# bench-brotli

| Field | Value |
|---|---|
| Commit | 62875f6 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260927.135.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/37233768758 |
| Date | 2026-10-04 |

## Decoding, quality 11, window 22

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Google, MB/s | stdx, MB/s | stdx / Google |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 447.3 ±0.4% | 607.5 ±1.2% | 1.36 |
| silesia/mozilla | 51220480 | 27.5 | 353.1 ±0.3% | 463.5 ±1.0% | 1.31 |
| silesia/mr | 9970564 | 28.3 | 318.7 ±6.9% | 450.7 ±25.0% | 1.41 |
| silesia/nci | 33553445 | 4.8 | 1608.6 ±0.8% | 1982.8 ±4.9% | 1.23 |
| silesia/ooffice | 6152192 | 40.3 | 243.1 ±1.0% | 305.1 ±1.0% | 1.26 |
| silesia/osdb | 10085684 | 28.0 | 389.4 ±0.5% | 581.7 ±1.1% | 1.49 |
| silesia/reymont | 6627202 | 20.2 | 611.7 ±0.5% | 846.4 ±0.4% | 1.38 |
| silesia/samba | 21606400 | 17.7 | 629.8 ±0.6% | 883.8 ±0.9% | 1.40 |
| silesia/sao | 7251944 | 63.3 | 193.1 ±0.6% | 294.4 ±1.1% | 1.52 |
| silesia/webster | 41458703 | 21.2 | 548.0 ±0.7% | 728.0 ±1.3% | 1.33 |
| silesia/x-ray | 8474240 | 55.3 | 162.0 ±0.7% | 206.4 ±0.3% | 1.27 |
| silesia/xml | 5345280 | 8.1 | 1299.6 ±0.5% | 1898.9 ±0.4% | 1.46 |
| canterbury/alice29.txt | 152089 | 30.6 | 380.3 ±0.2% | 562.0 ±1.0% | 1.48 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 324.1 ±0.1% | 481.6 ±0.9% | 1.49 |
| canterbury/cp.html | 24603 | 28.0 | 373.0 ±0.5% | 590.6 ±3.7% | 1.58 |
| canterbury/fields.c | 11150 | 24.4 | 485.0 ±1.0% | 699.4 ±0.2% | 1.44 |
| canterbury/grammar.lsp | 3721 | 30.2 | 344.7 ±0.3% | 471.0 ±0.3% | 1.37 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 607.9 ±0.3% | 887.7 ±0.6% | 1.46 |
| canterbury/lcet10.txt | 426754 | 26.6 | 435.1 ±0.2% | 646.1 ±0.4% | 1.48 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 371.3 ±0.1% | 551.0 ±0.2% | 1.48 |
| canterbury/ptt5 | 513216 | 8.0 | 792.1 ±0.2% | 1444.9 ±0.5% | 1.82 |
| canterbury/sum | 38240 | 26.5 | 313.0 ±0.2% | 416.0 ±0.5% | 1.33 |
| canterbury/xargs.1 | 4227 | 34.6 | 312.2 ±1.7% | 399.0 ±0.2% | 1.28 |
| canterbury-large/E.coli | 4638690 | 24.5 | 433.7 ±0.3% | 495.1 ±0.2% | 1.14 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 599.4 ±0.6% | 872.9 ±0.5% | 1.46 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 580.8 ±0.4% | 803.2 ±0.4% | 1.38 |
| http/html-1kx1024 | 1048576 | 30.3 | 189.0 ±0.1% | 220.1 ±0.1% | 1.16 |
| http/html-16kx64 | 1048576 | 16.8 | 501.7 ±0.1% | 658.6 ±0.1% | 1.31 |
| http/html-1m | 1048576 | 13.0 | 831.9 ±0.3% | 1196.4 ±0.5% | 1.44 |
| http/json-1kx1024 | 1048576 | 18.2 | 237.3 ±0.1% | 257.7 ±0.1% | 1.09 |
| http/json-16kx64 | 1048576 | 8.9 | 767.3 ±0.1% | 1005.1 ±0.2% | 1.31 |
| http/json-1m | 1048576 | 7.7 | 987.6 ±0.4% | 1380.8 ±0.1% | 1.40 |
| http/js-1kx1024 | 1048576 | 35.1 | 171.0 ±0.1% | 205.1 ±0.2% | 1.20 |
| http/js-16kx64 | 1048576 | 20.7 | 421.1 ±0.3% | 563.6 ±0.2% | 1.34 |
| http/js-1m | 1048576 | 14.0 | 771.7 ±0.5% | 1073.3 ±0.6% | 1.39 |
| http/css-1kx1024 | 1048576 | 22.5 | 220.9 ±0.2% | 242.8 ±0.1% | 1.10 |
| http/css-16kx64 | 1048576 | 11.7 | 685.8 ±0.1% | 885.8 ±0.1% | 1.29 |
| http/css-1m | 1048576 | 2.4 | 1396.6 ±0.2% | 4690.7 ±0.4% | 3.36 |
| shuffled/dickens-1m | 1048576 | 56.8 | 349.9 ±0.5% | 386.7 ±0.1% | 1.11 |

