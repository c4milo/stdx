# bench-zstd

| Field | Value |
|---|---|
| Commit | 9cd44f7 |
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
| silesia/dickens | 10192446 | 35.9 | 902.7 ±4.0% | 868.9 ±3.8% | 0.96 |
| silesia/mozilla | 51220480 | 35.6 | 1162.8 ±1.5% | 1149.9 ±2.0% | 0.99 |
| silesia/mr | 9970564 | 35.6 | 1064.1 ±2.8% | 1038.5 ±1.7% | 0.98 |
| silesia/nci | 33553445 | 8.4 | 1917.9 ±4.4% | 1768.8 ±3.8% | 0.92 |
| silesia/ooffice | 6152192 | 50.8 | 973.1 ±1.1% | 987.4 ±0.7% | 1.01 |
| silesia/osdb | 10085684 | 34.7 | 1371.8 ±0.6% | 1334.3 ±1.0% | 0.97 |
| silesia/reymont | 6627202 | 29.2 | 1005.5 ±5.5% | 966.7 ±1.7% | 0.96 |
| silesia/samba | 21606400 | 22.9 | 1539.1 ±3.3% | 1477.3 ±0.9% | 0.96 |
| silesia/sao | 7251944 | 76.2 | 864.2 ±1.6% | 934.1 ±1.5% | 1.08 |
| silesia/webster | 41458703 | 29.2 | 985.3 ±7.5% | 938.3 ±9.7% | 0.95 |
| silesia/x-ray | 8474240 | 71.8 | 840.3 ±0.5% | 919.3 ±1.1% | 1.09 |
| silesia/xml | 5345280 | 11.9 | 2159.2 ±0.8% | 2185.3 ±0.3% | 1.01 |
| canterbury/alice29.txt | 152089 | 37.5 | 1013.6 ±0.3% | 1024.7 ±0.1% | 1.01 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1133.1 ±0.2% | 1134.0 ±0.1% | 1.00 |
| canterbury/cp.html | 24603 | 34.4 | 1272.0 ±0.3% | 1331.4 ±0.1% | 1.05 |
| canterbury/fields.c | 11150 | 30.3 | 1082.0 ±0.2% | 1126.7 ±0.1% | 1.04 |
| canterbury/grammar.lsp | 3721 | 34.8 | 797.4 ±0.3% | 824.0 ±0.1% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1358.2 ±0.7% | 1264.0 ±0.4% | 0.93 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1239.8 ±0.1% | 1246.3 ±0.6% | 1.01 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1075.1 ±0.1% | 1060.9 ±0.3% | 0.99 |
| canterbury/ptt5 | 513216 | 10.6 | 2362.6 ±0.1% | 2540.7 ±1.6% | 1.08 |
| canterbury/sum | 38240 | 35.0 | 1276.8 ±0.3% | 1291.5 ±0.1% | 1.01 |
| canterbury/xargs.1 | 4227 | 42.7 | 788.6 ±0.4% | 795.5 ±0.0% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1060.0 ±0.6% | 1034.9 ±0.3% | 0.98 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1098.9 ±1.9% | 1019.3 ±10.3% | 0.93 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1296.6 ±6.9% | 1233.7 ±2.4% | 0.95 |
| http/html-1kx1024 | 1048576 | 39.3 | 458.0 ±0.2% | 447.6 ±0.1% | 0.98 |
| http/html-16kx64 | 1048576 | 21.9 | 1270.6 ±0.2% | 1269.2 ±0.2% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1666.7 ±0.6% | 1645.5 ±0.3% | 0.99 |
| http/json-1kx1024 | 1048576 | 21.9 | 530.3 ±0.1% | 546.0 ±0.3% | 1.03 |
| http/json-16kx64 | 1048576 | 12.6 | 1660.1 ±0.1% | 1676.9 ±0.1% | 1.01 |
| http/json-1m | 1048576 | 12.2 | 1953.3 ±0.5% | 2079.4 ±0.8% | 1.06 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.5 ±0.2% | 375.4 ±0.1% | 0.93 |
| http/js-16kx64 | 1048576 | 26.0 | 1158.5 ±0.2% | 1143.1 ±0.2% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1670.5 ±0.5% | 1630.9 ±0.6% | 0.98 |
| http/css-1kx1024 | 1048576 | 29.5 | 481.5 ±0.2% | 495.1 ±0.1% | 1.03 |
| http/css-16kx64 | 1048576 | 15.9 | 1514.5 ±0.1% | 1495.5 ±0.2% | 0.99 |
| http/css-1m | 1048576 | 3.6 | 5088.1 ±0.2% | 4888.9 ±1.2% | 0.96 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1198.1 ±0.6% | 1233.9 ±0.2% | 1.03 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 234.5 ±0.4% | 886.1 ±1.0% | 3.78 |
| silesia/mozilla | 51220480 | 35.6 | 276.4 ±0.5% | 1158.7 ±0.7% | 4.19 |
| silesia/mr | 9970564 | 35.6 | 240.7 ±0.6% | 1028.2 ±1.6% | 4.27 |
| silesia/nci | 33553445 | 8.4 | 662.0 ±0.8% | 1733.2 ±2.5% | 2.62 |
| silesia/ooffice | 6152192 | 50.8 | 192.5 ±1.0% | 965.9 ±0.9% | 5.02 |
| silesia/osdb | 10085684 | 34.7 | 296.8 ±0.8% | 1319.9 ±3.8% | 4.45 |
| silesia/reymont | 6627202 | 29.2 | 276.2 ±0.4% | 985.1 ±0.8% | 3.57 |
| silesia/samba | 21606400 | 22.9 | 440.4 ±2.5% | 1443.7 ±6.8% | 3.28 |
| silesia/sao | 7251944 | 76.2 | 163.1 ±0.6% | 930.6 ±1.8% | 5.70 |
| silesia/webster | 41458703 | 29.2 | 276.2 ±0.4% | 943.3 ±1.4% | 3.42 |
| silesia/x-ray | 8474240 | 71.8 | 152.4 ±0.2% | 911.4 ±0.6% | 5.98 |
| silesia/xml | 5345280 | 11.9 | 616.3 ±0.8% | 2170.5 ±1.8% | 3.52 |
| canterbury/alice29.txt | 152089 | 37.5 | 221.3 ±0.4% | 1025.1 ±0.1% | 4.63 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 207.8 ±0.3% | 1133.4 ±0.1% | 5.45 |
| canterbury/cp.html | 24603 | 34.4 | 253.7 ±0.2% | 1331.5 ±0.4% | 5.25 |
| canterbury/fields.c | 11150 | 30.3 | 251.1 ±0.3% | 1123.2 ±0.3% | 4.47 |
| canterbury/grammar.lsp | 3721 | 34.8 | 215.2 ±0.7% | 823.8 ±0.2% | 3.83 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 297.2 ±0.4% | 1265.6 ±0.2% | 4.26 |
| canterbury/lcet10.txt | 426754 | 33.0 | 266.0 ±0.2% | 1259.1 ±0.2% | 4.73 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 219.5 ±0.2% | 1069.2 ±0.1% | 4.87 |
| canterbury/ptt5 | 513216 | 10.6 | 473.0 ±0.3% | 2563.6 ±1.6% | 5.42 |
| canterbury/sum | 38240 | 35.0 | 250.1 ±0.2% | 1292.3 ±0.3% | 5.17 |
| canterbury/xargs.1 | 4227 | 42.7 | 182.4 ±0.5% | 796.3 ±0.1% | 4.37 |
| canterbury-large/E.coli | 4638690 | 30.0 | 263.9 ±1.2% | 1076.5 ±1.3% | 4.08 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 294.4 ±0.7% | 1076.4 ±0.7% | 3.66 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 330.4 ±0.2% | 1274.8 ±0.5% | 3.86 |
| http/html-1kx1024 | 1048576 | 39.3 | 187.8 ±0.2% | 452.7 ±0.2% | 2.41 |
| http/html-16kx64 | 1048576 | 21.9 | 335.0 ±0.2% | 1277.5 ±0.2% | 3.81 |
| http/html-1m | 1048576 | 17.7 | 451.7 ±0.3% | 1704.2 ±0.6% | 3.77 |
| http/json-1kx1024 | 1048576 | 21.9 | 279.1 ±0.2% | 546.7 ±0.1% | 1.96 |
| http/json-16kx64 | 1048576 | 12.6 | 468.4 ±0.1% | 1680.2 ±0.3% | 3.59 |
| http/json-1m | 1048576 | 12.2 | 527.7 ±0.3% | 2085.8 ±0.4% | 3.95 |
| http/js-1kx1024 | 1048576 | 44.5 | 158.3 ±0.1% | 375.9 ±0.1% | 2.37 |
| http/js-16kx64 | 1048576 | 26.0 | 287.0 ±0.3% | 1150.8 ±0.1% | 4.01 |
| http/js-1m | 1048576 | 19.0 | 428.4 ±0.3% | 1649.7 ±0.5% | 3.85 |
| http/css-1kx1024 | 1048576 | 29.5 | 234.8 ±0.1% | 496.0 ±0.3% | 2.11 |
| http/css-16kx64 | 1048576 | 15.9 | 420.8 ±0.2% | 1495.0 ±0.2% | 3.55 |
| http/css-1m | 1048576 | 3.6 | 1757.6 ±0.6% | 4876.9 ±0.5% | 2.77 |
| shuffled/dickens-1m | 1048576 | 58.8 | 152.9 ±0.7% | 1247.4 ±4.2% | 8.16 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 926.1 ±0.7% | 0.94 ±1.6% | 1.00 ±1.0% | 0.60 ±0.7% | 0.96 ±4.1% | 0.38 ±0.8% |
| silesia/mozilla | 51220480 | 35.6 | 1168.0 ±0.8% | 0.74 ±0.5% | 1.00 ±1.2% | 0.62 ±0.8% | 0.99 ±0.6% | 0.45 ±0.5% |
| silesia/mr | 9970564 | 35.6 | 1096.7 ±0.7% | 0.82 ±0.7% | 1.00 ±0.8% | 0.57 ±2.9% | 0.96 ±13.8% | 0.39 ±1.1% |
| silesia/nci | 33553445 | 8.4 | 1894.5 ±3.2% | 0.96 ±5.1% | 1.01 ±3.4% | 0.70 ±1.1% | 1.01 ±3.3% | 0.48 ±1.0% |
| silesia/ooffice | 6152192 | 50.8 | 1006.2 ±0.7% | 0.62 ±0.5% | 1.00 ±0.5% | 0.59 ±0.5% | 0.98 ±0.7% | 0.45 ±1.1% |
| silesia/osdb | 10085684 | 34.7 | 1394.9 ±0.5% | 0.67 ±3.2% | 1.00 ±4.6% | 0.69 ±9.2% | 0.96 ±1.2% | 0.46 ±1.1% |
| silesia/reymont | 6627202 | 29.2 | 1003.4 ±0.3% | 0.95 ±0.4% | 1.00 ±0.5% | 0.63 ±0.4% | 0.97 ±1.1% | 0.41 ±1.3% |
| silesia/samba | 21606400 | 22.9 | 1545.2 ±1.7% | 0.92 ±1.6% | 1.00 ±1.6% | 0.63 ±5.4% | 0.98 ±12.3% | 0.43 ±0.8% |
| silesia/sao | 7251944 | 76.2 | 950.4 ±0.3% | 0.52 ±0.4% | 0.99 ±1.4% | 0.69 ±0.8% | 0.98 ±1.0% | 0.53 ±0.8% |
| silesia/webster | 41458703 | 29.2 | 957.2 ±4.8% | 0.92 ±3.9% | 0.99 ±7.2% | 0.65 ±2.5% | 0.99 ±5.7% | 0.43 ±4.8% |
| silesia/x-ray | 8474240 | 71.8 | 937.3 ±5.5% | 0.51 ±2.3% | 1.00 ±4.7% | 0.66 ±2.1% | 0.97 ±4.9% | 0.48 ±1.3% |
| silesia/xml | 5345280 | 11.9 | 2217.6 ±7.7% | 0.92 ±1.1% | 0.99 ±0.5% | 0.62 ±0.7% | 0.98 ±6.8% | 0.41 ±14.0% |
| canterbury/alice29.txt | 152089 | 37.5 | 1022.9 ±0.1% | 0.94 ±0.4% | 1.01 ±0.4% | 0.54 ±0.1% | 0.99 ±0.1% | 0.36 ±0.2% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1134.3 ±0.1% | 0.85 ±0.2% | 0.98 ±0.1% | 0.51 ±0.2% | 0.99 ±0.1% | 0.37 ±0.1% |
| canterbury/cp.html | 24603 | 34.4 | 1336.6 ±0.3% | 0.63 ±0.2% | 1.00 ±0.1% | 0.62 ±0.4% | 0.99 ±0.1% | 0.45 ±0.2% |
| canterbury/fields.c | 11150 | 30.3 | 1126.2 ±0.3% | 0.81 ±0.2% | 1.00 ±0.2% | 0.59 ±0.7% | 1.00 ±0.2% | 0.41 ±0.1% |
| canterbury/grammar.lsp | 3721 | 34.8 | 823.6 ±0.1% | 0.79 ±0.1% | 1.00 ±0.2% | 0.67 ±0.7% | 0.99 ±0.1% | 0.49 ±0.2% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1261.9 ±0.5% | 0.86 ±0.9% | 1.01 ±0.4% | 0.58 ±0.2% | 1.00 ±0.4% | 0.38 ±1.4% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1259.1 ±0.4% | 0.89 ±0.2% | 1.00 ±0.4% | 0.54 ±0.3% | 0.99 ±0.2% | 0.35 ±0.2% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1070.5 ±0.2% | 0.91 ±0.3% | 0.99 ±0.3% | 0.53 ±0.4% | 0.99 ±0.2% | 0.35 ±0.5% |
| canterbury/ptt5 | 513216 | 10.6 | 2543.1 ±0.7% | 0.81 ±0.6% | 1.01 ±1.1% | 0.56 ±0.2% | 1.00 ±1.7% | 0.44 ±0.4% |
| canterbury/sum | 38240 | 35.0 | 1293.0 ±0.2% | 0.64 ±0.3% | 1.00 ±0.2% | 0.63 ±0.6% | 0.99 ±0.2% | 0.45 ±0.2% |
| canterbury/xargs.1 | 4227 | 42.7 | 796.3 ±0.2% | 0.74 ±0.2% | 1.00 ±0.2% | 0.64 ±0.3% | 0.99 ±0.1% | 0.46 ±0.1% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1079.7 ±1.1% | 0.98 ±3.1% | 1.00 ±0.4% | 0.59 ±2.1% | 0.97 ±2.2% | 0.35 ±7.8% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1086.8 ±0.7% | 0.96 ±0.9% | 1.00 ±1.5% | 0.61 ±1.1% | 0.97 ±12.8% | 0.38 ±1.5% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1271.8 ±0.5% | 0.90 ±0.5% | 1.01 ±0.6% | 0.62 ±0.5% | 0.99 ±0.8% | 0.41 ±0.6% |
| http/html-1kx1024 | 1048576 | 39.3 | 453.4 ±0.2% | 0.86 ±0.1% | 1.00 ±0.1% | 0.79 ±0.1% | 0.99 ±0.1% | 0.67 ±0.2% |
| http/html-16kx64 | 1048576 | 21.9 | 1275.0 ±0.3% | 0.83 ±0.2% | 1.00 ±0.2% | 0.63 ±0.1% | 1.00 ±0.1% | 0.46 ±0.2% |
| http/html-1m | 1048576 | 17.7 | 1693.9 ±0.3% | 0.94 ±0.9% | 1.01 ±0.9% | 0.60 ±0.4% | 0.99 ±0.3% | 0.39 ±0.4% |
| http/json-1kx1024 | 1048576 | 21.9 | 543.7 ±0.1% | 0.99 ±0.2% | 1.00 ±0.2% | 0.82 ±0.2% | 0.99 ±0.1% | 0.68 ±0.1% |
| http/json-16kx64 | 1048576 | 12.6 | 1679.9 ±0.2% | 0.85 ±0.2% | 1.01 ±0.4% | 0.65 ±0.2% | 0.99 ±0.1% | 0.47 ±0.1% |
| http/json-1m | 1048576 | 12.2 | 2077.4 ±0.7% | 0.89 ±0.9% | 1.01 ±0.4% | 0.59 ±0.1% | 0.99 ±0.2% | 0.40 ±0.2% |
| http/js-1kx1024 | 1048576 | 44.5 | 375.3 ±0.3% | 0.86 ±0.1% | 1.00 ±0.2% | 0.78 ±0.2% | 0.99 ±0.2% | 0.67 ±0.1% |
| http/js-16kx64 | 1048576 | 26.0 | 1149.3 ±0.1% | 0.82 ±0.1% | 1.00 ±0.3% | 0.61 ±0.2% | 1.00 ±0.2% | 0.45 ±0.0% |
| http/js-1m | 1048576 | 19.0 | 1643.6 ±0.3% | 0.92 ±0.3% | 1.00 ±0.6% | 0.60 ±0.4% | 0.99 ±2.1% | 0.40 ±0.3% |
| http/css-1kx1024 | 1048576 | 29.5 | 494.5 ±0.1% | 0.95 ±0.1% | 1.00 ±0.2% | 0.79 ±0.1% | 0.99 ±0.2% | 0.67 ±0.1% |
| http/css-16kx64 | 1048576 | 15.9 | 1491.8 ±0.3% | 0.89 ±0.2% | 1.01 ±0.1% | 0.65 ±0.1% | 1.00 ±0.2% | 0.45 ±0.3% |
| http/css-1m | 1048576 | 3.6 | 4823.1 ±0.4% | 0.96 ±0.7% | 1.01 ±1.0% | 0.71 ±0.6% | 1.00 ±0.9% | 0.46 ±0.8% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1246.5 ±0.4% | 0.52 ±2.7% | 0.86 ±1.3% | 0.74 ±0.6% | 0.97 ±0.2% | 0.56 ±0.7% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 332.4 ± 0.7% | 84.3 ± 0.5% | 0.25 |
| silesia/dickens | 10192446 | 3 | 137.6 ± 0.6% | 56.4 ± 3.3% | 0.41 |
| silesia/mozilla | 51220480 | 1 | 479.4 ± 0.7% | 118.8 ± 0.4% | 0.25 |
| silesia/mozilla | 51220480 | 3 | 179.9 ± 1.5% | 63.4 ± 0.9% | 0.35 |
| silesia/mr | 9970564 | 1 | 439.7 ± 0.2% | 104.1 ± 0.3% | 0.24 |
| silesia/mr | 9970564 | 3 | 152.9 ± 1.4% | 60.1 ± 0.6% | 0.39 |
| silesia/nci | 33553445 | 1 | 947.8 ± 0.4% | 225.6 ± 0.6% | 0.24 |
| silesia/nci | 33553445 | 3 | 575.1 ± 3.2% | 119.2 ± 1.3% | 0.21 |
| silesia/ooffice | 6152192 | 1 | 392.2 ± 0.2% | 93.9 ± 0.3% | 0.24 |
| silesia/ooffice | 6152192 | 3 | 126.7 ± 1.2% | 52.9 ± 2.5% | 0.42 |
| silesia/osdb | 10085684 | 1 | 472.4 ± 0.5% | 125.6 ± 0.8% | 0.27 |
| silesia/osdb | 10085684 | 3 | 168.6 ± 1.6% | 64.9 ± 1.7% | 0.38 |
| silesia/reymont | 6627202 | 1 | 342.8 ± 0.2% | 99.7 ± 4.7% | 0.29 |
| silesia/reymont | 6627202 | 3 | 169.5 ± 2.4% | 70.1 ± 5.1% | 0.41 |
| silesia/samba | 21606400 | 1 | 560.9 ± 0.9% | 145.7 ± 0.4% | 0.26 |
| silesia/samba | 21606400 | 3 | 256.4 ± 2.4% | 83.2 ± 2.0% | 0.32 |
| silesia/sao | 7251944 | 1 | 371.2 ± 0.6% | 84.3 ± 0.5% | 0.23 |
| silesia/sao | 7251944 | 3 | 95.4 ± 0.8% | 44.8 ± 0.5% | 0.47 |
| silesia/webster | 41458703 | 1 | 387.3 ± 0.2% | 101.5 ± 0.3% | 0.26 |
| silesia/webster | 41458703 | 3 | 164.1 ± 0.2% | 61.6 ± 0.2% | 0.38 |
| silesia/x-ray | 8474240 | 1 | 718.1 ± 1.4% | 90.1 ± 0.6% | 0.13 |
| silesia/x-ray | 8474240 | 3 | 94.3 ± 0.2% | 46.9 ± 0.3% | 0.50 |
| silesia/xml | 5345280 | 1 | 794.3 ± 0.1% | 185.1 ± 0.5% | 0.23 |
| silesia/xml | 5345280 | 3 | 466.8 ± 7.6% | 131.6 ± 1.5% | 0.28 |
| canterbury/alice29.txt | 152089 | 1 | 311.6 ± 0.2% | 101.1 ± 0.5% | 0.32 |
| canterbury/alice29.txt | 152089 | 3 | 211.2 ± 0.3% | 89.9 ± 0.3% | 0.43 |
| canterbury/asyoulik.txt | 125179 | 1 | 347.1 ± 0.1% | 94.8 ± 0.7% | 0.27 |
| canterbury/asyoulik.txt | 125179 | 3 | 219.2 ± 0.3% | 86.7 ± 0.6% | 0.40 |
| canterbury/cp.html | 24603 | 1 | 489.8 ± 0.5% | 143.4 ± 0.1% | 0.29 |
| canterbury/cp.html | 24603 | 3 | 370.0 ± 1.8% | 131.6 ± 0.4% | 0.36 |
| canterbury/fields.c | 11150 | 1 | 389.9 ± 0.7% | 138.6 ± 0.8% | 0.36 |
| canterbury/fields.c | 11150 | 3 | 376.9 ± 0.3% | 142.2 ± 0.6% | 0.38 |
| canterbury/grammar.lsp | 3721 | 1 | 358.9 ± 0.2% | 121.8 ± 0.6% | 0.34 |
| canterbury/grammar.lsp | 3721 | 3 | 321.3 ± 0.5% | 120.3 ± 0.6% | 0.37 |
| canterbury/kennedy.xls | 1029744 | 1 | 563.1 ± 0.1% | 155.1 ± 0.3% | 0.28 |
| canterbury/kennedy.xls | 1029744 | 3 | 374.0 ± 0.6% | 127.2 ± 0.5% | 0.34 |
| canterbury/lcet10.txt | 426754 | 1 | 342.3 ± 0.2% | 104.9 ± 0.4% | 0.31 |
| canterbury/lcet10.txt | 426754 | 3 | 189.5 ± 0.6% | 91.8 ± 1.0% | 0.48 |
| canterbury/plrabn12.txt | 481861 | 1 | 326.4 ± 0.2% | 88.0 ± 0.4% | 0.27 |
| canterbury/plrabn12.txt | 481861 | 3 | 152.1 ± 0.6% | 77.2 ± 0.4% | 0.51 |
| canterbury/ptt5 | 513216 | 1 | 1086.7 ± 0.2% | 319.6 ± 0.2% | 0.29 |
| canterbury/ptt5 | 513216 | 3 | 641.3 ± 0.6% | 266.9 ± 0.7% | 0.42 |
| canterbury/sum | 38240 | 1 | 519.3 ± 0.1% | 140.4 ± 0.5% | 0.27 |
| canterbury/sum | 38240 | 3 | 384.6 ± 1.0% | 124.7 ± 0.8% | 0.32 |
| canterbury/xargs.1 | 4227 | 1 | 340.4 ± 0.4% | 115.9 ± 0.4% | 0.34 |
| canterbury/xargs.1 | 4227 | 3 | 283.2 ± 0.5% | 110.4 ± 0.8% | 0.39 |
| canterbury-large/E.coli | 4638690 | 1 | 320.1 ± 0.3% | 94.9 ± 0.3% | 0.30 |
| canterbury-large/E.coli | 4638690 | 3 | 208.9 ± 1.2% | 81.3 ± 0.5% | 0.39 |
| canterbury-large/bible.txt | 4047392 | 1 | 343.7 ± 0.2% | 101.1 ± 0.4% | 0.29 |
| canterbury-large/bible.txt | 4047392 | 3 | 174.0 ± 0.3% | 75.8 ± 0.7% | 0.44 |
| canterbury-large/world192.txt | 2473400 | 1 | 414.0 ± 0.2% | 114.6 ± 0.7% | 0.28 |
| canterbury-large/world192.txt | 2473400 | 3 | 201.3 ± 0.6% | 95.8 ± 1.0% | 0.48 |
| http/html-1kx1024 | 1048576 | 1 | 199.0 ± 0.1% | 69.9 ± 0.2% | 0.35 |
| http/html-1kx1024 | 1048576 | 3 | 176.7 ± 0.1% | 66.3 ± 0.4% | 0.38 |
| http/html-16kx64 | 1048576 | 1 | 434.3 ± 0.2% | 166.7 ± 0.1% | 0.38 |
| http/html-16kx64 | 1048576 | 3 | 380.2 ± 0.3% | 156.8 ± 0.5% | 0.41 |
| http/html-1m | 1048576 | 1 | 536.8 ± 0.3% | 166.4 ± 0.3% | 0.31 |
| http/html-1m | 1048576 | 3 | 339.5 ± 3.7% | 155.5 ± 7.3% | 0.46 |
| http/json-1kx1024 | 1048576 | 1 | 237.3 ± 0.5% | 86.5 ± 0.5% | 0.36 |
| http/json-1kx1024 | 1048576 | 3 | 227.9 ± 0.2% | 82.8 ± 0.9% | 0.36 |
| http/json-16kx64 | 1048576 | 1 | 704.7 ± 0.2% | 240.5 ± 0.4% | 0.34 |
| http/json-16kx64 | 1048576 | 3 | 625.1 ± 0.2% | 227.4 ± 0.3% | 0.36 |
| http/json-1m | 1048576 | 1 | 831.9 ± 0.5% | 230.2 ± 0.4% | 0.28 |
| http/json-1m | 1048576 | 3 | 499.6 ± 0.9% | 212.9 ± 0.2% | 0.43 |
| http/js-1kx1024 | 1048576 | 1 | 183.0 ± 0.2% | 62.4 ± 0.4% | 0.34 |
| http/js-1kx1024 | 1048576 | 3 | 157.5 ± 0.2% | 59.1 ± 1.3% | 0.38 |
| http/js-16kx64 | 1048576 | 1 | 378.1 ± 0.2% | 139.2 ± 0.3% | 0.37 |
| http/js-16kx64 | 1048576 | 3 | 330.8 ± 0.3% | 134.9 ± 0.4% | 0.41 |
| http/js-1m | 1048576 | 1 | 509.2 ± 0.6% | 152.4 ± 1.8% | 0.30 |
| http/js-1m | 1048576 | 3 | 314.0 ± 0.5% | 143.6 ± 0.7% | 0.46 |
| http/css-1kx1024 | 1048576 | 1 | 217.7 ± 0.2% | 77.8 ± 0.5% | 0.36 |
| http/css-1kx1024 | 1048576 | 3 | 202.5 ± 0.1% | 75.1 ± 0.3% | 0.37 |
| http/css-16kx64 | 1048576 | 1 | 546.8 ± 0.1% | 185.5 ± 0.3% | 0.34 |
| http/css-16kx64 | 1048576 | 3 | 512.8 ± 0.3% | 183.7 ± 0.4% | 0.36 |
| http/css-1m | 1048576 | 1 | 2285.0 ± 0.2% | 493.0 ± 0.3% | 0.22 |
| http/css-1m | 1048576 | 3 | 1656.1 ± 2.5% | 635.2 ± 0.6% | 0.38 |
| shuffled/dickens-1m | 1048576 | 1 | 959.5 ± 0.3% | 185.3 ± 1.3% | 0.19 |
| shuffled/dickens-1m | 1048576 | 3 | 104.1 ± 0.8% | 111.7 ± 0.4% | 1.07 |

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
| silesia/dickens | 10192446 | 35.9 | 908.9 ±1.2% | 874.7 ±0.7% | 0.96 |
| silesia/mozilla | 51220480 | 35.6 | 1158.2 ±1.2% | 1159.5 ±3.4% | 1.00 |
| silesia/mr | 9970564 | 35.6 | 1071.0 ±0.7% | 1057.6 ±0.5% | 0.99 |
| silesia/nci | 33553445 | 8.4 | 1967.5 ±1.7% | 1826.6 ±2.1% | 0.93 |
| silesia/ooffice | 6152192 | 50.8 | 982.9 ±0.2% | 1002.6 ±0.5% | 1.02 |
| silesia/osdb | 10085684 | 34.7 | 1377.5 ±1.4% | 1346.9 ±0.6% | 0.98 |
| silesia/reymont | 6627202 | 29.2 | 1016.6 ±5.1% | 968.4 ±2.2% | 0.95 |
| silesia/samba | 21606400 | 22.9 | 1577.4 ±1.0% | 1529.5 ±2.5% | 0.97 |
| silesia/sao | 7251944 | 76.2 | 881.7 ±2.3% | 955.5 ±2.0% | 1.08 |
| silesia/webster | 41458703 | 29.2 | 1000.7 ±1.2% | 947.6 ±1.0% | 0.95 |
| silesia/x-ray | 8474240 | 71.8 | 840.1 ±1.2% | 926.6 ±0.9% | 1.10 |
| silesia/xml | 5345280 | 11.9 | 2157.9 ±0.6% | 2186.7 ±7.1% | 1.01 |
| canterbury/alice29.txt | 152089 | 37.5 | 1009.6 ±0.1% | 1025.6 ±0.1% | 1.02 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1128.3 ±0.1% | 1136.9 ±0.3% | 1.01 |
| canterbury/cp.html | 24603 | 34.4 | 1265.7 ±0.3% | 1335.4 ±0.1% | 1.06 |
| canterbury/fields.c | 11150 | 30.3 | 1082.9 ±0.2% | 1120.1 ±0.3% | 1.03 |
| canterbury/grammar.lsp | 3721 | 34.8 | 799.5 ±0.2% | 823.7 ±0.2% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1351.2 ±0.1% | 1260.9 ±0.5% | 0.93 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1230.9 ±0.5% | 1257.0 ±0.4% | 1.02 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1056.6 ±0.2% | 1069.5 ±0.2% | 1.01 |
| canterbury/ptt5 | 513216 | 10.6 | 2354.9 ±0.2% | 2563.3 ±0.9% | 1.09 |
| canterbury/sum | 38240 | 35.0 | 1275.9 ±0.1% | 1293.4 ±0.1% | 1.01 |
| canterbury/xargs.1 | 4227 | 42.7 | 789.4 ±0.1% | 796.9 ±0.2% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1063.3 ±1.8% | 1044.3 ±1.7% | 0.98 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1090.9 ±0.5% | 1056.4 ±0.7% | 0.97 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1299.4 ±0.1% | 1216.6 ±0.5% | 0.94 |
| http/html-1kx1024 | 1048576 | 39.3 | 457.9 ±0.1% | 477.6 ±0.1% | 1.04 |
| http/html-16kx64 | 1048576 | 21.9 | 1272.7 ±0.2% | 1276.6 ±0.2% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1623.5 ±0.3% | 1672.4 ±0.3% | 1.03 |
| http/json-1kx1024 | 1048576 | 21.9 | 531.3 ±0.2% | 573.0 ±0.1% | 1.08 |
| http/json-16kx64 | 1048576 | 12.6 | 1661.9 ±0.3% | 1699.2 ±0.2% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1959.9 ±0.3% | 2062.9 ±0.4% | 1.05 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.1 ±0.2% | 390.4 ±0.2% | 0.97 |
| http/js-16kx64 | 1048576 | 26.0 | 1158.4 ±0.2% | 1148.1 ±0.2% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1659.1 ±0.6% | 1620.8 ±2.6% | 0.98 |
| http/css-1kx1024 | 1048576 | 29.5 | 481.8 ±0.2% | 516.7 ±0.1% | 1.07 |
| http/css-16kx64 | 1048576 | 15.9 | 1513.1 ±0.1% | 1509.8 ±0.3% | 1.00 |
| http/css-1m | 1048576 | 3.6 | 5069.7 ±0.3% | 4810.2 ±0.9% | 0.95 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1200.2 ±0.6% | 1233.4 ±0.4% | 1.03 |
