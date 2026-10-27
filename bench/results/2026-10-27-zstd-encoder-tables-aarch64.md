# bench-zstd

| Field | Value |
|---|---|
| Commit | 27063af |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261026.166.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/40590088368 |
| Date | 2026-10-27 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 914.3 ±3.3% | 894.8 ±4.1% | 0.98 |
| silesia/mozilla | 51220480 | 35.6 | 1170.5 ±0.6% | 1173.7 ±1.0% | 1.00 |
| silesia/mr | 9970564 | 35.6 | 1105.6 ±0.7% | 1082.9 ±0.6% | 0.98 |
| silesia/nci | 33553445 | 8.4 | 2012.8 ±2.4% | 1891.2 ±6.9% | 0.94 |
| silesia/ooffice | 6152192 | 50.8 | 980.9 ±0.6% | 1003.1 ±0.6% | 1.02 |
| silesia/osdb | 10085684 | 34.7 | 1408.4 ±2.3% | 1372.6 ±1.4% | 0.97 |
| silesia/reymont | 6627202 | 29.2 | 1044.2 ±0.7% | 997.8 ±0.4% | 0.96 |
| silesia/samba | 21606400 | 22.9 | 1575.8 ±4.4% | 1456.4 ±6.5% | 0.92 |
| silesia/sao | 7251944 | 76.2 | 861.7 ±0.9% | 914.4 ±1.9% | 1.06 |
| silesia/webster | 41458703 | 29.2 | 944.3 ±7.6% | 904.0 ±9.3% | 0.96 |
| silesia/x-ray | 8474240 | 71.8 | 834.1 ±0.8% | 895.4 ±1.0% | 1.07 |
| silesia/xml | 5345280 | 11.9 | 2134.4 ±1.2% | 2156.8 ±0.7% | 1.01 |
| canterbury/alice29.txt | 152089 | 37.5 | 1009.7 ±0.3% | 1027.9 ±0.3% | 1.02 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1124.9 ±0.1% | 1136.6 ±0.2% | 1.01 |
| canterbury/cp.html | 24603 | 34.4 | 1249.5 ±0.1% | 1339.4 ±0.2% | 1.07 |
| canterbury/fields.c | 11150 | 30.3 | 1071.3 ±0.1% | 1129.4 ±0.3% | 1.05 |
| canterbury/grammar.lsp | 3721 | 34.8 | 791.2 ±0.1% | 823.7 ±0.1% | 1.04 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1353.9 ±0.1% | 1259.7 ±0.3% | 0.93 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1230.0 ±0.1% | 1259.1 ±0.4% | 1.02 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1066.8 ±0.2% | 1067.9 ±0.2% | 1.00 |
| canterbury/ptt5 | 513216 | 10.6 | 2369.6 ±0.3% | 2538.5 ±1.8% | 1.07 |
| canterbury/sum | 38240 | 35.0 | 1236.6 ±0.3% | 1296.4 ±0.1% | 1.05 |
| canterbury/xargs.1 | 4227 | 42.7 | 782.0 ±0.4% | 797.8 ±0.0% | 1.02 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1077.7 ±1.4% | 1044.5 ±1.7% | 0.97 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1102.4 ±1.1% | 1061.2 ±1.4% | 0.96 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1312.8 ±0.4% | 1242.4 ±1.8% | 0.95 |
| http/html-1kx1024 | 1048576 | 39.3 | 457.4 ±0.1% | 452.4 ±0.1% | 0.99 |
| http/html-16kx64 | 1048576 | 21.9 | 1273.1 ±0.2% | 1274.2 ±0.3% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1684.2 ±0.4% | 1671.0 ±0.8% | 0.99 |
| http/json-1kx1024 | 1048576 | 21.9 | 529.9 ±0.1% | 543.3 ±0.1% | 1.03 |
| http/json-16kx64 | 1048576 | 12.6 | 1652.1 ±0.1% | 1685.2 ±0.1% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1955.4 ±0.2% | 2085.5 ±0.2% | 1.07 |
| http/js-1kx1024 | 1048576 | 44.5 | 400.9 ±0.1% | 373.7 ±0.2% | 0.93 |
| http/js-16kx64 | 1048576 | 26.0 | 1156.9 ±0.3% | 1146.1 ±0.4% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1654.1 ±0.5% | 1607.3 ±0.6% | 0.97 |
| http/css-1kx1024 | 1048576 | 29.5 | 477.3 ±0.1% | 493.4 ±0.2% | 1.03 |
| http/css-16kx64 | 1048576 | 15.9 | 1466.6 ±0.1% | 1500.6 ±0.7% | 1.02 |
| http/css-1m | 1048576 | 3.6 | 5003.0 ±0.5% | 4888.5 ±0.2% | 0.98 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1200.7 ±0.2% | 1238.3 ±0.6% | 1.03 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 235.7 ±0.6% | 903.1 ±1.2% | 3.83 |
| silesia/mozilla | 51220480 | 35.6 | 276.8 ±0.7% | 1170.0 ±1.0% | 4.23 |
| silesia/mr | 9970564 | 35.6 | 243.2 ±1.0% | 1087.0 ±1.1% | 4.47 |
| silesia/nci | 33553445 | 8.4 | 668.4 ±1.0% | 1812.7 ±9.5% | 2.71 |
| silesia/ooffice | 6152192 | 50.8 | 192.4 ±0.3% | 990.2 ±2.0% | 5.15 |
| silesia/osdb | 10085684 | 34.7 | 301.3 ±0.6% | 1387.6 ±2.3% | 4.61 |
| silesia/reymont | 6627202 | 29.2 | 285.2 ±1.5% | 1027.0 ±0.5% | 3.60 |
| silesia/samba | 21606400 | 22.9 | 446.2 ±1.0% | 1528.1 ±2.3% | 3.42 |
| silesia/sao | 7251944 | 76.2 | 163.3 ±0.2% | 952.9 ±2.0% | 5.84 |
| silesia/webster | 41458703 | 29.2 | 278.4 ±0.7% | 973.9 ±0.8% | 3.50 |
| silesia/x-ray | 8474240 | 71.8 | 152.8 ±0.7% | 923.8 ±3.3% | 6.05 |
| silesia/xml | 5345280 | 11.9 | 628.2 ±0.4% | 2224.7 ±1.0% | 3.54 |
| canterbury/alice29.txt | 152089 | 37.5 | 221.0 ±0.3% | 1028.2 ±0.1% | 4.65 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 207.5 ±0.3% | 1137.7 ±0.4% | 5.48 |
| canterbury/cp.html | 24603 | 34.4 | 253.5 ±0.1% | 1334.8 ±0.1% | 5.27 |
| canterbury/fields.c | 11150 | 30.3 | 250.7 ±0.3% | 1129.5 ±0.1% | 4.51 |
| canterbury/grammar.lsp | 3721 | 34.8 | 214.2 ±0.2% | 824.5 ±0.1% | 3.85 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 295.5 ±0.7% | 1263.9 ±0.4% | 4.28 |
| canterbury/lcet10.txt | 426754 | 33.0 | 266.2 ±0.4% | 1258.0 ±0.3% | 4.73 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 219.0 ±0.8% | 1072.7 ±0.3% | 4.90 |
| canterbury/ptt5 | 513216 | 10.6 | 469.5 ±0.2% | 2588.8 ±1.4% | 5.51 |
| canterbury/sum | 38240 | 35.0 | 249.5 ±0.5% | 1295.4 ±0.4% | 5.19 |
| canterbury/xargs.1 | 4227 | 42.7 | 182.5 ±0.3% | 796.5 ±0.3% | 4.36 |
| canterbury-large/E.coli | 4638690 | 30.0 | 265.1 ±0.6% | 1088.3 ±0.5% | 4.11 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 298.7 ±0.5% | 1103.8 ±0.9% | 3.70 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 331.4 ±0.4% | 1305.9 ±0.3% | 3.94 |
| http/html-1kx1024 | 1048576 | 39.3 | 187.4 ±0.1% | 452.6 ±0.1% | 2.41 |
| http/html-16kx64 | 1048576 | 21.9 | 334.1 ±0.2% | 1283.0 ±0.6% | 3.84 |
| http/html-1m | 1048576 | 17.7 | 452.3 ±0.3% | 1700.2 ±0.4% | 3.76 |
| http/json-1kx1024 | 1048576 | 21.9 | 278.6 ±0.2% | 544.6 ±0.1% | 1.95 |
| http/json-16kx64 | 1048576 | 12.6 | 467.9 ±0.3% | 1687.5 ±0.3% | 3.61 |
| http/json-1m | 1048576 | 12.2 | 527.6 ±0.2% | 2090.3 ±0.4% | 3.96 |
| http/js-1kx1024 | 1048576 | 44.5 | 158.2 ±0.2% | 374.3 ±0.1% | 2.37 |
| http/js-16kx64 | 1048576 | 26.0 | 286.0 ±0.3% | 1150.0 ±0.5% | 4.02 |
| http/js-1m | 1048576 | 19.0 | 427.4 ±0.2% | 1640.4 ±0.6% | 3.84 |
| http/css-1kx1024 | 1048576 | 29.5 | 234.0 ±0.2% | 493.2 ±0.1% | 2.11 |
| http/css-16kx64 | 1048576 | 15.9 | 421.4 ±0.2% | 1494.3 ±0.1% | 3.55 |
| http/css-1m | 1048576 | 3.6 | 1762.7 ±0.3% | 4832.4 ±0.7% | 2.74 |
| shuffled/dickens-1m | 1048576 | 58.8 | 152.7 ±0.4% | 1246.8 ±0.5% | 8.17 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 944.7 ±0.6% | 0.94 ±0.4% | 1.00 ±0.4% | 0.59 ±1.1% | 0.96 ±0.9% | 0.39 ±1.3% |
| silesia/mozilla | 51220480 | 35.6 | 1172.3 ±2.9% | 0.74 ±3.4% | 1.00 ±2.8% | 0.61 ±1.3% | 0.98 ±2.9% | 0.45 ±2.3% |
| silesia/mr | 9970564 | 35.6 | 1104.6 ±2.0% | 0.82 ±3.7% | 1.00 ±3.6% | 0.57 ±3.1% | 0.97 ±5.0% | 0.39 ±2.2% |
| silesia/nci | 33553445 | 8.4 | 1955.8 ±5.5% | 0.92 ±7.2% | 0.98 ±4.7% | 0.69 ±3.3% | 0.99 ±3.0% | 0.48 ±0.4% |
| silesia/ooffice | 6152192 | 50.8 | 1006.3 ±4.0% | 0.61 ±3.3% | 0.99 ±5.7% | 0.59 ±2.6% | 0.98 ±4.1% | 0.44 ±1.9% |
| silesia/osdb | 10085684 | 34.7 | 1383.6 ±3.2% | 0.67 ±2.3% | 1.01 ±2.3% | 0.69 ±1.7% | 0.98 ±3.2% | 0.45 ±2.5% |
| silesia/reymont | 6627202 | 29.2 | 1032.6 ±0.7% | 0.95 ±2.4% | 0.99 ±1.1% | 0.62 ±0.3% | 0.97 ±1.2% | 0.40 ±2.0% |
| silesia/samba | 21606400 | 22.9 | 1544.2 ±1.9% | 0.92 ±4.6% | 1.00 ±3.7% | 0.64 ±1.3% | 1.00 ±1.2% | 0.43 ±1.0% |
| silesia/sao | 7251944 | 76.2 | 959.6 ±1.0% | 0.52 ±1.5% | 1.00 ±1.9% | 0.69 ±0.6% | 0.98 ±1.2% | 0.53 ±1.6% |
| silesia/webster | 41458703 | 29.2 | 1015.4 ±2.2% | 0.93 ±1.4% | 1.00 ±3.4% | 0.62 ±1.7% | 0.97 ±1.1% | 0.42 ±1.1% |
| silesia/x-ray | 8474240 | 71.8 | 947.1 ±1.3% | 0.51 ±1.2% | 1.00 ±0.7% | 0.66 ±1.0% | 0.97 ±0.9% | 0.48 ±0.8% |
| silesia/xml | 5345280 | 11.9 | 2236.1 ±0.6% | 0.92 ±0.4% | 1.00 ±0.7% | 0.61 ±0.7% | 0.99 ±0.7% | 0.41 ±0.9% |
| canterbury/alice29.txt | 152089 | 37.5 | 1028.3 ±0.2% | 0.94 ±0.0% | 1.00 ±0.1% | 0.53 ±0.4% | 0.99 ±0.1% | 0.36 ±0.4% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1136.4 ±0.1% | 0.85 ±0.1% | 0.98 ±0.1% | 0.51 ±0.3% | 0.99 ±0.1% | 0.37 ±0.3% |
| canterbury/cp.html | 24603 | 34.4 | 1341.2 ±0.1% | 0.63 ±0.2% | 1.00 ±0.1% | 0.62 ±0.7% | 0.98 ±0.2% | 0.45 ±0.2% |
| canterbury/fields.c | 11150 | 30.3 | 1130.9 ±0.2% | 0.81 ±0.4% | 1.00 ±0.4% | 0.59 ±0.3% | 0.99 ±0.2% | 0.41 ±0.1% |
| canterbury/grammar.lsp | 3721 | 34.8 | 825.0 ±0.1% | 0.79 ±0.2% | 1.00 ±0.3% | 0.67 ±0.5% | 0.99 ±0.2% | 0.49 ±0.1% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1264.9 ±0.3% | 0.86 ±0.4% | 1.01 ±0.3% | 0.58 ±0.5% | 0.99 ±0.7% | 0.39 ±0.4% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1260.7 ±0.2% | 0.89 ±0.1% | 1.00 ±0.1% | 0.54 ±0.5% | 0.99 ±0.2% | 0.35 ±0.1% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1073.9 ±0.1% | 0.91 ±0.1% | 0.99 ±0.2% | 0.52 ±0.2% | 0.98 ±0.2% | 0.36 ±0.2% |
| canterbury/ptt5 | 513216 | 10.6 | 2569.4 ±0.7% | 0.81 ±0.8% | 1.01 ±0.9% | 0.55 ±0.2% | 1.01 ±1.8% | 0.43 ±0.3% |
| canterbury/sum | 38240 | 35.0 | 1296.8 ±0.4% | 0.64 ±0.4% | 0.99 ±0.3% | 0.62 ±0.5% | 0.99 ±0.2% | 0.45 ±0.4% |
| canterbury/xargs.1 | 4227 | 42.7 | 798.6 ±0.1% | 0.74 ±0.1% | 1.00 ±0.1% | 0.65 ±0.3% | 0.99 ±0.1% | 0.46 ±0.1% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1088.1 ±1.0% | 0.98 ±1.8% | 1.00 ±1.1% | 0.58 ±1.7% | 0.98 ±2.4% | 0.36 ±2.2% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1103.0 ±0.5% | 0.97 ±0.8% | 1.00 ±0.2% | 0.61 ±0.7% | 0.97 ±1.3% | 0.39 ±1.7% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1295.0 ±0.3% | 0.90 ±0.3% | 1.01 ±0.2% | 0.61 ±0.6% | 0.99 ±0.6% | 0.41 ±1.0% |
| http/html-1kx1024 | 1048576 | 39.3 | 454.1 ±0.2% | 0.86 ±0.1% | 1.00 ±0.1% | 0.79 ±0.2% | 0.99 ±0.4% | 0.67 ±0.1% |
| http/html-16kx64 | 1048576 | 21.9 | 1282.5 ±0.6% | 0.83 ±0.2% | 1.00 ±0.1% | 0.62 ±0.2% | 0.99 ±0.4% | 0.46 ±0.1% |
| http/html-1m | 1048576 | 17.7 | 1697.4 ±0.2% | 0.94 ±0.9% | 1.00 ±0.2% | 0.60 ±0.6% | 0.99 ±0.7% | 0.40 ±0.2% |
| http/json-1kx1024 | 1048576 | 21.9 | 534.1 ±0.2% | 1.00 ±0.3% | 1.02 ±0.1% | 0.83 ±0.1% | 1.01 ±0.2% | 0.69 ±0.1% |
| http/json-16kx64 | 1048576 | 12.6 | 1681.5 ±0.3% | 0.85 ±0.1% | 1.00 ±0.4% | 0.64 ±0.2% | 1.00 ±0.4% | 0.47 ±0.1% |
| http/json-1m | 1048576 | 12.2 | 2086.5 ±0.6% | 0.88 ±1.2% | 1.00 ±0.9% | 0.58 ±0.5% | 0.99 ±0.3% | 0.40 ±0.3% |
| http/js-1kx1024 | 1048576 | 44.5 | 375.1 ±0.2% | 0.86 ±0.1% | 1.00 ±0.1% | 0.78 ±0.4% | 0.99 ±0.1% | 0.67 ±0.1% |
| http/js-16kx64 | 1048576 | 26.0 | 1151.0 ±0.2% | 0.82 ±0.5% | 1.00 ±0.5% | 0.61 ±0.2% | 0.99 ±0.2% | 0.45 ±0.1% |
| http/js-1m | 1048576 | 19.0 | 1650.3 ±0.4% | 0.91 ±0.7% | 1.00 ±0.3% | 0.60 ±0.4% | 0.99 ±1.1% | 0.40 ±0.5% |
| http/css-1kx1024 | 1048576 | 29.5 | 494.9 ±0.2% | 0.94 ±0.1% | 1.00 ±0.1% | 0.79 ±0.2% | 0.99 ±0.1% | 0.66 ±0.1% |
| http/css-16kx64 | 1048576 | 15.9 | 1495.2 ±0.3% | 0.89 ±0.3% | 1.00 ±0.2% | 0.65 ±0.2% | 0.99 ±0.3% | 0.45 ±0.1% |
| http/css-1m | 1048576 | 3.6 | 4892.5 ±1.3% | 0.95 ±0.9% | 1.00 ±1.3% | 0.71 ±0.7% | 0.98 ±1.0% | 0.46 ±1.2% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1246.8 ±0.6% | 0.52 ±0.9% | 0.85 ±1.1% | 0.74 ±0.3% | 0.98 ±0.3% | 0.56 ±0.3% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 333.2 ± 0.3% | 116.0 ± 0.3% | 0.35 |
| silesia/dickens | 10192446 | 3 | 144.9 ± 1.7% | 84.0 ± 0.5% | 0.58 |
| silesia/mozilla | 51220480 | 1 | 480.7 ± 0.3% | 161.7 ± 0.3% | 0.34 |
| silesia/mozilla | 51220480 | 3 | 192.0 ± 0.5% | 99.5 ± 0.3% | 0.52 |
| silesia/mr | 9970564 | 1 | 440.8 ± 0.4% | 144.1 ± 0.3% | 0.33 |
| silesia/mr | 9970564 | 3 | 164.3 ± 1.1% | 90.1 ± 0.7% | 0.55 |
| silesia/nci | 33553445 | 1 | 953.4 ± 0.6% | 369.2 ± 0.4% | 0.39 |
| silesia/nci | 33553445 | 3 | 610.6 ± 0.2% | 265.1 ± 0.6% | 0.43 |
| silesia/ooffice | 6152192 | 1 | 395.5 ± 0.3% | 122.3 ± 0.3% | 0.31 |
| silesia/ooffice | 6152192 | 3 | 136.5 ± 0.5% | 72.1 ± 0.6% | 0.53 |
| silesia/osdb | 10085684 | 1 | 474.3 ± 0.5% | 172.8 ± 0.5% | 0.36 |
| silesia/osdb | 10085684 | 3 | 180.7 ± 0.3% | 96.1 ± 0.3% | 0.53 |
| silesia/reymont | 6627202 | 1 | 343.5 ± 0.4% | 140.9 ± 0.3% | 0.41 |
| silesia/reymont | 6627202 | 3 | 178.8 ± 2.3% | 106.7 ± 0.2% | 0.60 |
| silesia/samba | 21606400 | 1 | 562.6 ± 0.3% | 212.1 ± 0.3% | 0.38 |
| silesia/samba | 21606400 | 3 | 275.2 ± 0.6% | 148.4 ± 0.4% | 0.54 |
| silesia/sao | 7251944 | 1 | 372.9 ± 0.4% | 107.0 ± 0.2% | 0.29 |
| silesia/sao | 7251944 | 3 | 103.0 ± 0.6% | 59.2 ± 0.3% | 0.57 |
| silesia/webster | 41458703 | 1 | 386.9 ± 0.8% | 142.4 ± 0.3% | 0.37 |
| silesia/webster | 41458703 | 3 | 172.3 ± 0.6% | 98.6 ± 0.4% | 0.57 |
| silesia/x-ray | 8474240 | 1 | 726.3 ± 0.4% | 114.8 ± 0.4% | 0.16 |
| silesia/x-ray | 8474240 | 3 | 101.8 ± 0.5% | 63.0 ± 0.1% | 0.62 |
| silesia/xml | 5345280 | 1 | 798.7 ± 0.4% | 280.7 ± 1.2% | 0.35 |
| silesia/xml | 5345280 | 3 | 492.7 ± 0.9% | 236.3 ± 1.1% | 0.48 |
| canterbury/alice29.txt | 152089 | 1 | 310.9 ± 0.2% | 125.9 ± 0.3% | 0.40 |
| canterbury/alice29.txt | 152089 | 3 | 211.1 ± 0.5% | 109.0 ± 0.5% | 0.52 |
| canterbury/asyoulik.txt | 125179 | 1 | 347.3 ± 0.2% | 117.6 ± 0.5% | 0.34 |
| canterbury/asyoulik.txt | 125179 | 3 | 218.2 ± 0.4% | 103.9 ± 0.6% | 0.48 |
| canterbury/cp.html | 24603 | 1 | 491.1 ± 0.5% | 176.4 ± 0.4% | 0.36 |
| canterbury/cp.html | 24603 | 3 | 368.4 ± 1.0% | 160.1 ± 0.6% | 0.43 |
| canterbury/fields.c | 11150 | 1 | 391.8 ± 0.4% | 179.0 ± 0.7% | 0.46 |
| canterbury/fields.c | 11150 | 3 | 377.7 ± 0.5% | 175.8 ± 0.5% | 0.47 |
| canterbury/grammar.lsp | 3721 | 1 | 359.3 ± 0.6% | 152.0 ± 0.2% | 0.42 |
| canterbury/grammar.lsp | 3721 | 3 | 320.4 ± 0.1% | 146.6 ± 0.2% | 0.46 |
| canterbury/kennedy.xls | 1029744 | 1 | 564.6 ± 0.3% | 197.7 ± 0.6% | 0.35 |
| canterbury/kennedy.xls | 1029744 | 3 | 385.5 ± 0.5% | 150.2 ± 0.6% | 0.39 |
| canterbury/lcet10.txt | 426754 | 1 | 341.7 ± 0.3% | 131.6 ± 0.5% | 0.39 |
| canterbury/lcet10.txt | 426754 | 3 | 196.7 ± 1.1% | 112.1 ± 0.4% | 0.57 |
| canterbury/plrabn12.txt | 481861 | 1 | 326.9 ± 0.2% | 110.0 ± 0.5% | 0.34 |
| canterbury/plrabn12.txt | 481861 | 3 | 162.4 ± 0.7% | 93.7 ± 0.8% | 0.58 |
| canterbury/ptt5 | 513216 | 1 | 1085.1 ± 0.2% | 377.5 ± 0.5% | 0.35 |
| canterbury/ptt5 | 513216 | 3 | 670.5 ± 0.4% | 308.2 ± 0.4% | 0.46 |
| canterbury/sum | 38240 | 1 | 524.7 ± 0.4% | 168.9 ± 0.5% | 0.32 |
| canterbury/sum | 38240 | 3 | 384.8 ± 1.1% | 145.9 ± 0.7% | 0.38 |
| canterbury/xargs.1 | 4227 | 1 | 340.8 ± 0.5% | 143.3 ± 0.3% | 0.42 |
| canterbury/xargs.1 | 4227 | 3 | 282.7 ± 0.1% | 133.9 ± 0.5% | 0.47 |
| canterbury-large/E.coli | 4638690 | 1 | 321.9 ± 0.3% | 133.0 ± 0.2% | 0.41 |
| canterbury-large/E.coli | 4638690 | 3 | 218.0 ± 0.9% | 122.7 ± 0.6% | 0.56 |
| canterbury-large/bible.txt | 4047392 | 1 | 342.4 ± 0.6% | 140.6 ± 0.4% | 0.41 |
| canterbury-large/bible.txt | 4047392 | 3 | 178.0 ± 1.2% | 106.1 ± 1.5% | 0.60 |
| canterbury-large/world192.txt | 2473400 | 1 | 412.3 ± 0.4% | 155.1 ± 0.4% | 0.38 |
| canterbury-large/world192.txt | 2473400 | 3 | 213.5 ± 0.6% | 119.1 ± 0.7% | 0.56 |
| http/html-1kx1024 | 1048576 | 1 | 198.1 ± 0.2% | 87.6 ± 0.2% | 0.44 |
| http/html-1kx1024 | 1048576 | 3 | 176.1 ± 0.2% | 82.3 ± 0.2% | 0.47 |
| http/html-16kx64 | 1048576 | 1 | 432.4 ± 0.1% | 201.2 ± 0.1% | 0.47 |
| http/html-16kx64 | 1048576 | 3 | 379.1 ± 0.2% | 188.9 ± 0.3% | 0.50 |
| http/html-1m | 1048576 | 1 | 535.0 ± 0.6% | 220.2 ± 0.4% | 0.41 |
| http/html-1m | 1048576 | 3 | 348.8 ± 0.5% | 185.9 ± 0.5% | 0.53 |
| http/json-1kx1024 | 1048576 | 1 | 236.5 ± 0.1% | 108.2 ± 0.2% | 0.46 |
| http/json-1kx1024 | 1048576 | 3 | 227.2 ± 0.1% | 103.8 ± 0.2% | 0.46 |
| http/json-16kx64 | 1048576 | 1 | 705.6 ± 0.2% | 293.1 ± 0.5% | 0.42 |
| http/json-16kx64 | 1048576 | 3 | 625.7 ± 0.6% | 270.7 ± 1.4% | 0.43 |
| http/json-1m | 1048576 | 1 | 829.8 ± 0.5% | 312.0 ± 0.5% | 0.38 |
| http/json-1m | 1048576 | 3 | 526.6 ± 0.7% | 256.3 ± 0.6% | 0.49 |
| http/js-1kx1024 | 1048576 | 1 | 182.1 ± 0.2% | 78.1 ± 0.6% | 0.43 |
| http/js-1kx1024 | 1048576 | 3 | 157.1 ± 0.1% | 74.0 ± 0.8% | 0.47 |
| http/js-16kx64 | 1048576 | 1 | 377.7 ± 0.2% | 170.1 ± 0.1% | 0.45 |
| http/js-16kx64 | 1048576 | 3 | 331.4 ± 0.4% | 162.0 ± 0.8% | 0.49 |
| http/js-1m | 1048576 | 1 | 510.1 ± 0.5% | 202.8 ± 1.1% | 0.40 |
| http/js-1m | 1048576 | 3 | 328.7 ± 0.6% | 174.4 ± 0.5% | 0.53 |
| http/css-1kx1024 | 1048576 | 1 | 216.9 ± 0.2% | 97.9 ± 0.1% | 0.45 |
| http/css-1kx1024 | 1048576 | 3 | 201.9 ± 0.1% | 94.5 ± 0.2% | 0.47 |
| http/css-16kx64 | 1048576 | 1 | 545.8 ± 0.1% | 228.7 ± 0.6% | 0.42 |
| http/css-16kx64 | 1048576 | 3 | 511.9 ± 0.3% | 224.7 ± 0.6% | 0.44 |
| http/css-1m | 1048576 | 1 | 2280.7 ± 0.4% | 740.8 ± 0.3% | 0.32 |
| http/css-1m | 1048576 | 3 | 1711.8 ± 0.4% | 756.6 ± 0.8% | 0.44 |
| shuffled/dickens-1m | 1048576 | 1 | 960.0 ± 0.2% | 236.1 ± 1.1% | 0.25 |
| shuffled/dickens-1m | 1048576 | 3 | 113.2 ± 0.5% | 126.7 ± 0.6% | 1.12 |

