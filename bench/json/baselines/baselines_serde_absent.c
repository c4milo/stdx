/* serde_json's bindings where the host has no cargo to build them (build/oracle_json.zig):
 * bench-json then reports serde_json as not built. */
#include "baselines.h"

int stdx_bench_serde_built(void) { return 0; }
int stdx_bench_serde_decode(const uint8_t *text, size_t len, stdx_bench_tally *tally) {
    (void)text, (void)len, (void)tally;
    return 1;
}
size_t stdx_bench_serde_encode(const stdx_bench_token *tokens, size_t count, uint8_t *out,
                               size_t out_len, char *scratch) {
    (void)tokens, (void)count, (void)out, (void)out_len, (void)scratch;
    return 0;
}
void *stdx_bench_serde_typed_new(void) { return 0; }
int stdx_bench_serde_typed_add(void *typed, const stdx_bench_token *tokens, size_t len) {
    (void)typed, (void)tokens, (void)len;
    return 1;
}
size_t stdx_bench_serde_typed_encode(const void *typed, uint8_t *out, size_t out_len) {
    (void)typed, (void)out, (void)out_len;
    return 0;
}
void stdx_bench_serde_typed_free(void *typed) { (void)typed; }
