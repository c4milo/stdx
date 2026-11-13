# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1420.8 ± 0.3% | 0.475 | 1.010 | 1.028 | 1.028 | 0.398 | 1.027 | 1.027 | 0.358 | 0.715 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1135.7 ± 1.9% | 0.755 | 1.052 | 1.019 | 1.024 | 0.380 | 1.018 | 1.024 | 0.353 | 0.674 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1735.3 ± 1.7% | 0.426 | 1.007 | 0.980 | 1.018 | 1.018 | 0.269 | 1.015 | 0.522 | 0.817 | 0.093 | 1.036 |
| qlog records, JSON text sequence | 1467503 | 1647.7 ± 2.9% | 0.643 | 0.968 | 0.990 | 1.002 | 0.993 | 0.236 | 0.995 | 0.455 | 0.749 | 0.107 | 1.044 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.052 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1420.8 ± 0.3% | 1539.5 ± 0.7% | 1116.3 ± 0.5% | 361.6 ± 0.9% | 670.1 ± 0.2% | 365.4 ± 2.1% | 0.923 | 1.273 | 3.930 | 2.120 | 3.888 |
| qlog records, JSON text sequence | 1467503 | 1135.7 ± 1.9% | 1237.4 ± 1.2% | 1128.8 ± 0.9% | 307.8 ± 1.7% | 745.2 ± 0.8% | 313.9 ± 1.6% | 0.918 | 1.006 | 3.690 | 1.524 | 3.618 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1735.3 ± 1.7% | 1477.5 ± 0.9% | 1021.9 ± 0.9% | 467.0 ± 1.0% | 474.9 ± 1.1% | 494.6 ± 1.4% | 1.174 | 1.698 | 3.716 | 3.654 | 3.508 |
| qlog records, JSON text sequence | 1467503 | 1647.7 ± 2.9% | 1233.9 ± 2.0% | 953.7 ± 1.3% | 447.1 ± 0.8% | 566.2 ± 0.6% | 352.6 ± 0.8% | 1.335 | 1.728 | 3.685 | 2.910 | 4.673 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1797.6 ± 0.8% | 1477.5 ± 0.9% | 1021.9 ± 0.9% | 467.0 ± 1.0% | 474.9 ± 1.1% | 494.6 ± 1.4% | 1.217 | 1.759 | 3.849 | 3.785 | 3.634 |
| qlog records, JSON text sequence | 1467503 | 1720.2 ± 1.0% | 1233.9 ± 2.0% | 953.7 ± 1.3% | 447.1 ± 0.8% | 566.2 ± 0.6% | 352.6 ± 0.8% | 1.394 | 1.804 | 3.847 | 3.038 | 4.878 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1015.3 ± 0.2% | 1539.5 ± 0.7% | 1116.3 ± 0.5% | 361.6 ± 0.9% | 670.1 ± 0.2% | 365.4 ± 2.1% | 0.659 | 0.909 | 2.808 | 1.515 | 2.778 |
| qlog records, JSON text sequence | 1467503 | 765.4 ± 0.9% | 1237.4 ± 1.2% | 1128.8 ± 0.9% | 307.8 ± 1.7% | 745.2 ± 0.8% | 313.9 ± 1.6% | 0.619 | 0.678 | 2.487 | 1.027 | 2.439 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1417.6 ± 0.8% | 1477.5 ± 0.9% | 1021.9 ± 0.9% | 467.0 ± 1.0% | 474.9 ± 1.1% | 494.6 ± 1.4% | 0.959 | 1.387 | 3.035 | 2.985 | 2.866 |
| qlog records, JSON text sequence | 1467503 | 1234.8 ± 0.4% | 1233.9 ± 2.0% | 953.7 ± 1.3% | 447.1 ± 0.8% | 566.2 ± 0.6% | 352.6 ± 0.8% | 1.001 | 1.295 | 2.762 | 2.181 | 3.502 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.923 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.918 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.659 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.909 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.619 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.678 of yyjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1431.3 ± 1.4% | 0.466 | 0.988 | 0.991 | 0.994 | 0.390 | 0.996 | 0.994 | 0.353 | 0.783 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1157.7 ± 0.9% | 0.726 | 1.006 | 0.960 | 0.960 | 0.375 | 0.964 | 0.962 | 0.342 | 0.856 | 0.119 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1753.8 ± 2.2% | 0.429 | 0.982 | 0.967 | 1.002 | 1.004 | 0.279 | 1.002 | 0.519 | 0.815 | 0.090 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1664.1 ± 2.6% | 0.671 | 0.908 | 0.987 | 1.003 | 0.978 | 0.250 | 0.977 | 0.454 | 0.740 | 0.101 | 1.034 |

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
| CLDR supplemental, 34 texts | 920675 | 1431.3 ± 1.4% | 1530.3 ± 2.5% | 1112.4 ± 0.9% | 359.3 ± 0.7% | 663.9 ± 0.7% | 364.9 ± 1.6% | 0.935 | 1.287 | 3.984 | 2.156 | 3.922 |
| qlog records, JSON text sequence | 1467503 | 1157.7 ± 0.9% | 1239.7 ± 1.3% | 1090.9 ± 0.8% | 305.8 ± 1.4% | 724.1 ± 1.2% | 316.8 ± 0.9% | 0.934 | 1.061 | 3.786 | 1.599 | 3.655 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1753.8 ± 2.2% | 1476.9 ± 0.9% | 1021.2 ± 1.9% | 464.1 ± 0.3% | 474.0 ± 1.4% | 500.4 ± 0.3% | 1.187 | 1.717 | 3.779 | 3.700 | 3.505 |
| qlog records, JSON text sequence | 1467503 | 1664.1 ± 2.6% | 1222.4 ± 0.8% | 953.0 ± 2.7% | 435.1 ± 1.0% | 573.2 ± 0.6% | 352.1 ± 1.2% | 1.361 | 1.746 | 3.825 | 2.903 | 4.726 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1800.4 ± 0.4% | 1476.9 ± 0.9% | 1021.2 ± 1.9% | 464.1 ± 0.3% | 474.0 ± 1.4% | 500.4 ± 0.3% | 1.219 | 1.763 | 3.879 | 3.798 | 3.598 |
| qlog records, JSON text sequence | 1467503 | 1720.5 ± 0.9% | 1222.4 ± 0.8% | 953.0 ± 2.7% | 435.1 ± 1.0% | 573.2 ± 0.6% | 352.1 ± 1.2% | 1.407 | 1.805 | 3.955 | 3.001 | 4.886 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1120.3 ± 0.5% | 1530.3 ± 2.5% | 1112.4 ± 0.9% | 359.3 ± 0.7% | 663.9 ± 0.7% | 364.9 ± 1.6% | 0.732 | 1.007 | 3.118 | 1.687 | 3.070 |
| qlog records, JSON text sequence | 1467503 | 990.9 ± 0.7% | 1239.7 ± 1.3% | 1090.9 ± 0.8% | 305.8 ± 1.4% | 724.1 ± 1.2% | 316.8 ± 0.9% | 0.799 | 0.908 | 3.240 | 1.368 | 3.128 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1429.9 ± 0.6% | 1476.9 ± 0.9% | 1021.2 ± 1.9% | 464.1 ± 0.3% | 474.0 ± 1.4% | 500.4 ± 0.3% | 0.968 | 1.400 | 3.081 | 3.017 | 2.858 |
| qlog records, JSON text sequence | 1467503 | 1232.0 ± 0.4% | 1222.4 ± 0.8% | 953.0 ± 2.7% | 435.1 ± 1.0% | 573.2 ± 0.6% | 352.1 ± 1.2% | 1.008 | 1.293 | 2.832 | 2.149 | 3.499 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.935 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.934 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.732 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.799 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.908 of yyjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1423.2 ± 1.6% | 0.470 | 0.994 | 0.995 | 0.998 | 0.394 | 0.999 | 0.995 | 0.357 | 0.799 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1145.7 ± 0.9% | 0.732 | 1.012 | 0.964 | 0.969 | 0.378 | 0.970 | 0.968 | 0.345 | 0.867 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1760.4 ± 1.6% | 0.427 | 0.973 | 0.966 | 0.993 | 0.998 | 0.279 | 0.997 | 0.512 | 0.813 | 0.090 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1661.0 ± 2.7% | 0.670 | 0.907 | 0.984 | 1.003 | 0.976 | 0.249 | 0.976 | 0.440 | 0.742 | 0.101 | 1.036 |

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
| CLDR supplemental, 34 texts | 920675 | 1423.2 ± 1.6% | 1528.6 ± 2.4% | 1100.3 ± 0.4% | 360.1 ± 1.1% | 666.2 ± 0.4% | 363.3 ± 2.1% | 0.931 | 1.293 | 3.952 | 2.136 | 3.917 |
| qlog records, JSON text sequence | 1467503 | 1145.7 ± 0.9% | 1224.8 ± 1.7% | 1082.1 ± 1.0% | 305.5 ± 1.5% | 724.6 ± 1.2% | 314.3 ± 1.0% | 0.935 | 1.059 | 3.750 | 1.581 | 3.645 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1760.4 ± 1.6% | 1477.8 ± 0.8% | 1022.3 ± 1.0% | 464.8 ± 0.7% | 478.2 ± 2.1% | 499.0 ± 1.0% | 1.191 | 1.722 | 3.787 | 3.682 | 3.528 |
| qlog records, JSON text sequence | 1467503 | 1661.0 ± 2.7% | 1206.5 ± 2.8% | 955.6 ± 1.8% | 434.1 ± 0.6% | 571.7 ± 0.7% | 350.8 ± 5.1% | 1.377 | 1.738 | 3.826 | 2.905 | 4.734 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1799.8 ± 0.6% | 1477.8 ± 0.8% | 1022.3 ± 1.0% | 464.8 ± 0.7% | 478.2 ± 2.1% | 499.0 ± 1.0% | 1.218 | 1.761 | 3.872 | 3.764 | 3.607 |
| qlog records, JSON text sequence | 1467503 | 1721.5 ± 0.3% | 1206.5 ± 2.8% | 955.6 ± 1.8% | 434.1 ± 0.6% | 571.7 ± 0.7% | 350.8 ± 5.1% | 1.427 | 1.802 | 3.966 | 3.011 | 4.907 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1137.6 ± 0.9% | 1528.6 ± 2.4% | 1100.3 ± 0.4% | 360.1 ± 1.1% | 666.2 ± 0.4% | 363.3 ± 2.1% | 0.744 | 1.034 | 3.159 | 1.708 | 3.131 |
| qlog records, JSON text sequence | 1467503 | 993.7 ± 0.7% | 1224.8 ± 1.7% | 1082.1 ± 1.0% | 305.5 ± 1.5% | 724.6 ± 1.2% | 314.3 ± 1.0% | 0.811 | 0.918 | 3.253 | 1.371 | 3.162 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1431.3 ± 0.5% | 1477.8 ± 0.8% | 1022.3 ± 1.0% | 464.8 ± 0.7% | 478.2 ± 2.1% | 499.0 ± 1.0% | 0.969 | 1.400 | 3.079 | 2.993 | 2.868 |
| qlog records, JSON text sequence | 1467503 | 1232.0 ± 0.5% | 1206.5 ± 2.8% | 955.6 ± 1.8% | 434.1 ± 0.6% | 571.7 ± 0.7% | 350.8 ± 5.1% | 1.021 | 1.289 | 2.838 | 2.155 | 3.512 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.931 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.935 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.744 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.811 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.918 of yyjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1411.5 ± 0.7% | 0.475 | 1.007 | 1.024 | 1.029 | 0.399 | 1.026 | 1.025 | 0.357 | 0.713 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1125.6 ± 0.9% | 0.764 | 1.051 | 1.025 | 1.029 | 0.381 | 1.027 | 1.033 | 0.354 | 0.674 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1743.4 ± 1.5% | 0.426 | 1.003 | 0.972 | 1.008 | 1.010 | 0.272 | 1.012 | 0.517 | 0.819 | 0.094 | 1.030 |
| qlog records, JSON text sequence | 1467503 | 1650.3 ± 2.0% | 0.641 | 0.965 | 0.987 | 1.003 | 0.991 | 0.236 | 0.992 | 0.442 | 0.745 | 0.107 | 1.042 |

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
| CLDR supplemental, 34 texts | 920675 | 1411.5 ± 0.7% | 1524.4 ± 1.2% | 1101.7 ± 0.7% | 358.0 ± 0.5% | 664.7 ± 1.4% | 361.8 ± 2.3% | 0.926 | 1.281 | 3.943 | 2.123 | 3.902 |
| qlog records, JSON text sequence | 1467503 | 1125.6 ± 0.9% | 1231.1 ± 1.7% | 1123.8 ± 1.0% | 307.2 ± 1.3% | 746.8 ± 0.5% | 312.7 ± 0.8% | 0.914 | 1.002 | 3.664 | 1.507 | 3.599 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1743.4 ± 1.5% | 1473.1 ± 0.7% | 1023.0 ± 0.9% | 468.9 ± 1.6% | 477.2 ± 3.6% | 498.1 ± 1.3% | 1.183 | 1.704 | 3.718 | 3.653 | 3.500 |
| qlog records, JSON text sequence | 1467503 | 1650.3 ± 2.0% | 1219.0 ± 1.5% | 955.5 ± 1.6% | 446.5 ± 0.9% | 564.6 ± 1.2% | 351.2 ± 1.0% | 1.354 | 1.727 | 3.696 | 2.923 | 4.700 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1796.5 ± 1.9% | 1473.1 ± 0.7% | 1023.0 ± 0.9% | 468.9 ± 1.6% | 477.2 ± 3.6% | 498.1 ± 1.3% | 1.220 | 1.756 | 3.831 | 3.764 | 3.607 |
| qlog records, JSON text sequence | 1467503 | 1719.8 ± 0.9% | 1219.0 ± 1.5% | 955.5 ± 1.6% | 446.5 ± 0.9% | 564.6 ± 1.2% | 351.2 ± 1.0% | 1.411 | 1.800 | 3.851 | 3.046 | 4.897 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1006.4 ± 1.1% | 1524.4 ± 1.2% | 1101.7 ± 0.7% | 358.0 ± 0.5% | 664.7 ± 1.4% | 361.8 ± 2.3% | 0.660 | 0.914 | 2.811 | 1.514 | 2.782 |
| qlog records, JSON text sequence | 1467503 | 758.3 ± 1.9% | 1231.1 ± 1.7% | 1123.8 ± 1.0% | 307.2 ± 1.3% | 746.8 ± 0.5% | 312.7 ± 0.8% | 0.616 | 0.675 | 2.469 | 1.015 | 2.425 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1428.0 ± 0.4% | 1473.1 ± 0.7% | 1023.0 ± 0.9% | 468.9 ± 1.6% | 477.2 ± 3.6% | 498.1 ± 1.3% | 0.969 | 1.396 | 3.045 | 2.992 | 2.867 |
| qlog records, JSON text sequence | 1467503 | 1229.3 ± 0.6% | 1219.0 ± 1.5% | 955.5 ± 1.6% | 446.5 ± 0.9% | 564.6 ± 1.2% | 351.2 ± 1.0% | 1.008 | 1.287 | 2.753 | 2.177 | 3.501 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.926 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.914 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.660 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.914 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.616 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.675 of yyjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1422.5 ± 1.3% | 0.468 | 0.994 | 0.993 | 0.994 | 0.392 | 0.997 | 0.995 | 0.355 | 0.778 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1152.5 ± 0.7% | 0.728 | 1.007 | 0.962 | 0.962 | 0.377 | 0.966 | 0.962 | 0.344 | 0.856 | 0.120 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1764.8 ± 0.8% | 0.425 | 0.973 | 0.964 | 0.993 | 0.994 | 0.276 | 0.994 | 0.509 | 0.810 | 0.089 | 1.020 |
| qlog records, JSON text sequence | 1467503 | 1653.0 ± 3.5% | 0.672 | 0.910 | 0.992 | 1.004 | 0.977 | 0.249 | 0.979 | 0.441 | 0.745 | 0.101 | 1.037 |

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
| CLDR supplemental, 34 texts | 920675 | 1422.5 ± 1.3% | 1531.0 ± 1.4% | 1103.5 ± 0.4% | 358.4 ± 0.7% | 664.4 ± 0.6% | 362.4 ± 1.9% | 0.929 | 1.289 | 3.969 | 2.141 | 3.925 |
| qlog records, JSON text sequence | 1467503 | 1152.5 ± 0.7% | 1236.2 ± 0.6% | 1082.3 ± 1.1% | 304.6 ± 1.0% | 723.2 ± 0.5% | 315.9 ± 1.7% | 0.932 | 1.065 | 3.784 | 1.594 | 3.649 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1764.8 ± 0.8% | 1473.7 ± 1.6% | 1020.3 ± 0.8% | 462.6 ± 0.7% | 465.2 ± 2.6% | 498.4 ± 1.1% | 1.198 | 1.730 | 3.815 | 3.794 | 3.541 |
| qlog records, JSON text sequence | 1467503 | 1653.0 ± 3.5% | 1196.1 ± 4.3% | 953.2 ± 0.6% | 433.5 ± 0.9% | 570.7 ± 1.9% | 350.3 ± 0.4% | 1.382 | 1.734 | 3.813 | 2.897 | 4.719 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1800.6 ± 0.8% | 1473.7 ± 1.6% | 1020.3 ± 0.8% | 462.6 ± 0.7% | 465.2 ± 2.6% | 498.4 ± 1.1% | 1.222 | 1.765 | 3.893 | 3.871 | 3.612 |
| qlog records, JSON text sequence | 1467503 | 1713.7 ± 0.8% | 1196.1 ± 4.3% | 953.2 ± 0.6% | 433.5 ± 0.9% | 570.7 ± 1.9% | 350.3 ± 0.4% | 1.433 | 1.798 | 3.953 | 3.003 | 4.892 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1107.1 ± 1.4% | 1531.0 ± 1.4% | 1103.5 ± 0.4% | 358.4 ± 0.7% | 664.4 ± 0.6% | 362.4 ± 1.9% | 0.723 | 1.003 | 3.089 | 1.666 | 3.055 |
| qlog records, JSON text sequence | 1467503 | 986.5 ± 0.9% | 1236.2 ± 0.6% | 1082.3 ± 1.1% | 304.6 ± 1.0% | 723.2 ± 0.5% | 315.9 ± 1.7% | 0.798 | 0.911 | 3.238 | 1.364 | 3.123 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1429.1 ± 0.3% | 1473.7 ± 1.6% | 1020.3 ± 0.8% | 462.6 ± 0.7% | 465.2 ± 2.6% | 498.4 ± 1.1% | 0.970 | 1.401 | 3.089 | 3.072 | 2.867 |
| qlog records, JSON text sequence | 1467503 | 1231.6 ± 1.1% | 1196.1 ± 4.3% | 953.2 ± 0.6% | 433.5 ± 0.9% | 570.7 ± 1.9% | 350.3 ± 0.4% | 1.030 | 1.292 | 2.841 | 2.158 | 3.516 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.929 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.932 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.723 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.798 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.911 of yyjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1414.2 ± 0.8% | 0.470 | 0.995 | 0.996 | 1.001 | 0.393 | 1.004 | 1.003 | 0.358 | 0.803 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1153.1 ± 0.4% | 0.728 | 1.009 | 0.965 | 0.963 | 0.375 | 0.966 | 0.964 | 0.344 | 0.862 | 0.120 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1762.5 ± 2.3% | 0.427 | 0.979 | 0.967 | 1.000 | 0.993 | 0.276 | 0.996 | 0.512 | 0.810 | 0.090 | 1.018 |
| qlog records, JSON text sequence | 1467503 | 1656.9 ± 2.1% | 0.670 | 0.907 | 0.985 | 1.002 | 0.976 | 0.248 | 0.980 | 0.449 | 0.740 | 0.100 | 1.035 |

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
| CLDR supplemental, 34 texts | 920675 | 1414.2 ± 0.8% | 1529.9 ± 2.8% | 1074.9 ± 0.7% | 358.0 ± 1.2% | 663.2 ± 1.0% | 363.0 ± 2.7% | 0.924 | 1.316 | 3.950 | 2.132 | 3.895 |
| qlog records, JSON text sequence | 1467503 | 1153.1 ± 0.4% | 1222.7 ± 2.1% | 1072.2 ± 1.5% | 305.9 ± 1.1% | 713.8 ± 2.6% | 316.1 ± 1.2% | 0.943 | 1.075 | 3.770 | 1.615 | 3.648 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1762.5 ± 2.3% | 1463.4 ± 1.4% | 1019.4 ± 2.1% | 461.8 ± 0.6% | 466.2 ± 2.8% | 495.9 ± 2.2% | 1.204 | 1.729 | 3.817 | 3.781 | 3.554 |
| qlog records, JSON text sequence | 1467503 | 1656.9 ± 2.1% | 1203.2 ± 2.4% | 951.8 ± 0.4% | 433.1 ± 1.9% | 570.5 ± 0.8% | 348.3 ± 3.5% | 1.377 | 1.741 | 3.826 | 2.904 | 4.757 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1793.8 ± 1.3% | 1463.4 ± 1.4% | 1019.4 ± 2.1% | 461.8 ± 0.6% | 466.2 ± 2.8% | 495.9 ± 2.2% | 1.226 | 1.760 | 3.885 | 3.848 | 3.617 |
| qlog records, JSON text sequence | 1467503 | 1714.7 ± 1.4% | 1203.2 ± 2.4% | 951.8 ± 0.4% | 433.1 ± 1.9% | 570.5 ± 0.8% | 348.3 ± 3.5% | 1.425 | 1.802 | 3.959 | 3.006 | 4.923 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1135.5 ± 0.6% | 1529.9 ± 2.8% | 1074.9 ± 0.7% | 358.0 ± 1.2% | 663.2 ± 1.0% | 363.0 ± 2.7% | 0.742 | 1.056 | 3.172 | 1.712 | 3.128 |
| qlog records, JSON text sequence | 1467503 | 993.7 ± 0.7% | 1222.7 ± 2.1% | 1072.2 ± 1.5% | 305.9 ± 1.1% | 713.8 ± 2.6% | 316.1 ± 1.2% | 0.813 | 0.927 | 3.248 | 1.392 | 3.144 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1428.1 ± 1.0% | 1463.4 ± 1.4% | 1019.4 ± 2.1% | 461.8 ± 0.6% | 466.2 ± 2.8% | 495.9 ± 2.2% | 0.976 | 1.401 | 3.093 | 3.064 | 2.880 |
| qlog records, JSON text sequence | 1467503 | 1225.8 ± 2.4% | 1203.2 ± 2.4% | 951.8 ± 0.4% | 433.1 ± 1.9% | 570.5 ± 0.8% | 348.3 ± 3.5% | 1.019 | 1.288 | 2.830 | 2.149 | 3.519 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.924 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.943 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.742 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.813 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.927 of yyjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1413.2 ± 0.8% | 0.473 | 1.007 | 1.026 | 1.025 | 0.398 | 1.023 | 1.025 | 0.358 | 0.713 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1127.2 ± 1.1% | 0.757 | 1.053 | 1.020 | 1.022 | 0.384 | 1.021 | 1.029 | 0.354 | 0.680 | 0.121 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1742.1 ± 1.8% | 0.426 | 1.004 | 0.977 | 1.013 | 1.012 | 0.270 | 1.015 | 0.505 | 0.821 | 0.094 | 1.035 |
| qlog records, JSON text sequence | 1467503 | 1647.8 ± 2.5% | 0.640 | 0.965 | 0.984 | 0.995 | 0.988 | 0.236 | 0.990 | 0.440 | 0.742 | 0.106 | 1.038 |

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
| CLDR supplemental, 34 texts | 920675 | 1413.2 ± 0.8% | 1533.9 ± 1.1% | 1105.3 ± 0.5% | 358.5 ± 1.0% | 665.3 ± 0.8% | 361.7 ± 2.7% | 0.921 | 1.279 | 3.942 | 2.124 | 3.907 |
| qlog records, JSON text sequence | 1467503 | 1127.2 ± 1.1% | 1202.6 ± 1.6% | 1122.6 ± 1.2% | 307.4 ± 2.1% | 747.4 ± 2.5% | 312.4 ± 1.7% | 0.937 | 1.004 | 3.667 | 1.508 | 3.608 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1742.1 ± 1.8% | 1481.2 ± 1.2% | 1024.3 ± 1.9% | 469.9 ± 1.1% | 475.5 ± 3.4% | 498.9 ± 1.7% | 1.176 | 1.701 | 3.707 | 3.664 | 3.492 |
| qlog records, JSON text sequence | 1467503 | 1647.8 ± 2.5% | 1222.7 ± 3.9% | 937.1 ± 3.0% | 443.0 ± 0.5% | 560.8 ± 0.7% | 349.5 ± 0.9% | 1.348 | 1.758 | 3.719 | 2.938 | 4.715 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1803.2 ± 1.0% | 1481.2 ± 1.2% | 1024.3 ± 1.9% | 469.9 ± 1.1% | 475.5 ± 3.4% | 498.9 ± 1.7% | 1.217 | 1.760 | 3.837 | 3.792 | 3.614 |
| qlog records, JSON text sequence | 1467503 | 1709.8 ± 0.2% | 1222.7 ± 3.9% | 937.1 ± 3.0% | 443.0 ± 0.5% | 560.8 ± 0.7% | 349.5 ± 0.9% | 1.398 | 1.824 | 3.859 | 3.049 | 4.892 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1007.2 ± 0.8% | 1533.9 ± 1.1% | 1105.3 ± 0.5% | 358.5 ± 1.0% | 665.3 ± 0.8% | 361.7 ± 2.7% | 0.657 | 0.911 | 2.810 | 1.514 | 2.784 |
| qlog records, JSON text sequence | 1467503 | 766.3 ± 1.5% | 1202.6 ± 1.6% | 1122.6 ± 1.2% | 307.4 ± 2.1% | 747.4 ± 2.5% | 312.4 ± 1.7% | 0.637 | 0.683 | 2.493 | 1.025 | 2.453 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1429.9 ± 0.6% | 1481.2 ± 1.2% | 1024.3 ± 1.9% | 469.9 ± 1.1% | 475.5 ± 3.4% | 498.9 ± 1.7% | 0.965 | 1.396 | 3.043 | 3.007 | 2.866 |
| qlog records, JSON text sequence | 1467503 | 1222.0 ± 0.4% | 1222.7 ± 3.9% | 937.1 ± 3.0% | 443.0 ± 0.5% | 560.8 ± 0.7% | 349.5 ± 0.9% | 0.999 | 1.304 | 2.758 | 2.179 | 3.497 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.921 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.937 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.657 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.911 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.637 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.683 of yyjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1420.7 ± 0.6% | 0.469 | 0.994 | 0.997 | 1.000 | 0.390 | 0.998 | 1.000 | 0.356 | 0.783 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 1149.9 ± 1.0% | 0.730 | 1.013 | 0.970 | 0.967 | 0.375 | 0.972 | 0.967 | 0.346 | 0.860 | 0.120 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1757.2 ± 2.4% | 0.428 | 0.979 | 0.970 | 0.999 | 1.000 | 0.278 | 0.998 | 0.520 | 0.813 | 0.090 | 1.026 |
| qlog records, JSON text sequence | 1467503 | 1663.6 ± 3.5% | 0.668 | 0.902 | 0.981 | 1.001 | 0.975 | 0.249 | 0.973 | 0.447 | 0.741 | 0.101 | 1.028 |

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
| CLDR supplemental, 34 texts | 920675 | 1420.7 ± 0.6% | 1492.3 ± 2.8% | 1073.4 ± 1.1% | 360.8 ± 1.1% | 664.6 ± 0.8% | 362.2 ± 2.4% | 0.952 | 1.324 | 3.937 | 2.138 | 3.923 |
| qlog records, JSON text sequence | 1467503 | 1149.9 ± 1.0% | 1209.6 ± 1.1% | 1078.7 ± 1.1% | 305.4 ± 0.7% | 720.1 ± 0.6% | 315.9 ± 2.1% | 0.951 | 1.066 | 3.765 | 1.597 | 3.640 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1757.2 ± 2.4% | 1479.6 ± 0.6% | 1022.2 ± 0.5% | 463.4 ± 0.8% | 479.4 ± 2.6% | 497.2 ± 2.3% | 1.188 | 1.719 | 3.792 | 3.665 | 3.534 |
| qlog records, JSON text sequence | 1467503 | 1663.6 ± 3.5% | 1214.5 ± 1.5% | 958.0 ± 0.8% | 436.1 ± 1.2% | 570.6 ± 0.7% | 351.1 ± 1.3% | 1.370 | 1.737 | 3.815 | 2.915 | 4.738 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1802.2 ± 1.1% | 1479.6 ± 0.6% | 1022.2 ± 0.5% | 463.4 ± 0.8% | 479.4 ± 2.6% | 497.2 ± 2.3% | 1.218 | 1.763 | 3.889 | 3.759 | 3.625 |
| qlog records, JSON text sequence | 1467503 | 1710.3 ± 1.1% | 1214.5 ± 1.5% | 958.0 ± 0.8% | 436.1 ± 1.2% | 570.6 ± 0.7% | 351.1 ± 1.3% | 1.408 | 1.785 | 3.922 | 2.997 | 4.872 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1112.6 ± 1.1% | 1492.3 ± 2.8% | 1073.4 ± 1.1% | 360.8 ± 1.1% | 664.6 ± 0.8% | 362.2 ± 2.4% | 0.746 | 1.037 | 3.084 | 1.674 | 3.072 |
| qlog records, JSON text sequence | 1467503 | 988.4 ± 1.3% | 1209.6 ± 1.1% | 1078.7 ± 1.1% | 305.4 ± 0.7% | 720.1 ± 0.6% | 315.9 ± 2.1% | 0.817 | 0.916 | 3.236 | 1.373 | 3.129 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1428.2 ± 0.4% | 1479.6 ± 0.6% | 1022.2 ± 0.5% | 463.4 ± 0.8% | 479.4 ± 2.6% | 497.2 ± 2.3% | 0.965 | 1.397 | 3.082 | 2.979 | 2.873 |
| qlog records, JSON text sequence | 1467503 | 1232.1 ± 0.6% | 1214.5 ± 1.5% | 958.0 ± 0.8% | 436.1 ± 1.2% | 570.6 ± 0.7% | 351.1 ± 1.3% | 1.015 | 1.286 | 2.825 | 2.159 | 3.509 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.746 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.817 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.916 of yyjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) 6975P-C |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1422.9 ± 0.7% | 0.467 | 0.991 | 0.992 | 0.996 | 0.392 | 0.996 | 0.995 | 0.357 | 0.799 | 0.102 |
| qlog records, JSON text sequence | 1467503 | 1152.2 ± 0.5% | 0.728 | 1.004 | 0.964 | 0.961 | 0.373 | 0.964 | 0.962 | 0.344 | 0.862 | 0.120 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1769.1 ± 1.3% | 0.426 | 0.973 | 0.968 | 0.995 | 0.989 | 0.273 | 0.994 | 0.512 | 0.806 | 0.090 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1643.5 ± 2.0% | 0.679 | 0.918 | 0.996 | 1.014 | 0.993 | 0.251 | 0.992 | 0.448 | 0.748 | 0.102 | 1.045 |

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
| CLDR supplemental, 34 texts | 920675 | 1422.9 ± 0.7% | 1535.8 ± 1.2% | 1109.7 ± 0.8% | 359.3 ± 1.6% | 664.6 ± 0.8% | 362.2 ± 2.8% | 0.926 | 1.282 | 3.960 | 2.141 | 3.929 |
| qlog records, JSON text sequence | 1467503 | 1152.2 ± 0.5% | 1208.3 ± 1.4% | 1085.2 ± 0.7% | 304.1 ± 1.4% | 717.5 ± 3.1% | 315.3 ± 1.0% | 0.954 | 1.062 | 3.789 | 1.606 | 3.655 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1769.1 ± 1.3% | 1474.6 ± 1.1% | 1022.6 ± 0.6% | 463.6 ± 1.2% | 472.0 ± 3.3% | 495.6 ± 1.2% | 1.200 | 1.730 | 3.816 | 3.748 | 3.569 |
| qlog records, JSON text sequence | 1467503 | 1643.5 ± 2.0% | 1229.2 ± 3.4% | 948.4 ± 1.1% | 435.2 ± 1.1% | 570.5 ± 4.0% | 350.8 ± 1.7% | 1.337 | 1.733 | 3.776 | 2.881 | 4.686 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1799.9 ± 0.6% | 1474.6 ± 1.1% | 1022.6 ± 0.6% | 463.6 ± 1.2% | 472.0 ± 3.3% | 495.6 ± 1.2% | 1.221 | 1.760 | 3.882 | 3.814 | 3.632 |
| qlog records, JSON text sequence | 1467503 | 1718.2 ± 0.8% | 1229.2 ± 3.4% | 948.4 ± 1.1% | 435.2 ± 1.1% | 570.5 ± 4.0% | 350.8 ± 1.7% | 1.398 | 1.812 | 3.948 | 3.011 | 4.898 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1137.0 ± 0.5% | 1535.8 ± 1.2% | 1109.7 ± 0.8% | 359.3 ± 1.6% | 664.6 ± 0.8% | 362.2 ± 2.8% | 0.740 | 1.025 | 3.164 | 1.711 | 3.140 |
| qlog records, JSON text sequence | 1467503 | 993.4 ± 1.2% | 1208.3 ± 1.4% | 1085.2 ± 0.7% | 304.1 ± 1.4% | 717.5 ± 3.1% | 315.3 ± 1.0% | 0.822 | 0.915 | 3.267 | 1.384 | 3.151 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1425.9 ± 1.6% | 1474.6 ± 1.1% | 1022.6 ± 0.6% | 463.6 ± 1.2% | 472.0 ± 3.3% | 495.6 ± 1.2% | 0.967 | 1.394 | 3.076 | 3.021 | 2.877 |
| qlog records, JSON text sequence | 1467503 | 1229.2 ± 0.7% | 1229.2 ± 3.4% | 948.4 ± 1.1% | 435.2 ± 1.1% | 570.5 ± 4.0% | 350.8 ± 1.7% | 1.000 | 1.296 | 2.824 | 2.154 | 3.504 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.926 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.740 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.822 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.915 of yyjson.
