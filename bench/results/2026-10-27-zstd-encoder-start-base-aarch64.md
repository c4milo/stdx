# bench-zstd

| Field | Value |
|---|---|
| Commit | 087c201 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261023.149.3 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/40535059200 |
| Date | 2026-10-27 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 913.9 ±1.1% | 880.5 ±1.2% | 0.96 |
| silesia/mozilla | 51220480 | 35.6 | 1164.6 ±0.6% | 1151.4 ±0.7% | 0.99 |
| silesia/mr | 9970564 | 35.6 | 1083.1 ±0.2% | 1056.9 ±1.2% | 0.98 |
| silesia/nci | 33553445 | 8.4 | 1958.5 ±2.9% | 1828.7 ±3.6% | 0.93 |
| silesia/ooffice | 6152192 | 50.8 | 981.3 ±0.4% | 991.6 ±0.3% | 1.01 |
| silesia/osdb | 10085684 | 34.7 | 1383.5 ±0.8% | 1344.1 ±1.4% | 0.97 |
| silesia/reymont | 6627202 | 29.2 | 1012.0 ±0.4% | 971.4 ±0.5% | 0.96 |
| silesia/samba | 21606400 | 22.9 | 1554.1 ±12.2% | 1482.0 ±8.0% | 0.95 |
| silesia/sao | 7251944 | 76.2 | 873.8 ±0.7% | 946.4 ±0.5% | 1.08 |
| silesia/webster | 41458703 | 29.2 | 999.6 ±1.2% | 941.1 ±1.8% | 0.94 |
| silesia/x-ray | 8474240 | 71.8 | 847.5 ±1.1% | 937.5 ±1.3% | 1.11 |
| silesia/xml | 5345280 | 11.9 | 2148.8 ±0.4% | 2178.5 ±0.8% | 1.01 |
| canterbury/alice29.txt | 152089 | 37.5 | 1015.7 ±0.2% | 1029.0 ±0.2% | 1.01 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1132.3 ±0.2% | 1139.3 ±0.2% | 1.01 |
| canterbury/cp.html | 24603 | 34.4 | 1269.6 ±0.2% | 1340.7 ±0.4% | 1.06 |
| canterbury/fields.c | 11150 | 30.3 | 1081.8 ±0.1% | 1131.3 ±0.1% | 1.05 |
| canterbury/grammar.lsp | 3721 | 34.8 | 796.6 ±1.1% | 823.9 ±0.3% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1357.8 ±0.5% | 1259.6 ±0.7% | 0.93 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1245.8 ±0.1% | 1256.8 ±0.8% | 1.01 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1067.2 ±0.5% | 1056.6 ±0.3% | 0.99 |
| canterbury/ptt5 | 513216 | 10.6 | 2365.5 ±0.2% | 2537.6 ±2.3% | 1.07 |
| canterbury/sum | 38240 | 35.0 | 1275.9 ±0.5% | 1293.9 ±0.3% | 1.01 |
| canterbury/xargs.1 | 4227 | 42.7 | 791.0 ±0.1% | 797.6 ±0.1% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1091.9 ±0.5% | 1064.2 ±3.7% | 0.97 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1097.2 ±0.5% | 1065.4 ±0.6% | 0.97 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1295.9 ±0.7% | 1255.6 ±0.4% | 0.97 |
| http/html-1kx1024 | 1048576 | 39.3 | 457.6 ±0.4% | 453.2 ±0.1% | 0.99 |
| http/html-16kx64 | 1048576 | 21.9 | 1275.3 ±0.3% | 1272.1 ±0.2% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1689.5 ±0.3% | 1684.5 ±0.7% | 1.00 |
| http/json-1kx1024 | 1048576 | 21.9 | 530.1 ±0.1% | 543.1 ±0.2% | 1.02 |
| http/json-16kx64 | 1048576 | 12.6 | 1654.2 ±0.2% | 1678.8 ±0.4% | 1.01 |
| http/json-1m | 1048576 | 12.2 | 1949.3 ±0.7% | 2064.1 ±0.6% | 1.06 |
| http/js-1kx1024 | 1048576 | 44.5 | 399.9 ±0.1% | 373.8 ±0.1% | 0.93 |
| http/js-16kx64 | 1048576 | 26.0 | 1158.9 ±0.2% | 1144.1 ±0.6% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1664.0 ±0.7% | 1532.2 ±0.5% | 0.92 |
| http/css-1kx1024 | 1048576 | 29.5 | 481.7 ±0.1% | 494.5 ±0.3% | 1.03 |
| http/css-16kx64 | 1048576 | 15.9 | 1513.8 ±0.1% | 1501.5 ±0.2% | 0.99 |
| http/css-1m | 1048576 | 3.6 | 5089.1 ±0.3% | 4803.3 ±0.9% | 0.94 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1189.3 ±0.2% | 1233.0 ±0.4% | 1.04 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 234.7 ±2.6% | 900.5 ±2.6% | 3.84 |
| silesia/mozilla | 51220480 | 35.6 | 276.8 ±1.0% | 1149.4 ±1.7% | 4.15 |
| silesia/mr | 9970564 | 35.6 | 241.7 ±1.5% | 1076.4 ±0.8% | 4.45 |
| silesia/nci | 33553445 | 8.4 | 667.2 ±1.0% | 1785.9 ±2.7% | 2.68 |
| silesia/ooffice | 6152192 | 50.8 | 193.3 ±0.3% | 977.6 ±1.2% | 5.06 |
| silesia/osdb | 10085684 | 34.7 | 300.4 ±1.9% | 1374.2 ±12.9% | 4.57 |
| silesia/reymont | 6627202 | 29.2 | 281.5 ±3.7% | 994.8 ±0.7% | 3.53 |
| silesia/samba | 21606400 | 22.9 | 443.2 ±1.3% | 1458.7 ±2.8% | 3.29 |
| silesia/sao | 7251944 | 76.2 | 163.3 ±0.3% | 939.2 ±1.2% | 5.75 |
| silesia/webster | 41458703 | 29.2 | 275.8 ±7.4% | 945.5 ±9.7% | 3.43 |
| silesia/x-ray | 8474240 | 71.8 | 152.9 ±0.1% | 925.8 ±0.8% | 6.06 |
| silesia/xml | 5345280 | 11.9 | 624.3 ±1.2% | 2185.3 ±2.8% | 3.50 |
| canterbury/alice29.txt | 152089 | 37.5 | 223.2 ±0.4% | 1028.8 ±0.2% | 4.61 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 208.3 ±0.2% | 1140.0 ±0.2% | 5.47 |
| canterbury/cp.html | 24603 | 34.4 | 254.4 ±0.2% | 1334.3 ±0.1% | 5.25 |
| canterbury/fields.c | 11150 | 30.3 | 251.1 ±0.4% | 1131.0 ±0.3% | 4.50 |
| canterbury/grammar.lsp | 3721 | 34.8 | 215.0 ±0.5% | 825.5 ±0.1% | 3.84 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 298.4 ±0.3% | 1260.4 ±0.3% | 4.22 |
| canterbury/lcet10.txt | 426754 | 33.0 | 267.9 ±0.2% | 1261.8 ±0.3% | 4.71 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 220.2 ±0.7% | 1073.8 ±0.3% | 4.88 |
| canterbury/ptt5 | 513216 | 10.6 | 475.0 ±0.1% | 2579.1 ±1.1% | 5.43 |
| canterbury/sum | 38240 | 35.0 | 250.5 ±0.3% | 1297.3 ±0.1% | 5.18 |
| canterbury/xargs.1 | 4227 | 42.7 | 182.6 ±0.2% | 794.9 ±0.1% | 4.35 |
| canterbury-large/E.coli | 4638690 | 30.0 | 261.7 ±2.4% | 1072.2 ±0.7% | 4.10 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 291.7 ±3.4% | 1057.9 ±2.0% | 3.63 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 328.9 ±1.0% | 1274.8 ±0.7% | 3.88 |
| http/html-1kx1024 | 1048576 | 39.3 | 187.6 ±0.4% | 453.6 ±0.1% | 2.42 |
| http/html-16kx64 | 1048576 | 21.9 | 335.8 ±0.3% | 1282.9 ±0.5% | 3.82 |
| http/html-1m | 1048576 | 17.7 | 453.8 ±0.4% | 1701.2 ±0.8% | 3.75 |
| http/json-1kx1024 | 1048576 | 21.9 | 279.2 ±0.6% | 544.9 ±0.2% | 1.95 |
| http/json-16kx64 | 1048576 | 12.6 | 469.8 ±0.2% | 1697.5 ±0.7% | 3.61 |
| http/json-1m | 1048576 | 12.2 | 528.8 ±0.4% | 2083.0 ±0.5% | 3.94 |
| http/js-1kx1024 | 1048576 | 44.5 | 158.3 ±0.2% | 375.3 ±0.2% | 2.37 |
| http/js-16kx64 | 1048576 | 26.0 | 286.6 ±0.5% | 1153.7 ±0.6% | 4.03 |
| http/js-1m | 1048576 | 19.0 | 428.5 ±0.7% | 1628.0 ±0.8% | 3.80 |
| http/css-1kx1024 | 1048576 | 29.5 | 234.5 ±0.1% | 491.9 ±0.2% | 2.10 |
| http/css-16kx64 | 1048576 | 15.9 | 423.6 ±0.3% | 1498.6 ±0.5% | 3.54 |
| http/css-1m | 1048576 | 3.6 | 1770.8 ±0.6% | 4822.0 ±0.6% | 2.72 |
| shuffled/dickens-1m | 1048576 | 58.8 | 152.1 ±0.4% | 1244.3 ±0.4% | 8.18 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 919.8 ±1.6% | 0.93 ±3.4% | 0.99 ±0.9% | 0.59 ±1.3% | 0.95 ±1.1% | 0.38 ±1.6% |
| silesia/mozilla | 51220480 | 35.6 | 1150.7 ±0.9% | 0.76 ±0.7% | 1.01 ±2.3% | 0.62 ±4.0% | 1.00 ±0.9% | 0.46 ±0.7% |
| silesia/mr | 9970564 | 35.6 | 1086.9 ±1.2% | 0.81 ±2.6% | 1.00 ±1.0% | 0.56 ±2.5% | 0.96 ±4.0% | 0.39 ±1.4% |
| silesia/nci | 33553445 | 8.4 | 1779.8 ±6.6% | 0.94 ±4.2% | 1.02 ±6.7% | 0.73 ±4.5% | 1.01 ±3.1% | 0.51 ±1.6% |
| silesia/ooffice | 6152192 | 50.8 | 987.0 ±2.2% | 0.63 ±0.6% | 1.01 ±4.9% | 0.59 ±0.9% | 0.99 ±1.4% | 0.45 ±0.6% |
| silesia/osdb | 10085684 | 34.7 | 1384.4 ±2.3% | 0.67 ±1.6% | 1.00 ±2.4% | 0.69 ±1.0% | 0.96 ±2.2% | 0.46 ±0.3% |
| silesia/reymont | 6627202 | 29.2 | 1002.1 ±1.2% | 0.95 ±0.6% | 1.00 ±0.6% | 0.63 ±0.5% | 0.96 ±4.1% | 0.40 ±4.5% |
| silesia/samba | 21606400 | 22.9 | 1438.5 ±7.1% | 0.94 ±1.8% | 1.02 ±1.1% | 0.67 ±1.3% | 1.01 ±2.9% | 0.45 ±1.9% |
| silesia/sao | 7251944 | 76.2 | 928.5 ±2.6% | 0.52 ±1.0% | 1.00 ±7.0% | 0.70 ±1.3% | 0.97 ±6.0% | 0.53 ±2.6% |
| silesia/webster | 41458703 | 29.2 | 928.5 ±1.9% | 0.94 ±1.3% | 1.01 ±2.0% | 0.65 ±3.4% | 0.97 ±4.8% | 0.43 ±3.3% |
| silesia/x-ray | 8474240 | 71.8 | 915.1 ±3.4% | 0.52 ±0.9% | 1.00 ±4.0% | 0.66 ±3.9% | 0.96 ±2.0% | 0.49 ±0.8% |
| silesia/xml | 5345280 | 11.9 | 2169.7 ±1.0% | 0.93 ±0.9% | 1.00 ±5.1% | 0.62 ±0.7% | 0.99 ±5.0% | 0.41 ±1.1% |
| canterbury/alice29.txt | 152089 | 37.5 | 1029.0 ±0.2% | 0.94 ±0.3% | 1.00 ±0.1% | 0.53 ±0.2% | 0.99 ±0.2% | 0.36 ±1.0% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1139.1 ±0.2% | 0.85 ±0.1% | 0.98 ±0.1% | 0.51 ±0.1% | 0.99 ±0.1% | 0.37 ±0.6% |
| canterbury/cp.html | 24603 | 34.4 | 1342.1 ±0.1% | 0.63 ±0.2% | 1.00 ±0.3% | 0.63 ±0.5% | 0.98 ±0.1% | 0.44 ±0.2% |
| canterbury/fields.c | 11150 | 30.3 | 1133.6 ±0.2% | 0.81 ±0.2% | 1.00 ±0.2% | 0.60 ±0.2% | 0.99 ±0.0% | 0.41 ±0.3% |
| canterbury/grammar.lsp | 3721 | 34.8 | 826.2 ±0.2% | 0.79 ±0.2% | 1.00 ±0.3% | 0.67 ±0.3% | 0.99 ±0.1% | 0.48 ±0.1% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1262.1 ±0.8% | 0.87 ±0.3% | 1.01 ±0.5% | 0.58 ±0.8% | 1.00 ±0.5% | 0.39 ±0.4% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1264.0 ±0.2% | 0.89 ±0.3% | 1.00 ±0.1% | 0.54 ±0.1% | 0.99 ±0.2% | 0.35 ±0.3% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1072.2 ±0.2% | 0.91 ±0.4% | 1.00 ±0.8% | 0.52 ±0.1% | 0.99 ±0.3% | 0.36 ±0.6% |
| canterbury/ptt5 | 513216 | 10.6 | 2560.0 ±0.4% | 0.81 ±1.4% | 1.01 ±2.7% | 0.56 ±0.1% | 1.01 ±2.0% | 0.43 ±0.4% |
| canterbury/sum | 38240 | 35.0 | 1296.6 ±0.1% | 0.64 ±0.1% | 1.00 ±0.1% | 0.64 ±0.6% | 0.99 ±0.2% | 0.45 ±0.3% |
| canterbury/xargs.1 | 4227 | 42.7 | 797.8 ±0.2% | 0.74 ±0.1% | 1.00 ±0.3% | 0.64 ±0.2% | 0.99 ±0.3% | 0.46 ±0.2% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1087.5 ±0.7% | 0.98 ±0.4% | 1.00 ±1.2% | 0.58 ±0.6% | 0.97 ±1.2% | 0.36 ±0.6% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1081.3 ±4.1% | 0.97 ±0.6% | 1.01 ±0.7% | 0.62 ±0.5% | 0.98 ±0.7% | 0.39 ±0.7% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1283.0 ±1.0% | 0.90 ±0.4% | 1.00 ±0.4% | 0.61 ±0.5% | 0.98 ±0.6% | 0.41 ±0.9% |
| http/html-1kx1024 | 1048576 | 39.3 | 455.1 ±0.1% | 0.86 ±0.2% | 1.00 ±0.2% | 0.79 ±0.1% | 0.99 ±0.1% | 0.66 ±0.3% |
| http/html-16kx64 | 1048576 | 21.9 | 1282.2 ±0.4% | 0.83 ±0.2% | 1.00 ±0.3% | 0.62 ±0.2% | 0.99 ±3.7% | 0.46 ±0.4% |
| http/html-1m | 1048576 | 17.7 | 1691.6 ±1.9% | 0.94 ±0.7% | 1.00 ±1.1% | 0.60 ±0.9% | 0.99 ±0.8% | 0.40 ±1.2% |
| http/json-1kx1024 | 1048576 | 21.9 | 545.9 ±0.2% | 0.98 ±0.1% | 1.00 ±0.2% | 0.81 ±0.1% | 0.99 ±0.1% | 0.68 ±0.2% |
| http/json-16kx64 | 1048576 | 12.6 | 1686.6 ±0.3% | 0.85 ±0.3% | 1.00 ±0.2% | 0.64 ±0.3% | 0.99 ±0.9% | 0.47 ±0.3% |
| http/json-1m | 1048576 | 12.2 | 2084.3 ±0.7% | 0.88 ±1.0% | 1.00 ±0.8% | 0.59 ±0.5% | 0.99 ±0.5% | 0.40 ±0.4% |
| http/js-1kx1024 | 1048576 | 44.5 | 376.2 ±0.1% | 0.86 ±0.2% | 0.99 ±0.1% | 0.78 ±0.1% | 0.99 ±0.1% | 0.67 ±0.3% |
| http/js-16kx64 | 1048576 | 26.0 | 1154.9 ±0.4% | 0.82 ±0.2% | 1.00 ±0.3% | 0.61 ±0.2% | 0.99 ±0.2% | 0.45 ±0.6% |
| http/js-1m | 1048576 | 19.0 | 1644.3 ±0.3% | 0.91 ±0.4% | 1.00 ±0.3% | 0.60 ±0.4% | 0.99 ±0.5% | 0.40 ±0.5% |
| http/css-1kx1024 | 1048576 | 29.5 | 495.7 ±0.2% | 0.94 ±0.1% | 1.00 ±0.1% | 0.79 ±0.1% | 0.99 ±0.3% | 0.66 ±0.1% |
| http/css-16kx64 | 1048576 | 15.9 | 1503.5 ±0.5% | 0.89 ±0.5% | 1.00 ±0.4% | 0.65 ±0.2% | 0.99 ±0.5% | 0.45 ±0.2% |
| http/css-1m | 1048576 | 3.6 | 4857.1 ±0.4% | 0.95 ±0.7% | 1.00 ±0.4% | 0.71 ±0.5% | 0.98 ±1.0% | 0.46 ±0.4% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1236.9 ±2.3% | 0.52 ±0.4% | 0.86 ±0.4% | 0.75 ±0.5% | 0.97 ±0.3% | 0.56 ±0.6% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 332.5 ± 0.3% | 83.1 ± 0.6% | 0.25 |
| silesia/dickens | 10192446 | 3 | 136.2 ± 0.6% | 54.9 ± 0.5% | 0.40 |
| silesia/mozilla | 51220480 | 1 | 479.3 ± 1.4% | 117.4 ± 0.1% | 0.24 |
| silesia/mozilla | 51220480 | 3 | 175.4 ± 2.1% | 60.3 ± 2.8% | 0.34 |
| silesia/mr | 9970564 | 1 | 439.4 ± 0.3% | 103.0 ± 0.1% | 0.23 |
| silesia/mr | 9970564 | 3 | 150.5 ± 1.2% | 58.4 ± 1.9% | 0.39 |
| silesia/nci | 33553445 | 1 | 948.8 ± 0.3% | 215.4 ± 0.5% | 0.23 |
| silesia/nci | 33553445 | 3 | 580.2 ± 0.6% | 109.4 ± 1.8% | 0.19 |
| silesia/ooffice | 6152192 | 1 | 393.0 ± 0.3% | 93.9 ± 0.2% | 0.24 |
| silesia/ooffice | 6152192 | 3 | 125.3 ± 2.6% | 52.5 ± 5.9% | 0.42 |
| silesia/osdb | 10085684 | 1 | 472.8 ± 0.7% | 124.8 ± 1.8% | 0.26 |
| silesia/osdb | 10085684 | 3 | 167.8 ± 1.4% | 63.0 ± 0.8% | 0.38 |
| silesia/reymont | 6627202 | 1 | 343.9 ± 0.2% | 98.5 ± 0.3% | 0.29 |
| silesia/reymont | 6627202 | 3 | 169.5 ± 7.2% | 68.1 ± 0.6% | 0.40 |
| silesia/samba | 21606400 | 1 | 560.5 ± 1.4% | 141.7 ± 2.2% | 0.25 |
| silesia/samba | 21606400 | 3 | 255.7 ± 3.1% | 79.7 ± 2.0% | 0.31 |
| silesia/sao | 7251944 | 1 | 371.4 ± 0.4% | 85.2 ± 0.5% | 0.23 |
| silesia/sao | 7251944 | 3 | 93.3 ± 0.7% | 44.2 ± 0.7% | 0.47 |
| silesia/webster | 41458703 | 1 | 386.6 ± 0.3% | 99.8 ± 0.2% | 0.26 |
| silesia/webster | 41458703 | 3 | 160.1 ± 0.7% | 58.8 ± 1.0% | 0.37 |
| silesia/x-ray | 8474240 | 1 | 703.6 ± 0.8% | 90.2 ± 0.3% | 0.13 |
| silesia/x-ray | 8474240 | 3 | 91.6 ± 6.5% | 45.9 ± 0.5% | 0.50 |
| silesia/xml | 5345280 | 1 | 789.2 ± 0.3% | 179.4 ± 0.4% | 0.23 |
| silesia/xml | 5345280 | 3 | 459.8 ± 5.8% | 124.8 ± 1.1% | 0.27 |
| canterbury/alice29.txt | 152089 | 1 | 310.5 ± 0.2% | 101.9 ± 0.1% | 0.33 |
| canterbury/alice29.txt | 152089 | 3 | 212.6 ± 1.2% | 90.9 ± 0.8% | 0.43 |
| canterbury/asyoulik.txt | 125179 | 1 | 346.8 ± 0.2% | 95.8 ± 0.2% | 0.28 |
| canterbury/asyoulik.txt | 125179 | 3 | 211.5 ± 0.9% | 87.6 ± 0.5% | 0.41 |
| canterbury/cp.html | 24603 | 1 | 483.7 ± 0.5% | 137.7 ± 0.4% | 0.28 |
| canterbury/cp.html | 24603 | 3 | 324.9 ± 0.8% | 114.0 ± 0.3% | 0.35 |
| canterbury/fields.c | 11150 | 1 | 362.5 ± 0.9% | 126.4 ± 0.4% | 0.35 |
| canterbury/fields.c | 11150 | 3 | 331.2 ± 0.6% | 98.0 ± 1.0% | 0.30 |
| canterbury/grammar.lsp | 3721 | 1 | 334.3 ± 0.3% | 93.1 ± 0.6% | 0.28 |
| canterbury/grammar.lsp | 3721 | 3 | 293.0 ± 0.3% | 61.9 ± 0.4% | 0.21 |
| canterbury/kennedy.xls | 1029744 | 1 | 562.9 ± 0.4% | 154.8 ± 0.8% | 0.27 |
| canterbury/kennedy.xls | 1029744 | 3 | 363.1 ± 9.1% | 129.4 ± 0.5% | 0.36 |
| canterbury/lcet10.txt | 426754 | 1 | 343.2 ± 0.2% | 106.2 ± 0.4% | 0.31 |
| canterbury/lcet10.txt | 426754 | 3 | 194.8 ± 0.1% | 94.2 ± 0.7% | 0.48 |
| canterbury/plrabn12.txt | 481861 | 1 | 325.4 ± 0.4% | 88.9 ± 0.1% | 0.27 |
| canterbury/plrabn12.txt | 481861 | 3 | 150.4 ± 0.3% | 79.0 ± 0.4% | 0.53 |
| canterbury/ptt5 | 513216 | 1 | 1087.5 ± 0.3% | 326.5 ± 0.4% | 0.30 |
| canterbury/ptt5 | 513216 | 3 | 613.0 ± 0.5% | 272.0 ± 0.4% | 0.44 |
| canterbury/sum | 38240 | 1 | 515.8 ± 0.3% | 138.6 ± 0.5% | 0.27 |
| canterbury/sum | 38240 | 3 | 351.6 ± 0.6% | 116.8 ± 0.6% | 0.33 |
| canterbury/xargs.1 | 4227 | 1 | 306.9 ± 0.5% | 97.2 ± 0.7% | 0.32 |
| canterbury/xargs.1 | 4227 | 3 | 249.4 ± 0.2% | 65.8 ± 0.2% | 0.26 |
| canterbury-large/E.coli | 4638690 | 1 | 320.8 ± 0.3% | 94.2 ± 0.7% | 0.29 |
| canterbury-large/E.coli | 4638690 | 3 | 205.6 ± 1.1% | 78.1 ± 1.3% | 0.38 |
| canterbury-large/bible.txt | 4047392 | 1 | 341.9 ± 0.5% | 99.5 ± 0.8% | 0.29 |
| canterbury-large/bible.txt | 4047392 | 3 | 172.4 ± 0.3% | 74.3 ± 0.6% | 0.43 |
| canterbury-large/world192.txt | 2473400 | 1 | 413.4 ± 0.3% | 113.4 ± 0.4% | 0.27 |
| canterbury-large/world192.txt | 2473400 | 3 | 198.3 ± 0.5% | 96.7 ± 0.7% | 0.49 |
| http/html-1kx1024 | 1048576 | 1 | 188.3 ± 0.1% | 40.5 ± 1.6% | 0.21 |
| http/html-1kx1024 | 1048576 | 3 | 165.4 ± 0.0% | 20.6 ± 1.1% | 0.12 |
| http/html-16kx64 | 1048576 | 1 | 408.5 ± 0.3% | 154.9 ± 0.4% | 0.38 |
| http/html-16kx64 | 1048576 | 3 | 350.5 ± 0.1% | 125.4 ± 0.4% | 0.36 |
| http/html-1m | 1048576 | 1 | 534.5 ± 0.3% | 164.8 ± 0.3% | 0.31 |
| http/html-1m | 1048576 | 3 | 340.6 ± 1.9% | 156.8 ± 0.4% | 0.46 |
| http/json-1kx1024 | 1048576 | 1 | 222.5 ± 0.2% | 45.9 ± 2.2% | 0.21 |
| http/json-1kx1024 | 1048576 | 3 | 210.8 ± 0.1% | 22.3 ± 1.2% | 0.11 |
| http/json-16kx64 | 1048576 | 1 | 634.0 ± 0.5% | 217.3 ± 0.4% | 0.34 |
| http/json-16kx64 | 1048576 | 3 | 546.2 ± 0.2% | 164.7 ± 0.3% | 0.30 |
| http/json-1m | 1048576 | 1 | 835.5 ± 2.1% | 226.9 ± 0.6% | 0.27 |
| http/json-1m | 1048576 | 3 | 503.0 ± 0.6% | 214.2 ± 0.4% | 0.43 |
| http/js-1kx1024 | 1048576 | 1 | 173.9 ± 0.1% | 37.8 ± 1.6% | 0.22 |
| http/js-1kx1024 | 1048576 | 3 | 148.7 ± 0.1% | 19.9 ± 0.7% | 0.13 |
| http/js-16kx64 | 1048576 | 1 | 359.2 ± 0.2% | 131.6 ± 0.5% | 0.37 |
| http/js-16kx64 | 1048576 | 3 | 308.4 ± 0.2% | 111.6 ± 1.0% | 0.36 |
| http/js-1m | 1048576 | 1 | 509.5 ± 0.5% | 152.3 ± 0.4% | 0.30 |
| http/js-1m | 1048576 | 3 | 312.5 ± 0.9% | 145.7 ± 0.9% | 0.47 |
| http/css-1kx1024 | 1048576 | 1 | 205.4 ± 0.2% | 43.3 ± 3.8% | 0.21 |
| http/css-1kx1024 | 1048576 | 3 | 188.5 ± 0.1% | 21.6 ± 2.2% | 0.11 |
| http/css-16kx64 | 1048576 | 1 | 506.4 ± 0.3% | 172.5 ± 0.3% | 0.34 |
| http/css-16kx64 | 1048576 | 3 | 459.7 ± 1.4% | 141.8 ± 0.4% | 0.31 |
| http/css-1m | 1048576 | 1 | 2292.3 ± 0.2% | 472.1 ± 0.4% | 0.21 |
| http/css-1m | 1048576 | 3 | 1626.6 ± 3.2% | 632.4 ± 1.1% | 0.39 |
| shuffled/dickens-1m | 1048576 | 1 | 954.8 ± 3.7% | 182.8 ± 0.3% | 0.19 |
| shuffled/dickens-1m | 1048576 | 3 | 102.1 ± 0.9% | 116.2 ± 1.1% | 1.14 |

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
| silesia/dickens | 10192446 | 35.9 | 897.7 ±3.5% | 867.8 ±1.8% | 0.97 |
| silesia/mozilla | 51220480 | 35.6 | 1152.2 ±3.0% | 1157.2 ±0.5% | 1.00 |
| silesia/mr | 9970564 | 35.6 | 1068.2 ±1.0% | 1058.3 ±1.4% | 0.99 |
| silesia/nci | 33553445 | 8.4 | 1931.5 ±2.8% | 1805.6 ±2.5% | 0.93 |
| silesia/ooffice | 6152192 | 50.8 | 972.8 ±1.2% | 993.2 ±1.0% | 1.02 |
| silesia/osdb | 10085684 | 34.7 | 1388.2 ±0.6% | 1346.2 ±0.4% | 0.97 |
| silesia/reymont | 6627202 | 29.2 | 1023.8 ±15.0% | 964.2 ±2.0% | 0.94 |
| silesia/samba | 21606400 | 22.9 | 1547.5 ±1.5% | 1480.1 ±1.8% | 0.96 |
| silesia/sao | 7251944 | 76.2 | 871.0 ±1.0% | 944.3 ±0.7% | 1.08 |
| silesia/webster | 41458703 | 29.2 | 1000.1 ±0.9% | 950.4 ±1.0% | 0.95 |
| silesia/x-ray | 8474240 | 71.8 | 841.5 ±2.8% | 929.7 ±4.3% | 1.10 |
| silesia/xml | 5345280 | 11.9 | 2166.9 ±0.3% | 2197.2 ±0.4% | 1.01 |
| canterbury/alice29.txt | 152089 | 37.5 | 1011.2 ±0.2% | 1026.3 ±0.1% | 1.01 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1128.3 ±0.3% | 1136.7 ±0.2% | 1.01 |
| canterbury/cp.html | 24603 | 34.4 | 1251.3 ±0.2% | 1335.8 ±0.1% | 1.07 |
| canterbury/fields.c | 11150 | 30.3 | 1071.9 ±0.3% | 1119.8 ±0.1% | 1.04 |
| canterbury/grammar.lsp | 3721 | 34.8 | 785.8 ±0.2% | 824.3 ±0.0% | 1.05 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1349.8 ±0.2% | 1261.6 ±0.3% | 0.93 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1236.5 ±0.2% | 1251.0 ±0.4% | 1.01 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1061.2 ±0.1% | 1068.5 ±0.2% | 1.01 |
| canterbury/ptt5 | 513216 | 10.6 | 2351.2 ±0.3% | 2521.0 ±1.9% | 1.07 |
| canterbury/sum | 38240 | 35.0 | 1232.5 ±0.2% | 1292.1 ±0.2% | 1.05 |
| canterbury/xargs.1 | 4227 | 42.7 | 783.1 ±0.3% | 796.7 ±0.1% | 1.02 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1079.6 ±0.5% | 1056.6 ±0.2% | 0.98 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1077.1 ±0.5% | 1058.6 ±0.4% | 0.98 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1288.8 ±0.3% | 1235.9 ±0.6% | 0.96 |
| http/html-1kx1024 | 1048576 | 39.3 | 458.3 ±0.1% | 477.7 ±0.2% | 1.04 |
| http/html-16kx64 | 1048576 | 21.9 | 1272.8 ±0.5% | 1279.9 ±0.3% | 1.01 |
| http/html-1m | 1048576 | 17.7 | 1687.1 ±0.7% | 1683.2 ±0.7% | 1.00 |
| http/json-1kx1024 | 1048576 | 21.9 | 531.7 ±0.1% | 573.7 ±0.2% | 1.08 |
| http/json-16kx64 | 1048576 | 12.6 | 1652.1 ±0.1% | 1698.7 ±0.3% | 1.03 |
| http/json-1m | 1048576 | 12.2 | 1938.8 ±0.4% | 2062.4 ±0.3% | 1.06 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.7 ±0.2% | 390.9 ±0.2% | 0.97 |
| http/js-16kx64 | 1048576 | 26.0 | 1159.3 ±0.3% | 1147.7 ±0.2% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1666.5 ±0.4% | 1617.6 ±0.3% | 0.97 |
| http/css-1kx1024 | 1048576 | 29.5 | 478.9 ±0.1% | 517.8 ±0.1% | 1.08 |
| http/css-16kx64 | 1048576 | 15.9 | 1478.9 ±0.2% | 1506.9 ±0.1% | 1.02 |
| http/css-1m | 1048576 | 3.6 | 5030.2 ±0.3% | 4813.1 ±0.7% | 0.96 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1200.2 ±0.5% | 1228.5 ±0.9% | 1.02 |
