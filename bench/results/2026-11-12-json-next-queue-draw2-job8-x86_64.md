# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1351.4 ± 1.8% | 0.473 | 0.996 | 0.979 | 0.988 | 0.368 | 0.986 | 0.977 | 0.345 | 0.762 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1058.6 ± 3.5% | 0.800 | 1.031 | 1.020 | 1.027 | 0.375 | 1.031 | 1.006 | 0.343 | 0.700 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1737.5 ± 1.6% | 0.426 | 0.976 | 0.975 | 1.016 | 1.005 | 0.252 | 1.008 | 0.445 | 0.742 | 0.089 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1487.2 ± 0.2% | 0.682 | 0.956 | 0.990 | 0.995 | 0.993 | 0.252 | 0.993 | 0.421 | 0.727 | 0.114 | 1.012 |

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
| CLDR supplemental, 34 texts | 920675 | 1351.4 ± 1.8% | 1337.2 ± 33.0% | 1213.8 ± 0.8% | 356.6 ± 5.3% | 667.7 ± 0.6% | 317.9 ± 4.2% | 1.011 | 1.113 | 3.789 | 2.024 | 4.252 |
| qlog records, JSON text sequence | 1467503 | 1058.6 ± 3.5% | 1058.9 ± 0.3% | 1061.9 ± 2.5% | 305.0 ± 3.9% | 726.8 ± 1.8% | 314.3 ± 5.8% | 1.000 | 0.997 | 3.471 | 1.457 | 3.368 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1737.5 ± 1.6% | 1590.4 ± 1.6% | 1157.2 ± 1.3% | 425.4 ± 0.8% | 458.0 ± 1.0% | 410.8 ± 1.4% | 1.092 | 1.501 | 4.084 | 3.794 | 4.230 |
| qlog records, JSON text sequence | 1467503 | 1487.2 ± 0.2% | 1312.3 ± 0.3% | 898.9 ± 0.3% | 421.8 ± 8.2% | 500.4 ± 4.2% | 324.4 ± 5.5% | 1.133 | 1.654 | 3.526 | 2.972 | 4.585 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1784.5 ± 1.0% | 1590.4 ± 1.6% | 1157.2 ± 1.3% | 425.4 ± 0.8% | 458.0 ± 1.0% | 410.8 ± 1.4% | 1.122 | 1.542 | 4.194 | 3.896 | 4.344 |
| qlog records, JSON text sequence | 1467503 | 1505.6 ± 0.1% | 1312.3 ± 0.3% | 898.9 ± 0.3% | 421.8 ± 8.2% | 500.4 ± 4.2% | 324.4 ± 5.5% | 1.147 | 1.675 | 3.569 | 3.009 | 4.642 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1029.9 ± 10.0% | 1337.2 ± 33.0% | 1213.8 ± 0.8% | 356.6 ± 5.3% | 667.7 ± 0.6% | 317.9 ± 4.2% | 0.770 | 0.849 | 2.888 | 1.543 | 3.240 |
| qlog records, JSON text sequence | 1467503 | 741.5 ± 0.4% | 1058.9 ± 0.3% | 1061.9 ± 2.5% | 305.0 ± 3.9% | 726.8 ± 1.8% | 314.3 ± 5.8% | 0.700 | 0.698 | 2.431 | 1.020 | 2.359 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1289.8 ± 1.9% | 1590.4 ± 1.6% | 1157.2 ± 1.3% | 425.4 ± 0.8% | 458.0 ± 1.0% | 410.8 ± 1.4% | 0.811 | 1.115 | 3.032 | 2.816 | 3.140 |
| qlog records, JSON text sequence | 1467503 | 1081.8 ± 0.6% | 1312.3 ± 0.3% | 898.9 ± 0.3% | 421.8 ± 8.2% | 500.4 ± 4.2% | 324.4 ± 5.5% | 0.824 | 1.203 | 2.565 | 2.162 | 3.335 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.849 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.700 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.698 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.811 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.824 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1421.7 ± 0.7% | 0.433 | 0.892 | 0.935 | 0.935 | 0.355 | 0.959 | 0.933 | 0.332 | 0.752 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1086.3 ± 1.2% | 0.739 | 0.977 | 0.947 | 0.948 | 0.362 | 0.976 | 0.949 | 0.333 | 0.800 | 0.117 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1760.2 ± 4.7% | 0.419 | 0.951 | 0.956 | 0.993 | 0.995 | 0.246 | 0.995 | 0.439 | 0.736 | 0.087 | 1.012 |
| qlog records, JSON text sequence | 1467503 | 1489.2 ± 6.9% | 0.683 | 0.944 | 0.991 | 0.993 | 0.990 | 0.251 | 0.989 | 0.421 | 0.728 | 0.113 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1421.7 ± 0.7% | 1329.8 ± 1.2% | 1211.0 ± 0.9% | 358.3 ± 1.0% | 666.2 ± 5.7% | 321.2 ± 1.8% | 1.069 | 1.174 | 3.968 | 2.134 | 4.426 |
| qlog records, JSON text sequence | 1467503 | 1086.3 ± 1.2% | 1049.5 ± 0.6% | 1070.0 ± 3.2% | 299.7 ± 2.4% | 727.9 ± 1.3% | 311.2 ± 2.6% | 1.035 | 1.015 | 3.625 | 1.492 | 3.491 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1760.2 ± 4.7% | 1589.9 ± 20.7% | 1152.8 ± 4.9% | 423.3 ± 0.2% | 456.6 ± 0.9% | 414.0 ± 4.9% | 1.107 | 1.527 | 4.159 | 3.855 | 4.252 |
| qlog records, JSON text sequence | 1467503 | 1489.2 ± 6.9% | 1315.6 ± 11.4% | 905.8 ± 0.4% | 427.3 ± 7.9% | 482.5 ± 0.3% | 327.5 ± 2.3% | 1.132 | 1.644 | 3.485 | 3.086 | 4.548 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1782.0 ± 0.9% | 1589.9 ± 20.7% | 1152.8 ± 4.9% | 423.3 ± 0.2% | 456.6 ± 0.9% | 414.0 ± 4.9% | 1.121 | 1.546 | 4.210 | 3.902 | 4.305 |
| qlog records, JSON text sequence | 1467503 | 1504.2 ± 1.4% | 1315.6 ± 11.4% | 905.8 ± 0.4% | 427.3 ± 7.9% | 482.5 ± 0.3% | 327.5 ± 2.3% | 1.143 | 1.661 | 3.521 | 3.118 | 4.594 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1068.6 ± 1.4% | 1329.8 ± 1.2% | 1211.0 ± 0.9% | 358.3 ± 1.0% | 666.2 ± 5.7% | 321.2 ± 1.8% | 0.804 | 0.882 | 2.983 | 1.604 | 3.327 |
| qlog records, JSON text sequence | 1467503 | 869.5 ± 3.2% | 1049.5 ± 0.6% | 1070.0 ± 3.2% | 299.7 ± 2.4% | 727.9 ± 1.3% | 311.2 ± 2.6% | 0.828 | 0.813 | 2.901 | 1.195 | 2.794 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1294.8 ± 13.5% | 1589.9 ± 20.7% | 1152.8 ± 4.9% | 423.3 ± 0.2% | 456.6 ± 0.9% | 414.0 ± 4.9% | 0.814 | 1.123 | 3.059 | 2.835 | 3.128 |
| qlog records, JSON text sequence | 1467503 | 1083.5 ± 25.6% | 1315.6 ± 11.4% | 905.8 ± 0.4% | 427.3 ± 7.9% | 482.5 ± 0.3% | 327.5 ± 2.3% | 0.824 | 1.196 | 2.536 | 2.246 | 3.309 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.804 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.882 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.828 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.813 of yyjson.

