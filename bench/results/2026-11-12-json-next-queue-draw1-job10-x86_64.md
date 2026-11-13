# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1039.1 ± 3.4% | 0.469 | 1.004 | 1.015 | 1.008 | 0.404 | 1.030 | 1.028 | 0.355 | 0.725 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 852.6 ± 1.2% | 0.734 | 1.032 | 1.009 | 1.001 | 0.389 | 1.014 | 1.002 | 0.338 | 0.646 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1327.8 ± 1.4% | 0.443 | 0.983 | 0.979 | 1.003 | 1.006 | 0.237 | 1.005 | 0.447 | 0.722 | 0.086 | 1.026 |
| qlog records, JSON text sequence | 1467503 | 1161.8 ± 0.3% | 0.699 | 0.920 | 0.985 | 0.980 | 0.986 | 0.227 | 0.986 | 0.402 | 0.679 | 0.104 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1039.1 ± 3.4% | 1008.9 ± 0.5% | 983.3 ± 0.3% | 258.7 ± 0.6% | 529.2 ± 0.6% | 258.0 ± 2.4% | 1.030 | 1.057 | 4.016 | 1.964 | 4.028 |
| qlog records, JSON text sequence | 1467503 | 852.6 ± 1.2% | 811.4 ± 0.5% | 780.6 ± 3.3% | 221.9 ± 6.6% | 587.2 ± 1.2% | 241.6 ± 2.6% | 1.051 | 1.092 | 3.843 | 1.452 | 3.528 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1327.8 ± 1.4% | 1137.1 ± 0.5% | 894.8 ± 1.0% | 319.4 ± 3.2% | 356.2 ± 2.0% | 311.8 ± 2.1% | 1.168 | 1.484 | 4.157 | 3.727 | 4.258 |
| qlog records, JSON text sequence | 1467503 | 1161.8 ± 0.3% | 866.2 ± 1.0% | 722.5 ± 0.6% | 314.1 ± 1.5% | 392.9 ± 0.6% | 233.9 ± 3.4% | 1.341 | 1.608 | 3.698 | 2.957 | 4.968 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1362.2 ± 4.9% | 1137.1 ± 0.5% | 894.8 ± 1.0% | 319.4 ± 3.2% | 356.2 ± 2.0% | 311.8 ± 2.1% | 1.198 | 1.522 | 4.265 | 3.824 | 4.368 |
| qlog records, JSON text sequence | 1467503 | 1173.4 ± 0.4% | 866.2 ± 1.0% | 722.5 ± 0.6% | 314.1 ± 1.5% | 392.9 ± 0.6% | 233.9 ± 3.4% | 1.355 | 1.624 | 3.735 | 2.986 | 5.018 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 753.3 ± 0.9% | 1008.9 ± 0.5% | 983.3 ± 0.3% | 258.7 ± 0.6% | 529.2 ± 0.6% | 258.0 ± 2.4% | 0.747 | 0.766 | 2.912 | 1.424 | 2.920 |
| qlog records, JSON text sequence | 1467503 | 550.6 ± 3.1% | 811.4 ± 0.5% | 780.6 ± 3.3% | 221.9 ± 6.6% | 587.2 ± 1.2% | 241.6 ± 2.6% | 0.679 | 0.705 | 2.482 | 0.938 | 2.279 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 958.4 ± 1.5% | 1137.1 ± 0.5% | 894.8 ± 1.0% | 319.4 ± 3.2% | 356.2 ± 2.0% | 311.8 ± 2.1% | 0.843 | 1.071 | 3.001 | 2.691 | 3.073 |
| qlog records, JSON text sequence | 1467503 | 788.8 ± 0.5% | 866.2 ± 1.0% | 722.5 ± 0.6% | 314.1 ± 1.5% | 392.9 ± 0.6% | 233.9 ± 3.4% | 0.911 | 1.092 | 2.511 | 2.008 | 3.373 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.747 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.766 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.679 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.705 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.938 of serde_json.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.843 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.911 of simdjson.

