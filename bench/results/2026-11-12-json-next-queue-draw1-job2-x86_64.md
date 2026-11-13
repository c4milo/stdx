# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1100.0 ± 1.6% | 0.471 | 1.009 | 1.018 | 1.023 | 0.393 | 1.024 | 1.026 | 0.359 | 0.717 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 841.9 ± 1.1% | 0.779 | 1.041 | 1.030 | 1.027 | 0.395 | 1.018 | 1.023 | 0.364 | 0.708 | 0.126 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1400.9 ± 1.9% | 0.381 | 0.968 | 0.962 | 0.996 | 1.001 | 0.250 | 1.002 | 0.433 | 0.769 | 0.092 | 1.018 |
| qlog records, JSON text sequence | 1467503 | 1142.8 ± 1.2% | 0.693 | 0.958 | 0.992 | 1.010 | 0.993 | 0.242 | 0.992 | 0.398 | 0.801 | 0.121 | 1.054 |

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
| CLDR supplemental, 34 texts | 920675 | 1100.0 ± 1.6% | 1174.8 ± 1.9% | 827.8 ± 0.3% | 269.6 ± 0.2% | 503.1 ± 0.7% | 271.6 ± 1.5% | 0.936 | 1.329 | 4.081 | 2.186 | 4.050 |
| qlog records, JSON text sequence | 1467503 | 841.9 ± 1.1% | 973.0 ± 0.9% | 863.0 ± 0.7% | 234.5 ± 1.0% | 576.7 ± 0.8% | 239.7 ± 1.7% | 0.865 | 0.975 | 3.590 | 1.460 | 3.513 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1400.9 ± 1.9% | 1141.0 ± 0.6% | 782.7 ± 1.0% | 347.9 ± 1.4% | 350.2 ± 0.7% | 375.3 ± 1.9% | 1.228 | 1.790 | 4.027 | 4.001 | 3.733 |
| qlog records, JSON text sequence | 1467503 | 1142.8 ± 1.2% | 978.1 ± 1.3% | 718.9 ± 1.6% | 334.4 ± 1.4% | 376.6 ± 7.8% | 261.6 ± 3.1% | 1.168 | 1.590 | 3.417 | 3.035 | 4.369 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1426.4 ± 0.3% | 1141.0 ± 0.6% | 782.7 ± 1.0% | 347.9 ± 1.4% | 350.2 ± 0.7% | 375.3 ± 1.9% | 1.250 | 1.822 | 4.100 | 4.074 | 3.801 |
| qlog records, JSON text sequence | 1467503 | 1204.5 ± 2.1% | 978.1 ± 1.3% | 718.9 ± 1.6% | 334.4 ± 1.4% | 376.6 ± 7.8% | 261.6 ± 3.1% | 1.231 | 1.675 | 3.602 | 3.198 | 4.604 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 788.4 ± 1.2% | 1174.8 ± 1.9% | 827.8 ± 0.3% | 269.6 ± 0.2% | 503.1 ± 0.7% | 271.6 ± 1.5% | 0.671 | 0.952 | 2.925 | 1.567 | 2.903 |
| qlog records, JSON text sequence | 1467503 | 596.3 ± 1.3% | 973.0 ± 0.9% | 863.0 ± 0.7% | 234.5 ± 1.0% | 576.7 ± 0.8% | 239.7 ± 1.7% | 0.613 | 0.691 | 2.543 | 1.034 | 2.488 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1077.4 ± 5.7% | 1141.0 ± 0.6% | 782.7 ± 1.0% | 347.9 ± 1.4% | 350.2 ± 0.7% | 375.3 ± 1.9% | 0.944 | 1.376 | 3.097 | 3.077 | 2.871 |
| qlog records, JSON text sequence | 1467503 | 915.7 ± 12.8% | 978.1 ± 1.3% | 718.9 ± 1.6% | 334.4 ± 1.4% | 376.6 ± 7.8% | 261.6 ± 3.1% | 0.936 | 1.274 | 2.738 | 2.432 | 3.501 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.936 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.865 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.671 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.613 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.691 of yyjson.

# bench-json, CLDR and qlog alone: null, round 1

