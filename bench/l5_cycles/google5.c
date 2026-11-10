// google <input file> <rounds>: encodes the file with Google's brotli at quality 5, WBITS 22, as
// bench-brotli's level 1 table pairs it, `rounds` times; prints the octets written and read.
// For callgrind counts beside stdx's harness. Built by google.sh; never part of stdx.
#include <brotli/encode.h>
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char** argv) {
  FILE* f = fopen(argv[1], "rb");
  fseek(f, 0, SEEK_END);
  long len = ftell(f);
  fseek(f, 0, SEEK_SET);
  unsigned char* in = malloc(len);
  fread(in, 1, len, f);
  fclose(f);
  int rounds = atoi(argv[2]);
  size_t bound = BrotliEncoderMaxCompressedSize(len);
  unsigned char* out = malloc(bound);
  size_t written = 0, read = 0;
  for (int r = 0; r < rounds; r++) {
    size_t out_len = bound;
    BrotliEncoderCompress(5, 22, BROTLI_MODE_GENERIC, len, in, &out_len, out);
    written += out_len;
    read += len;
  }
  printf("%zu octets out of %zu in\n", written, read);
  return 0;
}
