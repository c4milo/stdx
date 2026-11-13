# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1041.2 ± 3.6% | 0.474 | 0.978 | 1.014 | 1.010 | 0.406 | 1.039 | 1.011 | 0.355 | 0.779 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 851.1 ± 1.6% | 0.716 | 1.035 | 1.018 | 1.000 | 0.381 | 1.015 | 1.002 | 0.338 | 0.681 | 0.107 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1328.9 ± 5.2% | 0.445 | 0.986 | 0.988 | 1.008 | 1.004 | 0.235 | 1.003 | 0.447 | 0.724 | 0.086 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1158.9 ± 3.0% | 0.702 | 0.924 | 0.988 | 0.986 | 0.990 | 0.226 | 0.986 | 0.414 | 0.692 | 0.104 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1041.2 ± 3.6% | 1023.3 ± 1.1% | 978.3 ± 13.0% | 260.2 ± 4.7% | 529.4 ± 0.8% | 258.5 ± 2.9% | 1.018 | 1.064 | 4.002 | 1.967 | 4.028 |
| qlog records, JSON text sequence | 1467503 | 851.1 ± 1.6% | 813.0 ± 0.2% | 789.1 ± 1.4% | 222.9 ± 4.5% | 587.1 ± 2.5% | 243.1 ± 3.6% | 1.047 | 1.079 | 3.819 | 1.450 | 3.501 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1328.9 ± 5.2% | 1139.1 ± 0.6% | 899.1 ± 0.9% | 320.9 ± 0.5% | 359.5 ± 2.3% | 312.3 ± 2.2% | 1.167 | 1.478 | 4.141 | 3.697 | 4.256 |
| qlog records, JSON text sequence | 1467503 | 1158.9 ± 3.0% | 868.0 ± 0.8% | 724.5 ± 0.4% | 312.3 ± 10.3% | 386.8 ± 1.6% | 229.0 ± 1.9% | 1.335 | 1.600 | 3.711 | 2.996 | 5.061 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1357.8 ± 0.9% | 1139.1 ± 0.6% | 899.1 ± 0.9% | 320.9 ± 0.5% | 359.5 ± 2.3% | 312.3 ± 2.2% | 1.192 | 1.510 | 4.231 | 3.777 | 4.348 |
| qlog records, JSON text sequence | 1467503 | 1170.8 ± 1.2% | 868.0 ± 0.8% | 724.5 ± 0.4% | 312.3 ± 10.3% | 386.8 ± 1.6% | 229.0 ± 1.9% | 1.349 | 1.616 | 3.749 | 3.027 | 5.113 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 811.4 ± 1.4% | 1023.3 ± 1.1% | 978.3 ± 13.0% | 260.2 ± 4.7% | 529.4 ± 0.8% | 258.5 ± 2.9% | 0.793 | 0.829 | 3.119 | 1.533 | 3.139 |
| qlog records, JSON text sequence | 1467503 | 579.4 ± 1.3% | 813.0 ± 0.2% | 789.1 ± 1.4% | 222.9 ± 4.5% | 587.1 ± 2.5% | 243.1 ± 3.6% | 0.713 | 0.734 | 2.600 | 0.987 | 2.383 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 962.2 ± 6.2% | 1139.1 ± 0.6% | 899.1 ± 0.9% | 320.9 ± 0.5% | 359.5 ± 2.3% | 312.3 ± 2.2% | 0.845 | 1.070 | 2.998 | 2.676 | 3.081 |
| qlog records, JSON text sequence | 1467503 | 801.9 ± 0.7% | 868.0 ± 0.8% | 724.5 ± 0.4% | 312.3 ± 10.3% | 386.8 ± 1.6% | 229.0 ± 1.9% | 0.924 | 1.107 | 2.568 | 2.073 | 3.502 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.793 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.829 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.713 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.734 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.845 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.924 of simdjson.

