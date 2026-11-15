# bench-profile

| Field | Value |
|---|---|
| Commit | e59f48c |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43674622589 |
| Date | 2026-11-15 |

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
| silesia/dickens | 10192446 | zlib | 8.82 | 19.08 | 2.16 | 311.21 |
| silesia/dickens | 10192446 | zlib-ng | 4.87 | 10.50 | 2.16 | 67.50 |
| silesia/dickens | 10192446 | libdeflate | 3.45 | 9.56 | 2.77 | 66.42 |
| silesia/dickens | 10192446 | Wuffs | 5.54 | 13.90 | 2.51 | 97.61 |
| silesia/dickens | 10192446 | stdx | 2.93 | 7.15 | 2.44 | 75.68 |
| silesia/mozilla | 51220480 | zlib | 8.49 | 17.23 | 2.03 | 251.81 |
| silesia/mozilla | 51220480 | zlib-ng | 4.95 | 8.95 | 1.81 | 85.44 |
| silesia/mozilla | 51220480 | libdeflate | 3.48 | 7.63 | 2.20 | 71.13 |
| silesia/mozilla | 51220480 | Wuffs | 6.40 | 13.89 | 2.17 | 132.58 |
| silesia/mozilla | 51220480 | stdx | 3.64 | 6.29 | 1.73 | 89.41 |
| silesia/mr | 9970564 | zlib | 8.41 | 18.46 | 2.19 | 203.33 |
| silesia/mr | 9970564 | zlib-ng | 4.79 | 9.98 | 2.08 | 67.80 |
| silesia/mr | 9970564 | libdeflate | 3.35 | 8.58 | 2.56 | 61.04 |
| silesia/mr | 9970564 | Wuffs | 5.99 | 14.04 | 2.34 | 99.98 |
| silesia/mr | 9970564 | stdx | 3.07 | 6.70 | 2.18 | 69.70 |
| silesia/nci | 33553445 | zlib | 3.59 | 10.18 | 2.84 | 81.22 |
| silesia/nci | 33553445 | zlib-ng | 1.62 | 3.13 | 1.94 | 33.72 |
| silesia/nci | 33553445 | libdeflate | 1.21 | 2.66 | 2.20 | 29.78 |
| silesia/nci | 33553445 | Wuffs | 2.51 | 6.47 | 2.58 | 41.51 |
| silesia/nci | 33553445 | stdx | 1.25 | 2.20 | 1.76 | 37.41 |
| silesia/ooffice | 6152192 | zlib | 11.78 | 21.06 | 1.79 | 415.98 |
| silesia/ooffice | 6152192 | zlib-ng | 6.95 | 12.04 | 1.73 | 140.53 |
| silesia/ooffice | 6152192 | libdeflate | 4.91 | 10.45 | 2.13 | 125.46 |
| silesia/ooffice | 6152192 | Wuffs | 8.82 | 17.54 | 1.99 | 220.44 |
| silesia/ooffice | 6152192 | stdx | 5.13 | 8.55 | 1.67 | 151.34 |
| silesia/osdb | 10085684 | zlib | 7.46 | 16.59 | 2.22 | 183.42 |
| silesia/osdb | 10085684 | zlib-ng | 4.29 | 8.38 | 1.95 | 53.13 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.91 | 2.43 | 29.66 |
| silesia/osdb | 10085684 | Wuffs | 5.79 | 13.61 | 2.35 | 77.85 |
| silesia/osdb | 10085684 | stdx | 2.77 | 5.65 | 2.04 | 40.32 |
| silesia/reymont | 6627202 | zlib | 7.39 | 15.89 | 2.15 | 260.04 |
| silesia/reymont | 6627202 | zlib-ng | 3.71 | 7.72 | 2.08 | 59.65 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.37 |
| silesia/reymont | 6627202 | Wuffs | 4.88 | 11.40 | 2.34 | 112.82 |
| silesia/reymont | 6627202 | stdx | 2.28 | 5.11 | 2.24 | 64.34 |
| silesia/samba | 21606400 | zlib | 6.18 | 14.13 | 2.29 | 175.90 |
| silesia/samba | 21606400 | zlib-ng | 3.36 | 6.47 | 1.93 | 56.08 |
| silesia/samba | 21606400 | libdeflate | 2.34 | 5.58 | 2.39 | 43.00 |
| silesia/samba | 21606400 | Wuffs | 4.35 | 10.39 | 2.39 | 79.70 |
| silesia/samba | 21606400 | stdx | 2.28 | 4.46 | 1.95 | 56.25 |
| silesia/sao | 7251944 | zlib | 10.49 | 23.54 | 2.24 | 204.26 |
| silesia/sao | 7251944 | zlib-ng | 7.87 | 14.83 | 1.88 | 79.60 |
| silesia/sao | 7251944 | libdeflate | 5.74 | 12.73 | 2.22 | 78.97 |
| silesia/sao | 7251944 | Wuffs | 8.90 | 21.26 | 2.39 | 86.40 |
| silesia/sao | 7251944 | stdx | 5.57 | 10.32 | 1.85 | 87.39 |
| silesia/webster | 41458703 | zlib | 7.83 | 16.16 | 2.06 | 284.43 |
| silesia/webster | 41458703 | zlib-ng | 4.23 | 8.04 | 1.90 | 85.05 |
| silesia/webster | 41458703 | libdeflate | 2.92 | 7.17 | 2.45 | 68.41 |
| silesia/webster | 41458703 | Wuffs | 5.15 | 11.67 | 2.27 | 122.42 |
| silesia/webster | 41458703 | stdx | 2.81 | 5.56 | 1.98 | 87.07 |
| silesia/x-ray | 8474240 | zlib | 12.87 | 27.21 | 2.11 | 329.78 |
| silesia/x-ray | 8474240 | zlib-ng | 9.04 | 17.39 | 1.92 | 124.18 |
| silesia/x-ray | 8474240 | libdeflate | 6.55 | 15.26 | 2.33 | 124.51 |
| silesia/x-ray | 8474240 | Wuffs | 10.81 | 23.52 | 2.18 | 190.74 |
| silesia/x-ray | 8474240 | stdx | 6.18 | 11.49 | 1.86 | 139.61 |
| silesia/xml | 5345280 | zlib | 4.23 | 11.16 | 2.64 | 117.76 |
| silesia/xml | 5345280 | zlib-ng | 1.99 | 3.88 | 1.95 | 42.92 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.46 | 31.89 |
| silesia/xml | 5345280 | Wuffs | 2.84 | 7.22 | 2.55 | 58.99 |
| silesia/xml | 5345280 | stdx | 1.32 | 2.65 | 2.02 | 41.74 |
| canterbury/alice29.txt | 152089 | zlib | 8.42 | 18.35 | 2.18 | 293.90 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.40 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.20 | 8.96 | 2.80 | 56.78 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.39 | 13.40 | 2.49 | 98.92 |
| canterbury/alice29.txt | 152089 | stdx | 2.71 | 6.99 | 2.58 | 62.05 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.04 | 19.42 | 2.15 | 315.93 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.09 | 10.86 | 2.13 | 73.15 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.59 | 9.82 | 2.73 | 67.61 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.77 | 14.40 | 2.50 | 100.19 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.09 | 7.52 | 2.43 | 79.80 |
| canterbury/cp.html | 24603 | zlib | 7.06 | 17.33 | 2.46 | 170.09 |
| canterbury/cp.html | 24603 | zlib-ng | 4.19 | 9.50 | 2.27 | 37.45 |
| canterbury/cp.html | 24603 | libdeflate | 2.88 | 7.95 | 2.76 | 16.91 |
| canterbury/cp.html | 24603 | Wuffs | 5.25 | 13.91 | 2.65 | 63.72 |
| canterbury/cp.html | 24603 | stdx | 2.62 | 7.19 | 2.75 | 10.91 |
| canterbury/fields.c | 11150 | zlib | 5.27 | 17.73 | 3.37 | 36.55 |
| canterbury/fields.c | 11150 | zlib-ng | 3.86 | 10.20 | 2.64 | 13.86 |
| canterbury/fields.c | 11150 | libdeflate | 2.82 | 8.32 | 2.96 | 1.66 |
| canterbury/fields.c | 11150 | Wuffs | 4.53 | 14.54 | 3.21 | 10.51 |
| canterbury/fields.c | 11150 | stdx | 2.49 | 7.64 | 3.07 | 3.44 |
| canterbury/grammar.lsp | 3721 | zlib | 6.91 | 24.26 | 3.51 | 7.16 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.81 | 17.48 | 3.01 | 6.59 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.50 | 12.05 | 2.68 | 1.23 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.68 | 21.86 | 3.27 | 4.22 |
| canterbury/grammar.lsp | 3721 | stdx | 3.84 | 12.18 | 3.17 | 0.92 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.58 | 15.27 | 3.33 | 48.22 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.69 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.74 | 5.97 | 2.18 | 8.96 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.86 | 11.59 | 3.00 | 14.76 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.66 | 2.66 | 16.71 |
| canterbury/lcet10.txt | 426754 | zlib | 8.22 | 17.78 | 2.16 | 292.93 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 60.66 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.28 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.22 | 12.88 | 2.47 | 101.40 |
| canterbury/lcet10.txt | 426754 | stdx | 2.59 | 6.42 | 2.48 | 66.40 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.20 | 19.86 | 2.16 | 321.27 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.30 | 11.19 | 2.11 | 79.29 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.70 | 77.65 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.84 | 14.61 | 2.50 | 101.01 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.15 | 7.63 | 2.42 | 85.03 |
| canterbury/ptt5 | 513216 | zlib | 5.06 | 10.71 | 2.12 | 103.62 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.62 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.09 | 38.15 |
| canterbury/ptt5 | 513216 | Wuffs | 3.00 | 7.13 | 2.38 | 57.44 |
| canterbury/ptt5 | 513216 | stdx | 1.44 | 2.55 | 1.77 | 48.69 |
| canterbury/sum | 38240 | zlib | 8.02 | 18.12 | 2.26 | 225.14 |
| canterbury/sum | 38240 | zlib-ng | 4.65 | 10.02 | 2.16 | 56.11 |
| canterbury/sum | 38240 | libdeflate | 3.31 | 8.34 | 2.52 | 32.73 |
| canterbury/sum | 38240 | Wuffs | 5.80 | 14.47 | 2.50 | 81.93 |
| canterbury/sum | 38240 | stdx | 3.03 | 7.73 | 2.55 | 29.58 |
| canterbury/xargs.1 | 4227 | zlib | 7.44 | 25.22 | 3.39 | 14.18 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.38 | 17.97 | 2.81 | 11.12 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.83 | 13.27 | 2.75 | 0.15 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.22 | 22.63 | 3.14 | 10.91 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 12.86 | 3.03 | 2.68 |
| canterbury-large/E.coli | 4638690 | zlib | 6.76 | 17.84 | 2.64 | 177.47 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.24 | 9.68 | 2.29 | 47.24 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.15 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.67 | 12.73 | 2.73 | 62.06 |
| canterbury-large/E.coli | 4638690 | stdx | 2.47 | 6.72 | 2.72 | 54.04 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.53 | 16.46 | 2.19 | 267.53 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.78 | 8.26 | 2.18 | 53.64 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.84 | 45.73 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.81 | 11.73 | 2.44 | 100.72 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.23 | 5.57 | 2.50 | 55.76 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.70 | 15.84 | 2.06 | 281.17 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.18 | 7.78 | 1.86 | 91.19 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.41 | 75.09 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.18 | 11.48 | 2.21 | 128.32 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.71 | 5.40 | 1.99 | 90.31 |
| http/html-1kx1024 | 1048576 | zlib | 16.69 | 35.58 | 2.13 | 352.18 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.69 | 28.43 | 2.24 | 218.31 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.84 | 20.05 | 1.85 | 155.67 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.38 | 38.07 | 2.48 | 265.80 |
| http/html-1kx1024 | 1048576 | stdx | 8.38 | 20.88 | 2.49 | 136.91 |
| http/html-16kx64 | 1048576 | zlib | 6.73 | 14.77 | 2.19 | 222.17 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.16 |
| http/html-16kx64 | 1048576 | libdeflate | 2.65 | 6.04 | 2.28 | 60.48 |
| http/html-16kx64 | 1048576 | Wuffs | 4.93 | 11.57 | 2.35 | 115.18 |
| http/html-16kx64 | 1048576 | stdx | 2.52 | 5.56 | 2.21 | 59.47 |
| http/html-1m | 1048576 | zlib | 5.32 | 12.53 | 2.36 | 176.66 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 59.90 |
| http/html-1m | 1048576 | libdeflate | 1.69 | 4.39 | 2.59 | 37.38 |
| http/html-1m | 1048576 | Wuffs | 3.60 | 8.48 | 2.35 | 88.12 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.11 | 52.72 |
| http/json-1kx1024 | 1048576 | zlib | 10.61 | 23.92 | 2.25 | 193.40 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.26 | 130.72 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.13 | 16.72 | 1.83 | 92.36 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.16 | 34.78 | 2.86 | 146.44 |
| http/json-1kx1024 | 1048576 | stdx | 5.02 | 13.12 | 2.61 | 80.63 |
| http/json-16kx64 | 1048576 | zlib | 4.58 | 12.51 | 2.73 | 103.10 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.74 |
| http/json-16kx64 | 1048576 | libdeflate | 1.93 | 4.24 | 2.19 | 40.44 |
| http/json-16kx64 | 1048576 | Wuffs | 3.50 | 9.43 | 2.69 | 57.96 |
| http/json-16kx64 | 1048576 | stdx | 1.75 | 3.97 | 2.26 | 39.15 |
| http/json-1m | 1048576 | zlib | 3.84 | 11.20 | 2.92 | 83.13 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.02 | 37.36 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.68 |
| http/json-1m | 1048576 | Wuffs | 2.72 | 7.37 | 2.71 | 43.57 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.02 | 40.08 |
| http/js-1kx1024 | 1048576 | zlib | 18.25 | 38.46 | 2.11 | 411.50 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.79 | 31.25 | 2.27 | 238.55 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.55 | 21.58 | 1.87 | 179.12 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.57 | 40.70 | 2.46 | 300.57 |
| http/js-1kx1024 | 1048576 | stdx | 9.27 | 22.85 | 2.46 | 159.34 |
| http/js-16kx64 | 1048576 | zlib | 7.67 | 16.08 | 2.10 | 263.82 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.39 | 8.65 | 1.97 | 92.33 |
| http/js-16kx64 | 1048576 | libdeflate | 3.07 | 7.01 | 2.28 | 72.00 |
| http/js-16kx64 | 1048576 | Wuffs | 5.51 | 12.75 | 2.31 | 129.00 |
| http/js-16kx64 | 1048576 | stdx | 2.98 | 6.54 | 2.19 | 71.34 |
| http/js-1m | 1048576 | zlib | 5.85 | 13.31 | 2.28 | 200.10 |
| http/js-1m | 1048576 | zlib-ng | 2.87 | 5.66 | 1.97 | 60.00 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.93 |
| http/js-1m | 1048576 | Wuffs | 3.91 | 9.14 | 2.34 | 94.10 |
| http/js-1m | 1048576 | stdx | 1.80 | 3.89 | 2.16 | 55.35 |
| http/css-1kx1024 | 1048576 | zlib | 14.05 | 30.36 | 2.16 | 281.88 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.26 | 23.04 | 2.24 | 171.37 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.44 | 17.37 | 1.84 | 121.14 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.80 | 32.50 | 2.54 | 210.97 |
| http/css-1kx1024 | 1048576 | stdx | 6.67 | 17.64 | 2.64 | 100.22 |
| http/css-16kx64 | 1048576 | zlib | 5.31 | 13.04 | 2.46 | 153.57 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.18 | 50.22 |
| http/css-16kx64 | 1048576 | libdeflate | 1.90 | 4.69 | 2.46 | 29.71 |
| http/css-16kx64 | 1048576 | Wuffs | 3.79 | 10.01 | 2.64 | 69.87 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.54 | 28.05 |
| http/css-1m | 1048576 | zlib | 3.98 | 10.97 | 2.76 | 107.56 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.22 | 29.11 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.98 | 12.64 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.78 | 43.22 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.53 | 21.31 |
| shuffled/dickens-1m | 1048576 | zlib | 13.28 | 25.88 | 1.95 | 372.67 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.71 | 16.72 | 1.72 | 196.45 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.03 | 14.95 | 2.13 | 195.52 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.44 | 22.08 | 2.11 | 204.15 |
| shuffled/dickens-1m | 1048576 | stdx | 7.03 | 11.89 | 1.69 | 206.03 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.44 | 14.05 | 4.09 | 3.41 |
| silesia/dickens | 10192446 | stdx | 3.58 | 12.47 | 3.48 | 3.83 |
| silesia/mozilla | 51220480 | libzstd | 2.81 | 9.68 | 3.44 | 30.19 |
| silesia/mozilla | 51220480 | stdx | 2.83 | 9.68 | 3.42 | 15.97 |
| silesia/mr | 9970564 | libzstd | 2.94 | 11.99 | 4.08 | 6.05 |
| silesia/mr | 9970564 | stdx | 3.00 | 10.83 | 3.60 | 5.48 |
| silesia/nci | 33553445 | libzstd | 1.60 | 4.88 | 3.05 | 24.82 |
| silesia/nci | 33553445 | stdx | 1.57 | 4.63 | 2.95 | 13.67 |
| silesia/ooffice | 6152192 | libzstd | 3.36 | 12.19 | 3.63 | 30.99 |
| silesia/ooffice | 6152192 | stdx | 3.31 | 12.40 | 3.75 | 12.31 |
| silesia/osdb | 10085684 | libzstd | 2.34 | 8.45 | 3.62 | 14.89 |
| silesia/osdb | 10085684 | stdx | 2.41 | 8.11 | 3.37 | 15.64 |
| silesia/reymont | 6627202 | libzstd | 3.11 | 11.62 | 3.74 | 11.50 |
| silesia/reymont | 6627202 | stdx | 3.22 | 10.36 | 3.22 | 13.32 |
| silesia/samba | 21606400 | libzstd | 2.02 | 7.41 | 3.66 | 18.71 |
| silesia/samba | 21606400 | stdx | 2.07 | 6.83 | 3.30 | 17.88 |
| silesia/sao | 7251944 | libzstd | 3.78 | 12.72 | 3.36 | 26.74 |
| silesia/sao | 7251944 | stdx | 3.50 | 12.58 | 3.60 | 6.39 |
| silesia/webster | 41458703 | libzstd | 3.18 | 11.24 | 3.54 | 16.14 |
| silesia/webster | 41458703 | stdx | 3.29 | 10.05 | 3.06 | 18.28 |
| silesia/x-ray | 8474240 | libzstd | 3.89 | 14.94 | 3.84 | 18.90 |
| silesia/x-ray | 8474240 | stdx | 3.58 | 13.23 | 3.70 | 8.48 |
| silesia/xml | 5345280 | libzstd | 1.55 | 5.57 | 3.60 | 23.27 |
| silesia/xml | 5345280 | stdx | 1.51 | 5.16 | 3.42 | 17.25 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.89 | 4.10 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.36 | 0.61 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.95 | 14.26 | 4.84 | 3.25 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.29 | 0.27 |
| canterbury/cp.html | 24603 | libzstd | 2.63 | 10.74 | 4.08 | 7.35 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.11 | 0.35 |
| canterbury/fields.c | 11150 | libzstd | 3.12 | 13.62 | 4.37 | 9.27 |
| canterbury/fields.c | 11150 | stdx | 3.02 | 12.72 | 4.21 | 0.19 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.19 | 16.94 | 4.04 | 4.98 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.54 | 4.01 | 0.16 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.52 | 11.40 | 4.52 | 7.78 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.68 | 11.32 | 4.23 | 0.89 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.69 | 12.89 | 4.78 | 5.20 |
| canterbury/lcet10.txt | 426754 | stdx | 2.76 | 11.52 | 4.18 | 5.44 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.10 | 15.16 | 4.88 | 1.51 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.26 | 1.12 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.52 | 3.12 | 25.02 |
| canterbury/ptt5 | 513216 | stdx | 1.35 | 4.46 | 3.31 | 13.45 |
| canterbury/sum | 38240 | libzstd | 2.62 | 10.58 | 4.04 | 10.08 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.09 | 0.33 |
| canterbury/xargs.1 | 4227 | libzstd | 4.26 | 17.41 | 4.09 | 9.41 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.17 | 4.05 | 0.17 |
| canterbury-large/E.coli | 4638690 | libzstd | 2.96 | 13.64 | 4.61 | 2.07 |
| canterbury-large/E.coli | 4638690 | stdx | 3.09 | 12.04 | 3.90 | 2.86 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.90 | 12.00 | 4.14 | 8.35 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.01 | 10.64 | 3.53 | 9.62 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.52 | 9.60 | 3.82 | 19.65 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.61 | 8.64 | 3.31 | 21.37 |
| http/html-1kx1024 | 1048576 | libzstd | 7.27 | 21.63 | 2.98 | 63.43 |
| http/html-1kx1024 | 1048576 | stdx | 7.50 | 22.46 | 2.99 | 76.62 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.52 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 9.61 | 3.61 | 30.15 |
| http/html-1m | 1048576 | libzstd | 2.00 | 7.88 | 3.94 | 24.00 |
| http/html-1m | 1048576 | stdx | 1.99 | 7.12 | 3.57 | 24.88 |
| http/json-1kx1024 | 1048576 | libzstd | 6.29 | 17.39 | 2.76 | 49.63 |
| http/json-1kx1024 | 1048576 | stdx | 6.24 | 17.86 | 2.86 | 53.81 |
| http/json-16kx64 | 1048576 | libzstd | 2.06 | 7.26 | 3.53 | 28.57 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.58 | 19.84 |
| http/json-1m | 1048576 | libzstd | 1.72 | 6.08 | 3.54 | 28.17 |
| http/json-1m | 1048576 | stdx | 1.64 | 5.91 | 3.61 | 14.42 |
| http/js-1kx1024 | 1048576 | libzstd | 8.35 | 26.35 | 3.16 | 73.55 |
| http/js-1kx1024 | 1048576 | stdx | 9.08 | 27.60 | 3.04 | 113.85 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.72 | 4.00 | 24.28 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.74 | 25.79 |
| http/js-1m | 1048576 | libzstd | 2.03 | 8.19 | 4.04 | 20.03 |
| http/js-1m | 1048576 | stdx | 2.05 | 7.48 | 3.64 | 20.64 |
| http/css-1kx1024 | 1048576 | libzstd | 6.91 | 19.69 | 2.85 | 53.76 |
| http/css-1kx1024 | 1048576 | stdx | 6.88 | 19.96 | 2.90 | 63.75 |
| http/css-16kx64 | 1048576 | libzstd | 2.25 | 8.70 | 3.87 | 23.02 |
| http/css-16kx64 | 1048576 | stdx | 2.28 | 8.43 | 3.69 | 22.52 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.58 | 3.89 | 5.45 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.49 | 4.48 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.76 | 9.40 | 3.40 | 28.36 |
| shuffled/dickens-1m | 1048576 | stdx | 2.72 | 9.19 | 3.39 | 12.48 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.44 | 16.93 | 2.27 | 100.17 |
| silesia/dickens | 1048576 | stdx | 5.08 | 12.38 | 2.44 | 54.53 |
| silesia/mozilla | 1048576 | Google | 13.45 | 28.31 | 2.10 | 47.65 |
| silesia/mozilla | 1048576 | stdx | 8.31 | 15.02 | 1.81 | 47.24 |
| silesia/mr | 1048576 | Google | 8.87 | 20.21 | 2.28 | 103.40 |
| silesia/mr | 1048576 | stdx | 5.79 | 13.25 | 2.29 | 88.50 |
| silesia/nci | 1048576 | Google | 2.53 | 5.70 | 2.25 | 52.33 |
| silesia/nci | 1048576 | stdx | 1.94 | 3.95 | 2.04 | 55.44 |
| silesia/ooffice | 1048576 | Google | 14.09 | 29.27 | 2.08 | 289.01 |
| silesia/ooffice | 1048576 | stdx | 10.86 | 20.33 | 1.87 | 324.51 |
| silesia/osdb | 1048576 | Google | 8.16 | 17.48 | 2.14 | 97.45 |
| silesia/osdb | 1048576 | stdx | 5.15 | 10.57 | 2.05 | 91.63 |
| silesia/reymont | 1048576 | Google | 5.38 | 12.62 | 2.34 | 82.90 |
| silesia/reymont | 1048576 | stdx | 3.73 | 9.25 | 2.48 | 47.81 |
| silesia/samba | 1048576 | Google | 7.58 | 16.30 | 2.15 | 95.67 |
| silesia/samba | 1048576 | stdx | 5.06 | 10.71 | 2.12 | 67.17 |
| silesia/sao | 1048576 | Google | 16.83 | 37.18 | 2.21 | 167.88 |
| silesia/sao | 1048576 | stdx | 10.45 | 22.65 | 2.17 | 141.21 |
| silesia/webster | 1048576 | Google | 6.48 | 14.00 | 2.16 | 113.80 |
| silesia/webster | 1048576 | stdx | 4.36 | 9.98 | 2.29 | 69.22 |
| silesia/x-ray | 1048576 | Google | 19.20 | 38.56 | 2.01 | 235.81 |
| silesia/x-ray | 1048576 | stdx | 14.58 | 30.18 | 2.07 | 234.67 |
| silesia/xml | 1048576 | Google | 3.43 | 7.61 | 2.22 | 65.40 |
| silesia/xml | 1048576 | stdx | 2.40 | 5.40 | 2.25 | 47.19 |
| canterbury/alice29.txt | 152089 | Google | 8.84 | 20.55 | 2.32 | 133.13 |
| canterbury/alice29.txt | 152089 | stdx | 6.07 | 15.33 | 2.53 | 80.60 |
| canterbury/asyoulik.txt | 125179 | Google | 10.36 | 23.71 | 2.29 | 166.38 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.08 | 17.43 | 2.46 | 104.37 |
| canterbury/cp.html | 24603 | Google | 9.07 | 22.20 | 2.45 | 114.91 |
| canterbury/cp.html | 24603 | stdx | 5.92 | 17.15 | 2.90 | 44.15 |
| canterbury/fields.c | 11150 | Google | 7.15 | 21.16 | 2.96 | 32.05 |
| canterbury/fields.c | 11150 | stdx | 4.90 | 17.08 | 3.49 | 2.50 |
| canterbury/grammar.lsp | 3721 | Google | 9.83 | 30.16 | 3.07 | 6.94 |
| canterbury/grammar.lsp | 3721 | stdx | 7.14 | 25.04 | 3.51 | 0.62 |
| canterbury/kennedy.xls | 1029744 | Google | 5.43 | 17.05 | 3.14 | 37.48 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.78 | 12.94 | 3.42 | 34.02 |
| canterbury/lcet10.txt | 426754 | Google | 7.69 | 17.36 | 2.26 | 124.81 |
| canterbury/lcet10.txt | 426754 | stdx | 5.19 | 12.96 | 2.50 | 65.89 |
| canterbury/plrabn12.txt | 481861 | Google | 9.04 | 20.82 | 2.30 | 132.34 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.15 | 15.04 | 2.44 | 87.38 |
| canterbury/ptt5 | 513216 | Google | 4.29 | 10.41 | 2.43 | 62.44 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.06 | 66.29 |
| canterbury/sum | 38240 | Google | 10.86 | 26.44 | 2.43 | 159.31 |
| canterbury/sum | 38240 | stdx | 8.28 | 21.11 | 2.55 | 152.42 |
| canterbury/xargs.1 | 4227 | Google | 10.99 | 34.81 | 3.17 | 9.59 |
| canterbury/xargs.1 | 4227 | stdx | 8.51 | 30.44 | 3.58 | 6.31 |
| canterbury-large/E.coli | 1048576 | Google | 8.14 | 19.55 | 2.40 | 1.49 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.23 |
| canterbury-large/bible.txt | 1048576 | Google | 5.28 | 12.28 | 2.33 | 80.77 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.54 | 8.93 | 2.52 | 39.89 |
| canterbury-large/world192.txt | 1048576 | Google | 6.13 | 12.84 | 2.09 | 114.53 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.39 | 9.38 | 2.14 | 77.29 |
| http/html-1kx1024 | 1048576 | Google | 18.02 | 41.93 | 2.33 | 387.18 |
| http/html-1kx1024 | 1048576 | stdx | 15.29 | 37.56 | 2.46 | 359.50 |
| http/html-16kx64 | 1048576 | Google | 6.74 | 14.85 | 2.20 | 148.86 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 115.22 |
| http/html-1m | 1048576 | Google | 4.03 | 8.94 | 2.22 | 83.38 |
| http/html-1m | 1048576 | stdx | 2.86 | 6.52 | 2.28 | 54.74 |
| http/json-1kx1024 | 1048576 | Google | 14.50 | 36.64 | 2.53 | 240.92 |
| http/json-1kx1024 | 1048576 | stdx | 13.00 | 33.63 | 2.59 | 278.19 |
| http/json-16kx64 | 1048576 | Google | 4.44 | 11.43 | 2.58 | 83.13 |
| http/json-16kx64 | 1048576 | stdx | 3.38 | 8.42 | 2.49 | 83.87 |
| http/json-1m | 1048576 | Google | 3.40 | 8.65 | 2.54 | 60.13 |
| http/json-1m | 1048576 | stdx | 2.45 | 5.99 | 2.44 | 57.33 |
| http/js-1kx1024 | 1048576 | Google | 19.94 | 46.20 | 2.32 | 425.15 |
| http/js-1kx1024 | 1048576 | stdx | 16.39 | 39.90 | 2.43 | 378.90 |
| http/js-16kx64 | 1048576 | Google | 8.03 | 17.73 | 2.21 | 165.95 |
| http/js-16kx64 | 1048576 | stdx | 6.04 | 14.36 | 2.38 | 126.10 |
| http/js-1m | 1048576 | Google | 4.33 | 9.54 | 2.20 | 82.75 |
| http/js-1m | 1048576 | stdx | 3.15 | 7.25 | 2.30 | 55.40 |
| http/css-1kx1024 | 1048576 | Google | 15.53 | 37.36 | 2.41 | 294.02 |
| http/css-1kx1024 | 1048576 | stdx | 13.78 | 34.70 | 2.52 | 301.65 |
| http/css-16kx64 | 1048576 | Google | 4.97 | 11.76 | 2.37 | 102.41 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.49 | 80.89 |
| http/css-1m | 1048576 | Google | 2.43 | 9.42 | 3.88 | 17.03 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.47 | 12.08 |
| shuffled/dickens-1m | 1048576 | Google | 10.11 | 20.65 | 2.04 | 105.77 |
| shuffled/dickens-1m | 1048576 | stdx | 8.76 | 14.53 | 1.66 | 115.83 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.25 | 36.91 | 2.42 | 411.91 |
| silesia/dickens | 10192446 | 1 | stdx | 16.32 | 38.17 | 2.34 | 357.24 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.03 | 87.63 | 1.68 | 695.15 |
| silesia/dickens | 10192446 | 6 | stdx | 49.55 | 84.26 | 1.70 | 1450.13 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.76 | 160.47 | 1.44 | 928.45 |
| silesia/dickens | 10192446 | 9 | stdx | 85.64 | 191.81 | 2.24 | 1718.99 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.09 | 32.62 | 2.31 | 437.96 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.37 | 30.24 | 2.26 | 296.02 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.85 | 70.83 | 2.16 | 580.63 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.55 | 69.96 | 2.22 | 735.18 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.46 | 221.49 | 1.74 | 767.31 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.95 | 126.12 | 2.58 | 790.50 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.98 | 35.02 | 2.92 | 229.62 |
| silesia/mr | 9970564 | 1 | stdx | 12.62 | 34.08 | 2.70 | 187.32 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.19 | 80.54 | 2.11 | 438.00 |
| silesia/mr | 9970564 | 6 | stdx | 39.66 | 83.19 | 2.10 | 970.09 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.69 | 165.48 | 1.69 | 750.97 |
| silesia/mr | 9970564 | 9 | stdx | 87.37 | 206.31 | 2.36 | 1325.92 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.21 | 18.42 | 2.97 | 115.65 |
| silesia/nci | 33553445 | 1 | stdx | 4.99 | 10.88 | 2.18 | 98.70 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.96 | 34.84 | 2.05 | 225.59 |
| silesia/nci | 33553445 | 6 | stdx | 14.35 | 29.54 | 2.06 | 392.11 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.35 | 105.28 | 1.69 | 499.13 |
| silesia/nci | 33553445 | 9 | stdx | 33.27 | 80.64 | 2.42 | 649.01 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.92 | 39.15 | 1.97 | 753.99 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.72 | 39.08 | 2.21 | 429.45 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 40.94 | 79.10 | 1.93 | 954.52 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.54 | 87.83 | 2.11 | 999.95 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.51 | 127.63 | 1.71 | 1130.48 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.29 | 129.17 | 2.47 | 938.27 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.88 | 30.15 | 2.34 | 352.87 |
| silesia/osdb | 10085684 | 1 | stdx | 12.94 | 27.87 | 2.15 | 293.91 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.25 | 55.67 | 1.97 | 491.90 |
| silesia/osdb | 10085684 | 6 | stdx | 27.09 | 57.40 | 2.12 | 566.46 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.88 | 64.15 | 1.89 | 550.77 |
| silesia/osdb | 10085684 | 9 | stdx | 35.68 | 87.23 | 2.44 | 683.08 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.62 | 32.88 | 2.61 | 313.16 |
| silesia/reymont | 6627202 | 1 | stdx | 13.40 | 33.24 | 2.48 | 270.86 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.10 | 86.58 | 1.80 | 521.87 |
| silesia/reymont | 6627202 | 6 | stdx | 45.22 | 76.82 | 1.70 | 1428.24 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.12 | 276.14 | 1.39 | 836.25 |
| silesia/reymont | 6627202 | 9 | stdx | 87.69 | 189.98 | 2.17 | 1611.91 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.44 | 26.53 | 2.54 | 272.58 |
| silesia/samba | 21606400 | 1 | stdx | 9.89 | 22.23 | 2.25 | 220.53 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.92 | 58.79 | 2.03 | 385.30 |
| silesia/samba | 21606400 | 6 | stdx | 24.10 | 49.84 | 2.07 | 623.57 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.16 | 141.44 | 1.68 | 505.16 |
| silesia/samba | 21606400 | 9 | stdx | 41.80 | 102.63 | 2.46 | 729.15 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.75 | 47.87 | 2.20 | 689.06 |
| silesia/sao | 7251944 | 1 | stdx | 19.16 | 49.92 | 2.60 | 346.34 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.09 | 96.89 | 1.90 | 964.13 |
| silesia/sao | 7251944 | 6 | stdx | 47.07 | 105.66 | 2.24 | 853.36 |
| silesia/sao | 7251944 | 9 | libdeflate | 70.90 | 120.26 | 1.70 | 1109.41 |
| silesia/sao | 7251944 | 9 | stdx | 55.45 | 138.16 | 2.49 | 848.20 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.09 | 30.45 | 2.33 | 386.04 |
| silesia/webster | 41458703 | 1 | stdx | 13.84 | 29.09 | 2.10 | 339.14 |
| silesia/webster | 41458703 | 6 | libdeflate | 36.96 | 66.02 | 1.79 | 569.95 |
| silesia/webster | 41458703 | 6 | stdx | 35.03 | 60.88 | 1.74 | 1099.86 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.52 | 138.85 | 1.47 | 754.05 |
| silesia/webster | 41458703 | 9 | stdx | 61.13 | 135.96 | 2.22 | 1288.62 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.71 | 49.67 | 2.09 | 789.84 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.59 | 50.82 | 2.89 | 261.05 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.81 | 82.77 | 2.52 | 852.50 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.78 | 98.12 | 2.90 | 539.33 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.47 | 91.03 | 2.43 | 1030.64 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.78 | 122.06 | 2.99 | 466.76 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.80 | 21.59 | 2.77 | 176.01 |
| silesia/xml | 5345280 | 1 | stdx | 6.98 | 15.66 | 2.24 | 155.81 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.13 | 40.51 | 1.92 | 264.37 |
| silesia/xml | 5345280 | 6 | stdx | 17.68 | 34.32 | 1.94 | 498.06 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.62 | 89.17 | 1.52 | 369.99 |
| silesia/xml | 5345280 | 9 | stdx | 31.36 | 72.83 | 2.32 | 597.21 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.26 | 35.61 | 2.50 | 379.91 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.04 | 36.13 | 2.40 | 335.72 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.73 | 82.29 | 1.76 | 643.49 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.50 | 77.43 | 1.78 | 1307.07 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.59 | 159.21 | 1.48 | 850.73 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 73.16 | 167.73 | 2.29 | 1507.72 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.16 | 37.20 | 2.45 | 416.74 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.78 | 37.43 | 2.37 | 359.53 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.28 | 85.43 | 1.77 | 718.37 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.25 | 81.93 | 1.77 | 1393.99 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.91 | 136.15 | 1.53 | 942.81 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 76.17 | 175.98 | 2.31 | 1607.82 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.74 | 32.02 | 2.73 | 285.34 |
| canterbury/cp.html | 24603 | 1 | stdx | 10.89 | 27.13 | 2.49 | 241.76 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 27.06 | 62.33 | 2.30 | 491.37 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.72 | 57.06 | 2.41 | 617.63 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.96 | 91.97 | 1.96 | 602.53 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.39 | 88.89 | 2.83 | 645.32 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.58 | 35.92 | 3.75 | 64.39 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.15 | 30.06 | 3.69 | 26.45 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.62 | 69.37 | 2.82 | 256.18 |
| canterbury/fields.c | 11150 | 6 | stdx | 21.18 | 57.62 | 2.72 | 450.08 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.56 | 100.81 | 2.26 | 424.50 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.28 | 92.66 | 3.28 | 432.14 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 12.99 | 51.51 | 3.97 | 12.39 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.93 | 39.03 | 3.93 | 1.72 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.84 | 87.06 | 3.65 | 32.08 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.30 | 70.82 | 4.09 | 20.68 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 31.36 | 102.89 | 3.28 | 69.99 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.42 | 99.32 | 4.24 | 48.14 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.36 | 27.18 | 3.69 | 65.44 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.03 | 22.58 | 3.21 | 63.08 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.88 | 73.85 | 2.65 | 95.89 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.35 | 62.00 | 3.20 | 138.89 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.21 | 664.23 | 1.83 | 163.35 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.83 | 130.89 | 3.46 | 219.35 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.80 | 33.99 | 2.46 | 371.50 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.43 | 33.93 | 2.35 | 328.73 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 44.99 | 78.22 | 1.74 | 609.60 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.59 | 73.43 | 1.77 | 1219.28 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.70 | 136.94 | 1.49 | 804.01 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 71.06 | 162.25 | 2.28 | 1442.81 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.82 | 38.62 | 2.44 | 427.47 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.72 | 40.25 | 2.41 | 369.90 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.10 | 91.90 | 1.70 | 753.10 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.50 | 88.90 | 1.73 | 1498.89 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.84 | 166.26 | 1.42 | 1003.93 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 89.18 | 201.33 | 2.26 | 1797.22 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.43 | 18.61 | 2.90 | 141.51 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.98 | 11.03 | 2.22 | 123.49 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.26 | 36.17 | 2.54 | 220.59 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.34 | 29.58 | 2.40 | 311.31 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.39 | 120.86 | 2.00 | 374.22 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.28 | 130.09 | 3.01 | 641.86 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.81 | 33.49 | 2.61 | 337.22 |
| canterbury/sum | 38240 | 1 | stdx | 12.64 | 29.36 | 2.32 | 304.15 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.67 | 69.87 | 2.44 | 504.45 |
| canterbury/sum | 38240 | 6 | stdx | 26.86 | 65.74 | 2.45 | 670.11 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.27 | 181.91 | 1.93 | 612.22 |
| canterbury/sum | 38240 | 9 | stdx | 39.40 | 112.34 | 2.85 | 660.70 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.27 | 53.06 | 4.00 | 22.15 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.81 | 43.11 | 3.99 | 5.10 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.91 | 87.70 | 3.83 | 70.52 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 18.08 | 74.37 | 4.11 | 43.30 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 25.69 | 94.34 | 3.67 | 135.81 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 25.99 | 106.97 | 4.12 | 104.71 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.08 | 40.47 | 3.35 | 165.61 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.65 | 42.29 | 3.34 | 101.00 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.20 | 395.99 | 2.16 | 261.52 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.85 | 374.13 | 3.05 | 1907.76 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.67 | 1063.49 | 1.30 | 1320.80 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 230.45 | 755.68 | 3.28 | 2438.88 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.56 | 32.38 | 2.58 | 312.60 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.45 | 32.23 | 2.40 | 281.69 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.10 | 80.12 | 1.74 | 525.71 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.12 | 72.39 | 1.72 | 1252.79 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.61 | 200.28 | 1.41 | 741.33 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.65 | 170.21 | 2.22 | 1438.64 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.28 | 29.72 | 2.24 | 412.51 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.19 | 28.55 | 2.01 | 379.20 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.03 | 60.25 | 1.82 | 558.28 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 31.97 | 56.81 | 1.78 | 986.19 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.60 | 119.11 | 1.48 | 685.88 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 52.39 | 117.95 | 2.25 | 1140.96 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.38 | 103.92 | 2.94 | 452.87 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.36 | 58.69 | 2.75 | 365.45 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.19 | 138.34 | 3.00 | 562.73 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 32.06 | 94.36 | 2.94 | 527.31 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.74 | 142.44 | 2.98 | 590.02 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 36.23 | 112.18 | 3.10 | 539.15 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.46 | 27.96 | 2.67 | 267.83 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.00 | 20.25 | 2.25 | 233.30 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.46 | 52.09 | 2.32 | 404.24 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.90 | 42.87 | 2.27 | 539.42 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 35.04 | 72.54 | 2.07 | 470.04 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.91 | 69.06 | 2.77 | 550.85 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.77 | 23.03 | 2.63 | 224.51 |
| http/html-1m | 1048576 | 1 | stdx | 8.16 | 17.80 | 2.18 | 206.48 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.28 | 49.53 | 1.96 | 327.52 |
| http/html-1m | 1048576 | 6 | stdx | 21.13 | 40.71 | 1.93 | 613.54 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.12 | 109.24 | 1.54 | 432.12 |
| http/html-1m | 1048576 | 9 | stdx | 36.00 | 85.76 | 2.38 | 706.18 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.79 | 94.80 | 2.98 | 302.50 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.56 | 45.22 | 2.73 | 240.62 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.05 | 126.60 | 2.94 | 372.29 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.25 | 78.43 | 2.88 | 376.42 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.13 | 142.45 | 2.73 | 430.26 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.87 | 95.61 | 3.10 | 385.35 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.85 | 23.85 | 3.04 | 134.64 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.43 | 13.94 | 2.57 | 110.34 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.18 | 46.61 | 2.56 | 206.26 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.40 | 35.02 | 2.61 | 275.54 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.19 | 151.99 | 1.90 | 296.68 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.25 | 58.45 | 3.04 | 301.77 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.73 | 19.85 | 2.95 | 124.53 |
| http/json-1m | 1048576 | 1 | stdx | 5.06 | 12.51 | 2.47 | 102.97 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.31 | 45.30 | 2.23 | 175.50 |
| http/json-1m | 1048576 | 6 | stdx | 14.67 | 35.09 | 2.39 | 296.95 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.57 | 205.21 | 1.69 | 275.20 |
| http/json-1m | 1048576 | 9 | stdx | 29.14 | 72.87 | 2.50 | 370.21 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.07 | 107.80 | 2.91 | 517.43 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.72 | 65.45 | 2.76 | 411.08 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.31 | 144.85 | 2.94 | 677.00 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 35.74 | 104.17 | 2.92 | 617.20 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.70 | 150.13 | 2.90 | 719.31 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 40.39 | 125.18 | 3.10 | 625.29 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.73 | 30.90 | 2.63 | 309.65 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.82 | 24.80 | 2.29 | 272.61 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 26.02 | 59.43 | 2.28 | 486.10 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.66 | 50.05 | 2.21 | 673.68 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.85 | 83.31 | 2.04 | 569.61 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.66 | 81.31 | 2.74 | 663.28 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.62 | 25.19 | 2.62 | 247.10 |
| http/js-1m | 1048576 | 1 | stdx | 9.53 | 21.31 | 2.24 | 233.55 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.70 | 56.12 | 1.96 | 370.08 |
| http/js-1m | 1048576 | 6 | stdx | 24.79 | 46.64 | 1.88 | 739.79 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.19 | 120.65 | 1.58 | 499.99 |
| http/js-1m | 1048576 | 9 | stdx | 42.19 | 100.01 | 2.37 | 807.89 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.19 | 97.74 | 2.94 | 374.59 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.52 | 49.57 | 2.68 | 302.18 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.81 | 129.23 | 2.95 | 476.30 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.17 | 82.37 | 2.82 | 501.85 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.76 | 133.80 | 2.92 | 506.01 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.26 | 99.53 | 2.99 | 523.96 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.64 | 25.60 | 2.96 | 174.11 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.67 | 16.96 | 2.54 | 134.93 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.27 | 48.80 | 2.41 | 294.73 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.46 | 38.01 | 2.31 | 462.72 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.83 | 82.40 | 2.02 | 376.24 |
| http/css-16kx64 | 1048576 | 9 | stdx | 23.03 | 65.14 | 2.83 | 479.69 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.96 | 21.15 | 3.04 | 134.07 |
| http/css-1m | 1048576 | 1 | stdx | 5.78 | 14.91 | 2.58 | 108.92 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.75 | 44.50 | 2.14 | 226.38 |
| http/css-1m | 1048576 | 6 | stdx | 16.64 | 35.61 | 2.14 | 449.38 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.66 | 111.58 | 1.60 | 309.61 |
| http/css-1m | 1048576 | 9 | stdx | 32.20 | 83.00 | 2.58 | 512.89 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.27 | 48.89 | 1.93 | 936.74 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.09 | 49.19 | 2.72 | 322.83 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.52 | 86.45 | 2.08 | 1181.75 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.63 | 88.80 | 2.24 | 851.27 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.01 | 94.50 | 2.01 | 1343.41 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.55 | 134.38 | 2.46 | 1133.93 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.05 | 31.22 | 3.11 | 120.00 |
| silesia/dickens | 10192446 | 1 | stdx | 24.12 | 82.03 | 3.40 | 127.08 |
| silesia/dickens | 10192446 | 3 | libzstd | 21.41 | 34.39 | 1.61 | 169.63 |
| silesia/dickens | 10192446 | 3 | stdx | 34.19 | 78.22 | 2.29 | 182.52 |
| silesia/mozilla | 51220480 | 1 | libzstd | 6.99 | 22.69 | 3.25 | 71.28 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.49 | 54.73 | 3.13 | 175.57 |
| silesia/mozilla | 51220480 | 3 | libzstd | 15.83 | 27.89 | 1.76 | 102.32 |
| silesia/mozilla | 51220480 | 3 | stdx | 29.09 | 62.01 | 2.13 | 144.88 |
| silesia/mr | 9970564 | 1 | libzstd | 7.66 | 24.81 | 3.24 | 57.49 |
| silesia/mr | 9970564 | 1 | stdx | 19.78 | 66.82 | 3.38 | 116.58 |
| silesia/mr | 9970564 | 3 | libzstd | 18.71 | 32.19 | 1.72 | 86.63 |
| silesia/mr | 9970564 | 3 | stdx | 31.97 | 72.46 | 2.27 | 114.90 |
| silesia/nci | 33553445 | 1 | libzstd | 3.51 | 9.55 | 2.72 | 57.22 |
| silesia/nci | 33553445 | 1 | stdx | 7.64 | 25.69 | 3.36 | 60.52 |
| silesia/nci | 33553445 | 3 | libzstd | 5.19 | 9.95 | 1.92 | 56.32 |
| silesia/nci | 33553445 | 3 | stdx | 10.93 | 29.15 | 2.67 | 66.67 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.54 | 29.26 | 3.43 | 72.66 |
| silesia/ooffice | 6152192 | 1 | stdx | 22.94 | 72.51 | 3.16 | 181.21 |
| silesia/ooffice | 6152192 | 3 | libzstd | 21.91 | 39.44 | 1.80 | 120.16 |
| silesia/ooffice | 6152192 | 3 | stdx | 39.70 | 82.20 | 2.07 | 185.39 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.02 | 22.29 | 3.17 | 66.69 |
| silesia/osdb | 10085684 | 1 | stdx | 16.31 | 50.52 | 3.10 | 124.74 |
| silesia/osdb | 10085684 | 3 | libzstd | 16.57 | 26.23 | 1.58 | 67.85 |
| silesia/osdb | 10085684 | 3 | stdx | 29.93 | 57.87 | 1.93 | 112.15 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.66 | 27.13 | 2.81 | 150.37 |
| silesia/reymont | 6627202 | 1 | stdx | 20.00 | 72.05 | 3.60 | 97.09 |
| silesia/reymont | 6627202 | 3 | libzstd | 17.16 | 27.10 | 1.58 | 126.35 |
| silesia/reymont | 6627202 | 3 | stdx | 27.00 | 62.18 | 2.30 | 147.69 |
| silesia/samba | 21606400 | 1 | libzstd | 5.90 | 16.88 | 2.86 | 85.49 |
| silesia/samba | 21606400 | 1 | stdx | 13.40 | 42.89 | 3.20 | 126.77 |
| silesia/samba | 21606400 | 3 | libzstd | 11.24 | 18.81 | 1.67 | 98.78 |
| silesia/samba | 21606400 | 3 | stdx | 19.47 | 44.75 | 2.30 | 133.49 |
| silesia/sao | 7251944 | 1 | libzstd | 9.03 | 33.69 | 3.73 | 45.34 |
| silesia/sao | 7251944 | 1 | stdx | 25.74 | 82.03 | 3.19 | 105.05 |
| silesia/sao | 7251944 | 3 | libzstd | 28.74 | 50.03 | 1.74 | 94.96 |
| silesia/sao | 7251944 | 3 | stdx | 48.63 | 95.22 | 1.96 | 142.89 |
| silesia/webster | 41458703 | 1 | libzstd | 8.63 | 24.94 | 2.89 | 131.33 |
| silesia/webster | 41458703 | 1 | stdx | 20.19 | 64.04 | 3.17 | 168.67 |
| silesia/webster | 41458703 | 3 | libzstd | 17.99 | 27.33 | 1.52 | 176.20 |
| silesia/webster | 41458703 | 3 | stdx | 29.56 | 64.55 | 2.18 | 194.85 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.66 | 14.92 | 3.20 | 17.02 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.66 | 76.64 | 3.24 | 93.00 |
| silesia/x-ray | 8474240 | 3 | libzstd | 29.46 | 52.73 | 1.79 | 88.60 |
| silesia/x-ray | 8474240 | 3 | stdx | 44.94 | 92.40 | 2.06 | 105.62 |
| silesia/xml | 5345280 | 1 | libzstd | 4.20 | 11.71 | 2.79 | 71.26 |
| silesia/xml | 5345280 | 1 | stdx | 10.28 | 34.21 | 3.33 | 95.30 |
| silesia/xml | 5345280 | 3 | libzstd | 6.40 | 12.61 | 1.97 | 77.44 |
| silesia/xml | 5345280 | 3 | stdx | 12.38 | 32.28 | 2.61 | 116.50 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.78 | 32.84 | 3.05 | 139.28 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.34 | 76.49 | 3.42 | 191.31 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.24 | 39.48 | 2.59 | 200.37 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.23 | 73.76 | 2.81 | 339.05 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.72 | 33.55 | 3.45 | 102.87 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.55 | 79.00 | 3.35 | 219.34 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.15 | 39.27 | 2.59 | 209.33 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.04 | 79.30 | 2.83 | 377.24 |
| canterbury/cp.html | 24603 | 1 | libzstd | 7.05 | 26.64 | 3.78 | 42.84 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.19 | 57.76 | 3.57 | 125.98 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.48 | 31.85 | 3.36 | 46.84 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.22 | 59.76 | 3.28 | 142.13 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.73 | 31.76 | 3.64 | 42.87 |
| canterbury/fields.c | 11150 | 1 | stdx | 17.02 | 65.73 | 3.86 | 89.58 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.34 | 34.14 | 3.65 | 28.11 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.28 | 64.68 | 3.74 | 90.51 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.47 | 38.01 | 4.02 | 8.82 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.29 | 77.57 | 3.82 | 56.09 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.70 | 43.09 | 4.03 | 8.58 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.38 | 79.60 | 3.72 | 66.78 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.01 | 23.56 | 3.92 | 14.59 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.70 | 56.75 | 3.86 | 87.62 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.10 | 23.80 | 2.94 | 27.44 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 19.72 | 56.61 | 2.87 | 107.77 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.80 | 28.52 | 2.91 | 155.96 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.42 | 72.02 | 3.36 | 163.50 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 15.83 | 32.14 | 2.03 | 202.26 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 25.88 | 67.10 | 2.59 | 298.98 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.31 | 32.37 | 3.14 | 128.56 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.09 | 84.16 | 3.35 | 161.92 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 19.91 | 38.77 | 1.95 | 228.71 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 31.10 | 80.77 | 2.60 | 344.02 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.16 | 8.51 | 2.70 | 67.53 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.53 | 23.15 | 3.07 | 106.50 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 4.66 | 10.97 | 2.35 | 59.12 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.29 | 24.08 | 2.59 | 133.52 |
| canterbury/sum | 38240 | 1 | libzstd | 6.58 | 25.39 | 3.86 | 33.49 |
| canterbury/sum | 38240 | 1 | stdx | 17.04 | 59.13 | 3.47 | 157.71 |
| canterbury/sum | 38240 | 3 | libzstd | 9.04 | 30.67 | 3.39 | 47.60 |
| canterbury/sum | 38240 | 3 | stdx | 19.64 | 61.82 | 3.15 | 184.70 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 9.99 | 39.82 | 3.98 | 12.15 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.98 | 80.38 | 3.83 | 62.80 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.24 | 48.17 | 3.94 | 16.04 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.83 | 83.98 | 3.68 | 76.96 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.32 | 33.44 | 3.24 | 76.09 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.79 | 95.62 | 4.39 | 7.22 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 14.56 | 31.30 | 2.15 | 35.86 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.33 | 70.38 | 3.02 | 39.01 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.70 | 27.45 | 2.83 | 149.45 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.33 | 71.86 | 3.53 | 109.05 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 17.19 | 28.20 | 1.64 | 133.64 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 27.02 | 63.36 | 2.35 | 155.94 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.11 | 22.70 | 2.80 | 136.88 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.52 | 55.86 | 3.02 | 195.66 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 14.60 | 23.87 | 1.63 | 173.25 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 24.05 | 51.26 | 2.13 | 237.93 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.07 | 52.46 | 3.07 | 160.02 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.88 | 100.54 | 2.80 | 641.69 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.07 | 59.20 | 3.10 | 197.27 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 38.01 | 104.00 | 2.74 | 637.25 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.69 | 22.46 | 2.92 | 122.20 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.18 | 46.84 | 3.30 | 184.08 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.77 | 24.61 | 2.81 | 143.44 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.47 | 47.61 | 3.08 | 194.53 |
| http/html-1m | 1048576 | 1 | libzstd | 6.18 | 16.74 | 2.71 | 114.48 |
| http/html-1m | 1048576 | 1 | stdx | 12.87 | 42.00 | 3.26 | 135.75 |
| http/html-1m | 1048576 | 3 | libzstd | 9.02 | 18.18 | 2.02 | 125.49 |
| http/html-1m | 1048576 | 3 | stdx | 15.37 | 39.37 | 2.56 | 178.61 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.35 | 42.52 | 2.96 | 115.91 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.53 | 83.13 | 2.82 | 532.58 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.84 | 44.54 | 3.00 | 128.79 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.72 | 84.87 | 2.76 | 537.17 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.79 | 14.98 | 3.12 | 57.43 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.70 | 33.78 | 3.48 | 117.57 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.34 | 16.21 | 3.04 | 72.43 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.47 | 34.58 | 3.30 | 123.46 |
| http/json-1m | 1048576 | 1 | libzstd | 4.04 | 12.55 | 3.11 | 52.47 |
| http/json-1m | 1048576 | 1 | stdx | 8.97 | 30.70 | 3.42 | 86.98 |
| http/json-1m | 1048576 | 3 | libzstd | 5.97 | 13.78 | 2.31 | 68.53 |
| http/json-1m | 1048576 | 3 | stdx | 11.10 | 30.64 | 2.76 | 120.80 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.56 | 57.26 | 3.08 | 184.73 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 39.93 | 113.49 | 2.84 | 699.32 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.42 | 65.54 | 3.06 | 258.80 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.14 | 116.54 | 2.77 | 689.33 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.82 | 26.52 | 3.01 | 127.64 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.60 | 55.71 | 3.35 | 203.57 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.03 | 28.74 | 2.86 | 153.74 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.62 | 55.35 | 3.14 | 211.62 |
| http/js-1m | 1048576 | 1 | libzstd | 6.50 | 17.87 | 2.75 | 113.33 |
| http/js-1m | 1048576 | 1 | stdx | 13.86 | 45.88 | 3.31 | 137.45 |
| http/js-1m | 1048576 | 3 | libzstd | 9.56 | 19.14 | 2.00 | 124.74 |
| http/js-1m | 1048576 | 3 | stdx | 16.50 | 41.25 | 2.50 | 188.20 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.58 | 46.90 | 3.01 | 137.61 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.30 | 91.65 | 2.84 | 581.77 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.65 | 50.53 | 3.03 | 159.20 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.63 | 93.63 | 2.78 | 584.78 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.11 | 18.99 | 3.11 | 78.53 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.40 | 43.79 | 3.53 | 137.86 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.54 | 19.41 | 2.97 | 94.92 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.81 | 42.34 | 3.31 | 153.26 |
| http/css-1m | 1048576 | 1 | libzstd | 1.49 | 4.59 | 3.07 | 21.81 |
| http/css-1m | 1048576 | 1 | stdx | 3.97 | 14.85 | 3.74 | 30.85 |
| http/css-1m | 1048576 | 3 | libzstd | 1.92 | 5.25 | 2.73 | 19.67 |
| http/css-1m | 1048576 | 3 | stdx | 3.91 | 13.33 | 3.41 | 31.67 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.50 | 12.79 | 3.65 | 6.27 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.09 | 30.66 | 3.37 | 63.12 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 26.00 | 50.53 | 1.94 | 49.25 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 20.14 | 47.43 | 2.35 | 211.01 |

