// The baselines of decision 8 that are not also oracles, behind one C interface that
// bench/baselines/baselines.zig declares: libdeflate through libdeflate.h and zlib-ng through
// zlib-ng.h, their public headers alone. Nobody working on stdx reads either implementation
// (decision 9).
//
// This file is compiled in bench/ only, never into the library (invariant 14).

#include <stddef.h>
#include <stdint.h>
#include <string.h>

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

// One libdeflate decode of a whole gzip member into `output`. Returns the octets written, or
// SIZE_MAX when libdeflate refused the input or could not allocate its decompressor.
size_t baseline_libdeflate_gzip_decode(const uint8_t* input, size_t input_len, uint8_t* output,
                                       size_t output_len) {
  struct libdeflate_decompressor* decompressor = libdeflate_alloc_decompressor();
  if (decompressor == NULL) return SIZE_MAX;
  size_t written = 0;
  enum libdeflate_result result = libdeflate_gzip_decompress(decompressor, input, input_len,
                                                              output, output_len, &written);
  libdeflate_free_decompressor(decompressor);
  return result == LIBDEFLATE_SUCCESS ? written : SIZE_MAX;
}

// One zlib-ng decode of a whole gzip member into `output`, with windowBits 15 plus 16 for the
// gzip container (zlib-ng.h, zng_inflateInit2). Returns the octets written, or SIZE_MAX when
// zlib-ng refused the input or did not reach the member's end.
size_t baseline_zlib_ng_gzip_decode(const uint8_t* input, size_t input_len, uint8_t* output,
                                    size_t output_len) {
  zng_stream stream;
  memset(&stream, 0, sizeof stream);
  if (zng_inflateInit2(&stream, 15 + 16) != Z_OK) return SIZE_MAX;
  stream.next_in = input;
  stream.avail_in = (uint32_t)input_len;
  stream.next_out = output;
  stream.avail_out = (uint32_t)output_len;
  int status = zng_inflate(&stream, Z_FINISH);
  size_t written = stream.total_out;
  zng_inflateEnd(&stream);
  return status == Z_STREAM_END ? written : SIZE_MAX;
}

// One libdeflate encode of `input` as a gzip member at `level` (libdeflate.h,
// libdeflate_alloc_compressor). Returns the octets written, or SIZE_MAX when `output` was too
// small or libdeflate could not allocate its compressor.
size_t baseline_libdeflate_gzip_encode(int level, const uint8_t* input, size_t input_len,
                                       uint8_t* output, size_t output_len) {
  struct libdeflate_compressor* compressor = libdeflate_alloc_compressor(level);
  if (compressor == NULL) return SIZE_MAX;
  size_t written = libdeflate_gzip_compress(compressor, input, input_len, output, output_len);
  libdeflate_free_compressor(compressor);
  return written == 0 ? SIZE_MAX : written;
}

// The most octets libdeflate_gzip_compress writes for `input_len` octets at any level: a NULL
// compressor asks for that bound (libdeflate.h, libdeflate_deflate_compress_bound).
size_t baseline_libdeflate_gzip_bound(size_t input_len) {
  return libdeflate_gzip_compress_bound(NULL, input_len);
}

// One zlib-ng encode of `input` as a gzip member at `level`, with windowBits 15 plus 16 for the
// gzip container, memLevel 8 and the default strategy (zlib-ng.h, zng_deflateInit2). Returns the
// octets written, or SIZE_MAX when zlib-ng did not reach the member's end.
size_t baseline_zlib_ng_gzip_encode(int level, const uint8_t* input, size_t input_len,
                                    uint8_t* output, size_t output_len) {
  zng_stream stream;
  memset(&stream, 0, sizeof stream);
  if (zng_deflateInit2(&stream, level, Z_DEFLATED, 15 + 16, 8, Z_DEFAULT_STRATEGY) != Z_OK) {
    return SIZE_MAX;
  }
  stream.next_in = input;
  stream.avail_in = (uint32_t)input_len;
  stream.next_out = output;
  stream.avail_out = (uint32_t)output_len;
  int32_t status = zng_deflate(&stream, Z_FINISH);
  size_t written = stream.total_out;
  zng_deflateEnd(&stream);
  return status == Z_STREAM_END ? written : SIZE_MAX;
}
