# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1029.7 ± 4.0% | 0.477 | 1.009 | 1.042 | 1.012 | 0.409 | 1.048 | 0.994 | 0.358 | 0.785 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 842.8 ± 0.6% | 0.740 | 1.039 | 1.018 | 1.008 | 0.394 | 1.013 | 1.002 | 0.344 | 0.688 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1328.2 ± 5.2% | 0.443 | 0.980 | 0.978 | 1.003 | 1.003 | 0.235 | 1.000 | 0.447 | 0.720 | 0.086 | 1.019 |
| qlog records, JSON text sequence | 1467503 | 1142.4 ± 23.7% | 0.705 | 0.927 | 1.001 | 0.995 | 0.980 | 0.228 | 0.973 | 0.418 | 0.698 | 0.105 | 1.013 |

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
| CLDR supplemental, 34 texts | 920675 | 1029.7 ± 4.0% | 1002.3 ± 1.1% | 978.4 ± 0.8% | 259.4 ± 0.7% | 529.2 ± 0.5% | 251.2 ± 3.0% | 1.027 | 1.053 | 3.969 | 1.946 | 4.099 |
| qlog records, JSON text sequence | 1467503 | 842.8 ± 0.6% | 811.3 ± 1.0% | 793.0 ± 0.8% | 223.5 ± 4.1% | 585.8 ± 0.9% | 240.5 ± 3.8% | 1.039 | 1.063 | 3.772 | 1.439 | 3.504 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1328.2 ± 5.2% | 1128.3 ± 0.9% | 891.5 ± 1.0% | 318.9 ± 0.5% | 357.1 ± 0.8% | 306.6 ± 2.0% | 1.177 | 1.490 | 4.166 | 3.719 | 4.332 |
| qlog records, JSON text sequence | 1467503 | 1142.4 ± 23.7% | 840.2 ± 0.6% | 704.5 ± 0.3% | 226.8 ± 3.5% | 261.1 ± 1.9% | 229.4 ± 11.8% | 1.360 | 1.621 | 5.037 | 4.375 | 4.981 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1352.8 ± 2.0% | 1128.3 ± 0.9% | 891.5 ± 1.0% | 318.9 ± 0.5% | 357.1 ± 0.8% | 306.6 ± 2.0% | 1.199 | 1.517 | 4.243 | 3.788 | 4.412 |
| qlog records, JSON text sequence | 1467503 | 1157.0 ± 1.1% | 840.2 ± 0.6% | 704.5 ± 0.3% | 226.8 ± 3.5% | 261.1 ± 1.9% | 229.4 ± 11.8% | 1.377 | 1.642 | 5.101 | 4.431 | 5.044 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 808.0 ± 1.1% | 1002.3 ± 1.1% | 978.4 ± 0.8% | 259.4 ± 0.7% | 529.2 ± 0.5% | 251.2 ± 3.0% | 0.806 | 0.826 | 3.114 | 1.527 | 3.216 |
| qlog records, JSON text sequence | 1467503 | 579.7 ± 5.4% | 811.3 ± 1.0% | 793.0 ± 0.8% | 223.5 ± 4.1% | 585.8 ± 0.9% | 240.5 ± 3.8% | 0.715 | 0.731 | 2.594 | 0.990 | 2.410 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 956.7 ± 1.5% | 1128.3 ± 0.9% | 891.5 ± 1.0% | 318.9 ± 0.5% | 357.1 ± 0.8% | 306.6 ± 2.0% | 0.848 | 1.073 | 3.000 | 2.679 | 3.120 |
| qlog records, JSON text sequence | 1467503 | 796.8 ± 0.5% | 840.2 ± 0.6% | 704.5 ± 0.3% | 226.8 ± 3.5% | 261.1 ± 1.9% | 229.4 ± 11.8% | 0.948 | 1.131 | 3.513 | 3.052 | 3.474 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.806 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.826 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.715 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.731 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.848 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.948 of simdjson.

