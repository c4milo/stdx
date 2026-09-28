/* simdjson's bindings where the host cannot build C++: Zig 0.16.0 does not build its libc++ for
 * macOS 26 (INFINITY undeclared in libcxx's random.cpp). bench-json then reports simdjson as not
 * built; its numbers come from the Linux runners alone (decision 10). */
#include "baselines.h"

int stdx_bench_simdjson_built(void) { return 0; }
void *stdx_bench_simdjson_parser_new(void) { return 0; }
void stdx_bench_simdjson_parser_free(void *parser) { (void)parser; }
size_t stdx_bench_simdjson_padding(void) { return 0; }
int stdx_bench_simdjson_decode(void *parser, const uint8_t *text, size_t len, size_t capacity,
                               stdx_bench_tally *tally) {
    (void)parser, (void)text, (void)len, (void)capacity, (void)tally;
    return 1;
}
void *stdx_bench_simdjson_builder_new(size_t capacity) {
    (void)capacity;
    return 0;
}
void stdx_bench_simdjson_builder_free(void *builder) { (void)builder; }
size_t stdx_bench_simdjson_encode(void *builder, const stdx_bench_token *tokens, size_t count,
                                  char *scratch) {
    (void)builder, (void)tokens, (void)count, (void)scratch;
    return 0;
}
size_t stdx_bench_simdjson_copy(void *builder, uint8_t *out, size_t out_len) {
    (void)builder, (void)out, (void)out_len;
    return 0;
}
