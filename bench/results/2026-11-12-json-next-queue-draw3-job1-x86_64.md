# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1015.1 ± 3.0% | 0.486 | 0.991 | 1.045 | 1.042 | 0.415 | 1.053 | 1.039 | 0.365 | 0.802 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 852.9 ± 1.6% | 0.737 | 1.037 | 1.014 | 1.009 | 0.390 | 1.012 | 0.996 | 0.342 | 0.684 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.1 ± 8.1% | 0.443 | 0.985 | 0.981 | 1.005 | 1.000 | 0.235 | 1.002 | 0.447 | 0.724 | 0.085 | 1.024 |
| qlog records, JSON text sequence | 1467503 | 1164.2 ± 0.3% | 0.700 | 0.919 | 0.983 | 0.982 | 0.986 | 0.225 | 0.987 | 0.408 | 0.692 | 0.103 | 1.009 |

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
| CLDR supplemental, 34 texts | 920675 | 1015.1 ± 3.0% | 1021.9 ± 0.7% | 986.3 ± 2.7% | 260.0 ± 1.0% | 531.1 ± 0.8% | 258.7 ± 1.9% | 0.993 | 1.029 | 3.905 | 1.912 | 3.924 |
| qlog records, JSON text sequence | 1467503 | 852.9 ± 1.6% | 812.1 ± 5.1% | 807.4 ± 6.4% | 224.0 ± 0.9% | 590.9 ± 5.0% | 244.2 ± 1.6% | 1.050 | 1.056 | 3.808 | 1.443 | 3.493 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1332.1 ± 8.1% | 1141.9 ± 1.0% | 899.6 ± 0.8% | 321.1 ± 1.3% | 357.7 ± 11.7% | 313.0 ± 17.2% | 1.167 | 1.481 | 4.148 | 3.724 | 4.256 |
| qlog records, JSON text sequence | 1467503 | 1164.2 ± 0.3% | 869.2 ± 0.4% | 726.8 ± 0.7% | 316.6 ± 5.5% | 392.4 ± 0.7% | 233.3 ± 2.6% | 1.339 | 1.602 | 3.677 | 2.967 | 4.990 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1364.0 ± 7.0% | 1141.9 ± 1.0% | 899.6 ± 0.8% | 321.1 ± 1.3% | 357.7 ± 11.7% | 313.0 ± 17.2% | 1.194 | 1.516 | 4.248 | 3.813 | 4.358 |
| qlog records, JSON text sequence | 1467503 | 1175.2 ± 0.3% | 869.2 ± 0.4% | 726.8 ± 0.7% | 316.6 ± 5.5% | 392.4 ± 0.7% | 233.3 ± 2.6% | 1.352 | 1.617 | 3.712 | 2.995 | 5.037 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 813.9 ± 4.0% | 1021.9 ± 0.7% | 986.3 ± 2.7% | 260.0 ± 1.0% | 531.1 ± 0.8% | 258.7 ± 1.9% | 0.796 | 0.825 | 3.131 | 1.533 | 3.146 |
| qlog records, JSON text sequence | 1467503 | 583.8 ± 1.1% | 812.1 ± 5.1% | 807.4 ± 6.4% | 224.0 ± 0.9% | 590.9 ± 5.0% | 244.2 ± 1.6% | 0.719 | 0.723 | 2.607 | 0.988 | 2.391 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 965.1 ± 0.8% | 1141.9 ± 1.0% | 899.6 ± 0.8% | 321.1 ± 1.3% | 357.7 ± 11.7% | 313.0 ± 17.2% | 0.845 | 1.073 | 3.005 | 2.698 | 3.084 |
| qlog records, JSON text sequence | 1467503 | 805.7 ± 0.8% | 869.2 ± 0.4% | 726.8 ± 0.7% | 316.6 ± 5.5% | 392.4 ± 0.7% | 233.3 ± 2.6% | 0.927 | 1.109 | 2.545 | 2.053 | 3.453 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.796 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.825 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.719 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.723 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.845 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.927 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1030.6 ± 3.4% | 0.466 | 1.016 | 1.068 | 1.063 | 0.418 | 1.051 | 1.059 | 0.359 | 0.753 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 842.0 ± 0.4% | 0.734 | 1.027 | 1.011 | 1.008 | 0.392 | 1.014 | 1.006 | 0.345 | 0.797 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.8 ± 1.3% | 0.439 | 0.976 | 0.971 | 0.997 | 1.011 | 0.229 | 1.012 | 0.440 | 0.721 | 0.086 | 1.024 |
| qlog records, JSON text sequence | 1467503 | 1164.4 ± 0.5% | 0.689 | 0.944 | 0.985 | 0.986 | 0.989 | 0.221 | 0.987 | 0.409 | 0.693 | 0.104 | 1.016 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.068 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.063 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.051 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 1030.6 ± 3.4% | 1024.8 ± 0.8% | 981.7 ± 0.3% | 259.8 ± 4.1% | 531.7 ± 0.2% | 258.3 ± 2.7% | 1.006 | 1.050 | 3.966 | 1.938 | 3.989 |
| qlog records, JSON text sequence | 1467503 | 842.0 ± 0.4% | 790.1 ± 1.6% | 829.0 ± 1.4% | 223.5 ± 0.8% | 590.4 ± 0.8% | 247.8 ± 2.3% | 1.066 | 1.016 | 3.768 | 1.426 | 3.398 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1334.8 ± 1.3% | 1134.3 ± 1.0% | 900.9 ± 0.3% | 332.0 ± 0.6% | 362.0 ± 4.0% | 313.9 ± 0.6% | 1.177 | 1.482 | 4.021 | 3.687 | 4.252 |
| qlog records, JSON text sequence | 1467503 | 1164.4 ± 0.5% | 875.4 ± 0.2% | 729.7 ± 0.3% | 323.6 ± 0.5% | 393.6 ± 0.7% | 232.9 ± 4.4% | 1.330 | 1.596 | 3.598 | 2.958 | 5.000 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1366.8 ± 2.5% | 1134.3 ± 1.0% | 900.9 ± 0.3% | 332.0 ± 0.6% | 362.0 ± 4.0% | 313.9 ± 0.6% | 1.205 | 1.517 | 4.117 | 3.775 | 4.354 |
| qlog records, JSON text sequence | 1467503 | 1182.9 ± 0.3% | 875.4 ± 0.2% | 729.7 ± 0.3% | 323.6 ± 0.5% | 393.6 ± 0.7% | 232.9 ± 4.4% | 1.351 | 1.621 | 3.655 | 3.005 | 5.079 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 775.6 ± 2.1% | 1024.8 ± 0.8% | 981.7 ± 0.3% | 259.8 ± 4.1% | 531.7 ± 0.2% | 258.3 ± 2.7% | 0.757 | 0.790 | 2.985 | 1.459 | 3.002 |
| qlog records, JSON text sequence | 1467503 | 671.4 ± 1.2% | 790.1 ± 1.6% | 829.0 ± 1.4% | 223.5 ± 0.8% | 590.4 ± 0.8% | 247.8 ± 2.3% | 0.850 | 0.810 | 3.004 | 1.137 | 2.709 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 963.1 ± 0.4% | 1134.3 ± 1.0% | 900.9 ± 0.3% | 332.0 ± 0.6% | 362.0 ± 4.0% | 313.9 ± 0.6% | 0.849 | 1.069 | 2.901 | 2.660 | 3.068 |
| qlog records, JSON text sequence | 1467503 | 807.1 ± 0.4% | 875.4 ± 0.2% | 729.7 ± 0.3% | 323.6 ± 0.5% | 393.6 ± 0.7% | 232.9 ± 4.4% | 0.922 | 1.106 | 2.494 | 2.050 | 3.465 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.757 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.790 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.850 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.810 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.849 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.922 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1010.2 ± 5.4% | 0.477 | 1.022 | 1.084 | 1.080 | 0.426 | 1.067 | 1.079 | 0.366 | 0.791 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 844.5 ± 0.6% | 0.735 | 1.024 | 1.007 | 1.005 | 0.390 | 1.011 | 1.004 | 0.344 | 0.889 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.2 ± 1.1% | 0.438 | 0.975 | 0.970 | 0.995 | 1.005 | 0.228 | 1.008 | 0.438 | 0.722 | 0.086 | 1.021 |
| qlog records, JSON text sequence | 1467503 | 1166.1 ± 5.3% | 0.689 | 0.945 | 0.984 | 0.985 | 0.986 | 0.220 | 0.986 | 0.408 | 0.694 | 0.104 | 1.016 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.084 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.080 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.067 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.079 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1010.2 ± 5.4% | 997.0 ± 4.5% | 987.9 ± 0.7% | 259.2 ± 0.8% | 529.3 ± 0.7% | 261.1 ± 3.2% | 1.013 | 1.023 | 3.897 | 1.908 | 3.869 |
| qlog records, JSON text sequence | 1467503 | 844.5 ± 0.6% | 812.1 ± 0.2% | 798.9 ± 7.6% | 222.1 ± 10.2% | 588.5 ± 0.4% | 247.2 ± 4.4% | 1.040 | 1.057 | 3.803 | 1.435 | 3.416 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1337.2 ± 1.1% | 1128.8 ± 1.1% | 898.4 ± 5.8% | 333.2 ± 1.0% | 365.2 ± 4.6% | 313.1 ± 0.8% | 1.185 | 1.488 | 4.013 | 3.661 | 4.271 |
| qlog records, JSON text sequence | 1467503 | 1166.1 ± 5.3% | 871.8 ± 1.6% | 726.7 ± 2.1% | 280.9 ± 0.1% | 380.3 ± 0.5% | 231.5 ± 2.3% | 1.338 | 1.605 | 4.152 | 3.066 | 5.037 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1364.9 ± 0.6% | 1128.8 ± 1.1% | 898.4 ± 5.8% | 333.2 ± 1.0% | 365.2 ± 4.6% | 313.1 ± 0.8% | 1.209 | 1.519 | 4.096 | 3.737 | 4.360 |
| qlog records, JSON text sequence | 1467503 | 1184.9 ± 0.2% | 871.8 ± 1.6% | 726.7 ± 2.1% | 280.9 ± 0.1% | 380.3 ± 0.5% | 231.5 ± 2.3% | 1.359 | 1.631 | 4.219 | 3.115 | 5.118 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 798.7 ± 3.3% | 997.0 ± 4.5% | 987.9 ± 0.7% | 259.2 ± 0.8% | 529.3 ± 0.7% | 261.1 ± 3.2% | 0.801 | 0.808 | 3.081 | 1.509 | 3.059 |
| qlog records, JSON text sequence | 1467503 | 750.6 ± 0.6% | 812.1 ± 0.2% | 798.9 ± 7.6% | 222.1 ± 10.2% | 588.5 ± 0.4% | 247.2 ± 4.4% | 0.924 | 0.940 | 3.380 | 1.275 | 3.036 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 964.9 ± 1.1% | 1128.8 ± 1.1% | 898.4 ± 5.8% | 333.2 ± 1.0% | 365.2 ± 4.6% | 313.1 ± 0.8% | 0.855 | 1.074 | 2.896 | 2.642 | 3.082 |
| qlog records, JSON text sequence | 1467503 | 809.6 ± 6.6% | 871.8 ± 1.6% | 726.7 ± 2.1% | 280.9 ± 0.1% | 380.3 ± 0.5% | 231.5 ± 2.3% | 0.929 | 1.114 | 2.883 | 2.129 | 3.497 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.801 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.808 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.924 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.855 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.929 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1024.4 ± 3.1% | 0.479 | 0.996 | 1.058 | 1.040 | 0.414 | 1.013 | 1.000 | 0.362 | 0.799 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 854.0 ± 0.7% | 0.734 | 1.033 | 1.019 | 1.005 | 0.390 | 1.014 | 0.998 | 0.345 | 0.686 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.1 ± 0.4% | 0.443 | 0.982 | 0.979 | 1.001 | 1.004 | 0.236 | 1.001 | 0.444 | 0.720 | 0.086 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1165.3 ± 1.1% | 0.701 | 0.923 | 0.989 | 0.981 | 0.986 | 0.226 | 0.987 | 0.407 | 0.691 | 0.104 | 1.012 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.058 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1024.4 ± 3.1% | 1024.1 ± 0.1% | 986.8 ± 3.7% | 260.1 ± 6.2% | 531.8 ± 0.2% | 257.6 ± 2.2% | 1.000 | 1.038 | 3.939 | 1.926 | 3.976 |
| qlog records, JSON text sequence | 1467503 | 854.0 ± 0.7% | 812.4 ± 0.9% | 825.1 ± 1.2% | 222.1 ± 2.2% | 589.3 ± 0.7% | 245.8 ± 0.9% | 1.051 | 1.035 | 3.845 | 1.449 | 3.474 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.1 ± 0.4% | 1136.8 ± 1.6% | 896.8 ± 1.0% | 320.2 ± 4.5% | 356.5 ± 1.9% | 315.4 ± 4.8% | 1.173 | 1.486 | 4.163 | 3.739 | 4.226 |
| qlog records, JSON text sequence | 1467503 | 1165.3 ± 1.1% | 868.8 ± 0.7% | 726.5 ± 0.7% | 320.4 ± 0.3% | 392.1 ± 1.1% | 233.9 ± 3.0% | 1.341 | 1.604 | 3.637 | 2.972 | 4.982 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1362.2 ± 4.0% | 1136.8 ± 1.6% | 896.8 ± 1.0% | 320.2 ± 4.5% | 356.5 ± 1.9% | 315.4 ± 4.8% | 1.198 | 1.519 | 4.254 | 3.821 | 4.318 |
| qlog records, JSON text sequence | 1467503 | 1179.4 ± 0.3% | 868.8 ± 0.7% | 726.5 ± 0.7% | 320.4 ± 0.3% | 392.1 ± 1.1% | 233.9 ± 3.0% | 1.358 | 1.623 | 3.681 | 3.008 | 5.042 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 818.9 ± 0.8% | 1024.1 ± 0.1% | 986.8 ± 3.7% | 260.1 ± 6.2% | 531.8 ± 0.2% | 257.6 ± 2.2% | 0.800 | 0.830 | 3.149 | 1.540 | 3.178 |
| qlog records, JSON text sequence | 1467503 | 585.5 ± 1.0% | 812.4 ± 0.9% | 825.1 ± 1.2% | 222.1 ± 2.2% | 589.3 ± 0.7% | 245.8 ± 0.9% | 0.721 | 0.710 | 2.636 | 0.994 | 2.382 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 959.3 ± 0.8% | 1136.8 ± 1.6% | 896.8 ± 1.0% | 320.2 ± 4.5% | 356.5 ± 1.9% | 315.4 ± 4.8% | 0.844 | 1.070 | 2.996 | 2.691 | 3.041 |
| qlog records, JSON text sequence | 1467503 | 804.8 ± 0.2% | 868.8 ± 0.7% | 726.5 ± 0.7% | 320.4 ± 0.3% | 392.1 ± 1.1% | 233.9 ± 3.0% | 0.926 | 1.108 | 2.512 | 2.052 | 3.441 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.800 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.830 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.721 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.710 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.844 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1045.5 ± 3.5% | 0.461 | 0.990 | 1.049 | 1.046 | 0.408 | 1.038 | 1.048 | 0.354 | 0.741 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 844.3 ± 0.5% | 0.734 | 1.023 | 1.007 | 1.004 | 0.388 | 1.011 | 1.005 | 0.345 | 0.788 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.6 ± 3.1% | 0.437 | 0.974 | 0.972 | 0.995 | 1.003 | 0.228 | 1.005 | 0.440 | 0.721 | 0.085 | 1.013 |
| qlog records, JSON text sequence | 1467503 | 1161.0 ± 1.0% | 0.690 | 0.946 | 0.986 | 0.988 | 0.989 | 0.222 | 0.989 | 0.411 | 0.697 | 0.104 | 1.014 |

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
| CLDR supplemental, 34 texts | 920675 | 1045.5 ± 3.5% | 1026.7 ± 2.8% | 983.6 ± 0.5% | 258.9 ± 0.9% | 531.9 ± 0.2% | 255.9 ± 6.3% | 1.018 | 1.063 | 4.038 | 1.965 | 4.086 |
| qlog records, JSON text sequence | 1467503 | 844.3 ± 0.5% | 770.8 ± 0.4% | 815.8 ± 5.1% | 224.0 ± 1.0% | 591.3 ± 0.5% | 246.9 ± 1.2% | 1.095 | 1.035 | 3.770 | 1.428 | 3.419 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.6 ± 3.1% | 1135.2 ± 1.0% | 900.4 ± 0.6% | 332.7 ± 4.9% | 360.8 ± 1.1% | 313.8 ± 5.3% | 1.180 | 1.488 | 4.027 | 3.713 | 4.269 |
| qlog records, JSON text sequence | 1467503 | 1161.0 ± 1.0% | 877.8 ± 0.4% | 728.4 ± 0.8% | 323.2 ± 0.6% | 394.2 ± 1.3% | 233.9 ± 1.3% | 1.323 | 1.594 | 3.593 | 2.945 | 4.964 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1357.1 ± 4.6% | 1135.2 ± 1.0% | 900.4 ± 0.6% | 332.7 ± 4.9% | 360.8 ± 1.1% | 313.8 ± 5.3% | 1.195 | 1.507 | 4.079 | 3.761 | 4.325 |
| qlog records, JSON text sequence | 1467503 | 1177.3 ± 2.2% | 877.8 ± 0.4% | 728.4 ± 0.8% | 323.2 ± 0.6% | 394.2 ± 1.3% | 233.9 ± 1.3% | 1.341 | 1.616 | 3.643 | 2.987 | 5.034 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 775.1 ± 0.9% | 1026.7 ± 2.8% | 983.6 ± 0.5% | 258.9 ± 0.9% | 531.9 ± 0.2% | 255.9 ± 6.3% | 0.755 | 0.788 | 2.994 | 1.457 | 3.029 |
| qlog records, JSON text sequence | 1467503 | 665.6 ± 0.9% | 770.8 ± 0.4% | 815.8 ± 5.1% | 224.0 ± 1.0% | 591.3 ± 0.5% | 246.9 ± 1.2% | 0.864 | 0.816 | 2.972 | 1.126 | 2.696 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 965.6 ± 0.6% | 1135.2 ± 1.0% | 900.4 ± 0.6% | 332.7 ± 4.9% | 360.8 ± 1.1% | 313.8 ± 5.3% | 0.851 | 1.072 | 2.902 | 2.676 | 3.077 |
| qlog records, JSON text sequence | 1467503 | 809.5 ± 1.2% | 877.8 ± 0.4% | 728.4 ± 0.8% | 323.2 ± 0.6% | 394.2 ± 1.3% | 233.9 ± 1.3% | 0.922 | 1.111 | 2.505 | 2.054 | 3.461 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.755 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.788 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.864 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.816 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.851 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.922 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1039.9 ± 5.2% | 0.465 | 1.017 | 1.050 | 1.054 | 0.410 | 1.041 | 1.052 | 0.356 | 0.772 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 844.9 ± 1.2% | 0.733 | 1.024 | 1.005 | 1.005 | 0.387 | 1.012 | 1.002 | 0.348 | 0.889 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1342.7 ± 5.4% | 0.437 | 0.975 | 0.968 | 0.992 | 1.003 | 0.228 | 1.004 | 0.440 | 0.719 | 0.085 | 1.014 |
| qlog records, JSON text sequence | 1467503 | 1166.3 ± 0.8% | 0.687 | 0.944 | 0.980 | 0.983 | 0.986 | 0.221 | 0.986 | 0.412 | 0.695 | 0.104 | 1.011 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.054 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 1039.9 ± 5.2% | 991.4 ± 0.2% | 965.2 ± 3.3% | 260.0 ± 0.8% | 533.1 ± 0.9% | 260.7 ± 2.4% | 1.049 | 1.077 | 4.000 | 1.951 | 3.989 |
| qlog records, JSON text sequence | 1467503 | 844.9 ± 1.2% | 795.1 ± 0.1% | 817.1 ± 2.0% | 223.6 ± 1.9% | 591.0 ± 0.5% | 247.5 ± 4.7% | 1.063 | 1.034 | 3.778 | 1.429 | 3.413 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1342.7 ± 5.4% | 1137.6 ± 0.8% | 901.1 ± 5.2% | 333.8 ± 0.5% | 359.5 ± 4.5% | 311.9 ± 0.8% | 1.180 | 1.490 | 4.022 | 3.735 | 4.304 |
| qlog records, JSON text sequence | 1467503 | 1166.3 ± 0.8% | 875.1 ± 4.6% | 724.5 ± 3.7% | 322.9 ± 2.6% | 391.9 ± 0.6% | 234.4 ± 0.7% | 1.333 | 1.610 | 3.612 | 2.976 | 4.975 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1361.6 ± 1.3% | 1137.6 ± 0.8% | 901.1 ± 5.2% | 333.8 ± 0.5% | 359.5 ± 4.5% | 311.9 ± 0.8% | 1.197 | 1.511 | 4.079 | 3.788 | 4.365 |
| qlog records, JSON text sequence | 1467503 | 1178.8 ± 0.6% | 875.1 ± 4.6% | 724.5 ± 3.7% | 322.9 ± 2.6% | 391.9 ± 0.6% | 234.4 ± 0.7% | 1.347 | 1.627 | 3.651 | 3.008 | 5.028 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 802.5 ± 5.0% | 991.4 ± 0.2% | 965.2 ± 3.3% | 260.0 ± 0.8% | 533.1 ± 0.9% | 260.7 ± 2.4% | 0.809 | 0.831 | 3.087 | 1.505 | 3.078 |
| qlog records, JSON text sequence | 1467503 | 751.3 ± 1.0% | 795.1 ± 0.1% | 817.1 ± 2.0% | 223.6 ± 1.9% | 591.0 ± 0.5% | 247.5 ± 4.7% | 0.945 | 0.919 | 3.359 | 1.271 | 3.035 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 964.9 ± 1.0% | 1137.6 ± 0.8% | 901.1 ± 5.2% | 333.8 ± 0.5% | 359.5 ± 4.5% | 311.9 ± 0.8% | 0.848 | 1.071 | 2.891 | 2.684 | 3.093 |
| qlog records, JSON text sequence | 1467503 | 810.6 ± 1.3% | 875.1 ± 4.6% | 724.5 ± 3.7% | 322.9 ± 2.6% | 391.9 ± 0.6% | 234.4 ± 0.7% | 0.926 | 1.119 | 2.511 | 2.068 | 3.458 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.809 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.831 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.945 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.919 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.848 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1033.2 ± 4.8% | 0.474 | 0.979 | 1.029 | 1.032 | 0.410 | 1.047 | 1.021 | 0.358 | 0.780 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 854.4 ± 1.5% | 0.734 | 1.037 | 1.015 | 1.002 | 0.391 | 1.010 | 0.996 | 0.341 | 0.682 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1338.2 ± 1.3% | 0.440 | 0.981 | 0.975 | 1.001 | 0.997 | 0.234 | 0.999 | 0.444 | 0.722 | 0.085 | 1.024 |
| qlog records, JSON text sequence | 1467503 | 1166.9 ± 0.2% | 0.701 | 0.919 | 0.982 | 0.980 | 0.983 | 0.227 | 0.984 | 0.406 | 0.690 | 0.103 | 1.011 |

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
| CLDR supplemental, 34 texts | 920675 | 1033.2 ± 4.8% | 1012.9 ± 0.3% | 988.9 ± 0.6% | 260.4 ± 0.3% | 531.5 ± 0.3% | 257.0 ± 2.9% | 1.020 | 1.045 | 3.967 | 1.944 | 4.021 |
| qlog records, JSON text sequence | 1467503 | 854.4 ± 1.5% | 810.8 ± 0.4% | 825.8 ± 1.8% | 223.1 ± 1.1% | 590.8 ± 0.3% | 246.2 ± 0.5% | 1.054 | 1.035 | 3.830 | 1.446 | 3.470 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1338.2 ± 1.3% | 1137.4 ± 0.7% | 902.8 ± 5.6% | 320.8 ± 0.2% | 356.0 ± 5.2% | 315.7 ± 0.3% | 1.177 | 1.482 | 4.171 | 3.759 | 4.239 |
| qlog records, JSON text sequence | 1467503 | 1166.9 ± 0.2% | 869.9 ± 0.7% | 725.8 ± 1.1% | 319.2 ± 0.4% | 390.9 ± 1.1% | 233.3 ± 2.3% | 1.341 | 1.608 | 3.656 | 2.985 | 5.001 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1369.8 ± 1.3% | 1137.4 ± 0.7% | 902.8 ± 5.6% | 320.8 ± 0.2% | 356.0 ± 5.2% | 315.7 ± 0.3% | 1.204 | 1.517 | 4.270 | 3.848 | 4.339 |
| qlog records, JSON text sequence | 1467503 | 1179.2 ± 0.3% | 869.9 ± 0.7% | 725.8 ± 1.1% | 319.2 ± 0.4% | 390.9 ± 1.1% | 233.3 ± 2.3% | 1.355 | 1.625 | 3.694 | 3.017 | 5.053 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 806.4 ± 3.1% | 1012.9 ± 0.3% | 988.9 ± 0.6% | 260.4 ± 0.3% | 531.5 ± 0.3% | 257.0 ± 2.9% | 0.796 | 0.815 | 3.096 | 1.517 | 3.138 |
| qlog records, JSON text sequence | 1467503 | 582.8 ± 1.2% | 810.8 ± 0.4% | 825.8 ± 1.8% | 223.1 ± 1.1% | 590.8 ± 0.3% | 246.2 ± 0.5% | 0.719 | 0.706 | 2.612 | 0.987 | 2.367 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 965.7 ± 2.1% | 1137.4 ± 0.7% | 902.8 ± 5.6% | 320.8 ± 0.2% | 356.0 ± 5.2% | 315.7 ± 0.3% | 0.849 | 1.070 | 3.010 | 2.713 | 3.059 |
| qlog records, JSON text sequence | 1467503 | 805.3 ± 0.4% | 869.9 ± 0.7% | 725.8 ± 1.1% | 319.2 ± 0.4% | 390.9 ± 1.1% | 233.3 ± 2.3% | 0.926 | 1.110 | 2.523 | 2.060 | 3.451 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.796 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.815 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.719 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.706 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.849 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1009.2 ± 4.3% | 0.477 | 1.034 | 1.087 | 1.090 | 0.425 | 1.074 | 1.086 | 0.367 | 0.768 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 842.8 ± 0.5% | 0.735 | 1.025 | 1.009 | 1.004 | 0.389 | 1.014 | 1.005 | 0.345 | 0.795 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1344.1 ± 0.3% | 0.436 | 0.971 | 0.969 | 0.991 | 1.000 | 0.226 | 1.004 | 0.440 | 0.719 | 0.085 | 1.010 |
| qlog records, JSON text sequence | 1467503 | 1164.5 ± 0.4% | 0.689 | 0.946 | 0.984 | 0.986 | 0.985 | 0.221 | 0.988 | 0.411 | 0.695 | 0.104 | 1.014 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.087 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.090 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.074 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.086 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1009.2 ± 4.3% | 998.9 ± 4.8% | 967.5 ± 0.6% | 258.9 ± 0.6% | 532.7 ± 0.5% | 259.1 ± 2.3% | 1.010 | 1.043 | 3.897 | 1.895 | 3.895 |
| qlog records, JSON text sequence | 1467503 | 842.8 ± 0.5% | 798.6 ± 4.7% | 819.7 ± 1.8% | 221.5 ± 4.2% | 590.2 ± 0.8% | 247.7 ± 0.9% | 1.055 | 1.028 | 3.805 | 1.428 | 3.403 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1344.1 ± 0.3% | 1139.9 ± 0.8% | 900.0 ± 0.8% | 333.0 ± 4.5% | 359.5 ± 3.6% | 312.7 ± 0.5% | 1.179 | 1.494 | 4.036 | 3.738 | 4.298 |
| qlog records, JSON text sequence | 1467503 | 1164.5 ± 0.4% | 876.7 ± 0.3% | 730.1 ± 0.3% | 323.9 ± 0.4% | 392.0 ± 7.8% | 233.1 ± 1.3% | 1.328 | 1.595 | 3.595 | 2.971 | 4.995 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1357.1 ± 3.6% | 1139.9 ± 0.8% | 900.0 ± 0.8% | 333.0 ± 4.5% | 359.5 ± 3.6% | 312.7 ± 0.5% | 1.191 | 1.508 | 4.075 | 3.774 | 4.340 |
| qlog records, JSON text sequence | 1467503 | 1181.0 ± 1.5% | 876.7 ± 0.3% | 730.1 ± 0.3% | 323.9 ± 0.4% | 392.0 ± 7.8% | 233.1 ± 1.3% | 1.347 | 1.618 | 3.646 | 3.013 | 5.066 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 775.1 ± 1.8% | 998.9 ± 4.8% | 967.5 ± 0.6% | 258.9 ± 0.6% | 532.7 ± 0.5% | 259.1 ± 2.3% | 0.776 | 0.801 | 2.993 | 1.455 | 2.991 |
| qlog records, JSON text sequence | 1467503 | 670.0 ± 2.9% | 798.6 ± 4.7% | 819.7 ± 1.8% | 221.5 ± 4.2% | 590.2 ± 0.8% | 247.7 ± 0.9% | 0.839 | 0.817 | 3.025 | 1.135 | 2.705 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 965.8 ± 6.1% | 1139.9 ± 0.8% | 900.0 ± 0.8% | 333.0 ± 4.5% | 359.5 ± 3.6% | 312.7 ± 0.5% | 0.847 | 1.073 | 2.900 | 2.686 | 3.088 |
| qlog records, JSON text sequence | 1467503 | 809.4 ± 0.9% | 876.7 ± 0.3% | 730.1 ± 0.3% | 323.9 ± 0.4% | 392.0 ± 7.8% | 233.1 ± 1.3% | 0.923 | 1.109 | 2.499 | 2.065 | 3.472 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.776 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.801 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.839 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.817 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.847 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.923 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1016.7 ± 4.9% | 0.475 | 1.026 | 1.082 | 1.079 | 0.422 | 1.069 | 1.082 | 0.364 | 0.790 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 847.1 ± 7.6% | 0.731 | 1.022 | 1.000 | 0.999 | 0.388 | 1.007 | 0.999 | 0.339 | 0.884 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1344.9 ± 0.5% | 0.436 | 0.974 | 0.968 | 0.991 | 1.001 | 0.227 | 1.001 | 0.439 | 0.717 | 0.085 | 1.015 |
| qlog records, JSON text sequence | 1467503 | 1166.2 ± 0.3% | 0.688 | 0.944 | 0.980 | 0.985 | 0.987 | 0.221 | 0.986 | 0.412 | 0.694 | 0.104 | 1.014 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.082 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.079 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.069 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 1016.7 ± 4.9% | 994.9 ± 0.9% | 976.9 ± 0.9% | 259.1 ± 0.9% | 532.6 ± 0.3% | 259.8 ± 2.8% | 1.022 | 1.041 | 3.923 | 1.909 | 3.913 |
| qlog records, JSON text sequence | 1467503 | 847.1 ± 7.6% | 793.9 ± 0.3% | 805.6 ± 4.6% | 223.2 ± 2.1% | 590.2 ± 0.8% | 247.8 ± 0.9% | 1.067 | 1.051 | 3.795 | 1.435 | 3.418 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1344.9 ± 0.5% | 1136.1 ± 1.0% | 900.1 ± 0.7% | 332.6 ± 4.1% | 361.7 ± 2.4% | 313.0 ± 0.7% | 1.184 | 1.494 | 4.044 | 3.718 | 4.297 |
| qlog records, JSON text sequence | 1467503 | 1166.2 ± 0.3% | 876.6 ± 1.3% | 728.5 ± 1.1% | 323.5 ± 0.6% | 387.2 ± 6.7% | 234.0 ± 1.8% | 1.330 | 1.601 | 3.605 | 3.012 | 4.984 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1364.7 ± 3.7% | 1136.1 ± 1.0% | 900.1 ± 0.7% | 332.6 ± 4.1% | 361.7 ± 2.4% | 313.0 ± 0.7% | 1.201 | 1.516 | 4.103 | 3.773 | 4.360 |
| qlog records, JSON text sequence | 1467503 | 1182.5 ± 0.6% | 876.6 ± 1.3% | 728.5 ± 1.1% | 323.5 ± 0.6% | 387.2 ± 6.7% | 234.0 ± 1.8% | 1.349 | 1.623 | 3.656 | 3.054 | 5.054 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 802.7 ± 2.3% | 994.9 ± 0.9% | 976.9 ± 0.9% | 259.1 ± 0.9% | 532.6 ± 0.3% | 259.8 ± 2.8% | 0.807 | 0.822 | 3.098 | 1.507 | 3.090 |
| qlog records, JSON text sequence | 1467503 | 748.8 ± 5.2% | 793.9 ± 0.3% | 805.6 ± 4.6% | 223.2 ± 2.1% | 590.2 ± 0.8% | 247.8 ± 0.9% | 0.943 | 0.929 | 3.354 | 1.269 | 3.021 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 964.0 ± 1.0% | 1136.1 ± 1.0% | 900.1 ± 0.7% | 332.6 ± 4.1% | 361.7 ± 2.4% | 313.0 ± 0.7% | 0.848 | 1.071 | 2.898 | 2.665 | 3.079 |
| qlog records, JSON text sequence | 1467503 | 809.3 ± 0.6% | 876.6 ± 1.3% | 728.5 ± 1.1% | 323.5 ± 0.6% | 387.2 ± 6.7% | 234.0 ± 1.8% | 0.923 | 1.111 | 2.502 | 2.090 | 3.459 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.807 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.822 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.943 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.929 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.848 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.923 of simdjson.
