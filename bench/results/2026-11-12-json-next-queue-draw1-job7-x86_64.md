# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1703.2 ± 1.2% | 0.535 | 0.973 | 0.974 | 0.952 | 0.392 | 1.008 | 0.987 | 0.383 | 0.823 | 0.092 |
| qlog records, JSON text sequence | 1467503 | 1332.8 ± 6.1% | 0.920 | 1.017 | 1.020 | 1.025 | 0.404 | 1.019 | 1.048 | 0.378 | 0.712 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2388.0 ± 24.5% | 0.444 | 0.935 | 0.974 | 0.997 | 0.996 | 0.256 | 0.990 | 0.471 | 0.731 | 0.082 | 1.001 |
| qlog records, JSON text sequence | 1467503 | 2062.4 ± 4.8% | 0.712 | 0.913 | 0.976 | 1.001 | 0.984 | 0.254 | 0.980 | 0.428 | 0.713 | 0.100 | 0.997 |

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
| CLDR supplemental, 34 texts | 920675 | 1703.2 ± 1.2% | 2123.4 ± 4.3% | 1708.9 ± 8.3% | 546.7 ± 5.3% | 854.7 ± 1.1% | 490.2 ± 3.8% | 0.802 | 0.997 | 3.115 | 1.993 | 3.475 |
| qlog records, JSON text sequence | 1467503 | 1332.8 ± 6.1% | 1582.6 ± 15.0% | 1544.6 ± 4.4% | 462.7 ± 14.5% | 949.1 ± 31.6% | 483.8 ± 4.2% | 0.842 | 0.863 | 2.881 | 1.404 | 2.755 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2388.0 ± 24.5% | 2311.0 ± 4.3% | 1517.9 ± 5.8% | 623.1 ± 4.6% | 634.1 ± 4.8% | 585.1 ± 25.7% | 1.033 | 1.573 | 3.832 | 3.766 | 4.081 |
| qlog records, JSON text sequence | 1467503 | 2062.4 ± 4.8% | 1864.7 ± 3.4% | 1218.6 ± 1.2% | 578.9 ± 3.9% | 703.6 ± 1.0% | 492.0 ± 3.5% | 1.106 | 1.692 | 3.562 | 2.931 | 4.192 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2390.6 ± 6.8% | 2311.0 ± 4.3% | 1517.9 ± 5.8% | 623.1 ± 4.6% | 634.1 ± 4.8% | 585.1 ± 25.7% | 1.034 | 1.575 | 3.836 | 3.770 | 4.086 |
| qlog records, JSON text sequence | 1467503 | 2055.2 ± 2.6% | 1864.7 ± 3.4% | 1218.6 ± 1.2% | 578.9 ± 3.9% | 703.6 ± 1.0% | 492.0 ± 3.5% | 1.102 | 1.687 | 3.550 | 2.921 | 4.178 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1402.4 ± 2.8% | 2123.4 ± 4.3% | 1708.9 ± 8.3% | 546.7 ± 5.3% | 854.7 ± 1.1% | 490.2 ± 3.8% | 0.660 | 0.821 | 2.565 | 1.641 | 2.861 |
| qlog records, JSON text sequence | 1467503 | 949.3 ± 2.1% | 1582.6 ± 15.0% | 1544.6 ± 4.4% | 462.7 ± 14.5% | 949.1 ± 31.6% | 483.8 ± 4.2% | 0.600 | 0.615 | 2.052 | 1.000 | 1.962 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1746.1 ± 5.8% | 2311.0 ± 4.3% | 1517.9 ± 5.8% | 623.1 ± 4.6% | 634.1 ± 4.8% | 585.1 ± 25.7% | 0.756 | 1.150 | 2.802 | 2.753 | 2.984 |
| qlog records, JSON text sequence | 1467503 | 1470.8 ± 3.5% | 1864.7 ± 3.4% | 1218.6 ± 1.2% | 578.9 ± 3.9% | 703.6 ± 1.0% | 492.0 ± 3.5% | 0.789 | 1.207 | 2.541 | 2.091 | 2.990 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.802 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.842 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.863 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.660 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.821 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.600 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.615 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.756 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.789 of simdjson.

