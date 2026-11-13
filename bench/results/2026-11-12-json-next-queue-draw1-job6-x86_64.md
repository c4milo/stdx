# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1029.5 ± 3.0% | 0.477 | 1.017 | 1.043 | 1.035 | 0.411 | 1.038 | 1.025 | 0.360 | 0.792 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 855.3 ± 0.5% | 0.735 | 1.030 | 1.014 | 0.996 | 0.389 | 1.006 | 0.997 | 0.340 | 0.680 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.7 ± 0.8% | 0.443 | 0.979 | 0.984 | 1.006 | 1.001 | 0.236 | 1.000 | 0.445 | 0.721 | 0.086 | 1.026 |
| qlog records, JSON text sequence | 1467503 | 1149.7 ± 1.5% | 0.702 | 0.922 | 0.985 | 0.979 | 0.984 | 0.229 | 0.984 | 0.409 | 0.693 | 0.105 | 1.004 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

None.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe; the baselines for this host in ReleaseFast, and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1029.5 ± 3.0% | 1005.5 ± 0.7% | 977.7 ± 0.9% | 259.9 ± 0.5% | 531.7 ± 0.3% | 258.4 ± 2.2% | 1.024 | 1.053 | 3.961 | 1.936 | 3.984 |
| qlog records, JSON text sequence | 1467503 | 855.3 ± 0.5% | 808.4 ± 0.4% | 815.4 ± 1.6% | 219.8 ± 3.3% | 588.3 ± 1.6% | 245.5 ± 1.2% | 1.058 | 1.049 | 3.890 | 1.454 | 3.484 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.7 ± 0.8% | 1136.1 ± 1.3% | 897.2 ± 5.8% | 319.8 ± 0.4% | 356.9 ± 4.1% | 313.1 ± 1.0% | 1.174 | 1.486 | 4.171 | 3.737 | 4.259 |
| qlog records, JSON text sequence | 1467503 | 1149.7 ± 1.5% | 836.4 ± 6.0% | 717.3 ± 6.4% | 317.5 ± 1.9% | 383.2 ± 0.4% | 230.5 ± 4.8% | 1.375 | 1.603 | 3.621 | 3.000 | 4.988 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1368.6 ± 1.0% | 1136.1 ± 1.3% | 897.2 ± 5.8% | 319.8 ± 0.4% | 356.9 ± 4.1% | 313.1 ± 1.0% | 1.205 | 1.525 | 4.280 | 3.835 | 4.371 |
| qlog records, JSON text sequence | 1467503 | 1154.5 ± 5.5% | 836.4 ± 6.0% | 717.3 ± 6.4% | 317.5 ± 1.9% | 383.2 ± 0.4% | 230.5 ± 4.8% | 1.380 | 1.610 | 3.636 | 3.013 | 5.009 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 815.2 ± 1.0% | 1005.5 ± 0.7% | 977.7 ± 0.9% | 259.9 ± 0.5% | 531.7 ± 0.3% | 258.4 ± 2.2% | 0.811 | 0.834 | 3.137 | 1.533 | 3.155 |
| qlog records, JSON text sequence | 1467503 | 581.5 ± 5.2% | 808.4 ± 0.4% | 815.4 ± 1.6% | 219.8 ± 3.3% | 588.3 ± 1.6% | 245.5 ± 1.2% | 0.719 | 0.713 | 2.645 | 0.988 | 2.368 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 962.1 ± 1.7% | 1136.1 ± 1.3% | 897.2 ± 5.8% | 319.8 ± 0.4% | 356.9 ± 4.1% | 313.1 ± 1.0% | 0.847 | 1.072 | 3.009 | 2.696 | 3.073 |
| qlog records, JSON text sequence | 1467503 | 796.3 ± 0.9% | 836.4 ± 6.0% | 717.3 ± 6.4% | 317.5 ± 1.9% | 383.2 ± 0.4% | 230.5 ± 4.8% | 0.952 | 1.110 | 2.508 | 2.078 | 3.455 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.811 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.834 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.719 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.713 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.847 of simdjson.

