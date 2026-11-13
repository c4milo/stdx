# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1126.1 ± 0.2% | 0.536 | 0.968 | 0.997 | 0.999 | 0.459 | 1.003 | 1.006 | 0.383 | 0.683 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 844.6 ± 0.4% | 0.835 | 0.994 | 0.985 | 0.981 | 0.448 | 1.004 | 1.001 | 0.394 | 0.647 | 0.125 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1494.3 ± 1.0% | 0.442 | 1.006 | 0.971 | 1.010 | 1.009 | 0.265 | 0.994 | 0.546 | 0.827 | 0.089 | 1.023 |
| qlog records, JSON text sequence | 1467503 | 1261.0 ± 0.4% | 0.696 | 0.989 | 1.019 | 1.014 | 1.015 | 0.265 | 1.001 | 0.505 | 0.794 | 0.108 | 1.018 |

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
| CLDR supplemental, 34 texts | 920675 | 1126.1 ± 0.2% | 933.0 ± 0.8% | 1027.6 ± 0.4% | 299.9 ± 0.3% | 665.6 ± 0.1% | 309.5 ± 2.0% | 1.207 | 1.096 | 3.755 | 1.692 | 3.639 |
| qlog records, JSON text sequence | 1467503 | 844.6 ± 0.4% | 816.4 ± 0.4% | 785.9 ± 2.0% | 242.5 ± 0.4% | 689.5 ± 0.5% | 250.7 ± 1.8% | 1.035 | 1.075 | 3.483 | 1.225 | 3.369 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1494.3 ± 1.0% | 1237.8 ± 0.4% | 1036.7 ± 0.4% | 414.2 ± 0.2% | 448.2 ± 0.2% | 419.1 ± 0.5% | 1.207 | 1.441 | 3.608 | 3.334 | 3.566 |
| qlog records, JSON text sequence | 1467503 | 1261.0 ± 0.4% | 1053.2 ± 0.7% | 797.8 ± 1.1% | 384.5 ± 0.4% | 475.4 ± 0.8% | 280.5 ± 0.3% | 1.197 | 1.581 | 3.280 | 2.653 | 4.495 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1529.1 ± 0.3% | 1237.8 ± 0.4% | 1036.7 ± 0.4% | 414.2 ± 0.2% | 448.2 ± 0.2% | 419.1 ± 0.5% | 1.235 | 1.475 | 3.692 | 3.412 | 3.649 |
| qlog records, JSON text sequence | 1467503 | 1283.2 ± 0.6% | 1053.2 ± 0.7% | 797.8 ± 1.1% | 384.5 ± 0.4% | 475.4 ± 0.8% | 280.5 ± 0.3% | 1.218 | 1.609 | 3.338 | 2.699 | 4.575 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 769.0 ± 0.3% | 933.0 ± 0.8% | 1027.6 ± 0.4% | 299.9 ± 0.3% | 665.6 ± 0.1% | 309.5 ± 2.0% | 0.824 | 0.748 | 2.564 | 1.155 | 2.485 |
| qlog records, JSON text sequence | 1467503 | 546.5 ± 0.4% | 816.4 ± 0.4% | 785.9 ± 2.0% | 242.5 ± 0.4% | 689.5 ± 0.5% | 250.7 ± 1.8% | 0.669 | 0.695 | 2.254 | 0.793 | 2.180 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1235.4 ± 0.3% | 1237.8 ± 0.4% | 1036.7 ± 0.4% | 414.2 ± 0.2% | 448.2 ± 0.2% | 419.1 ± 0.5% | 0.998 | 1.192 | 2.983 | 2.757 | 2.948 |
| qlog records, JSON text sequence | 1467503 | 1001.5 ± 0.3% | 1053.2 ± 0.7% | 797.8 ± 1.1% | 384.5 ± 0.4% | 475.4 ± 0.8% | 280.5 ± 0.3% | 0.951 | 1.255 | 2.605 | 2.107 | 3.570 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.824 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.748 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.669 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.695 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.793 of serde_json.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.1 ± 0.2% | 0.534 | 0.968 | 1.006 | 1.006 | 0.457 | 1.001 | 0.999 | 0.382 | 0.812 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 853.8 ± 0.8% | 0.831 | 1.006 | 0.999 | 1.001 | 0.435 | 1.015 | 1.003 | 0.389 | 0.829 | 0.126 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1490.4 ± 1.8% | 0.445 | 1.005 | 0.970 | 1.007 | 1.009 | 0.270 | 0.999 | 0.548 | 0.830 | 0.088 | 1.026 |
| qlog records, JSON text sequence | 1467503 | 1262.7 ± 1.2% | 0.699 | 0.986 | 1.013 | 1.014 | 1.013 | 0.269 | 0.989 | 0.504 | 0.796 | 0.107 | 1.019 |

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
| CLDR supplemental, 34 texts | 920675 | 1127.1 ± 0.2% | 927.0 ± 0.9% | 1018.9 ± 0.3% | 300.1 ± 0.6% | 668.3 ± 0.4% | 308.8 ± 1.9% | 1.216 | 1.106 | 3.755 | 1.687 | 3.650 |
| qlog records, JSON text sequence | 1467503 | 853.8 ± 0.8% | 815.8 ± 0.1% | 797.1 ± 1.4% | 241.5 ± 0.7% | 701.8 ± 0.3% | 252.2 ± 0.5% | 1.047 | 1.071 | 3.535 | 1.217 | 3.386 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1490.4 ± 1.8% | 1253.5 ± 0.3% | 1043.9 ± 0.6% | 411.7 ± 0.3% | 449.8 ± 0.4% | 415.4 ± 0.4% | 1.189 | 1.428 | 3.620 | 3.313 | 3.587 |
| qlog records, JSON text sequence | 1467503 | 1262.7 ± 1.2% | 1060.0 ± 0.5% | 776.5 ± 1.2% | 372.1 ± 0.8% | 472.7 ± 0.4% | 277.7 ± 0.5% | 1.191 | 1.626 | 3.393 | 2.671 | 4.548 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1529.7 ± 0.4% | 1253.5 ± 0.3% | 1043.9 ± 0.6% | 411.7 ± 0.3% | 449.8 ± 0.4% | 415.4 ± 0.4% | 1.220 | 1.465 | 3.716 | 3.401 | 3.682 |
| qlog records, JSON text sequence | 1467503 | 1287.2 ± 1.1% | 1060.0 ± 0.5% | 776.5 ± 1.2% | 372.1 ± 0.8% | 472.7 ± 0.4% | 277.7 ± 0.5% | 1.214 | 1.658 | 3.459 | 2.723 | 4.636 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 915.5 ± 0.1% | 927.0 ± 0.9% | 1018.9 ± 0.3% | 300.1 ± 0.6% | 668.3 ± 0.4% | 308.8 ± 1.9% | 0.988 | 0.899 | 3.050 | 1.370 | 2.965 |
| qlog records, JSON text sequence | 1467503 | 707.8 ± 0.1% | 815.8 ± 0.1% | 797.1 ± 1.4% | 241.5 ± 0.7% | 701.8 ± 0.3% | 252.2 ± 0.5% | 0.868 | 0.888 | 2.930 | 1.009 | 2.807 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1236.5 ± 0.4% | 1253.5 ± 0.3% | 1043.9 ± 0.6% | 411.7 ± 0.3% | 449.8 ± 0.4% | 415.4 ± 0.4% | 0.986 | 1.185 | 3.004 | 2.749 | 2.976 |
| qlog records, JSON text sequence | 1467503 | 1004.5 ± 0.2% | 1060.0 ± 0.5% | 776.5 ± 1.2% | 372.1 ± 0.8% | 472.7 ± 0.4% | 277.7 ± 0.5% | 0.948 | 1.294 | 2.699 | 2.125 | 3.618 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.899 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.868 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.888 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.948 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 1

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1126.8 ± 0.4% | 0.535 | 0.968 | 1.005 | 1.006 | 0.459 | 1.002 | 0.999 | 0.384 | 0.813 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 854.1 ± 1.7% | 0.830 | 1.007 | 1.000 | 1.002 | 0.441 | 1.014 | 1.006 | 0.394 | 0.863 | 0.124 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1486.4 ± 1.2% | 0.444 | 1.006 | 0.971 | 1.009 | 1.010 | 0.270 | 0.999 | 0.548 | 0.831 | 0.089 | 1.029 |
| qlog records, JSON text sequence | 1467503 | 1264.4 ± 0.6% | 0.700 | 0.985 | 1.014 | 1.012 | 1.013 | 0.268 | 0.989 | 0.502 | 0.792 | 0.107 | 1.020 |

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
| CLDR supplemental, 34 texts | 920675 | 1126.8 ± 0.4% | 928.4 ± 0.4% | 1023.5 ± 0.2% | 299.9 ± 0.4% | 669.5 ± 0.2% | 309.0 ± 1.9% | 1.214 | 1.101 | 3.757 | 1.683 | 3.646 |
| qlog records, JSON text sequence | 1467503 | 854.1 ± 1.7% | 817.4 ± 0.1% | 795.1 ± 0.8% | 242.8 ± 0.4% | 709.3 ± 0.7% | 250.8 ± 1.2% | 1.045 | 1.074 | 3.518 | 1.204 | 3.405 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1486.4 ± 1.2% | 1253.3 ± 0.3% | 1043.5 ± 0.6% | 411.5 ± 0.2% | 449.8 ± 0.3% | 415.6 ± 0.5% | 1.186 | 1.424 | 3.612 | 3.305 | 3.576 |
| qlog records, JSON text sequence | 1467503 | 1264.4 ± 0.6% | 1058.7 ± 0.4% | 790.2 ± 1.6% | 369.2 ± 0.2% | 477.7 ± 0.3% | 276.3 ± 0.5% | 1.194 | 1.600 | 3.424 | 2.647 | 4.577 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1530.2 ± 0.4% | 1253.3 ± 0.3% | 1043.5 ± 0.6% | 411.5 ± 0.2% | 449.8 ± 0.3% | 415.6 ± 0.5% | 1.221 | 1.466 | 3.718 | 3.402 | 3.681 |
| qlog records, JSON text sequence | 1467503 | 1289.5 ± 0.4% | 1058.7 ± 0.4% | 790.2 ± 1.6% | 369.2 ± 0.2% | 477.7 ± 0.3% | 276.3 ± 0.5% | 1.218 | 1.632 | 3.492 | 2.699 | 4.667 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 915.6 ± 0.1% | 928.4 ± 0.4% | 1023.5 ± 0.2% | 299.9 ± 0.4% | 669.5 ± 0.2% | 309.0 ± 1.9% | 0.986 | 0.895 | 3.053 | 1.368 | 2.963 |
| qlog records, JSON text sequence | 1467503 | 737.0 ± 0.2% | 817.4 ± 0.1% | 795.1 ± 0.8% | 242.8 ± 0.4% | 709.3 ± 0.7% | 250.8 ± 1.2% | 0.902 | 0.927 | 3.036 | 1.039 | 2.938 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1235.5 ± 0.2% | 1253.3 ± 0.3% | 1043.5 ± 0.6% | 411.5 ± 0.2% | 449.8 ± 0.3% | 415.6 ± 0.5% | 0.986 | 1.184 | 3.002 | 2.747 | 2.972 |
| qlog records, JSON text sequence | 1467503 | 1001.5 ± 0.5% | 1058.7 ± 0.4% | 790.2 ± 1.6% | 369.2 ± 0.2% | 477.7 ± 0.3% | 276.3 ± 0.5% | 0.946 | 1.267 | 2.712 | 2.096 | 3.625 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.895 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.902 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.927 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.946 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 1

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.4 ± 0.4% | 0.534 | 0.967 | 1.003 | 1.004 | 0.457 | 1.001 | 0.998 | 0.381 | 0.807 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 852.9 ± 1.0% | 0.830 | 1.008 | 1.002 | 1.003 | 0.436 | 1.016 | 1.006 | 0.387 | 0.887 | 0.125 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1488.3 ± 0.7% | 0.444 | 1.003 | 0.973 | 1.006 | 1.011 | 0.270 | 1.000 | 0.549 | 0.829 | 0.088 | 1.029 |
| qlog records, JSON text sequence | 1467503 | 1261.8 ± 1.8% | 0.700 | 0.985 | 1.017 | 1.015 | 1.013 | 0.269 | 0.988 | 0.505 | 0.794 | 0.107 | 1.016 |

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
| CLDR supplemental, 34 texts | 920675 | 1127.4 ± 0.4% | 927.6 ± 0.7% | 1020.0 ± 0.3% | 300.4 ± 0.2% | 667.8 ± 0.1% | 309.5 ± 1.9% | 1.215 | 1.105 | 3.753 | 1.688 | 3.642 |
| qlog records, JSON text sequence | 1467503 | 852.9 ± 1.0% | 815.9 ± 0.1% | 793.5 ± 1.4% | 241.5 ± 1.0% | 715.2 ± 1.0% | 252.3 ± 1.2% | 1.045 | 1.075 | 3.532 | 1.193 | 3.381 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1488.3 ± 0.7% | 1255.4 ± 0.2% | 1041.4 ± 0.4% | 410.7 ± 0.3% | 449.5 ± 0.3% | 415.0 ± 0.6% | 1.186 | 1.429 | 3.624 | 3.311 | 3.587 |
| qlog records, JSON text sequence | 1467503 | 1261.8 ± 1.8% | 1059.9 ± 0.8% | 787.0 ± 0.6% | 372.6 ± 1.1% | 481.1 ± 0.6% | 277.0 ± 0.6% | 1.190 | 1.603 | 3.386 | 2.623 | 4.555 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1530.8 ± 0.7% | 1255.4 ± 0.2% | 1041.4 ± 0.4% | 410.7 ± 0.3% | 449.5 ± 0.3% | 415.0 ± 0.6% | 1.219 | 1.470 | 3.727 | 3.406 | 3.689 |
| qlog records, JSON text sequence | 1467503 | 1282.6 ± 0.5% | 1059.9 ± 0.8% | 787.0 ± 0.6% | 372.6 ± 1.1% | 481.1 ± 0.6% | 277.0 ± 0.6% | 1.210 | 1.630 | 3.442 | 2.666 | 4.630 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 909.7 ± 0.2% | 927.6 ± 0.7% | 1020.0 ± 0.3% | 300.4 ± 0.2% | 667.8 ± 0.1% | 309.5 ± 1.9% | 0.981 | 0.892 | 3.028 | 1.362 | 2.939 |
| qlog records, JSON text sequence | 1467503 | 756.3 ± 0.3% | 815.9 ± 0.1% | 793.5 ± 1.4% | 241.5 ± 1.0% | 715.2 ± 1.0% | 252.3 ± 1.2% | 0.927 | 0.953 | 3.132 | 1.058 | 2.998 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1233.8 ± 0.3% | 1255.4 ± 0.2% | 1041.4 ± 0.4% | 410.7 ± 0.3% | 449.5 ± 0.3% | 415.0 ± 0.6% | 0.983 | 1.185 | 3.004 | 2.745 | 2.973 |
| qlog records, JSON text sequence | 1467503 | 1002.1 ± 0.7% | 1059.9 ± 0.8% | 787.0 ± 0.6% | 372.6 ± 1.1% | 481.1 ± 0.6% | 277.0 ± 0.6% | 0.945 | 1.273 | 2.689 | 2.083 | 3.617 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.892 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.927 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.945 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1128.8 ± 0.6% | 0.534 | 0.967 | 1.002 | 1.003 | 0.459 | 1.001 | 0.996 | 0.382 | 0.830 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 848.4 ± 0.5% | 0.835 | 1.015 | 1.006 | 1.008 | 0.440 | 1.020 | 1.010 | 0.394 | 0.923 | 0.125 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1487.4 ± 0.7% | 0.444 | 1.005 | 0.972 | 1.008 | 1.011 | 0.270 | 1.000 | 0.549 | 0.829 | 0.089 | 1.029 |
| qlog records, JSON text sequence | 1467503 | 1264.9 ± 0.2% | 0.699 | 0.981 | 1.013 | 1.013 | 1.013 | 0.267 | 0.986 | 0.503 | 0.792 | 0.107 | 1.018 |

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
| CLDR supplemental, 34 texts | 920675 | 1128.8 ± 0.6% | 928.0 ± 0.5% | 1027.3 ± 0.3% | 300.0 ± 0.4% | 666.6 ± 0.1% | 309.1 ± 2.0% | 1.216 | 1.099 | 3.762 | 1.693 | 3.651 |
| qlog records, JSON text sequence | 1467503 | 848.4 ± 0.5% | 818.4 ± 0.1% | 794.0 ± 2.0% | 242.7 ± 0.9% | 706.6 ± 0.7% | 253.3 ± 0.6% | 1.037 | 1.069 | 3.495 | 1.201 | 3.350 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1487.4 ± 0.7% | 1254.5 ± 0.7% | 1042.9 ± 0.8% | 411.6 ± 0.3% | 449.9 ± 0.2% | 416.2 ± 0.5% | 1.186 | 1.426 | 3.614 | 3.306 | 3.574 |
| qlog records, JSON text sequence | 1467503 | 1264.9 ± 0.2% | 1059.5 ± 0.6% | 769.8 ± 0.5% | 373.8 ± 0.3% | 470.0 ± 1.1% | 276.2 ± 1.5% | 1.194 | 1.643 | 3.384 | 2.691 | 4.579 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1530.2 ± 0.3% | 1254.5 ± 0.7% | 1042.9 ± 0.8% | 411.6 ± 0.3% | 449.9 ± 0.2% | 416.2 ± 0.5% | 1.220 | 1.467 | 3.718 | 3.401 | 3.677 |
| qlog records, JSON text sequence | 1467503 | 1288.0 ± 0.7% | 1059.5 ± 0.6% | 769.8 ± 0.5% | 373.8 ± 0.3% | 470.0 ± 1.1% | 276.2 ± 1.5% | 1.216 | 1.673 | 3.446 | 2.740 | 4.663 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.3 ± 0.2% | 928.0 ± 0.5% | 1027.3 ± 0.3% | 300.0 ± 0.4% | 666.6 ± 0.1% | 309.1 ± 2.0% | 1.010 | 0.912 | 3.124 | 1.406 | 3.032 |
| qlog records, JSON text sequence | 1467503 | 783.4 ± 0.7% | 818.4 ± 0.1% | 794.0 ± 2.0% | 242.7 ± 0.9% | 706.6 ± 0.7% | 253.3 ± 0.6% | 0.957 | 0.987 | 3.228 | 1.109 | 3.093 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1233.6 ± 0.2% | 1254.5 ± 0.7% | 1042.9 ± 0.8% | 411.6 ± 0.3% | 449.9 ± 0.2% | 416.2 ± 0.5% | 0.983 | 1.183 | 2.997 | 2.742 | 2.964 |
| qlog records, JSON text sequence | 1467503 | 1002.2 ± 0.5% | 1059.5 ± 0.6% | 769.8 ± 0.5% | 373.8 ± 0.3% | 470.0 ± 1.1% | 276.2 ± 1.5% | 0.946 | 1.302 | 2.681 | 2.132 | 3.628 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.912 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.946 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1125.9 ± 0.5% | 0.535 | 0.968 | 0.995 | 0.998 | 0.459 | 1.004 | 1.006 | 0.384 | 0.683 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 854.0 ± 0.6% | 0.830 | 0.991 | 0.982 | 0.985 | 0.444 | 1.005 | 1.004 | 0.393 | 0.639 | 0.123 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1490.2 ± 0.7% | 0.442 | 1.005 | 0.972 | 1.005 | 1.009 | 0.266 | 0.998 | 0.546 | 0.828 | 0.089 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1266.9 ± 0.7% | 0.692 | 0.984 | 1.015 | 1.013 | 1.012 | 0.263 | 1.000 | 0.502 | 0.789 | 0.108 | 1.012 |

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
| CLDR supplemental, 34 texts | 920675 | 1125.9 ± 0.5% | 932.6 ± 0.7% | 1025.5 ± 0.1% | 299.9 ± 0.1% | 665.6 ± 0.3% | 308.5 ± 1.0% | 1.207 | 1.098 | 3.755 | 1.692 | 3.649 |
| qlog records, JSON text sequence | 1467503 | 854.0 ± 0.6% | 815.7 ± 0.1% | 791.1 ± 1.4% | 242.4 ± 0.6% | 712.3 ± 0.9% | 252.3 ± 1.3% | 1.047 | 1.079 | 3.523 | 1.199 | 3.384 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1490.2 ± 0.7% | 1254.0 ± 0.3% | 1038.5 ± 0.4% | 414.7 ± 0.2% | 448.1 ± 0.1% | 418.7 ± 0.4% | 1.188 | 1.435 | 3.594 | 3.326 | 3.559 |
| qlog records, JSON text sequence | 1467503 | 1266.9 ± 0.7% | 1055.7 ± 0.9% | 798.8 ± 0.9% | 384.6 ± 0.4% | 477.1 ± 0.9% | 279.6 ± 0.8% | 1.200 | 1.586 | 3.294 | 2.656 | 4.531 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1530.9 ± 0.5% | 1254.0 ± 0.3% | 1038.5 ± 0.4% | 414.7 ± 0.2% | 448.1 ± 0.1% | 418.7 ± 0.4% | 1.221 | 1.474 | 3.692 | 3.417 | 3.656 |
| qlog records, JSON text sequence | 1467503 | 1281.7 ± 0.6% | 1055.7 ± 0.9% | 798.8 ± 0.9% | 384.6 ± 0.4% | 477.1 ± 0.9% | 279.6 ± 0.8% | 1.214 | 1.605 | 3.333 | 2.687 | 4.584 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 769.4 ± 0.4% | 932.6 ± 0.7% | 1025.5 ± 0.1% | 299.9 ± 0.1% | 665.6 ± 0.3% | 308.5 ± 1.0% | 0.825 | 0.750 | 2.565 | 1.156 | 2.494 |
| qlog records, JSON text sequence | 1467503 | 546.1 ± 0.5% | 815.7 ± 0.1% | 791.1 ± 1.4% | 242.4 ± 0.6% | 712.3 ± 0.9% | 252.3 ± 1.3% | 0.669 | 0.690 | 2.253 | 0.767 | 2.164 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1233.6 ± 0.3% | 1254.0 ± 0.3% | 1038.5 ± 0.4% | 414.7 ± 0.2% | 448.1 ± 0.1% | 418.7 ± 0.4% | 0.984 | 1.188 | 2.975 | 2.753 | 2.946 |
| qlog records, JSON text sequence | 1467503 | 1000.1 ± 0.6% | 1055.7 ± 0.9% | 798.8 ± 0.9% | 384.6 ± 0.4% | 477.1 ± 0.9% | 279.6 ± 0.8% | 0.947 | 1.252 | 2.601 | 2.096 | 3.577 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.825 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.750 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.669 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.690 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.767 of serde_json.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.947 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1125.8 ± 0.4% | 0.535 | 0.969 | 1.005 | 1.005 | 0.460 | 1.002 | 0.998 | 0.384 | 0.814 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 847.7 ± 0.5% | 0.836 | 1.013 | 1.004 | 1.007 | 0.439 | 1.024 | 1.013 | 0.395 | 0.835 | 0.125 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1487.3 ± 0.8% | 0.444 | 1.003 | 0.970 | 1.007 | 1.009 | 0.270 | 1.000 | 0.548 | 0.829 | 0.089 | 1.029 |
| qlog records, JSON text sequence | 1467503 | 1263.9 ± 0.5% | 0.698 | 0.980 | 1.015 | 1.014 | 1.012 | 0.268 | 0.988 | 0.504 | 0.792 | 0.107 | 1.020 |

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
| CLDR supplemental, 34 texts | 920675 | 1125.8 ± 0.4% | 927.0 ± 0.3% | 1026.8 ± 0.5% | 300.2 ± 0.3% | 666.4 ± 0.2% | 309.4 ± 2.0% | 1.214 | 1.096 | 3.750 | 1.689 | 3.638 |
| qlog records, JSON text sequence | 1467503 | 847.7 ± 0.5% | 818.1 ± 0.1% | 790.9 ± 1.4% | 243.0 ± 0.7% | 704.3 ± 0.7% | 250.5 ± 3.2% | 1.036 | 1.072 | 3.488 | 1.204 | 3.384 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1487.3 ± 0.8% | 1253.2 ± 0.6% | 1042.5 ± 0.7% | 411.8 ± 0.6% | 449.7 ± 0.3% | 415.1 ± 0.6% | 1.187 | 1.427 | 3.612 | 3.308 | 3.583 |
| qlog records, JSON text sequence | 1467503 | 1263.9 ± 0.5% | 1058.7 ± 0.7% | 791.1 ± 1.0% | 374.4 ± 0.6% | 472.8 ± 0.8% | 278.2 ± 0.5% | 1.194 | 1.598 | 3.376 | 2.673 | 4.543 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1531.2 ± 0.3% | 1253.2 ± 0.6% | 1042.5 ± 0.7% | 411.8 ± 0.6% | 449.7 ± 0.3% | 415.1 ± 0.6% | 1.222 | 1.469 | 3.718 | 3.405 | 3.689 |
| qlog records, JSON text sequence | 1467503 | 1289.2 ± 0.2% | 1058.7 ± 0.7% | 791.1 ± 1.0% | 374.4 ± 0.6% | 472.8 ± 0.8% | 278.2 ± 0.5% | 1.218 | 1.630 | 3.443 | 2.726 | 4.634 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 916.8 ± 0.2% | 927.0 ± 0.3% | 1026.8 ± 0.5% | 300.2 ± 0.3% | 666.4 ± 0.2% | 309.4 ± 2.0% | 0.989 | 0.893 | 3.054 | 1.376 | 2.963 |
| qlog records, JSON text sequence | 1467503 | 707.9 ± 0.7% | 818.1 ± 0.1% | 790.9 ± 1.4% | 243.0 ± 0.7% | 704.3 ± 0.7% | 250.5 ± 3.2% | 0.865 | 0.895 | 2.913 | 1.005 | 2.826 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1232.4 ± 1.0% | 1253.2 ± 0.6% | 1042.5 ± 0.7% | 411.8 ± 0.6% | 449.7 ± 0.3% | 415.1 ± 0.6% | 0.983 | 1.182 | 2.993 | 2.741 | 2.969 |
| qlog records, JSON text sequence | 1467503 | 1001.2 ± 0.4% | 1058.7 ± 0.7% | 791.1 ± 1.0% | 374.4 ± 0.6% | 472.8 ± 0.8% | 278.2 ± 0.5% | 0.946 | 1.266 | 2.674 | 2.117 | 3.599 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.893 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.865 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.895 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.946 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 2

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1125.5 ± 0.3% | 0.534 | 0.968 | 1.005 | 1.005 | 0.460 | 1.000 | 0.996 | 0.384 | 0.813 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 846.9 ± 2.3% | 0.836 | 1.011 | 1.003 | 1.007 | 0.437 | 1.020 | 1.009 | 0.391 | 0.864 | 0.124 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1485.5 ± 0.6% | 0.443 | 1.002 | 0.971 | 1.007 | 1.007 | 0.270 | 0.995 | 0.547 | 0.827 | 0.089 | 1.025 |
| qlog records, JSON text sequence | 1467503 | 1243.3 ± 2.0% | 0.707 | 0.990 | 1.015 | 1.014 | 1.014 | 0.271 | 0.988 | 0.503 | 0.799 | 0.109 | 1.019 |

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
| CLDR supplemental, 34 texts | 920675 | 1125.5 ± 0.3% | 931.4 ± 0.5% | 1026.5 ± 0.5% | 300.0 ± 0.3% | 665.6 ± 0.4% | 308.8 ± 1.5% | 1.208 | 1.096 | 3.752 | 1.691 | 3.645 |
| qlog records, JSON text sequence | 1467503 | 846.9 ± 2.3% | 817.9 ± 0.1% | 773.9 ± 4.8% | 241.4 ± 0.9% | 698.0 ± 3.7% | 246.4 ± 2.9% | 1.035 | 1.094 | 3.508 | 1.213 | 3.437 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1485.5 ± 0.6% | 1250.2 ± 0.7% | 1036.5 ± 1.1% | 411.0 ± 0.3% | 449.5 ± 0.2% | 414.8 ± 0.4% | 1.188 | 1.433 | 3.614 | 3.305 | 3.581 |
| qlog records, JSON text sequence | 1467503 | 1243.3 ± 2.0% | 1048.7 ± 1.5% | 778.7 ± 3.3% | 368.7 ± 1.4% | 463.7 ± 2.3% | 273.8 ± 0.6% | 1.186 | 1.597 | 3.372 | 2.681 | 4.541 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1522.9 ± 0.4% | 1250.2 ± 0.7% | 1036.5 ± 1.1% | 411.0 ± 0.3% | 449.5 ± 0.2% | 414.8 ± 0.4% | 1.218 | 1.469 | 3.705 | 3.388 | 3.672 |
| qlog records, JSON text sequence | 1467503 | 1266.6 ± 1.2% | 1048.7 ± 1.5% | 778.7 ± 3.3% | 368.7 ± 1.4% | 463.7 ± 2.3% | 273.8 ± 0.6% | 1.208 | 1.627 | 3.435 | 2.732 | 4.626 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 914.5 ± 0.1% | 931.4 ± 0.5% | 1026.5 ± 0.5% | 300.0 ± 0.3% | 665.6 ± 0.4% | 308.8 ± 1.5% | 0.982 | 0.891 | 3.048 | 1.374 | 2.961 |
| qlog records, JSON text sequence | 1467503 | 731.8 ± 0.5% | 817.9 ± 0.1% | 773.9 ± 4.8% | 241.4 ± 0.9% | 698.0 ± 3.7% | 246.4 ± 2.9% | 0.895 | 0.946 | 3.031 | 1.048 | 2.970 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1229.0 ± 0.4% | 1250.2 ± 0.7% | 1036.5 ± 1.1% | 411.0 ± 0.3% | 449.5 ± 0.2% | 414.8 ± 0.4% | 0.983 | 1.186 | 2.990 | 2.734 | 2.963 |
| qlog records, JSON text sequence | 1467503 | 993.7 ± 0.7% | 1048.7 ± 1.5% | 778.7 ± 3.3% | 368.7 ± 1.4% | 463.7 ± 2.3% | 273.8 ± 0.6% | 0.948 | 1.276 | 2.695 | 2.143 | 3.629 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.891 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.895 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.946 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.948 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 2

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.8 ± 0.4% | 0.534 | 0.967 | 1.005 | 1.007 | 0.457 | 1.001 | 0.998 | 0.381 | 0.806 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 848.8 ± 0.9% | 0.834 | 1.014 | 1.006 | 1.006 | 0.435 | 1.022 | 1.013 | 0.388 | 0.890 | 0.126 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1489.9 ± 1.1% | 0.443 | 1.003 | 0.973 | 1.007 | 1.008 | 0.269 | 0.998 | 0.547 | 0.828 | 0.088 | 1.025 |
| qlog records, JSON text sequence | 1467503 | 1254.4 ± 1.7% | 0.703 | 0.989 | 1.019 | 1.019 | 1.018 | 0.270 | 0.994 | 0.507 | 0.799 | 0.107 | 1.025 |

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
| CLDR supplemental, 34 texts | 920675 | 1127.8 ± 0.4% | 925.9 ± 0.8% | 1016.5 ± 0.6% | 300.1 ± 0.4% | 667.5 ± 0.2% | 309.1 ± 2.4% | 1.218 | 1.110 | 3.759 | 1.690 | 3.649 |
| qlog records, JSON text sequence | 1467503 | 848.8 ± 0.9% | 815.9 ± 0.1% | 778.4 ± 2.4% | 240.9 ± 0.6% | 701.1 ± 0.4% | 246.7 ± 2.0% | 1.040 | 1.091 | 3.523 | 1.211 | 3.440 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1489.9 ± 1.1% | 1253.7 ± 0.3% | 1038.7 ± 0.8% | 410.8 ± 0.1% | 449.7 ± 0.2% | 415.1 ± 0.3% | 1.188 | 1.434 | 3.627 | 3.313 | 3.589 |
| qlog records, JSON text sequence | 1467503 | 1254.4 ± 1.7% | 1057.6 ± 0.3% | 789.3 ± 0.7% | 371.0 ± 0.5% | 471.4 ± 0.8% | 277.5 ± 0.9% | 1.186 | 1.589 | 3.381 | 2.661 | 4.521 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1527.7 ± 0.5% | 1253.7 ± 0.3% | 1038.7 ± 0.8% | 410.8 ± 0.1% | 449.7 ± 0.2% | 415.1 ± 0.3% | 1.219 | 1.471 | 3.719 | 3.397 | 3.681 |
| qlog records, JSON text sequence | 1467503 | 1285.5 ± 1.0% | 1057.6 ± 0.3% | 789.3 ± 0.7% | 371.0 ± 0.5% | 471.4 ± 0.8% | 277.5 ± 0.9% | 1.216 | 1.629 | 3.465 | 2.727 | 4.633 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 909.6 ± 0.1% | 925.9 ± 0.8% | 1016.5 ± 0.6% | 300.1 ± 0.4% | 667.5 ± 0.2% | 309.1 ± 2.4% | 0.982 | 0.895 | 3.031 | 1.363 | 2.943 |
| qlog records, JSON text sequence | 1467503 | 755.6 ± 0.5% | 815.9 ± 0.1% | 778.4 ± 2.4% | 240.9 ± 0.6% | 701.1 ± 0.4% | 246.7 ± 2.0% | 0.926 | 0.971 | 3.136 | 1.078 | 3.062 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1233.2 ± 0.2% | 1253.7 ± 0.3% | 1038.7 ± 0.8% | 410.8 ± 0.1% | 449.7 ± 0.2% | 415.1 ± 0.3% | 0.984 | 1.187 | 3.002 | 2.742 | 2.971 |
| qlog records, JSON text sequence | 1467503 | 1002.1 ± 0.3% | 1057.6 ± 0.3% | 789.3 ± 0.7% | 371.0 ± 0.5% | 471.4 ± 0.8% | 277.5 ± 0.9% | 0.948 | 1.270 | 2.701 | 2.126 | 3.611 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.895 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.926 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.948 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1128.7 ± 0.4% | 0.533 | 0.967 | 1.004 | 1.004 | 0.457 | 1.000 | 0.995 | 0.381 | 0.830 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 847.8 ± 0.5% | 0.834 | 1.015 | 1.005 | 1.006 | 0.438 | 1.022 | 1.009 | 0.388 | 0.921 | 0.126 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1486.3 ± 0.5% | 0.445 | 1.007 | 0.975 | 1.008 | 1.008 | 0.270 | 1.001 | 0.550 | 0.831 | 0.088 | 1.030 |
| qlog records, JSON text sequence | 1467503 | 1261.6 ± 1.4% | 0.700 | 0.984 | 1.015 | 1.013 | 1.013 | 0.269 | 0.989 | 0.504 | 0.794 | 0.107 | 1.020 |

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
| CLDR supplemental, 34 texts | 920675 | 1128.7 ± 0.4% | 922.9 ± 0.2% | 1019.5 ± 0.2% | 300.1 ± 0.3% | 668.0 ± 0.2% | 309.0 ± 2.1% | 1.223 | 1.107 | 3.761 | 1.690 | 3.653 |
| qlog records, JSON text sequence | 1467503 | 847.8 ± 0.5% | 815.7 ± 0.1% | 787.5 ± 1.3% | 241.0 ± 1.1% | 706.8 ± 0.7% | 247.4 ± 2.3% | 1.039 | 1.077 | 3.517 | 1.200 | 3.426 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1486.3 ± 0.5% | 1255.7 ± 0.4% | 1042.0 ± 0.3% | 411.3 ± 0.1% | 450.0 ± 0.1% | 416.1 ± 0.4% | 1.184 | 1.426 | 3.614 | 3.303 | 3.572 |
| qlog records, JSON text sequence | 1467503 | 1261.6 ± 1.4% | 1057.6 ± 0.4% | 791.4 ± 1.5% | 372.8 ± 0.6% | 478.8 ± 1.1% | 278.5 ± 0.5% | 1.193 | 1.594 | 3.384 | 2.635 | 4.530 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1531.2 ± 0.5% | 1255.7 ± 0.4% | 1042.0 ± 0.3% | 411.3 ± 0.1% | 450.0 ± 0.1% | 416.1 ± 0.4% | 1.219 | 1.469 | 3.723 | 3.403 | 3.680 |
| qlog records, JSON text sequence | 1467503 | 1286.4 ± 0.5% | 1057.6 ± 0.4% | 791.4 ± 1.5% | 372.8 ± 0.6% | 478.8 ± 1.1% | 278.5 ± 0.5% | 1.216 | 1.626 | 3.451 | 2.687 | 4.619 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.3 ± 0.1% | 922.9 ± 0.2% | 1019.5 ± 0.2% | 300.1 ± 0.3% | 668.0 ± 0.2% | 309.0 ± 2.1% | 1.016 | 0.919 | 3.123 | 1.403 | 3.033 |
| qlog records, JSON text sequence | 1467503 | 781.1 ± 0.9% | 815.7 ± 0.1% | 787.5 ± 1.3% | 241.0 ± 1.1% | 706.8 ± 0.7% | 247.4 ± 2.3% | 0.958 | 0.992 | 3.241 | 1.105 | 3.157 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1235.3 ± 0.2% | 1255.7 ± 0.4% | 1042.0 ± 0.3% | 411.3 ± 0.1% | 450.0 ± 0.1% | 416.1 ± 0.4% | 0.984 | 1.186 | 3.004 | 2.745 | 2.969 |
| qlog records, JSON text sequence | 1467503 | 1001.5 ± 0.4% | 1057.6 ± 0.4% | 791.4 ± 1.5% | 372.8 ± 0.6% | 478.8 ± 1.1% | 278.5 ± 0.5% | 0.947 | 1.266 | 2.687 | 2.092 | 3.596 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.919 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.947 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.6 ± 0.4% | 0.536 | 0.969 | 0.996 | 0.998 | 0.456 | 1.002 | 1.005 | 0.381 | 0.680 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 859.2 ± 1.0% | 0.824 | 0.981 | 0.977 | 0.976 | 0.441 | 1.000 | 0.994 | 0.381 | 0.634 | 0.124 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1488.6 ± 0.8% | 0.444 | 1.007 | 0.973 | 1.007 | 1.012 | 0.266 | 1.000 | 0.548 | 0.828 | 0.089 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1259.6 ± 1.2% | 0.696 | 0.989 | 1.020 | 1.015 | 1.018 | 0.265 | 1.002 | 0.506 | 0.796 | 0.108 | 1.014 |

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
| CLDR supplemental, 34 texts | 920675 | 1127.6 ± 0.4% | 924.9 ± 0.7% | 1017.5 ± 0.1% | 300.1 ± 0.2% | 667.1 ± 0.2% | 308.2 ± 1.8% | 1.219 | 1.108 | 3.758 | 1.690 | 3.659 |
| qlog records, JSON text sequence | 1467503 | 859.2 ± 1.0% | 814.0 ± 0.1% | 784.4 ± 1.9% | 241.3 ± 0.5% | 701.0 ± 0.3% | 250.8 ± 1.2% | 1.055 | 1.095 | 3.560 | 1.226 | 3.426 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1488.6 ± 0.8% | 1255.5 ± 0.4% | 1038.7 ± 0.3% | 413.3 ± 0.3% | 447.7 ± 0.3% | 418.7 ± 0.2% | 1.186 | 1.433 | 3.602 | 3.325 | 3.555 |
| qlog records, JSON text sequence | 1467503 | 1259.6 ± 1.2% | 1053.7 ± 0.4% | 795.1 ± 1.1% | 382.9 ± 0.6% | 479.0 ± 1.0% | 281.3 ± 0.7% | 1.195 | 1.584 | 3.289 | 2.630 | 4.478 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1528.9 ± 0.5% | 1255.5 ± 0.4% | 1038.7 ± 0.3% | 413.3 ± 0.3% | 447.7 ± 0.3% | 418.7 ± 0.2% | 1.218 | 1.472 | 3.699 | 3.415 | 3.652 |
| qlog records, JSON text sequence | 1467503 | 1277.7 ± 0.6% | 1053.7 ± 0.4% | 795.1 ± 1.1% | 382.9 ± 0.6% | 479.0 ± 1.0% | 281.3 ± 0.7% | 1.213 | 1.607 | 3.337 | 2.667 | 4.542 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 766.9 ± 0.2% | 924.9 ± 0.7% | 1017.5 ± 0.1% | 300.1 ± 0.2% | 667.1 ± 0.2% | 308.2 ± 1.8% | 0.829 | 0.754 | 2.556 | 1.150 | 2.488 |
| qlog records, JSON text sequence | 1467503 | 545.0 ± 0.7% | 814.0 ± 0.1% | 784.4 ± 1.9% | 241.3 ± 0.5% | 701.0 ± 0.3% | 250.8 ± 1.2% | 0.670 | 0.695 | 2.258 | 0.778 | 2.173 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1232.4 ± 0.1% | 1255.5 ± 0.4% | 1038.7 ± 0.3% | 413.3 ± 0.3% | 447.7 ± 0.3% | 418.7 ± 0.2% | 0.982 | 1.186 | 2.982 | 2.752 | 2.943 |
| qlog records, JSON text sequence | 1467503 | 1002.1 ± 0.3% | 1053.7 ± 0.4% | 795.1 ± 1.1% | 382.9 ± 0.6% | 479.0 ± 1.0% | 281.3 ± 0.7% | 0.951 | 1.260 | 2.617 | 2.092 | 3.563 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.829 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.754 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.670 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.695 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.778 of serde_json.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1126.7 ± 0.4% | 0.535 | 0.968 | 1.005 | 1.006 | 0.459 | 1.003 | 0.998 | 0.384 | 0.813 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 846.8 ± 0.9% | 0.837 | 1.013 | 1.008 | 1.007 | 0.441 | 1.021 | 1.012 | 0.396 | 0.838 | 0.125 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1489.8 ± 0.5% | 0.443 | 1.006 | 0.969 | 1.008 | 1.009 | 0.269 | 1.003 | 0.548 | 0.830 | 0.089 | 1.029 |
| qlog records, JSON text sequence | 1467503 | 1261.2 ± 1.4% | 0.701 | 0.987 | 1.014 | 1.015 | 1.012 | 0.268 | 0.990 | 0.502 | 0.794 | 0.107 | 1.021 |

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
| CLDR supplemental, 34 texts | 920675 | 1126.7 ± 0.4% | 914.3 ± 0.3% | 1024.8 ± 0.1% | 300.3 ± 0.1% | 669.1 ± 0.4% | 309.5 ± 2.1% | 1.232 | 1.099 | 3.752 | 1.684 | 3.640 |
| qlog records, JSON text sequence | 1467503 | 846.8 ± 0.9% | 817.6 ± 0.1% | 785.5 ± 2.3% | 241.8 ± 0.6% | 703.8 ± 1.4% | 253.2 ± 2.7% | 1.036 | 1.078 | 3.502 | 1.203 | 3.344 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1489.8 ± 0.5% | 1254.2 ± 0.3% | 1040.9 ± 0.4% | 411.3 ± 0.3% | 450.1 ± 0.2% | 416.2 ± 0.4% | 1.188 | 1.431 | 3.622 | 3.310 | 3.580 |
| qlog records, JSON text sequence | 1467503 | 1261.2 ± 1.4% | 1058.4 ± 0.8% | 788.8 ± 0.7% | 369.7 ± 0.8% | 469.5 ± 1.0% | 277.9 ± 0.2% | 1.192 | 1.599 | 3.411 | 2.686 | 4.538 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1532.7 ± 0.5% | 1254.2 ± 0.3% | 1040.9 ± 0.4% | 411.3 ± 0.3% | 450.1 ± 0.2% | 416.2 ± 0.4% | 1.222 | 1.472 | 3.726 | 3.405 | 3.683 |
| qlog records, JSON text sequence | 1467503 | 1288.2 ± 0.4% | 1058.4 ± 0.8% | 788.8 ± 0.7% | 369.7 ± 0.8% | 469.5 ± 1.0% | 277.9 ± 0.2% | 1.217 | 1.633 | 3.484 | 2.744 | 4.635 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 916.2 ± 0.5% | 914.3 ± 0.3% | 1024.8 ± 0.1% | 300.3 ± 0.1% | 669.1 ± 0.4% | 309.5 ± 2.1% | 1.002 | 0.894 | 3.051 | 1.369 | 2.960 |
| qlog records, JSON text sequence | 1467503 | 709.5 ± 0.3% | 817.6 ± 0.1% | 785.5 ± 2.3% | 241.8 ± 0.6% | 703.8 ± 1.4% | 253.2 ± 2.7% | 0.868 | 0.903 | 2.934 | 1.008 | 2.802 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1236.2 ± 0.2% | 1254.2 ± 0.3% | 1040.9 ± 0.4% | 411.3 ± 0.3% | 450.1 ± 0.2% | 416.2 ± 0.4% | 0.986 | 1.188 | 3.005 | 2.747 | 2.971 |
| qlog records, JSON text sequence | 1467503 | 1001.5 ± 0.3% | 1058.4 ± 0.8% | 788.8 ± 0.7% | 369.7 ± 0.8% | 469.5 ± 1.0% | 277.9 ± 0.2% | 0.946 | 1.270 | 2.709 | 2.133 | 3.603 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.894 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.868 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.903 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.946 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 3

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1126.7 ± 0.6% | 0.534 | 0.968 | 1.005 | 1.008 | 0.460 | 1.002 | 1.000 | 0.384 | 0.813 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 846.3 ± 1.1% | 0.835 | 1.017 | 1.011 | 1.009 | 0.440 | 1.024 | 1.015 | 0.395 | 0.870 | 0.125 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1491.8 ± 0.8% | 0.442 | 1.002 | 0.971 | 1.008 | 1.011 | 0.270 | 0.998 | 0.547 | 0.826 | 0.089 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1261.9 ± 1.4% | 0.700 | 0.987 | 1.015 | 1.015 | 1.012 | 0.269 | 0.988 | 0.504 | 0.793 | 0.107 | 1.017 |

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
| CLDR supplemental, 34 texts | 920675 | 1126.7 ± 0.6% | 922.6 ± 0.6% | 1026.5 ± 0.3% | 300.3 ± 0.2% | 666.4 ± 0.4% | 309.3 ± 2.3% | 1.221 | 1.098 | 3.751 | 1.691 | 3.643 |
| qlog records, JSON text sequence | 1467503 | 846.3 ± 1.1% | 818.1 ± 0.1% | 788.2 ± 1.2% | 241.4 ± 1.0% | 707.8 ± 0.9% | 251.9 ± 1.7% | 1.035 | 1.074 | 3.505 | 1.196 | 3.360 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1491.8 ± 0.8% | 1250.9 ± 0.7% | 1041.2 ± 0.4% | 412.0 ± 0.2% | 450.1 ± 0.2% | 415.1 ± 0.4% | 1.193 | 1.433 | 3.621 | 3.315 | 3.594 |
| qlog records, JSON text sequence | 1467503 | 1261.9 ± 1.4% | 1058.5 ± 0.5% | 793.0 ± 1.0% | 374.3 ± 0.5% | 468.1 ± 0.8% | 277.4 ± 0.6% | 1.192 | 1.591 | 3.371 | 2.696 | 4.549 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1532.1 ± 0.4% | 1250.9 ± 0.7% | 1041.2 ± 0.4% | 412.0 ± 0.2% | 450.1 ± 0.2% | 415.1 ± 0.4% | 1.225 | 1.471 | 3.718 | 3.404 | 3.691 |
| qlog records, JSON text sequence | 1467503 | 1283.0 ± 1.2% | 1058.5 ± 0.5% | 793.0 ± 1.0% | 374.3 ± 0.5% | 468.1 ± 0.8% | 277.4 ± 0.6% | 1.212 | 1.618 | 3.428 | 2.741 | 4.625 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 915.5 ± 1.0% | 922.6 ± 0.6% | 1026.5 ± 0.3% | 300.3 ± 0.2% | 666.4 ± 0.4% | 309.3 ± 2.3% | 0.992 | 0.892 | 3.048 | 1.374 | 2.960 |
| qlog records, JSON text sequence | 1467503 | 736.6 ± 0.3% | 818.1 ± 0.1% | 788.2 ± 1.2% | 241.4 ± 1.0% | 707.8 ± 0.9% | 251.9 ± 1.7% | 0.900 | 0.935 | 3.051 | 1.041 | 2.925 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1232.4 ± 0.2% | 1250.9 ± 0.7% | 1041.2 ± 0.4% | 412.0 ± 0.2% | 450.1 ± 0.2% | 415.1 ± 0.4% | 0.985 | 1.184 | 2.991 | 2.738 | 2.969 |
| qlog records, JSON text sequence | 1467503 | 1000.4 ± 0.3% | 1058.5 ± 0.5% | 793.0 ± 1.0% | 374.3 ± 0.5% | 468.1 ± 0.8% | 277.4 ± 0.6% | 0.945 | 1.261 | 2.673 | 2.137 | 3.606 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.892 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.900 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.935 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.945 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 3

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1125.9 ± 0.3% | 0.535 | 0.968 | 1.006 | 1.007 | 0.460 | 1.002 | 0.998 | 0.384 | 0.806 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 857.5 ± 1.3% | 0.824 | 1.001 | 0.997 | 0.999 | 0.440 | 1.013 | 1.005 | 0.390 | 0.880 | 0.124 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1488.1 ± 0.7% | 0.444 | 1.004 | 0.971 | 1.006 | 1.008 | 0.269 | 0.998 | 0.546 | 0.829 | 0.089 | 1.028 |
| qlog records, JSON text sequence | 1467503 | 1260.9 ± 1.8% | 0.701 | 0.986 | 1.017 | 1.013 | 1.009 | 0.268 | 0.985 | 0.499 | 0.783 | 0.107 | 1.022 |

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
| CLDR supplemental, 34 texts | 920675 | 1125.9 ± 0.3% | 931.0 ± 0.3% | 1024.8 ± 0.3% | 299.9 ± 0.5% | 668.8 ± 0.2% | 308.7 ± 1.8% | 1.209 | 1.099 | 3.755 | 1.683 | 3.648 |
| qlog records, JSON text sequence | 1467503 | 857.5 ± 1.3% | 817.6 ± 0.1% | 787.2 ± 0.8% | 242.1 ± 0.4% | 703.7 ± 0.5% | 252.8 ± 2.5% | 1.049 | 1.089 | 3.541 | 1.219 | 3.392 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1488.1 ± 0.7% | 1255.1 ± 0.6% | 1037.9 ± 0.8% | 411.1 ± 0.4% | 449.6 ± 0.3% | 415.0 ± 0.6% | 1.186 | 1.434 | 3.620 | 3.310 | 3.586 |
| qlog records, JSON text sequence | 1467503 | 1260.9 ± 1.8% | 1058.8 ± 0.4% | 790.0 ± 2.2% | 370.3 ± 1.3% | 479.5 ± 1.6% | 277.8 ± 0.9% | 1.191 | 1.596 | 3.405 | 2.630 | 4.539 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1529.1 ± 0.6% | 1255.1 ± 0.6% | 1037.9 ± 0.8% | 411.1 ± 0.4% | 449.6 ± 0.3% | 415.0 ± 0.6% | 1.218 | 1.473 | 3.720 | 3.401 | 3.685 |
| qlog records, JSON text sequence | 1467503 | 1288.7 ± 1.2% | 1058.8 ± 0.4% | 790.0 ± 2.2% | 370.3 ± 1.3% | 479.5 ± 1.6% | 277.8 ± 0.9% | 1.217 | 1.631 | 3.480 | 2.688 | 4.639 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 907.8 ± 0.1% | 931.0 ± 0.3% | 1024.8 ± 0.3% | 299.9 ± 0.5% | 668.8 ± 0.2% | 308.7 ± 1.8% | 0.975 | 0.886 | 3.028 | 1.357 | 2.941 |
| qlog records, JSON text sequence | 1467503 | 754.3 ± 0.8% | 817.6 ± 0.1% | 787.2 ± 0.8% | 242.1 ± 0.4% | 703.7 ± 0.5% | 252.8 ± 2.5% | 0.923 | 0.958 | 3.115 | 1.072 | 2.984 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1234.0 ± 0.5% | 1255.1 ± 0.6% | 1037.9 ± 0.8% | 411.1 ± 0.4% | 449.6 ± 0.3% | 415.0 ± 0.6% | 0.983 | 1.189 | 3.002 | 2.745 | 2.974 |
| qlog records, JSON text sequence | 1467503 | 987.9 ± 0.4% | 1058.8 ± 0.4% | 790.0 ± 2.2% | 370.3 ± 1.3% | 479.5 ± 1.6% | 277.8 ± 0.9% | 0.933 | 1.250 | 2.668 | 2.060 | 3.556 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.886 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.923 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.933 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | Neoverse-N2 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.3 ± 0.3% | 0.534 | 0.968 | 1.004 | 1.005 | 0.456 | 1.002 | 0.999 | 0.381 | 0.832 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 848.3 ± 1.0% | 0.834 | 1.017 | 1.010 | 1.008 | 0.444 | 1.022 | 1.017 | 0.390 | 0.923 | 0.126 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1493.6 ± 0.5% | 0.443 | 1.001 | 0.967 | 1.008 | 1.008 | 0.269 | 0.998 | 0.547 | 0.825 | 0.088 | 1.023 |
| qlog records, JSON text sequence | 1467503 | 1259.7 ± 1.7% | 0.701 | 0.987 | 1.018 | 1.017 | 1.017 | 0.269 | 0.993 | 0.506 | 0.797 | 0.107 | 1.021 |

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
| CLDR supplemental, 34 texts | 920675 | 1127.3 ± 0.3% | 927.5 ± 0.4% | 1020.1 ± 0.3% | 299.9 ± 0.4% | 668.1 ± 0.2% | 308.7 ± 1.1% | 1.216 | 1.105 | 3.759 | 1.687 | 3.652 |
| qlog records, JSON text sequence | 1467503 | 848.3 ± 1.0% | 815.6 ± 0.1% | 789.1 ± 1.7% | 241.1 ± 0.8% | 702.5 ± 0.9% | 250.9 ± 1.5% | 1.040 | 1.075 | 3.518 | 1.208 | 3.381 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1493.6 ± 0.5% | 1252.1 ± 0.5% | 1042.1 ± 0.4% | 411.0 ± 0.3% | 449.6 ± 0.4% | 415.5 ± 0.4% | 1.193 | 1.433 | 3.634 | 3.322 | 3.595 |
| qlog records, JSON text sequence | 1467503 | 1259.7 ± 1.7% | 1062.3 ± 0.4% | 790.8 ± 0.6% | 372.7 ± 0.5% | 480.3 ± 1.2% | 277.7 ± 1.0% | 1.186 | 1.593 | 3.380 | 2.623 | 4.536 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1528.7 ± 0.5% | 1252.1 ± 0.5% | 1042.1 ± 0.4% | 411.0 ± 0.3% | 449.6 ± 0.4% | 415.5 ± 0.4% | 1.221 | 1.467 | 3.719 | 3.400 | 3.679 |
| qlog records, JSON text sequence | 1467503 | 1285.7 ± 0.5% | 1062.3 ± 0.4% | 790.8 ± 0.6% | 372.7 ± 0.5% | 480.3 ± 1.2% | 277.7 ± 1.0% | 1.210 | 1.626 | 3.450 | 2.677 | 4.629 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.5 ± 0.2% | 927.5 ± 0.4% | 1020.1 ± 0.3% | 299.9 ± 0.4% | 668.1 ± 0.2% | 308.7 ± 1.1% | 1.011 | 0.919 | 3.126 | 1.403 | 3.037 |
| qlog records, JSON text sequence | 1467503 | 783.0 ± 0.7% | 815.6 ± 0.1% | 789.1 ± 1.7% | 241.1 ± 0.8% | 702.5 ± 0.9% | 250.9 ± 1.5% | 0.960 | 0.992 | 3.247 | 1.115 | 3.120 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1232.9 ± 0.2% | 1252.1 ± 0.5% | 1042.1 ± 0.4% | 411.0 ± 0.3% | 449.6 ± 0.4% | 415.5 ± 0.4% | 0.985 | 1.183 | 3.000 | 2.742 | 2.967 |
| qlog records, JSON text sequence | 1467503 | 1004.4 ± 0.3% | 1062.3 ± 0.4% | 790.8 ± 0.6% | 372.7 ± 0.5% | 480.3 ± 1.2% | 277.7 ± 1.0% | 0.946 | 1.270 | 2.695 | 2.091 | 3.616 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.919 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.946 of simdjson.