| Field | Value |
|---|---|
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1105.6 ± 0.4% | 0.463 | 0.999 | 0.994 | 0.995 | 0.389 | 0.996 | 0.995 | 0.356 | 0.685 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 856.3 ± 1.5% | 0.763 | 1.010 | 0.964 | 0.971 | 0.390 | 0.976 | 0.974 | 0.356 | 0.629 | 0.124 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1411.6 ± 0.9% | 0.386 | 0.954 | 0.965 | 0.992 | 0.992 | 0.265 | 0.992 | 0.431 | 0.775 | 0.091 | 1.012 |
| qlog records, JSON text sequence | 1467503 | 1149.5 ± 1.6% | 0.707 | 0.941 | 0.991 | 1.015 | 0.986 | 0.258 | 0.986 | 0.411 | 0.785 | 0.123 | 1.048 |

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
| CLDR supplemental, 34 texts | 920675 | 1105.6 ± 0.4% | 1159.0 ± 2.0% | 846.1 ± 0.3% | 269.1 ± 1.0% | 503.1 ± 0.2% | 274.0 ± 3.9% | 0.954 | 1.307 | 4.109 | 2.198 | 4.035 |
| qlog records, JSON text sequence | 1467503 | 856.3 ± 1.5% | 971.2 ± 0.5% | 863.3 ± 0.4% | 234.2 ± 0.7% | 575.3 ± 0.5% | 242.3 ± 1.9% | 0.882 | 0.992 | 3.657 | 1.488 | 3.533 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1411.6 ± 0.9% | 1146.3 ± 0.3% | 782.4 ± 0.9% | 342.7 ± 1.2% | 350.7 ± 2.1% | 376.5 ± 0.6% | 1.231 | 1.804 | 4.119 | 4.025 | 3.749 |
| qlog records, JSON text sequence | 1467503 | 1149.5 ± 1.6% | 970.4 ± 1.0% | 721.0 ± 1.6% | 321.8 ± 1.4% | 387.2 ± 19.2% | 256.3 ± 3.1% | 1.185 | 1.594 | 3.572 | 2.969 | 4.485 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1428.6 ± 0.4% | 1146.3 ± 0.3% | 782.4 ± 0.9% | 342.7 ± 1.2% | 350.7 ± 2.1% | 376.5 ± 0.6% | 1.246 | 1.826 | 4.169 | 4.073 | 3.794 |
| qlog records, JSON text sequence | 1467503 | 1204.4 ± 2.0% | 970.4 ± 1.0% | 721.0 ± 1.6% | 321.8 ± 1.4% | 387.2 ± 19.2% | 256.3 ± 3.1% | 1.241 | 1.670 | 3.742 | 3.111 | 4.700 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 757.6 ± 0.3% | 1159.0 ± 2.0% | 846.1 ± 0.3% | 269.1 ± 1.0% | 503.1 ± 0.2% | 274.0 ± 3.9% | 0.654 | 0.895 | 2.816 | 1.506 | 2.765 |
| qlog records, JSON text sequence | 1467503 | 538.7 ± 2.2% | 971.2 ± 0.5% | 863.3 ± 0.4% | 234.2 ± 0.7% | 575.3 ± 0.5% | 242.3 ± 1.9% | 0.555 | 0.624 | 2.301 | 0.936 | 2.223 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1093.8 ± 0.4% | 1146.3 ± 0.3% | 782.4 ± 0.9% | 342.7 ± 1.2% | 350.7 ± 2.1% | 376.5 ± 0.6% | 0.954 | 1.398 | 3.192 | 3.119 | 2.905 |
| qlog records, JSON text sequence | 1467503 | 902.8 ± 4.4% | 970.4 ± 1.0% | 721.0 ± 1.6% | 321.8 ± 1.4% | 387.2 ± 19.2% | 256.3 ± 3.1% | 0.930 | 1.252 | 2.805 | 2.332 | 3.523 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.882 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.654 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.895 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.555 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.624 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.936 of serde_json.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.930 of simdjson.

# bench-json, CLDR and qlog alone: head, round 1