# bench-json, CLDR and qlog alone: null, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1632.8 ± 3.9% | 0.523 | 0.975 | 1.007 | 0.985 | 0.392 | 1.014 | 1.005 | 0.381 | 0.835 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1325.2 ± 6.3% | 0.872 | 1.009 | 0.967 | 0.957 | 0.378 | 0.977 | 0.916 | 0.374 | 0.718 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2360.8 ± 5.2% | 0.441 | 0.939 | 0.958 | 1.000 | 0.976 | 0.262 | 0.974 | 0.460 | 0.727 | 0.085 | 0.974 |
| qlog records, JSON text sequence | 1467503 | 2018.3 ± 3.8% | 0.715 | 0.911 | 0.978 | 0.986 | 0.983 | 0.260 | 0.987 | 0.426 | 0.720 | 0.100 | 0.992 |

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
| CLDR supplemental, 34 texts | 920675 | 1632.8 ± 3.9% | 2063.5 ± 3.3% | 1661.1 ± 4.4% | 514.2 ± 8.0% | 801.2 ± 6.7% | 466.6 ± 3.1% | 0.791 | 0.983 | 3.175 | 2.038 | 3.499 |
| qlog records, JSON text sequence | 1467503 | 1325.2 ± 6.3% | 1587.0 ± 3.5% | 1574.6 ± 3.1% | 454.3 ± 3.5% | 935.0 ± 5.2% | 484.7 ± 5.4% | 0.835 | 0.842 | 2.917 | 1.417 | 2.734 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2360.8 ± 5.2% | 2286.1 ± 3.3% | 1492.0 ± 1.2% | 608.2 ± 3.1% | 625.7 ± 3.2% | 590.6 ± 4.4% | 1.033 | 1.582 | 3.882 | 3.773 | 3.997 |
| qlog records, JSON text sequence | 1467503 | 2018.3 ± 3.8% | 1846.5 ± 14.8% | 1197.1 ± 43.9% | 580.8 ± 3.8% | 693.2 ± 0.4% | 479.8 ± 3.7% | 1.093 | 1.686 | 3.475 | 2.912 | 4.207 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2300.1 ± 2.5% | 2286.1 ± 3.3% | 1492.0 ± 1.2% | 608.2 ± 3.1% | 625.7 ± 3.2% | 590.6 ± 4.4% | 1.006 | 1.542 | 3.782 | 3.676 | 3.895 |
| qlog records, JSON text sequence | 1467503 | 2002.8 ± 0.4% | 1846.5 ± 14.8% | 1197.1 ± 43.9% | 580.8 ± 3.8% | 693.2 ± 0.4% | 479.8 ± 3.7% | 1.085 | 1.673 | 3.448 | 2.889 | 4.174 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1362.6 ± 8.0% | 2063.5 ± 3.3% | 1661.1 ± 4.4% | 514.2 ± 8.0% | 801.2 ± 6.7% | 466.6 ± 3.1% | 0.660 | 0.820 | 2.650 | 1.701 | 2.920 |
| qlog records, JSON text sequence | 1467503 | 950.9 ± 5.6% | 1587.0 ± 3.5% | 1574.6 ± 3.1% | 454.3 ± 3.5% | 935.0 ± 5.2% | 484.7 ± 5.4% | 0.599 | 0.604 | 2.093 | 1.017 | 1.962 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1717.1 ± 3.2% | 2286.1 ± 3.3% | 1492.0 ± 1.2% | 608.2 ± 3.1% | 625.7 ± 3.2% | 590.6 ± 4.4% | 0.751 | 1.151 | 2.823 | 2.744 | 2.908 |
| qlog records, JSON text sequence | 1467503 | 1452.6 ± 0.7% | 1846.5 ± 14.8% | 1197.1 ± 43.9% | 580.8 ± 3.8% | 693.2 ± 0.4% | 479.8 ± 3.7% | 0.787 | 1.213 | 2.501 | 2.096 | 3.028 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.791 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.835 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.842 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.660 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.820 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.599 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.604 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.751 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.787 of simdjson.

