# bench-zstd

| Field | Value |
|---|---|
| Commit | fdfbb70 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/45895089065 |
| Date | 2026-11-26 |
| libzstd | 1.5.7 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 962.6 ±0.9% | 919.2 ±0.5% | 0.95 |
| silesia/mozilla | 51220480 | 35.6 | 1194.8 ±0.5% | 1187.0 ±0.5% | 0.99 |
| silesia/mr | 9970564 | 35.6 | 1127.1 ±0.8% | 1080.1 ±0.6% | 0.96 |
| silesia/nci | 33553445 | 8.4 | 2059.1 ±3.3% | 1960.8 ±1.7% | 0.95 |
| silesia/ooffice | 6152192 | 50.8 | 1009.0 ±0.5% | 1007.5 ±1.3% | 1.00 |
| silesia/osdb | 10085684 | 34.7 | 1415.9 ±1.0% | 1370.2 ±0.4% | 0.97 |
| silesia/reymont | 6627202 | 29.2 | 1055.9 ±0.9% | 1002.7 ±0.7% | 0.95 |
| silesia/samba | 21606400 | 22.9 | 1614.1 ±1.3% | 1570.8 ±2.2% | 0.97 |
| silesia/sao | 7251944 | 76.2 | 900.0 ±0.3% | 963.3 ±0.6% | 1.07 |
| silesia/webster | 41458703 | 29.2 | 1041.7 ±1.3% | 987.9 ±2.5% | 0.95 |
| silesia/x-ray | 8474240 | 71.8 | 868.7 ±0.6% | 938.5 ±0.8% | 1.08 |
| silesia/xml | 5345280 | 11.9 | 2173.1 ±0.6% | 2211.9 ±0.5% | 1.02 |
| canterbury/alice29.txt | 152089 | 37.5 | 1035.4 ±0.0% | 1028.8 ±0.1% | 0.99 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1155.9 ±0.1% | 1139.4 ±0.1% | 0.99 |
| canterbury/cp.html | 24603 | 34.4 | 1294.7 ±0.6% | 1339.1 ±0.6% | 1.03 |
| canterbury/fields.c | 11150 | 30.3 | 1093.7 ±0.1% | 1131.6 ±0.1% | 1.03 |
| canterbury/grammar.lsp | 3721 | 34.8 | 813.7 ±0.5% | 825.7 ±0.1% | 1.01 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1356.6 ±0.4% | 1261.9 ±0.3% | 0.93 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1266.8 ±0.3% | 1257.0 ±0.5% | 0.99 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1097.5 ±0.2% | 1071.6 ±0.2% | 0.98 |
| canterbury/ptt5 | 513216 | 10.6 | 2352.4 ±0.3% | 2597.9 ±0.2% | 1.10 |
| canterbury/sum | 38240 | 35.0 | 1322.6 ±0.1% | 1296.8 ±0.2% | 0.98 |
| canterbury/xargs.1 | 4227 | 42.7 | 803.3 ±0.0% | 799.4 ±0.2% | 1.00 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1124.9 ±0.5% | 1067.7 ±0.4% | 0.95 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1129.4 ±0.5% | 1074.4 ±0.3% | 0.95 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1301.1 ±0.6% | 1239.9 ±0.9% | 0.95 |
| http/html-1kx1024 | 1048576 | 39.3 | 468.4 ±0.1% | 452.2 ±0.1% | 0.97 |
| http/html-16kx64 | 1048576 | 21.9 | 1283.6 ±0.2% | 1276.1 ±0.2% | 0.99 |
| http/html-1m | 1048576 | 17.7 | 1676.5 ±0.2% | 1670.3 ±0.2% | 1.00 |
| http/json-1kx1024 | 1048576 | 21.9 | 542.2 ±0.1% | 546.9 ±0.1% | 1.01 |
| http/json-16kx64 | 1048576 | 12.6 | 1668.2 ±0.1% | 1687.7 ±0.1% | 1.01 |
| http/json-1m | 1048576 | 12.2 | 1973.3 ±0.2% | 2078.1 ±0.5% | 1.05 |
| http/js-1kx1024 | 1048576 | 44.5 | 407.7 ±0.1% | 374.9 ±0.1% | 0.92 |
| http/js-16kx64 | 1048576 | 26.0 | 1168.2 ±0.1% | 1148.5 ±0.4% | 0.98 |
| http/js-1m | 1048576 | 19.0 | 1682.0 ±0.2% | 1615.7 ±0.5% | 0.96 |
| http/css-1kx1024 | 1048576 | 29.5 | 494.4 ±0.2% | 495.1 ±0.1% | 1.00 |
| http/css-16kx64 | 1048576 | 15.9 | 1533.0 ±0.3% | 1504.2 ±0.2% | 0.98 |
| http/css-1m | 1048576 | 3.6 | 5115.4 ±0.3% | 4928.9 ±0.2% | 0.96 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1221.1 ±0.2% | 1229.1 ±0.8% | 1.01 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 239.6 ±0.8% | 915.4 ±0.3% | 3.82 |
| silesia/mozilla | 51220480 | 35.6 | 277.4 ±0.2% | 1185.1 ±0.6% | 4.27 |
| silesia/mr | 9970564 | 35.6 | 242.1 ±0.5% | 1094.4 ±1.2% | 4.52 |
| silesia/nci | 33553445 | 8.4 | 677.6 ±0.8% | 1922.2 ±3.8% | 2.84 |
| silesia/ooffice | 6152192 | 50.8 | 193.1 ±0.4% | 1006.7 ±0.3% | 5.21 |
| silesia/osdb | 10085684 | 34.7 | 302.2 ±0.4% | 1386.7 ±1.0% | 4.59 |
| silesia/reymont | 6627202 | 29.2 | 286.3 ±0.9% | 1018.8 ±0.9% | 3.56 |
| silesia/samba | 21606400 | 22.9 | 447.0 ±0.8% | 1573.9 ±1.6% | 3.52 |
| silesia/sao | 7251944 | 76.2 | 163.1 ±0.2% | 959.6 ±1.5% | 5.88 |
| silesia/webster | 41458703 | 29.2 | 283.0 ±0.5% | 1008.5 ±3.7% | 3.56 |
| silesia/x-ray | 8474240 | 71.8 | 152.9 ±0.3% | 942.6 ±0.5% | 6.17 |
| silesia/xml | 5345280 | 11.9 | 626.2 ±0.8% | 2207.4 ±0.8% | 3.53 |
| canterbury/alice29.txt | 152089 | 37.5 | 221.4 ±0.3% | 1029.0 ±0.1% | 4.65 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 207.2 ±0.9% | 1140.0 ±0.1% | 5.50 |
| canterbury/cp.html | 24603 | 34.4 | 253.6 ±0.1% | 1338.5 ±0.1% | 5.28 |
| canterbury/fields.c | 11150 | 30.3 | 250.2 ±0.6% | 1130.5 ±0.3% | 4.52 |
| canterbury/grammar.lsp | 3721 | 34.8 | 214.1 ±0.7% | 825.6 ±0.2% | 3.86 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 296.9 ±0.6% | 1264.3 ±0.4% | 4.26 |
| canterbury/lcet10.txt | 426754 | 33.0 | 266.2 ±0.1% | 1261.3 ±0.4% | 4.74 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 218.6 ±0.9% | 1073.4 ±0.2% | 4.91 |
| canterbury/ptt5 | 513216 | 10.6 | 472.5 ±0.4% | 2579.1 ±1.6% | 5.46 |
| canterbury/sum | 38240 | 35.0 | 249.9 ±0.0% | 1297.6 ±0.1% | 5.19 |
| canterbury/xargs.1 | 4227 | 42.7 | 183.2 ±0.2% | 800.5 ±0.0% | 4.37 |
| canterbury-large/E.coli | 4638690 | 30.0 | 267.1 ±0.4% | 1094.4 ±0.2% | 4.10 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 298.7 ±0.6% | 1105.7 ±0.4% | 3.70 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 331.4 ±0.6% | 1294.8 ±0.8% | 3.91 |
| http/html-1kx1024 | 1048576 | 39.3 | 187.8 ±0.1% | 453.4 ±0.2% | 2.41 |
| http/html-16kx64 | 1048576 | 21.9 | 334.3 ±0.1% | 1281.7 ±0.3% | 3.83 |
| http/html-1m | 1048576 | 17.7 | 450.1 ±0.2% | 1697.8 ±0.9% | 3.77 |
| http/json-1kx1024 | 1048576 | 21.9 | 278.4 ±0.2% | 547.8 ±0.1% | 1.97 |
| http/json-16kx64 | 1048576 | 12.6 | 467.1 ±0.3% | 1698.4 ±0.2% | 3.64 |
| http/json-1m | 1048576 | 12.2 | 525.2 ±0.1% | 2090.2 ±0.5% | 3.98 |
| http/js-1kx1024 | 1048576 | 44.5 | 158.3 ±0.1% | 376.0 ±0.1% | 2.38 |
| http/js-16kx64 | 1048576 | 26.0 | 286.7 ±0.1% | 1155.4 ±0.1% | 4.03 |
| http/js-1m | 1048576 | 19.0 | 428.1 ±0.3% | 1655.2 ±0.5% | 3.87 |
| http/css-1kx1024 | 1048576 | 29.5 | 234.4 ±0.1% | 496.4 ±0.3% | 2.12 |
| http/css-16kx64 | 1048576 | 15.9 | 422.2 ±0.2% | 1507.2 ±0.2% | 3.57 |
| http/css-1m | 1048576 | 3.6 | 1758.8 ±0.4% | 4932.5 ±0.2% | 2.80 |
| shuffled/dickens-1m | 1048576 | 58.8 | 152.6 ±0.3% | 1252.3 ±0.5% | 8.20 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 949.8 ±0.5% | 0.94 ±0.8% | 1.00 ±0.9% | 0.59 ±1.3% | 0.95 ±1.2% | 0.38 ±1.7% |
| silesia/mozilla | 51220480 | 35.6 | 1185.9 ±1.1% | 0.74 ±0.5% | 1.00 ±0.9% | 0.61 ±0.5% | 0.98 ±0.7% | 0.45 ±0.7% |
| silesia/mr | 9970564 | 35.6 | 1120.0 ±0.7% | 0.81 ±0.6% | 1.00 ±0.8% | 0.57 ±0.2% | 0.96 ±1.4% | 0.39 ±1.8% |
| silesia/nci | 33553445 | 8.4 | 1931.5 ±8.0% | 0.95 ±3.5% | 1.02 ±5.0% | 0.70 ±0.3% | 0.99 ±5.2% | 0.48 ±1.2% |
| silesia/ooffice | 6152192 | 50.8 | 1017.5 ±1.1% | 0.62 ±1.3% | 1.00 ±1.1% | 0.58 ±1.2% | 0.98 ±1.1% | 0.45 ±1.6% |
| silesia/osdb | 10085684 | 34.7 | 1426.3 ±0.6% | 0.67 ±0.6% | 1.00 ±0.5% | 0.68 ±0.7% | 0.95 ±1.5% | 0.45 ±0.7% |
| silesia/reymont | 6627202 | 29.2 | 1040.0 ±0.6% | 0.95 ±0.8% | 1.00 ±1.0% | 0.62 ±0.4% | 0.97 ±1.0% | 0.41 ±1.1% |
| silesia/samba | 21606400 | 22.9 | 1592.7 ±1.9% | 0.92 ±1.8% | 1.00 ±2.0% | 0.62 ±1.0% | 0.97 ±1.9% | 0.42 ±1.0% |
| silesia/sao | 7251944 | 76.2 | 964.0 ±1.5% | 0.52 ±1.3% | 1.00 ±2.1% | 0.70 ±1.3% | 0.98 ±0.6% | 0.53 ±1.5% |
| silesia/webster | 41458703 | 29.2 | 1014.2 ±2.1% | 0.92 ±2.5% | 1.00 ±2.4% | 0.63 ±2.0% | 0.97 ±2.6% | 0.42 ±3.2% |
| silesia/x-ray | 8474240 | 71.8 | 946.6 ±1.0% | 0.51 ±1.3% | 1.00 ±1.0% | 0.65 ±0.6% | 0.96 ±1.3% | 0.48 ±0.6% |
| silesia/xml | 5345280 | 11.9 | 2239.3 ±1.0% | 0.92 ±0.9% | 1.00 ±0.6% | 0.61 ±0.6% | 0.99 ±0.5% | 0.41 ±0.9% |
| canterbury/alice29.txt | 152089 | 37.5 | 1028.5 ±0.1% | 0.94 ±0.1% | 1.00 ±0.1% | 0.53 ±0.2% | 0.99 ±0.0% | 0.36 ±0.0% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1139.9 ±0.1% | 0.85 ±0.1% | 0.98 ±0.2% | 0.51 ±0.4% | 0.99 ±0.0% | 0.37 ±0.4% |
| canterbury/cp.html | 24603 | 34.4 | 1342.5 ±0.0% | 0.63 ±0.2% | 1.00 ±0.2% | 0.62 ±0.4% | 0.99 ±0.1% | 0.44 ±0.1% |
| canterbury/fields.c | 11150 | 30.3 | 1132.2 ±0.1% | 0.81 ±0.1% | 1.00 ±0.2% | 0.59 ±0.7% | 0.99 ±0.2% | 0.41 ±0.5% |
| canterbury/grammar.lsp | 3721 | 34.8 | 823.0 ±0.1% | 0.79 ±0.1% | 1.00 ±0.1% | 0.67 ±0.4% | 0.99 ±0.1% | 0.49 ±0.3% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1268.9 ±0.5% | 0.86 ±0.3% | 1.01 ±0.7% | 0.58 ±0.4% | 0.99 ±0.3% | 0.39 ±0.3% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1262.7 ±0.2% | 0.89 ±0.1% | 1.00 ±0.1% | 0.54 ±0.3% | 0.99 ±0.2% | 0.36 ±0.4% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1076.5 ±0.2% | 0.91 ±0.1% | 0.99 ±0.1% | 0.52 ±0.2% | 0.98 ±0.1% | 0.36 ±0.8% |
| canterbury/ptt5 | 513216 | 10.6 | 2561.9 ±0.6% | 0.81 ±1.4% | 1.01 ±1.9% | 0.56 ±0.1% | 1.01 ±2.2% | 0.43 ±0.2% |
| canterbury/sum | 38240 | 35.0 | 1296.6 ±0.2% | 0.64 ±0.1% | 0.99 ±0.2% | 0.62 ±0.3% | 0.99 ±0.0% | 0.45 ±0.1% |
| canterbury/xargs.1 | 4227 | 42.7 | 799.9 ±0.2% | 0.74 ±0.1% | 1.00 ±0.2% | 0.64 ±0.4% | 0.99 ±0.2% | 0.46 ±0.4% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1091.1 ±0.7% | 0.99 ±0.7% | 1.00 ±0.5% | 0.58 ±0.7% | 0.98 ±0.5% | 0.36 ±0.7% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1112.7 ±0.8% | 0.96 ±0.6% | 1.00 ±0.5% | 0.61 ±0.2% | 0.97 ±1.1% | 0.39 ±1.3% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1305.5 ±0.1% | 0.89 ±0.3% | 1.00 ±0.8% | 0.60 ±0.5% | 0.98 ±0.6% | 0.41 ±0.8% |
| http/html-1kx1024 | 1048576 | 39.3 | 453.1 ±0.1% | 0.86 ±0.1% | 1.00 ±0.1% | 0.78 ±0.2% | 0.99 ±0.2% | 0.67 ±0.1% |
| http/html-16kx64 | 1048576 | 21.9 | 1282.7 ±0.4% | 0.83 ±0.4% | 1.00 ±0.4% | 0.63 ±0.1% | 0.99 ±0.2% | 0.46 ±0.1% |
| http/html-1m | 1048576 | 17.7 | 1704.9 ±0.5% | 0.94 ±0.5% | 1.00 ±0.3% | 0.60 ±1.1% | 0.99 ±0.7% | 0.40 ±0.2% |
| http/json-1kx1024 | 1048576 | 21.9 | 546.2 ±0.1% | 0.98 ±0.1% | 1.00 ±0.1% | 0.81 ±0.1% | 0.99 ±0.1% | 0.68 ±0.1% |
| http/json-16kx64 | 1048576 | 12.6 | 1694.3 ±0.4% | 0.85 ±0.2% | 1.00 ±0.1% | 0.64 ±0.1% | 0.99 ±0.3% | 0.47 ±0.2% |
| http/json-1m | 1048576 | 12.2 | 2089.3 ±0.6% | 0.88 ±0.6% | 1.01 ±0.4% | 0.58 ±0.2% | 1.00 ±0.8% | 0.40 ±0.2% |
| http/js-1kx1024 | 1048576 | 44.5 | 375.2 ±0.1% | 0.86 ±0.1% | 1.00 ±0.1% | 0.78 ±0.1% | 0.99 ±0.0% | 0.67 ±0.2% |
| http/js-16kx64 | 1048576 | 26.0 | 1154.0 ±0.4% | 0.82 ±0.3% | 1.00 ±0.4% | 0.61 ±0.2% | 0.99 ±0.2% | 0.45 ±0.5% |
| http/js-1m | 1048576 | 19.0 | 1646.2 ±0.5% | 0.92 ±0.2% | 1.01 ±0.3% | 0.60 ±0.4% | 0.99 ±0.2% | 0.40 ±0.3% |
| http/css-1kx1024 | 1048576 | 29.5 | 495.6 ±0.1% | 0.95 ±0.1% | 1.00 ±0.1% | 0.79 ±0.1% | 0.99 ±0.1% | 0.66 ±0.1% |
| http/css-16kx64 | 1048576 | 15.9 | 1505.7 ±0.3% | 0.89 ±0.2% | 1.00 ±0.4% | 0.65 ±0.1% | 0.99 ±0.1% | 0.45 ±0.1% |
| http/css-1m | 1048576 | 3.6 | 4923.2 ±0.5% | 0.95 ±1.0% | 1.01 ±1.1% | 0.70 ±0.6% | 1.00 ±0.5% | 0.46 ±0.4% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1244.8 ±0.4% | 0.52 ±0.5% | 0.86 ±0.6% | 0.74 ±0.5% | 0.98 ±0.3% | 0.56 ±0.3% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 335.0 ± 0.3% | 138.1 ± 0.7% | 0.41 |
| silesia/dickens | 10192446 | 3 | 149.4 ± 1.0% | 93.4 ± 0.4% | 0.63 |
| silesia/mozilla | 51220480 | 1 | 480.7 ± 0.6% | 191.2 ± 0.1% | 0.40 |
| silesia/mozilla | 51220480 | 3 | 200.0 ± 0.4% | 109.8 ± 0.2% | 0.55 |
| silesia/mr | 9970564 | 1 | 437.5 ± 0.4% | 168.3 ± 0.6% | 0.38 |
| silesia/mr | 9970564 | 3 | 169.7 ± 0.5% | 97.1 ± 1.1% | 0.57 |
| silesia/nci | 33553445 | 1 | 954.9 ± 0.3% | 436.4 ± 0.5% | 0.46 |
| silesia/nci | 33553445 | 3 | 620.8 ± 0.5% | 305.9 ± 0.6% | 0.49 |
| silesia/ooffice | 6152192 | 1 | 395.2 ± 0.3% | 145.7 ± 0.5% | 0.37 |
| silesia/ooffice | 6152192 | 3 | 143.2 ± 0.3% | 79.4 ± 0.3% | 0.55 |
| silesia/osdb | 10085684 | 1 | 479.1 ± 0.4% | 205.0 ± 0.1% | 0.43 |
| silesia/osdb | 10085684 | 3 | 188.7 ± 0.7% | 105.5 ± 0.6% | 0.56 |
| silesia/reymont | 6627202 | 1 | 348.4 ± 0.2% | 166.7 ± 0.3% | 0.48 |
| silesia/reymont | 6627202 | 3 | 183.5 ± 0.7% | 119.7 ± 1.0% | 0.65 |
| silesia/samba | 21606400 | 1 | 568.0 ± 0.3% | 248.8 ± 0.4% | 0.44 |
| silesia/samba | 21606400 | 3 | 283.3 ± 0.7% | 166.2 ± 0.7% | 0.59 |
| silesia/sao | 7251944 | 1 | 372.9 ± 0.4% | 129.7 ± 1.3% | 0.35 |
| silesia/sao | 7251944 | 3 | 109.2 ± 0.4% | 65.1 ± 0.5% | 0.60 |
| silesia/webster | 41458703 | 1 | 391.3 ± 0.4% | 165.3 ± 0.2% | 0.42 |
| silesia/webster | 41458703 | 3 | 177.3 ± 0.3% | 108.9 ± 0.5% | 0.61 |
| silesia/x-ray | 8474240 | 1 | 715.9 ± 0.5% | 141.1 ± 0.6% | 0.20 |
| silesia/x-ray | 8474240 | 3 | 107.3 ± 0.6% | 70.2 ± 0.5% | 0.65 |
| silesia/xml | 5345280 | 1 | 801.0 ± 0.7% | 325.5 ± 1.7% | 0.41 |
| silesia/xml | 5345280 | 3 | 505.0 ± 0.8% | 264.3 ± 0.5% | 0.52 |
| canterbury/alice29.txt | 152089 | 1 | 314.4 ± 0.2% | 150.1 ± 0.3% | 0.48 |
| canterbury/alice29.txt | 152089 | 3 | 212.1 ± 0.6% | 125.5 ± 0.5% | 0.59 |
| canterbury/asyoulik.txt | 125179 | 1 | 348.4 ± 0.1% | 142.7 ± 0.5% | 0.41 |
| canterbury/asyoulik.txt | 125179 | 3 | 221.9 ± 0.6% | 117.4 ± 0.5% | 0.53 |
| canterbury/cp.html | 24603 | 1 | 493.7 ± 0.7% | 211.8 ± 0.2% | 0.43 |
| canterbury/cp.html | 24603 | 3 | 350.0 ± 0.5% | 188.0 ± 0.3% | 0.54 |
| canterbury/fields.c | 11150 | 1 | 391.4 ± 0.3% | 201.2 ± 0.5% | 0.51 |
| canterbury/fields.c | 11150 | 3 | 364.7 ± 0.8% | 195.6 ± 0.4% | 0.54 |
| canterbury/grammar.lsp | 3721 | 1 | 355.7 ± 1.0% | 169.1 ± 0.4% | 0.48 |
| canterbury/grammar.lsp | 3721 | 3 | 318.6 ± 0.2% | 158.5 ± 0.3% | 0.50 |
| canterbury/kennedy.xls | 1029744 | 1 | 560.2 ± 0.5% | 228.5 ± 0.3% | 0.41 |
| canterbury/kennedy.xls | 1029744 | 3 | 399.6 ± 0.2% | 164.0 ± 0.3% | 0.41 |
| canterbury/lcet10.txt | 426754 | 1 | 344.0 ± 0.2% | 157.3 ± 0.1% | 0.46 |
| canterbury/lcet10.txt | 426754 | 3 | 208.0 ± 0.6% | 125.8 ± 0.6% | 0.60 |
| canterbury/plrabn12.txt | 481861 | 1 | 327.3 ± 0.3% | 133.3 ± 0.5% | 0.41 |
| canterbury/plrabn12.txt | 481861 | 3 | 170.5 ± 0.7% | 104.1 ± 0.5% | 0.61 |
| canterbury/ptt5 | 513216 | 1 | 1079.6 ± 0.2% | 447.8 ± 0.5% | 0.41 |
| canterbury/ptt5 | 513216 | 3 | 695.3 ± 0.6% | 350.9 ± 0.5% | 0.50 |
| canterbury/sum | 38240 | 1 | 523.8 ± 0.3% | 202.0 ± 0.2% | 0.39 |
| canterbury/sum | 38240 | 3 | 372.1 ± 0.6% | 171.2 ± 0.8% | 0.46 |
| canterbury/xargs.1 | 4227 | 1 | 338.3 ± 0.6% | 163.1 ± 0.5% | 0.48 |
| canterbury/xargs.1 | 4227 | 3 | 278.3 ± 0.4% | 148.6 ± 0.2% | 0.53 |
| canterbury-large/E.coli | 4638690 | 1 | 323.5 ± 0.7% | 151.5 ± 1.7% | 0.47 |
| canterbury-large/E.coli | 4638690 | 3 | 218.2 ± 0.8% | 141.8 ± 0.4% | 0.65 |
| canterbury-large/bible.txt | 4047392 | 1 | 347.2 ± 0.4% | 165.0 ± 0.4% | 0.48 |
| canterbury-large/bible.txt | 4047392 | 3 | 184.7 ± 0.7% | 119.6 ± 0.6% | 0.65 |
| canterbury-large/world192.txt | 2473400 | 1 | 415.9 ± 0.2% | 181.1 ± 0.4% | 0.44 |
| canterbury-large/world192.txt | 2473400 | 3 | 214.7 ± 1.2% | 132.4 ± 1.0% | 0.62 |
| http/html-1kx1024 | 1048576 | 1 | 198.7 ± 0.0% | 94.7 ± 0.1% | 0.48 |
| http/html-1kx1024 | 1048576 | 3 | 178.4 ± 0.1% | 88.5 ± 0.3% | 0.50 |
| http/html-16kx64 | 1048576 | 1 | 440.0 ± 0.2% | 239.0 ± 0.4% | 0.54 |
| http/html-16kx64 | 1048576 | 3 | 385.7 ± 0.3% | 217.2 ± 0.5% | 0.56 |
| http/html-1m | 1048576 | 1 | 542.4 ± 0.5% | 260.0 ± 0.5% | 0.48 |
| http/html-1m | 1048576 | 3 | 364.1 ± 0.4% | 210.4 ± 0.4% | 0.58 |
| http/json-1kx1024 | 1048576 | 1 | 237.2 ± 0.4% | 114.9 ± 0.2% | 0.48 |
| http/json-1kx1024 | 1048576 | 3 | 229.3 ± 0.1% | 109.8 ± 0.3% | 0.48 |
| http/json-16kx64 | 1048576 | 1 | 707.8 ± 0.1% | 349.0 ± 0.1% | 0.49 |
| http/json-16kx64 | 1048576 | 3 | 632.4 ± 0.2% | 319.5 ± 0.3% | 0.51 |
| http/json-1m | 1048576 | 1 | 832.4 ± 0.4% | 373.1 ± 0.8% | 0.45 |
| http/json-1m | 1048576 | 3 | 544.4 ± 0.8% | 292.7 ± 0.3% | 0.54 |
| http/js-1kx1024 | 1048576 | 1 | 182.6 ± 0.1% | 85.0 ± 0.3% | 0.47 |
| http/js-1kx1024 | 1048576 | 3 | 158.6 ± 0.2% | 79.2 ± 0.6% | 0.50 |
| http/js-16kx64 | 1048576 | 1 | 383.8 ± 0.1% | 203.7 ± 0.4% | 0.53 |
| http/js-16kx64 | 1048576 | 3 | 335.6 ± 0.3% | 188.0 ± 0.7% | 0.56 |
| http/js-1m | 1048576 | 1 | 516.3 ± 0.4% | 241.1 ± 0.2% | 0.47 |
| http/js-1m | 1048576 | 3 | 334.6 ± 0.4% | 195.1 ± 1.0% | 0.58 |
| http/css-1kx1024 | 1048576 | 1 | 218.3 ± 0.1% | 105.0 ± 0.2% | 0.48 |
| http/css-1kx1024 | 1048576 | 3 | 204.3 ± 0.2% | 99.8 ± 0.3% | 0.49 |
| http/css-16kx64 | 1048576 | 1 | 553.2 ± 0.1% | 273.1 ± 0.1% | 0.49 |
| http/css-16kx64 | 1048576 | 3 | 516.4 ± 0.2% | 258.6 ± 0.5% | 0.50 |
| http/css-1m | 1048576 | 1 | 2298.7 ± 0.3% | 849.7 ± 0.7% | 0.37 |
| http/css-1m | 1048576 | 3 | 1728.5 ± 0.7% | 850.5 ± 0.2% | 0.49 |
| shuffled/dickens-1m | 1048576 | 1 | 965.5 ± 0.2% | 369.1 ± 0.5% | 0.38 |
| shuffled/dickens-1m | 1048576 | 3 | 119.4 ± 0.6% | 158.5 ± 0.5% | 1.33 |

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
| silesia/dickens | 10192446 | 35.9 | 955.4 ±0.7% | 913.1 ±0.4% | 0.96 |
| silesia/mozilla | 51220480 | 35.6 | 1180.7 ±0.6% | 1182.4 ±0.6% | 1.00 |
| silesia/mr | 9970564 | 35.6 | 1118.2 ±0.8% | 1087.1 ±0.3% | 0.97 |
| silesia/nci | 33553445 | 8.4 | 1958.4 ±1.4% | 1908.9 ±3.3% | 0.97 |
| silesia/ooffice | 6152192 | 50.8 | 1003.3 ±1.5% | 1006.2 ±1.1% | 1.00 |
| silesia/osdb | 10085684 | 34.7 | 1424.9 ±1.2% | 1371.4 ±0.5% | 0.96 |
| silesia/reymont | 6627202 | 29.2 | 1048.9 ±0.2% | 1003.7 ±0.7% | 0.96 |
| silesia/samba | 21606400 | 22.9 | 1587.1 ±1.2% | 1558.2 ±1.8% | 0.98 |
| silesia/sao | 7251944 | 76.2 | 888.7 ±1.0% | 960.5 ±0.3% | 1.08 |
| silesia/webster | 41458703 | 29.2 | 1016.9 ±0.6% | 981.6 ±1.9% | 0.97 |
| silesia/x-ray | 8474240 | 71.8 | 855.3 ±0.7% | 931.1 ±0.1% | 1.09 |
| silesia/xml | 5345280 | 11.9 | 2140.5 ±0.5% | 2210.8 ±0.3% | 1.03 |
| canterbury/alice29.txt | 152089 | 37.5 | 1030.1 ±0.2% | 1025.3 ±0.1% | 1.00 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1154.4 ±0.1% | 1132.8 ±0.1% | 0.98 |
| canterbury/cp.html | 24603 | 34.4 | 1294.6 ±0.3% | 1332.2 ±0.1% | 1.03 |
| canterbury/fields.c | 11150 | 30.3 | 1094.2 ±0.1% | 1117.4 ±0.2% | 1.02 |
| canterbury/grammar.lsp | 3721 | 34.8 | 811.7 ±0.2% | 823.5 ±0.1% | 1.01 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1345.9 ±0.4% | 1260.3 ±0.3% | 0.94 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1259.4 ±0.4% | 1247.5 ±0.5% | 0.99 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1095.1 ±0.6% | 1067.0 ±0.2% | 0.97 |
| canterbury/ptt5 | 513216 | 10.6 | 2306.7 ±0.1% | 2577.0 ±0.5% | 1.12 |
| canterbury/sum | 38240 | 35.0 | 1311.4 ±0.2% | 1292.2 ±0.1% | 0.99 |
| canterbury/xargs.1 | 4227 | 42.7 | 803.4 ±0.1% | 798.8 ±0.2% | 0.99 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1117.2 ±0.2% | 1063.9 ±0.5% | 0.95 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1114.6 ±0.6% | 1077.2 ±0.7% | 0.97 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1274.0 ±0.5% | 1266.5 ±0.5% | 0.99 |
| http/html-1kx1024 | 1048576 | 39.3 | 467.0 ±0.1% | 477.7 ±0.0% | 1.02 |
| http/html-16kx64 | 1048576 | 21.9 | 1265.0 ±0.2% | 1274.7 ±0.4% | 1.01 |
| http/html-1m | 1048576 | 17.7 | 1648.9 ±0.4% | 1677.7 ±0.3% | 1.02 |
| http/json-1kx1024 | 1048576 | 21.9 | 541.1 ±0.1% | 572.1 ±0.1% | 1.06 |
| http/json-16kx64 | 1048576 | 12.6 | 1647.4 ±0.1% | 1696.5 ±0.1% | 1.03 |
| http/json-1m | 1048576 | 12.2 | 1943.8 ±0.3% | 2080.4 ±0.3% | 1.07 |
| http/js-1kx1024 | 1048576 | 44.5 | 407.2 ±0.1% | 390.8 ±0.1% | 0.96 |
| http/js-16kx64 | 1048576 | 26.0 | 1154.1 ±0.2% | 1147.8 ±0.4% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1638.0 ±0.6% | 1613.4 ±0.6% | 0.98 |
| http/css-1kx1024 | 1048576 | 29.5 | 493.5 ±0.1% | 519.0 ±0.1% | 1.05 |
| http/css-16kx64 | 1048576 | 15.9 | 1512.9 ±0.2% | 1509.3 ±0.1% | 1.00 |
| http/css-1m | 1048576 | 3.6 | 5093.0 ±0.5% | 4879.5 ±0.5% | 0.96 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1218.3 ±0.5% | 1233.0 ±0.4% | 1.01 |
