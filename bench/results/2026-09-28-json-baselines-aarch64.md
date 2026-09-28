# bench-json

| Field | Value |
|---|---|
| Commit | e468bb5 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260920.129.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/36439380850 |
| Date | 2026-09-28 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the vector path lost. Octets are the text's.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | All off |
|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 154.5 ± 0.1% | 0.623 | 0.998 | 0.623 |
| qlog records, JSON text sequence | 1467503 | 109.8 ± 0.5% | 0.736 | 0.994 | 0.735 |
| string: silesia/dickens | 172528 | 964.4 ± 0.3% | 0.156 | 0.999 | 0.156 |
| string: silesia/nci | 1075110 | 1148.3 ± 0.7% | 0.131 | 1.000 | 0.131 |
| string: silesia/reymont | 1075159 | 1038.6 ± 0.6% | 0.145 | 1.001 | 0.145 |
| string: silesia/samba | 97582 | 245.2 ± 0.5% | 0.545 | 1.000 | 0.547 |
| string: silesia/webster | 1098490 | 717.7 ± 0.2% | 0.204 | 1.000 | 0.204 |
| string: silesia/xml | 1090118 | 1054.9 ± 0.3% | 0.143 | 1.000 | 0.142 |
| string: canterbury/alice29.txt | 159425 | 722.5 ± 0.3% | 0.204 | 0.999 | 0.204 |
| string: canterbury/asyoulik.txt | 132198 | 598.7 ± 0.1% | 0.241 | 1.000 | 0.240 |
| string: canterbury/lcet10.txt | 441884 | 940.8 ± 0.8% | 0.160 | 1.002 | 0.160 |
| string: canterbury/plrabn12.txt | 503330 | 777.9 ± 0.2% | 0.190 | 1.000 | 0.190 |
| string: canterbury-large/E.coli | 1048578 | 7290.8 ± 0.2% | 0.022 | 1.001 | 0.022 |
| string: canterbury-large/bible.txt | 1055886 | 2574.9 ± 0.4% | 0.060 | 1.003 | 0.061 |
| string: canterbury-large/world192.txt | 1103121 | 655.9 ± 0.5% | 0.223 | 1.000 | 0.222 |
| string: http/html-1m | 1058582 | 2178.3 ± 0.3% | 0.071 | 0.996 | 0.071 |
| string: http/json-1m | 1190272 | 283.4 ± 1.4% | 0.449 | 0.997 | 0.446 |
| string: http/js-1m | 1144362 | 390.3 ± 0.4% | 0.352 | 0.999 | 0.351 |
| string: http/css-1m | 1097820 | 643.3 ± 0.4% | 0.225 | 0.999 | 0.225 |
| string: dickens as Cyrillic and CJK | 1883069 | 631.0 ± 0.2% | 0.194 | 0.184 | 0.194 |
| hex: silesia/dickens | 524290 | 7441.7 ± 0.3% | 0.021 | 1.001 | 0.021 |
| hex: silesia/mozilla | 524290 | 7402.8 ± 0.3% | 0.021 | 1.000 | 0.021 |
| hex: silesia/mr | 524290 | 7308.8 ± 0.4% | 0.022 | 1.003 | 0.022 |
| hex: silesia/nci | 524290 | 7438.3 ± 0.6% | 0.021 | 1.000 | 0.021 |
| hex: silesia/ooffice | 524290 | 7363.8 ± 0.3% | 0.021 | 1.002 | 0.022 |
| hex: silesia/osdb | 524290 | 7563.8 ± 0.3% | 0.021 | 1.000 | 0.021 |
| hex: silesia/reymont | 524290 | 7297.6 ± 0.9% | 0.022 | 1.002 | 0.022 |
| hex: silesia/samba | 524290 | 7576.6 ± 0.7% | 0.021 | 0.999 | 0.021 |
| hex: silesia/sao | 524290 | 7441.8 ± 0.3% | 0.021 | 1.002 | 0.021 |
| hex: silesia/webster | 524290 | 7477.0 ± 0.4% | 0.021 | 1.000 | 0.021 |
| hex: silesia/x-ray | 524290 | 7320.8 ± 0.2% | 0.022 | 1.001 | 0.022 |
| hex: silesia/xml | 524290 | 7531.0 ± 0.4% | 0.021 | 0.999 | 0.021 |
| hex: canterbury/alice29.txt | 304180 | 7569.7 ± 1.5% | 0.021 | 1.008 | 0.021 |
| hex: canterbury/asyoulik.txt | 250360 | 7637.4 ± 1.2% | 0.021 | 1.008 | 0.021 |
| hex: canterbury/cp.html | 49208 | 7500.8 ± 1.4% | 0.021 | 1.008 | 0.021 |
| hex: canterbury/fields.c | 22302 | 7299.8 ± 0.8% | 0.022 | 1.007 | 0.022 |
| hex: canterbury/grammar.lsp | 7444 | 6945.8 ± 1.1% | 0.023 | 0.995 | 0.023 |
| hex: canterbury/kennedy.xls | 524290 | 7555.0 ± 0.3% | 0.021 | 0.998 | 0.021 |
| hex: canterbury/lcet10.txt | 524290 | 7190.6 ± 0.4% | 0.022 | 1.000 | 0.022 |
| hex: canterbury/plrabn12.txt | 524290 | 7616.9 ± 0.9% | 0.021 | 1.002 | 0.021 |
| hex: canterbury/ptt5 | 524290 | 7603.1 ± 0.3% | 0.021 | 0.999 | 0.021 |
| hex: canterbury/sum | 76482 | 7593.7 ± 0.5% | 0.021 | 1.004 | 0.021 |
| hex: canterbury/xargs.1 | 8456 | 6935.5 ± 0.5% | 0.023 | 1.000 | 0.023 |
| hex: canterbury-large/E.coli | 524290 | 7351.7 ± 0.3% | 0.022 | 1.006 | 0.022 |
| hex: canterbury-large/bible.txt | 524290 | 7335.8 ± 0.5% | 0.022 | 0.998 | 0.022 |
| hex: canterbury-large/world192.txt | 524290 | 7413.7 ± 0.6% | 0.021 | 1.001 | 0.021 |
| hex: http/html-1k | 2050 | 5722.6 ± 0.7% | 0.028 | 0.999 | 0.028 |
| hex: http/html-16k | 32770 | 7451.0 ± 1.6% | 0.021 | 1.000 | 0.021 |
| hex: http/html-1m | 524290 | 7338.3 ± 0.3% | 0.022 | 1.002 | 0.022 |
| hex: http/json-1k | 2050 | 5720.1 ± 0.4% | 0.028 | 0.999 | 0.028 |
| hex: http/json-16k | 32770 | 7448.1 ± 1.8% | 0.021 | 1.001 | 0.021 |
| hex: http/json-1m | 524290 | 7460.0 ± 1.0% | 0.021 | 1.002 | 0.021 |
| hex: http/js-1k | 2050 | 5706.5 ± 0.2% | 0.028 | 1.003 | 0.028 |
| hex: http/js-16k | 32770 | 7482.3 ± 1.5% | 0.021 | 0.997 | 0.021 |
| hex: http/js-1m | 524290 | 7611.4 ± 0.5% | 0.021 | 0.998 | 0.021 |
| hex: http/css-1k | 2050 | 5703.7 ± 0.3% | 0.028 | 1.002 | 0.028 |
| hex: http/css-16k | 32770 | 7484.1 ± 0.4% | 0.021 | 0.996 | 0.021 |
| hex: http/css-1m | 524290 | 7261.5 ± 0.8% | 0.022 | 1.002 | 0.022 |
| hex: shuffled/dickens-1m | 524290 | 7489.9 ± 0.4% | 0.021 | 1.000 | 0.021 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the vector path lost. Octets are the ones written.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | All off |
|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 221.6 ± 0.8% | 0.700 | 0.992 | 0.991 | 0.681 |
| qlog records, JSON text sequence | 1467503 | 195.2 ± 1.1% | 0.766 | 0.999 | 1.004 | 0.753 |
| string: silesia/dickens | 172528 | 1127.8 ± 0.3% | 0.200 | 1.001 | 0.988 | 0.199 |
| string: silesia/nci | 1075110 | 1515.6 ± 0.4% | 0.145 | 0.999 | 0.990 | 0.147 |
| string: silesia/reymont | 1075159 | 1286.0 ± 0.5% | 0.176 | 1.003 | 0.996 | 0.173 |
| string: silesia/samba | 97582 | 501.1 ± 0.2% | 0.551 | 1.000 | 0.972 | 0.549 |
| string: silesia/webster | 1098490 | 838.2 ± 0.3% | 0.263 | 1.001 | 0.984 | 0.262 |
| string: silesia/xml | 1090118 | 1521.5 ± 0.2% | 0.150 | 1.001 | 0.983 | 0.147 |
| string: canterbury/alice29.txt | 159425 | 847.4 ± 0.1% | 0.262 | 0.999 | 0.984 | 0.261 |
| string: canterbury/asyoulik.txt | 132198 | 728.7 ± 0.3% | 0.296 | 0.998 | 0.982 | 0.294 |
| string: canterbury/lcet10.txt | 441884 | 1095.7 ± 0.4% | 0.205 | 1.001 | 0.988 | 0.203 |
| string: canterbury/plrabn12.txt | 503330 | 952.8 ± 0.7% | 0.233 | 0.998 | 0.989 | 0.232 |
| string: canterbury-large/E.coli | 1048578 | 7269.4 ± 0.4% | 0.033 | 1.003 | 1.003 | 0.032 |
| string: canterbury-large/bible.txt | 1055886 | 3035.3 ± 0.2% | 0.076 | 0.997 | 0.991 | 0.076 |
| string: canterbury-large/world192.txt | 1103121 | 764.2 ± 0.6% | 0.288 | 1.003 | 0.984 | 0.282 |
| string: http/html-1m | 1058582 | 2529.9 ± 0.2% | 0.090 | 0.997 | 0.984 | 0.091 |
| string: http/json-1m | 1190272 | 396.6 ± 0.5% | 0.503 | 0.997 | 0.975 | 0.496 |
| string: http/js-1m | 1144362 | 446.2 ± 0.3% | 0.450 | 0.996 | 0.980 | 0.451 |
| string: http/css-1m | 1097820 | 844.1 ± 0.1% | 0.250 | 1.000 | 0.986 | 0.250 |
| string: dickens as Cyrillic and CJK | 1883069 | 618.8 ± 0.1% | 0.288 | 1.002 | 0.161 | 0.288 |
| hex: silesia/dickens | 524290 | 15601.0 ± 0.1% | 0.999 | 0.178 | 0.999 | 0.179 |
| hex: silesia/mozilla | 524290 | 15568.3 ± 0.3% | 1.000 | 0.179 | 1.000 | 0.179 |
| hex: silesia/mr | 524290 | 15583.5 ± 0.1% | 0.997 | 0.179 | 1.001 | 0.179 |
| hex: silesia/nci | 524290 | 15513.0 ± 0.2% | 1.000 | 0.179 | 1.000 | 0.179 |
| hex: silesia/ooffice | 524290 | 15528.0 ± 0.2% | 1.001 | 0.179 | 0.999 | 0.179 |
| hex: silesia/osdb | 524290 | 15458.8 ± 0.2% | 1.001 | 0.180 | 1.001 | 0.180 |
| hex: silesia/reymont | 524290 | 15593.5 ± 0.5% | 1.000 | 0.179 | 0.997 | 0.179 |
| hex: silesia/samba | 524290 | 15606.4 ± 0.2% | 0.999 | 0.178 | 1.000 | 0.178 |
| hex: silesia/sao | 524290 | 15603.2 ± 0.1% | 0.999 | 0.178 | 1.000 | 0.179 |
| hex: silesia/webster | 524290 | 15563.0 ± 0.5% | 0.997 | 0.179 | 0.995 | 0.179 |
| hex: silesia/x-ray | 524290 | 15475.9 ± 0.3% | 1.001 | 0.180 | 1.001 | 0.180 |
| hex: silesia/xml | 524290 | 15518.7 ± 0.2% | 1.001 | 0.179 | 1.001 | 0.179 |
| hex: canterbury/alice29.txt | 304180 | 15601.9 ± 0.1% | 0.999 | 0.179 | 0.999 | 0.179 |
| hex: canterbury/asyoulik.txt | 250360 | 15596.8 ± 0.2% | 1.000 | 0.179 | 1.000 | 0.179 |
| hex: canterbury/cp.html | 49208 | 15428.2 ± 0.1% | 1.001 | 0.181 | 1.001 | 0.181 |
| hex: canterbury/fields.c | 22302 | 15087.4 ± 0.1% | 1.000 | 0.185 | 0.999 | 0.185 |
| hex: canterbury/grammar.lsp | 7444 | 14276.6 ± 0.2% | 1.003 | 0.193 | 1.001 | 0.193 |
| hex: canterbury/kennedy.xls | 524290 | 15513.0 ± 0.1% | 1.000 | 0.179 | 1.000 | 0.179 |
| hex: canterbury/lcet10.txt | 524290 | 15536.8 ± 0.2% | 1.001 | 0.180 | 0.996 | 0.179 |
| hex: canterbury/plrabn12.txt | 524290 | 15569.5 ± 0.1% | 1.000 | 0.179 | 1.000 | 0.179 |
| hex: canterbury/ptt5 | 524290 | 15508.3 ± 0.3% | 0.998 | 0.179 | 0.998 | 0.179 |
| hex: canterbury/sum | 76482 | 15515.7 ± 0.1% | 1.000 | 0.180 | 1.000 | 0.180 |
| hex: canterbury/xargs.1 | 8456 | 14509.4 ± 0.0% | 1.003 | 0.190 | 1.001 | 0.190 |
| hex: canterbury-large/E.coli | 524290 | 15579.3 ± 0.3% | 1.000 | 0.179 | 1.000 | 0.179 |
| hex: canterbury-large/bible.txt | 524290 | 15533.0 ± 0.3% | 1.000 | 0.179 | 0.999 | 0.179 |
| hex: canterbury-large/world192.txt | 524290 | 15501.0 ± 0.5% | 0.999 | 0.180 | 0.998 | 0.180 |
| hex: http/html-1k | 2050 | 12016.5 ± 0.1% | 1.010 | 0.219 | 1.008 | 0.219 |
| hex: http/html-16k | 32770 | 15365.8 ± 0.1% | 1.001 | 0.181 | 1.001 | 0.181 |
| hex: http/html-1m | 524290 | 15583.6 ± 0.5% | 1.001 | 0.178 | 1.001 | 0.178 |
| hex: http/json-1k | 2050 | 12022.0 ± 0.1% | 1.010 | 0.219 | 1.006 | 0.219 |
| hex: http/json-16k | 32770 | 15369.6 ± 0.0% | 1.001 | 0.182 | 1.000 | 0.182 |
| hex: http/json-1m | 524290 | 15398.1 ± 0.2% | 1.003 | 0.181 | 1.001 | 0.181 |
| hex: http/js-1k | 2050 | 12026.4 ± 0.1% | 1.009 | 0.218 | 1.003 | 0.219 |
| hex: http/js-16k | 32770 | 15368.6 ± 0.1% | 1.001 | 0.181 | 1.001 | 0.181 |
| hex: http/js-1m | 524290 | 15591.3 ± 0.3% | 1.001 | 0.179 | 0.998 | 0.179 |
| hex: http/css-1k | 2050 | 12025.7 ± 0.1% | 1.010 | 0.219 | 1.006 | 0.219 |
| hex: http/css-16k | 32770 | 15366.9 ± 0.1% | 1.001 | 0.181 | 1.001 | 0.181 |
| hex: http/css-1m | 524290 | 15583.8 ± 0.3% | 1.000 | 0.179 | 0.999 | 0.179 |
| hex: shuffled/dickens-1m | 524290 | 15556.7 ± 0.2% | 1.000 | 0.179 | 1.000 | 0.179 |

