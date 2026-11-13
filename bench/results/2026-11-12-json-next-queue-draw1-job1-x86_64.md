# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1570.5 ± 22.4% | 0.541 | 0.983 | 1.020 | 1.022 | 0.402 | 1.023 | 1.019 | 0.393 | 0.844 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 1293.1 ± 5.4% | 0.907 | 1.008 | 1.011 | 1.024 | 0.387 | 1.011 | 1.013 | 0.378 | 0.712 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2304.5 ± 1.9% | 0.429 | 0.939 | 0.966 | 0.992 | 0.994 | 0.262 | 0.995 | 0.463 | 0.731 | 0.083 | 0.991 |
| qlog records, JSON text sequence | 1467503 | 2016.5 ± 10.9% | 0.715 | 0.914 | 0.978 | 0.995 | 0.992 | 0.256 | 0.980 | 0.425 | 0.718 | 0.099 | 0.976 |

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
| CLDR supplemental, 34 texts | 920675 | 1570.5 ± 22.4% | 2007.2 ± 0.9% | 1601.1 ± 3.2% | 514.8 ± 12.4% | 800.4 ± 10.6% | 461.9 ± 8.4% | 0.782 | 0.981 | 3.051 | 1.962 | 3.400 |
| qlog records, JSON text sequence | 1467503 | 1293.1 ± 5.4% | 1527.2 ± 0.5% | 1528.6 ± 3.3% | 448.7 ± 1.7% | 933.2 ± 0.4% | 468.7 ± 2.8% | 0.847 | 0.846 | 2.882 | 1.386 | 2.759 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2304.5 ± 1.9% | 2263.8 ± 1.3% | 1456.6 ± 7.7% | 593.2 ± 1.7% | 622.2 ± 3.4% | 570.7 ± 2.6% | 1.018 | 1.582 | 3.885 | 3.704 | 4.038 |
| qlog records, JSON text sequence | 1467503 | 2016.5 ± 10.9% | 1881.2 ± 0.7% | 1190.6 ± 0.5% | 570.9 ± 1.7% | 685.3 ± 4.7% | 478.3 ± 1.8% | 1.072 | 1.694 | 3.532 | 2.942 | 4.215 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2284.8 ± 0.7% | 2263.8 ± 1.3% | 1456.6 ± 7.7% | 593.2 ± 1.7% | 622.2 ± 3.4% | 570.7 ± 2.6% | 1.009 | 1.569 | 3.852 | 3.672 | 4.003 |
| qlog records, JSON text sequence | 1467503 | 1967.2 ± 42.1% | 1881.2 ± 0.7% | 1190.6 ± 0.5% | 570.9 ± 1.7% | 685.3 ± 4.7% | 478.3 ± 1.8% | 1.046 | 1.652 | 3.446 | 2.870 | 4.113 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1325.4 ± 1.1% | 2007.2 ± 0.9% | 1601.1 ± 3.2% | 514.8 ± 12.4% | 800.4 ± 10.6% | 461.9 ± 8.4% | 0.660 | 0.828 | 2.575 | 1.656 | 2.869 |
| qlog records, JSON text sequence | 1467503 | 920.8 ± 0.4% | 1527.2 ± 0.5% | 1528.6 ± 3.3% | 448.7 ± 1.7% | 933.2 ± 0.4% | 468.7 ± 2.8% | 0.603 | 0.602 | 2.052 | 0.987 | 1.965 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1685.3 ± 1.6% | 2263.8 ± 1.3% | 1456.6 ± 7.7% | 593.2 ± 1.7% | 622.2 ± 3.4% | 570.7 ± 2.6% | 0.744 | 1.157 | 2.841 | 2.709 | 2.953 |
| qlog records, JSON text sequence | 1467503 | 1447.6 ± 1.1% | 1881.2 ± 0.7% | 1190.6 ± 0.5% | 570.9 ± 1.7% | 685.3 ± 4.7% | 478.3 ± 1.8% | 0.770 | 1.216 | 2.536 | 2.112 | 3.026 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.847 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.846 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.660 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.828 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.603 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.602 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.744 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.770 of simdjson.