| Field | Value |
|---|---|
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1105.0 ± 0.6% | 0.464 | 0.988 | 0.993 | 0.997 | 0.389 | 0.997 | 0.996 | 0.357 | 0.803 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 861.4 ± 1.0% | 0.761 | 1.008 | 0.960 | 0.969 | 0.392 | 0.963 | 0.968 | 0.356 | 0.873 | 0.123 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1411.4 ± 0.4% | 0.388 | 0.954 | 0.959 | 0.989 | 0.991 | 0.261 | 0.991 | 0.443 | 0.771 | 0.090 | 1.012 |
| qlog records, JSON text sequence | 1467503 | 1152.9 ± 0.7% | 0.713 | 0.939 | 0.987 | 1.012 | 0.989 | 0.257 | 0.989 | 0.419 | 0.767 | 0.117 | 1.045 |

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
| CLDR supplemental, 34 texts | 920675 | 1105.0 ± 0.6% | 1170.5 ± 4.5% | 846.3 ± 0.4% | 270.1 ± 1.1% | 500.8 ± 0.8% | 273.9 ± 1.6% | 0.944 | 1.306 | 4.091 | 2.207 | 4.035 |
| qlog records, JSON text sequence | 1467503 | 861.4 ± 1.0% | 977.0 ± 1.6% | 859.6 ± 1.2% | 235.5 ± 1.9% | 555.9 ± 1.4% | 242.4 ± 3.4% | 0.882 | 1.002 | 3.658 | 1.549 | 3.553 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1411.4 ± 0.4% | 1143.4 ± 7.5% | 782.8 ± 0.5% | 342.8 ± 0.5% | 349.4 ± 1.3% | 376.4 ± 1.5% | 1.234 | 1.803 | 4.117 | 4.039 | 3.750 |
| qlog records, JSON text sequence | 1467503 | 1152.9 ± 0.7% | 983.3 ± 1.1% | 718.3 ± 1.4% | 325.1 ± 1.1% | 371.6 ± 8.6% | 257.9 ± 1.4% | 1.172 | 1.605 | 3.546 | 3.103 | 4.470 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1428.8 ± 1.1% | 1143.4 ± 7.5% | 782.8 ± 0.5% | 342.8 ± 0.5% | 349.4 ± 1.3% | 376.4 ± 1.5% | 1.250 | 1.825 | 4.168 | 4.089 | 3.797 |
| qlog records, JSON text sequence | 1467503 | 1205.3 ± 0.8% | 983.3 ± 1.1% | 718.3 ± 1.4% | 325.1 ± 1.1% | 371.6 ± 8.6% | 257.9 ± 1.4% | 1.226 | 1.678 | 3.708 | 3.244 | 4.673 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 887.4 ± 2.5% | 1170.5 ± 4.5% | 846.3 ± 0.4% | 270.1 ± 1.1% | 500.8 ± 0.8% | 273.9 ± 1.6% | 0.758 | 1.049 | 3.285 | 1.772 | 3.240 |
| qlog records, JSON text sequence | 1467503 | 751.8 ± 0.8% | 977.0 ± 1.6% | 859.6 ± 1.2% | 235.5 ± 1.9% | 555.9 ± 1.4% | 242.4 ± 3.4% | 0.770 | 0.875 | 3.192 | 1.352 | 3.101 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1087.5 ± 19.4% | 1143.4 ± 7.5% | 782.8 ± 0.5% | 342.8 ± 0.5% | 349.4 ± 1.3% | 376.4 ± 1.5% | 0.951 | 1.389 | 3.172 | 3.112 | 2.890 |
| qlog records, JSON text sequence | 1467503 | 884.7 ± 1.5% | 983.3 ± 1.1% | 718.3 ± 1.4% | 325.1 ± 1.1% | 371.6 ± 8.6% | 257.9 ± 1.4% | 0.900 | 1.232 | 2.721 | 2.381 | 3.430 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.944 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.882 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.758 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.770 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.875 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.900 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1095.7 ± 0.9% | 0.471 | 1.014 | 1.026 | 1.030 | 0.396 | 1.028 | 1.029 | 0.360 | 0.720 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 842.5 ± 0.5% | 0.784 | 1.041 | 1.033 | 1.020 | 0.397 | 1.020 | 1.019 | 0.363 | 0.709 | 0.126 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1401.9 ± 0.5% | 0.388 | 0.963 | 0.954 | 0.992 | 0.995 | 0.253 | 0.995 | 0.418 | 0.774 | 0.093 | 1.014 |
| qlog records, JSON text sequence | 1467503 | 1134.8 ± 1.6% | 0.695 | 0.961 | 0.998 | 1.008 | 0.993 | 0.233 | 0.994 | 0.388 | 0.811 | 0.118 | 1.058 |

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
| CLDR supplemental, 34 texts | 920675 | 1095.7 ± 0.9% | 1157.5 ± 0.6% | 845.2 ± 0.6% | 268.4 ± 3.2% | 502.6 ± 1.3% | 271.9 ± 5.5% | 0.947 | 1.296 | 4.082 | 2.180 | 4.030 |
| qlog records, JSON text sequence | 1467503 | 842.5 ± 0.5% | 963.9 ± 1.8% | 868.1 ± 6.8% | 234.1 ± 2.4% | 576.3 ± 1.0% | 240.0 ± 1.2% | 0.874 | 0.971 | 3.598 | 1.462 | 3.510 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1401.9 ± 0.5% | 1143.3 ± 1.5% | 783.5 ± 0.9% | 348.2 ± 0.4% | 350.0 ± 2.1% | 375.8 ± 2.1% | 1.226 | 1.789 | 4.026 | 4.005 | 3.731 |
| qlog records, JSON text sequence | 1467503 | 1134.8 ± 1.6% | 977.1 ± 0.9% | 711.3 ± 2.7% | 331.6 ± 3.2% | 331.6 ± 38.1% | 255.6 ± 4.5% | 1.161 | 1.595 | 3.422 | 3.423 | 4.439 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1421.2 ± 0.4% | 1143.3 ± 1.5% | 783.5 ± 0.9% | 348.2 ± 0.4% | 350.0 ± 2.1% | 375.8 ± 2.1% | 1.243 | 1.814 | 4.082 | 4.060 | 3.782 |
| qlog records, JSON text sequence | 1467503 | 1200.6 ± 0.2% | 977.1 ± 0.9% | 711.3 ± 2.7% | 331.6 ± 3.2% | 331.6 ± 38.1% | 255.6 ± 4.5% | 1.229 | 1.688 | 3.620 | 3.621 | 4.697 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 788.9 ± 1.3% | 1157.5 ± 0.6% | 845.2 ± 0.6% | 268.4 ± 3.2% | 502.6 ± 1.3% | 271.9 ± 5.5% | 0.682 | 0.933 | 2.939 | 1.570 | 2.902 |
| qlog records, JSON text sequence | 1467503 | 597.3 ± 2.1% | 963.9 ± 1.8% | 868.1 ± 6.8% | 234.1 ± 2.4% | 576.3 ± 1.0% | 240.0 ± 1.2% | 0.620 | 0.688 | 2.551 | 1.036 | 2.488 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1085.4 ± 4.0% | 1143.3 ± 1.5% | 783.5 ± 0.9% | 348.2 ± 0.4% | 350.0 ± 2.1% | 375.8 ± 2.1% | 0.949 | 1.385 | 3.117 | 3.101 | 2.888 |
| qlog records, JSON text sequence | 1467503 | 920.5 ± 2.4% | 977.1 ± 0.9% | 711.3 ± 2.7% | 331.6 ± 3.2% | 331.6 ± 38.1% | 255.6 ± 4.5% | 0.942 | 1.294 | 2.776 | 2.776 | 3.601 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.947 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.874 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.682 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.933 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.620 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.688 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.949 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.942 of simdjson.