## Encoding ratio

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, ratio | stdx, ratio | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 2.392 | 2.513 | 1.051 |
| silesia/dickens | 10192446 | 3 | 2.782 | 2.770 | 0.996 |
| silesia/mozilla | 51220480 | 1 | 2.565 | 2.627 | 1.024 |
| silesia/mozilla | 51220480 | 3 | 2.810 | 2.718 | 0.967 |
| silesia/mr | 9970564 | 1 | 2.615 | 2.765 | 1.058 |
| silesia/mr | 9970564 | 3 | 2.811 | 2.793 | 0.994 |
| silesia/nci | 33553445 | 1 | 11.779 | 9.291 | 0.789 |
| silesia/nci | 33553445 | 3 | 11.840 | 10.252 | 0.866 |
| silesia/ooffice | 6152192 | 1 | 1.712 | 1.907 | 1.114 |
| silesia/ooffice | 6152192 | 3 | 1.968 | 1.947 | 0.990 |
| silesia/osdb | 10085684 | 1 | 2.704 | 2.824 | 1.045 |
| silesia/osdb | 10085684 | 3 | 2.880 | 2.869 | 0.996 |
| silesia/reymont | 6627202 | 1 | 3.084 | 2.989 | 0.969 |
| silesia/reymont | 6627202 | 3 | 3.420 | 3.397 | 0.993 |
| silesia/samba | 21606400 | 1 | 3.937 | 3.888 | 0.987 |
| silesia/samba | 21606400 | 3 | 4.360 | 4.237 | 0.972 |
| silesia/sao | 7251944 | 1 | 1.160 | 1.291 | 1.112 |
| silesia/sao | 7251944 | 3 | 1.312 | 1.304 | 0.994 |
| silesia/webster | 41458703 | 1 | 3.035 | 3.107 | 1.024 |
| silesia/webster | 41458703 | 3 | 3.427 | 3.406 | 0.994 |
| silesia/x-ray | 8474240 | 1 | 1.251 | 1.363 | 1.089 |
| silesia/x-ray | 8474240 | 3 | 1.393 | 1.363 | 0.979 |
| silesia/xml | 5345280 | 1 | 7.710 | 6.565 | 0.851 |
| silesia/xml | 5345280 | 3 | 8.414 | 7.806 | 0.928 |
| canterbury/alice29.txt | 152089 | 1 | 2.549 | 2.555 | 1.002 |
| canterbury/alice29.txt | 152089 | 3 | 2.670 | 2.713 | 1.016 |
| canterbury/asyoulik.txt | 125179 | 1 | 2.296 | 2.397 | 1.044 |
| canterbury/asyoulik.txt | 125179 | 3 | 2.487 | 2.488 | 1.000 |
| canterbury/cp.html | 24603 | 1 | 2.789 | 2.838 | 1.017 |
| canterbury/cp.html | 24603 | 3 | 2.907 | 2.905 | 1.000 |
| canterbury/fields.c | 11150 | 1 | 3.136 | 3.136 | 1.000 |
| canterbury/fields.c | 11150 | 3 | 3.299 | 3.277 | 0.993 |
| canterbury/grammar.lsp | 3721 | 1 | 2.783 | 2.769 | 0.995 |
| canterbury/grammar.lsp | 3721 | 3 | 2.882 | 2.845 | 0.987 |
| canterbury/kennedy.xls | 1029744 | 1 | 8.924 | 7.381 | 0.827 |
| canterbury/kennedy.xls | 1029744 | 3 | 9.208 | 8.369 | 0.909 |
| canterbury/lcet10.txt | 426754 | 1 | 2.692 | 2.754 | 1.023 |
| canterbury/lcet10.txt | 426754 | 3 | 3.026 | 3.007 | 0.994 |
| canterbury/plrabn12.txt | 481861 | 1 | 2.212 | 2.355 | 1.065 |
| canterbury/plrabn12.txt | 481861 | 3 | 2.514 | 2.504 | 0.996 |
| canterbury/ptt5 | 513216 | 1 | 9.933 | 8.713 | 0.877 |
| canterbury/ptt5 | 513216 | 3 | 9.431 | 8.870 | 0.941 |
| canterbury/sum | 38240 | 1 | 2.808 | 2.765 | 0.985 |
| canterbury/sum | 38240 | 3 | 2.859 | 2.809 | 0.982 |
| canterbury/xargs.1 | 4227 | 1 | 2.273 | 2.269 | 0.998 |
| canterbury/xargs.1 | 4227 | 3 | 2.350 | 2.294 | 0.976 |
| canterbury-large/E.coli | 4638690 | 1 | 3.285 | 3.186 | 0.970 |
| canterbury-large/E.coli | 4638690 | 3 | 3.332 | 3.293 | 0.988 |
| canterbury-large/bible.txt | 4047392 | 1 | 3.124 | 3.040 | 0.973 |
| canterbury-large/bible.txt | 4047392 | 3 | 3.455 | 3.430 | 0.993 |
| canterbury-large/world192.txt | 2473400 | 1 | 3.228 | 3.329 | 1.031 |
| canterbury-large/world192.txt | 2473400 | 3 | 3.774 | 3.723 | 0.986 |
| http/html-1kx1024 | 1048576 | 1 | 2.541 | 2.550 | 1.004 |
| http/html-1kx1024 | 1048576 | 3 | 2.573 | 2.576 | 1.001 |
| http/html-16kx64 | 1048576 | 1 | 4.415 | 4.388 | 0.994 |
| http/html-16kx64 | 1048576 | 3 | 4.576 | 4.548 | 0.994 |
| http/html-1m | 1048576 | 1 | 5.232 | 5.110 | 0.977 |
| http/html-1m | 1048576 | 3 | 5.645 | 5.561 | 0.985 |
| http/json-1kx1024 | 1048576 | 1 | 4.607 | 4.560 | 0.990 |
| http/json-1kx1024 | 1048576 | 3 | 4.647 | 4.636 | 0.998 |
| http/json-16kx64 | 1048576 | 1 | 7.939 | 7.289 | 0.918 |
| http/json-16kx64 | 1048576 | 3 | 7.950 | 7.526 | 0.947 |
| http/json-1m | 1048576 | 1 | 7.648 | 7.267 | 0.950 |
| http/json-1m | 1048576 | 3 | 8.223 | 7.541 | 0.917 |
| http/js-1kx1024 | 1048576 | 1 | 2.233 | 2.236 | 1.001 |
| http/js-1kx1024 | 1048576 | 3 | 2.268 | 2.265 | 0.999 |
| http/js-16kx64 | 1048576 | 1 | 3.697 | 3.662 | 0.990 |
| http/js-16kx64 | 1048576 | 3 | 3.850 | 3.831 | 0.995 |
| http/js-1m | 1048576 | 1 | 4.776 | 4.676 | 0.979 |
| http/js-1m | 1048576 | 3 | 5.251 | 5.193 | 0.989 |
| http/css-1kx1024 | 1048576 | 1 | 3.381 | 3.397 | 1.005 |
| http/css-1kx1024 | 1048576 | 3 | 3.439 | 3.453 | 1.004 |
| http/css-16kx64 | 1048576 | 1 | 6.065 | 5.679 | 0.936 |
| http/css-16kx64 | 1048576 | 3 | 6.307 | 5.940 | 0.942 |
| http/css-1m | 1048576 | 1 | 26.317 | 21.892 | 0.832 |
| http/css-1m | 1048576 | 3 | 27.466 | 25.155 | 0.916 |
| shuffled/dickens-1m | 1048576 | 1 | 1.756 | 1.745 | 0.994 |
| shuffled/dickens-1m | 1048576 | 3 | 1.702 | 1.732 | 1.018 |

