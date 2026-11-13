# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1033.6 ± 3.1% | 0.476 | 1.013 | 1.006 | 1.029 | 0.409 | 1.014 | 1.021 | 0.358 | 0.787 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 854.4 ± 1.3% | 0.734 | 1.030 | 1.012 | 0.995 | 0.389 | 1.015 | 0.995 | 0.339 | 0.680 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1331.9 ± 2.1% | 0.443 | 0.982 | 0.979 | 1.005 | 0.996 | 0.233 | 0.992 | 0.444 | 0.724 | 0.086 | 1.013 |
| qlog records, JSON text sequence | 1467503 | 1160.0 ± 0.4% | 0.701 | 0.920 | 0.986 | 0.981 | 0.985 | 0.224 | 0.983 | 0.412 | 0.692 | 0.105 | 1.009 |

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
| CLDR supplemental, 34 texts | 920675 | 1033.6 ± 3.1% | 1024.9 ± 0.5% | 978.9 ± 1.1% | 260.0 ± 1.0% | 531.5 ± 0.6% | 258.9 ± 3.1% | 1.008 | 1.056 | 3.976 | 1.945 | 3.992 |
| qlog records, JSON text sequence | 1467503 | 854.4 ± 1.3% | 811.8 ± 0.5% | 798.3 ± 8.2% | 223.0 ± 22.3% | 586.6 ± 0.5% | 243.7 ± 5.4% | 1.052 | 1.070 | 3.832 | 1.457 | 3.505 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1331.9 ± 2.1% | 1140.1 ± 0.7% | 896.2 ± 5.9% | 320.7 ± 0.6% | 357.9 ± 1.0% | 313.3 ± 2.0% | 1.168 | 1.486 | 4.153 | 3.721 | 4.251 |
| qlog records, JSON text sequence | 1467503 | 1160.0 ± 0.4% | 868.1 ± 0.6% | 723.9 ± 0.6% | 319.1 ± 0.8% | 391.9 ± 0.6% | 233.5 ± 1.3% | 1.336 | 1.602 | 3.636 | 2.960 | 4.967 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1348.7 ± 1.2% | 1140.1 ± 0.7% | 896.2 ± 5.9% | 320.7 ± 0.6% | 357.9 ± 1.0% | 313.3 ± 2.0% | 1.183 | 1.505 | 4.205 | 3.768 | 4.305 |
| qlog records, JSON text sequence | 1467503 | 1170.7 ± 0.7% | 868.1 ± 0.6% | 723.9 ± 0.6% | 319.1 ± 0.8% | 391.9 ± 0.6% | 233.5 ± 1.3% | 1.349 | 1.617 | 3.669 | 2.988 | 5.013 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 813.9 ± 0.7% | 1024.9 ± 0.5% | 978.9 ± 1.1% | 260.0 ± 1.0% | 531.5 ± 0.6% | 258.9 ± 3.1% | 0.794 | 0.831 | 3.131 | 1.531 | 3.143 |
| qlog records, JSON text sequence | 1467503 | 580.8 ± 5.3% | 811.8 ± 0.5% | 798.3 ± 8.2% | 223.0 ± 22.3% | 586.6 ± 0.5% | 243.7 ± 5.4% | 0.715 | 0.728 | 2.605 | 0.990 | 2.383 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 964.0 ± 1.0% | 1140.1 ± 0.7% | 896.2 ± 5.9% | 320.7 ± 0.6% | 357.9 ± 1.0% | 313.3 ± 2.0% | 0.846 | 1.076 | 3.006 | 2.693 | 3.077 |
| qlog records, JSON text sequence | 1467503 | 802.9 ± 0.5% | 868.1 ± 0.6% | 723.9 ± 0.6% | 319.1 ± 0.8% | 391.9 ± 0.6% | 233.5 ± 1.3% | 0.925 | 1.109 | 2.517 | 2.049 | 3.438 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.794 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.831 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.715 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.728 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.846 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.925 of simdjson.

