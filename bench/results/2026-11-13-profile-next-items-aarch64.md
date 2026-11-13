# bench-profile

| Field | Value |
|---|---|
| Commit | ffd8215 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261101.172.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43362901192 |
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
| silesia/dickens | 10192446 | zlib | 8.83 | 19.08 | 2.16 | 310.78 |
| silesia/dickens | 10192446 | zlib-ng | 4.90 | 10.50 | 2.14 | 67.77 |
| silesia/dickens | 10192446 | libdeflate | 3.48 | 9.56 | 2.75 | 65.53 |
| silesia/dickens | 10192446 | Wuffs | 5.56 | 13.90 | 2.50 | 97.53 |
| silesia/dickens | 10192446 | stdx | 3.01 | 7.15 | 2.38 | 76.07 |
| silesia/mozilla | 51220480 | zlib | 8.49 | 17.23 | 2.03 | 251.79 |
| silesia/mozilla | 51220480 | zlib-ng | 4.95 | 8.95 | 1.81 | 85.56 |
| silesia/mozilla | 51220480 | libdeflate | 3.48 | 7.63 | 2.19 | 71.05 |
| silesia/mozilla | 51220480 | Wuffs | 6.40 | 13.89 | 2.17 | 132.61 |
| silesia/mozilla | 51220480 | stdx | 3.66 | 6.29 | 1.72 | 89.67 |
| silesia/mr | 9970564 | zlib | 8.43 | 18.46 | 2.19 | 203.21 |
| silesia/mr | 9970564 | zlib-ng | 4.81 | 9.98 | 2.08 | 67.74 |
| silesia/mr | 9970564 | libdeflate | 3.37 | 8.58 | 2.54 | 61.27 |
| silesia/mr | 9970564 | Wuffs | 6.01 | 14.04 | 2.34 | 99.88 |
| silesia/mr | 9970564 | stdx | 3.14 | 6.70 | 2.13 | 70.24 |
| silesia/nci | 33553445 | zlib | 3.59 | 10.18 | 2.84 | 81.22 |
| silesia/nci | 33553445 | zlib-ng | 1.63 | 3.13 | 1.92 | 33.74 |
| silesia/nci | 33553445 | libdeflate | 1.21 | 2.66 | 2.20 | 29.79 |
| silesia/nci | 33553445 | Wuffs | 2.48 | 6.47 | 2.61 | 41.48 |
| silesia/nci | 33553445 | stdx | 1.35 | 2.20 | 1.63 | 37.61 |
| silesia/ooffice | 6152192 | zlib | 11.85 | 21.06 | 1.78 | 419.08 |
| silesia/ooffice | 6152192 | zlib-ng | 6.94 | 12.04 | 1.74 | 141.31 |
| silesia/ooffice | 6152192 | libdeflate | 4.91 | 10.45 | 2.13 | 125.01 |
| silesia/ooffice | 6152192 | Wuffs | 8.82 | 17.54 | 1.99 | 220.26 |
| silesia/ooffice | 6152192 | stdx | 5.13 | 8.55 | 1.67 | 151.50 |
| silesia/osdb | 10085684 | zlib | 7.50 | 16.59 | 2.21 | 183.91 |
| silesia/osdb | 10085684 | zlib-ng | 4.31 | 8.38 | 1.94 | 53.02 |
| silesia/osdb | 10085684 | libdeflate | 2.86 | 6.91 | 2.42 | 29.76 |
| silesia/osdb | 10085684 | Wuffs | 5.80 | 13.61 | 2.35 | 78.28 |
| silesia/osdb | 10085684 | stdx | 2.83 | 5.65 | 1.99 | 41.57 |
| silesia/reymont | 6627202 | zlib | 7.41 | 15.89 | 2.14 | 261.47 |
| silesia/reymont | 6627202 | zlib-ng | 3.73 | 7.72 | 2.07 | 60.10 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.35 |
| silesia/reymont | 6627202 | Wuffs | 4.89 | 11.40 | 2.33 | 112.49 |
| silesia/reymont | 6627202 | stdx | 2.29 | 5.11 | 2.23 | 64.60 |
| silesia/samba | 21606400 | zlib | 6.18 | 14.13 | 2.29 | 175.38 |
| silesia/samba | 21606400 | zlib-ng | 3.39 | 6.47 | 1.91 | 55.95 |
| silesia/samba | 21606400 | libdeflate | 2.36 | 5.58 | 2.36 | 43.01 |
| silesia/samba | 21606400 | Wuffs | 4.36 | 10.39 | 2.38 | 79.62 |
| silesia/samba | 21606400 | stdx | 2.36 | 4.46 | 1.89 | 56.64 |
| silesia/sao | 7251944 | zlib | 10.51 | 23.54 | 2.24 | 204.51 |
| silesia/sao | 7251944 | zlib-ng | 7.89 | 14.83 | 1.88 | 79.45 |
| silesia/sao | 7251944 | libdeflate | 5.76 | 12.73 | 2.21 | 79.06 |
| silesia/sao | 7251944 | Wuffs | 8.91 | 21.26 | 2.39 | 86.53 |
| silesia/sao | 7251944 | stdx | 5.67 | 10.32 | 1.82 | 89.52 |
| silesia/webster | 41458703 | zlib | 7.82 | 16.16 | 2.07 | 282.48 |
| silesia/webster | 41458703 | zlib-ng | 4.23 | 8.04 | 1.90 | 85.10 |
| silesia/webster | 41458703 | libdeflate | 2.94 | 7.17 | 2.44 | 68.43 |
| silesia/webster | 41458703 | Wuffs | 5.15 | 11.67 | 2.27 | 122.40 |
| silesia/webster | 41458703 | stdx | 2.84 | 5.56 | 1.96 | 87.22 |
| silesia/x-ray | 8474240 | zlib | 12.91 | 27.21 | 2.11 | 329.89 |
| silesia/x-ray | 8474240 | zlib-ng | 9.05 | 17.39 | 1.92 | 124.28 |
| silesia/x-ray | 8474240 | libdeflate | 6.55 | 15.26 | 2.33 | 124.39 |
| silesia/x-ray | 8474240 | Wuffs | 10.83 | 23.52 | 2.17 | 190.79 |
| silesia/x-ray | 8474240 | stdx | 6.19 | 11.49 | 1.86 | 137.80 |
| silesia/xml | 5345280 | zlib | 4.23 | 11.16 | 2.64 | 117.92 |
| silesia/xml | 5345280 | zlib-ng | 2.00 | 3.88 | 1.94 | 42.78 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 31.94 |
| silesia/xml | 5345280 | Wuffs | 2.84 | 7.22 | 2.54 | 59.11 |
| silesia/xml | 5345280 | stdx | 1.33 | 2.65 | 1.99 | 42.11 |
| canterbury/alice29.txt | 152089 | zlib | 8.43 | 18.35 | 2.18 | 293.30 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.12 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.18 | 8.96 | 2.82 | 54.37 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.38 | 13.40 | 2.49 | 98.69 |
| canterbury/alice29.txt | 152089 | stdx | 2.72 | 6.99 | 2.57 | 63.55 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.03 | 19.42 | 2.15 | 314.93 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 73.17 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.59 | 9.82 | 2.73 | 67.47 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.75 | 14.40 | 2.50 | 99.56 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.08 | 7.52 | 2.44 | 78.74 |
| canterbury/cp.html | 24603 | zlib | 7.05 | 17.33 | 2.46 | 171.02 |
| canterbury/cp.html | 24603 | zlib-ng | 4.19 | 9.50 | 2.27 | 37.51 |
| canterbury/cp.html | 24603 | libdeflate | 2.79 | 7.95 | 2.85 | 9.72 |
| canterbury/cp.html | 24603 | Wuffs | 5.14 | 13.91 | 2.71 | 55.21 |
| canterbury/cp.html | 24603 | stdx | 2.66 | 7.19 | 2.70 | 13.74 |
| canterbury/fields.c | 11150 | zlib | 5.29 | 17.73 | 3.35 | 39.62 |
| canterbury/fields.c | 11150 | zlib-ng | 3.88 | 10.20 | 2.63 | 14.91 |
| canterbury/fields.c | 11150 | libdeflate | 2.78 | 8.32 | 2.99 | 1.50 |
| canterbury/fields.c | 11150 | Wuffs | 4.55 | 14.54 | 3.20 | 12.58 |
| canterbury/fields.c | 11150 | stdx | 2.50 | 7.64 | 3.05 | 4.60 |
| canterbury/grammar.lsp | 3721 | zlib | 6.89 | 24.26 | 3.52 | 6.61 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.82 | 17.48 | 3.01 | 7.69 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.42 | 12.05 | 2.73 | 1.55 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.68 | 21.86 | 3.27 | 4.39 |
| canterbury/grammar.lsp | 3721 | stdx | 3.85 | 12.18 | 3.16 | 1.87 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.59 | 15.27 | 3.33 | 48.68 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.53 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 8.98 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.87 | 11.59 | 3.00 | 14.84 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.74 | 4.66 | 2.68 | 16.86 |
| canterbury/lcet10.txt | 426754 | zlib | 8.20 | 17.78 | 2.17 | 289.22 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 60.37 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.04 | 8.48 | 2.79 | 55.90 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.23 | 12.88 | 2.46 | 101.62 |
| canterbury/lcet10.txt | 426754 | stdx | 2.59 | 6.42 | 2.48 | 66.39 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.22 | 19.86 | 2.15 | 322.10 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.30 | 11.19 | 2.11 | 78.99 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.70 | 77.40 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.84 | 14.61 | 2.50 | 99.65 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 7.63 | 2.41 | 85.33 |
| canterbury/ptt5 | 513216 | zlib | 5.05 | 10.71 | 2.12 | 103.42 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.00 | 3.74 | 1.87 | 46.67 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.08 | 38.12 |
| canterbury/ptt5 | 513216 | Wuffs | 3.00 | 7.13 | 2.38 | 57.52 |
| canterbury/ptt5 | 513216 | stdx | 1.45 | 2.55 | 1.76 | 49.36 |
| canterbury/sum | 38240 | zlib | 8.01 | 18.12 | 2.26 | 225.91 |
| canterbury/sum | 38240 | zlib-ng | 4.65 | 10.02 | 2.15 | 57.52 |
| canterbury/sum | 38240 | libdeflate | 3.31 | 8.34 | 2.52 | 36.26 |
| canterbury/sum | 38240 | Wuffs | 5.74 | 14.47 | 2.52 | 79.54 |
| canterbury/sum | 38240 | stdx | 3.04 | 7.73 | 2.54 | 29.40 |
| canterbury/xargs.1 | 4227 | zlib | 7.40 | 25.22 | 3.41 | 10.94 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.39 | 17.97 | 2.81 | 11.59 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.77 | 13.27 | 2.78 | 1.06 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.18 | 22.63 | 3.15 | 9.36 |
| canterbury/xargs.1 | 4227 | stdx | 4.22 | 12.86 | 3.04 | 1.52 |
| canterbury-large/E.coli | 4638690 | zlib | 6.77 | 17.84 | 2.63 | 177.76 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.24 | 9.68 | 2.28 | 47.39 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.92 | 48.44 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.66 | 12.73 | 2.73 | 61.48 |
| canterbury-large/E.coli | 4638690 | stdx | 2.48 | 6.72 | 2.71 | 54.06 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.53 | 16.46 | 2.19 | 266.68 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.79 | 8.26 | 2.18 | 53.81 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.55 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.80 | 11.73 | 2.44 | 100.32 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.23 | 5.57 | 2.50 | 55.63 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.72 | 15.84 | 2.05 | 281.06 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.53 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.41 | 74.83 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.19 | 11.48 | 2.21 | 128.40 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.73 | 5.40 | 1.98 | 90.92 |
| http/html-1kx1024 | 1048576 | zlib | 16.68 | 35.58 | 2.13 | 351.58 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.70 | 28.43 | 2.24 | 218.68 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.58 | 20.05 | 1.90 | 155.35 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.35 | 38.07 | 2.48 | 266.19 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 137.78 |
| http/html-16kx64 | 1048576 | zlib | 6.73 | 14.77 | 2.20 | 221.84 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.12 |
| http/html-16kx64 | 1048576 | libdeflate | 2.64 | 6.04 | 2.29 | 60.49 |
| http/html-16kx64 | 1048576 | Wuffs | 4.92 | 11.57 | 2.35 | 114.77 |
| http/html-16kx64 | 1048576 | stdx | 2.51 | 5.56 | 2.22 | 58.87 |
| http/html-1m | 1048576 | zlib | 5.31 | 12.53 | 2.36 | 176.43 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 59.99 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.70 |
| http/html-1m | 1048576 | Wuffs | 3.61 | 8.48 | 2.35 | 88.18 |
| http/html-1m | 1048576 | stdx | 1.65 | 3.46 | 2.10 | 53.05 |
| http/json-1kx1024 | 1048576 | zlib | 10.59 | 23.92 | 2.26 | 191.90 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.41 | 16.69 | 2.25 | 130.77 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.86 | 16.72 | 1.89 | 92.31 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.13 | 34.78 | 2.87 | 146.70 |
| http/json-1kx1024 | 1048576 | stdx | 5.03 | 13.12 | 2.61 | 80.84 |
| http/json-16kx64 | 1048576 | zlib | 4.56 | 12.51 | 2.74 | 102.96 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.82 |
| http/json-16kx64 | 1048576 | libdeflate | 1.92 | 4.24 | 2.21 | 40.61 |
| http/json-16kx64 | 1048576 | Wuffs | 3.49 | 9.43 | 2.70 | 57.98 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.26 | 39.33 |
| http/json-1m | 1048576 | zlib | 3.86 | 11.20 | 2.90 | 83.33 |
| http/json-1m | 1048576 | zlib-ng | 1.95 | 3.91 | 2.00 | 37.34 |
| http/json-1m | 1048576 | libdeflate | 1.39 | 3.33 | 2.40 | 32.74 |
| http/json-1m | 1048576 | Wuffs | 2.74 | 7.37 | 2.69 | 43.53 |
| http/json-1m | 1048576 | stdx | 1.34 | 2.67 | 1.99 | 40.28 |
| http/js-1kx1024 | 1048576 | zlib | 18.24 | 38.46 | 2.11 | 410.34 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.78 | 31.25 | 2.27 | 238.45 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.28 | 21.58 | 1.91 | 179.26 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.54 | 40.70 | 2.46 | 301.19 |
| http/js-1kx1024 | 1048576 | stdx | 9.27 | 22.85 | 2.46 | 158.95 |
| http/js-16kx64 | 1048576 | zlib | 7.67 | 16.08 | 2.10 | 263.66 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.97 | 92.06 |
| http/js-16kx64 | 1048576 | libdeflate | 3.06 | 7.01 | 2.29 | 72.15 |
| http/js-16kx64 | 1048576 | Wuffs | 5.50 | 12.75 | 2.32 | 128.83 |
| http/js-16kx64 | 1048576 | stdx | 3.02 | 6.54 | 2.17 | 72.47 |
| http/js-1m | 1048576 | zlib | 5.86 | 13.31 | 2.27 | 201.13 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 60.16 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 42.03 |
| http/js-1m | 1048576 | Wuffs | 3.90 | 9.14 | 2.34 | 93.94 |
| http/js-1m | 1048576 | stdx | 1.81 | 3.89 | 2.15 | 55.62 |
| http/css-1kx1024 | 1048576 | zlib | 14.04 | 30.36 | 2.16 | 280.78 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.26 | 23.04 | 2.25 | 171.81 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.18 | 17.37 | 1.89 | 121.12 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.80 | 32.50 | 2.54 | 211.26 |
| http/css-1kx1024 | 1048576 | stdx | 6.67 | 17.64 | 2.64 | 100.87 |
| http/css-16kx64 | 1048576 | zlib | 5.31 | 13.04 | 2.46 | 153.41 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.19 | 50.09 |
| http/css-16kx64 | 1048576 | libdeflate | 1.88 | 4.69 | 2.49 | 29.53 |
| http/css-16kx64 | 1048576 | Wuffs | 3.79 | 10.01 | 2.64 | 69.50 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.54 | 28.29 |
| http/css-1m | 1048576 | zlib | 3.98 | 10.97 | 2.76 | 107.31 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.22 | 29.15 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.98 | 12.70 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.77 | 43.65 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.53 | 21.44 |
| shuffled/dickens-1m | 1048576 | zlib | 13.30 | 25.88 | 1.95 | 373.04 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.72 | 16.72 | 1.72 | 196.52 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.03 | 14.95 | 2.13 | 194.09 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.45 | 22.08 | 2.11 | 200.83 |
| shuffled/dickens-1m | 1048576 | stdx | 7.05 | 11.89 | 1.69 | 206.42 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.51 | 14.05 | 4.00 | 3.38 |
| silesia/dickens | 10192446 | stdx | 3.67 | 12.47 | 3.40 | 3.65 |
| silesia/mozilla | 51220480 | libzstd | 2.85 | 9.68 | 3.39 | 30.16 |
| silesia/mozilla | 51220480 | stdx | 2.86 | 9.68 | 3.38 | 15.75 |
| silesia/mr | 9970564 | libzstd | 3.00 | 11.99 | 4.00 | 6.07 |
| silesia/mr | 9970564 | stdx | 3.08 | 10.83 | 3.52 | 5.26 |
| silesia/nci | 33553445 | libzstd | 1.69 | 4.88 | 2.89 | 24.87 |
| silesia/nci | 33553445 | stdx | 1.80 | 4.63 | 2.57 | 13.57 |
| silesia/ooffice | 6152192 | libzstd | 3.40 | 12.19 | 3.59 | 30.99 |
| silesia/ooffice | 6152192 | stdx | 3.36 | 12.40 | 3.69 | 12.47 |
| silesia/osdb | 10085684 | libzstd | 2.38 | 8.45 | 3.55 | 14.89 |
| silesia/osdb | 10085684 | stdx | 2.44 | 8.11 | 3.32 | 15.19 |
| silesia/reymont | 6627202 | libzstd | 3.20 | 11.62 | 3.64 | 11.54 |
| silesia/reymont | 6627202 | stdx | 3.34 | 10.36 | 3.10 | 12.67 |
| silesia/samba | 21606400 | libzstd | 2.10 | 7.41 | 3.52 | 18.59 |
| silesia/samba | 21606400 | stdx | 2.17 | 6.83 | 3.15 | 17.60 |
| silesia/sao | 7251944 | libzstd | 3.83 | 12.72 | 3.32 | 26.74 |
| silesia/sao | 7251944 | stdx | 3.54 | 12.58 | 3.55 | 6.18 |
| silesia/webster | 41458703 | libzstd | 3.29 | 11.24 | 3.42 | 16.13 |
| silesia/webster | 41458703 | stdx | 3.43 | 10.05 | 2.93 | 17.19 |
| silesia/x-ray | 8474240 | libzstd | 3.92 | 14.94 | 3.81 | 18.90 |
| silesia/x-ray | 8474240 | stdx | 3.59 | 13.23 | 3.69 | 8.57 |
| silesia/xml | 5345280 | libzstd | 1.56 | 5.57 | 3.57 | 23.26 |
| silesia/xml | 5345280 | stdx | 1.53 | 5.16 | 3.38 | 16.99 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.89 | 4.07 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.36 | 0.44 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.95 | 14.26 | 4.84 | 3.21 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.29 | 0.29 |
| canterbury/cp.html | 24603 | libzstd | 2.64 | 10.74 | 4.07 | 7.63 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.11 | 0.32 |
| canterbury/fields.c | 11150 | libzstd | 3.11 | 13.62 | 4.37 | 8.98 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.23 | 0.35 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.19 | 16.94 | 4.04 | 4.58 |
| canterbury/grammar.lsp | 3721 | stdx | 4.13 | 16.54 | 4.00 | 0.11 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.53 | 11.40 | 4.50 | 7.81 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.24 | 0.89 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.70 | 12.89 | 4.78 | 5.18 |
| canterbury/lcet10.txt | 426754 | stdx | 2.73 | 11.52 | 4.22 | 3.81 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.10 | 15.16 | 4.89 | 1.50 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.27 | 0.81 |
| canterbury/ptt5 | 513216 | libzstd | 1.47 | 4.52 | 3.08 | 25.64 |
| canterbury/ptt5 | 513216 | stdx | 1.36 | 4.46 | 3.28 | 14.65 |
| canterbury/sum | 38240 | libzstd | 2.62 | 10.58 | 4.03 | 10.19 |
| canterbury/sum | 38240 | stdx | 2.63 | 10.74 | 4.09 | 0.45 |
| canterbury/xargs.1 | 4227 | libzstd | 4.25 | 17.41 | 4.10 | 9.24 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.17 | 4.05 | 0.16 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.00 | 13.64 | 4.55 | 2.12 |
| canterbury-large/E.coli | 4638690 | stdx | 3.13 | 12.04 | 3.85 | 2.88 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.95 | 12.00 | 4.07 | 8.36 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.05 | 10.64 | 3.49 | 9.14 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.59 | 9.60 | 3.71 | 19.76 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.65 | 8.64 | 3.27 | 20.61 |
| http/html-1kx1024 | 1048576 | libzstd | 7.25 | 21.63 | 2.98 | 63.16 |
| http/html-1kx1024 | 1048576 | stdx | 7.47 | 22.46 | 3.01 | 76.59 |
| http/html-16kx64 | 1048576 | libzstd | 2.67 | 10.15 | 3.81 | 28.63 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.61 | 30.57 |
| http/html-1m | 1048576 | libzstd | 2.00 | 7.88 | 3.94 | 23.92 |
| http/html-1m | 1048576 | stdx | 2.01 | 7.12 | 3.55 | 24.68 |
| http/json-1kx1024 | 1048576 | libzstd | 6.27 | 17.39 | 2.77 | 49.73 |
| http/json-1kx1024 | 1048576 | stdx | 6.20 | 17.86 | 2.88 | 53.64 |
| http/json-16kx64 | 1048576 | libzstd | 2.06 | 7.26 | 3.53 | 28.49 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.59 | 19.77 |
| http/json-1m | 1048576 | libzstd | 1.72 | 6.08 | 3.53 | 28.15 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.63 | 14.33 |
| http/js-1kx1024 | 1048576 | libzstd | 8.33 | 26.35 | 3.16 | 73.59 |
| http/js-1kx1024 | 1048576 | stdx | 9.02 | 27.60 | 3.06 | 112.80 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.72 | 4.00 | 24.22 |
| http/js-16kx64 | 1048576 | stdx | 2.94 | 11.06 | 3.76 | 25.22 |
| http/js-1m | 1048576 | libzstd | 2.04 | 8.19 | 4.02 | 20.22 |
| http/js-1m | 1048576 | stdx | 2.07 | 7.48 | 3.61 | 20.26 |
| http/css-1kx1024 | 1048576 | libzstd | 6.88 | 19.69 | 2.86 | 53.42 |
| http/css-1kx1024 | 1048576 | stdx | 6.83 | 19.96 | 2.92 | 63.28 |
| http/css-16kx64 | 1048576 | libzstd | 2.25 | 8.70 | 3.87 | 23.28 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.04 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.58 | 3.85 | 5.46 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.51 | 3.69 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.76 | 9.40 | 3.40 | 28.44 |
| shuffled/dickens-1m | 1048576 | stdx | 2.74 | 9.19 | 3.36 | 12.45 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.54 | 16.93 | 2.24 | 99.90 |
| silesia/dickens | 1048576 | stdx | 5.12 | 12.38 | 2.42 | 55.49 |
| silesia/mozilla | 1048576 | Google | 13.48 | 28.31 | 2.10 | 48.39 |
| silesia/mozilla | 1048576 | stdx | 8.33 | 15.02 | 1.80 | 47.53 |
| silesia/mr | 1048576 | Google | 8.94 | 20.21 | 2.26 | 103.02 |
| silesia/mr | 1048576 | stdx | 5.79 | 13.25 | 2.29 | 88.99 |
| silesia/nci | 1048576 | Google | 2.56 | 5.70 | 2.23 | 52.42 |
| silesia/nci | 1048576 | stdx | 1.94 | 3.95 | 2.04 | 55.36 |
| silesia/ooffice | 1048576 | Google | 14.19 | 29.27 | 2.06 | 288.79 |
| silesia/ooffice | 1048576 | stdx | 10.98 | 20.33 | 1.85 | 324.40 |
| silesia/osdb | 1048576 | Google | 8.26 | 17.48 | 2.12 | 96.74 |
| silesia/osdb | 1048576 | stdx | 5.19 | 10.57 | 2.04 | 91.24 |
| silesia/reymont | 1048576 | Google | 5.44 | 12.62 | 2.32 | 82.40 |
| silesia/reymont | 1048576 | stdx | 3.74 | 9.25 | 2.48 | 47.97 |
| silesia/samba | 1048576 | Google | 7.60 | 16.30 | 2.15 | 95.53 |
| silesia/samba | 1048576 | stdx | 5.06 | 10.71 | 2.12 | 66.84 |
| silesia/sao | 1048576 | Google | 16.91 | 37.18 | 2.20 | 167.96 |
| silesia/sao | 1048576 | stdx | 10.42 | 22.65 | 2.17 | 141.00 |
| silesia/webster | 1048576 | Google | 6.55 | 14.00 | 2.14 | 113.44 |
| silesia/webster | 1048576 | stdx | 4.46 | 9.98 | 2.24 | 68.91 |
| silesia/x-ray | 1048576 | Google | 19.64 | 38.56 | 1.96 | 235.96 |
| silesia/x-ray | 1048576 | stdx | 14.89 | 30.18 | 2.03 | 234.40 |
| silesia/xml | 1048576 | Google | 3.45 | 7.61 | 2.21 | 65.41 |
| silesia/xml | 1048576 | stdx | 2.42 | 5.40 | 2.24 | 47.14 |
| canterbury/alice29.txt | 152089 | Google | 8.84 | 20.55 | 2.32 | 133.16 |
| canterbury/alice29.txt | 152089 | stdx | 6.05 | 15.33 | 2.53 | 80.23 |
| canterbury/asyoulik.txt | 125179 | Google | 10.37 | 23.71 | 2.29 | 166.62 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.06 | 17.43 | 2.47 | 103.11 |
| canterbury/cp.html | 24603 | Google | 9.03 | 22.20 | 2.46 | 112.95 |
| canterbury/cp.html | 24603 | stdx | 5.74 | 17.15 | 2.99 | 32.34 |
| canterbury/fields.c | 11150 | Google | 7.16 | 21.16 | 2.95 | 32.38 |
| canterbury/fields.c | 11150 | stdx | 4.88 | 17.08 | 3.50 | 1.58 |
| canterbury/grammar.lsp | 3721 | Google | 9.81 | 30.16 | 3.07 | 8.28 |
| canterbury/grammar.lsp | 3721 | stdx | 7.15 | 25.04 | 3.50 | 0.41 |
| canterbury/kennedy.xls | 1029744 | Google | 5.44 | 17.05 | 3.13 | 37.52 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.80 | 12.94 | 3.41 | 33.99 |
| canterbury/lcet10.txt | 426754 | Google | 7.72 | 17.36 | 2.25 | 125.31 |
| canterbury/lcet10.txt | 426754 | stdx | 5.24 | 12.96 | 2.47 | 66.31 |
| canterbury/plrabn12.txt | 481861 | Google | 9.07 | 20.82 | 2.30 | 132.41 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.17 | 15.04 | 2.44 | 86.90 |
| canterbury/ptt5 | 513216 | Google | 4.29 | 10.41 | 2.43 | 62.25 |
| canterbury/ptt5 | 513216 | stdx | 2.39 | 4.89 | 2.05 | 66.60 |
| canterbury/sum | 38240 | Google | 10.85 | 26.44 | 2.44 | 158.15 |
| canterbury/sum | 38240 | stdx | 8.36 | 21.11 | 2.53 | 157.80 |
| canterbury/xargs.1 | 4227 | Google | 10.98 | 34.81 | 3.17 | 10.51 |
| canterbury/xargs.1 | 4227 | stdx | 8.51 | 30.44 | 3.58 | 7.13 |
| canterbury-large/E.coli | 1048576 | Google | 8.15 | 19.55 | 2.40 | 1.45 |
| canterbury-large/E.coli | 1048576 | stdx | 6.70 | 13.48 | 2.01 | 1.11 |
| canterbury-large/bible.txt | 1048576 | Google | 5.34 | 12.28 | 2.30 | 80.88 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.58 | 8.93 | 2.49 | 39.75 |
| canterbury-large/world192.txt | 1048576 | Google | 6.23 | 12.84 | 2.06 | 114.67 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.65 | 9.38 | 2.02 | 77.06 |
| http/html-1kx1024 | 1048576 | Google | 18.00 | 41.93 | 2.33 | 385.54 |
| http/html-1kx1024 | 1048576 | stdx | 15.31 | 37.56 | 2.45 | 359.92 |
| http/html-16kx64 | 1048576 | Google | 6.74 | 14.85 | 2.20 | 149.31 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.53 |
| http/html-1m | 1048576 | Google | 4.05 | 8.94 | 2.21 | 83.07 |
| http/html-1m | 1048576 | stdx | 2.88 | 6.52 | 2.27 | 54.94 |
| http/json-1kx1024 | 1048576 | Google | 14.47 | 36.64 | 2.53 | 241.49 |
| http/json-1kx1024 | 1048576 | stdx | 13.01 | 33.63 | 2.59 | 276.38 |
| http/json-16kx64 | 1048576 | Google | 4.44 | 11.43 | 2.58 | 82.96 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.53 |
| http/json-1m | 1048576 | Google | 3.42 | 8.65 | 2.53 | 60.11 |
| http/json-1m | 1048576 | stdx | 2.45 | 5.99 | 2.44 | 57.41 |
| http/js-1kx1024 | 1048576 | Google | 19.92 | 46.20 | 2.32 | 425.99 |
| http/js-1kx1024 | 1048576 | stdx | 16.43 | 39.90 | 2.43 | 381.03 |
| http/js-16kx64 | 1048576 | Google | 8.04 | 17.73 | 2.21 | 166.10 |
| http/js-16kx64 | 1048576 | stdx | 6.04 | 14.36 | 2.38 | 125.97 |
| http/js-1m | 1048576 | Google | 4.36 | 9.54 | 2.19 | 82.90 |
| http/js-1m | 1048576 | stdx | 3.17 | 7.25 | 2.29 | 55.25 |
| http/css-1kx1024 | 1048576 | Google | 15.50 | 37.36 | 2.41 | 295.04 |
| http/css-1kx1024 | 1048576 | stdx | 13.82 | 34.70 | 2.51 | 301.57 |
| http/css-16kx64 | 1048576 | Google | 4.97 | 11.76 | 2.37 | 102.61 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.49 | 80.61 |
| http/css-1m | 1048576 | Google | 2.43 | 9.42 | 3.88 | 16.94 |
| http/css-1m | 1048576 | stdx | 0.76 | 1.86 | 2.46 | 12.16 |
| shuffled/dickens-1m | 1048576 | Google | 10.09 | 20.65 | 2.05 | 104.53 |
| shuffled/dickens-1m | 1048576 | stdx | 8.77 | 14.53 | 1.66 | 118.40 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.25 | 36.91 | 2.42 | 410.77 |
| silesia/dickens | 10192446 | 1 | stdx | 16.40 | 38.17 | 2.33 | 359.64 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.12 | 87.63 | 1.68 | 694.97 |
| silesia/dickens | 10192446 | 6 | stdx | 49.41 | 84.26 | 1.71 | 1424.41 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.88 | 160.47 | 1.43 | 927.75 |
| silesia/dickens | 10192446 | 9 | stdx | 85.77 | 191.81 | 2.24 | 1717.17 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.12 | 32.62 | 2.31 | 438.25 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.36 | 30.24 | 2.26 | 295.74 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.88 | 70.83 | 2.15 | 580.85 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.55 | 69.96 | 2.22 | 735.57 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.51 | 221.49 | 1.74 | 766.08 |
| silesia/mozilla | 51220480 | 9 | stdx | 49.04 | 126.12 | 2.57 | 791.94 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.99 | 35.02 | 2.92 | 229.72 |
| silesia/mr | 9970564 | 1 | stdx | 12.64 | 34.08 | 2.70 | 187.47 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.23 | 80.54 | 2.11 | 438.57 |
| silesia/mr | 9970564 | 6 | stdx | 39.54 | 83.19 | 2.10 | 965.70 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.61 | 165.48 | 1.70 | 748.28 |
| silesia/mr | 9970564 | 9 | stdx | 87.32 | 206.31 | 2.36 | 1329.41 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.24 | 18.42 | 2.95 | 116.10 |
| silesia/nci | 33553445 | 1 | stdx | 4.97 | 10.88 | 2.19 | 98.56 |
| silesia/nci | 33553445 | 6 | libdeflate | 17.00 | 34.84 | 2.05 | 225.77 |
| silesia/nci | 33553445 | 6 | stdx | 14.35 | 29.54 | 2.06 | 391.00 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.40 | 105.28 | 1.69 | 499.66 |
| silesia/nci | 33553445 | 9 | stdx | 33.15 | 80.64 | 2.43 | 648.13 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.91 | 39.15 | 1.97 | 753.18 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.79 | 39.08 | 2.20 | 429.99 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 41.02 | 79.10 | 1.93 | 953.80 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.70 | 87.83 | 2.11 | 1016.18 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.58 | 127.63 | 1.71 | 1128.47 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.39 | 129.17 | 2.47 | 939.42 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.91 | 30.15 | 2.34 | 353.34 |
| silesia/osdb | 10085684 | 1 | stdx | 12.96 | 27.87 | 2.15 | 293.96 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.35 | 55.67 | 1.96 | 492.81 |
| silesia/osdb | 10085684 | 6 | stdx | 27.12 | 57.40 | 2.12 | 569.79 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.98 | 64.15 | 1.89 | 552.20 |
| silesia/osdb | 10085684 | 9 | stdx | 35.83 | 87.23 | 2.43 | 687.35 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.68 | 32.88 | 2.59 | 313.12 |
| silesia/reymont | 6627202 | 1 | stdx | 13.52 | 33.24 | 2.46 | 270.84 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.12 | 86.58 | 1.80 | 519.85 |
| silesia/reymont | 6627202 | 6 | stdx | 45.12 | 76.82 | 1.70 | 1426.21 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.24 | 276.14 | 1.39 | 837.02 |
| silesia/reymont | 6627202 | 9 | stdx | 87.52 | 189.98 | 2.17 | 1609.80 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.46 | 26.53 | 2.54 | 272.81 |
| silesia/samba | 21606400 | 1 | stdx | 9.91 | 22.23 | 2.24 | 220.82 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.96 | 58.79 | 2.03 | 385.90 |
| silesia/samba | 21606400 | 6 | stdx | 24.13 | 49.84 | 2.07 | 626.01 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.21 | 141.44 | 1.68 | 504.36 |
| silesia/samba | 21606400 | 9 | stdx | 41.70 | 102.63 | 2.46 | 731.06 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.78 | 47.87 | 2.20 | 689.97 |
| silesia/sao | 7251944 | 1 | stdx | 19.19 | 49.92 | 2.60 | 346.63 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.19 | 96.89 | 1.89 | 960.59 |
| silesia/sao | 7251944 | 6 | stdx | 47.11 | 105.66 | 2.24 | 854.60 |
| silesia/sao | 7251944 | 9 | libdeflate | 71.03 | 120.26 | 1.69 | 1105.28 |
| silesia/sao | 7251944 | 9 | stdx | 55.60 | 138.16 | 2.48 | 852.03 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.15 | 30.45 | 2.32 | 388.92 |
| silesia/webster | 41458703 | 1 | stdx | 13.86 | 29.09 | 2.10 | 339.88 |
| silesia/webster | 41458703 | 6 | libdeflate | 37.07 | 66.02 | 1.78 | 570.13 |
| silesia/webster | 41458703 | 6 | stdx | 35.10 | 60.88 | 1.73 | 1107.35 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.63 | 138.85 | 1.47 | 752.74 |
| silesia/webster | 41458703 | 9 | stdx | 60.90 | 135.96 | 2.23 | 1292.45 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.75 | 49.67 | 2.09 | 790.24 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.61 | 50.82 | 2.89 | 261.64 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.82 | 82.77 | 2.52 | 852.71 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.80 | 98.12 | 2.90 | 538.80 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.51 | 91.03 | 2.43 | 1029.54 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.84 | 122.06 | 2.99 | 467.44 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.82 | 21.59 | 2.76 | 176.49 |
| silesia/xml | 5345280 | 1 | stdx | 7.07 | 15.66 | 2.21 | 155.20 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.22 | 40.51 | 1.91 | 263.89 |
| silesia/xml | 5345280 | 6 | stdx | 17.77 | 34.32 | 1.93 | 501.79 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.72 | 89.17 | 1.52 | 371.24 |
| silesia/xml | 5345280 | 9 | stdx | 31.27 | 72.83 | 2.33 | 599.47 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.28 | 35.61 | 2.49 | 381.64 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.01 | 36.13 | 2.41 | 334.61 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.83 | 82.29 | 1.76 | 643.52 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.68 | 77.43 | 1.77 | 1309.04 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.72 | 159.21 | 1.48 | 848.56 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 72.98 | 167.73 | 2.30 | 1508.41 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.19 | 37.20 | 2.45 | 418.31 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.75 | 37.43 | 2.38 | 358.55 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.38 | 85.43 | 1.77 | 717.72 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.01 | 81.93 | 1.78 | 1374.01 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 89.01 | 136.15 | 1.53 | 944.45 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 75.87 | 175.98 | 2.32 | 1606.02 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.76 | 32.02 | 2.72 | 286.93 |
| canterbury/cp.html | 24603 | 1 | stdx | 10.81 | 27.13 | 2.51 | 235.59 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 27.12 | 62.33 | 2.30 | 493.34 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.77 | 57.06 | 2.40 | 623.04 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 47.07 | 91.97 | 1.95 | 604.11 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.45 | 88.89 | 2.83 | 645.74 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.43 | 35.92 | 3.81 | 57.99 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.07 | 30.06 | 3.72 | 22.28 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.47 | 69.37 | 2.83 | 248.58 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.83 | 57.62 | 2.77 | 427.16 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.66 | 100.81 | 2.26 | 429.38 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.96 | 92.66 | 3.20 | 460.67 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.05 | 51.51 | 3.95 | 15.88 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.90 | 39.03 | 3.94 | 1.33 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.71 | 87.06 | 3.67 | 29.12 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.26 | 70.82 | 4.10 | 17.07 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 31.24 | 102.89 | 3.29 | 65.81 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.79 | 99.32 | 4.17 | 60.69 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.37 | 27.18 | 3.69 | 65.33 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.05 | 22.58 | 3.21 | 63.01 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.93 | 73.85 | 2.64 | 96.26 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.39 | 62.00 | 3.20 | 138.79 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.27 | 664.23 | 1.83 | 163.47 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.95 | 130.89 | 3.45 | 219.09 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.78 | 33.99 | 2.47 | 370.70 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.47 | 33.93 | 2.35 | 330.13 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.07 | 78.22 | 1.74 | 607.68 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.66 | 73.43 | 1.76 | 1221.98 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.83 | 136.94 | 1.49 | 804.50 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 71.04 | 162.25 | 2.28 | 1456.51 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.79 | 38.62 | 2.45 | 425.46 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.72 | 40.25 | 2.41 | 368.59 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.17 | 91.90 | 1.70 | 752.76 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.63 | 88.90 | 1.72 | 1502.86 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 117.02 | 166.26 | 1.42 | 1005.39 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 89.01 | 201.33 | 2.26 | 1806.41 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.42 | 18.61 | 2.90 | 141.63 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.98 | 11.03 | 2.21 | 123.49 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.26 | 36.17 | 2.54 | 220.11 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.34 | 29.58 | 2.40 | 309.74 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.43 | 120.86 | 2.00 | 373.29 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.21 | 130.09 | 3.01 | 639.64 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.83 | 33.49 | 2.61 | 338.65 |
| canterbury/sum | 38240 | 1 | stdx | 12.59 | 29.36 | 2.33 | 301.30 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.74 | 69.87 | 2.43 | 504.90 |
| canterbury/sum | 38240 | 6 | stdx | 26.75 | 65.74 | 2.46 | 664.51 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.36 | 181.91 | 1.93 | 614.94 |
| canterbury/sum | 38240 | 9 | stdx | 39.48 | 112.34 | 2.85 | 662.01 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.22 | 53.06 | 4.01 | 17.99 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.69 | 43.11 | 4.03 | 2.89 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.92 | 87.70 | 3.83 | 70.35 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 18.01 | 74.37 | 4.13 | 40.79 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 25.76 | 94.34 | 3.66 | 137.66 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.47 | 106.97 | 4.04 | 120.69 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.08 | 40.47 | 3.35 | 164.58 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.76 | 42.29 | 3.32 | 100.71 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.24 | 395.99 | 2.16 | 260.49 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.76 | 374.13 | 3.05 | 1897.42 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.57 | 1063.49 | 1.30 | 1320.55 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 228.55 | 755.68 | 3.31 | 2431.54 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.61 | 32.38 | 2.57 | 313.71 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.49 | 32.23 | 2.39 | 281.59 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.11 | 80.12 | 1.74 | 524.08 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.23 | 72.39 | 1.71 | 1264.28 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.73 | 200.28 | 1.41 | 741.09 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.38 | 170.21 | 2.23 | 1440.54 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.34 | 29.72 | 2.23 | 414.26 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.33 | 28.55 | 1.99 | 380.62 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.17 | 60.25 | 1.82 | 559.05 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.05 | 56.81 | 1.77 | 976.64 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.73 | 119.11 | 1.48 | 687.40 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 52.22 | 117.95 | 2.26 | 1148.77 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.42 | 103.92 | 2.93 | 452.50 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.54 | 58.69 | 2.72 | 364.12 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.29 | 138.34 | 2.99 | 563.90 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 32.22 | 94.36 | 2.93 | 528.55 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.77 | 142.44 | 2.98 | 588.33 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 36.40 | 112.18 | 3.08 | 538.28 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.46 | 27.96 | 2.67 | 266.50 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.05 | 20.25 | 2.24 | 234.31 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.50 | 52.09 | 2.32 | 400.48 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.88 | 42.87 | 2.27 | 536.16 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 35.20 | 72.54 | 2.06 | 470.35 |
| http/html-16kx64 | 1048576 | 9 | stdx | 25.05 | 69.06 | 2.76 | 551.26 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.77 | 23.03 | 2.63 | 224.19 |
| http/html-1m | 1048576 | 1 | stdx | 8.17 | 17.80 | 2.18 | 205.51 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.33 | 49.53 | 1.96 | 328.20 |
| http/html-1m | 1048576 | 6 | stdx | 21.18 | 40.71 | 1.92 | 620.37 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.21 | 109.24 | 1.53 | 432.34 |
| http/html-1m | 1048576 | 9 | stdx | 35.87 | 85.76 | 2.39 | 705.20 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.85 | 94.80 | 2.98 | 302.37 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.63 | 45.22 | 2.72 | 242.41 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.05 | 126.60 | 2.94 | 372.07 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.38 | 78.43 | 2.86 | 375.74 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.11 | 142.45 | 2.73 | 430.87 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.93 | 95.61 | 3.09 | 384.19 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.85 | 23.85 | 3.04 | 134.71 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.46 | 13.94 | 2.56 | 110.23 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.21 | 46.61 | 2.56 | 206.32 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.43 | 35.02 | 2.61 | 277.70 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.16 | 151.99 | 1.90 | 296.16 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.32 | 58.45 | 3.03 | 301.44 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.73 | 19.85 | 2.95 | 124.29 |
| http/json-1m | 1048576 | 1 | stdx | 5.07 | 12.51 | 2.47 | 103.19 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.32 | 45.30 | 2.23 | 175.47 |
| http/json-1m | 1048576 | 6 | stdx | 14.70 | 35.09 | 2.39 | 298.71 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.45 | 205.21 | 1.69 | 275.33 |
| http/json-1m | 1048576 | 9 | stdx | 29.17 | 72.87 | 2.50 | 369.22 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.07 | 107.80 | 2.91 | 517.49 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.80 | 65.45 | 2.75 | 411.46 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.41 | 144.85 | 2.93 | 676.92 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 35.76 | 104.17 | 2.91 | 618.01 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.77 | 150.13 | 2.90 | 720.95 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 40.59 | 125.18 | 3.08 | 626.18 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.73 | 30.90 | 2.64 | 308.88 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.88 | 24.80 | 2.28 | 273.76 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 26.11 | 59.43 | 2.28 | 486.03 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.66 | 50.05 | 2.21 | 668.98 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 41.04 | 83.31 | 2.03 | 573.40 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.88 | 81.31 | 2.72 | 663.82 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.64 | 25.19 | 2.61 | 247.12 |
| http/js-1m | 1048576 | 1 | stdx | 9.56 | 21.31 | 2.23 | 233.29 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.79 | 56.12 | 1.95 | 370.92 |
| http/js-1m | 1048576 | 6 | stdx | 24.98 | 46.64 | 1.87 | 747.80 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.37 | 120.65 | 1.58 | 499.87 |
| http/js-1m | 1048576 | 9 | stdx | 42.09 | 100.01 | 2.38 | 811.46 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.26 | 97.74 | 2.94 | 376.27 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.43 | 49.57 | 2.69 | 300.29 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.84 | 129.23 | 2.95 | 476.29 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.34 | 82.37 | 2.81 | 505.21 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.75 | 133.80 | 2.92 | 505.42 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.38 | 99.53 | 2.98 | 521.93 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.64 | 25.60 | 2.96 | 174.02 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.68 | 16.96 | 2.54 | 135.14 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.30 | 48.80 | 2.40 | 294.40 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.46 | 38.01 | 2.31 | 463.17 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.90 | 82.40 | 2.01 | 375.57 |
| http/css-16kx64 | 1048576 | 9 | stdx | 23.17 | 65.14 | 2.81 | 480.00 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.93 | 21.15 | 3.05 | 131.71 |
| http/css-1m | 1048576 | 1 | stdx | 5.79 | 14.91 | 2.58 | 108.65 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.80 | 44.50 | 2.14 | 227.02 |
| http/css-1m | 1048576 | 6 | stdx | 16.60 | 35.61 | 2.15 | 445.14 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.84 | 111.58 | 1.60 | 309.98 |
| http/css-1m | 1048576 | 9 | stdx | 32.14 | 83.00 | 2.58 | 511.54 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.26 | 48.89 | 1.94 | 934.81 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.13 | 49.19 | 2.71 | 322.55 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.56 | 86.45 | 2.08 | 1179.12 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.82 | 88.80 | 2.23 | 852.80 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.08 | 94.50 | 2.01 | 1347.38 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.54 | 134.38 | 2.46 | 1135.47 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.10 | 31.22 | 3.09 | 119.46 |
| silesia/dickens | 10192446 | 1 | stdx | 24.29 | 82.03 | 3.38 | 126.37 |
| silesia/dickens | 10192446 | 3 | libzstd | 22.57 | 34.39 | 1.52 | 170.98 |
| silesia/dickens | 10192446 | 3 | stdx | 35.65 | 78.22 | 2.19 | 183.56 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.01 | 22.69 | 3.23 | 71.20 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.62 | 54.73 | 3.11 | 175.20 |
| silesia/mozilla | 51220480 | 3 | libzstd | 16.67 | 27.89 | 1.67 | 102.64 |
| silesia/mozilla | 51220480 | 3 | stdx | 30.49 | 62.01 | 2.03 | 146.05 |
| silesia/mr | 9970564 | 1 | libzstd | 7.67 | 24.81 | 3.24 | 57.63 |
| silesia/mr | 9970564 | 1 | stdx | 19.95 | 66.82 | 3.35 | 116.75 |
| silesia/mr | 9970564 | 3 | libzstd | 19.74 | 32.19 | 1.63 | 86.91 |
| silesia/mr | 9970564 | 3 | stdx | 33.41 | 72.46 | 2.17 | 115.83 |
| silesia/nci | 33553445 | 1 | libzstd | 3.51 | 9.55 | 2.72 | 57.20 |
| silesia/nci | 33553445 | 1 | stdx | 7.72 | 25.69 | 3.33 | 60.37 |
| silesia/nci | 33553445 | 3 | libzstd | 5.75 | 9.95 | 1.73 | 56.57 |
| silesia/nci | 33553445 | 3 | stdx | 11.31 | 29.15 | 2.58 | 67.07 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.57 | 29.26 | 3.42 | 72.85 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.11 | 72.51 | 3.14 | 181.42 |
| silesia/ooffice | 6152192 | 3 | libzstd | 23.35 | 39.44 | 1.69 | 120.61 |
| silesia/ooffice | 6152192 | 3 | stdx | 41.75 | 82.20 | 1.97 | 187.36 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.05 | 22.29 | 3.16 | 66.54 |
| silesia/osdb | 10085684 | 1 | stdx | 16.41 | 50.52 | 3.08 | 123.26 |
| silesia/osdb | 10085684 | 3 | libzstd | 17.56 | 26.23 | 1.49 | 68.22 |
| silesia/osdb | 10085684 | 3 | stdx | 31.62 | 57.87 | 1.83 | 111.50 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.70 | 27.13 | 2.80 | 150.50 |
| silesia/reymont | 6627202 | 1 | stdx | 20.15 | 72.05 | 3.58 | 97.18 |
| silesia/reymont | 6627202 | 3 | libzstd | 18.15 | 27.10 | 1.49 | 126.42 |
| silesia/reymont | 6627202 | 3 | stdx | 28.01 | 62.18 | 2.22 | 147.43 |
| silesia/samba | 21606400 | 1 | libzstd | 6.04 | 16.88 | 2.79 | 85.58 |
| silesia/samba | 21606400 | 1 | stdx | 13.50 | 42.89 | 3.18 | 126.74 |
| silesia/samba | 21606400 | 3 | libzstd | 11.80 | 18.81 | 1.59 | 99.09 |
| silesia/samba | 21606400 | 3 | stdx | 20.27 | 44.75 | 2.21 | 134.41 |
| silesia/sao | 7251944 | 1 | libzstd | 9.04 | 33.69 | 3.72 | 45.46 |
| silesia/sao | 7251944 | 1 | stdx | 26.02 | 82.03 | 3.15 | 104.45 |
| silesia/sao | 7251944 | 3 | libzstd | 30.78 | 50.03 | 1.63 | 95.86 |
| silesia/sao | 7251944 | 3 | stdx | 51.09 | 95.22 | 1.86 | 143.25 |
| silesia/webster | 41458703 | 1 | libzstd | 8.65 | 24.94 | 2.88 | 131.05 |
| silesia/webster | 41458703 | 1 | stdx | 20.34 | 64.04 | 3.15 | 167.48 |
| silesia/webster | 41458703 | 3 | libzstd | 18.96 | 27.33 | 1.44 | 177.30 |
| silesia/webster | 41458703 | 3 | stdx | 30.75 | 64.55 | 2.10 | 195.67 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.78 | 14.92 | 3.12 | 17.27 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.95 | 76.64 | 3.20 | 92.99 |
| silesia/x-ray | 8474240 | 3 | libzstd | 31.46 | 52.73 | 1.68 | 88.04 |
| silesia/x-ray | 8474240 | 3 | stdx | 47.24 | 92.40 | 1.96 | 106.46 |
| silesia/xml | 5345280 | 1 | libzstd | 4.22 | 11.71 | 2.77 | 71.18 |
| silesia/xml | 5345280 | 1 | stdx | 10.39 | 34.21 | 3.29 | 95.34 |
| silesia/xml | 5345280 | 3 | libzstd | 6.65 | 12.61 | 1.90 | 77.69 |
| silesia/xml | 5345280 | 3 | stdx | 12.77 | 32.28 | 2.53 | 116.43 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.77 | 32.84 | 3.05 | 139.22 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.38 | 76.49 | 3.42 | 190.02 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.82 | 39.48 | 2.50 | 202.37 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.18 | 73.76 | 2.82 | 339.39 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.71 | 33.55 | 3.46 | 102.54 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.51 | 79.00 | 3.36 | 219.63 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.20 | 39.27 | 2.58 | 209.08 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.12 | 79.30 | 2.82 | 380.08 |
| canterbury/cp.html | 24603 | 1 | libzstd | 7.03 | 26.64 | 3.79 | 43.15 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.12 | 57.76 | 3.58 | 121.83 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.49 | 31.85 | 3.36 | 46.56 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.35 | 59.76 | 3.26 | 156.58 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.69 | 31.76 | 3.65 | 42.78 |
| canterbury/fields.c | 11150 | 1 | stdx | 17.04 | 65.73 | 3.86 | 89.88 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.32 | 34.14 | 3.66 | 28.54 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.48 | 64.68 | 3.70 | 101.79 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.41 | 38.01 | 4.04 | 8.91 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.29 | 77.57 | 3.82 | 52.73 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.65 | 43.09 | 4.04 | 8.59 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.47 | 79.60 | 3.71 | 68.40 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.04 | 23.56 | 3.90 | 14.79 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.76 | 56.75 | 3.85 | 87.03 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.52 | 23.80 | 2.80 | 27.26 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 20.32 | 56.61 | 2.79 | 111.24 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.83 | 28.52 | 2.90 | 156.02 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.38 | 72.02 | 3.37 | 162.74 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 16.76 | 32.14 | 1.92 | 203.12 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.41 | 67.10 | 2.54 | 299.48 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.31 | 32.37 | 3.14 | 129.21 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.01 | 84.16 | 3.36 | 160.49 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 20.55 | 38.77 | 1.89 | 227.94 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 31.73 | 80.77 | 2.55 | 347.65 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.15 | 8.51 | 2.71 | 66.49 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.55 | 23.15 | 3.07 | 106.87 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 4.94 | 10.97 | 2.22 | 59.92 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.43 | 24.08 | 2.55 | 134.11 |
| canterbury/sum | 38240 | 1 | libzstd | 6.58 | 25.39 | 3.86 | 34.10 |
| canterbury/sum | 38240 | 1 | stdx | 17.00 | 59.13 | 3.48 | 156.40 |
| canterbury/sum | 38240 | 3 | libzstd | 9.06 | 30.67 | 3.38 | 48.68 |
| canterbury/sum | 38240 | 3 | stdx | 19.73 | 61.82 | 3.13 | 192.54 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 9.96 | 39.82 | 4.00 | 12.60 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.97 | 80.38 | 3.83 | 62.37 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.21 | 48.17 | 3.94 | 16.82 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.98 | 83.98 | 3.65 | 84.14 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.34 | 33.44 | 3.23 | 76.66 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.86 | 95.62 | 4.37 | 7.29 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 15.20 | 31.30 | 2.06 | 35.84 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.94 | 70.38 | 2.94 | 38.36 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.71 | 27.45 | 2.83 | 149.34 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.41 | 71.86 | 3.52 | 109.44 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 18.07 | 28.20 | 1.56 | 132.63 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 27.90 | 63.36 | 2.27 | 155.82 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.14 | 22.70 | 2.79 | 137.40 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.69 | 55.86 | 2.99 | 195.60 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 15.39 | 23.87 | 1.55 | 174.01 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 25.06 | 51.26 | 2.05 | 239.02 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 16.97 | 52.46 | 3.09 | 159.52 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 36.21 | 100.54 | 2.78 | 644.75 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 18.94 | 59.20 | 3.13 | 195.08 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 38.48 | 104.00 | 2.70 | 640.39 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.74 | 22.46 | 2.90 | 122.45 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.68 | 46.84 | 3.19 | 183.90 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.83 | 24.61 | 2.79 | 143.34 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.56 | 47.61 | 3.06 | 193.01 |
| http/html-1m | 1048576 | 1 | libzstd | 6.22 | 16.74 | 2.69 | 114.61 |
| http/html-1m | 1048576 | 1 | stdx | 12.95 | 42.00 | 3.24 | 136.06 |
| http/html-1m | 1048576 | 3 | libzstd | 9.38 | 18.18 | 1.94 | 126.43 |
| http/html-1m | 1048576 | 3 | stdx | 15.69 | 39.37 | 2.51 | 178.31 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.24 | 42.52 | 2.99 | 115.35 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.93 | 83.13 | 2.78 | 539.38 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.74 | 44.54 | 3.02 | 129.14 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.84 | 84.87 | 2.75 | 543.24 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.78 | 14.98 | 3.14 | 57.39 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.72 | 33.78 | 3.48 | 117.88 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.32 | 16.21 | 3.05 | 71.94 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.74 | 34.58 | 3.22 | 124.31 |
| http/json-1m | 1048576 | 1 | libzstd | 4.04 | 12.55 | 3.11 | 52.43 |
| http/json-1m | 1048576 | 1 | stdx | 8.99 | 30.70 | 3.41 | 87.24 |
| http/json-1m | 1048576 | 3 | libzstd | 6.14 | 13.78 | 2.24 | 68.47 |
| http/json-1m | 1048576 | 3 | stdx | 11.36 | 30.64 | 2.70 | 121.47 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.46 | 57.26 | 3.10 | 183.72 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 40.30 | 113.49 | 2.82 | 704.53 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.30 | 65.54 | 3.08 | 259.56 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.36 | 116.54 | 2.75 | 696.47 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.81 | 26.52 | 3.01 | 127.25 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.68 | 55.71 | 3.34 | 202.48 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.03 | 28.74 | 2.86 | 153.41 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.87 | 55.35 | 3.10 | 212.19 |
| http/js-1m | 1048576 | 1 | libzstd | 6.51 | 17.87 | 2.74 | 113.78 |
| http/js-1m | 1048576 | 1 | stdx | 13.99 | 45.88 | 3.28 | 137.71 |
| http/js-1m | 1048576 | 3 | libzstd | 10.07 | 19.14 | 1.90 | 126.12 |
| http/js-1m | 1048576 | 3 | stdx | 17.09 | 41.25 | 2.41 | 188.29 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.47 | 46.90 | 3.03 | 136.84 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.65 | 91.65 | 2.81 | 586.44 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.53 | 50.53 | 3.06 | 158.57 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.84 | 93.63 | 2.77 | 585.35 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.11 | 18.99 | 3.11 | 78.39 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.47 | 43.79 | 3.51 | 139.01 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.55 | 19.41 | 2.96 | 95.45 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.98 | 42.34 | 3.26 | 154.39 |
| http/css-1m | 1048576 | 1 | libzstd | 1.49 | 4.59 | 3.07 | 21.75 |
| http/css-1m | 1048576 | 1 | stdx | 3.99 | 14.85 | 3.72 | 30.56 |
| http/css-1m | 1048576 | 3 | libzstd | 1.97 | 5.25 | 2.66 | 19.77 |
| http/css-1m | 1048576 | 3 | stdx | 3.96 | 13.33 | 3.37 | 31.90 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.52 | 12.79 | 3.64 | 6.15 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.15 | 30.66 | 3.35 | 62.82 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 27.94 | 50.53 | 1.81 | 52.56 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 21.03 | 47.43 | 2.26 | 213.90 |