# bench-json, CLDR and qlog alone: null, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1009.7 ± 6.9% | 0.476 | 1.035 | 1.090 | 1.087 | 0.428 | 1.073 | 1.087 | 0.366 | 0.766 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 829.7 ± 0.8% | 0.747 | 1.036 | 1.019 | 0.996 | 0.399 | 1.022 | 1.000 | 0.349 | 0.666 | 0.112 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.8 ± 4.8% | 0.404 | 0.974 | 0.960 | 1.010 | 0.996 | 0.229 | 0.998 | 0.441 | 0.720 | 0.085 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1162.8 ± 1.0% | 0.689 | 0.943 | 0.982 | 0.990 | 0.984 | 0.221 | 0.981 | 0.409 | 0.695 | 0.104 | 1.015 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.090 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.087 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.073 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.087 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe; the baselines for this host in ReleaseFast, and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1009.7 ± 6.9% | 1021.3 ± 2.2% | 988.2 ± 0.8% | 260.1 ± 0.3% | 530.7 ± 0.4% | 259.3 ± 3.9% | 0.989 | 1.022 | 3.882 | 1.903 | 3.894 |
| qlog records, JSON text sequence | 1467503 | 829.7 ± 0.8% | 807.4 ± 5.0% | 792.3 ± 4.4% | 222.9 ± 1.0% | 588.0 ± 0.9% | 245.6 ± 3.2% | 1.028 | 1.047 | 3.722 | 1.411 | 3.378 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.8 ± 4.8% | 1127.3 ± 1.1% | 897.6 ± 0.3% | 332.7 ± 4.5% | 361.8 ± 0.5% | 313.1 ± 0.7% | 1.187 | 1.490 | 4.021 | 3.698 | 4.273 |
| qlog records, JSON text sequence | 1467503 | 1162.8 ± 1.0% | 842.8 ± 0.8% | 728.6 ± 0.7% | 323.9 ± 0.3% | 381.6 ± 0.5% | 230.2 ± 2.4% | 1.380 | 1.596 | 3.590 | 3.047 | 5.051 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1359.9 ± 0.9% | 1127.3 ± 1.1% | 897.6 ± 0.3% | 332.7 ± 4.5% | 361.8 ± 0.5% | 313.1 ± 0.7% | 1.206 | 1.515 | 4.087 | 3.759 | 4.343 |
| qlog records, JSON text sequence | 1467503 | 1180.0 ± 1.6% | 842.8 ± 0.8% | 728.6 ± 0.7% | 323.9 ± 0.3% | 381.6 ± 0.5% | 230.2 ± 2.4% | 1.400 | 1.620 | 3.643 | 3.092 | 5.125 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 773.9 ± 2.1% | 1021.3 ± 2.2% | 988.2 ± 0.8% | 260.1 ± 0.3% | 530.7 ± 0.4% | 259.3 ± 3.9% | 0.758 | 0.783 | 2.975 | 1.458 | 2.984 |
| qlog records, JSON text sequence | 1467503 | 552.6 ± 1.2% | 807.4 ± 5.0% | 792.3 ± 4.4% | 222.9 ± 1.0% | 588.0 ± 0.9% | 245.6 ± 3.2% | 0.684 | 0.697 | 2.479 | 0.940 | 2.250 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 962.8 ± 0.5% | 1127.3 ± 1.1% | 897.6 ± 0.3% | 332.7 ± 4.5% | 361.8 ± 0.5% | 313.1 ± 0.7% | 0.854 | 1.073 | 2.894 | 2.661 | 3.075 |
| qlog records, JSON text sequence | 1467503 | 807.9 ± 0.7% | 842.8 ± 0.8% | 728.6 ± 0.7% | 323.9 ± 0.3% | 381.6 ± 0.5% | 230.2 ± 2.4% | 0.959 | 1.109 | 2.494 | 2.117 | 3.509 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.758 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.783 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.684 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.697 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.940 of serde_json.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.854 of simdjson.

