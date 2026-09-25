// The sample code of RFC 1952 §8 (CRC-32) and RFC 1950 §9 (Adler-32), as the differential check
// of design §8 step 4 compares stdx's checksums with it.
//
// The functions are the RFCs' own, copied from docs/rfcs/ with two changes: each is `static`, so
// no name reaches another object, and `buf` is `const`. The two exported wrappers at the end take
// a size_t length and hand the RFCs' `int` its pieces.
//
// This file is compiled in tools/ and bench/ only, never into the library (invariant 14).

#include <limits.h>
#include <stddef.h>
#include <stdint.h>

// RFC 1952 §8.

/* Table of CRCs of all 8-bit messages. */
static unsigned long crc_table[256];

/* Flag: has the table been computed? Initially false. */
static int crc_table_computed = 0;

/* Make the table for a fast CRC. */
static void make_crc_table(void)
{
  unsigned long c;
  int n, k;
  for (n = 0; n < 256; n++) {
    c = (unsigned long) n;
    for (k = 0; k < 8; k++) {
      if (c & 1) {
        c = 0xedb88320L ^ (c >> 1);
      } else {
        c = c >> 1;
      }
    }
    crc_table[n] = c;
  }
  crc_table_computed = 1;
}

static unsigned long update_crc(unsigned long crc,
                const unsigned char *buf, int len)
{
  unsigned long c = crc ^ 0xffffffffL;
  int n;

  if (!crc_table_computed)
    make_crc_table();
  for (n = 0; n < len; n++) {
    c = crc_table[(c ^ buf[n]) & 0xff] ^ (c >> 8);
  }
  return c ^ 0xffffffffL;
}

// RFC 1950 §9.

#define BASE 65521 /* largest prime smaller than 65536 */

static unsigned long update_adler32(unsigned long adler,
   const unsigned char *buf, int len)
{
  unsigned long s1 = adler & 0xffff;
  unsigned long s2 = (adler >> 16) & 0xffff;
  int n;

  for (n = 0; n < len; n++) {
    s1 = (s1 + buf[n]) % BASE;
    s2 = (s2 + s1)     % BASE;
  }
  return (s2 << 16) + s1;
}

// The wrappers tools/oracle/oracle.zig declares.

uint32_t oracle_rfc1952_update_crc(uint32_t crc, const unsigned char *buf, size_t len) {
  unsigned long value = crc;
  while (len > 0) {
    int piece = len > INT_MAX ? INT_MAX : (int)len;
    value = update_crc(value, buf, piece);
    buf += piece;
    len -= (size_t)piece;
  }
  return (uint32_t)value;
}

uint32_t oracle_rfc1950_update_adler32(uint32_t adler, const unsigned char *buf, size_t len) {
  unsigned long value = adler;
  while (len > 0) {
    int piece = len > INT_MAX ? INT_MAX : (int)len;
    value = update_adler32(value, buf, piece);
    buf += piece;
    len -= (size_t)piece;
  }
  return (uint32_t)value;
}
