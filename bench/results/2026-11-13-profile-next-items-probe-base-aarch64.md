# bench-profile

| Field | Value |
|---|---|
| Commit | 39b6cf9 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43348526005 |
| Date | 2026-11-13 |

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
| silesia/dickens | 10192446 | zlib | 8.85 | 19.08 | 2.16 | 312.97 |
| silesia/dickens | 10192446 | zlib-ng | 4.88 | 10.50 | 2.15 | 67.57 |
| silesia/dickens | 10192446 | libdeflate | 3.46 | 9.56 | 2.77 | 66.22 |
| silesia/dickens | 10192446 | Wuffs | 5.53 | 13.90 | 2.51 | 96.99 |
| silesia/dickens | 10192446 | stdx | 2.93 | 7.15 | 2.44 | 76.21 |
| silesia/mozilla | 51220480 | zlib | 8.50 | 17.23 | 2.03 | 252.86 |
| silesia/mozilla | 51220480 | zlib-ng | 4.95 | 8.95 | 1.81 | 85.40 |
| silesia/mozilla | 51220480 | libdeflate | 3.49 | 7.63 | 2.18 | 71.12 |
| silesia/mozilla | 51220480 | Wuffs | 6.40 | 13.89 | 2.17 | 132.23 |
| silesia/mozilla | 51220480 | stdx | 3.66 | 6.29 | 1.72 | 89.56 |
| silesia/mr | 9970564 | zlib | 8.44 | 18.46 | 2.19 | 201.95 |
| silesia/mr | 9970564 | zlib-ng | 4.82 | 9.98 | 2.07 | 67.99 |
| silesia/mr | 9970564 | libdeflate | 3.38 | 8.58 | 2.54 | 61.09 |
| silesia/mr | 9970564 | Wuffs | 6.03 | 14.04 | 2.33 | 99.33 |
| silesia/mr | 9970564 | stdx | 3.18 | 6.70 | 2.11 | 70.05 |
| silesia/nci | 33553445 | zlib | 3.59 | 10.18 | 2.84 | 81.25 |
| silesia/nci | 33553445 | zlib-ng | 1.61 | 3.13 | 1.95 | 33.65 |
| silesia/nci | 33553445 | libdeflate | 1.13 | 2.66 | 2.35 | 27.57 |
| silesia/nci | 33553445 | Wuffs | 2.46 | 6.47 | 2.63 | 41.20 |
| silesia/nci | 33553445 | stdx | 1.26 | 2.20 | 1.75 | 37.39 |
| silesia/ooffice | 6152192 | zlib | 11.82 | 21.06 | 1.78 | 419.54 |
| silesia/ooffice | 6152192 | zlib-ng | 6.91 | 12.04 | 1.74 | 139.82 |
| silesia/ooffice | 6152192 | libdeflate | 4.90 | 10.45 | 2.13 | 125.53 |
| silesia/ooffice | 6152192 | Wuffs | 8.80 | 17.54 | 1.99 | 219.72 |
| silesia/ooffice | 6152192 | stdx | 5.08 | 8.55 | 1.68 | 151.30 |
| silesia/osdb | 10085684 | zlib | 7.43 | 16.59 | 2.23 | 180.62 |
| silesia/osdb | 10085684 | zlib-ng | 4.31 | 8.38 | 1.95 | 53.21 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.91 | 2.43 | 29.72 |
| silesia/osdb | 10085684 | Wuffs | 5.76 | 13.61 | 2.36 | 75.19 |
| silesia/osdb | 10085684 | stdx | 2.79 | 5.65 | 2.03 | 41.38 |
| silesia/reymont | 6627202 | zlib | 7.39 | 15.89 | 2.15 | 260.03 |
| silesia/reymont | 6627202 | zlib-ng | 3.72 | 7.72 | 2.07 | 60.81 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.21 |
| silesia/reymont | 6627202 | Wuffs | 4.88 | 11.40 | 2.33 | 112.70 |
| silesia/reymont | 6627202 | stdx | 2.29 | 5.11 | 2.23 | 64.73 |
| silesia/samba | 21606400 | zlib | 6.14 | 14.13 | 2.30 | 175.12 |
| silesia/samba | 21606400 | zlib-ng | 3.35 | 6.47 | 1.93 | 55.98 |
| silesia/samba | 21606400 | libdeflate | 2.31 | 5.58 | 2.41 | 42.91 |
| silesia/samba | 21606400 | Wuffs | 4.32 | 10.39 | 2.40 | 79.59 |
| silesia/samba | 21606400 | stdx | 2.27 | 4.46 | 1.96 | 56.54 |
| silesia/sao | 7251944 | zlib | 10.51 | 23.54 | 2.24 | 203.42 |
| silesia/sao | 7251944 | zlib-ng | 7.88 | 14.83 | 1.88 | 79.35 |
| silesia/sao | 7251944 | libdeflate | 5.76 | 12.73 | 2.21 | 78.86 |
| silesia/sao | 7251944 | Wuffs | 8.87 | 21.26 | 2.40 | 84.05 |
| silesia/sao | 7251944 | stdx | 5.68 | 10.32 | 1.82 | 89.27 |
| silesia/webster | 41458703 | zlib | 7.83 | 16.16 | 2.06 | 282.06 |
| silesia/webster | 41458703 | zlib-ng | 4.24 | 8.04 | 1.90 | 84.97 |
| silesia/webster | 41458703 | libdeflate | 2.95 | 7.17 | 2.43 | 68.45 |
| silesia/webster | 41458703 | Wuffs | 5.15 | 11.67 | 2.26 | 122.57 |
| silesia/webster | 41458703 | stdx | 2.85 | 5.56 | 1.95 | 87.02 |
| silesia/x-ray | 8474240 | zlib | 12.91 | 27.21 | 2.11 | 327.67 |
| silesia/x-ray | 8474240 | zlib-ng | 9.07 | 17.39 | 1.92 | 124.26 |
| silesia/x-ray | 8474240 | libdeflate | 6.55 | 15.26 | 2.33 | 124.35 |
| silesia/x-ray | 8474240 | Wuffs | 10.81 | 23.52 | 2.18 | 189.26 |
| silesia/x-ray | 8474240 | stdx | 6.20 | 11.49 | 1.85 | 139.61 |
| silesia/xml | 5345280 | zlib | 4.23 | 11.16 | 2.64 | 118.30 |
| silesia/xml | 5345280 | zlib-ng | 1.99 | 3.88 | 1.95 | 42.62 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 31.52 |
| silesia/xml | 5345280 | Wuffs | 2.84 | 7.22 | 2.54 | 59.02 |
| silesia/xml | 5345280 | stdx | 1.33 | 2.65 | 1.99 | 41.99 |
| canterbury/alice29.txt | 152089 | zlib | 8.46 | 18.35 | 2.17 | 296.14 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.51 | 9.91 | 2.20 | 60.10 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.18 | 8.96 | 2.81 | 54.37 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.39 | 13.40 | 2.49 | 98.43 |
| canterbury/alice29.txt | 152089 | stdx | 2.73 | 6.99 | 2.56 | 63.85 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.04 | 19.42 | 2.15 | 314.50 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 72.85 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.60 | 9.82 | 2.73 | 67.84 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.77 | 14.40 | 2.50 | 100.68 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.04 | 7.52 | 2.47 | 75.59 |
| canterbury/cp.html | 24603 | zlib | 7.11 | 17.33 | 2.44 | 173.93 |
| canterbury/cp.html | 24603 | zlib-ng | 4.16 | 9.50 | 2.28 | 35.30 |
| canterbury/cp.html | 24603 | libdeflate | 2.80 | 7.95 | 2.84 | 11.47 |
| canterbury/cp.html | 24603 | Wuffs | 5.10 | 13.91 | 2.73 | 51.60 |
| canterbury/cp.html | 24603 | stdx | 2.63 | 7.19 | 2.73 | 11.08 |
| canterbury/fields.c | 11150 | zlib | 5.24 | 17.73 | 3.39 | 34.96 |
| canterbury/fields.c | 11150 | zlib-ng | 3.87 | 10.20 | 2.64 | 13.61 |
| canterbury/fields.c | 11150 | libdeflate | 2.79 | 8.32 | 2.98 | 1.49 |
| canterbury/fields.c | 11150 | Wuffs | 4.50 | 14.54 | 3.23 | 9.14 |
| canterbury/fields.c | 11150 | stdx | 2.53 | 7.64 | 3.03 | 4.53 |
| canterbury/grammar.lsp | 3721 | zlib | 6.90 | 24.26 | 3.51 | 6.73 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.86 | 17.48 | 2.98 | 6.54 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.41 | 12.05 | 2.73 | 1.19 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.69 | 21.86 | 3.27 | 4.68 |
| canterbury/grammar.lsp | 3721 | stdx | 3.86 | 12.18 | 3.16 | 1.87 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.58 | 15.27 | 3.33 | 48.28 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.53 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.34 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.86 | 11.59 | 3.00 | 14.80 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.74 | 4.66 | 2.67 | 16.88 |
| canterbury/lcet10.txt | 426754 | zlib | 8.23 | 17.78 | 2.16 | 291.57 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 60.34 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 54.97 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.23 | 12.88 | 2.46 | 101.42 |
| canterbury/lcet10.txt | 426754 | stdx | 2.59 | 6.42 | 2.48 | 66.93 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.20 | 19.86 | 2.16 | 321.15 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.29 | 11.19 | 2.11 | 79.42 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.70 | 77.56 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.81 | 14.61 | 2.52 | 99.09 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.14 | 7.63 | 2.43 | 84.74 |
| canterbury/ptt5 | 513216 | zlib | 5.04 | 10.71 | 2.12 | 103.21 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.83 |
| canterbury/ptt5 | 513216 | libdeflate | 1.44 | 3.02 | 2.10 | 37.58 |
| canterbury/ptt5 | 513216 | Wuffs | 3.00 | 7.13 | 2.38 | 57.78 |
| canterbury/ptt5 | 513216 | stdx | 1.44 | 2.55 | 1.77 | 49.08 |
| canterbury/sum | 38240 | zlib | 8.02 | 18.12 | 2.26 | 226.35 |
| canterbury/sum | 38240 | zlib-ng | 4.63 | 10.02 | 2.16 | 56.20 |
| canterbury/sum | 38240 | libdeflate | 3.38 | 8.34 | 2.47 | 42.13 |
| canterbury/sum | 38240 | Wuffs | 5.76 | 14.47 | 2.51 | 79.31 |
| canterbury/sum | 38240 | stdx | 3.03 | 7.73 | 2.55 | 27.77 |
| canterbury/xargs.1 | 4227 | zlib | 7.42 | 25.22 | 3.40 | 12.88 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.38 | 17.97 | 2.82 | 10.33 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.78 | 13.27 | 2.78 | 1.12 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.17 | 22.63 | 3.16 | 7.82 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 12.86 | 3.04 | 1.48 |
| canterbury-large/E.coli | 4638690 | zlib | 6.77 | 17.84 | 2.64 | 177.44 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.24 | 9.68 | 2.28 | 47.38 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.92 | 48.43 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.67 | 12.73 | 2.73 | 62.02 |
| canterbury-large/E.coli | 4638690 | stdx | 2.49 | 6.72 | 2.70 | 53.68 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.61 | 16.46 | 2.16 | 273.90 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.79 | 8.26 | 2.18 | 53.97 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.84 | 45.57 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.81 | 11.73 | 2.44 | 100.48 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.25 | 5.57 | 2.48 | 55.79 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.74 | 15.84 | 2.05 | 282.60 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.75 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.01 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.19 | 11.48 | 2.21 | 128.50 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.73 | 5.40 | 1.98 | 90.69 |
| http/html-1kx1024 | 1048576 | zlib | 16.73 | 35.58 | 2.13 | 353.21 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.68 | 28.43 | 2.24 | 217.45 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.62 | 20.05 | 1.89 | 157.15 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.31 | 38.07 | 2.49 | 263.00 |
| http/html-1kx1024 | 1048576 | stdx | 8.38 | 20.88 | 2.49 | 137.21 |
| http/html-16kx64 | 1048576 | zlib | 6.72 | 14.77 | 2.20 | 221.15 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.22 |
| http/html-16kx64 | 1048576 | libdeflate | 2.63 | 6.04 | 2.29 | 60.62 |
| http/html-16kx64 | 1048576 | Wuffs | 4.92 | 11.56 | 2.35 | 114.61 |
| http/html-16kx64 | 1048576 | stdx | 2.52 | 5.56 | 2.21 | 59.34 |
| http/html-1m | 1048576 | zlib | 5.33 | 12.53 | 2.35 | 176.06 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 60.03 |
| http/html-1m | 1048576 | libdeflate | 1.69 | 4.39 | 2.59 | 37.23 |
| http/html-1m | 1048576 | Wuffs | 3.60 | 8.48 | 2.35 | 87.78 |
| http/html-1m | 1048576 | stdx | 1.65 | 3.46 | 2.10 | 52.64 |
| http/json-1kx1024 | 1048576 | zlib | 10.61 | 23.92 | 2.25 | 192.89 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.25 | 130.83 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.87 | 16.72 | 1.89 | 92.77 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.10 | 34.78 | 2.87 | 145.16 |
| http/json-1kx1024 | 1048576 | stdx | 5.02 | 13.12 | 2.61 | 80.34 |
| http/json-16kx64 | 1048576 | zlib | 4.57 | 12.51 | 2.74 | 103.11 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.62 | 5.50 | 2.10 | 51.00 |
| http/json-16kx64 | 1048576 | libdeflate | 1.91 | 4.24 | 2.22 | 39.88 |
| http/json-16kx64 | 1048576 | Wuffs | 3.49 | 9.43 | 2.70 | 57.54 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.25 | 39.23 |
| http/json-1m | 1048576 | zlib | 3.85 | 11.20 | 2.91 | 83.50 |
| http/json-1m | 1048576 | zlib-ng | 1.94 | 3.91 | 2.02 | 37.45 |
| http/json-1m | 1048576 | libdeflate | 1.37 | 3.33 | 2.42 | 31.93 |
| http/json-1m | 1048576 | Wuffs | 2.72 | 7.37 | 2.71 | 43.09 |
| http/json-1m | 1048576 | stdx | 1.33 | 2.67 | 2.01 | 39.91 |
| http/js-1kx1024 | 1048576 | zlib | 18.30 | 38.46 | 2.10 | 412.99 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.79 | 31.25 | 2.27 | 239.91 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.30 | 21.58 | 1.91 | 179.89 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.45 | 40.70 | 2.47 | 293.34 |
| http/js-1kx1024 | 1048576 | stdx | 9.27 | 22.85 | 2.46 | 158.96 |
| http/js-16kx64 | 1048576 | zlib | 7.66 | 16.08 | 2.10 | 262.64 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.37 | 8.65 | 1.98 | 91.58 |
| http/js-16kx64 | 1048576 | libdeflate | 3.06 | 7.01 | 2.29 | 72.30 |
| http/js-16kx64 | 1048576 | Wuffs | 5.50 | 12.75 | 2.32 | 128.45 |
| http/js-16kx64 | 1048576 | stdx | 3.00 | 6.54 | 2.18 | 71.88 |
| http/js-1m | 1048576 | zlib | 5.86 | 13.31 | 2.27 | 200.66 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.96 | 60.26 |
| http/js-1m | 1048576 | libdeflate | 1.93 | 4.98 | 2.58 | 42.13 |
| http/js-1m | 1048576 | Wuffs | 3.91 | 9.14 | 2.34 | 93.67 |
| http/js-1m | 1048576 | stdx | 1.80 | 3.89 | 2.16 | 55.34 |
| http/css-1kx1024 | 1048576 | zlib | 14.05 | 30.36 | 2.16 | 281.27 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.27 | 23.04 | 2.24 | 171.78 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.21 | 17.37 | 1.89 | 123.34 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.73 | 32.49 | 2.55 | 207.79 |
| http/css-1kx1024 | 1048576 | stdx | 6.67 | 17.64 | 2.64 | 100.28 |
| http/css-16kx64 | 1048576 | zlib | 5.31 | 13.04 | 2.46 | 153.60 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.79 | 6.07 | 2.18 | 50.08 |
| http/css-16kx64 | 1048576 | libdeflate | 1.87 | 4.69 | 2.50 | 28.50 |
| http/css-16kx64 | 1048576 | Wuffs | 3.78 | 10.01 | 2.65 | 68.73 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.54 | 28.05 |
| http/css-1m | 1048576 | zlib | 3.97 | 10.97 | 2.76 | 107.13 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.22 | 28.93 |
| http/css-1m | 1048576 | libdeflate | 1.04 | 3.18 | 3.05 | 10.30 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.78 | 43.31 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.52 | 21.52 |
| shuffled/dickens-1m | 1048576 | zlib | 13.29 | 25.88 | 1.95 | 371.76 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.72 | 16.72 | 1.72 | 197.44 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.02 | 14.95 | 2.13 | 193.23 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.34 | 22.08 | 2.14 | 199.96 |
| shuffled/dickens-1m | 1048576 | stdx | 7.05 | 11.89 | 1.69 | 207.05 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.53 | 14.05 | 3.98 | 3.44 |
| silesia/dickens | 10192446 | stdx | 3.69 | 12.47 | 3.38 | 3.70 |
| silesia/mozilla | 51220480 | libzstd | 2.84 | 9.68 | 3.41 | 30.08 |
| silesia/mozilla | 51220480 | stdx | 2.88 | 9.68 | 3.36 | 15.72 |
| silesia/mr | 9970564 | libzstd | 2.98 | 11.99 | 4.03 | 6.15 |
| silesia/mr | 9970564 | stdx | 3.08 | 10.83 | 3.51 | 5.42 |
| silesia/nci | 33553445 | libzstd | 1.70 | 4.88 | 2.86 | 24.93 |
| silesia/nci | 33553445 | stdx | 1.83 | 4.63 | 2.54 | 13.84 |
| silesia/ooffice | 6152192 | libzstd | 3.38 | 12.19 | 3.61 | 30.95 |
| silesia/ooffice | 6152192 | stdx | 3.36 | 12.40 | 3.69 | 12.32 |
| silesia/osdb | 10085684 | libzstd | 2.35 | 8.45 | 3.60 | 14.95 |
| silesia/osdb | 10085684 | stdx | 2.41 | 8.11 | 3.37 | 15.43 |
| silesia/reymont | 6627202 | libzstd | 3.16 | 11.62 | 3.67 | 11.53 |
| silesia/reymont | 6627202 | stdx | 3.30 | 10.36 | 3.13 | 13.25 |
| silesia/samba | 21606400 | libzstd | 2.06 | 7.41 | 3.60 | 18.64 |
| silesia/samba | 21606400 | stdx | 2.11 | 6.83 | 3.23 | 17.75 |
| silesia/sao | 7251944 | libzstd | 3.79 | 12.72 | 3.36 | 26.85 |
| silesia/sao | 7251944 | stdx | 3.49 | 12.58 | 3.60 | 6.23 |
| silesia/webster | 41458703 | libzstd | 3.25 | 11.24 | 3.45 | 16.14 |
| silesia/webster | 41458703 | stdx | 3.43 | 10.05 | 2.93 | 17.72 |
| silesia/x-ray | 8474240 | libzstd | 3.93 | 14.94 | 3.81 | 18.92 |
| silesia/x-ray | 8474240 | stdx | 3.58 | 13.23 | 3.69 | 8.45 |
| silesia/xml | 5345280 | libzstd | 1.55 | 5.57 | 3.59 | 23.21 |
| silesia/xml | 5345280 | stdx | 1.55 | 5.16 | 3.33 | 17.26 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.89 | 4.08 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.36 | 0.59 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.95 | 14.26 | 4.83 | 3.29 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.30 | 0.26 |
| canterbury/cp.html | 24603 | libzstd | 2.63 | 10.74 | 4.08 | 7.86 |
| canterbury/cp.html | 24603 | stdx | 2.55 | 10.42 | 4.09 | 0.28 |
| canterbury/fields.c | 11150 | libzstd | 3.11 | 13.62 | 4.37 | 8.91 |
| canterbury/fields.c | 11150 | stdx | 3.00 | 12.72 | 4.23 | 0.06 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.18 | 16.94 | 4.05 | 4.93 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.54 | 4.01 | 0.14 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.53 | 11.40 | 4.51 | 7.73 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.69 | 11.32 | 4.21 | 0.97 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.69 | 12.89 | 4.78 | 5.14 |
| canterbury/lcet10.txt | 426754 | stdx | 2.76 | 11.52 | 4.18 | 4.94 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.10 | 15.16 | 4.90 | 1.55 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.26 | 1.03 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.52 | 3.12 | 24.84 |
| canterbury/ptt5 | 513216 | stdx | 1.34 | 4.46 | 3.32 | 13.22 |
| canterbury/sum | 38240 | libzstd | 2.61 | 10.58 | 4.05 | 9.33 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.37 |
| canterbury/xargs.1 | 4227 | libzstd | 4.26 | 17.41 | 4.09 | 9.76 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 17.17 | 4.06 | 0.18 |
| canterbury-large/E.coli | 4638690 | libzstd | 2.98 | 13.64 | 4.58 | 2.09 |
| canterbury-large/E.coli | 4638690 | stdx | 3.09 | 12.04 | 3.90 | 2.94 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.96 | 12.00 | 4.05 | 8.44 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.07 | 10.64 | 3.46 | 9.58 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.54 | 9.60 | 3.78 | 19.74 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.63 | 8.64 | 3.29 | 21.04 |
| http/html-1kx1024 | 1048576 | libzstd | 7.25 | 21.63 | 2.98 | 63.15 |
| http/html-1kx1024 | 1048576 | stdx | 7.45 | 22.46 | 3.01 | 76.74 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.55 |
| http/html-16kx64 | 1048576 | stdx | 2.68 | 9.61 | 3.59 | 30.93 |
| http/html-1m | 1048576 | libzstd | 2.01 | 7.88 | 3.92 | 24.08 |
| http/html-1m | 1048576 | stdx | 2.00 | 7.12 | 3.56 | 24.51 |
| http/json-1kx1024 | 1048576 | libzstd | 6.27 | 17.39 | 2.77 | 49.82 |
| http/json-1kx1024 | 1048576 | stdx | 6.20 | 17.86 | 2.88 | 53.56 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.26 | 3.54 | 28.20 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.57 | 20.05 |
| http/json-1m | 1048576 | libzstd | 1.72 | 6.08 | 3.52 | 27.97 |
| http/json-1m | 1048576 | stdx | 1.64 | 5.91 | 3.61 | 14.60 |
| http/js-1kx1024 | 1048576 | libzstd | 8.32 | 26.35 | 3.17 | 73.17 |
| http/js-1kx1024 | 1048576 | stdx | 9.01 | 27.60 | 3.06 | 112.93 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.72 | 4.00 | 24.30 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.74 | 26.45 |
| http/js-1m | 1048576 | libzstd | 2.03 | 8.19 | 4.04 | 20.17 |
| http/js-1m | 1048576 | stdx | 2.08 | 7.48 | 3.59 | 21.60 |
| http/css-1kx1024 | 1048576 | libzstd | 6.88 | 19.69 | 2.86 | 53.60 |
| http/css-1kx1024 | 1048576 | stdx | 6.85 | 19.96 | 2.91 | 64.01 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.70 | 3.89 | 22.54 |
| http/css-16kx64 | 1048576 | stdx | 2.28 | 8.43 | 3.70 | 22.47 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.58 | 3.86 | 5.40 |
| http/css-1m | 1048576 | stdx | 0.72 | 2.49 | 3.45 | 4.43 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.77 | 9.40 | 3.39 | 28.33 |
| shuffled/dickens-1m | 1048576 | stdx | 2.74 | 9.19 | 3.35 | 12.49 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.51 | 16.93 | 2.25 | 99.19 |
| silesia/dickens | 1048576 | stdx | 5.10 | 12.38 | 2.43 | 55.11 |
| silesia/mozilla | 1048576 | Google | 13.46 | 28.31 | 2.10 | 46.86 |
| silesia/mozilla | 1048576 | stdx | 8.33 | 15.02 | 1.80 | 47.34 |
| silesia/mr | 1048576 | Google | 8.90 | 20.21 | 2.27 | 102.67 |
| silesia/mr | 1048576 | stdx | 5.77 | 13.25 | 2.30 | 88.55 |
| silesia/nci | 1048576 | Google | 2.55 | 5.70 | 2.24 | 51.55 |
| silesia/nci | 1048576 | stdx | 1.94 | 3.95 | 2.04 | 54.87 |
| silesia/ooffice | 1048576 | Google | 14.14 | 29.27 | 2.07 | 289.86 |
| silesia/ooffice | 1048576 | stdx | 10.90 | 20.33 | 1.87 | 323.60 |
| silesia/osdb | 1048576 | Google | 8.22 | 17.48 | 2.13 | 98.94 |
| silesia/osdb | 1048576 | stdx | 5.14 | 10.57 | 2.06 | 91.73 |
| silesia/reymont | 1048576 | Google | 5.39 | 12.62 | 2.34 | 82.19 |
| silesia/reymont | 1048576 | stdx | 3.71 | 9.25 | 2.49 | 47.12 |
| silesia/samba | 1048576 | Google | 7.59 | 16.30 | 2.15 | 94.55 |
| silesia/samba | 1048576 | stdx | 5.05 | 10.71 | 2.12 | 66.47 |
| silesia/sao | 1048576 | Google | 16.84 | 37.18 | 2.21 | 167.68 |
| silesia/sao | 1048576 | stdx | 10.43 | 22.65 | 2.17 | 142.57 |
| silesia/webster | 1048576 | Google | 6.55 | 14.00 | 2.14 | 113.45 |
| silesia/webster | 1048576 | stdx | 4.43 | 9.98 | 2.25 | 69.31 |
| silesia/x-ray | 1048576 | Google | 19.55 | 38.56 | 1.97 | 236.69 |
| silesia/x-ray | 1048576 | stdx | 14.58 | 30.18 | 2.07 | 234.26 |
| silesia/xml | 1048576 | Google | 3.47 | 7.61 | 2.20 | 65.04 |
| silesia/xml | 1048576 | stdx | 2.40 | 5.40 | 2.25 | 46.67 |
| canterbury/alice29.txt | 152089 | Google | 8.90 | 20.55 | 2.31 | 133.94 |
| canterbury/alice29.txt | 152089 | stdx | 6.08 | 15.33 | 2.52 | 80.91 |
| canterbury/asyoulik.txt | 125179 | Google | 10.42 | 23.71 | 2.27 | 166.09 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.07 | 17.43 | 2.47 | 104.76 |
| canterbury/cp.html | 24603 | Google | 9.06 | 22.20 | 2.45 | 110.71 |
| canterbury/cp.html | 24603 | stdx | 5.73 | 17.15 | 2.99 | 32.34 |
| canterbury/fields.c | 11150 | Google | 7.01 | 21.16 | 3.02 | 21.72 |
| canterbury/fields.c | 11150 | stdx | 4.86 | 17.08 | 3.51 | 1.48 |
| canterbury/grammar.lsp | 3721 | Google | 9.78 | 30.16 | 3.08 | 5.63 |
| canterbury/grammar.lsp | 3721 | stdx | 7.12 | 25.04 | 3.52 | 0.48 |
| canterbury/kennedy.xls | 1029744 | Google | 5.41 | 17.05 | 3.15 | 37.34 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.80 | 12.94 | 3.40 | 33.81 |
| canterbury/lcet10.txt | 426754 | Google | 7.75 | 17.36 | 2.24 | 124.80 |
| canterbury/lcet10.txt | 426754 | stdx | 5.20 | 12.96 | 2.49 | 66.19 |
| canterbury/plrabn12.txt | 481861 | Google | 9.08 | 20.82 | 2.29 | 131.80 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.15 | 15.04 | 2.45 | 86.75 |
| canterbury/ptt5 | 513216 | Google | 4.28 | 10.41 | 2.43 | 62.02 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.07 | 64.96 |
| canterbury/sum | 38240 | Google | 10.83 | 26.44 | 2.44 | 157.95 |
| canterbury/sum | 38240 | stdx | 8.34 | 21.11 | 2.53 | 155.66 |
| canterbury/xargs.1 | 4227 | Google | 10.99 | 34.81 | 3.17 | 12.08 |
| canterbury/xargs.1 | 4227 | stdx | 8.46 | 30.44 | 3.60 | 5.82 |
| canterbury-large/E.coli | 1048576 | Google | 8.13 | 19.55 | 2.40 | 1.38 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.39 |
| canterbury-large/bible.txt | 1048576 | Google | 5.30 | 12.28 | 2.31 | 80.55 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.53 | 8.93 | 2.53 | 39.66 |
| canterbury-large/world192.txt | 1048576 | Google | 6.19 | 12.84 | 2.08 | 114.11 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.40 | 9.38 | 2.13 | 77.15 |
| http/html-1kx1024 | 1048576 | Google | 18.10 | 41.93 | 2.32 | 385.72 |
| http/html-1kx1024 | 1048576 | stdx | 15.22 | 37.56 | 2.47 | 356.34 |
| http/html-16kx64 | 1048576 | Google | 6.77 | 14.85 | 2.19 | 147.00 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.71 |
| http/html-1m | 1048576 | Google | 4.04 | 8.94 | 2.21 | 82.52 |
| http/html-1m | 1048576 | stdx | 2.86 | 6.52 | 2.28 | 54.91 |
| http/json-1kx1024 | 1048576 | Google | 14.51 | 36.64 | 2.52 | 241.90 |
| http/json-1kx1024 | 1048576 | stdx | 12.95 | 33.63 | 2.60 | 274.76 |
| http/json-16kx64 | 1048576 | Google | 4.41 | 11.43 | 2.59 | 81.41 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.07 |
| http/json-1m | 1048576 | Google | 3.40 | 8.65 | 2.55 | 58.65 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.44 | 57.66 |
| http/js-1kx1024 | 1048576 | Google | 20.06 | 46.20 | 2.30 | 426.71 |
| http/js-1kx1024 | 1048576 | stdx | 16.32 | 39.90 | 2.44 | 376.40 |
| http/js-16kx64 | 1048576 | Google | 8.06 | 17.73 | 2.20 | 163.66 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.27 |
| http/js-1m | 1048576 | Google | 4.37 | 9.54 | 2.18 | 82.46 |
| http/js-1m | 1048576 | stdx | 3.16 | 7.25 | 2.29 | 55.38 |
| http/css-1kx1024 | 1048576 | Google | 15.56 | 37.36 | 2.40 | 293.94 |
| http/css-1kx1024 | 1048576 | stdx | 13.76 | 34.70 | 2.52 | 299.63 |
| http/css-16kx64 | 1048576 | Google | 4.96 | 11.76 | 2.37 | 100.42 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.52 |
| http/css-1m | 1048576 | Google | 2.44 | 9.42 | 3.86 | 16.78 |
| http/css-1m | 1048576 | stdx | 0.76 | 1.86 | 2.46 | 12.13 |
| shuffled/dickens-1m | 1048576 | Google | 10.20 | 20.65 | 2.03 | 110.59 |
| shuffled/dickens-1m | 1048576 | stdx | 8.75 | 14.53 | 1.66 | 115.24 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.22 | 36.91 | 2.42 | 411.23 |
| silesia/dickens | 10192446 | 1 | stdx | 16.25 | 38.17 | 2.35 | 357.84 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.01 | 87.63 | 1.68 | 693.29 |
| silesia/dickens | 10192446 | 6 | stdx | 49.45 | 84.26 | 1.70 | 1432.69 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.86 | 160.47 | 1.43 | 930.95 |
| silesia/dickens | 10192446 | 9 | stdx | 84.80 | 191.81 | 2.26 | 1715.88 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.14 | 32.62 | 2.31 | 438.62 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.37 | 30.24 | 2.26 | 295.20 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.84 | 70.83 | 2.16 | 578.75 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.59 | 69.96 | 2.21 | 736.56 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.81 | 221.49 | 1.73 | 773.70 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.89 | 126.12 | 2.58 | 789.64 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.96 | 35.02 | 2.93 | 230.24 |
| silesia/mr | 9970564 | 1 | stdx | 12.45 | 34.08 | 2.74 | 187.27 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.23 | 80.54 | 2.11 | 438.78 |
| silesia/mr | 9970564 | 6 | stdx | 39.76 | 83.19 | 2.09 | 981.57 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.93 | 165.48 | 1.69 | 755.47 |
| silesia/mr | 9970564 | 9 | stdx | 87.03 | 206.31 | 2.37 | 1326.08 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.22 | 18.42 | 2.96 | 115.58 |
| silesia/nci | 33553445 | 1 | stdx | 4.98 | 10.88 | 2.19 | 97.63 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.99 | 34.84 | 2.05 | 226.28 |
| silesia/nci | 33553445 | 6 | stdx | 14.44 | 29.54 | 2.05 | 396.13 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.45 | 105.28 | 1.69 | 500.81 |
| silesia/nci | 33553445 | 9 | stdx | 33.07 | 80.64 | 2.44 | 648.57 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.95 | 39.15 | 1.96 | 752.84 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.79 | 39.08 | 2.20 | 430.39 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 40.98 | 79.10 | 1.93 | 953.14 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.60 | 87.83 | 2.11 | 1005.96 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.62 | 127.63 | 1.71 | 1135.82 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.26 | 129.17 | 2.47 | 937.10 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.90 | 30.15 | 2.34 | 353.37 |
| silesia/osdb | 10085684 | 1 | stdx | 12.87 | 27.87 | 2.17 | 294.06 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.28 | 55.67 | 1.97 | 490.53 |
| silesia/osdb | 10085684 | 6 | stdx | 27.10 | 57.40 | 2.12 | 565.90 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.94 | 64.15 | 1.89 | 552.40 |
| silesia/osdb | 10085684 | 9 | stdx | 35.63 | 87.23 | 2.45 | 684.40 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.64 | 32.88 | 2.60 | 311.01 |
| silesia/reymont | 6627202 | 1 | stdx | 13.55 | 33.24 | 2.45 | 271.78 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.12 | 86.58 | 1.80 | 519.74 |
| silesia/reymont | 6627202 | 6 | stdx | 45.23 | 76.82 | 1.70 | 1430.05 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.41 | 276.14 | 1.39 | 838.26 |
| silesia/reymont | 6627202 | 9 | stdx | 87.14 | 189.98 | 2.18 | 1608.56 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.42 | 26.53 | 2.55 | 271.89 |
| silesia/samba | 21606400 | 1 | stdx | 9.90 | 22.23 | 2.24 | 221.23 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.95 | 58.79 | 2.03 | 386.33 |
| silesia/samba | 21606400 | 6 | stdx | 24.17 | 49.84 | 2.06 | 627.67 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.20 | 141.44 | 1.68 | 505.49 |
| silesia/samba | 21606400 | 9 | stdx | 41.56 | 102.63 | 2.47 | 729.41 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.75 | 47.87 | 2.20 | 685.45 |
| silesia/sao | 7251944 | 1 | stdx | 19.33 | 49.92 | 2.58 | 346.23 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.04 | 96.89 | 1.90 | 960.06 |
| silesia/sao | 7251944 | 6 | stdx | 47.12 | 105.66 | 2.24 | 854.50 |
| silesia/sao | 7251944 | 9 | libdeflate | 70.97 | 120.26 | 1.69 | 1107.12 |
| silesia/sao | 7251944 | 9 | stdx | 55.35 | 138.16 | 2.50 | 845.26 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.11 | 30.45 | 2.32 | 386.39 |
| silesia/webster | 41458703 | 1 | stdx | 13.85 | 29.09 | 2.10 | 339.53 |
| silesia/webster | 41458703 | 6 | libdeflate | 37.02 | 66.02 | 1.78 | 569.90 |
| silesia/webster | 41458703 | 6 | stdx | 35.11 | 60.88 | 1.73 | 1112.64 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.60 | 138.85 | 1.47 | 753.76 |
| silesia/webster | 41458703 | 9 | stdx | 60.61 | 135.96 | 2.24 | 1290.64 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.67 | 49.67 | 2.10 | 783.59 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.46 | 50.82 | 2.91 | 261.54 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.79 | 82.77 | 2.52 | 851.33 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.80 | 98.12 | 2.90 | 540.06 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.50 | 91.03 | 2.43 | 1028.42 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.74 | 122.06 | 3.00 | 466.04 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.76 | 21.59 | 2.78 | 175.35 |
| silesia/xml | 5345280 | 1 | stdx | 6.81 | 15.66 | 2.30 | 154.94 |
| silesia/xml | 5345280 | 6 | libdeflate | 20.96 | 40.51 | 1.93 | 264.18 |
| silesia/xml | 5345280 | 6 | stdx | 17.50 | 34.32 | 1.96 | 497.89 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.70 | 89.17 | 1.52 | 372.17 |
| silesia/xml | 5345280 | 9 | stdx | 31.03 | 72.83 | 2.35 | 598.20 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.25 | 35.61 | 2.50 | 378.29 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.05 | 36.13 | 2.40 | 337.31 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.75 | 82.29 | 1.76 | 641.58 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.81 | 77.43 | 1.77 | 1322.40 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.59 | 159.21 | 1.48 | 851.62 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 72.60 | 167.73 | 2.31 | 1506.23 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.15 | 37.20 | 2.45 | 414.58 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.77 | 37.43 | 2.37 | 359.49 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.19 | 85.43 | 1.77 | 715.79 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.00 | 81.93 | 1.78 | 1376.48 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.76 | 136.15 | 1.53 | 939.95 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 75.58 | 175.98 | 2.33 | 1606.57 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.65 | 32.02 | 2.75 | 281.41 |
| canterbury/cp.html | 24603 | 1 | stdx | 10.96 | 27.13 | 2.48 | 244.20 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 26.86 | 62.33 | 2.32 | 481.39 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.71 | 57.06 | 2.41 | 619.99 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.97 | 91.97 | 1.96 | 603.53 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.47 | 88.89 | 2.82 | 644.69 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.51 | 35.92 | 3.78 | 61.63 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.05 | 30.06 | 3.73 | 20.71 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.88 | 69.37 | 2.79 | 266.13 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.85 | 57.62 | 2.76 | 432.60 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.95 | 100.81 | 2.24 | 442.81 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.64 | 92.66 | 3.24 | 443.28 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.08 | 51.51 | 3.94 | 15.83 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.94 | 39.03 | 3.93 | 2.89 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.74 | 87.06 | 3.67 | 28.87 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.19 | 70.82 | 4.12 | 15.93 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.75 | 102.89 | 3.35 | 40.59 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.70 | 99.32 | 4.19 | 53.86 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.38 | 27.18 | 3.68 | 65.68 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.06 | 22.58 | 3.20 | 63.10 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.91 | 73.85 | 2.65 | 96.43 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.34 | 62.00 | 3.21 | 139.28 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.36 | 664.23 | 1.83 | 164.60 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.77 | 130.89 | 3.47 | 219.08 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.78 | 33.99 | 2.47 | 369.94 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.45 | 33.93 | 2.35 | 328.85 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.04 | 78.22 | 1.74 | 609.00 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.63 | 73.43 | 1.76 | 1221.69 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.73 | 136.94 | 1.49 | 804.42 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 70.55 | 162.25 | 2.30 | 1444.98 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.81 | 38.62 | 2.44 | 426.17 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.75 | 40.25 | 2.40 | 370.55 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.04 | 91.90 | 1.70 | 751.59 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.67 | 88.90 | 1.72 | 1516.75 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.90 | 166.26 | 1.42 | 1005.77 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 88.40 | 201.33 | 2.28 | 1793.91 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.43 | 18.61 | 2.89 | 141.89 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.99 | 11.03 | 2.21 | 123.90 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.25 | 36.17 | 2.54 | 219.89 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.40 | 29.58 | 2.38 | 315.40 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.58 | 120.86 | 1.99 | 378.68 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.10 | 130.09 | 3.02 | 639.76 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.85 | 33.49 | 2.61 | 340.87 |
| canterbury/sum | 38240 | 1 | stdx | 12.69 | 29.36 | 2.31 | 308.18 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.63 | 69.87 | 2.44 | 497.20 |
| canterbury/sum | 38240 | 6 | stdx | 26.71 | 65.74 | 2.46 | 660.46 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.50 | 181.91 | 1.92 | 612.42 |
| canterbury/sum | 38240 | 9 | stdx | 39.40 | 112.34 | 2.85 | 657.65 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.47 | 53.06 | 3.94 | 31.66 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.72 | 43.11 | 4.02 | 3.39 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.74 | 87.70 | 3.86 | 63.52 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 17.94 | 74.37 | 4.14 | 41.24 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 24.85 | 94.34 | 3.80 | 89.29 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.48 | 106.97 | 4.04 | 117.49 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.08 | 40.47 | 3.35 | 164.48 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.74 | 42.29 | 3.32 | 101.19 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.40 | 395.99 | 2.16 | 264.81 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.87 | 374.13 | 3.04 | 1898.76 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.98 | 1063.49 | 1.30 | 1327.85 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 230.52 | 755.68 | 3.28 | 2476.27 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.62 | 32.38 | 2.56 | 312.36 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.50 | 32.23 | 2.39 | 281.20 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.11 | 80.12 | 1.74 | 523.31 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.33 | 72.39 | 1.71 | 1270.12 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.80 | 200.28 | 1.41 | 745.27 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.07 | 170.21 | 2.24 | 1439.32 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.33 | 29.72 | 2.23 | 413.19 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.27 | 28.55 | 2.00 | 379.64 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.16 | 60.25 | 1.82 | 558.10 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.05 | 56.81 | 1.77 | 977.71 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.76 | 119.11 | 1.47 | 686.56 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 51.89 | 117.95 | 2.27 | 1143.91 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.48 | 103.92 | 2.93 | 454.89 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.40 | 58.69 | 2.74 | 364.51 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.22 | 138.34 | 2.99 | 566.29 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 32.07 | 94.36 | 2.94 | 530.16 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.70 | 142.44 | 2.99 | 589.64 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 36.32 | 112.18 | 3.09 | 538.88 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.48 | 27.96 | 2.67 | 266.78 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.02 | 20.25 | 2.24 | 234.39 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.32 | 52.09 | 2.33 | 392.43 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.84 | 42.87 | 2.28 | 538.50 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 35.01 | 72.54 | 2.07 | 468.36 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.94 | 69.06 | 2.77 | 549.69 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.76 | 23.03 | 2.63 | 223.49 |
| http/html-1m | 1048576 | 1 | stdx | 8.18 | 17.80 | 2.18 | 206.67 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.30 | 49.53 | 1.96 | 327.74 |
| http/html-1m | 1048576 | 6 | stdx | 21.16 | 40.71 | 1.92 | 618.21 |
| http/html-1m | 1048576 | 9 | libdeflate | 70.97 | 109.24 | 1.54 | 431.77 |
| http/html-1m | 1048576 | 9 | stdx | 35.65 | 85.76 | 2.41 | 704.17 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.81 | 94.80 | 2.98 | 301.35 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.53 | 45.22 | 2.74 | 242.00 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.03 | 126.60 | 2.94 | 374.54 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.23 | 78.43 | 2.88 | 376.98 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.09 | 142.45 | 2.73 | 433.40 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.85 | 95.61 | 3.10 | 384.42 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.87 | 23.85 | 3.03 | 134.74 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.45 | 13.94 | 2.56 | 110.02 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.19 | 46.61 | 2.56 | 206.05 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.42 | 35.02 | 2.61 | 278.55 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.19 | 151.99 | 1.90 | 301.64 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.36 | 58.45 | 3.02 | 302.86 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.74 | 19.85 | 2.94 | 124.88 |
| http/json-1m | 1048576 | 1 | stdx | 5.09 | 12.51 | 2.46 | 103.66 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.32 | 45.30 | 2.23 | 175.88 |
| http/json-1m | 1048576 | 6 | stdx | 14.75 | 35.09 | 2.38 | 302.04 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.61 | 205.21 | 1.69 | 279.76 |
| http/json-1m | 1048576 | 9 | stdx | 29.14 | 72.87 | 2.50 | 368.55 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.18 | 107.80 | 2.90 | 519.34 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.78 | 65.45 | 2.75 | 408.75 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.36 | 144.85 | 2.93 | 679.22 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 35.77 | 104.17 | 2.91 | 620.08 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.74 | 150.13 | 2.90 | 716.46 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 40.65 | 125.18 | 3.08 | 627.82 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.73 | 30.90 | 2.63 | 307.91 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.86 | 24.80 | 2.28 | 273.76 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.89 | 59.43 | 2.30 | 470.28 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.75 | 50.05 | 2.20 | 675.32 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.93 | 83.31 | 2.04 | 569.97 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.90 | 81.31 | 2.72 | 662.67 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.64 | 25.19 | 2.61 | 246.93 |
| http/js-1m | 1048576 | 1 | stdx | 9.57 | 21.31 | 2.23 | 233.36 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.76 | 56.12 | 1.95 | 371.28 |
| http/js-1m | 1048576 | 6 | stdx | 24.91 | 46.64 | 1.87 | 745.51 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.41 | 120.65 | 1.58 | 500.84 |
| http/js-1m | 1048576 | 9 | stdx | 41.98 | 100.01 | 2.38 | 811.02 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.26 | 97.74 | 2.94 | 378.32 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.52 | 49.57 | 2.68 | 301.20 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.92 | 129.23 | 2.94 | 479.21 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.29 | 82.37 | 2.81 | 504.34 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.86 | 133.80 | 2.92 | 507.90 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.38 | 99.53 | 2.98 | 519.31 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.67 | 25.60 | 2.95 | 173.64 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.68 | 16.96 | 2.54 | 134.39 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.21 | 48.80 | 2.41 | 288.49 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.53 | 38.01 | 2.30 | 466.17 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.91 | 82.40 | 2.01 | 374.44 |
| http/css-16kx64 | 1048576 | 9 | stdx | 23.18 | 65.14 | 2.81 | 478.95 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.95 | 21.15 | 3.04 | 132.76 |
| http/css-1m | 1048576 | 1 | stdx | 5.79 | 14.91 | 2.57 | 108.21 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.80 | 44.50 | 2.14 | 226.67 |
| http/css-1m | 1048576 | 6 | stdx | 16.65 | 35.61 | 2.14 | 447.95 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.86 | 111.58 | 1.60 | 309.97 |
| http/css-1m | 1048576 | 9 | stdx | 32.00 | 83.00 | 2.59 | 511.11 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.24 | 48.89 | 1.94 | 928.55 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.13 | 49.19 | 2.71 | 323.67 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.55 | 86.45 | 2.08 | 1181.78 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.75 | 88.80 | 2.23 | 848.47 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.07 | 94.50 | 2.01 | 1343.05 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.22 | 134.38 | 2.48 | 1130.67 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.11 | 31.22 | 3.09 | 120.87 |
| silesia/dickens | 10192446 | 1 | stdx | 24.29 | 82.03 | 3.38 | 126.81 |
| silesia/dickens | 10192446 | 3 | libzstd | 23.05 | 34.39 | 1.49 | 170.88 |
| silesia/dickens | 10192446 | 3 | stdx | 36.85 | 78.22 | 2.12 | 183.99 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.01 | 22.69 | 3.24 | 71.73 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.66 | 54.73 | 3.10 | 175.44 |
| silesia/mozilla | 51220480 | 3 | libzstd | 17.36 | 27.89 | 1.61 | 102.36 |
| silesia/mozilla | 51220480 | 3 | stdx | 31.76 | 62.01 | 1.95 | 146.57 |
| silesia/mr | 9970564 | 1 | libzstd | 7.65 | 24.81 | 3.24 | 58.05 |
| silesia/mr | 9970564 | 1 | stdx | 19.95 | 66.82 | 3.35 | 116.82 |
| silesia/mr | 9970564 | 3 | libzstd | 20.14 | 32.19 | 1.60 | 87.05 |
| silesia/mr | 9970564 | 3 | stdx | 34.53 | 72.46 | 2.10 | 115.68 |
| silesia/nci | 33553445 | 1 | libzstd | 3.54 | 9.55 | 2.70 | 57.93 |
| silesia/nci | 33553445 | 1 | stdx | 7.77 | 25.69 | 3.31 | 60.34 |
| silesia/nci | 33553445 | 3 | libzstd | 5.50 | 9.95 | 1.81 | 57.00 |
| silesia/nci | 33553445 | 3 | stdx | 11.47 | 29.15 | 2.54 | 67.18 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.57 | 29.26 | 3.42 | 72.44 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.12 | 72.51 | 3.14 | 181.59 |
| silesia/ooffice | 6152192 | 3 | libzstd | 24.15 | 39.44 | 1.63 | 120.03 |
| silesia/ooffice | 6152192 | 3 | stdx | 43.52 | 82.20 | 1.89 | 188.86 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.04 | 22.29 | 3.16 | 66.15 |
| silesia/osdb | 10085684 | 1 | stdx | 16.47 | 50.52 | 3.07 | 123.85 |
| silesia/osdb | 10085684 | 3 | libzstd | 18.22 | 26.23 | 1.44 | 68.18 |
| silesia/osdb | 10085684 | 3 | stdx | 33.33 | 57.87 | 1.74 | 112.84 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.70 | 27.13 | 2.80 | 150.63 |
| silesia/reymont | 6627202 | 1 | stdx | 20.18 | 72.05 | 3.57 | 97.13 |
| silesia/reymont | 6627202 | 3 | libzstd | 18.70 | 27.10 | 1.45 | 126.25 |
| silesia/reymont | 6627202 | 3 | stdx | 28.74 | 62.18 | 2.16 | 148.91 |
| silesia/samba | 21606400 | 1 | libzstd | 5.93 | 16.88 | 2.84 | 85.88 |
| silesia/samba | 21606400 | 1 | stdx | 13.51 | 42.89 | 3.17 | 126.50 |
| silesia/samba | 21606400 | 3 | libzstd | 12.14 | 18.81 | 1.55 | 99.25 |
| silesia/samba | 21606400 | 3 | stdx | 20.85 | 44.75 | 2.15 | 134.86 |
| silesia/sao | 7251944 | 1 | libzstd | 9.02 | 33.69 | 3.74 | 45.03 |
| silesia/sao | 7251944 | 1 | stdx | 25.90 | 82.03 | 3.17 | 107.08 |
| silesia/sao | 7251944 | 3 | libzstd | 31.59 | 50.03 | 1.58 | 94.94 |
| silesia/sao | 7251944 | 3 | stdx | 53.21 | 95.22 | 1.79 | 144.64 |
| silesia/webster | 41458703 | 1 | libzstd | 8.64 | 24.94 | 2.89 | 130.93 |
| silesia/webster | 41458703 | 1 | stdx | 20.31 | 64.04 | 3.15 | 167.44 |
| silesia/webster | 41458703 | 3 | libzstd | 19.35 | 27.33 | 1.41 | 177.28 |
| silesia/webster | 41458703 | 3 | stdx | 31.80 | 64.55 | 2.03 | 196.65 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.69 | 14.92 | 3.18 | 17.07 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.83 | 76.64 | 3.22 | 93.20 |
| silesia/x-ray | 8474240 | 3 | libzstd | 31.92 | 52.73 | 1.65 | 87.92 |
| silesia/x-ray | 8474240 | 3 | stdx | 49.32 | 92.40 | 1.87 | 107.28 |
| silesia/xml | 5345280 | 1 | libzstd | 4.21 | 11.71 | 2.78 | 71.65 |
| silesia/xml | 5345280 | 1 | stdx | 10.39 | 34.21 | 3.29 | 95.22 |
| silesia/xml | 5345280 | 3 | libzstd | 6.70 | 12.61 | 1.88 | 77.55 |
| silesia/xml | 5345280 | 3 | stdx | 12.97 | 32.28 | 2.49 | 117.69 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.76 | 32.84 | 3.05 | 139.22 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.42 | 76.49 | 3.41 | 191.25 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.25 | 39.48 | 2.59 | 202.09 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.80 | 73.76 | 2.75 | 340.60 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.72 | 33.55 | 3.45 | 103.28 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.58 | 79.00 | 3.35 | 219.09 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.12 | 39.27 | 2.60 | 208.02 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.39 | 79.30 | 2.79 | 381.26 |
| canterbury/cp.html | 24603 | 1 | libzstd | 7.04 | 26.64 | 3.78 | 43.19 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.07 | 57.76 | 3.59 | 119.19 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.52 | 31.85 | 3.35 | 49.05 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.52 | 59.76 | 3.23 | 153.14 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.74 | 31.76 | 3.63 | 45.31 |
| canterbury/fields.c | 11150 | 1 | stdx | 16.99 | 65.73 | 3.87 | 87.07 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.36 | 34.14 | 3.65 | 30.40 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.51 | 64.68 | 3.69 | 103.28 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.48 | 38.01 | 4.01 | 10.09 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.22 | 77.57 | 3.84 | 50.20 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.68 | 43.09 | 4.04 | 10.41 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.49 | 79.60 | 3.70 | 72.78 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.01 | 23.56 | 3.92 | 14.92 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.73 | 56.75 | 3.85 | 88.02 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.49 | 23.80 | 2.80 | 27.56 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 20.99 | 56.61 | 2.70 | 113.60 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.83 | 28.52 | 2.90 | 156.68 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.46 | 72.02 | 3.36 | 162.15 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 16.25 | 32.14 | 1.98 | 201.69 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.81 | 67.10 | 2.50 | 300.98 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.34 | 32.37 | 3.13 | 129.66 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.17 | 84.16 | 3.34 | 160.68 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 20.25 | 38.77 | 1.91 | 226.62 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 32.10 | 80.77 | 2.52 | 345.93 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.15 | 8.51 | 2.71 | 66.94 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.56 | 23.15 | 3.06 | 106.44 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 4.76 | 10.97 | 2.30 | 58.48 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.70 | 24.08 | 2.48 | 136.07 |
| canterbury/sum | 38240 | 1 | libzstd | 6.53 | 25.39 | 3.89 | 32.23 |
| canterbury/sum | 38240 | 1 | stdx | 16.88 | 59.13 | 3.50 | 149.59 |
| canterbury/sum | 38240 | 3 | libzstd | 9.08 | 30.67 | 3.38 | 50.72 |
| canterbury/sum | 38240 | 3 | stdx | 20.12 | 61.82 | 3.07 | 192.87 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 9.97 | 39.82 | 3.99 | 13.61 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.87 | 80.38 | 3.85 | 58.55 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.30 | 48.17 | 3.91 | 19.42 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.95 | 83.98 | 3.66 | 83.35 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.33 | 33.44 | 3.24 | 77.20 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.88 | 95.62 | 4.37 | 7.27 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 15.13 | 31.30 | 2.07 | 35.94 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 24.41 | 70.38 | 2.88 | 38.34 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.71 | 27.45 | 2.83 | 149.31 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.62 | 71.86 | 3.48 | 109.16 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 18.40 | 28.20 | 1.53 | 132.89 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 28.77 | 63.36 | 2.20 | 156.93 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.14 | 22.70 | 2.79 | 138.02 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.67 | 55.86 | 2.99 | 195.56 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 15.54 | 23.87 | 1.54 | 174.36 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 25.65 | 51.26 | 2.00 | 240.90 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.00 | 52.46 | 3.09 | 161.77 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.94 | 100.54 | 2.80 | 644.15 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 18.95 | 59.20 | 3.12 | 196.71 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 38.48 | 104.00 | 2.70 | 642.50 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.70 | 22.46 | 2.92 | 123.48 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.15 | 46.84 | 3.31 | 184.26 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.77 | 24.61 | 2.81 | 143.66 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.95 | 47.61 | 2.98 | 195.34 |
| http/html-1m | 1048576 | 1 | libzstd | 6.23 | 16.74 | 2.69 | 115.08 |
| http/html-1m | 1048576 | 1 | stdx | 12.97 | 42.00 | 3.24 | 136.04 |
| http/html-1m | 1048576 | 3 | libzstd | 9.41 | 18.18 | 1.93 | 125.38 |
| http/html-1m | 1048576 | 3 | stdx | 16.03 | 39.37 | 2.46 | 178.83 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.25 | 42.52 | 2.98 | 116.39 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.73 | 83.13 | 2.80 | 534.37 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.73 | 44.54 | 3.02 | 128.52 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.71 | 84.87 | 2.76 | 540.21 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.79 | 14.98 | 3.13 | 57.62 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.71 | 33.78 | 3.48 | 118.07 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.33 | 16.21 | 3.04 | 72.64 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.66 | 34.58 | 3.24 | 125.54 |
| http/json-1m | 1048576 | 1 | libzstd | 4.06 | 12.55 | 3.09 | 53.39 |
| http/json-1m | 1048576 | 1 | stdx | 9.03 | 30.70 | 3.40 | 87.08 |
| http/json-1m | 1048576 | 3 | libzstd | 6.21 | 13.78 | 2.22 | 68.72 |
| http/json-1m | 1048576 | 3 | stdx | 11.60 | 30.64 | 2.64 | 122.68 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.51 | 57.26 | 3.09 | 188.50 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 40.24 | 113.49 | 2.82 | 703.53 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.31 | 65.54 | 3.08 | 260.20 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.59 | 116.54 | 2.74 | 693.08 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.85 | 26.52 | 3.00 | 129.56 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.73 | 55.71 | 3.33 | 203.23 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.06 | 28.74 | 2.86 | 155.19 |
| http/js-16kx64 | 1048576 | 3 | stdx | 18.02 | 55.35 | 3.07 | 212.71 |
| http/js-1m | 1048576 | 1 | libzstd | 6.52 | 17.87 | 2.74 | 114.09 |
| http/js-1m | 1048576 | 1 | stdx | 14.02 | 45.88 | 3.27 | 138.09 |
| http/js-1m | 1048576 | 3 | libzstd | 10.01 | 19.14 | 1.91 | 124.66 |
| http/js-1m | 1048576 | 3 | stdx | 17.41 | 41.25 | 2.37 | 189.18 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.52 | 46.90 | 3.02 | 138.45 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.65 | 91.65 | 2.81 | 585.43 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.54 | 50.53 | 3.05 | 160.26 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 34.02 | 93.63 | 2.75 | 592.30 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.13 | 18.99 | 3.10 | 79.77 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.49 | 43.79 | 3.51 | 139.52 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.55 | 19.41 | 2.96 | 96.08 |
| http/css-16kx64 | 1048576 | 3 | stdx | 13.02 | 42.34 | 3.25 | 154.15 |
| http/css-1m | 1048576 | 1 | libzstd | 1.50 | 4.59 | 3.06 | 21.82 |
| http/css-1m | 1048576 | 1 | stdx | 4.02 | 14.85 | 3.69 | 30.72 |
| http/css-1m | 1048576 | 3 | libzstd | 1.98 | 5.25 | 2.65 | 19.81 |
| http/css-1m | 1048576 | 3 | stdx | 4.01 | 13.33 | 3.32 | 31.95 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.52 | 12.79 | 3.63 | 6.15 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.17 | 30.66 | 3.34 | 62.94 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 28.53 | 50.53 | 1.77 | 49.21 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 21.65 | 47.43 | 2.19 | 211.80 |