# bench-json, CLDR and qlog alone: null, round 2

| Field | Value |
|---|---|
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1104.4 ± 1.0% | 0.462 | 0.997 | 0.993 | 0.995 | 0.389 | 0.996 | 0.996 | 0.357 | 0.686 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 855.5 ± 1.0% | 0.767 | 1.017 | 0.974 | 0.973 | 0.389 | 0.978 | 0.976 | 0.357 | 0.628 | 0.124 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1411.5 ± 3.5% | 0.394 | 0.955 | 0.963 | 0.990 | 0.991 | 0.259 | 0.992 | 0.426 | 0.773 | 0.089 | 1.010 |
| qlog records, JSON text sequence | 1467503 | 1146.2 ± 1.4% | 0.714 | 0.945 | 0.991 | 1.017 | 0.987 | 0.235 | 0.985 | 0.413 | 0.785 | 0.120 | 1.047 |

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
| CLDR supplemental, 34 texts | 920675 | 1104.4 ± 1.0% | 1147.6 ± 3.6% | 844.6 ± 1.4% | 269.0 ± 0.8% | 503.7 ± 0.6% | 272.0 ± 1.9% | 0.962 | 1.308 | 4.106 | 2.193 | 4.060 |
| qlog records, JSON text sequence | 1467503 | 855.5 ± 1.0% | 966.1 ± 2.7% | 864.8 ± 0.8% | 235.9 ± 0.9% | 577.2 ± 0.8% | 243.6 ± 1.2% | 0.886 | 0.989 | 3.627 | 1.482 | 3.512 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1411.5 ± 3.5% | 1146.4 ± 0.5% | 782.5 ± 1.7% | 342.6 ± 0.7% | 348.2 ± 1.4% | 377.0 ± 1.8% | 1.231 | 1.804 | 4.119 | 4.054 | 3.744 |
| qlog records, JSON text sequence | 1467503 | 1146.2 ± 1.4% | 978.9 ± 17.1% | 711.7 ± 1.5% | 323.6 ± 2.1% | 378.2 ± 26.5% | 256.7 ± 2.2% | 1.171 | 1.610 | 3.542 | 3.031 | 4.465 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1425.1 ± 0.6% | 1146.4 ± 0.5% | 782.5 ± 1.7% | 342.6 ± 0.7% | 348.2 ± 1.4% | 377.0 ± 1.8% | 1.243 | 1.821 | 4.159 | 4.093 | 3.780 |
| qlog records, JSON text sequence | 1467503 | 1199.6 ± 1.4% | 978.9 ± 17.1% | 711.7 ± 1.5% | 323.6 ± 2.1% | 378.2 ± 26.5% | 256.7 ± 2.2% | 1.225 | 1.685 | 3.707 | 3.172 | 4.673 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 757.7 ± 1.1% | 1147.6 ± 3.6% | 844.6 ± 1.4% | 269.0 ± 0.8% | 503.7 ± 0.6% | 272.0 ± 1.9% | 0.660 | 0.897 | 2.817 | 1.504 | 2.785 |
| qlog records, JSON text sequence | 1467503 | 537.1 ± 0.7% | 966.1 ± 2.7% | 864.8 ± 0.8% | 235.9 ± 0.9% | 577.2 ± 0.8% | 243.6 ± 1.2% | 0.556 | 0.621 | 2.277 | 0.930 | 2.205 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1090.4 ± 1.6% | 1146.4 ± 0.5% | 782.5 ± 1.7% | 342.6 ± 0.7% | 348.2 ± 1.4% | 377.0 ± 1.8% | 0.951 | 1.393 | 3.182 | 3.132 | 2.892 |
| qlog records, JSON text sequence | 1467503 | 899.7 ± 55.1% | 978.9 ± 17.1% | 711.7 ± 1.5% | 323.6 ± 2.1% | 378.2 ± 26.5% | 256.7 ± 2.2% | 0.919 | 1.264 | 2.780 | 2.379 | 3.504 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.886 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.660 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.897 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.556 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.621 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.930 of serde_json.

