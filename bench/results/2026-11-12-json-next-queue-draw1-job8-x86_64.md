# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1043.2 ± 5.0% | 0.469 | 0.999 | 1.007 | 1.010 | 0.405 | 0.987 | 0.987 | 0.355 | 0.782 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 854.0 ± 1.0% | 0.735 | 1.034 | 1.019 | 1.002 | 0.391 | 1.010 | 0.999 | 0.341 | 0.686 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1322.0 ± 3.1% | 0.447 | 0.989 | 0.983 | 1.012 | 1.008 | 0.238 | 1.004 | 0.450 | 0.731 | 0.087 | 1.031 |
| qlog records, JSON text sequence | 1467503 | 1164.9 ± 0.3% | 0.699 | 0.922 | 0.985 | 0.980 | 0.986 | 0.227 | 0.984 | 0.407 | 0.691 | 0.104 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1043.2 ± 5.0% | 954.2 ± 1.1% | 982.8 ± 3.0% | 260.2 ± 3.6% | 529.8 ± 0.7% | 254.9 ± 2.9% | 1.093 | 1.061 | 4.009 | 1.969 | 4.093 |
| qlog records, JSON text sequence | 1467503 | 854.0 ± 1.0% | 804.0 ± 0.3% | 819.7 ± 1.7% | 218.5 ± 1.5% | 589.0 ± 0.4% | 244.7 ± 0.6% | 1.062 | 1.042 | 3.908 | 1.450 | 3.490 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1322.0 ± 3.1% | 1135.0 ± 0.3% | 899.3 ± 0.2% | 319.5 ± 0.8% | 352.0 ± 2.9% | 313.0 ± 2.3% | 1.165 | 1.470 | 4.137 | 3.755 | 4.223 |
| qlog records, JSON text sequence | 1467503 | 1164.9 ± 0.3% | 868.9 ± 0.5% | 719.8 ± 0.3% | 319.3 ± 1.0% | 391.6 ± 0.7% | 230.8 ± 4.5% | 1.341 | 1.618 | 3.648 | 2.974 | 5.047 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1362.6 ± 0.9% | 1135.0 ± 0.3% | 899.3 ± 0.2% | 319.5 ± 0.8% | 352.0 ± 2.9% | 313.0 ± 2.3% | 1.201 | 1.515 | 4.264 | 3.871 | 4.353 |
| qlog records, JSON text sequence | 1467503 | 1176.8 ± 0.3% | 868.9 ± 0.5% | 719.8 ± 0.3% | 319.3 ± 1.0% | 391.6 ± 0.7% | 230.8 ± 4.5% | 1.354 | 1.635 | 3.685 | 3.005 | 5.099 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 815.8 ± 2.8% | 954.2 ± 1.1% | 982.8 ± 3.0% | 260.2 ± 3.6% | 529.8 ± 0.7% | 254.9 ± 2.9% | 0.855 | 0.830 | 3.135 | 1.540 | 3.200 |
| qlog records, JSON text sequence | 1467503 | 585.6 ± 0.4% | 804.0 ± 0.3% | 819.7 ± 1.7% | 218.5 ± 1.5% | 589.0 ± 0.4% | 244.7 ± 0.6% | 0.728 | 0.714 | 2.680 | 0.994 | 2.393 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 966.5 ± 0.7% | 1135.0 ± 0.3% | 899.3 ± 0.2% | 319.5 ± 0.8% | 352.0 ± 2.9% | 313.0 ± 2.3% | 0.852 | 1.075 | 3.025 | 2.745 | 3.088 |
| qlog records, JSON text sequence | 1467503 | 805.2 ± 0.5% | 868.9 ± 0.5% | 719.8 ± 0.3% | 319.3 ± 1.0% | 391.6 ± 0.7% | 230.8 ± 4.5% | 0.927 | 1.119 | 2.522 | 2.056 | 3.489 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.855 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.830 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.728 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.714 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.852 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.927 of simdjson.

