# Specifications

These are the specifications stdx is written from that are not RFCs, unmodified. Decision 18 rules
that XXH64 is read from xxHash's own specification document, because RFC 8878 §3.1.1 cites xxHash
by a URL and gives no algorithm. The copy here is what that decision points at, so every reader
works from the same octets.

`SHA256SUMS` records each file's checksum. Check that nothing was edited with:

```bash
cd docs/specs && shasum -a 256 -c SHA256SUMS
```

## Where each copy came from

- `xxhash_spec.md`, version 0.2.0 (29/06/23), was downloaded on 2026-09-26 from
  `https://raw.githubusercontent.com/Cyan4973/xxHash/d66a9cb6f223b1f15cceebee39bc07ed0bd4ad3d/doc/xxhash_spec.md`,
  the last commit to change it. The file at release v0.8.4 of github.com/Cyan4973/xxHash has the
  same SHA-256. Its notice allows copying it unmodified.

## What stdx uses

| Specification | What stdx uses it for |
|---|---|
| [xxhash_spec.md](xxhash_spec.md) | XXH64, in `checksum`: its "XXH64 Algorithm Description", steps 1 to 7. The document gives no test values, so design §8 step 10 checks stdx's XXH64 against libzstd's Content_Checksum, XXH64's low 32 bits with seed 0 (RFC 8878 §3.1.1) |