## Losses

Each workload where a vector path ran slower than the scalar path by more than the noise floor of decision 20.

None.

## Against the baselines

stdx with every claim on, timed beside simdjson 4.6.11, yyjson 0.13.0 and Zig 0.16.0's std.json in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe; the baselines for this host in ReleaseFast, and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 154.5 ± 0.1% | 925.4 ± 0.2% | 1022.7 ± 0.5% | 306.3 ± 0.5% | 0.167 | 0.151 | 0.504 |
| qlog records, JSON text sequence | 1467503 | 109.8 ± 0.5% | 785.4 ± 0.1% | 735.9 ± 12.4% | 226.3 ± 0.9% | 0.140 | 0.149 | 0.485 |
| string: silesia/dickens | 172528 | 964.4 ± 0.3% | 1765.4 ± 0.1% | 2543.7 ± 1.5% | 377.7 ± 0.3% | 0.546 | 0.379 | 2.553 |
| string: silesia/nci | 1075110 | 1148.3 ± 0.7% | 2072.0 ± 0.3% | 2974.0 ± 0.3% | 546.0 ± 3.1% | 0.554 | 0.386 | 2.103 |
| string: silesia/reymont | 1075159 | 1038.6 ± 0.6% | 1700.0 ± 0.9% | 2048.4 ± 0.3% | 391.2 ± 0.7% | 0.611 | 0.507 | 2.655 |
| string: silesia/samba | 97582 | 245.2 ± 0.5% | 1100.8 ± 0.3% | 2589.6 ± 0.4% | 339.9 ± 0.2% | 0.223 | 0.095 | 0.721 |
| string: silesia/webster | 1098490 | 717.7 ± 0.2% | 1445.8 ± 0.2% | 1998.8 ± 0.5% | 371.1 ± 0.5% | 0.496 | 0.359 | 1.934 |
| string: silesia/xml | 1090118 | 1054.9 ± 0.3% | 2062.0 ± 0.4% | 2512.0 ± 0.3% | 470.6 ± 1.0% | 0.512 | 0.420 | 2.242 |
| string: canterbury/alice29.txt | 159425 | 722.5 ± 0.3% | 1508.4 ± 0.2% | 2439.7 ± 0.4% | 354.9 ± 0.1% | 0.479 | 0.296 | 2.036 |
| string: canterbury/asyoulik.txt | 132198 | 598.7 ± 0.1% | 1386.6 ± 0.1% | 2216.0 ± 0.9% | 345.2 ± 0.3% | 0.432 | 0.270 | 1.735 |
| string: canterbury/lcet10.txt | 441884 | 940.8 ± 0.8% | 1747.2 ± 0.2% | 2260.0 ± 0.3% | 402.4 ± 0.2% | 0.538 | 0.416 | 2.338 |
| string: canterbury/plrabn12.txt | 503330 | 777.9 ± 0.2% | 1600.8 ± 0.3% | 2061.1 ± 0.3% | 372.4 ± 0.7% | 0.486 | 0.377 | 2.089 |
| string: canterbury-large/E.coli | 1048578 | 7290.8 ± 0.2% | 3187.1 ± 0.3% | 3250.0 ± 0.4% | 956.8 ± 0.6% | 2.288 | 2.243 | 7.620 |
| string: canterbury-large/bible.txt | 1055886 | 2574.9 ± 0.4% | 2607.0 ± 0.5% | 2824.5 ± 0.5% | 431.2 ± 0.3% | 0.988 | 0.912 | 5.972 |
| string: canterbury-large/world192.txt | 1103121 | 655.9 ± 0.5% | 1413.2 ± 0.1% | 2009.3 ± 0.6% | 363.5 ± 0.8% | 0.464 | 0.326 | 1.805 |
| string: http/html-1m | 1058582 | 2178.3 ± 0.3% | 2439.5 ± 0.8% | 2679.8 ± 0.4% | 463.1 ± 2.4% | 0.893 | 0.813 | 4.703 |
| string: http/json-1m | 1190272 | 283.4 ± 1.4% | 849.0 ± 0.4% | 2249.8 ± 0.6% | 405.2 ± 0.5% | 0.334 | 0.126 | 0.700 |
| string: http/js-1m | 1144362 | 390.3 ± 0.4% | 997.0 ± 0.3% | 1623.6 ± 0.3% | 331.7 ± 0.3% | 0.391 | 0.240 | 1.176 |
| string: http/css-1m | 1097820 | 643.3 ± 0.4% | 1576.3 ± 0.3% | 2183.1 ± 0.5% | 421.4 ± 0.7% | 0.408 | 0.295 | 1.527 |
| string: dickens as Cyrillic and CJK | 1883069 | 631.0 ± 0.2% | 1667.0 ± 0.1% | 881.1 ± 0.6% | 361.4 ± 0.3% | 0.379 | 0.716 | 1.746 |
| hex: silesia/dickens | 524290 | 7441.7 ± 0.3% | 3196.7 ± 0.2% | 3263.2 ± 0.3% | 509.9 ± 0.3% | 2.328 | 2.281 | 14.594 |
| hex: silesia/mozilla | 524290 | 7402.8 ± 0.3% | 3194.7 ± 0.1% | 3252.8 ± 0.1% | 461.5 ± 1.0% | 2.317 | 2.276 | 16.042 |
| hex: silesia/mr | 524290 | 7308.8 ± 0.4% | 3196.5 ± 0.2% | 3253.9 ± 0.4% | 561.1 ± 1.6% | 2.287 | 2.246 | 13.027 |
| hex: silesia/nci | 524290 | 7438.3 ± 0.6% | 3198.1 ± 0.3% | 3245.2 ± 0.3% | 631.0 ± 1.6% | 2.326 | 2.292 | 11.789 |
| hex: silesia/ooffice | 524290 | 7363.8 ± 0.3% | 3195.7 ± 0.3% | 3258.0 ± 0.2% | 406.5 ± 0.7% | 2.304 | 2.260 | 18.114 |
| hex: silesia/osdb | 524290 | 7563.8 ± 0.3% | 3188.3 ± 0.3% | 3266.7 ± 0.2% | 486.3 ± 2.0% | 2.372 | 2.315 | 15.554 |
| hex: silesia/reymont | 524290 | 7297.6 ± 0.9% | 3185.1 ± 0.2% | 3261.5 ± 0.2% | 503.4 ± 2.8% | 2.291 | 2.238 | 14.498 |
| hex: silesia/samba | 524290 | 7576.6 ± 0.7% | 3187.2 ± 0.3% | 3254.0 ± 0.3% | 410.9 ± 0.8% | 2.377 | 2.328 | 18.440 |
| hex: silesia/sao | 524290 | 7441.8 ± 0.3% | 3189.3 ± 0.4% | 3252.7 ± 0.4% | 351.4 ± 1.3% | 2.333 | 2.288 | 21.175 |
| hex: silesia/webster | 524290 | 7477.0 ± 0.4% | 3190.2 ± 0.1% | 3259.0 ± 0.3% | 470.6 ± 3.2% | 2.344 | 2.294 | 15.890 |
| hex: silesia/x-ray | 524290 | 7320.8 ± 0.2% | 3190.7 ± 0.2% | 3267.9 ± 0.2% | 478.5 ± 0.7% | 2.294 | 2.240 | 15.298 |
| hex: silesia/xml | 524290 | 7531.0 ± 0.4% | 3188.1 ± 0.1% | 3260.2 ± 0.6% | 524.4 ± 0.2% | 2.362 | 2.310 | 14.362 |
| hex: canterbury/alice29.txt | 304180 | 7569.7 ± 1.5% | 3199.6 ± 0.2% | 3305.4 ± 0.2% | 503.2 ± 0.5% | 2.366 | 2.290 | 15.042 |
| hex: canterbury/asyoulik.txt | 250360 | 7637.4 ± 1.2% | 3214.7 ± 0.0% | 3346.6 ± 0.5% | 497.7 ± 0.9% | 2.376 | 2.282 | 15.346 |
| hex: canterbury/cp.html | 49208 | 7500.8 ± 1.4% | 3217.6 ± 0.0% | 3285.5 ± 0.1% | 472.9 ± 2.4% | 2.331 | 2.283 | 15.861 |
| hex: canterbury/fields.c | 22302 | 7299.8 ± 0.8% | 3207.3 ± 0.1% | 3289.6 ± 0.3% | 491.4 ± 0.5% | 2.276 | 2.219 | 14.856 |
| hex: canterbury/grammar.lsp | 7444 | 6945.8 ± 1.1% | 3183.1 ± 0.1% | 3283.6 ± 0.2% | 526.7 ± 2.2% | 2.182 | 2.115 | 13.188 |
| hex: canterbury/kennedy.xls | 524290 | 7555.0 ± 0.3% | 3200.3 ± 0.3% | 3250.1 ± 0.3% | 656.5 ± 4.1% | 2.361 | 2.325 | 11.508 |
| hex: canterbury/lcet10.txt | 524290 | 7190.6 ± 0.4% | 3199.2 ± 0.3% | 3265.9 ± 0.2% | 513.2 ± 1.2% | 2.248 | 2.202 | 14.012 |
| hex: canterbury/plrabn12.txt | 524290 | 7616.9 ± 0.9% | 3196.5 ± 0.2% | 3257.4 ± 0.3% | 500.0 ± 2.2% | 2.383 | 2.338 | 15.234 |
| hex: canterbury/ptt5 | 524290 | 7603.1 ± 0.3% | 3197.8 ± 0.2% | 3229.6 ± 0.3% | 561.2 ± 1.1% | 2.378 | 2.354 | 13.549 |
| hex: canterbury/sum | 76482 | 7593.7 ± 0.5% | 3211.6 ± 0.1% | 3321.7 ± 0.2% | 498.8 ± 0.7% | 2.364 | 2.286 | 15.224 |
| hex: canterbury/xargs.1 | 8456 | 6935.5 ± 0.5% | 3184.6 ± 0.1% | 3278.0 ± 0.2% | 480.1 ± 1.4% | 2.178 | 2.116 | 14.447 |
| hex: canterbury-large/E.coli | 524290 | 7351.7 ± 0.3% | 3189.7 ± 0.3% | 3258.6 ± 0.5% | 750.5 ± 0.6% | 2.305 | 2.256 | 9.796 |
| hex: canterbury-large/bible.txt | 524290 | 7335.8 ± 0.5% | 3203.8 ± 0.1% | 3254.2 ± 0.4% | 512.3 ± 2.7% | 2.290 | 2.254 | 14.320 |
| hex: canterbury-large/world192.txt | 524290 | 7413.7 ± 0.6% | 3199.7 ± 0.2% | 3263.5 ± 0.2% | 497.5 ± 2.8% | 2.317 | 2.272 | 14.901 |
| hex: http/html-1k | 2050 | 5722.6 ± 0.7% | 3055.7 ± 0.1% | 3157.2 ± 0.1% | 541.8 ± 3.0% | 1.873 | 1.813 | 10.562 |
| hex: http/html-16k | 32770 | 7451.0 ± 1.6% | 3209.9 ± 0.0% | 3299.2 ± 0.1% | 503.8 ± 3.6% | 2.321 | 2.258 | 14.790 |
| hex: http/html-1m | 524290 | 7338.3 ± 0.3% | 3193.5 ± 0.2% | 3248.8 ± 0.3% | 498.8 ± 2.1% | 2.298 | 2.259 | 14.712 |
| hex: http/json-1k | 2050 | 5720.1 ± 0.4% | 3055.9 ± 0.2% | 3148.9 ± 0.3% | 626.3 ± 2.7% | 1.872 | 1.817 | 9.134 |
| hex: http/json-16k | 32770 | 7448.1 ± 1.8% | 3210.0 ± 0.1% | 3308.5 ± 0.0% | 630.9 ± 2.2% | 2.320 | 2.251 | 11.805 |
| hex: http/json-1m | 524290 | 7460.0 ± 1.0% | 3189.6 ± 0.4% | 3242.3 ± 1.0% | 583.0 ± 1.8% | 2.339 | 2.301 | 12.797 |
| hex: http/js-1k | 2050 | 5706.5 ± 0.2% | 3055.9 ± 0.1% | 3161.6 ± 0.4% | 558.0 ± 4.8% | 1.867 | 1.805 | 10.227 |
| hex: http/js-16k | 32770 | 7482.3 ± 1.5% | 3209.8 ± 0.0% | 3300.0 ± 0.2% | 536.9 ± 2.0% | 2.331 | 2.267 | 13.936 |
| hex: http/js-1m | 524290 | 7611.4 ± 0.5% | 3194.5 ± 0.2% | 3249.7 ± 0.2% | 494.8 ± 2.7% | 2.383 | 2.342 | 15.383 |
| hex: http/css-1k | 2050 | 5703.7 ± 0.3% | 3056.3 ± 0.2% | 3172.1 ± 0.3% | 623.6 ± 3.9% | 1.866 | 1.798 | 9.146 |
| hex: http/css-16k | 32770 | 7484.1 ± 0.4% | 3209.9 ± 0.0% | 3307.0 ± 0.4% | 473.8 ± 0.3% | 2.332 | 2.263 | 15.796 |
| hex: http/css-1m | 524290 | 7261.5 ± 0.8% | 3191.6 ± 0.5% | 3270.8 ± 0.4% | 507.2 ± 1.2% | 2.275 | 2.220 | 14.317 |
| hex: shuffled/dickens-1m | 524290 | 7489.9 ± 0.4% | 3199.9 ± 0.4% | 3248.4 ± 0.3% | 512.9 ± 2.5% | 2.341 | 2.306 | 14.604 |

