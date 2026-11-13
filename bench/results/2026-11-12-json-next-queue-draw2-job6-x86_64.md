# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1311.8 ± 3.3% | 0.489 | 1.030 | 1.016 | 1.014 | 0.382 | 1.015 | 1.001 | 0.356 | 0.797 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 1052.2 ± 2.2% | 0.803 | 1.032 | 1.048 | 1.036 | 0.377 | 1.035 | 1.050 | 0.343 | 0.698 | 0.122 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1744.7 ± 1.0% | 0.424 | 0.984 | 0.967 | 1.004 | 1.004 | 0.252 | 0.999 | 0.442 | 0.743 | 0.088 | 1.020 |
| qlog records, JSON text sequence | 1467503 | 1485.0 ± 0.2% | 0.684 | 0.956 | 0.987 | 0.994 | 0.993 | 0.253 | 0.993 | 0.422 | 0.729 | 0.114 | 1.014 |

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
| CLDR supplemental, 34 texts | 920675 | 1311.8 ± 3.3% | 1328.9 ± 5.1% | 1216.4 ± 1.5% | 355.8 ± 2.2% | 661.2 ± 1.1% | 314.9 ± 3.5% | 0.987 | 1.078 | 3.686 | 1.984 | 4.166 |
| qlog records, JSON text sequence | 1467503 | 1052.2 ± 2.2% | 1057.7 ± 0.6% | 1047.6 ± 2.2% | 298.3 ± 3.7% | 722.4 ± 2.6% | 310.9 ± 3.3% | 0.995 | 1.004 | 3.527 | 1.456 | 3.384 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1744.7 ± 1.0% | 1577.3 ± 1.8% | 1153.1 ± 3.1% | 423.8 ± 0.8% | 456.9 ± 0.8% | 413.1 ± 3.3% | 1.106 | 1.513 | 4.117 | 3.819 | 4.224 |
| qlog records, JSON text sequence | 1467503 | 1485.0 ± 0.2% | 1318.0 ± 0.6% | 902.0 ± 0.4% | 424.1 ± 0.8% | 497.1 ± 0.2% | 322.2 ± 1.9% | 1.127 | 1.646 | 3.501 | 2.987 | 4.609 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1780.1 ± 0.9% | 1577.3 ± 1.8% | 1153.1 ± 3.1% | 423.8 ± 0.8% | 456.9 ± 0.8% | 413.1 ± 3.3% | 1.129 | 1.544 | 4.200 | 3.896 | 4.309 |
| qlog records, JSON text sequence | 1467503 | 1505.2 ± 0.8% | 1318.0 ± 0.6% | 902.0 ± 0.4% | 424.1 ± 0.8% | 497.1 ± 0.2% | 322.2 ± 1.9% | 1.142 | 1.669 | 3.549 | 3.028 | 4.671 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1045.5 ± 0.5% | 1328.9 ± 5.1% | 1216.4 ± 1.5% | 355.8 ± 2.2% | 661.2 ± 1.1% | 314.9 ± 3.5% | 0.787 | 0.859 | 2.938 | 1.581 | 3.321 |
| qlog records, JSON text sequence | 1467503 | 734.7 ± 1.6% | 1057.7 ± 0.6% | 1047.6 ± 2.2% | 298.3 ± 3.7% | 722.4 ± 2.6% | 310.9 ± 3.3% | 0.695 | 0.701 | 2.463 | 1.017 | 2.363 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1296.3 ± 1.0% | 1577.3 ± 1.8% | 1153.1 ± 3.1% | 423.8 ± 0.8% | 456.9 ± 0.8% | 413.1 ± 3.3% | 0.822 | 1.124 | 3.059 | 2.837 | 3.138 |
| qlog records, JSON text sequence | 1467503 | 1082.6 ± 0.5% | 1318.0 ± 0.6% | 902.0 ± 0.4% | 424.1 ± 0.8% | 497.1 ± 0.2% | 322.2 ± 1.9% | 0.821 | 1.200 | 2.553 | 2.178 | 3.360 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.787 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.859 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.695 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.701 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.822 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.821 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1414.1 ± 7.5% | 0.431 | 0.893 | 0.933 | 0.935 | 0.355 | 0.966 | 0.937 | 0.333 | 0.766 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1104.9 ± 1.8% | 0.728 | 0.971 | 0.955 | 0.940 | 0.359 | 0.967 | 0.941 | 0.334 | 0.800 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1759.8 ± 1.2% | 0.420 | 0.952 | 0.967 | 0.974 | 0.996 | 0.248 | 0.994 | 0.439 | 0.736 | 0.087 | 1.013 |
| qlog records, JSON text sequence | 1467503 | 1480.9 ± 0.9% | 0.683 | 0.944 | 0.988 | 0.994 | 0.996 | 0.251 | 0.996 | 0.424 | 0.732 | 0.114 | 1.016 |

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
| CLDR supplemental, 34 texts | 920675 | 1414.1 ± 7.5% | 1351.2 ± 0.4% | 1216.6 ± 0.9% | 356.9 ± 0.9% | 663.6 ± 1.8% | 320.9 ± 1.7% | 1.047 | 1.162 | 3.962 | 2.131 | 4.406 |
| qlog records, JSON text sequence | 1467503 | 1104.9 ± 1.8% | 946.2 ± 0.5% | 1074.2 ± 0.2% | 302.5 ± 1.3% | 727.8 ± 0.6% | 316.8 ± 1.2% | 1.168 | 1.029 | 3.652 | 1.518 | 3.488 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1759.8 ± 1.2% | 1574.8 ± 1.8% | 1166.5 ± 1.2% | 422.9 ± 2.2% | 455.8 ± 7.8% | 416.0 ± 0.9% | 1.117 | 1.509 | 4.161 | 3.861 | 4.231 |
| qlog records, JSON text sequence | 1467503 | 1480.9 ± 0.9% | 1315.4 ± 6.0% | 903.8 ± 0.4% | 426.8 ± 0.8% | 495.3 ± 0.2% | 329.2 ± 1.0% | 1.126 | 1.639 | 3.470 | 2.990 | 4.499 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1781.9 ± 0.6% | 1574.8 ± 1.8% | 1166.5 ± 1.2% | 422.9 ± 2.2% | 455.8 ± 7.8% | 416.0 ± 0.9% | 1.131 | 1.528 | 4.213 | 3.909 | 4.284 |
| qlog records, JSON text sequence | 1467503 | 1504.1 ± 0.3% | 1315.4 ± 6.0% | 903.8 ± 0.4% | 426.8 ± 0.8% | 495.3 ± 0.2% | 329.2 ± 1.0% | 1.143 | 1.664 | 3.524 | 3.037 | 4.569 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1082.8 ± 1.7% | 1351.2 ± 0.4% | 1216.6 ± 0.9% | 356.9 ± 0.9% | 663.6 ± 1.8% | 320.9 ± 1.7% | 0.801 | 0.890 | 3.034 | 1.632 | 3.374 |
| qlog records, JSON text sequence | 1467503 | 883.5 ± 0.2% | 946.2 ± 0.5% | 1074.2 ± 0.2% | 302.5 ± 1.3% | 727.8 ± 0.6% | 316.8 ± 1.2% | 0.934 | 0.822 | 2.920 | 1.214 | 2.789 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1295.6 ± 0.5% | 1574.8 ± 1.8% | 1166.5 ± 1.2% | 422.9 ± 2.2% | 455.8 ± 7.8% | 416.0 ± 0.9% | 0.823 | 1.111 | 3.063 | 2.842 | 3.115 |
| qlog records, JSON text sequence | 1467503 | 1084.6 ± 0.2% | 1315.4 ± 6.0% | 903.8 ± 0.4% | 426.8 ± 0.8% | 495.3 ± 0.2% | 329.2 ± 1.0% | 0.825 | 1.200 | 2.541 | 2.190 | 3.295 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.801 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.890 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.934 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.822 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.823 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.825 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1353.4 ± 15.5% | 0.454 | 0.960 | 0.978 | 0.981 | 0.373 | 1.003 | 0.976 | 0.348 | 0.766 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1111.8 ± 2.2% | 0.690 | 0.965 | 0.934 | 0.930 | 0.356 | 0.962 | 0.912 | 0.332 | 0.808 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1746.0 ± 0.9% | 0.423 | 0.960 | 0.963 | 0.974 | 1.006 | 0.249 | 1.005 | 0.442 | 0.743 | 0.088 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1487.9 ± 0.4% | 0.683 | 0.944 | 0.993 | 0.990 | 0.982 | 0.250 | 0.983 | 0.421 | 0.722 | 0.114 | 1.002 |

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
| CLDR supplemental, 34 texts | 920675 | 1353.4 ± 15.5% | 1340.2 ± 0.8% | 1214.2 ± 1.4% | 358.1 ± 0.4% | 665.1 ± 0.8% | 321.1 ± 2.8% | 1.010 | 1.115 | 3.780 | 2.035 | 4.215 |
| qlog records, JSON text sequence | 1467503 | 1111.8 ± 2.2% | 1029.6 ± 0.7% | 1083.8 ± 0.8% | 292.2 ± 1.3% | 721.6 ± 1.3% | 314.4 ± 1.9% | 1.080 | 1.026 | 3.805 | 1.541 | 3.536 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1746.0 ± 0.9% | 1583.6 ± 1.6% | 1162.9 ± 2.1% | 424.0 ± 1.4% | 454.2 ± 1.8% | 416.3 ± 5.7% | 1.103 | 1.501 | 4.118 | 3.844 | 4.194 |
| qlog records, JSON text sequence | 1467503 | 1487.9 ± 0.4% | 1309.8 ± 0.2% | 904.4 ± 0.2% | 425.0 ± 0.7% | 499.6 ± 0.2% | 330.5 ± 0.9% | 1.136 | 1.645 | 3.501 | 2.978 | 4.502 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1775.9 ± 1.1% | 1583.6 ± 1.6% | 1162.9 ± 2.1% | 424.0 ± 1.4% | 454.2 ± 1.8% | 416.3 ± 5.7% | 1.121 | 1.527 | 4.188 | 3.910 | 4.266 |
| qlog records, JSON text sequence | 1467503 | 1490.8 ± 0.3% | 1309.8 ± 0.2% | 904.4 ± 0.2% | 425.0 ± 0.7% | 499.6 ± 0.2% | 330.5 ± 0.9% | 1.138 | 1.648 | 3.508 | 2.984 | 4.511 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1036.4 ± 0.7% | 1340.2 ± 0.8% | 1214.2 ± 1.4% | 358.1 ± 0.4% | 665.1 ± 0.8% | 321.1 ± 2.8% | 0.773 | 0.854 | 2.894 | 1.558 | 3.227 |
| qlog records, JSON text sequence | 1467503 | 898.7 ± 0.4% | 1029.6 ± 0.7% | 1083.8 ± 0.8% | 292.2 ± 1.3% | 721.6 ± 1.3% | 314.4 ± 1.9% | 0.873 | 0.829 | 3.076 | 1.245 | 2.858 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1296.5 ± 0.7% | 1583.6 ± 1.6% | 1162.9 ± 2.1% | 424.0 ± 1.4% | 454.2 ± 1.8% | 416.3 ± 5.7% | 0.819 | 1.115 | 3.058 | 2.855 | 3.114 |
| qlog records, JSON text sequence | 1467503 | 1074.4 ± 1.0% | 1309.8 ± 0.2% | 904.4 ± 0.2% | 425.0 ± 0.7% | 499.6 ± 0.2% | 330.5 ± 0.9% | 0.820 | 1.188 | 2.528 | 2.151 | 3.251 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.773 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.854 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.873 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.829 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.819 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.820 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1400.5 ± 4.5% | 0.435 | 0.925 | 0.952 | 0.950 | 0.359 | 0.972 | 0.948 | 0.333 | 0.738 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 1095.2 ± 3.1% | 0.734 | 0.974 | 0.945 | 0.946 | 0.361 | 0.974 | 0.947 | 0.334 | 0.830 | 0.117 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1745.4 ± 1.2% | 0.422 | 0.961 | 0.973 | 0.977 | 1.004 | 0.249 | 1.007 | 0.443 | 0.740 | 0.087 | 1.020 |
| qlog records, JSON text sequence | 1467503 | 1485.5 ± 6.7% | 0.684 | 0.940 | 0.988 | 0.993 | 0.985 | 0.249 | 0.983 | 0.423 | 0.732 | 0.114 | 1.011 |

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
| CLDR supplemental, 34 texts | 920675 | 1400.5 ± 4.5% | 1347.6 ± 0.5% | 1202.0 ± 0.9% | 356.5 ± 5.0% | 659.7 ± 22.1% | 320.4 ± 1.2% | 1.039 | 1.165 | 3.929 | 2.123 | 4.371 |
| qlog records, JSON text sequence | 1467503 | 1095.2 ± 3.1% | 1044.6 ± 1.1% | 1080.0 ± 15.6% | 302.8 ± 26.9% | 721.8 ± 24.9% | 316.9 ± 0.9% | 1.048 | 1.014 | 3.617 | 1.517 | 3.457 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1745.4 ± 1.2% | 1569.0 ± 7.4% | 1135.6 ± 1.2% | 424.1 ± 1.2% | 449.5 ± 19.4% | 414.2 ± 0.6% | 1.112 | 1.537 | 4.115 | 3.883 | 4.214 |
| qlog records, JSON text sequence | 1467503 | 1485.5 ± 6.7% | 1314.1 ± 1.1% | 904.6 ± 0.2% | 427.9 ± 0.2% | 482.1 ± 0.5% | 331.9 ± 1.1% | 1.130 | 1.642 | 3.472 | 3.081 | 4.476 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1781.2 ± 23.4% | 1569.0 ± 7.4% | 1135.6 ± 1.2% | 424.1 ± 1.2% | 449.5 ± 19.4% | 414.2 ± 0.6% | 1.135 | 1.568 | 4.200 | 3.963 | 4.300 |
| qlog records, JSON text sequence | 1467503 | 1502.3 ± 0.6% | 1314.1 ± 1.1% | 904.6 ± 0.2% | 427.9 ± 0.2% | 482.1 ± 0.5% | 331.9 ± 1.1% | 1.143 | 1.661 | 3.511 | 3.116 | 4.526 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1033.6 ± 1.8% | 1347.6 ± 0.5% | 1202.0 ± 0.9% | 356.5 ± 5.0% | 659.7 ± 22.1% | 320.4 ± 1.2% | 0.767 | 0.860 | 2.900 | 1.567 | 3.226 |
| qlog records, JSON text sequence | 1467503 | 909.1 ± 0.4% | 1044.6 ± 1.1% | 1080.0 ± 15.6% | 302.8 ± 26.9% | 721.8 ± 24.9% | 316.9 ± 0.9% | 0.870 | 0.842 | 3.003 | 1.260 | 2.869 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1292.5 ± 3.9% | 1569.0 ± 7.4% | 1135.6 ± 1.2% | 424.1 ± 1.2% | 449.5 ± 19.4% | 414.2 ± 0.6% | 0.824 | 1.138 | 3.047 | 2.875 | 3.120 |
| qlog records, JSON text sequence | 1467503 | 1086.8 ± 0.4% | 1314.1 ± 1.1% | 904.6 ± 0.2% | 427.9 ± 0.2% | 482.1 ± 0.5% | 331.9 ± 1.1% | 0.827 | 1.201 | 2.540 | 2.254 | 3.274 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.767 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.860 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.870 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.842 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.824 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.827 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1418.1 ± 1.4% | 0.430 | 0.920 | 0.931 | 0.935 | 0.356 | 0.964 | 0.934 | 0.332 | 0.748 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 1101.3 ± 5.7% | 0.713 | 0.972 | 0.959 | 0.942 | 0.360 | 0.970 | 0.942 | 0.335 | 0.839 | 0.117 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1741.9 ± 0.3% | 0.423 | 0.966 | 0.971 | 0.977 | 1.002 | 0.250 | 1.008 | 0.444 | 0.745 | 0.088 | 1.020 |
| qlog records, JSON text sequence | 1467503 | 1486.4 ± 0.3% | 0.683 | 0.946 | 0.992 | 0.993 | 0.986 | 0.249 | 0.987 | 0.421 | 0.725 | 0.114 | 1.008 |

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
| CLDR supplemental, 34 texts | 920675 | 1418.1 ± 1.4% | 1334.1 ± 0.8% | 1213.5 ± 0.5% | 354.7 ± 1.5% | 667.1 ± 1.9% | 322.6 ± 2.7% | 1.063 | 1.169 | 3.999 | 2.126 | 4.396 |
| qlog records, JSON text sequence | 1467503 | 1101.3 ± 5.7% | 1049.4 ± 0.5% | 1085.5 ± 6.2% | 290.4 ± 8.9% | 717.9 ± 23.1% | 318.1 ± 1.2% | 1.050 | 1.015 | 3.792 | 1.534 | 3.462 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1741.9 ± 0.3% | 1582.3 ± 0.6% | 1163.0 ± 1.3% | 424.3 ± 1.4% | 455.9 ± 2.6% | 415.1 ± 6.1% | 1.101 | 1.498 | 4.106 | 3.821 | 4.197 |
| qlog records, JSON text sequence | 1467503 | 1486.4 ± 0.3% | 1310.3 ± 1.1% | 904.5 ± 7.2% | 428.0 ± 0.7% | 502.6 ± 4.3% | 330.3 ± 0.9% | 1.134 | 1.643 | 3.473 | 2.957 | 4.500 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1777.6 ± 0.3% | 1582.3 ± 0.6% | 1163.0 ± 1.3% | 424.3 ± 1.4% | 455.9 ± 2.6% | 415.1 ± 6.1% | 1.123 | 1.528 | 4.190 | 3.899 | 4.283 |
| qlog records, JSON text sequence | 1467503 | 1497.7 ± 0.6% | 1310.3 ± 1.1% | 904.5 ± 7.2% | 428.0 ± 0.7% | 502.6 ± 4.3% | 330.3 ± 0.9% | 1.143 | 1.656 | 3.499 | 2.980 | 4.535 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1060.2 ± 1.1% | 1334.1 ± 0.8% | 1213.5 ± 0.5% | 354.7 ± 1.5% | 667.1 ± 1.9% | 322.6 ± 2.7% | 0.795 | 0.874 | 2.989 | 1.589 | 3.286 |
| qlog records, JSON text sequence | 1467503 | 924.1 ± 0.9% | 1049.4 ± 0.5% | 1085.5 ± 6.2% | 290.4 ± 8.9% | 717.9 ± 23.1% | 318.1 ± 1.2% | 0.881 | 0.851 | 3.182 | 1.287 | 2.905 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1297.9 ± 0.9% | 1582.3 ± 0.6% | 1163.0 ± 1.3% | 424.3 ± 1.4% | 455.9 ± 2.6% | 415.1 ± 6.1% | 0.820 | 1.116 | 3.059 | 2.847 | 3.127 |
| qlog records, JSON text sequence | 1467503 | 1077.4 ± 4.0% | 1310.3 ± 1.1% | 904.5 ± 7.2% | 428.0 ± 0.7% | 502.6 ± 4.3% | 330.3 ± 0.9% | 0.822 | 1.191 | 2.517 | 2.144 | 3.262 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.795 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.874 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.881 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.851 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.820 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.822 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1343.6 ± 3.6% | 0.478 | 1.014 | 0.987 | 0.995 | 0.373 | 0.999 | 0.996 | 0.348 | 0.777 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1068.6 ± 1.2% | 0.790 | 1.024 | 1.022 | 1.024 | 0.376 | 1.015 | 1.035 | 0.342 | 0.692 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1742.3 ± 1.6% | 0.425 | 0.981 | 0.962 | 1.000 | 0.997 | 0.252 | 0.996 | 0.442 | 0.738 | 0.088 | 1.021 |
| qlog records, JSON text sequence | 1467503 | 1480.6 ± 1.0% | 0.686 | 0.958 | 0.982 | 0.997 | 0.985 | 0.254 | 0.982 | 0.418 | 0.729 | 0.115 | 1.015 |

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
| CLDR supplemental, 34 texts | 920675 | 1343.6 ± 3.6% | 1352.2 ± 1.4% | 1211.7 ± 5.1% | 352.6 ± 2.6% | 662.0 ± 0.7% | 320.8 ± 2.5% | 0.994 | 1.109 | 3.810 | 2.030 | 4.188 |
| qlog records, JSON text sequence | 1467503 | 1068.6 ± 1.2% | 1058.0 ± 1.1% | 1083.5 ± 2.9% | 305.7 ± 25.0% | 726.8 ± 3.2% | 317.5 ± 2.0% | 1.010 | 0.986 | 3.496 | 1.470 | 3.365 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1742.3 ± 1.6% | 1591.5 ± 2.5% | 1161.6 ± 6.7% | 422.4 ± 2.1% | 458.3 ± 0.6% | 410.7 ± 0.6% | 1.095 | 1.500 | 4.125 | 3.802 | 4.242 |
| qlog records, JSON text sequence | 1467503 | 1480.6 ± 1.0% | 1307.0 ± 0.2% | 902.3 ± 3.0% | 423.4 ± 4.9% | 495.1 ± 0.4% | 323.1 ± 0.5% | 1.133 | 1.641 | 3.497 | 2.991 | 4.583 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1778.9 ± 0.7% | 1591.5 ± 2.5% | 1161.6 ± 6.7% | 422.4 ± 2.1% | 458.3 ± 0.6% | 410.7 ± 0.6% | 1.118 | 1.531 | 4.211 | 3.881 | 4.331 |
| qlog records, JSON text sequence | 1467503 | 1502.4 ± 0.3% | 1307.0 ± 0.2% | 902.3 ± 3.0% | 423.4 ± 4.9% | 495.1 ± 0.4% | 323.1 ± 0.5% | 1.150 | 1.665 | 3.548 | 3.035 | 4.650 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1043.7 ± 0.4% | 1352.2 ± 1.4% | 1211.7 ± 5.1% | 352.6 ± 2.6% | 662.0 ± 0.7% | 320.8 ± 2.5% | 0.772 | 0.861 | 2.960 | 1.577 | 3.253 |
| qlog records, JSON text sequence | 1467503 | 738.9 ± 1.5% | 1058.0 ± 1.1% | 1083.5 ± 2.9% | 305.7 ± 25.0% | 726.8 ± 3.2% | 317.5 ± 2.0% | 0.698 | 0.682 | 2.417 | 1.017 | 2.327 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1285.4 ± 0.4% | 1591.5 ± 2.5% | 1161.6 ± 6.7% | 422.4 ± 2.1% | 458.3 ± 0.6% | 410.7 ± 0.6% | 0.808 | 1.106 | 3.043 | 2.804 | 3.130 |
| qlog records, JSON text sequence | 1467503 | 1079.5 ± 0.2% | 1307.0 ± 0.2% | 902.3 ± 3.0% | 423.4 ± 4.9% | 495.1 ± 0.4% | 323.1 ± 0.5% | 0.826 | 1.196 | 2.549 | 2.180 | 3.341 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.772 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.861 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.698 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.682 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.808 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.826 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1418.9 ± 1.4% | 0.435 | 0.904 | 0.955 | 0.936 | 0.353 | 0.964 | 0.934 | 0.332 | 0.768 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1095.8 ± 3.1% | 0.736 | 0.976 | 0.963 | 0.948 | 0.361 | 0.975 | 0.945 | 0.337 | 0.807 | 0.118 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1752.9 ± 3.7% | 0.421 | 0.958 | 0.969 | 0.977 | 1.005 | 0.248 | 1.003 | 0.441 | 0.740 | 0.088 | 1.012 |
| qlog records, JSON text sequence | 1467503 | 1482.0 ± 0.6% | 0.683 | 0.944 | 0.988 | 1.000 | 0.993 | 0.249 | 0.993 | 0.425 | 0.733 | 0.114 | 1.014 |

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
| CLDR supplemental, 34 texts | 920675 | 1418.9 ± 1.4% | 1288.9 ± 0.3% | 1214.9 ± 1.1% | 357.4 ± 0.6% | 666.5 ± 3.8% | 321.8 ± 3.7% | 1.101 | 1.168 | 3.971 | 2.129 | 4.409 |
| qlog records, JSON text sequence | 1467503 | 1095.8 ± 3.1% | 1058.3 ± 2.6% | 1083.0 ± 0.6% | 290.8 ± 1.9% | 724.1 ± 7.0% | 318.5 ± 0.8% | 1.035 | 1.012 | 3.769 | 1.513 | 3.441 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1752.9 ± 3.7% | 1599.7 ± 1.0% | 1169.2 ± 6.7% | 424.4 ± 0.6% | 446.3 ± 8.5% | 413.9 ± 13.6% | 1.096 | 1.499 | 4.131 | 3.927 | 4.235 |
| qlog records, JSON text sequence | 1467503 | 1482.0 ± 0.6% | 1316.9 ± 6.2% | 903.6 ± 0.3% | 427.6 ± 0.2% | 498.4 ± 0.3% | 330.6 ± 0.4% | 1.125 | 1.640 | 3.466 | 2.974 | 4.482 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1774.0 ± 0.9% | 1599.7 ± 1.0% | 1169.2 ± 6.7% | 424.4 ± 0.6% | 446.3 ± 8.5% | 413.9 ± 13.6% | 1.109 | 1.517 | 4.180 | 3.975 | 4.286 |
| qlog records, JSON text sequence | 1467503 | 1503.1 ± 1.4% | 1316.9 ± 6.2% | 903.6 ± 0.3% | 427.6 ± 0.2% | 498.4 ± 0.3% | 330.6 ± 0.4% | 1.141 | 1.663 | 3.515 | 3.016 | 4.546 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1089.1 ± 1.9% | 1288.9 ± 0.3% | 1214.9 ± 1.1% | 357.4 ± 0.6% | 666.5 ± 3.8% | 321.8 ± 3.7% | 0.845 | 0.896 | 3.048 | 1.634 | 3.384 |
| qlog records, JSON text sequence | 1467503 | 884.2 ± 0.3% | 1058.3 ± 2.6% | 1083.0 ± 0.6% | 290.8 ± 1.9% | 724.1 ± 7.0% | 318.5 ± 0.8% | 0.836 | 0.816 | 3.041 | 1.221 | 2.776 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1296.7 ± 0.2% | 1599.7 ± 1.0% | 1169.2 ± 6.7% | 424.4 ± 0.6% | 446.3 ± 8.5% | 413.9 ± 13.6% | 0.811 | 1.109 | 3.056 | 2.905 | 3.133 |
| qlog records, JSON text sequence | 1467503 | 1085.9 ± 0.2% | 1316.9 ± 6.2% | 903.6 ± 0.3% | 427.6 ± 0.2% | 498.4 ± 0.3% | 330.6 ± 0.4% | 0.825 | 1.202 | 2.539 | 2.179 | 3.284 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.845 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.896 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.836 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.816 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.811 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.825 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1415.0 ± 6.0% | 0.427 | 0.935 | 0.941 | 0.939 | 0.355 | 0.964 | 0.938 | 0.333 | 0.738 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1104.0 ± 3.5% | 0.732 | 0.972 | 0.941 | 0.942 | 0.358 | 0.968 | 0.942 | 0.334 | 0.816 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1748.9 ± 5.6% | 0.424 | 0.962 | 0.970 | 0.973 | 1.005 | 0.249 | 1.006 | 0.442 | 0.743 | 0.088 | 1.019 |
| qlog records, JSON text sequence | 1467503 | 1490.1 ± 0.6% | 0.682 | 0.941 | 0.988 | 0.990 | 0.983 | 0.248 | 0.984 | 0.422 | 0.726 | 0.113 | 1.004 |

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
| CLDR supplemental, 34 texts | 920675 | 1415.0 ± 6.0% | 1339.3 ± 0.3% | 1212.5 ± 0.6% | 356.6 ± 1.1% | 666.5 ± 1.7% | 321.0 ± 2.3% | 1.056 | 1.167 | 3.968 | 2.123 | 4.407 |
| qlog records, JSON text sequence | 1467503 | 1104.0 ± 3.5% | 1054.3 ± 0.4% | 1087.2 ± 0.3% | 303.4 ± 1.0% | 731.4 ± 5.1% | 318.9 ± 1.6% | 1.047 | 1.015 | 3.638 | 1.509 | 3.461 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1748.9 ± 5.6% | 1585.8 ± 2.9% | 1165.9 ± 1.0% | 423.7 ± 0.3% | 454.8 ± 2.3% | 415.3 ± 0.5% | 1.103 | 1.500 | 4.128 | 3.845 | 4.211 |
| qlog records, JSON text sequence | 1467503 | 1490.1 ± 0.6% | 1298.7 ± 0.3% | 902.1 ± 0.3% | 427.7 ± 1.0% | 499.6 ± 4.3% | 330.7 ± 1.2% | 1.147 | 1.652 | 3.484 | 2.983 | 4.506 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1782.4 ± 0.9% | 1585.8 ± 2.9% | 1165.9 ± 1.0% | 423.7 ± 0.3% | 454.8 ± 2.3% | 415.3 ± 0.5% | 1.124 | 1.529 | 4.207 | 3.919 | 4.292 |
| qlog records, JSON text sequence | 1467503 | 1496.8 ± 0.3% | 1298.7 ± 0.3% | 902.1 ± 0.3% | 427.7 ± 1.0% | 499.6 ± 4.3% | 330.7 ± 1.2% | 1.153 | 1.659 | 3.500 | 2.996 | 4.526 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1043.8 ± 1.4% | 1339.3 ± 0.3% | 1212.5 ± 0.6% | 356.6 ± 1.1% | 666.5 ± 1.7% | 321.0 ± 2.3% | 0.779 | 0.861 | 2.928 | 1.566 | 3.251 |
| qlog records, JSON text sequence | 1467503 | 900.4 ± 5.1% | 1054.3 ± 0.4% | 1087.2 ± 0.3% | 303.4 ± 1.0% | 731.4 ± 5.1% | 318.9 ± 1.6% | 0.854 | 0.828 | 2.968 | 1.231 | 2.823 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1299.2 ± 4.0% | 1585.8 ± 2.9% | 1165.9 ± 1.0% | 423.7 ± 0.3% | 454.8 ± 2.3% | 415.3 ± 0.5% | 0.819 | 1.114 | 3.067 | 2.857 | 3.129 |
| qlog records, JSON text sequence | 1467503 | 1081.5 ± 4.8% | 1298.7 ± 0.3% | 902.1 ± 0.3% | 427.7 ± 1.0% | 499.6 ± 4.3% | 330.7 ± 1.2% | 0.833 | 1.199 | 2.529 | 2.165 | 3.270 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.779 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.861 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.854 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.828 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.819 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.833 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1417.5 ± 4.5% | 0.433 | 0.921 | 0.941 | 0.941 | 0.356 | 0.967 | 0.939 | 0.333 | 0.732 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1090.6 ± 2.7% | 0.740 | 0.982 | 0.950 | 0.953 | 0.357 | 0.980 | 0.949 | 0.337 | 0.830 | 0.118 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1749.6 ± 0.8% | 0.421 | 0.962 | 0.969 | 0.980 | 1.002 | 0.248 | 1.002 | 0.439 | 0.741 | 0.087 | 1.019 |
| qlog records, JSON text sequence | 1467503 | 1489.6 ± 7.0% | 0.681 | 0.938 | 0.987 | 0.990 | 0.981 | 0.248 | 0.986 | 0.422 | 0.730 | 0.113 | 1.003 |

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
| CLDR supplemental, 34 texts | 920675 | 1417.5 ± 4.5% | 1325.8 ± 0.9% | 1206.6 ± 1.2% | 356.9 ± 1.4% | 657.7 ± 3.2% | 322.1 ± 2.5% | 1.069 | 1.175 | 3.971 | 2.155 | 4.400 |
| qlog records, JSON text sequence | 1467503 | 1090.6 ± 2.7% | 1030.3 ± 1.0% | 1084.6 ± 4.9% | 296.2 ± 3.7% | 728.5 ± 0.8% | 318.7 ± 1.1% | 1.059 | 1.006 | 3.682 | 1.497 | 3.422 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1749.6 ± 0.8% | 1575.7 ± 1.0% | 1158.4 ± 4.5% | 422.8 ± 1.1% | 443.7 ± 6.5% | 415.0 ± 1.3% | 1.110 | 1.510 | 4.138 | 3.943 | 4.216 |
| qlog records, JSON text sequence | 1467503 | 1489.6 ± 7.0% | 1314.6 ± 3.4% | 903.6 ± 6.9% | 420.2 ± 0.8% | 484.3 ± 0.8% | 331.2 ± 1.6% | 1.133 | 1.648 | 3.545 | 3.076 | 4.497 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1782.0 ± 5.8% | 1575.7 ± 1.0% | 1158.4 ± 4.5% | 422.8 ± 1.1% | 443.7 ± 6.5% | 415.0 ± 1.3% | 1.131 | 1.538 | 4.215 | 4.017 | 4.294 |
| qlog records, JSON text sequence | 1467503 | 1493.6 ± 0.7% | 1314.6 ± 3.4% | 903.6 ± 6.9% | 420.2 ± 0.8% | 484.3 ± 0.8% | 331.2 ± 1.6% | 1.136 | 1.653 | 3.554 | 3.084 | 4.509 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1037.7 ± 1.3% | 1325.8 ± 0.9% | 1206.6 ± 1.2% | 356.9 ± 1.4% | 657.7 ± 3.2% | 322.1 ± 2.5% | 0.783 | 0.860 | 2.907 | 1.578 | 3.221 |
| qlog records, JSON text sequence | 1467503 | 905.4 ± 0.9% | 1030.3 ± 1.0% | 1084.6 ± 4.9% | 296.2 ± 3.7% | 728.5 ± 0.8% | 318.7 ± 1.1% | 0.879 | 0.835 | 3.057 | 1.243 | 2.841 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1297.1 ± 39.4% | 1575.7 ± 1.0% | 1158.4 ± 4.5% | 422.8 ± 1.1% | 443.7 ± 6.5% | 415.0 ± 1.3% | 0.823 | 1.120 | 3.068 | 2.924 | 3.125 |
| qlog records, JSON text sequence | 1467503 | 1087.5 ± 4.7% | 1314.6 ± 3.4% | 903.6 ± 6.9% | 420.2 ± 0.8% | 484.3 ± 0.8% | 331.2 ± 1.6% | 0.827 | 1.203 | 2.588 | 2.245 | 3.283 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.783 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.860 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.879 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.835 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.827 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1416.0 ± 5.1% | 0.431 | 0.913 | 0.942 | 0.942 | 0.355 | 0.962 | 0.959 | 0.333 | 0.750 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 1104.6 ± 3.3% | 0.726 | 0.969 | 0.941 | 0.940 | 0.358 | 0.968 | 0.940 | 0.334 | 0.836 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1756.9 ± 0.8% | 0.421 | 0.961 | 0.961 | 0.970 | 0.998 | 0.247 | 0.997 | 0.440 | 0.739 | 0.087 | 1.013 |
| qlog records, JSON text sequence | 1467503 | 1492.0 ± 0.2% | 0.680 | 0.944 | 0.991 | 0.993 | 0.983 | 0.247 | 0.983 | 0.421 | 0.726 | 0.113 | 1.003 |

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
| CLDR supplemental, 34 texts | 920675 | 1416.0 ± 5.1% | 1361.2 ± 0.7% | 1209.7 ± 1.4% | 356.6 ± 3.0% | 665.7 ± 2.5% | 319.9 ± 3.4% | 1.040 | 1.171 | 3.971 | 2.127 | 4.427 |
| qlog records, JSON text sequence | 1467503 | 1104.6 ± 3.3% | 1057.3 ± 5.2% | 1084.6 ± 27.8% | 300.6 ± 1.8% | 733.1 ± 0.9% | 316.7 ± 1.9% | 1.045 | 1.018 | 3.675 | 1.507 | 3.488 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1756.9 ± 0.8% | 1590.3 ± 1.3% | 1163.5 ± 1.9% | 424.5 ± 1.0% | 445.6 ± 3.5% | 415.3 ± 0.4% | 1.105 | 1.510 | 4.139 | 3.943 | 4.230 |
| qlog records, JSON text sequence | 1467503 | 1492.0 ± 0.2% | 1309.1 ± 0.2% | 903.2 ± 1.0% | 426.9 ± 0.6% | 503.4 ± 0.6% | 330.7 ± 1.9% | 1.140 | 1.652 | 3.495 | 2.964 | 4.511 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1780.2 ± 0.9% | 1590.3 ± 1.3% | 1163.5 ± 1.9% | 424.5 ± 1.0% | 445.6 ± 3.5% | 415.3 ± 0.4% | 1.119 | 1.530 | 4.194 | 3.995 | 4.286 |
| qlog records, JSON text sequence | 1467503 | 1496.8 ± 0.2% | 1309.1 ± 0.2% | 903.2 ± 1.0% | 426.9 ± 0.6% | 503.4 ± 0.6% | 330.7 ± 1.9% | 1.143 | 1.657 | 3.507 | 2.973 | 4.526 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1061.4 ± 3.2% | 1361.2 ± 0.7% | 1209.7 ± 1.4% | 356.6 ± 3.0% | 665.7 ± 2.5% | 319.9 ± 3.4% | 0.780 | 0.877 | 2.977 | 1.595 | 3.318 |
| qlog records, JSON text sequence | 1467503 | 922.9 ± 1.2% | 1057.3 ± 5.2% | 1084.6 ± 27.8% | 300.6 ± 1.8% | 733.1 ± 0.9% | 316.7 ± 1.9% | 0.873 | 0.851 | 3.071 | 1.259 | 2.915 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1297.9 ± 0.3% | 1590.3 ± 1.3% | 1163.5 ± 1.9% | 424.5 ± 1.0% | 445.6 ± 3.5% | 415.3 ± 0.4% | 0.816 | 1.116 | 3.058 | 2.913 | 3.125 |
| qlog records, JSON text sequence | 1467503 | 1082.7 ± 0.2% | 1309.1 ± 0.2% | 903.2 ± 1.0% | 426.9 ± 0.6% | 503.4 ± 0.6% | 330.7 ± 1.9% | 0.827 | 1.199 | 2.536 | 2.151 | 3.274 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.780 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.877 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.873 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.816 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.827 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1344.2 ± 3.9% | 0.478 | 1.007 | 0.994 | 0.998 | 0.372 | 0.994 | 0.997 | 0.348 | 0.778 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1066.6 ± 1.1% | 0.792 | 1.028 | 1.023 | 1.035 | 0.374 | 1.006 | 1.043 | 0.344 | 0.690 | 0.120 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1735.9 ± 1.0% | 0.429 | 0.987 | 0.970 | 1.014 | 1.010 | 0.253 | 1.006 | 0.446 | 0.743 | 0.089 | 1.025 |
| qlog records, JSON text sequence | 1467503 | 1483.9 ± 0.6% | 0.683 | 0.957 | 0.987 | 0.996 | 0.990 | 0.252 | 0.992 | 0.424 | 0.730 | 0.114 | 1.016 |

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
| CLDR supplemental, 34 texts | 920675 | 1344.2 ± 3.9% | 1307.0 ± 0.8% | 1190.0 ± 0.9% | 356.2 ± 10.1% | 663.0 ± 25.6% | 320.4 ± 2.3% | 1.028 | 1.130 | 3.774 | 2.028 | 4.196 |
| qlog records, JSON text sequence | 1467503 | 1066.6 ± 1.1% | 1032.6 ± 0.6% | 1064.3 ± 1.1% | 294.8 ± 5.0% | 720.8 ± 0.7% | 318.2 ± 0.8% | 1.033 | 1.002 | 3.618 | 1.480 | 3.352 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1735.9 ± 1.0% | 1591.6 ± 0.6% | 1167.9 ± 2.0% | 424.4 ± 1.0% | 458.3 ± 0.6% | 411.8 ± 0.6% | 1.091 | 1.486 | 4.090 | 3.788 | 4.215 |
| qlog records, JSON text sequence | 1467503 | 1483.9 ± 0.6% | 1314.1 ± 0.2% | 905.2 ± 0.1% | 425.9 ± 0.4% | 497.0 ± 0.2% | 328.0 ± 1.0% | 1.129 | 1.639 | 3.484 | 2.986 | 4.524 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1780.1 ± 0.7% | 1591.6 ± 0.6% | 1167.9 ± 2.0% | 424.4 ± 1.0% | 458.3 ± 0.6% | 411.8 ± 0.6% | 1.118 | 1.524 | 4.194 | 3.884 | 4.323 |
| qlog records, JSON text sequence | 1467503 | 1507.0 ± 1.5% | 1314.1 ± 0.2% | 905.2 ± 0.1% | 425.9 ± 0.4% | 497.0 ± 0.2% | 328.0 ± 1.0% | 1.147 | 1.665 | 3.538 | 3.032 | 4.595 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1045.4 ± 0.4% | 1307.0 ± 0.8% | 1190.0 ± 0.9% | 356.2 ± 10.1% | 663.0 ± 25.6% | 320.4 ± 2.3% | 0.800 | 0.878 | 2.935 | 1.577 | 3.263 |
| qlog records, JSON text sequence | 1467503 | 735.9 ± 1.1% | 1032.6 ± 0.6% | 1064.3 ± 1.1% | 294.8 ± 5.0% | 720.8 ± 0.7% | 318.2 ± 0.8% | 0.713 | 0.691 | 2.497 | 1.021 | 2.313 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1290.1 ± 0.4% | 1591.6 ± 0.6% | 1167.9 ± 2.0% | 424.4 ± 1.0% | 458.3 ± 0.6% | 411.8 ± 0.6% | 0.811 | 1.105 | 3.040 | 2.815 | 3.133 |
| qlog records, JSON text sequence | 1467503 | 1083.1 ± 0.2% | 1314.1 ± 0.2% | 905.2 ± 0.1% | 425.9 ± 0.4% | 497.0 ± 0.2% | 328.0 ± 1.0% | 0.824 | 1.196 | 2.543 | 2.179 | 3.303 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.800 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.878 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.713 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.691 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.811 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.824 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1413.9 ± 4.3% | 0.433 | 0.895 | 0.936 | 0.940 | 0.356 | 0.968 | 0.937 | 0.333 | 0.762 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 1104.3 ± 2.2% | 0.730 | 0.971 | 0.957 | 0.941 | 0.358 | 0.968 | 0.940 | 0.334 | 0.802 | 0.117 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1755.0 ± 0.3% | 0.423 | 0.961 | 0.960 | 0.971 | 1.005 | 0.248 | 0.997 | 0.441 | 0.738 | 0.087 | 1.018 |
| qlog records, JSON text sequence | 1467503 | 1479.7 ± 6.9% | 0.683 | 0.943 | 0.989 | 0.995 | 0.992 | 0.250 | 0.993 | 0.417 | 0.733 | 0.114 | 1.014 |

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
| CLDR supplemental, 34 texts | 920675 | 1413.9 ± 4.3% | 1351.0 ± 18.2% | 1203.5 ± 10.5% | 353.9 ± 2.8% | 671.9 ± 1.6% | 321.9 ± 2.7% | 1.047 | 1.175 | 3.996 | 2.104 | 4.392 |
| qlog records, JSON text sequence | 1467503 | 1104.3 ± 2.2% | 1001.5 ± 0.6% | 1084.4 ± 0.9% | 301.8 ± 4.5% | 731.8 ± 1.4% | 319.9 ± 4.2% | 1.103 | 1.018 | 3.658 | 1.509 | 3.452 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1755.0 ± 0.3% | 1590.5 ± 1.6% | 1154.6 ± 3.4% | 424.6 ± 0.1% | 454.2 ± 2.9% | 415.0 ± 0.4% | 1.103 | 1.520 | 4.134 | 3.864 | 4.229 |
| qlog records, JSON text sequence | 1467503 | 1479.7 ± 6.9% | 1309.3 ± 37.9% | 904.0 ± 0.3% | 426.7 ± 0.5% | 495.9 ± 0.4% | 330.6 ± 2.6% | 1.130 | 1.637 | 3.468 | 2.984 | 4.475 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1786.4 ± 5.6% | 1590.5 ± 1.6% | 1154.6 ± 3.4% | 424.6 ± 0.1% | 454.2 ± 2.9% | 415.0 ± 0.4% | 1.123 | 1.547 | 4.208 | 3.933 | 4.305 |
| qlog records, JSON text sequence | 1467503 | 1500.5 ± 0.6% | 1309.3 ± 37.9% | 904.0 ± 0.3% | 426.7 ± 0.5% | 495.9 ± 0.4% | 330.6 ± 2.6% | 1.146 | 1.660 | 3.517 | 3.026 | 4.538 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1077.7 ± 1.9% | 1351.0 ± 18.2% | 1203.5 ± 10.5% | 353.9 ± 2.8% | 671.9 ± 1.6% | 321.9 ± 2.7% | 0.798 | 0.895 | 3.045 | 1.604 | 3.348 |
| qlog records, JSON text sequence | 1467503 | 885.2 ± 5.6% | 1001.5 ± 0.6% | 1084.4 ± 0.9% | 301.8 ± 4.5% | 731.8 ± 1.4% | 319.9 ± 4.2% | 0.884 | 0.816 | 2.933 | 1.210 | 2.767 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1295.1 ± 0.8% | 1590.5 ± 1.6% | 1154.6 ± 3.4% | 424.6 ± 0.1% | 454.2 ± 2.9% | 415.0 ± 0.4% | 0.814 | 1.122 | 3.050 | 2.851 | 3.121 |
| qlog records, JSON text sequence | 1467503 | 1084.2 ± 35.1% | 1309.3 ± 37.9% | 904.0 ± 0.3% | 426.7 ± 0.5% | 495.9 ± 0.4% | 330.6 ± 2.6% | 0.828 | 1.199 | 2.541 | 2.187 | 3.279 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.798 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.884 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.816 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.814 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1410.4 ± 5.0% | 0.431 | 0.895 | 0.943 | 0.942 | 0.358 | 0.973 | 0.945 | 0.333 | 0.729 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1104.6 ± 6.4% | 0.731 | 0.971 | 0.941 | 0.940 | 0.359 | 0.968 | 0.940 | 0.334 | 0.814 | 0.117 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1756.4 ± 2.4% | 0.421 | 0.958 | 0.971 | 0.973 | 1.002 | 0.249 | 1.004 | 0.440 | 0.738 | 0.087 | 1.018 |
| qlog records, JSON text sequence | 1467503 | 1490.6 ± 0.2% | 0.683 | 0.943 | 0.990 | 0.991 | 0.983 | 0.249 | 0.983 | 0.419 | 0.724 | 0.113 | 1.003 |

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
| CLDR supplemental, 34 texts | 920675 | 1410.4 ± 5.0% | 1352.1 ± 0.6% | 1216.2 ± 0.9% | 356.7 ± 1.0% | 668.0 ± 1.1% | 320.0 ± 3.8% | 1.043 | 1.160 | 3.954 | 2.111 | 4.407 |
| qlog records, JSON text sequence | 1467503 | 1104.6 ± 6.4% | 770.6 ± 0.7% | 1092.4 ± 0.6% | 303.4 ± 2.1% | 729.2 ± 0.9% | 319.8 ± 2.1% | 1.433 | 1.011 | 3.641 | 1.515 | 3.454 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1756.4 ± 2.4% | 1588.2 ± 1.1% | 1159.4 ± 1.2% | 425.3 ± 2.2% | 457.2 ± 4.5% | 416.5 ± 0.8% | 1.106 | 1.515 | 4.130 | 3.842 | 4.217 |
| qlog records, JSON text sequence | 1467503 | 1490.6 ± 0.2% | 1308.6 ± 0.3% | 904.2 ± 1.0% | 426.8 ± 0.9% | 497.3 ± 0.1% | 330.5 ± 1.4% | 1.139 | 1.648 | 3.492 | 2.997 | 4.510 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1788.0 ± 2.4% | 1588.2 ± 1.1% | 1159.4 ± 1.2% | 425.3 ± 2.2% | 457.2 ± 4.5% | 416.5 ± 0.8% | 1.126 | 1.542 | 4.204 | 3.911 | 4.293 |
| qlog records, JSON text sequence | 1467503 | 1494.8 ± 0.3% | 1308.6 ± 0.3% | 904.2 ± 1.0% | 426.8 ± 0.9% | 497.3 ± 0.1% | 330.5 ± 1.4% | 1.142 | 1.653 | 3.502 | 3.006 | 4.523 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1028.8 ± 17.6% | 1352.1 ± 0.6% | 1216.2 ± 0.9% | 356.7 ± 1.0% | 668.0 ± 1.1% | 320.0 ± 3.8% | 0.761 | 0.846 | 2.884 | 1.540 | 3.215 |
| qlog records, JSON text sequence | 1467503 | 899.1 ± 0.7% | 770.6 ± 0.7% | 1092.4 ± 0.6% | 303.4 ± 2.1% | 729.2 ± 0.9% | 319.8 ± 2.1% | 1.167 | 0.823 | 2.964 | 1.233 | 2.812 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1296.8 ± 0.6% | 1588.2 ± 1.1% | 1159.4 ± 1.2% | 425.3 ± 2.2% | 457.2 ± 4.5% | 416.5 ± 0.8% | 0.817 | 1.119 | 3.049 | 2.837 | 3.113 |
| qlog records, JSON text sequence | 1467503 | 1078.7 ± 0.3% | 1308.6 ± 0.3% | 904.2 ± 1.0% | 426.8 ± 0.9% | 497.3 ± 0.1% | 330.5 ± 1.4% | 0.824 | 1.193 | 2.527 | 2.169 | 3.264 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.761 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.823 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.817 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.824 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1421.9 ± 0.5% | 0.430 | 0.896 | 0.939 | 0.939 | 0.355 | 0.962 | 0.939 | 0.331 | 0.729 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1086.2 ± 0.8% | 0.742 | 0.987 | 0.957 | 0.953 | 0.365 | 0.982 | 0.955 | 0.339 | 0.836 | 0.118 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1746.4 ± 1.0% | 0.423 | 0.962 | 0.971 | 0.972 | 1.004 | 0.249 | 1.004 | 0.442 | 0.743 | 0.088 | 1.018 |
| qlog records, JSON text sequence | 1467503 | 1485.0 ± 0.8% | 0.683 | 0.941 | 0.988 | 0.993 | 0.986 | 0.250 | 0.992 | 0.417 | 0.728 | 0.114 | 1.013 |

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
| CLDR supplemental, 34 texts | 920675 | 1421.9 ± 0.5% | 1357.5 ± 0.4% | 1214.3 ± 0.7% | 356.4 ± 0.7% | 659.0 ± 1.2% | 320.8 ± 2.2% | 1.047 | 1.171 | 3.990 | 2.157 | 4.432 |
| qlog records, JSON text sequence | 1467503 | 1086.2 ± 0.8% | 1050.3 ± 0.5% | 1078.2 ± 0.4% | 301.3 ± 1.5% | 727.3 ± 0.5% | 317.8 ± 1.0% | 1.034 | 1.007 | 3.606 | 1.494 | 3.418 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1746.4 ± 1.0% | 1572.2 ± 1.0% | 1160.6 ± 2.4% | 421.9 ± 1.6% | 449.5 ± 18.5% | 416.0 ± 1.4% | 1.111 | 1.505 | 4.140 | 3.885 | 4.198 |
| qlog records, JSON text sequence | 1467503 | 1485.0 ± 0.8% | 1299.3 ± 0.7% | 894.3 ± 6.8% | 426.8 ± 0.3% | 484.4 ± 0.3% | 332.0 ± 0.7% | 1.143 | 1.661 | 3.479 | 3.066 | 4.473 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1778.6 ± 0.8% | 1572.2 ± 1.0% | 1160.6 ± 2.4% | 421.9 ± 1.6% | 449.5 ± 18.5% | 416.0 ± 1.4% | 1.131 | 1.532 | 4.216 | 3.957 | 4.275 |
| qlog records, JSON text sequence | 1467503 | 1504.3 ± 0.2% | 1299.3 ± 0.7% | 894.3 ± 6.8% | 426.8 ± 0.3% | 484.4 ± 0.3% | 332.0 ± 0.7% | 1.158 | 1.682 | 3.525 | 3.106 | 4.531 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1035.9 ± 0.5% | 1357.5 ± 0.4% | 1214.3 ± 0.7% | 356.4 ± 0.7% | 659.0 ± 1.2% | 320.8 ± 2.2% | 0.763 | 0.853 | 2.907 | 1.572 | 3.229 |
| qlog records, JSON text sequence | 1467503 | 908.1 ± 0.5% | 1050.3 ± 0.5% | 1078.2 ± 0.4% | 301.3 ± 1.5% | 727.3 ± 0.5% | 317.8 ± 1.0% | 0.865 | 0.842 | 3.014 | 1.249 | 2.857 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1297.5 ± 2.9% | 1572.2 ± 1.0% | 1160.6 ± 2.4% | 421.9 ± 1.6% | 449.5 ± 18.5% | 416.0 ± 1.4% | 0.825 | 1.118 | 3.076 | 2.887 | 3.119 |
| qlog records, JSON text sequence | 1467503 | 1081.6 ± 0.9% | 1299.3 ± 0.7% | 894.3 ± 6.8% | 426.8 ± 0.3% | 484.4 ± 0.3% | 332.0 ± 0.7% | 0.832 | 1.209 | 2.534 | 2.233 | 3.258 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.763 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.853 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.865 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.842 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.825 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.832 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1418.4 ± 4.5% | 0.429 | 0.926 | 0.934 | 0.936 | 0.355 | 0.962 | 0.933 | 0.332 | 0.751 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1102.7 ± 1.8% | 0.732 | 0.972 | 0.935 | 0.944 | 0.359 | 0.966 | 0.943 | 0.334 | 0.840 | 0.117 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1751.2 ± 0.6% | 0.423 | 0.962 | 0.971 | 0.974 | 1.003 | 0.249 | 1.001 | 0.443 | 0.742 | 0.088 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1490.0 ± 1.1% | 0.681 | 0.942 | 0.990 | 0.991 | 0.984 | 0.248 | 0.987 | 0.422 | 0.728 | 0.113 | 1.009 |

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
| CLDR supplemental, 34 texts | 920675 | 1418.4 ± 4.5% | 1357.2 ± 0.3% | 1205.6 ± 1.3% | 355.3 ± 3.4% | 666.8 ± 1.7% | 321.8 ± 2.6% | 1.045 | 1.177 | 3.992 | 2.127 | 4.408 |
| qlog records, JSON text sequence | 1467503 | 1102.7 ± 1.8% | 1057.3 ± 2.4% | 1084.3 ± 0.7% | 304.7 ± 4.0% | 731.1 ± 2.0% | 318.5 ± 1.4% | 1.043 | 1.017 | 3.620 | 1.508 | 3.462 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1751.2 ± 0.6% | 1570.3 ± 0.5% | 1168.5 ± 1.8% | 423.7 ± 0.5% | 452.6 ± 3.3% | 415.9 ± 0.9% | 1.115 | 1.499 | 4.133 | 3.869 | 4.210 |
| qlog records, JSON text sequence | 1467503 | 1490.0 ± 1.1% | 1314.9 ± 0.5% | 905.5 ± 6.5% | 429.0 ± 18.6% | 496.7 ± 0.3% | 331.0 ± 1.5% | 1.133 | 1.645 | 3.473 | 3.000 | 4.501 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1780.7 ± 1.3% | 1570.3 ± 0.5% | 1168.5 ± 1.8% | 423.7 ± 0.5% | 452.6 ± 3.3% | 415.9 ± 0.9% | 1.134 | 1.524 | 4.203 | 3.934 | 4.281 |
| qlog records, JSON text sequence | 1467503 | 1504.0 ± 2.0% | 1314.9 ± 0.5% | 905.5 ± 6.5% | 429.0 ± 18.6% | 496.7 ± 0.3% | 331.0 ± 1.5% | 1.144 | 1.661 | 3.506 | 3.028 | 4.544 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1065.0 ± 2.0% | 1357.2 ± 0.3% | 1205.6 ± 1.3% | 355.3 ± 3.4% | 666.8 ± 1.7% | 321.8 ± 2.6% | 0.785 | 0.883 | 2.997 | 1.597 | 3.310 |
| qlog records, JSON text sequence | 1467503 | 925.8 ± 0.7% | 1057.3 ± 2.4% | 1084.3 ± 0.7% | 304.7 ± 4.0% | 731.1 ± 2.0% | 318.5 ± 1.4% | 0.876 | 0.854 | 3.039 | 1.266 | 2.907 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1299.1 ± 0.5% | 1570.3 ± 0.5% | 1168.5 ± 1.8% | 423.7 ± 0.5% | 452.6 ± 3.3% | 415.9 ± 0.9% | 0.827 | 1.112 | 3.066 | 2.870 | 3.123 |
| qlog records, JSON text sequence | 1467503 | 1084.6 ± 0.4% | 1314.9 ± 0.5% | 905.5 ± 6.5% | 429.0 ± 18.6% | 496.7 ± 0.3% | 331.0 ± 1.5% | 0.825 | 1.198 | 2.528 | 2.183 | 3.277 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.785 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.883 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.876 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.854 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.827 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.825 of simdjson.