# bench-json, CLDR and qlog alone: null, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1003.3 ± 3.1% | 0.478 | 1.044 | 1.094 | 1.094 | 0.428 | 1.081 | 1.088 | 0.369 | 0.773 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 835.3 ± 0.2% | 0.742 | 1.031 | 1.012 | 0.999 | 0.394 | 1.021 | 0.999 | 0.347 | 0.672 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.2 ± 1.5% | 0.401 | 0.966 | 0.959 | 1.013 | 0.994 | 0.228 | 0.992 | 0.440 | 0.716 | 0.086 | 1.007 |
| qlog records, JSON text sequence | 1467503 | 1162.7 ± 0.6% | 0.688 | 0.945 | 0.983 | 0.987 | 0.986 | 0.221 | 0.985 | 0.412 | 0.695 | 0.104 | 1.012 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.094 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.094 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.081 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.088 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1003.3 ± 3.1% | 988.9 ± 1.6% | 972.9 ± 1.2% | 260.5 ± 2.3% | 530.8 ± 3.4% | 258.2 ± 3.2% | 1.015 | 1.031 | 3.851 | 1.890 | 3.885 |
| qlog records, JSON text sequence | 1467503 | 835.3 ± 0.2% | 798.5 ± 0.2% | 783.1 ± 2.5% | 216.7 ± 4.5% | 586.7 ± 0.8% | 241.7 ± 2.1% | 1.046 | 1.067 | 3.854 | 1.424 | 3.455 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.2 ± 1.5% | 1134.2 ± 0.7% | 896.6 ± 0.6% | 332.1 ± 4.8% | 364.3 ± 2.9% | 312.9 ± 5.2% | 1.181 | 1.494 | 4.032 | 3.676 | 4.280 |
| qlog records, JSON text sequence | 1467503 | 1162.7 ± 0.6% | 873.0 ± 0.2% | 702.9 ± 1.1% | 322.9 ± 1.5% | 392.4 ± 0.6% | 228.5 ± 2.2% | 1.332 | 1.654 | 3.601 | 2.963 | 5.088 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1349.0 ± 1.1% | 1134.2 ± 0.7% | 896.6 ± 0.6% | 332.1 ± 4.8% | 364.3 ± 2.9% | 312.9 ± 5.2% | 1.189 | 1.505 | 4.062 | 3.703 | 4.311 |
| qlog records, JSON text sequence | 1467503 | 1177.1 ± 2.3% | 873.0 ± 0.2% | 702.9 ± 1.1% | 322.9 ± 1.5% | 392.4 ± 0.6% | 228.5 ± 2.2% | 1.348 | 1.675 | 3.645 | 3.000 | 5.151 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 775.4 ± 0.7% | 988.9 ± 1.6% | 972.9 ± 1.2% | 260.5 ± 2.3% | 530.8 ± 3.4% | 258.2 ± 3.2% | 0.784 | 0.797 | 2.976 | 1.461 | 3.003 |
| qlog records, JSON text sequence | 1467503 | 561.5 ± 1.1% | 798.5 ± 0.2% | 783.1 ± 2.5% | 216.7 ± 4.5% | 586.7 ± 0.8% | 241.7 ± 2.1% | 0.703 | 0.717 | 2.591 | 0.957 | 2.323 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 959.3 ± 0.9% | 1134.2 ± 0.7% | 896.6 ± 0.6% | 332.1 ± 4.8% | 364.3 ± 2.9% | 312.9 ± 5.2% | 0.846 | 1.070 | 2.888 | 2.634 | 3.066 |
| qlog records, JSON text sequence | 1467503 | 807.9 ± 0.8% | 873.0 ± 0.2% | 702.9 ± 1.1% | 322.9 ± 1.5% | 392.4 ± 0.6% | 228.5 ± 2.2% | 0.925 | 1.149 | 2.502 | 2.059 | 3.536 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.784 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.797 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.703 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.717 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.846 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.925 of simdjson.

