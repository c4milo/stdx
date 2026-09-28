/* yyjson 0.13.0 as a bench-json baseline (decision 27), through its documented API alone
 * (doc/API.md): a document read with numbers kept as raw text, as stdx's decoder keeps them, and
 * every value walked; and a document built from the tokens and written into the caller's buffer.
 * Both allocate from a pool over the caller's buffer, so no allocation is timed. */
#include <stdbool.h>
#include <string.h>

#include "baselines.h"
#include "yyjson.h"

size_t stdx_bench_format_decimal(const stdx_bench_token *token, char *out) {
    char digits[24];
    size_t len = 0;
    if (token->negative) out[len++] = '-';
    size_t count = 0;
    uint64_t integer = token->integer;
    do {
        digits[count++] = (char)('0' + integer % 10);
        integer /= 10;
    } while (integer != 0);
    while (count > 0) out[len++] = digits[--count];
    out[len++] = '.';
    uint64_t fraction = token->fraction;
    for (size_t index = token->fraction_digits; index > 0; index--) {
        out[len + index - 1] = (char)('0' + fraction % 10);
        fraction /= 10;
    }
    return len + token->fraction_digits;
}

size_t stdx_bench_format_hex(const stdx_bench_token *token, char *out) {
    static const char digits[] = "0123456789abcdef";
    for (size_t index = 0; index < token->len; index++) {
        out[2 * index] = digits[token->octets[index] >> 4];
        out[2 * index + 1] = digits[token->octets[index] & 15];
    }
    return 2 * token->len;
}

size_t stdx_bench_yyjson_read_pool_len(size_t text_len) {
    return yyjson_read_max_memory_usage(text_len, YYJSON_READ_NUMBER_AS_RAW);
}

static int walk(yyjson_val *value, stdx_bench_tally *tally) {
    switch (yyjson_get_type(value)) {
    case YYJSON_TYPE_OBJ: {
        tally->containers++;
        yyjson_obj_iter iterator = yyjson_obj_iter_with(value);
        yyjson_val *key;
        while ((key = yyjson_obj_iter_next(&iterator))) {
            tally->strings++;
            tally->string_len += yyjson_get_len(key);
            if (walk(yyjson_obj_iter_get_val(key), tally)) return 1;
        }
        return 0;
    }
    case YYJSON_TYPE_ARR: {
        tally->containers++;
        yyjson_arr_iter iterator = yyjson_arr_iter_with(value);
        yyjson_val *element;
        while ((element = yyjson_arr_iter_next(&iterator))) {
            if (walk(element, tally)) return 1;
        }
        return 0;
    }
    case YYJSON_TYPE_STR:
        tally->strings++;
        tally->string_len += yyjson_get_len(value);
        return 0;
    case YYJSON_TYPE_RAW:
    case YYJSON_TYPE_NUM:
        tally->numbers++;
        return 0;
    case YYJSON_TYPE_BOOL:
    case YYJSON_TYPE_NULL:
        tally->literals++;
        return 0;
    default:
        return 1;
    }
}

int stdx_bench_yyjson_decode(const uint8_t *text, size_t len, uint8_t *pool, size_t pool_len,
                             stdx_bench_tally *tally) {
    yyjson_alc allocator;
    if (!yyjson_alc_pool_init(&allocator, pool, pool_len)) return 1;
    yyjson_doc *document = yyjson_read_opts((char *)text, len, YYJSON_READ_NUMBER_AS_RAW, &allocator, NULL);
    if (!document) return 1;
    int result = walk(yyjson_doc_get_root(document), tally);
    yyjson_doc_free(document);
    return result;
}

/* A number from its value, as yyjson's API builds numbers: it documents no raw text for a
 * document it builds. */
static yyjson_mut_val *number(yyjson_mut_doc *document, const stdx_bench_token *token) {
    if (!token->integral) return yyjson_mut_real(document, token->real);
    if (token->negative) return yyjson_mut_sint(document, -(int64_t)token->integer);
    return yyjson_mut_uint(document, token->integer);
}

static yyjson_mut_val *value(yyjson_mut_doc *document, const stdx_bench_token *token, char *scratch) {
    switch (token->kind) {
    case STDX_BENCH_STRING:
        return yyjson_mut_strn(document, (const char *)token->octets, token->len);
    case STDX_BENCH_HEX:
        return yyjson_mut_strncpy(document, scratch, stdx_bench_format_hex(token, scratch));
    case STDX_BENCH_NUMBER:
        return number(document, token);
    case STDX_BENCH_UNSIGNED:
        return yyjson_mut_uint(document, token->integer);
    case STDX_BENCH_SIGNED:
        return yyjson_mut_sint(document, (int64_t)token->integer);
    case STDX_BENCH_DECIMAL:
        return yyjson_mut_real(document, token->real);
    case STDX_BENCH_FALSE:
        return yyjson_mut_bool(document, false);
    case STDX_BENCH_TRUE:
        return yyjson_mut_bool(document, true);
    default:
        return yyjson_mut_null(document);
    }
}

/* Where the next value goes: the document's root, a member under the pending name, or an array's
 * element. */
static bool attach(yyjson_mut_doc *document, yyjson_mut_val **stack, size_t depth, yyjson_mut_val *key,
                   yyjson_mut_val *element) {
    if (!element) return false;
    if (depth == 0) {
        yyjson_mut_doc_set_root(document, element);
        return true;
    }
    yyjson_mut_val *parent = stack[depth - 1];
    if (yyjson_mut_is_obj(parent)) return yyjson_mut_obj_add(parent, key, element);
    return yyjson_mut_arr_append(parent, element);
}

size_t stdx_bench_yyjson_encode(const stdx_bench_token *tokens, size_t count, uint8_t *out,
                                size_t out_len, uint8_t *pool, size_t pool_len, char *scratch) {
    yyjson_alc allocator;
    if (!yyjson_alc_pool_init(&allocator, pool, pool_len)) return 0;
    yyjson_mut_doc *document = yyjson_mut_doc_new(&allocator);
    if (!document) return 0;
    yyjson_mut_val *stack[STDX_BENCH_DEPTH_MAX];
    size_t depth = 0;
    yyjson_mut_val *key = NULL;
    bool attached = true;
    for (size_t index = 0; index < count && attached; index++) {
        const stdx_bench_token *token = &tokens[index];
        switch (token->kind) {
        case STDX_BENCH_BEGIN_OBJECT:
        case STDX_BENCH_BEGIN_ARRAY: {
            yyjson_mut_val *container = token->kind == STDX_BENCH_BEGIN_OBJECT ? yyjson_mut_obj(document) : yyjson_mut_arr(document);
            attached = depth < STDX_BENCH_DEPTH_MAX && attach(document, stack, depth, key, container);
            if (attached) stack[depth++] = container;
            break;
        }
        case STDX_BENCH_END_OBJECT:
        case STDX_BENCH_END_ARRAY:
            depth--;
            break;
        case STDX_BENCH_NAME:
            key = yyjson_mut_strn(document, (const char *)token->octets, token->len);
            break;
        default:
            attached = attach(document, stack, depth, key, value(document, token, scratch));
            break;
        }
    }
    size_t written = attached ? yyjson_mut_write_buf((char *)out, out_len, document, YYJSON_WRITE_NOFLAG, NULL) : 0;
    yyjson_mut_doc_free(document);
    return written;
}
