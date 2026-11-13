# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 999.7 ± 6.2% | 0.483 | 1.028 | 1.025 | 1.060 | 0.421 | 1.059 | 1.039 | 0.370 | 0.809 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 849.5 ± 0.8% | 0.737 | 1.035 | 1.015 | 0.996 | 0.391 | 1.015 | 1.002 | 0.338 | 0.681 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.2 ± 0.9% | 0.443 | 0.982 | 0.978 | 1.001 | 0.999 | 0.236 | 1.000 | 0.445 | 0.721 | 0.086 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1155.4 ± 0.4% | 0.704 | 0.919 | 0.987 | 0.977 | 0.979 | 0.228 | 0.978 | 0.409 | 0.688 | 0.103 | 1.003 |

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
| CLDR supplemental, 34 texts | 920675 | 999.7 ± 6.2% | 1003.8 ± 1.1% | 970.5 ± 3.1% | 259.3 ± 0.6% | 530.8 ± 3.4% | 253.0 ± 1.8% | 0.996 | 1.030 | 3.855 | 1.883 | 3.951 |
| qlog records, JSON text sequence | 1467503 | 849.5 ± 0.8% | 809.5 ± 0.9% | 811.0 ± 2.2% | 214.0 ± 4.1% | 587.5 ± 3.6% | 238.6 ± 1.8% | 1.049 | 1.047 | 3.969 | 1.446 | 3.560 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.2 ± 0.9% | 1137.8 ± 4.7% | 894.8 ± 0.5% | 320.3 ± 1.6% | 357.3 ± 0.6% | 312.8 ± 1.0% | 1.174 | 1.492 | 4.168 | 3.737 | 4.269 |
| qlog records, JSON text sequence | 1467503 | 1155.4 ± 0.4% | 861.3 ± 1.8% | 715.0 ± 1.1% | 313.6 ± 2.2% | 386.7 ± 1.5% | 228.8 ± 4.5% | 1.342 | 1.616 | 3.684 | 2.988 | 5.050 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1364.0 ± 1.5% | 1137.8 ± 4.7% | 894.8 ± 0.5% | 320.3 ± 1.6% | 357.3 ± 0.6% | 312.8 ± 1.0% | 1.199 | 1.524 | 4.258 | 3.818 | 4.361 |
| qlog records, JSON text sequence | 1467503 | 1159.3 ± 1.4% | 861.3 ± 1.8% | 715.0 ± 1.1% | 313.6 ± 2.2% | 386.7 ± 1.5% | 228.8 ± 4.5% | 1.346 | 1.621 | 3.696 | 2.998 | 5.067 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 808.8 ± 5.1% | 1003.8 ± 1.1% | 970.5 ± 3.1% | 259.3 ± 0.6% | 530.8 ± 3.4% | 253.0 ± 1.8% | 0.806 | 0.833 | 3.119 | 1.524 | 3.197 |
| qlog records, JSON text sequence | 1467503 | 578.7 ± 1.2% | 809.5 ± 0.9% | 811.0 ± 2.2% | 214.0 ± 4.1% | 587.5 ± 3.6% | 238.6 ± 1.8% | 0.715 | 0.714 | 2.704 | 0.985 | 2.425 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 962.1 ± 1.2% | 1137.8 ± 4.7% | 894.8 ± 0.5% | 320.3 ± 1.6% | 357.3 ± 0.6% | 312.8 ± 1.0% | 0.846 | 1.075 | 3.003 | 2.693 | 3.076 |
| qlog records, JSON text sequence | 1467503 | 794.4 ± 0.7% | 861.3 ± 1.8% | 715.0 ± 1.1% | 313.6 ± 2.2% | 386.7 ± 1.5% | 228.8 ± 4.5% | 0.922 | 1.111 | 2.533 | 2.054 | 3.472 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.806 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.833 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.715 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.714 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.846 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.922 of simdjson.