# bench-json, CLDR and qlog alone: null, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 995.8 ± 5.0% | 0.481 | 1.046 | 1.103 | 1.099 | 0.431 | 1.067 | 1.097 | 0.372 | 0.769 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 832.4 ± 0.6% | 0.745 | 1.031 | 1.019 | 1.000 | 0.396 | 1.024 | 0.998 | 0.349 | 0.670 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.4 ± 3.3% | 0.403 | 0.968 | 0.959 | 1.005 | 0.995 | 0.228 | 0.998 | 0.441 | 0.718 | 0.085 | 1.011 |
| qlog records, JSON text sequence | 1467503 | 1154.3 ± 0.8% | 0.693 | 0.945 | 0.988 | 0.997 | 0.993 | 0.223 | 0.992 | 0.415 | 0.695 | 0.105 | 1.011 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.103 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.099 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.067 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 995.8 ± 5.0% | 1007.6 ± 0.8% | 975.7 ± 0.5% | 260.2 ± 1.2% | 531.5 ± 0.4% | 257.4 ± 7.1% | 0.988 | 1.021 | 3.826 | 1.873 | 3.868 |
| qlog records, JSON text sequence | 1467503 | 832.4 ± 0.6% | 810.3 ± 1.3% | 817.0 ± 0.5% | 222.6 ± 1.4% | 588.4 ± 0.7% | 246.1 ± 1.8% | 1.027 | 1.019 | 3.740 | 1.415 | 3.382 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.4 ± 3.3% | 1138.9 ± 0.7% | 895.1 ± 0.9% | 332.9 ± 0.3% | 365.2 ± 2.0% | 311.3 ± 1.6% | 1.174 | 1.494 | 4.017 | 3.662 | 4.296 |
| qlog records, JSON text sequence | 1467503 | 1154.3 ± 0.8% | 871.9 ± 1.9% | 721.0 ± 2.1% | 321.3 ± 0.7% | 391.8 ± 1.1% | 230.5 ± 3.0% | 1.324 | 1.601 | 3.592 | 2.946 | 5.007 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1352.6 ± 1.2% | 1138.9 ± 0.7% | 895.1 ± 0.9% | 332.9 ± 0.3% | 365.2 ± 2.0% | 311.3 ± 1.6% | 1.188 | 1.511 | 4.063 | 3.703 | 4.345 |
| qlog records, JSON text sequence | 1467503 | 1166.7 ± 5.8% | 871.9 ± 1.9% | 721.0 ± 2.1% | 321.3 ± 0.7% | 391.8 ± 1.1% | 230.5 ± 3.0% | 1.338 | 1.618 | 3.631 | 2.978 | 5.061 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 765.7 ± 0.6% | 1007.6 ± 0.8% | 975.7 ± 0.5% | 260.2 ± 1.2% | 531.5 ± 0.4% | 257.4 ± 7.1% | 0.760 | 0.785 | 2.942 | 1.441 | 2.974 |
| qlog records, JSON text sequence | 1467503 | 557.7 ± 5.0% | 810.3 ± 1.3% | 817.0 ± 0.5% | 222.6 ± 1.4% | 588.4 ± 0.7% | 246.1 ± 1.8% | 0.688 | 0.683 | 2.506 | 0.948 | 2.266 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 960.2 ± 2.1% | 1138.9 ± 0.7% | 895.1 ± 0.9% | 332.9 ± 0.3% | 365.2 ± 2.0% | 311.3 ± 1.6% | 0.843 | 1.073 | 2.884 | 2.629 | 3.084 |
| qlog records, JSON text sequence | 1467503 | 802.1 ± 7.8% | 871.9 ± 1.9% | 721.0 ± 2.1% | 321.3 ± 0.7% | 391.8 ± 1.1% | 230.5 ± 3.0% | 0.920 | 1.113 | 2.496 | 2.047 | 3.479 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.760 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.785 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.688 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.683 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.948 of serde_json.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.843 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.920 of simdjson.

