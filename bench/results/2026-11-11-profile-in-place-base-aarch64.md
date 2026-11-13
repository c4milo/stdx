# bench-profile

| Field | Value |
|---|---|
| Commit | 1d1b46f |
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
| silesia/dickens | 10192446 | zlib | 7.98 | 15.77 | 1.98 | 299.82 |
| silesia/dickens | 10192446 | zlib-ng | 4.91 | 10.50 | 2.14 | 67.46 |
| silesia/dickens | 10192446 | libdeflate | 3.52 | 9.56 | 2.71 | 66.48 |
| silesia/dickens | 10192446 | Wuffs | 4.92 | 10.85 | 2.21 | 96.99 |
| silesia/dickens | 10192446 | stdx | 3.02 | 7.15 | 2.37 | 76.13 |
| silesia/mozilla | 51220480 | zlib | 7.78 | 14.13 | 1.82 | 242.59 |
| silesia/mozilla | 51220480 | zlib-ng | 4.97 | 8.95 | 1.80 | 85.32 |
| silesia/mozilla | 51220480 | libdeflate | 3.50 | 7.63 | 2.18 | 71.13 |
| silesia/mozilla | 51220480 | Wuffs | 5.74 | 10.84 | 1.89 | 132.91 |
| silesia/mozilla | 51220480 | stdx | 3.68 | 6.29 | 1.71 | 89.12 |
| silesia/mr | 9970564 | zlib | 7.73 | 15.26 | 1.97 | 197.20 |
| silesia/mr | 9970564 | zlib-ng | 4.84 | 9.98 | 2.06 | 67.75 |
| silesia/mr | 9970564 | libdeflate | 3.39 | 8.58 | 2.53 | 61.14 |
| silesia/mr | 9970564 | Wuffs | 5.33 | 10.93 | 2.05 | 100.30 |
| silesia/mr | 9970564 | stdx | 3.24 | 6.70 | 2.07 | 69.73 |
| silesia/nci | 33553445 | zlib | 2.95 | 7.25 | 2.45 | 78.34 |
| silesia/nci | 33553445 | zlib-ng | 1.68 | 3.13 | 1.87 | 33.71 |
| silesia/nci | 33553445 | libdeflate | 1.29 | 2.66 | 2.06 | 29.86 |
| silesia/nci | 33553445 | Wuffs | 1.79 | 3.38 | 1.89 | 42.61 |
| silesia/nci | 33553445 | stdx | 1.38 | 2.20 | 1.59 | 37.99 |
| silesia/ooffice | 6152192 | zlib | 11.07 | 17.83 | 1.61 | 401.18 |
| silesia/ooffice | 6152192 | zlib-ng | 6.96 | 12.04 | 1.73 | 140.29 |
| silesia/ooffice | 6152192 | libdeflate | 4.94 | 10.45 | 2.12 | 125.44 |
| silesia/ooffice | 6152192 | Wuffs | 8.16 | 14.47 | 1.77 | 221.66 |
| silesia/ooffice | 6152192 | stdx | 5.20 | 8.55 | 1.64 | 150.24 |
| silesia/osdb | 10085684 | zlib | 6.83 | 13.54 | 1.98 | 170.51 |
| silesia/osdb | 10085684 | zlib-ng | 4.34 | 8.38 | 1.93 | 53.30 |
| silesia/osdb | 10085684 | libdeflate | 2.87 | 6.91 | 2.41 | 29.83 |
| silesia/osdb | 10085684 | Wuffs | 5.16 | 10.56 | 2.05 | 77.94 |
| silesia/osdb | 10085684 | stdx | 2.91 | 5.65 | 1.94 | 41.06 |
| silesia/reymont | 6627202 | zlib | 6.62 | 12.73 | 1.92 | 251.31 |
| silesia/reymont | 6627202 | zlib-ng | 3.74 | 7.72 | 2.06 | 61.14 |
| silesia/reymont | 6627202 | libdeflate | 2.62 | 6.91 | 2.63 | 51.22 |
| silesia/reymont | 6627202 | Wuffs | 4.27 | 8.40 | 1.97 | 112.28 |
| silesia/reymont | 6627202 | stdx | 2.33 | 5.11 | 2.19 | 64.47 |
| silesia/samba | 21606400 | zlib | 5.50 | 11.09 | 2.02 | 169.42 |
| silesia/samba | 21606400 | zlib-ng | 3.41 | 6.47 | 1.90 | 55.78 |
| silesia/samba | 21606400 | libdeflate | 2.41 | 5.58 | 2.32 | 42.96 |
| silesia/samba | 21606400 | Wuffs | 3.72 | 7.33 | 1.97 | 81.07 |
| silesia/samba | 21606400 | stdx | 2.43 | 4.46 | 1.84 | 56.18 |
| silesia/sao | 7251944 | zlib | 9.94 | 20.36 | 2.05 | 195.21 |
| silesia/sao | 7251944 | zlib-ng | 7.90 | 14.83 | 1.88 | 79.43 |
| silesia/sao | 7251944 | libdeflate | 5.78 | 12.73 | 2.20 | 78.98 |
| silesia/sao | 7251944 | Wuffs | 8.20 | 18.14 | 2.21 | 86.94 |
| silesia/sao | 7251944 | stdx | 5.68 | 10.32 | 1.82 | 86.73 |
| silesia/webster | 41458703 | zlib | 7.00 | 12.99 | 1.86 | 271.41 |
| silesia/webster | 41458703 | zlib-ng | 4.24 | 8.04 | 1.89 | 84.58 |
| silesia/webster | 41458703 | libdeflate | 2.97 | 7.17 | 2.41 | 68.66 |
| silesia/webster | 41458703 | Wuffs | 4.54 | 8.62 | 1.90 | 123.02 |
| silesia/webster | 41458703 | stdx | 2.86 | 5.56 | 1.94 | 86.85 |
| silesia/x-ray | 8474240 | zlib | 12.31 | 23.82 | 1.94 | 324.49 |
| silesia/x-ray | 8474240 | zlib-ng | 9.06 | 17.39 | 1.92 | 123.95 |
| silesia/x-ray | 8474240 | libdeflate | 6.57 | 15.26 | 2.32 | 124.43 |
| silesia/x-ray | 8474240 | Wuffs | 10.13 | 20.40 | 2.01 | 191.38 |
| silesia/x-ray | 8474240 | stdx | 6.26 | 11.49 | 1.84 | 137.70 |
| silesia/xml | 5345280 | zlib | 3.63 | 8.20 | 2.26 | 115.33 |
| silesia/xml | 5345280 | zlib-ng | 1.99 | 3.88 | 1.95 | 42.57 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.44 | 32.04 |
| silesia/xml | 5345280 | Wuffs | 2.21 | 4.14 | 1.88 | 60.96 |
| silesia/xml | 5345280 | stdx | 1.33 | 2.65 | 1.99 | 41.61 |
| canterbury/alice29.txt | 152089 | zlib | 7.57 | 15.08 | 1.99 | 283.12 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.28 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.19 | 8.96 | 2.80 | 55.46 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.69 | 10.37 | 2.21 | 97.52 |
| canterbury/alice29.txt | 152089 | stdx | 2.71 | 6.99 | 2.58 | 62.38 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.11 | 16.11 | 1.99 | 301.11 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.10 | 10.86 | 2.13 | 75.05 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.60 | 9.82 | 2.73 | 67.74 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.08 | 11.34 | 2.23 | 99.58 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.07 | 7.52 | 2.45 | 77.57 |
| canterbury/cp.html | 24603 | zlib | 6.47 | 14.20 | 2.20 | 167.46 |
| canterbury/cp.html | 24603 | zlib-ng | 4.26 | 9.50 | 2.23 | 43.23 |
| canterbury/cp.html | 24603 | libdeflate | 2.89 | 7.95 | 2.76 | 19.54 |
| canterbury/cp.html | 24603 | Wuffs | 4.46 | 10.87 | 2.44 | 54.66 |
| canterbury/cp.html | 24603 | stdx | 2.69 | 7.19 | 2.67 | 13.34 |
| canterbury/fields.c | 11150 | zlib | 4.55 | 14.65 | 3.22 | 31.15 |
| canterbury/fields.c | 11150 | zlib-ng | 3.90 | 10.20 | 2.61 | 16.42 |
| canterbury/fields.c | 11150 | libdeflate | 2.80 | 8.32 | 2.97 | 2.35 |
| canterbury/fields.c | 11150 | Wuffs | 3.88 | 11.51 | 2.96 | 12.44 |
| canterbury/fields.c | 11150 | stdx | 2.49 | 7.64 | 3.08 | 3.39 |
| canterbury/grammar.lsp | 3721 | zlib | 6.22 | 21.22 | 3.41 | 2.79 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.83 | 17.48 | 3.00 | 8.27 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.39 | 12.05 | 2.75 | 0.15 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.03 | 18.87 | 3.13 | 4.94 |
| canterbury/grammar.lsp | 3721 | stdx | 3.84 | 12.18 | 3.17 | 1.11 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.94 | 12.20 | 3.09 | 47.72 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.58 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.25 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.21 | 8.67 | 2.71 | 14.87 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.66 | 2.67 | 16.66 |
| canterbury/lcet10.txt | 426754 | zlib | 7.35 | 14.53 | 1.98 | 278.58 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.33 | 9.39 | 2.17 | 61.10 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.22 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.56 | 9.85 | 2.16 | 100.93 |
| canterbury/lcet10.txt | 426754 | stdx | 2.60 | 6.42 | 2.47 | 66.42 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.31 | 16.53 | 1.99 | 310.84 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.31 | 11.19 | 2.11 | 80.16 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.70 | 77.11 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.16 | 11.53 | 2.24 | 99.31 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 7.63 | 2.42 | 85.52 |
| canterbury/ptt5 | 513216 | zlib | 4.40 | 7.79 | 1.77 | 99.72 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.00 | 3.74 | 1.87 | 47.07 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.08 | 38.18 |
| canterbury/ptt5 | 513216 | Wuffs | 2.20 | 4.02 | 1.83 | 58.87 |
| canterbury/ptt5 | 513216 | stdx | 1.45 | 2.55 | 1.76 | 48.98 |
| canterbury/sum | 38240 | zlib | 7.27 | 14.98 | 2.06 | 213.77 |
| canterbury/sum | 38240 | zlib-ng | 4.68 | 10.02 | 2.14 | 60.54 |
| canterbury/sum | 38240 | libdeflate | 3.43 | 8.34 | 2.43 | 46.43 |
| canterbury/sum | 38240 | Wuffs | 5.07 | 11.41 | 2.25 | 81.39 |
| canterbury/sum | 38240 | stdx | 3.02 | 7.73 | 2.56 | 28.67 |
| canterbury/xargs.1 | 4227 | zlib | 6.69 | 22.08 | 3.30 | 7.40 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.41 | 17.97 | 2.81 | 12.32 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.76 | 13.27 | 2.79 | 0.70 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.56 | 19.63 | 2.99 | 12.46 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 12.86 | 3.04 | 2.37 |
| canterbury-large/E.coli | 4638690 | zlib | 5.97 | 14.55 | 2.44 | 175.27 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.24 | 9.68 | 2.28 | 47.24 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.92 | 48.41 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.00 | 9.64 | 2.41 | 60.78 |
| canterbury-large/E.coli | 4638690 | stdx | 2.49 | 6.72 | 2.69 | 53.84 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.72 | 13.26 | 1.97 | 257.71 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.79 | 8.26 | 2.18 | 53.41 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.84 | 45.38 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.15 | 8.72 | 2.10 | 100.20 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.24 | 5.57 | 2.48 | 55.93 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.95 | 12.69 | 1.83 | 270.29 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.56 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.19 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.53 | 8.44 | 1.86 | 129.22 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 5.40 | 1.98 | 90.15 |
| http/html-1kx1024 | 1048576 | zlib | 15.83 | 32.44 | 2.05 | 349.13 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.68 | 28.43 | 2.24 | 217.57 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.58 | 20.05 | 1.90 | 156.69 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.74 | 35.05 | 2.38 | 264.42 |
| http/html-1kx1024 | 1048576 | stdx | 8.37 | 20.88 | 2.49 | 136.84 |
| http/html-16kx64 | 1048576 | zlib | 6.00 | 11.79 | 1.97 | 213.75 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 84.96 |
| http/html-16kx64 | 1048576 | libdeflate | 2.64 | 6.04 | 2.29 | 60.79 |
| http/html-16kx64 | 1048576 | Wuffs | 4.28 | 8.51 | 1.99 | 116.81 |
| http/html-16kx64 | 1048576 | stdx | 2.51 | 5.56 | 2.22 | 59.07 |
| http/html-1m | 1048576 | zlib | 4.63 | 9.51 | 2.05 | 171.51 |
| http/html-1m | 1048576 | zlib-ng | 2.63 | 5.03 | 1.92 | 59.95 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.32 |
| http/html-1m | 1048576 | Wuffs | 2.96 | 5.42 | 1.83 | 90.35 |
| http/html-1m | 1048576 | stdx | 1.65 | 3.46 | 2.10 | 52.46 |
| http/json-1kx1024 | 1048576 | zlib | 9.70 | 20.83 | 2.15 | 190.61 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.26 | 130.33 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.85 | 16.72 | 1.89 | 93.47 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.55 | 31.72 | 2.75 | 145.82 |
| http/json-1kx1024 | 1048576 | stdx | 5.02 | 13.12 | 2.62 | 80.46 |
| http/json-16kx64 | 1048576 | zlib | 3.93 | 9.62 | 2.44 | 100.70 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.10 | 50.88 |
| http/json-16kx64 | 1048576 | libdeflate | 1.92 | 4.24 | 2.21 | 40.71 |
| http/json-16kx64 | 1048576 | Wuffs | 2.83 | 6.35 | 2.25 | 58.57 |
| http/json-16kx64 | 1048576 | stdx | 1.75 | 3.97 | 2.26 | 39.40 |
| http/json-1m | 1048576 | zlib | 3.24 | 8.25 | 2.54 | 81.93 |
| http/json-1m | 1048576 | zlib-ng | 1.94 | 3.91 | 2.02 | 37.42 |
| http/json-1m | 1048576 | libdeflate | 1.39 | 3.33 | 2.40 | 33.01 |
| http/json-1m | 1048576 | Wuffs | 2.05 | 4.29 | 2.10 | 44.43 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.02 | 39.77 |
| http/js-1kx1024 | 1048576 | zlib | 17.30 | 35.33 | 2.04 | 401.21 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.79 | 31.25 | 2.27 | 239.57 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.27 | 21.58 | 1.92 | 179.91 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.92 | 37.71 | 2.37 | 296.04 |
| http/js-1kx1024 | 1048576 | stdx | 9.26 | 22.85 | 2.47 | 158.37 |
| http/js-16kx64 | 1048576 | zlib | 6.89 | 13.06 | 1.90 | 253.47 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.97 | 92.15 |
| http/js-16kx64 | 1048576 | libdeflate | 3.06 | 7.01 | 2.29 | 72.21 |
| http/js-16kx64 | 1048576 | Wuffs | 4.85 | 9.70 | 2.00 | 130.03 |
| http/js-16kx64 | 1048576 | stdx | 3.01 | 6.54 | 2.17 | 72.30 |
| http/js-1m | 1048576 | zlib | 5.15 | 10.26 | 1.99 | 195.06 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 60.10 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 42.02 |
| http/js-1m | 1048576 | Wuffs | 3.26 | 6.10 | 1.87 | 95.97 |
| http/js-1m | 1048576 | stdx | 1.80 | 3.89 | 2.16 | 55.20 |
| http/css-1kx1024 | 1048576 | zlib | 13.12 | 27.18 | 2.07 | 279.90 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.24 | 23.04 | 2.25 | 171.67 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.17 | 17.37 | 1.89 | 122.17 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.16 | 29.48 | 2.42 | 208.65 |
| http/css-1kx1024 | 1048576 | stdx | 6.66 | 17.64 | 2.65 | 99.91 |
| http/css-16kx64 | 1048576 | zlib | 4.65 | 10.12 | 2.18 | 150.52 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.19 | 49.87 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.49 | 29.97 |
| http/css-16kx64 | 1048576 | Wuffs | 3.13 | 6.97 | 2.22 | 70.65 |
| http/css-16kx64 | 1048576 | stdx | 1.71 | 4.36 | 2.55 | 27.84 |
| http/css-1m | 1048576 | zlib | 3.36 | 8.00 | 2.38 | 106.14 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.21 | 29.11 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.97 | 12.94 |
| http/css-1m | 1048576 | Wuffs | 1.92 | 4.08 | 2.13 | 45.16 |
| http/css-1m | 1048576 | stdx | 1.02 | 2.56 | 2.50 | 21.52 |
| shuffled/dickens-1m | 1048576 | zlib | 12.73 | 22.42 | 1.76 | 372.93 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.74 | 16.72 | 1.72 | 198.65 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.01 | 14.95 | 2.13 | 192.65 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.69 | 18.95 | 1.96 | 205.68 |
| shuffled/dickens-1m | 1048576 | stdx | 7.05 | 11.89 | 1.69 | 205.20 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.64 | 14.04 | 3.86 | 3.51 |
| silesia/dickens | 10192446 | stdx | 3.86 | 12.47 | 3.23 | 3.64 |
| silesia/mozilla | 51220480 | libzstd | 2.89 | 9.62 | 3.33 | 30.35 |
| silesia/mozilla | 51220480 | stdx | 2.91 | 9.68 | 3.32 | 15.82 |
| silesia/mr | 9970564 | libzstd | 3.09 | 11.98 | 3.88 | 6.26 |
| silesia/mr | 9970564 | stdx | 3.22 | 10.83 | 3.36 | 5.18 |
| silesia/nci | 33553445 | libzstd | 1.75 | 4.84 | 2.76 | 24.03 |
| silesia/nci | 33553445 | stdx | 1.87 | 4.63 | 2.48 | 13.67 |
| silesia/ooffice | 6152192 | libzstd | 3.46 | 12.14 | 3.51 | 31.40 |
| silesia/ooffice | 6152192 | stdx | 3.39 | 12.40 | 3.66 | 12.31 |
| silesia/osdb | 10085684 | libzstd | 2.39 | 8.44 | 3.53 | 15.26 |
| silesia/osdb | 10085684 | stdx | 2.47 | 8.11 | 3.28 | 15.29 |
| silesia/reymont | 6627202 | libzstd | 3.28 | 11.61 | 3.54 | 11.63 |
| silesia/reymont | 6627202 | stdx | 3.47 | 10.36 | 2.98 | 12.88 |
| silesia/samba | 21606400 | libzstd | 2.15 | 7.39 | 3.43 | 18.85 |
| silesia/samba | 21606400 | stdx | 2.28 | 6.83 | 3.00 | 17.60 |
| silesia/sao | 7251944 | libzstd | 3.88 | 12.69 | 3.27 | 26.91 |
| silesia/sao | 7251944 | stdx | 3.58 | 12.58 | 3.51 | 6.23 |
| silesia/webster | 41458703 | libzstd | 3.33 | 11.22 | 3.37 | 16.24 |
| silesia/webster | 41458703 | stdx | 3.57 | 10.05 | 2.81 | 17.75 |
| silesia/x-ray | 8474240 | libzstd | 3.99 | 14.93 | 3.74 | 18.79 |
| silesia/x-ray | 8474240 | stdx | 3.62 | 13.23 | 3.66 | 8.30 |
| silesia/xml | 5345280 | libzstd | 1.55 | 5.55 | 3.59 | 23.01 |
| silesia/xml | 5345280 | stdx | 1.53 | 5.16 | 3.37 | 17.16 |
| canterbury/alice29.txt | 152089 | libzstd | 3.36 | 16.18 | 4.81 | 4.23 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.35 | 0.48 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.01 | 14.25 | 4.74 | 3.33 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.30 | 0.21 |
| canterbury/cp.html | 24603 | libzstd | 2.68 | 10.74 | 4.01 | 9.33 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.11 | 0.32 |
| canterbury/fields.c | 11150 | libzstd | 3.13 | 13.61 | 4.35 | 9.51 |
| canterbury/fields.c | 11150 | stdx | 3.00 | 12.72 | 4.24 | 0.08 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.24 | 16.93 | 3.99 | 5.95 |
| canterbury/grammar.lsp | 3721 | stdx | 4.13 | 16.54 | 4.00 | 0.38 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.49 | 11.22 | 4.51 | 7.67 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.24 | 0.83 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.74 | 12.87 | 4.70 | 5.27 |
| canterbury/lcet10.txt | 426754 | stdx | 2.70 | 11.52 | 4.26 | 2.00 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.17 | 15.14 | 4.78 | 1.55 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.26 | 1.03 |
| canterbury/ptt5 | 513216 | libzstd | 1.44 | 4.50 | 3.11 | 24.22 |
| canterbury/ptt5 | 513216 | stdx | 1.33 | 4.46 | 3.35 | 13.23 |
| canterbury/sum | 38240 | libzstd | 2.66 | 10.51 | 3.96 | 11.38 |
| canterbury/sum | 38240 | stdx | 2.63 | 10.74 | 4.09 | 0.44 |
| canterbury/xargs.1 | 4227 | libzstd | 4.29 | 17.40 | 4.05 | 10.30 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.17 | 4.05 | 0.21 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.05 | 13.63 | 4.47 | 2.26 |
| canterbury-large/E.coli | 4638690 | stdx | 3.11 | 12.04 | 3.87 | 3.05 |
| canterbury-large/bible.txt | 4047392 | libzstd | 3.01 | 11.99 | 3.99 | 8.57 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.16 | 10.64 | 3.37 | 9.36 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.56 | 9.59 | 3.75 | 20.04 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.65 | 8.64 | 3.26 | 21.27 |
| http/html-1kx1024 | 1048576 | libzstd | 7.41 | 21.63 | 2.92 | 63.07 |
| http/html-1kx1024 | 1048576 | stdx | 7.44 | 22.46 | 3.02 | 76.19 |
| http/html-16kx64 | 1048576 | libzstd | 2.67 | 10.15 | 3.80 | 28.81 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 9.61 | 3.61 | 30.41 |
| http/html-1m | 1048576 | libzstd | 2.00 | 7.86 | 3.92 | 24.60 |
| http/html-1m | 1048576 | stdx | 2.01 | 7.12 | 3.54 | 25.11 |
| http/json-1kx1024 | 1048576 | libzstd | 6.39 | 17.37 | 2.72 | 49.98 |
| http/json-1kx1024 | 1048576 | stdx | 6.20 | 17.86 | 2.88 | 53.57 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.22 | 3.52 | 28.21 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 19.86 |
| http/json-1m | 1048576 | libzstd | 1.73 | 6.04 | 3.50 | 27.88 |
| http/json-1m | 1048576 | stdx | 1.64 | 5.91 | 3.61 | 14.24 |
| http/js-1kx1024 | 1048576 | libzstd | 8.45 | 26.38 | 3.12 | 73.12 |
| http/js-1kx1024 | 1048576 | stdx | 9.03 | 27.60 | 3.06 | 113.74 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.71 | 3.99 | 24.52 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.74 | 26.41 |
| http/js-1m | 1048576 | libzstd | 2.02 | 8.18 | 4.05 | 20.49 |
| http/js-1m | 1048576 | stdx | 2.07 | 7.48 | 3.60 | 21.71 |
| http/css-1kx1024 | 1048576 | libzstd | 7.05 | 19.70 | 2.79 | 54.40 |
| http/css-1kx1024 | 1048576 | stdx | 6.83 | 19.96 | 2.92 | 63.72 |
| http/css-16kx64 | 1048576 | libzstd | 2.25 | 8.69 | 3.86 | 24.18 |
| http/css-16kx64 | 1048576 | stdx | 2.28 | 8.43 | 3.70 | 22.52 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.57 | 3.85 | 5.62 |
| http/css-1m | 1048576 | stdx | 0.72 | 2.49 | 3.48 | 4.23 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.81 | 9.40 | 3.35 | 28.68 |
| shuffled/dickens-1m | 1048576 | stdx | 2.73 | 9.19 | 3.37 | 12.06 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.66 | 17.04 | 2.22 | 101.08 |
| silesia/dickens | 1048576 | stdx | 5.15 | 12.38 | 2.40 | 54.72 |
| silesia/mozilla | 1048576 | Google | 13.61 | 27.77 | 2.04 | 46.65 |
| silesia/mozilla | 1048576 | stdx | 8.34 | 15.02 | 1.80 | 47.68 |
| silesia/mr | 1048576 | Google | 8.96 | 20.24 | 2.26 | 102.30 |
| silesia/mr | 1048576 | stdx | 5.80 | 13.25 | 2.28 | 88.31 |
| silesia/nci | 1048576 | Google | 2.58 | 5.69 | 2.20 | 51.82 |
| silesia/nci | 1048576 | stdx | 1.95 | 3.95 | 2.03 | 54.62 |
| silesia/ooffice | 1048576 | Google | 14.29 | 29.28 | 2.05 | 287.15 |
| silesia/ooffice | 1048576 | stdx | 10.89 | 20.33 | 1.87 | 323.68 |
| silesia/osdb | 1048576 | Google | 8.31 | 17.38 | 2.09 | 96.15 |
| silesia/osdb | 1048576 | stdx | 5.17 | 10.57 | 2.05 | 92.13 |
| silesia/reymont | 1048576 | Google | 5.51 | 12.73 | 2.31 | 82.08 |
| silesia/reymont | 1048576 | stdx | 3.72 | 9.25 | 2.48 | 47.61 |
| silesia/samba | 1048576 | Google | 7.62 | 16.22 | 2.13 | 95.67 |
| silesia/samba | 1048576 | stdx | 5.08 | 10.71 | 2.11 | 67.32 |
| silesia/sao | 1048576 | Google | 16.92 | 36.97 | 2.18 | 162.23 |
| silesia/sao | 1048576 | stdx | 10.43 | 22.65 | 2.17 | 142.20 |
| silesia/webster | 1048576 | Google | 6.66 | 14.07 | 2.11 | 115.08 |
| silesia/webster | 1048576 | stdx | 4.43 | 9.98 | 2.25 | 69.63 |
| silesia/x-ray | 1048576 | Google | 19.87 | 38.46 | 1.94 | 233.60 |
| silesia/x-ray | 1048576 | stdx | 14.70 | 30.18 | 2.05 | 235.19 |
| silesia/xml | 1048576 | Google | 3.48 | 7.65 | 2.20 | 65.39 |
| silesia/xml | 1048576 | stdx | 2.41 | 5.40 | 2.24 | 47.11 |
| canterbury/alice29.txt | 152089 | Google | 8.94 | 20.66 | 2.31 | 136.36 |
| canterbury/alice29.txt | 152089 | stdx | 6.12 | 15.33 | 2.50 | 85.40 |
| canterbury/asyoulik.txt | 125179 | Google | 10.45 | 23.83 | 2.28 | 170.42 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.05 | 17.43 | 2.47 | 102.20 |
| canterbury/cp.html | 24603 | Google | 9.19 | 22.18 | 2.41 | 113.92 |
| canterbury/cp.html | 24603 | stdx | 5.63 | 17.15 | 3.05 | 24.99 |
| canterbury/fields.c | 11150 | Google | 7.06 | 21.25 | 3.01 | 20.94 |
| canterbury/fields.c | 11150 | stdx | 4.88 | 17.08 | 3.50 | 2.13 |
| canterbury/grammar.lsp | 3721 | Google | 9.88 | 30.23 | 3.06 | 7.38 |
| canterbury/grammar.lsp | 3721 | stdx | 7.16 | 25.04 | 3.50 | 0.44 |
| canterbury/kennedy.xls | 1029744 | Google | 5.51 | 17.05 | 3.10 | 37.39 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.82 | 12.94 | 3.38 | 33.97 |
| canterbury/lcet10.txt | 426754 | Google | 7.79 | 17.42 | 2.24 | 130.18 |
| canterbury/lcet10.txt | 426754 | stdx | 5.19 | 12.96 | 2.50 | 65.66 |
| canterbury/plrabn12.txt | 481861 | Google | 9.13 | 20.94 | 2.29 | 133.98 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.16 | 15.04 | 2.44 | 87.61 |
| canterbury/ptt5 | 513216 | Google | 4.30 | 10.36 | 2.41 | 61.86 |
| canterbury/ptt5 | 513216 | stdx | 2.36 | 4.89 | 2.07 | 65.24 |
| canterbury/sum | 38240 | Google | 10.86 | 26.44 | 2.43 | 157.29 |
| canterbury/sum | 38240 | stdx | 8.29 | 21.11 | 2.55 | 152.62 |
| canterbury/xargs.1 | 4227 | Google | 10.97 | 34.81 | 3.17 | 9.73 |
| canterbury/xargs.1 | 4227 | stdx | 8.54 | 30.44 | 3.56 | 10.43 |
| canterbury-large/E.coli | 1048576 | Google | 7.48 | 19.44 | 2.60 | 1.39 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.24 |
| canterbury-large/bible.txt | 1048576 | Google | 5.40 | 12.38 | 2.29 | 80.89 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.56 | 8.93 | 2.51 | 39.78 |
| canterbury-large/world192.txt | 1048576 | Google | 6.32 | 12.88 | 2.04 | 115.66 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.42 | 9.38 | 2.12 | 77.47 |
| http/html-1kx1024 | 1048576 | Google | 17.93 | 42.09 | 2.35 | 386.61 |
| http/html-1kx1024 | 1048576 | stdx | 15.33 | 37.56 | 2.45 | 361.62 |
| http/html-16kx64 | 1048576 | Google | 6.77 | 14.88 | 2.20 | 149.56 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.23 |
| http/html-1m | 1048576 | Google | 4.10 | 8.99 | 2.19 | 83.60 |
| http/html-1m | 1048576 | stdx | 2.88 | 6.52 | 2.26 | 55.06 |
| http/json-1kx1024 | 1048576 | Google | 14.27 | 36.74 | 2.57 | 238.76 |
| http/json-1kx1024 | 1048576 | stdx | 12.97 | 33.63 | 2.59 | 276.00 |
| http/json-16kx64 | 1048576 | Google | 4.42 | 11.42 | 2.59 | 81.18 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.59 |
| http/json-1m | 1048576 | Google | 3.43 | 8.66 | 2.52 | 58.73 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.43 | 57.86 |
| http/js-1kx1024 | 1048576 | Google | 19.88 | 46.38 | 2.33 | 427.03 |
| http/js-1kx1024 | 1048576 | stdx | 16.41 | 39.90 | 2.43 | 381.19 |
| http/js-16kx64 | 1048576 | Google | 8.08 | 17.79 | 2.20 | 166.93 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.31 |
| http/js-1m | 1048576 | Google | 4.43 | 9.60 | 2.17 | 83.32 |
| http/js-1m | 1048576 | stdx | 3.18 | 7.25 | 2.28 | 55.34 |
| http/css-1kx1024 | 1048576 | Google | 15.33 | 37.48 | 2.45 | 291.21 |
| http/css-1kx1024 | 1048576 | stdx | 13.82 | 34.70 | 2.51 | 303.42 |
| http/css-16kx64 | 1048576 | Google | 4.97 | 11.78 | 2.37 | 101.08 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.37 |
| http/css-1m | 1048576 | Google | 2.44 | 9.43 | 3.86 | 16.80 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.47 | 11.81 |
| shuffled/dickens-1m | 1048576 | Google | 9.72 | 20.34 | 2.09 | 110.84 |
| shuffled/dickens-1m | 1048576 | stdx | 8.77 | 14.53 | 1.66 | 117.08 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.27 | 36.91 | 2.42 | 411.14 |
| silesia/dickens | 10192446 | 1 | stdx | 16.40 | 38.17 | 2.33 | 360.75 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.70 | 87.63 | 1.66 | 693.40 |
| silesia/dickens | 10192446 | 6 | stdx | 49.67 | 84.26 | 1.70 | 1448.41 |
| silesia/dickens | 10192446 | 9 | libdeflate | 113.84 | 160.47 | 1.41 | 928.46 |
| silesia/dickens | 10192446 | 9 | stdx | 84.78 | 191.80 | 2.26 | 1723.59 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.12 | 32.62 | 2.31 | 437.17 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.39 | 30.24 | 2.26 | 296.09 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.98 | 70.83 | 2.15 | 577.93 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.51 | 69.96 | 2.22 | 730.06 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 128.07 | 221.49 | 1.73 | 767.63 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.98 | 126.12 | 2.58 | 787.60 |
| silesia/mr | 9970564 | 1 | libdeflate | 12.00 | 35.02 | 2.92 | 228.91 |
| silesia/mr | 9970564 | 1 | stdx | 12.65 | 34.08 | 2.69 | 186.93 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.59 | 80.54 | 2.09 | 435.94 |
| silesia/mr | 9970564 | 6 | stdx | 39.74 | 83.18 | 2.09 | 969.38 |
| silesia/mr | 9970564 | 9 | libdeflate | 98.94 | 165.48 | 1.67 | 753.14 |
| silesia/mr | 9970564 | 9 | stdx | 86.85 | 206.31 | 2.38 | 1328.52 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.24 | 18.42 | 2.95 | 115.46 |
| silesia/nci | 33553445 | 1 | stdx | 5.01 | 10.88 | 2.17 | 98.25 |
| silesia/nci | 33553445 | 6 | libdeflate | 17.09 | 34.84 | 2.04 | 225.88 |
| silesia/nci | 33553445 | 6 | stdx | 14.36 | 29.54 | 2.06 | 391.26 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.74 | 105.28 | 1.68 | 499.68 |
| silesia/nci | 33553445 | 9 | stdx | 33.07 | 80.63 | 2.44 | 651.95 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.95 | 39.15 | 1.96 | 753.11 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.81 | 39.08 | 2.19 | 431.05 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 41.27 | 79.10 | 1.92 | 953.96 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.58 | 87.83 | 2.11 | 996.25 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 75.08 | 127.63 | 1.70 | 1132.79 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.46 | 129.17 | 2.46 | 931.03 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.92 | 30.15 | 2.33 | 354.22 |
| silesia/osdb | 10085684 | 1 | stdx | 12.98 | 27.86 | 2.15 | 293.63 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.51 | 55.67 | 1.95 | 488.48 |
| silesia/osdb | 10085684 | 6 | stdx | 27.12 | 57.40 | 2.12 | 566.43 |
| silesia/osdb | 10085684 | 9 | libdeflate | 34.14 | 64.15 | 1.88 | 551.00 |
| silesia/osdb | 10085684 | 9 | stdx | 35.44 | 87.23 | 2.46 | 687.55 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.65 | 32.88 | 2.60 | 311.69 |
| silesia/reymont | 6627202 | 1 | stdx | 13.57 | 33.24 | 2.45 | 271.05 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.63 | 86.58 | 1.78 | 517.87 |
| silesia/reymont | 6627202 | 6 | stdx | 45.40 | 76.82 | 1.69 | 1437.35 |
| silesia/reymont | 6627202 | 9 | libdeflate | 202.09 | 276.14 | 1.37 | 827.68 |
| silesia/reymont | 6627202 | 9 | stdx | 87.10 | 189.97 | 2.18 | 1612.89 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.45 | 26.53 | 2.54 | 271.61 |
| silesia/samba | 21606400 | 1 | stdx | 9.92 | 22.23 | 2.24 | 221.30 |
| silesia/samba | 21606400 | 6 | libdeflate | 29.16 | 58.79 | 2.02 | 384.62 |
| silesia/samba | 21606400 | 6 | stdx | 24.09 | 49.84 | 2.07 | 618.09 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.93 | 141.44 | 1.67 | 502.90 |
| silesia/samba | 21606400 | 9 | stdx | 41.57 | 102.63 | 2.47 | 732.41 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.73 | 47.87 | 2.20 | 684.68 |
| silesia/sao | 7251944 | 1 | stdx | 19.15 | 49.92 | 2.61 | 346.36 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.62 | 96.89 | 1.88 | 959.21 |
| silesia/sao | 7251944 | 6 | stdx | 47.08 | 105.65 | 2.24 | 855.67 |
| silesia/sao | 7251944 | 9 | libdeflate | 71.80 | 120.26 | 1.67 | 1102.82 |
| silesia/sao | 7251944 | 9 | stdx | 55.48 | 138.16 | 2.49 | 841.14 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.12 | 30.45 | 2.32 | 387.17 |
| silesia/webster | 41458703 | 1 | stdx | 13.87 | 29.08 | 2.10 | 339.54 |
| silesia/webster | 41458703 | 6 | libdeflate | 37.42 | 66.02 | 1.76 | 570.28 |
| silesia/webster | 41458703 | 6 | stdx | 35.17 | 60.88 | 1.73 | 1107.71 |
| silesia/webster | 41458703 | 9 | libdeflate | 96.05 | 138.85 | 1.45 | 753.86 |
| silesia/webster | 41458703 | 9 | stdx | 60.59 | 135.96 | 2.24 | 1294.50 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.66 | 49.67 | 2.10 | 781.24 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.65 | 50.81 | 2.88 | 261.84 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.95 | 82.77 | 2.51 | 852.06 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.82 | 98.11 | 2.90 | 535.90 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.57 | 91.03 | 2.42 | 1031.39 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.94 | 122.05 | 2.98 | 467.49 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.83 | 21.59 | 2.76 | 175.19 |
| silesia/xml | 5345280 | 1 | stdx | 7.00 | 15.66 | 2.24 | 155.85 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.43 | 40.51 | 1.89 | 264.34 |
| silesia/xml | 5345280 | 6 | stdx | 17.73 | 34.32 | 1.94 | 493.92 |
| silesia/xml | 5345280 | 9 | libdeflate | 59.52 | 89.17 | 1.50 | 371.39 |
| silesia/xml | 5345280 | 9 | stdx | 31.15 | 72.83 | 2.34 | 600.41 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.26 | 35.61 | 2.50 | 378.52 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.03 | 36.12 | 2.40 | 335.26 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 47.25 | 82.29 | 1.74 | 640.54 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.70 | 77.43 | 1.77 | 1313.38 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 109.38 | 159.21 | 1.46 | 847.64 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 72.56 | 167.73 | 2.31 | 1510.19 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.17 | 37.20 | 2.45 | 417.61 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.78 | 37.43 | 2.37 | 360.45 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.93 | 85.43 | 1.75 | 713.78 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.05 | 81.93 | 1.78 | 1376.29 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 90.39 | 136.15 | 1.51 | 938.61 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 75.51 | 175.97 | 2.33 | 1613.62 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.63 | 32.02 | 2.75 | 279.26 |
| canterbury/cp.html | 24603 | 1 | stdx | 11.05 | 27.13 | 2.46 | 247.64 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 27.15 | 62.33 | 2.30 | 491.12 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.76 | 57.06 | 2.40 | 624.43 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 47.20 | 91.97 | 1.95 | 601.10 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.15 | 88.89 | 2.85 | 641.84 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.28 | 35.92 | 3.87 | 49.23 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.07 | 30.05 | 3.72 | 22.87 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.53 | 69.37 | 2.83 | 246.91 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.92 | 57.62 | 2.75 | 436.83 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 43.86 | 100.81 | 2.30 | 392.80 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.42 | 92.66 | 3.26 | 453.98 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 12.99 | 51.51 | 3.97 | 13.27 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.86 | 39.01 | 3.96 | 1.64 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.71 | 87.06 | 3.67 | 27.48 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.11 | 70.81 | 4.14 | 14.23 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.63 | 102.89 | 3.36 | 39.51 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.58 | 99.31 | 4.21 | 65.88 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.38 | 27.18 | 3.68 | 65.65 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.04 | 22.58 | 3.21 | 62.84 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 28.02 | 73.85 | 2.64 | 95.51 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.33 | 61.99 | 3.21 | 138.13 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.50 | 664.23 | 1.83 | 163.28 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.65 | 130.89 | 3.48 | 219.69 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.77 | 33.99 | 2.47 | 369.15 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.47 | 33.92 | 2.35 | 329.95 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.55 | 78.22 | 1.72 | 606.38 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.76 | 73.43 | 1.76 | 1230.49 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 93.27 | 136.94 | 1.47 | 802.58 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 70.52 | 162.24 | 2.30 | 1450.01 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.80 | 38.62 | 2.44 | 425.49 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.73 | 40.24 | 2.41 | 370.75 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.79 | 91.90 | 1.68 | 749.52 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.55 | 88.90 | 1.72 | 1500.36 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 119.22 | 166.26 | 1.39 | 1002.92 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 88.56 | 201.33 | 2.27 | 1802.54 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.42 | 18.61 | 2.90 | 141.27 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.99 | 11.03 | 2.21 | 123.67 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.29 | 36.17 | 2.53 | 218.99 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.30 | 29.58 | 2.40 | 307.67 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.56 | 120.86 | 2.00 | 374.44 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.09 | 130.09 | 3.02 | 641.63 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.85 | 33.49 | 2.61 | 340.77 |
| canterbury/sum | 38240 | 1 | stdx | 12.64 | 29.36 | 2.32 | 305.09 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.66 | 69.87 | 2.44 | 495.07 |
| canterbury/sum | 38240 | 6 | stdx | 26.73 | 65.74 | 2.46 | 661.94 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.25 | 181.91 | 1.93 | 605.78 |
| canterbury/sum | 38240 | 9 | stdx | 39.26 | 112.33 | 2.86 | 658.62 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.27 | 53.06 | 4.00 | 21.29 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.63 | 43.10 | 4.05 | 1.70 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.98 | 87.70 | 3.82 | 75.21 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 17.88 | 74.35 | 4.16 | 38.25 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 24.82 | 94.34 | 3.80 | 85.43 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.01 | 106.96 | 4.11 | 117.53 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.10 | 40.47 | 3.34 | 164.73 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.80 | 42.29 | 3.30 | 100.77 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.47 | 395.99 | 2.16 | 261.05 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.77 | 374.12 | 3.05 | 1913.74 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 841.29 | 1063.49 | 1.26 | 1322.37 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 230.32 | 755.68 | 3.28 | 2502.88 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.62 | 32.38 | 2.57 | 312.25 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.45 | 32.23 | 2.40 | 281.04 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.65 | 80.12 | 1.72 | 521.98 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.27 | 72.39 | 1.71 | 1255.49 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 144.41 | 200.28 | 1.39 | 740.20 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.01 | 170.21 | 2.24 | 1441.89 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.32 | 29.72 | 2.23 | 412.61 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.32 | 28.55 | 1.99 | 380.23 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.46 | 60.25 | 1.80 | 557.29 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.07 | 56.80 | 1.77 | 980.02 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 81.96 | 119.11 | 1.45 | 684.47 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 51.88 | 117.95 | 2.27 | 1146.48 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.46 | 103.92 | 2.93 | 455.71 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.40 | 58.63 | 2.74 | 364.73 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.34 | 138.33 | 2.99 | 564.50 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 32.06 | 94.31 | 2.94 | 528.09 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 48.12 | 142.44 | 2.96 | 586.88 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 36.11 | 112.13 | 3.11 | 538.63 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.46 | 27.96 | 2.67 | 266.76 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.00 | 20.25 | 2.25 | 233.79 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.41 | 52.09 | 2.32 | 390.40 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.88 | 42.86 | 2.27 | 539.29 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 35.23 | 72.54 | 2.06 | 467.71 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.78 | 69.05 | 2.79 | 548.24 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.77 | 23.03 | 2.63 | 223.96 |
| http/html-1m | 1048576 | 1 | stdx | 8.17 | 17.79 | 2.18 | 206.44 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.51 | 49.53 | 1.94 | 328.02 |
| http/html-1m | 1048576 | 6 | stdx | 21.23 | 40.71 | 1.92 | 616.86 |
| http/html-1m | 1048576 | 9 | libdeflate | 72.25 | 109.24 | 1.51 | 430.83 |
| http/html-1m | 1048576 | 9 | stdx | 35.79 | 85.76 | 2.40 | 706.74 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.82 | 94.80 | 2.98 | 301.44 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.48 | 45.16 | 2.74 | 241.83 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.15 | 126.60 | 2.93 | 374.21 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.21 | 78.37 | 2.88 | 376.67 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.35 | 142.45 | 2.72 | 428.03 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.66 | 95.56 | 3.12 | 384.32 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.86 | 23.85 | 3.03 | 134.56 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.44 | 13.94 | 2.56 | 110.62 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.24 | 46.61 | 2.55 | 205.86 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.45 | 35.01 | 2.60 | 278.27 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.29 | 151.99 | 1.89 | 296.99 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.16 | 58.45 | 3.05 | 302.32 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.73 | 19.85 | 2.95 | 124.07 |
| http/json-1m | 1048576 | 1 | stdx | 5.08 | 12.51 | 2.46 | 103.50 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.49 | 45.30 | 2.21 | 175.72 |
| http/json-1m | 1048576 | 6 | stdx | 14.72 | 35.09 | 2.38 | 298.97 |
| http/json-1m | 1048576 | 9 | libdeflate | 122.39 | 205.21 | 1.68 | 275.89 |
| http/json-1m | 1048576 | 9 | stdx | 29.10 | 72.87 | 2.50 | 368.23 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.05 | 107.80 | 2.91 | 517.57 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.65 | 65.40 | 2.77 | 410.67 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.47 | 144.85 | 2.93 | 674.63 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 35.69 | 104.12 | 2.92 | 618.84 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 52.03 | 150.13 | 2.89 | 716.43 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 40.38 | 125.13 | 3.10 | 626.53 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.75 | 30.90 | 2.63 | 309.46 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.82 | 24.80 | 2.29 | 273.17 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.94 | 59.43 | 2.29 | 468.41 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.75 | 50.05 | 2.20 | 675.47 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 41.07 | 83.31 | 2.03 | 567.94 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.54 | 81.30 | 2.75 | 661.39 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.64 | 25.19 | 2.61 | 246.97 |
| http/js-1m | 1048576 | 1 | stdx | 9.56 | 21.31 | 2.23 | 232.99 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.93 | 56.12 | 1.94 | 369.07 |
| http/js-1m | 1048576 | 6 | stdx | 24.98 | 46.64 | 1.87 | 743.71 |
| http/js-1m | 1048576 | 9 | libdeflate | 77.29 | 120.65 | 1.56 | 498.74 |
| http/js-1m | 1048576 | 9 | stdx | 42.02 | 100.01 | 2.38 | 814.18 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.21 | 97.73 | 2.94 | 377.10 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.46 | 49.52 | 2.68 | 301.58 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.93 | 129.22 | 2.94 | 477.41 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.19 | 82.32 | 2.82 | 503.23 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 46.03 | 133.80 | 2.91 | 508.02 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.15 | 99.48 | 3.00 | 520.48 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.64 | 25.60 | 2.96 | 173.13 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.68 | 16.96 | 2.54 | 135.27 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.28 | 48.80 | 2.41 | 289.14 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.48 | 38.00 | 2.31 | 463.86 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.95 | 82.40 | 2.01 | 371.43 |
| http/css-16kx64 | 1048576 | 9 | stdx | 22.91 | 65.13 | 2.84 | 478.29 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.94 | 21.15 | 3.05 | 132.04 |
| http/css-1m | 1048576 | 1 | stdx | 5.81 | 14.91 | 2.57 | 109.09 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.87 | 44.50 | 2.13 | 225.75 |
| http/css-1m | 1048576 | 6 | stdx | 16.66 | 35.61 | 2.14 | 447.97 |
| http/css-1m | 1048576 | 9 | libdeflate | 70.67 | 111.58 | 1.58 | 307.56 |
| http/css-1m | 1048576 | 9 | stdx | 32.10 | 83.00 | 2.59 | 512.54 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.21 | 48.89 | 1.94 | 928.90 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.17 | 49.19 | 2.71 | 323.56 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.80 | 86.45 | 2.07 | 1181.06 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.88 | 88.80 | 2.23 | 854.50 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.30 | 94.50 | 2.00 | 1341.08 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.03 | 134.38 | 2.49 | 1137.61 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.17 | 31.13 | 3.06 | 123.02 |
| silesia/dickens | 10192446 | 1 | stdx | 24.34 | 82.03 | 3.37 | 125.38 |
| silesia/dickens | 10192446 | 3 | libzstd | 24.43 | 35.01 | 1.43 | 173.28 |
| silesia/dickens | 10192446 | 3 | stdx | 37.57 | 78.22 | 2.08 | 182.50 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.02 | 22.57 | 3.21 | 72.15 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.67 | 54.73 | 3.10 | 173.45 |
| silesia/mozilla | 51220480 | 3 | libzstd | 18.64 | 28.71 | 1.54 | 102.61 |
| silesia/mozilla | 51220480 | 3 | stdx | 32.50 | 62.01 | 1.91 | 144.73 |
| silesia/mr | 9970564 | 1 | libzstd | 7.69 | 24.73 | 3.22 | 57.23 |
| silesia/mr | 9970564 | 1 | stdx | 19.95 | 66.82 | 3.35 | 114.06 |
| silesia/mr | 9970564 | 3 | libzstd | 21.78 | 32.97 | 1.51 | 87.06 |
| silesia/mr | 9970564 | 3 | stdx | 35.51 | 72.46 | 2.04 | 114.49 |
| silesia/nci | 33553445 | 1 | libzstd | 3.56 | 9.49 | 2.66 | 58.37 |
| silesia/nci | 33553445 | 1 | stdx | 7.75 | 25.69 | 3.31 | 59.33 |
| silesia/nci | 33553445 | 3 | libzstd | 5.76 | 10.11 | 1.76 | 57.45 |
| silesia/nci | 33553445 | 3 | stdx | 11.76 | 29.15 | 2.48 | 66.47 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.55 | 29.17 | 3.41 | 71.33 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.17 | 72.51 | 3.13 | 179.45 |
| silesia/ooffice | 6152192 | 3 | libzstd | 26.38 | 40.82 | 1.55 | 122.30 |
| silesia/ooffice | 6152192 | 3 | stdx | 44.46 | 82.20 | 1.85 | 184.86 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.13 | 22.22 | 3.11 | 67.21 |
| silesia/osdb | 10085684 | 1 | stdx | 16.41 | 50.52 | 3.08 | 119.25 |
| silesia/osdb | 10085684 | 3 | libzstd | 19.92 | 27.06 | 1.36 | 70.25 |
| silesia/osdb | 10085684 | 3 | stdx | 34.13 | 57.87 | 1.70 | 111.01 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.87 | 27.02 | 2.74 | 155.94 |
| silesia/reymont | 6627202 | 1 | stdx | 20.19 | 72.05 | 3.57 | 96.45 |
| silesia/reymont | 6627202 | 3 | libzstd | 19.66 | 27.53 | 1.40 | 127.92 |
| silesia/reymont | 6627202 | 3 | stdx | 29.19 | 62.18 | 2.13 | 147.50 |
| silesia/samba | 21606400 | 1 | libzstd | 5.99 | 16.80 | 2.80 | 88.33 |
| silesia/samba | 21606400 | 1 | stdx | 13.55 | 42.89 | 3.17 | 124.46 |
| silesia/samba | 21606400 | 3 | libzstd | 12.87 | 19.20 | 1.49 | 100.40 |
| silesia/samba | 21606400 | 3 | stdx | 21.41 | 44.75 | 2.09 | 133.13 |
| silesia/sao | 7251944 | 1 | libzstd | 9.04 | 33.64 | 3.72 | 43.69 |
| silesia/sao | 7251944 | 1 | stdx | 25.90 | 82.03 | 3.17 | 103.42 |
| silesia/sao | 7251944 | 3 | libzstd | 35.41 | 52.14 | 1.47 | 96.10 |
| silesia/sao | 7251944 | 3 | stdx | 54.73 | 95.22 | 1.74 | 142.18 |
| silesia/webster | 41458703 | 1 | libzstd | 8.74 | 24.86 | 2.85 | 135.68 |
| silesia/webster | 41458703 | 1 | stdx | 20.37 | 64.04 | 3.14 | 165.48 |
| silesia/webster | 41458703 | 3 | libzstd | 20.59 | 27.84 | 1.35 | 179.90 |
| silesia/webster | 41458703 | 3 | stdx | 32.58 | 64.55 | 1.98 | 194.78 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.78 | 14.89 | 3.11 | 17.05 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.97 | 76.64 | 3.20 | 91.84 |
| silesia/x-ray | 8474240 | 3 | libzstd | 36.16 | 54.96 | 1.52 | 87.30 |
| silesia/x-ray | 8474240 | 3 | stdx | 50.64 | 92.40 | 1.82 | 106.30 |
| silesia/xml | 5345280 | 1 | libzstd | 4.25 | 11.65 | 2.74 | 72.62 |
| silesia/xml | 5345280 | 1 | stdx | 10.44 | 34.21 | 3.28 | 94.54 |
| silesia/xml | 5345280 | 3 | libzstd | 7.11 | 12.84 | 1.81 | 79.30 |
| silesia/xml | 5345280 | 3 | stdx | 13.18 | 32.28 | 2.45 | 115.66 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.87 | 32.86 | 3.02 | 145.57 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.41 | 76.49 | 3.41 | 186.51 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.46 | 39.93 | 2.58 | 202.98 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.89 | 73.76 | 2.74 | 336.34 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.78 | 33.59 | 3.43 | 109.70 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.50 | 79.00 | 3.36 | 213.34 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.59 | 40.28 | 2.58 | 209.62 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.55 | 79.30 | 2.78 | 373.82 |
| canterbury/cp.html | 24603 | 1 | libzstd | 6.96 | 26.65 | 3.83 | 37.48 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.17 | 57.76 | 3.57 | 125.44 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.46 | 32.88 | 3.47 | 24.51 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.41 | 59.76 | 3.25 | 137.33 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.74 | 31.77 | 3.63 | 37.89 |
| canterbury/fields.c | 11150 | 1 | stdx | 17.14 | 65.73 | 3.83 | 95.12 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.00 | 34.41 | 3.82 | 9.75 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.31 | 64.68 | 3.74 | 90.84 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.53 | 37.98 | 3.99 | 9.84 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.25 | 77.57 | 3.83 | 51.60 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.59 | 43.28 | 4.09 | 2.46 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.38 | 79.60 | 3.72 | 66.92 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.02 | 23.37 | 3.88 | 14.80 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.83 | 56.75 | 3.83 | 83.94 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 9.07 | 24.26 | 2.67 | 27.27 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 21.33 | 56.61 | 2.65 | 107.84 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.91 | 28.42 | 2.87 | 161.00 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.56 | 72.02 | 3.34 | 159.67 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 17.83 | 32.77 | 1.84 | 204.00 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.96 | 67.10 | 2.49 | 297.45 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.39 | 32.28 | 3.11 | 130.94 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.22 | 84.16 | 3.34 | 157.94 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 21.63 | 39.60 | 1.83 | 226.76 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 32.42 | 80.77 | 2.49 | 341.36 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.16 | 8.48 | 2.69 | 67.60 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.56 | 23.15 | 3.06 | 104.71 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 5.28 | 11.28 | 2.14 | 60.75 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.75 | 24.08 | 2.47 | 132.17 |
| canterbury/sum | 38240 | 1 | libzstd | 6.47 | 25.37 | 3.92 | 28.75 |
| canterbury/sum | 38240 | 1 | stdx | 16.92 | 59.13 | 3.49 | 149.87 |
| canterbury/sum | 38240 | 3 | libzstd | 8.80 | 31.64 | 3.60 | 23.08 |
| canterbury/sum | 38240 | 3 | stdx | 20.06 | 61.82 | 3.08 | 181.03 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 10.07 | 39.84 | 3.95 | 14.21 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.92 | 80.38 | 3.84 | 62.63 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.06 | 48.45 | 4.02 | 2.13 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.82 | 83.98 | 3.68 | 79.10 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.48 | 33.29 | 3.18 | 75.22 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.84 | 95.62 | 4.38 | 7.19 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 15.72 | 31.71 | 2.02 | 35.71 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 24.43 | 70.38 | 2.88 | 38.22 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.85 | 27.35 | 2.78 | 154.42 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.44 | 71.86 | 3.52 | 107.88 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 19.38 | 28.64 | 1.48 | 134.90 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 29.34 | 63.36 | 2.16 | 155.43 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.20 | 22.62 | 2.76 | 140.30 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.81 | 55.86 | 2.97 | 192.67 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 16.72 | 24.36 | 1.46 | 178.87 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 26.34 | 51.26 | 1.95 | 236.41 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.15 | 52.52 | 3.06 | 172.15 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.97 | 100.54 | 2.80 | 642.37 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.22 | 59.34 | 3.09 | 205.35 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 38.26 | 104.00 | 2.72 | 633.20 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.85 | 22.47 | 2.86 | 127.81 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.20 | 46.84 | 3.30 | 182.34 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.88 | 24.79 | 2.79 | 146.54 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.68 | 47.61 | 3.04 | 192.16 |
| http/html-1m | 1048576 | 1 | libzstd | 6.32 | 16.66 | 2.64 | 117.55 |
| http/html-1m | 1048576 | 1 | stdx | 13.03 | 42.00 | 3.22 | 134.61 |
| http/html-1m | 1048576 | 3 | libzstd | 10.02 | 18.50 | 1.85 | 126.98 |
| http/html-1m | 1048576 | 3 | stdx | 16.39 | 39.37 | 2.40 | 177.57 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.33 | 42.58 | 2.97 | 119.18 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.79 | 83.13 | 2.79 | 533.34 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.94 | 44.69 | 2.99 | 134.68 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.85 | 84.87 | 2.75 | 535.16 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.83 | 15.00 | 3.11 | 58.91 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.75 | 33.78 | 3.47 | 116.10 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.43 | 16.31 | 3.01 | 73.38 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.71 | 34.58 | 3.23 | 122.05 |
| http/json-1m | 1048576 | 1 | libzstd | 4.06 | 12.47 | 3.07 | 53.38 |
| http/json-1m | 1048576 | 1 | stdx | 9.07 | 30.70 | 3.39 | 85.53 |
| http/json-1m | 1048576 | 3 | libzstd | 6.72 | 14.06 | 2.09 | 68.99 |
| http/json-1m | 1048576 | 3 | stdx | 11.78 | 30.64 | 2.60 | 119.33 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.65 | 57.29 | 3.07 | 198.44 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 40.14 | 113.49 | 2.83 | 694.55 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.57 | 65.62 | 3.04 | 268.50 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.44 | 116.54 | 2.75 | 684.01 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 9.01 | 26.53 | 2.95 | 134.30 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.75 | 55.71 | 3.32 | 200.14 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.20 | 28.96 | 2.84 | 158.13 |
| http/js-16kx64 | 1048576 | 3 | stdx | 18.10 | 55.35 | 3.06 | 209.00 |
| http/js-1m | 1048576 | 1 | libzstd | 6.62 | 17.80 | 2.69 | 116.45 |
| http/js-1m | 1048576 | 1 | stdx | 14.08 | 45.88 | 3.26 | 135.80 |
| http/js-1m | 1048576 | 3 | libzstd | 10.81 | 19.49 | 1.80 | 125.95 |
| http/js-1m | 1048576 | 3 | stdx | 17.59 | 41.25 | 2.35 | 186.87 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.64 | 46.97 | 3.00 | 144.81 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.50 | 91.65 | 2.82 | 579.76 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.78 | 50.68 | 3.02 | 166.66 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.80 | 93.63 | 2.77 | 582.69 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.25 | 18.99 | 3.04 | 79.96 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.50 | 43.79 | 3.50 | 138.82 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.61 | 19.53 | 2.95 | 94.97 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.94 | 42.34 | 3.27 | 152.80 |
| http/css-1m | 1048576 | 1 | libzstd | 1.52 | 4.57 | 3.01 | 22.01 |
| http/css-1m | 1048576 | 1 | stdx | 4.01 | 14.85 | 3.70 | 30.69 |
| http/css-1m | 1048576 | 3 | libzstd | 2.07 | 5.34 | 2.58 | 19.75 |
| http/css-1m | 1048576 | 3 | stdx | 4.03 | 13.33 | 3.31 | 31.64 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.55 | 12.79 | 3.60 | 6.32 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.16 | 30.66 | 3.35 | 61.71 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 32.14 | 53.05 | 1.65 | 47.22 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 21.75 | 47.43 | 2.18 | 207.77 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.5 | 74.2 | 0.119 | 3.01 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 65.8 | 219.6 | 0.086 | 7.77 | 3.34 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 39.9 | 177.7 | 0.075 | 4.71 | 4.45 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 251.0 | 1024.0 | 0.826 | 29.65 | 4.08 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.6 | 107.5 | 0.139 | 3.61 | 3.52 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.9 | 106.0 | 0.295 | 3.30 | 3.80 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 94.8 | 378.2 | 0.364 | 11.20 | 3.99 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.7 | 161.9 | 0.445 | 5.05 | 3.79 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 90.0 | 451.6 | 0.300 | 10.63 | 5.02 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.6 | 89.5 | 0.004 | 4.06 | 3.25 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 69.2 | 234.7 | 0.041 | 10.18 | 3.39 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 45.2 | 194.5 | 0.050 | 6.65 | 4.31 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 217.4 | 819.1 | 0.959 | 31.99 | 3.77 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.1 | 107.7 | 0.040 | 4.14 | 3.83 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.8 | 105.7 | 0.047 | 4.38 | 3.55 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 95.5 | 346.2 | 0.356 | 14.05 | 3.63 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 33.4 | 144.5 | 0.051 | 4.92 | 4.33 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 91.3 | 406.5 | 0.098 | 13.44 | 4.45 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114849.8 | 403846.2 | 529.237 | 0.67 | 3.52 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 591715.1 | 2503286.2 | 1392.155 | 3.43 | 4.23 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 114088.4 | 404040.2 | 488.845 | 0.66 | 3.54 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3591613.7 | 18223876.2 | 2976.093 | 20.82 | 5.07 |
| string: silesia/dickens | 1 | 172528 | simdjson | 310323.8 | 621743.2 | 586.495 | 1.80 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 226240.2 | 826618.2 | 2249.392 | 1.31 | 3.65 |
| string: silesia/dickens | 1 | 172528 | std.json | 1577268.1 | 4578768.2 | 42421.588 | 9.14 | 2.90 |
| string: silesia/dickens | 1 | 172528 | serde_json | 203802.3 | 802391.2 | 996.103 | 1.18 | 3.94 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1068584.7 | 5284147.0 | 4915.186 | 6.19 | 4.94 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1562764.1 | 4799763.6 | 1246.357 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14394470.4 | 56816152.6 | 39637.071 | 12.09 | 3.95 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1561159.9 | 4799854.6 | 1100.429 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 29057459.9 | 132108253.6 | 159701.714 | 24.41 | 4.55 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4590092.5 | 7053838.6 | 557.286 | 3.86 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1813356.9 | 7322017.6 | 14190.714 | 1.52 | 4.04 |
| string: http/json-1m | 1 | 1190272 | std.json | 10365952.8 | 47381213.6 | 31812.714 | 8.71 | 4.57 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3788042.1 | 15226459.6 | 5972.000 | 3.18 | 4.02 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9280145.6 | 48022724.0 | 27077.714 | 7.80 | 5.17 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2066647.4 | 5765413.8 | 4503.250 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6166683.1 | 22589263.8 | 6968.750 | 3.27 | 3.66 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2056275.4 | 5765504.8 | 3843.125 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47653994.8 | 227842320.8 | 285881.000 | 25.31 | 4.78 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3682213.4 | 7945848.8 | 1976.500 | 1.96 | 2.16 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7155245.4 | 12276727.8 | 278009.625 | 3.80 | 1.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17490661.5 | 63617055.8 | 267573.500 | 9.29 | 3.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9384728.3 | 24440755.8 | 327451.000 | 4.98 | 2.60 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39022382.1 | 160371714.6 | 832285.750 | 20.72 | 4.11 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12957816.0 | 42561069.3 | 243950.667 | 2.55 | 3.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 159657139.7 | 667246747.3 | 395200.667 | 31.46 | 4.18 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12907118.3 | 42561160.3 | 244318.000 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 159752970.0 | 639992662.3 | 423274.333 | 31.48 | 4.01 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17621411.3 | 49745819.3 | 220295.000 | 3.47 | 2.82 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 13804004.3 | 44816977.3 | 460047.000 | 2.72 | 3.25 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79228917.0 | 314900845.3 | 456728.333 | 15.61 | 3.97 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36124039.3 | 131556135.3 | 574765.667 | 7.12 | 3.64 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66711103.3 | 273921468.0 | 835197.667 | 13.14 | 4.11 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 96158.1 | 303836.7 | 8.484 | 0.18 | 3.16 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 190497.8 | 623465.7 | 9.226 | 0.36 | 3.27 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 189329.6 | 623245.7 | 10.645 | 0.36 | 3.29 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10299586.3 | 53478202.7 | 9.097 | 19.64 | 5.19 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 492187.9 | 1376732.7 | 3.968 | 0.94 | 2.80 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 541922.2 | 2195905.7 | 7.806 | 1.03 | 4.05 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3490147.5 | 12808414.7 | 61388.194 | 6.66 | 3.67 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 288267.5 | 1179969.7 | 6.935 | 0.55 | 4.09 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2283443.6 | 12787156.1 | 241.000 | 4.36 | 5.60 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.8 | 81.8 | 0.108 | 2.34 | 4.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.2 | 153.6 | 0.127 | 4.16 | 4.36 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 23.4 | 103.2 | 0.096 | 2.76 | 4.42 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 218.0 | 981.0 | 0.925 | 25.75 | 4.50 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 19.4 | 79.5 | 0.107 | 2.29 | 4.09 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.2 | 94.1 | 0.135 | 2.74 | 4.05 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.2 | 105.4 | 0.245 | 3.21 | 3.88 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.3 | 310.8 | 0.366 | 8.18 | 4.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.5 | 255.3 | 0.491 | 7.50 | 4.02 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.5 | 315.1 | 0.236 | 8.09 | 4.60 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 25.7 | 82.8 | 0.024 | 3.79 | 3.21 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 43.4 | 153.9 | 0.027 | 6.39 | 3.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 31.4 | 101.7 | 0.024 | 4.62 | 3.24 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 169.6 | 718.3 | 1.256 | 24.96 | 4.24 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 23.8 | 81.5 | 0.025 | 3.50 | 3.42 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 27.4 | 96.6 | 0.032 | 4.03 | 3.52 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 44.0 | 117.7 | 0.032 | 6.48 | 2.67 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 64.0 | 271.2 | 0.244 | 9.42 | 4.24 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 53.3 | 211.7 | 0.041 | 7.85 | 3.97 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 83.4 | 331.7 | 0.086 | 12.28 | 3.98 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 85059.6 | 280786.2 | 723.928 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84808.1 | 280732.2 | 718.103 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84898.2 | 280724.2 | 720.237 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3354838.5 | 16047574.2 | 2950.649 | 19.45 | 4.78 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 83293.0 | 274401.2 | 666.526 | 0.48 | 3.29 |
| string: silesia/dickens | 1 | 172528 | simdjson | 207464.2 | 674008.2 | 2084.000 | 1.20 | 3.25 |
| string: silesia/dickens | 1 | 172528 | yyjson | 213878.4 | 848559.2 | 1311.216 | 1.24 | 3.97 |
| string: silesia/dickens | 1 | 172528 | std.json | 1366686.0 | 2890892.2 | 53884.093 | 7.92 | 2.12 |
| string: silesia/dickens | 1 | 172528 | serde_json | 375260.5 | 1586249.2 | 2297.753 | 2.18 | 4.23 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 587115.6 | 2970295.1 | 2919.546 | 3.40 | 5.06 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1284000.5 | 3582350.6 | 11942.429 | 1.08 | 2.79 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1272024.2 | 3582290.6 | 11524.286 | 1.07 | 2.82 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1274994.9 | 3582278.6 | 11661.643 | 1.07 | 2.81 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25516182.5 | 109856348.6 | 140288.929 | 21.44 | 4.31 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1235734.9 | 3370022.6 | 11316.571 | 1.04 | 2.73 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2993694.6 | 10460754.6 | 29363.143 | 2.52 | 3.49 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2671191.1 | 11226214.6 | 9603.500 | 2.24 | 4.20 |
| string: http/json-1m | 1 | 1190272 | std.json | 9044662.2 | 43287986.6 | 16218.286 | 7.60 | 4.79 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4187472.0 | 17941088.6 | 10984.143 | 3.52 | 4.28 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5275514.9 | 26999673.9 | 11180.214 | 4.43 | 5.12 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2077743.0 | 6088099.8 | 4664.125 | 1.10 | 2.93 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2064679.0 | 6088039.8 | 4116.125 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2061069.6 | 6088027.8 | 4063.625 | 1.09 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43620541.4 | 193466548.8 | 275391.125 | 23.16 | 4.44 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2073981.0 | 5875346.8 | 4887.875 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2714887.8 | 7144135.8 | 20822.375 | 1.44 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12443755.0 | 26334410.8 | 417013.250 | 6.61 | 2.12 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20518549.8 | 56837736.8 | 554292.250 | 10.90 | 2.77 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11221491.1 | 33662338.8 | 337659.000 | 5.96 | 3.00 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18272757.1 | 76319463.1 | 251344.500 | 9.70 | 4.18 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113486.4 | 426376.7 | 2.677 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113449.7 | 426318.7 | 2.419 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113262.8 | 426299.7 | 2.452 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 635552.3 | 3146479.7 | 4.968 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113865.6 | 426343.7 | 2.194 | 0.22 | 3.74 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1209908.8 | 3866907.7 | 7.161 | 2.31 | 3.20 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1630800.2 | 5833344.7 | 5.097 | 3.11 | 3.58 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3578313.3 | 13108830.7 | 61249.774 | 6.83 | 3.66 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1790287.6 | 7405810.7 | 3.645 | 3.41 | 4.14 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2392355.7 | 12748313.0 | 16.258 | 4.56 | 5.33 |