# bench-json, CLDR and qlog alone: null, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1004.3 ± 4.3% | 0.478 | 1.035 | 1.092 | 1.093 | 0.430 | 1.082 | 1.095 | 0.368 | 0.771 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 828.8 ± 2.9% | 0.746 | 1.035 | 1.019 | 1.002 | 0.393 | 1.024 | 0.998 | 0.350 | 0.673 | 0.112 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1341.4 ± 0.6% | 0.403 | 0.967 | 0.964 | 1.001 | 0.991 | 0.228 | 0.996 | 0.437 | 0.717 | 0.085 | 1.013 |
| qlog records, JSON text sequence | 1467503 | 1147.8 ± 5.1% | 0.692 | 0.943 | 0.985 | 0.990 | 0.988 | 0.223 | 0.990 | 0.412 | 0.694 | 0.105 | 1.013 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.092 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.093 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.082 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.095 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1004.3 ± 4.3% | 1007.1 ± 0.8% | 983.2 ± 0.5% | 260.0 ± 0.4% | 529.0 ± 0.8% | 258.2 ± 2.6% | 0.997 | 1.021 | 3.863 | 1.898 | 3.890 |
| qlog records, JSON text sequence | 1467503 | 828.8 ± 2.9% | 805.4 ± 1.0% | 803.5 ± 2.1% | 223.2 ± 3.7% | 585.8 ± 0.8% | 246.1 ± 1.8% | 1.029 | 1.032 | 3.714 | 1.415 | 3.368 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1341.4 ± 0.6% | 1130.4 ± 2.2% | 898.9 ± 0.5% | 333.3 ± 1.0% | 361.8 ± 1.8% | 313.7 ± 0.7% | 1.187 | 1.492 | 4.025 | 3.707 | 4.277 |
| qlog records, JSON text sequence | 1467503 | 1147.8 ± 5.1% | 860.3 ± 3.5% | 720.5 ± 6.4% | 321.3 ± 0.9% | 389.3 ± 1.3% | 230.0 ± 0.5% | 1.334 | 1.593 | 3.573 | 2.948 | 4.991 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1358.9 ± 1.3% | 1130.4 ± 2.2% | 898.9 ± 0.5% | 333.3 ± 1.0% | 361.8 ± 1.8% | 313.7 ± 0.7% | 1.202 | 1.512 | 4.078 | 3.756 | 4.332 |
| qlog records, JSON text sequence | 1467503 | 1162.5 ± 4.9% | 860.3 ± 3.5% | 720.5 ± 6.4% | 321.3 ± 0.9% | 389.3 ± 1.3% | 230.0 ± 0.5% | 1.351 | 1.613 | 3.619 | 2.986 | 5.055 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 773.8 ± 0.6% | 1007.1 ± 0.8% | 983.2 ± 0.5% | 260.0 ± 0.4% | 529.0 ± 0.8% | 258.2 ± 2.6% | 0.768 | 0.787 | 2.976 | 1.463 | 2.997 |
| qlog records, JSON text sequence | 1467503 | 558.1 ± 1.4% | 805.4 ± 1.0% | 803.5 ± 2.1% | 223.2 ± 3.7% | 585.8 ± 0.8% | 246.1 ± 1.8% | 0.693 | 0.695 | 2.501 | 0.953 | 2.268 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.5 ± 2.0% | 1130.4 ± 2.2% | 898.9 ± 0.5% | 333.3 ± 1.0% | 361.8 ± 1.8% | 313.7 ± 0.7% | 0.851 | 1.070 | 2.885 | 2.657 | 3.065 |
| qlog records, JSON text sequence | 1467503 | 796.2 ± 0.9% | 860.3 ± 3.5% | 720.5 ± 6.4% | 321.3 ± 0.9% | 389.3 ± 1.3% | 230.0 ± 0.5% | 0.926 | 1.105 | 2.478 | 2.045 | 3.462 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.768 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.787 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.693 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.695 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.851 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.

