// The baselines of decision 8 that are not also oracles, behind one C interface that
// bench/baselines/baselines.zig declares: libdeflate through libdeflate.h and zlib-ng through
// zlib-ng.h, their public headers alone. Nobody working on stdx reads either implementation
// (decision 9).
//
// This file is compiled in bench/ only, never into the library (invariant 14).

#include <stddef.h>
#include <stdint.h>

#include "libdeflate.h"
#include "zlib-ng.h"

uint32_t baseline_libdeflate_crc32(uint32_t crc, const uint8_t* input, size_t input_len) {
  return libdeflate_crc32(crc, input, input_len);
}

uint32_t baseline_libdeflate_adler32(uint32_t adler, const uint8_t* input, size_t input_len) {
  return libdeflate_adler32(adler, input, input_len);
}

uint32_t baseline_zlib_ng_crc32(uint32_t crc, const uint8_t* input, size_t input_len) {
  return zng_crc32_z(crc, input, input_len);
}

uint32_t baseline_zlib_ng_adler32(uint32_t adler, const uint8_t* input, size_t input_len) {
  return zng_adler32_z(adler, input, input_len);
}