# bench-json, CLDR and qlog alone: head, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1627.1 ± 9.1% | 0.525 | 0.982 | 1.024 | 1.026 | 0.396 | 1.043 | 1.052 | 0.412 | 0.786 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 1328.2 ± 4.9% | 0.875 | 1.018 | 0.975 | 0.970 | 0.379 | 0.979 | 1.011 | 0.374 | 0.849 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2318.3 ± 2.5% | 0.446 | 0.949 | 0.967 | 1.001 | 0.998 | 0.267 | 1.003 | 0.469 | 0.738 | 0.087 | 0.992 |
| qlog records, JSON text sequence | 1467503 | 2109.9 ± 4.4% | 0.708 | 0.916 | 0.966 | 0.988 | 0.983 | 0.262 | 0.970 | 0.423 | 0.714 | 0.097 | 0.984 |

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
| CLDR supplemental, 34 texts | 920675 | 1627.1 ± 9.1% | 2030.1 ± 7.4% | 1679.3 ± 7.5% | 533.1 ± 4.1% | 748.6 ± 6.0% | 476.1 ± 8.9% | 0.801 | 0.969 | 3.052 | 2.173 | 3.417 |
| qlog records, JSON text sequence | 1467503 | 1328.2 ± 4.9% | 1554.4 ± 8.6% | 1553.4 ± 7.5% | 448.1 ± 7.0% | 919.9 ± 5.9% | 461.2 ± 3.1% | 0.854 | 0.855 | 2.964 | 1.444 | 2.880 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2318.3 ± 2.5% | 2285.7 ± 6.8% | 1481.7 ± 3.6% | 607.4 ± 3.5% | 552.1 ± 12.5% | 590.9 ± 3.0% | 1.014 | 1.565 | 3.817 | 4.199 | 3.923 |
| qlog records, JSON text sequence | 1467503 | 2109.9 ± 4.4% | 1946.9 ± 4.3% | 1226.1 ± 5.0% | 587.8 ± 30.5% | 716.7 ± 8.2% | 494.7 ± 7.8% | 1.084 | 1.721 | 3.590 | 2.944 | 4.265 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2300.4 ± 2.5% | 2285.7 ± 6.8% | 1481.7 ± 3.6% | 607.4 ± 3.5% | 552.1 ± 12.5% | 590.9 ± 3.0% | 1.006 | 1.552 | 3.787 | 4.166 | 3.893 |
| qlog records, JSON text sequence | 1467503 | 2076.2 ± 6.6% | 1946.9 ± 4.3% | 1226.1 ± 5.0% | 587.8 ± 30.5% | 716.7 ± 8.2% | 494.7 ± 7.8% | 1.066 | 1.693 | 3.532 | 2.897 | 4.197 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1279.5 ± 5.6% | 2030.1 ± 7.4% | 1679.3 ± 7.5% | 533.1 ± 4.1% | 748.6 ± 6.0% | 476.1 ± 8.9% | 0.630 | 0.762 | 2.400 | 1.709 | 2.687 |
| qlog records, JSON text sequence | 1467503 | 1127.6 ± 11.0% | 1554.4 ± 8.6% | 1553.4 ± 7.5% | 448.1 ± 7.0% | 919.9 ± 5.9% | 461.2 ± 3.1% | 0.725 | 0.726 | 2.517 | 1.226 | 2.445 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1710.8 ± 1.7% | 2285.7 ± 6.8% | 1481.7 ± 3.6% | 607.4 ± 3.5% | 552.1 ± 12.5% | 590.9 ± 3.0% | 0.748 | 1.155 | 2.817 | 3.099 | 2.895 |
| qlog records, JSON text sequence | 1467503 | 1506.3 ± 8.7% | 1946.9 ± 4.3% | 1226.1 ± 5.0% | 587.8 ± 30.5% | 716.7 ± 8.2% | 494.7 ± 7.8% | 0.774 | 1.228 | 2.563 | 2.102 | 3.045 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.801 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.854 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.855 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.630 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.762 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.725 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.726 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.748 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.774 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1617.5 ± 6.7% | 0.530 | 0.959 | 1.016 | 1.020 | 0.396 | 1.018 | 1.008 | 0.385 | 0.837 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1274.0 ± 6.4% | 0.919 | 0.988 | 0.999 | 1.009 | 0.384 | 1.027 | 1.011 | 0.311 | 0.685 | 0.106 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2279.6 ± 2.1% | 0.441 | 0.936 | 0.963 | 0.991 | 0.992 | 0.262 | 0.990 | 0.462 | 0.727 | 0.082 | 0.992 |
| qlog records, JSON text sequence | 1467503 | 2001.4 ± 1.1% | 0.712 | 0.918 | 0.979 | 0.987 | 0.991 | 0.258 | 0.985 | 0.427 | 0.717 | 0.100 | 1.001 |

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
| CLDR supplemental, 34 texts | 920675 | 1617.5 ± 6.7% | 2076.4 ± 7.2% | 1630.7 ± 21.7% | 504.9 ± 43.8% | 810.4 ± 6.9% | 472.3 ± 4.9% | 0.779 | 0.992 | 3.203 | 1.996 | 3.425 |
| qlog records, JSON text sequence | 1467503 | 1274.0 ± 6.4% | 1442.1 ± 4.9% | 1460.9 ± 3.0% | 417.2 ± 4.1% | 904.5 ± 3.3% | 455.2 ± 24.0% | 0.883 | 0.872 | 3.053 | 1.408 | 2.799 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2279.6 ± 2.1% | 2226.3 ± 0.8% | 1453.4 ± 1.4% | 593.5 ± 1.8% | 615.5 ± 3.9% | 567.7 ± 1.5% | 1.024 | 1.568 | 3.841 | 3.704 | 4.016 |
| qlog records, JSON text sequence | 1467503 | 2001.4 ± 1.1% | 1850.6 ± 27.8% | 1185.0 ± 2.0% | 565.7 ± 1.8% | 683.2 ± 2.5% | 466.5 ± 9.2% | 1.082 | 1.689 | 3.538 | 2.930 | 4.291 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2260.4 ± 28.9% | 2226.3 ± 0.8% | 1453.4 ± 1.4% | 593.5 ± 1.8% | 615.5 ± 3.9% | 567.7 ± 1.5% | 1.015 | 1.555 | 3.809 | 3.673 | 3.982 |
| qlog records, JSON text sequence | 1467503 | 2003.9 ± 2.1% | 1850.6 ± 27.8% | 1185.0 ± 2.0% | 565.7 ± 1.8% | 683.2 ± 2.5% | 466.5 ± 9.2% | 1.083 | 1.691 | 3.542 | 2.933 | 4.296 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1354.3 ± 2.6% | 2076.4 ± 7.2% | 1630.7 ± 21.7% | 504.9 ± 43.8% | 810.4 ± 6.9% | 472.3 ± 4.9% | 0.652 | 0.831 | 2.682 | 1.671 | 2.868 |
| qlog records, JSON text sequence | 1467503 | 872.5 ± 22.7% | 1442.1 ± 4.9% | 1460.9 ± 3.0% | 417.2 ± 4.1% | 904.5 ± 3.3% | 455.2 ± 24.0% | 0.605 | 0.597 | 2.091 | 0.965 | 1.917 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1657.8 ± 2.5% | 2226.3 ± 0.8% | 1453.4 ± 1.4% | 593.5 ± 1.8% | 615.5 ± 3.9% | 567.7 ± 1.5% | 0.745 | 1.141 | 2.793 | 2.693 | 2.920 |
| qlog records, JSON text sequence | 1467503 | 1435.0 ± 20.6% | 1850.6 ± 27.8% | 1185.0 ± 2.0% | 565.7 ± 1.8% | 683.2 ± 2.5% | 466.5 ± 9.2% | 0.775 | 1.211 | 2.537 | 2.101 | 3.076 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.779 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.883 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.872 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.652 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.605 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.597 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.745 of simdjson.

