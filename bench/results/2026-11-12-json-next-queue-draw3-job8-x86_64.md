# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1552.4 ± 4.2% | 0.542 | 0.977 | 1.012 | 1.004 | 0.400 | 1.014 | 1.007 | 0.392 | 0.840 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1244.5 ± 5.0% | 0.939 | 1.017 | 1.058 | 1.037 | 0.378 | 1.009 | 0.982 | 0.329 | 0.676 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2277.6 ± 4.4% | 0.438 | 0.925 | 0.957 | 0.971 | 0.982 | 0.260 | 1.001 | 0.459 | 0.723 | 0.082 | 1.000 |
| qlog records, JSON text sequence | 1467503 | 2024.6 ± 1.5% | 0.712 | 0.919 | 0.984 | 0.987 | 0.986 | 0.258 | 0.986 | 0.427 | 0.718 | 0.101 | 0.988 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.058 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1552.4 ± 4.2% | 2008.2 ± 1.8% | 1576.9 ± 2.5% | 503.2 ± 3.1% | 786.5 ± 2.0% | 451.2 ± 6.7% | 0.773 | 0.984 | 3.085 | 1.974 | 3.441 |
| qlog records, JSON text sequence | 1467503 | 1244.5 ± 5.0% | 1521.3 ± 4.8% | 1518.9 ± 5.8% | 418.8 ± 26.2% | 870.8 ± 39.2% | 444.5 ± 4.9% | 0.818 | 0.819 | 2.972 | 1.429 | 2.799 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2277.6 ± 4.4% | 2250.0 ± 4.2% | 1457.0 ± 4.0% | 603.1 ± 11.2% | 611.8 ± 4.5% | 568.7 ± 4.6% | 1.012 | 1.563 | 3.776 | 3.723 | 4.005 |
| qlog records, JSON text sequence | 1467503 | 2024.6 ± 1.5% | 1890.9 ± 3.3% | 1174.1 ± 3.9% | 574.5 ± 6.3% | 689.4 ± 5.4% | 485.0 ± 5.2% | 1.071 | 1.724 | 3.524 | 2.937 | 4.175 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2278.5 ± 3.0% | 2250.0 ± 4.2% | 1457.0 ± 4.0% | 603.1 ± 11.2% | 611.8 ± 4.5% | 568.7 ± 4.6% | 1.013 | 1.564 | 3.778 | 3.724 | 4.006 |
| qlog records, JSON text sequence | 1467503 | 2000.8 ± 4.3% | 1890.9 ± 3.3% | 1174.1 ± 3.9% | 574.5 ± 6.3% | 689.4 ± 5.4% | 485.0 ± 5.2% | 1.058 | 1.704 | 3.483 | 2.902 | 4.126 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1303.8 ± 3.3% | 2008.2 ± 1.8% | 1576.9 ± 2.5% | 503.2 ± 3.1% | 786.5 ± 2.0% | 451.2 ± 6.7% | 0.649 | 0.827 | 2.591 | 1.658 | 2.890 |
| qlog records, JSON text sequence | 1467503 | 841.4 ± 17.1% | 1521.3 ± 4.8% | 1518.9 ± 5.8% | 418.8 ± 26.2% | 870.8 ± 39.2% | 444.5 ± 4.9% | 0.553 | 0.554 | 2.009 | 0.966 | 1.893 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1647.2 ± 3.7% | 2250.0 ± 4.2% | 1457.0 ± 4.0% | 603.1 ± 11.2% | 611.8 ± 4.5% | 568.7 ± 4.6% | 0.732 | 1.131 | 2.731 | 2.692 | 2.896 |
| qlog records, JSON text sequence | 1467503 | 1454.4 ± 3.1% | 1890.9 ± 3.3% | 1174.1 ± 3.9% | 574.5 ± 6.3% | 689.4 ± 5.4% | 485.0 ± 5.2% | 0.769 | 1.239 | 2.531 | 2.110 | 2.999 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.773 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.818 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.819 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.649 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.827 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.553 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.554 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.732 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.769 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1587.6 ± 2.9% | 0.525 | 0.978 | 1.016 | 1.017 | 0.397 | 1.017 | 1.020 | 0.395 | 0.862 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1283.5 ± 8.5% | 0.874 | 0.992 | 0.960 | 0.934 | 0.357 | 0.980 | 0.988 | 0.371 | 0.860 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2303.7 ± 1.5% | 0.443 | 0.951 | 0.968 | 0.999 | 1.005 | 0.270 | 1.006 | 0.467 | 0.736 | 0.087 | 0.986 |
| qlog records, JSON text sequence | 1467503 | 2015.8 ± 1.0% | 0.721 | 0.922 | 0.998 | 1.000 | 0.998 | 0.262 | 0.994 | 0.430 | 0.730 | 0.106 | 1.006 |

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
| CLDR supplemental, 34 texts | 920675 | 1587.6 ± 2.9% | 2045.9 ± 12.0% | 1631.2 ± 41.0% | 516.9 ± 24.9% | 727.4 ± 2.2% | 451.7 ± 4.9% | 0.776 | 0.973 | 3.072 | 2.183 | 3.515 |
| qlog records, JSON text sequence | 1467503 | 1283.5 ± 8.5% | 1566.2 ± 1.8% | 1490.8 ± 2.4% | 429.5 ± 8.7% | 885.8 ± 13.9% | 457.0 ± 6.9% | 0.819 | 0.861 | 2.988 | 1.449 | 2.808 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2303.7 ± 1.5% | 2264.3 ± 1.6% | 1481.0 ± 1.6% | 599.1 ± 3.6% | 528.5 ± 6.6% | 581.6 ± 1.5% | 1.017 | 1.555 | 3.845 | 4.359 | 3.961 |
| qlog records, JSON text sequence | 1467503 | 2015.8 ± 1.0% | 1878.4 ± 2.5% | 1208.3 ± 0.7% | 581.4 ± 5.3% | 695.3 ± 3.4% | 482.6 ± 2.1% | 1.073 | 1.668 | 3.467 | 2.899 | 4.177 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2272.1 ± 10.9% | 2264.3 ± 1.6% | 1481.0 ± 1.6% | 599.1 ± 3.6% | 528.5 ± 6.6% | 581.6 ± 1.5% | 1.003 | 1.534 | 3.792 | 4.299 | 3.906 |
| qlog records, JSON text sequence | 1467503 | 2027.6 ± 3.3% | 1878.4 ± 2.5% | 1208.3 ± 0.7% | 581.4 ± 5.3% | 695.3 ± 3.4% | 482.6 ± 2.1% | 1.079 | 1.678 | 3.487 | 2.916 | 4.202 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1368.4 ± 2.7% | 2045.9 ± 12.0% | 1631.2 ± 41.0% | 516.9 ± 24.9% | 727.4 ± 2.2% | 451.7 ± 4.9% | 0.669 | 0.839 | 2.647 | 1.881 | 3.030 |
| qlog records, JSON text sequence | 1467503 | 1104.0 ± 27.7% | 1566.2 ± 1.8% | 1490.8 ± 2.4% | 429.5 ± 8.7% | 885.8 ± 13.9% | 457.0 ± 6.9% | 0.705 | 0.741 | 2.570 | 1.246 | 2.416 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1695.2 ± 5.5% | 2264.3 ± 1.6% | 1481.0 ± 1.6% | 599.1 ± 3.6% | 528.5 ± 6.6% | 581.6 ± 1.5% | 0.749 | 1.145 | 2.829 | 3.208 | 2.914 |
| qlog records, JSON text sequence | 1467503 | 1470.8 ± 1.7% | 1878.4 ± 2.5% | 1208.3 ± 0.7% | 581.4 ± 5.3% | 695.3 ± 3.4% | 482.6 ± 2.1% | 0.783 | 1.217 | 2.530 | 2.115 | 3.048 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.776 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.819 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.861 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.669 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.705 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.749 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.783 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1571.5 ± 14.1% | 0.531 | 0.993 | 1.027 | 1.025 | 0.396 | 1.011 | 1.020 | 0.396 | 0.791 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1281.8 ± 13.0% | 0.881 | 1.017 | 0.986 | 0.949 | 0.360 | 0.976 | 0.956 | 0.324 | 0.819 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2278.4 ± 1.8% | 0.444 | 0.953 | 0.963 | 0.999 | 0.998 | 0.267 | 1.012 | 0.471 | 0.741 | 0.082 | 0.993 |
| qlog records, JSON text sequence | 1467503 | 1976.9 ± 3.9% | 0.723 | 0.925 | 0.996 | 1.017 | 1.008 | 0.267 | 1.002 | 0.434 | 0.729 | 0.102 | 1.016 |

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
| CLDR supplemental, 34 texts | 920675 | 1571.5 ± 14.1% | 2036.4 ± 59.0% | 1631.5 ± 3.0% | 516.7 ± 4.9% | 726.8 ± 3.0% | 454.9 ± 4.5% | 0.772 | 0.963 | 3.041 | 2.162 | 3.455 |
| qlog records, JSON text sequence | 1467503 | 1281.8 ± 13.0% | 1540.0 ± 3.1% | 1491.8 ± 3.1% | 430.7 ± 6.3% | 878.9 ± 3.0% | 457.0 ± 29.6% | 0.832 | 0.859 | 2.976 | 1.458 | 2.805 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2278.4 ± 1.8% | 2266.9 ± 2.6% | 1464.1 ± 3.0% | 593.1 ± 3.0% | 537.2 ± 1.9% | 577.4 ± 12.8% | 1.005 | 1.556 | 3.842 | 4.242 | 3.946 |
| qlog records, JSON text sequence | 1467503 | 1976.9 ± 3.9% | 1858.6 ± 1.7% | 1178.4 ± 3.9% | 570.6 ± 1.8% | 675.4 ± 2.2% | 472.6 ± 2.8% | 1.064 | 1.678 | 3.465 | 2.927 | 4.183 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2263.4 ± 2.7% | 2266.9 ± 2.6% | 1464.1 ± 3.0% | 593.1 ± 3.0% | 537.2 ± 1.9% | 577.4 ± 12.8% | 0.998 | 1.546 | 3.816 | 4.214 | 3.920 |
| qlog records, JSON text sequence | 1467503 | 2008.2 ± 3.0% | 1858.6 ± 1.7% | 1178.4 ± 3.9% | 570.6 ± 1.8% | 675.4 ± 2.2% | 472.6 ± 2.8% | 1.080 | 1.704 | 3.520 | 2.974 | 4.249 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1243.0 ± 9.9% | 2036.4 ± 59.0% | 1631.5 ± 3.0% | 516.7 ± 4.9% | 726.8 ± 3.0% | 454.9 ± 4.5% | 0.610 | 0.762 | 2.406 | 1.710 | 2.733 |
| qlog records, JSON text sequence | 1467503 | 1049.6 ± 9.8% | 1540.0 ± 3.1% | 1491.8 ± 3.1% | 430.7 ± 6.3% | 878.9 ± 3.0% | 457.0 ± 29.6% | 0.682 | 0.704 | 2.437 | 1.194 | 2.297 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1687.6 ± 7.1% | 2266.9 ± 2.6% | 1464.1 ± 3.0% | 593.1 ± 3.0% | 537.2 ± 1.9% | 577.4 ± 12.8% | 0.744 | 1.153 | 2.845 | 3.142 | 2.923 |
| qlog records, JSON text sequence | 1467503 | 1440.9 ± 2.2% | 1858.6 ± 1.7% | 1178.4 ± 3.9% | 570.6 ± 1.8% | 675.4 ± 2.2% | 472.6 ± 2.8% | 0.775 | 1.223 | 2.525 | 2.134 | 3.049 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.832 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.859 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.762 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.682 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.704 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.744 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.775 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1550.6 ± 2.0% | 0.551 | 1.007 | 1.040 | 1.021 | 0.409 | 1.044 | 1.014 | 0.402 | 0.855 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 1279.7 ± 8.3% | 0.904 | 1.014 | 1.011 | 1.036 | 0.395 | 1.013 | 1.030 | 0.381 | 0.721 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2257.4 ± 7.9% | 0.445 | 0.936 | 0.963 | 0.996 | 0.993 | 0.264 | 1.001 | 0.467 | 0.733 | 0.082 | 0.983 |
| qlog records, JSON text sequence | 1467503 | 1964.9 ± 5.7% | 0.697 | 0.914 | 0.980 | 0.991 | 0.969 | 0.259 | 0.992 | 0.419 | 0.704 | 0.100 | 0.978 |

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
| CLDR supplemental, 34 texts | 920675 | 1550.6 ± 2.0% | 2039.6 ± 2.6% | 1633.5 ± 1.1% | 513.0 ± 4.0% | 806.4 ± 3.4% | 462.1 ± 6.5% | 0.760 | 0.949 | 3.023 | 1.923 | 3.356 |
| qlog records, JSON text sequence | 1467503 | 1279.7 ± 8.3% | 1564.6 ± 2.8% | 1469.8 ± 4.4% | 428.8 ± 33.5% | 921.7 ± 50.3% | 455.5 ± 3.6% | 0.818 | 0.871 | 2.984 | 1.388 | 2.809 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2257.4 ± 7.9% | 2236.8 ± 2.9% | 1429.5 ± 27.1% | 587.9 ± 3.7% | 619.0 ± 3.3% | 560.4 ± 1.3% | 1.009 | 1.579 | 3.840 | 3.647 | 4.028 |
| qlog records, JSON text sequence | 1467503 | 1964.9 ± 5.7% | 1823.5 ± 2.5% | 1155.0 ± 1.2% | 554.2 ± 4.4% | 669.5 ± 42.1% | 469.1 ± 5.0% | 1.077 | 1.701 | 3.546 | 2.935 | 4.188 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2220.0 ± 4.0% | 2236.8 ± 2.9% | 1429.5 ± 27.1% | 587.9 ± 3.7% | 619.0 ± 3.3% | 560.4 ± 1.3% | 0.993 | 1.553 | 3.776 | 3.587 | 3.961 |
| qlog records, JSON text sequence | 1467503 | 1922.4 ± 8.3% | 1823.5 ± 2.5% | 1155.0 ± 1.2% | 554.2 ± 4.4% | 669.5 ± 42.1% | 469.1 ± 5.0% | 1.054 | 1.664 | 3.469 | 2.871 | 4.098 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1326.5 ± 1.9% | 2039.6 ± 2.6% | 1633.5 ± 1.1% | 513.0 ± 4.0% | 806.4 ± 3.4% | 462.1 ± 6.5% | 0.650 | 0.812 | 2.586 | 1.645 | 2.870 |
| qlog records, JSON text sequence | 1467503 | 922.1 ± 9.8% | 1564.6 ± 2.8% | 1469.8 ± 4.4% | 428.8 ± 33.5% | 921.7 ± 50.3% | 455.5 ± 3.6% | 0.589 | 0.627 | 2.150 | 1.000 | 2.024 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1654.6 ± 3.5% | 2236.8 ± 2.9% | 1429.5 ± 27.1% | 587.9 ± 3.7% | 619.0 ± 3.3% | 560.4 ± 1.3% | 0.740 | 1.157 | 2.815 | 2.673 | 2.952 |
| qlog records, JSON text sequence | 1467503 | 1383.6 ± 3.6% | 1823.5 ± 2.5% | 1155.0 ± 1.2% | 554.2 ± 4.4% | 669.5 ± 42.1% | 469.1 ± 5.0% | 0.759 | 1.198 | 2.497 | 2.067 | 2.949 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.760 of simdjson.
- CLDR supplemental, 34 texts, decoding: stdx runs at 0.949 of yyjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.818 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.871 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.650 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.812 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.589 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.627 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.740 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.759 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1555.1 ± 2.2% | 0.533 | 0.990 | 1.027 | 1.021 | 0.396 | 1.004 | 1.019 | 0.396 | 0.869 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1245.7 ± 7.0% | 0.899 | 1.041 | 1.005 | 0.995 | 0.374 | 0.976 | 0.995 | 0.315 | 0.834 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2252.3 ± 4.1% | 0.445 | 0.956 | 0.983 | 1.009 | 1.011 | 0.270 | 1.019 | 0.469 | 0.739 | 0.089 | 1.001 |
| qlog records, JSON text sequence | 1467503 | 2013.5 ± 3.7% | 0.718 | 0.916 | 0.988 | 0.994 | 0.997 | 0.263 | 0.989 | 0.433 | 0.725 | 0.106 | 1.007 |

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
| CLDR supplemental, 34 texts | 920675 | 1555.1 ± 2.2% | 2012.6 ± 1.6% | 1599.8 ± 4.8% | 513.3 ± 1.9% | 705.7 ± 3.8% | 448.5 ± 4.3% | 0.773 | 0.972 | 3.030 | 2.204 | 3.467 |
| qlog records, JSON text sequence | 1467503 | 1245.7 ± 7.0% | 1540.8 ± 1.3% | 1427.0 ± 6.5% | 421.7 ± 5.6% | 870.2 ± 11.8% | 447.0 ± 12.8% | 0.808 | 0.873 | 2.954 | 1.432 | 2.787 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2252.3 ± 4.1% | 2247.5 ± 2.9% | 1452.5 ± 5.3% | 599.1 ± 3.4% | 527.8 ± 5.8% | 579.4 ± 5.2% | 1.002 | 1.551 | 3.760 | 4.267 | 3.887 |
| qlog records, JSON text sequence | 1467503 | 2013.5 ± 3.7% | 1846.4 ± 3.2% | 1177.7 ± 3.1% | 564.6 ± 2.7% | 663.0 ± 1.6% | 479.8 ± 2.5% | 1.090 | 1.710 | 3.566 | 3.037 | 4.196 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2253.6 ± 4.8% | 2247.5 ± 2.9% | 1452.5 ± 5.3% | 599.1 ± 3.4% | 527.8 ± 5.8% | 579.4 ± 5.2% | 1.003 | 1.552 | 3.762 | 4.269 | 3.890 |
| qlog records, JSON text sequence | 1467503 | 2028.5 ± 1.0% | 1846.4 ± 3.2% | 1177.7 ± 3.1% | 564.6 ± 2.7% | 663.0 ± 1.6% | 479.8 ± 2.5% | 1.099 | 1.723 | 3.593 | 3.060 | 4.228 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1350.6 ± 1.8% | 2012.6 ± 1.6% | 1599.8 ± 4.8% | 513.3 ± 1.9% | 705.7 ± 3.8% | 448.5 ± 4.3% | 0.671 | 0.844 | 2.632 | 1.914 | 3.012 |
| qlog records, JSON text sequence | 1467503 | 1038.8 ± 9.4% | 1540.8 ± 1.3% | 1427.0 ± 6.5% | 421.7 ± 5.6% | 870.2 ± 11.8% | 447.0 ± 12.8% | 0.674 | 0.728 | 2.463 | 1.194 | 2.324 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1665.3 ± 2.0% | 2247.5 ± 2.9% | 1452.5 ± 5.3% | 599.1 ± 3.4% | 527.8 ± 5.8% | 579.4 ± 5.2% | 0.741 | 1.147 | 2.780 | 3.155 | 2.874 |
| qlog records, JSON text sequence | 1467503 | 1459.8 ± 2.8% | 1846.4 ± 3.2% | 1177.7 ± 3.1% | 564.6 ± 2.7% | 663.0 ± 1.6% | 479.8 ± 2.5% | 0.791 | 1.240 | 2.585 | 2.202 | 3.042 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.773 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.808 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.873 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.671 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.844 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.674 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.728 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.741 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.791 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1586.7 ± 4.6% | 0.528 | 0.981 | 1.014 | 1.016 | 0.398 | 1.014 | 1.019 | 0.395 | 0.783 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1302.9 ± 3.8% | 0.872 | 1.012 | 0.977 | 0.974 | 0.378 | 0.972 | 0.972 | 0.370 | 0.829 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2262.0 ± 3.5% | 0.444 | 0.950 | 0.981 | 1.006 | 0.992 | 0.271 | 1.011 | 0.470 | 0.743 | 0.083 | 0.992 |
| qlog records, JSON text sequence | 1467503 | 2020.3 ± 5.5% | 0.718 | 0.908 | 0.978 | 0.993 | 0.989 | 0.262 | 0.990 | 0.428 | 0.721 | 0.100 | 0.998 |

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
| CLDR supplemental, 34 texts | 920675 | 1586.7 ± 4.6% | 2028.2 ± 2.9% | 1621.8 ± 3.7% | 512.1 ± 5.9% | 727.5 ± 2.3% | 457.5 ± 2.5% | 0.782 | 0.978 | 3.099 | 2.181 | 3.468 |
| qlog records, JSON text sequence | 1467503 | 1302.9 ± 3.8% | 1537.9 ± 3.9% | 1507.0 ± 3.5% | 432.1 ± 2.9% | 895.6 ± 5.8% | 459.3 ± 5.2% | 0.847 | 0.865 | 3.015 | 1.455 | 2.837 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2262.0 ± 3.5% | 2244.6 ± 2.2% | 1464.0 ± 2.0% | 592.8 ± 4.1% | 539.8 ± 3.1% | 571.7 ± 2.2% | 1.008 | 1.545 | 3.816 | 4.191 | 3.957 |
| qlog records, JSON text sequence | 1467503 | 2020.3 ± 5.5% | 1843.9 ± 10.3% | 1185.5 ± 75.1% | 575.0 ± 57.7% | 683.5 ± 65.9% | 476.8 ± 11.5% | 1.096 | 1.704 | 3.514 | 2.956 | 4.237 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2243.7 ± 3.3% | 2244.6 ± 2.2% | 1464.0 ± 2.0% | 592.8 ± 4.1% | 539.8 ± 3.1% | 571.7 ± 2.2% | 1.000 | 1.533 | 3.785 | 4.157 | 3.925 |
| qlog records, JSON text sequence | 1467503 | 2015.7 ± 0.9% | 1843.9 ± 10.3% | 1185.5 ± 75.1% | 575.0 ± 57.7% | 683.5 ± 65.9% | 476.8 ± 11.5% | 1.093 | 1.700 | 3.506 | 2.949 | 4.228 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1242.6 ± 2.1% | 2028.2 ± 2.9% | 1621.8 ± 3.7% | 512.1 ± 5.9% | 727.5 ± 2.3% | 457.5 ± 2.5% | 0.613 | 0.766 | 2.427 | 1.708 | 2.716 |
| qlog records, JSON text sequence | 1467503 | 1079.9 ± 1.5% | 1537.9 ± 3.9% | 1507.0 ± 3.5% | 432.1 ± 2.9% | 895.6 ± 5.8% | 459.3 ± 5.2% | 0.702 | 0.717 | 2.499 | 1.206 | 2.351 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1680.9 ± 2.9% | 2244.6 ± 2.2% | 1464.0 ± 2.0% | 592.8 ± 4.1% | 539.8 ± 3.1% | 571.7 ± 2.2% | 0.749 | 1.148 | 2.836 | 3.114 | 2.940 |
| qlog records, JSON text sequence | 1467503 | 1456.9 ± 1.3% | 1843.9 ± 10.3% | 1185.5 ± 75.1% | 575.0 ± 57.7% | 683.5 ± 65.9% | 476.8 ± 11.5% | 0.790 | 1.229 | 2.534 | 2.132 | 3.056 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.782 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.847 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.865 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.613 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.766 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.702 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.717 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.749 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.790 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1558.9 ± 3.8% | 0.545 | 0.994 | 1.030 | 1.032 | 0.407 | 1.037 | 1.035 | 0.401 | 0.854 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 1270.1 ± 3.9% | 0.910 | 0.991 | 1.035 | 1.014 | 0.384 | 1.020 | 0.982 | 0.374 | 0.715 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2269.3 ± 1.6% | 0.441 | 0.949 | 0.966 | 0.991 | 0.998 | 0.267 | 1.001 | 0.467 | 0.737 | 0.082 | 0.986 |
| qlog records, JSON text sequence | 1467503 | 2024.3 ± 34.7% | 0.715 | 0.917 | 0.986 | 0.992 | 0.989 | 0.258 | 0.976 | 0.430 | 0.720 | 0.101 | 0.994 |

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
| CLDR supplemental, 34 texts | 920675 | 1558.9 ± 3.8% | 1997.6 ± 2.4% | 1627.0 ± 2.6% | 517.5 ± 2.3% | 808.4 ± 0.5% | 455.0 ± 2.6% | 0.780 | 0.958 | 3.012 | 1.928 | 3.426 |
| qlog records, JSON text sequence | 1467503 | 1270.1 ± 3.9% | 1547.1 ± 1.9% | 1503.7 ± 3.4% | 439.5 ± 6.6% | 901.8 ± 4.8% | 452.7 ± 2.2% | 0.821 | 0.845 | 2.890 | 1.408 | 2.806 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2269.3 ± 1.6% | 2248.8 ± 1.0% | 1431.9 ± 1.6% | 590.0 ± 2.3% | 615.5 ± 3.0% | 568.7 ± 1.3% | 1.009 | 1.585 | 3.846 | 3.687 | 3.990 |
| qlog records, JSON text sequence | 1467503 | 2024.3 ± 34.7% | 1863.4 ± 3.8% | 1172.9 ± 2.9% | 570.7 ± 7.6% | 677.9 ± 4.1% | 477.0 ± 51.5% | 1.086 | 1.726 | 3.547 | 2.986 | 4.244 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2238.5 ± 6.3% | 2248.8 ± 1.0% | 1431.9 ± 1.6% | 590.0 ± 2.3% | 615.5 ± 3.0% | 568.7 ± 1.3% | 0.995 | 1.563 | 3.794 | 3.637 | 3.936 |
| qlog records, JSON text sequence | 1467503 | 2012.7 ± 1.7% | 1863.4 ± 3.8% | 1172.9 ± 2.9% | 570.7 ± 7.6% | 677.9 ± 4.1% | 477.0 ± 51.5% | 1.080 | 1.716 | 3.527 | 2.969 | 4.220 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1331.0 ± 2.3% | 1997.6 ± 2.4% | 1627.0 ± 2.6% | 517.5 ± 2.3% | 808.4 ± 0.5% | 455.0 ± 2.6% | 0.666 | 0.818 | 2.572 | 1.646 | 2.925 |
| qlog records, JSON text sequence | 1467503 | 907.7 ± 2.5% | 1547.1 ± 1.9% | 1503.7 ± 3.4% | 439.5 ± 6.6% | 901.8 ± 4.8% | 452.7 ± 2.2% | 0.587 | 0.604 | 2.065 | 1.007 | 2.005 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1672.6 ± 1.0% | 2248.8 ± 1.0% | 1431.9 ± 1.6% | 590.0 ± 2.3% | 615.5 ± 3.0% | 568.7 ± 1.3% | 0.744 | 1.168 | 2.835 | 2.718 | 2.941 |
| qlog records, JSON text sequence | 1467503 | 1458.0 ± 3.3% | 1863.4 ± 3.8% | 1172.9 ± 2.9% | 570.7 ± 7.6% | 677.9 ± 4.1% | 477.0 ± 51.5% | 0.782 | 1.243 | 2.555 | 2.151 | 3.057 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.780 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.821 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.845 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.666 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.818 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.587 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.604 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.744 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.782 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1578.7 ± 28.2% | 0.527 | 0.981 | 1.024 | 1.021 | 0.398 | 1.015 | 1.024 | 0.394 | 0.857 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1309.1 ± 1.7% | 0.871 | 1.006 | 0.976 | 0.966 | 0.380 | 0.976 | 0.977 | 0.365 | 0.847 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2294.4 ± 2.6% | 0.452 | 0.954 | 0.972 | 1.006 | 1.014 | 0.271 | 1.015 | 0.471 | 0.741 | 0.089 | 0.997 |
| qlog records, JSON text sequence | 1467503 | 2023.4 ± 1.2% | 0.720 | 0.908 | 0.991 | 0.997 | 0.993 | 0.261 | 0.995 | 0.433 | 0.724 | 0.106 | 1.004 |

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
| CLDR supplemental, 34 texts | 920675 | 1578.7 ± 28.2% | 2031.3 ± 0.6% | 1624.6 ± 2.0% | 516.4 ± 2.4% | 725.8 ± 7.0% | 456.8 ± 10.8% | 0.777 | 0.972 | 3.057 | 2.175 | 3.456 |
| qlog records, JSON text sequence | 1467503 | 1309.1 ± 1.7% | 1526.4 ± 6.7% | 1474.9 ± 1.6% | 439.7 ± 2.1% | 901.5 ± 2.3% | 461.9 ± 4.4% | 0.858 | 0.888 | 2.978 | 1.452 | 2.834 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2294.4 ± 2.6% | 2275.9 ± 2.6% | 1482.3 ± 2.5% | 596.4 ± 3.5% | 544.4 ± 2.6% | 577.9 ± 2.4% | 1.008 | 1.548 | 3.847 | 4.215 | 3.970 |
| qlog records, JSON text sequence | 1467503 | 2023.4 ± 1.2% | 1883.2 ± 1.2% | 1203.9 ± 2.6% | 583.8 ± 4.1% | 694.9 ± 3.4% | 476.7 ± 5.0% | 1.074 | 1.681 | 3.466 | 2.912 | 4.245 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2287.6 ± 1.8% | 2275.9 ± 2.6% | 1482.3 ± 2.5% | 596.4 ± 3.5% | 544.4 ± 2.6% | 577.9 ± 2.4% | 1.005 | 1.543 | 3.836 | 4.202 | 3.958 |
| qlog records, JSON text sequence | 1467503 | 2032.1 ± 3.9% | 1883.2 ± 1.2% | 1203.9 ± 2.6% | 583.8 ± 4.1% | 694.9 ± 3.4% | 476.7 ± 5.0% | 1.079 | 1.688 | 3.480 | 2.924 | 4.263 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1352.5 ± 41.6% | 2031.3 ± 0.6% | 1624.6 ± 2.0% | 516.4 ± 2.4% | 725.8 ± 7.0% | 456.8 ± 10.8% | 0.666 | 0.833 | 2.619 | 1.863 | 2.961 |
| qlog records, JSON text sequence | 1467503 | 1108.6 ± 1.3% | 1526.4 ± 6.7% | 1474.9 ± 1.6% | 439.7 ± 2.1% | 901.5 ± 2.3% | 461.9 ± 4.4% | 0.726 | 0.752 | 2.521 | 1.230 | 2.400 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1701.0 ± 2.0% | 2275.9 ± 2.6% | 1482.3 ± 2.5% | 596.4 ± 3.5% | 544.4 ± 2.6% | 577.9 ± 2.4% | 0.747 | 1.148 | 2.852 | 3.125 | 2.943 |
| qlog records, JSON text sequence | 1467503 | 1465.1 ± 58.9% | 1883.2 ± 1.2% | 1203.9 ± 2.6% | 583.8 ± 4.1% | 694.9 ± 3.4% | 476.7 ± 5.0% | 0.778 | 1.217 | 2.509 | 2.108 | 3.074 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.858 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.888 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.726 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.752 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.747 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1593.0 ± 3.1% | 0.531 | 0.983 | 1.018 | 1.009 | 0.397 | 1.013 | 1.008 | 0.395 | 0.784 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1303.3 ± 7.2% | 0.888 | 1.023 | 0.991 | 0.982 | 0.387 | 0.987 | 0.990 | 0.378 | 0.834 | 0.112 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2370.5 ± 3.1% | 0.444 | 0.931 | 0.961 | 0.982 | 0.990 | 0.267 | 1.000 | 0.461 | 0.731 | 0.081 | 0.995 |
| qlog records, JSON text sequence | 1467503 | 2027.7 ± 3.6% | 0.711 | 0.913 | 0.986 | 0.989 | 0.974 | 0.258 | 0.984 | 0.431 | 0.721 | 0.101 | 0.996 |

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
| CLDR supplemental, 34 texts | 920675 | 1593.0 ± 3.1% | 2019.9 ± 1.3% | 1611.4 ± 1.1% | 523.0 ± 7.7% | 730.9 ± 1.1% | 461.0 ± 2.8% | 0.789 | 0.989 | 3.046 | 2.180 | 3.456 |
| qlog records, JSON text sequence | 1467503 | 1303.3 ± 7.2% | 1545.4 ± 1.5% | 1474.1 ± 2.0% | 448.8 ± 3.2% | 923.9 ± 2.5% | 470.2 ± 5.6% | 0.843 | 0.884 | 2.904 | 1.411 | 2.772 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2370.5 ± 3.1% | 2293.9 ± 3.3% | 1472.4 ± 2.2% | 619.8 ± 4.7% | 548.4 ± 3.6% | 592.2 ± 71.4% | 1.033 | 1.610 | 3.825 | 4.323 | 4.003 |
| qlog records, JSON text sequence | 1467503 | 2027.7 ± 3.6% | 1879.8 ± 3.6% | 1216.5 ± 4.5% | 596.4 ± 3.5% | 711.9 ± 1.6% | 489.4 ± 3.1% | 1.079 | 1.667 | 3.400 | 2.848 | 4.143 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2358.5 ± 5.1% | 2293.9 ± 3.3% | 1472.4 ± 2.2% | 619.8 ± 4.7% | 548.4 ± 3.6% | 592.2 ± 71.4% | 1.028 | 1.602 | 3.805 | 4.301 | 3.982 |
| qlog records, JSON text sequence | 1467503 | 2019.7 ± 3.6% | 1879.8 ± 3.6% | 1216.5 ± 4.5% | 596.4 ± 3.5% | 711.9 ± 1.6% | 489.4 ± 3.1% | 1.074 | 1.660 | 3.386 | 2.837 | 4.127 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1249.1 ± 0.5% | 2019.9 ± 1.3% | 1611.4 ± 1.1% | 523.0 ± 7.7% | 730.9 ± 1.1% | 461.0 ± 2.8% | 0.618 | 0.775 | 2.388 | 1.709 | 2.710 |
| qlog records, JSON text sequence | 1467503 | 1087.4 ± 1.2% | 1545.4 ± 1.5% | 1474.1 ± 2.0% | 448.8 ± 3.2% | 923.9 ± 2.5% | 470.2 ± 5.6% | 0.704 | 0.738 | 2.423 | 1.177 | 2.313 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1732.8 ± 1.4% | 2293.9 ± 3.3% | 1472.4 ± 2.2% | 619.8 ± 4.7% | 548.4 ± 3.6% | 592.2 ± 71.4% | 0.755 | 1.177 | 2.796 | 3.160 | 2.926 |
| qlog records, JSON text sequence | 1467503 | 1462.4 ± 3.4% | 1879.8 ± 3.6% | 1216.5 ± 4.5% | 596.4 ± 3.5% | 711.9 ± 1.6% | 489.4 ± 3.1% | 0.778 | 1.202 | 2.452 | 2.054 | 2.988 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.789 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.843 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.884 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.618 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.775 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.704 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.738 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.755 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.778 of simdjson.
