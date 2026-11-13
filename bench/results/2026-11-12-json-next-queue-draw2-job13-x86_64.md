# bench-json, CLDR and qlog alone: base, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1617.7 ± 5.5% | 0.519 | 0.973 | 1.018 | 0.970 | 0.399 | 1.013 | 0.993 | 0.389 | 0.841 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 1298.7 ± 12.3% | 0.928 | 1.028 | 1.049 | 1.040 | 0.395 | 1.036 | 1.044 | 0.378 | 0.717 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2297.8 ± 3.1% | 0.446 | 0.954 | 0.977 | 1.012 | 0.986 | 0.260 | 1.008 | 0.471 | 0.748 | 0.083 | 0.998 |
| qlog records, JSON text sequence | 1467503 | 2049.1 ± 1.8% | 0.718 | 0.919 | 0.981 | 0.996 | 0.981 | 0.249 | 0.986 | 0.428 | 0.712 | 0.100 | 0.997 |

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
| CLDR supplemental, 34 texts | 920675 | 1617.7 ± 5.5% | 2007.6 ± 10.3% | 1616.9 ± 4.7% | 528.1 ± 1.2% | 816.4 ± 3.4% | 473.9 ± 3.4% | 0.806 | 1.000 | 3.063 | 1.982 | 3.414 |
| qlog records, JSON text sequence | 1467503 | 1298.7 ± 12.3% | 1496.1 ± 12.4% | 1507.1 ± 3.1% | 433.8 ± 5.1% | 934.2 ± 24.6% | 466.6 ± 42.3% | 0.868 | 0.862 | 2.994 | 1.390 | 2.783 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2297.8 ± 3.1% | 2329.2 ± 6.1% | 1480.7 ± 3.7% | 603.0 ± 5.7% | 619.5 ± 2.7% | 582.0 ± 3.9% | 0.987 | 1.552 | 3.810 | 3.709 | 3.948 |
| qlog records, JSON text sequence | 1467503 | 2049.1 ± 1.8% | 1890.8 ± 2.3% | 1210.8 ± 2.7% | 576.8 ± 3.2% | 702.3 ± 2.7% | 491.8 ± 5.0% | 1.084 | 1.692 | 3.553 | 2.918 | 4.166 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2294.4 ± 5.0% | 2329.2 ± 6.1% | 1480.7 ± 3.7% | 603.0 ± 5.7% | 619.5 ± 2.7% | 582.0 ± 3.9% | 0.985 | 1.550 | 3.805 | 3.704 | 3.942 |
| qlog records, JSON text sequence | 1467503 | 2043.8 ± 41.9% | 1890.8 ± 2.3% | 1210.8 ± 2.7% | 576.8 ± 3.2% | 702.3 ± 2.7% | 491.8 ± 5.0% | 1.081 | 1.688 | 3.544 | 2.910 | 4.156 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1360.4 ± 1.6% | 2007.6 ± 10.3% | 1616.9 ± 4.7% | 528.1 ± 1.2% | 816.4 ± 3.4% | 473.9 ± 3.4% | 0.678 | 0.841 | 2.576 | 1.666 | 2.871 |
| qlog records, JSON text sequence | 1467503 | 931.1 ± 18.2% | 1496.1 ± 12.4% | 1507.1 ± 3.1% | 433.8 ± 5.1% | 934.2 ± 24.6% | 466.6 ± 42.3% | 0.622 | 0.618 | 2.146 | 0.997 | 1.995 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1719.9 ± 6.6% | 2329.2 ± 6.1% | 1480.7 ± 3.7% | 603.0 ± 5.7% | 619.5 ± 2.7% | 582.0 ± 3.9% | 0.738 | 1.162 | 2.852 | 2.776 | 2.955 |
| qlog records, JSON text sequence | 1467503 | 1459.5 ± 2.6% | 1890.8 ± 2.3% | 1210.8 ± 2.7% | 576.8 ± 3.2% | 702.3 ± 2.7% | 491.8 ± 5.0% | 0.772 | 1.205 | 2.531 | 2.078 | 2.968 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.806 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.868 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.862 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.678 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.841 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.622 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.618 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.738 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.772 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1630.6 ± 3.9% | 0.520 | 0.970 | 0.996 | 1.001 | 0.398 | 1.014 | 1.014 | 0.387 | 0.848 | 0.094 |
| qlog records, JSON text sequence | 1467503 | 1336.2 ± 5.1% | 0.870 | 1.017 | 0.984 | 0.973 | 0.377 | 0.971 | 0.974 | 0.367 | 0.850 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2299.9 ± 2.4% | 0.450 | 0.951 | 0.967 | 1.005 | 1.001 | 0.267 | 1.007 | 0.471 | 0.736 | 0.081 | 0.998 |
| qlog records, JSON text sequence | 1467503 | 2009.1 ± 2.2% | 0.720 | 0.905 | 0.984 | 0.986 | 0.979 | 0.260 | 0.984 | 0.428 | 0.711 | 0.100 | 0.991 |

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
| CLDR supplemental, 34 texts | 920675 | 1630.6 ± 3.9% | 2069.5 ± 2.0% | 1671.9 ± 3.4% | 526.6 ± 2.6% | 743.8 ± 3.4% | 468.3 ± 2.3% | 0.788 | 0.975 | 3.097 | 2.192 | 3.482 |
| qlog records, JSON text sequence | 1467503 | 1336.2 ± 5.1% | 1576.6 ± 5.8% | 1493.7 ± 3.8% | 439.4 ± 6.7% | 922.4 ± 50.0% | 463.1 ± 13.7% | 0.848 | 0.895 | 3.041 | 1.448 | 2.885 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2299.9 ± 2.4% | 2263.1 ± 3.3% | 1466.0 ± 7.7% | 608.2 ± 3.9% | 540.2 ± 3.8% | 589.7 ± 5.8% | 1.016 | 1.569 | 3.781 | 4.258 | 3.900 |
| qlog records, JSON text sequence | 1467503 | 2009.1 ± 2.2% | 1873.5 ± 2.9% | 1193.7 ± 9.6% | 575.6 ± 4.2% | 683.6 ± 3.8% | 484.0 ± 1.4% | 1.072 | 1.683 | 3.491 | 2.939 | 4.151 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2294.7 ± 3.2% | 2263.1 ± 3.3% | 1466.0 ± 7.7% | 608.2 ± 3.9% | 540.2 ± 3.8% | 589.7 ± 5.8% | 1.014 | 1.565 | 3.773 | 4.248 | 3.891 |
| qlog records, JSON text sequence | 1467503 | 1990.3 ± 5.8% | 1873.5 ± 2.9% | 1193.7 ± 9.6% | 575.6 ± 4.2% | 683.6 ± 3.8% | 484.0 ± 1.4% | 1.062 | 1.667 | 3.458 | 2.912 | 4.112 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1382.2 ± 3.2% | 2069.5 ± 2.0% | 1671.9 ± 3.4% | 526.6 ± 2.6% | 743.8 ± 3.4% | 468.3 ± 2.3% | 0.668 | 0.827 | 2.625 | 1.858 | 2.952 |
| qlog records, JSON text sequence | 1467503 | 1135.5 ± 4.6% | 1576.6 ± 5.8% | 1493.7 ± 3.8% | 439.4 ± 6.7% | 922.4 ± 50.0% | 463.1 ± 13.7% | 0.720 | 0.760 | 2.584 | 1.231 | 2.452 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1693.4 ± 2.5% | 2263.1 ± 3.3% | 1466.0 ± 7.7% | 608.2 ± 3.9% | 540.2 ± 3.8% | 589.7 ± 5.8% | 0.748 | 1.155 | 2.784 | 3.135 | 2.871 |
| qlog records, JSON text sequence | 1467503 | 1429.2 ± 4.3% | 1873.5 ± 2.9% | 1193.7 ± 9.6% | 575.6 ± 4.2% | 683.6 ± 3.8% | 484.0 ± 1.4% | 0.763 | 1.197 | 2.483 | 2.091 | 2.953 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.788 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.848 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.895 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.668 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.827 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.720 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.760 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.748 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.763 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1569.1 ± 9.5% | 0.533 | 0.993 | 1.027 | 1.031 | 0.402 | 1.029 | 1.033 | 0.398 | 0.825 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1273.6 ± 3.1% | 0.890 | 1.029 | 1.001 | 0.990 | 0.359 | 0.996 | 0.990 | 0.339 | 0.836 | 0.114 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2292.3 ± 0.7% | 0.447 | 0.950 | 0.967 | 1.000 | 1.006 | 0.266 | 1.000 | 0.467 | 0.730 | 0.085 | 0.997 |
| qlog records, JSON text sequence | 1467503 | 2029.8 ± 4.8% | 0.714 | 0.902 | 1.011 | 0.998 | 0.986 | 0.257 | 0.986 | 0.430 | 0.717 | 0.099 | 0.993 |

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
| CLDR supplemental, 34 texts | 920675 | 1569.1 ± 9.5% | 1987.7 ± 2.6% | 1580.5 ± 7.3% | 520.0 ± 4.2% | 722.5 ± 4.4% | 457.1 ± 2.2% | 0.789 | 0.993 | 3.017 | 2.172 | 3.432 |
| qlog records, JSON text sequence | 1467503 | 1273.6 ± 3.1% | 1513.4 ± 7.9% | 1504.1 ± 1.8% | 437.3 ± 2.9% | 900.7 ± 10.7% | 455.3 ± 4.9% | 0.842 | 0.847 | 2.913 | 1.414 | 2.797 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2292.3 ± 0.7% | 2240.0 ± 10.2% | 1463.7 ± 3.7% | 603.5 ± 4.9% | 534.2 ± 4.3% | 569.2 ± 2.2% | 1.023 | 1.566 | 3.798 | 4.291 | 4.028 |
| qlog records, JSON text sequence | 1467503 | 2029.8 ± 4.8% | 1859.7 ± 12.0% | 1195.1 ± 12.4% | 580.2 ± 4.4% | 692.6 ± 1.6% | 474.5 ± 2.8% | 1.091 | 1.699 | 3.499 | 2.931 | 4.278 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2285.0 ± 12.3% | 2240.0 ± 10.2% | 1463.7 ± 3.7% | 603.5 ± 4.9% | 534.2 ± 4.3% | 569.2 ± 2.2% | 1.020 | 1.561 | 3.786 | 4.277 | 4.015 |
| qlog records, JSON text sequence | 1467503 | 2015.1 ± 6.0% | 1859.7 ± 12.0% | 1195.1 ± 12.4% | 580.2 ± 4.4% | 692.6 ± 1.6% | 474.5 ± 2.8% | 1.084 | 1.686 | 3.473 | 2.910 | 4.247 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1294.2 ± 2.3% | 1987.7 ± 2.6% | 1580.5 ± 7.3% | 520.0 ± 4.2% | 722.5 ± 4.4% | 457.1 ± 2.2% | 0.651 | 0.819 | 2.489 | 1.791 | 2.831 |
| qlog records, JSON text sequence | 1467503 | 1065.3 ± 7.6% | 1513.4 ± 7.9% | 1504.1 ± 1.8% | 437.3 ± 2.9% | 900.7 ± 10.7% | 455.3 ± 4.9% | 0.704 | 0.708 | 2.436 | 1.183 | 2.340 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1672.9 ± 33.6% | 2240.0 ± 10.2% | 1463.7 ± 3.7% | 603.5 ± 4.9% | 534.2 ± 4.3% | 569.2 ± 2.2% | 0.747 | 1.143 | 2.772 | 3.131 | 2.939 |
| qlog records, JSON text sequence | 1467503 | 1456.1 ± 4.9% | 1859.7 ± 12.0% | 1195.1 ± 12.4% | 580.2 ± 4.4% | 692.6 ± 1.6% | 474.5 ± 2.8% | 0.783 | 1.218 | 2.510 | 2.103 | 3.069 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.789 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.842 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.847 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.651 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.819 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.704 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.708 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.783 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1600.9 ± 2.7% | 0.527 | 0.982 | 1.005 | 1.013 | 0.394 | 0.995 | 1.012 | 0.392 | 0.769 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 1353.4 ± 4.0% | 0.868 | 0.995 | 0.964 | 0.886 | 0.368 | 0.954 | 0.953 | 0.361 | 0.805 | 0.107 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2353.4 ± 35.9% | 0.440 | 0.933 | 0.952 | 0.981 | 0.979 | 0.266 | 1.001 | 0.465 | 0.733 | 0.086 | 0.983 |
| qlog records, JSON text sequence | 1467503 | 2075.0 ± 4.4% | 0.715 | 0.905 | 0.984 | 0.994 | 0.991 | 0.262 | 0.983 | 0.427 | 0.718 | 0.105 | 1.004 |

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
| CLDR supplemental, 34 texts | 920675 | 1600.9 ± 2.7% | 2056.8 ± 35.3% | 1626.6 ± 7.0% | 520.4 ± 3.0% | 731.7 ± 6.6% | 465.0 ± 11.6% | 0.778 | 0.984 | 3.076 | 2.188 | 3.443 |
| qlog records, JSON text sequence | 1467503 | 1353.4 ± 4.0% | 1587.7 ± 4.4% | 1565.5 ± 4.5% | 447.9 ± 2.1% | 907.8 ± 1.3% | 469.1 ± 1.3% | 0.852 | 0.864 | 3.022 | 1.491 | 2.885 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2353.4 ± 35.9% | 2294.8 ± 1.9% | 1476.9 ± 6.0% | 610.3 ± 12.3% | 552.1 ± 3.4% | 594.5 ± 2.2% | 1.026 | 1.593 | 3.856 | 4.263 | 3.959 |
| qlog records, JSON text sequence | 1467503 | 2075.0 ± 4.4% | 1922.3 ± 1.4% | 1235.6 ± 1.9% | 592.3 ± 6.2% | 709.4 ± 5.2% | 491.7 ± 3.3% | 1.079 | 1.679 | 3.503 | 2.925 | 4.220 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2312.6 ± 2.2% | 2294.8 ± 1.9% | 1476.9 ± 6.0% | 610.3 ± 12.3% | 552.1 ± 3.4% | 594.5 ± 2.2% | 1.008 | 1.566 | 3.790 | 4.189 | 3.890 |
| qlog records, JSON text sequence | 1467503 | 2084.3 ± 2.6% | 1922.3 ± 1.4% | 1235.6 ± 1.9% | 592.3 ± 6.2% | 709.4 ± 5.2% | 491.7 ± 3.3% | 1.084 | 1.687 | 3.519 | 2.938 | 4.239 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1231.5 ± 5.5% | 2056.8 ± 35.3% | 1626.6 ± 7.0% | 520.4 ± 3.0% | 731.7 ± 6.6% | 465.0 ± 11.6% | 0.599 | 0.757 | 2.366 | 1.683 | 2.648 |
| qlog records, JSON text sequence | 1467503 | 1089.1 ± 3.0% | 1587.7 ± 4.4% | 1565.5 ± 4.5% | 447.9 ± 2.1% | 907.8 ± 1.3% | 469.1 ± 1.3% | 0.686 | 0.696 | 2.431 | 1.200 | 2.322 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1726.0 ± 4.8% | 2294.8 ± 1.9% | 1476.9 ± 6.0% | 610.3 ± 12.3% | 552.1 ± 3.4% | 594.5 ± 2.2% | 0.752 | 1.169 | 2.828 | 3.126 | 2.903 |
| qlog records, JSON text sequence | 1467503 | 1489.9 ± 2.5% | 1922.3 ± 1.4% | 1235.6 ± 1.9% | 592.3 ± 6.2% | 709.4 ± 5.2% | 491.7 ± 3.3% | 0.775 | 1.206 | 2.516 | 2.100 | 3.030 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.852 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.864 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.599 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.757 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.686 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.696 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.752 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.775 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 1

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1608.5 ± 22.9% | 0.538 | 0.991 | 1.024 | 1.022 | 0.398 | 1.032 | 1.012 | 0.399 | 0.782 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1322.2 ± 5.4% | 0.877 | 1.021 | 0.989 | 0.981 | 0.384 | 0.990 | 0.987 | 0.378 | 0.833 | 0.115 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2400.5 ± 4.2% | 0.441 | 0.930 | 0.947 | 0.993 | 0.996 | 0.257 | 0.991 | 0.466 | 0.721 | 0.084 | 0.970 |
| qlog records, JSON text sequence | 1467503 | 2045.2 ± 6.7% | 0.723 | 0.920 | 0.988 | 1.002 | 0.993 | 0.258 | 0.995 | 0.433 | 0.728 | 0.103 | 1.005 |

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
| CLDR supplemental, 34 texts | 920675 | 1608.5 ± 22.9% | 2044.5 ± 4.4% | 1626.6 ± 2.7% | 528.9 ± 2.9% | 740.7 ± 3.1% | 466.3 ± 5.3% | 0.787 | 0.989 | 3.041 | 2.172 | 3.449 |
| qlog records, JSON text sequence | 1467503 | 1322.2 ± 5.4% | 1534.9 ± 3.7% | 1495.5 ± 12.9% | 449.6 ± 5.5% | 911.2 ± 4.2% | 473.5 ± 6.2% | 0.861 | 0.884 | 2.941 | 1.451 | 2.792 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2400.5 ± 4.2% | 2305.8 ± 6.6% | 1511.8 ± 7.1% | 616.8 ± 7.2% | 561.1 ± 5.9% | 596.5 ± 3.5% | 1.041 | 1.588 | 3.892 | 4.279 | 4.024 |
| qlog records, JSON text sequence | 1467503 | 2045.2 ± 6.7% | 1927.5 ± 6.1% | 1226.5 ± 6.2% | 595.7 ± 6.8% | 703.2 ± 6.6% | 492.9 ± 6.7% | 1.061 | 1.668 | 3.433 | 2.909 | 4.149 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2328.5 ± 3.0% | 2305.8 ± 6.6% | 1511.8 ± 7.1% | 616.8 ± 7.2% | 561.1 ± 5.9% | 596.5 ± 3.5% | 1.010 | 1.540 | 3.775 | 4.150 | 3.903 |
| qlog records, JSON text sequence | 1467503 | 2056.3 ± 9.5% | 1927.5 ± 6.1% | 1226.5 ± 6.2% | 595.7 ± 6.8% | 703.2 ± 6.6% | 492.9 ± 6.7% | 1.067 | 1.677 | 3.452 | 2.924 | 4.172 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1257.4 ± 18.7% | 2044.5 ± 4.4% | 1626.6 ± 2.7% | 528.9 ± 2.9% | 740.7 ± 3.1% | 466.3 ± 5.3% | 0.615 | 0.773 | 2.377 | 1.697 | 2.697 |
| qlog records, JSON text sequence | 1467503 | 1100.9 ± 5.6% | 1534.9 ± 3.7% | 1495.5 ± 12.9% | 449.6 ± 5.5% | 911.2 ± 4.2% | 473.5 ± 6.2% | 0.717 | 0.736 | 2.449 | 1.208 | 2.325 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1731.0 ± 6.2% | 2305.8 ± 6.6% | 1511.8 ± 7.1% | 616.8 ± 7.2% | 561.1 ± 5.9% | 596.5 ± 3.5% | 0.751 | 1.145 | 2.807 | 3.085 | 2.902 |
| qlog records, JSON text sequence | 1467503 | 1489.8 ± 3.0% | 1927.5 ± 6.1% | 1226.5 ± 6.2% | 595.7 ± 6.8% | 703.2 ± 6.6% | 492.9 ± 6.7% | 0.773 | 1.215 | 2.501 | 2.119 | 3.023 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.861 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.615 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.773 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.717 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.736 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.751 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.773 of simdjson.