# bench-json, CLDR and qlog alone: null, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1008.5 ± 5.4% | 0.475 | 1.037 | 1.088 | 1.088 | 0.428 | 1.074 | 1.087 | 0.367 | 0.768 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 829.6 ± 1.7% | 0.744 | 1.034 | 1.016 | 1.000 | 0.398 | 1.023 | 0.999 | 0.350 | 0.677 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1342.8 ± 0.7% | 0.403 | 0.972 | 0.949 | 1.001 | 0.989 | 0.228 | 0.980 | 0.439 | 0.708 | 0.085 | 1.011 |
| qlog records, JSON text sequence | 1467503 | 1154.0 ± 2.2% | 0.664 | 0.948 | 0.991 | 0.996 | 0.995 | 0.222 | 0.988 | 0.412 | 0.697 | 0.104 | 1.014 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.088 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.088 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.074 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.087 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1008.5 ± 5.4% | 1004.8 ± 0.6% | 984.7 ± 0.9% | 260.0 ± 3.9% | 531.1 ± 1.7% | 259.1 ± 2.2% | 1.004 | 1.024 | 3.879 | 1.899 | 3.892 |
| qlog records, JSON text sequence | 1467503 | 829.6 ± 1.7% | 811.2 ± 0.5% | 804.6 ± 3.6% | 223.2 ± 1.0% | 587.3 ± 0.4% | 243.5 ± 1.5% | 1.023 | 1.031 | 3.717 | 1.412 | 3.407 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1342.8 ± 0.7% | 1131.6 ± 0.9% | 898.2 ± 1.6% | 331.8 ± 4.7% | 365.4 ± 0.5% | 314.3 ± 1.1% | 1.187 | 1.495 | 4.047 | 3.675 | 4.272 |
| qlog records, JSON text sequence | 1467503 | 1154.0 ± 2.2% | 870.1 ± 0.7% | 725.4 ± 3.8% | 320.3 ± 3.0% | 392.2 ± 1.4% | 231.4 ± 1.9% | 1.326 | 1.591 | 3.603 | 2.943 | 4.986 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1357.2 ± 1.8% | 1131.6 ± 0.9% | 898.2 ± 1.6% | 331.8 ± 4.7% | 365.4 ± 0.5% | 314.3 ± 1.1% | 1.199 | 1.511 | 4.090 | 3.715 | 4.318 |
| qlog records, JSON text sequence | 1467503 | 1169.7 ± 4.8% | 870.1 ± 0.7% | 725.4 ± 3.8% | 320.3 ± 3.0% | 392.2 ± 1.4% | 231.4 ± 1.9% | 1.344 | 1.613 | 3.652 | 2.983 | 5.054 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 774.3 ± 0.2% | 1004.8 ± 0.6% | 984.7 ± 0.9% | 260.0 ± 3.9% | 531.1 ± 1.7% | 259.1 ± 2.2% | 0.771 | 0.786 | 2.978 | 1.458 | 2.988 |
| qlog records, JSON text sequence | 1467503 | 561.2 ± 1.0% | 811.2 ± 0.5% | 804.6 ± 3.6% | 223.2 ± 1.0% | 587.3 ± 0.4% | 243.5 ± 1.5% | 0.692 | 0.698 | 2.514 | 0.956 | 2.305 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 951.0 ± 0.9% | 1131.6 ± 0.9% | 898.2 ± 1.6% | 331.8 ± 4.7% | 365.4 ± 0.5% | 314.3 ± 1.1% | 0.840 | 1.059 | 2.866 | 2.603 | 3.026 |
| qlog records, JSON text sequence | 1467503 | 803.8 ± 0.7% | 870.1 ± 0.7% | 725.4 ± 3.8% | 320.3 ± 3.0% | 392.2 ± 1.4% | 231.4 ± 1.9% | 0.924 | 1.108 | 2.510 | 2.050 | 3.473 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.771 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.786 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.692 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.698 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.840 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.924 of simdjson.