# bench-json, CLDR and qlog alone: null, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1574.1 ± 7.9% | 0.531 | 0.983 | 1.012 | 1.018 | 0.398 | 1.012 | 1.020 | 0.397 | 0.838 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 1297.1 ± 4.6% | 0.861 | 1.034 | 0.984 | 0.982 | 0.386 | 0.978 | 0.972 | 0.377 | 0.723 | 0.112 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2284.3 ± 5.5% | 0.443 | 0.956 | 0.966 | 0.999 | 0.987 | 0.270 | 0.989 | 0.468 | 0.740 | 0.086 | 0.996 |
| qlog records, JSON text sequence | 1467503 | 2020.4 ± 0.9% | 0.715 | 0.909 | 0.982 | 0.991 | 0.980 | 0.260 | 0.982 | 0.428 | 0.714 | 0.099 | 0.991 |

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
| CLDR supplemental, 34 texts | 920675 | 1574.1 ± 7.9% | 2022.0 ± 0.5% | 1628.5 ± 3.0% | 515.5 ± 10.9% | 805.8 ± 4.5% | 457.7 ± 4.9% | 0.778 | 0.967 | 3.053 | 1.954 | 3.439 |
| qlog records, JSON text sequence | 1467503 | 1297.1 ± 4.6% | 1553.7 ± 4.4% | 1505.4 ± 3.3% | 444.3 ± 1.8% | 926.7 ± 1.1% | 466.6 ± 5.0% | 0.835 | 0.862 | 2.919 | 1.400 | 2.780 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2284.3 ± 5.5% | 2247.8 ± 2.6% | 1463.7 ± 4.2% | 592.9 ± 1.8% | 628.4 ± 1.4% | 569.3 ± 3.2% | 1.016 | 1.561 | 3.853 | 3.635 | 4.013 |
| qlog records, JSON text sequence | 1467503 | 2020.4 ± 0.9% | 1824.4 ± 35.8% | 1190.3 ± 6.9% | 584.2 ± 5.4% | 692.2 ± 34.1% | 472.5 ± 2.3% | 1.107 | 1.697 | 3.458 | 2.919 | 4.276 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2275.5 ± 0.9% | 2247.8 ± 2.6% | 1463.7 ± 4.2% | 592.9 ± 1.8% | 628.4 ± 1.4% | 569.3 ± 3.2% | 1.012 | 1.555 | 3.838 | 3.621 | 3.997 |
| qlog records, JSON text sequence | 1467503 | 2001.8 ± 2.7% | 1824.4 ± 35.8% | 1190.3 ± 6.9% | 584.2 ± 5.4% | 692.2 ± 34.1% | 472.5 ± 2.3% | 1.097 | 1.682 | 3.426 | 2.892 | 4.237 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1318.4 ± 1.2% | 2022.0 ± 0.5% | 1628.5 ± 3.0% | 515.5 ± 10.9% | 805.8 ± 4.5% | 457.7 ± 4.9% | 0.652 | 0.810 | 2.557 | 1.636 | 2.881 |
| qlog records, JSON text sequence | 1467503 | 937.6 ± 2.8% | 1553.7 ± 4.4% | 1505.4 ± 3.3% | 444.3 ± 1.8% | 926.7 ± 1.1% | 466.6 ± 5.0% | 0.603 | 0.623 | 2.110 | 1.012 | 2.009 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1691.2 ± 1.1% | 2247.8 ± 2.6% | 1463.7 ± 4.2% | 592.9 ± 1.8% | 628.4 ± 1.4% | 569.3 ± 3.2% | 0.752 | 1.155 | 2.853 | 2.691 | 2.971 |
| qlog records, JSON text sequence | 1467503 | 1443.3 ± 6.9% | 1824.4 ± 35.8% | 1190.3 ± 6.9% | 584.2 ± 5.4% | 692.2 ± 34.1% | 472.5 ± 2.3% | 0.791 | 1.213 | 2.471 | 2.085 | 3.055 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.778 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.835 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.862 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.652 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.810 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.603 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.623 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.752 of simdjson.

