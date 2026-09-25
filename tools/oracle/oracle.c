// The oracles of decision 8, behind one C interface that tools/oracle/oracle.zig declares.
//
// Each function takes the whole input and the whole output room and returns what the oracle did
// with them: a verdict, the octets it consumed, and the octets it wrote. The functions call each
// oracle through its public API alone: zlib through the calls zlib.h documents, and Wuffs through
// the declarations of its public header section. Nobody working on stdx reads either oracle's
// implementation (decision 9).
//
// This file is compiled in tools/ and bench/ only, never into the library (invariant 14).

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "zlib.h"

#define WUFFS_IMPLEMENTATION
#define WUFFS_CONFIG__MODULES
#define WUFFS_CONFIG__MODULE__BASE
#define WUFFS_CONFIG__MODULE__ADLER32
#define WUFFS_CONFIG__MODULE__CRC32
#define WUFFS_CONFIG__MODULE__DEFLATE
#define WUFFS_CONFIG__MODULE__GZIP
#define WUFFS_CONFIG__MODULE__ZLIB
#include "wuffs-v0.4.c"

// The containers, in the order tools/oracle/oracle.zig's `Container` names them.
enum { ORACLE_RAW = 0, ORACLE_ZLIB = 1, ORACLE_GZIP = 2 };

// The verdicts, in the order tools/oracle/oracle.zig's `Verdict` names them.
enum {
  ORACLE_OK = 0,          // the stream ended and every check passed
  ORACLE_REFUSED = 1,     // the oracle refused the input
  ORACLE_INCOMPLETE = 2,  // the input ended before the stream did
  ORACLE_NO_ROOM = 3,     // the output filled before the stream ended
  ORACLE_FAILED = 4,      // the oracle could not run: an allocation or an argument failed
};

typedef struct {
  int verdict;
  size_t consumed;
  size_t written;
} oracle_result;

// zlib's windowBits for a container: negative for raw DEFLATE, plus 16 for gzip (zlib.h,
// deflateInit2 and inflateInit2).
static int zlib_window_bits(int container, int window_bits) {
  if (container == ORACLE_RAW) return -window_bits;
  if (container == ORACLE_GZIP) return window_bits + 16;
  return window_bits;
}

size_t oracle_zlib_bound(int container, size_t input_len) {
  // deflateBound needs a stream set up with the same parameters, so the bound is computed with
  // the largest overhead any level or strategy adds.
  z_stream stream;
  memset(&stream, 0, sizeof stream);
  if (deflateInit2(&stream, Z_BEST_COMPRESSION, Z_DEFLATED, zlib_window_bits(container, 9), 1,
                   Z_DEFAULT_STRATEGY) != Z_OK) {
    return 0;
  }
  size_t bound = deflateBound(&stream, (uLong)input_len);
  deflateEnd(&stream);
  // A gzip header carries no name here, but a margin covers every strategy's stored blocks.
  return bound + 64;
}

oracle_result oracle_zlib_encode(int container, int level, int strategy, int window_bits,
                                 int mem_level, const uint8_t* input, size_t input_len,
                                 uint8_t* output, size_t output_len) {
  oracle_result result = {ORACLE_FAILED, 0, 0};
  z_stream stream;
  memset(&stream, 0, sizeof stream);
  int status = deflateInit2(&stream, level, Z_DEFLATED, zlib_window_bits(container, window_bits),
                            mem_level, strategy);
  if (status != Z_OK) return result;
  stream.next_in = (Bytef*)input;
  stream.avail_in = (uInt)input_len;
  stream.next_out = output;
  stream.avail_out = (uInt)output_len;
  status = deflate(&stream, Z_FINISH);
  result.consumed = stream.total_in;
  result.written = stream.total_out;
  result.verdict = (status == Z_STREAM_END) ? ORACLE_OK : ORACLE_NO_ROOM;
  deflateEnd(&stream);
  return result;
}

oracle_result oracle_zlib_decode(int container, const uint8_t* input, size_t input_len,
                                 uint8_t* output, size_t output_len) {
  oracle_result result = {ORACLE_FAILED, 0, 0};
  z_stream stream;
  memset(&stream, 0, sizeof stream);
  if (inflateInit2(&stream, zlib_window_bits(container, 15)) != Z_OK) return result;
  stream.next_in = (Bytef*)input;
  stream.avail_in = (uInt)input_len;
  stream.next_out = output;
  stream.avail_out = (uInt)output_len;
  int status = inflate(&stream, Z_FINISH);
  result.consumed = stream.total_in;
  result.written = stream.total_out;
  if (status == Z_STREAM_END) {
    result.verdict = ORACLE_OK;
  } else if (status == Z_DATA_ERROR || status == Z_NEED_DICT || status == Z_STREAM_ERROR) {
    result.verdict = ORACLE_REFUSED;
  } else if (stream.avail_out == 0) {
    result.verdict = ORACLE_NO_ROOM;
  } else {
    result.verdict = ORACLE_INCOMPLETE;
  }
  inflateEnd(&stream);
  return result;
}

