# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.4 ± 0.3% | 0.535 | 0.967 | 0.994 | 0.997 | 0.458 | 1.001 | 1.006 | 0.384 | 0.682 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 847.1 ± 0.4% | 0.831 | 0.992 | 0.976 | 0.980 | 0.445 | 1.004 | 0.999 | 0.382 | 0.642 | 0.124 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1482.3 ± 1.2% | 0.442 | 1.001 | 0.969 | 1.004 | 1.005 | 0.266 | 0.996 | 0.546 | 0.827 | 0.089 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1254.1 ± 2.3% | 0.694 | 0.982 | 1.014 | 1.008 | 1.006 | 0.265 | 0.990 | 0.504 | 0.791 | 0.109 | 1.012 |

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
| CLDR supplemental, 34 texts | 920675 | 1127.4 ± 0.3% | 922.3 ± 1.3% | 1022.9 ± 0.1% | 299.8 ± 0.3% | 665.1 ± 0.2% | 307.3 ± 1.5% | 1.222 | 1.102 | 3.760 | 1.695 | 3.669 |
| qlog records, JSON text sequence | 1467503 | 847.1 ± 0.4% | 815.9 ± 0.2% | 745.7 ± 1.5% | 242.2 ± 0.9% | 693.6 ± 1.1% | 245.4 ± 1.5% | 1.038 | 1.136 | 3.498 | 1.221 | 3.452 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1482.3 ± 1.2% | 1245.5 ± 0.7% | 1025.7 ± 1.1% | 412.9 ± 0.2% | 447.0 ± 0.1% | 417.6 ± 0.5% | 1.190 | 1.445 | 3.590 | 3.316 | 3.550 |
| qlog records, JSON text sequence | 1467503 | 1254.1 ± 2.3% | 1037.8 ± 0.9% | 775.4 ± 1.6% | 382.0 ± 0.3% | 465.2 ± 1.3% | 277.8 ± 1.6% | 1.208 | 1.617 | 3.283 | 2.696 | 4.514 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1515.4 ± 0.6% | 1245.5 ± 0.7% | 1025.7 ± 1.1% | 412.9 ± 0.2% | 447.0 ± 0.1% | 417.6 ± 0.5% | 1.217 | 1.477 | 3.670 | 3.390 | 3.629 |
| qlog records, JSON text sequence | 1467503 | 1269.1 ± 57.1% | 1037.8 ± 0.9% | 775.4 ± 1.6% | 382.0 ± 0.3% | 465.2 ± 1.3% | 277.8 ± 1.6% | 1.223 | 1.637 | 3.322 | 2.728 | 4.568 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 768.4 ± 0.5% | 922.3 ± 1.3% | 1022.9 ± 0.1% | 299.8 ± 0.3% | 665.1 ± 0.2% | 307.3 ± 1.5% | 0.833 | 0.751 | 2.563 | 1.155 | 2.501 |
| qlog records, JSON text sequence | 1467503 | 543.5 ± 0.7% | 815.9 ± 0.2% | 745.7 ± 1.5% | 242.2 ± 0.9% | 693.6 ± 1.1% | 245.4 ± 1.5% | 0.666 | 0.729 | 2.244 | 0.784 | 2.215 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1225.6 ± 0.5% | 1245.5 ± 0.7% | 1025.7 ± 1.1% | 412.9 ± 0.2% | 447.0 ± 0.1% | 417.6 ± 0.5% | 0.984 | 1.195 | 2.968 | 2.742 | 2.935 |
| qlog records, JSON text sequence | 1467503 | 991.5 ± 0.3% | 1037.8 ± 0.9% | 775.4 ± 1.6% | 382.0 ± 0.3% | 465.2 ± 1.3% | 277.8 ± 1.6% | 0.955 | 1.279 | 2.595 | 2.131 | 3.569 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.833 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.751 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.666 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.729 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.784 of serde_json.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1124.2 ± 0.3% | 0.535 | 0.970 | 1.009 | 1.010 | 0.461 | 1.003 | 0.999 | 0.387 | 0.816 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 830.8 ± 2.0% | 0.844 | 1.022 | 1.020 | 1.022 | 0.450 | 1.036 | 1.023 | 0.385 | 0.843 | 0.127 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1472.1 ± 13.1% | 0.447 | 1.003 | 0.972 | 1.012 | 1.012 | 0.272 | 1.004 | 0.550 | 0.835 | 0.090 | 1.033 |
| qlog records, JSON text sequence | 1467503 | 1237.6 ± 1.1% | 0.709 | 0.980 | 1.020 | 1.018 | 1.020 | 0.273 | 0.995 | 0.507 | 0.802 | 0.109 | 1.026 |

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
| CLDR supplemental, 34 texts | 920675 | 1124.2 ± 0.3% | 927.2 ± 0.5% | 1019.6 ± 2.8% | 299.8 ± 0.2% | 668.5 ± 0.3% | 307.5 ± 1.6% | 1.212 | 1.103 | 3.750 | 1.682 | 3.655 |
| qlog records, JSON text sequence | 1467503 | 830.8 ± 2.0% | 817.1 ± 0.1% | 740.3 ± 2.1% | 240.4 ± 0.6% | 691.5 ± 1.9% | 241.0 ± 2.4% | 1.017 | 1.122 | 3.456 | 1.201 | 3.447 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1472.1 ± 13.1% | 1247.5 ± 0.7% | 1031.9 ± 0.4% | 410.6 ± 0.3% | 449.1 ± 0.1% | 415.0 ± 4.4% | 1.180 | 1.427 | 3.585 | 3.278 | 3.548 |
| qlog records, JSON text sequence | 1467503 | 1237.6 ± 1.1% | 1047.1 ± 1.3% | 779.9 ± 2.1% | 364.2 ± 1.5% | 474.6 ± 1.2% | 277.0 ± 0.8% | 1.182 | 1.587 | 3.398 | 2.608 | 4.468 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1520.8 ± 0.6% | 1247.5 ± 0.7% | 1031.9 ± 0.4% | 410.6 ± 0.3% | 449.1 ± 0.1% | 415.0 ± 4.4% | 1.219 | 1.474 | 3.704 | 3.386 | 3.665 |
| qlog records, JSON text sequence | 1467503 | 1270.1 ± 1.6% | 1047.1 ± 1.3% | 779.9 ± 2.1% | 364.2 ± 1.5% | 474.6 ± 1.2% | 277.0 ± 0.8% | 1.213 | 1.629 | 3.487 | 2.676 | 4.585 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 917.4 ± 0.1% | 927.2 ± 0.5% | 1019.6 ± 2.8% | 299.8 ± 0.2% | 668.5 ± 0.3% | 307.5 ± 1.6% | 0.989 | 0.900 | 3.060 | 1.372 | 2.983 |
| qlog records, JSON text sequence | 1467503 | 700.2 ± 1.1% | 817.1 ± 0.1% | 740.3 ± 2.1% | 240.4 ± 0.6% | 691.5 ± 1.9% | 241.0 ± 2.4% | 0.857 | 0.946 | 2.913 | 1.013 | 2.905 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1228.7 ± 0.3% | 1247.5 ± 0.7% | 1031.9 ± 0.4% | 410.6 ± 0.3% | 449.1 ± 0.1% | 415.0 ± 4.4% | 0.985 | 1.191 | 2.992 | 2.736 | 2.961 |
| qlog records, JSON text sequence | 1467503 | 992.9 ± 0.6% | 1047.1 ± 1.3% | 779.9 ± 2.1% | 364.2 ± 1.5% | 474.6 ± 1.2% | 277.0 ± 0.8% | 0.948 | 1.273 | 2.726 | 2.092 | 3.584 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.900 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.857 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.946 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.948 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 1

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1126.1 ± 0.5% | 0.534 | 0.968 | 1.006 | 1.008 | 0.460 | 1.001 | 0.997 | 0.386 | 0.812 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 840.5 ± 0.6% | 0.836 | 1.008 | 1.006 | 1.010 | 0.436 | 1.025 | 1.012 | 0.382 | 0.865 | 0.125 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1476.3 ± 1.0% | 0.444 | 1.003 | 0.968 | 1.008 | 1.008 | 0.270 | 0.996 | 0.547 | 0.829 | 0.089 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1240.4 ± 1.2% | 0.706 | 0.985 | 1.010 | 1.009 | 1.015 | 0.272 | 0.990 | 0.508 | 0.800 | 0.109 | 1.024 |

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
| CLDR supplemental, 34 texts | 920675 | 1126.1 ± 0.5% | 928.0 ± 0.5% | 988.2 ± 0.4% | 300.1 ± 0.3% | 668.9 ± 0.6% | 308.8 ± 1.5% | 1.214 | 1.140 | 3.752 | 1.683 | 3.646 |
| qlog records, JSON text sequence | 1467503 | 840.5 ± 0.6% | 817.2 ± 0.1% | 731.0 ± 3.3% | 239.5 ± 1.0% | 696.8 ± 0.4% | 246.5 ± 2.8% | 1.029 | 1.150 | 3.509 | 1.206 | 3.409 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1476.3 ± 1.0% | 1245.9 ± 10.1% | 1029.5 ± 9.9% | 410.0 ± 11.9% | 448.5 ± 1.2% | 413.0 ± 0.7% | 1.185 | 1.434 | 3.601 | 3.291 | 3.574 |
| qlog records, JSON text sequence | 1467503 | 1240.4 ± 1.2% | 1050.0 ± 0.8% | 771.1 ± 1.1% | 362.3 ± 1.1% | 460.7 ± 2.3% | 275.0 ± 0.9% | 1.181 | 1.609 | 3.424 | 2.693 | 4.510 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1515.6 ± 0.6% | 1245.9 ± 10.1% | 1029.5 ± 9.9% | 410.0 ± 11.9% | 448.5 ± 1.2% | 413.0 ± 0.7% | 1.216 | 1.472 | 3.697 | 3.379 | 3.669 |
| qlog records, JSON text sequence | 1467503 | 1270.6 ± 0.5% | 1050.0 ± 0.8% | 771.1 ± 1.1% | 362.3 ± 1.1% | 460.7 ± 2.3% | 275.0 ± 0.9% | 1.210 | 1.648 | 3.507 | 2.758 | 4.620 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 914.7 ± 0.2% | 928.0 ± 0.5% | 988.2 ± 0.4% | 300.1 ± 0.3% | 668.9 ± 0.6% | 308.8 ± 1.5% | 0.986 | 0.926 | 3.048 | 1.367 | 2.962 |
| qlog records, JSON text sequence | 1467503 | 727.0 ± 0.8% | 817.2 ± 0.1% | 731.0 ± 3.3% | 239.5 ± 1.0% | 696.8 ± 0.4% | 246.5 ± 2.8% | 0.890 | 0.994 | 3.035 | 1.043 | 2.949 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1224.4 ± 8.1% | 1245.9 ± 10.1% | 1029.5 ± 9.9% | 410.0 ± 11.9% | 448.5 ± 1.2% | 413.0 ± 0.7% | 0.983 | 1.189 | 2.986 | 2.730 | 2.964 |
| qlog records, JSON text sequence | 1467503 | 992.4 ± 0.4% | 1050.0 ± 0.8% | 771.1 ± 1.1% | 362.3 ± 1.1% | 460.7 ± 2.3% | 275.0 ± 0.9% | 0.945 | 1.287 | 2.739 | 2.154 | 3.608 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.926 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.890 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.945 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 1

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1123.7 ± 0.4% | 0.535 | 0.969 | 1.009 | 1.011 | 0.461 | 1.004 | 1.001 | 0.387 | 0.807 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 842.3 ± 2.5% | 0.836 | 1.009 | 1.006 | 1.007 | 0.433 | 1.022 | 1.013 | 0.385 | 0.886 | 0.125 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1480.9 ± 0.9% | 0.444 | 1.002 | 0.972 | 1.007 | 1.011 | 0.270 | 0.999 | 0.549 | 0.830 | 0.089 | 1.031 |
| qlog records, JSON text sequence | 1467503 | 1237.1 ± 1.7% | 0.708 | 0.990 | 1.018 | 1.012 | 1.013 | 0.273 | 0.990 | 0.509 | 0.800 | 0.109 | 1.020 |

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
| CLDR supplemental, 34 texts | 920675 | 1123.7 ± 0.4% | 926.3 ± 0.7% | 1020.5 ± 0.2% | 300.1 ± 0.2% | 669.3 ± 0.3% | 308.4 ± 1.6% | 1.213 | 1.101 | 3.744 | 1.679 | 3.644 |
| qlog records, JSON text sequence | 1467503 | 842.3 ± 2.5% | 816.5 ± 0.1% | 764.2 ± 2.1% | 241.1 ± 1.4% | 702.2 ± 1.1% | 248.1 ± 3.4% | 1.032 | 1.102 | 3.494 | 1.200 | 3.396 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1480.9 ± 0.9% | 1247.6 ± 0.4% | 1038.0 ± 0.8% | 411.1 ± 0.6% | 449.1 ± 0.4% | 414.1 ± 0.9% | 1.187 | 1.427 | 3.603 | 3.298 | 3.576 |
| qlog records, JSON text sequence | 1467503 | 1237.1 ± 1.7% | 1046.3 ± 0.3% | 771.1 ± 1.3% | 358.7 ± 1.4% | 447.6 ± 3.4% | 274.9 ± 1.3% | 1.182 | 1.604 | 3.448 | 2.764 | 4.500 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1526.4 ± 0.2% | 1247.6 ± 0.4% | 1038.0 ± 0.8% | 411.1 ± 0.6% | 449.1 ± 0.4% | 414.1 ± 0.9% | 1.223 | 1.470 | 3.713 | 3.399 | 3.686 |
| qlog records, JSON text sequence | 1467503 | 1262.4 ± 1.4% | 1046.3 ± 0.3% | 771.1 ± 1.3% | 358.7 ± 1.4% | 447.6 ± 3.4% | 274.9 ± 1.3% | 1.207 | 1.637 | 3.519 | 2.821 | 4.592 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 907.1 ± 0.3% | 926.3 ± 0.7% | 1020.5 ± 0.2% | 300.1 ± 0.2% | 669.3 ± 0.3% | 308.4 ± 1.6% | 0.979 | 0.889 | 3.022 | 1.355 | 2.941 |
| qlog records, JSON text sequence | 1467503 | 746.4 ± 0.6% | 816.5 ± 0.1% | 764.2 ± 2.1% | 241.1 ± 1.4% | 702.2 ± 1.1% | 248.1 ± 3.4% | 0.914 | 0.977 | 3.096 | 1.063 | 3.009 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1229.7 ± 0.3% | 1247.6 ± 0.4% | 1038.0 ± 0.8% | 411.1 ± 0.6% | 449.1 ± 0.4% | 414.1 ± 0.9% | 0.986 | 1.185 | 2.992 | 2.738 | 2.970 |
| qlog records, JSON text sequence | 1467503 | 989.6 ± 0.5% | 1046.3 ± 0.3% | 771.1 ± 1.3% | 358.7 ± 1.4% | 447.6 ± 3.4% | 274.9 ± 1.3% | 0.946 | 1.284 | 2.759 | 2.211 | 3.600 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.889 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.914 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.946 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1124.7 ± 0.6% | 0.527 | 0.966 | 1.006 | 1.009 | 0.461 | 1.002 | 0.999 | 0.386 | 0.832 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 824.7 ± 30.4% | 0.836 | 1.027 | 1.025 | 1.025 | 0.446 | 1.044 | 1.030 | 0.390 | 0.933 | 0.128 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1468.4 ± 0.9% | 0.445 | 1.003 | 0.965 | 1.009 | 1.010 | 0.271 | 0.998 | 0.550 | 0.832 | 0.089 | 1.029 |
| qlog records, JSON text sequence | 1467503 | 1235.1 ± 39.6% | 0.709 | 0.983 | 1.010 | 1.011 | 1.014 | 0.273 | 0.987 | 0.509 | 0.800 | 0.109 | 1.013 |

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
| CLDR supplemental, 34 texts | 920675 | 1124.7 ± 0.6% | 927.8 ± 0.6% | 1024.2 ± 0.5% | 299.7 ± 0.3% | 666.9 ± 0.2% | 308.5 ± 1.9% | 1.212 | 1.098 | 3.752 | 1.686 | 3.645 |
| qlog records, JSON text sequence | 1467503 | 824.7 ± 30.4% | 817.3 ± 0.2% | 759.9 ± 2.3% | 240.2 ± 0.6% | 704.6 ± 21.6% | 240.8 ± 6.6% | 1.009 | 1.085 | 3.433 | 1.170 | 3.424 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1468.4 ± 0.9% | 1242.4 ± 0.5% | 1026.3 ± 1.6% | 410.4 ± 0.3% | 447.7 ± 0.5% | 412.5 ± 0.3% | 1.182 | 1.431 | 3.578 | 3.280 | 3.559 |
| qlog records, JSON text sequence | 1467503 | 1235.1 ± 39.6% | 1043.5 ± 0.9% | 762.9 ± 1.5% | 366.5 ± 0.9% | 469.1 ± 6.1% | 273.8 ± 5.8% | 1.184 | 1.619 | 3.370 | 2.633 | 4.511 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1511.2 ± 1.9% | 1242.4 ± 0.5% | 1026.3 ± 1.6% | 410.4 ± 0.3% | 447.7 ± 0.5% | 412.5 ± 0.3% | 1.216 | 1.473 | 3.683 | 3.376 | 3.663 |
| qlog records, JSON text sequence | 1467503 | 1251.3 ± 1.1% | 1043.5 ± 0.9% | 762.9 ± 1.5% | 366.5 ± 0.9% | 469.1 ± 6.1% | 273.8 ± 5.8% | 1.199 | 1.640 | 3.414 | 2.667 | 4.570 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 935.8 ± 0.1% | 927.8 ± 0.6% | 1024.2 ± 0.5% | 299.7 ± 0.3% | 666.9 ± 0.2% | 308.5 ± 1.9% | 1.009 | 0.914 | 3.122 | 1.403 | 3.033 |
| qlog records, JSON text sequence | 1467503 | 769.4 ± 0.9% | 817.3 ± 0.2% | 759.9 ± 2.3% | 240.2 ± 0.6% | 704.6 ± 21.6% | 240.8 ± 6.6% | 0.941 | 1.013 | 3.204 | 1.092 | 3.195 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1222.0 ± 0.5% | 1242.4 ± 0.5% | 1026.3 ± 1.6% | 410.4 ± 0.3% | 447.7 ± 0.5% | 412.5 ± 0.3% | 0.984 | 1.191 | 2.978 | 2.729 | 2.962 |
| qlog records, JSON text sequence | 1467503 | 988.5 ± 0.3% | 1043.5 ± 0.9% | 762.9 ± 1.5% | 366.5 ± 0.9% | 469.1 ± 6.1% | 273.8 ± 5.8% | 0.947 | 1.296 | 2.697 | 2.107 | 3.610 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.914 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.941 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.947 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1125.1 ± 0.5% | 0.536 | 0.969 | 0.996 | 0.998 | 0.456 | 1.004 | 1.009 | 0.367 | 0.680 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 831.2 ± 2.4% | 0.837 | 0.999 | 1.004 | 1.003 | 0.446 | 1.022 | 1.011 | 0.373 | 0.642 | 0.127 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1471.2 ± 0.9% | 0.445 | 1.003 | 0.971 | 1.009 | 1.011 | 0.268 | 0.999 | 0.549 | 0.830 | 0.089 | 1.028 |
| qlog records, JSON text sequence | 1467503 | 1244.5 ± 0.4% | 0.698 | 0.981 | 1.016 | 1.013 | 1.011 | 0.268 | 0.995 | 0.506 | 0.798 | 0.109 | 1.006 |

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
| CLDR supplemental, 34 texts | 920675 | 1125.1 ± 0.5% | 931.1 ± 0.7% | 1022.0 ± 0.2% | 299.6 ± 0.3% | 664.8 ± 0.3% | 306.5 ± 1.8% | 1.208 | 1.101 | 3.756 | 1.692 | 3.671 |
| qlog records, JSON text sequence | 1467503 | 831.2 ± 2.4% | 815.3 ± 0.2% | 721.3 ± 6.8% | 240.0 ± 1.0% | 701.7 ± 2.4% | 239.3 ± 3.1% | 1.019 | 1.152 | 3.463 | 1.184 | 3.473 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1471.2 ± 0.9% | 1241.7 ± 0.4% | 1023.5 ± 0.7% | 411.5 ± 0.2% | 446.9 ± 0.2% | 416.9 ± 0.6% | 1.185 | 1.437 | 3.575 | 3.292 | 3.529 |
| qlog records, JSON text sequence | 1467503 | 1244.5 ± 0.4% | 1039.6 ± 0.5% | 770.8 ± 1.4% | 379.0 ± 0.9% | 458.4 ± 2.2% | 278.1 ± 0.2% | 1.197 | 1.614 | 3.284 | 2.715 | 4.475 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1512.0 ± 0.8% | 1241.7 ± 0.4% | 1023.5 ± 0.7% | 411.5 ± 0.2% | 446.9 ± 0.2% | 416.9 ± 0.6% | 1.218 | 1.477 | 3.674 | 3.383 | 3.627 |
| qlog records, JSON text sequence | 1467503 | 1252.4 ± 1.0% | 1039.6 ± 0.5% | 770.8 ± 1.4% | 379.0 ± 0.9% | 458.4 ± 2.2% | 278.1 ± 0.2% | 1.205 | 1.625 | 3.305 | 2.732 | 4.503 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 765.5 ± 0.2% | 931.1 ± 0.7% | 1022.0 ± 0.2% | 299.6 ± 0.3% | 664.8 ± 0.3% | 306.5 ± 1.8% | 0.822 | 0.749 | 2.555 | 1.151 | 2.498 |
| qlog records, JSON text sequence | 1467503 | 533.7 ± 1.2% | 815.3 ± 0.2% | 721.3 ± 6.8% | 240.0 ± 1.0% | 701.7 ± 2.4% | 239.3 ± 3.1% | 0.655 | 0.740 | 2.224 | 0.761 | 2.230 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1220.9 ± 0.5% | 1241.7 ± 0.4% | 1023.5 ± 0.7% | 411.5 ± 0.2% | 446.9 ± 0.2% | 416.9 ± 0.6% | 0.983 | 1.193 | 2.967 | 2.732 | 2.929 |
| qlog records, JSON text sequence | 1467503 | 992.6 ± 0.3% | 1039.6 ± 0.5% | 770.8 ± 1.4% | 379.0 ± 0.9% | 458.4 ± 2.2% | 278.1 ± 0.2% | 0.955 | 1.288 | 2.619 | 2.165 | 3.569 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.822 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.749 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.655 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.740 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.761 of serde_json.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1126.4 ± 0.6% | 0.534 | 0.967 | 1.005 | 1.007 | 0.460 | 1.002 | 0.997 | 0.385 | 0.814 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 828.0 ± 1.0% | 0.844 | 1.016 | 1.021 | 1.016 | 0.447 | 1.029 | 1.023 | 0.384 | 0.840 | 0.127 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1469.2 ± 0.3% | 0.445 | 1.004 | 0.970 | 1.009 | 1.011 | 0.272 | 1.002 | 0.551 | 0.833 | 0.089 | 1.034 |
| qlog records, JSON text sequence | 1467503 | 1242.6 ± 1.8% | 0.706 | 0.990 | 1.019 | 1.015 | 1.016 | 0.272 | 0.992 | 0.509 | 0.798 | 0.109 | 1.022 |

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
| CLDR supplemental, 34 texts | 920675 | 1126.4 ± 0.6% | 926.7 ± 0.6% | 1023.8 ± 2.0% | 300.2 ± 0.2% | 666.2 ± 0.2% | 307.1 ± 1.7% | 1.215 | 1.100 | 3.752 | 1.691 | 3.668 |
| qlog records, JSON text sequence | 1467503 | 828.0 ± 1.0% | 817.3 ± 0.2% | 744.0 ± 3.4% | 240.7 ± 0.8% | 697.5 ± 0.4% | 236.7 ± 1.0% | 1.013 | 1.113 | 3.440 | 1.187 | 3.498 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1469.2 ± 0.3% | 1244.6 ± 0.5% | 1030.9 ± 0.5% | 411.1 ± 0.3% | 448.3 ± 0.2% | 412.9 ± 0.4% | 1.180 | 1.425 | 3.573 | 3.277 | 3.558 |
| qlog records, JSON text sequence | 1467503 | 1242.6 ± 1.8% | 1050.3 ± 0.6% | 766.5 ± 2.4% | 370.2 ± 1.2% | 475.7 ± 1.2% | 266.2 ± 2.7% | 1.183 | 1.621 | 3.357 | 2.612 | 4.668 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1518.6 ± 0.6% | 1244.6 ± 0.5% | 1030.9 ± 0.5% | 411.1 ± 0.3% | 448.3 ± 0.2% | 412.9 ± 0.4% | 1.220 | 1.473 | 3.694 | 3.388 | 3.678 |
| qlog records, JSON text sequence | 1467503 | 1269.8 ± 1.0% | 1050.3 ± 0.6% | 766.5 ± 2.4% | 370.2 ± 1.2% | 475.7 ± 1.2% | 266.2 ± 2.7% | 1.209 | 1.657 | 3.430 | 2.669 | 4.771 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 917.2 ± 0.2% | 926.7 ± 0.6% | 1023.8 ± 2.0% | 300.2 ± 0.2% | 666.2 ± 0.2% | 307.1 ± 1.7% | 0.990 | 0.896 | 3.055 | 1.377 | 2.987 |
| qlog records, JSON text sequence | 1467503 | 695.4 ± 1.3% | 817.3 ± 0.2% | 744.0 ± 3.4% | 240.7 ± 0.8% | 697.5 ± 0.4% | 236.7 ± 1.0% | 0.851 | 0.935 | 2.889 | 0.997 | 2.938 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1223.9 ± 0.2% | 1244.6 ± 0.5% | 1030.9 ± 0.5% | 411.1 ± 0.3% | 448.3 ± 0.2% | 412.9 ± 0.4% | 0.983 | 1.187 | 2.977 | 2.730 | 2.964 |
| qlog records, JSON text sequence | 1467503 | 992.0 ± 0.3% | 1050.3 ± 0.6% | 766.5 ± 2.4% | 370.2 ± 1.2% | 475.7 ± 1.2% | 266.2 ± 2.7% | 0.945 | 1.294 | 2.680 | 2.085 | 3.727 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.896 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.851 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.935 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.945 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 2

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1124.7 ± 0.3% | 0.536 | 0.968 | 1.009 | 1.010 | 0.458 | 1.004 | 0.999 | 0.367 | 0.815 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 834.3 ± 1.6% | 0.841 | 1.014 | 1.011 | 1.012 | 0.435 | 1.023 | 1.017 | 0.375 | 0.877 | 0.128 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1477.8 ± 0.6% | 0.445 | 1.001 | 0.971 | 1.005 | 1.005 | 0.271 | 0.995 | 0.549 | 0.829 | 0.089 | 1.029 |
| qlog records, JSON text sequence | 1467503 | 1244.2 ± 2.2% | 0.704 | 0.986 | 1.012 | 1.013 | 1.014 | 0.273 | 0.987 | 0.507 | 0.799 | 0.108 | 1.016 |

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
| CLDR supplemental, 34 texts | 920675 | 1124.7 ± 0.3% | 928.5 ± 0.3% | 1024.1 ± 0.3% | 300.1 ± 0.1% | 665.2 ± 0.1% | 308.1 ± 1.6% | 1.211 | 1.098 | 3.747 | 1.691 | 3.651 |
| qlog records, JSON text sequence | 1467503 | 834.3 ± 1.6% | 817.8 ± 0.6% | 758.9 ± 2.7% | 239.7 ± 0.9% | 691.3 ± 0.4% | 243.9 ± 2.0% | 1.020 | 1.099 | 3.481 | 1.207 | 3.421 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1477.8 ± 0.6% | 1247.9 ± 0.7% | 1031.9 ± 1.0% | 409.4 ± 0.3% | 448.8 ± 0.2% | 414.0 ± 0.3% | 1.184 | 1.432 | 3.610 | 3.293 | 3.570 |
| qlog records, JSON text sequence | 1467503 | 1244.2 ± 2.2% | 1043.2 ± 1.0% | 776.4 ± 1.7% | 369.0 ± 0.8% | 465.5 ± 1.8% | 273.9 ± 0.3% | 1.193 | 1.602 | 3.372 | 2.673 | 4.542 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1520.0 ± 0.3% | 1247.9 ± 0.7% | 1031.9 ± 1.0% | 409.4 ± 0.3% | 448.8 ± 0.2% | 414.0 ± 0.3% | 1.218 | 1.473 | 3.713 | 3.387 | 3.672 |
| qlog records, JSON text sequence | 1467503 | 1264.6 ± 1.3% | 1043.2 ± 1.0% | 776.4 ± 1.7% | 369.0 ± 0.8% | 465.5 ± 1.8% | 273.9 ± 0.3% | 1.212 | 1.629 | 3.427 | 2.716 | 4.616 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 916.1 ± 0.4% | 928.5 ± 0.3% | 1024.1 ± 0.3% | 300.1 ± 0.1% | 665.2 ± 0.1% | 308.1 ± 1.6% | 0.987 | 0.895 | 3.052 | 1.377 | 2.974 |
| qlog records, JSON text sequence | 1467503 | 731.6 ± 0.9% | 817.8 ± 0.6% | 758.9 ± 2.7% | 239.7 ± 0.9% | 691.3 ± 0.4% | 243.9 ± 2.0% | 0.895 | 0.964 | 3.052 | 1.058 | 3.000 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1225.4 ± 0.5% | 1247.9 ± 0.7% | 1031.9 ± 1.0% | 409.4 ± 0.3% | 448.8 ± 0.2% | 414.0 ± 0.3% | 0.982 | 1.188 | 2.993 | 2.730 | 2.960 |
| qlog records, JSON text sequence | 1467503 | 994.3 ± 0.4% | 1043.2 ± 1.0% | 776.4 ± 1.7% | 369.0 ± 0.8% | 465.5 ± 1.8% | 273.9 ± 0.3% | 0.953 | 1.281 | 2.694 | 2.136 | 3.629 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.895 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.895 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 2

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1125.6 ± 0.2% | 0.534 | 0.967 | 1.005 | 1.008 | 0.460 | 1.002 | 0.997 | 0.386 | 0.805 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 828.7 ± 1.4% | 0.849 | 1.023 | 1.018 | 1.019 | 0.440 | 1.036 | 1.023 | 0.388 | 0.891 | 0.127 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1478.9 ± 0.4% | 0.445 | 1.005 | 0.971 | 1.008 | 1.009 | 0.271 | 0.999 | 0.548 | 0.830 | 0.089 | 1.030 |
| qlog records, JSON text sequence | 1467503 | 1250.1 ± 1.4% | 0.704 | 0.986 | 1.019 | 1.018 | 1.014 | 0.270 | 0.991 | 0.506 | 0.797 | 0.108 | 1.023 |

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
| CLDR supplemental, 34 texts | 920675 | 1125.6 ± 0.2% | 926.2 ± 17.5% | 1022.9 ± 0.2% | 299.9 ± 0.3% | 669.1 ± 0.3% | 307.1 ± 2.3% | 1.215 | 1.100 | 3.753 | 1.682 | 3.665 |
| qlog records, JSON text sequence | 1467503 | 828.7 ± 1.4% | 816.6 ± 0.2% | 749.8 ± 3.2% | 239.5 ± 1.0% | 695.8 ± 1.5% | 245.0 ± 2.5% | 1.015 | 1.105 | 3.460 | 1.191 | 3.382 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1478.9 ± 0.4% | 1250.2 ± 0.3% | 1038.2 ± 0.4% | 410.5 ± 0.4% | 449.6 ± 0.3% | 414.1 ± 0.3% | 1.183 | 1.424 | 3.602 | 3.289 | 3.571 |
| qlog records, JSON text sequence | 1467503 | 1250.1 ± 1.4% | 1054.0 ± 30.3% | 780.9 ± 15.5% | 367.2 ± 0.7% | 463.4 ± 1.8% | 276.4 ± 0.3% | 1.186 | 1.601 | 3.405 | 2.698 | 4.523 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1523.8 ± 0.6% | 1250.2 ± 0.3% | 1038.2 ± 0.4% | 410.5 ± 0.4% | 449.6 ± 0.3% | 414.1 ± 0.3% | 1.219 | 1.468 | 3.712 | 3.389 | 3.679 |
| qlog records, JSON text sequence | 1467503 | 1278.9 ± 0.8% | 1054.0 ± 30.3% | 780.9 ± 15.5% | 367.2 ± 0.7% | 463.4 ± 1.8% | 276.4 ± 0.3% | 1.213 | 1.638 | 3.483 | 2.760 | 4.627 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 906.3 ± 0.2% | 926.2 ± 17.5% | 1022.9 ± 0.2% | 299.9 ± 0.3% | 669.1 ± 0.3% | 307.1 ± 2.3% | 0.978 | 0.886 | 3.021 | 1.354 | 2.951 |
| qlog records, JSON text sequence | 1467503 | 738.5 ± 1.2% | 816.6 ± 0.2% | 749.8 ± 3.2% | 239.5 ± 1.0% | 695.8 ± 1.5% | 245.0 ± 2.5% | 0.904 | 0.985 | 3.083 | 1.061 | 3.014 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1227.8 ± 0.6% | 1250.2 ± 0.3% | 1038.2 ± 0.4% | 410.5 ± 0.4% | 449.6 ± 0.3% | 414.1 ± 0.3% | 0.982 | 1.183 | 2.991 | 2.731 | 2.965 |
| qlog records, JSON text sequence | 1467503 | 996.4 ± 21.2% | 1054.0 ± 30.3% | 780.9 ± 15.5% | 367.2 ± 0.7% | 463.4 ± 1.8% | 276.4 ± 0.3% | 0.945 | 1.276 | 2.714 | 2.150 | 3.605 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.886 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.904 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.0 ± 0.5% | 0.534 | 0.968 | 1.007 | 1.008 | 0.459 | 1.002 | 0.997 | 0.385 | 0.831 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 836.9 ± 1.8% | 0.838 | 1.014 | 1.010 | 1.015 | 0.439 | 1.023 | 1.012 | 0.386 | 0.923 | 0.126 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1479.8 ± 0.5% | 0.445 | 1.005 | 0.972 | 1.006 | 1.010 | 0.271 | 1.000 | 0.549 | 0.828 | 0.089 | 1.033 |
| qlog records, JSON text sequence | 1467503 | 1254.8 ± 2.2% | 0.702 | 0.984 | 1.016 | 1.010 | 1.008 | 0.270 | 0.983 | 0.506 | 0.794 | 0.108 | 1.018 |

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
| CLDR supplemental, 34 texts | 920675 | 1127.0 ± 0.5% | 930.9 ± 1.0% | 1023.5 ± 0.3% | 300.3 ± 0.3% | 666.8 ± 0.1% | 309.1 ± 1.6% | 1.211 | 1.101 | 3.753 | 1.690 | 3.646 |
| qlog records, JSON text sequence | 1467503 | 836.9 ± 1.8% | 818.1 ± 0.0% | 756.0 ± 1.6% | 240.8 ± 1.0% | 709.2 ± 0.7% | 244.4 ± 2.3% | 1.023 | 1.107 | 3.476 | 1.180 | 3.424 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1479.8 ± 0.5% | 1249.1 ± 0.3% | 1031.6 ± 0.9% | 411.3 ± 0.4% | 448.3 ± 0.9% | 414.9 ± 0.5% | 1.185 | 1.434 | 3.598 | 3.301 | 3.567 |
| qlog records, JSON text sequence | 1467503 | 1254.8 ± 2.2% | 1055.2 ± 0.7% | 774.7 ± 0.5% | 370.6 ± 1.2% | 471.8 ± 1.2% | 275.6 ± 0.7% | 1.189 | 1.620 | 3.386 | 2.660 | 4.553 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1528.3 ± 1.0% | 1249.1 ± 0.3% | 1031.6 ± 0.9% | 411.3 ± 0.4% | 448.3 ± 0.9% | 414.9 ± 0.5% | 1.224 | 1.481 | 3.716 | 3.409 | 3.684 |
| qlog records, JSON text sequence | 1467503 | 1277.7 ± 0.8% | 1055.2 ± 0.7% | 774.7 ± 0.5% | 370.6 ± 1.2% | 471.8 ± 1.2% | 275.6 ± 0.7% | 1.211 | 1.649 | 3.448 | 2.708 | 4.636 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 936.9 ± 0.2% | 930.9 ± 1.0% | 1023.5 ± 0.3% | 300.3 ± 0.3% | 666.8 ± 0.1% | 309.1 ± 1.6% | 1.006 | 0.915 | 3.120 | 1.405 | 3.031 |
| qlog records, JSON text sequence | 1467503 | 772.3 ± 1.3% | 818.1 ± 0.0% | 756.0 ± 1.6% | 240.8 ± 1.0% | 709.2 ± 0.7% | 244.4 ± 2.3% | 0.944 | 1.022 | 3.207 | 1.089 | 3.160 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1226.0 ± 0.4% | 1249.1 ± 0.3% | 1031.6 ± 0.9% | 411.3 ± 0.4% | 448.3 ± 0.9% | 414.9 ± 0.5% | 0.981 | 1.188 | 2.981 | 2.735 | 2.955 |
| qlog records, JSON text sequence | 1467503 | 996.7 ± 0.6% | 1055.2 ± 0.7% | 774.7 ± 0.5% | 370.6 ± 1.2% | 471.8 ± 1.2% | 275.6 ± 0.7% | 0.945 | 1.287 | 2.690 | 2.112 | 3.616 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.915 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.944 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.945 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1126.0 ± 0.5% | 0.535 | 0.969 | 0.995 | 0.996 | 0.456 | 1.003 | 1.009 | 0.367 | 0.681 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 843.3 ± 2.8% | 0.834 | 0.997 | 0.991 | 0.993 | 0.443 | 1.010 | 0.999 | 0.371 | 0.635 | 0.126 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1476.7 ± 0.7% | 0.444 | 1.003 | 0.970 | 1.006 | 1.008 | 0.267 | 0.998 | 0.548 | 0.828 | 0.089 | 1.026 |
| qlog records, JSON text sequence | 1467503 | 1241.6 ± 1.1% | 0.700 | 0.985 | 1.015 | 1.011 | 1.009 | 0.269 | 0.996 | 0.507 | 0.798 | 0.110 | 1.009 |

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
| CLDR supplemental, 34 texts | 920675 | 1126.0 ± 0.5% | 928.8 ± 0.7% | 1023.3 ± 0.2% | 299.3 ± 0.4% | 666.1 ± 0.1% | 307.7 ± 1.6% | 1.212 | 1.100 | 3.762 | 1.690 | 3.659 |
| qlog records, JSON text sequence | 1467503 | 843.3 ± 2.8% | 815.6 ± 0.2% | 740.0 ± 1.4% | 239.9 ± 0.6% | 700.0 ± 0.8% | 241.5 ± 0.7% | 1.034 | 1.140 | 3.515 | 1.205 | 3.492 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1476.7 ± 0.7% | 1246.9 ± 0.2% | 1025.3 ± 0.7% | 412.4 ± 0.2% | 446.9 ± 0.1% | 417.0 ± 0.3% | 1.184 | 1.440 | 3.581 | 3.305 | 3.541 |
| qlog records, JSON text sequence | 1467503 | 1241.6 ± 1.1% | 1041.0 ± 23.6% | 776.1 ± 30.5% | 381.8 ± 1.4% | 475.1 ± 1.8% | 278.8 ± 0.6% | 1.193 | 1.600 | 3.252 | 2.613 | 4.454 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1515.2 ± 0.6% | 1246.9 ± 0.2% | 1025.3 ± 0.7% | 412.4 ± 0.2% | 446.9 ± 0.1% | 417.0 ± 0.3% | 1.215 | 1.478 | 3.674 | 3.391 | 3.634 |
| qlog records, JSON text sequence | 1467503 | 1252.9 ± 1.3% | 1041.0 ± 23.6% | 776.1 ± 30.5% | 381.8 ± 1.4% | 475.1 ± 1.8% | 278.8 ± 0.6% | 1.204 | 1.614 | 3.282 | 2.637 | 4.494 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 766.2 ± 0.0% | 928.8 ± 0.7% | 1023.3 ± 0.2% | 299.3 ± 0.4% | 666.1 ± 0.1% | 307.7 ± 1.6% | 0.825 | 0.749 | 2.560 | 1.150 | 2.490 |
| qlog records, JSON text sequence | 1467503 | 535.7 ± 1.0% | 815.6 ± 0.2% | 740.0 ± 1.4% | 239.9 ± 0.6% | 700.0 ± 0.8% | 241.5 ± 0.7% | 0.657 | 0.724 | 2.233 | 0.765 | 2.218 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1223.4 ± 0.3% | 1246.9 ± 0.2% | 1025.3 ± 0.7% | 412.4 ± 0.2% | 446.9 ± 0.1% | 417.0 ± 0.3% | 0.981 | 1.193 | 2.967 | 2.738 | 2.934 |
| qlog records, JSON text sequence | 1467503 | 990.9 ± 5.7% | 1041.0 ± 23.6% | 776.1 ± 30.5% | 381.8 ± 1.4% | 475.1 ± 1.8% | 278.8 ± 0.6% | 0.952 | 1.277 | 2.596 | 2.086 | 3.555 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.825 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.749 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.657 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.724 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.765 of serde_json.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1125.2 ± 0.5% | 0.535 | 0.970 | 1.007 | 1.006 | 0.457 | 1.003 | 0.996 | 0.367 | 0.815 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 835.9 ± 1.9% | 0.843 | 1.013 | 1.013 | 1.014 | 0.437 | 1.030 | 1.015 | 0.376 | 0.834 | 0.128 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1480.5 ± 0.8% | 0.444 | 1.000 | 0.970 | 1.005 | 1.006 | 0.271 | 0.997 | 0.548 | 0.827 | 0.089 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1242.0 ± 13.5% | 0.705 | 0.986 | 1.015 | 1.017 | 1.011 | 0.273 | 0.988 | 0.505 | 0.800 | 0.108 | 1.014 |

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
| CLDR supplemental, 34 texts | 920675 | 1125.2 ± 0.5% | 925.5 ± 0.4% | 1021.2 ± 0.4% | 300.1 ± 0.2% | 667.6 ± 0.1% | 308.6 ± 1.9% | 1.216 | 1.102 | 3.750 | 1.686 | 3.646 |
| qlog records, JSON text sequence | 1467503 | 835.9 ± 1.9% | 818.2 ± 0.2% | 761.6 ± 1.5% | 241.0 ± 0.6% | 698.0 ± 0.7% | 245.1 ± 3.0% | 1.022 | 1.097 | 3.469 | 1.197 | 3.411 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1480.5 ± 0.8% | 1245.4 ± 0.6% | 1031.5 ± 0.8% | 409.7 ± 0.8% | 448.7 ± 0.4% | 414.3 ± 0.5% | 1.189 | 1.435 | 3.614 | 3.300 | 3.573 |
| qlog records, JSON text sequence | 1467503 | 1242.0 ± 13.5% | 1049.0 ± 0.5% | 768.4 ± 1.2% | 367.9 ± 1.6% | 459.9 ± 2.3% | 274.9 ± 0.8% | 1.184 | 1.616 | 3.376 | 2.700 | 4.518 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1520.1 ± 1.0% | 1245.4 ± 0.6% | 1031.5 ± 0.8% | 409.7 ± 0.8% | 448.7 ± 0.4% | 414.3 ± 0.5% | 1.221 | 1.474 | 3.710 | 3.388 | 3.669 |
| qlog records, JSON text sequence | 1467503 | 1259.8 ± 1.0% | 1049.0 ± 0.5% | 768.4 ± 1.2% | 367.9 ± 1.6% | 459.9 ± 2.3% | 274.9 ± 0.8% | 1.201 | 1.639 | 3.424 | 2.739 | 4.583 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 916.7 ± 0.5% | 925.5 ± 0.4% | 1021.2 ± 0.4% | 300.1 ± 0.2% | 667.6 ± 0.1% | 308.6 ± 1.9% | 0.991 | 0.898 | 3.055 | 1.373 | 2.971 |
| qlog records, JSON text sequence | 1467503 | 697.4 ± 0.7% | 818.2 ± 0.2% | 761.6 ± 1.5% | 241.0 ± 0.6% | 698.0 ± 0.7% | 245.1 ± 3.0% | 0.852 | 0.916 | 2.894 | 0.999 | 2.846 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1225.1 ± 0.4% | 1245.4 ± 0.6% | 1031.5 ± 0.8% | 409.7 ± 0.8% | 448.7 ± 0.4% | 414.3 ± 0.5% | 0.984 | 1.188 | 2.990 | 2.730 | 2.957 |
| qlog records, JSON text sequence | 1467503 | 994.2 ± 0.3% | 1049.0 ± 0.5% | 768.4 ± 1.2% | 367.9 ± 1.6% | 459.9 ± 2.3% | 274.9 ± 0.8% | 0.948 | 1.294 | 2.702 | 2.162 | 3.617 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.898 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.852 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.916 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.948 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 3

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1126.1 ± 0.5% | 0.534 | 0.968 | 1.007 | 1.009 | 0.460 | 1.001 | 0.996 | 0.386 | 0.812 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 831.4 ± 1.3% | 0.842 | 1.019 | 1.015 | 1.019 | 0.436 | 1.031 | 1.020 | 0.386 | 0.871 | 0.127 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1475.1 ± 1.2% | 0.445 | 1.006 | 0.972 | 1.011 | 1.009 | 0.271 | 0.998 | 0.548 | 0.831 | 0.089 | 1.030 |
| qlog records, JSON text sequence | 1467503 | 1241.4 ± 2.1% | 0.706 | 0.988 | 1.011 | 1.011 | 1.011 | 0.272 | 0.988 | 0.508 | 0.798 | 0.109 | 1.019 |

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
| CLDR supplemental, 34 texts | 920675 | 1126.1 ± 0.5% | 928.2 ± 0.3% | 1021.1 ± 0.2% | 300.0 ± 0.3% | 669.4 ± 0.1% | 308.8 ± 2.1% | 1.213 | 1.103 | 3.753 | 1.682 | 3.647 |
| qlog records, JSON text sequence | 1467503 | 831.4 ± 1.3% | 817.7 ± 0.2% | 755.6 ± 2.2% | 240.7 ± 0.8% | 689.6 ± 2.4% | 242.7 ± 3.1% | 1.017 | 1.100 | 3.454 | 1.206 | 3.425 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1475.1 ± 1.2% | 1247.9 ± 0.3% | 1034.2 ± 0.8% | 410.1 ± 0.2% | 448.6 ± 0.2% | 413.8 ± 0.3% | 1.182 | 1.426 | 3.597 | 3.288 | 3.565 |
| qlog records, JSON text sequence | 1467503 | 1241.4 ± 2.1% | 1050.1 ± 0.3% | 768.0 ± 1.1% | 360.5 ± 1.0% | 461.0 ± 3.9% | 276.1 ± 0.8% | 1.182 | 1.616 | 3.443 | 2.693 | 4.496 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1519.4 ± 0.7% | 1247.9 ± 0.3% | 1034.2 ± 0.8% | 410.1 ± 0.2% | 448.6 ± 0.2% | 413.8 ± 0.3% | 1.218 | 1.469 | 3.705 | 3.387 | 3.672 |
| qlog records, JSON text sequence | 1467503 | 1264.6 ± 0.3% | 1050.1 ± 0.3% | 768.0 ± 1.1% | 360.5 ± 1.0% | 461.0 ± 3.9% | 276.1 ± 0.8% | 1.204 | 1.647 | 3.508 | 2.743 | 4.580 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 914.8 ± 0.1% | 928.2 ± 0.3% | 1021.1 ± 0.2% | 300.0 ± 0.3% | 669.4 ± 0.1% | 308.8 ± 2.1% | 0.985 | 0.896 | 3.049 | 1.367 | 2.962 |
| qlog records, JSON text sequence | 1467503 | 724.1 ± 1.3% | 817.7 ± 0.2% | 755.6 ± 2.2% | 240.7 ± 0.8% | 689.6 ± 2.4% | 242.7 ± 3.1% | 0.886 | 0.958 | 3.008 | 1.050 | 2.983 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1226.4 ± 0.5% | 1247.9 ± 0.3% | 1034.2 ± 0.8% | 410.1 ± 0.2% | 448.6 ± 0.2% | 413.8 ± 0.3% | 0.983 | 1.186 | 2.991 | 2.734 | 2.964 |
| qlog records, JSON text sequence | 1467503 | 990.5 ± 0.2% | 1050.1 ± 0.3% | 768.0 ± 1.1% | 360.5 ± 1.0% | 461.0 ± 3.9% | 276.1 ± 0.8% | 0.943 | 1.290 | 2.748 | 2.148 | 3.587 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.896 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.886 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.943 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 3

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1123.9 ± 0.5% | 0.536 | 0.970 | 1.009 | 1.011 | 0.458 | 1.004 | 0.998 | 0.367 | 0.809 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 835.8 ± 1.3% | 0.836 | 1.015 | 1.010 | 1.013 | 0.434 | 1.029 | 1.016 | 0.376 | 0.889 | 0.128 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1473.1 ± 1.2% | 0.445 | 1.001 | 0.972 | 1.008 | 1.009 | 0.271 | 0.999 | 0.550 | 0.831 | 0.088 | 1.029 |
| qlog records, JSON text sequence | 1467503 | 1238.4 ± 1.9% | 0.704 | 0.983 | 1.014 | 1.013 | 1.019 | 0.274 | 0.990 | 0.504 | 0.800 | 0.108 | 1.012 |

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
| CLDR supplemental, 34 texts | 920675 | 1123.9 ± 0.5% | 927.1 ± 0.4% | 1023.7 ± 0.2% | 300.3 ± 0.3% | 667.5 ± 0.2% | 309.1 ± 2.1% | 1.212 | 1.098 | 3.743 | 1.684 | 3.636 |
| qlog records, JSON text sequence | 1467503 | 835.8 ± 1.3% | 818.1 ± 0.1% | 755.8 ± 3.4% | 240.2 ± 0.7% | 695.7 ± 1.8% | 243.1 ± 2.1% | 1.022 | 1.106 | 3.479 | 1.201 | 3.438 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1473.1 ± 1.2% | 1248.3 ± 0.4% | 1030.6 ± 1.2% | 409.2 ± 0.3% | 448.9 ± 0.3% | 413.1 ± 0.4% | 1.180 | 1.429 | 3.600 | 3.282 | 3.566 |
| qlog records, JSON text sequence | 1467503 | 1238.4 ± 1.9% | 1046.7 ± 0.4% | 768.7 ± 1.8% | 367.2 ± 0.9% | 464.4 ± 1.8% | 276.2 ± 0.6% | 1.183 | 1.611 | 3.373 | 2.666 | 4.484 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1515.7 ± 0.7% | 1248.3 ± 0.4% | 1030.6 ± 1.2% | 409.2 ± 0.3% | 448.9 ± 0.3% | 413.1 ± 0.4% | 1.214 | 1.471 | 3.704 | 3.377 | 3.669 |
| qlog records, JSON text sequence | 1467503 | 1253.8 ± 0.4% | 1046.7 ± 0.4% | 768.7 ± 1.8% | 367.2 ± 0.9% | 464.4 ± 1.8% | 276.2 ± 0.6% | 1.198 | 1.631 | 3.415 | 2.700 | 4.540 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 909.8 ± 0.1% | 927.1 ± 0.4% | 1023.7 ± 0.2% | 300.3 ± 0.3% | 667.5 ± 0.2% | 309.1 ± 2.1% | 0.981 | 0.889 | 3.030 | 1.363 | 2.943 |
| qlog records, JSON text sequence | 1467503 | 742.8 ± 1.0% | 818.1 ± 0.1% | 755.8 ± 3.4% | 240.2 ± 0.7% | 695.7 ± 1.8% | 243.1 ± 2.1% | 0.908 | 0.983 | 3.092 | 1.068 | 3.056 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1224.8 ± 0.7% | 1248.3 ± 0.4% | 1030.6 ± 1.2% | 409.2 ± 0.3% | 448.9 ± 0.3% | 413.1 ± 0.4% | 0.981 | 1.188 | 2.993 | 2.729 | 2.965 |
| qlog records, JSON text sequence | 1467503 | 990.5 ± 0.6% | 1046.7 ± 0.4% | 768.7 ± 1.8% | 367.2 ± 0.9% | 464.4 ± 1.8% | 276.2 ± 0.6% | 0.946 | 1.289 | 2.698 | 2.133 | 3.586 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.889 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.908 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.946 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.0 ± 0.4% | 0.534 | 0.967 | 1.005 | 1.007 | 0.459 | 1.002 | 0.997 | 0.385 | 0.831 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 823.6 ± 1.9% | 0.851 | 1.029 | 1.021 | 1.021 | 0.437 | 1.036 | 1.027 | 0.387 | 0.933 | 0.128 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1465.6 ± 0.9% | 0.446 | 1.005 | 0.975 | 1.008 | 1.014 | 0.273 | 1.003 | 0.550 | 0.831 | 0.090 | 1.031 |
| qlog records, JSON text sequence | 1467503 | 1232.7 ± 1.2% | 0.711 | 0.987 | 1.018 | 1.018 | 1.018 | 0.274 | 0.991 | 0.510 | 0.801 | 0.109 | 1.024 |

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
| CLDR supplemental, 34 texts | 920675 | 1127.0 ± 0.4% | 928.5 ± 0.8% | 1023.4 ± 2.3% | 300.2 ± 0.5% | 667.1 ± 0.1% | 307.5 ± 1.7% | 1.214 | 1.101 | 3.754 | 1.689 | 3.666 |
| qlog records, JSON text sequence | 1467503 | 823.6 ± 1.9% | 817.7 ± 0.2% | 747.6 ± 2.2% | 240.7 ± 0.4% | 685.5 ± 1.5% | 239.7 ± 1.0% | 1.007 | 1.102 | 3.422 | 1.202 | 3.435 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1465.6 ± 0.9% | 1243.7 ± 0.3% | 1026.9 ± 0.6% | 410.1 ± 0.3% | 447.8 ± 0.2% | 412.4 ± 1.1% | 1.178 | 1.427 | 3.574 | 3.273 | 3.554 |
| qlog records, JSON text sequence | 1467503 | 1232.7 ± 1.2% | 1048.0 ± 0.7% | 766.4 ± 1.1% | 364.6 ± 1.8% | 437.6 ± 2.4% | 273.8 ± 0.6% | 1.176 | 1.609 | 3.381 | 2.817 | 4.502 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1511.1 ± 0.9% | 1243.7 ± 0.3% | 1026.9 ± 0.6% | 410.1 ± 0.3% | 447.8 ± 0.2% | 412.4 ± 1.1% | 1.215 | 1.472 | 3.685 | 3.374 | 3.664 |
| qlog records, JSON text sequence | 1467503 | 1262.7 ± 1.3% | 1048.0 ± 0.7% | 766.4 ± 1.1% | 364.6 ± 1.8% | 437.6 ± 2.4% | 273.8 ± 0.6% | 1.205 | 1.648 | 3.463 | 2.885 | 4.611 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 936.1 ± 0.1% | 928.5 ± 0.8% | 1023.4 ± 2.3% | 300.2 ± 0.5% | 667.1 ± 0.1% | 307.5 ± 1.7% | 1.008 | 0.915 | 3.118 | 1.403 | 3.045 |
| qlog records, JSON text sequence | 1467503 | 768.3 ± 1.0% | 817.7 ± 0.2% | 747.6 ± 2.2% | 240.7 ± 0.4% | 685.5 ± 1.5% | 239.7 ± 1.0% | 0.940 | 1.028 | 3.192 | 1.121 | 3.205 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1217.2 ± 0.6% | 1243.7 ± 0.3% | 1026.9 ± 0.6% | 410.1 ± 0.3% | 447.8 ± 0.2% | 412.4 ± 1.1% | 0.979 | 1.185 | 2.968 | 2.718 | 2.952 |
| qlog records, JSON text sequence | 1467503 | 987.9 ± 0.6% | 1048.0 ± 0.7% | 766.4 ± 1.1% | 364.6 ± 1.8% | 437.6 ± 2.4% | 273.8 ± 0.6% | 0.943 | 1.289 | 2.710 | 2.257 | 3.608 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.915 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.940 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.943 of simdjson.