## stdx's fast path against its checked path

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Checked, MB/s | Fast, MB/s | Fast / checked |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 114.3 ±1.0% | 610.7 ±1.2% | 5.34 |
| silesia/mozilla | 51220480 | 27.5 | 110.3 ±0.3% | 463.4 ±1.2% | 4.20 |
| silesia/mr | 9970564 | 28.3 | 109.8 ±2.7% | 444.7 ±3.1% | 4.05 |
| silesia/nci | 33553445 | 4.8 | 213.3 ±0.3% | 2006.2 ±3.4% | 9.40 |
| silesia/ooffice | 6152192 | 40.3 | 83.2 ±1.2% | 305.1 ±1.4% | 3.67 |
| silesia/osdb | 10085684 | 28.0 | 122.8 ±14.1% | 579.7 ±12.7% | 4.72 |
| silesia/reymont | 6627202 | 20.2 | 138.8 ±0.9% | 852.6 ±0.9% | 6.14 |
| silesia/samba | 21606400 | 17.7 | 152.0 ±0.5% | 885.1 ±1.0% | 5.82 |
| silesia/sao | 7251944 | 63.3 | 80.1 ±0.4% | 296.7 ±1.4% | 3.71 |
| silesia/webster | 41458703 | 21.2 | 128.8 ±1.6% | 725.8 ±1.5% | 5.64 |
| silesia/x-ray | 8474240 | 55.3 | 69.7 ±3.0% | 210.3 ±1.0% | 3.02 |
| silesia/xml | 5345280 | 8.1 | 200.8 ±0.4% | 1906.5 ±0.3% | 9.49 |
| canterbury/alice29.txt | 152089 | 30.6 | 109.2 ±0.1% | 560.7 ±0.4% | 5.13 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 100.2 ±0.3% | 482.2 ±0.3% | 4.81 |
| canterbury/cp.html | 24603 | 28.0 | 112.1 ±0.2% | 603.5 ±4.0% | 5.38 |
| canterbury/fields.c | 11150 | 24.4 | 116.7 ±0.1% | 697.5 ±0.2% | 5.98 |
| canterbury/grammar.lsp | 3721 | 30.2 | 99.7 ±0.3% | 468.7 ±0.1% | 4.70 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 130.5 ±0.2% | 889.6 ±0.2% | 6.82 |
| canterbury/lcet10.txt | 426754 | 26.6 | 120.7 ±0.1% | 655.1 ±0.4% | 5.43 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 105.8 ±0.1% | 553.2 ±0.2% | 5.23 |
| canterbury/ptt5 | 513216 | 8.0 | 188.6 ±0.1% | 1451.0 ±0.5% | 7.69 |
| canterbury/sum | 38240 | 26.5 | 97.0 ±0.1% | 423.5 ±0.8% | 4.37 |
| canterbury/xargs.1 | 4227 | 34.6 | 91.1 ±0.4% | 399.3 ±0.2% | 4.38 |
| canterbury-large/E.coli | 4638690 | 24.5 | 108.1 ±0.1% | 495.4 ±0.2% | 4.58 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 136.9 ±0.6% | 878.3 ±0.5% | 6.41 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 141.6 ±0.3% | 806.5 ±0.4% | 5.69 |
| http/html-1kx1024 | 1048576 | 30.3 | 84.4 ±0.1% | 220.5 ±0.1% | 2.61 |
| http/html-16kx64 | 1048576 | 16.8 | 139.2 ±0.1% | 659.4 ±0.2% | 4.74 |
| http/html-1m | 1048576 | 13.0 | 167.1 ±0.1% | 1197.2 ±0.4% | 7.17 |
| http/json-1kx1024 | 1048576 | 18.2 | 98.1 ±0.2% | 258.1 ±0.1% | 2.63 |
| http/json-16kx64 | 1048576 | 8.9 | 161.8 ±0.1% | 1005.1 ±0.2% | 6.21 |
| http/json-1m | 1048576 | 7.7 | 175.7 ±0.3% | 1379.8 ±0.6% | 7.86 |
| http/js-1kx1024 | 1048576 | 35.1 | 77.7 ±0.2% | 205.9 ±0.2% | 2.65 |
| http/js-16kx64 | 1048576 | 20.7 | 124.0 ±0.1% | 562.2 ±0.1% | 4.53 |
| http/js-1m | 1048576 | 14.0 | 159.1 ±0.0% | 1078.8 ±0.2% | 6.78 |
| http/css-1kx1024 | 1048576 | 22.5 | 94.3 ±0.1% | 243.9 ±0.1% | 2.59 |
| http/css-16kx64 | 1048576 | 11.7 | 155.7 ±0.1% | 885.5 ±0.1% | 5.69 |
| http/css-1m | 1048576 | 2.4 | 241.5 ±0.3% | 4655.0 ±0.5% | 19.27 |
| shuffled/dickens-1m | 1048576 | 56.8 | 93.9 ±0.1% | 387.3 ±0.3% | 4.13 |

