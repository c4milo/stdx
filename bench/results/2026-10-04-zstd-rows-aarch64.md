# bench-zstd

| Field | Value |
|---|---|
| Commit | 62875f6 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260927.135.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/37230098844 |
| Date | 2026-10-04 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 953.8 ±0.3% | 918.5 ±0.3% | 0.96 |
| silesia/mozilla | 51220480 | 35.6 | 1213.1 ±1.1% | 1228.8 ±1.2% | 1.01 |
| silesia/mr | 9970564 | 35.6 | 1108.2 ±0.1% | 1097.4 ±0.2% | 0.99 |
| silesia/nci | 33553445 | 8.4 | 2134.1 ±0.3% | 2114.9 ±1.6% | 0.99 |
| silesia/ooffice | 6152192 | 50.8 | 994.2 ±0.2% | 1019.0 ±0.5% | 1.02 |
| silesia/osdb | 10085684 | 34.7 | 1430.3 ±0.2% | 1393.9 ±0.8% | 0.97 |
| silesia/reymont | 6627202 | 29.2 | 1054.4 ±0.3% | 1005.5 ±0.4% | 0.95 |
| silesia/samba | 21606400 | 22.9 | 1661.6 ±0.6% | 1606.3 ±0.6% | 0.97 |
| silesia/sao | 7251944 | 76.2 | 893.5 ±0.2% | 975.0 ±0.4% | 1.09 |
| silesia/webster | 41458703 | 29.2 | 1061.2 ±0.4% | 1018.6 ±0.6% | 0.96 |
| silesia/x-ray | 8474240 | 71.8 | 854.0 ±0.2% | 956.4 ±0.1% | 1.12 |
| silesia/xml | 5345280 | 11.9 | 2194.0 ±0.4% | 2236.1 ±0.3% | 1.02 |
| canterbury/alice29.txt | 152089 | 37.5 | 1009.1 ±0.1% | 1027.2 ±0.1% | 1.02 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1128.8 ±0.1% | 1139.0 ±0.1% | 1.01 |
| canterbury/cp.html | 24603 | 34.4 | 1270.5 ±0.4% | 1340.6 ±0.2% | 1.06 |
| canterbury/fields.c | 11150 | 30.3 | 1081.0 ±0.2% | 1131.8 ±0.1% | 1.05 |
| canterbury/grammar.lsp | 3721 | 34.8 | 796.9 ±0.2% | 820.4 ±0.1% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1363.4 ±0.2% | 1269.9 ±0.2% | 0.93 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1231.8 ±0.3% | 1263.2 ±0.4% | 1.03 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1068.8 ±0.1% | 1073.2 ±0.2% | 1.00 |
| canterbury/ptt5 | 513216 | 10.6 | 2374.8 ±0.1% | 2571.8 ±0.4% | 1.08 |
| canterbury/sum | 38240 | 35.0 | 1281.6 ±0.3% | 1299.6 ±0.2% | 1.01 |
| canterbury/xargs.1 | 4227 | 42.7 | 789.6 ±0.2% | 796.9 ±0.1% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1095.3 ±0.3% | 1074.4 ±0.2% | 0.98 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1114.9 ±1.0% | 1097.1 ±0.5% | 0.98 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1318.9 ±0.3% | 1253.2 ±0.2% | 0.95 |
| http/html-1kx1024 | 1048576 | 39.3 | 457.0 ±0.0% | 450.8 ±0.1% | 0.99 |
| http/html-16kx64 | 1048576 | 21.9 | 1272.8 ±0.2% | 1276.2 ±0.2% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1682.8 ±0.2% | 1691.3 ±0.4% | 1.01 |
| http/json-1kx1024 | 1048576 | 21.9 | 530.1 ±0.0% | 544.7 ±0.2% | 1.03 |
| http/json-16kx64 | 1048576 | 12.6 | 1657.5 ±0.1% | 1689.6 ±0.2% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1976.2 ±0.1% | 2100.3 ±0.1% | 1.06 |
| http/js-1kx1024 | 1048576 | 44.5 | 400.9 ±0.1% | 372.3 ±0.1% | 0.93 |
| http/js-16kx64 | 1048576 | 26.0 | 1158.7 ±0.2% | 1149.6 ±0.1% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1677.7 ±0.4% | 1612.8 ±0.6% | 0.96 |
| http/css-1kx1024 | 1048576 | 29.5 | 481.7 ±0.2% | 493.2 ±0.1% | 1.02 |
| http/css-16kx64 | 1048576 | 15.9 | 1520.9 ±0.5% | 1503.2 ±0.1% | 0.99 |
| http/css-1m | 1048576 | 3.6 | 5151.1 ±0.2% | 4846.8 ±0.7% | 0.94 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1203.8 ±0.2% | 1243.8 ±0.5% | 1.03 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 242.2 ±0.5% | 938.7 ±0.3% | 3.88 |
| silesia/mozilla | 51220480 | 35.6 | 279.7 ±0.2% | 1228.5 ±1.2% | 4.39 |
| silesia/mr | 9970564 | 35.6 | 247.8 ±0.2% | 1131.3 ±0.3% | 4.56 |
| silesia/nci | 33553445 | 8.4 | 696.4 ±0.2% | 2141.3 ±1.4% | 3.07 |
| silesia/ooffice | 6152192 | 50.8 | 195.4 ±0.4% | 1027.9 ±0.2% | 5.26 |
| silesia/osdb | 10085684 | 34.7 | 308.3 ±0.2% | 1438.3 ±0.1% | 4.66 |
| silesia/reymont | 6627202 | 29.2 | 291.2 ±0.5% | 1039.4 ±0.4% | 3.57 |
| silesia/samba | 21606400 | 22.9 | 456.8 ±0.5% | 1627.3 ±0.5% | 3.56 |
| silesia/sao | 7251944 | 76.2 | 165.1 ±0.2% | 986.0 ±0.1% | 5.97 |
| silesia/webster | 41458703 | 29.2 | 288.4 ±0.4% | 1055.0 ±0.4% | 3.66 |
| silesia/x-ray | 8474240 | 71.8 | 154.7 ±0.1% | 965.4 ±0.2% | 6.24 |
| silesia/xml | 5345280 | 11.9 | 631.5 ±0.2% | 2255.8 ±0.3% | 3.57 |
| canterbury/alice29.txt | 152089 | 37.5 | 221.1 ±0.1% | 1027.8 ±0.1% | 4.65 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 207.6 ±0.2% | 1138.8 ±0.1% | 5.49 |
| canterbury/cp.html | 24603 | 34.4 | 253.4 ±0.1% | 1327.7 ±0.3% | 5.24 |
| canterbury/fields.c | 11150 | 30.3 | 249.8 ±0.1% | 1131.4 ±0.0% | 4.53 |
| canterbury/grammar.lsp | 3721 | 34.8 | 214.5 ±0.4% | 820.0 ±0.1% | 3.82 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 296.0 ±1.0% | 1271.3 ±0.1% | 4.29 |
| canterbury/lcet10.txt | 426754 | 33.0 | 266.4 ±0.2% | 1264.9 ±0.1% | 4.75 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 218.9 ±1.0% | 1076.4 ±0.1% | 4.92 |
| canterbury/ptt5 | 513216 | 10.6 | 473.0 ±0.2% | 2597.4 ±1.7% | 5.49 |
| canterbury/sum | 38240 | 35.0 | 250.7 ±0.3% | 1296.7 ±0.1% | 5.17 |
| canterbury/xargs.1 | 4227 | 42.7 | 182.6 ±0.2% | 797.9 ±0.0% | 4.37 |
| canterbury-large/E.coli | 4638690 | 30.0 | 267.6 ±0.4% | 1102.9 ±0.4% | 4.12 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 300.6 ±0.0% | 1115.2 ±0.5% | 3.71 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 333.6 ±0.1% | 1310.1 ±0.4% | 3.93 |
| http/html-1kx1024 | 1048576 | 39.3 | 187.9 ±0.1% | 452.0 ±0.1% | 2.41 |
| http/html-16kx64 | 1048576 | 21.9 | 334.3 ±0.0% | 1285.3 ±0.2% | 3.84 |
| http/html-1m | 1048576 | 17.7 | 452.8 ±0.2% | 1721.5 ±0.4% | 3.80 |
| http/json-1kx1024 | 1048576 | 21.9 | 278.7 ±0.1% | 546.2 ±0.0% | 1.96 |
| http/json-16kx64 | 1048576 | 12.6 | 467.8 ±0.1% | 1699.0 ±0.2% | 3.63 |
| http/json-1m | 1048576 | 12.2 | 527.7 ±0.2% | 2106.3 ±0.2% | 3.99 |
| http/js-1kx1024 | 1048576 | 44.5 | 158.4 ±0.1% | 372.6 ±0.1% | 2.35 |
| http/js-16kx64 | 1048576 | 26.0 | 286.1 ±0.1% | 1158.5 ±0.2% | 4.05 |
| http/js-1m | 1048576 | 19.0 | 428.7 ±0.1% | 1664.0 ±0.1% | 3.88 |
| http/css-1kx1024 | 1048576 | 29.5 | 234.3 ±0.1% | 494.8 ±0.1% | 2.11 |
| http/css-16kx64 | 1048576 | 15.9 | 420.9 ±0.2% | 1504.3 ±0.1% | 3.57 |
| http/css-1m | 1048576 | 3.6 | 1770.8 ±0.3% | 4904.5 ±0.8% | 2.77 |
| shuffled/dickens-1m | 1048576 | 58.8 | 153.4 ±0.1% | 1257.5 ±0.4% | 8.20 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 959.6 ±0.2% | 0.93 ±0.3% | 1.00 ±0.4% | 0.59 ±0.4% | 0.97 ±0.3% | 0.39 ±0.3% |
| silesia/mozilla | 51220480 | 35.6 | 1226.7 ±0.7% | 0.73 ±0.6% | 1.01 ±0.6% | 0.60 ±0.5% | 0.99 ±0.4% | 0.44 ±0.2% |
| silesia/mr | 9970564 | 35.6 | 1127.1 ±0.4% | 0.82 ±0.2% | 1.00 ±0.5% | 0.57 ±0.2% | 0.97 ±0.4% | 0.39 ±0.5% |
| silesia/nci | 33553445 | 8.4 | 2116.8 ±0.9% | 0.92 ±0.4% | 1.00 ±0.4% | 0.65 ±0.8% | 0.99 ±0.4% | 0.45 ±0.4% |
| silesia/ooffice | 6152192 | 50.8 | 1021.8 ±0.6% | 0.62 ±0.6% | 1.00 ±0.7% | 0.59 ±0.5% | 0.99 ±0.5% | 0.46 ±0.4% |
| silesia/osdb | 10085684 | 34.7 | 1438.7 ±0.2% | 0.67 ±0.3% | 1.00 ±0.7% | 0.68 ±0.2% | 0.97 ±0.5% | 0.46 ±0.3% |
| silesia/reymont | 6627202 | 29.2 | 1037.9 ±0.3% | 0.96 ±0.2% | 1.00 ±0.3% | 0.63 ±0.2% | 0.98 ±0.4% | 0.41 ±0.2% |
| silesia/samba | 21606400 | 22.9 | 1612.7 ±0.6% | 0.92 ±0.6% | 1.00 ±0.7% | 0.63 ±0.6% | 0.99 ±0.3% | 0.43 ±0.4% |
| silesia/sao | 7251944 | 76.2 | 979.8 ±0.5% | 0.51 ±0.2% | 1.00 ±0.5% | 0.69 ±0.3% | 0.98 ±0.3% | 0.53 ±0.3% |
| silesia/webster | 41458703 | 29.2 | 1051.9 ±0.7% | 0.92 ±0.3% | 1.00 ±0.3% | 0.62 ±1.0% | 0.97 ±0.6% | 0.41 ±0.2% |
| silesia/x-ray | 8474240 | 71.8 | 959.8 ±0.6% | 0.51 ±0.4% | 1.00 ±0.6% | 0.65 ±0.3% | 0.98 ±0.7% | 0.48 ±0.3% |
| silesia/xml | 5345280 | 11.9 | 2246.2 ±0.6% | 0.93 ±0.7% | 1.00 ±0.4% | 0.61 ±0.4% | 0.99 ±0.6% | 0.42 ±0.3% |
| canterbury/alice29.txt | 152089 | 37.5 | 1027.8 ±0.2% | 0.94 ±0.3% | 1.00 ±0.2% | 0.54 ±0.2% | 0.99 ±0.1% | 0.36 ±0.1% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1138.3 ±0.2% | 0.85 ±0.1% | 0.98 ±0.0% | 0.51 ±0.2% | 0.99 ±0.2% | 0.37 ±0.2% |
| canterbury/cp.html | 24603 | 34.4 | 1338.2 ±0.2% | 0.63 ±0.1% | 1.00 ±0.4% | 0.63 ±0.6% | 0.99 ±0.1% | 0.45 ±0.2% |
| canterbury/fields.c | 11150 | 30.3 | 1131.4 ±0.2% | 0.81 ±0.1% | 1.00 ±0.4% | 0.59 ±0.4% | 0.99 ±0.3% | 0.41 ±0.1% |
| canterbury/grammar.lsp | 3721 | 34.8 | 821.5 ±0.1% | 0.79 ±0.1% | 1.00 ±0.1% | 0.67 ±0.3% | 0.99 ±0.1% | 0.49 ±0.1% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1273.8 ±0.3% | 0.86 ±0.6% | 1.01 ±0.2% | 0.58 ±0.1% | 1.00 ±0.1% | 0.38 ±0.1% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1265.4 ±0.1% | 0.89 ±0.1% | 1.00 ±0.1% | 0.54 ±0.1% | 0.99 ±0.3% | 0.35 ±0.3% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1075.3 ±0.1% | 0.90 ±0.4% | 0.99 ±0.1% | 0.52 ±0.2% | 0.99 ±0.1% | 0.36 ±0.1% |
| canterbury/ptt5 | 513216 | 10.6 | 2564.6 ±0.7% | 0.81 ±1.3% | 1.02 ±1.6% | 0.56 ±0.2% | 1.00 ±2.3% | 0.44 ±0.1% |
| canterbury/sum | 38240 | 35.0 | 1295.8 ±0.1% | 0.64 ±0.1% | 1.00 ±0.1% | 0.64 ±0.4% | 0.99 ±0.1% | 0.45 ±0.4% |
| canterbury/xargs.1 | 4227 | 42.7 | 798.1 ±0.1% | 0.74 ±0.0% | 1.00 ±0.1% | 0.64 ±0.5% | 0.99 ±0.3% | 0.47 ±0.2% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1100.4 ±0.2% | 0.98 ±0.2% | 1.00 ±0.2% | 0.58 ±0.2% | 0.98 ±0.4% | 0.36 ±0.5% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1118.4 ±0.1% | 0.96 ±0.3% | 1.00 ±0.5% | 0.61 ±0.2% | 0.97 ±0.2% | 0.39 ±0.5% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1308.7 ±0.5% | 0.90 ±0.4% | 1.00 ±0.2% | 0.60 ±0.2% | 0.98 ±0.2% | 0.41 ±0.3% |
| http/html-1kx1024 | 1048576 | 39.3 | 451.2 ±0.1% | 0.86 ±0.1% | 1.01 ±0.3% | 0.79 ±0.1% | 0.99 ±0.1% | 0.67 ±0.0% |
| http/html-16kx64 | 1048576 | 21.9 | 1284.6 ±0.3% | 0.83 ±0.3% | 1.00 ±0.3% | 0.62 ±0.1% | 0.99 ±0.2% | 0.46 ±0.0% |
| http/html-1m | 1048576 | 17.7 | 1710.2 ±0.5% | 0.94 ±0.4% | 1.01 ±0.2% | 0.60 ±0.4% | 0.99 ±0.2% | 0.40 ±0.2% |
| http/json-1kx1024 | 1048576 | 21.9 | 545.7 ±0.0% | 0.98 ±0.2% | 1.00 ±0.1% | 0.82 ±0.0% | 0.99 ±0.0% | 0.68 ±0.1% |
| http/json-16kx64 | 1048576 | 12.6 | 1694.4 ±0.2% | 0.85 ±0.2% | 1.00 ±0.2% | 0.64 ±0.1% | 0.99 ±0.1% | 0.47 ±0.1% |
| http/json-1m | 1048576 | 12.2 | 2107.8 ±0.5% | 0.88 ±0.5% | 1.00 ±0.8% | 0.58 ±0.1% | 0.99 ±0.2% | 0.40 ±0.2% |
| http/js-1kx1024 | 1048576 | 44.5 | 373.1 ±0.2% | 0.86 ±0.1% | 1.00 ±0.1% | 0.79 ±0.1% | 0.99 ±0.1% | 0.67 ±0.1% |
| http/js-16kx64 | 1048576 | 26.0 | 1154.1 ±0.2% | 0.82 ±0.2% | 1.00 ±0.3% | 0.61 ±0.2% | 0.99 ±0.1% | 0.45 ±0.2% |
| http/js-1m | 1048576 | 19.0 | 1662.3 ±0.4% | 0.91 ±0.1% | 1.00 ±0.3% | 0.59 ±0.5% | 0.99 ±0.4% | 0.40 ±0.1% |
| http/css-1kx1024 | 1048576 | 29.5 | 493.6 ±0.1% | 0.94 ±0.1% | 1.01 ±0.1% | 0.80 ±0.1% | 0.99 ±0.1% | 0.67 ±0.1% |
| http/css-16kx64 | 1048576 | 15.9 | 1504.5 ±0.2% | 0.89 ±0.1% | 1.00 ±0.1% | 0.65 ±0.3% | 0.99 ±0.1% | 0.45 ±0.1% |
| http/css-1m | 1048576 | 3.6 | 4915.1 ±0.5% | 0.95 ±0.5% | 1.00 ±0.8% | 0.71 ±0.4% | 0.99 ±0.4% | 0.46 ±0.1% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1249.6 ±0.2% | 0.52 ±0.1% | 0.86 ±0.4% | 0.74 ±0.1% | 0.98 ±0.3% | 0.56 ±0.5% |