# bench-json, CLDR and qlog alone: head, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1014.6 ± 4.1% | 0.472 | 0.983 | 1.079 | 1.075 | 0.424 | 1.064 | 1.072 | 0.365 | 0.785 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 836.5 ± 1.0% | 0.741 | 1.032 | 1.015 | 1.010 | 0.391 | 1.013 | 1.008 | 0.345 | 0.891 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1325.1 ± 4.7% | 0.441 | 0.984 | 0.977 | 1.007 | 1.017 | 0.231 | 1.014 | 0.442 | 0.728 | 0.086 | 1.012 |
| qlog records, JSON text sequence | 1467503 | 1155.8 ± 0.5% | 0.690 | 0.950 | 0.983 | 0.992 | 0.993 | 0.222 | 0.991 | 0.413 | 0.700 | 0.105 | 1.019 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.079 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.075 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.064 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.072 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1014.6 ± 4.1% | 1016.2 ± 2.5% | 983.2 ± 0.6% | 259.8 ± 1.4% | 532.2 ± 6.8% | 253.9 ± 3.3% | 0.999 | 1.032 | 3.905 | 1.907 | 3.996 |
| qlog records, JSON text sequence | 1467503 | 836.5 ± 1.0% | 807.3 ± 0.8% | 790.6 ± 2.3% | 222.0 ± 4.8% | 589.9 ± 1.8% | 245.1 ± 10.1% | 1.036 | 1.058 | 3.769 | 1.418 | 3.413 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1325.1 ± 4.7% | 1139.3 ± 1.8% | 895.8 ± 0.7% | 332.6 ± 0.3% | 361.7 ± 2.6% | 311.6 ± 1.0% | 1.163 | 1.479 | 3.984 | 3.663 | 4.252 |
| qlog records, JSON text sequence | 1467503 | 1155.8 ± 0.5% | 871.8 ± 0.5% | 728.5 ± 0.4% | 323.5 ± 0.5% | 390.6 ± 0.8% | 232.4 ± 4.5% | 1.326 | 1.587 | 3.572 | 2.959 | 4.974 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1341.3 ± 1.8% | 1139.3 ± 1.8% | 895.8 ± 0.7% | 332.6 ± 0.3% | 361.7 ± 2.6% | 311.6 ± 1.0% | 1.177 | 1.497 | 4.033 | 3.708 | 4.304 |
| qlog records, JSON text sequence | 1467503 | 1177.3 ± 1.0% | 871.8 ± 0.5% | 728.5 ± 0.4% | 323.5 ± 0.5% | 390.6 ± 0.8% | 232.4 ± 4.5% | 1.350 | 1.616 | 3.639 | 3.014 | 5.067 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 796.4 ± 4.6% | 1016.2 ± 2.5% | 983.2 ± 0.6% | 259.8 ± 1.4% | 532.2 ± 6.8% | 253.9 ± 3.3% | 0.784 | 0.810 | 3.066 | 1.497 | 3.136 |
| qlog records, JSON text sequence | 1467503 | 745.4 ± 5.2% | 807.3 ± 0.8% | 790.6 ± 2.3% | 222.0 ± 4.8% | 589.9 ± 1.8% | 245.1 ± 10.1% | 0.923 | 0.943 | 3.358 | 1.264 | 3.041 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 965.2 ± 0.7% | 1139.3 ± 1.8% | 895.8 ± 0.7% | 332.6 ± 0.3% | 361.7 ± 2.6% | 311.6 ± 1.0% | 0.847 | 1.078 | 2.902 | 2.668 | 3.097 |
| qlog records, JSON text sequence | 1467503 | 808.7 ± 0.4% | 871.8 ± 0.5% | 728.5 ± 0.4% | 323.5 ± 0.5% | 390.6 ± 0.8% | 232.4 ± 4.5% | 0.928 | 1.110 | 2.500 | 2.070 | 3.480 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.784 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.810 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.923 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.943 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.847 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.928 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1038.0 ± 4.3% | 0.428 | 1.013 | 1.018 | 1.027 | 0.408 | 1.028 | 1.015 | 0.356 | 0.786 | 0.085 |
| qlog records, JSON text sequence | 1467503 | 848.0 ± 0.9% | 0.725 | 1.038 | 1.021 | 0.975 | 0.394 | 1.023 | 0.978 | 0.341 | 0.687 | 0.096 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1328.8 ± 1.6% | 0.442 | 0.982 | 0.986 | 1.007 | 0.998 | 0.237 | 1.001 | 0.446 | 0.719 | 0.086 | 1.030 |
| qlog records, JSON text sequence | 1467503 | 1164.2 ± 0.4% | 0.701 | 0.918 | 0.984 | 0.980 | 0.983 | 0.227 | 0.984 | 0.407 | 0.689 | 0.104 | 1.007 |

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
| CLDR supplemental, 34 texts | 920675 | 1038.0 ± 4.3% | 1025.0 ± 0.4% | 982.7 ± 0.8% | 259.6 ± 0.6% | 528.6 ± 1.0% | 259.4 ± 2.8% | 1.013 | 1.056 | 3.998 | 1.964 | 4.001 |
| qlog records, JSON text sequence | 1467503 | 848.0 ± 0.9% | 814.2 ± 0.3% | 815.9 ± 1.9% | 222.2 ± 3.9% | 588.0 ± 1.3% | 243.0 ± 2.6% | 1.042 | 1.039 | 3.817 | 1.442 | 3.490 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1328.8 ± 1.6% | 1128.0 ± 2.1% | 897.0 ± 0.9% | 272.9 ± 0.3% | 358.6 ± 1.0% | 314.4 ± 0.2% | 1.178 | 1.481 | 4.869 | 3.706 | 4.227 |
| qlog records, JSON text sequence | 1467503 | 1164.2 ± 0.4% | 866.7 ± 0.7% | 725.0 ± 0.3% | 252.3 ± 0.5% | 392.5 ± 0.5% | 233.0 ± 1.7% | 1.343 | 1.606 | 4.614 | 2.966 | 4.996 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1368.4 ± 1.2% | 1128.0 ± 2.1% | 897.0 ± 0.9% | 272.9 ± 0.3% | 358.6 ± 1.0% | 314.4 ± 0.2% | 1.213 | 1.526 | 5.014 | 3.816 | 4.353 |
| qlog records, JSON text sequence | 1467503 | 1172.8 ± 0.3% | 866.7 ± 0.7% | 725.0 ± 0.3% | 252.3 ± 0.5% | 392.5 ± 0.5% | 233.0 ± 1.7% | 1.353 | 1.618 | 4.648 | 2.988 | 5.034 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 815.9 ± 0.6% | 1025.0 ± 0.4% | 982.7 ± 0.8% | 259.6 ± 0.6% | 528.6 ± 1.0% | 259.4 ± 2.8% | 0.796 | 0.830 | 3.143 | 1.544 | 3.145 |
| qlog records, JSON text sequence | 1467503 | 582.5 ± 0.9% | 814.2 ± 0.3% | 815.9 ± 1.9% | 222.2 ± 3.9% | 588.0 ± 1.3% | 243.0 ± 2.6% | 0.715 | 0.714 | 2.622 | 0.991 | 2.398 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 955.1 ± 0.5% | 1128.0 ± 2.1% | 897.0 ± 0.9% | 272.9 ± 0.3% | 358.6 ± 1.0% | 314.4 ± 0.2% | 0.847 | 1.065 | 3.500 | 2.664 | 3.038 |
| qlog records, JSON text sequence | 1467503 | 801.7 ± 0.3% | 866.7 ± 0.7% | 725.0 ± 0.3% | 252.3 ± 0.5% | 392.5 ± 0.5% | 233.0 ± 1.7% | 0.925 | 1.106 | 3.177 | 2.043 | 3.441 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.796 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.830 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.715 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.714 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.847 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.925 of simdjson.

