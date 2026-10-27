# bench-zstd

| Field | Value |
|---|---|
| Commit | 087c201 |
| Runner label | ubuntu-24.04 |
| Image version | 20261023.334.3 |
| CPU model | AMD EPYC 9V74 80-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/40535059200 |
| Date | 2026-10-27 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 851.5 ±0.6% | 1144.3 ±0.6% | 1.34 |
| silesia/mozilla | 51220480 | 35.6 | 966.1 ±2.3% | 1207.6 ±1.2% | 1.25 |
| silesia/mr | 9970564 | 35.6 | 958.1 ±6.0% | 1250.1 ±3.8% | 1.30 |
| silesia/nci | 33553445 | 8.4 | 1621.6 ±22.2% | 2275.1 ±39.6% | 1.40 |
| silesia/ooffice | 6152192 | 50.8 | 830.3 ±1.2% | 1040.3 ±1.9% | 1.25 |
| silesia/osdb | 10085684 | 34.7 | 1271.4 ±1.3% | 1535.9 ±1.0% | 1.21 |
| silesia/reymont | 6627202 | 29.2 | 985.3 ±0.5% | 1283.2 ±3.5% | 1.30 |
| silesia/samba | 21606400 | 22.9 | 1359.2 ±3.0% | 1705.6 ±2.3% | 1.25 |
| silesia/sao | 7251944 | 76.2 | 806.0 ±1.4% | 1029.0 ±0.9% | 1.28 |
| silesia/webster | 41458703 | 29.2 | 986.3 ±1.5% | 1251.7 ±1.1% | 1.27 |
| silesia/x-ray | 8474240 | 71.8 | 783.4 ±15.9% | 986.7 ±16.6% | 1.26 |
| silesia/xml | 5345280 | 11.9 | 1719.0 ±0.4% | 2224.0 ±0.3% | 1.29 |
| canterbury/alice29.txt | 152089 | 37.5 | 763.8 ±0.5% | 1030.5 ±0.4% | 1.35 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 885.2 ±0.4% | 1148.2 ±0.2% | 1.30 |
| canterbury/cp.html | 24603 | 34.4 | 1112.1 ±1.2% | 1331.2 ±0.3% | 1.20 |
| canterbury/fields.c | 11150 | 30.3 | 922.9 ±4.2% | 1147.3 ±2.1% | 1.24 |
| canterbury/grammar.lsp | 3721 | 34.8 | 729.3 ±0.6% | 845.0 ±0.6% | 1.16 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1031.1 ±0.2% | 1254.9 ±0.3% | 1.22 |
| canterbury/lcet10.txt | 426754 | 33.0 | 959.4 ±21.7% | 1265.3 ±2.1% | 1.32 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 829.9 ±0.4% | 1096.3 ±0.4% | 1.32 |
| canterbury/ptt5 | 513216 | 10.6 | 2465.4 ±0.1% | 2916.9 ±0.3% | 1.18 |
| canterbury/sum | 38240 | 35.0 | 1109.4 ±0.1% | 1253.6 ±0.2% | 1.13 |
| canterbury/xargs.1 | 4227 | 42.7 | 710.7 ±1.1% | 819.8 ±3.8% | 1.15 |
| canterbury-large/E.coli | 4638690 | 30.0 | 898.4 ±0.8% | 1205.8 ±0.3% | 1.34 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 981.5 ±2.3% | 1301.1 ±0.3% | 1.33 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1144.3 ±0.9% | 1422.1 ±2.7% | 1.24 |
| http/html-1kx1024 | 1048576 | 39.3 | 429.8 ±0.4% | 418.2 ±0.2% | 0.97 |
| http/html-16kx64 | 1048576 | 21.9 | 1052.7 ±0.3% | 1235.4 ±0.4% | 1.17 |
| http/html-1m | 1048576 | 17.7 | 1346.0 ±0.2% | 1751.4 ±1.7% | 1.30 |
| http/json-1kx1024 | 1048576 | 21.9 | 501.9 ±2.7% | 509.0 ±9.3% | 1.01 |
| http/json-16kx64 | 1048576 | 12.6 | 1357.1 ±2.0% | 1758.6 ±1.0% | 1.30 |
| http/json-1m | 1048576 | 12.2 | 1570.1 ±0.7% | 2295.8 ±0.7% | 1.46 |
| http/js-1kx1024 | 1048576 | 44.5 | 376.2 ±4.5% | 345.3 ±2.7% | 0.92 |
| http/js-16kx64 | 1048576 | 26.0 | 957.5 ±0.5% | 1140.5 ±3.7% | 1.19 |
| http/js-1m | 1048576 | 19.0 | 1335.6 ±0.2% | 1727.6 ±1.9% | 1.29 |
| http/css-1kx1024 | 1048576 | 29.5 | 461.5 ±0.2% | 461.2 ±0.2% | 1.00 |
| http/css-16kx64 | 1048576 | 15.9 | 1286.9 ±1.0% | 1537.2 ±0.2% | 1.19 |
| http/css-1m | 1048576 | 3.6 | 4076.1 ±0.3% | 5237.2 ±0.2% | 1.28 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1153.3 ±1.5% | 1359.0 ±0.7% | 1.18 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 270.3 ±0.5% | 1141.2 ±1.3% | 4.22 |
| silesia/mozilla | 51220480 | 35.6 | 312.0 ±1.2% | 1220.9 ±0.9% | 3.91 |
| silesia/mr | 9970564 | 35.6 | 278.3 ±1.0% | 1280.5 ±1.0% | 4.60 |
| silesia/nci | 33553445 | 8.4 | 741.5 ±3.6% | 2367.4 ±8.9% | 3.19 |
| silesia/ooffice | 6152192 | 50.8 | 225.9 ±0.9% | 1033.1 ±1.7% | 4.57 |
| silesia/osdb | 10085684 | 34.7 | 368.3 ±0.4% | 1533.5 ±0.6% | 4.16 |
| silesia/reymont | 6627202 | 29.2 | 327.7 ±0.3% | 1283.8 ±0.3% | 3.92 |
| silesia/samba | 21606400 | 22.9 | 493.5 ±15.2% | 1676.4 ±1.5% | 3.40 |
| silesia/sao | 7251944 | 76.2 | 203.8 ±0.2% | 1010.9 ±1.9% | 4.96 |
| silesia/webster | 41458703 | 29.2 | 319.3 ±2.4% | 1249.4 ±3.6% | 3.91 |
| silesia/x-ray | 8474240 | 71.8 | 189.7 ±0.1% | 992.4 ±0.5% | 5.23 |
| silesia/xml | 5345280 | 11.9 | 665.1 ±0.7% | 2225.2 ±0.3% | 3.35 |
| canterbury/alice29.txt | 152089 | 37.5 | 236.1 ±0.6% | 1036.6 ±0.2% | 4.39 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 227.1 ±3.9% | 1149.0 ±0.3% | 5.06 |
| canterbury/cp.html | 24603 | 34.4 | 318.4 ±0.1% | 1339.3 ±0.2% | 4.21 |
| canterbury/fields.c | 11150 | 30.3 | 305.3 ±0.3% | 1141.0 ±0.2% | 3.74 |
| canterbury/grammar.lsp | 3721 | 34.8 | 261.2 ±0.7% | 771.3 ±0.2% | 2.95 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 331.0 ±0.6% | 1255.0 ±2.1% | 3.79 |
| canterbury/lcet10.txt | 426754 | 33.0 | 284.1 ±0.3% | 1271.4 ±0.3% | 4.48 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 232.1 ±0.2% | 1094.5 ±0.2% | 4.72 |
| canterbury/ptt5 | 513216 | 10.6 | 524.5 ±0.4% | 2904.2 ±0.2% | 5.54 |
| canterbury/sum | 38240 | 35.0 | 315.2 ±0.2% | 1279.1 ±0.3% | 4.06 |
| canterbury/xargs.1 | 4227 | 42.7 | 227.4 ±0.2% | 818.4 ±0.3% | 3.60 |
| canterbury-large/E.coli | 4638690 | 30.0 | 287.3 ±0.8% | 1209.8 ±0.4% | 4.21 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 332.9 ±0.7% | 1294.9 ±1.5% | 3.89 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 361.4 ±0.6% | 1418.7 ±0.8% | 3.93 |
| http/html-1kx1024 | 1048576 | 39.3 | 207.9 ±0.4% | 419.8 ±0.2% | 2.02 |
| http/html-16kx64 | 1048576 | 21.9 | 356.9 ±0.2% | 1233.8 ±0.4% | 3.46 |
| http/html-1m | 1048576 | 17.7 | 471.2 ±0.3% | 1748.3 ±3.2% | 3.71 |
| http/json-1kx1024 | 1048576 | 21.9 | 300.5 ±0.4% | 517.2 ±0.3% | 1.72 |
| http/json-16kx64 | 1048576 | 12.6 | 504.5 ±0.3% | 1760.7 ±1.4% | 3.49 |
| http/json-1m | 1048576 | 12.2 | 564.7 ±0.6% | 2301.2 ±0.7% | 4.07 |
| http/js-1kx1024 | 1048576 | 44.5 | 171.7 ±1.8% | 347.5 ±1.6% | 2.02 |
| http/js-16kx64 | 1048576 | 26.0 | 301.9 ±0.7% | 1138.8 ±1.3% | 3.77 |
| http/js-1m | 1048576 | 19.0 | 450.4 ±0.2% | 1758.5 ±0.7% | 3.90 |
| http/css-1kx1024 | 1048576 | 29.5 | 255.3 ±0.3% | 463.4 ±0.1% | 1.82 |
| http/css-16kx64 | 1048576 | 15.9 | 445.3 ±0.5% | 1533.7 ±0.5% | 3.44 |
| http/css-1m | 1048576 | 3.6 | 1865.4 ±0.7% | 5219.3 ±0.4% | 2.80 |
| shuffled/dickens-1m | 1048576 | 58.8 | 202.1 ±0.2% | 1365.8 ±0.8% | 6.76 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 1137.2 ±0.8% | 0.92 ±0.8% | 1.01 ±2.3% | 0.50 ±1.3% | 0.99 ±0.4% | 0.32 ±0.4% |
| silesia/mozilla | 51220480 | 35.6 | 1216.0 ±2.4% | 0.72 ±2.6% | 1.00 ±1.3% | 0.56 ±1.1% | 1.00 ±1.3% | 0.40 ±0.7% |
| silesia/mr | 9970564 | 35.6 | 1257.7 ±1.5% | 0.79 ±1.4% | 1.00 ±1.7% | 0.50 ±1.3% | 1.00 ±3.4% | 0.34 ±2.0% |
| silesia/nci | 33553445 | 8.4 | 2366.5 ±4.8% | 0.93 ±2.3% | 0.99 ±2.4% | 0.57 ±1.6% | 1.00 ±1.8% | 0.39 ±3.1% |
| silesia/ooffice | 6152192 | 50.8 | 1049.0 ±1.3% | 0.59 ±1.3% | 1.00 ±1.4% | 0.55 ±0.2% | 0.99 ±0.7% | 0.41 ±0.4% |
| silesia/osdb | 10085684 | 34.7 | 1484.9 ±4.6% | 0.65 ±12.4% | 1.03 ±0.3% | 0.66 ±0.9% | 1.01 ±1.2% | 0.43 ±0.6% |
| silesia/reymont | 6627202 | 29.2 | 1210.1 ±1.9% | 0.99 ±1.0% | 1.06 ±0.6% | 0.55 ±0.4% | 1.04 ±1.0% | 0.35 ±4.6% |
| silesia/samba | 21606400 | 22.9 | 1673.4 ±5.5% | 0.92 ±5.2% | 1.01 ±1.1% | 0.58 ±3.5% | 1.01 ±1.8% | 0.39 ±5.2% |
| silesia/sao | 7251944 | 76.2 | 1025.3 ±2.6% | 0.48 ±1.5% | 1.00 ±3.6% | 0.63 ±1.8% | 0.98 ±15.7% | 0.47 ±2.9% |
| silesia/webster | 41458703 | 29.2 | 1167.6 ±5.1% | 0.91 ±5.9% | 1.01 ±10.2% | 0.54 ±6.6% | 1.01 ±5.2% | 0.36 ±3.3% |
| silesia/x-ray | 8474240 | 71.8 | 992.5 ±0.3% | 0.48 ±0.3% | 1.00 ±0.7% | 0.61 ±1.7% | 0.98 ±0.6% | 0.44 ±0.9% |
| silesia/xml | 5345280 | 11.9 | 2220.8 ±0.4% | 0.92 ±0.5% | 1.00 ±0.6% | 0.58 ±1.6% | 1.00 ±0.4% | 0.39 ±0.3% |
| canterbury/alice29.txt | 152089 | 37.5 | 1036.5 ±0.1% | 0.93 ±0.2% | 1.00 ±0.3% | 0.52 ±4.2% | 0.99 ±0.4% | 0.32 ±0.1% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1149.9 ±0.1% | 0.82 ±0.2% | 0.98 ±1.7% | 0.54 ±0.2% | 0.99 ±0.4% | 0.33 ±0.3% |
| canterbury/cp.html | 24603 | 34.4 | 1340.4 ±0.2% | 0.61 ±0.1% | 1.00 ±0.1% | 0.65 ±0.8% | 0.99 ±0.4% | 0.44 ±0.1% |
| canterbury/fields.c | 11150 | 30.3 | 1155.4 ±3.2% | 0.77 ±0.2% | 1.00 ±0.3% | 0.59 ±0.2% | 0.99 ±0.2% | 0.37 ±0.2% |
| canterbury/grammar.lsp | 3721 | 34.8 | 838.2 ±0.4% | 0.78 ±0.2% | 0.99 ±0.3% | 0.66 ±2.2% | 1.00 ±0.2% | 0.44 ±0.1% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1253.9 ±1.9% | 0.85 ±10.7% | 1.01 ±23.5% | 0.53 ±0.3% | 1.00 ±1.9% | 0.34 ±0.7% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1261.6 ±0.3% | 0.88 ±3.8% | 1.00 ±0.6% | 0.50 ±0.5% | 1.00 ±0.7% | 0.33 ±0.1% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1099.1 ±3.5% | 0.89 ±0.5% | 0.99 ±3.7% | 0.47 ±16.6% | 0.98 ±0.3% | 0.32 ±0.6% |
| canterbury/ptt5 | 513216 | 10.6 | 2836.3 ±0.5% | 0.78 ±0.7% | 1.02 ±0.5% | 0.61 ±3.5% | 1.02 ±0.3% | 0.40 ±2.4% |
| canterbury/sum | 38240 | 35.0 | 1283.1 ±0.9% | 0.62 ±0.3% | 1.00 ±0.4% | 0.66 ±0.0% | 0.99 ±0.5% | 0.44 ±2.0% |
| canterbury/xargs.1 | 4227 | 42.7 | 820.9 ±0.2% | 0.71 ±0.5% | 1.00 ±14.3% | 0.63 ±3.5% | 0.99 ±0.5% | 0.43 ±0.2% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1211.3 ±0.5% | 0.97 ±0.4% | 1.00 ±0.5% | 0.50 ±0.7% | 0.98 ±0.3% | 0.31 ±1.6% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1299.0 ±0.4% | 0.96 ±0.5% | 1.00 ±2.9% | 0.52 ±0.4% | 0.99 ±1.1% | 0.32 ±2.3% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1425.6 ±0.5% | 0.88 ±0.6% | 0.99 ±0.5% | 0.53 ±0.2% | 0.99 ±0.5% | 0.36 ±0.7% |
| http/html-1kx1024 | 1048576 | 39.3 | 420.5 ±0.4% | 0.87 ±0.4% | 1.01 ±0.2% | 0.78 ±0.6% | 0.99 ±0.5% | 0.65 ±0.2% |
| http/html-16kx64 | 1048576 | 21.9 | 1239.1 ±1.2% | 0.82 ±0.4% | 1.00 ±0.2% | 0.59 ±0.1% | 0.99 ±0.3% | 0.40 ±1.7% |
| http/html-1m | 1048576 | 17.7 | 1773.5 ±1.5% | 0.94 ±1.5% | 1.01 ±1.8% | 0.54 ±0.5% | 1.00 ±1.1% | 0.34 ±0.4% |
| http/json-1kx1024 | 1048576 | 21.9 | 516.5 ±0.2% | 0.99 ±0.4% | 1.01 ±0.3% | 0.74 ±0.3% | 1.00 ±0.3% | 0.66 ±0.6% |
| http/json-16kx64 | 1048576 | 12.6 | 1767.2 ±2.7% | 0.83 ±0.8% | 1.00 ±0.9% | 0.56 ±0.1% | 1.00 ±0.6% | 0.40 ±0.3% |
| http/json-1m | 1048576 | 12.2 | 2298.3 ±0.5% | 0.86 ±0.2% | 1.01 ±0.2% | 0.50 ±0.4% | 0.99 ±0.4% | 0.33 ±0.3% |
| http/js-1kx1024 | 1048576 | 44.5 | 346.1 ±0.1% | 0.87 ±0.2% | 1.01 ±0.2% | 0.78 ±0.6% | 1.00 ±1.0% | 0.65 ±1.0% |
| http/js-16kx64 | 1048576 | 26.0 | 1141.3 ±0.4% | 0.81 ±0.8% | 1.01 ±0.2% | 0.56 ±0.4% | 1.00 ±0.3% | 0.40 ±0.6% |
| http/js-1m | 1048576 | 19.0 | 1771.7 ±11.1% | 0.90 ±2.6% | 1.01 ±7.1% | 0.52 ±10.6% | 0.98 ±1.0% | 0.33 ±0.4% |
| http/css-1kx1024 | 1048576 | 29.5 | 463.8 ±0.6% | 0.94 ±0.3% | 1.00 ±3.0% | 0.79 ±0.4% | 0.99 ±0.8% | 0.65 ±1.8% |
| http/css-16kx64 | 1048576 | 15.9 | 1531.9 ±0.2% | 0.88 ±0.3% | 1.00 ±0.2% | 0.61 ±0.5% | 0.99 ±0.8% | 0.40 ±1.0% |
| http/css-1m | 1048576 | 3.6 | 5178.5 ±0.2% | 0.95 ±0.1% | 1.01 ±0.2% | 0.73 ±1.1% | 0.99 ±0.2% | 0.42 ±2.1% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1363.9 ±0.7% | 0.46 ±2.5% | 0.84 ±1.4% | 0.67 ±0.4% | 0.98 ±0.4% | 0.47 ±0.5% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 310.0 ± 0.6% | 91.7 ± 0.5% | 0.30 |
| silesia/dickens | 10192446 | 3 | 191.8 ± 1.4% | 71.6 ± 0.4% | 0.37 |
| silesia/mozilla | 51220480 | 1 | 474.3 ± 0.7% | 127.9 ± 0.4% | 0.27 |
| silesia/mozilla | 51220480 | 3 | 277.1 ± 0.8% | 89.6 ± 0.3% | 0.32 |
| silesia/mr | 9970564 | 1 | 427.0 ± 0.4% | 115.0 ± 0.3% | 0.27 |
| silesia/mr | 9970564 | 3 | 233.1 ± 0.9% | 82.4 ± 0.7% | 0.35 |
| silesia/nci | 33553445 | 1 | 953.0 ± 0.7% | 251.4 ± 0.4% | 0.26 |
| silesia/nci | 33553445 | 3 | 731.7 ± 6.6% | 147.3 ± 0.5% | 0.20 |
| silesia/ooffice | 6152192 | 1 | 386.9 ± 0.6% | 102.7 ± 0.3% | 0.27 |
| silesia/ooffice | 6152192 | 3 | 193.8 ± 2.5% | 79.4 ± 0.7% | 0.41 |
| silesia/osdb | 10085684 | 1 | 466.4 ± 0.9% | 141.6 ± 1.6% | 0.30 |
| silesia/osdb | 10085684 | 3 | 276.0 ± 2.9% | 98.7 ± 1.3% | 0.36 |
| silesia/reymont | 6627202 | 1 | 321.4 ± 0.6% | 108.5 ± 0.4% | 0.34 |
| silesia/reymont | 6627202 | 3 | 250.1 ± 2.5% | 88.4 ± 1.2% | 0.35 |
| silesia/samba | 21606400 | 1 | 543.5 ± 0.3% | 156.3 ± 0.6% | 0.29 |
| silesia/samba | 21606400 | 3 | 370.3 ± 2.1% | 108.2 ± 4.5% | 0.29 |
| silesia/sao | 7251944 | 1 | 370.1 ± 0.3% | 99.6 ± 0.5% | 0.27 |
| silesia/sao | 7251944 | 3 | 156.3 ± 15.8% | 73.2 ± 8.8% | 0.47 |
| silesia/webster | 41458703 | 1 | 357.8 ± 0.5% | 109.1 ± 1.0% | 0.30 |
| silesia/webster | 41458703 | 3 | 230.1 ± 2.0% | 79.2 ± 0.2% | 0.34 |
| silesia/x-ray | 8474240 | 1 | 782.2 ± 0.6% | 103.7 ± 0.4% | 0.13 |
| silesia/x-ray | 8474240 | 3 | 151.2 ± 1.2% | 73.4 ± 1.1% | 0.49 |
| silesia/xml | 5345280 | 1 | 757.1 ± 0.1% | 201.8 ± 0.5% | 0.27 |
| silesia/xml | 5345280 | 3 | 602.6 ± 10.3% | 158.9 ± 4.7% | 0.26 |
| canterbury/alice29.txt | 152089 | 1 | 304.4 ± 1.6% | 104.9 ± 0.4% | 0.34 |
| canterbury/alice29.txt | 152089 | 3 | 213.1 ± 8.1% | 93.2 ± 1.1% | 0.44 |
| canterbury/asyoulik.txt | 125179 | 1 | 417.6 ± 1.3% | 98.9 ± 0.2% | 0.24 |
| canterbury/asyoulik.txt | 125179 | 3 | 223.9 ± 1.0% | 89.3 ± 2.8% | 0.40 |
| canterbury/cp.html | 24603 | 1 | 497.8 ± 0.4% | 193.5 ± 1.6% | 0.39 |
| canterbury/cp.html | 24603 | 3 | 325.6 ± 1.7% | 150.7 ± 0.6% | 0.46 |
| canterbury/fields.c | 11150 | 1 | 365.2 ± 0.4% | 159.0 ± 0.2% | 0.44 |
| canterbury/fields.c | 11150 | 3 | 311.2 ± 1.0% | 118.6 ± 0.2% | 0.38 |
| canterbury/grammar.lsp | 3721 | 1 | 302.7 ± 0.3% | 114.4 ± 0.4% | 0.38 |
| canterbury/grammar.lsp | 3721 | 3 | 253.6 ± 0.4% | 66.1 ± 0.3% | 0.26 |
| canterbury/kennedy.xls | 1029744 | 1 | 561.8 ± 0.3% | 171.2 ± 0.7% | 0.30 |
| canterbury/kennedy.xls | 1029744 | 3 | 486.7 ± 0.5% | 159.2 ± 1.0% | 0.33 |
| canterbury/lcet10.txt | 426754 | 1 | 307.3 ± 0.4% | 110.2 ± 0.3% | 0.36 |
| canterbury/lcet10.txt | 426754 | 3 | 225.7 ± 0.6% | 101.0 ± 0.5% | 0.45 |
| canterbury/plrabn12.txt | 481861 | 1 | 300.6 ± 0.6% | 93.6 ± 1.1% | 0.31 |
| canterbury/plrabn12.txt | 481861 | 3 | 186.1 ± 0.3% | 86.2 ± 0.6% | 0.46 |
| canterbury/ptt5 | 513216 | 1 | 1076.5 ± 1.8% | 323.2 ± 0.2% | 0.30 |
| canterbury/ptt5 | 513216 | 3 | 786.5 ± 0.9% | 293.8 ± 0.7% | 0.37 |
| canterbury/sum | 38240 | 1 | 547.0 ± 0.1% | 187.2 ± 2.9% | 0.34 |
| canterbury/sum | 38240 | 3 | 368.2 ± 0.1% | 153.4 ± 4.1% | 0.42 |
| canterbury/xargs.1 | 4227 | 1 | 280.5 ± 0.1% | 122.1 ± 0.5% | 0.44 |
| canterbury/xargs.1 | 4227 | 3 | 209.3 ± 0.2% | 90.2 ± 0.6% | 0.43 |
| canterbury-large/E.coli | 4638690 | 1 | 305.8 ± 0.2% | 106.1 ± 0.1% | 0.35 |
| canterbury-large/E.coli | 4638690 | 3 | 271.3 ± 3.0% | 94.7 ± 1.1% | 0.35 |
| canterbury-large/bible.txt | 4047392 | 1 | 318.2 ± 0.6% | 109.2 ± 0.7% | 0.34 |
| canterbury-large/bible.txt | 4047392 | 3 | 241.9 ± 1.9% | 93.1 ± 1.4% | 0.38 |
| canterbury-large/world192.txt | 2473400 | 1 | 377.1 ± 0.2% | 120.6 ± 0.3% | 0.32 |
| canterbury-large/world192.txt | 2473400 | 3 | 271.7 ± 0.5% | 121.3 ± 0.3% | 0.45 |
| http/html-1kx1024 | 1048576 | 1 | 143.7 ± 1.9% | 41.2 ± 9.3% | 0.29 |
| http/html-1kx1024 | 1048576 | 3 | 125.6 ± 0.3% | 22.9 ± 0.1% | 0.18 |
| http/html-16kx64 | 1048576 | 1 | 366.7 ± 0.3% | 159.3 ± 0.4% | 0.43 |
| http/html-16kx64 | 1048576 | 3 | 307.0 ± 0.5% | 127.1 ± 0.4% | 0.41 |
| http/html-1m | 1048576 | 1 | 498.2 ± 6.6% | 174.3 ± 5.6% | 0.35 |
| http/html-1m | 1048576 | 3 | 405.7 ± 1.5% | 174.9 ± 1.7% | 0.43 |
| http/json-1kx1024 | 1048576 | 1 | 168.8 ± 0.9% | 46.8 ± 0.2% | 0.28 |
| http/json-1kx1024 | 1048576 | 3 | 158.3 ± 0.2% | 24.6 ± 0.2% | 0.16 |
| http/json-16kx64 | 1048576 | 1 | 575.8 ± 0.1% | 229.1 ± 0.4% | 0.40 |
| http/json-16kx64 | 1048576 | 3 | 482.6 ± 0.2% | 167.3 ± 0.2% | 0.35 |
| http/json-1m | 1048576 | 1 | 824.9 ± 0.8% | 247.1 ± 0.6% | 0.30 |
| http/json-1m | 1048576 | 3 | 632.8 ± 0.3% | 243.6 ± 0.9% | 0.38 |
| http/js-1kx1024 | 1048576 | 1 | 134.4 ± 1.8% | 38.4 ± 0.2% | 0.29 |
| http/js-1kx1024 | 1048576 | 3 | 113.8 ± 0.2% | 22.1 ± 0.2% | 0.19 |
| http/js-16kx64 | 1048576 | 1 | 326.5 ± 0.3% | 134.6 ± 0.3% | 0.41 |
| http/js-16kx64 | 1048576 | 3 | 272.5 ± 0.2% | 113.0 ± 0.6% | 0.41 |
| http/js-1m | 1048576 | 1 | 473.9 ± 0.2% | 160.3 ± 0.6% | 0.34 |
| http/js-1m | 1048576 | 3 | 388.4 ± 0.3% | 165.7 ± 0.4% | 0.43 |
| http/css-1kx1024 | 1048576 | 1 | 157.0 ± 2.5% | 44.1 ± 0.3% | 0.28 |
| http/css-1kx1024 | 1048576 | 3 | 142.4 ± 0.3% | 23.9 ± 0.2% | 0.17 |
| http/css-16kx64 | 1048576 | 1 | 473.4 ± 0.2% | 179.5 ± 1.5% | 0.38 |
| http/css-16kx64 | 1048576 | 3 | 411.0 ± 0.2% | 143.2 ± 0.4% | 0.35 |
| http/css-1m | 1048576 | 1 | 2522.2 ± 4.2% | 541.5 ± 0.3% | 0.21 |
| http/css-1m | 1048576 | 3 | 2007.1 ± 2.7% | 694.8 ± 0.8% | 0.35 |
| shuffled/dickens-1m | 1048576 | 1 | 1163.1 ± 0.4% | 188.7 ± 0.4% | 0.16 |
| shuffled/dickens-1m | 1048576 | 3 | 170.6 ± 5.9% | 136.6 ± 14.6% | 0.80 |

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
| silesia/dickens | 10192446 | 35.9 | 855.0 ±1.1% | 1146.5 ±0.6% | 1.34 |
| silesia/mozilla | 51220480 | 35.6 | 963.4 ±1.3% | 1224.7 ±1.0% | 1.27 |
| silesia/mr | 9970564 | 35.6 | 963.9 ±1.2% | 1268.2 ±6.4% | 1.32 |
| silesia/nci | 33553445 | 8.4 | 1777.1 ±3.6% | 2406.0 ±1.6% | 1.35 |
| silesia/ooffice | 6152192 | 50.8 | 832.9 ±0.7% | 1054.4 ±0.1% | 1.27 |
| silesia/osdb | 10085684 | 34.7 | 1263.2 ±1.0% | 1527.6 ±0.7% | 1.21 |
| silesia/reymont | 6627202 | 29.2 | 976.8 ±1.0% | 1282.9 ±0.5% | 1.31 |
| silesia/samba | 21606400 | 22.9 | 1372.5 ±1.1% | 1698.6 ±1.5% | 1.24 |
| silesia/sao | 7251944 | 76.2 | 805.1 ±1.9% | 1022.3 ±2.0% | 1.27 |
| silesia/webster | 41458703 | 29.2 | 978.5 ±5.6% | 1245.4 ±2.2% | 1.27 |
| silesia/x-ray | 8474240 | 71.8 | 790.4 ±0.3% | 995.4 ±0.4% | 1.26 |
| silesia/xml | 5345280 | 11.9 | 1718.5 ±0.2% | 2218.4 ±0.3% | 1.29 |
| canterbury/alice29.txt | 152089 | 37.5 | 766.0 ±0.3% | 1042.9 ±0.2% | 1.36 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 874.7 ±0.2% | 1136.1 ±0.2% | 1.30 |
| canterbury/cp.html | 24603 | 34.4 | 1105.5 ±0.2% | 1344.0 ±0.2% | 1.22 |
| canterbury/fields.c | 11150 | 30.3 | 912.7 ±0.3% | 1150.0 ±0.1% | 1.26 |
| canterbury/grammar.lsp | 3721 | 34.8 | 720.8 ±1.3% | 825.1 ±0.1% | 1.14 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1032.0 ±0.2% | 1255.8 ±0.7% | 1.22 |
| canterbury/lcet10.txt | 426754 | 33.0 | 960.8 ±0.2% | 1281.8 ±0.2% | 1.33 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 826.4 ±0.2% | 1097.5 ±0.3% | 1.33 |
| canterbury/ptt5 | 513216 | 10.6 | 2470.9 ±0.7% | 2936.8 ±0.2% | 1.19 |
| canterbury/sum | 38240 | 35.0 | 1087.7 ±0.2% | 1289.7 ±0.3% | 1.19 |
| canterbury/xargs.1 | 4227 | 42.7 | 704.8 ±0.1% | 813.5 ±0.2% | 1.15 |
| canterbury-large/E.coli | 4638690 | 30.0 | 895.9 ±0.4% | 1210.3 ±0.1% | 1.35 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 979.1 ±0.6% | 1299.6 ±1.3% | 1.33 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1144.5 ±0.2% | 1425.1 ±0.2% | 1.25 |
| http/html-1kx1024 | 1048576 | 39.3 | 430.9 ±0.2% | 450.1 ±0.2% | 1.04 |
| http/html-16kx64 | 1048576 | 21.9 | 1018.6 ±0.2% | 1244.4 ±0.8% | 1.22 |
| http/html-1m | 1048576 | 17.7 | 1344.0 ±0.2% | 1767.6 ±0.7% | 1.32 |
| http/json-1kx1024 | 1048576 | 21.9 | 503.4 ±0.2% | 558.9 ±0.2% | 1.11 |
| http/json-16kx64 | 1048576 | 12.6 | 1368.4 ±0.1% | 1789.5 ±0.8% | 1.31 |
| http/json-1m | 1048576 | 12.2 | 1569.2 ±0.2% | 2280.5 ±1.4% | 1.45 |
| http/js-1kx1024 | 1048576 | 44.5 | 376.2 ±1.1% | 368.0 ±0.5% | 0.98 |
| http/js-16kx64 | 1048576 | 26.0 | 957.2 ±0.2% | 1159.0 ±0.5% | 1.21 |
| http/js-1m | 1048576 | 19.0 | 1331.9 ±0.2% | 1782.7 ±0.4% | 1.34 |
| http/css-1kx1024 | 1048576 | 29.5 | 462.5 ±0.3% | 496.9 ±0.1% | 1.07 |
| http/css-16kx64 | 1048576 | 15.9 | 1285.7 ±4.3% | 1551.3 ±6.2% | 1.21 |
| http/css-1m | 1048576 | 3.6 | 4057.0 ±1.1% | 5247.0 ±14.8% | 1.29 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1154.0 ±0.3% | 1377.6 ±0.8% | 1.19 |
