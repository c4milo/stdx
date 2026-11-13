# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1063.3 ± 1.4% | 0.491 | 1.036 | 1.021 | 1.046 | 0.426 | 1.051 | 1.047 | 0.423 | 0.737 | 0.105 |
| qlog records, JSON text sequence | 1467503 | 690.6 ± 67.2% | 0.935 | 1.063 | 1.054 | 1.071 | 0.490 | 1.068 | 1.071 | 0.479 | 0.846 | 0.154 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1377.8 ± 2.6% | 0.426 | 0.960 | 0.965 | 0.991 | 0.999 | 0.258 | 0.998 | 0.461 | 0.764 | 0.090 | 1.013 |
| qlog records, JSON text sequence | 1467503 | 782.5 ± 10.5% | 0.838 | 1.001 | 1.013 | 0.999 | 1.067 | 0.387 | 1.028 | 0.636 | 0.935 | 0.173 | 1.042 |

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
| CLDR supplemental, 34 texts | 920675 | 1063.3 ± 1.4% | 1091.2 ± 0.7% | 856.0 ± 0.1% | 307.4 ± 1.6% | 525.1 ± 0.6% | 287.9 ± 11.6% | 0.974 | 1.242 | 3.459 | 2.025 | 3.693 |
| qlog records, JSON text sequence | 1467503 | 690.6 ± 67.2% | 905.4 ± 4.3% | 825.8 ± 6.1% | 257.2 ± 2.7% | 587.7 ± 10.6% | 236.9 ± 19.2% | 0.763 | 0.836 | 2.685 | 1.175 | 2.915 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1377.8 ± 2.6% | 1131.0 ± 1.1% | 835.2 ± 2.4% | 356.2 ± 3.1% | 368.1 ± 2.2% | 384.7 ± 3.3% | 1.218 | 1.650 | 3.869 | 3.743 | 3.581 |
| qlog records, JSON text sequence | 1467503 | 782.5 ± 10.5% | 613.5 ± 13.4% | 558.8 ± 7.0% | 283.4 ± 1.7% | 283.1 ± 3.6% | 222.8 ± 1.1% | 1.275 | 1.400 | 2.761 | 2.764 | 3.512 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1395.9 ± 0.8% | 1131.0 ± 1.1% | 835.2 ± 2.4% | 356.2 ± 3.1% | 368.1 ± 2.2% | 384.7 ± 3.3% | 1.234 | 1.671 | 3.919 | 3.792 | 3.628 |
| qlog records, JSON text sequence | 1467503 | 815.4 ± 16.9% | 613.5 ± 13.4% | 558.8 ± 7.0% | 283.4 ± 1.7% | 283.1 ± 3.6% | 222.8 ± 1.1% | 1.329 | 1.459 | 2.878 | 2.880 | 3.660 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 783.5 ± 1.7% | 1091.2 ± 0.7% | 856.0 ± 0.1% | 307.4 ± 1.6% | 525.1 ± 0.6% | 287.9 ± 11.6% | 0.718 | 0.915 | 2.549 | 1.492 | 2.721 |
| qlog records, JSON text sequence | 1467503 | 584.4 ± 4.6% | 905.4 ± 4.3% | 825.8 ± 6.1% | 257.2 ± 2.7% | 587.7 ± 10.6% | 236.9 ± 19.2% | 0.645 | 0.708 | 2.272 | 0.994 | 2.467 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1053.0 ± 0.7% | 1131.0 ± 1.1% | 835.2 ± 2.4% | 356.2 ± 3.1% | 368.1 ± 2.2% | 384.7 ± 3.3% | 0.931 | 1.261 | 2.957 | 2.861 | 2.737 |
| qlog records, JSON text sequence | 1467503 | 731.5 ± 3.5% | 613.5 ± 13.4% | 558.8 ± 7.0% | 283.4 ± 1.7% | 283.1 ± 3.6% | 222.8 ± 1.1% | 1.192 | 1.309 | 2.581 | 2.584 | 3.283 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.718 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.915 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.645 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.708 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.931 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1078.6 ± 0.9% | 0.480 | 1.005 | 1.015 | 1.017 | 0.436 | 1.012 | 1.011 | 0.415 | 0.800 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 678.1 ± 4.1% | 0.913 | 1.057 | 1.033 | 1.061 | 0.502 | 1.038 | 1.066 | 0.479 | 0.927 | 0.157 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1376.5 ± 2.8% | 0.431 | 0.951 | 0.955 | 0.990 | 0.986 | 0.253 | 0.988 | 0.452 | 0.761 | 0.092 | 1.016 |
| qlog records, JSON text sequence | 1467503 | 874.7 ± 23.1% | 0.758 | 0.969 | 0.934 | 0.982 | 0.931 | 0.345 | 0.935 | 0.572 | 0.853 | 0.157 | 0.926 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.057 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.066 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1078.6 ± 0.9% | 1145.3 ± 0.8% | 861.4 ± 0.5% | 303.9 ± 0.8% | 525.2 ± 0.8% | 291.2 ± 2.7% | 0.942 | 1.252 | 3.549 | 2.054 | 3.704 |
| qlog records, JSON text sequence | 1467503 | 678.1 ± 4.1% | 932.8 ± 0.2% | 808.2 ± 3.7% | 252.1 ± 3.0% | 555.0 ± 5.6% | 236.7 ± 1.7% | 0.727 | 0.839 | 2.690 | 1.222 | 2.866 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1376.5 ± 2.8% | 1123.6 ± 1.1% | 818.6 ± 21.7% | 357.6 ± 1.7% | 366.0 ± 2.6% | 382.6 ± 1.8% | 1.225 | 1.682 | 3.849 | 3.761 | 3.597 |
| qlog records, JSON text sequence | 1467503 | 874.7 ± 23.1% | 634.0 ± 82.6% | 569.4 ± 13.2% | 285.1 ± 6.4% | 294.3 ± 7.2% | 226.1 ± 2.4% | 1.380 | 1.536 | 3.068 | 2.972 | 3.869 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1397.9 ± 6.1% | 1123.6 ± 1.1% | 818.6 ± 21.7% | 357.6 ± 1.7% | 366.0 ± 2.6% | 382.6 ± 1.8% | 1.244 | 1.708 | 3.909 | 3.819 | 3.653 |
| qlog records, JSON text sequence | 1467503 | 809.6 ± 24.7% | 634.0 ± 82.6% | 569.4 ± 13.2% | 285.1 ± 6.4% | 294.3 ± 7.2% | 226.1 ± 2.4% | 1.277 | 1.422 | 2.840 | 2.751 | 3.582 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 862.4 ± 3.5% | 1145.3 ± 0.8% | 861.4 ± 0.5% | 303.9 ± 0.8% | 525.2 ± 0.8% | 291.2 ± 2.7% | 0.753 | 1.001 | 2.837 | 1.642 | 2.962 |
| qlog records, JSON text sequence | 1467503 | 628.9 ± 6.7% | 932.8 ± 0.2% | 808.2 ± 3.7% | 252.1 ± 3.0% | 555.0 ± 5.6% | 236.7 ± 1.7% | 0.674 | 0.778 | 2.495 | 1.133 | 2.657 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1047.2 ± 5.1% | 1123.6 ± 1.1% | 818.6 ± 21.7% | 357.6 ± 1.7% | 366.0 ± 2.6% | 382.6 ± 1.8% | 0.932 | 1.279 | 2.929 | 2.861 | 2.737 |
| qlog records, JSON text sequence | 1467503 | 745.7 ± 9.8% | 634.0 ± 82.6% | 569.4 ± 13.2% | 285.1 ± 6.4% | 294.3 ± 7.2% | 226.1 ± 2.4% | 1.176 | 1.310 | 2.616 | 2.534 | 3.299 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.942 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.727 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.839 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.753 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.674 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.778 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.932 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1018.4 ± 1.6% | 0.495 | 1.007 | 1.018 | 1.019 | 0.456 | 1.020 | 1.020 | 0.441 | 0.871 | 0.109 |
| qlog records, JSON text sequence | 1467503 | 686.2 ± 1.8% | 0.898 | 1.057 | 1.020 | 1.043 | 0.499 | 1.029 | 1.046 | 0.475 | 0.960 | 0.154 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1384.1 ± 0.7% | 0.435 | 0.952 | 0.970 | 0.994 | 0.988 | 0.256 | 0.986 | 0.456 | 0.762 | 0.091 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 998.7 ± 447.9% | 0.708 | 0.982 | 1.031 | 1.022 | 0.999 | 0.305 | 1.019 | 0.506 | 0.808 | 0.138 | 1.039 |

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
| CLDR supplemental, 34 texts | 920675 | 1018.4 ± 1.6% | 1103.9 ± 0.5% | 854.4 ± 1.5% | 306.6 ± 1.9% | 526.2 ± 0.6% | 293.3 ± 2.6% | 0.923 | 1.192 | 3.322 | 1.935 | 3.472 |
| qlog records, JSON text sequence | 1467503 | 686.2 ± 1.8% | 926.7 ± 2.3% | 815.8 ± 3.9% | 252.3 ± 1.1% | 564.6 ± 2.1% | 236.7 ± 1.4% | 0.741 | 0.841 | 2.720 | 1.215 | 2.899 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1384.1 ± 0.7% | 1132.6 ± 0.2% | 845.0 ± 4.1% | 362.7 ± 1.8% | 370.9 ± 2.0% | 383.7 ± 2.1% | 1.222 | 1.638 | 3.816 | 3.732 | 3.607 |
| qlog records, JSON text sequence | 1467503 | 998.7 ± 447.9% | 748.8 ± 11.0% | 611.6 ± 8.7% | 293.4 ± 4.7% | 310.9 ± 5.9% | 227.0 ± 36.3% | 1.334 | 1.633 | 3.404 | 3.212 | 4.399 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1407.0 ± 0.4% | 1132.6 ± 0.2% | 845.0 ± 4.1% | 362.7 ± 1.8% | 370.9 ± 2.0% | 383.7 ± 2.1% | 1.242 | 1.665 | 3.879 | 3.794 | 3.667 |
| qlog records, JSON text sequence | 1467503 | 1037.2 ± 8.2% | 748.8 ± 11.0% | 611.6 ± 8.7% | 293.4 ± 4.7% | 310.9 ± 5.9% | 227.0 ± 36.3% | 1.385 | 1.696 | 3.535 | 3.336 | 4.569 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 886.8 ± 1.9% | 1103.9 ± 0.5% | 854.4 ± 1.5% | 306.6 ± 1.9% | 526.2 ± 0.6% | 293.3 ± 2.6% | 0.803 | 1.038 | 2.892 | 1.685 | 3.023 |
| qlog records, JSON text sequence | 1467503 | 658.7 ± 2.7% | 926.7 ± 2.3% | 815.8 ± 3.9% | 252.3 ± 1.1% | 564.6 ± 2.1% | 236.7 ± 1.4% | 0.711 | 0.807 | 2.611 | 1.167 | 2.783 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1054.6 ± 0.7% | 1132.6 ± 0.2% | 845.0 ± 4.1% | 362.7 ± 1.8% | 370.9 ± 2.0% | 383.7 ± 2.1% | 0.931 | 1.248 | 2.908 | 2.843 | 2.748 |
| qlog records, JSON text sequence | 1467503 | 806.5 ± 12.2% | 748.8 ± 11.0% | 611.6 ± 8.7% | 293.4 ± 4.7% | 310.9 ± 5.9% | 227.0 ± 36.3% | 1.077 | 1.319 | 2.749 | 2.594 | 3.552 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.923 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.741 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.841 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.803 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.711 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.807 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.931 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1066.0 ± 0.4% | 0.490 | 1.038 | 1.049 | 1.049 | 0.446 | 1.052 | 1.049 | 0.421 | 0.735 | 0.105 |
| qlog records, JSON text sequence | 1467503 | 686.6 ± 6.3% | 0.931 | 1.071 | 1.051 | 1.073 | 0.511 | 1.046 | 1.057 | 0.475 | 0.812 | 0.155 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1374.9 ± 2.8% | 0.422 | 0.962 | 0.948 | 0.989 | 0.998 | 0.260 | 1.002 | 0.463 | 0.767 | 0.091 | 1.007 |
| qlog records, JSON text sequence | 1467503 | 994.2 ± 13.2% | 0.715 | 0.975 | 1.053 | 1.003 | 0.986 | 0.312 | 0.993 | 0.516 | 0.831 | 0.138 | 1.071 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.052 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.071 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.073 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1066.0 ± 0.4% | 1149.5 ± 1.8% | 861.2 ± 1.7% | 307.0 ± 1.6% | 525.9 ± 0.7% | 292.6 ± 1.8% | 0.927 | 1.238 | 3.472 | 2.027 | 3.644 |
| qlog records, JSON text sequence | 1467503 | 686.6 ± 6.3% | 905.2 ± 7.7% | 810.9 ± 23.2% | 254.4 ± 6.1% | 566.0 ± 7.5% | 235.8 ± 3.6% | 0.759 | 0.847 | 2.699 | 1.213 | 2.912 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1374.9 ± 2.8% | 1122.9 ± 4.7% | 847.2 ± 4.7% | 361.2 ± 1.5% | 370.9 ± 5.0% | 387.4 ± 1.9% | 1.224 | 1.623 | 3.806 | 3.707 | 3.549 |
| qlog records, JSON text sequence | 1467503 | 994.2 ± 13.2% | 698.6 ± 21.7% | 641.7 ± 15.4% | 300.0 ± 5.4% | 304.6 ± 4.4% | 228.5 ± 3.8% | 1.423 | 1.549 | 3.313 | 3.264 | 4.350 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1384.3 ± 2.3% | 1122.9 ± 4.7% | 847.2 ± 4.7% | 361.2 ± 1.5% | 370.9 ± 5.0% | 387.4 ± 1.9% | 1.233 | 1.634 | 3.832 | 3.732 | 3.574 |
| qlog records, JSON text sequence | 1467503 | 1064.9 ± 38.4% | 698.6 ± 21.7% | 641.7 ± 15.4% | 300.0 ± 5.4% | 304.6 ± 4.4% | 228.5 ± 3.8% | 1.524 | 1.659 | 3.549 | 3.496 | 4.660 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 783.4 ± 0.3% | 1149.5 ± 1.8% | 861.2 ± 1.7% | 307.0 ± 1.6% | 525.9 ± 0.7% | 292.6 ± 1.8% | 0.682 | 0.910 | 2.552 | 1.490 | 2.678 |
| qlog records, JSON text sequence | 1467503 | 557.3 ± 13.2% | 905.2 ± 7.7% | 810.9 ± 23.2% | 254.4 ± 6.1% | 566.0 ± 7.5% | 235.8 ± 3.6% | 0.616 | 0.687 | 2.191 | 0.985 | 2.363 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1055.1 ± 1.7% | 1122.9 ± 4.7% | 847.2 ± 4.7% | 361.2 ± 1.5% | 370.9 ± 5.0% | 387.4 ± 1.9% | 0.940 | 1.245 | 2.921 | 2.845 | 2.724 |
| qlog records, JSON text sequence | 1467503 | 826.2 ± 9.2% | 698.6 ± 21.7% | 641.7 ± 15.4% | 300.0 ± 5.4% | 304.6 ± 4.4% | 228.5 ± 3.8% | 1.183 | 1.288 | 2.754 | 2.713 | 3.615 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.927 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.759 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.682 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.910 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.616 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.687 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.940 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1080.3 ± 0.6% | 0.479 | 1.005 | 1.013 | 1.003 | 0.438 | 1.017 | 1.007 | 0.416 | 0.787 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 700.4 ± 4.6% | 0.899 | 1.050 | 1.012 | 1.017 | 0.506 | 1.014 | 1.018 | 0.480 | 0.919 | 0.151 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1378.0 ± 0.6% | 0.431 | 0.952 | 0.970 | 0.995 | 0.990 | 0.255 | 0.988 | 0.455 | 0.761 | 0.091 | 1.013 |
| qlog records, JSON text sequence | 1467503 | 965.8 ± 22.7% | 0.714 | 0.895 | 0.978 | 1.003 | 0.974 | 0.313 | 1.001 | 0.522 | 0.778 | 0.142 | 0.998 |

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
| CLDR supplemental, 34 texts | 920675 | 1080.3 ± 0.6% | 1057.0 ± 0.4% | 859.8 ± 3.4% | 306.2 ± 1.4% | 526.5 ± 1.1% | 291.4 ± 4.1% | 1.022 | 1.256 | 3.528 | 2.052 | 3.708 |
| qlog records, JSON text sequence | 1467503 | 700.4 ± 4.6% | 881.0 ± 2.6% | 820.8 ± 3.6% | 251.1 ± 2.2% | 586.4 ± 6.4% | 236.3 ± 3.1% | 0.795 | 0.853 | 2.789 | 1.194 | 2.964 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1378.0 ± 0.6% | 1131.3 ± 0.4% | 843.6 ± 2.5% | 359.8 ± 1.1% | 369.4 ± 0.5% | 386.8 ± 1.6% | 1.218 | 1.633 | 3.830 | 3.731 | 3.563 |
| qlog records, JSON text sequence | 1467503 | 965.8 ± 22.7% | 637.1 ± 22.7% | 589.1 ± 9.7% | 289.2 ± 3.1% | 303.5 ± 4.9% | 226.0 ± 1.6% | 1.516 | 1.639 | 3.339 | 3.182 | 4.274 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1396.3 ± 27.6% | 1131.3 ± 0.4% | 843.6 ± 2.5% | 359.8 ± 1.1% | 369.4 ± 0.5% | 386.8 ± 1.6% | 1.234 | 1.655 | 3.881 | 3.780 | 3.610 |
| qlog records, JSON text sequence | 1467503 | 963.6 ± 19.7% | 637.1 ± 22.7% | 589.1 ± 9.7% | 289.2 ± 3.1% | 303.5 ± 4.9% | 226.0 ± 1.6% | 1.512 | 1.636 | 3.332 | 3.175 | 4.264 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 850.4 ± 2.6% | 1057.0 ± 0.4% | 859.8 ± 3.4% | 306.2 ± 1.4% | 526.5 ± 1.1% | 291.4 ± 4.1% | 0.805 | 0.989 | 2.777 | 1.615 | 2.919 |
| qlog records, JSON text sequence | 1467503 | 643.7 ± 1.4% | 881.0 ± 2.6% | 820.8 ± 3.6% | 251.1 ± 2.2% | 586.4 ± 6.4% | 236.3 ± 3.1% | 0.731 | 0.784 | 2.563 | 1.098 | 2.724 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1048.1 ± 0.4% | 1131.3 ± 0.4% | 843.6 ± 2.5% | 359.8 ± 1.1% | 369.4 ± 0.5% | 386.8 ± 1.6% | 0.926 | 1.242 | 2.913 | 2.838 | 2.710 |
| qlog records, JSON text sequence | 1467503 | 751.6 ± 13.6% | 637.1 ± 22.7% | 589.1 ± 9.7% | 289.2 ± 3.1% | 303.5 ± 4.9% | 226.0 ± 1.6% | 1.180 | 1.276 | 2.599 | 2.477 | 3.326 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.795 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.853 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.805 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.731 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.784 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1080.4 ± 0.5% | 0.478 | 1.004 | 1.014 | 1.015 | 0.437 | 1.016 | 1.015 | 0.416 | 0.819 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 681.5 ± 8.7% | 0.910 | 1.060 | 1.028 | 1.044 | 0.497 | 1.029 | 1.056 | 0.479 | 0.972 | 0.155 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1380.6 ± 3.6% | 0.433 | 0.952 | 0.969 | 0.999 | 0.986 | 0.255 | 0.982 | 0.453 | 0.760 | 0.091 | 1.016 |
| qlog records, JSON text sequence | 1467503 | 791.7 ± 7.4% | 0.844 | 0.991 | 1.023 | 1.005 | 1.045 | 0.381 | 1.044 | 0.623 | 0.894 | 0.173 | 1.018 |

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
| CLDR supplemental, 34 texts | 920675 | 1080.4 ± 0.5% | 1125.0 ± 4.7% | 857.1 ± 0.7% | 306.8 ± 1.5% | 525.7 ± 4.3% | 290.2 ± 1.0% | 0.960 | 1.260 | 3.522 | 2.055 | 3.723 |
| qlog records, JSON text sequence | 1467503 | 681.5 ± 8.7% | 929.8 ± 4.4% | 791.7 ± 20.6% | 251.7 ± 0.5% | 565.7 ± 6.1% | 236.1 ± 2.4% | 0.733 | 0.861 | 2.708 | 1.205 | 2.887 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1380.6 ± 3.6% | 1133.6 ± 0.7% | 842.3 ± 3.1% | 361.5 ± 1.0% | 369.1 ± 1.3% | 382.8 ± 1.0% | 1.218 | 1.639 | 3.819 | 3.741 | 3.607 |
| qlog records, JSON text sequence | 1467503 | 791.7 ± 7.4% | 564.2 ± 9.9% | 544.3 ± 5.1% | 281.7 ± 2.9% | 292.3 ± 2.6% | 223.7 ± 1.3% | 1.403 | 1.455 | 2.811 | 2.709 | 3.539 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1403.0 ± 0.6% | 1133.6 ± 0.7% | 842.3 ± 3.1% | 361.5 ± 1.0% | 369.1 ± 1.3% | 382.8 ± 1.0% | 1.238 | 1.666 | 3.881 | 3.801 | 3.665 |
| qlog records, JSON text sequence | 1467503 | 805.6 ± 6.5% | 564.2 ± 9.9% | 544.3 ± 5.1% | 281.7 ± 2.9% | 292.3 ± 2.6% | 223.7 ± 1.3% | 1.428 | 1.480 | 2.860 | 2.756 | 3.601 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 884.8 ± 2.7% | 1125.0 ± 4.7% | 857.1 ± 0.7% | 306.8 ± 1.5% | 525.7 ± 4.3% | 290.2 ± 1.0% | 0.786 | 1.032 | 2.884 | 1.683 | 3.049 |
| qlog records, JSON text sequence | 1467503 | 662.1 ± 36.1% | 929.8 ± 4.4% | 791.7 ± 20.6% | 251.7 ± 0.5% | 565.7 ± 6.1% | 236.1 ± 2.4% | 0.712 | 0.836 | 2.631 | 1.170 | 2.805 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1049.1 ± 0.3% | 1133.6 ± 0.7% | 842.3 ± 3.1% | 361.5 ± 1.0% | 369.1 ± 1.3% | 382.8 ± 1.0% | 0.925 | 1.245 | 2.902 | 2.842 | 2.741 |
| qlog records, JSON text sequence | 1467503 | 707.9 ± 6.8% | 564.2 ± 9.9% | 544.3 ± 5.1% | 281.7 ± 2.9% | 292.3 ± 2.6% | 223.7 ± 1.3% | 1.255 | 1.301 | 2.513 | 2.422 | 3.164 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.733 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.786 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.925 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1065.0 ± 0.6% | 0.489 | 1.035 | 1.049 | 1.047 | 0.446 | 1.052 | 1.050 | 0.421 | 0.738 | 0.105 |
| qlog records, JSON text sequence | 1467503 | 650.4 ± 4.7% | 0.960 | 1.085 | 1.077 | 1.095 | 0.526 | 1.086 | 1.113 | 0.496 | 0.787 | 0.157 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1364.8 ± 1.5% | 0.421 | 0.959 | 0.962 | 0.997 | 0.988 | 0.255 | 1.000 | 0.453 | 0.767 | 0.091 | 1.011 |
| qlog records, JSON text sequence | 1467503 | 796.9 ± 5.2% | 0.825 | 1.005 | 1.030 | 1.027 | 1.005 | 0.382 | 1.031 | 0.613 | 0.865 | 0.171 | 1.056 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.052 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.050 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.085 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.077 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.095 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.086 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.113 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1065.0 ± 0.6% | 1116.9 ± 0.8% | 853.9 ± 10.3% | 306.3 ± 12.5% | 526.1 ± 1.1% | 292.4 ± 3.9% | 0.953 | 1.247 | 3.477 | 2.024 | 3.642 |
| qlog records, JSON text sequence | 1467503 | 650.4 ± 4.7% | 923.7 ± 0.5% | 784.2 ± 5.3% | 251.8 ± 2.3% | 538.6 ± 7.9% | 233.2 ± 1.5% | 0.704 | 0.829 | 2.583 | 1.208 | 2.789 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1364.8 ± 1.5% | 1116.2 ± 4.0% | 810.7 ± 11.6% | 353.3 ± 13.9% | 361.6 ± 2.3% | 379.4 ± 1.0% | 1.223 | 1.684 | 3.863 | 3.774 | 3.597 |
| qlog records, JSON text sequence | 1467503 | 796.9 ± 5.2% | 538.1 ± 4.2% | 524.6 ± 2.8% | 281.6 ± 1.3% | 280.4 ± 0.8% | 222.6 ± 0.8% | 1.481 | 1.519 | 2.830 | 2.842 | 3.581 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1379.6 ± 3.9% | 1116.2 ± 4.0% | 810.7 ± 11.6% | 353.3 ± 13.9% | 361.6 ± 2.3% | 379.4 ± 1.0% | 1.236 | 1.702 | 3.905 | 3.815 | 3.636 |
| qlog records, JSON text sequence | 1467503 | 842.0 ± 0.8% | 538.1 ± 4.2% | 524.6 ± 2.8% | 281.6 ± 1.3% | 280.4 ± 0.8% | 222.6 ± 0.8% | 1.565 | 1.605 | 2.990 | 3.003 | 3.783 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 786.2 ± 0.3% | 1116.9 ± 0.8% | 853.9 ± 10.3% | 306.3 ± 12.5% | 526.1 ± 1.1% | 292.4 ± 3.9% | 0.704 | 0.921 | 2.567 | 1.494 | 2.688 |
| qlog records, JSON text sequence | 1467503 | 511.7 ± 6.5% | 923.7 ± 0.5% | 784.2 ± 5.3% | 251.8 ± 2.3% | 538.6 ± 7.9% | 233.2 ± 1.5% | 0.554 | 0.653 | 2.032 | 0.950 | 2.194 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1047.2 ± 4.3% | 1116.2 ± 4.0% | 810.7 ± 11.6% | 353.3 ± 13.9% | 361.6 ± 2.3% | 379.4 ± 1.0% | 0.938 | 1.292 | 2.964 | 2.896 | 2.760 |
| qlog records, JSON text sequence | 1467503 | 689.2 ± 6.5% | 538.1 ± 4.2% | 524.6 ± 2.8% | 281.6 ± 1.3% | 280.4 ± 0.8% | 222.6 ± 0.8% | 1.281 | 1.314 | 2.448 | 2.458 | 3.096 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.704 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.829 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.704 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.554 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.653 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.938 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1079.5 ± 0.6% | 0.479 | 1.005 | 1.016 | 1.018 | 0.438 | 1.018 | 1.017 | 0.417 | 0.801 | 0.104 |
| qlog records, JSON text sequence | 1467503 | 671.4 ± 7.2% | 0.914 | 1.076 | 1.033 | 1.058 | 0.507 | 1.025 | 1.045 | 0.480 | 0.926 | 0.158 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1364.8 ± 4.8% | 0.423 | 0.952 | 0.973 | 0.996 | 0.995 | 0.253 | 0.991 | 0.453 | 0.764 | 0.092 | 1.024 |
| qlog records, JSON text sequence | 1467503 | 804.9 ± 5.2% | 0.827 | 0.986 | 0.997 | 1.026 | 1.002 | 0.373 | 0.983 | 0.617 | 0.860 | 0.170 | 0.982 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.076 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1079.5 ± 0.6% | 1154.4 ± 6.3% | 846.8 ± 0.5% | 306.8 ± 0.3% | 526.8 ± 0.7% | 293.7 ± 2.0% | 0.935 | 1.275 | 3.519 | 2.049 | 3.675 |
| qlog records, JSON text sequence | 1467503 | 671.4 ± 7.2% | 934.6 ± 0.3% | 775.5 ± 2.9% | 250.3 ± 1.4% | 553.1 ± 23.5% | 234.3 ± 3.9% | 0.718 | 0.866 | 2.682 | 1.214 | 2.866 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1364.8 ± 4.8% | 1126.7 ± 0.9% | 828.4 ± 5.7% | 360.4 ± 1.5% | 368.7 ± 2.2% | 379.8 ± 3.0% | 1.211 | 1.647 | 3.787 | 3.701 | 3.594 |
| qlog records, JSON text sequence | 1467503 | 804.9 ± 5.2% | 563.6 ± 16.1% | 557.3 ± 8.5% | 280.7 ± 1.1% | 291.2 ± 3.9% | 223.6 ± 0.6% | 1.428 | 1.444 | 2.867 | 2.764 | 3.600 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1396.9 ± 2.8% | 1126.7 ± 0.9% | 828.4 ± 5.7% | 360.4 ± 1.5% | 368.7 ± 2.2% | 379.8 ± 3.0% | 1.240 | 1.686 | 3.876 | 3.789 | 3.678 |
| qlog records, JSON text sequence | 1467503 | 790.5 ± 7.2% | 563.6 ± 16.1% | 557.3 ± 8.5% | 280.7 ± 1.1% | 291.2 ± 3.9% | 223.6 ± 0.6% | 1.402 | 1.418 | 2.816 | 2.714 | 3.535 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 864.4 ± 12.5% | 1154.4 ± 6.3% | 846.8 ± 0.5% | 306.8 ± 0.3% | 526.8 ± 0.7% | 293.7 ± 2.0% | 0.749 | 1.021 | 2.818 | 1.641 | 2.943 |
| qlog records, JSON text sequence | 1467503 | 621.9 ± 4.5% | 934.6 ± 0.3% | 775.5 ± 2.9% | 250.3 ± 1.4% | 553.1 ± 23.5% | 234.3 ± 3.9% | 0.665 | 0.802 | 2.485 | 1.124 | 2.655 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1042.9 ± 1.2% | 1126.7 ± 0.9% | 828.4 ± 5.7% | 360.4 ± 1.5% | 368.7 ± 2.2% | 379.8 ± 3.0% | 0.926 | 1.259 | 2.894 | 2.828 | 2.746 |
| qlog records, JSON text sequence | 1467503 | 692.4 ± 8.0% | 563.6 ± 16.1% | 557.3 ± 8.5% | 280.7 ± 1.1% | 291.2 ± 3.9% | 223.6 ± 0.6% | 1.228 | 1.243 | 2.466 | 2.378 | 3.097 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.935 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.718 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.866 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.749 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.665 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.802 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1078.1 ± 1.9% | 0.479 | 1.002 | 1.012 | 1.002 | 0.439 | 1.016 | 1.018 | 0.416 | 0.822 | 0.103 |
| qlog records, JSON text sequence | 1467503 | 651.8 ± 7.2% | 0.910 | 1.063 | 1.043 | 1.067 | 0.519 | 1.060 | 1.076 | 0.491 | 0.938 | 0.163 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1369.2 ± 21.7% | 0.421 | 0.951 | 0.970 | 1.003 | 0.982 | 0.251 | 0.990 | 0.450 | 0.763 | 0.092 | 1.020 |
| qlog records, JSON text sequence | 1467503 | 788.5 ± 4.9% | 0.855 | 0.989 | 1.033 | 0.994 | 0.998 | 0.380 | 1.009 | 0.624 | 0.886 | 0.174 | 1.016 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.076 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1078.1 ± 1.9% | 1154.5 ± 0.3% | 861.2 ± 0.8% | 306.1 ± 2.2% | 525.6 ± 1.7% | 292.1 ± 1.7% | 0.934 | 1.252 | 3.522 | 2.051 | 3.690 |
| qlog records, JSON text sequence | 1467503 | 651.8 ± 7.2% | 930.0 ± 0.3% | 772.7 ± 13.7% | 247.5 ± 1.8% | 536.1 ± 12.7% | 232.3 ± 1.6% | 0.701 | 0.844 | 2.633 | 1.216 | 2.806 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1369.2 ± 21.7% | 1126.0 ± 1.6% | 819.1 ± 11.3% | 357.2 ± 2.0% | 360.2 ± 2.0% | 378.7 ± 2.3% | 1.216 | 1.672 | 3.833 | 3.801 | 3.615 |
| qlog records, JSON text sequence | 1467503 | 788.5 ± 4.9% | 555.3 ± 13.0% | 525.9 ± 8.7% | 278.9 ± 3.3% | 290.6 ± 1.1% | 223.1 ± 0.5% | 1.420 | 1.499 | 2.827 | 2.713 | 3.534 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1396.7 ± 2.2% | 1126.0 ± 1.6% | 819.1 ± 11.3% | 357.2 ± 2.0% | 360.2 ± 2.0% | 378.7 ± 2.3% | 1.240 | 1.705 | 3.910 | 3.878 | 3.688 |
| qlog records, JSON text sequence | 1467503 | 800.8 ± 5.2% | 555.3 ± 13.0% | 525.9 ± 8.7% | 278.9 ± 3.3% | 290.6 ± 1.1% | 223.1 ± 0.5% | 1.442 | 1.523 | 2.871 | 2.756 | 3.589 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 886.6 ± 0.5% | 1154.5 ± 0.3% | 861.2 ± 0.8% | 306.1 ± 2.2% | 525.6 ± 1.7% | 292.1 ± 1.7% | 0.768 | 1.029 | 2.896 | 1.687 | 3.035 |
| qlog records, JSON text sequence | 1467503 | 611.4 ± 5.1% | 930.0 ± 0.3% | 772.7 ± 13.7% | 247.5 ± 1.8% | 536.1 ± 12.7% | 232.3 ± 1.6% | 0.657 | 0.791 | 2.470 | 1.140 | 2.631 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1045.1 ± 5.2% | 1126.0 ± 1.6% | 819.1 ± 11.3% | 357.2 ± 2.0% | 360.2 ± 2.0% | 378.7 ± 2.3% | 0.928 | 1.276 | 2.926 | 2.902 | 2.760 |
| qlog records, JSON text sequence | 1467503 | 698.3 ± 4.7% | 555.3 ± 13.0% | 525.9 ± 8.7% | 278.9 ± 3.3% | 290.6 ± 1.1% | 223.1 ± 0.5% | 1.257 | 1.328 | 2.504 | 2.403 | 3.129 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.934 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.701 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.844 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.768 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.657 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.791 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.928 of simdjson.
