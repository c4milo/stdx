# bench-profile

| Field | Value |
|---|---|
| Commit | 308faec |
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
| silesia/dickens | 10192446 | zlib | 8.83 | 19.08 | 2.16 | 311.77 |
| silesia/dickens | 10192446 | zlib-ng | 4.88 | 10.50 | 2.15 | 67.64 |
| silesia/dickens | 10192446 | libdeflate | 3.46 | 9.56 | 2.77 | 66.71 |
| silesia/dickens | 10192446 | Wuffs | 5.54 | 13.90 | 2.51 | 97.48 |
| silesia/dickens | 10192446 | stdx | 2.92 | 7.15 | 2.45 | 75.85 |
| silesia/mozilla | 51220480 | zlib | 8.49 | 17.23 | 2.03 | 251.52 |
| silesia/mozilla | 51220480 | zlib-ng | 4.96 | 8.95 | 1.81 | 85.50 |
| silesia/mozilla | 51220480 | libdeflate | 3.49 | 7.63 | 2.18 | 71.04 |
| silesia/mozilla | 51220480 | Wuffs | 6.41 | 13.89 | 2.17 | 132.34 |
| silesia/mozilla | 51220480 | stdx | 3.66 | 6.29 | 1.72 | 89.77 |
| silesia/mr | 9970564 | zlib | 8.39 | 18.46 | 2.20 | 201.58 |
| silesia/mr | 9970564 | zlib-ng | 4.80 | 9.98 | 2.08 | 67.88 |
| silesia/mr | 9970564 | libdeflate | 3.36 | 8.58 | 2.56 | 61.10 |
| silesia/mr | 9970564 | Wuffs | 6.00 | 14.04 | 2.34 | 99.41 |
| silesia/mr | 9970564 | stdx | 3.09 | 6.70 | 2.17 | 70.12 |
| silesia/nci | 33553445 | zlib | 3.57 | 10.18 | 2.85 | 80.82 |
| silesia/nci | 33553445 | zlib-ng | 1.61 | 3.13 | 1.95 | 33.67 |
| silesia/nci | 33553445 | libdeflate | 1.12 | 2.66 | 2.36 | 27.57 |
| silesia/nci | 33553445 | Wuffs | 2.46 | 6.47 | 2.63 | 41.11 |
| silesia/nci | 33553445 | stdx | 1.20 | 2.20 | 1.83 | 37.41 |
| silesia/ooffice | 6152192 | zlib | 11.78 | 21.06 | 1.79 | 418.04 |
| silesia/ooffice | 6152192 | zlib-ng | 7.00 | 12.04 | 1.72 | 141.56 |
| silesia/ooffice | 6152192 | libdeflate | 5.00 | 10.45 | 2.09 | 125.23 |
| silesia/ooffice | 6152192 | Wuffs | 8.92 | 17.54 | 1.97 | 219.69 |
| silesia/ooffice | 6152192 | stdx | 5.31 | 8.55 | 1.61 | 151.12 |
| silesia/osdb | 10085684 | zlib | 7.45 | 16.59 | 2.23 | 181.38 |
| silesia/osdb | 10085684 | zlib-ng | 4.30 | 8.38 | 1.95 | 53.27 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.91 | 2.43 | 29.83 |
| silesia/osdb | 10085684 | Wuffs | 5.76 | 13.61 | 2.36 | 74.97 |
| silesia/osdb | 10085684 | stdx | 2.78 | 5.65 | 2.04 | 40.79 |
| silesia/reymont | 6627202 | zlib | 7.42 | 15.89 | 2.14 | 262.48 |
| silesia/reymont | 6627202 | zlib-ng | 3.71 | 7.72 | 2.08 | 59.81 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.16 |
| silesia/reymont | 6627202 | Wuffs | 4.89 | 11.40 | 2.33 | 112.93 |
| silesia/reymont | 6627202 | stdx | 2.29 | 5.11 | 2.23 | 64.52 |
| silesia/samba | 21606400 | zlib | 6.19 | 14.13 | 2.28 | 175.59 |
| silesia/samba | 21606400 | zlib-ng | 3.38 | 6.47 | 1.92 | 55.88 |
| silesia/samba | 21606400 | libdeflate | 2.37 | 5.58 | 2.35 | 42.96 |
| silesia/samba | 21606400 | Wuffs | 4.34 | 10.39 | 2.39 | 79.62 |
| silesia/samba | 21606400 | stdx | 2.35 | 4.46 | 1.90 | 56.43 |
| silesia/sao | 7251944 | zlib | 10.50 | 23.54 | 2.24 | 203.35 |
| silesia/sao | 7251944 | zlib-ng | 7.86 | 14.83 | 1.89 | 79.52 |
| silesia/sao | 7251944 | libdeflate | 5.74 | 12.73 | 2.22 | 78.97 |
| silesia/sao | 7251944 | Wuffs | 8.86 | 21.26 | 2.40 | 84.21 |
| silesia/sao | 7251944 | stdx | 5.58 | 10.32 | 1.85 | 88.66 |
| silesia/webster | 41458703 | zlib | 7.82 | 16.16 | 2.07 | 282.01 |
| silesia/webster | 41458703 | zlib-ng | 4.23 | 8.04 | 1.90 | 85.24 |
| silesia/webster | 41458703 | libdeflate | 2.89 | 7.17 | 2.48 | 68.41 |
| silesia/webster | 41458703 | Wuffs | 5.15 | 11.67 | 2.27 | 122.50 |
| silesia/webster | 41458703 | stdx | 2.82 | 5.56 | 1.97 | 86.94 |
| silesia/x-ray | 8474240 | zlib | 12.83 | 27.21 | 2.12 | 326.40 |
| silesia/x-ray | 8474240 | zlib-ng | 9.02 | 17.39 | 1.93 | 124.12 |
| silesia/x-ray | 8474240 | libdeflate | 6.54 | 15.26 | 2.33 | 124.29 |
| silesia/x-ray | 8474240 | Wuffs | 10.80 | 23.52 | 2.18 | 189.36 |
| silesia/x-ray | 8474240 | stdx | 6.12 | 11.49 | 1.88 | 139.27 |
| silesia/xml | 5345280 | zlib | 4.24 | 11.16 | 2.63 | 118.29 |
| silesia/xml | 5345280 | zlib-ng | 1.99 | 3.88 | 1.95 | 42.76 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 31.56 |
| silesia/xml | 5345280 | Wuffs | 2.84 | 7.22 | 2.54 | 58.92 |
| silesia/xml | 5345280 | stdx | 1.33 | 2.65 | 1.99 | 41.92 |
| canterbury/alice29.txt | 152089 | zlib | 8.44 | 18.35 | 2.17 | 294.82 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.51 | 9.91 | 2.20 | 59.87 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.20 | 8.96 | 2.80 | 56.43 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.39 | 13.40 | 2.49 | 98.64 |
| canterbury/alice29.txt | 152089 | stdx | 2.73 | 6.99 | 2.56 | 64.64 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.04 | 19.42 | 2.15 | 315.58 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.09 | 10.86 | 2.13 | 73.37 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.62 | 9.82 | 2.71 | 70.17 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.76 | 14.40 | 2.50 | 100.03 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.04 | 7.52 | 2.47 | 76.22 |
| canterbury/cp.html | 24603 | zlib | 7.07 | 17.33 | 2.45 | 172.06 |
| canterbury/cp.html | 24603 | zlib-ng | 4.16 | 9.50 | 2.28 | 35.71 |
| canterbury/cp.html | 24603 | libdeflate | 2.89 | 7.95 | 2.75 | 18.42 |
| canterbury/cp.html | 24603 | Wuffs | 5.13 | 13.91 | 2.71 | 54.64 |
| canterbury/cp.html | 24603 | stdx | 2.66 | 7.19 | 2.71 | 13.64 |
| canterbury/fields.c | 11150 | zlib | 5.26 | 17.73 | 3.37 | 37.83 |
| canterbury/fields.c | 11150 | zlib-ng | 3.87 | 10.20 | 2.64 | 14.02 |
| canterbury/fields.c | 11150 | libdeflate | 2.80 | 8.32 | 2.97 | 0.98 |
| canterbury/fields.c | 11150 | Wuffs | 4.51 | 14.54 | 3.22 | 9.18 |
| canterbury/fields.c | 11150 | stdx | 2.50 | 7.64 | 3.05 | 4.59 |
| canterbury/grammar.lsp | 3721 | zlib | 6.87 | 24.26 | 3.53 | 4.19 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.81 | 17.48 | 3.01 | 6.61 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.50 | 12.05 | 2.68 | 1.11 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.69 | 21.86 | 3.27 | 4.19 |
| canterbury/grammar.lsp | 3721 | stdx | 3.85 | 12.18 | 3.16 | 1.59 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.59 | 15.27 | 3.33 | 48.42 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.61 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.38 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.86 | 11.59 | 3.00 | 14.74 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.74 | 4.66 | 2.68 | 16.74 |
| canterbury/lcet10.txt | 426754 | zlib | 8.26 | 17.78 | 2.15 | 295.21 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.17 | 61.07 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.33 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.22 | 12.88 | 2.47 | 101.09 |
| canterbury/lcet10.txt | 426754 | stdx | 2.58 | 6.42 | 2.48 | 66.48 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.20 | 19.86 | 2.16 | 320.97 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.30 | 11.19 | 2.11 | 79.83 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.76 | 10.19 | 2.71 | 76.28 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.81 | 14.61 | 2.52 | 98.81 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 7.63 | 2.41 | 85.05 |
| canterbury/ptt5 | 513216 | zlib | 5.05 | 10.71 | 2.12 | 103.42 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.00 | 3.74 | 1.87 | 47.17 |
| canterbury/ptt5 | 513216 | libdeflate | 1.44 | 3.02 | 2.09 | 37.65 |
| canterbury/ptt5 | 513216 | Wuffs | 3.01 | 7.13 | 2.37 | 57.89 |
| canterbury/ptt5 | 513216 | stdx | 1.44 | 2.55 | 1.77 | 48.90 |
| canterbury/sum | 38240 | zlib | 8.06 | 18.12 | 2.25 | 227.31 |
| canterbury/sum | 38240 | zlib-ng | 4.65 | 10.02 | 2.15 | 56.72 |
| canterbury/sum | 38240 | libdeflate | 3.38 | 8.34 | 2.47 | 39.77 |
| canterbury/sum | 38240 | Wuffs | 5.78 | 14.47 | 2.50 | 80.10 |
| canterbury/sum | 38240 | stdx | 3.04 | 7.73 | 2.55 | 29.48 |
| canterbury/xargs.1 | 4227 | zlib | 7.41 | 25.22 | 3.40 | 12.84 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.37 | 17.97 | 2.82 | 9.55 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.84 | 13.27 | 2.74 | 0.50 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.14 | 22.63 | 3.17 | 6.11 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 12.86 | 3.03 | 2.12 |
| canterbury-large/E.coli | 4638690 | zlib | 6.76 | 17.84 | 2.64 | 176.61 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.26 | 9.68 | 2.27 | 47.67 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.92 | 48.63 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.66 | 12.73 | 2.73 | 61.76 |
| canterbury-large/E.coli | 4638690 | stdx | 2.49 | 6.72 | 2.70 | 53.96 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.57 | 16.46 | 2.17 | 268.68 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.80 | 8.26 | 2.18 | 53.72 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.34 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.80 | 11.73 | 2.44 | 100.09 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.29 | 5.57 | 2.44 | 55.82 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.76 | 15.84 | 2.04 | 284.78 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.94 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.17 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.19 | 11.48 | 2.21 | 128.18 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 5.40 | 1.98 | 90.56 |
| http/html-1kx1024 | 1048576 | zlib | 16.74 | 35.58 | 2.13 | 353.70 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.69 | 28.43 | 2.24 | 217.06 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.87 | 20.05 | 1.85 | 157.13 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.35 | 38.07 | 2.48 | 262.15 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 137.79 |
| http/html-16kx64 | 1048576 | zlib | 6.74 | 14.77 | 2.19 | 221.95 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.27 |
| http/html-16kx64 | 1048576 | libdeflate | 2.66 | 6.04 | 2.28 | 60.67 |
| http/html-16kx64 | 1048576 | Wuffs | 4.92 | 11.56 | 2.35 | 114.76 |
| http/html-16kx64 | 1048576 | stdx | 2.52 | 5.56 | 2.21 | 59.22 |
| http/html-1m | 1048576 | zlib | 5.32 | 12.53 | 2.36 | 176.69 |
| http/html-1m | 1048576 | zlib-ng | 2.63 | 5.03 | 1.91 | 60.53 |
| http/html-1m | 1048576 | libdeflate | 1.69 | 4.39 | 2.59 | 37.30 |
| http/html-1m | 1048576 | Wuffs | 3.61 | 8.48 | 2.35 | 88.13 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.11 | 52.43 |
| http/json-1kx1024 | 1048576 | zlib | 10.61 | 23.92 | 2.25 | 192.15 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.41 | 16.69 | 2.25 | 131.68 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.15 | 16.72 | 1.83 | 93.59 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.10 | 34.78 | 2.87 | 145.26 |
| http/json-1kx1024 | 1048576 | stdx | 5.02 | 13.12 | 2.61 | 80.48 |
| http/json-16kx64 | 1048576 | zlib | 4.57 | 12.51 | 2.74 | 102.99 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.62 | 5.50 | 2.10 | 51.31 |
| http/json-16kx64 | 1048576 | libdeflate | 1.93 | 4.24 | 2.20 | 39.93 |
| http/json-16kx64 | 1048576 | Wuffs | 3.49 | 9.43 | 2.70 | 57.75 |
| http/json-16kx64 | 1048576 | stdx | 1.75 | 3.97 | 2.26 | 39.15 |
| http/json-1m | 1048576 | zlib | 3.86 | 11.20 | 2.90 | 83.28 |
| http/json-1m | 1048576 | zlib-ng | 1.94 | 3.91 | 2.02 | 37.37 |
| http/json-1m | 1048576 | libdeflate | 1.37 | 3.33 | 2.42 | 32.01 |
| http/json-1m | 1048576 | Wuffs | 2.72 | 7.37 | 2.71 | 43.28 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.01 | 40.16 |
| http/js-1kx1024 | 1048576 | zlib | 18.29 | 38.46 | 2.10 | 412.39 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.78 | 31.25 | 2.27 | 238.40 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.56 | 21.58 | 1.87 | 180.58 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.47 | 40.70 | 2.47 | 295.12 |
| http/js-1kx1024 | 1048576 | stdx | 9.28 | 22.85 | 2.46 | 158.87 |
| http/js-16kx64 | 1048576 | zlib | 7.65 | 16.08 | 2.10 | 262.59 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.98 | 91.80 |
| http/js-16kx64 | 1048576 | libdeflate | 3.07 | 7.01 | 2.28 | 72.12 |
| http/js-16kx64 | 1048576 | Wuffs | 5.50 | 12.75 | 2.32 | 128.33 |
| http/js-16kx64 | 1048576 | stdx | 2.98 | 6.54 | 2.19 | 71.38 |
| http/js-1m | 1048576 | zlib | 5.86 | 13.31 | 2.27 | 200.13 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 60.15 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.76 |
| http/js-1m | 1048576 | Wuffs | 3.90 | 9.14 | 2.34 | 93.60 |
| http/js-1m | 1048576 | stdx | 1.81 | 3.89 | 2.15 | 55.73 |
| http/css-1kx1024 | 1048576 | zlib | 14.06 | 30.36 | 2.16 | 281.17 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.23 | 23.04 | 2.25 | 169.73 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.46 | 17.37 | 1.84 | 122.63 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.70 | 32.49 | 2.56 | 207.50 |
| http/css-1kx1024 | 1048576 | stdx | 6.68 | 17.64 | 2.64 | 100.58 |
| http/css-16kx64 | 1048576 | zlib | 5.31 | 13.04 | 2.46 | 152.68 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.19 | 50.14 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 28.63 |
| http/css-16kx64 | 1048576 | Wuffs | 3.78 | 10.01 | 2.65 | 68.65 |
| http/css-16kx64 | 1048576 | stdx | 1.71 | 4.36 | 2.55 | 27.80 |
| http/css-1m | 1048576 | zlib | 4.00 | 10.97 | 2.75 | 108.57 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.22 | 28.67 |
| http/css-1m | 1048576 | libdeflate | 1.05 | 3.18 | 3.04 | 10.46 |
| http/css-1m | 1048576 | Wuffs | 2.56 | 7.14 | 2.79 | 42.78 |
| http/css-1m | 1048576 | stdx | 1.02 | 2.56 | 2.50 | 21.61 |
| shuffled/dickens-1m | 1048576 | zlib | 13.28 | 25.88 | 1.95 | 371.47 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.72 | 16.72 | 1.72 | 196.66 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.03 | 14.95 | 2.13 | 193.98 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.35 | 22.08 | 2.13 | 201.34 |
| shuffled/dickens-1m | 1048576 | stdx | 7.06 | 11.89 | 1.69 | 207.05 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.55 | 14.05 | 3.95 | 3.46 |
| silesia/dickens | 10192446 | stdx | 3.72 | 12.47 | 3.35 | 3.90 |
| silesia/mozilla | 51220480 | libzstd | 2.85 | 9.68 | 3.40 | 30.14 |
| silesia/mozilla | 51220480 | stdx | 2.84 | 9.68 | 3.40 | 15.74 |
| silesia/mr | 9970564 | libzstd | 3.04 | 11.99 | 3.94 | 6.17 |
| silesia/mr | 9970564 | stdx | 3.12 | 10.83 | 3.47 | 5.28 |
| silesia/nci | 33553445 | libzstd | 1.65 | 4.88 | 2.96 | 24.92 |
| silesia/nci | 33553445 | stdx | 1.64 | 4.63 | 2.82 | 13.73 |
| silesia/ooffice | 6152192 | libzstd | 3.41 | 12.19 | 3.58 | 31.02 |
| silesia/ooffice | 6152192 | stdx | 3.36 | 12.40 | 3.69 | 12.32 |
| silesia/osdb | 10085684 | libzstd | 2.38 | 8.45 | 3.55 | 14.96 |
| silesia/osdb | 10085684 | stdx | 2.45 | 8.11 | 3.30 | 15.38 |
| silesia/reymont | 6627202 | libzstd | 3.21 | 11.62 | 3.62 | 11.53 |
| silesia/reymont | 6627202 | stdx | 3.35 | 10.36 | 3.09 | 13.19 |
| silesia/samba | 21606400 | libzstd | 2.08 | 7.41 | 3.56 | 18.62 |
| silesia/samba | 21606400 | stdx | 2.15 | 6.83 | 3.18 | 17.87 |
| silesia/sao | 7251944 | libzstd | 3.77 | 12.72 | 3.38 | 26.76 |
| silesia/sao | 7251944 | stdx | 3.46 | 12.58 | 3.63 | 6.29 |
| silesia/webster | 41458703 | libzstd | 3.21 | 11.24 | 3.51 | 16.15 |
| silesia/webster | 41458703 | stdx | 3.32 | 10.05 | 3.03 | 17.91 |
| silesia/x-ray | 8474240 | libzstd | 3.90 | 14.94 | 3.83 | 18.93 |
| silesia/x-ray | 8474240 | stdx | 3.55 | 13.23 | 3.73 | 8.35 |
| silesia/xml | 5345280 | libzstd | 1.55 | 5.57 | 3.58 | 23.28 |
| silesia/xml | 5345280 | stdx | 1.51 | 5.16 | 3.41 | 17.18 |
| canterbury/alice29.txt | 152089 | libzstd | 3.33 | 16.20 | 4.86 | 4.05 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.36 | 0.45 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.97 | 14.26 | 4.80 | 3.28 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.29 | 0.26 |
| canterbury/cp.html | 24603 | libzstd | 2.64 | 10.74 | 4.06 | 7.76 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.11 | 0.22 |
| canterbury/fields.c | 11150 | libzstd | 3.13 | 13.62 | 4.36 | 9.27 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.23 | 0.10 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.20 | 16.94 | 4.03 | 5.15 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.54 | 4.01 | 0.19 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.54 | 11.40 | 4.50 | 7.71 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.68 | 11.32 | 4.22 | 1.00 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.72 | 12.89 | 4.75 | 5.08 |
| canterbury/lcet10.txt | 426754 | stdx | 2.74 | 11.52 | 4.21 | 4.21 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.12 | 15.16 | 4.86 | 1.54 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.26 | 1.05 |
| canterbury/ptt5 | 513216 | libzstd | 1.46 | 4.52 | 3.11 | 25.01 |
| canterbury/ptt5 | 513216 | stdx | 1.34 | 4.46 | 3.34 | 13.07 |
| canterbury/sum | 38240 | libzstd | 2.63 | 10.58 | 4.03 | 9.77 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.37 |
| canterbury/xargs.1 | 4227 | libzstd | 4.27 | 17.41 | 4.08 | 9.58 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 17.17 | 4.06 | 0.24 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.04 | 13.64 | 4.49 | 2.12 |
| canterbury-large/E.coli | 4638690 | stdx | 3.14 | 12.04 | 3.84 | 2.85 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.99 | 12.00 | 4.01 | 8.42 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.10 | 10.64 | 3.44 | 9.72 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.57 | 9.60 | 3.73 | 19.85 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.64 | 8.64 | 3.28 | 21.47 |
| http/html-1kx1024 | 1048576 | libzstd | 7.27 | 21.63 | 2.97 | 63.08 |
| http/html-1kx1024 | 1048576 | stdx | 7.47 | 22.46 | 3.01 | 76.54 |
| http/html-16kx64 | 1048576 | libzstd | 2.67 | 10.15 | 3.80 | 28.64 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 9.61 | 3.62 | 29.78 |
| http/html-1m | 1048576 | libzstd | 2.04 | 7.88 | 3.86 | 24.14 |
| http/html-1m | 1048576 | stdx | 2.03 | 7.12 | 3.51 | 25.21 |
| http/json-1kx1024 | 1048576 | libzstd | 6.29 | 17.39 | 2.76 | 50.15 |
| http/json-1kx1024 | 1048576 | stdx | 6.23 | 17.86 | 2.87 | 53.87 |
| http/json-16kx64 | 1048576 | libzstd | 2.06 | 7.26 | 3.53 | 27.98 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.57 | 20.06 |
| http/json-1m | 1048576 | libzstd | 1.74 | 6.08 | 3.50 | 28.13 |
| http/json-1m | 1048576 | stdx | 1.65 | 5.91 | 3.57 | 14.56 |
| http/js-1kx1024 | 1048576 | libzstd | 8.36 | 26.35 | 3.15 | 73.60 |
| http/js-1kx1024 | 1048576 | stdx | 9.05 | 27.60 | 3.05 | 113.35 |
| http/js-16kx64 | 1048576 | libzstd | 2.94 | 11.72 | 3.99 | 24.39 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.73 | 26.62 |
| http/js-1m | 1048576 | libzstd | 2.12 | 8.19 | 3.87 | 20.20 |
| http/js-1m | 1048576 | stdx | 2.19 | 7.48 | 3.42 | 21.84 |
| http/css-1kx1024 | 1048576 | libzstd | 6.91 | 19.69 | 2.85 | 53.70 |
| http/css-1kx1024 | 1048576 | stdx | 6.86 | 19.96 | 2.91 | 64.17 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.70 | 3.88 | 22.77 |
| http/css-16kx64 | 1048576 | stdx | 2.28 | 8.43 | 3.70 | 22.41 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.58 | 3.83 | 5.41 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.52 | 4.27 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.78 | 9.40 | 3.38 | 28.46 |
| shuffled/dickens-1m | 1048576 | stdx | 2.79 | 9.19 | 3.29 | 12.28 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.59 | 16.93 | 2.23 | 99.12 |
| silesia/dickens | 1048576 | stdx | 5.10 | 12.38 | 2.42 | 54.43 |
| silesia/mozilla | 1048576 | Google | 13.48 | 28.31 | 2.10 | 46.89 |
| silesia/mozilla | 1048576 | stdx | 8.43 | 15.02 | 1.78 | 46.85 |
| silesia/mr | 1048576 | Google | 8.95 | 20.21 | 2.26 | 103.01 |
| silesia/mr | 1048576 | stdx | 5.82 | 13.25 | 2.28 | 88.84 |
| silesia/nci | 1048576 | Google | 2.55 | 5.70 | 2.23 | 51.58 |
| silesia/nci | 1048576 | stdx | 1.98 | 3.95 | 1.99 | 55.14 |
| silesia/ooffice | 1048576 | Google | 14.20 | 29.27 | 2.06 | 290.23 |
| silesia/ooffice | 1048576 | stdx | 10.97 | 20.33 | 1.85 | 323.12 |
| silesia/osdb | 1048576 | Google | 8.30 | 17.48 | 2.11 | 98.94 |
| silesia/osdb | 1048576 | stdx | 5.17 | 10.57 | 2.05 | 92.24 |
| silesia/reymont | 1048576 | Google | 5.45 | 12.62 | 2.31 | 82.88 |
| silesia/reymont | 1048576 | stdx | 3.73 | 9.25 | 2.48 | 47.76 |
| silesia/samba | 1048576 | Google | 7.57 | 16.30 | 2.15 | 94.66 |
| silesia/samba | 1048576 | stdx | 5.07 | 10.71 | 2.11 | 67.19 |
| silesia/sao | 1048576 | Google | 16.92 | 37.18 | 2.20 | 168.67 |
| silesia/sao | 1048576 | stdx | 10.46 | 22.65 | 2.17 | 141.43 |
| silesia/webster | 1048576 | Google | 6.57 | 14.00 | 2.13 | 113.33 |
| silesia/webster | 1048576 | stdx | 4.41 | 9.98 | 2.26 | 69.65 |
| silesia/x-ray | 1048576 | Google | 19.37 | 38.56 | 1.99 | 236.90 |
| silesia/x-ray | 1048576 | stdx | 14.59 | 30.18 | 2.07 | 234.52 |
| silesia/xml | 1048576 | Google | 3.45 | 7.61 | 2.21 | 64.85 |
| silesia/xml | 1048576 | stdx | 2.41 | 5.40 | 2.24 | 47.20 |
| canterbury/alice29.txt | 152089 | Google | 8.83 | 20.55 | 2.33 | 133.41 |
| canterbury/alice29.txt | 152089 | stdx | 6.06 | 15.33 | 2.53 | 80.62 |
| canterbury/asyoulik.txt | 125179 | Google | 10.35 | 23.71 | 2.29 | 165.71 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.07 | 17.43 | 2.47 | 101.99 |
| canterbury/cp.html | 24603 | Google | 9.03 | 22.20 | 2.46 | 110.92 |
| canterbury/cp.html | 24603 | stdx | 5.63 | 17.15 | 3.05 | 25.00 |
| canterbury/fields.c | 11150 | Google | 6.97 | 21.16 | 3.04 | 20.44 |
| canterbury/fields.c | 11150 | stdx | 4.89 | 17.08 | 3.49 | 2.02 |
| canterbury/grammar.lsp | 3721 | Google | 9.82 | 30.16 | 3.07 | 7.28 |
| canterbury/grammar.lsp | 3721 | stdx | 7.16 | 25.04 | 3.50 | 0.43 |
| canterbury/kennedy.xls | 1029744 | Google | 5.42 | 17.05 | 3.15 | 37.37 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.83 | 12.94 | 3.38 | 33.90 |
| canterbury/lcet10.txt | 426754 | Google | 7.70 | 17.36 | 2.25 | 124.51 |
| canterbury/lcet10.txt | 426754 | stdx | 5.19 | 12.96 | 2.50 | 65.71 |
| canterbury/plrabn12.txt | 481861 | Google | 9.06 | 20.82 | 2.30 | 131.62 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.14 | 15.04 | 2.45 | 87.17 |
| canterbury/ptt5 | 513216 | Google | 4.28 | 10.41 | 2.43 | 62.00 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.07 | 65.03 |
| canterbury/sum | 38240 | Google | 10.83 | 26.44 | 2.44 | 159.45 |
| canterbury/sum | 38240 | stdx | 8.46 | 21.11 | 2.50 | 166.54 |
| canterbury/xargs.1 | 4227 | Google | 10.95 | 34.81 | 3.18 | 10.75 |
| canterbury/xargs.1 | 4227 | stdx | 8.48 | 30.44 | 3.59 | 6.28 |
| canterbury-large/E.coli | 1048576 | Google | 8.12 | 19.55 | 2.41 | 1.41 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.54 |
| canterbury-large/bible.txt | 1048576 | Google | 5.35 | 12.28 | 2.30 | 80.82 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.56 | 8.93 | 2.51 | 40.05 |
| canterbury-large/world192.txt | 1048576 | Google | 6.20 | 12.84 | 2.07 | 113.75 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.42 | 9.38 | 2.12 | 77.35 |
| http/html-1kx1024 | 1048576 | Google | 17.97 | 41.93 | 2.33 | 384.40 |
| http/html-1kx1024 | 1048576 | stdx | 15.26 | 37.56 | 2.46 | 357.88 |
| http/html-16kx64 | 1048576 | Google | 6.70 | 14.85 | 2.22 | 147.36 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.79 |
| http/html-1m | 1048576 | Google | 4.05 | 8.94 | 2.21 | 82.44 |
| http/html-1m | 1048576 | stdx | 2.86 | 6.52 | 2.28 | 54.63 |
| http/json-1kx1024 | 1048576 | Google | 14.51 | 36.64 | 2.53 | 242.10 |
| http/json-1kx1024 | 1048576 | stdx | 12.99 | 33.63 | 2.59 | 275.29 |
| http/json-16kx64 | 1048576 | Google | 4.41 | 11.43 | 2.59 | 81.31 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.68 |
| http/json-1m | 1048576 | Google | 3.40 | 8.65 | 2.54 | 58.50 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.43 | 57.82 |
| http/js-1kx1024 | 1048576 | Google | 19.90 | 46.20 | 2.32 | 426.32 |
| http/js-1kx1024 | 1048576 | stdx | 16.35 | 39.90 | 2.44 | 376.41 |
| http/js-16kx64 | 1048576 | Google | 7.98 | 17.73 | 2.22 | 163.47 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.57 |
| http/js-1m | 1048576 | Google | 4.35 | 9.54 | 2.19 | 82.47 |
| http/js-1m | 1048576 | stdx | 3.18 | 7.25 | 2.28 | 55.57 |
| http/css-1kx1024 | 1048576 | Google | 15.49 | 37.36 | 2.41 | 293.49 |
| http/css-1kx1024 | 1048576 | stdx | 13.78 | 34.70 | 2.52 | 299.95 |
| http/css-16kx64 | 1048576 | Google | 4.92 | 11.76 | 2.39 | 100.38 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.49 | 80.58 |
| http/css-1m | 1048576 | Google | 2.44 | 9.42 | 3.86 | 16.67 |
| http/css-1m | 1048576 | stdx | 0.76 | 1.86 | 2.46 | 12.22 |
| shuffled/dickens-1m | 1048576 | Google | 10.18 | 20.65 | 2.03 | 109.33 |
| shuffled/dickens-1m | 1048576 | stdx | 8.77 | 14.53 | 1.66 | 117.95 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.27 | 36.91 | 2.42 | 411.14 |
| silesia/dickens | 10192446 | 1 | stdx | 16.48 | 38.17 | 2.32 | 361.53 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.11 | 87.63 | 1.68 | 694.00 |
| silesia/dickens | 10192446 | 6 | stdx | 49.38 | 84.26 | 1.71 | 1425.15 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.98 | 160.47 | 1.43 | 931.52 |
| silesia/dickens | 10192446 | 9 | stdx | 84.84 | 191.81 | 2.26 | 1721.00 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.14 | 32.62 | 2.31 | 439.57 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.36 | 30.24 | 2.26 | 295.48 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.91 | 70.83 | 2.15 | 578.76 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.54 | 69.96 | 2.22 | 734.69 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.95 | 221.49 | 1.73 | 774.27 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.97 | 126.12 | 2.58 | 790.72 |
| silesia/mr | 9970564 | 1 | libdeflate | 12.00 | 35.02 | 2.92 | 230.14 |
| silesia/mr | 9970564 | 1 | stdx | 12.62 | 34.08 | 2.70 | 187.54 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.30 | 80.54 | 2.10 | 437.79 |
| silesia/mr | 9970564 | 6 | stdx | 39.82 | 83.19 | 2.09 | 981.97 |
| silesia/mr | 9970564 | 9 | libdeflate | 98.04 | 165.48 | 1.69 | 752.66 |
| silesia/mr | 9970564 | 9 | stdx | 87.09 | 206.31 | 2.37 | 1328.11 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.24 | 18.42 | 2.95 | 115.75 |
| silesia/nci | 33553445 | 1 | stdx | 4.98 | 10.88 | 2.19 | 97.93 |
| silesia/nci | 33553445 | 6 | libdeflate | 17.01 | 34.84 | 2.05 | 225.96 |
| silesia/nci | 33553445 | 6 | stdx | 14.40 | 29.54 | 2.05 | 394.28 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.51 | 105.28 | 1.68 | 500.86 |
| silesia/nci | 33553445 | 9 | stdx | 33.07 | 80.64 | 2.44 | 648.80 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.91 | 39.15 | 1.97 | 752.66 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.76 | 39.08 | 2.20 | 430.92 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 41.09 | 79.10 | 1.93 | 954.81 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.52 | 87.83 | 2.12 | 1000.21 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.77 | 127.63 | 1.71 | 1135.18 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.35 | 129.17 | 2.47 | 938.56 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.90 | 30.15 | 2.34 | 353.87 |
| silesia/osdb | 10085684 | 1 | stdx | 12.94 | 27.87 | 2.15 | 293.56 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.38 | 55.67 | 1.96 | 491.31 |
| silesia/osdb | 10085684 | 6 | stdx | 27.11 | 57.40 | 2.12 | 567.50 |
| silesia/osdb | 10085684 | 9 | libdeflate | 34.00 | 64.15 | 1.89 | 553.93 |
| silesia/osdb | 10085684 | 9 | stdx | 35.65 | 87.23 | 2.45 | 684.60 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.64 | 32.88 | 2.60 | 312.10 |
| silesia/reymont | 6627202 | 1 | stdx | 13.49 | 33.24 | 2.46 | 272.17 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.16 | 86.58 | 1.80 | 519.94 |
| silesia/reymont | 6627202 | 6 | stdx | 45.27 | 76.82 | 1.70 | 1432.88 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.66 | 276.14 | 1.39 | 843.04 |
| silesia/reymont | 6627202 | 9 | stdx | 87.14 | 189.98 | 2.18 | 1609.04 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.45 | 26.53 | 2.54 | 271.74 |
| silesia/samba | 21606400 | 1 | stdx | 9.92 | 22.23 | 2.24 | 221.14 |
| silesia/samba | 21606400 | 6 | libdeflate | 29.01 | 58.79 | 2.03 | 385.70 |
| silesia/samba | 21606400 | 6 | stdx | 24.13 | 49.84 | 2.07 | 624.78 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.34 | 141.44 | 1.68 | 505.54 |
| silesia/samba | 21606400 | 9 | stdx | 41.56 | 102.63 | 2.47 | 729.30 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.72 | 47.87 | 2.20 | 684.78 |
| silesia/sao | 7251944 | 1 | stdx | 19.19 | 49.92 | 2.60 | 346.75 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.21 | 96.89 | 1.89 | 961.19 |
| silesia/sao | 7251944 | 6 | stdx | 47.08 | 105.66 | 2.24 | 851.22 |
| silesia/sao | 7251944 | 9 | libdeflate | 71.18 | 120.26 | 1.69 | 1113.78 |
| silesia/sao | 7251944 | 9 | stdx | 55.45 | 138.16 | 2.49 | 844.40 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.09 | 30.45 | 2.33 | 385.11 |
| silesia/webster | 41458703 | 1 | stdx | 13.86 | 29.09 | 2.10 | 340.12 |
| silesia/webster | 41458703 | 6 | libdeflate | 37.06 | 66.02 | 1.78 | 571.19 |
| silesia/webster | 41458703 | 6 | stdx | 35.11 | 60.88 | 1.73 | 1109.10 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.71 | 138.85 | 1.47 | 755.19 |
| silesia/webster | 41458703 | 9 | stdx | 60.61 | 135.96 | 2.24 | 1289.88 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.69 | 49.67 | 2.10 | 783.08 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.60 | 50.82 | 2.89 | 261.51 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.93 | 82.77 | 2.51 | 851.33 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.81 | 98.12 | 2.90 | 539.73 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.60 | 91.03 | 2.42 | 1029.92 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.77 | 122.06 | 2.99 | 466.55 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.83 | 21.59 | 2.76 | 175.55 |
| silesia/xml | 5345280 | 1 | stdx | 7.09 | 15.66 | 2.21 | 155.25 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.26 | 40.51 | 1.91 | 264.39 |
| silesia/xml | 5345280 | 6 | stdx | 17.76 | 34.32 | 1.93 | 498.98 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.78 | 89.17 | 1.52 | 372.50 |
| silesia/xml | 5345280 | 9 | stdx | 31.18 | 72.83 | 2.34 | 597.30 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.27 | 35.61 | 2.50 | 378.60 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.04 | 36.13 | 2.40 | 335.33 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.79 | 82.29 | 1.76 | 640.62 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 44.00 | 77.43 | 1.76 | 1335.13 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.54 | 159.21 | 1.48 | 851.17 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 72.73 | 167.73 | 2.31 | 1508.25 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.18 | 37.20 | 2.45 | 415.62 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.72 | 37.43 | 2.38 | 355.69 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.26 | 85.43 | 1.77 | 711.90 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.14 | 81.93 | 1.78 | 1381.74 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 89.02 | 136.15 | 1.53 | 942.36 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 75.74 | 175.98 | 2.32 | 1606.88 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.69 | 32.02 | 2.74 | 284.43 |
| canterbury/cp.html | 24603 | 1 | stdx | 10.91 | 27.13 | 2.49 | 242.07 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 26.87 | 62.33 | 2.32 | 480.72 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.66 | 57.06 | 2.41 | 618.38 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.90 | 91.97 | 1.96 | 592.91 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.47 | 88.89 | 2.82 | 648.48 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.61 | 35.92 | 3.74 | 68.10 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.05 | 30.06 | 3.74 | 19.70 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.31 | 69.37 | 2.85 | 236.31 |
| canterbury/fields.c | 11150 | 6 | stdx | 21.30 | 57.62 | 2.70 | 461.80 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.66 | 100.81 | 2.26 | 428.95 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.74 | 92.66 | 3.22 | 449.31 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.10 | 51.51 | 3.93 | 17.28 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.91 | 39.03 | 3.94 | 1.97 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.80 | 87.06 | 3.66 | 28.86 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.18 | 70.82 | 4.12 | 13.71 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.79 | 102.89 | 3.34 | 40.06 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.82 | 99.32 | 4.17 | 57.87 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.38 | 27.18 | 3.68 | 65.47 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.06 | 22.58 | 3.20 | 62.89 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.97 | 73.85 | 2.64 | 96.19 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.32 | 62.00 | 3.21 | 138.19 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.56 | 664.23 | 1.83 | 164.56 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.55 | 130.89 | 3.49 | 219.52 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.80 | 33.99 | 2.46 | 371.26 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.46 | 33.93 | 2.35 | 330.17 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.10 | 78.22 | 1.73 | 608.81 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.76 | 73.43 | 1.76 | 1235.54 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.84 | 136.94 | 1.49 | 807.98 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 70.55 | 162.25 | 2.30 | 1445.52 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.80 | 38.62 | 2.44 | 426.19 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.71 | 40.25 | 2.41 | 367.73 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.13 | 91.90 | 1.70 | 752.10 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.64 | 88.90 | 1.72 | 1513.29 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 117.06 | 166.26 | 1.42 | 1006.45 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 88.57 | 201.33 | 2.27 | 1791.98 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.43 | 18.61 | 2.89 | 141.60 |
| canterbury/ptt5 | 513216 | 1 | stdx | 5.00 | 11.03 | 2.20 | 123.97 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.31 | 36.17 | 2.53 | 219.62 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.34 | 29.58 | 2.40 | 308.74 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.67 | 120.86 | 1.99 | 378.61 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.11 | 130.09 | 3.02 | 639.99 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.84 | 33.49 | 2.61 | 339.84 |
| canterbury/sum | 38240 | 1 | stdx | 12.47 | 29.36 | 2.35 | 292.09 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.65 | 69.87 | 2.44 | 496.03 |
| canterbury/sum | 38240 | 6 | stdx | 26.64 | 65.74 | 2.47 | 656.83 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.57 | 181.91 | 1.92 | 611.51 |
| canterbury/sum | 38240 | 9 | stdx | 39.38 | 112.34 | 2.85 | 656.52 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.39 | 53.06 | 3.96 | 27.11 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.75 | 43.11 | 4.01 | 8.04 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.89 | 87.70 | 3.83 | 67.91 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 18.02 | 74.37 | 4.13 | 42.63 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 25.15 | 94.34 | 3.75 | 98.64 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.47 | 106.97 | 4.04 | 121.20 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.07 | 40.47 | 3.35 | 163.68 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.76 | 42.29 | 3.31 | 101.39 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.53 | 395.99 | 2.16 | 264.82 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.70 | 374.13 | 3.05 | 1897.27 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 818.15 | 1063.49 | 1.30 | 1326.90 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 231.95 | 755.68 | 3.26 | 2485.40 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.54 | 32.38 | 2.58 | 312.20 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.23 | 32.23 | 2.44 | 282.26 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.10 | 80.12 | 1.74 | 522.81 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.16 | 72.39 | 1.72 | 1257.68 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.91 | 200.28 | 1.41 | 744.28 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.17 | 170.21 | 2.23 | 1440.71 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.30 | 29.72 | 2.23 | 412.38 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.12 | 28.55 | 2.02 | 379.53 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.04 | 60.25 | 1.82 | 557.87 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 31.94 | 56.81 | 1.78 | 990.10 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.76 | 119.11 | 1.47 | 685.97 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 51.88 | 117.95 | 2.27 | 1143.13 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.51 | 103.92 | 2.93 | 455.74 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.37 | 58.69 | 2.75 | 364.35 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.24 | 138.34 | 2.99 | 566.36 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 32.08 | 94.36 | 2.94 | 530.86 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.72 | 142.44 | 2.99 | 587.93 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 36.22 | 112.18 | 3.10 | 537.29 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.46 | 27.96 | 2.67 | 266.49 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.02 | 20.25 | 2.25 | 233.30 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.34 | 52.09 | 2.33 | 392.01 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.86 | 42.87 | 2.27 | 539.29 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 35.06 | 72.54 | 2.07 | 469.80 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.95 | 69.06 | 2.77 | 549.26 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.77 | 23.03 | 2.63 | 224.14 |
| http/html-1m | 1048576 | 1 | stdx | 8.17 | 17.80 | 2.18 | 206.05 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.34 | 49.53 | 1.95 | 327.69 |
| http/html-1m | 1048576 | 6 | stdx | 21.17 | 40.71 | 1.92 | 619.17 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.07 | 109.24 | 1.54 | 430.67 |
| http/html-1m | 1048576 | 9 | stdx | 35.66 | 85.76 | 2.41 | 704.93 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.89 | 94.80 | 2.97 | 305.17 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.54 | 45.22 | 2.73 | 242.48 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.05 | 126.60 | 2.94 | 373.73 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.23 | 78.43 | 2.88 | 378.49 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.13 | 142.45 | 2.73 | 432.47 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.80 | 95.61 | 3.10 | 383.76 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.85 | 23.85 | 3.04 | 134.35 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.45 | 13.94 | 2.56 | 110.32 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.19 | 46.61 | 2.56 | 205.28 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.46 | 35.02 | 2.60 | 281.15 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.22 | 151.99 | 1.89 | 300.97 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.31 | 58.45 | 3.03 | 302.75 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.74 | 19.85 | 2.94 | 124.72 |
| http/json-1m | 1048576 | 1 | stdx | 5.08 | 12.51 | 2.46 | 103.17 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.36 | 45.30 | 2.22 | 176.01 |
| http/json-1m | 1048576 | 6 | stdx | 14.72 | 35.09 | 2.38 | 299.73 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.56 | 205.21 | 1.69 | 279.82 |
| http/json-1m | 1048576 | 9 | stdx | 29.08 | 72.87 | 2.51 | 369.89 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.18 | 107.80 | 2.90 | 519.44 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.75 | 65.45 | 2.76 | 410.36 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.38 | 144.85 | 2.93 | 679.97 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 35.67 | 104.17 | 2.92 | 621.84 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.70 | 150.13 | 2.90 | 716.88 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 40.51 | 125.18 | 3.09 | 626.67 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.73 | 30.90 | 2.63 | 308.30 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.84 | 24.80 | 2.29 | 272.80 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.90 | 59.43 | 2.29 | 472.20 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.66 | 50.05 | 2.21 | 672.30 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.89 | 83.31 | 2.04 | 568.84 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.78 | 81.31 | 2.73 | 662.54 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.65 | 25.19 | 2.61 | 246.90 |
| http/js-1m | 1048576 | 1 | stdx | 9.56 | 21.31 | 2.23 | 233.48 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.82 | 56.12 | 1.95 | 370.96 |
| http/js-1m | 1048576 | 6 | stdx | 24.93 | 46.64 | 1.87 | 746.98 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.48 | 120.65 | 1.58 | 500.46 |
| http/js-1m | 1048576 | 9 | stdx | 42.15 | 100.01 | 2.37 | 811.66 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.31 | 97.74 | 2.93 | 377.30 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.51 | 49.57 | 2.68 | 300.37 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.97 | 129.23 | 2.94 | 480.14 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.14 | 82.37 | 2.83 | 503.12 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.81 | 133.80 | 2.92 | 509.58 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.23 | 99.53 | 3.00 | 519.24 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.65 | 25.60 | 2.96 | 174.31 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.69 | 16.96 | 2.54 | 134.92 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.20 | 48.80 | 2.42 | 287.85 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.47 | 38.01 | 2.31 | 463.16 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.86 | 82.40 | 2.02 | 374.23 |
| http/css-16kx64 | 1048576 | 9 | stdx | 23.12 | 65.14 | 2.82 | 478.22 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.97 | 21.15 | 3.03 | 134.08 |
| http/css-1m | 1048576 | 1 | stdx | 5.82 | 14.91 | 2.56 | 108.93 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.81 | 44.50 | 2.14 | 226.43 |
| http/css-1m | 1048576 | 6 | stdx | 16.72 | 35.61 | 2.13 | 447.75 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.86 | 111.58 | 1.60 | 310.23 |
| http/css-1m | 1048576 | 9 | stdx | 31.99 | 83.00 | 2.59 | 510.36 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.26 | 48.89 | 1.94 | 929.32 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.12 | 49.19 | 2.71 | 323.06 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.73 | 86.45 | 2.07 | 1183.32 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.63 | 88.80 | 2.24 | 850.25 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.13 | 94.50 | 2.00 | 1344.20 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.19 | 134.38 | 2.48 | 1135.22 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.08 | 31.22 | 3.10 | 120.70 |
| silesia/dickens | 10192446 | 1 | stdx | 24.25 | 82.03 | 3.38 | 126.05 |
| silesia/dickens | 10192446 | 3 | libzstd | 23.38 | 34.39 | 1.47 | 172.09 |
| silesia/dickens | 10192446 | 3 | stdx | 36.50 | 78.22 | 2.14 | 183.67 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.01 | 22.69 | 3.24 | 71.61 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.63 | 54.73 | 3.10 | 175.60 |
| silesia/mozilla | 51220480 | 3 | libzstd | 17.50 | 27.89 | 1.59 | 102.84 |
| silesia/mozilla | 51220480 | 3 | stdx | 31.61 | 62.01 | 1.96 | 146.55 |
| silesia/mr | 9970564 | 1 | libzstd | 7.67 | 24.81 | 3.23 | 58.03 |
| silesia/mr | 9970564 | 1 | stdx | 19.98 | 66.82 | 3.34 | 116.51 |
| silesia/mr | 9970564 | 3 | libzstd | 20.68 | 32.19 | 1.56 | 87.41 |
| silesia/mr | 9970564 | 3 | stdx | 34.48 | 72.46 | 2.10 | 115.24 |
| silesia/nci | 33553445 | 1 | libzstd | 3.51 | 9.55 | 2.72 | 57.81 |
| silesia/nci | 33553445 | 1 | stdx | 7.87 | 25.69 | 3.26 | 60.35 |
| silesia/nci | 33553445 | 3 | libzstd | 5.73 | 9.95 | 1.74 | 56.98 |
| silesia/nci | 33553445 | 3 | stdx | 11.59 | 29.15 | 2.51 | 67.06 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.57 | 29.26 | 3.41 | 72.66 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.09 | 72.51 | 3.14 | 181.58 |
| silesia/ooffice | 6152192 | 3 | libzstd | 32.97 | 39.44 | 1.20 | 120.85 |
| silesia/ooffice | 6152192 | 3 | stdx | 43.52 | 82.20 | 1.89 | 188.37 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.10 | 22.29 | 3.14 | 66.64 |
| silesia/osdb | 10085684 | 1 | stdx | 16.48 | 50.52 | 3.07 | 123.97 |
| silesia/osdb | 10085684 | 3 | libzstd | 18.58 | 26.23 | 1.41 | 68.57 |
| silesia/osdb | 10085684 | 3 | stdx | 33.11 | 57.87 | 1.75 | 112.77 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.73 | 27.13 | 2.79 | 150.58 |
| silesia/reymont | 6627202 | 1 | stdx | 20.29 | 72.05 | 3.55 | 97.39 |
| silesia/reymont | 6627202 | 3 | libzstd | 18.90 | 27.10 | 1.43 | 127.05 |
| silesia/reymont | 6627202 | 3 | stdx | 28.63 | 62.18 | 2.17 | 149.08 |
| silesia/samba | 21606400 | 1 | libzstd | 5.94 | 16.88 | 2.84 | 85.74 |
| silesia/samba | 21606400 | 1 | stdx | 13.56 | 42.89 | 3.16 | 126.46 |
| silesia/samba | 21606400 | 3 | libzstd | 12.39 | 18.81 | 1.52 | 99.55 |
| silesia/samba | 21606400 | 3 | stdx | 21.06 | 44.75 | 2.12 | 135.31 |
| silesia/sao | 7251944 | 1 | libzstd | 9.07 | 33.69 | 3.71 | 44.89 |
| silesia/sao | 7251944 | 1 | stdx | 26.04 | 82.03 | 3.15 | 109.27 |
| silesia/sao | 7251944 | 3 | libzstd | 32.73 | 50.03 | 1.53 | 96.14 |
| silesia/sao | 7251944 | 3 | stdx | 53.28 | 95.22 | 1.79 | 143.35 |
| silesia/webster | 41458703 | 1 | libzstd | 8.64 | 24.94 | 2.89 | 130.66 |
| silesia/webster | 41458703 | 1 | stdx | 20.38 | 64.04 | 3.14 | 167.42 |
| silesia/webster | 41458703 | 3 | libzstd | 19.79 | 27.33 | 1.38 | 177.88 |
| silesia/webster | 41458703 | 3 | stdx | 31.83 | 64.55 | 2.03 | 197.14 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.79 | 14.92 | 3.12 | 17.20 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.88 | 76.64 | 3.21 | 92.88 |
| silesia/x-ray | 8474240 | 3 | libzstd | 33.31 | 52.73 | 1.58 | 88.67 |
| silesia/x-ray | 8474240 | 3 | stdx | 49.32 | 92.40 | 1.87 | 109.40 |
| silesia/xml | 5345280 | 1 | libzstd | 4.23 | 11.71 | 2.77 | 71.40 |
| silesia/xml | 5345280 | 1 | stdx | 10.40 | 34.21 | 3.29 | 95.44 |
| silesia/xml | 5345280 | 3 | libzstd | 6.87 | 12.61 | 1.84 | 77.95 |
| silesia/xml | 5345280 | 3 | stdx | 12.98 | 32.28 | 2.49 | 117.37 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.77 | 32.84 | 3.05 | 139.11 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.43 | 76.49 | 3.41 | 191.35 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 16.17 | 39.48 | 2.44 | 204.73 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.64 | 73.76 | 2.77 | 340.35 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.73 | 33.55 | 3.45 | 103.26 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.56 | 79.00 | 3.35 | 218.73 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.98 | 39.27 | 2.46 | 210.75 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.35 | 79.30 | 2.80 | 381.05 |
| canterbury/cp.html | 24603 | 1 | libzstd | 7.05 | 26.64 | 3.78 | 43.27 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.07 | 57.76 | 3.59 | 120.63 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.81 | 31.85 | 3.25 | 51.23 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.66 | 59.76 | 3.20 | 153.22 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.71 | 31.76 | 3.65 | 44.16 |
| canterbury/fields.c | 11150 | 1 | stdx | 16.96 | 65.73 | 3.88 | 87.33 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.38 | 34.14 | 3.64 | 31.09 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.55 | 64.68 | 3.69 | 102.32 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.54 | 38.01 | 3.99 | 12.01 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.20 | 77.57 | 3.84 | 50.66 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.72 | 43.09 | 4.02 | 9.49 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.58 | 79.60 | 3.69 | 76.05 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.01 | 23.56 | 3.92 | 14.80 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.74 | 56.75 | 3.85 | 86.30 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.79 | 23.80 | 2.71 | 27.61 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 20.91 | 56.61 | 2.71 | 113.57 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.82 | 28.52 | 2.90 | 156.35 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.44 | 72.02 | 3.36 | 162.94 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 17.24 | 32.14 | 1.86 | 205.00 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.74 | 67.10 | 2.51 | 301.19 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.33 | 32.37 | 3.13 | 128.95 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.16 | 84.16 | 3.35 | 160.51 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 21.18 | 38.77 | 1.83 | 227.65 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 32.67 | 80.77 | 2.47 | 346.49 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.16 | 8.51 | 2.69 | 67.07 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.57 | 23.15 | 3.06 | 106.82 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 5.04 | 10.97 | 2.18 | 58.98 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.66 | 24.08 | 2.49 | 135.06 |
| canterbury/sum | 38240 | 1 | libzstd | 6.57 | 25.39 | 3.87 | 33.26 |
| canterbury/sum | 38240 | 1 | stdx | 16.89 | 59.13 | 3.50 | 151.74 |
| canterbury/sum | 38240 | 3 | libzstd | 9.44 | 30.67 | 3.25 | 49.69 |
| canterbury/sum | 38240 | 3 | stdx | 20.03 | 61.82 | 3.09 | 192.41 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 10.11 | 39.82 | 3.94 | 19.03 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.85 | 80.38 | 3.85 | 59.58 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.28 | 48.17 | 3.92 | 16.58 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.95 | 83.98 | 3.66 | 81.58 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.33 | 33.44 | 3.24 | 77.15 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.84 | 95.62 | 4.38 | 7.19 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 15.95 | 31.30 | 1.96 | 36.06 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 24.19 | 70.38 | 2.91 | 38.50 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.71 | 27.45 | 2.83 | 149.42 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.46 | 71.86 | 3.51 | 109.10 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 18.72 | 28.20 | 1.51 | 133.48 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 28.64 | 63.36 | 2.21 | 156.97 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.19 | 22.70 | 2.77 | 138.17 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.68 | 55.86 | 2.99 | 194.92 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 16.23 | 23.87 | 1.47 | 175.81 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 25.80 | 51.26 | 1.99 | 240.68 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.18 | 52.46 | 3.05 | 162.24 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 36.05 | 100.54 | 2.79 | 644.38 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.06 | 59.20 | 3.11 | 196.50 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 38.28 | 104.00 | 2.72 | 640.11 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.72 | 22.46 | 2.91 | 123.49 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.18 | 46.84 | 3.30 | 184.32 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.77 | 24.61 | 2.81 | 142.00 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.89 | 47.61 | 3.00 | 194.80 |
| http/html-1m | 1048576 | 1 | libzstd | 6.23 | 16.74 | 2.69 | 114.97 |
| http/html-1m | 1048576 | 1 | stdx | 13.00 | 42.00 | 3.23 | 136.14 |
| http/html-1m | 1048576 | 3 | libzstd | 9.69 | 18.18 | 1.88 | 126.22 |
| http/html-1m | 1048576 | 3 | stdx | 16.20 | 39.37 | 2.43 | 179.93 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.41 | 42.52 | 2.95 | 115.86 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.74 | 83.13 | 2.80 | 538.17 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.84 | 44.54 | 3.00 | 129.09 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.70 | 84.87 | 2.76 | 541.13 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.80 | 14.98 | 3.12 | 57.59 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.70 | 33.78 | 3.48 | 118.42 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.35 | 16.21 | 3.03 | 72.68 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.55 | 34.58 | 3.28 | 125.52 |
| http/json-1m | 1048576 | 1 | libzstd | 4.05 | 12.55 | 3.10 | 52.91 |
| http/json-1m | 1048576 | 1 | stdx | 9.02 | 30.70 | 3.40 | 87.16 |
| http/json-1m | 1048576 | 3 | libzstd | 6.39 | 13.78 | 2.16 | 69.00 |
| http/json-1m | 1048576 | 3 | stdx | 11.57 | 30.64 | 2.65 | 122.87 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.71 | 57.26 | 3.06 | 189.27 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 39.94 | 113.49 | 2.84 | 704.15 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.44 | 65.54 | 3.06 | 259.87 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.30 | 116.54 | 2.76 | 691.95 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.85 | 26.52 | 3.00 | 129.30 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.63 | 55.71 | 3.35 | 202.92 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.05 | 28.74 | 2.86 | 153.95 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.84 | 55.35 | 3.10 | 212.21 |
| http/js-1m | 1048576 | 1 | libzstd | 6.53 | 17.87 | 2.74 | 114.01 |
| http/js-1m | 1048576 | 1 | stdx | 13.99 | 45.88 | 3.28 | 137.74 |
| http/js-1m | 1048576 | 3 | libzstd | 10.29 | 19.14 | 1.86 | 125.53 |
| http/js-1m | 1048576 | 3 | stdx | 17.26 | 41.25 | 2.39 | 189.49 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.67 | 46.90 | 2.99 | 137.99 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.32 | 91.65 | 2.84 | 585.58 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.65 | 50.53 | 3.03 | 160.79 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.98 | 93.63 | 2.76 | 590.15 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.13 | 18.99 | 3.10 | 79.41 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.51 | 43.79 | 3.50 | 138.78 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.57 | 19.41 | 2.95 | 96.17 |
| http/css-16kx64 | 1048576 | 3 | stdx | 13.09 | 42.34 | 3.23 | 154.67 |
| http/css-1m | 1048576 | 1 | libzstd | 1.50 | 4.59 | 3.05 | 21.74 |
| http/css-1m | 1048576 | 1 | stdx | 4.01 | 14.85 | 3.70 | 30.77 |
| http/css-1m | 1048576 | 3 | libzstd | 2.00 | 5.25 | 2.63 | 19.63 |
| http/css-1m | 1048576 | 3 | stdx | 4.00 | 13.33 | 3.33 | 31.83 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.52 | 12.79 | 3.63 | 6.29 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.16 | 30.66 | 3.35 | 62.61 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 30.17 | 50.53 | 1.68 | 49.71 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 21.28 | 47.43 | 2.23 | 211.65 |

