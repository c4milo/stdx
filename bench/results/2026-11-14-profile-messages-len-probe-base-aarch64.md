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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43648383354 |
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
| silesia/dickens | 10192446 | zlib | 8.82 | 19.08 | 2.16 | 311.28 |
| silesia/dickens | 10192446 | zlib-ng | 4.86 | 10.50 | 2.16 | 67.56 |
| silesia/dickens | 10192446 | libdeflate | 3.45 | 9.56 | 2.77 | 66.44 |
| silesia/dickens | 10192446 | Wuffs | 5.53 | 13.90 | 2.51 | 97.30 |
| silesia/dickens | 10192446 | stdx | 2.91 | 7.15 | 2.46 | 76.01 |
| silesia/mozilla | 51220480 | zlib | 8.46 | 17.23 | 2.04 | 251.55 |
| silesia/mozilla | 51220480 | zlib-ng | 4.94 | 8.95 | 1.81 | 85.58 |
| silesia/mozilla | 51220480 | libdeflate | 3.46 | 7.63 | 2.21 | 71.02 |
| silesia/mozilla | 51220480 | Wuffs | 6.40 | 13.89 | 2.17 | 132.68 |
| silesia/mozilla | 51220480 | stdx | 3.63 | 6.29 | 1.73 | 89.76 |
| silesia/mr | 9970564 | zlib | 8.36 | 18.46 | 2.21 | 203.17 |
| silesia/mr | 9970564 | zlib-ng | 4.79 | 9.98 | 2.09 | 67.93 |
| silesia/mr | 9970564 | libdeflate | 3.34 | 8.58 | 2.57 | 61.24 |
| silesia/mr | 9970564 | Wuffs | 5.98 | 14.04 | 2.35 | 99.79 |
| silesia/mr | 9970564 | stdx | 3.06 | 6.70 | 2.19 | 69.80 |
| silesia/nci | 33553445 | zlib | 3.52 | 10.18 | 2.89 | 81.25 |
| silesia/nci | 33553445 | zlib-ng | 1.57 | 3.13 | 2.00 | 33.72 |
| silesia/nci | 33553445 | libdeflate | 1.12 | 2.66 | 2.38 | 29.74 |
| silesia/nci | 33553445 | Wuffs | 2.44 | 6.47 | 2.65 | 41.47 |
| silesia/nci | 33553445 | stdx | 1.12 | 2.20 | 1.97 | 37.44 |
| silesia/ooffice | 6152192 | zlib | 11.76 | 21.06 | 1.79 | 416.43 |
| silesia/ooffice | 6152192 | zlib-ng | 6.92 | 12.04 | 1.74 | 141.81 |
| silesia/ooffice | 6152192 | libdeflate | 4.89 | 10.45 | 2.14 | 124.85 |
| silesia/ooffice | 6152192 | Wuffs | 8.80 | 17.54 | 1.99 | 220.31 |
| silesia/ooffice | 6152192 | stdx | 5.06 | 8.55 | 1.69 | 151.61 |
| silesia/osdb | 10085684 | zlib | 7.45 | 16.59 | 2.23 | 182.63 |
| silesia/osdb | 10085684 | zlib-ng | 4.28 | 8.38 | 1.96 | 52.96 |
| silesia/osdb | 10085684 | libdeflate | 2.83 | 6.91 | 2.44 | 29.74 |
| silesia/osdb | 10085684 | Wuffs | 5.79 | 13.61 | 2.35 | 78.11 |
| silesia/osdb | 10085684 | stdx | 2.77 | 5.65 | 2.04 | 41.29 |
| silesia/reymont | 6627202 | zlib | 7.37 | 15.89 | 2.16 | 259.44 |
| silesia/reymont | 6627202 | zlib-ng | 3.70 | 7.72 | 2.09 | 59.76 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.45 |
| silesia/reymont | 6627202 | Wuffs | 4.88 | 11.40 | 2.33 | 112.39 |
| silesia/reymont | 6627202 | stdx | 2.28 | 5.11 | 2.24 | 64.76 |
| silesia/samba | 21606400 | zlib | 6.11 | 14.13 | 2.31 | 175.83 |
| silesia/samba | 21606400 | zlib-ng | 3.34 | 6.47 | 1.94 | 55.93 |
| silesia/samba | 21606400 | libdeflate | 2.31 | 5.58 | 2.42 | 42.95 |
| silesia/samba | 21606400 | Wuffs | 4.32 | 10.39 | 2.40 | 79.68 |
| silesia/samba | 21606400 | stdx | 2.25 | 4.46 | 1.99 | 56.44 |
| silesia/sao | 7251944 | zlib | 10.47 | 23.54 | 2.25 | 203.52 |
| silesia/sao | 7251944 | zlib-ng | 7.84 | 14.83 | 1.89 | 79.41 |
| silesia/sao | 7251944 | libdeflate | 5.72 | 12.73 | 2.22 | 78.89 |
| silesia/sao | 7251944 | Wuffs | 8.89 | 21.26 | 2.39 | 86.27 |
| silesia/sao | 7251944 | stdx | 5.58 | 10.32 | 1.85 | 89.48 |
| silesia/webster | 41458703 | zlib | 7.77 | 16.16 | 2.08 | 281.04 |
| silesia/webster | 41458703 | zlib-ng | 4.20 | 8.04 | 1.91 | 85.27 |
| silesia/webster | 41458703 | libdeflate | 2.90 | 7.17 | 2.47 | 68.40 |
| silesia/webster | 41458703 | Wuffs | 5.14 | 11.67 | 2.27 | 122.26 |
| silesia/webster | 41458703 | stdx | 2.73 | 5.56 | 2.04 | 87.19 |
| silesia/x-ray | 8474240 | zlib | 12.86 | 27.21 | 2.12 | 328.39 |
| silesia/x-ray | 8474240 | zlib-ng | 9.02 | 17.39 | 1.93 | 124.22 |
| silesia/x-ray | 8474240 | libdeflate | 6.52 | 15.26 | 2.34 | 124.37 |
| silesia/x-ray | 8474240 | Wuffs | 10.81 | 23.52 | 2.18 | 191.18 |
| silesia/x-ray | 8474240 | stdx | 6.10 | 11.49 | 1.88 | 137.15 |
| silesia/xml | 5345280 | zlib | 4.22 | 11.16 | 2.64 | 118.54 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.76 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 31.98 |
| silesia/xml | 5345280 | Wuffs | 2.84 | 7.22 | 2.54 | 59.09 |
| silesia/xml | 5345280 | stdx | 1.33 | 2.65 | 2.00 | 41.89 |
| canterbury/alice29.txt | 152089 | zlib | 8.43 | 18.35 | 2.18 | 294.56 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.36 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.20 | 8.96 | 2.80 | 56.80 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.39 | 13.40 | 2.49 | 99.14 |
| canterbury/alice29.txt | 152089 | stdx | 2.71 | 6.99 | 2.58 | 62.84 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.02 | 19.42 | 2.15 | 314.29 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.09 | 10.86 | 2.13 | 73.40 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.58 | 9.82 | 2.74 | 66.70 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.76 | 14.40 | 2.50 | 100.28 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.05 | 7.52 | 2.46 | 76.24 |
| canterbury/cp.html | 24603 | zlib | 7.05 | 17.33 | 2.46 | 171.66 |
| canterbury/cp.html | 24603 | zlib-ng | 4.20 | 9.50 | 2.26 | 38.61 |
| canterbury/cp.html | 24603 | libdeflate | 2.78 | 7.95 | 2.86 | 9.86 |
| canterbury/cp.html | 24603 | Wuffs | 5.21 | 13.91 | 2.67 | 59.14 |
| canterbury/cp.html | 24603 | stdx | 2.63 | 7.19 | 2.73 | 12.15 |
| canterbury/fields.c | 11150 | zlib | 5.24 | 17.73 | 3.39 | 37.68 |
| canterbury/fields.c | 11150 | zlib-ng | 3.87 | 10.20 | 2.63 | 14.47 |
| canterbury/fields.c | 11150 | libdeflate | 2.81 | 8.32 | 2.96 | 1.44 |
| canterbury/fields.c | 11150 | Wuffs | 4.58 | 14.54 | 3.17 | 13.62 |
| canterbury/fields.c | 11150 | stdx | 2.50 | 7.64 | 3.06 | 4.55 |
| canterbury/grammar.lsp | 3721 | zlib | 6.87 | 24.26 | 3.53 | 4.94 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.84 | 17.48 | 2.99 | 6.95 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.47 | 12.05 | 2.70 | 0.95 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.75 | 21.86 | 3.24 | 3.34 |
| canterbury/grammar.lsp | 3721 | stdx | 3.85 | 12.18 | 3.17 | 1.21 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.59 | 15.27 | 3.33 | 48.70 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.63 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.74 | 5.97 | 2.18 | 9.01 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.87 | 11.59 | 3.00 | 14.89 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.74 | 4.66 | 2.68 | 16.60 |
| canterbury/lcet10.txt | 426754 | zlib | 8.20 | 17.78 | 2.17 | 289.71 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.18 | 60.73 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.37 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.23 | 12.88 | 2.46 | 101.61 |
| canterbury/lcet10.txt | 426754 | stdx | 2.59 | 6.42 | 2.48 | 66.65 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.20 | 19.86 | 2.16 | 321.28 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.26 | 11.19 | 2.13 | 76.73 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.76 | 10.19 | 2.71 | 77.11 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.81 | 14.61 | 2.52 | 98.89 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.15 | 7.63 | 2.42 | 84.92 |
| canterbury/ptt5 | 513216 | zlib | 5.05 | 10.71 | 2.12 | 103.27 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.01 | 3.74 | 1.86 | 46.94 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.08 | 38.21 |
| canterbury/ptt5 | 513216 | Wuffs | 3.00 | 7.13 | 2.38 | 57.50 |
| canterbury/ptt5 | 513216 | stdx | 1.45 | 2.55 | 1.76 | 48.76 |
| canterbury/sum | 38240 | zlib | 7.98 | 18.12 | 2.27 | 222.80 |
| canterbury/sum | 38240 | zlib-ng | 4.63 | 10.02 | 2.16 | 56.06 |
| canterbury/sum | 38240 | libdeflate | 3.27 | 8.34 | 2.55 | 31.36 |
| canterbury/sum | 38240 | Wuffs | 5.77 | 14.47 | 2.51 | 79.98 |
| canterbury/sum | 38240 | stdx | 3.02 | 7.73 | 2.56 | 28.26 |
| canterbury/xargs.1 | 4227 | zlib | 7.27 | 25.22 | 3.47 | 10.24 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.37 | 17.97 | 2.82 | 9.18 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.76 | 13.27 | 2.79 | 0.96 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.22 | 22.63 | 3.13 | 10.83 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 12.86 | 3.04 | 1.98 |
| canterbury-large/E.coli | 4638690 | zlib | 6.75 | 17.84 | 2.64 | 177.11 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.22 | 9.68 | 2.30 | 47.22 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.28 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.67 | 12.73 | 2.73 | 61.73 |
| canterbury-large/E.coli | 4638690 | stdx | 2.48 | 6.72 | 2.71 | 54.41 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.51 | 16.46 | 2.19 | 267.00 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.77 | 8.26 | 2.19 | 53.85 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.58 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.80 | 11.73 | 2.44 | 100.44 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.23 | 5.57 | 2.50 | 55.99 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.71 | 15.84 | 2.06 | 281.11 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.18 | 7.78 | 1.86 | 91.44 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.41 | 74.85 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.18 | 11.48 | 2.22 | 128.15 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.71 | 5.40 | 1.99 | 90.45 |
| http/html-1kx1024 | 1048576 | zlib | 16.25 | 35.58 | 2.19 | 351.73 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.69 | 28.43 | 2.24 | 217.19 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.54 | 20.05 | 1.90 | 155.46 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.44 | 38.07 | 2.47 | 266.04 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 137.23 |
| http/html-16kx64 | 1048576 | zlib | 6.71 | 14.77 | 2.20 | 221.54 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 84.98 |
| http/html-16kx64 | 1048576 | libdeflate | 2.64 | 6.04 | 2.29 | 60.98 |
| http/html-16kx64 | 1048576 | Wuffs | 4.93 | 11.56 | 2.35 | 115.13 |
| http/html-16kx64 | 1048576 | stdx | 2.52 | 5.56 | 2.21 | 58.99 |
| http/html-1m | 1048576 | zlib | 5.30 | 12.53 | 2.36 | 175.22 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 59.87 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.53 |
| http/html-1m | 1048576 | Wuffs | 3.61 | 8.48 | 2.35 | 88.12 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.11 | 52.88 |
| http/json-1kx1024 | 1048576 | zlib | 10.17 | 23.92 | 2.35 | 192.71 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.26 | 130.64 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.81 | 16.72 | 1.90 | 92.31 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.18 | 34.78 | 2.85 | 147.00 |
| http/json-1kx1024 | 1048576 | stdx | 5.04 | 13.12 | 2.60 | 81.29 |
| http/json-16kx64 | 1048576 | zlib | 4.56 | 12.51 | 2.75 | 103.48 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.10 | 51.07 |
| http/json-16kx64 | 1048576 | libdeflate | 1.93 | 4.24 | 2.20 | 40.62 |
| http/json-16kx64 | 1048576 | Wuffs | 3.52 | 9.43 | 2.68 | 58.08 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.26 | 39.28 |
| http/json-1m | 1048576 | zlib | 3.84 | 11.20 | 2.92 | 83.29 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.02 | 37.38 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.72 |
| http/json-1m | 1048576 | Wuffs | 2.73 | 7.37 | 2.70 | 43.58 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.02 | 39.91 |
| http/js-1kx1024 | 1048576 | zlib | 17.79 | 38.46 | 2.16 | 409.91 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.78 | 31.25 | 2.27 | 238.61 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.21 | 21.58 | 1.92 | 179.25 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.60 | 40.70 | 2.45 | 299.98 |
| http/js-1kx1024 | 1048576 | stdx | 9.27 | 22.85 | 2.46 | 158.97 |
| http/js-16kx64 | 1048576 | zlib | 7.66 | 16.08 | 2.10 | 265.58 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.97 | 92.02 |
| http/js-16kx64 | 1048576 | libdeflate | 3.05 | 7.01 | 2.30 | 72.10 |
| http/js-16kx64 | 1048576 | Wuffs | 5.50 | 12.75 | 2.32 | 128.61 |
| http/js-16kx64 | 1048576 | stdx | 2.99 | 6.54 | 2.19 | 71.65 |
| http/js-1m | 1048576 | zlib | 5.86 | 13.31 | 2.27 | 201.35 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.96 | 60.40 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.94 |
| http/js-1m | 1048576 | Wuffs | 3.90 | 9.14 | 2.34 | 93.74 |
| http/js-1m | 1048576 | stdx | 1.80 | 3.89 | 2.16 | 55.26 |
| http/css-1kx1024 | 1048576 | zlib | 13.59 | 30.36 | 2.23 | 280.18 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.25 | 23.04 | 2.25 | 170.53 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.13 | 17.37 | 1.90 | 121.04 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.86 | 32.49 | 2.53 | 210.89 |
| http/css-1kx1024 | 1048576 | stdx | 6.69 | 17.64 | 2.64 | 101.15 |
| http/css-16kx64 | 1048576 | zlib | 5.29 | 13.04 | 2.46 | 154.28 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.19 | 50.11 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 29.84 |
| http/css-16kx64 | 1048576 | Wuffs | 3.79 | 10.01 | 2.64 | 69.68 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.53 | 28.33 |
| http/css-1m | 1048576 | zlib | 3.97 | 10.97 | 2.76 | 107.53 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.22 | 29.10 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.98 | 12.71 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.78 | 43.39 |
| http/css-1m | 1048576 | stdx | 1.02 | 2.56 | 2.52 | 21.75 |
| shuffled/dickens-1m | 1048576 | zlib | 13.30 | 25.88 | 1.95 | 373.32 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.75 | 16.72 | 1.72 | 199.22 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.03 | 14.95 | 2.13 | 193.95 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.32 | 22.08 | 2.14 | 199.90 |
| shuffled/dickens-1m | 1048576 | stdx | 7.04 | 11.89 | 1.69 | 206.21 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.42 | 14.05 | 4.10 | 3.37 |
| silesia/dickens | 10192446 | stdx | 3.59 | 12.47 | 3.47 | 3.59 |
| silesia/mozilla | 51220480 | libzstd | 2.78 | 9.68 | 3.48 | 30.08 |
| silesia/mozilla | 51220480 | stdx | 2.77 | 9.68 | 3.49 | 15.57 |
| silesia/mr | 9970564 | libzstd | 2.95 | 11.99 | 4.06 | 6.08 |
| silesia/mr | 9970564 | stdx | 3.01 | 10.83 | 3.60 | 5.28 |
| silesia/nci | 33553445 | libzstd | 1.58 | 4.88 | 3.09 | 24.79 |
| silesia/nci | 33553445 | stdx | 1.58 | 4.63 | 2.94 | 13.54 |
| silesia/ooffice | 6152192 | libzstd | 3.34 | 12.19 | 3.65 | 30.99 |
| silesia/ooffice | 6152192 | stdx | 3.31 | 12.40 | 3.74 | 12.18 |
| silesia/osdb | 10085684 | libzstd | 2.33 | 8.45 | 3.62 | 14.92 |
| silesia/osdb | 10085684 | stdx | 2.40 | 8.11 | 3.38 | 15.66 |
| silesia/reymont | 6627202 | libzstd | 3.15 | 11.62 | 3.69 | 11.55 |
| silesia/reymont | 6627202 | stdx | 3.30 | 10.36 | 3.14 | 12.71 |
| silesia/samba | 21606400 | libzstd | 2.04 | 7.41 | 3.63 | 18.68 |
| silesia/samba | 21606400 | stdx | 2.07 | 6.83 | 3.29 | 17.61 |
| silesia/sao | 7251944 | libzstd | 3.73 | 12.72 | 3.41 | 26.57 |
| silesia/sao | 7251944 | stdx | 3.43 | 12.58 | 3.67 | 6.26 |
| silesia/webster | 41458703 | libzstd | 3.09 | 11.24 | 3.63 | 16.12 |
| silesia/webster | 41458703 | stdx | 3.20 | 10.05 | 3.14 | 17.27 |
| silesia/x-ray | 8474240 | libzstd | 3.87 | 14.94 | 3.86 | 18.94 |
| silesia/x-ray | 8474240 | stdx | 3.53 | 13.23 | 3.75 | 8.41 |
| silesia/xml | 5345280 | libzstd | 1.54 | 5.57 | 3.62 | 23.22 |
| silesia/xml | 5345280 | stdx | 1.50 | 5.16 | 3.43 | 16.98 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.89 | 4.15 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.44 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.96 | 14.26 | 4.82 | 3.26 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.30 | 0.27 |
| canterbury/cp.html | 24603 | libzstd | 2.63 | 10.74 | 4.08 | 7.84 |
| canterbury/cp.html | 24603 | stdx | 2.56 | 10.42 | 4.07 | 0.28 |
| canterbury/fields.c | 11150 | libzstd | 3.13 | 13.62 | 4.35 | 9.69 |
| canterbury/fields.c | 11150 | stdx | 3.00 | 12.72 | 4.24 | 0.20 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.19 | 16.94 | 4.04 | 5.02 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.54 | 4.02 | 0.14 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.53 | 11.40 | 4.51 | 7.78 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.25 | 0.84 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.72 | 12.89 | 4.73 | 5.16 |
| canterbury/lcet10.txt | 426754 | stdx | 2.77 | 11.52 | 4.16 | 4.14 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.11 | 15.16 | 4.88 | 1.55 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.27 | 0.92 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.52 | 3.12 | 24.82 |
| canterbury/ptt5 | 513216 | stdx | 1.33 | 4.46 | 3.36 | 13.14 |
| canterbury/sum | 38240 | libzstd | 2.61 | 10.58 | 4.05 | 10.13 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.09 | 0.29 |
| canterbury/xargs.1 | 4227 | libzstd | 4.24 | 17.41 | 4.10 | 9.22 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.17 | 4.05 | 0.17 |
| canterbury-large/E.coli | 4638690 | libzstd | 2.97 | 13.64 | 4.59 | 2.12 |
| canterbury-large/E.coli | 4638690 | stdx | 3.10 | 12.04 | 3.88 | 2.82 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.93 | 12.00 | 4.10 | 8.30 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.02 | 10.64 | 3.52 | 9.31 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.52 | 9.60 | 3.82 | 19.68 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.59 | 8.64 | 3.34 | 21.74 |
| http/html-1kx1024 | 1048576 | libzstd | 7.25 | 21.63 | 2.98 | 63.09 |
| http/html-1kx1024 | 1048576 | stdx | 7.45 | 22.46 | 3.02 | 76.32 |
| http/html-16kx64 | 1048576 | libzstd | 2.67 | 10.15 | 3.81 | 28.57 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 9.61 | 3.61 | 30.02 |
| http/html-1m | 1048576 | libzstd | 2.02 | 7.88 | 3.91 | 24.09 |
| http/html-1m | 1048576 | stdx | 2.04 | 7.12 | 3.49 | 24.45 |
| http/json-1kx1024 | 1048576 | libzstd | 6.27 | 17.39 | 2.77 | 49.70 |
| http/json-1kx1024 | 1048576 | stdx | 6.21 | 17.86 | 2.88 | 53.30 |
| http/json-16kx64 | 1048576 | libzstd | 2.06 | 7.26 | 3.53 | 28.43 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.58 | 19.93 |
| http/json-1m | 1048576 | libzstd | 1.73 | 6.08 | 3.52 | 28.11 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.63 | 14.38 |
| http/js-1kx1024 | 1048576 | libzstd | 8.34 | 26.35 | 3.16 | 73.66 |
| http/js-1kx1024 | 1048576 | stdx | 9.03 | 27.60 | 3.06 | 113.33 |
| http/js-16kx64 | 1048576 | libzstd | 2.92 | 11.72 | 4.01 | 24.30 |
| http/js-16kx64 | 1048576 | stdx | 2.95 | 11.06 | 3.75 | 25.29 |
| http/js-1m | 1048576 | libzstd | 2.02 | 8.19 | 4.06 | 20.29 |
| http/js-1m | 1048576 | stdx | 2.06 | 7.48 | 3.63 | 21.41 |
| http/css-1kx1024 | 1048576 | libzstd | 6.89 | 19.69 | 2.86 | 53.62 |
| http/css-1kx1024 | 1048576 | stdx | 6.84 | 19.96 | 2.92 | 63.53 |
| http/css-16kx64 | 1048576 | libzstd | 2.25 | 8.70 | 3.87 | 23.15 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.10 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.58 | 3.86 | 5.47 |
| http/css-1m | 1048576 | stdx | 0.72 | 2.49 | 3.49 | 4.34 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.76 | 9.40 | 3.40 | 28.34 |
| shuffled/dickens-1m | 1048576 | stdx | 2.71 | 9.19 | 3.39 | 12.27 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.50 | 16.93 | 2.26 | 100.00 |
| silesia/dickens | 1048576 | stdx | 5.04 | 12.38 | 2.46 | 54.46 |
| silesia/mozilla | 1048576 | Google | 13.46 | 28.31 | 2.10 | 47.59 |
| silesia/mozilla | 1048576 | stdx | 8.32 | 15.02 | 1.81 | 47.14 |
| silesia/mr | 1048576 | Google | 8.91 | 20.21 | 2.27 | 103.29 |
| silesia/mr | 1048576 | stdx | 5.75 | 13.25 | 2.31 | 88.38 |
| silesia/nci | 1048576 | Google | 2.55 | 5.70 | 2.23 | 52.39 |
| silesia/nci | 1048576 | stdx | 1.94 | 3.95 | 2.04 | 54.64 |
| silesia/ooffice | 1048576 | Google | 14.12 | 29.27 | 2.07 | 288.41 |
| silesia/ooffice | 1048576 | stdx | 10.92 | 20.33 | 1.86 | 323.42 |
| silesia/osdb | 1048576 | Google | 8.21 | 17.48 | 2.13 | 97.18 |
| silesia/osdb | 1048576 | stdx | 5.31 | 10.57 | 1.99 | 91.17 |
| silesia/reymont | 1048576 | Google | 5.41 | 12.62 | 2.33 | 82.78 |
| silesia/reymont | 1048576 | stdx | 3.72 | 9.25 | 2.48 | 47.86 |
| silesia/samba | 1048576 | Google | 7.57 | 16.30 | 2.15 | 95.43 |
| silesia/samba | 1048576 | stdx | 5.04 | 10.71 | 2.12 | 66.90 |
| silesia/sao | 1048576 | Google | 16.83 | 37.18 | 2.21 | 167.75 |
| silesia/sao | 1048576 | stdx | 10.43 | 22.65 | 2.17 | 141.82 |
| silesia/webster | 1048576 | Google | 6.50 | 14.00 | 2.15 | 113.70 |
| silesia/webster | 1048576 | stdx | 4.49 | 9.98 | 2.22 | 68.50 |
| silesia/x-ray | 1048576 | Google | 19.32 | 38.56 | 2.00 | 235.99 |
| silesia/x-ray | 1048576 | stdx | 14.56 | 30.18 | 2.07 | 234.94 |
| silesia/xml | 1048576 | Google | 3.44 | 7.61 | 2.21 | 65.22 |
| silesia/xml | 1048576 | stdx | 2.39 | 5.40 | 2.26 | 46.94 |
| canterbury/alice29.txt | 152089 | Google | 8.84 | 20.55 | 2.33 | 133.60 |
| canterbury/alice29.txt | 152089 | stdx | 6.05 | 15.33 | 2.54 | 80.13 |
| canterbury/asyoulik.txt | 125179 | Google | 10.34 | 23.71 | 2.29 | 166.88 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.05 | 17.43 | 2.47 | 103.65 |
| canterbury/cp.html | 24603 | Google | 9.03 | 22.20 | 2.46 | 116.20 |
| canterbury/cp.html | 24603 | stdx | 6.04 | 17.15 | 2.84 | 51.41 |
| canterbury/fields.c | 11150 | Google | 7.13 | 21.16 | 2.97 | 31.73 |
| canterbury/fields.c | 11150 | stdx | 4.91 | 17.08 | 3.48 | 1.77 |
| canterbury/grammar.lsp | 3721 | Google | 9.81 | 30.16 | 3.07 | 7.59 |
| canterbury/grammar.lsp | 3721 | stdx | 7.21 | 25.04 | 3.47 | 0.57 |
| canterbury/kennedy.xls | 1029744 | Google | 5.40 | 17.05 | 3.16 | 37.48 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.80 | 12.94 | 3.41 | 33.97 |
| canterbury/lcet10.txt | 426754 | Google | 7.69 | 17.36 | 2.26 | 125.32 |
| canterbury/lcet10.txt | 426754 | stdx | 5.18 | 12.96 | 2.50 | 66.27 |
| canterbury/plrabn12.txt | 481861 | Google | 9.05 | 20.82 | 2.30 | 132.42 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.13 | 15.04 | 2.46 | 86.95 |
| canterbury/ptt5 | 513216 | Google | 4.28 | 10.41 | 2.43 | 62.49 |
| canterbury/ptt5 | 513216 | stdx | 2.36 | 4.89 | 2.08 | 64.91 |
| canterbury/sum | 38240 | Google | 10.87 | 26.44 | 2.43 | 161.47 |
| canterbury/sum | 38240 | stdx | 8.42 | 21.11 | 2.51 | 163.19 |
| canterbury/xargs.1 | 4227 | Google | 11.00 | 34.81 | 3.16 | 13.43 |
| canterbury/xargs.1 | 4227 | stdx | 8.54 | 30.44 | 3.56 | 7.06 |
| canterbury-large/E.coli | 1048576 | Google | 8.14 | 19.55 | 2.40 | 1.38 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.68 |
| canterbury-large/bible.txt | 1048576 | Google | 5.29 | 12.28 | 2.32 | 80.62 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.51 | 8.93 | 2.54 | 39.83 |
| canterbury-large/world192.txt | 1048576 | Google | 6.16 | 12.84 | 2.08 | 114.91 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.36 | 9.38 | 2.15 | 77.10 |
| http/html-1kx1024 | 1048576 | Google | 17.98 | 41.93 | 2.33 | 386.97 |
| http/html-1kx1024 | 1048576 | stdx | 15.48 | 37.56 | 2.43 | 359.96 |
| http/html-16kx64 | 1048576 | Google | 6.73 | 14.85 | 2.21 | 149.08 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.35 |
| http/html-1m | 1048576 | Google | 4.03 | 8.94 | 2.22 | 83.02 |
| http/html-1m | 1048576 | stdx | 2.84 | 6.52 | 2.30 | 54.82 |
| http/json-1kx1024 | 1048576 | Google | 14.44 | 36.64 | 2.54 | 241.33 |
| http/json-1kx1024 | 1048576 | stdx | 13.28 | 33.63 | 2.53 | 278.41 |
| http/json-16kx64 | 1048576 | Google | 4.43 | 11.43 | 2.58 | 82.90 |
| http/json-16kx64 | 1048576 | stdx | 3.38 | 8.42 | 2.49 | 83.25 |
| http/json-1m | 1048576 | Google | 3.40 | 8.65 | 2.54 | 60.05 |
| http/json-1m | 1048576 | stdx | 2.45 | 5.99 | 2.45 | 57.32 |
| http/js-1kx1024 | 1048576 | Google | 19.83 | 46.20 | 2.33 | 424.56 |
| http/js-1kx1024 | 1048576 | stdx | 16.58 | 39.90 | 2.41 | 380.70 |
| http/js-16kx64 | 1048576 | Google | 8.02 | 17.73 | 2.21 | 166.44 |
| http/js-16kx64 | 1048576 | stdx | 6.04 | 14.36 | 2.38 | 125.63 |
| http/js-1m | 1048576 | Google | 4.33 | 9.54 | 2.20 | 82.91 |
| http/js-1m | 1048576 | stdx | 3.15 | 7.25 | 2.30 | 55.33 |
| http/css-1kx1024 | 1048576 | Google | 15.48 | 37.36 | 2.41 | 295.44 |
| http/css-1kx1024 | 1048576 | stdx | 14.05 | 34.70 | 2.47 | 302.44 |
| http/css-16kx64 | 1048576 | Google | 4.96 | 11.76 | 2.37 | 103.08 |
| http/css-16kx64 | 1048576 | stdx | 3.85 | 9.54 | 2.48 | 80.66 |
| http/css-1m | 1048576 | Google | 2.43 | 9.42 | 3.88 | 17.03 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.48 | 12.10 |
| shuffled/dickens-1m | 1048576 | Google | 10.08 | 20.65 | 2.05 | 104.32 |
| shuffled/dickens-1m | 1048576 | stdx | 8.76 | 14.53 | 1.66 | 117.45 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.21 | 36.91 | 2.43 | 412.22 |
| silesia/dickens | 10192446 | 1 | stdx | 16.26 | 38.17 | 2.35 | 360.16 |
| silesia/dickens | 10192446 | 6 | libdeflate | 51.98 | 87.63 | 1.69 | 695.06 |
| silesia/dickens | 10192446 | 6 | stdx | 49.47 | 84.26 | 1.70 | 1437.68 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.75 | 160.47 | 1.44 | 927.95 |
| silesia/dickens | 10192446 | 9 | stdx | 85.11 | 191.81 | 2.25 | 1720.57 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.12 | 32.62 | 2.31 | 438.16 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.36 | 30.24 | 2.26 | 296.11 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.84 | 70.83 | 2.16 | 580.45 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.53 | 69.96 | 2.22 | 735.72 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.59 | 221.49 | 1.74 | 767.59 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.90 | 126.12 | 2.58 | 791.25 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.91 | 35.02 | 2.94 | 230.13 |
| silesia/mr | 9970564 | 1 | stdx | 12.46 | 34.08 | 2.74 | 187.84 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.15 | 80.54 | 2.11 | 437.54 |
| silesia/mr | 9970564 | 6 | stdx | 39.58 | 83.19 | 2.10 | 977.50 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.82 | 165.48 | 1.69 | 750.16 |
| silesia/mr | 9970564 | 9 | stdx | 87.11 | 206.31 | 2.37 | 1328.71 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.18 | 18.42 | 2.98 | 115.84 |
| silesia/nci | 33553445 | 1 | stdx | 4.92 | 10.88 | 2.21 | 98.59 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.93 | 34.84 | 2.06 | 225.43 |
| silesia/nci | 33553445 | 6 | stdx | 14.37 | 29.54 | 2.06 | 395.08 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.33 | 105.28 | 1.69 | 499.18 |
| silesia/nci | 33553445 | 9 | stdx | 33.11 | 80.64 | 2.44 | 647.45 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.85 | 39.15 | 1.97 | 752.89 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.52 | 39.08 | 2.23 | 429.88 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 40.85 | 79.10 | 1.94 | 952.84 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.46 | 87.83 | 2.12 | 1014.58 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.50 | 127.63 | 1.71 | 1129.99 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.07 | 129.17 | 2.48 | 937.23 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.81 | 30.15 | 2.35 | 352.51 |
| silesia/osdb | 10085684 | 1 | stdx | 12.77 | 27.87 | 2.18 | 294.65 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.28 | 55.67 | 1.97 | 493.64 |
| silesia/osdb | 10085684 | 6 | stdx | 26.93 | 57.40 | 2.13 | 562.95 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.88 | 64.15 | 1.89 | 551.88 |
| silesia/osdb | 10085684 | 9 | stdx | 35.64 | 87.23 | 2.45 | 688.96 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.59 | 32.88 | 2.61 | 313.16 |
| silesia/reymont | 6627202 | 1 | stdx | 13.20 | 33.24 | 2.52 | 271.10 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.04 | 86.58 | 1.80 | 520.08 |
| silesia/reymont | 6627202 | 6 | stdx | 45.18 | 76.82 | 1.70 | 1438.51 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.15 | 276.14 | 1.39 | 839.70 |
| silesia/reymont | 6627202 | 9 | stdx | 87.26 | 189.98 | 2.18 | 1606.69 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.44 | 26.53 | 2.54 | 273.07 |
| silesia/samba | 21606400 | 1 | stdx | 9.82 | 22.23 | 2.26 | 221.49 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.90 | 58.79 | 2.03 | 385.71 |
| silesia/samba | 21606400 | 6 | stdx | 24.10 | 49.84 | 2.07 | 625.40 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.17 | 141.44 | 1.68 | 505.69 |
| silesia/samba | 21606400 | 9 | stdx | 41.67 | 102.63 | 2.46 | 732.97 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.70 | 47.87 | 2.21 | 689.39 |
| silesia/sao | 7251944 | 1 | stdx | 18.97 | 49.92 | 2.63 | 346.31 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.08 | 96.89 | 1.90 | 964.76 |
| silesia/sao | 7251944 | 6 | stdx | 46.99 | 105.66 | 2.25 | 847.28 |
| silesia/sao | 7251944 | 9 | libdeflate | 70.91 | 120.26 | 1.70 | 1105.95 |
| silesia/sao | 7251944 | 9 | stdx | 55.36 | 138.16 | 2.50 | 850.71 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.09 | 30.45 | 2.33 | 385.89 |
| silesia/webster | 41458703 | 1 | stdx | 13.84 | 29.09 | 2.10 | 339.59 |
| silesia/webster | 41458703 | 6 | libdeflate | 36.94 | 66.02 | 1.79 | 570.51 |
| silesia/webster | 41458703 | 6 | stdx | 35.03 | 60.88 | 1.74 | 1103.21 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.50 | 138.85 | 1.47 | 754.12 |
| silesia/webster | 41458703 | 9 | stdx | 60.90 | 135.96 | 2.23 | 1290.74 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.69 | 49.67 | 2.10 | 790.28 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.40 | 50.82 | 2.92 | 261.48 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.82 | 82.77 | 2.52 | 855.86 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.75 | 98.12 | 2.91 | 539.60 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.46 | 91.03 | 2.43 | 1029.96 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.53 | 122.06 | 3.01 | 467.23 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.77 | 21.59 | 2.78 | 176.26 |
| silesia/xml | 5345280 | 1 | stdx | 6.79 | 15.66 | 2.31 | 155.33 |
| silesia/xml | 5345280 | 6 | libdeflate | 20.93 | 40.51 | 1.94 | 263.82 |
| silesia/xml | 5345280 | 6 | stdx | 17.37 | 34.32 | 1.98 | 498.10 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.36 | 89.17 | 1.53 | 369.96 |
| silesia/xml | 5345280 | 9 | stdx | 30.96 | 72.83 | 2.35 | 600.87 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.29 | 35.61 | 2.49 | 380.16 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.03 | 36.13 | 2.40 | 335.82 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.72 | 82.29 | 1.76 | 641.56 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.66 | 77.43 | 1.77 | 1314.84 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.46 | 159.21 | 1.48 | 849.09 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 72.96 | 167.73 | 2.30 | 1518.32 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.21 | 37.20 | 2.45 | 418.23 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.75 | 37.43 | 2.38 | 357.62 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.30 | 85.43 | 1.77 | 718.25 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 45.84 | 81.93 | 1.79 | 1355.91 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.89 | 136.15 | 1.53 | 943.38 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 75.88 | 175.98 | 2.32 | 1611.78 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.75 | 32.02 | 2.73 | 286.74 |
| canterbury/cp.html | 24603 | 1 | stdx | 11.05 | 27.13 | 2.45 | 246.99 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 26.96 | 62.33 | 2.31 | 488.32 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.80 | 57.06 | 2.40 | 616.81 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.86 | 91.97 | 1.96 | 601.44 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.53 | 88.89 | 2.82 | 646.34 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.38 | 35.92 | 3.83 | 55.36 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.17 | 30.06 | 3.68 | 22.48 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.45 | 69.37 | 2.84 | 244.33 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.86 | 57.62 | 2.76 | 409.04 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.95 | 100.81 | 2.24 | 444.71 |
| canterbury/fields.c | 11150 | 9 | stdx | 29.25 | 92.66 | 3.17 | 458.47 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.01 | 51.51 | 3.96 | 12.15 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.98 | 39.03 | 3.91 | 3.16 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.82 | 87.06 | 3.65 | 32.54 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.67 | 70.82 | 4.01 | 21.68 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 31.23 | 102.89 | 3.29 | 63.80 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 24.17 | 99.32 | 4.11 | 65.55 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.36 | 27.18 | 3.69 | 65.34 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.03 | 22.58 | 3.21 | 62.75 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.81 | 73.85 | 2.66 | 96.39 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.31 | 62.00 | 3.21 | 138.69 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.19 | 664.23 | 1.83 | 163.78 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.61 | 130.89 | 3.48 | 218.25 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.79 | 33.99 | 2.46 | 370.94 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.47 | 33.93 | 2.34 | 329.43 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.00 | 78.22 | 1.74 | 608.41 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.64 | 73.43 | 1.76 | 1222.21 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.77 | 136.94 | 1.49 | 805.38 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 70.84 | 162.25 | 2.29 | 1450.76 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.79 | 38.62 | 2.45 | 426.42 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.73 | 40.25 | 2.40 | 370.13 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.09 | 91.90 | 1.70 | 755.49 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.43 | 88.90 | 1.73 | 1496.50 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.83 | 166.26 | 1.42 | 1001.65 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 88.89 | 201.33 | 2.27 | 1811.51 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.42 | 18.61 | 2.90 | 141.25 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.97 | 11.03 | 2.22 | 123.30 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.26 | 36.17 | 2.54 | 219.86 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.33 | 29.58 | 2.40 | 312.28 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.41 | 120.86 | 2.00 | 374.11 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.17 | 130.09 | 3.01 | 640.95 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.83 | 33.49 | 2.61 | 337.64 |
| canterbury/sum | 38240 | 1 | stdx | 12.52 | 29.36 | 2.35 | 293.14 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.66 | 69.87 | 2.44 | 504.02 |
| canterbury/sum | 38240 | 6 | stdx | 26.86 | 65.74 | 2.45 | 665.37 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.31 | 181.91 | 1.93 | 613.31 |
| canterbury/sum | 38240 | 9 | stdx | 39.49 | 112.34 | 2.84 | 657.61 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.29 | 53.06 | 3.99 | 21.88 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.82 | 43.11 | 3.99 | 3.32 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.94 | 87.70 | 3.82 | 69.51 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 18.84 | 74.37 | 3.95 | 43.94 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 25.48 | 94.34 | 3.70 | 121.94 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.97 | 106.97 | 3.97 | 127.22 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.02 | 40.47 | 3.37 | 164.84 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.46 | 42.29 | 3.39 | 101.32 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.26 | 395.99 | 2.16 | 260.58 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.62 | 374.13 | 3.05 | 1897.29 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 818.18 | 1063.49 | 1.30 | 1326.41 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 229.18 | 755.68 | 3.30 | 2443.49 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.52 | 32.38 | 2.59 | 312.97 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.17 | 32.23 | 2.45 | 281.69 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 45.93 | 80.12 | 1.74 | 523.87 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 41.86 | 72.39 | 1.73 | 1256.21 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.63 | 200.28 | 1.41 | 742.60 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.20 | 170.21 | 2.23 | 1439.33 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.29 | 29.72 | 2.24 | 413.89 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.07 | 28.55 | 2.03 | 379.53 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 32.93 | 60.25 | 1.83 | 559.60 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 31.79 | 56.81 | 1.79 | 983.81 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.44 | 119.11 | 1.48 | 685.90 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 51.83 | 117.95 | 2.28 | 1147.03 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.39 | 103.92 | 2.94 | 452.28 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 23.33 | 58.69 | 2.52 | 365.89 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.16 | 138.34 | 3.00 | 564.17 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 33.02 | 94.36 | 2.86 | 529.87 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.68 | 142.44 | 2.99 | 589.87 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 37.16 | 112.18 | 3.02 | 537.28 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.46 | 27.96 | 2.67 | 267.91 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.07 | 20.25 | 2.23 | 234.37 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.44 | 52.09 | 2.32 | 403.62 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.98 | 42.87 | 2.26 | 538.03 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 35.00 | 72.54 | 2.07 | 469.94 |
| http/html-16kx64 | 1048576 | 9 | stdx | 25.14 | 69.06 | 2.75 | 551.16 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.76 | 23.03 | 2.63 | 223.99 |
| http/html-1m | 1048576 | 1 | stdx | 8.16 | 17.80 | 2.18 | 206.46 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.24 | 49.53 | 1.96 | 326.83 |
| http/html-1m | 1048576 | 6 | stdx | 21.18 | 40.71 | 1.92 | 623.13 |
| http/html-1m | 1048576 | 9 | libdeflate | 70.92 | 109.24 | 1.54 | 432.14 |
| http/html-1m | 1048576 | 9 | stdx | 35.82 | 85.76 | 2.39 | 706.91 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.78 | 94.80 | 2.98 | 302.60 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 18.48 | 45.22 | 2.45 | 242.21 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.01 | 126.60 | 2.94 | 372.05 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 28.14 | 78.43 | 2.79 | 376.62 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.09 | 142.45 | 2.73 | 432.00 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 31.81 | 95.61 | 3.01 | 383.85 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.85 | 23.85 | 3.04 | 134.60 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.48 | 13.94 | 2.54 | 110.85 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.16 | 46.61 | 2.57 | 206.20 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.55 | 35.02 | 2.58 | 275.75 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.10 | 151.99 | 1.90 | 295.83 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.42 | 58.45 | 3.01 | 301.30 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.73 | 19.85 | 2.95 | 124.14 |
| http/json-1m | 1048576 | 1 | stdx | 5.05 | 12.51 | 2.48 | 102.60 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.30 | 45.30 | 2.23 | 175.42 |
| http/json-1m | 1048576 | 6 | stdx | 14.66 | 35.09 | 2.39 | 296.61 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.33 | 205.21 | 1.69 | 275.04 |
| http/json-1m | 1048576 | 9 | stdx | 29.06 | 72.87 | 2.51 | 369.76 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.08 | 107.80 | 2.91 | 519.10 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 25.62 | 65.45 | 2.55 | 411.43 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.29 | 144.85 | 2.94 | 676.06 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 36.62 | 104.17 | 2.84 | 622.18 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.70 | 150.13 | 2.90 | 719.47 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 41.40 | 125.18 | 3.02 | 626.65 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.72 | 30.90 | 2.64 | 309.11 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.86 | 24.80 | 2.28 | 273.57 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.97 | 59.43 | 2.29 | 480.98 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.76 | 50.05 | 2.20 | 669.50 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.84 | 83.31 | 2.04 | 569.34 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.93 | 81.31 | 2.72 | 663.50 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.64 | 25.19 | 2.61 | 247.56 |
| http/js-1m | 1048576 | 1 | stdx | 9.55 | 21.31 | 2.23 | 233.75 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.70 | 56.12 | 1.96 | 370.04 |
| http/js-1m | 1048576 | 6 | stdx | 24.74 | 46.64 | 1.89 | 737.11 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.19 | 120.65 | 1.58 | 500.21 |
| http/js-1m | 1048576 | 9 | stdx | 41.96 | 100.01 | 2.38 | 812.86 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.21 | 97.74 | 2.94 | 376.83 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 20.32 | 49.57 | 2.44 | 301.89 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.77 | 129.23 | 2.95 | 476.39 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 30.03 | 82.37 | 2.74 | 502.69 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.75 | 133.80 | 2.92 | 507.37 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 34.14 | 99.53 | 2.92 | 520.38 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.63 | 25.60 | 2.97 | 173.13 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.72 | 16.96 | 2.53 | 135.91 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.28 | 48.80 | 2.41 | 293.87 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.55 | 38.01 | 2.30 | 459.48 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.86 | 82.40 | 2.02 | 375.74 |
| http/css-16kx64 | 1048576 | 9 | stdx | 23.30 | 65.14 | 2.80 | 479.81 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.96 | 21.15 | 3.04 | 133.54 |
| http/css-1m | 1048576 | 1 | stdx | 5.79 | 14.91 | 2.58 | 108.94 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.77 | 44.50 | 2.14 | 226.87 |
| http/css-1m | 1048576 | 6 | stdx | 16.60 | 35.61 | 2.15 | 447.21 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.63 | 111.58 | 1.60 | 309.16 |
| http/css-1m | 1048576 | 9 | stdx | 32.08 | 83.00 | 2.59 | 511.44 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.27 | 48.89 | 1.93 | 935.46 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.08 | 49.19 | 2.72 | 322.71 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.48 | 86.45 | 2.08 | 1180.81 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.68 | 88.80 | 2.24 | 856.20 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.00 | 94.50 | 2.01 | 1346.08 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.09 | 134.38 | 2.48 | 1134.23 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.04 | 31.22 | 3.11 | 120.09 |
| silesia/dickens | 10192446 | 1 | stdx | 24.17 | 82.03 | 3.39 | 126.38 |
| silesia/dickens | 10192446 | 3 | libzstd | 21.79 | 34.39 | 1.58 | 170.07 |
| silesia/dickens | 10192446 | 3 | stdx | 34.88 | 78.22 | 2.24 | 183.32 |
| silesia/mozilla | 51220480 | 1 | libzstd | 6.97 | 22.69 | 3.26 | 71.13 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.56 | 54.73 | 3.12 | 175.27 |
| silesia/mozilla | 51220480 | 3 | libzstd | 16.27 | 27.89 | 1.71 | 102.31 |
| silesia/mozilla | 51220480 | 3 | stdx | 29.93 | 62.01 | 2.07 | 145.81 |
| silesia/mr | 9970564 | 1 | libzstd | 7.60 | 24.81 | 3.26 | 57.92 |
| silesia/mr | 9970564 | 1 | stdx | 19.79 | 66.82 | 3.38 | 116.46 |
| silesia/mr | 9970564 | 3 | libzstd | 19.08 | 32.19 | 1.69 | 86.77 |
| silesia/mr | 9970564 | 3 | stdx | 32.72 | 72.46 | 2.21 | 115.72 |
| silesia/nci | 33553445 | 1 | libzstd | 3.45 | 9.55 | 2.77 | 57.16 |
| silesia/nci | 33553445 | 1 | stdx | 7.65 | 25.69 | 3.36 | 60.17 |
| silesia/nci | 33553445 | 3 | libzstd | 5.23 | 9.95 | 1.90 | 56.47 |
| silesia/nci | 33553445 | 3 | stdx | 11.15 | 29.15 | 2.62 | 67.18 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.50 | 29.26 | 3.44 | 72.62 |
| silesia/ooffice | 6152192 | 1 | stdx | 22.87 | 72.51 | 3.17 | 181.18 |
| silesia/ooffice | 6152192 | 3 | libzstd | 22.52 | 39.44 | 1.75 | 119.93 |
| silesia/ooffice | 6152192 | 3 | stdx | 40.90 | 82.20 | 2.01 | 186.99 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.02 | 22.29 | 3.18 | 66.64 |
| silesia/osdb | 10085684 | 1 | stdx | 16.29 | 50.52 | 3.10 | 122.63 |
| silesia/osdb | 10085684 | 3 | libzstd | 17.01 | 26.23 | 1.54 | 67.82 |
| silesia/osdb | 10085684 | 3 | stdx | 31.03 | 57.87 | 1.87 | 111.77 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.65 | 27.13 | 2.81 | 150.40 |
| silesia/reymont | 6627202 | 1 | stdx | 20.02 | 72.05 | 3.60 | 97.37 |
| silesia/reymont | 6627202 | 3 | libzstd | 17.61 | 27.10 | 1.54 | 126.29 |
| silesia/reymont | 6627202 | 3 | stdx | 27.41 | 62.18 | 2.27 | 147.26 |
| silesia/samba | 21606400 | 1 | libzstd | 5.85 | 16.88 | 2.89 | 85.34 |
| silesia/samba | 21606400 | 1 | stdx | 13.41 | 42.89 | 3.20 | 126.83 |
| silesia/samba | 21606400 | 3 | libzstd | 11.45 | 18.81 | 1.64 | 99.03 |
| silesia/samba | 21606400 | 3 | stdx | 19.93 | 44.75 | 2.25 | 134.35 |
| silesia/sao | 7251944 | 1 | libzstd | 9.00 | 33.69 | 3.74 | 44.65 |
| silesia/sao | 7251944 | 1 | stdx | 25.74 | 82.03 | 3.19 | 105.36 |
| silesia/sao | 7251944 | 3 | libzstd | 29.71 | 50.03 | 1.68 | 95.87 |
| silesia/sao | 7251944 | 3 | stdx | 50.12 | 95.22 | 1.90 | 143.78 |
| silesia/webster | 41458703 | 1 | libzstd | 8.63 | 24.94 | 2.89 | 131.53 |
| silesia/webster | 41458703 | 1 | stdx | 20.26 | 64.04 | 3.16 | 167.53 |
| silesia/webster | 41458703 | 3 | libzstd | 18.42 | 27.33 | 1.48 | 177.05 |
| silesia/webster | 41458703 | 3 | stdx | 30.28 | 64.55 | 2.13 | 195.93 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.64 | 14.92 | 3.22 | 17.13 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.69 | 76.64 | 3.23 | 93.51 |
| silesia/x-ray | 8474240 | 3 | libzstd | 30.36 | 52.73 | 1.74 | 87.80 |
| silesia/x-ray | 8474240 | 3 | stdx | 46.38 | 92.40 | 1.99 | 106.36 |
| silesia/xml | 5345280 | 1 | libzstd | 4.19 | 11.71 | 2.80 | 71.37 |
| silesia/xml | 5345280 | 1 | stdx | 10.25 | 34.21 | 3.34 | 95.13 |
| silesia/xml | 5345280 | 3 | libzstd | 6.48 | 12.61 | 1.95 | 77.24 |
| silesia/xml | 5345280 | 3 | stdx | 12.51 | 32.28 | 2.58 | 116.39 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.76 | 32.84 | 3.05 | 139.08 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.34 | 76.49 | 3.42 | 190.89 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.76 | 39.48 | 2.51 | 203.22 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.32 | 73.76 | 2.80 | 339.44 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.72 | 33.55 | 3.45 | 102.88 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.55 | 79.00 | 3.35 | 219.96 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.21 | 39.27 | 2.58 | 209.54 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.13 | 79.30 | 2.82 | 379.84 |
| canterbury/cp.html | 24603 | 1 | libzstd | 7.02 | 26.64 | 3.80 | 42.08 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.18 | 57.76 | 3.57 | 125.15 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.59 | 31.85 | 3.32 | 48.01 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.55 | 59.76 | 3.22 | 153.95 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.76 | 31.76 | 3.63 | 45.75 |
| canterbury/fields.c | 11150 | 1 | stdx | 16.99 | 65.73 | 3.87 | 88.74 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.33 | 34.14 | 3.66 | 27.90 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.60 | 64.68 | 3.67 | 100.10 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.38 | 38.01 | 4.05 | 7.65 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.23 | 77.57 | 3.83 | 52.41 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.65 | 43.09 | 4.05 | 8.08 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.53 | 79.60 | 3.70 | 69.93 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 5.99 | 23.56 | 3.93 | 14.54 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.67 | 56.75 | 3.87 | 86.97 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.27 | 23.80 | 2.88 | 27.46 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 20.03 | 56.61 | 2.83 | 111.00 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.80 | 28.52 | 2.91 | 155.83 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.40 | 72.02 | 3.37 | 162.62 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 16.28 | 32.14 | 1.97 | 202.96 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.19 | 67.10 | 2.56 | 298.81 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.31 | 32.37 | 3.14 | 128.45 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.02 | 84.16 | 3.36 | 161.28 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 20.00 | 38.77 | 1.94 | 227.27 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 31.56 | 80.77 | 2.56 | 347.53 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.16 | 8.51 | 2.70 | 67.17 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.53 | 23.15 | 3.07 | 106.59 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 4.80 | 10.97 | 2.29 | 58.64 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.34 | 24.08 | 2.58 | 134.46 |
| canterbury/sum | 38240 | 1 | libzstd | 6.58 | 25.39 | 3.86 | 34.60 |
| canterbury/sum | 38240 | 1 | stdx | 16.97 | 59.13 | 3.48 | 155.21 |
| canterbury/sum | 38240 | 3 | libzstd | 9.26 | 30.67 | 3.31 | 47.60 |
| canterbury/sum | 38240 | 3 | stdx | 20.02 | 61.82 | 3.09 | 191.74 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 9.99 | 39.82 | 3.99 | 13.73 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.88 | 80.38 | 3.85 | 60.82 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.18 | 48.17 | 3.95 | 15.15 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.96 | 83.98 | 3.66 | 81.29 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.31 | 33.44 | 3.25 | 76.29 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.68 | 95.62 | 4.41 | 7.18 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 15.02 | 31.30 | 2.08 | 35.90 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.24 | 70.38 | 3.03 | 38.28 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.66 | 27.45 | 2.84 | 148.74 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.20 | 71.86 | 3.56 | 108.71 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 17.55 | 28.20 | 1.61 | 133.16 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 27.39 | 63.36 | 2.31 | 155.67 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.10 | 22.70 | 2.80 | 136.51 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.54 | 55.86 | 3.01 | 194.65 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 15.04 | 23.87 | 1.59 | 173.79 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 24.53 | 51.26 | 2.09 | 238.78 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.01 | 52.46 | 3.08 | 159.55 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.68 | 100.54 | 2.82 | 643.37 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 18.99 | 59.20 | 3.12 | 198.28 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 38.23 | 104.00 | 2.72 | 643.44 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.69 | 22.46 | 2.92 | 122.28 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.11 | 46.84 | 3.32 | 184.48 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.77 | 24.61 | 2.81 | 143.88 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.38 | 47.61 | 3.10 | 194.09 |
| http/html-1m | 1048576 | 1 | libzstd | 6.21 | 16.74 | 2.69 | 114.52 |
| http/html-1m | 1048576 | 1 | stdx | 12.85 | 42.00 | 3.27 | 135.84 |
| http/html-1m | 1048576 | 3 | libzstd | 9.19 | 18.18 | 1.98 | 125.24 |
| http/html-1m | 1048576 | 3 | stdx | 15.54 | 39.37 | 2.53 | 178.50 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.28 | 42.52 | 2.98 | 116.34 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.47 | 83.13 | 2.82 | 538.63 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.74 | 44.54 | 3.02 | 128.65 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.80 | 84.87 | 2.76 | 543.08 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.78 | 14.98 | 3.14 | 57.58 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.67 | 33.78 | 3.49 | 117.61 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.33 | 16.21 | 3.04 | 72.37 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.55 | 34.58 | 3.28 | 124.32 |
| http/json-1m | 1048576 | 1 | libzstd | 4.02 | 12.55 | 3.13 | 52.36 |
| http/json-1m | 1048576 | 1 | stdx | 8.98 | 30.70 | 3.42 | 87.05 |
| http/json-1m | 1048576 | 3 | libzstd | 6.11 | 13.78 | 2.26 | 68.57 |
| http/json-1m | 1048576 | 3 | stdx | 11.27 | 30.64 | 2.72 | 121.22 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.49 | 57.26 | 3.10 | 184.51 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 39.76 | 113.49 | 2.85 | 699.65 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.31 | 65.54 | 3.08 | 258.98 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.22 | 116.54 | 2.76 | 692.18 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.82 | 26.52 | 3.01 | 127.52 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.56 | 55.71 | 3.36 | 203.02 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.09 | 28.74 | 2.85 | 156.68 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.70 | 55.35 | 3.13 | 212.41 |
| http/js-1m | 1048576 | 1 | libzstd | 6.53 | 17.87 | 2.74 | 113.61 |
| http/js-1m | 1048576 | 1 | stdx | 13.89 | 45.88 | 3.30 | 137.89 |
| http/js-1m | 1048576 | 3 | libzstd | 9.86 | 19.14 | 1.94 | 124.87 |
| http/js-1m | 1048576 | 3 | stdx | 16.77 | 41.25 | 2.46 | 188.22 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.51 | 46.90 | 3.02 | 137.02 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.18 | 91.65 | 2.85 | 583.33 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.55 | 50.53 | 3.05 | 158.35 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.75 | 93.63 | 2.77 | 587.85 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.11 | 18.99 | 3.11 | 79.05 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.38 | 43.79 | 3.54 | 139.10 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.54 | 19.41 | 2.97 | 94.91 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.87 | 42.34 | 3.29 | 154.74 |
| http/css-1m | 1048576 | 1 | libzstd | 1.49 | 4.59 | 3.09 | 21.75 |
| http/css-1m | 1048576 | 1 | stdx | 3.98 | 14.85 | 3.73 | 30.62 |
| http/css-1m | 1048576 | 3 | libzstd | 1.95 | 5.25 | 2.69 | 19.72 |
| http/css-1m | 1048576 | 3 | stdx | 3.94 | 13.33 | 3.38 | 31.93 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.50 | 12.79 | 3.66 | 6.24 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.10 | 30.66 | 3.37 | 62.95 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 27.00 | 50.53 | 1.87 | 49.32 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 20.67 | 47.43 | 2.29 | 212.39 |