# bench-json, CLDR and qlog alone: null, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1023.2 ± 3.6% | 0.469 | 1.019 | 1.071 | 1.074 | 0.420 | 1.058 | 1.066 | 0.362 | 0.756 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 832.3 ± 3.4% | 0.744 | 1.032 | 1.016 | 0.997 | 0.394 | 1.019 | 0.998 | 0.352 | 0.674 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1325.8 ± 1.8% | 0.413 | 0.972 | 0.974 | 1.014 | 1.008 | 0.230 | 1.005 | 0.440 | 0.725 | 0.085 | 1.024 |
| qlog records, JSON text sequence | 1467503 | 1156.5 ± 1.7% | 0.689 | 0.938 | 0.976 | 0.990 | 0.989 | 0.222 | 0.977 | 0.409 | 0.690 | 0.102 | 1.005 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.074 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.058 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 1023.2 ± 3.6% | 1011.7 ± 11.4% | 985.1 ± 0.8% | 260.1 ± 2.1% | 530.5 ± 0.8% | 257.3 ± 3.7% | 1.011 | 1.039 | 3.933 | 1.929 | 3.977 |
| qlog records, JSON text sequence | 1467503 | 832.3 ± 3.4% | 805.9 ± 0.4% | 805.2 ± 6.0% | 224.1 ± 1.2% | 587.3 ± 0.4% | 241.8 ± 9.1% | 1.033 | 1.034 | 3.715 | 1.417 | 3.442 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1325.8 ± 1.8% | 1133.4 ± 1.6% | 898.0 ± 2.2% | 332.9 ± 1.5% | 364.3 ± 1.5% | 312.1 ± 1.3% | 1.170 | 1.476 | 3.983 | 3.639 | 4.248 |
| qlog records, JSON text sequence | 1467503 | 1156.5 ± 1.7% | 858.9 ± 1.3% | 720.4 ± 6.5% | 322.5 ± 1.0% | 378.1 ± 4.3% | 230.5 ± 1.2% | 1.346 | 1.605 | 3.586 | 3.059 | 5.018 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1357.1 ± 1.6% | 1133.4 ± 1.6% | 898.0 ± 2.2% | 332.9 ± 1.5% | 364.3 ± 1.5% | 312.1 ± 1.3% | 1.197 | 1.511 | 4.077 | 3.725 | 4.348 |
| qlog records, JSON text sequence | 1467503 | 1162.9 ± 4.4% | 858.9 ± 1.3% | 720.4 ± 6.5% | 322.5 ± 1.0% | 378.1 ± 4.3% | 230.5 ± 1.2% | 1.354 | 1.614 | 3.606 | 3.076 | 5.046 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 773.4 ± 1.9% | 1011.7 ± 11.4% | 985.1 ± 0.8% | 260.1 ± 2.1% | 530.5 ± 0.8% | 257.3 ± 3.7% | 0.764 | 0.785 | 2.973 | 1.458 | 3.006 |
| qlog records, JSON text sequence | 1467503 | 560.8 ± 2.5% | 805.9 ± 0.4% | 805.2 ± 6.0% | 224.1 ± 1.2% | 587.3 ± 0.4% | 241.8 ± 9.1% | 0.696 | 0.697 | 2.503 | 0.955 | 2.319 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.6 ± 1.3% | 1133.4 ± 1.6% | 898.0 ± 2.2% | 332.9 ± 1.5% | 364.3 ± 1.5% | 312.1 ± 1.3% | 0.848 | 1.071 | 2.889 | 2.640 | 3.081 |
| qlog records, JSON text sequence | 1467503 | 798.5 ± 4.0% | 858.9 ± 1.3% | 720.4 ± 6.5% | 322.5 ± 1.0% | 378.1 ± 4.3% | 230.5 ± 1.2% | 0.930 | 1.108 | 2.476 | 2.112 | 3.465 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.764 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.785 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.696 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.697 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.848 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.930 of simdjson.