# bench-json, CLDR and qlog alone: head, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1580.0 ± 3.6% | 0.522 | 0.987 | 1.018 | 1.015 | 0.398 | 1.011 | 1.015 | 0.392 | 0.783 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1299.3 ± 3.0% | 0.874 | 1.027 | 0.980 | 0.979 | 0.383 | 0.982 | 0.980 | 0.372 | 0.831 | 0.112 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2276.8 ± 25.0% | 0.449 | 0.952 | 0.967 | 1.002 | 1.008 | 0.268 | 1.010 | 0.469 | 0.736 | 0.081 | 0.995 |
| qlog records, JSON text sequence | 1467503 | 2017.5 ± 21.8% | 0.719 | 0.920 | 0.989 | 0.999 | 0.991 | 0.261 | 0.988 | 0.429 | 0.726 | 0.100 | 1.000 |

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
| CLDR supplemental, 34 texts | 920675 | 1580.0 ± 3.6% | 2045.1 ± 0.3% | 1588.2 ± 2.0% | 517.9 ± 13.4% | 718.0 ± 6.3% | 459.0 ± 5.9% | 0.773 | 0.995 | 3.051 | 2.201 | 3.443 |
| qlog records, JSON text sequence | 1467503 | 1299.3 ± 3.0% | 1564.2 ± 1.4% | 1509.0 ± 1.3% | 441.0 ± 4.4% | 896.9 ± 1.1% | 462.7 ± 3.6% | 0.831 | 0.861 | 2.946 | 1.449 | 2.808 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2276.8 ± 25.0% | 2251.7 ± 7.4% | 1462.0 ± 4.1% | 596.5 ± 3.7% | 536.1 ± 0.7% | 578.9 ± 3.7% | 1.011 | 1.557 | 3.817 | 4.247 | 3.933 |
| qlog records, JSON text sequence | 1467503 | 2017.5 ± 21.8% | 1888.2 ± 32.4% | 1206.0 ± 54.8% | 589.4 ± 54.9% | 640.5 ± 33.9% | 459.9 ± 9.5% | 1.068 | 1.673 | 3.423 | 3.150 | 4.387 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2265.9 ± 0.7% | 2251.7 ± 7.4% | 1462.0 ± 4.1% | 596.5 ± 3.7% | 536.1 ± 0.7% | 578.9 ± 3.7% | 1.006 | 1.550 | 3.799 | 4.226 | 3.914 |
| qlog records, JSON text sequence | 1467503 | 2016.9 ± 9.6% | 1888.2 ± 32.4% | 1206.0 ± 54.8% | 589.4 ± 54.9% | 640.5 ± 33.9% | 459.9 ± 9.5% | 1.068 | 1.672 | 3.422 | 3.149 | 4.386 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1236.5 ± 0.2% | 2045.1 ± 0.3% | 1588.2 ± 2.0% | 517.9 ± 13.4% | 718.0 ± 6.3% | 459.0 ± 5.9% | 0.605 | 0.779 | 2.388 | 1.722 | 2.694 |
| qlog records, JSON text sequence | 1467503 | 1080.1 ± 0.2% | 1564.2 ± 1.4% | 1509.0 ± 1.3% | 441.0 ± 4.4% | 896.9 ± 1.1% | 462.7 ± 3.6% | 0.690 | 0.716 | 2.449 | 1.204 | 2.334 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1676.3 ± 0.7% | 2251.7 ± 7.4% | 1462.0 ± 4.1% | 596.5 ± 3.7% | 536.1 ± 0.7% | 578.9 ± 3.7% | 0.744 | 1.147 | 2.810 | 3.127 | 2.896 |
| qlog records, JSON text sequence | 1467503 | 1465.1 ± 13.2% | 1888.2 ± 32.4% | 1206.0 ± 54.8% | 589.4 ± 54.9% | 640.5 ± 33.9% | 459.9 ± 9.5% | 0.776 | 1.215 | 2.486 | 2.287 | 3.186 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.773 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.831 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.861 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.605 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.779 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.690 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.716 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.744 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1547.0 ± 5.0% | 0.555 | 0.993 | 1.029 | 1.005 | 0.404 | 1.030 | 1.007 | 0.403 | 0.858 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 1301.0 ± 1.3% | 0.894 | 1.002 | 1.030 | 1.006 | 0.387 | 1.021 | 1.004 | 0.377 | 0.709 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2295.4 ± 2.6% | 0.440 | 0.939 | 0.977 | 0.998 | 1.001 | 0.262 | 1.003 | 0.466 | 0.737 | 0.084 | 0.998 |
| qlog records, JSON text sequence | 1467503 | 2015.1 ± 1.7% | 0.714 | 0.915 | 0.975 | 0.994 | 0.982 | 0.255 | 0.988 | 0.423 | 0.719 | 0.099 | 0.992 |

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
| CLDR supplemental, 34 texts | 920675 | 1547.0 ± 5.0% | 2005.7 ± 3.3% | 1603.6 ± 1.0% | 516.3 ± 2.5% | 804.6 ± 30.0% | 462.5 ± 6.1% | 0.771 | 0.965 | 2.996 | 1.923 | 3.344 |
| qlog records, JSON text sequence | 1467503 | 1301.0 ± 1.3% | 1502.1 ± 4.8% | 1527.1 ± 2.3% | 447.3 ± 2.4% | 937.3 ± 5.5% | 463.1 ± 50.7% | 0.866 | 0.852 | 2.909 | 1.388 | 2.809 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2295.4 ± 2.6% | 2256.1 ± 1.8% | 1463.2 ± 2.7% | 601.5 ± 1.8% | 624.1 ± 2.3% | 570.0 ± 2.2% | 1.017 | 1.569 | 3.816 | 3.678 | 4.027 |
| qlog records, JSON text sequence | 1467503 | 2015.1 ± 1.7% | 1879.4 ± 3.8% | 1198.4 ± 1.0% | 575.0 ± 2.8% | 693.0 ± 5.9% | 481.0 ± 4.3% | 1.072 | 1.681 | 3.504 | 2.908 | 4.189 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2289.9 ± 1.4% | 2256.1 ± 1.8% | 1463.2 ± 2.7% | 601.5 ± 1.8% | 624.1 ± 2.3% | 570.0 ± 2.2% | 1.015 | 1.565 | 3.807 | 3.669 | 4.018 |
| qlog records, JSON text sequence | 1467503 | 1999.6 ± 5.4% | 1879.4 ± 3.8% | 1198.4 ± 1.0% | 575.0 ± 2.8% | 693.0 ± 5.9% | 481.0 ± 4.3% | 1.064 | 1.669 | 3.478 | 2.885 | 4.157 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1327.3 ± 5.3% | 2005.7 ± 3.3% | 1603.6 ± 1.0% | 516.3 ± 2.5% | 804.6 ± 30.0% | 462.5 ± 6.1% | 0.662 | 0.828 | 2.571 | 1.650 | 2.869 |
| qlog records, JSON text sequence | 1467503 | 922.5 ± 1.6% | 1502.1 ± 4.8% | 1527.1 ± 2.3% | 447.3 ± 2.4% | 937.3 ± 5.5% | 463.1 ± 50.7% | 0.614 | 0.604 | 2.062 | 0.984 | 1.992 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1690.9 ± 8.0% | 2256.1 ± 1.8% | 1463.2 ± 2.7% | 601.5 ± 1.8% | 624.1 ± 2.3% | 570.0 ± 2.2% | 0.749 | 1.156 | 2.811 | 2.709 | 2.967 |
| qlog records, JSON text sequence | 1467503 | 1448.4 ± 1.5% | 1879.4 ± 3.8% | 1198.4 ± 1.0% | 575.0 ± 2.8% | 693.0 ± 5.9% | 481.0 ± 4.3% | 0.771 | 1.209 | 2.519 | 2.090 | 3.011 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.771 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.866 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.852 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.662 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.828 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.614 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.604 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.749 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.771 of simdjson.