# bench-json, CLDR and qlog alone: null, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1562.4 ± 2.2% | 0.535 | 0.999 | 1.020 | 1.023 | 0.401 | 1.022 | 1.031 | 0.398 | 0.843 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 1287.4 ± 3.3% | 0.887 | 1.017 | 0.988 | 0.975 | 0.378 | 0.982 | 0.982 | 0.341 | 0.715 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2272.8 ± 1.9% | 0.449 | 0.958 | 0.971 | 1.003 | 0.986 | 0.268 | 0.986 | 0.462 | 0.740 | 0.086 | 0.991 |
| qlog records, JSON text sequence | 1467503 | 1991.2 ± 7.3% | 0.720 | 0.921 | 0.982 | 1.001 | 0.976 | 0.262 | 0.979 | 0.422 | 0.722 | 0.100 | 0.986 |

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
| CLDR supplemental, 34 texts | 920675 | 1562.4 ± 2.2% | 1974.6 ± 1.8% | 1598.1 ± 8.1% | 504.4 ± 4.2% | 794.8 ± 6.8% | 449.8 ± 4.3% | 0.791 | 0.978 | 3.098 | 1.966 | 3.473 |
| qlog records, JSON text sequence | 1467503 | 1287.4 ± 3.3% | 1532.7 ± 2.5% | 1522.3 ± 3.0% | 432.8 ± 4.3% | 876.7 ± 5.3% | 459.9 ± 2.1% | 0.840 | 0.846 | 2.975 | 1.468 | 2.799 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2272.8 ± 1.9% | 2210.2 ± 2.5% | 1459.8 ± 5.2% | 591.1 ± 6.9% | 619.6 ± 1.8% | 561.4 ± 4.2% | 1.028 | 1.557 | 3.845 | 3.668 | 4.049 |
| qlog records, JSON text sequence | 1467503 | 1991.2 ± 7.3% | 1848.1 ± 1.7% | 1192.4 ± 5.8% | 579.1 ± 5.4% | 684.3 ± 6.5% | 468.9 ± 4.7% | 1.077 | 1.670 | 3.439 | 2.910 | 4.247 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2251.8 ± 3.0% | 2210.2 ± 2.5% | 1459.8 ± 5.2% | 591.1 ± 6.9% | 619.6 ± 1.8% | 561.4 ± 4.2% | 1.019 | 1.543 | 3.810 | 3.634 | 4.011 |
| qlog records, JSON text sequence | 1467503 | 1962.5 ± 2.2% | 1848.1 ± 1.7% | 1192.4 ± 5.8% | 579.1 ± 5.4% | 684.3 ± 6.5% | 468.9 ± 4.7% | 1.062 | 1.646 | 3.389 | 2.868 | 4.185 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1316.6 ± 3.2% | 1974.6 ± 1.8% | 1598.1 ± 8.1% | 504.4 ± 4.2% | 794.8 ± 6.8% | 449.8 ± 4.3% | 0.667 | 0.824 | 2.610 | 1.656 | 2.927 |
| qlog records, JSON text sequence | 1467503 | 920.5 ± 3.9% | 1532.7 ± 2.5% | 1522.3 ± 3.0% | 432.8 ± 4.3% | 876.7 ± 5.3% | 459.9 ± 2.1% | 0.601 | 0.605 | 2.127 | 1.050 | 2.001 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1681.5 ± 0.8% | 2210.2 ± 2.5% | 1459.8 ± 5.2% | 591.1 ± 6.9% | 619.6 ± 1.8% | 561.4 ± 4.2% | 0.761 | 1.152 | 2.845 | 2.714 | 2.995 |
| qlog records, JSON text sequence | 1467503 | 1436.7 ± 1.2% | 1848.1 ± 1.7% | 1192.4 ± 5.8% | 579.1 ± 5.4% | 684.3 ± 6.5% | 468.9 ± 4.7% | 0.777 | 1.205 | 2.481 | 2.100 | 3.064 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.791 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.840 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.846 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.667 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.824 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.601 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.605 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.761 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.777 of simdjson.

