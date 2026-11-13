# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1424.5 ± 17.2% | 0.475 | 1.009 | 1.029 | 1.027 | 0.397 | 1.028 | 1.027 | 0.358 | 0.714 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1125.9 ± 0.8% | 0.765 | 1.053 | 1.023 | 1.030 | 0.381 | 1.023 | 1.029 | 0.356 | 0.680 | 0.122 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1729.2 ± 1.0% | 0.429 | 1.003 | 0.961 | 0.995 | 1.000 | 0.271 | 1.010 | 0.515 | 0.823 | 0.094 | 1.028 |
| qlog records, JSON text sequence | 1467503 | 1579.2 ± 19.7% | 0.670 | 0.999 | 1.021 | 1.048 | 1.027 | 0.248 | 1.025 | 0.459 | 0.774 | 0.112 | 1.085 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.053 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1424.5 ± 17.2% | 1475.3 ± 1.6% | 1087.3 ± 0.5% | 362.4 ± 1.4% | 671.7 ± 0.3% | 364.2 ± 1.5% | 0.966 | 1.310 | 3.931 | 2.121 | 3.911 |
| qlog records, JSON text sequence | 1467503 | 1125.9 ± 0.8% | 1213.5 ± 1.5% | 1119.5 ± 1.5% | 308.6 ± 0.9% | 743.2 ± 0.8% | 305.9 ± 1.4% | 0.928 | 1.006 | 3.648 | 1.515 | 3.680 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1729.2 ± 1.0% | 1478.7 ± 0.6% | 1017.4 ± 0.0% | 469.7 ± 0.3% | 487.8 ± 0.4% | 498.3 ± 6.5% | 1.169 | 1.700 | 3.682 | 3.544 | 3.470 |
| qlog records, JSON text sequence | 1467503 | 1579.2 ± 19.7% | 1200.1 ± 1.8% | 929.9 ± 3.4% | 446.7 ± 1.1% | 560.7 ± 1.8% | 352.0 ± 1.4% | 1.316 | 1.698 | 3.535 | 2.817 | 4.487 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1777.1 ± 0.9% | 1478.7 ± 0.6% | 1017.4 ± 0.0% | 469.7 ± 0.3% | 487.8 ± 0.4% | 498.3 ± 6.5% | 1.202 | 1.747 | 3.784 | 3.643 | 3.566 |
| qlog records, JSON text sequence | 1467503 | 1713.7 ± 0.0% | 1200.1 ± 1.8% | 929.9 ± 3.4% | 446.7 ± 1.1% | 560.7 ± 1.8% | 352.0 ± 1.4% | 1.428 | 1.843 | 3.836 | 3.057 | 4.869 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1017.2 ± 0.3% | 1475.3 ± 1.6% | 1087.3 ± 0.5% | 362.4 ± 1.4% | 671.7 ± 0.3% | 364.2 ± 1.5% | 0.689 | 0.936 | 2.807 | 1.514 | 2.793 |
| qlog records, JSON text sequence | 1467503 | 765.7 ± 1.1% | 1213.5 ± 1.5% | 1119.5 ± 1.5% | 308.6 ± 0.9% | 743.2 ± 0.8% | 305.9 ± 1.4% | 0.631 | 0.684 | 2.481 | 1.030 | 2.503 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1423.9 ± 0.4% | 1478.7 ± 0.6% | 1017.4 ± 0.0% | 469.7 ± 0.3% | 487.8 ± 0.4% | 498.3 ± 6.5% | 0.963 | 1.399 | 3.032 | 2.919 | 2.857 |
| qlog records, JSON text sequence | 1467503 | 1222.4 ± 0.4% | 1200.1 ± 1.8% | 929.9 ± 3.4% | 446.7 ± 1.1% | 560.7 ± 1.8% | 352.0 ± 1.4% | 1.019 | 1.315 | 2.737 | 2.180 | 3.473 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.928 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.689 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.936 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.631 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.684 of yyjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1435.6 ± 33.9% | 0.467 | 0.985 | 0.994 | 0.997 | 0.373 | 0.999 | 0.998 | 0.356 | 0.782 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1157.4 ± 0.6% | 0.730 | 1.008 | 0.965 | 0.960 | 0.356 | 0.963 | 0.960 | 0.346 | 0.851 | 0.120 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1741.9 ± 0.6% | 0.434 | 0.974 | 0.962 | 0.993 | 0.993 | 0.277 | 0.997 | 0.513 | 0.822 | 0.091 | 1.026 |
| qlog records, JSON text sequence | 1467503 | 1536.1 ± 19.8% | 0.725 | 0.978 | 1.055 | 1.081 | 1.049 | 0.267 | 1.050 | 0.475 | 0.796 | 0.109 | 1.117 |

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
| CLDR supplemental, 34 texts | 920675 | 1435.6 ± 33.9% | 1505.9 ± 49.1% | 1085.7 ± 55.7% | 360.5 ± 40.4% | 670.0 ± 53.3% | 367.3 ± 65.8% | 0.953 | 1.322 | 3.982 | 2.143 | 3.908 |
| qlog records, JSON text sequence | 1467503 | 1157.4 ± 0.6% | 1221.5 ± 0.9% | 1086.9 ± 1.4% | 307.1 ± 1.2% | 720.7 ± 1.0% | 319.1 ± 1.0% | 0.948 | 1.065 | 3.769 | 1.606 | 3.627 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1741.9 ± 0.6% | 1483.6 ± 1.0% | 1017.0 ± 2.3% | 465.5 ± 0.2% | 487.5 ± 0.6% | 496.8 ± 2.0% | 1.174 | 1.713 | 3.742 | 3.573 | 3.506 |
| qlog records, JSON text sequence | 1467503 | 1536.1 ± 19.8% | 1197.9 ± 2.7% | 908.5 ± 3.2% | 437.6 ± 0.7% | 572.4 ± 0.7% | 352.3 ± 0.8% | 1.282 | 1.691 | 3.510 | 2.684 | 4.360 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1787.9 ± 0.5% | 1483.6 ± 1.0% | 1017.0 ± 2.3% | 465.5 ± 0.2% | 487.5 ± 0.6% | 496.8 ± 2.0% | 1.205 | 1.758 | 3.840 | 3.667 | 3.599 |
| qlog records, JSON text sequence | 1467503 | 1715.9 ± 2.0% | 1197.9 ± 2.7% | 908.5 ± 3.2% | 437.6 ± 0.7% | 572.4 ± 0.7% | 352.3 ± 0.8% | 1.432 | 1.889 | 3.921 | 2.998 | 4.871 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1122.8 ± 55.1% | 1505.9 ± 49.1% | 1085.7 ± 55.7% | 360.5 ± 40.4% | 670.0 ± 53.3% | 367.3 ± 65.8% | 0.746 | 1.034 | 3.115 | 1.676 | 3.057 |
| qlog records, JSON text sequence | 1467503 | 984.7 ± 2.1% | 1221.5 ± 0.9% | 1086.9 ± 1.4% | 307.1 ± 1.2% | 720.7 ± 1.0% | 319.1 ± 1.0% | 0.806 | 0.906 | 3.207 | 1.366 | 3.086 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1432.2 ± 0.8% | 1483.6 ± 1.0% | 1017.0 ± 2.3% | 465.5 ± 0.2% | 487.5 ± 0.6% | 496.8 ± 2.0% | 0.965 | 1.408 | 3.076 | 2.938 | 2.883 |
| qlog records, JSON text sequence | 1467503 | 1222.5 ± 1.1% | 1197.9 ± 2.7% | 908.5 ± 3.2% | 437.6 ± 0.7% | 572.4 ± 0.7% | 352.3 ± 0.8% | 1.021 | 1.346 | 2.794 | 2.136 | 3.470 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.948 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.806 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.906 of yyjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1423.2 ± 33.9% | 0.471 | 0.995 | 0.996 | 0.998 | 0.395 | 1.001 | 1.000 | 0.359 | 0.806 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1154.8 ± 0.9% | 0.730 | 1.010 | 0.965 | 0.963 | 0.377 | 0.968 | 0.962 | 0.347 | 0.867 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1738.5 ± 1.0% | 0.435 | 0.973 | 0.973 | 0.997 | 0.997 | 0.276 | 1.003 | 0.513 | 0.824 | 0.091 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1567.1 ± 19.8% | 0.713 | 0.960 | 1.034 | 1.062 | 1.027 | 0.261 | 1.030 | 0.457 | 0.785 | 0.108 | 1.093 |

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
| CLDR supplemental, 34 texts | 920675 | 1423.2 ± 33.9% | 1515.5 ± 2.1% | 1116.9 ± 0.5% | 360.7 ± 14.4% | 669.8 ± 53.3% | 367.2 ± 68.0% | 0.939 | 1.274 | 3.946 | 2.125 | 3.876 |
| qlog records, JSON text sequence | 1467503 | 1154.8 ± 0.9% | 1224.3 ± 1.1% | 1090.5 ± 0.9% | 307.8 ± 1.1% | 719.3 ± 1.7% | 319.1 ± 1.3% | 0.943 | 1.059 | 3.752 | 1.605 | 3.619 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1738.5 ± 1.0% | 1481.8 ± 0.7% | 1017.0 ± 0.5% | 465.2 ± 0.3% | 486.3 ± 0.6% | 502.1 ± 3.4% | 1.173 | 1.709 | 3.737 | 3.575 | 3.463 |
| qlog records, JSON text sequence | 1467503 | 1567.1 ± 19.8% | 1208.5 ± 2.6% | 908.8 ± 2.0% | 438.5 ± 1.0% | 574.1 ± 0.1% | 352.2 ± 1.5% | 1.297 | 1.724 | 3.574 | 2.730 | 4.450 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1786.1 ± 0.6% | 1481.8 ± 0.7% | 1017.0 ± 0.5% | 465.2 ± 0.3% | 486.3 ± 0.6% | 502.1 ± 3.4% | 1.205 | 1.756 | 3.839 | 3.673 | 3.557 |
| qlog records, JSON text sequence | 1467503 | 1713.0 ± 0.4% | 1208.5 ± 2.6% | 908.8 ± 2.0% | 438.5 ± 1.0% | 574.1 ± 0.1% | 352.2 ± 1.5% | 1.417 | 1.885 | 3.906 | 2.984 | 4.864 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1147.3 ± 0.2% | 1515.5 ± 2.1% | 1116.9 ± 0.5% | 360.7 ± 14.4% | 669.8 ± 53.3% | 367.2 ± 68.0% | 0.757 | 1.027 | 3.181 | 1.713 | 3.125 |
| qlog records, JSON text sequence | 1467503 | 1001.3 ± 0.6% | 1224.3 ± 1.1% | 1090.5 ± 0.9% | 307.8 ± 1.1% | 719.3 ± 1.7% | 319.1 ± 1.3% | 0.818 | 0.918 | 3.253 | 1.392 | 3.138 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1431.9 ± 0.2% | 1481.8 ± 0.7% | 1017.0 ± 0.5% | 465.2 ± 0.3% | 486.3 ± 0.6% | 502.1 ± 3.4% | 0.966 | 1.408 | 3.078 | 2.945 | 2.852 |
| qlog records, JSON text sequence | 1467503 | 1229.4 ± 1.9% | 1208.5 ± 2.6% | 908.8 ± 2.0% | 438.5 ± 1.0% | 574.1 ± 0.1% | 352.2 ± 1.5% | 1.017 | 1.353 | 2.803 | 2.141 | 3.491 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.943 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.757 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.818 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.918 of yyjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1426.7 ± 0.6% | 0.474 | 1.007 | 1.024 | 1.026 | 0.397 | 1.023 | 1.027 | 0.358 | 0.713 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1129.0 ± 1.1% | 0.761 | 1.057 | 1.024 | 1.028 | 0.381 | 1.021 | 1.028 | 0.355 | 0.677 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1727.7 ± 0.9% | 0.429 | 1.003 | 0.965 | 1.004 | 1.015 | 0.271 | 1.016 | 0.515 | 0.826 | 0.095 | 1.029 |
| qlog records, JSON text sequence | 1467503 | 1632.4 ± 18.0% | 0.649 | 0.967 | 0.987 | 1.011 | 0.995 | 0.240 | 0.994 | 0.444 | 0.750 | 0.108 | 1.049 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.057 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1426.7 ± 0.6% | 1493.1 ± 0.9% | 1087.6 ± 0.4% | 361.4 ± 0.6% | 671.7 ± 0.2% | 365.2 ± 1.8% | 0.956 | 1.312 | 3.948 | 2.124 | 3.907 |
| qlog records, JSON text sequence | 1467503 | 1129.0 ± 1.1% | 1236.2 ± 1.4% | 1119.3 ± 0.7% | 309.3 ± 1.1% | 741.7 ± 1.3% | 315.3 ± 0.9% | 0.913 | 1.009 | 3.651 | 1.522 | 3.581 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1727.7 ± 0.9% | 1478.7 ± 0.6% | 1017.1 ± 0.2% | 468.5 ± 0.4% | 484.8 ± 1.1% | 498.4 ± 0.4% | 1.168 | 1.699 | 3.688 | 3.564 | 3.467 |
| qlog records, JSON text sequence | 1467503 | 1632.4 ± 18.0% | 1191.9 ± 1.7% | 934.5 ± 1.0% | 446.7 ± 2.3% | 565.1 ± 0.5% | 351.7 ± 1.6% | 1.370 | 1.747 | 3.655 | 2.889 | 4.641 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1778.6 ± 0.3% | 1478.7 ± 0.6% | 1017.1 ± 0.2% | 468.5 ± 0.4% | 484.8 ± 1.1% | 498.4 ± 0.4% | 1.203 | 1.749 | 3.796 | 3.669 | 3.569 |
| qlog records, JSON text sequence | 1467503 | 1712.7 ± 0.5% | 1191.9 ± 1.7% | 934.5 ± 1.0% | 446.7 ± 2.3% | 565.1 ± 0.5% | 351.7 ± 1.6% | 1.437 | 1.833 | 3.834 | 3.031 | 4.869 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1016.5 ± 0.3% | 1493.1 ± 0.9% | 1087.6 ± 0.4% | 361.4 ± 0.6% | 671.7 ± 0.2% | 365.2 ± 1.8% | 0.681 | 0.935 | 2.813 | 1.513 | 2.784 |
| qlog records, JSON text sequence | 1467503 | 764.6 ± 1.5% | 1236.2 ± 1.4% | 1119.3 ± 0.7% | 309.3 ± 1.1% | 741.7 ± 1.3% | 315.3 ± 0.9% | 0.618 | 0.683 | 2.472 | 1.031 | 2.425 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1426.8 ± 1.5% | 1478.7 ± 0.6% | 1017.1 ± 0.2% | 468.5 ± 0.4% | 484.8 ± 1.1% | 498.4 ± 0.4% | 0.965 | 1.403 | 3.046 | 2.943 | 2.863 |
| qlog records, JSON text sequence | 1467503 | 1224.6 ± 0.5% | 1191.9 ± 1.7% | 934.5 ± 1.0% | 446.7 ± 2.3% | 565.1 ± 0.5% | 351.7 ± 1.6% | 1.027 | 1.310 | 2.742 | 2.167 | 3.482 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.913 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.681 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.935 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.618 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.683 of yyjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1434.6 ± 0.7% | 0.468 | 0.994 | 0.996 | 0.998 | 0.392 | 1.000 | 0.999 | 0.356 | 0.784 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1160.8 ± 0.8% | 0.730 | 1.004 | 0.962 | 0.958 | 0.375 | 0.963 | 0.959 | 0.345 | 0.849 | 0.120 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1739.1 ± 2.2% | 0.435 | 0.977 | 0.972 | 0.997 | 0.992 | 0.277 | 1.005 | 0.514 | 0.823 | 0.092 | 1.031 |
| qlog records, JSON text sequence | 1467503 | 1580.9 ± 14.3% | 0.708 | 0.952 | 1.032 | 1.049 | 1.021 | 0.260 | 1.024 | 0.462 | 0.779 | 0.107 | 1.086 |

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
| CLDR supplemental, 34 texts | 920675 | 1434.6 ± 0.7% | 1523.8 ± 1.9% | 1114.1 ± 0.5% | 361.3 ± 0.8% | 669.6 ± 0.6% | 368.3 ± 2.7% | 0.941 | 1.288 | 3.970 | 2.142 | 3.896 |
| qlog records, JSON text sequence | 1467503 | 1160.8 ± 0.8% | 1226.0 ± 0.6% | 1088.3 ± 0.7% | 305.2 ± 1.5% | 726.9 ± 1.5% | 318.3 ± 1.8% | 0.947 | 1.067 | 3.803 | 1.597 | 3.647 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1739.1 ± 2.2% | 1482.9 ± 0.6% | 1017.4 ± 0.5% | 466.5 ± 0.3% | 485.8 ± 0.5% | 501.9 ± 0.7% | 1.173 | 1.709 | 3.728 | 3.580 | 3.465 |
| qlog records, JSON text sequence | 1467503 | 1580.9 ± 14.3% | 1208.5 ± 2.1% | 919.1 ± 2.9% | 439.4 ± 0.8% | 572.6 ± 2.2% | 353.5 ± 0.4% | 1.308 | 1.720 | 3.597 | 2.761 | 4.472 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1792.4 ± 0.1% | 1482.9 ± 0.6% | 1017.4 ± 0.5% | 466.5 ± 0.3% | 485.8 ± 0.5% | 501.9 ± 0.7% | 1.209 | 1.762 | 3.842 | 3.690 | 3.571 |
| qlog records, JSON text sequence | 1467503 | 1716.7 ± 0.3% | 1208.5 ± 2.1% | 919.1 ± 2.9% | 439.4 ± 0.8% | 572.6 ± 2.2% | 353.5 ± 0.4% | 1.420 | 1.868 | 3.907 | 2.998 | 4.856 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1124.6 ± 0.5% | 1523.8 ± 1.9% | 1114.1 ± 0.5% | 361.3 ± 0.8% | 669.6 ± 0.6% | 368.3 ± 2.7% | 0.738 | 1.009 | 3.112 | 1.679 | 3.054 |
| qlog records, JSON text sequence | 1467503 | 985.3 ± 0.7% | 1226.0 ± 0.6% | 1088.3 ± 0.7% | 305.2 ± 1.5% | 726.9 ± 1.5% | 318.3 ± 1.8% | 0.804 | 0.905 | 3.228 | 1.355 | 3.095 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1431.9 ± 0.1% | 1482.9 ± 0.6% | 1017.4 ± 0.5% | 466.5 ± 0.3% | 485.8 ± 0.5% | 501.9 ± 0.7% | 0.966 | 1.407 | 3.069 | 2.948 | 2.853 |
| qlog records, JSON text sequence | 1467503 | 1231.1 ± 0.5% | 1208.5 ± 2.1% | 919.1 ± 2.9% | 439.4 ± 0.8% | 572.6 ± 2.2% | 353.5 ± 0.4% | 1.019 | 1.339 | 2.801 | 2.150 | 3.482 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.941 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.947 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.738 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.804 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.905 of yyjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1434.1 ± 0.4% | 0.468 | 0.996 | 0.996 | 0.998 | 0.392 | 1.002 | 0.999 | 0.356 | 0.798 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1155.8 ± 0.8% | 0.730 | 1.009 | 0.966 | 0.963 | 0.377 | 0.969 | 0.964 | 0.347 | 0.865 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1742.0 ± 1.0% | 0.434 | 0.974 | 0.971 | 1.000 | 1.001 | 0.277 | 1.001 | 0.513 | 0.823 | 0.091 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1617.7 ± 8.5% | 0.692 | 0.931 | 1.006 | 1.029 | 0.996 | 0.254 | 0.997 | 0.451 | 0.760 | 0.104 | 1.060 |

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
| CLDR supplemental, 34 texts | 920675 | 1434.1 ± 0.4% | 1511.8 ± 1.0% | 1113.8 ± 0.4% | 360.4 ± 1.1% | 670.4 ± 0.3% | 366.6 ± 1.4% | 0.949 | 1.288 | 3.980 | 2.139 | 3.912 |
| qlog records, JSON text sequence | 1467503 | 1155.8 ± 0.8% | 1225.1 ± 1.4% | 1082.6 ± 0.6% | 307.9 ± 1.2% | 725.9 ± 1.2% | 318.2 ± 1.9% | 0.943 | 1.068 | 3.754 | 1.592 | 3.633 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1742.0 ± 1.0% | 1482.3 ± 0.2% | 1018.4 ± 0.2% | 467.2 ± 0.2% | 485.7 ± 1.6% | 500.0 ± 0.9% | 1.175 | 1.711 | 3.728 | 3.587 | 3.484 |
| qlog records, JSON text sequence | 1467503 | 1617.7 ± 8.5% | 1198.4 ± 1.9% | 930.2 ± 4.2% | 438.1 ± 1.7% | 573.8 ± 0.8% | 352.2 ± 0.9% | 1.350 | 1.739 | 3.693 | 2.819 | 4.593 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1789.2 ± 0.2% | 1482.3 ± 0.2% | 1018.4 ± 0.2% | 467.2 ± 0.2% | 485.7 ± 1.6% | 500.0 ± 0.9% | 1.207 | 1.757 | 3.829 | 3.684 | 3.578 |
| qlog records, JSON text sequence | 1467503 | 1714.9 ± 20.3% | 1198.4 ± 1.9% | 930.2 ± 4.2% | 438.1 ± 1.7% | 573.8 ± 0.8% | 352.2 ± 0.9% | 1.431 | 1.844 | 3.915 | 2.989 | 4.868 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1144.7 ± 0.5% | 1511.8 ± 1.0% | 1113.8 ± 0.4% | 360.4 ± 1.1% | 670.4 ± 0.3% | 366.6 ± 1.4% | 0.757 | 1.028 | 3.176 | 1.708 | 3.122 |
| qlog records, JSON text sequence | 1467503 | 999.3 ± 0.8% | 1225.1 ± 1.4% | 1082.6 ± 0.6% | 307.9 ± 1.2% | 725.9 ± 1.2% | 318.2 ± 1.9% | 0.816 | 0.923 | 3.245 | 1.377 | 3.141 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1432.9 ± 1.4% | 1482.3 ± 0.2% | 1018.4 ± 0.2% | 467.2 ± 0.2% | 485.7 ± 1.6% | 500.0 ± 0.9% | 0.967 | 1.407 | 3.067 | 2.950 | 2.866 |
| qlog records, JSON text sequence | 1467503 | 1229.2 ± 0.6% | 1198.4 ± 1.9% | 930.2 ± 4.2% | 438.1 ± 1.7% | 573.8 ± 0.8% | 352.2 ± 0.9% | 1.026 | 1.321 | 2.806 | 2.142 | 3.490 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.949 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.943 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.757 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.816 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.923 of yyjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1427.4 ± 1.0% | 0.474 | 1.007 | 1.025 | 1.025 | 0.398 | 1.025 | 1.023 | 0.357 | 0.712 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1130.6 ± 0.3% | 0.764 | 1.051 | 1.022 | 1.027 | 0.380 | 1.018 | 1.028 | 0.355 | 0.681 | 0.122 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1731.5 ± 0.6% | 0.429 | 1.002 | 0.964 | 1.004 | 1.008 | 0.270 | 1.013 | 0.514 | 0.824 | 0.095 | 1.030 |
| qlog records, JSON text sequence | 1467503 | 1527.9 ± 12.7% | 0.693 | 1.036 | 1.056 | 1.081 | 1.064 | 0.256 | 1.063 | 0.474 | 0.802 | 0.116 | 1.122 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.051 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1427.4 ± 1.0% | 1508.3 ± 0.7% | 1116.1 ± 0.2% | 361.1 ± 0.8% | 671.2 ± 1.0% | 365.6 ± 1.9% | 0.946 | 1.279 | 3.953 | 2.127 | 3.904 |
| qlog records, JSON text sequence | 1467503 | 1130.6 ± 0.3% | 1207.8 ± 0.5% | 1121.7 ± 1.1% | 308.6 ± 1.4% | 733.2 ± 1.0% | 315.0 ± 1.5% | 0.936 | 1.008 | 3.664 | 1.542 | 3.589 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1731.5 ± 0.6% | 1471.5 ± 1.3% | 1016.5 ± 0.4% | 470.8 ± 0.5% | 485.9 ± 0.6% | 498.7 ± 0.5% | 1.177 | 1.703 | 3.678 | 3.563 | 3.472 |
| qlog records, JSON text sequence | 1467503 | 1527.9 ± 12.7% | 1214.4 ± 1.6% | 915.2 ± 2.7% | 447.4 ± 0.7% | 565.6 ± 2.0% | 353.7 ± 0.6% | 1.258 | 1.669 | 3.415 | 2.701 | 4.320 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1782.6 ± 0.5% | 1471.5 ± 1.3% | 1016.5 ± 0.4% | 470.8 ± 0.5% | 485.9 ± 0.6% | 498.7 ± 0.5% | 1.211 | 1.754 | 3.786 | 3.669 | 3.574 |
| qlog records, JSON text sequence | 1467503 | 1714.3 ± 0.5% | 1214.4 ± 1.6% | 915.2 ± 2.7% | 447.4 ± 0.7% | 565.6 ± 2.0% | 353.7 ± 0.6% | 1.412 | 1.873 | 3.832 | 3.031 | 4.847 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1016.6 ± 0.4% | 1508.3 ± 0.7% | 1116.1 ± 0.2% | 361.1 ± 0.8% | 671.2 ± 1.0% | 365.6 ± 1.9% | 0.674 | 0.911 | 2.815 | 1.515 | 2.781 |
| qlog records, JSON text sequence | 1467503 | 769.8 ± 0.9% | 1207.8 ± 0.5% | 1121.7 ± 1.1% | 308.6 ± 1.4% | 733.2 ± 1.0% | 315.0 ± 1.5% | 0.637 | 0.686 | 2.495 | 1.050 | 2.443 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1426.7 ± 0.3% | 1471.5 ± 1.3% | 1016.5 ± 0.4% | 470.8 ± 0.5% | 485.9 ± 0.6% | 498.7 ± 0.5% | 0.970 | 1.404 | 3.030 | 2.936 | 2.861 |
| qlog records, JSON text sequence | 1467503 | 1225.3 ± 0.4% | 1214.4 ± 1.6% | 915.2 ± 2.7% | 447.4 ± 0.7% | 565.6 ± 2.0% | 353.7 ± 0.6% | 1.009 | 1.339 | 2.739 | 2.167 | 3.464 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.946 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.936 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.674 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.911 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.637 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.686 of yyjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1430.8 ± 1.6% | 0.469 | 0.996 | 0.999 | 1.000 | 0.393 | 1.003 | 1.001 | 0.357 | 0.782 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1158.9 ± 1.1% | 0.728 | 1.006 | 0.964 | 0.961 | 0.372 | 0.965 | 0.961 | 0.346 | 0.847 | 0.120 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1733.8 ± 0.8% | 0.436 | 0.969 | 0.970 | 0.995 | 0.995 | 0.276 | 1.001 | 0.514 | 0.826 | 0.092 | 1.030 |
| qlog records, JSON text sequence | 1467503 | 1397.3 ± 18.5% | 0.800 | 1.074 | 1.169 | 1.191 | 1.153 | 0.293 | 1.157 | 0.513 | 0.883 | 0.121 | 1.226 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, encoding: J7 wide vectors off runs at 1.191 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1430.8 ± 1.6% | 1507.2 ± 1.6% | 1114.9 ± 0.3% | 361.4 ± 0.4% | 669.5 ± 0.4% | 367.1 ± 2.0% | 0.949 | 1.283 | 3.959 | 2.137 | 3.898 |
| qlog records, JSON text sequence | 1467503 | 1158.9 ± 1.1% | 1224.3 ± 0.3% | 1082.9 ± 0.8% | 307.2 ± 1.1% | 719.9 ± 0.7% | 318.1 ± 1.3% | 0.947 | 1.070 | 3.773 | 1.610 | 3.644 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1733.8 ± 0.8% | 1478.5 ± 1.1% | 1017.1 ± 0.2% | 465.6 ± 0.3% | 487.2 ± 0.9% | 500.6 ± 0.4% | 1.173 | 1.705 | 3.724 | 3.559 | 3.464 |
| qlog records, JSON text sequence | 1467503 | 1397.3 ± 18.5% | 1199.1 ± 2.0% | 911.7 ± 2.9% | 439.3 ± 3.0% | 572.8 ± 0.4% | 352.9 ± 2.4% | 1.165 | 1.533 | 3.181 | 2.440 | 3.960 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1785.3 ± 0.4% | 1478.5 ± 1.1% | 1017.1 ± 0.2% | 465.6 ± 0.3% | 487.2 ± 0.9% | 500.6 ± 0.4% | 1.208 | 1.755 | 3.835 | 3.664 | 3.566 |
| qlog records, JSON text sequence | 1467503 | 1713.5 ± 2.9% | 1199.1 ± 2.0% | 911.7 ± 2.9% | 439.3 ± 3.0% | 572.8 ± 0.4% | 352.9 ± 2.4% | 1.429 | 1.879 | 3.900 | 2.992 | 4.856 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1119.6 ± 0.7% | 1507.2 ± 1.6% | 1114.9 ± 0.3% | 361.4 ± 0.4% | 669.5 ± 0.4% | 367.1 ± 2.0% | 0.743 | 1.004 | 3.098 | 1.672 | 3.050 |
| qlog records, JSON text sequence | 1467503 | 981.5 ± 1.9% | 1224.3 ± 0.3% | 1082.9 ± 0.8% | 307.2 ± 1.1% | 719.9 ± 0.7% | 318.1 ± 1.3% | 0.802 | 0.906 | 3.195 | 1.364 | 3.086 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1431.4 ± 1.4% | 1478.5 ± 1.1% | 1017.1 ± 0.2% | 465.6 ± 0.3% | 487.2 ± 0.9% | 500.6 ± 0.4% | 0.968 | 1.407 | 3.075 | 2.938 | 2.860 |
| qlog records, JSON text sequence | 1467503 | 1234.0 ± 0.3% | 1199.1 ± 2.0% | 911.7 ± 2.9% | 439.3 ± 3.0% | 572.8 ± 0.4% | 352.9 ± 2.4% | 1.029 | 1.353 | 2.809 | 2.154 | 3.497 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.949 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.947 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.743 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.802 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.906 of yyjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1429.7 ± 0.9% | 0.469 | 0.996 | 0.998 | 1.001 | 0.393 | 1.004 | 1.001 | 0.357 | 0.801 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1159.1 ± 1.5% | 0.729 | 1.008 | 0.962 | 0.961 | 0.376 | 0.966 | 0.960 | 0.346 | 0.858 | 0.120 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1741.4 ± 1.3% | 0.434 | 0.977 | 0.967 | 1.000 | 0.993 | 0.277 | 1.001 | 0.513 | 0.823 | 0.092 | 1.028 |
| qlog records, JSON text sequence | 1467503 | 1541.7 ± 15.7% | 0.727 | 0.977 | 1.054 | 1.077 | 1.048 | 0.266 | 1.045 | 0.473 | 0.797 | 0.109 | 1.113 |

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
| CLDR supplemental, 34 texts | 920675 | 1429.7 ± 0.9% | 1494.7 ± 0.9% | 1114.8 ± 0.5% | 360.6 ± 1.1% | 669.6 ± 0.7% | 365.5 ± 1.8% | 0.956 | 1.283 | 3.965 | 2.135 | 3.912 |
| qlog records, JSON text sequence | 1467503 | 1159.1 ± 1.5% | 1222.8 ± 1.3% | 1075.8 ± 1.2% | 305.9 ± 1.4% | 720.0 ± 0.9% | 318.9 ± 0.8% | 0.948 | 1.077 | 3.789 | 1.610 | 3.635 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1741.4 ± 1.3% | 1473.8 ± 1.0% | 1016.8 ± 1.3% | 466.7 ± 0.2% | 486.2 ± 1.2% | 501.5 ± 0.4% | 1.182 | 1.713 | 3.732 | 3.582 | 3.472 |
| qlog records, JSON text sequence | 1467503 | 1541.7 ± 15.7% | 1199.3 ± 2.4% | 906.2 ± 3.6% | 437.6 ± 0.6% | 573.7 ± 2.1% | 350.4 ± 2.0% | 1.286 | 1.701 | 3.523 | 2.687 | 4.400 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1790.4 ± 0.3% | 1473.8 ± 1.0% | 1016.8 ± 1.3% | 466.7 ± 0.2% | 486.2 ± 1.2% | 501.5 ± 0.4% | 1.215 | 1.761 | 3.837 | 3.682 | 3.570 |
| qlog records, JSON text sequence | 1467503 | 1715.7 ± 5.1% | 1199.3 ± 2.4% | 906.2 ± 3.6% | 437.6 ± 0.6% | 573.7 ± 2.1% | 350.4 ± 2.0% | 1.431 | 1.893 | 3.921 | 2.991 | 4.897 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1145.5 ± 0.3% | 1494.7 ± 0.9% | 1114.8 ± 0.5% | 360.6 ± 1.1% | 669.6 ± 0.7% | 365.5 ± 1.8% | 0.766 | 1.028 | 3.176 | 1.711 | 3.134 |
| qlog records, JSON text sequence | 1467503 | 994.4 ± 0.7% | 1222.8 ± 1.3% | 1075.8 ± 1.2% | 305.9 ± 1.4% | 720.0 ± 0.9% | 318.9 ± 0.8% | 0.813 | 0.924 | 3.251 | 1.381 | 3.118 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1433.9 ± 0.6% | 1473.8 ± 1.0% | 1016.8 ± 1.3% | 466.7 ± 0.2% | 486.2 ± 1.2% | 501.5 ± 0.4% | 0.973 | 1.410 | 3.073 | 2.949 | 2.859 |
| qlog records, JSON text sequence | 1467503 | 1229.4 ± 1.9% | 1199.3 ± 2.4% | 906.2 ± 3.6% | 437.6 ± 0.6% | 573.7 ± 2.1% | 350.4 ± 2.0% | 1.025 | 1.357 | 2.809 | 2.143 | 3.509 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.948 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.766 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.813 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.924 of yyjson.