# bench-json, CLDR and qlog alone: head, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1004.2 ± 13.6% | 0.478 | 1.016 | 1.093 | 1.087 | 0.427 | 1.072 | 1.088 | 0.368 | 0.801 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 844.2 ± 0.3% | 0.732 | 1.023 | 1.005 | 0.997 | 0.387 | 1.010 | 1.002 | 0.343 | 0.888 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.4 ± 2.4% | 0.438 | 0.979 | 0.971 | 0.996 | 1.005 | 0.229 | 1.007 | 0.442 | 0.721 | 0.086 | 1.011 |
| qlog records, JSON text sequence | 1467503 | 1156.1 ± 0.5% | 0.691 | 0.946 | 0.986 | 0.990 | 0.989 | 0.223 | 0.993 | 0.414 | 0.697 | 0.105 | 1.019 |

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
| CLDR supplemental, 34 texts | 920675 | 1004.2 ± 13.6% | 1001.6 ± 0.5% | 972.1 ± 1.2% | 259.3 ± 3.8% | 530.2 ± 3.8% | 257.1 ± 2.1% | 1.003 | 1.033 | 3.872 | 1.894 | 3.906 |
| qlog records, JSON text sequence | 1467503 | 844.2 ± 0.3% | 799.8 ± 4.8% | 805.3 ± 0.8% | 221.3 ± 3.5% | 589.7 ± 0.3% | 245.9 ± 1.2% | 1.055 | 1.048 | 3.815 | 1.431 | 3.433 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.4 ± 2.4% | 1134.8 ± 7.4% | 899.7 ± 1.3% | 332.4 ± 4.9% | 363.2 ± 2.3% | 311.3 ± 2.2% | 1.175 | 1.482 | 4.012 | 3.671 | 4.284 |
| qlog records, JSON text sequence | 1467503 | 1156.1 ± 0.5% | 844.4 ± 0.8% | 722.0 ± 0.8% | 320.4 ± 4.5% | 389.7 ± 7.1% | 232.9 ± 1.4% | 1.369 | 1.601 | 3.608 | 2.967 | 4.964 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1348.7 ± 1.3% | 1134.8 ± 7.4% | 899.7 ± 1.3% | 332.4 ± 4.9% | 363.2 ± 2.3% | 311.3 ± 2.2% | 1.189 | 1.499 | 4.058 | 3.713 | 4.333 |
| qlog records, JSON text sequence | 1467503 | 1177.7 ± 0.5% | 844.4 ± 0.8% | 722.0 ± 0.8% | 320.4 ± 4.5% | 389.7 ± 7.1% | 232.9 ± 1.4% | 1.395 | 1.631 | 3.676 | 3.022 | 5.057 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 803.9 ± 2.9% | 1001.6 ± 0.5% | 972.1 ± 1.2% | 259.3 ± 3.8% | 530.2 ± 3.8% | 257.1 ± 2.1% | 0.803 | 0.827 | 3.100 | 1.516 | 3.127 |
| qlog records, JSON text sequence | 1467503 | 749.9 ± 2.3% | 799.8 ± 4.8% | 805.3 ± 0.8% | 221.3 ± 3.5% | 589.7 ± 0.3% | 245.9 ± 1.2% | 0.938 | 0.931 | 3.389 | 1.272 | 3.050 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.9 ± 3.7% | 1134.8 ± 7.4% | 899.7 ± 1.3% | 332.4 ± 4.9% | 363.2 ± 2.3% | 311.3 ± 2.2% | 0.848 | 1.069 | 2.894 | 2.648 | 3.090 |
| qlog records, JSON text sequence | 1467503 | 806.4 ± 0.4% | 844.4 ± 0.8% | 722.0 ± 0.8% | 320.4 ± 4.5% | 389.7 ± 7.1% | 232.9 ± 1.4% | 0.955 | 1.117 | 2.517 | 2.070 | 3.462 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.803 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.827 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.938 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.931 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.848 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1045.6 ± 4.2% | 0.473 | 0.975 | 1.010 | 1.006 | 0.402 | 1.023 | 1.012 | 0.354 | 0.780 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 851.6 ± 0.8% | 0.735 | 1.034 | 1.017 | 0.999 | 0.390 | 1.006 | 0.999 | 0.336 | 0.680 | 0.107 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1319.6 ± 1.1% | 0.445 | 0.985 | 0.991 | 1.017 | 1.008 | 0.238 | 1.010 | 0.451 | 0.730 | 0.087 | 1.032 |
| qlog records, JSON text sequence | 1467503 | 1158.8 ± 0.9% | 0.703 | 0.921 | 0.986 | 0.983 | 0.983 | 0.229 | 0.983 | 0.414 | 0.691 | 0.104 | 1.008 |

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
| CLDR supplemental, 34 texts | 920675 | 1045.6 ± 4.2% | 996.7 ± 0.3% | 969.7 ± 0.7% | 260.6 ± 0.4% | 531.6 ± 1.6% | 258.4 ± 3.3% | 1.049 | 1.078 | 4.012 | 1.967 | 4.047 |
| qlog records, JSON text sequence | 1467503 | 851.6 ± 0.8% | 800.9 ± 0.6% | 788.4 ± 5.4% | 216.1 ± 4.8% | 587.9 ± 1.0% | 243.0 ± 2.2% | 1.063 | 1.080 | 3.940 | 1.449 | 3.505 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1319.6 ± 1.1% | 1131.5 ± 0.6% | 894.2 ± 5.5% | 319.0 ± 0.3% | 357.4 ± 5.7% | 311.0 ± 1.8% | 1.166 | 1.476 | 4.137 | 3.693 | 4.243 |
| qlog records, JSON text sequence | 1467503 | 1158.8 ± 0.9% | 865.9 ± 8.2% | 718.0 ± 10.7% | 307.5 ± 2.8% | 380.4 ± 6.2% | 225.5 ± 2.9% | 1.338 | 1.614 | 3.768 | 3.046 | 5.139 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1361.8 ± 3.9% | 1131.5 ± 0.6% | 894.2 ± 5.5% | 319.0 ± 0.3% | 357.4 ± 5.7% | 311.0 ± 1.8% | 1.204 | 1.523 | 4.269 | 3.811 | 4.379 |
| qlog records, JSON text sequence | 1467503 | 1168.5 ± 0.7% | 865.9 ± 8.2% | 718.0 ± 10.7% | 307.5 ± 2.8% | 380.4 ± 6.2% | 225.5 ± 2.9% | 1.349 | 1.628 | 3.800 | 3.072 | 5.182 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 815.3 ± 1.5% | 996.7 ± 0.3% | 969.7 ± 0.7% | 260.6 ± 0.4% | 531.6 ± 1.6% | 258.4 ± 3.3% | 0.818 | 0.841 | 3.128 | 1.534 | 3.156 |
| qlog records, JSON text sequence | 1467503 | 579.0 ± 1.7% | 800.9 ± 0.6% | 788.4 ± 5.4% | 216.1 ± 4.8% | 587.9 ± 1.0% | 243.0 ± 2.2% | 0.723 | 0.734 | 2.679 | 0.985 | 2.383 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 963.7 ± 1.4% | 1131.5 ± 0.6% | 894.2 ± 5.5% | 319.0 ± 0.3% | 357.4 ± 5.7% | 311.0 ± 1.8% | 0.852 | 1.078 | 3.021 | 2.697 | 3.099 |
| qlog records, JSON text sequence | 1467503 | 800.9 ± 0.4% | 865.9 ± 8.2% | 718.0 ± 10.7% | 307.5 ± 2.8% | 380.4 ± 6.2% | 225.5 ± 2.9% | 0.925 | 1.115 | 2.604 | 2.105 | 3.552 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.818 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.841 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.723 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.734 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.852 of simdjson.