# bench-json, CLDR and qlog alone: head, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1015.8 ± 5.0% | 0.473 | 1.014 | 1.078 | 1.082 | 0.422 | 1.071 | 1.079 | 0.365 | 0.786 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 839.8 ± 1.0% | 0.734 | 1.023 | 1.008 | 1.001 | 0.390 | 1.012 | 1.004 | 0.345 | 0.888 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1328.3 ± 1.6% | 0.438 | 0.974 | 0.965 | 0.992 | 1.004 | 0.228 | 1.000 | 0.439 | 0.719 | 0.086 | 1.008 |
| qlog records, JSON text sequence | 1467503 | 1157.5 ± 1.6% | 0.686 | 0.933 | 0.972 | 0.976 | 0.975 | 0.221 | 0.975 | 0.410 | 0.692 | 0.104 | 1.001 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.078 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.082 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.071 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 1015.8 ± 5.0% | 988.4 ± 2.3% | 968.0 ± 0.6% | 259.7 ± 0.8% | 530.4 ± 0.7% | 257.1 ± 4.4% | 1.028 | 1.049 | 3.912 | 1.915 | 3.951 |
| qlog records, JSON text sequence | 1467503 | 839.8 ± 1.0% | 797.6 ± 0.8% | 812.8 ± 1.1% | 223.1 ± 0.4% | 586.2 ± 5.7% | 243.9 ± 0.9% | 1.053 | 1.033 | 3.764 | 1.433 | 3.443 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1328.3 ± 1.6% | 1126.1 ± 1.4% | 895.9 ± 0.9% | 333.3 ± 1.1% | 361.3 ± 1.9% | 312.2 ± 0.5% | 1.180 | 1.483 | 3.985 | 3.676 | 4.254 |
| qlog records, JSON text sequence | 1467503 | 1157.5 ± 1.6% | 866.0 ± 3.4% | 719.9 ± 0.7% | 320.5 ± 0.6% | 390.6 ± 0.7% | 232.8 ± 1.1% | 1.337 | 1.608 | 3.611 | 2.963 | 4.972 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.2 ± 2.5% | 1126.1 ± 1.4% | 895.9 ± 0.9% | 333.3 ± 1.1% | 361.3 ± 1.9% | 312.2 ± 0.5% | 1.189 | 1.495 | 4.018 | 3.706 | 4.289 |
| qlog records, JSON text sequence | 1467503 | 1158.2 ± 4.8% | 866.0 ± 3.4% | 719.9 ± 0.7% | 320.5 ± 0.6% | 390.6 ± 0.7% | 232.8 ± 1.1% | 1.337 | 1.609 | 3.613 | 2.965 | 4.976 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 798.7 ± 2.2% | 988.4 ± 2.3% | 968.0 ± 0.6% | 259.7 ± 0.8% | 530.4 ± 0.7% | 257.1 ± 4.4% | 0.808 | 0.825 | 3.075 | 1.506 | 3.106 |
| qlog records, JSON text sequence | 1467503 | 746.0 ± 0.6% | 797.6 ± 0.8% | 812.8 ± 1.1% | 223.1 ± 0.4% | 586.2 ± 5.7% | 243.9 ± 0.9% | 0.935 | 0.918 | 3.343 | 1.273 | 3.059 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 955.0 ± 0.9% | 1126.1 ± 1.4% | 895.9 ± 0.9% | 333.3 ± 1.1% | 361.3 ± 1.9% | 312.2 ± 0.5% | 0.848 | 1.066 | 2.865 | 2.643 | 3.059 |
| qlog records, JSON text sequence | 1467503 | 800.7 ± 0.5% | 866.0 ± 3.4% | 719.9 ± 0.7% | 320.5 ± 0.6% | 390.6 ± 0.7% | 232.8 ± 1.1% | 0.925 | 1.112 | 2.498 | 2.050 | 3.440 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.808 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.825 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.935 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.918 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.848 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.925 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1027.2 ± 3.4% | 0.478 | 1.015 | 1.052 | 1.030 | 0.413 | 1.029 | 1.023 | 0.360 | 0.790 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 850.3 ± 1.4% | 0.736 | 1.037 | 1.012 | 1.002 | 0.392 | 1.011 | 1.003 | 0.345 | 0.685 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.9 ± 3.1% | 0.441 | 0.980 | 0.982 | 1.001 | 1.000 | 0.235 | 1.001 | 0.443 | 0.720 | 0.086 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1146.4 ± 0.8% | 0.704 | 0.925 | 0.998 | 0.988 | 0.995 | 0.229 | 0.988 | 0.412 | 0.694 | 0.104 | 1.013 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.052 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1027.2 ± 3.4% | 1018.6 ± 0.3% | 981.2 ± 0.9% | 259.7 ± 6.1% | 530.4 ± 4.1% | 257.5 ± 2.9% | 1.009 | 1.047 | 3.956 | 1.937 | 3.989 |
| qlog records, JSON text sequence | 1467503 | 850.3 ± 1.4% | 812.4 ± 0.3% | 784.0 ± 5.1% | 223.2 ± 2.9% | 586.9 ± 0.6% | 237.2 ± 1.4% | 1.047 | 1.085 | 3.810 | 1.449 | 3.584 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.9 ± 3.1% | 1131.6 ± 0.6% | 893.4 ± 0.3% | 320.0 ± 0.5% | 354.6 ± 2.2% | 314.2 ± 2.5% | 1.179 | 1.493 | 4.168 | 3.762 | 4.246 |
| qlog records, JSON text sequence | 1467503 | 1146.4 ± 0.8% | 860.5 ± 0.6% | 717.5 ± 2.6% | 317.9 ± 6.6% | 380.8 ± 1.7% | 230.6 ± 4.2% | 1.332 | 1.598 | 3.606 | 3.010 | 4.971 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1363.1 ± 0.2% | 1131.6 ± 0.6% | 893.4 ± 0.3% | 320.0 ± 0.5% | 354.6 ± 2.2% | 314.2 ± 2.5% | 1.205 | 1.526 | 4.259 | 3.844 | 4.338 |
| qlog records, JSON text sequence | 1467503 | 1161.2 ± 1.0% | 860.5 ± 0.6% | 717.5 ± 2.6% | 317.9 ± 6.6% | 380.8 ± 1.7% | 230.6 ± 4.2% | 1.350 | 1.618 | 3.652 | 3.049 | 5.035 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 812.0 ± 1.4% | 1018.6 ± 0.3% | 981.2 ± 0.9% | 259.7 ± 6.1% | 530.4 ± 4.1% | 257.5 ± 2.9% | 0.797 | 0.828 | 3.127 | 1.531 | 3.153 |
| qlog records, JSON text sequence | 1467503 | 582.6 ± 0.6% | 812.4 ± 0.3% | 784.0 ± 5.1% | 223.2 ± 2.9% | 586.9 ± 0.6% | 237.2 ± 1.4% | 0.717 | 0.743 | 2.610 | 0.993 | 2.456 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 960.1 ± 3.3% | 1131.6 ± 0.6% | 893.4 ± 0.3% | 320.0 ± 0.5% | 354.6 ± 2.2% | 314.2 ± 2.5% | 0.848 | 1.075 | 3.000 | 2.708 | 3.056 |
| qlog records, JSON text sequence | 1467503 | 795.2 ± 0.7% | 860.5 ± 0.6% | 717.5 ± 2.6% | 317.9 ± 6.6% | 380.8 ± 1.7% | 230.6 ± 4.2% | 0.924 | 1.108 | 2.501 | 2.088 | 3.448 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.797 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.828 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.717 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.743 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.848 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.924 of simdjson.