# bench-json, CLDR and qlog alone: base, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1665.5 ± 5.3% | 0.541 | 0.985 | 1.033 | 0.996 | 0.409 | 1.015 | 0.988 | 0.393 | 0.842 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1360.8 ± 7.5% | 0.921 | 0.994 | 1.034 | 1.011 | 0.394 | 1.018 | 1.030 | 0.376 | 0.718 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2384.3 ± 12.0% | 0.446 | 0.943 | 0.962 | 0.996 | 0.973 | 0.265 | 0.997 | 0.463 | 0.721 | 0.082 | 0.991 |
| qlog records, JSON text sequence | 1467503 | 2054.5 ± 0.9% | 0.717 | 0.908 | 0.966 | 0.985 | 0.994 | 0.252 | 0.974 | 0.423 | 0.714 | 0.100 | 0.971 |

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
| CLDR supplemental, 34 texts | 920675 | 1665.5 ± 5.3% | 2112.7 ± 3.8% | 1695.5 ± 4.2% | 555.0 ± 3.1% | 863.3 ± 4.6% | 489.7 ± 8.6% | 0.788 | 0.982 | 3.001 | 1.929 | 3.401 |
| qlog records, JSON text sequence | 1467503 | 1360.8 ± 7.5% | 1634.2 ± 5.9% | 1618.3 ± 3.2% | 461.1 ± 7.0% | 972.6 ± 2.8% | 476.8 ± 7.2% | 0.833 | 0.841 | 2.951 | 1.399 | 2.854 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2384.3 ± 12.0% | 2298.2 ± 36.5% | 1516.4 ± 4.6% | 597.2 ± 9.7% | 643.2 ± 2.0% | 599.8 ± 4.2% | 1.037 | 1.572 | 3.992 | 3.707 | 3.975 |
| qlog records, JSON text sequence | 1467503 | 2054.5 ± 0.9% | 1874.5 ± 15.1% | 1195.8 ± 3.0% | 573.1 ± 4.9% | 699.2 ± 2.8% | 486.0 ± 6.5% | 1.096 | 1.718 | 3.585 | 2.938 | 4.227 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2362.4 ± 18.4% | 2298.2 ± 36.5% | 1516.4 ± 4.6% | 597.2 ± 9.7% | 643.2 ± 2.0% | 599.8 ± 4.2% | 1.028 | 1.558 | 3.956 | 3.673 | 3.939 |
| qlog records, JSON text sequence | 1467503 | 1995.3 ± 9.0% | 1874.5 ± 15.1% | 1195.8 ± 3.0% | 573.1 ± 4.9% | 699.2 ± 2.8% | 486.0 ± 6.5% | 1.064 | 1.669 | 3.482 | 2.854 | 4.106 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1403.1 ± 4.0% | 2112.7 ± 3.8% | 1695.5 ± 4.2% | 555.0 ± 3.1% | 863.3 ± 4.6% | 489.7 ± 8.6% | 0.664 | 0.828 | 2.528 | 1.625 | 2.865 |
| qlog records, JSON text sequence | 1467503 | 977.6 ± 9.6% | 1634.2 ± 5.9% | 1618.3 ± 3.2% | 461.1 ± 7.0% | 972.6 ± 2.8% | 476.8 ± 7.2% | 0.598 | 0.604 | 2.120 | 1.005 | 2.050 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1719.1 ± 58.7% | 2298.2 ± 36.5% | 1516.4 ± 4.6% | 597.2 ± 9.7% | 643.2 ± 2.0% | 599.8 ± 4.2% | 0.748 | 1.134 | 2.879 | 2.673 | 2.866 |
| qlog records, JSON text sequence | 1467503 | 1467.7 ± 3.4% | 1874.5 ± 15.1% | 1195.8 ± 3.0% | 573.1 ± 4.9% | 699.2 ± 2.8% | 486.0 ± 6.5% | 0.783 | 1.227 | 2.561 | 2.099 | 3.020 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.788 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.833 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.841 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.664 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.828 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.598 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.604 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.783 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1590.9 ± 4.1% | 0.531 | 0.994 | 1.042 | 1.046 | 0.405 | 1.039 | 1.040 | 0.396 | 0.846 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 1316.3 ± 7.2% | 0.850 | 1.002 | 0.982 | 0.975 | 0.380 | 0.978 | 0.989 | 0.366 | 0.855 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2290.8 ± 10.6% | 0.449 | 0.952 | 0.973 | 0.989 | 0.996 | 0.273 | 0.995 | 0.472 | 0.746 | 0.082 | 0.995 |
| qlog records, JSON text sequence | 1467503 | 1995.2 ± 2.7% | 0.719 | 0.918 | 1.000 | 0.999 | 0.992 | 0.262 | 0.997 | 0.439 | 0.731 | 0.102 | 1.010 |

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
| CLDR supplemental, 34 texts | 920675 | 1590.9 ± 4.1% | 2055.2 ± 4.9% | 1653.0 ± 4.4% | 524.3 ± 4.8% | 742.2 ± 3.0% | 466.2 ± 3.5% | 0.774 | 0.962 | 3.035 | 2.144 | 3.413 |
| qlog records, JSON text sequence | 1467503 | 1316.3 ± 7.2% | 1418.0 ± 7.4% | 1490.2 ± 20.0% | 444.4 ± 13.9% | 909.7 ± 17.4% | 462.8 ± 9.1% | 0.928 | 0.883 | 2.962 | 1.447 | 2.844 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2290.8 ± 10.6% | 2292.1 ± 15.1% | 1475.8 ± 47.8% | 605.0 ± 52.2% | 540.2 ± 2.7% | 574.4 ± 5.5% | 0.999 | 1.552 | 3.786 | 4.241 | 3.988 |
| qlog records, JSON text sequence | 1467503 | 1995.2 ± 2.7% | 1902.0 ± 3.5% | 1199.9 ± 2.6% | 580.5 ± 2.4% | 684.0 ± 11.9% | 467.1 ± 15.3% | 1.049 | 1.663 | 3.437 | 2.917 | 4.272 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2279.5 ± 10.7% | 2292.1 ± 15.1% | 1475.8 ± 47.8% | 605.0 ± 52.2% | 540.2 ± 2.7% | 574.4 ± 5.5% | 0.994 | 1.545 | 3.767 | 4.220 | 3.969 |
| qlog records, JSON text sequence | 1467503 | 2015.0 ± 91.4% | 1902.0 ± 3.5% | 1199.9 ± 2.6% | 580.5 ± 2.4% | 684.0 ± 11.9% | 467.1 ± 15.3% | 1.059 | 1.679 | 3.471 | 2.946 | 4.314 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1345.2 ± 6.0% | 2055.2 ± 4.9% | 1653.0 ± 4.4% | 524.3 ± 4.8% | 742.2 ± 3.0% | 466.2 ± 3.5% | 0.655 | 0.814 | 2.566 | 1.812 | 2.885 |
| qlog records, JSON text sequence | 1467503 | 1125.6 ± 7.9% | 1418.0 ± 7.4% | 1490.2 ± 20.0% | 444.4 ± 13.9% | 909.7 ± 17.4% | 462.8 ± 9.1% | 0.794 | 0.755 | 2.533 | 1.237 | 2.432 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1709.5 ± 3.3% | 2292.1 ± 15.1% | 1475.8 ± 47.8% | 605.0 ± 52.2% | 540.2 ± 2.7% | 574.4 ± 5.5% | 0.746 | 1.158 | 2.825 | 3.165 | 2.976 |
| qlog records, JSON text sequence | 1467503 | 1459.4 ± 3.2% | 1902.0 ± 3.5% | 1199.9 ± 2.6% | 580.5 ± 2.4% | 684.0 ± 11.9% | 467.1 ± 15.3% | 0.767 | 1.216 | 2.514 | 2.134 | 3.125 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.774 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.655 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.814 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.794 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.755 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.746 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.767 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1579.6 ± 3.4% | 0.538 | 1.008 | 1.037 | 1.039 | 0.404 | 1.032 | 1.037 | 0.398 | 0.827 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1320.6 ± 8.9% | 0.882 | 1.020 | 0.988 | 0.983 | 0.359 | 0.989 | 0.985 | 0.370 | 0.848 | 0.113 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2348.4 ± 5.5% | 0.447 | 0.947 | 0.966 | 1.002 | 1.008 | 0.267 | 1.006 | 0.462 | 0.724 | 0.085 | 0.992 |
| qlog records, JSON text sequence | 1467503 | 2129.8 ± 6.6% | 0.725 | 0.921 | 1.002 | 0.993 | 1.000 | 0.254 | 0.989 | 0.423 | 0.722 | 0.100 | 1.012 |

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
| CLDR supplemental, 34 texts | 920675 | 1579.6 ± 3.4% | 2074.7 ± 2.0% | 1649.0 ± 1.4% | 519.7 ± 12.3% | 733.5 ± 13.0% | 465.5 ± 74.6% | 0.761 | 0.958 | 3.040 | 2.154 | 3.394 |
| qlog records, JSON text sequence | 1467503 | 1320.6 ± 8.9% | 1577.8 ± 5.6% | 1580.7 ± 5.2% | 452.5 ± 4.7% | 888.9 ± 8.7% | 468.7 ± 3.3% | 0.837 | 0.835 | 2.919 | 1.486 | 2.818 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2348.4 ± 5.5% | 2324.4 ± 5.8% | 1530.4 ± 5.8% | 615.7 ± 24.7% | 559.3 ± 1.9% | 593.1 ± 2.8% | 1.010 | 1.535 | 3.814 | 4.199 | 3.960 |
| qlog records, JSON text sequence | 1467503 | 2129.8 ± 6.6% | 1952.0 ± 3.7% | 1264.8 ± 4.2% | 617.3 ± 4.2% | 740.9 ± 3.0% | 511.6 ± 3.0% | 1.091 | 1.684 | 3.450 | 2.875 | 4.163 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2328.8 ± 5.5% | 2324.4 ± 5.8% | 1530.4 ± 5.8% | 615.7 ± 24.7% | 559.3 ± 1.9% | 593.1 ± 2.8% | 1.002 | 1.522 | 3.783 | 4.164 | 3.926 |
| qlog records, JSON text sequence | 1467503 | 2154.3 ± 4.9% | 1952.0 ± 3.7% | 1264.8 ± 4.2% | 617.3 ± 4.2% | 740.9 ± 3.0% | 511.6 ± 3.0% | 1.104 | 1.703 | 3.490 | 2.908 | 4.211 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1306.6 ± 4.2% | 2074.7 ± 2.0% | 1649.0 ± 1.4% | 519.7 ± 12.3% | 733.5 ± 13.0% | 465.5 ± 74.6% | 0.630 | 0.792 | 2.514 | 1.781 | 2.807 |
| qlog records, JSON text sequence | 1467503 | 1120.3 ± 12.3% | 1577.8 ± 5.6% | 1580.7 ± 5.2% | 452.5 ± 4.7% | 888.9 ± 8.7% | 468.7 ± 3.3% | 0.710 | 0.709 | 2.476 | 1.260 | 2.390 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1700.9 ± 7.7% | 2324.4 ± 5.8% | 1530.4 ± 5.8% | 615.7 ± 24.7% | 559.3 ± 1.9% | 593.1 ± 2.8% | 0.732 | 1.111 | 2.763 | 3.041 | 2.868 |
| qlog records, JSON text sequence | 1467503 | 1538.0 ± 3.4% | 1952.0 ± 3.7% | 1264.8 ± 4.2% | 617.3 ± 4.2% | 740.9 ± 3.0% | 511.6 ± 3.0% | 0.788 | 1.216 | 2.491 | 2.076 | 3.006 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.761 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.837 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.835 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.630 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.792 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.710 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.709 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.732 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.788 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1660.7 ± 4.8% | 0.527 | 0.969 | 1.012 | 1.012 | 0.392 | 0.993 | 1.003 | 0.388 | 0.769 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1339.1 ± 27.1% | 0.873 | 1.016 | 0.970 | 0.952 | 0.374 | 0.965 | 0.978 | 0.370 | 0.825 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2296.5 ± 7.3% | 0.450 | 0.956 | 0.972 | 1.000 | 1.007 | 0.269 | 1.008 | 0.469 | 0.742 | 0.087 | 0.998 |
| qlog records, JSON text sequence | 1467503 | 2017.5 ± 3.1% | 0.721 | 0.920 | 0.990 | 1.001 | 0.995 | 0.260 | 0.989 | 0.431 | 0.725 | 0.105 | 1.007 |

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
| CLDR supplemental, 34 texts | 920675 | 1660.7 ± 4.8% | 2088.0 ± 6.5% | 1665.2 ± 4.5% | 540.4 ± 4.4% | 746.1 ± 5.2% | 465.3 ± 5.9% | 0.795 | 0.997 | 3.073 | 2.226 | 3.569 |
| qlog records, JSON text sequence | 1467503 | 1339.1 ± 27.1% | 1595.9 ± 3.7% | 1552.3 ± 2.0% | 448.5 ± 3.6% | 919.4 ± 2.9% | 473.7 ± 7.5% | 0.839 | 0.863 | 2.986 | 1.456 | 2.827 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2296.5 ± 7.3% | 2270.5 ± 5.2% | 1470.4 ± 4.2% | 609.8 ± 3.8% | 542.5 ± 4.4% | 593.7 ± 6.3% | 1.011 | 1.562 | 3.766 | 4.233 | 3.868 |
| qlog records, JSON text sequence | 1467503 | 2017.5 ± 3.1% | 1895.9 ± 4.7% | 1196.9 ± 4.2% | 584.3 ± 8.3% | 686.1 ± 4.0% | 482.2 ± 1.3% | 1.064 | 1.686 | 3.453 | 2.940 | 4.184 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2290.9 ± 3.5% | 2270.5 ± 5.2% | 1470.4 ± 4.2% | 609.8 ± 3.8% | 542.5 ± 4.4% | 593.7 ± 6.3% | 1.009 | 1.558 | 3.757 | 4.223 | 3.858 |
| qlog records, JSON text sequence | 1467503 | 2032.1 ± 4.8% | 1895.9 ± 4.7% | 1196.9 ± 4.2% | 584.3 ± 8.3% | 686.1 ± 4.0% | 482.2 ± 1.3% | 1.072 | 1.698 | 3.478 | 2.962 | 4.214 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1276.9 ± 4.9% | 2088.0 ± 6.5% | 1665.2 ± 4.5% | 540.4 ± 4.4% | 746.1 ± 5.2% | 465.3 ± 5.9% | 0.612 | 0.767 | 2.363 | 1.711 | 2.744 |
| qlog records, JSON text sequence | 1467503 | 1104.8 ± 2.2% | 1595.9 ± 3.7% | 1552.3 ± 2.0% | 448.5 ± 3.6% | 919.4 ± 2.9% | 473.7 ± 7.5% | 0.692 | 0.712 | 2.463 | 1.202 | 2.332 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1704.1 ± 3.4% | 2270.5 ± 5.2% | 1470.4 ± 4.2% | 609.8 ± 3.8% | 542.5 ± 4.4% | 593.7 ± 6.3% | 0.751 | 1.159 | 2.795 | 3.141 | 2.870 |
| qlog records, JSON text sequence | 1467503 | 1462.5 ± 2.8% | 1895.9 ± 4.7% | 1196.9 ± 4.2% | 584.3 ± 8.3% | 686.1 ± 4.0% | 482.2 ± 1.3% | 0.771 | 1.222 | 2.503 | 2.131 | 3.033 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.795 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.612 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.767 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.692 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.712 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.751 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.771 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 2

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1588.5 ± 6.1% | 0.523 | 0.969 | 1.008 | 1.004 | 0.394 | 0.992 | 1.001 | 0.396 | 0.784 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1307.2 ± 7.1% | 0.867 | 1.009 | 0.981 | 0.977 | 0.378 | 0.971 | 0.972 | 0.358 | 0.821 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2296.7 ± 0.8% | 0.449 | 0.952 | 0.969 | 0.996 | 1.000 | 0.268 | 1.011 | 0.466 | 0.736 | 0.085 | 0.997 |
| qlog records, JSON text sequence | 1467503 | 2019.5 ± 1.3% | 0.716 | 0.905 | 0.987 | 0.990 | 0.987 | 0.262 | 0.992 | 0.426 | 0.723 | 0.103 | 0.999 |

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
| CLDR supplemental, 34 texts | 920675 | 1588.5 ± 6.1% | 1994.7 ± 22.1% | 1633.2 ± 3.4% | 515.7 ± 10.2% | 731.4 ± 2.9% | 457.0 ± 6.0% | 0.796 | 0.973 | 3.080 | 2.172 | 3.476 |
| qlog records, JSON text sequence | 1467503 | 1307.2 ± 7.1% | 1540.3 ± 3.9% | 1472.8 ± 3.6% | 435.0 ± 5.1% | 882.9 ± 9.6% | 451.8 ± 41.7% | 0.849 | 0.888 | 3.005 | 1.480 | 2.893 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2296.7 ± 0.8% | 2255.7 ± 16.4% | 1454.5 ± 46.1% | 599.5 ± 21.9% | 541.2 ± 2.0% | 579.7 ± 6.5% | 1.018 | 1.579 | 3.831 | 4.244 | 3.962 |
| qlog records, JSON text sequence | 1467503 | 2019.5 ± 1.3% | 1862.1 ± 5.3% | 1199.3 ± 2.7% | 580.0 ± 3.6% | 692.7 ± 8.4% | 482.3 ± 3.8% | 1.085 | 1.684 | 3.482 | 2.916 | 4.187 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2290.2 ± 1.7% | 2255.7 ± 16.4% | 1454.5 ± 46.1% | 599.5 ± 21.9% | 541.2 ± 2.0% | 579.7 ± 6.5% | 1.015 | 1.575 | 3.820 | 4.232 | 3.950 |
| qlog records, JSON text sequence | 1467503 | 2017.6 ± 0.9% | 1862.1 ± 5.3% | 1199.3 ± 2.7% | 580.0 ± 3.6% | 692.7 ± 8.4% | 482.3 ± 3.8% | 1.084 | 1.682 | 3.478 | 2.913 | 4.183 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1246.1 ± 9.2% | 1994.7 ± 22.1% | 1633.2 ± 3.4% | 515.7 ± 10.2% | 731.4 ± 2.9% | 457.0 ± 6.0% | 0.625 | 0.763 | 2.416 | 1.704 | 2.727 |
| qlog records, JSON text sequence | 1467503 | 1073.0 ± 3.0% | 1540.3 ± 3.9% | 1472.8 ± 3.6% | 435.0 ± 5.1% | 882.9 ± 9.6% | 451.8 ± 41.7% | 0.697 | 0.729 | 2.467 | 1.215 | 2.375 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1691.0 ± 1.3% | 2255.7 ± 16.4% | 1454.5 ± 46.1% | 599.5 ± 21.9% | 541.2 ± 2.0% | 579.7 ± 6.5% | 0.750 | 1.163 | 2.820 | 3.124 | 2.917 |
| qlog records, JSON text sequence | 1467503 | 1460.3 ± 1.4% | 1862.1 ± 5.3% | 1199.3 ± 2.7% | 580.0 ± 3.6% | 692.7 ± 8.4% | 482.3 ± 3.8% | 0.784 | 1.218 | 2.518 | 2.108 | 3.028 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.849 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.888 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.625 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.763 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.697 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.729 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.750 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.784 of simdjson.

