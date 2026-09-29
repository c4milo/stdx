"""gen.py <out dir>: writes raw DEFLATE streams whose symbol statistics vary one at a time, each one
dynamic block (RFC 1951 §3.2.7) with code lengths chosen for the family, and a <name>.len file
holding the decoded length. Seeded, so each stream is the same every run.

Families:
- lit<L>: literals alone, drawn uniformly from 2^L symbols of L-bit codes (mean code L bits).
- run<k>: literal runs of geometric length with mean k, each followed by one combinable pair
  (length 4, distance 20).
- dist<D>: pairs of length 8 at distance D, nothing else; a combinable entry for every D up to 1024.
- len<L>: pairs of length L at distance 4000, every one a plain entry (13 or more bits).
- plain<p>: pairs of length 8, of which p percent take a plain entry (distance 129..192 with a 5-bit
  code) and the rest a combined one (distance 97..128 with a 1-bit code).
"""
import os, random, struct, sys, zlib

LBASE = [3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258]
LEXT = [0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0]
DBASE = [1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577]
DEXT = [0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13]
CL_ORDER = [16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15]


class Bits:
    """An LSB-first bit writer (RFC 1951 §3.1.1)."""
    def __init__(self):
        self.out = bytearray(); self.acc = 0; self.n = 0
    def put(self, value, count):
        self.acc |= value << self.n; self.n += count
        while self.n >= 8:
            self.out.append(self.acc & 0xff); self.acc >>= 8; self.n -= 8
    def finish(self):
        if self.n: self.out.append(self.acc & 0xff)
        return bytes(self.out)


def canonical(lengths):
    """Each symbol's code as the stream writes it: reversed, since a Huffman code's most significant
    bit comes first (RFC 1951 §3.1.1, §3.2.2)."""
    counts = [0] * 16
    for l in lengths:
        if l: counts[l] += 1
    assert sum(c * 2 ** -l for l, c in enumerate(counts) if l) <= 1.0 + 1e-12, "over-subscribed"
    code = 0; next_code = [0] * 16
    for b in range(1, 16):
        code = (code + counts[b - 1]) << 1; next_code[b] = code
    codes = {}
    for s, l in enumerate(lengths):
        if l:
            c = next_code[l]; next_code[l] += 1
            codes[s] = (int(format(c, f'0{l}b')[::-1], 2), l)
    return codes


def kraft(lengths):
    return sum(2.0 ** -l for l in lengths if l)


class Block:
    def __init__(self, ll_lengths, d_lengths):
        assert abs(kraft(ll_lengths) - 1.0) < 1e-9, f"literal/length code not complete: {kraft(ll_lengths)}"
        assert kraft(d_lengths) <= 1.0 + 1e-9
        self.ll = canonical(ll_lengths); self.d = canonical(d_lengths)
        self.bits = Bits(); self.octets = 0
        b = self.bits
        b.put(1, 1); b.put(2, 2)  # BFINAL, BTYPE dynamic
        nlit = max(257, len(ll_lengths)); ndist = max(1, len(d_lengths))
        ll_lengths = list(ll_lengths) + [0] * (nlit - len(ll_lengths))
        d_lengths = list(d_lengths) + [0] * (ndist - len(d_lengths))
        b.put(nlit - 257, 5); b.put(ndist - 1, 5); b.put(19 - 4, 4)
        # Code length code: symbols 0 to 15 of 4 bits each, a complete code; no repeats used.
        cl_lengths = [4] * 16 + [0, 0, 0]
        for s in CL_ORDER: b.put(cl_lengths[s], 3)
        cl = canonical(cl_lengths)
        for l in ll_lengths + d_lengths:
            code, n = cl[l]; b.put(code, n)

    def literal(self, s):
        code, n = self.ll[s]; self.bits.put(code, n); self.octets += 1

    def pair(self, length, distance):
        i = max(k for k in range(29) if LBASE[k] <= length)
        if length == 258: i = 28
        code, n = self.ll[257 + i]; self.bits.put(code, n)
        if LEXT[i]: self.bits.put(length - LBASE[i], LEXT[i])
        j = max(k for k in range(30) if DBASE[k] <= distance)
        code, n = self.d[j]; self.bits.put(code, n)
        if DEXT[j]: self.bits.put(distance - DBASE[j], DEXT[j])
        self.octets += length

    def end(self):
        code, n = self.ll[256]; self.bits.put(code, n)
        return self.bits.finish()


def dsym(distance):
    return max(k for k in range(30) if DBASE[k] <= distance)


def write(out, name, block):
    raw = block.end()
    open(os.path.join(out, name + '.raw'), 'wb').write(raw + bytes(16))
    open(os.path.join(out, name + '.len'), 'w').write(str(block.octets))
    # The same stream as one gzip member (RFC 1952 §2.3): a header with no optional fields, the
    # DEFLATE stream, CRC-32 and ISIZE least significant octet first, no padding.
    decoded = zlib.decompressobj(-15).decompress(raw)
    assert len(decoded) == block.octets, (name, len(decoded), block.octets)
    header = bytes([0x1f, 0x8b, 8, 0, 0, 0, 0, 0, 0, 255])
    trailer = struct.pack('<II', zlib.crc32(decoded) & 0xffffffff, block.octets & 0xffffffff)
    open(os.path.join(out, name + '.gz'), 'wb').write(header + raw + trailer)
    print(f"{name}: {block.octets} octets, {len(raw)} in", flush=True)