# bench-json, CLDR and qlog alone: head, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 985.7 ± 3.1% | 0.486 | 1.020 | 1.112 | 1.060 | 0.435 | 1.100 | 1.058 | 0.374 | 0.819 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 839.0 ± 1.3% | 0.737 | 1.026 | 1.012 | 0.990 | 0.390 | 1.014 | 1.004 | 0.349 | 0.890 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.7 ± 1.0% | 0.437 | 0.975 | 0.963 | 0.991 | 1.002 | 0.227 | 1.000 | 0.437 | 0.714 | 0.086 | 1.007 |
| qlog records, JSON text sequence | 1467503 | 1160.4 ± 0.7% | 0.689 | 0.946 | 0.978 | 0.982 | 0.990 | 0.221 | 0.979 | 0.409 | 0.691 | 0.104 | 1.004 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.112 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.060 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.100 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe; the baselines for this host in ReleaseFast, and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 985.7 ± 3.1% | 984.6 ± 0.2% | 988.2 ± 0.4% | 259.4 ± 1.0% | 514.7 ± 3.4% | 256.1 ± 4.0% | 1.001 | 0.997 | 3.800 | 1.915 | 3.849 |
| qlog records, JSON text sequence | 1467503 | 839.0 ± 1.3% | 808.5 ± 0.4% | 811.5 ± 6.4% | 222.0 ± 0.6% | 587.8 ± 0.5% | 244.9 ± 3.2% | 1.038 | 1.034 | 3.779 | 1.427 | 3.426 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.7 ± 1.0% | 1127.1 ± 0.7% | 894.8 ± 3.0% | 330.9 ± 1.2% | 357.8 ± 2.0% | 312.7 ± 4.3% | 1.186 | 1.494 | 4.040 | 3.736 | 4.275 |
| qlog records, JSON text sequence | 1467503 | 1160.4 ± 0.7% | 863.0 ± 1.0% | 725.3 ± 1.0% | 323.3 ± 0.6% | 383.9 ± 1.5% | 233.4 ± 0.5% | 1.345 | 1.600 | 3.589 | 3.023 | 4.972 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1346.5 ± 0.8% | 1127.1 ± 0.7% | 894.8 ± 3.0% | 330.9 ± 1.2% | 357.8 ± 2.0% | 312.7 ± 4.3% | 1.195 | 1.505 | 4.069 | 3.763 | 4.306 |
| qlog records, JSON text sequence | 1467503 | 1165.0 ± 1.5% | 863.0 ± 1.0% | 725.3 ± 1.0% | 323.3 ± 0.6% | 383.9 ± 1.5% | 233.4 ± 0.5% | 1.350 | 1.606 | 3.603 | 3.035 | 4.992 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 806.8 ± 1.6% | 984.6 ± 0.2% | 988.2 ± 0.4% | 259.4 ± 1.0% | 514.7 ± 3.4% | 256.1 ± 4.0% | 0.819 | 0.816 | 3.111 | 1.568 | 3.151 |
| qlog records, JSON text sequence | 1467503 | 746.5 ± 2.8% | 808.5 ± 0.4% | 811.5 ± 6.4% | 222.0 ± 0.6% | 587.8 ± 0.5% | 244.9 ± 3.2% | 0.923 | 0.920 | 3.362 | 1.270 | 3.048 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 954.2 ± 0.3% | 1127.1 ± 0.7% | 894.8 ± 3.0% | 330.9 ± 1.2% | 357.8 ± 2.0% | 312.7 ± 4.3% | 0.847 | 1.066 | 2.884 | 2.667 | 3.051 |
| qlog records, JSON text sequence | 1467503 | 801.3 ± 7.5% | 863.0 ± 1.0% | 725.3 ± 1.0% | 323.3 ± 0.6% | 383.9 ± 1.5% | 233.4 ± 0.5% | 0.928 | 1.105 | 2.478 | 2.087 | 3.433 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.819 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.816 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.923 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.920 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.847 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1012.7 ± 3.4% | 0.488 | 1.035 | 1.063 | 1.066 | 0.418 | 1.070 | 1.020 | 0.365 | 0.807 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 854.8 ± 0.3% | 0.735 | 1.029 | 1.010 | 0.998 | 0.389 | 1.009 | 1.001 | 0.344 | 0.681 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1318.7 ± 3.0% | 0.446 | 0.984 | 0.978 | 1.009 | 0.998 | 0.238 | 1.000 | 0.448 | 0.717 | 0.087 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1165.8 ± 1.0% | 0.698 | 0.917 | 0.984 | 0.980 | 0.984 | 0.227 | 0.983 | 0.408 | 0.688 | 0.104 | 1.010 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.063 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.066 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.070 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe; the baselines for this host in ReleaseFast, and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1012.7 ± 3.4% | 1005.2 ± 4.4% | 984.7 ± 1.1% | 259.7 ± 1.1% | 530.8 ± 0.4% | 256.1 ± 3.1% | 1.008 | 1.028 | 3.899 | 1.908 | 3.955 |
| qlog records, JSON text sequence | 1467503 | 854.8 ± 0.3% | 812.7 ± 0.2% | 805.1 ± 6.5% | 222.6 ± 4.3% | 588.5 ± 4.9% | 245.6 ± 1.6% | 1.052 | 1.062 | 3.840 | 1.453 | 3.480 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1318.7 ± 3.0% | 1130.9 ± 1.0% | 896.7 ± 0.7% | 319.7 ± 4.5% | 357.1 ± 0.7% | 311.0 ± 4.2% | 1.166 | 1.470 | 4.124 | 3.693 | 4.240 |
| qlog records, JSON text sequence | 1467503 | 1165.8 ± 1.0% | 864.7 ± 0.2% | 727.0 ± 0.5% | 318.0 ± 1.3% | 384.9 ± 0.7% | 230.6 ± 1.9% | 1.348 | 1.603 | 3.666 | 3.029 | 5.054 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1347.7 ± 0.6% | 1130.9 ± 1.0% | 896.7 ± 0.7% | 319.7 ± 4.5% | 357.1 ± 0.7% | 311.0 ± 4.2% | 1.192 | 1.503 | 4.215 | 3.774 | 4.333 |
| qlog records, JSON text sequence | 1467503 | 1178.0 ± 0.4% | 864.7 ± 0.2% | 727.0 ± 0.5% | 318.0 ± 1.3% | 384.9 ± 0.7% | 230.6 ± 1.9% | 1.362 | 1.620 | 3.704 | 3.061 | 5.107 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 816.9 ± 2.1% | 1005.2 ± 4.4% | 984.7 ± 1.1% | 259.7 ± 1.1% | 530.8 ± 0.4% | 256.1 ± 3.1% | 0.813 | 0.830 | 3.145 | 1.539 | 3.190 |
| qlog records, JSON text sequence | 1467503 | 582.2 ± 1.2% | 812.7 ± 0.2% | 805.1 ± 6.5% | 222.6 ± 4.3% | 588.5 ± 4.9% | 245.6 ± 1.6% | 0.716 | 0.723 | 2.616 | 0.989 | 2.370 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 945.6 ± 5.4% | 1130.9 ± 1.0% | 896.7 ± 0.7% | 319.7 ± 4.5% | 357.1 ± 0.7% | 311.0 ± 4.2% | 0.836 | 1.054 | 2.958 | 2.648 | 3.040 |
| qlog records, JSON text sequence | 1467503 | 801.6 ± 1.8% | 864.7 ± 0.2% | 727.0 ± 0.5% | 318.0 ± 1.3% | 384.9 ± 0.7% | 230.6 ± 1.9% | 0.927 | 1.103 | 2.520 | 2.083 | 3.475 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.813 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.830 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.716 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.723 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.836 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.927 of simdjson.

