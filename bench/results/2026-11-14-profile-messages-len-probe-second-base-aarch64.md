# bench-profile

| Field | Value |
|---|---|
| Commit | 7696e57 |
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
| silesia/dickens | 10192446 | zlib | 8.85 | 19.08 | 2.16 | 310.98 |
| silesia/dickens | 10192446 | zlib-ng | 4.94 | 10.50 | 2.13 | 67.81 |
| silesia/dickens | 10192446 | libdeflate | 3.53 | 9.56 | 2.71 | 66.56 |
| silesia/dickens | 10192446 | Wuffs | 5.56 | 13.90 | 2.50 | 97.15 |
| silesia/dickens | 10192446 | stdx | 3.03 | 7.15 | 2.36 | 75.93 |
| silesia/mozilla | 51220480 | zlib | 8.51 | 17.23 | 2.03 | 252.07 |
| silesia/mozilla | 51220480 | zlib-ng | 4.97 | 8.95 | 1.80 | 85.42 |
| silesia/mozilla | 51220480 | libdeflate | 3.51 | 7.63 | 2.18 | 71.17 |
| silesia/mozilla | 51220480 | Wuffs | 6.42 | 13.89 | 2.16 | 132.62 |
| silesia/mozilla | 51220480 | stdx | 3.68 | 6.29 | 1.71 | 89.68 |
| silesia/mr | 9970564 | zlib | 8.46 | 18.46 | 2.18 | 202.31 |
| silesia/mr | 9970564 | zlib-ng | 4.83 | 9.98 | 2.06 | 67.96 |
| silesia/mr | 9970564 | libdeflate | 3.39 | 8.58 | 2.53 | 61.25 |
| silesia/mr | 9970564 | Wuffs | 6.02 | 14.04 | 2.33 | 99.85 |
| silesia/mr | 9970564 | stdx | 3.21 | 6.70 | 2.09 | 69.95 |
| silesia/nci | 33553445 | zlib | 3.60 | 10.18 | 2.83 | 81.18 |
| silesia/nci | 33553445 | zlib-ng | 1.64 | 3.13 | 1.91 | 33.70 |
| silesia/nci | 33553445 | libdeflate | 1.20 | 2.66 | 2.22 | 29.76 |
| silesia/nci | 33553445 | Wuffs | 2.49 | 6.47 | 2.60 | 41.61 |
| silesia/nci | 33553445 | stdx | 1.36 | 2.20 | 1.62 | 37.40 |
| silesia/ooffice | 6152192 | zlib | 11.79 | 21.06 | 1.79 | 416.75 |
| silesia/ooffice | 6152192 | zlib-ng | 6.95 | 12.04 | 1.73 | 141.91 |
| silesia/ooffice | 6152192 | libdeflate | 4.91 | 10.45 | 2.13 | 125.08 |
| silesia/ooffice | 6152192 | Wuffs | 8.83 | 17.54 | 1.99 | 220.40 |
| silesia/ooffice | 6152192 | stdx | 5.15 | 8.55 | 1.66 | 151.62 |
| silesia/osdb | 10085684 | zlib | 7.49 | 16.59 | 2.21 | 182.19 |
| silesia/osdb | 10085684 | zlib-ng | 4.36 | 8.38 | 1.92 | 53.04 |
| silesia/osdb | 10085684 | libdeflate | 2.87 | 6.91 | 2.41 | 29.70 |
| silesia/osdb | 10085684 | Wuffs | 5.80 | 13.61 | 2.35 | 78.18 |
| silesia/osdb | 10085684 | stdx | 2.88 | 5.65 | 1.96 | 41.24 |
| silesia/reymont | 6627202 | zlib | 7.41 | 15.89 | 2.14 | 260.12 |
| silesia/reymont | 6627202 | zlib-ng | 3.74 | 7.72 | 2.07 | 60.56 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.21 |
| silesia/reymont | 6627202 | Wuffs | 4.89 | 11.40 | 2.33 | 112.21 |
| silesia/reymont | 6627202 | stdx | 2.30 | 5.11 | 2.22 | 64.39 |
| silesia/samba | 21606400 | zlib | 6.25 | 14.13 | 2.26 | 175.21 |
| silesia/samba | 21606400 | zlib-ng | 3.41 | 6.47 | 1.90 | 55.99 |
| silesia/samba | 21606400 | libdeflate | 2.42 | 5.58 | 2.31 | 42.97 |
| silesia/samba | 21606400 | Wuffs | 4.37 | 10.39 | 2.38 | 79.71 |
| silesia/samba | 21606400 | stdx | 2.45 | 4.46 | 1.82 | 56.57 |
| silesia/sao | 7251944 | zlib | 10.53 | 23.54 | 2.24 | 203.79 |
| silesia/sao | 7251944 | zlib-ng | 7.91 | 14.83 | 1.88 | 79.50 |
| silesia/sao | 7251944 | libdeflate | 5.80 | 12.73 | 2.20 | 78.93 |
| silesia/sao | 7251944 | Wuffs | 8.91 | 21.26 | 2.39 | 86.50 |
| silesia/sao | 7251944 | stdx | 5.76 | 10.32 | 1.79 | 89.49 |
| silesia/webster | 41458703 | zlib | 7.82 | 16.16 | 2.07 | 281.67 |
| silesia/webster | 41458703 | zlib-ng | 4.25 | 8.04 | 1.89 | 85.20 |
| silesia/webster | 41458703 | libdeflate | 2.98 | 7.17 | 2.41 | 68.75 |
| silesia/webster | 41458703 | Wuffs | 5.16 | 11.67 | 2.26 | 122.53 |
| silesia/webster | 41458703 | stdx | 2.88 | 5.56 | 1.93 | 87.27 |
| silesia/x-ray | 8474240 | zlib | 12.91 | 27.21 | 2.11 | 329.02 |
| silesia/x-ray | 8474240 | zlib-ng | 9.07 | 17.39 | 1.92 | 124.06 |
| silesia/x-ray | 8474240 | libdeflate | 6.58 | 15.26 | 2.32 | 124.34 |
| silesia/x-ray | 8474240 | Wuffs | 10.82 | 23.52 | 2.17 | 190.94 |
| silesia/x-ray | 8474240 | stdx | 6.26 | 11.49 | 1.84 | 138.79 |
| silesia/xml | 5345280 | zlib | 4.31 | 11.16 | 2.59 | 117.97 |
| silesia/xml | 5345280 | zlib-ng | 2.02 | 3.88 | 1.92 | 42.74 |
| silesia/xml | 5345280 | libdeflate | 1.37 | 3.33 | 2.44 | 31.93 |
| silesia/xml | 5345280 | Wuffs | 2.84 | 7.22 | 2.54 | 58.98 |
| silesia/xml | 5345280 | stdx | 1.34 | 2.65 | 1.98 | 41.92 |
| canterbury/alice29.txt | 152089 | zlib | 8.43 | 18.35 | 2.18 | 294.15 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.37 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.18 | 8.96 | 2.82 | 54.16 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.37 | 13.40 | 2.50 | 98.55 |
| canterbury/alice29.txt | 152089 | stdx | 2.72 | 6.99 | 2.57 | 63.21 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.03 | 19.42 | 2.15 | 314.04 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 72.80 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.59 | 9.82 | 2.74 | 66.67 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.77 | 14.40 | 2.49 | 100.12 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.06 | 7.52 | 2.46 | 77.02 |
| canterbury/cp.html | 24603 | zlib | 7.05 | 17.33 | 2.46 | 170.89 |
| canterbury/cp.html | 24603 | zlib-ng | 4.18 | 9.50 | 2.27 | 37.29 |
| canterbury/cp.html | 24603 | libdeflate | 2.87 | 7.95 | 2.77 | 17.12 |
| canterbury/cp.html | 24603 | Wuffs | 5.20 | 13.91 | 2.68 | 59.22 |
| canterbury/cp.html | 24603 | stdx | 2.64 | 7.19 | 2.72 | 12.56 |
| canterbury/fields.c | 11150 | zlib | 5.26 | 17.73 | 3.37 | 37.87 |
| canterbury/fields.c | 11150 | zlib-ng | 3.88 | 10.20 | 2.63 | 15.25 |
| canterbury/fields.c | 11150 | libdeflate | 2.81 | 8.32 | 2.96 | 1.25 |
| canterbury/fields.c | 11150 | Wuffs | 4.52 | 14.54 | 3.22 | 9.62 |
| canterbury/fields.c | 11150 | stdx | 2.52 | 7.64 | 3.03 | 5.81 |
| canterbury/grammar.lsp | 3721 | zlib | 6.90 | 24.26 | 3.52 | 5.33 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.82 | 17.48 | 3.00 | 7.39 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.53 | 12.05 | 2.66 | 1.16 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.68 | 21.86 | 3.27 | 4.46 |
| canterbury/grammar.lsp | 3721 | stdx | 3.85 | 12.18 | 3.16 | 1.03 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.59 | 15.27 | 3.33 | 48.76 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.56 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.02 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.87 | 11.59 | 3.00 | 14.91 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.74 | 4.66 | 2.68 | 16.64 |
| canterbury/lcet10.txt | 426754 | zlib | 8.20 | 17.78 | 2.17 | 289.54 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.17 | 61.27 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.97 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.22 | 12.88 | 2.47 | 101.22 |
| canterbury/lcet10.txt | 426754 | stdx | 2.59 | 6.42 | 2.48 | 66.19 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.21 | 19.86 | 2.16 | 322.22 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.30 | 11.19 | 2.11 | 79.09 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.70 | 77.47 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.83 | 14.61 | 2.51 | 99.59 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 7.63 | 2.42 | 85.31 |
| canterbury/ptt5 | 513216 | zlib | 5.05 | 10.71 | 2.12 | 103.07 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.71 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.09 | 38.14 |
| canterbury/ptt5 | 513216 | Wuffs | 3.00 | 7.13 | 2.37 | 57.66 |
| canterbury/ptt5 | 513216 | stdx | 1.44 | 2.55 | 1.77 | 49.09 |
| canterbury/sum | 38240 | zlib | 7.99 | 18.12 | 2.27 | 223.40 |
| canterbury/sum | 38240 | zlib-ng | 4.64 | 10.02 | 2.16 | 56.46 |
| canterbury/sum | 38240 | libdeflate | 3.27 | 8.34 | 2.55 | 31.54 |
| canterbury/sum | 38240 | Wuffs | 5.77 | 14.47 | 2.51 | 80.79 |
| canterbury/sum | 38240 | stdx | 3.04 | 7.73 | 2.54 | 29.61 |
| canterbury/xargs.1 | 4227 | zlib | 7.41 | 25.22 | 3.41 | 12.44 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.37 | 17.97 | 2.82 | 9.58 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.84 | 13.27 | 2.74 | 0.13 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.24 | 22.63 | 3.13 | 12.25 |
| canterbury/xargs.1 | 4227 | stdx | 4.25 | 12.86 | 3.03 | 3.10 |
| canterbury-large/E.coli | 4638690 | zlib | 6.79 | 17.84 | 2.63 | 177.41 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.27 | 9.68 | 2.27 | 47.10 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.05 | 8.86 | 2.91 | 48.39 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.67 | 12.73 | 2.73 | 61.72 |
| canterbury-large/E.coli | 4638690 | stdx | 2.52 | 6.72 | 2.67 | 54.22 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.56 | 16.46 | 2.18 | 266.07 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.80 | 8.26 | 2.17 | 53.78 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.27 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.82 | 11.73 | 2.43 | 100.78 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.24 | 5.57 | 2.48 | 55.79 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.77 | 15.84 | 2.04 | 282.93 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.42 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.89 | 6.92 | 2.40 | 75.28 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.18 | 11.48 | 2.22 | 127.95 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.74 | 5.40 | 1.97 | 90.81 |
| http/html-1kx1024 | 1048576 | zlib | 16.69 | 35.58 | 2.13 | 351.62 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.69 | 28.43 | 2.24 | 217.34 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.85 | 20.05 | 1.85 | 155.43 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.35 | 38.07 | 2.48 | 266.04 |
| http/html-1kx1024 | 1048576 | stdx | 8.40 | 20.88 | 2.48 | 137.45 |
| http/html-16kx64 | 1048576 | zlib | 6.73 | 14.77 | 2.19 | 221.92 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.86 | 7.54 | 1.95 | 85.66 |
| http/html-16kx64 | 1048576 | libdeflate | 2.66 | 6.04 | 2.28 | 60.67 |
| http/html-16kx64 | 1048576 | Wuffs | 4.92 | 11.56 | 2.35 | 114.96 |
| http/html-16kx64 | 1048576 | stdx | 2.51 | 5.56 | 2.22 | 58.97 |
| http/html-1m | 1048576 | zlib | 5.32 | 12.53 | 2.36 | 176.72 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 60.13 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.64 |
| http/html-1m | 1048576 | Wuffs | 3.60 | 8.48 | 2.35 | 87.83 |
| http/html-1m | 1048576 | stdx | 1.65 | 3.46 | 2.10 | 52.82 |
| http/json-1kx1024 | 1048576 | zlib | 10.60 | 23.92 | 2.26 | 191.91 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.39 | 16.69 | 2.26 | 130.02 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.14 | 16.72 | 1.83 | 92.12 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.14 | 34.78 | 2.86 | 146.72 |
| http/json-1kx1024 | 1048576 | stdx | 5.05 | 13.12 | 2.60 | 81.05 |
| http/json-16kx64 | 1048576 | zlib | 4.56 | 12.51 | 2.74 | 103.52 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.80 |
| http/json-16kx64 | 1048576 | libdeflate | 1.93 | 4.24 | 2.19 | 40.53 |
| http/json-16kx64 | 1048576 | Wuffs | 3.50 | 9.43 | 2.70 | 58.07 |
| http/json-16kx64 | 1048576 | stdx | 1.75 | 3.97 | 2.26 | 39.49 |
| http/json-1m | 1048576 | zlib | 3.84 | 11.20 | 2.92 | 83.20 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.02 | 37.45 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.78 |
| http/json-1m | 1048576 | Wuffs | 2.73 | 7.37 | 2.70 | 43.48 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.02 | 40.21 |
| http/js-1kx1024 | 1048576 | zlib | 18.26 | 38.46 | 2.11 | 411.48 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.80 | 31.25 | 2.26 | 239.68 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.54 | 21.58 | 1.87 | 178.88 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.59 | 40.70 | 2.45 | 301.06 |
| http/js-1kx1024 | 1048576 | stdx | 9.28 | 22.85 | 2.46 | 159.22 |
| http/js-16kx64 | 1048576 | zlib | 7.67 | 16.08 | 2.10 | 264.03 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.97 | 92.10 |
| http/js-16kx64 | 1048576 | libdeflate | 3.08 | 7.01 | 2.28 | 72.27 |
| http/js-16kx64 | 1048576 | Wuffs | 5.50 | 12.75 | 2.32 | 128.77 |
| http/js-16kx64 | 1048576 | stdx | 3.01 | 6.54 | 2.17 | 72.17 |
| http/js-1m | 1048576 | zlib | 5.87 | 13.31 | 2.27 | 201.68 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 60.07 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 42.16 |
| http/js-1m | 1048576 | Wuffs | 3.91 | 9.14 | 2.34 | 94.08 |
| http/js-1m | 1048576 | stdx | 1.80 | 3.89 | 2.16 | 55.31 |
| http/css-1kx1024 | 1048576 | zlib | 14.03 | 30.36 | 2.16 | 280.69 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.26 | 23.04 | 2.24 | 171.47 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.46 | 17.37 | 1.84 | 121.44 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.78 | 32.49 | 2.54 | 211.55 |
| http/css-1kx1024 | 1048576 | stdx | 6.70 | 17.64 | 2.63 | 100.68 |
| http/css-16kx64 | 1048576 | zlib | 5.31 | 13.04 | 2.45 | 153.37 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.77 | 6.07 | 2.19 | 49.94 |
| http/css-16kx64 | 1048576 | libdeflate | 1.91 | 4.69 | 2.46 | 29.81 |
| http/css-16kx64 | 1048576 | Wuffs | 3.79 | 10.01 | 2.64 | 69.69 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.53 | 28.34 |
| http/css-1m | 1048576 | zlib | 3.99 | 10.97 | 2.75 | 108.83 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.22 | 29.13 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.98 | 12.58 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.77 | 43.66 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.52 | 21.60 |
| shuffled/dickens-1m | 1048576 | zlib | 13.32 | 25.88 | 1.94 | 373.57 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.74 | 16.72 | 1.72 | 196.43 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.04 | 14.95 | 2.12 | 195.48 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.50 | 22.08 | 2.10 | 202.89 |
| shuffled/dickens-1m | 1048576 | stdx | 7.08 | 11.89 | 1.68 | 206.72 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.57 | 14.05 | 3.93 | 3.39 |
| silesia/dickens | 10192446 | stdx | 3.74 | 12.47 | 3.33 | 3.59 |
| silesia/mozilla | 51220480 | libzstd | 2.86 | 9.68 | 3.39 | 30.15 |
| silesia/mozilla | 51220480 | stdx | 2.88 | 9.68 | 3.36 | 15.73 |
| silesia/mr | 9970564 | libzstd | 3.01 | 11.99 | 3.98 | 6.15 |
| silesia/mr | 9970564 | stdx | 3.15 | 10.83 | 3.44 | 5.18 |
| silesia/nci | 33553445 | libzstd | 1.68 | 4.88 | 2.90 | 24.83 |
| silesia/nci | 33553445 | stdx | 1.92 | 4.63 | 2.41 | 13.54 |
| silesia/ooffice | 6152192 | libzstd | 3.40 | 12.19 | 3.58 | 31.01 |
| silesia/ooffice | 6152192 | stdx | 3.38 | 12.40 | 3.66 | 12.32 |
| silesia/osdb | 10085684 | libzstd | 2.37 | 8.45 | 3.57 | 14.88 |
| silesia/osdb | 10085684 | stdx | 2.49 | 8.11 | 3.25 | 15.41 |
| silesia/reymont | 6627202 | libzstd | 3.20 | 11.62 | 3.64 | 11.57 |
| silesia/reymont | 6627202 | stdx | 3.38 | 10.36 | 3.07 | 12.65 |
| silesia/samba | 21606400 | libzstd | 2.16 | 7.41 | 3.42 | 18.60 |
| silesia/samba | 21606400 | stdx | 2.26 | 6.83 | 3.02 | 17.62 |
| silesia/sao | 7251944 | libzstd | 3.84 | 12.72 | 3.32 | 26.52 |
| silesia/sao | 7251944 | stdx | 3.61 | 12.58 | 3.49 | 6.26 |
| silesia/webster | 41458703 | libzstd | 3.32 | 11.24 | 3.38 | 16.15 |
| silesia/webster | 41458703 | stdx | 3.52 | 10.05 | 2.85 | 17.20 |
| silesia/x-ray | 8474240 | libzstd | 3.94 | 14.94 | 3.80 | 18.90 |
| silesia/x-ray | 8474240 | stdx | 3.71 | 13.23 | 3.57 | 8.44 |
| silesia/xml | 5345280 | libzstd | 1.59 | 5.57 | 3.51 | 23.27 |
| silesia/xml | 5345280 | stdx | 1.56 | 5.16 | 3.31 | 17.02 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.89 | 4.09 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.35 | 0.42 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.95 | 14.26 | 4.83 | 3.22 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.29 | 0.20 |
| canterbury/cp.html | 24603 | libzstd | 2.63 | 10.74 | 4.08 | 7.69 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.12 | 0.25 |
| canterbury/fields.c | 11150 | libzstd | 3.12 | 13.62 | 4.37 | 9.12 |
| canterbury/fields.c | 11150 | stdx | 3.00 | 12.72 | 4.24 | 0.19 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.18 | 16.94 | 4.05 | 4.44 |
| canterbury/grammar.lsp | 3721 | stdx | 4.13 | 16.54 | 4.01 | 0.22 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.53 | 11.40 | 4.52 | 7.82 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.24 | 0.88 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.70 | 12.89 | 4.78 | 5.14 |
| canterbury/lcet10.txt | 426754 | stdx | 2.74 | 11.52 | 4.21 | 4.18 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.11 | 15.16 | 4.88 | 1.51 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.18 | 13.51 | 4.25 | 0.88 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.52 | 3.11 | 25.43 |
| canterbury/ptt5 | 513216 | stdx | 1.33 | 4.46 | 3.36 | 13.11 |
| canterbury/sum | 38240 | libzstd | 2.62 | 10.58 | 4.05 | 10.07 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.46 |
| canterbury/xargs.1 | 4227 | libzstd | 4.26 | 17.41 | 4.09 | 9.47 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.17 | 4.05 | 0.21 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.04 | 13.64 | 4.49 | 2.10 |
| canterbury-large/E.coli | 4638690 | stdx | 3.14 | 12.04 | 3.84 | 2.81 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.99 | 12.00 | 4.01 | 8.34 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.11 | 10.64 | 3.42 | 9.22 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.53 | 9.60 | 3.79 | 19.73 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.60 | 8.64 | 3.32 | 20.96 |
| http/html-1kx1024 | 1048576 | libzstd | 7.25 | 21.63 | 2.98 | 63.07 |
| http/html-1kx1024 | 1048576 | stdx | 7.48 | 22.46 | 3.00 | 76.65 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.51 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 9.61 | 3.61 | 30.26 |
| http/html-1m | 1048576 | libzstd | 2.00 | 7.88 | 3.94 | 23.90 |
| http/html-1m | 1048576 | stdx | 1.99 | 7.12 | 3.57 | 24.09 |
| http/json-1kx1024 | 1048576 | libzstd | 6.27 | 17.39 | 2.77 | 49.80 |
| http/json-1kx1024 | 1048576 | stdx | 6.23 | 17.86 | 2.87 | 53.49 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.26 | 3.53 | 28.54 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 19.65 |
| http/json-1m | 1048576 | libzstd | 1.72 | 6.08 | 3.53 | 28.07 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.62 | 14.38 |
| http/js-1kx1024 | 1048576 | libzstd | 8.33 | 26.35 | 3.16 | 73.86 |
| http/js-1kx1024 | 1048576 | stdx | 9.06 | 27.60 | 3.05 | 113.68 |
| http/js-16kx64 | 1048576 | libzstd | 2.92 | 11.72 | 4.01 | 24.18 |
| http/js-16kx64 | 1048576 | stdx | 2.95 | 11.06 | 3.75 | 25.23 |
| http/js-1m | 1048576 | libzstd | 2.02 | 8.19 | 4.05 | 20.15 |
| http/js-1m | 1048576 | stdx | 2.05 | 7.48 | 3.65 | 20.52 |
| http/css-1kx1024 | 1048576 | libzstd | 6.88 | 19.69 | 2.86 | 53.57 |
| http/css-1kx1024 | 1048576 | stdx | 6.85 | 19.96 | 2.91 | 63.42 |
| http/css-16kx64 | 1048576 | libzstd | 2.25 | 8.70 | 3.87 | 23.39 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.15 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.58 | 3.85 | 5.47 |
| http/css-1m | 1048576 | stdx | 0.72 | 2.49 | 3.47 | 4.60 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.77 | 9.40 | 3.40 | 28.36 |
| shuffled/dickens-1m | 1048576 | stdx | 2.74 | 9.19 | 3.35 | 12.58 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.52 | 16.93 | 2.25 | 99.96 |
| silesia/dickens | 1048576 | stdx | 5.08 | 12.38 | 2.43 | 54.62 |
| silesia/mozilla | 1048576 | Google | 13.56 | 28.31 | 2.09 | 47.91 |
| silesia/mozilla | 1048576 | stdx | 8.33 | 15.02 | 1.80 | 47.10 |
| silesia/mr | 1048576 | Google | 8.89 | 20.21 | 2.27 | 103.16 |
| silesia/mr | 1048576 | stdx | 5.78 | 13.25 | 2.29 | 88.56 |
| silesia/nci | 1048576 | Google | 2.54 | 5.70 | 2.24 | 52.24 |
| silesia/nci | 1048576 | stdx | 1.93 | 3.95 | 2.04 | 54.65 |
| silesia/ooffice | 1048576 | Google | 14.11 | 29.27 | 2.07 | 289.42 |
| silesia/ooffice | 1048576 | stdx | 10.89 | 20.33 | 1.87 | 323.43 |
| silesia/osdb | 1048576 | Google | 8.20 | 17.48 | 2.13 | 97.30 |
| silesia/osdb | 1048576 | stdx | 5.19 | 10.57 | 2.04 | 92.56 |
| silesia/reymont | 1048576 | Google | 5.39 | 12.62 | 2.34 | 82.63 |
| silesia/reymont | 1048576 | stdx | 3.74 | 9.25 | 2.47 | 47.82 |
| silesia/samba | 1048576 | Google | 7.58 | 16.30 | 2.15 | 95.47 |
| silesia/samba | 1048576 | stdx | 5.04 | 10.71 | 2.12 | 66.83 |
| silesia/sao | 1048576 | Google | 16.82 | 37.18 | 2.21 | 167.99 |
| silesia/sao | 1048576 | stdx | 10.44 | 22.65 | 2.17 | 140.89 |
| silesia/webster | 1048576 | Google | 6.49 | 14.00 | 2.16 | 113.98 |
| silesia/webster | 1048576 | stdx | 4.37 | 9.98 | 2.29 | 68.85 |
| silesia/x-ray | 1048576 | Google | 19.57 | 38.56 | 1.97 | 235.73 |
| silesia/x-ray | 1048576 | stdx | 14.75 | 30.18 | 2.05 | 234.82 |
| silesia/xml | 1048576 | Google | 3.44 | 7.61 | 2.21 | 65.28 |
| silesia/xml | 1048576 | stdx | 2.40 | 5.40 | 2.25 | 46.86 |
| canterbury/alice29.txt | 152089 | Google | 8.84 | 20.55 | 2.32 | 133.39 |
| canterbury/alice29.txt | 152089 | stdx | 6.10 | 15.33 | 2.51 | 83.85 |
| canterbury/asyoulik.txt | 125179 | Google | 10.36 | 23.71 | 2.29 | 167.05 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.06 | 17.43 | 2.47 | 105.38 |
| canterbury/cp.html | 24603 | Google | 9.01 | 22.20 | 2.46 | 115.57 |
| canterbury/cp.html | 24603 | stdx | 5.64 | 17.15 | 3.04 | 27.43 |
| canterbury/fields.c | 11150 | Google | 7.12 | 21.16 | 2.97 | 31.95 |
| canterbury/fields.c | 11150 | stdx | 4.90 | 17.08 | 3.49 | 2.89 |
| canterbury/grammar.lsp | 3721 | Google | 9.80 | 30.16 | 3.08 | 6.09 |
| canterbury/grammar.lsp | 3721 | stdx | 7.14 | 25.04 | 3.51 | 0.38 |
| canterbury/kennedy.xls | 1029744 | Google | 5.41 | 17.05 | 3.15 | 37.37 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.81 | 12.94 | 3.40 | 34.08 |
| canterbury/lcet10.txt | 426754 | Google | 7.69 | 17.36 | 2.26 | 124.95 |
| canterbury/lcet10.txt | 426754 | stdx | 5.19 | 12.96 | 2.50 | 66.56 |
| canterbury/plrabn12.txt | 481861 | Google | 9.07 | 20.82 | 2.30 | 132.48 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.16 | 15.04 | 2.44 | 86.94 |
| canterbury/ptt5 | 513216 | Google | 4.28 | 10.41 | 2.43 | 62.57 |
| canterbury/ptt5 | 513216 | stdx | 2.36 | 4.89 | 2.07 | 64.90 |
| canterbury/sum | 38240 | Google | 10.85 | 26.44 | 2.44 | 160.29 |
| canterbury/sum | 38240 | stdx | 8.28 | 21.11 | 2.55 | 151.77 |
| canterbury/xargs.1 | 4227 | Google | 10.93 | 34.81 | 3.18 | 10.24 |
| canterbury/xargs.1 | 4227 | stdx | 8.47 | 30.44 | 3.59 | 6.31 |
| canterbury-large/E.coli | 1048576 | Google | 8.16 | 19.55 | 2.40 | 1.44 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.11 |
| canterbury-large/bible.txt | 1048576 | Google | 5.31 | 12.28 | 2.31 | 80.84 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.55 | 8.93 | 2.52 | 39.90 |
| canterbury-large/world192.txt | 1048576 | Google | 6.18 | 12.84 | 2.08 | 114.81 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.43 | 9.38 | 2.12 | 77.14 |
| http/html-1kx1024 | 1048576 | Google | 18.03 | 41.93 | 2.33 | 386.04 |
| http/html-1kx1024 | 1048576 | stdx | 15.28 | 37.56 | 2.46 | 359.27 |
| http/html-16kx64 | 1048576 | Google | 6.74 | 14.85 | 2.20 | 149.44 |
| http/html-16kx64 | 1048576 | stdx | 5.14 | 12.15 | 2.37 | 114.32 |
| http/html-1m | 1048576 | Google | 4.05 | 8.94 | 2.21 | 82.84 |
| http/html-1m | 1048576 | stdx | 2.86 | 6.52 | 2.28 | 54.50 |
| http/json-1kx1024 | 1048576 | Google | 14.49 | 36.64 | 2.53 | 241.13 |
| http/json-1kx1024 | 1048576 | stdx | 12.97 | 33.63 | 2.59 | 276.63 |
| http/json-16kx64 | 1048576 | Google | 4.43 | 11.43 | 2.58 | 83.04 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.50 |
| http/json-1m | 1048576 | Google | 3.41 | 8.65 | 2.54 | 60.05 |
| http/json-1m | 1048576 | stdx | 2.45 | 5.99 | 2.45 | 57.32 |
| http/js-1kx1024 | 1048576 | Google | 19.93 | 46.20 | 2.32 | 425.55 |
| http/js-1kx1024 | 1048576 | stdx | 16.38 | 39.90 | 2.44 | 379.43 |
| http/js-16kx64 | 1048576 | Google | 8.03 | 17.73 | 2.21 | 166.34 |
| http/js-16kx64 | 1048576 | stdx | 6.02 | 14.36 | 2.39 | 125.41 |
| http/js-1m | 1048576 | Google | 4.38 | 9.54 | 2.18 | 82.98 |
| http/js-1m | 1048576 | stdx | 3.16 | 7.25 | 2.29 | 55.27 |
| http/css-1kx1024 | 1048576 | Google | 15.53 | 37.36 | 2.41 | 294.97 |
| http/css-1kx1024 | 1048576 | stdx | 13.79 | 34.70 | 2.52 | 301.80 |
| http/css-16kx64 | 1048576 | Google | 4.97 | 11.76 | 2.37 | 102.76 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.53 |
| http/css-1m | 1048576 | Google | 2.44 | 9.42 | 3.87 | 17.01 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.49 | 12.14 |
| shuffled/dickens-1m | 1048576 | Google | 10.12 | 20.65 | 2.04 | 105.19 |
| shuffled/dickens-1m | 1048576 | stdx | 8.81 | 14.53 | 1.65 | 121.89 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.33 | 36.91 | 2.41 | 412.00 |
| silesia/dickens | 10192446 | 1 | stdx | 16.53 | 38.17 | 2.31 | 359.76 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.14 | 87.63 | 1.68 | 692.66 |
| silesia/dickens | 10192446 | 6 | stdx | 49.72 | 84.26 | 1.69 | 1444.60 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.95 | 160.47 | 1.43 | 928.02 |
| silesia/dickens | 10192446 | 9 | stdx | 85.11 | 191.81 | 2.25 | 1719.45 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.13 | 32.62 | 2.31 | 438.48 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.41 | 30.24 | 2.25 | 295.80 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.93 | 70.83 | 2.15 | 580.75 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.60 | 69.96 | 2.21 | 733.45 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.71 | 221.49 | 1.73 | 767.42 |
| silesia/mozilla | 51220480 | 9 | stdx | 49.04 | 126.12 | 2.57 | 791.26 |
| silesia/mr | 9970564 | 1 | libdeflate | 12.00 | 35.02 | 2.92 | 229.52 |
| silesia/mr | 9970564 | 1 | stdx | 12.74 | 34.08 | 2.67 | 188.08 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.31 | 80.54 | 2.10 | 437.99 |
| silesia/mr | 9970564 | 6 | stdx | 39.73 | 83.19 | 2.09 | 978.71 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.93 | 165.48 | 1.69 | 749.63 |
| silesia/mr | 9970564 | 9 | stdx | 87.27 | 206.31 | 2.36 | 1330.72 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.23 | 18.42 | 2.95 | 115.67 |
| silesia/nci | 33553445 | 1 | stdx | 5.01 | 10.88 | 2.17 | 98.73 |
| silesia/nci | 33553445 | 6 | libdeflate | 17.00 | 34.84 | 2.05 | 225.56 |
| silesia/nci | 33553445 | 6 | stdx | 14.42 | 29.54 | 2.05 | 395.04 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.46 | 105.28 | 1.69 | 499.14 |
| silesia/nci | 33553445 | 9 | stdx | 33.22 | 80.64 | 2.43 | 647.91 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.98 | 39.15 | 1.96 | 753.17 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.91 | 39.08 | 2.18 | 429.33 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 41.10 | 79.10 | 1.92 | 955.98 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.71 | 87.83 | 2.11 | 1008.46 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.63 | 127.63 | 1.71 | 1129.93 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.31 | 129.17 | 2.47 | 936.04 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.89 | 30.15 | 2.34 | 353.20 |
| silesia/osdb | 10085684 | 1 | stdx | 12.98 | 27.87 | 2.15 | 294.07 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.40 | 55.67 | 1.96 | 491.97 |
| silesia/osdb | 10085684 | 6 | stdx | 27.13 | 57.40 | 2.12 | 563.60 |
| silesia/osdb | 10085684 | 9 | libdeflate | 34.03 | 64.15 | 1.88 | 551.42 |
| silesia/osdb | 10085684 | 9 | stdx | 35.84 | 87.23 | 2.43 | 686.39 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.66 | 32.88 | 2.60 | 311.66 |
| silesia/reymont | 6627202 | 1 | stdx | 13.65 | 33.24 | 2.44 | 272.41 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.24 | 86.58 | 1.79 | 520.33 |
| silesia/reymont | 6627202 | 6 | stdx | 45.24 | 76.82 | 1.70 | 1438.85 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.36 | 276.14 | 1.39 | 837.09 |
| silesia/reymont | 6627202 | 9 | stdx | 87.26 | 189.98 | 2.18 | 1608.92 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.45 | 26.53 | 2.54 | 272.67 |
| silesia/samba | 21606400 | 1 | stdx | 9.97 | 22.23 | 2.23 | 221.15 |
| silesia/samba | 21606400 | 6 | libdeflate | 29.01 | 58.79 | 2.03 | 385.47 |
| silesia/samba | 21606400 | 6 | stdx | 24.13 | 49.84 | 2.07 | 624.50 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.29 | 141.44 | 1.68 | 505.08 |
| silesia/samba | 21606400 | 9 | stdx | 41.70 | 102.63 | 2.46 | 731.82 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.77 | 47.87 | 2.20 | 689.28 |
| silesia/sao | 7251944 | 1 | stdx | 19.20 | 49.92 | 2.60 | 346.72 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.22 | 96.89 | 1.89 | 963.64 |
| silesia/sao | 7251944 | 6 | stdx | 47.16 | 105.66 | 2.24 | 854.83 |
| silesia/sao | 7251944 | 9 | libdeflate | 71.10 | 120.26 | 1.69 | 1110.09 |
| silesia/sao | 7251944 | 9 | stdx | 55.53 | 138.16 | 2.49 | 852.05 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.14 | 30.45 | 2.32 | 388.75 |
| silesia/webster | 41458703 | 1 | stdx | 13.91 | 29.09 | 2.09 | 340.02 |
| silesia/webster | 41458703 | 6 | libdeflate | 37.08 | 66.02 | 1.78 | 569.79 |
| silesia/webster | 41458703 | 6 | stdx | 35.24 | 60.88 | 1.73 | 1107.60 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.70 | 138.85 | 1.47 | 752.34 |
| silesia/webster | 41458703 | 9 | stdx | 60.87 | 135.96 | 2.23 | 1291.36 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.82 | 49.67 | 2.08 | 791.95 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.67 | 50.82 | 2.88 | 261.44 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.88 | 82.77 | 2.52 | 852.94 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.83 | 98.12 | 2.90 | 540.12 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.54 | 91.03 | 2.42 | 1030.00 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.81 | 122.06 | 2.99 | 467.05 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.86 | 21.59 | 2.75 | 176.24 |
| silesia/xml | 5345280 | 1 | stdx | 7.16 | 15.66 | 2.19 | 155.70 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.27 | 40.51 | 1.90 | 264.25 |
| silesia/xml | 5345280 | 6 | stdx | 17.75 | 34.32 | 1.93 | 498.12 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.79 | 89.17 | 1.52 | 370.93 |
| silesia/xml | 5345280 | 9 | stdx | 31.26 | 72.83 | 2.33 | 598.31 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.30 | 35.61 | 2.49 | 380.99 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.02 | 36.13 | 2.40 | 335.04 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.88 | 82.29 | 1.76 | 642.51 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.53 | 77.43 | 1.78 | 1298.46 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.69 | 159.21 | 1.48 | 851.14 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 72.88 | 167.73 | 2.30 | 1506.39 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.18 | 37.20 | 2.45 | 417.66 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.73 | 37.43 | 2.38 | 357.31 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.32 | 85.43 | 1.77 | 715.65 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.18 | 81.93 | 1.77 | 1396.42 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.94 | 136.15 | 1.53 | 944.11 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 75.79 | 175.98 | 2.32 | 1607.64 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.75 | 32.02 | 2.73 | 286.27 |
| canterbury/cp.html | 24603 | 1 | stdx | 10.99 | 27.13 | 2.47 | 246.29 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 27.04 | 62.33 | 2.31 | 490.62 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.73 | 57.06 | 2.40 | 618.81 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.97 | 91.97 | 1.96 | 603.63 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.32 | 88.89 | 2.84 | 638.61 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.46 | 35.92 | 3.80 | 58.14 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.11 | 30.06 | 3.71 | 23.91 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.42 | 69.37 | 2.84 | 244.52 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.81 | 57.62 | 2.77 | 424.01 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.62 | 100.81 | 2.26 | 425.86 |
| canterbury/fields.c | 11150 | 9 | stdx | 29.23 | 92.66 | 3.17 | 477.61 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.01 | 51.51 | 3.96 | 12.40 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.91 | 39.03 | 3.94 | 1.70 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.82 | 87.06 | 3.65 | 31.66 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.24 | 70.82 | 4.11 | 16.62 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 31.32 | 102.89 | 3.29 | 66.19 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.84 | 99.32 | 4.17 | 61.89 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.36 | 27.18 | 3.69 | 65.28 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.05 | 22.58 | 3.20 | 62.90 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 28.01 | 73.85 | 2.64 | 96.24 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.40 | 62.00 | 3.20 | 137.87 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.39 | 664.23 | 1.83 | 163.84 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.81 | 130.89 | 3.46 | 218.97 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.79 | 33.99 | 2.46 | 370.87 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.46 | 33.93 | 2.35 | 329.54 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.09 | 78.22 | 1.73 | 608.90 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.75 | 73.43 | 1.76 | 1234.00 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.85 | 136.94 | 1.49 | 805.06 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 70.96 | 162.25 | 2.29 | 1449.42 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.80 | 38.62 | 2.44 | 425.31 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.77 | 40.25 | 2.40 | 371.70 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.22 | 91.90 | 1.70 | 753.89 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.55 | 88.90 | 1.72 | 1501.35 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 117.09 | 166.26 | 1.42 | 1002.13 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 88.99 | 201.33 | 2.26 | 1813.78 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.43 | 18.61 | 2.89 | 141.60 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.98 | 11.03 | 2.21 | 123.72 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.26 | 36.17 | 2.54 | 219.88 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.34 | 29.58 | 2.40 | 310.47 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.45 | 120.86 | 2.00 | 372.99 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.22 | 130.09 | 3.01 | 640.63 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.81 | 33.49 | 2.61 | 337.58 |
| canterbury/sum | 38240 | 1 | stdx | 12.62 | 29.36 | 2.33 | 302.61 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.69 | 69.87 | 2.44 | 503.92 |
| canterbury/sum | 38240 | 6 | stdx | 26.70 | 65.74 | 2.46 | 662.86 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.28 | 181.91 | 1.93 | 610.80 |
| canterbury/sum | 38240 | 9 | stdx | 39.44 | 112.34 | 2.85 | 659.99 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.26 | 53.06 | 4.00 | 20.10 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.68 | 43.11 | 4.04 | 1.75 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.95 | 87.70 | 3.82 | 69.54 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 17.96 | 74.37 | 4.14 | 41.54 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 25.62 | 94.34 | 3.68 | 128.57 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.41 | 106.97 | 4.05 | 116.80 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.13 | 40.47 | 3.34 | 164.56 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.89 | 42.29 | 3.28 | 100.83 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.39 | 395.99 | 2.16 | 260.71 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.84 | 374.13 | 3.05 | 1897.78 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 818.35 | 1063.49 | 1.30 | 1318.95 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 229.39 | 755.68 | 3.29 | 2432.50 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.63 | 32.38 | 2.56 | 312.40 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.56 | 32.23 | 2.38 | 280.79 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.22 | 80.12 | 1.73 | 524.64 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.36 | 72.39 | 1.71 | 1273.17 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.86 | 200.28 | 1.41 | 741.94 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.28 | 170.21 | 2.23 | 1438.23 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.35 | 29.72 | 2.23 | 413.34 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.37 | 28.55 | 1.99 | 378.72 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.26 | 60.25 | 1.81 | 557.98 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.17 | 56.81 | 1.77 | 985.96 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.80 | 119.11 | 1.47 | 687.16 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 52.19 | 117.95 | 2.26 | 1149.17 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.49 | 103.92 | 2.93 | 454.70 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.59 | 58.69 | 2.72 | 365.24 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.29 | 138.34 | 2.99 | 563.18 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 32.22 | 94.36 | 2.93 | 529.04 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.86 | 142.44 | 2.98 | 589.65 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 36.42 | 112.18 | 3.08 | 536.70 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.46 | 27.96 | 2.67 | 266.95 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.06 | 20.25 | 2.24 | 234.39 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.55 | 52.09 | 2.31 | 402.97 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.94 | 42.87 | 2.26 | 536.58 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 35.22 | 72.54 | 2.06 | 470.14 |
| http/html-16kx64 | 1048576 | 9 | stdx | 25.17 | 69.06 | 2.74 | 550.94 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.77 | 23.03 | 2.63 | 224.39 |
| http/html-1m | 1048576 | 1 | stdx | 8.17 | 17.80 | 2.18 | 205.86 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.38 | 49.53 | 1.95 | 327.69 |
| http/html-1m | 1048576 | 6 | stdx | 21.30 | 40.71 | 1.91 | 626.26 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.34 | 109.24 | 1.53 | 432.17 |
| http/html-1m | 1048576 | 9 | stdx | 36.10 | 85.76 | 2.38 | 704.24 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.82 | 94.80 | 2.98 | 301.88 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.75 | 45.22 | 2.70 | 242.00 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.11 | 126.60 | 2.94 | 372.02 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.50 | 78.43 | 2.85 | 375.79 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.20 | 142.45 | 2.73 | 430.96 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 31.08 | 95.61 | 3.08 | 383.75 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.85 | 23.85 | 3.04 | 134.55 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.45 | 13.94 | 2.56 | 110.36 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.21 | 46.61 | 2.56 | 205.83 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.47 | 35.02 | 2.60 | 278.09 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.21 | 151.99 | 1.89 | 296.74 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.43 | 58.45 | 3.01 | 301.83 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.73 | 19.85 | 2.95 | 124.48 |
| http/json-1m | 1048576 | 1 | stdx | 5.07 | 12.51 | 2.47 | 102.78 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.39 | 45.30 | 2.22 | 175.69 |
| http/json-1m | 1048576 | 6 | stdx | 14.75 | 35.09 | 2.38 | 296.96 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.64 | 205.21 | 1.69 | 275.61 |
| http/json-1m | 1048576 | 9 | stdx | 29.41 | 72.87 | 2.48 | 369.09 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.14 | 107.80 | 2.90 | 518.21 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 24.01 | 65.45 | 2.73 | 411.40 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.48 | 144.85 | 2.93 | 678.43 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 35.99 | 104.17 | 2.89 | 618.05 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.85 | 150.13 | 2.90 | 719.73 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 40.71 | 125.18 | 3.07 | 627.67 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.74 | 30.90 | 2.63 | 309.53 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.96 | 24.80 | 2.26 | 273.77 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 26.19 | 59.43 | 2.27 | 486.54 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.84 | 50.05 | 2.19 | 672.21 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 41.13 | 83.31 | 2.03 | 571.89 |
| http/js-16kx64 | 1048576 | 9 | stdx | 30.02 | 81.31 | 2.71 | 663.16 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.64 | 25.19 | 2.61 | 246.98 |
| http/js-1m | 1048576 | 1 | stdx | 9.61 | 21.31 | 2.22 | 233.16 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.99 | 56.12 | 1.94 | 370.42 |
| http/js-1m | 1048576 | 6 | stdx | 25.14 | 46.64 | 1.86 | 746.00 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.65 | 120.65 | 1.57 | 499.90 |
| http/js-1m | 1048576 | 9 | stdx | 42.41 | 100.01 | 2.36 | 813.44 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.25 | 97.74 | 2.94 | 375.65 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.64 | 49.57 | 2.66 | 300.95 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.90 | 129.23 | 2.94 | 474.12 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.51 | 82.37 | 2.79 | 503.15 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.91 | 133.80 | 2.91 | 507.58 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.50 | 99.53 | 2.97 | 521.30 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.65 | 25.60 | 2.96 | 174.01 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.69 | 16.96 | 2.54 | 135.68 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.31 | 48.80 | 2.40 | 293.74 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.49 | 38.01 | 2.31 | 462.29 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 41.02 | 82.40 | 2.01 | 374.69 |
| http/css-16kx64 | 1048576 | 9 | stdx | 23.25 | 65.14 | 2.80 | 479.47 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.96 | 21.15 | 3.04 | 133.52 |
| http/css-1m | 1048576 | 1 | stdx | 5.81 | 14.91 | 2.56 | 109.18 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.87 | 44.50 | 2.13 | 226.96 |
| http/css-1m | 1048576 | 6 | stdx | 16.71 | 35.61 | 2.13 | 445.34 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.98 | 111.58 | 1.59 | 310.06 |
| http/css-1m | 1048576 | 9 | stdx | 32.29 | 83.00 | 2.57 | 511.97 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.35 | 48.89 | 1.93 | 935.36 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.28 | 49.19 | 2.69 | 323.09 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.69 | 86.45 | 2.07 | 1181.72 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.94 | 88.80 | 2.22 | 853.52 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.16 | 94.50 | 2.00 | 1345.15 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.66 | 134.38 | 2.46 | 1135.87 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.12 | 31.22 | 3.09 | 120.43 |
| silesia/dickens | 10192446 | 1 | stdx | 24.33 | 82.03 | 3.37 | 126.52 |
| silesia/dickens | 10192446 | 3 | libzstd | 23.07 | 34.39 | 1.49 | 171.00 |
| silesia/dickens | 10192446 | 3 | stdx | 35.76 | 78.22 | 2.19 | 183.56 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.02 | 22.69 | 3.23 | 71.11 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.67 | 54.73 | 3.10 | 175.76 |
| silesia/mozilla | 51220480 | 3 | libzstd | 16.81 | 27.89 | 1.66 | 102.48 |
| silesia/mozilla | 51220480 | 3 | stdx | 30.13 | 62.01 | 2.06 | 145.76 |
| silesia/mr | 9970564 | 1 | libzstd | 7.72 | 24.81 | 3.21 | 57.96 |
| silesia/mr | 9970564 | 1 | stdx | 19.90 | 66.82 | 3.36 | 116.78 |
| silesia/mr | 9970564 | 3 | libzstd | 19.84 | 32.19 | 1.62 | 86.88 |
| silesia/mr | 9970564 | 3 | stdx | 33.84 | 72.46 | 2.14 | 115.73 |
| silesia/nci | 33553445 | 1 | libzstd | 3.58 | 9.55 | 2.67 | 57.21 |
| silesia/nci | 33553445 | 1 | stdx | 7.74 | 25.69 | 3.32 | 60.35 |
| silesia/nci | 33553445 | 3 | libzstd | 5.43 | 9.95 | 1.83 | 56.38 |
| silesia/nci | 33553445 | 3 | stdx | 11.34 | 29.15 | 2.57 | 67.00 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.61 | 29.26 | 3.40 | 72.45 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.11 | 72.51 | 3.14 | 181.08 |
| silesia/ooffice | 6152192 | 3 | libzstd | 23.33 | 39.44 | 1.69 | 120.29 |
| silesia/ooffice | 6152192 | 3 | stdx | 42.18 | 82.20 | 1.95 | 186.45 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.09 | 22.29 | 3.15 | 66.53 |
| silesia/osdb | 10085684 | 1 | stdx | 16.45 | 50.52 | 3.07 | 122.59 |
| silesia/osdb | 10085684 | 3 | libzstd | 17.86 | 26.23 | 1.47 | 68.23 |
| silesia/osdb | 10085684 | 3 | stdx | 31.73 | 57.87 | 1.82 | 111.81 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.73 | 27.13 | 2.79 | 150.49 |
| silesia/reymont | 6627202 | 1 | stdx | 20.20 | 72.05 | 3.57 | 97.59 |
| silesia/reymont | 6627202 | 3 | libzstd | 18.41 | 27.10 | 1.47 | 125.86 |
| silesia/reymont | 6627202 | 3 | stdx | 28.28 | 62.18 | 2.20 | 147.64 |
| silesia/samba | 21606400 | 1 | libzstd | 5.96 | 16.88 | 2.83 | 85.45 |
| silesia/samba | 21606400 | 1 | stdx | 13.50 | 42.89 | 3.18 | 126.36 |
| silesia/samba | 21606400 | 3 | libzstd | 11.86 | 18.81 | 1.59 | 98.93 |
| silesia/samba | 21606400 | 3 | stdx | 20.05 | 44.75 | 2.23 | 134.09 |
| silesia/sao | 7251944 | 1 | libzstd | 9.06 | 33.69 | 3.72 | 45.26 |
| silesia/sao | 7251944 | 1 | stdx | 25.83 | 82.03 | 3.18 | 104.91 |
| silesia/sao | 7251944 | 3 | libzstd | 30.33 | 50.03 | 1.65 | 95.62 |
| silesia/sao | 7251944 | 3 | stdx | 50.62 | 95.22 | 1.88 | 143.47 |
| silesia/webster | 41458703 | 1 | libzstd | 8.65 | 24.94 | 2.89 | 131.12 |
| silesia/webster | 41458703 | 1 | stdx | 20.26 | 64.04 | 3.16 | 167.35 |
| silesia/webster | 41458703 | 3 | libzstd | 19.17 | 27.33 | 1.43 | 176.89 |
| silesia/webster | 41458703 | 3 | stdx | 30.82 | 64.55 | 2.09 | 195.32 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.80 | 14.92 | 3.11 | 17.20 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.88 | 76.64 | 3.21 | 93.75 |
| silesia/x-ray | 8474240 | 3 | libzstd | 31.03 | 52.73 | 1.70 | 88.02 |
| silesia/x-ray | 8474240 | 3 | stdx | 47.86 | 92.40 | 1.93 | 106.17 |
| silesia/xml | 5345280 | 1 | libzstd | 4.29 | 11.71 | 2.73 | 71.34 |
| silesia/xml | 5345280 | 1 | stdx | 10.47 | 34.21 | 3.27 | 95.16 |
| silesia/xml | 5345280 | 3 | libzstd | 6.95 | 12.61 | 1.81 | 77.81 |
| silesia/xml | 5345280 | 3 | stdx | 12.97 | 32.28 | 2.49 | 116.38 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.79 | 32.84 | 3.04 | 139.55 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.45 | 76.49 | 3.41 | 190.11 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.70 | 39.48 | 2.51 | 205.62 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.43 | 73.76 | 2.79 | 339.19 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.72 | 33.55 | 3.45 | 102.50 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.59 | 79.00 | 3.35 | 218.94 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.16 | 39.27 | 2.59 | 209.52 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.20 | 79.30 | 2.81 | 378.85 |
| canterbury/cp.html | 24603 | 1 | libzstd | 7.03 | 26.64 | 3.79 | 42.54 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.18 | 57.76 | 3.57 | 125.39 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.53 | 31.85 | 3.34 | 49.75 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.59 | 59.76 | 3.21 | 156.28 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.74 | 31.76 | 3.63 | 44.34 |
| canterbury/fields.c | 11150 | 1 | stdx | 17.04 | 65.73 | 3.86 | 91.14 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.32 | 34.14 | 3.66 | 27.48 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.42 | 64.68 | 3.71 | 99.52 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.46 | 38.01 | 4.02 | 8.96 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.24 | 77.57 | 3.83 | 54.35 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.66 | 43.09 | 4.04 | 7.27 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.44 | 79.60 | 3.71 | 69.27 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.01 | 23.56 | 3.92 | 14.68 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.81 | 56.75 | 3.83 | 87.17 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.27 | 23.80 | 2.88 | 27.51 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 20.20 | 56.61 | 2.80 | 110.65 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.81 | 28.52 | 2.91 | 156.58 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.43 | 72.02 | 3.36 | 162.68 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 16.39 | 32.14 | 1.96 | 203.30 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.17 | 67.10 | 2.56 | 299.21 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.32 | 32.37 | 3.14 | 129.74 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.19 | 84.16 | 3.34 | 160.76 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 20.03 | 38.77 | 1.94 | 227.12 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 31.51 | 80.77 | 2.56 | 346.00 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.16 | 8.51 | 2.70 | 67.09 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.53 | 23.15 | 3.07 | 106.52 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 4.79 | 10.97 | 2.29 | 58.99 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.38 | 24.08 | 2.57 | 133.84 |
| canterbury/sum | 38240 | 1 | libzstd | 6.58 | 25.39 | 3.86 | 33.75 |
| canterbury/sum | 38240 | 1 | stdx | 16.95 | 59.13 | 3.49 | 155.08 |
| canterbury/sum | 38240 | 3 | libzstd | 9.04 | 30.67 | 3.39 | 47.78 |
| canterbury/sum | 38240 | 3 | stdx | 20.09 | 61.82 | 3.08 | 191.12 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 10.01 | 39.82 | 3.98 | 13.87 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.86 | 80.38 | 3.85 | 59.29 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.26 | 48.17 | 3.93 | 17.51 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.95 | 83.98 | 3.66 | 84.33 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.35 | 33.44 | 3.23 | 76.30 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.88 | 95.62 | 4.37 | 7.32 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 15.03 | 31.30 | 2.08 | 36.02 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.77 | 70.38 | 2.96 | 38.45 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.73 | 27.45 | 2.82 | 149.02 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.42 | 71.86 | 3.52 | 109.28 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 18.16 | 28.20 | 1.55 | 132.60 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 28.41 | 63.36 | 2.23 | 156.73 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.19 | 22.70 | 2.77 | 136.63 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.72 | 55.86 | 2.98 | 194.82 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 15.59 | 23.87 | 1.53 | 173.83 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 25.77 | 51.26 | 1.99 | 238.66 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.06 | 52.46 | 3.07 | 159.52 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 36.19 | 100.54 | 2.78 | 644.14 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.07 | 59.20 | 3.10 | 196.69 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 38.25 | 104.00 | 2.72 | 639.21 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.73 | 22.46 | 2.91 | 122.33 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.42 | 46.84 | 3.25 | 184.70 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.78 | 24.61 | 2.80 | 141.74 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.53 | 47.61 | 3.07 | 194.04 |
| http/html-1m | 1048576 | 1 | libzstd | 6.23 | 16.74 | 2.69 | 114.62 |
| http/html-1m | 1048576 | 1 | stdx | 13.05 | 42.00 | 3.22 | 135.74 |
| http/html-1m | 1048576 | 3 | libzstd | 9.26 | 18.18 | 1.96 | 126.24 |
| http/html-1m | 1048576 | 3 | stdx | 15.76 | 39.37 | 2.50 | 178.06 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.36 | 42.52 | 2.96 | 115.58 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.89 | 83.13 | 2.78 | 536.85 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.83 | 44.54 | 3.00 | 127.86 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.99 | 84.87 | 2.74 | 546.63 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.82 | 14.98 | 3.11 | 57.69 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.77 | 33.78 | 3.46 | 118.04 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.35 | 16.21 | 3.03 | 72.20 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.65 | 34.58 | 3.25 | 124.78 |
| http/json-1m | 1048576 | 1 | libzstd | 4.04 | 12.55 | 3.11 | 52.49 |
| http/json-1m | 1048576 | 1 | stdx | 9.04 | 30.70 | 3.40 | 87.30 |
| http/json-1m | 1048576 | 3 | libzstd | 6.15 | 13.78 | 2.24 | 68.97 |
| http/json-1m | 1048576 | 3 | stdx | 11.35 | 30.64 | 2.70 | 121.06 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.54 | 57.26 | 3.09 | 183.76 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 40.27 | 113.49 | 2.82 | 701.80 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.43 | 65.54 | 3.06 | 259.86 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.41 | 116.54 | 2.75 | 692.96 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.83 | 26.52 | 3.00 | 127.26 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.74 | 55.71 | 3.33 | 202.84 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.07 | 28.74 | 2.85 | 155.79 |
| http/js-16kx64 | 1048576 | 3 | stdx | 18.09 | 55.35 | 3.06 | 212.59 |
| http/js-1m | 1048576 | 1 | libzstd | 6.55 | 17.87 | 2.73 | 113.55 |
| http/js-1m | 1048576 | 1 | stdx | 14.00 | 45.88 | 3.28 | 137.77 |
| http/js-1m | 1048576 | 3 | libzstd | 9.80 | 19.14 | 1.95 | 125.03 |
| http/js-1m | 1048576 | 3 | stdx | 16.96 | 41.25 | 2.43 | 188.33 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.57 | 46.90 | 3.01 | 136.56 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.62 | 91.65 | 2.81 | 585.82 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.65 | 50.53 | 3.03 | 159.18 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 34.03 | 93.63 | 2.75 | 588.69 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.13 | 18.99 | 3.10 | 78.69 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.54 | 43.79 | 3.49 | 139.27 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.57 | 19.41 | 2.96 | 95.90 |
| http/css-16kx64 | 1048576 | 3 | stdx | 13.04 | 42.34 | 3.25 | 154.49 |
| http/css-1m | 1048576 | 1 | libzstd | 1.49 | 4.59 | 3.07 | 21.70 |
| http/css-1m | 1048576 | 1 | stdx | 3.99 | 14.85 | 3.72 | 30.64 |
| http/css-1m | 1048576 | 3 | libzstd | 1.97 | 5.25 | 2.67 | 19.78 |
| http/css-1m | 1048576 | 3 | stdx | 3.95 | 13.33 | 3.37 | 32.18 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.52 | 12.79 | 3.64 | 6.23 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.20 | 30.66 | 3.33 | 62.92 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 27.76 | 50.53 | 1.82 | 49.28 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 20.93 | 47.43 | 2.27 | 214.01 |

