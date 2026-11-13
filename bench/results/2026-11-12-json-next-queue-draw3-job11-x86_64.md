# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1042.9 ± 2.6% | 0.465 | 1.006 | 1.031 | 1.025 | 0.405 | 1.016 | 0.991 | 0.354 | 0.782 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 853.7 ± 2.7% | 0.736 | 1.033 | 1.016 | 1.006 | 0.389 | 1.009 | 1.003 | 0.341 | 0.686 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1327.4 ± 1.5% | 0.445 | 0.985 | 0.977 | 1.006 | 1.003 | 0.237 | 1.001 | 0.448 | 0.724 | 0.087 | 1.029 |
| qlog records, JSON text sequence | 1467503 | 1166.9 ± 0.7% | 0.699 | 0.919 | 0.983 | 0.980 | 0.979 | 0.226 | 0.982 | 0.395 | 0.687 | 0.103 | 1.007 |

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
| CLDR supplemental, 34 texts | 920675 | 1042.9 ± 2.6% | 1020.6 ± 1.1% | 985.4 ± 0.2% | 259.9 ± 0.4% | 529.9 ± 3.4% | 260.6 ± 2.8% | 1.022 | 1.058 | 4.012 | 1.968 | 4.001 |
| qlog records, JSON text sequence | 1467503 | 853.7 ± 2.7% | 809.6 ± 0.4% | 827.0 ± 0.4% | 223.8 ± 0.5% | 589.2 ± 1.0% | 244.9 ± 2.0% | 1.054 | 1.032 | 3.815 | 1.449 | 3.486 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1327.4 ± 1.5% | 1128.2 ± 0.4% | 898.9 ± 4.6% | 320.9 ± 0.7% | 357.6 ± 0.5% | 312.0 ± 1.6% | 1.176 | 1.477 | 4.137 | 3.711 | 4.255 |
| qlog records, JSON text sequence | 1467503 | 1166.9 ± 0.7% | 852.6 ± 0.9% | 725.9 ± 0.6% | 319.2 ± 0.7% | 393.2 ± 6.3% | 234.0 ± 5.2% | 1.369 | 1.608 | 3.656 | 2.967 | 4.986 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1366.2 ± 0.8% | 1128.2 ± 0.4% | 898.9 ± 4.6% | 320.9 ± 0.7% | 357.6 ± 0.5% | 312.0 ± 1.6% | 1.211 | 1.520 | 4.258 | 3.820 | 4.380 |
| qlog records, JSON text sequence | 1467503 | 1175.2 ± 1.9% | 852.6 ± 0.9% | 725.9 ± 0.6% | 319.2 ± 0.7% | 393.2 ± 6.3% | 234.0 ± 5.2% | 1.378 | 1.619 | 3.682 | 2.989 | 5.022 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 816.0 ± 1.1% | 1020.6 ± 1.1% | 985.4 ± 0.2% | 259.9 ± 0.4% | 529.9 ± 3.4% | 260.6 ± 2.8% | 0.800 | 0.828 | 3.140 | 1.540 | 3.131 |
| qlog records, JSON text sequence | 1467503 | 585.6 ± 1.4% | 809.6 ± 0.4% | 827.0 ± 0.4% | 223.8 ± 0.5% | 589.2 ± 1.0% | 244.9 ± 2.0% | 0.723 | 0.708 | 2.617 | 0.994 | 2.391 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 960.7 ± 0.8% | 1128.2 ± 0.4% | 898.9 ± 4.6% | 320.9 ± 0.7% | 357.6 ± 0.5% | 312.0 ± 1.6% | 0.851 | 1.069 | 2.994 | 2.686 | 3.079 |
| qlog records, JSON text sequence | 1467503 | 801.5 ± 3.0% | 852.6 ± 0.9% | 725.9 ± 0.6% | 319.2 ± 0.7% | 393.2 ± 6.3% | 234.0 ± 5.2% | 0.940 | 1.104 | 2.511 | 2.038 | 3.424 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.800 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.828 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.723 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.708 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.851 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.940 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1036.7 ± 2.1% | 0.463 | 1.014 | 1.063 | 1.052 | 0.414 | 1.045 | 1.044 | 0.357 | 0.746 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 842.6 ± 0.9% | 0.733 | 1.025 | 1.010 | 1.005 | 0.387 | 1.013 | 1.006 | 0.348 | 0.795 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.7 ± 0.6% | 0.438 | 0.977 | 0.969 | 1.000 | 1.011 | 0.229 | 1.011 | 0.441 | 0.721 | 0.086 | 1.014 |
| qlog records, JSON text sequence | 1467503 | 1163.7 ± 5.0% | 0.689 | 0.934 | 0.971 | 0.972 | 0.976 | 0.221 | 0.985 | 0.412 | 0.696 | 0.104 | 0.995 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.063 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.052 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1036.7 ± 2.1% | 1021.5 ± 18.7% | 987.5 ± 2.3% | 258.5 ± 1.0% | 530.7 ± 3.1% | 256.2 ± 2.6% | 1.015 | 1.050 | 4.011 | 1.954 | 4.046 |
| qlog records, JSON text sequence | 1467503 | 842.6 ± 0.9% | 813.3 ± 0.7% | 825.8 ± 0.2% | 222.8 ± 1.3% | 588.7 ± 1.4% | 248.0 ± 1.7% | 1.036 | 1.020 | 3.782 | 1.431 | 3.397 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.7 ± 0.6% | 1136.9 ± 0.7% | 901.7 ± 1.0% | 332.4 ± 0.5% | 357.9 ± 2.3% | 313.3 ± 1.0% | 1.176 | 1.482 | 4.021 | 3.735 | 4.267 |
| qlog records, JSON text sequence | 1467503 | 1163.7 ± 5.0% | 867.9 ± 6.2% | 728.9 ± 0.4% | 324.0 ± 1.2% | 393.3 ± 1.1% | 234.2 ± 1.8% | 1.341 | 1.597 | 3.592 | 2.959 | 4.969 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1355.9 ± 1.7% | 1136.9 ± 0.7% | 901.7 ± 1.0% | 332.4 ± 0.5% | 357.9 ± 2.3% | 313.3 ± 1.0% | 1.193 | 1.504 | 4.079 | 3.788 | 4.328 |
| qlog records, JSON text sequence | 1467503 | 1157.9 ± 4.3% | 867.9 ± 6.2% | 728.9 ± 0.4% | 324.0 ± 1.2% | 393.3 ± 1.1% | 234.2 ± 1.8% | 1.334 | 1.589 | 3.574 | 2.944 | 4.945 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 773.3 ± 0.5% | 1021.5 ± 18.7% | 987.5 ± 2.3% | 258.5 ± 1.0% | 530.7 ± 3.1% | 256.2 ± 2.6% | 0.757 | 0.783 | 2.992 | 1.457 | 3.018 |
| qlog records, JSON text sequence | 1467503 | 669.5 ± 3.2% | 813.3 ± 0.7% | 825.8 ± 0.2% | 222.8 ± 1.3% | 588.7 ± 1.4% | 248.0 ± 1.7% | 0.823 | 0.811 | 3.005 | 1.137 | 2.699 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 963.7 ± 0.8% | 1136.9 ± 0.7% | 901.7 ± 1.0% | 332.4 ± 0.5% | 357.9 ± 2.3% | 313.3 ± 1.0% | 0.848 | 1.069 | 2.899 | 2.693 | 3.076 |
| qlog records, JSON text sequence | 1467503 | 809.6 ± 0.1% | 867.9 ± 6.2% | 728.9 ± 0.4% | 324.0 ± 1.2% | 393.3 ± 1.1% | 234.2 ± 1.8% | 0.933 | 1.111 | 2.499 | 2.059 | 3.457 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.757 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.783 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.823 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.811 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.848 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.933 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1014.0 ± 5.4% | 0.474 | 1.052 | 1.083 | 1.081 | 0.423 | 1.072 | 1.067 | 0.364 | 0.788 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 843.8 ± 0.6% | 0.735 | 1.024 | 1.005 | 1.002 | 0.389 | 1.012 | 1.003 | 0.347 | 0.889 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.9 ± 0.9% | 0.438 | 0.974 | 0.975 | 1.000 | 1.009 | 0.229 | 1.015 | 0.443 | 0.717 | 0.086 | 1.013 |
| qlog records, JSON text sequence | 1467503 | 1158.2 ± 0.4% | 0.692 | 0.946 | 0.989 | 0.988 | 0.993 | 0.221 | 0.992 | 0.412 | 0.698 | 0.104 | 1.016 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.083 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.081 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.072 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1014.0 ± 5.4% | 1016.7 ± 0.4% | 976.5 ± 1.6% | 259.3 ± 1.8% | 529.6 ± 0.8% | 255.0 ± 6.7% | 0.997 | 1.038 | 3.911 | 1.915 | 3.977 |
| qlog records, JSON text sequence | 1467503 | 843.8 ± 0.6% | 807.9 ± 0.2% | 827.4 ± 0.4% | 222.2 ± 1.2% | 589.5 ± 1.0% | 248.0 ± 0.4% | 1.044 | 1.020 | 3.798 | 1.431 | 3.403 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.9 ± 0.9% | 1134.1 ± 1.3% | 897.6 ± 0.5% | 333.5 ± 1.1% | 362.7 ± 1.7% | 310.4 ± 1.4% | 1.177 | 1.487 | 4.002 | 3.680 | 4.301 |
| qlog records, JSON text sequence | 1467503 | 1158.2 ± 0.4% | 866.4 ± 0.3% | 719.7 ± 0.4% | 323.3 ± 0.4% | 382.8 ± 1.4% | 232.2 ± 1.1% | 1.337 | 1.609 | 3.583 | 3.026 | 4.988 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1352.6 ± 2.0% | 1134.1 ± 1.3% | 897.6 ± 0.5% | 333.5 ± 1.1% | 362.7 ± 1.7% | 310.4 ± 1.4% | 1.193 | 1.507 | 4.055 | 3.729 | 4.358 |
| qlog records, JSON text sequence | 1467503 | 1176.4 ± 0.6% | 866.4 ± 0.3% | 719.7 ± 0.4% | 323.3 ± 0.4% | 382.8 ± 1.4% | 232.2 ± 1.1% | 1.358 | 1.635 | 3.639 | 3.073 | 5.066 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 799.4 ± 1.2% | 1016.7 ± 0.4% | 976.5 ± 1.6% | 259.3 ± 1.8% | 529.6 ± 0.8% | 255.0 ± 6.7% | 0.786 | 0.819 | 3.083 | 1.509 | 3.135 |
| qlog records, JSON text sequence | 1467503 | 750.1 ± 0.5% | 807.9 ± 0.2% | 827.4 ± 0.4% | 222.2 ± 1.2% | 589.5 ± 1.0% | 248.0 ± 0.4% | 0.928 | 0.907 | 3.376 | 1.273 | 3.025 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 957.2 ± 1.1% | 1134.1 ± 1.3% | 897.6 ± 0.5% | 333.5 ± 1.1% | 362.7 ± 1.7% | 310.4 ± 1.4% | 0.844 | 1.066 | 2.870 | 2.639 | 3.084 |
| qlog records, JSON text sequence | 1467503 | 807.9 ± 0.3% | 866.4 ± 0.3% | 719.7 ± 0.4% | 323.3 ± 0.4% | 382.8 ± 1.4% | 232.2 ± 1.1% | 0.932 | 1.123 | 2.499 | 2.111 | 3.479 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.786 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.819 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.928 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.907 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.844 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.932 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1042.7 ± 6.0% | 0.470 | 0.970 | 1.021 | 1.028 | 0.404 | 1.014 | 1.030 | 0.355 | 0.781 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 854.8 ± 0.3% | 0.734 | 1.028 | 1.012 | 0.997 | 0.386 | 1.009 | 0.998 | 0.340 | 0.681 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1338.0 ± 1.0% | 0.441 | 0.980 | 0.973 | 1.000 | 0.998 | 0.234 | 0.998 | 0.445 | 0.722 | 0.086 | 1.019 |
| qlog records, JSON text sequence | 1467503 | 1162.9 ± 0.3% | 0.701 | 0.922 | 0.986 | 0.982 | 0.983 | 0.225 | 0.978 | 0.413 | 0.691 | 0.104 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1042.7 ± 6.0% | 1006.2 ± 1.2% | 984.9 ± 0.7% | 260.1 ± 3.6% | 531.5 ± 0.4% | 259.2 ± 3.1% | 1.036 | 1.059 | 4.009 | 1.962 | 4.023 |
| qlog records, JSON text sequence | 1467503 | 854.8 ± 0.3% | 807.2 ± 0.9% | 824.4 ± 0.3% | 223.2 ± 2.3% | 588.7 ± 4.1% | 245.4 ± 1.1% | 1.059 | 1.037 | 3.829 | 1.452 | 3.483 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1338.0 ± 1.0% | 1142.2 ± 0.5% | 838.2 ± 0.5% | 320.8 ± 4.1% | 354.7 ± 1.1% | 309.0 ± 5.7% | 1.171 | 1.596 | 4.171 | 3.772 | 4.330 |
| qlog records, JSON text sequence | 1467503 | 1162.9 ± 0.3% | 870.0 ± 0.4% | 726.5 ± 1.6% | 319.8 ± 0.5% | 395.7 ± 0.7% | 232.9 ± 4.7% | 1.337 | 1.601 | 3.636 | 2.939 | 4.993 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1363.0 ± 1.2% | 1142.2 ± 0.5% | 838.2 ± 0.5% | 320.8 ± 4.1% | 354.7 ± 1.1% | 309.0 ± 5.7% | 1.193 | 1.626 | 4.249 | 3.842 | 4.410 |
| qlog records, JSON text sequence | 1467503 | 1174.0 ± 1.0% | 870.0 ± 0.4% | 726.5 ± 1.6% | 319.8 ± 0.5% | 395.7 ± 0.7% | 232.9 ± 4.7% | 1.349 | 1.616 | 3.671 | 2.967 | 5.041 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 814.8 ± 0.4% | 1006.2 ± 1.2% | 984.9 ± 0.7% | 260.1 ± 3.6% | 531.5 ± 0.4% | 259.2 ± 3.1% | 0.810 | 0.827 | 3.133 | 1.533 | 3.143 |
| qlog records, JSON text sequence | 1467503 | 581.8 ± 1.2% | 807.2 ± 0.9% | 824.4 ± 0.3% | 223.2 ± 2.3% | 588.7 ± 4.1% | 245.4 ± 1.1% | 0.721 | 0.706 | 2.606 | 0.988 | 2.370 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 965.9 ± 0.7% | 1142.2 ± 0.5% | 838.2 ± 0.5% | 320.8 ± 4.1% | 354.7 ± 1.1% | 309.0 ± 5.7% | 0.846 | 1.152 | 3.011 | 2.723 | 3.125 |
| qlog records, JSON text sequence | 1467503 | 803.3 ± 5.9% | 870.0 ± 0.4% | 726.5 ± 1.6% | 319.8 ± 0.5% | 395.7 ± 0.7% | 232.9 ± 4.7% | 0.923 | 1.106 | 2.512 | 2.030 | 3.449 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.810 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.827 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.721 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.706 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.846 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.923 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1043.4 ± 3.2% | 0.461 | 1.007 | 1.055 | 1.018 | 0.412 | 1.037 | 1.022 | 0.355 | 0.738 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 828.7 ± 0.5% | 0.746 | 1.033 | 1.018 | 1.009 | 0.393 | 1.013 | 1.009 | 0.354 | 0.803 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.9 ± 0.7% | 0.437 | 0.975 | 0.974 | 0.997 | 1.003 | 0.229 | 1.003 | 0.439 | 0.720 | 0.086 | 1.021 |
| qlog records, JSON text sequence | 1467503 | 1163.4 ± 0.7% | 0.690 | 0.939 | 0.971 | 0.972 | 0.975 | 0.220 | 0.988 | 0.411 | 0.693 | 0.104 | 1.013 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.055 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1043.4 ± 3.2% | 1009.8 ± 0.3% | 988.2 ± 0.7% | 259.1 ± 1.3% | 530.7 ± 0.8% | 256.4 ± 2.5% | 1.033 | 1.056 | 4.027 | 1.966 | 4.070 |
| qlog records, JSON text sequence | 1467503 | 828.7 ± 0.5% | 811.5 ± 1.5% | 377.4 ± 0.3% | 222.2 ± 0.2% | 588.8 ± 0.5% | 245.9 ± 1.9% | 1.021 | 2.196 | 3.730 | 1.407 | 3.370 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.9 ± 0.7% | 1134.5 ± 5.9% | 897.8 ± 0.5% | 332.8 ± 2.5% | 360.7 ± 4.9% | 312.0 ± 1.1% | 1.179 | 1.490 | 4.020 | 3.709 | 4.288 |
| qlog records, JSON text sequence | 1467503 | 1163.4 ± 0.7% | 870.0 ± 1.5% | 726.9 ± 6.1% | 316.3 ± 0.8% | 394.2 ± 0.9% | 233.7 ± 0.9% | 1.337 | 1.600 | 3.678 | 2.951 | 4.978 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1365.6 ± 1.8% | 1134.5 ± 5.9% | 897.8 ± 0.5% | 332.8 ± 2.5% | 360.7 ± 4.9% | 312.0 ± 1.1% | 1.204 | 1.521 | 4.103 | 3.786 | 4.377 |
| qlog records, JSON text sequence | 1467503 | 1178.1 ± 0.4% | 870.0 ± 1.5% | 726.9 ± 6.1% | 316.3 ± 0.8% | 394.2 ± 0.9% | 233.7 ± 0.9% | 1.354 | 1.621 | 3.724 | 2.989 | 5.041 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 770.3 ± 1.5% | 1009.8 ± 0.3% | 988.2 ± 0.7% | 259.1 ± 1.3% | 530.7 ± 0.8% | 256.4 ± 2.5% | 0.763 | 0.780 | 2.973 | 1.452 | 3.005 |
| qlog records, JSON text sequence | 1467503 | 665.3 ± 2.0% | 811.5 ± 1.5% | 377.4 ± 0.3% | 222.2 ± 0.2% | 588.8 ± 0.5% | 245.9 ± 1.9% | 0.820 | 1.763 | 2.994 | 1.130 | 2.706 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 963.2 ± 1.0% | 1134.5 ± 5.9% | 897.8 ± 0.5% | 332.8 ± 2.5% | 360.7 ± 4.9% | 312.0 ± 1.1% | 0.849 | 1.073 | 2.894 | 2.670 | 3.087 |
| qlog records, JSON text sequence | 1467503 | 806.0 ± 1.2% | 870.0 ± 1.5% | 726.9 ± 6.1% | 316.3 ± 0.8% | 394.2 ± 0.9% | 233.7 ± 0.9% | 0.926 | 1.109 | 2.548 | 2.045 | 3.449 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.763 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.780 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.820 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.849 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1039.9 ± 8.8% | 0.463 | 1.019 | 1.053 | 1.038 | 0.414 | 1.047 | 1.004 | 0.356 | 0.775 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 842.8 ± 1.8% | 0.737 | 1.028 | 1.007 | 1.007 | 0.390 | 1.012 | 1.005 | 0.345 | 0.890 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1341.0 ± 0.8% | 0.435 | 0.977 | 0.964 | 0.995 | 1.009 | 0.228 | 1.006 | 0.439 | 0.720 | 0.086 | 1.019 |
| qlog records, JSON text sequence | 1467503 | 1165.3 ± 1.1% | 0.688 | 0.941 | 0.985 | 0.984 | 0.986 | 0.219 | 0.987 | 0.407 | 0.694 | 0.103 | 1.013 |

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
| CLDR supplemental, 34 texts | 920675 | 1039.9 ± 8.8% | 1022.6 ± 2.6% | 989.2 ± 0.9% | 258.5 ± 0.5% | 530.9 ± 0.9% | 259.0 ± 3.5% | 1.017 | 1.051 | 4.023 | 1.959 | 4.015 |
| qlog records, JSON text sequence | 1467503 | 842.8 ± 1.8% | 812.9 ± 0.1% | 826.5 ± 0.5% | 222.4 ± 1.7% | 589.4 ± 0.4% | 247.1 ± 1.9% | 1.037 | 1.020 | 3.789 | 1.430 | 3.410 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1341.0 ± 0.8% | 1140.6 ± 0.8% | 897.9 ± 4.7% | 332.7 ± 1.1% | 358.3 ± 4.2% | 311.9 ± 0.6% | 1.176 | 1.493 | 4.031 | 3.743 | 4.300 |
| qlog records, JSON text sequence | 1467503 | 1165.3 ± 1.1% | 868.6 ± 0.9% | 726.2 ± 0.5% | 323.1 ± 0.5% | 383.8 ± 1.8% | 233.0 ± 7.4% | 1.342 | 1.605 | 3.606 | 3.036 | 5.002 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1366.3 ± 0.8% | 1140.6 ± 0.8% | 897.9 ± 4.7% | 332.7 ± 1.1% | 358.3 ± 4.2% | 311.9 ± 0.6% | 1.198 | 1.522 | 4.107 | 3.813 | 4.381 |
| qlog records, JSON text sequence | 1467503 | 1181.0 ± 4.8% | 868.6 ± 0.9% | 726.2 ± 0.5% | 323.1 ± 0.5% | 383.8 ± 1.8% | 233.0 ± 7.4% | 1.360 | 1.626 | 3.655 | 3.077 | 5.069 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 806.3 ± 2.1% | 1022.6 ± 2.6% | 989.2 ± 0.9% | 258.5 ± 0.5% | 530.9 ± 0.9% | 259.0 ± 3.5% | 0.789 | 0.815 | 3.119 | 1.519 | 3.113 |
| qlog records, JSON text sequence | 1467503 | 750.5 ± 0.3% | 812.9 ± 0.1% | 826.5 ± 0.5% | 222.4 ± 1.7% | 589.4 ± 0.4% | 247.1 ± 1.9% | 0.923 | 0.908 | 3.374 | 1.273 | 3.037 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 965.1 ± 0.9% | 1140.6 ± 0.8% | 897.9 ± 4.7% | 332.7 ± 1.1% | 358.3 ± 4.2% | 311.9 ± 0.6% | 0.846 | 1.075 | 2.901 | 2.693 | 3.095 |
| qlog records, JSON text sequence | 1467503 | 808.4 ± 1.4% | 868.6 ± 0.9% | 726.2 ± 0.5% | 323.1 ± 0.5% | 383.8 ± 1.8% | 233.0 ± 7.4% | 0.931 | 1.113 | 2.502 | 2.106 | 3.470 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.789 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.815 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.923 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.908 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.846 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.931 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1045.6 ± 0.6% | 0.471 | 0.977 | 1.015 | 0.998 | 0.405 | 1.044 | 1.014 | 0.354 | 0.777 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 853.2 ± 5.2% | 0.733 | 1.034 | 1.016 | 1.002 | 0.390 | 1.011 | 1.004 | 0.342 | 0.684 | 0.107 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.6 ± 1.1% | 0.442 | 0.983 | 0.982 | 0.998 | 0.996 | 0.235 | 0.997 | 0.445 | 0.723 | 0.086 | 1.016 |
| qlog records, JSON text sequence | 1467503 | 1159.3 ± 5.6% | 0.704 | 0.925 | 0.992 | 0.985 | 0.989 | 0.228 | 0.990 | 0.411 | 0.695 | 0.104 | 1.013 |

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
| CLDR supplemental, 34 texts | 920675 | 1045.6 ± 0.6% | 1018.3 ± 0.5% | 986.1 ± 0.6% | 259.8 ± 0.5% | 531.0 ± 3.4% | 260.2 ± 2.1% | 1.027 | 1.060 | 4.025 | 1.969 | 4.018 |
| qlog records, JSON text sequence | 1467503 | 853.2 ± 5.2% | 703.0 ± 0.6% | 830.2 ± 0.6% | 223.3 ± 3.6% | 590.2 ± 0.3% | 245.8 ± 4.3% | 1.214 | 1.028 | 3.821 | 1.446 | 3.471 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.6 ± 1.1% | 1135.2 ± 0.6% | 899.0 ± 1.4% | 320.9 ± 0.4% | 358.7 ± 0.7% | 311.8 ± 4.2% | 1.177 | 1.487 | 4.165 | 3.727 | 4.286 |
| qlog records, JSON text sequence | 1467503 | 1159.3 ± 5.6% | 867.8 ± 1.0% | 726.4 ± 0.3% | 319.3 ± 0.4% | 394.5 ± 0.5% | 233.4 ± 1.3% | 1.336 | 1.596 | 3.630 | 2.939 | 4.968 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1358.1 ± 0.5% | 1135.2 ± 0.6% | 899.0 ± 1.4% | 320.9 ± 0.4% | 358.7 ± 0.7% | 311.8 ± 4.2% | 1.196 | 1.511 | 4.232 | 3.786 | 4.355 |
| qlog records, JSON text sequence | 1467503 | 1174.7 ± 4.4% | 867.8 ± 1.0% | 726.4 ± 0.3% | 319.3 ± 0.4% | 394.5 ± 0.5% | 233.4 ± 1.3% | 1.354 | 1.617 | 3.679 | 2.978 | 5.034 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 812.9 ± 0.7% | 1018.3 ± 0.5% | 986.1 ± 0.6% | 259.8 ± 0.5% | 531.0 ± 3.4% | 260.2 ± 2.1% | 0.798 | 0.824 | 3.129 | 1.531 | 3.124 |
| qlog records, JSON text sequence | 1467503 | 583.4 ± 4.7% | 703.0 ± 0.6% | 830.2 ± 0.6% | 223.3 ± 3.6% | 590.2 ± 0.3% | 245.8 ± 4.3% | 0.830 | 0.703 | 2.612 | 0.988 | 2.373 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 966.2 ± 0.7% | 1135.2 ± 0.6% | 899.0 ± 1.4% | 320.9 ± 0.4% | 358.7 ± 0.7% | 311.8 ± 4.2% | 0.851 | 1.075 | 3.010 | 2.694 | 3.098 |
| qlog records, JSON text sequence | 1467503 | 805.4 ± 1.5% | 867.8 ± 1.0% | 726.4 ± 0.3% | 319.3 ± 0.4% | 394.5 ± 0.5% | 233.4 ± 1.3% | 0.928 | 1.109 | 2.522 | 2.042 | 3.452 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.798 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.824 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.830 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.703 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.851 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.928 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1024.6 ± 5.3% | 0.468 | 1.015 | 1.073 | 1.060 | 0.418 | 1.060 | 1.066 | 0.361 | 0.758 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 843.7 ± 1.3% | 0.730 | 1.023 | 1.006 | 1.001 | 0.386 | 1.002 | 1.004 | 0.348 | 0.789 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.8 ± 0.8% | 0.437 | 0.972 | 0.965 | 0.998 | 1.009 | 0.228 | 1.007 | 0.439 | 0.718 | 0.086 | 1.012 |
| qlog records, JSON text sequence | 1467503 | 1160.5 ± 0.5% | 0.689 | 0.939 | 0.971 | 0.973 | 0.978 | 0.221 | 0.981 | 0.412 | 0.695 | 0.104 | 1.005 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.073 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.060 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.060 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1024.6 ± 5.3% | 995.0 ± 0.5% | 965.0 ± 0.5% | 256.4 ± 6.0% | 532.2 ± 0.4% | 258.2 ± 4.2% | 1.030 | 1.062 | 3.996 | 1.925 | 3.969 |
| qlog records, JSON text sequence | 1467503 | 843.7 ± 1.3% | 798.9 ± 1.0% | 817.3 ± 2.8% | 222.9 ± 1.6% | 590.0 ± 0.3% | 247.4 ± 1.2% | 1.056 | 1.032 | 3.785 | 1.430 | 3.410 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.8 ± 0.8% | 1144.1 ± 0.8% | 899.4 ± 1.3% | 332.4 ± 0.1% | 360.9 ± 3.4% | 312.0 ± 1.0% | 1.171 | 1.490 | 4.030 | 3.712 | 4.295 |
| qlog records, JSON text sequence | 1467503 | 1160.5 ± 0.5% | 871.2 ± 0.6% | 728.7 ± 0.8% | 323.5 ± 0.8% | 391.4 ± 2.1% | 232.3 ± 1.7% | 1.332 | 1.593 | 3.587 | 2.965 | 4.995 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1356.4 ± 1.7% | 1144.1 ± 0.8% | 899.4 ± 1.3% | 332.4 ± 0.1% | 360.9 ± 3.4% | 312.0 ± 1.0% | 1.186 | 1.508 | 4.081 | 3.758 | 4.348 |
| qlog records, JSON text sequence | 1467503 | 1166.6 ± 2.0% | 871.2 ± 0.6% | 728.7 ± 0.8% | 323.5 ± 0.8% | 391.4 ± 2.1% | 232.3 ± 1.7% | 1.339 | 1.601 | 3.606 | 2.980 | 5.021 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 776.5 ± 4.6% | 995.0 ± 0.5% | 965.0 ± 0.5% | 256.4 ± 6.0% | 532.2 ± 0.4% | 258.2 ± 4.2% | 0.780 | 0.805 | 3.028 | 1.459 | 3.007 |
| qlog records, JSON text sequence | 1467503 | 665.6 ± 3.1% | 798.9 ± 1.0% | 817.3 ± 2.8% | 222.9 ± 1.6% | 590.0 ± 0.3% | 247.4 ± 1.2% | 0.833 | 0.814 | 2.987 | 1.128 | 2.690 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 962.1 ± 1.4% | 1144.1 ± 0.8% | 899.4 ± 1.3% | 332.4 ± 0.1% | 360.9 ± 3.4% | 312.0 ± 1.0% | 0.841 | 1.070 | 2.894 | 2.666 | 3.084 |
| qlog records, JSON text sequence | 1467503 | 806.0 ± 0.5% | 871.2 ± 0.6% | 728.7 ± 0.8% | 323.5 ± 0.8% | 391.4 ± 2.1% | 232.3 ± 1.7% | 0.925 | 1.106 | 2.491 | 2.059 | 3.469 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.780 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.805 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.833 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.814 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.841 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.925 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1011.9 ± 4.5% | 0.475 | 1.022 | 1.086 | 1.078 | 0.424 | 1.074 | 1.079 | 0.366 | 0.790 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 842.3 ± 3.1% | 0.735 | 1.025 | 1.007 | 1.005 | 0.390 | 1.012 | 1.004 | 0.345 | 0.889 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1343.4 ± 3.9% | 0.436 | 0.974 | 0.968 | 0.996 | 1.003 | 0.228 | 1.002 | 0.440 | 0.719 | 0.085 | 1.015 |
| qlog records, JSON text sequence | 1467503 | 1160.5 ± 0.5% | 0.691 | 0.945 | 0.985 | 0.985 | 0.991 | 0.221 | 0.990 | 0.413 | 0.697 | 0.104 | 1.015 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.086 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.078 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.074 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.079 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1011.9 ± 4.5% | 1019.3 ± 1.2% | 988.6 ± 0.8% | 259.4 ± 0.7% | 530.5 ± 0.5% | 252.8 ± 3.9% | 0.993 | 1.024 | 3.901 | 1.908 | 4.003 |
| qlog records, JSON text sequence | 1467503 | 842.3 ± 3.1% | 813.1 ± 4.9% | 810.4 ± 2.2% | 222.3 ± 7.8% | 589.9 ± 0.3% | 246.6 ± 1.3% | 1.036 | 1.039 | 3.789 | 1.428 | 3.415 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1343.4 ± 3.9% | 1136.7 ± 1.1% | 900.4 ± 1.0% | 333.6 ± 0.5% | 362.3 ± 6.5% | 312.7 ± 0.7% | 1.182 | 1.492 | 4.027 | 3.708 | 4.297 |
| qlog records, JSON text sequence | 1467503 | 1160.5 ± 0.5% | 869.8 ± 0.5% | 728.4 ± 0.6% | 322.5 ± 0.4% | 387.5 ± 0.7% | 233.2 ± 1.9% | 1.334 | 1.593 | 3.598 | 2.995 | 4.977 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1363.2 ± 1.1% | 1136.7 ± 1.1% | 900.4 ± 1.0% | 333.6 ± 0.5% | 362.3 ± 6.5% | 312.7 ± 0.7% | 1.199 | 1.514 | 4.086 | 3.763 | 4.360 |
| qlog records, JSON text sequence | 1467503 | 1177.5 ± 2.3% | 869.8 ± 0.5% | 728.4 ± 0.6% | 322.5 ± 0.4% | 387.5 ± 0.7% | 233.2 ± 1.9% | 1.354 | 1.617 | 3.651 | 3.039 | 5.050 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 799.2 ± 3.6% | 1019.3 ± 1.2% | 988.6 ± 0.8% | 259.4 ± 0.7% | 530.5 ± 0.5% | 252.8 ± 3.9% | 0.784 | 0.808 | 3.081 | 1.507 | 3.162 |
| qlog records, JSON text sequence | 1467503 | 748.9 ± 4.4% | 813.1 ± 4.9% | 810.4 ± 2.2% | 222.3 ± 7.8% | 589.9 ± 0.3% | 246.6 ± 1.3% | 0.921 | 0.924 | 3.369 | 1.270 | 3.036 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 965.5 ± 1.1% | 1136.7 ± 1.1% | 900.4 ± 1.0% | 333.6 ± 0.5% | 362.3 ± 6.5% | 312.7 ± 0.7% | 0.849 | 1.072 | 2.894 | 2.665 | 3.088 |
| qlog records, JSON text sequence | 1467503 | 808.7 ± 0.5% | 869.8 ± 0.5% | 728.4 ± 0.6% | 322.5 ± 0.4% | 387.5 ± 0.7% | 233.2 ± 1.9% | 0.930 | 1.110 | 2.507 | 2.087 | 3.468 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.784 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.808 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.921 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.924 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.849 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.930 of simdjson.
