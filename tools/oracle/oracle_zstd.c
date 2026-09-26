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

// libzstd carries xxHash's own implementation for its checksums, and its compiled library exports
// xxHash's one-shot XXH64 under libzstd's ZSTD_ prefix, as the library's symbol table shows. zstd.h
// does not declare it, so this does, with the interface xxHash documents: the octets, their length,
// and a 64-bit seed. Its binding's test checks it against libzstd's Content_Checksum.
unsigned long long ZSTD_XXH64(const void* input, size_t length, unsigned long long seed);

// libzstd's XXH64 of `input` from `seed`: every 64 bits, where a frame carries the low 32.
uint64_t oracle_zstd_xxh64(const uint8_t* input, size_t input_len, uint64_t seed) {
  return (uint64_t)ZSTD_XXH64(input, input_len, seed);
}

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

// The largest window libzstd decodes on a 64-bit host, 2^31 (zstd.h, ZSTD_WINDOWLOG_MAX_64), so its
// verdict on a frame never comes from a window limit stdx does not share.
enum { ORACLE_ZSTD_WINDOW_LOG_MAX = 31 };

// Compresses `input` into `output` as one frame at `level`, with `window_log` (0 keeps the level's
// own), and the checksum and content-size flags as given. Returns the frame's octets, or SIZE_MAX
// when libzstd failed or `output` had no room.
size_t oracle_zstd_encode(int level, int window_log, int with_checksum, int with_content_size,
                          const uint8_t* input, size_t input_len, uint8_t* output,
                          size_t output_len) {
  ZSTD_CCtx* context = ZSTD_createCCtx();
  if (context == NULL) return SIZE_MAX;
  size_t result = ZSTD_CCtx_setParameter(context, ZSTD_c_compressionLevel, level);
  if (!ZSTD_isError(result) && window_log != 0) {
    result = ZSTD_CCtx_setParameter(context, ZSTD_c_windowLog, window_log);
  }
  if (!ZSTD_isError(result)) result = ZSTD_CCtx_setParameter(context, ZSTD_c_checksumFlag, with_checksum);
  if (!ZSTD_isError(result)) {
    result = ZSTD_CCtx_setParameter(context, ZSTD_c_contentSizeFlag, with_content_size);
  }
  if (!ZSTD_isError(result)) result = ZSTD_compress2(context, output, output_len, input, input_len);
  ZSTD_freeCCtx(context);
  return ZSTD_isError(result) ? SIZE_MAX : result;
}

// Decodes every frame of `input`, skippable ones skipped, into `output`, with libzstd's largest
// window. Returns the octets written, or SIZE_MAX when libzstd refused the input or `output` had
// no room.
size_t oracle_zstd_decode(const uint8_t* input, size_t input_len, uint8_t* output,
                          size_t output_len) {
  ZSTD_DCtx* context = ZSTD_createDCtx();
  if (context == NULL) return SIZE_MAX;
  size_t result = ZSTD_DCtx_setParameter(context, ZSTD_d_windowLogMax, ORACLE_ZSTD_WINDOW_LOG_MAX);
  if (!ZSTD_isError(result)) result = ZSTD_decompressDCtx(context, output, output_len, input, input_len);
  ZSTD_freeDCtx(context);
  return ZSTD_isError(result) ? SIZE_MAX : result;
}

// The verdicts and the result, in the order and layout tools/oracle/oracle.zig's `Verdict` and
// `Result` give them, as tools/oracle/oracle.c defines them for zlib and Wuffs.
enum {
  ORACLE_ZSTD_OK = 0,          // the input ended where a frame did, and every check passed
  ORACLE_ZSTD_REFUSED = 1,     // libzstd refused the input
  ORACLE_ZSTD_INCOMPLETE = 2,  // the input ended inside a frame
  ORACLE_ZSTD_NO_ROOM = 3,     // the output filled before the frames ended
  ORACLE_ZSTD_FAILED = 4,      // libzstd could not run: an allocation or an argument failed
};

typedef struct {
  int verdict;
  size_t consumed;
  size_t written;
} oracle_zstd_result;

// The verdict after the calls ended: `status` is the last call's return, an error code or the
// hint, 0 once a frame has ended. A full output is no room even where the input ended too. Every
// error is a refusal: the streaming decoder writes into the caller's output as it has room, so
// its dstSize_tooSmall means a block past its own block buffer.
static int oracle_zstd_verdict(size_t status, const ZSTD_inBuffer* in, const ZSTD_outBuffer* out) {
  if (ZSTD_isError(status)) return ORACLE_ZSTD_REFUSED;
  if (in->pos == in->size && status == 0) return ORACLE_ZSTD_OK;
  if (out->pos == out->size) return ORACLE_ZSTD_NO_ROOM;
  return ORACLE_ZSTD_INCOMPLETE;
}

// Decodes every frame of `input`, skippable ones skipped, into `output` through libzstd's
// streaming decoder, which refuses a window past 2^`window_log_max`. The calls go on while they
// consume or write, one more than the input and the output can need. The verdict reads the last
// call that consumed or wrote: a call after a frame's end asks for the next frame's header.
oracle_zstd_result oracle_zstd_decode_verdict(const uint8_t* input, size_t input_len,
                                              uint8_t* output, size_t output_len,
                                              int window_log_max) {
  oracle_zstd_result result = {ORACLE_ZSTD_FAILED, 0, 0};
  ZSTD_DCtx* context = ZSTD_createDCtx();
  if (context == NULL) return result;
  size_t status = ZSTD_DCtx_setParameter(context, ZSTD_d_windowLogMax, window_log_max);
  if (ZSTD_isError(status)) {
    ZSTD_freeDCtx(context);
    return result;
  }
  ZSTD_inBuffer in = {input, input_len, 0};
  ZSTD_outBuffer out = {output, output_len, 0};
  // Nonzero: no frame has ended before the first call.
  status = 1;
  for (size_t call = 0; call <= input_len + output_len + 1; call++) {
    size_t consumed = in.pos;
    size_t written = out.pos;
    size_t call_status = ZSTD_decompressStream(context, &out, &in);
    if (ZSTD_isError(call_status)) {
      status = call_status;
      break;
    }
    if (in.pos == consumed && out.pos == written) break;
    status = call_status;
  }
  result.verdict = oracle_zstd_verdict(status, &in, &out);
  result.consumed = in.pos;
  result.written = out.pos;
  ZSTD_freeDCtx(context);
  return result;
}

// A decompression context kept across calls, as a server keeps one per connection or thread, so a
// benchmark times decoding and not the context's allocation.
ZSTD_DCtx* oracle_zstd_context_create(void) { return ZSTD_createDCtx(); }

void oracle_zstd_context_free(ZSTD_DCtx* context) { ZSTD_freeDCtx(context); }

// Decodes every frame of `input` into `output` with `context`, libzstd's one-shot path. Returns the
// octets written, or SIZE_MAX when libzstd refused the input or `output` had no room.
size_t oracle_zstd_decode_with(ZSTD_DCtx* context, const uint8_t* input, size_t input_len,
                               uint8_t* output, size_t output_len) {
  size_t result = ZSTD_decompressDCtx(context, output, output_len, input, input_len);
  return ZSTD_isError(result) ? SIZE_MAX : result;
}
