# bench-zstd

| Field | Value |
|---|---|
| Commit | c74152e |
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
| silesia/dickens | 10192446 | 35.9 | 1216.4 ±1.2% | 1436.9 ±1.0% | 1.18 |
| silesia/mozilla | 51220480 | 35.6 | 1228.4 ±1.5% | 1466.2 ±1.8% | 1.19 |
| silesia/mr | 9970564 | 35.6 | 1335.2 ±2.0% | 1592.5 ±3.7% | 1.19 |
| silesia/nci | 33553445 | 8.4 | 2013.1 ±12.6% | 2616.1 ±6.4% | 1.30 |
| silesia/ooffice | 6152192 | 50.8 | 1088.0 ±2.4% | 1311.0 ±1.5% | 1.20 |
| silesia/osdb | 10085684 | 34.7 | 1708.3 ±2.0% | 1871.6 ±4.4% | 1.10 |
| silesia/reymont | 6627202 | 29.2 | 1372.4 ±3.4% | 1567.4 ±3.1% | 1.14 |
| silesia/samba | 21606400 | 22.9 | 1810.7 ±2.5% | 2002.9 ±4.0% | 1.11 |
| silesia/sao | 7251944 | 76.2 | 1008.2 ±4.6% | 1305.9 ±3.8% | 1.30 |
| silesia/webster | 41458703 | 29.2 | 1324.2 ±19.0% | 1443.6 ±11.2% | 1.09 |
| silesia/x-ray | 8474240 | 71.8 | 1045.0 ±2.1% | 1276.1 ±2.3% | 1.22 |
| silesia/xml | 5345280 | 11.9 | 2203.4 ±2.3% | 2589.6 ±2.0% | 1.18 |
| canterbury/alice29.txt | 152089 | 37.5 | 1084.7 ±2.9% | 1320.0 ±2.0% | 1.22 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1237.9 ±1.3% | 1469.1 ±1.3% | 1.19 |
| canterbury/cp.html | 24603 | 34.4 | 1485.8 ±2.0% | 1731.2 ±1.3% | 1.17 |
| canterbury/fields.c | 11150 | 30.3 | 1251.0 ±43.1% | 1461.5 ±9.8% | 1.17 |
| canterbury/grammar.lsp | 3721 | 34.8 | 987.9 ±1.3% | 1073.0 ±1.6% | 1.09 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1441.7 ±2.4% | 1561.5 ±2.8% | 1.08 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1367.4 ±2.8% | 1624.5 ±1.9% | 1.19 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1155.2 ±4.3% | 1372.8 ±25.8% | 1.19 |
| canterbury/ptt5 | 513216 | 10.6 | 3587.5 ±3.3% | 3588.7 ±2.5% | 1.00 |
| canterbury/sum | 38240 | 35.0 | 1501.8 ±1.9% | 1617.8 ±2.4% | 1.08 |
| canterbury/xargs.1 | 4227 | 42.7 | 960.5 ±3.5% | 1018.0 ±1.5% | 1.06 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1305.6 ±1.1% | 1553.6 ±5.5% | 1.19 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1396.9 ±1.3% | 1634.9 ±2.0% | 1.17 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1547.1 ±5.7% | 1708.3 ±2.5% | 1.10 |
| http/html-1kx1024 | 1048576 | 39.3 | 509.2 ±2.0% | 495.7 ±2.1% | 0.97 |
| http/html-16kx64 | 1048576 | 21.9 | 1338.6 ±2.6% | 1447.8 ±2.6% | 1.08 |
| http/html-1m | 1048576 | 17.7 | 1768.9 ±3.2% | 2019.8 ±1.7% | 1.14 |
| http/json-1kx1024 | 1048576 | 21.9 | 590.4 ±3.0% | 603.1 ±1.4% | 1.02 |
| http/json-16kx64 | 1048576 | 12.6 | 1667.1 ±4.1% | 1953.5 ±33.3% | 1.17 |
| http/json-1m | 1048576 | 12.2 | 1977.8 ±2.6% | 2830.6 ±1.1% | 1.43 |
| http/js-1kx1024 | 1048576 | 44.5 | 444.7 ±1.7% | 400.3 ±0.8% | 0.90 |
| http/js-16kx64 | 1048576 | 26.0 | 1221.4 ±1.5% | 1321.0 ±2.9% | 1.08 |
| http/js-1m | 1048576 | 19.0 | 1743.3 ±6.5% | 1973.5 ±2.7% | 1.13 |
| http/css-1kx1024 | 1048576 | 29.5 | 537.8 ±3.8% | 537.8 ±1.7% | 1.00 |
| http/css-16kx64 | 1048576 | 15.9 | 1736.1 ±1.8% | 1790.4 ±2.3% | 1.03 |
| http/css-1m | 1048576 | 3.6 | 6281.8 ±1.2% | 6334.6 ±0.8% | 1.01 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1463.1 ±1.4% | 1691.4 ±2.7% | 1.16 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 347.0 ±2.3% | 1454.2 ±3.2% | 4.19 |
| silesia/mozilla | 51220480 | 35.6 | 382.0 ±2.3% | 1438.9 ±29.3% | 3.77 |
| silesia/mr | 9970564 | 35.6 | 349.9 ±2.1% | 1584.0 ±1.2% | 4.53 |
| silesia/nci | 33553445 | 8.4 | 886.9 ±4.1% | 2621.4 ±10.9% | 2.96 |
| silesia/ooffice | 6152192 | 50.8 | 274.3 ±3.3% | 1263.0 ±4.9% | 4.60 |
| silesia/osdb | 10085684 | 34.7 | 462.4 ±3.2% | 1879.7 ±3.8% | 4.07 |
| silesia/reymont | 6627202 | 29.2 | 409.6 ±2.6% | 1511.8 ±6.1% | 3.69 |
| silesia/samba | 21606400 | 22.9 | 602.6 ±2.1% | 1944.6 ±2.3% | 3.23 |
| silesia/sao | 7251944 | 76.2 | 243.0 ±24.9% | 1264.1 ±7.1% | 5.20 |
| silesia/webster | 41458703 | 29.2 | 381.3 ±9.9% | 1366.6 ±5.0% | 3.58 |
| silesia/x-ray | 8474240 | 71.8 | 226.6 ±2.3% | 1237.7 ±12.7% | 5.46 |
| silesia/xml | 5345280 | 11.9 | 828.0 ±4.4% | 2622.2 ±4.1% | 3.17 |
| canterbury/alice29.txt | 152089 | 37.5 | 304.8 ±2.4% | 1356.0 ±2.1% | 4.45 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 282.0 ±2.9% | 1491.4 ±2.1% | 5.29 |
| canterbury/cp.html | 24603 | 34.4 | 376.5 ±3.3% | 1723.9 ±4.2% | 4.58 |
| canterbury/fields.c | 11150 | 30.3 | 360.1 ±4.5% | 1434.5 ±5.4% | 3.98 |
| canterbury/grammar.lsp | 3721 | 34.8 | 300.9 ±1.9% | 1039.3 ±2.8% | 3.45 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 422.3 ±2.3% | 1528.9 ±2.8% | 3.62 |
| canterbury/lcet10.txt | 426754 | 33.0 | 358.8 ±3.1% | 1620.5 ±2.8% | 4.52 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 295.1 ±2.3% | 1412.4 ±2.0% | 4.79 |
| canterbury/ptt5 | 513216 | 10.6 | 684.4 ±4.2% | 3563.9 ±2.7% | 5.21 |
| canterbury/sum | 38240 | 35.0 | 369.2 ±2.7% | 1597.6 ±2.8% | 4.33 |
| canterbury/xargs.1 | 4227 | 42.7 | 263.4 ±1.8% | 999.8 ±1.4% | 3.80 |
| canterbury-large/E.coli | 4638690 | 30.0 | 355.9 ±2.3% | 1549.6 ±1.4% | 4.35 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 419.3 ±2.9% | 1594.4 ±2.4% | 3.80 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 455.3 ±14.9% | 1700.2 ±28.1% | 3.73 |
| http/html-1kx1024 | 1048576 | 39.3 | 239.6 ±1.5% | 491.9 ±1.7% | 2.05 |
| http/html-16kx64 | 1048576 | 21.9 | 433.3 ±1.7% | 1411.2 ±1.5% | 3.26 |
| http/html-1m | 1048576 | 17.7 | 587.1 ±10.9% | 1986.9 ±3.1% | 3.38 |
| http/json-1kx1024 | 1048576 | 21.9 | 370.6 ±0.8% | 610.2 ±2.1% | 1.65 |
| http/json-16kx64 | 1048576 | 12.6 | 629.8 ±2.5% | 1977.0 ±3.1% | 3.14 |
| http/json-1m | 1048576 | 12.2 | 722.5 ±2.5% | 2867.3 ±3.9% | 3.97 |
| http/js-1kx1024 | 1048576 | 44.5 | 210.4 ±5.9% | 414.8 ±3.2% | 1.97 |
| http/js-16kx64 | 1048576 | 26.0 | 390.3 ±2.4% | 1372.4 ±2.8% | 3.52 |
| http/js-1m | 1048576 | 19.0 | 576.9 ±2.3% | 2020.8 ±2.7% | 3.50 |
| http/css-1kx1024 | 1048576 | 29.5 | 307.9 ±2.3% | 551.2 ±1.4% | 1.79 |
| http/css-16kx64 | 1048576 | 15.9 | 557.9 ±3.5% | 1834.9 ±3.0% | 3.29 |
| http/css-1m | 1048576 | 3.6 | 2363.4 ±2.7% | 6397.2 ±2.9% | 2.71 |
| shuffled/dickens-1m | 1048576 | 58.8 | 242.3 ±1.0% | 1751.2 ±3.3% | 7.23 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 1470.0 ±5.8% | 0.91 ±4.0% | 0.98 ±20.1% | 0.50 ±73.1% | 0.98 ±14.1% | 0.36 ±4.6% |
| silesia/mozilla | 51220480 | 35.6 | 1406.1 ±4.4% | 0.70 ±34.0% | 1.02 ±68.6% | 0.56 ±65.7% | 1.02 ±53.4% | 0.45 ±1.5% |
| silesia/mr | 9970564 | 35.6 | 1567.5 ±1.3% | 0.76 ±3.8% | 1.00 ±20.6% | 0.49 ±1.7% | 1.00 ±19.8% | 0.35 ±13.0% |
| silesia/nci | 33553445 | 8.4 | 2685.1 ±1.6% | 0.92 ±2.1% | 1.00 ±4.6% | 0.60 ±1.9% | 1.01 ±2.1% | 0.44 ±4.0% |
| silesia/ooffice | 6152192 | 50.8 | 1273.6 ±3.5% | 0.56 ±3.6% | 1.01 ±4.6% | 0.52 ±6.2% | 1.00 ±5.4% | 0.45 ±4.1% |
| silesia/osdb | 10085684 | 34.7 | 1883.5 ±2.2% | 0.60 ±2.0% | 1.00 ±3.7% | 0.66 ±12.3% | 0.98 ±43.4% | 0.46 ±9.4% |
| silesia/reymont | 6627202 | 29.2 | 1562.1 ±2.0% | 0.93 ±2.3% | 1.01 ±1.6% | 0.54 ±1.1% | 0.99 ±1.4% | 0.38 ±7.3% |
| silesia/samba | 21606400 | 22.9 | 1959.4 ±3.1% | 0.90 ±8.3% | 1.01 ±54.8% | 0.58 ±24.9% | 1.01 ±1.2% | 0.44 ±4.7% |
| silesia/sao | 7251944 | 76.2 | 1294.8 ±2.8% | 0.44 ±1.6% | 1.01 ±1.1% | 0.62 ±9.2% | 0.99 ±64.5% | 0.51 ±2.5% |
| silesia/webster | 41458703 | 29.2 | 1390.1 ±5.6% | 0.88 ±6.1% | 1.01 ±4.0% | 0.55 ±3.0% | 1.00 ±4.8% | 0.41 ±8.7% |
| silesia/x-ray | 8474240 | 71.8 | 1257.2 ±2.1% | 0.44 ±2.4% | 0.99 ±3.3% | 0.59 ±3.5% | 0.99 ±15.0% | 0.47 ±27.4% |
| silesia/xml | 5345280 | 11.9 | 2580.5 ±2.7% | 0.90 ±3.7% | 0.99 ±3.3% | 0.60 ±14.4% | 0.99 ±3.4% | 0.44 ±2.2% |
| canterbury/alice29.txt | 152089 | 37.5 | 1324.6 ±3.6% | 0.92 ±2.7% | 0.99 ±5.9% | 0.51 ±4.1% | 0.98 ±2.9% | 0.36 ±3.3% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1459.0 ±0.9% | 0.82 ±2.7% | 0.99 ±2.7% | 0.51 ±3.0% | 0.98 ±1.6% | 0.37 ±2.7% |
| canterbury/cp.html | 24603 | 34.4 | 1702.2 ±1.2% | 0.57 ±1.1% | 0.99 ±1.3% | 0.69 ±2.3% | 1.00 ±1.4% | 0.49 ±1.0% |
| canterbury/fields.c | 11150 | 30.3 | 1478.2 ±1.4% | 0.77 ±1.9% | 0.98 ±2.6% | 0.63 ±1.7% | 0.97 ±1.6% | 0.39 ±1.1% |
| canterbury/grammar.lsp | 3721 | 34.8 | 1065.8 ±3.3% | 0.75 ±2.3% | 0.99 ±2.4% | 0.70 ±1.8% | 0.99 ±4.2% | 0.49 ±2.7% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1519.3 ±2.5% | 0.84 ±14.1% | 1.01 ±41.7% | 0.60 ±3.5% | 1.00 ±2.0% | 0.40 ±2.4% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1630.5 ±3.5% | 0.87 ±8.3% | 1.01 ±2.3% | 0.50 ±1.8% | 1.00 ±8.1% | 0.36 ±47.0% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1389.1 ±1.0% | 0.88 ±1.9% | 1.00 ±5.8% | 0.47 ±1.4% | 0.99 ±1.7% | 0.36 ±0.5% |
| canterbury/ptt5 | 513216 | 10.6 | 3509.3 ±2.6% | 0.75 ±2.1% | 1.00 ±1.7% | 0.47 ±3.9% | 0.99 ±2.1% | 0.41 ±2.7% |
| canterbury/sum | 38240 | 35.0 | 1586.4 ±4.3% | 0.57 ±3.0% | 1.01 ±25.4% | 0.71 ±49.5% | 1.00 ±15.2% | 0.49 ±5.8% |
| canterbury/xargs.1 | 4227 | 42.7 | 1029.3 ±2.5% | 0.68 ±3.0% | 0.99 ±11.6% | 0.69 ±1.8% | 0.98 ±2.3% | 0.46 ±2.2% |
| canterbury-large/E.coli | 4638690 | 30.0 | 1537.0 ±1.9% | 0.98 ±1.1% | 1.00 ±1.4% | 0.53 ±1.1% | 0.99 ±0.9% | 0.35 ±1.3% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1599.2 ±28.7% | 0.94 ±2.1% | 1.01 ±1.3% | 0.55 ±3.5% | 0.99 ±2.8% | 0.37 ±4.4% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1664.4 ±2.6% | 0.87 ±5.5% | 1.01 ±4.0% | 0.55 ±2.1% | 0.99 ±2.6% | 0.42 ±2.3% |
| http/html-1kx1024 | 1048576 | 39.3 | 490.3 ±30.6% | 0.86 ±18.7% | 1.00 ±28.1% | 0.78 ±2.4% | 0.98 ±2.2% | 0.69 ±16.1% |
| http/html-16kx64 | 1048576 | 21.9 | 1438.1 ±2.6% | 0.82 ±1.6% | 1.01 ±11.1% | 0.61 ±37.3% | 0.99 ±19.6% | 0.48 ±21.7% |
| http/html-1m | 1048576 | 17.7 | 1999.5 ±2.8% | 0.94 ±3.5% | 1.02 ±3.7% | 0.58 ±2.6% | 0.99 ±2.9% | 0.42 ±2.5% |
| http/json-1kx1024 | 1048576 | 21.9 | 608.4 ±22.6% | 0.98 ±47.4% | 1.01 ±4.5% | 0.81 ±3.7% | 0.96 ±6.1% | 0.70 ±2.0% |
| http/json-16kx64 | 1048576 | 12.6 | 1959.2 ±4.7% | 0.83 ±2.1% | 1.02 ±3.5% | 0.61 ±3.7% | 1.00 ±14.5% | 0.48 ±2.6% |
| http/json-1m | 1048576 | 12.2 | 2777.4 ±10.8% | 0.86 ±3.7% | 1.01 ±3.1% | 0.50 ±13.1% | 1.00 ±27.4% | 0.38 ±61.4% |
| http/js-1kx1024 | 1048576 | 44.5 | 400.1 ±2.2% | 0.86 ±3.2% | 1.01 ±7.7% | 0.77 ±3.6% | 0.99 ±3.5% | 0.68 ±1.8% |
| http/js-16kx64 | 1048576 | 26.0 | 1302.1 ±7.8% | 0.80 ±6.1% | 1.01 ±36.1% | 0.57 ±7.3% | 0.99 ±35.6% | 0.47 ±3.2% |
| http/js-1m | 1048576 | 19.0 | 1965.8 ±0.4% | 0.91 ±1.3% | 1.01 ±2.8% | 0.57 ±1.4% | 0.99 ±1.0% | 0.41 ±1.3% |
| http/css-1kx1024 | 1048576 | 29.5 | 529.3 ±27.5% | 0.96 ±2.0% | 1.02 ±9.2% | 0.80 ±31.6% | 0.99 ±3.4% | 0.68 ±25.2% |
| http/css-16kx64 | 1048576 | 15.9 | 1783.3 ±2.8% | 0.87 ±19.1% | 1.01 ±51.0% | 0.65 ±2.1% | 0.99 ±1.1% | 0.46 ±7.3% |
| http/css-1m | 1048576 | 3.6 | 6115.1 ±3.4% | 0.94 ±15.4% | 1.01 ±1.9% | 0.74 ±1.8% | 1.00 ±2.5% | 0.47 ±0.8% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1693.3 ±2.4% | 0.44 ±2.7% | 0.88 ±2.5% | 0.63 ±2.7% | 0.97 ±2.5% | 0.49 ±1.7% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 395.3 ± 2.2% | 184.0 ± 1.8% | 0.47 |
| silesia/dickens | 10192446 | 3 | 232.6 ± 2.5% | 141.1 ± 1.4% | 0.61 |
| silesia/mozilla | 51220480 | 1 | 586.7 ± 14.8% | 249.0 ± 5.4% | 0.42 |
| silesia/mozilla | 51220480 | 3 | 359.4 ± 4.6% | 206.2 ± 1.4% | 0.57 |
| silesia/mr | 9970564 | 1 | 547.7 ± 2.1% | 232.7 ± 4.4% | 0.42 |
| silesia/mr | 9970564 | 3 | 293.8 ± 1.2% | 167.7 ± 3.0% | 0.57 |
| silesia/nci | 33553445 | 1 | 1101.1 ± 1.8% | 593.1 ± 2.2% | 0.54 |
| silesia/nci | 33553445 | 3 | 946.9 ± 2.2% | 465.2 ± 2.7% | 0.49 |
| silesia/ooffice | 6152192 | 1 | 511.6 ± 2.0% | 201.2 ± 25.0% | 0.39 |
| silesia/ooffice | 6152192 | 3 | 259.6 ± 1.9% | 159.9 ± 1.7% | 0.62 |
| silesia/osdb | 10085684 | 1 | 603.1 ± 3.3% | 293.5 ± 2.3% | 0.49 |
| silesia/osdb | 10085684 | 3 | 357.9 ± 5.8% | 221.6 ± 1.3% | 0.62 |
| silesia/reymont | 6627202 | 1 | 393.0 ± 1.6% | 228.2 ± 1.7% | 0.58 |
| silesia/reymont | 6627202 | 3 | 284.1 ± 4.4% | 176.0 ± 1.7% | 0.62 |
| silesia/samba | 21606400 | 1 | 650.3 ± 26.7% | 317.1 ± 1.7% | 0.49 |
| silesia/samba | 21606400 | 3 | 465.9 ± 3.1% | 264.6 ± 3.0% | 0.57 |
| silesia/sao | 7251944 | 1 | 504.9 ± 6.9% | 205.2 ± 1.4% | 0.41 |
| silesia/sao | 7251944 | 3 | 201.6 ± 4.2% | 151.2 ± 3.3% | 0.75 |
| silesia/webster | 41458703 | 1 | 447.3 ± 1.1% | 209.9 ± 18.7% | 0.47 |
| silesia/webster | 41458703 | 3 | 275.4 ± 6.6% | 175.7 ± 2.6% | 0.64 |
| silesia/x-ray | 8474240 | 1 | 939.8 ± 15.3% | 216.8 ± 50.2% | 0.23 |
| silesia/x-ray | 8474240 | 3 | 199.1 ± 30.0% | 157.0 ± 59.7% | 0.79 |
| silesia/xml | 5345280 | 1 | 895.0 ± 1.9% | 426.8 ± 2.3% | 0.48 |
| silesia/xml | 5345280 | 3 | 703.6 ± 1.8% | 378.2 ± 4.8% | 0.54 |
| canterbury/alice29.txt | 152089 | 1 | 382.3 ± 18.5% | 205.1 ± 2.2% | 0.54 |
| canterbury/alice29.txt | 152089 | 3 | 271.7 ± 7.9% | 162.4 ± 3.3% | 0.60 |
| canterbury/asyoulik.txt | 125179 | 1 | 461.3 ± 2.0% | 195.3 ± 1.7% | 0.42 |
| canterbury/asyoulik.txt | 125179 | 3 | 278.9 ± 35.6% | 152.8 ± 11.8% | 0.55 |
| canterbury/cp.html | 24603 | 1 | 749.0 ± 1.4% | 386.8 ± 2.5% | 0.52 |
| canterbury/cp.html | 24603 | 3 | 542.2 ± 1.5% | 332.9 ± 1.3% | 0.61 |
| canterbury/fields.c | 11150 | 1 | 589.7 ± 1.8% | 342.4 ± 2.0% | 0.58 |
| canterbury/fields.c | 11150 | 3 | 510.8 ± 16.5% | 301.9 ± 38.5% | 0.59 |
| canterbury/grammar.lsp | 3721 | 1 | 477.5 ± 1.4% | 259.4 ± 1.9% | 0.54 |
| canterbury/grammar.lsp | 3721 | 3 | 409.8 ± 1.6% | 235.6 ± 1.4% | 0.57 |
| canterbury/kennedy.xls | 1029744 | 1 | 752.1 ± 3.2% | 325.8 ± 15.1% | 0.43 |
| canterbury/kennedy.xls | 1029744 | 3 | 654.9 ± 1.0% | 250.1 ± 2.9% | 0.38 |
| canterbury/lcet10.txt | 426754 | 1 | 375.9 ± 0.8% | 204.3 ± 2.2% | 0.54 |
| canterbury/lcet10.txt | 426754 | 3 | 271.8 ± 1.7% | 170.9 ± 1.6% | 0.63 |
| canterbury/plrabn12.txt | 481861 | 1 | 383.7 ± 1.7% | 183.5 ± 1.9% | 0.48 |
| canterbury/plrabn12.txt | 481861 | 3 | 231.9 ± 2.0% | 141.8 ± 3.8% | 0.61 |
| canterbury/ptt5 | 513216 | 1 | 1226.0 ± 2.2% | 551.3 ± 3.0% | 0.45 |
| canterbury/ptt5 | 513216 | 3 | 976.0 ± 1.7% | 484.1 ± 1.9% | 0.50 |
| canterbury/sum | 38240 | 1 | 781.4 ± 2.1% | 366.9 ± 1.8% | 0.47 |
| canterbury/sum | 38240 | 3 | 581.7 ± 1.7% | 315.1 ± 3.0% | 0.54 |
| canterbury/xargs.1 | 4227 | 1 | 475.1 ± 1.2% | 264.8 ± 1.0% | 0.56 |
| canterbury/xargs.1 | 4227 | 3 | 360.0 ± 1.7% | 232.5 ± 2.0% | 0.65 |
| canterbury-large/E.coli | 4638690 | 1 | 379.2 ± 23.9% | 238.8 ± 14.2% | 0.63 |
| canterbury-large/E.coli | 4638690 | 3 | 351.8 ± 1.1% | 212.6 ± 3.7% | 0.60 |
| canterbury-large/bible.txt | 4047392 | 1 | 395.1 ± 2.1% | 227.1 ± 2.1% | 0.57 |
| canterbury-large/bible.txt | 4047392 | 3 | 289.6 ± 1.7% | 181.4 ± 6.8% | 0.63 |
| canterbury-large/world192.txt | 2473400 | 1 | 466.1 ± 0.6% | 231.7 ± 1.1% | 0.50 |
| canterbury-large/world192.txt | 2473400 | 3 | 316.1 ± 2.1% | 206.1 ± 3.3% | 0.65 |
| http/html-1kx1024 | 1048576 | 1 | 215.4 ± 2.0% | 104.1 ± 1.0% | 0.48 |
| http/html-1kx1024 | 1048576 | 3 | 186.4 ± 1.4% | 102.8 ± 0.8% | 0.55 |
| http/html-16kx64 | 1048576 | 1 | 491.0 ± 2.5% | 294.1 ± 3.0% | 0.60 |
| http/html-16kx64 | 1048576 | 3 | 396.4 ± 1.8% | 276.3 ± 2.9% | 0.70 |
| http/html-1m | 1048576 | 1 | 595.9 ± 0.6% | 334.5 ± 1.4% | 0.56 |
| http/html-1m | 1048576 | 3 | 480.0 ± 2.6% | 294.7 ± 4.2% | 0.61 |
| http/json-1kx1024 | 1048576 | 1 | 265.4 ± 1.4% | 125.4 ± 1.7% | 0.47 |
| http/json-1kx1024 | 1048576 | 3 | 251.6 ± 2.1% | 123.1 ± 1.6% | 0.49 |
| http/json-16kx64 | 1048576 | 1 | 838.3 ± 49.7% | 430.1 ± 20.9% | 0.51 |
| http/json-16kx64 | 1048576 | 3 | 679.9 ± 1.1% | 400.8 ± 6.4% | 0.59 |
| http/json-1m | 1048576 | 1 | 1005.4 ± 1.3% | 500.6 ± 1.7% | 0.50 |
| http/json-1m | 1048576 | 3 | 756.3 ± 1.7% | 413.4 ± 1.5% | 0.55 |
| http/js-1kx1024 | 1048576 | 1 | 196.0 ± 10.7% | 93.3 ± 1.4% | 0.48 |
| http/js-1kx1024 | 1048576 | 3 | 164.6 ± 1.5% | 91.8 ± 2.3% | 0.56 |
| http/js-16kx64 | 1048576 | 1 | 421.0 ± 2.8% | 247.2 ± 3.0% | 0.59 |
| http/js-16kx64 | 1048576 | 3 | 351.6 ± 1.3% | 242.9 ± 2.0% | 0.69 |
| http/js-1m | 1048576 | 1 | 564.1 ± 2.3% | 305.2 ± 2.1% | 0.54 |
| http/js-1m | 1048576 | 3 | 456.7 ± 3.7% | 271.7 ± 3.5% | 0.59 |
| http/css-1kx1024 | 1048576 | 1 | 239.0 ± 2.6% | 114.4 ± 3.3% | 0.48 |
| http/css-1kx1024 | 1048576 | 3 | 213.7 ± 1.2% | 111.5 ± 1.9% | 0.52 |
| http/css-16kx64 | 1048576 | 1 | 677.5 ± 0.8% | 354.3 ± 2.8% | 0.52 |
| http/css-16kx64 | 1048576 | 3 | 595.5 ± 3.9% | 337.1 ± 1.7% | 0.57 |
| http/css-1m | 1048576 | 1 | 3204.4 ± 19.3% | 1222.6 ± 45.1% | 0.38 |
| http/css-1m | 1048576 | 3 | 2626.9 ± 0.3% | 1233.7 ± 2.0% | 0.47 |
| shuffled/dickens-1m | 1048576 | 1 | 1637.9 ± 3.0% | 530.0 ± 4.8% | 0.32 |
| shuffled/dickens-1m | 1048576 | 3 | 234.3 ± 2.8% | 268.4 ± 2.2% | 1.15 |

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
| silesia/dickens | 10192446 | 35.9 | 1217.7 ±42.4% | 1406.7 ±9.2% | 1.16 |
| silesia/mozilla | 51220480 | 35.6 | 1181.1 ±1.1% | 1411.6 ±3.1% | 1.20 |
| silesia/mr | 9970564 | 35.6 | 1335.6 ±5.2% | 1568.4 ±6.4% | 1.17 |
| silesia/nci | 33553445 | 8.4 | 2108.1 ±15.9% | 2702.7 ±5.3% | 1.28 |
| silesia/ooffice | 6152192 | 50.8 | 1078.5 ±55.7% | 1253.6 ±45.5% | 1.16 |
| silesia/osdb | 10085684 | 34.7 | 1704.3 ±2.3% | 1876.1 ±1.7% | 1.10 |
| silesia/reymont | 6627202 | 29.2 | 1355.5 ±1.8% | 1546.2 ±1.0% | 1.14 |
| silesia/samba | 21606400 | 22.9 | 1742.5 ±32.6% | 1967.9 ±2.7% | 1.13 |
| silesia/sao | 7251944 | 76.2 | 984.5 ±4.1% | 1259.1 ±8.5% | 1.28 |
| silesia/webster | 41458703 | 29.2 | 1241.8 ±10.1% | 1359.2 ±7.0% | 1.09 |
| silesia/x-ray | 8474240 | 71.8 | 1022.4 ±9.2% | 1252.8 ±2.2% | 1.23 |
| silesia/xml | 5345280 | 11.9 | 2144.3 ±2.3% | 2566.8 ±2.1% | 1.20 |
| canterbury/alice29.txt | 152089 | 37.5 | 1093.2 ±2.4% | 1336.2 ±1.8% | 1.22 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 1235.7 ±41.3% | 1444.1 ±19.3% | 1.17 |
| canterbury/cp.html | 24603 | 34.4 | 1448.7 ±2.5% | 1696.5 ±2.3% | 1.17 |
| canterbury/fields.c | 11150 | 30.3 | 1228.7 ±3.4% | 1456.1 ±1.6% | 1.19 |
| canterbury/grammar.lsp | 3721 | 34.8 | 963.9 ±2.2% | 1073.3 ±1.1% | 1.11 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1404.9 ±1.2% | 1514.0 ±1.5% | 1.08 |
| canterbury/lcet10.txt | 426754 | 33.0 | 1340.0 ±1.7% | 1639.8 ±2.7% | 1.22 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 1184.0 ±5.3% | 1383.1 ±27.8% | 1.17 |
| canterbury/ptt5 | 513216 | 10.6 | 3590.7 ±3.8% | 3577.4 ±2.8% | 1.00 |
| canterbury/sum | 38240 | 35.0 | 1504.2 ±3.4% | 1606.5 ±4.3% | 1.07 |
| canterbury/xargs.1 | 4227 | 42.7 | 938.0 ±32.5% | 1038.1 ±2.4% | 1.11 |
| canterbury-large/E.coli | 4638690 | 30.0 | 1275.2 ±27.9% | 1510.3 ±10.0% | 1.18 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1376.9 ±2.0% | 1566.8 ±2.1% | 1.14 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1521.4 ±2.9% | 1684.1 ±7.0% | 1.11 |
| http/html-1kx1024 | 1048576 | 39.3 | 499.4 ±7.9% | 531.5 ±1.8% | 1.06 |
| http/html-16kx64 | 1048576 | 21.9 | 1317.6 ±1.1% | 1469.3 ±1.9% | 1.12 |
| http/html-1m | 1048576 | 17.7 | 1727.7 ±4.8% | 1963.0 ±2.9% | 1.14 |
| http/json-1kx1024 | 1048576 | 21.9 | 590.5 ±12.8% | 655.4 ±35.4% | 1.11 |
| http/json-16kx64 | 1048576 | 12.6 | 1684.5 ±1.1% | 2035.3 ±2.3% | 1.21 |
| http/json-1m | 1048576 | 12.2 | 1983.7 ±2.2% | 2820.0 ±2.8% | 1.42 |
| http/js-1kx1024 | 1048576 | 44.5 | 437.7 ±19.3% | 425.5 ±27.0% | 0.97 |
| http/js-16kx64 | 1048576 | 26.0 | 1215.7 ±1.7% | 1346.4 ±2.1% | 1.11 |
| http/js-1m | 1048576 | 19.0 | 1760.4 ±1.9% | 1993.5 ±0.7% | 1.13 |
| http/css-1kx1024 | 1048576 | 29.5 | 546.6 ±0.2% | 589.0 ±3.7% | 1.08 |
| http/css-16kx64 | 1048576 | 15.9 | 1719.4 ±5.1% | 1843.8 ±10.2% | 1.07 |
| http/css-1m | 1048576 | 3.6 | 6298.6 ±1.1% | 6323.7 ±1.9% | 1.00 |
| shuffled/dickens-1m | 1048576 | 58.8 | 1457.7 ±1.0% | 1723.3 ±0.9% | 1.18 |
