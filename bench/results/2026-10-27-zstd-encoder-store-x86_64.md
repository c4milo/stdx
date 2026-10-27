# bench-zstd

| Field | Value |
|---|---|
| Commit | 8f8e979 |
| Runner label | ubuntu-24.04 |
| Image version | 20261023.334.3 |
| CPU model | Intel(R) Xeon(R) 6973P-C |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/40578095901 |
| Date | 2026-10-27 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 1001.8 ±1.5% | 1223.7 ±0.4% | 1.22 |
| silesia/mozilla | 51220480 | 35.6 | 1068.3 ±12.8% | 1233.2 ±4.4% | 1.15 |
| silesia/mr | 9970564 | 35.6 | 1110.9 ±1.0% | 1376.5 ±0.2% | 1.24 |
| silesia/nci | 33553445 | 8.4 | 2249.0 ±2.8% | 2555.3 ±5.0% | 1.14 |
| silesia/ooffice | 6152192 | 50.8 | 973.8 ±0.7% | 1126.1 ±1.0% | 1.16 |
| silesia/osdb | 10085684 | 34.7 | 1513.0 ±0.4% | 1685.9 ±0.2% | 1.11 |
| silesia/reymont | 6627202 | 29.2 | 1193.3 ±1.2% | 1353.8 ±2.1% | 1.13 |
| silesia/samba | 21606400 | 22.9 | 1680.1 ±1.2% | 1822.3 ±7.6% | 1.08 |
| silesia/sao | 7251944 | 76.2 | 765.8 ±6.6% | 990.4 ±2.5% | 1.29 |
| silesia/webster | 41458703 | 29.2 | 1051.4 ±3.8% | 1070.2 ±8.7% | 1.02 |
| silesia/x-ray | 8474240 | 71.8 | 802.4 ±13.8% | 976.5 ±15.4% | 1.22 |
| silesia/xml | 5345280 | 11.9 | 1973.0 ±1.2% | 2317.6 ±0.2% | 1.17 |
| canterbury/alice29.txt | 152089 | 37.5 | 941.6 ±0.3% | 1135.6 ±1.1% | 1.21 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1063.5 ±0.7% | 1270.7 ±0.7% | 1.19 |
| canterbury/cp.html | 24603 | 34.4 | 1271.6 ±3.8% | 1509.5 ±2.1% | 1.19 |
| canterbury/fields.c | 11150 | 30.3 | 1087.8 ±0.7% | 1264.7 ±0.4% | 1.16 |
| canterbury/grammar.lsp | 3721 | 34.8 | 849.5 ±0.3% | 951.5 ±4.0% | 1.12 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1224.7 ±19.8% | 1348.7 ±17.4% | 1.10 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1169.9 ±0.1% | 1396.9 ±0.6% | 1.19 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 997.6 ±1.0% | 1207.6 ±0.3% | 1.21 |
| canterbury/ptt5 | 513216 | 10.6 | 2425.5 ±3.2% | 2656.4 ±9.4% | 1.10 |
| canterbury/sum | 38240 | 35.0 | 1191.4 ±16.3% | 1433.7 ±21.0% | 1.20 |
| canterbury/xargs.1 | 4227 | 42.7 | 815.6 ±0.3% | 918.8 ±0.1% | 1.13 |
| canterbury-large/E.coli | 4638690 | 30.0 | 957.9 ±1.2% | 1290.4 ±0.1% | 1.35 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1130.5 ±0.8% | 1371.6 ±0.3% | 1.21 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1416.3 ±1.7% | 1524.7 ±6.9% | 1.08 |
| http/html-1kx1024 | 1048576 | 39.3 | 480.2 ±0.9% | 477.7 ±0.8% | 0.99 |
| http/html-16kx64 | 1048576 | 21.9 | 1256.6 ±0.8% | 1307.8 ±0.5% | 1.04 |
| http/html-1m | 1048576 | 17.7 | 1678.2 ±0.9% | 1781.6 ±0.2% | 1.06 |
| http/json-1kx1024 | 1048576 | 21.9 | 562.9 ±0.6% | 575.8 ±0.7% | 1.02 |
| http/json-16kx64 | 1048576 | 12.6 | 1584.5 ±1.0% | 1763.6 ±0.3% | 1.11 |
| http/json-1m | 1048576 | 12.2 | 1876.8 ±0.5% | 2231.4 ±0.1% | 1.19 |
| http/js-1kx1024 | 1048576 | 44.5 | 427.1 ±0.7% | 394.4 ±0.1% | 0.92 |
| http/js-16kx64 | 1048576 | 26.0 | 1155.7 ±0.4% | 1219.6 ±0.2% | 1.06 |
| http/js-1m | 1048576 | 19.0 | 1653.8 ±0.4% | 1760.1 ±0.3% | 1.06 |
| http/css-1kx1024 | 1048576 | 29.5 | 515.5 ±0.9% | 522.4 ±0.2% | 1.01 |
| http/css-16kx64 | 1048576 | 15.9 | 1523.8 ±0.2% | 1563.5 ±0.2% | 1.03 |
| http/css-1m | 1048576 | 3.6 | 5108.9 ±0.3% | 5031.0 ±0.3% | 0.98 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1309.2 ±0.4% | 1524.8 ±0.9% | 1.16 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 290.6 ±1.5% | 1218.4 ±0.7% | 4.19 |
| silesia/mozilla | 51220480 | 35.6 | 311.7 ±2.8% | 1217.9 ±3.6% | 3.91 |
| silesia/mr | 9970564 | 35.6 | 299.3 ±1.1% | 1385.0 ±1.0% | 4.63 |
| silesia/nci | 33553445 | 8.4 | 724.0 ±2.1% | 2286.7 ±20.6% | 3.16 |
| silesia/ooffice | 6152192 | 50.8 | 232.8 ±0.4% | 1114.5 ±1.8% | 4.79 |
| silesia/osdb | 10085684 | 34.7 | 387.3 ±1.0% | 1686.2 ±0.3% | 4.35 |
| silesia/reymont | 6627202 | 29.2 | 350.2 ±0.9% | 1353.6 ±0.2% | 3.87 |
| silesia/samba | 21606400 | 22.9 | 505.8 ±5.2% | 1815.0 ±2.2% | 3.59 |
| silesia/sao | 7251944 | 76.2 | 210.5 ±4.3% | 1138.1 ±1.7% | 5.41 |
| silesia/webster | 41458703 | 29.2 | 328.4 ±1.6% | 1203.2 ±5.9% | 3.66 |
| silesia/x-ray | 8474240 | 71.8 | 194.7 ±0.7% | 1095.4 ±5.7% | 5.63 |
| silesia/xml | 5345280 | 11.9 | 683.5 ±1.1% | 2320.4 ±0.5% | 3.39 |
| canterbury/alice29.txt | 152089 | 37.5 | 250.3 ±0.2% | 1135.2 ±0.1% | 4.53 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 236.9 ±0.5% | 1271.1 ±0.2% | 5.37 |
| canterbury/cp.html | 24603 | 34.4 | 277.2 ±15.8% | 1298.4 ±14.4% | 4.68 |
| canterbury/fields.c | 11150 | 30.3 | 270.0 ±0.3% | 1081.1 ±0.7% | 4.00 |
| canterbury/grammar.lsp | 3721 | 34.8 | 234.4 ±1.7% | 821.7 ±1.6% | 3.51 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 307.7 ±14.0% | 1213.4 ±14.6% | 3.94 |
| canterbury/lcet10.txt | 426754 | 33.0 | 295.8 ±15.7% | 1392.5 ±7.3% | 4.71 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 246.5 ±0.4% | 1205.7 ±0.2% | 4.89 |
| canterbury/ptt5 | 513216 | 10.6 | 552.1 ±1.4% | 2700.9 ±1.5% | 4.89 |
| canterbury/sum | 38240 | 35.0 | 315.8 ±0.7% | 1442.3 ±0.2% | 4.57 |
| canterbury/xargs.1 | 4227 | 42.7 | 231.3 ±1.1% | 915.6 ±5.0% | 3.96 |
| canterbury-large/E.coli | 4638690 | 30.0 | 306.8 ±0.6% | 1290.3 ±0.2% | 4.21 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 360.7 ±0.6% | 1372.2 ±1.1% | 3.80 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 378.5 ±1.1% | 1515.7 ±2.3% | 4.00 |
| http/html-1kx1024 | 1048576 | 39.3 | 214.7 ±0.8% | 478.3 ±2.1% | 2.23 |
| http/html-16kx64 | 1048576 | 21.9 | 365.5 ±17.0% | 1250.9 ±15.9% | 3.42 |
| http/html-1m | 1048576 | 17.7 | 485.9 ±15.1% | 1776.6 ±13.8% | 3.66 |
| http/json-1kx1024 | 1048576 | 21.9 | 315.6 ±0.3% | 573.8 ±0.4% | 1.82 |
| http/json-16kx64 | 1048576 | 12.6 | 517.4 ±0.6% | 1759.1 ±0.3% | 3.40 |
| http/json-1m | 1048576 | 12.2 | 587.2 ±0.4% | 2225.1 ±0.6% | 3.79 |
| http/js-1kx1024 | 1048576 | 44.5 | 178.8 ±0.1% | 393.9 ±0.2% | 2.20 |
| http/js-16kx64 | 1048576 | 26.0 | 318.4 ±0.3% | 1218.5 ±0.2% | 3.83 |
| http/js-1m | 1048576 | 19.0 | 469.4 ±1.8% | 1756.0 ±0.6% | 3.74 |
| http/css-1kx1024 | 1048576 | 29.5 | 268.4 ±0.1% | 522.7 ±0.3% | 1.95 |
| http/css-16kx64 | 1048576 | 15.9 | 457.4 ±0.3% | 1568.1 ±0.3% | 3.43 |
| http/css-1m | 1048576 | 3.6 | 1894.9 ±0.3% | 5028.3 ±1.3% | 2.65 |
| shuffled/dickens-1m | 1048576 | 58.8 | 201.3 ±0.8% | 1528.7 ±0.2% | 7.60 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 1192.9 ±2.0% | 0.91 ±4.2% | 1.00 ±2.9% | 0.51 ±1.3% | 0.98 ±3.4% | 0.38 ±1.8% |
| silesia/mozilla | 51220480 | 35.6 | 1210.1 ±1.5% | 0.72 ±1.6% | 1.01 ±1.8% | 0.57 ±4.8% | 0.99 ±3.5% | 0.46 ±2.0% |
| silesia/mr | 9970564 | 35.6 | 1332.8 ±1.4% | 0.76 ±2.7% | 1.00 ±2.1% | 0.49 ±4.0% | 0.99 ±2.5% | 0.40 ±1.6% |
| silesia/nci | 33553445 | 8.4 | 2185.4 ±24.3% | 0.88 ±13.7% | 1.02 ±21.4% | 0.59 ±11.7% | 0.89 ±13.1% | 0.42 ±13.7% |
| silesia/ooffice | 6152192 | 50.8 | 937.9 ±17.3% | 0.59 ±13.8% | 1.01 ±14.7% | 0.54 ±11.1% | 1.02 ±14.8% | 0.44 ±15.9% |
| silesia/osdb | 10085684 | 34.7 | 1651.2 ±20.8% | 0.61 ±17.0% | 0.97 ±17.7% | 0.57 ±14.5% | 0.98 ±16.2% | 0.46 ±16.6% |
| silesia/reymont | 6627202 | 29.2 | 1338.5 ±2.2% | 0.93 ±6.2% | 1.00 ±1.5% | 0.53 ±2.7% | 0.98 ±1.8% | 0.39 ±2.9% |
| silesia/samba | 21606400 | 22.9 | 1694.8 ±2.7% | 0.92 ±2.4% | 1.02 ±2.2% | 0.55 ±3.7% | 1.02 ±1.8% | 0.44 ±2.5% |
| silesia/sao | 7251944 | 76.2 | 1121.9 ±1.6% | 0.45 ±1.6% | 1.01 ±1.8% | 0.60 ±4.8% | 0.99 ±1.2% | 0.48 ±3.8% |
| silesia/webster | 41458703 | 29.2 | 1176.1 ±0.9% | 0.90 ±2.5% | 0.99 ±2.7% | 0.56 ±2.8% | 0.96 ±2.5% | 0.45 ±1.7% |
| silesia/x-ray | 8474240 | 71.8 | 1026.4 ±3.6% | 0.47 ±0.7% | 1.02 ±3.0% | 0.59 ±5.5% | 1.02 ±1.4% | 0.45 ±4.6% |
| silesia/xml | 5345280 | 11.9 | 1989.6 ±14.5% | 0.91 ±14.6% | 1.02 ±15.1% | 0.57 ±11.2% | 1.00 ±5.6% | 0.41 ±3.0% |
| canterbury/alice29.txt | 152089 | 37.5 | 1129.0 ±15.2% | 0.92 ±13.9% | 1.00 ±15.8% | 0.49 ±17.2% | 0.97 ±15.1% | 0.37 ±13.7% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1270.8 ±0.8% | 0.81 ±0.2% | 0.97 ±0.4% | 0.45 ±0.8% | 0.99 ±0.3% | 0.38 ±0.6% |
| canterbury/cp.html | 24603 | 34.4 | 1508.1 ±0.4% | 0.58 ±0.9% | 1.00 ±0.1% | 0.67 ±1.7% | 0.99 ±0.4% | 0.48 ±0.6% |
| canterbury/fields.c | 11150 | 30.3 | 1265.5 ±1.0% | 0.77 ±0.4% | 1.00 ±0.2% | 0.62 ±0.5% | 0.99 ±0.1% | 0.43 ±0.5% |
| canterbury/grammar.lsp | 3721 | 34.8 | 947.5 ±0.2% | 0.74 ±0.1% | 1.00 ±0.3% | 0.69 ±0.4% | 0.99 ±0.2% | 0.51 ±0.6% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1378.9 ±0.2% | 0.83 ±0.1% | 1.01 ±0.2% | 0.57 ±0.3% | 1.00 ±0.8% | 0.40 ±0.5% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1397.1 ±0.2% | 0.87 ±0.3% | 1.00 ±0.3% | 0.49 ±0.3% | 0.99 ±0.2% | 0.38 ±0.7% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1122.6 ±13.3% | 0.91 ±12.8% | 0.95 ±12.5% | 0.43 ±16.9% | 0.93 ±14.6% | 0.35 ±16.2% |
| canterbury/ptt5 | 513216 | 10.6 | 2286.1 ±0.8% | 0.78 ±12.4% | 1.01 ±8.6% | 0.53 ±2.1% | 0.99 ±2.9% | 0.45 ±1.1% |
| canterbury/sum | 38240 | 35.0 | 1425.7 ±13.8% | 0.58 ±15.4% | 1.01 ±12.9% | 0.69 ±6.5% | 1.00 ±13.3% | 0.50 ±4.7% |
| canterbury/xargs.1 | 4227 | 42.7 | 916.3 ±0.2% | 0.68 ±0.2% | 0.99 ±0.3% | 0.66 ±0.5% | 1.00 ±0.5% | 0.49 ±0.6% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1275.0 ±1.8% | 0.98 ±0.8% | 1.00 ±0.9% | 0.54 ±0.6% | 0.98 ±1.8% | 0.37 ±3.0% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1368.9 ±0.7% | 0.95 ±0.3% | 1.00 ±0.4% | 0.53 ±0.9% | 0.98 ±0.2% | 0.38 ±1.2% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1519.1 ±0.6% | 0.86 ±1.1% | 1.00 ±0.4% | 0.51 ±0.3% | 0.98 ±1.0% | 0.41 ±1.5% |
| http/html-1kx1024 | 1048576 | 39.3 | 479.1 ±0.3% | 0.84 ±0.3% | 1.00 ±0.2% | 0.76 ±0.2% | 0.98 ±0.2% | 0.66 ±0.4% |
| http/html-16kx64 | 1048576 | 21.9 | 1318.9 ±0.2% | 0.81 ±0.1% | 1.01 ±0.2% | 0.58 ±0.3% | 0.99 ±0.4% | 0.48 ±0.3% |
| http/html-1m | 1048576 | 17.7 | 1783.9 ±0.9% | 0.93 ±0.6% | 1.00 ±0.8% | 0.55 ±0.6% | 0.99 ±0.7% | 0.39 ±1.4% |
| http/json-1kx1024 | 1048576 | 21.9 | 575.6 ±0.2% | 0.97 ±0.0% | 1.00 ±0.4% | 0.80 ±0.6% | 0.98 ±0.2% | 0.68 ±0.1% |
| http/json-16kx64 | 1048576 | 12.6 | 1768.3 ±0.8% | 0.82 ±7.0% | 1.00 ±1.2% | 0.60 ±19.4% | 0.99 ±17.5% | 0.47 ±16.8% |
| http/json-1m | 1048576 | 12.2 | 1904.7 ±9.8% | 0.85 ±2.8% | 1.00 ±0.6% | 0.54 ±1.9% | 1.00 ±5.0% | 0.37 ±7.8% |
| http/js-1kx1024 | 1048576 | 44.5 | 394.0 ±16.5% | 0.83 ±8.8% | 1.00 ±0.1% | 0.75 ±0.3% | 0.98 ±2.8% | 0.63 ±3.6% |
| http/js-16kx64 | 1048576 | 26.0 | 1220.6 ±0.1% | 0.79 ±0.5% | 1.00 ±1.2% | 0.55 ±0.2% | 0.99 ±0.1% | 0.47 ±0.5% |
| http/js-1m | 1048576 | 19.0 | 1749.8 ±0.8% | 0.91 ±1.3% | 1.01 ±0.7% | 0.56 ±0.4% | 0.99 ±1.7% | 0.38 ±0.8% |
| http/css-1kx1024 | 1048576 | 29.5 | 521.9 ±0.3% | 0.94 ±0.4% | 1.00 ±0.3% | 0.77 ±0.2% | 0.98 ±0.3% | 0.66 ±0.4% |
| http/css-16kx64 | 1048576 | 15.9 | 1551.7 ±17.6% | 0.82 ±15.8% | 0.88 ±14.5% | 0.53 ±15.9% | 0.86 ±14.3% | 0.40 ±14.6% |
| http/css-1m | 1048576 | 3.6 | 4283.9 ±0.7% | 0.95 ±0.9% | 1.01 ±0.6% | 0.69 ±7.7% | 1.00 ±14.5% | 0.32 ±13.8% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1508.7 ±0.6% | 0.43 ±0.2% | 0.83 ±0.8% | 0.68 ±1.2% | 0.98 ±0.3% | 0.45 ±1.2% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 379.8 ± 0.2% | 130.0 ± 1.6% | 0.34 |
| silesia/dickens | 10192446 | 3 | 206.9 ± 17.0% | 98.3 ± 17.9% | 0.47 |
| silesia/mozilla | 51220480 | 1 | 570.7 ± 15.1% | 176.6 ± 3.4% | 0.31 |
| silesia/mozilla | 51220480 | 3 | 315.8 ± 1.1% | 150.3 ± 0.6% | 0.48 |
| silesia/mr | 9970564 | 1 | 515.3 ± 0.4% | 162.2 ± 0.1% | 0.31 |
| silesia/mr | 9970564 | 3 | 287.3 ± 0.8% | 131.6 ± 1.0% | 0.46 |
| silesia/nci | 33553445 | 1 | 1075.1 ± 1.7% | 406.5 ± 0.8% | 0.38 |
| silesia/nci | 33553445 | 3 | 782.1 ± 8.4% | 281.6 ± 4.6% | 0.36 |
| silesia/ooffice | 6152192 | 1 | 418.5 ± 1.4% | 118.3 ± 0.7% | 0.28 |
| silesia/ooffice | 6152192 | 3 | 220.9 ± 0.7% | 103.9 ± 1.2% | 0.47 |
| silesia/osdb | 10085684 | 1 | 563.9 ± 10.6% | 197.9 ± 0.6% | 0.35 |
| silesia/osdb | 10085684 | 3 | 336.4 ± 0.6% | 163.0 ± 1.9% | 0.48 |
| silesia/reymont | 6627202 | 1 | 371.5 ± 2.3% | 157.6 ± 9.3% | 0.42 |
| silesia/reymont | 6627202 | 3 | 258.9 ± 3.0% | 121.5 ± 4.4% | 0.47 |
| silesia/samba | 21606400 | 1 | 644.4 ± 0.7% | 230.2 ± 0.4% | 0.36 |
| silesia/samba | 21606400 | 3 | 423.7 ± 6.5% | 190.5 ± 1.5% | 0.45 |
| silesia/sao | 7251944 | 1 | 466.1 ± 0.2% | 131.2 ± 1.1% | 0.28 |
| silesia/sao | 7251944 | 3 | 207.5 ± 1.0% | 110.1 ± 2.3% | 0.53 |
| silesia/webster | 41458703 | 1 | 431.4 ± 1.2% | 155.8 ± 0.2% | 0.36 |
| silesia/webster | 41458703 | 3 | 264.3 ± 1.2% | 130.4 ± 0.5% | 0.49 |
| silesia/x-ray | 8474240 | 1 | 946.8 ± 2.7% | 138.7 ± 0.3% | 0.15 |
| silesia/x-ray | 8474240 | 3 | 197.4 ± 1.2% | 112.4 ± 1.8% | 0.57 |
| silesia/xml | 5345280 | 1 | 880.7 ± 0.2% | 302.7 ± 0.2% | 0.34 |
| silesia/xml | 5345280 | 3 | 711.5 ± 1.0% | 281.5 ± 0.6% | 0.40 |
| canterbury/alice29.txt | 152089 | 1 | 341.6 ± 0.3% | 134.8 ± 0.1% | 0.39 |
| canterbury/alice29.txt | 152089 | 3 | 259.4 ± 0.9% | 119.9 ± 0.3% | 0.46 |
| canterbury/asyoulik.txt | 125179 | 1 | 394.5 ± 0.4% | 125.1 ± 0.1% | 0.32 |
| canterbury/asyoulik.txt | 125179 | 3 | 252.0 ± 0.8% | 115.5 ± 0.2% | 0.46 |
| canterbury/cp.html | 24603 | 1 | 652.6 ± 0.4% | 203.1 ± 0.2% | 0.31 |
| canterbury/cp.html | 24603 | 3 | 458.6 ± 0.8% | 200.6 ± 0.5% | 0.44 |
| canterbury/fields.c | 11150 | 1 | 505.8 ± 13.8% | 230.8 ± 21.4% | 0.46 |
| canterbury/fields.c | 11150 | 3 | 392.6 ± 0.4% | 186.2 ± 1.0% | 0.47 |
| canterbury/grammar.lsp | 3721 | 1 | 366.6 ± 13.2% | 153.1 ± 10.5% | 0.42 |
| canterbury/grammar.lsp | 3721 | 3 | 303.4 ± 2.6% | 145.3 ± 2.3% | 0.48 |
| canterbury/kennedy.xls | 1029744 | 1 | 615.0 ± 8.4% | 199.8 ± 12.3% | 0.32 |
| canterbury/kennedy.xls | 1029744 | 3 | 551.9 ± 0.3% | 175.6 ± 0.5% | 0.32 |
| canterbury/lcet10.txt | 426754 | 1 | 371.2 ± 12.0% | 143.1 ± 2.8% | 0.39 |
| canterbury/lcet10.txt | 426754 | 3 | 278.8 ± 0.4% | 132.5 ± 0.5% | 0.48 |
| canterbury/plrabn12.txt | 481861 | 1 | 366.4 ± 5.3% | 120.5 ± 0.5% | 0.33 |
| canterbury/plrabn12.txt | 481861 | 3 | 232.2 ± 0.9% | 113.6 ± 0.4% | 0.49 |
| canterbury/ptt5 | 513216 | 1 | 1169.4 ± 0.6% | 386.5 ± 0.2% | 0.33 |
| canterbury/ptt5 | 513216 | 3 | 962.4 ± 1.2% | 365.2 ± 0.7% | 0.38 |
| canterbury/sum | 38240 | 1 | 697.8 ± 1.5% | 186.9 ± 0.4% | 0.27 |
| canterbury/sum | 38240 | 3 | 504.2 ± 0.8% | 172.9 ± 1.0% | 0.34 |
| canterbury/xargs.1 | 4227 | 1 | 349.1 ± 17.2% | 154.1 ± 22.1% | 0.44 |
| canterbury/xargs.1 | 4227 | 3 | 328.4 ± 0.8% | 159.6 ± 0.8% | 0.49 |
| canterbury-large/E.coli | 4638690 | 1 | 356.3 ± 0.3% | 155.8 ± 0.4% | 0.44 |
| canterbury-large/E.coli | 4638690 | 3 | 354.9 ± 0.2% | 150.4 ± 0.4% | 0.42 |
| canterbury-large/bible.txt | 4047392 | 1 | 375.2 ± 0.1% | 157.4 ± 0.2% | 0.42 |
| canterbury-large/bible.txt | 4047392 | 3 | 297.9 ± 0.3% | 139.4 ± 0.9% | 0.47 |
| canterbury-large/world192.txt | 2473400 | 1 | 455.2 ± 20.6% | 162.9 ± 16.1% | 0.36 |
| canterbury-large/world192.txt | 2473400 | 3 | 287.0 ± 0.0% | 137.6 ± 0.2% | 0.48 |
| http/html-1kx1024 | 1048576 | 1 | 205.9 ± 16.7% | 73.6 ± 12.5% | 0.36 |
| http/html-1kx1024 | 1048576 | 3 | 177.5 ± 0.3% | 73.3 ± 0.3% | 0.41 |
| http/html-16kx64 | 1048576 | 1 | 462.7 ± 17.0% | 200.4 ± 12.4% | 0.43 |
| http/html-16kx64 | 1048576 | 3 | 403.2 ± 0.9% | 199.3 ± 0.3% | 0.49 |
| http/html-1m | 1048576 | 1 | 575.3 ± 17.8% | 228.9 ± 18.8% | 0.40 |
| http/html-1m | 1048576 | 3 | 431.0 ± 14.1% | 199.4 ± 14.4% | 0.46 |
| http/json-1kx1024 | 1048576 | 1 | 254.6 ± 0.3% | 90.6 ± 0.2% | 0.36 |
| http/json-1kx1024 | 1048576 | 3 | 240.4 ± 0.4% | 89.5 ± 0.3% | 0.37 |
| http/json-16kx64 | 1048576 | 1 | 767.8 ± 17.3% | 291.1 ± 20.5% | 0.38 |
| http/json-16kx64 | 1048576 | 3 | 686.8 ± 1.0% | 285.1 ± 0.4% | 0.42 |
| http/json-1m | 1048576 | 1 | 922.8 ± 17.5% | 303.2 ± 14.9% | 0.33 |
| http/json-1m | 1048576 | 3 | 759.2 ± 3.2% | 308.4 ± 1.2% | 0.41 |
| http/js-1kx1024 | 1048576 | 1 | 187.8 ± 5.2% | 66.4 ± 0.5% | 0.35 |
| http/js-1kx1024 | 1048576 | 3 | 154.2 ± 4.5% | 66.2 ± 0.3% | 0.43 |
| http/js-16kx64 | 1048576 | 1 | 409.7 ± 0.2% | 169.8 ± 0.5% | 0.41 |
| http/js-16kx64 | 1048576 | 3 | 355.9 ± 0.7% | 173.8 ± 0.2% | 0.49 |
| http/js-1m | 1048576 | 1 | 554.3 ± 0.7% | 215.2 ± 0.8% | 0.39 |
| http/js-1m | 1048576 | 3 | 468.2 ± 0.6% | 213.3 ± 0.8% | 0.46 |
| http/css-1kx1024 | 1048576 | 1 | 229.0 ± 0.6% | 81.8 ± 0.3% | 0.36 |
| http/css-1kx1024 | 1048576 | 3 | 207.2 ± 0.5% | 81.6 ± 0.4% | 0.39 |
| http/css-16kx64 | 1048576 | 1 | 598.8 ± 1.2% | 228.1 ± 0.3% | 0.38 |
| http/css-16kx64 | 1048576 | 3 | 554.0 ± 0.2% | 232.3 ± 0.8% | 0.42 |
| http/css-1m | 1048576 | 1 | 2619.7 ± 0.3% | 817.5 ± 0.1% | 0.31 |
| http/css-1m | 1048576 | 3 | 2221.9 ± 0.6% | 841.3 ± 0.4% | 0.38 |
| shuffled/dickens-1m | 1048576 | 1 | 1458.1 ± 0.3% | 275.8 ± 0.2% | 0.19 |
| shuffled/dickens-1m | 1048576 | 3 | 229.8 ± 0.4% | 178.5 ± 4.6% | 0.78 |

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
| silesia/dickens | 10192446 | 35.9 | 868.1 ±2.3% | 1066.7 ±1.7% | 1.23 |
| silesia/mozilla | 51220480 | 35.6 | 954.5 ±3.9% | 1121.4 ±2.5% | 1.17 |
| silesia/mr | 9970564 | 35.6 | 1117.6 ±15.6% | 1375.3 ±7.7% | 1.23 |
| silesia/nci | 33553445 | 8.4 | 2212.2 ±1.7% | 2463.4 ±9.2% | 1.11 |
| silesia/ooffice | 6152192 | 50.8 | 971.6 ±0.3% | 1125.1 ±1.6% | 1.16 |
| silesia/osdb | 10085684 | 34.7 | 1512.1 ±0.2% | 1692.1 ±0.3% | 1.12 |
| silesia/reymont | 6627202 | 29.2 | 1195.3 ±0.8% | 1362.5 ±0.4% | 1.14 |
| silesia/samba | 21606400 | 22.9 | 1690.8 ±1.4% | 1842.0 ±2.4% | 1.09 |
| silesia/sao | 7251944 | 76.2 | 892.3 ±0.4% | 1141.7 ±1.0% | 1.28 |
| silesia/webster | 41458703 | 29.2 | 1224.3 ±1.5% | 1278.2 ±4.2% | 1.04 |
| silesia/x-ray | 8474240 | 71.8 | 893.8 ±0.6% | 1092.4 ±2.2% | 1.22 |
| silesia/xml | 5345280 | 11.9 | 1976.0 ±1.0% | 2332.4 ±0.2% | 1.18 |
| canterbury/alice29.txt | 152089 | 37.5 | 941.3 ±0.1% | 1143.8 ±0.2% | 1.22 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1063.1 ±0.3% | 1282.7 ±0.7% | 1.21 |
| canterbury/cp.html | 24603 | 34.4 | 1271.5 ±7.0% | 1513.7 ±7.5% | 1.19 |
| canterbury/fields.c | 11150 | 30.3 | 954.8 ±5.2% | 1091.0 ±3.2% | 1.14 |
| canterbury/grammar.lsp | 3721 | 34.8 | 740.4 ±2.2% | 815.9 ±1.7% | 1.10 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1165.3 ±12.1% | 1186.4 ±14.0% | 1.02 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1168.4 ±0.5% | 1406.6 ±1.0% | 1.20 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 997.5 ±0.6% | 1219.0 ±0.6% | 1.22 |
| canterbury/ptt5 | 513216 | 10.6 | 2432.1 ±1.1% | 2707.7 ±2.7% | 1.11 |
| canterbury/sum | 38240 | 35.0 | 1263.9 ±16.6% | 1442.8 ±16.8% | 1.14 |
| canterbury/xargs.1 | 4227 | 42.7 | 802.4 ±0.1% | 914.0 ±0.5% | 1.14 |
| canterbury-large/E.coli | 4638690 | 30.0 | 960.6 ±1.0% | 1302.7 ±0.4% | 1.36 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1127.0 ±1.3% | 1382.3 ±0.6% | 1.23 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1415.4 ±0.2% | 1538.4 ±0.3% | 1.09 |
| http/html-1kx1024 | 1048576 | 39.3 | 481.3 ±0.4% | 506.0 ±0.3% | 1.05 |
| http/html-16kx64 | 1048576 | 21.9 | 1254.9 ±1.1% | 1325.6 ±0.6% | 1.06 |
| http/html-1m | 1048576 | 17.7 | 1678.6 ±0.4% | 1791.6 ±0.3% | 1.07 |
| http/json-1kx1024 | 1048576 | 21.9 | 564.9 ±0.3% | 609.0 ±1.1% | 1.08 |
| http/json-16kx64 | 1048576 | 12.6 | 1532.1 ±15.5% | 1708.1 ±18.2% | 1.11 |
| http/json-1m | 1048576 | 12.2 | 1628.9 ±2.2% | 1948.7 ±2.2% | 1.20 |
| http/js-1kx1024 | 1048576 | 44.5 | 367.1 ±1.7% | 353.8 ±1.8% | 0.96 |
| http/js-16kx64 | 1048576 | 26.0 | 995.5 ±2.6% | 1057.5 ±2.1% | 1.06 |
| http/js-1m | 1048576 | 19.0 | 1418.4 ±4.7% | 1541.0 ±7.7% | 1.09 |
| http/css-1kx1024 | 1048576 | 29.5 | 516.5 ±0.9% | 552.7 ±0.8% | 1.07 |
| http/css-16kx64 | 1048576 | 15.9 | 1521.3 ±0.1% | 1576.7 ±0.1% | 1.04 |
| http/css-1m | 1048576 | 3.6 | 5101.2 ±0.8% | 5111.4 ±0.7% | 1.00 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1301.9 ±0.5% | 1540.1 ±0.3% | 1.18 |