# bench-json, CLDR and qlog alone: null, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1020.5 ± 4.9% | 0.467 | 0.989 | 1.065 | 1.070 | 0.420 | 1.057 | 1.066 | 0.363 | 0.757 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 831.9 ± 0.3% | 0.740 | 1.035 | 1.020 | 1.001 | 0.397 | 1.027 | 0.998 | 0.348 | 0.674 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.0 ± 1.2% | 0.405 | 0.976 | 0.969 | 1.013 | 1.003 | 0.230 | 1.002 | 0.442 | 0.722 | 0.085 | 1.012 |
| qlog records, JSON text sequence | 1467503 | 1161.0 ± 0.9% | 0.691 | 0.945 | 0.984 | 0.988 | 0.988 | 0.222 | 0.985 | 0.410 | 0.697 | 0.104 | 1.016 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.065 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.070 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.057 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.066 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1020.5 ± 4.9% | 1013.7 ± 1.1% | 977.6 ± 0.2% | 260.0 ± 0.4% | 531.3 ± 3.7% | 257.8 ± 3.0% | 1.007 | 1.044 | 3.925 | 1.921 | 3.959 |
| qlog records, JSON text sequence | 1467503 | 831.9 ± 0.3% | 808.9 ± 0.6% | 812.6 ± 0.6% | 221.9 ± 5.4% | 585.9 ± 0.7% | 239.7 ± 1.4% | 1.028 | 1.024 | 3.750 | 1.420 | 3.471 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.0 ± 1.2% | 1140.8 ± 0.7% | 897.9 ± 0.5% | 333.7 ± 0.2% | 364.0 ± 1.2% | 312.9 ± 1.1% | 1.168 | 1.484 | 3.992 | 3.660 | 4.257 |
| qlog records, JSON text sequence | 1467503 | 1161.0 ± 0.9% | 871.0 ± 0.8% | 727.2 ± 0.8% | 320.7 ± 0.6% | 385.8 ± 0.8% | 230.3 ± 2.6% | 1.333 | 1.596 | 3.620 | 3.009 | 5.042 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1347.5 ± 2.0% | 1140.8 ± 0.7% | 897.9 ± 0.5% | 333.7 ± 0.2% | 364.0 ± 1.2% | 312.9 ± 1.1% | 1.181 | 1.501 | 4.038 | 3.702 | 4.306 |
| qlog records, JSON text sequence | 1467503 | 1180.1 ± 0.9% | 871.0 ± 0.8% | 727.2 ± 0.8% | 320.7 ± 0.6% | 385.8 ± 0.8% | 230.3 ± 2.6% | 1.355 | 1.623 | 3.680 | 3.059 | 5.125 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 772.1 ± 3.0% | 1013.7 ± 1.1% | 977.6 ± 0.2% | 260.0 ± 0.4% | 531.3 ± 3.7% | 257.8 ± 3.0% | 0.762 | 0.790 | 2.969 | 1.453 | 2.995 |
| qlog records, JSON text sequence | 1467503 | 561.0 ± 0.7% | 808.9 ± 0.6% | 812.6 ± 0.6% | 221.9 ± 5.4% | 585.9 ± 0.7% | 239.7 ± 1.4% | 0.693 | 0.690 | 2.528 | 0.957 | 2.340 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.7 ± 1.6% | 1140.8 ± 0.7% | 897.9 ± 0.5% | 333.7 ± 0.2% | 364.0 ± 1.2% | 312.9 ± 1.1% | 0.843 | 1.071 | 2.882 | 2.642 | 3.073 |
| qlog records, JSON text sequence | 1467503 | 809.7 ± 0.6% | 871.0 ± 0.8% | 727.2 ± 0.8% | 320.7 ± 0.6% | 385.8 ± 0.8% | 230.3 ± 2.6% | 0.930 | 1.113 | 2.525 | 2.099 | 3.517 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.762 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.790 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.693 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.690 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.843 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.930 of simdjson.

