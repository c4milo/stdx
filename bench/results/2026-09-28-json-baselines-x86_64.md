# bench-json

| Field | Value |
|---|---|
| Commit | e468bb5 |
| Runner label | ubuntu-24.04 |
| Image version | 20260920.314.1 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/36439380850 |
| Date | 2026-09-28 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the vector path lost. Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | All off |
|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 193.2 ± 0.4% | 0.587 | 0.995 | 0.587 |
| qlog records, JSON text sequence | 1467503 | 139.3 ± 0.3% | 0.723 | 0.997 | 0.720 |
| string: silesia/dickens | 172528 | 1291.6 ± 2.8% | 0.128 | 1.009 | 0.127 |
| string: silesia/nci | 1075110 | 1660.4 ± 0.4% | 0.101 | 1.007 | 0.101 |
| string: silesia/reymont | 1075159 | 1212.0 ± 0.8% | 0.137 | 0.997 | 0.137 |
| string: silesia/samba | 97582 | 281.5 ± 1.9% | 0.518 | 1.000 | 0.518 |
| string: silesia/webster | 1098490 | 906.6 ± 1.0% | 0.178 | 1.004 | 0.178 |
| string: silesia/xml | 1090118 | 1432.2 ± 0.3% | 0.116 | 1.004 | 0.116 |
| string: canterbury/alice29.txt | 159425 | 979.4 ± 0.8% | 0.165 | 1.008 | 0.166 |
| string: canterbury/asyoulik.txt | 132198 | 839.8 ± 0.9% | 0.189 | 1.001 | 0.189 |
| string: canterbury/lcet10.txt | 441884 | 1238.4 ± 16.9% | 0.133 | 1.006 | 0.133 |
| string: canterbury/plrabn12.txt | 503330 | 1071.8 ± 0.4% | 0.151 | 1.003 | 0.151 |
| string: canterbury-large/E.coli | 1048578 | 12997.9 ± 0.5% | 0.013 | 0.999 | 0.013 |
| string: canterbury-large/bible.txt | 1055886 | 3356.8 ± 0.9% | 0.051 | 1.002 | 0.051 |
| string: canterbury-large/world192.txt | 1103121 | 837.6 ± 0.5% | 0.192 | 1.004 | 0.192 |
| string: http/html-1m | 1058582 | 2919.2 ± 0.8% | 0.058 | 0.990 | 0.058 |
| string: http/json-1m | 1190272 | 404.3 ± 0.3% | 0.397 | 0.994 | 0.397 |
| string: http/js-1m | 1144362 | 506.8 ± 0.6% | 0.303 | 1.006 | 0.303 |
| string: http/css-1m | 1097820 | 928.7 ± 0.5% | 0.172 | 1.000 | 0.172 |
| string: dickens as Cyrillic and CJK | 1883069 | 794.1 ± 0.2% | 0.155 | 0.147 | 0.155 |
| hex: silesia/dickens | 524290 | 13800.5 ± 1.1% | 0.013 | 1.001 | 0.013 |
| hex: silesia/mozilla | 524290 | 13812.2 ± 0.3% | 0.013 | 0.999 | 0.013 |
| hex: silesia/mr | 524290 | 13783.0 ± 0.3% | 0.013 | 1.000 | 0.013 |
| hex: silesia/nci | 524290 | 13821.3 ± 1.4% | 0.013 | 1.000 | 0.013 |
| hex: silesia/ooffice | 524290 | 13800.0 ± 0.1% | 0.013 | 1.001 | 0.013 |
| hex: silesia/osdb | 524290 | 13822.9 ± 0.6% | 0.013 | 0.999 | 0.013 |
| hex: silesia/reymont | 524290 | 13804.0 ± 0.2% | 0.013 | 1.000 | 0.013 |
| hex: silesia/samba | 524290 | 13839.0 ± 0.8% | 0.013 | 1.000 | 0.013 |
| hex: silesia/sao | 524290 | 13780.8 ± 0.2% | 0.013 | 0.998 | 0.013 |
| hex: silesia/webster | 524290 | 13837.6 ± 0.1% | 0.013 | 0.998 | 0.013 |
| hex: silesia/x-ray | 524290 | 13696.8 ± 0.4% | 0.013 | 1.000 | 0.013 |
| hex: silesia/xml | 524290 | 13742.4 ± 0.3% | 0.013 | 1.002 | 0.013 |
| hex: canterbury/alice29.txt | 304180 | 13747.4 ± 0.4% | 0.013 | 1.001 | 0.013 |
| hex: canterbury/asyoulik.txt | 250360 | 13880.5 ± 0.2% | 0.013 | 1.002 | 0.013 |
| hex: canterbury/cp.html | 49208 | 13571.5 ± 0.7% | 0.013 | 1.001 | 0.013 |
| hex: canterbury/fields.c | 22302 | 13255.7 ± 0.4% | 0.013 | 1.001 | 0.013 |
| hex: canterbury/grammar.lsp | 7444 | 12555.7 ± 0.6% | 0.014 | 1.000 | 0.014 |
| hex: canterbury/kennedy.xls | 524290 | 13811.2 ± 0.4% | 0.013 | 1.000 | 0.013 |
| hex: canterbury/lcet10.txt | 524290 | 13658.7 ± 0.1% | 0.013 | 0.999 | 0.013 |
| hex: canterbury/plrabn12.txt | 524290 | 13779.9 ± 0.4% | 0.013 | 0.999 | 0.013 |
| hex: canterbury/ptt5 | 524290 | 13741.9 ± 1.5% | 0.013 | 1.000 | 0.013 |
| hex: canterbury/sum | 76482 | 13698.4 ± 0.1% | 0.013 | 1.000 | 0.013 |
| hex: canterbury/xargs.1 | 8456 | 12753.4 ± 0.1% | 0.014 | 0.999 | 0.014 |
| hex: canterbury-large/E.coli | 524290 | 13794.9 ± 0.6% | 0.013 | 1.001 | 0.013 |
| hex: canterbury-large/bible.txt | 524290 | 13779.2 ± 0.5% | 0.013 | 1.001 | 0.013 |
| hex: canterbury-large/world192.txt | 524290 | 13832.2 ± 0.2% | 0.013 | 1.000 | 0.013 |
| hex: http/html-1k | 2050 | 9797.7 ± 0.2% | 0.018 | 1.002 | 0.018 |
| hex: http/html-16k | 32770 | 13437.9 ± 0.1% | 0.013 | 1.001 | 0.013 |
| hex: http/html-1m | 524290 | 13814.2 ± 0.3% | 0.013 | 1.000 | 0.013 |
| hex: http/json-1k | 2050 | 9513.8 ± 0.3% | 0.018 | 1.000 | 0.018 |
| hex: http/json-16k | 32770 | 13434.3 ± 0.5% | 0.013 | 1.002 | 0.013 |
| hex: http/json-1m | 524290 | 13759.6 ± 3.5% | 0.013 | 1.003 | 0.013 |
| hex: http/js-1k | 2050 | 9805.2 ± 4.7% | 0.018 | 1.008 | 0.018 |
| hex: http/js-16k | 32770 | 13418.6 ± 12.9% | 0.013 | 1.003 | 0.013 |
| hex: http/js-1m | 524290 | 13758.4 ± 0.2% | 0.013 | 1.000 | 0.013 |
| hex: http/css-1k | 2050 | 9485.2 ± 1.9% | 0.018 | 1.002 | 0.018 |
| hex: http/css-16k | 32770 | 13415.6 ± 0.8% | 0.013 | 1.000 | 0.013 |
| hex: http/css-1m | 524290 | 13751.1 ± 0.5% | 0.013 | 0.999 | 0.013 |
| hex: shuffled/dickens-1m | 524290 | 13827.2 ± 0.5% | 0.013 | 1.001 | 0.013 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the vector path lost. Octets are the ones written.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | All off |
|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 251.4 ± 0.2% | 0.651 | 1.000 | 0.975 | 0.650 |
| qlog records, JSON text sequence | 1467503 | 227.8 ± 0.1% | 0.760 | 1.002 | 0.989 | 0.760 |
| string: silesia/dickens | 172528 | 1483.6 ± 1.4% | 0.150 | 1.005 | 1.019 | 0.152 |
| string: silesia/nci | 1075110 | 2133.4 ± 0.5% | 0.106 | 1.000 | 0.985 | 0.107 |
| string: silesia/reymont | 1075159 | 1470.1 ± 0.8% | 0.151 | 1.002 | 0.993 | 0.153 |
| string: silesia/samba | 97582 | 683.4 ± 0.5% | 0.406 | 1.009 | 0.998 | 0.408 |
| string: silesia/webster | 1098490 | 1054.3 ± 2.0% | 0.207 | 0.992 | 0.993 | 0.208 |
| string: silesia/xml | 1090118 | 2097.8 ± 0.8% | 0.109 | 1.000 | 0.995 | 0.110 |
| string: canterbury/alice29.txt | 159425 | 1169.4 ± 0.5% | 0.187 | 0.992 | 0.986 | 0.188 |
| string: canterbury/asyoulik.txt | 132198 | 1016.9 ± 0.5% | 0.210 | 0.991 | 1.009 | 0.212 |
| string: canterbury/lcet10.txt | 441884 | 1394.0 ± 1.2% | 0.159 | 0.984 | 1.023 | 0.160 |
| string: canterbury/plrabn12.txt | 503330 | 1293.2 ± 2.3% | 0.168 | 1.000 | 0.990 | 0.171 |
| string: canterbury-large/E.coli | 1048578 | 12980.3 ± 0.3% | 0.018 | 1.001 | 1.000 | 0.018 |
| string: canterbury-large/bible.txt | 1055886 | 3957.5 ± 16.0% | 0.058 | 0.993 | 0.994 | 0.059 |
| string: canterbury-large/world192.txt | 1103121 | 964.2 ± 0.4% | 0.224 | 0.991 | 1.004 | 0.226 |
| string: http/html-1m | 1058582 | 3477.6 ± 0.8% | 0.066 | 0.996 | 0.974 | 0.067 |
| string: http/json-1m | 1190272 | 543.4 ± 0.9% | 0.406 | 0.998 | 0.967 | 0.409 |
| string: http/js-1m | 1144362 | 599.7 ± 0.6% | 0.346 | 0.996 | 0.987 | 0.350 |
| string: http/css-1m | 1097820 | 1211.0 ± 0.7% | 0.177 | 0.999 | 0.972 | 0.178 |
| string: dickens as Cyrillic and CJK | 1883069 | 814.2 ± 0.2% | 0.203 | 0.998 | 0.139 | 0.204 |
| hex: silesia/dickens | 524290 | 23043.9 ± 0.2% | 1.002 | 0.136 | 1.002 | 0.136 |
| hex: silesia/mozilla | 524290 | 23142.5 ± 0.3% | 0.999 | 0.136 | 1.001 | 0.135 |
| hex: silesia/mr | 524290 | 23293.4 ± 0.1% | 1.000 | 0.135 | 1.000 | 0.135 |
| hex: silesia/nci | 524290 | 23216.0 ± 0.3% | 1.000 | 0.135 | 1.000 | 0.135 |
| hex: silesia/ooffice | 524290 | 23128.3 ± 0.3% | 1.001 | 0.136 | 1.001 | 0.136 |
| hex: silesia/osdb | 524290 | 22587.1 ± 0.3% | 0.999 | 0.138 | 1.000 | 0.139 |
| hex: silesia/reymont | 524290 | 23275.2 ± 0.2% | 1.000 | 0.135 | 0.999 | 0.135 |
| hex: silesia/samba | 524290 | 23079.0 ± 0.1% | 1.000 | 0.136 | 0.998 | 0.136 |
| hex: silesia/sao | 524290 | 22999.0 ± 0.4% | 1.000 | 0.136 | 1.000 | 0.136 |
| hex: silesia/webster | 524290 | 23147.1 ± 4.0% | 1.000 | 0.135 | 1.000 | 0.135 |
| hex: silesia/x-ray | 524290 | 23271.2 ± 0.2% | 1.000 | 0.135 | 1.000 | 0.135 |
| hex: silesia/xml | 524290 | 23279.5 ± 0.2% | 1.001 | 0.134 | 0.999 | 0.135 |
| hex: canterbury/alice29.txt | 304180 | 22703.7 ± 0.6% | 1.002 | 0.137 | 1.002 | 0.137 |
| hex: canterbury/asyoulik.txt | 250360 | 23207.2 ± 0.3% | 1.001 | 0.135 | 1.001 | 0.135 |
| hex: canterbury/cp.html | 49208 | 22593.1 ± 0.4% | 1.001 | 0.139 | 1.002 | 0.138 |
| hex: canterbury/fields.c | 22302 | 21728.1 ± 0.3% | 1.000 | 0.143 | 1.000 | 0.143 |
| hex: canterbury/grammar.lsp | 7444 | 20513.7 ± 1.6% | 1.002 | 0.150 | 1.003 | 0.150 |
| hex: canterbury/kennedy.xls | 524290 | 23288.8 ± 10.6% | 1.000 | 0.135 | 1.000 | 0.135 |
| hex: canterbury/lcet10.txt | 524290 | 22871.9 ± 3.2% | 1.007 | 0.137 | 1.008 | 0.137 |
| hex: canterbury/plrabn12.txt | 524290 | 22984.8 ± 0.1% | 1.000 | 0.136 | 1.000 | 0.136 |
| hex: canterbury/ptt5 | 524290 | 23295.3 ± 0.7% | 1.000 | 0.135 | 0.998 | 0.135 |
| hex: canterbury/sum | 76482 | 22952.1 ± 0.3% | 1.000 | 0.136 | 1.000 | 0.137 |
| hex: canterbury/xargs.1 | 8456 | 20057.3 ± 0.2% | 1.002 | 0.154 | 0.999 | 0.154 |
| hex: canterbury-large/E.coli | 524290 | 22994.4 ± 0.1% | 1.000 | 0.136 | 0.999 | 0.136 |
| hex: canterbury-large/bible.txt | 524290 | 23104.3 ± 3.1% | 1.001 | 0.135 | 1.000 | 0.135 |
| hex: canterbury-large/world192.txt | 524290 | 23061.6 ± 0.2% | 0.999 | 0.136 | 0.999 | 0.135 |
| hex: http/html-1k | 2050 | 16245.0 ± 0.2% | 1.013 | 0.182 | 1.007 | 0.182 |
| hex: http/html-16k | 32770 | 22314.1 ± 0.9% | 1.001 | 0.140 | 1.000 | 0.140 |
| hex: http/html-1m | 524290 | 23124.0 ± 0.4% | 1.000 | 0.135 | 0.999 | 0.135 |
| hex: http/json-1k | 2050 | 16413.3 ± 0.2% | 1.008 | 0.180 | 1.007 | 0.180 |
| hex: http/json-16k | 32770 | 22464.9 ± 0.2% | 1.001 | 0.139 | 1.001 | 0.139 |
| hex: http/json-1m | 524290 | 22580.7 ± 0.2% | 1.000 | 0.139 | 0.999 | 0.139 |
| hex: http/js-1k | 2050 | 16094.6 ± 0.8% | 1.004 | 0.183 | 1.005 | 0.183 |
| hex: http/js-16k | 32770 | 22358.6 ± 0.3% | 1.001 | 0.140 | 1.001 | 0.140 |
| hex: http/js-1m | 524290 | 23223.1 ± 0.4% | 1.000 | 0.135 | 1.000 | 0.134 |
| hex: http/css-1k | 2050 | 16456.7 ± 0.3% | 1.006 | 0.178 | 1.013 | 0.178 |
| hex: http/css-16k | 32770 | 22272.1 ± 0.2% | 1.001 | 0.140 | 1.001 | 0.140 |
| hex: http/css-1m | 524290 | 23268.5 ± 0.6% | 1.000 | 0.135 | 1.001 | 0.135 |
| hex: shuffled/dickens-1m | 524290 | 23298.7 ± 0.2% | 0.999 | 0.135 | 0.999 | 0.135 |

