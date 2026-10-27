# bench-zstd

| Field | Value |
|---|---|
| Commit | ed0fa2f |
| Runner label | ubuntu-24.04 |
| Image version | 20261023.334.3 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/40590088368 |
| Date | 2026-10-27 |

## Decoding, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 693.3 ±0.1% | 894.7 ±0.1% | 1.29 |
| silesia/mozilla | 51220480 | 35.6 | 833.4 ±0.5% | 1022.0 ±0.4% | 1.23 |
| silesia/mr | 9970564 | 35.6 | 786.9 ±0.2% | 1009.5 ±0.4% | 1.28 |
| silesia/nci | 33553445 | 8.4 | 1574.8 ±1.2% | 1925.0 ±2.0% | 1.22 |
| silesia/ooffice | 6152192 | 50.8 | 686.5 ±1.0% | 849.0 ±0.4% | 1.24 |
| silesia/osdb | 10085684 | 34.7 | 1048.8 ±0.3% | 1241.9 ±0.4% | 1.18 |
| silesia/reymont | 6627202 | 29.2 | 811.8 ±0.8% | 1005.8 ±0.5% | 1.24 |
| silesia/samba | 21606400 | 22.9 | 1186.8 ±0.8% | 1397.2 ±0.7% | 1.18 |
| silesia/sao | 7251944 | 76.2 | 634.8 ±0.3% | 801.0 ±0.5% | 1.26 |
| silesia/webster | 41458703 | 29.2 | 797.9 ±1.7% | 970.7 ±1.3% | 1.22 |
| silesia/x-ray | 8474240 | 71.8 | 605.0 ±0.3% | 802.3 ±0.3% | 1.33 |
| silesia/xml | 5345280 | 11.9 | 1504.8 ±18.1% | 1792.7 ±16.5% | 1.19 |
| canterbury/alice29.txt | 152089 | 37.5 | 635.5 ±0.4% | 831.4 ±0.2% | 1.31 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 718.2 ±0.2% | 923.9 ±0.3% | 1.29 |
| canterbury/cp.html | 24603 | 34.4 | 871.8 ±0.3% | 1043.4 ±0.6% | 1.20 |
| canterbury/fields.c | 11150 | 30.3 | 721.3 ±0.2% | 877.8 ±1.1% | 1.22 |
| canterbury/grammar.lsp | 3721 | 34.8 | 550.9 ±0.3% | 636.6 ±0.6% | 1.16 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 878.8 ±0.7% | 1034.1 ±0.1% | 1.18 |
| canterbury/lcet10.txt | 426754 | 33.0 | 785.7 ±0.6% | 1003.1 ±0.4% | 1.28 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 667.7 ±1.0% | 875.3 ±0.2% | 1.31 |
| canterbury/ptt5 | 513216 | 10.6 | 1696.0 ±0.3% | 2076.0 ±0.2% | 1.22 |
| canterbury/sum | 38240 | 35.0 | 852.6 ±0.3% | 1014.7 ±0.2% | 1.19 |
| canterbury/xargs.1 | 4227 | 42.7 | 532.7 ±0.3% | 620.8 ±0.3% | 1.17 |
| canterbury-large/E.coli | 4638690 | 30.0 | 728.5 ±0.6% | 951.6 ±0.6% | 1.31 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 806.4 ±2.6% | 1022.8 ±1.5% | 1.27 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 951.5 ±1.6% | 1143.3 ±0.3% | 1.20 |
| http/html-1kx1024 | 1048576 | 39.3 | 328.5 ±0.3% | 327.9 ±0.3% | 1.00 |
| http/html-16kx64 | 1048576 | 21.9 | 865.9 ±0.2% | 971.1 ±0.3% | 1.12 |
| http/html-1m | 1048576 | 17.7 | 1137.5 ±0.2% | 1353.2 ±0.2% | 1.19 |
| http/json-1kx1024 | 1048576 | 21.9 | 393.3 ±0.3% | 400.5 ±0.6% | 1.02 |
| http/json-16kx64 | 1048576 | 12.6 | 1131.4 ±0.3% | 1286.4 ±0.4% | 1.14 |
| http/json-1m | 1048576 | 12.2 | 1346.8 ±0.4% | 1665.9 ±0.4% | 1.24 |
| http/js-1kx1024 | 1048576 | 44.5 | 286.3 ±0.3% | 269.3 ±0.3% | 0.94 |
| http/js-16kx64 | 1048576 | 26.0 | 773.9 ±0.2% | 887.7 ±0.4% | 1.15 |
| http/js-1m | 1048576 | 19.0 | 1114.1 ±0.2% | 1324.1 ±0.3% | 1.19 |
| http/css-1kx1024 | 1048576 | 29.5 | 354.6 ±0.2% | 357.9 ±0.2% | 1.01 |
| http/css-16kx64 | 1048576 | 15.9 | 1029.6 ±0.1% | 1134.0 ±0.3% | 1.10 |
| http/css-1m | 1048576 | 3.6 | 3490.3 ±0.5% | 3645.1 ±0.4% | 1.04 |
| shuffled/dickens-1m | 1048576 | 58.8 | 889.8 ±0.3% | 1035.8 ±0.2% | 1.16 |

