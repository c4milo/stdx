# bench-profile

| Field | Value |
|---|---|
| Commit | e43afcc |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261101.172.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/42924395454 |
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
| silesia/dickens | 10192446 | zlib | 7.99 | 15.77 | 1.97 | 301.10 |
| silesia/dickens | 10192446 | zlib-ng | 4.90 | 10.50 | 2.14 | 67.60 |
| silesia/dickens | 10192446 | libdeflate | 3.49 | 9.56 | 2.74 | 65.82 |
| silesia/dickens | 10192446 | Wuffs | 4.89 | 10.85 | 2.22 | 97.43 |
| silesia/dickens | 10192446 | stdx | 2.99 | 7.15 | 2.39 | 75.93 |
| silesia/mozilla | 51220480 | zlib | 7.79 | 14.13 | 1.81 | 243.56 |
| silesia/mozilla | 51220480 | zlib-ng | 4.97 | 8.95 | 1.80 | 85.62 |
| silesia/mozilla | 51220480 | libdeflate | 3.50 | 7.63 | 2.18 | 71.09 |
| silesia/mozilla | 51220480 | Wuffs | 5.74 | 10.84 | 1.89 | 132.90 |
| silesia/mozilla | 51220480 | stdx | 3.66 | 6.29 | 1.72 | 89.04 |
| silesia/mr | 9970564 | zlib | 7.72 | 15.26 | 1.98 | 198.56 |
| silesia/mr | 9970564 | zlib-ng | 4.82 | 9.98 | 2.07 | 67.87 |
| silesia/mr | 9970564 | libdeflate | 3.38 | 8.58 | 2.54 | 61.26 |
| silesia/mr | 9970564 | Wuffs | 5.29 | 10.93 | 2.06 | 100.93 |
| silesia/mr | 9970564 | stdx | 3.15 | 6.70 | 2.12 | 69.76 |
| silesia/nci | 33553445 | zlib | 2.95 | 7.25 | 2.46 | 80.18 |
| silesia/nci | 33553445 | zlib-ng | 1.63 | 3.13 | 1.92 | 33.62 |
| silesia/nci | 33553445 | libdeflate | 1.17 | 2.66 | 2.26 | 27.60 |
| silesia/nci | 33553445 | Wuffs | 1.74 | 3.38 | 1.94 | 42.53 |
| silesia/nci | 33553445 | stdx | 1.33 | 2.20 | 1.66 | 37.30 |
| silesia/ooffice | 6152192 | zlib | 11.07 | 17.83 | 1.61 | 402.04 |
| silesia/ooffice | 6152192 | zlib-ng | 6.94 | 12.04 | 1.73 | 140.24 |
| silesia/ooffice | 6152192 | libdeflate | 4.92 | 10.45 | 2.12 | 125.27 |
| silesia/ooffice | 6152192 | Wuffs | 8.15 | 14.47 | 1.78 | 221.72 |
| silesia/ooffice | 6152192 | stdx | 5.14 | 8.55 | 1.66 | 150.78 |
| silesia/osdb | 10085684 | zlib | 6.83 | 13.54 | 1.98 | 172.57 |
| silesia/osdb | 10085684 | zlib-ng | 4.31 | 8.38 | 1.95 | 52.91 |
| silesia/osdb | 10085684 | libdeflate | 2.86 | 6.91 | 2.41 | 29.92 |
| silesia/osdb | 10085684 | Wuffs | 5.20 | 10.56 | 2.03 | 82.88 |
| silesia/osdb | 10085684 | stdx | 2.82 | 5.65 | 2.00 | 41.30 |
| silesia/reymont | 6627202 | zlib | 6.65 | 12.73 | 1.91 | 255.84 |
| silesia/reymont | 6627202 | zlib-ng | 3.71 | 7.72 | 2.08 | 59.86 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.19 |
| silesia/reymont | 6627202 | Wuffs | 4.23 | 8.40 | 1.99 | 112.60 |
| silesia/reymont | 6627202 | stdx | 2.30 | 5.11 | 2.23 | 64.40 |
| silesia/samba | 21606400 | zlib | 5.50 | 11.09 | 2.02 | 170.26 |
| silesia/samba | 21606400 | zlib-ng | 3.38 | 6.47 | 1.91 | 55.85 |
| silesia/samba | 21606400 | libdeflate | 2.36 | 5.58 | 2.36 | 42.92 |
| silesia/samba | 21606400 | Wuffs | 3.69 | 7.33 | 1.99 | 81.38 |
| silesia/samba | 21606400 | stdx | 2.35 | 4.46 | 1.90 | 56.08 |
| silesia/sao | 7251944 | zlib | 9.94 | 20.36 | 2.05 | 197.08 |
| silesia/sao | 7251944 | zlib-ng | 7.88 | 14.83 | 1.88 | 79.07 |
| silesia/sao | 7251944 | libdeflate | 5.75 | 12.73 | 2.21 | 79.00 |
| silesia/sao | 7251944 | Wuffs | 8.16 | 18.14 | 2.22 | 85.87 |
| silesia/sao | 7251944 | stdx | 5.65 | 10.32 | 1.83 | 87.30 |
| silesia/webster | 41458703 | zlib | 7.02 | 12.99 | 1.85 | 274.05 |
| silesia/webster | 41458703 | zlib-ng | 4.23 | 8.04 | 1.90 | 85.07 |
| silesia/webster | 41458703 | libdeflate | 2.94 | 7.17 | 2.44 | 68.38 |
| silesia/webster | 41458703 | Wuffs | 4.51 | 8.62 | 1.91 | 123.33 |
| silesia/webster | 41458703 | stdx | 2.84 | 5.56 | 1.96 | 87.14 |
| silesia/x-ray | 8474240 | zlib | 12.30 | 23.82 | 1.94 | 325.53 |
| silesia/x-ray | 8474240 | zlib-ng | 9.06 | 17.39 | 1.92 | 124.15 |
| silesia/x-ray | 8474240 | libdeflate | 6.55 | 15.26 | 2.33 | 124.51 |
| silesia/x-ray | 8474240 | Wuffs | 10.14 | 20.40 | 2.01 | 192.86 |
| silesia/x-ray | 8474240 | stdx | 6.20 | 11.49 | 1.85 | 137.64 |
| silesia/xml | 5345280 | zlib | 3.63 | 8.20 | 2.26 | 116.26 |
| silesia/xml | 5345280 | zlib-ng | 2.00 | 3.88 | 1.95 | 42.49 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.46 | 31.61 |
| silesia/xml | 5345280 | Wuffs | 2.20 | 4.14 | 1.89 | 60.80 |
| silesia/xml | 5345280 | stdx | 1.33 | 2.65 | 2.00 | 41.80 |
| canterbury/alice29.txt | 152089 | zlib | 7.57 | 15.08 | 1.99 | 284.18 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.51 | 9.91 | 2.20 | 59.74 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.19 | 8.96 | 2.81 | 55.18 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.70 | 10.37 | 2.21 | 98.12 |
| canterbury/alice29.txt | 152089 | stdx | 2.70 | 6.99 | 2.58 | 62.21 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.13 | 16.11 | 1.98 | 302.21 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 72.62 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.62 | 9.82 | 2.71 | 69.98 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.08 | 11.34 | 2.23 | 99.77 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.10 | 7.52 | 2.43 | 80.99 |
| canterbury/cp.html | 24603 | zlib | 6.49 | 14.20 | 2.19 | 170.78 |
| canterbury/cp.html | 24603 | zlib-ng | 4.17 | 9.50 | 2.28 | 36.62 |
| canterbury/cp.html | 24603 | libdeflate | 2.85 | 7.95 | 2.79 | 15.19 |
| canterbury/cp.html | 24603 | Wuffs | 4.46 | 10.87 | 2.44 | 55.63 |
| canterbury/cp.html | 24603 | stdx | 2.66 | 7.19 | 2.70 | 13.80 |
| canterbury/fields.c | 11150 | zlib | 4.60 | 14.65 | 3.18 | 36.56 |
| canterbury/fields.c | 11150 | zlib-ng | 3.87 | 10.20 | 2.63 | 14.12 |
| canterbury/fields.c | 11150 | libdeflate | 2.82 | 8.32 | 2.95 | 1.27 |
| canterbury/fields.c | 11150 | Wuffs | 3.82 | 11.51 | 3.01 | 8.99 |
| canterbury/fields.c | 11150 | stdx | 2.50 | 7.64 | 3.05 | 4.97 |
| canterbury/grammar.lsp | 3721 | zlib | 6.23 | 21.22 | 3.41 | 3.21 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.83 | 17.48 | 3.00 | 7.58 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.48 | 12.05 | 2.69 | 0.09 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.96 | 18.87 | 3.16 | 3.98 |
| canterbury/grammar.lsp | 3721 | stdx | 3.84 | 12.18 | 3.17 | 0.78 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.96 | 12.20 | 3.08 | 49.14 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.85 | 6.97 | 2.45 | 12.52 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.27 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.20 | 8.67 | 2.71 | 14.77 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.66 | 2.67 | 16.53 |
| canterbury/lcet10.txt | 426754 | zlib | 7.36 | 14.53 | 1.97 | 279.14 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 60.39 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.60 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.56 | 9.85 | 2.16 | 101.38 |
| canterbury/lcet10.txt | 426754 | stdx | 2.59 | 6.42 | 2.48 | 66.33 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.29 | 16.53 | 1.99 | 310.03 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.27 | 11.19 | 2.12 | 76.83 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.76 | 10.19 | 2.71 | 76.73 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.15 | 11.53 | 2.24 | 99.59 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.14 | 7.63 | 2.43 | 84.66 |
| canterbury/ptt5 | 513216 | zlib | 4.41 | 7.79 | 1.77 | 100.44 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.00 | 3.74 | 1.88 | 46.45 |
| canterbury/ptt5 | 513216 | libdeflate | 1.44 | 3.02 | 2.10 | 37.66 |
| canterbury/ptt5 | 513216 | Wuffs | 2.19 | 4.02 | 1.84 | 58.70 |
| canterbury/ptt5 | 513216 | stdx | 1.45 | 2.55 | 1.76 | 49.22 |
| canterbury/sum | 38240 | zlib | 7.28 | 14.98 | 2.06 | 215.99 |
| canterbury/sum | 38240 | zlib-ng | 4.63 | 10.02 | 2.17 | 55.97 |
| canterbury/sum | 38240 | libdeflate | 3.38 | 8.34 | 2.46 | 41.48 |
| canterbury/sum | 38240 | Wuffs | 5.00 | 11.41 | 2.28 | 77.09 |
| canterbury/sum | 38240 | stdx | 3.07 | 7.73 | 2.52 | 31.53 |
| canterbury/xargs.1 | 4227 | zlib | 6.72 | 22.08 | 3.29 | 9.67 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.37 | 17.97 | 2.82 | 9.28 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.83 | 13.27 | 2.75 | 0.62 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.48 | 19.63 | 3.03 | 9.39 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 12.86 | 3.04 | 1.99 |
| canterbury-large/E.coli | 4638690 | zlib | 5.94 | 14.55 | 2.45 | 174.92 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.24 | 9.68 | 2.28 | 47.30 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.40 |
| canterbury-large/E.coli | 4638690 | Wuffs | 3.99 | 9.64 | 2.42 | 61.16 |
| canterbury-large/E.coli | 4638690 | stdx | 2.48 | 6.72 | 2.71 | 54.29 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.74 | 13.26 | 1.97 | 259.93 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.79 | 8.26 | 2.18 | 54.02 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.84 | 45.65 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.15 | 8.72 | 2.10 | 100.75 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.23 | 5.57 | 2.50 | 55.95 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.96 | 12.69 | 1.82 | 272.95 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.38 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.41 | 75.20 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.51 | 8.44 | 1.87 | 129.15 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 5.40 | 1.98 | 90.59 |
| http/html-1kx1024 | 1048576 | zlib | 15.83 | 32.44 | 2.05 | 350.14 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.71 | 28.43 | 2.24 | 218.16 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.86 | 20.05 | 1.85 | 156.01 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.60 | 35.05 | 2.40 | 264.23 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 137.77 |
| http/html-16kx64 | 1048576 | zlib | 6.01 | 11.79 | 1.96 | 214.76 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.01 |
| http/html-16kx64 | 1048576 | libdeflate | 2.66 | 6.04 | 2.27 | 60.59 |
| http/html-16kx64 | 1048576 | Wuffs | 4.26 | 8.51 | 2.00 | 116.82 |
| http/html-16kx64 | 1048576 | stdx | 2.51 | 5.56 | 2.22 | 58.89 |
| http/html-1m | 1048576 | zlib | 4.64 | 9.51 | 2.05 | 172.21 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 60.05 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.84 |
| http/html-1m | 1048576 | Wuffs | 2.96 | 5.42 | 1.83 | 90.24 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.11 | 52.37 |
| http/json-1kx1024 | 1048576 | zlib | 9.70 | 20.83 | 2.15 | 191.48 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.25 | 130.77 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.12 | 16.72 | 1.83 | 91.98 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.41 | 31.72 | 2.78 | 145.25 |
| http/json-1kx1024 | 1048576 | stdx | 5.04 | 13.12 | 2.60 | 81.21 |
| http/json-16kx64 | 1048576 | zlib | 3.94 | 9.62 | 2.44 | 101.89 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.76 |
| http/json-16kx64 | 1048576 | libdeflate | 1.92 | 4.24 | 2.20 | 39.63 |
| http/json-16kx64 | 1048576 | Wuffs | 2.81 | 6.35 | 2.26 | 58.07 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.26 | 39.38 |
| http/json-1m | 1048576 | zlib | 3.25 | 8.25 | 2.54 | 82.31 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.03 | 37.17 |
| http/json-1m | 1048576 | libdeflate | 1.37 | 3.33 | 2.42 | 32.08 |
| http/json-1m | 1048576 | Wuffs | 2.04 | 4.29 | 2.11 | 44.30 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.02 | 40.00 |
| http/js-1kx1024 | 1048576 | zlib | 17.29 | 35.33 | 2.04 | 402.08 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.78 | 31.25 | 2.27 | 238.23 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.54 | 21.58 | 1.87 | 179.52 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.77 | 37.71 | 2.39 | 296.50 |
| http/js-1kx1024 | 1048576 | stdx | 9.28 | 22.85 | 2.46 | 159.50 |
| http/js-16kx64 | 1048576 | zlib | 6.91 | 13.06 | 1.89 | 254.66 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.98 | 91.48 |
| http/js-16kx64 | 1048576 | libdeflate | 3.08 | 7.01 | 2.28 | 72.21 |
| http/js-16kx64 | 1048576 | Wuffs | 4.84 | 9.70 | 2.00 | 130.55 |
| http/js-16kx64 | 1048576 | stdx | 3.02 | 6.54 | 2.16 | 72.48 |
| http/js-1m | 1048576 | zlib | 5.16 | 10.26 | 1.99 | 195.92 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 60.21 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 42.16 |
| http/js-1m | 1048576 | Wuffs | 3.26 | 6.10 | 1.87 | 96.23 |
| http/js-1m | 1048576 | stdx | 1.81 | 3.89 | 2.15 | 55.60 |
| http/css-1kx1024 | 1048576 | zlib | 13.14 | 27.18 | 2.07 | 281.46 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.25 | 23.04 | 2.25 | 171.22 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.43 | 17.37 | 1.84 | 121.29 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.03 | 29.48 | 2.45 | 208.87 |
| http/css-1kx1024 | 1048576 | stdx | 6.68 | 17.64 | 2.64 | 100.98 |
| http/css-16kx64 | 1048576 | zlib | 4.67 | 10.12 | 2.16 | 152.17 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.18 | 49.82 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 28.41 |
| http/css-16kx64 | 1048576 | Wuffs | 3.12 | 6.97 | 2.23 | 70.46 |
| http/css-16kx64 | 1048576 | stdx | 1.73 | 4.36 | 2.53 | 28.50 |
| http/css-1m | 1048576 | zlib | 3.38 | 8.00 | 2.37 | 107.74 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.22 | 28.69 |
| http/css-1m | 1048576 | libdeflate | 1.04 | 3.18 | 3.05 | 10.51 |
| http/css-1m | 1048576 | Wuffs | 1.91 | 4.08 | 2.14 | 44.76 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.53 | 21.48 |
| shuffled/dickens-1m | 1048576 | zlib | 12.74 | 22.42 | 1.76 | 372.24 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.73 | 16.72 | 1.72 | 196.55 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.01 | 14.95 | 2.13 | 192.63 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.68 | 18.95 | 1.96 | 206.87 |
| shuffled/dickens-1m | 1048576 | stdx | 7.06 | 11.89 | 1.68 | 209.46 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.58 | 14.04 | 3.92 | 3.52 |
| silesia/dickens | 10192446 | stdx | 3.71 | 12.47 | 3.36 | 3.62 |
| silesia/mozilla | 51220480 | libzstd | 2.86 | 9.62 | 3.36 | 30.07 |
| silesia/mozilla | 51220480 | stdx | 2.88 | 9.68 | 3.36 | 15.70 |
| silesia/mr | 9970564 | libzstd | 3.11 | 11.98 | 3.85 | 6.22 |
| silesia/mr | 9970564 | stdx | 3.13 | 10.83 | 3.46 | 5.24 |
| silesia/nci | 33553445 | libzstd | 1.70 | 4.84 | 2.84 | 23.52 |
| silesia/nci | 33553445 | stdx | 1.88 | 4.63 | 2.46 | 13.54 |
| silesia/ooffice | 6152192 | libzstd | 3.46 | 12.14 | 3.51 | 31.13 |
| silesia/ooffice | 6152192 | stdx | 3.38 | 12.40 | 3.67 | 12.21 |
| silesia/osdb | 10085684 | libzstd | 2.39 | 8.44 | 3.53 | 15.25 |
| silesia/osdb | 10085684 | stdx | 2.45 | 8.11 | 3.31 | 15.53 |
| silesia/reymont | 6627202 | libzstd | 3.24 | 11.61 | 3.58 | 11.61 |
| silesia/reymont | 6627202 | stdx | 3.36 | 10.36 | 3.08 | 12.95 |
| silesia/samba | 21606400 | libzstd | 2.10 | 7.39 | 3.51 | 18.63 |
| silesia/samba | 21606400 | stdx | 2.20 | 6.83 | 3.10 | 17.53 |
| silesia/sao | 7251944 | libzstd | 3.86 | 12.69 | 3.29 | 26.37 |
| silesia/sao | 7251944 | stdx | 3.59 | 12.58 | 3.51 | 6.24 |
| silesia/webster | 41458703 | libzstd | 3.28 | 11.22 | 3.42 | 16.33 |
| silesia/webster | 41458703 | stdx | 3.51 | 10.05 | 2.86 | 17.37 |
| silesia/x-ray | 8474240 | libzstd | 4.00 | 14.93 | 3.73 | 18.74 |
| silesia/x-ray | 8474240 | stdx | 3.60 | 13.23 | 3.68 | 8.52 |
| silesia/xml | 5345280 | libzstd | 1.54 | 5.55 | 3.61 | 22.89 |
| silesia/xml | 5345280 | stdx | 1.52 | 5.16 | 3.39 | 17.03 |
| canterbury/alice29.txt | 152089 | libzstd | 3.37 | 16.18 | 4.80 | 4.20 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.39 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.01 | 14.25 | 4.74 | 3.34 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.30 | 0.29 |
| canterbury/cp.html | 24603 | libzstd | 2.67 | 10.74 | 4.03 | 9.28 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.11 | 0.25 |
| canterbury/fields.c | 11150 | libzstd | 3.13 | 13.61 | 4.35 | 9.64 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.22 | 0.28 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.23 | 16.93 | 4.00 | 6.35 |
| canterbury/grammar.lsp | 3721 | stdx | 4.11 | 16.54 | 4.02 | 0.14 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.48 | 11.22 | 4.52 | 7.71 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.24 | 0.91 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.74 | 12.87 | 4.70 | 5.25 |
| canterbury/lcet10.txt | 426754 | stdx | 2.75 | 11.52 | 4.20 | 4.18 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.17 | 15.14 | 4.78 | 1.56 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.26 | 0.99 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.50 | 3.10 | 24.73 |
| canterbury/ptt5 | 513216 | stdx | 1.35 | 4.46 | 3.30 | 14.00 |
| canterbury/sum | 38240 | libzstd | 2.65 | 10.51 | 3.96 | 10.78 |
| canterbury/sum | 38240 | stdx | 2.63 | 10.74 | 4.09 | 0.42 |
| canterbury/xargs.1 | 4227 | libzstd | 4.30 | 17.40 | 4.04 | 10.62 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 17.17 | 4.06 | 0.21 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.05 | 13.63 | 4.47 | 2.18 |
| canterbury-large/E.coli | 4638690 | stdx | 3.12 | 12.04 | 3.85 | 2.99 |
| canterbury-large/bible.txt | 4047392 | libzstd | 3.00 | 11.99 | 4.00 | 8.56 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.09 | 10.64 | 3.44 | 9.24 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.52 | 9.59 | 3.81 | 19.75 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.63 | 8.64 | 3.28 | 21.86 |
| http/html-1kx1024 | 1048576 | libzstd | 7.41 | 21.63 | 2.92 | 62.84 |
| http/html-1kx1024 | 1048576 | stdx | 7.46 | 22.46 | 3.01 | 76.19 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.65 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.60 | 30.72 |
| http/html-1m | 1048576 | libzstd | 2.00 | 7.86 | 3.94 | 24.23 |
| http/html-1m | 1048576 | stdx | 2.00 | 7.12 | 3.57 | 24.68 |
| http/json-1kx1024 | 1048576 | libzstd | 6.39 | 17.37 | 2.72 | 49.42 |
| http/json-1kx1024 | 1048576 | stdx | 6.21 | 17.86 | 2.88 | 53.32 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.22 | 3.53 | 27.81 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 19.86 |
| http/json-1m | 1048576 | libzstd | 1.71 | 6.04 | 3.53 | 27.32 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.63 | 14.36 |
| http/js-1kx1024 | 1048576 | libzstd | 8.45 | 26.38 | 3.12 | 72.75 |
| http/js-1kx1024 | 1048576 | stdx | 9.03 | 27.60 | 3.06 | 112.39 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.71 | 3.99 | 24.52 |
| http/js-16kx64 | 1048576 | stdx | 2.97 | 11.06 | 3.73 | 26.67 |
| http/js-1m | 1048576 | libzstd | 2.03 | 8.18 | 4.02 | 20.30 |
| http/js-1m | 1048576 | stdx | 2.09 | 7.48 | 3.58 | 21.75 |
| http/css-1kx1024 | 1048576 | libzstd | 7.04 | 19.70 | 2.80 | 53.57 |
| http/css-1kx1024 | 1048576 | stdx | 6.84 | 19.96 | 2.92 | 63.44 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.69 | 3.88 | 23.23 |
| http/css-16kx64 | 1048576 | stdx | 2.28 | 8.43 | 3.69 | 22.40 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.57 | 3.88 | 5.55 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.52 | 4.06 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.81 | 9.40 | 3.35 | 28.57 |
| shuffled/dickens-1m | 1048576 | stdx | 2.73 | 9.19 | 3.37 | 12.45 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.57 | 17.04 | 2.25 | 101.04 |
| silesia/dickens | 1048576 | stdx | 5.12 | 12.38 | 2.42 | 54.70 |
| silesia/mozilla | 1048576 | Google | 13.59 | 27.77 | 2.04 | 46.59 |
| silesia/mozilla | 1048576 | stdx | 8.32 | 15.02 | 1.81 | 47.09 |
| silesia/mr | 1048576 | Google | 8.95 | 20.24 | 2.26 | 102.28 |
| silesia/mr | 1048576 | stdx | 5.86 | 13.25 | 2.26 | 88.35 |
| silesia/nci | 1048576 | Google | 2.57 | 5.69 | 2.21 | 52.13 |
| silesia/nci | 1048576 | stdx | 1.94 | 3.95 | 2.04 | 55.02 |
| silesia/ooffice | 1048576 | Google | 14.25 | 29.28 | 2.05 | 288.53 |
| silesia/ooffice | 1048576 | stdx | 10.89 | 20.33 | 1.87 | 323.14 |
| silesia/osdb | 1048576 | Google | 8.27 | 17.38 | 2.10 | 96.29 |
| silesia/osdb | 1048576 | stdx | 5.21 | 10.57 | 2.03 | 92.91 |
| silesia/reymont | 1048576 | Google | 5.48 | 12.73 | 2.32 | 81.61 |
| silesia/reymont | 1048576 | stdx | 3.75 | 9.25 | 2.47 | 47.54 |
| silesia/samba | 1048576 | Google | 7.61 | 16.22 | 2.13 | 95.74 |
| silesia/samba | 1048576 | stdx | 5.07 | 10.71 | 2.11 | 67.44 |
| silesia/sao | 1048576 | Google | 16.87 | 36.97 | 2.19 | 162.29 |
| silesia/sao | 1048576 | stdx | 10.42 | 22.65 | 2.17 | 142.12 |
| silesia/webster | 1048576 | Google | 6.59 | 14.07 | 2.14 | 114.93 |
| silesia/webster | 1048576 | stdx | 4.43 | 9.98 | 2.25 | 68.88 |
| silesia/x-ray | 1048576 | Google | 19.52 | 38.46 | 1.97 | 233.80 |
| silesia/x-ray | 1048576 | stdx | 14.59 | 30.18 | 2.07 | 234.78 |
| silesia/xml | 1048576 | Google | 3.47 | 7.65 | 2.21 | 65.39 |
| silesia/xml | 1048576 | stdx | 2.41 | 5.40 | 2.24 | 47.12 |
| canterbury/alice29.txt | 152089 | Google | 8.90 | 20.66 | 2.32 | 135.70 |
| canterbury/alice29.txt | 152089 | stdx | 6.07 | 15.33 | 2.53 | 80.39 |
| canterbury/asyoulik.txt | 125179 | Google | 10.42 | 23.83 | 2.29 | 170.11 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.07 | 17.43 | 2.46 | 103.70 |
| canterbury/cp.html | 24603 | Google | 9.21 | 22.18 | 2.41 | 115.16 |
| canterbury/cp.html | 24603 | stdx | 6.04 | 17.15 | 2.84 | 50.19 |
| canterbury/fields.c | 11150 | Google | 7.09 | 21.25 | 3.00 | 21.80 |
| canterbury/fields.c | 11150 | stdx | 4.91 | 17.08 | 3.48 | 2.85 |
| canterbury/grammar.lsp | 3721 | Google | 9.85 | 30.23 | 3.07 | 5.81 |
| canterbury/grammar.lsp | 3721 | stdx | 7.14 | 25.04 | 3.51 | 0.36 |
| canterbury/kennedy.xls | 1029744 | Google | 5.49 | 17.05 | 3.10 | 37.00 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.79 | 12.94 | 3.41 | 33.91 |
| canterbury/lcet10.txt | 426754 | Google | 7.78 | 17.42 | 2.24 | 129.85 |
| canterbury/lcet10.txt | 426754 | stdx | 5.21 | 12.96 | 2.49 | 66.03 |
| canterbury/plrabn12.txt | 481861 | Google | 9.11 | 20.94 | 2.30 | 134.08 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.16 | 15.04 | 2.44 | 87.52 |
| canterbury/ptt5 | 513216 | Google | 4.30 | 10.36 | 2.41 | 62.36 |
| canterbury/ptt5 | 513216 | stdx | 2.36 | 4.89 | 2.07 | 65.31 |
| canterbury/sum | 38240 | Google | 10.83 | 26.44 | 2.44 | 157.38 |
| canterbury/sum | 38240 | stdx | 8.30 | 21.11 | 2.54 | 152.65 |
| canterbury/xargs.1 | 4227 | Google | 10.94 | 34.81 | 3.18 | 9.47 |
| canterbury/xargs.1 | 4227 | stdx | 8.50 | 30.44 | 3.58 | 7.27 |
| canterbury-large/E.coli | 1048576 | Google | 7.49 | 19.44 | 2.60 | 1.39 |
| canterbury-large/E.coli | 1048576 | stdx | 6.72 | 13.48 | 2.00 | 1.86 |
| canterbury-large/bible.txt | 1048576 | Google | 5.37 | 12.38 | 2.31 | 80.80 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.54 | 8.93 | 2.53 | 39.78 |
| canterbury-large/world192.txt | 1048576 | Google | 6.26 | 12.88 | 2.06 | 115.38 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.48 | 9.38 | 2.09 | 77.58 |
| http/html-1kx1024 | 1048576 | Google | 17.97 | 42.09 | 2.34 | 387.54 |
| http/html-1kx1024 | 1048576 | stdx | 15.27 | 37.56 | 2.46 | 359.31 |
| http/html-16kx64 | 1048576 | Google | 6.78 | 14.88 | 2.19 | 149.51 |
| http/html-16kx64 | 1048576 | stdx | 5.17 | 12.15 | 2.35 | 114.68 |
| http/html-1m | 1048576 | Google | 4.08 | 8.99 | 2.20 | 83.38 |
| http/html-1m | 1048576 | stdx | 2.87 | 6.52 | 2.27 | 54.93 |
| http/json-1kx1024 | 1048576 | Google | 14.32 | 36.74 | 2.57 | 238.75 |
| http/json-1kx1024 | 1048576 | stdx | 12.97 | 33.63 | 2.59 | 277.55 |
| http/json-16kx64 | 1048576 | Google | 4.42 | 11.42 | 2.58 | 81.23 |
| http/json-16kx64 | 1048576 | stdx | 3.36 | 8.42 | 2.50 | 83.26 |
| http/json-1m | 1048576 | Google | 3.42 | 8.66 | 2.53 | 58.87 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.44 | 57.45 |
| http/js-1kx1024 | 1048576 | Google | 19.93 | 46.38 | 2.33 | 428.00 |
| http/js-1kx1024 | 1048576 | stdx | 16.39 | 39.90 | 2.44 | 379.54 |
| http/js-16kx64 | 1048576 | Google | 8.08 | 17.79 | 2.20 | 167.48 |
| http/js-16kx64 | 1048576 | stdx | 6.06 | 14.36 | 2.37 | 125.69 |
| http/js-1m | 1048576 | Google | 4.39 | 9.60 | 2.19 | 83.35 |
| http/js-1m | 1048576 | stdx | 3.16 | 7.25 | 2.30 | 55.43 |
| http/css-1kx1024 | 1048576 | Google | 15.39 | 37.48 | 2.44 | 292.84 |
| http/css-1kx1024 | 1048576 | stdx | 13.79 | 34.70 | 2.52 | 301.38 |
| http/css-16kx64 | 1048576 | Google | 4.98 | 11.78 | 2.37 | 101.10 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.48 | 80.81 |
| http/css-1m | 1048576 | Google | 2.43 | 9.43 | 3.87 | 16.82 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.47 | 11.94 |
| shuffled/dickens-1m | 1048576 | Google | 9.80 | 20.34 | 2.07 | 112.50 |
| shuffled/dickens-1m | 1048576 | stdx | 8.76 | 14.53 | 1.66 | 116.33 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.25 | 36.91 | 2.42 | 410.27 |
| silesia/dickens | 10192446 | 1 | stdx | 16.39 | 38.17 | 2.33 | 359.49 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.05 | 87.63 | 1.68 | 692.83 |
| silesia/dickens | 10192446 | 6 | stdx | 49.64 | 84.25 | 1.70 | 1453.36 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.82 | 160.47 | 1.44 | 929.21 |
| silesia/dickens | 10192446 | 9 | stdx | 64.87 | 150.06 | 2.31 | 1399.67 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.11 | 32.62 | 2.31 | 436.86 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.36 | 30.24 | 2.26 | 294.92 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.85 | 70.83 | 2.16 | 578.35 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.56 | 69.96 | 2.22 | 735.70 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.68 | 221.49 | 1.73 | 771.72 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.61 | 125.42 | 2.58 | 781.25 |
| silesia/mr | 9970564 | 1 | libdeflate | 12.01 | 35.02 | 2.92 | 229.18 |
| silesia/mr | 9970564 | 1 | stdx | 12.59 | 34.08 | 2.71 | 186.17 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.21 | 80.54 | 2.11 | 439.34 |
| silesia/mr | 9970564 | 6 | stdx | 39.79 | 83.18 | 2.09 | 975.01 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.56 | 165.48 | 1.70 | 750.62 |
| silesia/mr | 9970564 | 9 | stdx | 78.86 | 184.93 | 2.35 | 1219.20 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.22 | 18.42 | 2.96 | 113.88 |
| silesia/nci | 33553445 | 1 | stdx | 4.95 | 10.88 | 2.20 | 97.26 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.99 | 34.84 | 2.05 | 225.86 |
| silesia/nci | 33553445 | 6 | stdx | 14.44 | 29.54 | 2.05 | 398.56 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.46 | 105.28 | 1.69 | 502.20 |
| silesia/nci | 33553445 | 9 | stdx | 28.28 | 69.01 | 2.44 | 558.92 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.95 | 39.15 | 1.96 | 752.12 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.77 | 39.08 | 2.20 | 429.32 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 41.04 | 79.10 | 1.93 | 956.59 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.66 | 87.83 | 2.11 | 1013.20 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.62 | 127.63 | 1.71 | 1132.97 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.18 | 129.03 | 2.47 | 930.85 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.91 | 30.15 | 2.33 | 351.84 |
| silesia/osdb | 10085684 | 1 | stdx | 12.92 | 27.86 | 2.16 | 293.42 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.30 | 55.67 | 1.97 | 491.15 |
| silesia/osdb | 10085684 | 6 | stdx | 27.15 | 57.39 | 2.11 | 577.92 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.92 | 64.15 | 1.89 | 553.14 |
| silesia/osdb | 10085684 | 9 | stdx | 35.23 | 87.16 | 2.47 | 680.95 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.64 | 32.88 | 2.60 | 310.68 |
| silesia/reymont | 6627202 | 1 | stdx | 13.56 | 33.24 | 2.45 | 272.30 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.09 | 86.58 | 1.80 | 519.25 |
| silesia/reymont | 6627202 | 6 | stdx | 45.12 | 76.81 | 1.70 | 1418.07 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.35 | 276.14 | 1.39 | 837.31 |
| silesia/reymont | 6627202 | 9 | stdx | 74.06 | 160.03 | 2.16 | 1430.33 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.45 | 26.53 | 2.54 | 271.75 |
| silesia/samba | 21606400 | 1 | stdx | 9.91 | 22.23 | 2.24 | 221.01 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.94 | 58.79 | 2.03 | 385.15 |
| silesia/samba | 21606400 | 6 | stdx | 24.16 | 49.83 | 2.06 | 628.67 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.23 | 141.44 | 1.68 | 504.71 |
| silesia/samba | 21606400 | 9 | stdx | 36.14 | 90.81 | 2.51 | 644.05 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.68 | 47.87 | 2.21 | 681.25 |
| silesia/sao | 7251944 | 1 | stdx | 19.13 | 49.92 | 2.61 | 346.29 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.14 | 96.89 | 1.89 | 961.54 |
| silesia/sao | 7251944 | 6 | stdx | 47.14 | 105.66 | 2.24 | 859.59 |
| silesia/sao | 7251944 | 9 | libdeflate | 70.95 | 120.26 | 1.69 | 1107.56 |
| silesia/sao | 7251944 | 9 | stdx | 55.03 | 137.71 | 2.50 | 834.02 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.11 | 30.45 | 2.32 | 386.86 |
| silesia/webster | 41458703 | 1 | stdx | 13.86 | 29.08 | 2.10 | 340.25 |
| silesia/webster | 41458703 | 6 | libdeflate | 36.97 | 66.02 | 1.79 | 570.06 |
| silesia/webster | 41458703 | 6 | stdx | 35.23 | 60.87 | 1.73 | 1122.56 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.66 | 138.85 | 1.47 | 758.74 |
| silesia/webster | 41458703 | 9 | stdx | 48.43 | 110.73 | 2.29 | 1085.22 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.68 | 49.67 | 2.10 | 782.72 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.58 | 50.81 | 2.89 | 261.95 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.84 | 82.77 | 2.52 | 851.46 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.90 | 98.12 | 2.89 | 540.17 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.46 | 91.03 | 2.43 | 1027.55 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.51 | 121.58 | 3.00 | 466.27 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.83 | 21.59 | 2.76 | 175.64 |
| silesia/xml | 5345280 | 1 | stdx | 7.04 | 15.66 | 2.22 | 155.09 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.22 | 40.51 | 1.91 | 263.70 |
| silesia/xml | 5345280 | 6 | stdx | 17.75 | 34.32 | 1.93 | 504.57 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.75 | 89.17 | 1.52 | 373.41 |
| silesia/xml | 5345280 | 9 | stdx | 26.62 | 63.43 | 2.38 | 525.85 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.29 | 35.61 | 2.49 | 378.82 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.07 | 36.12 | 2.40 | 335.87 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.71 | 82.29 | 1.76 | 639.06 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.91 | 77.41 | 1.76 | 1333.06 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.65 | 159.21 | 1.48 | 847.36 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 58.17 | 138.20 | 2.38 | 1268.51 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.14 | 37.20 | 2.46 | 413.22 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.78 | 37.43 | 2.37 | 359.11 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.27 | 85.43 | 1.77 | 713.10 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.25 | 81.92 | 1.77 | 1393.44 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.88 | 136.15 | 1.53 | 938.73 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 60.18 | 144.56 | 2.40 | 1334.62 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.72 | 32.02 | 2.73 | 287.41 |
| canterbury/cp.html | 24603 | 1 | stdx | 10.92 | 27.13 | 2.48 | 240.89 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 26.86 | 62.33 | 2.32 | 483.22 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.73 | 57.05 | 2.40 | 624.80 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.78 | 91.97 | 1.97 | 595.71 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.24 | 88.88 | 2.84 | 647.52 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.66 | 35.92 | 3.72 | 73.25 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.07 | 30.05 | 3.73 | 22.81 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.28 | 69.37 | 2.86 | 231.11 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.82 | 57.62 | 2.77 | 433.11 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 45.09 | 100.81 | 2.24 | 448.53 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.21 | 92.65 | 3.28 | 438.12 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.01 | 51.51 | 3.96 | 14.68 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.86 | 39.01 | 3.96 | 2.28 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.76 | 87.06 | 3.66 | 29.52 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.17 | 70.80 | 4.12 | 17.58 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.53 | 102.89 | 3.37 | 34.90 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.70 | 99.30 | 4.19 | 49.62 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.38 | 27.18 | 3.68 | 65.39 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.03 | 22.58 | 3.21 | 63.47 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.93 | 73.85 | 2.64 | 95.84 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.31 | 61.98 | 3.21 | 138.63 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.26 | 664.23 | 1.83 | 163.59 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 30.19 | 107.06 | 3.55 | 144.03 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.76 | 33.99 | 2.47 | 368.33 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.46 | 33.92 | 2.35 | 330.29 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.03 | 78.22 | 1.74 | 606.09 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.82 | 73.42 | 1.76 | 1240.92 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.81 | 136.94 | 1.49 | 805.29 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 55.18 | 130.91 | 2.37 | 1196.56 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.81 | 38.62 | 2.44 | 426.11 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.72 | 40.24 | 2.41 | 369.13 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.13 | 91.90 | 1.70 | 752.60 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.56 | 88.89 | 1.72 | 1502.26 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.89 | 166.26 | 1.42 | 1004.69 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 67.79 | 158.18 | 2.33 | 1465.61 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.42 | 18.61 | 2.90 | 141.70 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.98 | 11.03 | 2.21 | 123.61 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.24 | 36.17 | 2.54 | 219.16 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.38 | 29.57 | 2.39 | 314.88 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.63 | 120.86 | 1.99 | 379.40 |
| canterbury/ptt5 | 513216 | 9 | stdx | 41.30 | 126.55 | 3.06 | 591.39 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.80 | 33.49 | 2.62 | 336.63 |
| canterbury/sum | 38240 | 1 | stdx | 12.62 | 29.36 | 2.33 | 301.23 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.55 | 69.87 | 2.45 | 494.13 |
| canterbury/sum | 38240 | 6 | stdx | 26.87 | 65.73 | 2.45 | 676.69 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.42 | 181.91 | 1.93 | 607.89 |
| canterbury/sum | 38240 | 9 | stdx | 39.26 | 112.32 | 2.86 | 661.42 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.46 | 53.06 | 3.94 | 32.11 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.75 | 43.10 | 4.01 | 2.07 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.86 | 87.70 | 3.84 | 63.52 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 17.99 | 74.35 | 4.13 | 45.82 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 24.95 | 94.34 | 3.78 | 87.39 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 25.93 | 106.95 | 4.12 | 107.28 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.10 | 40.47 | 3.35 | 164.53 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.70 | 42.29 | 3.33 | 100.92 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.37 | 395.99 | 2.16 | 263.42 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.82 | 374.12 | 3.05 | 1917.81 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.99 | 1063.49 | 1.30 | 1323.03 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 229.35 | 751.65 | 3.28 | 2432.19 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.60 | 32.38 | 2.57 | 312.07 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.50 | 32.23 | 2.39 | 281.80 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.17 | 80.12 | 1.74 | 524.75 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.35 | 72.38 | 1.71 | 1275.12 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.83 | 200.28 | 1.41 | 743.04 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 60.59 | 136.73 | 2.26 | 1225.73 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.30 | 29.72 | 2.23 | 412.02 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.16 | 28.55 | 2.02 | 378.33 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.17 | 60.25 | 1.82 | 557.88 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.24 | 56.80 | 1.76 | 998.90 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.73 | 119.11 | 1.48 | 688.89 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 41.76 | 97.56 | 2.34 | 972.58 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.45 | 103.92 | 2.93 | 456.38 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.46 | 58.63 | 2.73 | 364.50 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.26 | 138.33 | 2.99 | 564.01 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 33.12 | 94.30 | 2.85 | 529.43 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.82 | 142.44 | 2.98 | 588.78 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 37.06 | 112.10 | 3.02 | 538.89 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.46 | 27.96 | 2.67 | 266.88 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.02 | 20.25 | 2.24 | 233.16 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.29 | 52.09 | 2.34 | 390.31 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.93 | 42.86 | 2.26 | 544.92 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 34.99 | 72.54 | 2.07 | 463.14 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.81 | 69.05 | 2.78 | 551.25 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.77 | 23.03 | 2.63 | 223.94 |
| http/html-1m | 1048576 | 1 | stdx | 8.16 | 17.79 | 2.18 | 205.50 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.29 | 49.53 | 1.96 | 326.08 |
| http/html-1m | 1048576 | 6 | stdx | 21.21 | 40.70 | 1.92 | 618.48 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.20 | 109.24 | 1.53 | 432.03 |
| http/html-1m | 1048576 | 9 | stdx | 29.97 | 73.42 | 2.45 | 614.94 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.77 | 94.80 | 2.98 | 302.24 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.50 | 45.16 | 2.74 | 242.53 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.09 | 126.60 | 2.94 | 374.49 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.18 | 78.36 | 2.88 | 379.87 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.19 | 142.45 | 2.73 | 432.14 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.81 | 95.54 | 3.10 | 384.43 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.86 | 23.85 | 3.04 | 134.25 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.48 | 13.94 | 2.54 | 110.59 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.19 | 46.61 | 2.56 | 204.42 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.44 | 35.01 | 2.61 | 282.02 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.23 | 151.99 | 1.89 | 299.21 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.12 | 58.29 | 3.05 | 302.60 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.73 | 19.85 | 2.95 | 124.31 |
| http/json-1m | 1048576 | 1 | stdx | 5.06 | 12.51 | 2.47 | 103.96 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.32 | 45.30 | 2.23 | 174.94 |
| http/json-1m | 1048576 | 6 | stdx | 14.69 | 35.08 | 2.39 | 297.40 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.76 | 205.21 | 1.69 | 280.66 |
| http/json-1m | 1048576 | 9 | stdx | 27.46 | 69.14 | 2.52 | 336.91 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.05 | 107.80 | 2.91 | 517.69 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.72 | 65.40 | 2.76 | 410.43 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.48 | 144.85 | 2.93 | 681.02 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 36.63 | 104.11 | 2.84 | 617.67 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.80 | 150.13 | 2.90 | 719.00 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 41.28 | 125.11 | 3.03 | 625.57 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.74 | 30.90 | 2.63 | 308.52 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.86 | 24.80 | 2.28 | 272.74 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.91 | 59.43 | 2.29 | 470.55 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.86 | 50.04 | 2.19 | 682.76 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.92 | 83.31 | 2.04 | 564.58 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.63 | 81.30 | 2.74 | 663.68 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.65 | 25.19 | 2.61 | 247.09 |
| http/js-1m | 1048576 | 1 | stdx | 9.61 | 21.31 | 2.22 | 232.98 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.87 | 56.12 | 1.94 | 368.53 |
| http/js-1m | 1048576 | 6 | stdx | 25.14 | 46.64 | 1.86 | 751.31 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.53 | 120.65 | 1.58 | 501.47 |
| http/js-1m | 1048576 | 9 | stdx | 35.01 | 84.80 | 2.42 | 707.74 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.23 | 97.73 | 2.94 | 376.48 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.45 | 49.52 | 2.68 | 301.13 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.92 | 129.22 | 2.94 | 479.85 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.28 | 82.31 | 2.81 | 504.64 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.94 | 133.80 | 2.91 | 509.30 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.25 | 99.46 | 2.99 | 521.72 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.65 | 25.60 | 2.96 | 173.24 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.72 | 16.96 | 2.52 | 134.67 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.25 | 48.80 | 2.41 | 287.71 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.52 | 38.00 | 2.30 | 468.60 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.83 | 82.40 | 2.02 | 371.13 |
| http/css-16kx64 | 1048576 | 9 | stdx | 22.95 | 65.13 | 2.84 | 479.40 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.95 | 21.15 | 3.04 | 132.37 |
| http/css-1m | 1048576 | 1 | stdx | 5.78 | 14.91 | 2.58 | 108.44 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.79 | 44.50 | 2.14 | 226.87 |
| http/css-1m | 1048576 | 6 | stdx | 16.64 | 35.61 | 2.14 | 446.69 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.85 | 111.58 | 1.60 | 310.46 |
| http/css-1m | 1048576 | 9 | stdx | 28.19 | 72.54 | 2.57 | 473.27 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.25 | 48.89 | 1.94 | 929.25 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.18 | 49.19 | 2.71 | 323.77 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.65 | 86.45 | 2.08 | 1183.63 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.82 | 88.79 | 2.23 | 851.93 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.16 | 94.50 | 2.00 | 1346.68 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 53.62 | 133.83 | 2.50 | 1125.11 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.14 | 31.13 | 3.07 | 122.57 |
| silesia/dickens | 10192446 | 1 | stdx | 24.26 | 82.03 | 3.38 | 124.73 |
| silesia/dickens | 10192446 | 3 | libzstd | 22.90 | 35.01 | 1.53 | 172.12 |
| silesia/dickens | 10192446 | 3 | stdx | 35.38 | 78.22 | 2.21 | 182.49 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.02 | 22.57 | 3.21 | 72.21 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.56 | 54.73 | 3.12 | 173.39 |
| silesia/mozilla | 51220480 | 3 | libzstd | 17.25 | 28.71 | 1.66 | 102.76 |
| silesia/mozilla | 51220480 | 3 | stdx | 30.27 | 62.01 | 2.05 | 144.63 |
| silesia/mr | 9970564 | 1 | libzstd | 7.69 | 24.73 | 3.21 | 57.80 |
| silesia/mr | 9970564 | 1 | stdx | 19.82 | 66.82 | 3.37 | 113.66 |
| silesia/mr | 9970564 | 3 | libzstd | 20.22 | 32.97 | 1.63 | 86.63 |
| silesia/mr | 9970564 | 3 | stdx | 33.41 | 72.46 | 2.17 | 114.60 |
| silesia/nci | 33553445 | 1 | libzstd | 3.56 | 9.49 | 2.66 | 58.68 |
| silesia/nci | 33553445 | 1 | stdx | 7.66 | 25.69 | 3.36 | 58.87 |
| silesia/nci | 33553445 | 3 | libzstd | 5.47 | 10.11 | 1.85 | 56.91 |
| silesia/nci | 33553445 | 3 | stdx | 11.25 | 29.15 | 2.59 | 66.28 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.58 | 29.17 | 3.40 | 72.31 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.05 | 72.51 | 3.15 | 179.59 |
| silesia/ooffice | 6152192 | 3 | libzstd | 24.08 | 40.82 | 1.70 | 122.22 |
| silesia/ooffice | 6152192 | 3 | stdx | 41.35 | 82.20 | 1.99 | 184.57 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.13 | 22.22 | 3.12 | 67.03 |
| silesia/osdb | 10085684 | 1 | stdx | 16.29 | 50.52 | 3.10 | 119.43 |
| silesia/osdb | 10085684 | 3 | libzstd | 18.17 | 27.06 | 1.49 | 69.57 |
| silesia/osdb | 10085684 | 3 | stdx | 31.18 | 57.87 | 1.86 | 110.51 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.83 | 27.02 | 2.75 | 156.09 |
| silesia/reymont | 6627202 | 1 | stdx | 20.13 | 72.05 | 3.58 | 96.60 |
| silesia/reymont | 6627202 | 3 | libzstd | 18.50 | 27.53 | 1.49 | 127.30 |
| silesia/reymont | 6627202 | 3 | stdx | 27.93 | 62.18 | 2.23 | 147.41 |
| silesia/samba | 21606400 | 1 | libzstd | 6.01 | 16.80 | 2.80 | 88.13 |
| silesia/samba | 21606400 | 1 | stdx | 13.44 | 42.89 | 3.19 | 125.10 |
| silesia/samba | 21606400 | 3 | libzstd | 12.01 | 19.20 | 1.60 | 99.95 |
| silesia/samba | 21606400 | 3 | stdx | 20.15 | 44.75 | 2.22 | 132.67 |
| silesia/sao | 7251944 | 1 | libzstd | 9.06 | 33.64 | 3.71 | 43.87 |
| silesia/sao | 7251944 | 1 | stdx | 25.86 | 82.03 | 3.17 | 103.35 |
| silesia/sao | 7251944 | 3 | libzstd | 32.26 | 52.14 | 1.62 | 95.63 |
| silesia/sao | 7251944 | 3 | stdx | 50.15 | 95.22 | 1.90 | 141.92 |
| silesia/webster | 41458703 | 1 | libzstd | 8.73 | 24.86 | 2.85 | 135.74 |
| silesia/webster | 41458703 | 1 | stdx | 20.29 | 64.04 | 3.16 | 166.34 |
| silesia/webster | 41458703 | 3 | libzstd | 19.24 | 27.84 | 1.45 | 178.28 |
| silesia/webster | 41458703 | 3 | stdx | 30.74 | 64.55 | 2.10 | 194.90 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.76 | 14.89 | 3.13 | 16.92 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.79 | 76.64 | 3.22 | 91.62 |
| silesia/x-ray | 8474240 | 3 | libzstd | 32.89 | 54.96 | 1.67 | 86.83 |
| silesia/x-ray | 8474240 | 3 | stdx | 46.65 | 92.40 | 1.98 | 106.89 |
| silesia/xml | 5345280 | 1 | libzstd | 4.29 | 11.65 | 2.71 | 72.79 |
| silesia/xml | 5345280 | 1 | stdx | 10.34 | 34.21 | 3.31 | 94.53 |
| silesia/xml | 5345280 | 3 | libzstd | 6.88 | 12.84 | 1.87 | 78.95 |
| silesia/xml | 5345280 | 3 | stdx | 12.67 | 32.28 | 2.55 | 115.46 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.93 | 32.86 | 3.01 | 145.98 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.34 | 76.49 | 3.42 | 185.23 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.88 | 39.93 | 2.51 | 204.49 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.40 | 73.76 | 2.79 | 332.33 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.80 | 33.59 | 3.43 | 110.18 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.54 | 79.00 | 3.36 | 214.81 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.65 | 40.28 | 2.57 | 207.57 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.08 | 79.30 | 2.82 | 372.54 |
| canterbury/cp.html | 24603 | 1 | libzstd | 6.99 | 26.65 | 3.81 | 38.92 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.03 | 57.76 | 3.60 | 117.67 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.37 | 32.88 | 3.51 | 15.86 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.11 | 59.76 | 3.30 | 138.62 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.74 | 31.77 | 3.64 | 38.30 |
| canterbury/fields.c | 11150 | 1 | stdx | 16.91 | 65.73 | 3.89 | 80.89 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.10 | 34.41 | 3.78 | 12.70 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.26 | 64.68 | 3.75 | 88.79 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.51 | 37.98 | 3.99 | 8.34 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.15 | 77.57 | 3.85 | 49.67 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.64 | 43.28 | 4.07 | 1.82 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.42 | 79.60 | 3.72 | 69.79 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.01 | 23.37 | 3.89 | 14.82 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.76 | 56.75 | 3.85 | 83.79 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.69 | 24.26 | 2.79 | 27.41 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 20.34 | 56.61 | 2.78 | 107.81 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.88 | 28.42 | 2.88 | 160.72 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.40 | 72.02 | 3.37 | 159.31 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 17.00 | 32.77 | 1.93 | 203.54 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.35 | 67.10 | 2.55 | 297.40 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.36 | 32.28 | 3.11 | 130.22 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.10 | 84.16 | 3.35 | 159.04 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 20.83 | 39.60 | 1.90 | 226.71 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 31.73 | 80.77 | 2.55 | 341.38 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.17 | 8.48 | 2.67 | 67.99 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.53 | 23.15 | 3.07 | 104.78 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 5.09 | 11.28 | 2.22 | 59.98 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.43 | 24.08 | 2.55 | 132.46 |
| canterbury/sum | 38240 | 1 | libzstd | 6.49 | 25.37 | 3.91 | 29.47 |
| canterbury/sum | 38240 | 1 | stdx | 16.87 | 59.13 | 3.51 | 148.18 |
| canterbury/sum | 38240 | 3 | libzstd | 9.15 | 31.64 | 3.46 | 29.20 |
| canterbury/sum | 38240 | 3 | stdx | 19.55 | 61.82 | 3.16 | 181.35 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 10.05 | 39.84 | 3.97 | 11.94 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.87 | 80.38 | 3.85 | 58.48 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.08 | 48.45 | 4.01 | 2.28 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.83 | 83.98 | 3.68 | 79.25 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.53 | 33.29 | 3.16 | 75.69 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.86 | 95.62 | 4.37 | 7.29 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 15.65 | 31.71 | 2.03 | 35.78 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.91 | 70.38 | 2.94 | 38.61 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.87 | 27.35 | 2.77 | 154.78 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.37 | 71.86 | 3.53 | 108.65 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 18.30 | 28.64 | 1.57 | 133.36 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 28.05 | 63.36 | 2.26 | 155.07 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.19 | 22.62 | 2.76 | 139.79 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.67 | 55.86 | 2.99 | 192.89 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 15.69 | 24.36 | 1.55 | 175.75 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 24.81 | 51.26 | 2.07 | 236.03 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.24 | 52.52 | 3.05 | 169.61 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.90 | 100.54 | 2.80 | 638.55 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.30 | 59.34 | 3.08 | 204.62 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 37.99 | 104.00 | 2.74 | 632.41 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.88 | 22.47 | 2.85 | 128.10 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.23 | 46.84 | 3.29 | 182.04 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.99 | 24.79 | 2.76 | 146.39 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.55 | 47.61 | 3.06 | 191.47 |
| http/html-1m | 1048576 | 1 | libzstd | 6.32 | 16.66 | 2.64 | 117.56 |
| http/html-1m | 1048576 | 1 | stdx | 12.95 | 42.00 | 3.24 | 134.34 |
| http/html-1m | 1048576 | 3 | libzstd | 9.54 | 18.50 | 1.94 | 125.97 |
| http/html-1m | 1048576 | 3 | stdx | 15.63 | 39.37 | 2.52 | 177.22 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.47 | 42.58 | 2.94 | 119.92 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.57 | 83.13 | 2.81 | 528.12 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.99 | 44.69 | 2.98 | 134.38 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.82 | 84.87 | 2.75 | 530.45 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.85 | 15.00 | 3.10 | 59.23 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.75 | 33.78 | 3.46 | 116.16 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.44 | 16.31 | 3.00 | 73.15 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.75 | 34.58 | 3.22 | 122.72 |
| http/json-1m | 1048576 | 1 | libzstd | 4.07 | 12.47 | 3.06 | 53.51 |
| http/json-1m | 1048576 | 1 | stdx | 9.00 | 30.70 | 3.41 | 85.49 |
| http/json-1m | 1048576 | 3 | libzstd | 6.36 | 14.06 | 2.21 | 68.42 |
| http/json-1m | 1048576 | 3 | stdx | 11.30 | 30.64 | 2.71 | 119.24 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.75 | 57.29 | 3.05 | 196.22 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 39.97 | 113.49 | 2.84 | 688.45 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.64 | 65.62 | 3.03 | 267.72 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.12 | 116.54 | 2.77 | 680.36 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 9.01 | 26.53 | 2.94 | 132.99 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.65 | 55.71 | 3.35 | 200.53 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.32 | 28.96 | 2.81 | 157.87 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.78 | 55.35 | 3.11 | 209.58 |
| http/js-1m | 1048576 | 1 | libzstd | 6.62 | 17.80 | 2.69 | 116.51 |
| http/js-1m | 1048576 | 1 | stdx | 13.97 | 45.88 | 3.28 | 136.38 |
| http/js-1m | 1048576 | 3 | libzstd | 10.27 | 19.49 | 1.90 | 124.91 |
| http/js-1m | 1048576 | 3 | stdx | 16.89 | 41.25 | 2.44 | 187.33 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.75 | 46.97 | 2.98 | 142.82 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.35 | 91.65 | 2.83 | 579.19 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.87 | 50.68 | 3.00 | 167.03 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.80 | 93.63 | 2.77 | 583.42 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.25 | 18.99 | 3.04 | 80.64 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.51 | 43.79 | 3.50 | 137.51 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.64 | 19.53 | 2.94 | 94.38 |
| http/css-16kx64 | 1048576 | 3 | stdx | 13.03 | 42.34 | 3.25 | 153.31 |
| http/css-1m | 1048576 | 1 | libzstd | 1.52 | 4.57 | 3.00 | 22.15 |
| http/css-1m | 1048576 | 1 | stdx | 3.98 | 14.85 | 3.73 | 30.47 |
| http/css-1m | 1048576 | 3 | libzstd | 2.00 | 5.34 | 2.66 | 19.57 |
| http/css-1m | 1048576 | 3 | stdx | 3.94 | 13.33 | 3.38 | 31.39 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.55 | 12.79 | 3.60 | 6.41 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.10 | 30.66 | 3.37 | 61.82 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 29.68 | 53.05 | 1.79 | 48.30 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 20.75 | 47.43 | 2.29 | 206.98 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.3 | 74.2 | 0.119 | 2.99 | 2.93 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 66.3 | 223.0 | 0.081 | 7.83 | 3.36 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 41.0 | 179.1 | 0.077 | 4.84 | 4.37 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 250.7 | 1024.0 | 0.823 | 29.61 | 4.08 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 31.0 | 107.5 | 0.151 | 3.66 | 3.47 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.2 | 106.0 | 0.298 | 3.33 | 3.76 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 94.6 | 378.2 | 0.376 | 11.18 | 4.00 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.5 | 161.9 | 0.437 | 5.02 | 3.81 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 89.7 | 451.6 | 0.301 | 10.60 | 5.03 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.9 | 89.5 | 0.005 | 4.10 | 3.21 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.9 | 235.2 | 0.040 | 10.14 | 3.41 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 45.4 | 192.0 | 0.049 | 6.69 | 4.23 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 218.1 | 819.1 | 0.977 | 32.10 | 3.76 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.1 | 107.7 | 0.039 | 4.14 | 3.83 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 31.9 | 105.7 | 0.047 | 4.69 | 3.32 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 93.6 | 346.2 | 0.317 | 13.78 | 3.70 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 33.3 | 144.5 | 0.052 | 4.89 | 4.35 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 93.7 | 406.5 | 0.087 | 13.79 | 4.34 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114069.5 | 403845.2 | 473.082 | 0.66 | 3.54 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 592659.7 | 2503289.2 | 1392.474 | 3.44 | 4.22 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 593666.3 | 2503705.2 | 1391.216 | 3.44 | 4.22 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3573615.1 | 18223876.2 | 3000.216 | 20.71 | 5.10 |
| string: silesia/dickens | 1 | 172528 | simdjson | 310294.7 | 621743.2 | 575.608 | 1.80 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 224349.3 | 826618.2 | 2190.340 | 1.30 | 3.68 |
| string: silesia/dickens | 1 | 172528 | std.json | 1576734.5 | 4578768.2 | 42882.433 | 9.14 | 2.90 |
| string: silesia/dickens | 1 | 172528 | serde_json | 203263.9 | 802391.2 | 992.742 | 1.18 | 3.95 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1069259.9 | 5282676.3 | 5137.196 | 6.20 | 4.94 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1568082.9 | 4799762.6 | 1300.357 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14327376.8 | 56816155.6 | 39204.214 | 12.04 | 3.97 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 14299782.1 | 56816485.6 | 39206.214 | 12.01 | 3.97 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 29225702.5 | 132108253.6 | 159568.786 | 24.55 | 4.52 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4583755.4 | 7053838.6 | 521.286 | 3.85 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1796286.6 | 7322017.6 | 14574.286 | 1.51 | 4.08 |
| string: http/json-1m | 1 | 1190272 | std.json | 10366710.5 | 47381213.6 | 30695.429 | 8.71 | 4.57 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3847501.4 | 15226459.6 | 6113.571 | 3.23 | 3.96 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9283884.0 | 48021117.8 | 27750.357 | 7.80 | 5.17 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2069803.8 | 5765412.8 | 4345.875 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6155307.4 | 22589266.8 | 7012.625 | 3.27 | 3.67 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 6157050.6 | 22589596.8 | 6970.750 | 3.27 | 3.67 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47588246.5 | 227842320.8 | 294686.875 | 25.27 | 4.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3696274.3 | 7945848.8 | 1948.250 | 1.96 | 2.15 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7266573.5 | 12276727.8 | 279806.125 | 3.86 | 1.69 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 18198325.1 | 63617055.8 | 219311.250 | 9.66 | 3.50 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9403029.4 | 24440755.8 | 328420.000 | 4.99 | 2.60 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39220438.0 | 160312699.3 | 837929.125 | 20.83 | 4.09 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12965119.3 | 42561068.3 | 245995.667 | 2.55 | 3.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 159289420.7 | 667246750.3 | 394404.333 | 31.38 | 4.19 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 168817292.3 | 667247080.3 | 392175.333 | 33.26 | 3.95 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 152245796.3 | 639992662.3 | 423415.333 | 30.00 | 4.20 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17645231.7 | 49745819.3 | 222826.333 | 3.48 | 2.82 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 13972237.0 | 44816977.3 | 432815.000 | 2.75 | 3.21 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 80540763.3 | 314900845.3 | 482536.000 | 15.87 | 3.91 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36131565.3 | 131556135.3 | 584354.333 | 7.12 | 3.64 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66698852.3 | 273932075.0 | 841262.000 | 13.14 | 4.11 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 93232.2 | 303836.7 | 6.710 | 0.18 | 3.26 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 188214.0 | 623468.7 | 9.194 | 0.36 | 3.31 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 186873.4 | 623253.7 | 8.129 | 0.36 | 3.34 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10298935.8 | 53478202.7 | 8.452 | 19.64 | 5.19 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 490571.8 | 1376732.7 | 3.677 | 0.94 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 538848.9 | 2195905.7 | 9.355 | 1.03 | 4.08 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3458717.5 | 12808414.7 | 61043.032 | 6.60 | 3.70 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 286995.1 | 1179969.7 | 5.710 | 0.55 | 4.11 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2260024.8 | 12790415.6 | 250.226 | 4.31 | 5.66 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 20.2 | 81.8 | 0.111 | 2.39 | 4.05 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.1 | 153.6 | 0.127 | 4.15 | 4.37 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 33.1 | 151.5 | 0.095 | 3.91 | 4.58 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 221.3 | 981.0 | 0.926 | 26.14 | 4.43 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 19.4 | 79.5 | 0.105 | 2.30 | 4.09 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.1 | 94.1 | 0.135 | 2.72 | 4.08 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 26.9 | 105.4 | 0.244 | 3.18 | 3.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.4 | 310.8 | 0.371 | 8.20 | 4.48 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.4 | 255.3 | 0.490 | 7.49 | 4.03 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 67.8 | 315.1 | 0.234 | 8.01 | 4.64 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.9 | 82.8 | 0.025 | 2.78 | 4.38 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.1 | 153.9 | 0.025 | 5.32 | 4.26 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 32.3 | 142.5 | 0.024 | 4.76 | 4.41 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 172.8 | 718.3 | 1.282 | 25.44 | 4.16 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.4 | 81.5 | 0.025 | 2.70 | 4.44 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.7 | 96.6 | 0.032 | 3.19 | 4.45 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.2 | 117.7 | 0.032 | 4.30 | 4.03 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 60.5 | 271.2 | 0.273 | 8.90 | 4.48 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 48.5 | 211.7 | 0.038 | 7.13 | 4.37 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 81.2 | 331.7 | 0.085 | 11.95 | 4.09 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 84951.3 | 280786.2 | 717.495 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84768.9 | 280732.2 | 709.639 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84634.1 | 280758.2 | 705.062 | 0.49 | 3.32 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3399593.4 | 16047574.2 | 2945.299 | 19.70 | 4.72 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 82774.3 | 274401.2 | 648.742 | 0.48 | 3.32 |
| string: silesia/dickens | 1 | 172528 | simdjson | 211195.7 | 674008.2 | 2210.804 | 1.22 | 3.19 |
| string: silesia/dickens | 1 | 172528 | yyjson | 217620.6 | 848559.2 | 1435.794 | 1.26 | 3.90 |
| string: silesia/dickens | 1 | 172528 | std.json | 1360469.3 | 2890892.2 | 54454.227 | 7.89 | 2.12 |
| string: silesia/dickens | 1 | 172528 | serde_json | 366241.6 | 1586249.2 | 2360.412 | 2.12 | 4.33 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 590182.4 | 2970293.2 | 3157.577 | 3.42 | 5.03 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1251978.1 | 3582350.6 | 10751.286 | 1.05 | 2.86 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1237488.7 | 3582290.6 | 10199.571 | 1.04 | 2.89 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1237686.6 | 3582318.6 | 10245.857 | 1.04 | 2.89 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25588510.4 | 109856348.6 | 142489.714 | 21.50 | 4.29 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1221028.5 | 3370022.6 | 10843.500 | 1.03 | 2.76 |
| string: http/json-1m | 1 | 1190272 | simdjson | 3028094.9 | 10460754.6 | 30970.643 | 2.54 | 3.45 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2669801.4 | 11226214.6 | 9807.214 | 2.24 | 4.20 |
| string: http/json-1m | 1 | 1190272 | std.json | 8945572.6 | 43287986.6 | 16183.214 | 7.52 | 4.84 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3772828.8 | 17941088.6 | 11615.500 | 3.17 | 4.76 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5278670.9 | 26999728.6 | 11455.429 | 4.43 | 5.11 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2072784.0 | 6088099.8 | 4736.375 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2059584.5 | 6088039.8 | 4196.375 | 1.09 | 2.96 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2056892.4 | 6088067.8 | 4069.625 | 1.09 | 2.96 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43665292.0 | 193466548.8 | 266535.000 | 23.19 | 4.43 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2074080.0 | 5875346.8 | 4804.375 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2719491.9 | 7144135.8 | 20705.875 | 1.44 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12421069.8 | 26334410.8 | 417514.125 | 6.60 | 2.12 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20249473.6 | 56837736.8 | 542843.250 | 10.75 | 2.81 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11180223.9 | 33662338.8 | 338992.750 | 5.94 | 3.01 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18347770.0 | 76319472.0 | 254446.500 | 9.74 | 4.16 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113209.7 | 426376.7 | 3.032 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113066.5 | 426318.7 | 2.645 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113102.3 | 426335.7 | 2.290 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 635516.6 | 3146479.7 | 6.129 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113076.9 | 426343.7 | 2.032 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1238894.3 | 3866907.7 | 4.548 | 2.36 | 3.12 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1662856.3 | 5833344.7 | 10.032 | 3.17 | 3.51 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3529912.6 | 13108830.7 | 77545.581 | 6.73 | 3.71 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1825982.4 | 7405810.7 | 4.323 | 3.48 | 4.06 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2388631.3 | 12748343.8 | 17.839 | 4.56 | 5.34 |
