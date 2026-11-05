# bench-zstd

| Field | Value |
|---|---|
| Commit | 6347b4a |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261101.172.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/41962193660 |
| Date | 2026-11-05 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 917.1 ±2.9% | 881.8 ±2.6% | 0.96 |
| silesia/mozilla | 51220480 | 35.6 | 1165.6 ±1.9% | 1147.3 ±3.2% | 0.98 |
| silesia/mr | 9970564 | 35.6 | 1098.3 ±0.5% | 1070.9 ±0.9% | 0.98 |
| silesia/nci | 33553445 | 8.4 | 2016.3 ±2.6% | 1887.0 ±4.5% | 0.94 |
| silesia/ooffice | 6152192 | 50.8 | 974.7 ±1.7% | 990.3 ±2.0% | 1.02 |
| silesia/osdb | 10085684 | 34.7 | 1394.6 ±2.0% | 1356.4 ±1.8% | 0.97 |
| silesia/reymont | 6627202 | 29.2 | 1059.8 ±0.8% | 1020.8 ±0.6% | 0.96 |
| silesia/samba | 21606400 | 22.9 | 1571.8 ±2.3% | 1529.6 ±3.7% | 0.97 |
| silesia/sao | 7251944 | 76.2 | 867.4 ±0.6% | 940.2 ±1.2% | 1.08 |
| silesia/webster | 41458703 | 29.2 | 1030.3 ±0.8% | 970.6 ±2.1% | 0.94 |
| silesia/x-ray | 8474240 | 71.8 | 837.7 ±0.6% | 904.5 ±1.2% | 1.08 |
| silesia/xml | 5345280 | 11.9 | 2169.0 ±0.8% | 2187.1 ±1.3% | 1.01 |
| canterbury/alice29.txt | 152089 | 37.5 | 1017.2 ±0.1% | 1028.8 ±0.1% | 1.01 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1135.6 ±0.0% | 1138.7 ±0.2% | 1.00 |
| canterbury/cp.html | 24603 | 34.4 | 1266.7 ±0.4% | 1335.4 ±0.1% | 1.05 |
| canterbury/fields.c | 11150 | 30.3 | 1081.8 ±0.3% | 1133.6 ±0.1% | 1.05 |
| canterbury/grammar.lsp | 3721 | 34.8 | 796.9 ±0.2% | 822.8 ±0.2% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1360.3 ±0.3% | 1265.1 ±0.3% | 0.93 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1244.7 ±0.1% | 1253.6 ±0.4% | 1.01 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1075.2 ±0.1% | 1065.2 ±0.1% | 0.99 |
| canterbury/ptt5 | 513216 | 10.6 | 2359.1 ±0.4% | 2541.0 ±2.7% | 1.08 |
| canterbury/sum | 38240 | 35.0 | 1280.4 ±0.3% | 1297.3 ±0.0% | 1.01 |
| canterbury/xargs.1 | 4227 | 42.7 | 790.9 ±0.3% | 798.6 ±0.1% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1104.7 ±0.5% | 1059.2 ±0.7% | 0.96 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1119.7 ±1.1% | 1075.9 ±0.6% | 0.96 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1316.7 ±0.9% | 1272.9 ±1.8% | 0.97 |
| http/html-1kx1024 | 1048576 | 39.3 | 456.9 ±0.2% | 453.2 ±0.1% | 0.99 |
| http/html-16kx64 | 1048576 | 21.9 | 1275.1 ±0.1% | 1274.9 ±0.2% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1691.3 ±0.4% | 1668.9 ±0.6% | 0.99 |
| http/json-1kx1024 | 1048576 | 21.9 | 529.8 ±0.2% | 547.4 ±0.1% | 1.03 |
| http/json-16kx64 | 1048576 | 12.6 | 1650.8 ±0.1% | 1685.4 ±0.2% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1960.9 ±0.5% | 2088.4 ±0.6% | 1.07 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.0 ±0.1% | 374.2 ±0.1% | 0.93 |
| http/js-16kx64 | 1048576 | 26.0 | 1160.0 ±0.1% | 1149.9 ±0.4% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1652.5 ±0.3% | 1620.8 ±0.8% | 0.98 |
| http/css-1kx1024 | 1048576 | 29.5 | 481.3 ±0.2% | 492.0 ±0.1% | 1.02 |
| http/css-16kx64 | 1048576 | 15.9 | 1511.0 ±0.2% | 1504.1 ±0.1% | 1.00 |
| http/css-1m | 1048576 | 3.6 | 5129.5 ±0.4% | 4927.4 ±0.5% | 0.96 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1189.4 ±0.3% | 1238.5 ±0.7% | 1.04 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 236.4 ±1.4% | 909.8 ±2.9% | 3.85 |
| silesia/mozilla | 51220480 | 35.6 | 276.5 ±0.2% | 1168.2 ±1.1% | 4.22 |
| silesia/mr | 9970564 | 35.6 | 242.2 ±0.7% | 1085.0 ±3.4% | 4.48 |
| silesia/nci | 33553445 | 8.4 | 672.6 ±1.2% | 1832.2 ±1.4% | 2.72 |
| silesia/ooffice | 6152192 | 50.8 | 193.4 ±0.2% | 1001.5 ±0.5% | 5.18 |
| silesia/osdb | 10085684 | 34.7 | 299.5 ±0.5% | 1378.7 ±1.3% | 4.60 |
| silesia/reymont | 6627202 | 29.2 | 279.8 ±1.0% | 1034.2 ±4.3% | 3.70 |
| silesia/samba | 21606400 | 22.9 | 450.7 ±0.5% | 1560.6 ±2.5% | 3.46 |
| silesia/sao | 7251944 | 76.2 | 163.1 ±0.3% | 939.3 ±2.6% | 5.76 |
| silesia/webster | 41458703 | 29.2 | 280.5 ±2.4% | 992.8 ±2.9% | 3.54 |
| silesia/x-ray | 8474240 | 71.8 | 153.1 ±0.3% | 926.7 ±1.8% | 6.05 |
| silesia/xml | 5345280 | 11.9 | 623.2 ±1.2% | 2228.7 ±1.6% | 3.58 |
| canterbury/alice29.txt | 152089 | 37.5 | 221.7 ±0.1% | 1029.1 ±0.1% | 4.64 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 208.2 ±0.3% | 1140.0 ±0.2% | 5.48 |
| canterbury/cp.html | 24603 | 34.4 | 253.9 ±0.2% | 1338.9 ±0.1% | 5.27 |
| canterbury/fields.c | 11150 | 30.3 | 250.7 ±0.2% | 1131.2 ±0.3% | 4.51 |
| canterbury/grammar.lsp | 3721 | 34.8 | 214.3 ±0.4% | 822.8 ±0.1% | 3.84 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 297.2 ±0.1% | 1267.5 ±0.3% | 4.26 |
| canterbury/lcet10.txt | 426754 | 33.0 | 266.2 ±0.2% | 1265.9 ±0.3% | 4.76 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 219.2 ±0.6% | 1072.5 ±0.4% | 4.89 |
| canterbury/ptt5 | 513216 | 10.6 | 473.6 ±0.3% | 2584.0 ±1.7% | 5.46 |
| canterbury/sum | 38240 | 35.0 | 250.1 ±0.3% | 1296.9 ±0.1% | 5.19 |
| canterbury/xargs.1 | 4227 | 42.7 | 183.1 ±1.6% | 799.3 ±0.3% | 4.37 |
| canterbury-large/E.coli | 4638690 | 30.0 | 265.3 ±1.2% | 1095.0 ±0.7% | 4.13 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 295.3 ±2.7% | 1110.9 ±1.3% | 3.76 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 332.1 ±0.4% | 1309.7 ±0.5% | 3.94 |
| http/html-1kx1024 | 1048576 | 39.3 | 188.1 ±0.1% | 453.7 ±0.2% | 2.41 |
| http/html-16kx64 | 1048576 | 21.9 | 335.6 ±0.2% | 1285.4 ±0.3% | 3.83 |
| http/html-1m | 1048576 | 17.7 | 453.5 ±0.4% | 1716.7 ±0.3% | 3.79 |
| http/json-1kx1024 | 1048576 | 21.9 | 279.0 ±0.3% | 547.6 ±0.1% | 1.96 |
| http/json-16kx64 | 1048576 | 12.6 | 468.4 ±0.2% | 1691.1 ±0.3% | 3.61 |
| http/json-1m | 1048576 | 12.2 | 527.0 ±0.5% | 2092.0 ±0.7% | 3.97 |
| http/js-1kx1024 | 1048576 | 44.5 | 158.5 ±0.2% | 374.5 ±0.2% | 2.36 |
| http/js-16kx64 | 1048576 | 26.0 | 287.0 ±0.3% | 1157.2 ±0.2% | 4.03 |
| http/js-1m | 1048576 | 19.0 | 428.8 ±0.2% | 1656.6 ±0.3% | 3.86 |
| http/css-1kx1024 | 1048576 | 29.5 | 234.6 ±0.1% | 496.1 ±0.1% | 2.11 |
| http/css-16kx64 | 1048576 | 15.9 | 421.6 ±0.2% | 1503.7 ±0.5% | 3.57 |
| http/css-1m | 1048576 | 3.6 | 1776.1 ±0.4% | 4942.9 ±0.5% | 2.78 |
| shuffled/dickens-1m | 1048576 | 58.8 | 152.3 ±0.4% | 1256.2 ±0.5% | 8.25 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 940.8 ±2.9% | 0.93 ±1.1% | 1.00 ±1.6% | 0.58 ±1.2% | 0.96 ±4.6% | 0.38 ±1.2% |
| silesia/mozilla | 51220480 | 35.6 | 1182.3 ±1.3% | 0.74 ±1.0% | 1.00 ±0.7% | 0.61 ±0.8% | 0.98 ±0.7% | 0.45 ±1.3% |
| silesia/mr | 9970564 | 35.6 | 1122.1 ±1.4% | 0.81 ±1.0% | 0.99 ±1.7% | 0.56 ±0.4% | 0.96 ±0.9% | 0.38 ±1.1% |
| silesia/nci | 33553445 | 8.4 | 1893.8 ±10.4% | 0.94 ±9.8% | 0.98 ±10.9% | 0.70 ±4.4% | 0.97 ±9.3% | 0.48 ±4.2% |
| silesia/ooffice | 6152192 | 50.8 | 920.8 ±3.0% | 0.65 ±1.8% | 1.01 ±4.4% | 0.62 ±3.1% | 0.96 ±6.7% | 0.48 ±3.5% |
| silesia/osdb | 10085684 | 34.7 | 1392.7 ±12.4% | 0.67 ±6.4% | 1.00 ±2.1% | 0.68 ±1.5% | 0.97 ±2.1% | 0.46 ±2.3% |
| silesia/reymont | 6627202 | 29.2 | 1043.3 ±1.0% | 0.95 ±1.0% | 1.00 ±1.1% | 0.61 ±1.8% | 0.97 ±2.5% | 0.40 ±2.7% |
| silesia/samba | 21606400 | 22.9 | 1502.6 ±5.7% | 0.92 ±3.0% | 1.01 ±4.5% | 0.65 ±1.8% | 0.99 ±5.0% | 0.44 ±2.4% |
| silesia/sao | 7251944 | 76.2 | 942.0 ±0.5% | 0.52 ±0.6% | 1.00 ±1.6% | 0.70 ±0.8% | 0.98 ±2.2% | 0.53 ±0.7% |
| silesia/webster | 41458703 | 29.2 | 1007.5 ±2.6% | 0.93 ±4.1% | 1.00 ±4.6% | 0.63 ±1.8% | 0.98 ±2.4% | 0.42 ±1.3% |
| silesia/x-ray | 8474240 | 71.8 | 940.7 ±1.6% | 0.51 ±0.5% | 0.99 ±1.8% | 0.66 ±0.6% | 0.96 ±1.9% | 0.48 ±0.3% |
| silesia/xml | 5345280 | 11.9 | 2220.8 ±1.2% | 0.92 ±1.0% | 1.00 ±1.3% | 0.61 ±0.3% | 0.99 ±1.3% | 0.41 ±2.4% |
| canterbury/alice29.txt | 152089 | 37.5 | 1029.2 ±0.2% | 0.94 ±0.2% | 1.00 ±0.2% | 0.53 ±0.1% | 0.99 ±0.1% | 0.36 ±0.6% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1139.7 ±0.2% | 0.85 ±0.1% | 0.98 ±0.1% | 0.51 ±0.1% | 0.99 ±0.1% | 0.37 ±0.3% |
| canterbury/cp.html | 24603 | 34.4 | 1339.7 ±0.2% | 0.63 ±0.4% | 1.00 ±0.1% | 0.61 ±0.2% | 0.99 ±0.4% | 0.45 ±0.4% |
| canterbury/fields.c | 11150 | 30.3 | 1132.3 ±0.1% | 0.81 ±0.1% | 1.00 ±0.3% | 0.59 ±0.6% | 0.99 ±0.3% | 0.41 ±0.2% |
| canterbury/grammar.lsp | 3721 | 34.8 | 823.8 ±0.3% | 0.79 ±0.1% | 1.00 ±0.1% | 0.67 ±1.0% | 0.99 ±0.1% | 0.49 ±0.4% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1269.5 ±0.3% | 0.86 ±1.2% | 1.01 ±0.5% | 0.58 ±0.5% | 1.00 ±0.4% | 0.39 ±1.1% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1264.6 ±0.2% | 0.89 ±0.1% | 1.00 ±0.1% | 0.53 ±0.2% | 0.99 ±1.7% | 0.36 ±0.5% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1074.9 ±0.2% | 0.91 ±0.2% | 0.99 ±0.1% | 0.52 ±0.2% | 0.99 ±0.2% | 0.36 ±0.7% |
| canterbury/ptt5 | 513216 | 10.6 | 2574.4 ±0.6% | 0.81 ±1.0% | 1.02 ±1.3% | 0.55 ±0.2% | 1.01 ±1.0% | 0.44 ±0.5% |
| canterbury/sum | 38240 | 35.0 | 1298.7 ±0.1% | 0.63 ±0.0% | 1.00 ±0.4% | 0.62 ±0.3% | 0.99 ±0.2% | 0.45 ±0.2% |
| canterbury/xargs.1 | 4227 | 42.7 | 799.5 ±0.3% | 0.74 ±0.3% | 1.00 ±0.1% | 0.64 ±0.4% | 0.99 ±0.5% | 0.47 ±0.5% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1095.7 ±1.7% | 0.98 ±0.6% | 1.00 ±1.1% | 0.58 ±1.0% | 0.97 ±0.9% | 0.36 ±1.1% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1117.4 ±2.2% | 0.96 ±0.8% | 1.00 ±0.6% | 0.60 ±0.5% | 0.97 ±2.4% | 0.38 ±2.2% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1305.6 ±0.7% | 0.90 ±0.8% | 1.00 ±0.5% | 0.60 ±0.7% | 0.98 ±1.2% | 0.41 ±0.8% |
| http/html-1kx1024 | 1048576 | 39.3 | 452.5 ±0.2% | 0.87 ±0.2% | 1.00 ±0.1% | 0.79 ±0.1% | 1.00 ±0.2% | 0.67 ±0.3% |
| http/html-16kx64 | 1048576 | 21.9 | 1281.1 ±0.4% | 0.83 ±0.2% | 1.00 ±0.2% | 0.62 ±0.2% | 0.99 ±0.3% | 0.46 ±0.3% |
| http/html-1m | 1048576 | 17.7 | 1709.7 ±0.4% | 0.94 ±0.4% | 1.00 ±0.5% | 0.59 ±0.5% | 0.99 ±0.8% | 0.40 ±0.5% |
| http/json-1kx1024 | 1048576 | 21.9 | 546.5 ±0.1% | 0.98 ±0.1% | 1.00 ±0.1% | 0.81 ±0.1% | 0.98 ±0.0% | 0.68 ±0.1% |
| http/json-16kx64 | 1048576 | 12.6 | 1691.7 ±0.4% | 0.85 ±0.1% | 1.00 ±0.2% | 0.64 ±0.2% | 0.99 ±0.5% | 0.47 ±0.3% |
| http/json-1m | 1048576 | 12.2 | 2100.5 ±0.4% | 0.88 ±0.6% | 1.00 ±0.8% | 0.58 ±0.4% | 0.99 ±0.3% | 0.41 ±0.8% |
| http/js-1kx1024 | 1048576 | 44.5 | 374.0 ±0.3% | 0.86 ±0.1% | 1.00 ±0.1% | 0.79 ±0.1% | 1.00 ±0.1% | 0.68 ±0.1% |
| http/js-16kx64 | 1048576 | 26.0 | 1154.3 ±0.1% | 0.82 ±0.2% | 1.00 ±0.2% | 0.61 ±0.2% | 0.99 ±0.2% | 0.45 ±0.1% |
| http/js-1m | 1048576 | 19.0 | 1656.2 ±0.7% | 0.91 ±0.5% | 1.00 ±0.2% | 0.59 ±1.1% | 0.99 ±0.4% | 0.40 ±0.5% |
| http/css-1kx1024 | 1048576 | 29.5 | 495.6 ±0.1% | 0.95 ±0.3% | 1.00 ±0.1% | 0.79 ±0.3% | 0.99 ±0.1% | 0.67 ±0.1% |
| http/css-16kx64 | 1048576 | 15.9 | 1505.1 ±0.1% | 0.89 ±0.1% | 1.00 ±0.1% | 0.64 ±0.1% | 0.99 ±0.1% | 0.45 ±0.4% |
| http/css-1m | 1048576 | 3.6 | 4915.4 ±0.7% | 0.96 ±0.8% | 1.01 ±0.8% | 0.70 ±0.7% | 1.00 ±0.6% | 0.46 ±0.5% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1250.7 ±0.4% | 0.52 ±0.2% | 0.86 ±0.5% | 0.74 ±0.5% | 0.98 ±0.5% | 0.56 ±0.3% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 332.8 ± 0.4% | 132.8 ± 0.4% | 0.40 |
| silesia/dickens | 10192446 | 3 | 151.1 ± 0.4% | 94.0 ± 0.6% | 0.62 |
| silesia/mozilla | 51220480 | 1 | 480.1 ± 0.3% | 187.5 ± 0.4% | 0.39 |
| silesia/mozilla | 51220480 | 3 | 200.2 ± 0.6% | 111.7 ± 0.5% | 0.56 |
| silesia/mr | 9970564 | 1 | 439.0 ± 0.2% | 162.1 ± 0.6% | 0.37 |
| silesia/mr | 9970564 | 3 | 168.7 ± 0.9% | 99.8 ± 0.9% | 0.59 |
| silesia/nci | 33553445 | 1 | 952.4 ± 0.1% | 410.8 ± 0.4% | 0.43 |
| silesia/nci | 33553445 | 3 | 624.1 ± 1.2% | 289.0 ± 1.5% | 0.46 |
| silesia/ooffice | 6152192 | 1 | 392.8 ± 0.4% | 143.2 ± 0.6% | 0.36 |
| silesia/ooffice | 6152192 | 3 | 142.6 ± 0.3% | 81.4 ± 0.7% | 0.57 |
| silesia/osdb | 10085684 | 1 | 473.8 ± 0.3% | 198.7 ± 0.3% | 0.42 |
| silesia/osdb | 10085684 | 3 | 190.1 ± 1.1% | 107.2 ± 0.9% | 0.56 |
| silesia/reymont | 6627202 | 1 | 344.1 ± 0.6% | 161.1 ± 0.5% | 0.47 |
| silesia/reymont | 6627202 | 3 | 187.6 ± 0.9% | 118.3 ± 0.5% | 0.63 |
| silesia/samba | 21606400 | 1 | 565.4 ± 1.0% | 240.0 ± 0.4% | 0.42 |
| silesia/samba | 21606400 | 3 | 284.4 ± 1.6% | 163.5 ± 0.4% | 0.57 |
| silesia/sao | 7251944 | 1 | 371.7 ± 0.1% | 125.7 ± 0.6% | 0.34 |
| silesia/sao | 7251944 | 3 | 107.3 ± 0.6% | 66.5 ± 0.9% | 0.62 |
| silesia/webster | 41458703 | 1 | 385.6 ± 0.9% | 157.7 ± 0.5% | 0.41 |
| silesia/webster | 41458703 | 3 | 178.5 ± 1.0% | 108.1 ± 0.4% | 0.61 |
| silesia/x-ray | 8474240 | 1 | 710.8 ± 0.4% | 138.1 ± 0.7% | 0.19 |
| silesia/x-ray | 8474240 | 3 | 105.4 ± 0.6% | 71.7 ± 0.8% | 0.68 |
| silesia/xml | 5345280 | 1 | 793.2 ± 0.9% | 311.6 ± 0.7% | 0.39 |
| silesia/xml | 5345280 | 3 | 499.4 ± 1.9% | 256.5 ± 1.1% | 0.51 |
| canterbury/alice29.txt | 152089 | 1 | 311.8 ± 0.6% | 143.5 ± 0.3% | 0.46 |
| canterbury/alice29.txt | 152089 | 3 | 219.3 ± 0.2% | 123.6 ± 0.3% | 0.56 |
| canterbury/asyoulik.txt | 125179 | 1 | 347.9 ± 0.1% | 136.5 ± 0.4% | 0.39 |
| canterbury/asyoulik.txt | 125179 | 3 | 218.8 ± 0.4% | 116.5 ± 0.5% | 0.53 |
| canterbury/cp.html | 24603 | 1 | 490.8 ± 0.2% | 204.7 ± 0.4% | 0.42 |
| canterbury/cp.html | 24603 | 3 | 371.4 ± 0.3% | 178.2 ± 0.6% | 0.48 |
| canterbury/fields.c | 11150 | 1 | 385.0 ± 0.2% | 192.8 ± 0.4% | 0.50 |
| canterbury/fields.c | 11150 | 3 | 374.5 ± 0.8% | 190.0 ± 0.6% | 0.51 |
| canterbury/grammar.lsp | 3721 | 1 | 358.5 ± 0.4% | 163.0 ± 0.4% | 0.45 |
| canterbury/grammar.lsp | 3721 | 3 | 319.4 ± 0.1% | 155.0 ± 0.3% | 0.49 |
| canterbury/kennedy.xls | 1029744 | 1 | 563.4 ± 0.4% | 219.8 ± 0.5% | 0.39 |
| canterbury/kennedy.xls | 1029744 | 3 | 397.6 ± 0.2% | 162.5 ± 0.7% | 0.41 |
| canterbury/lcet10.txt | 426754 | 1 | 342.9 ± 0.2% | 150.5 ± 0.5% | 0.44 |
| canterbury/lcet10.txt | 426754 | 3 | 205.1 ± 0.7% | 123.0 ± 0.9% | 0.60 |
| canterbury/plrabn12.txt | 481861 | 1 | 326.3 ± 0.4% | 128.6 ± 0.7% | 0.39 |
| canterbury/plrabn12.txt | 481861 | 3 | 164.1 ± 0.4% | 102.9 ± 0.4% | 0.63 |
| canterbury/ptt5 | 513216 | 1 | 1083.1 ± 0.1% | 424.1 ± 1.0% | 0.39 |
| canterbury/ptt5 | 513216 | 3 | 683.6 ± 0.5% | 345.3 ± 1.1% | 0.51 |
| canterbury/sum | 38240 | 1 | 523.8 ± 0.1% | 196.2 ± 0.4% | 0.37 |
| canterbury/sum | 38240 | 3 | 377.1 ± 1.3% | 168.2 ± 0.6% | 0.45 |
| canterbury/xargs.1 | 4227 | 1 | 337.9 ± 0.2% | 157.3 ± 0.1% | 0.47 |
| canterbury/xargs.1 | 4227 | 3 | 281.8 ± 0.8% | 144.8 ± 0.4% | 0.51 |
| canterbury-large/E.coli | 4638690 | 1 | 320.8 ± 0.2% | 146.1 ± 0.3% | 0.46 |
| canterbury-large/E.coli | 4638690 | 3 | 222.4 ± 1.3% | 135.7 ± 1.4% | 0.61 |
| canterbury-large/bible.txt | 4047392 | 1 | 342.8 ± 0.1% | 159.4 ± 0.2% | 0.46 |
| canterbury-large/bible.txt | 4047392 | 3 | 186.8 ± 1.0% | 118.9 ± 1.9% | 0.64 |
| canterbury-large/world192.txt | 2473400 | 1 | 412.6 ± 0.2% | 172.7 ± 0.3% | 0.42 |
| canterbury-large/world192.txt | 2473400 | 3 | 217.9 ± 1.0% | 132.5 ± 0.6% | 0.61 |
| http/html-1kx1024 | 1048576 | 1 | 198.6 ± 0.2% | 93.4 ± 0.4% | 0.47 |
| http/html-1kx1024 | 1048576 | 3 | 176.1 ± 0.1% | 87.4 ± 0.3% | 0.50 |
| http/html-16kx64 | 1048576 | 1 | 437.0 ± 0.2% | 230.1 ± 0.4% | 0.53 |
| http/html-16kx64 | 1048576 | 3 | 378.6 ± 0.4% | 210.1 ± 0.4% | 0.56 |
| http/html-1m | 1048576 | 1 | 536.1 ± 0.3% | 248.7 ± 0.5% | 0.46 |
| http/html-1m | 1048576 | 3 | 356.7 ± 0.7% | 205.6 ± 1.3% | 0.58 |
| http/json-1kx1024 | 1048576 | 1 | 236.6 ± 0.1% | 113.4 ± 0.3% | 0.48 |
| http/json-1kx1024 | 1048576 | 3 | 227.9 ± 0.1% | 107.9 ± 0.6% | 0.47 |
| http/json-16kx64 | 1048576 | 1 | 705.6 ± 0.2% | 337.9 ± 0.2% | 0.48 |
| http/json-16kx64 | 1048576 | 3 | 624.2 ± 0.1% | 307.6 ± 1.0% | 0.49 |
| http/json-1m | 1048576 | 1 | 835.9 ± 0.6% | 355.9 ± 0.5% | 0.43 |
| http/json-1m | 1048576 | 3 | 536.3 ± 0.3% | 287.7 ± 0.4% | 0.54 |
| http/js-1kx1024 | 1048576 | 1 | 182.6 ± 0.5% | 83.6 ± 0.5% | 0.46 |
| http/js-1kx1024 | 1048576 | 3 | 156.9 ± 0.2% | 78.2 ± 0.2% | 0.50 |
| http/js-16kx64 | 1048576 | 1 | 381.1 ± 0.2% | 195.8 ± 0.2% | 0.51 |
| http/js-16kx64 | 1048576 | 3 | 329.3 ± 0.2% | 180.7 ± 0.3% | 0.55 |
| http/js-1m | 1048576 | 1 | 510.1 ± 0.1% | 229.5 ± 0.6% | 0.45 |
| http/js-1m | 1048576 | 3 | 334.1 ± 0.5% | 191.4 ± 0.8% | 0.57 |
| http/css-1kx1024 | 1048576 | 1 | 217.5 ± 0.1% | 103.0 ± 0.3% | 0.47 |
| http/css-1kx1024 | 1048576 | 3 | 202.0 ± 0.9% | 97.8 ± 0.3% | 0.48 |
| http/css-16kx64 | 1048576 | 1 | 547.9 ± 0.2% | 257.3 ± 0.3% | 0.47 |
| http/css-16kx64 | 1048576 | 3 | 509.7 ± 0.3% | 246.3 ± 1.1% | 0.48 |
| http/css-1m | 1048576 | 1 | 2289.0 ± 0.4% | 821.4 ± 0.6% | 0.36 |
| http/css-1m | 1048576 | 3 | 1719.7 ± 0.5% | 826.5 ± 0.7% | 0.48 |
| shuffled/dickens-1m | 1048576 | 1 | 960.3 ± 0.4% | 363.9 ± 1.1% | 0.38 |
| shuffled/dickens-1m | 1048576 | 3 | 115.7 ± 0.7% | 159.7 ± 0.3% | 1.38 |

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
| silesia/dickens | 10192446 | 35.9 | 917.0 ±4.4% | 893.4 ±2.3% | 0.97 |
| silesia/mozilla | 51220480 | 35.6 | 1163.1 ±0.5% | 1164.0 ±0.9% | 1.00 |
| silesia/mr | 9970564 | 35.6 | 1054.9 ±2.1% | 1056.1 ±1.8% | 1.00 |
| silesia/nci | 33553445 | 8.4 | 1956.1 ±2.1% | 1815.1 ±1.7% | 0.93 |
| silesia/ooffice | 6152192 | 50.8 | 960.0 ±0.4% | 978.4 ±1.6% | 1.02 |
| silesia/osdb | 10085684 | 34.7 | 1366.2 ±1.1% | 1328.3 ±1.6% | 0.97 |
| silesia/reymont | 6627202 | 29.2 | 1042.9 ±1.5% | 988.5 ±0.8% | 0.95 |
| silesia/samba | 21606400 | 22.9 | 1538.3 ±0.7% | 1466.2 ±2.3% | 0.95 |
| silesia/sao | 7251944 | 76.2 | 858.1 ±1.6% | 939.1 ±2.7% | 1.09 |
| silesia/webster | 41458703 | 29.2 | 1029.9 ±3.8% | 980.5 ±2.8% | 0.95 |
| silesia/x-ray | 8474240 | 71.8 | 841.1 ±0.4% | 926.5 ±0.9% | 1.10 |
| silesia/xml | 5345280 | 11.9 | 2176.7 ±0.5% | 2189.2 ±1.1% | 1.01 |
| canterbury/alice29.txt | 152089 | 37.5 | 1011.8 ±0.3% | 1025.3 ±0.2% | 1.01 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1127.4 ±0.1% | 1136.6 ±0.3% | 1.01 |
| canterbury/cp.html | 24603 | 34.4 | 1270.0 ±0.3% | 1331.8 ±0.1% | 1.05 |
| canterbury/fields.c | 11150 | 30.3 | 1081.7 ±0.1% | 1120.0 ±0.2% | 1.04 |
| canterbury/grammar.lsp | 3721 | 34.8 | 800.3 ±0.1% | 823.0 ±0.2% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1351.6 ±0.2% | 1267.7 ±0.5% | 0.94 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1236.2 ±0.3% | 1230.3 ±0.4% | 1.00 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1063.8 ±0.4% | 1061.3 ±0.9% | 1.00 |
| canterbury/ptt5 | 513216 | 10.6 | 2365.0 ±0.4% | 2552.4 ±1.7% | 1.08 |
| canterbury/sum | 38240 | 35.0 | 1275.9 ±0.1% | 1292.3 ±0.1% | 1.01 |
| canterbury/xargs.1 | 4227 | 42.7 | 788.8 ±0.2% | 795.7 ±0.1% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1076.0 ±1.1% | 1053.5 ±0.6% | 0.98 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1122.1 ±0.4% | 1084.8 ±0.9% | 0.97 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1323.1 ±0.5% | 1269.8 ±0.2% | 0.96 |
| http/html-1kx1024 | 1048576 | 39.3 | 458.0 ±0.1% | 477.8 ±0.2% | 1.04 |
| http/html-16kx64 | 1048576 | 21.9 | 1272.1 ±0.2% | 1276.2 ±0.1% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1675.0 ±0.5% | 1695.3 ±0.3% | 1.01 |
| http/json-1kx1024 | 1048576 | 21.9 | 531.7 ±0.1% | 573.5 ±0.0% | 1.08 |
| http/json-16kx64 | 1048576 | 12.6 | 1661.9 ±0.1% | 1690.9 ±0.2% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1969.3 ±0.2% | 2085.7 ±0.3% | 1.06 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.5 ±0.2% | 391.2 ±0.2% | 0.97 |
| http/js-16kx64 | 1048576 | 26.0 | 1159.9 ±0.2% | 1148.6 ±0.2% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1672.7 ±0.4% | 1619.2 ±0.4% | 0.97 |
| http/css-1kx1024 | 1048576 | 29.5 | 482.3 ±0.2% | 518.5 ±0.3% | 1.08 |
| http/css-16kx64 | 1048576 | 15.9 | 1512.6 ±0.1% | 1507.3 ±0.1% | 1.00 |
| http/css-1m | 1048576 | 3.6 | 5118.5 ±0.4% | 4879.4 ±0.5% | 0.95 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1203.7 ±0.3% | 1236.0 ±0.3% | 1.03 |
