// simdutf 9.2.1 as the UTF-8 check's baseline in bench-json (decision 38), through its documented
// API alone: validate_utf8 over a buffer, which stdx's `is_utf8` runs beside. simdutf picks its
// kernel at run time, as simdjson does.
#include "baselines.h"
#include "simdutf.h"

extern "C" int stdx_bench_simdutf_built(void) { return 1; }

extern "C" int stdx_bench_simdutf_validate_utf8(const uint8_t *octets, size_t len) {
    return simdutf::validate_utf8(reinterpret_cast<const char *>(octets), len) ? 1 : 0;
}