## Hardware counters per input octet, brotli encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | Google q1 | 18.03 | 30.24 | 1.68 | 232.29 |
| silesia/dickens | 10192446 | stdx 1 | 19.50 | 43.43 | 2.23 | 413.28 |
| silesia/dickens | 10192446 | Google q5 | 101.90 | 194.36 | 1.91 | 820.92 |
| silesia/dickens | 10192446 | stdx 5 | 71.88 | 155.43 | 2.16 | 987.63 |
| silesia/mozilla | 51220480 | Google q1 | 12.98 | 25.26 | 1.95 | 144.67 |
| silesia/mozilla | 51220480 | stdx 1 | 12.34 | 32.95 | 2.67 | 213.39 |
| silesia/mozilla | 51220480 | Google q5 | 62.91 | 149.30 | 2.37 | 796.86 |
| silesia/mozilla | 51220480 | stdx 5 | 60.60 | 148.04 | 2.44 | 814.79 |
| silesia/mr | 9970564 | Google q1 | 13.02 | 26.14 | 2.01 | 97.91 |
| silesia/mr | 9970564 | stdx 1 | 13.77 | 37.80 | 2.75 | 165.25 |
| silesia/mr | 9970564 | Google q5 | 81.60 | 177.41 | 2.17 | 607.28 |
| silesia/mr | 9970564 | stdx 5 | 67.38 | 149.01 | 2.21 | 703.83 |
| silesia/nci | 33553445 | Google q1 | 5.21 | 9.71 | 1.86 | 89.38 |
| silesia/nci | 33553445 | stdx 1 | 6.08 | 14.48 | 2.38 | 127.87 |
| silesia/nci | 33553445 | Google q5 | 31.18 | 59.01 | 1.89 | 409.61 |
| silesia/nci | 33553445 | stdx 5 | 30.36 | 58.51 | 1.93 | 487.35 |
| silesia/ooffice | 6152192 | Google q1 | 17.24 | 33.43 | 1.94 | 154.58 |
| silesia/ooffice | 6152192 | stdx 1 | 16.91 | 45.85 | 2.71 | 266.46 |
| silesia/ooffice | 6152192 | Google q5 | 86.89 | 198.80 | 2.29 | 1064.63 |
| silesia/ooffice | 6152192 | stdx 5 | 73.76 | 178.18 | 2.42 | 1076.57 |
| silesia/osdb | 10085684 | Google q1 | 12.29 | 23.47 | 1.91 | 84.46 |
| silesia/osdb | 10085684 | stdx 1 | 11.71 | 32.00 | 2.73 | 140.92 |
| silesia/osdb | 10085684 | Google q5 | 66.88 | 146.01 | 2.18 | 544.93 |
| silesia/osdb | 10085684 | stdx 5 | 53.63 | 123.53 | 2.30 | 521.49 |
| silesia/reymont | 6627202 | Google q1 | 15.31 | 25.54 | 1.67 | 208.27 |
| silesia/reymont | 6627202 | stdx 1 | 14.54 | 33.36 | 2.29 | 284.73 |
| silesia/reymont | 6627202 | Google q5 | 80.55 | 169.16 | 2.10 | 798.14 |
| silesia/reymont | 6627202 | stdx 5 | 63.78 | 139.71 | 2.19 | 907.51 |
| silesia/samba | 21606400 | Google q1 | 9.77 | 17.38 | 1.78 | 127.99 |
| silesia/samba | 21606400 | stdx 1 | 9.93 | 23.94 | 2.41 | 196.54 |
| silesia/samba | 21606400 | Google q5 | 47.10 | 105.54 | 2.24 | 478.22 |
| silesia/samba | 21606400 | stdx 5 | 43.72 | 102.32 | 2.34 | 531.02 |
| silesia/sao | 7251944 | Google q1 | 20.44 | 39.96 | 1.95 | 100.96 |
| silesia/sao | 7251944 | stdx 1 | 18.82 | 55.66 | 2.96 | 190.08 |
| silesia/sao | 7251944 | Google q5 | 106.70 | 259.63 | 2.43 | 925.72 |
| silesia/sao | 7251944 | stdx 5 | 87.78 | 229.67 | 2.62 | 755.57 |
| silesia/webster | 41458703 | Google q1 | 14.46 | 24.40 | 1.69 | 208.69 |
| silesia/webster | 41458703 | stdx 1 | 15.31 | 34.12 | 2.23 | 339.20 |
| silesia/webster | 41458703 | Google q5 | 74.95 | 141.82 | 1.89 | 754.17 |
| silesia/webster | 41458703 | stdx 5 | 63.23 | 121.03 | 1.91 | 852.98 |
| silesia/x-ray | 8474240 | Google q1 | 13.83 | 22.03 | 1.59 | 12.43 |
| silesia/x-ray | 8474240 | stdx 1 | 13.17 | 38.68 | 2.94 | 94.84 |
| silesia/x-ray | 8474240 | Google q5 | 98.15 | 236.76 | 2.41 | 725.27 |
| silesia/x-ray | 8474240 | stdx 5 | 85.11 | 226.78 | 2.66 | 644.92 |
| silesia/xml | 5345280 | Google q1 | 6.98 | 12.28 | 1.76 | 113.68 |
| silesia/xml | 5345280 | stdx 1 | 7.42 | 17.44 | 2.35 | 152.68 |
| silesia/xml | 5345280 | Google q5 | 32.17 | 72.50 | 2.25 | 358.60 |
| silesia/xml | 5345280 | stdx 5 | 29.74 | 64.66 | 2.17 | 413.70 |
| canterbury/alice29.txt | 152089 | Google q1 | 16.88 | 29.72 | 1.76 | 208.79 |
| canterbury/alice29.txt | 152089 | stdx 1 | 18.31 | 40.79 | 2.23 | 445.03 |
| canterbury/alice29.txt | 152089 | Google q5 | 80.06 | 200.77 | 2.51 | 1038.98 |
| canterbury/alice29.txt | 152089 | stdx 5 | 67.63 | 150.37 | 2.22 | 906.35 |
| canterbury/asyoulik.txt | 125179 | Google q1 | 17.79 | 32.37 | 1.82 | 221.70 |
| canterbury/asyoulik.txt | 125179 | stdx 1 | 20.04 | 44.50 | 2.22 | 498.76 |
| canterbury/asyoulik.txt | 125179 | Google q5 | 85.35 | 215.27 | 2.52 | 1079.95 |
| canterbury/asyoulik.txt | 125179 | stdx 5 | 75.15 | 162.29 | 2.16 | 1049.62 |
| canterbury/cp.html | 24603 | Google q1 | 12.88 | 27.30 | 2.12 | 94.53 |
| canterbury/cp.html | 24603 | stdx 1 | 14.52 | 36.07 | 2.48 | 344.01 |
| canterbury/cp.html | 24603 | Google q5 | 60.34 | 163.89 | 2.72 | 946.28 |
| canterbury/cp.html | 24603 | stdx 5 | 56.79 | 131.75 | 2.32 | 721.63 |
| canterbury/fields.c | 11150 | Google q1 | 11.98 | 29.04 | 2.42 | 11.55 |
| canterbury/fields.c | 11150 | stdx 1 | 10.45 | 38.87 | 3.72 | 87.01 |
| canterbury/fields.c | 11150 | Google q5 | 58.50 | 168.16 | 2.87 | 896.11 |
| canterbury/fields.c | 11150 | stdx 5 | 43.98 | 123.30 | 2.80 | 544.18 |
| canterbury/grammar.lsp | 3721 | Google q1 | 14.30 | 39.39 | 2.76 | 7.82 |
| canterbury/grammar.lsp | 3721 | stdx 1 | 13.58 | 55.22 | 4.07 | 34.22 |
| canterbury/grammar.lsp | 3721 | Google q5 | 60.69 | 203.91 | 3.36 | 440.42 |
| canterbury/grammar.lsp | 3721 | stdx 5 | 40.98 | 148.73 | 3.63 | 143.24 |
| canterbury/kennedy.xls | 1029744 | Google q1 | 9.76 | 24.83 | 2.54 | 59.52 |
| canterbury/kennedy.xls | 1029744 | stdx 1 | 7.81 | 27.03 | 3.46 | 76.16 |
| canterbury/kennedy.xls | 1029744 | Google q5 | 47.74 | 162.91 | 3.41 | 262.66 |
| canterbury/kennedy.xls | 1029744 | stdx 5 | 52.04 | 162.45 | 3.12 | 476.04 |
| canterbury/lcet10.txt | 426754 | Google q1 | 16.12 | 27.19 | 1.69 | 202.41 |
| canterbury/lcet10.txt | 426754 | stdx 1 | 16.80 | 37.84 | 2.25 | 379.04 |
| canterbury/lcet10.txt | 426754 | Google q5 | 78.14 | 187.58 | 2.40 | 958.33 |
| canterbury/lcet10.txt | 426754 | stdx 5 | 64.85 | 140.50 | 2.17 | 913.36 |
| canterbury/plrabn12.txt | 481861 | Google q1 | 19.16 | 32.57 | 1.70 | 250.42 |
| canterbury/plrabn12.txt | 481861 | stdx 1 | 20.84 | 46.66 | 2.24 | 472.03 |
| canterbury/plrabn12.txt | 481861 | Google q5 | 96.36 | 229.77 | 2.38 | 1065.77 |
| canterbury/plrabn12.txt | 481861 | stdx 5 | 81.46 | 168.65 | 2.07 | 1192.58 |
| canterbury/ptt5 | 513216 | Google q1 | 5.02 | 9.55 | 1.90 | 80.49 |
| canterbury/ptt5 | 513216 | stdx 1 | 6.64 | 15.64 | 2.36 | 160.16 |
| canterbury/ptt5 | 513216 | Google q5 | 27.51 | 68.87 | 2.50 | 468.08 |
| canterbury/ptt5 | 513216 | stdx 5 | 29.74 | 69.96 | 2.35 | 468.36 |
| canterbury/sum | 38240 | Google q1 | 12.97 | 29.25 | 2.25 | 89.41 |
| canterbury/sum | 38240 | stdx 1 | 15.40 | 36.37 | 2.36 | 397.57 |
| canterbury/sum | 38240 | Google q5 | 65.87 | 182.58 | 2.77 | 1095.91 |
| canterbury/sum | 38240 | stdx 5 | 64.49 | 159.26 | 2.47 | 840.18 |
| canterbury/xargs.1 | 4227 | Google q1 | 16.17 | 43.16 | 2.67 | 14.01 |
| canterbury/xargs.1 | 4227 | stdx 1 | 14.75 | 59.10 | 4.01 | 45.11 |
| canterbury/xargs.1 | 4227 | Google q5 | 71.01 | 219.02 | 3.08 | 767.98 |
| canterbury/xargs.1 | 4227 | stdx 5 | 48.03 | 159.53 | 3.32 | 260.57 |
| canterbury-large/E.coli | 4638690 | Google q1 | 13.57 | 27.46 | 2.02 | 53.37 |
| canterbury-large/E.coli | 4638690 | stdx 1 | 5.70 | 19.24 | 3.37 | 18.03 |
| canterbury-large/E.coli | 4638690 | Google q5 | 90.80 | 262.67 | 2.89 | 999.94 |
| canterbury-large/E.coli | 4638690 | stdx 5 | 31.58 | 93.28 | 2.95 | 64.14 |
| canterbury-large/bible.txt | 4047392 | Google q1 | 14.65 | 24.57 | 1.68 | 175.33 |
| canterbury-large/bible.txt | 4047392 | stdx 1 | 15.33 | 34.29 | 2.24 | 315.76 |
| canterbury-large/bible.txt | 4047392 | Google q5 | 78.42 | 165.65 | 2.11 | 729.16 |
| canterbury-large/bible.txt | 4047392 | stdx 5 | 59.96 | 134.16 | 2.24 | 810.42 |
| canterbury-large/world192.txt | 2473400 | Google q1 | 13.41 | 22.62 | 1.69 | 195.05 |
| canterbury-large/world192.txt | 2473400 | stdx 1 | 13.80 | 31.07 | 2.25 | 314.08 |
| canterbury-large/world192.txt | 2473400 | Google q5 | 66.10 | 129.46 | 1.96 | 739.01 |
| canterbury-large/world192.txt | 2473400 | stdx 5 | 54.19 | 105.07 | 1.94 | 773.19 |
| http/html-1kx1024 | 1048576 | Google q1 | 32.22 | 62.53 | 1.94 | 861.51 |
| http/html-1kx1024 | 1048576 | stdx 1 | 27.49 | 80.73 | 2.94 | 472.58 |
| http/html-1kx1024 | 1048576 | Google q5 | 107.10 | 260.90 | 2.44 | 2116.46 |
| http/html-1kx1024 | 1048576 | stdx 5 | 68.28 | 169.39 | 2.48 | 1181.48 |
| http/html-16kx64 | 1048576 | Google q1 | 11.25 | 20.38 | 1.81 | 215.03 |
| http/html-16kx64 | 1048576 | stdx 1 | 11.53 | 28.46 | 2.47 | 301.46 |
| http/html-16kx64 | 1048576 | Google q5 | 46.80 | 118.53 | 2.53 | 854.82 |
| http/html-16kx64 | 1048576 | stdx 5 | 40.93 | 92.79 | 2.27 | 667.25 |
| http/html-1m | 1048576 | Google q1 | 8.89 | 15.15 | 1.70 | 137.67 |
| http/html-1m | 1048576 | stdx 1 | 9.70 | 22.18 | 2.29 | 225.64 |
| http/html-1m | 1048576 | Google q5 | 44.55 | 104.93 | 2.36 | 573.14 |
| http/html-1m | 1048576 | stdx 5 | 37.22 | 84.09 | 2.26 | 543.38 |
| http/json-1kx1024 | 1048576 | Google q1 | 24.65 | 49.87 | 2.02 | 653.32 |
| http/json-1kx1024 | 1048576 | stdx 1 | 21.09 | 61.64 | 2.92 | 364.09 |
| http/json-1kx1024 | 1048576 | Google q5 | 80.24 | 203.15 | 2.53 | 1340.33 |
| http/json-1kx1024 | 1048576 | stdx 5 | 50.80 | 132.48 | 2.61 | 733.97 |
| http/json-16kx64 | 1048576 | Google q1 | 7.60 | 14.90 | 1.96 | 141.98 |
| http/json-16kx64 | 1048576 | stdx 1 | 7.06 | 19.73 | 2.79 | 158.81 |
| http/json-16kx64 | 1048576 | Google q5 | 36.06 | 97.81 | 2.71 | 556.81 |
| http/json-16kx64 | 1048576 | stdx 5 | 36.23 | 89.00 | 2.46 | 531.68 |
| http/json-1m | 1048576 | Google q1 | 6.14 | 12.65 | 2.06 | 92.09 |
| http/json-1m | 1048576 | stdx 1 | 6.65 | 17.21 | 2.59 | 139.80 |
| http/json-1m | 1048576 | Google q5 | 36.51 | 96.08 | 2.63 | 445.97 |
| http/json-1m | 1048576 | stdx 5 | 39.16 | 92.44 | 2.36 | 574.58 |
| http/js-1kx1024 | 1048576 | Google q1 | 34.83 | 68.18 | 1.96 | 906.55 |
| http/js-1kx1024 | 1048576 | stdx 1 | 30.56 | 90.40 | 2.96 | 530.23 |
| http/js-1kx1024 | 1048576 | Google q5 | 118.48 | 288.57 | 2.44 | 2311.11 |
| http/js-1kx1024 | 1048576 | stdx 5 | 76.62 | 188.24 | 2.46 | 1319.24 |
| http/js-16kx64 | 1048576 | Google q1 | 13.10 | 24.07 | 1.84 | 231.40 |
| http/js-16kx64 | 1048576 | stdx 1 | 13.45 | 32.69 | 2.43 | 353.48 |
| http/js-16kx64 | 1048576 | Google q5 | 55.02 | 141.15 | 2.57 | 995.25 |
| http/js-16kx64 | 1048576 | stdx 5 | 47.82 | 107.16 | 2.24 | 789.73 |
| http/js-1m | 1048576 | Google q1 | 9.69 | 16.69 | 1.72 | 140.75 |
| http/js-1m | 1048576 | stdx 1 | 10.17 | 23.55 | 2.32 | 228.47 |
| http/js-1m | 1048576 | Google q5 | 49.99 | 116.02 | 2.32 | 634.99 |
| http/js-1m | 1048576 | stdx 5 | 39.74 | 90.08 | 2.27 | 591.27 |
| http/css-1kx1024 | 1048576 | Google q1 | 27.69 | 54.06 | 1.95 | 737.14 |
| http/css-1kx1024 | 1048576 | stdx 1 | 23.72 | 68.32 | 2.88 | 431.77 |
| http/css-1kx1024 | 1048576 | Google q5 | 87.17 | 213.92 | 2.45 | 1654.16 |
| http/css-1kx1024 | 1048576 | stdx 5 | 54.19 | 139.00 | 2.56 | 905.17 |
| http/css-16kx64 | 1048576 | Google q1 | 8.94 | 16.85 | 1.88 | 140.26 |
| http/css-16kx64 | 1048576 | stdx 1 | 8.56 | 23.62 | 2.76 | 192.38 |
| http/css-16kx64 | 1048576 | Google q5 | 37.53 | 100.68 | 2.68 | 646.97 |
| http/css-16kx64 | 1048576 | stdx 5 | 31.83 | 81.52 | 2.56 | 494.85 |
| http/css-1m | 1048576 | Google q1 | 5.97 | 11.27 | 1.89 | 75.99 |
| http/css-1m | 1048576 | stdx 1 | 5.45 | 14.38 | 2.64 | 110.48 |
| http/css-1m | 1048576 | Google q5 | 14.44 | 38.50 | 2.67 | 129.85 |
| http/css-1m | 1048576 | stdx 5 | 14.54 | 36.87 | 2.53 | 111.57 |
| shuffled/dickens-1m | 1048576 | Google q1 | 11.41 | 20.96 | 1.84 | 2.80 |
| shuffled/dickens-1m | 1048576 | stdx 1 | 5.36 | 19.75 | 3.68 | 16.87 |
| shuffled/dickens-1m | 1048576 | Google q5 | 93.35 | 235.57 | 2.52 | 723.08 |
| shuffled/dickens-1m | 1048576 | stdx 5 | 45.63 | 123.05 | 2.70 | 254.28 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.3 | 74.2 | 0.119 | 2.99 | 2.93 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 65.8 | 219.6 | 0.086 | 7.77 | 3.34 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 30.6 | 96.1 | 0.162 | 3.62 | 3.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextReader.next_items | 28.4 | 80.8 | 0.154 | 3.35 | 2.85 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 252.1 | 1024.0 | 0.828 | 29.78 | 4.06 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.8 | 107.7 | 0.132 | 3.63 | 3.50 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.2 | 106.2 | 0.306 | 3.33 | 3.77 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.4 | 378.2 | 0.389 | 11.27 | 3.96 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 43.0 | 161.9 | 0.470 | 5.08 | 3.77 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 92.0 | 451.7 | 0.311 | 10.86 | 4.91 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.5 | 89.5 | 0.004 | 4.05 | 3.26 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.6 | 234.7 | 0.053 | 10.10 | 3.42 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 29.4 | 99.4 | 0.011 | 4.32 | 3.38 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextReader.next_items | 27.3 | 84.2 | 0.008 | 4.01 | 3.09 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 218.1 | 819.1 | 0.973 | 32.10 | 3.76 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.3 | 107.7 | 0.040 | 4.17 | 3.81 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 32.1 | 106.0 | 0.047 | 4.73 | 3.30 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 95.6 | 346.2 | 0.386 | 14.07 | 3.62 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 33.4 | 144.5 | 0.052 | 4.91 | 4.33 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 96.8 | 406.5 | 0.103 | 14.25 | 4.20 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 115210.0 | 403846.2 | 539.196 | 0.67 | 3.51 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 595214.9 | 2503286.2 | 1383.897 | 3.45 | 4.21 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 114677.4 | 404249.2 | 505.371 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, TextReader.next_items | 114665.2 | 404282.2 | 504.753 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3587715.3 | 18223876.2 | 2976.299 | 20.79 | 5.08 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311160.2 | 621744.2 | 580.969 | 1.80 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 224721.0 | 826630.2 | 2279.784 | 1.30 | 3.68 |
| string: silesia/dickens | 1 | 172528 | std.json | 1623946.6 | 4578768.2 | 43931.969 | 9.41 | 2.82 |
| string: silesia/dickens | 1 | 172528 | serde_json | 203158.4 | 802391.2 | 997.258 | 1.18 | 3.95 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1049110.3 | 5276111.6 | 4912.515 | 6.08 | 5.03 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1574169.3 | 4799763.6 | 1513.429 | 1.32 | 3.05 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14307126.9 | 56816152.6 | 39219.500 | 12.02 | 3.97 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1572641.9 | 4799955.6 | 1352.143 | 1.32 | 3.05 |
| string: http/json-1m | 1 | 1190272 | stdx, TextReader.next_items | 1571443.3 | 4799988.6 | 1331.857 | 1.32 | 3.05 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 29080594.1 | 132108253.6 | 159347.000 | 24.43 | 4.54 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4587023.9 | 7062781.6 | 556.643 | 3.85 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1809952.1 | 7322029.6 | 14608.786 | 1.52 | 4.05 |
| string: http/json-1m | 1 | 1190272 | std.json | 10310914.8 | 47381213.6 | 31651.143 | 8.66 | 4.60 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3813956.9 | 15226459.6 | 6248.143 | 3.20 | 3.99 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9026236.2 | 47987771.0 | 27638.143 | 7.58 | 5.32 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2068282.9 | 5765413.8 | 4376.375 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6184703.6 | 22589263.8 | 6934.125 | 3.28 | 3.65 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2059541.0 | 5765605.8 | 3915.375 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextReader.next_items | 2057510.6 | 5765638.8 | 3789.875 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47346298.4 | 227842320.8 | 281662.375 | 25.14 | 4.81 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3778054.6 | 8446023.8 | 2018.250 | 2.01 | 2.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7229587.5 | 12276717.8 | 277114.375 | 3.84 | 1.70 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 18202310.0 | 63617055.8 | 219888.125 | 9.67 | 3.49 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9428978.1 | 24440755.8 | 326219.125 | 5.01 | 2.59 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39468910.9 | 160311132.4 | 794521.250 | 20.96 | 4.06 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12903004.7 | 42561069.3 | 243846.000 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 160330866.7 | 667246747.3 | 394605.333 | 31.59 | 4.16 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12937537.3 | 42561261.3 | 244309.667 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextReader.next_items | 12954828.7 | 42561294.3 | 243970.000 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 159370308.3 | 639992662.3 | 423463.333 | 31.40 | 4.02 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17507475.7 | 49745820.3 | 252247.667 | 3.45 | 2.84 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14306001.7 | 45615166.3 | 453663.667 | 2.82 | 3.19 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79485701.7 | 314900845.3 | 481720.667 | 15.66 | 3.96 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36026460.7 | 131556135.3 | 587803.000 | 7.10 | 3.65 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 67101327.7 | 273924866.7 | 837148.000 | 13.22 | 4.08 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 94244.8 | 303836.7 | 6.355 | 0.18 | 3.22 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 188253.4 | 623465.7 | 10.000 | 0.36 | 3.31 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 148284.6 | 557622.7 | 6.065 | 0.28 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextReader.next_items | 148288.2 | 557626.7 | 6.226 | 0.28 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10282758.9 | 53478202.7 | 8.774 | 19.61 | 5.20 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 490375.5 | 1376733.7 | 6.161 | 0.94 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 537373.3 | 2195917.7 | 8.806 | 1.02 | 4.09 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3462210.5 | 12808414.7 | 60970.613 | 6.60 | 3.70 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 297604.8 | 1179969.7 | 6.323 | 0.57 | 3.96 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2252446.0 | 12787544.3 | 246.032 | 4.30 | 5.68 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.8 | 81.8 | 0.109 | 2.34 | 4.12 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.1 | 153.5 | 0.129 | 4.15 | 4.38 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 21.0 | 93.4 | 0.090 | 2.48 | 4.44 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 218.3 | 981.0 | 0.932 | 25.79 | 4.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 19.3 | 79.5 | 0.105 | 2.28 | 4.11 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.3 | 94.1 | 0.136 | 2.75 | 4.04 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.4 | 105.6 | 0.246 | 3.24 | 3.85 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.7 | 310.8 | 0.353 | 8.24 | 4.46 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.6 | 255.3 | 0.510 | 7.52 | 4.01 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.3 | 315.1 | 0.234 | 8.07 | 4.61 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.8 | 82.8 | 0.025 | 2.77 | 4.40 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.1 | 153.9 | 0.026 | 5.31 | 4.26 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 22.1 | 94.2 | 0.024 | 3.25 | 4.26 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 169.3 | 718.3 | 1.252 | 24.91 | 4.24 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.4 | 81.5 | 0.024 | 2.70 | 4.44 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 22.5 | 96.8 | 0.032 | 3.31 | 4.30 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.8 | 117.9 | 0.032 | 4.39 | 3.96 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 60.2 | 271.2 | 0.247 | 8.86 | 4.50 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 48.4 | 211.0 | 0.034 | 7.12 | 4.36 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 82.6 | 331.7 | 0.082 | 12.16 | 4.02 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 84786.2 | 280786.2 | 715.010 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84546.5 | 280732.2 | 707.691 | 0.49 | 3.32 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84546.4 | 280721.2 | 705.371 | 0.49 | 3.32 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3354447.4 | 16047574.2 | 2946.546 | 19.44 | 4.78 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 83073.6 | 274401.2 | 661.588 | 0.48 | 3.30 |
| string: silesia/dickens | 1 | 172528 | simdjson | 206817.6 | 674016.2 | 2033.887 | 1.20 | 3.26 |
| string: silesia/dickens | 1 | 172528 | yyjson | 204710.9 | 825518.2 | 1064.474 | 1.19 | 4.03 |
| string: silesia/dickens | 1 | 172528 | std.json | 1365565.9 | 2890892.2 | 50111.268 | 7.92 | 2.12 |
| string: silesia/dickens | 1 | 172528 | serde_json | 372058.0 | 1586249.2 | 2253.526 | 2.16 | 4.26 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 578060.9 | 2970285.3 | 2322.722 | 3.35 | 5.14 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1283462.6 | 3582350.6 | 12030.571 | 1.08 | 2.79 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1271855.8 | 3582290.6 | 11557.357 | 1.07 | 2.82 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1272709.8 | 3582277.6 | 11615.714 | 1.07 | 2.81 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25271549.0 | 109856348.6 | 140813.929 | 21.23 | 4.35 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1235306.9 | 3370022.6 | 11299.429 | 1.04 | 2.73 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2975909.9 | 10460762.6 | 29399.214 | 2.50 | 3.52 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2581616.8 | 10197931.6 | 9207.571 | 2.17 | 3.95 |
| string: http/json-1m | 1 | 1190272 | std.json | 9129422.4 | 43287986.6 | 17951.857 | 7.67 | 4.74 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4195750.4 | 17941088.6 | 10903.857 | 3.53 | 4.28 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5264515.0 | 26999739.4 | 11245.500 | 4.42 | 5.13 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2079188.8 | 6088099.8 | 4684.250 | 1.10 | 2.93 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2065693.5 | 6088039.8 | 4135.250 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2068332.8 | 6088026.8 | 4068.250 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43527887.3 | 193466548.8 | 265414.250 | 23.12 | 4.44 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2072645.4 | 5875346.8 | 4735.000 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2711942.3 | 7144143.8 | 21090.875 | 1.44 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12176300.9 | 23590602.8 | 447500.250 | 6.47 | 1.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20812404.4 | 56837736.8 | 535512.500 | 11.05 | 2.73 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11617076.3 | 33662338.8 | 327071.125 | 6.17 | 2.90 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18777661.0 | 76319473.5 | 248503.250 | 9.97 | 4.06 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113284.4 | 426376.7 | 4.032 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113041.9 | 426318.7 | 2.613 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113048.4 | 426305.7 | 2.710 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 635752.1 | 3146479.7 | 5.871 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113057.0 | 426343.7 | 2.645 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1202808.6 | 3866916.7 | 5.613 | 2.29 | 3.21 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1630810.6 | 5833341.7 | 4.613 | 3.11 | 3.58 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3572155.9 | 13108830.7 | 62151.613 | 6.81 | 3.67 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1774059.3 | 7405810.7 | 4.032 | 3.38 | 4.17 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2396359.7 | 12748352.5 | 17.000 | 4.57 | 5.32 |
