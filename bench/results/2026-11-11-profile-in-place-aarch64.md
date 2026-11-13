# bench-profile

| Field | Value |
|---|---|
| Commit | d95d4cb |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261101.172.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/42974769027 |
| Date | 2026-11-11 |

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
| silesia/dickens | 10192446 | zlib | 7.99 | 15.77 | 1.97 | 300.23 |
| silesia/dickens | 10192446 | zlib-ng | 4.91 | 10.50 | 2.14 | 67.23 |
| silesia/dickens | 10192446 | libdeflate | 3.49 | 9.56 | 2.74 | 66.16 |
| silesia/dickens | 10192446 | Wuffs | 4.95 | 10.85 | 2.19 | 96.86 |
| silesia/dickens | 10192446 | stdx | 3.02 | 7.15 | 2.37 | 75.90 |
| silesia/mozilla | 51220480 | zlib | 7.78 | 14.13 | 1.82 | 242.74 |
| silesia/mozilla | 51220480 | zlib-ng | 4.95 | 8.95 | 1.81 | 85.40 |
| silesia/mozilla | 51220480 | libdeflate | 3.49 | 7.63 | 2.19 | 71.08 |
| silesia/mozilla | 51220480 | Wuffs | 5.76 | 10.84 | 1.88 | 132.74 |
| silesia/mozilla | 51220480 | stdx | 3.66 | 6.29 | 1.72 | 89.19 |
| silesia/mr | 9970564 | zlib | 7.72 | 15.26 | 1.98 | 196.71 |
| silesia/mr | 9970564 | zlib-ng | 4.85 | 9.98 | 2.06 | 67.79 |
| silesia/mr | 9970564 | libdeflate | 3.38 | 8.58 | 2.54 | 61.13 |
| silesia/mr | 9970564 | Wuffs | 5.33 | 10.93 | 2.05 | 100.63 |
| silesia/mr | 9970564 | stdx | 3.19 | 6.70 | 2.10 | 69.63 |
| silesia/nci | 33553445 | zlib | 2.93 | 7.25 | 2.47 | 78.32 |
| silesia/nci | 33553445 | zlib-ng | 1.67 | 3.13 | 1.87 | 33.73 |
| silesia/nci | 33553445 | libdeflate | 1.26 | 2.66 | 2.12 | 29.73 |
| silesia/nci | 33553445 | Wuffs | 1.78 | 3.38 | 1.90 | 42.74 |
| silesia/nci | 33553445 | stdx | 1.45 | 2.20 | 1.52 | 37.98 |
| silesia/ooffice | 6152192 | zlib | 11.05 | 17.83 | 1.61 | 401.31 |
| silesia/ooffice | 6152192 | zlib-ng | 6.95 | 12.04 | 1.73 | 140.63 |
| silesia/ooffice | 6152192 | libdeflate | 4.93 | 10.45 | 2.12 | 125.47 |
| silesia/ooffice | 6152192 | Wuffs | 8.16 | 14.47 | 1.77 | 220.96 |
| silesia/ooffice | 6152192 | stdx | 5.16 | 8.55 | 1.66 | 150.71 |
| silesia/osdb | 10085684 | zlib | 6.82 | 13.54 | 1.99 | 170.17 |
| silesia/osdb | 10085684 | zlib-ng | 4.33 | 8.38 | 1.93 | 53.21 |
| silesia/osdb | 10085684 | libdeflate | 2.86 | 6.91 | 2.41 | 29.74 |
| silesia/osdb | 10085684 | Wuffs | 5.16 | 10.56 | 2.05 | 77.71 |
| silesia/osdb | 10085684 | stdx | 2.83 | 5.65 | 2.00 | 40.99 |
| silesia/reymont | 6627202 | zlib | 6.63 | 12.73 | 1.92 | 251.65 |
| silesia/reymont | 6627202 | zlib-ng | 3.72 | 7.72 | 2.07 | 59.57 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.07 |
| silesia/reymont | 6627202 | Wuffs | 4.24 | 8.40 | 1.98 | 112.24 |
| silesia/reymont | 6627202 | stdx | 2.29 | 5.11 | 2.23 | 63.96 |
| silesia/samba | 21606400 | zlib | 5.50 | 11.09 | 2.02 | 169.46 |
| silesia/samba | 21606400 | zlib-ng | 3.39 | 6.47 | 1.91 | 55.85 |
| silesia/samba | 21606400 | libdeflate | 2.37 | 5.58 | 2.36 | 43.09 |
| silesia/samba | 21606400 | Wuffs | 3.70 | 7.33 | 1.98 | 81.17 |
| silesia/samba | 21606400 | stdx | 2.42 | 4.46 | 1.84 | 56.13 |
| silesia/sao | 7251944 | zlib | 9.94 | 20.36 | 2.05 | 195.89 |
| silesia/sao | 7251944 | zlib-ng | 7.89 | 14.83 | 1.88 | 79.35 |
| silesia/sao | 7251944 | libdeflate | 5.76 | 12.73 | 2.21 | 78.94 |
| silesia/sao | 7251944 | Wuffs | 8.21 | 18.14 | 2.21 | 86.90 |
| silesia/sao | 7251944 | stdx | 5.67 | 10.32 | 1.82 | 86.68 |
| silesia/webster | 41458703 | zlib | 6.98 | 12.99 | 1.86 | 271.34 |
| silesia/webster | 41458703 | zlib-ng | 4.24 | 8.04 | 1.90 | 84.30 |
| silesia/webster | 41458703 | libdeflate | 2.95 | 7.17 | 2.43 | 68.52 |
| silesia/webster | 41458703 | Wuffs | 4.55 | 8.62 | 1.90 | 122.95 |
| silesia/webster | 41458703 | stdx | 2.86 | 5.56 | 1.95 | 86.85 |
| silesia/x-ray | 8474240 | zlib | 12.30 | 23.82 | 1.94 | 323.43 |
| silesia/x-ray | 8474240 | zlib-ng | 9.06 | 17.39 | 1.92 | 124.35 |
| silesia/x-ray | 8474240 | libdeflate | 6.57 | 15.26 | 2.32 | 124.51 |
| silesia/x-ray | 8474240 | Wuffs | 10.14 | 20.40 | 2.01 | 191.81 |
| silesia/x-ray | 8474240 | stdx | 6.22 | 11.49 | 1.85 | 137.16 |
| silesia/xml | 5345280 | zlib | 3.61 | 8.20 | 2.27 | 115.26 |
| silesia/xml | 5345280 | zlib-ng | 1.99 | 3.88 | 1.95 | 42.46 |
| silesia/xml | 5345280 | libdeflate | 1.37 | 3.33 | 2.44 | 31.94 |
| silesia/xml | 5345280 | Wuffs | 2.21 | 4.14 | 1.88 | 60.99 |
| silesia/xml | 5345280 | stdx | 1.33 | 2.65 | 1.99 | 41.58 |
| canterbury/alice29.txt | 152089 | zlib | 7.56 | 15.08 | 1.99 | 283.43 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.93 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.18 | 8.96 | 2.81 | 55.27 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.70 | 10.37 | 2.20 | 97.28 |
| canterbury/alice29.txt | 152089 | stdx | 2.72 | 6.99 | 2.57 | 62.85 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.11 | 16.11 | 1.99 | 300.70 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.10 | 10.86 | 2.13 | 75.09 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.61 | 9.82 | 2.72 | 69.12 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.09 | 11.34 | 2.23 | 99.39 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.06 | 7.52 | 2.46 | 76.96 |
| canterbury/cp.html | 24603 | zlib | 6.41 | 14.20 | 2.22 | 164.85 |
| canterbury/cp.html | 24603 | zlib-ng | 4.24 | 9.50 | 2.24 | 41.42 |
| canterbury/cp.html | 24603 | libdeflate | 2.80 | 7.95 | 2.84 | 11.99 |
| canterbury/cp.html | 24603 | Wuffs | 4.47 | 10.87 | 2.43 | 55.65 |
| canterbury/cp.html | 24603 | stdx | 2.68 | 7.19 | 2.68 | 12.85 |
| canterbury/fields.c | 11150 | zlib | 4.45 | 14.65 | 3.29 | 27.98 |
| canterbury/fields.c | 11150 | zlib-ng | 3.92 | 10.20 | 2.60 | 17.51 |
| canterbury/fields.c | 11150 | libdeflate | 2.78 | 8.32 | 3.00 | 1.65 |
| canterbury/fields.c | 11150 | Wuffs | 3.87 | 11.51 | 2.98 | 12.26 |
| canterbury/fields.c | 11150 | stdx | 2.52 | 7.64 | 3.04 | 5.86 |
| canterbury/grammar.lsp | 3721 | zlib | 6.07 | 21.22 | 3.49 | 1.59 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.85 | 17.48 | 2.99 | 9.75 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.39 | 12.05 | 2.75 | 0.41 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.98 | 18.87 | 3.16 | 4.10 |
| canterbury/grammar.lsp | 3721 | stdx | 3.84 | 12.18 | 3.17 | 1.25 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.94 | 12.20 | 3.09 | 47.71 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.63 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.22 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.21 | 8.67 | 2.70 | 14.91 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.66 | 2.66 | 16.77 |
| canterbury/lcet10.txt | 426754 | zlib | 7.35 | 14.53 | 1.98 | 277.95 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 60.11 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.02 | 8.48 | 2.81 | 54.29 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.57 | 9.85 | 2.16 | 100.55 |
| canterbury/lcet10.txt | 426754 | stdx | 2.60 | 6.42 | 2.47 | 67.00 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.30 | 16.53 | 1.99 | 310.80 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.30 | 11.19 | 2.11 | 79.65 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.71 | 76.87 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.17 | 11.53 | 2.23 | 99.10 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.15 | 7.63 | 2.42 | 85.48 |
| canterbury/ptt5 | 513216 | zlib | 4.40 | 7.79 | 1.77 | 99.61 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.01 | 3.74 | 1.87 | 46.89 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.09 | 38.03 |
| canterbury/ptt5 | 513216 | Wuffs | 2.20 | 4.02 | 1.83 | 58.63 |
| canterbury/ptt5 | 513216 | stdx | 1.45 | 2.55 | 1.76 | 49.30 |
| canterbury/sum | 38240 | zlib | 7.26 | 14.98 | 2.06 | 214.07 |
| canterbury/sum | 38240 | zlib-ng | 4.67 | 10.02 | 2.15 | 59.28 |
| canterbury/sum | 38240 | libdeflate | 3.40 | 8.34 | 2.46 | 43.63 |
| canterbury/sum | 38240 | Wuffs | 5.09 | 11.41 | 2.24 | 81.04 |
| canterbury/sum | 38240 | stdx | 3.02 | 7.73 | 2.56 | 28.47 |
| canterbury/xargs.1 | 4227 | zlib | 6.57 | 22.08 | 3.36 | 7.55 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.42 | 17.97 | 2.80 | 12.74 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.75 | 13.27 | 2.79 | 0.90 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.51 | 19.63 | 3.02 | 10.40 |
| canterbury/xargs.1 | 4227 | stdx | 4.25 | 12.86 | 3.03 | 2.73 |
| canterbury-large/E.coli | 4638690 | zlib | 5.95 | 14.55 | 2.45 | 174.96 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.25 | 9.68 | 2.28 | 47.61 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.92 | 48.63 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.02 | 9.64 | 2.40 | 61.55 |
| canterbury-large/E.coli | 4638690 | stdx | 2.49 | 6.72 | 2.70 | 54.09 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.71 | 13.26 | 1.98 | 257.36 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.79 | 8.26 | 2.18 | 53.87 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.63 | 7.45 | 2.84 | 45.84 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.17 | 8.72 | 2.09 | 100.17 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.25 | 5.57 | 2.48 | 55.79 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.93 | 12.69 | 1.83 | 269.93 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.19 | 7.78 | 1.86 | 90.85 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.33 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.52 | 8.44 | 1.87 | 129.04 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.73 | 5.40 | 1.98 | 90.33 |
| http/html-1kx1024 | 1048576 | zlib | 15.38 | 32.44 | 2.11 | 348.37 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.67 | 28.43 | 2.24 | 216.63 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.50 | 20.05 | 1.91 | 156.66 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.58 | 35.05 | 2.40 | 263.37 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 137.08 |
| http/html-16kx64 | 1048576 | zlib | 5.96 | 11.79 | 1.98 | 213.20 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 84.80 |
| http/html-16kx64 | 1048576 | libdeflate | 2.64 | 6.04 | 2.29 | 60.65 |
| http/html-16kx64 | 1048576 | Wuffs | 4.27 | 8.51 | 1.99 | 116.88 |
| http/html-16kx64 | 1048576 | stdx | 2.53 | 5.56 | 2.20 | 59.76 |
| http/html-1m | 1048576 | zlib | 4.63 | 9.51 | 2.05 | 171.69 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 59.86 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.57 |
| http/html-1m | 1048576 | Wuffs | 2.96 | 5.42 | 1.83 | 90.04 |
| http/html-1m | 1048576 | stdx | 1.65 | 3.46 | 2.10 | 52.49 |
| http/json-1kx1024 | 1048576 | zlib | 9.26 | 20.83 | 2.25 | 190.87 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.26 | 130.77 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.77 | 16.72 | 1.91 | 93.47 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.41 | 31.72 | 2.78 | 145.94 |
| http/json-1kx1024 | 1048576 | stdx | 5.03 | 13.12 | 2.61 | 80.72 |
| http/json-16kx64 | 1048576 | zlib | 3.91 | 9.62 | 2.46 | 100.68 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.60 |
| http/json-16kx64 | 1048576 | libdeflate | 1.92 | 4.24 | 2.21 | 40.79 |
| http/json-16kx64 | 1048576 | Wuffs | 2.82 | 6.35 | 2.25 | 58.51 |
| http/json-16kx64 | 1048576 | stdx | 1.75 | 3.97 | 2.26 | 39.17 |
| http/json-1m | 1048576 | zlib | 3.24 | 8.25 | 2.55 | 81.64 |
| http/json-1m | 1048576 | zlib-ng | 1.94 | 3.91 | 2.01 | 37.36 |
| http/json-1m | 1048576 | libdeflate | 1.39 | 3.33 | 2.40 | 32.90 |
| http/json-1m | 1048576 | Wuffs | 2.05 | 4.29 | 2.09 | 44.39 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.01 | 40.09 |
| http/js-1kx1024 | 1048576 | zlib | 16.87 | 35.33 | 2.09 | 401.40 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.78 | 31.25 | 2.27 | 239.06 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.20 | 21.58 | 1.93 | 180.14 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.75 | 37.71 | 2.39 | 295.67 |
| http/js-1kx1024 | 1048576 | stdx | 9.27 | 22.85 | 2.46 | 158.64 |
| http/js-16kx64 | 1048576 | zlib | 6.87 | 13.06 | 1.90 | 253.84 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.98 | 91.68 |
| http/js-16kx64 | 1048576 | libdeflate | 3.06 | 7.01 | 2.29 | 72.36 |
| http/js-16kx64 | 1048576 | Wuffs | 4.85 | 9.70 | 2.00 | 130.26 |
| http/js-16kx64 | 1048576 | stdx | 3.01 | 6.54 | 2.17 | 72.51 |
| http/js-1m | 1048576 | zlib | 5.15 | 10.26 | 1.99 | 194.77 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 60.17 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.98 |
| http/js-1m | 1048576 | Wuffs | 3.26 | 6.10 | 1.87 | 95.98 |
| http/js-1m | 1048576 | stdx | 1.81 | 3.89 | 2.15 | 55.00 |
| http/css-1kx1024 | 1048576 | zlib | 12.69 | 27.18 | 2.14 | 280.53 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.24 | 23.04 | 2.25 | 170.29 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.09 | 17.37 | 1.91 | 122.26 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.02 | 29.48 | 2.45 | 208.16 |
| http/css-1kx1024 | 1048576 | stdx | 6.68 | 17.64 | 2.64 | 100.27 |
| http/css-16kx64 | 1048576 | zlib | 4.62 | 10.12 | 2.19 | 150.40 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.77 | 6.07 | 2.19 | 49.73 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 30.30 |
| http/css-16kx64 | 1048576 | Wuffs | 3.13 | 6.97 | 2.23 | 70.68 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.54 | 28.15 |
| http/css-1m | 1048576 | zlib | 3.36 | 8.00 | 2.38 | 106.36 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.21 | 28.96 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.97 | 12.86 |
| http/css-1m | 1048576 | Wuffs | 1.91 | 4.08 | 2.13 | 44.87 |
| http/css-1m | 1048576 | stdx | 1.02 | 2.56 | 2.52 | 21.32 |
| shuffled/dickens-1m | 1048576 | zlib | 12.73 | 22.42 | 1.76 | 372.76 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.71 | 16.72 | 1.72 | 195.72 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.01 | 14.95 | 2.13 | 191.81 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.70 | 18.95 | 1.95 | 206.39 |
| shuffled/dickens-1m | 1048576 | stdx | 7.07 | 11.89 | 1.68 | 207.32 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.63 | 14.04 | 3.87 | 3.54 |
| silesia/dickens | 10192446 | stdx | 3.73 | 12.47 | 3.34 | 3.72 |
| silesia/mozilla | 51220480 | libzstd | 2.88 | 9.62 | 3.33 | 30.30 |
| silesia/mozilla | 51220480 | stdx | 2.90 | 9.68 | 3.34 | 15.96 |
| silesia/mr | 9970564 | libzstd | 3.09 | 11.98 | 3.87 | 6.19 |
| silesia/mr | 9970564 | stdx | 3.18 | 10.83 | 3.40 | 5.27 |
| silesia/nci | 33553445 | libzstd | 1.72 | 4.84 | 2.81 | 24.12 |
| silesia/nci | 33553445 | stdx | 1.94 | 4.63 | 2.39 | 13.66 |
| silesia/ooffice | 6152192 | libzstd | 3.45 | 12.14 | 3.52 | 31.43 |
| silesia/ooffice | 6152192 | stdx | 3.41 | 12.40 | 3.63 | 12.50 |
| silesia/osdb | 10085684 | libzstd | 2.41 | 8.44 | 3.50 | 15.19 |
| silesia/osdb | 10085684 | stdx | 2.49 | 8.11 | 3.25 | 15.37 |
| silesia/reymont | 6627202 | libzstd | 3.32 | 11.61 | 3.49 | 11.64 |
| silesia/reymont | 6627202 | stdx | 3.49 | 10.36 | 2.97 | 13.01 |
| silesia/samba | 21606400 | libzstd | 2.17 | 7.39 | 3.41 | 18.82 |
| silesia/samba | 21606400 | stdx | 2.30 | 6.83 | 2.96 | 17.66 |
| silesia/sao | 7251944 | libzstd | 3.88 | 12.69 | 3.27 | 26.54 |
| silesia/sao | 7251944 | stdx | 3.63 | 12.58 | 3.47 | 6.32 |
| silesia/webster | 41458703 | libzstd | 3.33 | 11.22 | 3.37 | 16.26 |
| silesia/webster | 41458703 | stdx | 3.53 | 10.05 | 2.85 | 17.72 |
| silesia/x-ray | 8474240 | libzstd | 4.01 | 14.93 | 3.72 | 18.83 |
| silesia/x-ray | 8474240 | stdx | 3.68 | 13.23 | 3.60 | 8.54 |
| silesia/xml | 5345280 | libzstd | 1.55 | 5.55 | 3.58 | 22.92 |
| silesia/xml | 5345280 | stdx | 1.54 | 5.16 | 3.36 | 17.16 |
| canterbury/alice29.txt | 152089 | libzstd | 3.35 | 16.18 | 4.83 | 4.18 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.36 | 0.41 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.00 | 14.25 | 4.75 | 3.33 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.30 | 0.26 |
| canterbury/cp.html | 24603 | libzstd | 2.67 | 10.74 | 4.02 | 9.31 |
| canterbury/cp.html | 24603 | stdx | 2.52 | 10.42 | 4.13 | 0.28 |
| canterbury/fields.c | 11150 | libzstd | 3.13 | 13.61 | 4.35 | 9.68 |
| canterbury/fields.c | 11150 | stdx | 3.00 | 12.72 | 4.24 | 0.08 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.23 | 16.93 | 4.00 | 5.96 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.54 | 4.02 | 0.40 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.49 | 11.22 | 4.51 | 7.65 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.68 | 11.32 | 4.22 | 0.96 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.73 | 12.87 | 4.71 | 5.28 |
| canterbury/lcet10.txt | 426754 | stdx | 2.73 | 11.52 | 4.22 | 4.08 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.18 | 15.14 | 4.76 | 1.56 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.20 | 13.51 | 4.22 | 0.88 |
| canterbury/ptt5 | 513216 | libzstd | 1.47 | 4.50 | 3.05 | 24.38 |
| canterbury/ptt5 | 513216 | stdx | 1.36 | 4.46 | 3.28 | 13.06 |
| canterbury/sum | 38240 | libzstd | 2.65 | 10.51 | 3.96 | 11.22 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.09 | 0.33 |
| canterbury/xargs.1 | 4227 | libzstd | 4.29 | 17.40 | 4.06 | 10.69 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 17.17 | 4.06 | 0.34 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.13 | 13.63 | 4.35 | 2.18 |
| canterbury-large/E.coli | 4638690 | stdx | 3.18 | 12.04 | 3.79 | 3.01 |
| canterbury-large/bible.txt | 4047392 | libzstd | 3.04 | 11.99 | 3.95 | 8.50 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.15 | 10.64 | 3.38 | 9.32 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.57 | 9.59 | 3.73 | 19.96 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.68 | 8.64 | 3.23 | 21.34 |
| http/html-1kx1024 | 1048576 | libzstd | 7.43 | 21.63 | 2.91 | 63.31 |
| http/html-1kx1024 | 1048576 | stdx | 7.43 | 22.46 | 3.02 | 76.31 |
| http/html-16kx64 | 1048576 | libzstd | 2.67 | 10.15 | 3.80 | 29.00 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.60 | 31.08 |
| http/html-1m | 1048576 | libzstd | 2.01 | 7.86 | 3.91 | 24.53 |
| http/html-1m | 1048576 | stdx | 2.01 | 7.12 | 3.54 | 24.94 |
| http/json-1kx1024 | 1048576 | libzstd | 6.41 | 17.37 | 2.71 | 50.17 |
| http/json-1kx1024 | 1048576 | stdx | 6.19 | 17.86 | 2.88 | 53.67 |
| http/json-16kx64 | 1048576 | libzstd | 2.06 | 7.22 | 3.51 | 28.27 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 19.95 |
| http/json-1m | 1048576 | libzstd | 1.73 | 6.04 | 3.50 | 27.98 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.62 | 14.62 |
| http/js-1kx1024 | 1048576 | libzstd | 8.45 | 26.38 | 3.12 | 73.11 |
| http/js-1kx1024 | 1048576 | stdx | 9.01 | 27.60 | 3.06 | 113.78 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.71 | 3.99 | 24.50 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.73 | 27.00 |
| http/js-1m | 1048576 | libzstd | 2.07 | 8.18 | 3.94 | 20.54 |
| http/js-1m | 1048576 | stdx | 2.18 | 7.48 | 3.42 | 21.78 |
| http/css-1kx1024 | 1048576 | libzstd | 7.06 | 19.70 | 2.79 | 54.65 |
| http/css-1kx1024 | 1048576 | stdx | 6.83 | 19.96 | 2.92 | 63.73 |
| http/css-16kx64 | 1048576 | libzstd | 2.25 | 8.69 | 3.86 | 23.84 |
| http/css-16kx64 | 1048576 | stdx | 2.28 | 8.43 | 3.70 | 22.36 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.57 | 3.84 | 5.63 |
| http/css-1m | 1048576 | stdx | 0.73 | 2.49 | 3.42 | 4.36 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.81 | 9.40 | 3.35 | 28.63 |
| shuffled/dickens-1m | 1048576 | stdx | 2.76 | 9.19 | 3.33 | 12.62 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.60 | 17.04 | 2.24 | 101.33 |
| silesia/dickens | 1048576 | stdx | 5.13 | 12.38 | 2.41 | 54.66 |
| silesia/mozilla | 1048576 | Google | 13.59 | 27.77 | 2.04 | 46.82 |
| silesia/mozilla | 1048576 | stdx | 8.34 | 15.02 | 1.80 | 47.91 |
| silesia/mr | 1048576 | Google | 8.97 | 20.24 | 2.26 | 102.31 |
| silesia/mr | 1048576 | stdx | 5.83 | 13.25 | 2.27 | 88.56 |
| silesia/nci | 1048576 | Google | 2.58 | 5.69 | 2.21 | 51.60 |
| silesia/nci | 1048576 | stdx | 1.95 | 3.95 | 2.02 | 54.73 |
| silesia/ooffice | 1048576 | Google | 14.26 | 29.28 | 2.05 | 287.52 |
| silesia/ooffice | 1048576 | stdx | 11.06 | 20.33 | 1.84 | 323.44 |
| silesia/osdb | 1048576 | Google | 8.27 | 17.38 | 2.10 | 96.22 |
| silesia/osdb | 1048576 | stdx | 5.19 | 10.57 | 2.04 | 91.73 |
| silesia/reymont | 1048576 | Google | 5.46 | 12.73 | 2.33 | 81.68 |
| silesia/reymont | 1048576 | stdx | 3.75 | 9.25 | 2.46 | 47.86 |
| silesia/samba | 1048576 | Google | 7.63 | 16.22 | 2.12 | 95.95 |
| silesia/samba | 1048576 | stdx | 5.10 | 10.71 | 2.10 | 67.26 |
| silesia/sao | 1048576 | Google | 16.90 | 36.97 | 2.19 | 162.35 |
| silesia/sao | 1048576 | stdx | 10.51 | 22.65 | 2.16 | 141.96 |
| silesia/webster | 1048576 | Google | 6.63 | 14.07 | 2.12 | 115.24 |
| silesia/webster | 1048576 | stdx | 4.46 | 9.98 | 2.24 | 68.92 |
| silesia/x-ray | 1048576 | Google | 19.41 | 38.46 | 1.98 | 234.22 |
| silesia/x-ray | 1048576 | stdx | 15.02 | 30.18 | 2.01 | 235.25 |
| silesia/xml | 1048576 | Google | 3.48 | 7.65 | 2.19 | 65.48 |
| silesia/xml | 1048576 | stdx | 2.42 | 5.40 | 2.23 | 46.90 |
| canterbury/alice29.txt | 152089 | Google | 8.92 | 20.66 | 2.32 | 136.68 |
| canterbury/alice29.txt | 152089 | stdx | 6.09 | 15.33 | 2.52 | 79.66 |
| canterbury/asyoulik.txt | 125179 | Google | 10.45 | 23.83 | 2.28 | 172.03 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.09 | 17.43 | 2.46 | 102.30 |
| canterbury/cp.html | 24603 | Google | 9.12 | 22.18 | 2.43 | 109.88 |
| canterbury/cp.html | 24603 | stdx | 5.99 | 17.15 | 2.86 | 48.30 |
| canterbury/fields.c | 11150 | Google | 7.03 | 21.25 | 3.02 | 20.51 |
| canterbury/fields.c | 11150 | stdx | 4.89 | 17.08 | 3.49 | 1.28 |
| canterbury/grammar.lsp | 3721 | Google | 9.84 | 30.23 | 3.07 | 4.98 |
| canterbury/grammar.lsp | 3721 | stdx | 7.18 | 25.04 | 3.49 | 1.20 |
| canterbury/kennedy.xls | 1029744 | Google | 5.50 | 17.05 | 3.10 | 37.20 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.84 | 12.94 | 3.37 | 34.00 |
| canterbury/lcet10.txt | 426754 | Google | 7.79 | 17.42 | 2.24 | 130.46 |
| canterbury/lcet10.txt | 426754 | stdx | 5.23 | 12.96 | 2.48 | 65.58 |
| canterbury/plrabn12.txt | 481861 | Google | 9.14 | 20.94 | 2.29 | 134.50 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.17 | 15.04 | 2.44 | 87.31 |
| canterbury/ptt5 | 513216 | Google | 4.30 | 10.36 | 2.41 | 61.72 |
| canterbury/ptt5 | 513216 | stdx | 2.35 | 4.89 | 2.08 | 64.79 |
| canterbury/sum | 38240 | Google | 10.88 | 26.44 | 2.43 | 158.61 |
| canterbury/sum | 38240 | stdx | 8.32 | 21.11 | 2.54 | 154.76 |
| canterbury/xargs.1 | 4227 | Google | 10.92 | 34.81 | 3.19 | 8.94 |
| canterbury/xargs.1 | 4227 | stdx | 8.52 | 30.44 | 3.57 | 6.80 |
| canterbury-large/E.coli | 1048576 | Google | 7.48 | 19.44 | 2.60 | 1.39 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.08 |
| canterbury-large/bible.txt | 1048576 | Google | 5.37 | 12.38 | 2.31 | 81.23 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.56 | 8.93 | 2.51 | 39.89 |
| canterbury-large/world192.txt | 1048576 | Google | 6.27 | 12.88 | 2.05 | 115.65 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.47 | 9.38 | 2.10 | 77.30 |
| http/html-1kx1024 | 1048576 | Google | 17.92 | 42.09 | 2.35 | 387.27 |
| http/html-1kx1024 | 1048576 | stdx | 15.37 | 37.56 | 2.44 | 360.17 |
| http/html-16kx64 | 1048576 | Google | 6.77 | 14.88 | 2.20 | 149.70 |
| http/html-16kx64 | 1048576 | stdx | 5.18 | 12.15 | 2.35 | 114.03 |
| http/html-1m | 1048576 | Google | 4.09 | 8.99 | 2.20 | 83.44 |
| http/html-1m | 1048576 | stdx | 2.89 | 6.52 | 2.26 | 54.74 |
| http/json-1kx1024 | 1048576 | Google | 14.28 | 36.74 | 2.57 | 239.56 |
| http/json-1kx1024 | 1048576 | stdx | 13.01 | 33.63 | 2.59 | 276.65 |
| http/json-16kx64 | 1048576 | Google | 4.42 | 11.42 | 2.58 | 81.22 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.49 | 83.51 |
| http/json-1m | 1048576 | Google | 3.42 | 8.66 | 2.53 | 58.66 |
| http/json-1m | 1048576 | stdx | 2.47 | 5.99 | 2.43 | 57.91 |
| http/js-1kx1024 | 1048576 | Google | 19.80 | 46.38 | 2.34 | 426.91 |
| http/js-1kx1024 | 1048576 | stdx | 16.48 | 39.90 | 2.42 | 382.79 |
| http/js-16kx64 | 1048576 | Google | 8.08 | 17.79 | 2.20 | 167.19 |
| http/js-16kx64 | 1048576 | stdx | 6.06 | 14.36 | 2.37 | 125.28 |
| http/js-1m | 1048576 | Google | 4.41 | 9.60 | 2.18 | 83.81 |
| http/js-1m | 1048576 | stdx | 3.20 | 7.25 | 2.27 | 55.34 |
| http/css-1kx1024 | 1048576 | Google | 15.32 | 37.48 | 2.45 | 292.27 |
| http/css-1kx1024 | 1048576 | stdx | 13.87 | 34.70 | 2.50 | 303.16 |
| http/css-16kx64 | 1048576 | Google | 4.97 | 11.78 | 2.37 | 101.13 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.48 | 80.42 |
| http/css-1m | 1048576 | Google | 2.44 | 9.43 | 3.86 | 16.70 |
| http/css-1m | 1048576 | stdx | 0.76 | 1.86 | 2.45 | 12.07 |
| shuffled/dickens-1m | 1048576 | Google | 9.65 | 20.34 | 2.11 | 107.84 |
| shuffled/dickens-1m | 1048576 | stdx | 8.79 | 14.53 | 1.65 | 118.83 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.27 | 36.91 | 2.42 | 411.03 |
| silesia/dickens | 10192446 | 1 | stdx | 16.39 | 38.17 | 2.33 | 358.95 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.18 | 87.63 | 1.68 | 691.94 |
| silesia/dickens | 10192446 | 6 | stdx | 49.68 | 84.26 | 1.70 | 1450.91 |
| silesia/dickens | 10192446 | 9 | libdeflate | 112.01 | 160.47 | 1.43 | 926.58 |
| silesia/dickens | 10192446 | 9 | stdx | 84.86 | 191.80 | 2.26 | 1725.35 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.12 | 32.62 | 2.31 | 437.33 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.41 | 30.24 | 2.25 | 296.02 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.89 | 70.83 | 2.15 | 577.41 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.52 | 69.96 | 2.22 | 729.35 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.58 | 221.49 | 1.74 | 767.75 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.96 | 126.12 | 2.58 | 787.31 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.99 | 35.02 | 2.92 | 229.43 |
| silesia/mr | 9970564 | 1 | stdx | 12.63 | 34.08 | 2.70 | 188.47 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.29 | 80.54 | 2.10 | 435.62 |
| silesia/mr | 9970564 | 6 | stdx | 39.88 | 83.18 | 2.09 | 980.88 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.66 | 165.48 | 1.69 | 754.59 |
| silesia/mr | 9970564 | 9 | stdx | 86.80 | 206.31 | 2.38 | 1325.83 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.24 | 18.42 | 2.95 | 115.41 |
| silesia/nci | 33553445 | 1 | stdx | 4.99 | 10.88 | 2.18 | 98.05 |
| silesia/nci | 33553445 | 6 | libdeflate | 17.02 | 34.84 | 2.05 | 225.34 |
| silesia/nci | 33553445 | 6 | stdx | 14.36 | 29.54 | 2.06 | 390.38 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.45 | 105.28 | 1.69 | 500.37 |
| silesia/nci | 33553445 | 9 | stdx | 33.06 | 80.63 | 2.44 | 651.51 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.94 | 39.15 | 1.96 | 753.24 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.81 | 39.08 | 2.19 | 430.42 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 41.13 | 79.10 | 1.92 | 954.65 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.49 | 87.83 | 2.12 | 998.27 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.69 | 127.63 | 1.71 | 1132.06 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.44 | 129.17 | 2.46 | 930.11 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.94 | 30.15 | 2.33 | 353.88 |
| silesia/osdb | 10085684 | 1 | stdx | 12.98 | 27.86 | 2.15 | 294.83 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.37 | 55.67 | 1.96 | 488.52 |
| silesia/osdb | 10085684 | 6 | stdx | 27.04 | 57.40 | 2.12 | 562.84 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.95 | 64.15 | 1.89 | 551.51 |
| silesia/osdb | 10085684 | 9 | stdx | 35.48 | 87.23 | 2.46 | 688.92 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.64 | 32.88 | 2.60 | 311.64 |
| silesia/reymont | 6627202 | 1 | stdx | 13.50 | 33.24 | 2.46 | 272.89 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.19 | 86.58 | 1.80 | 518.69 |
| silesia/reymont | 6627202 | 6 | stdx | 45.38 | 76.82 | 1.69 | 1433.42 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.32 | 276.14 | 1.39 | 827.49 |
| silesia/reymont | 6627202 | 9 | stdx | 87.18 | 189.97 | 2.18 | 1611.03 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.45 | 26.53 | 2.54 | 271.81 |
| silesia/samba | 21606400 | 1 | stdx | 9.92 | 22.23 | 2.24 | 221.17 |
| silesia/samba | 21606400 | 6 | libdeflate | 29.02 | 58.79 | 2.03 | 384.47 |
| silesia/samba | 21606400 | 6 | stdx | 24.13 | 49.84 | 2.07 | 622.63 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.28 | 141.44 | 1.68 | 503.12 |
| silesia/samba | 21606400 | 9 | stdx | 41.52 | 102.63 | 2.47 | 731.25 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.73 | 47.87 | 2.20 | 684.45 |
| silesia/sao | 7251944 | 1 | stdx | 19.16 | 49.92 | 2.61 | 346.25 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.29 | 96.89 | 1.89 | 963.25 |
| silesia/sao | 7251944 | 6 | stdx | 47.13 | 105.65 | 2.24 | 858.91 |
| silesia/sao | 7251944 | 9 | libdeflate | 71.06 | 120.26 | 1.69 | 1098.83 |
| silesia/sao | 7251944 | 9 | stdx | 55.49 | 138.16 | 2.49 | 843.00 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.10 | 30.45 | 2.32 | 386.74 |
| silesia/webster | 41458703 | 1 | stdx | 13.88 | 29.08 | 2.10 | 340.27 |
| silesia/webster | 41458703 | 6 | libdeflate | 37.10 | 66.02 | 1.78 | 570.01 |
| silesia/webster | 41458703 | 6 | stdx | 35.10 | 60.88 | 1.73 | 1104.50 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.75 | 138.85 | 1.47 | 754.78 |
| silesia/webster | 41458703 | 9 | stdx | 60.69 | 135.96 | 2.24 | 1296.32 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.66 | 49.67 | 2.10 | 781.04 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.64 | 50.81 | 2.88 | 261.56 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.92 | 82.77 | 2.51 | 852.90 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.85 | 98.11 | 2.90 | 535.79 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.52 | 91.03 | 2.43 | 1031.48 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.79 | 122.05 | 2.99 | 466.11 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.81 | 21.59 | 2.76 | 176.01 |
| silesia/xml | 5345280 | 1 | stdx | 6.98 | 15.66 | 2.24 | 155.14 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.30 | 40.51 | 1.90 | 263.79 |
| silesia/xml | 5345280 | 6 | stdx | 17.72 | 34.32 | 1.94 | 496.01 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.82 | 89.17 | 1.52 | 370.86 |
| silesia/xml | 5345280 | 9 | stdx | 31.14 | 72.83 | 2.34 | 599.23 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.23 | 35.61 | 2.50 | 377.76 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.06 | 36.12 | 2.40 | 336.69 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.71 | 82.29 | 1.76 | 637.22 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.78 | 77.43 | 1.77 | 1317.27 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.64 | 159.21 | 1.48 | 848.08 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 72.56 | 167.73 | 2.31 | 1512.45 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.15 | 37.20 | 2.46 | 416.37 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.79 | 37.43 | 2.37 | 359.76 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.37 | 85.43 | 1.77 | 712.50 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.09 | 81.93 | 1.78 | 1379.73 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 89.11 | 136.15 | 1.53 | 941.32 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 75.51 | 175.97 | 2.33 | 1608.26 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.57 | 32.02 | 2.77 | 274.83 |
| canterbury/cp.html | 24603 | 1 | stdx | 11.06 | 27.13 | 2.45 | 245.53 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 26.94 | 62.33 | 2.31 | 481.20 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.93 | 57.06 | 2.38 | 628.42 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.94 | 91.97 | 1.96 | 600.31 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.33 | 88.89 | 2.84 | 642.08 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.28 | 35.92 | 3.87 | 50.53 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.15 | 30.05 | 3.69 | 20.11 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.28 | 69.37 | 2.86 | 233.66 |
| canterbury/fields.c | 11150 | 6 | stdx | 21.25 | 57.62 | 2.71 | 433.91 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.72 | 100.81 | 2.25 | 434.98 |
| canterbury/fields.c | 11150 | 9 | stdx | 29.04 | 92.66 | 3.19 | 472.80 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 12.99 | 51.51 | 3.97 | 13.25 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 10.17 | 39.01 | 3.83 | 2.35 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.80 | 87.06 | 3.66 | 29.44 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.81 | 70.81 | 3.98 | 17.03 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.63 | 102.89 | 3.36 | 37.94 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 24.37 | 99.31 | 4.08 | 70.11 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.38 | 27.18 | 3.68 | 65.55 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.04 | 22.58 | 3.21 | 62.86 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.94 | 73.85 | 2.64 | 95.94 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.37 | 61.99 | 3.20 | 137.46 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.33 | 664.23 | 1.83 | 163.08 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.65 | 130.89 | 3.48 | 219.86 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.76 | 33.99 | 2.47 | 369.45 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.49 | 33.92 | 2.34 | 330.64 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.14 | 78.22 | 1.73 | 606.08 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.61 | 73.43 | 1.76 | 1218.40 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.96 | 136.94 | 1.49 | 804.13 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 70.55 | 162.24 | 2.30 | 1449.32 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.80 | 38.62 | 2.44 | 426.53 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.73 | 40.24 | 2.41 | 369.68 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.19 | 91.90 | 1.70 | 749.26 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.55 | 88.90 | 1.72 | 1508.37 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 117.14 | 166.26 | 1.42 | 1003.07 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 88.65 | 201.33 | 2.27 | 1805.01 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.41 | 18.61 | 2.90 | 141.60 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.99 | 11.03 | 2.21 | 123.74 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.25 | 36.17 | 2.54 | 218.54 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.35 | 29.58 | 2.39 | 310.51 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.43 | 120.86 | 2.00 | 373.67 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.13 | 130.09 | 3.02 | 643.49 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.84 | 33.49 | 2.61 | 341.34 |
| canterbury/sum | 38240 | 1 | stdx | 12.76 | 29.36 | 2.30 | 306.23 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.63 | 69.87 | 2.44 | 497.87 |
| canterbury/sum | 38240 | 6 | stdx | 26.83 | 65.74 | 2.45 | 660.24 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.17 | 181.91 | 1.93 | 604.99 |
| canterbury/sum | 38240 | 9 | stdx | 39.37 | 112.33 | 2.85 | 658.42 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.27 | 53.06 | 4.00 | 22.69 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.91 | 43.10 | 3.95 | 2.65 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 23.11 | 87.70 | 3.79 | 76.63 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 18.86 | 74.35 | 3.94 | 40.69 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 24.98 | 94.34 | 3.78 | 93.03 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.71 | 106.96 | 4.00 | 121.95 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.06 | 40.47 | 3.35 | 164.82 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.66 | 42.29 | 3.34 | 101.38 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.35 | 395.99 | 2.16 | 260.53 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.90 | 374.12 | 3.04 | 1910.70 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 818.32 | 1063.49 | 1.30 | 1324.98 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 230.55 | 755.68 | 3.28 | 2509.24 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.55 | 32.38 | 2.58 | 311.19 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.41 | 32.23 | 2.40 | 281.80 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.18 | 80.12 | 1.73 | 522.00 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.34 | 72.39 | 1.71 | 1265.91 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.92 | 200.28 | 1.41 | 741.65 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.22 | 170.21 | 2.23 | 1444.32 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.30 | 29.72 | 2.23 | 413.20 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.29 | 28.55 | 2.00 | 377.29 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.25 | 60.25 | 1.81 | 557.76 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.09 | 56.80 | 1.77 | 980.66 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.82 | 119.11 | 1.47 | 685.30 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 51.96 | 117.95 | 2.27 | 1150.03 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.45 | 103.92 | 2.93 | 455.31 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 23.56 | 58.63 | 2.49 | 365.19 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.36 | 138.33 | 2.98 | 562.49 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 34.33 | 94.31 | 2.75 | 529.07 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 48.13 | 142.44 | 2.96 | 585.66 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 38.36 | 112.13 | 2.92 | 538.23 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.47 | 27.96 | 2.67 | 267.26 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.09 | 20.25 | 2.23 | 234.07 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.37 | 52.09 | 2.33 | 391.06 |
| http/html-16kx64 | 1048576 | 6 | stdx | 19.14 | 42.86 | 2.24 | 541.73 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 35.11 | 72.54 | 2.07 | 467.28 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.99 | 69.05 | 2.76 | 548.28 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.76 | 23.03 | 2.63 | 223.38 |
| http/html-1m | 1048576 | 1 | stdx | 8.16 | 17.79 | 2.18 | 205.99 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.39 | 49.53 | 1.95 | 327.81 |
| http/html-1m | 1048576 | 6 | stdx | 21.30 | 40.71 | 1.91 | 621.83 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.37 | 109.24 | 1.53 | 431.39 |
| http/html-1m | 1048576 | 9 | stdx | 35.87 | 85.76 | 2.39 | 707.78 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.80 | 94.80 | 2.98 | 302.12 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 18.60 | 45.16 | 2.43 | 242.58 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.14 | 126.60 | 2.93 | 373.17 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 29.24 | 78.37 | 2.68 | 376.99 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.47 | 142.45 | 2.71 | 432.27 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 33.02 | 95.56 | 2.89 | 385.62 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.86 | 23.85 | 3.04 | 134.61 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.51 | 13.94 | 2.53 | 110.69 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.16 | 46.61 | 2.57 | 205.56 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.62 | 35.01 | 2.57 | 279.49 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.18 | 151.99 | 1.90 | 297.09 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.36 | 58.45 | 3.02 | 302.08 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.74 | 19.85 | 2.95 | 124.45 |
| http/json-1m | 1048576 | 1 | stdx | 5.08 | 12.51 | 2.46 | 103.40 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.33 | 45.30 | 2.23 | 175.45 |
| http/json-1m | 1048576 | 6 | stdx | 14.74 | 35.09 | 2.38 | 300.96 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.56 | 205.21 | 1.69 | 275.64 |
| http/json-1m | 1048576 | 9 | stdx | 29.03 | 72.87 | 2.51 | 369.66 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.05 | 107.80 | 2.91 | 516.85 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 25.91 | 65.40 | 2.52 | 411.50 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.47 | 144.85 | 2.93 | 678.89 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 37.70 | 104.12 | 2.76 | 618.08 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.99 | 150.13 | 2.89 | 716.57 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 42.59 | 125.13 | 2.94 | 626.48 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.73 | 30.90 | 2.63 | 308.69 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.94 | 24.80 | 2.27 | 273.94 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.86 | 59.43 | 2.30 | 467.70 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.94 | 50.05 | 2.18 | 677.03 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.93 | 83.31 | 2.04 | 567.06 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.78 | 81.30 | 2.73 | 661.42 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.64 | 25.19 | 2.61 | 247.42 |
| http/js-1m | 1048576 | 1 | stdx | 9.55 | 21.31 | 2.23 | 233.18 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.82 | 56.12 | 1.95 | 369.25 |
| http/js-1m | 1048576 | 6 | stdx | 25.00 | 46.64 | 1.87 | 748.01 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.47 | 120.65 | 1.58 | 499.90 |
| http/js-1m | 1048576 | 9 | stdx | 41.90 | 100.01 | 2.39 | 812.30 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.24 | 97.73 | 2.94 | 377.37 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 20.47 | 49.52 | 2.42 | 301.87 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.89 | 129.22 | 2.94 | 477.34 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 31.23 | 82.32 | 2.64 | 504.80 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 46.09 | 133.80 | 2.90 | 507.23 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 35.38 | 99.48 | 2.81 | 521.51 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.64 | 25.60 | 2.96 | 173.54 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.73 | 16.96 | 2.52 | 134.98 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.21 | 48.80 | 2.41 | 288.25 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.66 | 38.00 | 2.28 | 460.80 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.93 | 82.40 | 2.01 | 372.55 |
| http/css-16kx64 | 1048576 | 9 | stdx | 23.18 | 65.13 | 2.81 | 479.35 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.93 | 21.15 | 3.05 | 131.66 |
| http/css-1m | 1048576 | 1 | stdx | 5.82 | 14.91 | 2.56 | 109.60 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.79 | 44.50 | 2.14 | 225.12 |
| http/css-1m | 1048576 | 6 | stdx | 16.68 | 35.61 | 2.14 | 449.78 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.86 | 111.58 | 1.60 | 307.40 |
| http/css-1m | 1048576 | 9 | stdx | 32.02 | 83.00 | 2.59 | 511.27 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.21 | 48.89 | 1.94 | 928.28 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.15 | 49.19 | 2.71 | 324.31 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.65 | 86.45 | 2.08 | 1180.44 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.79 | 88.80 | 2.23 | 853.61 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.15 | 94.50 | 2.00 | 1340.91 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.01 | 134.38 | 2.49 | 1139.92 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.15 | 31.13 | 3.07 | 122.69 |
| silesia/dickens | 10192446 | 1 | stdx | 24.28 | 82.03 | 3.38 | 125.45 |
| silesia/dickens | 10192446 | 3 | libzstd | 24.40 | 35.01 | 1.43 | 173.18 |
| silesia/dickens | 10192446 | 3 | stdx | 37.60 | 78.22 | 2.08 | 182.82 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.06 | 22.57 | 3.20 | 72.10 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.68 | 54.73 | 3.10 | 173.55 |
| silesia/mozilla | 51220480 | 3 | libzstd | 18.72 | 28.71 | 1.53 | 102.38 |
| silesia/mozilla | 51220480 | 3 | stdx | 32.71 | 62.01 | 1.90 | 144.86 |
| silesia/mr | 9970564 | 1 | libzstd | 7.71 | 24.73 | 3.21 | 57.19 |
| silesia/mr | 9970564 | 1 | stdx | 19.99 | 66.82 | 3.34 | 113.57 |
| silesia/mr | 9970564 | 3 | libzstd | 21.78 | 32.97 | 1.51 | 86.86 |
| silesia/mr | 9970564 | 3 | stdx | 35.48 | 72.46 | 2.04 | 114.29 |
| silesia/nci | 33553445 | 1 | libzstd | 3.57 | 9.49 | 2.65 | 58.48 |
| silesia/nci | 33553445 | 1 | stdx | 7.79 | 25.69 | 3.30 | 59.44 |
| silesia/nci | 33553445 | 3 | libzstd | 5.75 | 10.11 | 1.76 | 57.45 |
| silesia/nci | 33553445 | 3 | stdx | 11.78 | 29.15 | 2.47 | 66.46 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.63 | 29.17 | 3.38 | 72.06 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.18 | 72.51 | 3.13 | 179.70 |
| silesia/ooffice | 6152192 | 3 | libzstd | 26.22 | 40.82 | 1.56 | 121.68 |
| silesia/ooffice | 6152192 | 3 | stdx | 44.73 | 82.20 | 1.84 | 185.38 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.17 | 22.22 | 3.10 | 67.14 |
| silesia/osdb | 10085684 | 1 | stdx | 16.48 | 50.52 | 3.06 | 119.41 |
| silesia/osdb | 10085684 | 3 | libzstd | 19.77 | 27.06 | 1.37 | 70.58 |
| silesia/osdb | 10085684 | 3 | stdx | 34.08 | 57.87 | 1.70 | 111.13 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.87 | 27.02 | 2.74 | 155.36 |
| silesia/reymont | 6627202 | 1 | stdx | 20.27 | 72.05 | 3.56 | 96.74 |
| silesia/reymont | 6627202 | 3 | libzstd | 19.60 | 27.53 | 1.40 | 127.74 |
| silesia/reymont | 6627202 | 3 | stdx | 29.31 | 62.18 | 2.12 | 147.59 |
| silesia/samba | 21606400 | 1 | libzstd | 6.01 | 16.80 | 2.80 | 88.36 |
| silesia/samba | 21606400 | 1 | stdx | 13.53 | 42.89 | 3.17 | 124.86 |
| silesia/samba | 21606400 | 3 | libzstd | 12.84 | 19.20 | 1.49 | 100.14 |
| silesia/samba | 21606400 | 3 | stdx | 21.29 | 44.75 | 2.10 | 132.86 |
| silesia/sao | 7251944 | 1 | libzstd | 9.06 | 33.64 | 3.71 | 43.47 |
| silesia/sao | 7251944 | 1 | stdx | 26.06 | 82.03 | 3.15 | 104.00 |
| silesia/sao | 7251944 | 3 | libzstd | 35.01 | 52.14 | 1.49 | 95.59 |
| silesia/sao | 7251944 | 3 | stdx | 54.60 | 95.22 | 1.74 | 142.42 |
| silesia/webster | 41458703 | 1 | libzstd | 8.76 | 24.86 | 2.84 | 135.90 |
| silesia/webster | 41458703 | 1 | stdx | 20.32 | 64.04 | 3.15 | 165.42 |
| silesia/webster | 41458703 | 3 | libzstd | 20.45 | 27.84 | 1.36 | 180.15 |
| silesia/webster | 41458703 | 3 | stdx | 32.54 | 64.55 | 1.98 | 194.92 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.72 | 14.89 | 3.16 | 16.97 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.87 | 76.64 | 3.21 | 91.70 |
| silesia/x-ray | 8474240 | 3 | libzstd | 35.38 | 54.96 | 1.55 | 86.68 |
| silesia/x-ray | 8474240 | 3 | stdx | 50.45 | 92.40 | 1.83 | 105.81 |
| silesia/xml | 5345280 | 1 | libzstd | 4.27 | 11.65 | 2.73 | 72.94 |
| silesia/xml | 5345280 | 1 | stdx | 10.39 | 34.21 | 3.29 | 94.28 |
| silesia/xml | 5345280 | 3 | libzstd | 7.15 | 12.84 | 1.80 | 79.06 |
| silesia/xml | 5345280 | 3 | stdx | 13.13 | 32.28 | 2.46 | 115.34 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.88 | 32.86 | 3.02 | 145.63 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.40 | 76.49 | 3.42 | 187.62 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.68 | 39.93 | 2.55 | 203.32 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.68 | 73.76 | 2.76 | 334.11 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.78 | 33.59 | 3.43 | 110.18 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.52 | 79.00 | 3.36 | 212.06 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.58 | 40.28 | 2.59 | 207.84 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.40 | 79.30 | 2.79 | 372.10 |
| canterbury/cp.html | 24603 | 1 | libzstd | 6.97 | 26.65 | 3.82 | 38.21 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.22 | 57.76 | 3.56 | 127.08 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.35 | 32.88 | 3.51 | 21.71 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.14 | 59.76 | 3.29 | 137.47 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.70 | 31.77 | 3.65 | 35.81 |
| canterbury/fields.c | 11150 | 1 | stdx | 17.08 | 65.73 | 3.85 | 94.18 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.08 | 34.41 | 3.79 | 11.31 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.32 | 64.68 | 3.73 | 91.06 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.52 | 37.98 | 3.99 | 10.48 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.21 | 77.57 | 3.84 | 53.75 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.60 | 43.28 | 4.08 | 2.09 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.40 | 79.60 | 3.72 | 67.02 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.03 | 23.37 | 3.88 | 14.64 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.75 | 56.75 | 3.85 | 83.98 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 9.04 | 24.26 | 2.68 | 27.51 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 21.35 | 56.61 | 2.65 | 107.77 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.94 | 28.42 | 2.86 | 160.76 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.51 | 72.02 | 3.35 | 159.22 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 17.31 | 32.77 | 1.89 | 201.85 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.89 | 67.10 | 2.50 | 297.89 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.37 | 32.28 | 3.11 | 130.22 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.24 | 84.16 | 3.33 | 157.38 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 21.52 | 39.60 | 1.84 | 225.67 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 32.67 | 80.77 | 2.47 | 341.49 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.16 | 8.48 | 2.68 | 67.33 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.55 | 23.15 | 3.06 | 104.18 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 5.24 | 11.28 | 2.15 | 60.01 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.76 | 24.08 | 2.47 | 131.66 |
| canterbury/sum | 38240 | 1 | libzstd | 6.47 | 25.37 | 3.92 | 28.67 |
| canterbury/sum | 38240 | 1 | stdx | 16.84 | 59.13 | 3.51 | 148.89 |
| canterbury/sum | 38240 | 3 | libzstd | 9.24 | 31.64 | 3.42 | 27.95 |
| canterbury/sum | 38240 | 3 | stdx | 19.86 | 61.82 | 3.11 | 179.29 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 10.08 | 39.84 | 3.95 | 13.34 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.84 | 80.38 | 3.86 | 61.62 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.03 | 48.45 | 4.03 | 2.00 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.90 | 83.98 | 3.67 | 80.74 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.53 | 33.29 | 3.16 | 76.07 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.91 | 95.62 | 4.36 | 7.27 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 16.04 | 31.71 | 1.98 | 35.91 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 24.82 | 70.38 | 2.84 | 38.46 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.85 | 27.35 | 2.78 | 154.37 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.48 | 71.86 | 3.51 | 108.27 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 19.20 | 28.64 | 1.49 | 134.97 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 29.46 | 63.36 | 2.15 | 155.73 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.22 | 22.62 | 2.75 | 140.43 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.69 | 55.86 | 2.99 | 192.52 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 16.69 | 24.36 | 1.46 | 176.02 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 26.13 | 51.26 | 1.96 | 236.66 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.11 | 52.52 | 3.07 | 170.81 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.85 | 100.54 | 2.80 | 643.94 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.19 | 59.34 | 3.09 | 206.12 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 38.02 | 104.00 | 2.74 | 638.33 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.87 | 22.47 | 2.86 | 128.35 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.13 | 46.84 | 3.31 | 181.83 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.89 | 24.79 | 2.79 | 146.32 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.62 | 47.61 | 3.05 | 191.84 |
| http/html-1m | 1048576 | 1 | libzstd | 6.36 | 16.66 | 2.62 | 117.82 |
| http/html-1m | 1048576 | 1 | stdx | 13.05 | 42.00 | 3.22 | 134.59 |
| http/html-1m | 1048576 | 3 | libzstd | 9.91 | 18.50 | 1.87 | 126.24 |
| http/html-1m | 1048576 | 3 | stdx | 16.31 | 39.37 | 2.41 | 177.73 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.30 | 42.58 | 2.98 | 118.35 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.60 | 83.13 | 2.81 | 529.35 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.88 | 44.69 | 3.00 | 133.91 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.78 | 84.87 | 2.76 | 533.05 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.83 | 15.00 | 3.11 | 59.43 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.71 | 33.78 | 3.48 | 116.12 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.42 | 16.31 | 3.01 | 73.53 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.79 | 34.58 | 3.21 | 122.23 |
| http/json-1m | 1048576 | 1 | libzstd | 4.07 | 12.47 | 3.07 | 53.18 |
| http/json-1m | 1048576 | 1 | stdx | 9.10 | 30.70 | 3.37 | 85.50 |
| http/json-1m | 1048576 | 3 | libzstd | 6.66 | 14.06 | 2.11 | 69.10 |
| http/json-1m | 1048576 | 3 | stdx | 11.73 | 30.64 | 2.61 | 119.47 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.62 | 57.29 | 3.08 | 198.84 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 39.83 | 113.49 | 2.85 | 693.56 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.51 | 65.62 | 3.05 | 268.75 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.17 | 116.54 | 2.76 | 685.07 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 9.03 | 26.53 | 2.94 | 135.93 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.61 | 55.71 | 3.35 | 200.64 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.20 | 28.96 | 2.84 | 158.52 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.76 | 55.35 | 3.12 | 208.86 |
| http/js-1m | 1048576 | 1 | libzstd | 6.64 | 17.80 | 2.68 | 116.79 |
| http/js-1m | 1048576 | 1 | stdx | 14.09 | 45.88 | 3.26 | 137.69 |
| http/js-1m | 1048576 | 3 | libzstd | 10.74 | 19.49 | 1.81 | 125.35 |
| http/js-1m | 1048576 | 3 | stdx | 17.48 | 41.25 | 2.36 | 187.04 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.61 | 46.97 | 3.01 | 143.53 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.30 | 91.65 | 2.84 | 578.74 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.73 | 50.68 | 3.03 | 165.63 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.92 | 93.63 | 2.76 | 582.86 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.25 | 18.99 | 3.04 | 80.97 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.43 | 43.79 | 3.52 | 138.37 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.60 | 19.53 | 2.96 | 94.40 |
| http/css-16kx64 | 1048576 | 3 | stdx | 13.04 | 42.34 | 3.25 | 152.43 |
| http/css-1m | 1048576 | 1 | libzstd | 1.53 | 4.57 | 3.00 | 22.08 |
| http/css-1m | 1048576 | 1 | stdx | 4.01 | 14.85 | 3.70 | 30.63 |
| http/css-1m | 1048576 | 3 | libzstd | 2.06 | 5.34 | 2.58 | 19.60 |
| http/css-1m | 1048576 | 3 | stdx | 4.03 | 13.33 | 3.31 | 31.59 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.56 | 12.79 | 3.60 | 6.51 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.11 | 30.66 | 3.37 | 61.43 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 31.53 | 53.05 | 1.68 | 47.26 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 21.83 | 47.43 | 2.17 | 206.86 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.5 | 74.2 | 0.118 | 3.01 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 66.5 | 219.6 | 0.086 | 7.85 | 3.30 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 37.4 | 163.0 | 0.069 | 4.42 | 4.36 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 250.7 | 1024.0 | 0.817 | 29.61 | 4.08 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.4 | 107.5 | 0.139 | 3.60 | 3.53 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.0 | 106.0 | 0.294 | 3.31 | 3.78 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.1 | 378.2 | 0.365 | 11.23 | 3.98 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.7 | 161.9 | 0.448 | 5.04 | 3.79 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 89.6 | 451.7 | 0.306 | 10.58 | 5.04 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 26.8 | 89.5 | 0.004 | 3.94 | 3.34 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 70.0 | 234.7 | 0.086 | 10.30 | 3.35 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 42.9 | 179.3 | 0.052 | 6.31 | 4.18 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 217.9 | 819.1 | 0.958 | 32.08 | 3.76 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.0 | 107.7 | 0.039 | 4.12 | 3.85 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 30.3 | 105.7 | 0.048 | 4.45 | 3.49 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 96.4 | 346.2 | 0.350 | 14.20 | 3.59 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 32.5 | 144.5 | 0.051 | 4.78 | 4.45 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 92.1 | 406.5 | 0.078 | 13.55 | 4.41 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 115119.4 | 403846.2 | 525.227 | 0.67 | 3.51 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 592016.1 | 2503286.2 | 1386.010 | 3.43 | 4.23 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 114493.8 | 404053.2 | 490.278 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3575642.7 | 18223876.2 | 2976.320 | 20.72 | 5.10 |
| string: silesia/dickens | 1 | 172528 | simdjson | 310458.5 | 621743.2 | 581.515 | 1.80 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 226133.9 | 826618.2 | 2250.722 | 1.31 | 3.66 |
| string: silesia/dickens | 1 | 172528 | std.json | 1572958.2 | 4578768.3 | 42414.361 | 9.12 | 2.91 |
| string: silesia/dickens | 1 | 172528 | serde_json | 202815.7 | 802391.2 | 992.598 | 1.18 | 3.96 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1071452.3 | 5283581.7 | 4954.505 | 6.21 | 4.93 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1566419.4 | 4799763.6 | 1318.714 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14393501.1 | 56816152.6 | 39247.429 | 12.09 | 3.95 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1563335.6 | 4799865.6 | 1109.286 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 28991650.0 | 132108253.6 | 160061.214 | 24.36 | 4.56 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4566575.5 | 7053838.6 | 558.143 | 3.84 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1811778.5 | 7322017.6 | 14918.286 | 1.52 | 4.04 |
| string: http/json-1m | 1 | 1190272 | std.json | 10306346.5 | 47381213.6 | 31899.000 | 8.66 | 4.60 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3905690.4 | 15226459.6 | 6038.786 | 3.28 | 3.90 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9251951.6 | 48024915.3 | 27715.857 | 7.77 | 5.19 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2072150.9 | 5765413.8 | 4388.875 | 1.10 | 2.78 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6205693.4 | 22589263.8 | 6996.375 | 3.30 | 3.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2061744.5 | 5765515.8 | 3931.125 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47670558.5 | 227842320.8 | 309822.875 | 25.32 | 4.78 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3683706.4 | 7945848.8 | 1867.500 | 1.96 | 2.16 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7179922.4 | 12276727.8 | 276999.500 | 3.81 | 1.71 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17525726.6 | 63617055.8 | 273000.125 | 9.31 | 3.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9396643.6 | 24440755.8 | 328014.125 | 4.99 | 2.60 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39393936.0 | 160433506.5 | 823023.000 | 20.92 | 4.07 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12931994.7 | 42561069.3 | 244652.000 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 173302829.3 | 667246747.3 | 392696.333 | 34.15 | 3.85 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12913748.0 | 42561171.3 | 244375.000 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 153179942.3 | 639992662.3 | 423963.333 | 30.18 | 4.18 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17634801.7 | 49745819.3 | 221742.667 | 3.47 | 2.82 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 13850017.7 | 44816977.3 | 452381.333 | 2.73 | 3.24 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 80447068.3 | 314900845.3 | 461087.333 | 15.85 | 3.91 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36060071.3 | 131556135.3 | 582669.000 | 7.10 | 3.65 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 67018010.3 | 273924952.0 | 841864.667 | 13.20 | 4.09 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 94970.5 | 303836.7 | 7.710 | 0.18 | 3.20 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 189755.0 | 623465.7 | 10.000 | 0.36 | 3.29 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 148020.2 | 557689.7 | 5.097 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10277301.1 | 53478202.7 | 9.226 | 19.60 | 5.20 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 491004.9 | 1376732.7 | 6.129 | 0.94 | 2.80 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 537860.8 | 2195905.7 | 5.839 | 1.03 | 4.08 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3457024.4 | 12808414.7 | 60641.452 | 6.59 | 3.71 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 286146.2 | 1179969.7 | 5.645 | 0.55 | 4.12 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2266571.0 | 12787320.3 | 256.935 | 4.32 | 5.64 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 20.1 | 81.8 | 0.109 | 2.38 | 4.06 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.2 | 153.6 | 0.127 | 4.15 | 4.37 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 23.3 | 103.2 | 0.097 | 2.75 | 4.43 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 219.7 | 981.0 | 0.957 | 25.95 | 4.47 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 19.3 | 79.5 | 0.105 | 2.28 | 4.12 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.1 | 94.1 | 0.134 | 2.72 | 4.08 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 26.9 | 105.4 | 0.246 | 3.18 | 3.91 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.1 | 310.8 | 0.358 | 8.16 | 4.50 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.3 | 255.3 | 0.488 | 7.48 | 4.03 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.7 | 315.1 | 0.236 | 8.11 | 4.59 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.9 | 82.8 | 0.025 | 2.77 | 4.39 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.1 | 153.9 | 0.025 | 5.31 | 4.26 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 22.6 | 101.7 | 0.024 | 3.32 | 4.51 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 169.5 | 718.3 | 1.267 | 24.94 | 4.24 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.3 | 81.5 | 0.024 | 2.69 | 4.46 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.3 | 96.6 | 0.032 | 3.14 | 4.52 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.2 | 117.7 | 0.032 | 4.15 | 4.17 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.5 | 271.2 | 0.247 | 8.76 | 4.56 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 48.7 | 211.7 | 0.040 | 7.17 | 4.35 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 82.0 | 331.7 | 0.084 | 12.07 | 4.04 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 84850.6 | 280786.2 | 724.433 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84767.8 | 280732.2 | 719.412 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84687.9 | 280724.2 | 716.670 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3412003.4 | 16047574.2 | 2946.722 | 19.78 | 4.70 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 83132.2 | 274401.2 | 666.969 | 0.48 | 3.30 |
| string: silesia/dickens | 1 | 172528 | simdjson | 208545.1 | 674008.2 | 2090.144 | 1.21 | 3.23 |
| string: silesia/dickens | 1 | 172528 | yyjson | 217191.3 | 848559.2 | 1425.918 | 1.26 | 3.91 |
| string: silesia/dickens | 1 | 172528 | std.json | 1358728.2 | 2890892.2 | 53645.010 | 7.88 | 2.13 |
| string: silesia/dickens | 1 | 172528 | serde_json | 375442.3 | 1586249.2 | 2291.371 | 2.18 | 4.23 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 587529.9 | 2970293.3 | 2929.392 | 3.41 | 5.06 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1261027.6 | 3582350.6 | 10985.429 | 1.06 | 2.84 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1246666.1 | 3582290.6 | 10493.214 | 1.05 | 2.87 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1247859.0 | 3582278.6 | 10518.214 | 1.05 | 2.87 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25526871.0 | 109856348.6 | 142810.000 | 21.45 | 4.30 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1225742.2 | 3370022.6 | 11003.786 | 1.03 | 2.75 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2997608.9 | 10460754.6 | 29606.786 | 2.52 | 3.49 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2663506.1 | 11226214.6 | 9398.929 | 2.24 | 4.21 |
| string: http/json-1m | 1 | 1190272 | std.json | 9040102.5 | 43287986.6 | 15996.214 | 7.59 | 4.79 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3881520.2 | 17941088.6 | 11024.714 | 3.26 | 4.62 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5247096.4 | 26999739.9 | 10931.786 | 4.41 | 5.15 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2073770.3 | 6088099.8 | 4627.000 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2064149.5 | 6088039.8 | 4133.750 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2062029.5 | 6088027.8 | 4058.125 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43612199.6 | 193466548.8 | 269430.625 | 23.16 | 4.44 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2072619.9 | 5875346.8 | 4857.000 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2725187.9 | 7144135.8 | 20930.125 | 1.45 | 2.62 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12431302.0 | 26334410.8 | 416777.000 | 6.60 | 2.12 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20421635.1 | 56837736.8 | 549787.750 | 10.84 | 2.78 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11380102.6 | 33662338.8 | 341305.250 | 6.04 | 2.96 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18320469.6 | 76319463.5 | 254369.750 | 9.73 | 4.17 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113322.7 | 426376.7 | 6.258 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113086.6 | 426318.7 | 1.323 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113466.4 | 426299.7 | 4.387 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 637491.4 | 3146479.7 | 5.355 | 1.22 | 4.94 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113508.1 | 426343.7 | 2.323 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1210895.7 | 3866907.7 | 4.968 | 2.31 | 3.19 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1625827.2 | 5833344.7 | 5.871 | 3.10 | 3.59 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3612763.7 | 13108830.7 | 63174.710 | 6.89 | 3.63 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1789837.0 | 7405810.7 | 4.839 | 3.41 | 4.14 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2392115.5 | 12748285.9 | 17.097 | 4.56 | 5.33 |