# bench-json, CLDR and qlog alone: null, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1016.6 ± 3.2% | 0.473 | 1.045 | 1.081 | 1.078 | 0.422 | 1.064 | 1.080 | 0.364 | 0.761 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 827.4 ± 0.6% | 0.745 | 1.032 | 1.019 | 1.001 | 0.396 | 1.022 | 1.002 | 0.354 | 0.674 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.1 ± 2.7% | 0.404 | 0.964 | 0.963 | 1.000 | 1.002 | 0.228 | 1.002 | 0.421 | 0.723 | 0.086 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1157.3 ± 1.7% | 0.689 | 0.947 | 0.983 | 0.988 | 0.988 | 0.220 | 0.988 | 0.396 | 0.661 | 0.104 | 1.017 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.081 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.078 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.080 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1016.6 ± 3.2% | 987.1 ± 0.6% | 971.1 ± 2.7% | 260.2 ± 1.8% | 529.5 ± 1.8% | 257.3 ± 3.7% | 1.030 | 1.047 | 3.907 | 1.920 | 3.950 |
| qlog records, JSON text sequence | 1467503 | 827.4 ± 0.6% | 773.9 ± 0.3% | 799.3 ± 6.5% | 223.3 ± 1.0% | 584.7 ± 1.2% | 240.6 ± 2.1% | 1.069 | 1.035 | 3.706 | 1.415 | 3.439 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.1 ± 2.7% | 1131.4 ± 1.4% | 896.5 ± 5.1% | 333.3 ± 0.6% | 366.1 ± 1.4% | 310.4 ± 4.6% | 1.180 | 1.489 | 4.005 | 3.647 | 4.302 |
| qlog records, JSON text sequence | 1467503 | 1157.3 ± 1.7% | 870.6 ± 0.8% | 722.2 ± 0.8% | 316.5 ± 5.9% | 379.0 ± 0.9% | 231.1 ± 3.2% | 1.329 | 1.602 | 3.656 | 3.053 | 5.007 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1363.8 ± 4.6% | 1131.4 ± 1.4% | 896.5 ± 5.1% | 333.3 ± 0.6% | 366.1 ± 1.4% | 310.4 ± 4.6% | 1.205 | 1.521 | 4.091 | 3.725 | 4.394 |
| qlog records, JSON text sequence | 1467503 | 1177.3 ± 0.8% | 870.6 ± 0.8% | 722.2 ± 0.8% | 316.5 ± 5.9% | 379.0 ± 0.9% | 231.1 ± 3.2% | 1.352 | 1.630 | 3.720 | 3.106 | 5.094 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 773.7 ± 0.6% | 987.1 ± 0.6% | 971.1 ± 2.7% | 260.2 ± 1.8% | 529.5 ± 1.8% | 257.3 ± 3.7% | 0.784 | 0.797 | 2.973 | 1.461 | 3.006 |
| qlog records, JSON text sequence | 1467503 | 557.5 ± 1.1% | 773.9 ± 0.3% | 799.3 ± 6.5% | 223.3 ± 1.0% | 584.7 ± 1.2% | 240.6 ± 2.1% | 0.720 | 0.697 | 2.497 | 0.953 | 2.317 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 965.5 ± 1.3% | 1131.4 ± 1.4% | 896.5 ± 5.1% | 333.3 ± 0.6% | 366.1 ± 1.4% | 310.4 ± 4.6% | 0.853 | 1.077 | 2.896 | 2.637 | 3.111 |
| qlog records, JSON text sequence | 1467503 | 765.1 ± 0.4% | 870.6 ± 0.8% | 722.2 ± 0.8% | 316.5 ± 5.9% | 379.0 ± 0.9% | 231.1 ± 3.2% | 0.879 | 1.059 | 2.417 | 2.019 | 3.311 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.784 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.797 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.720 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.697 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.853 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.879 of simdjson.