# bench-json, CLDR and qlog alone: base, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1590.0 ± 2.4% | 0.540 | 0.971 | 0.998 | 1.000 | 0.401 | 1.023 | 0.999 | 0.394 | 0.846 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1281.4 ± 7.7% | 0.921 | 1.024 | 1.052 | 1.025 | 0.392 | 1.039 | 1.014 | 0.338 | 0.711 | 0.109 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2293.6 ± 19.2% | 0.445 | 0.944 | 0.970 | 0.998 | 0.998 | 0.265 | 0.997 | 0.466 | 0.726 | 0.082 | 0.990 |
| qlog records, JSON text sequence | 1467503 | 1997.5 ± 2.0% | 0.718 | 0.918 | 0.991 | 0.998 | 0.994 | 0.260 | 0.999 | 0.432 | 0.722 | 0.101 | 1.001 |

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
| CLDR supplemental, 34 texts | 920675 | 1590.0 ± 2.4% | 2063.1 ± 0.8% | 1635.8 ± 3.7% | 524.1 ± 3.7% | 812.9 ± 2.6% | 456.7 ± 7.5% | 0.771 | 0.972 | 3.034 | 1.956 | 3.482 |
| qlog records, JSON text sequence | 1467503 | 1281.4 ± 7.7% | 1561.9 ± 1.2% | 1497.4 ± 2.3% | 439.2 ± 5.3% | 914.4 ± 24.2% | 456.3 ± 45.2% | 0.820 | 0.856 | 2.917 | 1.401 | 2.808 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2293.6 ± 19.2% | 2259.9 ± 1.7% | 1468.6 ± 2.0% | 587.2 ± 1.7% | 627.8 ± 2.0% | 576.4 ± 3.8% | 1.015 | 1.562 | 3.906 | 3.654 | 3.979 |
| qlog records, JSON text sequence | 1467503 | 1997.5 ± 2.0% | 1879.7 ± 1.2% | 1190.6 ± 4.3% | 565.2 ± 1.4% | 690.1 ± 0.3% | 480.2 ± 1.5% | 1.063 | 1.678 | 3.534 | 2.895 | 4.160 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2271.5 ± 19.0% | 2259.9 ± 1.7% | 1468.6 ± 2.0% | 587.2 ± 1.7% | 627.8 ± 2.0% | 576.4 ± 3.8% | 1.005 | 1.547 | 3.869 | 3.618 | 3.941 |
| qlog records, JSON text sequence | 1467503 | 1999.6 ± 2.8% | 1879.7 ± 1.2% | 1190.6 ± 4.3% | 565.2 ± 1.4% | 690.1 ± 0.3% | 480.2 ± 1.5% | 1.064 | 1.680 | 3.538 | 2.898 | 4.165 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1344.8 ± 1.2% | 2063.1 ± 0.8% | 1635.8 ± 3.7% | 524.1 ± 3.7% | 812.9 ± 2.6% | 456.7 ± 7.5% | 0.652 | 0.822 | 2.566 | 1.654 | 2.945 |
| qlog records, JSON text sequence | 1467503 | 911.3 ± 2.9% | 1561.9 ± 1.2% | 1497.4 ± 2.3% | 439.2 ± 5.3% | 914.4 ± 24.2% | 456.3 ± 45.2% | 0.583 | 0.609 | 2.075 | 0.997 | 1.997 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1665.3 ± 1.6% | 2259.9 ± 1.7% | 1468.6 ± 2.0% | 587.2 ± 1.7% | 627.8 ± 2.0% | 576.4 ± 3.8% | 0.737 | 1.134 | 2.836 | 2.653 | 2.889 |
| qlog records, JSON text sequence | 1467503 | 1442.6 ± 2.5% | 1879.7 ± 1.2% | 1190.6 ± 4.3% | 565.2 ± 1.4% | 690.1 ± 0.3% | 480.2 ± 1.5% | 0.767 | 1.212 | 2.553 | 2.090 | 3.004 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.771 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.820 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.856 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.652 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.822 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.583 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.609 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.737 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.767 of simdjson.