# bench-json, CLDR and qlog alone: head, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 945.2 ± 0.9% | 0.492 | 1.051 | 1.092 | 1.094 | 0.442 | 1.082 | 1.094 | 0.392 | 0.859 | 0.104 |
| qlog records, JSON text sequence | 1467503 | 839.1 ± 2.6% | 0.737 | 1.027 | 1.009 | 1.006 | 0.392 | 1.008 | 1.007 | 0.346 | 0.898 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.9 ± 1.5% | 0.437 | 0.979 | 0.969 | 1.002 | 1.013 | 0.228 | 1.013 | 0.440 | 0.717 | 0.085 | 1.019 |
| qlog records, JSON text sequence | 1467503 | 1158.4 ± 5.5% | 0.693 | 0.950 | 0.984 | 0.992 | 0.993 | 0.221 | 0.994 | 0.410 | 0.697 | 0.104 | 1.016 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J5 UTF-8 vectors off runs at 1.051 of all on.
- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.092 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.094 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.082 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 945.2 ± 0.9% | 739.8 ± 1.7% | 983.1 ± 0.4% | 258.8 ± 0.3% | 530.7 ± 0.5% | 255.6 ± 3.4% | 1.278 | 0.961 | 3.653 | 1.781 | 3.698 |
| qlog records, JSON text sequence | 1467503 | 839.1 ± 2.6% | 685.1 ± 0.6% | 819.2 ± 2.0% | 220.9 ± 3.8% | 587.7 ± 0.8% | 243.6 ± 2.2% | 1.225 | 1.024 | 3.798 | 1.428 | 3.445 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.9 ± 1.5% | 1136.1 ± 0.7% | 897.3 ± 0.6% | 332.6 ± 0.6% | 358.0 ± 2.7% | 311.5 ± 0.8% | 1.177 | 1.490 | 4.019 | 3.735 | 4.292 |
| qlog records, JSON text sequence | 1467503 | 1158.4 ± 5.5% | 865.9 ± 6.6% | 723.8 ± 0.6% | 322.9 ± 0.8% | 391.9 ± 0.5% | 232.3 ± 1.0% | 1.338 | 1.600 | 3.587 | 2.956 | 4.987 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1362.5 ± 1.4% | 1136.1 ± 0.7% | 897.3 ± 0.6% | 332.6 ± 0.6% | 358.0 ± 2.7% | 311.5 ± 0.8% | 1.199 | 1.519 | 4.096 | 3.806 | 4.374 |
| qlog records, JSON text sequence | 1467503 | 1176.8 ± 5.0% | 865.9 ± 6.6% | 723.8 ± 0.6% | 322.9 ± 0.8% | 391.9 ± 0.5% | 232.3 ± 1.0% | 1.359 | 1.626 | 3.644 | 3.003 | 5.067 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 812.1 ± 1.6% | 739.8 ± 1.7% | 983.1 ± 0.4% | 258.8 ± 0.3% | 530.7 ± 0.5% | 255.6 ± 3.4% | 1.098 | 0.826 | 3.139 | 1.530 | 3.178 |
| qlog records, JSON text sequence | 1467503 | 753.1 ± 5.5% | 685.1 ± 0.6% | 819.2 ± 2.0% | 220.9 ± 3.8% | 587.7 ± 0.8% | 243.6 ± 2.2% | 1.099 | 0.919 | 3.409 | 1.282 | 3.092 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 959.0 ± 3.7% | 1136.1 ± 0.7% | 897.3 ± 0.6% | 332.6 ± 0.6% | 358.0 ± 2.7% | 311.5 ± 0.8% | 0.844 | 1.069 | 2.883 | 2.679 | 3.079 |
| qlog records, JSON text sequence | 1467503 | 806.9 ± 0.7% | 865.9 ± 6.6% | 723.8 ± 0.6% | 322.9 ± 0.8% | 391.9 ± 0.5% | 232.3 ± 1.0% | 0.932 | 1.115 | 2.499 | 2.059 | 3.474 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.826 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.919 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.844 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.932 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1045.5 ± 6.1% | 0.470 | 1.009 | 1.016 | 1.029 | 0.406 | 1.022 | 1.028 | 0.354 | 0.777 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 853.7 ± 2.4% | 0.735 | 1.032 | 1.014 | 1.000 | 0.391 | 1.013 | 0.999 | 0.341 | 0.684 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1327.7 ± 1.6% | 0.442 | 0.982 | 0.985 | 1.001 | 1.002 | 0.237 | 1.007 | 0.446 | 0.716 | 0.086 | 1.030 |
| qlog records, JSON text sequence | 1467503 | 1166.7 ± 5.2% | 0.699 | 0.920 | 0.983 | 0.979 | 0.982 | 0.226 | 0.983 | 0.408 | 0.690 | 0.104 | 1.009 |

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
| CLDR supplemental, 34 texts | 920675 | 1045.5 ± 6.1% | 1018.0 ± 2.6% | 981.4 ± 0.5% | 259.8 ± 4.9% | 531.2 ± 0.3% | 258.2 ± 6.1% | 1.027 | 1.065 | 4.024 | 1.968 | 4.050 |
| qlog records, JSON text sequence | 1467503 | 853.7 ± 2.4% | 813.2 ± 0.8% | 815.3 ± 1.1% | 216.4 ± 5.5% | 589.0 ± 1.5% | 242.6 ± 1.3% | 1.050 | 1.047 | 3.944 | 1.449 | 3.519 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1327.7 ± 1.6% | 1128.6 ± 1.9% | 895.9 ± 5.5% | 319.7 ± 0.7% | 356.1 ± 4.5% | 309.8 ± 0.5% | 1.176 | 1.482 | 4.153 | 3.729 | 4.285 |
| qlog records, JSON text sequence | 1467503 | 1166.7 ± 5.2% | 865.1 ± 2.6% | 723.3 ± 3.8% | 319.5 ± 1.1% | 390.1 ± 0.3% | 229.7 ± 2.3% | 1.349 | 1.613 | 3.652 | 2.991 | 5.078 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1367.5 ± 0.4% | 1128.6 ± 1.9% | 895.9 ± 5.5% | 319.7 ± 0.7% | 356.1 ± 4.5% | 309.8 ± 0.5% | 1.212 | 1.526 | 4.278 | 3.841 | 4.413 |
| qlog records, JSON text sequence | 1467503 | 1177.1 ± 0.3% | 865.1 ± 2.6% | 723.3 ± 3.8% | 319.5 ± 1.1% | 390.1 ± 0.3% | 229.7 ± 2.3% | 1.361 | 1.627 | 3.684 | 3.017 | 5.123 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 812.1 ± 5.5% | 1018.0 ± 2.6% | 981.4 ± 0.5% | 259.8 ± 4.9% | 531.2 ± 0.3% | 258.2 ± 6.1% | 0.798 | 0.827 | 3.126 | 1.529 | 3.146 |
| qlog records, JSON text sequence | 1467503 | 583.6 ± 2.3% | 813.2 ± 0.8% | 815.3 ± 1.1% | 216.4 ± 5.5% | 589.0 ± 1.5% | 242.6 ± 1.3% | 0.718 | 0.716 | 2.696 | 0.991 | 2.405 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 950.2 ± 0.9% | 1128.6 ± 1.9% | 895.9 ± 5.5% | 319.7 ± 0.7% | 356.1 ± 4.5% | 309.8 ± 0.5% | 0.842 | 1.061 | 2.972 | 2.669 | 3.067 |
| qlog records, JSON text sequence | 1467503 | 804.9 ± 0.5% | 865.1 ± 2.6% | 723.3 ± 3.8% | 319.5 ± 1.1% | 390.1 ± 0.3% | 229.7 ± 2.3% | 0.930 | 1.113 | 2.519 | 2.063 | 3.503 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.798 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.827 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.718 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.716 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.842 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.930 of simdjson.

