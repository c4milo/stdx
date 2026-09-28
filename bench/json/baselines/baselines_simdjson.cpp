// simdjson 4.6.11 as a bench-json baseline (decision 27), through its documented API alone
// (doc/basics.md, doc/builder.md), with error codes and no exceptions. Decoding iterates each text
// with On-Demand, the API simdjson recommends, and walks every value: names and strings unescaped,
// numbers parsed and so checked, literals checked, and the text's end checked. Encoding writes each
// text with the string builder, placing the separators, and checks its UTF-8 at the end, as stdx's
// encoder checks every string.
#include <cstring>
#include <new>
#include <string_view>
#include <utility>

#include "baselines.h"
#include "simdjson.h"

using simdjson::ondemand::json_type;

namespace {

// Each walk takes an `ondemand::value` or an `ondemand::document`: both document `type()`,
// `get_array()`, `get_object()` and the scalars' getters.
template <typename Source>
int walk(Source &source, stdx_bench_tally *tally);

template <typename Source>
int walk_array(Source &source, stdx_bench_tally *tally) {
    simdjson::ondemand::array array;
    if (source.get_array().get(array)) return 1;
    tally->containers++;
    for (auto element : array) {
        simdjson::ondemand::value child;
        if (std::move(element).get(child)) return 1;
        if (walk(child, tally)) return 1;
    }
    return 0;
}

template <typename Source>
int walk_object(Source &source, stdx_bench_tally *tally) {
    simdjson::ondemand::object object;
    if (source.get_object().get(object)) return 1;
    tally->containers++;
    for (auto result : object) {
        simdjson::ondemand::field field;
        if (std::move(result).get(field)) return 1;
        std::string_view key;
        if (field.unescaped_key().get(key)) return 1;
        tally->strings++;
        tally->string_len += key.size();
        if (walk(field.value(), tally)) return 1;
    }
    return 0;
}

template <typename Source>
int walk_scalar(Source &source, json_type type, stdx_bench_tally *tally) {
    switch (type) {
    case json_type::string: {
        std::string_view string;
        if (source.get_string().get(string)) return 1;
        tally->strings++;
        tally->string_len += string.size();
        return 0;
    }
    case json_type::number: {
        simdjson::ondemand::number number;
        if (source.get_number().get(number)) return 1;
        tally->numbers++;
        return 0;
    }
    case json_type::boolean: {
        bool boolean;
        if (source.get_bool().get(boolean)) return 1;
        tally->literals++;
        return 0;
    }
    case json_type::null: {
        bool is_null;
        if (source.is_null().get(is_null) || !is_null) return 1;
        tally->literals++;
        return 0;
    }
    default:
        return 1;
    }
}

template <typename Source>
int walk(Source &source, stdx_bench_tally *tally) {
    json_type type;
    if (source.type().get(type)) return 1;
    if (type == json_type::array) return walk_array(source, tally);
    if (type == json_type::object) return walk_object(source, tally);
    return walk_scalar(source, type, tally);
}

// Writes the comma a value or a name needs after the one before it in its container.
struct Separators {
    bool first[STDX_BENCH_DEPTH_MAX + 1];
    size_t depth;

    void open() {
        first[++depth] = true;
    }
    void element(simdjson::builder::string_builder &builder) {
        if (!first[depth]) builder.append_comma();
        first[depth] = false;
    }
};

}  // namespace

extern "C" {

int stdx_bench_simdjson_built(void) {
    return 1;
}

void *stdx_bench_simdjson_parser_new(void) {
    return new (std::nothrow) simdjson::ondemand::parser();
}

void stdx_bench_simdjson_parser_free(void *parser) {
    delete static_cast<simdjson::ondemand::parser *>(parser);
}

size_t stdx_bench_simdjson_padding(void) {
    return simdjson::SIMDJSON_PADDING;
}

int stdx_bench_simdjson_decode(void *parser, const uint8_t *text, size_t len, size_t capacity,
                               stdx_bench_tally *tally) {
    auto &on_demand = *static_cast<simdjson::ondemand::parser *>(parser);
    simdjson::padded_string_view view(reinterpret_cast<const char *>(text), len, capacity);
    simdjson::ondemand::document document;
    if (on_demand.iterate(view).get(document)) return 1;
    if (walk(document, tally)) return 1;
    return document.at_end() ? 0 : 1;
}

void *stdx_bench_simdjson_builder_new(size_t capacity) {
    return new (std::nothrow) simdjson::builder::string_builder(capacity);
}

void stdx_bench_simdjson_builder_free(void *builder) {
    delete static_cast<simdjson::builder::string_builder *>(builder);
}

size_t stdx_bench_simdjson_encode(void *builder_pointer, const stdx_bench_token *tokens, size_t count,
                                  char *scratch) {
    auto &builder = *static_cast<simdjson::builder::string_builder *>(builder_pointer);
    builder.clear();
    Separators separators;
    separators.first[0] = true;
    separators.depth = 0;
    bool after_name = false;
    for (size_t index = 0; index < count; index++) {
        const stdx_bench_token &token = tokens[index];
        if (token.kind == STDX_BENCH_END_OBJECT || token.kind == STDX_BENCH_END_ARRAY) {
            separators.depth--;
            if (token.kind == STDX_BENCH_END_OBJECT) builder.end_object();
            else builder.end_array();
            continue;
        }
        if (!after_name) separators.element(builder);
        after_name = token.kind == STDX_BENCH_NAME;
        std::string_view octets(reinterpret_cast<const char *>(token.octets), token.len);
        switch (token.kind) {
        case STDX_BENCH_BEGIN_OBJECT:
            builder.start_object();
            separators.open();
            break;
        case STDX_BENCH_BEGIN_ARRAY:
            builder.start_array();
            separators.open();
            break;
        case STDX_BENCH_NAME:
            builder.escape_and_append_with_quotes(octets);
            builder.append_colon();
            break;
        case STDX_BENCH_STRING:
            builder.escape_and_append_with_quotes(octets);
            break;
        case STDX_BENCH_HEX:
            builder.append('"');
            builder.append_raw(std::string_view(scratch, stdx_bench_format_hex(&token, scratch)));
            builder.append('"');
            break;
        case STDX_BENCH_NUMBER:
            builder.append_raw(octets);
            break;
        case STDX_BENCH_UNSIGNED:
            builder.append(token.integer);
            break;
        case STDX_BENCH_SIGNED:
            builder.append(static_cast<int64_t>(token.integer));
            break;
        case STDX_BENCH_DECIMAL:
            builder.append_raw(std::string_view(scratch, stdx_bench_format_decimal(&token, scratch)));
            break;
        case STDX_BENCH_FALSE:
            builder.append(false);
            break;
        case STDX_BENCH_TRUE:
            builder.append(true);
            break;
        default:
            builder.append_null();
            break;
        }
    }
    if (!builder.validate_unicode()) return 0;
    std::string_view text;
    if (builder.view().get(text)) return 0;
    return text.size();
}

size_t stdx_bench_simdjson_copy(void *builder_pointer, uint8_t *out, size_t out_len) {
    auto &builder = *static_cast<simdjson::builder::string_builder *>(builder_pointer);
    std::string_view text;
    if (builder.view().get(text) || text.size() > out_len) return 0;
    std::memcpy(out, text.data(), text.size());
    return text.size();
}

}  // extern "C"
