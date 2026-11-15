# bench-profile

| Field | Value |
|---|---|
| Commit | 3a70a3d |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43648388947 |
| Date | 2026-11-14 |

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
| silesia/dickens | 10192446 | zlib | 8.96 | 19.08 | 2.13 | 310.57 |
| silesia/dickens | 10192446 | zlib-ng | 4.96 | 10.50 | 2.12 | 67.54 |
| silesia/dickens | 10192446 | libdeflate | 3.58 | 9.56 | 2.67 | 66.81 |
| silesia/dickens | 10192446 | Wuffs | 5.60 | 13.90 | 2.48 | 97.73 |
| silesia/dickens | 10192446 | stdx | 3.21 | 7.15 | 2.22 | 76.07 |
| silesia/mozilla | 51220480 | zlib | 8.53 | 17.23 | 2.02 | 251.36 |
| silesia/mozilla | 51220480 | zlib-ng | 4.98 | 8.95 | 1.80 | 85.50 |
| silesia/mozilla | 51220480 | libdeflate | 3.52 | 7.63 | 2.17 | 71.16 |
| silesia/mozilla | 51220480 | Wuffs | 6.46 | 13.89 | 2.15 | 132.51 |
| silesia/mozilla | 51220480 | stdx | 3.72 | 6.29 | 1.69 | 89.66 |
| silesia/mr | 9970564 | zlib | 8.55 | 18.46 | 2.16 | 202.84 |
| silesia/mr | 9970564 | zlib-ng | 4.86 | 9.98 | 2.05 | 67.93 |
| silesia/mr | 9970564 | libdeflate | 3.47 | 8.58 | 2.47 | 61.14 |
| silesia/mr | 9970564 | Wuffs | 6.06 | 14.04 | 2.32 | 100.00 |
| silesia/mr | 9970564 | stdx | 3.32 | 6.70 | 2.02 | 70.46 |
| silesia/nci | 33553445 | zlib | 3.62 | 10.18 | 2.81 | 81.22 |
| silesia/nci | 33553445 | zlib-ng | 1.69 | 3.13 | 1.85 | 33.75 |
| silesia/nci | 33553445 | libdeflate | 1.36 | 2.66 | 1.96 | 29.81 |
| silesia/nci | 33553445 | Wuffs | 2.55 | 6.47 | 2.54 | 41.47 |
| silesia/nci | 33553445 | stdx | 1.46 | 2.20 | 1.51 | 37.43 |
| silesia/ooffice | 6152192 | zlib | 11.90 | 21.06 | 1.77 | 417.49 |
| silesia/ooffice | 6152192 | zlib-ng | 6.99 | 12.04 | 1.72 | 140.33 |
| silesia/ooffice | 6152192 | libdeflate | 4.96 | 10.45 | 2.11 | 125.31 |
| silesia/ooffice | 6152192 | Wuffs | 8.86 | 17.54 | 1.98 | 220.07 |
| silesia/ooffice | 6152192 | stdx | 5.26 | 8.55 | 1.62 | 151.28 |
| silesia/osdb | 10085684 | zlib | 7.58 | 16.59 | 2.19 | 183.68 |
| silesia/osdb | 10085684 | zlib-ng | 4.39 | 8.38 | 1.91 | 53.04 |
| silesia/osdb | 10085684 | libdeflate | 2.94 | 6.91 | 2.35 | 29.81 |
| silesia/osdb | 10085684 | Wuffs | 5.81 | 13.61 | 2.34 | 78.43 |
| silesia/osdb | 10085684 | stdx | 2.96 | 5.65 | 1.91 | 41.27 |
| silesia/reymont | 6627202 | zlib | 7.52 | 15.89 | 2.11 | 261.95 |
| silesia/reymont | 6627202 | zlib-ng | 3.80 | 7.72 | 2.03 | 60.67 |
| silesia/reymont | 6627202 | libdeflate | 2.69 | 6.91 | 2.57 | 51.30 |
| silesia/reymont | 6627202 | Wuffs | 4.91 | 11.40 | 2.32 | 112.99 |
| silesia/reymont | 6627202 | stdx | 2.48 | 5.11 | 2.06 | 64.13 |
| silesia/samba | 21606400 | zlib | 6.22 | 14.13 | 2.27 | 174.88 |
| silesia/samba | 21606400 | zlib-ng | 3.42 | 6.47 | 1.89 | 56.13 |
| silesia/samba | 21606400 | libdeflate | 2.41 | 5.58 | 2.31 | 42.97 |
| silesia/samba | 21606400 | Wuffs | 4.40 | 10.39 | 2.36 | 79.56 |
| silesia/samba | 21606400 | stdx | 2.54 | 4.46 | 1.76 | 56.48 |
| silesia/sao | 7251944 | zlib | 10.56 | 23.54 | 2.23 | 203.90 |
| silesia/sao | 7251944 | zlib-ng | 7.93 | 14.83 | 1.87 | 79.62 |
| silesia/sao | 7251944 | libdeflate | 5.80 | 12.73 | 2.19 | 79.15 |
| silesia/sao | 7251944 | Wuffs | 8.91 | 21.26 | 2.39 | 86.44 |
| silesia/sao | 7251944 | stdx | 5.76 | 10.32 | 1.79 | 89.31 |
| silesia/webster | 41458703 | zlib | 7.88 | 16.16 | 2.05 | 283.57 |
| silesia/webster | 41458703 | zlib-ng | 4.27 | 8.04 | 1.88 | 84.88 |
| silesia/webster | 41458703 | libdeflate | 2.98 | 7.17 | 2.40 | 68.41 |
| silesia/webster | 41458703 | Wuffs | 5.16 | 11.67 | 2.26 | 122.27 |
| silesia/webster | 41458703 | stdx | 2.90 | 5.56 | 1.92 | 87.11 |
| silesia/x-ray | 8474240 | zlib | 12.94 | 27.21 | 2.10 | 329.59 |
| silesia/x-ray | 8474240 | zlib-ng | 9.11 | 17.39 | 1.91 | 124.08 |
| silesia/x-ray | 8474240 | libdeflate | 6.59 | 15.26 | 2.31 | 124.34 |
| silesia/x-ray | 8474240 | Wuffs | 10.87 | 23.52 | 2.16 | 190.79 |
| silesia/x-ray | 8474240 | stdx | 6.28 | 11.49 | 1.83 | 139.40 |
| silesia/xml | 5345280 | zlib | 4.31 | 11.16 | 2.59 | 118.36 |
| silesia/xml | 5345280 | zlib-ng | 2.02 | 3.88 | 1.93 | 42.85 |
| silesia/xml | 5345280 | libdeflate | 1.37 | 3.33 | 2.44 | 31.94 |
| silesia/xml | 5345280 | Wuffs | 2.89 | 7.22 | 2.50 | 58.95 |
| silesia/xml | 5345280 | stdx | 1.42 | 2.65 | 1.87 | 41.98 |
| canterbury/alice29.txt | 152089 | zlib | 8.42 | 18.35 | 2.18 | 294.36 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.61 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.18 | 8.96 | 2.82 | 54.94 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.38 | 13.40 | 2.49 | 98.62 |
| canterbury/alice29.txt | 152089 | stdx | 2.73 | 6.99 | 2.56 | 64.10 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.02 | 19.42 | 2.15 | 313.74 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 72.95 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.59 | 9.82 | 2.73 | 67.41 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.76 | 14.40 | 2.50 | 100.16 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.07 | 7.52 | 2.45 | 77.94 |
| canterbury/cp.html | 24603 | zlib | 7.01 | 17.33 | 2.47 | 167.30 |
| canterbury/cp.html | 24603 | zlib-ng | 4.19 | 9.50 | 2.27 | 37.69 |
| canterbury/cp.html | 24603 | libdeflate | 2.77 | 7.95 | 2.87 | 7.15 |
| canterbury/cp.html | 24603 | Wuffs | 5.27 | 13.91 | 2.64 | 64.67 |
| canterbury/cp.html | 24603 | stdx | 2.65 | 7.19 | 2.71 | 13.52 |
| canterbury/fields.c | 11150 | zlib | 5.28 | 17.73 | 3.36 | 36.23 |
| canterbury/fields.c | 11150 | zlib-ng | 3.89 | 10.20 | 2.62 | 13.03 |
| canterbury/fields.c | 11150 | libdeflate | 2.88 | 8.32 | 2.89 | 1.79 |
| canterbury/fields.c | 11150 | Wuffs | 4.52 | 14.54 | 3.22 | 7.74 |
| canterbury/fields.c | 11150 | stdx | 2.51 | 7.64 | 3.05 | 5.50 |
| canterbury/grammar.lsp | 3721 | zlib | 6.92 | 24.26 | 3.50 | 7.36 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.82 | 17.48 | 3.00 | 7.46 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.48 | 12.05 | 2.69 | 0.12 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.66 | 21.86 | 3.28 | 3.72 |
| canterbury/grammar.lsp | 3721 | stdx | 3.85 | 12.18 | 3.17 | 1.01 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.59 | 15.27 | 3.33 | 48.36 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.66 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.04 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.86 | 11.59 | 3.00 | 14.86 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.74 | 4.66 | 2.67 | 16.67 |
| canterbury/lcet10.txt | 426754 | zlib | 8.22 | 17.78 | 2.16 | 291.88 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.17 | 61.29 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.02 | 8.48 | 2.81 | 54.77 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.22 | 12.88 | 2.47 | 101.05 |
| canterbury/lcet10.txt | 426754 | stdx | 2.59 | 6.42 | 2.48 | 66.76 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.21 | 19.86 | 2.16 | 321.15 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.31 | 11.19 | 2.11 | 80.05 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.70 | 77.72 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.83 | 14.61 | 2.51 | 99.77 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 7.63 | 2.41 | 85.35 |
| canterbury/ptt5 | 513216 | zlib | 5.05 | 10.71 | 2.12 | 103.06 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.76 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.09 | 38.21 |
| canterbury/ptt5 | 513216 | Wuffs | 3.00 | 7.13 | 2.38 | 57.38 |
| canterbury/ptt5 | 513216 | stdx | 1.45 | 2.55 | 1.75 | 49.78 |
| canterbury/sum | 38240 | zlib | 8.03 | 18.12 | 2.26 | 225.33 |
| canterbury/sum | 38240 | zlib-ng | 4.62 | 10.02 | 2.17 | 55.12 |
| canterbury/sum | 38240 | libdeflate | 3.25 | 8.34 | 2.56 | 28.35 |
| canterbury/sum | 38240 | Wuffs | 5.80 | 14.47 | 2.49 | 81.75 |
| canterbury/sum | 38240 | stdx | 3.04 | 7.73 | 2.55 | 29.31 |
| canterbury/xargs.1 | 4227 | zlib | 7.44 | 25.22 | 3.39 | 14.75 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.38 | 17.97 | 2.81 | 10.17 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.84 | 13.27 | 2.74 | 0.42 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.17 | 22.63 | 3.16 | 8.49 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 12.86 | 3.04 | 1.93 |
| canterbury-large/E.coli | 4638690 | zlib | 6.79 | 17.84 | 2.63 | 177.69 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.30 | 9.68 | 2.25 | 47.43 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.05 | 8.86 | 2.90 | 48.37 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.68 | 12.73 | 2.72 | 61.55 |
| canterbury-large/E.coli | 4638690 | stdx | 2.56 | 6.72 | 2.62 | 53.87 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.56 | 16.46 | 2.18 | 266.15 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.84 | 8.26 | 2.15 | 54.03 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.64 | 7.45 | 2.82 | 45.83 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.82 | 11.73 | 2.43 | 100.69 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.30 | 5.57 | 2.42 | 55.94 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.78 | 15.84 | 2.04 | 282.06 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.21 | 7.78 | 1.85 | 91.48 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 74.99 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.20 | 11.48 | 2.21 | 128.35 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.76 | 5.40 | 1.96 | 90.68 |
| http/html-1kx1024 | 1048576 | zlib | 16.69 | 35.58 | 2.13 | 351.24 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.69 | 28.43 | 2.24 | 218.44 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.85 | 20.05 | 1.85 | 155.35 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.38 | 38.07 | 2.47 | 266.19 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 137.52 |
| http/html-16kx64 | 1048576 | zlib | 6.73 | 14.77 | 2.20 | 221.30 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.44 |
| http/html-16kx64 | 1048576 | libdeflate | 2.66 | 6.04 | 2.27 | 60.49 |
| http/html-16kx64 | 1048576 | Wuffs | 4.92 | 11.56 | 2.35 | 115.06 |
| http/html-16kx64 | 1048576 | stdx | 2.53 | 5.56 | 2.20 | 59.84 |
| http/html-1m | 1048576 | zlib | 5.32 | 12.53 | 2.36 | 175.96 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 60.08 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.58 | 37.67 |
| http/html-1m | 1048576 | Wuffs | 3.61 | 8.48 | 2.35 | 88.04 |
| http/html-1m | 1048576 | stdx | 1.65 | 3.46 | 2.10 | 52.69 |
| http/json-1kx1024 | 1048576 | zlib | 10.61 | 23.92 | 2.25 | 192.79 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.26 | 131.07 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.13 | 16.72 | 1.83 | 92.30 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.15 | 34.78 | 2.86 | 146.37 |
| http/json-1kx1024 | 1048576 | stdx | 5.03 | 13.12 | 2.61 | 80.99 |
| http/json-16kx64 | 1048576 | zlib | 4.58 | 12.51 | 2.73 | 103.30 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.62 | 5.50 | 2.10 | 50.81 |
| http/json-16kx64 | 1048576 | libdeflate | 1.95 | 4.24 | 2.18 | 40.65 |
| http/json-16kx64 | 1048576 | Wuffs | 3.52 | 9.43 | 2.68 | 57.96 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.26 | 39.38 |
| http/json-1m | 1048576 | zlib | 3.85 | 11.20 | 2.91 | 83.21 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.02 | 37.46 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.70 |
| http/json-1m | 1048576 | Wuffs | 2.73 | 7.37 | 2.70 | 43.56 |
| http/json-1m | 1048576 | stdx | 1.33 | 2.67 | 2.01 | 40.31 |
| http/js-1kx1024 | 1048576 | zlib | 18.25 | 38.46 | 2.11 | 410.70 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.79 | 31.25 | 2.27 | 238.77 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.54 | 21.58 | 1.87 | 179.03 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.58 | 40.70 | 2.45 | 301.07 |
| http/js-1kx1024 | 1048576 | stdx | 9.28 | 22.85 | 2.46 | 159.34 |
| http/js-16kx64 | 1048576 | zlib | 7.67 | 16.08 | 2.10 | 263.50 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.97 | 92.07 |
| http/js-16kx64 | 1048576 | libdeflate | 3.08 | 7.01 | 2.28 | 72.20 |
| http/js-16kx64 | 1048576 | Wuffs | 5.51 | 12.75 | 2.32 | 129.09 |
| http/js-16kx64 | 1048576 | stdx | 3.01 | 6.54 | 2.17 | 72.52 |
| http/js-1m | 1048576 | zlib | 5.85 | 13.31 | 2.28 | 199.75 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.96 | 60.13 |
| http/js-1m | 1048576 | libdeflate | 1.93 | 4.98 | 2.58 | 42.30 |
| http/js-1m | 1048576 | Wuffs | 3.90 | 9.14 | 2.34 | 93.82 |
| http/js-1m | 1048576 | stdx | 1.81 | 3.89 | 2.15 | 55.52 |
| http/css-1kx1024 | 1048576 | zlib | 14.04 | 30.36 | 2.16 | 280.70 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.25 | 23.04 | 2.25 | 170.81 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.45 | 17.37 | 1.84 | 121.40 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.79 | 32.49 | 2.54 | 211.26 |
| http/css-1kx1024 | 1048576 | stdx | 6.67 | 17.64 | 2.64 | 100.57 |
| http/css-16kx64 | 1048576 | zlib | 5.31 | 13.04 | 2.45 | 153.16 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.77 | 6.07 | 2.19 | 49.98 |
| http/css-16kx64 | 1048576 | libdeflate | 1.90 | 4.69 | 2.46 | 29.75 |
| http/css-16kx64 | 1048576 | Wuffs | 3.78 | 10.01 | 2.65 | 69.57 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.54 | 28.22 |
| http/css-1m | 1048576 | zlib | 3.98 | 10.97 | 2.75 | 107.95 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.22 | 28.99 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.97 | 12.88 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.77 | 43.46 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.52 | 21.57 |
| shuffled/dickens-1m | 1048576 | zlib | 13.32 | 25.88 | 1.94 | 373.85 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.74 | 16.72 | 1.72 | 196.20 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.04 | 14.95 | 2.12 | 194.13 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.50 | 22.08 | 2.10 | 200.96 |
| shuffled/dickens-1m | 1048576 | stdx | 7.09 | 11.89 | 1.68 | 206.07 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.61 | 14.05 | 3.89 | 3.38 |
| silesia/dickens | 10192446 | stdx | 3.76 | 12.47 | 3.31 | 3.60 |
| silesia/mozilla | 51220480 | libzstd | 2.87 | 9.68 | 3.37 | 30.13 |
| silesia/mozilla | 51220480 | stdx | 2.91 | 9.68 | 3.32 | 15.69 |
| silesia/mr | 9970564 | libzstd | 3.09 | 11.99 | 3.88 | 6.15 |
| silesia/mr | 9970564 | stdx | 3.18 | 10.83 | 3.40 | 5.24 |
| silesia/nci | 33553445 | libzstd | 1.72 | 4.88 | 2.83 | 24.84 |
| silesia/nci | 33553445 | stdx | 1.89 | 4.63 | 2.46 | 13.56 |
| silesia/ooffice | 6152192 | libzstd | 3.45 | 12.19 | 3.53 | 31.00 |
| silesia/ooffice | 6152192 | stdx | 3.48 | 12.40 | 3.57 | 12.40 |
| silesia/osdb | 10085684 | libzstd | 2.43 | 8.45 | 3.48 | 14.91 |
| silesia/osdb | 10085684 | stdx | 2.50 | 8.11 | 3.24 | 15.42 |
| silesia/reymont | 6627202 | libzstd | 3.24 | 11.62 | 3.58 | 11.54 |
| silesia/reymont | 6627202 | stdx | 3.44 | 10.36 | 3.01 | 12.76 |
| silesia/samba | 21606400 | libzstd | 2.17 | 7.41 | 3.42 | 18.63 |
| silesia/samba | 21606400 | stdx | 2.30 | 6.83 | 2.97 | 17.66 |
| silesia/sao | 7251944 | libzstd | 3.85 | 12.72 | 3.30 | 26.61 |
| silesia/sao | 7251944 | stdx | 3.65 | 12.58 | 3.45 | 6.23 |
| silesia/webster | 41458703 | libzstd | 3.32 | 11.24 | 3.38 | 16.11 |
| silesia/webster | 41458703 | stdx | 3.53 | 10.05 | 2.85 | 17.29 |
| silesia/x-ray | 8474240 | libzstd | 3.93 | 14.94 | 3.80 | 18.94 |
| silesia/x-ray | 8474240 | stdx | 3.71 | 13.23 | 3.56 | 8.50 |
| silesia/xml | 5345280 | libzstd | 1.56 | 5.57 | 3.56 | 23.27 |
| silesia/xml | 5345280 | stdx | 1.54 | 5.16 | 3.34 | 17.06 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.89 | 4.06 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.43 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.96 | 14.26 | 4.82 | 3.23 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.29 | 0.22 |
| canterbury/cp.html | 24603 | libzstd | 2.63 | 10.74 | 4.08 | 7.63 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.11 | 0.17 |
| canterbury/fields.c | 11150 | libzstd | 3.12 | 13.62 | 4.37 | 8.97 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.23 | 0.20 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.19 | 16.94 | 4.05 | 4.99 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.54 | 4.01 | 0.18 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.53 | 11.40 | 4.51 | 7.80 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.23 | 0.88 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.70 | 12.89 | 4.78 | 5.13 |
| canterbury/lcet10.txt | 426754 | stdx | 2.73 | 11.52 | 4.22 | 4.34 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.10 | 15.16 | 4.89 | 1.54 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.26 | 0.99 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.52 | 3.12 | 25.01 |
| canterbury/ptt5 | 513216 | stdx | 1.34 | 4.46 | 3.32 | 12.94 |
| canterbury/sum | 38240 | libzstd | 2.62 | 10.58 | 4.03 | 10.56 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.31 |
| canterbury/xargs.1 | 4227 | libzstd | 4.25 | 17.41 | 4.10 | 9.29 |
| canterbury/xargs.1 | 4227 | stdx | 4.25 | 17.17 | 4.05 | 0.46 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.01 | 13.64 | 4.53 | 2.11 |
| canterbury-large/E.coli | 4638690 | stdx | 3.15 | 12.04 | 3.83 | 2.88 |
| canterbury-large/bible.txt | 4047392 | libzstd | 3.04 | 12.00 | 3.94 | 8.27 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.15 | 10.64 | 3.38 | 9.25 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.62 | 9.60 | 3.66 | 19.75 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 8.64 | 3.18 | 21.03 |
| http/html-1kx1024 | 1048576 | libzstd | 7.25 | 21.63 | 2.98 | 63.16 |
| http/html-1kx1024 | 1048576 | stdx | 7.48 | 22.46 | 3.00 | 76.79 |
| http/html-16kx64 | 1048576 | libzstd | 2.67 | 10.15 | 3.81 | 28.64 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.61 | 30.58 |
| http/html-1m | 1048576 | libzstd | 2.01 | 7.88 | 3.92 | 23.87 |
| http/html-1m | 1048576 | stdx | 2.01 | 7.12 | 3.53 | 24.14 |
| http/json-1kx1024 | 1048576 | libzstd | 6.27 | 17.39 | 2.77 | 49.74 |
| http/json-1kx1024 | 1048576 | stdx | 6.23 | 17.86 | 2.87 | 53.77 |
| http/json-16kx64 | 1048576 | libzstd | 2.06 | 7.26 | 3.53 | 28.34 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.58 | 19.72 |
| http/json-1m | 1048576 | libzstd | 1.75 | 6.08 | 3.48 | 28.09 |
| http/json-1m | 1048576 | stdx | 1.64 | 5.91 | 3.61 | 14.29 |
| http/js-1kx1024 | 1048576 | libzstd | 8.33 | 26.35 | 3.16 | 74.00 |
| http/js-1kx1024 | 1048576 | stdx | 9.06 | 27.60 | 3.05 | 113.50 |
| http/js-16kx64 | 1048576 | libzstd | 2.92 | 11.72 | 4.01 | 24.36 |
| http/js-16kx64 | 1048576 | stdx | 2.95 | 11.06 | 3.75 | 25.30 |
| http/js-1m | 1048576 | libzstd | 2.03 | 8.19 | 4.04 | 20.22 |
| http/js-1m | 1048576 | stdx | 2.07 | 7.48 | 3.61 | 21.35 |
| http/css-1kx1024 | 1048576 | libzstd | 6.89 | 19.69 | 2.86 | 53.63 |
| http/css-1kx1024 | 1048576 | stdx | 6.85 | 19.96 | 2.91 | 63.24 |
| http/css-16kx64 | 1048576 | libzstd | 2.25 | 8.70 | 3.87 | 23.18 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.12 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.58 | 3.84 | 5.48 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.50 | 3.98 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.78 | 9.40 | 3.39 | 28.41 |
| shuffled/dickens-1m | 1048576 | stdx | 2.74 | 9.19 | 3.35 | 12.31 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.51 | 16.93 | 2.25 | 100.12 |
| silesia/dickens | 1048576 | stdx | 5.12 | 12.38 | 2.42 | 54.67 |
| silesia/mozilla | 1048576 | Google | 13.58 | 28.31 | 2.08 | 47.80 |
| silesia/mozilla | 1048576 | stdx | 8.37 | 15.02 | 1.79 | 47.33 |
| silesia/mr | 1048576 | Google | 8.94 | 20.21 | 2.26 | 103.37 |
| silesia/mr | 1048576 | stdx | 5.80 | 13.25 | 2.29 | 88.43 |
| silesia/nci | 1048576 | Google | 2.55 | 5.70 | 2.24 | 52.13 |
| silesia/nci | 1048576 | stdx | 1.92 | 3.95 | 2.05 | 54.56 |
| silesia/ooffice | 1048576 | Google | 14.19 | 29.27 | 2.06 | 289.75 |
| silesia/ooffice | 1048576 | stdx | 10.94 | 20.33 | 1.86 | 323.55 |
| silesia/osdb | 1048576 | Google | 8.21 | 17.48 | 2.13 | 96.85 |
| silesia/osdb | 1048576 | stdx | 5.16 | 10.57 | 2.05 | 91.75 |
| silesia/reymont | 1048576 | Google | 5.39 | 12.62 | 2.34 | 82.94 |
| silesia/reymont | 1048576 | stdx | 3.76 | 9.25 | 2.46 | 47.43 |
| silesia/samba | 1048576 | Google | 7.63 | 16.30 | 2.14 | 95.51 |
| silesia/samba | 1048576 | stdx | 5.07 | 10.71 | 2.11 | 66.43 |
| silesia/sao | 1048576 | Google | 16.98 | 37.18 | 2.19 | 167.73 |
| silesia/sao | 1048576 | stdx | 10.50 | 22.65 | 2.16 | 141.03 |
| silesia/webster | 1048576 | Google | 6.51 | 14.00 | 2.15 | 113.68 |
| silesia/webster | 1048576 | stdx | 4.40 | 9.98 | 2.27 | 69.07 |
| silesia/x-ray | 1048576 | Google | 19.34 | 38.56 | 1.99 | 235.75 |
| silesia/x-ray | 1048576 | stdx | 14.95 | 30.18 | 2.02 | 234.35 |
| silesia/xml | 1048576 | Google | 3.45 | 7.61 | 2.21 | 65.51 |
| silesia/xml | 1048576 | stdx | 2.40 | 5.40 | 2.25 | 46.92 |
| canterbury/alice29.txt | 152089 | Google | 8.85 | 20.55 | 2.32 | 133.73 |
| canterbury/alice29.txt | 152089 | stdx | 6.11 | 15.33 | 2.51 | 82.90 |
| canterbury/asyoulik.txt | 125179 | Google | 10.34 | 23.71 | 2.29 | 166.19 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.01 | 17.43 | 2.49 | 101.21 |
| canterbury/cp.html | 24603 | Google | 9.04 | 22.20 | 2.46 | 113.97 |
| canterbury/cp.html | 24603 | stdx | 5.77 | 17.15 | 2.97 | 35.76 |
| canterbury/fields.c | 11150 | Google | 7.14 | 21.16 | 2.96 | 31.22 |
| canterbury/fields.c | 11150 | stdx | 4.90 | 17.08 | 3.49 | 2.72 |
| canterbury/grammar.lsp | 3721 | Google | 9.82 | 30.16 | 3.07 | 8.03 |
| canterbury/grammar.lsp | 3721 | stdx | 7.11 | 25.04 | 3.52 | 0.38 |
| canterbury/kennedy.xls | 1029744 | Google | 5.43 | 17.05 | 3.14 | 37.55 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.81 | 12.94 | 3.40 | 33.99 |
| canterbury/lcet10.txt | 426754 | Google | 7.68 | 17.36 | 2.26 | 124.99 |
| canterbury/lcet10.txt | 426754 | stdx | 5.21 | 12.96 | 2.49 | 66.84 |
| canterbury/plrabn12.txt | 481861 | Google | 9.04 | 20.82 | 2.30 | 132.30 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.15 | 15.04 | 2.44 | 86.95 |
| canterbury/ptt5 | 513216 | Google | 4.28 | 10.41 | 2.43 | 62.53 |
| canterbury/ptt5 | 513216 | stdx | 2.36 | 4.89 | 2.07 | 64.78 |
| canterbury/sum | 38240 | Google | 10.84 | 26.44 | 2.44 | 159.10 |
| canterbury/sum | 38240 | stdx | 8.22 | 21.11 | 2.57 | 147.49 |
| canterbury/xargs.1 | 4227 | Google | 10.95 | 34.81 | 3.18 | 11.25 |
| canterbury/xargs.1 | 4227 | stdx | 8.46 | 30.44 | 3.60 | 6.04 |
| canterbury-large/E.coli | 1048576 | Google | 8.17 | 19.55 | 2.39 | 1.49 |
| canterbury-large/E.coli | 1048576 | stdx | 6.72 | 13.48 | 2.01 | 1.36 |
| canterbury-large/bible.txt | 1048576 | Google | 5.29 | 12.28 | 2.32 | 80.98 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.57 | 8.93 | 2.50 | 39.92 |
| canterbury-large/world192.txt | 1048576 | Google | 6.14 | 12.84 | 2.09 | 114.70 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.48 | 9.38 | 2.09 | 77.56 |
| http/html-1kx1024 | 1048576 | Google | 18.05 | 41.93 | 2.32 | 387.45 |
| http/html-1kx1024 | 1048576 | stdx | 15.28 | 37.56 | 2.46 | 360.76 |
| http/html-16kx64 | 1048576 | Google | 6.74 | 14.85 | 2.20 | 149.02 |
| http/html-16kx64 | 1048576 | stdx | 5.14 | 12.15 | 2.36 | 114.50 |
| http/html-1m | 1048576 | Google | 4.05 | 8.94 | 2.21 | 83.20 |
| http/html-1m | 1048576 | stdx | 2.85 | 6.52 | 2.29 | 54.81 |
| http/json-1kx1024 | 1048576 | Google | 14.50 | 36.64 | 2.53 | 241.48 |
| http/json-1kx1024 | 1048576 | stdx | 12.97 | 33.63 | 2.59 | 276.41 |
| http/json-16kx64 | 1048576 | Google | 4.43 | 11.43 | 2.58 | 82.88 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.72 |
| http/json-1m | 1048576 | Google | 3.41 | 8.65 | 2.53 | 60.03 |
| http/json-1m | 1048576 | stdx | 2.45 | 5.99 | 2.45 | 57.19 |
| http/js-1kx1024 | 1048576 | Google | 19.96 | 46.20 | 2.32 | 425.51 |
| http/js-1kx1024 | 1048576 | stdx | 16.38 | 39.90 | 2.44 | 379.40 |
| http/js-16kx64 | 1048576 | Google | 8.02 | 17.73 | 2.21 | 166.15 |
| http/js-16kx64 | 1048576 | stdx | 6.04 | 14.36 | 2.38 | 126.06 |
| http/js-1m | 1048576 | Google | 4.36 | 9.54 | 2.19 | 83.14 |
| http/js-1m | 1048576 | stdx | 3.17 | 7.25 | 2.28 | 55.38 |
| http/css-1kx1024 | 1048576 | Google | 15.54 | 37.36 | 2.40 | 294.59 |
| http/css-1kx1024 | 1048576 | stdx | 13.77 | 34.70 | 2.52 | 301.44 |
| http/css-16kx64 | 1048576 | Google | 4.97 | 11.76 | 2.37 | 102.80 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.44 |
| http/css-1m | 1048576 | Google | 2.44 | 9.42 | 3.86 | 16.97 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.49 | 11.77 |
| shuffled/dickens-1m | 1048576 | Google | 10.14 | 20.65 | 2.04 | 105.01 |
| shuffled/dickens-1m | 1048576 | stdx | 8.83 | 14.53 | 1.65 | 122.22 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.32 | 36.91 | 2.41 | 410.64 |
| silesia/dickens | 10192446 | 1 | stdx | 16.52 | 38.17 | 2.31 | 357.64 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.10 | 87.63 | 1.68 | 694.40 |
| silesia/dickens | 10192446 | 6 | stdx | 49.70 | 84.26 | 1.70 | 1442.58 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.85 | 160.47 | 1.43 | 927.77 |
| silesia/dickens | 10192446 | 9 | stdx | 85.19 | 191.81 | 2.25 | 1720.50 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.16 | 32.62 | 2.30 | 438.48 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.47 | 30.24 | 2.24 | 295.94 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.94 | 70.83 | 2.15 | 580.77 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.66 | 69.96 | 2.21 | 735.89 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.67 | 221.49 | 1.73 | 766.76 |
| silesia/mozilla | 51220480 | 9 | stdx | 49.03 | 126.12 | 2.57 | 791.39 |
| silesia/mr | 9970564 | 1 | libdeflate | 12.00 | 35.02 | 2.92 | 229.25 |
| silesia/mr | 9970564 | 1 | stdx | 12.73 | 34.08 | 2.68 | 187.43 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.33 | 80.54 | 2.10 | 438.93 |
| silesia/mr | 9970564 | 6 | stdx | 39.80 | 83.19 | 2.09 | 977.74 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.91 | 165.48 | 1.69 | 749.07 |
| silesia/mr | 9970564 | 9 | stdx | 87.23 | 206.31 | 2.36 | 1329.20 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.28 | 18.42 | 2.93 | 115.75 |
| silesia/nci | 33553445 | 1 | stdx | 5.05 | 10.88 | 2.16 | 98.25 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.99 | 34.84 | 2.05 | 225.30 |
| silesia/nci | 33553445 | 6 | stdx | 14.48 | 29.54 | 2.04 | 395.11 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.39 | 105.28 | 1.69 | 499.31 |
| silesia/nci | 33553445 | 9 | stdx | 33.24 | 80.64 | 2.43 | 647.71 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 20.00 | 39.15 | 1.96 | 754.00 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.87 | 39.08 | 2.19 | 431.17 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 41.02 | 79.10 | 1.93 | 952.86 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.78 | 87.83 | 2.10 | 1012.60 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.60 | 127.63 | 1.71 | 1129.51 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.41 | 129.17 | 2.46 | 938.00 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.93 | 30.15 | 2.33 | 352.74 |
| silesia/osdb | 10085684 | 1 | stdx | 13.07 | 27.87 | 2.13 | 295.46 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.38 | 55.67 | 1.96 | 493.35 |
| silesia/osdb | 10085684 | 6 | stdx | 27.16 | 57.40 | 2.11 | 566.86 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.99 | 64.15 | 1.89 | 551.25 |
| silesia/osdb | 10085684 | 9 | stdx | 35.76 | 87.23 | 2.44 | 687.50 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.68 | 32.88 | 2.59 | 311.94 |
| silesia/reymont | 6627202 | 1 | stdx | 13.65 | 33.24 | 2.44 | 271.63 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.32 | 86.58 | 1.79 | 521.87 |
| silesia/reymont | 6627202 | 6 | stdx | 45.19 | 76.82 | 1.70 | 1416.41 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.19 | 276.14 | 1.39 | 835.74 |
| silesia/reymont | 6627202 | 9 | stdx | 87.42 | 189.98 | 2.17 | 1606.58 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.51 | 26.53 | 2.52 | 272.75 |
| silesia/samba | 21606400 | 1 | stdx | 10.04 | 22.23 | 2.21 | 221.35 |
| silesia/samba | 21606400 | 6 | libdeflate | 29.06 | 58.79 | 2.02 | 385.73 |
| silesia/samba | 21606400 | 6 | stdx | 24.22 | 49.84 | 2.06 | 622.08 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.27 | 141.44 | 1.68 | 504.66 |
| silesia/samba | 21606400 | 9 | stdx | 41.78 | 102.63 | 2.46 | 731.21 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.84 | 47.87 | 2.19 | 688.99 |
| silesia/sao | 7251944 | 1 | stdx | 19.33 | 49.92 | 2.58 | 346.80 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.19 | 96.89 | 1.89 | 963.87 |
| silesia/sao | 7251944 | 6 | stdx | 47.28 | 105.66 | 2.23 | 855.76 |
| silesia/sao | 7251944 | 9 | libdeflate | 71.02 | 120.26 | 1.69 | 1105.72 |
| silesia/sao | 7251944 | 9 | stdx | 55.51 | 138.16 | 2.49 | 853.00 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.15 | 30.45 | 2.32 | 385.97 |
| silesia/webster | 41458703 | 1 | stdx | 13.97 | 29.09 | 2.08 | 340.62 |
| silesia/webster | 41458703 | 6 | libdeflate | 37.06 | 66.02 | 1.78 | 570.93 |
| silesia/webster | 41458703 | 6 | stdx | 35.18 | 60.88 | 1.73 | 1102.67 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.56 | 138.85 | 1.47 | 752.70 |
| silesia/webster | 41458703 | 9 | stdx | 60.92 | 135.96 | 2.23 | 1290.40 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.79 | 49.67 | 2.09 | 790.31 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.69 | 50.82 | 2.87 | 261.56 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.91 | 82.77 | 2.52 | 851.69 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.95 | 98.12 | 2.89 | 538.29 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.56 | 91.03 | 2.42 | 1029.24 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.85 | 122.06 | 2.99 | 467.46 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.92 | 21.59 | 2.73 | 176.45 |
| silesia/xml | 5345280 | 1 | stdx | 7.22 | 15.66 | 2.17 | 155.81 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.29 | 40.51 | 1.90 | 264.58 |
| silesia/xml | 5345280 | 6 | stdx | 17.82 | 34.32 | 1.93 | 497.64 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.76 | 89.17 | 1.52 | 370.69 |
| silesia/xml | 5345280 | 9 | stdx | 31.34 | 72.83 | 2.32 | 599.55 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.32 | 35.61 | 2.49 | 381.50 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.06 | 36.13 | 2.40 | 337.11 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.73 | 82.29 | 1.76 | 641.56 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.75 | 77.43 | 1.77 | 1320.33 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.42 | 159.21 | 1.48 | 850.40 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 72.93 | 167.73 | 2.30 | 1512.32 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.18 | 37.20 | 2.45 | 416.12 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.79 | 37.43 | 2.37 | 359.92 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.29 | 85.43 | 1.77 | 717.86 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 45.92 | 81.93 | 1.78 | 1372.80 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.81 | 136.15 | 1.53 | 941.61 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 75.85 | 175.98 | 2.32 | 1611.09 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.73 | 32.02 | 2.73 | 283.49 |
| canterbury/cp.html | 24603 | 1 | stdx | 11.02 | 27.13 | 2.46 | 248.27 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 27.00 | 62.33 | 2.31 | 486.32 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.70 | 57.06 | 2.41 | 620.31 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 47.23 | 91.97 | 1.95 | 600.27 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.34 | 88.89 | 2.84 | 639.40 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.71 | 35.92 | 3.70 | 73.87 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.10 | 30.06 | 3.71 | 23.66 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.56 | 69.37 | 2.82 | 253.55 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.80 | 57.62 | 2.77 | 423.91 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.48 | 100.81 | 2.27 | 426.51 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.78 | 92.66 | 3.22 | 449.93 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.01 | 51.51 | 3.96 | 12.59 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.89 | 39.03 | 3.95 | 1.13 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.86 | 87.06 | 3.65 | 33.02 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.29 | 70.82 | 4.10 | 20.20 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 31.25 | 102.89 | 3.29 | 66.25 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.78 | 99.32 | 4.18 | 58.23 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.38 | 27.18 | 3.68 | 65.81 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.04 | 22.58 | 3.21 | 62.74 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 28.00 | 73.85 | 2.64 | 96.70 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.56 | 62.00 | 3.17 | 138.85 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.18 | 664.23 | 1.83 | 163.27 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 38.02 | 130.89 | 3.44 | 219.43 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.80 | 33.99 | 2.46 | 370.20 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.48 | 33.93 | 2.34 | 329.93 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.13 | 78.22 | 1.73 | 608.58 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.68 | 73.43 | 1.76 | 1222.10 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.80 | 136.94 | 1.49 | 804.44 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 70.97 | 162.25 | 2.29 | 1448.88 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.80 | 38.62 | 2.44 | 425.74 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.76 | 40.25 | 2.40 | 369.69 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.11 | 91.90 | 1.70 | 752.53 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.78 | 88.90 | 1.72 | 1512.05 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.81 | 166.26 | 1.42 | 1000.02 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 89.02 | 201.33 | 2.26 | 1809.90 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.43 | 18.61 | 2.89 | 141.03 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.99 | 11.03 | 2.21 | 123.53 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.26 | 36.17 | 2.54 | 219.85 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.32 | 29.58 | 2.40 | 309.38 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.54 | 120.86 | 2.00 | 373.78 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.34 | 130.09 | 3.00 | 640.31 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.84 | 33.49 | 2.61 | 339.34 |
| canterbury/sum | 38240 | 1 | stdx | 12.55 | 29.36 | 2.34 | 299.47 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.67 | 69.87 | 2.44 | 503.11 |
| canterbury/sum | 38240 | 6 | stdx | 26.75 | 65.74 | 2.46 | 665.86 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.25 | 181.91 | 1.93 | 609.98 |
| canterbury/sum | 38240 | 9 | stdx | 39.49 | 112.34 | 2.84 | 661.02 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.26 | 53.06 | 4.00 | 20.14 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.67 | 43.11 | 4.04 | 2.60 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.97 | 87.70 | 3.82 | 71.71 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 18.00 | 74.37 | 4.13 | 40.06 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 25.74 | 94.34 | 3.66 | 139.26 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.98 | 106.97 | 3.96 | 147.94 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.10 | 40.47 | 3.34 | 164.20 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.88 | 42.29 | 3.28 | 101.10 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.43 | 395.99 | 2.16 | 260.31 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 123.09 | 374.13 | 3.04 | 1899.70 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 818.39 | 1063.49 | 1.30 | 1322.22 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 228.99 | 755.68 | 3.30 | 2439.41 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.63 | 32.38 | 2.56 | 312.10 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.59 | 32.23 | 2.37 | 282.13 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.17 | 80.12 | 1.74 | 525.02 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.18 | 72.39 | 1.72 | 1252.91 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.65 | 200.28 | 1.41 | 740.95 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.37 | 170.21 | 2.23 | 1439.35 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.37 | 29.72 | 2.22 | 412.36 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.48 | 28.55 | 1.97 | 379.64 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.18 | 60.25 | 1.82 | 557.96 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.17 | 56.81 | 1.77 | 981.52 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.67 | 119.11 | 1.48 | 686.92 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 52.17 | 117.95 | 2.26 | 1147.18 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.49 | 103.92 | 2.93 | 453.56 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.64 | 58.69 | 2.71 | 364.58 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.29 | 138.34 | 2.99 | 560.47 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 32.37 | 94.36 | 2.91 | 529.08 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.90 | 142.44 | 2.97 | 588.89 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 36.40 | 112.18 | 3.08 | 537.09 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.45 | 27.96 | 2.68 | 266.98 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.09 | 20.25 | 2.23 | 234.34 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.55 | 52.09 | 2.31 | 404.82 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.98 | 42.87 | 2.26 | 535.34 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 35.15 | 72.54 | 2.06 | 469.65 |
| http/html-16kx64 | 1048576 | 9 | stdx | 25.18 | 69.06 | 2.74 | 551.19 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.78 | 23.03 | 2.62 | 224.66 |
| http/html-1m | 1048576 | 1 | stdx | 8.19 | 17.80 | 2.17 | 206.70 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.44 | 49.53 | 1.95 | 328.33 |
| http/html-1m | 1048576 | 6 | stdx | 21.39 | 40.71 | 1.90 | 620.73 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.32 | 109.24 | 1.53 | 432.57 |
| http/html-1m | 1048576 | 9 | stdx | 36.14 | 85.76 | 2.37 | 706.82 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.84 | 94.80 | 2.98 | 301.40 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.82 | 45.22 | 2.69 | 242.25 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.13 | 126.60 | 2.94 | 372.47 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.50 | 78.43 | 2.85 | 375.71 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.20 | 142.45 | 2.73 | 430.91 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 31.11 | 95.61 | 3.07 | 383.59 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.86 | 23.85 | 3.03 | 134.26 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.50 | 13.94 | 2.54 | 110.45 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.24 | 46.61 | 2.55 | 206.05 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.56 | 35.02 | 2.58 | 276.85 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.15 | 151.99 | 1.90 | 296.31 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.44 | 58.45 | 3.01 | 301.50 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.74 | 19.85 | 2.95 | 124.34 |
| http/json-1m | 1048576 | 1 | stdx | 5.08 | 12.51 | 2.46 | 103.08 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.35 | 45.30 | 2.23 | 176.05 |
| http/json-1m | 1048576 | 6 | stdx | 14.78 | 35.09 | 2.37 | 294.80 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.52 | 205.21 | 1.69 | 274.96 |
| http/json-1m | 1048576 | 9 | stdx | 29.40 | 72.87 | 2.48 | 369.01 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.16 | 107.80 | 2.90 | 517.21 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 24.00 | 65.45 | 2.73 | 411.89 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.46 | 144.85 | 2.93 | 676.75 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 35.93 | 104.17 | 2.90 | 619.38 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.83 | 150.13 | 2.90 | 716.33 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 40.73 | 125.18 | 3.07 | 626.01 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.74 | 30.90 | 2.63 | 308.77 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.96 | 24.80 | 2.26 | 273.55 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 26.13 | 59.43 | 2.27 | 481.37 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.81 | 50.05 | 2.19 | 671.50 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.98 | 83.31 | 2.03 | 568.91 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.97 | 81.31 | 2.71 | 664.10 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.66 | 25.19 | 2.61 | 247.65 |
| http/js-1m | 1048576 | 1 | stdx | 9.60 | 21.31 | 2.22 | 234.14 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.83 | 56.12 | 1.95 | 370.29 |
| http/js-1m | 1048576 | 6 | stdx | 25.08 | 46.64 | 1.86 | 739.79 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.46 | 120.65 | 1.58 | 499.80 |
| http/js-1m | 1048576 | 9 | stdx | 42.35 | 100.01 | 2.36 | 813.96 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.29 | 97.74 | 2.94 | 376.93 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.63 | 49.57 | 2.66 | 300.62 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.89 | 129.23 | 2.94 | 476.17 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.32 | 82.37 | 2.81 | 500.90 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.93 | 133.80 | 2.91 | 507.57 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.43 | 99.53 | 2.98 | 520.96 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.65 | 25.60 | 2.96 | 173.17 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.74 | 16.96 | 2.52 | 135.43 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.33 | 48.80 | 2.40 | 293.74 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.51 | 38.01 | 2.30 | 459.71 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.93 | 82.40 | 2.01 | 375.28 |
| http/css-16kx64 | 1048576 | 9 | stdx | 23.38 | 65.14 | 2.79 | 479.94 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.97 | 21.15 | 3.04 | 133.63 |
| http/css-1m | 1048576 | 1 | stdx | 5.82 | 14.91 | 2.56 | 109.11 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.81 | 44.50 | 2.14 | 226.88 |
| http/css-1m | 1048576 | 6 | stdx | 16.75 | 35.61 | 2.13 | 450.66 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.89 | 111.58 | 1.60 | 309.36 |
| http/css-1m | 1048576 | 9 | stdx | 32.36 | 83.00 | 2.57 | 510.79 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.32 | 48.89 | 1.93 | 935.26 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.27 | 49.19 | 2.69 | 323.22 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.62 | 86.45 | 2.08 | 1181.00 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.91 | 88.80 | 2.22 | 852.10 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.06 | 94.50 | 2.01 | 1342.32 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.52 | 134.38 | 2.46 | 1134.41 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.11 | 31.22 | 3.09 | 120.04 |
| silesia/dickens | 10192446 | 1 | stdx | 24.29 | 82.03 | 3.38 | 126.49 |
| silesia/dickens | 10192446 | 3 | libzstd | 22.80 | 34.39 | 1.51 | 170.06 |
| silesia/dickens | 10192446 | 3 | stdx | 35.59 | 78.22 | 2.20 | 182.86 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.01 | 22.69 | 3.23 | 71.13 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.60 | 54.73 | 3.11 | 175.22 |
| silesia/mozilla | 51220480 | 3 | libzstd | 16.54 | 27.89 | 1.69 | 102.33 |
| silesia/mozilla | 51220480 | 3 | stdx | 30.24 | 62.01 | 2.05 | 145.72 |
| silesia/mr | 9970564 | 1 | libzstd | 7.72 | 24.81 | 3.21 | 57.52 |
| silesia/mr | 9970564 | 1 | stdx | 19.91 | 66.82 | 3.36 | 116.64 |
| silesia/mr | 9970564 | 3 | libzstd | 19.63 | 32.19 | 1.64 | 86.64 |
| silesia/mr | 9970564 | 3 | stdx | 33.31 | 72.46 | 2.18 | 115.36 |
| silesia/nci | 33553445 | 1 | libzstd | 3.53 | 9.55 | 2.70 | 57.23 |
| silesia/nci | 33553445 | 1 | stdx | 7.70 | 25.69 | 3.34 | 60.12 |
| silesia/nci | 33553445 | 3 | libzstd | 5.38 | 9.95 | 1.85 | 56.37 |
| silesia/nci | 33553445 | 3 | stdx | 11.17 | 29.15 | 2.61 | 66.94 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.60 | 29.26 | 3.40 | 72.90 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.14 | 72.51 | 3.13 | 181.28 |
| silesia/ooffice | 6152192 | 3 | libzstd | 23.06 | 39.44 | 1.71 | 120.17 |
| silesia/ooffice | 6152192 | 3 | stdx | 41.42 | 82.20 | 1.98 | 186.68 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.08 | 22.29 | 3.15 | 66.62 |
| silesia/osdb | 10085684 | 1 | stdx | 16.38 | 50.52 | 3.08 | 122.95 |
| silesia/osdb | 10085684 | 3 | libzstd | 17.38 | 26.23 | 1.51 | 68.19 |
| silesia/osdb | 10085684 | 3 | stdx | 31.25 | 57.87 | 1.85 | 111.08 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.75 | 27.13 | 2.78 | 150.72 |
| silesia/reymont | 6627202 | 1 | stdx | 20.26 | 72.05 | 3.56 | 97.09 |
| silesia/reymont | 6627202 | 3 | libzstd | 18.12 | 27.10 | 1.50 | 126.65 |
| silesia/reymont | 6627202 | 3 | stdx | 28.09 | 62.18 | 2.21 | 147.15 |
| silesia/samba | 21606400 | 1 | libzstd | 5.97 | 16.88 | 2.82 | 85.38 |
| silesia/samba | 21606400 | 1 | stdx | 13.58 | 42.89 | 3.16 | 126.50 |
| silesia/samba | 21606400 | 3 | libzstd | 11.84 | 18.81 | 1.59 | 98.86 |
| silesia/samba | 21606400 | 3 | stdx | 20.15 | 44.75 | 2.22 | 134.46 |
| silesia/sao | 7251944 | 1 | libzstd | 9.08 | 33.69 | 3.71 | 45.67 |
| silesia/sao | 7251944 | 1 | stdx | 25.86 | 82.03 | 3.17 | 104.76 |
| silesia/sao | 7251944 | 3 | libzstd | 30.27 | 50.03 | 1.65 | 95.02 |
| silesia/sao | 7251944 | 3 | stdx | 50.74 | 95.22 | 1.88 | 143.29 |
| silesia/webster | 41458703 | 1 | libzstd | 8.64 | 24.94 | 2.89 | 130.95 |
| silesia/webster | 41458703 | 1 | stdx | 20.28 | 64.04 | 3.16 | 167.31 |
| silesia/webster | 41458703 | 3 | libzstd | 18.78 | 27.33 | 1.45 | 176.79 |
| silesia/webster | 41458703 | 3 | stdx | 30.53 | 64.55 | 2.11 | 195.72 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.78 | 14.92 | 3.12 | 17.07 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.86 | 76.64 | 3.21 | 93.48 |
| silesia/x-ray | 8474240 | 3 | libzstd | 30.68 | 52.73 | 1.72 | 88.10 |
| silesia/x-ray | 8474240 | 3 | stdx | 46.97 | 92.40 | 1.97 | 106.84 |
| silesia/xml | 5345280 | 1 | libzstd | 4.24 | 11.71 | 2.76 | 71.45 |
| silesia/xml | 5345280 | 1 | stdx | 10.41 | 34.21 | 3.29 | 95.17 |
| silesia/xml | 5345280 | 3 | libzstd | 6.79 | 12.61 | 1.86 | 77.57 |
| silesia/xml | 5345280 | 3 | stdx | 12.82 | 32.28 | 2.52 | 116.20 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.79 | 32.84 | 3.04 | 138.96 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.42 | 76.49 | 3.41 | 190.37 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.65 | 39.48 | 2.52 | 204.93 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.57 | 73.76 | 2.78 | 340.25 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.74 | 33.55 | 3.45 | 103.37 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.66 | 79.00 | 3.34 | 221.20 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.34 | 39.27 | 2.56 | 211.98 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.35 | 79.30 | 2.80 | 381.73 |
| canterbury/cp.html | 24603 | 1 | libzstd | 7.00 | 26.64 | 3.81 | 40.95 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.14 | 57.76 | 3.58 | 123.38 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.55 | 31.85 | 3.33 | 47.75 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.51 | 59.76 | 3.23 | 156.06 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.73 | 31.76 | 3.64 | 44.51 |
| canterbury/fields.c | 11150 | 1 | stdx | 17.06 | 65.73 | 3.85 | 91.43 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.36 | 34.14 | 3.65 | 29.14 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.36 | 64.68 | 3.73 | 96.94 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.45 | 38.01 | 4.02 | 8.97 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.18 | 77.57 | 3.84 | 51.22 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.70 | 43.09 | 4.03 | 7.77 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.53 | 79.60 | 3.70 | 75.77 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.01 | 23.56 | 3.92 | 14.97 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.82 | 56.75 | 3.83 | 87.07 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.30 | 23.80 | 2.87 | 27.58 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 20.29 | 56.61 | 2.79 | 111.18 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.81 | 28.52 | 2.91 | 155.56 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.47 | 72.02 | 3.35 | 161.59 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 16.02 | 32.14 | 2.01 | 201.69 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.28 | 67.10 | 2.55 | 299.31 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.31 | 32.37 | 3.14 | 128.36 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.16 | 84.16 | 3.34 | 160.42 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 20.02 | 38.77 | 1.94 | 226.80 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 31.64 | 80.77 | 2.55 | 346.12 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.16 | 8.51 | 2.69 | 67.23 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.55 | 23.15 | 3.07 | 106.68 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 4.80 | 10.97 | 2.29 | 59.19 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.47 | 24.08 | 2.54 | 133.93 |
| canterbury/sum | 38240 | 1 | libzstd | 6.57 | 25.39 | 3.86 | 33.94 |
| canterbury/sum | 38240 | 1 | stdx | 16.96 | 59.13 | 3.49 | 154.90 |
| canterbury/sum | 38240 | 3 | libzstd | 9.04 | 30.67 | 3.39 | 46.86 |
| canterbury/sum | 38240 | 3 | stdx | 19.81 | 61.82 | 3.12 | 191.63 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 9.99 | 39.82 | 3.99 | 13.09 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.91 | 80.38 | 3.85 | 61.31 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.25 | 48.17 | 3.93 | 16.57 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.95 | 83.98 | 3.66 | 83.59 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.32 | 33.44 | 3.24 | 76.17 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.90 | 95.62 | 4.37 | 7.34 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 15.01 | 31.30 | 2.09 | 36.07 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.75 | 70.38 | 2.96 | 38.36 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.72 | 27.45 | 2.82 | 149.05 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.42 | 71.86 | 3.52 | 108.44 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 17.94 | 28.20 | 1.57 | 132.33 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 27.83 | 63.36 | 2.28 | 155.59 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.17 | 22.70 | 2.78 | 137.59 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.70 | 55.86 | 2.99 | 195.85 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 15.21 | 23.87 | 1.57 | 173.48 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 24.92 | 51.26 | 2.06 | 238.91 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.04 | 52.46 | 3.08 | 159.23 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 36.24 | 100.54 | 2.77 | 645.14 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.07 | 59.20 | 3.10 | 198.56 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 38.31 | 104.00 | 2.71 | 642.25 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.69 | 22.46 | 2.92 | 122.02 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.28 | 46.84 | 3.28 | 184.35 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.75 | 24.61 | 2.81 | 141.42 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.53 | 47.61 | 3.07 | 194.41 |
| http/html-1m | 1048576 | 1 | libzstd | 6.20 | 16.74 | 2.70 | 114.43 |
| http/html-1m | 1048576 | 1 | stdx | 12.96 | 42.00 | 3.24 | 135.60 |
| http/html-1m | 1048576 | 3 | libzstd | 9.20 | 18.18 | 1.98 | 125.44 |
| http/html-1m | 1048576 | 3 | stdx | 15.77 | 39.37 | 2.50 | 178.31 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.35 | 42.52 | 2.96 | 115.59 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.78 | 83.13 | 2.79 | 536.83 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.84 | 44.54 | 3.00 | 129.51 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 31.06 | 84.87 | 2.73 | 541.60 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.80 | 14.98 | 3.12 | 57.71 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.78 | 33.78 | 3.46 | 117.99 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.34 | 16.21 | 3.04 | 72.30 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.63 | 34.58 | 3.25 | 123.96 |
| http/json-1m | 1048576 | 1 | libzstd | 4.04 | 12.55 | 3.11 | 52.38 |
| http/json-1m | 1048576 | 1 | stdx | 9.05 | 30.70 | 3.39 | 87.25 |
| http/json-1m | 1048576 | 3 | libzstd | 6.08 | 13.78 | 2.26 | 68.29 |
| http/json-1m | 1048576 | 3 | stdx | 11.36 | 30.64 | 2.70 | 121.34 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.55 | 57.26 | 3.09 | 184.93 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 40.21 | 113.49 | 2.82 | 701.66 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.42 | 65.54 | 3.06 | 258.87 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.35 | 116.54 | 2.75 | 691.67 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.82 | 26.52 | 3.01 | 127.30 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.77 | 55.71 | 3.32 | 203.10 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.07 | 28.74 | 2.85 | 155.83 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.89 | 55.35 | 3.09 | 211.79 |
| http/js-1m | 1048576 | 1 | libzstd | 6.53 | 17.87 | 2.74 | 113.49 |
| http/js-1m | 1048576 | 1 | stdx | 13.98 | 45.88 | 3.28 | 137.62 |
| http/js-1m | 1048576 | 3 | libzstd | 9.86 | 19.14 | 1.94 | 125.78 |
| http/js-1m | 1048576 | 3 | stdx | 16.89 | 41.25 | 2.44 | 188.22 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.56 | 46.90 | 3.01 | 136.68 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.52 | 91.65 | 2.82 | 580.56 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.64 | 50.53 | 3.04 | 159.51 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.98 | 93.63 | 2.76 | 587.83 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.13 | 18.99 | 3.10 | 78.72 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.55 | 43.79 | 3.49 | 138.24 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.55 | 19.41 | 2.96 | 95.14 |
| http/css-16kx64 | 1048576 | 3 | stdx | 13.12 | 42.34 | 3.23 | 154.47 |
| http/css-1m | 1048576 | 1 | libzstd | 1.50 | 4.59 | 3.05 | 21.80 |
| http/css-1m | 1048576 | 1 | stdx | 4.00 | 14.85 | 3.71 | 30.54 |
| http/css-1m | 1048576 | 3 | libzstd | 1.96 | 5.25 | 2.68 | 19.64 |
| http/css-1m | 1048576 | 3 | stdx | 3.98 | 13.33 | 3.35 | 31.91 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.51 | 12.79 | 3.65 | 5.98 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.20 | 30.66 | 3.33 | 62.99 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 27.19 | 50.53 | 1.86 | 51.69 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 20.85 | 47.43 | 2.27 | 212.94 |