# bench-json, CLDR and qlog alone: null, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1017.9 ± 6.0% | 0.471 | 1.043 | 1.081 | 1.078 | 0.421 | 1.070 | 1.073 | 0.364 | 0.763 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 834.2 ± 12.6% | 0.742 | 1.023 | 1.014 | 0.998 | 0.392 | 1.019 | 0.999 | 0.345 | 0.668 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.5 ± 1.0% | 0.402 | 0.966 | 0.963 | 1.011 | 0.994 | 0.228 | 0.996 | 0.440 | 0.714 | 0.086 | 1.012 |
| qlog records, JSON text sequence | 1467503 | 1162.2 ± 0.2% | 0.689 | 0.946 | 0.986 | 0.990 | 0.988 | 0.222 | 0.989 | 0.413 | 0.696 | 0.104 | 1.014 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.081 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.078 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.070 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.073 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1017.9 ± 6.0% | 982.4 ± 0.8% | 967.0 ± 0.4% | 260.3 ± 0.2% | 532.2 ± 0.3% | 257.6 ± 2.4% | 1.036 | 1.053 | 3.910 | 1.913 | 3.951 |
| qlog records, JSON text sequence | 1467503 | 834.2 ± 12.6% | 794.4 ± 0.4% | 791.1 ± 4.4% | 223.6 ± 1.4% | 590.1 ± 0.6% | 242.3 ± 7.7% | 1.050 | 1.054 | 3.730 | 1.413 | 3.443 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.5 ± 1.0% | 1134.1 ± 0.3% | 896.1 ± 0.9% | 331.8 ± 0.5% | 365.4 ± 0.3% | 311.6 ± 1.1% | 1.178 | 1.492 | 4.028 | 3.657 | 4.289 |
| qlog records, JSON text sequence | 1467503 | 1162.2 ± 0.2% | 872.8 ± 3.5% | 728.3 ± 1.0% | 321.7 ± 1.3% | 389.9 ± 1.9% | 232.1 ± 2.4% | 1.332 | 1.596 | 3.613 | 2.981 | 5.008 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1352.1 ± 0.9% | 1134.1 ± 0.3% | 896.1 ± 0.9% | 331.8 ± 0.5% | 365.4 ± 0.3% | 311.6 ± 1.1% | 1.192 | 1.509 | 4.075 | 3.700 | 4.339 |
| qlog records, JSON text sequence | 1467503 | 1178.8 ± 0.3% | 872.8 ± 3.5% | 728.3 ± 1.0% | 321.7 ± 1.3% | 389.9 ± 1.9% | 232.1 ± 2.4% | 1.351 | 1.619 | 3.665 | 3.024 | 5.080 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 776.3 ± 0.4% | 982.4 ± 0.8% | 967.0 ± 0.4% | 260.3 ± 0.2% | 532.2 ± 0.3% | 257.6 ± 2.4% | 0.790 | 0.803 | 2.982 | 1.459 | 3.013 |
| qlog records, JSON text sequence | 1467503 | 557.4 ± 1.5% | 794.4 ± 0.4% | 791.1 ± 4.4% | 223.6 ± 1.4% | 590.1 ± 0.6% | 242.3 ± 7.7% | 0.702 | 0.705 | 2.492 | 0.944 | 2.300 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 954.3 ± 1.7% | 1134.1 ± 0.3% | 896.1 ± 0.9% | 331.8 ± 0.5% | 365.4 ± 0.3% | 311.6 ± 1.1% | 0.841 | 1.065 | 2.876 | 2.611 | 3.063 |
| qlog records, JSON text sequence | 1467503 | 808.8 ± 0.6% | 872.8 ± 3.5% | 728.3 ± 1.0% | 321.7 ± 1.3% | 389.9 ± 1.9% | 232.1 ± 2.4% | 0.927 | 1.111 | 2.515 | 2.075 | 3.485 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.790 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.803 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.702 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.705 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.944 of serde_json.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.841 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.927 of simdjson.

