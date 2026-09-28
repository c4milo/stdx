/* What bench-json's baselines and stdx share across the C ABI (decision 27). The layout is
 * baselines_abi.zig's, which the Zig side reads. */
#ifndef STDX_BENCH_BASELINES_H
#define STDX_BENCH_BASELINES_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* What a decode of a text found, counted the same way by every candidate. */
typedef struct {
    uint64_t containers;
    uint64_t strings;
    uint64_t string_len;
    uint64_t numbers;
    uint64_t literals;
} stdx_bench_tally;

enum {
    STDX_BENCH_BEGIN_OBJECT,
    STDX_BENCH_END_OBJECT,
    STDX_BENCH_BEGIN_ARRAY,
    STDX_BENCH_END_ARRAY,
    STDX_BENCH_NAME,
    STDX_BENCH_STRING,
    STDX_BENCH_HEX,
    STDX_BENCH_NUMBER,
    STDX_BENCH_UNSIGNED,
    STDX_BENCH_SIGNED,
    STDX_BENCH_DECIMAL,
    STDX_BENCH_FALSE,
    STDX_BENCH_TRUE,
    STDX_BENCH_NULL,
};

/* One token of a text to encode. */
typedef struct {
    uint8_t kind;
    uint8_t fraction_digits;
    uint8_t negative;
    uint8_t integral;
    const uint8_t *octets;
    size_t len;
    uint64_t integer;
    uint64_t fraction;
    double real;
} stdx_bench_token;

/* The deepest nesting any workload holds, for the encoders' container stacks. */
#define STDX_BENCH_DEPTH_MAX 1024

/* Writes the fixed-point decimal of `token` into `out`, which holds at least 48 octets, and
 * returns its length: the integer part, a point, and the fraction with `fraction_digits` digits. */
size_t stdx_bench_format_decimal(const stdx_bench_token *token, char *out);

/* Writes two lowercase hex digits for each octet of `token` into `out`, and returns 2 * len. */
size_t stdx_bench_format_hex(const stdx_bench_token *token, char *out);

/* 1 where simdjson's bindings are built, and 0 where they are absent. */
int stdx_bench_simdjson_built(void);
void *stdx_bench_simdjson_parser_new(void);
void stdx_bench_simdjson_parser_free(void *parser);
size_t stdx_bench_simdjson_padding(void);
/* 0 when the text, `len` octets with `capacity` octets readable, is valid JSON walked whole. */
int stdx_bench_simdjson_decode(void *parser, const uint8_t *text, size_t len, size_t capacity,
                               stdx_bench_tally *tally);
void *stdx_bench_simdjson_builder_new(size_t capacity);
void stdx_bench_simdjson_builder_free(void *builder);
/* The length of the text the builder holds, or 0 when a string is not UTF-8. */
size_t stdx_bench_simdjson_encode(void *builder, const stdx_bench_token *tokens, size_t count,
                                  char *scratch);
size_t stdx_bench_simdjson_copy(void *builder, uint8_t *out, size_t out_len);

size_t stdx_bench_yyjson_read_pool_len(size_t text_len);
int stdx_bench_yyjson_decode(const uint8_t *text, size_t len, uint8_t *pool, size_t pool_len,
                             stdx_bench_tally *tally);
/* The octets written into `out`, or 0 on failure. */
size_t stdx_bench_yyjson_encode(const stdx_bench_token *tokens, size_t count, uint8_t *out,
                                size_t out_len, uint8_t *pool, size_t pool_len, char *scratch);

#ifdef __cplusplus
}
#endif

#endif
