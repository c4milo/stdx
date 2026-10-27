# bench-zstd

| Field | Value |
|---|---|
| Commit | ed0fa2f |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261026.166.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/40590088368 |
| Date | 2026-10-27 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 934.3 ±0.9% | 901.5 ±0.8% | 0.96 |
| silesia/mozilla | 51220480 | 35.6 | 1171.6 ±0.4% | 1172.8 ±1.0% | 1.00 |
| silesia/mr | 9970564 | 35.6 | 1095.8 ±0.5% | 1083.8 ±0.9% | 0.99 |
| silesia/nci | 33553445 | 8.4 | 2011.8 ±2.5% | 1860.6 ±5.4% | 0.92 |
| silesia/ooffice | 6152192 | 50.8 | 975.2 ±1.6% | 1001.2 ±1.4% | 1.03 |
| silesia/osdb | 10085684 | 34.7 | 1410.2 ±1.0% | 1358.5 ±0.6% | 0.96 |
| silesia/reymont | 6627202 | 29.2 | 1038.2 ±1.6% | 996.3 ±0.9% | 0.96 |
| silesia/samba | 21606400 | 22.9 | 1588.5 ±2.2% | 1527.4 ±3.2% | 0.96 |
| silesia/sao | 7251944 | 76.2 | 872.9 ±0.6% | 947.5 ±1.2% | 1.09 |
| silesia/webster | 41458703 | 29.2 | 1027.5 ±2.3% | 967.5 ±1.0% | 0.94 |
| silesia/x-ray | 8474240 | 71.8 | 841.3 ±0.7% | 936.3 ±0.6% | 1.11 |
| silesia/xml | 5345280 | 11.9 | 2181.5 ±0.9% | 2217.1 ±0.4% | 1.02 |
| canterbury/alice29.txt | 152089 | 37.5 | 1002.3 ±0.1% | 1026.3 ±0.1% | 1.02 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1117.2 ±0.2% | 1136.7 ±0.2% | 1.02 |
| canterbury/cp.html | 24603 | 34.4 | 1264.9 ±0.2% | 1332.8 ±0.2% | 1.05 |
| canterbury/fields.c | 11150 | 30.3 | 1074.2 ±0.2% | 1129.5 ±0.2% | 1.05 |
| canterbury/grammar.lsp | 3721 | 34.8 | 797.9 ±0.3% | 823.6 ±0.3% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1347.8 ±0.2% | 1267.6 ±0.3% | 0.94 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1228.5 ±0.1% | 1259.0 ±0.4% | 1.02 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1050.1 ±0.3% | 1068.7 ±0.2% | 1.02 |
| canterbury/ptt5 | 513216 | 10.6 | 2348.5 ±0.2% | 2562.2 ±0.7% | 1.09 |
| canterbury/sum | 38240 | 35.0 | 1272.3 ±0.2% | 1295.1 ±0.2% | 1.02 |
| canterbury/xargs.1 | 4227 | 42.7 | 786.3 ±0.1% | 796.3 ±0.2% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1077.6 ±0.6% | 1068.6 ±0.5% | 0.99 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1096.7 ±0.8% | 1091.4 ±0.8% | 1.00 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1297.1 ±0.3% | 1280.3 ±0.2% | 0.99 |
| http/html-1kx1024 | 1048576 | 39.3 | 457.2 ±0.1% | 451.3 ±0.1% | 0.99 |
| http/html-16kx64 | 1048576 | 21.9 | 1269.1 ±0.1% | 1268.3 ±0.4% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1684.2 ±0.3% | 1692.8 ±0.6% | 1.01 |
| http/json-1kx1024 | 1048576 | 21.9 | 530.3 ±0.0% | 542.0 ±0.2% | 1.02 |
| http/json-16kx64 | 1048576 | 12.6 | 1650.2 ±0.1% | 1679.6 ±0.2% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1958.2 ±0.4% | 2088.0 ±0.4% | 1.07 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.3 ±0.1% | 373.2 ±0.2% | 0.93 |
| http/js-16kx64 | 1048576 | 26.0 | 1153.2 ±0.2% | 1144.4 ±0.4% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1661.0 ±0.3% | 1629.8 ±0.7% | 0.98 |
| http/css-1kx1024 | 1048576 | 29.5 | 481.8 ±0.1% | 492.1 ±0.1% | 1.02 |
| http/css-16kx64 | 1048576 | 15.9 | 1514.0 ±0.2% | 1492.7 ±0.0% | 0.99 |
| http/css-1m | 1048576 | 3.6 | 5120.3 ±0.5% | 4856.5 ±0.8% | 0.95 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1197.6 ±0.2% | 1243.3 ±0.6% | 1.04 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 238.6 ±2.3% | 910.8 ±3.5% | 3.82 |
| silesia/mozilla | 51220480 | 35.6 | 277.3 ±0.3% | 1164.6 ±0.8% | 4.20 |
| silesia/mr | 9970564 | 35.6 | 243.7 ±1.0% | 1089.7 ±3.4% | 4.47 |
| silesia/nci | 33553445 | 8.4 | 675.2 ±0.4% | 1846.4 ±4.2% | 2.73 |
| silesia/ooffice | 6152192 | 50.8 | 193.8 ±0.2% | 1000.9 ±0.7% | 5.16 |
| silesia/osdb | 10085684 | 34.7 | 302.6 ±0.5% | 1388.7 ±0.6% | 4.59 |
| silesia/reymont | 6627202 | 29.2 | 286.1 ±2.7% | 1028.2 ±2.6% | 3.59 |
| silesia/samba | 21606400 | 22.9 | 444.6 ±0.7% | 1494.3 ±5.9% | 3.36 |
| silesia/sao | 7251944 | 76.2 | 162.9 ±0.2% | 935.5 ±1.8% | 5.74 |
| silesia/webster | 41458703 | 29.2 | 271.9 ±4.2% | 952.4 ±1.8% | 3.50 |
| silesia/x-ray | 8474240 | 71.8 | 152.6 ±0.7% | 919.0 ±2.6% | 6.02 |
| silesia/xml | 5345280 | 11.9 | 626.4 ±1.2% | 2207.5 ±1.1% | 3.52 |
| canterbury/alice29.txt | 152089 | 37.5 | 222.8 ±0.3% | 1026.5 ±0.2% | 4.61 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 208.7 ±0.1% | 1137.9 ±0.2% | 5.45 |
| canterbury/cp.html | 24603 | 34.4 | 254.1 ±0.2% | 1324.4 ±0.2% | 5.21 |
| canterbury/fields.c | 11150 | 30.3 | 251.4 ±0.2% | 1125.6 ±0.2% | 4.48 |
| canterbury/grammar.lsp | 3721 | 34.8 | 215.0 ±0.6% | 824.1 ±0.1% | 3.83 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 298.5 ±0.3% | 1268.5 ±0.6% | 4.25 |
| canterbury/lcet10.txt | 426754 | 33.0 | 267.7 ±0.4% | 1259.6 ±0.3% | 4.70 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 220.4 ±0.5% | 1072.2 ±0.2% | 4.87 |
| canterbury/ptt5 | 513216 | 10.6 | 474.7 ±0.1% | 2565.2 ±2.2% | 5.40 |
| canterbury/sum | 38240 | 35.0 | 250.4 ±0.1% | 1297.9 ±0.3% | 5.18 |
| canterbury/xargs.1 | 4227 | 42.7 | 182.9 ±0.1% | 796.0 ±0.3% | 4.35 |
| canterbury-large/E.coli | 4638690 | 30.0 | 265.2 ±0.5% | 1087.8 ±0.2% | 4.10 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 300.1 ±0.5% | 1106.5 ±0.6% | 3.69 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 333.3 ±0.9% | 1308.2 ±0.5% | 3.92 |
| http/html-1kx1024 | 1048576 | 39.3 | 187.4 ±0.1% | 451.7 ±0.3% | 2.41 |
| http/html-16kx64 | 1048576 | 21.9 | 335.9 ±0.2% | 1277.0 ±0.3% | 3.80 |
| http/html-1m | 1048576 | 17.7 | 455.1 ±0.2% | 1715.4 ±0.4% | 3.77 |
| http/json-1kx1024 | 1048576 | 21.9 | 279.1 ±0.2% | 543.6 ±0.0% | 1.95 |
| http/json-16kx64 | 1048576 | 12.6 | 469.4 ±0.2% | 1687.1 ±0.3% | 3.59 |
| http/json-1m | 1048576 | 12.2 | 529.9 ±0.1% | 2098.7 ±0.6% | 3.96 |
| http/js-1kx1024 | 1048576 | 44.5 | 158.1 ±0.1% | 373.7 ±0.0% | 2.36 |
| http/js-16kx64 | 1048576 | 26.0 | 287.5 ±0.2% | 1152.1 ±0.3% | 4.01 |
| http/js-1m | 1048576 | 19.0 | 429.9 ±0.4% | 1659.3 ±0.6% | 3.86 |
| http/css-1kx1024 | 1048576 | 29.5 | 234.3 ±0.1% | 493.4 ±0.1% | 2.11 |
| http/css-16kx64 | 1048576 | 15.9 | 423.3 ±0.1% | 1494.0 ±0.2% | 3.53 |
| http/css-1m | 1048576 | 3.6 | 1780.5 ±0.5% | 4881.9 ±1.0% | 2.74 |
| shuffled/dickens-1m | 1048576 | 58.8 | 152.2 ±0.2% | 1247.8 ±0.3% | 8.20 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 912.3 ±2.7% | 0.94 ±0.8% | 0.99 ±2.8% | 0.59 ±2.3% | 0.95 ±4.7% | 0.39 ±1.0% |
| silesia/mozilla | 51220480 | 35.6 | 1164.0 ±1.3% | 0.75 ±0.9% | 1.00 ±0.3% | 0.61 ±0.3% | 0.98 ±1.0% | 0.45 ±0.9% |
| silesia/mr | 9970564 | 35.6 | 1084.2 ±2.5% | 0.82 ±0.8% | 1.01 ±1.4% | 0.57 ±0.9% | 0.97 ±1.7% | 0.39 ±1.0% |
| silesia/nci | 33553445 | 8.4 | 1788.4 ±9.1% | 0.94 ±7.6% | 0.99 ±6.6% | 0.73 ±2.7% | 0.98 ±7.7% | 0.51 ±4.2% |
| silesia/ooffice | 6152192 | 50.8 | 981.7 ±1.3% | 0.63 ±1.0% | 1.00 ±2.9% | 0.59 ±1.0% | 0.97 ±5.0% | 0.46 ±1.0% |
| silesia/osdb | 10085684 | 34.7 | 1362.3 ±4.1% | 0.68 ±4.7% | 1.01 ±2.7% | 0.69 ±1.1% | 0.97 ±2.9% | 0.46 ±2.2% |
| silesia/reymont | 6627202 | 29.2 | 1024.7 ±0.8% | 0.95 ±1.0% | 1.00 ±0.4% | 0.62 ±2.2% | 0.96 ±0.9% | 0.40 ±1.0% |
| silesia/samba | 21606400 | 22.9 | 1516.2 ±3.6% | 0.91 ±2.5% | 0.99 ±1.6% | 0.64 ±0.5% | 0.97 ±2.2% | 0.43 ±0.9% |
| silesia/sao | 7251944 | 76.2 | 936.8 ±1.4% | 0.52 ±0.7% | 1.00 ±0.9% | 0.70 ±0.8% | 0.97 ±0.9% | 0.53 ±0.5% |
| silesia/webster | 41458703 | 29.2 | 979.7 ±3.6% | 0.93 ±2.0% | 1.00 ±2.9% | 0.63 ±1.6% | 0.96 ±3.8% | 0.42 ±2.0% |
| silesia/x-ray | 8474240 | 71.8 | 918.9 ±4.3% | 0.52 ±1.0% | 1.01 ±4.0% | 0.67 ±0.4% | 0.96 ±2.8% | 0.49 ±0.7% |
| silesia/xml | 5345280 | 11.9 | 2199.2 ±1.1% | 0.92 ±0.9% | 1.00 ±1.2% | 0.62 ±0.3% | 0.98 ±1.0% | 0.41 ±2.9% |
| canterbury/alice29.txt | 152089 | 37.5 | 1025.8 ±0.3% | 0.94 ±0.2% | 1.00 ±0.1% | 0.53 ±0.1% | 0.99 ±0.1% | 0.36 ±0.2% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1136.5 ±0.2% | 0.85 ±0.1% | 0.98 ±0.1% | 0.51 ±0.1% | 0.99 ±0.1% | 0.37 ±0.2% |
| canterbury/cp.html | 24603 | 34.4 | 1336.7 ±0.4% | 0.63 ±0.2% | 1.00 ±0.4% | 0.62 ±0.7% | 0.98 ±0.2% | 0.45 ±0.3% |
| canterbury/fields.c | 11150 | 30.3 | 1129.4 ±0.2% | 0.81 ±0.1% | 1.00 ±0.2% | 0.59 ±0.2% | 0.99 ±0.4% | 0.41 ±0.6% |
| canterbury/grammar.lsp | 3721 | 34.8 | 825.3 ±0.3% | 0.79 ±0.1% | 1.00 ±0.1% | 0.67 ±0.3% | 0.99 ±0.3% | 0.49 ±0.1% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1266.6 ±0.3% | 0.86 ±0.6% | 1.01 ±0.4% | 0.58 ±0.4% | 1.00 ±0.3% | 0.38 ±0.6% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1260.3 ±0.2% | 0.89 ±0.1% | 1.00 ±0.1% | 0.54 ±0.3% | 0.99 ±0.2% | 0.35 ±0.2% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1073.0 ±0.1% | 0.91 ±0.2% | 1.00 ±0.0% | 0.52 ±0.8% | 0.99 ±0.2% | 0.35 ±0.3% |
| canterbury/ptt5 | 513216 | 10.6 | 2529.0 ±1.4% | 0.81 ±1.2% | 1.01 ±1.7% | 0.56 ±0.2% | 1.01 ±2.1% | 0.44 ±0.3% |
| canterbury/sum | 38240 | 35.0 | 1294.7 ±0.3% | 0.64 ±0.1% | 1.00 ±0.4% | 0.64 ±0.7% | 0.99 ±0.2% | 0.45 ±0.3% |
| canterbury/xargs.1 | 4227 | 42.7 | 797.4 ±0.1% | 0.74 ±0.3% | 1.00 ±0.2% | 0.64 ±0.4% | 0.99 ±0.1% | 0.47 ±0.2% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1080.5 ±1.0% | 0.99 ±1.0% | 1.00 ±1.7% | 0.58 ±1.4% | 0.97 ±0.3% | 0.35 ±1.8% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1100.3 ±0.7% | 0.96 ±0.8% | 0.99 ±2.3% | 0.61 ±0.8% | 0.96 ±6.6% | 0.38 ±1.9% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1298.7 ±0.9% | 0.90 ±0.6% | 1.00 ±0.7% | 0.60 ±0.4% | 0.97 ±2.0% | 0.41 ±2.0% |
| http/html-1kx1024 | 1048576 | 39.3 | 452.5 ±0.0% | 0.86 ±0.2% | 0.99 ±0.4% | 0.79 ±0.1% | 0.99 ±0.0% | 0.67 ±0.1% |
| http/html-16kx64 | 1048576 | 21.9 | 1274.5 ±0.4% | 0.83 ±0.2% | 1.00 ±0.3% | 0.63 ±0.3% | 0.99 ±0.8% | 0.46 ±0.1% |
| http/html-1m | 1048576 | 17.7 | 1701.9 ±0.4% | 0.94 ±0.5% | 1.00 ±0.8% | 0.60 ±0.2% | 0.98 ±0.4% | 0.39 ±0.9% |
| http/json-1kx1024 | 1048576 | 21.9 | 542.0 ±0.1% | 0.99 ±0.1% | 1.01 ±0.1% | 0.82 ±0.2% | 0.99 ±0.1% | 0.68 ±0.1% |
| http/json-16kx64 | 1048576 | 12.6 | 1687.6 ±0.5% | 0.85 ±0.4% | 1.00 ±0.2% | 0.64 ±0.1% | 0.99 ±0.2% | 0.47 ±0.3% |
| http/json-1m | 1048576 | 12.2 | 2097.4 ±0.4% | 0.88 ±0.5% | 1.00 ±0.5% | 0.58 ±0.4% | 0.99 ±0.4% | 0.40 ±0.4% |
| http/js-1kx1024 | 1048576 | 44.5 | 374.5 ±0.1% | 0.86 ±0.1% | 1.00 ±0.1% | 0.78 ±0.2% | 0.99 ±0.3% | 0.67 ±0.1% |
| http/js-16kx64 | 1048576 | 26.0 | 1150.1 ±0.1% | 0.82 ±0.1% | 1.00 ±0.3% | 0.61 ±0.3% | 0.99 ±0.2% | 0.45 ±0.1% |
| http/js-1m | 1048576 | 19.0 | 1652.8 ±0.4% | 0.91 ±0.3% | 1.00 ±0.5% | 0.60 ±0.3% | 0.98 ±0.2% | 0.40 ±0.3% |
| http/css-1kx1024 | 1048576 | 29.5 | 493.4 ±0.1% | 0.94 ±0.1% | 1.00 ±0.1% | 0.79 ±0.2% | 0.99 ±0.3% | 0.67 ±0.1% |
| http/css-16kx64 | 1048576 | 15.9 | 1495.0 ±0.1% | 0.89 ±0.2% | 1.00 ±0.2% | 0.65 ±0.2% | 0.99 ±0.1% | 0.45 ±0.1% |
| http/css-1m | 1048576 | 3.6 | 4915.5 ±0.6% | 0.96 ±0.3% | 1.00 ±0.3% | 0.70 ±0.3% | 0.98 ±0.8% | 0.46 ±0.4% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1246.9 ±0.8% | 0.52 ±0.5% | 0.85 ±0.6% | 0.74 ±0.4% | 0.98 ±0.6% | 0.55 ±0.2% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 333.9 ± 0.4% | 115.5 ± 0.2% | 0.35 |
| silesia/dickens | 10192446 | 3 | 146.5 ± 1.0% | 83.7 ± 0.6% | 0.57 |
| silesia/mozilla | 51220480 | 1 | 481.3 ± 0.5% | 157.3 ± 0.4% | 0.33 |
| silesia/mozilla | 51220480 | 3 | 190.6 ± 1.9% | 97.3 ± 1.0% | 0.51 |
| silesia/mr | 9970564 | 1 | 439.0 ± 0.3% | 141.3 ± 0.5% | 0.32 |
| silesia/mr | 9970564 | 3 | 163.8 ± 0.6% | 88.6 ± 0.3% | 0.54 |
| silesia/nci | 33553445 | 1 | 947.9 ± 1.2% | 361.4 ± 0.8% | 0.38 |
| silesia/nci | 33553445 | 3 | 608.0 ± 0.5% | 262.2 ± 0.8% | 0.43 |
| silesia/ooffice | 6152192 | 1 | 394.0 ± 0.6% | 117.9 ± 0.1% | 0.30 |
| silesia/ooffice | 6152192 | 3 | 136.6 ± 1.3% | 70.1 ± 1.7% | 0.51 |
| silesia/osdb | 10085684 | 1 | 475.0 ± 0.3% | 169.3 ± 0.2% | 0.36 |
| silesia/osdb | 10085684 | 3 | 180.0 ± 1.0% | 94.3 ± 0.8% | 0.52 |
| silesia/reymont | 6627202 | 1 | 343.9 ± 0.5% | 139.7 ± 0.7% | 0.41 |
| silesia/reymont | 6627202 | 3 | 180.9 ± 0.7% | 106.1 ± 0.6% | 0.59 |
| silesia/samba | 21606400 | 1 | 564.2 ± 0.6% | 207.9 ± 0.2% | 0.37 |
| silesia/samba | 21606400 | 3 | 274.6 ± 1.8% | 145.5 ± 0.8% | 0.53 |
| silesia/sao | 7251944 | 1 | 373.1 ± 0.4% | 102.2 ± 0.3% | 0.27 |
| silesia/sao | 7251944 | 3 | 103.0 ± 0.3% | 57.2 ± 1.0% | 0.56 |
| silesia/webster | 41458703 | 1 | 387.8 ± 0.3% | 140.4 ± 0.3% | 0.36 |
| silesia/webster | 41458703 | 3 | 173.6 ± 0.8% | 97.4 ± 0.4% | 0.56 |
| silesia/x-ray | 8474240 | 1 | 710.0 ± 2.1% | 108.9 ± 0.4% | 0.15 |
| silesia/x-ray | 8474240 | 3 | 101.4 ± 0.7% | 61.0 ± 0.4% | 0.60 |
| silesia/xml | 5345280 | 1 | 797.3 ± 0.9% | 274.2 ± 0.7% | 0.34 |
| silesia/xml | 5345280 | 3 | 488.9 ± 1.6% | 231.1 ± 1.2% | 0.47 |
| canterbury/alice29.txt | 152089 | 1 | 309.8 ± 0.2% | 123.8 ± 0.3% | 0.40 |
| canterbury/alice29.txt | 152089 | 3 | 212.8 ± 1.0% | 107.1 ± 1.6% | 0.50 |
| canterbury/asyoulik.txt | 125179 | 1 | 347.2 ± 0.2% | 115.8 ± 0.2% | 0.33 |
| canterbury/asyoulik.txt | 125179 | 3 | 218.9 ± 0.4% | 102.2 ± 0.2% | 0.47 |
| canterbury/cp.html | 24603 | 1 | 488.8 ± 0.3% | 167.3 ± 0.3% | 0.34 |
| canterbury/cp.html | 24603 | 3 | 370.0 ± 1.2% | 153.9 ± 0.5% | 0.42 |
| canterbury/fields.c | 11150 | 1 | 390.8 ± 0.6% | 165.2 ± 0.8% | 0.42 |
| canterbury/fields.c | 11150 | 3 | 374.7 ± 0.8% | 167.4 ± 0.8% | 0.45 |
| canterbury/grammar.lsp | 3721 | 1 | 356.4 ± 0.4% | 136.9 ± 0.5% | 0.38 |
| canterbury/grammar.lsp | 3721 | 3 | 319.8 ± 0.1% | 132.9 ± 0.9% | 0.42 |
| canterbury/kennedy.xls | 1029744 | 1 | 565.1 ± 0.4% | 193.3 ± 0.4% | 0.34 |
| canterbury/kennedy.xls | 1029744 | 3 | 389.9 ± 0.4% | 145.2 ± 0.6% | 0.37 |
| canterbury/lcet10.txt | 426754 | 1 | 342.9 ± 0.4% | 130.3 ± 0.4% | 0.38 |
| canterbury/lcet10.txt | 426754 | 3 | 200.9 ± 0.3% | 109.1 ± 0.8% | 0.54 |
| canterbury/plrabn12.txt | 481861 | 1 | 327.2 ± 0.3% | 108.5 ± 0.4% | 0.33 |
| canterbury/plrabn12.txt | 481861 | 3 | 160.4 ± 0.9% | 92.3 ± 0.7% | 0.58 |
| canterbury/ptt5 | 513216 | 1 | 1092.7 ± 0.1% | 368.3 ± 0.4% | 0.34 |
| canterbury/ptt5 | 513216 | 3 | 676.3 ± 1.1% | 302.2 ± 0.8% | 0.45 |
| canterbury/sum | 38240 | 1 | 525.2 ± 0.6% | 162.3 ± 0.4% | 0.31 |
| canterbury/sum | 38240 | 3 | 382.1 ± 0.3% | 140.0 ± 0.5% | 0.37 |
| canterbury/xargs.1 | 4227 | 1 | 338.4 ± 0.6% | 129.5 ± 0.5% | 0.38 |
| canterbury/xargs.1 | 4227 | 3 | 282.4 ± 0.1% | 122.5 ± 0.5% | 0.43 |
| canterbury-large/E.coli | 4638690 | 1 | 320.5 ± 0.2% | 133.7 ± 0.3% | 0.42 |
| canterbury-large/E.coli | 4638690 | 3 | 215.0 ± 0.8% | 123.1 ± 0.3% | 0.57 |
| canterbury-large/bible.txt | 4047392 | 1 | 343.8 ± 0.5% | 139.1 ± 0.4% | 0.40 |
| canterbury-large/bible.txt | 4047392 | 3 | 181.9 ± 1.1% | 106.9 ± 3.5% | 0.59 |
| canterbury-large/world192.txt | 2473400 | 1 | 413.8 ± 0.3% | 151.2 ± 0.3% | 0.37 |
| canterbury-large/world192.txt | 2473400 | 3 | 213.4 ± 0.3% | 118.2 ± 1.0% | 0.55 |
| http/html-1kx1024 | 1048576 | 1 | 198.5 ± 0.1% | 73.3 ± 0.3% | 0.37 |
| http/html-1kx1024 | 1048576 | 3 | 176.2 ± 0.2% | 69.2 ± 0.3% | 0.39 |
| http/html-16kx64 | 1048576 | 1 | 432.9 ± 0.2% | 192.6 ± 0.3% | 0.44 |
| http/html-16kx64 | 1048576 | 3 | 379.1 ± 0.5% | 176.8 ± 1.2% | 0.47 |
| http/html-1m | 1048576 | 1 | 539.0 ± 0.4% | 218.3 ± 0.5% | 0.40 |
| http/html-1m | 1048576 | 3 | 355.0 ± 0.7% | 184.4 ± 0.5% | 0.52 |
| http/json-1kx1024 | 1048576 | 1 | 237.3 ± 0.3% | 91.2 ± 0.1% | 0.38 |
| http/json-1kx1024 | 1048576 | 3 | 228.0 ± 0.1% | 87.5 ± 0.5% | 0.38 |
| http/json-16kx64 | 1048576 | 1 | 706.1 ± 0.1% | 277.3 ± 0.4% | 0.39 |
| http/json-16kx64 | 1048576 | 3 | 625.2 ± 0.3% | 253.5 ± 1.7% | 0.41 |
| http/json-1m | 1048576 | 1 | 835.8 ± 0.5% | 304.4 ± 1.4% | 0.36 |
| http/json-1m | 1048576 | 3 | 522.8 ± 1.0% | 247.4 ± 0.8% | 0.47 |
| http/js-1kx1024 | 1048576 | 1 | 182.5 ± 0.1% | 65.9 ± 0.1% | 0.36 |
| http/js-1kx1024 | 1048576 | 3 | 157.0 ± 0.1% | 62.1 ± 0.3% | 0.40 |
| http/js-16kx64 | 1048576 | 1 | 376.3 ± 0.1% | 160.5 ± 0.1% | 0.43 |
| http/js-16kx64 | 1048576 | 3 | 330.9 ± 0.1% | 154.7 ± 0.7% | 0.47 |
| http/js-1m | 1048576 | 1 | 514.0 ± 0.1% | 200.1 ± 0.6% | 0.39 |
| http/js-1m | 1048576 | 3 | 329.3 ± 0.3% | 170.9 ± 1.0% | 0.52 |
| http/css-1kx1024 | 1048576 | 1 | 217.3 ± 0.1% | 82.4 ± 0.3% | 0.38 |
| http/css-1kx1024 | 1048576 | 3 | 202.3 ± 0.3% | 78.8 ± 0.4% | 0.39 |
| http/css-16kx64 | 1048576 | 1 | 544.3 ± 0.2% | 218.7 ± 0.5% | 0.40 |
| http/css-16kx64 | 1048576 | 3 | 512.4 ± 0.1% | 212.9 ± 0.5% | 0.42 |
| http/css-1m | 1048576 | 1 | 2289.4 ± 0.4% | 735.7 ± 0.1% | 0.32 |
| http/css-1m | 1048576 | 3 | 1709.6 ± 0.5% | 747.5 ± 0.6% | 0.44 |
| shuffled/dickens-1m | 1048576 | 1 | 963.5 ± 0.4% | 204.6 ± 0.5% | 0.21 |
| shuffled/dickens-1m | 1048576 | 3 | 111.5 ± 1.0% | 117.6 ± 1.5% | 1.06 |

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
| silesia/dickens | 10192446 | 35.9 | 938.7 ±1.0% | 910.9 ±1.1% | 0.97 |
| silesia/mozilla | 51220480 | 35.6 | 1170.3 ±0.7% | 1177.9 ±1.1% | 1.01 |
| silesia/mr | 9970564 | 35.6 | 1079.0 ±3.4% | 1047.2 ±3.9% | 0.97 |
| silesia/nci | 33553445 | 8.4 | 2037.7 ±2.6% | 1917.2 ±5.3% | 0.94 |
| silesia/ooffice | 6152192 | 50.8 | 975.6 ±1.7% | 996.3 ±1.5% | 1.02 |
| silesia/osdb | 10085684 | 34.7 | 1378.4 ±0.8% | 1351.3 ±1.1% | 0.98 |
| silesia/reymont | 6627202 | 29.2 | 1040.5 ±0.5% | 998.7 ±0.7% | 0.96 |
| silesia/samba | 21606400 | 22.9 | 1563.0 ±3.2% | 1508.8 ±4.0% | 0.97 |
| silesia/sao | 7251944 | 76.2 | 870.6 ±3.6% | 933.9 ±2.6% | 1.07 |
| silesia/webster | 41458703 | 29.2 | 1015.8 ±1.4% | 976.7 ±2.3% | 0.96 |
| silesia/x-ray | 8474240 | 71.8 | 847.6 ±0.4% | 939.4 ±0.4% | 1.11 |
| silesia/xml | 5345280 | 11.9 | 2189.2 ±0.2% | 2230.6 ±0.7% | 1.02 |
| canterbury/alice29.txt | 152089 | 37.5 | 1009.0 ±0.4% | 1026.4 ±0.1% | 1.02 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1128.6 ±0.1% | 1135.2 ±0.2% | 1.01 |
| canterbury/cp.html | 24603 | 34.4 | 1267.7 ±0.5% | 1327.6 ±0.1% | 1.05 |
| canterbury/fields.c | 11150 | 30.3 | 1082.1 ±0.2% | 1119.2 ±0.2% | 1.03 |
| canterbury/grammar.lsp | 3721 | 34.8 | 799.1 ±0.1% | 822.5 ±0.0% | 1.03 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1348.0 ±0.2% | 1267.4 ±0.4% | 0.94 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1238.7 ±0.2% | 1249.5 ±0.7% | 1.01 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1063.7 ±0.3% | 1067.8 ±0.2% | 1.00 |
| canterbury/ptt5 | 513216 | 10.6 | 2373.0 ±0.2% | 2569.5 ±2.1% | 1.08 |
| canterbury/sum | 38240 | 35.0 | 1277.8 ±0.2% | 1292.4 ±0.2% | 1.01 |
| canterbury/xargs.1 | 4227 | 42.7 | 789.6 ±0.3% | 796.3 ±0.2% | 1.01 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1084.7 ±3.9% | 1063.8 ±5.6% | 0.98 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1105.9 ±1.0% | 1078.0 ±0.5% | 0.97 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1305.5 ±0.2% | 1254.5 ±0.4% | 0.96 |
| http/html-1kx1024 | 1048576 | 39.3 | 458.3 ±0.3% | 478.0 ±0.1% | 1.04 |
| http/html-16kx64 | 1048576 | 21.9 | 1272.8 ±0.2% | 1276.0 ±0.3% | 1.00 |
| http/html-1m | 1048576 | 17.7 | 1675.0 ±0.3% | 1676.8 ±0.6% | 1.00 |
| http/json-1kx1024 | 1048576 | 21.9 | 531.8 ±0.0% | 573.3 ±0.1% | 1.08 |
| http/json-16kx64 | 1048576 | 12.6 | 1661.6 ±0.2% | 1697.8 ±0.1% | 1.02 |
| http/json-1m | 1048576 | 12.2 | 1961.8 ±0.3% | 2080.0 ±0.4% | 1.06 |
| http/js-1kx1024 | 1048576 | 44.5 | 401.6 ±0.0% | 391.3 ±0.2% | 0.97 |
| http/js-16kx64 | 1048576 | 26.0 | 1159.4 ±0.2% | 1148.6 ±0.2% | 0.99 |
| http/js-1m | 1048576 | 19.0 | 1665.0 ±0.5% | 1619.9 ±0.3% | 0.97 |
| http/css-1kx1024 | 1048576 | 29.5 | 482.3 ±0.2% | 518.8 ±0.1% | 1.08 |
| http/css-16kx64 | 1048576 | 15.9 | 1513.2 ±0.1% | 1507.4 ±0.2% | 1.00 |
| http/css-1m | 1048576 | 3.6 | 5085.9 ±0.7% | 4807.7 ±0.7% | 0.95 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1200.3 ±0.6% | 1228.5 ±1.0% | 1.02 |
