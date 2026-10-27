# bench-zstd

| Field | Value |
|---|---|
| Commit | 00ebfdb |
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
| silesia/dickens | 10192446 | 35.9 | 1002.7 ±1.4% | 1226.9 ±5.2% | 1.22 |
| silesia/mozilla | 51220480 | 35.6 | 1067.0 ±4.4% | 1209.9 ±1.6% | 1.13 |
| silesia/mr | 9970564 | 35.6 | 1035.2 ±16.3% | 1185.7 ±14.7% | 1.15 |
| silesia/nci | 33553445 | 8.4 | 1946.5 ±9.5% | 2239.7 ±5.2% | 1.15 |
| silesia/ooffice | 6152192 | 50.8 | 832.4 ±15.7% | 957.1 ±15.7% | 1.15 |
| silesia/osdb | 10085684 | 34.7 | 1385.1 ±20.9% | 1594.2 ±15.6% | 1.15 |
| silesia/reymont | 6627202 | 29.2 | 1023.3 ±15.2% | 1238.3 ±14.3% | 1.21 |
| silesia/samba | 21606400 | 22.9 | 1681.6 ±1.7% | 1837.0 ±2.3% | 1.09 |
| silesia/sao | 7251944 | 76.2 | 894.0 ±5.7% | 1124.8 ±2.3% | 1.26 |
| silesia/webster | 41458703 | 29.2 | 1222.3 ±4.0% | 1339.0 ±1.8% | 1.10 |
| silesia/x-ray | 8474240 | 71.8 | 891.6 ±1.5% | 1098.9 ±2.3% | 1.23 |
| silesia/xml | 5345280 | 11.9 | 1975.8 ±1.9% | 2324.3 ±0.3% | 1.18 |
| canterbury/alice29.txt | 152089 | 37.5 | 941.6 ±0.4% | 1137.7 ±0.1% | 1.21 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1062.9 ±0.3% | 1274.2 ±0.3% | 1.20 |
| canterbury/cp.html | 24603 | 34.4 | 1266.7 ±0.6% | 1524.9 ±0.9% | 1.20 |
| canterbury/fields.c | 11150 | 30.3 | 1085.5 ±0.2% | 1269.1 ±0.8% | 1.17 |
| canterbury/grammar.lsp | 3721 | 34.8 | 848.4 ±0.4% | 954.6 ±0.2% | 1.13 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1342.4 ±0.4% | 1382.4 ±0.1% | 1.03 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1168.8 ±0.2% | 1396.9 ±0.9% | 1.20 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 997.1 ±0.1% | 1208.3 ±0.3% | 1.21 |
| canterbury/ptt5 | 513216 | 10.6 | 2433.8 ±1.1% | 2706.2 ±0.9% | 1.11 |
| canterbury/sum | 38240 | 35.0 | 1271.7 ±0.3% | 1447.9 ±0.1% | 1.14 |
| canterbury/xargs.1 | 4227 | 42.7 | 816.1 ±18.6% | 921.9 ±17.4% | 1.13 |
| canterbury-large/E.coli | 4638690 | 30.0 | 855.4 ±2.7% | 1116.8 ±2.5% | 1.31 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 973.3 ±2.8% | 1208.6 ±2.6% | 1.24 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1278.3 ±0.4% | 1381.9 ±0.5% | 1.08 |
| http/html-1kx1024 | 1048576 | 39.3 | 428.0 ±2.6% | 430.0 ±4.4% | 1.00 |
| http/html-16kx64 | 1048576 | 21.9 | 1136.4 ±12.4% | 1203.8 ±12.2% | 1.06 |
| http/html-1m | 1048576 | 17.7 | 1678.6 ±0.8% | 1781.3 ±0.3% | 1.06 |
| http/json-1kx1024 | 1048576 | 21.9 | 566.4 ±11.4% | 576.1 ±20.8% | 1.02 |
| http/json-16kx64 | 1048576 | 12.6 | 1391.9 ±15.0% | 1757.6 ±16.8% | 1.26 |
| http/json-1m | 1048576 | 12.2 | 1874.7 ±0.2% | 2245.7 ±0.5% | 1.20 |
| http/js-1kx1024 | 1048576 | 44.5 | 427.8 ±0.6% | 389.8 ±0.2% | 0.91 |
| http/js-16kx64 | 1048576 | 26.0 | 1156.4 ±0.2% | 1219.1 ±5.7% | 1.05 |
| http/js-1m | 1048576 | 19.0 | 1651.1 ±1.7% | 1754.9 ±0.5% | 1.06 |
| http/css-1kx1024 | 1048576 | 29.5 | 517.9 ±0.2% | 522.6 ±1.5% | 1.01 |
| http/css-16kx64 | 1048576 | 15.9 | 1526.5 ±0.8% | 1559.3 ±0.7% | 1.02 |
| http/css-1m | 1048576 | 3.6 | 5092.6 ±0.9% | 5068.9 ±0.6% | 1.00 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1302.6 ±0.1% | 1531.8 ±0.6% | 1.18 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 291.5 ±1.3% | 1222.6 ±0.7% | 4.19 |
| silesia/mozilla | 51220480 | 35.6 | 281.3 ±11.9% | 1186.5 ±9.1% | 4.22 |
| silesia/mr | 9970564 | 35.6 | 298.2 ±1.0% | 1381.3 ±1.0% | 4.63 |
| silesia/nci | 33553445 | 8.4 | 714.0 ±18.8% | 2431.2 ±14.2% | 3.41 |
| silesia/ooffice | 6152192 | 50.8 | 234.0 ±0.5% | 1128.7 ±1.1% | 4.82 |
| silesia/osdb | 10085684 | 34.7 | 387.2 ±0.8% | 1683.0 ±0.4% | 4.35 |
| silesia/reymont | 6627202 | 29.2 | 348.4 ±4.2% | 1353.6 ±2.9% | 3.88 |
| silesia/samba | 21606400 | 22.9 | 520.8 ±0.5% | 1833.1 ±0.6% | 3.52 |
| silesia/sao | 7251944 | 76.2 | 210.2 ±1.2% | 1130.5 ±0.8% | 5.38 |
| silesia/webster | 41458703 | 29.2 | 330.3 ±1.8% | 1246.7 ±9.0% | 3.77 |
| silesia/x-ray | 8474240 | 71.8 | 195.4 ±0.4% | 1094.6 ±1.7% | 5.60 |
| silesia/xml | 5345280 | 11.9 | 687.3 ±0.4% | 2323.2 ±0.3% | 3.38 |
| canterbury/alice29.txt | 152089 | 37.5 | 253.2 ±0.9% | 1137.2 ±0.3% | 4.49 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 235.0 ±1.7% | 1273.1 ±0.2% | 5.42 |
| canterbury/cp.html | 24603 | 34.4 | 321.3 ±0.4% | 1527.5 ±0.2% | 4.75 |
| canterbury/fields.c | 11150 | 30.3 | 313.2 ±0.6% | 1268.1 ±1.4% | 4.05 |
| canterbury/grammar.lsp | 3721 | 34.8 | 273.2 ±0.3% | 955.5 ±0.4% | 3.50 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 357.1 ±0.2% | 1384.7 ±0.1% | 3.88 |
| canterbury/lcet10.txt | 426754 | 33.0 | 301.5 ±0.2% | 1399.6 ±0.1% | 4.64 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 249.1 ±0.5% | 1206.8 ±0.1% | 4.84 |
| canterbury/ptt5 | 513216 | 10.6 | 557.9 ±0.2% | 2761.5 ±2.2% | 4.95 |
| canterbury/sum | 38240 | 35.0 | 314.3 ±0.7% | 1447.0 ±0.1% | 4.60 |
| canterbury/xargs.1 | 4227 | 42.7 | 229.8 ±0.2% | 920.4 ±0.3% | 4.00 |
| canterbury-large/E.coli | 4638690 | 30.0 | 312.2 ±0.2% | 1288.0 ±1.8% | 4.12 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 365.2 ±0.3% | 1374.7 ±0.1% | 3.76 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 380.2 ±19.7% | 1427.1 ±17.1% | 3.75 |
| http/html-1kx1024 | 1048576 | 39.3 | 188.0 ±1.2% | 412.8 ±0.2% | 2.20 |
| http/html-16kx64 | 1048576 | 21.9 | 322.6 ±0.3% | 1157.2 ±0.1% | 3.59 |
| http/html-1m | 1048576 | 17.7 | 429.7 ±1.1% | 1570.4 ±9.4% | 3.65 |
| http/json-1kx1024 | 1048576 | 21.9 | 314.0 ±1.1% | 573.2 ±0.8% | 1.83 |
| http/json-16kx64 | 1048576 | 12.6 | 521.5 ±0.2% | 1755.3 ±0.4% | 3.37 |
| http/json-1m | 1048576 | 12.2 | 521.4 ±14.8% | 2024.0 ±18.6% | 3.88 |
| http/js-1kx1024 | 1048576 | 44.5 | 177.4 ±1.5% | 389.1 ±5.3% | 2.19 |
| http/js-16kx64 | 1048576 | 26.0 | 318.4 ±17.9% | 1214.9 ±18.3% | 3.82 |
| http/js-1m | 1048576 | 19.0 | 431.6 ±14.8% | 1672.8 ±15.1% | 3.88 |
| http/css-1kx1024 | 1048576 | 29.5 | 267.2 ±0.4% | 522.7 ±0.5% | 1.96 |
| http/css-16kx64 | 1048576 | 15.9 | 458.9 ±0.1% | 1566.1 ±0.2% | 3.41 |
| http/css-1m | 1048576 | 3.6 | 1901.4 ±0.3% | 5079.2 ±1.2% | 2.67 |
| shuffled/dickens-1m | 1048576 | 58.8 | 195.4 ±18.1% | 1488.2 ±16.3% | 7.62 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 1205.7 ±1.1% | 0.91 ±2.4% | 1.00 ±1.3% | 0.49 ±9.0% | 0.97 ±1.9% | 0.37 ±1.5% |
| silesia/mozilla | 51220480 | 35.6 | 1210.3 ±12.6% | 0.72 ±12.6% | 1.01 ±4.9% | 0.57 ±4.0% | 1.00 ±10.4% | 0.46 ±15.7% |
| silesia/mr | 9970564 | 35.6 | 1329.6 ±2.1% | 0.77 ±2.3% | 1.01 ±2.1% | 0.49 ±1.5% | 1.00 ±1.6% | 0.40 ±0.9% |
| silesia/nci | 33553445 | 8.4 | 2347.7 ±0.9% | 0.81 ±6.1% | 0.98 ±4.2% | 0.55 ±4.4% | 0.99 ±18.5% | 0.42 ±3.2% |
| silesia/ooffice | 6152192 | 50.8 | 1108.0 ±1.4% | 0.58 ±1.0% | 1.00 ±1.0% | 0.51 ±2.1% | 1.00 ±1.2% | 0.45 ±3.0% |
| silesia/osdb | 10085684 | 34.7 | 1471.1 ±17.2% | 0.60 ±16.2% | 0.96 ±14.5% | 0.58 ±11.9% | 0.95 ±15.9% | 0.45 ±10.7% |
| silesia/reymont | 6627202 | 29.2 | 1309.5 ±15.3% | 0.94 ±17.0% | 1.01 ±15.5% | 0.54 ±16.4% | 1.00 ±15.3% | 0.39 ±16.9% |
| silesia/samba | 21606400 | 22.9 | 1704.5 ±4.5% | 0.88 ±4.5% | 0.98 ±7.3% | 0.54 ±3.5% | 1.01 ±9.4% | 0.44 ±0.6% |
| silesia/sao | 7251944 | 76.2 | 1112.9 ±18.3% | 0.46 ±13.5% | 1.00 ±18.4% | 0.60 ±14.1% | 0.99 ±15.5% | 0.48 ±15.5% |
| silesia/webster | 41458703 | 29.2 | 1160.7 ±11.0% | 0.90 ±13.3% | 0.99 ±13.4% | 0.57 ±5.1% | 0.96 ±3.6% | 0.45 ±1.3% |
| silesia/x-ray | 8474240 | 71.8 | 1059.6 ±4.2% | 0.46 ±2.4% | 1.00 ±3.9% | 0.59 ±3.3% | 1.00 ±2.4% | 0.46 ±4.0% |
| silesia/xml | 5345280 | 11.9 | 2298.7 ±17.2% | 0.91 ±17.0% | 1.00 ±16.3% | 0.55 ±13.5% | 0.99 ±14.6% | 0.42 ±15.3% |
| canterbury/alice29.txt | 152089 | 37.5 | 998.6 ±17.6% | 0.92 ±15.7% | 1.00 ±16.5% | 0.49 ±13.5% | 0.99 ±11.8% | 0.37 ±18.0% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1271.5 ±1.2% | 0.81 ±0.3% | 0.97 ±3.3% | 0.45 ±10.6% | 0.99 ±17.8% | 0.36 ±16.2% |
| canterbury/cp.html | 24603 | 34.4 | 1527.3 ±11.1% | 0.57 ±0.4% | 0.99 ±1.1% | 0.67 ±2.0% | 0.99 ±0.5% | 0.48 ±0.6% |
| canterbury/fields.c | 11150 | 30.3 | 1262.8 ±0.3% | 0.78 ±0.5% | 1.00 ±0.9% | 0.62 ±2.5% | 1.00 ±0.5% | 0.43 ±0.8% |
| canterbury/grammar.lsp | 3721 | 34.8 | 930.6 ±0.7% | 0.76 ±0.2% | 1.02 ±0.7% | 0.70 ±0.4% | 1.02 ±1.0% | 0.51 ±1.2% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1383.7 ±0.2% | 0.84 ±0.4% | 1.00 ±0.2% | 0.57 ±0.1% | 0.99 ±0.2% | 0.39 ±0.5% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1397.9 ±0.1% | 0.87 ±0.2% | 1.00 ±0.1% | 0.49 ±0.4% | 0.99 ±0.8% | 0.37 ±0.2% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1206.5 ±0.2% | 0.88 ±0.3% | 0.99 ±0.2% | 0.47 ±0.4% | 0.99 ±0.2% | 0.37 ±1.0% |
| canterbury/ptt5 | 513216 | 10.6 | 2389.1 ±16.9% | 0.78 ±15.6% | 1.00 ±17.3% | 0.51 ±14.8% | 0.97 ±15.2% | 0.43 ±14.0% |
| canterbury/sum | 38240 | 35.0 | 1263.5 ±14.5% | 0.58 ±8.4% | 0.99 ±14.4% | 0.68 ±5.5% | 0.97 ±5.7% | 0.49 ±9.8% |
| canterbury/xargs.1 | 4227 | 42.7 | 918.9 ±2.8% | 0.68 ±0.6% | 1.00 ±0.5% | 0.66 ±1.0% | 0.99 ±0.7% | 0.47 ±3.1% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1288.6 ±1.3% | 0.97 ±0.5% | 1.00 ±0.5% | 0.53 ±2.6% | 0.99 ±0.7% | 0.37 ±0.7% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1371.5 ±16.4% | 0.91 ±15.6% | 0.88 ±14.3% | 0.46 ±16.2% | 0.98 ±16.1% | 0.38 ±16.5% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1527.3 ±0.9% | 0.85 ±1.3% | 1.00 ±0.7% | 0.51 ±0.6% | 0.99 ±0.6% | 0.41 ±6.9% |
| http/html-1kx1024 | 1048576 | 39.3 | 478.0 ±0.1% | 0.84 ±0.5% | 1.00 ±0.1% | 0.76 ±0.0% | 0.98 ±0.4% | 0.66 ±0.7% |
| http/html-16kx64 | 1048576 | 21.9 | 1315.6 ±16.6% | 0.82 ±15.8% | 1.00 ±16.8% | 0.58 ±13.5% | 0.99 ±15.3% | 0.47 ±20.1% |
| http/html-1m | 1048576 | 17.7 | 1785.5 ±5.7% | 0.93 ±0.2% | 1.00 ±0.4% | 0.55 ±1.8% | 0.99 ±0.3% | 0.39 ±1.2% |
| http/json-1kx1024 | 1048576 | 21.9 | 574.8 ±3.3% | 0.97 ±10.4% | 1.00 ±16.7% | 0.80 ±15.2% | 0.98 ±18.2% | 0.68 ±15.4% |
| http/json-16kx64 | 1048576 | 12.6 | 1760.0 ±16.7% | 0.83 ±12.0% | 1.00 ±1.1% | 0.60 ±3.3% | 0.99 ±12.6% | 0.47 ±17.2% |
| http/json-1m | 1048576 | 12.2 | 2243.2 ±0.3% | 0.86 ±0.6% | 1.00 ±0.9% | 0.54 ±0.6% | 1.00 ±0.3% | 0.36 ±0.9% |
| http/js-1kx1024 | 1048576 | 44.5 | 389.6 ±0.2% | 0.84 ±0.2% | 1.00 ±0.3% | 0.76 ±0.3% | 0.98 ±0.5% | 0.67 ±0.3% |
| http/js-16kx64 | 1048576 | 26.0 | 1221.4 ±0.3% | 0.80 ±1.0% | 1.00 ±0.2% | 0.56 ±0.5% | 0.99 ±0.2% | 0.46 ±0.3% |
| http/js-1m | 1048576 | 19.0 | 1748.8 ±16.0% | 0.91 ±17.9% | 1.02 ±9.4% | 0.56 ±12.0% | 1.00 ±18.1% | 0.40 ±16.5% |
| http/css-1kx1024 | 1048576 | 29.5 | 522.5 ±0.4% | 0.94 ±0.8% | 1.00 ±0.8% | 0.77 ±0.2% | 0.98 ±0.5% | 0.66 ±1.5% |
| http/css-16kx64 | 1048576 | 15.9 | 1565.6 ±0.3% | 0.87 ±0.3% | 1.01 ±0.2% | 0.61 ±0.3% | 0.99 ±0.6% | 0.46 ±0.3% |
| http/css-1m | 1048576 | 3.6 | 5086.7 ±1.1% | 0.95 ±1.4% | 1.01 ±0.8% | 0.69 ±0.1% | 0.99 ±0.5% | 0.32 ±0.4% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1527.8 ±16.1% | 0.42 ±16.8% | 0.82 ±18.9% | 0.67 ±18.4% | 0.98 ±16.5% | 0.44 ±14.0% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 335.2 ± 3.0% | 91.7 ± 2.5% | 0.27 |
| silesia/dickens | 10192446 | 3 | 241.9 ± 12.4% | 83.6 ± 2.6% | 0.35 |
| silesia/mozilla | 51220480 | 1 | 569.1 ± 1.2% | 143.8 ± 6.9% | 0.25 |
| silesia/mozilla | 51220480 | 3 | 326.1 ± 12.6% | 105.3 ± 1.5% | 0.32 |
| silesia/mr | 9970564 | 1 | 517.1 ± 8.1% | 127.4 ± 0.9% | 0.25 |
| silesia/mr | 9970564 | 3 | 291.6 ± 0.4% | 97.0 ± 0.6% | 0.33 |
| silesia/nci | 33553445 | 1 | 1087.7 ± 1.6% | 290.9 ± 0.9% | 0.27 |
| silesia/nci | 33553445 | 3 | 913.5 ± 2.5% | 181.6 ± 0.5% | 0.20 |
| silesia/ooffice | 6152192 | 1 | 482.6 ± 0.1% | 115.0 ± 0.6% | 0.24 |
| silesia/ooffice | 6152192 | 3 | 221.3 ± 12.8% | 81.7 ± 11.8% | 0.37 |
| silesia/osdb | 10085684 | 1 | 563.8 ± 15.4% | 158.5 ± 1.8% | 0.28 |
| silesia/osdb | 10085684 | 3 | 341.8 ± 1.0% | 118.2 ± 0.4% | 0.35 |
| silesia/reymont | 6627202 | 1 | 371.4 ± 5.3% | 121.4 ± 2.9% | 0.33 |
| silesia/reymont | 6627202 | 3 | 296.4 ± 0.4% | 102.2 ± 1.6% | 0.34 |
| silesia/samba | 21606400 | 1 | 641.0 ± 1.0% | 176.8 ± 0.5% | 0.28 |
| silesia/samba | 21606400 | 3 | 447.2 ± 1.5% | 127.5 ± 2.9% | 0.29 |
| silesia/sao | 7251944 | 1 | 465.2 ± 0.2% | 112.2 ± 0.5% | 0.24 |
| silesia/sao | 7251944 | 3 | 207.6 ± 0.5% | 88.8 ± 0.5% | 0.43 |
| silesia/webster | 41458703 | 1 | 429.5 ± 16.7% | 120.6 ± 13.9% | 0.28 |
| silesia/webster | 41458703 | 3 | 267.8 ± 11.7% | 91.5 ± 9.6% | 0.34 |
| silesia/x-ray | 8474240 | 1 | 946.5 ± 0.5% | 119.2 ± 5.7% | 0.13 |
| silesia/x-ray | 8474240 | 3 | 197.6 ± 0.5% | 90.1 ± 0.4% | 0.46 |
| silesia/xml | 5345280 | 1 | 869.6 ± 0.5% | 227.7 ± 0.5% | 0.26 |
| silesia/xml | 5345280 | 3 | 710.7 ± 0.4% | 189.9 ± 0.6% | 0.27 |
| canterbury/alice29.txt | 152089 | 1 | 343.0 ± 0.3% | 113.8 ± 5.3% | 0.33 |
| canterbury/alice29.txt | 152089 | 3 | 220.4 ± 17.9% | 92.9 ± 16.1% | 0.42 |
| canterbury/asyoulik.txt | 125179 | 1 | 396.4 ± 1.4% | 106.4 ± 0.6% | 0.27 |
| canterbury/asyoulik.txt | 125179 | 3 | 253.8 ± 0.9% | 100.0 ± 0.3% | 0.39 |
| canterbury/cp.html | 24603 | 1 | 647.9 ± 1.7% | 175.5 ± 9.0% | 0.27 |
| canterbury/cp.html | 24603 | 3 | 467.2 ± 17.2% | 175.1 ± 16.9% | 0.37 |
| canterbury/fields.c | 11150 | 1 | 502.3 ± 5.6% | 194.6 ± 2.3% | 0.39 |
| canterbury/fields.c | 11150 | 3 | 394.3 ± 11.8% | 168.3 ± 3.3% | 0.43 |
| canterbury/grammar.lsp | 3721 | 1 | 425.5 ± 17.1% | 168.2 ± 17.5% | 0.40 |
| canterbury/grammar.lsp | 3721 | 3 | 366.3 ± 0.9% | 160.0 ± 0.3% | 0.44 |
| canterbury/kennedy.xls | 1029744 | 1 | 704.6 ± 0.6% | 192.7 ± 1.1% | 0.27 |
| canterbury/kennedy.xls | 1029744 | 3 | 644.8 ± 3.2% | 184.8 ± 3.3% | 0.29 |
| canterbury/lcet10.txt | 426754 | 1 | 368.1 ± 0.5% | 119.3 ± 0.4% | 0.32 |
| canterbury/lcet10.txt | 426754 | 3 | 279.7 ± 0.7% | 114.4 ± 0.3% | 0.41 |
| canterbury/plrabn12.txt | 481861 | 1 | 364.3 ± 0.3% | 101.2 ± 0.5% | 0.28 |
| canterbury/plrabn12.txt | 481861 | 3 | 231.3 ± 0.7% | 98.1 ± 0.5% | 0.42 |
| canterbury/ptt5 | 513216 | 1 | 1126.5 ± 0.3% | 348.6 ± 0.4% | 0.31 |
| canterbury/ptt5 | 513216 | 3 | 949.0 ± 18.8% | 324.4 ± 16.1% | 0.34 |
| canterbury/sum | 38240 | 1 | 576.1 ± 0.8% | 141.5 ± 0.7% | 0.25 |
| canterbury/sum | 38240 | 3 | 435.8 ± 4.2% | 137.0 ± 14.3% | 0.31 |
| canterbury/xargs.1 | 4227 | 1 | 415.0 ± 0.4% | 162.3 ± 0.4% | 0.39 |
| canterbury/xargs.1 | 4227 | 3 | 327.7 ± 0.2% | 151.6 ± 7.5% | 0.46 |
| canterbury-large/E.coli | 4638690 | 1 | 355.9 ± 0.6% | 119.8 ± 0.6% | 0.34 |
| canterbury-large/E.coli | 4638690 | 3 | 353.1 ± 16.3% | 107.2 ± 17.4% | 0.30 |
| canterbury-large/bible.txt | 4047392 | 1 | 374.2 ± 0.1% | 122.2 ± 0.3% | 0.33 |
| canterbury-large/bible.txt | 4047392 | 3 | 294.9 ± 15.7% | 107.4 ± 11.3% | 0.36 |
| canterbury-large/world192.txt | 2473400 | 1 | 384.1 ± 4.6% | 115.4 ± 2.4% | 0.30 |
| canterbury-large/world192.txt | 2473400 | 3 | 284.6 ± 6.6% | 114.3 ± 4.7% | 0.40 |
| http/html-1kx1024 | 1048576 | 1 | 176.6 ± 15.5% | 61.6 ± 9.5% | 0.35 |
| http/html-1kx1024 | 1048576 | 3 | 150.9 ± 13.5% | 61.2 ± 13.0% | 0.41 |
| http/html-16kx64 | 1048576 | 1 | 462.1 ± 0.8% | 178.8 ± 0.6% | 0.39 |
| http/html-16kx64 | 1048576 | 3 | 396.7 ± 0.2% | 178.9 ± 0.5% | 0.45 |
| http/html-1m | 1048576 | 1 | 568.3 ± 15.7% | 189.3 ± 4.4% | 0.33 |
| http/html-1m | 1048576 | 3 | 493.7 ± 0.7% | 196.4 ± 0.3% | 0.40 |
| http/json-1kx1024 | 1048576 | 1 | 254.7 ± 0.5% | 88.3 ± 0.2% | 0.35 |
| http/json-1kx1024 | 1048576 | 3 | 240.0 ± 0.9% | 87.6 ± 0.6% | 0.36 |
| http/json-16kx64 | 1048576 | 1 | 780.8 ± 0.2% | 261.3 ± 0.4% | 0.33 |
| http/json-16kx64 | 1048576 | 3 | 680.6 ± 0.5% | 256.5 ± 3.5% | 0.38 |
| http/json-1m | 1048576 | 1 | 947.2 ± 1.2% | 270.6 ± 0.6% | 0.29 |
| http/json-1m | 1048576 | 3 | 758.1 ± 0.4% | 268.9 ± 0.3% | 0.35 |
| http/js-1kx1024 | 1048576 | 1 | 188.6 ± 0.1% | 64.6 ± 1.0% | 0.34 |
| http/js-1kx1024 | 1048576 | 3 | 153.6 ± 0.4% | 64.6 ± 0.4% | 0.42 |
| http/js-16kx64 | 1048576 | 1 | 409.2 ± 0.3% | 151.0 ± 0.2% | 0.37 |
| http/js-16kx64 | 1048576 | 3 | 350.0 ± 0.2% | 155.4 ± 0.1% | 0.44 |
| http/js-1m | 1048576 | 1 | 546.9 ± 0.4% | 175.4 ± 0.5% | 0.32 |
| http/js-1m | 1048576 | 3 | 471.3 ± 0.6% | 184.0 ± 0.8% | 0.39 |
| http/css-1kx1024 | 1048576 | 1 | 230.0 ± 0.9% | 79.6 ± 0.4% | 0.35 |
| http/css-1kx1024 | 1048576 | 3 | 206.5 ± 0.3% | 79.2 ± 0.3% | 0.38 |
| http/css-16kx64 | 1048576 | 1 | 605.7 ± 0.3% | 200.6 ± 0.2% | 0.33 |
| http/css-16kx64 | 1048576 | 3 | 545.0 ± 0.1% | 206.2 ± 0.2% | 0.38 |
| http/css-1m | 1048576 | 1 | 2550.8 ± 0.4% | 609.8 ± 0.1% | 0.24 |
| http/css-1m | 1048576 | 3 | 2237.2 ± 0.7% | 739.7 ± 0.2% | 0.33 |
| shuffled/dickens-1m | 1048576 | 1 | 1455.1 ± 12.1% | 255.2 ± 16.9% | 0.18 |
| shuffled/dickens-1m | 1048576 | 3 | 196.4 ± 1.5% | 149.0 ± 0.5% | 0.76 |

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
| silesia/dickens | 10192446 | 35.9 | 888.6 ±2.8% | 1055.8 ±1.3% | 1.19 |
| silesia/mozilla | 51220480 | 35.6 | 982.1 ±4.8% | 1094.3 ±7.7% | 1.11 |
| silesia/mr | 9970564 | 35.6 | 1133.1 ±1.4% | 1365.1 ±1.3% | 1.20 |
| silesia/nci | 33553445 | 8.4 | 2172.8 ±11.0% | 2456.8 ±4.9% | 1.13 |
| silesia/ooffice | 6152192 | 50.8 | 966.4 ±2.5% | 1126.6 ±4.0% | 1.17 |
| silesia/osdb | 10085684 | 34.7 | 1520.5 ±0.2% | 1689.6 ±0.2% | 1.11 |
| silesia/reymont | 6627202 | 29.2 | 1221.8 ±1.1% | 1362.1 ±1.5% | 1.11 |
| silesia/samba | 21606400 | 22.9 | 1696.2 ±2.8% | 1820.3 ±2.9% | 1.07 |
| silesia/sao | 7251944 | 76.2 | 894.4 ±0.9% | 1139.0 ±1.4% | 1.27 |
| silesia/webster | 41458703 | 29.2 | 1243.5 ±3.6% | 1306.6 ±13.4% | 1.05 |
| silesia/x-ray | 8474240 | 71.8 | 902.1 ±1.3% | 1093.7 ±9.5% | 1.21 |
| silesia/xml | 5345280 | 11.9 | 1965.1 ±17.4% | 2205.3 ±15.4% | 1.12 |
| canterbury/alice29.txt | 152089 | 37.5 | 894.0 ±15.5% | 1072.8 ±17.3% | 1.20 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 934.5 ±1.1% | 1096.3 ±1.9% | 1.17 |
| canterbury/cp.html | 24603 | 34.4 | 1108.8 ±1.1% | 1298.2 ±0.2% | 1.17 |
| canterbury/fields.c | 11150 | 30.3 | 1106.8 ±16.8% | 1235.0 ±8.0% | 1.12 |
| canterbury/grammar.lsp | 3721 | 34.8 | 863.2 ±0.7% | 957.9 ±0.6% | 1.11 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1370.4 ±0.6% | 1385.8 ±0.4% | 1.01 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1199.3 ±0.1% | 1404.9 ±1.0% | 1.17 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1023.3 ±0.3% | 1218.8 ±0.3% | 1.19 |
| canterbury/ptt5 | 513216 | 10.6 | 2432.2 ±0.7% | 2713.5 ±1.3% | 1.12 |
| canterbury/sum | 38240 | 35.0 | 1296.2 ±0.9% | 1447.4 ±1.0% | 1.12 |
| canterbury/xargs.1 | 4227 | 42.7 | 832.4 ±0.1% | 916.0 ±0.1% | 1.10 |
| canterbury-large/E.coli | 4638690 | 30.0 | 970.7 ±1.3% | 1303.2 ±0.4% | 1.34 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1182.0 ±2.3% | 1381.5 ±0.9% | 1.17 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1429.6 ±0.3% | 1537.5 ±0.3% | 1.08 |
| http/html-1kx1024 | 1048576 | 39.3 | 481.1 ±0.1% | 502.0 ±0.2% | 1.04 |
| http/html-16kx64 | 1048576 | 21.9 | 1264.0 ±0.3% | 1329.1 ±0.2% | 1.05 |
| http/html-1m | 1048576 | 17.7 | 1687.0 ±0.4% | 1790.3 ±0.4% | 1.06 |
| http/json-1kx1024 | 1048576 | 21.9 | 564.0 ±0.1% | 605.1 ±1.7% | 1.07 |
| http/json-16kx64 | 1048576 | 12.6 | 1583.8 ±0.3% | 1783.9 ±0.2% | 1.13 |
| http/json-1m | 1048576 | 12.2 | 1875.7 ±0.4% | 2252.5 ±0.2% | 1.20 |
| http/js-1kx1024 | 1048576 | 44.5 | 428.5 ±0.3% | 412.6 ±0.2% | 0.96 |
| http/js-16kx64 | 1048576 | 26.0 | 1166.2 ±0.3% | 1226.9 ±0.4% | 1.05 |
| http/js-1m | 1048576 | 19.0 | 1440.0 ±14.1% | 1511.5 ±9.5% | 1.05 |
| http/css-1kx1024 | 1048576 | 29.5 | 444.0 ±8.8% | 480.3 ±12.4% | 1.08 |
| http/css-16kx64 | 1048576 | 15.9 | 1309.0 ±1.1% | 1347.7 ±2.5% | 1.03 |
| http/css-1m | 1048576 | 3.6 | 4397.7 ±2.3% | 4371.0 ±1.8% | 0.99 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1150.8 ±14.8% | 1497.8 ±18.3% | 1.30 |