## The claims, each off against the fast path with all on

Each claim's column is its throughput with the claim off over the throughput with all on.

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | All on, MB/s | S1 word refill off | S4 chunk copies off | S5 window once off | unchecked loop off |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 611.1 ±1.5% | 0.55 ±3.0% | 0.52 ±2.5% | 0.98 ±2.0% | 0.52 ±2.3% |
| silesia/mozilla | 51220480 | 27.5 | 463.9 ±0.9% | 0.67 ±0.9% | 0.64 ±0.5% | 0.98 ±0.9% | 0.66 ±1.2% |
| silesia/mr | 9970564 | 28.3 | 458.4 ±0.9% | 0.63 ±2.1% | 0.62 ±2.1% | 0.98 ±0.8% | 0.63 ±1.1% |
| silesia/nci | 33553445 | 4.8 | 2057.3 ±3.3% | 0.65 ±2.4% | 0.48 ±1.7% | 0.92 ±0.9% | 0.61 ±1.5% |
| silesia/ooffice | 6152192 | 40.3 | 306.1 ±0.9% | 0.67 ±1.8% | 0.65 ±1.6% | 0.99 ±0.9% | 0.65 ±2.4% |
| silesia/osdb | 10085684 | 28.0 | 580.0 ±1.1% | 0.66 ±3.1% | 0.62 ±1.8% | 0.99 ±0.9% | 0.66 ±3.2% |
| silesia/reymont | 6627202 | 20.2 | 848.4 ±0.6% | 0.55 ±0.8% | 0.49 ±0.5% | 0.97 ±0.7% | 0.53 ±0.5% |
| silesia/samba | 21606400 | 17.7 | 889.3 ±0.9% | 0.64 ±0.8% | 0.58 ±0.4% | 0.97 ±1.5% | 0.63 ±1.0% |
| silesia/sao | 7251944 | 63.3 | 297.9 ±1.1% | 0.66 ±2.4% | 0.70 ±1.6% | 0.99 ±2.2% | 0.66 ±0.6% |
| silesia/webster | 41458703 | 21.2 | 728.5 ±2.2% | 0.55 ±1.9% | 0.51 ±2.8% | 0.97 ±1.3% | 0.54 ±0.8% |
| silesia/x-ray | 8474240 | 55.3 | 209.5 ±2.6% | 0.70 ±1.4% | 0.78 ±1.7% | 1.00 ±1.0% | 0.68 ±1.2% |
| silesia/xml | 5345280 | 8.1 | 1903.7 ±0.3% | 0.60 ±0.3% | 0.47 ±0.2% | 0.94 ±0.4% | 0.57 ±0.5% |
| canterbury/alice29.txt | 152089 | 30.6 | 568.2 ±1.1% | 0.59 ±0.1% | 0.54 ±0.2% | 0.98 ±0.3% | 0.57 ±0.3% |
| canterbury/asyoulik.txt | 125179 | 34.1 | 486.8 ±1.2% | 0.60 ±0.1% | 0.56 ±0.2% | 0.99 ±0.6% | 0.57 ±0.1% |
| canterbury/cp.html | 24603 | 28.0 | 607.1 ±2.0% | 0.59 ±0.6% | 0.57 ±0.6% | 0.98 ±2.9% | 0.54 ±0.3% |
| canterbury/fields.c | 11150 | 24.4 | 698.0 ±0.5% | 0.59 ±1.2% | 0.57 ±1.0% | 0.98 ±0.3% | 0.50 ±0.3% |
| canterbury/grammar.lsp | 3721 | 30.2 | 469.9 ±0.1% | 0.70 ±0.9% | 0.70 ±0.5% | 0.99 ±0.1% | 0.60 ±0.3% |
| canterbury/kennedy.xls | 1029744 | 6.0 | 895.3 ±0.1% | 0.59 ±0.5% | 0.52 ±0.4% | 0.97 ±0.7% | 0.49 ±0.3% |
| canterbury/lcet10.txt | 426754 | 26.6 | 655.5 ±0.4% | 0.59 ±0.2% | 0.54 ±0.2% | 0.98 ±0.2% | 0.58 ±0.2% |
| canterbury/plrabn12.txt | 481861 | 33.9 | 554.4 ±0.3% | 0.58 ±0.2% | 0.53 ±0.7% | 0.98 ±0.2% | 0.56 ±0.1% |
| canterbury/ptt5 | 513216 | 8.0 | 1446.9 ±0.4% | 0.68 ±0.1% | 0.47 ±0.1% | 0.96 ±0.3% | 0.65 ±0.2% |
| canterbury/sum | 38240 | 26.5 | 420.3 ±4.1% | 0.65 ±0.3% | 0.64 ±0.7% | 1.00 ±2.5% | 0.63 ±0.1% |
| canterbury/xargs.1 | 4227 | 34.6 | 399.5 ±0.2% | 0.70 ±0.9% | 0.70 ±1.1% | 0.98 ±0.1% | 0.60 ±0.5% |
| canterbury-large/E.coli | 4638690 | 24.5 | 495.0 ±0.3% | 0.88 ±0.6% | 0.91 ±0.1% | 0.98 ±0.3% | 0.88 ±0.3% |
| canterbury-large/bible.txt | 4047392 | 22.0 | 876.0 ±0.7% | 0.54 ±0.1% | 0.48 ±0.9% | 0.97 ±0.7% | 0.53 ±0.3% |
| canterbury-large/world192.txt | 2473400 | 19.2 | 804.8 ±0.9% | 0.61 ±0.4% | 0.55 ±0.3% | 0.97 ±0.4% | 0.59 ±0.4% |
| http/html-1kx1024 | 1048576 | 30.3 | 220.7 ±0.1% | 0.80 ±0.1% | 0.81 ±0.1% | 0.99 ±0.1% | 0.80 ±0.1% |
| http/html-16kx64 | 1048576 | 16.8 | 657.3 ±0.2% | 0.69 ±0.1% | 0.63 ±0.1% | 0.99 ±0.2% | 0.65 ±0.2% |
| http/html-1m | 1048576 | 13.0 | 1193.0 ±0.1% | 0.59 ±0.5% | 0.51 ±0.2% | 0.96 ±0.4% | 0.57 ±0.4% |
| http/json-1kx1024 | 1048576 | 18.2 | 258.4 ±0.1% | 0.84 ±0.1% | 0.83 ±0.0% | 0.97 ±0.1% | 0.83 ±0.1% |
| http/json-16kx64 | 1048576 | 8.9 | 1002.5 ±0.1% | 0.66 ±0.1% | 0.59 ±0.1% | 0.97 ±0.1% | 0.62 ±0.2% |
| http/json-1m | 1048576 | 7.7 | 1382.6 ±0.1% | 0.61 ±0.2% | 0.52 ±0.1% | 0.96 ±0.3% | 0.56 ±0.1% |
| http/js-1kx1024 | 1048576 | 35.1 | 205.6 ±0.2% | 0.79 ±0.1% | 0.79 ±0.1% | 0.99 ±0.1% | 0.78 ±0.1% |
| http/js-16kx64 | 1048576 | 20.7 | 562.3 ±0.2% | 0.67 ±0.1% | 0.62 ±0.0% | 0.99 ±0.1% | 0.64 ±0.1% |
| http/js-1m | 1048576 | 14.0 | 1081.8 ±0.6% | 0.58 ±0.5% | 0.51 ±0.2% | 0.96 ±0.3% | 0.57 ±0.3% |
| http/css-1kx1024 | 1048576 | 22.5 | 244.8 ±0.4% | 0.82 ±0.1% | 0.80 ±0.4% | 0.97 ±0.3% | 0.81 ±0.3% |
| http/css-16kx64 | 1048576 | 11.7 | 886.6 ±0.1% | 0.65 ±0.1% | 0.57 ±0.1% | 0.98 ±0.2% | 0.62 ±0.0% |
| http/css-1m | 1048576 | 2.4 | 4744.3 ±0.5% | 0.63 ±0.3% | 0.34 ±0.3% | 0.86 ±0.3% | 0.57 ±0.4% |
| shuffled/dickens-1m | 1048576 | 56.8 | 387.0 ±0.3% | 0.87 ±0.7% | 0.94 ±0.5% | 0.99 ±0.7% | 0.92 ±0.2% |

