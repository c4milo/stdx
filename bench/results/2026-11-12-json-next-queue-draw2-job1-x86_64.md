# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1318.1 ± 4.1% | 0.488 | 1.028 | 1.014 | 1.012 | 0.380 | 1.012 | 1.007 | 0.355 | 0.794 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 1063.4 ± 2.8% | 0.799 | 1.026 | 1.037 | 1.032 | 0.377 | 1.026 | 1.026 | 0.345 | 0.698 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1745.0 ± 1.2% | 0.423 | 0.976 | 0.969 | 1.007 | 1.008 | 0.250 | 1.003 | 0.443 | 0.738 | 0.088 | 1.021 |
| qlog records, JSON text sequence | 1467503 | 1482.4 ± 1.7% | 0.683 | 0.957 | 0.993 | 0.993 | 0.991 | 0.253 | 0.990 | 0.422 | 0.727 | 0.114 | 1.009 |

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
| CLDR supplemental, 34 texts | 920675 | 1318.1 ± 4.1% | 1344.6 ± 0.9% | 1209.5 ± 1.5% | 357.1 ± 1.6% | 663.4 ± 6.0% | 321.1 ± 5.3% | 0.980 | 1.090 | 3.691 | 1.987 | 4.106 |
| qlog records, JSON text sequence | 1467503 | 1063.4 ± 2.8% | 1059.8 ± 2.3% | 1072.7 ± 0.2% | 301.8 ± 1.9% | 730.9 ± 1.4% | 319.0 ± 0.9% | 1.003 | 0.991 | 3.523 | 1.455 | 3.333 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1745.0 ± 1.2% | 1577.7 ± 1.3% | 1174.4 ± 1.5% | 424.7 ± 5.4% | 459.9 ± 0.5% | 413.3 ± 0.8% | 1.106 | 1.486 | 4.109 | 3.794 | 4.222 |
| qlog records, JSON text sequence | 1467503 | 1482.4 ± 1.7% | 1318.2 ± 0.5% | 901.3 ± 0.9% | 424.6 ± 1.3% | 497.9 ± 0.6% | 326.5 ± 6.5% | 1.125 | 1.645 | 3.491 | 2.977 | 4.540 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1781.3 ± 2.1% | 1577.7 ± 1.3% | 1174.4 ± 1.5% | 424.7 ± 5.4% | 459.9 ± 0.5% | 413.3 ± 0.8% | 1.129 | 1.517 | 4.195 | 3.873 | 4.310 |
| qlog records, JSON text sequence | 1467503 | 1495.1 ± 0.3% | 1318.2 ± 0.5% | 901.3 ± 0.9% | 424.6 ± 1.3% | 497.9 ± 0.6% | 326.5 ± 6.5% | 1.134 | 1.659 | 3.521 | 3.003 | 4.579 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1046.0 ± 0.5% | 1344.6 ± 0.9% | 1209.5 ± 1.5% | 357.1 ± 1.6% | 663.4 ± 6.0% | 321.1 ± 5.3% | 0.778 | 0.865 | 2.929 | 1.577 | 3.258 |
| qlog records, JSON text sequence | 1467503 | 742.4 ± 0.3% | 1059.8 ± 2.3% | 1072.7 ± 0.2% | 301.8 ± 1.9% | 730.9 ± 1.4% | 319.0 ± 0.9% | 0.700 | 0.692 | 2.460 | 1.016 | 2.327 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1288.2 ± 3.8% | 1577.7 ± 1.3% | 1174.4 ± 1.5% | 424.7 ± 5.4% | 459.9 ± 0.5% | 413.3 ± 0.8% | 0.816 | 1.097 | 3.033 | 2.801 | 3.117 |
| qlog records, JSON text sequence | 1467503 | 1077.5 ± 0.3% | 1318.2 ± 0.5% | 901.3 ± 0.9% | 424.6 ± 1.3% | 497.9 ± 0.6% | 326.5 ± 6.5% | 0.817 | 1.195 | 2.537 | 2.164 | 3.300 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.778 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.865 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.700 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.692 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.816 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.817 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1421.7 ± 0.7% | 0.429 | 0.895 | 0.934 | 0.949 | 0.355 | 0.959 | 0.953 | 0.331 | 0.749 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1089.9 ± 4.6% | 0.739 | 0.984 | 0.949 | 0.951 | 0.365 | 0.980 | 0.961 | 0.338 | 0.811 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1757.7 ± 1.1% | 0.398 | 0.961 | 0.965 | 0.996 | 1.003 | 0.248 | 1.003 | 0.441 | 0.740 | 0.071 | 1.019 |
| qlog records, JSON text sequence | 1467503 | 1486.7 ± 3.1% | 0.684 | 0.947 | 0.994 | 0.998 | 0.991 | 0.249 | 0.990 | 0.422 | 0.729 | 0.095 | 1.013 |

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
| CLDR supplemental, 34 texts | 920675 | 1421.7 ± 0.7% | 1337.0 ± 0.9% | 1206.2 ± 1.7% | 357.9 ± 8.4% | 666.1 ± 0.8% | 320.6 ± 2.0% | 1.063 | 1.179 | 3.973 | 2.134 | 4.435 |
| qlog records, JSON text sequence | 1467503 | 1089.9 ± 4.6% | 1052.5 ± 0.5% | 1083.0 ± 0.6% | 304.1 ± 1.0% | 731.0 ± 5.1% | 315.9 ± 1.8% | 1.036 | 1.006 | 3.584 | 1.491 | 3.450 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1757.7 ± 1.1% | 1595.8 ± 1.3% | 1158.4 ± 7.6% | 423.7 ± 1.0% | 456.4 ± 3.5% | 418.0 ± 0.7% | 1.101 | 1.517 | 4.148 | 3.851 | 4.205 |
| qlog records, JSON text sequence | 1467503 | 1486.7 ± 3.1% | 1300.5 ± 0.6% | 905.4 ± 0.8% | 428.6 ± 0.7% | 496.8 ± 0.3% | 332.0 ± 7.0% | 1.143 | 1.642 | 3.468 | 2.993 | 4.478 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1790.7 ± 0.6% | 1595.8 ± 1.3% | 1158.4 ± 7.6% | 423.7 ± 1.0% | 456.4 ± 3.5% | 418.0 ± 0.7% | 1.122 | 1.546 | 4.227 | 3.924 | 4.284 |
| qlog records, JSON text sequence | 1467503 | 1506.3 ± 0.3% | 1300.5 ± 0.6% | 905.4 ± 0.8% | 428.6 ± 0.7% | 496.8 ± 0.3% | 332.0 ± 7.0% | 1.158 | 1.664 | 3.514 | 3.032 | 4.537 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1065.1 ± 1.9% | 1337.0 ± 0.9% | 1206.2 ± 1.7% | 357.9 ± 8.4% | 666.1 ± 0.8% | 320.6 ± 2.0% | 0.797 | 0.883 | 2.976 | 1.599 | 3.322 |
| qlog records, JSON text sequence | 1467503 | 883.4 ± 0.4% | 1052.5 ± 0.5% | 1083.0 ± 0.6% | 304.1 ± 1.0% | 731.0 ± 5.1% | 315.9 ± 1.8% | 0.839 | 0.816 | 2.905 | 1.208 | 2.797 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1300.4 ± 0.7% | 1595.8 ± 1.3% | 1158.4 ± 7.6% | 423.7 ± 1.0% | 456.4 ± 3.5% | 418.0 ± 0.7% | 0.815 | 1.123 | 3.069 | 2.849 | 3.111 |
| qlog records, JSON text sequence | 1467503 | 1084.1 ± 0.4% | 1300.5 ± 0.6% | 905.4 ± 0.8% | 428.6 ± 0.7% | 496.8 ± 0.3% | 332.0 ± 7.0% | 0.834 | 1.197 | 2.529 | 2.182 | 3.265 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.797 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.883 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.839 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.816 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.815 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.834 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1416.5 ± 1.7% | 0.430 | 0.922 | 0.940 | 0.938 | 0.356 | 0.961 | 0.930 | 0.333 | 0.729 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1088.2 ± 4.4% | 0.741 | 0.987 | 0.948 | 0.954 | 0.365 | 0.982 | 0.969 | 0.339 | 0.827 | 0.118 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1765.7 ± 0.7% | 0.419 | 0.956 | 0.962 | 0.991 | 0.995 | 0.247 | 0.992 | 0.439 | 0.735 | 0.087 | 1.013 |
| qlog records, JSON text sequence | 1467503 | 1489.0 ± 0.4% | 0.682 | 0.943 | 0.990 | 0.993 | 0.988 | 0.249 | 0.988 | 0.421 | 0.726 | 0.113 | 1.008 |

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
| CLDR supplemental, 34 texts | 920675 | 1416.5 ± 1.7% | 1353.4 ± 0.6% | 1216.1 ± 1.6% | 357.3 ± 1.6% | 669.0 ± 2.5% | 325.1 ± 2.2% | 1.047 | 1.165 | 3.965 | 2.117 | 4.357 |
| qlog records, JSON text sequence | 1467503 | 1088.2 ± 4.4% | 1054.7 ± 0.3% | 1082.0 ± 0.4% | 291.2 ± 1.2% | 730.2 ± 0.4% | 316.7 ± 0.5% | 1.032 | 1.006 | 3.737 | 1.490 | 3.437 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1765.7 ± 0.7% | 1592.4 ± 0.8% | 1170.0 ± 6.3% | 424.2 ± 0.8% | 446.7 ± 3.2% | 417.2 ± 1.1% | 1.109 | 1.509 | 4.163 | 3.953 | 4.233 |
| qlog records, JSON text sequence | 1467503 | 1489.0 ± 0.4% | 1313.8 ± 0.6% | 905.6 ± 0.4% | 427.8 ± 0.4% | 499.8 ± 0.3% | 316.8 ± 5.2% | 1.133 | 1.644 | 3.481 | 2.979 | 4.701 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1788.8 ± 1.1% | 1592.4 ± 0.8% | 1170.0 ± 6.3% | 424.2 ± 0.8% | 446.7 ± 3.2% | 417.2 ± 1.1% | 1.123 | 1.529 | 4.217 | 4.005 | 4.288 |
| qlog records, JSON text sequence | 1467503 | 1501.2 ± 3.1% | 1313.8 ± 0.6% | 905.6 ± 0.4% | 427.8 ± 0.4% | 499.8 ± 0.3% | 316.8 ± 5.2% | 1.143 | 1.658 | 3.509 | 3.004 | 4.739 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1032.7 ± 0.9% | 1353.4 ± 0.6% | 1216.1 ± 1.6% | 357.3 ± 1.6% | 669.0 ± 2.5% | 325.1 ± 2.2% | 0.763 | 0.849 | 2.891 | 1.544 | 3.176 |
| qlog records, JSON text sequence | 1467503 | 899.5 ± 0.3% | 1054.7 ± 0.3% | 1082.0 ± 0.4% | 291.2 ± 1.2% | 730.2 ± 0.4% | 316.7 ± 0.5% | 0.853 | 0.831 | 3.089 | 1.232 | 2.841 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1298.2 ± 0.6% | 1592.4 ± 0.8% | 1170.0 ± 6.3% | 424.2 ± 0.8% | 446.7 ± 3.2% | 417.2 ± 1.1% | 0.815 | 1.110 | 3.061 | 2.906 | 3.112 |
| qlog records, JSON text sequence | 1467503 | 1081.6 ± 4.6% | 1313.8 ± 0.6% | 905.6 ± 0.4% | 427.8 ± 0.4% | 499.8 ± 0.3% | 316.8 ± 5.2% | 0.823 | 1.194 | 2.528 | 2.164 | 3.415 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.763 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.849 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.853 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.831 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.815 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.823 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1409.3 ± 5.5% | 0.432 | 0.911 | 0.947 | 0.941 | 0.356 | 0.961 | 0.943 | 0.334 | 0.726 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1090.0 ± 3.0% | 0.739 | 0.982 | 0.950 | 0.951 | 0.364 | 0.979 | 0.953 | 0.338 | 0.831 | 0.118 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1762.4 ± 1.3% | 0.418 | 0.952 | 0.965 | 0.985 | 0.999 | 0.247 | 0.994 | 0.437 | 0.737 | 0.087 | 1.008 |
| qlog records, JSON text sequence | 1467503 | 1489.2 ± 2.6% | 0.681 | 0.946 | 0.984 | 0.992 | 0.986 | 0.249 | 0.986 | 0.420 | 0.723 | 0.113 | 1.007 |

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
| CLDR supplemental, 34 texts | 920675 | 1409.3 ± 5.5% | 1307.2 ± 5.5% | 1216.3 ± 1.1% | 356.0 ± 1.1% | 667.7 ± 2.0% | 324.1 ± 4.0% | 1.078 | 1.159 | 3.959 | 2.111 | 4.348 |
| qlog records, JSON text sequence | 1467503 | 1090.0 ± 3.0% | 1023.8 ± 0.6% | 1085.6 ± 3.3% | 303.2 ± 1.9% | 731.1 ± 0.2% | 318.5 ± 1.5% | 1.065 | 1.004 | 3.595 | 1.491 | 3.422 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1762.4 ± 1.3% | 1582.8 ± 0.5% | 1151.8 ± 1.2% | 421.1 ± 4.7% | 444.4 ± 4.5% | 416.3 ± 0.9% | 1.113 | 1.530 | 4.185 | 3.966 | 4.234 |
| qlog records, JSON text sequence | 1467503 | 1489.2 ± 2.6% | 1306.8 ± 0.3% | 902.6 ± 0.2% | 426.3 ± 0.4% | 502.8 ± 0.4% | 329.9 ± 0.8% | 1.140 | 1.650 | 3.493 | 2.962 | 4.514 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1775.7 ± 5.7% | 1582.8 ± 0.5% | 1151.8 ± 1.2% | 421.1 ± 4.7% | 444.4 ± 4.5% | 416.3 ± 0.9% | 1.122 | 1.542 | 4.217 | 3.996 | 4.266 |
| qlog records, JSON text sequence | 1467503 | 1499.9 ± 0.3% | 1306.8 ± 0.3% | 902.6 ± 0.2% | 426.3 ± 0.4% | 502.8 ± 0.4% | 329.9 ± 0.8% | 1.148 | 1.662 | 3.518 | 2.983 | 4.546 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1023.3 ± 1.4% | 1307.2 ± 5.5% | 1216.3 ± 1.1% | 356.0 ± 1.1% | 667.7 ± 2.0% | 324.1 ± 4.0% | 0.783 | 0.841 | 2.875 | 1.532 | 3.157 |
| qlog records, JSON text sequence | 1467503 | 906.1 ± 4.6% | 1023.8 ± 0.6% | 1085.6 ± 3.3% | 303.2 ± 1.9% | 731.1 ± 0.2% | 318.5 ± 1.5% | 0.885 | 0.835 | 2.988 | 1.239 | 2.845 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1299.5 ± 0.6% | 1582.8 ± 0.5% | 1151.8 ± 1.2% | 421.1 ± 4.7% | 444.4 ± 4.5% | 416.3 ± 0.9% | 0.821 | 1.128 | 3.086 | 2.924 | 3.122 |
| qlog records, JSON text sequence | 1467503 | 1076.6 ± 0.8% | 1306.8 ± 0.3% | 902.6 ± 0.2% | 426.3 ± 0.4% | 502.8 ± 0.4% | 329.9 ± 0.8% | 0.824 | 1.193 | 2.525 | 2.141 | 3.263 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.783 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.841 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.885 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.835 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.821 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.824 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1390.1 ± 5.6% | 0.440 | 0.943 | 0.958 | 0.951 | 0.359 | 0.982 | 0.954 | 0.339 | 0.767 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 1102.6 ± 2.9% | 0.724 | 0.968 | 0.938 | 0.940 | 0.359 | 0.968 | 0.940 | 0.334 | 0.837 | 0.117 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1761.5 ± 0.7% | 0.420 | 0.954 | 0.963 | 0.994 | 0.995 | 0.247 | 0.996 | 0.438 | 0.738 | 0.087 | 1.018 |
| qlog records, JSON text sequence | 1467503 | 1487.7 ± 0.6% | 0.681 | 0.944 | 0.986 | 0.990 | 0.981 | 0.248 | 0.981 | 0.422 | 0.727 | 0.113 | 1.005 |

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
| CLDR supplemental, 34 texts | 920675 | 1390.1 ± 5.6% | 1338.8 ± 1.1% | 1211.2 ± 1.1% | 356.4 ± 2.0% | 669.8 ± 1.8% | 321.9 ± 3.9% | 1.038 | 1.148 | 3.900 | 2.075 | 4.318 |
| qlog records, JSON text sequence | 1467503 | 1102.6 ± 2.9% | 1038.9 ± 0.3% | 1076.9 ± 0.4% | 286.8 ± 2.4% | 728.5 ± 0.9% | 318.1 ± 2.2% | 1.061 | 1.024 | 3.845 | 1.514 | 3.467 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1761.5 ± 0.7% | 1593.8 ± 5.5% | 1137.2 ± 1.0% | 423.6 ± 5.0% | 445.7 ± 1.0% | 415.0 ± 0.7% | 1.105 | 1.549 | 4.158 | 3.952 | 4.244 |
| qlog records, JSON text sequence | 1467503 | 1487.7 ± 0.6% | 1312.6 ± 1.0% | 897.3 ± 1.3% | 427.1 ± 0.8% | 498.9 ± 0.4% | 330.1 ± 0.6% | 1.133 | 1.658 | 3.483 | 2.982 | 4.507 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1792.3 ± 0.9% | 1593.8 ± 5.5% | 1137.2 ± 1.0% | 423.6 ± 5.0% | 445.7 ± 1.0% | 415.0 ± 0.7% | 1.125 | 1.576 | 4.231 | 4.021 | 4.319 |
| qlog records, JSON text sequence | 1467503 | 1494.6 ± 0.6% | 1312.6 ± 1.0% | 897.3 ± 1.3% | 427.1 ± 0.8% | 498.9 ± 0.4% | 330.1 ± 0.6% | 1.139 | 1.666 | 3.499 | 2.996 | 4.527 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1066.8 ± 1.7% | 1338.8 ± 1.1% | 1211.2 ± 1.1% | 356.4 ± 2.0% | 669.8 ± 1.8% | 321.9 ± 3.9% | 0.797 | 0.881 | 2.993 | 1.593 | 3.314 |
| qlog records, JSON text sequence | 1467503 | 923.1 ± 0.4% | 1038.9 ± 0.3% | 1076.9 ± 0.4% | 286.8 ± 2.4% | 728.5 ± 0.9% | 318.1 ± 2.2% | 0.889 | 0.857 | 3.219 | 1.267 | 2.902 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1299.9 ± 1.2% | 1593.8 ± 5.5% | 1137.2 ± 1.0% | 423.6 ± 5.0% | 445.7 ± 1.0% | 415.0 ± 0.7% | 0.816 | 1.143 | 3.068 | 2.916 | 3.132 |
| qlog records, JSON text sequence | 1467503 | 1081.3 ± 0.3% | 1312.6 ± 1.0% | 897.3 ± 1.3% | 427.1 ± 0.8% | 498.9 ± 0.4% | 330.1 ± 0.6% | 0.824 | 1.205 | 2.532 | 2.167 | 3.275 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.797 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.881 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.889 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.857 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.816 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.824 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.8 ± 1.1% | 0.485 | 1.021 | 0.999 | 0.994 | 0.373 | 0.983 | 0.992 | 0.350 | 0.782 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 1064.0 ± 0.2% | 0.791 | 1.029 | 1.046 | 1.033 | 0.376 | 1.034 | 1.045 | 0.344 | 0.696 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1749.3 ± 6.4% | 0.423 | 0.977 | 0.965 | 1.007 | 1.004 | 0.251 | 1.005 | 0.443 | 0.740 | 0.088 | 1.020 |
| qlog records, JSON text sequence | 1467503 | 1488.0 ± 0.3% | 0.682 | 0.954 | 0.986 | 0.990 | 0.986 | 0.253 | 0.987 | 0.421 | 0.725 | 0.113 | 1.005 |

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
| CLDR supplemental, 34 texts | 920675 | 1336.8 ± 1.1% | 1305.2 ± 0.6% | 1194.6 ± 0.7% | 354.1 ± 1.5% | 664.3 ± 1.0% | 320.4 ± 1.7% | 1.024 | 1.119 | 3.775 | 2.012 | 4.173 |
| qlog records, JSON text sequence | 1467503 | 1064.0 ± 0.2% | 1029.0 ± 0.2% | 1062.6 ± 3.0% | 304.8 ± 2.8% | 729.4 ± 0.1% | 317.1 ± 1.5% | 1.034 | 1.001 | 3.491 | 1.459 | 3.356 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1749.3 ± 6.4% | 1596.2 ± 1.6% | 1172.8 ± 2.0% | 423.7 ± 0.7% | 458.7 ± 0.7% | 411.0 ± 0.7% | 1.096 | 1.492 | 4.129 | 3.814 | 4.256 |
| qlog records, JSON text sequence | 1467503 | 1488.0 ± 0.3% | 1311.5 ± 0.2% | 904.0 ± 0.5% | 419.8 ± 0.6% | 490.4 ± 0.1% | 328.4 ± 1.5% | 1.135 | 1.646 | 3.544 | 3.034 | 4.531 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1784.6 ± 1.1% | 1596.2 ± 1.6% | 1172.8 ± 2.0% | 423.7 ± 0.7% | 458.7 ± 0.7% | 411.0 ± 0.7% | 1.118 | 1.522 | 4.212 | 3.891 | 4.342 |
| qlog records, JSON text sequence | 1467503 | 1495.7 ± 0.1% | 1311.5 ± 0.2% | 904.0 ± 0.5% | 419.8 ± 0.6% | 490.4 ± 0.1% | 328.4 ± 1.5% | 1.140 | 1.655 | 3.562 | 3.050 | 4.554 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1045.4 ± 0.6% | 1305.2 ± 0.6% | 1194.6 ± 0.7% | 354.1 ± 1.5% | 664.3 ± 1.0% | 320.4 ± 1.7% | 0.801 | 0.875 | 2.952 | 1.574 | 3.263 |
| qlog records, JSON text sequence | 1467503 | 740.4 ± 0.8% | 1029.0 ± 0.2% | 1062.6 ± 3.0% | 304.8 ± 2.8% | 729.4 ± 0.1% | 317.1 ± 1.5% | 0.719 | 0.697 | 2.429 | 1.015 | 2.335 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1294.1 ± 0.8% | 1596.2 ± 1.6% | 1172.8 ± 2.0% | 423.7 ± 0.7% | 458.7 ± 0.7% | 411.0 ± 0.7% | 0.811 | 1.103 | 3.055 | 2.821 | 3.149 |
| qlog records, JSON text sequence | 1467503 | 1078.6 ± 0.2% | 1311.5 ± 0.2% | 904.0 ± 0.5% | 419.8 ± 0.6% | 490.4 ± 0.1% | 328.4 ± 1.5% | 0.822 | 1.193 | 2.569 | 2.200 | 3.284 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.801 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.875 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.719 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.697 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.811 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.822 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1424.9 ± 0.3% | 0.430 | 0.920 | 0.931 | 0.930 | 0.354 | 0.956 | 0.928 | 0.330 | 0.753 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1101.2 ± 1.3% | 0.734 | 0.973 | 0.941 | 0.942 | 0.361 | 0.969 | 0.942 | 0.335 | 0.801 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1747.5 ± 1.6% | 0.400 | 0.963 | 0.970 | 0.998 | 1.001 | 0.249 | 1.006 | 0.442 | 0.745 | 0.071 | 1.023 |
| qlog records, JSON text sequence | 1467503 | 1490.8 ± 0.4% | 0.681 | 0.944 | 0.992 | 0.994 | 0.988 | 0.249 | 0.987 | 0.421 | 0.728 | 0.095 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1424.9 ± 0.3% | 1342.7 ± 1.3% | 1214.9 ± 0.4% | 356.9 ± 1.3% | 667.3 ± 1.7% | 322.8 ± 2.8% | 1.061 | 1.173 | 3.993 | 2.135 | 4.415 |
| qlog records, JSON text sequence | 1467503 | 1101.2 ± 1.3% | 1054.3 ± 0.7% | 1085.2 ± 0.4% | 301.8 ± 0.9% | 731.2 ± 0.9% | 316.5 ± 1.2% | 1.044 | 1.015 | 3.649 | 1.506 | 3.479 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1747.5 ± 1.6% | 1595.9 ± 0.6% | 1167.1 ± 1.7% | 423.0 ± 0.5% | 456.4 ± 0.9% | 416.0 ± 0.6% | 1.095 | 1.497 | 4.131 | 3.829 | 4.201 |
| qlog records, JSON text sequence | 1467503 | 1490.8 ± 0.4% | 1314.6 ± 2.7% | 904.2 ± 0.9% | 427.1 ± 1.2% | 496.2 ± 0.5% | 329.9 ± 1.0% | 1.134 | 1.649 | 3.491 | 3.005 | 4.519 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1788.6 ± 0.6% | 1595.9 ± 0.6% | 1167.1 ± 1.7% | 423.0 ± 0.5% | 456.4 ± 0.9% | 416.0 ± 0.6% | 1.121 | 1.533 | 4.228 | 3.919 | 4.300 |
| qlog records, JSON text sequence | 1467503 | 1505.0 ± 0.2% | 1314.6 ± 2.7% | 904.2 ± 0.9% | 427.1 ± 1.2% | 496.2 ± 0.5% | 329.9 ± 1.0% | 1.145 | 1.664 | 3.524 | 3.033 | 4.562 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1073.6 ± 1.5% | 1342.7 ± 1.3% | 1214.9 ± 0.4% | 356.9 ± 1.3% | 667.3 ± 1.7% | 322.8 ± 2.8% | 0.800 | 0.884 | 3.008 | 1.609 | 3.326 |
| qlog records, JSON text sequence | 1467503 | 882.2 ± 0.3% | 1054.3 ± 0.7% | 1085.2 ± 0.4% | 301.8 ± 0.9% | 731.2 ± 0.9% | 316.5 ± 1.2% | 0.837 | 0.813 | 2.923 | 1.207 | 2.787 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1301.4 ± 0.5% | 1595.9 ± 0.6% | 1167.1 ± 1.7% | 423.0 ± 0.5% | 456.4 ± 0.9% | 416.0 ± 0.6% | 0.815 | 1.115 | 3.076 | 2.852 | 3.129 |
| qlog records, JSON text sequence | 1467503 | 1085.4 ± 0.7% | 1314.6 ± 2.7% | 904.2 ± 0.9% | 427.1 ± 1.2% | 496.2 ± 0.5% | 329.9 ± 1.0% | 0.826 | 1.200 | 2.541 | 2.188 | 3.290 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.800 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.884 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.837 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.813 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.815 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.826 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1418.8 ± 5.3% | 0.431 | 0.915 | 0.940 | 0.931 | 0.355 | 0.962 | 0.931 | 0.332 | 0.727 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1084.1 ± 2.2% | 0.746 | 0.989 | 0.955 | 0.957 | 0.366 | 0.986 | 0.957 | 0.340 | 0.831 | 0.118 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1766.5 ± 1.0% | 0.419 | 0.956 | 0.966 | 0.994 | 0.999 | 0.246 | 0.997 | 0.437 | 0.737 | 0.087 | 1.012 |
| qlog records, JSON text sequence | 1467503 | 1488.8 ± 0.8% | 0.680 | 0.943 | 0.989 | 0.993 | 0.988 | 0.249 | 0.987 | 0.421 | 0.729 | 0.113 | 1.009 |

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
| CLDR supplemental, 34 texts | 920675 | 1418.8 ± 5.3% | 1356.5 ± 1.8% | 1213.8 ± 0.8% | 356.5 ± 1.0% | 665.3 ± 0.6% | 321.6 ± 1.8% | 1.046 | 1.169 | 3.979 | 2.133 | 4.411 |
| qlog records, JSON text sequence | 1467503 | 1084.1 ± 2.2% | 1056.5 ± 0.7% | 1065.2 ± 0.9% | 301.1 ± 0.7% | 731.4 ± 0.4% | 317.8 ± 2.1% | 1.026 | 1.018 | 3.601 | 1.482 | 3.411 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1766.5 ± 1.0% | 1593.7 ± 1.3% | 1170.4 ± 1.3% | 423.5 ± 1.0% | 455.7 ± 2.6% | 417.0 ± 1.3% | 1.108 | 1.509 | 4.171 | 3.877 | 4.236 |
| qlog records, JSON text sequence | 1467503 | 1488.8 ± 0.8% | 1313.0 ± 0.4% | 898.5 ± 0.6% | 426.2 ± 0.6% | 498.8 ± 0.1% | 329.4 ± 3.4% | 1.134 | 1.657 | 3.493 | 2.985 | 4.519 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1788.4 ± 1.4% | 1593.7 ± 1.3% | 1170.4 ± 1.3% | 423.5 ± 1.0% | 455.7 ± 2.6% | 417.0 ± 1.3% | 1.122 | 1.528 | 4.223 | 3.925 | 4.288 |
| qlog records, JSON text sequence | 1467503 | 1501.7 ± 1.1% | 1313.0 ± 0.4% | 898.5 ± 0.6% | 426.2 ± 0.6% | 498.8 ± 0.1% | 329.4 ± 3.4% | 1.144 | 1.671 | 3.524 | 3.011 | 4.558 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1031.6 ± 1.5% | 1356.5 ± 1.8% | 1213.8 ± 0.8% | 356.5 ± 1.0% | 665.3 ± 0.6% | 321.6 ± 1.8% | 0.760 | 0.850 | 2.893 | 1.551 | 3.207 |
| qlog records, JSON text sequence | 1467503 | 900.4 ± 0.3% | 1056.5 ± 0.7% | 1065.2 ± 0.9% | 301.1 ± 0.7% | 731.4 ± 0.4% | 317.8 ± 2.1% | 0.852 | 0.845 | 2.991 | 1.231 | 2.833 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1301.8 ± 0.5% | 1593.7 ± 1.3% | 1170.4 ± 1.3% | 423.5 ± 1.0% | 455.7 ± 2.6% | 417.0 ± 1.3% | 0.817 | 1.112 | 3.074 | 2.857 | 3.121 |
| qlog records, JSON text sequence | 1467503 | 1085.8 ± 0.4% | 1313.0 ± 0.4% | 898.5 ± 0.6% | 426.2 ± 0.6% | 498.8 ± 0.1% | 329.4 ± 3.4% | 0.827 | 1.209 | 2.548 | 2.177 | 3.296 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.760 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.850 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.852 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.845 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.817 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.827 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1414.8 ± 0.9% | 0.434 | 0.899 | 0.943 | 0.937 | 0.356 | 0.964 | 0.935 | 0.333 | 0.730 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1100.2 ± 4.2% | 0.733 | 0.973 | 0.942 | 0.941 | 0.361 | 0.970 | 0.944 | 0.335 | 0.825 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1753.7 ± 1.1% | 0.421 | 0.957 | 0.962 | 0.992 | 1.001 | 0.248 | 1.002 | 0.441 | 0.740 | 0.087 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1492.3 ± 0.2% | 0.680 | 0.944 | 0.986 | 0.992 | 0.985 | 0.248 | 0.981 | 0.421 | 0.726 | 0.113 | 1.004 |

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
| CLDR supplemental, 34 texts | 920675 | 1414.8 ± 0.9% | 1292.5 ± 1.2% | 1191.7 ± 0.5% | 357.1 ± 0.2% | 665.0 ± 0.4% | 322.3 ± 3.3% | 1.095 | 1.187 | 3.962 | 2.127 | 4.389 |
| qlog records, JSON text sequence | 1467503 | 1100.2 ± 4.2% | 1002.3 ± 0.5% | 1061.5 ± 3.3% | 304.2 ± 0.7% | 730.6 ± 0.5% | 316.5 ± 1.1% | 1.098 | 1.036 | 3.617 | 1.506 | 3.476 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1753.7 ± 1.1% | 1595.5 ± 1.2% | 1153.5 ± 2.2% | 422.9 ± 0.8% | 453.4 ± 2.7% | 415.0 ± 0.6% | 1.099 | 1.520 | 4.147 | 3.868 | 4.226 |
| qlog records, JSON text sequence | 1467503 | 1492.3 ± 0.2% | 1314.5 ± 0.3% | 905.4 ± 5.0% | 426.2 ± 2.6% | 501.4 ± 0.1% | 329.3 ± 1.5% | 1.135 | 1.648 | 3.501 | 2.976 | 4.532 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1783.2 ± 0.9% | 1595.5 ± 1.2% | 1153.5 ± 2.2% | 422.9 ± 0.8% | 453.4 ± 2.7% | 415.0 ± 0.6% | 1.118 | 1.546 | 4.217 | 3.933 | 4.297 |
| qlog records, JSON text sequence | 1467503 | 1498.0 ± 0.4% | 1314.5 ± 0.3% | 905.4 ± 5.0% | 426.2 ± 2.6% | 501.4 ± 0.1% | 329.3 ± 1.5% | 1.140 | 1.654 | 3.515 | 2.988 | 4.549 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1033.0 ± 0.8% | 1292.5 ± 1.2% | 1191.7 ± 0.5% | 357.1 ± 0.2% | 665.0 ± 0.4% | 322.3 ± 3.3% | 0.799 | 0.867 | 2.893 | 1.553 | 3.205 |
| qlog records, JSON text sequence | 1467503 | 907.2 ± 0.4% | 1002.3 ± 0.5% | 1061.5 ± 3.3% | 304.2 ± 0.7% | 730.6 ± 0.5% | 316.5 ± 1.1% | 0.905 | 0.855 | 2.982 | 1.242 | 2.866 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1297.0 ± 4.0% | 1595.5 ± 1.2% | 1153.5 ± 2.2% | 422.9 ± 0.8% | 453.4 ± 2.7% | 415.0 ± 0.6% | 0.813 | 1.124 | 3.067 | 2.861 | 3.126 |
| qlog records, JSON text sequence | 1467503 | 1084.2 ± 0.1% | 1314.5 ± 0.3% | 905.4 ± 5.0% | 426.2 ± 2.6% | 501.4 ± 0.1% | 329.3 ± 1.5% | 0.825 | 1.197 | 2.544 | 2.162 | 3.293 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.799 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.867 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.905 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.855 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.813 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.825 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1423.7 ± 1.6% | 0.432 | 0.918 | 0.936 | 0.930 | 0.354 | 0.957 | 0.929 | 0.331 | 0.748 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1103.0 ± 0.5% | 0.743 | 0.971 | 0.936 | 0.941 | 0.360 | 0.966 | 0.957 | 0.334 | 0.836 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1759.5 ± 0.8% | 0.420 | 0.960 | 0.968 | 0.990 | 0.998 | 0.248 | 1.001 | 0.440 | 0.739 | 0.087 | 0.998 |
| qlog records, JSON text sequence | 1467503 | 1489.6 ± 0.6% | 0.680 | 0.938 | 0.987 | 0.989 | 0.980 | 0.249 | 0.982 | 0.421 | 0.725 | 0.113 | 1.004 |

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
| CLDR supplemental, 34 texts | 920675 | 1423.7 ± 1.6% | 1319.1 ± 0.9% | 1196.1 ± 0.6% | 354.5 ± 1.3% | 665.5 ± 1.4% | 321.9 ± 1.4% | 1.079 | 1.190 | 4.016 | 2.139 | 4.423 |
| qlog records, JSON text sequence | 1467503 | 1103.0 ± 0.5% | 1021.4 ± 4.5% | 1064.2 ± 13.1% | 300.6 ± 0.9% | 727.3 ± 4.5% | 317.2 ± 4.6% | 1.080 | 1.036 | 3.670 | 1.516 | 3.477 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1759.5 ± 0.8% | 1593.9 ± 1.2% | 1158.5 ± 1.4% | 422.8 ± 4.9% | 444.0 ± 5.5% | 415.8 ± 2.7% | 1.104 | 1.519 | 4.161 | 3.963 | 4.232 |
| qlog records, JSON text sequence | 1467503 | 1489.6 ± 0.6% | 1309.2 ± 5.7% | 904.3 ± 0.1% | 427.3 ± 0.6% | 499.8 ± 0.2% | 329.6 ± 1.4% | 1.138 | 1.647 | 3.486 | 2.980 | 4.519 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1756.8 ± 6.5% | 1593.9 ± 1.2% | 1158.5 ± 1.4% | 422.8 ± 4.9% | 444.0 ± 5.5% | 415.8 ± 2.7% | 1.102 | 1.516 | 4.155 | 3.957 | 4.225 |
| qlog records, JSON text sequence | 1467503 | 1496.0 ± 0.3% | 1309.2 ± 5.7% | 904.3 ± 0.1% | 427.3 ± 0.6% | 499.8 ± 0.2% | 329.6 ± 1.4% | 1.143 | 1.654 | 3.501 | 2.993 | 4.538 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1064.7 ± 1.0% | 1319.1 ± 0.9% | 1196.1 ± 0.6% | 354.5 ± 1.3% | 665.5 ± 1.4% | 321.9 ± 1.4% | 0.807 | 0.890 | 3.003 | 1.600 | 3.308 |
| qlog records, JSON text sequence | 1467503 | 921.7 ± 0.5% | 1021.4 ± 4.5% | 1064.2 ± 13.1% | 300.6 ± 0.9% | 727.3 ± 4.5% | 317.2 ± 4.6% | 0.902 | 0.866 | 3.067 | 1.267 | 2.905 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1299.9 ± 0.6% | 1593.9 ± 1.2% | 1158.5 ± 1.4% | 422.8 ± 4.9% | 444.0 ± 5.5% | 415.8 ± 2.7% | 0.816 | 1.122 | 3.074 | 2.928 | 3.126 |
| qlog records, JSON text sequence | 1467503 | 1080.2 ± 0.3% | 1309.2 ± 5.7% | 904.3 ± 0.1% | 427.3 ± 0.6% | 499.8 ± 0.2% | 329.6 ± 1.4% | 0.825 | 1.194 | 2.528 | 2.161 | 3.277 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.807 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.890 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.902 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.866 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.816 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.825 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.0 ± 2.5% | 0.484 | 1.016 | 0.998 | 1.002 | 0.375 | 1.001 | 1.002 | 0.350 | 0.784 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 1061.5 ± 0.7% | 0.798 | 1.032 | 1.036 | 1.027 | 0.378 | 1.018 | 1.029 | 0.345 | 0.699 | 0.122 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1745.5 ± 3.3% | 0.423 | 0.981 | 0.971 | 1.013 | 1.009 | 0.252 | 1.010 | 0.442 | 0.744 | 0.088 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1488.4 ± 0.5% | 0.683 | 0.955 | 0.988 | 0.990 | 0.986 | 0.252 | 0.987 | 0.420 | 0.724 | 0.113 | 1.008 |

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
| CLDR supplemental, 34 texts | 920675 | 1336.0 ± 2.5% | 1344.0 ± 3.2% | 1216.7 ± 1.2% | 356.6 ± 0.6% | 663.1 ± 1.3% | 320.2 ± 2.8% | 0.994 | 1.098 | 3.746 | 2.015 | 4.172 |
| qlog records, JSON text sequence | 1467503 | 1061.5 ± 0.7% | 930.8 ± 1.8% | 1085.2 ± 0.5% | 303.4 ± 2.0% | 727.6 ± 0.5% | 318.0 ± 5.1% | 1.140 | 0.978 | 3.499 | 1.459 | 3.339 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1745.5 ± 3.3% | 1596.3 ± 1.1% | 1159.1 ± 1.4% | 426.8 ± 0.8% | 456.0 ± 1.8% | 412.8 ± 0.5% | 1.093 | 1.506 | 4.089 | 3.828 | 4.229 |
| qlog records, JSON text sequence | 1467503 | 1488.4 ± 0.5% | 1309.3 ± 0.9% | 899.8 ± 0.8% | 423.9 ± 8.5% | 499.1 ± 0.1% | 330.1 ± 1.1% | 1.137 | 1.654 | 3.511 | 2.982 | 4.509 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1783.6 ± 1.8% | 1596.3 ± 1.1% | 1159.1 ± 1.4% | 426.8 ± 0.8% | 456.0 ± 1.8% | 412.8 ± 0.5% | 1.117 | 1.539 | 4.179 | 3.911 | 4.321 |
| qlog records, JSON text sequence | 1467503 | 1500.8 ± 2.2% | 1309.3 ± 0.9% | 899.8 ± 0.8% | 423.9 ± 8.5% | 499.1 ± 0.1% | 330.1 ± 1.1% | 1.146 | 1.668 | 3.540 | 3.007 | 4.546 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1046.8 ± 0.5% | 1344.0 ± 3.2% | 1216.7 ± 1.2% | 356.6 ± 0.6% | 663.1 ± 1.3% | 320.2 ± 2.8% | 0.779 | 0.860 | 2.935 | 1.579 | 3.269 |
| qlog records, JSON text sequence | 1467503 | 742.0 ± 0.4% | 930.8 ± 1.8% | 1085.2 ± 0.5% | 303.4 ± 2.0% | 727.6 ± 0.5% | 318.0 ± 5.1% | 0.797 | 0.684 | 2.446 | 1.020 | 2.334 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1297.9 ± 0.7% | 1596.3 ± 1.1% | 1159.1 ± 1.4% | 426.8 ± 0.8% | 456.0 ± 1.8% | 412.8 ± 0.5% | 0.813 | 1.120 | 3.041 | 2.846 | 3.144 |
| qlog records, JSON text sequence | 1467503 | 1077.8 ± 0.3% | 1309.3 ± 0.9% | 899.8 ± 0.8% | 423.9 ± 8.5% | 499.1 ± 0.1% | 330.1 ± 1.1% | 0.823 | 1.198 | 2.542 | 2.160 | 3.265 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.779 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.860 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.797 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.684 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.813 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.823 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1424.9 ± 4.7% | 0.429 | 0.906 | 0.935 | 0.928 | 0.354 | 0.953 | 0.931 | 0.331 | 0.758 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1101.1 ± 2.0% | 0.731 | 0.973 | 0.943 | 0.956 | 0.361 | 0.966 | 0.941 | 0.335 | 0.801 | 0.117 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1756.5 ± 1.0% | 0.399 | 0.959 | 0.968 | 0.996 | 1.001 | 0.248 | 1.004 | 0.439 | 0.741 | 0.071 | 1.016 |
| qlog records, JSON text sequence | 1467503 | 1487.7 ± 0.3% | 0.682 | 0.947 | 0.989 | 0.997 | 0.990 | 0.253 | 0.990 | 0.421 | 0.721 | 0.095 | 1.011 |

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
| CLDR supplemental, 34 texts | 920675 | 1424.9 ± 4.7% | 1314.6 ± 2.4% | 1207.7 ± 2.5% | 356.7 ± 9.2% | 665.5 ± 0.5% | 321.6 ± 2.8% | 1.084 | 1.180 | 3.995 | 2.141 | 4.431 |
| qlog records, JSON text sequence | 1467503 | 1101.1 ± 2.0% | 1051.4 ± 0.7% | 1086.1 ± 0.5% | 302.5 ± 1.2% | 730.4 ± 0.6% | 316.0 ± 1.3% | 1.047 | 1.014 | 3.640 | 1.507 | 3.484 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1756.5 ± 1.0% | 1606.2 ± 1.2% | 1137.4 ± 1.1% | 425.6 ± 1.0% | 447.3 ± 0.5% | 414.6 ± 4.6% | 1.094 | 1.544 | 4.127 | 3.927 | 4.236 |
| qlog records, JSON text sequence | 1467503 | 1487.7 ± 0.3% | 1316.3 ± 0.3% | 887.4 ± 6.5% | 427.3 ± 1.5% | 497.1 ± 3.6% | 331.9 ± 1.1% | 1.130 | 1.676 | 3.482 | 2.993 | 4.482 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1783.8 ± 6.0% | 1606.2 ± 1.2% | 1137.4 ± 1.1% | 425.6 ± 1.0% | 447.3 ± 0.5% | 414.6 ± 4.6% | 1.111 | 1.568 | 4.191 | 3.988 | 4.302 |
| qlog records, JSON text sequence | 1467503 | 1504.6 ± 0.2% | 1316.3 ± 0.3% | 887.4 ± 6.5% | 427.3 ± 1.5% | 497.1 ± 3.6% | 331.9 ± 1.1% | 1.143 | 1.695 | 3.521 | 3.026 | 4.533 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1079.6 ± 2.0% | 1314.6 ± 2.4% | 1207.7 ± 2.5% | 356.7 ± 9.2% | 665.5 ± 0.5% | 321.6 ± 2.8% | 0.821 | 0.894 | 3.027 | 1.622 | 3.357 |
| qlog records, JSON text sequence | 1467503 | 881.8 ± 0.2% | 1051.4 ± 0.7% | 1086.1 ± 0.5% | 302.5 ± 1.2% | 730.4 ± 0.6% | 316.0 ± 1.3% | 0.839 | 0.812 | 2.915 | 1.207 | 2.790 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1300.7 ± 0.9% | 1606.2 ± 1.2% | 1137.4 ± 1.1% | 425.6 ± 1.0% | 447.3 ± 0.5% | 414.6 ± 4.6% | 0.810 | 1.144 | 3.056 | 2.908 | 3.137 |
| qlog records, JSON text sequence | 1467503 | 1072.3 ± 0.1% | 1316.3 ± 0.3% | 887.4 ± 6.5% | 427.3 ± 1.5% | 497.1 ± 3.6% | 331.9 ± 1.1% | 0.815 | 1.208 | 2.510 | 2.157 | 3.231 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.821 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.894 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.839 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.812 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.810 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.815 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1420.0 ± 5.3% | 0.433 | 0.919 | 0.930 | 0.936 | 0.354 | 0.955 | 0.933 | 0.331 | 0.727 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1086.3 ± 3.3% | 0.744 | 0.987 | 0.956 | 0.955 | 0.365 | 0.983 | 0.954 | 0.339 | 0.828 | 0.118 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1760.7 ± 4.9% | 0.421 | 0.957 | 0.961 | 0.992 | 0.998 | 0.247 | 0.998 | 0.439 | 0.738 | 0.087 | 1.015 |
| qlog records, JSON text sequence | 1467503 | 1488.1 ± 0.3% | 0.682 | 0.946 | 0.990 | 0.995 | 0.987 | 0.249 | 0.988 | 0.422 | 0.730 | 0.113 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1420.0 ± 5.3% | 1309.1 ± 1.5% | 1211.6 ± 0.9% | 358.2 ± 2.7% | 666.3 ± 0.8% | 323.0 ± 2.2% | 1.085 | 1.172 | 3.965 | 2.131 | 4.396 |
| qlog records, JSON text sequence | 1467503 | 1086.3 ± 3.3% | 1054.9 ± 0.7% | 1084.5 ± 0.3% | 302.5 ± 1.1% | 731.6 ± 0.5% | 318.9 ± 1.4% | 1.030 | 1.002 | 3.590 | 1.485 | 3.407 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1760.7 ± 4.9% | 1603.3 ± 1.3% | 1182.6 ± 0.5% | 420.2 ± 1.1% | 457.7 ± 3.0% | 418.1 ± 0.6% | 1.098 | 1.489 | 4.190 | 3.846 | 4.211 |
| qlog records, JSON text sequence | 1467503 | 1488.1 ± 0.3% | 1314.6 ± 0.4% | 906.7 ± 0.6% | 427.8 ± 0.8% | 500.0 ± 0.3% | 329.2 ± 1.7% | 1.132 | 1.641 | 3.479 | 2.976 | 4.521 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1786.6 ± 0.7% | 1603.3 ± 1.3% | 1182.6 ± 0.5% | 420.2 ± 1.1% | 457.7 ± 3.0% | 418.1 ± 0.6% | 1.114 | 1.511 | 4.252 | 3.903 | 4.273 |
| qlog records, JSON text sequence | 1467503 | 1502.3 ± 0.4% | 1314.6 ± 0.4% | 906.7 ± 0.6% | 427.8 ± 0.8% | 500.0 ± 0.3% | 329.2 ± 1.7% | 1.143 | 1.657 | 3.512 | 3.005 | 4.564 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1032.3 ± 0.5% | 1309.1 ± 1.5% | 1211.6 ± 0.9% | 358.2 ± 2.7% | 666.3 ± 0.8% | 323.0 ± 2.2% | 0.789 | 0.852 | 2.882 | 1.549 | 3.196 |
| qlog records, JSON text sequence | 1467503 | 899.1 ± 0.8% | 1054.9 ± 0.7% | 1084.5 ± 0.3% | 302.5 ± 1.1% | 731.6 ± 0.5% | 318.9 ± 1.4% | 0.852 | 0.829 | 2.972 | 1.229 | 2.820 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1298.7 ± 4.5% | 1603.3 ± 1.3% | 1182.6 ± 0.5% | 420.2 ± 1.1% | 457.7 ± 3.0% | 418.1 ± 0.6% | 0.810 | 1.098 | 3.091 | 2.837 | 3.106 |
| qlog records, JSON text sequence | 1467503 | 1085.9 ± 0.4% | 1314.6 ± 0.4% | 906.7 ± 0.6% | 427.8 ± 0.8% | 500.0 ± 0.3% | 329.2 ± 1.7% | 0.826 | 1.198 | 2.539 | 2.172 | 3.299 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.789 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.852 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.852 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.829 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.810 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.826 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1407.0 ± 5.7% | 0.434 | 0.909 | 0.939 | 0.935 | 0.358 | 0.965 | 0.938 | 0.334 | 0.731 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 1103.1 ± 2.1% | 0.721 | 0.973 | 0.937 | 0.939 | 0.360 | 0.968 | 0.941 | 0.334 | 0.823 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1767.5 ± 3.5% | 0.418 | 0.951 | 0.964 | 0.987 | 0.996 | 0.245 | 0.991 | 0.436 | 0.735 | 0.087 | 1.009 |
| qlog records, JSON text sequence | 1467503 | 1486.7 ± 0.3% | 0.682 | 0.946 | 0.990 | 0.997 | 0.981 | 0.248 | 0.983 | 0.422 | 0.729 | 0.113 | 1.005 |

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
| CLDR supplemental, 34 texts | 920675 | 1407.0 ± 5.7% | 1328.3 ± 0.4% | 1207.7 ± 2.3% | 353.5 ± 3.0% | 665.7 ± 2.7% | 322.2 ± 2.7% | 1.059 | 1.165 | 3.981 | 2.113 | 4.367 |
| qlog records, JSON text sequence | 1467503 | 1103.1 ± 2.1% | 1038.2 ± 1.6% | 1082.1 ± 0.6% | 302.3 ± 1.4% | 730.3 ± 3.8% | 317.5 ± 1.9% | 1.062 | 1.019 | 3.649 | 1.511 | 3.474 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1767.5 ± 3.5% | 1594.9 ± 1.1% | 1173.2 ± 1.6% | 423.0 ± 2.7% | 449.6 ± 2.2% | 414.3 ± 1.9% | 1.108 | 1.507 | 4.178 | 3.931 | 4.267 |
| qlog records, JSON text sequence | 1467503 | 1486.7 ± 0.3% | 1309.3 ± 0.3% | 902.6 ± 0.2% | 426.7 ± 1.7% | 503.2 ± 0.3% | 330.5 ± 6.0% | 1.135 | 1.647 | 3.484 | 2.954 | 4.499 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1782.7 ± 1.1% | 1594.9 ± 1.1% | 1173.2 ± 1.6% | 423.0 ± 2.7% | 449.6 ± 2.2% | 414.3 ± 1.9% | 1.118 | 1.519 | 4.214 | 3.965 | 4.303 |
| qlog records, JSON text sequence | 1467503 | 1494.3 ± 6.5% | 1309.3 ± 0.3% | 902.6 ± 0.2% | 426.7 ± 1.7% | 503.2 ± 0.3% | 330.5 ± 6.0% | 1.141 | 1.656 | 3.502 | 2.970 | 4.522 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1028.4 ± 1.7% | 1328.3 ± 0.4% | 1207.7 ± 2.3% | 353.5 ± 3.0% | 665.7 ± 2.7% | 322.2 ± 2.7% | 0.774 | 0.851 | 2.909 | 1.545 | 3.192 |
| qlog records, JSON text sequence | 1467503 | 908.3 ± 0.4% | 1038.2 ± 1.6% | 1082.1 ± 0.6% | 302.3 ± 1.4% | 730.3 ± 3.8% | 317.5 ± 1.9% | 0.875 | 0.839 | 3.005 | 1.244 | 2.861 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1299.9 ± 1.1% | 1594.9 ± 1.1% | 1173.2 ± 1.6% | 423.0 ± 2.7% | 449.6 ± 2.2% | 414.3 ± 1.9% | 0.815 | 1.108 | 3.073 | 2.891 | 3.138 |
| qlog records, JSON text sequence | 1467503 | 1083.6 ± 0.5% | 1309.3 ± 0.3% | 902.6 ± 0.2% | 426.7 ± 1.7% | 503.2 ± 0.3% | 330.5 ± 6.0% | 0.828 | 1.201 | 2.539 | 2.153 | 3.279 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.774 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.851 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.875 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.839 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.815 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.828 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1415.1 ± 1.0% | 0.432 | 0.908 | 0.942 | 0.934 | 0.351 | 0.957 | 0.937 | 0.332 | 0.752 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1109.7 ± 2.8% | 0.724 | 0.967 | 0.947 | 0.935 | 0.358 | 0.962 | 0.935 | 0.332 | 0.829 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1764.6 ± 1.4% | 0.418 | 0.947 | 0.965 | 0.985 | 0.995 | 0.246 | 0.999 | 0.437 | 0.734 | 0.087 | 1.011 |
| qlog records, JSON text sequence | 1467503 | 1490.4 ± 6.6% | 0.682 | 0.943 | 0.985 | 0.988 | 0.985 | 0.252 | 0.982 | 0.419 | 0.726 | 0.113 | 1.003 |

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
| CLDR supplemental, 34 texts | 920675 | 1415.1 ± 1.0% | 1341.8 ± 1.0% | 1214.1 ± 0.6% | 353.7 ± 1.8% | 661.7 ± 0.5% | 323.6 ± 1.9% | 1.055 | 1.166 | 4.001 | 2.138 | 4.374 |
| qlog records, JSON text sequence | 1467503 | 1109.7 ± 2.8% | 1039.2 ± 0.9% | 1087.3 ± 0.5% | 289.1 ± 1.8% | 727.2 ± 0.7% | 317.1 ± 1.5% | 1.068 | 1.021 | 3.838 | 1.526 | 3.499 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1764.6 ± 1.4% | 1598.0 ± 1.6% | 1142.6 ± 3.0% | 423.9 ± 0.5% | 454.1 ± 2.7% | 417.0 ± 1.1% | 1.104 | 1.544 | 4.163 | 3.886 | 4.232 |
| qlog records, JSON text sequence | 1467503 | 1490.4 ± 6.6% | 1314.6 ± 0.1% | 904.6 ± 0.3% | 426.8 ± 0.5% | 503.1 ± 0.4% | 330.2 ± 1.7% | 1.134 | 1.648 | 3.492 | 2.963 | 4.513 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1784.4 ± 1.2% | 1598.0 ± 1.6% | 1142.6 ± 3.0% | 423.9 ± 0.5% | 454.1 ± 2.7% | 417.0 ± 1.1% | 1.117 | 1.562 | 4.209 | 3.930 | 4.279 |
| qlog records, JSON text sequence | 1467503 | 1495.0 ± 6.6% | 1314.6 ± 0.1% | 904.6 ± 0.3% | 426.8 ± 0.5% | 503.1 ± 0.4% | 330.2 ± 1.7% | 1.137 | 1.653 | 3.503 | 2.972 | 4.527 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1064.5 ± 1.8% | 1341.8 ± 1.0% | 1214.1 ± 0.6% | 353.7 ± 1.8% | 661.7 ± 0.5% | 323.6 ± 1.9% | 0.793 | 0.877 | 3.010 | 1.609 | 3.290 |
| qlog records, JSON text sequence | 1467503 | 919.5 ± 0.4% | 1039.2 ± 0.9% | 1087.3 ± 0.5% | 289.1 ± 1.8% | 727.2 ± 0.7% | 317.1 ± 1.5% | 0.885 | 0.846 | 3.180 | 1.264 | 2.899 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1295.8 ± 0.6% | 1598.0 ± 1.6% | 1142.6 ± 3.0% | 423.9 ± 0.5% | 454.1 ± 2.7% | 417.0 ± 1.1% | 0.811 | 1.134 | 3.057 | 2.854 | 3.108 |
| qlog records, JSON text sequence | 1467503 | 1082.3 ± 0.5% | 1314.6 ± 0.1% | 904.6 ± 0.3% | 426.8 ± 0.5% | 503.1 ± 0.4% | 330.2 ± 1.7% | 0.823 | 1.196 | 2.536 | 2.151 | 3.277 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.793 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.877 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.885 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.846 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.811 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.823 of simdjson.