# bench-json, CLDR and qlog alone: head, round 2

| Field | Value |
|---|---|
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1111.9 ± 1.3% | 0.461 | 0.983 | 0.987 | 0.991 | 0.387 | 0.990 | 0.990 | 0.355 | 0.797 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 862.8 ± 0.8% | 0.763 | 1.011 | 0.960 | 0.969 | 0.391 | 0.965 | 0.969 | 0.355 | 0.870 | 0.123 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1403.0 ± 1.5% | 0.392 | 0.963 | 0.964 | 0.993 | 0.995 | 0.260 | 0.997 | 0.419 | 0.769 | 0.088 | 1.019 |
| qlog records, JSON text sequence | 1467503 | 1146.3 ± 2.5% | 0.708 | 0.943 | 0.986 | 1.017 | 0.987 | 0.239 | 0.989 | 0.398 | 0.786 | 0.111 | 1.049 |

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
| CLDR supplemental, 34 texts | 920675 | 1111.9 ± 1.3% | 1152.8 ± 1.9% | 845.3 ± 0.4% | 270.0 ± 1.1% | 502.4 ± 0.7% | 272.4 ± 2.3% | 0.964 | 1.315 | 4.118 | 2.213 | 4.082 |
| qlog records, JSON text sequence | 1467503 | 862.8 ± 0.8% | 968.9 ± 1.3% | 861.4 ± 3.4% | 235.5 ± 0.5% | 558.0 ± 1.4% | 242.1 ± 0.8% | 0.891 | 1.002 | 3.663 | 1.546 | 3.564 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1403.0 ± 1.5% | 1139.7 ± 0.5% | 780.1 ± 0.5% | 342.4 ± 0.6% | 347.5 ± 0.6% | 373.9 ± 1.6% | 1.231 | 1.799 | 4.098 | 4.037 | 3.752 |
| qlog records, JSON text sequence | 1467503 | 1146.3 ± 2.5% | 980.9 ± 1.9% | 708.6 ± 2.6% | 323.2 ± 3.3% | 346.3 ± 52.3% | 254.9 ± 6.9% | 1.169 | 1.618 | 3.547 | 3.310 | 4.497 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1429.4 ± 0.3% | 1139.7 ± 0.5% | 780.1 ± 0.5% | 342.4 ± 0.6% | 347.5 ± 0.6% | 373.9 ± 1.6% | 1.254 | 1.832 | 4.175 | 4.113 | 3.823 |
| qlog records, JSON text sequence | 1467503 | 1202.1 ± 3.8% | 980.9 ± 1.9% | 708.6 ± 2.6% | 323.2 ± 3.3% | 346.3 ± 52.3% | 254.9 ± 6.9% | 1.225 | 1.696 | 3.719 | 3.471 | 4.716 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 886.7 ± 0.6% | 1152.8 ± 1.9% | 845.3 ± 0.4% | 270.0 ± 1.1% | 502.4 ± 0.7% | 272.4 ± 2.3% | 0.769 | 1.049 | 3.284 | 1.765 | 3.256 |
| qlog records, JSON text sequence | 1467503 | 750.9 ± 0.7% | 968.9 ± 1.3% | 861.4 ± 3.4% | 235.5 ± 0.5% | 558.0 ± 1.4% | 242.1 ± 0.8% | 0.775 | 0.872 | 3.188 | 1.346 | 3.102 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1079.4 ± 7.5% | 1139.7 ± 0.5% | 780.1 ± 0.5% | 342.4 ± 0.6% | 347.5 ± 0.6% | 373.9 ± 1.6% | 0.947 | 1.384 | 3.152 | 3.106 | 2.887 |
| qlog records, JSON text sequence | 1467503 | 901.4 ± 1.9% | 980.9 ± 1.9% | 708.6 ± 2.6% | 323.2 ± 3.3% | 346.3 ± 52.3% | 254.9 ± 6.9% | 0.919 | 1.272 | 2.789 | 2.603 | 3.536 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.891 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.769 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.775 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.872 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.919 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1099.5 ± 1.4% | 0.470 | 1.009 | 1.024 | 1.026 | 0.394 | 1.026 | 1.025 | 0.359 | 0.717 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 841.6 ± 1.4% | 0.778 | 1.039 | 1.030 | 1.025 | 0.397 | 1.020 | 1.022 | 0.364 | 0.709 | 0.126 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1404.3 ± 1.9% | 0.385 | 0.968 | 0.958 | 0.995 | 0.998 | 0.256 | 1.001 | 0.427 | 0.771 | 0.094 | 1.015 |
| qlog records, JSON text sequence | 1467503 | 1142.9 ± 0.6% | 0.694 | 0.958 | 0.992 | 1.013 | 0.997 | 0.255 | 1.000 | 0.423 | 0.786 | 0.127 | 1.056 |

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
| CLDR supplemental, 34 texts | 920675 | 1099.5 ± 1.4% | 1165.8 ± 1.9% | 846.6 ± 0.5% | 269.3 ± 0.6% | 502.2 ± 1.2% | 270.8 ± 3.4% | 0.943 | 1.299 | 4.083 | 2.189 | 4.061 |
| qlog records, JSON text sequence | 1467503 | 841.6 ± 1.4% | 965.7 ± 0.9% | 866.4 ± 0.5% | 235.4 ± 1.3% | 577.5 ± 0.8% | 239.8 ± 0.7% | 0.872 | 0.971 | 3.575 | 1.457 | 3.509 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1404.3 ± 1.9% | 1144.8 ± 0.4% | 783.6 ± 2.2% | 349.9 ± 0.7% | 351.6 ± 1.4% | 375.8 ± 1.4% | 1.227 | 1.792 | 4.014 | 3.994 | 3.737 |
| qlog records, JSON text sequence | 1467503 | 1142.9 ± 0.6% | 983.7 ± 1.4% | 722.0 ± 1.6% | 332.5 ± 0.7% | 383.1 ± 3.1% | 263.3 ± 1.1% | 1.162 | 1.583 | 3.437 | 2.983 | 4.341 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1425.1 ± 0.4% | 1144.8 ± 0.4% | 783.6 ± 2.2% | 349.9 ± 0.7% | 351.6 ± 1.4% | 375.8 ± 1.4% | 1.245 | 1.819 | 4.073 | 4.053 | 3.792 |
| qlog records, JSON text sequence | 1467503 | 1207.4 ± 0.6% | 983.7 ± 1.4% | 722.0 ± 1.6% | 332.5 ± 0.7% | 383.1 ± 3.1% | 263.3 ± 1.1% | 1.227 | 1.672 | 3.631 | 3.152 | 4.586 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 788.1 ± 0.5% | 1165.8 ± 1.9% | 846.6 ± 0.5% | 269.3 ± 0.6% | 502.2 ± 1.2% | 270.8 ± 3.4% | 0.676 | 0.931 | 2.927 | 1.569 | 2.911 |
| qlog records, JSON text sequence | 1467503 | 596.4 ± 2.6% | 965.7 ± 0.9% | 866.4 ± 0.5% | 235.4 ± 1.3% | 577.5 ± 0.8% | 239.8 ± 0.7% | 0.618 | 0.688 | 2.534 | 1.033 | 2.487 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1082.6 ± 4.7% | 1144.8 ± 0.4% | 783.6 ± 2.2% | 349.9 ± 0.7% | 351.6 ± 1.4% | 375.8 ± 1.4% | 0.946 | 1.382 | 3.094 | 3.079 | 2.881 |
| qlog records, JSON text sequence | 1467503 | 898.7 ± 4.7% | 983.7 ± 1.4% | 722.0 ± 1.6% | 332.5 ± 0.7% | 383.1 ± 3.1% | 263.3 ± 1.1% | 0.914 | 1.245 | 2.703 | 2.346 | 3.413 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.943 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.872 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.676 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.931 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.618 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.688 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.946 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.914 of simdjson.