# bench-json, CLDR and qlog alone: null, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1596.9 ± 2.3% | 0.524 | 0.974 | 1.006 | 0.981 | 0.393 | 1.005 | 0.981 | 0.393 | 0.835 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1324.7 ± 2.8% | 0.864 | 0.990 | 0.954 | 0.957 | 0.376 | 0.920 | 0.956 | 0.371 | 0.708 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2287.4 ± 1.0% | 0.444 | 0.951 | 0.970 | 1.006 | 0.991 | 0.269 | 0.991 | 0.469 | 0.741 | 0.084 | 0.995 |
| qlog records, JSON text sequence | 1467503 | 2031.2 ± 1.5% | 0.712 | 0.914 | 0.987 | 0.990 | 0.982 | 0.258 | 0.982 | 0.426 | 0.721 | 0.099 | 0.999 |

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
| CLDR supplemental, 34 texts | 920675 | 1596.9 ± 2.3% | 2035.9 ± 1.0% | 1641.1 ± 31.3% | 507.9 ± 5.1% | 809.9 ± 2.0% | 461.5 ± 4.5% | 0.784 | 0.973 | 3.144 | 1.972 | 3.460 |
| qlog records, JSON text sequence | 1467503 | 1324.7 ± 2.8% | 1557.8 ± 1.5% | 1521.1 ± 2.6% | 446.8 ± 0.6% | 927.3 ± 1.0% | 466.4 ± 2.9% | 0.850 | 0.871 | 2.965 | 1.429 | 2.841 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2287.4 ± 1.0% | 2239.9 ± 38.9% | 1463.1 ± 4.7% | 603.5 ± 0.8% | 624.8 ± 2.4% | 569.0 ± 11.0% | 1.021 | 1.563 | 3.790 | 3.661 | 4.020 |
| qlog records, JSON text sequence | 1467503 | 2031.2 ± 1.5% | 1878.5 ± 6.0% | 1194.7 ± 45.6% | 594.9 ± 7.2% | 681.9 ± 2.7% | 473.6 ± 4.4% | 1.081 | 1.700 | 3.414 | 2.979 | 4.289 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2275.6 ± 1.2% | 2239.9 ± 38.9% | 1463.1 ± 4.7% | 603.5 ± 0.8% | 624.8 ± 2.4% | 569.0 ± 11.0% | 1.016 | 1.555 | 3.770 | 3.642 | 3.999 |
| qlog records, JSON text sequence | 1467503 | 2028.9 ± 1.2% | 1878.5 ± 6.0% | 1194.7 ± 45.6% | 594.9 ± 7.2% | 681.9 ± 2.7% | 473.6 ± 4.4% | 1.080 | 1.698 | 3.411 | 2.975 | 4.284 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.0 ± 26.7% | 2035.9 ± 1.0% | 1641.1 ± 31.3% | 507.9 ± 5.1% | 809.9 ± 2.0% | 461.5 ± 4.5% | 0.655 | 0.812 | 2.625 | 1.646 | 2.888 |
| qlog records, JSON text sequence | 1467503 | 937.8 ± 1.2% | 1557.8 ± 1.5% | 1521.1 ± 2.6% | 446.8 ± 0.6% | 927.3 ± 1.0% | 466.4 ± 2.9% | 0.602 | 0.617 | 2.099 | 1.011 | 2.011 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1695.8 ± 1.8% | 2239.9 ± 38.9% | 1463.1 ± 4.7% | 603.5 ± 0.8% | 624.8 ± 2.4% | 569.0 ± 11.0% | 0.757 | 1.159 | 2.810 | 2.714 | 2.980 |
| qlog records, JSON text sequence | 1467503 | 1465.4 ± 0.8% | 1878.5 ± 6.0% | 1194.7 ± 45.6% | 594.9 ± 7.2% | 681.9 ± 2.7% | 473.6 ± 4.4% | 0.780 | 1.227 | 2.463 | 2.149 | 3.094 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.784 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.850 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.871 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.655 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.602 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.617 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.780 of simdjson.

