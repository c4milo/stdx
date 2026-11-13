# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1043.3 ± 0.8% | 0.470 | 1.000 | 1.020 | 1.009 | 0.406 | 1.003 | 1.014 | 0.354 | 0.783 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 851.4 ± 5.5% | 0.735 | 1.035 | 1.018 | 1.006 | 0.390 | 1.009 | 1.002 | 0.340 | 0.682 | 0.107 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1328.7 ± 1.2% | 0.444 | 0.987 | 0.985 | 0.999 | 1.005 | 0.236 | 0.992 | 0.447 | 0.721 | 0.086 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1158.8 ± 3.0% | 0.701 | 0.921 | 0.982 | 0.977 | 0.976 | 0.226 | 0.974 | 0.410 | 0.693 | 0.104 | 0.990 |

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
| CLDR supplemental, 34 texts | 920675 | 1043.3 ± 0.8% | 1005.8 ± 12.1% | 983.0 ± 0.7% | 260.1 ± 0.4% | 530.2 ± 1.3% | 257.0 ± 2.2% | 1.037 | 1.061 | 4.011 | 1.968 | 4.059 |
| qlog records, JSON text sequence | 1467503 | 851.4 ± 5.5% | 813.5 ± 0.2% | 819.8 ± 1.7% | 219.6 ± 4.1% | 588.6 ± 6.2% | 237.6 ± 6.8% | 1.047 | 1.039 | 3.876 | 1.447 | 3.583 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1328.7 ± 1.2% | 1131.8 ± 1.0% | 896.0 ± 10.4% | 320.0 ± 2.7% | 357.4 ± 1.4% | 312.1 ± 1.5% | 1.174 | 1.483 | 4.153 | 3.718 | 4.257 |
| qlog records, JSON text sequence | 1467503 | 1158.8 ± 3.0% | 861.7 ± 0.4% | 718.4 ± 1.3% | 317.5 ± 2.2% | 390.2 ± 0.9% | 231.9 ± 1.2% | 1.345 | 1.613 | 3.650 | 2.970 | 4.997 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1350.8 ± 1.9% | 1131.8 ± 1.0% | 896.0 ± 10.4% | 320.0 ± 2.7% | 357.4 ± 1.4% | 312.1 ± 1.5% | 1.194 | 1.508 | 4.222 | 3.779 | 4.328 |
| qlog records, JSON text sequence | 1467503 | 1146.9 ± 7.5% | 861.7 ± 0.4% | 718.4 ± 1.3% | 317.5 ± 2.2% | 390.2 ± 0.9% | 231.9 ± 1.2% | 1.331 | 1.596 | 3.612 | 2.939 | 4.945 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 816.4 ± 1.1% | 1005.8 ± 12.1% | 983.0 ± 0.7% | 260.1 ± 0.4% | 530.2 ± 1.3% | 257.0 ± 2.2% | 0.812 | 0.830 | 3.139 | 1.540 | 3.176 |
| qlog records, JSON text sequence | 1467503 | 581.1 ± 8.0% | 813.5 ± 0.2% | 819.8 ± 1.7% | 219.6 ± 4.1% | 588.6 ± 6.2% | 237.6 ± 6.8% | 0.714 | 0.709 | 2.645 | 0.987 | 2.445 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 958.6 ± 1.4% | 1131.8 ± 1.0% | 896.0 ± 10.4% | 320.0 ± 2.7% | 357.4 ± 1.4% | 312.1 ± 1.5% | 0.847 | 1.070 | 2.996 | 2.682 | 3.071 |
| qlog records, JSON text sequence | 1467503 | 802.8 ± 1.4% | 861.7 ± 0.4% | 718.4 ± 1.3% | 317.5 ± 2.2% | 390.2 ± 0.9% | 231.9 ± 1.2% | 0.932 | 1.117 | 2.529 | 2.057 | 3.461 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.812 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.830 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.714 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.709 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.847 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.932 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1040.4 ± 3.8% | 0.461 | 1.019 | 1.052 | 1.046 | 0.411 | 1.037 | 1.053 | 0.355 | 0.741 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 842.0 ± 2.4% | 0.734 | 1.020 | 1.005 | 1.002 | 0.388 | 1.013 | 1.002 | 0.347 | 0.787 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.0 ± 6.3% | 0.435 | 0.976 | 0.966 | 0.997 | 1.008 | 0.228 | 1.009 | 0.440 | 0.708 | 0.085 | 1.018 |
| qlog records, JSON text sequence | 1467503 | 1159.0 ± 0.5% | 0.690 | 0.945 | 0.980 | 0.978 | 0.985 | 0.221 | 0.983 | 0.411 | 0.687 | 0.105 | 1.011 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.052 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.053 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1040.4 ± 3.8% | 984.3 ± 0.3% | 971.2 ± 0.6% | 259.3 ± 1.3% | 530.6 ± 3.4% | 254.4 ± 4.2% | 1.057 | 1.071 | 4.013 | 1.961 | 4.090 |
| qlog records, JSON text sequence | 1467503 | 842.0 ± 2.4% | 796.8 ± 6.4% | 805.7 ± 1.0% | 220.6 ± 3.4% | 586.8 ± 1.5% | 241.3 ± 5.4% | 1.057 | 1.045 | 3.817 | 1.435 | 3.489 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.0 ± 6.3% | 1126.6 ± 1.3% | 893.8 ± 1.1% | 331.1 ± 1.2% | 360.9 ± 3.3% | 310.4 ± 1.2% | 1.189 | 1.498 | 4.044 | 3.710 | 4.313 |
| qlog records, JSON text sequence | 1467503 | 1159.0 ± 0.5% | 864.3 ± 0.8% | 720.4 ± 1.8% | 320.4 ± 1.1% | 389.8 ± 1.8% | 229.6 ± 4.6% | 1.341 | 1.609 | 3.618 | 2.974 | 5.047 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1362.9 ± 1.2% | 1126.6 ± 1.3% | 893.8 ± 1.1% | 331.1 ± 1.2% | 360.9 ± 3.3% | 310.4 ± 1.2% | 1.210 | 1.525 | 4.117 | 3.776 | 4.390 |
| qlog records, JSON text sequence | 1467503 | 1172.2 ± 0.6% | 864.3 ± 0.8% | 720.4 ± 1.8% | 320.4 ± 1.1% | 389.8 ± 1.8% | 229.6 ± 4.6% | 1.356 | 1.627 | 3.659 | 3.008 | 5.105 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 770.5 ± 1.0% | 984.3 ± 0.3% | 971.2 ± 0.6% | 259.3 ± 1.3% | 530.6 ± 3.4% | 254.4 ± 4.2% | 0.783 | 0.793 | 2.972 | 1.452 | 3.029 |
| qlog records, JSON text sequence | 1467503 | 663.0 ± 2.6% | 796.8 ± 6.4% | 805.7 ± 1.0% | 220.6 ± 3.4% | 586.8 ± 1.5% | 241.3 ± 5.4% | 0.832 | 0.823 | 3.006 | 1.130 | 2.748 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 948.3 ± 1.1% | 1126.6 ± 1.3% | 893.8 ± 1.1% | 331.1 ± 1.2% | 360.9 ± 3.3% | 310.4 ± 1.2% | 0.842 | 1.061 | 2.864 | 2.628 | 3.055 |
| qlog records, JSON text sequence | 1467503 | 796.3 ± 1.4% | 864.3 ± 0.8% | 720.4 ± 1.8% | 320.4 ± 1.1% | 389.8 ± 1.8% | 229.6 ± 4.6% | 0.921 | 1.105 | 2.485 | 2.043 | 3.467 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.783 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.793 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.832 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.823 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.842 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.921 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 998.2 ± 5.2% | 0.477 | 1.069 | 1.100 | 1.099 | 0.429 | 1.085 | 1.097 | 0.371 | 0.801 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 839.6 ± 1.8% | 0.735 | 1.028 | 1.005 | 1.005 | 0.384 | 1.015 | 1.004 | 0.339 | 0.890 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.0 ± 5.9% | 0.439 | 0.985 | 0.975 | 1.001 | 1.013 | 0.229 | 1.014 | 0.442 | 0.721 | 0.086 | 1.021 |
| qlog records, JSON text sequence | 1467503 | 1159.5 ± 0.5% | 0.690 | 0.946 | 0.984 | 0.969 | 0.977 | 0.221 | 0.977 | 0.413 | 0.695 | 0.104 | 1.004 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J5 UTF-8 vectors off runs at 1.069 of all on.
- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.100 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.099 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.085 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.097 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 998.2 ± 5.2% | 1005.1 ± 0.3% | 966.8 ± 0.2% | 258.6 ± 1.2% | 530.4 ± 5.7% | 256.7 ± 5.9% | 0.993 | 1.032 | 3.860 | 1.882 | 3.888 |
| qlog records, JSON text sequence | 1467503 | 839.6 ± 1.8% | 799.4 ± 0.7% | 801.1 ± 0.8% | 219.5 ± 2.3% | 583.5 ± 2.3% | 237.7 ± 6.8% | 1.050 | 1.048 | 3.825 | 1.439 | 3.533 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.0 ± 5.9% | 1126.8 ± 0.5% | 896.9 ± 0.9% | 333.6 ± 1.8% | 365.5 ± 2.4% | 311.6 ± 1.0% | 1.182 | 1.485 | 3.992 | 3.644 | 4.275 |
| qlog records, JSON text sequence | 1467503 | 1159.5 ± 0.5% | 871.7 ± 0.6% | 722.2 ± 1.6% | 322.4 ± 1.8% | 390.1 ± 1.5% | 231.5 ± 4.5% | 1.330 | 1.605 | 3.596 | 2.973 | 5.009 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1359.7 ± 6.0% | 1126.8 ± 0.5% | 896.9 ± 0.9% | 333.6 ± 1.8% | 365.5 ± 2.4% | 311.6 ± 1.0% | 1.207 | 1.516 | 4.075 | 3.720 | 4.364 |
| qlog records, JSON text sequence | 1467503 | 1164.0 ± 2.6% | 871.7 ± 0.6% | 722.2 ± 1.6% | 322.4 ± 1.8% | 390.1 ± 1.5% | 231.5 ± 4.5% | 1.335 | 1.612 | 3.610 | 2.984 | 5.029 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 799.1 ± 0.7% | 1005.1 ± 0.3% | 966.8 ± 0.2% | 258.6 ± 1.2% | 530.4 ± 5.7% | 256.7 ± 5.9% | 0.795 | 0.827 | 3.090 | 1.507 | 3.113 |
| qlog records, JSON text sequence | 1467503 | 746.9 ± 0.9% | 799.4 ± 0.7% | 801.1 ± 0.8% | 219.5 ± 2.3% | 583.5 ± 2.3% | 237.7 ± 6.8% | 0.934 | 0.932 | 3.403 | 1.280 | 3.143 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 960.0 ± 1.2% | 1126.8 ± 0.5% | 896.9 ± 0.9% | 333.6 ± 1.8% | 365.5 ± 2.4% | 311.6 ± 1.0% | 0.852 | 1.070 | 2.877 | 2.626 | 3.081 |
| qlog records, JSON text sequence | 1467503 | 805.9 ± 0.3% | 871.7 ± 0.6% | 722.2 ± 1.6% | 322.4 ± 1.8% | 390.1 ± 1.5% | 231.5 ± 4.5% | 0.925 | 1.116 | 2.499 | 2.066 | 3.482 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.795 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.827 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.934 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.932 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.852 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.925 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1041.1 ± 5.3% | 0.472 | 0.994 | 0.991 | 1.026 | 0.404 | 1.029 | 1.022 | 0.355 | 0.778 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 850.7 ± 0.8% | 0.737 | 1.036 | 1.017 | 1.001 | 0.386 | 1.015 | 1.002 | 0.337 | 0.685 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1324.5 ± 2.1% | 0.445 | 0.987 | 0.983 | 0.999 | 0.998 | 0.237 | 0.996 | 0.448 | 0.722 | 0.086 | 1.021 |
| qlog records, JSON text sequence | 1467503 | 1162.6 ± 0.4% | 0.700 | 0.920 | 0.986 | 0.981 | 0.971 | 0.226 | 0.972 | 0.411 | 0.690 | 0.104 | 0.998 |

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
| CLDR supplemental, 34 texts | 920675 | 1041.1 ± 5.3% | 994.4 ± 0.8% | 965.3 ± 0.5% | 259.5 ± 0.5% | 530.2 ± 7.7% | 258.5 ± 2.7% | 1.047 | 1.079 | 4.011 | 1.964 | 4.027 |
| qlog records, JSON text sequence | 1467503 | 850.7 ± 0.8% | 793.5 ± 0.9% | 780.5 ± 4.5% | 216.4 ± 4.8% | 586.9 ± 2.1% | 240.4 ± 9.6% | 1.072 | 1.090 | 3.931 | 1.449 | 3.539 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1324.5 ± 2.1% | 1130.2 ± 1.2% | 898.1 ± 0.9% | 320.0 ± 7.1% | 358.2 ± 0.9% | 306.8 ± 2.1% | 1.172 | 1.475 | 4.139 | 3.698 | 4.317 |
| qlog records, JSON text sequence | 1467503 | 1162.6 ± 0.4% | 871.3 ± 0.4% | 709.0 ± 0.6% | 318.2 ± 1.6% | 391.0 ± 2.0% | 231.5 ± 2.9% | 1.334 | 1.640 | 3.654 | 2.974 | 5.022 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1351.7 ± 1.2% | 1130.2 ± 1.2% | 898.1 ± 0.9% | 320.0 ± 7.1% | 358.2 ± 0.9% | 306.8 ± 2.1% | 1.196 | 1.505 | 4.224 | 3.774 | 4.406 |
| qlog records, JSON text sequence | 1467503 | 1160.0 ± 0.8% | 871.3 ± 0.4% | 709.0 ± 0.6% | 318.2 ± 1.6% | 391.0 ± 2.0% | 231.5 ± 2.9% | 1.331 | 1.636 | 3.645 | 2.967 | 5.011 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 809.6 ± 0.9% | 994.4 ± 0.8% | 965.3 ± 0.5% | 259.5 ± 0.5% | 530.2 ± 7.7% | 258.5 ± 2.7% | 0.814 | 0.839 | 3.119 | 1.527 | 3.132 |
| qlog records, JSON text sequence | 1467503 | 582.5 ± 8.3% | 793.5 ± 0.9% | 780.5 ± 4.5% | 216.4 ± 4.8% | 586.9 ± 2.1% | 240.4 ± 9.6% | 0.734 | 0.746 | 2.691 | 0.992 | 2.423 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 956.1 ± 0.5% | 1130.2 ± 1.2% | 898.1 ± 0.9% | 320.0 ± 7.1% | 358.2 ± 0.9% | 306.8 ± 2.1% | 0.846 | 1.065 | 2.988 | 2.669 | 3.117 |
| qlog records, JSON text sequence | 1467503 | 801.7 ± 1.0% | 871.3 ± 0.4% | 709.0 ± 0.6% | 318.2 ± 1.6% | 391.0 ± 2.0% | 231.5 ± 2.9% | 0.920 | 1.131 | 2.520 | 2.051 | 3.463 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.814 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.839 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.734 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.746 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.846 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.920 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1012.1 ± 4.6% | 0.473 | 1.056 | 1.085 | 1.081 | 0.424 | 1.073 | 1.083 | 0.366 | 0.766 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 840.9 ± 0.6% | 0.734 | 1.025 | 1.009 | 0.999 | 0.389 | 1.012 | 1.005 | 0.344 | 0.788 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1331.6 ± 0.6% | 0.437 | 0.981 | 0.975 | 1.005 | 1.014 | 0.229 | 1.014 | 0.442 | 0.711 | 0.086 | 1.023 |
| qlog records, JSON text sequence | 1467503 | 1161.2 ± 2.2% | 0.689 | 0.945 | 0.978 | 0.975 | 0.975 | 0.220 | 0.975 | 0.413 | 0.687 | 0.104 | 1.002 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J5 UTF-8 vectors off runs at 1.056 of all on.
- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.085 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.081 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.073 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 1012.1 ± 4.6% | 1003.1 ± 0.5% | 982.3 ± 1.1% | 259.1 ± 0.7% | 530.5 ± 0.5% | 256.6 ± 2.7% | 1.009 | 1.030 | 3.906 | 1.908 | 3.945 |
| qlog records, JSON text sequence | 1467503 | 840.9 ± 0.6% | 811.8 ± 25.5% | 779.8 ± 5.3% | 221.0 ± 1.1% | 589.8 ± 0.8% | 245.6 ± 1.8% | 1.036 | 1.078 | 3.805 | 1.426 | 3.423 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1331.6 ± 0.6% | 1138.3 ± 1.0% | 894.6 ± 8.9% | 333.3 ± 0.2% | 366.3 ± 0.8% | 311.7 ± 3.8% | 1.170 | 1.489 | 3.995 | 3.635 | 4.272 |
| qlog records, JSON text sequence | 1467503 | 1161.2 ± 2.2% | 867.9 ± 1.0% | 729.3 ± 0.2% | 322.8 ± 1.4% | 394.0 ± 1.0% | 232.6 ± 1.0% | 1.338 | 1.592 | 3.597 | 2.947 | 4.992 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1361.9 ± 1.3% | 1138.3 ± 1.0% | 894.6 ± 8.9% | 333.3 ± 0.2% | 366.3 ± 0.8% | 311.7 ± 3.8% | 1.196 | 1.522 | 4.086 | 3.718 | 4.368 |
| qlog records, JSON text sequence | 1467503 | 1164.0 ± 0.4% | 867.9 ± 1.0% | 729.3 ± 0.2% | 322.8 ± 1.4% | 394.0 ± 1.0% | 232.6 ± 1.0% | 1.341 | 1.596 | 3.606 | 2.954 | 5.004 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 774.9 ± 5.2% | 1003.1 ± 0.5% | 982.3 ± 1.1% | 259.1 ± 0.7% | 530.5 ± 0.5% | 256.6 ± 2.7% | 0.772 | 0.789 | 2.990 | 1.461 | 3.020 |
| qlog records, JSON text sequence | 1467503 | 663.0 ± 3.1% | 811.8 ± 25.5% | 779.8 ± 5.3% | 221.0 ± 1.1% | 589.8 ± 0.8% | 245.6 ± 1.8% | 0.817 | 0.850 | 3.000 | 1.124 | 2.699 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 947.4 ± 1.2% | 1138.3 ± 1.0% | 894.6 ± 8.9% | 333.3 ± 0.2% | 366.3 ± 0.8% | 311.7 ± 3.8% | 0.832 | 1.059 | 2.842 | 2.586 | 3.039 |
| qlog records, JSON text sequence | 1467503 | 798.0 ± 1.7% | 867.9 ± 1.0% | 729.3 ± 0.2% | 322.8 ± 1.4% | 394.0 ± 1.0% | 232.6 ± 1.0% | 0.919 | 1.094 | 2.472 | 2.025 | 3.431 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.772 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.789 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.850 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.832 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.919 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1040.5 ± 4.0% | 0.462 | 1.004 | 1.058 | 1.056 | 0.411 | 1.046 | 1.059 | 0.355 | 0.768 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 843.0 ± 1.3% | 0.733 | 1.025 | 1.005 | 1.004 | 0.387 | 1.011 | 1.001 | 0.347 | 0.888 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.7 ± 1.4% | 0.437 | 0.976 | 0.970 | 1.002 | 1.009 | 0.227 | 1.010 | 0.442 | 0.720 | 0.086 | 1.021 |
| qlog records, JSON text sequence | 1467503 | 1161.9 ± 0.4% | 0.685 | 0.944 | 0.982 | 0.967 | 0.976 | 0.220 | 0.977 | 0.412 | 0.695 | 0.104 | 1.002 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.056 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.059 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1040.5 ± 4.0% | 1002.1 ± 0.6% | 976.3 ± 0.4% | 259.5 ± 1.5% | 531.4 ± 0.2% | 255.7 ± 1.6% | 1.038 | 1.066 | 4.010 | 1.958 | 4.069 |
| qlog records, JSON text sequence | 1467503 | 843.0 ± 1.3% | 801.2 ± 0.3% | 804.0 ± 3.8% | 222.5 ± 4.9% | 589.3 ± 7.9% | 247.1 ± 1.1% | 1.052 | 1.048 | 3.789 | 1.430 | 3.412 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.7 ± 1.4% | 1137.2 ± 0.9% | 897.0 ± 0.7% | 332.6 ± 1.5% | 360.0 ± 3.3% | 311.1 ± 1.4% | 1.175 | 1.489 | 4.016 | 3.710 | 4.294 |
| qlog records, JSON text sequence | 1467503 | 1161.9 ± 0.4% | 867.3 ± 1.9% | 724.8 ± 1.3% | 322.1 ± 1.3% | 387.9 ± 1.9% | 232.0 ± 1.8% | 1.340 | 1.603 | 3.607 | 2.995 | 5.009 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1364.1 ± 0.8% | 1137.2 ± 0.9% | 897.0 ± 0.7% | 332.6 ± 1.5% | 360.0 ± 3.3% | 311.1 ± 1.4% | 1.200 | 1.521 | 4.101 | 3.789 | 4.385 |
| qlog records, JSON text sequence | 1467503 | 1164.3 ± 2.5% | 867.3 ± 1.9% | 724.8 ± 1.3% | 322.1 ± 1.3% | 387.9 ± 1.9% | 232.0 ± 1.8% | 1.342 | 1.606 | 3.615 | 3.001 | 5.019 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 799.6 ± 4.4% | 1002.1 ± 0.6% | 976.3 ± 0.4% | 259.5 ± 1.5% | 531.4 ± 0.2% | 255.7 ± 1.6% | 0.798 | 0.819 | 3.082 | 1.505 | 3.127 |
| qlog records, JSON text sequence | 1467503 | 748.9 ± 0.4% | 801.2 ± 0.3% | 804.0 ± 3.8% | 222.5 ± 4.9% | 589.3 ± 7.9% | 247.1 ± 1.1% | 0.935 | 0.931 | 3.366 | 1.271 | 3.031 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.8 ± 1.6% | 1137.2 ± 0.9% | 897.0 ± 0.7% | 332.6 ± 1.5% | 360.0 ± 3.3% | 311.1 ± 1.4% | 0.846 | 1.072 | 2.892 | 2.671 | 3.092 |
| qlog records, JSON text sequence | 1467503 | 807.8 ± 5.4% | 867.3 ± 1.9% | 724.8 ± 1.3% | 322.1 ± 1.3% | 387.9 ± 1.9% | 232.0 ± 1.8% | 0.931 | 1.115 | 2.508 | 2.082 | 3.482 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.798 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.819 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.935 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.931 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.846 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.931 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1044.4 ± 1.4% | 0.474 | 0.996 | 1.020 | 1.011 | 0.405 | 1.027 | 1.006 | 0.354 | 0.782 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 851.5 ± 0.9% | 0.736 | 1.036 | 1.022 | 1.007 | 0.391 | 1.012 | 1.003 | 0.341 | 0.686 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.0 ± 0.6% | 0.443 | 0.978 | 0.976 | 0.994 | 0.989 | 0.235 | 0.990 | 0.444 | 0.719 | 0.086 | 1.014 |
| qlog records, JSON text sequence | 1467503 | 1162.9 ± 2.4% | 0.699 | 0.920 | 0.980 | 0.977 | 0.972 | 0.225 | 0.971 | 0.409 | 0.689 | 0.104 | 0.999 |

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
| CLDR supplemental, 34 texts | 920675 | 1044.4 ± 1.4% | 1002.5 ± 0.8% | 978.8 ± 0.6% | 259.8 ± 0.5% | 529.3 ± 0.9% | 253.3 ± 2.6% | 1.042 | 1.067 | 4.020 | 1.973 | 4.123 |
| qlog records, JSON text sequence | 1467503 | 851.5 ± 0.9% | 812.4 ± 0.5% | 780.4 ± 3.7% | 223.8 ± 0.8% | 588.8 ± 1.1% | 245.4 ± 1.3% | 1.048 | 1.091 | 3.804 | 1.446 | 3.469 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.0 ± 0.6% | 1131.3 ± 1.2% | 898.6 ± 0.5% | 321.1 ± 7.0% | 356.6 ± 1.4% | 310.6 ± 2.6% | 1.178 | 1.483 | 4.152 | 3.738 | 4.291 |
| qlog records, JSON text sequence | 1467503 | 1162.9 ± 2.4% | 866.8 ± 0.8% | 719.0 ± 8.5% | 316.9 ± 1.6% | 390.3 ± 0.7% | 230.3 ± 3.3% | 1.341 | 1.617 | 3.670 | 2.979 | 5.049 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1351.8 ± 0.9% | 1131.3 ± 1.2% | 898.6 ± 0.5% | 321.1 ± 7.0% | 356.6 ± 1.4% | 310.6 ± 2.6% | 1.195 | 1.504 | 4.210 | 3.790 | 4.352 |
| qlog records, JSON text sequence | 1467503 | 1161.6 ± 0.3% | 866.8 ± 0.8% | 719.0 ± 8.5% | 316.9 ± 1.6% | 390.3 ± 0.7% | 230.3 ± 3.3% | 1.340 | 1.616 | 3.666 | 2.976 | 5.044 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 816.3 ± 1.8% | 1002.5 ± 0.8% | 978.8 ± 0.6% | 259.8 ± 0.5% | 529.3 ± 0.9% | 253.3 ± 2.6% | 0.814 | 0.834 | 3.142 | 1.542 | 3.222 |
| qlog records, JSON text sequence | 1467503 | 583.9 ± 1.3% | 812.4 ± 0.5% | 780.4 ± 3.7% | 223.8 ± 0.8% | 588.8 ± 1.1% | 245.4 ± 1.3% | 0.719 | 0.748 | 2.609 | 0.992 | 2.379 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 958.9 ± 2.0% | 1131.3 ± 1.2% | 898.6 ± 0.5% | 321.1 ± 7.0% | 356.6 ± 1.4% | 310.6 ± 2.6% | 0.848 | 1.067 | 2.987 | 2.689 | 3.087 |
| qlog records, JSON text sequence | 1467503 | 801.5 ± 0.5% | 866.8 ± 0.8% | 719.0 ± 8.5% | 316.9 ± 1.6% | 390.3 ± 0.7% | 230.3 ± 3.3% | 0.925 | 1.115 | 2.530 | 2.053 | 3.480 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.814 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.834 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.719 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.748 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.848 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.925 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1038.1 ± 2.2% | 0.462 | 0.990 | 1.060 | 1.058 | 0.412 | 1.047 | 1.054 | 0.356 | 0.747 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 841.9 ± 2.0% | 0.734 | 1.023 | 1.004 | 1.002 | 0.388 | 1.011 | 1.001 | 0.347 | 0.790 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.6 ± 0.9% | 0.437 | 0.977 | 0.972 | 1.004 | 1.016 | 0.229 | 1.016 | 0.441 | 0.712 | 0.086 | 1.025 |
| qlog records, JSON text sequence | 1467503 | 1163.0 ± 4.9% | 0.688 | 0.943 | 0.973 | 0.982 | 0.985 | 0.221 | 0.985 | 0.411 | 0.683 | 0.104 | 1.013 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.060 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.058 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.054 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1038.1 ± 2.2% | 987.0 ± 0.3% | 963.9 ± 0.4% | 259.8 ± 0.2% | 531.6 ± 0.4% | 254.4 ± 2.7% | 1.052 | 1.077 | 3.996 | 1.953 | 4.080 |
| qlog records, JSON text sequence | 1467503 | 841.9 ± 2.0% | 794.5 ± 0.4% | 782.3 ± 0.9% | 221.4 ± 0.7% | 587.9 ± 0.5% | 245.0 ± 1.7% | 1.060 | 1.076 | 3.802 | 1.432 | 3.437 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.6 ± 0.9% | 1132.8 ± 1.3% | 894.3 ± 0.7% | 332.4 ± 0.6% | 363.4 ± 2.1% | 312.1 ± 0.4% | 1.176 | 1.490 | 4.009 | 3.667 | 4.269 |
| qlog records, JSON text sequence | 1467503 | 1163.0 ± 4.9% | 865.1 ± 2.1% | 726.1 ± 0.7% | 320.4 ± 4.7% | 389.3 ± 1.9% | 229.1 ± 4.4% | 1.344 | 1.602 | 3.629 | 2.988 | 5.077 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1366.5 ± 1.6% | 1132.8 ± 1.3% | 894.3 ± 0.7% | 332.4 ± 0.6% | 363.4 ± 2.1% | 312.1 ± 0.4% | 1.206 | 1.528 | 4.110 | 3.761 | 4.378 |
| qlog records, JSON text sequence | 1467503 | 1178.0 ± 0.3% | 865.1 ± 2.1% | 726.1 ± 0.7% | 320.4 ± 4.7% | 389.3 ± 1.9% | 229.1 ± 4.4% | 1.362 | 1.622 | 3.676 | 3.026 | 5.143 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 775.1 ± 0.7% | 987.0 ± 0.3% | 963.9 ± 0.4% | 259.8 ± 0.2% | 531.6 ± 0.4% | 254.4 ± 2.7% | 0.785 | 0.804 | 2.984 | 1.458 | 3.046 |
| qlog records, JSON text sequence | 1467503 | 665.3 ± 0.8% | 794.5 ± 0.4% | 782.3 ± 0.9% | 221.4 ± 0.7% | 587.9 ± 0.5% | 245.0 ± 1.7% | 0.837 | 0.850 | 3.004 | 1.132 | 2.716 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 949.3 ± 0.8% | 1132.8 ± 1.3% | 894.3 ± 0.7% | 332.4 ± 0.6% | 363.4 ± 2.1% | 312.1 ± 0.4% | 0.838 | 1.061 | 2.856 | 2.613 | 3.041 |
| qlog records, JSON text sequence | 1467503 | 794.3 ± 7.4% | 865.1 ± 2.1% | 726.1 ± 0.7% | 320.4 ± 4.7% | 389.3 ± 1.9% | 229.1 ± 4.4% | 0.918 | 1.094 | 2.479 | 2.040 | 3.467 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.785 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.804 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.837 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.850 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.838 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.918 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1001.9 ± 3.5% | 0.478 | 1.051 | 1.091 | 1.090 | 0.427 | 1.074 | 1.091 | 0.369 | 0.801 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 843.1 ± 0.6% | 0.735 | 1.021 | 1.005 | 1.001 | 0.386 | 1.010 | 0.999 | 0.343 | 0.887 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.2 ± 7.2% | 0.439 | 0.978 | 0.969 | 1.001 | 1.012 | 0.229 | 1.012 | 0.442 | 0.721 | 0.085 | 1.019 |
| qlog records, JSON text sequence | 1467503 | 1159.6 ± 0.2% | 0.689 | 0.945 | 0.979 | 0.978 | 0.975 | 0.222 | 0.977 | 0.413 | 0.694 | 0.104 | 1.003 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.091 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.090 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.074 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.091 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1001.9 ± 3.5% | 995.8 ± 5.4% | 968.5 ± 1.2% | 259.6 ± 1.2% | 531.2 ± 0.2% | 257.2 ± 2.7% | 1.006 | 1.034 | 3.859 | 1.886 | 3.895 |
| qlog records, JSON text sequence | 1467503 | 843.1 ± 0.6% | 796.8 ± 0.4% | 794.3 ± 0.4% | 219.8 ± 11.7% | 587.6 ± 1.3% | 244.8 ± 1.5% | 1.058 | 1.061 | 3.836 | 1.435 | 3.444 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.2 ± 7.2% | 1127.2 ± 1.5% | 894.3 ± 0.6% | 331.2 ± 5.2% | 362.5 ± 3.8% | 309.8 ± 0.8% | 1.182 | 1.490 | 4.022 | 3.675 | 4.301 |
| qlog records, JSON text sequence | 1467503 | 1159.6 ± 0.2% | 874.6 ± 0.3% | 727.2 ± 0.4% | 321.6 ± 0.6% | 389.7 ± 1.4% | 230.5 ± 6.3% | 1.326 | 1.595 | 3.605 | 2.976 | 5.032 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1357.5 ± 1.0% | 1127.2 ± 1.5% | 894.3 ± 0.6% | 331.2 ± 5.2% | 362.5 ± 3.8% | 309.8 ± 0.8% | 1.204 | 1.518 | 4.098 | 3.745 | 4.382 |
| qlog records, JSON text sequence | 1467503 | 1162.5 ± 0.3% | 874.6 ± 0.3% | 727.2 ± 0.4% | 321.6 ± 0.6% | 389.7 ± 1.4% | 230.5 ± 6.3% | 1.329 | 1.599 | 3.614 | 2.983 | 5.044 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 802.8 ± 2.6% | 995.8 ± 5.4% | 968.5 ± 1.2% | 259.6 ± 1.2% | 531.2 ± 0.2% | 257.2 ± 2.7% | 0.806 | 0.829 | 3.092 | 1.511 | 3.121 |
| qlog records, JSON text sequence | 1467503 | 748.0 ± 8.6% | 796.8 ± 0.4% | 794.3 ± 0.4% | 219.8 ± 11.7% | 587.6 ± 1.3% | 244.8 ± 1.5% | 0.939 | 0.942 | 3.403 | 1.273 | 3.056 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.1 ± 10.4% | 1127.2 ± 1.5% | 894.3 ± 0.6% | 331.2 ± 5.2% | 362.5 ± 3.8% | 309.8 ± 0.8% | 0.853 | 1.075 | 2.902 | 2.651 | 3.103 |
| qlog records, JSON text sequence | 1467503 | 804.5 ± 10.6% | 874.6 ± 0.3% | 727.2 ± 0.4% | 321.6 ± 0.6% | 389.7 ± 1.4% | 230.5 ± 6.3% | 0.920 | 1.106 | 2.501 | 2.064 | 3.491 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.806 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.829 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.853 of simdjson.