## stdx's fast paths against its checked path, libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 207.8 ±0.3% | 892.1 ±0.3% | 4.29 |
| silesia/mozilla | 51220480 | 35.6 | 250.5 ±0.8% | 1017.2 ±1.6% | 4.06 |
| silesia/mr | 9970564 | 35.6 | 216.8 ±0.2% | 1003.1 ±0.2% | 4.63 |
| silesia/nci | 33553445 | 8.4 | 582.4 ±0.9% | 1931.6 ±1.9% | 3.32 |
| silesia/ooffice | 6152192 | 50.8 | 183.7 ±0.1% | 850.6 ±0.4% | 4.63 |
| silesia/osdb | 10085684 | 34.7 | 293.5 ±0.9% | 1238.5 ±0.6% | 4.22 |
| silesia/reymont | 6627202 | 29.2 | 252.9 ±0.3% | 1013.2 ±0.4% | 4.01 |
| silesia/samba | 21606400 | 22.9 | 386.3 ±0.3% | 1388.4 ±0.1% | 3.59 |
| silesia/sao | 7251944 | 76.2 | 167.7 ±0.4% | 799.4 ±1.0% | 4.77 |
| silesia/webster | 41458703 | 29.2 | 249.6 ±1.6% | 1003.2 ±0.5% | 4.02 |
| silesia/x-ray | 8474240 | 71.8 | 156.8 ±4.8% | 794.8 ±3.2% | 5.07 |
| silesia/xml | 5345280 | 11.9 | 523.0 ±0.4% | 1795.1 ±0.4% | 3.43 |
| canterbury/alice29.txt | 152089 | 37.5 | 181.7 ±0.4% | 834.1 ±0.5% | 4.59 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 179.6 ±0.3% | 922.9 ±0.2% | 5.14 |
| canterbury/cp.html | 24603 | 34.4 | 237.4 ±0.5% | 1044.9 ±0.7% | 4.40 |
| canterbury/fields.c | 11150 | 30.3 | 215.9 ±0.7% | 885.9 ±0.3% | 4.10 |
| canterbury/grammar.lsp | 3721 | 34.8 | 187.5 ±0.2% | 631.3 ±0.6% | 3.37 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 258.0 ±1.1% | 1032.9 ±0.3% | 4.00 |
| canterbury/lcet10.txt | 426754 | 33.0 | 220.6 ±1.8% | 1002.7 ±2.5% | 4.55 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 183.1 ±0.3% | 875.7 ±1.6% | 4.78 |
| canterbury/ptt5 | 513216 | 10.6 | 418.6 ±0.3% | 2076.9 ±0.4% | 4.96 |
| canterbury/sum | 38240 | 35.0 | 232.7 ±0.4% | 1012.6 ±0.3% | 4.35 |
| canterbury/xargs.1 | 4227 | 42.7 | 164.8 ±1.6% | 613.6 ±1.6% | 3.72 |
| canterbury-large/E.coli | 4638690 | 30.0 | 221.0 ±24.7% | 950.3 ±0.3% | 4.30 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 251.3 ±0.3% | 1017.9 ±0.4% | 4.05 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 282.4 ±0.7% | 1144.4 ±0.6% | 4.05 |
| http/html-1kx1024 | 1048576 | 39.3 | 161.4 ±0.7% | 328.4 ±0.2% | 2.03 |
| http/html-16kx64 | 1048576 | 21.9 | 282.6 ±8.3% | 971.3 ±1.1% | 3.44 |
| http/html-1m | 1048576 | 17.7 | 369.8 ±0.3% | 1348.4 ±0.2% | 3.65 |
| http/json-1kx1024 | 1048576 | 21.9 | 233.8 ±0.2% | 401.3 ±0.1% | 1.72 |
| http/json-16kx64 | 1048576 | 12.6 | 397.0 ±0.2% | 1287.2 ±0.6% | 3.24 |
| http/json-1m | 1048576 | 12.2 | 446.0 ±0.3% | 1666.7 ±0.4% | 3.74 |
| http/js-1kx1024 | 1048576 | 44.5 | 133.9 ±0.4% | 270.1 ±0.4% | 2.02 |
| http/js-16kx64 | 1048576 | 26.0 | 242.9 ±0.4% | 888.2 ±0.4% | 3.66 |
| http/js-1m | 1048576 | 19.0 | 352.8 ±0.4% | 1323.5 ±1.0% | 3.75 |
| http/css-1kx1024 | 1048576 | 29.5 | 197.3 ±0.3% | 361.4 ±0.3% | 1.83 |
| http/css-16kx64 | 1048576 | 15.9 | 346.7 ±0.2% | 1131.2 ±0.2% | 3.26 |
| http/css-1m | 1048576 | 3.6 | 1422.4 ±0.3% | 3644.3 ±0.3% | 2.56 |
| shuffled/dickens-1m | 1048576 | 58.8 | 172.5 ±0.2% | 1034.5 ±0.2% | 6.00 |

