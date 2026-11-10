/* Go's jsontext bindings where the host has no go to build them (build/oracle_json.zig):
 * bench-json then reports Go's jsontext as not built. */
#include "baselines.h"

int stdx_bench_go_built(void) { return 0; }
int stdx_bench_go_decode(const uint8_t *text, size_t len, stdx_bench_tally *tally) {
    (void)text, (void)len, (void)tally;
    return 1;
}
size_t stdx_bench_go_encode(const stdx_bench_token *tokens, size_t count, uint8_t *out,
                            size_t out_len) {
    (void)tokens, (void)count, (void)out, (void)out_len;
    return 0;
}
