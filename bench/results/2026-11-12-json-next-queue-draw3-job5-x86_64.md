# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1641.5 ± 4.4% | 0.555 | 1.015 | 1.044 | 1.031 | 0.405 | 1.056 | 1.054 | 0.407 | 0.870 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 1356.6 ± 7.0% | 0.910 | 0.987 | 0.996 | 1.008 | 0.395 | 1.016 | 1.007 | 0.374 | 0.690 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2401.5 ± 4.9% | 0.444 | 0.916 | 0.944 | 0.968 | 0.964 | 0.260 | 0.977 | 0.457 | 0.725 | 0.080 | 0.983 |
| qlog records, JSON text sequence | 1467503 | 2064.2 ± 5.0% | 0.716 | 0.930 | 0.988 | 0.993 | 0.987 | 0.259 | 0.986 | 0.429 | 0.718 | 0.102 | 1.003 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.056 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.054 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1641.5 ± 4.4% | 2194.0 ± 2.9% | 1744.7 ± 6.6% | 547.1 ± 6.6% | 848.0 ± 4.8% | 490.6 ± 4.3% | 0.748 | 0.941 | 3.000 | 1.936 | 3.346 |
| qlog records, JSON text sequence | 1467503 | 1356.6 ± 7.0% | 1554.7 ± 9.8% | 1567.3 ± 7.2% | 456.5 ± 53.8% | 962.8 ± 5.2% | 480.3 ± 5.6% | 0.873 | 0.866 | 2.972 | 1.409 | 2.824 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2401.5 ± 4.9% | 2323.6 ± 5.1% | 1481.7 ± 3.4% | 618.0 ± 2.6% | 639.2 ± 7.0% | 598.5 ± 4.4% | 1.034 | 1.621 | 3.886 | 3.757 | 4.013 |
| qlog records, JSON text sequence | 1467503 | 2064.2 ± 5.0% | 1935.7 ± 2.3% | 1198.8 ± 7.6% | 581.9 ± 34.0% | 701.3 ± 22.9% | 493.8 ± 1.4% | 1.066 | 1.722 | 3.548 | 2.943 | 4.180 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2361.4 ± 9.6% | 2323.6 ± 5.1% | 1481.7 ± 3.4% | 618.0 ± 2.6% | 639.2 ± 7.0% | 598.5 ± 4.4% | 1.016 | 1.594 | 3.821 | 3.694 | 3.946 |
| qlog records, JSON text sequence | 1467503 | 2070.3 ± 3.1% | 1935.7 ± 2.3% | 1198.8 ± 7.6% | 581.9 ± 34.0% | 701.3 ± 22.9% | 493.8 ± 1.4% | 1.070 | 1.727 | 3.558 | 2.952 | 4.193 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1428.4 ± 6.9% | 2194.0 ± 2.9% | 1744.7 ± 6.6% | 547.1 ± 6.6% | 848.0 ± 4.8% | 490.6 ± 4.3% | 0.651 | 0.819 | 2.611 | 1.684 | 2.911 |
| qlog records, JSON text sequence | 1467503 | 935.6 ± 2.5% | 1554.7 ± 9.8% | 1567.3 ± 7.2% | 456.5 ± 53.8% | 962.8 ± 5.2% | 480.3 ± 5.6% | 0.602 | 0.597 | 2.050 | 0.972 | 1.948 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1742.2 ± 3.8% | 2323.6 ± 5.1% | 1481.7 ± 3.4% | 618.0 ± 2.6% | 639.2 ± 7.0% | 598.5 ± 4.4% | 0.750 | 1.176 | 2.819 | 2.726 | 2.911 |
| qlog records, JSON text sequence | 1467503 | 1482.9 ± 2.8% | 1935.7 ± 2.3% | 1198.8 ± 7.6% | 581.9 ± 34.0% | 701.3 ± 22.9% | 493.8 ± 1.4% | 0.766 | 1.237 | 2.549 | 2.115 | 3.003 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.748 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.873 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.866 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.651 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.819 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.602 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.597 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.750 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.766 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1643.3 ± 10.9% | 0.525 | 0.968 | 1.029 | 1.024 | 0.398 | 1.016 | 1.002 | 0.390 | 0.852 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 1396.8 ± 10.5% | 0.841 | 0.932 | 0.929 | 0.928 | 0.358 | 0.913 | 0.916 | 0.358 | 0.800 | 0.105 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2290.4 ± 2.3% | 0.449 | 0.950 | 0.975 | 1.001 | 1.001 | 0.269 | 1.010 | 0.468 | 0.741 | 0.081 | 0.995 |
| qlog records, JSON text sequence | 1467503 | 2012.8 ± 29.5% | 0.704 | 0.912 | 0.988 | 0.990 | 0.979 | 0.260 | 0.985 | 0.429 | 0.721 | 0.099 | 0.994 |

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
| CLDR supplemental, 34 texts | 920675 | 1643.3 ± 10.9% | 2088.6 ± 4.3% | 1700.8 ± 4.4% | 541.4 ± 4.8% | 774.9 ± 3.8% | 486.1 ± 6.1% | 0.787 | 0.966 | 3.035 | 2.121 | 3.381 |
| qlog records, JSON text sequence | 1467503 | 1396.8 ± 10.5% | 1521.4 ± 8.0% | 1531.2 ± 6.8% | 452.3 ± 6.4% | 895.9 ± 8.9% | 471.6 ± 8.9% | 0.918 | 0.912 | 3.088 | 1.559 | 2.962 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2290.4 ± 2.3% | 2269.5 ± 2.9% | 1468.2 ± 3.8% | 597.5 ± 12.6% | 540.8 ± 26.0% | 581.7 ± 26.0% | 1.009 | 1.560 | 3.833 | 4.235 | 3.937 |
| qlog records, JSON text sequence | 1467503 | 2012.8 ± 29.5% | 1867.3 ± 2.1% | 1198.5 ± 1.6% | 580.0 ± 7.4% | 689.2 ± 1.8% | 478.8 ± 9.3% | 1.078 | 1.679 | 3.471 | 2.921 | 4.203 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2279.7 ± 2.2% | 2269.5 ± 2.9% | 1468.2 ± 3.8% | 597.5 ± 12.6% | 540.8 ± 26.0% | 581.7 ± 26.0% | 1.005 | 1.553 | 3.815 | 4.215 | 3.919 |
| qlog records, JSON text sequence | 1467503 | 2001.7 ± 9.3% | 1867.3 ± 2.1% | 1198.5 ± 1.6% | 580.0 ± 7.4% | 689.2 ± 1.8% | 478.8 ± 9.3% | 1.072 | 1.670 | 3.451 | 2.905 | 4.180 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1400.3 ± 5.0% | 2088.6 ± 4.3% | 1700.8 ± 4.4% | 541.4 ± 4.8% | 774.9 ± 3.8% | 486.1 ± 6.1% | 0.670 | 0.823 | 2.586 | 1.807 | 2.881 |
| qlog records, JSON text sequence | 1467503 | 1117.6 ± 6.2% | 1521.4 ± 8.0% | 1531.2 ± 6.8% | 452.3 ± 6.4% | 895.9 ± 8.9% | 471.6 ± 8.9% | 0.735 | 0.730 | 2.471 | 1.247 | 2.370 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1696.0 ± 2.2% | 2269.5 ± 2.9% | 1468.2 ± 3.8% | 597.5 ± 12.6% | 540.8 ± 26.0% | 581.7 ± 26.0% | 0.747 | 1.155 | 2.838 | 3.136 | 2.916 |
| qlog records, JSON text sequence | 1467503 | 1451.3 ± 4.5% | 1867.3 ± 2.1% | 1198.5 ± 1.6% | 580.0 ± 7.4% | 689.2 ± 1.8% | 478.8 ± 9.3% | 0.777 | 1.211 | 2.502 | 2.106 | 3.031 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.787 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.670 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.823 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.735 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.730 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.747 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.777 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1610.1 ± 3.6% | 0.524 | 0.965 | 1.011 | 1.009 | 0.394 | 1.010 | 1.009 | 0.394 | 0.781 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1357.7 ± 9.1% | 0.864 | 1.004 | 0.970 | 0.969 | 0.378 | 0.965 | 0.967 | 0.372 | 0.816 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2299.2 ± 8.2% | 0.457 | 0.968 | 0.984 | 1.024 | 1.017 | 0.271 | 1.014 | 0.476 | 0.749 | 0.087 | 1.009 |
| qlog records, JSON text sequence | 1467503 | 2059.3 ± 2.0% | 0.723 | 0.917 | 0.995 | 0.998 | 0.994 | 0.259 | 0.993 | 0.433 | 0.726 | 0.099 | 1.008 |

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
| CLDR supplemental, 34 texts | 920675 | 1610.1 ± 3.6% | 2027.6 ± 10.2% | 1617.9 ± 6.1% | 520.6 ± 3.6% | 729.8 ± 3.6% | 461.8 ± 3.6% | 0.794 | 0.995 | 3.092 | 2.206 | 3.486 |
| qlog records, JSON text sequence | 1467503 | 1357.7 ± 9.1% | 1580.6 ± 6.4% | 1597.4 ± 7.4% | 454.1 ± 7.7% | 931.7 ± 6.0% | 480.0 ± 3.6% | 0.859 | 0.850 | 2.990 | 1.457 | 2.829 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2299.2 ± 8.2% | 2295.2 ± 2.3% | 1480.1 ± 3.5% | 614.6 ± 4.3% | 539.2 ± 9.4% | 591.0 ± 48.8% | 1.002 | 1.553 | 3.741 | 4.264 | 3.890 |
| qlog records, JSON text sequence | 1467503 | 2059.3 ± 2.0% | 1915.1 ± 1.3% | 1192.8 ± 1.4% | 588.1 ± 1.8% | 678.4 ± 42.7% | 478.7 ± 4.9% | 1.075 | 1.726 | 3.502 | 3.036 | 4.302 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2319.8 ± 1.8% | 2295.2 ± 2.3% | 1480.1 ± 3.5% | 614.6 ± 4.3% | 539.2 ± 9.4% | 591.0 ± 48.8% | 1.011 | 1.567 | 3.775 | 4.302 | 3.925 |
| qlog records, JSON text sequence | 1467503 | 2074.8 ± 4.5% | 1915.1 ± 1.3% | 1192.8 ± 1.4% | 588.1 ± 1.8% | 678.4 ± 42.7% | 478.7 ± 4.9% | 1.083 | 1.739 | 3.528 | 3.058 | 4.334 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1257.5 ± 3.0% | 2027.6 ± 10.2% | 1617.9 ± 6.1% | 520.6 ± 3.6% | 729.8 ± 3.6% | 461.8 ± 3.6% | 0.620 | 0.777 | 2.415 | 1.723 | 2.723 |
| qlog records, JSON text sequence | 1467503 | 1107.8 ± 10.3% | 1580.6 ± 6.4% | 1597.4 ± 7.4% | 454.1 ± 7.7% | 931.7 ± 6.0% | 480.0 ± 3.6% | 0.701 | 0.694 | 2.440 | 1.189 | 2.308 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1723.0 ± 3.2% | 2295.2 ± 2.3% | 1480.1 ± 3.5% | 614.6 ± 4.3% | 539.2 ± 9.4% | 591.0 ± 48.8% | 0.751 | 1.164 | 2.804 | 3.195 | 2.915 |
| qlog records, JSON text sequence | 1467503 | 1495.2 ± 1.3% | 1915.1 ± 1.3% | 1192.8 ± 1.4% | 588.1 ± 1.8% | 678.4 ± 42.7% | 478.7 ± 4.9% | 0.781 | 1.254 | 2.542 | 2.204 | 3.123 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.794 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.859 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.850 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.620 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.777 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.701 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.694 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.751 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.781 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1613.9 ± 4.5% | 0.545 | 0.986 | 1.021 | 0.998 | 0.402 | 1.025 | 0.999 | 0.397 | 0.850 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1327.0 ± 3.5% | 0.924 | 0.995 | 1.022 | 1.004 | 0.385 | 1.005 | 1.018 | 0.376 | 0.710 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2364.0 ± 3.4% | 0.437 | 0.934 | 0.935 | 0.992 | 0.987 | 0.257 | 0.986 | 0.455 | 0.723 | 0.081 | 0.981 |
| qlog records, JSON text sequence | 1467503 | 1998.3 ± 23.3% | 0.704 | 0.938 | 1.000 | 1.012 | 1.015 | 0.260 | 1.016 | 0.437 | 0.738 | 0.102 | 1.031 |

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
| CLDR supplemental, 34 texts | 920675 | 1613.9 ± 4.5% | 2062.5 ± 23.4% | 1654.4 ± 5.0% | 531.0 ± 4.5% | 831.7 ± 1.9% | 470.5 ± 9.6% | 0.783 | 0.976 | 3.039 | 1.940 | 3.430 |
| qlog records, JSON text sequence | 1467503 | 1327.0 ± 3.5% | 1529.4 ± 35.1% | 1566.2 ± 3.5% | 457.4 ± 1.1% | 955.0 ± 2.0% | 480.1 ± 4.7% | 0.868 | 0.847 | 2.901 | 1.390 | 2.764 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2364.0 ± 3.4% | 2305.7 ± 5.2% | 1480.0 ± 8.4% | 605.0 ± 6.0% | 630.1 ± 38.1% | 591.4 ± 15.5% | 1.025 | 1.597 | 3.907 | 3.752 | 3.997 |
| qlog records, JSON text sequence | 1467503 | 1998.3 ± 23.3% | 1907.8 ± 5.3% | 1224.2 ± 11.3% | 586.3 ± 5.2% | 705.2 ± 6.0% | 492.6 ± 4.0% | 1.047 | 1.632 | 3.408 | 2.834 | 4.057 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2318.2 ± 2.6% | 2305.7 ± 5.2% | 1480.0 ± 8.4% | 605.0 ± 6.0% | 630.1 ± 38.1% | 591.4 ± 15.5% | 1.005 | 1.566 | 3.832 | 3.679 | 3.920 |
| qlog records, JSON text sequence | 1467503 | 2060.5 ± 3.0% | 1907.8 ± 5.3% | 1224.2 ± 11.3% | 586.3 ± 5.2% | 705.2 ± 6.0% | 492.6 ± 4.0% | 1.080 | 1.683 | 3.515 | 2.922 | 4.183 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1371.2 ± 2.2% | 2062.5 ± 23.4% | 1654.4 ± 5.0% | 531.0 ± 4.5% | 831.7 ± 1.9% | 470.5 ± 9.6% | 0.665 | 0.829 | 2.582 | 1.649 | 2.914 |
| qlog records, JSON text sequence | 1467503 | 942.4 ± 17.4% | 1529.4 ± 35.1% | 1566.2 ± 3.5% | 457.4 ± 1.1% | 955.0 ± 2.0% | 480.1 ± 4.7% | 0.616 | 0.602 | 2.061 | 0.987 | 1.963 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1708.8 ± 2.4% | 2305.7 ± 5.2% | 1480.0 ± 8.4% | 605.0 ± 6.0% | 630.1 ± 38.1% | 591.4 ± 15.5% | 0.741 | 1.155 | 2.824 | 2.712 | 2.889 |
| qlog records, JSON text sequence | 1467503 | 1475.2 ± 6.8% | 1907.8 ± 5.3% | 1224.2 ± 11.3% | 586.3 ± 5.2% | 705.2 ± 6.0% | 492.6 ± 4.0% | 0.773 | 1.205 | 2.516 | 2.092 | 2.995 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.847 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.665 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.829 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.616 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.602 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.741 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.773 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1644.0 ± 5.1% | 0.517 | 0.962 | 1.000 | 1.005 | 0.386 | 0.992 | 0.995 | 0.389 | 0.845 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 1352.2 ± 13.4% | 0.878 | 1.013 | 0.984 | 0.969 | 0.373 | 0.966 | 0.963 | 0.371 | 0.851 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2379.2 ± 6.4% | 0.438 | 0.938 | 0.962 | 0.991 | 0.996 | 0.262 | 1.004 | 0.465 | 0.734 | 0.080 | 0.993 |
| qlog records, JSON text sequence | 1467503 | 2112.9 ± 8.6% | 0.713 | 0.908 | 0.982 | 0.979 | 0.987 | 0.238 | 0.960 | 0.421 | 0.713 | 0.098 | 0.994 |

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
| CLDR supplemental, 34 texts | 920675 | 1644.0 ± 5.1% | 2046.2 ± 4.2% | 1638.5 ± 5.3% | 532.5 ± 2.8% | 744.3 ± 1.8% | 470.1 ± 6.8% | 0.803 | 1.003 | 3.087 | 2.209 | 3.497 |
| qlog records, JSON text sequence | 1467503 | 1352.2 ± 13.4% | 1596.8 ± 9.7% | 1588.4 ± 7.6% | 459.7 ± 4.4% | 914.5 ± 3.4% | 474.9 ± 3.9% | 0.847 | 0.851 | 2.942 | 1.479 | 2.847 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2379.2 ± 6.4% | 2338.1 ± 7.3% | 1481.9 ± 6.2% | 623.3 ± 6.4% | 564.8 ± 5.4% | 595.6 ± 5.1% | 1.018 | 1.606 | 3.817 | 4.213 | 3.995 |
| qlog records, JSON text sequence | 1467503 | 2112.9 ± 8.6% | 1960.6 ± 10.4% | 1234.0 ± 18.9% | 590.3 ± 6.8% | 713.9 ± 9.9% | 505.3 ± 17.8% | 1.078 | 1.712 | 3.579 | 2.960 | 4.182 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2363.1 ± 3.1% | 2338.1 ± 7.3% | 1481.9 ± 6.2% | 623.3 ± 6.4% | 564.8 ± 5.4% | 595.6 ± 5.1% | 1.011 | 1.595 | 3.791 | 4.184 | 3.967 |
| qlog records, JSON text sequence | 1467503 | 2100.0 ± 12.5% | 1960.6 ± 10.4% | 1234.0 ± 18.9% | 590.3 ± 6.8% | 713.9 ± 9.9% | 505.3 ± 17.8% | 1.071 | 1.702 | 3.557 | 2.942 | 4.156 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1389.5 ± 4.0% | 2046.2 ± 4.2% | 1638.5 ± 5.3% | 532.5 ± 2.8% | 744.3 ± 1.8% | 470.1 ± 6.8% | 0.679 | 0.848 | 2.609 | 1.867 | 2.956 |
| qlog records, JSON text sequence | 1467503 | 1151.2 ± 6.0% | 1596.8 ± 9.7% | 1588.4 ± 7.6% | 459.7 ± 4.4% | 914.5 ± 3.4% | 474.9 ± 3.9% | 0.721 | 0.725 | 2.504 | 1.259 | 2.424 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1746.6 ± 3.6% | 2338.1 ± 7.3% | 1481.9 ± 6.2% | 623.3 ± 6.4% | 564.8 ± 5.4% | 595.6 ± 5.1% | 0.747 | 1.179 | 2.802 | 3.092 | 2.932 |
| qlog records, JSON text sequence | 1467503 | 1506.7 ± 9.7% | 1960.6 ± 10.4% | 1234.0 ± 18.9% | 590.3 ± 6.8% | 713.9 ± 9.9% | 505.3 ± 17.8% | 0.768 | 1.221 | 2.552 | 2.111 | 2.982 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.803 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.847 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.851 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.679 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.848 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.721 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.725 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.747 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.768 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1582.4 ± 6.3% | 0.508 | 0.975 | 1.022 | 1.031 | 0.404 | 0.986 | 0.992 | 0.394 | 0.788 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1313.5 ± 22.7% | 0.870 | 0.980 | 0.979 | 0.993 | 0.390 | 1.028 | 1.029 | 0.383 | 0.853 | 0.114 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2390.1 ± 6.3% | 0.449 | 0.953 | 0.951 | 0.996 | 1.007 | 0.266 | 0.997 | 0.471 | 0.725 | 0.084 | 0.979 |
| qlog records, JSON text sequence | 1467503 | 2093.6 ± 4.9% | 0.708 | 0.906 | 0.994 | 1.016 | 1.019 | 0.260 | 1.024 | 0.428 | 0.723 | 0.098 | 1.001 |

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
| CLDR supplemental, 34 texts | 920675 | 1582.4 ± 6.3% | 1972.0 ± 5.3% | 1622.4 ± 13.4% | 511.8 ± 44.8% | 728.7 ± 5.3% | 452.3 ± 6.7% | 0.802 | 0.975 | 3.092 | 2.171 | 3.499 |
| qlog records, JSON text sequence | 1467503 | 1313.5 ± 22.7% | 1624.4 ± 10.1% | 1672.0 ± 11.8% | 448.8 ± 5.1% | 917.0 ± 12.0% | 479.2 ± 27.2% | 0.809 | 0.786 | 2.927 | 1.432 | 2.741 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2390.1 ± 6.3% | 2320.6 ± 9.5% | 1509.9 ± 7.3% | 616.8 ± 7.7% | 561.5 ± 6.8% | 596.8 ± 8.8% | 1.030 | 1.583 | 3.875 | 4.257 | 4.005 |
| qlog records, JSON text sequence | 1467503 | 2093.6 ± 4.9% | 1862.3 ± 11.0% | 1225.6 ± 46.9% | 599.2 ± 6.5% | 705.2 ± 9.9% | 493.9 ± 3.9% | 1.124 | 1.708 | 3.494 | 2.969 | 4.239 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2341.1 ± 6.9% | 2320.6 ± 9.5% | 1509.9 ± 7.3% | 616.8 ± 7.7% | 561.5 ± 6.8% | 596.8 ± 8.8% | 1.009 | 1.551 | 3.796 | 4.169 | 3.923 |
| qlog records, JSON text sequence | 1467503 | 2095.6 ± 5.3% | 1862.3 ± 11.0% | 1225.6 ± 46.9% | 599.2 ± 6.5% | 705.2 ± 9.9% | 493.9 ± 3.9% | 1.125 | 1.710 | 3.497 | 2.972 | 4.243 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1246.5 ± 5.3% | 1972.0 ± 5.3% | 1622.4 ± 13.4% | 511.8 ± 44.8% | 728.7 ± 5.3% | 452.3 ± 6.7% | 0.632 | 0.768 | 2.436 | 1.711 | 2.756 |
| qlog records, JSON text sequence | 1467503 | 1119.8 ± 10.2% | 1624.4 ± 10.1% | 1672.0 ± 11.8% | 448.8 ± 5.1% | 917.0 ± 12.0% | 479.2 ± 27.2% | 0.689 | 0.670 | 2.495 | 1.221 | 2.337 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1733.4 ± 11.2% | 2320.6 ± 9.5% | 1509.9 ± 7.3% | 616.8 ± 7.7% | 561.5 ± 6.8% | 596.8 ± 8.8% | 0.747 | 1.148 | 2.811 | 3.087 | 2.905 |
| qlog records, JSON text sequence | 1467503 | 1514.6 ± 9.2% | 1862.3 ± 11.0% | 1225.6 ± 46.9% | 599.2 ± 6.5% | 705.2 ± 9.9% | 493.9 ± 3.9% | 0.813 | 1.236 | 2.528 | 2.148 | 3.067 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.802 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.632 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.768 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.689 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.670 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.747 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.813 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1628.2 ± 6.2% | 0.546 | 0.975 | 1.015 | 1.001 | 0.398 | 1.016 | 0.985 | 0.391 | 0.841 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 1339.7 ± 3.1% | 0.903 | 0.994 | 1.018 | 1.007 | 0.386 | 1.003 | 0.997 | 0.375 | 0.697 | 0.107 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2391.5 ± 2.2% | 0.440 | 0.932 | 0.952 | 0.988 | 0.988 | 0.257 | 0.971 | 0.461 | 0.729 | 0.081 | 0.977 |
| qlog records, JSON text sequence | 1467503 | 2068.0 ± 3.2% | 0.716 | 0.918 | 0.992 | 0.998 | 0.989 | 0.255 | 0.991 | 0.429 | 0.725 | 0.101 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1628.2 ± 6.2% | 2031.6 ± 7.2% | 1618.1 ± 9.4% | 528.9 ± 8.1% | 827.8 ± 5.2% | 471.4 ± 2.0% | 0.801 | 1.006 | 3.078 | 1.967 | 3.454 |
| qlog records, JSON text sequence | 1467503 | 1339.7 ± 3.1% | 1563.0 ± 43.5% | 1558.4 ± 80.2% | 456.2 ± 34.6% | 954.1 ± 1.5% | 464.9 ± 5.5% | 0.857 | 0.860 | 2.936 | 1.404 | 2.882 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2391.5 ± 2.2% | 2300.8 ± 13.4% | 1490.6 ± 49.5% | 610.0 ± 5.8% | 640.4 ± 5.3% | 591.4 ± 3.0% | 1.039 | 1.604 | 3.921 | 3.735 | 4.044 |
| qlog records, JSON text sequence | 1467503 | 2068.0 ± 3.2% | 1935.7 ± 12.7% | 1227.2 ± 50.9% | 596.3 ± 40.1% | 710.5 ± 2.1% | 495.3 ± 3.0% | 1.068 | 1.685 | 3.468 | 2.911 | 4.175 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2335.6 ± 9.7% | 2300.8 ± 13.4% | 1490.6 ± 49.5% | 610.0 ± 5.8% | 640.4 ± 5.3% | 591.4 ± 3.0% | 1.015 | 1.567 | 3.829 | 3.647 | 3.949 |
| qlog records, JSON text sequence | 1467503 | 2088.2 ± 2.5% | 1935.7 ± 12.7% | 1227.2 ± 50.9% | 596.3 ± 40.1% | 710.5 ± 2.1% | 495.3 ± 3.0% | 1.079 | 1.702 | 3.502 | 2.939 | 4.216 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1369.0 ± 5.8% | 2031.6 ± 7.2% | 1618.1 ± 9.4% | 528.9 ± 8.1% | 827.8 ± 5.2% | 471.4 ± 2.0% | 0.674 | 0.846 | 2.588 | 1.654 | 2.904 |
| qlog records, JSON text sequence | 1467503 | 934.1 ± 3.2% | 1563.0 ± 43.5% | 1558.4 ± 80.2% | 456.2 ± 34.6% | 954.1 ± 1.5% | 464.9 ± 5.5% | 0.598 | 0.599 | 2.047 | 0.979 | 2.009 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1742.8 ± 12.9% | 2300.8 ± 13.4% | 1490.6 ± 49.5% | 610.0 ± 5.8% | 640.4 ± 5.3% | 591.4 ± 3.0% | 0.757 | 1.169 | 2.857 | 2.721 | 2.947 |
| qlog records, JSON text sequence | 1467503 | 1499.1 ± 2.6% | 1935.7 ± 12.7% | 1227.2 ± 50.9% | 596.3 ± 40.1% | 710.5 ± 2.1% | 495.3 ± 3.0% | 0.774 | 1.222 | 2.514 | 2.110 | 3.027 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.801 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.674 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.846 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.757 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.774 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1632.1 ± 3.2% | 0.523 | 0.985 | 1.017 | 1.014 | 0.394 | 1.005 | 1.013 | 0.396 | 0.863 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1339.4 ± 4.2% | 0.867 | 1.014 | 0.970 | 0.974 | 0.382 | 0.975 | 0.967 | 0.374 | 0.847 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2348.7 ± 6.0% | 0.449 | 0.955 | 0.974 | 1.008 | 1.008 | 0.267 | 1.014 | 0.469 | 0.741 | 0.081 | 1.005 |
| qlog records, JSON text sequence | 1467503 | 2090.7 ± 3.1% | 0.715 | 0.907 | 0.979 | 0.972 | 0.986 | 0.253 | 0.979 | 0.422 | 0.708 | 0.096 | 0.976 |

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
| CLDR supplemental, 34 texts | 920675 | 1632.1 ± 3.2% | 2062.2 ± 3.5% | 1663.2 ± 4.6% | 531.2 ± 3.7% | 753.5 ± 4.2% | 477.1 ± 7.1% | 0.791 | 0.981 | 3.073 | 2.166 | 3.421 |
| qlog records, JSON text sequence | 1467503 | 1339.4 ± 4.2% | 1535.0 ± 77.2% | 1557.1 ± 8.6% | 453.2 ± 62.0% | 908.5 ± 15.1% | 468.2 ± 4.9% | 0.873 | 0.860 | 2.955 | 1.474 | 2.861 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2348.7 ± 6.0% | 2325.3 ± 1.8% | 1516.6 ± 4.6% | 616.2 ± 2.4% | 552.8 ± 4.7% | 595.7 ± 2.9% | 1.010 | 1.549 | 3.812 | 4.249 | 3.943 |
| qlog records, JSON text sequence | 1467503 | 2090.7 ± 3.1% | 1847.6 ± 8.7% | 1202.2 ± 2.3% | 590.5 ± 7.4% | 701.7 ± 35.7% | 489.2 ± 2.5% | 1.132 | 1.739 | 3.541 | 2.980 | 4.274 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2361.6 ± 2.4% | 2325.3 ± 1.8% | 1516.6 ± 4.6% | 616.2 ± 2.4% | 552.8 ± 4.7% | 595.7 ± 2.9% | 1.016 | 1.557 | 3.833 | 4.272 | 3.964 |
| qlog records, JSON text sequence | 1467503 | 2040.8 ± 4.1% | 1847.6 ± 8.7% | 1202.2 ± 2.3% | 590.5 ± 7.4% | 701.7 ± 35.7% | 489.2 ± 2.5% | 1.105 | 1.698 | 3.456 | 2.908 | 4.172 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1408.5 ± 2.3% | 2062.2 ± 3.5% | 1663.2 ± 4.6% | 531.2 ± 3.7% | 753.5 ± 4.2% | 477.1 ± 7.1% | 0.683 | 0.847 | 2.652 | 1.869 | 2.952 |
| qlog records, JSON text sequence | 1467503 | 1134.6 ± 262.5% | 1535.0 ± 77.2% | 1557.1 ± 8.6% | 453.2 ± 62.0% | 908.5 ± 15.1% | 468.2 ± 4.9% | 0.739 | 0.729 | 2.504 | 1.249 | 2.423 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1740.4 ± 2.8% | 2325.3 ± 1.8% | 1516.6 ± 4.6% | 616.2 ± 2.4% | 552.8 ± 4.7% | 595.7 ± 2.9% | 0.748 | 1.148 | 2.824 | 3.148 | 2.921 |
| qlog records, JSON text sequence | 1467503 | 1479.8 ± 1.7% | 1847.6 ± 8.7% | 1202.2 ± 2.3% | 590.5 ± 7.4% | 701.7 ± 35.7% | 489.2 ± 2.5% | 0.801 | 1.231 | 2.506 | 2.109 | 3.025 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.791 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.860 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.683 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.847 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.748 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.801 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1631.6 ± 2.8% | 0.524 | 0.985 | 1.014 | 1.013 | 0.395 | 1.013 | 1.012 | 0.393 | 0.779 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1335.1 ± 4.1% | 0.876 | 1.011 | 0.983 | 0.981 | 0.381 | 0.966 | 0.971 | 0.376 | 0.829 | 0.112 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2377.2 ± 50.2% | 0.445 | 0.947 | 0.966 | 1.012 | 1.002 | 0.266 | 1.001 | 0.460 | 0.729 | 0.085 | 0.995 |
| qlog records, JSON text sequence | 1467503 | 2070.5 ± 13.2% | 0.714 | 0.913 | 0.988 | 0.993 | 0.984 | 0.261 | 0.989 | 0.426 | 0.719 | 0.098 | 1.004 |

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
| CLDR supplemental, 34 texts | 920675 | 1631.6 ± 2.8% | 2098.0 ± 2.5% | 1690.5 ± 2.0% | 535.7 ± 1.1% | 747.9 ± 2.4% | 479.2 ± 5.4% | 0.778 | 0.965 | 3.046 | 2.182 | 3.405 |
| qlog records, JSON text sequence | 1467503 | 1335.1 ± 4.1% | 1592.0 ± 0.6% | 1620.5 ± 6.9% | 450.4 ± 1.9% | 916.6 ± 4.3% | 475.8 ± 7.5% | 0.839 | 0.824 | 2.964 | 1.457 | 2.806 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2377.2 ± 50.2% | 2350.9 ± 5.5% | 1516.8 ± 7.7% | 623.6 ± 15.9% | 554.1 ± 4.1% | 604.2 ± 51.6% | 1.011 | 1.567 | 3.812 | 4.290 | 3.934 |
| qlog records, JSON text sequence | 1467503 | 2070.5 ± 13.2% | 1943.1 ± 1.5% | 1219.5 ± 0.6% | 600.1 ± 2.3% | 704.3 ± 1.4% | 484.0 ± 2.6% | 1.066 | 1.698 | 3.450 | 2.940 | 4.278 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2364.4 ± 5.9% | 2350.9 ± 5.5% | 1516.8 ± 7.7% | 623.6 ± 15.9% | 554.1 ± 4.1% | 604.2 ± 51.6% | 1.006 | 1.559 | 3.792 | 4.267 | 3.913 |
| qlog records, JSON text sequence | 1467503 | 2079.1 ± 13.5% | 1943.1 ± 1.5% | 1219.5 ± 0.6% | 600.1 ± 2.3% | 704.3 ± 1.4% | 484.0 ± 2.6% | 1.070 | 1.705 | 3.465 | 2.952 | 4.296 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1271.1 ± 1.9% | 2098.0 ± 2.5% | 1690.5 ± 2.0% | 535.7 ± 1.1% | 747.9 ± 2.4% | 479.2 ± 5.4% | 0.606 | 0.752 | 2.373 | 1.700 | 2.653 |
| qlog records, JSON text sequence | 1467503 | 1106.4 ± 4.2% | 1592.0 ± 0.6% | 1620.5 ± 6.9% | 450.4 ± 1.9% | 916.6 ± 4.3% | 475.8 ± 7.5% | 0.695 | 0.683 | 2.456 | 1.207 | 2.325 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1733.9 ± 38.1% | 2350.9 ± 5.5% | 1516.8 ± 7.7% | 623.6 ± 15.9% | 554.1 ± 4.1% | 604.2 ± 51.6% | 0.738 | 1.143 | 2.781 | 3.129 | 2.870 |
| qlog records, JSON text sequence | 1467503 | 1489.7 ± 2.0% | 1943.1 ± 1.5% | 1219.5 ± 0.6% | 600.1 ± 2.3% | 704.3 ± 1.4% | 484.0 ± 2.6% | 0.767 | 1.222 | 2.483 | 2.115 | 3.078 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.778 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.839 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.824 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.606 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.752 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.695 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.683 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.767 of simdjson.