def family_lit(out, L, target):
    rng = random.Random(L)
    n = 1 << L
    # n - 1 literals of L bits, then the last literal and the block's end at L + 1 bits: complete.
    ll = [L] * (n - 1) + [L + 1] + [0] * (256 - n) + [L + 1]
    block = Block(ll, [1])
    while block.octets < target:
        block.literal(rng.randrange(n))
    write(out, f'lit{L}', block)


def family_run(out, k, target):
    rng = random.Random(100 + k)
    # 253 literals of 8 bits, length symbol 258 (length 4) of 7 bits, literal 253 and the block's
    # end of 9 bits: 1012/1024 + 8/1024 + 4/1024. Distance symbol 8 (17..24) of 1 bit: the pair
    # takes 7 + 1 + 3 = 11 bits, a combined entry.
    ll = [8] * 253 + [9, 0, 0] + [9] + [0] + [7]
    d = [0] * 8 + [1]
    block = Block(ll, d)
    # Enough history for the pairs' distance.
    for _ in range(64): block.literal(rng.randrange(253))
    while block.octets < target:
        block.literal(rng.randrange(253))
        while rng.random() > 1.0 / k:
            block.literal(rng.randrange(253))
        block.pair(4, 20)
    write(out, f'run{k}', block)


def family_dist(out, D, target):
    rng = random.Random(1000 + D)
    # Length symbol 262 (length 8) of 1 bit, the block's end of 2 bits, 64 literals of 8 bits.
    ll = [8] * 64 + [0] * 192 + [2] + [0] * 5 + [1]
    d = [0] * dsym(D) + [1]
    block = Block(ll, d)
    # Enough history for every distance.
    for _ in range(4096): block.literal(rng.randrange(64))
    while block.octets < target:
        block.pair(8, D)
    write(out, f'dist{D}', block)


def family_len(out, L, target):
    rng = random.Random(2000 + L)
    i = 28 if L == 258 else max(k for k in range(29) if LBASE[k] <= L)
    ll = [8] * 64 + [0] * 192 + [2] + [0] * i + [1]
    d = [0] * 23 + [1]  # distance symbol 23: 3073..4096, 11 extra bits: a plain entry always
    block = Block(ll, d)
    for _ in range(4096): block.literal(rng.randrange(64))
    while block.octets < target:
        block.pair(L, 4000)
    write(out, f'len{L}', block)


def family_plain(out, p, target):
    rng = random.Random(3000 + p)
    ll = [8] * 64 + [0] * 192 + [2] + [0] * 5 + [1]
    # Distance symbol 13 (97..128) of 1 bit, symbol 14 (129..192) of 5 bits, and 15 unused symbols
    # of 5 bits: complete. Symbol 13's pair takes 1 + 1 + 5 = 7 bits, combined; symbol 14's
    # 1 + 5 + 6 = 12, plain.
    d = [5] * 13 + [1, 5] + [5] * 2
    block = Block(ll, d)
    for _ in range(256): block.literal(rng.randrange(64))
    while block.octets < target:
        if rng.random() * 100 < p:
            block.pair(8, rng.randrange(129, 193))
        else:
            block.pair(8, rng.randrange(97, 129))
    write(out, f'plain{p}', block)


def family_near(out, D, target):
    rng = random.Random(4000 + D)
    # One literal, then a pair of length 4 at distance D whose source lies just before the output
    # the pair before it wrote: the run family's literal/length code, and a distance code of 16
    # symbols, 4 to 19, of 4 bits each, so every pair takes 7 + 4 + 1 bits at least, a plain entry.
    ll = [8] * 253 + [9, 0, 0] + [9] + [0] + [7]
    d = [0] * 4 + [4] * 16
    block = Block(ll, d)
    for _ in range(1024): block.literal(rng.randrange(253))
    while block.octets < target:
        block.literal(rng.randrange(253))
        block.pair(4, D)
    write(out, f'near{D}', block)


if __name__ == '__main__':
    out = sys.argv[1]; os.makedirs(out, exist_ok=True)
    which = sys.argv[2] if len(sys.argv) > 2 else 'all'
    target = 2 << 20
    if which in ('all', 'lit'):
        for L in (4, 6, 7, 8): family_lit(out, L, target)
    if which in ('all', 'run'):
        for k in (1, 2, 3, 4, 6, 8, 16, 64): family_run(out, k, target)
    if which in ('all', 'dist'):
        for D in (1, 2, 3, 4, 8, 12, 15, 16, 17, 20, 24, 31, 32, 33, 40, 48, 63, 64, 65, 96, 128, 192, 256, 384, 512, 768, 1024): family_dist(out, D, target)
    if which in ('all', 'len'):
        for L in (3, 4, 8, 12, 16, 17, 24, 32, 33, 40, 48, 49, 64, 96, 128, 200, 258): family_len(out, L, target)
    if which in ('all', 'near'):
        for D in (5, 6, 8, 12, 20, 36, 52, 68, 100, 132, 200, 264, 400, 600, 1000): family_near(out, D, target)
    if which in ('all', 'plain'):
        for p in (0, 2, 5, 10, 20, 30, 50, 70, 100): family_plain(out, p, target)
