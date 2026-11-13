# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1401.7 ± 16.4% | 0.480 | 1.008 | 1.024 | 1.024 | 0.404 | 1.025 | 1.026 | 0.365 | 0.725 | 0.105 |
| qlog records, JSON text sequence | 1467503 | 1138.7 ± 1.7% | 0.759 | 1.052 | 1.022 | 1.028 | 0.379 | 1.022 | 1.029 | 0.353 | 0.677 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1774.4 ± 1.5% | 0.422 | 0.995 | 0.969 | 1.006 | 1.004 | 0.265 | 1.007 | 0.506 | 0.810 | 0.092 | 1.023 |
| qlog records, JSON text sequence | 1467503 | 1664.1 ± 1.8% | 0.642 | 0.966 | 0.987 | 1.002 | 0.991 | 0.237 | 0.992 | 0.439 | 0.746 | 0.107 | 1.042 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.052 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1401.7 ± 16.4% | 1502.5 ± 1.1% | 1115.2 ± 0.5% | 360.2 ± 0.5% | 670.6 ± 0.2% | 365.5 ± 1.8% | 0.933 | 1.257 | 3.892 | 2.090 | 3.835 |
| qlog records, JSON text sequence | 1467503 | 1138.7 ± 1.7% | 1234.3 ± 0.6% | 1139.0 ± 0.7% | 309.7 ± 2.6% | 757.3 ± 0.8% | 306.7 ± 1.0% | 0.923 | 1.000 | 3.677 | 1.504 | 3.713 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1774.4 ± 1.5% | 1498.2 ± 0.6% | 1029.6 ± 1.4% | 473.0 ± 0.2% | 469.8 ± 2.5% | 501.9 ± 0.7% | 1.184 | 1.723 | 3.751 | 3.777 | 3.536 |
| qlog records, JSON text sequence | 1467503 | 1664.1 ± 1.8% | 1235.1 ± 0.8% | 959.7 ± 0.9% | 449.1 ± 0.2% | 569.0 ± 2.4% | 355.9 ± 0.6% | 1.347 | 1.734 | 3.705 | 2.924 | 4.675 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1815.0 ± 0.5% | 1498.2 ± 0.6% | 1029.6 ± 1.4% | 473.0 ± 0.2% | 469.8 ± 2.5% | 501.9 ± 0.7% | 1.211 | 1.763 | 3.837 | 3.863 | 3.617 |
| qlog records, JSON text sequence | 1467503 | 1734.6 ± 0.3% | 1235.1 ± 0.8% | 959.7 ± 0.9% | 449.1 ± 0.2% | 569.0 ± 2.4% | 355.9 ± 0.6% | 1.404 | 1.807 | 3.862 | 3.048 | 4.873 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1015.7 ± 0.5% | 1502.5 ± 1.1% | 1115.2 ± 0.5% | 360.2 ± 0.5% | 670.6 ± 0.2% | 365.5 ± 1.8% | 0.676 | 0.911 | 2.820 | 1.514 | 2.779 |
| qlog records, JSON text sequence | 1467503 | 771.0 ± 0.6% | 1234.3 ± 0.6% | 1139.0 ± 0.7% | 309.7 ± 2.6% | 757.3 ± 0.8% | 306.7 ± 1.0% | 0.625 | 0.677 | 2.489 | 1.018 | 2.514 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1437.8 ± 0.3% | 1498.2 ± 0.6% | 1029.6 ± 1.4% | 473.0 ± 0.2% | 469.8 ± 2.5% | 501.9 ± 0.7% | 0.960 | 1.397 | 3.040 | 3.060 | 2.865 |
| qlog records, JSON text sequence | 1467503 | 1241.5 ± 0.3% | 1235.1 ± 0.8% | 959.7 ± 0.9% | 449.1 ± 0.2% | 569.0 ± 2.4% | 355.9 ± 0.6% | 1.005 | 1.294 | 2.765 | 2.182 | 3.488 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.923 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.676 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.911 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.625 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.677 of yyjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1432.6 ± 0.6% | 0.467 | 0.994 | 0.996 | 0.999 | 0.389 | 1.000 | 0.998 | 0.357 | 0.779 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 1162.0 ± 0.8% | 0.733 | 1.014 | 0.967 | 0.967 | 0.375 | 0.972 | 0.968 | 0.346 | 0.861 | 0.120 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1788.1 ± 2.3% | 0.426 | 0.975 | 0.965 | 0.997 | 0.992 | 0.271 | 0.993 | 0.504 | 0.808 | 0.089 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1676.9 ± 3.2% | 0.673 | 0.907 | 0.983 | 1.004 | 0.977 | 0.247 | 0.977 | 0.439 | 0.743 | 0.101 | 1.037 |

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
| CLDR supplemental, 34 texts | 920675 | 1432.6 ± 0.6% | 1504.4 ± 49.1% | 1087.7 ± 11.7% | 361.1 ± 1.0% | 669.3 ± 0.2% | 367.6 ± 2.2% | 0.952 | 1.317 | 3.968 | 2.140 | 3.897 |
| qlog records, JSON text sequence | 1467503 | 1162.0 ± 0.8% | 1239.9 ± 0.7% | 1092.0 ± 1.1% | 308.6 ± 1.9% | 734.8 ± 1.4% | 319.4 ± 2.0% | 0.937 | 1.064 | 3.765 | 1.581 | 3.638 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1788.1 ± 2.3% | 1499.7 ± 0.1% | 1032.1 ± 0.2% | 469.0 ± 0.2% | 468.3 ± 2.3% | 506.3 ± 0.6% | 1.192 | 1.732 | 3.812 | 3.818 | 3.531 |
| qlog records, JSON text sequence | 1467503 | 1676.9 ± 3.2% | 1226.7 ± 3.3% | 958.1 ± 0.3% | 439.2 ± 0.2% | 579.0 ± 0.2% | 354.0 ± 0.9% | 1.367 | 1.750 | 3.818 | 2.896 | 4.737 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1818.6 ± 0.5% | 1499.7 ± 0.1% | 1032.1 ± 0.2% | 469.0 ± 0.2% | 468.3 ± 2.3% | 506.3 ± 0.6% | 1.213 | 1.762 | 3.877 | 3.884 | 3.592 |
| qlog records, JSON text sequence | 1467503 | 1739.1 ± 0.2% | 1226.7 ± 3.3% | 958.1 ± 0.3% | 439.2 ± 0.2% | 579.0 ± 0.2% | 354.0 ± 0.9% | 1.418 | 1.815 | 3.959 | 3.004 | 4.913 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1116.5 ± 53.5% | 1504.4 ± 49.1% | 1087.7 ± 11.7% | 361.1 ± 1.0% | 669.3 ± 0.2% | 367.6 ± 2.2% | 0.742 | 1.026 | 3.092 | 1.668 | 3.037 |
| qlog records, JSON text sequence | 1467503 | 1000.8 ± 1.8% | 1239.9 ± 0.7% | 1092.0 ± 1.1% | 308.6 ± 1.9% | 734.8 ± 1.4% | 319.4 ± 2.0% | 0.807 | 0.916 | 3.243 | 1.362 | 3.133 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1444.5 ± 0.2% | 1499.7 ± 0.1% | 1032.1 ± 0.2% | 469.0 ± 0.2% | 468.3 ± 2.3% | 506.3 ± 0.6% | 0.963 | 1.400 | 3.080 | 3.085 | 2.853 |
| qlog records, JSON text sequence | 1467503 | 1245.7 ± 0.4% | 1226.7 ± 3.3% | 958.1 ± 0.3% | 439.2 ± 0.2% | 579.0 ± 0.2% | 354.0 ± 0.9% | 1.015 | 1.300 | 2.836 | 2.151 | 3.519 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.937 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.807 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.916 of yyjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1431.0 ± 33.3% | 0.469 | 0.995 | 0.997 | 0.999 | 0.393 | 1.002 | 1.000 | 0.357 | 0.801 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1168.3 ± 1.2% | 0.726 | 1.006 | 0.961 | 0.961 | 0.375 | 0.966 | 0.963 | 0.344 | 0.865 | 0.119 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1792.1 ± 2.0% | 0.426 | 0.974 | 0.964 | 0.995 | 0.992 | 0.271 | 0.993 | 0.496 | 0.806 | 0.089 | 1.019 |
| qlog records, JSON text sequence | 1467503 | 1690.1 ± 2.4% | 0.668 | 0.902 | 0.977 | 0.997 | 0.971 | 0.246 | 0.969 | 0.429 | 0.738 | 0.100 | 1.027 |

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
| CLDR supplemental, 34 texts | 920675 | 1431.0 ± 33.3% | 1495.0 ± 47.7% | 1114.6 ± 57.5% | 361.2 ± 40.7% | 670.4 ± 52.7% | 365.9 ± 64.7% | 0.957 | 1.284 | 3.962 | 2.134 | 3.911 |
| qlog records, JSON text sequence | 1467503 | 1168.3 ± 1.2% | 1206.4 ± 1.7% | 1101.1 ± 1.7% | 307.2 ± 2.1% | 732.7 ± 1.3% | 319.1 ± 1.4% | 0.968 | 1.061 | 3.803 | 1.595 | 3.662 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1792.1 ± 2.0% | 1499.7 ± 0.2% | 1033.2 ± 0.2% | 469.2 ± 0.2% | 470.1 ± 0.8% | 504.8 ± 0.6% | 1.195 | 1.735 | 3.820 | 3.813 | 3.550 |
| qlog records, JSON text sequence | 1467503 | 1690.1 ± 2.4% | 1248.9 ± 1.9% | 960.2 ± 3.7% | 439.0 ± 1.0% | 579.4 ± 1.0% | 355.1 ± 0.5% | 1.353 | 1.760 | 3.850 | 2.917 | 4.760 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1826.1 ± 0.4% | 1499.7 ± 0.2% | 1033.2 ± 0.2% | 469.2 ± 0.2% | 470.1 ± 0.8% | 504.8 ± 0.6% | 1.218 | 1.767 | 3.892 | 3.885 | 3.618 |
| qlog records, JSON text sequence | 1467503 | 1736.4 ± 0.3% | 1248.9 ± 1.9% | 960.2 ± 3.7% | 439.0 ± 1.0% | 579.4 ± 1.0% | 355.1 ± 0.5% | 1.390 | 1.808 | 3.955 | 2.997 | 4.891 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1146.8 ± 40.3% | 1495.0 ± 47.7% | 1114.6 ± 57.5% | 361.2 ± 40.7% | 670.4 ± 52.7% | 365.9 ± 64.7% | 0.767 | 1.029 | 3.175 | 1.710 | 3.134 |
| qlog records, JSON text sequence | 1467503 | 1010.0 ± 0.2% | 1206.4 ± 1.7% | 1101.1 ± 1.7% | 307.2 ± 2.1% | 732.7 ± 1.3% | 319.1 ± 1.4% | 0.837 | 0.917 | 3.288 | 1.378 | 3.165 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1445.1 ± 0.4% | 1499.7 ± 0.2% | 1033.2 ± 0.2% | 469.2 ± 0.2% | 470.1 ± 0.8% | 504.8 ± 0.6% | 0.964 | 1.399 | 3.080 | 3.074 | 2.863 |
| qlog records, JSON text sequence | 1467503 | 1247.2 ± 0.4% | 1248.9 ± 1.9% | 960.2 ± 3.7% | 439.0 ± 1.0% | 579.4 ± 1.0% | 355.1 ± 0.5% | 0.999 | 1.299 | 2.841 | 2.153 | 3.513 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.837 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.917 of yyjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1428.1 ± 0.8% | 0.475 | 1.007 | 1.025 | 1.024 | 0.396 | 1.025 | 1.025 | 0.357 | 0.713 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1139.6 ± 0.8% | 0.756 | 1.051 | 1.022 | 1.028 | 0.379 | 1.020 | 1.028 | 0.353 | 0.678 | 0.120 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1753.2 ± 1.0% | 0.427 | 1.006 | 0.977 | 1.013 | 1.014 | 0.268 | 1.014 | 0.512 | 0.820 | 0.094 | 1.035 |
| qlog records, JSON text sequence | 1467503 | 1678.7 ± 3.1% | 0.637 | 0.955 | 0.978 | 0.998 | 0.985 | 0.235 | 0.983 | 0.434 | 0.736 | 0.106 | 1.033 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.051 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1428.1 ± 0.8% | 1489.9 ± 0.8% | 1087.9 ± 0.3% | 361.2 ± 0.6% | 671.2 ± 0.6% | 365.2 ± 1.9% | 0.959 | 1.313 | 3.953 | 2.128 | 3.911 |
| qlog records, JSON text sequence | 1467503 | 1139.6 ± 0.8% | 1234.4 ± 1.2% | 1133.7 ± 0.3% | 310.7 ± 1.4% | 752.5 ± 0.7% | 316.1 ± 0.7% | 0.923 | 1.005 | 3.668 | 1.514 | 3.606 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1753.2 ± 1.0% | 1498.0 ± 0.1% | 1029.5 ± 0.2% | 472.5 ± 0.2% | 471.9 ± 2.0% | 502.6 ± 0.4% | 1.170 | 1.703 | 3.710 | 3.715 | 3.488 |
| qlog records, JSON text sequence | 1467503 | 1678.7 ± 3.1% | 1257.6 ± 1.7% | 959.5 ± 1.2% | 450.4 ± 0.9% | 569.5 ± 0.3% | 355.8 ± 0.8% | 1.335 | 1.750 | 3.727 | 2.948 | 4.718 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1814.9 ± 0.3% | 1498.0 ± 0.1% | 1029.5 ± 0.2% | 472.5 ± 0.2% | 471.9 ± 2.0% | 502.6 ± 0.4% | 1.212 | 1.763 | 3.841 | 3.846 | 3.611 |
| qlog records, JSON text sequence | 1467503 | 1734.7 ± 0.3% | 1257.6 ± 1.7% | 959.5 ± 1.2% | 450.4 ± 0.9% | 569.5 ± 0.3% | 355.8 ± 0.8% | 1.379 | 1.808 | 3.852 | 3.046 | 4.875 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1018.2 ± 0.3% | 1489.9 ± 0.8% | 1087.9 ± 0.3% | 361.2 ± 0.6% | 671.2 ± 0.6% | 365.2 ± 1.9% | 0.683 | 0.936 | 2.819 | 1.517 | 2.788 |
| qlog records, JSON text sequence | 1467503 | 772.4 ± 0.6% | 1234.4 ± 1.2% | 1133.7 ± 0.3% | 310.7 ± 1.4% | 752.5 ± 0.7% | 316.1 ± 0.7% | 0.626 | 0.681 | 2.486 | 1.026 | 2.444 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1437.2 ± 0.1% | 1498.0 ± 0.1% | 1029.5 ± 0.2% | 472.5 ± 0.2% | 471.9 ± 2.0% | 502.6 ± 0.4% | 0.959 | 1.396 | 3.042 | 3.046 | 2.859 |
| qlog records, JSON text sequence | 1467503 | 1234.8 ± 0.2% | 1257.6 ± 1.7% | 959.5 ± 1.2% | 450.4 ± 0.9% | 569.5 ± 0.3% | 355.8 ± 0.8% | 0.982 | 1.287 | 2.741 | 2.168 | 3.470 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.923 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.683 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.936 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.626 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.681 of yyjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1433.8 ± 0.5% | 0.469 | 0.993 | 0.996 | 0.998 | 0.373 | 1.001 | 0.999 | 0.356 | 0.784 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 1157.2 ± 0.7% | 0.735 | 1.020 | 0.970 | 0.973 | 0.359 | 0.977 | 0.973 | 0.347 | 0.865 | 0.120 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1795.7 ± 0.7% | 0.425 | 0.971 | 0.961 | 0.991 | 0.990 | 0.271 | 0.989 | 0.502 | 0.805 | 0.089 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1680.5 ± 3.0% | 0.670 | 0.906 | 0.982 | 1.001 | 0.975 | 0.246 | 0.976 | 0.439 | 0.742 | 0.100 | 1.035 |

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
| CLDR supplemental, 34 texts | 920675 | 1433.8 ± 0.5% | 1507.8 ± 0.8% | 1088.3 ± 0.3% | 361.3 ± 0.4% | 670.6 ± 0.3% | 366.8 ± 2.0% | 0.951 | 1.317 | 3.968 | 2.138 | 3.909 |
| qlog records, JSON text sequence | 1467503 | 1157.2 ± 0.7% | 1222.7 ± 1.2% | 1091.6 ± 0.4% | 306.7 ± 1.4% | 728.8 ± 1.1% | 318.4 ± 1.2% | 0.946 | 1.060 | 3.773 | 1.588 | 3.635 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1795.7 ± 0.7% | 1500.7 ± 0.1% | 1032.0 ± 0.3% | 469.3 ± 0.3% | 465.6 ± 1.9% | 505.4 ± 0.8% | 1.197 | 1.740 | 3.826 | 3.857 | 3.553 |
| qlog records, JSON text sequence | 1467503 | 1680.5 ± 3.0% | 1218.6 ± 3.7% | 956.5 ± 0.6% | 440.4 ± 0.4% | 577.9 ± 0.7% | 355.1 ± 0.5% | 1.379 | 1.757 | 3.816 | 2.908 | 4.732 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1826.5 ± 1.0% | 1500.7 ± 0.1% | 1032.0 ± 0.3% | 469.3 ± 0.3% | 465.6 ± 1.9% | 505.4 ± 0.8% | 1.217 | 1.770 | 3.892 | 3.923 | 3.614 |
| qlog records, JSON text sequence | 1467503 | 1738.6 ± 0.7% | 1218.6 ± 3.7% | 956.5 ± 0.6% | 440.4 ± 0.4% | 577.9 ± 0.7% | 355.1 ± 0.5% | 1.427 | 1.818 | 3.948 | 3.008 | 4.896 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1123.4 ± 0.9% | 1507.8 ± 0.8% | 1088.3 ± 0.3% | 361.3 ± 0.4% | 670.6 ± 0.3% | 366.8 ± 2.0% | 0.745 | 1.032 | 3.109 | 1.675 | 3.063 |
| qlog records, JSON text sequence | 1467503 | 1001.1 ± 2.6% | 1222.7 ± 1.2% | 1091.6 ± 0.4% | 306.7 ± 1.4% | 728.8 ± 1.1% | 318.4 ± 1.2% | 0.819 | 0.917 | 3.264 | 1.374 | 3.145 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1445.7 ± 0.1% | 1500.7 ± 0.1% | 1032.0 ± 0.3% | 469.3 ± 0.3% | 465.6 ± 1.9% | 505.4 ± 0.8% | 0.963 | 1.401 | 3.081 | 3.105 | 2.861 |
| qlog records, JSON text sequence | 1467503 | 1246.1 ± 0.2% | 1218.6 ± 3.7% | 956.5 ± 0.6% | 440.4 ± 0.4% | 577.9 ± 0.7% | 355.1 ± 0.5% | 1.023 | 1.303 | 2.830 | 2.156 | 3.509 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.946 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.745 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.819 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.917 of yyjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1432.7 ± 0.3% | 0.469 | 0.995 | 0.997 | 0.999 | 0.394 | 1.002 | 0.999 | 0.357 | 0.799 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1161.7 ± 5.4% | 0.732 | 1.015 | 0.968 | 0.969 | 0.378 | 0.974 | 0.969 | 0.345 | 0.869 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1801.7 ± 2.3% | 0.423 | 0.968 | 0.959 | 0.990 | 0.985 | 0.268 | 0.986 | 0.499 | 0.803 | 0.089 | 1.011 |
| qlog records, JSON text sequence | 1467503 | 1721.6 ± 2.3% | 0.655 | 0.884 | 0.960 | 0.977 | 0.955 | 0.240 | 0.953 | 0.420 | 0.724 | 0.098 | 1.009 |

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
| CLDR supplemental, 34 texts | 920675 | 1432.7 ± 0.3% | 1506.3 ± 1.2% | 1113.9 ± 0.5% | 360.9 ± 0.7% | 669.7 ± 0.2% | 366.7 ± 1.7% | 0.951 | 1.286 | 3.970 | 2.139 | 3.907 |
| qlog records, JSON text sequence | 1467503 | 1161.7 ± 5.4% | 1244.0 ± 1.1% | 1115.0 ± 1.3% | 308.9 ± 1.7% | 731.9 ± 1.1% | 318.9 ± 0.4% | 0.934 | 1.042 | 3.761 | 1.587 | 3.643 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1801.7 ± 2.3% | 1504.6 ± 0.5% | 1032.5 ± 0.2% | 469.8 ± 0.2% | 470.0 ± 2.2% | 504.0 ± 1.0% | 1.197 | 1.745 | 3.835 | 3.834 | 3.575 |
| qlog records, JSON text sequence | 1467503 | 1721.6 ± 2.3% | 1252.3 ± 1.4% | 959.2 ± 0.4% | 441.9 ± 2.4% | 579.0 ± 0.5% | 353.6 ± 9.2% | 1.375 | 1.795 | 3.896 | 2.974 | 4.868 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1821.5 ± 0.6% | 1504.6 ± 0.5% | 1032.5 ± 0.2% | 469.8 ± 0.2% | 470.0 ± 2.2% | 504.0 ± 1.0% | 1.211 | 1.764 | 3.877 | 3.876 | 3.614 |
| qlog records, JSON text sequence | 1467503 | 1736.5 ± 0.4% | 1252.3 ± 1.4% | 959.2 ± 0.4% | 441.9 ± 2.4% | 579.0 ± 0.5% | 353.6 ± 9.2% | 1.387 | 1.810 | 3.929 | 2.999 | 4.911 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1144.1 ± 0.5% | 1506.3 ± 1.2% | 1113.9 ± 0.5% | 360.9 ± 0.7% | 669.7 ± 0.2% | 366.7 ± 1.7% | 0.759 | 1.027 | 3.170 | 1.708 | 3.120 |
| qlog records, JSON text sequence | 1467503 | 1009.5 ± 0.8% | 1244.0 ± 1.1% | 1115.0 ± 1.3% | 308.9 ± 1.7% | 731.9 ± 1.1% | 318.9 ± 0.4% | 0.811 | 0.905 | 3.268 | 1.379 | 3.165 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1446.4 ± 1.3% | 1504.6 ± 0.5% | 1032.5 ± 0.2% | 469.8 ± 0.2% | 470.0 ± 2.2% | 504.0 ± 1.0% | 0.961 | 1.401 | 3.079 | 3.078 | 2.870 |
| qlog records, JSON text sequence | 1467503 | 1247.3 ± 0.3% | 1252.3 ± 1.4% | 959.2 ± 0.4% | 441.9 ± 2.4% | 579.0 ± 0.5% | 353.6 ± 9.2% | 0.996 | 1.300 | 2.822 | 2.154 | 3.527 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.934 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.759 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.811 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.905 of yyjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1427.7 ± 0.8% | 0.475 | 1.009 | 1.026 | 1.027 | 0.398 | 1.026 | 1.028 | 0.358 | 0.714 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1136.8 ± 0.6% | 0.760 | 1.053 | 1.025 | 1.030 | 0.381 | 1.022 | 1.030 | 0.354 | 0.682 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1780.6 ± 1.1% | 0.420 | 0.991 | 0.962 | 1.002 | 0.999 | 0.265 | 1.001 | 0.504 | 0.809 | 0.092 | 1.019 |
| qlog records, JSON text sequence | 1467503 | 1703.8 ± 2.0% | 0.628 | 0.943 | 0.960 | 0.979 | 0.970 | 0.232 | 0.969 | 0.428 | 0.729 | 0.104 | 1.018 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.053 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1427.7 ± 0.8% | 1510.0 ± 1.1% | 1118.3 ± 0.5% | 362.2 ± 0.7% | 672.1 ± 0.3% | 366.1 ± 2.0% | 0.946 | 1.277 | 3.942 | 2.124 | 3.899 |
| qlog records, JSON text sequence | 1467503 | 1136.8 ± 0.6% | 1235.2 ± 0.9% | 1144.6 ± 0.7% | 308.5 ± 1.8% | 757.0 ± 3.3% | 306.6 ± 1.7% | 0.920 | 0.993 | 3.685 | 1.502 | 3.708 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1780.6 ± 1.1% | 1501.7 ± 0.2% | 1029.9 ± 0.1% | 473.7 ± 0.6% | 469.1 ± 2.8% | 502.3 ± 0.3% | 1.186 | 1.729 | 3.759 | 3.796 | 3.545 |
| qlog records, JSON text sequence | 1467503 | 1703.8 ± 2.0% | 1264.1 ± 4.6% | 955.6 ± 2.1% | 450.1 ± 1.0% | 567.7 ± 1.7% | 355.9 ± 1.3% | 1.348 | 1.783 | 3.786 | 3.001 | 4.787 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1814.1 ± 0.3% | 1501.7 ± 0.2% | 1029.9 ± 0.1% | 473.7 ± 0.6% | 469.1 ± 2.8% | 502.3 ± 0.3% | 1.208 | 1.761 | 3.829 | 3.867 | 3.612 |
| qlog records, JSON text sequence | 1467503 | 1735.1 ± 0.7% | 1264.1 ± 4.6% | 955.6 ± 2.1% | 450.1 ± 1.0% | 567.7 ± 1.7% | 355.9 ± 1.3% | 1.373 | 1.816 | 3.855 | 3.057 | 4.875 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1018.8 ± 0.3% | 1510.0 ± 1.1% | 1118.3 ± 0.5% | 362.2 ± 0.7% | 672.1 ± 0.3% | 366.1 ± 2.0% | 0.675 | 0.911 | 2.813 | 1.516 | 2.783 |
| qlog records, JSON text sequence | 1467503 | 774.8 ± 0.6% | 1235.2 ± 0.9% | 1144.6 ± 0.7% | 308.5 ± 1.8% | 757.0 ± 3.3% | 306.6 ± 1.7% | 0.627 | 0.677 | 2.512 | 1.024 | 2.527 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1439.6 ± 0.2% | 1501.7 ± 0.2% | 1029.9 ± 0.1% | 473.7 ± 0.6% | 469.1 ± 2.8% | 502.3 ± 0.3% | 0.959 | 1.398 | 3.039 | 3.069 | 2.866 |
| qlog records, JSON text sequence | 1467503 | 1242.0 ± 2.0% | 1264.1 ± 4.6% | 955.6 ± 2.1% | 450.1 ± 1.0% | 567.7 ± 1.7% | 355.9 ± 1.3% | 0.983 | 1.300 | 2.760 | 2.188 | 3.490 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.946 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.920 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.675 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.911 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.627 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.677 of yyjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1438.1 ± 1.5% | 0.468 | 0.992 | 0.993 | 0.996 | 0.392 | 0.999 | 0.997 | 0.355 | 0.781 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 1156.8 ± 0.4% | 0.733 | 1.020 | 0.970 | 0.973 | 0.379 | 0.976 | 0.973 | 0.347 | 0.866 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1794.6 ± 1.7% | 0.425 | 0.972 | 0.961 | 0.990 | 0.989 | 0.271 | 0.992 | 0.501 | 0.805 | 0.089 | 1.015 |
| qlog records, JSON text sequence | 1467503 | 1716.9 ± 3.4% | 0.658 | 0.889 | 0.963 | 0.979 | 0.956 | 0.241 | 0.954 | 0.430 | 0.726 | 0.098 | 1.013 |

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
| CLDR supplemental, 34 texts | 920675 | 1438.1 ± 1.5% | 1517.6 ± 1.8% | 1114.9 ± 0.5% | 362.1 ± 0.6% | 669.1 ± 0.2% | 366.6 ± 1.7% | 0.948 | 1.290 | 3.972 | 2.149 | 3.923 |
| qlog records, JSON text sequence | 1467503 | 1156.8 ± 0.4% | 1239.2 ± 0.8% | 1116.0 ± 1.0% | 308.2 ± 2.1% | 733.1 ± 1.9% | 318.9 ± 1.2% | 0.933 | 1.037 | 3.753 | 1.578 | 3.627 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1794.6 ± 1.7% | 1495.9 ± 1.4% | 1030.9 ± 0.5% | 469.2 ± 0.3% | 467.9 ± 1.2% | 505.1 ± 0.5% | 1.200 | 1.741 | 3.825 | 3.835 | 3.553 |
| qlog records, JSON text sequence | 1467503 | 1716.9 ± 3.4% | 1248.6 ± 1.4% | 958.9 ± 0.6% | 441.7 ± 0.7% | 578.7 ± 0.8% | 355.2 ± 1.3% | 1.375 | 1.790 | 3.887 | 2.967 | 4.833 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1822.3 ± 0.5% | 1495.9 ± 1.4% | 1030.9 ± 0.5% | 469.2 ± 0.3% | 467.9 ± 1.2% | 505.1 ± 0.5% | 1.218 | 1.768 | 3.884 | 3.894 | 3.608 |
| qlog records, JSON text sequence | 1467503 | 1739.2 ± 0.4% | 1248.6 ± 1.4% | 958.9 ± 0.6% | 441.7 ± 0.7% | 578.7 ± 0.8% | 355.2 ± 1.3% | 1.393 | 1.814 | 3.938 | 3.005 | 4.896 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1123.7 ± 1.2% | 1517.6 ± 1.8% | 1114.9 ± 0.5% | 362.1 ± 0.6% | 669.1 ± 0.2% | 366.6 ± 1.7% | 0.740 | 1.008 | 3.104 | 1.680 | 3.065 |
| qlog records, JSON text sequence | 1467503 | 1001.3 ± 1.0% | 1239.2 ± 0.8% | 1116.0 ± 1.0% | 308.2 ± 2.1% | 733.1 ± 1.9% | 318.9 ± 1.2% | 0.808 | 0.897 | 3.249 | 1.366 | 3.140 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1444.4 ± 1.1% | 1495.9 ± 1.4% | 1030.9 ± 0.5% | 469.2 ± 0.3% | 467.9 ± 1.2% | 505.1 ± 0.5% | 0.966 | 1.401 | 3.079 | 3.087 | 2.860 |
| qlog records, JSON text sequence | 1467503 | 1246.9 ± 0.3% | 1248.6 ± 1.4% | 958.9 ± 0.6% | 441.7 ± 0.7% | 578.7 ± 0.8% | 355.2 ± 1.3% | 0.999 | 1.300 | 2.823 | 2.154 | 3.510 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.948 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.933 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.740 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.808 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.897 of yyjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1437.2 ± 1.1% | 0.468 | 0.992 | 0.994 | 0.997 | 0.392 | 1.000 | 0.997 | 0.356 | 0.799 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1164.1 ± 0.7% | 0.733 | 1.013 | 0.962 | 0.964 | 0.376 | 0.970 | 0.965 | 0.345 | 0.866 | 0.120 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1808.3 ± 1.1% | 0.422 | 0.963 | 0.955 | 0.986 | 0.985 | 0.267 | 0.985 | 0.498 | 0.800 | 0.089 | 1.009 |
| qlog records, JSON text sequence | 1467503 | 1717.2 ± 0.7% | 0.657 | 0.886 | 0.966 | 0.979 | 0.956 | 0.240 | 0.957 | 0.421 | 0.724 | 0.098 | 1.011 |

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
| CLDR supplemental, 34 texts | 920675 | 1437.2 ± 1.1% | 1524.8 ± 0.8% | 1117.2 ± 1.0% | 360.3 ± 0.5% | 670.6 ± 0.3% | 368.0 ± 2.6% | 0.943 | 1.286 | 3.989 | 2.143 | 3.906 |
| qlog records, JSON text sequence | 1467503 | 1164.1 ± 0.7% | 1232.9 ± 1.0% | 1112.5 ± 0.6% | 307.9 ± 1.4% | 733.5 ± 2.1% | 319.6 ± 1.6% | 0.944 | 1.046 | 3.781 | 1.587 | 3.642 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1808.3 ± 1.1% | 1495.4 ± 1.0% | 1032.9 ± 1.6% | 469.4 ± 0.5% | 467.5 ± 2.2% | 505.7 ± 0.3% | 1.209 | 1.751 | 3.852 | 3.868 | 3.576 |
| qlog records, JSON text sequence | 1467503 | 1717.2 ± 0.7% | 1249.6 ± 1.4% | 956.0 ± 0.6% | 442.4 ± 1.1% | 573.6 ± 1.5% | 355.6 ± 0.8% | 1.374 | 1.796 | 3.882 | 2.994 | 4.829 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1825.0 ± 0.3% | 1495.4 ± 1.0% | 1032.9 ± 1.6% | 469.4 ± 0.5% | 467.5 ± 2.2% | 505.7 ± 0.3% | 1.220 | 1.767 | 3.888 | 3.903 | 3.609 |
| qlog records, JSON text sequence | 1467503 | 1735.3 ± 0.1% | 1249.6 ± 1.4% | 956.0 ± 0.6% | 442.4 ± 1.1% | 573.6 ± 1.5% | 355.6 ± 0.8% | 1.389 | 1.815 | 3.923 | 3.025 | 4.880 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1147.8 ± 0.2% | 1524.8 ± 0.8% | 1117.2 ± 1.0% | 360.3 ± 0.5% | 670.6 ± 0.3% | 368.0 ± 2.6% | 0.753 | 1.027 | 3.186 | 1.712 | 3.119 |
| qlog records, JSON text sequence | 1467503 | 1007.6 ± 0.6% | 1232.9 ± 1.0% | 1112.5 ± 0.6% | 307.9 ± 1.4% | 733.5 ± 2.1% | 319.6 ± 1.6% | 0.817 | 0.906 | 3.272 | 1.374 | 3.152 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1446.6 ± 0.4% | 1495.4 ± 1.0% | 1032.9 ± 1.6% | 469.4 ± 0.5% | 467.5 ± 2.2% | 505.7 ± 0.3% | 0.967 | 1.400 | 3.081 | 3.094 | 2.860 |
| qlog records, JSON text sequence | 1467503 | 1244.0 ± 0.5% | 1249.6 ± 1.4% | 956.0 ± 0.6% | 442.4 ± 1.1% | 573.6 ± 1.5% | 355.6 ± 0.8% | 0.995 | 1.301 | 2.812 | 2.169 | 3.498 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.943 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.944 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.753 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.817 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.906 of yyjson.