# bench-json, CLDR and qlog alone: null, round 3

| Field | Value |
|---|---|
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1100.5 ± 0.9% | 0.464 | 1.005 | 0.997 | 0.999 | 0.391 | 1.000 | 0.997 | 0.358 | 0.687 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 857.0 ± 0.5% | 0.769 | 1.014 | 0.972 | 0.975 | 0.390 | 0.979 | 0.979 | 0.357 | 0.633 | 0.124 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1412.8 ± 0.6% | 0.386 | 0.953 | 0.963 | 0.990 | 0.990 | 0.258 | 0.988 | 0.437 | 0.775 | 0.089 | 1.009 |
| qlog records, JSON text sequence | 1467503 | 1144.9 ± 36.8% | 0.711 | 0.947 | 0.994 | 1.019 | 0.987 | 0.266 | 0.987 | 0.485 | 0.801 | 0.124 | 1.048 |

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
| CLDR supplemental, 34 texts | 920675 | 1100.5 ± 0.9% | 1177.8 ± 0.6% | 847.3 ± 0.4% | 267.8 ± 1.1% | 503.0 ± 4.9% | 272.3 ± 2.2% | 0.934 | 1.299 | 4.109 | 2.188 | 4.042 |
| qlog records, JSON text sequence | 1467503 | 857.0 ± 0.5% | 973.8 ± 2.9% | 863.9 ± 1.3% | 235.4 ± 0.8% | 575.7 ± 1.1% | 241.9 ± 1.9% | 0.880 | 0.992 | 3.640 | 1.489 | 3.543 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1412.8 ± 0.6% | 1149.3 ± 0.5% | 782.5 ± 0.4% | 341.5 ± 0.7% | 349.8 ± 2.0% | 375.8 ± 3.4% | 1.229 | 1.805 | 4.137 | 4.039 | 3.759 |
| qlog records, JSON text sequence | 1467503 | 1144.9 ± 36.8% | 972.1 ± 3.3% | 715.2 ± 6.4% | 325.7 ± 11.8% | 379.9 ± 46.7% | 256.8 ± 78.9% | 1.178 | 1.601 | 3.515 | 3.014 | 4.458 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1425.4 ± 0.5% | 1149.3 ± 0.5% | 782.5 ± 0.4% | 341.5 ± 0.7% | 349.8 ± 2.0% | 375.8 ± 3.4% | 1.240 | 1.821 | 4.174 | 4.075 | 3.792 |
| qlog records, JSON text sequence | 1467503 | 1199.9 ± 3.1% | 972.1 ± 3.3% | 715.2 ± 6.4% | 325.7 ± 11.8% | 379.9 ± 46.7% | 256.8 ± 78.9% | 1.234 | 1.678 | 3.684 | 3.159 | 4.672 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 756.5 ± 1.4% | 1177.8 ± 0.6% | 847.3 ± 0.4% | 267.8 ± 1.1% | 503.0 ± 4.9% | 272.3 ± 2.2% | 0.642 | 0.893 | 2.824 | 1.504 | 2.779 |
| qlog records, JSON text sequence | 1467503 | 542.3 ± 1.7% | 973.8 ± 2.9% | 863.9 ± 1.3% | 235.4 ± 0.8% | 575.7 ± 1.1% | 241.9 ± 1.9% | 0.557 | 0.628 | 2.303 | 0.942 | 2.242 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1094.4 ± 1.2% | 1149.3 ± 0.5% | 782.5 ± 0.4% | 341.5 ± 0.7% | 349.8 ± 2.0% | 375.8 ± 3.4% | 0.952 | 1.399 | 3.205 | 3.129 | 2.912 |
| qlog records, JSON text sequence | 1467503 | 917.6 ± 2.3% | 972.1 ± 3.3% | 715.2 ± 6.4% | 325.7 ± 11.8% | 379.9 ± 46.7% | 256.8 ± 78.9% | 0.944 | 1.283 | 2.817 | 2.415 | 3.573 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.934 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.880 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.642 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.893 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.557 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.628 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.942 of serde_json.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.944 of simdjson.