# bench-json, CLDR and qlog alone: head, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1576.5 ± 7.4% | 0.531 | 0.983 | 1.021 | 1.017 | 0.398 | 1.016 | 1.020 | 0.395 | 0.784 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1321.6 ± 2.6% | 0.865 | 1.009 | 0.968 | 0.965 | 0.373 | 0.963 | 0.964 | 0.367 | 0.818 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2285.6 ± 1.2% | 0.450 | 0.949 | 0.962 | 0.997 | 1.001 | 0.270 | 1.000 | 0.467 | 0.736 | 0.081 | 0.990 |
| qlog records, JSON text sequence | 1467503 | 2007.8 ± 1.8% | 0.718 | 0.916 | 0.990 | 0.995 | 0.986 | 0.264 | 0.992 | 0.431 | 0.727 | 0.100 | 0.999 |

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
| CLDR supplemental, 34 texts | 920675 | 1576.5 ± 7.4% | 2041.6 ± 1.1% | 1621.7 ± 2.0% | 518.8 ± 4.1% | 723.6 ± 2.1% | 463.2 ± 5.9% | 0.772 | 0.972 | 3.039 | 2.179 | 3.403 |
| qlog records, JSON text sequence | 1467503 | 1321.6 ± 2.6% | 1556.1 ± 0.8% | 1552.0 ± 2.0% | 440.4 ± 1.8% | 894.1 ± 1.4% | 461.0 ± 3.2% | 0.849 | 0.852 | 3.001 | 1.478 | 2.867 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2285.6 ± 1.2% | 2257.7 ± 1.1% | 1462.1 ± 1.7% | 594.9 ± 1.9% | 539.6 ± 0.8% | 577.1 ± 6.5% | 1.012 | 1.563 | 3.842 | 4.236 | 3.961 |
| qlog records, JSON text sequence | 1467503 | 2007.8 ± 1.8% | 1893.9 ± 20.9% | 1201.5 ± 40.2% | 590.4 ± 2.7% | 692.8 ± 1.7% | 464.8 ± 2.2% | 1.060 | 1.671 | 3.401 | 2.898 | 4.320 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2262.3 ± 1.2% | 2257.7 ± 1.1% | 1462.1 ± 1.7% | 594.9 ± 1.9% | 539.6 ± 0.8% | 577.1 ± 6.5% | 1.002 | 1.547 | 3.803 | 4.193 | 3.920 |
| qlog records, JSON text sequence | 1467503 | 2005.3 ± 1.4% | 1893.9 ± 20.9% | 1201.5 ± 40.2% | 590.4 ± 2.7% | 692.8 ± 1.7% | 464.8 ± 2.2% | 1.059 | 1.669 | 3.397 | 2.895 | 4.315 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1236.6 ± 1.2% | 2041.6 ± 1.1% | 1621.7 ± 2.0% | 518.8 ± 4.1% | 723.6 ± 2.1% | 463.2 ± 5.9% | 0.606 | 0.763 | 2.384 | 1.709 | 2.670 |
| qlog records, JSON text sequence | 1467503 | 1080.9 ± 1.1% | 1556.1 ± 0.8% | 1552.0 ± 2.0% | 440.4 ± 1.8% | 894.1 ± 1.4% | 461.0 ± 3.2% | 0.695 | 0.696 | 2.454 | 1.209 | 2.345 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1681.7 ± 0.7% | 2257.7 ± 1.1% | 1462.1 ± 1.7% | 594.9 ± 1.9% | 539.6 ± 0.8% | 577.1 ± 6.5% | 0.745 | 1.150 | 2.827 | 3.117 | 2.914 |
| qlog records, JSON text sequence | 1467503 | 1459.3 ± 0.7% | 1893.9 ± 20.9% | 1201.5 ± 40.2% | 590.4 ± 2.7% | 692.8 ± 1.7% | 464.8 ± 2.2% | 0.770 | 1.215 | 2.472 | 2.106 | 3.140 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.772 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.849 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.852 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.606 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.763 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.695 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.696 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.745 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.770 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1576.6 ± 2.4% | 0.540 | 0.979 | 1.014 | 1.004 | 0.401 | 1.024 | 0.998 | 0.397 | 0.848 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1290.8 ± 5.5% | 0.920 | 1.036 | 1.047 | 1.026 | 0.391 | 1.020 | 1.028 | 0.381 | 0.718 | 0.112 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2320.1 ± 1.2% | 0.425 | 0.941 | 0.960 | 0.995 | 0.993 | 0.262 | 0.998 | 0.464 | 0.735 | 0.083 | 0.995 |
| qlog records, JSON text sequence | 1467503 | 2012.6 ± 2.0% | 0.717 | 0.916 | 0.978 | 1.002 | 0.995 | 0.258 | 0.988 | 0.426 | 0.725 | 0.100 | 1.009 |

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
| CLDR supplemental, 34 texts | 920675 | 1576.6 ± 2.4% | 2025.6 ± 0.6% | 1624.6 ± 33.7% | 515.4 ± 2.2% | 803.1 ± 15.3% | 458.4 ± 2.4% | 0.778 | 0.970 | 3.059 | 1.963 | 3.439 |
| qlog records, JSON text sequence | 1467503 | 1290.8 ± 5.5% | 1577.0 ± 9.8% | 1569.8 ± 2.6% | 451.3 ± 1.4% | 937.1 ± 1.1% | 466.1 ± 23.8% | 0.819 | 0.822 | 2.860 | 1.377 | 2.770 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2320.1 ± 1.2% | 2263.4 ± 2.3% | 1453.5 ± 24.0% | 599.9 ± 2.4% | 628.2 ± 1.0% | 578.7 ± 2.2% | 1.025 | 1.596 | 3.867 | 3.693 | 4.009 |
| qlog records, JSON text sequence | 1467503 | 2012.6 ± 2.0% | 1884.8 ± 5.7% | 1198.2 ± 1.1% | 577.3 ± 0.7% | 695.5 ± 0.9% | 484.2 ± 3.3% | 1.068 | 1.680 | 3.486 | 2.894 | 4.156 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2308.9 ± 3.7% | 2263.4 ± 2.3% | 1453.5 ± 24.0% | 599.9 ± 2.4% | 628.2 ± 1.0% | 578.7 ± 2.2% | 1.020 | 1.589 | 3.849 | 3.676 | 3.990 |
| qlog records, JSON text sequence | 1467503 | 2030.5 ± 1.8% | 1884.8 ± 5.7% | 1198.2 ± 1.1% | 577.3 ± 0.7% | 695.5 ± 0.9% | 484.2 ± 3.3% | 1.077 | 1.695 | 3.517 | 2.919 | 4.193 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.6 ± 6.4% | 2025.6 ± 0.6% | 1624.6 ± 33.7% | 515.4 ± 2.2% | 803.1 ± 15.3% | 458.4 ± 2.4% | 0.660 | 0.823 | 2.595 | 1.666 | 2.918 |
| qlog records, JSON text sequence | 1467503 | 927.0 ± 1.0% | 1577.0 ± 9.8% | 1569.8 ± 2.6% | 451.3 ± 1.4% | 937.1 ± 1.1% | 466.1 ± 23.8% | 0.588 | 0.591 | 2.054 | 0.989 | 1.989 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1704.5 ± 1.9% | 2263.4 ± 2.3% | 1453.5 ± 24.0% | 599.9 ± 2.4% | 628.2 ± 1.0% | 578.7 ± 2.2% | 0.753 | 1.173 | 2.841 | 2.713 | 2.945 |
| qlog records, JSON text sequence | 1467503 | 1458.9 ± 2.0% | 1884.8 ± 5.7% | 1198.2 ± 1.1% | 577.3 ± 0.7% | 695.5 ± 0.9% | 484.2 ± 3.3% | 0.774 | 1.218 | 2.527 | 2.098 | 3.013 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.778 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.819 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.822 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.660 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.588 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.591 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.753 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.774 of simdjson.