# bench-json, CLDR and qlog alone: head, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1042.8 ± 6.2% | 0.461 | 0.982 | 1.054 | 1.054 | 0.413 | 1.043 | 1.051 | 0.355 | 0.767 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 840.6 ± 0.4% | 0.734 | 1.027 | 1.007 | 1.004 | 0.392 | 1.012 | 1.005 | 0.345 | 0.890 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1325.8 ± 2.1% | 0.440 | 0.978 | 0.964 | 0.997 | 1.012 | 0.229 | 1.010 | 0.441 | 0.721 | 0.086 | 1.013 |
| qlog records, JSON text sequence | 1467503 | 1153.9 ± 1.2% | 0.690 | 0.940 | 0.978 | 0.984 | 0.978 | 0.221 | 0.984 | 0.410 | 0.693 | 0.104 | 1.008 |

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
| CLDR supplemental, 34 texts | 920675 | 1042.8 ± 6.2% | 1011.6 ± 0.3% | 979.8 ± 0.5% | 259.2 ± 1.0% | 529.7 ± 0.7% | 256.9 ± 3.6% | 1.031 | 1.064 | 4.023 | 1.968 | 4.059 |
| qlog records, JSON text sequence | 1467503 | 840.6 ± 0.4% | 811.0 ± 0.4% | 792.6 ± 2.2% | 220.8 ± 2.7% | 587.3 ± 0.9% | 244.3 ± 1.0% | 1.036 | 1.061 | 3.808 | 1.431 | 3.441 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1325.8 ± 2.1% | 1129.0 ± 0.7% | 895.4 ± 1.0% | 330.9 ± 2.0% | 358.9 ± 2.8% | 310.4 ± 1.1% | 1.174 | 1.481 | 4.007 | 3.694 | 4.271 |
| qlog records, JSON text sequence | 1467503 | 1153.9 ± 1.2% | 862.4 ± 0.4% | 722.2 ± 0.3% | 321.0 ± 0.3% | 379.4 ± 6.1% | 231.2 ± 0.8% | 1.338 | 1.598 | 3.595 | 3.041 | 4.991 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1343.5 ± 1.5% | 1129.0 ± 0.7% | 895.4 ± 1.0% | 330.9 ± 2.0% | 358.9 ± 2.8% | 310.4 ± 1.1% | 1.190 | 1.500 | 4.060 | 3.743 | 4.328 |
| qlog records, JSON text sequence | 1467503 | 1163.4 ± 0.4% | 862.4 ± 0.4% | 722.2 ± 0.3% | 321.0 ± 0.3% | 379.4 ± 6.1% | 231.2 ± 0.8% | 1.349 | 1.611 | 3.624 | 3.066 | 5.032 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 799.8 ± 1.3% | 1011.6 ± 0.3% | 979.8 ± 0.5% | 259.2 ± 1.0% | 529.7 ± 0.7% | 256.9 ± 3.6% | 0.791 | 0.816 | 3.086 | 1.510 | 3.113 |
| qlog records, JSON text sequence | 1467503 | 748.1 ± 0.8% | 811.0 ± 0.4% | 792.6 ± 2.2% | 220.8 ± 2.7% | 587.3 ± 0.9% | 244.3 ± 1.0% | 0.922 | 0.944 | 3.389 | 1.274 | 3.063 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 956.1 ± 0.8% | 1129.0 ± 0.7% | 895.4 ± 1.0% | 330.9 ± 2.0% | 358.9 ± 2.8% | 310.4 ± 1.1% | 0.847 | 1.068 | 2.889 | 2.664 | 3.080 |
| qlog records, JSON text sequence | 1467503 | 800.0 ± 0.6% | 862.4 ± 0.4% | 722.2 ± 0.3% | 321.0 ± 0.3% | 379.4 ± 6.1% | 231.2 ± 0.8% | 0.928 | 1.108 | 2.492 | 2.109 | 3.460 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.791 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.816 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.922 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.944 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.847 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.928 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1042.9 ± 6.0% | 0.471 | 0.992 | 1.020 | 1.019 | 0.405 | 1.015 | 1.022 | 0.355 | 0.780 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 849.8 ± 0.6% | 0.734 | 1.035 | 1.019 | 0.999 | 0.392 | 1.015 | 1.003 | 0.340 | 0.684 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.6 ± 0.8% | 0.442 | 0.980 | 0.978 | 1.004 | 0.994 | 0.233 | 0.999 | 0.445 | 0.718 | 0.086 | 1.016 |
| qlog records, JSON text sequence | 1467503 | 1146.2 ± 1.0% | 0.704 | 0.929 | 0.993 | 0.993 | 0.987 | 0.227 | 0.983 | 0.416 | 0.693 | 0.105 | 1.008 |

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
| CLDR supplemental, 34 texts | 920675 | 1042.9 ± 6.0% | 1006.2 ± 8.5% | 983.0 ± 0.3% | 260.0 ± 3.6% | 531.2 ± 0.7% | 258.5 ± 2.0% | 1.036 | 1.061 | 4.010 | 1.963 | 4.035 |
| qlog records, JSON text sequence | 1467503 | 849.8 ± 0.6% | 811.2 ± 0.3% | 823.3 ± 1.3% | 223.5 ± 0.5% | 587.8 ± 0.7% | 245.3 ± 1.4% | 1.048 | 1.032 | 3.803 | 1.446 | 3.464 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.6 ± 0.8% | 1136.4 ± 7.3% | 895.9 ± 0.6% | 320.7 ± 0.4% | 354.4 ± 3.0% | 311.4 ± 1.5% | 1.174 | 1.490 | 4.161 | 3.766 | 4.286 |
| qlog records, JSON text sequence | 1467503 | 1146.2 ± 1.0% | 862.9 ± 0.4% | 717.5 ± 0.3% | 317.9 ± 0.8% | 382.2 ± 1.2% | 230.4 ± 3.0% | 1.328 | 1.598 | 3.606 | 2.999 | 4.975 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1355.5 ± 4.5% | 1136.4 ± 7.3% | 895.9 ± 0.6% | 320.7 ± 0.4% | 354.4 ± 3.0% | 311.4 ± 1.5% | 1.193 | 1.513 | 4.227 | 3.825 | 4.353 |
| qlog records, JSON text sequence | 1467503 | 1155.7 ± 1.0% | 862.9 ± 0.4% | 717.5 ± 0.3% | 317.9 ± 0.8% | 382.2 ± 1.2% | 230.4 ± 3.0% | 1.339 | 1.611 | 3.636 | 3.024 | 5.016 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 813.4 ± 20.1% | 1006.2 ± 8.5% | 983.0 ± 0.3% | 260.0 ± 3.6% | 531.2 ± 0.7% | 258.5 ± 2.0% | 0.808 | 0.827 | 3.128 | 1.531 | 3.147 |
| qlog records, JSON text sequence | 1467503 | 581.6 ± 1.1% | 811.2 ± 0.3% | 823.3 ± 1.3% | 223.5 ± 0.5% | 587.8 ± 0.7% | 245.3 ± 1.4% | 0.717 | 0.706 | 2.602 | 0.989 | 2.371 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 957.8 ± 22.4% | 1136.4 ± 7.3% | 895.9 ± 0.6% | 320.7 ± 0.4% | 354.4 ± 3.0% | 311.4 ± 1.5% | 0.843 | 1.069 | 2.987 | 2.703 | 3.076 |
| qlog records, JSON text sequence | 1467503 | 793.8 ± 0.4% | 862.9 ± 0.4% | 717.5 ± 0.3% | 317.9 ± 0.8% | 382.2 ± 1.2% | 230.4 ± 3.0% | 0.920 | 1.106 | 2.497 | 2.077 | 3.445 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.717 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.706 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.920 of simdjson.