# bench-json, CLDR and qlog alone: null, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1022.2 ± 3.2% | 0.469 | 1.023 | 1.074 | 1.074 | 0.423 | 1.063 | 1.073 | 0.362 | 0.755 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 828.4 ± 1.1% | 0.744 | 1.030 | 1.016 | 0.999 | 0.399 | 1.024 | 0.998 | 0.349 | 0.676 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.3 ± 4.9% | 0.403 | 0.972 | 0.959 | 1.012 | 1.001 | 0.230 | 0.997 | 0.442 | 0.723 | 0.086 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1158.7 ± 1.0% | 0.690 | 0.947 | 0.985 | 0.994 | 0.979 | 0.222 | 0.977 | 0.410 | 0.691 | 0.104 | 1.000 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.074 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.074 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.063 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 1022.2 ± 3.2% | 1009.2 ± 0.4% | 982.4 ± 0.7% | 260.2 ± 0.3% | 531.2 ± 0.4% | 259.4 ± 2.9% | 1.013 | 1.041 | 3.929 | 1.924 | 3.941 |
| qlog records, JSON text sequence | 1467503 | 828.4 ± 1.1% | 809.9 ± 0.4% | 813.6 ± 3.9% | 223.5 ± 2.5% | 587.0 ± 4.9% | 245.6 ± 4.5% | 1.023 | 1.018 | 3.707 | 1.411 | 3.373 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.3 ± 4.9% | 1133.0 ± 1.1% | 890.9 ± 5.3% | 332.3 ± 0.6% | 366.5 ± 0.8% | 314.3 ± 4.5% | 1.178 | 1.498 | 4.015 | 3.641 | 4.245 |
| qlog records, JSON text sequence | 1467503 | 1158.7 ± 1.0% | 853.2 ± 0.8% | 696.8 ± 2.4% | 316.3 ± 5.9% | 390.7 ± 1.0% | 231.1 ± 36.6% | 1.358 | 1.663 | 3.663 | 2.966 | 5.014 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1363.9 ± 0.7% | 1133.0 ± 1.1% | 890.9 ± 5.3% | 332.3 ± 0.6% | 366.5 ± 0.8% | 314.3 ± 4.5% | 1.204 | 1.531 | 4.104 | 3.722 | 4.339 |
| qlog records, JSON text sequence | 1467503 | 1158.9 ± 2.6% | 853.2 ± 0.8% | 696.8 ± 2.4% | 316.3 ± 5.9% | 390.7 ± 1.0% | 231.1 ± 36.6% | 1.358 | 1.663 | 3.664 | 2.966 | 5.014 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 771.8 ± 1.0% | 1009.2 ± 0.4% | 982.4 ± 0.7% | 260.2 ± 0.3% | 531.2 ± 0.4% | 259.4 ± 2.9% | 0.765 | 0.786 | 2.967 | 1.453 | 2.976 |
| qlog records, JSON text sequence | 1467503 | 560.1 ± 6.2% | 809.9 ± 0.4% | 813.6 ± 3.9% | 223.5 ± 2.5% | 587.0 ± 4.9% | 245.6 ± 4.5% | 0.692 | 0.688 | 2.506 | 0.954 | 2.280 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 965.0 ± 1.2% | 1133.0 ± 1.1% | 890.9 ± 5.3% | 332.3 ± 0.6% | 366.5 ± 0.8% | 314.3 ± 4.5% | 0.852 | 1.083 | 2.904 | 2.633 | 3.070 |
| qlog records, JSON text sequence | 1467503 | 800.6 ± 0.8% | 853.2 ± 0.8% | 696.8 ± 2.4% | 316.3 ± 5.9% | 390.7 ± 1.0% | 231.1 ± 36.6% | 0.938 | 1.149 | 2.531 | 2.049 | 3.464 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.765 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.786 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.692 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.688 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.852 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.938 of simdjson.

