# bench-profile

| Field | Value |
|---|---|
| Commit | 06a7341 |
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
| silesia/dickens | 10192446 | zlib | 7.99 | 15.77 | 1.97 | 300.90 |
| silesia/dickens | 10192446 | zlib-ng | 4.89 | 10.50 | 2.15 | 67.78 |
| silesia/dickens | 10192446 | libdeflate | 3.48 | 9.56 | 2.75 | 65.88 |
| silesia/dickens | 10192446 | Wuffs | 4.92 | 10.85 | 2.20 | 97.25 |
| silesia/dickens | 10192446 | stdx | 3.05 | 7.15 | 2.34 | 76.23 |
| silesia/mozilla | 51220480 | zlib | 7.79 | 14.13 | 1.81 | 243.32 |
| silesia/mozilla | 51220480 | zlib-ng | 4.96 | 8.95 | 1.80 | 85.61 |
| silesia/mozilla | 51220480 | libdeflate | 3.49 | 7.63 | 2.18 | 71.10 |
| silesia/mozilla | 51220480 | Wuffs | 5.73 | 10.84 | 1.89 | 132.92 |
| silesia/mozilla | 51220480 | stdx | 3.66 | 6.29 | 1.72 | 89.13 |
| silesia/mr | 9970564 | zlib | 7.72 | 15.26 | 1.98 | 198.41 |
| silesia/mr | 9970564 | zlib-ng | 4.82 | 9.98 | 2.07 | 67.73 |
| silesia/mr | 9970564 | libdeflate | 3.37 | 8.58 | 2.55 | 61.19 |
| silesia/mr | 9970564 | Wuffs | 5.29 | 10.93 | 2.07 | 100.81 |
| silesia/mr | 9970564 | stdx | 3.13 | 6.70 | 2.14 | 69.36 |
| silesia/nci | 33553445 | zlib | 2.95 | 7.25 | 2.46 | 79.88 |
| silesia/nci | 33553445 | zlib-ng | 1.65 | 3.13 | 1.89 | 33.60 |
| silesia/nci | 33553445 | libdeflate | 1.22 | 2.66 | 2.17 | 27.65 |
| silesia/nci | 33553445 | Wuffs | 1.78 | 3.38 | 1.90 | 42.41 |
| silesia/nci | 33553445 | stdx | 1.35 | 2.20 | 1.63 | 37.23 |
| silesia/ooffice | 6152192 | zlib | 11.05 | 17.83 | 1.61 | 401.70 |
| silesia/ooffice | 6152192 | zlib-ng | 6.93 | 12.04 | 1.74 | 139.89 |
| silesia/ooffice | 6152192 | libdeflate | 4.91 | 10.45 | 2.13 | 125.63 |
| silesia/ooffice | 6152192 | Wuffs | 8.14 | 14.47 | 1.78 | 221.41 |
| silesia/ooffice | 6152192 | stdx | 5.14 | 8.55 | 1.66 | 150.70 |
| silesia/osdb | 10085684 | zlib | 6.83 | 13.54 | 1.98 | 172.41 |
| silesia/osdb | 10085684 | zlib-ng | 4.31 | 8.38 | 1.95 | 52.86 |
| silesia/osdb | 10085684 | libdeflate | 2.86 | 6.91 | 2.41 | 29.85 |
| silesia/osdb | 10085684 | Wuffs | 5.19 | 10.56 | 2.03 | 82.42 |
| silesia/osdb | 10085684 | stdx | 2.84 | 5.65 | 1.99 | 41.19 |
| silesia/reymont | 6627202 | zlib | 6.64 | 12.73 | 1.92 | 254.17 |
| silesia/reymont | 6627202 | zlib-ng | 3.72 | 7.72 | 2.07 | 59.71 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.64 | 51.03 |
| silesia/reymont | 6627202 | Wuffs | 4.24 | 8.40 | 1.98 | 112.15 |
| silesia/reymont | 6627202 | stdx | 2.30 | 5.11 | 2.23 | 64.04 |
| silesia/samba | 21606400 | zlib | 5.50 | 11.09 | 2.02 | 170.41 |
| silesia/samba | 21606400 | zlib-ng | 3.38 | 6.47 | 1.92 | 55.87 |
| silesia/samba | 21606400 | libdeflate | 2.38 | 5.58 | 2.35 | 42.93 |
| silesia/samba | 21606400 | Wuffs | 3.69 | 7.33 | 1.99 | 81.28 |
| silesia/samba | 21606400 | stdx | 2.39 | 4.46 | 1.87 | 56.15 |
| silesia/sao | 7251944 | zlib | 9.93 | 20.36 | 2.05 | 197.36 |
| silesia/sao | 7251944 | zlib-ng | 7.89 | 14.83 | 1.88 | 79.42 |
| silesia/sao | 7251944 | libdeflate | 5.75 | 12.73 | 2.21 | 78.86 |
| silesia/sao | 7251944 | Wuffs | 8.16 | 18.14 | 2.22 | 85.83 |
| silesia/sao | 7251944 | stdx | 5.63 | 10.32 | 1.83 | 87.16 |
| silesia/webster | 41458703 | zlib | 7.01 | 12.99 | 1.85 | 273.50 |
| silesia/webster | 41458703 | zlib-ng | 4.23 | 8.04 | 1.90 | 84.69 |
| silesia/webster | 41458703 | libdeflate | 2.95 | 7.17 | 2.43 | 68.48 |
| silesia/webster | 41458703 | Wuffs | 4.52 | 8.62 | 1.91 | 123.17 |
| silesia/webster | 41458703 | stdx | 2.85 | 5.56 | 1.95 | 87.02 |
| silesia/x-ray | 8474240 | zlib | 12.30 | 23.82 | 1.94 | 324.67 |
| silesia/x-ray | 8474240 | zlib-ng | 9.06 | 17.39 | 1.92 | 124.19 |
| silesia/x-ray | 8474240 | libdeflate | 6.56 | 15.26 | 2.33 | 124.41 |
| silesia/x-ray | 8474240 | Wuffs | 10.13 | 20.40 | 2.01 | 192.60 |
| silesia/x-ray | 8474240 | stdx | 6.20 | 11.49 | 1.85 | 137.93 |
| silesia/xml | 5345280 | zlib | 3.64 | 8.20 | 2.25 | 116.25 |
| silesia/xml | 5345280 | zlib-ng | 2.00 | 3.88 | 1.94 | 42.55 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 31.49 |
| silesia/xml | 5345280 | Wuffs | 2.20 | 4.14 | 1.88 | 60.90 |
| silesia/xml | 5345280 | stdx | 1.34 | 2.65 | 1.98 | 41.74 |
| canterbury/alice29.txt | 152089 | zlib | 7.59 | 15.08 | 1.99 | 285.55 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.51 | 9.91 | 2.20 | 59.96 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.19 | 8.96 | 2.81 | 55.74 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.70 | 10.37 | 2.21 | 98.20 |
| canterbury/alice29.txt | 152089 | stdx | 2.71 | 6.99 | 2.58 | 62.28 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.14 | 16.11 | 1.98 | 303.68 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 72.71 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.61 | 9.82 | 2.72 | 68.56 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.08 | 11.34 | 2.23 | 100.21 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.08 | 7.52 | 2.44 | 79.02 |
| canterbury/cp.html | 24603 | zlib | 6.56 | 14.20 | 2.17 | 174.95 |
| canterbury/cp.html | 24603 | zlib-ng | 4.16 | 9.50 | 2.28 | 35.48 |
| canterbury/cp.html | 24603 | libdeflate | 2.88 | 7.95 | 2.76 | 19.63 |
| canterbury/cp.html | 24603 | Wuffs | 4.49 | 10.87 | 2.42 | 57.40 |
| canterbury/cp.html | 24603 | stdx | 2.65 | 7.19 | 2.71 | 13.45 |
| canterbury/fields.c | 11150 | zlib | 4.61 | 14.65 | 3.18 | 36.72 |
| canterbury/fields.c | 11150 | zlib-ng | 3.90 | 10.20 | 2.62 | 13.38 |
| canterbury/fields.c | 11150 | libdeflate | 2.78 | 8.32 | 2.99 | 1.08 |
| canterbury/fields.c | 11150 | Wuffs | 3.81 | 11.51 | 3.02 | 8.41 |
| canterbury/fields.c | 11150 | stdx | 2.51 | 7.64 | 3.05 | 4.83 |
| canterbury/grammar.lsp | 3721 | zlib | 6.24 | 21.22 | 3.40 | 4.12 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.83 | 17.48 | 3.00 | 8.06 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.40 | 12.05 | 2.74 | 0.52 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.96 | 18.87 | 3.16 | 3.92 |
| canterbury/grammar.lsp | 3721 | stdx | 3.85 | 12.18 | 3.17 | 1.29 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.97 | 12.20 | 3.08 | 49.20 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.85 | 6.97 | 2.45 | 12.57 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.29 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.20 | 8.67 | 2.71 | 14.85 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.66 | 2.67 | 16.53 |
| canterbury/lcet10.txt | 426754 | zlib | 7.38 | 14.53 | 1.97 | 279.61 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.33 | 9.39 | 2.17 | 60.82 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 54.63 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.58 | 9.85 | 2.15 | 101.47 |
| canterbury/lcet10.txt | 426754 | stdx | 2.60 | 6.42 | 2.47 | 66.66 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.30 | 16.53 | 1.99 | 310.90 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.26 | 11.19 | 2.12 | 76.68 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.76 | 10.19 | 2.71 | 76.67 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.15 | 11.53 | 2.24 | 99.66 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.14 | 7.63 | 2.43 | 85.20 |
| canterbury/ptt5 | 513216 | zlib | 4.40 | 7.79 | 1.77 | 100.38 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.49 |
| canterbury/ptt5 | 513216 | libdeflate | 1.44 | 3.02 | 2.09 | 37.89 |
| canterbury/ptt5 | 513216 | Wuffs | 2.19 | 4.02 | 1.84 | 58.61 |
| canterbury/ptt5 | 513216 | stdx | 1.44 | 2.55 | 1.77 | 49.01 |
| canterbury/sum | 38240 | zlib | 7.32 | 14.98 | 2.04 | 217.87 |
| canterbury/sum | 38240 | zlib-ng | 4.64 | 10.02 | 2.16 | 56.54 |
| canterbury/sum | 38240 | libdeflate | 3.38 | 8.34 | 2.47 | 41.92 |
| canterbury/sum | 38240 | Wuffs | 5.01 | 11.41 | 2.28 | 77.16 |
| canterbury/sum | 38240 | stdx | 3.06 | 7.73 | 2.53 | 30.53 |
| canterbury/xargs.1 | 4227 | zlib | 6.66 | 22.08 | 3.31 | 5.92 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.38 | 17.97 | 2.82 | 9.03 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.75 | 13.27 | 2.79 | 0.60 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.50 | 19.63 | 3.02 | 9.99 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 12.86 | 3.03 | 2.19 |
| canterbury-large/E.coli | 4638690 | zlib | 5.94 | 14.55 | 2.45 | 175.07 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.24 | 9.68 | 2.28 | 47.56 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.92 | 48.69 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.00 | 9.64 | 2.41 | 61.50 |
| canterbury-large/E.coli | 4638690 | stdx | 2.48 | 6.72 | 2.71 | 53.61 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.74 | 13.26 | 1.97 | 259.77 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.79 | 8.26 | 2.18 | 53.60 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.84 | 45.31 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.16 | 8.72 | 2.10 | 100.86 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.24 | 5.57 | 2.49 | 55.70 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.96 | 12.69 | 1.82 | 272.02 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.73 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.04 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.51 | 8.44 | 1.87 | 129.48 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.73 | 5.40 | 1.98 | 90.49 |
| http/html-1kx1024 | 1048576 | zlib | 15.84 | 32.44 | 2.05 | 349.58 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.69 | 28.43 | 2.24 | 217.19 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.59 | 20.05 | 1.89 | 155.94 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.59 | 35.05 | 2.40 | 264.29 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 137.69 |
| http/html-16kx64 | 1048576 | zlib | 6.01 | 11.79 | 1.96 | 214.66 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.34 |
| http/html-16kx64 | 1048576 | libdeflate | 2.64 | 6.04 | 2.29 | 60.51 |
| http/html-16kx64 | 1048576 | Wuffs | 4.26 | 8.51 | 2.00 | 116.91 |
| http/html-16kx64 | 1048576 | stdx | 2.51 | 5.56 | 2.22 | 58.71 |
| http/html-1m | 1048576 | zlib | 4.65 | 9.51 | 2.05 | 172.39 |
| http/html-1m | 1048576 | zlib-ng | 2.63 | 5.03 | 1.92 | 60.05 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.30 |
| http/html-1m | 1048576 | Wuffs | 2.96 | 5.42 | 1.83 | 90.33 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.10 | 52.38 |
| http/json-1kx1024 | 1048576 | zlib | 9.71 | 20.83 | 2.14 | 192.79 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.39 | 16.69 | 2.26 | 130.70 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.84 | 16.72 | 1.89 | 92.16 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.40 | 31.72 | 2.78 | 145.13 |
| http/json-1kx1024 | 1048576 | stdx | 5.03 | 13.12 | 2.61 | 81.07 |
| http/json-16kx64 | 1048576 | zlib | 3.94 | 9.62 | 2.44 | 101.50 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.84 |
| http/json-16kx64 | 1048576 | libdeflate | 1.91 | 4.24 | 2.22 | 39.73 |
| http/json-16kx64 | 1048576 | Wuffs | 2.81 | 6.35 | 2.26 | 58.10 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.26 | 39.35 |
| http/json-1m | 1048576 | zlib | 3.25 | 8.25 | 2.54 | 82.11 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.02 | 37.47 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.42 | 32.20 |
| http/json-1m | 1048576 | Wuffs | 2.04 | 4.29 | 2.10 | 44.11 |
| http/json-1m | 1048576 | stdx | 1.33 | 2.67 | 2.00 | 39.96 |
| http/js-1kx1024 | 1048576 | zlib | 17.33 | 35.33 | 2.04 | 403.59 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.77 | 31.25 | 2.27 | 238.31 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.27 | 21.58 | 1.92 | 179.16 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.75 | 37.71 | 2.39 | 295.46 |
| http/js-1kx1024 | 1048576 | stdx | 9.28 | 22.85 | 2.46 | 159.40 |
| http/js-16kx64 | 1048576 | zlib | 6.91 | 13.06 | 1.89 | 254.69 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.98 | 91.63 |
| http/js-16kx64 | 1048576 | libdeflate | 3.05 | 7.01 | 2.29 | 72.06 |
| http/js-16kx64 | 1048576 | Wuffs | 4.84 | 9.70 | 2.00 | 130.40 |
| http/js-16kx64 | 1048576 | stdx | 3.01 | 6.54 | 2.17 | 72.47 |
| http/js-1m | 1048576 | zlib | 5.16 | 10.26 | 1.99 | 195.97 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 60.10 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 42.05 |
| http/js-1m | 1048576 | Wuffs | 3.26 | 6.10 | 1.87 | 96.04 |
| http/js-1m | 1048576 | stdx | 1.81 | 3.89 | 2.15 | 55.27 |
| http/css-1kx1024 | 1048576 | zlib | 13.14 | 27.18 | 2.07 | 281.20 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.25 | 23.04 | 2.25 | 171.62 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.17 | 17.37 | 1.89 | 121.25 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.01 | 29.48 | 2.45 | 208.15 |
| http/css-1kx1024 | 1048576 | stdx | 6.67 | 17.64 | 2.64 | 100.76 |
| http/css-16kx64 | 1048576 | zlib | 4.66 | 10.12 | 2.17 | 151.44 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.19 | 49.88 |
| http/css-16kx64 | 1048576 | libdeflate | 1.87 | 4.69 | 2.51 | 28.39 |
| http/css-16kx64 | 1048576 | Wuffs | 3.12 | 6.97 | 2.24 | 70.15 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.53 | 28.46 |
| http/css-1m | 1048576 | zlib | 3.37 | 8.00 | 2.37 | 107.35 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.21 | 28.82 |
| http/css-1m | 1048576 | libdeflate | 1.05 | 3.18 | 3.04 | 10.54 |
| http/css-1m | 1048576 | Wuffs | 1.91 | 4.08 | 2.14 | 44.81 |
| http/css-1m | 1048576 | stdx | 1.02 | 2.56 | 2.51 | 21.58 |
| shuffled/dickens-1m | 1048576 | zlib | 12.74 | 22.42 | 1.76 | 371.39 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.75 | 16.72 | 1.71 | 199.02 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.04 | 14.95 | 2.12 | 194.73 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.66 | 18.95 | 1.96 | 205.46 |
| shuffled/dickens-1m | 1048576 | stdx | 7.04 | 11.89 | 1.69 | 205.58 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.63 | 14.04 | 3.87 | 3.50 |
| silesia/dickens | 10192446 | stdx | 3.73 | 12.47 | 3.34 | 3.66 |
| silesia/mozilla | 51220480 | libzstd | 2.87 | 9.62 | 3.35 | 30.08 |
| silesia/mozilla | 51220480 | stdx | 2.90 | 9.68 | 3.33 | 15.62 |
| silesia/mr | 9970564 | libzstd | 3.14 | 11.98 | 3.81 | 6.20 |
| silesia/mr | 9970564 | stdx | 3.19 | 10.83 | 3.39 | 5.23 |
| silesia/nci | 33553445 | libzstd | 1.71 | 4.84 | 2.83 | 23.59 |
| silesia/nci | 33553445 | stdx | 1.83 | 4.63 | 2.52 | 13.58 |
| silesia/ooffice | 6152192 | libzstd | 3.46 | 12.14 | 3.50 | 31.22 |
| silesia/ooffice | 6152192 | stdx | 3.39 | 12.40 | 3.66 | 12.13 |
| silesia/osdb | 10085684 | libzstd | 2.43 | 8.44 | 3.48 | 15.48 |
| silesia/osdb | 10085684 | stdx | 2.52 | 8.11 | 3.22 | 15.40 |
| silesia/reymont | 6627202 | libzstd | 3.24 | 11.61 | 3.58 | 11.63 |
| silesia/reymont | 6627202 | stdx | 3.42 | 10.36 | 3.03 | 13.00 |
| silesia/samba | 21606400 | libzstd | 2.13 | 7.39 | 3.47 | 18.65 |
| silesia/samba | 21606400 | stdx | 2.19 | 6.83 | 3.12 | 17.60 |
| silesia/sao | 7251944 | libzstd | 3.87 | 12.69 | 3.28 | 26.43 |
| silesia/sao | 7251944 | stdx | 3.55 | 12.58 | 3.54 | 6.17 |
| silesia/webster | 41458703 | libzstd | 3.32 | 11.22 | 3.38 | 16.24 |
| silesia/webster | 41458703 | stdx | 3.49 | 10.05 | 2.88 | 17.44 |
| silesia/x-ray | 8474240 | libzstd | 3.99 | 14.93 | 3.74 | 18.76 |
| silesia/x-ray | 8474240 | stdx | 3.57 | 13.23 | 3.71 | 8.53 |
| silesia/xml | 5345280 | libzstd | 1.54 | 5.55 | 3.60 | 22.85 |
| silesia/xml | 5345280 | stdx | 1.53 | 5.16 | 3.37 | 16.99 |
| canterbury/alice29.txt | 152089 | libzstd | 3.36 | 16.18 | 4.82 | 4.16 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.36 | 0.44 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.00 | 14.25 | 4.75 | 3.30 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.29 | 0.23 |
| canterbury/cp.html | 24603 | libzstd | 2.67 | 10.74 | 4.02 | 9.19 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.11 | 0.30 |
| canterbury/fields.c | 11150 | libzstd | 3.13 | 13.61 | 4.35 | 9.59 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.23 | 0.17 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.23 | 16.93 | 4.00 | 6.40 |
| canterbury/grammar.lsp | 3721 | stdx | 4.13 | 16.54 | 4.00 | 0.41 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.49 | 11.22 | 4.51 | 7.65 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.68 | 11.32 | 4.22 | 0.95 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.73 | 12.87 | 4.71 | 5.27 |
| canterbury/lcet10.txt | 426754 | stdx | 2.71 | 11.52 | 4.24 | 2.56 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.17 | 15.14 | 4.78 | 1.60 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.27 | 0.88 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.50 | 3.10 | 24.37 |
| canterbury/ptt5 | 513216 | stdx | 1.35 | 4.46 | 3.31 | 13.85 |
| canterbury/sum | 38240 | libzstd | 2.65 | 10.51 | 3.97 | 10.67 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.09 | 0.28 |
| canterbury/xargs.1 | 4227 | libzstd | 4.28 | 17.40 | 4.07 | 10.24 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.17 | 4.05 | 0.16 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.03 | 13.63 | 4.49 | 2.19 |
| canterbury-large/E.coli | 4638690 | stdx | 3.11 | 12.04 | 3.88 | 2.91 |
| canterbury-large/bible.txt | 4047392 | libzstd | 3.01 | 11.99 | 3.99 | 8.53 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.10 | 10.64 | 3.43 | 9.32 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.56 | 9.59 | 3.75 | 19.94 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.64 | 8.64 | 3.27 | 21.56 |
| http/html-1kx1024 | 1048576 | libzstd | 7.41 | 21.63 | 2.92 | 62.90 |
| http/html-1kx1024 | 1048576 | stdx | 7.43 | 22.46 | 3.02 | 76.02 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.72 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.60 | 30.84 |
| http/html-1m | 1048576 | libzstd | 2.00 | 7.86 | 3.94 | 24.22 |
| http/html-1m | 1048576 | stdx | 2.01 | 7.12 | 3.54 | 24.96 |
| http/json-1kx1024 | 1048576 | libzstd | 6.38 | 17.37 | 2.72 | 49.06 |
| http/json-1kx1024 | 1048576 | stdx | 6.19 | 17.86 | 2.89 | 52.91 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.22 | 3.53 | 27.81 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.58 | 19.90 |
| http/json-1m | 1048576 | libzstd | 1.72 | 6.04 | 3.51 | 27.40 |
| http/json-1m | 1048576 | stdx | 1.64 | 5.91 | 3.59 | 14.55 |
| http/js-1kx1024 | 1048576 | libzstd | 8.44 | 26.38 | 3.12 | 72.81 |
| http/js-1kx1024 | 1048576 | stdx | 9.02 | 27.60 | 3.06 | 112.76 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.71 | 4.00 | 24.46 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.74 | 26.27 |
| http/js-1m | 1048576 | libzstd | 2.02 | 8.18 | 4.04 | 20.29 |
| http/js-1m | 1048576 | stdx | 2.09 | 7.48 | 3.58 | 21.66 |
| http/css-1kx1024 | 1048576 | libzstd | 7.04 | 19.70 | 2.80 | 53.42 |
| http/css-1kx1024 | 1048576 | stdx | 6.82 | 19.96 | 2.93 | 63.13 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.69 | 3.88 | 23.29 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.27 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.57 | 3.86 | 5.59 |
| http/css-1m | 1048576 | stdx | 0.72 | 2.49 | 3.47 | 4.07 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.81 | 9.40 | 3.34 | 28.64 |
| shuffled/dickens-1m | 1048576 | stdx | 2.74 | 9.19 | 3.36 | 12.45 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.64 | 17.04 | 2.23 | 100.82 |
| silesia/dickens | 1048576 | stdx | 5.13 | 12.38 | 2.41 | 54.67 |
| silesia/mozilla | 1048576 | Google | 13.62 | 27.77 | 2.04 | 47.00 |
| silesia/mozilla | 1048576 | stdx | 8.33 | 15.02 | 1.80 | 47.02 |
| silesia/mr | 1048576 | Google | 8.98 | 20.24 | 2.25 | 102.75 |
| silesia/mr | 1048576 | stdx | 5.85 | 13.25 | 2.27 | 88.29 |
| silesia/nci | 1048576 | Google | 2.59 | 5.69 | 2.19 | 52.05 |
| silesia/nci | 1048576 | stdx | 1.96 | 3.95 | 2.02 | 55.06 |
| silesia/ooffice | 1048576 | Google | 14.33 | 29.28 | 2.04 | 287.97 |
| silesia/ooffice | 1048576 | stdx | 10.89 | 20.33 | 1.87 | 322.14 |
| silesia/osdb | 1048576 | Google | 8.30 | 17.38 | 2.09 | 96.17 |
| silesia/osdb | 1048576 | stdx | 5.18 | 10.57 | 2.04 | 92.29 |
| silesia/reymont | 1048576 | Google | 5.48 | 12.73 | 2.32 | 81.50 |
| silesia/reymont | 1048576 | stdx | 3.74 | 9.25 | 2.47 | 47.72 |
| silesia/samba | 1048576 | Google | 7.63 | 16.22 | 2.13 | 95.91 |
| silesia/samba | 1048576 | stdx | 5.07 | 10.71 | 2.11 | 66.96 |
| silesia/sao | 1048576 | Google | 16.89 | 36.97 | 2.19 | 162.00 |
| silesia/sao | 1048576 | stdx | 10.44 | 22.65 | 2.17 | 142.27 |
| silesia/webster | 1048576 | Google | 6.64 | 14.07 | 2.12 | 115.07 |
| silesia/webster | 1048576 | stdx | 4.41 | 9.98 | 2.26 | 68.86 |
| silesia/x-ray | 1048576 | Google | 19.74 | 38.46 | 1.95 | 234.31 |
| silesia/x-ray | 1048576 | stdx | 14.67 | 30.18 | 2.06 | 234.88 |
| silesia/xml | 1048576 | Google | 3.54 | 7.65 | 2.16 | 65.69 |
| silesia/xml | 1048576 | stdx | 2.44 | 5.40 | 2.21 | 47.22 |
| canterbury/alice29.txt | 152089 | Google | 8.90 | 20.66 | 2.32 | 135.70 |
| canterbury/alice29.txt | 152089 | stdx | 6.06 | 15.33 | 2.53 | 81.63 |
| canterbury/asyoulik.txt | 125179 | Google | 10.43 | 23.83 | 2.28 | 170.19 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.10 | 17.43 | 2.46 | 107.38 |
| canterbury/cp.html | 24603 | Google | 9.14 | 22.18 | 2.43 | 112.50 |
| canterbury/cp.html | 24603 | stdx | 6.05 | 17.15 | 2.84 | 52.40 |
| canterbury/fields.c | 11150 | Google | 7.10 | 21.25 | 3.00 | 22.75 |
| canterbury/fields.c | 11150 | stdx | 4.89 | 17.08 | 3.49 | 2.45 |
| canterbury/grammar.lsp | 3721 | Google | 9.86 | 30.23 | 3.07 | 5.82 |
| canterbury/grammar.lsp | 3721 | stdx | 7.15 | 25.04 | 3.50 | 0.60 |
| canterbury/kennedy.xls | 1029744 | Google | 5.51 | 17.05 | 3.10 | 37.29 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.82 | 12.94 | 3.39 | 33.79 |
| canterbury/lcet10.txt | 426754 | Google | 7.79 | 17.42 | 2.24 | 129.23 |
| canterbury/lcet10.txt | 426754 | stdx | 5.20 | 12.96 | 2.49 | 66.45 |
| canterbury/plrabn12.txt | 481861 | Google | 9.14 | 20.94 | 2.29 | 133.41 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.15 | 15.04 | 2.45 | 86.77 |
| canterbury/ptt5 | 513216 | Google | 4.30 | 10.36 | 2.41 | 62.27 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.07 | 65.36 |
| canterbury/sum | 38240 | Google | 10.87 | 26.44 | 2.43 | 159.44 |
| canterbury/sum | 38240 | stdx | 8.20 | 21.11 | 2.57 | 147.45 |
| canterbury/xargs.1 | 4227 | Google | 10.93 | 34.81 | 3.18 | 7.20 |
| canterbury/xargs.1 | 4227 | stdx | 8.48 | 30.44 | 3.59 | 7.43 |
| canterbury-large/E.coli | 1048576 | Google | 7.51 | 19.44 | 2.59 | 1.31 |
| canterbury-large/E.coli | 1048576 | stdx | 6.72 | 13.48 | 2.01 | 1.32 |
| canterbury-large/bible.txt | 1048576 | Google | 5.41 | 12.38 | 2.29 | 80.82 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.56 | 8.93 | 2.51 | 39.68 |
| canterbury-large/world192.txt | 1048576 | Google | 6.29 | 12.88 | 2.05 | 115.24 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.44 | 9.38 | 2.11 | 77.62 |
| http/html-1kx1024 | 1048576 | Google | 17.96 | 42.09 | 2.34 | 388.34 |
| http/html-1kx1024 | 1048576 | stdx | 15.26 | 37.56 | 2.46 | 360.84 |
| http/html-16kx64 | 1048576 | Google | 6.78 | 14.88 | 2.20 | 150.18 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 115.14 |
| http/html-1m | 1048576 | Google | 4.10 | 8.99 | 2.19 | 83.28 |
| http/html-1m | 1048576 | stdx | 2.88 | 6.52 | 2.27 | 54.94 |
| http/json-1kx1024 | 1048576 | Google | 14.27 | 36.74 | 2.57 | 239.00 |
| http/json-1kx1024 | 1048576 | stdx | 12.97 | 33.63 | 2.59 | 277.35 |
| http/json-16kx64 | 1048576 | Google | 4.41 | 11.42 | 2.59 | 81.19 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.43 |
| http/json-1m | 1048576 | Google | 3.43 | 8.66 | 2.52 | 58.88 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.44 | 57.56 |
| http/js-1kx1024 | 1048576 | Google | 19.86 | 46.38 | 2.34 | 427.19 |
| http/js-1kx1024 | 1048576 | stdx | 16.35 | 39.90 | 2.44 | 381.75 |
| http/js-16kx64 | 1048576 | Google | 8.07 | 17.79 | 2.20 | 167.13 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 126.06 |
| http/js-1m | 1048576 | Google | 4.45 | 9.60 | 2.16 | 83.52 |
| http/js-1m | 1048576 | stdx | 3.18 | 7.25 | 2.28 | 55.64 |
| http/css-1kx1024 | 1048576 | Google | 15.34 | 37.48 | 2.44 | 292.42 |
| http/css-1kx1024 | 1048576 | stdx | 13.79 | 34.70 | 2.52 | 302.07 |
| http/css-16kx64 | 1048576 | Google | 4.96 | 11.78 | 2.38 | 100.76 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.97 |
| http/css-1m | 1048576 | Google | 2.45 | 9.43 | 3.84 | 16.85 |
| http/css-1m | 1048576 | stdx | 0.76 | 1.86 | 2.44 | 12.23 |
| shuffled/dickens-1m | 1048576 | Google | 9.67 | 20.34 | 2.10 | 108.77 |
| shuffled/dickens-1m | 1048576 | stdx | 8.82 | 14.53 | 1.65 | 121.06 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.25 | 36.91 | 2.42 | 410.45 |
| silesia/dickens | 10192446 | 1 | stdx | 16.37 | 38.17 | 2.33 | 357.79 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.09 | 87.63 | 1.68 | 694.48 |
| silesia/dickens | 10192446 | 6 | stdx | 49.76 | 84.25 | 1.69 | 1468.45 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.81 | 160.47 | 1.44 | 928.42 |
| silesia/dickens | 10192446 | 9 | stdx | 64.87 | 150.06 | 2.31 | 1399.19 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.10 | 32.62 | 2.31 | 436.79 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.36 | 30.24 | 2.26 | 295.53 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.88 | 70.83 | 2.15 | 578.39 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.52 | 69.96 | 2.22 | 734.56 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.71 | 221.49 | 1.73 | 771.62 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.57 | 125.42 | 2.58 | 780.88 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.98 | 35.02 | 2.92 | 229.36 |
| silesia/mr | 9970564 | 1 | stdx | 12.61 | 34.08 | 2.70 | 187.36 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.31 | 80.54 | 2.10 | 437.68 |
| silesia/mr | 9970564 | 6 | stdx | 39.83 | 83.18 | 2.09 | 979.15 |
| silesia/mr | 9970564 | 9 | libdeflate | 98.05 | 165.48 | 1.69 | 750.80 |
| silesia/mr | 9970564 | 9 | stdx | 78.78 | 184.93 | 2.35 | 1218.42 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.23 | 18.42 | 2.96 | 114.89 |
| silesia/nci | 33553445 | 1 | stdx | 4.95 | 10.88 | 2.20 | 97.47 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.98 | 34.84 | 2.05 | 225.63 |
| silesia/nci | 33553445 | 6 | stdx | 14.45 | 29.54 | 2.04 | 398.30 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.42 | 105.28 | 1.69 | 501.68 |
| silesia/nci | 33553445 | 9 | stdx | 28.34 | 69.01 | 2.44 | 559.54 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.92 | 39.15 | 1.97 | 752.27 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.75 | 39.08 | 2.20 | 429.30 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 41.06 | 79.10 | 1.93 | 954.72 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.61 | 87.83 | 2.11 | 1006.73 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.66 | 127.63 | 1.71 | 1132.98 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.18 | 129.03 | 2.47 | 930.80 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.90 | 30.15 | 2.34 | 352.26 |
| silesia/osdb | 10085684 | 1 | stdx | 12.93 | 27.86 | 2.15 | 292.96 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.35 | 55.67 | 1.96 | 491.68 |
| silesia/osdb | 10085684 | 6 | stdx | 27.24 | 57.39 | 2.11 | 577.94 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.91 | 64.15 | 1.89 | 552.95 |
| silesia/osdb | 10085684 | 9 | stdx | 35.23 | 87.16 | 2.47 | 681.26 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.61 | 32.88 | 2.61 | 309.57 |
| silesia/reymont | 6627202 | 1 | stdx | 13.51 | 33.24 | 2.46 | 270.44 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.09 | 86.58 | 1.80 | 516.75 |
| silesia/reymont | 6627202 | 6 | stdx | 45.48 | 76.81 | 1.69 | 1449.09 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.37 | 276.14 | 1.39 | 839.72 |
| silesia/reymont | 6627202 | 9 | stdx | 74.17 | 160.03 | 2.16 | 1434.40 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.56 | 26.53 | 2.51 | 271.97 |
| silesia/samba | 21606400 | 1 | stdx | 9.97 | 22.23 | 2.23 | 220.80 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.98 | 58.79 | 2.03 | 385.07 |
| silesia/samba | 21606400 | 6 | stdx | 24.16 | 49.83 | 2.06 | 628.01 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.23 | 141.44 | 1.68 | 504.52 |
| silesia/samba | 21606400 | 9 | stdx | 36.15 | 90.81 | 2.51 | 644.20 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.74 | 47.87 | 2.20 | 682.29 |
| silesia/sao | 7251944 | 1 | stdx | 19.17 | 49.92 | 2.60 | 345.80 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.23 | 96.89 | 1.89 | 965.24 |
| silesia/sao | 7251944 | 6 | stdx | 47.10 | 105.66 | 2.24 | 851.83 |
| silesia/sao | 7251944 | 9 | libdeflate | 71.02 | 120.26 | 1.69 | 1106.60 |
| silesia/sao | 7251944 | 9 | stdx | 55.12 | 137.71 | 2.50 | 834.09 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.13 | 30.45 | 2.32 | 386.49 |
| silesia/webster | 41458703 | 1 | stdx | 13.87 | 29.08 | 2.10 | 339.82 |
| silesia/webster | 41458703 | 6 | libdeflate | 37.21 | 66.02 | 1.77 | 570.44 |
| silesia/webster | 41458703 | 6 | stdx | 35.73 | 60.87 | 1.70 | 1129.51 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.68 | 138.85 | 1.47 | 756.98 |
| silesia/webster | 41458703 | 9 | stdx | 48.43 | 110.73 | 2.29 | 1084.79 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.71 | 49.67 | 2.09 | 782.62 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.58 | 50.81 | 2.89 | 261.19 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.89 | 82.77 | 2.52 | 851.86 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.89 | 98.12 | 2.89 | 540.03 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.53 | 91.03 | 2.43 | 1026.30 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.48 | 121.58 | 3.00 | 466.60 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.83 | 21.59 | 2.76 | 175.81 |
| silesia/xml | 5345280 | 1 | stdx | 7.03 | 15.66 | 2.23 | 155.36 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.22 | 40.51 | 1.91 | 264.51 |
| silesia/xml | 5345280 | 6 | stdx | 17.79 | 34.32 | 1.93 | 504.36 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.69 | 89.17 | 1.52 | 372.20 |
| silesia/xml | 5345280 | 9 | stdx | 26.66 | 63.43 | 2.38 | 526.62 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.23 | 35.61 | 2.50 | 376.99 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.05 | 36.12 | 2.40 | 336.11 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.69 | 82.29 | 1.76 | 639.21 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.92 | 77.41 | 1.76 | 1343.18 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.60 | 159.21 | 1.48 | 851.08 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 58.31 | 138.20 | 2.37 | 1273.38 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.14 | 37.20 | 2.46 | 414.76 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.77 | 37.43 | 2.37 | 358.67 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.36 | 85.43 | 1.77 | 713.92 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.17 | 81.92 | 1.77 | 1398.59 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.94 | 136.15 | 1.53 | 939.82 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 60.16 | 144.56 | 2.40 | 1334.66 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.74 | 32.02 | 2.73 | 288.12 |
| canterbury/cp.html | 24603 | 1 | stdx | 10.99 | 27.13 | 2.47 | 245.29 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 27.00 | 62.33 | 2.31 | 486.45 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.65 | 57.05 | 2.41 | 620.51 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.92 | 91.97 | 1.96 | 596.45 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.35 | 88.88 | 2.84 | 649.99 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.73 | 35.92 | 3.69 | 77.60 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.11 | 30.05 | 3.71 | 24.76 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.02 | 69.37 | 2.89 | 224.10 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.69 | 57.62 | 2.78 | 421.99 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.02 | 100.81 | 2.29 | 397.49 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.32 | 92.65 | 3.27 | 443.25 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.02 | 51.51 | 3.96 | 15.64 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.83 | 39.01 | 3.97 | 1.28 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.78 | 87.06 | 3.66 | 30.45 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.19 | 70.80 | 4.12 | 17.42 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.67 | 102.89 | 3.35 | 40.60 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.78 | 99.30 | 4.18 | 55.69 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.38 | 27.18 | 3.68 | 65.18 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.06 | 22.58 | 3.20 | 63.55 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.90 | 73.85 | 2.65 | 96.18 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.36 | 61.98 | 3.20 | 138.34 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.36 | 664.23 | 1.83 | 162.73 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 30.30 | 107.06 | 3.53 | 143.97 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.78 | 33.99 | 2.47 | 369.29 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.48 | 33.92 | 2.34 | 329.83 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.07 | 78.22 | 1.74 | 607.07 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.88 | 73.42 | 1.75 | 1244.67 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.81 | 136.94 | 1.49 | 806.49 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 55.22 | 130.91 | 2.37 | 1200.40 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.81 | 38.62 | 2.44 | 426.95 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.77 | 40.24 | 2.40 | 370.24 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.22 | 91.90 | 1.70 | 752.02 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.72 | 88.89 | 1.72 | 1516.72 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.89 | 166.26 | 1.42 | 1002.75 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 67.85 | 158.18 | 2.33 | 1466.68 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.41 | 18.61 | 2.90 | 141.43 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.99 | 11.03 | 2.21 | 123.11 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.28 | 36.17 | 2.53 | 219.63 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.36 | 29.57 | 2.39 | 311.47 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.66 | 120.86 | 1.99 | 380.07 |
| canterbury/ptt5 | 513216 | 9 | stdx | 41.38 | 126.55 | 3.06 | 591.94 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.80 | 33.49 | 2.62 | 337.68 |
| canterbury/sum | 38240 | 1 | stdx | 12.66 | 29.36 | 2.32 | 304.28 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.63 | 69.87 | 2.44 | 497.55 |
| canterbury/sum | 38240 | 6 | stdx | 26.72 | 65.73 | 2.46 | 661.78 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.46 | 181.91 | 1.93 | 606.35 |
| canterbury/sum | 38240 | 9 | stdx | 39.22 | 112.32 | 2.86 | 658.97 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.44 | 53.06 | 3.95 | 32.10 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.74 | 43.10 | 4.01 | 1.95 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.81 | 87.70 | 3.84 | 64.67 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 17.98 | 74.35 | 4.14 | 44.38 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 24.89 | 94.34 | 3.79 | 91.28 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 25.70 | 106.95 | 4.16 | 92.07 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.10 | 40.47 | 3.34 | 164.41 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.75 | 42.29 | 3.32 | 101.04 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.30 | 395.99 | 2.16 | 262.28 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.86 | 374.12 | 3.04 | 1918.03 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.72 | 1063.49 | 1.30 | 1321.46 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 230.38 | 751.65 | 3.26 | 2438.27 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.58 | 32.38 | 2.57 | 312.34 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.47 | 32.23 | 2.39 | 281.39 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.16 | 80.12 | 1.74 | 524.17 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.32 | 72.38 | 1.71 | 1276.12 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.77 | 200.28 | 1.41 | 742.67 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 60.59 | 136.73 | 2.26 | 1227.03 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.34 | 29.72 | 2.23 | 414.78 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.26 | 28.55 | 2.00 | 379.65 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.13 | 60.25 | 1.82 | 557.08 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.22 | 56.80 | 1.76 | 1001.08 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.71 | 119.11 | 1.48 | 687.07 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 41.74 | 97.56 | 2.34 | 973.23 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.38 | 103.92 | 2.94 | 454.20 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.48 | 58.63 | 2.73 | 365.16 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.30 | 138.33 | 2.99 | 565.49 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 33.01 | 94.30 | 2.86 | 526.67 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.78 | 142.44 | 2.98 | 587.04 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 37.12 | 112.10 | 3.02 | 538.67 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.45 | 27.96 | 2.68 | 267.01 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.05 | 20.25 | 2.24 | 233.91 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.30 | 52.09 | 2.34 | 390.22 |
| http/html-16kx64 | 1048576 | 6 | stdx | 19.00 | 42.86 | 2.26 | 547.18 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 34.96 | 72.54 | 2.08 | 462.71 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.80 | 69.05 | 2.78 | 550.72 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.77 | 23.03 | 2.63 | 224.05 |
| http/html-1m | 1048576 | 1 | stdx | 8.17 | 17.79 | 2.18 | 206.09 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.33 | 49.53 | 1.96 | 327.31 |
| http/html-1m | 1048576 | 6 | stdx | 21.27 | 40.70 | 1.91 | 628.00 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.21 | 109.24 | 1.53 | 432.49 |
| http/html-1m | 1048576 | 9 | stdx | 29.95 | 73.42 | 2.45 | 613.65 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.79 | 94.80 | 2.98 | 301.82 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.52 | 45.16 | 2.73 | 241.92 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.13 | 126.60 | 2.94 | 373.51 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.25 | 78.36 | 2.88 | 379.72 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.18 | 142.45 | 2.73 | 433.91 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.77 | 95.54 | 3.11 | 384.51 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.84 | 23.85 | 3.04 | 134.04 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.47 | 13.94 | 2.55 | 110.46 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.16 | 46.61 | 2.57 | 204.24 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.39 | 35.01 | 2.61 | 279.68 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.31 | 151.99 | 1.89 | 298.99 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.16 | 58.29 | 3.04 | 302.32 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.73 | 19.85 | 2.95 | 124.35 |
| http/json-1m | 1048576 | 1 | stdx | 5.08 | 12.51 | 2.46 | 103.26 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.32 | 45.30 | 2.23 | 175.42 |
| http/json-1m | 1048576 | 6 | stdx | 14.75 | 35.08 | 2.38 | 300.42 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.75 | 205.21 | 1.69 | 280.25 |
| http/json-1m | 1048576 | 9 | stdx | 27.36 | 69.14 | 2.53 | 336.47 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.01 | 107.80 | 2.91 | 516.50 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.77 | 65.40 | 2.75 | 411.33 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.44 | 144.85 | 2.93 | 679.17 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 36.58 | 104.11 | 2.85 | 620.58 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.80 | 150.13 | 2.90 | 717.84 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 41.30 | 125.11 | 3.03 | 625.97 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.72 | 30.90 | 2.64 | 308.06 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.84 | 24.80 | 2.29 | 273.31 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.87 | 59.43 | 2.30 | 470.19 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.83 | 50.04 | 2.19 | 684.40 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.86 | 83.31 | 2.04 | 564.06 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.57 | 81.30 | 2.75 | 663.76 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.64 | 25.19 | 2.61 | 246.75 |
| http/js-1m | 1048576 | 1 | stdx | 9.57 | 21.31 | 2.23 | 233.61 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.74 | 56.12 | 1.95 | 368.88 |
| http/js-1m | 1048576 | 6 | stdx | 25.04 | 46.64 | 1.86 | 751.56 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.42 | 120.65 | 1.58 | 499.88 |
| http/js-1m | 1048576 | 9 | stdx | 35.06 | 84.80 | 2.42 | 707.51 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.19 | 97.73 | 2.94 | 375.85 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.48 | 49.52 | 2.68 | 301.17 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.95 | 129.22 | 2.94 | 480.24 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.27 | 82.31 | 2.81 | 504.78 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.87 | 133.80 | 2.92 | 509.55 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.27 | 99.46 | 2.99 | 521.66 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.63 | 25.60 | 2.97 | 172.97 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.70 | 16.96 | 2.53 | 134.68 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.18 | 48.80 | 2.42 | 287.74 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.43 | 38.00 | 2.31 | 464.50 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.83 | 82.40 | 2.02 | 371.17 |
| http/css-16kx64 | 1048576 | 9 | stdx | 22.96 | 65.13 | 2.84 | 479.21 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.95 | 21.15 | 3.04 | 132.79 |
| http/css-1m | 1048576 | 1 | stdx | 5.79 | 14.91 | 2.58 | 107.85 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.78 | 44.50 | 2.14 | 226.37 |
| http/css-1m | 1048576 | 6 | stdx | 16.65 | 35.61 | 2.14 | 447.90 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.81 | 111.58 | 1.60 | 309.62 |
| http/css-1m | 1048576 | 9 | stdx | 28.18 | 72.54 | 2.57 | 473.19 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.24 | 48.89 | 1.94 | 929.16 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.17 | 49.19 | 2.71 | 323.39 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.67 | 86.45 | 2.07 | 1181.89 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.80 | 88.79 | 2.23 | 855.02 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.17 | 94.50 | 2.00 | 1345.48 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 53.60 | 133.83 | 2.50 | 1124.08 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.16 | 31.13 | 3.06 | 122.47 |
| silesia/dickens | 10192446 | 1 | stdx | 24.48 | 82.03 | 3.35 | 125.27 |
| silesia/dickens | 10192446 | 3 | libzstd | 26.75 | 35.01 | 1.31 | 172.43 |
| silesia/dickens | 10192446 | 3 | stdx | 38.47 | 78.22 | 2.03 | 182.72 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.08 | 22.57 | 3.19 | 72.16 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.75 | 54.73 | 3.08 | 173.08 |
| silesia/mozilla | 51220480 | 3 | libzstd | 18.83 | 28.71 | 1.52 | 102.73 |
| silesia/mozilla | 51220480 | 3 | stdx | 32.76 | 62.01 | 1.89 | 144.94 |
| silesia/mr | 9970564 | 1 | libzstd | 7.69 | 24.73 | 3.22 | 57.24 |
| silesia/mr | 9970564 | 1 | stdx | 19.97 | 66.82 | 3.35 | 113.66 |
| silesia/mr | 9970564 | 3 | libzstd | 22.00 | 32.97 | 1.50 | 87.04 |
| silesia/mr | 9970564 | 3 | stdx | 35.91 | 72.46 | 2.02 | 114.36 |
| silesia/nci | 33553445 | 1 | libzstd | 3.59 | 9.49 | 2.64 | 58.59 |
| silesia/nci | 33553445 | 1 | stdx | 7.80 | 25.69 | 3.29 | 59.05 |
| silesia/nci | 33553445 | 3 | libzstd | 5.85 | 10.11 | 1.73 | 57.13 |
| silesia/nci | 33553445 | 3 | stdx | 11.87 | 29.15 | 2.46 | 66.45 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.60 | 29.17 | 3.39 | 72.04 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.35 | 72.51 | 3.10 | 180.01 |
| silesia/ooffice | 6152192 | 3 | libzstd | 26.74 | 40.82 | 1.53 | 121.82 |
| silesia/ooffice | 6152192 | 3 | stdx | 45.04 | 82.20 | 1.83 | 184.86 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.14 | 22.22 | 3.11 | 67.09 |
| silesia/osdb | 10085684 | 1 | stdx | 16.55 | 50.52 | 3.05 | 120.33 |
| silesia/osdb | 10085684 | 3 | libzstd | 20.04 | 27.06 | 1.35 | 70.46 |
| silesia/osdb | 10085684 | 3 | stdx | 34.29 | 57.87 | 1.69 | 110.72 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.87 | 27.02 | 2.74 | 155.76 |
| silesia/reymont | 6627202 | 1 | stdx | 20.30 | 72.05 | 3.55 | 96.61 |
| silesia/reymont | 6627202 | 3 | libzstd | 19.79 | 27.53 | 1.39 | 127.66 |
| silesia/reymont | 6627202 | 3 | stdx | 29.50 | 62.18 | 2.11 | 147.89 |
| silesia/samba | 21606400 | 1 | libzstd | 6.03 | 16.80 | 2.79 | 88.07 |
| silesia/samba | 21606400 | 1 | stdx | 13.59 | 42.89 | 3.16 | 124.54 |
| silesia/samba | 21606400 | 3 | libzstd | 12.94 | 19.20 | 1.48 | 100.06 |
| silesia/samba | 21606400 | 3 | stdx | 21.67 | 44.75 | 2.07 | 133.12 |
| silesia/sao | 7251944 | 1 | libzstd | 9.05 | 33.64 | 3.72 | 43.59 |
| silesia/sao | 7251944 | 1 | stdx | 26.15 | 82.03 | 3.14 | 103.75 |
| silesia/sao | 7251944 | 3 | libzstd | 35.08 | 52.14 | 1.49 | 95.33 |
| silesia/sao | 7251944 | 3 | stdx | 55.35 | 95.22 | 1.72 | 142.45 |
| silesia/webster | 41458703 | 1 | libzstd | 8.75 | 24.86 | 2.84 | 135.59 |
| silesia/webster | 41458703 | 1 | stdx | 20.43 | 64.04 | 3.13 | 166.10 |
| silesia/webster | 41458703 | 3 | libzstd | 20.70 | 27.84 | 1.35 | 178.93 |
| silesia/webster | 41458703 | 3 | stdx | 32.67 | 64.55 | 1.98 | 195.14 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.76 | 14.89 | 3.13 | 17.06 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.93 | 76.64 | 3.20 | 92.21 |
| silesia/x-ray | 8474240 | 3 | libzstd | 36.13 | 54.96 | 1.52 | 86.39 |
| silesia/x-ray | 8474240 | 3 | stdx | 51.03 | 92.40 | 1.81 | 105.45 |
| silesia/xml | 5345280 | 1 | libzstd | 4.29 | 11.65 | 2.72 | 72.60 |
| silesia/xml | 5345280 | 1 | stdx | 10.45 | 34.21 | 3.27 | 94.37 |
| silesia/xml | 5345280 | 3 | libzstd | 7.24 | 12.84 | 1.77 | 79.41 |
| silesia/xml | 5345280 | 3 | stdx | 13.24 | 32.28 | 2.44 | 115.32 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.89 | 32.86 | 3.02 | 145.78 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.41 | 76.49 | 3.41 | 187.87 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.81 | 39.93 | 2.53 | 203.74 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.93 | 73.76 | 2.74 | 335.34 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.79 | 33.59 | 3.43 | 109.81 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.49 | 79.00 | 3.36 | 215.87 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.55 | 40.28 | 2.59 | 208.49 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.69 | 79.30 | 2.76 | 372.97 |
| canterbury/cp.html | 24603 | 1 | libzstd | 6.98 | 26.65 | 3.82 | 38.20 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.03 | 57.76 | 3.60 | 117.06 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.21 | 32.88 | 3.57 | 14.76 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.21 | 59.76 | 3.28 | 137.37 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.75 | 31.77 | 3.63 | 38.64 |
| canterbury/fields.c | 11150 | 1 | stdx | 16.98 | 65.73 | 3.87 | 85.80 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.03 | 34.41 | 3.81 | 10.20 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.61 | 64.68 | 3.67 | 90.25 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.49 | 37.98 | 4.00 | 7.18 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.21 | 77.57 | 3.84 | 49.85 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.61 | 43.28 | 4.08 | 1.86 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.39 | 79.60 | 3.72 | 67.36 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.02 | 23.37 | 3.88 | 14.64 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.81 | 56.75 | 3.83 | 84.02 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 9.10 | 24.26 | 2.67 | 27.40 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 21.38 | 56.61 | 2.65 | 108.44 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.90 | 28.42 | 2.87 | 160.53 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.52 | 72.02 | 3.35 | 160.38 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 17.65 | 32.77 | 1.86 | 202.35 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.99 | 67.10 | 2.49 | 297.24 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.36 | 32.28 | 3.12 | 130.29 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.30 | 84.16 | 3.33 | 158.51 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 21.64 | 39.60 | 1.83 | 225.40 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 32.45 | 80.77 | 2.49 | 341.74 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.18 | 8.48 | 2.66 | 68.01 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.57 | 23.15 | 3.06 | 104.63 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 5.30 | 11.28 | 2.13 | 59.86 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.80 | 24.08 | 2.46 | 132.52 |
| canterbury/sum | 38240 | 1 | libzstd | 6.50 | 25.37 | 3.90 | 30.56 |
| canterbury/sum | 38240 | 1 | stdx | 16.85 | 59.13 | 3.51 | 149.90 |
| canterbury/sum | 38240 | 3 | libzstd | 8.88 | 31.64 | 3.56 | 26.28 |
| canterbury/sum | 38240 | 3 | stdx | 19.81 | 61.82 | 3.12 | 181.00 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 10.02 | 39.84 | 3.98 | 10.74 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.91 | 80.38 | 3.84 | 59.06 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.08 | 48.45 | 4.01 | 2.60 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.78 | 83.98 | 3.69 | 74.83 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.50 | 33.29 | 3.17 | 75.68 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.86 | 95.62 | 4.37 | 7.31 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 16.35 | 31.71 | 1.94 | 35.93 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 24.59 | 70.38 | 2.86 | 38.48 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.82 | 27.35 | 2.78 | 154.35 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.50 | 71.86 | 3.51 | 107.87 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 19.44 | 28.64 | 1.47 | 133.70 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 29.36 | 63.36 | 2.16 | 155.48 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.22 | 22.62 | 2.75 | 139.65 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.75 | 55.86 | 2.98 | 192.95 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 16.67 | 24.36 | 1.46 | 175.71 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 26.45 | 51.26 | 1.94 | 237.93 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.10 | 52.52 | 3.07 | 168.16 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 36.06 | 100.54 | 2.79 | 637.83 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.20 | 59.34 | 3.09 | 205.31 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 38.30 | 104.00 | 2.72 | 632.02 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.86 | 22.47 | 2.86 | 128.02 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.19 | 46.84 | 3.30 | 181.91 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.93 | 24.79 | 2.77 | 146.44 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.56 | 47.61 | 3.06 | 190.96 |
| http/html-1m | 1048576 | 1 | libzstd | 6.34 | 16.66 | 2.63 | 117.57 |
| http/html-1m | 1048576 | 1 | stdx | 13.03 | 42.00 | 3.22 | 134.18 |
| http/html-1m | 1048576 | 3 | libzstd | 10.06 | 18.50 | 1.84 | 125.73 |
| http/html-1m | 1048576 | 3 | stdx | 16.45 | 39.37 | 2.39 | 177.89 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.35 | 42.58 | 2.97 | 119.84 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.71 | 83.13 | 2.80 | 525.66 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.89 | 44.69 | 3.00 | 134.12 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.98 | 84.87 | 2.74 | 531.69 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.84 | 15.00 | 3.10 | 59.34 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.71 | 33.78 | 3.48 | 116.47 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.44 | 16.31 | 3.00 | 73.55 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.74 | 34.58 | 3.22 | 122.39 |
| http/json-1m | 1048576 | 1 | libzstd | 4.07 | 12.47 | 3.07 | 53.36 |
| http/json-1m | 1048576 | 1 | stdx | 9.07 | 30.70 | 3.39 | 85.46 |
| http/json-1m | 1048576 | 3 | libzstd | 6.70 | 14.06 | 2.10 | 68.62 |
| http/json-1m | 1048576 | 3 | stdx | 11.79 | 30.64 | 2.60 | 119.75 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.62 | 57.29 | 3.08 | 196.27 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 40.08 | 113.49 | 2.83 | 692.64 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.55 | 65.62 | 3.05 | 269.28 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.48 | 116.54 | 2.74 | 683.93 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 9.01 | 26.53 | 2.94 | 133.65 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.67 | 55.71 | 3.34 | 200.40 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.23 | 28.96 | 2.83 | 157.90 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.79 | 55.35 | 3.11 | 209.22 |
| http/js-1m | 1048576 | 1 | libzstd | 6.64 | 17.80 | 2.68 | 116.28 |
| http/js-1m | 1048576 | 1 | stdx | 14.06 | 45.88 | 3.26 | 135.56 |
| http/js-1m | 1048576 | 3 | libzstd | 10.79 | 19.49 | 1.81 | 124.75 |
| http/js-1m | 1048576 | 3 | stdx | 17.67 | 41.25 | 2.33 | 186.40 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.62 | 46.97 | 3.01 | 142.47 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.55 | 91.65 | 2.82 | 580.27 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.75 | 50.68 | 3.03 | 165.49 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.96 | 93.63 | 2.76 | 583.92 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.25 | 18.99 | 3.04 | 80.53 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.50 | 43.79 | 3.50 | 138.07 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.63 | 19.53 | 2.95 | 94.36 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.99 | 42.34 | 3.26 | 152.12 |
| http/css-1m | 1048576 | 1 | libzstd | 1.52 | 4.57 | 3.01 | 22.10 |
| http/css-1m | 1048576 | 1 | stdx | 4.02 | 14.85 | 3.70 | 30.62 |
| http/css-1m | 1048576 | 3 | libzstd | 2.07 | 5.34 | 2.58 | 19.63 |
| http/css-1m | 1048576 | 3 | stdx | 4.05 | 13.33 | 3.29 | 31.56 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.56 | 12.79 | 3.59 | 6.49 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.13 | 30.66 | 3.36 | 61.50 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 32.43 | 53.05 | 1.64 | 48.71 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 21.86 | 47.43 | 2.17 | 206.51 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.3 | 74.2 | 0.119 | 2.99 | 2.93 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 75.4 | 239.0 | 0.091 | 8.91 | 3.17 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 44.1 | 194.4 | 0.074 | 5.21 | 4.41 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 283.7 | 1193.5 | 0.823 | 33.51 | 4.21 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.5 | 107.5 | 0.141 | 3.60 | 3.53 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.0 | 106.0 | 0.295 | 3.31 | 3.79 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.4 | 378.2 | 0.379 | 11.26 | 3.97 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.2 | 161.9 | 0.446 | 4.99 | 3.83 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 91.2 | 451.6 | 0.309 | 10.77 | 4.95 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.3 | 89.5 | 0.004 | 4.02 | 3.28 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 74.9 | 250.2 | 0.041 | 11.02 | 3.34 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 47.8 | 205.1 | 0.048 | 7.04 | 4.29 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 242.2 | 927.9 | 0.969 | 35.65 | 3.83 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.0 | 107.7 | 0.040 | 4.12 | 3.85 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 30.3 | 105.7 | 0.047 | 4.45 | 3.49 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 94.8 | 346.2 | 0.360 | 13.96 | 3.65 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 32.6 | 144.5 | 0.053 | 4.80 | 4.43 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 91.9 | 406.5 | 0.102 | 13.53 | 4.42 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114335.4 | 403845.2 | 490.608 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 645333.1 | 2749355.2 | 1405.361 | 3.74 | 4.26 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 646714.9 | 2749752.2 | 1404.268 | 3.75 | 4.25 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 4486921.2 | 22490188.2 | 2975.969 | 26.01 | 5.01 |
| string: silesia/dickens | 1 | 172528 | simdjson | 319558.8 | 621743.2 | 1040.433 | 1.85 | 1.95 |
| string: silesia/dickens | 1 | 172528 | yyjson | 222633.6 | 826618.2 | 2152.670 | 1.29 | 3.71 |
| string: silesia/dickens | 1 | 172528 | std.json | 1596772.3 | 4578768.2 | 43459.649 | 9.26 | 2.87 |
| string: silesia/dickens | 1 | 172528 | serde_json | 201625.0 | 802391.2 | 1001.443 | 1.17 | 3.98 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1049606.0 | 5284810.0 | 4917.052 | 6.08 | 5.04 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1568721.1 | 4799762.6 | 1251.857 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 15247217.3 | 62777133.6 | 38853.429 | 12.81 | 4.12 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 15294652.4 | 62777455.6 | 38840.429 | 12.85 | 4.10 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 35383758.6 | 160729111.6 | 159175.929 | 29.73 | 4.54 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4562501.4 | 7053838.6 | 597.000 | 3.83 | 1.55 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1808840.2 | 7322017.6 | 14439.786 | 1.52 | 4.05 |
| string: http/json-1m | 1 | 1190272 | std.json | 10302079.0 | 47381213.6 | 30869.071 | 8.66 | 4.60 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3791282.4 | 15226459.6 | 6045.714 | 3.19 | 4.02 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9016008.4 | 48003897.0 | 27701.214 | 7.57 | 5.32 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2071202.0 | 5765412.8 | 4322.875 | 1.10 | 2.78 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6545064.9 | 24513270.8 | 6931.000 | 3.48 | 3.75 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 6560640.5 | 24513592.8 | 6925.625 | 3.48 | 3.74 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 59106117.6 | 273034491.8 | 265474.625 | 31.39 | 4.62 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3701440.0 | 7945848.8 | 2700.250 | 1.97 | 2.15 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7262453.8 | 12276727.8 | 275834.875 | 3.86 | 1.69 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 18176928.3 | 63617055.8 | 217817.000 | 9.65 | 3.50 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9579681.4 | 24440755.8 | 298370.375 | 5.09 | 2.55 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39328267.5 | 160321259.5 | 791194.875 | 20.89 | 4.08 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12915188.0 | 42561068.3 | 243461.000 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 189745149.0 | 782100838.3 | 389914.333 | 37.38 | 4.12 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 181660499.0 | 782101160.3 | 393380.667 | 35.79 | 4.31 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 185188878.7 | 760206171.3 | 424173.667 | 36.49 | 4.11 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17625432.0 | 49745819.3 | 215403.333 | 3.47 | 2.82 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14284288.0 | 44816977.3 | 454634.000 | 2.81 | 3.14 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79804520.3 | 314900845.3 | 484902.667 | 15.72 | 3.95 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36140908.0 | 131556135.3 | 575103.000 | 7.12 | 3.64 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66963755.0 | 273942406.7 | 841211.667 | 13.19 | 4.09 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 94791.6 | 303836.7 | 6.742 | 0.18 | 3.21 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 184756.8 | 623498.7 | 10.710 | 0.35 | 3.37 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 183755.7 | 623231.7 | 6.548 | 0.35 | 3.39 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 13199736.0 | 66585428.7 | 8.548 | 25.18 | 5.04 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 491433.2 | 1376732.7 | 8.387 | 0.94 | 2.80 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 538294.6 | 2195905.7 | 6.806 | 1.03 | 4.08 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3520936.1 | 12808414.7 | 61797.258 | 6.72 | 3.64 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 283146.0 | 1179969.7 | 7.065 | 0.54 | 4.17 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2264431.2 | 12789862.1 | 259.226 | 4.32 | 5.65 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.8 | 81.5 | 0.114 | 2.34 | 4.11 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.3 | 153.6 | 0.125 | 4.17 | 4.35 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 23.4 | 103.2 | 0.094 | 2.76 | 4.41 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 258.4 | 1182.8 | 0.912 | 30.53 | 4.58 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 19.2 | 79.5 | 0.105 | 2.27 | 4.13 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.1 | 94.1 | 0.135 | 2.72 | 4.08 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.9 | 105.4 | 0.252 | 3.29 | 3.78 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.6 | 310.8 | 0.366 | 8.23 | 4.46 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.5 | 255.3 | 0.485 | 7.50 | 4.02 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.6 | 315.1 | 0.236 | 8.10 | 4.59 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.7 | 82.5 | 0.024 | 2.75 | 4.41 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.3 | 153.9 | 0.025 | 5.34 | 4.24 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 22.9 | 101.7 | 0.024 | 3.37 | 4.45 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 196.4 | 848.0 | 1.242 | 28.90 | 4.32 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.6 | 81.5 | 0.025 | 2.74 | 4.38 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.5 | 96.6 | 0.032 | 3.17 | 4.49 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.4 | 117.7 | 0.033 | 4.33 | 4.00 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 60.6 | 271.2 | 0.268 | 8.92 | 4.48 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 49.3 | 211.7 | 0.042 | 7.25 | 4.30 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 82.6 | 331.7 | 0.085 | 12.15 | 4.02 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 84995.5 | 280780.2 | 716.680 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 85034.7 | 280730.2 | 717.928 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84841.1 | 280724.2 | 716.351 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 4103031.7 | 20167466.2 | 2952.196 | 23.78 | 4.92 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 83664.9 | 274401.2 | 684.907 | 0.48 | 3.28 |
| string: silesia/dickens | 1 | 172528 | simdjson | 211094.4 | 674008.2 | 2156.629 | 1.22 | 3.19 |
| string: silesia/dickens | 1 | 172528 | yyjson | 209847.7 | 848559.2 | 1313.258 | 1.22 | 4.04 |
| string: silesia/dickens | 1 | 172528 | std.json | 1350548.9 | 2890892.2 | 51017.175 | 7.83 | 2.14 |
| string: silesia/dickens | 1 | 172528 | serde_json | 366692.5 | 1586249.2 | 2300.237 | 2.13 | 4.33 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 577888.0 | 2970254.6 | 2323.103 | 3.35 | 5.14 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1272733.0 | 3582346.6 | 11526.786 | 1.07 | 2.81 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1257544.3 | 3582290.6 | 10981.214 | 1.06 | 2.85 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1255844.4 | 3582278.6 | 10906.000 | 1.06 | 2.85 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 30095733.9 | 134936069.6 | 138730.500 | 25.28 | 4.48 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1224139.7 | 3370022.6 | 11045.500 | 1.03 | 2.75 |
| string: http/json-1m | 1 | 1190272 | simdjson | 3016709.1 | 10460754.6 | 30664.786 | 2.53 | 3.47 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2420499.8 | 11226214.6 | 9642.357 | 2.03 | 4.64 |
| string: http/json-1m | 1 | 1190272 | std.json | 9051010.1 | 43287986.6 | 17352.571 | 7.60 | 4.78 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4214102.0 | 17941088.6 | 11853.214 | 3.54 | 4.26 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5244517.6 | 26999452.4 | 11153.357 | 4.41 | 5.15 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2076407.3 | 6088095.8 | 4670.625 | 1.10 | 2.93 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2062543.0 | 6088039.8 | 4144.000 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2062564.0 | 6088027.8 | 4112.750 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 52542237.4 | 238556376.8 | 258453.250 | 27.90 | 4.54 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2071993.6 | 5875346.8 | 4846.250 | 1.10 | 2.84 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2717665.9 | 7144135.8 | 20790.000 | 1.44 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 11885991.9 | 26334410.8 | 430567.000 | 6.31 | 2.22 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20393327.0 | 56837736.8 | 524907.000 | 10.83 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11433165.3 | 33662338.8 | 306834.125 | 6.07 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18859086.1 | 76318998.5 | 253194.000 | 10.02 | 4.05 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113443.1 | 426373.7 | 3.032 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113123.1 | 426318.7 | 3.258 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113155.4 | 426299.7 | 1.613 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 636022.7 | 3146562.7 | 5.194 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113159.5 | 426343.7 | 2.419 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1241915.3 | 3866907.7 | 5.484 | 2.37 | 3.11 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1664318.8 | 5833344.7 | 7.355 | 3.17 | 3.50 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3635931.3 | 13108830.7 | 72561.097 | 6.93 | 3.61 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1821024.4 | 7405810.7 | 3.548 | 3.47 | 4.07 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2398886.0 | 12748191.5 | 17.774 | 4.58 | 5.31 |