# bench-json, CLDR and qlog alone: q16, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1415.5 ± 3.7% | 0.431 | 0.906 | 0.937 | 0.939 | 0.356 | 0.965 | 0.934 | 0.333 | 0.728 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1104.7 ± 4.0% | 0.730 | 0.970 | 0.940 | 0.940 | 0.356 | 0.967 | 0.940 | 0.333 | 0.812 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1764.9 ± 1.1% | 0.419 | 0.954 | 0.957 | 0.991 | 0.997 | 0.248 | 0.999 | 0.438 | 0.737 | 0.086 | 1.010 |
| qlog records, JSON text sequence | 1467503 | 1489.3 ± 0.5% | 0.681 | 0.944 | 0.990 | 0.996 | 0.989 | 0.249 | 0.990 | 0.421 | 0.728 | 0.112 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1415.5 ± 3.7% | 1346.0 ± 1.0% | 1207.8 ± 0.7% | 356.9 ± 0.9% | 665.7 ± 6.5% | 318.0 ± 2.5% | 1.052 | 1.172 | 3.966 | 2.126 | 4.451 |
| qlog records, JSON text sequence | 1467503 | 1104.7 ± 4.0% | 1055.1 ± 0.7% | 1084.8 ± 0.6% | 301.4 ± 3.0% | 730.6 ± 0.8% | 305.9 ± 5.1% | 1.047 | 1.018 | 3.665 | 1.512 | 3.611 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1764.9 ± 1.1% | 1604.1 ± 1.0% | 1169.1 ± 2.0% | 424.4 ± 0.7% | 456.0 ± 4.9% | 412.4 ± 5.7% | 1.100 | 1.510 | 4.159 | 3.871 | 4.280 |
| qlog records, JSON text sequence | 1467503 | 1489.3 ± 0.5% | 1314.7 ± 2.6% | 907.1 ± 0.2% | 426.2 ± 1.2% | 500.4 ± 0.2% | 330.6 ± 1.6% | 1.133 | 1.642 | 3.495 | 2.977 | 4.505 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1781.9 ± 6.5% | 1604.1 ± 1.0% | 1169.1 ± 2.0% | 424.4 ± 0.7% | 456.0 ± 4.9% | 412.4 ± 5.7% | 1.111 | 1.524 | 4.199 | 3.908 | 4.321 |
| qlog records, JSON text sequence | 1467503 | 1504.4 ± 0.8% | 1314.7 ± 2.6% | 907.1 ± 0.2% | 426.2 ± 1.2% | 500.4 ± 0.2% | 330.6 ± 1.6% | 1.144 | 1.658 | 3.530 | 3.007 | 4.551 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1029.9 ± 4.5% | 1346.0 ± 1.0% | 1207.8 ± 0.7% | 356.9 ± 0.9% | 665.7 ± 6.5% | 318.0 ± 2.5% | 0.765 | 0.853 | 2.886 | 1.547 | 3.238 |
| qlog records, JSON text sequence | 1467503 | 897.5 ± 3.5% | 1055.1 ± 0.7% | 1084.8 ± 0.6% | 301.4 ± 3.0% | 730.6 ± 0.8% | 305.9 ± 5.1% | 0.851 | 0.827 | 2.977 | 1.229 | 2.934 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1300.1 ± 5.1% | 1604.1 ± 1.0% | 1169.1 ± 2.0% | 424.4 ± 0.7% | 456.0 ± 4.9% | 412.4 ± 5.7% | 0.810 | 1.112 | 3.064 | 2.851 | 3.152 |
| qlog records, JSON text sequence | 1467503 | 1084.7 ± 0.3% | 1314.7 ± 2.6% | 907.1 ± 0.2% | 426.2 ± 1.2% | 500.4 ± 0.2% | 330.6 ± 1.6% | 0.825 | 1.196 | 2.545 | 2.168 | 3.281 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.765 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.853 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.851 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.827 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.810 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.825 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1421.9 ± 2.1% | 0.431 | 0.898 | 0.934 | 0.933 | 0.355 | 0.957 | 0.934 | 0.331 | 0.724 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1103.3 ± 1.4% | 0.726 | 0.965 | 0.933 | 0.934 | 0.357 | 0.963 | 0.937 | 0.328 | 0.812 | 0.115 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1758.1 ± 0.9% | 0.421 | 0.952 | 0.960 | 0.991 | 1.003 | 0.248 | 1.001 | 0.439 | 0.732 | 0.087 | 1.013 |
| qlog records, JSON text sequence | 1467503 | 1487.9 ± 0.8% | 0.682 | 0.944 | 0.990 | 0.992 | 0.987 | 0.249 | 0.989 | 0.418 | 0.713 | 0.113 | 1.005 |

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
| CLDR supplemental, 34 texts | 920675 | 1421.9 ± 2.1% | 1330.5 ± 0.4% | 1211.8 ± 0.5% | 358.6 ± 1.8% | 662.9 ± 1.0% | 320.0 ± 3.5% | 1.069 | 1.173 | 3.965 | 2.145 | 4.444 |
| qlog records, JSON text sequence | 1467503 | 1103.3 ± 1.4% | 1038.6 ± 1.7% | 1080.1 ± 1.7% | 304.2 ± 0.9% | 728.6 ± 0.7% | 319.3 ± 0.8% | 1.062 | 1.021 | 3.627 | 1.514 | 3.456 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1758.1 ± 0.9% | 1600.2 ± 0.9% | 1157.1 ± 1.5% | 424.3 ± 0.4% | 455.8 ± 2.6% | 417.1 ± 0.8% | 1.099 | 1.519 | 4.143 | 3.857 | 4.215 |
| qlog records, JSON text sequence | 1467503 | 1487.9 ± 0.8% | 1314.3 ± 5.2% | 906.8 ± 0.4% | 427.4 ± 0.7% | 496.7 ± 1.2% | 330.7 ± 1.1% | 1.132 | 1.641 | 3.482 | 2.996 | 4.499 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1781.1 ± 1.1% | 1600.2 ± 0.9% | 1157.1 ± 1.5% | 424.3 ± 0.4% | 455.8 ± 2.6% | 417.1 ± 0.8% | 1.113 | 1.539 | 4.198 | 3.908 | 4.270 |
| qlog records, JSON text sequence | 1467503 | 1496.0 ± 0.5% | 1314.3 ± 5.2% | 906.8 ± 0.4% | 427.4 ± 0.7% | 496.7 ± 1.2% | 330.7 ± 1.1% | 1.138 | 1.650 | 3.501 | 3.012 | 4.524 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1028.9 ± 0.6% | 1330.5 ± 0.4% | 1211.8 ± 0.5% | 358.6 ± 1.8% | 662.9 ± 1.0% | 320.0 ± 3.5% | 0.773 | 0.849 | 2.869 | 1.552 | 3.216 |
| qlog records, JSON text sequence | 1467503 | 895.8 ± 1.9% | 1038.6 ± 1.7% | 1080.1 ± 1.7% | 304.2 ± 0.9% | 728.6 ± 0.7% | 319.3 ± 0.8% | 0.862 | 0.829 | 2.945 | 1.229 | 2.806 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1286.5 ± 0.4% | 1600.2 ± 0.9% | 1157.1 ± 1.5% | 424.3 ± 0.4% | 455.8 ± 2.6% | 417.1 ± 0.8% | 0.804 | 1.112 | 3.032 | 2.823 | 3.084 |
| qlog records, JSON text sequence | 1467503 | 1060.3 ± 0.3% | 1314.3 ± 5.2% | 906.8 ± 0.4% | 427.4 ± 0.7% | 496.7 ± 1.2% | 330.7 ± 1.1% | 0.807 | 1.169 | 2.481 | 2.135 | 3.206 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.773 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.849 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.862 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.829 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.804 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.807 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1418.5 ± 0.7% | 0.433 | 0.922 | 0.936 | 0.931 | 0.356 | 0.959 | 0.933 | 0.332 | 0.742 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1110.1 ± 3.8% | 0.718 | 0.966 | 0.952 | 0.932 | 0.356 | 0.964 | 0.931 | 0.332 | 0.827 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1754.6 ± 1.5% | 0.420 | 0.953 | 0.958 | 0.992 | 0.995 | 0.248 | 0.992 | 0.437 | 0.729 | 0.087 | 1.008 |
| qlog records, JSON text sequence | 1467503 | 1489.0 ± 6.6% | 0.681 | 0.945 | 0.991 | 0.993 | 0.989 | 0.249 | 0.989 | 0.418 | 0.711 | 0.113 | 1.006 |

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
| CLDR supplemental, 34 texts | 920675 | 1418.5 ± 0.7% | 1347.0 ± 0.5% | 1208.8 ± 1.1% | 357.7 ± 0.5% | 666.2 ± 1.4% | 318.1 ± 2.7% | 1.053 | 1.173 | 3.965 | 2.129 | 4.460 |
| qlog records, JSON text sequence | 1467503 | 1110.1 ± 3.8% | 1041.0 ± 0.8% | 1086.2 ± 0.3% | 301.1 ± 0.8% | 728.9 ± 0.9% | 316.2 ± 2.4% | 1.066 | 1.022 | 3.687 | 1.523 | 3.511 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1754.6 ± 1.5% | 1581.1 ± 1.4% | 1152.5 ± 1.3% | 423.0 ± 0.6% | 451.1 ± 3.5% | 416.4 ± 0.3% | 1.110 | 1.522 | 4.148 | 3.890 | 4.214 |
| qlog records, JSON text sequence | 1467503 | 1489.0 ± 6.6% | 1312.2 ± 0.1% | 905.6 ± 0.2% | 428.7 ± 0.8% | 495.5 ± 0.4% | 330.7 ± 1.5% | 1.135 | 1.644 | 3.473 | 3.005 | 4.502 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1768.4 ± 1.0% | 1581.1 ± 1.4% | 1152.5 ± 1.3% | 423.0 ± 0.6% | 451.1 ± 3.5% | 416.4 ± 0.3% | 1.118 | 1.534 | 4.181 | 3.920 | 4.247 |
| qlog records, JSON text sequence | 1467503 | 1497.6 ± 0.2% | 1312.2 ± 0.1% | 905.6 ± 0.2% | 428.7 ± 0.8% | 495.5 ± 0.4% | 330.7 ± 1.5% | 1.141 | 1.654 | 3.493 | 3.023 | 4.528 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1051.8 ± 1.6% | 1347.0 ± 0.5% | 1208.8 ± 1.1% | 357.7 ± 0.5% | 666.2 ± 1.4% | 318.1 ± 2.7% | 0.781 | 0.870 | 2.940 | 1.579 | 3.307 |
| qlog records, JSON text sequence | 1467503 | 917.6 ± 2.6% | 1041.0 ± 0.8% | 1086.2 ± 0.3% | 301.1 ± 0.8% | 728.9 ± 0.9% | 316.2 ± 2.4% | 0.881 | 0.845 | 3.048 | 1.259 | 2.902 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1278.5 ± 4.1% | 1581.1 ± 1.4% | 1152.5 ± 1.3% | 423.0 ± 0.6% | 451.1 ± 3.5% | 416.4 ± 0.3% | 0.809 | 1.109 | 3.023 | 2.834 | 3.071 |
| qlog records, JSON text sequence | 1467503 | 1058.1 ± 0.3% | 1312.2 ± 0.1% | 905.6 ± 0.2% | 428.7 ± 0.8% | 495.5 ± 0.4% | 330.7 ± 1.5% | 0.806 | 1.168 | 2.468 | 2.136 | 3.199 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.781 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.870 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.881 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.845 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.809 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.806 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1345.3 ± 2.0% | 0.477 | 0.996 | 0.987 | 0.987 | 0.371 | 0.988 | 0.985 | 0.348 | 0.777 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1064.7 ± 1.2% | 0.793 | 1.029 | 1.028 | 1.031 | 0.373 | 1.031 | 1.011 | 0.344 | 0.690 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1752.0 ± 0.7% | 0.423 | 0.972 | 0.963 | 0.998 | 1.000 | 0.250 | 0.996 | 0.442 | 0.738 | 0.088 | 1.018 |
| qlog records, JSON text sequence | 1467503 | 1480.8 ± 0.1% | 0.674 | 0.952 | 0.986 | 0.993 | 0.994 | 0.254 | 0.992 | 0.425 | 0.732 | 0.115 | 1.007 |

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
| CLDR supplemental, 34 texts | 920675 | 1345.3 ± 2.0% | 1283.3 ± 0.5% | 1190.7 ± 0.7% | 356.5 ± 1.3% | 664.4 ± 1.4% | 320.1 ± 2.4% | 1.048 | 1.130 | 3.773 | 2.025 | 4.202 |
| qlog records, JSON text sequence | 1467503 | 1064.7 ± 1.2% | 1030.8 ± 0.3% | 1049.4 ± 6.4% | 307.4 ± 2.8% | 730.5 ± 2.0% | 316.5 ± 1.8% | 1.033 | 1.015 | 3.464 | 1.457 | 3.364 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1752.0 ± 0.7% | 1594.9 ± 5.5% | 1167.1 ± 4.1% | 425.5 ± 2.0% | 460.6 ± 2.9% | 412.8 ± 0.7% | 1.098 | 1.501 | 4.117 | 3.804 | 4.244 |
| qlog records, JSON text sequence | 1467503 | 1480.8 ± 0.1% | 1317.4 ± 0.2% | 889.5 ± 0.3% | 421.6 ± 0.8% | 498.8 ± 0.2% | 324.8 ± 0.3% | 1.124 | 1.665 | 3.512 | 2.968 | 4.559 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1784.0 ± 5.1% | 1594.9 ± 5.5% | 1167.1 ± 4.1% | 425.5 ± 2.0% | 460.6 ± 2.9% | 412.8 ± 0.7% | 1.119 | 1.529 | 4.193 | 3.873 | 4.322 |
| qlog records, JSON text sequence | 1467503 | 1490.8 ± 0.5% | 1317.4 ± 0.2% | 889.5 ± 0.3% | 421.6 ± 0.8% | 498.8 ± 0.2% | 324.8 ± 0.3% | 1.132 | 1.676 | 3.536 | 2.989 | 4.590 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1044.7 ± 4.2% | 1283.3 ± 0.5% | 1190.7 ± 0.7% | 356.5 ± 1.3% | 664.4 ± 1.4% | 320.1 ± 2.4% | 0.814 | 0.877 | 2.930 | 1.572 | 3.263 |
| qlog records, JSON text sequence | 1467503 | 735.2 ± 0.4% | 1030.8 ± 0.3% | 1049.4 ± 6.4% | 307.4 ± 2.8% | 730.5 ± 2.0% | 316.5 ± 1.8% | 0.713 | 0.701 | 2.392 | 1.006 | 2.323 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1292.6 ± 1.0% | 1594.9 ± 5.5% | 1167.1 ± 4.1% | 425.5 ± 2.0% | 460.6 ± 2.9% | 412.8 ± 0.7% | 0.810 | 1.108 | 3.038 | 2.806 | 3.132 |
| qlog records, JSON text sequence | 1467503 | 1084.0 ± 0.6% | 1317.4 ± 0.2% | 889.5 ± 0.3% | 421.6 ± 0.8% | 498.8 ± 0.2% | 324.8 ± 0.3% | 0.823 | 1.219 | 2.571 | 2.173 | 3.338 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.814 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.877 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.713 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.701 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.810 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.823 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1424.2 ± 0.4% | 0.427 | 0.905 | 0.929 | 0.935 | 0.350 | 0.959 | 0.931 | 0.331 | 0.760 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1087.8 ± 3.7% | 0.737 | 0.979 | 0.948 | 0.949 | 0.362 | 0.972 | 0.948 | 0.334 | 0.800 | 0.117 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1759.0 ± 0.7% | 0.420 | 0.958 | 0.957 | 0.990 | 0.991 | 0.248 | 0.996 | 0.437 | 0.734 | 0.086 | 1.011 |
| qlog records, JSON text sequence | 1467503 | 1488.2 ± 0.4% | 0.683 | 0.947 | 0.991 | 0.995 | 0.990 | 0.249 | 0.990 | 0.421 | 0.728 | 0.113 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1424.2 ± 0.4% | 1358.9 ± 1.5% | 1210.0 ± 1.7% | 356.5 ± 1.8% | 663.3 ± 1.4% | 320.1 ± 1.8% | 1.048 | 1.177 | 3.995 | 2.147 | 4.450 |
| qlog records, JSON text sequence | 1467503 | 1087.8 ± 3.7% | 1045.6 ± 0.6% | 1041.7 ± 1.9% | 301.4 ± 3.5% | 719.8 ± 0.7% | 307.5 ± 1.5% | 1.040 | 1.044 | 3.609 | 1.511 | 3.538 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1759.0 ± 0.7% | 1590.8 ± 0.2% | 1169.1 ± 2.0% | 423.0 ± 2.3% | 456.2 ± 1.9% | 416.0 ± 0.5% | 1.106 | 1.505 | 4.159 | 3.856 | 4.229 |
| qlog records, JSON text sequence | 1467503 | 1488.2 ± 0.4% | 1318.6 ± 0.2% | 906.2 ± 0.4% | 427.5 ± 0.7% | 480.9 ± 0.2% | 331.3 ± 0.6% | 1.129 | 1.642 | 3.481 | 3.095 | 4.492 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1778.0 ± 1.0% | 1590.8 ± 0.2% | 1169.1 ± 2.0% | 423.0 ± 2.3% | 456.2 ± 1.9% | 416.0 ± 0.5% | 1.118 | 1.521 | 4.204 | 3.897 | 4.274 |
| qlog records, JSON text sequence | 1467503 | 1503.1 ± 2.3% | 1318.6 ± 0.2% | 906.2 ± 0.4% | 427.5 ± 0.7% | 480.9 ± 0.2% | 331.3 ± 0.6% | 1.140 | 1.659 | 3.516 | 3.125 | 4.537 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1082.9 ± 1.7% | 1358.9 ± 1.5% | 1210.0 ± 1.7% | 356.5 ± 1.8% | 663.3 ± 1.4% | 320.1 ± 1.8% | 0.797 | 0.895 | 3.037 | 1.632 | 3.383 |
| qlog records, JSON text sequence | 1467503 | 870.1 ± 1.6% | 1045.6 ± 0.6% | 1041.7 ± 1.9% | 301.4 ± 3.5% | 719.8 ± 0.7% | 307.5 ± 1.5% | 0.832 | 0.835 | 2.887 | 1.209 | 2.830 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1290.3 ± 2.4% | 1590.8 ± 0.2% | 1169.1 ± 2.0% | 423.0 ± 2.3% | 456.2 ± 1.9% | 416.0 ± 0.5% | 0.811 | 1.104 | 3.051 | 2.828 | 3.102 |
| qlog records, JSON text sequence | 1467503 | 1083.4 ± 0.3% | 1318.6 ± 0.2% | 906.2 ± 0.4% | 427.5 ± 0.7% | 480.9 ± 0.2% | 331.3 ± 0.6% | 0.822 | 1.196 | 2.534 | 2.253 | 3.270 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.797 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.895 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.832 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.835 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.811 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.822 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1421.6 ± 1.3% | 0.429 | 0.903 | 0.936 | 0.934 | 0.355 | 0.962 | 0.931 | 0.331 | 0.726 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1089.5 ± 3.0% | 0.722 | 0.977 | 0.943 | 0.945 | 0.357 | 0.973 | 0.946 | 0.332 | 0.819 | 0.117 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1749.7 ± 1.3% | 0.421 | 0.959 | 0.965 | 0.995 | 0.998 | 0.249 | 1.001 | 0.439 | 0.737 | 0.088 | 1.013 |
| qlog records, JSON text sequence | 1467503 | 1490.2 ± 0.2% | 0.681 | 0.943 | 0.991 | 0.994 | 0.988 | 0.249 | 0.986 | 0.421 | 0.727 | 0.113 | 1.009 |

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
| CLDR supplemental, 34 texts | 920675 | 1421.6 ± 1.3% | 1318.6 ± 0.2% | 1194.4 ± 0.6% | 357.1 ± 2.0% | 670.0 ± 1.6% | 320.4 ± 2.5% | 1.078 | 1.190 | 3.981 | 2.122 | 4.437 |
| qlog records, JSON text sequence | 1467503 | 1089.5 ± 3.0% | 1024.6 ± 0.6% | 1021.6 ± 1.1% | 302.9 ± 2.1% | 721.3 ± 0.9% | 308.9 ± 2.7% | 1.063 | 1.067 | 3.597 | 1.510 | 3.528 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1749.7 ± 1.3% | 1584.4 ± 1.8% | 1176.8 ± 1.5% | 423.3 ± 0.5% | 456.7 ± 2.6% | 417.0 ± 3.0% | 1.104 | 1.487 | 4.134 | 3.831 | 4.196 |
| qlog records, JSON text sequence | 1467503 | 1490.2 ± 0.2% | 1314.9 ± 0.4% | 906.4 ± 0.3% | 427.0 ± 0.9% | 499.2 ± 0.3% | 331.0 ± 1.0% | 1.133 | 1.644 | 3.490 | 2.986 | 4.502 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1772.0 ± 1.7% | 1584.4 ± 1.8% | 1176.8 ± 1.5% | 423.3 ± 0.5% | 456.7 ± 2.6% | 417.0 ± 3.0% | 1.118 | 1.506 | 4.187 | 3.880 | 4.250 |
| qlog records, JSON text sequence | 1467503 | 1503.4 ± 2.2% | 1314.9 ± 0.4% | 906.4 ± 0.3% | 427.0 ± 0.9% | 499.2 ± 0.3% | 331.0 ± 1.0% | 1.143 | 1.659 | 3.521 | 3.012 | 4.542 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1032.5 ± 1.4% | 1318.6 ± 0.2% | 1194.4 ± 0.6% | 357.1 ± 2.0% | 670.0 ± 1.6% | 320.4 ± 2.5% | 0.783 | 0.864 | 2.891 | 1.541 | 3.223 |
| qlog records, JSON text sequence | 1467503 | 892.2 ± 1.4% | 1024.6 ± 0.6% | 1021.6 ± 1.1% | 302.9 ± 2.1% | 721.3 ± 0.9% | 308.9 ± 2.7% | 0.871 | 0.873 | 2.946 | 1.237 | 2.889 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1289.7 ± 0.3% | 1584.4 ± 1.8% | 1176.8 ± 1.5% | 423.3 ± 0.5% | 456.7 ± 2.6% | 417.0 ± 3.0% | 0.814 | 1.096 | 3.047 | 2.824 | 3.093 |
| qlog records, JSON text sequence | 1467503 | 1083.7 ± 1.9% | 1314.9 ± 0.4% | 906.4 ± 0.3% | 427.0 ± 0.9% | 499.2 ± 0.3% | 331.0 ± 1.0% | 0.824 | 1.196 | 2.538 | 2.171 | 3.274 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.783 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.864 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.871 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.873 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.814 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.824 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1418.1 ± 1.5% | 0.425 | 0.893 | 0.935 | 0.932 | 0.354 | 0.960 | 0.931 | 0.332 | 0.730 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1085.2 ± 3.5% | 0.740 | 0.985 | 0.955 | 0.957 | 0.364 | 0.983 | 0.956 | 0.339 | 0.836 | 0.118 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1755.5 ± 2.0% | 0.421 | 0.954 | 0.958 | 0.995 | 1.002 | 0.249 | 1.000 | 0.440 | 0.741 | 0.087 | 1.008 |
| qlog records, JSON text sequence | 1467503 | 1491.0 ± 0.5% | 0.680 | 0.943 | 0.988 | 0.991 | 0.986 | 0.249 | 0.986 | 0.422 | 0.729 | 0.113 | 1.007 |

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
| CLDR supplemental, 34 texts | 920675 | 1418.1 ± 1.5% | 1309.5 ± 3.4% | 1190.6 ± 1.0% | 355.6 ± 1.9% | 669.9 ± 1.7% | 322.1 ± 6.0% | 1.083 | 1.191 | 3.988 | 2.117 | 4.402 |
| qlog records, JSON text sequence | 1467503 | 1085.2 ± 3.5% | 1009.3 ± 0.5% | 1066.3 ± 0.2% | 299.9 ± 6.0% | 731.2 ± 0.4% | 318.0 ± 3.7% | 1.075 | 1.018 | 3.619 | 1.484 | 3.412 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1755.5 ± 2.0% | 1603.7 ± 1.1% | 1171.4 ± 3.3% | 424.7 ± 0.5% | 456.1 ± 8.5% | 416.2 ± 0.7% | 1.095 | 1.499 | 4.134 | 3.849 | 4.218 |
| qlog records, JSON text sequence | 1467503 | 1491.0 ± 0.5% | 1314.6 ± 0.3% | 907.4 ± 0.1% | 425.6 ± 8.6% | 499.6 ± 0.4% | 331.4 ± 1.3% | 1.134 | 1.643 | 3.504 | 2.985 | 4.499 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1770.1 ± 5.7% | 1603.7 ± 1.1% | 1171.4 ± 3.3% | 424.7 ± 0.5% | 456.1 ± 8.5% | 416.2 ± 0.7% | 1.104 | 1.511 | 4.168 | 3.881 | 4.253 |
| qlog records, JSON text sequence | 1467503 | 1500.9 ± 0.2% | 1314.6 ± 0.3% | 907.4 ± 0.1% | 425.6 ± 8.6% | 499.6 ± 0.4% | 331.4 ± 1.3% | 1.142 | 1.654 | 3.527 | 3.004 | 4.529 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1035.5 ± 1.9% | 1309.5 ± 3.4% | 1190.6 ± 1.0% | 355.6 ± 1.9% | 669.9 ± 1.7% | 322.1 ± 6.0% | 0.791 | 0.870 | 2.912 | 1.546 | 3.215 |
| qlog records, JSON text sequence | 1467503 | 907.6 ± 4.9% | 1009.3 ± 0.5% | 1066.3 ± 0.2% | 299.9 ± 6.0% | 731.2 ± 0.4% | 318.0 ± 3.7% | 0.899 | 0.851 | 3.027 | 1.241 | 2.854 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1300.3 ± 4.7% | 1603.7 ± 1.1% | 1171.4 ± 3.3% | 424.7 ± 0.5% | 456.1 ± 8.5% | 416.2 ± 0.7% | 0.811 | 1.110 | 3.062 | 2.851 | 3.124 |
| qlog records, JSON text sequence | 1467503 | 1087.1 ± 0.2% | 1314.6 ± 0.3% | 907.4 ± 0.1% | 425.6 ± 8.6% | 499.6 ± 0.4% | 331.4 ± 1.3% | 0.827 | 1.198 | 2.554 | 2.176 | 3.280 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.791 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.870 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.899 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.851 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.811 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.827 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1421.9 ± 2.1% | 0.430 | 0.890 | 0.938 | 0.936 | 0.354 | 0.957 | 0.934 | 0.331 | 0.743 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1097.5 ± 3.1% | 0.725 | 0.973 | 0.944 | 0.933 | 0.358 | 0.970 | 0.935 | 0.331 | 0.832 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1759.1 ± 0.7% | 0.419 | 0.957 | 0.956 | 0.996 | 0.998 | 0.246 | 1.001 | 0.439 | 0.735 | 0.087 | 1.008 |
| qlog records, JSON text sequence | 1467503 | 1490.1 ± 0.2% | 0.680 | 0.942 | 0.989 | 0.992 | 0.988 | 0.248 | 0.987 | 0.423 | 0.728 | 0.113 | 1.007 |

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
| CLDR supplemental, 34 texts | 920675 | 1421.9 ± 2.1% | 1308.0 ± 0.3% | 1194.9 ± 0.5% | 356.7 ± 1.3% | 664.0 ± 1.2% | 323.1 ± 3.4% | 1.087 | 1.190 | 3.986 | 2.141 | 4.401 |
| qlog records, JSON text sequence | 1467503 | 1097.5 ± 3.1% | 1031.3 ± 0.3% | 1049.2 ± 1.7% | 292.0 ± 0.9% | 715.8 ± 0.8% | 313.0 ± 1.2% | 1.064 | 1.046 | 3.759 | 1.533 | 3.507 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1759.1 ± 0.7% | 1594.2 ± 1.4% | 1164.1 ± 1.1% | 424.8 ± 0.7% | 448.5 ± 4.9% | 415.6 ± 0.4% | 1.103 | 1.511 | 4.141 | 3.922 | 4.233 |
| qlog records, JSON text sequence | 1467503 | 1490.1 ± 0.2% | 1315.9 ± 0.2% | 905.7 ± 0.4% | 426.3 ± 0.8% | 495.0 ± 0.2% | 331.5 ± 0.5% | 1.132 | 1.645 | 3.495 | 3.010 | 4.495 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1773.8 ± 7.2% | 1594.2 ± 1.4% | 1164.1 ± 1.1% | 424.8 ± 0.7% | 448.5 ± 4.9% | 415.6 ± 0.4% | 1.113 | 1.524 | 4.175 | 3.955 | 4.268 |
| qlog records, JSON text sequence | 1467503 | 1500.1 ± 0.3% | 1315.9 ± 0.2% | 905.7 ± 0.4% | 426.3 ± 0.8% | 495.0 ± 0.2% | 331.5 ± 0.5% | 1.140 | 1.656 | 3.518 | 3.030 | 4.525 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1057.0 ± 1.1% | 1308.0 ± 0.3% | 1194.9 ± 0.5% | 356.7 ± 1.3% | 664.0 ± 1.2% | 323.1 ± 3.4% | 0.808 | 0.885 | 2.963 | 1.592 | 3.272 |
| qlog records, JSON text sequence | 1467503 | 912.8 ± 0.9% | 1031.3 ± 0.3% | 1049.2 ± 1.7% | 292.0 ± 0.9% | 715.8 ± 0.8% | 313.0 ± 1.2% | 0.885 | 0.870 | 3.126 | 1.275 | 2.917 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1293.3 ± 0.8% | 1594.2 ± 1.4% | 1164.1 ± 1.1% | 424.8 ± 0.7% | 448.5 ± 4.9% | 415.6 ± 0.4% | 0.811 | 1.111 | 3.044 | 2.884 | 3.112 |
| qlog records, JSON text sequence | 1467503 | 1085.3 ± 0.5% | 1315.9 ± 0.2% | 905.7 ± 0.4% | 426.3 ± 0.8% | 495.0 ± 0.2% | 331.5 ± 0.5% | 0.825 | 1.198 | 2.546 | 2.193 | 3.274 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.808 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.885 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.885 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.870 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.811 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.825 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1349.4 ± 0.9% | 0.476 | 1.002 | 0.988 | 0.982 | 0.371 | 0.992 | 0.990 | 0.347 | 0.775 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1061.6 ± 3.6% | 0.798 | 1.050 | 1.044 | 1.027 | 0.376 | 1.024 | 1.028 | 0.345 | 0.697 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1740.6 ± 5.3% | 0.424 | 0.979 | 0.972 | 1.001 | 1.000 | 0.251 | 0.999 | 0.444 | 0.742 | 0.088 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1485.3 ± 0.3% | 0.681 | 0.956 | 0.989 | 0.996 | 0.990 | 0.253 | 0.992 | 0.421 | 0.728 | 0.114 | 1.013 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.050 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1349.4 ± 0.9% | 1350.0 ± 3.2% | 1217.5 ± 0.7% | 355.0 ± 3.4% | 661.4 ± 3.9% | 313.2 ± 3.0% | 1.000 | 1.108 | 3.801 | 2.040 | 4.309 |
| qlog records, JSON text sequence | 1467503 | 1061.6 ± 3.6% | 1043.1 ± 0.9% | 1084.2 ± 3.3% | 305.2 ± 3.1% | 729.8 ± 1.0% | 307.5 ± 1.5% | 1.018 | 0.979 | 3.478 | 1.455 | 3.452 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1740.6 ± 5.3% | 1590.3 ± 0.7% | 1173.3 ± 3.0% | 426.2 ± 30.1% | 454.4 ± 3.0% | 412.9 ± 0.6% | 1.094 | 1.483 | 4.084 | 3.831 | 4.215 |
| qlog records, JSON text sequence | 1467503 | 1485.3 ± 0.3% | 1316.3 ± 5.7% | 886.3 ± 0.2% | 423.2 ± 0.5% | 500.0 ± 0.6% | 326.0 ± 1.3% | 1.128 | 1.676 | 3.510 | 2.970 | 4.556 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1769.3 ± 2.0% | 1590.3 ± 0.7% | 1173.3 ± 3.0% | 426.2 ± 30.1% | 454.4 ± 3.0% | 412.9 ± 0.6% | 1.113 | 1.508 | 4.151 | 3.894 | 4.285 |
| qlog records, JSON text sequence | 1467503 | 1503.9 ± 0.9% | 1316.3 ± 5.7% | 886.3 ± 0.2% | 423.2 ± 0.5% | 500.0 ± 0.6% | 326.0 ± 1.3% | 1.143 | 1.697 | 3.554 | 3.008 | 4.613 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1046.5 ± 0.5% | 1350.0 ± 3.2% | 1217.5 ± 0.7% | 355.0 ± 3.4% | 661.4 ± 3.9% | 313.2 ± 3.0% | 0.775 | 0.860 | 2.947 | 1.582 | 3.342 |
| qlog records, JSON text sequence | 1467503 | 740.3 ± 0.5% | 1043.1 ± 0.9% | 1084.2 ± 3.3% | 305.2 ± 3.1% | 729.8 ± 1.0% | 307.5 ± 1.5% | 0.710 | 0.683 | 2.425 | 1.014 | 2.408 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1290.8 ± 4.3% | 1590.3 ± 0.7% | 1173.3 ± 3.0% | 426.2 ± 30.1% | 454.4 ± 3.0% | 412.9 ± 0.6% | 0.812 | 1.100 | 3.029 | 2.841 | 3.126 |
| qlog records, JSON text sequence | 1467503 | 1081.3 ± 3.0% | 1316.3 ± 5.7% | 886.3 ± 0.2% | 423.2 ± 0.5% | 500.0 ± 0.6% | 326.0 ± 1.3% | 0.821 | 1.220 | 2.555 | 2.163 | 3.317 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.775 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.860 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.710 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.683 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.812 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.821 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1424.0 ± 2.3% | 0.429 | 0.895 | 0.935 | 0.932 | 0.350 | 0.959 | 0.932 | 0.331 | 0.756 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1085.5 ± 2.6% | 0.744 | 0.987 | 0.956 | 0.956 | 0.364 | 0.981 | 0.958 | 0.339 | 0.812 | 0.118 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1763.0 ± 5.5% | 0.419 | 0.956 | 0.957 | 0.994 | 1.001 | 0.247 | 0.996 | 0.438 | 0.738 | 0.087 | 1.013 |
| qlog records, JSON text sequence | 1467503 | 1489.0 ± 0.2% | 0.681 | 0.944 | 0.988 | 0.993 | 0.988 | 0.249 | 0.989 | 0.423 | 0.728 | 0.113 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1424.0 ± 2.3% | 1305.1 ± 0.9% | 1190.3 ± 0.6% | 355.4 ± 1.4% | 666.3 ± 2.2% | 321.3 ± 1.8% | 1.091 | 1.196 | 4.007 | 2.137 | 4.433 |
| qlog records, JSON text sequence | 1467503 | 1085.5 ± 2.6% | 1022.0 ± 0.4% | 1063.7 ± 0.3% | 301.4 ± 2.8% | 727.9 ± 5.0% | 313.6 ± 5.1% | 1.062 | 1.020 | 3.602 | 1.491 | 3.461 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1763.0 ± 5.5% | 1596.5 ± 1.9% | 1158.5 ± 1.9% | 423.9 ± 0.2% | 458.9 ± 4.7% | 416.2 ± 5.1% | 1.104 | 1.522 | 4.159 | 3.842 | 4.236 |
| qlog records, JSON text sequence | 1467503 | 1489.0 ± 0.2% | 1311.9 ± 5.6% | 904.6 ± 1.0% | 426.8 ± 0.2% | 479.6 ± 0.1% | 331.2 ± 1.0% | 1.135 | 1.646 | 3.489 | 3.104 | 4.495 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1786.7 ± 6.1% | 1596.5 ± 1.9% | 1158.5 ± 1.9% | 423.9 ± 0.2% | 458.9 ± 4.7% | 416.2 ± 5.1% | 1.119 | 1.542 | 4.215 | 3.893 | 4.293 |
| qlog records, JSON text sequence | 1467503 | 1503.8 ± 0.2% | 1311.9 ± 5.6% | 904.6 ± 1.0% | 426.8 ± 0.2% | 479.6 ± 0.1% | 331.2 ± 1.0% | 1.146 | 1.662 | 3.523 | 3.135 | 4.540 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1077.2 ± 5.3% | 1305.1 ± 0.9% | 1190.3 ± 0.6% | 355.4 ± 1.4% | 666.3 ± 2.2% | 321.3 ± 1.8% | 0.825 | 0.905 | 3.031 | 1.617 | 3.353 |
| qlog records, JSON text sequence | 1467503 | 881.0 ± 4.6% | 1022.0 ± 0.4% | 1063.7 ± 0.3% | 301.4 ± 2.8% | 727.9 ± 5.0% | 313.6 ± 5.1% | 0.862 | 0.828 | 2.923 | 1.210 | 2.809 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1300.9 ± 1.2% | 1596.5 ± 1.9% | 1158.5 ± 1.9% | 423.9 ± 0.2% | 458.9 ± 4.7% | 416.2 ± 5.1% | 0.815 | 1.123 | 3.069 | 2.835 | 3.125 |
| qlog records, JSON text sequence | 1467503 | 1084.1 ± 0.4% | 1311.9 ± 5.6% | 904.6 ± 1.0% | 426.8 ± 0.2% | 479.6 ± 0.1% | 331.2 ± 1.0% | 0.826 | 1.198 | 2.540 | 2.260 | 3.273 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.825 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.905 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.862 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.828 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.815 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.826 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1422.3 ± 0.9% | 0.428 | 0.922 | 0.938 | 0.933 | 0.353 | 0.958 | 0.933 | 0.331 | 0.734 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1100.8 ± 3.6% | 0.734 | 0.975 | 0.943 | 0.944 | 0.356 | 0.971 | 0.943 | 0.334 | 0.817 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1757.1 ± 1.2% | 0.420 | 0.959 | 0.964 | 0.995 | 0.991 | 0.248 | 0.997 | 0.439 | 0.739 | 0.087 | 1.015 |
| qlog records, JSON text sequence | 1467503 | 1487.3 ± 2.1% | 0.682 | 0.945 | 0.990 | 0.993 | 0.988 | 0.249 | 0.990 | 0.422 | 0.728 | 0.114 | 1.009 |

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
| CLDR supplemental, 34 texts | 920675 | 1422.3 ± 0.9% | 1309.0 ± 1.3% | 1190.9 ± 0.7% | 357.7 ± 3.9% | 665.8 ± 0.9% | 320.7 ± 3.1% | 1.087 | 1.194 | 3.976 | 2.136 | 4.434 |
| qlog records, JSON text sequence | 1467503 | 1100.8 ± 3.6% | 1025.0 ± 1.0% | 1071.4 ± 3.2% | 301.4 ± 1.8% | 727.1 ± 0.8% | 319.0 ± 4.6% | 1.074 | 1.027 | 3.653 | 1.514 | 3.451 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1757.1 ± 1.2% | 1597.7 ± 0.8% | 1159.9 ± 4.1% | 424.2 ± 0.4% | 456.7 ± 2.2% | 413.9 ± 0.9% | 1.100 | 1.515 | 4.143 | 3.848 | 4.245 |
| qlog records, JSON text sequence | 1467503 | 1487.3 ± 2.1% | 1314.0 ± 0.2% | 905.9 ± 0.2% | 424.8 ± 0.6% | 500.4 ± 3.5% | 330.8 ± 2.6% | 1.132 | 1.642 | 3.502 | 2.972 | 4.496 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1783.2 ± 6.7% | 1597.7 ± 0.8% | 1159.9 ± 4.1% | 424.2 ± 0.4% | 456.7 ± 2.2% | 413.9 ± 0.9% | 1.116 | 1.537 | 4.204 | 3.905 | 4.308 |
| qlog records, JSON text sequence | 1467503 | 1501.1 ± 1.7% | 1314.0 ± 0.2% | 905.9 ± 0.2% | 424.8 ± 0.6% | 500.4 ± 3.5% | 330.8 ± 2.6% | 1.142 | 1.657 | 3.534 | 3.000 | 4.538 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1043.4 ± 1.9% | 1309.0 ± 1.3% | 1190.9 ± 0.7% | 357.7 ± 3.9% | 665.8 ± 0.9% | 320.7 ± 3.1% | 0.797 | 0.876 | 2.917 | 1.567 | 3.253 |
| qlog records, JSON text sequence | 1467503 | 899.2 ± 2.6% | 1025.0 ± 1.0% | 1071.4 ± 3.2% | 301.4 ± 1.8% | 727.1 ± 0.8% | 319.0 ± 4.6% | 0.877 | 0.839 | 2.984 | 1.237 | 2.819 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1297.7 ± 1.2% | 1597.7 ± 0.8% | 1159.9 ± 4.1% | 424.2 ± 0.4% | 456.7 ± 2.2% | 413.9 ± 0.9% | 0.812 | 1.119 | 3.059 | 2.842 | 3.135 |
| qlog records, JSON text sequence | 1467503 | 1083.2 ± 4.6% | 1314.0 ± 0.2% | 905.9 ± 0.2% | 424.8 ± 0.6% | 500.4 ± 3.5% | 330.8 ± 2.6% | 0.824 | 1.196 | 2.550 | 2.165 | 3.275 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.797 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.876 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.877 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.839 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.812 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.824 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1418.9 ± 2.5% | 0.429 | 0.919 | 0.935 | 0.933 | 0.354 | 0.962 | 0.933 | 0.332 | 0.728 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1096.6 ± 3.3% | 0.715 | 0.968 | 0.937 | 0.933 | 0.359 | 0.965 | 0.938 | 0.328 | 0.821 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1754.0 ± 0.9% | 0.423 | 0.960 | 0.959 | 0.994 | 1.000 | 0.246 | 0.998 | 0.440 | 0.738 | 0.087 | 1.012 |
| qlog records, JSON text sequence | 1467503 | 1489.4 ± 0.7% | 0.682 | 0.945 | 0.992 | 0.995 | 0.988 | 0.249 | 0.988 | 0.421 | 0.730 | 0.113 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1418.9 ± 2.5% | 1228.8 ± 0.9% | 1212.5 ± 1.5% | 345.6 ± 2.3% | 668.4 ± 1.7% | 322.2 ± 3.2% | 1.155 | 1.170 | 4.105 | 2.123 | 4.404 |
| qlog records, JSON text sequence | 1467503 | 1096.6 ± 3.3% | 953.0 ± 0.6% | 1074.6 ± 2.1% | 302.5 ± 2.5% | 728.4 ± 1.0% | 311.3 ± 3.9% | 1.151 | 1.020 | 3.625 | 1.505 | 3.522 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1754.0 ± 0.9% | 1606.7 ± 0.8% | 1174.1 ± 6.2% | 424.4 ± 3.8% | 454.8 ± 11.6% | 413.9 ± 21.1% | 1.092 | 1.494 | 4.133 | 3.857 | 4.237 |
| qlog records, JSON text sequence | 1467503 | 1489.4 ± 0.7% | 1315.4 ± 0.5% | 906.2 ± 0.2% | 424.3 ± 2.1% | 499.6 ± 0.3% | 332.1 ± 0.8% | 1.132 | 1.644 | 3.510 | 2.981 | 4.485 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1775.5 ± 0.8% | 1606.7 ± 0.8% | 1174.1 ± 6.2% | 424.4 ± 3.8% | 454.8 ± 11.6% | 413.9 ± 21.1% | 1.105 | 1.512 | 4.184 | 3.904 | 4.289 |
| qlog records, JSON text sequence | 1467503 | 1505.1 ± 0.7% | 1315.4 ± 0.5% | 906.2 ± 0.2% | 424.3 ± 2.1% | 499.6 ± 0.3% | 332.1 ± 0.8% | 1.144 | 1.661 | 3.547 | 3.013 | 4.532 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1033.2 ± 1.3% | 1228.8 ± 0.9% | 1212.5 ± 1.5% | 345.6 ± 2.3% | 668.4 ± 1.7% | 322.2 ± 3.2% | 0.841 | 0.852 | 2.989 | 1.546 | 3.207 |
| qlog records, JSON text sequence | 1467503 | 900.3 ± 4.3% | 953.0 ± 0.6% | 1074.6 ± 2.1% | 302.5 ± 2.5% | 728.4 ± 1.0% | 311.3 ± 3.9% | 0.945 | 0.838 | 2.976 | 1.236 | 2.892 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1294.0 ± 1.8% | 1606.7 ± 0.8% | 1174.1 ± 6.2% | 424.4 ± 3.8% | 454.8 ± 11.6% | 413.9 ± 21.1% | 0.805 | 1.102 | 3.049 | 2.845 | 3.126 |
| qlog records, JSON text sequence | 1467503 | 1087.2 ± 1.1% | 1315.4 ± 0.5% | 906.2 ± 0.2% | 424.3 ± 2.1% | 499.6 ± 0.3% | 332.1 ± 0.8% | 0.827 | 1.200 | 2.562 | 2.176 | 3.274 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.841 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.852 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.945 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.838 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.805 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.827 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V74 80-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1423.1 ± 0.6% | 0.430 | 0.901 | 0.937 | 0.935 | 0.354 | 0.961 | 0.933 | 0.331 | 0.746 | 0.093 |
| qlog records, JSON text sequence | 1467503 | 1100.6 ± 1.6% | 0.733 | 0.973 | 0.957 | 0.936 | 0.360 | 0.971 | 0.939 | 0.335 | 0.838 | 0.117 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1749.3 ± 2.4% | 0.422 | 0.955 | 0.962 | 0.994 | 0.997 | 0.249 | 1.003 | 0.441 | 0.737 | 0.088 | 1.015 |
| qlog records, JSON text sequence | 1467503 | 1485.6 ± 2.3% | 0.683 | 0.947 | 0.993 | 0.995 | 0.991 | 0.250 | 0.992 | 0.422 | 0.730 | 0.114 | 1.011 |

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
| CLDR supplemental, 34 texts | 920675 | 1423.1 ± 0.6% | 1333.6 ± 0.7% | 1211.6 ± 0.7% | 356.8 ± 1.4% | 671.1 ± 1.6% | 321.4 ± 2.5% | 1.067 | 1.175 | 3.989 | 2.121 | 4.428 |
| qlog records, JSON text sequence | 1467503 | 1100.6 ± 1.6% | 1053.6 ± 0.5% | 1085.5 ± 0.4% | 300.9 ± 4.6% | 722.9 ± 0.9% | 303.9 ± 4.5% | 1.045 | 1.014 | 3.658 | 1.522 | 3.622 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1749.3 ± 2.4% | 1591.0 ± 1.4% | 1170.2 ± 1.8% | 423.5 ± 0.6% | 454.5 ± 2.1% | 416.2 ± 0.5% | 1.100 | 1.495 | 4.130 | 3.849 | 4.204 |
| qlog records, JSON text sequence | 1467503 | 1485.6 ± 2.3% | 1319.6 ± 0.2% | 905.1 ± 0.7% | 427.7 ± 0.3% | 496.8 ± 0.5% | 330.3 ± 0.9% | 1.126 | 1.641 | 3.474 | 2.991 | 4.498 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1775.0 ± 1.2% | 1591.0 ± 1.4% | 1170.2 ± 1.8% | 423.5 ± 0.6% | 454.5 ± 2.1% | 416.2 ± 0.5% | 1.116 | 1.517 | 4.191 | 3.905 | 4.265 |
| qlog records, JSON text sequence | 1467503 | 1501.2 ± 0.4% | 1319.6 ± 0.2% | 905.1 ± 0.7% | 427.7 ± 0.3% | 496.8 ± 0.5% | 330.3 ± 0.9% | 1.138 | 1.659 | 3.510 | 3.022 | 4.545 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1061.3 ± 0.8% | 1333.6 ± 0.7% | 1211.6 ± 0.7% | 356.8 ± 1.4% | 671.1 ± 1.6% | 321.4 ± 2.5% | 0.796 | 0.876 | 2.975 | 1.581 | 3.302 |
| qlog records, JSON text sequence | 1467503 | 922.2 ± 0.7% | 1053.6 ± 0.5% | 1085.5 ± 0.4% | 300.9 ± 4.6% | 722.9 ± 0.9% | 303.9 ± 4.5% | 0.875 | 0.850 | 3.065 | 1.276 | 3.035 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1289.9 ± 0.6% | 1591.0 ± 1.4% | 1170.2 ± 1.8% | 423.5 ± 0.6% | 454.5 ± 2.1% | 416.2 ± 0.5% | 0.811 | 1.102 | 3.046 | 2.838 | 3.100 |
| qlog records, JSON text sequence | 1467503 | 1084.9 ± 0.3% | 1319.6 ± 0.2% | 905.1 ± 0.7% | 427.7 ± 0.3% | 496.8 ± 0.5% | 330.3 ± 0.9% | 0.822 | 1.199 | 2.537 | 2.184 | 3.285 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.796 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.876 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.875 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.850 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.811 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.822 of simdjson.