# bench-json, CLDR and qlog alone: head, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1042.4 ± 3.3% | 0.462 | 1.021 | 1.055 | 1.051 | 0.411 | 1.043 | 1.042 | 0.355 | 0.780 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 839.1 ± 0.8% | 0.736 | 1.022 | 1.006 | 1.003 | 0.389 | 1.008 | 1.003 | 0.349 | 0.890 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1330.4 ± 4.0% | 0.439 | 0.976 | 0.966 | 1.002 | 1.016 | 0.229 | 1.011 | 0.444 | 0.720 | 0.086 | 1.013 |
| qlog records, JSON text sequence | 1467503 | 1160.0 ± 5.9% | 0.690 | 0.944 | 0.985 | 0.986 | 0.989 | 0.221 | 0.981 | 0.411 | 0.694 | 0.104 | 1.003 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.055 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 1042.4 ± 3.3% | 954.1 ± 4.6% | 982.6 ± 0.5% | 241.5 ± 0.4% | 531.5 ± 0.2% | 256.5 ± 2.1% | 1.093 | 1.061 | 4.315 | 1.961 | 4.063 |
| qlog records, JSON text sequence | 1467503 | 839.1 ± 0.8% | 783.5 ± 0.4% | 816.3 ± 4.1% | 204.0 ± 3.3% | 587.4 ± 0.6% | 239.2 ± 4.3% | 1.071 | 1.028 | 4.113 | 1.429 | 3.507 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1330.4 ± 4.0% | 1129.9 ± 1.1% | 895.6 ± 0.8% | 331.4 ± 1.7% | 361.2 ± 4.1% | 312.4 ± 1.7% | 1.178 | 1.485 | 4.015 | 3.683 | 4.259 |
| qlog records, JSON text sequence | 1467503 | 1160.0 ± 5.9% | 867.8 ± 0.2% | 723.9 ± 0.4% | 322.8 ± 0.3% | 396.0 ± 0.9% | 234.3 ± 1.0% | 1.337 | 1.603 | 3.594 | 2.930 | 4.952 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1347.3 ± 2.6% | 1129.9 ± 1.1% | 895.6 ± 0.8% | 331.4 ± 1.7% | 361.2 ± 4.1% | 312.4 ± 1.7% | 1.192 | 1.504 | 4.066 | 3.730 | 4.314 |
| qlog records, JSON text sequence | 1467503 | 1164.0 ± 7.2% | 867.8 ± 0.2% | 723.9 ± 0.4% | 322.8 ± 0.3% | 396.0 ± 0.9% | 234.3 ± 1.0% | 1.341 | 1.608 | 3.606 | 2.940 | 4.969 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 812.8 ± 3.9% | 954.1 ± 4.6% | 982.6 ± 0.5% | 241.5 ± 0.4% | 531.5 ± 0.2% | 256.5 ± 2.1% | 0.852 | 0.827 | 3.365 | 1.529 | 3.168 |
| qlog records, JSON text sequence | 1467503 | 746.8 ± 6.1% | 783.5 ± 0.4% | 816.3 ± 4.1% | 204.0 ± 3.3% | 587.4 ± 0.6% | 239.2 ± 4.3% | 0.953 | 0.915 | 3.661 | 1.271 | 3.122 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 957.9 ± 5.2% | 1129.9 ± 1.1% | 895.6 ± 0.8% | 331.4 ± 1.7% | 361.2 ± 4.1% | 312.4 ± 1.7% | 0.848 | 1.070 | 2.891 | 2.652 | 3.067 |
| qlog records, JSON text sequence | 1467503 | 805.0 ± 0.8% | 867.8 ± 0.2% | 723.9 ± 0.4% | 322.8 ± 0.3% | 396.0 ± 0.9% | 234.3 ± 1.0% | 0.928 | 1.112 | 2.494 | 2.033 | 3.436 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.852 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.827 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.915 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.848 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.928 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1019.5 ± 3.7% | 0.485 | 1.020 | 1.049 | 1.056 | 0.414 | 1.019 | 1.039 | 0.363 | 0.797 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 852.3 ± 5.1% | 0.735 | 1.032 | 1.011 | 1.000 | 0.390 | 1.009 | 0.998 | 0.344 | 0.684 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.5 ± 0.9% | 0.442 | 0.981 | 0.981 | 0.999 | 1.001 | 0.236 | 0.999 | 0.445 | 0.723 | 0.086 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1160.2 ± 0.7% | 0.701 | 0.920 | 0.988 | 0.982 | 0.986 | 0.228 | 0.985 | 0.410 | 0.691 | 0.104 | 1.011 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.056 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1019.5 ± 3.7% | 1011.6 ± 0.2% | 985.8 ± 1.4% | 258.6 ± 4.9% | 531.7 ± 0.3% | 260.2 ± 3.3% | 1.008 | 1.034 | 3.942 | 1.918 | 3.918 |
| qlog records, JSON text sequence | 1467503 | 852.3 ± 5.1% | 812.3 ± 0.7% | 817.6 ± 1.6% | 223.2 ± 3.7% | 588.8 ± 0.2% | 245.1 ± 1.7% | 1.049 | 1.042 | 3.819 | 1.448 | 3.478 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.5 ± 0.9% | 1133.8 ± 6.8% | 895.1 ± 2.7% | 319.5 ± 9.4% | 356.8 ± 1.4% | 313.8 ± 4.4% | 1.175 | 1.489 | 4.170 | 3.734 | 4.246 |
| qlog records, JSON text sequence | 1467503 | 1160.2 ± 0.7% | 867.7 ± 0.5% | 723.9 ± 0.5% | 319.0 ± 0.6% | 392.1 ± 0.8% | 234.2 ± 0.9% | 1.337 | 1.603 | 3.637 | 2.959 | 4.953 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1354.8 ± 1.2% | 1133.8 ± 6.8% | 895.1 ± 2.7% | 319.5 ± 9.4% | 356.8 ± 1.4% | 313.8 ± 4.4% | 1.195 | 1.514 | 4.240 | 3.797 | 4.317 |
| qlog records, JSON text sequence | 1467503 | 1172.9 ± 0.5% | 867.7 ± 0.5% | 723.9 ± 0.5% | 319.0 ± 0.6% | 392.1 ± 0.8% | 234.2 ± 0.9% | 1.352 | 1.620 | 3.677 | 2.991 | 5.007 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 812.3 ± 1.4% | 1011.6 ± 0.2% | 985.8 ± 1.4% | 258.6 ± 4.9% | 531.7 ± 0.3% | 260.2 ± 3.3% | 0.803 | 0.824 | 3.141 | 1.528 | 3.122 |
| qlog records, JSON text sequence | 1467503 | 582.8 ± 0.5% | 812.3 ± 0.7% | 817.6 ± 1.6% | 223.2 ± 3.7% | 588.8 ± 0.2% | 245.1 ± 1.7% | 0.717 | 0.713 | 2.611 | 0.990 | 2.378 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 964.0 ± 14.1% | 1133.8 ± 6.8% | 895.1 ± 2.7% | 319.5 ± 9.4% | 356.8 ± 1.4% | 313.8 ± 4.4% | 0.850 | 1.077 | 3.017 | 2.701 | 3.072 |
| qlog records, JSON text sequence | 1467503 | 801.8 ± 0.5% | 867.7 ± 0.5% | 723.9 ± 0.5% | 319.0 ± 0.6% | 392.1 ± 0.8% | 234.2 ± 0.9% | 0.924 | 1.108 | 2.513 | 2.045 | 3.423 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.803 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.824 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.717 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.713 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.850 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.924 of simdjson.