# bench-json, CLDR and qlog alone: head, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1600.2 ± 3.1% | 0.526 | 0.986 | 1.019 | 1.017 | 0.396 | 1.008 | 1.015 | 0.395 | 0.783 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1297.3 ± 3.5% | 0.879 | 1.040 | 0.993 | 0.987 | 0.385 | 0.961 | 0.990 | 0.371 | 0.844 | 0.112 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2315.0 ± 0.9% | 0.450 | 0.955 | 0.971 | 0.998 | 1.003 | 0.269 | 1.001 | 0.466 | 0.730 | 0.085 | 0.978 |
| qlog records, JSON text sequence | 1467503 | 1930.2 ± 11.0% | 0.721 | 0.945 | 1.022 | 1.030 | 1.029 | 0.267 | 0.982 | 0.442 | 0.739 | 0.099 | 1.000 |

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
| CLDR supplemental, 34 texts | 920675 | 1600.2 ± 3.1% | 2020.6 ± 4.3% | 1615.3 ± 2.7% | 523.1 ± 2.3% | 733.9 ± 2.5% | 464.0 ± 4.3% | 0.792 | 0.991 | 3.059 | 2.180 | 3.449 |
| qlog records, JSON text sequence | 1467503 | 1297.3 ± 3.5% | 1314.1 ± 2.7% | 1523.9 ± 5.9% | 440.1 ± 1.8% | 907.1 ± 9.9% | 465.4 ± 28.0% | 0.987 | 0.851 | 2.948 | 1.430 | 2.787 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2315.0 ± 0.9% | 2283.1 ± 6.8% | 1455.4 ± 2.7% | 587.9 ± 5.5% | 542.5 ± 4.1% | 583.9 ± 3.7% | 1.014 | 1.591 | 3.938 | 4.267 | 3.964 |
| qlog records, JSON text sequence | 1467503 | 1930.2 ± 11.0% | 1768.0 ± 9.4% | 1139.6 ± 5.8% | 562.0 ± 9.0% | 675.4 ± 6.4% | 449.0 ± 9.5% | 1.092 | 1.694 | 3.435 | 2.858 | 4.299 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2263.5 ± 6.3% | 2283.1 ± 6.8% | 1455.4 ± 2.7% | 587.9 ± 5.5% | 542.5 ± 4.1% | 583.9 ± 3.7% | 0.991 | 1.555 | 3.850 | 4.172 | 3.876 |
| qlog records, JSON text sequence | 1467503 | 1929.4 ± 7.2% | 1768.0 ± 9.4% | 1139.6 ± 5.8% | 562.0 ± 9.0% | 675.4 ± 6.4% | 449.0 ± 9.5% | 1.091 | 1.693 | 3.433 | 2.857 | 4.297 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1252.5 ± 1.6% | 2020.6 ± 4.3% | 1615.3 ± 2.7% | 523.1 ± 2.3% | 733.9 ± 2.5% | 464.0 ± 4.3% | 0.620 | 0.775 | 2.394 | 1.707 | 2.700 |
| qlog records, JSON text sequence | 1467503 | 1095.5 ± 1.0% | 1314.1 ± 2.7% | 1523.9 ± 5.9% | 440.1 ± 1.8% | 907.1 ± 9.9% | 465.4 ± 28.0% | 0.834 | 0.719 | 2.489 | 1.208 | 2.354 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1689.4 ± 2.7% | 2283.1 ± 6.8% | 1455.4 ± 2.7% | 587.9 ± 5.5% | 542.5 ± 4.1% | 583.9 ± 3.7% | 0.740 | 1.161 | 2.874 | 3.114 | 2.893 |
| qlog records, JSON text sequence | 1467503 | 1425.8 ± 6.6% | 1768.0 ± 9.4% | 1139.6 ± 5.8% | 562.0 ± 9.0% | 675.4 ± 6.4% | 449.0 ± 9.5% | 0.806 | 1.251 | 2.537 | 2.111 | 3.175 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.792 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.851 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.620 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.775 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.834 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.719 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.740 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.806 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1549.7 ± 4.1% | 0.538 | 0.967 | 0.998 | 0.978 | 0.395 | 1.001 | 0.997 | 0.391 | 0.838 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 1258.1 ± 6.1% | 0.902 | 0.994 | 1.002 | 1.014 | 0.383 | 1.006 | 1.027 | 0.366 | 0.711 | 0.107 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2248.0 ± 25.8% | 0.437 | 0.936 | 0.961 | 0.994 | 0.993 | 0.262 | 0.995 | 0.462 | 0.730 | 0.081 | 0.999 |
| qlog records, JSON text sequence | 1467503 | 1978.0 ± 0.9% | 0.703 | 0.915 | 0.976 | 0.992 | 0.973 | 0.256 | 0.976 | 0.423 | 0.718 | 0.100 | 0.987 |

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
| CLDR supplemental, 34 texts | 920675 | 1549.7 ± 4.1% | 1990.5 ± 4.1% | 1592.1 ± 6.0% | 504.5 ± 3.4% | 787.2 ± 9.2% | 442.9 ± 20.2% | 0.779 | 0.973 | 3.072 | 1.969 | 3.499 |
| qlog records, JSON text sequence | 1467503 | 1258.1 ± 6.1% | 1536.0 ± 3.4% | 1408.1 ± 6.0% | 432.5 ± 2.4% | 887.2 ± 6.8% | 452.7 ± 3.7% | 0.819 | 0.893 | 2.909 | 1.418 | 2.779 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2248.0 ± 25.8% | 2214.4 ± 3.6% | 1420.7 ± 2.9% | 582.6 ± 1.3% | 617.6 ± 3.1% | 561.1 ± 33.4% | 1.015 | 1.582 | 3.859 | 3.640 | 4.007 |
| qlog records, JSON text sequence | 1467503 | 1978.0 ± 0.9% | 1826.4 ± 5.2% | 1145.4 ± 7.8% | 557.3 ± 6.9% | 663.1 ± 12.6% | 468.5 ± 8.5% | 1.083 | 1.727 | 3.549 | 2.983 | 4.222 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2246.4 ± 1.5% | 2214.4 ± 3.6% | 1420.7 ± 2.9% | 582.6 ± 1.3% | 617.6 ± 3.1% | 561.1 ± 33.4% | 1.014 | 1.581 | 3.856 | 3.637 | 4.004 |
| qlog records, JSON text sequence | 1467503 | 1953.1 ± 9.1% | 1826.4 ± 5.2% | 1145.4 ± 7.8% | 557.3 ± 6.9% | 663.1 ± 12.6% | 468.5 ± 8.5% | 1.069 | 1.705 | 3.505 | 2.945 | 4.168 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1299.3 ± 3.4% | 1990.5 ± 4.1% | 1592.1 ± 6.0% | 504.5 ± 3.4% | 787.2 ± 9.2% | 442.9 ± 20.2% | 0.653 | 0.816 | 2.575 | 1.651 | 2.933 |
| qlog records, JSON text sequence | 1467503 | 894.7 ± 4.8% | 1536.0 ± 3.4% | 1408.1 ± 6.0% | 432.5 ± 2.4% | 887.2 ± 6.8% | 452.7 ± 3.7% | 0.583 | 0.635 | 2.069 | 1.008 | 1.976 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1641.4 ± 5.6% | 2214.4 ± 3.6% | 1420.7 ± 2.9% | 582.6 ± 1.3% | 617.6 ± 3.1% | 561.1 ± 33.4% | 0.741 | 1.155 | 2.817 | 2.658 | 2.926 |
| qlog records, JSON text sequence | 1467503 | 1419.8 ± 2.0% | 1826.4 ± 5.2% | 1145.4 ± 7.8% | 557.3 ± 6.9% | 663.1 ± 12.6% | 468.5 ± 8.5% | 0.777 | 1.240 | 2.548 | 2.141 | 3.030 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.779 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.819 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.893 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.653 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.816 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.583 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.635 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.741 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.777 of simdjson.