# bench-json, CLDR and qlog alone: null, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1588.7 ± 2.0% | 0.527 | 0.981 | 1.013 | 1.011 | 0.395 | 1.013 | 1.007 | 0.391 | 0.829 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1316.4 ± 1.2% | 0.875 | 1.012 | 0.963 | 0.956 | 0.381 | 0.967 | 0.962 | 0.372 | 0.713 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2282.4 ± 28.8% | 0.448 | 0.954 | 0.967 | 1.002 | 0.987 | 0.268 | 0.989 | 0.471 | 0.738 | 0.085 | 1.000 |
| qlog records, JSON text sequence | 1467503 | 1721.3 ± 35.8% | 0.838 | 1.072 | 1.163 | 1.174 | 1.161 | 0.305 | 1.154 | 0.506 | 0.850 | 0.117 | 1.178 |

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
| CLDR supplemental, 34 texts | 920675 | 1588.7 ± 2.0% | 2007.3 ± 4.4% | 1636.5 ± 3.3% | 507.1 ± 6.8% | 805.4 ± 13.4% | 455.3 ± 71.0% | 0.791 | 0.971 | 3.133 | 1.972 | 3.489 |
| qlog records, JSON text sequence | 1467503 | 1316.4 ± 1.2% | 1571.2 ± 1.8% | 1524.6 ± 2.2% | 438.7 ± 4.6% | 926.9 ± 0.5% | 469.5 ± 13.0% | 0.838 | 0.863 | 3.001 | 1.420 | 2.804 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2282.4 ± 28.8% | 2236.5 ± 1.1% | 1468.3 ± 1.8% | 599.7 ± 4.2% | 626.5 ± 1.6% | 574.7 ± 21.1% | 1.021 | 1.554 | 3.806 | 3.643 | 3.972 |
| qlog records, JSON text sequence | 1467503 | 1721.3 ± 35.8% | 1845.4 ± 19.9% | 1194.6 ± 0.5% | 589.8 ± 1.5% | 688.3 ± 6.8% | 464.3 ± 23.4% | 0.933 | 1.441 | 2.918 | 2.501 | 3.707 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2283.2 ± 1.6% | 2236.5 ± 1.1% | 1468.3 ± 1.8% | 599.7 ± 4.2% | 626.5 ± 1.6% | 574.7 ± 21.1% | 1.021 | 1.555 | 3.807 | 3.644 | 3.973 |
| qlog records, JSON text sequence | 1467503 | 2027.3 ± 2.3% | 1845.4 ± 19.9% | 1194.6 ± 0.5% | 589.8 ± 1.5% | 688.3 ± 6.8% | 464.3 ± 23.4% | 1.099 | 1.697 | 3.437 | 2.945 | 4.366 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1316.4 ± 2.5% | 2007.3 ± 4.4% | 1636.5 ± 3.3% | 507.1 ± 6.8% | 805.4 ± 13.4% | 455.3 ± 71.0% | 0.656 | 0.804 | 2.596 | 1.634 | 2.891 |
| qlog records, JSON text sequence | 1467503 | 938.3 ± 0.8% | 1571.2 ± 1.8% | 1524.6 ± 2.2% | 438.7 ± 4.6% | 926.9 ± 0.5% | 469.5 ± 13.0% | 0.597 | 0.615 | 2.139 | 1.012 | 1.999 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1683.5 ± 1.6% | 2236.5 ± 1.1% | 1468.3 ± 1.8% | 599.7 ± 4.2% | 626.5 ± 1.6% | 574.7 ± 21.1% | 0.753 | 1.147 | 2.807 | 2.687 | 2.929 |
| qlog records, JSON text sequence | 1467503 | 1462.8 ± 2.9% | 1845.4 ± 19.9% | 1194.6 ± 0.5% | 589.8 ± 1.5% | 688.3 ± 6.8% | 464.3 ± 23.4% | 0.793 | 1.225 | 2.480 | 2.125 | 3.150 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.791 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.838 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.863 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.656 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.804 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.597 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.615 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.753 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.793 of simdjson.