# bench-json, CLDR and qlog alone: null, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1005.6 ± 5.2% | 0.478 | 1.026 | 1.085 | 1.088 | 0.426 | 1.073 | 1.084 | 0.368 | 0.769 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 827.0 ± 1.3% | 0.744 | 1.033 | 1.019 | 1.001 | 0.396 | 1.024 | 0.999 | 0.349 | 0.677 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1330.6 ± 5.7% | 0.406 | 0.966 | 0.960 | 1.011 | 1.000 | 0.230 | 1.004 | 0.443 | 0.722 | 0.086 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1158.1 ± 1.5% | 0.689 | 0.942 | 0.984 | 0.988 | 0.987 | 0.223 | 0.988 | 0.413 | 0.699 | 0.105 | 1.017 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.085 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.088 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.073 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.084 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1005.6 ± 5.2% | 1004.5 ± 2.7% | 972.0 ± 0.5% | 259.8 ± 0.7% | 529.9 ± 0.5% | 254.9 ± 3.7% | 1.001 | 1.035 | 3.871 | 1.898 | 3.945 |
| qlog records, JSON text sequence | 1467503 | 827.0 ± 1.3% | 795.4 ± 5.0% | 778.8 ± 3.6% | 221.5 ± 3.5% | 586.8 ± 2.1% | 241.2 ± 4.0% | 1.040 | 1.062 | 3.734 | 1.409 | 3.428 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1330.6 ± 5.7% | 1128.8 ± 2.2% | 897.5 ± 0.7% | 331.3 ± 0.5% | 365.1 ± 1.2% | 311.5 ± 0.8% | 1.179 | 1.483 | 4.016 | 3.645 | 4.272 |
| qlog records, JSON text sequence | 1467503 | 1158.1 ± 1.5% | 869.6 ± 1.0% | 724.5 ± 0.4% | 322.2 ± 1.4% | 377.5 ± 0.7% | 233.0 ± 5.5% | 1.332 | 1.598 | 3.595 | 3.068 | 4.970 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1352.9 ± 1.6% | 1128.8 ± 2.2% | 897.5 ± 0.7% | 331.3 ± 0.5% | 365.1 ± 1.2% | 311.5 ± 0.8% | 1.198 | 1.507 | 4.083 | 3.706 | 4.344 |
| qlog records, JSON text sequence | 1467503 | 1177.6 ± 1.8% | 869.6 ± 1.0% | 724.5 ± 0.4% | 322.2 ± 1.4% | 377.5 ± 0.7% | 233.0 ± 5.5% | 1.354 | 1.625 | 3.655 | 3.120 | 5.053 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 773.4 ± 0.6% | 1004.5 ± 2.7% | 972.0 ± 0.5% | 259.8 ± 0.7% | 529.9 ± 0.5% | 254.9 ± 3.7% | 0.770 | 0.796 | 2.977 | 1.459 | 3.034 |
| qlog records, JSON text sequence | 1467503 | 559.9 ± 0.9% | 795.4 ± 5.0% | 778.8 ± 3.6% | 221.5 ± 3.5% | 586.8 ± 2.1% | 241.2 ± 4.0% | 0.704 | 0.719 | 2.528 | 0.954 | 2.321 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 960.8 ± 1.1% | 1128.8 ± 2.2% | 897.5 ± 0.7% | 331.3 ± 0.5% | 365.1 ± 1.2% | 311.5 ± 0.8% | 0.851 | 1.071 | 2.900 | 2.632 | 3.085 |
| qlog records, JSON text sequence | 1467503 | 809.5 ± 0.4% | 869.6 ± 1.0% | 724.5 ± 0.4% | 322.2 ± 1.4% | 377.5 ± 0.7% | 233.0 ± 5.5% | 0.931 | 1.117 | 2.513 | 2.145 | 3.474 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.770 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.796 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.704 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.719 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.851 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.931 of simdjson.