// One Wuffs decode of a whole input, for the decoder type the macro arguments name.
#define WUFFS_DECODE(prefix, input, input_len, output, output_len, result)                     \
  do {                                                                                       \
    prefix##__decoder* decoder = (prefix##__decoder*)malloc(sizeof__##prefix##__decoder()); \
    if (decoder == NULL) break;                                                              \
    wuffs_base__status status = prefix##__decoder__initialize(                               \
        decoder, sizeof__##prefix##__decoder(), WUFFS_VERSION,                               \
        WUFFS_INITIALIZE__DEFAULT_OPTIONS);                                                  \
    if (!wuffs_base__status__is_ok(&status)) {                                               \
      free(decoder);                                                                         \
      break;                                                                                 \
    }                                                                                        \
    wuffs_base__range_ii_u64 range = prefix##__decoder__workbuf_len(decoder);                \
    size_t workbuf_len = (size_t)range.max_incl;                                             \
    uint8_t* workbuf = (uint8_t*)malloc(workbuf_len > 0 ? workbuf_len : 1);                  \
    if (workbuf == NULL) {                                                                   \
      free(decoder);                                                                         \
      break;                                                                                 \
    }                                                                                        \
    wuffs_base__io_buffer dst = wuffs_base__ptr_u8__writer(output, output_len);              \
    wuffs_base__io_buffer src =                                                              \
        wuffs_base__ptr_u8__reader((uint8_t*)input, input_len, true);                        \
    status = prefix##__decoder__transform_io(decoder, &dst, &src,                            \
                                             wuffs_base__make_slice_u8(workbuf, workbuf_len)); \
    (result).consumed = src.meta.ri;                                                         \
    (result).written = dst.meta.wi;                                                          \
    if (wuffs_base__status__is_ok(&status)) {                                                \
      (result).verdict = ORACLE_OK;                                                          \
    } else if (status.repr == wuffs_base__suspension__short_write) {                         \
      (result).verdict = ORACLE_NO_ROOM;                                                     \
    } else if (status.repr == wuffs_base__suspension__short_read) {                          \
      (result).verdict = ORACLE_INCOMPLETE;                                                  \
    } else {                                                                                 \
      (result).verdict = ORACLE_REFUSED;                                                     \
    }                                                                                        \
    free(workbuf);                                                                           \
    free(decoder);                                                                           \
  } while (0)

oracle_result oracle_wuffs_decode(int container, const uint8_t* input, size_t input_len,
                                  uint8_t* output, size_t output_len) {
  oracle_result result = {ORACLE_FAILED, 0, 0};
  if (container == ORACLE_RAW) {
    WUFFS_DECODE(wuffs_deflate, input, input_len, output, output_len, result);
  } else if (container == ORACLE_ZLIB) {
    WUFFS_DECODE(wuffs_zlib, input, input_len, output, output_len, result);
  } else if (container == ORACLE_GZIP) {
    WUFFS_DECODE(wuffs_gzip, input, input_len, output, output_len, result);
  }
  return result;
}

// The checksums of zlib and Wuffs, for the differential check and the benchmark of design §8 step
// 4: zlib through zlib.h's crc32_z and adler32_z, Wuffs through its hashers. A Wuffs hasher starts
// from the value of no octets, 0 for CRC-32 and 1 for Adler-32, so its calls take no start. A
// hasher that fails to initialize gives 0, which the check then reports as a disagreement.

uint32_t oracle_zlib_crc32(uint32_t crc, const uint8_t* input, size_t input_len) {
  return (uint32_t)crc32_z(crc, input, input_len);
}

uint32_t oracle_zlib_adler32(uint32_t adler, const uint8_t* input, size_t input_len) {
  return (uint32_t)adler32_z(adler, input, input_len);
}

uint32_t oracle_wuffs_crc32(const uint8_t* input, size_t input_len) {
  wuffs_crc32__ieee_hasher hasher;
  wuffs_base__status status = wuffs_crc32__ieee_hasher__initialize(
      &hasher, sizeof hasher, WUFFS_VERSION, WUFFS_INITIALIZE__DEFAULT_OPTIONS);
  if (!wuffs_base__status__is_ok(&status)) return 0;
  return wuffs_crc32__ieee_hasher__update_u32(&hasher,
                                              wuffs_base__make_slice_u8((uint8_t*)input, input_len));
}

uint32_t oracle_wuffs_adler32(const uint8_t* input, size_t input_len) {
  wuffs_adler32__hasher hasher;
  wuffs_base__status status = wuffs_adler32__hasher__initialize(
      &hasher, sizeof hasher, WUFFS_VERSION, WUFFS_INITIALIZE__DEFAULT_OPTIONS);
  if (!wuffs_base__status__is_ok(&status)) return 0;
  return wuffs_adler32__hasher__update_u32(&hasher,
                                           wuffs_base__make_slice_u8((uint8_t*)input, input_len));
}