# bench-json, CLDR and qlog alone: head, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1041.1 ± 3.6% | 0.461 | 0.999 | 1.054 | 1.053 | 0.413 | 1.037 | 1.051 | 0.355 | 0.772 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 831.0 ± 1.6% | 0.740 | 1.036 | 1.017 | 1.016 | 0.390 | 1.024 | 1.015 | 0.341 | 0.886 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.9 ± 1.7% | 0.436 | 0.976 | 0.964 | 0.998 | 1.010 | 0.228 | 1.008 | 0.438 | 0.721 | 0.085 | 1.023 |
| qlog records, JSON text sequence | 1467503 | 1159.7 ± 0.5% | 0.688 | 0.945 | 0.986 | 0.983 | 0.987 | 0.221 | 0.986 | 0.408 | 0.695 | 0.104 | 1.016 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.053 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.051 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1041.1 ± 3.6% | 1014.2 ± 1.8% | 984.3 ± 5.3% | 259.3 ± 0.6% | 530.0 ± 0.7% | 254.9 ± 2.6% | 1.027 | 1.058 | 4.016 | 1.964 | 4.084 |
| qlog records, JSON text sequence | 1467503 | 831.0 ± 1.6% | 812.7 ± 3.3% | 790.3 ± 3.8% | 220.2 ± 2.7% | 585.7 ± 5.5% | 236.7 ± 4.3% | 1.022 | 1.051 | 3.774 | 1.419 | 3.510 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.9 ± 1.7% | 1138.0 ± 0.6% | 900.5 ± 0.6% | 331.2 ± 4.5% | 358.2 ± 3.9% | 312.0 ± 0.7% | 1.175 | 1.485 | 4.036 | 3.732 | 4.286 |
| qlog records, JSON text sequence | 1467503 | 1159.7 ± 0.5% | 861.5 ± 1.4% | 727.1 ± 1.6% | 320.8 ± 0.6% | 385.6 ± 0.6% | 230.0 ± 1.4% | 1.346 | 1.595 | 3.615 | 3.008 | 5.042 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1367.3 ± 4.8% | 1138.0 ± 0.6% | 900.5 ± 0.6% | 331.2 ± 4.5% | 358.2 ± 3.9% | 312.0 ± 0.7% | 1.201 | 1.518 | 4.128 | 3.817 | 4.383 |
| qlog records, JSON text sequence | 1467503 | 1177.9 ± 0.4% | 861.5 ± 1.4% | 727.1 ± 1.6% | 320.8 ± 0.6% | 385.6 ± 0.6% | 230.0 ± 1.4% | 1.367 | 1.620 | 3.672 | 3.055 | 5.122 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 804.1 ± 2.1% | 1014.2 ± 1.8% | 984.3 ± 5.3% | 259.3 ± 0.6% | 530.0 ± 0.7% | 254.9 ± 2.6% | 0.793 | 0.817 | 3.101 | 1.517 | 3.154 |
| qlog records, JSON text sequence | 1467503 | 735.8 ± 9.1% | 812.7 ± 3.3% | 790.3 ± 3.8% | 220.2 ± 2.7% | 585.7 ± 5.5% | 236.7 ± 4.3% | 0.905 | 0.931 | 3.342 | 1.256 | 3.109 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 963.6 ± 0.6% | 1138.0 ± 0.6% | 900.5 ± 0.6% | 331.2 ± 4.5% | 358.2 ± 3.9% | 312.0 ± 0.7% | 0.847 | 1.070 | 2.909 | 2.690 | 3.089 |
| qlog records, JSON text sequence | 1467503 | 806.5 ± 0.3% | 861.5 ± 1.4% | 727.1 ± 1.6% | 320.8 ± 0.6% | 385.6 ± 0.6% | 230.0 ± 1.4% | 0.936 | 1.109 | 2.514 | 2.092 | 3.507 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.793 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.817 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.905 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.847 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.936 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 949.6 ± 4.0% | 0.495 | 1.021 | 1.058 | 1.012 | 0.422 | 1.035 | 1.009 | 0.389 | 0.861 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 852.2 ± 5.9% | 0.737 | 1.035 | 1.022 | 1.003 | 0.391 | 1.012 | 1.003 | 0.340 | 0.681 | 0.107 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1340.6 ± 1.3% | 0.441 | 0.979 | 0.977 | 1.000 | 0.995 | 0.234 | 0.995 | 0.443 | 0.716 | 0.085 | 1.016 |
| qlog records, JSON text sequence | 1467503 | 1163.2 ± 0.5% | 0.701 | 0.918 | 0.970 | 0.966 | 0.968 | 0.226 | 0.967 | 0.406 | 0.685 | 0.104 | 0.995 |

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
| CLDR supplemental, 34 texts | 920675 | 949.6 ± 4.0% | 997.9 ± 0.6% | 981.0 ± 1.3% | 258.7 ± 2.4% | 518.5 ± 6.0% | 255.8 ± 6.7% | 0.952 | 0.968 | 3.671 | 1.831 | 3.712 |
| qlog records, JSON text sequence | 1467503 | 852.2 ± 5.9% | 810.4 ± 0.4% | 805.2 ± 1.1% | 221.0 ± 3.3% | 588.3 ± 1.9% | 242.2 ± 1.9% | 1.052 | 1.058 | 3.856 | 1.449 | 3.519 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1340.6 ± 1.3% | 1135.9 ± 1.3% | 899.5 ± 0.5% | 320.1 ± 0.9% | 357.6 ± 0.8% | 312.7 ± 1.6% | 1.180 | 1.490 | 4.188 | 3.749 | 4.287 |
| qlog records, JSON text sequence | 1467503 | 1163.2 ± 0.5% | 862.0 ± 0.6% | 714.6 ± 0.4% | 315.3 ± 0.7% | 385.5 ± 0.5% | 230.4 ± 1.2% | 1.349 | 1.628 | 3.690 | 3.017 | 5.048 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1362.7 ± 0.8% | 1135.9 ± 1.3% | 899.5 ± 0.5% | 320.1 ± 0.9% | 357.6 ± 0.8% | 312.7 ± 1.6% | 1.200 | 1.515 | 4.257 | 3.810 | 4.357 |
| qlog records, JSON text sequence | 1467503 | 1157.2 ± 0.8% | 862.0 ± 0.6% | 714.6 ± 0.4% | 315.3 ± 0.7% | 385.5 ± 0.5% | 230.4 ± 1.2% | 1.342 | 1.619 | 3.671 | 3.002 | 5.022 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 817.3 ± 1.0% | 997.9 ± 0.6% | 981.0 ± 1.3% | 258.7 ± 2.4% | 518.5 ± 6.0% | 255.8 ± 6.7% | 0.819 | 0.833 | 3.160 | 1.576 | 3.195 |
| qlog records, JSON text sequence | 1467503 | 580.6 ± 4.5% | 810.4 ± 0.4% | 805.2 ± 1.1% | 221.0 ± 3.3% | 588.3 ± 1.9% | 242.2 ± 1.9% | 0.716 | 0.721 | 2.627 | 0.987 | 2.397 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 960.2 ± 5.5% | 1135.9 ± 1.3% | 899.5 ± 0.5% | 320.1 ± 0.9% | 357.6 ± 0.8% | 312.7 ± 1.6% | 0.845 | 1.067 | 2.999 | 2.685 | 3.070 |
| qlog records, JSON text sequence | 1467503 | 796.6 ± 0.9% | 862.0 ± 0.6% | 714.6 ± 0.4% | 315.3 ± 0.7% | 385.5 ± 0.5% | 230.4 ± 1.2% | 0.924 | 1.115 | 2.527 | 2.067 | 3.457 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.819 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.833 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.716 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.721 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.845 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.924 of simdjson.

