// The brotli oracle of decision 8, Google's brotli, behind the C interface tools/oracle/oracle.zig
// declares. It calls Google's brotli through the functions its public headers, decode.h and
// encode.h, document alone. Nobody working on stdx reads Google's implementation (decision 9).
//
// This file is compiled in tools/ and bench/ only, never into the library (invariant 14).

#include <stddef.h>
#include <stdint.h>

#include <brotli/decode.h>
#include <brotli/encode.h>

// The verdicts of tools/oracle/oracle.zig's `Verdict`.
enum {
  ORACLE_BROTLI_OK = 0,
  ORACLE_BROTLI_REFUSED = 1,
  ORACLE_BROTLI_INCOMPLETE = 2,
  ORACLE_BROTLI_NO_ROOM = 3,
  ORACLE_BROTLI_FAILED = 4,
};

typedef struct {
  int verdict;
  size_t consumed;
  size_t written;
} oracle_brotli_result;

// The most octets Google's encoder writes for `input_len` octets.
size_t oracle_brotli_bound(size_t input_len) { return BrotliEncoderMaxCompressedSize(input_len); }

// Sets the encoder's parameters: quality 0 to 11, the window's WBITS, the large window of RFC 9841
// when `large_window` is nonzero, and NPOSTFIX and NDIRECT where each is not negative. Returns
// nonzero when the encoder took every one.
static int set_parameters(BrotliEncoderState* state, int quality, int window_bits, int large_window,
                          int postfix_bits, int direct_count, size_t input_len) {
  int ok = BrotliEncoderSetParameter(state, BROTLI_PARAM_QUALITY, (uint32_t)quality) &&
           BrotliEncoderSetParameter(state, BROTLI_PARAM_LGWIN, (uint32_t)window_bits) &&
           BrotliEncoderSetParameter(state, BROTLI_PARAM_LARGE_WINDOW, (uint32_t)large_window) &&
           BrotliEncoderSetParameter(state, BROTLI_PARAM_SIZE_HINT, (uint32_t)input_len);
  if (ok && postfix_bits >= 0) {
    ok = BrotliEncoderSetParameter(state, BROTLI_PARAM_NPOSTFIX, (uint32_t)postfix_bits);
  }
  if (ok && direct_count >= 0) {
    ok = BrotliEncoderSetParameter(state, BROTLI_PARAM_NDIRECT, (uint32_t)direct_count);
  }
  return ok;
}

// Runs one operation over `piece` octets until the encoder has taken them and, for a flush, written
// all it holds, or, for the finish, ended the stream. Returns nonzero on success.
static int encode_piece(BrotliEncoderState* state, BrotliEncoderOperation operation,
                        const uint8_t* piece, size_t piece_len, uint8_t** next_out,
                        size_t* available_out) {
  size_t available_in = piece_len;
  const uint8_t* next_in = piece;
  // Each call takes input or writes output until the operation completes; the octets on either
  // side bound the calls.
  for (size_t call = 0; call <= piece_len + *available_out + 2; call++) {
    if (!BrotliEncoderCompressStream(state, operation, &available_in, &next_in, available_out,
                                     next_out, NULL)) {
      return 0;
    }
    if (operation == BROTLI_OPERATION_FINISH && BrotliEncoderIsFinished(state)) return 1;
    if (operation != BROTLI_OPERATION_FINISH && available_in == 0 &&
        !BrotliEncoderHasMoreOutput(state)) {
      return 1;
    }
    if (*available_out == 0) return 0;
  }
  return 0;
}

// Encodes `input` into `output` as one stream, with a flush after every `flush_every` octets (0 for
// none), each of which ends a meta-block. Returns the octets written, or SIZE_MAX when Google's
// encoder failed or `output` had no room.
size_t oracle_brotli_encode(int quality, int window_bits, int large_window, int postfix_bits,
                            int direct_count, size_t flush_every, const uint8_t* input,
                            size_t input_len, uint8_t* output, size_t output_len) {
  BrotliEncoderState* state = BrotliEncoderCreateInstance(NULL, NULL, NULL);
  if (state == NULL) return SIZE_MAX;
  int ok = set_parameters(state, quality, window_bits, large_window, postfix_bits, direct_count,
                          input_len);
  uint8_t* next_out = output;
  size_t available_out = output_len;
  size_t offset = 0;
  while (ok) {
    size_t piece_len = input_len - offset;
    BrotliEncoderOperation operation = BROTLI_OPERATION_FINISH;
    if (flush_every > 0 && piece_len > flush_every) {
      piece_len = flush_every;
      operation = BROTLI_OPERATION_FLUSH;
    }
    ok = encode_piece(state, operation, input + offset, piece_len, &next_out, &available_out);
    offset += piece_len;
    if (operation == BROTLI_OPERATION_FINISH) break;
  }
  BrotliEncoderDestroyInstance(state);
  return ok ? output_len - available_out : SIZE_MAX;
}

// Google's verdict on `input` through its streaming decoder, given all of the input and all of the
// output at once: the stream ended, it refused the input, it needs more input, or more room.
oracle_brotli_result oracle_brotli_decode_verdict(const uint8_t* input, size_t input_len,
                                                  uint8_t* output, size_t output_len) {
  oracle_brotli_result result = {ORACLE_BROTLI_FAILED, 0, 0};
  BrotliDecoderState* state = BrotliDecoderCreateInstance(NULL, NULL, NULL);
  if (state == NULL) return result;
  size_t available_in = input_len;
  const uint8_t* next_in = input;
  size_t available_out = output_len;
  uint8_t* next_out = output;
  BrotliDecoderResult status =
      BrotliDecoderDecompressStream(state, &available_in, &next_in, &available_out, &next_out, NULL);
  switch (status) {
    case BROTLI_DECODER_RESULT_SUCCESS:
      result.verdict = ORACLE_BROTLI_OK;
      break;
    case BROTLI_DECODER_RESULT_NEEDS_MORE_INPUT:
      result.verdict = ORACLE_BROTLI_INCOMPLETE;
      break;
    case BROTLI_DECODER_RESULT_NEEDS_MORE_OUTPUT:
      result.verdict = ORACLE_BROTLI_NO_ROOM;
      break;
    default:
      result.verdict = ORACLE_BROTLI_REFUSED;
      break;
  }
  result.consumed = input_len - available_in;
  result.written = output_len - available_out;
  BrotliDecoderDestroyInstance(state);
  return result;
}