# bench-json, CLDR and qlog alone: null, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1590.0 ± 13.2% | 0.521 | 0.960 | 0.990 | 1.006 | 0.390 | 1.003 | 1.004 | 0.393 | 0.825 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 1278.8 ± 5.0% | 0.869 | 1.012 | 0.979 | 0.960 | 0.370 | 0.978 | 0.980 | 0.328 | 0.705 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2208.8 ± 1.5% | 0.442 | 0.933 | 0.962 | 0.995 | 0.980 | 0.266 | 0.983 | 0.461 | 0.737 | 0.085 | 0.987 |
| qlog records, JSON text sequence | 1467503 | 1934.0 ± 5.2% | 0.723 | 0.921 | 0.973 | 0.989 | 0.996 | 0.257 | 0.969 | 0.420 | 0.716 | 0.100 | 0.985 |

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
| CLDR supplemental, 34 texts | 920675 | 1590.0 ± 13.2% | 2000.3 ± 3.6% | 1607.5 ± 2.6% | 497.5 ± 7.0% | 804.5 ± 3.0% | 449.3 ± 11.6% | 0.795 | 0.989 | 3.196 | 1.976 | 3.539 |
| qlog records, JSON text sequence | 1467503 | 1278.8 ± 5.0% | 1519.7 ± 5.3% | 1521.5 ± 8.0% | 415.0 ± 49.3% | 903.3 ± 6.4% | 461.3 ± 3.6% | 0.841 | 0.840 | 3.081 | 1.416 | 2.772 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2208.8 ± 1.5% | 2149.5 ± 4.4% | 1414.5 ± 4.5% | 573.6 ± 3.6% | 595.1 ± 6.4% | 548.2 ± 1.7% | 1.028 | 1.562 | 3.851 | 3.712 | 4.029 |
| qlog records, JSON text sequence | 1467503 | 1934.0 ± 5.2% | 1787.1 ± 6.3% | 1145.7 ± 4.7% | 570.1 ± 4.3% | 664.0 ± 4.7% | 464.0 ± 9.2% | 1.082 | 1.688 | 3.393 | 2.913 | 4.168 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2179.4 ± 2.6% | 2149.5 ± 4.4% | 1414.5 ± 4.5% | 573.6 ± 3.6% | 595.1 ± 6.4% | 548.2 ± 1.7% | 1.014 | 1.541 | 3.800 | 3.662 | 3.975 |
| qlog records, JSON text sequence | 1467503 | 1905.3 ± 3.6% | 1787.1 ± 6.3% | 1145.7 ± 4.7% | 570.1 ± 4.3% | 664.0 ± 4.7% | 464.0 ± 9.2% | 1.066 | 1.663 | 3.342 | 2.869 | 4.106 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1311.1 ± 1.7% | 2000.3 ± 3.6% | 1607.5 ± 2.6% | 497.5 ± 7.0% | 804.5 ± 3.0% | 449.3 ± 11.6% | 0.655 | 0.816 | 2.635 | 1.630 | 2.918 |
| qlog records, JSON text sequence | 1467503 | 901.1 ± 4.1% | 1519.7 ± 5.3% | 1521.5 ± 8.0% | 415.0 ± 49.3% | 903.3 ± 6.4% | 461.3 ± 3.6% | 0.593 | 0.592 | 2.171 | 0.998 | 1.953 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1627.3 ± 6.4% | 2149.5 ± 4.4% | 1414.5 ± 4.5% | 573.6 ± 3.6% | 595.1 ± 6.4% | 548.2 ± 1.7% | 0.757 | 1.150 | 2.837 | 2.734 | 2.968 |
| qlog records, JSON text sequence | 1467503 | 1385.0 ± 7.3% | 1787.1 ± 6.3% | 1145.7 ± 4.7% | 570.1 ± 4.3% | 664.0 ± 4.7% | 464.0 ± 9.2% | 0.775 | 1.209 | 2.429 | 2.086 | 2.985 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.795 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.841 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.840 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.655 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.816 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.593 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.592 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.757 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.775 of simdjson.

