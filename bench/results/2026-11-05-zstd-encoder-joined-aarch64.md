# bench-zstd

| Field | Value |
|---|---|
| Commit | c74152e |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261101.172.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/41980417764 |
| Date | 2026-11-05 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 892.8 ±3.0% | 865.7 ±5.6% | 0.97 |
| silesia/mozilla | 51220480 | 35.6 | 1162.6 ±1.3% | 1151.1 ±1.6% | 0.99 |
| silesia/mr | 9970564 | 35.6 | 1049.1 ±2.0% | 1018.3 ±3.1% | 0.97 |
| silesia/nci | 33553445 | 8.4 | 1892.5 ±1.3% | 1725.7 ±2.4% | 0.91 |
| silesia/ooffice | 6152192 | 50.8 | 963.6 ±1.3% | 985.1 ±5.2% | 1.02 |
| silesia/osdb | 10085684 | 34.7 | 1369.2 ±0.9% | 1333.9 ±2.4% | 0.97 |
| silesia/reymont | 6627202 | 29.2 | 1021.5 ±4.5% | 991.6 ±9.5% | 0.97 |
| silesia/samba | 21606400 | 22.9 | 1531.1 ±2.2% | 1445.3 ±4.5% | 0.94 |
| silesia/sao | 7251944 | 76.2 | 857.8 ±0.9% | 922.2 ±0.5% | 1.08 |
| silesia/webster | 41458703 | 29.2 | 996.9 ±1.4% | 936.9 ±1.3% | 0.94 |
| silesia/x-ray | 8474240 | 71.8 | 839.5 ±0.2% | 924.4 ±3.6% | 1.10 |
| silesia/xml | 5345280 | 11.9 | 2171.2 ±1.9% | 2167.2 ±10.6% | 1.00 |
| canterbury/alice29.txt | 152089 | 37.5 | 1015.3 ±0.0% | 1027.4 ±0.1% | 1.01 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1133.2 ±0.7% | 1138.7 ±0.1% | 1.00 |
| canterbury/cp.html | 24603 | 34.4 | 1269.1 ±0.3% | 1334.9 ±0.1% | 1.05 |
| canterbury/fields.c | 11150 | 30.3 | 1081.6 ±0.2% | 1131.4 ±0.1% | 1.05 |
| canterbury/grammar.lsp | 3721 | 34.8 | 796.7 ±0.1% | 822.8 ±0.1% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1360.6 ±0.2% | 1264.7 ±0.3% | 0.93 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1238.6 ±0.2% | 1256.7 ±0.5% | 1.01 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1068.5 ±0.1% | 1067.1 ±0.4% | 1.00 |
| canterbury/ptt5 | 513216 | 10.6 | 2378.1 ±0.2% | 2592.3 ±1.7% | 1.09 |
| canterbury/sum | 38240 | 35.0 | 1282.4 ±0.7% | 1296.2 ±0.1% | 1.01 |
| canterbury/xargs.1 | 4227 | 42.7 | 791.4 ±0.3% | 795.9 ±0.1% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1084.0 ±0.5% | 1048.9 ±0.5% | 0.97 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1108.5 ±0.5% | 1074.5 ±0.6% | 0.97 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1305.2 ±0.2% | 1268.5 ±0.3% | 0.97 |
| http/html-1kx1024 | 1048576 | 39.3 | 457.7 ±0.1% | 450.2 ±0.1% | 0.98 |
| http/html-16kx64 | 1048576 | 21.9 | 1274.7 ±0.2% | 1274.1 ±0.4% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1688.6 ±0.3% | 1681.0 ±0.4% | 1.00 |
| http/json-1kx1024 | 1048576 | 21.9 | 529.9 ±0.1% | 544.5 ±0.0% | 1.03 |
| http/json-16kx64 | 1048576 | 12.6 | 1654.6 ±0.1% | 1688.5 ±0.3% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1959.5 ±0.7% | 2077.7 ±2.1% | 1.06 |
| http/js-1kx1024 | 1048576 | 44.5 | 400.8 ±0.1% | 371.3 ±0.1% | 0.93 |
| http/js-16kx64 | 1048576 | 26.0 | 1160.2 ±0.1% | 1148.2 ±0.5% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1659.4 ±0.2% | 1634.5 ±0.7% | 0.99 |
| http/css-1kx1024 | 1048576 | 29.5 | 481.5 ±0.2% | 495.0 ±0.1% | 1.03 |
| http/css-16kx64 | 1048576 | 15.9 | 1515.4 ±0.1% | 1501.0 ±0.2% | 0.99 |
| http/css-1m | 1048576 | 3.6 | 5091.6 ±1.0% | 4833.0 ±2.2% | 0.95 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1196.5 ±0.5% | 1241.0 ±0.5% | 1.04 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 235.8 ±1.0% | 907.0 ±3.5% | 3.85 |
| silesia/mozilla | 51220480 | 35.6 | 277.1 ±0.2% | 1164.4 ±0.5% | 4.20 |
| silesia/mr | 9970564 | 35.6 | 242.6 ±0.5% | 1089.6 ±2.8% | 4.49 |
| silesia/nci | 33553445 | 8.4 | 668.9 ±1.0% | 1866.7 ±6.4% | 2.79 |
| silesia/ooffice | 6152192 | 50.8 | 193.3 ±0.3% | 1000.2 ±3.3% | 5.17 |
| silesia/osdb | 10085684 | 34.7 | 300.6 ±1.2% | 1356.3 ±5.5% | 4.51 |
| silesia/reymont | 6627202 | 29.2 | 286.0 ±2.6% | 1031.6 ±0.4% | 3.61 |
| silesia/samba | 21606400 | 22.9 | 444.9 ±0.9% | 1531.6 ±1.7% | 3.44 |
| silesia/sao | 7251944 | 76.2 | 163.3 ±0.2% | 947.0 ±1.1% | 5.80 |
| silesia/webster | 41458703 | 29.2 | 278.5 ±1.0% | 983.6 ±1.1% | 3.53 |
| silesia/x-ray | 8474240 | 71.8 | 152.7 ±0.5% | 920.5 ±4.3% | 6.03 |
| silesia/xml | 5345280 | 11.9 | 625.5 ±0.4% | 2207.7 ±1.1% | 3.53 |
| canterbury/alice29.txt | 152089 | 37.5 | 221.8 ±0.4% | 1027.7 ±0.0% | 4.63 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 208.4 ±0.7% | 1138.9 ±0.1% | 5.46 |
| canterbury/cp.html | 24603 | 34.4 | 254.5 ±0.2% | 1333.9 ±0.1% | 5.24 |
| canterbury/fields.c | 11150 | 30.3 | 250.6 ±0.4% | 1128.2 ±0.3% | 4.50 |
| canterbury/grammar.lsp | 3721 | 34.8 | 215.3 ±0.7% | 824.3 ±0.1% | 3.83 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 297.3 ±0.8% | 1266.3 ±0.4% | 4.26 |
| canterbury/lcet10.txt | 426754 | 33.0 | 266.5 ±0.3% | 1263.5 ±0.2% | 4.74 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 220.4 ±0.4% | 1074.5 ±0.3% | 4.88 |
| canterbury/ptt5 | 513216 | 10.6 | 473.6 ±0.2% | 2580.8 ±1.5% | 5.45 |
| canterbury/sum | 38240 | 35.0 | 250.6 ±0.1% | 1294.5 ±0.2% | 5.17 |
| canterbury/xargs.1 | 4227 | 42.7 | 183.3 ±0.2% | 798.4 ±0.1% | 4.36 |
| canterbury-large/E.coli | 4638690 | 30.0 | 264.6 ±1.0% | 1085.6 ±0.6% | 4.10 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 296.7 ±1.8% | 1098.2 ±2.4% | 3.70 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 329.2 ±1.4% | 1299.5 ±3.8% | 3.95 |
| http/html-1kx1024 | 1048576 | 39.3 | 187.8 ±0.1% | 452.8 ±0.1% | 2.41 |
| http/html-16kx64 | 1048576 | 21.9 | 334.8 ±0.1% | 1282.5 ±0.3% | 3.83 |
| http/html-1m | 1048576 | 17.7 | 451.9 ±0.8% | 1705.6 ±1.3% | 3.77 |
| http/json-1kx1024 | 1048576 | 21.9 | 278.9 ±0.3% | 546.2 ±0.1% | 1.96 |
| http/json-16kx64 | 1048576 | 12.6 | 468.0 ±0.1% | 1693.8 ±0.2% | 3.62 |
| http/json-1m | 1048576 | 12.2 | 528.2 ±1.0% | 2085.3 ±0.9% | 3.95 |
| http/js-1kx1024 | 1048576 | 44.5 | 158.5 ±0.2% | 373.8 ±0.3% | 2.36 |
| http/js-16kx64 | 1048576 | 26.0 | 286.5 ±0.1% | 1154.2 ±0.3% | 4.03 |
| http/js-1m | 1048576 | 19.0 | 428.4 ±0.5% | 1654.3 ±0.3% | 3.86 |
| http/css-1kx1024 | 1048576 | 29.5 | 234.5 ±0.1% | 495.7 ±0.1% | 2.11 |
| http/css-16kx64 | 1048576 | 15.9 | 421.6 ±0.1% | 1499.4 ±0.1% | 3.56 |
| http/css-1m | 1048576 | 3.6 | 1770.2 ±0.3% | 4891.3 ±1.5% | 2.76 |
| shuffled/dickens-1m | 1048576 | 58.8 | 152.7 ±0.4% | 1249.2 ±0.9% | 8.18 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 927.7 ±3.6% | 0.93 ±3.1% | 1.00 ±2.1% | 0.59 ±5.2% | 0.95 ±4.6% | 0.38 ±1.5% |
| silesia/mozilla | 51220480 | 35.6 | 1164.9 ±3.3% | 0.74 ±6.4% | 1.00 ±1.8% | 0.61 ±1.6% | 0.99 ±1.6% | 0.45 ±1.9% |
| silesia/mr | 9970564 | 35.6 | 1105.3 ±1.5% | 0.81 ±1.5% | 1.00 ±7.3% | 0.56 ±1.3% | 0.97 ±3.9% | 0.39 ±9.0% |
| silesia/nci | 33553445 | 8.4 | 1928.8 ±9.3% | 0.94 ±10.3% | 1.00 ±8.6% | 0.69 ±3.6% | 0.96 ±9.3% | 0.47 ±3.5% |
| silesia/ooffice | 6152192 | 50.8 | 1013.2 ±0.8% | 0.62 ±0.7% | 1.00 ±1.2% | 0.59 ±0.7% | 0.98 ±1.0% | 0.45 ±1.3% |
| silesia/osdb | 10085684 | 34.7 | 1425.1 ±1.3% | 0.67 ±0.4% | 1.00 ±1.3% | 0.68 ±1.1% | 0.96 ±1.8% | 0.46 ±0.8% |
| silesia/reymont | 6627202 | 29.2 | 1035.0 ±1.4% | 0.95 ±11.7% | 1.00 ±1.7% | 0.62 ±2.7% | 0.97 ±13.8% | 0.40 ±0.9% |
| silesia/samba | 21606400 | 22.9 | 1534.5 ±2.4% | 0.93 ±2.0% | 1.01 ±1.8% | 0.64 ±1.9% | 1.00 ±4.9% | 0.43 ±3.1% |
| silesia/sao | 7251944 | 76.2 | 961.2 ±0.9% | 0.52 ±0.9% | 1.00 ±1.5% | 0.70 ±1.0% | 0.98 ±1.0% | 0.53 ±1.3% |
| silesia/webster | 41458703 | 29.2 | 1000.1 ±2.4% | 0.92 ±1.6% | 1.00 ±6.1% | 0.63 ±2.1% | 0.98 ±1.8% | 0.43 ±0.8% |
| silesia/x-ray | 8474240 | 71.8 | 937.6 ±1.2% | 0.51 ±0.4% | 1.00 ±0.7% | 0.65 ±0.6% | 0.96 ±3.1% | 0.48 ±2.0% |
| silesia/xml | 5345280 | 11.9 | 2198.6 ±13.0% | 0.93 ±1.8% | 1.00 ±2.1% | 0.61 ±4.2% | 0.99 ±2.0% | 0.41 ±3.7% |
| canterbury/alice29.txt | 152089 | 37.5 | 1027.5 ±0.3% | 0.94 ±0.1% | 1.00 ±0.1% | 0.53 ±0.2% | 0.99 ±0.1% | 0.36 ±0.1% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1139.3 ±0.1% | 0.85 ±0.2% | 0.98 ±0.0% | 0.51 ±0.3% | 0.99 ±0.1% | 0.37 ±0.5% |
| canterbury/cp.html | 24603 | 34.4 | 1342.7 ±0.1% | 0.63 ±0.3% | 1.00 ±0.3% | 0.61 ±0.2% | 0.98 ±0.1% | 0.45 ±0.1% |
| canterbury/fields.c | 11150 | 30.3 | 1134.5 ±0.4% | 0.81 ±0.1% | 1.00 ±0.1% | 0.59 ±0.4% | 0.99 ±0.1% | 0.41 ±0.3% |
| canterbury/grammar.lsp | 3721 | 34.8 | 824.2 ±0.2% | 0.79 ±0.1% | 1.00 ±0.1% | 0.67 ±0.6% | 0.99 ±0.1% | 0.49 ±0.1% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1267.6 ±0.5% | 0.86 ±0.1% | 1.01 ±0.5% | 0.58 ±0.4% | 1.00 ±0.4% | 0.38 ±1.2% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1262.1 ±0.6% | 0.89 ±0.2% | 1.00 ±0.1% | 0.53 ±0.5% | 0.99 ±0.2% | 0.36 ±0.5% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1076.6 ±0.4% | 0.91 ±0.2% | 0.99 ±0.3% | 0.52 ±0.2% | 0.99 ±0.3% | 0.36 ±1.9% |
| canterbury/ptt5 | 513216 | 10.6 | 2551.4 ±0.7% | 0.81 ±1.4% | 1.02 ±2.4% | 0.56 ±0.1% | 1.01 ±2.3% | 0.44 ±0.9% |
| canterbury/sum | 38240 | 35.0 | 1297.7 ±0.1% | 0.64 ±0.1% | 1.00 ±0.2% | 0.62 ±0.4% | 0.99 ±0.2% | 0.45 ±0.1% |
| canterbury/xargs.1 | 4227 | 42.7 | 799.7 ±0.1% | 0.74 ±0.1% | 0.99 ±0.1% | 0.64 ±1.0% | 0.99 ±0.1% | 0.47 ±0.2% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1095.8 ±0.3% | 0.98 ±0.6% | 1.00 ±0.4% | 0.58 ±0.8% | 0.98 ±0.4% | 0.36 ±0.5% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1108.8 ±0.6% | 0.96 ±0.7% | 1.00 ±0.3% | 0.61 ±1.1% | 0.98 ±2.6% | 0.39 ±6.8% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1307.4 ±0.5% | 0.89 ±0.4% | 1.00 ±1.0% | 0.60 ±0.4% | 0.98 ±0.4% | 0.41 ±0.8% |
| http/html-1kx1024 | 1048576 | 39.3 | 454.0 ±0.1% | 0.86 ±0.1% | 1.00 ±0.0% | 0.79 ±0.1% | 0.99 ±0.1% | 0.67 ±0.2% |
| http/html-16kx64 | 1048576 | 21.9 | 1280.0 ±0.3% | 0.83 ±0.2% | 1.00 ±0.2% | 0.62 ±0.4% | 0.99 ±0.2% | 0.46 ±0.2% |
| http/html-1m | 1048576 | 17.7 | 1701.1 ±0.6% | 0.94 ±0.5% | 1.01 ±0.3% | 0.60 ±0.3% | 0.99 ±0.6% | 0.40 ±0.8% |
| http/json-1kx1024 | 1048576 | 21.9 | 546.8 ±0.1% | 0.98 ±0.1% | 1.00 ±0.1% | 0.81 ±0.1% | 0.98 ±0.1% | 0.68 ±0.0% |
| http/json-16kx64 | 1048576 | 12.6 | 1695.2 ±0.3% | 0.85 ±0.3% | 1.00 ±0.2% | 0.64 ±0.2% | 0.99 ±0.1% | 0.47 ±0.3% |
| http/json-1m | 1048576 | 12.2 | 2094.9 ±1.7% | 0.88 ±0.5% | 1.00 ±0.6% | 0.58 ±1.1% | 0.99 ±0.8% | 0.40 ±0.7% |
| http/js-1kx1024 | 1048576 | 44.5 | 374.5 ±0.1% | 0.86 ±0.1% | 1.00 ±0.2% | 0.78 ±0.1% | 0.99 ±0.1% | 0.67 ±0.5% |
| http/js-16kx64 | 1048576 | 26.0 | 1154.5 ±0.2% | 0.82 ±0.1% | 1.00 ±0.1% | 0.61 ±0.1% | 0.99 ±0.1% | 0.45 ±0.2% |
| http/js-1m | 1048576 | 19.0 | 1645.8 ±0.7% | 0.92 ±0.9% | 1.00 ±1.1% | 0.60 ±0.8% | 0.99 ±0.4% | 0.40 ±0.3% |
| http/css-1kx1024 | 1048576 | 29.5 | 495.3 ±0.2% | 0.95 ±0.1% | 1.00 ±0.2% | 0.80 ±0.0% | 0.99 ±0.1% | 0.67 ±0.2% |
| http/css-16kx64 | 1048576 | 15.9 | 1502.1 ±0.1% | 0.89 ±0.2% | 1.00 ±0.1% | 0.64 ±0.1% | 0.99 ±0.1% | 0.45 ±2.1% |
| http/css-1m | 1048576 | 3.6 | 4912.7 ±0.5% | 0.95 ±0.8% | 1.00 ±0.7% | 0.70 ±0.4% | 0.98 ±0.9% | 0.46 ±0.5% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1244.6 ±0.6% | 0.52 ±0.3% | 0.86 ±0.6% | 0.75 ±0.5% | 0.98 ±0.9% | 0.56 ±1.1% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 333.2 ± 0.3% | 138.2 ± 0.4% | 0.41 |
| silesia/dickens | 10192446 | 3 | 143.6 ± 0.8% | 93.7 ± 0.7% | 0.65 |
| silesia/mozilla | 51220480 | 1 | 480.3 ± 0.2% | 191.5 ± 0.5% | 0.40 |
| silesia/mozilla | 51220480 | 3 | 189.5 ± 1.9% | 108.8 ± 1.9% | 0.57 |
| silesia/mr | 9970564 | 1 | 439.7 ± 0.2% | 169.0 ± 0.6% | 0.38 |
| silesia/mr | 9970564 | 3 | 161.0 ± 0.3% | 99.1 ± 0.4% | 0.62 |
| silesia/nci | 33553445 | 1 | 951.4 ± 0.5% | 437.6 ± 0.7% | 0.46 |
| silesia/nci | 33553445 | 3 | 606.7 ± 9.4% | 296.5 ± 1.9% | 0.49 |
| silesia/ooffice | 6152192 | 1 | 395.5 ± 0.3% | 146.5 ± 0.6% | 0.37 |
| silesia/ooffice | 6152192 | 3 | 134.3 ± 0.4% | 79.8 ± 0.5% | 0.59 |
| silesia/osdb | 10085684 | 1 | 474.5 ± 0.5% | 204.9 ± 0.3% | 0.43 |
| silesia/osdb | 10085684 | 3 | 178.9 ± 0.8% | 105.0 ± 0.7% | 0.59 |
| silesia/reymont | 6627202 | 1 | 344.3 ± 0.3% | 166.9 ± 0.2% | 0.48 |
| silesia/reymont | 6627202 | 3 | 178.2 ± 2.1% | 118.1 ± 1.4% | 0.66 |
| silesia/samba | 21606400 | 1 | 564.6 ± 2.9% | 249.5 ± 0.5% | 0.44 |
| silesia/samba | 21606400 | 3 | 274.4 ± 0.5% | 163.7 ± 0.4% | 0.60 |
| silesia/sao | 7251944 | 1 | 372.2 ± 0.5% | 130.0 ± 0.5% | 0.35 |
| silesia/sao | 7251944 | 3 | 100.6 ± 0.7% | 65.2 ± 0.5% | 0.65 |
| silesia/webster | 41458703 | 1 | 387.7 ± 0.3% | 165.7 ± 0.2% | 0.43 |
| silesia/webster | 41458703 | 3 | 171.0 ± 2.9% | 108.4 ± 0.3% | 0.63 |
| silesia/x-ray | 8474240 | 1 | 709.0 ± 2.8% | 140.7 ± 0.6% | 0.20 |
| silesia/x-ray | 8474240 | 3 | 98.6 ± 0.6% | 70.1 ± 0.7% | 0.71 |
| silesia/xml | 5345280 | 1 | 793.8 ± 0.6% | 324.6 ± 1.1% | 0.41 |
| silesia/xml | 5345280 | 3 | 476.1 ± 5.6% | 259.9 ± 5.2% | 0.55 |
| canterbury/alice29.txt | 152089 | 1 | 311.7 ± 0.4% | 150.2 ± 0.4% | 0.48 |
| canterbury/alice29.txt | 152089 | 3 | 207.8 ± 0.8% | 126.4 ± 1.7% | 0.61 |
| canterbury/asyoulik.txt | 125179 | 1 | 347.8 ± 0.2% | 142.2 ± 0.4% | 0.41 |
| canterbury/asyoulik.txt | 125179 | 3 | 216.4 ± 0.8% | 118.7 ± 0.6% | 0.55 |
| canterbury/cp.html | 24603 | 1 | 488.1 ± 0.3% | 207.9 ± 0.3% | 0.43 |
| canterbury/cp.html | 24603 | 3 | 367.6 ± 1.5% | 186.5 ± 0.6% | 0.51 |
| canterbury/fields.c | 11150 | 1 | 390.4 ± 0.9% | 198.8 ± 0.8% | 0.51 |
| canterbury/fields.c | 11150 | 3 | 374.4 ± 0.8% | 197.4 ± 0.8% | 0.53 |
| canterbury/grammar.lsp | 3721 | 1 | 360.1 ± 0.8% | 167.5 ± 0.4% | 0.47 |
| canterbury/grammar.lsp | 3721 | 3 | 319.9 ± 0.3% | 159.2 ± 0.1% | 0.50 |
| canterbury/kennedy.xls | 1029744 | 1 | 564.9 ± 0.3% | 229.2 ± 0.6% | 0.41 |
| canterbury/kennedy.xls | 1029744 | 3 | 376.8 ± 0.7% | 163.5 ± 0.5% | 0.43 |
| canterbury/lcet10.txt | 426754 | 1 | 342.5 ± 0.1% | 156.7 ± 0.3% | 0.46 |
| canterbury/lcet10.txt | 426754 | 3 | 190.4 ± 2.0% | 125.6 ± 0.8% | 0.66 |
| canterbury/plrabn12.txt | 481861 | 1 | 326.3 ± 0.2% | 133.4 ± 0.2% | 0.41 |
| canterbury/plrabn12.txt | 481861 | 3 | 152.8 ± 0.2% | 105.2 ± 0.6% | 0.69 |
| canterbury/ptt5 | 513216 | 1 | 1085.2 ± 0.4% | 445.9 ± 2.1% | 0.41 |
| canterbury/ptt5 | 513216 | 3 | 637.8 ± 0.6% | 352.5 ± 0.5% | 0.55 |
| canterbury/sum | 38240 | 1 | 526.1 ± 0.5% | 198.0 ± 0.2% | 0.38 |
| canterbury/sum | 38240 | 3 | 375.9 ± 1.0% | 171.7 ± 0.3% | 0.46 |
| canterbury/xargs.1 | 4227 | 1 | 338.6 ± 0.6% | 162.0 ± 0.2% | 0.48 |
| canterbury/xargs.1 | 4227 | 3 | 281.8 ± 0.3% | 148.7 ± 0.3% | 0.53 |
| canterbury-large/E.coli | 4638690 | 1 | 320.7 ± 0.2% | 153.3 ± 0.6% | 0.48 |
| canterbury-large/E.coli | 4638690 | 3 | 207.1 ± 0.3% | 140.5 ± 0.7% | 0.68 |
| canterbury-large/bible.txt | 4047392 | 1 | 343.0 ± 2.8% | 164.8 ± 0.8% | 0.48 |
| canterbury-large/bible.txt | 4047392 | 3 | 176.7 ± 0.8% | 118.5 ± 1.2% | 0.67 |
| canterbury-large/world192.txt | 2473400 | 1 | 412.3 ± 0.4% | 179.8 ± 0.5% | 0.44 |
| canterbury-large/world192.txt | 2473400 | 3 | 207.0 ± 0.4% | 132.5 ± 0.8% | 0.64 |
| http/html-1kx1024 | 1048576 | 1 | 198.8 ± 0.1% | 94.3 ± 0.6% | 0.47 |
| http/html-1kx1024 | 1048576 | 3 | 176.0 ± 0.1% | 88.3 ± 0.2% | 0.50 |
| http/html-16kx64 | 1048576 | 1 | 437.2 ± 0.4% | 238.3 ± 0.6% | 0.55 |
| http/html-16kx64 | 1048576 | 3 | 377.9 ± 0.1% | 215.0 ± 1.0% | 0.57 |
| http/html-1m | 1048576 | 1 | 537.3 ± 0.5% | 257.3 ± 1.6% | 0.48 |
| http/html-1m | 1048576 | 3 | 343.8 ± 1.0% | 210.8 ± 0.5% | 0.61 |
| http/json-1kx1024 | 1048576 | 1 | 237.6 ± 0.2% | 113.6 ± 0.4% | 0.48 |
| http/json-1kx1024 | 1048576 | 3 | 227.9 ± 0.2% | 108.9 ± 0.4% | 0.48 |
| http/json-16kx64 | 1048576 | 1 | 708.3 ± 0.2% | 348.5 ± 0.7% | 0.49 |
| http/json-16kx64 | 1048576 | 3 | 625.0 ± 0.2% | 316.3 ± 0.5% | 0.51 |
| http/json-1m | 1048576 | 1 | 833.6 ± 0.5% | 371.5 ± 1.3% | 0.45 |
| http/json-1m | 1048576 | 3 | 513.4 ± 0.6% | 292.5 ± 0.7% | 0.57 |
| http/js-1kx1024 | 1048576 | 1 | 183.1 ± 0.1% | 84.7 ± 0.6% | 0.46 |
| http/js-1kx1024 | 1048576 | 3 | 157.0 ± 0.3% | 79.4 ± 0.4% | 0.51 |
| http/js-16kx64 | 1048576 | 1 | 380.7 ± 0.2% | 201.7 ± 0.1% | 0.53 |
| http/js-16kx64 | 1048576 | 3 | 328.9 ± 0.3% | 187.9 ± 1.3% | 0.57 |
| http/js-1m | 1048576 | 1 | 509.6 ± 0.5% | 237.9 ± 0.5% | 0.47 |
| http/js-1m | 1048576 | 3 | 321.1 ± 0.7% | 195.3 ± 0.9% | 0.61 |
| http/css-1kx1024 | 1048576 | 1 | 218.3 ± 0.2% | 104.1 ± 0.9% | 0.48 |
| http/css-1kx1024 | 1048576 | 3 | 202.3 ± 0.1% | 99.2 ± 0.3% | 0.49 |
| http/css-16kx64 | 1048576 | 1 | 550.8 ± 0.3% | 271.2 ± 0.5% | 0.49 |
| http/css-16kx64 | 1048576 | 3 | 509.4 ± 0.4% | 257.1 ± 1.2% | 0.50 |
| http/css-1m | 1048576 | 1 | 2282.1 ± 0.2% | 850.4 ± 0.6% | 0.37 |
| http/css-1m | 1048576 | 3 | 1676.3 ± 0.3% | 846.5 ± 0.5% | 0.51 |
| shuffled/dickens-1m | 1048576 | 1 | 958.5 ± 0.5% | 364.8 ± 1.9% | 0.38 |
| shuffled/dickens-1m | 1048576 | 3 | 106.4 ± 1.8% | 157.9 ± 1.8% | 1.48 |

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
| silesia/dickens | 10192446 | 35.9 | 894.6 ±3.7% | 876.0 ±9.9% | 0.98 |
| silesia/mozilla | 51220480 | 35.6 | 1164.0 ±0.2% | 1161.6 ±2.5% | 1.00 |
| silesia/mr | 9970564 | 35.6 | 1077.2 ±1.1% | 1067.8 ±1.3% | 0.99 |
| silesia/nci | 33553445 | 8.4 | 1973.0 ±0.7% | 1804.4 ±2.3% | 0.91 |
| silesia/ooffice | 6152192 | 50.8 | 969.0 ±1.3% | 997.3 ±0.8% | 1.03 |
| silesia/osdb | 10085684 | 34.7 | 1367.5 ±1.1% | 1347.0 ±1.4% | 0.98 |
| silesia/reymont | 6627202 | 29.2 | 1026.9 ±3.4% | 992.1 ±9.6% | 0.97 |
| silesia/samba | 21606400 | 22.9 | 1557.2 ±1.3% | 1494.2 ±2.0% | 0.96 |
| silesia/sao | 7251944 | 76.2 | 856.9 ±0.5% | 933.8 ±1.0% | 1.09 |
| silesia/webster | 41458703 | 29.2 | 1013.1 ±1.4% | 963.9 ±1.0% | 0.95 |
| silesia/x-ray | 8474240 | 71.8 | 838.9 ±0.4% | 915.2 ±1.1% | 1.09 |
| silesia/xml | 5345280 | 11.9 | 2159.9 ±3.2% | 2194.4 ±7.6% | 1.02 |
| canterbury/alice29.txt | 152089 | 37.5 | 1009.2 ±0.2% | 1016.6 ±0.3% | 1.01 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1126.8 ±0.1% | 1137.3 ±0.1% | 1.01 |
| canterbury/cp.html | 24603 | 34.4 | 1266.7 ±0.2% | 1333.2 ±0.1% | 1.05 |
| canterbury/fields.c | 11150 | 30.3 | 1079.7 ±0.1% | 1118.5 ±0.1% | 1.04 |
| canterbury/grammar.lsp | 3721 | 34.8 | 799.7 ±0.2% | 823.4 ±0.1% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1354.3 ±0.4% | 1262.7 ±0.5% | 0.93 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1231.3 ±0.2% | 1165.8 ±0.3% | 0.95 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1064.8 ±0.2% | 1068.1 ±0.2% | 1.00 |
| canterbury/ptt5 | 513216 | 10.6 | 2358.8 ±0.2% | 2572.6 ±0.4% | 1.09 |
| canterbury/sum | 38240 | 35.0 | 1275.1 ±0.2% | 1292.8 ±0.1% | 1.01 |
| canterbury/xargs.1 | 4227 | 42.7 | 788.7 ±0.1% | 796.6 ±0.1% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1083.3 ±6.0% | 1048.7 ±0.7% | 0.97 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1108.0 ±0.8% | 1075.8 ±0.4% | 0.97 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1300.7 ±2.5% | 1220.7 ±1.4% | 0.94 |
| http/html-1kx1024 | 1048576 | 39.3 | 457.6 ±0.1% | 476.8 ±0.1% | 1.04 |
| http/html-16kx64 | 1048576 | 21.9 | 1272.6 ±0.2% | 1276.2 ±0.2% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1680.8 ±0.4% | 1687.8 ±0.2% | 1.00 |
| http/json-1kx1024 | 1048576 | 21.9 | 531.6 ±0.1% | 572.1 ±0.1% | 1.08 |
| http/json-16kx64 | 1048576 | 12.6 | 1661.4 ±0.1% | 1695.9 ±0.2% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1962.2 ±0.2% | 2072.2 ±0.3% | 1.06 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.1 ±0.4% | 391.0 ±0.1% | 0.97 |
| http/js-16kx64 | 1048576 | 26.0 | 1159.3 ±0.3% | 1143.9 ±0.3% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1662.5 ±0.3% | 1591.5 ±1.8% | 0.96 |
| http/css-1kx1024 | 1048576 | 29.5 | 482.3 ±0.1% | 519.0 ±0.2% | 1.08 |
| http/css-16kx64 | 1048576 | 15.9 | 1511.5 ±0.2% | 1506.9 ±0.1% | 1.00 |
| http/css-1m | 1048576 | 3.6 | 5102.0 ±0.5% | 4869.7 ±0.9% | 0.95 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1189.9 ±0.5% | 1232.7 ±0.6% | 1.04 |