# bench-json, CLDR and qlog alone: null, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 970.7 ± 6.0% | 0.487 | 1.042 | 1.089 | 1.090 | 0.441 | 1.071 | 1.087 | 0.382 | 0.798 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 829.3 ± 0.6% | 0.744 | 1.031 | 1.017 | 1.001 | 0.396 | 1.023 | 1.002 | 0.349 | 0.677 | 0.112 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.7 ± 1.2% | 0.404 | 0.971 | 0.959 | 1.013 | 0.994 | 0.230 | 0.996 | 0.442 | 0.724 | 0.086 | 1.011 |
| qlog records, JSON text sequence | 1467503 | 1159.6 ± 0.4% | 0.691 | 0.944 | 0.982 | 0.990 | 0.985 | 0.222 | 0.986 | 0.413 | 0.696 | 0.104 | 1.014 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.089 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.090 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.071 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.087 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe; the baselines for this host in ReleaseFast, and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 970.7 ± 6.0% | 1005.1 ± 0.3% | 970.3 ± 0.6% | 260.3 ± 0.4% | 531.1 ± 3.6% | 258.5 ± 3.0% | 0.966 | 1.000 | 3.730 | 1.828 | 3.754 |
| qlog records, JSON text sequence | 1467503 | 829.3 ± 0.6% | 786.1 ± 1.0% | 808.5 ± 5.8% | 223.6 ± 1.4% | 586.5 ± 6.2% | 243.5 ± 0.6% | 1.055 | 1.026 | 3.708 | 1.414 | 3.405 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.7 ± 1.2% | 1123.5 ± 1.4% | 898.7 ± 0.3% | 333.3 ± 1.2% | 365.9 ± 0.7% | 312.6 ± 4.7% | 1.188 | 1.485 | 4.005 | 3.647 | 4.270 |
| qlog records, JSON text sequence | 1467503 | 1159.6 ± 0.4% | 871.5 ± 0.6% | 727.8 ± 0.6% | 323.7 ± 3.0% | 393.0 ± 0.8% | 230.8 ± 0.9% | 1.331 | 1.593 | 3.583 | 2.951 | 5.025 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1349.5 ± 5.4% | 1123.5 ± 1.4% | 898.7 ± 0.3% | 333.3 ± 1.2% | 365.9 ± 0.7% | 312.6 ± 4.7% | 1.201 | 1.502 | 4.049 | 3.688 | 4.317 |
| qlog records, JSON text sequence | 1467503 | 1176.2 ± 0.5% | 871.5 ± 0.6% | 727.8 ± 0.6% | 323.7 ± 3.0% | 393.0 ± 0.8% | 230.8 ± 0.9% | 1.350 | 1.616 | 3.634 | 2.993 | 5.096 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 774.4 ± 3.3% | 1005.1 ± 0.3% | 970.3 ± 0.6% | 260.3 ± 0.4% | 531.1 ± 3.6% | 258.5 ± 3.0% | 0.770 | 0.798 | 2.975 | 1.458 | 2.995 |
| qlog records, JSON text sequence | 1467503 | 561.2 ± 3.4% | 786.1 ± 1.0% | 808.5 ± 5.8% | 223.6 ± 1.4% | 586.5 ± 6.2% | 243.5 ± 0.6% | 0.714 | 0.694 | 2.510 | 0.957 | 2.304 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 966.8 ± 1.4% | 1123.5 ± 1.4% | 898.7 ± 0.3% | 333.3 ± 1.2% | 365.9 ± 0.7% | 312.6 ± 4.7% | 0.861 | 1.076 | 2.901 | 2.642 | 3.093 |
| qlog records, JSON text sequence | 1467503 | 807.1 ± 0.9% | 871.5 ± 0.6% | 727.8 ± 0.6% | 323.7 ± 3.0% | 393.0 ± 0.8% | 230.8 ± 0.9% | 0.926 | 1.109 | 2.494 | 2.054 | 3.497 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.770 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.798 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.714 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.694 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.861 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.

