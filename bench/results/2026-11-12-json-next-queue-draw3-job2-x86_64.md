# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1045.4 ± 5.4% | 0.471 | 0.999 | 1.020 | 1.012 | 0.405 | 1.036 | 1.012 | 0.353 | 0.782 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 852.4 ± 0.4% | 0.736 | 1.035 | 1.013 | 1.002 | 0.391 | 1.009 | 0.997 | 0.340 | 0.684 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1327.9 ± 3.7% | 0.443 | 0.980 | 0.972 | 0.999 | 0.990 | 0.236 | 0.992 | 0.444 | 0.720 | 0.086 | 1.018 |
| qlog records, JSON text sequence | 1467503 | 1161.7 ± 0.7% | 0.701 | 0.921 | 0.984 | 0.979 | 0.986 | 0.226 | 0.976 | 0.407 | 0.685 | 0.104 | 0.996 |

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
| CLDR supplemental, 34 texts | 920675 | 1045.4 ± 5.4% | 1019.0 ± 12.1% | 978.1 ± 0.6% | 259.1 ± 0.6% | 531.1 ± 2.2% | 252.8 ± 4.4% | 1.026 | 1.069 | 4.035 | 1.968 | 4.135 |
| qlog records, JSON text sequence | 1467503 | 852.4 ± 0.4% | 808.0 ± 0.5% | 801.1 ± 4.9% | 215.1 ± 3.6% | 589.2 ± 0.4% | 245.1 ± 1.1% | 1.055 | 1.064 | 3.962 | 1.447 | 3.478 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1327.9 ± 3.7% | 1120.4 ± 1.0% | 893.9 ± 0.5% | 319.7 ± 5.1% | 358.1 ± 0.9% | 311.1 ± 4.8% | 1.185 | 1.486 | 4.154 | 3.708 | 4.269 |
| qlog records, JSON text sequence | 1467503 | 1161.7 ± 0.7% | 863.2 ± 0.6% | 717.7 ± 6.6% | 317.7 ± 1.0% | 391.9 ± 0.6% | 233.0 ± 1.4% | 1.346 | 1.619 | 3.657 | 2.964 | 4.985 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1352.4 ± 1.2% | 1120.4 ± 1.0% | 893.9 ± 0.5% | 319.7 ± 5.1% | 358.1 ± 0.9% | 311.1 ± 4.8% | 1.207 | 1.513 | 4.230 | 3.777 | 4.348 |
| qlog records, JSON text sequence | 1467503 | 1157.0 ± 0.7% | 863.2 ± 0.6% | 717.7 ± 6.6% | 317.7 ± 1.0% | 391.9 ± 0.6% | 233.0 ± 1.4% | 1.340 | 1.612 | 3.642 | 2.952 | 4.965 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 817.8 ± 2.4% | 1019.0 ± 12.1% | 978.1 ± 0.6% | 259.1 ± 0.6% | 531.1 ± 2.2% | 252.8 ± 4.4% | 0.803 | 0.836 | 3.157 | 1.540 | 3.235 |
| qlog records, JSON text sequence | 1467503 | 582.8 ± 2.9% | 808.0 ± 0.5% | 801.1 ± 4.9% | 215.1 ± 3.6% | 589.2 ± 0.4% | 245.1 ± 1.1% | 0.721 | 0.727 | 2.709 | 0.989 | 2.378 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 955.6 ± 2.0% | 1120.4 ± 1.0% | 893.9 ± 0.5% | 319.7 ± 5.1% | 358.1 ± 0.9% | 311.1 ± 4.8% | 0.853 | 1.069 | 2.989 | 2.669 | 3.072 |
| qlog records, JSON text sequence | 1467503 | 795.6 ± 0.7% | 863.2 ± 0.6% | 717.7 ± 6.6% | 317.7 ± 1.0% | 391.9 ± 0.6% | 233.0 ± 1.4% | 0.922 | 1.109 | 2.505 | 2.030 | 3.414 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.803 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.836 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.721 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.727 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.853 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.922 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1026.7 ± 4.2% | 0.468 | 1.037 | 1.069 | 1.065 | 0.416 | 1.049 | 1.064 | 0.360 | 0.758 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 837.8 ± 1.0% | 0.734 | 1.023 | 1.006 | 1.002 | 0.388 | 1.008 | 0.988 | 0.349 | 0.788 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1340.9 ± 0.2% | 0.436 | 0.970 | 0.962 | 0.995 | 1.006 | 0.227 | 1.005 | 0.440 | 0.717 | 0.086 | 1.019 |
| qlog records, JSON text sequence | 1467503 | 1159.5 ± 2.1% | 0.691 | 0.943 | 0.984 | 0.986 | 0.987 | 0.222 | 0.987 | 0.413 | 0.697 | 0.105 | 1.015 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.069 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.065 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.064 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1026.7 ± 4.2% | 1001.0 ± 0.8% | 974.3 ± 5.8% | 259.6 ± 1.0% | 529.6 ± 0.6% | 256.7 ± 5.8% | 1.026 | 1.054 | 3.955 | 1.939 | 4.000 |
| qlog records, JSON text sequence | 1467503 | 837.8 ± 1.0% | 796.6 ± 1.1% | 814.3 ± 0.3% | 221.3 ± 0.9% | 586.9 ± 0.4% | 246.7 ± 2.4% | 1.052 | 1.029 | 3.787 | 1.427 | 3.397 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1340.9 ± 0.2% | 1134.9 ± 0.4% | 899.8 ± 0.9% | 333.2 ± 1.3% | 360.2 ± 3.9% | 311.4 ± 2.9% | 1.182 | 1.490 | 4.024 | 3.723 | 4.306 |
| qlog records, JSON text sequence | 1467503 | 1159.5 ± 2.1% | 873.1 ± 0.2% | 724.1 ± 0.3% | 322.4 ± 0.7% | 389.4 ± 8.3% | 233.2 ± 0.7% | 1.328 | 1.601 | 3.596 | 2.978 | 4.973 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1365.8 ± 0.5% | 1134.9 ± 0.4% | 899.8 ± 0.9% | 333.2 ± 1.3% | 360.2 ± 3.9% | 311.4 ± 2.9% | 1.203 | 1.518 | 4.099 | 3.792 | 4.386 |
| qlog records, JSON text sequence | 1467503 | 1176.5 ± 0.2% | 873.1 ± 0.2% | 724.1 ± 0.3% | 322.4 ± 0.7% | 389.4 ± 8.3% | 233.2 ± 0.7% | 1.348 | 1.625 | 3.649 | 3.021 | 5.046 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 777.9 ± 1.9% | 1001.0 ± 0.8% | 974.3 ± 5.8% | 259.6 ± 1.0% | 529.6 ± 0.6% | 256.7 ± 5.8% | 0.777 | 0.798 | 2.997 | 1.469 | 3.031 |
| qlog records, JSON text sequence | 1467503 | 660.2 ± 1.6% | 796.6 ± 1.1% | 814.3 ± 0.3% | 221.3 ± 0.9% | 586.9 ± 0.4% | 246.7 ± 2.4% | 0.829 | 0.811 | 2.984 | 1.125 | 2.677 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 960.9 ± 1.2% | 1134.9 ± 0.4% | 899.8 ± 0.9% | 333.2 ± 1.3% | 360.2 ± 3.9% | 311.4 ± 2.9% | 0.847 | 1.068 | 2.884 | 2.668 | 3.086 |
| qlog records, JSON text sequence | 1467503 | 808.5 ± 0.8% | 873.1 ± 0.2% | 724.1 ± 0.3% | 322.4 ± 0.7% | 389.4 ± 8.3% | 233.2 ± 0.7% | 0.926 | 1.116 | 2.508 | 2.076 | 3.467 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.777 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.798 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.829 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.811 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.847 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1011.5 ± 5.7% | 0.475 | 1.055 | 1.082 | 1.081 | 0.426 | 1.068 | 1.079 | 0.366 | 0.786 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 839.0 ± 5.1% | 0.737 | 1.027 | 1.008 | 1.007 | 0.391 | 1.014 | 1.006 | 0.350 | 0.893 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1329.2 ± 1.4% | 0.439 | 0.970 | 0.969 | 1.001 | 1.005 | 0.229 | 1.010 | 0.441 | 0.721 | 0.086 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1153.7 ± 5.3% | 0.694 | 0.950 | 0.988 | 0.991 | 0.993 | 0.223 | 0.993 | 0.413 | 0.701 | 0.105 | 1.021 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.082 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.081 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.068 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 1011.5 ± 5.7% | 1009.4 ± 0.6% | 983.2 ± 2.8% | 259.6 ± 1.8% | 532.0 ± 0.3% | 258.1 ± 4.9% | 1.002 | 1.029 | 3.896 | 1.901 | 3.920 |
| qlog records, JSON text sequence | 1467503 | 839.0 ± 5.1% | 811.3 ± 4.8% | 823.1 ± 3.4% | 223.4 ± 1.4% | 588.0 ± 0.6% | 246.6 ± 0.9% | 1.034 | 1.019 | 3.756 | 1.427 | 3.402 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1329.2 ± 1.4% | 1127.2 ± 1.2% | 897.1 ± 1.0% | 332.7 ± 0.4% | 357.5 ± 5.2% | 312.6 ± 1.6% | 1.179 | 1.482 | 3.995 | 3.718 | 4.252 |
| qlog records, JSON text sequence | 1467503 | 1153.7 ± 5.3% | 805.3 ± 5.7% | 722.4 ± 0.5% | 323.2 ± 0.7% | 391.4 ± 0.6% | 232.5 ± 0.8% | 1.433 | 1.597 | 3.570 | 2.947 | 4.963 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1351.4 ± 2.9% | 1127.2 ± 1.2% | 897.1 ± 1.0% | 332.7 ± 0.4% | 357.5 ± 5.2% | 312.6 ± 1.6% | 1.199 | 1.506 | 4.062 | 3.780 | 4.323 |
| qlog records, JSON text sequence | 1467503 | 1177.5 ± 5.4% | 805.3 ± 5.7% | 722.4 ± 0.5% | 323.2 ± 0.7% | 391.4 ± 0.6% | 232.5 ± 0.8% | 1.462 | 1.630 | 3.643 | 3.008 | 5.065 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 795.5 ± 0.8% | 1009.4 ± 0.6% | 983.2 ± 2.8% | 259.6 ± 1.8% | 532.0 ± 0.3% | 258.1 ± 4.9% | 0.788 | 0.809 | 3.064 | 1.495 | 3.083 |
| qlog records, JSON text sequence | 1467503 | 749.6 ± 0.4% | 811.3 ± 4.8% | 823.1 ± 3.4% | 223.4 ± 1.4% | 588.0 ± 0.6% | 246.6 ± 0.9% | 0.924 | 0.911 | 3.355 | 1.275 | 3.040 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 958.0 ± 1.6% | 1127.2 ± 1.2% | 897.1 ± 1.0% | 332.7 ± 0.4% | 357.5 ± 5.2% | 312.6 ± 1.6% | 0.850 | 1.068 | 2.880 | 2.680 | 3.065 |
| qlog records, JSON text sequence | 1467503 | 809.0 ± 0.3% | 805.3 ± 5.7% | 722.4 ± 0.5% | 323.2 ± 0.7% | 391.4 ± 0.6% | 232.5 ± 0.8% | 1.005 | 1.120 | 2.503 | 2.067 | 3.480 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.788 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.809 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.924 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.911 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.850 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1023.8 ± 0.5% | 0.472 | 0.981 | 1.023 | 1.030 | 0.407 | 1.029 | 1.007 | 0.361 | 0.800 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 850.6 ± 0.6% | 0.738 | 1.031 | 1.012 | 1.003 | 0.387 | 1.014 | 0.996 | 0.342 | 0.683 | 0.107 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.6 ± 1.2% | 0.440 | 0.977 | 0.970 | 0.998 | 0.991 | 0.234 | 0.990 | 0.444 | 0.718 | 0.086 | 1.011 |
| qlog records, JSON text sequence | 1467503 | 1161.5 ± 0.8% | 0.701 | 0.921 | 0.985 | 0.980 | 0.980 | 0.228 | 0.970 | 0.411 | 0.685 | 0.104 | 0.998 |

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
| CLDR supplemental, 34 texts | 920675 | 1023.8 ± 0.5% | 997.4 ± 0.5% | 967.6 ± 1.4% | 259.3 ± 1.1% | 531.2 ± 3.6% | 259.5 ± 2.7% | 1.026 | 1.058 | 3.949 | 1.927 | 3.945 |
| qlog records, JSON text sequence | 1467503 | 850.6 ± 0.6% | 797.1 ± 2.8% | 803.7 ± 0.9% | 217.3 ± 4.0% | 587.7 ± 1.0% | 244.5 ± 3.1% | 1.067 | 1.058 | 3.914 | 1.447 | 3.479 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1339.6 ± 1.2% | 1129.8 ± 1.1% | 894.0 ± 4.9% | 320.3 ± 1.2% | 358.7 ± 0.2% | 312.8 ± 4.6% | 1.186 | 1.498 | 4.182 | 3.734 | 4.283 |
| qlog records, JSON text sequence | 1467503 | 1161.5 ± 0.8% | 865.0 ± 1.2% | 721.6 ± 0.7% | 318.7 ± 0.4% | 391.9 ± 7.2% | 233.4 ± 1.9% | 1.343 | 1.610 | 3.645 | 2.964 | 4.976 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1354.4 ± 0.4% | 1129.8 ± 1.1% | 894.0 ± 4.9% | 320.3 ± 1.2% | 358.7 ± 0.2% | 312.8 ± 4.6% | 1.199 | 1.515 | 4.228 | 3.775 | 4.330 |
| qlog records, JSON text sequence | 1467503 | 1159.1 ± 2.8% | 865.0 ± 1.2% | 721.6 ± 0.7% | 318.7 ± 0.4% | 391.9 ± 7.2% | 233.4 ± 1.9% | 1.340 | 1.606 | 3.637 | 2.958 | 4.966 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 819.6 ± 0.3% | 997.4 ± 0.5% | 967.6 ± 1.4% | 259.3 ± 1.1% | 531.2 ± 3.6% | 259.5 ± 2.7% | 0.822 | 0.847 | 3.161 | 1.543 | 3.158 |
| qlog records, JSON text sequence | 1467503 | 580.8 ± 0.9% | 797.1 ± 2.8% | 803.7 ± 0.9% | 217.3 ± 4.0% | 587.7 ± 1.0% | 244.5 ± 3.1% | 0.729 | 0.723 | 2.672 | 0.988 | 2.375 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 962.3 ± 1.1% | 1129.8 ± 1.1% | 894.0 ± 4.9% | 320.3 ± 1.2% | 358.7 ± 0.2% | 312.8 ± 4.6% | 0.852 | 1.076 | 3.004 | 2.683 | 3.077 |
| qlog records, JSON text sequence | 1467503 | 795.5 ± 1.1% | 865.0 ± 1.2% | 721.6 ± 0.7% | 318.7 ± 0.4% | 391.9 ± 7.2% | 233.4 ± 1.9% | 0.920 | 1.102 | 2.496 | 2.030 | 3.408 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.822 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.847 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.729 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.723 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.852 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.920 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 990.8 ± 2.6% | 0.485 | 1.067 | 1.109 | 1.110 | 0.434 | 1.087 | 1.106 | 0.373 | 0.781 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 840.3 ± 0.4% | 0.736 | 1.024 | 1.007 | 1.003 | 0.390 | 1.010 | 1.002 | 0.345 | 0.788 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.3 ± 1.8% | 0.437 | 0.975 | 0.957 | 0.996 | 1.005 | 0.228 | 1.005 | 0.440 | 0.714 | 0.086 | 1.011 |
| qlog records, JSON text sequence | 1467503 | 1161.9 ± 1.3% | 0.688 | 0.943 | 0.985 | 0.985 | 0.986 | 0.221 | 0.987 | 0.410 | 0.694 | 0.104 | 1.014 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.109 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.110 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.087 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.106 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 990.8 ± 2.6% | 1010.2 ± 0.9% | 978.7 ± 1.7% | 260.0 ± 0.9% | 532.0 ± 0.5% | 256.4 ± 2.0% | 0.981 | 1.012 | 3.812 | 1.862 | 3.865 |
| qlog records, JSON text sequence | 1467503 | 840.3 ± 0.4% | 810.4 ± 0.5% | 823.6 ± 0.8% | 223.3 ± 4.0% | 588.5 ± 0.3% | 246.0 ± 4.5% | 1.037 | 1.020 | 3.763 | 1.428 | 3.416 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1335.3 ± 1.8% | 1125.6 ± 0.8% | 894.0 ± 5.5% | 332.3 ± 0.9% | 358.9 ± 3.4% | 311.2 ± 4.3% | 1.186 | 1.494 | 4.018 | 3.721 | 4.291 |
| qlog records, JSON text sequence | 1467503 | 1161.9 ± 1.3% | 872.4 ± 0.3% | 721.9 ± 6.4% | 323.4 ± 6.5% | 391.4 ± 0.6% | 234.1 ± 2.8% | 1.332 | 1.610 | 3.592 | 2.968 | 4.963 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1349.8 ± 3.4% | 1125.6 ± 0.8% | 894.0 ± 5.5% | 332.3 ± 0.9% | 358.9 ± 3.4% | 311.2 ± 4.3% | 1.199 | 1.510 | 4.062 | 3.761 | 4.338 |
| qlog records, JSON text sequence | 1467503 | 1178.2 ± 0.3% | 872.4 ± 0.3% | 721.9 ± 6.4% | 323.4 ± 6.5% | 391.4 ± 0.6% | 234.1 ± 2.8% | 1.351 | 1.632 | 3.643 | 3.010 | 5.033 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 773.7 ± 1.5% | 1010.2 ± 0.9% | 978.7 ± 1.7% | 260.0 ± 0.9% | 532.0 ± 0.5% | 256.4 ± 2.0% | 0.766 | 0.791 | 2.976 | 1.454 | 3.018 |
| qlog records, JSON text sequence | 1467503 | 662.2 ± 5.1% | 810.4 ± 0.5% | 823.6 ± 0.8% | 223.3 ± 4.0% | 588.5 ± 0.3% | 246.0 ± 4.5% | 0.817 | 0.804 | 2.966 | 1.125 | 2.692 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 953.0 ± 1.2% | 1125.6 ± 0.8% | 894.0 ± 5.5% | 332.3 ± 0.9% | 358.9 ± 3.4% | 311.2 ± 4.3% | 0.847 | 1.066 | 2.868 | 2.655 | 3.063 |
| qlog records, JSON text sequence | 1467503 | 806.8 ± 0.4% | 872.4 ± 0.3% | 721.9 ± 6.4% | 323.4 ± 6.5% | 391.4 ± 0.6% | 234.1 ± 2.8% | 0.925 | 1.118 | 2.495 | 2.061 | 3.446 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.766 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.791 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.817 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.804 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.847 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.925 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 998.0 ± 1.6% | 0.482 | 1.068 | 1.103 | 1.095 | 0.431 | 1.086 | 1.098 | 0.370 | 0.806 | 0.099 |
| qlog records, JSON text sequence | 1467503 | 841.5 ± 0.5% | 0.736 | 1.027 | 1.006 | 1.004 | 0.390 | 1.012 | 1.005 | 0.345 | 0.891 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1327.6 ± 0.8% | 0.441 | 0.984 | 0.974 | 1.003 | 1.014 | 0.230 | 1.015 | 0.444 | 0.720 | 0.086 | 1.023 |
| qlog records, JSON text sequence | 1467503 | 1159.6 ± 3.0% | 0.690 | 0.945 | 0.984 | 0.986 | 0.989 | 0.222 | 0.988 | 0.411 | 0.696 | 0.104 | 1.012 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J5 UTF-8 vectors off runs at 1.068 of all on.
- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.103 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.095 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.086 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.098 of all on.

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
| CLDR supplemental, 34 texts | 920675 | 998.0 ± 1.6% | 999.5 ± 0.5% | 987.0 ± 0.3% | 259.9 ± 0.6% | 531.7 ± 0.6% | 255.5 ± 2.7% | 0.999 | 1.011 | 3.840 | 1.877 | 3.907 |
| qlog records, JSON text sequence | 1467503 | 841.5 ± 0.5% | 810.5 ± 0.5% | 823.3 ± 1.3% | 223.5 ± 0.8% | 589.4 ± 4.8% | 248.1 ± 0.4% | 1.038 | 1.022 | 3.766 | 1.428 | 3.392 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1327.6 ± 0.8% | 1133.7 ± 1.0% | 896.7 ± 0.4% | 333.3 ± 0.6% | 362.2 ± 3.3% | 313.1 ± 1.3% | 1.171 | 1.481 | 3.983 | 3.666 | 4.240 |
| qlog records, JSON text sequence | 1467503 | 1159.6 ± 3.0% | 869.6 ± 0.3% | 729.2 ± 0.4% | 322.9 ± 0.8% | 393.0 ± 0.7% | 233.4 ± 5.0% | 1.333 | 1.590 | 3.592 | 2.951 | 4.969 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1358.6 ± 6.5% | 1133.7 ± 1.0% | 896.7 ± 0.4% | 333.3 ± 0.6% | 362.2 ± 3.3% | 313.1 ± 1.3% | 1.198 | 1.515 | 4.077 | 3.751 | 4.339 |
| qlog records, JSON text sequence | 1467503 | 1173.8 ± 4.3% | 869.6 ± 0.3% | 729.2 ± 0.4% | 322.9 ± 0.8% | 393.0 ± 0.7% | 233.4 ± 5.0% | 1.350 | 1.610 | 3.636 | 2.987 | 5.030 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 804.7 ± 2.9% | 999.5 ± 0.5% | 987.0 ± 0.3% | 259.9 ± 0.6% | 531.7 ± 0.6% | 255.5 ± 2.7% | 0.805 | 0.815 | 3.096 | 1.513 | 3.150 |
| qlog records, JSON text sequence | 1467503 | 749.5 ± 1.2% | 810.5 ± 0.5% | 823.3 ± 1.3% | 223.5 ± 0.8% | 589.4 ± 4.8% | 248.1 ± 0.4% | 0.925 | 0.910 | 3.354 | 1.272 | 3.021 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 956.3 ± 14.4% | 1133.7 ± 1.0% | 896.7 ± 0.4% | 333.3 ± 0.6% | 362.2 ± 3.3% | 313.1 ± 1.3% | 0.844 | 1.066 | 2.869 | 2.641 | 3.054 |
| qlog records, JSON text sequence | 1467503 | 807.4 ± 7.8% | 869.6 ± 0.3% | 729.2 ± 0.4% | 322.9 ± 0.8% | 393.0 ± 0.7% | 233.4 ± 5.0% | 0.929 | 1.107 | 2.501 | 2.055 | 3.460 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.805 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.815 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.925 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.910 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.844 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1044.1 ± 0.3% | 0.473 | 0.982 | 1.033 | 1.029 | 0.403 | 1.004 | 1.009 | 0.354 | 0.780 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 848.9 ± 7.0% | 0.733 | 1.031 | 1.017 | 0.999 | 0.388 | 1.009 | 0.999 | 0.342 | 0.680 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.5 ± 1.3% | 0.442 | 0.980 | 0.977 | 0.998 | 1.000 | 0.234 | 1.003 | 0.446 | 0.721 | 0.086 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1157.1 ± 5.5% | 0.703 | 0.925 | 0.987 | 0.984 | 0.988 | 0.226 | 0.982 | 0.414 | 0.693 | 0.104 | 1.000 |

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
| CLDR supplemental, 34 texts | 920675 | 1044.1 ± 0.3% | 988.3 ± 1.1% | 989.7 ± 0.6% | 259.5 ± 0.9% | 530.4 ± 1.1% | 258.1 ± 8.6% | 1.056 | 1.055 | 4.023 | 1.968 | 4.046 |
| qlog records, JSON text sequence | 1467503 | 848.9 ± 7.0% | 810.0 ± 0.4% | 821.6 ± 4.5% | 216.4 ± 2.7% | 586.8 ± 0.4% | 244.6 ± 1.6% | 1.048 | 1.033 | 3.923 | 1.447 | 3.471 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1333.5 ± 1.3% | 1139.9 ± 0.8% | 897.6 ± 0.5% | 320.4 ± 4.2% | 360.4 ± 0.8% | 312.5 ± 3.5% | 1.170 | 1.486 | 4.162 | 3.701 | 4.268 |
| qlog records, JSON text sequence | 1467503 | 1157.1 ± 5.5% | 866.0 ± 7.4% | 710.8 ± 1.2% | 318.0 ± 0.4% | 392.4 ± 0.6% | 233.1 ± 2.1% | 1.336 | 1.628 | 3.639 | 2.949 | 4.965 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1363.1 ± 4.5% | 1139.9 ± 0.8% | 897.6 ± 0.5% | 320.4 ± 4.2% | 360.4 ± 0.8% | 312.5 ± 3.5% | 1.196 | 1.519 | 4.254 | 3.783 | 4.362 |
| qlog records, JSON text sequence | 1467503 | 1157.2 ± 5.5% | 866.0 ± 7.4% | 710.8 ± 1.2% | 318.0 ± 0.4% | 392.4 ± 0.6% | 233.1 ± 2.1% | 1.336 | 1.628 | 3.639 | 2.949 | 4.965 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 814.9 ± 3.3% | 988.3 ± 1.1% | 989.7 ± 0.6% | 259.5 ± 0.9% | 530.4 ± 1.1% | 258.1 ± 8.6% | 0.825 | 0.823 | 3.140 | 1.536 | 3.158 |
| qlog records, JSON text sequence | 1467503 | 577.6 ± 5.2% | 810.0 ± 0.4% | 821.6 ± 4.5% | 216.4 ± 2.7% | 586.8 ± 0.4% | 244.6 ± 1.6% | 0.713 | 0.703 | 2.669 | 0.984 | 2.362 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.3 ± 0.9% | 1139.9 ± 0.8% | 897.6 ± 0.5% | 320.4 ± 4.2% | 360.4 ± 0.8% | 312.5 ± 3.5% | 0.843 | 1.071 | 3.000 | 2.668 | 3.076 |
| qlog records, JSON text sequence | 1467503 | 801.7 ± 1.1% | 866.0 ± 7.4% | 710.8 ± 1.2% | 318.0 ± 0.4% | 392.4 ± 0.6% | 233.1 ± 2.1% | 0.926 | 1.128 | 2.521 | 2.043 | 3.440 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.825 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.823 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.713 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.703 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.843 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.926 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1013.3 ± 4.8% | 0.474 | 1.031 | 1.086 | 1.083 | 0.425 | 1.075 | 1.082 | 0.365 | 0.770 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 840.0 ± 0.6% | 0.738 | 1.027 | 1.010 | 1.006 | 0.391 | 1.013 | 1.007 | 0.346 | 0.790 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.2 ± 0.6% | 0.438 | 0.976 | 0.973 | 1.001 | 1.012 | 0.228 | 1.011 | 0.439 | 0.717 | 0.086 | 1.022 |
| qlog records, JSON text sequence | 1467503 | 1162.2 ± 0.4% | 0.688 | 0.940 | 0.983 | 0.985 | 0.987 | 0.220 | 0.987 | 0.408 | 0.696 | 0.103 | 1.015 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.086 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.083 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.075 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 1013.3 ± 4.8% | 1015.8 ± 0.3% | 986.1 ± 0.5% | 259.6 ± 1.1% | 530.5 ± 0.7% | 253.9 ± 5.5% | 0.997 | 1.028 | 3.903 | 1.910 | 3.991 |
| qlog records, JSON text sequence | 1467503 | 840.0 ± 0.6% | 810.5 ± 0.1% | 825.4 ± 6.3% | 223.5 ± 0.6% | 588.2 ± 0.4% | 247.1 ± 2.1% | 1.036 | 1.018 | 3.757 | 1.428 | 3.399 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1336.2 ± 0.6% | 1135.0 ± 0.6% | 895.1 ± 0.8% | 332.8 ± 0.3% | 359.9 ± 2.3% | 312.4 ± 1.0% | 1.177 | 1.493 | 4.015 | 3.713 | 4.277 |
| qlog records, JSON text sequence | 1467503 | 1162.2 ± 0.4% | 869.0 ± 0.7% | 727.1 ± 0.5% | 323.1 ± 0.5% | 389.1 ± 6.7% | 233.5 ± 0.9% | 1.337 | 1.598 | 3.598 | 2.987 | 4.978 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1365.1 ± 0.5% | 1135.0 ± 0.6% | 895.1 ± 0.8% | 332.8 ± 0.3% | 359.9 ± 2.3% | 312.4 ± 1.0% | 1.203 | 1.525 | 4.102 | 3.793 | 4.369 |
| qlog records, JSON text sequence | 1467503 | 1179.1 ± 0.6% | 869.0 ± 0.7% | 727.1 ± 0.5% | 323.1 ± 0.5% | 389.1 ± 6.7% | 233.5 ± 0.9% | 1.357 | 1.622 | 3.650 | 3.030 | 5.050 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 780.6 ± 2.0% | 1015.8 ± 0.3% | 986.1 ± 0.5% | 259.6 ± 1.1% | 530.5 ± 0.7% | 253.9 ± 5.5% | 0.768 | 0.792 | 3.006 | 1.471 | 3.074 |
| qlog records, JSON text sequence | 1467503 | 663.9 ± 7.0% | 810.5 ± 0.1% | 825.4 ± 6.3% | 223.5 ± 0.6% | 588.2 ± 0.4% | 247.1 ± 2.1% | 0.819 | 0.804 | 2.970 | 1.129 | 2.687 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 958.3 ± 2.4% | 1135.0 ± 0.6% | 895.1 ± 0.8% | 332.8 ± 0.3% | 359.9 ± 2.3% | 312.4 ± 1.0% | 0.844 | 1.071 | 2.879 | 2.663 | 3.067 |
| qlog records, JSON text sequence | 1467503 | 808.8 ± 0.5% | 869.0 ± 0.7% | 727.1 ± 0.5% | 323.1 ± 0.5% | 389.1 ± 6.7% | 233.5 ± 0.9% | 0.931 | 1.112 | 2.504 | 2.078 | 3.464 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.768 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.792 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.819 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.804 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.844 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.931 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 7763 64-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1007.5 ± 6.3% | 0.477 | 1.005 | 1.086 | 1.085 | 0.427 | 1.076 | 1.083 | 0.367 | 0.798 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 839.8 ± 0.2% | 0.737 | 1.028 | 1.009 | 1.008 | 0.391 | 1.013 | 1.007 | 0.346 | 0.892 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1329.2 ± 0.8% | 0.440 | 0.981 | 0.975 | 1.002 | 1.009 | 0.230 | 1.016 | 0.444 | 0.723 | 0.086 | 1.025 |
| qlog records, JSON text sequence | 1467503 | 1151.9 ± 5.2% | 0.695 | 0.951 | 0.980 | 0.981 | 0.984 | 0.222 | 0.984 | 0.414 | 0.701 | 0.105 | 1.019 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.086 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.085 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.076 of all on.
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
| CLDR supplemental, 34 texts | 920675 | 1007.5 ± 6.3% | 1006.3 ± 2.4% | 980.8 ± 2.7% | 258.6 ± 1.4% | 531.9 ± 0.7% | 252.8 ± 2.5% | 1.001 | 1.027 | 3.896 | 1.894 | 3.985 |
| qlog records, JSON text sequence | 1467503 | 839.8 ± 0.2% | 812.3 ± 4.9% | 824.1 ± 4.2% | 222.9 ± 0.6% | 589.5 ± 4.7% | 246.3 ± 2.0% | 1.034 | 1.019 | 3.767 | 1.424 | 3.410 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1329.2 ± 0.8% | 1130.3 ± 1.0% | 898.2 ± 0.7% | 333.3 ± 4.6% | 359.8 ± 2.5% | 312.4 ± 0.7% | 1.176 | 1.480 | 3.987 | 3.694 | 4.255 |
| qlog records, JSON text sequence | 1467503 | 1151.9 ± 5.2% | 867.8 ± 6.4% | 727.7 ± 0.4% | 323.2 ± 0.5% | 392.7 ± 0.5% | 233.1 ± 1.5% | 1.327 | 1.583 | 3.564 | 2.933 | 4.942 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1362.5 ± 0.7% | 1130.3 ± 1.0% | 898.2 ± 0.7% | 333.3 ± 4.6% | 359.8 ± 2.5% | 312.4 ± 0.7% | 1.205 | 1.517 | 4.087 | 3.787 | 4.362 |
| qlog records, JSON text sequence | 1467503 | 1173.8 ± 5.0% | 867.8 ± 6.4% | 727.7 ± 0.4% | 323.2 ± 0.5% | 392.7 ± 0.5% | 233.1 ± 1.5% | 1.353 | 1.613 | 3.632 | 2.989 | 5.036 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 803.6 ± 2.7% | 1006.3 ± 2.4% | 980.8 ± 2.7% | 258.6 ± 1.4% | 531.9 ± 0.7% | 252.8 ± 2.5% | 0.799 | 0.819 | 3.108 | 1.511 | 3.179 |
| qlog records, JSON text sequence | 1467503 | 749.2 ± 0.9% | 812.3 ± 4.9% | 824.1 ± 4.2% | 222.9 ± 0.6% | 589.5 ± 4.7% | 246.3 ± 2.0% | 0.922 | 0.909 | 3.361 | 1.271 | 3.042 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 960.4 ± 0.4% | 1130.3 ± 1.0% | 898.2 ± 0.7% | 333.3 ± 4.6% | 359.8 ± 2.5% | 312.4 ± 0.7% | 0.850 | 1.069 | 2.881 | 2.669 | 3.075 |
| qlog records, JSON text sequence | 1467503 | 807.4 ± 0.9% | 867.8 ± 6.4% | 727.7 ± 0.4% | 323.2 ± 0.5% | 392.7 ± 0.5% | 233.1 ± 1.5% | 0.930 | 1.110 | 2.498 | 2.056 | 3.464 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.799 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.819 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.922 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.909 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.850 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.930 of simdjson.
