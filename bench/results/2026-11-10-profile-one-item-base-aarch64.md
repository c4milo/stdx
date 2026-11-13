# bench-profile

| Field | Value |
|---|---|
| Commit | 8eefa96 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261101.172.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/42920501977 |
| Date | 2026-11-10 |

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
| silesia/dickens | 10192446 | zlib | 7.97 | 15.77 | 1.98 | 300.24 |
| silesia/dickens | 10192446 | zlib-ng | 4.90 | 10.50 | 2.14 | 67.77 |
| silesia/dickens | 10192446 | libdeflate | 3.49 | 9.56 | 2.74 | 65.94 |
| silesia/dickens | 10192446 | Wuffs | 4.91 | 10.85 | 2.21 | 97.67 |
| silesia/dickens | 10192446 | stdx | 3.01 | 7.15 | 2.37 | 75.98 |
| silesia/mozilla | 51220480 | zlib | 7.79 | 14.13 | 1.82 | 243.45 |
| silesia/mozilla | 51220480 | zlib-ng | 4.97 | 8.95 | 1.80 | 85.40 |
| silesia/mozilla | 51220480 | libdeflate | 3.50 | 7.63 | 2.18 | 71.03 |
| silesia/mozilla | 51220480 | Wuffs | 5.74 | 10.84 | 1.89 | 132.80 |
| silesia/mozilla | 51220480 | stdx | 3.67 | 6.29 | 1.71 | 89.04 |
| silesia/mr | 9970564 | zlib | 7.76 | 15.26 | 1.97 | 198.91 |
| silesia/mr | 9970564 | zlib-ng | 4.82 | 9.98 | 2.07 | 68.04 |
| silesia/mr | 9970564 | libdeflate | 3.39 | 8.58 | 2.53 | 61.18 |
| silesia/mr | 9970564 | Wuffs | 5.30 | 10.93 | 2.06 | 101.01 |
| silesia/mr | 9970564 | stdx | 3.19 | 6.70 | 2.10 | 69.51 |
| silesia/nci | 33553445 | zlib | 2.97 | 7.25 | 2.44 | 80.26 |
| silesia/nci | 33553445 | zlib-ng | 1.66 | 3.13 | 1.89 | 33.56 |
| silesia/nci | 33553445 | libdeflate | 1.18 | 2.66 | 2.24 | 27.67 |
| silesia/nci | 33553445 | Wuffs | 1.75 | 3.38 | 1.93 | 42.52 |
| silesia/nci | 33553445 | stdx | 1.31 | 2.20 | 1.69 | 37.19 |
| silesia/ooffice | 6152192 | zlib | 11.07 | 17.83 | 1.61 | 402.23 |
| silesia/ooffice | 6152192 | zlib-ng | 6.92 | 12.04 | 1.74 | 139.66 |
| silesia/ooffice | 6152192 | libdeflate | 4.90 | 10.45 | 2.13 | 124.84 |
| silesia/ooffice | 6152192 | Wuffs | 8.15 | 14.47 | 1.78 | 221.79 |
| silesia/ooffice | 6152192 | stdx | 5.15 | 8.55 | 1.66 | 150.93 |
| silesia/osdb | 10085684 | zlib | 6.90 | 13.54 | 1.96 | 172.84 |
| silesia/osdb | 10085684 | zlib-ng | 4.32 | 8.38 | 1.94 | 52.88 |
| silesia/osdb | 10085684 | libdeflate | 2.87 | 6.91 | 2.40 | 29.86 |
| silesia/osdb | 10085684 | Wuffs | 5.19 | 10.56 | 2.03 | 82.44 |
| silesia/osdb | 10085684 | stdx | 2.88 | 5.65 | 1.97 | 41.15 |
| silesia/reymont | 6627202 | zlib | 6.66 | 12.73 | 1.91 | 254.33 |
| silesia/reymont | 6627202 | zlib-ng | 3.73 | 7.72 | 2.07 | 59.80 |
| silesia/reymont | 6627202 | libdeflate | 2.62 | 6.91 | 2.63 | 50.99 |
| silesia/reymont | 6627202 | Wuffs | 4.25 | 8.40 | 1.98 | 112.63 |
| silesia/reymont | 6627202 | stdx | 2.30 | 5.11 | 2.22 | 64.65 |
| silesia/samba | 21606400 | zlib | 5.62 | 11.09 | 1.97 | 170.60 |
| silesia/samba | 21606400 | zlib-ng | 3.40 | 6.47 | 1.90 | 55.80 |
| silesia/samba | 21606400 | libdeflate | 2.39 | 5.58 | 2.33 | 42.95 |
| silesia/samba | 21606400 | Wuffs | 3.70 | 7.33 | 1.98 | 81.11 |
| silesia/samba | 21606400 | stdx | 2.38 | 4.46 | 1.87 | 56.17 |
| silesia/sao | 7251944 | zlib | 9.92 | 20.36 | 2.05 | 196.83 |
| silesia/sao | 7251944 | zlib-ng | 7.87 | 14.83 | 1.88 | 79.26 |
| silesia/sao | 7251944 | libdeflate | 5.75 | 12.73 | 2.21 | 79.11 |
| silesia/sao | 7251944 | Wuffs | 8.16 | 18.14 | 2.22 | 85.90 |
| silesia/sao | 7251944 | stdx | 5.65 | 10.32 | 1.83 | 87.31 |
| silesia/webster | 41458703 | zlib | 7.02 | 12.99 | 1.85 | 273.84 |
| silesia/webster | 41458703 | zlib-ng | 4.24 | 8.04 | 1.90 | 84.89 |
| silesia/webster | 41458703 | libdeflate | 2.95 | 7.17 | 2.43 | 68.43 |
| silesia/webster | 41458703 | Wuffs | 4.52 | 8.62 | 1.91 | 123.25 |
| silesia/webster | 41458703 | stdx | 2.86 | 5.56 | 1.95 | 87.13 |
| silesia/x-ray | 8474240 | zlib | 12.30 | 23.82 | 1.94 | 324.62 |
| silesia/x-ray | 8474240 | zlib-ng | 9.06 | 17.39 | 1.92 | 124.30 |
| silesia/x-ray | 8474240 | libdeflate | 6.55 | 15.26 | 2.33 | 124.60 |
| silesia/x-ray | 8474240 | Wuffs | 10.13 | 20.40 | 2.01 | 192.70 |
| silesia/x-ray | 8474240 | stdx | 6.20 | 11.49 | 1.85 | 137.20 |
| silesia/xml | 5345280 | zlib | 3.64 | 8.20 | 2.26 | 116.20 |
| silesia/xml | 5345280 | zlib-ng | 1.99 | 3.88 | 1.95 | 42.57 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 31.57 |
| silesia/xml | 5345280 | Wuffs | 2.20 | 4.14 | 1.88 | 61.00 |
| silesia/xml | 5345280 | stdx | 1.34 | 2.65 | 1.99 | 41.76 |
| canterbury/alice29.txt | 152089 | zlib | 7.61 | 15.08 | 1.98 | 286.71 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.51 | 9.91 | 2.20 | 59.92 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.19 | 8.96 | 2.81 | 55.25 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.70 | 10.37 | 2.21 | 98.19 |
| canterbury/alice29.txt | 152089 | stdx | 2.70 | 6.99 | 2.59 | 61.95 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.13 | 16.11 | 1.98 | 302.41 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 72.81 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.61 | 9.82 | 2.72 | 69.54 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.08 | 11.34 | 2.23 | 99.70 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.04 | 7.52 | 2.47 | 76.65 |
| canterbury/cp.html | 24603 | zlib | 6.48 | 14.20 | 2.19 | 170.83 |
| canterbury/cp.html | 24603 | zlib-ng | 4.17 | 9.50 | 2.28 | 35.51 |
| canterbury/cp.html | 24603 | libdeflate | 2.84 | 7.95 | 2.80 | 14.81 |
| canterbury/cp.html | 24603 | Wuffs | 4.45 | 10.87 | 2.44 | 54.49 |
| canterbury/cp.html | 24603 | stdx | 2.65 | 7.19 | 2.71 | 13.14 |
| canterbury/fields.c | 11150 | zlib | 4.65 | 14.65 | 3.15 | 39.07 |
| canterbury/fields.c | 11150 | zlib-ng | 3.87 | 10.20 | 2.64 | 13.43 |
| canterbury/fields.c | 11150 | libdeflate | 2.81 | 8.32 | 2.96 | 2.53 |
| canterbury/fields.c | 11150 | Wuffs | 3.82 | 11.51 | 3.02 | 8.90 |
| canterbury/fields.c | 11150 | stdx | 2.50 | 7.64 | 3.06 | 4.14 |
| canterbury/grammar.lsp | 3721 | zlib | 6.21 | 21.22 | 3.41 | 2.01 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.84 | 17.48 | 2.99 | 7.58 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.46 | 12.05 | 2.70 | 2.75 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.96 | 18.87 | 3.17 | 3.81 |
| canterbury/grammar.lsp | 3721 | stdx | 3.86 | 12.18 | 3.16 | 1.97 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.96 | 12.20 | 3.08 | 48.99 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.85 | 6.97 | 2.45 | 12.49 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.31 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.20 | 8.67 | 2.71 | 14.77 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.66 | 2.66 | 16.89 |
| canterbury/lcet10.txt | 426754 | zlib | 7.37 | 14.53 | 1.97 | 279.56 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.17 | 60.45 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.02 | 8.48 | 2.81 | 54.38 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.57 | 9.85 | 2.16 | 101.50 |
| canterbury/lcet10.txt | 426754 | stdx | 2.60 | 6.42 | 2.47 | 66.61 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.30 | 16.53 | 1.99 | 310.56 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.27 | 11.19 | 2.12 | 76.89 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.71 | 77.14 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.15 | 11.53 | 2.24 | 99.85 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.15 | 7.63 | 2.42 | 85.30 |
| canterbury/ptt5 | 513216 | zlib | 4.40 | 7.79 | 1.77 | 100.39 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.51 |
| canterbury/ptt5 | 513216 | libdeflate | 1.44 | 3.02 | 2.09 | 37.75 |
| canterbury/ptt5 | 513216 | Wuffs | 2.19 | 4.02 | 1.84 | 58.66 |
| canterbury/ptt5 | 513216 | stdx | 1.44 | 2.55 | 1.77 | 48.68 |
| canterbury/sum | 38240 | zlib | 7.29 | 14.98 | 2.06 | 215.18 |
| canterbury/sum | 38240 | zlib-ng | 4.64 | 10.02 | 2.16 | 56.53 |
| canterbury/sum | 38240 | libdeflate | 3.38 | 8.34 | 2.47 | 42.01 |
| canterbury/sum | 38240 | Wuffs | 5.01 | 11.41 | 2.28 | 77.27 |
| canterbury/sum | 38240 | stdx | 3.06 | 7.73 | 2.52 | 30.36 |
| canterbury/xargs.1 | 4227 | zlib | 6.70 | 22.08 | 3.30 | 8.66 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.39 | 17.97 | 2.81 | 9.12 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.76 | 13.27 | 2.79 | 0.73 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.50 | 19.63 | 3.02 | 9.48 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 12.86 | 3.03 | 2.59 |
| canterbury-large/E.coli | 4638690 | zlib | 5.94 | 14.55 | 2.45 | 174.80 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.25 | 9.68 | 2.28 | 47.31 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.92 | 48.39 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.00 | 9.64 | 2.41 | 61.34 |
| canterbury-large/E.coli | 4638690 | stdx | 2.48 | 6.72 | 2.70 | 53.71 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.94 | 13.26 | 1.91 | 259.81 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 4.01 | 8.26 | 2.06 | 53.71 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.83 | 7.45 | 2.63 | 45.39 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.41 | 8.72 | 1.98 | 100.86 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.56 | 5.57 | 2.17 | 55.83 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.97 | 12.69 | 1.82 | 272.56 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.14 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.00 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.53 | 8.44 | 1.86 | 129.88 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.73 | 5.40 | 1.98 | 90.59 |
| http/html-1kx1024 | 1048576 | zlib | 15.84 | 32.44 | 2.05 | 349.70 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.81 | 28.43 | 2.22 | 218.57 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.62 | 20.05 | 1.89 | 155.81 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.60 | 35.05 | 2.40 | 263.25 |
| http/html-1kx1024 | 1048576 | stdx | 8.41 | 20.88 | 2.48 | 137.55 |
| http/html-16kx64 | 1048576 | zlib | 6.02 | 11.79 | 1.96 | 215.17 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.87 | 7.54 | 1.95 | 85.75 |
| http/html-16kx64 | 1048576 | libdeflate | 2.64 | 6.04 | 2.29 | 60.48 |
| http/html-16kx64 | 1048576 | Wuffs | 4.26 | 8.51 | 2.00 | 116.78 |
| http/html-16kx64 | 1048576 | stdx | 2.52 | 5.56 | 2.21 | 59.26 |
| http/html-1m | 1048576 | zlib | 4.64 | 9.51 | 2.05 | 172.39 |
| http/html-1m | 1048576 | zlib-ng | 2.63 | 5.03 | 1.92 | 60.09 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.39 |
| http/html-1m | 1048576 | Wuffs | 2.96 | 5.42 | 1.83 | 90.31 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.11 | 52.74 |
| http/json-1kx1024 | 1048576 | zlib | 9.73 | 20.83 | 2.14 | 191.69 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.47 | 16.69 | 2.23 | 131.34 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.88 | 16.72 | 1.88 | 92.09 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.41 | 31.72 | 2.78 | 145.04 |
| http/json-1kx1024 | 1048576 | stdx | 5.05 | 13.12 | 2.60 | 81.15 |
| http/json-16kx64 | 1048576 | zlib | 3.96 | 9.62 | 2.43 | 101.98 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.10 | 50.68 |
| http/json-16kx64 | 1048576 | libdeflate | 1.91 | 4.24 | 2.22 | 39.65 |
| http/json-16kx64 | 1048576 | Wuffs | 2.81 | 6.35 | 2.26 | 58.36 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.25 | 39.75 |
| http/json-1m | 1048576 | zlib | 3.25 | 8.25 | 2.54 | 82.18 |
| http/json-1m | 1048576 | zlib-ng | 1.94 | 3.91 | 2.01 | 37.34 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.21 |
| http/json-1m | 1048576 | Wuffs | 2.05 | 4.29 | 2.10 | 44.48 |
| http/json-1m | 1048576 | stdx | 1.33 | 2.67 | 2.01 | 39.56 |
| http/js-1kx1024 | 1048576 | zlib | 17.31 | 35.33 | 2.04 | 401.34 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.88 | 31.25 | 2.25 | 240.52 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.29 | 21.58 | 1.91 | 178.94 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.76 | 37.71 | 2.39 | 295.91 |
| http/js-1kx1024 | 1048576 | stdx | 9.30 | 22.85 | 2.46 | 159.52 |
| http/js-16kx64 | 1048576 | zlib | 6.93 | 13.06 | 1.88 | 255.99 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.39 | 8.65 | 1.97 | 91.84 |
| http/js-16kx64 | 1048576 | libdeflate | 3.06 | 7.01 | 2.29 | 72.02 |
| http/js-16kx64 | 1048576 | Wuffs | 4.84 | 9.70 | 2.00 | 130.46 |
| http/js-16kx64 | 1048576 | stdx | 3.02 | 6.54 | 2.17 | 72.58 |
| http/js-1m | 1048576 | zlib | 5.16 | 10.26 | 1.99 | 195.84 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 60.20 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.86 |
| http/js-1m | 1048576 | Wuffs | 3.26 | 6.10 | 1.87 | 96.06 |
| http/js-1m | 1048576 | stdx | 1.82 | 3.89 | 2.14 | 55.62 |
| http/css-1kx1024 | 1048576 | zlib | 13.17 | 27.18 | 2.06 | 281.04 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.36 | 23.04 | 2.22 | 172.36 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.20 | 17.37 | 1.89 | 121.24 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.06 | 29.48 | 2.44 | 210.07 |
| http/css-1kx1024 | 1048576 | stdx | 6.70 | 17.64 | 2.63 | 101.05 |
| http/css-16kx64 | 1048576 | zlib | 4.67 | 10.12 | 2.17 | 151.41 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.18 | 49.89 |
| http/css-16kx64 | 1048576 | libdeflate | 1.87 | 4.69 | 2.50 | 28.32 |
| http/css-16kx64 | 1048576 | Wuffs | 3.12 | 6.97 | 2.24 | 70.18 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.54 | 28.15 |
| http/css-1m | 1048576 | zlib | 3.38 | 8.00 | 2.37 | 107.54 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.22 | 28.65 |
| http/css-1m | 1048576 | libdeflate | 1.05 | 3.18 | 3.04 | 10.46 |
| http/css-1m | 1048576 | Wuffs | 1.91 | 4.08 | 2.14 | 44.57 |
| http/css-1m | 1048576 | stdx | 1.02 | 2.56 | 2.52 | 21.21 |
| shuffled/dickens-1m | 1048576 | zlib | 12.74 | 22.42 | 1.76 | 372.31 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.72 | 16.72 | 1.72 | 195.84 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.03 | 14.95 | 2.13 | 194.48 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.67 | 18.95 | 1.96 | 205.46 |
| shuffled/dickens-1m | 1048576 | stdx | 7.06 | 11.89 | 1.68 | 208.50 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.64 | 14.04 | 3.86 | 3.53 |
| silesia/dickens | 10192446 | stdx | 3.81 | 12.47 | 3.27 | 3.58 |
| silesia/mozilla | 51220480 | libzstd | 2.88 | 9.62 | 3.34 | 30.05 |
| silesia/mozilla | 51220480 | stdx | 2.90 | 9.68 | 3.34 | 15.58 |
| silesia/mr | 9970564 | libzstd | 3.16 | 11.98 | 3.79 | 6.23 |
| silesia/mr | 9970564 | stdx | 3.18 | 10.83 | 3.40 | 5.33 |
| silesia/nci | 33553445 | libzstd | 1.72 | 4.84 | 2.82 | 23.49 |
| silesia/nci | 33553445 | stdx | 1.91 | 4.63 | 2.42 | 13.53 |
| silesia/ooffice | 6152192 | libzstd | 3.46 | 12.14 | 3.51 | 31.14 |
| silesia/ooffice | 6152192 | stdx | 3.40 | 12.40 | 3.65 | 12.18 |
| silesia/osdb | 10085684 | libzstd | 2.41 | 8.44 | 3.51 | 15.21 |
| silesia/osdb | 10085684 | stdx | 2.48 | 8.11 | 3.26 | 15.46 |
| silesia/reymont | 6627202 | libzstd | 3.31 | 11.61 | 3.51 | 11.63 |
| silesia/reymont | 6627202 | stdx | 3.49 | 10.36 | 2.97 | 12.74 |
| silesia/samba | 21606400 | libzstd | 2.16 | 7.39 | 3.42 | 18.71 |
| silesia/samba | 21606400 | stdx | 2.27 | 6.83 | 3.01 | 17.61 |
| silesia/sao | 7251944 | libzstd | 3.88 | 12.69 | 3.27 | 26.56 |
| silesia/sao | 7251944 | stdx | 3.58 | 12.58 | 3.51 | 6.25 |
| silesia/webster | 41458703 | libzstd | 3.37 | 11.22 | 3.33 | 16.29 |
| silesia/webster | 41458703 | stdx | 3.58 | 10.05 | 2.81 | 17.88 |
| silesia/x-ray | 8474240 | libzstd | 4.00 | 14.93 | 3.74 | 18.80 |
| silesia/x-ray | 8474240 | stdx | 3.65 | 13.23 | 3.63 | 8.48 |
| silesia/xml | 5345280 | libzstd | 1.55 | 5.55 | 3.58 | 22.85 |
| silesia/xml | 5345280 | stdx | 1.54 | 5.16 | 3.35 | 16.94 |
| canterbury/alice29.txt | 152089 | libzstd | 3.36 | 16.18 | 4.82 | 4.15 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.36 | 0.52 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.00 | 14.25 | 4.75 | 3.31 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.30 | 0.23 |
| canterbury/cp.html | 24603 | libzstd | 2.66 | 10.74 | 4.03 | 9.06 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.10 | 0.19 |
| canterbury/fields.c | 11150 | libzstd | 3.13 | 13.61 | 4.35 | 9.54 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.23 | 0.20 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.22 | 16.93 | 4.01 | 5.63 |
| canterbury/grammar.lsp | 3721 | stdx | 4.22 | 16.54 | 3.92 | 0.27 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.49 | 11.22 | 4.50 | 7.68 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.68 | 11.32 | 4.23 | 0.82 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.74 | 12.87 | 4.71 | 5.30 |
| canterbury/lcet10.txt | 426754 | stdx | 2.72 | 11.52 | 4.24 | 2.66 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.16 | 15.14 | 4.79 | 1.58 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.27 | 0.98 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.50 | 3.11 | 24.34 |
| canterbury/ptt5 | 513216 | stdx | 1.34 | 4.46 | 3.32 | 13.28 |
| canterbury/sum | 38240 | libzstd | 2.65 | 10.51 | 3.97 | 10.65 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.09 | 0.42 |
| canterbury/xargs.1 | 4227 | libzstd | 4.29 | 17.40 | 4.06 | 9.93 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.17 | 4.05 | 0.26 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.04 | 13.63 | 4.49 | 2.14 |
| canterbury-large/E.coli | 4638690 | stdx | 3.14 | 12.04 | 3.83 | 2.88 |
| canterbury-large/bible.txt | 4047392 | libzstd | 3.02 | 11.99 | 3.97 | 8.52 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.12 | 10.64 | 3.40 | 9.26 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.57 | 9.59 | 3.74 | 19.83 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.67 | 8.64 | 3.23 | 21.33 |
| http/html-1kx1024 | 1048576 | libzstd | 7.40 | 21.63 | 2.92 | 62.67 |
| http/html-1kx1024 | 1048576 | stdx | 7.47 | 22.46 | 3.01 | 76.06 |
| http/html-16kx64 | 1048576 | libzstd | 2.67 | 10.15 | 3.80 | 28.78 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.60 | 30.60 |
| http/html-1m | 1048576 | libzstd | 2.00 | 7.86 | 3.93 | 24.24 |
| http/html-1m | 1048576 | stdx | 2.01 | 7.12 | 3.55 | 24.81 |
| http/json-1kx1024 | 1048576 | libzstd | 6.39 | 17.37 | 2.72 | 49.22 |
| http/json-1kx1024 | 1048576 | stdx | 6.22 | 17.86 | 2.87 | 53.42 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.22 | 3.52 | 27.90 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.58 | 19.95 |
| http/json-1m | 1048576 | libzstd | 1.72 | 6.04 | 3.51 | 27.46 |
| http/json-1m | 1048576 | stdx | 1.64 | 5.91 | 3.60 | 14.41 |
| http/js-1kx1024 | 1048576 | libzstd | 8.45 | 26.38 | 3.12 | 72.69 |
| http/js-1kx1024 | 1048576 | stdx | 9.05 | 27.60 | 3.05 | 113.40 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.71 | 4.00 | 24.36 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.73 | 26.54 |
| http/js-1m | 1048576 | libzstd | 2.02 | 8.18 | 4.04 | 20.21 |
| http/js-1m | 1048576 | stdx | 2.08 | 7.48 | 3.59 | 21.35 |
| http/css-1kx1024 | 1048576 | libzstd | 7.04 | 19.70 | 2.80 | 53.81 |
| http/css-1kx1024 | 1048576 | stdx | 6.86 | 19.96 | 2.91 | 63.36 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.69 | 3.88 | 23.37 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.15 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.57 | 3.85 | 5.53 |
| http/css-1m | 1048576 | stdx | 0.72 | 2.49 | 3.47 | 4.06 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.81 | 9.40 | 3.35 | 28.63 |
| shuffled/dickens-1m | 1048576 | stdx | 2.75 | 9.19 | 3.35 | 12.75 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.64 | 17.04 | 2.23 | 100.95 |
| silesia/dickens | 1048576 | stdx | 5.12 | 12.38 | 2.42 | 54.63 |
| silesia/mozilla | 1048576 | Google | 14.66 | 27.77 | 1.89 | 46.71 |
| silesia/mozilla | 1048576 | stdx | 8.34 | 15.02 | 1.80 | 47.00 |
| silesia/mr | 1048576 | Google | 9.03 | 20.24 | 2.24 | 102.40 |
| silesia/mr | 1048576 | stdx | 5.83 | 13.25 | 2.27 | 88.61 |
| silesia/nci | 1048576 | Google | 2.60 | 5.69 | 2.19 | 51.99 |
| silesia/nci | 1048576 | stdx | 1.95 | 3.95 | 2.02 | 55.01 |
| silesia/ooffice | 1048576 | Google | 14.33 | 29.28 | 2.04 | 288.18 |
| silesia/ooffice | 1048576 | stdx | 10.92 | 20.33 | 1.86 | 323.37 |
| silesia/osdb | 1048576 | Google | 8.35 | 17.38 | 2.08 | 96.06 |
| silesia/osdb | 1048576 | stdx | 5.18 | 10.57 | 2.04 | 92.03 |
| silesia/reymont | 1048576 | Google | 5.54 | 12.73 | 2.30 | 81.90 |
| silesia/reymont | 1048576 | stdx | 3.75 | 9.25 | 2.47 | 47.83 |
| silesia/samba | 1048576 | Google | 7.62 | 16.22 | 2.13 | 95.59 |
| silesia/samba | 1048576 | stdx | 5.07 | 10.71 | 2.11 | 67.46 |
| silesia/sao | 1048576 | Google | 16.99 | 36.97 | 2.18 | 161.84 |
| silesia/sao | 1048576 | stdx | 10.44 | 22.65 | 2.17 | 143.57 |
| silesia/webster | 1048576 | Google | 6.65 | 14.07 | 2.12 | 115.13 |
| silesia/webster | 1048576 | stdx | 4.41 | 9.98 | 2.26 | 68.88 |
| silesia/x-ray | 1048576 | Google | 19.71 | 38.46 | 1.95 | 234.12 |
| silesia/x-ray | 1048576 | stdx | 14.78 | 30.18 | 2.04 | 235.52 |
| silesia/xml | 1048576 | Google | 3.49 | 7.65 | 2.19 | 65.44 |
| silesia/xml | 1048576 | stdx | 2.44 | 5.40 | 2.21 | 47.12 |
| canterbury/alice29.txt | 152089 | Google | 8.89 | 20.66 | 2.32 | 135.28 |
| canterbury/alice29.txt | 152089 | stdx | 6.07 | 15.33 | 2.53 | 81.60 |
| canterbury/asyoulik.txt | 125179 | Google | 10.42 | 23.83 | 2.29 | 170.86 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.06 | 17.43 | 2.47 | 104.15 |
| canterbury/cp.html | 24603 | Google | 9.17 | 22.18 | 2.42 | 111.48 |
| canterbury/cp.html | 24603 | stdx | 5.74 | 17.15 | 2.99 | 33.28 |
| canterbury/fields.c | 11150 | Google | 7.11 | 21.25 | 2.99 | 24.13 |
| canterbury/fields.c | 11150 | stdx | 4.87 | 17.08 | 3.50 | 2.41 |
| canterbury/grammar.lsp | 3721 | Google | 9.89 | 30.23 | 3.06 | 7.63 |
| canterbury/grammar.lsp | 3721 | stdx | 7.17 | 25.04 | 3.49 | 0.90 |
| canterbury/kennedy.xls | 1029744 | Google | 5.50 | 17.05 | 3.10 | 37.18 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.81 | 12.94 | 3.39 | 34.05 |
| canterbury/lcet10.txt | 426754 | Google | 7.77 | 17.42 | 2.24 | 129.88 |
| canterbury/lcet10.txt | 426754 | stdx | 5.19 | 12.96 | 2.50 | 66.44 |
| canterbury/plrabn12.txt | 481861 | Google | 9.13 | 20.94 | 2.29 | 133.66 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.15 | 15.04 | 2.44 | 87.04 |
| canterbury/ptt5 | 513216 | Google | 4.31 | 10.36 | 2.41 | 62.53 |
| canterbury/ptt5 | 513216 | stdx | 2.39 | 4.89 | 2.05 | 67.50 |
| canterbury/sum | 38240 | Google | 10.84 | 26.44 | 2.44 | 157.53 |
| canterbury/sum | 38240 | stdx | 8.24 | 21.11 | 2.56 | 150.47 |
| canterbury/xargs.1 | 4227 | Google | 11.02 | 34.81 | 3.16 | 11.67 |
| canterbury/xargs.1 | 4227 | stdx | 8.45 | 30.44 | 3.60 | 6.46 |
| canterbury-large/E.coli | 1048576 | Google | 7.49 | 19.44 | 2.60 | 1.40 |
| canterbury-large/E.coli | 1048576 | stdx | 6.72 | 13.48 | 2.00 | 1.76 |
| canterbury-large/bible.txt | 1048576 | Google | 5.42 | 12.38 | 2.28 | 80.58 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.56 | 8.93 | 2.51 | 39.88 |
| canterbury-large/world192.txt | 1048576 | Google | 6.31 | 12.88 | 2.04 | 115.43 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.43 | 9.38 | 2.12 | 77.86 |
| http/html-1kx1024 | 1048576 | Google | 17.94 | 42.09 | 2.35 | 387.48 |
| http/html-1kx1024 | 1048576 | stdx | 15.25 | 37.56 | 2.46 | 360.68 |
| http/html-16kx64 | 1048576 | Google | 6.77 | 14.88 | 2.20 | 149.72 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 115.04 |
| http/html-1m | 1048576 | Google | 4.10 | 8.99 | 2.19 | 83.52 |
| http/html-1m | 1048576 | stdx | 2.88 | 6.52 | 2.27 | 54.81 |
| http/json-1kx1024 | 1048576 | Google | 14.28 | 36.74 | 2.57 | 239.13 |
| http/json-1kx1024 | 1048576 | stdx | 12.98 | 33.63 | 2.59 | 277.38 |
| http/json-16kx64 | 1048576 | Google | 4.41 | 11.42 | 2.59 | 80.86 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.38 |
| http/json-1m | 1048576 | Google | 3.43 | 8.66 | 2.53 | 58.75 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.43 | 57.61 |
| http/js-1kx1024 | 1048576 | Google | 19.87 | 46.38 | 2.33 | 427.39 |
| http/js-1kx1024 | 1048576 | stdx | 16.35 | 39.90 | 2.44 | 380.63 |
| http/js-16kx64 | 1048576 | Google | 8.07 | 17.79 | 2.20 | 167.55 |
| http/js-16kx64 | 1048576 | stdx | 6.04 | 14.36 | 2.38 | 126.74 |
| http/js-1m | 1048576 | Google | 4.42 | 9.60 | 2.17 | 83.21 |
| http/js-1m | 1048576 | stdx | 3.18 | 7.25 | 2.28 | 55.62 |
| http/css-1kx1024 | 1048576 | Google | 15.35 | 37.48 | 2.44 | 292.67 |
| http/css-1kx1024 | 1048576 | stdx | 13.80 | 34.70 | 2.51 | 302.89 |
| http/css-16kx64 | 1048576 | Google | 4.97 | 11.78 | 2.37 | 100.84 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.82 |
| http/css-1m | 1048576 | Google | 2.45 | 9.43 | 3.85 | 16.85 |
| http/css-1m | 1048576 | stdx | 0.76 | 1.86 | 2.44 | 12.03 |
| shuffled/dickens-1m | 1048576 | Google | 9.70 | 20.34 | 2.10 | 109.95 |
| shuffled/dickens-1m | 1048576 | stdx | 8.84 | 14.53 | 1.64 | 122.86 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.28 | 36.91 | 2.42 | 411.06 |
| silesia/dickens | 10192446 | 1 | stdx | 16.42 | 38.17 | 2.33 | 359.07 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.10 | 87.63 | 1.68 | 693.96 |
| silesia/dickens | 10192446 | 6 | stdx | 49.63 | 84.25 | 1.70 | 1451.21 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.85 | 160.47 | 1.43 | 931.45 |
| silesia/dickens | 10192446 | 9 | stdx | 64.89 | 150.06 | 2.31 | 1399.54 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.12 | 32.62 | 2.31 | 436.72 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.35 | 30.24 | 2.27 | 294.65 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.89 | 70.83 | 2.15 | 578.61 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.54 | 69.96 | 2.22 | 736.53 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.70 | 221.49 | 1.73 | 771.24 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.59 | 125.42 | 2.58 | 780.40 |
| silesia/mr | 9970564 | 1 | libdeflate | 12.01 | 35.02 | 2.92 | 229.61 |
| silesia/mr | 9970564 | 1 | stdx | 12.62 | 34.08 | 2.70 | 187.06 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.34 | 80.54 | 2.10 | 437.93 |
| silesia/mr | 9970564 | 6 | stdx | 39.99 | 83.18 | 2.08 | 992.92 |
| silesia/mr | 9970564 | 9 | libdeflate | 98.06 | 165.48 | 1.69 | 751.10 |
| silesia/mr | 9970564 | 9 | stdx | 78.89 | 184.93 | 2.34 | 1219.40 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.23 | 18.42 | 2.96 | 114.05 |
| silesia/nci | 33553445 | 1 | stdx | 4.96 | 10.88 | 2.19 | 97.50 |
| silesia/nci | 33553445 | 6 | libdeflate | 17.01 | 34.84 | 2.05 | 225.95 |
| silesia/nci | 33553445 | 6 | stdx | 14.47 | 29.54 | 2.04 | 400.14 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.48 | 105.28 | 1.68 | 501.83 |
| silesia/nci | 33553445 | 9 | stdx | 28.31 | 69.01 | 2.44 | 559.40 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.97 | 39.15 | 1.96 | 753.33 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.78 | 39.08 | 2.20 | 430.00 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 41.08 | 79.10 | 1.93 | 954.73 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.60 | 87.83 | 2.11 | 1005.41 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.62 | 127.63 | 1.71 | 1131.49 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.11 | 129.03 | 2.48 | 928.22 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.91 | 30.15 | 2.34 | 352.76 |
| silesia/osdb | 10085684 | 1 | stdx | 12.95 | 27.86 | 2.15 | 293.57 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.40 | 55.67 | 1.96 | 492.80 |
| silesia/osdb | 10085684 | 6 | stdx | 27.25 | 57.39 | 2.11 | 584.45 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.95 | 64.15 | 1.89 | 554.81 |
| silesia/osdb | 10085684 | 9 | stdx | 35.30 | 87.16 | 2.47 | 686.26 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.62 | 32.88 | 2.60 | 310.59 |
| silesia/reymont | 6627202 | 1 | stdx | 13.50 | 33.24 | 2.46 | 271.09 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.14 | 86.58 | 1.80 | 519.85 |
| silesia/reymont | 6627202 | 6 | stdx | 45.37 | 76.81 | 1.69 | 1438.04 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.39 | 276.14 | 1.39 | 840.05 |
| silesia/reymont | 6627202 | 9 | stdx | 74.23 | 160.03 | 2.16 | 1437.21 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.46 | 26.53 | 2.54 | 271.47 |
| silesia/samba | 21606400 | 1 | stdx | 9.90 | 22.23 | 2.24 | 220.96 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.98 | 58.79 | 2.03 | 384.50 |
| silesia/samba | 21606400 | 6 | stdx | 24.18 | 49.83 | 2.06 | 629.67 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.23 | 141.44 | 1.68 | 504.78 |
| silesia/samba | 21606400 | 9 | stdx | 36.14 | 90.81 | 2.51 | 644.28 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.71 | 47.87 | 2.20 | 682.42 |
| silesia/sao | 7251944 | 1 | stdx | 19.14 | 49.92 | 2.61 | 345.81 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.18 | 96.89 | 1.89 | 961.33 |
| silesia/sao | 7251944 | 6 | stdx | 47.08 | 105.66 | 2.24 | 854.01 |
| silesia/sao | 7251944 | 9 | libdeflate | 71.00 | 120.26 | 1.69 | 1107.28 |
| silesia/sao | 7251944 | 9 | stdx | 55.05 | 137.71 | 2.50 | 834.40 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.13 | 30.45 | 2.32 | 385.95 |
| silesia/webster | 41458703 | 1 | stdx | 13.86 | 29.08 | 2.10 | 340.14 |
| silesia/webster | 41458703 | 6 | libdeflate | 37.03 | 66.02 | 1.78 | 570.01 |
| silesia/webster | 41458703 | 6 | stdx | 35.31 | 60.87 | 1.72 | 1132.96 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.67 | 138.85 | 1.47 | 757.90 |
| silesia/webster | 41458703 | 9 | stdx | 48.43 | 110.73 | 2.29 | 1084.15 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.68 | 49.67 | 2.10 | 782.74 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.58 | 50.81 | 2.89 | 261.27 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.87 | 82.77 | 2.52 | 850.82 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.86 | 98.12 | 2.90 | 537.43 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.50 | 91.03 | 2.43 | 1026.59 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.47 | 121.58 | 3.00 | 466.70 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.81 | 21.59 | 2.77 | 175.41 |
| silesia/xml | 5345280 | 1 | stdx | 7.01 | 15.66 | 2.23 | 155.16 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.25 | 40.51 | 1.91 | 264.94 |
| silesia/xml | 5345280 | 6 | stdx | 17.76 | 34.32 | 1.93 | 500.84 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.74 | 89.17 | 1.52 | 372.62 |
| silesia/xml | 5345280 | 9 | stdx | 26.61 | 63.43 | 2.38 | 526.68 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.23 | 35.61 | 2.50 | 377.59 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.05 | 36.12 | 2.40 | 337.13 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.80 | 82.29 | 1.76 | 639.78 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.64 | 77.41 | 1.77 | 1311.49 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.68 | 159.21 | 1.48 | 850.42 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 58.28 | 138.20 | 2.37 | 1273.55 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.14 | 37.20 | 2.46 | 413.85 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.79 | 37.43 | 2.37 | 360.13 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.24 | 85.43 | 1.77 | 713.33 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.29 | 81.92 | 1.77 | 1399.41 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.84 | 136.15 | 1.53 | 938.47 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 60.14 | 144.56 | 2.40 | 1331.83 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.68 | 32.02 | 2.74 | 283.57 |
| canterbury/cp.html | 24603 | 1 | stdx | 11.05 | 27.13 | 2.46 | 248.85 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 26.98 | 62.33 | 2.31 | 488.14 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.58 | 57.05 | 2.42 | 614.83 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.92 | 91.97 | 1.96 | 596.91 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.26 | 88.88 | 2.84 | 643.45 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.73 | 35.92 | 3.69 | 76.03 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.05 | 30.05 | 3.73 | 21.70 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.20 | 69.37 | 2.87 | 224.93 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.81 | 57.62 | 2.77 | 431.67 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.47 | 100.81 | 2.27 | 419.10 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.29 | 92.65 | 3.28 | 440.55 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.07 | 51.51 | 3.94 | 16.80 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.85 | 39.01 | 3.96 | 1.61 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.82 | 87.06 | 3.66 | 29.64 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.19 | 70.80 | 4.12 | 19.19 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.74 | 102.89 | 3.35 | 39.14 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.72 | 99.30 | 4.19 | 54.23 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.38 | 27.18 | 3.68 | 65.33 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.05 | 22.58 | 3.20 | 63.28 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.89 | 73.85 | 2.65 | 95.98 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.33 | 61.98 | 3.21 | 138.43 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.22 | 664.23 | 1.83 | 162.71 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 30.30 | 107.06 | 3.53 | 144.13 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.77 | 33.99 | 2.47 | 369.20 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.47 | 33.92 | 2.34 | 329.94 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.05 | 78.22 | 1.74 | 606.89 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.99 | 73.42 | 1.75 | 1259.41 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.75 | 136.94 | 1.49 | 803.58 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 55.21 | 130.91 | 2.37 | 1198.87 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.81 | 38.62 | 2.44 | 425.73 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.77 | 40.24 | 2.40 | 370.86 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.14 | 91.90 | 1.70 | 752.35 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.89 | 88.89 | 1.71 | 1539.60 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.90 | 166.26 | 1.42 | 1002.93 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 67.84 | 158.18 | 2.33 | 1464.99 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.42 | 18.61 | 2.90 | 141.37 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.97 | 11.03 | 2.22 | 123.54 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.29 | 36.17 | 2.53 | 219.07 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.35 | 29.57 | 2.40 | 310.40 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.67 | 120.86 | 1.99 | 379.62 |
| canterbury/ptt5 | 513216 | 9 | stdx | 41.33 | 126.55 | 3.06 | 591.11 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.79 | 33.49 | 2.62 | 336.48 |
| canterbury/sum | 38240 | 1 | stdx | 12.65 | 29.36 | 2.32 | 301.55 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.55 | 69.87 | 2.45 | 493.72 |
| canterbury/sum | 38240 | 6 | stdx | 26.74 | 65.73 | 2.46 | 664.99 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.37 | 181.91 | 1.93 | 609.23 |
| canterbury/sum | 38240 | 9 | stdx | 39.24 | 112.32 | 2.86 | 659.68 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.46 | 53.06 | 3.94 | 32.27 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.76 | 43.10 | 4.01 | 2.03 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.97 | 87.70 | 3.82 | 68.68 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 17.89 | 74.35 | 4.16 | 39.07 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 24.92 | 94.34 | 3.79 | 90.81 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 25.73 | 106.95 | 4.16 | 96.19 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.12 | 40.47 | 3.34 | 164.11 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.72 | 42.29 | 3.32 | 100.89 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.34 | 395.99 | 2.16 | 263.49 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 123.03 | 374.12 | 3.04 | 1928.82 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.70 | 1063.49 | 1.30 | 1323.80 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 229.67 | 751.65 | 3.27 | 2431.92 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.57 | 32.38 | 2.58 | 312.58 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.42 | 32.23 | 2.40 | 282.17 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.11 | 80.12 | 1.74 | 523.26 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.34 | 72.38 | 1.71 | 1271.73 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.77 | 200.28 | 1.41 | 743.79 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 60.62 | 136.73 | 2.26 | 1226.26 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.33 | 29.72 | 2.23 | 413.63 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.24 | 28.55 | 2.00 | 377.84 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.14 | 60.25 | 1.82 | 557.38 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.21 | 56.80 | 1.76 | 994.59 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.76 | 119.11 | 1.47 | 686.79 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 41.77 | 97.56 | 2.34 | 975.87 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.49 | 103.92 | 2.93 | 457.47 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.49 | 58.63 | 2.73 | 364.54 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.27 | 138.33 | 2.99 | 564.65 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 33.00 | 94.30 | 2.86 | 527.59 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.72 | 142.44 | 2.98 | 586.94 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 37.14 | 112.10 | 3.02 | 538.62 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.46 | 27.96 | 2.67 | 267.01 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.03 | 20.25 | 2.24 | 233.83 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.36 | 52.09 | 2.33 | 390.46 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.97 | 42.86 | 2.26 | 548.75 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 34.98 | 72.54 | 2.07 | 463.55 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.74 | 69.05 | 2.79 | 551.15 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.78 | 23.03 | 2.62 | 224.45 |
| http/html-1m | 1048576 | 1 | stdx | 8.17 | 17.79 | 2.18 | 206.27 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.35 | 49.53 | 1.95 | 327.57 |
| http/html-1m | 1048576 | 6 | stdx | 21.29 | 40.70 | 1.91 | 630.11 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.16 | 109.24 | 1.54 | 432.32 |
| http/html-1m | 1048576 | 9 | stdx | 29.93 | 73.42 | 2.45 | 612.48 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.81 | 94.80 | 2.98 | 303.30 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.63 | 45.16 | 2.72 | 242.53 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.14 | 126.60 | 2.93 | 375.12 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.21 | 78.36 | 2.88 | 379.93 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.17 | 142.45 | 2.73 | 433.17 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.75 | 95.54 | 3.11 | 385.20 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.85 | 23.85 | 3.04 | 134.21 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.49 | 13.94 | 2.54 | 111.07 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.18 | 46.61 | 2.56 | 204.17 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.38 | 35.01 | 2.62 | 280.27 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.34 | 151.99 | 1.89 | 299.80 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.13 | 58.29 | 3.05 | 302.66 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.74 | 19.85 | 2.95 | 124.28 |
| http/json-1m | 1048576 | 1 | stdx | 5.08 | 12.51 | 2.46 | 103.49 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.34 | 45.30 | 2.23 | 175.47 |
| http/json-1m | 1048576 | 6 | stdx | 14.77 | 35.08 | 2.38 | 302.30 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.82 | 205.21 | 1.68 | 280.27 |
| http/json-1m | 1048576 | 9 | stdx | 27.36 | 69.14 | 2.53 | 336.36 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.07 | 107.80 | 2.91 | 520.03 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.81 | 65.40 | 2.75 | 410.45 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.44 | 144.85 | 2.93 | 678.66 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 36.61 | 104.11 | 2.84 | 619.08 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.69 | 150.13 | 2.90 | 714.86 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 41.31 | 125.11 | 3.03 | 625.73 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.72 | 30.90 | 2.64 | 308.35 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.84 | 24.80 | 2.29 | 272.86 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.86 | 59.43 | 2.30 | 469.46 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.73 | 50.04 | 2.20 | 680.19 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.87 | 83.31 | 2.04 | 564.21 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.50 | 81.30 | 2.76 | 662.58 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.63 | 25.19 | 2.62 | 246.70 |
| http/js-1m | 1048576 | 1 | stdx | 9.54 | 21.31 | 2.23 | 232.10 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.73 | 56.12 | 1.95 | 368.81 |
| http/js-1m | 1048576 | 6 | stdx | 24.95 | 46.64 | 1.87 | 751.69 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.34 | 120.65 | 1.58 | 501.24 |
| http/js-1m | 1048576 | 9 | stdx | 35.00 | 84.80 | 2.42 | 709.00 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.17 | 97.73 | 2.95 | 375.34 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.40 | 49.52 | 2.69 | 301.21 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.87 | 129.22 | 2.95 | 478.94 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.12 | 82.31 | 2.83 | 504.45 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.89 | 133.80 | 2.92 | 512.56 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.20 | 99.46 | 3.00 | 522.09 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.64 | 25.60 | 2.96 | 173.01 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.68 | 16.96 | 2.54 | 134.51 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.20 | 48.80 | 2.42 | 287.11 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.43 | 38.00 | 2.31 | 467.82 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.87 | 82.40 | 2.02 | 371.20 |
| http/css-16kx64 | 1048576 | 9 | stdx | 22.89 | 65.13 | 2.85 | 477.93 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.95 | 21.15 | 3.04 | 133.11 |
| http/css-1m | 1048576 | 1 | stdx | 5.78 | 14.91 | 2.58 | 107.69 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.79 | 44.50 | 2.14 | 226.70 |
| http/css-1m | 1048576 | 6 | stdx | 16.63 | 35.61 | 2.14 | 449.63 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.78 | 111.58 | 1.60 | 309.55 |
| http/css-1m | 1048576 | 9 | stdx | 28.06 | 72.54 | 2.58 | 473.03 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.24 | 48.89 | 1.94 | 930.38 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.12 | 49.19 | 2.72 | 323.55 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.65 | 86.45 | 2.08 | 1182.48 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.67 | 88.79 | 2.24 | 855.82 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.15 | 94.50 | 2.00 | 1346.46 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 53.48 | 133.83 | 2.50 | 1124.62 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.15 | 31.13 | 3.07 | 122.43 |
| silesia/dickens | 10192446 | 1 | stdx | 24.37 | 82.03 | 3.37 | 125.40 |
| silesia/dickens | 10192446 | 3 | libzstd | 24.62 | 35.01 | 1.42 | 172.74 |
| silesia/dickens | 10192446 | 3 | stdx | 37.72 | 78.22 | 2.07 | 183.07 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.02 | 22.57 | 3.21 | 72.28 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.67 | 54.73 | 3.10 | 172.99 |
| silesia/mozilla | 51220480 | 3 | libzstd | 18.72 | 28.71 | 1.53 | 102.85 |
| silesia/mozilla | 51220480 | 3 | stdx | 32.60 | 62.01 | 1.90 | 144.81 |
| silesia/mr | 9970564 | 1 | libzstd | 7.67 | 24.73 | 3.23 | 57.59 |
| silesia/mr | 9970564 | 1 | stdx | 19.97 | 66.82 | 3.35 | 113.46 |
| silesia/mr | 9970564 | 3 | libzstd | 21.95 | 32.97 | 1.50 | 86.81 |
| silesia/mr | 9970564 | 3 | stdx | 35.75 | 72.46 | 2.03 | 114.48 |
| silesia/nci | 33553445 | 1 | libzstd | 3.57 | 9.49 | 2.66 | 58.47 |
| silesia/nci | 33553445 | 1 | stdx | 7.74 | 25.69 | 3.32 | 59.07 |
| silesia/nci | 33553445 | 3 | libzstd | 5.79 | 10.11 | 1.75 | 57.27 |
| silesia/nci | 33553445 | 3 | stdx | 11.77 | 29.15 | 2.48 | 66.61 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.57 | 29.17 | 3.40 | 72.43 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.29 | 72.51 | 3.11 | 180.85 |
| silesia/ooffice | 6152192 | 3 | libzstd | 26.47 | 40.82 | 1.54 | 121.84 |
| silesia/ooffice | 6152192 | 3 | stdx | 44.83 | 82.20 | 1.83 | 185.00 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.12 | 22.22 | 3.12 | 67.05 |
| silesia/osdb | 10085684 | 1 | stdx | 16.45 | 50.52 | 3.07 | 119.44 |
| silesia/osdb | 10085684 | 3 | libzstd | 19.87 | 27.06 | 1.36 | 70.38 |
| silesia/osdb | 10085684 | 3 | stdx | 34.00 | 57.87 | 1.70 | 113.50 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.84 | 27.02 | 2.75 | 155.66 |
| silesia/reymont | 6627202 | 1 | stdx | 20.22 | 72.05 | 3.56 | 96.45 |
| silesia/reymont | 6627202 | 3 | libzstd | 19.72 | 27.53 | 1.40 | 127.73 |
| silesia/reymont | 6627202 | 3 | stdx | 29.51 | 62.18 | 2.11 | 147.53 |
| silesia/samba | 21606400 | 1 | libzstd | 5.99 | 16.80 | 2.81 | 88.23 |
| silesia/samba | 21606400 | 1 | stdx | 13.54 | 42.89 | 3.17 | 124.59 |
| silesia/samba | 21606400 | 3 | libzstd | 12.89 | 19.20 | 1.49 | 100.37 |
| silesia/samba | 21606400 | 3 | stdx | 21.46 | 44.75 | 2.08 | 132.88 |
| silesia/sao | 7251944 | 1 | libzstd | 9.04 | 33.64 | 3.72 | 43.61 |
| silesia/sao | 7251944 | 1 | stdx | 26.06 | 82.03 | 3.15 | 103.39 |
| silesia/sao | 7251944 | 3 | libzstd | 35.27 | 52.14 | 1.48 | 95.62 |
| silesia/sao | 7251944 | 3 | stdx | 55.12 | 95.22 | 1.73 | 142.40 |
| silesia/webster | 41458703 | 1 | libzstd | 8.74 | 24.86 | 2.85 | 135.81 |
| silesia/webster | 41458703 | 1 | stdx | 20.38 | 64.04 | 3.14 | 165.80 |
| silesia/webster | 41458703 | 3 | libzstd | 20.67 | 27.84 | 1.35 | 179.44 |
| silesia/webster | 41458703 | 3 | stdx | 32.72 | 64.55 | 1.97 | 195.31 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.72 | 14.89 | 3.15 | 17.06 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.83 | 76.64 | 3.22 | 92.28 |
| silesia/x-ray | 8474240 | 3 | libzstd | 36.07 | 54.96 | 1.52 | 87.16 |
| silesia/x-ray | 8474240 | 3 | stdx | 50.91 | 92.40 | 1.81 | 105.87 |
| silesia/xml | 5345280 | 1 | libzstd | 4.26 | 11.65 | 2.73 | 72.61 |
| silesia/xml | 5345280 | 1 | stdx | 10.45 | 34.21 | 3.27 | 94.33 |
| silesia/xml | 5345280 | 3 | libzstd | 7.19 | 12.84 | 1.79 | 79.37 |
| silesia/xml | 5345280 | 3 | stdx | 13.23 | 32.28 | 2.44 | 115.47 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.90 | 32.86 | 3.01 | 145.54 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.37 | 76.49 | 3.42 | 187.28 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 16.05 | 39.93 | 2.49 | 205.26 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.64 | 73.76 | 2.77 | 334.54 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.79 | 33.59 | 3.43 | 109.80 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.47 | 79.00 | 3.37 | 213.75 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.56 | 40.28 | 2.59 | 208.44 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.47 | 79.30 | 2.79 | 371.64 |
| canterbury/cp.html | 24603 | 1 | libzstd | 6.98 | 26.65 | 3.82 | 38.38 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.03 | 57.76 | 3.60 | 117.02 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.25 | 32.88 | 3.55 | 16.84 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.18 | 59.76 | 3.29 | 138.23 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.76 | 31.77 | 3.63 | 39.22 |
| canterbury/fields.c | 11150 | 1 | stdx | 16.94 | 65.73 | 3.88 | 83.83 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.04 | 34.41 | 3.81 | 10.36 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.23 | 64.68 | 3.75 | 88.50 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.56 | 37.98 | 3.97 | 11.51 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.21 | 77.57 | 3.84 | 50.84 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.58 | 43.28 | 4.09 | 1.73 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.37 | 79.60 | 3.72 | 67.64 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.03 | 23.37 | 3.87 | 14.67 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.75 | 56.75 | 3.85 | 82.88 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 9.06 | 24.26 | 2.68 | 27.55 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 21.47 | 56.61 | 2.64 | 108.02 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.90 | 28.42 | 2.87 | 160.67 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.44 | 72.02 | 3.36 | 160.57 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 17.62 | 32.77 | 1.86 | 202.27 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.95 | 67.10 | 2.49 | 295.46 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.36 | 32.28 | 3.12 | 130.12 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.17 | 84.16 | 3.34 | 158.41 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 22.01 | 39.60 | 1.80 | 227.12 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 32.92 | 80.77 | 2.45 | 342.47 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.15 | 8.48 | 2.69 | 67.50 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.53 | 23.15 | 3.07 | 104.28 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 5.36 | 11.28 | 2.10 | 59.74 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.83 | 24.08 | 2.45 | 132.34 |
| canterbury/sum | 38240 | 1 | libzstd | 6.50 | 25.37 | 3.90 | 30.01 |
| canterbury/sum | 38240 | 1 | stdx | 16.81 | 59.13 | 3.52 | 146.99 |
| canterbury/sum | 38240 | 3 | libzstd | 8.88 | 31.64 | 3.56 | 26.57 |
| canterbury/sum | 38240 | 3 | stdx | 19.93 | 61.82 | 3.10 | 179.20 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 9.97 | 39.84 | 3.99 | 9.62 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.80 | 80.38 | 3.86 | 56.53 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.05 | 48.45 | 4.02 | 1.50 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.83 | 83.98 | 3.68 | 78.52 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.51 | 33.29 | 3.17 | 75.76 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.85 | 95.62 | 4.38 | 7.23 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 16.16 | 31.71 | 1.96 | 36.01 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 24.47 | 70.38 | 2.88 | 38.32 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.85 | 27.35 | 2.78 | 154.09 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.51 | 71.86 | 3.50 | 108.15 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 19.57 | 28.64 | 1.46 | 134.67 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 29.38 | 63.36 | 2.16 | 155.63 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.22 | 22.62 | 2.75 | 140.25 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.75 | 55.86 | 2.98 | 192.36 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 16.80 | 24.36 | 1.45 | 177.04 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 26.41 | 51.26 | 1.94 | 237.52 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.12 | 52.52 | 3.07 | 168.07 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 36.01 | 100.54 | 2.79 | 635.07 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.21 | 59.34 | 3.09 | 205.85 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 38.02 | 104.00 | 2.74 | 631.15 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.86 | 22.47 | 2.86 | 127.77 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.19 | 46.84 | 3.30 | 182.19 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.91 | 24.79 | 2.78 | 146.69 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.43 | 47.61 | 3.08 | 190.70 |
| http/html-1m | 1048576 | 1 | libzstd | 6.33 | 16.66 | 2.63 | 117.66 |
| http/html-1m | 1048576 | 1 | stdx | 13.01 | 42.00 | 3.23 | 134.27 |
| http/html-1m | 1048576 | 3 | libzstd | 10.03 | 18.50 | 1.84 | 126.42 |
| http/html-1m | 1048576 | 3 | stdx | 16.34 | 39.37 | 2.41 | 177.49 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.35 | 42.58 | 2.97 | 119.26 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.73 | 83.13 | 2.80 | 525.50 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.90 | 44.69 | 3.00 | 133.98 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 31.01 | 84.87 | 2.74 | 531.19 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.83 | 15.00 | 3.11 | 59.35 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.70 | 33.78 | 3.48 | 115.99 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.43 | 16.31 | 3.00 | 73.52 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.69 | 34.58 | 3.24 | 122.48 |
| http/json-1m | 1048576 | 1 | libzstd | 4.06 | 12.47 | 3.07 | 53.57 |
| http/json-1m | 1048576 | 1 | stdx | 9.04 | 30.70 | 3.40 | 85.15 |
| http/json-1m | 1048576 | 3 | libzstd | 6.71 | 14.06 | 2.10 | 68.56 |
| http/json-1m | 1048576 | 3 | stdx | 11.87 | 30.64 | 2.58 | 119.81 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.63 | 57.29 | 3.07 | 196.40 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 40.08 | 113.49 | 2.83 | 691.00 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.55 | 65.62 | 3.05 | 268.78 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.20 | 116.54 | 2.76 | 680.60 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 9.00 | 26.53 | 2.95 | 132.73 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.64 | 55.71 | 3.35 | 199.78 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.20 | 28.96 | 2.84 | 158.12 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.74 | 55.35 | 3.12 | 209.24 |
| http/js-1m | 1048576 | 1 | libzstd | 6.62 | 17.80 | 2.69 | 116.56 |
| http/js-1m | 1048576 | 1 | stdx | 14.02 | 45.88 | 3.27 | 135.82 |
| http/js-1m | 1048576 | 3 | libzstd | 10.81 | 19.49 | 1.80 | 125.44 |
| http/js-1m | 1048576 | 3 | stdx | 17.66 | 41.25 | 2.34 | 187.12 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.65 | 46.97 | 3.00 | 143.65 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.42 | 91.65 | 2.83 | 578.54 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.74 | 50.68 | 3.03 | 165.66 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.71 | 93.63 | 2.78 | 581.44 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.25 | 18.99 | 3.04 | 80.41 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.43 | 43.79 | 3.52 | 136.81 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.62 | 19.53 | 2.95 | 95.04 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.98 | 42.34 | 3.26 | 152.38 |
| http/css-1m | 1048576 | 1 | libzstd | 1.52 | 4.57 | 3.01 | 22.04 |
| http/css-1m | 1048576 | 1 | stdx | 4.01 | 14.85 | 3.70 | 30.51 |
| http/css-1m | 1048576 | 3 | libzstd | 2.06 | 5.34 | 2.59 | 19.59 |
| http/css-1m | 1048576 | 3 | stdx | 4.04 | 13.33 | 3.30 | 31.52 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.55 | 12.79 | 3.60 | 6.35 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.09 | 30.66 | 3.37 | 61.37 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 32.84 | 53.05 | 1.62 | 47.35 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 21.83 | 47.43 | 2.17 | 206.66 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.121 | 3.00 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 75.3 | 239.0 | 0.087 | 8.90 | 3.17 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 44.1 | 194.4 | 0.073 | 5.21 | 4.41 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 283.8 | 1193.5 | 0.815 | 33.52 | 4.21 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.5 | 107.5 | 0.141 | 3.60 | 3.53 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.3 | 106.0 | 0.296 | 3.34 | 3.75 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.5 | 378.2 | 0.380 | 11.28 | 3.96 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.4 | 161.9 | 0.447 | 5.01 | 3.82 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 91.9 | 451.7 | 0.303 | 10.85 | 4.92 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 28.2 | 89.5 | 0.004 | 4.15 | 3.17 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 76.8 | 250.2 | 0.040 | 11.31 | 3.26 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 49.2 | 205.1 | 0.048 | 7.24 | 4.17 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 241.5 | 927.9 | 0.965 | 35.55 | 3.84 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.0 | 107.7 | 0.041 | 4.11 | 3.85 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 32.8 | 105.7 | 0.047 | 4.82 | 3.23 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 95.5 | 346.2 | 0.353 | 14.06 | 3.62 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 32.6 | 144.5 | 0.053 | 4.80 | 4.43 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 98.1 | 406.5 | 0.078 | 14.45 | 4.14 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114337.0 | 403845.2 | 495.062 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 646211.7 | 2749355.2 | 1406.814 | 3.75 | 4.25 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 645461.0 | 2749752.2 | 1407.196 | 3.74 | 4.26 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 4511847.1 | 22490188.2 | 2976.784 | 26.15 | 4.98 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311134.6 | 621743.2 | 631.423 | 1.80 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 223781.4 | 826618.2 | 2171.990 | 1.30 | 3.69 |
| string: silesia/dickens | 1 | 172528 | std.json | 1593922.5 | 4578768.3 | 43278.918 | 9.24 | 2.87 |
| string: silesia/dickens | 1 | 172528 | serde_json | 201105.5 | 802391.2 | 1007.412 | 1.17 | 3.99 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1061004.0 | 5281911.1 | 4915.701 | 6.15 | 4.98 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1568949.9 | 4799762.6 | 1293.071 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 15230793.5 | 62777133.6 | 38854.357 | 12.80 | 4.12 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 15285541.4 | 62777455.6 | 38853.357 | 12.84 | 4.11 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 35791526.6 | 160729111.6 | 159015.786 | 30.07 | 4.49 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4587006.0 | 7053838.6 | 570.286 | 3.85 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1827902.8 | 7322017.6 | 13876.429 | 1.54 | 4.01 |
| string: http/json-1m | 1 | 1190272 | std.json | 10291600.5 | 47381213.6 | 31973.071 | 8.65 | 4.60 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3819698.2 | 15226459.6 | 6028.786 | 3.21 | 3.99 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9087151.9 | 48020820.5 | 27383.357 | 7.63 | 5.28 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2070482.5 | 5765412.8 | 4498.375 | 1.10 | 2.78 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6529506.8 | 24513270.8 | 6962.125 | 3.47 | 3.75 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 6524788.4 | 24513592.8 | 6894.750 | 3.46 | 3.76 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 59460238.3 | 273034491.8 | 266139.375 | 31.58 | 4.59 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3694149.3 | 7945848.8 | 2169.625 | 1.96 | 2.15 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7279496.3 | 12276727.8 | 276313.625 | 3.87 | 1.69 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 18218185.8 | 63617055.8 | 220307.250 | 9.67 | 3.49 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9606057.4 | 24440755.8 | 292665.500 | 5.10 | 2.54 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39512183.6 | 160311396.0 | 794173.000 | 20.98 | 4.06 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12939389.0 | 42561068.3 | 247213.667 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 190878340.0 | 782100838.3 | 390211.000 | 37.61 | 4.10 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 182621069.7 | 782101160.3 | 392652.667 | 35.98 | 4.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 184297690.3 | 760206171.3 | 422848.333 | 36.31 | 4.12 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17676205.3 | 49745819.3 | 214931.000 | 3.48 | 2.81 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14390666.3 | 44816977.3 | 450428.333 | 2.84 | 3.11 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79585058.3 | 314900845.3 | 484419.333 | 15.68 | 3.96 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36169780.0 | 131556135.3 | 591400.000 | 7.13 | 3.64 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66877344.3 | 273928004.7 | 838944.333 | 13.18 | 4.10 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 94156.2 | 303836.7 | 4.290 | 0.18 | 3.23 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 188425.2 | 623498.7 | 9.419 | 0.36 | 3.31 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 186512.3 | 623231.7 | 8.871 | 0.36 | 3.34 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 13167066.2 | 66585428.7 | 8.774 | 25.11 | 5.06 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 491504.0 | 1376732.7 | 5.258 | 0.94 | 2.80 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 539327.1 | 2195905.7 | 9.871 | 1.03 | 4.07 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3530575.1 | 12808414.7 | 61718.194 | 6.73 | 3.63 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 286191.0 | 1179969.7 | 7.097 | 0.55 | 4.12 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2263339.9 | 12787372.5 | 249.032 | 4.32 | 5.65 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.9 | 81.5 | 0.109 | 2.35 | 4.09 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.3 | 153.6 | 0.129 | 4.17 | 4.35 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 33.5 | 151.5 | 0.095 | 3.96 | 4.52 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 257.7 | 1182.8 | 0.904 | 30.44 | 4.59 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 19.6 | 79.5 | 0.104 | 2.31 | 4.06 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.2 | 94.1 | 0.133 | 2.74 | 4.05 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.9 | 105.4 | 0.246 | 3.30 | 3.77 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.4 | 310.8 | 0.369 | 8.19 | 4.48 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.4 | 255.3 | 0.484 | 7.49 | 4.02 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.5 | 315.1 | 0.239 | 8.09 | 4.60 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 19.5 | 82.5 | 0.024 | 2.86 | 4.24 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.1 | 153.9 | 0.026 | 5.31 | 4.27 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 32.8 | 142.5 | 0.025 | 4.83 | 4.34 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 196.5 | 848.0 | 1.224 | 28.93 | 4.32 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.5 | 81.5 | 0.024 | 2.72 | 4.41 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.5 | 96.6 | 0.032 | 3.17 | 4.49 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.8 | 117.7 | 0.033 | 4.39 | 3.94 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.8 | 271.2 | 0.269 | 8.80 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 48.7 | 211.7 | 0.041 | 7.17 | 4.35 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 82.2 | 331.7 | 0.088 | 12.09 | 4.04 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 85369.4 | 280780.2 | 741.567 | 0.49 | 3.29 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84797.8 | 280730.2 | 722.536 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84846.8 | 280758.2 | 723.309 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 4098459.2 | 20167466.2 | 2946.247 | 23.76 | 4.92 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 83821.4 | 274401.2 | 691.165 | 0.49 | 3.27 |
| string: silesia/dickens | 1 | 172528 | simdjson | 207926.2 | 674008.2 | 2058.433 | 1.21 | 3.24 |
| string: silesia/dickens | 1 | 172528 | yyjson | 210694.3 | 848559.2 | 1361.186 | 1.22 | 4.03 |
| string: silesia/dickens | 1 | 172528 | std.json | 1350750.2 | 2890892.2 | 51206.887 | 7.83 | 2.14 |
| string: silesia/dickens | 1 | 172528 | serde_json | 370872.0 | 1586249.2 | 2295.412 | 2.15 | 4.28 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 577484.9 | 2970296.1 | 2357.979 | 3.35 | 5.14 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1281865.3 | 3582346.6 | 11858.214 | 1.08 | 2.79 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1266815.9 | 3582290.6 | 11377.214 | 1.06 | 2.83 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1269769.0 | 3582318.6 | 11445.214 | 1.07 | 2.82 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 30106480.1 | 134936069.6 | 138975.929 | 25.29 | 4.48 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1228179.3 | 3370022.6 | 11103.643 | 1.03 | 2.74 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2975689.6 | 10460754.6 | 29207.500 | 2.50 | 3.52 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2422720.5 | 11226214.6 | 9768.571 | 2.04 | 4.63 |
| string: http/json-1m | 1 | 1190272 | std.json | 9027693.8 | 43287986.6 | 16413.571 | 7.58 | 4.80 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4203556.2 | 17941088.6 | 10637.357 | 3.53 | 4.27 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5264838.6 | 26999739.9 | 11234.214 | 4.42 | 5.13 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2077194.8 | 6088095.8 | 4654.000 | 1.10 | 2.93 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2065555.4 | 6088039.8 | 4172.500 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2063749.1 | 6088067.8 | 4096.375 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 52556486.6 | 238556376.8 | 258809.625 | 27.91 | 4.54 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2074049.5 | 5875346.8 | 4910.750 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2727065.1 | 7144135.8 | 20907.500 | 1.45 | 2.62 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 11873383.6 | 26334410.8 | 430441.875 | 6.31 | 2.22 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20454645.3 | 56837736.8 | 529598.375 | 10.86 | 2.78 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11573958.1 | 33662338.8 | 306377.750 | 6.15 | 2.91 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18902786.4 | 76319312.5 | 253705.250 | 10.04 | 4.04 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113163.8 | 426373.7 | 2.806 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113214.0 | 426318.7 | 2.645 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113360.4 | 426335.7 | 4.323 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 635237.7 | 3146562.7 | 5.613 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113148.1 | 426343.7 | 1.516 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1243209.9 | 3866907.7 | 4.710 | 2.37 | 3.11 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1667611.2 | 5833344.7 | 6.968 | 3.18 | 3.50 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3630960.3 | 13108830.7 | 72598.355 | 6.93 | 3.61 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1823649.2 | 7405810.7 | 3.806 | 3.48 | 4.06 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2398710.7 | 12748280.9 | 14.742 | 4.58 | 5.31 |