# bench-json, CLDR and qlog alone: head, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1014.2 ± 3.4% | 0.474 | 1.054 | 1.086 | 1.082 | 0.422 | 1.068 | 1.082 | 0.365 | 0.796 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 841.4 ± 5.9% | 0.734 | 1.020 | 1.003 | 1.005 | 0.388 | 1.010 | 1.000 | 0.345 | 0.891 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.0 ± 4.1% | 0.439 | 0.979 | 0.968 | 1.004 | 1.017 | 0.229 | 1.015 | 0.443 | 0.723 | 0.086 | 1.016 |
| qlog records, JSON text sequence | 1467503 | 1159.9 ± 0.6% | 0.690 | 0.946 | 0.986 | 0.988 | 0.990 | 0.221 | 0.987 | 0.411 | 0.698 | 0.104 | 1.005 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J5 UTF-8 vectors off runs at 1.054 of all on.
- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.086 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.082 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 1014.2 ± 3.4% | 997.8 ± 3.1% | 973.1 ± 0.5% | 259.1 ± 0.9% | 531.3 ± 0.8% | 257.4 ± 4.9% | 1.016 | 1.042 | 3.914 | 1.909 | 3.940 |
| qlog records, JSON text sequence | 1467503 | 841.4 ± 5.9% | 796.3 ± 0.4% | 806.9 ± 2.4% | 221.7 ± 1.8% | 588.6 ± 1.7% | 244.9 ± 2.1% | 1.057 | 1.043 | 3.795 | 1.430 | 3.436 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.0 ± 4.1% | 1136.6 ± 1.1% | 897.6 ± 3.6% | 332.9 ± 2.0% | 359.3 ± 2.4% | 312.1 ± 5.7% | 1.172 | 1.484 | 4.002 | 3.707 | 4.268 |
| qlog records, JSON text sequence | 1467503 | 1159.9 ± 0.6% | 875.4 ± 1.7% | 727.5 ± 6.4% | 322.8 ± 5.9% | 390.5 ± 1.4% | 231.7 ± 1.7% | 1.325 | 1.594 | 3.593 | 2.970 | 5.007 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1353.0 ± 1.6% | 1136.6 ± 1.1% | 897.6 ± 3.6% | 332.9 ± 2.0% | 359.3 ± 2.4% | 312.1 ± 5.7% | 1.190 | 1.507 | 4.065 | 3.765 | 4.335 |
| qlog records, JSON text sequence | 1467503 | 1165.6 ± 2.1% | 875.4 ± 1.7% | 727.5 ± 6.4% | 322.8 ± 5.9% | 390.5 ± 1.4% | 231.7 ± 1.7% | 1.332 | 1.602 | 3.611 | 2.985 | 5.032 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 806.9 ± 3.0% | 997.8 ± 3.1% | 973.1 ± 0.5% | 259.1 ± 0.9% | 531.3 ± 0.8% | 257.4 ± 4.9% | 0.809 | 0.829 | 3.114 | 1.519 | 3.135 |
| qlog records, JSON text sequence | 1467503 | 749.8 ± 5.2% | 796.3 ± 0.4% | 806.9 ± 2.4% | 221.7 ± 1.8% | 588.6 ± 1.7% | 244.9 ± 2.1% | 0.942 | 0.929 | 3.382 | 1.274 | 3.062 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 962.8 ± 0.6% | 1136.6 ± 1.1% | 897.6 ± 3.6% | 332.9 ± 2.0% | 359.3 ± 2.4% | 312.1 ± 5.7% | 0.847 | 1.073 | 2.893 | 2.680 | 3.085 |
| qlog records, JSON text sequence | 1467503 | 809.2 ± 0.3% | 875.4 ± 1.7% | 727.5 ± 6.4% | 322.8 ± 5.9% | 390.5 ± 1.4% | 231.7 ± 1.7% | 0.924 | 1.112 | 2.507 | 2.072 | 3.493 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.809 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.829 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.942 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.929 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.847 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.924 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1038.5 ± 6.3% | 0.475 | 1.008 | 0.998 | 0.997 | 0.407 | 1.025 | 1.031 | 0.356 | 0.786 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 851.6 ± 1.5% | 0.736 | 1.037 | 1.022 | 1.004 | 0.389 | 1.022 | 1.003 | 0.336 | 0.679 | 0.107 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1330.8 ± 5.7% | 0.443 | 0.977 | 0.990 | 1.006 | 1.004 | 0.235 | 1.002 | 0.448 | 0.722 | 0.086 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1164.4 ± 5.5% | 0.701 | 0.919 | 0.987 | 0.980 | 0.985 | 0.225 | 0.983 | 0.413 | 0.691 | 0.104 | 1.009 |

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
| CLDR supplemental, 34 texts | 920675 | 1038.5 ± 6.3% | 1022.8 ± 0.4% | 981.4 ± 0.6% | 260.4 ± 0.8% | 531.8 ± 0.3% | 258.8 ± 3.3% | 1.015 | 1.058 | 3.988 | 1.953 | 4.013 |
| qlog records, JSON text sequence | 1467503 | 851.6 ± 1.5% | 813.0 ± 0.2% | 808.3 ± 3.0% | 218.2 ± 3.5% | 584.7 ± 6.7% | 237.6 ± 3.1% | 1.047 | 1.053 | 3.902 | 1.456 | 3.584 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1330.8 ± 5.7% | 1122.9 ± 1.7% | 893.4 ± 0.9% | 319.0 ± 0.4% | 354.9 ± 4.2% | 311.0 ± 1.0% | 1.185 | 1.490 | 4.172 | 3.750 | 4.280 |
| qlog records, JSON text sequence | 1467503 | 1164.4 ± 5.5% | 870.5 ± 0.4% | 720.5 ± 0.9% | 318.3 ± 5.8% | 392.5 ± 0.4% | 230.2 ± 2.3% | 1.338 | 1.616 | 3.658 | 2.967 | 5.059 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1360.3 ± 1.2% | 1122.9 ± 1.7% | 893.4 ± 0.9% | 319.0 ± 0.4% | 354.9 ± 4.2% | 311.0 ± 1.0% | 1.211 | 1.523 | 4.265 | 3.833 | 4.375 |
| qlog records, JSON text sequence | 1467503 | 1174.4 ± 0.5% | 870.5 ± 0.4% | 720.5 ± 0.9% | 318.3 ± 5.8% | 392.5 ± 0.4% | 230.2 ± 2.3% | 1.349 | 1.630 | 3.689 | 2.992 | 5.102 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 816.1 ± 0.4% | 1022.8 ± 0.4% | 981.4 ± 0.6% | 260.4 ± 0.8% | 531.8 ± 0.3% | 258.8 ± 3.3% | 0.798 | 0.832 | 3.135 | 1.535 | 3.154 |
| qlog records, JSON text sequence | 1467503 | 578.2 ± 2.5% | 813.0 ± 0.2% | 808.3 ± 3.0% | 218.2 ± 3.5% | 584.7 ± 6.7% | 237.6 ± 3.1% | 0.711 | 0.715 | 2.650 | 0.989 | 2.433 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 960.7 ± 6.7% | 1122.9 ± 1.7% | 893.4 ± 0.9% | 319.0 ± 0.4% | 354.9 ± 4.2% | 311.0 ± 1.0% | 0.856 | 1.075 | 3.012 | 2.707 | 3.090 |
| qlog records, JSON text sequence | 1467503 | 804.4 ± 0.3% | 870.5 ± 0.4% | 720.5 ± 0.9% | 318.3 ± 5.8% | 392.5 ± 0.4% | 230.2 ± 2.3% | 0.924 | 1.116 | 2.527 | 2.049 | 3.495 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.798 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.832 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.711 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.715 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.856 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.924 of simdjson.