# bench-json, CLDR and qlog alone: null, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1015.4 ± 3.2% | 0.471 | 1.023 | 1.082 | 1.081 | 0.422 | 1.068 | 1.078 | 0.364 | 0.761 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 833.7 ± 5.6% | 0.742 | 1.024 | 1.015 | 0.997 | 0.394 | 1.022 | 0.999 | 0.346 | 0.671 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.4 ± 0.9% | 0.404 | 0.970 | 0.962 | 1.006 | 1.000 | 0.228 | 1.003 | 0.441 | 0.718 | 0.085 | 1.006 |
| qlog records, JSON text sequence | 1467503 | 1160.1 ± 0.2% | 0.692 | 0.945 | 0.984 | 0.987 | 0.990 | 0.222 | 0.987 | 0.411 | 0.697 | 0.104 | 1.014 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.082 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.081 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.068 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.078 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1015.4 ± 3.2% | 993.5 ± 0.5% | 966.2 ± 0.9% | 259.7 ± 0.7% | 530.3 ± 0.7% | 258.2 ± 2.3% | 1.022 | 1.051 | 3.911 | 1.915 | 3.933 |
| qlog records, JSON text sequence | 1467503 | 833.7 ± 5.6% | 798.0 ± 1.0% | 806.0 ± 2.8% | 221.8 ± 5.9% | 584.1 ± 3.9% | 241.9 ± 2.4% | 1.045 | 1.034 | 3.759 | 1.427 | 3.446 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.4 ± 0.9% | 1141.7 ± 2.6% | 888.1 ± 5.2% | 332.2 ± 2.3% | 363.3 ± 4.1% | 312.7 ± 2.6% | 1.173 | 1.508 | 4.032 | 3.687 | 4.283 |
| qlog records, JSON text sequence | 1467503 | 1160.1 ± 0.2% | 818.3 ± 0.3% | 725.0 ± 0.5% | 320.7 ± 2.5% | 383.8 ± 2.1% | 229.8 ± 2.6% | 1.418 | 1.600 | 3.617 | 3.023 | 5.048 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1347.5 ± 1.7% | 1141.7 ± 2.6% | 888.1 ± 5.2% | 332.2 ± 2.3% | 363.3 ± 4.1% | 312.7 ± 2.6% | 1.180 | 1.517 | 4.056 | 3.709 | 4.309 |
| qlog records, JSON text sequence | 1467503 | 1176.8 ± 0.4% | 818.3 ± 0.3% | 725.0 ± 0.5% | 320.7 ± 2.5% | 383.8 ± 2.1% | 229.8 ± 2.6% | 1.438 | 1.623 | 3.669 | 3.066 | 5.121 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 773.0 ± 1.0% | 993.5 ± 0.5% | 966.2 ± 0.9% | 259.7 ± 0.7% | 530.3 ± 0.7% | 258.2 ± 2.3% | 0.778 | 0.800 | 2.977 | 1.458 | 2.994 |
| qlog records, JSON text sequence | 1467503 | 559.3 ± 5.2% | 798.0 ± 1.0% | 806.0 ± 2.8% | 221.8 ± 5.9% | 584.1 ± 3.9% | 241.9 ± 2.4% | 0.701 | 0.694 | 2.522 | 0.958 | 2.312 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.8 ± 4.9% | 1141.7 ± 2.6% | 888.1 ± 5.2% | 332.2 ± 2.3% | 363.3 ± 4.1% | 312.7 ± 2.6% | 0.842 | 1.083 | 2.895 | 2.647 | 3.075 |
| qlog records, JSON text sequence | 1467503 | 808.6 ± 1.0% | 818.3 ± 0.3% | 725.0 ± 0.5% | 320.7 ± 2.5% | 383.8 ± 2.1% | 229.8 ± 2.6% | 0.988 | 1.115 | 2.521 | 2.107 | 3.519 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.778 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.800 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.701 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.694 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.842 of simdjson.