# bench-json, CLDR and qlog alone: q8, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1588.8 ± 4.4% | 0.521 | 0.981 | 1.017 | 1.021 | 0.396 | 1.014 | 1.016 | 0.391 | 0.861 | 0.095 |
| qlog records, JSON text sequence | 1467503 | 1326.5 ± 9.7% | 0.864 | 0.996 | 0.967 | 0.969 | 0.378 | 0.974 | 0.967 | 0.363 | 0.838 | 0.110 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2284.4 ± 5.2% | 0.450 | 0.951 | 0.971 | 0.996 | 1.010 | 0.270 | 0.999 | 0.470 | 0.734 | 0.082 | 1.005 |
| qlog records, JSON text sequence | 1467503 | 1976.2 ± 13.2% | 0.718 | 0.918 | 0.991 | 0.988 | 0.995 | 0.262 | 0.982 | 0.433 | 0.729 | 0.102 | 1.001 |

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
| CLDR supplemental, 34 texts | 920675 | 1588.8 ± 4.4% | 2030.5 ± 3.4% | 1640.1 ± 2.6% | 518.4 ± 29.3% | 732.3 ± 12.9% | 458.4 ± 6.2% | 0.782 | 0.969 | 3.065 | 2.170 | 3.466 |
| qlog records, JSON text sequence | 1467503 | 1326.5 ± 9.7% | 1489.3 ± 30.3% | 1478.7 ± 29.6% | 435.3 ± 7.1% | 917.0 ± 3.0% | 463.6 ± 3.1% | 0.891 | 0.897 | 3.047 | 1.447 | 2.861 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2284.4 ± 5.2% | 2267.5 ± 3.0% | 1450.4 ± 3.8% | 603.6 ± 12.8% | 540.0 ± 11.2% | 574.9 ± 4.4% | 1.007 | 1.575 | 3.785 | 4.231 | 3.973 |
| qlog records, JSON text sequence | 1467503 | 1976.2 ± 13.2% | 1813.4 ± 5.7% | 1187.9 ± 4.3% | 570.6 ± 5.2% | 678.5 ± 3.0% | 468.6 ± 4.5% | 1.090 | 1.664 | 3.463 | 2.913 | 4.218 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2295.0 ± 3.8% | 2267.5 ± 3.0% | 1450.4 ± 3.8% | 603.6 ± 12.8% | 540.0 ± 11.2% | 574.9 ± 4.4% | 1.012 | 1.582 | 3.802 | 4.250 | 3.992 |
| qlog records, JSON text sequence | 1467503 | 1978.5 ± 4.8% | 1813.4 ± 5.7% | 1187.9 ± 4.3% | 570.6 ± 5.2% | 678.5 ± 3.0% | 468.6 ± 4.5% | 1.091 | 1.666 | 3.467 | 2.916 | 4.223 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1367.9 ± 41.8% | 2030.5 ± 3.4% | 1640.1 ± 2.6% | 518.4 ± 29.3% | 732.3 ± 12.9% | 458.4 ± 6.2% | 0.674 | 0.834 | 2.638 | 1.868 | 2.984 |
| qlog records, JSON text sequence | 1467503 | 1111.6 ± 16.9% | 1489.3 ± 30.3% | 1478.7 ± 29.6% | 435.3 ± 7.1% | 917.0 ± 3.0% | 463.6 ± 3.1% | 0.746 | 0.752 | 2.554 | 1.212 | 2.398 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1676.8 ± 1.8% | 2267.5 ± 3.0% | 1450.4 ± 3.8% | 603.6 ± 12.8% | 540.0 ± 11.2% | 574.9 ± 4.4% | 0.739 | 1.156 | 2.778 | 3.105 | 2.917 |
| qlog records, JSON text sequence | 1467503 | 1441.1 ± 5.9% | 1813.4 ± 5.7% | 1187.9 ± 4.3% | 570.6 ± 5.2% | 678.5 ± 3.0% | 468.6 ± 4.5% | 0.795 | 1.213 | 2.526 | 2.124 | 3.076 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.782 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.739 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.795 of simdjson.