# bench-json, CLDR and qlog alone: null, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1037.8 ± 5.1% | 0.463 | 1.000 | 1.063 | 1.060 | 0.414 | 1.009 | 1.052 | 0.357 | 0.746 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 833.2 ± 1.2% | 0.742 | 1.033 | 1.019 | 0.999 | 0.393 | 1.019 | 1.001 | 0.350 | 0.671 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1341.8 ± 0.6% | 0.409 | 0.965 | 0.953 | 1.007 | 0.992 | 0.228 | 0.993 | 0.440 | 0.717 | 0.085 | 1.002 |
| qlog records, JSON text sequence | 1467503 | 1156.4 ± 1.2% | 0.693 | 0.946 | 0.986 | 0.996 | 0.990 | 0.222 | 0.990 | 0.416 | 0.695 | 0.104 | 1.015 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.063 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.060 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.052 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1037.8 ± 5.1% | 1016.8 ± 0.4% | 983.5 ± 0.6% | 260.3 ± 3.8% | 531.1 ± 0.7% | 259.0 ± 1.7% | 1.021 | 1.055 | 3.987 | 1.954 | 4.006 |
| qlog records, JSON text sequence | 1467503 | 833.2 ± 1.2% | 812.6 ± 3.1% | 813.6 ± 0.4% | 223.0 ± 1.5% | 587.8 ± 0.5% | 237.0 ± 1.9% | 1.025 | 1.024 | 3.736 | 1.418 | 3.516 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1341.8 ± 0.6% | 1135.6 ± 0.3% | 895.8 ± 0.4% | 333.2 ± 1.3% | 365.2 ± 1.7% | 312.9 ± 1.8% | 1.182 | 1.498 | 4.028 | 3.674 | 4.288 |
| qlog records, JSON text sequence | 1467503 | 1156.4 ± 1.2% | 868.8 ± 6.8% | 727.0 ± 4.7% | 321.2 ± 1.3% | 392.7 ± 1.5% | 231.3 ± 1.3% | 1.331 | 1.591 | 3.600 | 2.944 | 5.000 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1344.9 ± 2.7% | 1135.6 ± 0.3% | 895.8 ± 0.4% | 333.2 ± 1.3% | 365.2 ± 1.7% | 312.9 ± 1.8% | 1.184 | 1.501 | 4.037 | 3.682 | 4.298 |
| qlog records, JSON text sequence | 1467503 | 1174.3 ± 0.8% | 868.8 ± 6.8% | 727.0 ± 4.7% | 321.2 ± 1.3% | 392.7 ± 1.5% | 231.3 ± 1.3% | 1.352 | 1.615 | 3.656 | 2.990 | 5.077 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 773.8 ± 0.7% | 1016.8 ± 0.4% | 983.5 ± 0.6% | 260.3 ± 3.8% | 531.1 ± 0.7% | 259.0 ± 1.7% | 0.761 | 0.787 | 2.973 | 1.457 | 2.987 |
| qlog records, JSON text sequence | 1467503 | 559.5 ± 1.3% | 812.6 ± 3.1% | 813.6 ± 0.4% | 223.0 ± 1.5% | 587.8 ± 0.5% | 237.0 ± 1.9% | 0.688 | 0.688 | 2.509 | 0.952 | 2.361 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 962.7 ± 1.2% | 1135.6 ± 0.3% | 895.8 ± 0.4% | 333.2 ± 1.3% | 365.2 ± 1.7% | 312.9 ± 1.8% | 0.848 | 1.075 | 2.890 | 2.636 | 3.077 |
| qlog records, JSON text sequence | 1467503 | 803.9 ± 0.4% | 868.8 ± 6.8% | 727.0 ± 4.7% | 321.2 ± 1.3% | 392.7 ± 1.5% | 231.3 ± 1.3% | 0.925 | 1.106 | 2.503 | 2.047 | 3.475 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.761 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.787 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.688 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.688 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.848 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.925 of simdjson.