## Hardware counters per input octet, brotli encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | Google q1 | 18.55 | 30.24 | 1.63 | 232.28 |
| silesia/dickens | 10192446 | stdx 1 | 19.39 | 43.43 | 2.24 | 412.81 |
| silesia/dickens | 10192446 | Google q5 | 104.29 | 194.36 | 1.86 | 821.84 |
| silesia/dickens | 10192446 | stdx 5 | 70.82 | 155.43 | 2.19 | 986.31 |
| silesia/mozilla | 51220480 | Google q1 | 13.37 | 25.26 | 1.89 | 145.15 |
| silesia/mozilla | 51220480 | stdx 1 | 12.32 | 32.95 | 2.67 | 213.51 |
| silesia/mozilla | 51220480 | Google q5 | 62.70 | 149.30 | 2.38 | 799.54 |
| silesia/mozilla | 51220480 | stdx 5 | 58.95 | 148.04 | 2.51 | 814.43 |
| silesia/mr | 9970564 | Google q1 | 13.39 | 26.14 | 1.95 | 97.82 |
| silesia/mr | 9970564 | stdx 1 | 13.70 | 37.80 | 2.76 | 165.31 |
| silesia/mr | 9970564 | Google q5 | 82.17 | 177.41 | 2.16 | 607.39 |
| silesia/mr | 9970564 | stdx 5 | 65.97 | 149.01 | 2.26 | 703.24 |
| silesia/nci | 33553445 | Google q1 | 5.21 | 9.71 | 1.86 | 89.09 |
| silesia/nci | 33553445 | stdx 1 | 6.07 | 14.48 | 2.39 | 127.82 |
| silesia/nci | 33553445 | Google q5 | 30.93 | 59.01 | 1.91 | 411.74 |
| silesia/nci | 33553445 | stdx 5 | 29.59 | 58.51 | 1.98 | 488.57 |
| silesia/ooffice | 6152192 | Google q1 | 18.08 | 33.43 | 1.85 | 154.99 |
| silesia/ooffice | 6152192 | stdx 1 | 16.75 | 45.85 | 2.74 | 266.55 |
| silesia/ooffice | 6152192 | Google q5 | 89.16 | 198.80 | 2.23 | 1067.86 |
| silesia/ooffice | 6152192 | stdx 5 | 72.92 | 178.18 | 2.44 | 1075.23 |
| silesia/osdb | 10085684 | Google q1 | 12.81 | 23.47 | 1.83 | 83.97 |
| silesia/osdb | 10085684 | stdx 1 | 11.60 | 32.00 | 2.76 | 141.56 |
| silesia/osdb | 10085684 | Google q5 | 68.71 | 146.01 | 2.12 | 547.91 |
| silesia/osdb | 10085684 | stdx 5 | 52.37 | 123.53 | 2.36 | 522.43 |
| silesia/reymont | 6627202 | Google q1 | 15.44 | 25.54 | 1.65 | 208.61 |
| silesia/reymont | 6627202 | stdx 1 | 14.44 | 33.36 | 2.31 | 283.25 |
| silesia/reymont | 6627202 | Google q5 | 80.84 | 169.16 | 2.09 | 801.97 |
| silesia/reymont | 6627202 | stdx 5 | 62.71 | 139.71 | 2.23 | 905.26 |
| silesia/samba | 21606400 | Google q1 | 9.93 | 17.38 | 1.75 | 127.89 |
| silesia/samba | 21606400 | stdx 1 | 9.90 | 23.94 | 2.42 | 197.26 |
| silesia/samba | 21606400 | Google q5 | 47.66 | 105.54 | 2.21 | 480.42 |
| silesia/samba | 21606400 | stdx 5 | 42.78 | 102.32 | 2.39 | 530.30 |
| silesia/sao | 7251944 | Google q1 | 21.91 | 39.96 | 1.82 | 101.06 |
| silesia/sao | 7251944 | stdx 1 | 18.77 | 55.66 | 2.97 | 190.39 |
| silesia/sao | 7251944 | Google q5 | 111.77 | 259.63 | 2.32 | 933.90 |
| silesia/sao | 7251944 | stdx 5 | 86.34 | 229.67 | 2.66 | 754.59 |
| silesia/webster | 41458703 | Google q1 | 14.84 | 24.40 | 1.64 | 209.05 |
| silesia/webster | 41458703 | stdx 1 | 15.29 | 34.12 | 2.23 | 338.99 |
| silesia/webster | 41458703 | Google q5 | 76.11 | 141.82 | 1.86 | 755.77 |
| silesia/webster | 41458703 | stdx 5 | 61.35 | 121.03 | 1.97 | 852.44 |
| silesia/x-ray | 8474240 | Google q1 | 13.87 | 22.03 | 1.59 | 12.45 |
| silesia/x-ray | 8474240 | stdx 1 | 13.10 | 38.68 | 2.95 | 95.42 |
| silesia/x-ray | 8474240 | Google q5 | 103.18 | 236.76 | 2.29 | 724.30 |
| silesia/x-ray | 8474240 | stdx 5 | 83.28 | 226.78 | 2.72 | 645.21 |
| silesia/xml | 5345280 | Google q1 | 7.04 | 12.28 | 1.74 | 114.07 |
| silesia/xml | 5345280 | stdx 1 | 7.28 | 17.44 | 2.39 | 153.57 |
| silesia/xml | 5345280 | Google q5 | 31.76 | 72.50 | 2.28 | 359.37 |
| silesia/xml | 5345280 | stdx 5 | 28.99 | 64.66 | 2.23 | 411.91 |
| canterbury/alice29.txt | 152089 | Google q1 | 16.74 | 29.72 | 1.78 | 208.57 |
| canterbury/alice29.txt | 152089 | stdx 1 | 18.33 | 40.79 | 2.23 | 446.56 |
| canterbury/alice29.txt | 152089 | Google q5 | 79.20 | 200.77 | 2.54 | 1040.92 |
| canterbury/alice29.txt | 152089 | stdx 5 | 67.10 | 150.37 | 2.24 | 909.84 |
| canterbury/asyoulik.txt | 125179 | Google q1 | 18.07 | 32.37 | 1.79 | 224.36 |
| canterbury/asyoulik.txt | 125179 | stdx 1 | 20.06 | 44.50 | 2.22 | 498.63 |
| canterbury/asyoulik.txt | 125179 | Google q5 | 84.71 | 215.27 | 2.54 | 1078.34 |
| canterbury/asyoulik.txt | 125179 | stdx 5 | 74.07 | 162.29 | 2.19 | 1049.67 |
| canterbury/cp.html | 24603 | Google q1 | 12.73 | 27.30 | 2.14 | 96.19 |
| canterbury/cp.html | 24603 | stdx 1 | 14.67 | 36.07 | 2.46 | 353.58 |
| canterbury/cp.html | 24603 | Google q5 | 61.56 | 163.89 | 2.66 | 950.72 |
| canterbury/cp.html | 24603 | stdx 5 | 56.64 | 131.75 | 2.33 | 732.33 |
| canterbury/fields.c | 11150 | Google q1 | 11.85 | 29.04 | 2.45 | 12.31 |
| canterbury/fields.c | 11150 | stdx 1 | 10.61 | 38.87 | 3.66 | 90.91 |
| canterbury/fields.c | 11150 | Google q5 | 59.52 | 168.16 | 2.83 | 905.45 |
| canterbury/fields.c | 11150 | stdx 5 | 44.22 | 123.30 | 2.79 | 558.23 |
| canterbury/grammar.lsp | 3721 | Google q1 | 14.22 | 39.39 | 2.77 | 8.17 |
| canterbury/grammar.lsp | 3721 | stdx 1 | 13.69 | 55.22 | 4.03 | 30.97 |
| canterbury/grammar.lsp | 3721 | Google q5 | 60.79 | 203.91 | 3.35 | 468.21 |
| canterbury/grammar.lsp | 3721 | stdx 5 | 41.24 | 148.73 | 3.61 | 141.96 |
| canterbury/kennedy.xls | 1029744 | Google q1 | 9.82 | 24.83 | 2.53 | 59.79 |
| canterbury/kennedy.xls | 1029744 | stdx 1 | 7.78 | 27.03 | 3.47 | 76.50 |
| canterbury/kennedy.xls | 1029744 | Google q5 | 47.05 | 162.91 | 3.46 | 262.57 |
| canterbury/kennedy.xls | 1029744 | stdx 5 | 51.49 | 162.45 | 3.16 | 475.17 |
| canterbury/lcet10.txt | 426754 | Google q1 | 16.15 | 27.19 | 1.68 | 201.61 |
| canterbury/lcet10.txt | 426754 | stdx 1 | 16.78 | 37.84 | 2.25 | 379.19 |
| canterbury/lcet10.txt | 426754 | Google q5 | 77.10 | 187.58 | 2.43 | 958.09 |
| canterbury/lcet10.txt | 426754 | stdx 5 | 64.12 | 140.50 | 2.19 | 910.22 |
| canterbury/plrabn12.txt | 481861 | Google q1 | 18.88 | 32.57 | 1.72 | 250.50 |
| canterbury/plrabn12.txt | 481861 | stdx 1 | 20.84 | 46.66 | 2.24 | 473.86 |
| canterbury/plrabn12.txt | 481861 | Google q5 | 94.90 | 229.77 | 2.42 | 1064.76 |
| canterbury/plrabn12.txt | 481861 | stdx 5 | 80.10 | 168.65 | 2.11 | 1189.97 |
| canterbury/ptt5 | 513216 | Google q1 | 4.96 | 9.55 | 1.93 | 80.46 |
| canterbury/ptt5 | 513216 | stdx 1 | 6.64 | 15.64 | 2.36 | 160.27 |
| canterbury/ptt5 | 513216 | Google q5 | 27.32 | 68.87 | 2.52 | 468.16 |
| canterbury/ptt5 | 513216 | stdx 5 | 29.47 | 69.96 | 2.37 | 468.43 |
| canterbury/sum | 38240 | Google q1 | 12.56 | 29.25 | 2.33 | 84.65 |
| canterbury/sum | 38240 | stdx 1 | 15.43 | 36.37 | 2.36 | 397.94 |
| canterbury/sum | 38240 | Google q5 | 65.77 | 182.58 | 2.78 | 1097.49 |
| canterbury/sum | 38240 | stdx 5 | 64.18 | 159.26 | 2.48 | 844.88 |
| canterbury/xargs.1 | 4227 | Google q1 | 16.10 | 43.16 | 2.68 | 14.64 |
| canterbury/xargs.1 | 4227 | stdx 1 | 14.99 | 59.10 | 3.94 | 49.23 |
| canterbury/xargs.1 | 4227 | Google q5 | 70.49 | 219.02 | 3.11 | 776.29 |
| canterbury/xargs.1 | 4227 | stdx 5 | 48.33 | 159.53 | 3.30 | 250.36 |
| canterbury-large/E.coli | 4638690 | Google q1 | 13.50 | 27.46 | 2.03 | 53.38 |
| canterbury-large/E.coli | 4638690 | stdx 1 | 5.57 | 19.24 | 3.45 | 17.98 |
| canterbury-large/E.coli | 4638690 | Google q5 | 89.89 | 262.67 | 2.92 | 993.35 |
| canterbury-large/E.coli | 4638690 | stdx 5 | 31.68 | 93.28 | 2.94 | 64.59 |
| canterbury-large/bible.txt | 4047392 | Google q1 | 14.92 | 24.57 | 1.65 | 174.91 |
| canterbury-large/bible.txt | 4047392 | stdx 1 | 15.16 | 34.29 | 2.26 | 316.34 |
| canterbury-large/bible.txt | 4047392 | Google q5 | 80.82 | 165.65 | 2.05 | 733.79 |
| canterbury-large/bible.txt | 4047392 | stdx 5 | 58.98 | 134.16 | 2.27 | 807.90 |
| canterbury-large/world192.txt | 2473400 | Google q1 | 13.90 | 22.62 | 1.63 | 196.34 |
| canterbury-large/world192.txt | 2473400 | stdx 1 | 13.61 | 31.07 | 2.28 | 314.19 |
| canterbury-large/world192.txt | 2473400 | Google q5 | 69.77 | 129.46 | 1.86 | 744.63 |
| canterbury-large/world192.txt | 2473400 | stdx 5 | 53.24 | 105.07 | 1.97 | 774.48 |
| http/html-1kx1024 | 1048576 | Google q1 | 32.15 | 62.53 | 1.94 | 862.26 |
| http/html-1kx1024 | 1048576 | stdx 1 | 27.81 | 80.73 | 2.90 | 473.21 |
| http/html-1kx1024 | 1048576 | Google q5 | 105.92 | 260.90 | 2.46 | 2119.94 |
| http/html-1kx1024 | 1048576 | stdx 5 | 68.42 | 169.39 | 2.48 | 1181.58 |
| http/html-16kx64 | 1048576 | Google q1 | 11.14 | 20.38 | 1.83 | 215.32 |
| http/html-16kx64 | 1048576 | stdx 1 | 11.49 | 28.46 | 2.48 | 302.22 |
| http/html-16kx64 | 1048576 | Google q5 | 47.36 | 118.53 | 2.50 | 858.24 |
| http/html-16kx64 | 1048576 | stdx 5 | 40.71 | 92.79 | 2.28 | 668.38 |
| http/html-1m | 1048576 | Google q1 | 9.02 | 15.15 | 1.68 | 137.83 |
| http/html-1m | 1048576 | stdx 1 | 9.64 | 22.18 | 2.30 | 225.55 |
| http/html-1m | 1048576 | Google q5 | 46.21 | 104.93 | 2.27 | 576.40 |
| http/html-1m | 1048576 | stdx 5 | 36.68 | 84.09 | 2.29 | 544.45 |
| http/json-1kx1024 | 1048576 | Google q1 | 24.57 | 49.87 | 2.03 | 652.35 |
| http/json-1kx1024 | 1048576 | stdx 1 | 21.59 | 61.64 | 2.85 | 366.92 |
| http/json-1kx1024 | 1048576 | Google q5 | 78.86 | 203.15 | 2.58 | 1343.07 |
| http/json-1kx1024 | 1048576 | stdx 5 | 50.62 | 132.48 | 2.62 | 735.14 |
| http/json-16kx64 | 1048576 | Google q1 | 7.46 | 14.90 | 2.00 | 141.95 |
| http/json-16kx64 | 1048576 | stdx 1 | 7.06 | 19.73 | 2.80 | 159.03 |
| http/json-16kx64 | 1048576 | Google q5 | 36.24 | 97.81 | 2.70 | 558.47 |
| http/json-16kx64 | 1048576 | stdx 5 | 35.83 | 89.00 | 2.48 | 531.80 |
| http/json-1m | 1048576 | Google q1 | 6.17 | 12.65 | 2.05 | 91.79 |
| http/json-1m | 1048576 | stdx 1 | 6.62 | 17.21 | 2.60 | 139.95 |
| http/json-1m | 1048576 | Google q5 | 36.74 | 96.08 | 2.62 | 446.67 |
| http/json-1m | 1048576 | stdx 5 | 38.58 | 92.44 | 2.40 | 574.58 |
| http/js-1kx1024 | 1048576 | Google q1 | 34.73 | 68.18 | 1.96 | 903.63 |
| http/js-1kx1024 | 1048576 | stdx 1 | 30.89 | 90.40 | 2.93 | 531.04 |
| http/js-1kx1024 | 1048576 | Google q5 | 116.07 | 288.57 | 2.49 | 2301.02 |
| http/js-1kx1024 | 1048576 | stdx 5 | 77.42 | 188.24 | 2.43 | 1320.53 |
| http/js-16kx64 | 1048576 | Google q1 | 12.97 | 24.07 | 1.86 | 231.36 |
| http/js-16kx64 | 1048576 | stdx 1 | 13.36 | 32.69 | 2.45 | 353.98 |
| http/js-16kx64 | 1048576 | Google q5 | 55.59 | 141.15 | 2.54 | 997.60 |
| http/js-16kx64 | 1048576 | stdx 5 | 47.24 | 107.16 | 2.27 | 787.35 |
| http/js-1m | 1048576 | Google q1 | 9.84 | 16.69 | 1.70 | 141.17 |
| http/js-1m | 1048576 | stdx 1 | 10.13 | 23.55 | 2.33 | 229.23 |
| http/js-1m | 1048576 | Google q5 | 51.60 | 116.02 | 2.25 | 637.26 |
| http/js-1m | 1048576 | stdx 5 | 39.04 | 90.08 | 2.31 | 589.95 |
| http/css-1kx1024 | 1048576 | Google q1 | 27.55 | 54.06 | 1.96 | 731.31 |
| http/css-1kx1024 | 1048576 | stdx 1 | 24.22 | 68.32 | 2.82 | 433.15 |
| http/css-1kx1024 | 1048576 | Google q5 | 85.85 | 213.92 | 2.49 | 1650.45 |
| http/css-1kx1024 | 1048576 | stdx 5 | 54.28 | 139.00 | 2.56 | 907.29 |
| http/css-16kx64 | 1048576 | Google q1 | 8.82 | 16.85 | 1.91 | 140.82 |
| http/css-16kx64 | 1048576 | stdx 1 | 8.50 | 23.62 | 2.78 | 192.24 |
| http/css-16kx64 | 1048576 | Google q5 | 37.64 | 100.68 | 2.67 | 646.55 |
| http/css-16kx64 | 1048576 | stdx 5 | 31.64 | 81.52 | 2.58 | 495.12 |
| http/css-1m | 1048576 | Google q1 | 5.93 | 11.27 | 1.90 | 76.06 |
| http/css-1m | 1048576 | stdx 1 | 5.43 | 14.38 | 2.65 | 110.54 |
| http/css-1m | 1048576 | Google q5 | 14.44 | 38.50 | 2.67 | 129.73 |
| http/css-1m | 1048576 | stdx 5 | 14.21 | 36.87 | 2.59 | 111.41 |
| shuffled/dickens-1m | 1048576 | Google q1 | 11.37 | 20.96 | 1.84 | 2.79 |
| shuffled/dickens-1m | 1048576 | stdx 1 | 5.33 | 19.75 | 3.70 | 16.72 |
| shuffled/dickens-1m | 1048576 | Google q5 | 99.80 | 235.57 | 2.36 | 724.08 |
| shuffled/dickens-1m | 1048576 | stdx 5 | 44.54 | 123.05 | 2.76 | 254.49 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.117 | 3.01 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 66.5 | 219.6 | 0.087 | 7.86 | 3.30 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 30.6 | 96.1 | 0.163 | 3.62 | 3.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextReader.next_items | 29.3 | 80.8 | 0.152 | 3.46 | 2.76 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 249.9 | 1024.0 | 0.830 | 29.52 | 4.10 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 31.0 | 107.7 | 0.134 | 3.66 | 3.47 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.0 | 106.2 | 0.298 | 3.31 | 3.79 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 93.1 | 378.2 | 0.383 | 10.99 | 4.06 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 43.0 | 161.9 | 0.476 | 5.08 | 3.76 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 90.6 | 451.7 | 0.301 | 10.70 | 4.98 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.0 | 89.5 | 0.004 | 3.97 | 3.32 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.4 | 234.7 | 0.041 | 10.07 | 3.43 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 29.2 | 99.4 | 0.011 | 4.29 | 3.41 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextReader.next_items | 28.2 | 84.2 | 0.008 | 4.15 | 2.99 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 214.1 | 819.1 | 0.967 | 31.51 | 3.83 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.4 | 107.7 | 0.039 | 4.17 | 3.80 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.3 | 106.0 | 0.046 | 4.17 | 3.74 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 92.1 | 346.2 | 0.332 | 13.56 | 3.76 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 32.1 | 144.5 | 0.051 | 4.73 | 4.49 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 90.2 | 406.5 | 0.085 | 13.28 | 4.50 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 41.6 | 96.3 | 0.198 | 3.89 | 2.32 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 86.7 | 249.4 | 0.232 | 8.12 | 2.88 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 45.6 | 113.8 | 0.284 | 4.27 | 2.50 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextReader.next_items | 44.3 | 99.4 | 0.215 | 4.15 | 2.24 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 313.6 | 1284.6 | 1.085 | 29.37 | 4.10 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 36.3 | 133.1 | 0.183 | 3.40 | 3.66 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 46.3 | 128.6 | 0.735 | 4.33 | 2.78 |
| messages: 11 string members | 96000 | 1025025 | std.json | 120.8 | 451.2 | 1.066 | 11.31 | 3.74 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 67.4 | 204.1 | 1.010 | 6.31 | 3.03 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 134.4 | 572.0 | 0.836 | 12.58 | 4.26 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 24.3 | 78.8 | 0.021 | 3.04 | 3.25 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 67.5 | 239.5 | 0.006 | 8.45 | 3.55 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 27.9 | 93.3 | 0.043 | 3.49 | 3.35 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextReader.next_items | 26.9 | 78.0 | 0.033 | 3.37 | 2.90 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 232.3 | 942.3 | 0.401 | 29.07 | 4.06 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 28.1 | 107.6 | 0.043 | 3.52 | 3.83 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 25.5 | 104.8 | 0.022 | 3.19 | 4.11 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 87.3 | 361.0 | 0.170 | 10.93 | 4.13 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 32.2 | 151.6 | 0.034 | 4.03 | 4.71 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 80.7 | 418.2 | 0.008 | 10.10 | 5.18 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114512.3 | 403846.2 | 508.526 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 593429.7 | 2503286.2 | 1390.629 | 3.44 | 4.22 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 114181.1 | 404249.2 | 488.155 | 0.66 | 3.54 |
| string: silesia/dickens | 1 | 172528 | stdx, TextReader.next_items | 114363.1 | 404282.2 | 483.990 | 0.66 | 3.54 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3564038.0 | 18223876.2 | 2977.454 | 20.66 | 5.11 |
| string: silesia/dickens | 1 | 172528 | simdjson | 310989.8 | 621744.2 | 579.000 | 1.80 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 224770.5 | 826630.2 | 2263.351 | 1.30 | 3.68 |
| string: silesia/dickens | 1 | 172528 | std.json | 1563887.4 | 4578768.3 | 43020.031 | 9.06 | 2.93 |
| string: silesia/dickens | 1 | 172528 | serde_json | 204794.2 | 802909.2 | 995.289 | 1.19 | 3.92 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1043829.7 | 5281612.6 | 4939.206 | 6.05 | 5.06 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1565742.1 | 4799769.6 | 1493.429 | 1.32 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14834808.1 | 56410893.6 | 45066.929 | 12.46 | 3.80 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1560558.1 | 4799955.6 | 1164.929 | 1.31 | 3.08 |
| string: http/json-1m | 1 | 1190272 | stdx, TextReader.next_items | 1558923.7 | 4799988.6 | 1120.857 | 1.31 | 3.08 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 28804673.1 | 132108259.6 | 159482.500 | 24.20 | 4.59 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4585309.9 | 7062781.6 | 518.429 | 3.85 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1775744.5 | 7322029.6 | 13990.143 | 1.49 | 4.12 |
| string: http/json-1m | 1 | 1190272 | std.json | 10368172.5 | 47381157.6 | 32347.357 | 8.71 | 4.57 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3892024.9 | 15226584.6 | 6235.429 | 3.27 | 3.91 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 8947618.2 | 47987153.1 | 27997.429 | 7.52 | 5.36 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2066559.5 | 5765419.8 | 4322.875 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6216157.5 | 22538840.8 | 6975.125 | 3.30 | 3.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2060098.3 | 5765605.8 | 3796.250 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextReader.next_items | 2058205.8 | 5765638.8 | 3677.000 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47139380.6 | 227842326.8 | 254771.375 | 25.03 | 4.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3765537.5 | 8446023.8 | 1943.750 | 2.00 | 2.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7113754.3 | 12276717.8 | 275802.750 | 3.78 | 1.73 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17416453.1 | 63617055.8 | 286081.875 | 9.25 | 3.65 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9500042.0 | 24440998.8 | 336368.625 | 5.04 | 2.57 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39148909.6 | 160310395.1 | 797814.500 | 20.79 | 4.09 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12923637.7 | 42561075.3 | 244423.667 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 173467993.0 | 666700955.3 | 392446.667 | 34.18 | 3.84 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12914346.0 | 42561261.3 | 244025.000 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextReader.next_items | 12879365.7 | 42561294.3 | 243197.667 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 151880109.0 | 639992668.3 | 424922.333 | 29.92 | 4.21 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17465460.3 | 49745820.3 | 247872.667 | 3.44 | 2.85 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 13986141.7 | 45615166.3 | 444034.667 | 2.76 | 3.26 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79772535.3 | 314900845.3 | 469229.667 | 15.72 | 3.95 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36264837.7 | 131556418.3 | 588976.000 | 7.15 | 3.63 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 65898243.3 | 273918600.3 | 833561.000 | 12.98 | 4.16 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 92554.4 | 303842.7 | 4.710 | 0.18 | 3.28 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 183193.6 | 623466.7 | 10.097 | 0.35 | 3.40 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 148057.3 | 557622.7 | 3.903 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextReader.next_items | 148346.7 | 557626.7 | 6.452 | 0.28 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10216673.1 | 53478208.7 | 8.871 | 19.49 | 5.23 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 488837.6 | 1376733.7 | 5.129 | 0.93 | 2.82 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 537176.7 | 2195917.7 | 6.774 | 1.02 | 4.09 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3327635.7 | 12808414.7 | 60654.355 | 6.35 | 3.85 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 295446.3 | 1179969.7 | 5.613 | 0.56 | 3.99 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2241476.0 | 12787036.1 | 230.710 | 4.28 | 5.70 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.3 | 81.8 | 0.108 | 2.28 | 4.23 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.1 | 153.5 | 0.136 | 4.15 | 4.37 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 21.2 | 93.4 | 0.093 | 2.50 | 4.41 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 218.0 | 981.0 | 0.921 | 25.76 | 4.50 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 18.6 | 79.5 | 0.104 | 2.20 | 4.27 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.0 | 94.1 | 0.136 | 2.71 | 4.10 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.3 | 105.6 | 0.246 | 3.23 | 3.87 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.0 | 310.8 | 0.362 | 8.15 | 4.51 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.8 | 255.3 | 0.523 | 7.54 | 4.00 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.1 | 315.1 | 0.232 | 8.04 | 4.63 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.4 | 82.8 | 0.024 | 2.70 | 4.51 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 35.8 | 153.9 | 0.025 | 5.28 | 4.29 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 22.1 | 94.2 | 0.024 | 3.25 | 4.27 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 170.6 | 718.3 | 1.246 | 25.11 | 4.21 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 17.8 | 81.5 | 0.024 | 2.62 | 4.58 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.6 | 96.8 | 0.032 | 3.17 | 4.49 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.4 | 117.9 | 0.033 | 4.19 | 4.15 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.8 | 271.2 | 0.245 | 8.80 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 48.5 | 213.2 | 0.039 | 7.13 | 4.40 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 83.9 | 331.7 | 0.084 | 12.35 | 3.95 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 30.9 | 85.9 | 0.386 | 2.89 | 2.78 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 43.0 | 151.2 | 0.426 | 4.02 | 3.52 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 29.2 | 92.6 | 0.391 | 2.73 | 3.17 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 274.0 | 1195.0 | 1.148 | 25.66 | 4.36 |
| messages: 11 string members | 96000 | 1025025 | stdx, J11's loop unchecked | 28.9 | 82.8 | 0.387 | 2.70 | 2.87 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 38.1 | 119.1 | 0.591 | 3.57 | 3.12 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 46.1 | 138.2 | 0.664 | 4.32 | 3.00 |
| messages: 11 string members | 96000 | 1025025 | std.json | 99.8 | 370.8 | 1.080 | 9.35 | 3.71 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 88.4 | 315.4 | 0.785 | 8.28 | 3.57 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 106.6 | 400.7 | 0.855 | 9.98 | 3.76 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 19.7 | 80.2 | 0.007 | 2.47 | 4.07 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 37.8 | 152.5 | 0.006 | 4.73 | 4.04 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 22.3 | 93.2 | 0.006 | 2.79 | 4.18 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 196.0 | 866.7 | 0.742 | 24.54 | 4.42 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, J11's loop unchecked | 19.2 | 79.4 | 0.007 | 2.40 | 4.14 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 23.4 | 96.6 | 0.004 | 2.93 | 4.12 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 25.2 | 101.3 | 0.018 | 3.15 | 4.02 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 58.4 | 279.4 | 0.006 | 7.30 | 4.79 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 52.1 | 230.6 | 0.071 | 6.52 | 4.43 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 69.6 | 310.8 | 0.006 | 8.71 | 4.47 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 84593.6 | 280786.2 | 711.031 | 0.49 | 3.32 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84438.5 | 280732.2 | 705.711 | 0.49 | 3.32 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84428.5 | 280721.2 | 705.289 | 0.49 | 3.32 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3396804.3 | 16047574.2 | 2942.887 | 19.69 | 4.72 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 90548.2 | 274401.2 | 952.062 | 0.52 | 3.03 |
| string: silesia/dickens | 1 | 172528 | simdjson | 207534.5 | 674016.2 | 2043.031 | 1.20 | 3.25 |
| string: silesia/dickens | 1 | 172528 | yyjson | 204088.6 | 825518.2 | 1003.722 | 1.18 | 4.04 |
| string: silesia/dickens | 1 | 172528 | std.json | 1361146.2 | 2890892.2 | 55766.113 | 7.89 | 2.12 |
| string: silesia/dickens | 1 | 172528 | serde_json | 367729.4 | 1586249.2 | 2294.794 | 2.13 | 4.31 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 576530.3 | 2970251.9 | 2325.495 | 3.34 | 5.15 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1266013.6 | 3582350.6 | 11384.500 | 1.06 | 2.83 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1257873.4 | 3582290.6 | 11015.500 | 1.06 | 2.85 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1254102.4 | 3582277.6 | 10908.143 | 1.05 | 2.86 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25367018.4 | 109856348.6 | 142046.571 | 21.31 | 4.33 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1240755.1 | 3370022.6 | 11690.786 | 1.04 | 2.72 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2967959.6 | 10460762.6 | 29434.571 | 2.49 | 3.52 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2582421.6 | 10197931.6 | 9653.929 | 2.17 | 3.95 |
| string: http/json-1m | 1 | 1190272 | std.json | 8940717.9 | 43287986.6 | 17558.500 | 7.51 | 4.84 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3769292.4 | 17941088.6 | 10707.714 | 3.17 | 4.76 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5251487.9 | 26999452.4 | 11221.500 | 4.41 | 5.14 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2069527.3 | 6088099.8 | 4613.500 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2063215.4 | 6088043.8 | 4147.750 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2061108.4 | 6088026.8 | 4103.500 | 1.09 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43670740.4 | 193466553.8 | 270296.000 | 23.19 | 4.43 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2072705.0 | 5875346.8 | 4930.500 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2711209.4 | 7144143.8 | 20923.250 | 1.44 | 2.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12127379.3 | 23590602.8 | 447545.375 | 6.44 | 1.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20645135.4 | 56837736.8 | 558780.125 | 10.96 | 2.75 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11613999.5 | 33662338.8 | 330529.375 | 6.17 | 2.90 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18773246.1 | 76319246.5 | 250902.625 | 9.97 | 4.07 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113427.1 | 426376.7 | 3.484 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113194.1 | 426318.7 | 2.548 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113153.7 | 426305.7 | 2.677 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 635692.5 | 3146479.7 | 6.097 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113146.9 | 426343.7 | 2.968 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1200852.4 | 3866916.7 | 4.258 | 2.29 | 3.22 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1624656.3 | 5833341.7 | 4.516 | 3.10 | 3.59 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3528121.3 | 13108830.7 | 65114.484 | 6.73 | 3.72 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1784824.0 | 7405810.7 | 3.484 | 3.40 | 4.15 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2387729.7 | 12748182.9 | 12.774 | 4.55 | 5.34 |