## Decision 14's claims, each off against the fast paths with all on, libzstd level 3

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | Z1 interleaved streams off | Z2 pairs off | Z4 chunk copies off | Z5 block in input off | Z6 window once off |
|---|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 35.9 | 894.7 ±0.7% | 0.92 ±0.6% | 1.00 ±0.6% | 0.49 ±0.5% | 0.99 ±0.7% | 0.31 ±0.5% |
| silesia/mozilla | 51220480 | 35.6 | 1016.8 ±1.7% | 0.72 ±0.8% | 1.00 ±2.3% | 0.55 ±2.3% | 1.00 ±2.8% | 0.39 ±1.4% |
| silesia/mr | 9970564 | 35.6 | 1006.2 ±2.4% | 0.78 ±2.2% | 0.99 ±1.0% | 0.49 ±0.6% | 0.98 ±2.6% | 0.33 ±2.4% |
| silesia/nci | 33553445 | 8.4 | 1911.3 ±3.2% | 0.93 ±1.2% | 0.99 ±2.7% | 0.57 ±2.5% | 1.00 ±0.9% | 0.38 ±2.2% |
| silesia/ooffice | 6152192 | 50.8 | 849.2 ±0.6% | 0.60 ±0.2% | 1.00 ±0.1% | 0.54 ±0.4% | 0.99 ±0.2% | 0.40 ±0.4% |
| silesia/osdb | 10085684 | 34.7 | 1239.1 ±0.7% | 0.64 ±2.1% | 1.00 ±2.4% | 0.62 ±1.1% | 0.99 ±0.6% | 0.40 ±0.5% |
| silesia/reymont | 6627202 | 29.2 | 913.3 ±0.8% | 1.04 ±0.2% | 1.11 ±0.9% | 0.57 ±0.2% | 1.10 ±0.3% | 0.36 ±0.4% |
| silesia/samba | 21606400 | 22.9 | 1397.0 ±0.6% | 0.90 ±0.7% | 1.00 ±0.5% | 0.56 ±0.3% | 0.99 ±0.5% | 0.37 ±1.1% |
| silesia/sao | 7251944 | 76.2 | 800.2 ±0.8% | 0.48 ±2.4% | 1.00 ±0.4% | 0.64 ±0.3% | 0.98 ±0.2% | 0.47 ±0.6% |
| silesia/webster | 41458703 | 29.2 | 957.8 ±3.1% | 0.90 ±5.2% | 1.00 ±2.7% | 0.53 ±2.7% | 1.00 ±3.1% | 0.35 ±1.6% |
| silesia/x-ray | 8474240 | 71.8 | 801.1 ±0.4% | 0.48 ±0.7% | 1.00 ±0.7% | 0.60 ±0.2% | 0.98 ±0.7% | 0.43 ±0.5% |
| silesia/xml | 5345280 | 11.9 | 1794.0 ±0.2% | 0.92 ±0.2% | 1.00 ±0.5% | 0.57 ±0.4% | 1.00 ±0.4% | 0.38 ±0.3% |
| canterbury/alice29.txt | 152089 | 37.5 | 828.4 ±0.1% | 0.94 ±2.4% | 1.01 ±0.3% | 0.48 ±1.0% | 1.00 ±0.2% | 0.31 ±1.5% |
| canterbury/asyoulik.txt | 125179 | 40.2 | 926.4 ±0.1% | 0.84 ±0.4% | 0.98 ±0.2% | 0.47 ±2.1% | 0.99 ±4.7% | 0.32 ±0.4% |
| canterbury/cp.html | 24603 | 34.4 | 1042.7 ±0.2% | 0.63 ±0.5% | 1.00 ±0.2% | 0.64 ±0.2% | 0.99 ±0.3% | 0.42 ±0.3% |
| canterbury/fields.c | 11150 | 30.3 | 875.0 ±0.3% | 0.80 ±0.3% | 1.01 ±1.4% | 0.59 ±0.1% | 0.99 ±1.8% | 0.37 ±22.0% |
| canterbury/grammar.lsp | 3721 | 34.8 | 622.0 ±0.8% | 0.81 ±0.5% | 1.02 ±0.1% | 0.66 ±0.2% | 1.00 ±0.4% | 0.46 ±0.4% |
| canterbury/kennedy.xls | 1029744 | 10.9 | 1031.6 ±6.6% | 0.86 ±14.9% | 1.01 ±0.1% | 0.51 ±1.3% | 1.00 ±0.2% | 0.32 ±0.1% |
| canterbury/lcet10.txt | 426754 | 33.0 | 1009.3 ±0.3% | 0.89 ±0.4% | 1.00 ±0.4% | 0.48 ±0.2% | 0.98 ±0.4% | 0.32 ±0.3% |
| canterbury/plrabn12.txt | 481861 | 39.8 | 873.3 ±0.7% | 0.90 ±1.2% | 1.00 ±0.5% | 0.47 ±0.2% | 0.99 ±0.1% | 0.31 ±0.6% |
| canterbury/ptt5 | 513216 | 10.6 | 2084.0 ±0.2% | 0.80 ±0.4% | 1.01 ±0.3% | 0.50 ±0.4% | 0.99 ±0.3% | 0.40 ±0.6% |
| canterbury/sum | 38240 | 35.0 | 1013.1 ±0.2% | 0.63 ±0.5% | 1.00 ±0.2% | 0.64 ±1.0% | 1.00 ±0.2% | 0.42 ±0.9% |
| canterbury/xargs.1 | 4227 | 42.7 | 613.0 ±0.3% | 0.74 ±0.4% | 1.00 ±0.3% | 0.63 ±0.3% | 1.00 ±0.4% | 0.43 ±0.2% |
| canterbury-large/E.coli | 4638690 | 30.0 | 950.8 ±10.7% | 0.98 ±0.6% | 0.99 ±0.3% | 0.49 ±1.8% | 0.99 ±0.4% | 0.31 ±0.3% |
| canterbury-large/bible.txt | 4047392 | 28.9 | 1019.3 ±0.5% | 0.96 ±0.4% | 1.00 ±0.3% | 0.51 ±1.2% | 0.99 ±0.6% | 0.32 ±0.5% |
| canterbury-large/world192.txt | 2473400 | 26.5 | 1144.6 ±0.6% | 0.89 ±0.3% | 1.00 ±0.4% | 0.53 ±0.4% | 0.99 ±0.3% | 0.35 ±0.3% |
| http/html-1kx1024 | 1048576 | 39.3 | 326.3 ±0.1% | 0.87 ±0.2% | 1.01 ±0.4% | 0.77 ±0.2% | 0.99 ±0.2% | 0.63 ±0.6% |
| http/html-16kx64 | 1048576 | 21.9 | 974.9 ±0.4% | 0.82 ±0.6% | 1.00 ±0.4% | 0.59 ±0.1% | 0.99 ±0.4% | 0.42 ±0.3% |
| http/html-1m | 1048576 | 17.7 | 1351.6 ±0.1% | 0.93 ±0.2% | 1.00 ±0.3% | 0.55 ±0.5% | 0.99 ±0.2% | 0.35 ±0.2% |
| http/json-1kx1024 | 1048576 | 21.9 | 399.2 ±0.3% | 0.99 ±0.2% | 1.01 ±0.9% | 0.80 ±0.3% | 0.99 ±0.5% | 0.66 ±2.7% |
| http/json-16kx64 | 1048576 | 12.6 | 1292.0 ±3.4% | 0.85 ±0.9% | 0.99 ±2.9% | 0.60 ±0.2% | 0.99 ±0.2% | 0.43 ±0.5% |
| http/json-1m | 1048576 | 12.2 | 1664.6 ±0.6% | 0.88 ±0.3% | 1.00 ±0.2% | 0.55 ±12.1% | 0.99 ±0.2% | 0.36 ±0.2% |
| http/js-1kx1024 | 1048576 | 44.5 | 270.1 ±0.2% | 0.87 ±0.2% | 1.00 ±0.3% | 0.76 ±0.5% | 0.98 ±0.7% | 0.64 ±0.4% |
| http/js-16kx64 | 1048576 | 26.0 | 890.7 ±0.4% | 0.82 ±0.2% | 1.00 ±0.3% | 0.56 ±0.1% | 0.99 ±0.1% | 0.40 ±0.1% |
| http/js-1m | 1048576 | 19.0 | 1314.2 ±0.3% | 0.92 ±0.4% | 1.01 ±1.5% | 0.55 ±7.4% | 1.00 ±1.4% | 0.35 ±22.5% |
| http/css-1kx1024 | 1048576 | 29.5 | 360.3 ±0.7% | 0.95 ±0.1% | 0.99 ±0.2% | 0.78 ±0.2% | 0.99 ±0.1% | 0.64 ±0.8% |
| http/css-16kx64 | 1048576 | 15.9 | 1136.5 ±1.3% | 0.88 ±0.2% | 0.99 ±0.9% | 0.62 ±0.2% | 0.99 ±4.2% | 0.41 ±0.6% |
| http/css-1m | 1048576 | 3.6 | 3649.1 ±0.3% | 0.95 ±0.3% | 1.00 ±0.2% | 0.71 ±0.9% | 1.00 ±0.2% | 0.44 ±0.2% |
| shuffled/dickens-1m | 1048576 | 58.8 | 1035.0 ±0.4% | 0.50 ±1.2% | 0.86 ±0.2% | 0.70 ±0.4% | 0.98 ±0.4% | 0.50 ±0.2% |