# bench-json, CLDR and qlog alone: null, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1043.9 ± 5.7% | 0.460 | 1.018 | 1.051 | 1.051 | 0.412 | 1.042 | 1.053 | 0.355 | 0.743 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 824.7 ± 4.2% | 0.749 | 1.042 | 1.013 | 1.008 | 0.397 | 1.029 | 1.007 | 0.351 | 0.680 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.9 ± 1.1% | 0.404 | 0.974 | 0.960 | 1.010 | 0.996 | 0.229 | 0.995 | 0.442 | 0.719 | 0.086 | 1.011 |
| qlog records, JSON text sequence | 1467503 | 1159.0 ± 0.9% | 0.689 | 0.945 | 0.984 | 0.986 | 0.989 | 0.222 | 0.989 | 0.413 | 0.695 | 0.104 | 1.013 |

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
| CLDR supplemental, 34 texts | 920675 | 1043.9 ± 5.7% | 994.8 ± 0.8% | 976.8 ± 0.7% | 260.2 ± 3.5% | 531.6 ± 0.2% | 258.4 ± 9.4% | 1.049 | 1.069 | 4.012 | 1.964 | 4.039 |
| qlog records, JSON text sequence | 1467503 | 824.7 ± 4.2% | 796.9 ± 0.5% | 802.1 ± 6.4% | 222.8 ± 3.8% | 586.1 ± 1.2% | 242.8 ± 6.5% | 1.035 | 1.028 | 3.701 | 1.407 | 3.396 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.9 ± 1.1% | 1126.9 ± 6.5% | 892.0 ± 1.4% | 332.7 ± 0.6% | 363.3 ± 4.1% | 314.5 ± 0.5% | 1.186 | 1.499 | 4.018 | 3.680 | 4.250 |
| qlog records, JSON text sequence | 1467503 | 1159.0 ± 0.9% | 872.5 ± 0.7% | 727.4 ± 0.5% | 323.5 ± 0.4% | 392.0 ± 0.4% | 232.3 ± 0.8% | 1.328 | 1.593 | 3.582 | 2.957 | 4.990 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1352.1 ± 1.9% | 1126.9 ± 6.5% | 892.0 ± 1.4% | 332.7 ± 0.6% | 363.3 ± 4.1% | 314.5 ± 0.5% | 1.200 | 1.516 | 4.063 | 3.722 | 4.299 |
| qlog records, JSON text sequence | 1467503 | 1173.8 ± 5.4% | 872.5 ± 0.7% | 727.4 ± 0.5% | 323.5 ± 0.4% | 392.0 ± 0.4% | 232.3 ± 0.8% | 1.345 | 1.614 | 3.628 | 2.994 | 5.054 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 775.5 ± 0.1% | 994.8 ± 0.8% | 976.8 ± 0.7% | 260.2 ± 3.5% | 531.6 ± 0.2% | 258.4 ± 9.4% | 0.780 | 0.794 | 2.981 | 1.459 | 3.000 |
| qlog records, JSON text sequence | 1467503 | 560.5 ± 0.6% | 796.9 ± 0.5% | 802.1 ± 6.4% | 222.8 ± 3.8% | 586.1 ± 1.2% | 242.8 ± 6.5% | 0.703 | 0.699 | 2.515 | 0.956 | 2.308 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.6 ± 1.2% | 1126.9 ± 6.5% | 892.0 ± 1.4% | 332.7 ± 0.6% | 363.3 ± 4.1% | 314.5 ± 0.5% | 0.853 | 1.078 | 2.890 | 2.647 | 3.057 |
| qlog records, JSON text sequence | 1467503 | 805.9 ± 0.6% | 872.5 ± 0.7% | 727.4 ± 0.5% | 323.5 ± 0.4% | 392.0 ± 0.4% | 232.3 ± 0.8% | 0.924 | 1.108 | 2.491 | 2.056 | 3.470 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.780 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.794 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.703 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.699 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.853 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.924 of simdjson.