## stdx built ReleaseFast against libzstd, libzstd level 3 (decision 17)

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 955.7 ±0.1% | 913.8 ±0.4% | 0.96 |
| silesia/mozilla | 51220480 | 35.6 | 1201.1 ±0.9% | 1231.3 ±1.7% | 1.03 |
| silesia/mr | 9970564 | 35.6 | 1109.3 ±0.3% | 1091.1 ±0.4% | 0.98 |
| silesia/nci | 33553445 | 8.4 | 2119.2 ±0.4% | 2123.1 ±0.8% | 1.00 |
| silesia/ooffice | 6152192 | 50.8 | 991.8 ±0.1% | 1016.4 ±0.2% | 1.02 |
| silesia/osdb | 10085684 | 34.7 | 1433.0 ±0.3% | 1394.6 ±0.2% | 0.97 |
| silesia/reymont | 6627202 | 29.2 | 1053.3 ±0.2% | 1002.0 ±0.3% | 0.95 |
| silesia/samba | 21606400 | 22.9 | 1659.8 ±0.3% | 1610.1 ±0.2% | 0.97 |
| silesia/sao | 7251944 | 76.2 | 898.7 ±0.2% | 977.8 ±0.1% | 1.09 |
| silesia/webster | 41458703 | 29.2 | 1069.7 ±0.7% | 1021.1 ±0.4% | 0.95 |
| silesia/x-ray | 8474240 | 71.8 | 856.5 ±0.2% | 951.7 ±0.5% | 1.11 |
| silesia/xml | 5345280 | 11.9 | 2178.8 ±0.1% | 2225.3 ±0.2% | 1.02 |
| canterbury/alice29.txt | 152089 | 37.5 | 1011.6 ±0.2% | 1025.7 ±0.1% | 1.01 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1130.7 ±0.2% | 1132.4 ±0.1% | 1.00 |
| canterbury/cp.html | 24603 | 34.4 | 1249.7 ±0.3% | 1336.0 ±0.2% | 1.07 |
| canterbury/fields.c | 11150 | 30.3 | 1071.1 ±0.2% | 1120.8 ±0.1% | 1.05 |
| canterbury/grammar.lsp | 3721 | 34.8 | 788.0 ±0.1% | 824.5 ±0.1% | 1.05 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1352.8 ±0.1% | 1270.4 ±0.2% | 0.94 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1235.7 ±0.1% | 1252.8 ±0.3% | 1.01 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1065.6 ±0.1% | 1066.0 ±0.1% | 1.00 |
| canterbury/ptt5 | 513216 | 10.6 | 2369.0 ±0.3% | 2579.0 ±2.8% | 1.09 |
| canterbury/sum | 38240 | 35.0 | 1243.2 ±0.1% | 1293.7 ±0.0% | 1.04 |
| canterbury/xargs.1 | 4227 | 42.7 | 782.0 ±0.3% | 796.7 ±0.1% | 1.02 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1086.8 ±0.2% | 1061.8 ±0.4% | 0.98 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1118.6 ±0.5% | 1083.0 ±0.5% | 0.97 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1318.4 ±0.2% | 1261.4 ±0.6% | 0.96 |
| http/html-1kx1024 | 1048576 | 39.3 | 458.5 ±0.1% | 478.1 ±0.1% | 1.04 |
| http/html-16kx64 | 1048576 | 21.9 | 1274.2 ±0.3% | 1278.1 ±0.3% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1691.2 ±0.3% | 1693.2 ±0.4% | 1.00 |
| http/json-1kx1024 | 1048576 | 21.9 | 531.5 ±0.0% | 573.5 ±0.0% | 1.08 |
| http/json-16kx64 | 1048576 | 12.6 | 1653.7 ±0.0% | 1697.3 ±0.2% | 1.03 |
| http/json-1m | 1048576 | 12.2 | 1952.6 ±0.2% | 2098.7 ±0.5% | 1.07 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.6 ±0.1% | 390.7 ±0.0% | 0.97 |
| http/js-16kx64 | 1048576 | 26.0 | 1154.4 ±0.2% | 1144.2 ±0.2% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1671.6 ±0.5% | 1629.2 ±0.2% | 0.97 |
| http/css-1kx1024 | 1048576 | 29.5 | 479.0 ±0.1% | 517.9 ±0.2% | 1.08 |
| http/css-16kx64 | 1048576 | 15.9 | 1479.6 ±0.1% | 1506.4 ±0.4% | 1.02 |
| http/css-1m | 1048576 | 3.6 | 5077.6 ±0.3% | 4859.4 ±0.6% | 0.96 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1204.9 ±0.2% | 1232.6 ±0.5% | 1.02 |
