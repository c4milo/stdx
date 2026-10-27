# bench-zstd

| Field | Value |
|---|---|
| Commit | 8f8e979 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261023.149.3 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/40578095901 |
| Date | 2026-10-27 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 961.5 ±0.5% | 927.5 ±1.1% | 0.96 |
| silesia/mozilla | 51220480 | 35.6 | 1184.1 ±0.4% | 1181.1 ±1.2% | 1.00 |
| silesia/mr | 9970564 | 35.6 | 1100.6 ±0.9% | 1091.1 ±2.0% | 0.99 |
| silesia/nci | 33553445 | 8.4 | 2049.3 ±3.4% | 1917.9 ±10.9% | 0.94 |
| silesia/ooffice | 6152192 | 50.8 | 980.9 ±0.5% | 1003.6 ±0.7% | 1.02 |
| silesia/osdb | 10085684 | 34.7 | 1422.8 ±1.2% | 1372.2 ±0.9% | 0.96 |
| silesia/reymont | 6627202 | 29.2 | 1077.4 ±0.2% | 1028.7 ±0.4% | 0.95 |
| silesia/samba | 21606400 | 22.9 | 1647.0 ±1.6% | 1597.8 ±1.0% | 0.97 |
| silesia/sao | 7251944 | 76.2 | 893.6 ±0.5% | 969.8 ±0.8% | 1.09 |
| silesia/webster | 41458703 | 29.2 | 1061.5 ±0.8% | 994.3 ±1.3% | 0.94 |
| silesia/x-ray | 8474240 | 71.8 | 846.7 ±0.6% | 943.6 ±0.8% | 1.11 |
| silesia/xml | 5345280 | 11.9 | 2193.0 ±0.5% | 2230.2 ±0.2% | 1.02 |
| canterbury/alice29.txt | 152089 | 37.5 | 1001.9 ±0.1% | 1026.4 ±0.2% | 1.02 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1117.9 ±0.2% | 1137.0 ±0.0% | 1.02 |
| canterbury/cp.html | 24603 | 34.4 | 1266.2 ±0.3% | 1335.5 ±0.2% | 1.05 |
| canterbury/fields.c | 11150 | 30.3 | 1076.6 ±0.1% | 1127.3 ±0.1% | 1.05 |
| canterbury/grammar.lsp | 3721 | 34.8 | 797.9 ±0.2% | 824.1 ±0.4% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1352.0 ±0.1% | 1272.5 ±0.4% | 0.94 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1228.8 ±0.1% | 1255.1 ±0.8% | 1.02 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1051.8 ±0.2% | 1062.8 ±0.4% | 1.01 |
| canterbury/ptt5 | 513216 | 10.6 | 2362.7 ±0.1% | 2573.6 ±2.7% | 1.09 |
| canterbury/sum | 38240 | 35.0 | 1276.1 ±0.4% | 1294.8 ±0.2% | 1.01 |
| canterbury/xargs.1 | 4227 | 42.7 | 786.6 ±0.1% | 796.1 ±0.2% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1089.5 ±0.4% | 1083.4 ±0.6% | 0.99 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1124.5 ±0.6% | 1107.4 ±1.3% | 0.98 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1320.5 ±0.8% | 1282.9 ±0.5% | 0.97 |
| http/html-1kx1024 | 1048576 | 39.3 | 457.4 ±0.1% | 451.3 ±0.1% | 0.99 |
| http/html-16kx64 | 1048576 | 21.9 | 1269.0 ±0.2% | 1268.0 ±0.4% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1682.3 ±0.4% | 1698.4 ±0.5% | 1.01 |
| http/json-1kx1024 | 1048576 | 21.9 | 530.5 ±0.1% | 541.8 ±0.1% | 1.02 |
| http/json-16kx64 | 1048576 | 12.6 | 1653.1 ±0.3% | 1680.6 ±0.2% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1974.3 ±0.2% | 2069.5 ±0.7% | 1.05 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.3 ±0.1% | 373.3 ±0.1% | 0.93 |
| http/js-16kx64 | 1048576 | 26.0 | 1153.3 ±0.2% | 1144.2 ±0.4% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1676.6 ±0.4% | 1604.2 ±0.6% | 0.96 |
| http/css-1kx1024 | 1048576 | 29.5 | 481.7 ±0.2% | 492.6 ±0.1% | 1.02 |
| http/css-16kx64 | 1048576 | 15.9 | 1515.0 ±0.1% | 1491.9 ±0.2% | 0.98 |
| http/css-1m | 1048576 | 3.6 | 5177.5 ±0.3% | 4914.5 ±0.8% | 0.95 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1200.6 ±0.1% | 1226.8 ±0.6% | 1.02 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 242.5 ±0.9% | 937.2 ±0.8% | 3.86 |
| silesia/mozilla | 51220480 | 35.6 | 277.8 ±0.3% | 1185.4 ±1.5% | 4.27 |
| silesia/mr | 9970564 | 35.6 | 245.3 ±0.9% | 1120.3 ±0.7% | 4.57 |
| silesia/nci | 33553445 | 8.4 | 684.5 ±1.7% | 1978.1 ±8.0% | 2.89 |
| silesia/ooffice | 6152192 | 50.8 | 194.0 ±0.4% | 1012.2 ±0.8% | 5.22 |
| silesia/osdb | 10085684 | 34.7 | 305.6 ±0.7% | 1435.1 ±0.8% | 4.70 |
| silesia/reymont | 6627202 | 29.2 | 291.8 ±1.9% | 1053.9 ±0.9% | 3.61 |
| silesia/samba | 21606400 | 22.9 | 453.9 ±0.6% | 1596.3 ±1.3% | 3.52 |
| silesia/sao | 7251944 | 76.2 | 163.6 ±0.3% | 950.9 ±2.1% | 5.81 |
| silesia/webster | 41458703 | 29.2 | 285.2 ±1.3% | 1017.1 ±1.3% | 3.57 |
| silesia/x-ray | 8474240 | 71.8 | 153.1 ±0.2% | 947.4 ±0.5% | 6.19 |
| silesia/xml | 5345280 | 11.9 | 632.5 ±0.3% | 2245.9 ±0.3% | 3.55 |
| canterbury/alice29.txt | 152089 | 37.5 | 223.0 ±0.1% | 1026.8 ±0.1% | 4.60 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 208.8 ±0.4% | 1137.3 ±0.1% | 5.45 |
| canterbury/cp.html | 24603 | 34.4 | 253.8 ±0.4% | 1333.6 ±0.1% | 5.25 |
| canterbury/fields.c | 11150 | 30.3 | 251.1 ±0.3% | 1128.3 ±0.1% | 4.49 |
| canterbury/grammar.lsp | 3721 | 34.8 | 215.2 ±0.4% | 824.8 ±0.2% | 3.83 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 299.6 ±0.4% | 1270.9 ±0.6% | 4.24 |
| canterbury/lcet10.txt | 426754 | 33.0 | 267.8 ±0.3% | 1258.8 ±0.3% | 4.70 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 220.8 ±0.3% | 1071.2 ±0.2% | 4.85 |
| canterbury/ptt5 | 513216 | 10.6 | 476.1 ±0.2% | 2578.5 ±1.6% | 5.42 |
| canterbury/sum | 38240 | 35.0 | 250.3 ±0.2% | 1295.9 ±0.2% | 5.18 |
| canterbury/xargs.1 | 4227 | 42.7 | 182.9 ±0.2% | 796.9 ±0.1% | 4.36 |
| canterbury-large/E.coli | 4638690 | 30.0 | 268.6 ±0.9% | 1104.7 ±0.7% | 4.11 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 303.3 ±0.5% | 1124.4 ±0.5% | 3.71 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 335.2 ±0.4% | 1329.3 ±0.7% | 3.97 |
| http/html-1kx1024 | 1048576 | 39.3 | 187.3 ±0.0% | 451.6 ±0.1% | 2.41 |
| http/html-16kx64 | 1048576 | 21.9 | 335.6 ±0.3% | 1277.3 ±0.2% | 3.81 |
| http/html-1m | 1048576 | 17.7 | 456.0 ±0.3% | 1721.0 ±0.4% | 3.77 |
| http/json-1kx1024 | 1048576 | 21.9 | 279.1 ±0.1% | 543.7 ±0.1% | 1.95 |
| http/json-16kx64 | 1048576 | 12.6 | 469.4 ±0.2% | 1690.9 ±0.3% | 3.60 |
| http/json-1m | 1048576 | 12.2 | 530.1 ±0.2% | 2110.6 ±0.4% | 3.98 |
| http/js-1kx1024 | 1048576 | 44.5 | 158.2 ±0.1% | 374.0 ±0.2% | 2.36 |
| http/js-16kx64 | 1048576 | 26.0 | 287.1 ±0.3% | 1152.8 ±0.4% | 4.01 |
| http/js-1m | 1048576 | 19.0 | 430.8 ±0.2% | 1664.9 ±0.5% | 3.86 |
| http/css-1kx1024 | 1048576 | 29.5 | 234.2 ±0.4% | 493.3 ±0.1% | 2.11 |
| http/css-16kx64 | 1048576 | 15.9 | 423.1 ±0.3% | 1490.9 ±0.1% | 3.52 |
| http/css-1m | 1048576 | 3.6 | 1788.0 ±0.5% | 4932.3 ±0.5% | 2.76 |
| shuffled/dickens-1m | 1048576 | 58.8 | 152.6 ±0.8% | 1256.1 ±0.2% | 8.23 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 950.4 ±2.7% | 0.92 ±2.5% | 0.99 ±2.6% | 0.58 ±2.4% | 0.96 ±2.6% | 0.38 ±2.1% |
| silesia/mozilla | 51220480 | 35.6 | 1174.2 ±0.7% | 0.74 ±0.8% | 1.00 ±1.0% | 0.61 ±0.9% | 0.98 ±0.6% | 0.45 ±1.3% |
| silesia/mr | 9970564 | 35.6 | 1112.6 ±0.5% | 0.81 ±1.9% | 1.00 ±1.1% | 0.56 ±1.6% | 0.96 ±5.0% | 0.38 ±0.9% |
| silesia/nci | 33553445 | 8.4 | 1866.6 ±3.3% | 0.94 ±2.1% | 1.01 ±3.7% | 0.71 ±0.7% | 0.99 ±2.5% | 0.49 ±1.0% |
| silesia/ooffice | 6152192 | 50.8 | 1007.3 ±0.6% | 0.62 ±1.4% | 1.00 ±1.1% | 0.59 ±0.8% | 0.98 ±1.4% | 0.45 ±2.3% |
| silesia/osdb | 10085684 | 34.7 | 1407.6 ±1.9% | 0.67 ±2.3% | 1.01 ±2.6% | 0.68 ±1.7% | 0.96 ±1.1% | 0.45 ±1.5% |
| silesia/reymont | 6627202 | 29.2 | 1051.7 ±0.6% | 0.95 ±0.4% | 1.00 ±1.1% | 0.61 ±0.5% | 0.97 ±1.5% | 0.40 ±2.7% |
| silesia/samba | 21606400 | 22.9 | 1534.0 ±4.7% | 0.92 ±2.8% | 0.98 ±2.4% | 0.64 ±1.4% | 0.97 ±5.5% | 0.43 ±3.1% |
| silesia/sao | 7251944 | 76.2 | 937.8 ±2.0% | 0.52 ±0.9% | 1.00 ±1.2% | 0.70 ±1.0% | 0.97 ±1.6% | 0.53 ±0.6% |
| silesia/webster | 41458703 | 29.2 | 999.5 ±1.1% | 0.93 ±0.9% | 1.01 ±1.2% | 0.63 ±0.6% | 0.98 ±1.2% | 0.42 ±0.9% |
| silesia/x-ray | 8474240 | 71.8 | 938.2 ±1.1% | 0.51 ±1.2% | 1.00 ±1.6% | 0.65 ±0.7% | 0.96 ±1.4% | 0.48 ±0.4% |
| silesia/xml | 5345280 | 11.9 | 2232.4 ±0.4% | 0.92 ±0.7% | 0.99 ±1.1% | 0.61 ±0.3% | 0.99 ±0.4% | 0.41 ±0.5% |
| canterbury/alice29.txt | 152089 | 37.5 | 1025.9 ±0.1% | 0.94 ±0.4% | 1.00 ±0.1% | 0.53 ±0.1% | 0.99 ±0.1% | 0.36 ±0.1% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1134.0 ±0.1% | 0.85 ±0.2% | 0.98 ±0.1% | 0.51 ±0.1% | 0.99 ±0.0% | 0.37 ±0.1% |
| canterbury/cp.html | 24603 | 34.4 | 1337.7 ±0.3% | 0.63 ±0.2% | 1.00 ±0.2% | 0.63 ±0.4% | 0.98 ±0.3% | 0.45 ±0.2% |
| canterbury/fields.c | 11150 | 30.3 | 1128.9 ±0.2% | 0.81 ±0.4% | 1.00 ±0.1% | 0.59 ±0.6% | 0.99 ±0.1% | 0.41 ±0.4% |
| canterbury/grammar.lsp | 3721 | 34.8 | 825.4 ±0.1% | 0.79 ±0.1% | 1.00 ±0.2% | 0.67 ±0.5% | 0.99 ±0.2% | 0.49 ±0.2% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1270.0 ±0.4% | 0.86 ±0.7% | 1.01 ±0.5% | 0.58 ±0.3% | 1.00 ±0.4% | 0.38 ±0.4% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1258.6 ±0.2% | 0.89 ±0.4% | 1.00 ±0.2% | 0.54 ±0.2% | 0.99 ±0.2% | 0.36 ±0.2% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1071.4 ±0.6% | 0.91 ±0.2% | 0.99 ±0.1% | 0.52 ±0.3% | 0.99 ±0.7% | 0.36 ±0.3% |
| canterbury/ptt5 | 513216 | 10.6 | 2529.9 ±1.1% | 0.81 ±1.3% | 1.01 ±2.0% | 0.56 ±0.2% | 1.00 ±2.4% | 0.44 ±0.2% |
| canterbury/sum | 38240 | 35.0 | 1295.1 ±0.4% | 0.63 ±0.4% | 1.00 ±0.2% | 0.63 ±0.6% | 0.99 ±0.2% | 0.45 ±0.1% |
| canterbury/xargs.1 | 4227 | 42.7 | 797.5 ±0.2% | 0.74 ±0.1% | 1.00 ±0.0% | 0.65 ±0.5% | 0.99 ±0.2% | 0.47 ±0.1% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1062.2 ±0.6% | 1.01 ±0.9% | 1.03 ±0.2% | 0.60 ±1.4% | 1.00 ±1.2% | 0.36 ±1.0% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1118.7 ±1.8% | 0.96 ±1.6% | 1.00 ±1.2% | 0.61 ±0.7% | 0.97 ±1.0% | 0.38 ±1.3% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1316.7 ±0.9% | 0.90 ±0.8% | 1.00 ±0.7% | 0.60 ±0.4% | 0.98 ±1.1% | 0.41 ±0.9% |
| http/html-1kx1024 | 1048576 | 39.3 | 452.7 ±0.2% | 0.86 ±0.1% | 1.00 ±0.1% | 0.79 ±0.2% | 0.99 ±0.2% | 0.67 ±0.2% |
| http/html-16kx64 | 1048576 | 21.9 | 1275.5 ±0.3% | 0.83 ±0.3% | 1.00 ±0.3% | 0.63 ±0.1% | 0.99 ±0.3% | 0.46 ±0.2% |
| http/html-1m | 1048576 | 17.7 | 1716.5 ±0.5% | 0.94 ±0.4% | 1.00 ±0.7% | 0.59 ±0.8% | 0.99 ±0.5% | 0.39 ±0.3% |
| http/json-1kx1024 | 1048576 | 21.9 | 545.1 ±1.5% | 0.98 ±0.1% | 1.00 ±0.1% | 0.81 ±0.1% | 0.99 ±0.1% | 0.68 ±0.1% |
| http/json-16kx64 | 1048576 | 12.6 | 1686.0 ±0.2% | 0.85 ±0.3% | 1.00 ±0.3% | 0.64 ±0.2% | 0.99 ±0.2% | 0.47 ±0.2% |
| http/json-1m | 1048576 | 12.2 | 2101.9 ±0.6% | 0.88 ±0.7% | 1.00 ±0.4% | 0.58 ±1.0% | 0.99 ±0.7% | 0.40 ±1.0% |
| http/js-1kx1024 | 1048576 | 44.5 | 374.5 ±0.1% | 0.86 ±0.2% | 1.00 ±0.1% | 0.78 ±0.1% | 0.99 ±0.2% | 0.67 ±0.1% |
| http/js-16kx64 | 1048576 | 26.0 | 1148.4 ±0.4% | 0.82 ±0.3% | 1.00 ±0.5% | 0.61 ±0.1% | 0.99 ±0.1% | 0.45 ±0.5% |
| http/js-1m | 1048576 | 19.0 | 1654.2 ±0.3% | 0.92 ±0.1% | 1.00 ±0.4% | 0.60 ±0.2% | 0.99 ±0.2% | 0.40 ±0.4% |
| http/css-1kx1024 | 1048576 | 29.5 | 492.6 ±0.1% | 0.95 ±0.1% | 1.00 ±0.2% | 0.80 ±0.1% | 0.99 ±0.0% | 0.67 ±0.0% |
| http/css-16kx64 | 1048576 | 15.9 | 1494.5 ±0.2% | 0.89 ±0.5% | 1.00 ±0.2% | 0.65 ±0.2% | 0.99 ±0.0% | 0.45 ±0.1% |
| http/css-1m | 1048576 | 3.6 | 4938.0 ±0.7% | 0.95 ±0.4% | 1.01 ±0.7% | 0.71 ±0.7% | 0.99 ±0.7% | 0.46 ±0.3% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1253.0 ±0.2% | 0.52 ±0.5% | 0.86 ±0.4% | 0.74 ±0.4% | 0.98 ±0.5% | 0.55 ±0.7% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 334.5 ± 0.3% | 115.8 ± 0.3% | 0.35 |
| silesia/dickens | 10192446 | 3 | 151.7 ± 1.0% | 86.7 ± 0.8% | 0.57 |
| silesia/mozilla | 51220480 | 1 | 482.7 ± 0.2% | 158.1 ± 0.2% | 0.33 |
| silesia/mozilla | 51220480 | 3 | 201.9 ± 1.0% | 101.8 ± 0.5% | 0.50 |
| silesia/mr | 9970564 | 1 | 440.7 ± 0.2% | 142.1 ± 0.3% | 0.32 |
| silesia/mr | 9970564 | 3 | 170.2 ± 0.8% | 92.5 ± 1.0% | 0.54 |
| silesia/nci | 33553445 | 1 | 953.6 ± 0.5% | 366.4 ± 0.5% | 0.38 |
| silesia/nci | 33553445 | 3 | 630.3 ± 1.3% | 269.2 ± 0.5% | 0.43 |
| silesia/ooffice | 6152192 | 1 | 394.9 ± 0.3% | 118.6 ± 0.2% | 0.30 |
| silesia/ooffice | 6152192 | 3 | 143.2 ± 0.7% | 73.8 ± 0.9% | 0.52 |
| silesia/osdb | 10085684 | 1 | 475.9 ± 0.6% | 170.9 ± 1.1% | 0.36 |
| silesia/osdb | 10085684 | 3 | 191.2 ± 0.6% | 99.3 ± 0.5% | 0.52 |
| silesia/reymont | 6627202 | 1 | 344.2 ± 0.6% | 140.1 ± 0.5% | 0.41 |
| silesia/reymont | 6627202 | 3 | 187.2 ± 1.8% | 109.6 ± 1.8% | 0.59 |
| silesia/samba | 21606400 | 1 | 565.4 ± 0.2% | 209.0 ± 0.4% | 0.37 |
| silesia/samba | 21606400 | 3 | 287.0 ± 0.6% | 151.0 ± 0.6% | 0.53 |
| silesia/sao | 7251944 | 1 | 374.0 ± 0.5% | 102.5 ± 0.5% | 0.27 |
| silesia/sao | 7251944 | 3 | 108.6 ± 0.4% | 60.4 ± 0.3% | 0.56 |
| silesia/webster | 41458703 | 1 | 389.0 ± 0.3% | 141.2 ± 0.3% | 0.36 |
| silesia/webster | 41458703 | 3 | 181.7 ± 0.5% | 101.7 ± 0.3% | 0.56 |
| silesia/x-ray | 8474240 | 1 | 715.8 ± 1.9% | 109.2 ± 0.6% | 0.15 |
| silesia/x-ray | 8474240 | 3 | 105.6 ± 0.9% | 63.9 ± 0.5% | 0.60 |
| silesia/xml | 5345280 | 1 | 801.0 ± 1.1% | 276.5 ± 1.2% | 0.35 |
| silesia/xml | 5345280 | 3 | 499.6 ± 0.8% | 236.9 ± 1.6% | 0.47 |
| canterbury/alice29.txt | 152089 | 1 | 310.2 ± 0.1% | 124.6 ± 0.3% | 0.40 |
| canterbury/alice29.txt | 152089 | 3 | 206.0 ± 0.2% | 108.6 ± 0.4% | 0.53 |
| canterbury/asyoulik.txt | 125179 | 1 | 347.3 ± 0.2% | 116.4 ± 0.2% | 0.34 |
| canterbury/asyoulik.txt | 125179 | 3 | 215.6 ± 0.3% | 104.0 ± 0.6% | 0.48 |
| canterbury/cp.html | 24603 | 1 | 488.3 ± 0.3% | 167.0 ± 0.3% | 0.34 |
| canterbury/cp.html | 24603 | 3 | 364.9 ± 0.7% | 154.2 ± 0.6% | 0.42 |
| canterbury/fields.c | 11150 | 1 | 391.3 ± 0.3% | 165.2 ± 0.6% | 0.42 |
| canterbury/fields.c | 11150 | 3 | 374.3 ± 1.1% | 167.5 ± 1.0% | 0.45 |
| canterbury/grammar.lsp | 3721 | 1 | 356.3 ± 0.4% | 136.5 ± 0.5% | 0.38 |
| canterbury/grammar.lsp | 3721 | 3 | 319.9 ± 0.2% | 133.0 ± 0.4% | 0.42 |
| canterbury/kennedy.xls | 1029744 | 1 | 566.4 ± 0.5% | 196.0 ± 0.5% | 0.35 |
| canterbury/kennedy.xls | 1029744 | 3 | 397.5 ± 0.9% | 152.5 ± 0.6% | 0.38 |
| canterbury/lcet10.txt | 426754 | 1 | 343.5 ± 0.1% | 131.0 ± 0.3% | 0.38 |
| canterbury/lcet10.txt | 426754 | 3 | 203.0 ± 0.7% | 112.4 ± 1.0% | 0.55 |
| canterbury/plrabn12.txt | 481861 | 1 | 327.7 ± 0.3% | 109.4 ± 0.4% | 0.33 |
| canterbury/plrabn12.txt | 481861 | 3 | 163.9 ± 0.8% | 94.9 ± 0.5% | 0.58 |
| canterbury/ptt5 | 513216 | 1 | 1091.1 ± 0.2% | 368.6 ± 0.2% | 0.34 |
| canterbury/ptt5 | 513216 | 3 | 687.4 ± 0.5% | 310.3 ± 0.7% | 0.45 |
| canterbury/sum | 38240 | 1 | 526.3 ± 0.6% | 162.4 ± 0.5% | 0.31 |
| canterbury/sum | 38240 | 3 | 373.2 ± 0.6% | 143.3 ± 0.4% | 0.38 |
| canterbury/xargs.1 | 4227 | 1 | 338.3 ± 0.7% | 129.4 ± 0.4% | 0.38 |
| canterbury/xargs.1 | 4227 | 3 | 282.9 ± 0.2% | 122.5 ± 0.5% | 0.43 |
| canterbury-large/E.coli | 4638690 | 1 | 321.4 ± 0.2% | 133.9 ± 0.3% | 0.42 |
| canterbury-large/E.coli | 4638690 | 3 | 220.6 ± 0.8% | 125.6 ± 0.6% | 0.57 |
| canterbury-large/bible.txt | 4047392 | 1 | 345.3 ± 0.3% | 140.1 ± 0.3% | 0.41 |
| canterbury-large/bible.txt | 4047392 | 3 | 189.9 ± 1.6% | 110.8 ± 0.3% | 0.58 |
| canterbury-large/world192.txt | 2473400 | 1 | 414.1 ± 0.6% | 154.1 ± 0.5% | 0.37 |
| canterbury-large/world192.txt | 2473400 | 3 | 221.8 ± 0.6% | 122.4 ± 0.7% | 0.55 |
| http/html-1kx1024 | 1048576 | 1 | 197.6 ± 0.1% | 73.4 ± 0.7% | 0.37 |
| http/html-1kx1024 | 1048576 | 3 | 176.0 ± 0.1% | 69.6 ± 0.5% | 0.40 |
| http/html-16kx64 | 1048576 | 1 | 432.6 ± 0.1% | 192.8 ± 0.1% | 0.45 |
| http/html-16kx64 | 1048576 | 3 | 379.8 ± 0.2% | 182.1 ± 0.8% | 0.48 |
| http/html-1m | 1048576 | 1 | 539.9 ± 0.2% | 219.9 ± 0.5% | 0.41 |
| http/html-1m | 1048576 | 3 | 360.0 ± 0.6% | 190.4 ± 0.7% | 0.53 |
| http/json-1kx1024 | 1048576 | 1 | 236.3 ± 0.1% | 91.3 ± 0.5% | 0.39 |
| http/json-1kx1024 | 1048576 | 3 | 227.7 ± 0.2% | 87.9 ± 0.3% | 0.39 |
| http/json-16kx64 | 1048576 | 1 | 707.1 ± 0.1% | 277.8 ± 0.2% | 0.39 |
| http/json-16kx64 | 1048576 | 3 | 625.3 ± 0.4% | 260.3 ± 0.5% | 0.42 |
| http/json-1m | 1048576 | 1 | 839.4 ± 0.9% | 309.2 ± 0.8% | 0.37 |
| http/json-1m | 1048576 | 3 | 540.2 ± 0.2% | 258.7 ± 0.3% | 0.48 |
| http/js-1kx1024 | 1048576 | 1 | 181.4 ± 0.1% | 66.2 ± 0.2% | 0.37 |
| http/js-1kx1024 | 1048576 | 3 | 156.8 ± 0.2% | 62.7 ± 0.4% | 0.40 |
| http/js-16kx64 | 1048576 | 1 | 376.8 ± 0.6% | 162.1 ± 0.4% | 0.43 |
| http/js-16kx64 | 1048576 | 3 | 331.0 ± 0.1% | 155.9 ± 1.0% | 0.47 |
| http/js-1m | 1048576 | 1 | 514.7 ± 0.2% | 201.6 ± 0.5% | 0.39 |
| http/js-1m | 1048576 | 3 | 336.2 ± 0.5% | 177.2 ± 0.2% | 0.53 |
| http/css-1kx1024 | 1048576 | 1 | 216.1 ± 0.1% | 82.4 ± 0.7% | 0.38 |
| http/css-1kx1024 | 1048576 | 3 | 202.1 ± 0.1% | 79.6 ± 0.7% | 0.39 |
| http/css-16kx64 | 1048576 | 1 | 544.0 ± 0.3% | 219.8 ± 0.1% | 0.40 |
| http/css-16kx64 | 1048576 | 3 | 513.1 ± 0.2% | 216.2 ± 0.3% | 0.42 |
| http/css-1m | 1048576 | 1 | 2299.2 ± 0.4% | 740.0 ± 0.8% | 0.32 |
| http/css-1m | 1048576 | 3 | 1737.7 ± 0.5% | 758.6 ± 0.2% | 0.44 |
| shuffled/dickens-1m | 1048576 | 1 | 968.3 ± 0.2% | 205.1 ± 0.3% | 0.21 |
| shuffled/dickens-1m | 1048576 | 3 | 114.7 ± 0.9% | 120.1 ± 1.0% | 1.05 |

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
| silesia/dickens | 10192446 | 35.9 | 957.8 ±1.4% | 938.0 ±1.1% | 0.98 |
| silesia/mozilla | 51220480 | 35.6 | 1179.1 ±0.7% | 1185.8 ±1.7% | 1.01 |
| silesia/mr | 9970564 | 35.6 | 1114.1 ±1.1% | 1101.5 ±0.9% | 0.99 |
| silesia/nci | 33553445 | 8.4 | 2082.7 ±0.9% | 1972.0 ±2.4% | 0.95 |
| silesia/ooffice | 6152192 | 50.8 | 988.6 ±0.4% | 1014.1 ±0.4% | 1.03 |
| silesia/osdb | 10085684 | 34.7 | 1431.4 ±0.6% | 1402.7 ±0.8% | 0.98 |
| silesia/reymont | 6627202 | 29.2 | 1070.8 ±0.4% | 1030.3 ±1.1% | 0.96 |
| silesia/samba | 21606400 | 22.9 | 1610.9 ±2.5% | 1577.5 ±4.4% | 0.98 |
| silesia/sao | 7251944 | 76.2 | 887.9 ±2.3% | 966.9 ±1.0% | 1.09 |
| silesia/webster | 41458703 | 29.2 | 1057.9 ±1.4% | 1017.5 ±2.5% | 0.96 |
| silesia/x-ray | 8474240 | 71.8 | 852.1 ±0.9% | 945.0 ±2.0% | 1.11 |
| silesia/xml | 5345280 | 11.9 | 2186.3 ±0.3% | 2231.3 ±0.5% | 1.02 |
| canterbury/alice29.txt | 152089 | 37.5 | 1009.5 ±0.1% | 1025.6 ±0.0% | 1.02 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1128.5 ±0.2% | 1135.8 ±0.1% | 1.01 |
| canterbury/cp.html | 24603 | 34.4 | 1269.3 ±0.3% | 1329.5 ±0.1% | 1.05 |
| canterbury/fields.c | 11150 | 30.3 | 1081.9 ±0.2% | 1119.0 ±0.2% | 1.03 |
| canterbury/grammar.lsp | 3721 | 34.8 | 800.1 ±0.1% | 822.4 ±0.1% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1354.0 ±1.6% | 1270.5 ±0.6% | 0.94 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1236.4 ±0.2% | 1249.7 ±0.3% | 1.01 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1063.0 ±0.3% | 1069.5 ±0.3% | 1.01 |
| canterbury/ptt5 | 513216 | 10.6 | 2340.5 ±0.3% | 2580.4 ±1.4% | 1.10 |
| canterbury/sum | 38240 | 35.0 | 1278.6 ±0.2% | 1290.5 ±0.2% | 1.01 |
| canterbury/xargs.1 | 4227 | 42.7 | 789.8 ±0.1% | 795.7 ±0.1% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1092.1 ±0.6% | 1062.2 ±0.7% | 0.97 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1131.3 ±0.7% | 1089.4 ±0.8% | 0.96 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1335.8 ±0.7% | 1289.5 ±1.0% | 0.97 |
| http/html-1kx1024 | 1048576 | 39.3 | 458.3 ±0.0% | 478.1 ±0.1% | 1.04 |
| http/html-16kx64 | 1048576 | 21.9 | 1272.9 ±0.2% | 1277.1 ±0.2% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1684.5 ±0.4% | 1698.2 ±0.2% | 1.01 |
| http/json-1kx1024 | 1048576 | 21.9 | 532.0 ±0.1% | 573.6 ±0.1% | 1.08 |
| http/json-16kx64 | 1048576 | 12.6 | 1661.6 ±0.3% | 1697.6 ±0.1% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1976.0 ±0.2% | 2088.0 ±0.3% | 1.06 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.5 ±0.2% | 391.5 ±0.1% | 0.97 |
| http/js-16kx64 | 1048576 | 26.0 | 1160.0 ±0.2% | 1148.6 ±0.2% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1674.1 ±0.2% | 1629.7 ±0.4% | 0.97 |
| http/css-1kx1024 | 1048576 | 29.5 | 482.6 ±0.1% | 519.1 ±0.2% | 1.08 |
| http/css-16kx64 | 1048576 | 15.9 | 1513.0 ±0.2% | 1508.2 ±0.1% | 1.00 |
| http/css-1m | 1048576 | 3.6 | 5147.7 ±0.6% | 4914.3 ±0.5% | 0.95 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1203.0 ±0.7% | 1231.5 ±1.0% | 1.02 |
