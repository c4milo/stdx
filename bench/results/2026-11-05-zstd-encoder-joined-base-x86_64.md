# bench-zstd

| Field | Value |
|---|---|
| Commit | 99d7426 |
| Runner label | ubuntu-24.04 |
| Image version | 20261101.360.1 |
| CPU model | AMD EPYC 9V45 96-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/41980417764 |
| Date | 2026-11-05 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 1240.2 ±4.9% | 1478.6 ±4.9% | 1.19 |
| silesia/mozilla | 51220480 | 35.6 | 1231.2 ±3.6% | 1463.9 ±1.5% | 1.19 |
| silesia/mr | 9970564 | 35.6 | 1322.1 ±29.9% | 1560.3 ±0.7% | 1.18 |
| silesia/nci | 33553445 | 8.4 | 2136.9 ±17.9% | 2587.4 ±37.8% | 1.21 |
| silesia/ooffice | 6152192 | 50.8 | 1020.2 ±1.9% | 1228.0 ±1.4% | 1.20 |
| silesia/osdb | 10085684 | 34.7 | 1632.9 ±1.9% | 1794.6 ±2.9% | 1.10 |
| silesia/reymont | 6627202 | 29.2 | 1347.0 ±2.1% | 1544.8 ±2.3% | 1.15 |
| silesia/samba | 21606400 | 22.9 | 1768.6 ±2.3% | 1955.9 ±2.0% | 1.11 |
| silesia/sao | 7251944 | 76.2 | 954.2 ±2.4% | 1219.7 ±2.8% | 1.28 |
| silesia/webster | 41458703 | 29.2 | 1353.4 ±1.6% | 1534.2 ±1.8% | 1.13 |
| silesia/x-ray | 8474240 | 71.8 | 1028.5 ±2.1% | 1241.8 ±1.7% | 1.21 |
| silesia/xml | 5345280 | 11.9 | 2188.5 ±1.4% | 2606.1 ±1.9% | 1.19 |
| canterbury/alice29.txt | 152089 | 37.5 | 1092.0 ±0.7% | 1330.1 ±2.3% | 1.22 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1232.7 ±31.5% | 1475.7 ±11.3% | 1.20 |
| canterbury/cp.html | 24603 | 34.4 | 1471.1 ±1.9% | 1723.1 ±0.8% | 1.17 |
| canterbury/fields.c | 11150 | 30.3 | 1216.2 ±2.0% | 1465.8 ±2.1% | 1.21 |
| canterbury/grammar.lsp | 3721 | 34.8 | 956.4 ±0.6% | 1072.3 ±9.8% | 1.12 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1414.9 ±2.1% | 1543.1 ±1.5% | 1.09 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1355.5 ±1.2% | 1671.7 ±1.1% | 1.23 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1171.3 ±2.1% | 1410.3 ±1.0% | 1.20 |
| canterbury/ptt5 | 513216 | 10.6 | 3607.4 ±1.8% | 3561.7 ±2.4% | 0.99 |
| canterbury/sum | 38240 | 35.0 | 1498.7 ±0.7% | 1625.7 ±0.9% | 1.08 |
| canterbury/xargs.1 | 4227 | 42.7 | 937.6 ±3.1% | 1020.1 ±1.6% | 1.09 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1261.2 ±0.8% | 1525.9 ±0.8% | 1.21 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1355.1 ±2.4% | 1583.7 ±1.1% | 1.17 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1529.6 ±1.8% | 1703.7 ±0.9% | 1.11 |
| http/html-1kx1024 | 1048576 | 39.3 | 504.0 ±1.0% | 500.6 ±1.9% | 0.99 |
| http/html-16kx64 | 1048576 | 21.9 | 1310.3 ±4.7% | 1438.4 ±3.0% | 1.10 |
| http/html-1m | 1048576 | 17.7 | 1731.8 ±2.4% | 1965.5 ±2.7% | 1.14 |
| http/json-1kx1024 | 1048576 | 21.9 | 595.1 ±1.5% | 616.5 ±1.4% | 1.04 |
| http/json-16kx64 | 1048576 | 12.6 | 1703.8 ±3.4% | 1976.4 ±1.3% | 1.16 |
| http/json-1m | 1048576 | 12.2 | 1983.9 ±26.0% | 2806.0 ±24.1% | 1.41 |
| http/js-1kx1024 | 1048576 | 44.5 | 450.6 ±1.4% | 405.4 ±1.5% | 0.90 |
| http/js-16kx64 | 1048576 | 26.0 | 1231.4 ±1.7% | 1352.7 ±0.7% | 1.10 |
| http/js-1m | 1048576 | 19.0 | 1765.2 ±24.6% | 1989.5 ±8.9% | 1.13 |
| http/css-1kx1024 | 1048576 | 29.5 | 536.5 ±9.5% | 549.7 ±2.5% | 1.02 |
| http/css-16kx64 | 1048576 | 15.9 | 1724.5 ±42.8% | 1784.5 ±15.8% | 1.03 |
| http/css-1m | 1048576 | 3.6 | 6324.0 ±0.8% | 6275.5 ±2.0% | 0.99 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1459.7 ±8.3% | 1712.2 ±2.1% | 1.17 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 337.2 ±1.0% | 1423.7 ±24.9% | 4.22 |
| silesia/mozilla | 51220480 | 35.6 | 385.5 ±1.8% | 1452.5 ±2.1% | 3.77 |
| silesia/mr | 9970564 | 35.6 | 349.0 ±0.7% | 1561.6 ±1.8% | 4.47 |
| silesia/nci | 33553445 | 8.4 | 916.4 ±2.5% | 2686.4 ±39.3% | 2.93 |
| silesia/ooffice | 6152192 | 50.8 | 280.5 ±2.4% | 1260.4 ±1.5% | 4.49 |
| silesia/osdb | 10085684 | 34.7 | 457.2 ±1.2% | 1799.1 ±2.6% | 3.94 |
| silesia/reymont | 6627202 | 29.2 | 410.7 ±1.0% | 1523.1 ±8.8% | 3.71 |
| silesia/samba | 21606400 | 22.9 | 600.8 ±3.7% | 1925.4 ±4.9% | 3.20 |
| silesia/sao | 7251944 | 76.2 | 247.3 ±1.1% | 1207.9 ±3.2% | 4.88 |
| silesia/webster | 41458703 | 29.2 | 398.4 ±2.6% | 1506.7 ±1.1% | 3.78 |
| silesia/x-ray | 8474240 | 71.8 | 228.0 ±2.5% | 1206.6 ±1.5% | 5.29 |
| silesia/xml | 5345280 | 11.9 | 818.2 ±1.1% | 2596.1 ±1.6% | 3.17 |
| canterbury/alice29.txt | 152089 | 37.5 | 302.4 ±1.2% | 1328.9 ±1.8% | 4.40 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 283.4 ±41.6% | 1475.2 ±17.0% | 5.20 |
| canterbury/cp.html | 24603 | 34.4 | 368.2 ±1.9% | 1714.2 ±2.1% | 4.66 |
| canterbury/fields.c | 11150 | 30.3 | 359.8 ±2.1% | 1462.5 ±1.5% | 4.06 |
| canterbury/grammar.lsp | 3721 | 34.8 | 313.2 ±0.6% | 1057.8 ±1.9% | 3.38 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 418.4 ±1.5% | 1527.6 ±8.9% | 3.65 |
| canterbury/lcet10.txt | 426754 | 33.0 | 357.9 ±29.4% | 1632.3 ±5.7% | 4.56 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 299.9 ±1.3% | 1408.7 ±1.7% | 4.70 |
| canterbury/ptt5 | 513216 | 10.6 | 681.0 ±1.3% | 3559.3 ±2.4% | 5.23 |
| canterbury/sum | 38240 | 35.0 | 372.0 ±1.9% | 1629.9 ±1.4% | 4.38 |
| canterbury/xargs.1 | 4227 | 42.7 | 267.4 ±8.4% | 1041.8 ±1.0% | 3.90 |
| canterbury-large/E.coli | 4638690 | 30.0 | 357.2 ±1.5% | 1531.7 ±1.6% | 4.29 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 412.1 ±1.3% | 1555.4 ±2.1% | 3.77 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 450.6 ±1.0% | 1670.0 ±0.7% | 3.71 |
| http/html-1kx1024 | 1048576 | 39.3 | 250.7 ±2.1% | 494.4 ±1.2% | 1.97 |
| http/html-16kx64 | 1048576 | 21.9 | 440.9 ±1.3% | 1448.9 ±3.2% | 3.29 |
| http/html-1m | 1048576 | 17.7 | 590.7 ±1.3% | 1996.7 ±1.0% | 3.38 |
| http/json-1kx1024 | 1048576 | 21.9 | 367.3 ±6.4% | 607.9 ±37.8% | 1.65 |
| http/json-16kx64 | 1048576 | 12.6 | 621.3 ±1.3% | 1996.6 ±1.9% | 3.21 |
| http/json-1m | 1048576 | 12.2 | 709.5 ±1.7% | 2806.7 ±1.8% | 3.96 |
| http/js-1kx1024 | 1048576 | 44.5 | 204.2 ±0.7% | 400.7 ±6.2% | 1.96 |
| http/js-16kx64 | 1048576 | 26.0 | 379.4 ±42.9% | 1344.8 ±9.8% | 3.54 |
| http/js-1m | 1048576 | 19.0 | 563.6 ±0.3% | 1979.1 ±1.1% | 3.51 |
| http/css-1kx1024 | 1048576 | 29.5 | 300.9 ±3.7% | 535.8 ±2.6% | 1.78 |
| http/css-16kx64 | 1048576 | 15.9 | 537.6 ±1.3% | 1765.6 ±1.4% | 3.28 |
| http/css-1m | 1048576 | 3.6 | 2259.4 ±51.7% | 6147.9 ±9.4% | 2.72 |
| shuffled/dickens-1m | 1048576 | 58.8 | 236.6 ±4.0% | 1693.6 ±1.3% | 7.16 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 1408.8 ±2.0% | 0.90 ±3.1% | 0.99 ±2.4% | 0.50 ±1.8% | 0.99 ±1.8% | 0.35 ±0.4% |
| silesia/mozilla | 51220480 | 35.6 | 1460.1 ±1.1% | 0.69 ±1.6% | 0.98 ±1.9% | 0.55 ±1.2% | 1.02 ±1.7% | 0.45 ±1.4% |
| silesia/mr | 9970564 | 35.6 | 1557.1 ±1.3% | 0.75 ±0.8% | 1.00 ±1.0% | 0.48 ±2.8% | 0.99 ±0.8% | 0.38 ±1.7% |
| silesia/nci | 33553445 | 8.4 | 2768.4 ±1.1% | 0.92 ±1.9% | 1.00 ±1.4% | 0.59 ±0.9% | 1.01 ±1.4% | 0.44 ±1.7% |
| silesia/ooffice | 6152192 | 50.8 | 1254.1 ±1.0% | 0.57 ±1.4% | 0.99 ±0.7% | 0.51 ±0.9% | 1.00 ±2.6% | 0.44 ±0.8% |
| silesia/osdb | 10085684 | 34.7 | 1821.3 ±6.5% | 0.61 ±1.6% | 1.01 ±1.4% | 0.67 ±1.1% | 1.00 ±2.8% | 0.46 ±0.8% |
| silesia/reymont | 6627202 | 29.2 | 1535.7 ±68.2% | 0.94 ±12.7% | 1.02 ±2.9% | 0.54 ±3.1% | 1.01 ±2.0% | 0.37 ±2.0% |
| silesia/samba | 21606400 | 22.9 | 1954.9 ±4.9% | 0.88 ±7.5% | 0.92 ±13.3% | 0.59 ±2.5% | 0.99 ±9.1% | 0.44 ±33.5% |
| silesia/sao | 7251944 | 76.2 | 1197.6 ±3.1% | 0.45 ±0.8% | 1.00 ±1.3% | 0.64 ±2.4% | 1.03 ±32.8% | 0.52 ±67.7% |
| silesia/webster | 41458703 | 29.2 | 1511.5 ±8.4% | 0.90 ±1.5% | 1.00 ±1.3% | 0.53 ±2.8% | 1.00 ±3.3% | 0.40 ±52.1% |
| silesia/x-ray | 8474240 | 71.8 | 1235.8 ±6.1% | 0.45 ±2.3% | 1.00 ±2.9% | 0.60 ±3.8% | 0.99 ±3.1% | 0.47 ±3.1% |
| silesia/xml | 5345280 | 11.9 | 2598.9 ±1.8% | 0.91 ±1.4% | 1.00 ±1.7% | 0.60 ±2.1% | 0.99 ±2.1% | 0.44 ±0.9% |
| canterbury/alice29.txt | 152089 | 37.5 | 1341.3 ±3.5% | 0.91 ±2.2% | 1.00 ±1.7% | 0.52 ±1.3% | 0.99 ±2.0% | 0.35 ±1.6% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1472.3 ±2.0% | 0.81 ±1.4% | 0.98 ±1.0% | 0.51 ±3.0% | 0.99 ±3.0% | 0.36 ±2.8% |
| canterbury/cp.html | 24603 | 34.4 | 1725.9 ±1.3% | 0.57 ±2.2% | 1.00 ±3.2% | 0.70 ±2.4% | 1.00 ±3.7% | 0.48 ±5.0% |
| canterbury/fields.c | 11150 | 30.3 | 1444.2 ±3.8% | 0.77 ±3.3% | 0.99 ±2.1% | 0.64 ±1.3% | 1.00 ±3.1% | 0.41 ±1.7% |
| canterbury/grammar.lsp | 3721 | 34.8 | 1067.9 ±5.5% | 0.75 ±4.8% | 1.01 ±29.0% | 0.70 ±52.7% | 1.01 ±5.0% | 0.49 ±2.9% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1557.7 ±2.0% | 0.84 ±2.4% | 1.01 ±30.7% | 0.60 ±37.0% | 0.99 ±9.6% | 0.40 ±1.8% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1658.8 ±27.4% | 0.86 ±1.9% | 1.00 ±3.3% | 0.49 ±3.0% | 0.96 ±8.8% | 0.35 ±30.7% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1405.5 ±2.3% | 0.87 ±5.6% | 0.99 ±6.9% | 0.46 ±1.9% | 0.98 ±0.9% | 0.36 ±1.6% |
| canterbury/ptt5 | 513216 | 10.6 | 3570.2 ±1.9% | 0.74 ±1.4% | 1.01 ±1.8% | 0.47 ±2.1% | 0.98 ±2.3% | 0.41 ±2.6% |
| canterbury/sum | 38240 | 35.0 | 1608.7 ±2.3% | 0.59 ±2.0% | 1.00 ±8.7% | 0.71 ±29.5% | 1.00 ±1.1% | 0.50 ±3.3% |
| canterbury/xargs.1 | 4227 | 42.7 | 1026.1 ±0.6% | 0.69 ±1.3% | 1.00 ±8.2% | 0.68 ±2.1% | 0.95 ±1.4% | 0.46 ±1.3% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1528.8 ±22.1% | 0.97 ±32.3% | 1.00 ±2.3% | 0.53 ±2.7% | 0.98 ±7.7% | 0.35 ±27.5% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1615.3 ±8.7% | 0.95 ±2.8% | 1.00 ±14.1% | 0.54 ±1.0% | 1.00 ±1.9% | 0.37 ±2.6% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1689.2 ±2.4% | 0.87 ±3.3% | 1.01 ±26.2% | 0.55 ±40.4% | 0.99 ±3.3% | 0.42 ±1.9% |
| http/html-1kx1024 | 1048576 | 39.3 | 496.2 ±2.3% | 0.86 ±7.7% | 1.00 ±2.5% | 0.78 ±1.4% | 0.99 ±4.8% | 0.69 ±3.0% |
| http/html-16kx64 | 1048576 | 21.9 | 1468.9 ±2.8% | 0.81 ±2.4% | 1.00 ±2.2% | 0.59 ±0.6% | 0.98 ±3.0% | 0.48 ±4.6% |
| http/html-1m | 1048576 | 17.7 | 1962.8 ±4.8% | 0.94 ±1.6% | 1.02 ±2.1% | 0.59 ±1.2% | 1.00 ±2.3% | 0.42 ±27.1% |
| http/json-1kx1024 | 1048576 | 21.9 | 602.4 ±2.2% | 0.98 ±26.7% | 1.01 ±31.7% | 0.82 ±2.4% | 1.00 ±2.8% | 0.71 ±9.0% |
| http/json-16kx64 | 1048576 | 12.6 | 1953.8 ±13.1% | 0.84 ±2.1% | 1.04 ±1.3% | 0.62 ±3.0% | 1.00 ±4.1% | 0.48 ±2.0% |
| http/json-1m | 1048576 | 12.2 | 2796.2 ±0.9% | 0.85 ±2.7% | 1.02 ±1.6% | 0.50 ±1.5% | 1.00 ±1.8% | 0.36 ±1.6% |
| http/js-1kx1024 | 1048576 | 44.5 | 400.9 ±3.5% | 0.86 ±3.5% | 1.00 ±3.6% | 0.77 ±4.7% | 0.99 ±4.2% | 0.69 ±3.2% |
| http/js-16kx64 | 1048576 | 26.0 | 1354.0 ±4.3% | 0.79 ±4.9% | 1.01 ±3.3% | 0.57 ±2.9% | 0.99 ±3.4% | 0.46 ±3.6% |
| http/js-1m | 1048576 | 19.0 | 1997.4 ±1.9% | 0.90 ±2.5% | 1.01 ±2.6% | 0.57 ±1.9% | 0.99 ±3.5% | 0.41 ±4.3% |
| http/css-1kx1024 | 1048576 | 29.5 | 548.8 ±1.7% | 0.94 ±0.7% | 1.00 ±3.1% | 0.80 ±0.8% | 0.99 ±1.0% | 0.69 ±1.5% |
| http/css-16kx64 | 1048576 | 15.9 | 1825.0 ±1.9% | 0.89 ±2.7% | 1.03 ±1.9% | 0.65 ±2.2% | 1.00 ±0.6% | 0.47 ±4.3% |
| http/css-1m | 1048576 | 3.6 | 6430.7 ±1.4% | 0.93 ±1.4% | 0.99 ±1.3% | 0.73 ±2.5% | 0.99 ±1.7% | 0.47 ±1.9% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1720.1 ±8.3% | 0.44 ±37.0% | 0.89 ±27.4% | 0.63 ±5.9% | 0.97 ±3.1% | 0.49 ±1.8% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 412.2 ± 1.6% | 171.1 ± 1.8% | 0.42 |
| silesia/dickens | 10192446 | 3 | 239.1 ± 20.2% | 141.8 ± 2.5% | 0.59 |
| silesia/mozilla | 51220480 | 1 | 600.2 ± 24.4% | 229.4 ± 21.2% | 0.38 |
| silesia/mozilla | 51220480 | 3 | 359.3 ± 4.7% | 203.2 ± 7.1% | 0.57 |
| silesia/mr | 9970564 | 1 | 552.6 ± 2.5% | 213.1 ± 1.8% | 0.39 |
| silesia/mr | 9970564 | 3 | 298.1 ± 3.6% | 166.5 ± 2.1% | 0.56 |
| silesia/nci | 33553445 | 1 | 1123.5 ± 2.6% | 536.4 ± 5.0% | 0.48 |
| silesia/nci | 33553445 | 3 | 964.5 ± 12.1% | 445.5 ± 24.1% | 0.46 |
| silesia/ooffice | 6152192 | 1 | 518.9 ± 1.1% | 190.5 ± 3.3% | 0.37 |
| silesia/ooffice | 6152192 | 3 | 263.1 ± 2.1% | 160.3 ± 3.0% | 0.61 |
| silesia/osdb | 10085684 | 1 | 610.2 ± 2.4% | 273.0 ± 6.6% | 0.45 |
| silesia/osdb | 10085684 | 3 | 368.2 ± 3.4% | 221.4 ± 22.3% | 0.60 |
| silesia/reymont | 6627202 | 1 | 389.7 ± 2.6% | 207.5 ± 1.7% | 0.53 |
| silesia/reymont | 6627202 | 3 | 295.8 ± 2.4% | 168.9 ± 2.3% | 0.57 |
| silesia/samba | 21606400 | 1 | 664.7 ± 1.1% | 298.3 ± 2.2% | 0.45 |
| silesia/samba | 21606400 | 3 | 457.7 ± 35.7% | 248.9 ± 24.7% | 0.54 |
| silesia/sao | 7251944 | 1 | 504.3 ± 2.5% | 188.8 ± 1.4% | 0.37 |
| silesia/sao | 7251944 | 3 | 208.0 ± 4.5% | 143.7 ± 11.4% | 0.69 |
| silesia/webster | 41458703 | 1 | 452.6 ± 1.8% | 192.7 ± 12.6% | 0.43 |
| silesia/webster | 41458703 | 3 | 279.1 ± 2.1% | 158.8 ± 1.7% | 0.57 |
| silesia/x-ray | 8474240 | 1 | 933.6 ± 2.2% | 198.5 ± 1.5% | 0.21 |
| silesia/x-ray | 8474240 | 3 | 203.1 ± 3.6% | 148.5 ± 3.5% | 0.73 |
| silesia/xml | 5345280 | 1 | 916.6 ± 2.4% | 393.3 ± 2.5% | 0.43 |
| silesia/xml | 5345280 | 3 | 721.0 ± 1.9% | 355.0 ± 2.6% | 0.49 |
| canterbury/alice29.txt | 152089 | 1 | 396.9 ± 0.8% | 182.4 ± 0.7% | 0.46 |
| canterbury/alice29.txt | 152089 | 3 | 283.8 ± 2.1% | 148.7 ± 2.1% | 0.52 |
| canterbury/asyoulik.txt | 125179 | 1 | 466.9 ± 1.8% | 173.4 ± 3.3% | 0.37 |
| canterbury/asyoulik.txt | 125179 | 3 | 285.1 ± 7.7% | 138.3 ± 2.1% | 0.49 |
| canterbury/cp.html | 24603 | 1 | 761.5 ± 2.1% | 340.5 ± 3.9% | 0.45 |
| canterbury/cp.html | 24603 | 3 | 552.2 ± 6.6% | 296.2 ± 21.7% | 0.54 |
| canterbury/fields.c | 11150 | 1 | 591.6 ± 49.7% | 293.3 ± 2.0% | 0.50 |
| canterbury/fields.c | 11150 | 3 | 519.2 ± 0.3% | 269.5 ± 1.0% | 0.52 |
| canterbury/grammar.lsp | 3721 | 1 | 485.4 ± 40.6% | 237.3 ± 17.2% | 0.49 |
| canterbury/grammar.lsp | 3721 | 3 | 415.9 ± 13.3% | 219.5 ± 2.7% | 0.53 |
| canterbury/kennedy.xls | 1029744 | 1 | 765.1 ± 1.9% | 295.3 ± 3.4% | 0.39 |
| canterbury/kennedy.xls | 1029744 | 3 | 670.2 ± 2.7% | 233.4 ± 1.4% | 0.35 |
| canterbury/lcet10.txt | 426754 | 1 | 388.4 ± 1.3% | 186.6 ± 1.0% | 0.48 |
| canterbury/lcet10.txt | 426754 | 3 | 273.8 ± 8.6% | 154.0 ± 2.1% | 0.56 |
| canterbury/plrabn12.txt | 481861 | 1 | 393.4 ± 2.4% | 162.7 ± 2.1% | 0.41 |
| canterbury/plrabn12.txt | 481861 | 3 | 235.4 ± 3.5% | 128.7 ± 2.8% | 0.55 |
| canterbury/ptt5 | 513216 | 1 | 1218.1 ± 1.9% | 505.1 ± 1.5% | 0.41 |
| canterbury/ptt5 | 513216 | 3 | 1005.1 ± 9.0% | 453.9 ± 29.2% | 0.45 |
| canterbury/sum | 38240 | 1 | 804.8 ± 2.7% | 329.3 ± 1.7% | 0.41 |
| canterbury/sum | 38240 | 3 | 595.3 ± 1.6% | 284.2 ± 3.1% | 0.48 |
| canterbury/xargs.1 | 4227 | 1 | 478.3 ± 2.7% | 236.7 ± 1.4% | 0.49 |
| canterbury/xargs.1 | 4227 | 3 | 372.2 ± 44.1% | 207.3 ± 19.6% | 0.56 |
| canterbury-large/E.coli | 4638690 | 1 | 388.4 ± 0.4% | 215.4 ± 0.9% | 0.55 |
| canterbury-large/E.coli | 4638690 | 3 | 358.6 ± 1.0% | 187.8 ± 2.7% | 0.52 |
| canterbury-large/bible.txt | 4047392 | 1 | 399.2 ± 2.2% | 208.0 ± 2.3% | 0.52 |
| canterbury-large/bible.txt | 4047392 | 3 | 291.9 ± 32.1% | 170.9 ± 4.8% | 0.59 |
| canterbury-large/world192.txt | 2473400 | 1 | 479.0 ± 2.0% | 209.4 ± 1.1% | 0.44 |
| canterbury-large/world192.txt | 2473400 | 3 | 329.7 ± 2.2% | 191.0 ± 3.1% | 0.58 |
| http/html-1kx1024 | 1048576 | 1 | 223.0 ± 2.2% | 101.7 ± 6.3% | 0.46 |
| http/html-1kx1024 | 1048576 | 3 | 192.2 ± 1.4% | 99.9 ± 1.1% | 0.52 |
| http/html-16kx64 | 1048576 | 1 | 483.6 ± 1.1% | 267.6 ± 2.4% | 0.55 |
| http/html-16kx64 | 1048576 | 3 | 404.9 ± 2.5% | 253.2 ± 3.5% | 0.63 |
| http/html-1m | 1048576 | 1 | 598.7 ± 1.4% | 299.6 ± 1.5% | 0.50 |
| http/html-1m | 1048576 | 3 | 484.2 ± 1.5% | 267.8 ± 0.8% | 0.55 |
| http/json-1kx1024 | 1048576 | 1 | 271.9 ± 1.6% | 124.5 ± 1.8% | 0.46 |
| http/json-1kx1024 | 1048576 | 3 | 254.4 ± 1.2% | 120.2 ± 0.8% | 0.47 |
| http/json-16kx64 | 1048576 | 1 | 845.3 ± 0.8% | 406.1 ± 1.9% | 0.48 |
| http/json-16kx64 | 1048576 | 3 | 704.0 ± 2.8% | 374.6 ± 1.2% | 0.53 |
| http/json-1m | 1048576 | 1 | 1038.6 ± 6.1% | 462.1 ± 33.9% | 0.44 |
| http/json-1m | 1048576 | 3 | 794.0 ± 2.4% | 387.9 ± 2.6% | 0.49 |
| http/js-1kx1024 | 1048576 | 1 | 202.8 ± 2.0% | 91.9 ± 1.5% | 0.45 |
| http/js-1kx1024 | 1048576 | 3 | 170.1 ± 0.9% | 90.8 ± 1.6% | 0.53 |
| http/js-16kx64 | 1048576 | 1 | 423.9 ± 9.6% | 227.3 ± 1.5% | 0.54 |
| http/js-16kx64 | 1048576 | 3 | 357.9 ± 3.0% | 226.3 ± 3.6% | 0.63 |
| http/js-1m | 1048576 | 1 | 569.5 ± 32.9% | 276.5 ± 11.8% | 0.49 |
| http/js-1m | 1048576 | 3 | 462.1 ± 2.4% | 250.2 ± 2.9% | 0.54 |
| http/css-1kx1024 | 1048576 | 1 | 251.3 ± 2.0% | 114.8 ± 3.2% | 0.46 |
| http/css-1kx1024 | 1048576 | 3 | 222.2 ± 2.0% | 111.6 ± 31.4% | 0.50 |
| http/css-16kx64 | 1048576 | 1 | 691.2 ± 0.5% | 319.5 ± 5.7% | 0.46 |
| http/css-16kx64 | 1048576 | 3 | 607.4 ± 3.1% | 305.3 ± 2.5% | 0.50 |
| http/css-1m | 1048576 | 1 | 3193.8 ± 38.9% | 1116.2 ± 8.1% | 0.35 |
| http/css-1m | 1048576 | 3 | 2618.6 ± 10.7% | 1126.3 ± 2.6% | 0.43 |
| shuffled/dickens-1m | 1048576 | 1 | 1649.6 ± 1.3% | 511.9 ± 1.3% | 0.31 |
| shuffled/dickens-1m | 1048576 | 3 | 237.2 ± 0.9% | 257.6 ± 1.3% | 1.09 |

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
| silesia/dickens | 10192446 | 35.9 | 1234.7 ±1.4% | 1458.1 ±1.8% | 1.18 |
| silesia/mozilla | 51220480 | 35.6 | 1231.2 ±4.0% | 1485.9 ±2.5% | 1.21 |
| silesia/mr | 9970564 | 35.6 | 1375.5 ±2.4% | 1645.9 ±2.5% | 1.20 |
| silesia/nci | 33553445 | 8.4 | 2165.8 ±3.2% | 2750.5 ±3.2% | 1.27 |
| silesia/ooffice | 6152192 | 50.8 | 1095.0 ±3.6% | 1321.7 ±2.7% | 1.21 |
| silesia/osdb | 10085684 | 34.7 | 1698.7 ±2.5% | 1889.5 ±3.2% | 1.11 |
| silesia/reymont | 6627202 | 29.2 | 1386.7 ±2.8% | 1585.9 ±1.5% | 1.14 |
| silesia/samba | 21606400 | 22.9 | 1813.0 ±4.6% | 2036.8 ±2.9% | 1.12 |
| silesia/sao | 7251944 | 76.2 | 996.6 ±3.4% | 1304.4 ±1.4% | 1.31 |
| silesia/webster | 41458703 | 29.2 | 1324.7 ±11.0% | 1514.8 ±50.1% | 1.14 |
| silesia/x-ray | 8474240 | 71.8 | 1046.5 ±2.6% | 1272.0 ±9.4% | 1.22 |
| silesia/xml | 5345280 | 11.9 | 2179.8 ±62.1% | 2624.0 ±3.1% | 1.20 |
| canterbury/alice29.txt | 152089 | 37.5 | 1083.2 ±1.2% | 1327.6 ±1.0% | 1.23 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1245.4 ±34.9% | 1439.0 ±16.7% | 1.16 |
| canterbury/cp.html | 24603 | 34.4 | 1464.6 ±12.5% | 1718.7 ±22.5% | 1.17 |
| canterbury/fields.c | 11150 | 30.3 | 1231.7 ±2.3% | 1452.4 ±3.0% | 1.18 |
| canterbury/grammar.lsp | 3721 | 34.8 | 919.8 ±10.4% | 1077.0 ±8.0% | 1.17 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1422.5 ±1.6% | 1531.7 ±7.2% | 1.08 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1371.6 ±2.1% | 1668.2 ±9.4% | 1.22 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1200.0 ±2.6% | 1412.2 ±2.1% | 1.18 |
| canterbury/ptt5 | 513216 | 10.6 | 3615.3 ±31.0% | 3555.8 ±1.3% | 0.98 |
| canterbury/sum | 38240 | 35.0 | 1506.2 ±3.8% | 1635.2 ±1.9% | 1.09 |
| canterbury/xargs.1 | 4227 | 42.7 | 955.4 ±2.9% | 1039.4 ±3.4% | 1.09 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1312.1 ±2.3% | 1554.7 ±2.2% | 1.18 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1407.3 ±1.7% | 1622.6 ±7.4% | 1.15 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1566.1 ±1.6% | 1742.4 ±3.0% | 1.11 |
| http/html-1kx1024 | 1048576 | 39.3 | 510.8 ±17.2% | 550.2 ±27.4% | 1.08 |
| http/html-16kx64 | 1048576 | 21.9 | 1348.2 ±1.9% | 1480.7 ±2.6% | 1.10 |
| http/html-1m | 1048576 | 17.7 | 1747.8 ±1.7% | 1985.1 ±0.7% | 1.14 |
| http/json-1kx1024 | 1048576 | 21.9 | 592.0 ±27.9% | 665.4 ±20.6% | 1.12 |
| http/json-16kx64 | 1048576 | 12.6 | 1666.4 ±7.6% | 2027.8 ±3.9% | 1.22 |
| http/json-1m | 1048576 | 12.2 | 1984.1 ±1.8% | 2835.6 ±1.6% | 1.43 |
| http/js-1kx1024 | 1048576 | 44.5 | 448.9 ±2.1% | 437.9 ±3.5% | 0.98 |
| http/js-16kx64 | 1048576 | 26.0 | 1245.5 ±3.0% | 1370.3 ±2.7% | 1.10 |
| http/js-1m | 1048576 | 19.0 | 1756.7 ±6.0% | 1999.5 ±2.4% | 1.14 |
| http/css-1kx1024 | 1048576 | 29.5 | 547.7 ±1.8% | 595.1 ±1.4% | 1.09 |
| http/css-16kx64 | 1048576 | 15.9 | 1723.0 ±6.1% | 1799.9 ±30.7% | 1.04 |
| http/css-1m | 1048576 | 3.6 | 6364.2 ±1.1% | 6390.9 ±1.7% | 1.00 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1458.9 ±1.3% | 1703.7 ±3.4% | 1.17 |