# bench-json, CLDR and qlog alone: head, round 3

| Field | Value |
|---|---|
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1109.7 ± 0.9% | 0.461 | 0.979 | 0.983 | 0.992 | 0.387 | 0.992 | 0.991 | 0.355 | 0.797 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 859.3 ± 1.4% | 0.770 | 1.006 | 0.958 | 0.967 | 0.393 | 0.965 | 0.968 | 0.354 | 0.875 | 0.124 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1415.1 ± 0.9% | 0.413 | 0.958 | 0.958 | 0.985 | 0.991 | 0.275 | 0.991 | 0.479 | 0.779 | 0.092 | 1.012 |
| qlog records, JSON text sequence | 1467503 | 1152.2 ± 2.1% | 0.712 | 0.944 | 0.988 | 1.017 | 0.987 | 0.280 | 0.989 | 0.472 | 0.802 | 0.127 | 1.044 |

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
| CLDR supplemental, 34 texts | 920675 | 1109.7 ± 0.9% | 1165.5 ± 4.0% | 847.6 ± 1.0% | 270.7 ± 1.0% | 501.3 ± 1.0% | 275.1 ± 3.6% | 0.952 | 1.309 | 4.099 | 2.214 | 4.034 |
| qlog records, JSON text sequence | 1467503 | 859.3 ± 1.4% | 981.1 ± 3.0% | 860.5 ± 4.4% | 234.6 ± 1.1% | 555.4 ± 0.5% | 242.5 ± 1.5% | 0.876 | 0.999 | 3.662 | 1.547 | 3.544 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1415.1 ± 0.9% | 1145.0 ± 0.6% | 784.6 ± 1.7% | 344.1 ± 1.4% | 356.7 ± 0.4% | 383.5 ± 2.2% | 1.236 | 1.804 | 4.112 | 3.967 | 3.690 |
| qlog records, JSON text sequence | 1467503 | 1152.2 ± 2.1% | 976.2 ± 1.8% | 716.6 ± 2.1% | 326.3 ± 1.1% | 382.6 ± 8.4% | 260.9 ± 3.3% | 1.180 | 1.608 | 3.532 | 3.012 | 4.416 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1431.5 ± 0.9% | 1145.0 ± 0.6% | 784.6 ± 1.7% | 344.1 ± 1.4% | 356.7 ± 0.4% | 383.5 ± 2.2% | 1.250 | 1.825 | 4.160 | 4.013 | 3.733 |
| qlog records, JSON text sequence | 1467503 | 1203.0 ± 1.2% | 976.2 ± 1.8% | 716.6 ± 2.1% | 326.3 ± 1.1% | 382.6 ± 8.4% | 260.9 ± 3.3% | 1.232 | 1.679 | 3.687 | 3.144 | 4.611 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 884.9 ± 1.0% | 1165.5 ± 4.0% | 847.6 ± 1.0% | 270.7 ± 1.0% | 501.3 ± 1.0% | 275.1 ± 3.6% | 0.759 | 1.044 | 3.268 | 1.765 | 3.217 |
| qlog records, JSON text sequence | 1467503 | 751.9 ± 2.9% | 981.1 ± 3.0% | 860.5 ± 4.4% | 234.6 ± 1.1% | 555.4 ± 0.5% | 242.5 ± 1.5% | 0.766 | 0.874 | 3.204 | 1.354 | 3.101 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1102.8 ± 0.9% | 1145.0 ± 0.6% | 784.6 ± 1.7% | 344.1 ± 1.4% | 356.7 ± 0.4% | 383.5 ± 2.2% | 0.963 | 1.406 | 3.205 | 3.091 | 2.876 |
| qlog records, JSON text sequence | 1467503 | 923.6 ± 5.4% | 976.2 ± 1.8% | 716.6 ± 2.1% | 326.3 ± 1.1% | 382.6 ± 8.4% | 260.9 ± 3.3% | 0.946 | 1.289 | 2.831 | 2.414 | 3.540 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.876 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.759 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.766 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.874 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.946 of simdjson.