# bench-json, CLDR and qlog alone: head, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1013.6 ± 4.7% | 0.474 | 1.040 | 1.083 | 1.082 | 0.426 | 1.068 | 1.078 | 0.365 | 0.785 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 842.0 ± 0.6% | 0.734 | 1.026 | 1.005 | 1.004 | 0.389 | 1.012 | 1.005 | 0.344 | 0.890 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1326.0 ± 1.4% | 0.439 | 0.980 | 0.979 | 0.998 | 1.017 | 0.230 | 1.015 | 0.444 | 0.721 | 0.086 | 1.009 |
| qlog records, JSON text sequence | 1467503 | 1145.2 ± 0.9% | 0.696 | 0.956 | 1.002 | 1.000 | 0.998 | 0.225 | 1.000 | 0.416 | 0.705 | 0.106 | 1.026 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.083 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.082 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.068 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.078 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1013.6 ± 4.7% | 1013.0 ± 0.4% | 985.3 ± 0.3% | 259.8 ± 0.8% | 528.9 ± 3.9% | 257.0 ± 2.5% | 1.001 | 1.029 | 3.902 | 1.916 | 3.944 |
| qlog records, JSON text sequence | 1467503 | 842.0 ± 0.6% | 806.8 ± 0.8% | 816.1 ± 3.0% | 222.0 ± 3.4% | 589.0 ± 0.7% | 244.7 ± 0.9% | 1.044 | 1.032 | 3.793 | 1.429 | 3.441 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1326.0 ± 1.4% | 1137.6 ± 1.0% | 895.1 ± 0.7% | 331.9 ± 0.4% | 358.4 ± 3.0% | 309.6 ± 1.1% | 1.166 | 1.481 | 3.995 | 3.700 | 4.282 |
| qlog records, JSON text sequence | 1467503 | 1145.2 ± 0.9% | 873.1 ± 0.6% | 722.2 ± 3.0% | 320.8 ± 0.9% | 389.1 ± 1.0% | 228.1 ± 2.5% | 1.312 | 1.586 | 3.570 | 2.943 | 5.021 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.4 ± 0.8% | 1137.6 ± 1.0% | 895.1 ± 0.7% | 331.9 ± 0.4% | 358.4 ± 3.0% | 309.6 ± 1.1% | 1.176 | 1.494 | 4.029 | 3.731 | 4.319 |
| qlog records, JSON text sequence | 1467503 | 1175.1 ± 2.1% | 873.1 ± 0.6% | 722.2 ± 3.0% | 320.8 ± 0.9% | 389.1 ± 1.0% | 228.1 ± 2.5% | 1.346 | 1.627 | 3.663 | 3.020 | 5.152 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 795.5 ± 4.0% | 1013.0 ± 0.4% | 985.3 ± 0.3% | 259.8 ± 0.8% | 528.9 ± 3.9% | 257.0 ± 2.5% | 0.785 | 0.807 | 3.062 | 1.504 | 3.095 |
| qlog records, JSON text sequence | 1467503 | 749.2 ± 3.5% | 806.8 ± 0.8% | 816.1 ± 3.0% | 222.0 ± 3.4% | 589.0 ± 0.7% | 244.7 ± 0.9% | 0.928 | 0.918 | 3.375 | 1.272 | 3.062 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 956.0 ± 0.4% | 1137.6 ± 1.0% | 895.1 ± 0.7% | 331.9 ± 0.4% | 358.4 ± 3.0% | 309.6 ± 1.1% | 0.840 | 1.068 | 2.880 | 2.667 | 3.087 |
| qlog records, JSON text sequence | 1467503 | 807.8 ± 0.6% | 873.1 ± 0.6% | 722.2 ± 3.0% | 320.8 ± 0.9% | 389.1 ± 1.0% | 228.1 ± 2.5% | 0.925 | 1.119 | 2.518 | 2.076 | 3.542 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.785 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.807 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.928 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.918 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.840 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.925 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1031.7 ± 3.3% | 0.478 | 1.014 | 1.046 | 1.009 | 0.409 | 1.026 | 1.020 | 0.359 | 0.792 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 852.9 ± 0.8% | 0.736 | 1.032 | 1.012 | 1.004 | 0.390 | 1.013 | 1.001 | 0.341 | 0.680 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.7 ± 1.5% | 0.441 | 0.981 | 0.978 | 0.995 | 0.995 | 0.234 | 0.995 | 0.444 | 0.720 | 0.086 | 1.014 |
| qlog records, JSON text sequence | 1467503 | 1152.3 ± 1.3% | 0.702 | 0.928 | 0.992 | 0.988 | 0.989 | 0.227 | 0.991 | 0.416 | 0.696 | 0.105 | 1.015 |

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
| CLDR supplemental, 34 texts | 920675 | 1031.7 ± 3.3% | 1021.8 ± 0.3% | 985.6 ± 1.1% | 260.0 ± 0.8% | 530.6 ± 3.6% | 258.4 ± 2.2% | 1.010 | 1.047 | 3.969 | 1.944 | 3.992 |
| qlog records, JSON text sequence | 1467503 | 852.9 ± 0.8% | 811.1 ± 0.2% | 767.3 ± 5.2% | 223.6 ± 4.3% | 587.8 ± 4.7% | 245.7 ± 0.8% | 1.051 | 1.112 | 3.814 | 1.451 | 3.471 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.7 ± 1.5% | 1131.3 ± 1.1% | 898.1 ± 0.9% | 319.6 ± 0.7% | 358.6 ± 0.9% | 313.2 ± 1.0% | 1.181 | 1.487 | 4.179 | 3.724 | 4.264 |
| qlog records, JSON text sequence | 1467503 | 1152.3 ± 1.3% | 868.4 ± 0.7% | 714.4 ± 1.4% | 312.9 ± 0.8% | 391.8 ± 1.3% | 231.0 ± 1.9% | 1.327 | 1.613 | 3.683 | 2.941 | 4.988 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1354.4 ± 1.2% | 1131.3 ± 1.1% | 898.1 ± 0.9% | 319.6 ± 0.7% | 358.6 ± 0.9% | 313.2 ± 1.0% | 1.197 | 1.508 | 4.238 | 3.777 | 4.324 |
| qlog records, JSON text sequence | 1467503 | 1169.3 ± 0.4% | 868.4 ± 0.7% | 714.4 ± 1.4% | 312.9 ± 0.8% | 391.8 ± 1.3% | 231.0 ± 1.9% | 1.346 | 1.637 | 3.737 | 2.985 | 5.061 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 816.7 ± 1.5% | 1021.8 ± 0.3% | 985.6 ± 1.1% | 260.0 ± 0.8% | 530.6 ± 3.6% | 258.4 ± 2.2% | 0.799 | 0.829 | 3.141 | 1.539 | 3.160 |
| qlog records, JSON text sequence | 1467503 | 580.0 ± 0.8% | 811.1 ± 0.2% | 767.3 ± 5.2% | 223.6 ± 4.3% | 587.8 ± 4.7% | 245.7 ± 0.8% | 0.715 | 0.756 | 2.593 | 0.987 | 2.360 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.6 ± 1.1% | 1131.3 ± 1.1% | 898.1 ± 0.9% | 319.6 ± 0.7% | 358.6 ± 0.9% | 313.2 ± 1.0% | 0.850 | 1.071 | 3.009 | 2.681 | 3.070 |
| qlog records, JSON text sequence | 1467503 | 801.5 ± 0.6% | 868.4 ± 0.7% | 714.4 ± 1.4% | 312.9 ± 0.8% | 391.8 ± 1.3% | 231.0 ± 1.9% | 0.923 | 1.122 | 2.562 | 2.046 | 3.470 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.799 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.829 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.715 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.756 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.850 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.923 of simdjson.