# bench-json, CLDR and qlog alone: q16, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1596.1 ± 5.4% | 0.530 | 0.984 | 1.007 | 1.008 | 0.393 | 1.017 | 0.993 | 0.392 | 0.812 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1304.5 ± 6.5% | 0.864 | 1.024 | 0.982 | 0.971 | 0.364 | 0.979 | 0.971 | 0.315 | 0.833 | 0.111 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2279.8 ± 1.7% | 0.448 | 0.952 | 0.962 | 1.003 | 1.006 | 0.268 | 1.008 | 0.462 | 0.725 | 0.083 | 0.999 |
| qlog records, JSON text sequence | 1467503 | 1987.7 ± 12.3% | 0.724 | 0.920 | 0.995 | 1.003 | 1.006 | 0.267 | 1.004 | 0.435 | 0.730 | 0.100 | 1.015 |

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
| CLDR supplemental, 34 texts | 920675 | 1596.1 ± 5.4% | 2045.0 ± 17.2% | 1610.2 ± 16.8% | 521.9 ± 2.8% | 733.1 ± 9.1% | 456.0 ± 7.1% | 0.780 | 0.991 | 3.058 | 2.177 | 3.500 |
| qlog records, JSON text sequence | 1467503 | 1304.5 ± 6.5% | 1336.4 ± 10.0% | 1526.8 ± 34.3% | 424.8 ± 5.0% | 886.9 ± 9.0% | 457.6 ± 6.1% | 0.976 | 0.854 | 3.071 | 1.471 | 2.851 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2279.8 ± 1.7% | 2236.3 ± 1.8% | 1449.7 ± 2.1% | 593.3 ± 3.4% | 535.2 ± 1.8% | 567.7 ± 13.5% | 1.019 | 1.573 | 3.843 | 4.260 | 4.016 |
| qlog records, JSON text sequence | 1467503 | 1987.7 ± 12.3% | 1893.5 ± 2.1% | 1200.0 ± 2.6% | 576.6 ± 2.5% | 691.8 ± 5.9% | 475.7 ± 51.3% | 1.050 | 1.656 | 3.447 | 2.873 | 4.179 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2278.2 ± 9.4% | 2236.3 ± 1.8% | 1449.7 ± 2.1% | 593.3 ± 3.4% | 535.2 ± 1.8% | 567.7 ± 13.5% | 1.019 | 1.571 | 3.840 | 4.257 | 4.013 |
| qlog records, JSON text sequence | 1467503 | 2017.6 ± 2.0% | 1893.5 ± 2.1% | 1200.0 ± 2.6% | 576.6 ± 2.5% | 691.8 ± 5.9% | 475.7 ± 51.3% | 1.066 | 1.681 | 3.499 | 2.917 | 4.242 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1295.8 ± 3.4% | 2045.0 ± 17.2% | 1610.2 ± 16.8% | 521.9 ± 2.8% | 733.1 ± 9.1% | 456.0 ± 7.1% | 0.634 | 0.805 | 2.483 | 1.768 | 2.842 |
| qlog records, JSON text sequence | 1467503 | 1087.3 ± 4.4% | 1336.4 ± 10.0% | 1526.8 ± 34.3% | 424.8 ± 5.0% | 886.9 ± 9.0% | 457.6 ± 6.1% | 0.814 | 0.712 | 2.560 | 1.226 | 2.376 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1652.6 ± 2.0% | 2236.3 ± 1.8% | 1449.7 ± 2.1% | 593.3 ± 3.4% | 535.2 ± 1.8% | 567.7 ± 13.5% | 0.739 | 1.140 | 2.786 | 3.088 | 2.911 |
| qlog records, JSON text sequence | 1467503 | 1451.9 ± 1.6% | 1893.5 ± 2.1% | 1200.0 ± 2.6% | 576.6 ± 2.5% | 691.8 ± 5.9% | 475.7 ± 51.3% | 0.767 | 1.210 | 2.518 | 2.099 | 3.052 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.780 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.634 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.805 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.814 of simdjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.739 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.767 of simdjson.