## Encoding speed

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | libzstd, MB/s | stdx, MB/s | stdx / libzstd |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 266.0 ± 0.5% | 93.4 ± 1.8% | 0.35 |
| silesia/dickens | 10192446 | 3 | 146.4 ± 0.3% | 80.6 ± 0.6% | 0.55 |
| silesia/mozilla | 51220480 | 1 | 391.5 ± 16.1% | 128.4 ± 1.7% | 0.33 |
| silesia/mozilla | 51220480 | 3 | 210.3 ± 0.4% | 111.7 ± 0.4% | 0.53 |
| silesia/mr | 9970564 | 1 | 357.9 ± 0.5% | 117.0 ± 0.4% | 0.33 |
| silesia/mr | 9970564 | 3 | 170.3 ± 1.2% | 93.5 ± 1.1% | 0.55 |
| silesia/nci | 33553445 | 1 | 805.7 ± 0.3% | 296.3 ± 0.4% | 0.37 |
| silesia/nci | 33553445 | 3 | 636.6 ± 0.6% | 263.9 ± 1.4% | 0.41 |
| silesia/ooffice | 6152192 | 1 | 323.1 ± 0.1% | 98.7 ± 0.3% | 0.31 |
| silesia/ooffice | 6152192 | 3 | 144.8 ± 0.4% | 82.0 ± 0.5% | 0.57 |
| silesia/osdb | 10085684 | 1 | 388.7 ± 0.2% | 141.1 ± 0.9% | 0.36 |
| silesia/osdb | 10085684 | 3 | 205.2 ± 0.4% | 116.1 ± 0.8% | 0.57 |
| silesia/reymont | 6627202 | 1 | 274.9 ± 0.4% | 111.9 ± 0.4% | 0.41 |
| silesia/reymont | 6627202 | 3 | 191.6 ± 1.2% | 101.5 ± 0.9% | 0.53 |
| silesia/samba | 21606400 | 1 | 462.8 ± 0.4% | 167.7 ± 0.4% | 0.36 |
| silesia/samba | 21606400 | 3 | 292.3 ± 0.6% | 149.6 ± 0.8% | 0.51 |
| silesia/sao | 7251944 | 1 | 301.5 ± 0.3% | 91.7 ± 1.4% | 0.30 |
| silesia/sao | 7251944 | 3 | 109.3 ± 0.4% | 70.8 ± 1.2% | 0.65 |
| silesia/webster | 41458703 | 1 | 308.9 ± 1.1% | 112.2 ± 0.4% | 0.36 |
| silesia/webster | 41458703 | 3 | 181.5 ± 0.3% | 98.0 ± 0.8% | 0.54 |
| silesia/x-ray | 8474240 | 1 | 656.7 ± 0.2% | 94.3 ± 0.3% | 0.14 |
| silesia/x-ray | 8474240 | 3 | 105.3 ± 0.5% | 72.4 ± 0.5% | 0.69 |
| silesia/xml | 5345280 | 1 | 648.7 ± 2.7% | 224.0 ± 8.0% | 0.35 |
| silesia/xml | 5345280 | 3 | 474.5 ± 3.8% | 216.4 ± 6.2% | 0.46 |
| canterbury/alice29.txt | 152089 | 1 | 243.6 ± 0.5% | 98.4 ± 0.2% | 0.40 |
| canterbury/alice29.txt | 152089 | 3 | 167.7 ± 0.6% | 84.5 ± 0.4% | 0.50 |
| canterbury/asyoulik.txt | 125179 | 1 | 264.6 ± 0.5% | 91.2 ± 0.6% | 0.34 |
| canterbury/asyoulik.txt | 125179 | 3 | 170.3 ± 0.6% | 80.4 ± 0.5% | 0.47 |
| canterbury/cp.html | 24603 | 1 | 424.7 ± 0.2% | 141.0 ± 3.5% | 0.33 |
| canterbury/cp.html | 24603 | 3 | 274.2 ± 0.2% | 131.9 ± 0.9% | 0.48 |
| canterbury/fields.c | 11150 | 1 | 344.5 ± 0.4% | 149.3 ± 2.7% | 0.43 |
| canterbury/fields.c | 11150 | 3 | 286.3 ± 0.7% | 142.0 ± 0.4% | 0.50 |
| canterbury/grammar.lsp | 3721 | 1 | 283.0 ± 0.4% | 116.2 ± 0.2% | 0.41 |
| canterbury/grammar.lsp | 3721 | 3 | 233.1 ± 0.3% | 112.4 ± 1.1% | 0.48 |
| canterbury/kennedy.xls | 1029744 | 1 | 426.8 ± 1.8% | 159.5 ± 0.1% | 0.37 |
| canterbury/kennedy.xls | 1029744 | 3 | 373.9 ± 0.4% | 139.6 ± 0.8% | 0.37 |
| canterbury/lcet10.txt | 426754 | 1 | 265.4 ± 5.2% | 104.2 ± 0.8% | 0.39 |
| canterbury/lcet10.txt | 426754 | 3 | 171.8 ± 0.7% | 90.9 ± 0.6% | 0.53 |
| canterbury/plrabn12.txt | 481861 | 1 | 256.5 ± 3.7% | 88.3 ± 0.5% | 0.34 |
| canterbury/plrabn12.txt | 481861 | 3 | 138.7 ± 1.8% | 75.8 ± 0.8% | 0.55 |
| canterbury/ptt5 | 513216 | 1 | 865.4 ± 0.3% | 289.7 ± 1.1% | 0.33 |
| canterbury/ptt5 | 513216 | 3 | 606.9 ± 0.9% | 267.0 ± 0.4% | 0.44 |
| canterbury/sum | 38240 | 1 | 434.3 ± 0.1% | 132.2 ± 0.2% | 0.30 |
| canterbury/sum | 38240 | 3 | 287.9 ± 28.6% | 117.8 ± 2.0% | 0.41 |
| canterbury/xargs.1 | 4227 | 1 | 274.3 ± 0.5% | 111.7 ± 0.2% | 0.41 |
| canterbury/xargs.1 | 4227 | 3 | 205.5 ± 0.8% | 104.2 ± 0.6% | 0.51 |
| canterbury-large/E.coli | 4638690 | 1 | 251.0 ± 0.3% | 105.1 ± 1.2% | 0.42 |
| canterbury-large/E.coli | 4638690 | 3 | 195.3 ± 1.1% | 103.9 ± 1.5% | 0.53 |
| canterbury-large/bible.txt | 4047392 | 1 | 269.7 ± 0.4% | 111.7 ± 1.7% | 0.41 |
| canterbury-large/bible.txt | 4047392 | 3 | 184.4 ± 7.0% | 99.3 ± 24.8% | 0.54 |
| canterbury-large/world192.txt | 2473400 | 1 | 324.8 ± 0.6% | 122.2 ± 0.5% | 0.38 |
| canterbury-large/world192.txt | 2473400 | 3 | 207.9 ± 1.0% | 113.5 ± 0.8% | 0.55 |
| http/html-1kx1024 | 1048576 | 1 | 152.1 ± 8.5% | 55.2 ± 3.5% | 0.36 |
| http/html-1kx1024 | 1048576 | 3 | 129.4 ± 4.7% | 53.7 ± 4.4% | 0.42 |
| http/html-16kx64 | 1048576 | 1 | 347.3 ± 0.4% | 148.4 ± 4.7% | 0.43 |
| http/html-16kx64 | 1048576 | 3 | 294.4 ± 1.0% | 142.6 ± 0.7% | 0.48 |
| http/html-1m | 1048576 | 1 | 426.0 ± 0.2% | 172.8 ± 0.3% | 0.41 |
| http/html-1m | 1048576 | 3 | 318.4 ± 0.9% | 162.0 ± 0.8% | 0.51 |
| http/json-1kx1024 | 1048576 | 1 | 185.9 ± 0.3% | 68.5 ± 0.5% | 0.37 |
| http/json-1kx1024 | 1048576 | 3 | 173.5 ± 2.6% | 66.8 ± 4.2% | 0.38 |
| http/json-16kx64 | 1048576 | 1 | 572.2 ± 0.4% | 214.9 ± 0.9% | 0.38 |
| http/json-16kx64 | 1048576 | 3 | 486.2 ± 0.4% | 201.8 ± 1.0% | 0.41 |
| http/json-1m | 1048576 | 1 | 676.2 ± 0.4% | 245.0 ± 0.4% | 0.36 |
| http/json-1m | 1048576 | 3 | 489.0 ± 0.7% | 220.9 ± 0.5% | 0.45 |
| http/js-1kx1024 | 1048576 | 1 | 139.1 ± 0.3% | 49.5 ± 0.4% | 0.36 |
| http/js-1kx1024 | 1048576 | 3 | 113.8 ± 0.2% | 48.0 ± 0.4% | 0.42 |
| http/js-16kx64 | 1048576 | 1 | 300.3 ± 0.3% | 125.1 ± 0.6% | 0.42 |
| http/js-16kx64 | 1048576 | 3 | 254.9 ± 0.6% | 121.2 ± 1.0% | 0.48 |
| http/js-1m | 1048576 | 1 | 403.9 ± 0.2% | 156.6 ± 1.2% | 0.39 |
| http/js-1m | 1048576 | 3 | 294.6 ± 1.5% | 149.9 ± 0.3% | 0.51 |
| http/css-1kx1024 | 1048576 | 1 | 169.2 ± 0.2% | 62.1 ± 0.5% | 0.37 |
| http/css-1kx1024 | 1048576 | 3 | 151.0 ± 0.2% | 60.4 ± 0.7% | 0.40 |
| http/css-16kx64 | 1048576 | 1 | 444.9 ± 0.5% | 169.0 ± 0.4% | 0.38 |
| http/css-16kx64 | 1048576 | 3 | 399.1 ± 0.5% | 167.6 ± 0.4% | 0.42 |
| http/css-1m | 1048576 | 1 | 1913.4 ± 0.4% | 589.6 ± 0.7% | 0.31 |
| http/css-1m | 1048576 | 3 | 1514.8 ± 2.7% | 626.8 ± 0.2% | 0.41 |
| shuffled/dickens-1m | 1048576 | 1 | 975.1 ± 0.9% | 173.9 ± 0.4% | 0.18 |
| shuffled/dickens-1m | 1048576 | 3 | 112.0 ± 1.5% | 111.7 ± 0.8% | 1.00 |

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
| silesia/dickens | 10192446 | 35.9 | 674.4 ±0.9% | 877.4 ±0.8% | 1.30 |
| silesia/mozilla | 51220480 | 35.6 | 833.7 ±0.5% | 1017.7 ±4.0% | 1.22 |
| silesia/mr | 9970564 | 35.6 | 773.9 ±0.5% | 983.0 ±3.3% | 1.27 |
| silesia/nci | 33553445 | 8.4 | 1571.1 ±0.9% | 1929.9 ±0.6% | 1.23 |
| silesia/ooffice | 6152192 | 50.8 | 688.2 ±0.8% | 838.9 ±4.4% | 1.22 |
| silesia/osdb | 10085684 | 34.7 | 1044.0 ±0.4% | 1216.6 ±2.9% | 1.17 |
| silesia/reymont | 6627202 | 29.2 | 795.4 ±0.9% | 998.8 ±0.6% | 1.26 |
| silesia/samba | 21606400 | 22.9 | 1120.1 ±13.7% | 1290.1 ±7.8% | 1.15 |
| silesia/sao | 7251944 | 76.2 | 631.8 ±1.0% | 775.0 ±0.6% | 1.23 |
| silesia/webster | 41458703 | 29.2 | 811.6 ±0.8% | 987.9 ±0.6% | 1.22 |
| silesia/x-ray | 8474240 | 71.8 | 599.8 ±1.7% | 783.4 ±6.4% | 1.31 |
| silesia/xml | 5345280 | 11.9 | 1499.0 ±0.6% | 1796.1 ±0.4% | 1.20 |
| canterbury/alice29.txt | 152089 | 37.5 | 626.2 ±0.4% | 832.1 ±0.3% | 1.33 |
| canterbury/asyoulik.txt | 125179 | 40.2 | 708.5 ±0.6% | 926.7 ±0.1% | 1.31 |
| canterbury/cp.html | 24603 | 34.4 | 867.8 ±0.2% | 1038.9 ±0.7% | 1.20 |
| canterbury/fields.c | 11150 | 30.3 | 717.0 ±0.3% | 874.7 ±0.3% | 1.22 |
| canterbury/grammar.lsp | 3721 | 34.8 | 555.6 ±0.3% | 628.3 ±0.5% | 1.13 |
| canterbury/kennedy.xls | 1029744 | 10.9 | 875.4 ±0.5% | 1034.7 ±0.2% | 1.18 |
| canterbury/lcet10.txt | 426754 | 33.0 | 775.8 ±0.3% | 1007.7 ±0.4% | 1.30 |
| canterbury/plrabn12.txt | 481861 | 39.8 | 660.4 ±2.5% | 880.8 ±0.4% | 1.33 |
| canterbury/ptt5 | 513216 | 10.6 | 1700.9 ±0.3% | 2103.5 ±3.2% | 1.24 |
| canterbury/sum | 38240 | 35.0 | 863.3 ±1.5% | 1022.6 ±0.2% | 1.18 |
| canterbury/xargs.1 | 4227 | 42.7 | 540.2 ±0.2% | 608.7 ±0.5% | 1.13 |
| canterbury-large/E.coli | 4638690 | 30.0 | 716.4 ±0.3% | 941.6 ±0.3% | 1.31 |
| canterbury-large/bible.txt | 4047392 | 28.9 | 794.1 ±0.3% | 1009.8 ±0.5% | 1.27 |
| canterbury-large/world192.txt | 2473400 | 26.5 | 942.6 ±0.6% | 1128.2 ±0.7% | 1.20 |
| http/html-1kx1024 | 1048576 | 39.3 | 335.7 ±1.1% | 338.0 ±1.1% | 1.01 |
| http/html-16kx64 | 1048576 | 21.9 | 868.9 ±0.2% | 973.5 ±0.1% | 1.12 |
| http/html-1m | 1048576 | 17.7 | 1129.0 ±0.6% | 1344.1 ±0.4% | 1.19 |
| http/json-1kx1024 | 1048576 | 21.9 | 398.7 ±0.3% | 419.0 ±0.5% | 1.05 |
| http/json-16kx64 | 1048576 | 12.6 | 1139.8 ±0.5% | 1297.6 ±0.1% | 1.14 |
| http/json-1m | 1048576 | 12.2 | 1346.5 ±0.3% | 1670.7 ±0.1% | 1.24 |
| http/js-1kx1024 | 1048576 | 44.5 | 292.2 ±0.7% | 277.4 ±0.3% | 0.95 |
| http/js-16kx64 | 1048576 | 26.0 | 774.4 ±1.6% | 887.7 ±0.1% | 1.15 |
| http/js-1m | 1048576 | 19.0 | 1105.3 ±0.5% | 1319.8 ±0.5% | 1.19 |
| http/css-1kx1024 | 1048576 | 29.5 | 361.5 ±0.1% | 374.3 ±2.0% | 1.04 |
| http/css-16kx64 | 1048576 | 15.9 | 1034.6 ±0.2% | 1135.7 ±0.4% | 1.10 |
| http/css-1m | 1048576 | 3.6 | 3457.9 ±19.9% | 3644.6 ±1.7% | 1.05 |
| shuffled/dickens-1m | 1048576 | 58.8 | 901.6 ±0.4% | 1034.7 ±0.2% | 1.15 |