# bench-json, CLDR and qlog alone: null, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1012.8 ± 3.8% | 0.474 | 1.035 | 1.085 | 1.087 | 0.425 | 1.068 | 1.082 | 0.366 | 0.764 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 831.3 ± 3.5% | 0.745 | 1.034 | 1.018 | 1.001 | 0.392 | 1.025 | 1.002 | 0.350 | 0.676 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.4 ± 1.5% | 0.404 | 0.972 | 0.957 | 1.007 | 1.001 | 0.228 | 1.000 | 0.433 | 0.715 | 0.085 | 1.010 |
| qlog records, JSON text sequence | 1467503 | 1145.9 ± 0.7% | 0.692 | 0.943 | 0.986 | 0.993 | 0.989 | 0.222 | 0.991 | 0.413 | 0.694 | 0.105 | 1.015 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.085 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.087 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.068 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.082 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1012.8 ± 3.8% | 976.6 ± 0.4% | 983.3 ± 0.9% | 260.6 ± 0.5% | 530.7 ± 0.5% | 258.9 ± 2.2% | 1.037 | 1.030 | 3.887 | 1.908 | 3.912 |
| qlog records, JSON text sequence | 1467503 | 831.3 ± 3.5% | 764.2 ± 0.3% | 822.3 ± 5.5% | 224.2 ± 0.5% | 588.6 ± 0.5% | 247.0 ± 2.3% | 1.088 | 1.011 | 3.708 | 1.412 | 3.365 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.4 ± 1.5% | 1139.4 ± 0.5% | 894.3 ± 5.8% | 333.6 ± 0.3% | 366.8 ± 1.7% | 314.8 ± 4.5% | 1.174 | 1.495 | 4.009 | 3.646 | 4.248 |
| qlog records, JSON text sequence | 1467503 | 1145.9 ± 0.7% | 862.3 ± 0.4% | 717.0 ± 0.9% | 320.8 ± 0.5% | 392.8 ± 0.7% | 231.4 ± 2.1% | 1.329 | 1.598 | 3.572 | 2.918 | 4.952 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1350.7 ± 4.6% | 1139.4 ± 0.5% | 894.3 ± 5.8% | 333.6 ± 0.3% | 366.8 ± 1.7% | 314.8 ± 4.5% | 1.185 | 1.510 | 4.049 | 3.683 | 4.291 |
| qlog records, JSON text sequence | 1467503 | 1163.2 ± 0.8% | 862.3 ± 0.4% | 717.0 ± 0.9% | 320.8 ± 0.5% | 392.8 ± 0.7% | 231.4 ± 2.1% | 1.349 | 1.622 | 3.625 | 2.962 | 5.026 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 774.2 ± 0.2% | 976.6 ± 0.4% | 983.3 ± 0.9% | 260.6 ± 0.5% | 530.7 ± 0.5% | 258.9 ± 2.2% | 0.793 | 0.787 | 2.971 | 1.459 | 2.991 |
| qlog records, JSON text sequence | 1467503 | 561.6 ± 0.5% | 764.2 ± 0.3% | 822.3 ± 5.5% | 224.2 ± 0.5% | 588.6 ± 0.5% | 247.0 ± 2.3% | 0.735 | 0.683 | 2.505 | 0.954 | 2.274 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 956.8 ± 5.0% | 1139.4 ± 0.5% | 894.3 ± 5.8% | 333.6 ± 0.3% | 366.8 ± 1.7% | 314.8 ± 4.5% | 0.840 | 1.070 | 2.868 | 2.609 | 3.039 |
| qlog records, JSON text sequence | 1467503 | 795.1 ± 0.3% | 862.3 ± 0.4% | 717.0 ± 0.9% | 320.8 ± 0.5% | 392.8 ± 0.7% | 231.4 ± 2.1% | 0.922 | 1.109 | 2.478 | 2.024 | 3.436 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.793 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.787 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.735 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.683 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.840 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.922 of simdjson.