## stdx built ReleaseFast against libzstd, libzstd level 3 (decision 17)

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 939.8 ±1.3% | 918.2 ±2.3% | 0.98 |
| silesia/mozilla | 51220480 | 35.6 | 1173.9 ±0.8% | 1177.6 ±1.1% | 1.00 |
| silesia/mr | 9970564 | 35.6 | 1097.4 ±2.2% | 1067.7 ±2.2% | 0.97 |
| silesia/nci | 33553445 | 8.4 | 2032.9 ±2.1% | 1916.4 ±3.4% | 0.94 |
| silesia/ooffice | 6152192 | 50.8 | 974.6 ±1.9% | 993.8 ±1.6% | 1.02 |
| silesia/osdb | 10085684 | 34.7 | 1398.4 ±1.2% | 1372.4 ±1.0% | 0.98 |
| silesia/reymont | 6627202 | 29.2 | 1049.6 ±0.8% | 1003.6 ±1.4% | 0.96 |
| silesia/samba | 21606400 | 22.9 | 1592.9 ±0.7% | 1524.4 ±1.3% | 0.96 |
| silesia/sao | 7251944 | 76.2 | 864.8 ±1.1% | 949.2 ±1.8% | 1.10 |
| silesia/webster | 41458703 | 29.2 | 1028.5 ±2.7% | 975.3 ±3.5% | 0.95 |
| silesia/x-ray | 8474240 | 71.8 | 845.1 ±1.6% | 932.6 ±1.8% | 1.10 |
| silesia/xml | 5345280 | 11.9 | 2181.7 ±0.9% | 2226.1 ±0.7% | 1.02 |
| canterbury/alice29.txt | 152089 | 37.5 | 1008.0 ±0.3% | 1026.5 ±0.1% | 1.02 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1123.9 ±0.2% | 1136.4 ±0.2% | 1.01 |
| canterbury/cp.html | 24603 | 34.4 | 1271.2 ±0.3% | 1333.0 ±0.1% | 1.05 |
| canterbury/fields.c | 11150 | 30.3 | 1074.9 ±0.1% | 1105.2 ±0.1% | 1.03 |
| canterbury/grammar.lsp | 3721 | 34.8 | 800.3 ±0.1% | 822.5 ±0.1% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1345.8 ±0.3% | 1264.1 ±0.6% | 0.94 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1228.8 ±0.3% | 1255.7 ±0.5% | 1.02 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1062.8 ±0.3% | 1040.2 ±0.2% | 0.98 |
| canterbury/ptt5 | 513216 | 10.6 | 2363.0 ±0.3% | 2554.9 ±1.5% | 1.08 |
| canterbury/sum | 38240 | 35.0 | 1274.2 ±0.2% | 1292.3 ±0.1% | 1.01 |
| canterbury/xargs.1 | 4227 | 42.7 | 788.6 ±0.2% | 796.5 ±0.1% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1079.2 ±0.5% | 1049.1 ±0.8% | 0.97 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1106.9 ±0.6% | 1078.5 ±0.9% | 0.97 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1305.3 ±0.5% | 1245.8 ±0.7% | 0.95 |
| http/html-1kx1024 | 1048576 | 39.3 | 458.1 ±0.2% | 476.9 ±0.6% | 1.04 |
| http/html-16kx64 | 1048576 | 21.9 | 1272.9 ±0.2% | 1277.0 ±0.2% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1666.3 ±0.1% | 1668.7 ±0.6% | 1.00 |
| http/json-1kx1024 | 1048576 | 21.9 | 531.5 ±0.2% | 572.3 ±0.1% | 1.08 |
| http/json-16kx64 | 1048576 | 12.6 | 1661.1 ±0.1% | 1699.5 ±0.1% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1965.7 ±0.6% | 2083.0 ±0.6% | 1.06 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.6 ±0.1% | 390.6 ±0.2% | 0.97 |
| http/js-16kx64 | 1048576 | 26.0 | 1159.4 ±0.2% | 1149.2 ±0.1% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1663.5 ±0.3% | 1631.8 ±0.4% | 0.98 |
| http/css-1kx1024 | 1048576 | 29.5 | 481.8 ±0.2% | 518.8 ±0.5% | 1.08 |
| http/css-16kx64 | 1048576 | 15.9 | 1512.5 ±0.1% | 1508.8 ±0.2% | 1.00 |
| http/css-1m | 1048576 | 3.6 | 5062.3 ±0.5% | 4855.5 ±1.1% | 0.96 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1200.5 ±0.3% | 1227.6 ±0.5% | 1.02 |