## Hardware counters per input octet, brotli encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | Google q1 | 18.55 | 30.24 | 1.63 | 231.92 |
| silesia/dickens | 10192446 | stdx 1 | 19.52 | 43.43 | 2.22 | 413.08 |
| silesia/dickens | 10192446 | Google q5 | 123.96 | 194.36 | 1.57 | 824.09 |
| silesia/dickens | 10192446 | stdx 5 | 75.44 | 155.43 | 2.06 | 991.78 |
| silesia/mozilla | 51220480 | Google q1 | 13.42 | 25.26 | 1.88 | 145.09 |
| silesia/mozilla | 51220480 | stdx 1 | 12.40 | 32.95 | 2.66 | 213.48 |
| silesia/mozilla | 51220480 | Google q5 | 66.84 | 149.30 | 2.23 | 800.44 |
| silesia/mozilla | 51220480 | stdx 5 | 60.54 | 148.04 | 2.45 | 815.29 |
| silesia/mr | 9970564 | Google q1 | 13.40 | 26.14 | 1.95 | 97.41 |
| silesia/mr | 9970564 | stdx 1 | 13.75 | 37.80 | 2.75 | 165.37 |
| silesia/mr | 9970564 | Google q5 | 88.92 | 177.41 | 2.00 | 607.95 |
| silesia/mr | 9970564 | stdx 5 | 67.47 | 149.01 | 2.21 | 703.21 |
| silesia/nci | 33553445 | Google q1 | 5.33 | 9.71 | 1.82 | 88.99 |
| silesia/nci | 33553445 | stdx 1 | 6.11 | 14.48 | 2.37 | 127.89 |
| silesia/nci | 33553445 | Google q5 | 32.37 | 59.01 | 1.82 | 412.02 |
| silesia/nci | 33553445 | stdx 5 | 30.60 | 58.51 | 1.91 | 487.90 |
| silesia/ooffice | 6152192 | Google q1 | 18.05 | 33.43 | 1.85 | 155.96 |
| silesia/ooffice | 6152192 | stdx 1 | 16.92 | 45.85 | 2.71 | 266.06 |
| silesia/ooffice | 6152192 | Google q5 | 92.75 | 198.80 | 2.14 | 1068.88 |
| silesia/ooffice | 6152192 | stdx 5 | 74.10 | 178.18 | 2.40 | 1076.97 |
| silesia/osdb | 10085684 | Google q1 | 12.78 | 23.47 | 1.84 | 84.36 |
| silesia/osdb | 10085684 | stdx 1 | 11.74 | 32.00 | 2.73 | 141.99 |
| silesia/osdb | 10085684 | Google q5 | 73.46 | 146.01 | 1.99 | 549.73 |
| silesia/osdb | 10085684 | stdx 5 | 53.26 | 123.53 | 2.32 | 520.29 |
| silesia/reymont | 6627202 | Google q1 | 15.57 | 25.54 | 1.64 | 207.85 |
| silesia/reymont | 6627202 | stdx 1 | 14.51 | 33.36 | 2.30 | 284.09 |
| silesia/reymont | 6627202 | Google q5 | 84.36 | 169.16 | 2.01 | 800.33 |
| silesia/reymont | 6627202 | stdx 5 | 64.53 | 139.71 | 2.16 | 906.84 |
| silesia/samba | 21606400 | Google q1 | 10.02 | 17.38 | 1.73 | 128.03 |
| silesia/samba | 21606400 | stdx 1 | 9.95 | 23.94 | 2.41 | 196.33 |
| silesia/samba | 21606400 | Google q5 | 49.67 | 105.54 | 2.12 | 481.07 |
| silesia/samba | 21606400 | stdx 5 | 43.77 | 102.32 | 2.34 | 531.37 |
| silesia/sao | 7251944 | Google q1 | 21.51 | 39.96 | 1.86 | 100.85 |
| silesia/sao | 7251944 | stdx 1 | 18.84 | 55.66 | 2.95 | 189.79 |
| silesia/sao | 7251944 | Google q5 | 113.97 | 259.63 | 2.28 | 932.34 |
| silesia/sao | 7251944 | stdx 5 | 87.33 | 229.67 | 2.63 | 753.11 |
| silesia/webster | 41458703 | Google q1 | 14.83 | 24.40 | 1.65 | 209.12 |
| silesia/webster | 41458703 | stdx 1 | 15.29 | 34.12 | 2.23 | 338.98 |
| silesia/webster | 41458703 | Google q5 | 79.04 | 141.82 | 1.79 | 757.08 |
| silesia/webster | 41458703 | stdx 5 | 64.44 | 121.03 | 1.88 | 852.34 |
| silesia/x-ray | 8474240 | Google q1 | 13.98 | 22.03 | 1.58 | 12.64 |
| silesia/x-ray | 8474240 | stdx 1 | 13.20 | 38.68 | 2.93 | 95.05 |
| silesia/x-ray | 8474240 | Google q5 | 108.50 | 236.76 | 2.18 | 726.49 |
| silesia/x-ray | 8474240 | stdx 5 | 85.20 | 226.78 | 2.66 | 643.82 |
| silesia/xml | 5345280 | Google q1 | 7.15 | 12.28 | 1.72 | 114.15 |
| silesia/xml | 5345280 | stdx 1 | 7.45 | 17.44 | 2.34 | 153.83 |
| silesia/xml | 5345280 | Google q5 | 33.49 | 72.50 | 2.16 | 360.11 |
| silesia/xml | 5345280 | stdx 5 | 29.99 | 64.66 | 2.16 | 412.80 |
| canterbury/alice29.txt | 152089 | Google q1 | 17.13 | 29.72 | 1.73 | 208.95 |
| canterbury/alice29.txt | 152089 | stdx 1 | 18.34 | 40.79 | 2.22 | 447.32 |
| canterbury/alice29.txt | 152089 | Google q5 | 79.98 | 200.77 | 2.51 | 1040.07 |
| canterbury/alice29.txt | 152089 | stdx 5 | 67.72 | 150.37 | 2.22 | 906.41 |
| canterbury/asyoulik.txt | 125179 | Google q1 | 18.41 | 32.37 | 1.76 | 223.50 |
| canterbury/asyoulik.txt | 125179 | stdx 1 | 20.04 | 44.50 | 2.22 | 497.90 |
| canterbury/asyoulik.txt | 125179 | Google q5 | 85.30 | 215.27 | 2.52 | 1077.99 |
| canterbury/asyoulik.txt | 125179 | stdx 5 | 75.43 | 162.29 | 2.15 | 1052.96 |
| canterbury/cp.html | 24603 | Google q1 | 12.98 | 27.30 | 2.10 | 95.87 |
| canterbury/cp.html | 24603 | stdx 1 | 14.60 | 36.07 | 2.47 | 351.05 |
| canterbury/cp.html | 24603 | Google q5 | 61.27 | 163.89 | 2.68 | 945.49 |
| canterbury/cp.html | 24603 | stdx 5 | 56.52 | 131.75 | 2.33 | 723.61 |
| canterbury/fields.c | 11150 | Google q1 | 12.07 | 29.04 | 2.41 | 10.62 |
| canterbury/fields.c | 11150 | stdx 1 | 10.54 | 38.87 | 3.69 | 88.55 |
| canterbury/fields.c | 11150 | Google q5 | 59.53 | 168.16 | 2.82 | 906.53 |
| canterbury/fields.c | 11150 | stdx 5 | 44.10 | 123.30 | 2.80 | 554.46 |
| canterbury/grammar.lsp | 3721 | Google q1 | 14.41 | 39.39 | 2.73 | 9.51 |
| canterbury/grammar.lsp | 3721 | stdx 1 | 13.51 | 55.22 | 4.09 | 30.97 |
| canterbury/grammar.lsp | 3721 | Google q5 | 60.55 | 203.91 | 3.37 | 434.07 |
| canterbury/grammar.lsp | 3721 | stdx 5 | 41.32 | 148.73 | 3.60 | 144.23 |
| canterbury/kennedy.xls | 1029744 | Google q1 | 9.92 | 24.83 | 2.50 | 59.78 |
| canterbury/kennedy.xls | 1029744 | stdx 1 | 7.81 | 27.03 | 3.46 | 76.34 |
| canterbury/kennedy.xls | 1029744 | Google q5 | 47.32 | 162.91 | 3.44 | 261.73 |
| canterbury/kennedy.xls | 1029744 | stdx 5 | 51.95 | 162.45 | 3.13 | 474.76 |
| canterbury/lcet10.txt | 426754 | Google q1 | 16.04 | 27.19 | 1.70 | 201.89 |
| canterbury/lcet10.txt | 426754 | stdx 1 | 16.79 | 37.84 | 2.25 | 378.44 |
| canterbury/lcet10.txt | 426754 | Google q5 | 77.06 | 187.58 | 2.43 | 956.76 |
| canterbury/lcet10.txt | 426754 | stdx 5 | 64.27 | 140.50 | 2.19 | 908.29 |
| canterbury/plrabn12.txt | 481861 | Google q1 | 18.97 | 32.57 | 1.72 | 251.82 |
| canterbury/plrabn12.txt | 481861 | stdx 1 | 20.83 | 46.66 | 2.24 | 472.72 |
| canterbury/plrabn12.txt | 481861 | Google q5 | 94.63 | 229.77 | 2.43 | 1065.30 |
| canterbury/plrabn12.txt | 481861 | stdx 5 | 80.82 | 168.65 | 2.09 | 1193.19 |
| canterbury/ptt5 | 513216 | Google q1 | 5.07 | 9.55 | 1.88 | 80.68 |
| canterbury/ptt5 | 513216 | stdx 1 | 6.64 | 15.64 | 2.35 | 160.68 |
| canterbury/ptt5 | 513216 | Google q5 | 27.25 | 68.87 | 2.53 | 467.73 |
| canterbury/ptt5 | 513216 | stdx 5 | 29.69 | 69.96 | 2.36 | 469.35 |
| canterbury/sum | 38240 | Google q1 | 12.99 | 29.25 | 2.25 | 91.73 |
| canterbury/sum | 38240 | stdx 1 | 15.43 | 36.37 | 2.36 | 398.61 |
| canterbury/sum | 38240 | Google q5 | 65.48 | 182.58 | 2.79 | 1095.05 |
| canterbury/sum | 38240 | stdx 5 | 64.50 | 159.26 | 2.47 | 843.17 |
| canterbury/xargs.1 | 4227 | Google q1 | 16.34 | 43.16 | 2.64 | 15.93 |
| canterbury/xargs.1 | 4227 | stdx 1 | 14.78 | 59.10 | 4.00 | 44.26 |
| canterbury/xargs.1 | 4227 | Google q5 | 70.20 | 219.02 | 3.12 | 737.88 |
| canterbury/xargs.1 | 4227 | stdx 5 | 47.85 | 159.53 | 3.33 | 261.61 |
| canterbury-large/E.coli | 4638690 | Google q1 | 13.61 | 27.46 | 2.02 | 53.34 |
| canterbury-large/E.coli | 4638690 | stdx 1 | 5.63 | 19.24 | 3.42 | 17.90 |
| canterbury-large/E.coli | 4638690 | Google q5 | 92.61 | 262.67 | 2.84 | 1009.94 |
| canterbury-large/E.coli | 4638690 | stdx 5 | 31.70 | 93.28 | 2.94 | 64.63 |
| canterbury-large/bible.txt | 4047392 | Google q1 | 14.91 | 24.57 | 1.65 | 174.69 |
| canterbury-large/bible.txt | 4047392 | stdx 1 | 15.34 | 34.29 | 2.24 | 316.23 |
| canterbury-large/bible.txt | 4047392 | Google q5 | 82.38 | 165.65 | 2.01 | 734.05 |
| canterbury-large/bible.txt | 4047392 | stdx 5 | 59.39 | 134.16 | 2.26 | 806.55 |
| canterbury-large/world192.txt | 2473400 | Google q1 | 13.93 | 22.62 | 1.62 | 196.26 |
| canterbury-large/world192.txt | 2473400 | stdx 1 | 13.78 | 31.07 | 2.25 | 314.76 |
| canterbury-large/world192.txt | 2473400 | Google q5 | 71.82 | 129.46 | 1.80 | 745.43 |
| canterbury-large/world192.txt | 2473400 | stdx 5 | 54.48 | 105.07 | 1.93 | 775.00 |
| http/html-1kx1024 | 1048576 | Google q1 | 32.34 | 62.53 | 1.93 | 864.66 |
| http/html-1kx1024 | 1048576 | stdx 1 | 27.55 | 80.73 | 2.93 | 472.26 |
| http/html-1kx1024 | 1048576 | Google q5 | 106.79 | 260.90 | 2.44 | 2122.95 |
| http/html-1kx1024 | 1048576 | stdx 5 | 68.46 | 169.39 | 2.47 | 1180.19 |
| http/html-16kx64 | 1048576 | Google q1 | 11.33 | 20.38 | 1.80 | 215.08 |
| http/html-16kx64 | 1048576 | stdx 1 | 11.50 | 28.46 | 2.48 | 301.61 |
| http/html-16kx64 | 1048576 | Google q5 | 47.50 | 118.53 | 2.50 | 858.32 |
| http/html-16kx64 | 1048576 | stdx 5 | 40.78 | 92.79 | 2.28 | 668.51 |
| http/html-1m | 1048576 | Google q1 | 9.09 | 15.15 | 1.67 | 137.33 |
| http/html-1m | 1048576 | stdx 1 | 9.64 | 22.18 | 2.30 | 225.60 |
| http/html-1m | 1048576 | Google q5 | 46.16 | 104.93 | 2.27 | 576.22 |
| http/html-1m | 1048576 | stdx 5 | 37.21 | 84.09 | 2.26 | 543.98 |
| http/json-1kx1024 | 1048576 | Google q1 | 24.73 | 49.87 | 2.02 | 653.01 |
| http/json-1kx1024 | 1048576 | stdx 1 | 21.17 | 61.64 | 2.91 | 365.46 |
| http/json-1kx1024 | 1048576 | Google q5 | 79.75 | 203.15 | 2.55 | 1340.02 |
| http/json-1kx1024 | 1048576 | stdx 5 | 50.67 | 132.48 | 2.61 | 735.64 |
| http/json-16kx64 | 1048576 | Google q1 | 7.66 | 14.90 | 1.94 | 141.92 |
| http/json-16kx64 | 1048576 | stdx 1 | 7.05 | 19.73 | 2.80 | 158.99 |
| http/json-16kx64 | 1048576 | Google q5 | 36.39 | 97.81 | 2.69 | 560.10 |
| http/json-16kx64 | 1048576 | stdx 5 | 36.23 | 89.00 | 2.46 | 532.26 |
| http/json-1m | 1048576 | Google q1 | 6.26 | 12.65 | 2.02 | 91.98 |
| http/json-1m | 1048576 | stdx 1 | 6.65 | 17.21 | 2.59 | 140.18 |
| http/json-1m | 1048576 | Google q5 | 37.51 | 96.08 | 2.56 | 446.64 |
| http/json-1m | 1048576 | stdx 5 | 39.21 | 92.44 | 2.36 | 573.57 |
| http/js-1kx1024 | 1048576 | Google q1 | 34.97 | 68.18 | 1.95 | 907.87 |
| http/js-1kx1024 | 1048576 | stdx 1 | 30.59 | 90.40 | 2.96 | 529.87 |
| http/js-1kx1024 | 1048576 | Google q5 | 116.83 | 288.57 | 2.47 | 2297.01 |
| http/js-1kx1024 | 1048576 | stdx 5 | 76.98 | 188.24 | 2.45 | 1319.57 |
| http/js-16kx64 | 1048576 | Google q1 | 13.16 | 24.07 | 1.83 | 231.23 |
| http/js-16kx64 | 1048576 | stdx 1 | 13.43 | 32.69 | 2.43 | 353.97 |
| http/js-16kx64 | 1048576 | Google q5 | 55.88 | 141.15 | 2.53 | 998.92 |
| http/js-16kx64 | 1048576 | stdx 5 | 47.72 | 107.16 | 2.25 | 788.91 |
| http/js-1m | 1048576 | Google q1 | 9.89 | 16.69 | 1.69 | 141.14 |
| http/js-1m | 1048576 | stdx 1 | 10.23 | 23.55 | 2.30 | 228.29 |
| http/js-1m | 1048576 | Google q5 | 53.45 | 116.02 | 2.17 | 636.02 |
| http/js-1m | 1048576 | stdx 5 | 39.56 | 90.08 | 2.28 | 590.80 |
| http/css-1kx1024 | 1048576 | Google q1 | 27.77 | 54.06 | 1.95 | 734.78 |
| http/css-1kx1024 | 1048576 | stdx 1 | 23.73 | 68.32 | 2.88 | 432.97 |
| http/css-1kx1024 | 1048576 | Google q5 | 86.95 | 213.92 | 2.46 | 1666.23 |
| http/css-1kx1024 | 1048576 | stdx 5 | 53.99 | 139.00 | 2.57 | 906.71 |
| http/css-16kx64 | 1048576 | Google q1 | 9.01 | 16.85 | 1.87 | 140.58 |
| http/css-16kx64 | 1048576 | stdx 1 | 8.49 | 23.62 | 2.78 | 191.99 |
| http/css-16kx64 | 1048576 | Google q5 | 37.85 | 100.68 | 2.66 | 647.58 |
| http/css-16kx64 | 1048576 | stdx 5 | 31.88 | 81.52 | 2.56 | 495.05 |
| http/css-1m | 1048576 | Google q1 | 6.09 | 11.27 | 1.85 | 75.80 |
| http/css-1m | 1048576 | stdx 1 | 5.44 | 14.38 | 2.64 | 110.12 |
| http/css-1m | 1048576 | Google q5 | 14.80 | 38.50 | 2.60 | 130.22 |
| http/css-1m | 1048576 | stdx 5 | 14.67 | 36.87 | 2.51 | 111.45 |
| shuffled/dickens-1m | 1048576 | Google q1 | 11.55 | 20.96 | 1.81 | 2.85 |
| shuffled/dickens-1m | 1048576 | stdx 1 | 5.44 | 19.75 | 3.63 | 16.83 |
| shuffled/dickens-1m | 1048576 | Google q5 | 100.79 | 235.57 | 2.34 | 724.64 |
| shuffled/dickens-1m | 1048576 | stdx 5 | 44.99 | 123.05 | 2.74 | 254.71 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.118 | 3.00 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 65.7 | 219.6 | 0.088 | 7.76 | 3.34 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 30.6 | 96.1 | 0.162 | 3.62 | 3.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextReader.next_items | 29.3 | 80.8 | 0.152 | 3.46 | 2.75 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 252.0 | 1024.0 | 0.839 | 29.77 | 4.06 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.8 | 107.7 | 0.133 | 3.64 | 3.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.6 | 106.2 | 0.294 | 3.37 | 3.72 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 93.1 | 378.2 | 0.387 | 11.00 | 4.06 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.9 | 161.9 | 0.471 | 5.07 | 3.77 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 92.7 | 451.6 | 0.304 | 10.95 | 4.87 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 32.6 | 89.5 | 0.004 | 4.80 | 2.75 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 72.2 | 234.7 | 0.041 | 10.63 | 3.25 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 35.1 | 99.4 | 0.012 | 5.17 | 2.83 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextReader.next_items | 33.7 | 84.2 | 0.009 | 4.96 | 2.50 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 219.5 | 819.1 | 0.972 | 32.31 | 3.73 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.3 | 107.7 | 0.040 | 4.16 | 3.81 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 39.1 | 106.0 | 0.049 | 5.75 | 2.71 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 93.2 | 346.2 | 0.316 | 13.72 | 3.72 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 37.9 | 144.5 | 0.051 | 5.58 | 3.81 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 99.0 | 406.5 | 0.104 | 14.57 | 4.11 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 43.0 | 96.3 | 0.195 | 4.03 | 2.24 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 88.6 | 249.4 | 0.234 | 8.29 | 2.82 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 47.6 | 113.8 | 0.292 | 4.46 | 2.39 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextReader.next_items | 45.0 | 99.4 | 0.209 | 4.21 | 2.21 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 328.2 | 1284.6 | 1.066 | 30.74 | 3.91 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 36.4 | 133.1 | 0.191 | 3.41 | 3.66 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 55.8 | 128.6 | 0.716 | 5.22 | 2.31 |
| messages: 11 string members | 96000 | 1025025 | std.json | 134.1 | 451.2 | 1.074 | 12.56 | 3.36 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 78.2 | 204.1 | 1.006 | 7.32 | 2.61 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 155.5 | 572.0 | 0.849 | 14.56 | 3.68 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 24.3 | 78.8 | 0.017 | 3.04 | 3.24 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 67.4 | 239.5 | 0.006 | 8.44 | 3.55 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 28.0 | 93.3 | 0.043 | 3.51 | 3.33 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextReader.next_items | 26.8 | 78.0 | 0.033 | 3.36 | 2.90 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 235.0 | 942.3 | 0.414 | 29.42 | 4.01 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 28.4 | 107.6 | 0.059 | 3.55 | 3.79 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 26.7 | 104.8 | 0.022 | 3.34 | 3.93 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 86.1 | 361.0 | 0.027 | 10.78 | 4.19 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 32.5 | 151.6 | 0.036 | 4.07 | 4.66 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 84.0 | 418.3 | 0.009 | 10.52 | 4.98 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114195.0 | 403846.2 | 484.505 | 0.66 | 3.54 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 599137.4 | 2503286.2 | 1388.103 | 3.47 | 4.18 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 113740.2 | 404249.2 | 453.928 | 0.66 | 3.55 |
| string: silesia/dickens | 1 | 172528 | stdx, TextReader.next_items | 113726.4 | 404282.2 | 452.866 | 0.66 | 3.55 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3559165.1 | 18223876.2 | 2976.433 | 20.63 | 5.12 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311722.5 | 621744.2 | 615.289 | 1.81 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 225493.5 | 826630.2 | 2307.814 | 1.31 | 3.67 |
| string: silesia/dickens | 1 | 172528 | std.json | 1573743.9 | 4578768.3 | 43078.990 | 9.12 | 2.91 |
| string: silesia/dickens | 1 | 172528 | serde_json | 204623.8 | 802909.2 | 994.794 | 1.19 | 3.92 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1059151.6 | 5279996.6 | 4948.216 | 6.14 | 4.99 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1564891.7 | 4799769.6 | 1362.714 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14742575.0 | 56410893.6 | 39256.929 | 12.39 | 3.83 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1566395.3 | 4799955.6 | 1334.786 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, TextReader.next_items | 1564308.1 | 4799988.6 | 1304.857 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 29162265.1 | 132108259.6 | 159468.357 | 24.50 | 4.53 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4594022.9 | 7062781.6 | 531.071 | 3.86 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1821948.1 | 7322029.6 | 14343.071 | 1.53 | 4.02 |
| string: http/json-1m | 1 | 1190272 | std.json | 10310616.6 | 47381157.6 | 31342.143 | 8.66 | 4.60 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3778512.1 | 15226584.6 | 6095.000 | 3.17 | 4.03 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9122689.3 | 47991235.9 | 27496.786 | 7.66 | 5.26 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2067943.4 | 5765419.8 | 4212.625 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6235068.4 | 22538840.8 | 6950.500 | 3.31 | 3.61 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2057237.5 | 5765605.8 | 3754.375 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextReader.next_items | 2054866.3 | 5765638.8 | 3683.750 | 1.09 | 2.81 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47431353.8 | 227842326.8 | 268507.125 | 25.19 | 4.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3783804.1 | 8446023.8 | 1923.500 | 2.01 | 2.23 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7199126.3 | 12276717.8 | 274920.125 | 3.82 | 1.71 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17488027.4 | 63617055.8 | 290712.500 | 9.29 | 3.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9489906.0 | 24440998.8 | 327731.125 | 5.04 | 2.58 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39596407.8 | 160431210.6 | 802064.625 | 21.03 | 4.05 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12972202.3 | 42561075.3 | 246165.667 | 2.56 | 3.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 160678692.0 | 666700955.3 | 394454.667 | 31.66 | 4.15 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12966265.7 | 42561261.3 | 243748.333 | 2.55 | 3.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextReader.next_items | 12940449.3 | 42561294.3 | 245217.000 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 159886497.7 | 639992668.3 | 423410.667 | 31.50 | 4.00 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17645851.7 | 49745820.3 | 251748.000 | 3.48 | 2.82 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14435146.7 | 45615166.3 | 424610.000 | 2.84 | 3.16 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79342765.7 | 314900845.3 | 480328.667 | 15.63 | 3.97 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36906516.7 | 131556418.3 | 579691.667 | 7.27 | 3.56 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 67152134.7 | 273932923.0 | 836883.333 | 13.23 | 4.08 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 92897.9 | 303842.7 | 7.677 | 0.18 | 3.27 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 185874.5 | 623466.7 | 11.484 | 0.35 | 3.35 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 147963.2 | 557622.7 | 7.613 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextReader.next_items | 148002.6 | 557626.7 | 5.935 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10208516.4 | 53478208.7 | 8.645 | 19.47 | 5.24 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 489189.2 | 1376733.7 | 3.968 | 0.93 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 537836.0 | 2195917.7 | 7.839 | 1.03 | 4.08 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3346196.3 | 12808414.7 | 60674.419 | 6.38 | 3.83 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 290985.1 | 1179969.7 | 5.258 | 0.56 | 4.06 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2264315.0 | 12789020.8 | 265.065 | 4.32 | 5.65 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 20.9 | 81.8 | 0.109 | 2.47 | 3.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.5 | 153.5 | 0.135 | 4.19 | 4.33 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 21.6 | 94.0 | 0.091 | 2.55 | 4.36 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 218.9 | 981.0 | 0.925 | 25.86 | 4.48 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 20.6 | 79.5 | 0.104 | 2.43 | 3.86 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 24.1 | 94.1 | 0.135 | 2.84 | 3.91 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 29.3 | 105.6 | 0.250 | 3.46 | 3.61 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.5 | 310.8 | 0.363 | 8.21 | 4.47 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.8 | 255.3 | 0.514 | 7.53 | 4.00 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 69.3 | 315.1 | 0.235 | 8.18 | 4.55 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 19.2 | 82.8 | 0.024 | 2.83 | 4.31 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.4 | 153.9 | 0.026 | 5.36 | 4.23 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 23.0 | 94.9 | 0.024 | 3.39 | 4.12 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 169.6 | 718.3 | 1.245 | 24.96 | 4.24 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 19.2 | 81.5 | 0.024 | 2.82 | 4.25 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 22.9 | 96.8 | 0.032 | 3.36 | 4.24 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 30.7 | 117.9 | 0.033 | 4.52 | 3.84 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 60.9 | 271.2 | 0.249 | 8.97 | 4.45 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 52.7 | 213.2 | 0.040 | 7.76 | 4.05 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 88.9 | 331.7 | 0.079 | 13.09 | 3.73 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 35.7 | 85.9 | 0.375 | 3.34 | 2.41 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 43.9 | 151.2 | 0.427 | 4.11 | 3.44 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 29.9 | 93.1 | 0.390 | 2.80 | 3.12 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 292.2 | 1195.0 | 1.662 | 27.37 | 4.09 |
| messages: 11 string members | 96000 | 1025025 | stdx, J11's loop unchecked | 34.3 | 82.8 | 0.393 | 3.21 | 2.41 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 39.1 | 119.1 | 0.573 | 3.67 | 3.04 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 47.3 | 138.2 | 0.691 | 4.43 | 2.92 |
| messages: 11 string members | 96000 | 1025025 | std.json | 105.3 | 370.8 | 1.064 | 9.86 | 3.52 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 102.3 | 315.4 | 0.779 | 9.58 | 3.08 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 134.6 | 400.7 | 0.853 | 12.61 | 2.98 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 22.0 | 80.2 | 0.007 | 2.75 | 3.65 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 38.6 | 152.5 | 0.006 | 4.83 | 3.95 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 22.3 | 93.8 | 0.006 | 2.80 | 4.20 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 209.6 | 866.7 | 1.023 | 26.23 | 4.14 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, J11's loop unchecked | 22.3 | 79.4 | 0.007 | 2.79 | 3.56 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 24.1 | 96.6 | 0.004 | 3.02 | 4.00 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 26.9 | 101.3 | 0.018 | 3.37 | 3.77 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 61.0 | 279.4 | 0.006 | 7.63 | 4.58 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 53.5 | 230.6 | 0.066 | 6.69 | 4.31 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 74.0 | 310.8 | 0.006 | 9.26 | 4.20 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 85621.7 | 280786.2 | 760.845 | 0.50 | 3.28 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 85252.0 | 280732.2 | 745.938 | 0.49 | 3.29 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 85252.1 | 280722.2 | 746.278 | 0.49 | 3.29 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3368194.3 | 16047574.2 | 2944.742 | 19.52 | 4.76 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 83109.2 | 274401.2 | 666.196 | 0.48 | 3.30 |
| string: silesia/dickens | 1 | 172528 | simdjson | 207581.7 | 674016.2 | 2041.412 | 1.20 | 3.25 |
| string: silesia/dickens | 1 | 172528 | yyjson | 203705.0 | 825518.2 | 1029.722 | 1.18 | 4.05 |
| string: silesia/dickens | 1 | 172528 | std.json | 1354224.1 | 2890892.2 | 54718.887 | 7.85 | 2.13 |
| string: silesia/dickens | 1 | 172528 | serde_json | 366483.3 | 1586249.2 | 2273.701 | 2.12 | 4.33 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 577074.9 | 2970283.9 | 2329.938 | 3.34 | 5.15 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1261955.2 | 3582350.6 | 11044.214 | 1.06 | 2.84 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1244041.0 | 3582290.6 | 10437.429 | 1.05 | 2.88 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1242184.1 | 3582278.6 | 10393.643 | 1.04 | 2.88 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25382111.5 | 109856348.6 | 143235.143 | 21.32 | 4.33 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1221966.0 | 3370022.6 | 10871.929 | 1.03 | 2.76 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2972694.7 | 10460762.6 | 29007.357 | 2.50 | 3.52 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2590394.6 | 10197931.6 | 9574.500 | 2.18 | 3.94 |
| string: http/json-1m | 1 | 1190272 | std.json | 8951838.5 | 43287986.6 | 16769.357 | 7.52 | 4.84 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4213915.1 | 17941088.6 | 10870.714 | 3.54 | 4.26 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5267053.9 | 26999510.7 | 11220.857 | 4.43 | 5.13 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2079754.9 | 6088099.8 | 4661.500 | 1.10 | 2.93 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2065137.9 | 6088043.8 | 4129.750 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2063192.8 | 6088027.8 | 4075.125 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43614058.3 | 193466553.8 | 265012.375 | 23.16 | 4.44 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2079143.8 | 5875346.8 | 4782.250 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2713998.1 | 7144143.8 | 20687.875 | 1.44 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12177080.0 | 23590602.8 | 449042.750 | 6.47 | 1.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20759055.4 | 56837736.8 | 553746.375 | 11.02 | 2.74 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11658791.3 | 33662338.8 | 331749.750 | 6.19 | 2.89 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 19014887.8 | 76319443.8 | 254839.625 | 10.10 | 4.01 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113930.9 | 426376.7 | 4.742 | 0.22 | 3.74 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113175.3 | 426318.7 | 6.774 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113092.6 | 426306.7 | 3.774 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 636274.5 | 3146479.7 | 5.710 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113110.2 | 426343.7 | 2.419 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1197587.5 | 3866916.7 | 5.194 | 2.28 | 3.23 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1626766.9 | 5833341.7 | 4.161 | 3.10 | 3.59 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3518080.5 | 13108830.7 | 63344.000 | 6.71 | 3.73 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1787349.9 | 7405810.7 | 5.645 | 3.41 | 4.14 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2395735.4 | 12748297.8 | 17.290 | 4.57 | 5.32 |