# bench-json, CLDR and qlog alone: head, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1041.1 ± 3.7% | 0.461 | 1.014 | 1.053 | 1.052 | 0.414 | 1.036 | 1.050 | 0.355 | 0.771 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 842.5 ± 0.8% | 0.734 | 1.025 | 1.009 | 1.004 | 0.385 | 1.012 | 1.005 | 0.345 | 0.887 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1330.3 ± 4.0% | 0.440 | 0.982 | 0.971 | 0.999 | 1.010 | 0.229 | 1.015 | 0.443 | 0.723 | 0.086 | 1.021 |
| qlog records, JSON text sequence | 1467503 | 1151.7 ± 0.7% | 0.692 | 0.952 | 0.989 | 0.995 | 0.997 | 0.223 | 0.997 | 0.414 | 0.700 | 0.105 | 1.025 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.053 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.052 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1041.1 ± 3.7% | 1013.0 ± 0.3% | 986.7 ± 0.6% | 260.2 ± 0.3% | 531.7 ± 0.4% | 256.3 ± 1.8% | 1.028 | 1.055 | 4.002 | 1.958 | 4.062 |
| qlog records, JSON text sequence | 1467503 | 842.5 ± 0.8% | 808.0 ± 0.3% | 814.4 ± 3.2% | 220.5 ± 2.1% | 590.0 ± 1.7% | 245.1 ± 4.7% | 1.043 | 1.034 | 3.822 | 1.428 | 3.437 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1330.3 ± 4.0% | 1137.3 ± 0.5% | 896.3 ± 0.9% | 333.4 ± 0.5% | 366.5 ± 2.3% | 310.5 ± 6.4% | 1.170 | 1.484 | 3.990 | 3.630 | 4.284 |
| qlog records, JSON text sequence | 1467503 | 1151.7 ± 0.7% | 872.2 ± 5.1% | 725.8 ± 1.1% | 319.3 ± 1.3% | 390.5 ± 1.6% | 231.5 ± 1.4% | 1.321 | 1.587 | 3.607 | 2.949 | 4.976 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1358.8 ± 1.6% | 1137.3 ± 0.5% | 896.3 ± 0.9% | 333.4 ± 0.5% | 366.5 ± 2.3% | 310.5 ± 6.4% | 1.195 | 1.516 | 4.076 | 3.707 | 4.376 |
| qlog records, JSON text sequence | 1467503 | 1180.2 ± 0.4% | 872.2 ± 5.1% | 725.8 ± 1.1% | 319.3 ± 1.3% | 390.5 ± 1.6% | 231.5 ± 1.4% | 1.353 | 1.626 | 3.696 | 3.022 | 5.099 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 803.2 ± 1.9% | 1013.0 ± 0.3% | 986.7 ± 0.6% | 260.2 ± 0.3% | 531.7 ± 0.4% | 256.3 ± 1.8% | 0.793 | 0.814 | 3.087 | 1.511 | 3.133 |
| qlog records, JSON text sequence | 1467503 | 747.3 ± 1.3% | 808.0 ± 0.3% | 814.4 ± 3.2% | 220.5 ± 2.1% | 590.0 ± 1.7% | 245.1 ± 4.7% | 0.925 | 0.918 | 3.390 | 1.267 | 3.048 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.8 ± 0.5% | 1137.3 ± 0.5% | 896.3 ± 0.9% | 333.4 ± 0.5% | 366.5 ± 2.3% | 310.5 ± 6.4% | 0.846 | 1.073 | 2.885 | 2.624 | 3.098 |
| qlog records, JSON text sequence | 1467503 | 806.1 ± 0.7% | 872.2 ± 5.1% | 725.8 ± 1.1% | 319.3 ± 1.3% | 390.5 ± 1.6% | 231.5 ± 1.4% | 0.924 | 1.111 | 2.524 | 2.064 | 3.482 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.793 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.814 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.925 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.918 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.846 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.924 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1045.1 ± 4.8% | 0.469 | 1.005 | 0.982 | 1.017 | 0.403 | 1.028 | 1.011 | 0.354 | 0.782 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 850.0 ± 0.9% | 0.740 | 1.039 | 1.019 | 1.002 | 0.391 | 1.014 | 1.003 | 0.341 | 0.682 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.4 ± 5.0% | 0.443 | 0.983 | 0.980 | 1.003 | 0.996 | 0.235 | 1.001 | 0.446 | 0.722 | 0.086 | 1.020 |
| qlog records, JSON text sequence | 1467503 | 1162.5 ± 0.5% | 0.700 | 0.920 | 0.983 | 0.983 | 0.983 | 0.227 | 0.985 | 0.412 | 0.690 | 0.104 | 1.003 |

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
| CLDR supplemental, 34 texts | 920675 | 1045.1 ± 4.8% | 1005.4 ± 0.3% | 971.5 ± 1.0% | 260.2 ± 1.0% | 532.0 ± 0.4% | 258.8 ± 2.1% | 1.039 | 1.076 | 4.016 | 1.964 | 4.037 |
| qlog records, JSON text sequence | 1467503 | 850.0 ± 0.9% | 800.8 ± 0.3% | 805.1 ± 5.6% | 222.7 ± 3.2% | 588.4 ± 0.8% | 245.2 ± 10.4% | 1.062 | 1.056 | 3.816 | 1.445 | 3.467 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.4 ± 5.0% | 1133.0 ± 3.5% | 893.2 ± 1.1% | 320.3 ± 0.5% | 357.1 ± 0.9% | 314.7 ± 1.0% | 1.178 | 1.494 | 4.166 | 3.737 | 4.240 |
| qlog records, JSON text sequence | 1467503 | 1162.5 ± 0.5% | 866.8 ± 0.6% | 722.4 ± 0.2% | 312.9 ± 1.9% | 384.4 ± 6.4% | 225.9 ± 12.2% | 1.341 | 1.609 | 3.716 | 3.024 | 5.147 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1361.7 ± 0.9% | 1133.0 ± 3.5% | 893.2 ± 1.1% | 320.3 ± 0.5% | 357.1 ± 0.9% | 314.7 ± 1.0% | 1.202 | 1.525 | 4.251 | 3.813 | 4.327 |
| qlog records, JSON text sequence | 1467503 | 1165.8 ± 1.6% | 866.8 ± 0.6% | 722.4 ± 0.2% | 312.9 ± 1.9% | 384.4 ± 6.4% | 225.9 ± 12.2% | 1.345 | 1.614 | 3.726 | 3.033 | 5.162 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 816.9 ± 2.8% | 1005.4 ± 0.3% | 971.5 ± 1.0% | 260.2 ± 1.0% | 532.0 ± 0.4% | 258.8 ± 2.1% | 0.813 | 0.841 | 3.139 | 1.535 | 3.156 |
| qlog records, JSON text sequence | 1467503 | 579.3 ± 1.0% | 800.8 ± 0.3% | 805.1 ± 5.6% | 222.7 ± 3.2% | 588.4 ± 0.8% | 245.2 ± 10.4% | 0.723 | 0.720 | 2.601 | 0.985 | 2.363 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 963.7 ± 0.5% | 1133.0 ± 3.5% | 893.2 ± 1.1% | 320.3 ± 0.5% | 357.1 ± 0.9% | 314.7 ± 1.0% | 0.851 | 1.079 | 3.009 | 2.699 | 3.062 |
| qlog records, JSON text sequence | 1467503 | 802.7 ± 0.3% | 866.8 ± 0.6% | 722.4 ± 0.2% | 312.9 ± 1.9% | 384.4 ± 6.4% | 225.9 ± 12.2% | 0.926 | 1.111 | 2.566 | 2.088 | 3.554 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.813 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.841 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.723 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.720 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.851 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.

