# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1023.8 ± 3.7% | 0.478 | 0.991 | 1.052 | 1.036 | 0.411 | 1.046 | 1.013 | 0.360 | 0.792 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 705.6 ± 12.9% | 0.796 | 1.083 | 1.082 | 1.075 | 0.444 | 1.066 | 1.074 | 0.391 | 0.817 | 0.125 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.9 ± 1.2% | 0.443 | 0.978 | 0.972 | 1.004 | 0.998 | 0.233 | 0.995 | 0.445 | 0.721 | 0.086 | 1.016 |
| qlog records, JSON text sequence | 1467503 | 1154.7 ± 0.8% | 0.704 | 0.923 | 0.989 | 0.987 | 0.990 | 0.226 | 0.988 | 0.414 | 0.694 | 0.105 | 1.011 |

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
| CLDR supplemental, 34 texts | 920675 | 1023.8 ± 3.7% | 1004.6 ± 0.6% | 977.1 ± 1.0% | 259.7 ± 1.4% | 531.1 ± 12.0% | 258.0 ± 2.4% | 1.019 | 1.048 | 3.942 | 1.928 | 3.969 |
| qlog records, JSON text sequence | 1467503 | 705.6 ± 12.9% | 812.8 ± 0.3% | 812.0 ± 4.1% | 215.3 ± 4.8% | 561.0 ± 18.6% | 223.8 ± 10.7% | 0.868 | 0.869 | 3.277 | 1.258 | 3.152 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.9 ± 1.2% | 1135.3 ± 1.0% | 895.3 ± 0.6% | 319.5 ± 0.7% | 354.8 ± 0.7% | 312.8 ± 1.4% | 1.175 | 1.490 | 4.175 | 3.760 | 4.264 |
| qlog records, JSON text sequence | 1467503 | 1154.7 ± 0.8% | 867.5 ± 0.8% | 722.3 ± 1.6% | 315.9 ± 1.8% | 391.5 ± 1.7% | 232.4 ± 0.4% | 1.331 | 1.599 | 3.655 | 2.949 | 4.969 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1354.8 ± 0.5% | 1135.3 ± 1.0% | 895.3 ± 0.6% | 319.5 ± 0.7% | 354.8 ± 0.7% | 312.8 ± 1.4% | 1.193 | 1.513 | 4.241 | 3.819 | 4.331 |
| qlog records, JSON text sequence | 1467503 | 1167.4 ± 1.0% | 867.5 ± 0.8% | 722.3 ± 1.6% | 315.9 ± 1.8% | 391.5 ± 1.7% | 232.4 ± 0.4% | 1.346 | 1.616 | 3.695 | 2.981 | 5.024 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 810.7 ± 1.1% | 1004.6 ± 0.6% | 977.1 ± 1.0% | 259.7 ± 1.4% | 531.1 ± 12.0% | 258.0 ± 2.4% | 0.807 | 0.830 | 3.122 | 1.526 | 3.143 |
| qlog records, JSON text sequence | 1467503 | 576.3 ± 17.7% | 812.8 ± 0.3% | 812.0 ± 4.1% | 215.3 ± 4.8% | 561.0 ± 18.6% | 223.8 ± 10.7% | 0.709 | 0.710 | 2.676 | 1.027 | 2.575 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.9 ± 0.9% | 1135.3 ± 1.0% | 895.3 ± 0.6% | 319.5 ± 0.7% | 354.8 ± 0.7% | 312.8 ± 1.4% | 0.847 | 1.074 | 3.011 | 2.711 | 3.075 |
| qlog records, JSON text sequence | 1467503 | 801.3 ± 0.5% | 867.5 ± 0.8% | 722.3 ± 1.6% | 315.9 ± 1.8% | 391.5 ± 1.7% | 232.4 ± 0.4% | 0.924 | 1.109 | 2.537 | 2.046 | 3.448 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.868 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.869 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.807 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.830 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.709 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.710 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.847 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.924 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1009.5 ± 5.3% | 0.476 | 1.052 | 1.089 | 1.084 | 0.425 | 1.079 | 1.087 | 0.366 | 0.770 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 841.2 ± 0.4% | 0.733 | 1.026 | 1.007 | 1.002 | 0.389 | 1.010 | 1.004 | 0.344 | 0.789 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.0 ± 3.6% | 0.438 | 0.967 | 0.966 | 0.996 | 1.005 | 0.228 | 1.004 | 0.441 | 0.716 | 0.082 | 1.003 |
| qlog records, JSON text sequence | 1467503 | 1146.3 ± 4.7% | 0.696 | 0.954 | 0.995 | 0.996 | 0.997 | 0.224 | 0.991 | 0.418 | 0.702 | 0.099 | 1.024 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.089 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.084 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.079 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 1009.5 ± 5.3% | 995.1 ± 0.9% | 977.8 ± 0.2% | 258.4 ± 0.7% | 530.9 ± 3.1% | 255.4 ± 1.9% | 1.014 | 1.032 | 3.907 | 1.901 | 3.952 |
| qlog records, JSON text sequence | 1467503 | 841.2 ± 0.4% | 813.1 ± 0.3% | 813.6 ± 1.2% | 223.0 ± 1.5% | 588.6 ± 0.3% | 244.1 ± 2.7% | 1.035 | 1.034 | 3.773 | 1.429 | 3.446 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.0 ± 3.6% | 1118.4 ± 1.2% | 894.1 ± 1.1% | 330.5 ± 1.7% | 359.7 ± 4.6% | 311.8 ± 1.1% | 1.195 | 1.494 | 4.042 | 3.715 | 4.285 |
| qlog records, JSON text sequence | 1467503 | 1146.3 ± 4.7% | 862.7 ± 1.1% | 726.0 ± 0.8% | 320.0 ± 1.3% | 388.2 ± 2.3% | 232.5 ± 5.5% | 1.329 | 1.579 | 3.582 | 2.953 | 4.931 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.4 ± 2.2% | 1118.4 ± 1.2% | 894.1 ± 1.1% | 330.5 ± 1.7% | 359.7 ± 4.6% | 311.8 ± 1.1% | 1.198 | 1.498 | 4.053 | 3.724 | 4.296 |
| qlog records, JSON text sequence | 1467503 | 1174.0 ± 3.4% | 862.7 ± 1.1% | 726.0 ± 0.8% | 320.0 ± 1.3% | 388.2 ± 2.3% | 232.5 ± 5.5% | 1.361 | 1.617 | 3.669 | 3.024 | 5.050 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 777.1 ± 1.3% | 995.1 ± 0.9% | 977.8 ± 0.2% | 258.4 ± 0.7% | 530.9 ± 3.1% | 255.4 ± 1.9% | 0.781 | 0.795 | 3.007 | 1.464 | 3.042 |
| qlog records, JSON text sequence | 1467503 | 663.3 ± 2.2% | 813.1 ± 0.3% | 813.6 ± 1.2% | 223.0 ± 1.5% | 588.6 ± 0.3% | 244.1 ± 2.7% | 0.816 | 0.815 | 2.975 | 1.127 | 2.717 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 956.4 ± 2.3% | 1118.4 ± 1.2% | 894.1 ± 1.1% | 330.5 ± 1.7% | 359.7 ± 4.6% | 311.8 ± 1.1% | 0.855 | 1.070 | 2.894 | 2.659 | 3.068 |
| qlog records, JSON text sequence | 1467503 | 805.2 ± 7.1% | 862.7 ± 1.1% | 726.0 ± 0.8% | 320.0 ± 1.3% | 388.2 ± 2.3% | 232.5 ± 5.5% | 0.933 | 1.109 | 2.516 | 2.074 | 3.463 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.781 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.795 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.816 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.815 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.855 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 982.4 ± 1.5% | 0.489 | 1.086 | 1.118 | 1.118 | 0.437 | 1.106 | 1.122 | 0.376 | 0.820 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 807.6 ± 6.3% | 0.758 | 1.066 | 1.046 | 1.040 | 0.394 | 1.051 | 1.038 | 0.326 | 0.854 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.1 ± 0.3% | 0.437 | 0.974 | 0.969 | 0.998 | 1.009 | 0.228 | 1.005 | 0.439 | 0.713 | 0.085 | 1.010 |
| qlog records, JSON text sequence | 1467503 | 1150.2 ± 2.0% | 0.693 | 0.948 | 0.988 | 0.991 | 0.994 | 0.224 | 0.993 | 0.417 | 0.700 | 0.105 | 1.019 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J5 UTF-8 vectors off runs at 1.086 of all on.
- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.118 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.118 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.106 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.122 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.066 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 982.4 ± 1.5% | 1008.1 ± 0.2% | 978.2 ± 3.6% | 259.8 ± 2.1% | 530.0 ± 0.4% | 254.2 ± 2.0% | 0.974 | 1.004 | 3.782 | 1.854 | 3.865 |
| qlog records, JSON text sequence | 1467503 | 807.6 ± 6.3% | 803.4 ± 0.7% | 793.8 ± 4.6% | 219.5 ± 7.1% | 582.4 ± 9.6% | 236.5 ± 6.2% | 1.005 | 1.017 | 3.679 | 1.387 | 3.415 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.1 ± 0.3% | 1133.1 ± 1.8% | 895.3 ± 1.1% | 331.7 ± 1.7% | 352.8 ± 3.1% | 310.8 ± 4.6% | 1.179 | 1.492 | 4.028 | 3.787 | 4.299 |
| qlog records, JSON text sequence | 1467503 | 1150.2 ± 2.0% | 866.2 ± 1.0% | 713.5 ± 0.7% | 314.6 ± 6.1% | 387.1 ± 2.0% | 224.7 ± 2.0% | 1.328 | 1.612 | 3.656 | 2.971 | 5.119 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1350.2 ± 1.7% | 1133.1 ± 1.8% | 895.3 ± 1.1% | 331.7 ± 1.7% | 352.8 ± 3.1% | 310.8 ± 4.6% | 1.192 | 1.508 | 4.070 | 3.827 | 4.344 |
| qlog records, JSON text sequence | 1467503 | 1171.9 ± 0.4% | 866.2 ± 1.0% | 713.5 ± 0.7% | 314.6 ± 6.1% | 387.1 ± 2.0% | 224.7 ± 2.0% | 1.353 | 1.642 | 3.725 | 3.027 | 5.216 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 805.8 ± 1.0% | 1008.1 ± 0.2% | 978.2 ± 3.6% | 259.8 ± 2.1% | 530.0 ± 0.4% | 254.2 ± 2.0% | 0.799 | 0.824 | 3.102 | 1.520 | 3.170 |
| qlog records, JSON text sequence | 1467503 | 689.5 ± 16.0% | 803.4 ± 0.7% | 793.8 ± 4.6% | 219.5 ± 7.1% | 582.4 ± 9.6% | 236.5 ± 6.2% | 0.858 | 0.869 | 3.141 | 1.184 | 2.916 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 952.3 ± 1.8% | 1133.1 ± 1.8% | 895.3 ± 1.1% | 331.7 ± 1.7% | 352.8 ± 3.1% | 310.8 ± 4.6% | 0.840 | 1.064 | 2.871 | 2.699 | 3.064 |
| qlog records, JSON text sequence | 1467503 | 804.9 ± 0.4% | 866.2 ± 1.0% | 713.5 ± 0.7% | 314.6 ± 6.1% | 387.1 ± 2.0% | 224.7 ± 2.0% | 0.929 | 1.128 | 2.559 | 2.079 | 3.582 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.799 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.824 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.840 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.929 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1045.7 ± 3.3% | 0.469 | 0.990 | 1.015 | 0.996 | 0.331 | 0.993 | 0.988 | 0.353 | 0.780 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 842.2 ± 3.6% | 0.743 | 1.044 | 1.019 | 1.013 | 0.327 | 1.023 | 1.012 | 0.344 | 0.692 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.5 ± 5.1% | 0.443 | 0.979 | 0.979 | 1.003 | 1.004 | 0.235 | 0.994 | 0.446 | 0.725 | 0.086 | 1.021 |
| qlog records, JSON text sequence | 1467503 | 1158.4 ± 0.4% | 0.703 | 0.924 | 0.989 | 0.984 | 0.988 | 0.228 | 0.989 | 0.410 | 0.694 | 0.104 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1045.7 ± 3.3% | 1010.1 ± 0.2% | 980.4 ± 1.2% | 260.3 ± 0.3% | 531.4 ± 3.9% | 257.5 ± 2.8% | 1.035 | 1.067 | 4.018 | 1.968 | 4.060 |
| qlog records, JSON text sequence | 1467503 | 842.2 ± 3.6% | 812.2 ± 0.3% | 812.9 ± 1.6% | 220.2 ± 3.1% | 585.0 ± 2.2% | 238.0 ± 8.1% | 1.037 | 1.036 | 3.825 | 1.440 | 3.539 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.5 ± 5.1% | 1129.0 ± 0.8% | 897.8 ± 0.6% | 319.4 ± 2.1% | 355.2 ± 1.9% | 310.7 ± 2.7% | 1.180 | 1.484 | 4.172 | 3.751 | 4.289 |
| qlog records, JSON text sequence | 1467503 | 1158.4 ± 0.4% | 865.8 ± 0.6% | 383.3 ± 0.8% | 316.5 ± 0.8% | 387.9 ± 7.8% | 231.8 ± 1.6% | 1.338 | 3.022 | 3.661 | 2.987 | 4.998 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1360.7 ± 4.0% | 1129.0 ± 0.8% | 897.8 ± 0.6% | 319.4 ± 2.1% | 355.2 ± 1.9% | 310.7 ± 2.7% | 1.205 | 1.516 | 4.260 | 3.831 | 4.380 |
| qlog records, JSON text sequence | 1467503 | 1170.5 ± 0.3% | 865.8 ± 0.6% | 383.3 ± 0.8% | 316.5 ± 0.8% | 387.9 ± 7.8% | 231.8 ± 1.6% | 1.352 | 3.054 | 3.699 | 3.018 | 5.051 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 816.1 ± 0.4% | 1010.1 ± 0.2% | 980.4 ± 1.2% | 260.3 ± 0.3% | 531.4 ± 3.9% | 257.5 ± 2.8% | 0.808 | 0.832 | 3.136 | 1.536 | 3.169 |
| qlog records, JSON text sequence | 1467503 | 582.8 ± 0.3% | 812.2 ± 0.3% | 812.9 ± 1.6% | 220.2 ± 3.1% | 585.0 ± 2.2% | 238.0 ± 8.1% | 0.718 | 0.717 | 2.647 | 0.996 | 2.449 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 965.6 ± 1.1% | 1129.0 ± 0.8% | 897.8 ± 0.6% | 319.4 ± 2.1% | 355.2 ± 1.9% | 310.7 ± 2.7% | 0.855 | 1.076 | 3.023 | 2.718 | 3.108 |
| qlog records, JSON text sequence | 1467503 | 803.6 ± 0.5% | 865.8 ± 0.6% | 383.3 ± 0.8% | 316.5 ± 0.8% | 387.9 ± 7.8% | 231.8 ± 1.6% | 0.928 | 2.097 | 2.540 | 2.072 | 3.468 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.808 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.832 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.718 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.717 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.855 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.928 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1030.1 ± 2.4% | 0.467 | 1.023 | 1.064 | 1.062 | 0.418 | 1.052 | 1.062 | 0.359 | 0.753 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 779.0 ± 7.8% | 0.785 | 1.099 | 1.081 | 1.077 | 0.413 | 1.082 | 1.075 | 0.337 | 0.799 | 0.115 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1327.9 ± 4.7% | 0.439 | 0.974 | 0.972 | 0.998 | 1.019 | 0.229 | 1.015 | 0.442 | 0.721 | 0.082 | 1.028 |
| qlog records, JSON text sequence | 1467503 | 1157.5 ± 0.8% | 0.691 | 0.948 | 0.986 | 0.986 | 0.989 | 0.221 | 0.988 | 0.409 | 0.696 | 0.097 | 1.015 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.064 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.062 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.052 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.062 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.099 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.081 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.082 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1030.1 ± 2.4% | 1027.0 ± 0.6% | 979.0 ± 3.1% | 258.5 ± 4.0% | 531.9 ± 0.8% | 255.2 ± 1.9% | 1.003 | 1.052 | 3.986 | 1.937 | 4.036 |
| qlog records, JSON text sequence | 1467503 | 779.0 ± 7.8% | 811.5 ± 1.3% | 775.9 ± 3.1% | 211.3 ± 6.7% | 550.3 ± 10.6% | 228.7 ± 6.0% | 0.960 | 1.004 | 3.687 | 1.416 | 3.406 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1327.9 ± 4.7% | 1121.9 ± 0.6% | 889.6 ± 5.3% | 331.3 ± 0.6% | 350.5 ± 5.3% | 309.9 ± 0.9% | 1.184 | 1.493 | 4.009 | 3.789 | 4.285 |
| qlog records, JSON text sequence | 1467503 | 1157.5 ± 0.8% | 863.5 ± 1.2% | 726.1 ± 1.7% | 321.0 ± 1.5% | 388.2 ± 0.6% | 231.8 ± 0.9% | 1.340 | 1.594 | 3.606 | 2.982 | 4.992 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1365.0 ± 5.3% | 1121.9 ± 0.6% | 889.6 ± 5.3% | 331.3 ± 0.6% | 350.5 ± 5.3% | 309.9 ± 0.9% | 1.217 | 1.535 | 4.121 | 3.895 | 4.404 |
| qlog records, JSON text sequence | 1467503 | 1174.5 ± 1.6% | 863.5 ± 1.2% | 726.1 ± 1.7% | 321.0 ± 1.5% | 388.2 ± 0.6% | 231.8 ± 0.9% | 1.360 | 1.618 | 3.659 | 3.025 | 5.066 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 775.5 ± 0.9% | 1027.0 ± 0.6% | 979.0 ± 3.1% | 258.5 ± 4.0% | 531.9 ± 0.8% | 255.2 ± 1.9% | 0.755 | 0.792 | 3.001 | 1.458 | 3.038 |
| qlog records, JSON text sequence | 1467503 | 622.6 ± 22.4% | 811.5 ± 1.3% | 775.9 ± 3.1% | 211.3 ± 6.7% | 550.3 ± 10.6% | 228.7 ± 6.0% | 0.767 | 0.802 | 2.947 | 1.131 | 2.723 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 957.5 ± 0.5% | 1121.9 ± 0.6% | 889.6 ± 5.3% | 331.3 ± 0.6% | 350.5 ± 5.3% | 309.9 ± 0.9% | 0.853 | 1.076 | 2.890 | 2.732 | 3.089 |
| qlog records, JSON text sequence | 1467503 | 805.1 ± 0.6% | 863.5 ± 1.2% | 726.1 ± 1.7% | 321.0 ± 1.5% | 388.2 ± 0.6% | 231.8 ± 0.9% | 0.932 | 1.109 | 2.508 | 2.074 | 3.473 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.755 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.792 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.767 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.853 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.932 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1036.7 ± 4.0% | 0.460 | 1.010 | 1.050 | 1.050 | 0.411 | 1.032 | 1.049 | 0.356 | 0.779 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 834.8 ± 5.7% | 0.737 | 1.028 | 1.010 | 1.007 | 0.389 | 1.018 | 1.011 | 0.340 | 0.893 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1343.6 ± 0.6% | 0.435 | 0.968 | 0.965 | 0.993 | 1.008 | 0.227 | 1.002 | 0.440 | 0.714 | 0.085 | 1.004 |
| qlog records, JSON text sequence | 1467503 | 1140.3 ± 2.2% | 0.696 | 0.940 | 0.998 | 0.996 | 1.000 | 0.224 | 0.988 | 0.416 | 0.699 | 0.106 | 1.012 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.050 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1036.7 ± 4.0% | 989.9 ± 4.7% | 968.5 ± 0.3% | 258.9 ± 0.8% | 530.5 ± 0.6% | 256.4 ± 2.9% | 1.047 | 1.070 | 4.004 | 1.954 | 4.043 |
| qlog records, JSON text sequence | 1467503 | 834.8 ± 5.7% | 796.3 ± 0.1% | 772.9 ± 3.9% | 218.7 ± 3.4% | 583.3 ± 3.7% | 239.6 ± 9.6% | 1.048 | 1.080 | 3.818 | 1.431 | 3.484 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1343.6 ± 0.6% | 1131.4 ± 2.5% | 896.4 ± 0.6% | 333.0 ± 0.7% | 361.6 ± 2.2% | 312.1 ± 0.8% | 1.188 | 1.499 | 4.035 | 3.715 | 4.305 |
| qlog records, JSON text sequence | 1467503 | 1140.3 ± 2.2% | 858.5 ± 0.9% | 708.3 ± 7.2% | 313.0 ± 6.7% | 383.1 ± 1.0% | 228.4 ± 2.8% | 1.328 | 1.610 | 3.643 | 2.976 | 4.992 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1348.8 ± 0.8% | 1131.4 ± 2.5% | 896.4 ± 0.6% | 333.0 ± 0.7% | 361.6 ± 2.2% | 312.1 ± 0.8% | 1.192 | 1.505 | 4.050 | 3.730 | 4.322 |
| qlog records, JSON text sequence | 1467503 | 1153.9 ± 8.3% | 858.5 ± 0.9% | 708.3 ± 7.2% | 313.0 ± 6.7% | 383.1 ± 1.0% | 228.4 ± 2.8% | 1.344 | 1.629 | 3.686 | 3.012 | 5.051 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 807.6 ± 1.9% | 989.9 ± 4.7% | 968.5 ± 0.3% | 258.9 ± 0.8% | 530.5 ± 0.6% | 256.4 ± 2.9% | 0.816 | 0.834 | 3.119 | 1.522 | 3.150 |
| qlog records, JSON text sequence | 1467503 | 745.7 ± 4.5% | 796.3 ± 0.1% | 772.9 ± 3.9% | 218.7 ± 3.4% | 583.3 ± 3.7% | 239.6 ± 9.6% | 0.936 | 0.965 | 3.410 | 1.278 | 3.112 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 959.5 ± 0.8% | 1131.4 ± 2.5% | 896.4 ± 0.6% | 333.0 ± 0.7% | 361.6 ± 2.2% | 312.1 ± 0.8% | 0.848 | 1.070 | 2.881 | 2.653 | 3.074 |
| qlog records, JSON text sequence | 1467503 | 797.0 ± 1.1% | 858.5 ± 0.9% | 708.3 ± 7.2% | 313.0 ± 6.7% | 383.1 ± 1.0% | 228.4 ± 2.8% | 0.928 | 1.125 | 2.546 | 2.080 | 3.489 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.816 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.834 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.936 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.848 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.928 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1037.9 ± 3.2% | 0.472 | 0.983 | 1.024 | 1.029 | 0.406 | 1.040 | 0.992 | 0.356 | 0.785 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 813.8 ± 10.4% | 0.767 | 1.074 | 1.059 | 1.039 | 0.403 | 1.053 | 1.041 | 0.340 | 0.703 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1326.7 ± 1.3% | 0.444 | 0.985 | 0.986 | 1.004 | 1.008 | 0.236 | 0.988 | 0.447 | 0.723 | 0.086 | 1.024 |
| qlog records, JSON text sequence | 1467503 | 1157.7 ± 2.9% | 0.703 | 0.923 | 0.990 | 0.985 | 0.987 | 0.228 | 0.990 | 0.411 | 0.693 | 0.104 | 1.014 |

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
| CLDR supplemental, 34 texts | 920675 | 1037.9 ± 3.2% | 1008.3 ± 0.8% | 975.4 ± 0.9% | 259.9 ± 7.1% | 530.6 ± 0.3% | 256.9 ± 3.6% | 1.029 | 1.064 | 3.993 | 1.956 | 4.041 |
| qlog records, JSON text sequence | 1467503 | 813.8 ± 10.4% | 811.2 ± 0.4% | 778.9 ± 2.3% | 211.4 ± 7.5% | 536.4 ± 14.0% | 222.2 ± 7.6% | 1.003 | 1.045 | 3.850 | 1.517 | 3.662 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1326.7 ± 1.3% | 1131.8 ± 1.6% | 889.1 ± 5.2% | 320.6 ± 1.0% | 356.0 ± 1.9% | 313.8 ± 1.3% | 1.172 | 1.492 | 4.138 | 3.726 | 4.228 |
| qlog records, JSON text sequence | 1467503 | 1157.7 ± 2.9% | 868.0 ± 0.5% | 722.1 ± 0.6% | 315.6 ± 1.7% | 390.4 ± 7.4% | 232.2 ± 1.0% | 1.334 | 1.603 | 3.668 | 2.965 | 4.986 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1358.5 ± 4.0% | 1131.8 ± 1.6% | 889.1 ± 5.2% | 320.6 ± 1.0% | 356.0 ± 1.9% | 313.8 ± 1.3% | 1.200 | 1.528 | 4.237 | 3.816 | 4.330 |
| qlog records, JSON text sequence | 1467503 | 1173.4 ± 0.5% | 868.0 ± 0.5% | 722.1 ± 0.6% | 315.6 ± 1.7% | 390.4 ± 7.4% | 232.2 ± 1.0% | 1.352 | 1.625 | 3.718 | 3.006 | 5.054 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 814.6 ± 4.2% | 1008.3 ± 0.8% | 975.4 ± 0.9% | 259.9 ± 7.1% | 530.6 ± 0.3% | 256.9 ± 3.6% | 0.808 | 0.835 | 3.134 | 1.535 | 3.172 |
| qlog records, JSON text sequence | 1467503 | 571.8 ± 6.7% | 811.2 ± 0.4% | 778.9 ± 2.3% | 211.4 ± 7.5% | 536.4 ± 14.0% | 222.2 ± 7.6% | 0.705 | 0.734 | 2.705 | 1.066 | 2.573 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 958.6 ± 1.0% | 1131.8 ± 1.6% | 889.1 ± 5.2% | 320.6 ± 1.0% | 356.0 ± 1.9% | 313.8 ± 1.3% | 0.847 | 1.078 | 2.990 | 2.692 | 3.055 |
| qlog records, JSON text sequence | 1467503 | 802.7 ± 0.2% | 868.0 ± 0.5% | 722.1 ± 0.6% | 315.6 ± 1.7% | 390.4 ± 7.4% | 232.2 ± 1.0% | 0.925 | 1.112 | 2.543 | 2.056 | 3.457 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.808 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.835 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.705 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.734 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.847 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.925 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 985.0 ± 0.7% | 0.483 | 1.072 | 1.109 | 1.107 | 0.432 | 1.096 | 1.104 | 0.375 | 0.789 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 841.0 ± 0.9% | 0.733 | 1.027 | 1.004 | 1.003 | 0.387 | 1.011 | 1.003 | 0.343 | 0.788 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.8 ± 0.9% | 0.437 | 0.977 | 0.971 | 0.998 | 1.011 | 0.228 | 1.012 | 0.441 | 0.718 | 0.082 | 1.019 |
| qlog records, JSON text sequence | 1467503 | 1141.3 ± 2.1% | 0.695 | 0.945 | 0.999 | 0.997 | 1.001 | 0.225 | 0.999 | 0.419 | 0.707 | 0.099 | 1.029 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J5 UTF-8 vectors off runs at 1.072 of all on.
- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.109 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.107 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.096 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.104 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 985.0 ± 0.7% | 997.4 ± 0.3% | 963.3 ± 0.6% | 258.5 ± 1.2% | 530.4 ± 3.5% | 257.3 ± 3.4% | 0.988 | 1.023 | 3.811 | 1.857 | 3.828 |
| qlog records, JSON text sequence | 1467503 | 841.0 ± 0.9% | 799.5 ± 0.3% | 805.4 ± 5.9% | 223.1 ± 1.0% | 587.9 ± 0.5% | 244.0 ± 1.6% | 1.052 | 1.044 | 3.769 | 1.430 | 3.446 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.8 ± 0.9% | 1126.0 ± 1.0% | 889.7 ± 1.4% | 331.6 ± 1.0% | 358.8 ± 3.6% | 310.3 ± 1.3% | 1.185 | 1.500 | 4.026 | 3.720 | 4.302 |
| qlog records, JSON text sequence | 1467503 | 1141.3 ± 2.1% | 860.3 ± 0.6% | 715.1 ± 1.3% | 311.3 ± 5.8% | 377.1 ± 6.6% | 225.4 ± 1.8% | 1.327 | 1.596 | 3.666 | 3.026 | 5.064 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1360.3 ± 1.0% | 1126.0 ± 1.0% | 889.7 ± 1.4% | 331.6 ± 1.0% | 358.8 ± 3.6% | 310.3 ± 1.3% | 1.208 | 1.529 | 4.103 | 3.791 | 4.384 |
| qlog records, JSON text sequence | 1467503 | 1174.3 ± 0.5% | 860.3 ± 0.6% | 715.1 ± 1.3% | 311.3 ± 5.8% | 377.1 ± 6.6% | 225.4 ± 1.8% | 1.365 | 1.642 | 3.772 | 3.114 | 5.211 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 777.4 ± 1.3% | 997.4 ± 0.3% | 963.3 ± 0.6% | 258.5 ± 1.2% | 530.4 ± 3.5% | 257.3 ± 3.4% | 0.779 | 0.807 | 3.008 | 1.466 | 3.021 |
| qlog records, JSON text sequence | 1467503 | 663.1 ± 2.8% | 799.5 ± 0.3% | 805.4 ± 5.9% | 223.1 ± 1.0% | 587.9 ± 0.5% | 244.0 ± 1.6% | 0.829 | 0.823 | 2.972 | 1.128 | 2.717 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 958.1 ± 0.9% | 1126.0 ± 1.0% | 889.7 ± 1.4% | 331.6 ± 1.0% | 358.8 ± 3.6% | 310.3 ± 1.3% | 0.851 | 1.077 | 2.890 | 2.670 | 3.088 |
| qlog records, JSON text sequence | 1467503 | 806.6 ± 0.5% | 860.3 ± 0.6% | 715.1 ± 1.3% | 311.3 ± 5.8% | 377.1 ± 6.6% | 225.4 ± 1.8% | 0.938 | 1.128 | 2.591 | 2.139 | 3.579 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.779 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.807 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.829 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.823 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.851 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.938 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1012.2 ± 6.3% | 0.475 | 1.051 | 1.079 | 1.078 | 0.423 | 1.070 | 1.079 | 0.365 | 0.790 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 836.9 ± 0.6% | 0.736 | 1.026 | 1.005 | 1.002 | 0.390 | 1.018 | 1.006 | 0.338 | 0.892 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.8 ± 4.4% | 0.438 | 0.975 | 0.973 | 0.996 | 1.007 | 0.229 | 1.008 | 0.442 | 0.720 | 0.086 | 1.020 |
| qlog records, JSON text sequence | 1467503 | 1146.4 ± 2.6% | 0.692 | 0.942 | 0.987 | 0.994 | 0.987 | 0.224 | 0.985 | 0.416 | 0.697 | 0.105 | 1.009 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.079 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.078 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.070 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 1012.2 ± 6.3% | 1021.8 ± 0.4% | 980.6 ± 2.5% | 258.1 ± 1.7% | 531.4 ± 0.6% | 258.6 ± 2.8% | 0.991 | 1.032 | 3.921 | 1.905 | 3.915 |
| qlog records, JSON text sequence | 1467503 | 836.9 ± 0.6% | 763.1 ± 4.1% | 809.3 ± 3.2% | 221.1 ± 1.1% | 587.1 ± 0.3% | 243.9 ± 6.7% | 1.097 | 1.034 | 3.786 | 1.425 | 3.431 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.8 ± 4.4% | 1136.2 ± 7.1% | 898.2 ± 0.5% | 333.1 ± 0.8% | 359.0 ± 5.6% | 312.2 ± 0.6% | 1.173 | 1.484 | 4.002 | 3.712 | 4.269 |
| qlog records, JSON text sequence | 1467503 | 1146.4 ± 2.6% | 860.3 ± 0.4% | 717.5 ± 5.0% | 319.1 ± 3.4% | 390.7 ± 1.2% | 228.2 ± 1.2% | 1.333 | 1.598 | 3.593 | 2.934 | 5.023 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1359.0 ± 4.8% | 1136.2 ± 7.1% | 898.2 ± 0.5% | 333.1 ± 0.8% | 359.0 ± 5.6% | 312.2 ± 0.6% | 1.196 | 1.513 | 4.080 | 3.785 | 4.353 |
| qlog records, JSON text sequence | 1467503 | 1156.9 ± 0.5% | 860.3 ± 0.4% | 717.5 ± 5.0% | 319.1 ± 3.4% | 390.7 ± 1.2% | 228.2 ± 1.2% | 1.345 | 1.612 | 3.626 | 2.961 | 5.069 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 799.4 ± 1.1% | 1021.8 ± 0.4% | 980.6 ± 2.5% | 258.1 ± 1.7% | 531.4 ± 0.6% | 258.6 ± 2.8% | 0.782 | 0.815 | 3.097 | 1.504 | 3.091 |
| qlog records, JSON text sequence | 1467503 | 746.9 ± 1.2% | 763.1 ± 4.1% | 809.3 ± 3.2% | 221.1 ± 1.1% | 587.1 ± 0.3% | 243.9 ± 6.7% | 0.979 | 0.923 | 3.379 | 1.272 | 3.062 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 959.3 ± 0.8% | 1136.2 ± 7.1% | 898.2 ± 0.5% | 333.1 ± 0.8% | 359.0 ± 5.6% | 312.2 ± 0.6% | 0.844 | 1.068 | 2.880 | 2.672 | 3.073 |
| qlog records, JSON text sequence | 1467503 | 799.4 ± 0.6% | 860.3 ± 0.4% | 717.5 ± 5.0% | 319.1 ± 3.4% | 390.7 ± 1.2% | 228.2 ± 1.2% | 0.929 | 1.114 | 2.505 | 2.046 | 3.503 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.782 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.815 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.923 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.844 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.929 of simdjson.