# bench-json, CLDR and qlog alone: head, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1035.3 ± 3.5% | 0.465 | 1.031 | 1.065 | 1.018 | 0.416 | 1.049 | 1.011 | 0.357 | 0.780 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 838.6 ± 0.6% | 0.734 | 1.024 | 1.007 | 1.001 | 0.389 | 1.012 | 1.001 | 0.348 | 0.892 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.1 ± 1.3% | 0.437 | 0.978 | 0.965 | 0.991 | 1.009 | 0.229 | 1.012 | 0.442 | 0.719 | 0.085 | 1.014 |
| qlog records, JSON text sequence | 1467503 | 1162.4 ± 0.4% | 0.685 | 0.946 | 0.975 | 0.980 | 0.986 | 0.221 | 0.985 | 0.408 | 0.695 | 0.104 | 1.007 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.065 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe; the baselines for this host in ReleaseFast, and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1035.3 ± 3.5% | 1005.2 ± 0.5% | 981.0 ± 0.2% | 259.1 ± 3.7% | 531.7 ± 0.4% | 258.8 ± 3.0% | 1.030 | 1.055 | 3.996 | 1.947 | 4.000 |
| qlog records, JSON text sequence | 1467503 | 838.6 ± 0.6% | 807.7 ± 0.5% | 789.0 ± 5.0% | 222.1 ± 1.3% | 587.6 ± 4.6% | 245.2 ± 1.3% | 1.038 | 1.063 | 3.776 | 1.427 | 3.421 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.1 ± 1.3% | 1139.5 ± 0.9% | 896.4 ± 1.3% | 333.0 ± 0.7% | 359.9 ± 4.4% | 312.0 ± 2.0% | 1.173 | 1.490 | 4.012 | 3.713 | 4.282 |
| qlog records, JSON text sequence | 1467503 | 1162.4 ± 0.4% | 861.4 ± 1.2% | 727.1 ± 6.9% | 322.4 ± 1.1% | 383.3 ± 2.2% | 232.0 ± 1.3% | 1.350 | 1.599 | 3.605 | 3.033 | 5.010 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1354.4 ± 1.1% | 1139.5 ± 0.9% | 896.4 ± 1.3% | 333.0 ± 0.7% | 359.9 ± 4.4% | 312.0 ± 2.0% | 1.189 | 1.511 | 4.067 | 3.764 | 4.340 |
| qlog records, JSON text sequence | 1467503 | 1170.3 ± 5.0% | 861.4 ± 1.2% | 727.1 ± 6.9% | 322.4 ± 1.1% | 383.3 ± 2.2% | 232.0 ± 1.3% | 1.359 | 1.609 | 3.630 | 3.053 | 5.044 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 807.1 ± 3.4% | 1005.2 ± 0.5% | 981.0 ± 0.2% | 259.1 ± 3.7% | 531.7 ± 0.4% | 258.8 ± 3.0% | 0.803 | 0.823 | 3.115 | 1.518 | 3.119 |
| qlog records, JSON text sequence | 1467503 | 747.7 ± 0.4% | 807.7 ± 0.5% | 789.0 ± 5.0% | 222.1 ± 1.3% | 587.6 ± 4.6% | 245.2 ± 1.3% | 0.926 | 0.948 | 3.366 | 1.272 | 3.050 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.1 ± 1.9% | 1139.5 ± 0.9% | 896.4 ± 1.3% | 333.0 ± 0.7% | 359.9 ± 4.4% | 312.0 ± 2.0% | 0.843 | 1.072 | 2.886 | 2.671 | 3.080 |
| qlog records, JSON text sequence | 1467503 | 808.3 ± 1.2% | 861.4 ± 1.2% | 727.1 ± 6.9% | 322.4 ± 1.1% | 383.3 ± 2.2% | 232.0 ± 1.3% | 0.938 | 1.112 | 2.507 | 2.109 | 3.484 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.803 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.823 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.926 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.948 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.843 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.938 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1013.6 ± 4.9% | 0.483 | 1.029 | 1.019 | 1.060 | 0.416 | 1.061 | 1.064 | 0.365 | 0.801 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 855.6 ± 5.9% | 0.730 | 1.034 | 1.015 | 0.999 | 0.388 | 1.008 | 0.993 | 0.343 | 0.680 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1323.7 ± 1.4% | 0.445 | 0.977 | 0.980 | 0.996 | 0.995 | 0.237 | 0.995 | 0.449 | 0.719 | 0.087 | 1.012 |
| qlog records, JSON text sequence | 1467503 | 1129.4 ± 7.5% | 0.708 | 0.940 | 0.998 | 0.988 | 0.993 | 0.234 | 0.989 | 0.424 | 0.703 | 0.107 | 1.025 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.060 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.061 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.064 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe; the baselines for this host in ReleaseFast, and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1013.6 ± 4.9% | 976.2 ± 1.2% | 974.7 ± 0.2% | 259.5 ± 0.8% | 531.4 ± 6.2% | 258.3 ± 3.1% | 1.038 | 1.040 | 3.905 | 1.907 | 3.924 |
| qlog records, JSON text sequence | 1467503 | 855.6 ± 5.9% | 794.8 ± 0.6% | 798.4 ± 6.0% | 221.3 ± 4.2% | 589.4 ± 0.6% | 245.0 ± 1.9% | 1.077 | 1.072 | 3.867 | 1.452 | 3.493 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1323.7 ± 1.4% | 1126.4 ± 3.7% | 895.4 ± 0.5% | 319.4 ± 0.4% | 356.1 ± 1.7% | 310.9 ± 0.6% | 1.175 | 1.478 | 4.145 | 3.717 | 4.258 |
| qlog records, JSON text sequence | 1467503 | 1129.4 ± 7.5% | 864.4 ± 1.7% | 713.6 ± 0.6% | 313.7 ± 0.8% | 382.3 ± 1.3% | 231.2 ± 1.2% | 1.307 | 1.583 | 3.600 | 2.955 | 4.886 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.6 ± 20.4% | 1126.4 ± 3.7% | 895.4 ± 0.5% | 319.4 ± 0.4% | 356.1 ± 1.7% | 310.9 ± 0.6% | 1.189 | 1.496 | 4.195 | 3.762 | 4.309 |
| qlog records, JSON text sequence | 1467503 | 1157.2 ± 1.2% | 864.4 ± 1.7% | 713.6 ± 0.6% | 313.7 ± 0.8% | 382.3 ± 1.3% | 231.2 ± 1.2% | 1.339 | 1.622 | 3.689 | 3.027 | 5.006 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 812.0 ± 1.4% | 976.2 ± 1.2% | 974.7 ± 0.2% | 259.5 ± 0.8% | 531.4 ± 6.2% | 258.3 ± 3.1% | 0.832 | 0.833 | 3.129 | 1.528 | 3.143 |
| qlog records, JSON text sequence | 1467503 | 582.1 ± 3.2% | 794.8 ± 0.6% | 798.4 ± 6.0% | 221.3 ± 4.2% | 589.4 ± 0.6% | 245.0 ± 1.9% | 0.732 | 0.729 | 2.631 | 0.988 | 2.376 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 952.1 ± 5.3% | 1126.4 ± 3.7% | 895.4 ± 0.5% | 319.4 ± 0.4% | 356.1 ± 1.7% | 310.9 ± 0.6% | 0.845 | 1.063 | 2.981 | 2.673 | 3.063 |
| qlog records, JSON text sequence | 1467503 | 793.9 ± 1.1% | 864.4 ± 1.7% | 713.6 ± 0.6% | 313.7 ± 0.8% | 382.3 ± 1.3% | 231.2 ± 1.2% | 0.919 | 1.113 | 2.531 | 2.077 | 3.435 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.832 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.833 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.732 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.729 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.845 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.919 of simdjson.