## Hardware counters per input octet, brotli encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | Google q1 | 18.09 | 30.24 | 1.67 | 231.54 |
| silesia/dickens | 10192446 | stdx 1 | 19.50 | 43.43 | 2.23 | 414.03 |
| silesia/dickens | 10192446 | Google q5 | 97.37 | 194.36 | 2.00 | 817.72 |
| silesia/dickens | 10192446 | stdx 5 | 68.71 | 156.51 | 2.28 | 981.90 |
| silesia/mozilla | 51220480 | Google q1 | 13.07 | 25.26 | 1.93 | 144.79 |
| silesia/mozilla | 51220480 | stdx 1 | 12.34 | 32.95 | 2.67 | 213.85 |
| silesia/mozilla | 51220480 | Google q5 | 60.15 | 149.30 | 2.48 | 795.70 |
| silesia/mozilla | 51220480 | stdx 5 | 57.13 | 149.71 | 2.62 | 808.79 |
| silesia/mr | 9970564 | Google q1 | 13.08 | 26.14 | 2.00 | 97.20 |
| silesia/mr | 9970564 | stdx 1 | 13.73 | 37.80 | 2.75 | 164.96 |
| silesia/mr | 9970564 | Google q5 | 77.13 | 177.41 | 2.30 | 608.11 |
| silesia/mr | 9970564 | stdx 5 | 59.64 | 150.44 | 2.52 | 697.31 |
| silesia/nci | 33553445 | Google q1 | 5.26 | 9.71 | 1.84 | 89.07 |
| silesia/nci | 33553445 | stdx 1 | 6.08 | 14.48 | 2.38 | 128.49 |
| silesia/nci | 33553445 | Google q5 | 29.75 | 59.01 | 1.98 | 408.98 |
| silesia/nci | 33553445 | stdx 5 | 25.63 | 58.75 | 2.29 | 472.17 |
| silesia/ooffice | 6152192 | Google q1 | 17.26 | 33.43 | 1.94 | 155.56 |
| silesia/ooffice | 6152192 | stdx 1 | 16.88 | 45.85 | 2.72 | 267.97 |
| silesia/ooffice | 6152192 | Google q5 | 82.90 | 198.80 | 2.40 | 1062.63 |
| silesia/ooffice | 6152192 | stdx 5 | 71.18 | 180.71 | 2.54 | 1067.15 |
| silesia/osdb | 10085684 | Google q1 | 12.40 | 23.47 | 1.89 | 85.04 |
| silesia/osdb | 10085684 | stdx 1 | 11.67 | 32.00 | 2.74 | 141.33 |
| silesia/osdb | 10085684 | Google q5 | 63.01 | 146.01 | 2.32 | 545.04 |
| silesia/osdb | 10085684 | stdx 5 | 47.98 | 125.21 | 2.61 | 516.93 |
| silesia/reymont | 6627202 | Google q1 | 15.37 | 25.54 | 1.66 | 208.23 |
| silesia/reymont | 6627202 | stdx 1 | 14.45 | 33.36 | 2.31 | 283.10 |
| silesia/reymont | 6627202 | Google q5 | 75.42 | 169.16 | 2.24 | 799.45 |
| silesia/reymont | 6627202 | stdx 5 | 58.28 | 140.32 | 2.41 | 893.19 |
| silesia/samba | 21606400 | Google q1 | 9.83 | 17.38 | 1.77 | 127.59 |
| silesia/samba | 21606400 | stdx 1 | 9.93 | 23.94 | 2.41 | 197.03 |
| silesia/samba | 21606400 | Google q5 | 44.95 | 105.54 | 2.35 | 477.82 |
| silesia/samba | 21606400 | stdx 5 | 40.11 | 103.19 | 2.57 | 524.94 |
| silesia/sao | 7251944 | Google q1 | 20.49 | 39.96 | 1.95 | 101.51 |
| silesia/sao | 7251944 | stdx 1 | 18.77 | 55.66 | 2.96 | 190.54 |
| silesia/sao | 7251944 | Google q5 | 102.16 | 259.63 | 2.54 | 925.59 |
| silesia/sao | 7251944 | stdx 5 | 85.79 | 233.57 | 2.72 | 741.36 |
| silesia/webster | 41458703 | Google q1 | 14.53 | 24.40 | 1.68 | 208.44 |
| silesia/webster | 41458703 | stdx 1 | 15.34 | 34.12 | 2.22 | 340.88 |
| silesia/webster | 41458703 | Google q5 | 70.84 | 141.82 | 2.00 | 751.40 |
| silesia/webster | 41458703 | stdx 5 | 54.31 | 122.07 | 2.25 | 836.26 |
| silesia/x-ray | 8474240 | Google q1 | 13.88 | 22.03 | 1.59 | 13.04 |
| silesia/x-ray | 8474240 | stdx 1 | 13.15 | 38.68 | 2.94 | 95.57 |
| silesia/x-ray | 8474240 | Google q5 | 93.50 | 236.76 | 2.53 | 724.03 |
| silesia/x-ray | 8474240 | stdx 5 | 81.80 | 231.05 | 2.82 | 652.91 |
| silesia/xml | 5345280 | Google q1 | 7.02 | 12.28 | 1.75 | 114.06 |
| silesia/xml | 5345280 | stdx 1 | 7.37 | 17.44 | 2.37 | 153.71 |
| silesia/xml | 5345280 | Google q5 | 30.45 | 72.50 | 2.38 | 358.08 |
| silesia/xml | 5345280 | stdx 5 | 25.67 | 65.03 | 2.53 | 404.20 |
| canterbury/alice29.txt | 152089 | Google q1 | 17.22 | 29.72 | 1.73 | 208.71 |
| canterbury/alice29.txt | 152089 | stdx 1 | 18.40 | 40.79 | 2.22 | 449.36 |
| canterbury/alice29.txt | 152089 | Google q5 | 79.22 | 200.77 | 2.53 | 1038.96 |
| canterbury/alice29.txt | 152089 | stdx 5 | 58.13 | 148.01 | 2.55 | 900.39 |
| canterbury/asyoulik.txt | 125179 | Google q1 | 17.88 | 32.37 | 1.81 | 221.81 |
| canterbury/asyoulik.txt | 125179 | stdx 1 | 20.11 | 44.50 | 2.21 | 500.99 |
| canterbury/asyoulik.txt | 125179 | Google q5 | 84.78 | 215.27 | 2.54 | 1078.12 |
| canterbury/asyoulik.txt | 125179 | stdx 5 | 64.27 | 159.47 | 2.48 | 1040.55 |
| canterbury/cp.html | 24603 | Google q1 | 13.06 | 27.30 | 2.09 | 100.87 |
| canterbury/cp.html | 24603 | stdx 1 | 14.57 | 36.07 | 2.48 | 351.09 |
| canterbury/cp.html | 24603 | Google q5 | 59.61 | 163.89 | 2.75 | 950.41 |
| canterbury/cp.html | 24603 | stdx 5 | 45.94 | 128.83 | 2.80 | 717.03 |
| canterbury/fields.c | 11150 | Google q1 | 12.10 | 29.04 | 2.40 | 11.59 |
| canterbury/fields.c | 11150 | stdx 1 | 10.50 | 38.87 | 3.70 | 85.39 |
| canterbury/fields.c | 11150 | Google q5 | 58.75 | 168.16 | 2.86 | 912.97 |
| canterbury/fields.c | 11150 | stdx 5 | 39.93 | 120.96 | 3.03 | 540.99 |
| canterbury/grammar.lsp | 3721 | Google q1 | 14.38 | 39.39 | 2.74 | 7.70 |
| canterbury/grammar.lsp | 3721 | stdx 1 | 13.55 | 55.22 | 4.07 | 29.99 |
| canterbury/grammar.lsp | 3721 | Google q5 | 60.55 | 203.91 | 3.37 | 442.23 |
| canterbury/grammar.lsp | 3721 | stdx 5 | 39.09 | 145.59 | 3.72 | 178.22 |
| canterbury/kennedy.xls | 1029744 | Google q1 | 9.83 | 24.83 | 2.53 | 59.64 |
| canterbury/kennedy.xls | 1029744 | stdx 1 | 7.81 | 27.03 | 3.46 | 77.15 |
| canterbury/kennedy.xls | 1029744 | Google q5 | 47.53 | 162.91 | 3.43 | 262.70 |
| canterbury/kennedy.xls | 1029744 | stdx 5 | 49.60 | 162.41 | 3.27 | 467.95 |
| canterbury/lcet10.txt | 426754 | Google q1 | 16.14 | 27.19 | 1.68 | 201.14 |
| canterbury/lcet10.txt | 426754 | stdx 1 | 16.78 | 37.84 | 2.25 | 379.91 |
| canterbury/lcet10.txt | 426754 | Google q5 | 77.39 | 187.58 | 2.42 | 956.18 |
| canterbury/lcet10.txt | 426754 | stdx 5 | 56.33 | 139.70 | 2.48 | 889.77 |
| canterbury/plrabn12.txt | 481861 | Google q1 | 19.21 | 32.57 | 1.70 | 252.04 |
| canterbury/plrabn12.txt | 481861 | stdx 1 | 20.83 | 46.66 | 2.24 | 475.24 |
| canterbury/plrabn12.txt | 481861 | Google q5 | 94.94 | 229.77 | 2.42 | 1062.99 |
| canterbury/plrabn12.txt | 481861 | stdx 5 | 70.36 | 167.86 | 2.39 | 1169.14 |
| canterbury/ptt5 | 513216 | Google q1 | 5.11 | 9.55 | 1.87 | 80.63 |
| canterbury/ptt5 | 513216 | stdx 1 | 6.64 | 15.64 | 2.36 | 160.80 |
| canterbury/ptt5 | 513216 | Google q5 | 27.24 | 68.87 | 2.53 | 466.86 |
| canterbury/ptt5 | 513216 | stdx 5 | 27.30 | 69.27 | 2.54 | 456.68 |
| canterbury/sum | 38240 | Google q1 | 12.97 | 29.25 | 2.25 | 88.81 |
| canterbury/sum | 38240 | stdx 1 | 15.56 | 36.37 | 2.34 | 406.65 |
| canterbury/sum | 38240 | Google q5 | 65.56 | 182.58 | 2.78 | 1096.45 |
| canterbury/sum | 38240 | stdx 5 | 55.27 | 155.87 | 2.82 | 826.95 |
| canterbury/xargs.1 | 4227 | Google q1 | 16.24 | 43.16 | 2.66 | 13.18 |
| canterbury/xargs.1 | 4227 | stdx 1 | 14.94 | 59.10 | 3.96 | 48.77 |
| canterbury/xargs.1 | 4227 | Google q5 | 70.36 | 219.02 | 3.11 | 738.14 |
| canterbury/xargs.1 | 4227 | stdx 5 | 43.95 | 155.91 | 3.55 | 302.57 |
| canterbury-large/E.coli | 4638690 | Google q1 | 13.61 | 27.46 | 2.02 | 53.66 |
| canterbury-large/E.coli | 4638690 | stdx 1 | 5.63 | 19.24 | 3.42 | 18.15 |
| canterbury-large/E.coli | 4638690 | Google q5 | 89.37 | 262.67 | 2.94 | 998.90 |
| canterbury-large/E.coli | 4638690 | stdx 5 | 30.54 | 93.11 | 3.05 | 64.48 |
| canterbury-large/bible.txt | 4047392 | Google q1 | 14.73 | 24.57 | 1.67 | 176.26 |
| canterbury-large/bible.txt | 4047392 | stdx 1 | 15.31 | 34.29 | 2.24 | 317.44 |
| canterbury-large/bible.txt | 4047392 | Google q5 | 75.15 | 165.65 | 2.20 | 730.47 |
| canterbury-large/bible.txt | 4047392 | stdx 5 | 56.29 | 134.78 | 2.39 | 801.92 |
| canterbury-large/world192.txt | 2473400 | Google q1 | 13.57 | 22.62 | 1.67 | 196.13 |
| canterbury-large/world192.txt | 2473400 | stdx 1 | 13.75 | 31.07 | 2.26 | 313.97 |
| canterbury-large/world192.txt | 2473400 | Google q5 | 63.72 | 129.46 | 2.03 | 740.41 |
| canterbury-large/world192.txt | 2473400 | stdx 5 | 45.85 | 105.74 | 2.31 | 749.36 |
| http/html-1kx1024 | 1048576 | Google q1 | 32.32 | 62.53 | 1.93 | 861.29 |
| http/html-1kx1024 | 1048576 | stdx 1 | 27.57 | 80.73 | 2.93 | 476.99 |
| http/html-1kx1024 | 1048576 | Google q5 | 106.40 | 260.90 | 2.45 | 2120.26 |
| http/html-1kx1024 | 1048576 | stdx 5 | 62.76 | 167.89 | 2.67 | 1108.71 |
| http/html-16kx64 | 1048576 | Google q1 | 11.31 | 20.38 | 1.80 | 214.78 |
| http/html-16kx64 | 1048576 | stdx 1 | 11.53 | 28.46 | 2.47 | 303.43 |
| http/html-16kx64 | 1048576 | Google q5 | 46.34 | 118.53 | 2.56 | 854.58 |
| http/html-16kx64 | 1048576 | stdx 5 | 35.36 | 92.10 | 2.60 | 635.47 |
| http/html-1m | 1048576 | Google q1 | 8.94 | 15.15 | 1.69 | 137.46 |
| http/html-1m | 1048576 | stdx 1 | 9.64 | 22.18 | 2.30 | 224.82 |
| http/html-1m | 1048576 | Google q5 | 43.62 | 104.93 | 2.41 | 572.99 |
| http/html-1m | 1048576 | stdx 5 | 32.96 | 84.11 | 2.55 | 529.86 |
| http/json-1kx1024 | 1048576 | Google q1 | 24.73 | 49.87 | 2.02 | 654.35 |
| http/json-1kx1024 | 1048576 | stdx 1 | 21.31 | 61.64 | 2.89 | 365.09 |
| http/json-1kx1024 | 1048576 | Google q5 | 79.56 | 203.15 | 2.55 | 1345.08 |
| http/json-1kx1024 | 1048576 | stdx 5 | 46.78 | 131.37 | 2.81 | 707.29 |
| http/json-16kx64 | 1048576 | Google q1 | 7.65 | 14.90 | 1.95 | 141.67 |
| http/json-16kx64 | 1048576 | stdx 1 | 7.05 | 19.73 | 2.80 | 159.73 |
| http/json-16kx64 | 1048576 | Google q5 | 35.76 | 97.81 | 2.74 | 559.06 |
| http/json-16kx64 | 1048576 | stdx 5 | 31.50 | 88.58 | 2.81 | 517.18 |
| http/json-1m | 1048576 | Google q1 | 6.20 | 12.65 | 2.04 | 91.34 |
| http/json-1m | 1048576 | stdx 1 | 6.63 | 17.21 | 2.60 | 140.75 |
| http/json-1m | 1048576 | Google q5 | 35.87 | 96.08 | 2.68 | 444.93 |
| http/json-1m | 1048576 | stdx 5 | 34.05 | 92.25 | 2.71 | 561.85 |
| http/js-1kx1024 | 1048576 | Google q1 | 34.97 | 68.18 | 1.95 | 913.93 |
| http/js-1kx1024 | 1048576 | stdx 1 | 30.75 | 90.40 | 2.94 | 537.33 |
| http/js-1kx1024 | 1048576 | Google q5 | 116.29 | 288.57 | 2.48 | 2299.72 |
| http/js-1kx1024 | 1048576 | stdx 5 | 69.14 | 186.45 | 2.70 | 1234.83 |
| http/js-16kx64 | 1048576 | Google q1 | 13.13 | 24.07 | 1.83 | 230.32 |
| http/js-16kx64 | 1048576 | stdx 1 | 13.36 | 32.69 | 2.45 | 355.88 |
| http/js-16kx64 | 1048576 | Google q5 | 54.56 | 141.15 | 2.59 | 1000.32 |
| http/js-16kx64 | 1048576 | stdx 5 | 41.12 | 106.28 | 2.58 | 747.43 |
| http/js-1m | 1048576 | Google q1 | 9.74 | 16.69 | 1.71 | 140.93 |
| http/js-1m | 1048576 | stdx 1 | 10.12 | 23.55 | 2.33 | 229.13 |
| http/js-1m | 1048576 | Google q5 | 48.75 | 116.02 | 2.38 | 634.67 |
| http/js-1m | 1048576 | stdx 5 | 35.63 | 90.22 | 2.53 | 575.47 |
| http/css-1kx1024 | 1048576 | Google q1 | 27.73 | 54.06 | 1.95 | 732.48 |
| http/css-1kx1024 | 1048576 | stdx 1 | 23.85 | 68.32 | 2.86 | 430.94 |
| http/css-1kx1024 | 1048576 | Google q5 | 86.42 | 213.92 | 2.48 | 1660.48 |
| http/css-1kx1024 | 1048576 | stdx 5 | 50.87 | 137.20 | 2.70 | 881.59 |
| http/css-16kx64 | 1048576 | Google q1 | 9.01 | 16.85 | 1.87 | 141.60 |
| http/css-16kx64 | 1048576 | stdx 1 | 8.49 | 23.62 | 2.78 | 193.51 |
| http/css-16kx64 | 1048576 | Google q5 | 37.30 | 100.68 | 2.70 | 646.99 |
| http/css-16kx64 | 1048576 | stdx 5 | 28.72 | 80.59 | 2.81 | 485.52 |
| http/css-1m | 1048576 | Google q1 | 6.02 | 11.27 | 1.87 | 75.90 |
| http/css-1m | 1048576 | stdx 1 | 5.42 | 14.38 | 2.65 | 110.44 |
| http/css-1m | 1048576 | Google q5 | 14.21 | 38.50 | 2.71 | 130.50 |
| http/css-1m | 1048576 | stdx 5 | 11.58 | 36.69 | 3.17 | 111.61 |
| shuffled/dickens-1m | 1048576 | Google q1 | 11.44 | 20.96 | 1.83 | 2.79 |
| shuffled/dickens-1m | 1048576 | stdx 1 | 5.22 | 19.75 | 3.79 | 10.20 |
| shuffled/dickens-1m | 1048576 | Google q5 | 89.70 | 235.57 | 2.63 | 723.06 |
| shuffled/dickens-1m | 1048576 | stdx 5 | 40.47 | 122.09 | 3.02 | 202.73 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.118 | 3.00 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 65.8 | 219.6 | 0.086 | 7.78 | 3.34 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 30.6 | 96.1 | 0.164 | 3.62 | 3.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextReader.next_items | 28.3 | 80.8 | 0.153 | 3.35 | 2.85 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 250.0 | 1024.0 | 0.832 | 29.53 | 4.10 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.8 | 107.7 | 0.132 | 3.64 | 3.50 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.9 | 106.2 | 0.295 | 3.30 | 3.81 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 94.9 | 378.2 | 0.360 | 11.21 | 3.99 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.4 | 161.9 | 0.441 | 5.01 | 3.82 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 89.7 | 451.7 | 0.303 | 10.59 | 5.04 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 26.7 | 89.5 | 0.005 | 3.92 | 3.36 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 67.5 | 234.7 | 0.041 | 9.93 | 3.48 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 29.2 | 99.4 | 0.014 | 4.30 | 3.40 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextReader.next_items | 27.1 | 84.2 | 0.009 | 4.00 | 3.10 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 216.7 | 819.1 | 0.968 | 31.90 | 3.78 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.3 | 107.7 | 0.039 | 4.17 | 3.80 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.3 | 106.0 | 0.048 | 4.31 | 3.62 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 95.1 | 346.2 | 0.335 | 14.00 | 3.64 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 31.6 | 144.5 | 0.052 | 4.66 | 4.57 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 88.4 | 406.5 | 0.092 | 13.02 | 4.60 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 41.2 | 96.3 | 0.193 | 3.86 | 2.34 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 84.3 | 249.4 | 0.236 | 7.90 | 2.96 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 45.6 | 113.8 | 0.282 | 4.28 | 2.49 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextReader.next_items | 43.0 | 99.4 | 0.208 | 4.03 | 2.31 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 313.1 | 1284.6 | 1.062 | 29.33 | 4.10 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 36.5 | 133.1 | 0.183 | 3.42 | 3.64 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 45.9 | 128.6 | 0.683 | 4.30 | 2.80 |
| messages: 11 string members | 96000 | 1025025 | std.json | 123.1 | 451.2 | 1.036 | 11.53 | 3.67 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 66.7 | 204.1 | 0.975 | 6.24 | 3.06 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 133.7 | 572.0 | 0.826 | 12.52 | 4.28 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 24.4 | 78.8 | 0.023 | 3.05 | 3.23 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 67.1 | 239.5 | 0.006 | 8.40 | 3.57 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 28.0 | 93.3 | 0.044 | 3.51 | 3.33 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextReader.next_items | 26.0 | 78.0 | 0.033 | 3.25 | 3.00 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 232.7 | 942.3 | 0.442 | 29.13 | 4.05 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 28.4 | 107.6 | 0.059 | 3.55 | 3.79 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 25.6 | 104.8 | 0.022 | 3.20 | 4.10 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 89.3 | 361.0 | 0.028 | 11.18 | 4.04 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 32.6 | 151.6 | 0.050 | 4.09 | 4.64 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 79.4 | 418.3 | 0.008 | 9.94 | 5.27 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim on | 12.9 | 56.5 | 0.050 | 5.90 | 4.39 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, one token a call | 50.3 | 172.6 | 0.123 | 23.08 | 3.43 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, TextWriter's methods or TextReader.next | 16.6 | 73.4 | 0.078 | 7.61 | 4.42 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, TextReader.next_items | 13.8 | 57.7 | 0.048 | 6.33 | 4.18 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim off | 101.6 | 326.3 | 0.266 | 46.62 | 3.21 |
| messages: a tree of 341 objects | 281100 | 612600 | simdjson | 16.2 | 58.4 | 0.024 | 7.44 | 3.60 |
| messages: a tree of 341 objects | 281100 | 612600 | yyjson | 15.9 | 72.2 | 0.047 | 7.31 | 4.53 |
| messages: a tree of 341 objects | 281100 | 612600 | std.json | 59.4 | 220.1 | 0.118 | 27.28 | 3.70 |
| messages: a tree of 341 objects | 281100 | 612600 | serde_json | 13.6 | 59.5 | 0.092 | 6.23 | 4.38 |
| messages: a tree of 341 objects | 281100 | 612600 | Go jsontext | 43.4 | 216.0 | 0.116 | 19.92 | 4.98 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114524.0 | 403852.2 | 499.691 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 590603.9 | 2495394.2 | 1385.938 | 3.42 | 4.23 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 113985.1 | 404249.2 | 465.072 | 0.66 | 3.55 |
| string: silesia/dickens | 1 | 172528 | stdx, TextReader.next_items | 113723.0 | 404282.2 | 460.206 | 0.66 | 3.55 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3560434.9 | 18223882.2 | 2976.763 | 20.64 | 5.12 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311361.0 | 621744.2 | 580.186 | 1.80 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 224439.3 | 826630.2 | 2266.216 | 1.30 | 3.68 |
| string: silesia/dickens | 1 | 172528 | std.json | 1572436.2 | 4578768.2 | 42335.619 | 9.11 | 2.91 |
| string: silesia/dickens | 1 | 172528 | serde_json | 204144.7 | 802909.2 | 994.144 | 1.18 | 3.93 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1057204.6 | 5280780.3 | 4945.186 | 6.13 | 5.00 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1572319.6 | 4799769.6 | 1743.643 | 1.32 | 3.05 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14097700.6 | 56410893.6 | 39334.429 | 11.84 | 4.00 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1570791.4 | 4799955.6 | 1641.071 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, TextReader.next_items | 1570103.7 | 4799988.6 | 1602.214 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 28980561.9 | 132108259.6 | 159005.071 | 24.35 | 4.56 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4587357.6 | 7062781.6 | 582.929 | 3.85 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1786589.0 | 7322029.6 | 14484.143 | 1.50 | 4.10 |
| string: http/json-1m | 1 | 1190272 | std.json | 10402221.1 | 47381157.6 | 34275.786 | 8.74 | 4.55 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3794736.3 | 15226584.6 | 6029.143 | 3.19 | 4.01 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9172304.1 | 48022600.3 | 27530.000 | 7.71 | 5.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2069294.6 | 5765419.8 | 4378.875 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6170908.5 | 22538840.8 | 6989.125 | 3.28 | 3.65 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2056437.6 | 5765605.8 | 3899.125 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextReader.next_items | 2053594.8 | 5765638.8 | 3790.125 | 1.09 | 2.81 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47341523.3 | 227842326.8 | 281195.375 | 25.14 | 4.81 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3765829.5 | 8446023.8 | 1957.375 | 2.00 | 2.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7135104.1 | 12276717.8 | 275698.500 | 3.79 | 1.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17438542.9 | 63617055.8 | 265750.250 | 9.26 | 3.65 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9373730.1 | 24440998.8 | 325026.125 | 4.98 | 2.61 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39235959.8 | 160311923.0 | 834189.375 | 20.84 | 4.09 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12895825.7 | 42561075.3 | 244623.667 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 160240264.7 | 666700955.3 | 394758.000 | 31.57 | 4.16 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12931738.0 | 42561261.3 | 244318.333 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextReader.next_items | 12936811.3 | 42561294.3 | 243710.667 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 160587960.0 | 639992668.3 | 424765.000 | 31.64 | 3.99 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17543855.0 | 49745820.3 | 252115.667 | 3.46 | 2.84 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14230581.0 | 45615166.3 | 444625.333 | 2.80 | 3.21 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79281999.7 | 314900845.3 | 458309.333 | 15.62 | 3.97 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36746431.3 | 131556418.3 | 602120.000 | 7.24 | 3.58 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66118269.3 | 273923688.7 | 837945.667 | 13.03 | 4.14 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 92507.4 | 303842.7 | 3.871 | 0.18 | 3.28 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 183677.4 | 623466.7 | 9.742 | 0.35 | 3.39 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 147908.3 | 557622.7 | 5.903 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextReader.next_items | 147984.0 | 557626.7 | 5.355 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10223271.7 | 53478208.7 | 6.935 | 19.50 | 5.23 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 488864.0 | 1376733.7 | 5.710 | 0.93 | 2.82 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 536138.9 | 2195917.7 | 6.613 | 1.02 | 4.10 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3488389.2 | 12808414.7 | 60970.419 | 6.65 | 3.67 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 287623.2 | 1179969.7 | 5.355 | 0.55 | 4.10 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2252533.0 | 12787982.1 | 251.484 | 4.30 | 5.68 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.9 | 81.8 | 0.110 | 2.35 | 4.12 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.3 | 153.5 | 0.131 | 4.17 | 4.35 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 21.3 | 93.4 | 0.092 | 2.52 | 4.38 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 217.6 | 981.0 | 0.928 | 25.70 | 4.51 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 18.7 | 79.5 | 0.109 | 2.21 | 4.24 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.0 | 94.1 | 0.137 | 2.72 | 4.09 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.4 | 105.6 | 0.249 | 3.23 | 3.86 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.4 | 310.8 | 0.372 | 8.19 | 4.48 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 65.4 | 255.3 | 0.507 | 7.72 | 3.91 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.0 | 315.1 | 0.237 | 8.04 | 4.63 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 19.1 | 82.8 | 0.024 | 2.82 | 4.32 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.1 | 153.9 | 0.026 | 5.32 | 4.26 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 21.6 | 94.2 | 0.024 | 3.19 | 4.35 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 171.4 | 718.3 | 1.304 | 25.23 | 4.19 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.2 | 81.5 | 0.026 | 2.68 | 4.48 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 22.0 | 96.8 | 0.032 | 3.24 | 4.40 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.8 | 117.9 | 0.033 | 4.23 | 4.10 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 60.3 | 271.2 | 0.276 | 8.88 | 4.50 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 49.3 | 212.7 | 0.038 | 7.26 | 4.31 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 81.3 | 331.7 | 0.088 | 11.97 | 4.08 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 31.2 | 85.9 | 0.378 | 2.93 | 2.75 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 43.1 | 151.2 | 0.426 | 4.03 | 3.51 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 29.4 | 92.6 | 0.400 | 2.75 | 3.15 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 276.9 | 1195.0 | 1.139 | 25.93 | 4.32 |
| messages: 11 string members | 96000 | 1025025 | stdx, J11's loop unchecked | 28.8 | 82.8 | 0.394 | 2.70 | 2.87 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 37.6 | 119.1 | 0.583 | 3.52 | 3.17 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 46.1 | 138.2 | 0.709 | 4.32 | 3.00 |
| messages: 11 string members | 96000 | 1025025 | std.json | 99.0 | 370.8 | 1.041 | 9.27 | 3.74 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 90.6 | 315.4 | 0.753 | 8.49 | 3.48 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 107.8 | 400.7 | 0.868 | 10.09 | 3.72 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 20.4 | 80.2 | 0.007 | 2.55 | 3.93 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 37.6 | 152.5 | 0.006 | 4.70 | 4.06 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 21.5 | 93.2 | 0.006 | 2.69 | 4.33 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 197.7 | 866.7 | 0.763 | 24.75 | 4.38 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, J11's loop unchecked | 19.5 | 79.4 | 0.007 | 2.44 | 4.08 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 23.5 | 96.6 | 0.004 | 2.94 | 4.12 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 25.2 | 101.3 | 0.018 | 3.15 | 4.02 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 58.7 | 279.4 | 0.006 | 7.35 | 4.76 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 52.2 | 230.6 | 0.048 | 6.54 | 4.42 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 68.3 | 310.8 | 0.006 | 8.55 | 4.55 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim on | 15.9 | 62.6 | 0.023 | 7.30 | 3.93 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, one token a call | 32.0 | 135.7 | 0.031 | 14.67 | 4.24 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, TextWriter's methods or TextReader.next | 18.2 | 81.6 | 0.026 | 8.36 | 4.48 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim off | 82.0 | 375.6 | 0.234 | 37.61 | 4.58 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, J11's loop unchecked | 14.9 | 61.4 | 0.023 | 6.83 | 4.13 |
| messages: a tree of 341 objects | 281100 | 612600 | simdjson | 12.3 | 45.5 | 0.024 | 5.64 | 3.70 |
| messages: a tree of 341 objects | 281100 | 612600 | yyjson | 15.5 | 56.5 | 0.050 | 7.13 | 3.64 |
| messages: a tree of 341 objects | 281100 | 612600 | std.json | 27.7 | 125.4 | 0.045 | 12.70 | 4.53 |
| messages: a tree of 341 objects | 281100 | 612600 | serde_json | 23.6 | 102.3 | 0.028 | 10.81 | 4.34 |
| messages: a tree of 341 objects | 281100 | 612600 | Go jsontext | 41.8 | 181.3 | 0.120 | 19.19 | 4.33 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 84870.9 | 280786.2 | 721.856 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84758.0 | 280732.2 | 721.010 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84823.2 | 280721.2 | 721.907 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3379731.1 | 16047574.2 | 2951.619 | 19.59 | 4.75 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 83144.1 | 274401.2 | 659.289 | 0.48 | 3.30 |
| string: silesia/dickens | 1 | 172528 | simdjson | 208100.4 | 674016.2 | 2090.897 | 1.21 | 3.24 |
| string: silesia/dickens | 1 | 172528 | yyjson | 203663.1 | 825518.2 | 1022.423 | 1.18 | 4.05 |
| string: silesia/dickens | 1 | 172528 | std.json | 1392323.9 | 2890892.2 | 56137.186 | 8.07 | 2.08 |
| string: silesia/dickens | 1 | 172528 | serde_json | 390888.6 | 1586249.2 | 2631.722 | 2.27 | 4.06 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 591676.8 | 2970296.2 | 3339.495 | 3.43 | 5.02 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1321868.6 | 3582350.6 | 13104.786 | 1.11 | 2.71 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1304393.8 | 3582290.6 | 12406.429 | 1.10 | 2.75 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1303017.8 | 3582277.6 | 12344.714 | 1.09 | 2.75 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25291087.2 | 109856348.6 | 141523.286 | 21.25 | 4.34 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1229358.9 | 3370022.6 | 10974.214 | 1.03 | 2.74 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2980624.1 | 10460762.6 | 30021.500 | 2.50 | 3.51 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2578873.9 | 10197931.6 | 9637.571 | 2.17 | 3.95 |
| string: http/json-1m | 1 | 1190272 | std.json | 9037452.9 | 43287986.6 | 16799.786 | 7.59 | 4.79 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4281564.7 | 17941088.6 | 11306.214 | 3.60 | 4.19 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5215342.6 | 26999444.5 | 11298.714 | 4.38 | 5.18 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2072502.8 | 6088099.8 | 4592.875 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2068407.1 | 6088043.8 | 4200.625 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2063468.1 | 6088026.8 | 4057.750 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43664798.4 | 193466553.8 | 267575.750 | 23.19 | 4.43 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2078177.3 | 5875346.8 | 5077.750 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2713977.6 | 7144143.8 | 21383.250 | 1.44 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12058664.0 | 23590602.8 | 445592.250 | 6.40 | 1.96 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20744141.0 | 56837736.8 | 555871.750 | 11.02 | 2.74 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11555928.8 | 33662338.8 | 335137.625 | 6.14 | 2.91 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18200810.1 | 76319282.1 | 252532.375 | 9.67 | 4.19 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113791.0 | 426376.7 | 2.516 | 0.22 | 3.75 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113769.6 | 426318.7 | 3.968 | 0.22 | 3.75 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113610.1 | 426305.7 | 2.613 | 0.22 | 3.75 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 638677.6 | 3146479.7 | 6.839 | 1.22 | 4.93 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113626.5 | 426343.7 | 1.677 | 0.22 | 3.75 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1204240.0 | 3866916.7 | 4.613 | 2.30 | 3.21 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1622344.0 | 5833341.7 | 4.871 | 3.09 | 3.60 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3600719.5 | 13108830.7 | 79191.774 | 6.87 | 3.64 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1883478.5 | 7405810.7 | 4.935 | 3.59 | 3.93 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2383927.3 | 12748312.3 | 20.355 | 4.55 | 5.35 |
