# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1015.4 ± 3.4% | 0.486 | 1.017 | 1.063 | 1.045 | 0.416 | 1.050 | 1.047 | 0.365 | 0.799 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 854.6 ± 1.1% | 0.733 | 1.031 | 1.015 | 0.996 | 0.388 | 1.013 | 0.996 | 0.343 | 0.683 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.3 ± 1.3% | 0.442 | 0.980 | 0.975 | 1.001 | 0.997 | 0.235 | 0.999 | 0.445 | 0.719 | 0.086 | 1.014 |
| qlog records, JSON text sequence | 1467503 | 1159.0 ± 1.3% | 0.700 | 0.919 | 0.985 | 0.987 | 0.986 | 0.228 | 0.986 | 0.413 | 0.690 | 0.104 | 1.009 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.063 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1015.4 ± 3.4% | 986.6 ± 0.3% | 968.8 ± 0.3% | 259.9 ± 1.3% | 531.1 ± 0.6% | 256.2 ± 7.7% | 1.029 | 1.048 | 3.907 | 1.912 | 3.963 |
| qlog records, JSON text sequence | 1467503 | 854.6 ± 1.1% | 796.4 ± 0.3% | 795.4 ± 6.8% | 222.8 ± 0.9% | 587.8 ± 0.6% | 244.4 ± 0.8% | 1.073 | 1.074 | 3.835 | 1.454 | 3.496 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.3 ± 1.3% | 1133.7 ± 1.1% | 898.3 ± 0.8% | 320.7 ± 0.7% | 358.0 ± 0.5% | 309.8 ± 0.9% | 1.177 | 1.485 | 4.161 | 3.727 | 4.308 |
| qlog records, JSON text sequence | 1467503 | 1159.0 ± 1.3% | 871.7 ± 3.4% | 726.0 ± 0.4% | 318.9 ± 1.0% | 391.6 ± 0.5% | 230.6 ± 2.3% | 1.330 | 1.596 | 3.634 | 2.960 | 5.025 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1353.2 ± 2.7% | 1133.7 ± 1.1% | 898.3 ± 0.8% | 320.7 ± 0.7% | 358.0 ± 0.5% | 309.8 ± 0.9% | 1.194 | 1.506 | 4.220 | 3.780 | 4.369 |
| qlog records, JSON text sequence | 1467503 | 1169.6 ± 4.9% | 871.7 ± 3.4% | 726.0 ± 0.4% | 318.9 ± 1.0% | 391.6 ± 0.5% | 230.6 ± 2.3% | 1.342 | 1.611 | 3.667 | 2.987 | 5.071 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 811.2 ± 1.3% | 986.6 ± 0.3% | 968.8 ± 0.3% | 259.9 ± 1.3% | 531.1 ± 0.6% | 256.2 ± 7.7% | 0.822 | 0.837 | 3.121 | 1.527 | 3.166 |
| qlog records, JSON text sequence | 1467503 | 583.9 ± 0.6% | 796.4 ± 0.3% | 795.4 ± 6.8% | 222.8 ± 0.9% | 587.8 ± 0.6% | 244.4 ± 0.8% | 0.733 | 0.734 | 2.620 | 0.993 | 2.389 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 959.2 ± 0.6% | 1133.7 ± 1.1% | 898.3 ± 0.8% | 320.7 ± 0.7% | 358.0 ± 0.5% | 309.8 ± 0.9% | 0.846 | 1.068 | 2.991 | 2.679 | 3.097 |
| qlog records, JSON text sequence | 1467503 | 799.6 ± 1.3% | 871.7 ± 3.4% | 726.0 ± 0.4% | 318.9 ± 1.0% | 391.6 ± 0.5% | 230.6 ± 2.3% | 0.917 | 1.101 | 2.507 | 2.042 | 3.467 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.822 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.837 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.733 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.734 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.846 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.917 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1003.7 ± 5.9% | 0.478 | 1.064 | 1.075 | 1.092 | 0.428 | 1.081 | 1.085 | 0.369 | 0.776 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 836.7 ± 0.9% | 0.735 | 1.030 | 1.008 | 1.005 | 0.393 | 1.013 | 1.006 | 0.346 | 0.793 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.3 ± 0.7% | 0.436 | 0.975 | 0.971 | 0.994 | 1.010 | 0.228 | 1.010 | 0.440 | 0.716 | 0.086 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1147.2 ± 5.4% | 0.692 | 0.948 | 0.997 | 0.997 | 1.001 | 0.223 | 1.002 | 0.415 | 0.702 | 0.105 | 1.027 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.075 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.092 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.081 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.085 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1003.7 ± 5.9% | 1002.3 ± 0.5% | 979.3 ± 3.7% | 259.5 ± 0.4% | 530.7 ± 0.2% | 257.5 ± 2.2% | 1.001 | 1.025 | 3.867 | 1.891 | 3.898 |
| qlog records, JSON text sequence | 1467503 | 836.7 ± 0.9% | 805.6 ± 0.2% | 812.4 ± 6.7% | 221.6 ± 1.3% | 586.4 ± 2.1% | 240.0 ± 1.2% | 1.039 | 1.030 | 3.775 | 1.427 | 3.487 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.3 ± 0.7% | 1134.1 ± 1.0% | 898.3 ± 0.7% | 332.7 ± 0.3% | 359.0 ± 3.5% | 311.7 ± 1.1% | 1.179 | 1.489 | 4.019 | 3.725 | 4.291 |
| qlog records, JSON text sequence | 1467503 | 1147.2 ± 5.4% | 866.1 ± 6.9% | 722.6 ± 0.8% | 322.9 ± 0.8% | 388.6 ± 4.5% | 229.0 ± 1.2% | 1.325 | 1.588 | 3.553 | 2.952 | 5.010 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1359.4 ± 1.1% | 1134.1 ± 1.0% | 898.3 ± 0.7% | 332.7 ± 0.3% | 359.0 ± 3.5% | 311.7 ± 1.1% | 1.199 | 1.513 | 4.086 | 3.786 | 4.362 |
| qlog records, JSON text sequence | 1467503 | 1178.0 ± 5.4% | 866.1 ± 6.9% | 722.6 ± 0.8% | 322.9 ± 0.8% | 388.6 ± 4.5% | 229.0 ± 1.2% | 1.360 | 1.630 | 3.648 | 3.031 | 5.145 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 779.1 ± 2.1% | 1002.3 ± 0.5% | 979.3 ± 3.7% | 259.5 ± 0.4% | 530.7 ± 0.2% | 257.5 ± 2.2% | 0.777 | 0.796 | 3.002 | 1.468 | 3.026 |
| qlog records, JSON text sequence | 1467503 | 663.5 ± 2.8% | 805.6 ± 0.2% | 812.4 ± 6.7% | 221.6 ± 1.3% | 586.4 ± 2.1% | 240.0 ± 1.2% | 0.824 | 0.817 | 2.994 | 1.131 | 2.765 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 957.9 ± 0.8% | 1134.1 ± 1.0% | 898.3 ± 0.7% | 332.7 ± 0.3% | 359.0 ± 3.5% | 311.7 ± 1.1% | 0.845 | 1.066 | 2.879 | 2.668 | 3.074 |
| qlog records, JSON text sequence | 1467503 | 805.7 ± 0.5% | 866.1 ± 6.9% | 722.6 ± 0.8% | 322.9 ± 0.8% | 388.6 ± 4.5% | 229.0 ± 1.2% | 0.930 | 1.115 | 2.495 | 2.073 | 3.519 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.777 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.796 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.824 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.817 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.845 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.930 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1041.3 ± 0.4% | 0.458 | 0.990 | 1.022 | 1.047 | 0.413 | 1.037 | 1.049 | 0.356 | 0.774 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 840.3 ± 0.6% | 0.735 | 1.028 | 1.006 | 1.003 | 0.389 | 1.011 | 1.002 | 0.346 | 0.891 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.7 ± 0.5% | 0.438 | 0.973 | 0.964 | 0.993 | 1.005 | 0.228 | 1.006 | 0.440 | 0.717 | 0.086 | 1.019 |
| qlog records, JSON text sequence | 1467503 | 1145.8 ± 0.9% | 0.688 | 0.949 | 0.985 | 0.988 | 0.987 | 0.222 | 0.989 | 0.412 | 0.697 | 0.104 | 1.018 |

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
| CLDR supplemental, 34 texts | 920675 | 1041.3 ± 0.4% | 1004.7 ± 1.1% | 985.4 ± 0.6% | 259.1 ± 0.5% | 530.7 ± 3.3% | 259.0 ± 2.2% | 1.036 | 1.057 | 4.018 | 1.962 | 4.020 |
| qlog records, JSON text sequence | 1467503 | 840.3 ± 0.6% | 813.8 ± 0.3% | 812.4 ± 6.0% | 214.7 ± 1.5% | 587.1 ± 0.8% | 246.5 ± 1.5% | 1.032 | 1.034 | 3.914 | 1.431 | 3.409 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.7 ± 0.5% | 1129.7 ± 2.1% | 898.9 ± 0.6% | 333.0 ± 0.6% | 356.8 ± 3.6% | 311.8 ± 4.7% | 1.183 | 1.487 | 4.014 | 3.746 | 4.288 |
| qlog records, JSON text sequence | 1467503 | 1145.8 ± 0.9% | 861.9 ± 0.3% | 715.1 ± 0.7% | 319.9 ± 0.4% | 389.4 ± 1.1% | 229.8 ± 1.7% | 1.329 | 1.602 | 3.582 | 2.942 | 4.986 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1361.5 ± 0.9% | 1129.7 ± 2.1% | 898.9 ± 0.6% | 333.0 ± 0.6% | 356.8 ± 3.6% | 311.8 ± 4.7% | 1.205 | 1.515 | 4.089 | 3.815 | 4.367 |
| qlog records, JSON text sequence | 1467503 | 1166.4 ± 0.8% | 861.9 ± 0.3% | 715.1 ± 0.7% | 319.9 ± 0.4% | 389.4 ± 1.1% | 229.8 ± 1.7% | 1.353 | 1.631 | 3.647 | 2.995 | 5.076 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 805.7 ± 1.8% | 1004.7 ± 1.1% | 985.4 ± 0.6% | 259.1 ± 0.5% | 530.7 ± 3.3% | 259.0 ± 2.2% | 0.802 | 0.818 | 3.109 | 1.518 | 3.110 |
| qlog records, JSON text sequence | 1467503 | 748.7 ± 5.4% | 813.8 ± 0.3% | 812.4 ± 6.0% | 214.7 ± 1.5% | 587.1 ± 0.8% | 246.5 ± 1.5% | 0.920 | 0.922 | 3.488 | 1.275 | 3.037 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 958.3 ± 4.2% | 1129.7 ± 2.1% | 898.9 ± 0.6% | 333.0 ± 0.6% | 356.8 ± 3.6% | 311.8 ± 4.7% | 0.848 | 1.066 | 2.878 | 2.685 | 3.074 |
| qlog records, JSON text sequence | 1467503 | 798.9 ± 0.5% | 861.9 ± 0.3% | 715.1 ± 0.7% | 319.9 ± 0.4% | 389.4 ± 1.1% | 229.8 ± 1.7% | 0.927 | 1.117 | 2.498 | 2.051 | 3.477 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.802 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.818 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.920 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.922 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.848 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.927 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1017.1 ± 4.0% | 0.484 | 1.015 | 1.055 | 1.037 | 0.415 | 1.049 | 1.049 | 0.364 | 0.799 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 856.0 ± 0.7% | 0.731 | 1.028 | 1.014 | 1.003 | 0.387 | 1.011 | 0.998 | 0.343 | 0.683 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.0 ± 1.0% | 0.442 | 0.978 | 0.975 | 1.001 | 0.997 | 0.235 | 0.997 | 0.444 | 0.722 | 0.086 | 1.021 |
| qlog records, JSON text sequence | 1467503 | 1149.2 ± 1.9% | 0.704 | 0.923 | 0.995 | 0.995 | 0.996 | 0.230 | 0.998 | 0.414 | 0.698 | 0.105 | 1.023 |

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
| CLDR supplemental, 34 texts | 920675 | 1017.1 ± 4.0% | 886.6 ± 0.2% | 983.6 ± 0.9% | 259.4 ± 0.6% | 530.8 ± 0.4% | 255.7 ± 3.3% | 1.147 | 1.034 | 3.921 | 1.916 | 3.978 |
| qlog records, JSON text sequence | 1467503 | 856.0 ± 0.7% | 733.0 ± 0.1% | 813.0 ± 1.2% | 216.6 ± 3.5% | 586.5 ± 1.4% | 244.8 ± 5.3% | 1.168 | 1.053 | 3.951 | 1.460 | 3.497 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.0 ± 1.0% | 1129.7 ± 7.3% | 895.4 ± 0.9% | 315.1 ± 4.2% | 357.5 ± 4.4% | 310.9 ± 2.5% | 1.181 | 1.490 | 4.234 | 3.732 | 4.290 |
| qlog records, JSON text sequence | 1467503 | 1149.2 ± 1.9% | 864.8 ± 7.0% | 708.0 ± 0.9% | 281.2 ± 1.2% | 386.6 ± 3.3% | 229.0 ± 6.1% | 1.329 | 1.623 | 4.087 | 2.972 | 5.017 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1361.5 ± 0.8% | 1129.7 ± 7.3% | 895.4 ± 0.9% | 315.1 ± 4.2% | 357.5 ± 4.4% | 310.9 ± 2.5% | 1.205 | 1.520 | 4.321 | 3.809 | 4.379 |
| qlog records, JSON text sequence | 1467503 | 1176.0 ± 0.5% | 864.8 ± 7.0% | 708.0 ± 0.9% | 281.2 ± 1.2% | 386.6 ± 3.3% | 229.0 ± 6.1% | 1.360 | 1.661 | 4.183 | 3.042 | 5.134 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 813.0 ± 0.7% | 886.6 ± 0.2% | 983.6 ± 0.9% | 259.4 ± 0.6% | 530.8 ± 0.4% | 255.7 ± 3.3% | 0.917 | 0.827 | 3.134 | 1.532 | 3.180 |
| qlog records, JSON text sequence | 1467503 | 584.9 ± 5.2% | 733.0 ± 0.1% | 813.0 ± 1.2% | 216.6 ± 3.5% | 586.5 ± 1.4% | 244.8 ± 5.3% | 0.798 | 0.719 | 2.700 | 0.997 | 2.390 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 962.6 ± 1.0% | 1129.7 ± 7.3% | 895.4 ± 0.9% | 315.1 ± 4.2% | 357.5 ± 4.4% | 310.9 ± 2.5% | 0.852 | 1.075 | 3.055 | 2.693 | 3.096 |
| qlog records, JSON text sequence | 1467503 | 802.2 ± 6.6% | 864.8 ± 7.0% | 708.0 ± 0.9% | 281.2 ± 1.2% | 386.6 ± 3.3% | 229.0 ± 6.1% | 0.928 | 1.133 | 2.853 | 2.075 | 3.502 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.917 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.827 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.798 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.719 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.852 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.928 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1023.6 ± 4.7% | 0.468 | 1.042 | 1.068 | 1.070 | 0.421 | 1.063 | 1.063 | 0.362 | 0.761 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 840.1 ± 0.4% | 0.732 | 1.024 | 1.003 | 1.002 | 0.390 | 1.010 | 1.001 | 0.347 | 0.794 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.4 ± 1.0% | 0.436 | 0.969 | 0.968 | 0.990 | 1.001 | 0.227 | 1.007 | 0.439 | 0.718 | 0.085 | 1.011 |
| qlog records, JSON text sequence | 1467503 | 1139.4 ± 2.9% | 0.696 | 0.952 | 1.002 | 1.002 | 1.007 | 0.225 | 1.002 | 0.418 | 0.707 | 0.105 | 1.036 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.068 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.070 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.063 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1023.6 ± 4.7% | 1012.9 ± 0.4% | 984.1 ± 0.3% | 259.8 ± 0.9% | 528.9 ± 0.9% | 258.8 ± 3.0% | 1.011 | 1.040 | 3.940 | 1.935 | 3.956 |
| qlog records, JSON text sequence | 1467503 | 840.1 ± 0.4% | 808.5 ± 5.0% | 779.8 ± 4.5% | 218.7 ± 3.8% | 584.8 ± 1.4% | 245.9 ± 1.3% | 1.039 | 1.077 | 3.841 | 1.436 | 3.417 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.4 ± 1.0% | 1130.4 ± 0.5% | 897.1 ± 1.4% | 333.5 ± 1.1% | 365.1 ± 1.9% | 313.1 ± 4.4% | 1.185 | 1.493 | 4.016 | 3.669 | 4.278 |
| qlog records, JSON text sequence | 1467503 | 1139.4 ± 2.9% | 867.6 ± 0.4% | 725.2 ± 0.4% | 322.4 ± 0.7% | 392.0 ± 0.8% | 229.2 ± 2.4% | 1.313 | 1.571 | 3.534 | 2.906 | 4.971 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1354.2 ± 1.3% | 1130.4 ± 0.5% | 897.1 ± 1.4% | 333.5 ± 1.1% | 365.1 ± 1.9% | 313.1 ± 4.4% | 1.198 | 1.510 | 4.060 | 3.709 | 4.325 |
| qlog records, JSON text sequence | 1467503 | 1180.7 ± 5.2% | 867.6 ± 0.4% | 725.2 ± 0.4% | 322.4 ± 0.7% | 392.0 ± 0.8% | 229.2 ± 2.4% | 1.361 | 1.628 | 3.662 | 3.012 | 5.151 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 778.9 ± 1.1% | 1012.9 ± 0.4% | 984.1 ± 0.3% | 259.8 ± 0.9% | 528.9 ± 0.9% | 258.8 ± 3.0% | 0.769 | 0.791 | 2.998 | 1.473 | 3.010 |
| qlog records, JSON text sequence | 1467503 | 667.2 ± 2.9% | 808.5 ± 5.0% | 779.8 ± 4.5% | 218.7 ± 3.8% | 584.8 ± 1.4% | 245.9 ± 1.3% | 0.825 | 0.856 | 3.051 | 1.141 | 2.714 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.1 ± 4.7% | 1130.4 ± 0.5% | 897.1 ± 1.4% | 333.5 ± 1.1% | 365.1 ± 1.9% | 313.1 ± 4.4% | 0.850 | 1.071 | 2.882 | 2.632 | 3.069 |
| qlog records, JSON text sequence | 1467503 | 805.4 ± 1.7% | 867.6 ± 0.4% | 725.2 ± 0.4% | 322.4 ± 0.7% | 392.0 ± 0.8% | 229.2 ± 2.4% | 0.928 | 1.111 | 2.498 | 2.054 | 3.514 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.769 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.791 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.825 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.856 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.850 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.928 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1033.8 ± 2.0% | 0.460 | 0.981 | 1.049 | 1.062 | 0.416 | 1.044 | 1.056 | 0.358 | 0.776 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 841.8 ± 0.5% | 0.733 | 1.019 | 0.988 | 1.005 | 0.387 | 1.006 | 1.000 | 0.348 | 0.888 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.5 ± 1.1% | 0.438 | 0.978 | 0.971 | 0.995 | 1.004 | 0.228 | 1.007 | 0.440 | 0.720 | 0.085 | 1.018 |
| qlog records, JSON text sequence | 1467503 | 1148.7 ± 0.6% | 0.692 | 0.933 | 0.983 | 0.984 | 0.989 | 0.222 | 0.986 | 0.411 | 0.696 | 0.104 | 1.014 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.062 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.056 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1033.8 ± 2.0% | 1013.0 ± 0.2% | 982.0 ± 1.3% | 260.1 ± 1.8% | 531.3 ± 1.0% | 259.7 ± 2.0% | 1.021 | 1.053 | 3.974 | 1.946 | 3.980 |
| qlog records, JSON text sequence | 1467503 | 841.8 ± 0.5% | 807.4 ± 0.5% | 809.4 ± 1.4% | 222.3 ± 1.2% | 587.4 ± 0.8% | 246.9 ± 0.4% | 1.043 | 1.040 | 3.787 | 1.433 | 3.409 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.5 ± 1.1% | 1129.5 ± 0.7% | 899.5 ± 0.8% | 332.5 ± 1.4% | 360.5 ± 4.3% | 312.2 ± 0.8% | 1.182 | 1.485 | 4.016 | 3.704 | 4.278 |
| qlog records, JSON text sequence | 1467503 | 1148.7 ± 0.6% | 859.8 ± 1.8% | 720.7 ± 0.6% | 322.3 ± 7.1% | 386.5 ± 1.2% | 231.6 ± 1.8% | 1.336 | 1.594 | 3.564 | 2.972 | 4.959 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1359.6 ± 1.4% | 1129.5 ± 0.7% | 899.5 ± 0.8% | 332.5 ± 1.4% | 360.5 ± 4.3% | 312.2 ± 0.8% | 1.204 | 1.512 | 4.089 | 3.771 | 4.355 |
| qlog records, JSON text sequence | 1467503 | 1164.6 ± 0.5% | 859.8 ± 1.8% | 720.7 ± 0.6% | 322.3 ± 7.1% | 386.5 ± 1.2% | 231.6 ± 1.8% | 1.354 | 1.616 | 3.613 | 3.013 | 5.027 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 802.3 ± 4.1% | 1013.0 ± 0.2% | 982.0 ± 1.3% | 260.1 ± 1.8% | 531.3 ± 1.0% | 259.7 ± 2.0% | 0.792 | 0.817 | 3.084 | 1.510 | 3.089 |
| qlog records, JSON text sequence | 1467503 | 747.7 ± 0.9% | 807.4 ± 0.5% | 809.4 ± 1.4% | 222.3 ± 1.2% | 587.4 ± 0.8% | 246.9 ± 0.4% | 0.926 | 0.924 | 3.364 | 1.273 | 3.028 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.1 ± 0.9% | 1129.5 ± 0.7% | 899.5 ± 0.8% | 332.5 ± 1.4% | 360.5 ± 4.3% | 312.2 ± 0.8% | 0.851 | 1.069 | 2.890 | 2.666 | 3.079 |
| qlog records, JSON text sequence | 1467503 | 799.4 ± 0.7% | 859.8 ± 1.8% | 720.7 ± 0.6% | 322.3 ± 7.1% | 386.5 ± 1.2% | 231.6 ± 1.8% | 0.930 | 1.109 | 2.480 | 2.068 | 3.451 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.792 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.817 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.926 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.924 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.851 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.930 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1039.8 ± 6.3% | 0.476 | 1.009 | 1.039 | 0.988 | 0.406 | 1.030 | 1.040 | 0.356 | 0.779 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 848.1 ± 0.3% | 0.735 | 1.036 | 1.018 | 1.007 | 0.390 | 1.023 | 1.002 | 0.343 | 0.686 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1321.5 ± 1.0% | 0.444 | 0.979 | 0.981 | 1.002 | 0.996 | 0.234 | 0.994 | 0.449 | 0.723 | 0.087 | 1.020 |
| qlog records, JSON text sequence | 1467503 | 1160.3 ± 3.0% | 0.702 | 0.913 | 0.972 | 0.983 | 0.986 | 0.225 | 0.985 | 0.413 | 0.692 | 0.104 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1039.8 ± 6.3% | 1007.3 ± 0.9% | 980.3 ± 1.0% | 260.1 ± 1.0% | 530.3 ± 3.3% | 258.6 ± 2.6% | 1.032 | 1.061 | 3.997 | 1.961 | 4.021 |
| qlog records, JSON text sequence | 1467503 | 848.1 ± 0.3% | 809.5 ± 0.9% | 823.7 ± 2.5% | 222.5 ± 4.1% | 587.6 ± 0.7% | 244.4 ± 4.6% | 1.048 | 1.030 | 3.812 | 1.443 | 3.470 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1321.5 ± 1.0% | 1130.3 ± 7.7% | 894.3 ± 0.4% | 319.7 ± 4.5% | 356.3 ± 1.5% | 310.5 ± 5.1% | 1.169 | 1.478 | 4.133 | 3.709 | 4.257 |
| qlog records, JSON text sequence | 1467503 | 1160.3 ± 3.0% | 872.5 ± 0.4% | 725.9 ± 1.1% | 317.7 ± 6.0% | 394.7 ± 0.3% | 233.4 ± 1.8% | 1.330 | 1.598 | 3.652 | 2.940 | 4.972 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1348.0 ± 3.0% | 1130.3 ± 7.7% | 894.3 ± 0.4% | 319.7 ± 4.5% | 356.3 ± 1.5% | 310.5 ± 5.1% | 1.193 | 1.507 | 4.216 | 3.783 | 4.342 |
| qlog records, JSON text sequence | 1467503 | 1171.5 ± 0.6% | 872.5 ± 0.4% | 725.9 ± 1.1% | 317.7 ± 6.0% | 394.7 ± 0.3% | 233.4 ± 1.8% | 1.343 | 1.614 | 3.688 | 2.968 | 5.021 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 810.4 ± 2.2% | 1007.3 ± 0.9% | 980.3 ± 1.0% | 260.1 ± 1.0% | 530.3 ± 3.3% | 258.6 ± 2.6% | 0.805 | 0.827 | 3.116 | 1.528 | 3.134 |
| qlog records, JSON text sequence | 1467503 | 582.0 ± 3.0% | 809.5 ± 0.9% | 823.7 ± 2.5% | 222.5 ± 4.1% | 587.6 ± 0.7% | 244.4 ± 4.6% | 0.719 | 0.707 | 2.616 | 0.990 | 2.381 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 956.1 ± 1.2% | 1130.3 ± 7.7% | 894.3 ± 0.4% | 319.7 ± 4.5% | 356.3 ± 1.5% | 310.5 ± 5.1% | 0.846 | 1.069 | 2.990 | 2.683 | 3.080 |
| qlog records, JSON text sequence | 1467503 | 803.1 ± 0.2% | 872.5 ± 0.4% | 725.9 ± 1.1% | 317.7 ± 6.0% | 394.7 ± 0.3% | 233.4 ± 1.8% | 0.920 | 1.106 | 2.528 | 2.035 | 3.441 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.805 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.827 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.719 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.707 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.846 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.920 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1040.6 ± 2.6% | 0.462 | 0.989 | 1.052 | 1.052 | 0.414 | 1.044 | 1.050 | 0.356 | 0.746 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 841.7 ± 0.6% | 0.732 | 1.024 | 1.009 | 1.003 | 0.389 | 1.011 | 1.004 | 0.343 | 0.807 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.2 ± 0.7% | 0.438 | 0.974 | 0.970 | 0.997 | 1.007 | 0.228 | 1.008 | 0.441 | 0.720 | 0.086 | 1.012 |
| qlog records, JSON text sequence | 1467503 | 1149.7 ± 0.3% | 0.692 | 0.944 | 0.997 | 0.996 | 0.997 | 0.223 | 0.998 | 0.409 | 0.703 | 0.105 | 1.028 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.052 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.050 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1040.6 ± 2.6% | 1003.9 ± 0.5% | 982.6 ± 2.8% | 260.0 ± 0.4% | 531.4 ± 0.3% | 257.8 ± 2.0% | 1.036 | 1.059 | 4.003 | 1.958 | 4.036 |
| qlog records, JSON text sequence | 1467503 | 841.7 ± 0.6% | 810.7 ± 0.2% | 777.3 ± 6.6% | 222.8 ± 1.4% | 587.5 ± 0.7% | 245.7 ± 1.4% | 1.038 | 1.083 | 3.777 | 1.433 | 3.426 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.2 ± 0.7% | 1139.3 ± 1.5% | 897.5 ± 0.3% | 332.5 ± 0.5% | 361.8 ± 3.4% | 311.2 ± 0.8% | 1.171 | 1.487 | 4.013 | 3.688 | 4.288 |
| qlog records, JSON text sequence | 1467503 | 1149.7 ± 0.3% | 872.8 ± 1.2% | 720.8 ± 1.0% | 321.3 ± 0.9% | 386.8 ± 3.7% | 228.2 ± 2.2% | 1.317 | 1.595 | 3.578 | 2.972 | 5.038 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1349.6 ± 1.5% | 1139.3 ± 1.5% | 897.5 ± 0.3% | 332.5 ± 0.5% | 361.8 ± 3.4% | 311.2 ± 0.8% | 1.185 | 1.504 | 4.059 | 3.730 | 4.337 |
| qlog records, JSON text sequence | 1467503 | 1182.3 ± 0.4% | 872.8 ± 1.2% | 720.8 ± 1.0% | 321.3 ± 0.9% | 386.8 ± 3.7% | 228.2 ± 2.2% | 1.355 | 1.640 | 3.679 | 3.056 | 5.181 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 775.8 ± 0.9% | 1003.9 ± 0.5% | 982.6 ± 2.8% | 260.0 ± 0.4% | 531.4 ± 0.3% | 257.8 ± 2.0% | 0.773 | 0.790 | 2.985 | 1.460 | 3.009 |
| qlog records, JSON text sequence | 1467503 | 679.0 ± 2.1% | 810.7 ± 0.2% | 777.3 ± 6.6% | 222.8 ± 1.4% | 587.5 ± 0.7% | 245.7 ± 1.4% | 0.838 | 0.874 | 3.048 | 1.156 | 2.764 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.3 ± 0.9% | 1139.3 ± 1.5% | 897.5 ± 0.3% | 332.5 ± 0.5% | 361.8 ± 3.4% | 311.2 ± 0.8% | 0.844 | 1.071 | 2.891 | 2.657 | 3.089 |
| qlog records, JSON text sequence | 1467503 | 808.6 ± 0.7% | 872.8 ± 1.2% | 720.8 ± 1.0% | 321.3 ± 0.9% | 386.8 ± 3.7% | 228.2 ± 2.2% | 0.926 | 1.122 | 2.516 | 2.090 | 3.543 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.773 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.790 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.838 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.874 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.844 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1042.8 ± 2.5% | 0.460 | 1.003 | 1.053 | 1.048 | 0.410 | 1.035 | 1.046 | 0.355 | 0.770 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 842.4 ± 0.8% | 0.734 | 1.021 | 1.006 | 1.004 | 0.387 | 1.012 | 1.000 | 0.347 | 0.887 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.6 ± 0.5% | 0.437 | 0.971 | 0.966 | 0.992 | 1.005 | 0.228 | 1.005 | 0.441 | 0.718 | 0.086 | 1.015 |
| qlog records, JSON text sequence | 1467503 | 1143.7 ± 5.6% | 0.693 | 0.947 | 0.985 | 0.988 | 0.990 | 0.223 | 0.990 | 0.416 | 0.700 | 0.105 | 1.015 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.053 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1042.8 ± 2.5% | 1000.1 ± 0.6% | 974.6 ± 1.7% | 258.8 ± 1.1% | 530.7 ± 3.5% | 256.4 ± 2.1% | 1.043 | 1.070 | 4.029 | 1.965 | 4.066 |
| qlog records, JSON text sequence | 1467503 | 842.4 ± 0.8% | 800.1 ± 1.1% | 777.7 ± 5.0% | 222.7 ± 0.6% | 587.4 ± 0.7% | 246.2 ± 1.6% | 1.053 | 1.083 | 3.782 | 1.434 | 3.422 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.6 ± 0.5% | 1133.1 ± 0.8% | 895.7 ± 0.9% | 333.1 ± 0.7% | 359.1 ± 2.4% | 312.4 ± 1.3% | 1.182 | 1.495 | 4.021 | 3.730 | 4.288 |
| qlog records, JSON text sequence | 1467503 | 1143.7 ± 5.6% | 863.2 ± 6.8% | 720.9 ± 0.4% | 320.6 ± 0.6% | 386.2 ± 2.1% | 230.8 ± 1.7% | 1.325 | 1.587 | 3.568 | 2.961 | 4.955 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1359.3 ± 1.5% | 1133.1 ± 0.8% | 895.7 ± 0.9% | 333.1 ± 0.7% | 359.1 ± 2.4% | 312.4 ± 1.3% | 1.200 | 1.518 | 4.080 | 3.785 | 4.351 |
| qlog records, JSON text sequence | 1467503 | 1160.5 ± 5.2% | 863.2 ± 6.8% | 720.9 ± 0.4% | 320.6 ± 0.6% | 386.2 ± 2.1% | 230.8 ± 1.7% | 1.344 | 1.610 | 3.620 | 3.005 | 5.027 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 802.6 ± 1.9% | 1000.1 ± 0.6% | 974.6 ± 1.7% | 258.8 ± 1.1% | 530.7 ± 3.5% | 256.4 ± 2.1% | 0.803 | 0.824 | 3.101 | 1.512 | 3.130 |
| qlog records, JSON text sequence | 1467503 | 747.0 ± 0.5% | 800.1 ± 1.1% | 777.7 ± 5.0% | 222.7 ± 0.6% | 587.4 ± 0.7% | 246.2 ± 1.6% | 0.934 | 0.961 | 3.354 | 1.272 | 3.034 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.9 ± 2.1% | 1133.1 ± 0.8% | 895.7 ± 0.9% | 333.1 ± 0.7% | 359.1 ± 2.4% | 312.4 ± 1.3% | 0.849 | 1.074 | 2.887 | 2.679 | 3.079 |
| qlog records, JSON text sequence | 1467503 | 800.7 ± 0.5% | 863.2 ± 6.8% | 720.9 ± 0.4% | 320.6 ± 0.6% | 386.2 ± 2.1% | 230.8 ± 1.7% | 0.928 | 1.111 | 2.498 | 2.073 | 3.469 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.803 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.824 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.934 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.849 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.928 of simdjson.
