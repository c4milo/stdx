# bench-zstd

| Field | Value |
|---|---|
| Commit | 99d7426 |
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
| silesia/dickens | 10192446 | 35.9 | 953.8 ±0.6% | 920.4 ±1.1% | 0.96 |
| silesia/mozilla | 51220480 | 35.6 | 1177.3 ±1.7% | 1177.3 ±3.9% | 1.00 |
| silesia/mr | 9970564 | 35.6 | 1099.9 ±0.9% | 1092.3 ±0.5% | 0.99 |
| silesia/nci | 33553445 | 8.4 | 2048.3 ±0.7% | 1949.4 ±2.6% | 0.95 |
| silesia/ooffice | 6152192 | 50.8 | 982.7 ±2.5% | 1002.7 ±6.3% | 1.02 |
| silesia/osdb | 10085684 | 34.7 | 1409.8 ±0.6% | 1382.6 ±0.8% | 0.98 |
| silesia/reymont | 6627202 | 29.2 | 1061.3 ±0.1% | 1017.9 ±0.5% | 0.96 |
| silesia/samba | 21606400 | 22.9 | 1630.9 ±0.6% | 1585.9 ±0.6% | 0.97 |
| silesia/sao | 7251944 | 76.2 | 890.0 ±0.4% | 968.5 ±0.4% | 1.09 |
| silesia/webster | 41458703 | 29.2 | 1035.4 ±1.3% | 978.1 ±2.0% | 0.94 |
| silesia/x-ray | 8474240 | 71.8 | 849.8 ±0.3% | 939.0 ±0.3% | 1.10 |
| silesia/xml | 5345280 | 11.9 | 2174.3 ±0.8% | 2207.2 ±0.5% | 1.02 |
| canterbury/alice29.txt | 152089 | 37.5 | 1016.2 ±0.2% | 1029.3 ±0.4% | 1.01 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1131.8 ±0.2% | 1140.1 ±0.1% | 1.01 |
| canterbury/cp.html | 24603 | 34.4 | 1266.5 ±0.1% | 1340.7 ±0.1% | 1.06 |
| canterbury/fields.c | 11150 | 30.3 | 1081.5 ±0.3% | 1132.1 ±0.1% | 1.05 |
| canterbury/grammar.lsp | 3721 | 34.8 | 798.8 ±0.1% | 823.4 ±0.2% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1356.8 ±0.4% | 1261.5 ±0.5% | 0.93 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1239.2 ±0.2% | 1257.1 ±1.0% | 1.01 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1079.2 ±0.3% | 1073.3 ±0.4% | 0.99 |
| canterbury/ptt5 | 513216 | 10.6 | 2371.3 ±0.3% | 2579.9 ±2.2% | 1.09 |
| canterbury/sum | 38240 | 35.0 | 1279.2 ±0.4% | 1296.5 ±0.2% | 1.01 |
| canterbury/xargs.1 | 4227 | 42.7 | 791.6 ±0.2% | 798.0 ±0.1% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1110.2 ±0.6% | 1066.3 ±0.6% | 0.96 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1124.8 ±0.5% | 1091.1 ±0.8% | 0.97 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1323.8 ±0.5% | 1273.9 ±0.5% | 0.96 |
| http/html-1kx1024 | 1048576 | 39.3 | 457.9 ±0.2% | 452.0 ±0.2% | 0.99 |
| http/html-16kx64 | 1048576 | 21.9 | 1274.3 ±0.1% | 1277.2 ±0.5% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1696.6 ±0.5% | 1703.2 ±0.5% | 1.00 |
| http/json-1kx1024 | 1048576 | 21.9 | 530.4 ±0.3% | 544.3 ±0.2% | 1.03 |
| http/json-16kx64 | 1048576 | 12.6 | 1657.2 ±0.1% | 1688.6 ±0.2% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1958.2 ±0.6% | 2074.5 ±0.3% | 1.06 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.2 ±0.1% | 374.0 ±0.1% | 0.93 |
| http/js-16kx64 | 1048576 | 26.0 | 1160.3 ±0.3% | 1148.2 ±0.3% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1678.1 ±0.4% | 1638.1 ±0.2% | 0.98 |
| http/css-1kx1024 | 1048576 | 29.5 | 481.4 ±0.1% | 494.3 ±0.1% | 1.03 |
| http/css-16kx64 | 1048576 | 15.9 | 1510.7 ±0.1% | 1501.7 ±0.1% | 0.99 |
| http/css-1m | 1048576 | 3.6 | 5124.3 ±0.5% | 4898.5 ±1.8% | 0.96 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1195.8 ±0.7% | 1246.1 ±0.9% | 1.04 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 240.1 ±4.8% | 949.6 ±2.8% | 3.96 |
| silesia/mozilla | 51220480 | 35.6 | 277.5 ±0.4% | 1175.9 ±1.9% | 4.24 |
| silesia/mr | 9970564 | 35.6 | 245.5 ±1.0% | 1117.5 ±5.8% | 4.55 |
| silesia/nci | 33553445 | 8.4 | 683.6 ±0.4% | 2012.9 ±4.9% | 2.94 |
| silesia/ooffice | 6152192 | 50.8 | 193.8 ±0.3% | 1018.9 ±1.0% | 5.26 |
| silesia/osdb | 10085684 | 34.7 | 305.6 ±0.1% | 1427.4 ±0.3% | 4.67 |
| silesia/reymont | 6627202 | 29.2 | 291.1 ±0.7% | 1040.5 ±0.6% | 3.57 |
| silesia/samba | 21606400 | 22.9 | 452.2 ±1.1% | 1597.4 ±1.1% | 3.53 |
| silesia/sao | 7251944 | 76.2 | 163.4 ±0.4% | 961.7 ±6.6% | 5.89 |
| silesia/webster | 41458703 | 29.2 | 285.2 ±1.3% | 1028.0 ±2.9% | 3.60 |
| silesia/x-ray | 8474240 | 71.8 | 153.1 ±0.1% | 946.3 ±0.2% | 6.18 |
| silesia/xml | 5345280 | 11.9 | 631.9 ±0.4% | 2242.9 ±0.8% | 3.55 |
| canterbury/alice29.txt | 152089 | 37.5 | 222.1 ±0.5% | 1029.1 ±0.1% | 4.63 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 208.0 ±0.2% | 1139.8 ±0.1% | 5.48 |
| canterbury/cp.html | 24603 | 34.4 | 253.8 ±0.1% | 1338.4 ±0.3% | 5.27 |
| canterbury/fields.c | 11150 | 30.3 | 250.0 ±1.6% | 1132.0 ±0.1% | 4.53 |
| canterbury/grammar.lsp | 3721 | 34.8 | 214.2 ±0.2% | 824.2 ±0.0% | 3.85 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 297.7 ±0.2% | 1267.0 ±0.5% | 4.26 |
| canterbury/lcet10.txt | 426754 | 33.0 | 266.4 ±0.4% | 1262.2 ±0.2% | 4.74 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 219.6 ±0.6% | 1074.6 ±0.2% | 4.89 |
| canterbury/ptt5 | 513216 | 10.6 | 474.3 ±0.1% | 2586.2 ±1.5% | 5.45 |
| canterbury/sum | 38240 | 35.0 | 249.4 ±0.2% | 1297.5 ±0.2% | 5.20 |
| canterbury/xargs.1 | 4227 | 42.7 | 182.7 ±0.7% | 798.3 ±0.2% | 4.37 |
| canterbury-large/E.coli | 4638690 | 30.0 | 266.9 ±0.8% | 1092.9 ±0.6% | 4.09 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 297.8 ±1.3% | 1108.9 ±0.6% | 3.72 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 333.4 ±0.6% | 1310.0 ±0.4% | 3.93 |
| http/html-1kx1024 | 1048576 | 39.3 | 187.5 ±0.1% | 452.5 ±0.1% | 2.41 |
| http/html-16kx64 | 1048576 | 21.9 | 335.5 ±0.3% | 1285.0 ±0.4% | 3.83 |
| http/html-1m | 1048576 | 17.7 | 453.2 ±0.2% | 1713.1 ±0.6% | 3.78 |
| http/json-1kx1024 | 1048576 | 21.9 | 278.5 ±0.1% | 546.2 ±0.1% | 1.96 |
| http/json-16kx64 | 1048576 | 12.6 | 468.1 ±0.1% | 1695.2 ±0.3% | 3.62 |
| http/json-1m | 1048576 | 12.2 | 527.3 ±0.5% | 2097.3 ±0.7% | 3.98 |
| http/js-1kx1024 | 1048576 | 44.5 | 158.3 ±0.1% | 373.6 ±0.0% | 2.36 |
| http/js-16kx64 | 1048576 | 26.0 | 286.9 ±0.2% | 1158.1 ±0.3% | 4.04 |
| http/js-1m | 1048576 | 19.0 | 430.1 ±0.3% | 1657.9 ±0.7% | 3.85 |
| http/css-1kx1024 | 1048576 | 29.5 | 234.2 ±0.1% | 495.0 ±0.2% | 2.11 |
| http/css-16kx64 | 1048576 | 15.9 | 422.8 ±0.3% | 1503.6 ±0.1% | 3.56 |
| http/css-1m | 1048576 | 3.6 | 1771.4 ±0.9% | 4889.9 ±2.9% | 2.76 |
| shuffled/dickens-1m | 1048576 | 58.8 | 152.2 ±0.7% | 1249.4 ±0.5% | 8.21 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 954.8 ±0.9% | 0.93 ±1.0% | 1.00 ±1.4% | 0.59 ±0.3% | 0.97 ±0.8% | 0.38 ±0.8% |
| silesia/mozilla | 51220480 | 35.6 | 1185.2 ±4.5% | 0.74 ±0.9% | 1.00 ±0.8% | 0.61 ±0.6% | 0.99 ±0.8% | 0.45 ±0.9% |
| silesia/mr | 9970564 | 35.6 | 1122.8 ±0.7% | 0.82 ±0.6% | 1.01 ±1.0% | 0.56 ±0.5% | 0.97 ±0.9% | 0.39 ±1.2% |
| silesia/nci | 33553445 | 8.4 | 2074.9 ±5.7% | 0.93 ±2.9% | 1.02 ±5.7% | 0.66 ±2.6% | 1.01 ±4.8% | 0.45 ±0.7% |
| silesia/ooffice | 6152192 | 50.8 | 1019.1 ±7.1% | 0.62 ±0.4% | 1.00 ±0.5% | 0.59 ±0.4% | 0.98 ±2.4% | 0.45 ±1.6% |
| silesia/osdb | 10085684 | 34.7 | 1430.0 ±0.7% | 0.67 ±0.4% | 1.00 ±0.3% | 0.68 ±0.9% | 0.97 ±1.1% | 0.46 ±0.3% |
| silesia/reymont | 6627202 | 29.2 | 1036.7 ±1.4% | 0.95 ±7.4% | 1.00 ±0.8% | 0.62 ±1.0% | 0.97 ±1.4% | 0.40 ±6.1% |
| silesia/samba | 21606400 | 22.9 | 1576.7 ±3.2% | 0.91 ±4.2% | 1.00 ±4.2% | 0.63 ±4.5% | 0.98 ±22.6% | 0.42 ±1.1% |
| silesia/sao | 7251944 | 76.2 | 967.6 ±1.3% | 0.52 ±0.5% | 1.00 ±1.1% | 0.70 ±0.9% | 0.97 ±4.5% | 0.53 ±2.6% |
| silesia/webster | 41458703 | 29.2 | 1037.5 ±1.3% | 0.93 ±1.0% | 1.00 ±1.6% | 0.62 ±0.8% | 0.97 ±1.1% | 0.42 ±0.7% |
| silesia/x-ray | 8474240 | 71.8 | 951.7 ±0.5% | 0.51 ±0.6% | 1.00 ±0.5% | 0.66 ±0.3% | 0.98 ±0.8% | 0.48 ±0.5% |
| silesia/xml | 5345280 | 11.9 | 2244.5 ±0.3% | 0.92 ±0.3% | 1.00 ±1.0% | 0.61 ±0.7% | 0.99 ±0.6% | 0.41 ±0.3% |
| canterbury/alice29.txt | 152089 | 37.5 | 1027.9 ±0.3% | 0.94 ±0.2% | 1.00 ±0.1% | 0.53 ±0.1% | 0.99 ±0.1% | 0.36 ±0.6% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1139.7 ±0.2% | 0.85 ±0.1% | 0.98 ±0.1% | 0.51 ±0.1% | 0.99 ±0.3% | 0.37 ±0.6% |
| canterbury/cp.html | 24603 | 34.4 | 1341.1 ±0.2% | 0.63 ±0.2% | 1.00 ±0.1% | 0.61 ±0.6% | 0.99 ±0.2% | 0.45 ±0.2% |
| canterbury/fields.c | 11150 | 30.3 | 1134.4 ±0.1% | 0.81 ±0.1% | 1.00 ±0.4% | 0.59 ±0.4% | 0.99 ±0.2% | 0.41 ±0.6% |
| canterbury/grammar.lsp | 3721 | 34.8 | 824.9 ±0.1% | 0.79 ±0.2% | 1.00 ±0.0% | 0.67 ±0.5% | 0.99 ±0.1% | 0.49 ±0.5% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1270.0 ±0.6% | 0.86 ±0.4% | 1.01 ±0.3% | 0.58 ±0.5% | 0.99 ±0.7% | 0.39 ±0.4% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1264.4 ±0.2% | 0.89 ±0.1% | 1.00 ±0.2% | 0.53 ±0.2% | 0.99 ±0.9% | 0.35 ±0.7% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1073.5 ±0.3% | 0.91 ±0.1% | 1.00 ±0.1% | 0.52 ±0.3% | 0.99 ±0.3% | 0.36 ±0.5% |
| canterbury/ptt5 | 513216 | 10.6 | 2563.1 ±0.5% | 0.81 ±0.5% | 1.01 ±1.2% | 0.55 ±0.1% | 1.00 ±1.7% | 0.44 ±0.7% |
| canterbury/sum | 38240 | 35.0 | 1298.9 ±0.2% | 0.63 ±0.1% | 1.00 ±0.3% | 0.62 ±0.6% | 0.99 ±0.1% | 0.45 ±0.3% |
| canterbury/xargs.1 | 4227 | 42.7 | 799.6 ±0.2% | 0.74 ±0.1% | 1.00 ±0.2% | 0.64 ±0.5% | 0.99 ±0.2% | 0.47 ±0.4% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1097.2 ±1.6% | 0.98 ±0.9% | 1.00 ±3.4% | 0.58 ±0.6% | 0.98 ±0.8% | 0.36 ±0.9% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1113.2 ±0.7% | 0.96 ±1.0% | 1.00 ±0.7% | 0.60 ±0.4% | 0.98 ±1.6% | 0.38 ±1.4% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1308.3 ±1.8% | 0.89 ±0.9% | 1.00 ±1.6% | 0.60 ±2.7% | 0.98 ±0.5% | 0.41 ±0.4% |
| http/html-1kx1024 | 1048576 | 39.3 | 450.6 ±0.4% | 0.87 ±0.2% | 1.01 ±0.4% | 0.80 ±0.2% | 1.00 ±0.2% | 0.67 ±0.3% |
| http/html-16kx64 | 1048576 | 21.9 | 1283.1 ±0.5% | 0.83 ±0.4% | 1.00 ±0.4% | 0.62 ±0.2% | 0.99 ±0.3% | 0.46 ±0.1% |
| http/html-1m | 1048576 | 17.7 | 1708.6 ±1.4% | 0.94 ±0.6% | 1.00 ±0.6% | 0.59 ±0.2% | 0.99 ±0.8% | 0.40 ±0.9% |
| http/json-1kx1024 | 1048576 | 21.9 | 547.7 ±0.1% | 0.98 ±0.2% | 1.00 ±0.2% | 0.79 ±0.1% | 0.98 ±0.1% | 0.68 ±0.1% |
| http/json-16kx64 | 1048576 | 12.6 | 1693.9 ±0.2% | 0.85 ±0.2% | 1.00 ±0.1% | 0.64 ±0.2% | 0.99 ±0.2% | 0.47 ±0.1% |
| http/json-1m | 1048576 | 12.2 | 2093.5 ±0.5% | 0.88 ±0.5% | 1.00 ±0.7% | 0.58 ±0.7% | 0.99 ±0.6% | 0.41 ±0.4% |
| http/js-1kx1024 | 1048576 | 44.5 | 374.9 ±0.3% | 0.86 ±0.1% | 1.00 ±0.1% | 0.78 ±0.2% | 0.99 ±0.1% | 0.67 ±0.1% |
| http/js-16kx64 | 1048576 | 26.0 | 1155.8 ±0.3% | 0.82 ±0.3% | 1.00 ±0.2% | 0.60 ±0.1% | 0.99 ±0.2% | 0.45 ±0.2% |
| http/js-1m | 1048576 | 19.0 | 1648.2 ±0.8% | 0.92 ±0.4% | 1.00 ±0.5% | 0.60 ±0.3% | 0.99 ±2.9% | 0.40 ±0.3% |
| http/css-1kx1024 | 1048576 | 29.5 | 495.2 ±0.1% | 0.94 ±0.2% | 1.00 ±0.0% | 0.80 ±0.2% | 0.99 ±0.1% | 0.67 ±0.1% |
| http/css-16kx64 | 1048576 | 15.9 | 1505.6 ±0.1% | 0.89 ±0.2% | 1.00 ±0.3% | 0.64 ±0.3% | 0.99 ±0.2% | 0.45 ±0.2% |
| http/css-1m | 1048576 | 3.6 | 4935.3 ±0.5% | 0.95 ±1.1% | 1.00 ±0.2% | 0.70 ±1.3% | 0.98 ±1.6% | 0.46 ±1.3% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1248.6 ±0.3% | 0.52 ±0.4% | 0.86 ±0.3% | 0.74 ±0.4% | 0.98 ±0.7% | 0.56 ±0.4% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 332.4 ± 0.4% | 132.5 ± 0.6% | 0.40 |
| silesia/dickens | 10192446 | 3 | 143.2 ± 3.9% | 91.3 ± 2.4% | 0.64 |
| silesia/mozilla | 51220480 | 1 | 480.5 ± 0.4% | 187.6 ± 0.5% | 0.39 |
| silesia/mozilla | 51220480 | 3 | 191.9 ± 0.3% | 108.2 ± 1.3% | 0.56 |
| silesia/mr | 9970564 | 1 | 440.8 ± 0.2% | 162.8 ± 0.3% | 0.37 |
| silesia/mr | 9970564 | 3 | 163.4 ± 0.5% | 97.4 ± 0.4% | 0.60 |
| silesia/nci | 33553445 | 1 | 956.1 ± 1.5% | 410.5 ± 1.0% | 0.43 |
| silesia/nci | 33553445 | 3 | 611.5 ± 0.8% | 286.1 ± 0.3% | 0.47 |
| silesia/ooffice | 6152192 | 1 | 394.0 ± 0.6% | 143.4 ± 0.4% | 0.36 |
| silesia/ooffice | 6152192 | 3 | 135.8 ± 1.5% | 78.6 ± 5.9% | 0.58 |
| silesia/osdb | 10085684 | 1 | 474.5 ± 1.1% | 198.0 ± 0.4% | 0.42 |
| silesia/osdb | 10085684 | 3 | 180.0 ± 0.8% | 103.5 ± 2.1% | 0.57 |
| silesia/reymont | 6627202 | 1 | 344.3 ± 1.4% | 160.9 ± 0.4% | 0.47 |
| silesia/reymont | 6627202 | 3 | 179.6 ± 1.0% | 115.8 ± 0.6% | 0.64 |
| silesia/samba | 21606400 | 1 | 564.6 ± 0.5% | 239.9 ± 0.5% | 0.42 |
| silesia/samba | 21606400 | 3 | 275.4 ± 1.5% | 159.8 ± 3.3% | 0.58 |
| silesia/sao | 7251944 | 1 | 371.6 ± 0.2% | 125.4 ± 0.9% | 0.34 |
| silesia/sao | 7251944 | 3 | 102.0 ± 0.3% | 64.3 ± 0.4% | 0.63 |
| silesia/webster | 41458703 | 1 | 387.8 ± 0.3% | 158.2 ± 0.6% | 0.41 |
| silesia/webster | 41458703 | 3 | 171.2 ± 3.2% | 105.5 ± 1.5% | 0.62 |
| silesia/x-ray | 8474240 | 1 | 716.0 ± 1.2% | 138.5 ± 0.5% | 0.19 |
| silesia/x-ray | 8474240 | 3 | 99.1 ± 0.7% | 69.4 ± 0.4% | 0.70 |
| silesia/xml | 5345280 | 1 | 793.6 ± 0.5% | 312.0 ± 0.3% | 0.39 |
| silesia/xml | 5345280 | 3 | 479.4 ± 13.8% | 252.4 ± 1.7% | 0.53 |
| canterbury/alice29.txt | 152089 | 1 | 312.1 ± 0.3% | 142.9 ± 0.3% | 0.46 |
| canterbury/alice29.txt | 152089 | 3 | 204.5 ± 0.6% | 121.6 ± 0.8% | 0.59 |
| canterbury/asyoulik.txt | 125179 | 1 | 348.0 ± 0.4% | 136.0 ± 0.9% | 0.39 |
| canterbury/asyoulik.txt | 125179 | 3 | 215.2 ± 0.2% | 115.6 ± 0.6% | 0.54 |
| canterbury/cp.html | 24603 | 1 | 487.8 ± 0.8% | 204.6 ± 0.2% | 0.42 |
| canterbury/cp.html | 24603 | 3 | 362.8 ± 2.5% | 177.5 ± 0.4% | 0.49 |
| canterbury/fields.c | 11150 | 1 | 385.8 ± 0.4% | 192.6 ± 0.5% | 0.50 |
| canterbury/fields.c | 11150 | 3 | 373.7 ± 0.8% | 191.1 ± 0.5% | 0.51 |
| canterbury/grammar.lsp | 3721 | 1 | 358.3 ± 0.5% | 162.9 ± 0.4% | 0.45 |
| canterbury/grammar.lsp | 3721 | 3 | 320.0 ± 0.2% | 154.9 ± 0.2% | 0.48 |
| canterbury/kennedy.xls | 1029744 | 1 | 563.2 ± 0.4% | 219.6 ± 0.5% | 0.39 |
| canterbury/kennedy.xls | 1029744 | 3 | 380.7 ± 1.3% | 159.1 ± 2.2% | 0.42 |
| canterbury/lcet10.txt | 426754 | 1 | 342.3 ± 0.1% | 149.9 ± 0.3% | 0.44 |
| canterbury/lcet10.txt | 426754 | 3 | 194.3 ± 0.4% | 122.2 ± 0.8% | 0.63 |
| canterbury/plrabn12.txt | 481861 | 1 | 325.9 ± 0.2% | 127.8 ± 0.7% | 0.39 |
| canterbury/plrabn12.txt | 481861 | 3 | 157.6 ± 1.4% | 102.0 ± 4.0% | 0.65 |
| canterbury/ptt5 | 513216 | 1 | 1085.2 ± 0.1% | 426.1 ± 0.4% | 0.39 |
| canterbury/ptt5 | 513216 | 3 | 653.7 ± 2.4% | 342.3 ± 0.9% | 0.52 |
| canterbury/sum | 38240 | 1 | 525.6 ± 0.3% | 196.3 ± 0.2% | 0.37 |
| canterbury/sum | 38240 | 3 | 374.7 ± 2.0% | 165.6 ± 0.6% | 0.44 |
| canterbury/xargs.1 | 4227 | 1 | 337.6 ± 0.7% | 157.3 ± 0.2% | 0.47 |
| canterbury/xargs.1 | 4227 | 3 | 282.8 ± 0.1% | 144.7 ± 0.4% | 0.51 |
| canterbury-large/E.coli | 4638690 | 1 | 321.8 ± 0.2% | 145.9 ± 0.5% | 0.45 |
| canterbury-large/E.coli | 4638690 | 3 | 211.9 ± 2.2% | 134.6 ± 1.8% | 0.64 |
| canterbury-large/bible.txt | 4047392 | 1 | 344.6 ± 1.5% | 160.2 ± 0.5% | 0.46 |
| canterbury-large/bible.txt | 4047392 | 3 | 181.2 ± 0.9% | 117.2 ± 0.7% | 0.65 |
| canterbury-large/world192.txt | 2473400 | 1 | 413.7 ± 0.6% | 173.6 ± 0.4% | 0.42 |
| canterbury-large/world192.txt | 2473400 | 3 | 210.7 ± 0.6% | 129.2 ± 0.9% | 0.61 |
| http/html-1kx1024 | 1048576 | 1 | 198.5 ± 0.1% | 93.8 ± 0.1% | 0.47 |
| http/html-1kx1024 | 1048576 | 3 | 176.2 ± 0.1% | 88.1 ± 0.3% | 0.50 |
| http/html-16kx64 | 1048576 | 1 | 437.3 ± 0.1% | 230.5 ± 0.2% | 0.53 |
| http/html-16kx64 | 1048576 | 3 | 377.5 ± 0.2% | 211.7 ± 0.9% | 0.56 |
| http/html-1m | 1048576 | 1 | 536.4 ± 0.2% | 248.9 ± 1.1% | 0.46 |
| http/html-1m | 1048576 | 3 | 346.7 ± 2.9% | 204.3 ± 0.5% | 0.59 |
| http/json-1kx1024 | 1048576 | 1 | 236.6 ± 0.1% | 113.5 ± 0.4% | 0.48 |
| http/json-1kx1024 | 1048576 | 3 | 228.0 ± 0.1% | 108.8 ± 0.5% | 0.48 |
| http/json-16kx64 | 1048576 | 1 | 707.7 ± 0.2% | 338.4 ± 0.1% | 0.48 |
| http/json-16kx64 | 1048576 | 3 | 623.0 ± 0.6% | 309.1 ± 0.4% | 0.50 |
| http/json-1m | 1048576 | 1 | 835.3 ± 0.1% | 356.6 ± 0.5% | 0.43 |
| http/json-1m | 1048576 | 3 | 518.0 ± 0.6% | 285.1 ± 0.3% | 0.55 |
| http/js-1kx1024 | 1048576 | 1 | 182.8 ± 0.5% | 83.7 ± 0.6% | 0.46 |
| http/js-1kx1024 | 1048576 | 3 | 157.2 ± 0.1% | 79.6 ± 0.5% | 0.51 |
| http/js-16kx64 | 1048576 | 1 | 381.0 ± 0.1% | 196.8 ± 0.1% | 0.52 |
| http/js-16kx64 | 1048576 | 3 | 328.5 ± 0.4% | 183.7 ± 0.4% | 0.56 |
| http/js-1m | 1048576 | 1 | 510.1 ± 0.1% | 231.0 ± 0.3% | 0.45 |
| http/js-1m | 1048576 | 3 | 322.3 ± 3.6% | 190.3 ± 3.2% | 0.59 |
| http/css-1kx1024 | 1048576 | 1 | 217.5 ± 0.3% | 103.6 ± 0.8% | 0.48 |
| http/css-1kx1024 | 1048576 | 3 | 202.2 ± 0.1% | 99.1 ± 0.6% | 0.49 |
| http/css-16kx64 | 1048576 | 1 | 549.3 ± 0.2% | 260.0 ± 0.7% | 0.47 |
| http/css-16kx64 | 1048576 | 3 | 507.5 ± 0.2% | 250.0 ± 0.4% | 0.49 |
| http/css-1m | 1048576 | 1 | 2288.5 ± 0.3% | 826.1 ± 0.6% | 0.36 |
| http/css-1m | 1048576 | 3 | 1700.2 ± 0.8% | 825.7 ± 0.2% | 0.49 |
| shuffled/dickens-1m | 1048576 | 1 | 959.3 ± 0.3% | 366.6 ± 0.4% | 0.38 |
| shuffled/dickens-1m | 1048576 | 3 | 108.7 ± 0.7% | 158.6 ± 0.7% | 1.46 |

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
| silesia/dickens | 10192446 | 35.9 | 938.3 ±2.3% | 904.9 ±1.5% | 0.96 |
| silesia/mozilla | 51220480 | 35.6 | 1171.2 ±0.3% | 1174.9 ±0.7% | 1.00 |
| silesia/mr | 9970564 | 35.6 | 1087.0 ±0.2% | 1087.4 ±0.3% | 1.00 |
| silesia/nci | 33553445 | 8.4 | 2002.6 ±1.2% | 1889.0 ±2.1% | 0.94 |
| silesia/ooffice | 6152192 | 50.8 | 978.3 ±2.3% | 1003.9 ±1.6% | 1.03 |
| silesia/osdb | 10085684 | 34.7 | 1403.4 ±0.8% | 1369.0 ±1.4% | 0.98 |
| silesia/reymont | 6627202 | 29.2 | 1041.0 ±11.8% | 1007.9 ±2.4% | 0.97 |
| silesia/samba | 21606400 | 22.9 | 1604.3 ±1.1% | 1565.8 ±0.9% | 0.98 |
| silesia/sao | 7251944 | 76.2 | 879.5 ±7.0% | 951.3 ±5.9% | 1.08 |
| silesia/webster | 41458703 | 29.2 | 1039.7 ±0.8% | 996.3 ±1.5% | 0.96 |
| silesia/x-ray | 8474240 | 71.8 | 848.2 ±0.2% | 944.6 ±0.6% | 1.11 |
| silesia/xml | 5345280 | 11.9 | 2186.0 ±0.4% | 2225.3 ±0.6% | 1.02 |
| canterbury/alice29.txt | 152089 | 37.5 | 1009.8 ±0.1% | 1026.8 ±0.0% | 1.02 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1125.2 ±0.1% | 1136.9 ±0.1% | 1.01 |
| canterbury/cp.html | 24603 | 34.4 | 1270.2 ±0.4% | 1334.8 ±0.1% | 1.05 |
| canterbury/fields.c | 11150 | 30.3 | 1080.0 ±0.3% | 1119.6 ±0.1% | 1.04 |
| canterbury/grammar.lsp | 3721 | 34.8 | 801.6 ±0.3% | 823.8 ±0.1% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1350.8 ±0.3% | 1271.8 ±0.3% | 0.94 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1233.4 ±0.2% | 1258.9 ±0.2% | 1.02 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1058.5 ±0.3% | 1064.3 ±0.2% | 1.01 |
| canterbury/ptt5 | 513216 | 10.6 | 2368.3 ±0.5% | 2548.6 ±3.1% | 1.08 |
| canterbury/sum | 38240 | 35.0 | 1274.4 ±0.3% | 1292.0 ±0.0% | 1.01 |
| canterbury/xargs.1 | 4227 | 42.7 | 788.6 ±0.1% | 796.3 ±0.2% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1077.6 ±0.6% | 1085.3 ±0.3% | 1.01 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1112.5 ±0.6% | 1070.0 ±0.3% | 0.96 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1302.4 ±0.5% | 1276.0 ±0.5% | 0.98 |
| http/html-1kx1024 | 1048576 | 39.3 | 458.1 ±0.1% | 476.6 ±0.1% | 1.04 |
| http/html-16kx64 | 1048576 | 21.9 | 1271.9 ±0.1% | 1277.0 ±0.1% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1677.8 ±0.4% | 1686.1 ±0.4% | 1.00 |
| http/json-1kx1024 | 1048576 | 21.9 | 531.0 ±0.1% | 571.8 ±0.2% | 1.08 |
| http/json-16kx64 | 1048576 | 12.6 | 1660.1 ±0.1% | 1698.1 ±0.2% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1952.2 ±0.7% | 2084.5 ±1.2% | 1.07 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.2 ±0.1% | 389.9 ±0.2% | 0.97 |
| http/js-16kx64 | 1048576 | 26.0 | 1157.1 ±0.2% | 1147.9 ±0.2% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1653.0 ±0.3% | 1615.1 ±0.6% | 0.98 |
| http/css-1kx1024 | 1048576 | 29.5 | 482.2 ±0.1% | 518.7 ±0.1% | 1.08 |
| http/css-16kx64 | 1048576 | 15.9 | 1512.2 ±0.2% | 1508.0 ±0.1% | 1.00 |
| http/css-1m | 1048576 | 3.6 | 5072.0 ±0.5% | 4849.8 ±0.5% | 0.96 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1199.6 ±0.2% | 1238.6 ±3.6% | 1.03 |
