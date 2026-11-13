# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1582.8 ± 6.6% | 0.534 | 0.982 | 1.025 | 1.020 | 0.403 | 1.032 | 1.006 | 0.392 | 0.844 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 1288.1 ± 6.5% | 0.899 | 1.016 | 1.044 | 1.033 | 0.389 | 1.026 | 1.018 | 0.373 | 0.716 | 0.106 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2302.7 ± 3.3% | 0.437 | 0.896 | 0.949 | 0.967 | 0.979 | 0.265 | 0.977 | 0.462 | 0.738 | 0.086 | 0.988 |
| qlog records, JSON text sequence | 1467503 | 2012.2 ± 5.1% | 0.710 | 0.917 | 0.983 | 0.975 | 0.967 | 0.258 | 0.981 | 0.426 | 0.718 | 0.105 | 0.991 |

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
| CLDR supplemental, 34 texts | 920675 | 1582.8 ± 6.6% | 2037.2 ± 3.4% | 1638.7 ± 2.5% | 509.6 ± 8.2% | 801.0 ± 5.1% | 464.4 ± 4.7% | 0.777 | 0.966 | 3.106 | 1.976 | 3.408 |
| qlog records, JSON text sequence | 1467503 | 1288.1 ± 6.5% | 1552.9 ± 4.9% | 1580.2 ± 3.8% | 445.0 ± 4.0% | 925.3 ± 3.1% | 466.1 ± 6.7% | 0.830 | 0.815 | 2.894 | 1.392 | 2.764 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2302.7 ± 3.3% | 2261.1 ± 7.6% | 1454.6 ± 11.2% | 590.4 ± 5.1% | 613.1 ± 78.0% | 577.2 ± 18.0% | 1.018 | 1.583 | 3.900 | 3.756 | 3.989 |
| qlog records, JSON text sequence | 1467503 | 2012.2 ± 5.1% | 1836.2 ± 7.2% | 1165.0 ± 6.3% | 558.9 ± 3.2% | 683.0 ± 3.0% | 478.6 ± 3.9% | 1.096 | 1.727 | 3.600 | 2.946 | 4.205 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2276.1 ± 4.1% | 2261.1 ± 7.6% | 1454.6 ± 11.2% | 590.4 ± 5.1% | 613.1 ± 78.0% | 577.2 ± 18.0% | 1.007 | 1.565 | 3.855 | 3.713 | 3.943 |
| qlog records, JSON text sequence | 1467503 | 1993.8 ± 5.4% | 1836.2 ± 7.2% | 1165.0 ± 6.3% | 558.9 ± 3.2% | 683.0 ± 3.0% | 478.6 ± 3.9% | 1.086 | 1.711 | 3.568 | 2.919 | 4.166 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.5 ± 16.9% | 2037.2 ± 3.4% | 1638.7 ± 2.5% | 509.6 ± 8.2% | 801.0 ± 5.1% | 464.4 ± 4.7% | 0.656 | 0.815 | 2.621 | 1.667 | 2.876 |
| qlog records, JSON text sequence | 1467503 | 922.5 ± 5.3% | 1552.9 ± 4.9% | 1580.2 ± 3.8% | 445.0 ± 4.0% | 925.3 ± 3.1% | 466.1 ± 6.7% | 0.594 | 0.584 | 2.073 | 0.997 | 1.979 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1698.4 ± 3.6% | 2261.1 ± 7.6% | 1454.6 ± 11.2% | 590.4 ± 5.1% | 613.1 ± 78.0% | 577.2 ± 18.0% | 0.751 | 1.168 | 2.877 | 2.770 | 2.942 |
| qlog records, JSON text sequence | 1467503 | 1443.8 ± 4.9% | 1836.2 ± 7.2% | 1165.0 ± 6.3% | 558.9 ± 3.2% | 683.0 ± 3.0% | 478.6 ± 3.9% | 0.786 | 1.239 | 2.583 | 2.114 | 3.017 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.777 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.830 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.815 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.656 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.815 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.594 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.584 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.751 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.786 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1580.5 ± 4.7% | 0.518 | 0.982 | 1.013 | 0.999 | 0.393 | 1.007 | 1.014 | 0.388 | 0.857 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 1262.3 ± 44.6% | 0.877 | 1.045 | 0.980 | 0.980 | 0.383 | 0.985 | 1.003 | 0.361 | 0.856 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2279.0 ± 2.3% | 0.450 | 0.947 | 0.972 | 1.008 | 1.018 | 0.273 | 1.014 | 0.468 | 0.734 | 0.087 | 0.976 |
| qlog records, JSON text sequence | 1467503 | 1969.1 ± 73.2% | 0.736 | 0.924 | 1.021 | 1.023 | 1.019 | 0.269 | 0.997 | 0.438 | 0.743 | 0.107 | 1.015 |

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
| CLDR supplemental, 34 texts | 920675 | 1580.5 ± 4.7% | 2025.7 ± 3.3% | 1603.4 ± 5.8% | 518.2 ± 6.8% | 717.2 ± 4.3% | 453.2 ± 2.5% | 0.780 | 0.986 | 3.050 | 2.204 | 3.487 |
| qlog records, JSON text sequence | 1467503 | 1262.3 ± 44.6% | 1560.2 ± 10.5% | 1489.2 ± 4.7% | 415.1 ± 23.1% | 881.3 ± 3.5% | 450.2 ± 6.7% | 0.809 | 0.848 | 3.041 | 1.432 | 2.804 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2279.0 ± 2.3% | 2216.1 ± 4.1% | 1433.0 ± 4.3% | 596.7 ± 2.1% | 539.2 ± 3.4% | 575.9 ± 7.9% | 1.028 | 1.590 | 3.819 | 4.226 | 3.957 |
| qlog records, JSON text sequence | 1467503 | 1969.1 ± 73.2% | 1884.7 ± 3.2% | 1203.7 ± 4.0% | 581.1 ± 8.1% | 672.4 ± 5.1% | 468.4 ± 2.8% | 1.045 | 1.636 | 3.389 | 2.928 | 4.203 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2225.3 ± 3.8% | 2216.1 ± 4.1% | 1433.0 ± 4.3% | 596.7 ± 2.1% | 539.2 ± 3.4% | 575.9 ± 7.9% | 1.004 | 1.553 | 3.729 | 4.127 | 3.864 |
| qlog records, JSON text sequence | 1467503 | 1998.0 ± 3.5% | 1884.7 ± 3.2% | 1203.7 ± 4.0% | 581.1 ± 8.1% | 672.4 ± 5.1% | 468.4 ± 2.8% | 1.060 | 1.660 | 3.439 | 2.972 | 4.265 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1354.9 ± 3.4% | 2025.7 ± 3.3% | 1603.4 ± 5.8% | 518.2 ± 6.8% | 717.2 ± 4.3% | 453.2 ± 2.5% | 0.669 | 0.845 | 2.614 | 1.889 | 2.989 |
| qlog records, JSON text sequence | 1467503 | 1081.0 ± 6.4% | 1560.2 ± 10.5% | 1489.2 ± 4.7% | 415.1 ± 23.1% | 881.3 ± 3.5% | 450.2 ± 6.7% | 0.693 | 0.726 | 2.604 | 1.227 | 2.401 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1672.7 ± 5.4% | 2216.1 ± 4.1% | 1433.0 ± 4.3% | 596.7 ± 2.1% | 539.2 ± 3.4% | 575.9 ± 7.9% | 0.755 | 1.167 | 2.803 | 3.102 | 2.905 |
| qlog records, JSON text sequence | 1467503 | 1462.4 ± 3.9% | 1884.7 ± 3.2% | 1203.7 ± 4.0% | 581.1 ± 8.1% | 672.4 ± 5.1% | 468.4 ± 2.8% | 0.776 | 1.215 | 2.517 | 2.175 | 3.122 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.780 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.669 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.845 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.693 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.726 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.755 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.776 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1574.5 ± 18.5% | 0.529 | 0.988 | 1.020 | 1.017 | 0.401 | 1.021 | 1.025 | 0.395 | 0.813 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1286.5 ± 5.4% | 0.883 | 1.039 | 1.002 | 0.984 | 0.383 | 0.984 | 0.987 | 0.321 | 0.850 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2266.8 ± 0.9% | 0.448 | 0.951 | 0.971 | 1.002 | 1.010 | 0.268 | 0.999 | 0.465 | 0.731 | 0.081 | 0.987 |
| qlog records, JSON text sequence | 1467503 | 1994.7 ± 2.0% | 0.708 | 0.908 | 0.981 | 0.995 | 0.985 | 0.261 | 0.977 | 0.424 | 0.710 | 0.100 | 0.985 |

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
| CLDR supplemental, 34 texts | 920675 | 1574.5 ± 18.5% | 2018.1 ± 3.7% | 1604.5 ± 5.9% | 512.9 ± 4.5% | 725.3 ± 3.5% | 454.2 ± 6.6% | 0.780 | 0.981 | 3.070 | 2.171 | 3.466 |
| qlog records, JSON text sequence | 1467503 | 1286.5 ± 5.4% | 1558.8 ± 3.8% | 1553.7 ± 4.4% | 434.4 ± 9.5% | 895.4 ± 8.7% | 454.5 ± 5.5% | 0.825 | 0.828 | 2.961 | 1.437 | 2.830 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2266.8 ± 0.9% | 2222.2 ± 1.6% | 1446.3 ± 1.1% | 586.8 ± 2.4% | 533.5 ± 1.1% | 568.1 ± 3.6% | 1.020 | 1.567 | 3.863 | 4.249 | 3.990 |
| qlog records, JSON text sequence | 1467503 | 1994.7 ± 2.0% | 1836.0 ± 2.7% | 1180.7 ± 3.6% | 565.8 ± 3.1% | 682.1 ± 3.1% | 465.2 ± 25.4% | 1.086 | 1.689 | 3.525 | 2.924 | 4.288 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2236.9 ± 5.0% | 2222.2 ± 1.6% | 1446.3 ± 1.1% | 586.8 ± 2.4% | 533.5 ± 1.1% | 568.1 ± 3.6% | 1.007 | 1.547 | 3.812 | 4.193 | 3.937 |
| qlog records, JSON text sequence | 1467503 | 1965.4 ± 1.4% | 1836.0 ± 2.7% | 1180.7 ± 3.6% | 565.8 ± 3.1% | 682.1 ± 3.1% | 465.2 ± 25.4% | 1.070 | 1.665 | 3.474 | 2.881 | 4.225 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1280.0 ± 2.1% | 2018.1 ± 3.7% | 1604.5 ± 5.9% | 512.9 ± 4.5% | 725.3 ± 3.5% | 454.2 ± 6.6% | 0.634 | 0.798 | 2.496 | 1.765 | 2.818 |
| qlog records, JSON text sequence | 1467503 | 1093.4 ± 31.3% | 1558.8 ± 3.8% | 1553.7 ± 4.4% | 434.4 ± 9.5% | 895.4 ± 8.7% | 454.5 ± 5.5% | 0.701 | 0.704 | 2.517 | 1.221 | 2.406 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1656.0 ± 3.4% | 2222.2 ± 1.6% | 1446.3 ± 1.1% | 586.8 ± 2.4% | 533.5 ± 1.1% | 568.1 ± 3.6% | 0.745 | 1.145 | 2.822 | 3.104 | 2.915 |
| qlog records, JSON text sequence | 1467503 | 1415.8 ± 68.0% | 1836.0 ± 2.7% | 1180.7 ± 3.6% | 565.8 ± 3.1% | 682.1 ± 3.1% | 465.2 ± 25.4% | 0.771 | 1.199 | 2.502 | 2.076 | 3.044 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.780 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.825 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.828 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.634 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.798 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.745 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1584.1 ± 3.8% | 0.522 | 0.960 | 0.997 | 1.001 | 0.389 | 1.004 | 1.003 | 0.386 | 0.769 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 1292.4 ± 4.3% | 0.865 | 1.004 | 0.978 | 0.972 | 0.368 | 0.974 | 0.967 | 0.329 | 0.794 | 0.107 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2285.6 ± 2.7% | 0.445 | 0.941 | 0.969 | 0.994 | 1.006 | 0.268 | 0.996 | 0.465 | 0.735 | 0.086 | 0.996 |
| qlog records, JSON text sequence | 1467503 | 1996.7 ± 3.4% | 0.723 | 0.919 | 0.999 | 1.003 | 0.999 | 0.263 | 0.994 | 0.435 | 0.727 | 0.107 | 1.005 |

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
| CLDR supplemental, 34 texts | 920675 | 1584.1 ± 3.8% | 2014.1 ± 8.0% | 1602.2 ± 2.5% | 519.0 ± 2.1% | 728.1 ± 2.8% | 449.3 ± 3.0% | 0.787 | 0.989 | 3.052 | 2.176 | 3.526 |
| qlog records, JSON text sequence | 1467503 | 1292.4 ± 4.3% | 1528.1 ± 72.8% | 1443.0 ± 8.7% | 417.5 ± 29.6% | 870.1 ± 118.8% | 451.0 ± 1.1% | 0.846 | 0.896 | 3.096 | 1.485 | 2.866 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2285.6 ± 2.7% | 2255.1 ± 3.3% | 1441.9 ± 4.0% | 597.1 ± 13.5% | 537.9 ± 1.0% | 577.4 ± 4.1% | 1.014 | 1.585 | 3.828 | 4.249 | 3.958 |
| qlog records, JSON text sequence | 1467503 | 1996.7 ± 3.4% | 1890.5 ± 2.4% | 1206.9 ± 3.9% | 575.8 ± 3.9% | 690.9 ± 14.5% | 483.9 ± 68.1% | 1.056 | 1.654 | 3.468 | 2.890 | 4.126 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2276.2 ± 4.2% | 2255.1 ± 3.3% | 1441.9 ± 4.0% | 597.1 ± 13.5% | 537.9 ± 1.0% | 577.4 ± 4.1% | 1.009 | 1.579 | 3.812 | 4.232 | 3.942 |
| qlog records, JSON text sequence | 1467503 | 2006.5 ± 2.9% | 1890.5 ± 2.4% | 1206.9 ± 3.9% | 575.8 ± 3.9% | 690.9 ± 14.5% | 483.9 ± 68.1% | 1.061 | 1.663 | 3.485 | 2.904 | 4.147 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1218.7 ± 2.4% | 2014.1 ± 8.0% | 1602.2 ± 2.5% | 519.0 ± 2.1% | 728.1 ± 2.8% | 449.3 ± 3.0% | 0.605 | 0.761 | 2.348 | 1.674 | 2.712 |
| qlog records, JSON text sequence | 1467503 | 1026.3 ± 20.7% | 1528.1 ± 72.8% | 1443.0 ± 8.7% | 417.5 ± 29.6% | 870.1 ± 118.8% | 451.0 ± 1.1% | 0.672 | 0.711 | 2.458 | 1.180 | 2.276 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1678.9 ± 1.7% | 2255.1 ± 3.3% | 1441.9 ± 4.0% | 597.1 ± 13.5% | 537.9 ± 1.0% | 577.4 ± 4.1% | 0.744 | 1.164 | 2.812 | 3.121 | 2.908 |
| qlog records, JSON text sequence | 1467503 | 1451.8 ± 5.0% | 1890.5 ± 2.4% | 1206.9 ± 3.9% | 575.8 ± 3.9% | 690.9 ± 14.5% | 483.9 ± 68.1% | 0.768 | 1.203 | 2.521 | 2.101 | 3.000 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.787 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.896 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.605 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.761 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.711 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.744 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.768 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1593.5 ± 2.2% | 0.529 | 0.981 | 1.022 | 1.016 | 0.397 | 1.013 | 1.011 | 0.392 | 0.773 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1281.6 ± 4.6% | 0.865 | 1.014 | 0.982 | 0.971 | 0.343 | 0.987 | 0.971 | 0.292 | 0.809 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2269.5 ± 3.1% | 0.449 | 0.958 | 0.970 | 0.996 | 1.007 | 0.271 | 1.012 | 0.471 | 0.740 | 0.088 | 0.999 |
| qlog records, JSON text sequence | 1467503 | 2009.0 ± 2.1% | 0.716 | 0.913 | 0.990 | 0.994 | 0.985 | 0.262 | 0.981 | 0.424 | 0.720 | 0.106 | 0.990 |

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
| CLDR supplemental, 34 texts | 920675 | 1593.5 ± 2.2% | 2010.1 ± 2.2% | 1611.6 ± 4.4% | 522.9 ± 2.9% | 732.0 ± 1.2% | 461.4 ± 4.5% | 0.793 | 0.989 | 3.047 | 2.177 | 3.454 |
| qlog records, JSON text sequence | 1467503 | 1281.6 ± 4.6% | 1516.7 ± 3.1% | 1500.1 ± 4.1% | 397.7 ± 15.2% | 838.2 ± 12.8% | 453.7 ± 5.8% | 0.845 | 0.854 | 3.223 | 1.529 | 2.824 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2269.5 ± 3.1% | 2237.1 ± 3.1% | 1452.8 ± 4.3% | 596.2 ± 3.6% | 538.0 ± 4.2% | 578.1 ± 9.6% | 1.014 | 1.562 | 3.807 | 4.218 | 3.926 |
| qlog records, JSON text sequence | 1467503 | 2009.0 ± 2.1% | 1864.8 ± 2.2% | 1188.0 ± 1.7% | 582.6 ± 1.7% | 690.3 ± 5.2% | 473.4 ± 28.9% | 1.077 | 1.691 | 3.448 | 2.910 | 4.244 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2268.2 ± 3.5% | 2237.1 ± 3.1% | 1452.8 ± 4.3% | 596.2 ± 3.6% | 538.0 ± 4.2% | 578.1 ± 9.6% | 1.014 | 1.561 | 3.805 | 4.216 | 3.923 |
| qlog records, JSON text sequence | 1467503 | 1989.8 ± 45.0% | 1864.8 ± 2.2% | 1188.0 ± 1.7% | 582.6 ± 1.7% | 690.3 ± 5.2% | 473.4 ± 28.9% | 1.067 | 1.675 | 3.416 | 2.883 | 4.203 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1231.3 ± 42.8% | 2010.1 ± 2.2% | 1611.6 ± 4.4% | 522.9 ± 2.9% | 732.0 ± 1.2% | 461.4 ± 4.5% | 0.613 | 0.764 | 2.355 | 1.682 | 2.669 |
| qlog records, JSON text sequence | 1467503 | 1037.2 ± 5.2% | 1516.7 ± 3.1% | 1500.1 ± 4.1% | 397.7 ± 15.2% | 838.2 ± 12.8% | 453.7 ± 5.8% | 0.684 | 0.691 | 2.608 | 1.237 | 2.286 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1679.3 ± 4.0% | 2237.1 ± 3.1% | 1452.8 ± 4.3% | 596.2 ± 3.6% | 538.0 ± 4.2% | 578.1 ± 9.6% | 0.751 | 1.156 | 2.817 | 3.122 | 2.905 |
| qlog records, JSON text sequence | 1467503 | 1445.9 ± 2.8% | 1864.8 ± 2.2% | 1188.0 ± 1.7% | 582.6 ± 1.7% | 690.3 ± 5.2% | 473.4 ± 28.9% | 0.775 | 1.217 | 2.482 | 2.095 | 3.054 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.793 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.845 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.854 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.684 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.691 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.751 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.775 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1574.3 ± 4.7% | 0.544 | 0.987 | 1.021 | 1.003 | 0.404 | 1.028 | 1.012 | 0.392 | 0.842 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1256.3 ± 5.6% | 0.929 | 1.031 | 1.042 | 1.032 | 0.389 | 1.040 | 1.033 | 0.330 | 0.720 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2282.3 ± 2.5% | 0.444 | 0.937 | 0.976 | 1.000 | 1.010 | 0.266 | 1.008 | 0.466 | 0.739 | 0.087 | 0.996 |
| qlog records, JSON text sequence | 1467503 | 2008.8 ± 3.5% | 0.710 | 0.908 | 0.978 | 0.984 | 0.981 | 0.259 | 0.983 | 0.424 | 0.714 | 0.106 | 0.995 |

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
| CLDR supplemental, 34 texts | 920675 | 1574.3 ± 4.7% | 2019.2 ± 2.4% | 1609.5 ± 1.8% | 517.8 ± 8.3% | 798.4 ± 48.9% | 448.4 ± 20.3% | 0.780 | 0.978 | 3.041 | 1.972 | 3.511 |
| qlog records, JSON text sequence | 1467503 | 1256.3 ± 5.6% | 1544.5 ± 2.1% | 1522.3 ± 5.2% | 429.3 ± 7.3% | 893.3 ± 9.1% | 449.0 ± 66.1% | 0.813 | 0.825 | 2.926 | 1.406 | 2.798 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2282.3 ± 2.5% | 2235.3 ± 4.7% | 1446.4 ± 4.0% | 597.0 ± 3.4% | 624.5 ± 9.6% | 570.8 ± 2.8% | 1.021 | 1.578 | 3.823 | 3.655 | 3.998 |
| qlog records, JSON text sequence | 1467503 | 2008.8 ± 3.5% | 1864.9 ± 8.1% | 1184.9 ± 53.0% | 573.1 ± 15.7% | 689.0 ± 2.7% | 479.5 ± 2.5% | 1.077 | 1.695 | 3.505 | 2.916 | 4.189 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2272.9 ± 2.9% | 2235.3 ± 4.7% | 1446.4 ± 4.0% | 597.0 ± 3.4% | 624.5 ± 9.6% | 570.8 ± 2.8% | 1.017 | 1.571 | 3.807 | 3.640 | 3.982 |
| qlog records, JSON text sequence | 1467503 | 1999.1 ± 2.4% | 1864.9 ± 8.1% | 1184.9 ± 53.0% | 573.1 ± 15.7% | 689.0 ± 2.7% | 479.5 ± 2.5% | 1.072 | 1.687 | 3.488 | 2.901 | 4.169 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1325.2 ± 2.3% | 2019.2 ± 2.4% | 1609.5 ± 1.8% | 517.8 ± 8.3% | 798.4 ± 48.9% | 448.4 ± 20.3% | 0.656 | 0.823 | 2.559 | 1.660 | 2.955 |
| qlog records, JSON text sequence | 1467503 | 904.5 ± 5.4% | 1544.5 ± 2.1% | 1522.3 ± 5.2% | 429.3 ± 7.3% | 893.3 ± 9.1% | 449.0 ± 66.1% | 0.586 | 0.594 | 2.107 | 1.013 | 2.014 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1687.7 ± 4.4% | 2235.3 ± 4.7% | 1446.4 ± 4.0% | 597.0 ± 3.4% | 624.5 ± 9.6% | 570.8 ± 2.8% | 0.755 | 1.167 | 2.827 | 2.703 | 2.957 |
| qlog records, JSON text sequence | 1467503 | 1435.3 ± 3.4% | 1864.9 ± 8.1% | 1184.9 ± 53.0% | 573.1 ± 15.7% | 689.0 ± 2.7% | 479.5 ± 2.5% | 0.770 | 1.211 | 2.504 | 2.083 | 2.993 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.780 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.813 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.825 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.656 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.823 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.586 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.594 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.755 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.770 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1569.0 ± 2.7% | 0.528 | 0.987 | 1.019 | 1.019 | 0.394 | 1.017 | 1.018 | 0.393 | 0.854 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1245.9 ± 43.4% | 0.893 | 1.044 | 1.010 | 1.011 | 0.386 | 1.007 | 1.004 | 0.369 | 0.874 | 0.113 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2266.1 ± 1.3% | 0.443 | 0.943 | 0.961 | 0.993 | 1.005 | 0.268 | 0.996 | 0.462 | 0.730 | 0.086 | 0.986 |
| qlog records, JSON text sequence | 1467503 | 1944.8 ± 2.7% | 0.722 | 0.925 | 0.999 | 1.011 | 1.006 | 0.264 | 0.999 | 0.427 | 0.723 | 0.106 | 1.018 |

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
| CLDR supplemental, 34 texts | 920675 | 1569.0 ± 2.7% | 2021.4 ± 0.9% | 1618.8 ± 4.1% | 510.1 ± 4.0% | 718.4 ± 2.5% | 453.4 ± 2.9% | 0.776 | 0.969 | 3.076 | 2.184 | 3.460 |
| qlog records, JSON text sequence | 1467503 | 1245.9 ± 43.4% | 1518.4 ± 3.0% | 1541.7 ± 4.1% | 425.4 ± 4.2% | 873.8 ± 4.8% | 453.2 ± 9.8% | 0.821 | 0.808 | 2.929 | 1.426 | 2.749 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2266.1 ± 1.3% | 2226.2 ± 1.5% | 1435.6 ± 3.0% | 583.5 ± 2.6% | 530.5 ± 1.1% | 566.9 ± 7.0% | 1.018 | 1.579 | 3.884 | 4.271 | 3.997 |
| qlog records, JSON text sequence | 1467503 | 1944.8 ± 2.7% | 1831.0 ± 3.6% | 1174.0 ± 12.1% | 579.7 ± 72.8% | 674.3 ± 10.2% | 455.1 ± 3.0% | 1.062 | 1.657 | 3.355 | 2.884 | 4.273 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2235.1 ± 2.4% | 2226.2 ± 1.5% | 1435.6 ± 3.0% | 583.5 ± 2.6% | 530.5 ± 1.1% | 566.9 ± 7.0% | 1.004 | 1.557 | 3.831 | 4.213 | 3.943 |
| qlog records, JSON text sequence | 1467503 | 1980.0 ± 3.8% | 1831.0 ± 3.6% | 1174.0 ± 12.1% | 579.7 ± 72.8% | 674.3 ± 10.2% | 455.1 ± 3.0% | 1.081 | 1.687 | 3.416 | 2.937 | 4.351 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.4 ± 3.6% | 2021.4 ± 0.9% | 1618.8 ± 4.1% | 510.1 ± 4.0% | 718.4 ± 2.5% | 453.4 ± 2.9% | 0.663 | 0.827 | 2.626 | 1.864 | 2.954 |
| qlog records, JSON text sequence | 1467503 | 1088.9 ± 6.6% | 1518.4 ± 3.0% | 1541.7 ± 4.1% | 425.4 ± 4.2% | 873.8 ± 4.8% | 453.2 ± 9.8% | 0.717 | 0.706 | 2.560 | 1.246 | 2.403 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1653.2 ± 2.9% | 2226.2 ± 1.5% | 1435.6 ± 3.0% | 583.5 ± 2.6% | 530.5 ± 1.1% | 566.9 ± 7.0% | 0.743 | 1.152 | 2.833 | 3.116 | 2.916 |
| qlog records, JSON text sequence | 1467503 | 1406.6 ± 2.8% | 1831.0 ± 3.6% | 1174.0 ± 12.1% | 579.7 ± 72.8% | 674.3 ± 10.2% | 455.1 ± 3.0% | 0.768 | 1.198 | 2.427 | 2.086 | 3.091 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.776 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.663 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.827 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.717 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.706 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.743 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.768 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1576.1 ± 3.8% | 0.529 | 0.990 | 1.013 | 1.022 | 0.394 | 1.015 | 1.011 | 0.392 | 0.808 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1273.3 ± 5.1% | 0.883 | 1.019 | 0.989 | 0.987 | 0.336 | 0.993 | 0.979 | 0.311 | 0.818 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2264.0 ± 2.7% | 0.445 | 0.953 | 0.968 | 0.985 | 1.001 | 0.263 | 1.009 | 0.468 | 0.736 | 0.080 | 0.992 |
| qlog records, JSON text sequence | 1467503 | 1980.4 ± 2.1% | 0.723 | 0.924 | 0.986 | 0.991 | 0.993 | 0.258 | 0.996 | 0.434 | 0.722 | 0.101 | 1.003 |

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
| CLDR supplemental, 34 texts | 920675 | 1576.1 ± 3.8% | 1955.4 ± 2.8% | 1602.6 ± 3.5% | 511.6 ± 9.6% | 714.0 ± 33.1% | 456.6 ± 3.6% | 0.806 | 0.983 | 3.081 | 2.208 | 3.452 |
| qlog records, JSON text sequence | 1467503 | 1273.3 ± 5.1% | 1495.1 ± 2.7% | 1483.9 ± 5.4% | 420.3 ± 19.0% | 864.7 ± 10.8% | 449.6 ± 6.0% | 0.852 | 0.858 | 3.029 | 1.472 | 2.832 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2264.0 ± 2.7% | 2218.6 ± 0.8% | 1438.9 ± 0.8% | 582.3 ± 5.3% | 534.1 ± 11.5% | 567.1 ± 2.0% | 1.020 | 1.573 | 3.888 | 4.239 | 3.992 |
| qlog records, JSON text sequence | 1467503 | 1980.4 ± 2.1% | 1852.7 ± 3.3% | 1184.6 ± 0.9% | 569.2 ± 5.6% | 689.6 ± 27.8% | 433.2 ± 60.5% | 1.069 | 1.672 | 3.479 | 2.872 | 4.572 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2246.4 ± 20.8% | 2218.6 ± 0.8% | 1438.9 ± 0.8% | 582.3 ± 5.3% | 534.1 ± 11.5% | 567.1 ± 2.0% | 1.013 | 1.561 | 3.858 | 4.206 | 3.961 |
| qlog records, JSON text sequence | 1467503 | 1986.2 ± 2.9% | 1852.7 ± 3.3% | 1184.6 ± 0.9% | 569.2 ± 5.6% | 689.6 ± 27.8% | 433.2 ± 60.5% | 1.072 | 1.677 | 3.489 | 2.880 | 4.585 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1273.1 ± 2.6% | 1955.4 ± 2.8% | 1602.6 ± 3.5% | 511.6 ± 9.6% | 714.0 ± 33.1% | 456.6 ± 3.6% | 0.651 | 0.794 | 2.488 | 1.783 | 2.788 |
| qlog records, JSON text sequence | 1467503 | 1041.6 ± 19.3% | 1495.1 ± 2.7% | 1483.9 ± 5.4% | 420.3 ± 19.0% | 864.7 ± 10.8% | 449.6 ± 6.0% | 0.697 | 0.702 | 2.478 | 1.205 | 2.317 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1666.7 ± 2.9% | 2218.6 ± 0.8% | 1438.9 ± 0.8% | 582.3 ± 5.3% | 534.1 ± 11.5% | 567.1 ± 2.0% | 0.751 | 1.158 | 2.862 | 3.121 | 2.939 |
| qlog records, JSON text sequence | 1467503 | 1429.4 ± 1.2% | 1852.7 ± 3.3% | 1184.6 ± 0.9% | 569.2 ± 5.6% | 689.6 ± 27.8% | 433.2 ± 60.5% | 0.772 | 1.207 | 2.511 | 2.073 | 3.300 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.806 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.852 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.858 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.651 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.794 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.697 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.702 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.751 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.772 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1569.3 ± 9.4% | 0.529 | 0.993 | 1.027 | 1.024 | 0.401 | 1.023 | 1.021 | 0.395 | 0.779 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 1264.2 ± 6.2% | 0.871 | 1.014 | 0.990 | 0.976 | 0.364 | 0.986 | 0.993 | 0.308 | 0.809 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2254.3 ± 13.5% | 0.450 | 0.948 | 0.969 | 1.002 | 1.011 | 0.268 | 1.008 | 0.465 | 0.738 | 0.087 | 0.980 |
| qlog records, JSON text sequence | 1467503 | 1978.5 ± 3.3% | 0.715 | 0.909 | 0.990 | 0.997 | 0.992 | 0.263 | 0.986 | 0.432 | 0.724 | 0.107 | 0.998 |

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
| CLDR supplemental, 34 texts | 920675 | 1569.3 ± 9.4% | 2032.9 ± 2.0% | 1625.9 ± 1.9% | 520.4 ± 35.4% | 725.1 ± 4.2% | 453.0 ± 3.9% | 0.772 | 0.965 | 3.015 | 2.164 | 3.464 |
| qlog records, JSON text sequence | 1467503 | 1264.2 ± 6.2% | 1322.4 ± 5.2% | 1441.9 ± 1.1% | 398.9 ± 9.6% | 824.4 ± 8.9% | 439.9 ± 3.5% | 0.956 | 0.877 | 3.169 | 1.534 | 2.874 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2254.3 ± 13.5% | 2226.4 ± 6.2% | 1448.4 ± 5.9% | 589.4 ± 3.1% | 526.4 ± 4.4% | 567.4 ± 4.1% | 1.013 | 1.556 | 3.825 | 4.283 | 3.973 |
| qlog records, JSON text sequence | 1467503 | 1978.5 ± 3.3% | 1865.9 ± 1.1% | 1185.5 ± 1.3% | 574.2 ± 0.8% | 683.6 ± 4.2% | 475.9 ± 4.2% | 1.060 | 1.669 | 3.446 | 2.894 | 4.158 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2208.6 ± 2.3% | 2226.4 ± 6.2% | 1448.4 ± 5.9% | 589.4 ± 3.1% | 526.4 ± 4.4% | 567.4 ± 4.1% | 0.992 | 1.525 | 3.747 | 4.196 | 3.893 |
| qlog records, JSON text sequence | 1467503 | 1973.7 ± 2.7% | 1865.9 ± 1.1% | 1185.5 ± 1.3% | 574.2 ± 0.8% | 683.6 ± 4.2% | 475.9 ± 4.2% | 1.058 | 1.665 | 3.437 | 2.887 | 4.148 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1222.3 ± 2.3% | 2032.9 ± 2.0% | 1625.9 ± 1.9% | 520.4 ± 35.4% | 725.1 ± 4.2% | 453.0 ± 3.9% | 0.601 | 0.752 | 2.349 | 1.686 | 2.698 |
| qlog records, JSON text sequence | 1467503 | 1022.2 ± 6.3% | 1322.4 ± 5.2% | 1441.9 ± 1.1% | 398.9 ± 9.6% | 824.4 ± 8.9% | 439.9 ± 3.5% | 0.773 | 0.709 | 2.562 | 1.240 | 2.324 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1663.0 ± 7.9% | 2226.4 ± 6.2% | 1448.4 ± 5.9% | 589.4 ± 3.1% | 526.4 ± 4.4% | 567.4 ± 4.1% | 0.747 | 1.148 | 2.822 | 3.159 | 2.931 |
| qlog records, JSON text sequence | 1467503 | 1432.1 ± 2.2% | 1865.9 ± 1.1% | 1185.5 ± 1.3% | 574.2 ± 0.8% | 683.6 ± 4.2% | 475.9 ± 4.2% | 0.768 | 1.208 | 2.494 | 2.095 | 3.009 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.772 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.877 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.601 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.752 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.773 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.709 of yyjson.
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
| CLDR supplemental, 34 texts | 920675 | 1574.1 ± 3.8% | 0.530 | 0.975 | 1.011 | 1.014 | 0.396 | 1.013 | 1.014 | 0.390 | 0.780 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 1253.2 ± 12.2% | 0.875 | 1.022 | 0.993 | 0.993 | 0.342 | 0.990 | 0.996 | 0.314 | 0.815 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2250.8 ± 3.3% | 0.449 | 0.953 | 0.972 | 1.014 | 1.010 | 0.270 | 1.017 | 0.470 | 0.740 | 0.086 | 0.996 |
| qlog records, JSON text sequence | 1467503 | 1977.5 ± 2.6% | 0.719 | 0.911 | 0.984 | 0.994 | 0.988 | 0.263 | 0.986 | 0.434 | 0.727 | 0.106 | 0.995 |

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
| CLDR supplemental, 34 texts | 920675 | 1574.1 ± 3.8% | 2026.5 ± 1.8% | 1598.8 ± 3.1% | 516.0 ± 3.1% | 720.7 ± 3.7% | 452.8 ± 3.0% | 0.777 | 0.985 | 3.051 | 2.184 | 3.476 |
| qlog records, JSON text sequence | 1467503 | 1253.2 ± 12.2% | 1511.8 ± 3.3% | 1503.6 ± 1.7% | 396.0 ± 24.3% | 809.5 ± 105.2% | 433.3 ± 5.0% | 0.829 | 0.833 | 3.165 | 1.548 | 2.892 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2250.8 ± 3.3% | 2221.4 ± 4.7% | 1421.7 ± 1.9% | 588.7 ± 10.8% | 533.6 ± 2.8% | 575.3 ± 3.0% | 1.013 | 1.583 | 3.823 | 4.218 | 3.912 |
| qlog records, JSON text sequence | 1467503 | 1977.5 ± 2.6% | 1854.1 ± 1.7% | 1179.6 ± 3.8% | 574.8 ± 1.2% | 674.6 ± 4.7% | 477.7 ± 1.5% | 1.067 | 1.676 | 3.440 | 2.931 | 4.140 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2241.0 ± 1.3% | 2221.4 ± 4.7% | 1421.7 ± 1.9% | 588.7 ± 10.8% | 533.6 ± 2.8% | 575.3 ± 3.0% | 1.009 | 1.576 | 3.807 | 4.199 | 3.895 |
| qlog records, JSON text sequence | 1467503 | 1967.2 ± 2.3% | 1854.1 ± 1.7% | 1179.6 ± 3.8% | 574.8 ± 1.2% | 674.6 ± 4.7% | 477.7 ± 1.5% | 1.061 | 1.668 | 3.422 | 2.916 | 4.118 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1227.4 ± 0.7% | 2026.5 ± 1.8% | 1598.8 ± 3.1% | 516.0 ± 3.1% | 720.7 ± 3.7% | 452.8 ± 3.0% | 0.606 | 0.768 | 2.379 | 1.703 | 2.711 |
| qlog records, JSON text sequence | 1467503 | 1021.0 ± 3.2% | 1511.8 ± 3.3% | 1503.6 ± 1.7% | 396.0 ± 24.3% | 809.5 ± 105.2% | 433.3 ± 5.0% | 0.675 | 0.679 | 2.578 | 1.261 | 2.356 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1665.1 ± 0.9% | 2221.4 ± 4.7% | 1421.7 ± 1.9% | 588.7 ± 10.8% | 533.6 ± 2.8% | 575.3 ± 3.0% | 0.750 | 1.171 | 2.829 | 3.120 | 2.894 |
| qlog records, JSON text sequence | 1467503 | 1436.7 ± 1.8% | 1854.1 ± 1.7% | 1179.6 ± 3.8% | 574.8 ± 1.2% | 674.6 ± 4.7% | 477.7 ± 1.5% | 0.775 | 1.218 | 2.499 | 2.130 | 3.008 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.777 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.829 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.833 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.606 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.768 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.675 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.679 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.750 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.775 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1580.6 ± 4.4% | 0.546 | 0.984 | 1.020 | 1.014 | 0.401 | 1.021 | 1.013 | 0.394 | 0.845 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 1245.8 ± 5.3% | 0.930 | 0.999 | 1.051 | 1.032 | 0.352 | 1.007 | 1.017 | 0.301 | 0.667 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2256.7 ± 34.0% | 0.441 | 0.940 | 0.970 | 0.995 | 0.998 | 0.264 | 0.995 | 0.460 | 0.731 | 0.087 | 0.997 |
| qlog records, JSON text sequence | 1467503 | 1976.1 ± 18.4% | 0.722 | 0.925 | 0.991 | 0.990 | 0.984 | 0.261 | 0.992 | 0.432 | 0.726 | 0.108 | 1.007 |

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
| CLDR supplemental, 34 texts | 920675 | 1580.6 ± 4.4% | 2009.2 ± 2.1% | 1614.5 ± 3.7% | 517.5 ± 4.1% | 799.4 ± 21.6% | 448.6 ± 81.8% | 0.787 | 0.979 | 3.054 | 1.977 | 3.523 |
| qlog records, JSON text sequence | 1467503 | 1245.8 ± 5.3% | 1513.0 ± 4.0% | 1492.6 ± 5.8% | 408.8 ± 6.3% | 853.4 ± 11.6% | 448.5 ± 7.4% | 0.823 | 0.835 | 3.048 | 1.460 | 2.777 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2256.7 ± 34.0% | 2218.3 ± 2.4% | 1414.2 ± 1.5% | 581.6 ± 11.9% | 608.6 ± 1.7% | 560.2 ± 19.9% | 1.017 | 1.596 | 3.880 | 3.708 | 4.029 |
| qlog records, JSON text sequence | 1467503 | 1976.1 ± 18.4% | 1861.8 ± 1.7% | 1178.2 ± 1.5% | 562.3 ± 8.7% | 679.3 ± 4.9% | 466.4 ± 29.3% | 1.061 | 1.677 | 3.514 | 2.909 | 4.237 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2248.9 ± 2.3% | 2218.3 ± 2.4% | 1414.2 ± 1.5% | 581.6 ± 11.9% | 608.6 ± 1.7% | 560.2 ± 19.9% | 1.014 | 1.590 | 3.867 | 3.695 | 4.015 |
| qlog records, JSON text sequence | 1467503 | 1990.4 ± 1.1% | 1861.8 ± 1.7% | 1178.2 ± 1.5% | 562.3 ± 8.7% | 679.3 ± 4.9% | 466.4 ± 29.3% | 1.069 | 1.689 | 3.540 | 2.930 | 4.267 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.1 ± 3.3% | 2009.2 ± 2.1% | 1614.5 ± 3.7% | 517.5 ± 4.1% | 799.4 ± 21.6% | 448.6 ± 81.8% | 0.665 | 0.828 | 2.582 | 1.671 | 2.978 |
| qlog records, JSON text sequence | 1467503 | 830.5 ± 9.2% | 1513.0 ± 4.0% | 1492.6 ± 5.8% | 408.8 ± 6.3% | 853.4 ± 11.6% | 448.5 ± 7.4% | 0.549 | 0.556 | 2.032 | 0.973 | 1.852 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1649.9 ± 3.4% | 2218.3 ± 2.4% | 1414.2 ± 1.5% | 581.6 ± 11.9% | 608.6 ± 1.7% | 560.2 ± 19.9% | 0.744 | 1.167 | 2.837 | 2.711 | 2.945 |
| qlog records, JSON text sequence | 1467503 | 1435.6 ± 2.4% | 1861.8 ± 1.7% | 1178.2 ± 1.5% | 562.3 ± 8.7% | 679.3 ± 4.9% | 466.4 ± 29.3% | 0.771 | 1.218 | 2.553 | 2.113 | 3.078 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.787 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.823 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.835 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.665 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.828 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.549 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.556 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.744 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.771 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1546.1 ± 4.9% | 0.538 | 1.001 | 1.043 | 1.024 | 0.403 | 1.022 | 1.025 | 0.400 | 0.879 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1298.2 ± 5.0% | 0.860 | 1.024 | 0.987 | 0.980 | 0.381 | 0.978 | 0.982 | 0.360 | 0.848 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2286.9 ± 14.3% | 0.450 | 0.948 | 0.949 | 0.999 | 1.000 | 0.272 | 1.007 | 0.469 | 0.737 | 0.087 | 0.987 |
| qlog records, JSON text sequence | 1467503 | 2000.4 ± 1.9% | 0.717 | 0.914 | 0.990 | 1.001 | 0.996 | 0.262 | 0.997 | 0.431 | 0.725 | 0.106 | 1.006 |

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
| CLDR supplemental, 34 texts | 920675 | 1546.1 ± 4.9% | 2031.8 ± 1.3% | 1631.4 ± 2.1% | 519.2 ± 5.0% | 725.3 ± 2.8% | 446.9 ± 2.1% | 0.761 | 0.948 | 2.978 | 2.132 | 3.460 |
| qlog records, JSON text sequence | 1467503 | 1298.2 ± 5.0% | 1409.2 ± 3.5% | 1501.9 ± 4.8% | 435.9 ± 9.2% | 895.1 ± 4.0% | 451.9 ± 6.1% | 0.921 | 0.864 | 2.979 | 1.450 | 2.873 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2286.9 ± 14.3% | 2263.3 ± 3.3% | 1443.3 ± 9.8% | 596.0 ± 3.3% | 537.2 ± 1.7% | 570.6 ± 3.5% | 1.010 | 1.584 | 3.837 | 4.257 | 4.008 |
| qlog records, JSON text sequence | 1467503 | 2000.4 ± 1.9% | 1858.2 ± 1.4% | 1188.8 ± 2.3% | 575.4 ± 2.8% | 686.1 ± 4.2% | 465.0 ± 1.5% | 1.077 | 1.683 | 3.476 | 2.916 | 4.302 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2256.5 ± 31.9% | 2263.3 ± 3.3% | 1443.3 ± 9.8% | 596.0 ± 3.3% | 537.2 ± 1.7% | 570.6 ± 3.5% | 0.997 | 1.563 | 3.786 | 4.200 | 3.955 |
| qlog records, JSON text sequence | 1467503 | 2013.2 ± 1.1% | 1858.2 ± 1.4% | 1188.8 ± 2.3% | 575.4 ± 2.8% | 686.1 ± 4.2% | 465.0 ± 1.5% | 1.083 | 1.693 | 3.499 | 2.934 | 4.329 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1358.9 ± 18.3% | 2031.8 ± 1.3% | 1631.4 ± 2.1% | 519.2 ± 5.0% | 725.3 ± 2.8% | 446.9 ± 2.1% | 0.669 | 0.833 | 2.617 | 1.874 | 3.041 |
| qlog records, JSON text sequence | 1467503 | 1100.8 ± 4.8% | 1409.2 ± 3.5% | 1501.9 ± 4.8% | 435.9 ± 9.2% | 895.1 ± 4.0% | 451.9 ± 6.1% | 0.781 | 0.733 | 2.526 | 1.230 | 2.436 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1685.0 ± 2.0% | 2263.3 ± 3.3% | 1443.3 ± 9.8% | 596.0 ± 3.3% | 537.2 ± 1.7% | 570.6 ± 3.5% | 0.744 | 1.167 | 2.827 | 3.136 | 2.953 |
| qlog records, JSON text sequence | 1467503 | 1450.1 ± 2.8% | 1858.2 ± 1.4% | 1188.8 ± 2.3% | 575.4 ± 2.8% | 686.1 ± 4.2% | 465.0 ± 1.5% | 0.780 | 1.220 | 2.520 | 2.114 | 3.118 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.761 of simdjson.
- CLDR supplemental, 34 texts, decoding: stdx runs at 0.948 of yyjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.921 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.864 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.669 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.781 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.733 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.744 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.780 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1570.4 ± 5.4% | 0.528 | 0.979 | 1.022 | 1.008 | 0.397 | 1.015 | 1.022 | 0.395 | 0.819 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 1268.1 ± 12.4% | 0.887 | 1.024 | 0.991 | 0.977 | 0.371 | 0.989 | 0.987 | 0.340 | 0.844 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2296.5 ± 0.4% | 0.450 | 0.950 | 0.974 | 1.007 | 1.005 | 0.268 | 1.016 | 0.468 | 0.736 | 0.081 | 0.997 |
| qlog records, JSON text sequence | 1467503 | 2002.7 ± 1.4% | 0.720 | 0.922 | 1.002 | 1.007 | 1.001 | 0.262 | 0.998 | 0.426 | 0.723 | 0.101 | 1.006 |

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
| CLDR supplemental, 34 texts | 920675 | 1570.4 ± 5.4% | 2007.3 ± 4.0% | 1592.7 ± 7.0% | 506.1 ± 7.4% | 711.4 ± 5.3% | 448.0 ± 4.2% | 0.782 | 0.986 | 3.103 | 2.208 | 3.505 |
| qlog records, JSON text sequence | 1467503 | 1268.1 ± 12.4% | 1488.8 ± 9.9% | 1510.5 ± 3.3% | 430.0 ± 8.9% | 866.9 ± 8.9% | 448.2 ± 4.1% | 0.852 | 0.839 | 2.949 | 1.463 | 2.829 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2296.5 ± 0.4% | 2275.5 ± 1.5% | 1467.2 ± 1.6% | 600.8 ± 3.0% | 542.2 ± 2.0% | 583.1 ± 1.6% | 1.009 | 1.565 | 3.823 | 4.236 | 3.939 |
| qlog records, JSON text sequence | 1467503 | 2002.7 ± 1.4% | 1844.3 ± 3.8% | 1198.3 ± 2.5% | 578.8 ± 7.1% | 692.7 ± 4.8% | 454.3 ± 16.0% | 1.086 | 1.671 | 3.460 | 2.891 | 4.408 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2288.9 ± 5.4% | 2275.5 ± 1.5% | 1467.2 ± 1.6% | 600.8 ± 3.0% | 542.2 ± 2.0% | 583.1 ± 1.6% | 1.006 | 1.560 | 3.810 | 4.222 | 3.926 |
| qlog records, JSON text sequence | 1467503 | 2014.7 ± 9.6% | 1844.3 ± 3.8% | 1198.3 ± 2.5% | 578.8 ± 7.1% | 692.7 ± 4.8% | 454.3 ± 16.0% | 1.092 | 1.681 | 3.481 | 2.909 | 4.434 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1286.7 ± 45.0% | 2007.3 ± 4.0% | 1592.7 ± 7.0% | 506.1 ± 7.4% | 711.4 ± 5.3% | 448.0 ± 4.2% | 0.641 | 0.808 | 2.542 | 1.809 | 2.872 |
| qlog records, JSON text sequence | 1467503 | 1069.8 ± 2.4% | 1488.8 ± 9.9% | 1510.5 ± 3.3% | 430.0 ± 8.9% | 866.9 ± 8.9% | 448.2 ± 4.1% | 0.719 | 0.708 | 2.488 | 1.234 | 2.387 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1689.1 ± 2.1% | 2275.5 ± 1.5% | 1467.2 ± 1.6% | 600.8 ± 3.0% | 542.2 ± 2.0% | 583.1 ± 1.6% | 0.742 | 1.151 | 2.812 | 3.115 | 2.897 |
| qlog records, JSON text sequence | 1467503 | 1447.8 ± 1.6% | 1844.3 ± 3.8% | 1198.3 ± 2.5% | 578.8 ± 7.1% | 692.7 ± 4.8% | 454.3 ± 16.0% | 0.785 | 1.208 | 2.502 | 2.090 | 3.186 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.782 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.852 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.839 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.719 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.708 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.742 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.785 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1617.2 ± 2.7% | 0.526 | 0.981 | 1.012 | 1.017 | 0.391 | 1.007 | 1.011 | 0.392 | 0.773 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 1275.7 ± 8.9% | 0.881 | 1.015 | 0.980 | 0.965 | 0.318 | 0.965 | 0.978 | 0.296 | 0.784 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2309.7 ± 3.5% | 0.450 | 0.943 | 0.954 | 0.991 | 0.989 | 0.259 | 0.990 | 0.466 | 0.729 | 0.085 | 0.980 |
| qlog records, JSON text sequence | 1467503 | 2010.5 ± 71.9% | 0.720 | 0.916 | 0.991 | 0.992 | 0.986 | 0.257 | 0.986 | 0.430 | 0.723 | 0.107 | 0.992 |

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
| CLDR supplemental, 34 texts | 920675 | 1617.2 ± 2.7% | 2019.1 ± 3.9% | 1598.3 ± 9.9% | 524.9 ± 2.5% | 734.6 ± 4.3% | 462.1 ± 3.7% | 0.801 | 1.012 | 3.081 | 2.201 | 3.500 |
| qlog records, JSON text sequence | 1467503 | 1275.7 ± 8.9% | 1503.2 ± 5.0% | 1418.5 ± 2.8% | 409.8 ± 7.4% | 847.8 ± 4.7% | 443.5 ± 4.1% | 0.849 | 0.899 | 3.113 | 1.505 | 2.877 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2309.7 ± 3.5% | 2261.3 ± 2.4% | 1465.9 ± 3.0% | 595.3 ± 3.7% | 538.0 ± 2.6% | 568.6 ± 2.5% | 1.021 | 1.576 | 3.880 | 4.293 | 4.062 |
| qlog records, JSON text sequence | 1467503 | 2010.5 ± 71.9% | 1868.6 ± 2.3% | 1204.6 ± 17.2% | 570.3 ± 7.3% | 667.0 ± 82.7% | 471.2 ± 25.3% | 1.076 | 1.669 | 3.525 | 3.014 | 4.267 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2263.4 ± 2.9% | 2261.3 ± 2.4% | 1465.9 ± 3.0% | 595.3 ± 3.7% | 538.0 ± 2.6% | 568.6 ± 2.5% | 1.001 | 1.544 | 3.802 | 4.207 | 3.981 |
| qlog records, JSON text sequence | 1467503 | 1994.9 ± 11.5% | 1868.6 ± 2.3% | 1204.6 ± 17.2% | 570.3 ± 7.3% | 667.0 ± 82.7% | 471.2 ± 25.3% | 1.068 | 1.656 | 3.498 | 2.991 | 4.234 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1249.3 ± 1.3% | 2019.1 ± 3.9% | 1598.3 ± 9.9% | 524.9 ± 2.5% | 734.6 ± 4.3% | 462.1 ± 3.7% | 0.619 | 0.782 | 2.380 | 1.701 | 2.704 |
| qlog records, JSON text sequence | 1467503 | 999.9 ± 18.1% | 1503.2 ± 5.0% | 1418.5 ± 2.8% | 409.8 ± 7.4% | 847.8 ± 4.7% | 443.5 ± 4.1% | 0.665 | 0.705 | 2.440 | 1.179 | 2.255 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1684.6 ± 2.2% | 2261.3 ± 2.4% | 1465.9 ± 3.0% | 595.3 ± 3.7% | 538.0 ± 2.6% | 568.6 ± 2.5% | 0.745 | 1.149 | 2.830 | 3.131 | 2.963 |
| qlog records, JSON text sequence | 1467503 | 1453.8 ± 0.9% | 1868.6 ± 2.3% | 1204.6 ± 17.2% | 570.3 ± 7.3% | 667.0 ± 82.7% | 471.2 ± 25.3% | 0.778 | 1.207 | 2.549 | 2.180 | 3.085 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.801 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.849 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.899 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.619 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.782 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.665 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.705 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.745 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.778 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1574.6 ± 3.2% | 0.527 | 0.980 | 1.019 | 1.015 | 0.397 | 1.017 | 1.019 | 0.397 | 0.786 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1274.5 ± 2.3% | 0.870 | 1.020 | 0.980 | 0.982 | 0.368 | 0.976 | 0.963 | 0.305 | 0.805 | 0.106 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2277.3 ± 4.4% | 0.449 | 0.948 | 0.968 | 1.002 | 1.004 | 0.264 | 0.993 | 0.462 | 0.734 | 0.086 | 0.988 |
| qlog records, JSON text sequence | 1467503 | 2004.7 ± 10.1% | 0.709 | 0.917 | 0.990 | 0.996 | 0.994 | 0.258 | 0.998 | 0.433 | 0.686 | 0.106 | 1.004 |

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
| CLDR supplemental, 34 texts | 920675 | 1574.6 ± 3.2% | 1984.5 ± 1.5% | 1602.0 ± 3.2% | 514.1 ± 2.9% | 727.8 ± 1.4% | 457.5 ± 6.3% | 0.793 | 0.983 | 3.063 | 2.164 | 3.442 |
| qlog records, JSON text sequence | 1467503 | 1274.5 ± 2.3% | 1510.7 ± 2.2% | 1432.4 ± 5.5% | 416.6 ± 3.9% | 844.2 ± 6.3% | 449.1 ± 2.9% | 0.844 | 0.890 | 3.060 | 1.510 | 2.838 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2277.3 ± 4.4% | 2226.2 ± 7.5% | 1443.3 ± 2.6% | 596.6 ± 7.8% | 538.7 ± 2.5% | 568.4 ± 9.0% | 1.023 | 1.578 | 3.817 | 4.227 | 4.006 |
| qlog records, JSON text sequence | 1467503 | 2004.7 ± 10.1% | 1871.1 ± 6.2% | 1176.6 ± 1.4% | 568.5 ± 4.3% | 692.1 ± 1.8% | 480.7 ± 4.3% | 1.071 | 1.704 | 3.527 | 2.897 | 4.170 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2250.9 ± 3.0% | 2226.2 ± 7.5% | 1443.3 ± 2.6% | 596.6 ± 7.8% | 538.7 ± 2.5% | 568.4 ± 9.0% | 1.011 | 1.560 | 3.773 | 4.178 | 3.960 |
| qlog records, JSON text sequence | 1467503 | 2013.4 ± 3.6% | 1871.1 ± 6.2% | 1176.6 ± 1.4% | 568.5 ± 4.3% | 692.1 ± 1.8% | 480.7 ± 4.3% | 1.076 | 1.711 | 3.542 | 2.909 | 4.188 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1238.2 ± 1.9% | 1984.5 ± 1.5% | 1602.0 ± 3.2% | 514.1 ± 2.9% | 727.8 ± 1.4% | 457.5 ± 6.3% | 0.624 | 0.773 | 2.408 | 1.701 | 2.707 |
| qlog records, JSON text sequence | 1467503 | 1026.3 ± 9.4% | 1510.7 ± 2.2% | 1432.4 ± 5.5% | 416.6 ± 3.9% | 844.2 ± 6.3% | 449.1 ± 2.9% | 0.679 | 0.716 | 2.464 | 1.216 | 2.285 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1671.0 ± 3.9% | 2226.2 ± 7.5% | 1443.3 ± 2.6% | 596.6 ± 7.8% | 538.7 ± 2.5% | 568.4 ± 9.0% | 0.751 | 1.158 | 2.801 | 3.102 | 2.940 |
| qlog records, JSON text sequence | 1467503 | 1375.4 ± 4.2% | 1871.1 ± 6.2% | 1176.6 ± 1.4% | 568.5 ± 4.3% | 692.1 ± 1.8% | 480.7 ± 4.3% | 0.735 | 1.169 | 2.420 | 1.987 | 2.861 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.793 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.844 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.890 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.624 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.773 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.679 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.716 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.751 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.735 of simdjson.