# bench-json, CLDR and qlog alone: head, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 942.0 ± 4.5% | 0.495 | 1.037 | 1.090 | 1.094 | 0.444 | 1.081 | 1.094 | 0.393 | 0.858 | 0.104 |
| qlog records, JSON text sequence | 1467503 | 833.9 ± 5.4% | 0.740 | 1.032 | 1.013 | 1.009 | 0.395 | 1.017 | 1.010 | 0.348 | 0.894 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1319.5 ± 1.5% | 0.441 | 0.981 | 0.966 | 1.003 | 1.011 | 0.229 | 1.012 | 0.438 | 0.724 | 0.086 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1149.6 ± 37.6% | 0.691 | 0.945 | 0.982 | 0.988 | 0.991 | 0.223 | 0.987 | 0.411 | 0.696 | 0.105 | 1.014 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.090 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.094 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.081 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.094 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 942.0 ± 4.5% | 1023.9 ± 0.3% | 979.5 ± 0.5% | 254.7 ± 1.0% | 530.5 ± 0.1% | 257.9 ± 3.7% | 0.920 | 0.962 | 3.698 | 1.776 | 3.653 |
| qlog records, JSON text sequence | 1467503 | 833.9 ± 5.4% | 812.7 ± 0.6% | 783.9 ± 2.9% | 215.7 ± 7.8% | 586.9 ± 0.7% | 242.1 ± 1.9% | 1.026 | 1.064 | 3.865 | 1.421 | 3.444 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1319.5 ± 1.5% | 1041.6 ± 0.6% | 897.5 ± 0.8% | 331.8 ± 0.4% | 353.1 ± 3.5% | 310.6 ± 0.8% | 1.267 | 1.470 | 3.977 | 3.737 | 4.248 |
| qlog records, JSON text sequence | 1467503 | 1149.6 ± 37.6% | 857.5 ± 1.0% | 719.7 ± 1.0% | 320.2 ± 1.6% | 389.4 ± 1.4% | 228.7 ± 9.1% | 1.341 | 1.597 | 3.591 | 2.953 | 5.026 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1349.1 ± 2.1% | 1041.6 ± 0.6% | 897.5 ± 0.8% | 331.8 ± 0.4% | 353.1 ± 3.5% | 310.6 ± 0.8% | 1.295 | 1.503 | 4.067 | 3.821 | 4.343 |
| qlog records, JSON text sequence | 1467503 | 1165.7 ± 0.7% | 857.5 ± 1.0% | 719.7 ± 1.0% | 320.2 ± 1.6% | 389.4 ± 1.4% | 228.7 ± 9.1% | 1.359 | 1.620 | 3.641 | 2.994 | 5.096 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 808.6 ± 2.0% | 1023.9 ± 0.3% | 979.5 ± 0.5% | 254.7 ± 1.0% | 530.5 ± 0.1% | 257.9 ± 3.7% | 0.790 | 0.826 | 3.175 | 1.524 | 3.136 |
| qlog records, JSON text sequence | 1467503 | 745.7 ± 5.2% | 812.7 ± 0.6% | 783.9 ± 2.9% | 215.7 ± 7.8% | 586.9 ± 0.7% | 242.1 ± 1.9% | 0.917 | 0.951 | 3.457 | 1.270 | 3.079 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 955.2 ± 3.1% | 1041.6 ± 0.6% | 897.5 ± 0.8% | 331.8 ± 0.4% | 353.1 ± 3.5% | 310.6 ± 0.8% | 0.917 | 1.064 | 2.879 | 2.705 | 3.075 |
| qlog records, JSON text sequence | 1467503 | 800.6 ± 5.8% | 857.5 ± 1.0% | 719.7 ± 1.0% | 320.2 ± 1.6% | 389.4 ± 1.4% | 228.7 ± 9.1% | 0.934 | 1.112 | 2.500 | 2.056 | 3.500 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.920 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.790 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.826 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.917 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.917 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.934 of simdjson.