# bench-json, CLDR and qlog alone: head, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1041.8 ± 3.5% | 0.460 | 1.019 | 1.042 | 1.050 | 0.414 | 1.037 | 1.047 | 0.355 | 0.773 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 842.4 ± 0.4% | 0.733 | 1.026 | 1.007 | 1.004 | 0.390 | 1.009 | 1.004 | 0.348 | 0.888 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1328.0 ± 0.7% | 0.441 | 0.982 | 0.974 | 1.004 | 1.014 | 0.230 | 1.017 | 0.441 | 0.726 | 0.086 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1161.5 ± 1.4% | 0.690 | 0.946 | 0.984 | 0.983 | 0.987 | 0.221 | 0.986 | 0.406 | 0.695 | 0.104 | 1.011 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.050 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1041.8 ± 3.5% | 1024.7 ± 0.7% | 987.6 ± 0.4% | 259.4 ± 1.8% | 530.9 ± 0.6% | 254.5 ± 7.6% | 1.017 | 1.055 | 4.015 | 1.963 | 4.093 |
| qlog records, JSON text sequence | 1467503 | 842.4 ± 0.4% | 809.8 ± 0.2% | 823.5 ± 0.7% | 223.6 ± 0.4% | 587.5 ± 1.2% | 244.8 ± 1.9% | 1.040 | 1.023 | 3.767 | 1.434 | 3.441 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1328.0 ± 0.7% | 1133.0 ± 0.9% | 898.6 ± 0.6% | 332.5 ± 0.9% | 359.4 ± 4.0% | 313.7 ± 0.8% | 1.172 | 1.478 | 3.994 | 3.695 | 4.233 |
| qlog records, JSON text sequence | 1467503 | 1161.5 ± 1.4% | 871.4 ± 1.2% | 727.5 ± 0.1% | 323.8 ± 3.3% | 392.1 ± 0.6% | 233.7 ± 0.9% | 1.333 | 1.597 | 3.587 | 2.962 | 4.969 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1350.2 ± 1.7% | 1133.0 ± 0.9% | 898.6 ± 0.6% | 332.5 ± 0.9% | 359.4 ± 4.0% | 313.7 ± 0.8% | 1.192 | 1.503 | 4.061 | 3.756 | 4.304 |
| qlog records, JSON text sequence | 1467503 | 1174.3 ± 0.4% | 871.4 ± 1.2% | 727.5 ± 0.1% | 323.8 ± 3.3% | 392.1 ± 0.6% | 233.7 ± 0.9% | 1.348 | 1.614 | 3.627 | 2.995 | 5.024 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 804.8 ± 2.5% | 1024.7 ± 0.7% | 987.6 ± 0.4% | 259.4 ± 1.8% | 530.9 ± 0.6% | 254.5 ± 7.6% | 0.785 | 0.815 | 3.102 | 1.516 | 3.162 |
| qlog records, JSON text sequence | 1467503 | 747.9 ± 5.2% | 809.8 ± 0.2% | 823.5 ± 0.7% | 223.6 ± 0.4% | 587.5 ± 1.2% | 244.8 ± 1.9% | 0.924 | 0.908 | 3.344 | 1.273 | 3.055 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 964.4 ± 0.8% | 1133.0 ± 0.9% | 898.6 ± 0.6% | 332.5 ± 0.9% | 359.4 ± 4.0% | 313.7 ± 0.8% | 0.851 | 1.073 | 2.900 | 2.683 | 3.074 |
| qlog records, JSON text sequence | 1467503 | 806.7 ± 6.2% | 871.4 ± 1.2% | 727.5 ± 0.1% | 323.8 ± 3.3% | 392.1 ± 0.6% | 233.7 ± 0.9% | 0.926 | 1.109 | 2.491 | 2.058 | 3.451 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.785 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.815 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.924 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.908 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.851 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.