# bench-json, CLDR and qlog alone: null, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1034.0 ± 3.6% | 0.454 | 0.982 | 1.058 | 1.059 | 0.414 | 1.042 | 1.058 | 0.358 | 0.750 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 833.4 ± 5.2% | 0.743 | 1.035 | 1.021 | 1.002 | 0.395 | 1.024 | 1.001 | 0.349 | 0.674 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1345.5 ± 4.8% | 0.400 | 0.963 | 0.953 | 1.005 | 0.993 | 0.227 | 0.995 | 0.439 | 0.717 | 0.085 | 1.004 |
| qlog records, JSON text sequence | 1467503 | 1162.0 ± 1.4% | 0.690 | 0.946 | 0.984 | 0.993 | 0.989 | 0.221 | 0.986 | 0.413 | 0.694 | 0.104 | 1.012 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.058 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.059 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.058 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1034.0 ± 3.6% | 1014.3 ± 0.2% | 979.8 ± 0.9% | 260.3 ± 7.9% | 530.1 ± 0.7% | 256.1 ± 2.7% | 1.019 | 1.055 | 3.973 | 1.951 | 4.038 |
| qlog records, JSON text sequence | 1467503 | 833.4 ± 5.2% | 809.1 ± 0.3% | 810.6 ± 1.6% | 222.8 ± 1.1% | 590.3 ± 4.8% | 241.7 ± 3.9% | 1.030 | 1.028 | 3.740 | 1.412 | 3.447 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1345.5 ± 4.8% | 1141.0 ± 1.4% | 898.0 ± 0.6% | 333.7 ± 0.9% | 364.7 ± 4.1% | 312.1 ± 3.6% | 1.179 | 1.498 | 4.032 | 3.689 | 4.311 |
| qlog records, JSON text sequence | 1467503 | 1162.0 ± 1.4% | 871.0 ± 0.4% | 728.5 ± 0.5% | 323.8 ± 0.6% | 394.2 ± 0.6% | 232.6 ± 1.5% | 1.334 | 1.595 | 3.589 | 2.948 | 4.995 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1350.2 ± 3.1% | 1141.0 ± 1.4% | 898.0 ± 0.6% | 333.7 ± 0.9% | 364.7 ± 4.1% | 312.1 ± 3.6% | 1.183 | 1.504 | 4.046 | 3.702 | 4.326 |
| qlog records, JSON text sequence | 1467503 | 1176.3 ± 0.4% | 871.0 ± 0.4% | 728.5 ± 0.5% | 323.8 ± 0.6% | 394.2 ± 0.6% | 232.6 ± 1.5% | 1.351 | 1.615 | 3.633 | 2.984 | 5.057 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 775.4 ± 0.4% | 1014.3 ± 0.2% | 979.8 ± 0.9% | 260.3 ± 7.9% | 530.1 ± 0.7% | 256.1 ± 2.7% | 0.764 | 0.791 | 2.979 | 1.463 | 3.028 |
| qlog records, JSON text sequence | 1467503 | 562.1 ± 1.6% | 809.1 ± 0.3% | 810.6 ± 1.6% | 222.8 ± 1.1% | 590.3 ± 4.8% | 241.7 ± 3.9% | 0.695 | 0.693 | 2.522 | 0.952 | 2.325 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 964.7 ± 6.3% | 1141.0 ± 1.4% | 898.0 ± 0.6% | 333.7 ± 0.9% | 364.7 ± 4.1% | 312.1 ± 3.6% | 0.845 | 1.074 | 2.891 | 2.645 | 3.091 |
| qlog records, JSON text sequence | 1467503 | 806.8 ± 0.7% | 871.0 ± 0.4% | 728.5 ± 0.5% | 323.8 ± 0.6% | 394.2 ± 0.6% | 232.6 ± 1.5% | 0.926 | 1.107 | 2.492 | 2.047 | 3.468 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.764 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.791 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.695 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.693 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.845 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.

