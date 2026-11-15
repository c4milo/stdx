# bench-profile

| Field | Value |
|---|---|
| Commit | 6e0508c |
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
| silesia/dickens | 10192446 | zlib | 8.83 | 19.08 | 2.16 | 311.71 |
| silesia/dickens | 10192446 | zlib-ng | 4.87 | 10.50 | 2.16 | 67.37 |
| silesia/dickens | 10192446 | libdeflate | 3.45 | 9.56 | 2.77 | 66.07 |
| silesia/dickens | 10192446 | Wuffs | 5.54 | 13.90 | 2.51 | 97.09 |
| silesia/dickens | 10192446 | stdx | 2.93 | 7.15 | 2.44 | 76.05 |
| silesia/mozilla | 51220480 | zlib | 8.48 | 17.23 | 2.03 | 251.81 |
| silesia/mozilla | 51220480 | zlib-ng | 4.95 | 8.95 | 1.81 | 85.52 |
| silesia/mozilla | 51220480 | libdeflate | 3.47 | 7.63 | 2.20 | 71.16 |
| silesia/mozilla | 51220480 | Wuffs | 6.42 | 13.89 | 2.17 | 132.62 |
| silesia/mozilla | 51220480 | stdx | 3.64 | 6.29 | 1.73 | 89.47 |
| silesia/mr | 9970564 | zlib | 8.39 | 18.46 | 2.20 | 202.65 |
| silesia/mr | 9970564 | zlib-ng | 4.80 | 9.98 | 2.08 | 67.87 |
| silesia/mr | 9970564 | libdeflate | 3.35 | 8.58 | 2.56 | 61.16 |
| silesia/mr | 9970564 | Wuffs | 5.99 | 14.04 | 2.34 | 99.75 |
| silesia/mr | 9970564 | stdx | 3.09 | 6.70 | 2.17 | 69.58 |
| silesia/nci | 33553445 | zlib | 3.55 | 10.18 | 2.86 | 81.02 |
| silesia/nci | 33553445 | zlib-ng | 1.58 | 3.13 | 1.98 | 33.68 |
| silesia/nci | 33553445 | libdeflate | 1.13 | 2.66 | 2.35 | 29.75 |
| silesia/nci | 33553445 | Wuffs | 2.47 | 6.47 | 2.62 | 41.39 |
| silesia/nci | 33553445 | stdx | 1.20 | 2.20 | 1.83 | 37.45 |
| silesia/ooffice | 6152192 | zlib | 11.77 | 21.06 | 1.79 | 417.39 |
| silesia/ooffice | 6152192 | zlib-ng | 6.92 | 12.04 | 1.74 | 140.21 |
| silesia/ooffice | 6152192 | libdeflate | 4.90 | 10.45 | 2.13 | 125.27 |
| silesia/ooffice | 6152192 | Wuffs | 8.81 | 17.54 | 1.99 | 220.02 |
| silesia/ooffice | 6152192 | stdx | 5.08 | 8.55 | 1.68 | 150.99 |
| silesia/osdb | 10085684 | zlib | 7.47 | 16.59 | 2.22 | 183.81 |
| silesia/osdb | 10085684 | zlib-ng | 4.29 | 8.38 | 1.95 | 52.88 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.91 | 2.43 | 29.74 |
| silesia/osdb | 10085684 | Wuffs | 5.80 | 13.61 | 2.35 | 78.44 |
| silesia/osdb | 10085684 | stdx | 2.77 | 5.65 | 2.04 | 40.92 |
| silesia/reymont | 6627202 | zlib | 7.36 | 15.89 | 2.16 | 259.03 |
| silesia/reymont | 6627202 | zlib-ng | 3.72 | 7.72 | 2.08 | 60.21 |
| silesia/reymont | 6627202 | libdeflate | 2.60 | 6.91 | 2.65 | 51.08 |
| silesia/reymont | 6627202 | Wuffs | 4.89 | 11.40 | 2.33 | 112.88 |
| silesia/reymont | 6627202 | stdx | 2.27 | 5.11 | 2.25 | 64.43 |
| silesia/samba | 21606400 | zlib | 6.12 | 14.13 | 2.31 | 175.13 |
| silesia/samba | 21606400 | zlib-ng | 3.34 | 6.47 | 1.94 | 55.96 |
| silesia/samba | 21606400 | libdeflate | 2.32 | 5.58 | 2.41 | 43.04 |
| silesia/samba | 21606400 | Wuffs | 4.32 | 10.39 | 2.41 | 79.49 |
| silesia/samba | 21606400 | stdx | 2.25 | 4.46 | 1.98 | 56.25 |
| silesia/sao | 7251944 | zlib | 10.49 | 23.54 | 2.24 | 203.95 |
| silesia/sao | 7251944 | zlib-ng | 7.86 | 14.83 | 1.89 | 79.42 |
| silesia/sao | 7251944 | libdeflate | 5.74 | 12.73 | 2.22 | 79.06 |
| silesia/sao | 7251944 | Wuffs | 8.90 | 21.26 | 2.39 | 86.38 |
| silesia/sao | 7251944 | stdx | 5.58 | 10.32 | 1.85 | 87.00 |
| silesia/webster | 41458703 | zlib | 7.84 | 16.16 | 2.06 | 284.19 |
| silesia/webster | 41458703 | zlib-ng | 4.23 | 8.04 | 1.90 | 85.30 |
| silesia/webster | 41458703 | libdeflate | 2.91 | 7.17 | 2.46 | 68.77 |
| silesia/webster | 41458703 | Wuffs | 5.14 | 11.67 | 2.27 | 121.81 |
| silesia/webster | 41458703 | stdx | 2.80 | 5.56 | 1.99 | 86.99 |
| silesia/x-ray | 8474240 | zlib | 12.89 | 27.21 | 2.11 | 329.32 |
| silesia/x-ray | 8474240 | zlib-ng | 9.05 | 17.39 | 1.92 | 124.13 |
| silesia/x-ray | 8474240 | libdeflate | 6.54 | 15.26 | 2.33 | 124.45 |
| silesia/x-ray | 8474240 | Wuffs | 10.80 | 23.52 | 2.18 | 190.76 |
| silesia/x-ray | 8474240 | stdx | 6.13 | 11.49 | 1.87 | 137.31 |
| silesia/xml | 5345280 | zlib | 4.22 | 11.16 | 2.64 | 118.00 |
| silesia/xml | 5345280 | zlib-ng | 1.99 | 3.88 | 1.96 | 42.85 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 31.95 |
| silesia/xml | 5345280 | Wuffs | 2.84 | 7.22 | 2.55 | 58.96 |
| silesia/xml | 5345280 | stdx | 1.32 | 2.65 | 2.01 | 41.96 |
| canterbury/alice29.txt | 152089 | zlib | 8.44 | 18.35 | 2.18 | 294.42 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.02 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.17 | 8.96 | 2.83 | 53.28 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.38 | 13.40 | 2.49 | 98.82 |
| canterbury/alice29.txt | 152089 | stdx | 2.70 | 6.99 | 2.59 | 62.02 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.03 | 19.42 | 2.15 | 314.48 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 72.54 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.61 | 9.82 | 2.72 | 69.02 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.77 | 14.40 | 2.50 | 100.41 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.08 | 7.52 | 2.44 | 79.11 |
| canterbury/cp.html | 24603 | zlib | 7.03 | 17.33 | 2.47 | 171.55 |
| canterbury/cp.html | 24603 | zlib-ng | 4.21 | 9.50 | 2.26 | 38.73 |
| canterbury/cp.html | 24603 | libdeflate | 2.79 | 7.95 | 2.85 | 10.29 |
| canterbury/cp.html | 24603 | Wuffs | 5.30 | 13.91 | 2.63 | 66.47 |
| canterbury/cp.html | 24603 | stdx | 2.64 | 7.19 | 2.73 | 11.84 |
| canterbury/fields.c | 11150 | zlib | 5.21 | 17.73 | 3.40 | 37.13 |
| canterbury/fields.c | 11150 | zlib-ng | 3.88 | 10.20 | 2.63 | 14.59 |
| canterbury/fields.c | 11150 | libdeflate | 2.78 | 8.32 | 2.99 | 1.19 |
| canterbury/fields.c | 11150 | Wuffs | 4.52 | 14.54 | 3.22 | 10.03 |
| canterbury/fields.c | 11150 | stdx | 2.49 | 7.64 | 3.07 | 3.64 |
| canterbury/grammar.lsp | 3721 | zlib | 6.75 | 24.26 | 3.59 | 5.30 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.81 | 17.48 | 3.01 | 7.38 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.39 | 12.05 | 2.75 | 0.20 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.67 | 21.86 | 3.28 | 3.72 |
| canterbury/grammar.lsp | 3721 | stdx | 3.85 | 12.18 | 3.17 | 1.44 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.59 | 15.27 | 3.33 | 48.64 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.70 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.74 | 5.97 | 2.18 | 8.96 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.86 | 11.59 | 3.00 | 14.93 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.66 | 2.67 | 16.86 |
| canterbury/lcet10.txt | 426754 | zlib | 8.21 | 17.78 | 2.17 | 290.69 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.18 | 60.72 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.60 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.22 | 12.88 | 2.47 | 101.23 |
| canterbury/lcet10.txt | 426754 | stdx | 2.58 | 6.42 | 2.48 | 66.24 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.20 | 19.86 | 2.16 | 321.41 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.29 | 11.19 | 2.11 | 79.40 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.76 | 10.19 | 2.71 | 76.89 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.83 | 14.61 | 2.50 | 100.54 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.14 | 7.63 | 2.43 | 84.88 |
| canterbury/ptt5 | 513216 | zlib | 5.05 | 10.71 | 2.12 | 103.36 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.00 | 3.74 | 1.87 | 46.77 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.08 | 38.57 |
| canterbury/ptt5 | 513216 | Wuffs | 3.00 | 7.13 | 2.38 | 57.56 |
| canterbury/ptt5 | 513216 | stdx | 1.44 | 2.55 | 1.77 | 48.69 |
| canterbury/sum | 38240 | zlib | 7.98 | 18.12 | 2.27 | 224.41 |
| canterbury/sum | 38240 | zlib-ng | 4.64 | 10.02 | 2.16 | 56.10 |
| canterbury/sum | 38240 | libdeflate | 3.28 | 8.34 | 2.54 | 32.75 |
| canterbury/sum | 38240 | Wuffs | 5.77 | 14.47 | 2.51 | 81.30 |
| canterbury/sum | 38240 | stdx | 3.03 | 7.73 | 2.55 | 28.60 |
| canterbury/xargs.1 | 4227 | zlib | 7.29 | 25.22 | 3.46 | 11.52 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.37 | 17.97 | 2.82 | 9.81 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.76 | 13.27 | 2.79 | 0.19 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.21 | 22.63 | 3.14 | 10.25 |
| canterbury/xargs.1 | 4227 | stdx | 4.26 | 12.86 | 3.02 | 3.57 |
| canterbury-large/E.coli | 4638690 | zlib | 6.76 | 17.84 | 2.64 | 177.60 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.23 | 9.68 | 2.29 | 47.47 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.92 | 48.40 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.66 | 12.73 | 2.73 | 61.30 |
| canterbury-large/E.coli | 4638690 | stdx | 2.46 | 6.72 | 2.73 | 53.58 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.51 | 16.46 | 2.19 | 266.41 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.77 | 8.26 | 2.19 | 53.56 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.61 | 7.45 | 2.85 | 45.41 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.80 | 11.73 | 2.45 | 99.95 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.23 | 5.57 | 2.50 | 55.69 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.73 | 15.84 | 2.05 | 282.56 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.97 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.23 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.18 | 11.48 | 2.22 | 128.20 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.71 | 5.40 | 1.99 | 90.26 |
| http/html-1kx1024 | 1048576 | zlib | 16.27 | 35.58 | 2.19 | 353.11 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.74 | 28.43 | 2.23 | 218.76 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.51 | 20.05 | 1.91 | 155.32 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.38 | 38.07 | 2.48 | 266.47 |
| http/html-1kx1024 | 1048576 | stdx | 8.40 | 20.88 | 2.49 | 137.73 |
| http/html-16kx64 | 1048576 | zlib | 6.71 | 14.77 | 2.20 | 223.11 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.39 |
| http/html-16kx64 | 1048576 | libdeflate | 2.63 | 6.04 | 2.30 | 60.44 |
| http/html-16kx64 | 1048576 | Wuffs | 4.92 | 11.57 | 2.35 | 115.13 |
| http/html-16kx64 | 1048576 | stdx | 2.51 | 5.56 | 2.21 | 59.13 |
| http/html-1m | 1048576 | zlib | 5.31 | 12.53 | 2.36 | 175.41 |
| http/html-1m | 1048576 | zlib-ng | 2.63 | 5.03 | 1.91 | 60.62 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.37 |
| http/html-1m | 1048576 | Wuffs | 3.61 | 8.48 | 2.35 | 88.20 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.11 | 53.26 |
| http/json-1kx1024 | 1048576 | zlib | 10.16 | 23.92 | 2.35 | 192.62 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.43 | 16.69 | 2.25 | 131.26 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.78 | 16.72 | 1.90 | 92.03 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.16 | 34.78 | 2.86 | 146.67 |
| http/json-1kx1024 | 1048576 | stdx | 5.04 | 13.12 | 2.60 | 81.14 |
| http/json-16kx64 | 1048576 | zlib | 4.55 | 12.51 | 2.75 | 103.89 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.94 |
| http/json-16kx64 | 1048576 | libdeflate | 1.91 | 4.24 | 2.22 | 40.61 |
| http/json-16kx64 | 1048576 | Wuffs | 3.50 | 9.43 | 2.70 | 58.11 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.26 | 39.21 |
| http/json-1m | 1048576 | zlib | 3.84 | 11.20 | 2.92 | 83.35 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.03 | 37.28 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.69 |
| http/json-1m | 1048576 | Wuffs | 2.72 | 7.37 | 2.71 | 43.46 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.02 | 40.19 |
| http/js-1kx1024 | 1048576 | zlib | 17.79 | 38.46 | 2.16 | 409.60 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.80 | 31.25 | 2.27 | 238.93 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.19 | 21.58 | 1.93 | 179.04 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.56 | 40.70 | 2.46 | 300.03 |
| http/js-1kx1024 | 1048576 | stdx | 9.28 | 22.85 | 2.46 | 159.01 |
| http/js-16kx64 | 1048576 | zlib | 7.64 | 16.08 | 2.10 | 264.03 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.39 | 8.65 | 1.97 | 92.08 |
| http/js-16kx64 | 1048576 | libdeflate | 3.05 | 7.01 | 2.30 | 71.99 |
| http/js-16kx64 | 1048576 | Wuffs | 5.50 | 12.75 | 2.32 | 128.69 |
| http/js-16kx64 | 1048576 | stdx | 2.98 | 6.54 | 2.19 | 71.44 |
| http/js-1m | 1048576 | zlib | 5.86 | 13.31 | 2.27 | 200.74 |
| http/js-1m | 1048576 | zlib-ng | 2.87 | 5.66 | 1.97 | 59.97 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.88 |
| http/js-1m | 1048576 | Wuffs | 3.91 | 9.14 | 2.34 | 93.95 |
| http/js-1m | 1048576 | stdx | 1.80 | 3.89 | 2.16 | 55.48 |
| http/css-1kx1024 | 1048576 | zlib | 13.59 | 30.36 | 2.23 | 279.80 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.28 | 23.04 | 2.24 | 170.57 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.10 | 17.37 | 1.91 | 121.63 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.79 | 32.50 | 2.54 | 210.74 |
| http/css-1kx1024 | 1048576 | stdx | 6.68 | 17.64 | 2.64 | 100.43 |
| http/css-16kx64 | 1048576 | zlib | 5.28 | 13.04 | 2.47 | 153.10 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.77 | 6.07 | 2.19 | 49.91 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 29.82 |
| http/css-16kx64 | 1048576 | Wuffs | 3.80 | 10.01 | 2.64 | 69.73 |
| http/css-16kx64 | 1048576 | stdx | 1.73 | 4.36 | 2.52 | 27.92 |
| http/css-1m | 1048576 | zlib | 3.99 | 10.97 | 2.75 | 108.74 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.21 | 29.17 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.98 | 12.83 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.78 | 43.63 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.53 | 21.42 |
| shuffled/dickens-1m | 1048576 | zlib | 13.30 | 25.88 | 1.95 | 373.26 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.68 | 16.72 | 1.73 | 194.37 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.02 | 14.95 | 2.13 | 194.00 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.33 | 22.08 | 2.14 | 201.69 |
| shuffled/dickens-1m | 1048576 | stdx | 7.02 | 11.89 | 1.69 | 205.33 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.38 | 14.05 | 4.16 | 3.42 |
| silesia/dickens | 10192446 | stdx | 3.56 | 12.47 | 3.50 | 3.97 |
| silesia/mozilla | 51220480 | libzstd | 2.83 | 9.68 | 3.43 | 30.09 |
| silesia/mozilla | 51220480 | stdx | 2.82 | 9.68 | 3.43 | 15.84 |
| silesia/mr | 9970564 | libzstd | 2.95 | 11.99 | 4.07 | 6.08 |
| silesia/mr | 9970564 | stdx | 3.01 | 10.83 | 3.59 | 5.31 |
| silesia/nci | 33553445 | libzstd | 1.60 | 4.88 | 3.05 | 24.79 |
| silesia/nci | 33553445 | stdx | 1.56 | 4.63 | 2.97 | 13.59 |
| silesia/ooffice | 6152192 | libzstd | 3.35 | 12.19 | 3.64 | 30.98 |
| silesia/ooffice | 6152192 | stdx | 3.30 | 12.40 | 3.76 | 12.24 |
| silesia/osdb | 10085684 | libzstd | 2.35 | 8.45 | 3.60 | 14.86 |
| silesia/osdb | 10085684 | stdx | 2.42 | 8.11 | 3.34 | 15.39 |
| silesia/reymont | 6627202 | libzstd | 3.12 | 11.62 | 3.72 | 11.50 |
| silesia/reymont | 6627202 | stdx | 3.29 | 10.36 | 3.14 | 13.00 |
| silesia/samba | 21606400 | libzstd | 2.04 | 7.41 | 3.62 | 18.59 |
| silesia/samba | 21606400 | stdx | 2.09 | 6.83 | 3.27 | 18.02 |
| silesia/sao | 7251944 | libzstd | 3.75 | 12.72 | 3.39 | 26.47 |
| silesia/sao | 7251944 | stdx | 3.47 | 12.58 | 3.62 | 6.26 |
| silesia/webster | 41458703 | libzstd | 3.11 | 11.24 | 3.62 | 16.13 |
| silesia/webster | 41458703 | stdx | 3.23 | 10.05 | 3.11 | 17.63 |
| silesia/x-ray | 8474240 | libzstd | 3.88 | 14.94 | 3.86 | 18.87 |
| silesia/x-ray | 8474240 | stdx | 3.54 | 13.23 | 3.74 | 8.40 |
| silesia/xml | 5345280 | libzstd | 1.54 | 5.57 | 3.62 | 23.30 |
| silesia/xml | 5345280 | stdx | 1.49 | 5.16 | 3.45 | 17.37 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.90 | 4.08 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.35 | 0.74 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.95 | 14.26 | 4.84 | 3.26 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.30 | 0.32 |
| canterbury/cp.html | 24603 | libzstd | 2.63 | 10.74 | 4.08 | 7.72 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.12 | 0.24 |
| canterbury/fields.c | 11150 | libzstd | 3.12 | 13.62 | 4.36 | 9.25 |
| canterbury/fields.c | 11150 | stdx | 2.99 | 12.72 | 4.25 | 0.08 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.19 | 16.94 | 4.04 | 4.91 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.54 | 4.02 | 0.06 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.52 | 11.40 | 4.52 | 7.80 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.66 | 11.32 | 4.25 | 0.88 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.69 | 12.89 | 4.78 | 5.15 |
| canterbury/lcet10.txt | 426754 | stdx | 2.74 | 11.52 | 4.20 | 5.62 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.09 | 15.16 | 4.90 | 1.50 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.26 | 0.90 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.52 | 3.12 | 24.88 |
| canterbury/ptt5 | 513216 | stdx | 1.34 | 4.46 | 3.33 | 13.37 |
| canterbury/sum | 38240 | libzstd | 2.61 | 10.58 | 4.05 | 10.17 |
| canterbury/sum | 38240 | stdx | 2.63 | 10.74 | 4.09 | 0.38 |
| canterbury/xargs.1 | 4227 | libzstd | 4.25 | 17.41 | 4.10 | 9.23 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 17.17 | 4.06 | 0.12 |
| canterbury-large/E.coli | 4638690 | libzstd | 2.98 | 13.64 | 4.58 | 2.11 |
| canterbury-large/E.coli | 4638690 | stdx | 3.09 | 12.04 | 3.89 | 2.88 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.93 | 12.00 | 4.10 | 8.32 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.05 | 10.64 | 3.49 | 9.67 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.49 | 9.60 | 3.86 | 19.70 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.56 | 8.64 | 3.38 | 21.43 |
| http/html-1kx1024 | 1048576 | libzstd | 7.25 | 21.63 | 2.98 | 63.35 |
| http/html-1kx1024 | 1048576 | stdx | 7.43 | 22.46 | 3.02 | 76.64 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.50 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 9.61 | 3.61 | 30.19 |
| http/html-1m | 1048576 | libzstd | 1.99 | 7.88 | 3.95 | 23.91 |
| http/html-1m | 1048576 | stdx | 2.00 | 7.12 | 3.56 | 24.59 |
| http/json-1kx1024 | 1048576 | libzstd | 6.27 | 17.39 | 2.77 | 49.76 |
| http/json-1kx1024 | 1048576 | stdx | 6.19 | 17.86 | 2.89 | 53.55 |
| http/json-16kx64 | 1048576 | libzstd | 2.06 | 7.26 | 3.53 | 28.65 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.58 | 19.74 |
| http/json-1m | 1048576 | libzstd | 1.71 | 6.08 | 3.55 | 28.08 |
| http/json-1m | 1048576 | stdx | 1.61 | 5.91 | 3.66 | 14.32 |
| http/js-1kx1024 | 1048576 | libzstd | 8.33 | 26.35 | 3.16 | 73.71 |
| http/js-1kx1024 | 1048576 | stdx | 9.01 | 27.60 | 3.06 | 113.61 |
| http/js-16kx64 | 1048576 | libzstd | 2.92 | 11.72 | 4.01 | 24.22 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.73 | 26.64 |
| http/js-1m | 1048576 | libzstd | 2.01 | 8.19 | 4.07 | 20.09 |
| http/js-1m | 1048576 | stdx | 2.06 | 7.48 | 3.63 | 21.47 |
| http/css-1kx1024 | 1048576 | libzstd | 6.89 | 19.69 | 2.86 | 53.81 |
| http/css-1kx1024 | 1048576 | stdx | 6.82 | 19.96 | 2.93 | 63.46 |
| http/css-16kx64 | 1048576 | libzstd | 2.25 | 8.70 | 3.87 | 23.14 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.42 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.58 | 3.88 | 5.49 |
| http/css-1m | 1048576 | stdx | 0.70 | 2.49 | 3.55 | 4.10 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.76 | 9.40 | 3.41 | 28.33 |
| shuffled/dickens-1m | 1048576 | stdx | 2.72 | 9.19 | 3.38 | 12.74 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.45 | 16.93 | 2.27 | 100.26 |
| silesia/dickens | 1048576 | stdx | 5.10 | 12.38 | 2.43 | 54.57 |
| silesia/mozilla | 1048576 | Google | 13.46 | 28.31 | 2.10 | 47.98 |
| silesia/mozilla | 1048576 | stdx | 8.32 | 15.02 | 1.81 | 47.35 |
| silesia/mr | 1048576 | Google | 8.87 | 20.21 | 2.28 | 103.30 |
| silesia/mr | 1048576 | stdx | 5.78 | 13.25 | 2.29 | 88.41 |
| silesia/nci | 1048576 | Google | 2.54 | 5.70 | 2.24 | 52.44 |
| silesia/nci | 1048576 | stdx | 1.94 | 3.95 | 2.04 | 55.11 |
| silesia/ooffice | 1048576 | Google | 14.09 | 29.27 | 2.08 | 289.50 |
| silesia/ooffice | 1048576 | stdx | 10.92 | 20.33 | 1.86 | 322.87 |
| silesia/osdb | 1048576 | Google | 8.17 | 17.48 | 2.14 | 97.66 |
| silesia/osdb | 1048576 | stdx | 5.15 | 10.57 | 2.05 | 91.88 |
| silesia/reymont | 1048576 | Google | 5.38 | 12.62 | 2.35 | 82.80 |
| silesia/reymont | 1048576 | stdx | 3.85 | 9.25 | 2.40 | 47.66 |
| silesia/samba | 1048576 | Google | 7.57 | 16.30 | 2.15 | 95.35 |
| silesia/samba | 1048576 | stdx | 5.07 | 10.71 | 2.11 | 66.80 |
| silesia/sao | 1048576 | Google | 16.84 | 37.18 | 2.21 | 167.44 |
| silesia/sao | 1048576 | stdx | 10.40 | 22.65 | 2.18 | 141.79 |
| silesia/webster | 1048576 | Google | 6.49 | 14.00 | 2.16 | 113.87 |
| silesia/webster | 1048576 | stdx | 4.38 | 9.98 | 2.28 | 68.83 |
| silesia/x-ray | 1048576 | Google | 19.60 | 38.56 | 1.97 | 236.32 |
| silesia/x-ray | 1048576 | stdx | 14.72 | 30.18 | 2.05 | 234.15 |
| silesia/xml | 1048576 | Google | 3.43 | 7.61 | 2.22 | 65.40 |
| silesia/xml | 1048576 | stdx | 2.40 | 5.40 | 2.25 | 47.15 |
| canterbury/alice29.txt | 152089 | Google | 8.86 | 20.55 | 2.32 | 132.50 |
| canterbury/alice29.txt | 152089 | stdx | 6.08 | 15.33 | 2.52 | 82.16 |
| canterbury/asyoulik.txt | 125179 | Google | 10.35 | 23.71 | 2.29 | 165.88 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.09 | 17.43 | 2.46 | 104.75 |
| canterbury/cp.html | 24603 | Google | 9.05 | 22.20 | 2.45 | 114.23 |
| canterbury/cp.html | 24603 | stdx | 5.85 | 17.15 | 2.93 | 36.09 |
| canterbury/fields.c | 11150 | Google | 7.14 | 21.16 | 2.97 | 29.56 |
| canterbury/fields.c | 11150 | stdx | 4.96 | 17.08 | 3.44 | 2.52 |
| canterbury/grammar.lsp | 3721 | Google | 9.84 | 30.16 | 3.06 | 8.82 |
| canterbury/grammar.lsp | 3721 | stdx | 7.25 | 25.04 | 3.45 | 0.34 |
| canterbury/kennedy.xls | 1029744 | Google | 5.44 | 17.05 | 3.14 | 37.44 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.81 | 12.94 | 3.40 | 33.73 |
| canterbury/lcet10.txt | 426754 | Google | 7.69 | 17.36 | 2.26 | 125.04 |
| canterbury/lcet10.txt | 426754 | stdx | 5.21 | 12.96 | 2.49 | 66.26 |
| canterbury/plrabn12.txt | 481861 | Google | 9.04 | 20.82 | 2.30 | 132.48 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.16 | 15.04 | 2.44 | 87.41 |
| canterbury/ptt5 | 513216 | Google | 4.29 | 10.41 | 2.43 | 62.36 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.07 | 66.01 |
| canterbury/sum | 38240 | Google | 10.86 | 26.44 | 2.44 | 158.73 |
| canterbury/sum | 38240 | stdx | 8.41 | 21.11 | 2.51 | 159.67 |
| canterbury/xargs.1 | 4227 | Google | 10.93 | 34.81 | 3.18 | 9.82 |
| canterbury/xargs.1 | 4227 | stdx | 8.72 | 30.44 | 3.49 | 7.27 |
| canterbury-large/E.coli | 1048576 | Google | 8.14 | 19.55 | 2.40 | 2.17 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.26 |
| canterbury-large/bible.txt | 1048576 | Google | 5.28 | 12.28 | 2.33 | 80.94 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.53 | 8.93 | 2.53 | 39.87 |
| canterbury-large/world192.txt | 1048576 | Google | 6.15 | 12.84 | 2.09 | 114.35 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.43 | 9.38 | 2.12 | 77.50 |
| http/html-1kx1024 | 1048576 | Google | 18.00 | 41.93 | 2.33 | 386.63 |
| http/html-1kx1024 | 1048576 | stdx | 15.32 | 37.56 | 2.45 | 360.01 |
| http/html-16kx64 | 1048576 | Google | 6.74 | 14.85 | 2.20 | 149.08 |
| http/html-16kx64 | 1048576 | stdx | 5.16 | 12.15 | 2.35 | 114.86 |
| http/html-1m | 1048576 | Google | 4.03 | 8.94 | 2.22 | 83.13 |
| http/html-1m | 1048576 | stdx | 2.85 | 6.52 | 2.29 | 54.91 |
| http/json-1kx1024 | 1048576 | Google | 14.45 | 36.64 | 2.54 | 241.54 |
| http/json-1kx1024 | 1048576 | stdx | 13.04 | 33.63 | 2.58 | 279.46 |
| http/json-16kx64 | 1048576 | Google | 4.43 | 11.43 | 2.58 | 82.89 |
| http/json-16kx64 | 1048576 | stdx | 3.38 | 8.42 | 2.49 | 83.75 |
| http/json-1m | 1048576 | Google | 3.41 | 8.65 | 2.54 | 59.96 |
| http/json-1m | 1048576 | stdx | 2.45 | 5.99 | 2.44 | 57.48 |
| http/js-1kx1024 | 1048576 | Google | 19.87 | 46.20 | 2.33 | 425.81 |
| http/js-1kx1024 | 1048576 | stdx | 16.42 | 39.90 | 2.43 | 378.91 |
| http/js-16kx64 | 1048576 | Google | 8.04 | 17.73 | 2.21 | 166.52 |
| http/js-16kx64 | 1048576 | stdx | 6.05 | 14.36 | 2.37 | 126.29 |
| http/js-1m | 1048576 | Google | 4.34 | 9.54 | 2.20 | 82.85 |
| http/js-1m | 1048576 | stdx | 3.16 | 7.25 | 2.30 | 55.68 |
| http/css-1kx1024 | 1048576 | Google | 15.49 | 37.36 | 2.41 | 294.57 |
| http/css-1kx1024 | 1048576 | stdx | 13.84 | 34.70 | 2.51 | 303.40 |
| http/css-16kx64 | 1048576 | Google | 4.96 | 11.76 | 2.37 | 102.59 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.49 | 80.54 |
| http/css-1m | 1048576 | Google | 2.42 | 9.42 | 3.89 | 16.97 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.48 | 12.07 |
| shuffled/dickens-1m | 1048576 | Google | 10.10 | 20.65 | 2.04 | 105.28 |
| shuffled/dickens-1m | 1048576 | stdx | 8.82 | 14.53 | 1.65 | 120.87 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.30 | 36.91 | 2.41 | 411.00 |
| silesia/dickens | 10192446 | 1 | stdx | 16.40 | 38.17 | 2.33 | 360.24 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.02 | 87.63 | 1.68 | 693.71 |
| silesia/dickens | 10192446 | 6 | stdx | 49.66 | 84.26 | 1.70 | 1451.97 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.76 | 160.47 | 1.44 | 927.22 |
| silesia/dickens | 10192446 | 9 | stdx | 85.50 | 191.81 | 2.24 | 1720.00 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.23 | 32.62 | 2.29 | 439.03 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.35 | 30.24 | 2.26 | 295.74 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.86 | 70.83 | 2.16 | 580.44 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.56 | 69.96 | 2.22 | 735.70 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.47 | 221.49 | 1.74 | 766.71 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.89 | 126.12 | 2.58 | 790.30 |
| silesia/mr | 9970564 | 1 | libdeflate | 12.05 | 35.02 | 2.91 | 229.63 |
| silesia/mr | 9970564 | 1 | stdx | 12.58 | 34.08 | 2.71 | 186.81 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.29 | 80.54 | 2.10 | 437.72 |
| silesia/mr | 9970564 | 6 | stdx | 39.60 | 83.19 | 2.10 | 966.15 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.65 | 165.48 | 1.69 | 750.41 |
| silesia/mr | 9970564 | 9 | stdx | 87.32 | 206.31 | 2.36 | 1329.81 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.22 | 18.42 | 2.96 | 115.66 |
| silesia/nci | 33553445 | 1 | stdx | 4.95 | 10.88 | 2.20 | 98.30 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.93 | 34.84 | 2.06 | 225.11 |
| silesia/nci | 33553445 | 6 | stdx | 14.32 | 29.54 | 2.06 | 391.17 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.31 | 105.28 | 1.69 | 499.13 |
| silesia/nci | 33553445 | 9 | stdx | 33.27 | 80.64 | 2.42 | 649.39 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 20.06 | 39.15 | 1.95 | 754.12 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.77 | 39.08 | 2.20 | 430.71 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 41.01 | 79.10 | 1.93 | 955.73 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.63 | 87.83 | 2.11 | 1007.36 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.49 | 127.63 | 1.71 | 1129.62 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.13 | 129.17 | 2.48 | 934.86 |
| silesia/osdb | 10085684 | 1 | libdeflate | 13.00 | 30.15 | 2.32 | 353.64 |
| silesia/osdb | 10085684 | 1 | stdx | 12.91 | 27.87 | 2.16 | 294.37 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.29 | 55.67 | 1.97 | 492.28 |
| silesia/osdb | 10085684 | 6 | stdx | 27.04 | 57.40 | 2.12 | 565.02 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.89 | 64.15 | 1.89 | 552.10 |
| silesia/osdb | 10085684 | 9 | stdx | 35.66 | 87.23 | 2.45 | 686.85 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.65 | 32.88 | 2.60 | 311.95 |
| silesia/reymont | 6627202 | 1 | stdx | 13.44 | 33.24 | 2.47 | 270.86 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.12 | 86.58 | 1.80 | 520.36 |
| silesia/reymont | 6627202 | 6 | stdx | 45.25 | 76.82 | 1.70 | 1430.37 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.10 | 276.14 | 1.39 | 835.07 |
| silesia/reymont | 6627202 | 9 | stdx | 87.63 | 189.98 | 2.17 | 1608.55 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.49 | 26.53 | 2.53 | 272.69 |
| silesia/samba | 21606400 | 1 | stdx | 9.90 | 22.23 | 2.24 | 220.64 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.93 | 58.79 | 2.03 | 385.69 |
| silesia/samba | 21606400 | 6 | stdx | 24.04 | 49.84 | 2.07 | 619.14 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.16 | 141.44 | 1.68 | 505.01 |
| silesia/samba | 21606400 | 9 | stdx | 41.77 | 102.63 | 2.46 | 728.79 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.90 | 47.87 | 2.19 | 689.00 |
| silesia/sao | 7251944 | 1 | stdx | 19.15 | 49.92 | 2.61 | 346.34 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.08 | 96.89 | 1.90 | 963.51 |
| silesia/sao | 7251944 | 6 | stdx | 47.17 | 105.66 | 2.24 | 855.21 |
| silesia/sao | 7251944 | 9 | libdeflate | 70.91 | 120.26 | 1.70 | 1104.78 |
| silesia/sao | 7251944 | 9 | stdx | 55.35 | 138.16 | 2.50 | 847.25 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.17 | 30.45 | 2.31 | 388.27 |
| silesia/webster | 41458703 | 1 | stdx | 13.86 | 29.09 | 2.10 | 340.48 |
| silesia/webster | 41458703 | 6 | libdeflate | 36.97 | 66.02 | 1.79 | 569.53 |
| silesia/webster | 41458703 | 6 | stdx | 35.06 | 60.88 | 1.74 | 1102.16 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.50 | 138.85 | 1.47 | 752.21 |
| silesia/webster | 41458703 | 9 | stdx | 61.19 | 135.96 | 2.22 | 1288.30 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.88 | 49.67 | 2.08 | 791.83 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.57 | 50.82 | 2.89 | 261.26 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.82 | 82.77 | 2.52 | 851.09 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.79 | 98.12 | 2.90 | 537.68 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.49 | 91.03 | 2.43 | 1032.48 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.60 | 122.06 | 3.01 | 467.52 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.81 | 21.59 | 2.76 | 176.60 |
| silesia/xml | 5345280 | 1 | stdx | 6.93 | 15.66 | 2.26 | 155.75 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.16 | 40.51 | 1.91 | 264.83 |
| silesia/xml | 5345280 | 6 | stdx | 17.72 | 34.32 | 1.94 | 499.78 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.59 | 89.17 | 1.52 | 369.74 |
| silesia/xml | 5345280 | 9 | stdx | 31.34 | 72.83 | 2.32 | 597.64 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.35 | 35.61 | 2.48 | 380.49 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.05 | 36.13 | 2.40 | 335.89 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.68 | 82.29 | 1.76 | 641.14 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.54 | 77.43 | 1.78 | 1308.51 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.60 | 159.21 | 1.48 | 850.67 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 73.12 | 167.73 | 2.29 | 1502.39 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.25 | 37.20 | 2.44 | 416.85 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.78 | 37.43 | 2.37 | 358.20 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.33 | 85.43 | 1.77 | 718.85 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.22 | 81.93 | 1.77 | 1392.72 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.86 | 136.15 | 1.53 | 941.43 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 76.22 | 175.98 | 2.31 | 1607.31 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.64 | 32.02 | 2.75 | 279.11 |
| canterbury/cp.html | 24603 | 1 | stdx | 10.94 | 27.13 | 2.48 | 240.54 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 27.11 | 62.33 | 2.30 | 496.30 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.90 | 57.06 | 2.39 | 622.63 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.94 | 91.97 | 1.96 | 598.65 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.43 | 88.89 | 2.83 | 638.15 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.43 | 35.92 | 3.81 | 57.63 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.23 | 30.06 | 3.65 | 25.40 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.49 | 69.37 | 2.83 | 249.17 |
| canterbury/fields.c | 11150 | 6 | stdx | 21.26 | 57.62 | 2.71 | 434.72 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.72 | 100.81 | 2.25 | 430.79 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.85 | 92.66 | 3.21 | 447.24 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 12.99 | 51.51 | 3.97 | 11.99 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 10.18 | 39.03 | 3.83 | 1.48 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.84 | 87.06 | 3.65 | 32.21 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.80 | 70.82 | 3.98 | 15.99 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 31.18 | 102.89 | 3.30 | 61.67 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 24.17 | 99.32 | 4.11 | 52.50 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.40 | 27.18 | 3.67 | 65.49 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.03 | 22.58 | 3.21 | 63.42 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.80 | 73.85 | 2.66 | 96.57 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.32 | 62.00 | 3.21 | 138.97 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.22 | 664.23 | 1.83 | 163.86 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.78 | 130.89 | 3.46 | 219.91 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.79 | 33.99 | 2.46 | 371.16 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.48 | 33.93 | 2.34 | 331.03 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 44.99 | 78.22 | 1.74 | 608.10 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.69 | 73.43 | 1.76 | 1232.16 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.80 | 136.94 | 1.49 | 804.77 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 71.06 | 162.25 | 2.28 | 1444.88 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.87 | 38.62 | 2.43 | 427.15 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.72 | 40.25 | 2.41 | 370.00 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.18 | 91.90 | 1.70 | 756.96 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.51 | 88.90 | 1.73 | 1504.86 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.93 | 166.26 | 1.42 | 1003.93 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 89.14 | 201.33 | 2.26 | 1796.93 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.45 | 18.61 | 2.89 | 141.62 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.96 | 11.03 | 2.22 | 123.34 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.26 | 36.17 | 2.54 | 219.08 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.32 | 29.58 | 2.40 | 310.12 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.37 | 120.86 | 2.00 | 373.38 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.28 | 130.09 | 3.01 | 641.21 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.92 | 33.49 | 2.59 | 338.81 |
| canterbury/sum | 38240 | 1 | stdx | 12.64 | 29.36 | 2.32 | 301.54 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.68 | 69.87 | 2.44 | 504.04 |
| canterbury/sum | 38240 | 6 | stdx | 26.88 | 65.74 | 2.45 | 666.93 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.23 | 181.91 | 1.93 | 609.54 |
| canterbury/sum | 38240 | 9 | stdx | 39.39 | 112.34 | 2.85 | 658.87 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.50 | 53.06 | 3.93 | 23.34 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.94 | 43.11 | 3.94 | 2.81 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.81 | 87.70 | 3.84 | 58.96 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 18.67 | 74.37 | 3.98 | 33.64 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 25.69 | 94.34 | 3.67 | 127.95 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.58 | 106.97 | 4.02 | 107.47 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.05 | 40.47 | 3.36 | 165.05 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.56 | 42.29 | 3.37 | 101.00 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.23 | 395.99 | 2.16 | 261.71 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.85 | 374.13 | 3.05 | 1906.39 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 818.05 | 1063.49 | 1.30 | 1325.73 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 229.37 | 755.68 | 3.29 | 2424.76 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.58 | 32.38 | 2.57 | 313.41 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.27 | 32.23 | 2.43 | 281.52 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.07 | 80.12 | 1.74 | 524.21 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.17 | 72.39 | 1.72 | 1262.58 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.63 | 200.28 | 1.41 | 743.12 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.60 | 170.21 | 2.22 | 1437.34 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.41 | 29.72 | 2.22 | 412.95 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.14 | 28.55 | 2.02 | 379.24 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 32.95 | 60.25 | 1.83 | 559.14 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 31.94 | 56.81 | 1.78 | 978.43 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.59 | 119.11 | 1.48 | 686.52 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 52.38 | 117.95 | 2.25 | 1144.67 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.43 | 103.92 | 2.93 | 455.13 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 23.35 | 58.69 | 2.51 | 365.83 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.14 | 138.34 | 3.00 | 562.14 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 34.01 | 94.36 | 2.77 | 527.05 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.72 | 142.44 | 2.99 | 587.55 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 38.24 | 112.18 | 2.93 | 539.64 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.46 | 27.96 | 2.67 | 267.14 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.06 | 20.25 | 2.24 | 233.58 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.45 | 52.09 | 2.32 | 404.13 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.98 | 42.87 | 2.26 | 536.19 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 34.99 | 72.54 | 2.07 | 468.82 |
| http/html-16kx64 | 1048576 | 9 | stdx | 25.05 | 69.06 | 2.76 | 552.05 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.80 | 23.03 | 2.62 | 224.67 |
| http/html-1m | 1048576 | 1 | stdx | 8.16 | 17.80 | 2.18 | 206.37 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.29 | 49.53 | 1.96 | 328.43 |
| http/html-1m | 1048576 | 6 | stdx | 21.12 | 40.71 | 1.93 | 616.78 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.00 | 109.24 | 1.54 | 432.89 |
| http/html-1m | 1048576 | 9 | stdx | 35.94 | 85.76 | 2.39 | 703.57 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.79 | 94.80 | 2.98 | 303.02 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 18.48 | 45.22 | 2.45 | 241.32 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.05 | 126.60 | 2.94 | 372.23 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 29.25 | 78.43 | 2.68 | 376.29 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.12 | 142.45 | 2.73 | 431.10 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 32.99 | 95.61 | 2.90 | 385.64 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.85 | 23.85 | 3.04 | 134.62 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.50 | 13.94 | 2.54 | 110.23 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.17 | 46.61 | 2.57 | 206.03 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.58 | 35.02 | 2.58 | 276.08 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.15 | 151.99 | 1.90 | 296.95 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.46 | 58.45 | 3.00 | 301.53 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.74 | 19.85 | 2.95 | 124.20 |
| http/json-1m | 1048576 | 1 | stdx | 5.06 | 12.51 | 2.47 | 102.83 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.30 | 45.30 | 2.23 | 175.67 |
| http/json-1m | 1048576 | 6 | stdx | 14.65 | 35.09 | 2.39 | 294.89 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.48 | 205.21 | 1.69 | 274.48 |
| http/json-1m | 1048576 | 9 | stdx | 29.15 | 72.87 | 2.50 | 369.81 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.08 | 107.80 | 2.91 | 517.71 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 25.66 | 65.45 | 2.55 | 409.76 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.40 | 144.85 | 2.93 | 676.94 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 37.66 | 104.17 | 2.77 | 618.35 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.78 | 150.13 | 2.90 | 717.60 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 42.53 | 125.18 | 2.94 | 626.00 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.72 | 30.90 | 2.64 | 308.76 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.89 | 24.80 | 2.28 | 273.11 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 26.05 | 59.43 | 2.28 | 486.09 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.86 | 50.05 | 2.19 | 676.53 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.89 | 83.31 | 2.04 | 569.27 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.89 | 81.31 | 2.72 | 663.73 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.64 | 25.19 | 2.61 | 247.07 |
| http/js-1m | 1048576 | 1 | stdx | 9.54 | 21.31 | 2.23 | 233.94 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.72 | 56.12 | 1.95 | 371.50 |
| http/js-1m | 1048576 | 6 | stdx | 24.82 | 46.64 | 1.88 | 744.07 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.23 | 120.65 | 1.58 | 500.79 |
| http/js-1m | 1048576 | 9 | stdx | 42.19 | 100.01 | 2.37 | 811.38 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.26 | 97.74 | 2.94 | 376.54 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 20.32 | 49.57 | 2.44 | 301.41 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.81 | 129.23 | 2.95 | 477.17 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 31.18 | 82.37 | 2.64 | 504.19 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.78 | 133.80 | 2.92 | 507.42 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 35.36 | 99.53 | 2.81 | 524.60 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.65 | 25.60 | 2.96 | 173.68 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.73 | 16.96 | 2.52 | 135.07 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.27 | 48.80 | 2.41 | 294.55 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.63 | 38.01 | 2.29 | 461.93 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.86 | 82.40 | 2.02 | 375.24 |
| http/css-16kx64 | 1048576 | 9 | stdx | 23.20 | 65.14 | 2.81 | 479.12 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.96 | 21.15 | 3.04 | 132.64 |
| http/css-1m | 1048576 | 1 | stdx | 5.78 | 14.91 | 2.58 | 108.74 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.75 | 44.50 | 2.14 | 226.48 |
| http/css-1m | 1048576 | 6 | stdx | 16.56 | 35.61 | 2.15 | 443.69 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.68 | 111.58 | 1.60 | 309.97 |
| http/css-1m | 1048576 | 9 | stdx | 32.18 | 83.00 | 2.58 | 512.56 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.35 | 48.89 | 1.93 | 936.85 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.10 | 49.19 | 2.72 | 323.69 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.54 | 86.45 | 2.08 | 1181.54 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.65 | 88.80 | 2.24 | 851.43 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 46.98 | 94.50 | 2.01 | 1344.98 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.46 | 134.38 | 2.47 | 1133.46 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.06 | 31.22 | 3.10 | 120.37 |
| silesia/dickens | 10192446 | 1 | stdx | 24.15 | 82.03 | 3.40 | 127.10 |
| silesia/dickens | 10192446 | 3 | libzstd | 21.39 | 34.39 | 1.61 | 169.56 |
| silesia/dickens | 10192446 | 3 | stdx | 34.34 | 78.22 | 2.28 | 182.87 |
| silesia/mozilla | 51220480 | 1 | libzstd | 6.96 | 22.69 | 3.26 | 71.24 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.46 | 54.73 | 3.13 | 175.30 |
| silesia/mozilla | 51220480 | 3 | libzstd | 15.73 | 27.89 | 1.77 | 102.23 |
| silesia/mozilla | 51220480 | 3 | stdx | 29.03 | 62.01 | 2.14 | 144.96 |
| silesia/mr | 9970564 | 1 | libzstd | 7.62 | 24.81 | 3.26 | 57.64 |
| silesia/mr | 9970564 | 1 | stdx | 19.77 | 66.82 | 3.38 | 117.02 |
| silesia/mr | 9970564 | 3 | libzstd | 18.61 | 32.19 | 1.73 | 86.74 |
| silesia/mr | 9970564 | 3 | stdx | 32.02 | 72.46 | 2.26 | 115.07 |
| silesia/nci | 33553445 | 1 | libzstd | 3.49 | 9.55 | 2.74 | 57.10 |
| silesia/nci | 33553445 | 1 | stdx | 7.63 | 25.69 | 3.37 | 60.08 |
| silesia/nci | 33553445 | 3 | libzstd | 5.20 | 9.95 | 1.91 | 56.20 |
| silesia/nci | 33553445 | 3 | stdx | 10.93 | 29.15 | 2.67 | 66.60 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.54 | 29.26 | 3.43 | 73.05 |
| silesia/ooffice | 6152192 | 1 | stdx | 22.90 | 72.51 | 3.17 | 181.48 |
| silesia/ooffice | 6152192 | 3 | libzstd | 21.85 | 39.44 | 1.81 | 120.04 |
| silesia/ooffice | 6152192 | 3 | stdx | 39.79 | 82.20 | 2.07 | 185.68 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.03 | 22.29 | 3.17 | 66.65 |
| silesia/osdb | 10085684 | 1 | stdx | 16.36 | 50.52 | 3.09 | 124.81 |
| silesia/osdb | 10085684 | 3 | libzstd | 16.57 | 26.23 | 1.58 | 67.86 |
| silesia/osdb | 10085684 | 3 | stdx | 30.04 | 57.87 | 1.93 | 111.77 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.64 | 27.13 | 2.81 | 150.55 |
| silesia/reymont | 6627202 | 1 | stdx | 20.02 | 72.05 | 3.60 | 97.14 |
| silesia/reymont | 6627202 | 3 | libzstd | 17.14 | 27.10 | 1.58 | 125.66 |
| silesia/reymont | 6627202 | 3 | stdx | 26.88 | 62.18 | 2.31 | 147.95 |
| silesia/samba | 21606400 | 1 | libzstd | 5.87 | 16.88 | 2.88 | 85.32 |
| silesia/samba | 21606400 | 1 | stdx | 13.39 | 42.89 | 3.20 | 126.54 |
| silesia/samba | 21606400 | 3 | libzstd | 11.22 | 18.81 | 1.68 | 98.87 |
| silesia/samba | 21606400 | 3 | stdx | 19.56 | 44.75 | 2.29 | 133.87 |
| silesia/sao | 7251944 | 1 | libzstd | 9.01 | 33.69 | 3.74 | 45.40 |
| silesia/sao | 7251944 | 1 | stdx | 25.70 | 82.03 | 3.19 | 104.56 |
| silesia/sao | 7251944 | 3 | libzstd | 28.64 | 50.03 | 1.75 | 94.49 |
| silesia/sao | 7251944 | 3 | stdx | 48.52 | 95.22 | 1.96 | 142.86 |
| silesia/webster | 41458703 | 1 | libzstd | 8.64 | 24.94 | 2.89 | 131.41 |
| silesia/webster | 41458703 | 1 | stdx | 20.19 | 64.04 | 3.17 | 168.10 |
| silesia/webster | 41458703 | 3 | libzstd | 17.99 | 27.33 | 1.52 | 175.65 |
| silesia/webster | 41458703 | 3 | stdx | 29.60 | 64.55 | 2.18 | 194.29 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.67 | 14.92 | 3.19 | 17.17 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.60 | 76.64 | 3.25 | 92.37 |
| silesia/x-ray | 8474240 | 3 | libzstd | 28.99 | 52.73 | 1.82 | 87.94 |
| silesia/x-ray | 8474240 | 3 | stdx | 44.93 | 92.40 | 2.06 | 105.66 |
| silesia/xml | 5345280 | 1 | libzstd | 4.19 | 11.71 | 2.80 | 71.24 |
| silesia/xml | 5345280 | 1 | stdx | 10.27 | 34.21 | 3.33 | 95.22 |
| silesia/xml | 5345280 | 3 | libzstd | 6.38 | 12.61 | 1.98 | 77.34 |
| silesia/xml | 5345280 | 3 | stdx | 12.34 | 32.28 | 2.62 | 116.14 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.75 | 32.84 | 3.06 | 138.93 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.46 | 76.49 | 3.41 | 192.05 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.24 | 39.48 | 2.59 | 203.67 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.15 | 73.76 | 2.82 | 338.89 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.70 | 33.55 | 3.46 | 102.13 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.56 | 79.00 | 3.35 | 219.67 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.14 | 39.27 | 2.59 | 210.10 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 27.82 | 79.30 | 2.85 | 377.46 |
| canterbury/cp.html | 24603 | 1 | libzstd | 7.03 | 26.64 | 3.79 | 42.45 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.25 | 57.76 | 3.55 | 125.80 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.52 | 31.85 | 3.35 | 48.72 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.19 | 59.76 | 3.28 | 141.06 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.73 | 31.76 | 3.64 | 42.02 |
| canterbury/fields.c | 11150 | 1 | stdx | 17.04 | 65.73 | 3.86 | 92.17 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.40 | 34.14 | 3.63 | 29.71 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.47 | 64.68 | 3.70 | 88.18 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.41 | 38.01 | 4.04 | 8.17 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.36 | 77.57 | 3.81 | 58.68 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.60 | 43.09 | 4.06 | 6.70 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.42 | 79.60 | 3.72 | 66.64 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 5.99 | 23.56 | 3.93 | 14.62 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.67 | 56.75 | 3.87 | 87.83 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.11 | 23.80 | 2.93 | 27.55 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 19.72 | 56.61 | 2.87 | 108.35 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.79 | 28.52 | 2.91 | 155.93 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.42 | 72.02 | 3.36 | 162.56 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 15.62 | 32.14 | 2.06 | 200.30 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 25.83 | 67.10 | 2.60 | 298.54 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.30 | 32.37 | 3.14 | 129.38 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.07 | 84.16 | 3.36 | 160.95 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 19.40 | 38.77 | 2.00 | 226.12 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 31.15 | 80.77 | 2.59 | 345.73 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.13 | 8.51 | 2.72 | 66.61 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.52 | 23.15 | 3.08 | 106.01 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 4.60 | 10.97 | 2.38 | 58.96 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.21 | 24.08 | 2.62 | 134.05 |
| canterbury/sum | 38240 | 1 | libzstd | 6.56 | 25.39 | 3.87 | 33.41 |
| canterbury/sum | 38240 | 1 | stdx | 17.04 | 59.13 | 3.47 | 158.30 |
| canterbury/sum | 38240 | 3 | libzstd | 9.03 | 30.67 | 3.40 | 47.86 |
| canterbury/sum | 38240 | 3 | stdx | 19.75 | 61.82 | 3.13 | 184.03 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 9.94 | 39.82 | 4.01 | 10.33 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.96 | 80.38 | 3.83 | 63.58 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.75 | 48.17 | 3.78 | 16.20 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.96 | 83.98 | 3.66 | 81.90 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.27 | 33.44 | 3.25 | 75.72 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.77 | 95.62 | 4.39 | 7.26 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 14.35 | 31.30 | 2.18 | 36.04 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.15 | 70.38 | 3.04 | 39.19 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.65 | 27.45 | 2.84 | 148.84 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.23 | 71.86 | 3.55 | 109.37 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 17.06 | 28.20 | 1.65 | 132.56 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 26.96 | 63.36 | 2.35 | 155.88 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.10 | 22.70 | 2.80 | 137.23 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.55 | 55.86 | 3.01 | 195.39 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 14.57 | 23.87 | 1.64 | 172.03 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 24.04 | 51.26 | 2.13 | 237.32 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 16.95 | 52.46 | 3.10 | 159.71 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.68 | 100.54 | 2.82 | 639.45 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 18.93 | 59.20 | 3.13 | 195.87 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 37.99 | 104.00 | 2.74 | 635.39 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.73 | 22.46 | 2.90 | 121.80 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.14 | 46.84 | 3.31 | 183.30 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.81 | 24.61 | 2.79 | 141.32 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.21 | 47.61 | 3.13 | 193.22 |
| http/html-1m | 1048576 | 1 | libzstd | 6.18 | 16.74 | 2.71 | 114.32 |
| http/html-1m | 1048576 | 1 | stdx | 12.86 | 42.00 | 3.27 | 135.58 |
| http/html-1m | 1048576 | 3 | libzstd | 8.97 | 18.18 | 2.03 | 125.06 |
| http/html-1m | 1048576 | 3 | stdx | 15.36 | 39.37 | 2.56 | 178.28 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.22 | 42.52 | 2.99 | 115.64 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.48 | 83.13 | 2.82 | 527.93 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.72 | 44.54 | 3.03 | 129.29 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.53 | 84.87 | 2.78 | 532.25 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.80 | 14.98 | 3.12 | 57.54 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.67 | 33.78 | 3.49 | 117.72 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.36 | 16.21 | 3.02 | 72.27 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.52 | 34.58 | 3.29 | 123.58 |
| http/json-1m | 1048576 | 1 | libzstd | 4.01 | 12.55 | 3.13 | 52.30 |
| http/json-1m | 1048576 | 1 | stdx | 8.96 | 30.70 | 3.42 | 87.49 |
| http/json-1m | 1048576 | 3 | libzstd | 5.92 | 13.78 | 2.33 | 68.13 |
| http/json-1m | 1048576 | 3 | stdx | 11.04 | 30.64 | 2.78 | 120.63 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.43 | 57.26 | 3.11 | 184.22 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 40.00 | 113.49 | 2.84 | 703.15 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.30 | 65.54 | 3.08 | 260.20 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.48 | 116.54 | 2.74 | 689.41 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.85 | 26.52 | 3.00 | 127.05 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.63 | 55.71 | 3.35 | 203.15 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.10 | 28.74 | 2.85 | 155.47 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.52 | 55.35 | 3.16 | 211.40 |
| http/js-1m | 1048576 | 1 | libzstd | 6.49 | 17.87 | 2.75 | 113.77 |
| http/js-1m | 1048576 | 1 | stdx | 13.88 | 45.88 | 3.31 | 137.54 |
| http/js-1m | 1048576 | 3 | libzstd | 9.50 | 19.14 | 2.02 | 124.14 |
| http/js-1m | 1048576 | 3 | stdx | 16.45 | 41.25 | 2.51 | 187.76 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.45 | 46.90 | 3.04 | 137.24 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.28 | 91.65 | 2.84 | 581.75 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.53 | 50.53 | 3.06 | 159.37 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.79 | 93.63 | 2.77 | 586.32 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.12 | 18.99 | 3.10 | 78.36 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.39 | 43.79 | 3.53 | 138.38 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.57 | 19.41 | 2.95 | 95.50 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.93 | 42.34 | 3.28 | 152.32 |
| http/css-1m | 1048576 | 1 | libzstd | 1.49 | 4.59 | 3.09 | 21.76 |
| http/css-1m | 1048576 | 1 | stdx | 3.97 | 14.85 | 3.74 | 30.67 |
| http/css-1m | 1048576 | 3 | libzstd | 1.92 | 5.25 | 2.74 | 19.58 |
| http/css-1m | 1048576 | 3 | stdx | 3.92 | 13.33 | 3.40 | 31.77 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.51 | 12.79 | 3.64 | 6.16 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.09 | 30.66 | 3.37 | 62.64 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 26.17 | 50.53 | 1.93 | 49.90 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 20.26 | 47.43 | 2.34 | 210.38 |

