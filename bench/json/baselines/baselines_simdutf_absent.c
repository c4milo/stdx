/* simdutf's bindings where the host cannot build C++, as baselines_simdjson_absent.c: bench-json
 * then reports simdutf as not built, and its numbers come from the Linux runners alone (decision
 * 10). */
#include "baselines.h"

int stdx_bench_simdutf_built(void) { return 0; }
int stdx_bench_simdutf_validate_utf8(const uint8_t *octets, size_t len) {
    (void)octets, (void)len;
    return 0;
}