## Hardware counters per input octet, brotli encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | Google q1 | 18.88 | 30.24 | 1.60 | 231.61 |
| silesia/dickens | 10192446 | stdx 1 | 19.54 | 43.43 | 2.22 | 413.45 |
| silesia/dickens | 10192446 | Google q5 | 110.74 | 194.36 | 1.76 | 825.99 |
| silesia/dickens | 10192446 | stdx 5 | 74.59 | 156.05 | 2.09 | 982.43 |
| silesia/mozilla | 51220480 | Google q1 | 13.70 | 25.26 | 1.84 | 144.46 |
| silesia/mozilla | 51220480 | stdx 1 | 12.34 | 32.95 | 2.67 | 213.54 |
| silesia/mozilla | 51220480 | Google q5 | 65.50 | 149.30 | 2.28 | 801.00 |
| silesia/mozilla | 51220480 | stdx 5 | 59.89 | 147.29 | 2.46 | 813.47 |
| silesia/mr | 9970564 | Google q1 | 13.76 | 26.14 | 1.90 | 97.98 |
| silesia/mr | 9970564 | stdx 1 | 13.75 | 37.80 | 2.75 | 164.72 |
| silesia/mr | 9970564 | Google q5 | 90.57 | 177.41 | 1.96 | 608.15 |
| silesia/mr | 9970564 | stdx 5 | 68.60 | 148.94 | 2.17 | 696.22 |
| silesia/nci | 33553445 | Google q1 | 5.36 | 9.71 | 1.81 | 87.89 |
| silesia/nci | 33553445 | stdx 1 | 6.08 | 14.48 | 2.38 | 128.18 |
| silesia/nci | 33553445 | Google q5 | 32.66 | 59.01 | 1.81 | 413.50 |
| silesia/nci | 33553445 | stdx 5 | 30.52 | 58.55 | 1.92 | 485.14 |
| silesia/ooffice | 6152192 | Google q1 | 18.72 | 33.43 | 1.79 | 154.51 |
| silesia/ooffice | 6152192 | stdx 1 | 16.93 | 45.85 | 2.71 | 267.53 |
| silesia/ooffice | 6152192 | Google q5 | 93.16 | 198.80 | 2.13 | 1069.82 |
| silesia/ooffice | 6152192 | stdx 5 | 74.86 | 176.82 | 2.36 | 1072.03 |
| silesia/osdb | 10085684 | Google q1 | 13.30 | 23.47 | 1.76 | 84.46 |
| silesia/osdb | 10085684 | stdx 1 | 11.73 | 32.00 | 2.73 | 141.72 |
| silesia/osdb | 10085684 | Google q5 | 75.21 | 146.01 | 1.94 | 549.87 |
| silesia/osdb | 10085684 | stdx 5 | 54.21 | 122.60 | 2.26 | 524.60 |
| silesia/reymont | 6627202 | Google q1 | 15.73 | 25.54 | 1.62 | 208.45 |
| silesia/reymont | 6627202 | stdx 1 | 14.51 | 33.36 | 2.30 | 283.33 |
| silesia/reymont | 6627202 | Google q5 | 86.86 | 169.16 | 1.95 | 801.16 |
| silesia/reymont | 6627202 | stdx 5 | 65.12 | 140.26 | 2.15 | 900.60 |
| silesia/samba | 21606400 | Google q1 | 10.16 | 17.38 | 1.71 | 127.49 |
| silesia/samba | 21606400 | stdx 1 | 9.96 | 23.94 | 2.40 | 197.14 |
| silesia/samba | 21606400 | Google q5 | 50.03 | 105.54 | 2.11 | 480.31 |
| silesia/samba | 21606400 | stdx 5 | 43.95 | 102.34 | 2.33 | 528.60 |
| silesia/sao | 7251944 | Google q1 | 22.72 | 39.96 | 1.76 | 101.68 |
| silesia/sao | 7251944 | stdx 1 | 18.81 | 55.66 | 2.96 | 190.67 |
| silesia/sao | 7251944 | Google q5 | 117.96 | 259.63 | 2.20 | 935.89 |
| silesia/sao | 7251944 | stdx 5 | 88.68 | 226.51 | 2.55 | 756.29 |
| silesia/webster | 41458703 | Google q1 | 15.16 | 24.40 | 1.61 | 209.70 |
| silesia/webster | 41458703 | stdx 1 | 15.32 | 34.12 | 2.23 | 339.35 |
| silesia/webster | 41458703 | Google q5 | 80.86 | 141.82 | 1.75 | 756.84 |
| silesia/webster | 41458703 | stdx 5 | 64.69 | 121.37 | 1.88 | 851.21 |
| silesia/x-ray | 8474240 | Google q1 | 14.11 | 22.03 | 1.56 | 12.46 |
| silesia/x-ray | 8474240 | stdx 1 | 13.18 | 38.68 | 2.93 | 94.54 |
| silesia/x-ray | 8474240 | Google q5 | 109.66 | 236.76 | 2.16 | 726.38 |
| silesia/x-ray | 8474240 | stdx 5 | 86.79 | 224.49 | 2.59 | 644.80 |
| silesia/xml | 5345280 | Google q1 | 7.22 | 12.28 | 1.70 | 113.79 |
| silesia/xml | 5345280 | stdx 1 | 7.42 | 17.44 | 2.35 | 152.96 |
| silesia/xml | 5345280 | Google q5 | 33.36 | 72.50 | 2.17 | 359.63 |
| silesia/xml | 5345280 | stdx 5 | 30.12 | 64.71 | 2.15 | 409.75 |
| canterbury/alice29.txt | 152089 | Google q1 | 17.01 | 29.72 | 1.75 | 209.66 |
| canterbury/alice29.txt | 152089 | stdx 1 | 18.36 | 40.79 | 2.22 | 446.31 |
| canterbury/alice29.txt | 152089 | Google q5 | 81.15 | 200.77 | 2.47 | 1041.27 |
| canterbury/alice29.txt | 152089 | stdx 5 | 68.98 | 150.71 | 2.18 | 913.65 |
| canterbury/asyoulik.txt | 125179 | Google q1 | 18.76 | 32.37 | 1.73 | 223.86 |
| canterbury/asyoulik.txt | 125179 | stdx 1 | 20.09 | 44.50 | 2.22 | 500.34 |
| canterbury/asyoulik.txt | 125179 | Google q5 | 86.77 | 215.27 | 2.48 | 1079.02 |
| canterbury/asyoulik.txt | 125179 | stdx 5 | 76.63 | 162.50 | 2.12 | 1052.97 |
| canterbury/cp.html | 24603 | Google q1 | 13.20 | 27.30 | 2.07 | 110.63 |
| canterbury/cp.html | 24603 | stdx 1 | 14.60 | 36.07 | 2.47 | 350.00 |
| canterbury/cp.html | 24603 | Google q5 | 62.64 | 163.89 | 2.62 | 947.70 |
| canterbury/cp.html | 24603 | stdx 5 | 58.28 | 131.02 | 2.25 | 734.27 |
| canterbury/fields.c | 11150 | Google q1 | 12.07 | 29.04 | 2.41 | 11.14 |
| canterbury/fields.c | 11150 | stdx 1 | 10.52 | 38.87 | 3.70 | 89.01 |
| canterbury/fields.c | 11150 | Google q5 | 60.13 | 168.16 | 2.80 | 930.60 |
| canterbury/fields.c | 11150 | stdx 5 | 44.49 | 123.15 | 2.77 | 549.61 |
| canterbury/grammar.lsp | 3721 | Google q1 | 14.47 | 39.39 | 2.72 | 12.83 |
| canterbury/grammar.lsp | 3721 | stdx 1 | 13.49 | 55.22 | 4.09 | 30.93 |
| canterbury/grammar.lsp | 3721 | Google q5 | 60.32 | 203.91 | 3.38 | 434.79 |
| canterbury/grammar.lsp | 3721 | stdx 5 | 41.55 | 148.05 | 3.56 | 150.07 |
| canterbury/kennedy.xls | 1029744 | Google q1 | 9.89 | 24.83 | 2.51 | 59.56 |
| canterbury/kennedy.xls | 1029744 | stdx 1 | 7.80 | 27.03 | 3.47 | 77.08 |
| canterbury/kennedy.xls | 1029744 | Google q5 | 47.69 | 162.91 | 3.42 | 267.07 |
| canterbury/kennedy.xls | 1029744 | stdx 5 | 52.19 | 162.35 | 3.11 | 468.33 |
| canterbury/lcet10.txt | 426754 | Google q1 | 16.04 | 27.19 | 1.70 | 201.03 |
| canterbury/lcet10.txt | 426754 | stdx 1 | 16.80 | 37.84 | 2.25 | 378.49 |
| canterbury/lcet10.txt | 426754 | Google q5 | 80.38 | 187.58 | 2.33 | 961.12 |
| canterbury/lcet10.txt | 426754 | stdx 5 | 66.27 | 140.98 | 2.13 | 907.46 |
| canterbury/plrabn12.txt | 481861 | Google q1 | 19.05 | 32.57 | 1.71 | 250.76 |
| canterbury/plrabn12.txt | 481861 | stdx 1 | 20.91 | 46.66 | 2.23 | 475.43 |
| canterbury/plrabn12.txt | 481861 | Google q5 | 99.57 | 229.77 | 2.31 | 1068.10 |
| canterbury/plrabn12.txt | 481861 | stdx 5 | 83.37 | 169.17 | 2.03 | 1186.03 |
| canterbury/ptt5 | 513216 | Google q1 | 5.03 | 9.55 | 1.90 | 80.23 |
| canterbury/ptt5 | 513216 | stdx 1 | 6.66 | 15.64 | 2.35 | 160.57 |
| canterbury/ptt5 | 513216 | Google q5 | 27.69 | 68.87 | 2.49 | 472.49 |
| canterbury/ptt5 | 513216 | stdx 5 | 29.94 | 69.62 | 2.32 | 467.92 |
| canterbury/sum | 38240 | Google q1 | 12.95 | 29.25 | 2.26 | 87.83 |
| canterbury/sum | 38240 | stdx 1 | 15.45 | 36.37 | 2.35 | 399.76 |
| canterbury/sum | 38240 | Google q5 | 66.19 | 182.58 | 2.76 | 1096.62 |
| canterbury/sum | 38240 | stdx 5 | 65.56 | 158.18 | 2.41 | 847.71 |
| canterbury/xargs.1 | 4227 | Google q1 | 16.27 | 43.16 | 2.65 | 13.74 |
| canterbury/xargs.1 | 4227 | stdx 1 | 14.74 | 59.10 | 4.01 | 40.86 |
| canterbury/xargs.1 | 4227 | Google q5 | 70.23 | 219.02 | 3.12 | 760.30 |
| canterbury/xargs.1 | 4227 | stdx 5 | 48.34 | 158.73 | 3.28 | 268.76 |
| canterbury-large/E.coli | 4638690 | Google q1 | 13.63 | 27.46 | 2.02 | 53.49 |
| canterbury-large/E.coli | 4638690 | stdx 1 | 5.65 | 19.24 | 3.40 | 18.05 |
| canterbury-large/E.coli | 4638690 | Google q5 | 91.17 | 262.67 | 2.88 | 994.17 |
| canterbury-large/E.coli | 4638690 | stdx 5 | 31.55 | 92.99 | 2.95 | 65.10 |
| canterbury-large/bible.txt | 4047392 | Google q1 | 15.13 | 24.57 | 1.62 | 175.38 |
| canterbury-large/bible.txt | 4047392 | stdx 1 | 15.28 | 34.29 | 2.24 | 316.65 |
| canterbury-large/bible.txt | 4047392 | Google q5 | 85.04 | 165.65 | 1.95 | 735.51 |
| canterbury-large/bible.txt | 4047392 | stdx 5 | 60.58 | 134.75 | 2.22 | 800.66 |
| canterbury-large/world192.txt | 2473400 | Google q1 | 14.30 | 22.62 | 1.58 | 196.77 |
| canterbury-large/world192.txt | 2473400 | stdx 1 | 13.74 | 31.07 | 2.26 | 315.13 |
| canterbury-large/world192.txt | 2473400 | Google q5 | 73.17 | 129.46 | 1.77 | 748.31 |
| canterbury-large/world192.txt | 2473400 | stdx 5 | 55.29 | 105.23 | 1.90 | 766.55 |
| http/html-1kx1024 | 1048576 | Google q1 | 32.23 | 62.53 | 1.94 | 854.79 |
| http/html-1kx1024 | 1048576 | stdx 1 | 27.30 | 80.73 | 2.96 | 471.77 |
| http/html-1kx1024 | 1048576 | Google q5 | 106.04 | 260.90 | 2.46 | 2093.70 |
| http/html-1kx1024 | 1048576 | stdx 5 | 69.75 | 168.79 | 2.42 | 1199.12 |
| http/html-16kx64 | 1048576 | Google q1 | 11.32 | 20.38 | 1.80 | 214.04 |
| http/html-16kx64 | 1048576 | stdx 1 | 11.50 | 28.46 | 2.47 | 303.38 |
| http/html-16kx64 | 1048576 | Google q5 | 47.60 | 118.53 | 2.49 | 856.40 |
| http/html-16kx64 | 1048576 | stdx 5 | 41.84 | 92.79 | 2.22 | 673.80 |
| http/html-1m | 1048576 | Google q1 | 9.25 | 15.15 | 1.64 | 137.83 |
| http/html-1m | 1048576 | stdx 1 | 9.69 | 22.18 | 2.29 | 224.95 |
| http/html-1m | 1048576 | Google q5 | 48.03 | 104.93 | 2.18 | 578.78 |
| http/html-1m | 1048576 | stdx 5 | 37.88 | 84.35 | 2.23 | 543.15 |
| http/json-1kx1024 | 1048576 | Google q1 | 24.65 | 49.87 | 2.02 | 646.01 |
| http/json-1kx1024 | 1048576 | stdx 1 | 21.08 | 61.65 | 2.92 | 366.26 |
| http/json-1kx1024 | 1048576 | Google q5 | 79.56 | 203.15 | 2.55 | 1330.77 |
| http/json-1kx1024 | 1048576 | stdx 5 | 50.61 | 131.80 | 2.60 | 733.70 |
| http/json-16kx64 | 1048576 | Google q1 | 7.68 | 14.90 | 1.94 | 143.00 |
| http/json-16kx64 | 1048576 | stdx 1 | 7.05 | 19.73 | 2.80 | 159.23 |
| http/json-16kx64 | 1048576 | Google q5 | 36.73 | 97.81 | 2.66 | 560.51 |
| http/json-16kx64 | 1048576 | stdx 5 | 36.27 | 88.74 | 2.45 | 531.01 |
| http/json-1m | 1048576 | Google q1 | 6.32 | 12.65 | 2.00 | 91.35 |
| http/json-1m | 1048576 | stdx 1 | 6.65 | 17.21 | 2.59 | 140.31 |
| http/json-1m | 1048576 | Google q5 | 37.71 | 96.08 | 2.55 | 447.57 |
| http/json-1m | 1048576 | stdx 5 | 39.31 | 92.42 | 2.35 | 571.79 |
| http/js-1kx1024 | 1048576 | Google q1 | 34.83 | 68.18 | 1.96 | 898.86 |
| http/js-1kx1024 | 1048576 | stdx 1 | 30.66 | 90.40 | 2.95 | 531.11 |
| http/js-1kx1024 | 1048576 | Google q5 | 116.52 | 288.57 | 2.48 | 2309.31 |
| http/js-1kx1024 | 1048576 | stdx 5 | 77.77 | 187.33 | 2.41 | 1332.95 |
| http/js-16kx64 | 1048576 | Google q1 | 13.16 | 24.07 | 1.83 | 229.96 |
| http/js-16kx64 | 1048576 | stdx 1 | 13.45 | 32.69 | 2.43 | 355.21 |
| http/js-16kx64 | 1048576 | Google q5 | 56.30 | 141.15 | 2.51 | 997.73 |
| http/js-16kx64 | 1048576 | stdx 5 | 49.05 | 107.08 | 2.18 | 795.88 |
| http/js-1m | 1048576 | Google q1 | 9.97 | 16.69 | 1.67 | 140.73 |
| http/js-1m | 1048576 | stdx 1 | 10.19 | 23.55 | 2.31 | 229.38 |
| http/js-1m | 1048576 | Google q5 | 53.52 | 116.02 | 2.17 | 638.59 |
| http/js-1m | 1048576 | stdx 5 | 40.29 | 90.34 | 2.24 | 586.75 |
| http/css-1kx1024 | 1048576 | Google q1 | 27.71 | 54.06 | 1.95 | 733.03 |
| http/css-1kx1024 | 1048576 | stdx 1 | 23.67 | 68.32 | 2.89 | 430.42 |
| http/css-1kx1024 | 1048576 | Google q5 | 86.37 | 213.92 | 2.48 | 1644.91 |
| http/css-1kx1024 | 1048576 | stdx 5 | 54.51 | 138.71 | 2.54 | 913.21 |
| http/css-16kx64 | 1048576 | Google q1 | 9.02 | 16.85 | 1.87 | 140.52 |
| http/css-16kx64 | 1048576 | stdx 1 | 8.51 | 23.62 | 2.78 | 191.93 |
| http/css-16kx64 | 1048576 | Google q5 | 37.98 | 100.68 | 2.65 | 648.51 |
| http/css-16kx64 | 1048576 | stdx 5 | 32.13 | 81.61 | 2.54 | 495.85 |
| http/css-1m | 1048576 | Google q1 | 6.10 | 11.27 | 1.85 | 75.65 |
| http/css-1m | 1048576 | stdx 1 | 5.46 | 14.38 | 2.63 | 110.34 |
| http/css-1m | 1048576 | Google q5 | 14.73 | 38.50 | 2.61 | 130.31 |
| http/css-1m | 1048576 | stdx 5 | 14.60 | 36.92 | 2.53 | 111.72 |
| shuffled/dickens-1m | 1048576 | Google q1 | 11.56 | 20.96 | 1.81 | 2.90 |
| shuffled/dickens-1m | 1048576 | stdx 1 | 5.35 | 19.75 | 3.69 | 16.62 |
| shuffled/dickens-1m | 1048576 | Google q5 | 106.55 | 235.57 | 2.21 | 724.32 |
| shuffled/dickens-1m | 1048576 | stdx 5 | 46.57 | 121.56 | 2.61 | 250.95 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.122 | 3.01 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 65.8 | 219.6 | 0.083 | 7.77 | 3.34 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 28.3 | 80.7 | 0.151 | 3.35 | 2.85 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 250.3 | 1024.0 | 0.825 | 29.57 | 4.09 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.8 | 107.7 | 0.129 | 3.64 | 3.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.9 | 106.2 | 0.303 | 3.30 | 3.80 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 96.1 | 378.2 | 0.379 | 11.35 | 3.94 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 43.3 | 161.9 | 0.483 | 5.11 | 3.74 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 91.7 | 451.7 | 0.307 | 10.83 | 4.93 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.3 | 89.5 | 0.004 | 4.02 | 3.28 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.9 | 234.7 | 0.069 | 10.14 | 3.41 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 27.6 | 84.2 | 0.008 | 4.07 | 3.05 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 217.7 | 819.1 | 0.937 | 32.05 | 3.76 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.3 | 107.7 | 0.040 | 4.17 | 3.80 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 31.3 | 106.0 | 0.045 | 4.60 | 3.39 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 95.1 | 346.2 | 0.339 | 14.00 | 3.64 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 32.9 | 144.5 | 0.052 | 4.84 | 4.40 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 90.5 | 406.5 | 0.076 | 13.32 | 4.49 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 115020.3 | 403846.2 | 530.010 | 0.67 | 3.51 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 592607.9 | 2503286.2 | 1401.608 | 3.43 | 4.22 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 114403.1 | 404278.2 | 490.041 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3569221.9 | 18223876.2 | 3006.649 | 20.69 | 5.11 |
| string: silesia/dickens | 1 | 172528 | simdjson | 312031.9 | 621744.2 | 631.464 | 1.81 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 224404.2 | 826630.2 | 2204.557 | 1.30 | 3.68 |
| string: silesia/dickens | 1 | 172528 | std.json | 1634600.6 | 4578768.2 | 42255.392 | 9.47 | 2.80 |
| string: silesia/dickens | 1 | 172528 | serde_json | 203619.9 | 802391.2 | 992.309 | 1.18 | 3.94 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1052699.4 | 5283071.0 | 4981.093 | 6.10 | 5.02 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1572374.8 | 4799763.6 | 1764.571 | 1.32 | 3.05 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14412080.9 | 56816152.6 | 44962.929 | 12.11 | 3.94 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1568953.5 | 4799984.6 | 1577.000 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 28739066.4 | 132108253.6 | 159337.929 | 24.14 | 4.60 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4587485.9 | 7062781.6 | 533.714 | 3.85 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1797013.6 | 7322029.6 | 14328.571 | 1.51 | 4.07 |
| string: http/json-1m | 1 | 1190272 | std.json | 10863857.2 | 47381213.6 | 31437.786 | 9.13 | 4.36 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3798631.4 | 15226459.6 | 6193.500 | 3.19 | 4.01 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9085523.9 | 48022410.6 | 28054.143 | 7.63 | 5.29 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2066067.9 | 5765413.8 | 4419.750 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6180820.0 | 22589263.8 | 6924.250 | 3.28 | 3.65 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2059319.8 | 5765634.8 | 3925.250 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47312677.1 | 227842320.8 | 288039.375 | 25.13 | 4.82 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3764405.8 | 8446023.8 | 1932.375 | 2.00 | 2.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7144804.9 | 12276717.8 | 276568.250 | 3.79 | 1.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17871085.0 | 63617055.8 | 267824.000 | 9.49 | 3.56 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9568206.0 | 24440755.8 | 337858.000 | 5.08 | 2.55 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39615343.5 | 160313023.3 | 800234.625 | 21.04 | 4.05 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12950882.0 | 42561069.3 | 247108.333 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 160303968.7 | 667246747.3 | 393936.667 | 31.58 | 4.16 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12972512.3 | 42561290.3 | 245752.000 | 2.56 | 3.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 159463983.3 | 639992662.3 | 424046.667 | 31.42 | 4.01 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17530981.3 | 49745820.3 | 253829.000 | 3.45 | 2.84 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14388074.0 | 45615166.3 | 442463.667 | 2.83 | 3.17 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79586196.7 | 314900845.3 | 459514.000 | 15.68 | 3.96 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36014615.3 | 131556135.3 | 579031.333 | 7.10 | 3.65 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66747556.0 | 273934207.7 | 837230.667 | 13.15 | 4.10 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 94822.7 | 303836.7 | 5.032 | 0.18 | 3.20 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 189312.3 | 623465.7 | 8.710 | 0.36 | 3.29 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 147943.3 | 557626.7 | 5.742 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10223741.6 | 53478202.7 | 8.516 | 19.50 | 5.23 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 490362.6 | 1376733.7 | 4.839 | 0.94 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 538056.1 | 2195917.7 | 7.548 | 1.03 | 4.08 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3463162.7 | 12808414.7 | 60867.355 | 6.61 | 3.70 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 294082.0 | 1179969.7 | 5.548 | 0.56 | 4.01 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2249562.4 | 12790583.1 | 256.226 | 4.29 | 5.69 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.7 | 81.8 | 0.108 | 2.33 | 4.15 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.2 | 153.6 | 0.128 | 4.16 | 4.36 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 21.2 | 93.4 | 0.090 | 2.50 | 4.41 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 216.7 | 981.0 | 0.930 | 25.60 | 4.53 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 19.2 | 79.5 | 0.106 | 2.27 | 4.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.2 | 94.1 | 0.134 | 2.74 | 4.06 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.5 | 105.6 | 0.249 | 3.25 | 3.84 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.3 | 310.8 | 0.366 | 8.19 | 4.48 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.7 | 255.3 | 0.513 | 7.52 | 4.01 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.5 | 315.1 | 0.234 | 8.09 | 4.60 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 19.0 | 82.8 | 0.025 | 2.79 | 4.36 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.0 | 153.9 | 0.025 | 5.30 | 4.28 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 21.9 | 94.2 | 0.024 | 3.23 | 4.30 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 168.0 | 718.3 | 1.228 | 24.72 | 4.28 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.0 | 81.5 | 0.024 | 2.65 | 4.53 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.9 | 96.8 | 0.032 | 3.23 | 4.41 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.5 | 117.9 | 0.033 | 4.34 | 4.00 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 60.5 | 271.2 | 0.277 | 8.90 | 4.49 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 49.7 | 211.0 | 0.036 | 7.32 | 4.24 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 82.6 | 331.7 | 0.090 | 12.16 | 4.01 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 84803.8 | 280786.2 | 717.103 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84739.5 | 280732.2 | 714.206 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84800.8 | 280721.2 | 713.186 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3365950.2 | 16047574.2 | 2948.340 | 19.51 | 4.77 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 82737.3 | 274401.2 | 654.299 | 0.48 | 3.32 |
| string: silesia/dickens | 1 | 172528 | simdjson | 208219.0 | 674016.2 | 2099.237 | 1.21 | 3.24 |
| string: silesia/dickens | 1 | 172528 | yyjson | 206080.9 | 825518.2 | 1135.392 | 1.19 | 4.01 |
| string: silesia/dickens | 1 | 172528 | std.json | 1364538.1 | 2890892.2 | 54543.959 | 7.91 | 2.12 |
| string: silesia/dickens | 1 | 172528 | serde_json | 373728.4 | 1586249.2 | 2282.845 | 2.17 | 4.24 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 577970.7 | 2970293.3 | 2353.000 | 3.35 | 5.14 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1281696.9 | 3582350.6 | 11936.786 | 1.08 | 2.80 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1273709.2 | 3582290.6 | 11613.357 | 1.07 | 2.81 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1271052.4 | 3582277.6 | 11525.643 | 1.07 | 2.82 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25335201.8 | 109856348.6 | 142956.429 | 21.29 | 4.34 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1236582.4 | 3370022.6 | 11483.143 | 1.04 | 2.73 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2970851.4 | 10460762.6 | 29372.071 | 2.50 | 3.52 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2587742.8 | 10197931.6 | 9520.357 | 2.17 | 3.94 |
| string: http/json-1m | 1 | 1190272 | std.json | 8865871.4 | 43287986.6 | 15862.714 | 7.45 | 4.88 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4204786.8 | 17941088.6 | 10832.714 | 3.53 | 4.27 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5242450.7 | 26999740.1 | 11371.214 | 4.40 | 5.15 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2074895.8 | 6088099.8 | 4706.500 | 1.10 | 2.93 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2064159.1 | 6088039.8 | 4228.500 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2063511.3 | 6088026.8 | 4126.250 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43580163.3 | 193466548.8 | 271843.500 | 23.14 | 4.44 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2072593.4 | 5875346.8 | 4863.750 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2712995.0 | 7144143.8 | 21057.875 | 1.44 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12151547.3 | 23590602.8 | 447406.750 | 6.45 | 1.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20146684.8 | 56837736.8 | 538766.750 | 10.70 | 2.82 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11640394.1 | 33662338.8 | 329034.125 | 6.18 | 2.89 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18800326.6 | 76319450.8 | 249832.875 | 9.98 | 4.06 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113295.8 | 426376.7 | 3.387 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113210.5 | 426318.7 | 2.387 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113369.6 | 426305.7 | 3.516 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 638438.7 | 3146479.7 | 6.258 | 1.22 | 4.93 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113172.2 | 426343.7 | 2.677 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1206516.4 | 3866916.7 | 5.194 | 2.30 | 3.21 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1628578.1 | 5833341.7 | 5.839 | 3.11 | 3.58 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3568276.9 | 13108830.7 | 79165.581 | 6.81 | 3.67 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1783206.1 | 7405810.7 | 4.419 | 3.40 | 4.15 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2390066.4 | 12748285.1 | 16.613 | 4.56 | 5.33 |
