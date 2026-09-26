// The Zstandard oracle of decision 8, libzstd, behind the C interface tools/oracle/oracle.zig
// declares. It calls libzstd through the functions zstd.h documents alone. Nobody working on stdx
// reads libzstd's implementation (decision 9).
//
// This file is compiled in tools/ and bench/ only, never into the library (invariant 14).

#include <stddef.h>
#include <stdint.h>

#include "zstd.h"

// The level of the frames the checksum oracle writes: the fastest, as the content checksum does
// not depend on it.
enum { ORACLE_ZSTD_CHECKSUM_LEVEL = 1 };

// The octets of a frame's Content_Checksum, the last of the frame (RFC 8878 §3.1.1).
enum { ORACLE_ZSTD_CONTENT_CHECKSUM_LEN = 4 };

// The most octets one libzstd frame of `input_len` octets takes.
size_t oracle_zstd_bound(size_t input_len) { return ZSTD_compressBound(input_len); }

// Compresses `input` into `frame` as one frame with its content checksum on, and stores that
// Content_Checksum in `checksum`: the frame's last 4 octets, least significant first, which RFC
// 8878 §3.1.1 defines as the low 32 bits of XXH64 of the content with seed 0. Returns 0, or -1 when
// libzstd failed or `frame` had no room.
int oracle_zstd_content_checksum(const uint8_t* input, size_t input_len, uint8_t* frame,
                                 size_t frame_len, uint32_t* checksum) {
  ZSTD_CCtx* context = ZSTD_createCCtx();
  if (context == NULL) return -1;
  size_t result = ZSTD_CCtx_setParameter(context, ZSTD_c_compressionLevel,
                                         ORACLE_ZSTD_CHECKSUM_LEVEL);
  if (!ZSTD_isError(result)) result = ZSTD_CCtx_setParameter(context, ZSTD_c_checksumFlag, 1);
  if (!ZSTD_isError(result)) result = ZSTD_compress2(context, frame, frame_len, input, input_len);
  ZSTD_freeCCtx(context);
  if (ZSTD_isError(result) || result < ORACLE_ZSTD_CONTENT_CHECKSUM_LEN) return -1;
  const uint8_t* octets = frame + result - ORACLE_ZSTD_CONTENT_CHECKSUM_LEN;
  // Least significant octet first (RFC 8878 §3.1.1).
  *checksum = (uint32_t)octets[0] | (uint32_t)octets[1] << 8 | (uint32_t)octets[2] << 16 |
              (uint32_t)octets[3] << 24;
  return 0;
}
