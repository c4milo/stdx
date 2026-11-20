# bench-profile

| Field | Value |
|---|---|
| Commit | 0dd2e97 |
| Runner label | ubuntu-26.04-arm |
| Image version | 20261116.190.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44677304532 |
| Date | 2026-11-20 |
| zlib | 1.3.2 |
| zlib-ng | 2.3.3 |
| libdeflate | 1.26 |
| Wuffs | 7411f48 |
| libzstd | 1.5.7 |
| Google | 1.2.0 |
| simdjson | 5.1.1 |
| yyjson | 0.13.0 |
| std.json | 0.16.0 |

## S2: how stdx's decoder took each symbol, raw DEFLATE at zlib level 6

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Symbols | One lookup | Canonical code | Checked path | One lookup, share |
|---|---|---|---|---|---|
| silesia/dickens | 3518211 | 3506560 | 11647 | 4 | 0.9967 |
| silesia/mozilla | 18320919 | 18281238 | 39678 | 3 | 0.9978 |
| silesia/mr | 3428100 | 3410568 | 17529 | 3 | 0.9949 |
| silesia/nci | 2830717 | 2816759 | 13954 | 4 | 0.9951 |
| silesia/ooffice | 2955912 | 2950263 | 5646 | 3 | 0.9981 |
| silesia/osdb | 3412934 | 3407674 | 5257 | 3 | 0.9985 |
| silesia/reymont | 1673508 | 1671162 | 2342 | 4 | 0.9986 |
| silesia/samba | 5074517 | 5059991 | 14521 | 5 | 0.9971 |
| silesia/sao | 5009900 | 5006901 | 2996 | 3 | 0.9994 |
| silesia/webster | 10994248 | 10954576 | 39670 | 2 | 0.9964 |
| silesia/x-ray | 6048558 | 6046914 | 1639 | 5 | 0.9997 |
| silesia/xml | 605484 | 603518 | 1963 | 3 | 0.9968 |
| canterbury/alice29.txt | 49256 | 49045 | 208 | 3 | 0.9957 |
| canterbury/asyoulik.txt | 45322 | 45173 | 146 | 3 | 0.9967 |
| canterbury/cp.html | 7939 | 7920 | 16 | 3 | 0.9976 |
| canterbury/fields.c | 3152 | 3149 | 0 | 3 | 0.9990 |
| canterbury/grammar.lsp | 1345 | 1342 | 0 | 3 | 0.9978 |
| canterbury/kennedy.xls | 246939 | 245576 | 1358 | 5 | 0.9945 |
| canterbury/lcet10.txt | 129885 | 129431 | 451 | 3 | 0.9965 |
| canterbury/plrabn12.txt | 180028 | 179433 | 592 | 3 | 0.9967 |
| canterbury/ptt5 | 56796 | 56413 | 378 | 5 | 0.9933 |
| canterbury/sum | 12915 | 12808 | 103 | 4 | 0.9917 |
| canterbury/xargs.1 | 1898 | 1893 | 0 | 5 | 0.9974 |
| canterbury-large/E.coli | 1452869 | 1446399 | 6466 | 4 | 0.9955 |
| canterbury-large/bible.txt | 1062543 | 1059567 | 2973 | 3 | 0.9972 |
| canterbury-large/world192.txt | 648814 | 647123 | 1686 | 5 | 0.9974 |
| http/html-1kx1024 | 434108 | 428774 | 0 | 5334 | 0.9877 |
| http/html-16kx64 | 212133 | 211600 | 284 | 249 | 0.9975 |
| http/html-1m | 158301 | 157787 | 509 | 5 | 0.9968 |
| http/json-1kx1024 | 223459 | 218351 | 0 | 5108 | 0.9771 |
| http/json-16kx64 | 137984 | 137535 | 188 | 261 | 0.9967 |
| http/json-1m | 123160 | 122759 | 397 | 4 | 0.9967 |
| http/js-1kx1024 | 485195 | 479797 | 0 | 5398 | 0.9889 |
| http/js-16kx64 | 254928 | 254200 | 487 | 241 | 0.9971 |
| http/js-1m | 183438 | 182999 | 436 | 3 | 0.9976 |
| http/css-1kx1024 | 296675 | 291174 | 0 | 5501 | 0.9815 |
| http/css-16kx64 | 150913 | 150379 | 281 | 253 | 0.9965 |
| http/css-1m | 106766 | 106306 | 455 | 5 | 0.9957 |
| shuffled/dickens-1m | 726094 | 723324 | 2765 | 5 | 0.9962 |