# bench-json, CLDR and qlog alone: q32, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1571.6 ± 19.0% | 0.538 | 0.996 | 1.026 | 1.032 | 0.403 | 1.019 | 1.016 | 0.390 | 0.778 | 0.098 |
| qlog records, JSON text sequence | 1467503 | 1332.3 ± 6.5% | 0.872 | 0.997 | 0.978 | 0.959 | 0.372 | 0.970 | 0.943 | 0.362 | 0.806 | 0.108 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2358.8 ± 5.6% | 0.427 | 0.938 | 0.961 | 0.999 | 0.991 | 0.255 | 1.004 | 0.459 | 0.732 | 0.085 | 0.983 |
| qlog records, JSON text sequence | 1467503 | 2063.6 ± 1.9% | 0.719 | 0.901 | 0.987 | 0.999 | 0.991 | 0.260 | 0.995 | 0.428 | 0.719 | 0.106 | 1.000 |

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
| CLDR supplemental, 34 texts | 920675 | 1571.6 ± 19.0% | 2041.3 ± 3.1% | 1611.0 ± 4.1% | 512.5 ± 1.7% | 716.4 ± 3.9% | 442.9 ± 7.6% | 0.770 | 0.976 | 3.067 | 2.194 | 3.548 |
| qlog records, JSON text sequence | 1467503 | 1332.3 ± 6.5% | 1549.4 ± 9.0% | 1543.7 ± 2.5% | 440.2 ± 4.9% | 895.0 ± 4.5% | 458.0 ± 7.1% | 0.860 | 0.863 | 3.027 | 1.489 | 2.909 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2358.8 ± 5.6% | 2297.7 ± 1.9% | 1478.1 ± 5.3% | 608.5 ± 2.1% | 548.5 ± 1.7% | 591.8 ± 2.4% | 1.027 | 1.596 | 3.877 | 4.300 | 3.986 |
| qlog records, JSON text sequence | 1467503 | 2063.6 ± 1.9% | 1934.1 ± 3.3% | 1217.9 ± 2.4% | 591.5 ± 22.3% | 707.6 ± 63.9% | 484.6 ± 8.4% | 1.067 | 1.694 | 3.489 | 2.916 | 4.258 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2318.6 ± 16.0% | 2297.7 ± 1.9% | 1478.1 ± 5.3% | 608.5 ± 2.1% | 548.5 ± 1.7% | 591.8 ± 2.4% | 1.009 | 1.569 | 3.811 | 4.227 | 3.918 |
| qlog records, JSON text sequence | 1467503 | 2063.2 ± 1.3% | 1934.1 ± 3.3% | 1217.9 ± 2.4% | 591.5 ± 22.3% | 707.6 ± 63.9% | 484.6 ± 8.4% | 1.067 | 1.694 | 3.488 | 2.916 | 4.257 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1222.1 ± 3.7% | 2041.3 ± 3.1% | 1611.0 ± 4.1% | 512.5 ± 1.7% | 716.4 ± 3.9% | 442.9 ± 7.6% | 0.599 | 0.759 | 2.385 | 1.706 | 2.759 |
| qlog records, JSON text sequence | 1467503 | 1073.4 ± 3.5% | 1549.4 ± 9.0% | 1543.7 ± 2.5% | 440.2 ± 4.9% | 895.0 ± 4.5% | 458.0 ± 7.1% | 0.693 | 0.695 | 2.438 | 1.199 | 2.344 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1725.6 ± 27.9% | 2297.7 ± 1.9% | 1478.1 ± 5.3% | 608.5 ± 2.1% | 548.5 ± 1.7% | 591.8 ± 2.4% | 0.751 | 1.167 | 2.836 | 3.146 | 2.916 |
| qlog records, JSON text sequence | 1467503 | 1482.9 ± 11.2% | 1934.1 ± 3.3% | 1217.9 ± 2.4% | 591.5 ± 22.3% | 707.6 ± 63.9% | 484.6 ± 8.4% | 0.767 | 1.218 | 2.507 | 2.096 | 3.060 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.770 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.860 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.863 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.599 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.759 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.693 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.695 of yyjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.767 of simdjson.