## Hardware counters per input octet, brotli encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | Google q1 | 18.35 | 30.24 | 1.65 | 232.10 |
| silesia/dickens | 10192446 | stdx 1 | 19.57 | 43.43 | 2.22 | 413.54 |
| silesia/dickens | 10192446 | Google q5 | 119.01 | 194.36 | 1.63 | 821.52 |
| silesia/dickens | 10192446 | stdx 5 | 74.28 | 155.43 | 2.09 | 987.30 |
| silesia/mozilla | 51220480 | Google q1 | 13.29 | 25.26 | 1.90 | 144.92 |
| silesia/mozilla | 51220480 | stdx 1 | 12.43 | 32.95 | 2.65 | 213.42 |
| silesia/mozilla | 51220480 | Google q5 | 67.23 | 149.30 | 2.22 | 800.05 |
| silesia/mozilla | 51220480 | stdx 5 | 60.62 | 148.04 | 2.44 | 814.39 |
| silesia/mr | 9970564 | Google q1 | 13.32 | 26.14 | 1.96 | 97.91 |
| silesia/mr | 9970564 | stdx 1 | 13.81 | 37.80 | 2.74 | 165.54 |
| silesia/mr | 9970564 | Google q5 | 95.49 | 177.41 | 1.86 | 607.18 |
| silesia/mr | 9970564 | stdx 5 | 69.18 | 149.01 | 2.15 | 702.80 |
| silesia/nci | 33553445 | Google q1 | 5.32 | 9.71 | 1.83 | 89.27 |
| silesia/nci | 33553445 | stdx 1 | 6.15 | 14.48 | 2.35 | 128.17 |
| silesia/nci | 33553445 | Google q5 | 34.96 | 59.01 | 1.69 | 413.39 |
| silesia/nci | 33553445 | stdx 5 | 31.69 | 58.51 | 1.85 | 488.94 |
| silesia/ooffice | 6152192 | Google q1 | 17.84 | 33.43 | 1.87 | 154.21 |
| silesia/ooffice | 6152192 | stdx 1 | 17.03 | 45.85 | 2.69 | 266.64 |
| silesia/ooffice | 6152192 | Google q5 | 95.88 | 198.80 | 2.07 | 1069.43 |
| silesia/ooffice | 6152192 | stdx 5 | 74.96 | 178.18 | 2.38 | 1076.11 |
| silesia/osdb | 10085684 | Google q1 | 12.68 | 23.47 | 1.85 | 84.76 |
| silesia/osdb | 10085684 | stdx 1 | 11.81 | 32.00 | 2.71 | 141.73 |
| silesia/osdb | 10085684 | Google q5 | 74.24 | 146.01 | 1.97 | 546.08 |
| silesia/osdb | 10085684 | stdx 5 | 54.14 | 123.53 | 2.28 | 520.68 |
| silesia/reymont | 6627202 | Google q1 | 15.49 | 25.54 | 1.65 | 208.20 |
| silesia/reymont | 6627202 | stdx 1 | 14.55 | 33.36 | 2.29 | 283.29 |
| silesia/reymont | 6627202 | Google q5 | 88.44 | 169.16 | 1.91 | 799.57 |
| silesia/reymont | 6627202 | stdx 5 | 64.60 | 139.71 | 2.16 | 907.57 |
| silesia/samba | 21606400 | Google q1 | 9.93 | 17.38 | 1.75 | 128.04 |
| silesia/samba | 21606400 | stdx 1 | 9.95 | 23.94 | 2.41 | 196.81 |
| silesia/samba | 21606400 | Google q5 | 49.48 | 105.54 | 2.13 | 480.43 |
| silesia/samba | 21606400 | stdx 5 | 47.12 | 102.32 | 2.17 | 531.65 |
| silesia/sao | 7251944 | Google q1 | 21.24 | 39.96 | 1.88 | 100.87 |
| silesia/sao | 7251944 | stdx 1 | 18.94 | 55.66 | 2.94 | 190.05 |
| silesia/sao | 7251944 | Google q5 | 122.32 | 259.63 | 2.12 | 931.43 |
| silesia/sao | 7251944 | stdx 5 | 88.60 | 229.67 | 2.59 | 754.71 |
| silesia/webster | 41458703 | Google q1 | 14.73 | 24.40 | 1.66 | 209.25 |
| silesia/webster | 41458703 | stdx 1 | 15.39 | 34.12 | 2.22 | 338.92 |
| silesia/webster | 41458703 | Google q5 | 80.42 | 141.82 | 1.76 | 757.02 |
| silesia/webster | 41458703 | stdx 5 | 61.96 | 121.03 | 1.95 | 851.24 |
| silesia/x-ray | 8474240 | Google q1 | 13.95 | 22.03 | 1.58 | 12.41 |
| silesia/x-ray | 8474240 | stdx 1 | 13.16 | 38.68 | 2.94 | 94.49 |
| silesia/x-ray | 8474240 | Google q5 | 105.15 | 236.76 | 2.25 | 725.76 |
| silesia/x-ray | 8474240 | stdx 5 | 84.26 | 226.78 | 2.69 | 644.84 |
| silesia/xml | 5345280 | Google q1 | 7.09 | 12.28 | 1.73 | 113.83 |
| silesia/xml | 5345280 | stdx 1 | 7.43 | 17.44 | 2.35 | 153.53 |
| silesia/xml | 5345280 | Google q5 | 33.03 | 72.50 | 2.19 | 359.55 |
| silesia/xml | 5345280 | stdx 5 | 30.07 | 64.66 | 2.15 | 413.03 |
| canterbury/alice29.txt | 152089 | Google q1 | 17.01 | 29.72 | 1.75 | 207.51 |
| canterbury/alice29.txt | 152089 | stdx 1 | 18.33 | 40.79 | 2.23 | 445.91 |
| canterbury/alice29.txt | 152089 | Google q5 | 79.23 | 200.77 | 2.53 | 1039.73 |
| canterbury/alice29.txt | 152089 | stdx 5 | 67.79 | 150.37 | 2.22 | 915.27 |
| canterbury/asyoulik.txt | 125179 | Google q1 | 17.91 | 32.37 | 1.81 | 222.59 |
| canterbury/asyoulik.txt | 125179 | stdx 1 | 20.05 | 44.50 | 2.22 | 499.07 |
| canterbury/asyoulik.txt | 125179 | Google q5 | 84.46 | 215.27 | 2.55 | 1075.50 |
| canterbury/asyoulik.txt | 125179 | stdx 5 | 74.58 | 162.29 | 2.18 | 1051.64 |
| canterbury/cp.html | 24603 | Google q1 | 13.11 | 27.30 | 2.08 | 105.21 |
| canterbury/cp.html | 24603 | stdx 1 | 14.67 | 36.07 | 2.46 | 355.42 |
| canterbury/cp.html | 24603 | Google q5 | 61.93 | 163.89 | 2.65 | 949.64 |
| canterbury/cp.html | 24603 | stdx 5 | 56.29 | 131.75 | 2.34 | 722.96 |
| canterbury/fields.c | 11150 | Google q1 | 12.13 | 29.04 | 2.39 | 14.02 |
| canterbury/fields.c | 11150 | stdx 1 | 10.56 | 38.87 | 3.68 | 91.57 |
| canterbury/fields.c | 11150 | Google q5 | 59.77 | 168.16 | 2.81 | 911.62 |
| canterbury/fields.c | 11150 | stdx 5 | 43.90 | 123.30 | 2.81 | 552.13 |
| canterbury/grammar.lsp | 3721 | Google q1 | 14.36 | 39.39 | 2.74 | 7.96 |
| canterbury/grammar.lsp | 3721 | stdx 1 | 13.51 | 55.22 | 4.09 | 29.79 |
| canterbury/grammar.lsp | 3721 | Google q5 | 60.62 | 203.91 | 3.36 | 447.46 |
| canterbury/grammar.lsp | 3721 | stdx 5 | 41.04 | 148.73 | 3.62 | 142.77 |
| canterbury/kennedy.xls | 1029744 | Google q1 | 9.85 | 24.83 | 2.52 | 59.69 |
| canterbury/kennedy.xls | 1029744 | stdx 1 | 7.83 | 27.03 | 3.45 | 76.43 |
| canterbury/kennedy.xls | 1029744 | Google q5 | 47.40 | 162.91 | 3.44 | 263.11 |
| canterbury/kennedy.xls | 1029744 | stdx 5 | 52.23 | 162.45 | 3.11 | 475.91 |
| canterbury/lcet10.txt | 426754 | Google q1 | 16.08 | 27.19 | 1.69 | 200.34 |
| canterbury/lcet10.txt | 426754 | stdx 1 | 16.82 | 37.84 | 2.25 | 378.09 |
| canterbury/lcet10.txt | 426754 | Google q5 | 77.23 | 187.58 | 2.43 | 957.15 |
| canterbury/lcet10.txt | 426754 | stdx 5 | 64.80 | 140.50 | 2.17 | 910.46 |
| canterbury/plrabn12.txt | 481861 | Google q1 | 18.91 | 32.57 | 1.72 | 249.23 |
| canterbury/plrabn12.txt | 481861 | stdx 1 | 20.87 | 46.66 | 2.24 | 473.39 |
| canterbury/plrabn12.txt | 481861 | Google q5 | 95.13 | 229.77 | 2.42 | 1064.27 |
| canterbury/plrabn12.txt | 481861 | stdx 5 | 81.25 | 168.65 | 2.08 | 1194.31 |
| canterbury/ptt5 | 513216 | Google q1 | 5.06 | 9.55 | 1.89 | 80.45 |
| canterbury/ptt5 | 513216 | stdx 1 | 6.66 | 15.64 | 2.35 | 161.56 |
| canterbury/ptt5 | 513216 | Google q5 | 27.36 | 68.87 | 2.52 | 466.58 |
| canterbury/ptt5 | 513216 | stdx 5 | 29.92 | 69.96 | 2.34 | 469.84 |
| canterbury/sum | 38240 | Google q1 | 12.93 | 29.25 | 2.26 | 87.49 |
| canterbury/sum | 38240 | stdx 1 | 15.45 | 36.37 | 2.35 | 399.80 |
| canterbury/sum | 38240 | Google q5 | 65.79 | 182.58 | 2.77 | 1098.23 |
| canterbury/sum | 38240 | stdx 5 | 64.37 | 159.26 | 2.47 | 842.22 |
| canterbury/xargs.1 | 4227 | Google q1 | 16.28 | 43.16 | 2.65 | 12.49 |
| canterbury/xargs.1 | 4227 | stdx 1 | 14.81 | 59.10 | 3.99 | 45.19 |
| canterbury/xargs.1 | 4227 | Google q5 | 70.21 | 219.02 | 3.12 | 726.65 |
| canterbury/xargs.1 | 4227 | stdx 5 | 46.89 | 159.53 | 3.40 | 256.26 |
| canterbury-large/E.coli | 4638690 | Google q1 | 13.63 | 27.46 | 2.01 | 53.69 |
| canterbury-large/E.coli | 4638690 | stdx 1 | 5.77 | 19.24 | 3.33 | 18.01 |
| canterbury-large/E.coli | 4638690 | Google q5 | 93.97 | 262.67 | 2.80 | 1009.95 |
| canterbury-large/E.coli | 4638690 | stdx 5 | 31.63 | 93.28 | 2.95 | 64.70 |
| canterbury-large/bible.txt | 4047392 | Google q1 | 14.89 | 24.57 | 1.65 | 175.74 |
| canterbury-large/bible.txt | 4047392 | stdx 1 | 15.38 | 34.29 | 2.23 | 316.34 |
| canterbury-large/bible.txt | 4047392 | Google q5 | 88.21 | 165.65 | 1.88 | 732.61 |
| canterbury-large/bible.txt | 4047392 | stdx 5 | 61.62 | 134.16 | 2.18 | 808.05 |
| canterbury-large/world192.txt | 2473400 | Google q1 | 13.79 | 22.62 | 1.64 | 195.81 |
| canterbury-large/world192.txt | 2473400 | stdx 1 | 13.89 | 31.07 | 2.24 | 314.96 |
| canterbury-large/world192.txt | 2473400 | Google q5 | 73.51 | 129.46 | 1.76 | 744.94 |
| canterbury-large/world192.txt | 2473400 | stdx 5 | 55.04 | 105.07 | 1.91 | 771.81 |
| http/html-1kx1024 | 1048576 | Google q1 | 32.34 | 62.53 | 1.93 | 864.11 |
| http/html-1kx1024 | 1048576 | stdx 1 | 27.64 | 80.73 | 2.92 | 473.13 |
| http/html-1kx1024 | 1048576 | Google q5 | 107.24 | 260.90 | 2.43 | 2122.54 |
| http/html-1kx1024 | 1048576 | stdx 5 | 68.72 | 169.39 | 2.46 | 1181.11 |
| http/html-16kx64 | 1048576 | Google q1 | 11.36 | 20.38 | 1.79 | 214.27 |
| http/html-16kx64 | 1048576 | stdx 1 | 11.69 | 28.46 | 2.44 | 302.18 |
| http/html-16kx64 | 1048576 | Google q5 | 47.66 | 118.53 | 2.49 | 858.27 |
| http/html-16kx64 | 1048576 | stdx 5 | 40.93 | 92.79 | 2.27 | 667.16 |
| http/html-1m | 1048576 | Google q1 | 9.06 | 15.15 | 1.67 | 138.13 |
| http/html-1m | 1048576 | stdx 1 | 9.73 | 22.18 | 2.28 | 225.61 |
| http/html-1m | 1048576 | Google q5 | 47.25 | 104.93 | 2.22 | 575.62 |
| http/html-1m | 1048576 | stdx 5 | 37.41 | 84.09 | 2.25 | 544.29 |
| http/json-1kx1024 | 1048576 | Google q1 | 24.75 | 49.87 | 2.02 | 653.72 |
| http/json-1kx1024 | 1048576 | stdx 1 | 21.26 | 61.64 | 2.90 | 364.30 |
| http/json-1kx1024 | 1048576 | Google q5 | 79.94 | 203.15 | 2.54 | 1341.04 |
| http/json-1kx1024 | 1048576 | stdx 5 | 51.06 | 132.48 | 2.59 | 737.25 |
| http/json-16kx64 | 1048576 | Google q1 | 7.71 | 14.90 | 1.93 | 142.02 |
| http/json-16kx64 | 1048576 | stdx 1 | 7.19 | 19.73 | 2.75 | 159.13 |
| http/json-16kx64 | 1048576 | Google q5 | 37.24 | 97.81 | 2.63 | 557.22 |
| http/json-16kx64 | 1048576 | stdx 5 | 36.68 | 89.00 | 2.43 | 532.94 |
| http/json-1m | 1048576 | Google q1 | 6.26 | 12.65 | 2.02 | 92.05 |
| http/json-1m | 1048576 | stdx 1 | 6.77 | 17.21 | 2.54 | 139.55 |
| http/json-1m | 1048576 | Google q5 | 38.75 | 96.08 | 2.48 | 447.32 |
| http/json-1m | 1048576 | stdx 5 | 39.93 | 92.44 | 2.31 | 573.87 |
| http/js-1kx1024 | 1048576 | Google q1 | 34.98 | 68.18 | 1.95 | 913.13 |
| http/js-1kx1024 | 1048576 | stdx 1 | 30.72 | 90.40 | 2.94 | 529.68 |
| http/js-1kx1024 | 1048576 | Google q5 | 117.67 | 288.57 | 2.45 | 2304.31 |
| http/js-1kx1024 | 1048576 | stdx 5 | 77.63 | 188.24 | 2.42 | 1326.40 |
| http/js-16kx64 | 1048576 | Google q1 | 13.21 | 24.07 | 1.82 | 230.68 |
| http/js-16kx64 | 1048576 | stdx 1 | 13.59 | 32.69 | 2.41 | 353.68 |
| http/js-16kx64 | 1048576 | Google q5 | 56.37 | 141.15 | 2.50 | 997.69 |
| http/js-16kx64 | 1048576 | stdx 5 | 48.15 | 107.16 | 2.23 | 788.62 |
| http/js-1m | 1048576 | Google q1 | 9.85 | 16.69 | 1.69 | 141.06 |
| http/js-1m | 1048576 | stdx 1 | 10.31 | 23.55 | 2.28 | 227.66 |
| http/js-1m | 1048576 | Google q5 | 54.52 | 116.02 | 2.13 | 637.00 |
| http/js-1m | 1048576 | stdx 5 | 40.46 | 90.08 | 2.23 | 591.36 |
| http/css-1kx1024 | 1048576 | Google q1 | 27.78 | 54.06 | 1.95 | 735.57 |
| http/css-1kx1024 | 1048576 | stdx 1 | 23.98 | 68.32 | 2.85 | 432.27 |
| http/css-1kx1024 | 1048576 | Google q5 | 87.55 | 213.92 | 2.44 | 1665.32 |
| http/css-1kx1024 | 1048576 | stdx 5 | 54.76 | 139.00 | 2.54 | 906.34 |
| http/css-16kx64 | 1048576 | Google q1 | 9.04 | 16.85 | 1.86 | 140.92 |
| http/css-16kx64 | 1048576 | stdx 1 | 8.63 | 23.62 | 2.74 | 192.57 |
| http/css-16kx64 | 1048576 | Google q5 | 38.13 | 100.68 | 2.64 | 647.89 |
| http/css-16kx64 | 1048576 | stdx 5 | 32.24 | 81.52 | 2.53 | 495.87 |
| http/css-1m | 1048576 | Google q1 | 6.06 | 11.27 | 1.86 | 75.59 |
| http/css-1m | 1048576 | stdx 1 | 5.53 | 14.38 | 2.60 | 110.21 |
| http/css-1m | 1048576 | Google q5 | 15.25 | 38.50 | 2.53 | 129.79 |
| http/css-1m | 1048576 | stdx 5 | 14.88 | 36.87 | 2.48 | 111.02 |
| shuffled/dickens-1m | 1048576 | Google q1 | 11.56 | 20.96 | 1.81 | 2.69 |
| shuffled/dickens-1m | 1048576 | stdx 1 | 5.47 | 19.75 | 3.61 | 16.81 |
| shuffled/dickens-1m | 1048576 | Google q5 | 104.18 | 235.57 | 2.26 | 725.40 |
| shuffled/dickens-1m | 1048576 | stdx 5 | 46.48 | 123.05 | 2.65 | 254.99 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.117 | 3.00 | 2.93 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 65.8 | 219.6 | 0.087 | 7.77 | 3.34 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 30.7 | 96.1 | 0.163 | 3.62 | 3.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextReader.next_items | 29.3 | 80.8 | 0.152 | 3.46 | 2.76 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 251.6 | 1024.0 | 0.847 | 29.72 | 4.07 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.9 | 107.7 | 0.137 | 3.65 | 3.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.4 | 106.2 | 0.293 | 3.35 | 3.74 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 93.2 | 378.2 | 0.386 | 11.01 | 4.06 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 43.0 | 161.9 | 0.477 | 5.08 | 3.77 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 91.8 | 451.7 | 0.306 | 10.84 | 4.92 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 31.2 | 89.5 | 0.004 | 4.60 | 2.87 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 72.2 | 234.7 | 0.039 | 10.62 | 3.25 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 33.0 | 99.4 | 0.012 | 4.86 | 3.01 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextReader.next_items | 31.8 | 84.2 | 0.009 | 4.69 | 2.64 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 221.7 | 819.1 | 0.978 | 32.63 | 3.69 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.3 | 107.7 | 0.040 | 4.17 | 3.80 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 41.7 | 106.0 | 0.050 | 6.14 | 2.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 92.9 | 346.2 | 0.311 | 13.68 | 3.73 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 40.5 | 144.5 | 0.052 | 5.97 | 3.56 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 102.1 | 406.5 | 0.079 | 15.02 | 3.98 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 45.3 | 96.3 | 0.204 | 4.24 | 2.13 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 89.7 | 249.4 | 0.234 | 8.40 | 2.78 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 47.9 | 113.8 | 0.288 | 4.48 | 2.38 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextReader.next_items | 45.6 | 99.4 | 0.209 | 4.27 | 2.18 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 327.5 | 1284.6 | 1.087 | 30.67 | 3.92 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 36.2 | 133.1 | 0.180 | 3.39 | 3.68 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 51.3 | 128.6 | 0.731 | 4.80 | 2.51 |
| messages: 11 string members | 96000 | 1025025 | std.json | 132.5 | 451.2 | 1.061 | 12.41 | 3.41 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 75.3 | 204.1 | 1.013 | 7.05 | 2.71 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 153.7 | 572.0 | 0.842 | 14.40 | 3.72 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 24.2 | 78.8 | 0.017 | 3.03 | 3.25 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 67.2 | 239.5 | 0.006 | 8.41 | 3.56 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 28.2 | 93.3 | 0.043 | 3.53 | 3.31 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextReader.next_items | 26.9 | 78.0 | 0.036 | 3.36 | 2.90 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 235.0 | 942.3 | 0.400 | 29.42 | 4.01 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 28.4 | 107.6 | 0.058 | 3.55 | 3.79 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 26.7 | 104.8 | 0.022 | 3.34 | 3.93 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 85.9 | 361.0 | 0.027 | 10.76 | 4.20 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 32.5 | 151.6 | 0.035 | 4.07 | 4.66 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 83.3 | 418.3 | 0.008 | 10.42 | 5.02 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114969.7 | 403846.2 | 504.897 | 0.67 | 3.51 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 594250.9 | 2503286.2 | 1386.340 | 3.44 | 4.21 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 114504.2 | 404249.2 | 487.825 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, TextReader.next_items | 114606.4 | 404282.2 | 484.093 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3558739.1 | 18223876.2 | 2978.268 | 20.63 | 5.12 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311336.3 | 621744.2 | 589.577 | 1.80 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 226606.2 | 826630.2 | 2317.845 | 1.31 | 3.65 |
| string: silesia/dickens | 1 | 172528 | std.json | 1565998.2 | 4578768.2 | 42975.660 | 9.08 | 2.92 |
| string: silesia/dickens | 1 | 172528 | serde_json | 204759.8 | 802909.2 | 992.825 | 1.19 | 3.92 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1060315.5 | 5280818.4 | 4949.144 | 6.15 | 4.98 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1564540.9 | 4799769.6 | 1216.429 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14717923.1 | 56410893.6 | 45142.429 | 12.37 | 3.83 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1560785.6 | 4799955.6 | 1104.500 | 1.31 | 3.08 |
| string: http/json-1m | 1 | 1190272 | stdx, TextReader.next_items | 1560622.6 | 4799988.6 | 1090.357 | 1.31 | 3.08 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 29055046.9 | 132108259.6 | 159236.714 | 24.41 | 4.55 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4592367.4 | 7062781.6 | 609.214 | 3.86 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1823227.2 | 7322029.6 | 14273.571 | 1.53 | 4.02 |
| string: http/json-1m | 1 | 1190272 | std.json | 10357125.1 | 47381157.6 | 31756.643 | 8.70 | 4.57 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3779236.8 | 15226584.6 | 6065.929 | 3.18 | 4.03 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9004180.6 | 47991138.4 | 27169.286 | 7.56 | 5.33 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2072130.8 | 5765419.8 | 4373.625 | 1.10 | 2.78 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6211975.1 | 22538840.8 | 6955.250 | 3.30 | 3.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2055029.0 | 5765605.8 | 3791.875 | 1.09 | 2.81 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextReader.next_items | 2055412.0 | 5765638.8 | 3683.250 | 1.09 | 2.81 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47521836.9 | 227842326.8 | 287663.500 | 25.24 | 4.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3773897.4 | 8446023.8 | 1925.375 | 2.00 | 2.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7210030.3 | 12276717.8 | 275307.375 | 3.83 | 1.70 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17449199.5 | 63617055.8 | 286800.125 | 9.27 | 3.65 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9536812.5 | 24440998.8 | 331833.750 | 5.06 | 2.56 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39766364.4 | 160435712.6 | 799498.125 | 21.12 | 4.03 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12975905.3 | 42561075.3 | 246462.333 | 2.56 | 3.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 160390138.3 | 666700955.3 | 394620.000 | 31.60 | 4.16 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12925416.0 | 42561261.3 | 244710.667 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextReader.next_items | 12910263.7 | 42561294.3 | 244633.000 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 159965446.0 | 639992668.3 | 424985.333 | 31.52 | 4.00 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17624982.0 | 49745820.3 | 254257.000 | 3.47 | 2.82 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14371300.0 | 45615166.3 | 451506.000 | 2.83 | 3.17 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79311138.3 | 314900845.3 | 471454.000 | 15.63 | 3.97 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36330371.0 | 131556418.3 | 585530.667 | 7.16 | 3.62 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66903188.0 | 273932114.3 | 832329.667 | 13.18 | 4.09 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 92949.6 | 303842.7 | 4.323 | 0.18 | 3.27 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 181197.4 | 623466.7 | 10.097 | 0.35 | 3.44 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 148658.7 | 557622.7 | 6.032 | 0.28 | 3.75 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextReader.next_items | 148102.0 | 557626.7 | 5.452 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10290985.6 | 53478208.7 | 6.935 | 19.63 | 5.20 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 488956.7 | 1376733.7 | 7.387 | 0.93 | 2.82 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 534146.1 | 2195917.7 | 9.935 | 1.02 | 4.11 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3322863.9 | 12808414.7 | 60763.710 | 6.34 | 3.85 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 285777.4 | 1179969.7 | 5.935 | 0.55 | 4.13 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2260791.2 | 12788679.6 | 254.548 | 4.31 | 5.66 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 20.3 | 81.8 | 0.109 | 2.40 | 4.03 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.3 | 153.5 | 0.137 | 4.17 | 4.35 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 21.4 | 93.4 | 0.093 | 2.53 | 4.37 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 218.6 | 981.0 | 0.928 | 25.82 | 4.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 19.8 | 79.5 | 0.105 | 2.34 | 4.01 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.3 | 94.1 | 0.135 | 2.75 | 4.05 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.5 | 105.6 | 0.247 | 3.25 | 3.83 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.2 | 310.8 | 0.361 | 8.17 | 4.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 64.1 | 255.3 | 0.524 | 7.58 | 3.98 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.6 | 315.1 | 0.233 | 8.11 | 4.59 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.6 | 82.8 | 0.024 | 2.74 | 4.45 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.2 | 153.9 | 0.026 | 5.32 | 4.26 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 22.4 | 94.2 | 0.024 | 3.30 | 4.20 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 170.2 | 718.3 | 1.272 | 25.05 | 4.22 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.6 | 81.5 | 0.024 | 2.74 | 4.38 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 22.1 | 96.8 | 0.032 | 3.25 | 4.38 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.9 | 117.9 | 0.032 | 4.40 | 3.95 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 60.2 | 271.2 | 0.249 | 8.85 | 4.51 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 48.8 | 213.2 | 0.039 | 7.18 | 4.37 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 86.5 | 331.7 | 0.086 | 12.73 | 3.83 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 34.2 | 85.9 | 0.394 | 3.21 | 2.51 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 43.6 | 151.2 | 0.425 | 4.08 | 3.47 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 29.2 | 92.6 | 0.391 | 2.73 | 3.17 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 285.1 | 1195.0 | 1.143 | 26.70 | 4.19 |
| messages: 11 string members | 96000 | 1025025 | stdx, J11's loop unchecked | 31.9 | 82.8 | 0.391 | 2.99 | 2.59 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 38.7 | 119.1 | 0.580 | 3.62 | 3.08 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 46.4 | 138.2 | 0.670 | 4.35 | 2.98 |
| messages: 11 string members | 96000 | 1025025 | std.json | 103.3 | 370.8 | 1.092 | 9.68 | 3.59 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 95.6 | 315.4 | 0.789 | 8.96 | 3.30 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 113.8 | 400.7 | 0.851 | 10.66 | 3.52 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 21.9 | 80.2 | 0.007 | 2.74 | 3.66 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 39.0 | 152.5 | 0.006 | 4.88 | 3.91 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 22.9 | 93.2 | 0.006 | 2.87 | 4.07 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 205.1 | 866.7 | 0.742 | 25.67 | 4.23 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, J11's loop unchecked | 22.5 | 79.4 | 0.007 | 2.81 | 3.54 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 24.1 | 96.6 | 0.004 | 3.02 | 4.00 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 26.4 | 101.3 | 0.018 | 3.30 | 3.84 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 60.6 | 279.4 | 0.006 | 7.59 | 4.61 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 53.5 | 230.6 | 0.073 | 6.70 | 4.31 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 74.7 | 310.8 | 0.006 | 9.36 | 4.16 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 84467.5 | 280786.2 | 711.835 | 0.49 | 3.32 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84416.5 | 280732.2 | 709.660 | 0.49 | 3.33 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84381.0 | 280721.2 | 707.804 | 0.49 | 3.33 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3386488.3 | 16047574.2 | 2949.515 | 19.63 | 4.74 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 90255.7 | 274401.2 | 944.918 | 0.52 | 3.04 |
| string: silesia/dickens | 1 | 172528 | simdjson | 207539.5 | 674016.2 | 2054.619 | 1.20 | 3.25 |
| string: silesia/dickens | 1 | 172528 | yyjson | 205561.8 | 825518.2 | 1113.825 | 1.19 | 4.02 |
| string: silesia/dickens | 1 | 172528 | std.json | 1354654.2 | 2890892.2 | 55249.134 | 7.85 | 2.13 |
| string: silesia/dickens | 1 | 172528 | serde_json | 368107.4 | 1586249.2 | 2291.495 | 2.13 | 4.31 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 577640.2 | 2970251.9 | 2351.423 | 3.35 | 5.14 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1270421.6 | 3582350.6 | 11459.429 | 1.07 | 2.82 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1258811.1 | 3582290.6 | 11024.071 | 1.06 | 2.85 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1257462.6 | 3582277.6 | 11016.500 | 1.06 | 2.85 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25409435.9 | 109856348.6 | 141295.857 | 21.35 | 4.32 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1240827.9 | 3370022.6 | 11650.071 | 1.04 | 2.72 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2978531.1 | 10460762.6 | 29327.929 | 2.50 | 3.51 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2582459.7 | 10197931.6 | 9465.500 | 2.17 | 3.95 |
| string: http/json-1m | 1 | 1190272 | std.json | 8953175.4 | 43287986.6 | 17878.929 | 7.52 | 4.83 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4210097.6 | 17941088.6 | 10982.500 | 3.54 | 4.26 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5273463.6 | 26999452.4 | 11129.429 | 4.43 | 5.12 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2074231.0 | 6088099.8 | 4611.375 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2064791.9 | 6088043.8 | 4118.250 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2064428.4 | 6088026.8 | 4091.375 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43570683.5 | 193466553.8 | 264171.625 | 23.14 | 4.44 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2074834.9 | 5875346.8 | 4834.000 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2712205.0 | 7144143.8 | 20882.875 | 1.44 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12118709.8 | 23590602.8 | 446449.500 | 6.44 | 1.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20708164.0 | 56837736.8 | 549913.750 | 11.00 | 2.74 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11487927.1 | 33662338.8 | 333754.750 | 6.10 | 2.93 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18965626.5 | 76319032.6 | 254831.625 | 10.07 | 4.02 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113188.2 | 426376.7 | 4.516 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113080.9 | 426318.7 | 4.290 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113022.7 | 426305.7 | 2.484 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 638465.8 | 3146479.7 | 4.645 | 1.22 | 4.93 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113443.0 | 426343.7 | 1.387 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1202487.8 | 3866916.7 | 4.548 | 2.29 | 3.22 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1624703.0 | 5833341.7 | 5.323 | 3.10 | 3.59 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3532554.1 | 13108830.7 | 64619.677 | 6.74 | 3.71 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1787920.9 | 7405810.7 | 3.581 | 3.41 | 4.14 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2388806.0 | 12748182.9 | 16.742 | 4.56 | 5.34 |