## Hardware counters per input octet, brotli encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | Google q1 | 17.96 | 30.24 | 1.68 | 232.04 |
| silesia/dickens | 10192446 | stdx 1 | 19.51 | 43.43 | 2.23 | 413.67 |
| silesia/dickens | 10192446 | Google q5 | 99.60 | 194.36 | 1.95 | 818.66 |
| silesia/dickens | 10192446 | stdx 5 | 68.30 | 156.51 | 2.29 | 978.93 |
| silesia/mozilla | 51220480 | Google q1 | 12.94 | 25.26 | 1.95 | 144.74 |
| silesia/mozilla | 51220480 | stdx 1 | 12.35 | 32.95 | 2.67 | 213.83 |
| silesia/mozilla | 51220480 | Google q5 | 59.97 | 149.30 | 2.49 | 795.81 |
| silesia/mozilla | 51220480 | stdx 5 | 57.60 | 149.71 | 2.60 | 808.58 |
| silesia/mr | 9970564 | Google q1 | 13.00 | 26.14 | 2.01 | 97.81 |
| silesia/mr | 9970564 | stdx 1 | 13.74 | 37.80 | 2.75 | 164.93 |
| silesia/mr | 9970564 | Google q5 | 78.57 | 177.41 | 2.26 | 607.48 |
| silesia/mr | 9970564 | stdx 5 | 60.05 | 150.44 | 2.51 | 696.78 |
| silesia/nci | 33553445 | Google q1 | 5.16 | 9.71 | 1.88 | 89.18 |
| silesia/nci | 33553445 | stdx 1 | 6.08 | 14.48 | 2.38 | 128.36 |
| silesia/nci | 33553445 | Google q5 | 29.99 | 59.01 | 1.97 | 410.17 |
| silesia/nci | 33553445 | stdx 5 | 25.75 | 58.75 | 2.28 | 473.39 |
| silesia/ooffice | 6152192 | Google q1 | 17.20 | 33.43 | 1.94 | 155.59 |
| silesia/ooffice | 6152192 | stdx 1 | 16.89 | 45.85 | 2.72 | 267.26 |
| silesia/ooffice | 6152192 | Google q5 | 83.10 | 198.80 | 2.39 | 1062.60 |
| silesia/ooffice | 6152192 | stdx 5 | 72.20 | 180.71 | 2.50 | 1061.98 |
| silesia/osdb | 10085684 | Google q1 | 12.28 | 23.47 | 1.91 | 84.62 |
| silesia/osdb | 10085684 | stdx 1 | 11.71 | 32.00 | 2.73 | 141.21 |
| silesia/osdb | 10085684 | Google q5 | 63.42 | 146.01 | 2.30 | 544.17 |
| silesia/osdb | 10085684 | stdx 5 | 49.13 | 125.21 | 2.55 | 516.49 |
| silesia/reymont | 6627202 | Google q1 | 15.17 | 25.54 | 1.68 | 206.45 |
| silesia/reymont | 6627202 | stdx 1 | 14.54 | 33.36 | 2.29 | 283.90 |
| silesia/reymont | 6627202 | Google q5 | 76.18 | 169.16 | 2.22 | 795.66 |
| silesia/reymont | 6627202 | stdx 5 | 58.45 | 140.32 | 2.40 | 889.37 |
| silesia/samba | 21606400 | Google q1 | 9.69 | 17.38 | 1.79 | 128.00 |
| silesia/samba | 21606400 | stdx 1 | 9.94 | 23.94 | 2.41 | 197.63 |
| silesia/samba | 21606400 | Google q5 | 44.87 | 105.54 | 2.35 | 477.48 |
| silesia/samba | 21606400 | stdx 5 | 40.40 | 103.19 | 2.55 | 525.14 |
| silesia/sao | 7251944 | Google q1 | 20.62 | 39.96 | 1.94 | 100.68 |
| silesia/sao | 7251944 | stdx 1 | 18.80 | 55.66 | 2.96 | 189.93 |
| silesia/sao | 7251944 | Google q5 | 102.61 | 259.63 | 2.53 | 925.55 |
| silesia/sao | 7251944 | stdx 5 | 87.32 | 233.57 | 2.67 | 741.68 |
| silesia/webster | 41458703 | Google q1 | 14.36 | 24.40 | 1.70 | 208.55 |
| silesia/webster | 41458703 | stdx 1 | 15.34 | 34.12 | 2.22 | 340.44 |
| silesia/webster | 41458703 | Google q5 | 71.56 | 141.82 | 1.98 | 751.84 |
| silesia/webster | 41458703 | stdx 5 | 54.41 | 122.07 | 2.24 | 837.50 |
| silesia/x-ray | 8474240 | Google q1 | 13.76 | 22.03 | 1.60 | 12.34 |
| silesia/x-ray | 8474240 | stdx 1 | 13.14 | 38.68 | 2.94 | 94.41 |
| silesia/x-ray | 8474240 | Google q5 | 92.76 | 236.76 | 2.55 | 723.64 |
| silesia/x-ray | 8474240 | stdx 5 | 82.09 | 231.05 | 2.81 | 652.51 |
| silesia/xml | 5345280 | Google q1 | 6.92 | 12.28 | 1.77 | 114.44 |
| silesia/xml | 5345280 | stdx 1 | 7.33 | 17.44 | 2.38 | 153.65 |
| silesia/xml | 5345280 | Google q5 | 30.32 | 72.50 | 2.39 | 358.42 |
| silesia/xml | 5345280 | stdx 5 | 25.77 | 65.03 | 2.52 | 405.20 |
| canterbury/alice29.txt | 152089 | Google q1 | 16.69 | 29.72 | 1.78 | 208.48 |
| canterbury/alice29.txt | 152089 | stdx 1 | 18.37 | 40.79 | 2.22 | 449.63 |
| canterbury/alice29.txt | 152089 | Google q5 | 79.15 | 200.77 | 2.54 | 1039.44 |
| canterbury/alice29.txt | 152089 | stdx 5 | 58.55 | 148.01 | 2.53 | 901.10 |
| canterbury/asyoulik.txt | 125179 | Google q1 | 17.65 | 32.37 | 1.83 | 222.58 |
| canterbury/asyoulik.txt | 125179 | stdx 1 | 20.20 | 44.50 | 2.20 | 504.00 |
| canterbury/asyoulik.txt | 125179 | Google q5 | 84.58 | 215.27 | 2.55 | 1075.82 |
| canterbury/asyoulik.txt | 125179 | stdx 5 | 64.25 | 159.47 | 2.48 | 1034.02 |
| canterbury/cp.html | 24603 | Google q1 | 12.78 | 27.30 | 2.14 | 101.89 |
| canterbury/cp.html | 24603 | stdx 1 | 14.57 | 36.07 | 2.48 | 348.09 |
| canterbury/cp.html | 24603 | Google q5 | 59.94 | 163.89 | 2.73 | 945.55 |
| canterbury/cp.html | 24603 | stdx 5 | 45.83 | 128.83 | 2.81 | 718.11 |
| canterbury/fields.c | 11150 | Google q1 | 11.85 | 29.04 | 2.45 | 12.45 |
| canterbury/fields.c | 11150 | stdx 1 | 10.47 | 38.87 | 3.71 | 83.40 |
| canterbury/fields.c | 11150 | Google q5 | 58.46 | 168.16 | 2.88 | 905.00 |
| canterbury/fields.c | 11150 | stdx 5 | 39.84 | 120.96 | 3.04 | 532.40 |
| canterbury/grammar.lsp | 3721 | Google q1 | 14.22 | 39.39 | 2.77 | 8.14 |
| canterbury/grammar.lsp | 3721 | stdx 1 | 13.67 | 55.22 | 4.04 | 30.25 |
| canterbury/grammar.lsp | 3721 | Google q5 | 60.84 | 203.91 | 3.35 | 454.89 |
| canterbury/grammar.lsp | 3721 | stdx 5 | 39.18 | 145.59 | 3.72 | 185.85 |
| canterbury/kennedy.xls | 1029744 | Google q1 | 9.68 | 24.83 | 2.56 | 59.75 |
| canterbury/kennedy.xls | 1029744 | stdx 1 | 7.83 | 27.03 | 3.45 | 77.21 |
| canterbury/kennedy.xls | 1029744 | Google q5 | 47.52 | 162.91 | 3.43 | 263.76 |
| canterbury/kennedy.xls | 1029744 | stdx 5 | 50.09 | 162.41 | 3.24 | 467.78 |
| canterbury/lcet10.txt | 426754 | Google q1 | 16.26 | 27.19 | 1.67 | 202.24 |
| canterbury/lcet10.txt | 426754 | stdx 1 | 16.75 | 37.84 | 2.26 | 379.83 |
| canterbury/lcet10.txt | 426754 | Google q5 | 77.20 | 187.58 | 2.43 | 956.76 |
| canterbury/lcet10.txt | 426754 | stdx 5 | 56.70 | 139.70 | 2.46 | 889.57 |
| canterbury/plrabn12.txt | 481861 | Google q1 | 19.30 | 32.57 | 1.69 | 252.81 |
| canterbury/plrabn12.txt | 481861 | stdx 1 | 20.81 | 46.66 | 2.24 | 472.68 |
| canterbury/plrabn12.txt | 481861 | Google q5 | 94.57 | 229.77 | 2.43 | 1064.00 |
| canterbury/plrabn12.txt | 481861 | stdx 5 | 70.40 | 167.86 | 2.38 | 1168.34 |
| canterbury/ptt5 | 513216 | Google q1 | 4.97 | 9.55 | 1.92 | 80.26 |
| canterbury/ptt5 | 513216 | stdx 1 | 6.65 | 15.64 | 2.35 | 159.94 |
| canterbury/ptt5 | 513216 | Google q5 | 27.20 | 68.87 | 2.53 | 467.61 |
| canterbury/ptt5 | 513216 | stdx 5 | 27.43 | 69.27 | 2.53 | 457.77 |
| canterbury/sum | 38240 | Google q1 | 12.63 | 29.25 | 2.31 | 91.28 |
| canterbury/sum | 38240 | stdx 1 | 15.57 | 36.37 | 2.34 | 407.07 |
| canterbury/sum | 38240 | Google q5 | 65.59 | 182.58 | 2.78 | 1091.04 |
| canterbury/sum | 38240 | stdx 5 | 55.37 | 155.87 | 2.81 | 828.75 |
| canterbury/xargs.1 | 4227 | Google q1 | 16.07 | 43.16 | 2.69 | 13.36 |
| canterbury/xargs.1 | 4227 | stdx 1 | 15.04 | 59.10 | 3.93 | 53.97 |
| canterbury/xargs.1 | 4227 | Google q5 | 71.33 | 219.02 | 3.07 | 748.92 |
| canterbury/xargs.1 | 4227 | stdx 5 | 43.98 | 155.91 | 3.55 | 295.16 |
| canterbury-large/E.coli | 4638690 | Google q1 | 13.50 | 27.46 | 2.03 | 53.57 |
| canterbury-large/E.coli | 4638690 | stdx 1 | 5.63 | 19.24 | 3.42 | 18.10 |
| canterbury-large/E.coli | 4638690 | Google q5 | 89.38 | 262.67 | 2.94 | 992.12 |
| canterbury-large/E.coli | 4638690 | stdx 5 | 30.59 | 93.11 | 3.04 | 64.88 |
| canterbury-large/bible.txt | 4047392 | Google q1 | 14.53 | 24.57 | 1.69 | 176.21 |
| canterbury-large/bible.txt | 4047392 | stdx 1 | 15.38 | 34.29 | 2.23 | 317.79 |
| canterbury-large/bible.txt | 4047392 | Google q5 | 75.32 | 165.65 | 2.20 | 729.05 |
| canterbury-large/bible.txt | 4047392 | stdx 5 | 56.55 | 134.78 | 2.38 | 800.85 |
| canterbury-large/world192.txt | 2473400 | Google q1 | 13.37 | 22.62 | 1.69 | 194.75 |
| canterbury-large/world192.txt | 2473400 | stdx 1 | 13.82 | 31.07 | 2.25 | 315.51 |
| canterbury-large/world192.txt | 2473400 | Google q5 | 63.59 | 129.46 | 2.04 | 739.52 |
| canterbury-large/world192.txt | 2473400 | stdx 5 | 46.11 | 105.74 | 2.29 | 749.84 |
| http/html-1kx1024 | 1048576 | Google q1 | 32.20 | 62.53 | 1.94 | 865.14 |
| http/html-1kx1024 | 1048576 | stdx 1 | 28.12 | 80.73 | 2.87 | 477.99 |
| http/html-1kx1024 | 1048576 | Google q5 | 106.59 | 260.90 | 2.45 | 2114.65 |
| http/html-1kx1024 | 1048576 | stdx 5 | 62.61 | 167.89 | 2.68 | 1111.78 |
| http/html-16kx64 | 1048576 | Google q1 | 11.17 | 20.38 | 1.82 | 215.60 |
| http/html-16kx64 | 1048576 | stdx 1 | 11.60 | 28.46 | 2.45 | 304.20 |
| http/html-16kx64 | 1048576 | Google q5 | 46.74 | 118.53 | 2.54 | 857.41 |
| http/html-16kx64 | 1048576 | stdx 5 | 35.67 | 92.10 | 2.58 | 638.40 |
| http/html-1m | 1048576 | Google q1 | 8.82 | 15.15 | 1.72 | 137.26 |
| http/html-1m | 1048576 | stdx 1 | 9.75 | 22.18 | 2.27 | 224.74 |
| http/html-1m | 1048576 | Google q5 | 44.15 | 104.93 | 2.38 | 574.29 |
| http/html-1m | 1048576 | stdx 5 | 33.32 | 84.11 | 2.52 | 532.41 |
| http/json-1kx1024 | 1048576 | Google q1 | 24.56 | 49.87 | 2.03 | 651.48 |
| http/json-1kx1024 | 1048576 | stdx 1 | 21.57 | 61.64 | 2.86 | 367.00 |
| http/json-1kx1024 | 1048576 | Google q5 | 79.62 | 203.15 | 2.55 | 1343.75 |
| http/json-1kx1024 | 1048576 | stdx 5 | 46.89 | 131.37 | 2.80 | 708.93 |
| http/json-16kx64 | 1048576 | Google q1 | 7.49 | 14.90 | 1.99 | 142.01 |
| http/json-16kx64 | 1048576 | stdx 1 | 7.06 | 19.73 | 2.80 | 159.60 |
| http/json-16kx64 | 1048576 | Google q5 | 35.96 | 97.81 | 2.72 | 559.19 |
| http/json-16kx64 | 1048576 | stdx 5 | 31.71 | 88.58 | 2.79 | 517.67 |
| http/json-1m | 1048576 | Google q1 | 6.09 | 12.65 | 2.08 | 91.78 |
| http/json-1m | 1048576 | stdx 1 | 6.65 | 17.21 | 2.59 | 140.93 |
| http/json-1m | 1048576 | Google q5 | 36.10 | 96.08 | 2.66 | 445.01 |
| http/json-1m | 1048576 | stdx 5 | 34.57 | 92.25 | 2.67 | 563.55 |
| http/js-1kx1024 | 1048576 | Google q1 | 34.75 | 68.18 | 1.96 | 906.91 |
| http/js-1kx1024 | 1048576 | stdx 1 | 31.10 | 90.40 | 2.91 | 538.35 |
| http/js-1kx1024 | 1048576 | Google q5 | 116.77 | 288.57 | 2.47 | 2302.35 |
| http/js-1kx1024 | 1048576 | stdx 5 | 69.29 | 186.45 | 2.69 | 1234.61 |
| http/js-16kx64 | 1048576 | Google q1 | 12.98 | 24.07 | 1.85 | 231.22 |
| http/js-16kx64 | 1048576 | stdx 1 | 13.46 | 32.69 | 2.43 | 356.50 |
| http/js-16kx64 | 1048576 | Google q5 | 54.67 | 141.15 | 2.58 | 996.64 |
| http/js-16kx64 | 1048576 | stdx 5 | 41.22 | 106.28 | 2.58 | 748.83 |
| http/js-1m | 1048576 | Google q1 | 9.54 | 16.69 | 1.75 | 140.26 |
| http/js-1m | 1048576 | stdx 1 | 10.16 | 23.55 | 2.32 | 229.45 |
| http/js-1m | 1048576 | Google q5 | 48.80 | 116.02 | 2.38 | 633.45 |
| http/js-1m | 1048576 | stdx 5 | 35.84 | 90.22 | 2.52 | 575.44 |
| http/css-1kx1024 | 1048576 | Google q1 | 27.53 | 54.06 | 1.96 | 728.37 |
| http/css-1kx1024 | 1048576 | stdx 1 | 24.12 | 68.32 | 2.83 | 433.71 |
| http/css-1kx1024 | 1048576 | Google q5 | 86.53 | 213.92 | 2.47 | 1660.88 |
| http/css-1kx1024 | 1048576 | stdx 5 | 50.54 | 137.20 | 2.71 | 882.17 |
| http/css-16kx64 | 1048576 | Google q1 | 8.83 | 16.85 | 1.91 | 141.17 |
| http/css-16kx64 | 1048576 | stdx 1 | 8.51 | 23.62 | 2.77 | 193.32 |
| http/css-16kx64 | 1048576 | Google q5 | 37.25 | 100.68 | 2.70 | 647.83 |
| http/css-16kx64 | 1048576 | stdx 5 | 28.71 | 80.59 | 2.81 | 485.10 |
| http/css-1m | 1048576 | Google q1 | 5.90 | 11.27 | 1.91 | 75.86 |
| http/css-1m | 1048576 | stdx 1 | 5.43 | 14.38 | 2.65 | 110.34 |
| http/css-1m | 1048576 | Google q5 | 14.16 | 38.50 | 2.72 | 130.31 |
| http/css-1m | 1048576 | stdx 5 | 11.55 | 36.69 | 3.18 | 110.19 |
| shuffled/dickens-1m | 1048576 | Google q1 | 11.33 | 20.96 | 1.85 | 2.85 |
| shuffled/dickens-1m | 1048576 | stdx 1 | 5.24 | 19.75 | 3.77 | 10.20 |
| shuffled/dickens-1m | 1048576 | Google q5 | 89.50 | 235.57 | 2.63 | 723.06 |
| shuffled/dickens-1m | 1048576 | stdx 5 | 40.35 | 122.09 | 3.03 | 202.78 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.5 | 74.2 | 0.119 | 3.01 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 65.8 | 219.6 | 0.086 | 7.77 | 3.34 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 30.6 | 96.1 | 0.166 | 3.62 | 3.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextReader.next_items | 28.3 | 80.8 | 0.153 | 3.35 | 2.85 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 250.0 | 1024.0 | 0.831 | 29.54 | 4.10 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.8 | 107.7 | 0.133 | 3.64 | 3.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.0 | 106.2 | 0.299 | 3.30 | 3.80 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 94.8 | 378.2 | 0.365 | 11.20 | 3.99 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 43.2 | 161.9 | 0.451 | 5.10 | 3.75 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 89.7 | 451.7 | 0.306 | 10.60 | 5.03 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 26.6 | 89.5 | 0.004 | 3.92 | 3.36 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 67.8 | 234.7 | 0.040 | 9.97 | 3.46 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 29.2 | 99.4 | 0.015 | 4.30 | 3.40 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextReader.next_items | 26.9 | 84.2 | 0.009 | 3.96 | 3.13 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 218.1 | 819.1 | 0.961 | 32.10 | 3.76 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.3 | 107.7 | 0.039 | 4.16 | 3.81 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 30.4 | 106.0 | 0.046 | 4.47 | 3.49 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 95.1 | 346.2 | 0.359 | 14.00 | 3.64 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 31.8 | 144.5 | 0.056 | 4.68 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 88.1 | 406.5 | 0.074 | 12.97 | 4.61 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 41.5 | 96.3 | 0.193 | 3.89 | 2.32 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 84.7 | 249.4 | 0.237 | 7.93 | 2.94 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 45.8 | 113.8 | 0.286 | 4.29 | 2.48 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextReader.next_items | 43.1 | 99.4 | 0.216 | 4.04 | 2.30 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 316.6 | 1284.6 | 1.063 | 29.65 | 4.06 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 36.4 | 133.1 | 0.187 | 3.41 | 3.65 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 46.6 | 128.6 | 0.704 | 4.36 | 2.76 |
| messages: 11 string members | 96000 | 1025025 | std.json | 123.2 | 451.2 | 1.031 | 11.54 | 3.66 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 66.6 | 204.1 | 0.987 | 6.24 | 3.06 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 134.6 | 572.0 | 0.829 | 12.61 | 4.25 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 24.3 | 78.8 | 0.017 | 3.04 | 3.25 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 67.0 | 239.5 | 0.008 | 8.39 | 3.57 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 28.0 | 93.3 | 0.044 | 3.51 | 3.33 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextReader.next_items | 26.0 | 78.0 | 0.036 | 3.25 | 3.00 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 233.0 | 942.3 | 0.410 | 29.17 | 4.04 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 28.4 | 107.6 | 0.060 | 3.55 | 3.79 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 25.7 | 104.8 | 0.022 | 3.22 | 4.08 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 88.0 | 361.0 | 0.028 | 11.02 | 4.10 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 32.5 | 151.6 | 0.033 | 4.07 | 4.66 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 79.1 | 418.3 | 0.008 | 9.90 | 5.29 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim on | 12.9 | 56.5 | 0.049 | 5.93 | 4.37 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, one token a call | 49.9 | 172.6 | 0.129 | 22.92 | 3.46 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, TextWriter's methods or TextReader.next | 16.5 | 73.4 | 0.079 | 7.55 | 4.46 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, TextReader.next_items | 13.9 | 57.7 | 0.050 | 6.36 | 4.16 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim off | 101.6 | 326.3 | 0.266 | 46.62 | 3.21 |
| messages: a tree of 341 objects | 281100 | 612600 | simdjson | 16.2 | 58.4 | 0.024 | 7.44 | 3.60 |
| messages: a tree of 341 objects | 281100 | 612600 | yyjson | 15.9 | 72.2 | 0.047 | 7.31 | 4.53 |
| messages: a tree of 341 objects | 281100 | 612600 | std.json | 55.7 | 220.1 | 0.120 | 25.58 | 3.95 |
| messages: a tree of 341 objects | 281100 | 612600 | serde_json | 13.9 | 59.5 | 0.091 | 6.37 | 4.29 |
| messages: a tree of 341 objects | 281100 | 612600 | Go jsontext | 43.7 | 216.0 | 0.115 | 20.06 | 4.94 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114154.9 | 403852.2 | 478.433 | 0.66 | 3.54 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 590342.3 | 2495394.2 | 1385.773 | 3.42 | 4.23 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 113632.0 | 404249.2 | 445.526 | 0.66 | 3.56 |
| string: silesia/dickens | 1 | 172528 | stdx, TextReader.next_items | 113607.6 | 404282.2 | 442.144 | 0.66 | 3.56 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3582921.1 | 18223882.2 | 2976.093 | 20.77 | 5.09 |
| string: silesia/dickens | 1 | 172528 | simdjson | 312240.6 | 621744.2 | 630.196 | 1.81 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 224348.4 | 826630.2 | 2192.144 | 1.30 | 3.68 |
| string: silesia/dickens | 1 | 172528 | std.json | 1570755.8 | 4578768.2 | 42307.474 | 9.10 | 2.92 |
| string: silesia/dickens | 1 | 172528 | serde_json | 204775.3 | 802909.2 | 985.526 | 1.19 | 3.92 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1054451.7 | 5279808.9 | 4866.619 | 6.11 | 5.01 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1563494.8 | 4799769.6 | 1436.429 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14154410.4 | 56410893.6 | 39634.786 | 11.89 | 3.99 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1562167.0 | 4799955.6 | 1342.286 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, TextReader.next_items | 1561099.9 | 4799988.6 | 1318.357 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 29121173.9 | 132108259.6 | 159430.000 | 24.47 | 4.54 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4588872.8 | 7062781.6 | 582.786 | 3.86 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1781277.4 | 7322029.6 | 14117.429 | 1.50 | 4.11 |
| string: http/json-1m | 1 | 1190272 | std.json | 10356147.9 | 47381157.6 | 32339.214 | 8.70 | 4.58 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3794447.4 | 15226584.6 | 6136.357 | 3.19 | 4.01 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9167241.9 | 48021689.1 | 27480.714 | 7.70 | 5.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2067561.5 | 5765419.8 | 4453.625 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6213827.6 | 22538840.8 | 8764.625 | 3.30 | 3.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2054548.3 | 5765605.8 | 3985.375 | 1.09 | 2.81 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextReader.next_items | 2052311.3 | 5765638.8 | 3849.375 | 1.09 | 2.81 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47437437.5 | 227842326.8 | 278996.625 | 25.19 | 4.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3768319.9 | 8446023.8 | 1943.125 | 2.00 | 2.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7150542.1 | 12276717.8 | 274320.375 | 3.80 | 1.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17454427.0 | 63617055.8 | 263848.750 | 9.27 | 3.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9525743.8 | 24440998.8 | 330284.625 | 5.06 | 2.57 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39146246.8 | 160315768.5 | 834108.000 | 20.79 | 4.10 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12928773.7 | 42561075.3 | 245021.000 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 160235370.3 | 666700955.3 | 393476.333 | 31.57 | 4.16 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12929511.0 | 42561261.3 | 244140.667 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextReader.next_items | 12872222.3 | 42561294.3 | 244207.000 | 2.54 | 3.31 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 160326930.0 | 639992668.3 | 423143.333 | 31.59 | 3.99 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17512004.3 | 49745820.3 | 250919.333 | 3.45 | 2.84 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14303681.7 | 45615166.3 | 434373.000 | 2.82 | 3.19 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79309862.3 | 314900845.3 | 458120.667 | 15.63 | 3.97 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36730295.7 | 131556418.3 | 586041.667 | 7.24 | 3.58 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66667752.0 | 273923190.3 | 842086.667 | 13.14 | 4.11 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 92399.9 | 303842.7 | 8.032 | 0.18 | 3.29 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 181573.4 | 623466.7 | 11.581 | 0.35 | 3.43 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 148462.4 | 557622.7 | 7.323 | 0.28 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextReader.next_items | 148363.0 | 557626.7 | 6.548 | 0.28 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10209488.0 | 53478208.7 | 9.129 | 19.47 | 5.24 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 489727.0 | 1376733.7 | 7.097 | 0.93 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 537127.4 | 2195917.7 | 10.710 | 1.02 | 4.09 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3531021.1 | 12808414.7 | 61268.258 | 6.73 | 3.63 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 288557.7 | 1179969.7 | 6.032 | 0.55 | 4.09 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2258599.7 | 12787266.9 | 249.194 | 4.31 | 5.66 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 20.0 | 81.8 | 0.110 | 2.36 | 4.10 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.3 | 153.5 | 0.126 | 4.17 | 4.35 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 21.7 | 96.1 | 0.091 | 2.56 | 4.43 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 220.9 | 981.0 | 0.929 | 26.10 | 4.44 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 19.0 | 79.5 | 0.109 | 2.25 | 4.18 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.1 | 94.1 | 0.135 | 2.72 | 4.08 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.3 | 105.6 | 0.247 | 3.22 | 3.87 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.6 | 310.8 | 0.370 | 8.22 | 4.47 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 65.8 | 255.3 | 0.521 | 7.77 | 3.88 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.1 | 315.1 | 0.239 | 8.05 | 4.62 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.8 | 82.8 | 0.024 | 2.76 | 4.41 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.2 | 153.9 | 0.025 | 5.32 | 4.25 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 22.3 | 95.7 | 0.023 | 3.28 | 4.30 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 171.4 | 718.3 | 1.269 | 25.23 | 4.19 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.2 | 81.5 | 0.025 | 2.68 | 4.47 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.8 | 96.8 | 0.032 | 3.21 | 4.44 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.0 | 117.9 | 0.033 | 4.27 | 4.07 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 60.8 | 271.2 | 0.276 | 8.95 | 4.46 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 49.8 | 212.7 | 0.036 | 7.33 | 4.27 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 81.2 | 331.7 | 0.091 | 11.95 | 4.08 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 32.7 | 85.9 | 0.397 | 3.06 | 2.63 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 42.9 | 151.2 | 0.409 | 4.02 | 3.52 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 28.4 | 92.4 | 0.389 | 2.66 | 3.25 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 286.7 | 1195.0 | 1.145 | 26.85 | 4.17 |
| messages: 11 string members | 96000 | 1025025 | stdx, J11's loop unchecked | 29.2 | 82.8 | 0.382 | 2.74 | 2.83 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 37.5 | 119.1 | 0.577 | 3.52 | 3.17 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 44.5 | 138.2 | 0.660 | 4.17 | 3.11 |
| messages: 11 string members | 96000 | 1025025 | std.json | 99.6 | 370.8 | 1.045 | 9.32 | 3.72 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 90.6 | 315.4 | 0.751 | 8.48 | 3.48 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 107.6 | 400.7 | 0.881 | 10.08 | 3.72 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 20.4 | 80.2 | 0.007 | 2.56 | 3.93 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 37.7 | 152.5 | 0.006 | 4.72 | 4.04 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 22.0 | 94.4 | 0.006 | 2.76 | 4.28 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 201.4 | 866.7 | 0.746 | 25.21 | 4.30 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, J11's loop unchecked | 20.0 | 79.4 | 0.007 | 2.51 | 3.97 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 23.3 | 96.6 | 0.004 | 2.92 | 4.15 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 24.9 | 101.3 | 0.018 | 3.12 | 4.06 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 59.0 | 279.4 | 0.006 | 7.39 | 4.73 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 53.5 | 230.6 | 0.047 | 6.70 | 4.31 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 68.5 | 310.8 | 0.006 | 8.57 | 4.54 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim on | 16.1 | 62.6 | 0.023 | 7.40 | 3.88 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, one token a call | 31.9 | 135.7 | 0.031 | 14.63 | 4.25 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, TextWriter's methods or TextReader.next | 15.3 | 64.2 | 0.040 | 7.02 | 4.19 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim off | 81.3 | 375.6 | 0.235 | 37.32 | 4.62 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, J11's loop unchecked | 14.9 | 61.4 | 0.023 | 6.85 | 4.11 |
| messages: a tree of 341 objects | 281100 | 612600 | simdjson | 12.2 | 45.5 | 0.023 | 5.61 | 3.72 |
| messages: a tree of 341 objects | 281100 | 612600 | yyjson | 15.6 | 56.5 | 0.053 | 7.15 | 3.62 |
| messages: a tree of 341 objects | 281100 | 612600 | std.json | 27.9 | 125.4 | 0.045 | 12.82 | 4.49 |
| messages: a tree of 341 objects | 281100 | 612600 | serde_json | 23.5 | 102.3 | 0.028 | 10.78 | 4.36 |
| messages: a tree of 341 objects | 281100 | 612600 | Go jsontext | 41.7 | 181.3 | 0.119 | 19.12 | 4.35 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 85062.4 | 280786.2 | 728.619 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84846.5 | 280732.2 | 717.907 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84936.4 | 280730.2 | 719.361 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3366083.8 | 16047574.2 | 2945.948 | 19.51 | 4.77 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 82669.4 | 274401.2 | 644.000 | 0.48 | 3.32 |
| string: silesia/dickens | 1 | 172528 | simdjson | 208291.0 | 674016.2 | 2110.907 | 1.21 | 3.24 |
| string: silesia/dickens | 1 | 172528 | yyjson | 202451.2 | 825518.2 | 971.629 | 1.17 | 4.08 |
| string: silesia/dickens | 1 | 172528 | std.json | 1379860.3 | 2890892.2 | 55006.196 | 8.00 | 2.10 |
| string: silesia/dickens | 1 | 172528 | serde_json | 390024.8 | 1586249.2 | 2541.979 | 2.26 | 4.07 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 585383.3 | 2970286.9 | 2864.330 | 3.39 | 5.07 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1277752.2 | 3582350.6 | 11602.286 | 1.07 | 2.80 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1266332.9 | 3582290.6 | 11132.357 | 1.06 | 2.83 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1265704.1 | 3582286.6 | 11077.571 | 1.06 | 2.83 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25308818.2 | 109856348.6 | 141580.143 | 21.26 | 4.34 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1238073.2 | 3370022.6 | 11211.143 | 1.04 | 2.72 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2968095.6 | 10460762.6 | 29360.714 | 2.49 | 3.52 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2589632.1 | 10197931.6 | 9861.000 | 2.18 | 3.94 |
| string: http/json-1m | 1 | 1190272 | std.json | 8966855.0 | 43287986.6 | 16539.500 | 7.53 | 4.83 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4275207.6 | 17941088.6 | 10901.214 | 3.59 | 4.20 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5237405.4 | 26999739.9 | 11667.429 | 4.40 | 5.16 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2073013.3 | 6088099.8 | 4638.000 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2064331.0 | 6088043.8 | 4163.750 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2062831.3 | 6088035.8 | 4068.500 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43513141.6 | 193466553.8 | 261203.000 | 23.11 | 4.45 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2071818.0 | 5875346.8 | 4648.500 | 1.10 | 2.84 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2709079.6 | 7144143.8 | 21022.250 | 1.44 | 2.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12184482.0 | 23590602.8 | 448221.250 | 6.47 | 1.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20669929.6 | 56837736.8 | 551728.625 | 10.98 | 2.75 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11528855.8 | 33662338.8 | 334457.750 | 6.12 | 2.92 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18347364.4 | 76319358.0 | 256043.375 | 9.74 | 4.16 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113357.6 | 426376.7 | 2.516 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113077.8 | 426318.7 | 2.161 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113168.8 | 426311.7 | 2.452 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 638665.7 | 3146479.7 | 7.323 | 1.22 | 4.93 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113292.5 | 426343.7 | 2.323 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1198068.7 | 3866916.7 | 5.129 | 2.29 | 3.23 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1622237.8 | 5833341.7 | 7.226 | 3.09 | 3.60 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3561507.0 | 13108830.7 | 78035.129 | 6.79 | 3.68 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1886406.5 | 7405810.7 | 4.645 | 3.60 | 3.93 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2383490.8 | 12748343.6 | 14.065 | 4.55 | 5.35 |