# bench-json, CLDR and qlog alone: null, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1004.5 ± 5.4% | 0.478 | 1.017 | 1.093 | 1.092 | 0.429 | 1.078 | 1.091 | 0.368 | 0.772 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 832.9 ± 5.6% | 0.746 | 1.033 | 1.016 | 0.999 | 0.396 | 1.018 | 1.002 | 0.348 | 0.673 | 0.112 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1341.9 ± 1.1% | 0.402 | 0.966 | 0.963 | 1.006 | 0.998 | 0.228 | 0.996 | 0.439 | 0.717 | 0.085 | 1.015 |
| qlog records, JSON text sequence | 1467503 | 1160.6 ± 0.4% | 0.690 | 0.947 | 0.984 | 0.991 | 0.987 | 0.222 | 0.988 | 0.408 | 0.698 | 0.103 | 1.015 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.093 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.092 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.078 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.091 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe; the baselines for this host in ReleaseFast, and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1004.5 ± 5.4% | 1020.9 ± 3.1% | 977.5 ± 0.8% | 260.1 ± 0.3% | 530.8 ± 0.5% | 260.0 ± 2.8% | 0.984 | 1.028 | 3.862 | 1.893 | 3.863 |
| qlog records, JSON text sequence | 1467503 | 832.9 ± 5.6% | 807.4 ± 2.3% | 792.3 ± 6.9% | 223.3 ± 3.2% | 588.9 ± 3.3% | 243.2 ± 3.2% | 1.032 | 1.051 | 3.730 | 1.414 | 3.425 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1341.9 ± 1.1% | 1132.3 ± 1.2% | 897.8 ± 0.7% | 333.7 ± 0.4% | 364.8 ± 3.5% | 314.4 ± 0.8% | 1.185 | 1.495 | 4.021 | 3.678 | 4.269 |
| qlog records, JSON text sequence | 1467503 | 1160.6 ± 0.4% | 868.0 ± 0.8% | 726.5 ± 0.5% | 321.4 ± 1.4% | 392.3 ± 2.1% | 228.9 ± 3.5% | 1.337 | 1.598 | 3.611 | 2.959 | 5.070 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1362.2 ± 1.0% | 1132.3 ± 1.2% | 897.8 ± 0.7% | 333.7 ± 0.4% | 364.8 ± 3.5% | 314.4 ± 0.8% | 1.203 | 1.517 | 4.081 | 3.734 | 4.333 |
| qlog records, JSON text sequence | 1467503 | 1178.5 ± 1.4% | 868.0 ± 0.8% | 726.5 ± 0.5% | 321.4 ± 1.4% | 392.3 ± 2.1% | 228.9 ± 3.5% | 1.358 | 1.622 | 3.666 | 3.004 | 5.148 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 775.5 ± 0.2% | 1020.9 ± 3.1% | 977.5 ± 0.8% | 260.1 ± 0.3% | 530.8 ± 0.5% | 260.0 ± 2.8% | 0.760 | 0.793 | 2.982 | 1.461 | 2.982 |
| qlog records, JSON text sequence | 1467503 | 560.7 ± 4.5% | 807.4 ± 2.3% | 792.3 ± 6.9% | 223.3 ± 3.2% | 588.9 ± 3.3% | 243.2 ± 3.2% | 0.695 | 0.708 | 2.511 | 0.952 | 2.306 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 962.6 ± 1.1% | 1132.3 ± 1.2% | 897.8 ± 0.7% | 333.7 ± 0.4% | 364.8 ± 3.5% | 314.4 ± 0.8% | 0.850 | 1.072 | 2.884 | 2.639 | 3.062 |
| qlog records, JSON text sequence | 1467503 | 809.9 ± 6.6% | 868.0 ± 0.8% | 726.5 ± 0.5% | 321.4 ± 1.4% | 392.3 ± 2.1% | 228.9 ± 3.5% | 0.933 | 1.115 | 2.519 | 2.065 | 3.538 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.760 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.793 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.695 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.708 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.850 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.933 of simdjson.