# bench-json, CLDR and qlog alone: head, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1588.6 ± 10.6% | 0.529 | 0.977 | 1.015 | 1.013 | 0.395 | 1.014 | 1.012 | 0.391 | 0.780 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 1305.8 ± 21.4% | 0.880 | 1.012 | 0.985 | 0.983 | 0.379 | 0.981 | 0.971 | 0.373 | 0.828 | 0.112 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2297.2 ± 1.2% | 0.448 | 0.949 | 0.968 | 0.998 | 1.003 | 0.263 | 1.001 | 0.466 | 0.735 | 0.081 | 0.997 |
| qlog records, JSON text sequence | 1467503 | 2037.9 ± 1.3% | 0.714 | 0.906 | 0.982 | 0.995 | 0.989 | 0.256 | 0.988 | 0.425 | 0.718 | 0.099 | 0.993 |

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
| CLDR supplemental, 34 texts | 920675 | 1588.6 ± 10.6% | 2035.9 ± 1.8% | 1606.0 ± 1.7% | 519.3 ± 1.9% | 731.1 ± 2.2% | 457.5 ± 4.3% | 0.780 | 0.989 | 3.059 | 2.173 | 3.472 |
| qlog records, JSON text sequence | 1467503 | 1305.8 ± 21.4% | 1548.3 ± 1.8% | 1568.0 ± 0.8% | 443.1 ± 5.8% | 899.2 ± 1.2% | 453.2 ± 12.8% | 0.843 | 0.833 | 2.947 | 1.452 | 2.881 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2297.2 ± 1.2% | 2270.3 ± 2.5% | 1470.0 ± 1.3% | 594.0 ± 2.4% | 533.8 ± 9.6% | 579.8 ± 2.2% | 1.012 | 1.563 | 3.867 | 4.303 | 3.962 |
| qlog records, JSON text sequence | 1467503 | 2037.9 ± 1.3% | 1899.4 ± 5.4% | 1204.1 ± 2.9% | 588.1 ± 3.1% | 697.1 ± 0.9% | 469.0 ± 1.3% | 1.073 | 1.693 | 3.465 | 2.923 | 4.345 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2290.6 ± 0.9% | 2270.3 ± 2.5% | 1470.0 ± 1.3% | 594.0 ± 2.4% | 533.8 ± 9.6% | 579.8 ± 2.2% | 1.009 | 1.558 | 3.856 | 4.291 | 3.950 |
| qlog records, JSON text sequence | 1467503 | 2024.0 ± 1.2% | 1899.4 ± 5.4% | 1204.1 ± 2.9% | 588.1 ± 3.1% | 697.1 ± 0.9% | 469.0 ± 1.3% | 1.066 | 1.681 | 3.441 | 2.903 | 4.315 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1239.4 ± 1.0% | 2035.9 ± 1.8% | 1606.0 ± 1.7% | 519.3 ± 1.9% | 731.1 ± 2.2% | 457.5 ± 4.3% | 0.609 | 0.772 | 2.386 | 1.695 | 2.709 |
| qlog records, JSON text sequence | 1467503 | 1080.8 ± 2.3% | 1548.3 ± 1.8% | 1568.0 ± 0.8% | 443.1 ± 5.8% | 899.2 ± 1.2% | 453.2 ± 12.8% | 0.698 | 0.689 | 2.439 | 1.202 | 2.385 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1689.0 ± 1.8% | 2270.3 ± 2.5% | 1470.0 ± 1.3% | 594.0 ± 2.4% | 533.8 ± 9.6% | 579.8 ± 2.2% | 0.744 | 1.149 | 2.843 | 3.164 | 2.913 |
| qlog records, JSON text sequence | 1467503 | 1462.4 ± 0.9% | 1899.4 ± 5.4% | 1204.1 ± 2.9% | 588.1 ± 3.1% | 697.1 ± 0.9% | 469.0 ± 1.3% | 0.770 | 1.215 | 2.486 | 2.098 | 3.118 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.780 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.609 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.772 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.698 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.689 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.744 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.770 of simdjson.
