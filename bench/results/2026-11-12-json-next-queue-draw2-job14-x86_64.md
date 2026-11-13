# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.2 ± 3.0% | 0.479 | 1.008 | 0.993 | 0.999 | 0.374 | 0.997 | 1.000 | 0.348 | 0.780 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1065.7 ± 0.6% | 0.794 | 1.020 | 1.024 | 1.036 | 0.375 | 1.009 | 1.020 | 0.337 | 0.690 | 0.119 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1732.3 ± 1.8% | 0.427 | 0.984 | 0.968 | 1.009 | 1.010 | 0.254 | 1.004 | 0.446 | 0.748 | 0.088 | 1.025 |
| qlog records, JSON text sequence | 1467503 | 1484.1 ± 1.1% | 0.683 | 0.955 | 0.993 | 0.996 | 0.994 | 0.253 | 0.997 | 0.422 | 0.730 | 0.114 | 1.018 |

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
| CLDR supplemental, 34 texts | 920675 | 1339.2 ± 3.0% | 1335.7 ± 0.3% | 1211.8 ± 1.0% | 355.0 ± 0.6% | 660.3 ± 1.6% | 319.9 ± 2.6% | 1.003 | 1.105 | 3.772 | 2.028 | 4.186 |
| qlog records, JSON text sequence | 1467503 | 1065.7 ± 0.6% | 1035.2 ± 1.5% | 1071.3 ± 3.7% | 300.0 ± 1.1% | 730.0 ± 0.5% | 315.3 ± 3.9% | 1.029 | 0.995 | 3.552 | 1.460 | 3.380 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1732.3 ± 1.8% | 1585.8 ± 1.3% | 1146.3 ± 0.8% | 424.0 ± 5.8% | 459.7 ± 0.8% | 412.4 ± 1.1% | 1.092 | 1.511 | 4.086 | 3.769 | 4.201 |
| qlog records, JSON text sequence | 1467503 | 1484.1 ± 1.1% | 1310.9 ± 0.7% | 902.6 ± 0.3% | 425.1 ± 0.3% | 487.2 ± 0.8% | 322.1 ± 1.1% | 1.132 | 1.644 | 3.491 | 3.046 | 4.608 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1775.5 ± 0.8% | 1585.8 ± 1.3% | 1146.3 ± 0.8% | 424.0 ± 5.8% | 459.7 ± 0.8% | 412.4 ± 1.1% | 1.120 | 1.549 | 4.188 | 3.863 | 4.305 |
| qlog records, JSON text sequence | 1467503 | 1510.7 ± 0.4% | 1310.9 ± 0.7% | 902.6 ± 0.3% | 425.1 ± 0.3% | 487.2 ± 0.8% | 322.1 ± 1.1% | 1.152 | 1.674 | 3.554 | 3.101 | 4.690 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1044.6 ± 0.5% | 1335.7 ± 0.3% | 1211.8 ± 1.0% | 355.0 ± 0.6% | 660.3 ± 1.6% | 319.9 ± 2.6% | 0.782 | 0.862 | 2.943 | 1.582 | 3.265 |
| qlog records, JSON text sequence | 1467503 | 735.7 ± 2.8% | 1035.2 ± 1.5% | 1071.3 ± 3.7% | 300.0 ± 1.1% | 730.0 ± 0.5% | 315.3 ± 3.9% | 0.711 | 0.687 | 2.452 | 1.008 | 2.333 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1296.5 ± 0.7% | 1585.8 ± 1.3% | 1146.3 ± 0.8% | 424.0 ± 5.8% | 459.7 ± 0.8% | 412.4 ± 1.1% | 0.818 | 1.131 | 3.058 | 2.820 | 3.144 |
| qlog records, JSON text sequence | 1467503 | 1083.2 ± 0.5% | 1310.9 ± 0.7% | 902.6 ± 0.3% | 425.1 ± 0.3% | 487.2 ± 0.8% | 322.1 ± 1.1% | 0.826 | 1.200 | 2.548 | 2.223 | 3.363 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.782 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.862 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.711 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.687 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.818 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.826 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1420.2 ± 4.4% | 0.431 | 0.926 | 0.945 | 0.942 | 0.353 | 0.962 | 0.931 | 0.331 | 0.766 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1098.9 ± 2.7% | 0.731 | 0.973 | 0.941 | 0.943 | 0.357 | 0.969 | 0.945 | 0.319 | 0.802 | 0.113 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1742.2 ± 4.8% | 0.423 | 0.964 | 0.968 | 0.995 | 1.002 | 0.249 | 1.005 | 0.442 | 0.742 | 0.087 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1481.8 ± 0.2% | 0.684 | 0.945 | 0.997 | 0.995 | 0.990 | 0.249 | 0.993 | 0.424 | 0.733 | 0.114 | 1.013 |

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
| CLDR supplemental, 34 texts | 920675 | 1420.2 ± 4.4% | 1336.6 ± 1.5% | 1197.3 ± 5.6% | 356.6 ± 2.3% | 665.7 ± 1.6% | 318.8 ± 3.1% | 1.063 | 1.186 | 3.983 | 2.133 | 4.455 |
| qlog records, JSON text sequence | 1467503 | 1098.9 ± 2.7% | 1035.6 ± 0.9% | 1063.0 ± 0.8% | 297.2 ± 8.7% | 712.7 ± 9.5% | 310.9 ± 7.4% | 1.061 | 1.034 | 3.697 | 1.542 | 3.535 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1742.2 ± 4.8% | 1583.9 ± 1.0% | 1145.9 ± 1.7% | 422.6 ± 0.6% | 450.5 ± 2.5% | 413.6 ± 2.4% | 1.100 | 1.520 | 4.123 | 3.867 | 4.213 |
| qlog records, JSON text sequence | 1467503 | 1481.8 ± 0.2% | 1315.6 ± 5.8% | 898.0 ± 0.4% | 427.9 ± 4.2% | 495.3 ± 0.6% | 330.3 ± 0.7% | 1.126 | 1.650 | 3.463 | 2.991 | 4.486 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1772.2 ± 0.7% | 1583.9 ± 1.0% | 1145.9 ± 1.7% | 422.6 ± 0.6% | 450.5 ± 2.5% | 413.6 ± 2.4% | 1.119 | 1.547 | 4.194 | 3.934 | 4.285 |
| qlog records, JSON text sequence | 1467503 | 1501.0 ± 0.3% | 1315.6 ± 5.8% | 898.0 ± 0.4% | 427.9 ± 4.2% | 495.3 ± 0.6% | 330.3 ± 0.7% | 1.141 | 1.672 | 3.508 | 3.030 | 4.544 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1088.3 ± 2.1% | 1336.6 ± 1.5% | 1197.3 ± 5.6% | 356.6 ± 2.3% | 665.7 ± 1.6% | 318.8 ± 3.1% | 0.814 | 0.909 | 3.052 | 1.635 | 3.414 |
| qlog records, JSON text sequence | 1467503 | 881.2 ± 1.9% | 1035.6 ± 0.9% | 1063.0 ± 0.8% | 297.2 ± 8.7% | 712.7 ± 9.5% | 310.9 ± 7.4% | 0.851 | 0.829 | 2.965 | 1.236 | 2.835 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1293.1 ± 1.1% | 1583.9 ± 1.0% | 1145.9 ± 1.7% | 422.6 ± 0.6% | 450.5 ± 2.5% | 413.6 ± 2.4% | 0.816 | 1.128 | 3.060 | 2.870 | 3.127 |
| qlog records, JSON text sequence | 1467503 | 1086.8 ± 0.2% | 1315.6 ± 5.8% | 898.0 ± 0.4% | 427.9 ± 4.2% | 495.3 ± 0.6% | 330.3 ± 0.7% | 0.826 | 1.210 | 2.540 | 2.194 | 3.290 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.814 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.909 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.851 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.829 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.816 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.826 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1417.4 ± 2.2% | 0.429 | 0.919 | 0.934 | 0.934 | 0.352 | 0.960 | 0.911 | 0.332 | 0.730 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1103.7 ± 2.1% | 0.728 | 0.960 | 0.939 | 0.936 | 0.358 | 0.963 | 0.931 | 0.330 | 0.810 | 0.115 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1766.4 ± 1.1% | 0.417 | 0.947 | 0.958 | 0.983 | 0.992 | 0.246 | 0.990 | 0.436 | 0.733 | 0.086 | 1.002 |
| qlog records, JSON text sequence | 1467503 | 1489.7 ± 6.7% | 0.679 | 0.943 | 0.989 | 0.993 | 0.986 | 0.249 | 0.987 | 0.420 | 0.727 | 0.113 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1417.4 ± 2.2% | 1326.5 ± 1.0% | 1209.7 ± 6.2% | 351.6 ± 1.6% | 663.8 ± 0.7% | 319.6 ± 2.9% | 1.069 | 1.172 | 4.031 | 2.135 | 4.435 |
| qlog records, JSON text sequence | 1467503 | 1103.7 ± 2.1% | 1010.2 ± 1.2% | 1066.6 ± 3.2% | 297.0 ± 4.8% | 726.3 ± 1.2% | 314.3 ± 3.5% | 1.093 | 1.035 | 3.716 | 1.520 | 3.511 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1766.4 ± 1.1% | 1578.5 ± 0.8% | 1159.2 ± 2.7% | 424.2 ± 0.6% | 456.1 ± 7.5% | 416.4 ± 0.8% | 1.119 | 1.524 | 4.164 | 3.873 | 4.243 |
| qlog records, JSON text sequence | 1467503 | 1489.7 ± 6.7% | 1314.7 ± 0.2% | 886.0 ± 0.3% | 426.7 ± 0.9% | 497.5 ± 0.5% | 326.2 ± 4.1% | 1.133 | 1.681 | 3.491 | 2.995 | 4.567 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1770.3 ± 5.9% | 1578.5 ± 0.8% | 1159.2 ± 2.7% | 424.2 ± 0.6% | 456.1 ± 7.5% | 416.4 ± 0.8% | 1.122 | 1.527 | 4.173 | 3.881 | 4.252 |
| qlog records, JSON text sequence | 1467503 | 1504.7 ± 0.2% | 1314.7 ± 0.2% | 886.0 ± 0.3% | 426.7 ± 0.9% | 497.5 ± 0.5% | 326.2 ± 4.1% | 1.145 | 1.698 | 3.526 | 3.025 | 4.613 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1035.3 ± 2.3% | 1326.5 ± 1.0% | 1209.7 ± 6.2% | 351.6 ± 1.6% | 663.8 ± 0.7% | 319.6 ± 2.9% | 0.781 | 0.856 | 2.944 | 1.560 | 3.239 |
| qlog records, JSON text sequence | 1467503 | 893.9 ± 1.1% | 1010.2 ± 1.2% | 1066.6 ± 3.2% | 297.0 ± 4.8% | 726.3 ± 1.2% | 314.3 ± 3.5% | 0.885 | 0.838 | 3.009 | 1.231 | 2.844 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1295.3 ± 0.6% | 1578.5 ± 0.8% | 1159.2 ± 2.7% | 424.2 ± 0.6% | 456.1 ± 7.5% | 416.4 ± 0.8% | 0.821 | 1.117 | 3.053 | 2.840 | 3.111 |
| qlog records, JSON text sequence | 1467503 | 1083.6 ± 0.4% | 1314.7 ± 0.2% | 886.0 ± 0.3% | 426.7 ± 0.9% | 497.5 ± 0.5% | 326.2 ± 4.1% | 0.824 | 1.223 | 2.539 | 2.178 | 3.322 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.781 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.856 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.885 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.838 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.821 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.824 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1399.0 ± 17.4% | 0.433 | 0.896 | 0.937 | 0.936 | 0.360 | 0.958 | 0.935 | 0.337 | 0.736 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 1083.4 ± 3.3% | 0.725 | 0.984 | 0.947 | 0.942 | 0.357 | 0.978 | 0.950 | 0.331 | 0.825 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1748.9 ± 1.5% | 0.422 | 0.954 | 0.964 | 0.994 | 0.998 | 0.249 | 1.001 | 0.439 | 0.739 | 0.088 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1485.9 ± 2.7% | 0.681 | 0.945 | 0.987 | 0.991 | 0.982 | 0.251 | 0.982 | 0.421 | 0.727 | 0.114 | 1.006 |

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
| CLDR supplemental, 34 texts | 920675 | 1399.0 ± 17.4% | 1288.0 ± 1.6% | 1192.9 ± 10.2% | 355.9 ± 8.3% | 662.3 ± 20.7% | 318.0 ± 2.0% | 1.086 | 1.173 | 3.931 | 2.112 | 4.399 |
| qlog records, JSON text sequence | 1467503 | 1083.4 ± 3.3% | 973.1 ± 0.6% | 1043.2 ± 3.3% | 299.8 ± 4.1% | 721.0 ± 1.1% | 308.2 ± 17.8% | 1.113 | 1.039 | 3.614 | 1.503 | 3.515 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1748.9 ± 1.5% | 1562.0 ± 5.9% | 1162.9 ± 1.0% | 423.6 ± 0.6% | 445.9 ± 3.2% | 413.9 ± 0.5% | 1.120 | 1.504 | 4.129 | 3.922 | 4.225 |
| qlog records, JSON text sequence | 1467503 | 1485.9 ± 2.7% | 1308.5 ± 2.2% | 888.9 ± 33.0% | 422.0 ± 18.3% | 494.3 ± 4.2% | 326.7 ± 1.4% | 1.136 | 1.672 | 3.521 | 3.006 | 4.548 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1778.7 ± 0.3% | 1562.0 ± 5.9% | 1162.9 ± 1.0% | 423.6 ± 0.6% | 445.9 ± 3.2% | 413.9 ± 0.5% | 1.139 | 1.530 | 4.199 | 3.989 | 4.297 |
| qlog records, JSON text sequence | 1467503 | 1494.9 ± 6.7% | 1308.5 ± 2.2% | 888.9 ± 33.0% | 422.0 ± 18.3% | 494.3 ± 4.2% | 326.7 ± 1.4% | 1.142 | 1.682 | 3.543 | 3.024 | 4.575 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1029.9 ± 1.4% | 1288.0 ± 1.6% | 1192.9 ± 10.2% | 355.9 ± 8.3% | 662.3 ± 20.7% | 318.0 ± 2.0% | 0.800 | 0.863 | 2.894 | 1.555 | 3.239 |
| qlog records, JSON text sequence | 1467503 | 893.6 ± 4.2% | 973.1 ± 0.6% | 1043.2 ± 3.3% | 299.8 ± 4.1% | 721.0 ± 1.1% | 308.2 ± 17.8% | 0.918 | 0.857 | 2.981 | 1.239 | 2.899 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1291.9 ± 0.8% | 1562.0 ± 5.9% | 1162.9 ± 1.0% | 423.6 ± 0.6% | 445.9 ± 3.2% | 413.9 ± 0.5% | 0.827 | 1.111 | 3.050 | 2.897 | 3.121 |
| qlog records, JSON text sequence | 1467503 | 1080.4 ± 0.8% | 1308.5 ± 2.2% | 888.9 ± 33.0% | 422.0 ± 18.3% | 494.3 ± 4.2% | 326.7 ± 1.4% | 0.826 | 1.215 | 2.560 | 2.186 | 3.307 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.800 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.863 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.918 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.857 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.827 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.826 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1412.4 ± 1.6% | 0.434 | 0.906 | 0.938 | 0.938 | 0.356 | 0.963 | 0.933 | 0.333 | 0.752 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 1105.3 ± 0.6% | 0.730 | 0.968 | 0.938 | 0.939 | 0.358 | 0.967 | 0.929 | 0.333 | 0.835 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1753.7 ± 0.7% | 0.420 | 0.954 | 0.964 | 0.994 | 0.993 | 0.247 | 0.997 | 0.441 | 0.741 | 0.087 | 1.015 |
| qlog records, JSON text sequence | 1467503 | 1488.1 ± 1.1% | 0.681 | 0.942 | 0.989 | 0.999 | 0.989 | 0.248 | 0.987 | 0.422 | 0.729 | 0.113 | 1.009 |

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
| CLDR supplemental, 34 texts | 920675 | 1412.4 ± 1.6% | 1323.2 ± 15.6% | 1210.3 ± 3.0% | 356.4 ± 0.9% | 665.7 ± 0.4% | 318.3 ± 2.8% | 1.067 | 1.167 | 3.963 | 2.122 | 4.438 |
| qlog records, JSON text sequence | 1467503 | 1105.3 ± 0.6% | 1045.1 ± 2.2% | 1085.0 ± 3.9% | 304.5 ± 1.1% | 731.6 ± 0.4% | 312.4 ± 6.0% | 1.058 | 1.019 | 3.630 | 1.511 | 3.538 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1753.7 ± 0.7% | 1577.2 ± 5.8% | 1165.1 ± 1.7% | 423.2 ± 0.6% | 453.9 ± 3.1% | 414.8 ± 4.3% | 1.112 | 1.505 | 4.144 | 3.864 | 4.228 |
| qlog records, JSON text sequence | 1467503 | 1488.1 ± 1.1% | 1312.2 ± 0.5% | 874.8 ± 0.3% | 418.0 ± 2.6% | 483.6 ± 0.4% | 329.6 ± 1.1% | 1.134 | 1.701 | 3.560 | 3.077 | 4.514 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1779.6 ± 1.0% | 1577.2 ± 5.8% | 1165.1 ± 1.7% | 423.2 ± 0.6% | 453.9 ± 3.1% | 414.8 ± 4.3% | 1.128 | 1.527 | 4.205 | 3.921 | 4.290 |
| qlog records, JSON text sequence | 1467503 | 1501.7 ± 0.4% | 1312.2 ± 0.5% | 874.8 ± 0.3% | 418.0 ± 2.6% | 483.6 ± 0.4% | 329.6 ± 1.1% | 1.144 | 1.717 | 3.592 | 3.105 | 4.556 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1061.5 ± 2.0% | 1323.2 ± 15.6% | 1210.3 ± 3.0% | 356.4 ± 0.9% | 665.7 ± 0.4% | 318.3 ± 2.8% | 0.802 | 0.877 | 2.978 | 1.595 | 3.335 |
| qlog records, JSON text sequence | 1467503 | 923.2 ± 0.5% | 1045.1 ± 2.2% | 1085.0 ± 3.9% | 304.5 ± 1.1% | 731.6 ± 0.4% | 312.4 ± 6.0% | 0.883 | 0.851 | 3.032 | 1.262 | 2.955 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1300.2 ± 0.2% | 1577.2 ± 5.8% | 1165.1 ± 1.7% | 423.2 ± 0.6% | 453.9 ± 3.1% | 414.8 ± 4.3% | 0.824 | 1.116 | 3.072 | 2.865 | 3.135 |
| qlog records, JSON text sequence | 1467503 | 1084.5 ± 0.6% | 1312.2 ± 0.5% | 874.8 ± 0.3% | 418.0 ± 2.6% | 483.6 ± 0.4% | 329.6 ± 1.1% | 0.826 | 1.240 | 2.594 | 2.243 | 3.290 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.802 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.877 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.883 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.851 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.824 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.826 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1341.0 ± 3.0% | 0.482 | 0.998 | 0.988 | 0.994 | 0.373 | 0.982 | 0.989 | 0.349 | 0.778 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1060.3 ± 2.7% | 0.803 | 1.034 | 1.026 | 1.054 | 0.378 | 1.017 | 1.018 | 0.344 | 0.698 | 0.120 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1746.3 ± 7.2% | 0.425 | 0.975 | 0.969 | 1.008 | 0.990 | 0.251 | 1.001 | 0.442 | 0.744 | 0.087 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1483.3 ± 0.3% | 0.681 | 0.955 | 0.990 | 0.995 | 0.995 | 0.252 | 0.993 | 0.423 | 0.730 | 0.114 | 1.015 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.054 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1341.0 ± 3.0% | 1337.5 ± 0.7% | 1211.0 ± 1.1% | 355.3 ± 0.6% | 661.9 ± 2.4% | 314.3 ± 3.5% | 1.003 | 1.107 | 3.775 | 2.026 | 4.267 |
| qlog records, JSON text sequence | 1467503 | 1060.3 ± 2.7% | 1054.2 ± 0.2% | 1079.3 ± 3.8% | 305.2 ± 2.6% | 728.7 ± 2.0% | 314.0 ± 3.5% | 1.006 | 0.982 | 3.474 | 1.455 | 3.376 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1746.3 ± 7.2% | 1599.0 ± 0.8% | 1133.3 ± 2.5% | 424.9 ± 0.7% | 459.0 ± 0.3% | 413.2 ± 1.5% | 1.092 | 1.541 | 4.109 | 3.804 | 4.227 |
| qlog records, JSON text sequence | 1467503 | 1483.3 ± 0.3% | 1315.3 ± 0.3% | 901.8 ± 0.5% | 419.7 ± 8.3% | 484.6 ± 0.1% | 322.1 ± 2.5% | 1.128 | 1.645 | 3.534 | 3.061 | 4.605 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1784.1 ± 0.7% | 1599.0 ± 0.8% | 1133.3 ± 2.5% | 424.9 ± 0.7% | 459.0 ± 0.3% | 413.2 ± 1.5% | 1.116 | 1.574 | 4.199 | 3.887 | 4.318 |
| qlog records, JSON text sequence | 1467503 | 1505.8 ± 0.0% | 1315.3 ± 0.3% | 901.8 ± 0.5% | 419.7 ± 8.3% | 484.6 ± 0.1% | 322.1 ± 2.5% | 1.145 | 1.670 | 3.587 | 3.108 | 4.675 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1043.5 ± 0.5% | 1337.5 ± 0.7% | 1211.0 ± 1.1% | 355.3 ± 0.6% | 661.9 ± 2.4% | 314.3 ± 3.5% | 0.780 | 0.862 | 2.937 | 1.577 | 3.320 |
| qlog records, JSON text sequence | 1467503 | 740.2 ± 0.6% | 1054.2 ± 0.2% | 1079.3 ± 3.8% | 305.2 ± 2.6% | 728.7 ± 2.0% | 314.0 ± 3.5% | 0.702 | 0.686 | 2.425 | 1.016 | 2.357 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1299.1 ± 0.8% | 1599.0 ± 0.8% | 1133.3 ± 2.5% | 424.9 ± 0.7% | 459.0 ± 0.3% | 413.2 ± 1.5% | 0.812 | 1.146 | 3.057 | 2.830 | 3.144 |
| qlog records, JSON text sequence | 1467503 | 1082.6 ± 1.0% | 1315.3 ± 0.3% | 901.8 ± 0.5% | 419.7 ± 8.3% | 484.6 ± 0.1% | 322.1 ± 2.5% | 0.823 | 1.200 | 2.579 | 2.234 | 3.361 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.780 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.862 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.702 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.686 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.812 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.823 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1412.8 ± 1.5% | 0.427 | 0.903 | 0.931 | 0.939 | 0.356 | 0.962 | 0.940 | 0.333 | 0.759 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1096.3 ± 2.2% | 0.724 | 0.975 | 0.944 | 0.940 | 0.353 | 0.963 | 0.937 | 0.327 | 0.796 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1750.8 ± 1.5% | 0.422 | 0.959 | 0.969 | 0.990 | 1.000 | 0.248 | 1.000 | 0.440 | 0.741 | 0.087 | 1.019 |
| qlog records, JSON text sequence | 1467503 | 1484.3 ± 0.9% | 0.683 | 0.947 | 0.991 | 0.994 | 0.984 | 0.248 | 0.987 | 0.422 | 0.726 | 0.113 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1412.8 ± 1.5% | 1342.6 ± 0.2% | 1210.6 ± 0.8% | 351.4 ± 1.9% | 669.3 ± 1.9% | 318.2 ± 2.0% | 1.052 | 1.167 | 4.020 | 2.111 | 4.440 |
| qlog records, JSON text sequence | 1467503 | 1096.3 ± 2.2% | 1033.6 ± 2.1% | 1049.3 ± 7.4% | 295.5 ± 17.6% | 714.5 ± 2.7% | 312.2 ± 7.8% | 1.061 | 1.045 | 3.710 | 1.534 | 3.512 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1750.8 ± 1.5% | 1579.8 ± 1.0% | 1157.7 ± 1.7% | 423.7 ± 1.3% | 454.7 ± 2.9% | 415.2 ± 0.8% | 1.108 | 1.512 | 4.132 | 3.851 | 4.217 |
| qlog records, JSON text sequence | 1467503 | 1484.3 ± 0.9% | 1314.3 ± 0.5% | 903.8 ± 0.2% | 424.2 ± 0.6% | 494.2 ± 0.4% | 329.2 ± 1.8% | 1.129 | 1.642 | 3.499 | 3.003 | 4.508 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1784.5 ± 1.0% | 1579.8 ± 1.0% | 1157.7 ± 1.7% | 423.7 ± 1.3% | 454.7 ± 2.9% | 415.2 ± 0.8% | 1.130 | 1.541 | 4.211 | 3.925 | 4.298 |
| qlog records, JSON text sequence | 1467503 | 1499.2 ± 0.5% | 1314.3 ± 0.5% | 903.8 ± 0.2% | 424.2 ± 0.6% | 494.2 ± 0.4% | 329.2 ± 1.8% | 1.141 | 1.659 | 3.534 | 3.033 | 4.554 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1071.7 ± 0.9% | 1342.6 ± 0.2% | 1210.6 ± 0.8% | 351.4 ± 1.9% | 669.3 ± 1.9% | 318.2 ± 2.0% | 0.798 | 0.885 | 3.050 | 1.601 | 3.368 |
| qlog records, JSON text sequence | 1467503 | 872.4 ± 3.6% | 1033.6 ± 2.1% | 1049.3 ± 7.4% | 295.5 ± 17.6% | 714.5 ± 2.7% | 312.2 ± 7.8% | 0.844 | 0.831 | 2.952 | 1.221 | 2.794 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1297.5 ± 1.1% | 1579.8 ± 1.0% | 1157.7 ± 1.7% | 423.7 ± 1.3% | 454.7 ± 2.9% | 415.2 ± 0.8% | 0.821 | 1.121 | 3.062 | 2.853 | 3.125 |
| qlog records, JSON text sequence | 1467503 | 1077.8 ± 0.4% | 1314.3 ± 0.5% | 903.8 ± 0.2% | 424.2 ± 0.6% | 494.2 ± 0.4% | 329.2 ± 1.8% | 0.820 | 1.192 | 2.541 | 2.181 | 3.274 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.798 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.885 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.844 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.831 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.821 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.820 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1410.0 ± 0.7% | 0.432 | 0.900 | 0.963 | 0.939 | 0.356 | 0.969 | 0.942 | 0.334 | 0.733 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 1113.9 ± 4.4% | 0.723 | 0.960 | 0.933 | 0.933 | 0.353 | 0.957 | 0.948 | 0.327 | 0.807 | 0.112 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1763.1 ± 0.8% | 0.417 | 0.953 | 0.960 | 0.984 | 0.992 | 0.247 | 0.993 | 0.437 | 0.724 | 0.086 | 1.006 |
| qlog records, JSON text sequence | 1467503 | 1485.4 ± 0.3% | 0.683 | 0.943 | 0.992 | 0.993 | 0.987 | 0.250 | 0.988 | 0.423 | 0.728 | 0.113 | 1.009 |

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
| CLDR supplemental, 34 texts | 920675 | 1410.0 ± 0.7% | 1322.1 ± 0.9% | 1185.5 ± 1.2% | 354.8 ± 0.9% | 662.8 ± 0.4% | 319.7 ± 2.1% | 1.066 | 1.189 | 3.974 | 2.127 | 4.410 |
| qlog records, JSON text sequence | 1467503 | 1113.9 ± 4.4% | 1021.7 ± 0.7% | 1065.6 ± 0.7% | 301.0 ± 5.7% | 724.0 ± 2.0% | 311.5 ± 5.1% | 1.090 | 1.045 | 3.701 | 1.539 | 3.575 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1763.1 ± 0.8% | 1591.4 ± 1.4% | 1155.1 ± 8.7% | 423.2 ± 0.9% | 454.5 ± 4.1% | 415.5 ± 1.5% | 1.108 | 1.526 | 4.166 | 3.879 | 4.243 |
| qlog records, JSON text sequence | 1467503 | 1485.4 ± 0.3% | 1304.1 ± 0.5% | 904.0 ± 0.3% | 427.4 ± 0.3% | 497.1 ± 0.3% | 320.2 ± 6.4% | 1.139 | 1.643 | 3.476 | 2.988 | 4.639 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1773.2 ± 1.3% | 1591.4 ± 1.4% | 1155.1 ± 8.7% | 423.2 ± 0.9% | 454.5 ± 4.1% | 415.5 ± 1.5% | 1.114 | 1.535 | 4.190 | 3.901 | 4.268 |
| qlog records, JSON text sequence | 1467503 | 1498.6 ± 0.4% | 1304.1 ± 0.5% | 904.0 ± 0.3% | 427.4 ± 0.3% | 497.1 ± 0.3% | 320.2 ± 6.4% | 1.149 | 1.658 | 3.506 | 3.015 | 4.680 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1033.4 ± 1.9% | 1322.1 ± 0.9% | 1185.5 ± 1.2% | 354.8 ± 0.9% | 662.8 ± 0.4% | 319.7 ± 2.1% | 0.782 | 0.872 | 2.913 | 1.559 | 3.232 |
| qlog records, JSON text sequence | 1467503 | 898.8 ± 1.3% | 1021.7 ± 0.7% | 1065.6 ± 0.7% | 301.0 ± 5.7% | 724.0 ± 2.0% | 311.5 ± 5.1% | 0.880 | 0.843 | 2.986 | 1.241 | 2.885 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1276.9 ± 1.2% | 1591.4 ± 1.4% | 1155.1 ± 8.7% | 423.2 ± 0.9% | 454.5 ± 4.1% | 415.5 ± 1.5% | 0.802 | 1.105 | 3.017 | 2.809 | 3.073 |
| qlog records, JSON text sequence | 1467503 | 1080.7 ± 0.7% | 1304.1 ± 0.5% | 904.0 ± 0.3% | 427.4 ± 0.3% | 497.1 ± 0.3% | 320.2 ± 6.4% | 0.829 | 1.195 | 2.529 | 2.174 | 3.375 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.782 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.872 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.880 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.843 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.802 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.829 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1419.4 ± 1.0% | 0.431 | 0.902 | 0.934 | 0.938 | 0.355 | 0.959 | 0.933 | 0.332 | 0.726 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1105.3 ± 2.9% | 0.718 | 0.968 | 0.937 | 0.941 | 0.357 | 0.968 | 0.941 | 0.333 | 0.821 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1754.4 ± 1.4% | 0.421 | 0.953 | 0.964 | 0.990 | 0.993 | 0.248 | 0.995 | 0.440 | 0.739 | 0.087 | 1.013 |
| qlog records, JSON text sequence | 1467503 | 1487.6 ± 0.6% | 0.682 | 0.947 | 0.986 | 0.994 | 0.982 | 0.249 | 0.978 | 0.421 | 0.727 | 0.113 | 1.007 |

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
| CLDR supplemental, 34 texts | 920675 | 1419.4 ± 1.0% | 1328.4 ± 0.4% | 1212.6 ± 0.8% | 352.6 ± 0.4% | 663.6 ± 1.2% | 317.2 ± 2.4% | 1.069 | 1.171 | 4.026 | 2.139 | 4.475 |
| qlog records, JSON text sequence | 1467503 | 1105.3 ± 2.9% | 1051.2 ± 0.4% | 1076.6 ± 0.9% | 287.7 ± 2.0% | 728.9 ± 0.3% | 319.5 ± 1.5% | 1.051 | 1.027 | 3.841 | 1.517 | 3.459 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1754.4 ± 1.4% | 1587.0 ± 1.2% | 1145.5 ± 2.7% | 422.2 ± 1.1% | 448.4 ± 2.0% | 415.0 ± 0.3% | 1.106 | 1.532 | 4.156 | 3.912 | 4.227 |
| qlog records, JSON text sequence | 1467503 | 1487.6 ± 0.6% | 1316.7 ± 0.3% | 899.0 ± 0.2% | 426.5 ± 0.9% | 494.8 ± 0.3% | 327.8 ± 1.0% | 1.130 | 1.655 | 3.488 | 3.006 | 4.538 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1776.9 ± 0.6% | 1587.0 ± 1.2% | 1145.5 ± 2.7% | 422.2 ± 1.1% | 448.4 ± 2.0% | 415.0 ± 0.3% | 1.120 | 1.551 | 4.209 | 3.962 | 4.281 |
| qlog records, JSON text sequence | 1467503 | 1497.9 ± 0.3% | 1316.7 ± 0.3% | 899.0 ± 0.2% | 426.5 ± 0.9% | 494.8 ± 0.3% | 327.8 ± 1.0% | 1.138 | 1.666 | 3.512 | 3.027 | 4.570 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1029.9 ± 0.9% | 1328.4 ± 0.4% | 1212.6 ± 0.8% | 352.6 ± 0.4% | 663.6 ± 1.2% | 317.2 ± 2.4% | 0.775 | 0.849 | 2.921 | 1.552 | 3.246 |
| qlog records, JSON text sequence | 1467503 | 907.7 ± 1.1% | 1051.2 ± 0.4% | 1076.6 ± 0.9% | 287.7 ± 2.0% | 728.9 ± 0.3% | 319.5 ± 1.5% | 0.863 | 0.843 | 3.154 | 1.245 | 2.841 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1295.8 ± 0.5% | 1587.0 ± 1.2% | 1145.5 ± 2.7% | 422.2 ± 1.1% | 448.4 ± 2.0% | 415.0 ± 0.3% | 0.817 | 1.131 | 3.069 | 2.890 | 3.122 |
| qlog records, JSON text sequence | 1467503 | 1081.1 ± 0.6% | 1316.7 ± 0.3% | 899.0 ± 0.2% | 426.5 ± 0.9% | 494.8 ± 0.3% | 327.8 ± 1.0% | 0.821 | 1.203 | 2.535 | 2.185 | 3.298 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.775 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.849 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.863 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.843 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.817 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.821 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1414.3 ± 1.5% | 0.435 | 0.934 | 0.939 | 0.936 | 0.356 | 0.961 | 0.939 | 0.333 | 0.748 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1094.5 ± 1.9% | 0.729 | 0.976 | 0.946 | 0.948 | 0.361 | 0.976 | 0.949 | 0.330 | 0.838 | 0.113 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1763.2 ± 1.6% | 0.418 | 0.950 | 0.959 | 0.989 | 0.999 | 0.247 | 0.995 | 0.436 | 0.735 | 0.087 | 1.008 |
| qlog records, JSON text sequence | 1467503 | 1489.1 ± 0.8% | 0.683 | 0.941 | 0.990 | 0.996 | 0.989 | 0.252 | 0.991 | 0.420 | 0.728 | 0.113 | 1.006 |

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
| CLDR supplemental, 34 texts | 920675 | 1414.3 ± 1.5% | 1331.7 ± 0.6% | 1210.3 ± 0.6% | 353.8 ± 1.1% | 662.6 ± 0.9% | 318.5 ± 3.0% | 1.062 | 1.169 | 3.998 | 2.134 | 4.441 |
| qlog records, JSON text sequence | 1467503 | 1094.5 ± 1.9% | 1043.7 ± 2.3% | 1081.1 ± 27.4% | 298.3 ± 3.1% | 727.7 ± 0.5% | 315.2 ± 2.5% | 1.049 | 1.012 | 3.669 | 1.504 | 3.473 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1763.2 ± 1.6% | 1577.1 ± 13.4% | 1159.2 ± 19.4% | 423.1 ± 0.5% | 455.2 ± 1.8% | 416.1 ± 0.9% | 1.118 | 1.521 | 4.167 | 3.874 | 4.237 |
| qlog records, JSON text sequence | 1467503 | 1489.1 ± 0.8% | 1315.4 ± 0.6% | 905.0 ± 7.1% | 416.4 ± 0.6% | 484.0 ± 4.3% | 330.4 ± 0.4% | 1.132 | 1.645 | 3.576 | 3.077 | 4.506 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1777.3 ± 1.8% | 1577.1 ± 13.4% | 1159.2 ± 19.4% | 423.1 ± 0.5% | 455.2 ± 1.8% | 416.1 ± 0.9% | 1.127 | 1.533 | 4.201 | 3.905 | 4.271 |
| qlog records, JSON text sequence | 1467503 | 1498.4 ± 0.4% | 1315.4 ± 0.6% | 905.0 ± 7.1% | 416.4 ± 0.6% | 484.0 ± 4.3% | 330.4 ± 0.4% | 1.139 | 1.656 | 3.598 | 3.096 | 4.535 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1057.5 ± 5.5% | 1331.7 ± 0.6% | 1210.3 ± 0.6% | 353.8 ± 1.1% | 662.6 ± 0.9% | 318.5 ± 3.0% | 0.794 | 0.874 | 2.989 | 1.596 | 3.320 |
| qlog records, JSON text sequence | 1467503 | 917.4 ± 0.8% | 1043.7 ± 2.3% | 1081.1 ± 27.4% | 298.3 ± 3.1% | 727.7 ± 0.5% | 315.2 ± 2.5% | 0.879 | 0.849 | 3.076 | 1.261 | 2.911 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1296.2 ± 4.1% | 1577.1 ± 13.4% | 1159.2 ± 19.4% | 423.1 ± 0.5% | 455.2 ± 1.8% | 416.1 ± 0.9% | 0.822 | 1.118 | 3.063 | 2.848 | 3.115 |
| qlog records, JSON text sequence | 1467503 | 1083.5 ± 0.1% | 1315.4 ± 0.6% | 905.0 ± 7.1% | 416.4 ± 0.6% | 484.0 ± 4.3% | 330.4 ± 0.4% | 0.824 | 1.197 | 2.602 | 2.239 | 3.279 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.794 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.874 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.879 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.822 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.824 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1340.9 ± 4.3% | 0.482 | 1.000 | 0.990 | 0.997 | 0.372 | 0.989 | 0.997 | 0.349 | 0.779 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1063.3 ± 2.2% | 0.797 | 1.027 | 1.042 | 1.049 | 0.376 | 1.028 | 1.047 | 0.345 | 0.697 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1742.9 ± 1.3% | 0.424 | 0.965 | 0.969 | 1.006 | 1.006 | 0.251 | 0.999 | 0.439 | 0.738 | 0.088 | 1.014 |
| qlog records, JSON text sequence | 1467503 | 1482.2 ± 0.5% | 0.682 | 0.955 | 0.990 | 0.993 | 0.994 | 0.250 | 0.992 | 0.422 | 0.730 | 0.114 | 1.016 |

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
| CLDR supplemental, 34 texts | 920675 | 1340.9 ± 4.3% | 1304.1 ± 0.6% | 1210.0 ± 0.7% | 356.2 ± 1.0% | 663.4 ± 1.4% | 318.0 ± 2.3% | 1.028 | 1.108 | 3.765 | 2.021 | 4.217 |
| qlog records, JSON text sequence | 1467503 | 1063.3 ± 2.2% | 1051.8 ± 0.5% | 1080.4 ± 3.7% | 295.9 ± 2.2% | 729.0 ± 0.6% | 319.3 ± 1.8% | 1.011 | 0.984 | 3.594 | 1.459 | 3.330 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1742.9 ± 1.3% | 1599.3 ± 1.7% | 1155.4 ± 1.1% | 425.3 ± 0.8% | 457.8 ± 1.0% | 413.2 ± 2.3% | 1.090 | 1.508 | 4.098 | 3.807 | 4.218 |
| qlog records, JSON text sequence | 1467503 | 1482.2 ± 0.5% | 1318.7 ± 0.2% | 902.5 ± 0.3% | 421.8 ± 1.1% | 482.2 ± 0.3% | 322.3 ± 1.0% | 1.124 | 1.642 | 3.514 | 3.074 | 4.599 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1767.2 ± 6.7% | 1599.3 ± 1.7% | 1155.4 ± 1.1% | 425.3 ± 0.8% | 457.8 ± 1.0% | 413.2 ± 2.3% | 1.105 | 1.530 | 4.155 | 3.860 | 4.277 |
| qlog records, JSON text sequence | 1467503 | 1505.5 ± 0.2% | 1318.7 ± 0.2% | 902.5 ± 0.3% | 421.8 ± 1.1% | 482.2 ± 0.3% | 322.3 ± 1.0% | 1.142 | 1.668 | 3.569 | 3.122 | 4.671 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1043.9 ± 0.6% | 1304.1 ± 0.6% | 1210.0 ± 0.7% | 356.2 ± 1.0% | 663.4 ± 1.4% | 318.0 ± 2.3% | 0.800 | 0.863 | 2.931 | 1.574 | 3.283 |
| qlog records, JSON text sequence | 1467503 | 741.4 ± 1.8% | 1051.8 ± 0.5% | 1080.4 ± 3.7% | 295.9 ± 2.2% | 729.0 ± 0.6% | 319.3 ± 1.8% | 0.705 | 0.686 | 2.506 | 1.017 | 2.322 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1285.6 ± 0.8% | 1599.3 ± 1.7% | 1155.4 ± 1.1% | 425.3 ± 0.8% | 457.8 ± 1.0% | 413.2 ± 2.3% | 0.804 | 1.113 | 3.023 | 2.808 | 3.111 |
| qlog records, JSON text sequence | 1467503 | 1081.8 ± 0.6% | 1318.7 ± 0.2% | 902.5 ± 0.3% | 421.8 ± 1.1% | 482.2 ± 0.3% | 322.3 ± 1.0% | 0.820 | 1.199 | 2.565 | 2.243 | 3.357 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.800 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.863 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.705 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.686 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.804 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.820 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1399.1 ± 23.3% | 0.438 | 0.928 | 0.944 | 0.950 | 0.360 | 0.971 | 0.948 | 0.336 | 0.776 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 1092.2 ± 3.1% | 0.738 | 0.982 | 0.964 | 0.950 | 0.362 | 0.978 | 0.949 | 0.336 | 0.810 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1759.0 ± 1.2% | 0.417 | 0.953 | 0.966 | 0.992 | 0.994 | 0.247 | 0.993 | 0.437 | 0.736 | 0.087 | 1.010 |
| qlog records, JSON text sequence | 1467503 | 1483.0 ± 0.7% | 0.682 | 0.948 | 0.995 | 0.998 | 0.990 | 0.251 | 0.992 | 0.424 | 0.733 | 0.114 | 1.013 |

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
| CLDR supplemental, 34 texts | 920675 | 1399.1 ± 23.3% | 1355.1 ± 3.1% | 1203.1 ± 1.0% | 356.0 ± 1.7% | 670.4 ± 3.0% | 319.5 ± 2.5% | 1.032 | 1.163 | 3.931 | 2.087 | 4.379 |
| qlog records, JSON text sequence | 1467503 | 1092.2 ± 3.1% | 1028.9 ± 2.5% | 1047.7 ± 0.5% | 302.9 ± 2.9% | 727.8 ± 6.1% | 308.4 ± 4.5% | 1.061 | 1.042 | 3.606 | 1.501 | 3.541 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1759.0 ± 1.2% | 1577.6 ± 0.8% | 1158.5 ± 1.8% | 423.7 ± 0.5% | 448.0 ± 6.5% | 414.7 ± 5.9% | 1.115 | 1.518 | 4.152 | 3.926 | 4.241 |
| qlog records, JSON text sequence | 1467503 | 1483.0 ± 0.7% | 1313.6 ± 0.2% | 876.2 ± 0.5% | 421.0 ± 0.3% | 494.5 ± 0.2% | 329.6 ± 0.4% | 1.129 | 1.693 | 3.523 | 2.999 | 4.499 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1776.9 ± 4.3% | 1577.6 ± 0.8% | 1158.5 ± 1.8% | 423.7 ± 0.5% | 448.0 ± 6.5% | 414.7 ± 5.9% | 1.126 | 1.534 | 4.194 | 3.966 | 4.284 |
| qlog records, JSON text sequence | 1467503 | 1502.1 ± 0.8% | 1313.6 ± 0.2% | 876.2 ± 0.5% | 421.0 ± 0.3% | 494.5 ± 0.2% | 329.6 ± 0.4% | 1.144 | 1.714 | 3.568 | 3.037 | 4.557 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1086.0 ± 2.1% | 1355.1 ± 3.1% | 1203.1 ± 1.0% | 356.0 ± 1.7% | 670.4 ± 3.0% | 319.5 ± 2.5% | 0.801 | 0.903 | 3.051 | 1.620 | 3.399 |
| qlog records, JSON text sequence | 1467503 | 885.0 ± 0.7% | 1028.9 ± 2.5% | 1047.7 ± 0.5% | 302.9 ± 2.9% | 727.8 ± 6.1% | 308.4 ± 4.5% | 0.860 | 0.845 | 2.922 | 1.216 | 2.869 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1295.0 ± 0.9% | 1577.6 ± 0.8% | 1158.5 ± 1.8% | 423.7 ± 0.5% | 448.0 ± 6.5% | 414.7 ± 5.9% | 0.821 | 1.118 | 3.056 | 2.890 | 3.122 |
| qlog records, JSON text sequence | 1467503 | 1086.8 ± 0.4% | 1313.6 ± 0.2% | 876.2 ± 0.5% | 421.0 ± 0.3% | 494.5 ± 0.2% | 329.6 ± 0.4% | 0.827 | 1.240 | 2.582 | 2.198 | 3.297 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.801 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.903 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.860 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.845 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.821 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.827 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1399.9 ± 3.9% | 0.433 | 0.907 | 0.975 | 0.947 | 0.358 | 0.970 | 0.950 | 0.336 | 0.737 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 1102.6 ± 1.8% | 0.728 | 0.970 | 0.937 | 0.941 | 0.359 | 0.968 | 0.940 | 0.334 | 0.815 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1751.9 ± 1.1% | 0.420 | 0.955 | 0.963 | 0.986 | 0.999 | 0.249 | 0.997 | 0.439 | 0.741 | 0.087 | 1.011 |
| qlog records, JSON text sequence | 1467503 | 1486.1 ± 0.4% | 0.682 | 0.945 | 0.991 | 0.996 | 0.988 | 0.249 | 0.990 | 0.420 | 0.727 | 0.113 | 1.009 |

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
| CLDR supplemental, 34 texts | 920675 | 1399.9 ± 3.9% | 1346.8 ± 1.1% | 1208.5 ± 0.6% | 355.6 ± 2.0% | 669.4 ± 2.0% | 320.1 ± 2.5% | 1.039 | 1.158 | 3.937 | 2.091 | 4.374 |
| qlog records, JSON text sequence | 1467503 | 1102.6 ± 1.8% | 1034.5 ± 2.2% | 1085.0 ± 0.9% | 299.1 ± 6.8% | 731.0 ± 3.4% | 315.2 ± 6.4% | 1.066 | 1.016 | 3.687 | 1.508 | 3.499 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1751.9 ± 1.1% | 1576.2 ± 1.0% | 1148.8 ± 1.1% | 421.0 ± 1.2% | 448.5 ± 2.0% | 413.9 ± 6.1% | 1.111 | 1.525 | 4.161 | 3.906 | 4.233 |
| qlog records, JSON text sequence | 1467503 | 1486.1 ± 0.4% | 1316.0 ± 0.2% | 902.3 ± 0.5% | 426.8 ± 0.8% | 496.2 ± 0.4% | 327.2 ± 1.1% | 1.129 | 1.647 | 3.482 | 2.995 | 4.542 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1770.9 ± 1.3% | 1576.2 ± 1.0% | 1148.8 ± 1.1% | 421.0 ± 1.2% | 448.5 ± 2.0% | 413.9 ± 6.1% | 1.123 | 1.542 | 4.206 | 3.948 | 4.279 |
| qlog records, JSON text sequence | 1467503 | 1499.7 ± 1.2% | 1316.0 ± 0.2% | 902.3 ± 0.5% | 426.8 ± 0.8% | 496.2 ± 0.4% | 327.2 ± 1.1% | 1.140 | 1.662 | 3.514 | 3.022 | 4.583 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1031.8 ± 4.8% | 1346.8 ± 1.1% | 1208.5 ± 0.6% | 355.6 ± 2.0% | 669.4 ± 2.0% | 320.1 ± 2.5% | 0.766 | 0.854 | 2.901 | 1.541 | 3.224 |
| qlog records, JSON text sequence | 1467503 | 899.1 ± 5.2% | 1034.5 ± 2.2% | 1085.0 ± 0.9% | 299.1 ± 6.8% | 731.0 ± 3.4% | 315.2 ± 6.4% | 0.869 | 0.829 | 3.006 | 1.230 | 2.853 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1297.9 ± 1.0% | 1576.2 ± 1.0% | 1148.8 ± 1.1% | 421.0 ± 1.2% | 448.5 ± 2.0% | 413.9 ± 6.1% | 0.823 | 1.130 | 3.083 | 2.894 | 3.136 |
| qlog records, JSON text sequence | 1467503 | 1080.0 ± 2.3% | 1316.0 ± 0.2% | 902.3 ± 0.5% | 426.8 ± 0.8% | 496.2 ± 0.4% | 327.2 ± 1.1% | 0.821 | 1.197 | 2.530 | 2.176 | 3.300 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.766 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.854 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.869 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.829 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.823 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.821 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1398.0 ± 4.8% | 0.436 | 0.934 | 0.951 | 0.946 | 0.360 | 0.976 | 0.950 | 0.336 | 0.736 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 1104.9 ± 2.5% | 0.717 | 0.968 | 0.939 | 0.940 | 0.356 | 0.963 | 0.933 | 0.314 | 0.778 | 0.114 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1771.4 ± 0.6% | 0.417 | 0.945 | 0.955 | 0.985 | 0.988 | 0.246 | 0.977 | 0.438 | 0.734 | 0.086 | 1.006 |
| qlog records, JSON text sequence | 1467503 | 1488.3 ± 6.3% | 0.681 | 0.945 | 0.984 | 0.990 | 0.982 | 0.249 | 0.982 | 0.422 | 0.728 | 0.113 | 1.006 |

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
| CLDR supplemental, 34 texts | 920675 | 1398.0 ± 4.8% | 1284.5 ± 0.7% | 1184.5 ± 0.7% | 355.8 ± 0.3% | 672.4 ± 1.4% | 317.7 ± 2.7% | 1.088 | 1.180 | 3.929 | 2.079 | 4.400 |
| qlog records, JSON text sequence | 1467503 | 1104.9 ± 2.5% | 1025.9 ± 0.2% | 1058.1 ± 0.9% | 287.1 ± 3.3% | 728.2 ± 2.3% | 313.8 ± 3.7% | 1.077 | 1.044 | 3.848 | 1.517 | 3.521 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1771.4 ± 0.6% | 1585.7 ± 7.2% | 1167.9 ± 7.1% | 423.1 ± 5.3% | 446.6 ± 3.3% | 414.8 ± 26.5% | 1.117 | 1.517 | 4.186 | 3.966 | 4.270 |
| qlog records, JSON text sequence | 1467503 | 1488.3 ± 6.3% | 1316.8 ± 1.3% | 904.4 ± 2.3% | 423.8 ± 1.2% | 482.5 ± 53.9% | 327.9 ± 7.0% | 1.130 | 1.646 | 3.511 | 3.085 | 4.539 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1782.3 ± 1.1% | 1585.7 ± 7.2% | 1167.9 ± 7.1% | 423.1 ± 5.3% | 446.6 ± 3.3% | 414.8 ± 26.5% | 1.124 | 1.526 | 4.212 | 3.991 | 4.297 |
| qlog records, JSON text sequence | 1467503 | 1497.3 ± 0.7% | 1316.8 ± 1.3% | 904.4 ± 2.3% | 423.8 ± 1.2% | 482.5 ± 53.9% | 327.9 ± 7.0% | 1.137 | 1.656 | 3.533 | 3.104 | 4.566 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1028.6 ± 4.8% | 1284.5 ± 0.7% | 1184.5 ± 0.7% | 355.8 ± 0.3% | 672.4 ± 1.4% | 317.7 ± 2.7% | 0.801 | 0.868 | 2.891 | 1.530 | 3.237 |
| qlog records, JSON text sequence | 1467503 | 859.5 ± 9.4% | 1025.9 ± 0.2% | 1058.1 ± 0.9% | 287.1 ± 3.3% | 728.2 ± 2.3% | 313.8 ± 3.7% | 0.838 | 0.812 | 2.994 | 1.180 | 2.739 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1299.7 ± 1.2% | 1585.7 ± 7.2% | 1167.9 ± 7.1% | 423.1 ± 5.3% | 446.6 ± 3.3% | 414.8 ± 26.5% | 0.820 | 1.113 | 3.072 | 2.910 | 3.133 |
| qlog records, JSON text sequence | 1467503 | 1083.2 ± 2.1% | 1316.8 ± 1.3% | 904.4 ± 2.3% | 423.8 ± 1.2% | 482.5 ± 53.9% | 327.9 ± 7.0% | 0.823 | 1.198 | 2.556 | 2.245 | 3.303 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.801 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.868 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.838 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.812 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.820 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.823 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1415.4 ± 5.4% | 0.434 | 0.930 | 0.935 | 0.940 | 0.357 | 0.960 | 0.938 | 0.333 | 0.751 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1093.8 ± 2.2% | 0.723 | 0.979 | 0.948 | 0.950 | 0.362 | 0.976 | 0.948 | 0.337 | 0.841 | 0.118 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1740.1 ± 5.2% | 0.424 | 0.962 | 0.978 | 1.007 | 1.009 | 0.250 | 0.999 | 0.442 | 0.741 | 0.088 | 1.021 |
| qlog records, JSON text sequence | 1467503 | 1488.0 ± 6.6% | 0.682 | 0.946 | 0.988 | 0.995 | 0.988 | 0.249 | 0.988 | 0.420 | 0.722 | 0.113 | 1.009 |

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
| CLDR supplemental, 34 texts | 920675 | 1415.4 ± 5.4% | 1348.8 ± 1.0% | 1202.9 ± 0.4% | 356.3 ± 0.7% | 664.3 ± 0.8% | 319.7 ± 1.8% | 1.049 | 1.177 | 3.972 | 2.131 | 4.427 |
| qlog records, JSON text sequence | 1467503 | 1093.8 ± 2.2% | 1055.0 ± 0.4% | 1074.6 ± 4.5% | 296.2 ± 3.2% | 723.0 ± 1.0% | 311.7 ± 7.0% | 1.037 | 1.018 | 3.692 | 1.513 | 3.509 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1740.1 ± 5.2% | 1580.4 ± 1.0% | 1155.4 ± 0.8% | 420.8 ± 2.0% | 445.5 ± 3.4% | 415.3 ± 5.5% | 1.101 | 1.506 | 4.135 | 3.906 | 4.190 |
| qlog records, JSON text sequence | 1467503 | 1488.0 ± 6.6% | 1228.6 ± 0.2% | 900.5 ± 1.2% | 416.6 ± 0.4% | 484.0 ± 1.3% | 329.6 ± 1.1% | 1.211 | 1.652 | 3.572 | 3.074 | 4.514 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1776.2 ± 31.9% | 1580.4 ± 1.0% | 1155.4 ± 0.8% | 420.8 ± 2.0% | 445.5 ± 3.4% | 415.3 ± 5.5% | 1.124 | 1.537 | 4.221 | 3.987 | 4.277 |
| qlog records, JSON text sequence | 1467503 | 1501.2 ± 0.5% | 1228.6 ± 0.2% | 900.5 ± 1.2% | 416.6 ± 0.4% | 484.0 ± 1.3% | 329.6 ± 1.1% | 1.222 | 1.667 | 3.603 | 3.102 | 4.554 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1062.7 ± 1.5% | 1348.8 ± 1.0% | 1202.9 ± 0.4% | 356.3 ± 0.7% | 664.3 ± 0.8% | 319.7 ± 1.8% | 0.788 | 0.883 | 2.982 | 1.600 | 3.324 |
| qlog records, JSON text sequence | 1467503 | 919.4 ± 0.3% | 1055.0 ± 0.4% | 1074.6 ± 4.5% | 296.2 ± 3.2% | 723.0 ± 1.0% | 311.7 ± 7.0% | 0.871 | 0.856 | 3.104 | 1.272 | 2.949 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1288.5 ± 0.7% | 1580.4 ± 1.0% | 1155.4 ± 0.8% | 420.8 ± 2.0% | 445.5 ± 3.4% | 415.3 ± 5.5% | 0.815 | 1.115 | 3.062 | 2.893 | 3.103 |
| qlog records, JSON text sequence | 1467503 | 1073.7 ± 4.7% | 1228.6 ± 0.2% | 900.5 ± 1.2% | 416.6 ± 0.4% | 484.0 ± 1.3% | 329.6 ± 1.1% | 0.874 | 1.192 | 2.577 | 2.218 | 3.257 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.788 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.883 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.871 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.856 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.815 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.874 of simdjson.