# bench-json, CLDR and qlog alone: q64, round 3

| Field | Value |
|---|---|
| CPU model | AMD EPYC 9V45 96-Core Processor |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1599.2 ± 21.8% | 0.528 | 0.975 | 1.012 | 1.010 | 0.395 | 1.009 | 1.014 | 0.399 | 0.783 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 1292.2 ± 7.3% | 0.896 | 1.052 | 1.007 | 1.008 | 0.391 | 1.011 | 1.002 | 0.387 | 0.858 | 0.116 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2251.0 ± 9.5% | 0.443 | 0.966 | 0.988 | 1.016 | 1.030 | 0.276 | 1.010 | 0.474 | 0.744 | 0.087 | 1.001 |
| qlog records, JSON text sequence | 1467503 | 2046.4 ± 6.5% | 0.721 | 0.931 | 0.978 | 0.991 | 0.986 | 0.265 | 0.993 | 0.426 | 0.738 | 0.103 | 1.004 |

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
| CLDR supplemental, 34 texts | 920675 | 1599.2 ± 21.8% | 2034.0 ± 1.6% | 1659.2 ± 2.2% | 522.9 ± 4.5% | 738.1 ± 3.1% | 468.0 ± 4.7% | 0.786 | 0.964 | 3.059 | 2.167 | 3.417 |
| qlog records, JSON text sequence | 1467503 | 1292.2 ± 7.3% | 1548.7 ± 2.4% | 1546.7 ± 3.8% | 442.7 ± 2.5% | 909.1 ± 5.5% | 460.1 ± 7.3% | 0.834 | 0.835 | 2.919 | 1.421 | 2.809 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2251.0 ± 9.5% | 2253.8 ± 4.3% | 1456.6 ± 5.9% | 595.6 ± 6.1% | 537.3 ± 5.7% | 570.6 ± 5.7% | 0.999 | 1.545 | 3.779 | 4.189 | 3.945 |
| qlog records, JSON text sequence | 1467503 | 2046.4 ± 6.5% | 1914.1 ± 3.2% | 1194.3 ± 4.2% | 579.7 ± 6.0% | 692.2 ± 5.4% | 482.6 ± 7.8% | 1.069 | 1.713 | 3.530 | 2.956 | 4.240 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 2252.5 ± 6.4% | 2253.8 ± 4.3% | 1456.6 ± 5.9% | 595.6 ± 6.1% | 537.3 ± 5.7% | 570.6 ± 5.7% | 0.999 | 1.546 | 3.782 | 4.192 | 3.948 |
| qlog records, JSON text sequence | 1467503 | 2053.8 ± 4.0% | 1914.1 ± 3.2% | 1194.3 ± 4.2% | 579.7 ± 6.0% | 692.2 ± 5.4% | 482.6 ± 7.8% | 1.073 | 1.720 | 3.543 | 2.967 | 4.256 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1251.4 ± 2.0% | 2034.0 ± 1.6% | 1659.2 ± 2.2% | 522.9 ± 4.5% | 738.1 ± 3.1% | 468.0 ± 4.7% | 0.615 | 0.754 | 2.393 | 1.695 | 2.674 |
| qlog records, JSON text sequence | 1467503 | 1108.7 ± 3.1% | 1548.7 ± 2.4% | 1546.7 ± 3.8% | 442.7 ± 2.5% | 909.1 ± 5.5% | 460.1 ± 7.3% | 0.716 | 0.717 | 2.504 | 1.219 | 2.410 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1675.2 ± 5.0% | 2253.8 ± 4.3% | 1456.6 ± 5.9% | 595.6 ± 6.1% | 537.3 ± 5.7% | 570.6 ± 5.7% | 0.743 | 1.150 | 2.813 | 3.118 | 2.936 |
| qlog records, JSON text sequence | 1467503 | 1510.5 ± 3.7% | 1914.1 ± 3.2% | 1194.3 ± 4.2% | 579.7 ± 6.0% | 692.2 ± 5.4% | 482.6 ± 7.8% | 0.789 | 1.265 | 2.606 | 2.182 | 3.130 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.834 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.835 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.615 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.754 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.716 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.717 of yyjson.
- CLDR supplemental, 34 texts, encoding through TextWriter's methods: stdx runs at 0.743 of simdjson.
- qlog records, JSON text sequence, encoding through TextWriter's methods: stdx runs at 0.789 of simdjson.
