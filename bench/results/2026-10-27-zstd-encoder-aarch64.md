# bench-zstd

| Field | Value |
|---|---|
| Commit | c70e26e |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261023.149.3 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/40495156507 |
| Date | 2026-10-27 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 935.1 ±1.2% | 903.7 ±1.8% | 0.97 |
| silesia/mozilla | 51220480 | 35.6 | 1173.4 ±0.3% | 1163.4 ±0.4% | 0.99 |
| silesia/mr | 9970564 | 35.6 | 1090.2 ±1.2% | 1076.5 ±1.9% | 0.99 |
| silesia/nci | 33553445 | 8.4 | 1981.7 ±1.6% | 1829.8 ±3.5% | 0.92 |
| silesia/ooffice | 6152192 | 50.8 | 979.5 ±0.4% | 993.6 ±1.2% | 1.01 |
| silesia/osdb | 10085684 | 34.7 | 1407.8 ±1.3% | 1362.3 ±1.1% | 0.97 |
| silesia/reymont | 6627202 | 29.2 | 1054.0 ±1.1% | 1018.9 ±0.8% | 0.97 |
| silesia/samba | 21606400 | 22.9 | 1570.4 ±1.4% | 1496.2 ±2.4% | 0.95 |
| silesia/sao | 7251944 | 76.2 | 866.7 ±0.2% | 933.7 ±0.9% | 1.08 |
| silesia/webster | 41458703 | 29.2 | 1024.6 ±1.7% | 971.6 ±1.6% | 0.95 |
| silesia/x-ray | 8474240 | 71.8 | 844.7 ±0.3% | 933.5 ±0.9% | 1.11 |
| silesia/xml | 5345280 | 11.9 | 2181.5 ±1.0% | 2207.7 ±1.2% | 1.01 |
| canterbury/alice29.txt | 152089 | 37.5 | 1014.1 ±0.1% | 1027.8 ±0.3% | 1.01 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1131.7 ±0.1% | 1136.6 ±0.3% | 1.00 |
| canterbury/cp.html | 24603 | 34.4 | 1264.1 ±0.3% | 1340.5 ±0.3% | 1.06 |
| canterbury/fields.c | 11150 | 30.3 | 1079.7 ±0.2% | 1133.9 ±0.1% | 1.05 |
| canterbury/grammar.lsp | 3721 | 34.8 | 793.8 ±0.3% | 824.8 ±0.1% | 1.04 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1359.7 ±0.5% | 1267.2 ±0.2% | 0.93 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1244.2 ±0.1% | 1260.7 ±0.9% | 1.01 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1074.0 ±0.4% | 1072.9 ±0.2% | 1.00 |
| canterbury/ptt5 | 513216 | 10.6 | 2337.7 ±0.4% | 2571.1 ±3.3% | 1.10 |
| canterbury/sum | 38240 | 35.0 | 1277.5 ±0.4% | 1298.2 ±0.3% | 1.02 |
| canterbury/xargs.1 | 4227 | 42.7 | 790.0 ±0.3% | 797.2 ±0.1% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1097.4 ±1.0% | 1089.2 ±0.3% | 0.99 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1147.3 ±0.2% | 1108.7 ±0.8% | 0.97 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1341.0 ±0.6% | 1249.9 ±0.2% | 0.93 |
| http/html-1kx1024 | 1048576 | 39.3 | 457.4 ±0.1% | 453.6 ±0.3% | 0.99 |
| http/html-16kx64 | 1048576 | 21.9 | 1274.4 ±0.3% | 1273.1 ±0.5% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1686.6 ±0.2% | 1686.5 ±0.6% | 1.00 |
| http/json-1kx1024 | 1048576 | 21.9 | 529.8 ±0.2% | 544.8 ±0.1% | 1.03 |
| http/json-16kx64 | 1048576 | 12.6 | 1652.6 ±0.1% | 1681.9 ±0.3% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1955.8 ±0.5% | 2093.1 ±1.0% | 1.07 |
| http/js-1kx1024 | 1048576 | 44.5 | 400.7 ±2.7% | 372.6 ±0.2% | 0.93 |
| http/js-16kx64 | 1048576 | 26.0 | 1160.2 ±0.1% | 1146.3 ±0.5% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1666.6 ±0.1% | 1627.7 ±1.3% | 0.98 |
| http/css-1kx1024 | 1048576 | 29.5 | 481.3 ±0.2% | 490.2 ±0.1% | 1.02 |
| http/css-16kx64 | 1048576 | 15.9 | 1513.3 ±0.1% | 1501.2 ±0.2% | 0.99 |
| http/css-1m | 1048576 | 3.6 | 5147.2 ±0.4% | 4904.0 ±0.9% | 0.95 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1199.7 ±0.5% | 1246.3 ±0.7% | 1.04 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 240.1 ±1.3% | 935.7 ±0.7% | 3.90 |
| silesia/mozilla | 51220480 | 35.6 | 278.6 ±0.3% | 1172.8 ±0.6% | 4.21 |
| silesia/mr | 9970564 | 35.6 | 245.6 ±0.4% | 1122.7 ±0.9% | 4.57 |
| silesia/nci | 33553445 | 8.4 | 684.0 ±0.4% | 1977.0 ±2.9% | 2.89 |
| silesia/ooffice | 6152192 | 50.8 | 194.0 ±0.3% | 1010.1 ±0.7% | 5.21 |
| silesia/osdb | 10085684 | 34.7 | 305.2 ±0.4% | 1433.2 ±1.7% | 4.70 |
| silesia/reymont | 6627202 | 29.2 | 292.5 ±0.7% | 1051.5 ±1.5% | 3.60 |
| silesia/samba | 21606400 | 22.9 | 450.5 ±0.5% | 1580.0 ±1.1% | 3.51 |
| silesia/sao | 7251944 | 76.2 | 163.8 ±0.1% | 960.0 ±1.2% | 5.86 |
| silesia/webster | 41458703 | 29.2 | 285.3 ±0.9% | 1030.1 ±1.7% | 3.61 |
| silesia/x-ray | 8474240 | 71.8 | 153.1 ±0.3% | 948.7 ±1.1% | 6.20 |
| silesia/xml | 5345280 | 11.9 | 628.9 ±0.6% | 2243.6 ±1.0% | 3.57 |
| canterbury/alice29.txt | 152089 | 37.5 | 222.5 ±1.1% | 1028.4 ±0.2% | 4.62 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 208.4 ±0.4% | 1138.6 ±0.2% | 5.46 |
| canterbury/cp.html | 24603 | 34.4 | 254.2 ±0.2% | 1334.9 ±0.3% | 5.25 |
| canterbury/fields.c | 11150 | 30.3 | 251.0 ±0.3% | 1130.4 ±0.3% | 4.50 |
| canterbury/grammar.lsp | 3721 | 34.8 | 215.0 ±0.3% | 824.6 ±0.3% | 3.84 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 299.6 ±0.2% | 1267.6 ±0.5% | 4.23 |
| canterbury/lcet10.txt | 426754 | 33.0 | 267.0 ±0.3% | 1264.2 ±0.2% | 4.73 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 219.9 ±0.5% | 1074.6 ±0.2% | 4.89 |
| canterbury/ptt5 | 513216 | 10.6 | 474.3 ±0.3% | 2588.6 ±1.0% | 5.46 |
| canterbury/sum | 38240 | 35.0 | 250.2 ±0.2% | 1298.0 ±0.3% | 5.19 |
| canterbury/xargs.1 | 4227 | 42.7 | 182.9 ±0.2% | 794.5 ±0.1% | 4.34 |
| canterbury-large/E.coli | 4638690 | 30.0 | 267.3 ±0.6% | 1103.1 ±0.5% | 4.13 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 300.9 ±0.7% | 1124.6 ±0.8% | 3.74 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 334.6 ±0.3% | 1321.1 ±1.3% | 3.95 |
| http/html-1kx1024 | 1048576 | 39.3 | 187.8 ±0.1% | 455.0 ±0.1% | 2.42 |
| http/html-16kx64 | 1048576 | 21.9 | 335.7 ±0.1% | 1286.2 ±0.3% | 3.83 |
| http/html-1m | 1048576 | 17.7 | 454.0 ±0.2% | 1719.0 ±0.3% | 3.79 |
| http/json-1kx1024 | 1048576 | 21.9 | 279.4 ±0.2% | 546.1 ±0.1% | 1.95 |
| http/json-16kx64 | 1048576 | 12.6 | 469.2 ±0.1% | 1694.9 ±0.3% | 3.61 |
| http/json-1m | 1048576 | 12.2 | 530.8 ±0.3% | 2098.9 ±1.4% | 3.95 |
| http/js-1kx1024 | 1048576 | 44.5 | 158.4 ±0.0% | 376.3 ±0.1% | 2.38 |
| http/js-16kx64 | 1048576 | 26.0 | 287.2 ±0.1% | 1151.4 ±0.6% | 4.01 |
| http/js-1m | 1048576 | 19.0 | 430.3 ±0.2% | 1645.6 ±1.8% | 3.82 |
| http/css-1kx1024 | 1048576 | 29.5 | 233.9 ±0.1% | 495.8 ±0.1% | 2.12 |
| http/css-16kx64 | 1048576 | 15.9 | 423.5 ±0.2% | 1495.8 ±0.1% | 3.53 |
| http/css-1m | 1048576 | 3.6 | 1772.4 ±0.5% | 4889.3 ±2.8% | 2.76 |
| shuffled/dickens-1m | 1048576 | 58.8 | 153.0 ±0.2% | 1254.7 ±1.1% | 8.20 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 960.7 ±0.7% | 0.94 ±0.5% | 1.00 ±1.1% | 0.59 ±1.3% | 0.97 ±1.1% | 0.38 ±1.2% |
| silesia/mozilla | 51220480 | 35.6 | 1174.5 ±0.7% | 0.75 ±0.9% | 1.01 ±1.2% | 0.62 ±0.5% | 1.00 ±0.8% | 0.45 ±0.4% |
| silesia/mr | 9970564 | 35.6 | 1127.1 ±0.8% | 0.81 ±0.8% | 1.00 ±0.9% | 0.56 ±0.6% | 0.97 ±0.9% | 0.39 ±1.6% |
| silesia/nci | 33553445 | 8.4 | 1979.7 ±5.0% | 0.95 ±3.8% | 1.01 ±4.0% | 0.69 ±1.6% | 1.00 ±5.7% | 0.47 ±0.7% |
| silesia/ooffice | 6152192 | 50.8 | 1009.8 ±1.1% | 0.63 ±1.2% | 1.01 ±0.7% | 0.59 ±0.5% | 0.99 ±0.3% | 0.45 ±1.6% |
| silesia/osdb | 10085684 | 34.7 | 1440.6 ±0.9% | 0.67 ±1.1% | 1.00 ±0.5% | 0.68 ±0.9% | 0.96 ±1.0% | 0.45 ±0.4% |
| silesia/reymont | 6627202 | 29.2 | 1052.1 ±0.5% | 0.96 ±0.5% | 1.00 ±1.1% | 0.62 ±0.5% | 0.98 ±0.9% | 0.40 ±0.5% |
| silesia/samba | 21606400 | 22.9 | 1581.5 ±2.6% | 0.91 ±2.5% | 1.00 ±2.1% | 0.63 ±4.6% | 0.98 ±2.7% | 0.42 ±1.0% |
| silesia/sao | 7251944 | 76.2 | 964.1 ±0.8% | 0.52 ±0.5% | 1.01 ±1.0% | 0.70 ±0.7% | 0.98 ±0.9% | 0.53 ±0.8% |
| silesia/webster | 41458703 | 29.2 | 1034.2 ±1.1% | 0.92 ±1.2% | 0.99 ±0.8% | 0.62 ±1.1% | 0.96 ±1.3% | 0.42 ±1.0% |
| silesia/x-ray | 8474240 | 71.8 | 949.5 ±1.3% | 0.51 ±0.8% | 1.00 ±1.0% | 0.66 ±0.6% | 0.97 ±1.0% | 0.48 ±0.6% |
| silesia/xml | 5345280 | 11.9 | 2239.2 ±0.9% | 0.93 ±0.8% | 1.00 ±1.0% | 0.61 ±0.4% | 0.99 ±1.0% | 0.41 ±0.3% |
| canterbury/alice29.txt | 152089 | 37.5 | 1028.5 ±0.2% | 0.94 ±0.1% | 1.00 ±0.1% | 0.53 ±0.2% | 0.99 ±0.1% | 0.36 ±0.9% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1138.4 ±0.5% | 0.85 ±0.3% | 0.98 ±0.2% | 0.51 ±0.3% | 0.99 ±0.2% | 0.37 ±1.0% |
| canterbury/cp.html | 24603 | 34.4 | 1340.4 ±0.3% | 0.63 ±0.2% | 1.00 ±0.2% | 0.63 ±0.4% | 0.99 ±0.2% | 0.45 ±0.1% |
| canterbury/fields.c | 11150 | 30.3 | 1133.5 ±0.1% | 0.81 ±0.3% | 1.00 ±0.2% | 0.60 ±0.3% | 0.99 ±0.2% | 0.41 ±0.1% |
| canterbury/grammar.lsp | 3721 | 34.8 | 825.7 ±0.4% | 0.79 ±0.1% | 1.00 ±0.4% | 0.67 ±0.7% | 0.99 ±0.1% | 0.48 ±0.6% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1271.2 ±0.3% | 0.86 ±0.5% | 1.01 ±0.4% | 0.58 ±0.1% | 0.99 ±0.4% | 0.39 ±0.5% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1263.9 ±0.1% | 0.89 ±0.2% | 1.00 ±0.1% | 0.54 ±0.2% | 0.99 ±0.2% | 0.36 ±0.4% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1074.4 ±0.5% | 0.91 ±0.3% | 0.99 ±0.2% | 0.52 ±0.3% | 0.99 ±0.1% | 0.36 ±0.6% |
| canterbury/ptt5 | 513216 | 10.6 | 2563.1 ±0.8% | 0.81 ±1.0% | 1.01 ±1.4% | 0.55 ±0.2% | 1.01 ±2.2% | 0.44 ±0.3% |
| canterbury/sum | 38240 | 35.0 | 1297.5 ±0.1% | 0.63 ±0.2% | 1.00 ±0.2% | 0.64 ±0.7% | 0.99 ±0.1% | 0.45 ±0.2% |
| canterbury/xargs.1 | 4227 | 42.7 | 797.4 ±0.2% | 0.74 ±0.3% | 1.00 ±0.4% | 0.64 ±0.4% | 0.99 ±0.3% | 0.46 ±0.7% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1102.4 ±0.5% | 0.98 ±0.8% | 0.99 ±1.2% | 0.58 ±1.0% | 0.98 ±0.8% | 0.36 ±0.6% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1127.7 ±1.2% | 0.96 ±1.1% | 0.99 ±0.7% | 0.60 ±0.4% | 0.98 ±0.4% | 0.38 ±0.8% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1318.5 ±0.2% | 0.89 ±0.1% | 1.00 ±0.3% | 0.60 ±0.7% | 0.98 ±0.4% | 0.41 ±0.5% |
| http/html-1kx1024 | 1048576 | 39.3 | 454.1 ±0.2% | 0.86 ±0.1% | 1.00 ±0.2% | 0.79 ±0.2% | 0.99 ±0.2% | 0.66 ±0.1% |
| http/html-16kx64 | 1048576 | 21.9 | 1281.9 ±0.5% | 0.83 ±0.5% | 1.00 ±0.7% | 0.62 ±0.4% | 0.99 ±0.5% | 0.46 ±0.5% |
| http/html-1m | 1048576 | 17.7 | 1715.7 ±0.6% | 0.94 ±0.4% | 1.00 ±0.4% | 0.59 ±0.3% | 0.99 ±0.2% | 0.39 ±0.4% |
| http/json-1kx1024 | 1048576 | 21.9 | 545.4 ±0.2% | 0.97 ±0.3% | 1.00 ±0.1% | 0.81 ±0.1% | 0.98 ±0.1% | 0.68 ±0.2% |
| http/json-16kx64 | 1048576 | 12.6 | 1688.1 ±0.1% | 0.84 ±0.3% | 1.00 ±0.1% | 0.64 ±0.1% | 0.99 ±0.3% | 0.47 ±0.3% |
| http/json-1m | 1048576 | 12.2 | 2097.7 ±1.5% | 0.88 ±1.0% | 1.00 ±1.3% | 0.59 ±0.4% | 0.99 ±0.8% | 0.40 ±0.6% |
| http/js-1kx1024 | 1048576 | 44.5 | 375.5 ±0.1% | 0.86 ±0.2% | 1.00 ±0.1% | 0.78 ±0.1% | 0.99 ±0.1% | 0.67 ±0.4% |
| http/js-16kx64 | 1048576 | 26.0 | 1152.7 ±0.3% | 0.82 ±0.6% | 1.00 ±0.4% | 0.61 ±2.7% | 0.99 ±0.9% | 0.45 ±0.3% |
| http/js-1m | 1048576 | 19.0 | 1661.6 ±0.4% | 0.91 ±0.2% | 1.00 ±0.2% | 0.59 ±0.3% | 0.98 ±0.4% | 0.40 ±0.1% |
| http/css-1kx1024 | 1048576 | 29.5 | 495.2 ±0.2% | 0.94 ±0.2% | 1.00 ±0.2% | 0.79 ±0.1% | 0.99 ±0.1% | 0.66 ±0.2% |
| http/css-16kx64 | 1048576 | 15.9 | 1498.5 ±0.1% | 0.89 ±0.1% | 1.00 ±0.2% | 0.65 ±0.2% | 0.99 ±0.1% | 0.45 ±0.4% |
| http/css-1m | 1048576 | 3.6 | 4901.3 ±0.5% | 0.96 ±0.7% | 1.01 ±0.5% | 0.71 ±0.6% | 1.00 ±0.5% | 0.46 ±0.6% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1253.5 ±0.5% | 0.52 ±0.4% | 0.85 ±0.4% | 0.74 ±0.1% | 0.98 ±0.5% | 0.55 ±0.2% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 333.8 ± 0.5% | 83.6 ± 0.4% | 0.25 |
| silesia/dickens | 10192446 | 3 | 149.2 ± 0.6% | 57.8 ± 0.5% | 0.39 |
| silesia/mozilla | 51220480 | 1 | 481.1 ± 0.7% | 118.1 ± 0.4% | 0.25 |
| silesia/mozilla | 51220480 | 3 | 200.1 ± 2.9% | 64.4 ± 1.2% | 0.32 |
| silesia/mr | 9970564 | 1 | 441.1 ± 0.5% | 103.3 ± 0.4% | 0.23 |
| silesia/mr | 9970564 | 3 | 168.9 ± 0.8% | 62.0 ± 0.2% | 0.37 |
| silesia/nci | 33553445 | 1 | 959.9 ± 0.4% | 217.3 ± 0.1% | 0.23 |
| silesia/nci | 33553445 | 3 | 630.1 ± 0.5% | 111.4 ± 0.2% | 0.18 |
| silesia/ooffice | 6152192 | 1 | 395.5 ± 0.2% | 94.5 ± 0.3% | 0.24 |
| silesia/ooffice | 6152192 | 3 | 141.4 ± 0.4% | 56.4 ± 0.5% | 0.40 |
| silesia/osdb | 10085684 | 1 | 475.0 ± 0.3% | 125.7 ± 0.3% | 0.26 |
| silesia/osdb | 10085684 | 3 | 189.3 ± 0.6% | 67.4 ± 0.2% | 0.36 |
| silesia/reymont | 6627202 | 1 | 344.6 ± 0.4% | 99.1 ± 0.1% | 0.29 |
| silesia/reymont | 6627202 | 3 | 186.4 ± 0.7% | 71.3 ± 0.7% | 0.38 |
| silesia/samba | 21606400 | 1 | 565.6 ± 0.3% | 142.5 ± 0.4% | 0.25 |
| silesia/samba | 21606400 | 3 | 285.5 ± 0.9% | 83.1 ± 0.5% | 0.29 |
| silesia/sao | 7251944 | 1 | 373.1 ± 0.3% | 85.6 ± 0.2% | 0.23 |
| silesia/sao | 7251944 | 3 | 106.4 ± 0.2% | 47.8 ± 0.8% | 0.45 |
| silesia/webster | 41458703 | 1 | 388.2 ± 0.2% | 100.3 ± 0.1% | 0.26 |
| silesia/webster | 41458703 | 3 | 177.9 ± 0.6% | 61.8 ± 0.1% | 0.35 |
| silesia/x-ray | 8474240 | 1 | 717.0 ± 0.6% | 90.3 ± 0.4% | 0.13 |
| silesia/x-ray | 8474240 | 3 | 103.4 ± 0.2% | 49.5 ± 1.8% | 0.48 |
| silesia/xml | 5345280 | 1 | 797.2 ± 0.4% | 179.8 ± 0.3% | 0.23 |
| silesia/xml | 5345280 | 3 | 496.1 ± 0.8% | 127.9 ± 0.3% | 0.26 |
| canterbury/alice29.txt | 152089 | 1 | 310.5 ± 0.4% | 102.3 ± 0.3% | 0.33 |
| canterbury/alice29.txt | 152089 | 3 | 212.5 ± 0.2% | 92.6 ± 0.3% | 0.44 |
| canterbury/asyoulik.txt | 125179 | 1 | 346.8 ± 0.2% | 96.1 ± 0.1% | 0.28 |
| canterbury/asyoulik.txt | 125179 | 3 | 214.0 ± 0.2% | 89.7 ± 0.2% | 0.42 |
| canterbury/cp.html | 24603 | 1 | 479.2 ± 0.5% | 140.5 ± 0.3% | 0.29 |
| canterbury/cp.html | 24603 | 3 | 303.9 ± 0.8% | 121.2 ± 0.6% | 0.40 |
| canterbury/fields.c | 11150 | 1 | 344.5 ± 0.6% | 130.8 ± 0.3% | 0.38 |
| canterbury/fields.c | 11150 | 3 | 309.5 ± 0.3% | 114.7 ± 1.0% | 0.37 |
| canterbury/grammar.lsp | 3721 | 1 | 327.5 ± 0.3% | 103.7 ± 0.4% | 0.32 |
| canterbury/grammar.lsp | 3721 | 3 | 284.0 ± 0.2% | 75.1 ± 0.6% | 0.26 |
| canterbury/kennedy.xls | 1029744 | 1 | 562.8 ± 0.3% | 155.9 ± 0.4% | 0.28 |
| canterbury/kennedy.xls | 1029744 | 3 | 388.2 ± 0.5% | 137.3 ± 0.7% | 0.35 |
| canterbury/lcet10.txt | 426754 | 1 | 340.9 ± 0.3% | 107.0 ± 1.4% | 0.31 |
| canterbury/lcet10.txt | 426754 | 3 | 192.7 ± 0.4% | 96.4 ± 0.5% | 0.50 |
| canterbury/plrabn12.txt | 481861 | 1 | 327.0 ± 0.2% | 89.5 ± 0.4% | 0.27 |
| canterbury/plrabn12.txt | 481861 | 3 | 162.0 ± 0.3% | 81.6 ± 0.3% | 0.50 |
| canterbury/ptt5 | 513216 | 1 | 1089.0 ± 0.2% | 329.3 ± 0.3% | 0.30 |
| canterbury/ptt5 | 513216 | 3 | 643.7 ± 0.3% | 280.0 ± 0.4% | 0.44 |
| canterbury/sum | 38240 | 1 | 512.3 ± 0.6% | 139.8 ± 0.4% | 0.27 |
| canterbury/sum | 38240 | 3 | 335.2 ± 1.9% | 120.6 ± 1.0% | 0.36 |
| canterbury/xargs.1 | 4227 | 1 | 293.5 ± 0.8% | 104.3 ± 0.7% | 0.36 |
| canterbury/xargs.1 | 4227 | 3 | 236.4 ± 0.2% | 78.6 ± 0.4% | 0.33 |
| canterbury-large/E.coli | 4638690 | 1 | 320.9 ± 0.2% | 94.4 ± 0.5% | 0.29 |
| canterbury-large/E.coli | 4638690 | 3 | 216.4 ± 0.7% | 80.5 ± 0.8% | 0.37 |
| canterbury-large/bible.txt | 4047392 | 1 | 344.5 ± 0.3% | 100.1 ± 0.3% | 0.29 |
| canterbury-large/bible.txt | 4047392 | 3 | 188.2 ± 0.5% | 78.0 ± 0.4% | 0.41 |
| canterbury-large/world192.txt | 2473400 | 1 | 413.4 ± 0.3% | 113.9 ± 0.3% | 0.28 |
| canterbury-large/world192.txt | 2473400 | 3 | 215.7 ± 0.2% | 102.2 ± 0.4% | 0.47 |
| http/html-1kx1024 | 1048576 | 1 | 186.0 ± 0.1% | 49.7 ± 0.3% | 0.27 |
| http/html-1kx1024 | 1048576 | 3 | 163.0 ± 0.2% | 30.3 ± 0.4% | 0.19 |
| http/html-16kx64 | 1048576 | 1 | 395.3 ± 0.1% | 161.5 ± 0.2% | 0.41 |
| http/html-16kx64 | 1048576 | 3 | 334.0 ± 0.2% | 136.1 ± 0.4% | 0.41 |
| http/html-1m | 1048576 | 1 | 536.8 ± 0.5% | 166.8 ± 0.3% | 0.31 |
| http/html-1m | 1048576 | 3 | 355.7 ± 0.7% | 164.2 ± 0.3% | 0.46 |
| http/json-1kx1024 | 1048576 | 1 | 219.3 ± 0.1% | 57.6 ± 0.2% | 0.26 |
| http/json-1kx1024 | 1048576 | 3 | 206.1 ± 0.2% | 33.5 ± 0.4% | 0.16 |
| http/json-16kx64 | 1048576 | 1 | 604.6 ± 0.1% | 229.2 ± 0.2% | 0.38 |
| http/json-16kx64 | 1048576 | 3 | 510.1 ± 0.2% | 185.3 ± 0.9% | 0.36 |
| http/json-1m | 1048576 | 1 | 839.4 ± 0.5% | 230.2 ± 0.3% | 0.27 |
| http/json-1m | 1048576 | 3 | 530.9 ± 0.4% | 225.4 ± 0.8% | 0.42 |
| http/js-1kx1024 | 1048576 | 1 | 171.9 ± 0.1% | 46.0 ± 0.2% | 0.27 |
| http/js-1kx1024 | 1048576 | 3 | 146.3 ± 0.2% | 28.9 ± 0.2% | 0.20 |
| http/js-16kx64 | 1048576 | 1 | 348.2 ± 0.2% | 136.4 ± 0.1% | 0.39 |
| http/js-16kx64 | 1048576 | 3 | 295.1 ± 0.2% | 119.1 ± 0.3% | 0.40 |
| http/js-1m | 1048576 | 1 | 513.3 ± 0.6% | 153.6 ± 0.6% | 0.30 |
| http/js-1m | 1048576 | 3 | 334.1 ± 0.3% | 153.2 ± 0.4% | 0.46 |
| http/css-1kx1024 | 1048576 | 1 | 202.7 ± 0.2% | 53.7 ± 0.4% | 0.27 |
| http/css-1kx1024 | 1048576 | 3 | 185.0 ± 0.2% | 32.0 ± 0.4% | 0.17 |
| http/css-16kx64 | 1048576 | 1 | 486.0 ± 0.3% | 179.7 ± 0.5% | 0.37 |
| http/css-16kx64 | 1048576 | 3 | 432.7 ± 0.1% | 155.4 ± 0.3% | 0.36 |
| http/css-1m | 1048576 | 1 | 2294.4 ± 0.5% | 479.6 ± 0.6% | 0.21 |
| http/css-1m | 1048576 | 3 | 1673.7 ± 0.4% | 660.2 ± 0.5% | 0.39 |
| shuffled/dickens-1m | 1048576 | 1 | 963.9 ± 0.4% | 185.0 ± 0.3% | 0.19 |
| shuffled/dickens-1m | 1048576 | 3 | 112.5 ± 0.8% | 121.4 ± 0.5% | 1.08 |

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
| silesia/dickens | 10192446 | 35.9 | 961.0 ±1.5% | 926.4 ±0.7% | 0.96 |
| silesia/mozilla | 51220480 | 35.6 | 1173.7 ±0.3% | 1183.8 ±0.1% | 1.01 |
| silesia/mr | 9970564 | 35.6 | 1113.5 ±0.9% | 1098.4 ±0.7% | 0.99 |
| silesia/nci | 33553445 | 8.4 | 2051.9 ±0.9% | 1940.7 ±3.4% | 0.95 |
| silesia/ooffice | 6152192 | 50.8 | 988.2 ±1.2% | 1010.0 ±0.7% | 1.02 |
| silesia/osdb | 10085684 | 34.7 | 1432.5 ±1.0% | 1387.4 ±1.0% | 0.97 |
| silesia/reymont | 6627202 | 29.2 | 1058.4 ±0.7% | 1020.7 ±0.7% | 0.96 |
| silesia/samba | 21606400 | 22.9 | 1616.8 ±0.6% | 1573.5 ±2.2% | 0.97 |
| silesia/sao | 7251944 | 76.2 | 891.3 ±2.0% | 967.7 ±1.4% | 1.09 |
| silesia/webster | 41458703 | 29.2 | 1062.0 ±0.6% | 1006.5 ±2.8% | 0.95 |
| silesia/x-ray | 8474240 | 71.8 | 850.4 ±0.3% | 940.7 ±0.1% | 1.11 |
| silesia/xml | 5345280 | 11.9 | 2193.3 ±0.3% | 2235.4 ±0.4% | 1.02 |
| canterbury/alice29.txt | 152089 | 37.5 | 1011.3 ±0.2% | 1025.1 ±0.1% | 1.01 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1131.3 ±0.3% | 1134.9 ±4.5% | 1.00 |
| canterbury/cp.html | 24603 | 34.4 | 1251.6 ±0.5% | 1333.9 ±0.1% | 1.07 |
| canterbury/fields.c | 11150 | 30.3 | 1071.6 ±0.3% | 1119.5 ±0.1% | 1.04 |
| canterbury/grammar.lsp | 3721 | 34.8 | 787.8 ±0.3% | 823.4 ±0.2% | 1.05 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1355.3 ±0.1% | 1273.4 ±0.3% | 0.94 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1238.4 ±0.1% | 1257.0 ±0.4% | 1.02 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1064.7 ±0.2% | 1068.4 ±0.3% | 1.00 |
| canterbury/ptt5 | 513216 | 10.6 | 2368.1 ±0.5% | 2558.5 ±1.7% | 1.08 |
| canterbury/sum | 38240 | 35.0 | 1233.3 ±0.2% | 1292.4 ±0.1% | 1.05 |
| canterbury/xargs.1 | 4227 | 42.7 | 780.8 ±0.2% | 795.8 ±0.1% | 1.02 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1090.0 ±0.7% | 1077.3 ±0.5% | 0.99 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1129.4 ±0.4% | 1108.1 ±0.5% | 0.98 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1294.2 ±0.4% | 1280.5 ±0.3% | 0.99 |
| http/html-1kx1024 | 1048576 | 39.3 | 458.6 ±0.1% | 478.1 ±0.2% | 1.04 |
| http/html-16kx64 | 1048576 | 21.9 | 1274.1 ±0.1% | 1278.2 ±0.3% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1694.2 ±0.4% | 1686.1 ±0.5% | 1.00 |
| http/json-1kx1024 | 1048576 | 21.9 | 531.8 ±0.1% | 573.7 ±0.1% | 1.08 |
| http/json-16kx64 | 1048576 | 12.6 | 1654.0 ±0.3% | 1697.9 ±0.2% | 1.03 |
| http/json-1m | 1048576 | 12.2 | 1952.7 ±0.6% | 2112.3 ±0.4% | 1.08 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.8 ±0.2% | 391.0 ±0.1% | 0.97 |
| http/js-16kx64 | 1048576 | 26.0 | 1158.4 ±0.4% | 1148.4 ±0.1% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1670.1 ±0.2% | 1634.0 ±0.3% | 0.98 |
| http/css-1kx1024 | 1048576 | 29.5 | 479.0 ±0.2% | 519.5 ±0.2% | 1.08 |
| http/css-16kx64 | 1048576 | 15.9 | 1480.2 ±0.2% | 1504.5 ±0.1% | 1.02 |
| http/css-1m | 1048576 | 3.6 | 5040.2 ±0.3% | 4883.3 ±0.5% | 0.97 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1206.4 ±0.3% | 1240.6 ±0.3% | 1.03 |