## Losses

Each workload where a vector path ran slower than the scalar path by more than the noise floor of decision 20.

None.

## Against the baselines

stdx with every claim on, timed beside simdjson 4.6.11, yyjson 0.13.0 and Zig 0.16.0's std.json in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe; the baselines for this host in ReleaseFast, and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 193.2 ± 0.4% | 1275.7 ± 1.5% | 1202.7 ± 1.6% | 364.0 ± 1.5% | 0.151 | 0.161 | 0.531 |
| qlog records, JSON text sequence | 1467503 | 139.3 ± 0.3% | 898.2 ± 2.3% | 1064.0 ± 0.7% | 301.8 ± 2.1% | 0.155 | 0.131 | 0.461 |
| string: silesia/dickens | 172528 | 1291.6 ± 2.8% | 3637.1 ± 0.2% | 3276.9 ± 0.7% | 335.4 ± 0.2% | 0.355 | 0.394 | 3.851 |
| string: silesia/nci | 1075110 | 1660.4 ± 0.4% | 4368.3 ± 0.1% | 3478.9 ± 0.4% | 530.0 ± 0.3% | 0.380 | 0.477 | 3.133 |
| string: silesia/reymont | 1075159 | 1212.0 ± 0.8% | 4621.0 ± 0.2% | 2055.4 ± 0.7% | 330.8 ± 2.0% | 0.262 | 0.590 | 3.663 |
| string: silesia/samba | 97582 | 281.5 ± 1.9% | 1834.8 ± 0.1% | 2662.6 ± 0.5% | 330.5 ± 2.4% | 0.153 | 0.106 | 0.852 |
| string: silesia/webster | 1098490 | 906.6 ± 1.0% | 2917.5 ± 0.2% | 2013.7 ± 6.0% | 336.3 ± 1.2% | 0.311 | 0.450 | 2.696 |
| string: silesia/xml | 1090118 | 1432.2 ± 0.3% | 4740.4 ± 0.1% | 2700.9 ± 3.0% | 456.3 ± 0.2% | 0.302 | 0.530 | 3.139 |
| string: canterbury/alice29.txt | 159425 | 979.4 ± 0.8% | 2920.4 ± 0.2% | 3460.7 ± 4.3% | 316.9 ± 1.6% | 0.335 | 0.283 | 3.091 |
| string: canterbury/asyoulik.txt | 132198 | 839.8 ± 0.9% | 2618.9 ± 0.3% | 2941.0 ± 3.2% | 309.1 ± 0.6% | 0.321 | 0.286 | 2.717 |
| string: canterbury/lcet10.txt | 441884 | 1238.4 ± 16.9% | 3593.8 ± 0.4% | 2632.3 ± 0.6% | 359.8 ± 0.4% | 0.345 | 0.470 | 3.442 |
| string: canterbury/plrabn12.txt | 503330 | 1071.8 ± 0.4% | 3117.9 ± 0.1% | 2057.6 ± 4.1% | 326.2 ± 0.9% | 0.344 | 0.521 | 3.286 |
| string: canterbury-large/E.coli | 1048578 | 12997.9 ± 0.5% | 12772.0 ± 0.3% | 4107.1 ± 0.2% | 913.8 ± 0.2% | 1.018 | 3.165 | 14.224 |
| string: canterbury-large/bible.txt | 1055886 | 3356.8 ± 0.9% | 8781.3 ± 0.3% | 2988.9 ± 0.3% | 390.3 ± 0.3% | 0.382 | 1.123 | 8.601 |
| string: canterbury-large/world192.txt | 1103121 | 837.6 ± 0.5% | 2487.8 ± 0.4% | 1996.4 ± 0.1% | 345.9 ± 0.9% | 0.337 | 0.420 | 2.422 |
| string: http/html-1m | 1058582 | 2919.2 ± 0.8% | 7595.2 ± 0.7% | 3031.6 ± 2.9% | 414.6 ± 0.2% | 0.384 | 0.963 | 7.042 |
| string: http/json-1m | 1190272 | 404.3 ± 0.3% | 1276.3 ± 0.2% | 2065.2 ± 6.9% | 363.9 ± 0.6% | 0.317 | 0.196 | 1.111 |
| string: http/js-1m | 1144362 | 506.8 ± 0.6% | 1730.6 ± 0.3% | 1488.6 ± 0.2% | 305.8 ± 1.4% | 0.293 | 0.340 | 1.657 |
| string: http/css-1m | 1097820 | 928.7 ± 0.5% | 2972.4 ± 1.0% | 3334.6 ± 0.3% | 430.0 ± 0.4% | 0.312 | 0.278 | 2.160 |
| string: dickens as Cyrillic and CJK | 1883069 | 794.1 ± 0.2% | 4387.3 ± 0.4% | 727.6 ± 4.8% | 294.7 ± 3.1% | 0.181 | 1.091 | 2.695 |
| hex: silesia/dickens | 524290 | 13800.5 ± 1.1% | 13178.6 ± 0.2% | 4162.8 ± 0.1% | 492.5 ± 0.6% | 1.047 | 3.315 | 28.020 |
| hex: silesia/mozilla | 524290 | 13812.2 ± 0.3% | 13200.0 ± 0.2% | 4182.5 ± 0.1% | 432.5 ± 0.1% | 1.046 | 3.302 | 31.939 |
| hex: silesia/mr | 524290 | 13783.0 ± 0.3% | 13180.6 ± 0.2% | 4202.0 ± 0.3% | 608.4 ± 0.1% | 1.046 | 3.280 | 22.653 |
| hex: silesia/nci | 524290 | 13821.3 ± 1.4% | 13200.2 ± 0.2% | 4154.5 ± 0.3% | 729.3 ± 0.2% | 1.047 | 3.327 | 18.952 |
| hex: silesia/ooffice | 524290 | 13800.0 ± 0.1% | 13168.1 ± 0.1% | 4203.2 ± 0.1% | 380.6 ± 0.4% | 1.048 | 3.283 | 36.260 |
| hex: silesia/osdb | 524290 | 13822.9 ± 0.6% | 13202.8 ± 0.6% | 4172.5 ± 0.3% | 489.7 ± 0.2% | 1.047 | 3.313 | 28.229 |
| hex: silesia/reymont | 524290 | 13804.0 ± 0.2% | 13164.3 ± 0.2% | 4164.2 ± 0.1% | 522.2 ± 0.8% | 1.049 | 3.315 | 26.436 |
| hex: silesia/samba | 524290 | 13839.0 ± 0.8% | 13166.7 ± 0.2% | 4202.8 ± 0.1% | 372.6 ± 3.7% | 1.051 | 3.293 | 37.137 |
| hex: silesia/sao | 524290 | 13780.8 ± 0.2% | 13152.8 ± 0.3% | 4195.6 ± 0.2% | 305.7 ± 0.1% | 1.048 | 3.285 | 45.080 |
| hex: silesia/webster | 524290 | 13837.6 ± 0.1% | 13205.7 ± 0.8% | 4154.8 ± 0.4% | 471.2 ± 0.5% | 1.048 | 3.330 | 29.368 |
| hex: silesia/x-ray | 524290 | 13696.8 ± 0.4% | 13165.3 ± 0.2% | 4199.4 ± 0.1% | 462.5 ± 4.1% | 1.040 | 3.262 | 29.617 |
| hex: silesia/xml | 524290 | 13742.4 ± 0.3% | 13141.9 ± 14.0% | 4145.2 ± 2.5% | 715.6 ± 1.4% | 1.046 | 3.315 | 19.204 |
| hex: canterbury/alice29.txt | 304180 | 13747.4 ± 0.4% | 14007.4 ± 0.2% | 4179.0 ± 0.1% | 490.7 ± 0.5% | 0.981 | 3.290 | 28.016 |
| hex: canterbury/asyoulik.txt | 250360 | 13880.5 ± 0.2% | 13388.8 ± 0.2% | 4145.6 ± 0.9% | 483.1 ± 0.3% | 1.037 | 3.348 | 28.734 |
| hex: canterbury/cp.html | 49208 | 13571.5 ± 0.7% | 13714.2 ± 0.2% | 4215.7 ± 0.3% | 627.1 ± 0.7% | 0.990 | 3.219 | 21.642 |
| hex: canterbury/fields.c | 22302 | 13255.7 ± 0.4% | 13393.0 ± 0.1% | 4213.3 ± 1.4% | 748.3 ± 2.0% | 0.990 | 3.146 | 17.715 |
| hex: canterbury/grammar.lsp | 7444 | 12555.7 ± 0.6% | 12975.4 ± 0.1% | 4212.9 ± 0.1% | 743.8 ± 0.5% | 0.968 | 2.980 | 16.880 |
| hex: canterbury/kennedy.xls | 524290 | 13811.2 ± 0.4% | 13205.9 ± 0.4% | 4178.5 ± 0.1% | 719.1 ± 0.1% | 1.046 | 3.305 | 19.206 |
| hex: canterbury/lcet10.txt | 524290 | 13658.7 ± 0.1% | 13194.6 ± 0.2% | 4212.5 ± 0.2% | 447.6 ± 6.6% | 1.035 | 3.242 | 30.513 |
| hex: canterbury/plrabn12.txt | 524290 | 13779.9 ± 0.4% | 13203.9 ± 0.2% | 4188.3 ± 0.2% | 481.6 ± 0.2% | 1.044 | 3.290 | 28.610 |
| hex: canterbury/ptt5 | 524290 | 13741.9 ± 1.5% | 13174.1 ± 0.5% | 4139.1 ± 0.3% | 606.2 ± 0.7% | 1.043 | 3.320 | 22.667 |
| hex: canterbury/sum | 76482 | 13698.4 ± 0.1% | 12873.6 ± 0.3% | 4225.9 ± 0.1% | 684.2 ± 0.7% | 1.064 | 3.242 | 20.022 |
| hex: canterbury/xargs.1 | 8456 | 12753.4 ± 0.1% | 13128.4 ± 0.5% | 4187.4 ± 0.5% | 752.7 ± 0.3% | 0.971 | 3.046 | 16.943 |
| hex: canterbury-large/E.coli | 524290 | 13794.9 ± 0.6% | 13124.7 ± 0.2% | 4157.5 ± 0.2% | 803.2 ± 0.6% | 1.051 | 3.318 | 17.174 |
| hex: canterbury-large/bible.txt | 524290 | 13779.2 ± 0.5% | 13048.2 ± 0.2% | 4152.5 ± 0.1% | 450.3 ± 0.4% | 1.056 | 3.318 | 30.603 |
| hex: canterbury-large/world192.txt | 524290 | 13832.2 ± 0.2% | 13082.3 ± 0.1% | 4197.6 ± 0.5% | 487.8 ± 0.1% | 1.057 | 3.295 | 28.356 |
| hex: http/html-1k | 2050 | 9797.7 ± 0.2% | 11447.5 ± 0.5% | 4028.5 ± 0.3% | 745.1 ± 0.2% | 0.856 | 2.432 | 13.149 |
| hex: http/html-16k | 32770 | 13437.9 ± 0.1% | 13359.4 ± 0.1% | 4110.0 ± 0.1% | 750.6 ± 1.0% | 1.006 | 3.270 | 17.903 |
| hex: http/html-1m | 524290 | 13814.2 ± 0.3% | 13125.9 ± 0.3% | 4150.5 ± 0.5% | 518.7 ± 0.6% | 1.052 | 3.328 | 26.634 |
| hex: http/json-1k | 2050 | 9513.8 ± 0.3% | 11453.5 ± 0.2% | 4023.5 ± 5.1% | 730.8 ± 22.2% | 0.831 | 2.365 | 13.018 |
| hex: http/json-16k | 32770 | 13434.3 ± 0.5% | 13524.8 ± 0.3% | 4151.6 ± 0.1% | 720.4 ± 0.1% | 0.993 | 3.236 | 18.648 |
| hex: http/json-1m | 524290 | 13759.6 ± 3.5% | 12796.1 ± 0.6% | 4152.7 ± 0.4% | 718.7 ± 1.3% | 1.075 | 3.313 | 19.145 |
| hex: http/js-1k | 2050 | 9805.2 ± 4.7% | 11449.5 ± 0.3% | 3978.5 ± 0.8% | 750.7 ± 13.0% | 0.856 | 2.465 | 13.062 |
| hex: http/js-16k | 32770 | 13418.6 ± 12.9% | 13446.2 ± 0.2% | 4135.5 ± 0.1% | 740.4 ± 4.2% | 0.998 | 3.245 | 18.123 |
| hex: http/js-1m | 524290 | 13758.4 ± 0.2% | 13227.6 ± 0.3% | 4146.6 ± 0.3% | 526.5 ± 0.4% | 1.040 | 3.318 | 26.131 |
| hex: http/css-1k | 2050 | 9485.2 ± 1.9% | 11459.0 ± 2.3% | 3957.7 ± 3.0% | 746.6 ± 3.0% | 0.828 | 2.397 | 12.704 |
| hex: http/css-16k | 32770 | 13415.6 ± 0.8% | 13488.7 ± 0.2% | 4152.7 ± 0.3% | 752.8 ± 0.2% | 0.995 | 3.231 | 17.821 |
| hex: http/css-1m | 524290 | 13751.1 ± 0.5% | 13082.3 ± 0.3% | 4165.6 ± 0.1% | 572.6 ± 0.3% | 1.051 | 3.301 | 24.013 |
| hex: shuffled/dickens-1m | 524290 | 13827.2 ± 0.5% | 13097.8 ± 0.1% | 4188.5 ± 0.2% | 501.4 ± 0.1% | 1.056 | 3.301 | 27.580 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 251.4 ± 0.2% | 1182.0 ± 0.4% | 1143.8 ± 0.8% | 428.1 ± 0.6% | 0.213 | 0.220 | 0.587 |
| qlog records, JSON text sequence | 1467503 | 227.8 ± 0.1% | 1064.2 ± 0.2% | 898.6 ± 0.4% | 426.4 ± 0.9% | 0.214 | 0.254 | 0.534 |
| string: silesia/dickens | 172528 | 1483.6 ± 1.4% | 4109.5 ± 0.2% | 3731.0 ± 0.9% | 400.1 ± 2.6% | 0.361 | 0.398 | 3.709 |
| string: silesia/nci | 1075110 | 2133.4 ± 0.5% | 4852.2 ± 0.5% | 3656.3 ± 0.3% | 949.7 ± 1.6% | 0.440 | 0.583 | 2.246 |
| string: silesia/reymont | 1075159 | 1470.1 ± 0.8% | 2672.1 ± 0.3% | 2031.8 ± 2.7% | 372.9 ± 0.4% | 0.550 | 0.724 | 3.942 |
| string: silesia/samba | 97582 | 683.4 ± 0.5% | 2097.7 ± 0.4% | 3859.7 ± 0.8% | 492.1 ± 0.1% | 0.326 | 0.177 | 1.389 |
| string: silesia/webster | 1098490 | 1054.3 ± 2.0% | 2353.8 ± 0.5% | 2083.1 ± 3.0% | 372.4 ± 0.6% | 0.448 | 0.506 | 2.831 |
| string: silesia/xml | 1090118 | 2097.8 ± 0.8% | 4975.6 ± 0.5% | 2984.9 ± 3.8% | 606.9 ± 1.4% | 0.422 | 0.703 | 3.456 |
| string: canterbury/alice29.txt | 159425 | 1169.4 ± 0.5% | 3288.4 ± 0.1% | 3462.3 ± 0.1% | 379.8 ± 3.8% | 0.356 | 0.338 | 3.079 |
| string: canterbury/asyoulik.txt | 132198 | 1016.9 ± 0.5% | 2935.5 ± 0.3% | 3311.8 ± 3.3% | 449.0 ± 4.5% | 0.346 | 0.307 | 2.265 |
| string: canterbury/lcet10.txt | 441884 | 1394.0 ± 1.2% | 4116.7 ± 16.3% | 2909.1 ± 2.1% | 432.1 ± 0.6% | 0.339 | 0.479 | 3.226 |
| string: canterbury/plrabn12.txt | 503330 | 1293.2 ± 2.3% | 3206.7 ± 0.4% | 2349.0 ± 0.6% | 399.5 ± 0.8% | 0.403 | 0.551 | 3.237 |
| string: canterbury-large/E.coli | 1048578 | 12980.3 ± 0.3% | 10775.5 ± 0.7% | 4166.9 ± 0.1% | 1647.4 ± 0.3% | 1.205 | 3.115 | 7.879 |
| string: canterbury-large/bible.txt | 1055886 | 3957.5 ± 16.0% | 9012.8 ± 18.7% | 3238.4 ± 0.6% | 484.0 ± 0.2% | 0.439 | 1.222 | 8.177 |
| string: canterbury-large/world192.txt | 1103121 | 964.2 ± 0.4% | 2226.3 ± 3.6% | 2149.9 ± 1.6% | 420.7 ± 1.7% | 0.433 | 0.448 | 2.292 |
| string: http/html-1m | 1058582 | 3477.6 ± 0.8% | 7889.3 ± 1.5% | 3114.4 ± 1.2% | 461.8 ± 0.6% | 0.441 | 1.117 | 7.530 |
| string: http/json-1m | 1190272 | 543.4 ± 0.9% | 1400.8 ± 0.3% | 2161.0 ± 0.8% | 476.2 ± 1.7% | 0.388 | 0.251 | 1.141 |
| string: http/js-1m | 1144362 | 599.7 ± 0.6% | 1381.8 ± 0.0% | 1501.2 ± 4.0% | 353.1 ± 2.6% | 0.434 | 0.400 | 1.698 |
| string: http/css-1m | 1097820 | 1211.0 ± 0.7% | 3214.4 ± 0.3% | 3372.1 ± 0.4% | 552.1 ± 2.3% | 0.377 | 0.359 | 2.193 |
| string: dickens as Cyrillic and CJK | 1883069 | 814.2 ± 0.2% | 4061.8 ± 0.6% | 497.1 ± 0.2% | 306.0 ± 0.5% | 0.200 | 1.638 | 2.661 |
| hex: silesia/dickens | 524290 | 23043.9 ± 0.2% | 2000.5 ± 0.2% | 1378.3 ± 0.2% | 502.8 ± 0.6% | 11.519 | 16.719 | 45.828 |
| hex: silesia/mozilla | 524290 | 23142.5 ± 0.3% | 1998.2 ± 10.5% | 1379.2 ± 24.6% | 443.3 ± 1.7% | 11.582 | 16.780 | 52.208 |
| hex: silesia/mr | 524290 | 23293.4 ± 0.1% | 2001.8 ± 0.2% | 1378.0 ± 0.2% | 611.4 ± 9.4% | 11.636 | 16.904 | 38.100 |
| hex: silesia/nci | 524290 | 23216.0 ± 0.3% | 1999.4 ± 0.2% | 1378.3 ± 0.2% | 732.4 ± 0.9% | 11.612 | 16.844 | 31.698 |
| hex: silesia/ooffice | 524290 | 23128.3 ± 0.3% | 1995.1 ± 11.0% | 1378.3 ± 3.8% | 386.3 ± 19.8% | 11.593 | 16.780 | 59.864 |
| hex: silesia/osdb | 524290 | 22587.1 ± 0.3% | 1999.2 ± 0.3% | 1379.3 ± 0.8% | 501.5 ± 0.3% | 11.298 | 16.376 | 45.038 |
| hex: silesia/reymont | 524290 | 23275.2 ± 0.2% | 1999.8 ± 14.2% | 1378.3 ± 0.0% | 529.4 ± 0.1% | 11.639 | 16.887 | 43.965 |
| hex: silesia/samba | 524290 | 23079.0 ± 0.1% | 2000.7 ± 0.3% | 1377.9 ± 0.7% | 395.4 ± 0.1% | 11.536 | 16.749 | 58.371 |
| hex: silesia/sao | 524290 | 22999.0 ± 0.4% | 1995.2 ± 0.9% | 1376.6 ± 0.6% | 313.9 ± 17.7% | 11.527 | 16.707 | 73.268 |
| hex: silesia/webster | 524290 | 23147.1 ± 4.0% | 2002.1 ± 0.2% | 1379.7 ± 0.1% | 483.6 ± 2.1% | 11.562 | 16.777 | 47.860 |
| hex: silesia/x-ray | 524290 | 23271.2 ± 0.2% | 2003.6 ± 0.7% | 1380.9 ± 0.2% | 464.5 ± 0.2% | 11.615 | 16.852 | 50.105 |
| hex: silesia/xml | 524290 | 23279.5 ± 0.2% | 1999.6 ± 0.3% | 1378.0 ± 0.2% | 733.7 ± 0.4% | 11.642 | 16.894 | 31.727 |
| hex: canterbury/alice29.txt | 304180 | 22703.7 ± 0.6% | 2025.2 ± 0.2% | 1378.9 ± 0.3% | 505.1 ± 0.6% | 11.210 | 16.465 | 44.953 |
| hex: canterbury/asyoulik.txt | 250360 | 23207.2 ± 0.3% | 2023.7 ± 0.4% | 1394.6 ± 0.1% | 501.3 ± 0.3% | 11.468 | 16.640 | 46.295 |
| hex: canterbury/cp.html | 49208 | 22593.1 ± 0.4% | 1885.4 ± 0.4% | 1325.2 ± 0.8% | 766.4 ± 0.2% | 11.983 | 17.049 | 29.478 |
| hex: canterbury/fields.c | 22302 | 21728.1 ± 0.3% | 1937.4 ± 0.2% | 1346.9 ± 1.6% | 758.8 ± 0.6% | 11.215 | 16.132 | 28.634 |
| hex: canterbury/grammar.lsp | 7444 | 20513.7 ± 1.6% | 1960.9 ± 0.1% | 1366.1 ± 0.2% | 754.5 ± 0.1% | 10.461 | 15.017 | 27.190 |
| hex: canterbury/kennedy.xls | 524290 | 23288.8 ± 10.6% | 2001.5 ± 0.3% | 1378.4 ± 0.1% | 725.9 ± 0.2% | 11.636 | 16.895 | 32.082 |
| hex: canterbury/lcet10.txt | 524290 | 22871.9 ± 3.2% | 2004.7 ± 0.2% | 1380.1 ± 0.1% | 505.7 ± 2.6% | 11.409 | 16.573 | 45.229 |
| hex: canterbury/plrabn12.txt | 524290 | 22984.8 ± 0.1% | 1992.8 ± 0.8% | 1375.3 ± 0.2% | 492.2 ± 7.2% | 11.534 | 16.712 | 46.696 |
| hex: canterbury/ptt5 | 524290 | 23295.3 ± 0.7% | 2000.7 ± 0.1% | 1379.6 ± 0.1% | 624.7 ± 8.8% | 11.643 | 16.886 | 37.293 |
| hex: canterbury/sum | 76482 | 22952.1 ± 0.3% | 1917.8 ± 0.4% | 1336.2 ± 0.1% | 747.4 ± 0.4% | 11.968 | 17.177 | 30.710 |
| hex: canterbury/xargs.1 | 8456 | 20057.3 ± 0.2% | 1923.6 ± 0.2% | 1325.5 ± 0.2% | 762.1 ± 0.1% | 10.427 | 15.132 | 26.320 |
| hex: canterbury-large/E.coli | 524290 | 22994.4 ± 0.1% | 1997.1 ± 0.3% | 1379.6 ± 0.6% | 733.6 ± 5.3% | 11.514 | 16.667 | 31.345 |
| hex: canterbury-large/bible.txt | 524290 | 23104.3 ± 3.1% | 2001.2 ± 0.1% | 1378.5 ± 0.1% | 519.3 ± 0.3% | 11.545 | 16.760 | 44.489 |
| hex: canterbury-large/world192.txt | 524290 | 23061.6 ± 0.2% | 2000.6 ± 6.4% | 1379.5 ± 0.1% | 506.4 ± 0.2% | 11.527 | 16.718 | 45.538 |
| hex: http/html-1k | 2050 | 16245.0 ± 0.2% | 1905.5 ± 0.4% | 1316.6 ± 0.8% | 759.3 ± 0.2% | 8.526 | 12.339 | 21.395 |
| hex: http/html-16k | 32770 | 22314.1 ± 0.9% | 1907.9 ± 0.2% | 1371.1 ± 0.9% | 766.5 ± 0.1% | 11.695 | 16.274 | 29.110 |
| hex: http/html-1m | 524290 | 23124.0 ± 0.4% | 1994.0 ± 0.4% | 1374.4 ± 0.6% | 531.7 ± 0.2% | 11.597 | 16.825 | 43.494 |
| hex: http/json-1k | 2050 | 16413.3 ± 0.2% | 1904.1 ± 0.2% | 1316.4 ± 0.3% | 741.5 ± 0.6% | 8.620 | 12.468 | 22.135 |
| hex: http/json-16k | 32770 | 22464.9 ± 0.2% | 1874.9 ± 0.1% | 1319.7 ± 0.1% | 726.8 ± 0.4% | 11.982 | 17.022 | 30.909 |
| hex: http/json-1m | 524290 | 22580.7 ± 0.2% | 1999.1 ± 0.5% | 1377.4 ± 0.1% | 724.5 ± 0.5% | 11.295 | 16.394 | 31.166 |
| hex: http/js-1k | 2050 | 16094.6 ± 0.8% | 1904.4 ± 0.3% | 1319.3 ± 0.5% | 764.7 ± 0.5% | 8.451 | 12.199 | 21.046 |
| hex: http/js-16k | 32770 | 22358.6 ± 0.3% | 1907.8 ± 0.8% | 1334.6 ± 0.1% | 758.1 ± 0.2% | 11.719 | 16.753 | 29.491 |
| hex: http/js-1m | 524290 | 23223.1 ± 0.4% | 1996.2 ± 13.1% | 1374.4 ± 0.3% | 542.1 ± 0.4% | 11.633 | 16.897 | 42.842 |
| hex: http/css-1k | 2050 | 16456.7 ± 0.3% | 1903.2 ± 0.3% | 1302.8 ± 0.7% | 757.9 ± 0.2% | 8.647 | 12.632 | 21.713 |
| hex: http/css-16k | 32770 | 22272.1 ± 0.2% | 1877.5 ± 0.2% | 1321.7 ± 0.1% | 764.6 ± 0.1% | 11.862 | 16.851 | 29.130 |
| hex: http/css-1m | 524290 | 23268.5 ± 0.6% | 2003.4 ± 0.5% | 1378.4 ± 0.1% | 589.1 ± 0.3% | 11.614 | 16.881 | 39.501 |
| hex: shuffled/dickens-1m | 524290 | 23298.7 ± 0.2% | 1994.5 ± 0.3% | 1376.8 ± 0.3% | 505.2 ± 0.1% | 11.681 | 16.922 | 46.114 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.151 of simdjson.
- CLDR supplemental, 34 texts, decoding: stdx runs at 0.161 of yyjson.
- CLDR supplemental, 34 texts, decoding: stdx runs at 0.531 of std.json.
- qlog records, JSON text sequence, decoding: stdx runs at 0.155 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.131 of yyjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.461 of std.json.
- string: silesia/dickens, decoding: stdx runs at 0.355 of simdjson.
- string: silesia/dickens, decoding: stdx runs at 0.394 of yyjson.
- string: silesia/nci, decoding: stdx runs at 0.380 of simdjson.
- string: silesia/nci, decoding: stdx runs at 0.477 of yyjson.
- string: silesia/reymont, decoding: stdx runs at 0.262 of simdjson.
- string: silesia/reymont, decoding: stdx runs at 0.590 of yyjson.
- string: silesia/samba, decoding: stdx runs at 0.153 of simdjson.
- string: silesia/samba, decoding: stdx runs at 0.106 of yyjson.
- string: silesia/samba, decoding: stdx runs at 0.852 of std.json.
- string: silesia/webster, decoding: stdx runs at 0.311 of simdjson.
- string: silesia/webster, decoding: stdx runs at 0.450 of yyjson.
- string: silesia/xml, decoding: stdx runs at 0.302 of simdjson.
- string: silesia/xml, decoding: stdx runs at 0.530 of yyjson.
- string: canterbury/alice29.txt, decoding: stdx runs at 0.335 of simdjson.
- string: canterbury/alice29.txt, decoding: stdx runs at 0.283 of yyjson.
- string: canterbury/asyoulik.txt, decoding: stdx runs at 0.321 of simdjson.
- string: canterbury/asyoulik.txt, decoding: stdx runs at 0.286 of yyjson.
- string: canterbury/lcet10.txt, decoding: stdx runs at 0.345 of simdjson.
- string: canterbury/lcet10.txt, decoding: stdx runs at 0.470 of yyjson.
- string: canterbury/plrabn12.txt, decoding: stdx runs at 0.344 of simdjson.
- string: canterbury/plrabn12.txt, decoding: stdx runs at 0.521 of yyjson.
- string: canterbury-large/bible.txt, decoding: stdx runs at 0.382 of simdjson.
- string: canterbury-large/world192.txt, decoding: stdx runs at 0.337 of simdjson.
- string: canterbury-large/world192.txt, decoding: stdx runs at 0.420 of yyjson.
- string: http/html-1m, decoding: stdx runs at 0.384 of simdjson.
- string: http/json-1m, decoding: stdx runs at 0.317 of simdjson.
- string: http/json-1m, decoding: stdx runs at 0.196 of yyjson.
- string: http/js-1m, decoding: stdx runs at 0.293 of simdjson.
- string: http/js-1m, decoding: stdx runs at 0.340 of yyjson.
- string: http/css-1m, decoding: stdx runs at 0.312 of simdjson.
- string: http/css-1m, decoding: stdx runs at 0.278 of yyjson.
- string: dickens as Cyrillic and CJK, decoding: stdx runs at 0.181 of simdjson.
- hex: http/html-1k, decoding: stdx runs at 0.856 of simdjson.
- hex: http/json-1k, decoding: stdx runs at 0.831 of simdjson.
- hex: http/js-1k, decoding: stdx runs at 0.856 of simdjson.
- hex: http/css-1k, decoding: stdx runs at 0.828 of simdjson.
- CLDR supplemental, 34 texts, encoding: stdx runs at 0.213 of simdjson.
- CLDR supplemental, 34 texts, encoding: stdx runs at 0.220 of yyjson.
- CLDR supplemental, 34 texts, encoding: stdx runs at 0.587 of std.json.
- qlog records, JSON text sequence, encoding: stdx runs at 0.214 of simdjson.
- qlog records, JSON text sequence, encoding: stdx runs at 0.254 of yyjson.
- qlog records, JSON text sequence, encoding: stdx runs at 0.534 of std.json.
- string: silesia/dickens, encoding: stdx runs at 0.361 of simdjson.
- string: silesia/dickens, encoding: stdx runs at 0.398 of yyjson.
- string: silesia/nci, encoding: stdx runs at 0.440 of simdjson.
- string: silesia/nci, encoding: stdx runs at 0.583 of yyjson.
- string: silesia/reymont, encoding: stdx runs at 0.550 of simdjson.
- string: silesia/reymont, encoding: stdx runs at 0.724 of yyjson.
- string: silesia/samba, encoding: stdx runs at 0.326 of simdjson.
- string: silesia/samba, encoding: stdx runs at 0.177 of yyjson.
- string: silesia/webster, encoding: stdx runs at 0.448 of simdjson.
- string: silesia/webster, encoding: stdx runs at 0.506 of yyjson.
- string: silesia/xml, encoding: stdx runs at 0.422 of simdjson.
- string: silesia/xml, encoding: stdx runs at 0.703 of yyjson.
- string: canterbury/alice29.txt, encoding: stdx runs at 0.356 of simdjson.
- string: canterbury/alice29.txt, encoding: stdx runs at 0.338 of yyjson.
- string: canterbury/asyoulik.txt, encoding: stdx runs at 0.346 of simdjson.
- string: canterbury/asyoulik.txt, encoding: stdx runs at 0.307 of yyjson.
- string: canterbury/lcet10.txt, encoding: stdx runs at 0.339 of simdjson.
- string: canterbury/lcet10.txt, encoding: stdx runs at 0.479 of yyjson.
- string: canterbury/plrabn12.txt, encoding: stdx runs at 0.403 of simdjson.
- string: canterbury/plrabn12.txt, encoding: stdx runs at 0.551 of yyjson.
- string: canterbury-large/bible.txt, encoding: stdx runs at 0.439 of simdjson.
- string: canterbury-large/world192.txt, encoding: stdx runs at 0.433 of simdjson.
- string: canterbury-large/world192.txt, encoding: stdx runs at 0.448 of yyjson.
- string: http/html-1m, encoding: stdx runs at 0.441 of simdjson.
- string: http/json-1m, encoding: stdx runs at 0.388 of simdjson.
- string: http/json-1m, encoding: stdx runs at 0.251 of yyjson.
- string: http/js-1m, encoding: stdx runs at 0.434 of simdjson.
- string: http/js-1m, encoding: stdx runs at 0.400 of yyjson.
- string: http/css-1m, encoding: stdx runs at 0.377 of simdjson.
- string: http/css-1m, encoding: stdx runs at 0.359 of yyjson.
- string: dickens as Cyrillic and CJK, encoding: stdx runs at 0.200 of simdjson.