# bench-json, CLDR and qlog alone: head, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1492.5 ± 6.6% | 0.534 | 1.017 | 1.056 | 1.045 | 0.404 | 1.036 | 1.050 | 0.405 | 0.797 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 1246.5 ± 3.8% | 0.871 | 1.008 | 0.967 | 0.963 | 0.383 | 0.970 | 0.960 | 0.370 | 0.830 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2185.7 ± 3.4% | 0.448 | 0.950 | 0.967 | 0.992 | 0.994 | 0.264 | 1.006 | 0.468 | 0.731 | 0.087 | 0.976 |
| qlog records, JSON text sequence | 1467503 | 1930.9 ± 2.6% | 0.703 | 0.914 | 0.976 | 0.982 | 0.988 | 0.260 | 0.954 | 0.433 | 0.729 | 0.099 | 1.001 |

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
| CLDR supplemental, 34 texts | 920675 | 1492.5 ± 6.6% | 1893.4 ± 3.8% | 1545.7 ± 4.0% | 501.5 ± 2.6% | 697.9 ± 2.2% | 438.8 ± 4.8% | 0.788 | 0.966 | 2.976 | 2.139 | 3.401 |
| qlog records, JSON text sequence | 1467503 | 1246.5 ± 3.8% | 1424.5 ± 3.5% | 1446.8 ± 1.4% | 426.3 ± 3.7% | 866.7 ± 2.3% | 436.8 ± 4.0% | 0.875 | 0.862 | 2.924 | 1.438 | 2.853 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2185.7 ± 3.4% | 2153.0 ± 3.7% | 1403.3 ± 5.4% | 575.0 ± 4.8% | 522.9 ± 4.6% | 555.5 ± 4.4% | 1.015 | 1.558 | 3.801 | 4.180 | 3.935 |
| qlog records, JSON text sequence | 1467503 | 1930.9 ± 2.6% | 1794.0 ± 5.9% | 1144.9 ± 39.5% | 557.3 ± 6.4% | 664.5 ± 4.1% | 469.2 ± 5.4% | 1.076 | 1.687 | 3.465 | 2.906 | 4.116 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2132.5 ± 4.4% | 2153.0 ± 3.7% | 1403.3 ± 5.4% | 575.0 ± 4.8% | 522.9 ± 4.6% | 555.5 ± 4.4% | 0.990 | 1.520 | 3.709 | 4.078 | 3.839 |
| qlog records, JSON text sequence | 1467503 | 1932.2 ± 33.3% | 1794.0 ± 5.9% | 1144.9 ± 39.5% | 557.3 ± 6.4% | 664.5 ± 4.1% | 469.2 ± 5.4% | 1.077 | 1.688 | 3.467 | 2.908 | 4.118 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1190.3 ± 4.2% | 1893.4 ± 3.8% | 1545.7 ± 4.0% | 501.5 ± 2.6% | 697.9 ± 2.2% | 438.8 ± 4.8% | 0.629 | 0.770 | 2.373 | 1.705 | 2.713 |
| qlog records, JSON text sequence | 1467503 | 1035.0 ± 2.3% | 1424.5 ± 3.5% | 1446.8 ± 1.4% | 426.3 ± 3.7% | 866.7 ± 2.3% | 436.8 ± 4.0% | 0.727 | 0.715 | 2.428 | 1.194 | 2.369 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1596.9 ± 6.4% | 2153.0 ± 3.7% | 1403.3 ± 5.4% | 575.0 ± 4.8% | 522.9 ± 4.6% | 555.5 ± 4.4% | 0.742 | 1.138 | 2.777 | 3.054 | 2.875 |
| qlog records, JSON text sequence | 1467503 | 1407.5 ± 4.7% | 1794.0 ± 5.9% | 1144.9 ± 39.5% | 557.3 ± 6.4% | 664.5 ± 4.1% | 469.2 ± 5.4% | 0.785 | 1.229 | 2.525 | 2.118 | 3.000 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.788 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.875 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.862 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.629 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.770 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.727 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.715 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.742 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.785 of simdjson.