## Hardware counters per decoded octet, gzip at zlib level 6

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | zlib | 8.80 | 19.08 | 2.17 | 310.24 |
| silesia/dickens | 10192446 | zlib-ng | 4.86 | 10.50 | 2.16 | 67.73 |
| silesia/dickens | 10192446 | libdeflate | 3.44 | 9.56 | 2.78 | 66.16 |
| silesia/dickens | 10192446 | Wuffs | 5.52 | 13.90 | 2.52 | 96.93 |
| silesia/dickens | 10192446 | stdx | 2.91 | 7.15 | 2.46 | 76.12 |
| silesia/mozilla | 51220480 | zlib | 8.43 | 17.23 | 2.04 | 251.94 |
| silesia/mozilla | 51220480 | zlib-ng | 4.91 | 8.95 | 1.82 | 85.51 |
| silesia/mozilla | 51220480 | libdeflate | 3.44 | 7.63 | 2.22 | 71.21 |
| silesia/mozilla | 51220480 | Wuffs | 6.38 | 13.89 | 2.18 | 132.33 |
| silesia/mozilla | 51220480 | stdx | 3.53 | 6.29 | 1.78 | 89.63 |
| silesia/mr | 9970564 | zlib | 8.36 | 18.46 | 2.21 | 202.85 |
| silesia/mr | 9970564 | zlib-ng | 4.78 | 9.98 | 2.09 | 68.06 |
| silesia/mr | 9970564 | libdeflate | 3.34 | 8.58 | 2.57 | 61.18 |
| silesia/mr | 9970564 | Wuffs | 5.99 | 14.04 | 2.35 | 100.02 |
| silesia/mr | 9970564 | stdx | 3.06 | 6.70 | 2.19 | 69.65 |
| silesia/nci | 33553445 | zlib | 3.52 | 10.18 | 2.89 | 81.17 |
| silesia/nci | 33553445 | zlib-ng | 1.56 | 3.13 | 2.00 | 33.69 |
| silesia/nci | 33553445 | libdeflate | 1.12 | 2.66 | 2.37 | 29.77 |
| silesia/nci | 33553445 | Wuffs | 2.44 | 6.47 | 2.65 | 41.47 |
| silesia/nci | 33553445 | stdx | 1.14 | 2.20 | 1.93 | 37.37 |
| silesia/ooffice | 6152192 | zlib | 11.77 | 21.06 | 1.79 | 417.34 |
| silesia/ooffice | 6152192 | zlib-ng | 6.90 | 12.04 | 1.74 | 140.37 |
| silesia/ooffice | 6152192 | libdeflate | 4.90 | 10.45 | 2.13 | 124.95 |
| silesia/ooffice | 6152192 | Wuffs | 8.79 | 17.54 | 2.00 | 220.41 |
| silesia/ooffice | 6152192 | stdx | 5.06 | 8.55 | 1.69 | 150.94 |
| silesia/osdb | 10085684 | zlib | 7.45 | 16.59 | 2.23 | 183.18 |
| silesia/osdb | 10085684 | zlib-ng | 4.28 | 8.38 | 1.96 | 52.89 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.91 | 2.43 | 29.77 |
| silesia/osdb | 10085684 | Wuffs | 5.79 | 13.61 | 2.35 | 78.67 |
| silesia/osdb | 10085684 | stdx | 2.76 | 5.65 | 2.05 | 40.86 |
| silesia/reymont | 6627202 | zlib | 7.38 | 15.89 | 2.15 | 260.07 |
| silesia/reymont | 6627202 | zlib-ng | 3.72 | 7.72 | 2.08 | 61.11 |
| silesia/reymont | 6627202 | libdeflate | 2.60 | 6.91 | 2.65 | 51.03 |
| silesia/reymont | 6627202 | Wuffs | 4.88 | 11.40 | 2.34 | 112.29 |
| silesia/reymont | 6627202 | stdx | 2.28 | 5.11 | 2.24 | 64.86 |
| silesia/samba | 21606400 | zlib | 6.10 | 14.13 | 2.32 | 175.17 |
| silesia/samba | 21606400 | zlib-ng | 3.34 | 6.47 | 1.94 | 55.96 |
| silesia/samba | 21606400 | libdeflate | 2.30 | 5.58 | 2.42 | 42.97 |
| silesia/samba | 21606400 | Wuffs | 4.32 | 10.39 | 2.41 | 79.63 |
| silesia/samba | 21606400 | stdx | 2.24 | 4.46 | 2.00 | 56.29 |
| silesia/sao | 7251944 | zlib | 10.47 | 23.54 | 2.25 | 203.66 |
| silesia/sao | 7251944 | zlib-ng | 7.84 | 14.83 | 1.89 | 79.50 |
| silesia/sao | 7251944 | libdeflate | 5.73 | 12.73 | 2.22 | 78.97 |
| silesia/sao | 7251944 | Wuffs | 8.90 | 21.26 | 2.39 | 86.37 |
| silesia/sao | 7251944 | stdx | 5.55 | 10.32 | 1.86 | 87.04 |
| silesia/webster | 41458703 | zlib | 7.79 | 16.16 | 2.07 | 281.20 |
| silesia/webster | 41458703 | zlib-ng | 4.22 | 8.04 | 1.90 | 84.96 |
| silesia/webster | 41458703 | libdeflate | 2.87 | 7.17 | 2.50 | 68.68 |
| silesia/webster | 41458703 | Wuffs | 5.13 | 11.67 | 2.27 | 122.39 |
| silesia/webster | 41458703 | stdx | 2.68 | 5.56 | 2.07 | 87.19 |
| silesia/x-ray | 8474240 | zlib | 12.87 | 27.21 | 2.12 | 329.85 |
| silesia/x-ray | 8474240 | zlib-ng | 9.02 | 17.39 | 1.93 | 124.22 |
| silesia/x-ray | 8474240 | libdeflate | 6.52 | 15.26 | 2.34 | 124.40 |
| silesia/x-ray | 8474240 | Wuffs | 10.79 | 23.52 | 2.18 | 190.89 |
| silesia/x-ray | 8474240 | stdx | 6.11 | 11.49 | 1.88 | 140.00 |
| silesia/xml | 5345280 | zlib | 4.21 | 11.16 | 2.65 | 117.80 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.75 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 31.91 |
| silesia/xml | 5345280 | Wuffs | 2.84 | 7.22 | 2.55 | 58.99 |
| silesia/xml | 5345280 | stdx | 1.32 | 2.65 | 2.01 | 41.97 |
| canterbury/alice29.txt | 152089 | zlib | 8.46 | 18.35 | 2.17 | 297.85 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.22 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.16 | 8.96 | 2.83 | 53.02 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.40 | 13.40 | 2.48 | 99.55 |
| canterbury/alice29.txt | 152089 | stdx | 2.72 | 6.99 | 2.57 | 62.97 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.02 | 19.41 | 2.15 | 313.86 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 73.22 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.56 | 9.82 | 2.75 | 64.79 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.77 | 14.40 | 2.49 | 100.49 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.07 | 7.52 | 2.45 | 78.39 |
| canterbury/cp.html | 24603 | zlib | 7.01 | 17.33 | 2.47 | 167.43 |
| canterbury/cp.html | 24603 | zlib-ng | 4.17 | 9.50 | 2.28 | 36.12 |
| canterbury/cp.html | 24603 | libdeflate | 2.80 | 7.95 | 2.84 | 10.42 |
| canterbury/cp.html | 24603 | Wuffs | 5.20 | 13.91 | 2.67 | 59.77 |
| canterbury/cp.html | 24603 | stdx | 2.64 | 7.19 | 2.73 | 11.53 |
| canterbury/fields.c | 11150 | zlib | 5.24 | 17.72 | 3.38 | 36.18 |
| canterbury/fields.c | 11150 | zlib-ng | 3.92 | 10.19 | 2.60 | 17.88 |
| canterbury/fields.c | 11150 | libdeflate | 2.81 | 8.31 | 2.96 | 1.48 |
| canterbury/fields.c | 11150 | Wuffs | 4.53 | 14.53 | 3.21 | 10.94 |
| canterbury/fields.c | 11150 | stdx | 2.51 | 7.64 | 3.05 | 4.92 |
| canterbury/grammar.lsp | 3721 | zlib | 6.87 | 24.23 | 3.53 | 6.03 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.81 | 17.45 | 3.00 | 6.96 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.48 | 12.02 | 2.68 | 0.44 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.70 | 21.84 | 3.26 | 5.95 |
| canterbury/grammar.lsp | 3721 | stdx | 3.84 | 12.18 | 3.17 | 1.10 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.59 | 15.27 | 3.33 | 48.53 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.56 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.74 | 5.97 | 2.18 | 9.00 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.86 | 11.59 | 3.00 | 14.86 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.66 | 2.66 | 16.70 |
| canterbury/lcet10.txt | 426754 | zlib | 8.19 | 17.78 | 2.17 | 288.99 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.17 | 61.36 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.09 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.22 | 12.88 | 2.47 | 101.03 |
| canterbury/lcet10.txt | 426754 | stdx | 2.59 | 6.42 | 2.47 | 66.74 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.22 | 19.86 | 2.16 | 322.09 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.29 | 11.18 | 2.11 | 79.28 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.70 | 77.67 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.82 | 14.61 | 2.51 | 99.80 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.13 | 7.63 | 2.44 | 84.34 |
| canterbury/ptt5 | 513216 | zlib | 5.04 | 10.71 | 2.12 | 103.11 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.58 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.09 | 38.25 |
| canterbury/ptt5 | 513216 | Wuffs | 3.00 | 7.13 | 2.38 | 57.44 |
| canterbury/ptt5 | 513216 | stdx | 1.44 | 2.55 | 1.77 | 49.04 |
| canterbury/sum | 38240 | zlib | 8.00 | 18.12 | 2.26 | 224.67 |
| canterbury/sum | 38240 | zlib-ng | 4.64 | 10.02 | 2.16 | 56.84 |
| canterbury/sum | 38240 | libdeflate | 3.31 | 8.34 | 2.52 | 34.84 |
| canterbury/sum | 38240 | Wuffs | 5.79 | 14.47 | 2.50 | 82.42 |
| canterbury/sum | 38240 | stdx | 3.00 | 7.73 | 2.58 | 27.20 |
| canterbury/xargs.1 | 4227 | zlib | 7.39 | 25.20 | 3.41 | 11.32 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.34 | 17.95 | 2.83 | 7.72 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.83 | 13.25 | 2.74 | 0.30 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.20 | 22.62 | 3.14 | 11.01 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 12.86 | 3.03 | 2.53 |
| canterbury-large/E.coli | 4638690 | zlib | 6.77 | 17.84 | 2.64 | 178.06 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.23 | 9.68 | 2.29 | 47.73 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.20 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.67 | 12.73 | 2.73 | 61.92 |
| canterbury-large/E.coli | 4638690 | stdx | 2.46 | 6.72 | 2.73 | 53.49 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.52 | 16.46 | 2.19 | 266.98 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.77 | 8.26 | 2.19 | 53.94 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.65 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.80 | 11.73 | 2.44 | 100.36 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.23 | 5.57 | 2.50 | 55.70 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.73 | 15.84 | 2.05 | 282.86 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.19 | 7.78 | 1.86 | 91.55 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.09 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.18 | 11.48 | 2.22 | 128.06 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.71 | 5.40 | 1.99 | 90.12 |
| http/html-1kx1024 | 1048576 | zlib | 16.68 | 35.49 | 2.13 | 352.53 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.67 | 28.34 | 2.24 | 217.94 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.83 | 19.96 | 1.84 | 155.23 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.35 | 38.00 | 2.47 | 265.54 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 137.18 |
| http/html-16kx64 | 1048576 | zlib | 6.74 | 14.77 | 2.19 | 221.26 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.53 | 1.95 | 85.51 |
| http/html-16kx64 | 1048576 | libdeflate | 2.65 | 6.04 | 2.27 | 60.41 |
| http/html-16kx64 | 1048576 | Wuffs | 4.92 | 11.56 | 2.35 | 114.88 |
| http/html-16kx64 | 1048576 | stdx | 2.51 | 5.56 | 2.22 | 58.74 |
| http/html-1m | 1048576 | zlib | 5.31 | 12.53 | 2.36 | 175.61 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 60.24 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.49 |
| http/html-1m | 1048576 | Wuffs | 3.61 | 8.48 | 2.35 | 88.06 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.11 | 52.73 |
| http/json-1kx1024 | 1048576 | zlib | 10.56 | 23.83 | 2.26 | 191.48 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.38 | 16.60 | 2.25 | 130.84 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.10 | 16.63 | 1.83 | 92.00 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.11 | 34.71 | 2.86 | 146.42 |
| http/json-1kx1024 | 1048576 | stdx | 5.03 | 13.12 | 2.61 | 81.08 |
| http/json-16kx64 | 1048576 | zlib | 4.56 | 12.50 | 2.74 | 103.20 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.49 | 2.11 | 50.84 |
| http/json-16kx64 | 1048576 | libdeflate | 1.93 | 4.23 | 2.19 | 40.49 |
| http/json-16kx64 | 1048576 | Wuffs | 3.50 | 9.43 | 2.70 | 58.05 |
| http/json-16kx64 | 1048576 | stdx | 1.75 | 3.97 | 2.26 | 39.27 |
| http/json-1m | 1048576 | zlib | 3.85 | 11.20 | 2.91 | 83.26 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.03 | 37.27 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.70 |
| http/json-1m | 1048576 | Wuffs | 2.73 | 7.37 | 2.70 | 43.58 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.02 | 40.03 |
| http/js-1kx1024 | 1048576 | zlib | 18.21 | 38.37 | 2.11 | 410.18 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.76 | 31.16 | 2.26 | 238.59 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.52 | 21.49 | 1.87 | 179.13 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.53 | 40.63 | 2.46 | 299.81 |
| http/js-1kx1024 | 1048576 | stdx | 9.27 | 22.85 | 2.46 | 158.47 |
| http/js-16kx64 | 1048576 | zlib | 7.66 | 16.07 | 2.10 | 263.56 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.64 | 1.97 | 92.13 |
| http/js-16kx64 | 1048576 | libdeflate | 3.07 | 7.00 | 2.28 | 71.96 |
| http/js-16kx64 | 1048576 | Wuffs | 5.50 | 12.74 | 2.32 | 129.18 |
| http/js-16kx64 | 1048576 | stdx | 2.99 | 6.54 | 2.19 | 71.91 |
| http/js-1m | 1048576 | zlib | 5.86 | 13.31 | 2.27 | 200.36 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 59.93 |
| http/js-1m | 1048576 | libdeflate | 1.93 | 4.98 | 2.59 | 42.27 |
| http/js-1m | 1048576 | Wuffs | 3.91 | 9.14 | 2.34 | 93.90 |
| http/js-1m | 1048576 | stdx | 1.81 | 3.89 | 2.15 | 55.41 |
| http/css-1kx1024 | 1048576 | zlib | 14.02 | 30.27 | 2.16 | 281.62 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.22 | 22.95 | 2.25 | 171.07 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.41 | 17.28 | 1.84 | 120.97 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.76 | 32.42 | 2.54 | 211.00 |
| http/css-1kx1024 | 1048576 | stdx | 6.67 | 17.64 | 2.64 | 100.21 |
| http/css-16kx64 | 1048576 | zlib | 5.32 | 13.03 | 2.45 | 154.45 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.18 | 50.24 |
| http/css-16kx64 | 1048576 | libdeflate | 1.90 | 4.68 | 2.46 | 29.73 |
| http/css-16kx64 | 1048576 | Wuffs | 3.79 | 10.01 | 2.64 | 70.01 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.54 | 27.97 |
| http/css-1m | 1048576 | zlib | 3.97 | 10.97 | 2.76 | 107.60 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.21 | 29.17 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.97 | 12.89 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.78 | 43.40 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.53 | 21.32 |
| shuffled/dickens-1m | 1048576 | zlib | 13.31 | 25.88 | 1.94 | 373.46 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.71 | 16.72 | 1.72 | 195.73 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.03 | 14.95 | 2.13 | 194.43 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.44 | 22.08 | 2.11 | 201.28 |
| shuffled/dickens-1m | 1048576 | stdx | 7.03 | 11.89 | 1.69 | 205.61 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.47 | 14.05 | 4.05 | 3.33 |
| silesia/dickens | 10192446 | stdx | 3.62 | 12.47 | 3.44 | 3.94 |
| silesia/mozilla | 51220480 | libzstd | 2.79 | 9.68 | 3.47 | 30.14 |
| silesia/mozilla | 51220480 | stdx | 2.78 | 9.68 | 3.49 | 15.98 |
| silesia/mr | 9970564 | libzstd | 2.96 | 11.99 | 4.06 | 6.09 |
| silesia/mr | 9970564 | stdx | 3.03 | 10.83 | 3.57 | 5.27 |
| silesia/nci | 33553445 | libzstd | 1.59 | 4.88 | 3.07 | 24.80 |
| silesia/nci | 33553445 | stdx | 1.57 | 4.63 | 2.94 | 13.61 |
| silesia/ooffice | 6152192 | libzstd | 3.34 | 12.19 | 3.64 | 30.95 |
| silesia/ooffice | 6152192 | stdx | 3.31 | 12.40 | 3.75 | 12.26 |
| silesia/osdb | 10085684 | libzstd | 2.34 | 8.45 | 3.61 | 14.88 |
| silesia/osdb | 10085684 | stdx | 2.39 | 8.11 | 3.39 | 15.27 |
| silesia/reymont | 6627202 | libzstd | 3.13 | 11.62 | 3.71 | 11.58 |
| silesia/reymont | 6627202 | stdx | 3.26 | 10.36 | 3.17 | 13.08 |
| silesia/samba | 21606400 | libzstd | 2.02 | 7.41 | 3.67 | 18.55 |
| silesia/samba | 21606400 | stdx | 2.09 | 6.83 | 3.27 | 17.89 |
| silesia/sao | 7251944 | libzstd | 3.74 | 12.72 | 3.40 | 26.77 |
| silesia/sao | 7251944 | stdx | 3.45 | 12.58 | 3.65 | 6.28 |
| silesia/webster | 41458703 | libzstd | 3.11 | 11.24 | 3.61 | 16.14 |
| silesia/webster | 41458703 | stdx | 3.22 | 10.05 | 3.12 | 17.58 |
| silesia/x-ray | 8474240 | libzstd | 3.86 | 14.94 | 3.88 | 18.86 |
| silesia/x-ray | 8474240 | stdx | 3.52 | 13.23 | 3.76 | 8.52 |
| silesia/xml | 5345280 | libzstd | 1.55 | 5.57 | 3.60 | 23.24 |
| silesia/xml | 5345280 | stdx | 1.52 | 5.16 | 3.39 | 17.23 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.89 | 4.12 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.35 | 0.63 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.95 | 14.26 | 4.83 | 3.24 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.29 | 0.37 |
| canterbury/cp.html | 24603 | libzstd | 2.64 | 10.74 | 4.07 | 7.69 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.11 | 0.18 |
| canterbury/fields.c | 11150 | libzstd | 3.12 | 13.62 | 4.37 | 9.08 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.23 | 0.19 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.18 | 16.94 | 4.06 | 4.27 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.54 | 4.01 | 0.22 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.53 | 11.40 | 4.50 | 7.79 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.68 | 11.32 | 4.22 | 0.87 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.70 | 12.89 | 4.78 | 5.17 |
| canterbury/lcet10.txt | 426754 | stdx | 2.73 | 11.52 | 4.22 | 4.67 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.10 | 15.16 | 4.89 | 1.51 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.19 | 13.51 | 4.23 | 0.99 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.52 | 3.12 | 24.95 |
| canterbury/ptt5 | 513216 | stdx | 1.33 | 4.46 | 3.35 | 13.18 |
| canterbury/sum | 38240 | libzstd | 2.62 | 10.58 | 4.03 | 10.21 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.29 |
| canterbury/xargs.1 | 4227 | libzstd | 4.25 | 17.41 | 4.10 | 9.11 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.17 | 4.05 | 0.22 |
| canterbury-large/E.coli | 4638690 | libzstd | 2.98 | 13.64 | 4.57 | 2.09 |
| canterbury-large/E.coli | 4638690 | stdx | 3.10 | 12.04 | 3.88 | 2.83 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.93 | 12.00 | 4.09 | 8.33 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.05 | 10.64 | 3.49 | 9.64 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.56 | 9.60 | 3.75 | 19.72 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.66 | 8.64 | 3.24 | 20.68 |
| http/html-1kx1024 | 1048576 | libzstd | 7.25 | 21.63 | 2.98 | 63.11 |
| http/html-1kx1024 | 1048576 | stdx | 7.48 | 22.46 | 3.00 | 76.87 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.51 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 9.61 | 3.61 | 30.23 |
| http/html-1m | 1048576 | libzstd | 2.00 | 7.88 | 3.93 | 23.95 |
| http/html-1m | 1048576 | stdx | 2.00 | 7.12 | 3.55 | 25.29 |
| http/json-1kx1024 | 1048576 | libzstd | 6.27 | 17.39 | 2.77 | 49.66 |
| http/json-1kx1024 | 1048576 | stdx | 6.22 | 17.86 | 2.87 | 53.72 |
| http/json-16kx64 | 1048576 | libzstd | 2.06 | 7.26 | 3.53 | 28.61 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 19.67 |
| http/json-1m | 1048576 | libzstd | 1.72 | 6.08 | 3.54 | 27.96 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.63 | 14.29 |
| http/js-1kx1024 | 1048576 | libzstd | 8.33 | 26.35 | 3.16 | 73.46 |
| http/js-1kx1024 | 1048576 | stdx | 9.06 | 27.60 | 3.05 | 114.22 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.72 | 4.00 | 24.25 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.73 | 26.65 |
| http/js-1m | 1048576 | libzstd | 2.02 | 8.19 | 4.06 | 20.13 |
| http/js-1m | 1048576 | stdx | 2.07 | 7.48 | 3.62 | 20.62 |
| http/css-1kx1024 | 1048576 | libzstd | 6.89 | 19.69 | 2.86 | 53.80 |
| http/css-1kx1024 | 1048576 | stdx | 6.86 | 19.96 | 2.91 | 64.12 |
| http/css-16kx64 | 1048576 | libzstd | 2.25 | 8.70 | 3.86 | 23.28 |
| http/css-16kx64 | 1048576 | stdx | 2.28 | 8.43 | 3.70 | 22.24 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.58 | 3.86 | 5.48 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.51 | 3.73 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.76 | 9.40 | 3.40 | 28.30 |
| shuffled/dickens-1m | 1048576 | stdx | 2.74 | 9.19 | 3.35 | 12.70 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.35 | 16.92 | 2.30 | 100.06 |
| silesia/dickens | 1048576 | stdx | 5.22 | 12.38 | 2.37 | 54.75 |
| silesia/mozilla | 1048576 | Google | 13.45 | 28.31 | 2.10 | 47.84 |
| silesia/mozilla | 1048576 | stdx | 8.31 | 15.02 | 1.81 | 47.20 |
| silesia/mr | 1048576 | Google | 8.77 | 20.21 | 2.31 | 103.32 |
| silesia/mr | 1048576 | stdx | 5.88 | 13.25 | 2.25 | 88.26 |
| silesia/nci | 1048576 | Google | 2.52 | 5.70 | 2.26 | 52.20 |
| silesia/nci | 1048576 | stdx | 1.94 | 3.95 | 2.03 | 55.61 |
| silesia/ooffice | 1048576 | Google | 13.96 | 29.27 | 2.10 | 289.27 |
| silesia/ooffice | 1048576 | stdx | 10.85 | 20.33 | 1.87 | 322.21 |
| silesia/osdb | 1048576 | Google | 8.10 | 17.48 | 2.16 | 97.04 |
| silesia/osdb | 1048576 | stdx | 5.16 | 10.57 | 2.05 | 91.97 |
| silesia/reymont | 1048576 | Google | 5.31 | 12.62 | 2.38 | 82.67 |
| silesia/reymont | 1048576 | stdx | 3.72 | 9.25 | 2.49 | 47.70 |
| silesia/samba | 1048576 | Google | 7.55 | 16.30 | 2.16 | 95.35 |
| silesia/samba | 1048576 | stdx | 5.04 | 10.71 | 2.12 | 66.85 |
| silesia/sao | 1048576 | Google | 16.77 | 37.18 | 2.22 | 168.37 |
| silesia/sao | 1048576 | stdx | 10.40 | 22.65 | 2.18 | 141.34 |
| silesia/webster | 1048576 | Google | 6.41 | 14.00 | 2.18 | 113.46 |
| silesia/webster | 1048576 | stdx | 4.38 | 9.98 | 2.28 | 68.89 |
| silesia/x-ray | 1048576 | Google | 19.17 | 38.56 | 2.01 | 236.12 |
| silesia/x-ray | 1048576 | stdx | 14.52 | 30.18 | 2.08 | 234.40 |
| silesia/xml | 1048576 | Google | 3.41 | 7.61 | 2.23 | 65.32 |
| silesia/xml | 1048576 | stdx | 2.39 | 5.40 | 2.26 | 46.95 |
| canterbury/alice29.txt | 152089 | Google | 8.93 | 20.55 | 2.30 | 133.31 |
| canterbury/alice29.txt | 152089 | stdx | 6.04 | 15.33 | 2.54 | 80.02 |
| canterbury/asyoulik.txt | 125179 | Google | 10.36 | 23.71 | 2.29 | 166.92 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.05 | 17.43 | 2.47 | 103.18 |
| canterbury/cp.html | 24603 | Google | 9.07 | 22.18 | 2.45 | 116.29 |
| canterbury/cp.html | 24603 | stdx | 5.90 | 17.15 | 2.91 | 43.27 |
| canterbury/fields.c | 11150 | Google | 7.14 | 21.13 | 2.96 | 30.57 |
| canterbury/fields.c | 11150 | stdx | 4.89 | 17.08 | 3.49 | 2.51 |
| canterbury/grammar.lsp | 3721 | Google | 9.85 | 30.05 | 3.05 | 9.20 |
| canterbury/grammar.lsp | 3721 | stdx | 7.15 | 25.04 | 3.50 | 0.76 |
| canterbury/kennedy.xls | 1029744 | Google | 5.43 | 17.05 | 3.14 | 37.41 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.79 | 12.94 | 3.42 | 33.83 |
| canterbury/lcet10.txt | 426754 | Google | 7.68 | 17.36 | 2.26 | 125.46 |
| canterbury/lcet10.txt | 426754 | stdx | 5.18 | 12.96 | 2.50 | 66.87 |
| canterbury/plrabn12.txt | 481861 | Google | 9.00 | 20.82 | 2.31 | 132.16 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.23 | 15.04 | 2.41 | 87.49 |
| canterbury/ptt5 | 513216 | Google | 4.28 | 10.41 | 2.43 | 62.44 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.07 | 65.63 |
| canterbury/sum | 38240 | Google | 10.87 | 26.43 | 2.43 | 160.28 |
| canterbury/sum | 38240 | stdx | 8.38 | 21.11 | 2.52 | 160.29 |
| canterbury/xargs.1 | 4227 | Google | 10.95 | 34.71 | 3.17 | 8.32 |
| canterbury/xargs.1 | 4227 | stdx | 8.51 | 30.44 | 3.58 | 7.35 |
| canterbury-large/E.coli | 1048576 | Google | 8.12 | 19.55 | 2.41 | 1.47 |
| canterbury-large/E.coli | 1048576 | stdx | 6.70 | 13.48 | 2.01 | 1.22 |
| canterbury-large/bible.txt | 1048576 | Google | 5.25 | 12.28 | 2.34 | 80.88 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.53 | 8.93 | 2.53 | 39.88 |
| canterbury-large/world192.txt | 1048576 | Google | 6.08 | 12.84 | 2.11 | 114.40 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.38 | 9.38 | 2.14 | 77.50 |
| http/html-1kx1024 | 1048576 | Google | 18.08 | 41.57 | 2.30 | 388.25 |
| http/html-1kx1024 | 1048576 | stdx | 15.27 | 37.56 | 2.46 | 360.49 |
| http/html-16kx64 | 1048576 | Google | 6.74 | 14.83 | 2.20 | 149.20 |
| http/html-16kx64 | 1048576 | stdx | 5.14 | 12.15 | 2.36 | 114.79 |
| http/html-1m | 1048576 | Google | 4.02 | 8.94 | 2.23 | 83.31 |
| http/html-1m | 1048576 | stdx | 2.84 | 6.52 | 2.29 | 54.86 |
| http/json-1kx1024 | 1048576 | Google | 14.54 | 36.27 | 2.49 | 242.35 |
| http/json-1kx1024 | 1048576 | stdx | 13.01 | 33.63 | 2.58 | 278.40 |
| http/json-16kx64 | 1048576 | Google | 4.43 | 11.41 | 2.57 | 83.03 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.49 | 83.97 |
| http/json-1m | 1048576 | Google | 3.40 | 8.65 | 2.54 | 60.12 |
| http/json-1m | 1048576 | stdx | 2.45 | 5.99 | 2.44 | 57.64 |
| http/js-1kx1024 | 1048576 | Google | 19.95 | 45.84 | 2.30 | 425.92 |
| http/js-1kx1024 | 1048576 | stdx | 16.36 | 39.90 | 2.44 | 379.01 |
| http/js-16kx64 | 1048576 | Google | 8.03 | 17.71 | 2.20 | 166.20 |
| http/js-16kx64 | 1048576 | stdx | 6.02 | 14.36 | 2.39 | 125.66 |
| http/js-1m | 1048576 | Google | 4.31 | 9.54 | 2.21 | 82.83 |
| http/js-1m | 1048576 | stdx | 3.15 | 7.25 | 2.30 | 55.59 |
| http/css-1kx1024 | 1048576 | Google | 15.56 | 37.00 | 2.38 | 295.68 |
| http/css-1kx1024 | 1048576 | stdx | 13.79 | 34.70 | 2.52 | 301.94 |
| http/css-16kx64 | 1048576 | Google | 4.96 | 11.73 | 2.36 | 102.80 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.85 |
| http/css-1m | 1048576 | Google | 2.43 | 9.42 | 3.87 | 17.04 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.48 | 12.26 |
| shuffled/dickens-1m | 1048576 | Google | 10.11 | 20.65 | 2.04 | 105.81 |
| shuffled/dickens-1m | 1048576 | stdx | 8.77 | 14.53 | 1.66 | 118.43 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.17 | 36.91 | 2.43 | 412.52 |
| silesia/dickens | 10192446 | 1 | stdx | 16.18 | 38.17 | 2.36 | 358.10 |
| silesia/dickens | 10192446 | 6 | libdeflate | 49.82 | 87.63 | 1.76 | 694.71 |
| silesia/dickens | 10192446 | 6 | stdx | 49.31 | 84.26 | 1.71 | 1423.43 |
| silesia/dickens | 10192446 | 9 | libdeflate | 109.04 | 160.47 | 1.47 | 927.97 |
| silesia/dickens | 10192446 | 9 | stdx | 85.57 | 191.81 | 2.24 | 1717.56 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.08 | 32.62 | 2.32 | 438.67 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.35 | 30.24 | 2.27 | 296.14 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.10 | 70.83 | 2.21 | 580.39 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.53 | 69.96 | 2.22 | 735.17 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 126.32 | 221.49 | 1.75 | 766.34 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.87 | 126.12 | 2.58 | 789.24 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.87 | 35.02 | 2.95 | 229.35 |
| silesia/mr | 9970564 | 1 | stdx | 12.39 | 34.08 | 2.75 | 186.96 |
| silesia/mr | 9970564 | 6 | libdeflate | 37.08 | 80.54 | 2.17 | 437.21 |
| silesia/mr | 9970564 | 6 | stdx | 39.43 | 83.19 | 2.11 | 962.03 |
| silesia/mr | 9970564 | 9 | libdeflate | 96.27 | 165.48 | 1.72 | 748.64 |
| silesia/mr | 9970564 | 9 | stdx | 87.22 | 206.31 | 2.37 | 1324.55 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.18 | 18.42 | 2.98 | 115.63 |
| silesia/nci | 33553445 | 1 | stdx | 4.91 | 10.88 | 2.22 | 98.41 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.34 | 34.84 | 2.13 | 225.27 |
| silesia/nci | 33553445 | 6 | stdx | 14.33 | 29.54 | 2.06 | 393.16 |
| silesia/nci | 33553445 | 9 | libdeflate | 61.36 | 105.28 | 1.72 | 498.70 |
| silesia/nci | 33553445 | 9 | stdx | 33.25 | 80.64 | 2.42 | 649.46 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.82 | 39.15 | 1.98 | 753.45 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.55 | 39.08 | 2.23 | 430.10 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 39.64 | 79.10 | 2.00 | 954.68 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.40 | 87.83 | 2.12 | 1005.73 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 72.78 | 127.63 | 1.75 | 1129.30 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.01 | 129.17 | 2.48 | 935.65 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.80 | 30.15 | 2.36 | 352.75 |
| silesia/osdb | 10085684 | 1 | stdx | 12.77 | 27.87 | 2.18 | 294.08 |
| silesia/osdb | 10085684 | 6 | libdeflate | 26.87 | 55.67 | 2.07 | 491.95 |
| silesia/osdb | 10085684 | 6 | stdx | 27.00 | 57.40 | 2.13 | 571.19 |
| silesia/osdb | 10085684 | 9 | libdeflate | 32.36 | 64.15 | 1.98 | 549.88 |
| silesia/osdb | 10085684 | 9 | stdx | 35.47 | 87.23 | 2.46 | 684.24 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.56 | 32.88 | 2.62 | 312.19 |
| silesia/reymont | 6627202 | 1 | stdx | 13.24 | 33.24 | 2.51 | 271.67 |
| silesia/reymont | 6627202 | 6 | libdeflate | 46.30 | 86.58 | 1.87 | 521.06 |
| silesia/reymont | 6627202 | 6 | stdx | 44.89 | 76.82 | 1.71 | 1409.56 |
| silesia/reymont | 6627202 | 9 | libdeflate | 195.37 | 276.14 | 1.41 | 839.07 |
| silesia/reymont | 6627202 | 9 | stdx | 87.65 | 189.98 | 2.17 | 1612.12 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.37 | 26.53 | 2.56 | 272.37 |
| silesia/samba | 21606400 | 1 | stdx | 9.79 | 22.23 | 2.27 | 220.71 |
| silesia/samba | 21606400 | 6 | libdeflate | 27.97 | 58.79 | 2.10 | 384.60 |
| silesia/samba | 21606400 | 6 | stdx | 24.02 | 49.84 | 2.08 | 618.90 |
| silesia/samba | 21606400 | 9 | libdeflate | 82.78 | 141.44 | 1.71 | 504.65 |
| silesia/samba | 21606400 | 9 | stdx | 41.76 | 102.63 | 2.46 | 728.97 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.63 | 47.87 | 2.21 | 689.02 |
| silesia/sao | 7251944 | 1 | stdx | 18.92 | 49.92 | 2.64 | 346.80 |
| silesia/sao | 7251944 | 6 | libdeflate | 48.87 | 96.89 | 1.98 | 963.28 |
| silesia/sao | 7251944 | 6 | stdx | 46.98 | 105.66 | 2.25 | 856.64 |
| silesia/sao | 7251944 | 9 | libdeflate | 68.43 | 120.26 | 1.76 | 1103.32 |
| silesia/sao | 7251944 | 9 | stdx | 55.18 | 138.16 | 2.50 | 847.17 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.09 | 30.45 | 2.33 | 388.79 |
| silesia/webster | 41458703 | 1 | stdx | 13.82 | 29.09 | 2.10 | 339.13 |
| silesia/webster | 41458703 | 6 | libdeflate | 35.53 | 66.02 | 1.86 | 570.81 |
| silesia/webster | 41458703 | 6 | stdx | 35.09 | 60.88 | 1.74 | 1104.37 |
| silesia/webster | 41458703 | 9 | libdeflate | 92.32 | 138.85 | 1.50 | 752.32 |
| silesia/webster | 41458703 | 9 | stdx | 61.14 | 135.96 | 2.22 | 1288.47 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.63 | 49.67 | 2.10 | 790.35 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.37 | 50.82 | 2.93 | 260.68 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 31.86 | 82.77 | 2.60 | 846.20 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.68 | 98.12 | 2.91 | 539.96 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 36.45 | 91.03 | 2.50 | 1021.95 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.59 | 122.06 | 3.01 | 467.52 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.75 | 21.59 | 2.78 | 176.02 |
| silesia/xml | 5345280 | 1 | stdx | 6.81 | 15.66 | 2.30 | 155.81 |
| silesia/xml | 5345280 | 6 | libdeflate | 20.16 | 40.51 | 2.01 | 264.76 |
| silesia/xml | 5345280 | 6 | stdx | 17.38 | 34.32 | 1.98 | 495.14 |
| silesia/xml | 5345280 | 9 | libdeflate | 57.31 | 89.17 | 1.56 | 370.21 |
| silesia/xml | 5345280 | 9 | stdx | 31.06 | 72.83 | 2.35 | 597.86 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.25 | 35.61 | 2.50 | 380.60 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.06 | 36.13 | 2.40 | 337.26 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 44.92 | 82.29 | 1.83 | 642.88 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.59 | 77.43 | 1.78 | 1310.59 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 105.22 | 159.21 | 1.51 | 850.42 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 73.19 | 167.73 | 2.29 | 1502.57 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.13 | 37.20 | 2.46 | 416.73 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.80 | 37.43 | 2.37 | 359.39 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 46.48 | 85.43 | 1.84 | 718.15 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.09 | 81.93 | 1.78 | 1381.23 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 86.74 | 136.15 | 1.57 | 944.44 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 76.15 | 175.98 | 2.31 | 1606.01 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.67 | 32.02 | 2.74 | 282.38 |
| canterbury/cp.html | 24603 | 1 | stdx | 10.97 | 27.13 | 2.47 | 245.55 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 26.66 | 62.32 | 2.34 | 497.42 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.75 | 57.06 | 2.40 | 621.70 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.39 | 91.97 | 1.98 | 598.86 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.33 | 88.89 | 2.84 | 642.60 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.48 | 35.92 | 3.79 | 62.10 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.10 | 30.06 | 3.71 | 23.71 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.38 | 69.37 | 2.85 | 257.45 |
| canterbury/fields.c | 11150 | 6 | stdx | 21.33 | 57.62 | 2.70 | 462.78 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.58 | 100.80 | 2.26 | 436.22 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.48 | 92.66 | 3.25 | 443.12 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 12.92 | 51.50 | 3.99 | 12.03 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.92 | 39.03 | 3.93 | 2.53 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.63 | 87.04 | 3.68 | 28.88 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.21 | 70.82 | 4.11 | 16.07 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 31.14 | 102.88 | 3.30 | 70.76 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.58 | 99.32 | 4.21 | 58.54 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.35 | 27.18 | 3.70 | 65.22 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.04 | 22.58 | 3.21 | 63.17 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 26.05 | 73.85 | 2.83 | 96.33 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.35 | 62.00 | 3.20 | 140.44 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 360.07 | 664.23 | 1.84 | 162.81 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.73 | 130.89 | 3.47 | 218.81 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.76 | 33.99 | 2.47 | 370.92 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.46 | 33.93 | 2.35 | 330.09 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 43.20 | 78.22 | 1.81 | 609.82 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.71 | 73.43 | 1.76 | 1230.90 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 89.40 | 136.94 | 1.53 | 806.16 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 71.12 | 162.25 | 2.28 | 1440.90 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.77 | 38.62 | 2.45 | 427.29 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.75 | 40.25 | 2.40 | 370.59 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 51.89 | 91.90 | 1.77 | 753.51 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.56 | 88.90 | 1.72 | 1510.11 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 114.07 | 166.26 | 1.46 | 1004.13 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 89.15 | 201.33 | 2.26 | 1796.82 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.42 | 18.61 | 2.90 | 141.37 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.97 | 11.03 | 2.22 | 123.56 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.04 | 36.17 | 2.58 | 219.62 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.30 | 29.58 | 2.40 | 307.67 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.03 | 120.86 | 2.01 | 372.90 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.25 | 130.09 | 3.01 | 641.44 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.79 | 33.49 | 2.62 | 336.19 |
| canterbury/sum | 38240 | 1 | stdx | 12.61 | 29.36 | 2.33 | 301.92 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.37 | 69.86 | 2.46 | 504.16 |
| canterbury/sum | 38240 | 6 | stdx | 26.71 | 65.74 | 2.46 | 656.54 |
| canterbury/sum | 38240 | 9 | libdeflate | 93.95 | 181.91 | 1.94 | 611.58 |
| canterbury/sum | 38240 | 9 | stdx | 39.42 | 112.34 | 2.85 | 664.84 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.25 | 53.05 | 4.00 | 22.81 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.69 | 43.11 | 4.03 | 2.73 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.77 | 87.69 | 3.85 | 70.01 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 18.04 | 74.37 | 4.12 | 42.94 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 25.51 | 94.32 | 3.70 | 133.89 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 25.86 | 106.97 | 4.14 | 97.61 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.06 | 40.47 | 3.36 | 165.99 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.49 | 42.29 | 3.39 | 100.87 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 182.74 | 395.99 | 2.17 | 260.77 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.65 | 374.13 | 3.05 | 1909.08 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 815.72 | 1063.49 | 1.30 | 1317.76 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 229.58 | 755.68 | 3.29 | 2422.67 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.48 | 32.38 | 2.59 | 312.23 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.14 | 32.23 | 2.45 | 280.63 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 44.14 | 80.12 | 1.82 | 524.50 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 41.92 | 72.39 | 1.73 | 1262.06 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 139.05 | 200.28 | 1.44 | 741.54 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.47 | 170.21 | 2.23 | 1440.02 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.28 | 29.72 | 2.24 | 415.58 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.07 | 28.55 | 2.03 | 378.59 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 31.58 | 60.25 | 1.91 | 558.53 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 31.73 | 56.81 | 1.79 | 977.90 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 78.70 | 119.11 | 1.51 | 685.01 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 52.08 | 117.95 | 2.26 | 1142.84 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.22 | 103.87 | 2.95 | 452.87 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.33 | 58.69 | 2.75 | 365.22 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 45.93 | 138.28 | 3.01 | 563.14 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 32.03 | 94.36 | 2.95 | 529.48 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.49 | 142.38 | 3.00 | 586.02 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 36.10 | 112.18 | 3.11 | 539.22 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.44 | 27.96 | 2.68 | 266.95 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.01 | 20.25 | 2.25 | 233.41 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.21 | 52.08 | 2.35 | 405.67 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.84 | 42.87 | 2.28 | 539.37 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 34.71 | 72.54 | 2.09 | 471.49 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.82 | 69.06 | 2.78 | 550.69 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.75 | 23.03 | 2.63 | 224.03 |
| http/html-1m | 1048576 | 1 | stdx | 8.17 | 17.80 | 2.18 | 206.80 |
| http/html-1m | 1048576 | 6 | libdeflate | 24.48 | 49.53 | 2.02 | 327.55 |
| http/html-1m | 1048576 | 6 | stdx | 21.13 | 40.71 | 1.93 | 618.82 |
| http/html-1m | 1048576 | 9 | libdeflate | 69.70 | 109.24 | 1.57 | 431.92 |
| http/html-1m | 1048576 | 9 | stdx | 35.93 | 85.76 | 2.39 | 705.47 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.63 | 94.75 | 3.00 | 302.16 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.49 | 45.22 | 2.74 | 240.12 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 42.83 | 126.54 | 2.95 | 370.29 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.16 | 78.43 | 2.89 | 376.39 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 51.93 | 142.39 | 2.74 | 429.51 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.75 | 95.61 | 3.11 | 385.49 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.83 | 23.85 | 3.04 | 134.52 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.45 | 13.94 | 2.56 | 110.67 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.01 | 46.61 | 2.59 | 205.44 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.40 | 35.02 | 2.61 | 276.59 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 79.79 | 151.98 | 1.90 | 296.21 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.21 | 58.45 | 3.04 | 301.91 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.72 | 19.85 | 2.96 | 124.25 |
| http/json-1m | 1048576 | 1 | stdx | 5.07 | 12.51 | 2.47 | 103.34 |
| http/json-1m | 1048576 | 6 | libdeflate | 19.66 | 45.30 | 2.30 | 174.97 |
| http/json-1m | 1048576 | 6 | stdx | 14.69 | 35.09 | 2.39 | 299.26 |
| http/json-1m | 1048576 | 9 | libdeflate | 120.18 | 205.21 | 1.71 | 275.27 |
| http/json-1m | 1048576 | 9 | stdx | 29.08 | 72.87 | 2.51 | 369.00 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 36.93 | 107.75 | 2.92 | 518.68 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.65 | 65.45 | 2.77 | 409.86 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.10 | 144.79 | 2.95 | 677.85 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 35.60 | 104.17 | 2.93 | 616.88 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.45 | 150.07 | 2.92 | 716.63 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 40.37 | 125.18 | 3.10 | 626.76 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.71 | 30.90 | 2.64 | 309.46 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.82 | 24.80 | 2.29 | 272.83 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.72 | 59.43 | 2.31 | 484.25 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.65 | 50.05 | 2.21 | 674.13 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.49 | 83.30 | 2.06 | 568.30 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.63 | 81.31 | 2.74 | 664.86 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.63 | 25.19 | 2.62 | 247.89 |
| http/js-1m | 1048576 | 1 | stdx | 9.54 | 21.31 | 2.23 | 233.42 |
| http/js-1m | 1048576 | 6 | libdeflate | 27.85 | 56.12 | 2.02 | 370.68 |
| http/js-1m | 1048576 | 6 | stdx | 24.77 | 46.64 | 1.88 | 736.99 |
| http/js-1m | 1048576 | 9 | libdeflate | 74.74 | 120.65 | 1.61 | 499.62 |
| http/js-1m | 1048576 | 9 | stdx | 42.16 | 100.01 | 2.37 | 810.59 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.01 | 97.69 | 2.96 | 373.73 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.43 | 49.57 | 2.69 | 301.40 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.54 | 129.17 | 2.97 | 474.90 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.14 | 82.37 | 2.83 | 503.13 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.55 | 133.74 | 2.94 | 504.53 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.20 | 99.53 | 3.00 | 523.89 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.64 | 25.60 | 2.96 | 174.80 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.67 | 16.96 | 2.54 | 134.75 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.01 | 48.80 | 2.44 | 293.90 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.44 | 38.01 | 2.31 | 462.89 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.51 | 82.40 | 2.03 | 376.16 |
| http/css-16kx64 | 1048576 | 9 | stdx | 23.01 | 65.14 | 2.83 | 479.72 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.96 | 21.15 | 3.04 | 133.67 |
| http/css-1m | 1048576 | 1 | stdx | 5.79 | 14.91 | 2.58 | 108.61 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.22 | 44.50 | 2.20 | 226.87 |
| http/css-1m | 1048576 | 6 | stdx | 16.55 | 35.61 | 2.15 | 442.73 |
| http/css-1m | 1048576 | 9 | libdeflate | 68.59 | 111.58 | 1.63 | 309.29 |
| http/css-1m | 1048576 | 9 | stdx | 32.16 | 83.00 | 2.58 | 512.64 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.19 | 48.89 | 1.94 | 934.08 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.10 | 49.19 | 2.72 | 323.64 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 40.04 | 86.45 | 2.16 | 1171.82 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.61 | 88.80 | 2.24 | 851.52 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 45.39 | 94.50 | 2.08 | 1334.03 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.36 | 134.38 | 2.47 | 1134.11 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.03 | 31.22 | 3.11 | 120.58 |
| silesia/dickens | 10192446 | 1 | stdx | 24.20 | 82.03 | 3.39 | 126.78 |
| silesia/dickens | 10192446 | 3 | libzstd | 21.22 | 34.39 | 1.62 | 169.52 |
| silesia/dickens | 10192446 | 3 | stdx | 35.21 | 78.22 | 2.22 | 182.96 |
| silesia/mozilla | 51220480 | 1 | libzstd | 6.98 | 22.69 | 3.25 | 71.07 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.60 | 54.73 | 3.11 | 175.50 |
| silesia/mozilla | 51220480 | 3 | libzstd | 16.03 | 27.89 | 1.74 | 101.53 |
| silesia/mozilla | 51220480 | 3 | stdx | 30.16 | 62.01 | 2.06 | 145.10 |
| silesia/mr | 9970564 | 1 | libzstd | 7.60 | 24.81 | 3.27 | 57.49 |
| silesia/mr | 9970564 | 1 | stdx | 19.82 | 66.82 | 3.37 | 116.29 |
| silesia/mr | 9970564 | 3 | libzstd | 18.58 | 32.19 | 1.73 | 86.73 |
| silesia/mr | 9970564 | 3 | stdx | 32.97 | 72.46 | 2.20 | 114.70 |
| silesia/nci | 33553445 | 1 | libzstd | 3.46 | 9.55 | 2.76 | 57.29 |
| silesia/nci | 33553445 | 1 | stdx | 7.65 | 25.69 | 3.36 | 60.53 |
| silesia/nci | 33553445 | 3 | libzstd | 5.08 | 9.95 | 1.96 | 56.24 |
| silesia/nci | 33553445 | 3 | stdx | 11.11 | 29.15 | 2.62 | 66.90 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.52 | 29.26 | 3.43 | 72.41 |
| silesia/ooffice | 6152192 | 1 | stdx | 22.99 | 72.51 | 3.15 | 181.61 |
| silesia/ooffice | 6152192 | 3 | libzstd | 22.11 | 39.44 | 1.78 | 118.78 |
| silesia/ooffice | 6152192 | 3 | stdx | 41.20 | 82.20 | 1.99 | 186.30 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.01 | 22.29 | 3.18 | 66.73 |
| silesia/osdb | 10085684 | 1 | stdx | 16.33 | 50.52 | 3.09 | 124.94 |
| silesia/osdb | 10085684 | 3 | libzstd | 16.73 | 26.23 | 1.57 | 68.06 |
| silesia/osdb | 10085684 | 3 | stdx | 31.15 | 57.87 | 1.86 | 113.15 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.64 | 27.13 | 2.81 | 150.14 |
| silesia/reymont | 6627202 | 1 | stdx | 20.03 | 72.05 | 3.60 | 97.58 |
| silesia/reymont | 6627202 | 3 | libzstd | 17.08 | 27.10 | 1.59 | 126.18 |
| silesia/reymont | 6627202 | 3 | stdx | 27.57 | 62.18 | 2.26 | 147.92 |
| silesia/samba | 21606400 | 1 | libzstd | 5.84 | 16.88 | 2.89 | 85.37 |
| silesia/samba | 21606400 | 1 | stdx | 13.42 | 42.89 | 3.20 | 126.76 |
| silesia/samba | 21606400 | 3 | libzstd | 11.17 | 18.81 | 1.68 | 98.65 |
| silesia/samba | 21606400 | 3 | stdx | 20.08 | 44.75 | 2.23 | 133.91 |
| silesia/sao | 7251944 | 1 | libzstd | 9.00 | 33.69 | 3.74 | 45.24 |
| silesia/sao | 7251944 | 1 | stdx | 25.77 | 82.03 | 3.18 | 105.51 |
| silesia/sao | 7251944 | 3 | libzstd | 28.93 | 50.03 | 1.73 | 93.60 |
| silesia/sao | 7251944 | 3 | stdx | 50.41 | 95.22 | 1.89 | 142.78 |
| silesia/webster | 41458703 | 1 | libzstd | 8.61 | 24.94 | 2.90 | 130.97 |
| silesia/webster | 41458703 | 1 | stdx | 20.27 | 64.04 | 3.16 | 168.12 |
| silesia/webster | 41458703 | 3 | libzstd | 17.94 | 27.33 | 1.52 | 176.33 |
| silesia/webster | 41458703 | 3 | stdx | 30.50 | 64.55 | 2.12 | 195.61 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.61 | 14.92 | 3.23 | 17.13 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.74 | 76.64 | 3.23 | 92.80 |
| silesia/x-ray | 8474240 | 3 | libzstd | 29.32 | 52.73 | 1.80 | 87.33 |
| silesia/x-ray | 8474240 | 3 | stdx | 46.61 | 92.40 | 1.98 | 105.89 |
| silesia/xml | 5345280 | 1 | libzstd | 4.20 | 11.71 | 2.79 | 71.24 |
| silesia/xml | 5345280 | 1 | stdx | 10.32 | 34.21 | 3.32 | 95.72 |
| silesia/xml | 5345280 | 3 | libzstd | 6.29 | 12.61 | 2.01 | 76.89 |
| silesia/xml | 5345280 | 3 | stdx | 12.54 | 32.28 | 2.57 | 116.33 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.79 | 32.84 | 3.04 | 140.08 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.39 | 76.49 | 3.42 | 191.30 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 14.66 | 39.48 | 2.69 | 202.42 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.36 | 73.76 | 2.80 | 337.13 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.71 | 33.55 | 3.46 | 102.44 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.62 | 79.00 | 3.35 | 220.07 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 14.70 | 39.27 | 2.67 | 205.31 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 27.92 | 79.30 | 2.84 | 376.40 |
| canterbury/cp.html | 24603 | 1 | libzstd | 7.03 | 26.64 | 3.79 | 42.60 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.23 | 57.76 | 3.56 | 127.91 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.27 | 31.85 | 3.44 | 48.00 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.29 | 59.76 | 3.27 | 140.46 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.69 | 31.76 | 3.65 | 43.40 |
| canterbury/fields.c | 11150 | 1 | stdx | 17.09 | 65.73 | 3.84 | 93.66 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.27 | 34.14 | 3.68 | 29.02 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.18 | 64.68 | 3.77 | 85.41 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.47 | 38.01 | 4.01 | 9.57 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.32 | 77.57 | 3.82 | 56.72 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.66 | 43.09 | 4.04 | 7.04 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.35 | 79.60 | 3.73 | 64.39 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.00 | 23.56 | 3.93 | 14.64 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.69 | 56.75 | 3.86 | 87.44 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.12 | 23.80 | 2.93 | 27.19 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 20.24 | 56.61 | 2.80 | 108.73 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.80 | 28.52 | 2.91 | 155.90 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.37 | 72.02 | 3.37 | 163.43 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 15.32 | 32.14 | 2.10 | 200.58 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.31 | 67.10 | 2.55 | 299.11 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.31 | 32.37 | 3.14 | 128.95 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 24.98 | 84.16 | 3.37 | 160.61 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 18.86 | 38.77 | 2.06 | 225.42 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 31.70 | 80.77 | 2.55 | 344.30 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.16 | 8.51 | 2.70 | 67.49 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.51 | 23.15 | 3.08 | 106.04 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 4.58 | 10.97 | 2.40 | 57.98 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.43 | 24.08 | 2.55 | 133.53 |
| canterbury/sum | 38240 | 1 | libzstd | 6.59 | 25.39 | 3.85 | 34.14 |
| canterbury/sum | 38240 | 1 | stdx | 17.07 | 59.13 | 3.46 | 159.73 |
| canterbury/sum | 38240 | 3 | libzstd | 8.83 | 30.67 | 3.48 | 45.96 |
| canterbury/sum | 38240 | 3 | stdx | 19.92 | 61.82 | 3.10 | 184.02 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 9.95 | 39.82 | 4.00 | 11.02 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 21.00 | 80.38 | 3.83 | 65.00 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.17 | 48.17 | 3.96 | 13.75 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.92 | 83.98 | 3.66 | 82.26 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.29 | 33.44 | 3.25 | 76.51 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.64 | 95.62 | 4.42 | 7.26 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 13.95 | 31.30 | 2.24 | 36.10 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.50 | 70.38 | 2.99 | 39.85 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.66 | 27.45 | 2.84 | 148.84 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.28 | 71.86 | 3.54 | 109.02 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 17.02 | 28.20 | 1.66 | 132.77 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 27.65 | 63.36 | 2.29 | 155.97 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.11 | 22.70 | 2.80 | 137.31 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.58 | 55.86 | 3.01 | 196.12 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 14.51 | 23.87 | 1.64 | 172.32 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 24.61 | 51.26 | 2.08 | 238.41 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.05 | 52.46 | 3.08 | 158.65 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.69 | 100.54 | 2.82 | 640.48 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.06 | 59.20 | 3.11 | 196.60 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 37.70 | 104.00 | 2.76 | 633.07 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.69 | 22.46 | 2.92 | 122.06 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.12 | 46.84 | 3.32 | 184.07 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.67 | 24.61 | 2.84 | 140.05 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.29 | 47.61 | 3.11 | 193.27 |
| http/html-1m | 1048576 | 1 | libzstd | 6.19 | 16.74 | 2.70 | 114.08 |
| http/html-1m | 1048576 | 1 | stdx | 12.89 | 42.00 | 3.26 | 136.53 |
| http/html-1m | 1048576 | 3 | libzstd | 8.92 | 18.18 | 2.04 | 124.31 |
| http/html-1m | 1048576 | 3 | stdx | 15.73 | 39.37 | 2.50 | 178.74 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.37 | 42.52 | 2.96 | 116.18 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.41 | 83.13 | 2.83 | 528.62 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.84 | 44.54 | 3.00 | 128.92 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.79 | 84.87 | 2.76 | 532.81 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.79 | 14.98 | 3.13 | 57.83 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.68 | 33.78 | 3.49 | 117.82 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.29 | 16.21 | 3.06 | 71.54 |
| http/json-16kx64 | 1048576 | 3 | stdx | 11.01 | 34.58 | 3.14 | 123.97 |
| http/json-1m | 1048576 | 1 | libzstd | 4.02 | 12.55 | 3.12 | 52.39 |
| http/json-1m | 1048576 | 1 | stdx | 8.99 | 30.70 | 3.41 | 87.27 |
| http/json-1m | 1048576 | 3 | libzstd | 5.91 | 13.78 | 2.33 | 67.60 |
| http/json-1m | 1048576 | 3 | stdx | 11.27 | 30.64 | 2.72 | 120.75 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.57 | 57.26 | 3.08 | 184.89 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 39.77 | 113.49 | 2.85 | 696.93 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.42 | 65.54 | 3.06 | 258.44 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 41.83 | 116.54 | 2.79 | 688.06 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.82 | 26.52 | 3.01 | 127.87 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.58 | 55.71 | 3.36 | 203.02 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 9.92 | 28.74 | 2.90 | 150.53 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.55 | 55.35 | 3.15 | 210.99 |
| http/js-1m | 1048576 | 1 | libzstd | 6.52 | 17.87 | 2.74 | 113.58 |
| http/js-1m | 1048576 | 1 | stdx | 13.92 | 45.88 | 3.30 | 137.56 |
| http/js-1m | 1048576 | 3 | libzstd | 9.51 | 19.14 | 2.01 | 124.28 |
| http/js-1m | 1048576 | 3 | stdx | 16.95 | 41.25 | 2.43 | 188.47 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.61 | 46.90 | 3.01 | 137.70 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.14 | 91.65 | 2.85 | 582.53 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.65 | 50.53 | 3.03 | 158.94 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.39 | 93.63 | 2.80 | 585.78 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.10 | 18.99 | 3.11 | 78.60 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.39 | 43.79 | 3.53 | 138.32 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.48 | 19.41 | 3.00 | 94.71 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.81 | 42.34 | 3.31 | 152.82 |
| http/css-1m | 1048576 | 1 | libzstd | 1.49 | 4.59 | 3.07 | 21.93 |
| http/css-1m | 1048576 | 1 | stdx | 3.98 | 14.85 | 3.73 | 30.55 |
| http/css-1m | 1048576 | 3 | libzstd | 1.89 | 5.25 | 2.77 | 19.65 |
| http/css-1m | 1048576 | 3 | stdx | 3.95 | 13.33 | 3.37 | 31.84 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.51 | 12.79 | 3.64 | 6.04 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.13 | 30.66 | 3.36 | 63.05 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 25.93 | 50.53 | 1.95 | 49.14 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 20.80 | 47.43 | 2.28 | 210.05 |