# bench-json, CLDR and qlog alone: head, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1043.5 ± 3.5% | 0.462 | 1.014 | 1.053 | 1.051 | 0.412 | 1.038 | 1.048 | 0.355 | 0.765 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 839.7 ± 0.3% | 0.736 | 1.027 | 1.005 | 1.007 | 0.391 | 1.014 | 1.006 | 0.349 | 0.891 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1318.1 ± 6.5% | 0.444 | 0.981 | 0.983 | 1.006 | 1.018 | 0.225 | 1.026 | 0.446 | 0.723 | 0.087 | 1.030 |
| qlog records, JSON text sequence | 1467503 | 1145.9 ± 2.2% | 0.694 | 0.956 | 0.997 | 1.001 | 1.001 | 0.219 | 1.001 | 0.415 | 0.705 | 0.106 | 1.027 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.053 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.051 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1043.5 ± 3.5% | 1012.6 ± 1.1% | 984.7 ± 1.0% | 260.5 ± 2.5% | 532.2 ± 0.5% | 255.4 ± 3.3% | 1.031 | 1.060 | 4.006 | 1.961 | 4.085 |
| qlog records, JSON text sequence | 1467503 | 839.7 ± 0.3% | 810.8 ± 0.1% | 803.0 ± 4.2% | 222.6 ± 2.0% | 589.2 ± 1.1% | 245.5 ± 6.3% | 1.036 | 1.046 | 3.772 | 1.425 | 3.421 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1318.1 ± 6.5% | 1137.4 ± 1.7% | 896.6 ± 0.3% | 332.1 ± 1.1% | 360.6 ± 2.8% | 309.8 ± 0.3% | 1.159 | 1.470 | 3.969 | 3.655 | 4.255 |
| qlog records, JSON text sequence | 1467503 | 1145.9 ± 2.2% | 872.6 ± 1.2% | 726.6 ± 0.5% | 322.7 ± 0.7% | 390.3 ± 2.2% | 232.8 ± 0.9% | 1.313 | 1.577 | 3.551 | 2.936 | 4.922 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1357.9 ± 4.6% | 1137.4 ± 1.7% | 896.6 ± 0.3% | 332.1 ± 1.1% | 360.6 ± 2.8% | 309.8 ± 0.3% | 1.194 | 1.515 | 4.088 | 3.765 | 4.383 |
| qlog records, JSON text sequence | 1467503 | 1176.7 ± 1.1% | 872.6 ± 1.2% | 726.6 ± 0.5% | 322.7 ± 0.7% | 390.3 ± 2.2% | 232.8 ± 0.9% | 1.348 | 1.619 | 3.646 | 3.015 | 5.054 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 797.8 ± 3.4% | 1012.6 ± 1.1% | 984.7 ± 1.0% | 260.5 ± 2.5% | 532.2 ± 0.5% | 255.4 ± 3.3% | 0.788 | 0.810 | 3.063 | 1.499 | 3.123 |
| qlog records, JSON text sequence | 1467503 | 748.3 ± 0.6% | 810.8 ± 0.1% | 803.0 ± 4.2% | 222.6 ± 2.0% | 589.2 ± 1.1% | 245.5 ± 6.3% | 0.923 | 0.932 | 3.361 | 1.270 | 3.048 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 952.7 ± 1.0% | 1137.4 ± 1.7% | 896.6 ± 0.3% | 332.1 ± 1.1% | 360.6 ± 2.8% | 309.8 ± 0.3% | 0.838 | 1.063 | 2.868 | 2.642 | 3.075 |
| qlog records, JSON text sequence | 1467503 | 808.2 ± 1.0% | 872.6 ± 1.2% | 726.6 ± 0.5% | 322.7 ± 0.7% | 390.3 ± 2.2% | 232.8 ± 0.9% | 0.926 | 1.112 | 2.504 | 2.071 | 3.471 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.788 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.810 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.923 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.932 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.838 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1014.2 ± 5.7% | 0.488 | 1.028 | 1.048 | 1.035 | 0.418 | 1.056 | 1.041 | 0.365 | 0.807 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 853.5 ± 1.2% | 0.734 | 1.030 | 1.012 | 0.997 | 0.390 | 1.015 | 0.995 | 0.341 | 0.683 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.2 ± 1.3% | 0.441 | 0.977 | 0.980 | 0.996 | 0.993 | 0.235 | 0.994 | 0.441 | 0.718 | 0.086 | 1.018 |
| qlog records, JSON text sequence | 1467503 | 1149.0 ± 1.0% | 0.702 | 0.929 | 0.995 | 0.992 | 0.993 | 0.230 | 0.994 | 0.414 | 0.698 | 0.105 | 1.019 |

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
| CLDR supplemental, 34 texts | 920675 | 1014.2 ± 5.7% | 1010.8 ± 0.7% | 984.1 ± 3.2% | 260.3 ± 0.4% | 531.9 ± 0.2% | 258.1 ± 2.7% | 1.003 | 1.031 | 3.897 | 1.907 | 3.929 |
| qlog records, JSON text sequence | 1467503 | 853.5 ± 1.2% | 810.7 ± 0.9% | 824.2 ± 3.3% | 216.6 ± 3.8% | 588.5 ± 0.7% | 244.9 ± 1.6% | 1.053 | 1.036 | 3.941 | 1.450 | 3.484 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.2 ± 1.3% | 1110.1 ± 0.7% | 900.1 ± 1.7% | 319.4 ± 1.2% | 355.0 ± 1.6% | 313.7 ± 0.6% | 1.205 | 1.485 | 4.187 | 3.767 | 4.262 |
| qlog records, JSON text sequence | 1467503 | 1149.0 ± 1.0% | 869.6 ± 1.5% | 723.8 ± 0.5% | 318.5 ± 0.7% | 387.0 ± 6.7% | 230.4 ± 6.2% | 1.321 | 1.587 | 3.608 | 2.969 | 4.986 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1361.4 ± 1.9% | 1110.1 ± 0.7% | 900.1 ± 1.7% | 319.4 ± 1.2% | 355.0 ± 1.6% | 313.7 ± 0.6% | 1.226 | 1.512 | 4.263 | 3.835 | 4.340 |
| qlog records, JSON text sequence | 1467503 | 1171.2 ± 0.6% | 869.6 ± 1.5% | 723.8 ± 0.5% | 318.5 ± 0.7% | 387.0 ± 6.7% | 230.4 ± 6.2% | 1.347 | 1.618 | 3.678 | 3.026 | 5.082 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 818.4 ± 3.0% | 1010.8 ± 0.7% | 984.1 ± 3.2% | 260.3 ± 0.4% | 531.9 ± 0.2% | 258.1 ± 2.7% | 0.810 | 0.832 | 3.144 | 1.539 | 3.170 |
| qlog records, JSON text sequence | 1467503 | 583.2 ± 2.4% | 810.7 ± 0.9% | 824.2 ± 3.3% | 216.6 ± 3.8% | 588.5 ± 0.7% | 244.9 ± 1.6% | 0.719 | 0.708 | 2.693 | 0.991 | 2.381 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 960.6 ± 1.6% | 1110.1 ± 0.7% | 900.1 ± 1.7% | 319.4 ± 1.2% | 355.0 ± 1.6% | 313.7 ± 0.6% | 0.865 | 1.067 | 3.008 | 2.706 | 3.062 |
| qlog records, JSON text sequence | 1467503 | 801.9 ± 0.6% | 869.6 ± 1.5% | 723.8 ± 0.5% | 318.5 ± 0.7% | 387.0 ± 6.7% | 230.4 ± 6.2% | 0.922 | 1.108 | 2.518 | 2.072 | 3.480 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.810 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.832 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.719 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.708 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.865 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.922 of simdjson.