# bench-json, CLDR and qlog alone: null, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1004.1 ± 6.8% | 0.479 | 1.055 | 1.088 | 1.089 | 0.430 | 1.029 | 1.083 | 0.369 | 0.772 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 834.7 ± 3.4% | 0.742 | 1.029 | 1.018 | 0.997 | 0.393 | 1.020 | 0.996 | 0.350 | 0.671 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.8 ± 0.7% | 0.404 | 0.971 | 0.963 | 1.009 | 0.996 | 0.228 | 0.996 | 0.442 | 0.721 | 0.085 | 1.021 |
| qlog records, JSON text sequence | 1467503 | 1159.3 ± 2.1% | 0.691 | 0.945 | 0.984 | 0.993 | 0.989 | 0.222 | 0.986 | 0.412 | 0.691 | 0.104 | 1.016 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.088 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.089 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 1004.1 ± 6.8% | 1019.4 ± 6.3% | 981.6 ± 0.6% | 260.5 ± 0.2% | 531.3 ± 0.4% | 261.1 ± 2.4% | 0.985 | 1.023 | 3.855 | 1.890 | 3.846 |
| qlog records, JSON text sequence | 1467503 | 834.7 ± 3.4% | 811.5 ± 4.9% | 814.4 ± 3.4% | 221.5 ± 8.8% | 588.3 ± 0.9% | 243.9 ± 1.4% | 1.029 | 1.025 | 3.769 | 1.419 | 3.422 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.8 ± 0.7% | 1139.5 ± 0.6% | 895.5 ± 3.5% | 332.8 ± 1.4% | 365.7 ± 1.3% | 312.6 ± 7.9% | 1.176 | 1.496 | 4.026 | 3.663 | 4.286 |
| qlog records, JSON text sequence | 1467503 | 1159.3 ± 2.1% | 870.6 ± 1.4% | 728.9 ± 1.4% | 321.1 ± 3.6% | 389.3 ± 2.9% | 229.9 ± 2.7% | 1.332 | 1.590 | 3.610 | 2.978 | 5.043 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1368.2 ± 0.8% | 1139.5 ± 0.6% | 895.5 ± 3.5% | 332.8 ± 1.4% | 365.7 ± 1.3% | 312.6 ± 7.9% | 1.201 | 1.528 | 4.111 | 3.741 | 4.376 |
| qlog records, JSON text sequence | 1467503 | 1178.1 ± 0.5% | 870.6 ± 1.4% | 728.9 ± 1.4% | 321.1 ± 3.6% | 389.3 ± 2.9% | 229.9 ± 2.7% | 1.353 | 1.616 | 3.669 | 3.026 | 5.125 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 775.3 ± 0.7% | 1019.4 ± 6.3% | 981.6 ± 0.6% | 260.5 ± 0.2% | 531.3 ± 0.4% | 261.1 ± 2.4% | 0.761 | 0.790 | 2.976 | 1.459 | 2.970 |
| qlog records, JSON text sequence | 1467503 | 560.5 ± 0.8% | 811.5 ± 4.9% | 814.4 ± 3.4% | 221.5 ± 8.8% | 588.3 ± 0.9% | 243.9 ± 1.4% | 0.691 | 0.688 | 2.531 | 0.953 | 2.298 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 966.1 ± 1.6% | 1139.5 ± 0.6% | 895.5 ± 3.5% | 332.8 ± 1.4% | 365.7 ± 1.3% | 312.6 ± 7.9% | 0.848 | 1.079 | 2.903 | 2.642 | 3.090 |
| qlog records, JSON text sequence | 1467503 | 801.4 ± 1.2% | 870.6 ± 1.4% | 728.9 ± 1.4% | 321.1 ± 3.6% | 389.3 ± 2.9% | 229.9 ± 2.7% | 0.921 | 1.099 | 2.496 | 2.058 | 3.486 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.761 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.790 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.691 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.688 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.848 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.921 of simdjson.