# bench-json, CLDR and qlog alone: head, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1008.1 ± 2.1% | 0.476 | 1.054 | 1.087 | 1.086 | 0.424 | 1.074 | 1.088 | 0.367 | 0.802 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 834.0 ± 1.1% | 0.742 | 1.034 | 1.013 | 1.010 | 0.390 | 1.023 | 1.015 | 0.339 | 0.898 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.5 ± 1.7% | 0.437 | 0.978 | 0.965 | 0.999 | 1.010 | 0.227 | 1.011 | 0.441 | 0.716 | 0.085 | 1.011 |
| qlog records, JSON text sequence | 1467503 | 1142.6 ± 2.1% | 0.697 | 0.960 | 0.998 | 1.000 | 1.001 | 0.224 | 1.004 | 0.417 | 0.705 | 0.105 | 1.027 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J5 UTF-8 vectors off runs at 1.054 of all on.
- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.087 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.086 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.074 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.088 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1008.1 ± 2.1% | 1018.2 ± 2.9% | 975.8 ± 0.7% | 259.7 ± 0.2% | 530.7 ± 0.4% | 258.0 ± 3.0% | 0.990 | 1.033 | 3.882 | 1.900 | 3.907 |
| qlog records, JSON text sequence | 1467503 | 834.0 ± 1.1% | 806.4 ± 0.4% | 782.0 ± 2.6% | 220.5 ± 2.1% | 583.9 ± 2.5% | 241.0 ± 4.0% | 1.034 | 1.066 | 3.782 | 1.428 | 3.460 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.5 ± 1.7% | 1138.6 ± 1.4% | 896.6 ± 0.7% | 331.9 ± 0.6% | 361.0 ± 2.2% | 310.1 ± 1.1% | 1.174 | 1.491 | 4.027 | 3.702 | 4.310 |
| qlog records, JSON text sequence | 1467503 | 1142.6 ± 2.1% | 871.5 ± 0.4% | 721.3 ± 0.9% | 320.0 ± 0.9% | 386.1 ± 1.0% | 229.8 ± 1.0% | 1.311 | 1.584 | 3.570 | 2.960 | 4.973 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1351.1 ± 1.1% | 1138.6 ± 1.4% | 896.6 ± 0.7% | 331.9 ± 0.6% | 361.0 ± 2.2% | 310.1 ± 1.1% | 1.187 | 1.507 | 4.071 | 3.742 | 4.357 |
| qlog records, JSON text sequence | 1467503 | 1173.3 ± 1.1% | 871.5 ± 0.4% | 721.3 ± 0.9% | 320.0 ± 0.9% | 386.1 ± 1.0% | 229.8 ± 1.0% | 1.346 | 1.627 | 3.666 | 3.039 | 5.106 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 808.8 ± 3.0% | 1018.2 ± 2.9% | 975.8 ± 0.7% | 259.7 ± 0.2% | 530.7 ± 0.4% | 258.0 ± 3.0% | 0.794 | 0.829 | 3.114 | 1.524 | 3.135 |
| qlog records, JSON text sequence | 1467503 | 749.3 ± 1.1% | 806.4 ± 0.4% | 782.0 ± 2.6% | 220.5 ± 2.1% | 583.9 ± 2.5% | 241.0 ± 4.0% | 0.929 | 0.958 | 3.398 | 1.283 | 3.109 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 957.5 ± 0.7% | 1138.6 ± 1.4% | 896.6 ± 0.7% | 331.9 ± 0.6% | 361.0 ± 2.2% | 310.1 ± 1.1% | 0.841 | 1.068 | 2.885 | 2.652 | 3.088 |
| qlog records, JSON text sequence | 1467503 | 806.1 ± 0.4% | 871.5 ± 0.4% | 721.3 ± 0.9% | 320.0 ± 0.9% | 386.1 ± 1.0% | 229.8 ± 1.0% | 0.925 | 1.118 | 2.519 | 2.088 | 3.508 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.794 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.829 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.929 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.841 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.925 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1012.9 ± 4.5% | 0.486 | 1.043 | 1.007 | 1.056 | 0.418 | 1.062 | 1.054 | 0.365 | 0.801 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 853.0 ± 1.1% | 0.735 | 1.030 | 1.011 | 0.996 | 0.389 | 1.009 | 0.998 | 0.337 | 0.681 | 0.107 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1345.4 ± 1.4% | 0.438 | 0.975 | 0.967 | 0.992 | 0.985 | 0.233 | 0.978 | 0.439 | 0.712 | 0.085 | 1.004 |
| qlog records, JSON text sequence | 1467503 | 1152.1 ± 5.5% | 0.706 | 0.929 | 0.988 | 0.988 | 0.990 | 0.228 | 0.979 | 0.408 | 0.693 | 0.105 | 1.008 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.056 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1012.9 ± 4.5% | 997.4 ± 0.4% | 982.6 ± 1.0% | 259.6 ± 0.6% | 531.4 ± 1.2% | 259.1 ± 2.2% | 1.016 | 1.031 | 3.902 | 1.906 | 3.909 |
| qlog records, JSON text sequence | 1467503 | 853.0 ± 1.1% | 808.5 ± 0.7% | 806.0 ± 3.9% | 221.0 ± 2.4% | 588.3 ± 2.4% | 239.6 ± 3.5% | 1.055 | 1.058 | 3.860 | 1.450 | 3.559 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1345.4 ± 1.4% | 1128.6 ± 0.8% | 898.0 ± 0.8% | 319.4 ± 0.3% | 357.2 ± 0.5% | 313.8 ± 1.2% | 1.192 | 1.498 | 4.213 | 3.766 | 4.288 |
| qlog records, JSON text sequence | 1467503 | 1152.1 ± 5.5% | 865.7 ± 7.4% | 720.3 ± 1.0% | 316.1 ± 1.5% | 388.8 ± 0.8% | 230.9 ± 4.3% | 1.331 | 1.600 | 3.645 | 2.963 | 4.989 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1350.8 ± 0.9% | 1128.6 ± 0.8% | 898.0 ± 0.8% | 319.4 ± 0.3% | 357.2 ± 0.5% | 313.8 ± 1.2% | 1.197 | 1.504 | 4.229 | 3.781 | 4.305 |
| qlog records, JSON text sequence | 1467503 | 1161.9 ± 6.3% | 865.7 ± 7.4% | 720.3 ± 1.0% | 316.1 ± 1.5% | 388.8 ± 0.8% | 230.9 ± 4.3% | 1.342 | 1.613 | 3.676 | 2.988 | 5.031 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 811.1 ± 2.4% | 997.4 ± 0.4% | 982.6 ± 1.0% | 259.6 ± 0.6% | 531.4 ± 1.2% | 259.1 ± 2.2% | 0.813 | 0.825 | 3.124 | 1.526 | 3.130 |
| qlog records, JSON text sequence | 1467503 | 580.5 ± 0.5% | 808.5 ± 0.7% | 806.0 ± 3.9% | 221.0 ± 2.4% | 588.3 ± 2.4% | 239.6 ± 3.5% | 0.718 | 0.720 | 2.627 | 0.987 | 2.422 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 957.9 ± 1.3% | 1128.6 ± 0.8% | 898.0 ± 0.8% | 319.4 ± 0.3% | 357.2 ± 0.5% | 313.8 ± 1.2% | 0.849 | 1.067 | 2.999 | 2.682 | 3.053 |
| qlog records, JSON text sequence | 1467503 | 798.1 ± 6.4% | 865.7 ± 7.4% | 720.3 ± 1.0% | 316.1 ± 1.5% | 388.8 ± 0.8% | 230.9 ± 4.3% | 0.922 | 1.108 | 2.525 | 2.053 | 3.456 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.813 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.825 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.718 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.720 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.849 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.922 of simdjson.