# bench-json, CLDR and qlog alone: null, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1011.8 ± 5.5% | 0.475 | 1.050 | 1.086 | 1.085 | 0.424 | 1.071 | 1.083 | 0.366 | 0.765 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 834.4 ± 0.7% | 0.739 | 1.031 | 1.012 | 0.996 | 0.392 | 1.021 | 0.996 | 0.346 | 0.671 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.9 ± 0.7% | 0.405 | 0.977 | 0.967 | 1.006 | 1.001 | 0.229 | 0.999 | 0.441 | 0.721 | 0.085 | 1.020 |
| qlog records, JSON text sequence | 1467503 | 1145.2 ± 1.9% | 0.694 | 0.942 | 0.984 | 0.991 | 0.988 | 0.224 | 0.988 | 0.415 | 0.696 | 0.105 | 1.007 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.086 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.085 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.071 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.083 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1011.8 ± 5.5% | 990.7 ± 0.4% | 968.6 ± 0.8% | 259.8 ± 1.4% | 530.0 ± 0.5% | 260.2 ± 2.8% | 1.021 | 1.045 | 3.894 | 1.909 | 3.889 |
| qlog records, JSON text sequence | 1467503 | 834.4 ± 0.7% | 796.5 ± 0.5% | 775.4 ± 3.6% | 223.4 ± 0.6% | 587.6 ± 4.8% | 246.0 ± 2.5% | 1.048 | 1.076 | 3.734 | 1.420 | 3.392 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.9 ± 0.7% | 1137.2 ± 1.0% | 894.3 ± 0.7% | 331.2 ± 0.6% | 365.9 ± 0.6% | 314.9 ± 0.9% | 1.175 | 1.494 | 4.034 | 3.652 | 4.243 |
| qlog records, JSON text sequence | 1467503 | 1145.2 ± 1.9% | 858.8 ± 6.8% | 721.2 ± 0.6% | 321.7 ± 0.4% | 379.2 ± 1.6% | 230.1 ± 0.6% | 1.333 | 1.588 | 3.559 | 3.020 | 4.976 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1362.7 ± 0.5% | 1137.2 ± 1.0% | 894.3 ± 0.7% | 331.2 ± 0.6% | 365.9 ± 0.6% | 314.9 ± 0.9% | 1.198 | 1.524 | 4.115 | 3.725 | 4.327 |
| qlog records, JSON text sequence | 1467503 | 1153.1 ± 4.9% | 858.8 ± 6.8% | 721.2 ± 0.6% | 321.7 ± 0.4% | 379.2 ± 1.6% | 230.1 ± 0.6% | 1.343 | 1.599 | 3.584 | 3.041 | 5.010 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 774.4 ± 1.0% | 990.7 ± 0.4% | 968.6 ± 0.8% | 259.8 ± 1.4% | 530.0 ± 0.5% | 260.2 ± 2.8% | 0.782 | 0.799 | 2.981 | 1.461 | 2.976 |
| qlog records, JSON text sequence | 1467503 | 559.9 ± 1.8% | 796.5 ± 0.5% | 775.4 ± 3.6% | 223.4 ± 0.6% | 587.6 ± 4.8% | 246.0 ± 2.5% | 0.703 | 0.722 | 2.506 | 0.953 | 2.276 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 963.5 ± 1.0% | 1137.2 ± 1.0% | 894.3 ± 0.7% | 331.2 ± 0.6% | 365.9 ± 0.6% | 314.9 ± 0.9% | 0.847 | 1.077 | 2.910 | 2.634 | 3.060 |
| qlog records, JSON text sequence | 1467503 | 797.5 ± 0.6% | 858.8 ± 6.8% | 721.2 ± 0.6% | 321.7 ± 0.4% | 379.2 ± 1.6% | 230.1 ± 0.6% | 0.929 | 1.106 | 2.479 | 2.103 | 3.465 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.782 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.799 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.703 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.722 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.847 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.929 of simdjson.