## Hardware counters per input octet, brotli encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | Google q1 | 16.99 | 30.24 | 1.78 | 228.11 |
| silesia/dickens | 10192446 | stdx 1 | 19.31 | 43.43 | 2.25 | 413.48 |
| silesia/dickens | 10192446 | Google q5 | 91.14 | 194.36 | 2.13 | 815.57 |
| silesia/dickens | 10192446 | stdx 5 | 68.67 | 156.51 | 2.28 | 981.79 |
| silesia/mozilla | 51220480 | Google q1 | 12.58 | 25.26 | 2.01 | 143.57 |
| silesia/mozilla | 51220480 | stdx 1 | 12.31 | 32.95 | 2.68 | 213.99 |
| silesia/mozilla | 51220480 | Google q5 | 58.42 | 149.30 | 2.56 | 794.99 |
| silesia/mozilla | 51220480 | stdx 5 | 57.41 | 149.71 | 2.61 | 812.84 |
| silesia/mr | 9970564 | Google q1 | 12.50 | 26.14 | 2.09 | 97.08 |
| silesia/mr | 9970564 | stdx 1 | 13.59 | 37.80 | 2.78 | 165.14 |
| silesia/mr | 9970564 | Google q5 | 72.83 | 177.40 | 2.44 | 604.92 |
| silesia/mr | 9970564 | stdx 5 | 60.27 | 150.44 | 2.50 | 697.88 |
| silesia/nci | 33553445 | Google q1 | 5.08 | 9.71 | 1.91 | 87.85 |
| silesia/nci | 33553445 | stdx 1 | 5.97 | 14.48 | 2.43 | 128.23 |
| silesia/nci | 33553445 | Google q5 | 28.39 | 59.01 | 2.08 | 406.62 |
| silesia/nci | 33553445 | stdx 5 | 25.92 | 58.75 | 2.27 | 473.44 |
| silesia/ooffice | 6152192 | Google q1 | 16.48 | 33.43 | 2.03 | 152.82 |
| silesia/ooffice | 6152192 | stdx 1 | 16.70 | 45.85 | 2.75 | 267.51 |
| silesia/ooffice | 6152192 | Google q5 | 81.18 | 198.80 | 2.45 | 1062.19 |
| silesia/ooffice | 6152192 | stdx 5 | 72.18 | 180.71 | 2.50 | 1071.82 |
| silesia/osdb | 10085684 | Google q1 | 11.65 | 23.47 | 2.01 | 84.39 |
| silesia/osdb | 10085684 | stdx 1 | 11.61 | 32.00 | 2.76 | 140.97 |
| silesia/osdb | 10085684 | Google q5 | 60.99 | 146.01 | 2.39 | 543.73 |
| silesia/osdb | 10085684 | stdx 5 | 48.33 | 125.21 | 2.59 | 516.04 |
| silesia/reymont | 6627202 | Google q1 | 14.40 | 25.54 | 1.77 | 206.30 |
| silesia/reymont | 6627202 | stdx 1 | 14.35 | 33.36 | 2.32 | 283.69 |
| silesia/reymont | 6627202 | Google q5 | 72.71 | 169.16 | 2.33 | 796.14 |
| silesia/reymont | 6627202 | stdx 5 | 58.96 | 140.32 | 2.38 | 892.98 |
| silesia/samba | 21606400 | Google q1 | 9.39 | 17.38 | 1.85 | 125.86 |
| silesia/samba | 21606400 | stdx 1 | 9.80 | 23.94 | 2.44 | 197.01 |
| silesia/samba | 21606400 | Google q5 | 43.42 | 105.54 | 2.43 | 477.67 |
| silesia/samba | 21606400 | stdx 5 | 40.33 | 103.19 | 2.56 | 524.67 |
| silesia/sao | 7251944 | Google q1 | 19.30 | 39.96 | 2.07 | 100.18 |
| silesia/sao | 7251944 | stdx 1 | 18.66 | 55.66 | 2.98 | 190.30 |
| silesia/sao | 7251944 | Google q5 | 100.20 | 259.63 | 2.59 | 923.47 |
| silesia/sao | 7251944 | stdx 5 | 87.28 | 233.57 | 2.68 | 749.79 |
| silesia/webster | 41458703 | Google q1 | 13.66 | 24.40 | 1.79 | 204.59 |
| silesia/webster | 41458703 | stdx 1 | 15.30 | 34.12 | 2.23 | 339.74 |
| silesia/webster | 41458703 | Google q5 | 67.57 | 141.82 | 2.10 | 749.76 |
| silesia/webster | 41458703 | stdx 5 | 54.73 | 122.07 | 2.23 | 837.85 |
| silesia/x-ray | 8474240 | Google q1 | 13.72 | 22.03 | 1.61 | 12.42 |
| silesia/x-ray | 8474240 | stdx 1 | 13.08 | 38.68 | 2.96 | 94.33 |
| silesia/x-ray | 8474240 | Google q5 | 90.79 | 236.76 | 2.61 | 723.83 |
| silesia/x-ray | 8474240 | stdx 5 | 82.77 | 231.05 | 2.79 | 646.13 |
| silesia/xml | 5345280 | Google q1 | 6.72 | 12.28 | 1.83 | 112.67 |
| silesia/xml | 5345280 | stdx 1 | 7.27 | 17.44 | 2.40 | 152.97 |
| silesia/xml | 5345280 | Google q5 | 29.31 | 72.50 | 2.47 | 357.80 |
| silesia/xml | 5345280 | stdx 5 | 25.59 | 65.03 | 2.54 | 405.15 |
| canterbury/alice29.txt | 152089 | Google q1 | 16.17 | 29.72 | 1.84 | 205.11 |
| canterbury/alice29.txt | 152089 | stdx 1 | 18.36 | 40.79 | 2.22 | 448.83 |
| canterbury/alice29.txt | 152089 | Google q5 | 77.55 | 200.76 | 2.59 | 1034.60 |
| canterbury/alice29.txt | 152089 | stdx 5 | 58.43 | 148.01 | 2.53 | 904.92 |
| canterbury/asyoulik.txt | 125179 | Google q1 | 17.04 | 32.36 | 1.90 | 216.98 |
| canterbury/asyoulik.txt | 125179 | stdx 1 | 20.11 | 44.50 | 2.21 | 501.78 |
| canterbury/asyoulik.txt | 125179 | Google q5 | 82.90 | 215.26 | 2.60 | 1076.34 |
| canterbury/asyoulik.txt | 125179 | stdx 5 | 64.56 | 159.47 | 2.47 | 1046.70 |
| canterbury/cp.html | 24603 | Google q1 | 13.04 | 27.29 | 2.09 | 100.24 |
| canterbury/cp.html | 24603 | stdx 1 | 14.60 | 36.07 | 2.47 | 353.07 |
| canterbury/cp.html | 24603 | Google q5 | 58.91 | 163.84 | 2.78 | 944.68 |
| canterbury/cp.html | 24603 | stdx 5 | 46.12 | 128.83 | 2.79 | 724.24 |
| canterbury/fields.c | 11150 | Google q1 | 12.13 | 29.03 | 2.39 | 14.32 |
| canterbury/fields.c | 11150 | stdx 1 | 10.37 | 38.87 | 3.75 | 82.00 |
| canterbury/fields.c | 11150 | Google q5 | 57.61 | 168.04 | 2.92 | 897.29 |
| canterbury/fields.c | 11150 | stdx 5 | 39.56 | 120.96 | 3.06 | 533.06 |
| canterbury/grammar.lsp | 3721 | Google q1 | 14.37 | 39.35 | 2.74 | 8.17 |
| canterbury/grammar.lsp | 3721 | stdx 1 | 13.52 | 55.22 | 4.08 | 32.82 |
| canterbury/grammar.lsp | 3721 | Google q5 | 59.52 | 203.59 | 3.42 | 446.59 |
| canterbury/grammar.lsp | 3721 | stdx 5 | 38.71 | 145.59 | 3.76 | 160.44 |
| canterbury/kennedy.xls | 1029744 | Google q1 | 9.70 | 24.83 | 2.56 | 59.63 |
| canterbury/kennedy.xls | 1029744 | stdx 1 | 7.80 | 27.03 | 3.47 | 77.02 |
| canterbury/kennedy.xls | 1029744 | Google q5 | 46.42 | 162.90 | 3.51 | 264.07 |
| canterbury/kennedy.xls | 1029744 | stdx 5 | 49.66 | 162.41 | 3.27 | 466.66 |
| canterbury/lcet10.txt | 426754 | Google q1 | 15.18 | 27.19 | 1.79 | 196.63 |
| canterbury/lcet10.txt | 426754 | stdx 1 | 16.76 | 37.84 | 2.26 | 379.84 |
| canterbury/lcet10.txt | 426754 | Google q5 | 75.29 | 187.57 | 2.49 | 952.75 |
| canterbury/lcet10.txt | 426754 | stdx 5 | 56.59 | 139.70 | 2.47 | 896.53 |
| canterbury/plrabn12.txt | 481861 | Google q1 | 17.97 | 32.57 | 1.81 | 245.67 |
| canterbury/plrabn12.txt | 481861 | stdx 1 | 20.80 | 46.66 | 2.24 | 473.83 |
| canterbury/plrabn12.txt | 481861 | Google q5 | 92.44 | 229.76 | 2.49 | 1061.37 |
| canterbury/plrabn12.txt | 481861 | stdx 5 | 70.73 | 167.86 | 2.37 | 1172.67 |
| canterbury/ptt5 | 513216 | Google q1 | 4.89 | 9.55 | 1.95 | 79.24 |
| canterbury/ptt5 | 513216 | stdx 1 | 6.65 | 15.64 | 2.35 | 161.15 |
| canterbury/ptt5 | 513216 | Google q5 | 26.86 | 68.86 | 2.56 | 465.55 |
| canterbury/ptt5 | 513216 | stdx 5 | 27.53 | 69.27 | 2.52 | 460.92 |
| canterbury/sum | 38240 | Google q1 | 12.85 | 29.24 | 2.28 | 88.64 |
| canterbury/sum | 38240 | stdx 1 | 15.54 | 36.37 | 2.34 | 406.93 |
| canterbury/sum | 38240 | Google q5 | 64.71 | 182.55 | 2.82 | 1094.81 |
| canterbury/sum | 38240 | stdx 5 | 55.48 | 155.87 | 2.81 | 832.39 |
| canterbury/xargs.1 | 4227 | Google q1 | 16.28 | 43.12 | 2.65 | 13.55 |
| canterbury/xargs.1 | 4227 | stdx 1 | 14.86 | 59.10 | 3.98 | 50.52 |
| canterbury/xargs.1 | 4227 | Google q5 | 68.61 | 218.74 | 3.19 | 734.27 |
| canterbury/xargs.1 | 4227 | stdx 5 | 43.60 | 155.91 | 3.58 | 293.56 |
| canterbury-large/E.coli | 4638690 | Google q1 | 12.86 | 27.46 | 2.14 | 53.45 |
| canterbury-large/E.coli | 4638690 | stdx 1 | 5.52 | 19.24 | 3.48 | 18.15 |
| canterbury-large/E.coli | 4638690 | Google q5 | 87.10 | 262.67 | 3.02 | 997.27 |
| canterbury-large/E.coli | 4638690 | stdx 5 | 30.52 | 93.11 | 3.05 | 64.64 |
| canterbury-large/bible.txt | 4047392 | Google q1 | 13.80 | 24.57 | 1.78 | 172.52 |
| canterbury-large/bible.txt | 4047392 | stdx 1 | 15.16 | 34.29 | 2.26 | 317.95 |
| canterbury-large/bible.txt | 4047392 | Google q5 | 71.97 | 165.65 | 2.30 | 726.64 |
| canterbury-large/bible.txt | 4047392 | stdx 5 | 56.50 | 134.78 | 2.39 | 801.33 |
| canterbury-large/world192.txt | 2473400 | Google q1 | 12.81 | 22.62 | 1.77 | 191.64 |
| canterbury-large/world192.txt | 2473400 | stdx 1 | 13.64 | 31.07 | 2.28 | 314.45 |
| canterbury-large/world192.txt | 2473400 | Google q5 | 61.75 | 129.46 | 2.10 | 735.99 |
| canterbury-large/world192.txt | 2473400 | stdx 5 | 46.20 | 105.74 | 2.29 | 750.67 |
| http/html-1kx1024 | 1048576 | Google q1 | 32.32 | 62.37 | 1.93 | 863.96 |
| http/html-1kx1024 | 1048576 | stdx 1 | 27.28 | 80.73 | 2.96 | 475.23 |
| http/html-1kx1024 | 1048576 | Google q5 | 104.66 | 259.72 | 2.48 | 2118.39 |
| http/html-1kx1024 | 1048576 | stdx 5 | 62.05 | 167.89 | 2.71 | 1113.95 |
| http/html-16kx64 | 1048576 | Google q1 | 11.30 | 20.37 | 1.80 | 214.33 |
| http/html-16kx64 | 1048576 | stdx 1 | 11.49 | 28.46 | 2.48 | 303.77 |
| http/html-16kx64 | 1048576 | Google q5 | 45.63 | 118.46 | 2.60 | 853.49 |
| http/html-16kx64 | 1048576 | stdx 5 | 35.23 | 92.10 | 2.61 | 639.40 |
| http/html-1m | 1048576 | Google q1 | 8.56 | 15.15 | 1.77 | 135.81 |
| http/html-1m | 1048576 | stdx 1 | 9.66 | 22.18 | 2.30 | 226.04 |
| http/html-1m | 1048576 | Google q5 | 42.65 | 104.93 | 2.46 | 571.64 |
| http/html-1m | 1048576 | stdx 5 | 33.02 | 84.11 | 2.55 | 530.53 |
| http/json-1kx1024 | 1048576 | Google q1 | 24.72 | 49.72 | 2.01 | 651.08 |
| http/json-1kx1024 | 1048576 | stdx 1 | 20.91 | 61.64 | 2.95 | 364.56 |
| http/json-1kx1024 | 1048576 | Google q5 | 78.01 | 201.96 | 2.59 | 1339.62 |
| http/json-1kx1024 | 1048576 | stdx 5 | 46.38 | 131.37 | 2.83 | 709.20 |
| http/json-16kx64 | 1048576 | Google q1 | 7.64 | 14.89 | 1.95 | 142.59 |
| http/json-16kx64 | 1048576 | stdx 1 | 7.03 | 19.73 | 2.81 | 159.75 |
| http/json-16kx64 | 1048576 | Google q5 | 35.08 | 97.74 | 2.79 | 558.52 |
| http/json-16kx64 | 1048576 | stdx 5 | 31.42 | 88.58 | 2.82 | 518.93 |
| http/json-1m | 1048576 | Google q1 | 6.06 | 12.65 | 2.09 | 91.22 |
| http/json-1m | 1048576 | stdx 1 | 6.62 | 17.21 | 2.60 | 140.74 |
| http/json-1m | 1048576 | Google q5 | 34.70 | 96.08 | 2.77 | 445.44 |
| http/json-1m | 1048576 | stdx 5 | 34.16 | 92.25 | 2.70 | 562.92 |
| http/js-1kx1024 | 1048576 | Google q1 | 34.89 | 68.03 | 1.95 | 904.91 |
| http/js-1kx1024 | 1048576 | stdx 1 | 30.36 | 90.40 | 2.98 | 535.05 |
| http/js-1kx1024 | 1048576 | Google q5 | 114.45 | 287.38 | 2.51 | 2297.95 |
| http/js-1kx1024 | 1048576 | stdx 5 | 68.61 | 186.45 | 2.72 | 1234.93 |
| http/js-16kx64 | 1048576 | Google q1 | 13.13 | 24.05 | 1.83 | 230.89 |
| http/js-16kx64 | 1048576 | stdx 1 | 13.35 | 32.69 | 2.45 | 356.04 |
| http/js-16kx64 | 1048576 | Google q5 | 53.71 | 141.07 | 2.63 | 994.89 |
| http/js-16kx64 | 1048576 | stdx 5 | 40.99 | 106.28 | 2.59 | 750.03 |
| http/js-1m | 1048576 | Google q1 | 9.24 | 16.69 | 1.81 | 138.80 |
| http/js-1m | 1048576 | stdx 1 | 10.14 | 23.55 | 2.32 | 230.24 |
| http/js-1m | 1048576 | Google q5 | 47.71 | 116.02 | 2.43 | 633.24 |
| http/js-1m | 1048576 | stdx 5 | 35.72 | 90.22 | 2.53 | 575.75 |
| http/css-1kx1024 | 1048576 | Google q1 | 27.70 | 53.91 | 1.95 | 728.46 |
| http/css-1kx1024 | 1048576 | stdx 1 | 23.51 | 68.32 | 2.91 | 433.16 |
| http/css-1kx1024 | 1048576 | Google q5 | 84.95 | 212.73 | 2.50 | 1654.80 |
| http/css-1kx1024 | 1048576 | stdx 5 | 50.30 | 137.20 | 2.73 | 881.02 |
| http/css-16kx64 | 1048576 | Google q1 | 8.99 | 16.83 | 1.87 | 140.04 |
| http/css-16kx64 | 1048576 | stdx 1 | 8.47 | 23.62 | 2.79 | 192.56 |
| http/css-16kx64 | 1048576 | Google q5 | 36.50 | 100.60 | 2.76 | 644.63 |
| http/css-16kx64 | 1048576 | stdx 5 | 28.64 | 80.59 | 2.81 | 485.91 |
| http/css-1m | 1048576 | Google q1 | 5.80 | 11.27 | 1.94 | 75.60 |
| http/css-1m | 1048576 | stdx 1 | 5.42 | 14.38 | 2.65 | 110.23 |
| http/css-1m | 1048576 | Google q5 | 13.88 | 38.50 | 2.77 | 129.47 |
| http/css-1m | 1048576 | stdx 5 | 11.59 | 36.69 | 3.17 | 110.09 |
| shuffled/dickens-1m | 1048576 | Google q1 | 11.40 | 20.96 | 1.84 | 2.70 |
| shuffled/dickens-1m | 1048576 | stdx 1 | 5.21 | 19.75 | 3.79 | 10.11 |
| shuffled/dickens-1m | 1048576 | Google q5 | 87.80 | 235.57 | 2.68 | 722.71 |
| shuffled/dickens-1m | 1048576 | stdx 5 | 41.08 | 122.09 | 2.97 | 200.85 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.118 | 3.00 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 65.6 | 219.6 | 0.086 | 7.75 | 3.35 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 30.5 | 96.1 | 0.164 | 3.61 | 3.15 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextReader.next_items | 28.3 | 80.8 | 0.152 | 3.34 | 2.85 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 250.3 | 1024.0 | 0.834 | 29.57 | 4.09 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.8 | 107.7 | 0.135 | 3.64 | 3.50 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.8 | 106.2 | 0.293 | 3.29 | 3.81 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.1 | 378.2 | 0.388 | 11.23 | 3.98 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.5 | 161.9 | 0.453 | 5.02 | 3.81 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 90.9 | 451.7 | 0.301 | 10.74 | 4.97 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.1 | 89.5 | 0.004 | 3.99 | 3.30 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 67.5 | 234.7 | 0.040 | 9.94 | 3.48 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 29.2 | 99.4 | 0.013 | 4.30 | 3.40 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextReader.next_items | 27.0 | 84.2 | 0.009 | 3.98 | 3.12 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 215.9 | 819.1 | 0.946 | 31.78 | 3.79 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.3 | 107.7 | 0.040 | 4.17 | 3.81 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.2 | 106.0 | 0.046 | 4.16 | 3.75 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 94.9 | 346.2 | 0.363 | 13.97 | 3.65 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 31.6 | 144.5 | 0.052 | 4.66 | 4.57 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 89.9 | 406.5 | 0.078 | 13.23 | 4.52 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 41.8 | 96.3 | 0.195 | 3.92 | 2.30 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 84.8 | 249.4 | 0.236 | 7.94 | 2.94 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 45.9 | 113.8 | 0.280 | 4.30 | 2.48 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextReader.next_items | 43.4 | 99.4 | 0.214 | 4.07 | 2.29 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 313.2 | 1284.6 | 1.049 | 29.34 | 4.10 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 36.5 | 133.1 | 0.188 | 3.42 | 3.64 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 46.0 | 128.6 | 0.734 | 4.31 | 2.80 |
| messages: 11 string members | 96000 | 1025025 | std.json | 124.3 | 451.2 | 1.042 | 11.64 | 3.63 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 67.1 | 204.1 | 0.982 | 6.28 | 3.04 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 134.9 | 572.0 | 0.858 | 12.63 | 4.24 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 24.3 | 78.8 | 0.017 | 3.04 | 3.24 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 67.0 | 239.5 | 0.009 | 8.39 | 3.57 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 28.0 | 93.3 | 0.043 | 3.50 | 3.34 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextReader.next_items | 26.0 | 78.0 | 0.033 | 3.26 | 2.99 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 232.1 | 942.3 | 0.422 | 29.06 | 4.06 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 28.1 | 107.6 | 0.048 | 3.52 | 3.82 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 25.4 | 104.8 | 0.022 | 3.18 | 4.12 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 88.2 | 361.0 | 0.027 | 11.04 | 4.09 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 32.1 | 151.6 | 0.032 | 4.02 | 4.72 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 82.1 | 418.2 | 0.008 | 10.28 | 5.10 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim on | 12.9 | 56.5 | 0.049 | 5.93 | 4.37 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, one token a call | 50.1 | 172.6 | 0.139 | 23.00 | 3.45 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, TextWriter's methods or TextReader.next | 16.4 | 73.4 | 0.080 | 7.53 | 4.47 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, TextReader.next_items | 13.9 | 57.7 | 0.047 | 6.37 | 4.16 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim off | 101.3 | 326.3 | 0.260 | 46.49 | 3.22 |
| messages: a tree of 341 objects | 281100 | 612600 | simdjson | 16.2 | 58.4 | 0.024 | 7.44 | 3.60 |
| messages: a tree of 341 objects | 281100 | 612600 | yyjson | 15.9 | 72.2 | 0.047 | 7.31 | 4.53 |
| messages: a tree of 341 objects | 281100 | 612600 | std.json | 55.6 | 220.1 | 0.117 | 25.53 | 3.96 |
| messages: a tree of 341 objects | 281100 | 612600 | serde_json | 13.7 | 59.5 | 0.094 | 6.29 | 4.34 |
| messages: a tree of 341 objects | 281100 | 612600 | Go jsontext | 43.6 | 216.0 | 0.117 | 19.99 | 4.96 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114893.8 | 403852.2 | 525.639 | 0.67 | 3.52 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 590181.0 | 2495394.2 | 1401.165 | 3.42 | 4.23 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 114708.1 | 404249.2 | 498.969 | 0.66 | 3.52 |
| string: silesia/dickens | 1 | 172528 | stdx, TextReader.next_items | 114461.4 | 404282.2 | 501.072 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3551206.3 | 18223882.2 | 2976.093 | 20.58 | 5.13 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311308.5 | 621744.2 | 587.732 | 1.80 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 224638.6 | 826630.2 | 2295.691 | 1.30 | 3.68 |
| string: silesia/dickens | 1 | 172528 | std.json | 1572865.5 | 4578768.2 | 42403.433 | 9.12 | 2.91 |
| string: silesia/dickens | 1 | 172528 | serde_json | 203866.5 | 802604.2 | 993.515 | 1.18 | 3.94 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1045000.6 | 5282087.4 | 4998.052 | 6.06 | 5.05 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1566494.1 | 4799769.6 | 1466.357 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14100708.4 | 56410893.6 | 39362.214 | 11.85 | 4.00 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1564669.2 | 4799955.6 | 1357.143 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, TextReader.next_items | 1563925.3 | 4799988.6 | 1326.143 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 29011048.9 | 132108259.6 | 159310.357 | 24.37 | 4.55 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4587020.2 | 7062781.6 | 516.714 | 3.85 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1784929.6 | 7322029.6 | 14177.857 | 1.50 | 4.10 |
| string: http/json-1m | 1 | 1190272 | std.json | 10392648.6 | 47381157.6 | 32057.500 | 8.73 | 4.56 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3782457.4 | 15226594.6 | 6175.357 | 3.18 | 4.03 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 8923727.6 | 47991993.5 | 27520.500 | 7.50 | 5.38 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2066468.8 | 5765419.8 | 4311.750 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6150490.1 | 22538840.8 | 6973.125 | 3.27 | 3.66 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2055520.9 | 5765605.8 | 3818.250 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextReader.next_items | 2054644.4 | 5765638.8 | 3718.375 | 1.09 | 2.81 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47493331.1 | 227842326.8 | 291091.500 | 25.22 | 4.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3764263.9 | 8446023.8 | 1993.250 | 2.00 | 2.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7120112.8 | 12276717.8 | 275055.500 | 3.78 | 1.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17454490.0 | 63617055.8 | 269041.625 | 9.27 | 3.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9292990.0 | 24441106.8 | 307325.875 | 4.94 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39222936.0 | 160384128.8 | 795608.125 | 20.83 | 4.09 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12951887.0 | 42561075.3 | 246047.333 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 160095157.7 | 666700955.3 | 394434.000 | 31.54 | 4.16 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12931494.7 | 42561261.3 | 244371.333 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextReader.next_items | 12924461.3 | 42561294.3 | 245278.667 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 160614867.7 | 639992668.3 | 423986.333 | 31.65 | 3.98 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17553598.7 | 49745820.3 | 253766.333 | 3.46 | 2.83 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14010466.3 | 45615166.3 | 446641.000 | 2.76 | 3.26 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79203842.7 | 314900845.3 | 458806.667 | 15.61 | 3.98 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 35365487.0 | 131556247.3 | 585174.000 | 6.97 | 3.72 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66019883.0 | 273932710.0 | 834871.000 | 13.01 | 4.15 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 92043.8 | 303842.7 | 6.581 | 0.18 | 3.30 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 182158.5 | 623466.7 | 10.226 | 0.35 | 3.42 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 147910.9 | 557622.7 | 6.129 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextReader.next_items | 147916.8 | 557626.7 | 7.677 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10203839.2 | 53478208.7 | 7.161 | 19.46 | 5.24 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 488875.3 | 1376733.7 | 7.419 | 0.93 | 2.82 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 535452.6 | 2195917.7 | 7.774 | 1.02 | 4.10 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3499087.2 | 12808414.7 | 60802.387 | 6.67 | 3.66 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 285839.9 | 1179969.7 | 7.129 | 0.55 | 4.13 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2243755.0 | 12790461.5 | 262.774 | 4.28 | 5.70 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.5 | 81.8 | 0.107 | 2.30 | 4.20 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.3 | 153.5 | 0.128 | 4.17 | 4.35 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 20.7 | 91.8 | 0.092 | 2.44 | 4.44 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 217.5 | 981.0 | 0.932 | 25.70 | 4.51 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 18.7 | 79.5 | 0.104 | 2.21 | 4.26 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.1 | 94.1 | 0.135 | 2.73 | 4.08 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.3 | 105.6 | 0.245 | 3.23 | 3.86 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.4 | 310.8 | 0.373 | 8.19 | 4.48 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.6 | 255.2 | 0.492 | 7.51 | 4.01 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 67.6 | 315.1 | 0.233 | 7.98 | 4.66 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.8 | 82.8 | 0.024 | 2.76 | 4.41 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.1 | 153.9 | 0.026 | 5.32 | 4.26 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 21.1 | 91.4 | 0.023 | 3.11 | 4.33 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 169.9 | 718.3 | 1.253 | 25.00 | 4.23 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 17.7 | 81.5 | 0.025 | 2.61 | 4.60 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 22.1 | 96.8 | 0.032 | 3.26 | 4.37 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.7 | 117.9 | 0.033 | 4.23 | 4.10 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 60.1 | 271.2 | 0.272 | 8.85 | 4.51 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 48.8 | 212.4 | 0.038 | 7.18 | 4.35 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 81.7 | 331.5 | 0.084 | 12.03 | 4.06 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 30.0 | 85.9 | 0.384 | 2.81 | 2.86 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 43.2 | 151.2 | 0.408 | 4.04 | 3.50 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 28.7 | 89.2 | 0.400 | 2.69 | 3.10 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 273.2 | 1195.0 | 1.144 | 25.59 | 4.37 |
| messages: 11 string members | 96000 | 1025025 | stdx, J11's loop unchecked | 28.4 | 82.8 | 0.380 | 2.66 | 2.91 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 37.9 | 119.1 | 0.573 | 3.55 | 3.14 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 46.7 | 138.2 | 0.701 | 4.37 | 2.96 |
| messages: 11 string members | 96000 | 1025025 | std.json | 100.5 | 370.8 | 1.076 | 9.41 | 3.69 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 88.1 | 315.4 | 0.747 | 8.25 | 3.58 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 105.8 | 400.4 | 0.857 | 9.91 | 3.78 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 20.0 | 80.2 | 0.007 | 2.50 | 4.01 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 37.9 | 152.5 | 0.006 | 4.74 | 4.03 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 21.4 | 91.1 | 0.006 | 2.68 | 4.25 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 195.6 | 866.7 | 0.745 | 24.48 | 4.43 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, J11's loop unchecked | 19.4 | 79.4 | 0.007 | 2.43 | 4.09 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 23.5 | 96.6 | 0.004 | 2.95 | 4.10 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 25.3 | 101.3 | 0.018 | 3.16 | 4.01 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 59.0 | 279.4 | 0.006 | 7.38 | 4.74 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 51.7 | 230.3 | 0.062 | 6.48 | 4.45 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 69.4 | 310.8 | 0.006 | 8.68 | 4.48 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim on | 15.7 | 62.6 | 0.023 | 7.21 | 3.98 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, one token a call | 32.0 | 135.7 | 0.032 | 14.67 | 4.24 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, TextWriter's methods or TextReader.next | 14.1 | 58.1 | 0.028 | 6.47 | 4.13 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim off | 81.3 | 375.6 | 0.238 | 37.29 | 4.62 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, J11's loop unchecked | 14.7 | 61.4 | 0.023 | 6.74 | 4.18 |
| messages: a tree of 341 objects | 281100 | 612600 | simdjson | 12.5 | 45.5 | 0.026 | 5.71 | 3.65 |
| messages: a tree of 341 objects | 281100 | 612600 | yyjson | 15.6 | 56.5 | 0.051 | 7.16 | 3.62 |
| messages: a tree of 341 objects | 281100 | 612600 | std.json | 27.8 | 125.4 | 0.045 | 12.74 | 4.52 |
| messages: a tree of 341 objects | 281100 | 612600 | serde_json | 23.4 | 102.3 | 0.028 | 10.72 | 4.38 |
| messages: a tree of 341 objects | 281100 | 612600 | Go jsontext | 41.7 | 181.3 | 0.118 | 19.14 | 4.35 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 85235.6 | 280786.2 | 731.412 | 0.49 | 3.29 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 85154.3 | 280732.2 | 732.691 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 85219.5 | 280710.2 | 732.897 | 0.49 | 3.29 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3372929.1 | 16047574.2 | 2955.526 | 19.55 | 4.76 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 82884.7 | 274401.2 | 656.856 | 0.48 | 3.31 |
| string: silesia/dickens | 1 | 172528 | simdjson | 207114.2 | 674016.2 | 2062.216 | 1.20 | 3.25 |
| string: silesia/dickens | 1 | 172528 | yyjson | 205706.4 | 825518.2 | 1127.794 | 1.19 | 4.01 |
| string: silesia/dickens | 1 | 172528 | std.json | 1364841.9 | 2890892.2 | 54008.835 | 7.91 | 2.12 |
| string: silesia/dickens | 1 | 172528 | serde_json | 367417.7 | 1586249.2 | 2282.505 | 2.13 | 4.32 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 579159.7 | 2970245.9 | 2335.134 | 3.36 | 5.13 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1277419.9 | 3582350.6 | 11560.500 | 1.07 | 2.80 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1263415.7 | 3582290.6 | 11021.857 | 1.06 | 2.84 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1260417.1 | 3582273.6 | 10867.071 | 1.06 | 2.84 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25136813.9 | 109856348.6 | 141688.857 | 21.12 | 4.37 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1228045.6 | 3370022.6 | 10987.214 | 1.03 | 2.74 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2972289.6 | 10460762.6 | 29065.143 | 2.50 | 3.52 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2586005.6 | 10197931.6 | 9685.643 | 2.17 | 3.94 |
| string: http/json-1m | 1 | 1190272 | std.json | 8970651.4 | 43287986.6 | 17366.357 | 7.54 | 4.83 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4210588.1 | 17941088.6 | 11370.929 | 3.54 | 4.26 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5247830.5 | 26999446.4 | 11265.714 | 4.41 | 5.14 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2071641.4 | 6088099.8 | 4602.000 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2062857.9 | 6088043.8 | 4125.250 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2060278.0 | 6088022.8 | 4041.875 | 1.09 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43570156.9 | 193466553.8 | 261818.500 | 23.14 | 4.44 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2071444.1 | 5875346.8 | 4830.625 | 1.10 | 2.84 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2705874.8 | 7144143.8 | 20911.375 | 1.44 | 2.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12126405.0 | 23590602.8 | 446391.625 | 6.44 | 1.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20709671.1 | 56837736.8 | 553521.000 | 11.00 | 2.74 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11321799.6 | 33662338.8 | 323582.625 | 6.01 | 2.97 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18821978.6 | 76318992.3 | 252504.375 | 10.00 | 4.05 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113500.5 | 426376.7 | 5.129 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113654.6 | 426318.7 | 2.452 | 0.22 | 3.75 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113689.1 | 426295.7 | 1.452 | 0.22 | 3.75 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 638772.6 | 3146479.7 | 6.613 | 1.22 | 4.93 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113315.8 | 426343.7 | 1.613 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1253120.2 | 3866916.7 | 5.516 | 2.39 | 3.09 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1675446.9 | 5833341.7 | 5.419 | 3.20 | 3.48 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3546144.6 | 13108830.7 | 72884.516 | 6.76 | 3.70 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1833831.5 | 7405810.7 | 3.581 | 3.50 | 4.04 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2384183.2 | 12748176.8 | 15.323 | 4.55 | 5.35 |