# bench-json, CLDR and qlog alone: head, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1037.6 ± 4.1% | 0.461 | 1.023 | 1.053 | 1.048 | 0.411 | 1.037 | 1.050 | 0.357 | 0.783 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 843.3 ± 1.1% | 0.733 | 1.022 | 1.005 | 1.003 | 0.388 | 1.009 | 1.001 | 0.342 | 0.886 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.4 ± 0.9% | 0.439 | 0.978 | 0.970 | 1.000 | 1.016 | 0.229 | 1.013 | 0.442 | 0.720 | 0.086 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1142.9 ± 1.2% | 0.695 | 0.950 | 0.994 | 0.996 | 0.997 | 0.223 | 0.997 | 0.414 | 0.696 | 0.106 | 1.023 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.053 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.050 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1037.6 ± 4.1% | 1002.1 ± 3.3% | 971.5 ± 2.8% | 258.3 ± 3.8% | 531.1 ± 0.2% | 256.3 ± 1.9% | 1.035 | 1.068 | 4.017 | 1.954 | 4.049 |
| qlog records, JSON text sequence | 1467503 | 843.3 ± 1.1% | 799.9 ± 0.3% | 790.3 ± 2.9% | 221.6 ± 2.0% | 587.7 ± 0.7% | 244.0 ± 4.5% | 1.054 | 1.067 | 3.805 | 1.435 | 3.456 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.4 ± 0.9% | 1140.1 ± 1.3% | 894.6 ± 1.3% | 333.4 ± 2.1% | 361.9 ± 1.9% | 311.9 ± 0.5% | 1.170 | 1.490 | 4.000 | 3.684 | 4.276 |
| qlog records, JSON text sequence | 1467503 | 1142.9 ± 1.2% | 875.3 ± 0.6% | 724.5 ± 0.4% | 319.6 ± 0.9% | 391.2 ± 0.7% | 233.7 ± 1.3% | 1.306 | 1.577 | 3.576 | 2.922 | 4.890 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1362.1 ± 2.0% | 1140.1 ± 1.3% | 894.6 ± 1.3% | 333.4 ± 2.1% | 361.9 ± 1.9% | 311.9 ± 0.5% | 1.195 | 1.523 | 4.086 | 3.764 | 4.368 |
| qlog records, JSON text sequence | 1467503 | 1169.6 ± 0.3% | 875.3 ± 0.6% | 724.5 ± 0.4% | 319.6 ± 0.9% | 391.2 ± 0.7% | 233.7 ± 1.3% | 1.336 | 1.614 | 3.659 | 2.990 | 5.004 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 812.1 ± 4.4% | 1002.1 ± 3.3% | 971.5 ± 2.8% | 258.3 ± 3.8% | 531.1 ± 0.2% | 256.3 ± 1.9% | 0.810 | 0.836 | 3.143 | 1.529 | 3.169 |
| qlog records, JSON text sequence | 1467503 | 746.8 ± 0.8% | 799.9 ± 0.3% | 790.3 ± 2.9% | 221.6 ± 2.0% | 587.7 ± 0.7% | 244.0 ± 4.5% | 0.934 | 0.945 | 3.370 | 1.271 | 3.061 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 960.6 ± 0.7% | 1140.1 ± 1.3% | 894.6 ± 1.3% | 333.4 ± 2.1% | 361.9 ± 1.9% | 311.9 ± 0.5% | 0.843 | 1.074 | 2.882 | 2.654 | 3.080 |
| qlog records, JSON text sequence | 1467503 | 795.5 ± 0.5% | 875.3 ± 0.6% | 724.5 ± 0.4% | 319.6 ± 0.9% | 391.2 ± 0.7% | 233.7 ± 1.3% | 0.909 | 1.098 | 2.489 | 2.034 | 3.404 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.810 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.836 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.934 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.945 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.843 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.909 of simdjson.