## Encoding against the baselines

Octets are the ones stdx writes.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 221.6 ± 0.8% | 1116.1 ± 0.7% | 1020.9 ± 2.0% | 417.0 ± 1.4% | 0.199 | 0.217 | 0.531 |
| qlog records, JSON text sequence | 1467503 | 195.2 ± 1.1% | 993.4 ± 4.1% | 787.5 ± 2.2% | 384.4 ± 1.3% | 0.196 | 0.248 | 0.508 |
| string: silesia/dickens | 172528 | 1127.8 ± 0.3% | 2758.4 ± 0.4% | 2757.3 ± 0.5% | 437.5 ± 0.9% | 0.409 | 0.409 | 2.578 |
| string: silesia/nci | 1075110 | 1515.6 ± 0.4% | 3487.4 ± 0.2% | 3047.1 ± 0.3% | 807.7 ± 0.8% | 0.435 | 0.497 | 1.876 |
| string: silesia/reymont | 1075159 | 1286.0 ± 0.5% | 2560.6 ± 0.4% | 2083.1 ± 0.5% | 468.3 ± 0.6% | 0.502 | 0.617 | 2.746 |
| string: silesia/samba | 97582 | 501.1 ± 0.2% | 1574.0 ± 0.4% | 3405.3 ± 0.5% | 370.1 ± 1.2% | 0.318 | 0.147 | 1.354 |
| string: silesia/webster | 1098490 | 838.2 ± 0.3% | 2016.1 ± 0.3% | 2111.6 ± 0.3% | 452.2 ± 0.7% | 0.416 | 0.397 | 1.854 |
| string: silesia/xml | 1090118 | 1521.5 ± 0.2% | 3447.4 ± 0.4% | 2654.3 ± 0.6% | 632.6 ± 1.5% | 0.441 | 0.573 | 2.405 |
| string: canterbury/alice29.txt | 159425 | 847.4 ± 0.1% | 2130.1 ± 0.2% | 2689.2 ± 0.5% | 413.8 ± 1.6% | 0.398 | 0.315 | 2.048 |
| string: canterbury/asyoulik.txt | 132198 | 728.7 ± 0.3% | 1837.7 ± 0.3% | 2285.9 ± 0.4% | 411.1 ± 1.5% | 0.397 | 0.319 | 1.772 |
| string: canterbury/lcet10.txt | 441884 | 1095.7 ± 0.4% | 2624.3 ± 0.2% | 2499.8 ± 0.9% | 476.3 ± 1.3% | 0.418 | 0.438 | 2.301 |
| string: canterbury/plrabn12.txt | 503330 | 952.8 ± 0.7% | 2403.7 ± 0.5% | 2094.2 ± 0.6% | 429.1 ± 0.3% | 0.396 | 0.455 | 2.221 |
| string: canterbury-large/E.coli | 1048578 | 7269.4 ± 0.4% | 8224.8 ± 1.3% | 3768.5 ± 0.3% | 1466.6 ± 0.7% | 0.884 | 1.929 | 4.957 |
| string: canterbury-large/bible.txt | 1055886 | 3035.3 ± 0.2% | 4774.1 ± 1.6% | 3027.2 ± 1.1% | 508.1 ± 0.6% | 0.636 | 1.003 | 5.974 |
| string: canterbury-large/world192.txt | 1103121 | 764.2 ± 0.6% | 1876.3 ± 0.1% | 2094.4 ± 0.5% | 455.7 ± 1.6% | 0.407 | 0.365 | 1.677 |
| string: http/html-1m | 1058582 | 2529.9 ± 0.2% | 4347.0 ± 1.0% | 3034.3 ± 0.4% | 507.1 ± 1.3% | 0.582 | 0.834 | 4.989 |
| string: http/json-1m | 1190272 | 396.6 ± 0.5% | 1131.7 ± 0.2% | 1654.8 ± 0.5% | 466.2 ± 0.7% | 0.350 | 0.240 | 0.851 |
| string: http/js-1m | 1144362 | 446.2 ± 0.3% | 1173.2 ± 0.6% | 1622.3 ± 0.5% | 375.4 ± 0.4% | 0.380 | 0.275 | 1.189 |
| string: http/css-1m | 1097820 | 844.1 ± 0.1% | 2079.6 ± 0.3% | 2080.8 ± 0.4% | 511.9 ± 0.5% | 0.406 | 0.406 | 1.649 |
| string: dickens as Cyrillic and CJK | 1883069 | 618.8 ± 0.1% | 2392.6 ± 1.2% | 534.8 ± 0.3% | 316.8 ± 0.4% | 0.259 | 1.157 | 1.953 |
| hex: silesia/dickens | 524290 | 15601.0 ± 0.1% | 1444.3 ± 0.2% | 1069.3 ± 0.7% | 489.5 ± 1.3% | 10.802 | 14.590 | 31.874 |
| hex: silesia/mozilla | 524290 | 15568.3 ± 0.3% | 1444.1 ± 0.4% | 1073.3 ± 0.5% | 458.6 ± 1.6% | 10.781 | 14.505 | 33.950 |
| hex: silesia/mr | 524290 | 15583.5 ± 0.1% | 1454.0 ± 0.2% | 1077.3 ± 0.3% | 562.2 ± 1.1% | 10.718 | 14.466 | 27.718 |
| hex: silesia/nci | 524290 | 15513.0 ± 0.2% | 1455.3 ± 0.3% | 1076.5 ± 0.6% | 643.7 ± 2.1% | 10.659 | 14.411 | 24.100 |
| hex: silesia/ooffice | 524290 | 15528.0 ± 0.2% | 1429.6 ± 0.1% | 1068.2 ± 0.5% | 405.5 ± 0.9% | 10.862 | 14.537 | 38.295 |
| hex: silesia/osdb | 524290 | 15458.8 ± 0.2% | 1444.2 ± 0.2% | 1074.1 ± 0.4% | 487.9 ± 1.9% | 10.704 | 14.392 | 31.681 |
| hex: silesia/reymont | 524290 | 15593.5 ± 0.5% | 1440.1 ± 0.2% | 1071.7 ± 0.5% | 514.8 ± 0.4% | 10.828 | 14.550 | 30.288 |
| hex: silesia/samba | 524290 | 15606.4 ± 0.2% | 1438.5 ± 0.4% | 1069.0 ± 0.4% | 423.3 ± 0.8% | 10.849 | 14.599 | 36.866 |
| hex: silesia/sao | 524290 | 15603.2 ± 0.1% | 1432.5 ± 0.5% | 1064.9 ± 0.9% | 348.0 ± 0.8% | 10.893 | 14.652 | 44.837 |
| hex: silesia/webster | 524290 | 15563.0 ± 0.5% | 1443.5 ± 0.2% | 1073.0 ± 0.4% | 478.8 ± 0.7% | 10.781 | 14.504 | 32.501 |
| hex: silesia/x-ray | 524290 | 15475.9 ± 0.3% | 1440.7 ± 0.2% | 1071.4 ± 0.3% | 464.4 ± 0.4% | 10.742 | 14.445 | 33.323 |
| hex: silesia/xml | 524290 | 15518.7 ± 0.2% | 1441.4 ± 0.3% | 1071.8 ± 0.4% | 618.8 ± 1.5% | 10.766 | 14.479 | 25.078 |
| hex: canterbury/alice29.txt | 304180 | 15601.9 ± 0.1% | 1436.0 ± 0.1% | 1066.1 ± 0.3% | 503.6 ± 0.5% | 10.865 | 14.635 | 30.978 |
| hex: canterbury/asyoulik.txt | 250360 | 15596.8 ± 0.2% | 1446.7 ± 0.4% | 1071.0 ± 0.6% | 497.3 ± 0.2% | 10.781 | 14.563 | 31.363 |
| hex: canterbury/cp.html | 49208 | 15428.2 ± 0.1% | 1452.4 ± 0.3% | 1075.1 ± 0.3% | 526.7 ± 2.5% | 10.622 | 14.350 | 29.293 |
| hex: canterbury/fields.c | 22302 | 15087.4 ± 0.1% | 1429.4 ± 0.7% | 1082.8 ± 0.6% | 623.3 ± 5.6% | 10.555 | 13.934 | 24.206 |
| hex: canterbury/grammar.lsp | 7444 | 14276.6 ± 0.2% | 1468.4 ± 0.3% | 1074.3 ± 0.4% | 655.4 ± 1.2% | 9.722 | 13.289 | 21.783 |
| hex: canterbury/kennedy.xls | 524290 | 15513.0 ± 0.1% | 1447.8 ± 0.3% | 1074.9 ± 0.5% | 661.8 ± 1.4% | 10.715 | 14.432 | 23.440 |
| hex: canterbury/lcet10.txt | 524290 | 15536.8 ± 0.2% | 1438.0 ± 0.2% | 1072.6 ± 0.3% | 502.2 ± 0.4% | 10.804 | 14.486 | 30.939 |
| hex: canterbury/plrabn12.txt | 524290 | 15569.5 ± 0.1% | 1440.6 ± 0.3% | 1073.3 ± 0.4% | 492.4 ± 0.5% | 10.808 | 14.506 | 31.622 |
| hex: canterbury/ptt5 | 524290 | 15508.3 ± 0.3% | 1450.2 ± 0.2% | 1078.0 ± 0.4% | 570.5 ± 0.5% | 10.694 | 14.386 | 27.185 |
| hex: canterbury/sum | 76482 | 15515.7 ± 0.1% | 1481.1 ± 0.1% | 1091.1 ± 0.2% | 589.4 ± 0.7% | 10.476 | 14.221 | 26.323 |
| hex: canterbury/xargs.1 | 8456 | 14509.4 ± 0.0% | 1466.7 ± 0.4% | 1058.4 ± 0.6% | 660.5 ± 1.4% | 9.893 | 13.709 | 21.969 |
| hex: canterbury-large/E.coli | 524290 | 15579.3 ± 0.3% | 1455.6 ± 0.4% | 1079.6 ± 0.5% | 667.7 ± 0.3% | 10.703 | 14.431 | 23.332 |
| hex: canterbury-large/bible.txt | 524290 | 15533.0 ± 0.3% | 1441.8 ± 0.3% | 1070.8 ± 0.6% | 511.9 ± 0.5% | 10.773 | 14.506 | 30.346 |
| hex: canterbury-large/world192.txt | 524290 | 15501.0 ± 0.5% | 1441.5 ± 0.2% | 1071.0 ± 0.7% | 500.7 ± 1.1% | 10.754 | 14.473 | 30.961 |
| hex: http/html-1k | 2050 | 12016.5 ± 0.1% | 1423.6 ± 0.5% | 1038.5 ± 0.3% | 638.9 ± 4.4% | 8.441 | 11.571 | 18.807 |
| hex: http/html-16k | 32770 | 15365.8 ± 0.1% | 1454.4 ± 0.4% | 1077.7 ± 0.3% | 579.7 ± 4.4% | 10.565 | 14.258 | 26.506 |
| hex: http/html-1m | 524290 | 15583.6 ± 0.5% | 1437.9 ± 0.1% | 1071.8 ± 0.3% | 506.9 ± 0.2% | 10.837 | 14.540 | 30.744 |
| hex: http/json-1k | 2050 | 12022.0 ± 0.1% | 1423.6 ± 0.6% | 1040.1 ± 0.5% | 655.3 ± 1.5% | 8.445 | 11.559 | 18.345 |
| hex: http/json-16k | 32770 | 15369.6 ± 0.0% | 1464.9 ± 0.1% | 1080.8 ± 0.2% | 659.2 ± 3.0% | 10.492 | 14.220 | 23.315 |
| hex: http/json-1m | 524290 | 15398.1 ± 0.2% | 1447.4 ± 0.3% | 1076.1 ± 0.6% | 624.8 ± 0.9% | 10.638 | 14.309 | 24.644 |
| hex: http/js-1k | 2050 | 12026.4 ± 0.1% | 1424.2 ± 0.7% | 1019.7 ± 0.4% | 652.8 ± 1.9% | 8.444 | 11.794 | 18.424 |
| hex: http/js-16k | 32770 | 15368.6 ± 0.1% | 1457.9 ± 0.1% | 1079.0 ± 0.2% | 649.5 ± 2.6% | 10.542 | 14.243 | 23.663 |
| hex: http/js-1m | 524290 | 15591.3 ± 0.3% | 1441.7 ± 0.4% | 1071.5 ± 0.5% | 517.0 ± 0.4% | 10.814 | 14.552 | 30.155 |
| hex: http/css-1k | 2050 | 12025.7 ± 0.1% | 1429.9 ± 0.8% | 1050.1 ± 0.1% | 670.9 ± 0.5% | 8.410 | 11.452 | 17.924 |
| hex: http/css-16k | 32770 | 15366.9 ± 0.1% | 1455.5 ± 0.3% | 1077.4 ± 0.3% | 583.5 ± 2.8% | 10.558 | 14.263 | 26.338 |
| hex: http/css-1m | 524290 | 15583.8 ± 0.3% | 1440.9 ± 0.5% | 1072.1 ± 0.7% | 537.2 ± 0.2% | 10.816 | 14.535 | 29.012 |
| hex: shuffled/dickens-1m | 524290 | 15556.7 ± 0.2% | 1440.8 ± 0.3% | 1073.3 ± 0.3% | 503.1 ± 0.5% | 10.797 | 14.494 | 30.923 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.167 of simdjson.
- CLDR supplemental, 34 texts, decoding: stdx runs at 0.151 of yyjson.
- CLDR supplemental, 34 texts, decoding: stdx runs at 0.504 of std.json.
- qlog records, JSON text sequence, decoding: stdx runs at 0.140 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.149 of yyjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.485 of std.json.
- string: silesia/dickens, decoding: stdx runs at 0.546 of simdjson.
- string: silesia/dickens, decoding: stdx runs at 0.379 of yyjson.
- string: silesia/nci, decoding: stdx runs at 0.554 of simdjson.
- string: silesia/nci, decoding: stdx runs at 0.386 of yyjson.
- string: silesia/reymont, decoding: stdx runs at 0.611 of simdjson.
- string: silesia/reymont, decoding: stdx runs at 0.507 of yyjson.
- string: silesia/samba, decoding: stdx runs at 0.223 of simdjson.
- string: silesia/samba, decoding: stdx runs at 0.095 of yyjson.
- string: silesia/samba, decoding: stdx runs at 0.721 of std.json.
- string: silesia/webster, decoding: stdx runs at 0.496 of simdjson.
- string: silesia/webster, decoding: stdx runs at 0.359 of yyjson.
- string: silesia/xml, decoding: stdx runs at 0.512 of simdjson.
- string: silesia/xml, decoding: stdx runs at 0.420 of yyjson.
- string: canterbury/alice29.txt, decoding: stdx runs at 0.479 of simdjson.
- string: canterbury/alice29.txt, decoding: stdx runs at 0.296 of yyjson.
- string: canterbury/asyoulik.txt, decoding: stdx runs at 0.432 of simdjson.
- string: canterbury/asyoulik.txt, decoding: stdx runs at 0.270 of yyjson.
- string: canterbury/lcet10.txt, decoding: stdx runs at 0.538 of simdjson.
- string: canterbury/lcet10.txt, decoding: stdx runs at 0.416 of yyjson.
- string: canterbury/plrabn12.txt, decoding: stdx runs at 0.486 of simdjson.
- string: canterbury/plrabn12.txt, decoding: stdx runs at 0.377 of yyjson.
- string: canterbury-large/bible.txt, decoding: stdx runs at 0.912 of yyjson.
- string: canterbury-large/world192.txt, decoding: stdx runs at 0.464 of simdjson.
- string: canterbury-large/world192.txt, decoding: stdx runs at 0.326 of yyjson.
- string: http/html-1m, decoding: stdx runs at 0.893 of simdjson.
- string: http/html-1m, decoding: stdx runs at 0.813 of yyjson.
- string: http/json-1m, decoding: stdx runs at 0.334 of simdjson.
- string: http/json-1m, decoding: stdx runs at 0.126 of yyjson.
- string: http/json-1m, decoding: stdx runs at 0.700 of std.json.
- string: http/js-1m, decoding: stdx runs at 0.391 of simdjson.
- string: http/js-1m, decoding: stdx runs at 0.240 of yyjson.
- string: http/css-1m, decoding: stdx runs at 0.408 of simdjson.
- string: http/css-1m, decoding: stdx runs at 0.295 of yyjson.
- string: dickens as Cyrillic and CJK, decoding: stdx runs at 0.379 of simdjson.
- string: dickens as Cyrillic and CJK, decoding: stdx runs at 0.716 of yyjson.
- CLDR supplemental, 34 texts, encoding: stdx runs at 0.199 of simdjson.
- CLDR supplemental, 34 texts, encoding: stdx runs at 0.217 of yyjson.
- CLDR supplemental, 34 texts, encoding: stdx runs at 0.531 of std.json.
- qlog records, JSON text sequence, encoding: stdx runs at 0.196 of simdjson.
- qlog records, JSON text sequence, encoding: stdx runs at 0.248 of yyjson.
- qlog records, JSON text sequence, encoding: stdx runs at 0.508 of std.json.
- string: silesia/dickens, encoding: stdx runs at 0.409 of simdjson.
- string: silesia/dickens, encoding: stdx runs at 0.409 of yyjson.
- string: silesia/nci, encoding: stdx runs at 0.435 of simdjson.
- string: silesia/nci, encoding: stdx runs at 0.497 of yyjson.
- string: silesia/reymont, encoding: stdx runs at 0.502 of simdjson.
- string: silesia/reymont, encoding: stdx runs at 0.617 of yyjson.
- string: silesia/samba, encoding: stdx runs at 0.318 of simdjson.
- string: silesia/samba, encoding: stdx runs at 0.147 of yyjson.
- string: silesia/webster, encoding: stdx runs at 0.416 of simdjson.
- string: silesia/webster, encoding: stdx runs at 0.397 of yyjson.
- string: silesia/xml, encoding: stdx runs at 0.441 of simdjson.
- string: silesia/xml, encoding: stdx runs at 0.573 of yyjson.
- string: canterbury/alice29.txt, encoding: stdx runs at 0.398 of simdjson.
- string: canterbury/alice29.txt, encoding: stdx runs at 0.315 of yyjson.
- string: canterbury/asyoulik.txt, encoding: stdx runs at 0.397 of simdjson.
- string: canterbury/asyoulik.txt, encoding: stdx runs at 0.319 of yyjson.
- string: canterbury/lcet10.txt, encoding: stdx runs at 0.418 of simdjson.
- string: canterbury/lcet10.txt, encoding: stdx runs at 0.438 of yyjson.
- string: canterbury/plrabn12.txt, encoding: stdx runs at 0.396 of simdjson.
- string: canterbury/plrabn12.txt, encoding: stdx runs at 0.455 of yyjson.
- string: canterbury-large/E.coli, encoding: stdx runs at 0.884 of simdjson.
- string: canterbury-large/bible.txt, encoding: stdx runs at 0.636 of simdjson.
- string: canterbury-large/world192.txt, encoding: stdx runs at 0.407 of simdjson.
- string: canterbury-large/world192.txt, encoding: stdx runs at 0.365 of yyjson.
- string: http/html-1m, encoding: stdx runs at 0.582 of simdjson.
- string: http/html-1m, encoding: stdx runs at 0.834 of yyjson.
- string: http/json-1m, encoding: stdx runs at 0.350 of simdjson.
- string: http/json-1m, encoding: stdx runs at 0.240 of yyjson.
- string: http/json-1m, encoding: stdx runs at 0.851 of std.json.
- string: http/js-1m, encoding: stdx runs at 0.380 of simdjson.
- string: http/js-1m, encoding: stdx runs at 0.275 of yyjson.
- string: http/css-1m, encoding: stdx runs at 0.406 of simdjson.
- string: http/css-1m, encoding: stdx runs at 0.406 of yyjson.
- string: dickens as Cyrillic and CJK, encoding: stdx runs at 0.259 of simdjson.