## Hardware counters per input octet, brotli encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | Google q1 | 18.51 | 30.24 | 1.63 | 230.95 |
| silesia/dickens | 10192446 | stdx 1 | 19.54 | 43.43 | 2.22 | 413.46 |
| silesia/dickens | 10192446 | Google q5 | 112.60 | 194.36 | 1.73 | 827.24 |
| silesia/dickens | 10192446 | stdx 5 | 74.19 | 156.05 | 2.10 | 983.27 |
| silesia/mozilla | 51220480 | Google q1 | 13.33 | 25.26 | 1.89 | 144.49 |
| silesia/mozilla | 51220480 | stdx 1 | 12.36 | 32.95 | 2.67 | 213.50 |
| silesia/mozilla | 51220480 | Google q5 | 65.58 | 149.30 | 2.28 | 801.53 |
| silesia/mozilla | 51220480 | stdx 5 | 60.45 | 147.29 | 2.44 | 813.07 |
| silesia/mr | 9970564 | Google q1 | 13.34 | 26.14 | 1.96 | 97.43 |
| silesia/mr | 9970564 | stdx 1 | 13.75 | 37.80 | 2.75 | 165.25 |
| silesia/mr | 9970564 | Google q5 | 87.36 | 177.41 | 2.03 | 607.72 |
| silesia/mr | 9970564 | stdx 5 | 68.52 | 148.94 | 2.17 | 694.75 |
| silesia/nci | 33553445 | Google q1 | 5.23 | 9.71 | 1.86 | 87.46 |
| silesia/nci | 33553445 | stdx 1 | 6.08 | 14.48 | 2.38 | 127.85 |
| silesia/nci | 33553445 | Google q5 | 31.85 | 59.01 | 1.85 | 412.54 |
| silesia/nci | 33553445 | stdx 5 | 30.52 | 58.55 | 1.92 | 486.81 |
| silesia/ooffice | 6152192 | Google q1 | 17.93 | 33.43 | 1.87 | 154.65 |
| silesia/ooffice | 6152192 | stdx 1 | 16.91 | 45.85 | 2.71 | 267.52 |
| silesia/ooffice | 6152192 | Google q5 | 93.35 | 198.80 | 2.13 | 1069.49 |
| silesia/ooffice | 6152192 | stdx 5 | 74.83 | 176.82 | 2.36 | 1071.01 |
| silesia/osdb | 10085684 | Google q1 | 12.79 | 23.47 | 1.84 | 84.11 |
| silesia/osdb | 10085684 | stdx 1 | 11.72 | 32.00 | 2.73 | 141.86 |
| silesia/osdb | 10085684 | Google q5 | 74.57 | 146.01 | 1.96 | 547.32 |
| silesia/osdb | 10085684 | stdx 5 | 54.70 | 122.60 | 2.24 | 523.89 |
| silesia/reymont | 6627202 | Google q1 | 15.50 | 25.54 | 1.65 | 207.89 |
| silesia/reymont | 6627202 | stdx 1 | 14.52 | 33.36 | 2.30 | 283.71 |
| silesia/reymont | 6627202 | Google q5 | 86.73 | 169.16 | 1.95 | 799.78 |
| silesia/reymont | 6627202 | stdx 5 | 65.19 | 140.26 | 2.15 | 903.44 |
| silesia/samba | 21606400 | Google q1 | 9.91 | 17.38 | 1.75 | 127.42 |
| silesia/samba | 21606400 | stdx 1 | 9.94 | 23.94 | 2.41 | 197.06 |
| silesia/samba | 21606400 | Google q5 | 49.31 | 105.54 | 2.14 | 480.25 |
| silesia/samba | 21606400 | stdx 5 | 43.92 | 102.34 | 2.33 | 529.05 |
| silesia/sao | 7251944 | Google q1 | 21.63 | 39.96 | 1.85 | 101.85 |
| silesia/sao | 7251944 | stdx 1 | 18.83 | 55.66 | 2.96 | 190.44 |
| silesia/sao | 7251944 | Google q5 | 118.49 | 259.63 | 2.19 | 936.06 |
| silesia/sao | 7251944 | stdx 5 | 88.74 | 226.51 | 2.55 | 755.28 |
| silesia/webster | 41458703 | Google q1 | 14.76 | 24.40 | 1.65 | 208.72 |
| silesia/webster | 41458703 | stdx 1 | 15.33 | 34.12 | 2.23 | 339.25 |
| silesia/webster | 41458703 | Google q5 | 80.92 | 141.82 | 1.75 | 756.98 |
| silesia/webster | 41458703 | stdx 5 | 64.95 | 121.37 | 1.87 | 850.00 |
| silesia/x-ray | 8474240 | Google q1 | 13.98 | 22.03 | 1.58 | 12.45 |
| silesia/x-ray | 8474240 | stdx 1 | 13.18 | 38.68 | 2.93 | 95.24 |
| silesia/x-ray | 8474240 | Google q5 | 110.66 | 236.76 | 2.14 | 725.98 |
| silesia/x-ray | 8474240 | stdx 5 | 85.92 | 224.49 | 2.61 | 645.05 |
| silesia/xml | 5345280 | Google q1 | 7.05 | 12.28 | 1.74 | 113.28 |
| silesia/xml | 5345280 | stdx 1 | 7.31 | 17.44 | 2.39 | 152.56 |
| silesia/xml | 5345280 | Google q5 | 32.86 | 72.50 | 2.21 | 359.15 |
| silesia/xml | 5345280 | stdx 5 | 29.67 | 64.71 | 2.18 | 408.96 |
| canterbury/alice29.txt | 152089 | Google q1 | 16.86 | 29.72 | 1.76 | 208.41 |
| canterbury/alice29.txt | 152089 | stdx 1 | 18.35 | 40.79 | 2.22 | 446.38 |
| canterbury/alice29.txt | 152089 | Google q5 | 80.98 | 200.77 | 2.48 | 1039.34 |
| canterbury/alice29.txt | 152089 | stdx 5 | 69.37 | 150.71 | 2.17 | 918.05 |
| canterbury/asyoulik.txt | 125179 | Google q1 | 18.01 | 32.37 | 1.80 | 222.61 |
| canterbury/asyoulik.txt | 125179 | stdx 1 | 20.06 | 44.50 | 2.22 | 500.76 |
| canterbury/asyoulik.txt | 125179 | Google q5 | 86.75 | 215.27 | 2.48 | 1076.35 |
| canterbury/asyoulik.txt | 125179 | stdx 5 | 77.16 | 162.50 | 2.11 | 1057.28 |
| canterbury/cp.html | 24603 | Google q1 | 13.05 | 27.30 | 2.09 | 102.13 |
| canterbury/cp.html | 24603 | stdx 1 | 14.57 | 36.07 | 2.48 | 347.93 |
| canterbury/cp.html | 24603 | Google q5 | 61.97 | 163.89 | 2.64 | 957.36 |
| canterbury/cp.html | 24603 | stdx 5 | 58.66 | 131.02 | 2.23 | 731.61 |
| canterbury/fields.c | 11150 | Google q1 | 12.10 | 29.04 | 2.40 | 12.97 |
| canterbury/fields.c | 11150 | stdx 1 | 10.54 | 38.87 | 3.69 | 90.43 |
| canterbury/fields.c | 11150 | Google q5 | 59.57 | 168.16 | 2.82 | 920.49 |
| canterbury/fields.c | 11150 | stdx 5 | 45.27 | 123.15 | 2.72 | 546.96 |
| canterbury/grammar.lsp | 3721 | Google q1 | 14.37 | 39.39 | 2.74 | 11.37 |
| canterbury/grammar.lsp | 3721 | stdx 1 | 13.45 | 55.22 | 4.11 | 28.56 |
| canterbury/grammar.lsp | 3721 | Google q5 | 60.29 | 203.91 | 3.38 | 421.97 |
| canterbury/grammar.lsp | 3721 | stdx 5 | 41.49 | 148.05 | 3.57 | 148.24 |
| canterbury/kennedy.xls | 1029744 | Google q1 | 9.88 | 24.83 | 2.51 | 59.79 |
| canterbury/kennedy.xls | 1029744 | stdx 1 | 7.83 | 27.03 | 3.45 | 77.02 |
| canterbury/kennedy.xls | 1029744 | Google q5 | 47.79 | 162.91 | 3.41 | 266.88 |
| canterbury/kennedy.xls | 1029744 | stdx 5 | 52.47 | 162.35 | 3.09 | 467.67 |
| canterbury/lcet10.txt | 426754 | Google q1 | 15.96 | 27.19 | 1.70 | 201.12 |
| canterbury/lcet10.txt | 426754 | stdx 1 | 16.82 | 37.84 | 2.25 | 379.22 |
| canterbury/lcet10.txt | 426754 | Google q5 | 79.01 | 187.58 | 2.37 | 959.99 |
| canterbury/lcet10.txt | 426754 | stdx 5 | 65.95 | 140.98 | 2.14 | 904.95 |
| canterbury/plrabn12.txt | 481861 | Google q1 | 18.84 | 32.57 | 1.73 | 250.85 |
| canterbury/plrabn12.txt | 481861 | stdx 1 | 20.87 | 46.66 | 2.24 | 475.46 |
| canterbury/plrabn12.txt | 481861 | Google q5 | 97.52 | 229.77 | 2.36 | 1065.97 |
| canterbury/plrabn12.txt | 481861 | stdx 5 | 83.53 | 169.17 | 2.03 | 1187.74 |
| canterbury/ptt5 | 513216 | Google q1 | 4.94 | 9.55 | 1.94 | 80.21 |
| canterbury/ptt5 | 513216 | stdx 1 | 6.66 | 15.64 | 2.35 | 160.41 |
| canterbury/ptt5 | 513216 | Google q5 | 27.63 | 68.87 | 2.49 | 471.64 |
| canterbury/ptt5 | 513216 | stdx 5 | 30.12 | 69.62 | 2.31 | 466.66 |
| canterbury/sum | 38240 | Google q1 | 12.88 | 29.25 | 2.27 | 89.03 |
| canterbury/sum | 38240 | stdx 1 | 15.47 | 36.37 | 2.35 | 401.96 |
| canterbury/sum | 38240 | Google q5 | 66.28 | 182.58 | 2.75 | 1097.01 |
| canterbury/sum | 38240 | stdx 5 | 66.03 | 158.18 | 2.40 | 841.65 |
| canterbury/xargs.1 | 4227 | Google q1 | 16.18 | 43.16 | 2.67 | 13.54 |
| canterbury/xargs.1 | 4227 | stdx 1 | 14.73 | 59.10 | 4.01 | 43.60 |
| canterbury/xargs.1 | 4227 | Google q5 | 70.69 | 219.02 | 3.10 | 769.96 |
| canterbury/xargs.1 | 4227 | stdx 5 | 48.88 | 158.73 | 3.25 | 270.56 |
| canterbury-large/E.coli | 4638690 | Google q1 | 13.57 | 27.46 | 2.02 | 53.33 |
| canterbury-large/E.coli | 4638690 | stdx 1 | 5.76 | 19.24 | 3.34 | 18.03 |
| canterbury-large/E.coli | 4638690 | Google q5 | 93.02 | 262.67 | 2.82 | 995.34 |
| canterbury-large/E.coli | 4638690 | stdx 5 | 31.49 | 92.99 | 2.95 | 65.09 |
| canterbury-large/bible.txt | 4047392 | Google q1 | 15.02 | 24.57 | 1.64 | 175.89 |
| canterbury-large/bible.txt | 4047392 | stdx 1 | 15.44 | 34.29 | 2.22 | 317.15 |
| canterbury-large/bible.txt | 4047392 | Google q5 | 103.70 | 165.65 | 1.60 | 735.58 |
| canterbury-large/bible.txt | 4047392 | stdx 5 | 61.23 | 134.75 | 2.20 | 805.22 |
| canterbury-large/world192.txt | 2473400 | Google q1 | 13.79 | 22.62 | 1.64 | 195.91 |
| canterbury-large/world192.txt | 2473400 | stdx 1 | 13.83 | 31.07 | 2.25 | 315.04 |
| canterbury-large/world192.txt | 2473400 | Google q5 | 74.33 | 129.46 | 1.74 | 747.78 |
| canterbury-large/world192.txt | 2473400 | stdx 5 | 58.51 | 105.23 | 1.80 | 767.26 |
| http/html-1kx1024 | 1048576 | Google q1 | 32.20 | 62.53 | 1.94 | 858.82 |
| http/html-1kx1024 | 1048576 | stdx 1 | 27.83 | 80.73 | 2.90 | 472.65 |
| http/html-1kx1024 | 1048576 | Google q5 | 106.94 | 260.90 | 2.44 | 2101.14 |
| http/html-1kx1024 | 1048576 | stdx 5 | 69.78 | 168.79 | 2.42 | 1198.13 |
| http/html-16kx64 | 1048576 | Google q1 | 11.32 | 20.38 | 1.80 | 213.92 |
| http/html-16kx64 | 1048576 | stdx 1 | 11.46 | 28.46 | 2.48 | 302.10 |
| http/html-16kx64 | 1048576 | Google q5 | 47.64 | 118.53 | 2.49 | 856.90 |
| http/html-16kx64 | 1048576 | stdx 5 | 41.78 | 92.79 | 2.22 | 676.40 |
| http/html-1m | 1048576 | Google q1 | 8.97 | 15.15 | 1.69 | 137.43 |
| http/html-1m | 1048576 | stdx 1 | 9.64 | 22.18 | 2.30 | 225.22 |
| http/html-1m | 1048576 | Google q5 | 47.25 | 104.93 | 2.22 | 578.14 |
| http/html-1m | 1048576 | stdx 5 | 37.74 | 84.35 | 2.24 | 542.80 |
| http/json-1kx1024 | 1048576 | Google q1 | 24.59 | 49.87 | 2.03 | 649.75 |
| http/json-1kx1024 | 1048576 | stdx 1 | 20.88 | 61.65 | 2.95 | 362.59 |
| http/json-1kx1024 | 1048576 | Google q5 | 80.05 | 203.15 | 2.54 | 1334.03 |
| http/json-1kx1024 | 1048576 | stdx 5 | 50.52 | 131.80 | 2.61 | 733.81 |
| http/json-16kx64 | 1048576 | Google q1 | 7.68 | 14.90 | 1.94 | 142.51 |
| http/json-16kx64 | 1048576 | stdx 1 | 7.04 | 19.73 | 2.80 | 159.76 |
| http/json-16kx64 | 1048576 | Google q5 | 36.52 | 97.81 | 2.68 | 560.33 |
| http/json-16kx64 | 1048576 | stdx 5 | 36.09 | 88.74 | 2.46 | 531.11 |
| http/json-1m | 1048576 | Google q1 | 6.21 | 12.65 | 2.04 | 91.85 |
| http/json-1m | 1048576 | stdx 1 | 6.64 | 17.21 | 2.59 | 140.43 |
| http/json-1m | 1048576 | Google q5 | 37.35 | 96.08 | 2.57 | 448.32 |
| http/json-1m | 1048576 | stdx 5 | 39.12 | 92.42 | 2.36 | 572.32 |
| http/js-1kx1024 | 1048576 | Google q1 | 34.75 | 68.18 | 1.96 | 905.24 |
| http/js-1kx1024 | 1048576 | stdx 1 | 30.26 | 90.40 | 2.99 | 528.01 |
| http/js-1kx1024 | 1048576 | Google q5 | 116.94 | 288.57 | 2.47 | 2288.11 |
| http/js-1kx1024 | 1048576 | stdx 5 | 78.09 | 187.33 | 2.40 | 1334.98 |
| http/js-16kx64 | 1048576 | Google q1 | 13.17 | 24.07 | 1.83 | 231.72 |
| http/js-16kx64 | 1048576 | stdx 1 | 13.34 | 32.69 | 2.45 | 354.44 |
| http/js-16kx64 | 1048576 | Google q5 | 56.05 | 141.15 | 2.52 | 998.93 |
| http/js-16kx64 | 1048576 | stdx 5 | 48.48 | 107.08 | 2.21 | 796.98 |
| http/js-1m | 1048576 | Google q1 | 9.80 | 16.69 | 1.70 | 140.55 |
| http/js-1m | 1048576 | stdx 1 | 10.16 | 23.55 | 2.32 | 229.45 |
| http/js-1m | 1048576 | Google q5 | 53.07 | 116.02 | 2.19 | 637.65 |
| http/js-1m | 1048576 | stdx 5 | 40.12 | 90.34 | 2.25 | 586.96 |
| http/css-1kx1024 | 1048576 | Google q1 | 27.58 | 54.06 | 1.96 | 731.36 |
| http/css-1kx1024 | 1048576 | stdx 1 | 23.48 | 68.32 | 2.91 | 429.51 |
| http/css-1kx1024 | 1048576 | Google q5 | 86.88 | 213.92 | 2.46 | 1644.68 |
| http/css-1kx1024 | 1048576 | stdx 5 | 54.86 | 138.71 | 2.53 | 912.06 |
| http/css-16kx64 | 1048576 | Google q1 | 9.00 | 16.85 | 1.87 | 139.79 |
| http/css-16kx64 | 1048576 | stdx 1 | 8.51 | 23.62 | 2.78 | 192.08 |
| http/css-16kx64 | 1048576 | Google q5 | 38.04 | 100.68 | 2.65 | 647.99 |
| http/css-16kx64 | 1048576 | stdx 5 | 32.18 | 81.61 | 2.54 | 496.16 |
| http/css-1m | 1048576 | Google q1 | 6.00 | 11.27 | 1.88 | 75.92 |
| http/css-1m | 1048576 | stdx 1 | 5.45 | 14.38 | 2.64 | 109.45 |
| http/css-1m | 1048576 | Google q5 | 14.76 | 38.50 | 2.61 | 129.81 |
| http/css-1m | 1048576 | stdx 5 | 14.76 | 36.92 | 2.50 | 111.84 |
| shuffled/dickens-1m | 1048576 | Google q1 | 11.48 | 20.96 | 1.83 | 2.94 |
| shuffled/dickens-1m | 1048576 | stdx 1 | 5.37 | 19.75 | 3.68 | 16.70 |
| shuffled/dickens-1m | 1048576 | Google q5 | 106.22 | 235.57 | 2.22 | 725.92 |
| shuffled/dickens-1m | 1048576 | stdx 5 | 46.41 | 121.56 | 2.62 | 250.92 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.5 | 74.2 | 0.122 | 3.01 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 65.7 | 219.6 | 0.084 | 7.76 | 3.34 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 30.7 | 96.1 | 0.163 | 3.63 | 3.13 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 250.3 | 1024.0 | 0.851 | 29.57 | 4.09 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.9 | 107.7 | 0.135 | 3.65 | 3.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.2 | 106.2 | 0.305 | 3.33 | 3.77 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 96.1 | 378.2 | 0.380 | 11.36 | 3.93 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 43.1 | 161.9 | 0.481 | 5.09 | 3.76 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 92.0 | 451.6 | 0.305 | 10.87 | 4.91 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.3 | 89.5 | 0.004 | 4.02 | 3.28 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.1 | 234.7 | 0.040 | 10.02 | 3.45 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 29.4 | 99.4 | 0.010 | 4.33 | 3.38 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 216.5 | 819.1 | 0.944 | 31.86 | 3.78 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.3 | 107.7 | 0.040 | 4.17 | 3.80 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 30.7 | 106.0 | 0.046 | 4.53 | 3.45 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 95.1 | 346.2 | 0.341 | 13.99 | 3.64 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 32.1 | 144.5 | 0.053 | 4.73 | 4.50 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 93.8 | 406.5 | 0.088 | 13.80 | 4.33 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 115317.1 | 403846.2 | 538.763 | 0.67 | 3.50 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 589030.1 | 2503286.2 | 1392.948 | 3.41 | 4.25 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 114598.4 | 404249.2 | 499.278 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3584719.0 | 18223876.2 | 3004.072 | 20.78 | 5.08 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311840.6 | 621744.2 | 619.711 | 1.81 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 224189.8 | 826630.2 | 2178.670 | 1.30 | 3.69 |
| string: silesia/dickens | 1 | 172528 | std.json | 1571006.1 | 4578768.2 | 42247.278 | 9.11 | 2.91 |
| string: silesia/dickens | 1 | 172528 | serde_json | 203940.1 | 802391.2 | 987.660 | 1.18 | 3.93 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1052743.6 | 5283876.3 | 4990.825 | 6.10 | 5.02 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1570576.5 | 4799763.6 | 1532.143 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14389554.4 | 56816152.6 | 39374.000 | 12.09 | 3.95 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1569281.9 | 4799955.6 | 1422.286 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 29141557.4 | 132108253.6 | 163376.000 | 24.48 | 4.53 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4588641.5 | 7062781.6 | 619.000 | 3.86 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1796846.9 | 7322029.6 | 14166.143 | 1.51 | 4.07 |
| string: http/json-1m | 1 | 1190272 | std.json | 10383905.6 | 47381213.6 | 32088.071 | 8.72 | 4.56 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3792758.4 | 15226459.6 | 6148.000 | 3.19 | 4.01 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9062558.8 | 47990865.1 | 27684.000 | 7.61 | 5.30 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2071749.3 | 5765413.8 | 4489.875 | 1.10 | 2.78 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6165270.8 | 22589263.8 | 6964.000 | 3.27 | 3.66 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2059063.9 | 5765605.8 | 3980.750 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47261480.0 | 227842320.8 | 277216.500 | 25.10 | 4.82 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3772089.3 | 8446023.8 | 1864.750 | 2.00 | 2.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7200245.1 | 12276717.8 | 276081.375 | 3.82 | 1.71 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17449381.3 | 63617055.8 | 266443.625 | 9.27 | 3.65 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9475721.0 | 24440755.8 | 331606.000 | 5.03 | 2.58 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39623143.0 | 160412043.4 | 802085.375 | 21.04 | 4.05 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12941195.7 | 42561069.3 | 244927.667 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 160637034.7 | 667246747.3 | 396117.333 | 31.65 | 4.15 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12932198.0 | 42561261.3 | 244130.667 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 159928597.0 | 639992662.3 | 423404.333 | 31.51 | 4.00 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17561371.7 | 49745820.3 | 253281.333 | 3.46 | 2.83 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14316568.0 | 45615166.3 | 450679.667 | 2.82 | 3.19 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79570710.3 | 314900845.3 | 459291.333 | 15.68 | 3.96 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36396780.0 | 131556135.3 | 590991.333 | 7.17 | 3.61 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66715587.0 | 273931011.3 | 831918.333 | 13.14 | 4.11 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 94650.7 | 303836.7 | 9.645 | 0.18 | 3.21 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 185148.4 | 623465.7 | 8.032 | 0.35 | 3.37 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 148434.4 | 557622.7 | 7.645 | 0.28 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10241292.7 | 53478202.7 | 8.032 | 19.53 | 5.22 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 489900.5 | 1376733.7 | 5.452 | 0.93 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 540318.2 | 2195917.7 | 6.000 | 1.03 | 4.06 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3498932.0 | 12808414.7 | 61227.839 | 6.67 | 3.66 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 297619.1 | 1179969.7 | 5.839 | 0.57 | 3.96 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2255595.0 | 12789265.1 | 248.452 | 4.30 | 5.67 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.7 | 81.8 | 0.107 | 2.33 | 4.15 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.3 | 153.6 | 0.127 | 4.16 | 4.36 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 21.2 | 93.4 | 0.090 | 2.50 | 4.41 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 216.5 | 981.0 | 0.926 | 25.57 | 4.53 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 19.3 | 79.5 | 0.107 | 2.27 | 4.13 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.1 | 94.1 | 0.134 | 2.73 | 4.08 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.5 | 105.6 | 0.250 | 3.25 | 3.84 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.5 | 310.8 | 0.368 | 8.21 | 4.47 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.7 | 255.3 | 0.517 | 7.53 | 4.01 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.8 | 315.1 | 0.235 | 8.13 | 4.58 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.5 | 82.8 | 0.024 | 2.72 | 4.49 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.1 | 153.9 | 0.027 | 5.31 | 4.27 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 21.9 | 94.2 | 0.024 | 3.22 | 4.30 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 168.0 | 718.3 | 1.234 | 24.73 | 4.27 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.0 | 81.5 | 0.024 | 2.64 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.9 | 96.8 | 0.032 | 3.22 | 4.42 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.5 | 117.9 | 0.033 | 4.34 | 4.00 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 60.7 | 271.2 | 0.282 | 8.93 | 4.47 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 48.3 | 211.0 | 0.038 | 7.10 | 4.37 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 82.9 | 331.7 | 0.094 | 12.20 | 4.00 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 85266.5 | 280786.2 | 720.649 | 0.49 | 3.29 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 85084.5 | 280732.2 | 715.835 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 85047.9 | 280721.2 | 715.639 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3384952.6 | 16047574.2 | 2945.062 | 19.62 | 4.74 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 83002.9 | 274401.2 | 656.918 | 0.48 | 3.31 |
| string: silesia/dickens | 1 | 172528 | simdjson | 208733.2 | 674016.2 | 2108.784 | 1.21 | 3.23 |
| string: silesia/dickens | 1 | 172528 | yyjson | 205307.2 | 825518.2 | 1094.412 | 1.19 | 4.02 |
| string: silesia/dickens | 1 | 172528 | std.json | 1361580.3 | 2890892.2 | 54777.918 | 7.89 | 2.12 |
| string: silesia/dickens | 1 | 172528 | serde_json | 368088.3 | 1586249.2 | 2320.443 | 2.13 | 4.31 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 577474.4 | 2970293.3 | 2341.546 | 3.35 | 5.14 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1281181.9 | 3582350.6 | 11910.071 | 1.08 | 2.80 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1273192.4 | 3582290.6 | 11545.571 | 1.07 | 2.81 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1272510.0 | 3582277.6 | 11486.071 | 1.07 | 2.82 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25301251.9 | 109856348.6 | 143541.786 | 21.26 | 4.34 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1233878.4 | 3370022.6 | 11350.071 | 1.04 | 2.73 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2980169.1 | 10460762.6 | 29416.929 | 2.50 | 3.51 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2588830.3 | 10197931.6 | 9517.429 | 2.17 | 3.94 |
| string: http/json-1m | 1 | 1190272 | std.json | 8884838.2 | 43287986.6 | 16548.000 | 7.46 | 4.87 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4198179.0 | 17941088.6 | 10565.000 | 3.53 | 4.27 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5259258.1 | 26999674.4 | 11495.357 | 4.42 | 5.13 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2070971.3 | 6088099.8 | 4595.875 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2061305.9 | 6088039.8 | 4158.125 | 1.09 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2060609.0 | 6088026.8 | 4076.625 | 1.09 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43633224.3 | 193466548.8 | 268787.750 | 23.17 | 4.43 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2069293.0 | 5875346.8 | 4787.000 | 1.10 | 2.84 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2709081.8 | 7144143.8 | 21015.750 | 1.44 | 2.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12124673.9 | 23590602.8 | 447399.625 | 6.44 | 1.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20199220.5 | 56837736.8 | 543533.625 | 10.73 | 2.81 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11604976.6 | 33662338.8 | 334179.875 | 6.16 | 2.90 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18824761.3 | 76319428.0 | 253431.000 | 10.00 | 4.05 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113183.2 | 426376.7 | 5.194 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113080.1 | 426318.7 | 3.581 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113165.6 | 426305.7 | 3.161 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 637535.5 | 3146479.7 | 5.903 | 1.22 | 4.94 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113068.7 | 426343.7 | 2.258 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1203710.2 | 3866916.7 | 4.774 | 2.30 | 3.21 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1622618.3 | 5833341.7 | 6.419 | 3.09 | 3.60 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3525365.2 | 13108830.7 | 78634.774 | 6.72 | 3.72 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1785075.5 | 7405810.7 | 4.097 | 3.40 | 4.15 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2390952.5 | 12748252.2 | 17.742 | 4.56 | 5.33 |