# bench-json, CLDR and qlog alone: head, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1012.6 ± 0.9% | 0.475 | 1.025 | 1.086 | 1.083 | 0.423 | 1.075 | 1.083 | 0.366 | 0.787 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 840.6 ± 0.4% | 0.735 | 1.026 | 1.005 | 1.004 | 0.387 | 1.011 | 1.002 | 0.344 | 0.888 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.2 ± 0.8% | 0.437 | 0.976 | 0.970 | 0.999 | 1.009 | 0.228 | 1.012 | 0.441 | 0.721 | 0.085 | 1.012 |
| qlog records, JSON text sequence | 1467503 | 1160.9 ± 0.8% | 0.690 | 0.944 | 0.981 | 0.986 | 0.988 | 0.222 | 0.989 | 0.413 | 0.695 | 0.104 | 1.015 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.086 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.083 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.075 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 1012.6 ± 0.9% | 1004.2 ± 0.5% | 968.5 ± 0.7% | 257.6 ± 1.4% | 531.2 ± 0.6% | 259.1 ± 2.9% | 1.008 | 1.046 | 3.931 | 1.906 | 3.908 |
| qlog records, JSON text sequence | 1467503 | 840.6 ± 0.4% | 798.4 ± 4.8% | 805.0 ± 2.1% | 221.8 ± 1.2% | 588.5 ± 4.8% | 244.0 ± 0.7% | 1.053 | 1.044 | 3.789 | 1.428 | 3.445 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.2 ± 0.8% | 1130.1 ± 7.2% | 898.7 ± 0.4% | 332.9 ± 1.2% | 359.8 ± 3.9% | 311.2 ± 1.3% | 1.185 | 1.490 | 4.023 | 3.722 | 4.304 |
| qlog records, JSON text sequence | 1467503 | 1160.9 ± 0.8% | 873.9 ± 1.9% | 726.8 ± 1.4% | 321.6 ± 3.9% | 391.7 ± 3.9% | 229.5 ± 4.8% | 1.328 | 1.597 | 3.609 | 2.964 | 5.058 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1355.7 ± 3.5% | 1130.1 ± 7.2% | 898.7 ± 0.4% | 332.9 ± 1.2% | 359.8 ± 3.9% | 311.2 ± 1.3% | 1.200 | 1.508 | 4.072 | 3.768 | 4.356 |
| qlog records, JSON text sequence | 1467503 | 1177.8 ± 0.6% | 873.9 ± 1.9% | 726.8 ± 1.4% | 321.6 ± 3.9% | 391.7 ± 3.9% | 229.5 ± 4.8% | 1.348 | 1.621 | 3.662 | 3.007 | 5.131 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 796.8 ± 2.9% | 1004.2 ± 0.5% | 968.5 ± 0.7% | 257.6 ± 1.4% | 531.2 ± 0.6% | 259.1 ± 2.9% | 0.794 | 0.823 | 3.093 | 1.500 | 3.075 |
| qlog records, JSON text sequence | 1467503 | 746.5 ± 0.6% | 798.4 ± 4.8% | 805.0 ± 2.1% | 221.8 ± 1.2% | 588.5 ± 4.8% | 244.0 ± 0.7% | 0.935 | 0.927 | 3.365 | 1.268 | 3.059 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 965.8 ± 1.3% | 1130.1 ± 7.2% | 898.7 ± 0.4% | 332.9 ± 1.2% | 359.8 ± 3.9% | 311.2 ± 1.3% | 0.855 | 1.075 | 2.901 | 2.684 | 3.104 |
| qlog records, JSON text sequence | 1467503 | 806.9 ± 2.5% | 873.9 ± 1.9% | 726.8 ± 1.4% | 321.6 ± 3.9% | 391.7 ± 3.9% | 229.5 ± 4.8% | 0.923 | 1.110 | 2.509 | 2.060 | 3.515 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.794 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.823 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.935 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.927 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.855 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.923 of simdjson.