# bench-json, CLDR and qlog alone: head, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 994.4 ± 5.2% | 0.482 | 1.053 | 1.087 | 1.030 | 0.432 | 1.069 | 1.036 | 0.372 | 0.808 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 829.6 ± 1.7% | 0.715 | 1.035 | 1.019 | 1.005 | 0.393 | 1.018 | 1.005 | 0.352 | 0.901 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1324.3 ± 1.3% | 0.441 | 0.980 | 0.970 | 0.996 | 1.005 | 0.229 | 1.005 | 0.441 | 0.720 | 0.086 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1159.9 ± 0.7% | 0.689 | 0.946 | 0.978 | 0.978 | 0.987 | 0.220 | 0.971 | 0.407 | 0.691 | 0.104 | 1.003 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.087 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.069 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe; the baselines for this host in ReleaseFast, and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 994.4 ± 5.2% | 1011.0 ± 0.6% | 981.4 ± 0.7% | 259.1 ± 0.4% | 531.2 ± 0.6% | 257.0 ± 6.4% | 0.984 | 1.013 | 3.837 | 1.872 | 3.869 |
| qlog records, JSON text sequence | 1467503 | 829.6 ± 1.7% | 810.4 ± 0.2% | 784.8 ± 6.1% | 221.2 ± 1.5% | 588.4 ± 0.5% | 245.9 ± 3.1% | 1.024 | 1.057 | 3.751 | 1.410 | 3.373 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1324.3 ± 1.3% | 1128.7 ± 0.5% | 895.8 ± 5.3% | 333.0 ± 1.9% | 361.0 ± 3.5% | 311.8 ± 0.6% | 1.173 | 1.478 | 3.977 | 3.668 | 4.247 |
| qlog records, JSON text sequence | 1467503 | 1159.9 ± 0.7% | 864.4 ± 0.5% | 723.6 ± 1.1% | 322.5 ± 1.0% | 385.8 ± 6.4% | 232.1 ± 6.6% | 1.342 | 1.603 | 3.597 | 3.007 | 4.996 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1347.0 ± 0.8% | 1128.7 ± 0.5% | 895.8 ± 5.3% | 333.0 ± 1.9% | 361.0 ± 3.5% | 311.8 ± 0.6% | 1.193 | 1.504 | 4.045 | 3.731 | 4.319 |
| qlog records, JSON text sequence | 1467503 | 1163.2 ± 0.4% | 864.4 ± 0.5% | 723.6 ± 1.1% | 322.5 ± 1.0% | 385.8 ± 6.4% | 232.1 ± 6.6% | 1.346 | 1.607 | 3.607 | 3.015 | 5.011 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 803.4 ± 3.3% | 1011.0 ± 0.6% | 981.4 ± 0.7% | 259.1 ± 0.4% | 531.2 ± 0.6% | 257.0 ± 6.4% | 0.795 | 0.819 | 3.100 | 1.512 | 3.126 |
| qlog records, JSON text sequence | 1467503 | 747.7 ± 0.7% | 810.4 ± 0.2% | 784.8 ± 6.1% | 221.2 ± 1.5% | 588.4 ± 0.5% | 245.9 ± 3.1% | 0.923 | 0.953 | 3.381 | 1.271 | 3.040 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 954.0 ± 1.0% | 1128.7 ± 0.5% | 895.8 ± 5.3% | 333.0 ± 1.9% | 361.0 ± 3.5% | 311.8 ± 0.6% | 0.845 | 1.065 | 2.865 | 2.643 | 3.059 |
| qlog records, JSON text sequence | 1467503 | 801.8 ± 0.4% | 864.4 ± 0.5% | 723.6 ± 1.1% | 322.5 ± 1.0% | 385.8 ± 6.4% | 232.1 ± 6.6% | 0.928 | 1.108 | 2.486 | 2.079 | 3.454 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.795 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.819 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.923 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.845 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.928 of simdjson.