# bench-json, CLDR and qlog alone: null, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1040.5 ± 5.4% | 0.460 | 0.999 | 1.057 | 1.056 | 0.412 | 1.041 | 1.053 | 0.356 | 0.744 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 827.7 ± 1.2% | 0.744 | 1.039 | 1.020 | 1.004 | 0.392 | 1.021 | 1.001 | 0.342 | 0.672 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1346.8 ± 2.8% | 0.400 | 0.964 | 0.954 | 1.000 | 0.999 | 0.227 | 0.996 | 0.436 | 0.716 | 0.085 | 1.006 |
| qlog records, JSON text sequence | 1467503 | 1161.5 ± 0.7% | 0.691 | 0.939 | 0.982 | 0.984 | 0.985 | 0.221 | 0.987 | 0.413 | 0.696 | 0.104 | 1.014 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.057 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.056 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1040.5 ± 5.4% | 994.5 ± 0.6% | 963.7 ± 0.7% | 260.4 ± 0.4% | 528.5 ± 1.9% | 258.0 ± 2.6% | 1.046 | 1.080 | 3.996 | 1.969 | 4.033 |
| qlog records, JSON text sequence | 1467503 | 827.7 ± 1.2% | 795.9 ± 0.2% | 793.4 ± 2.1% | 219.9 ± 5.7% | 585.0 ± 1.2% | 240.7 ± 2.5% | 1.040 | 1.043 | 3.765 | 1.415 | 3.439 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1346.8 ± 2.8% | 1140.9 ± 8.3% | 894.3 ± 0.8% | 332.1 ± 0.4% | 359.9 ± 1.4% | 313.1 ± 0.7% | 1.180 | 1.506 | 4.055 | 3.742 | 4.301 |
| qlog records, JSON text sequence | 1467503 | 1161.5 ± 0.7% | 873.6 ± 0.4% | 724.0 ± 0.6% | 320.9 ± 1.1% | 380.1 ± 1.2% | 230.4 ± 1.5% | 1.329 | 1.604 | 3.620 | 3.055 | 5.040 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1354.6 ± 4.5% | 1140.9 ± 8.3% | 894.3 ± 0.8% | 332.1 ± 0.4% | 359.9 ± 1.4% | 313.1 ± 0.7% | 1.187 | 1.515 | 4.078 | 3.764 | 4.326 |
| qlog records, JSON text sequence | 1467503 | 1177.9 ± 0.8% | 873.6 ± 0.4% | 724.0 ± 0.6% | 320.9 ± 1.1% | 380.1 ± 1.2% | 230.4 ± 1.5% | 1.348 | 1.627 | 3.671 | 3.099 | 5.111 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 773.9 ± 1.0% | 994.5 ± 0.6% | 963.7 ± 0.7% | 260.4 ± 0.4% | 528.5 ± 1.9% | 258.0 ± 2.6% | 0.778 | 0.803 | 2.972 | 1.464 | 3.000 |
| qlog records, JSON text sequence | 1467503 | 556.1 ± 0.9% | 795.9 ± 0.2% | 793.4 ± 2.1% | 219.9 ± 5.7% | 585.0 ± 1.2% | 240.7 ± 2.5% | 0.699 | 0.701 | 2.529 | 0.951 | 2.310 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 963.7 ± 1.3% | 1140.9 ± 8.3% | 894.3 ± 0.8% | 332.1 ± 0.4% | 359.9 ± 1.4% | 313.1 ± 0.7% | 0.845 | 1.078 | 2.901 | 2.678 | 3.077 |
| qlog records, JSON text sequence | 1467503 | 809.0 ± 0.7% | 873.6 ± 0.4% | 724.0 ± 0.6% | 320.9 ± 1.1% | 380.1 ± 1.2% | 230.4 ± 1.5% | 0.926 | 1.117 | 2.521 | 2.128 | 3.510 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.778 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.803 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.699 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.701 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.845 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.