# bench-json, CLDR and qlog alone: head, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1041.9 ± 5.4% | 0.463 | 1.007 | 1.059 | 1.053 | 0.412 | 1.043 | 1.051 | 0.355 | 0.772 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 839.5 ± 5.4% | 0.733 | 1.025 | 1.009 | 1.003 | 0.388 | 1.013 | 1.003 | 0.344 | 0.890 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.9 ± 1.4% | 0.437 | 0.973 | 0.976 | 0.995 | 1.016 | 0.228 | 1.013 | 0.441 | 0.720 | 0.086 | 1.013 |
| qlog records, JSON text sequence | 1467503 | 1160.3 ± 0.4% | 0.690 | 0.945 | 0.986 | 0.986 | 0.989 | 0.222 | 0.990 | 0.412 | 0.696 | 0.105 | 1.012 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.059 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1041.9 ± 5.4% | 985.8 ± 0.2% | 970.0 ± 0.9% | 260.5 ± 0.3% | 532.4 ± 0.6% | 257.5 ± 2.1% | 1.057 | 1.074 | 3.999 | 1.957 | 4.046 |
| qlog records, JSON text sequence | 1467503 | 839.5 ± 5.4% | 793.3 ± 0.5% | 812.0 ± 1.6% | 223.6 ± 0.9% | 589.0 ± 5.3% | 243.7 ± 4.0% | 1.058 | 1.034 | 3.755 | 1.425 | 3.445 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.9 ± 1.4% | 1137.9 ± 0.7% | 897.0 ± 5.6% | 331.6 ± 1.4% | 363.5 ± 2.1% | 310.6 ± 5.0% | 1.172 | 1.487 | 4.023 | 3.669 | 4.295 |
| qlog records, JSON text sequence | 1467503 | 1160.3 ± 0.4% | 875.4 ± 0.2% | 721.9 ± 0.4% | 322.4 ± 1.3% | 387.8 ± 0.8% | 234.1 ± 1.3% | 1.325 | 1.607 | 3.598 | 2.992 | 4.956 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1351.5 ± 4.5% | 1137.9 ± 0.7% | 897.0 ± 5.6% | 331.6 ± 1.4% | 363.5 ± 2.1% | 310.6 ± 5.0% | 1.188 | 1.507 | 4.076 | 3.718 | 4.352 |
| qlog records, JSON text sequence | 1467503 | 1174.7 ± 2.3% | 875.4 ± 0.2% | 721.9 ± 0.4% | 322.4 ± 1.3% | 387.8 ± 0.8% | 234.1 ± 1.3% | 1.342 | 1.627 | 3.643 | 3.029 | 5.018 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 804.1 ± 1.4% | 985.8 ± 0.2% | 970.0 ± 0.9% | 260.5 ± 0.3% | 532.4 ± 0.6% | 257.5 ± 2.1% | 0.816 | 0.829 | 3.086 | 1.510 | 3.123 |
| qlog records, JSON text sequence | 1467503 | 746.8 ± 0.8% | 793.3 ± 0.5% | 812.0 ± 1.6% | 223.6 ± 0.9% | 589.0 ± 5.3% | 243.7 ± 4.0% | 0.941 | 0.920 | 3.340 | 1.268 | 3.064 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 959.9 ± 1.3% | 1137.9 ± 0.7% | 897.0 ± 5.6% | 331.6 ± 1.4% | 363.5 ± 2.1% | 310.6 ± 5.0% | 0.844 | 1.070 | 2.895 | 2.641 | 3.091 |
| qlog records, JSON text sequence | 1467503 | 808.1 ± 0.3% | 875.4 ± 0.2% | 721.9 ± 0.4% | 322.4 ± 1.3% | 387.8 ± 0.8% | 234.1 ± 1.3% | 0.923 | 1.119 | 2.506 | 2.084 | 3.452 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.816 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.829 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.941 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.920 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.844 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.923 of simdjson.