## stdx built ReleaseFast against Google's brotli, quality 11, window 22 (decision 17)

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Compressed, % | Google, MB/s | stdx, MB/s | stdx / Google |
|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 28.0 | 444.0 ±0.6% | 614.1 ±0.9% | 1.38 |
| silesia/mozilla | 51220480 | 27.5 | 352.6 ±0.3% | 469.5 ±0.4% | 1.33 |
| silesia/mr | 9970564 | 28.3 | 318.9 ±0.7% | 451.2 ±1.2% | 1.41 |
| silesia/nci | 33553445 | 4.8 | 1610.0 ±1.1% | 2057.7 ±3.2% | 1.28 |
| silesia/ooffice | 6152192 | 40.3 | 242.6 ±0.3% | 307.5 ±0.7% | 1.27 |
| silesia/osdb | 10085684 | 28.0 | 387.2 ±0.6% | 579.5 ±3.0% | 1.50 |
| silesia/reymont | 6627202 | 20.2 | 611.1 ±0.4% | 847.7 ±0.3% | 1.39 |
| silesia/samba | 21606400 | 17.7 | 630.0 ±0.4% | 892.1 ±1.3% | 1.42 |
| silesia/sao | 7251944 | 63.3 | 193.8 ±0.7% | 299.0 ±0.8% | 1.54 |
| silesia/webster | 41458703 | 21.2 | 548.8 ±0.2% | 735.6 ±2.1% | 1.34 |
| silesia/x-ray | 8474240 | 55.3 | 162.5 ±0.8% | 208.6 ±0.7% | 1.28 |
| silesia/xml | 5345280 | 8.1 | 1299.6 ±0.1% | 1912.0 ±0.2% | 1.47 |
| canterbury/alice29.txt | 152089 | 30.6 | 379.5 ±0.1% | 575.1 ±0.6% | 1.52 |
| canterbury/asyoulik.txt | 125179 | 34.1 | 323.4 ±0.2% | 490.4 ±0.8% | 1.52 |
| canterbury/cp.html | 24603 | 28.0 | 367.2 ±0.4% | 618.9 ±5.8% | 1.69 |
| canterbury/fields.c | 11150 | 24.4 | 482.5 ±1.4% | 732.0 ±0.2% | 1.52 |
| canterbury/grammar.lsp | 3721 | 30.2 | 344.1 ±0.2% | 500.4 ±0.1% | 1.45 |
| canterbury/kennedy.xls | 1029744 | 6.0 | 605.5 ±0.2% | 914.8 ±0.2% | 1.51 |
| canterbury/lcet10.txt | 426754 | 26.6 | 436.0 ±0.4% | 670.3 ±0.3% | 1.54 |
| canterbury/plrabn12.txt | 481861 | 33.9 | 370.4 ±0.3% | 554.3 ±0.2% | 1.50 |
| canterbury/ptt5 | 513216 | 8.0 | 788.3 ±0.3% | 1459.1 ±0.3% | 1.85 |
| canterbury/sum | 38240 | 26.5 | 311.7 ±0.3% | 428.7 ±0.6% | 1.38 |
| canterbury/xargs.1 | 4227 | 34.6 | 308.7 ±1.0% | 431.0 ±0.3% | 1.40 |
| canterbury-large/E.coli | 4638690 | 24.5 | 440.2 ±0.3% | 494.7 ±0.2% | 1.12 |
| canterbury-large/bible.txt | 4047392 | 22.0 | 596.4 ±0.7% | 871.0 ±0.4% | 1.46 |
| canterbury-large/world192.txt | 2473400 | 19.2 | 581.0 ±0.2% | 802.7 ±0.2% | 1.38 |
| http/html-1kx1024 | 1048576 | 30.3 | 188.6 ±0.1% | 236.5 ±0.0% | 1.25 |
| http/html-16kx64 | 1048576 | 16.8 | 500.2 ±0.1% | 686.4 ±0.1% | 1.37 |
| http/html-1m | 1048576 | 13.0 | 832.8 ±0.6% | 1204.9 ±0.2% | 1.45 |
| http/json-1kx1024 | 1048576 | 18.2 | 237.2 ±0.1% | 281.1 ±0.1% | 1.19 |
| http/json-16kx64 | 1048576 | 8.9 | 765.0 ±0.1% | 1038.5 ±0.1% | 1.36 |
| http/json-1m | 1048576 | 7.7 | 984.5 ±0.4% | 1398.4 ±0.2% | 1.42 |
| http/js-1kx1024 | 1048576 | 35.1 | 170.7 ±0.1% | 219.7 ±0.2% | 1.29 |
| http/js-16kx64 | 1048576 | 20.7 | 420.1 ±0.1% | 582.5 ±0.3% | 1.39 |
| http/js-1m | 1048576 | 14.0 | 774.2 ±0.1% | 1095.6 ±0.4% | 1.42 |
| http/css-1kx1024 | 1048576 | 22.5 | 220.5 ±0.1% | 263.0 ±0.2% | 1.19 |
| http/css-16kx64 | 1048576 | 11.7 | 682.6 ±0.1% | 922.2 ±0.1% | 1.35 |
| http/css-1m | 1048576 | 2.4 | 1393.0 ±0.7% | 4751.3 ±0.5% | 3.41 |
| shuffled/dickens-1m | 1048576 | 56.8 | 348.5 ±0.6% | 385.9 ±0.5% | 1.11 |