# bench-json, CLDR and qlog alone: head, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1007.9 ± 2.3% | 0.477 | 1.049 | 1.091 | 1.090 | 0.426 | 1.076 | 1.086 | 0.367 | 0.800 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 836.9 ± 4.1% | 0.737 | 1.031 | 1.009 | 1.011 | 0.388 | 1.013 | 1.009 | 0.338 | 0.893 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.8 ± 1.8% | 0.435 | 0.972 | 0.967 | 0.994 | 1.001 | 0.229 | 1.006 | 0.443 | 0.720 | 0.085 | 1.014 |
| qlog records, JSON text sequence | 1467503 | 1159.9 ± 0.4% | 0.691 | 0.945 | 0.984 | 0.987 | 0.987 | 0.221 | 0.985 | 0.413 | 0.695 | 0.104 | 1.014 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.091 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.090 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.076 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.086 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1007.9 ± 2.3% | 1011.1 ± 0.4% | 985.5 ± 1.2% | 259.3 ± 0.9% | 529.7 ± 0.5% | 257.8 ± 3.6% | 0.997 | 1.023 | 3.887 | 1.903 | 3.910 |
| qlog records, JSON text sequence | 1467503 | 836.9 ± 4.1% | 810.9 ± 2.9% | 779.0 ± 4.4% | 217.4 ± 5.8% | 575.5 ± 4.4% | 236.4 ± 8.4% | 1.032 | 1.074 | 3.850 | 1.454 | 3.540 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.8 ± 1.8% | 1141.1 ± 0.6% | 895.7 ± 2.0% | 333.6 ± 1.0% | 358.8 ± 2.5% | 312.6 ± 1.3% | 1.171 | 1.491 | 4.004 | 3.723 | 4.273 |
| qlog records, JSON text sequence | 1467503 | 1159.9 ± 0.4% | 870.8 ± 0.9% | 727.2 ± 1.1% | 321.5 ± 1.9% | 387.6 ± 1.6% | 231.8 ± 2.3% | 1.332 | 1.595 | 3.608 | 2.993 | 5.003 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1354.3 ± 1.3% | 1141.1 ± 0.6% | 895.7 ± 2.0% | 333.6 ± 1.0% | 358.8 ± 2.5% | 312.6 ± 1.3% | 1.187 | 1.512 | 4.060 | 3.775 | 4.332 |
| qlog records, JSON text sequence | 1467503 | 1175.9 ± 1.2% | 870.8 ± 0.9% | 727.2 ± 1.1% | 321.5 ± 1.9% | 387.6 ± 1.6% | 231.8 ± 2.3% | 1.350 | 1.617 | 3.657 | 3.034 | 5.072 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 806.4 ± 1.8% | 1011.1 ± 0.4% | 985.5 ± 1.2% | 259.3 ± 0.9% | 529.7 ± 0.5% | 257.8 ± 3.6% | 0.798 | 0.818 | 3.110 | 1.522 | 3.128 |
| qlog records, JSON text sequence | 1467503 | 747.4 ± 0.7% | 810.9 ± 2.9% | 779.0 ± 4.4% | 217.4 ± 5.8% | 575.5 ± 4.4% | 236.4 ± 8.4% | 0.922 | 0.959 | 3.438 | 1.299 | 3.162 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 962.1 ± 1.8% | 1141.1 ± 0.6% | 895.7 ± 2.0% | 333.6 ± 1.0% | 358.8 ± 2.5% | 312.6 ± 1.3% | 0.843 | 1.074 | 2.884 | 2.681 | 3.077 |
| qlog records, JSON text sequence | 1467503 | 806.5 ± 0.8% | 870.8 ± 0.9% | 727.2 ± 1.1% | 321.5 ± 1.9% | 387.6 ± 1.6% | 231.8 ± 2.3% | 0.926 | 1.109 | 2.508 | 2.081 | 3.479 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.798 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.818 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.922 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.843 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.
