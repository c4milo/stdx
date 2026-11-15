# bench-profile

| Field | Value |
|---|---|
| Commit | d49e5bd |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43668096898 |
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
| silesia/dickens | 10192446 | zlib | 8.80 | 19.08 | 2.17 | 310.43 |
| silesia/dickens | 10192446 | zlib-ng | 4.87 | 10.50 | 2.16 | 67.72 |
| silesia/dickens | 10192446 | libdeflate | 3.45 | 9.56 | 2.77 | 65.95 |
| silesia/dickens | 10192446 | Wuffs | 5.53 | 13.90 | 2.51 | 97.14 |
| silesia/dickens | 10192446 | stdx | 2.93 | 7.15 | 2.44 | 75.88 |
| silesia/mozilla | 51220480 | zlib | 8.47 | 17.23 | 2.03 | 251.82 |
| silesia/mozilla | 51220480 | zlib-ng | 4.94 | 8.95 | 1.81 | 85.50 |
| silesia/mozilla | 51220480 | libdeflate | 3.47 | 7.63 | 2.20 | 71.13 |
| silesia/mozilla | 51220480 | Wuffs | 6.40 | 13.89 | 2.17 | 132.68 |
| silesia/mozilla | 51220480 | stdx | 3.64 | 6.29 | 1.72 | 89.58 |
| silesia/mr | 9970564 | zlib | 8.37 | 18.46 | 2.20 | 203.23 |
| silesia/mr | 9970564 | zlib-ng | 4.80 | 9.98 | 2.08 | 67.91 |
| silesia/mr | 9970564 | libdeflate | 3.34 | 8.58 | 2.57 | 61.14 |
| silesia/mr | 9970564 | Wuffs | 5.98 | 14.04 | 2.35 | 99.84 |
| silesia/mr | 9970564 | stdx | 3.07 | 6.70 | 2.18 | 69.88 |
| silesia/nci | 33553445 | zlib | 3.54 | 10.18 | 2.88 | 81.03 |
| silesia/nci | 33553445 | zlib-ng | 1.58 | 3.13 | 1.98 | 33.81 |
| silesia/nci | 33553445 | libdeflate | 1.13 | 2.66 | 2.35 | 29.73 |
| silesia/nci | 33553445 | Wuffs | 2.45 | 6.47 | 2.64 | 41.53 |
| silesia/nci | 33553445 | stdx | 1.15 | 2.20 | 1.92 | 37.54 |
| silesia/ooffice | 6152192 | zlib | 11.78 | 21.06 | 1.79 | 417.99 |
| silesia/ooffice | 6152192 | zlib-ng | 6.91 | 12.04 | 1.74 | 140.98 |
| silesia/ooffice | 6152192 | libdeflate | 4.90 | 10.45 | 2.13 | 125.05 |
| silesia/ooffice | 6152192 | Wuffs | 8.82 | 17.54 | 1.99 | 220.59 |
| silesia/ooffice | 6152192 | stdx | 5.06 | 8.55 | 1.69 | 151.16 |
| silesia/osdb | 10085684 | zlib | 7.46 | 16.59 | 2.22 | 183.01 |
| silesia/osdb | 10085684 | zlib-ng | 4.29 | 8.38 | 1.95 | 53.04 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.91 | 2.43 | 29.73 |
| silesia/osdb | 10085684 | Wuffs | 5.79 | 13.61 | 2.35 | 78.21 |
| silesia/osdb | 10085684 | stdx | 2.77 | 5.65 | 2.04 | 40.54 |
| silesia/reymont | 6627202 | zlib | 7.38 | 15.89 | 2.15 | 261.22 |
| silesia/reymont | 6627202 | zlib-ng | 3.70 | 7.72 | 2.09 | 59.58 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.64 | 51.63 |
| silesia/reymont | 6627202 | Wuffs | 4.90 | 11.40 | 2.33 | 113.71 |
| silesia/reymont | 6627202 | stdx | 2.29 | 5.11 | 2.24 | 64.56 |
| silesia/samba | 21606400 | zlib | 6.10 | 14.13 | 2.31 | 175.43 |
| silesia/samba | 21606400 | zlib-ng | 3.35 | 6.47 | 1.93 | 55.96 |
| silesia/samba | 21606400 | libdeflate | 2.31 | 5.58 | 2.42 | 42.90 |
| silesia/samba | 21606400 | Wuffs | 4.32 | 10.39 | 2.41 | 79.75 |
| silesia/samba | 21606400 | stdx | 2.25 | 4.46 | 1.99 | 56.30 |
| silesia/sao | 7251944 | zlib | 10.49 | 23.54 | 2.25 | 203.74 |
| silesia/sao | 7251944 | zlib-ng | 7.84 | 14.83 | 1.89 | 79.50 |
| silesia/sao | 7251944 | libdeflate | 5.73 | 12.73 | 2.22 | 79.02 |
| silesia/sao | 7251944 | Wuffs | 8.89 | 21.26 | 2.39 | 86.44 |
| silesia/sao | 7251944 | stdx | 5.55 | 10.32 | 1.86 | 87.09 |
| silesia/webster | 41458703 | zlib | 7.78 | 16.16 | 2.08 | 281.95 |
| silesia/webster | 41458703 | zlib-ng | 4.21 | 8.04 | 1.91 | 84.97 |
| silesia/webster | 41458703 | libdeflate | 2.89 | 7.17 | 2.48 | 68.35 |
| silesia/webster | 41458703 | Wuffs | 5.14 | 11.67 | 2.27 | 122.09 |
| silesia/webster | 41458703 | stdx | 2.80 | 5.56 | 1.99 | 86.97 |
| silesia/x-ray | 8474240 | zlib | 12.86 | 27.21 | 2.12 | 329.32 |
| silesia/x-ray | 8474240 | zlib-ng | 9.02 | 17.39 | 1.93 | 124.09 |
| silesia/x-ray | 8474240 | libdeflate | 6.53 | 15.26 | 2.34 | 124.49 |
| silesia/x-ray | 8474240 | Wuffs | 10.79 | 23.52 | 2.18 | 190.80 |
| silesia/x-ray | 8474240 | stdx | 6.11 | 11.49 | 1.88 | 138.16 |
| silesia/xml | 5345280 | zlib | 4.22 | 11.16 | 2.65 | 118.19 |
| silesia/xml | 5345280 | zlib-ng | 1.99 | 3.88 | 1.96 | 42.86 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.44 | 31.94 |
| silesia/xml | 5345280 | Wuffs | 2.84 | 7.22 | 2.54 | 59.05 |
| silesia/xml | 5345280 | stdx | 1.33 | 2.65 | 1.99 | 41.82 |
| canterbury/alice29.txt | 152089 | zlib | 8.43 | 18.35 | 2.18 | 293.78 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.52 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.18 | 8.96 | 2.81 | 54.81 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.38 | 13.40 | 2.49 | 98.78 |
| canterbury/alice29.txt | 152089 | stdx | 2.71 | 6.99 | 2.57 | 63.03 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.03 | 19.42 | 2.15 | 314.75 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.09 | 10.86 | 2.14 | 73.11 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.59 | 9.82 | 2.74 | 67.13 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.76 | 14.40 | 2.50 | 99.73 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.04 | 7.52 | 2.47 | 75.47 |
| canterbury/cp.html | 24603 | zlib | 7.07 | 17.33 | 2.45 | 171.52 |
| canterbury/cp.html | 24603 | zlib-ng | 4.21 | 9.50 | 2.26 | 38.93 |
| canterbury/cp.html | 24603 | libdeflate | 2.76 | 7.95 | 2.88 | 7.38 |
| canterbury/cp.html | 24603 | Wuffs | 5.14 | 13.91 | 2.71 | 55.12 |
| canterbury/cp.html | 24603 | stdx | 2.65 | 7.19 | 2.71 | 13.26 |
| canterbury/fields.c | 11150 | zlib | 5.29 | 17.73 | 3.35 | 38.10 |
| canterbury/fields.c | 11150 | zlib-ng | 3.86 | 10.20 | 2.64 | 13.49 |
| canterbury/fields.c | 11150 | libdeflate | 2.79 | 8.32 | 2.98 | 1.08 |
| canterbury/fields.c | 11150 | Wuffs | 4.52 | 14.54 | 3.22 | 9.25 |
| canterbury/fields.c | 11150 | stdx | 2.49 | 7.64 | 3.07 | 3.95 |
| canterbury/grammar.lsp | 3721 | zlib | 6.88 | 24.26 | 3.53 | 5.90 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.84 | 17.48 | 2.99 | 8.62 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.41 | 12.05 | 2.73 | 0.72 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.68 | 21.86 | 3.27 | 4.79 |
| canterbury/grammar.lsp | 3721 | stdx | 3.85 | 12.18 | 3.16 | 1.61 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.58 | 15.27 | 3.33 | 48.29 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.54 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.05 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.86 | 11.59 | 3.00 | 14.80 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.76 | 4.66 | 2.65 | 16.73 |
| canterbury/lcet10.txt | 426754 | zlib | 8.20 | 17.78 | 2.17 | 290.41 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.17 | 60.80 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.04 | 8.48 | 2.79 | 55.69 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.23 | 12.88 | 2.46 | 101.61 |
| canterbury/lcet10.txt | 426754 | stdx | 2.60 | 6.42 | 2.47 | 66.70 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.20 | 19.86 | 2.16 | 320.82 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.30 | 11.19 | 2.11 | 79.23 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.78 | 10.19 | 2.70 | 77.67 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.82 | 14.61 | 2.51 | 99.06 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.14 | 7.63 | 2.43 | 84.33 |
| canterbury/ptt5 | 513216 | zlib | 5.06 | 10.71 | 2.12 | 103.51 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.66 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.08 | 38.34 |
| canterbury/ptt5 | 513216 | Wuffs | 3.00 | 7.13 | 2.38 | 57.41 |
| canterbury/ptt5 | 513216 | stdx | 1.44 | 2.55 | 1.77 | 48.79 |
| canterbury/sum | 38240 | zlib | 7.99 | 18.12 | 2.27 | 223.78 |
| canterbury/sum | 38240 | zlib-ng | 4.63 | 10.02 | 2.16 | 56.35 |
| canterbury/sum | 38240 | libdeflate | 3.23 | 8.34 | 2.58 | 27.79 |
| canterbury/sum | 38240 | Wuffs | 5.79 | 14.47 | 2.50 | 82.42 |
| canterbury/sum | 38240 | stdx | 3.01 | 7.73 | 2.57 | 28.10 |
| canterbury/xargs.1 | 4227 | zlib | 7.42 | 25.22 | 3.40 | 12.43 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.37 | 17.97 | 2.82 | 9.94 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.76 | 13.27 | 2.79 | 0.43 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.22 | 22.63 | 3.13 | 11.01 |
| canterbury/xargs.1 | 4227 | stdx | 4.22 | 12.86 | 3.05 | 0.97 |
| canterbury-large/E.coli | 4638690 | zlib | 6.76 | 17.84 | 2.64 | 177.65 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.23 | 9.68 | 2.29 | 47.35 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.36 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.66 | 12.73 | 2.73 | 61.75 |
| canterbury-large/E.coli | 4638690 | stdx | 2.47 | 6.72 | 2.72 | 53.91 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.52 | 16.46 | 2.19 | 267.54 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.77 | 8.26 | 2.19 | 53.88 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.84 | 45.57 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.80 | 11.73 | 2.44 | 100.37 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.24 | 5.57 | 2.49 | 55.82 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.72 | 15.84 | 2.05 | 282.71 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.19 | 7.78 | 1.86 | 91.46 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.07 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.18 | 11.48 | 2.22 | 128.30 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 5.40 | 1.98 | 90.36 |
| http/html-1kx1024 | 1048576 | zlib | 16.70 | 35.58 | 2.13 | 352.67 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.69 | 28.43 | 2.24 | 217.08 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.59 | 20.05 | 1.89 | 155.68 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.38 | 38.07 | 2.47 | 266.28 |
| http/html-1kx1024 | 1048576 | stdx | 8.38 | 20.88 | 2.49 | 137.51 |
| http/html-16kx64 | 1048576 | zlib | 6.73 | 14.77 | 2.20 | 221.31 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.59 |
| http/html-16kx64 | 1048576 | libdeflate | 2.64 | 6.04 | 2.29 | 60.61 |
| http/html-16kx64 | 1048576 | Wuffs | 4.92 | 11.57 | 2.35 | 114.98 |
| http/html-16kx64 | 1048576 | stdx | 2.52 | 5.56 | 2.21 | 59.06 |
| http/html-1m | 1048576 | zlib | 5.31 | 12.53 | 2.36 | 175.57 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 60.21 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.44 |
| http/html-1m | 1048576 | Wuffs | 3.61 | 8.48 | 2.35 | 87.94 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.11 | 52.87 |
| http/json-1kx1024 | 1048576 | zlib | 10.61 | 23.92 | 2.25 | 193.03 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.25 | 130.93 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.85 | 16.72 | 1.89 | 92.13 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.16 | 34.78 | 2.86 | 146.26 |
| http/json-1kx1024 | 1048576 | stdx | 5.03 | 13.12 | 2.61 | 81.04 |
| http/json-16kx64 | 1048576 | zlib | 4.57 | 12.51 | 2.74 | 103.12 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.93 |
| http/json-16kx64 | 1048576 | libdeflate | 1.92 | 4.24 | 2.21 | 40.48 |
| http/json-16kx64 | 1048576 | Wuffs | 3.50 | 9.43 | 2.69 | 58.27 |
| http/json-16kx64 | 1048576 | stdx | 1.75 | 3.97 | 2.26 | 39.26 |
| http/json-1m | 1048576 | zlib | 3.85 | 11.20 | 2.91 | 83.10 |
| http/json-1m | 1048576 | zlib-ng | 1.94 | 3.91 | 2.01 | 37.39 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.40 | 32.88 |
| http/json-1m | 1048576 | Wuffs | 2.73 | 7.37 | 2.70 | 43.55 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.02 | 39.99 |
| http/js-1kx1024 | 1048576 | zlib | 18.25 | 38.46 | 2.11 | 410.81 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.78 | 31.25 | 2.27 | 238.23 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.27 | 21.58 | 1.92 | 178.87 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.55 | 40.70 | 2.46 | 299.82 |
| http/js-1kx1024 | 1048576 | stdx | 9.26 | 22.85 | 2.47 | 158.91 |
| http/js-16kx64 | 1048576 | zlib | 7.68 | 16.08 | 2.09 | 265.30 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.97 | 91.94 |
| http/js-16kx64 | 1048576 | libdeflate | 3.06 | 7.01 | 2.29 | 71.94 |
| http/js-16kx64 | 1048576 | Wuffs | 5.50 | 12.75 | 2.32 | 128.77 |
| http/js-16kx64 | 1048576 | stdx | 2.98 | 6.54 | 2.19 | 71.57 |
| http/js-1m | 1048576 | zlib | 5.85 | 13.31 | 2.27 | 200.32 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 60.30 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.94 |
| http/js-1m | 1048576 | Wuffs | 3.90 | 9.14 | 2.34 | 93.63 |
| http/js-1m | 1048576 | stdx | 1.81 | 3.89 | 2.15 | 55.88 |
| http/css-1kx1024 | 1048576 | zlib | 14.04 | 30.36 | 2.16 | 280.62 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.27 | 23.04 | 2.24 | 171.79 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.17 | 17.37 | 1.89 | 121.21 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.79 | 32.50 | 2.54 | 211.21 |
| http/css-1kx1024 | 1048576 | stdx | 6.67 | 17.64 | 2.64 | 100.70 |
| http/css-16kx64 | 1048576 | zlib | 5.33 | 13.04 | 2.45 | 154.63 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.79 | 6.07 | 2.18 | 50.12 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 29.92 |
| http/css-16kx64 | 1048576 | Wuffs | 3.79 | 10.01 | 2.64 | 69.51 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.54 | 28.02 |
| http/css-1m | 1048576 | zlib | 3.97 | 10.97 | 2.76 | 107.32 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.21 | 28.90 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.97 | 12.78 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.77 | 43.66 |
| http/css-1m | 1048576 | stdx | 1.02 | 2.56 | 2.51 | 21.28 |
| shuffled/dickens-1m | 1048576 | zlib | 13.29 | 25.88 | 1.95 | 372.92 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.70 | 16.72 | 1.72 | 195.77 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.03 | 14.95 | 2.13 | 192.81 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.44 | 22.08 | 2.11 | 201.84 |
| shuffled/dickens-1m | 1048576 | stdx | 7.05 | 11.89 | 1.69 | 205.53 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.55 | 14.05 | 3.95 | 3.42 |
| silesia/dickens | 10192446 | stdx | 3.70 | 12.47 | 3.37 | 3.86 |
| silesia/mozilla | 51220480 | libzstd | 2.83 | 9.68 | 3.42 | 30.15 |
| silesia/mozilla | 51220480 | stdx | 2.77 | 9.68 | 3.50 | 15.84 |
| silesia/mr | 9970564 | libzstd | 3.00 | 11.99 | 4.00 | 6.09 |
| silesia/mr | 9970564 | stdx | 3.05 | 10.83 | 3.55 | 5.24 |
| silesia/nci | 33553445 | libzstd | 1.63 | 4.88 | 3.00 | 24.78 |
| silesia/nci | 33553445 | stdx | 1.62 | 4.63 | 2.85 | 13.71 |
| silesia/ooffice | 6152192 | libzstd | 3.35 | 12.19 | 3.64 | 31.03 |
| silesia/ooffice | 6152192 | stdx | 3.33 | 12.40 | 3.73 | 12.35 |
| silesia/osdb | 10085684 | libzstd | 2.40 | 8.45 | 3.52 | 14.89 |
| silesia/osdb | 10085684 | stdx | 2.45 | 8.11 | 3.31 | 15.36 |
| silesia/reymont | 6627202 | libzstd | 3.28 | 11.62 | 3.54 | 11.49 |
| silesia/reymont | 6627202 | stdx | 3.40 | 10.36 | 3.05 | 13.05 |
| silesia/samba | 21606400 | libzstd | 2.09 | 7.41 | 3.54 | 18.58 |
| silesia/samba | 21606400 | stdx | 2.15 | 6.83 | 3.18 | 18.00 |
| silesia/sao | 7251944 | libzstd | 3.76 | 12.72 | 3.38 | 26.47 |
| silesia/sao | 7251944 | stdx | 3.46 | 12.58 | 3.64 | 6.08 |
| silesia/webster | 41458703 | libzstd | 3.21 | 11.24 | 3.50 | 16.13 |
| silesia/webster | 41458703 | stdx | 3.30 | 10.05 | 3.05 | 17.72 |
| silesia/x-ray | 8474240 | libzstd | 3.88 | 14.94 | 3.85 | 18.98 |
| silesia/x-ray | 8474240 | stdx | 3.54 | 13.23 | 3.74 | 8.52 |
| silesia/xml | 5345280 | libzstd | 1.55 | 5.57 | 3.58 | 23.27 |
| silesia/xml | 5345280 | stdx | 1.53 | 5.16 | 3.38 | 17.22 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.90 | 4.12 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.35 | 0.59 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.95 | 14.26 | 4.84 | 3.26 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.29 | 0.26 |
| canterbury/cp.html | 24603 | libzstd | 2.63 | 10.74 | 4.08 | 7.67 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.10 | 0.22 |
| canterbury/fields.c | 11150 | libzstd | 3.11 | 13.62 | 4.38 | 9.03 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.23 | 0.18 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.19 | 16.94 | 4.05 | 4.93 |
| canterbury/grammar.lsp | 3721 | stdx | 4.13 | 16.54 | 4.00 | 0.18 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.54 | 11.40 | 4.49 | 7.79 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.24 | 0.87 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.70 | 12.89 | 4.77 | 5.16 |
| canterbury/lcet10.txt | 426754 | stdx | 2.74 | 11.52 | 4.20 | 4.52 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.10 | 15.16 | 4.90 | 1.51 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.26 | 1.03 |
| canterbury/ptt5 | 513216 | libzstd | 1.46 | 4.52 | 3.10 | 24.77 |
| canterbury/ptt5 | 513216 | stdx | 1.34 | 4.46 | 3.32 | 13.13 |
| canterbury/sum | 38240 | libzstd | 2.62 | 10.58 | 4.04 | 10.16 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.09 | 0.37 |
| canterbury/xargs.1 | 4227 | libzstd | 4.25 | 17.41 | 4.10 | 9.20 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.17 | 4.05 | 0.20 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.02 | 13.64 | 4.52 | 2.05 |
| canterbury-large/E.coli | 4638690 | stdx | 3.13 | 12.04 | 3.84 | 2.88 |
| canterbury-large/bible.txt | 4047392 | libzstd | 3.01 | 12.00 | 3.99 | 8.38 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.11 | 10.64 | 3.42 | 9.80 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.63 | 9.60 | 3.65 | 19.82 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.70 | 8.64 | 3.20 | 21.23 |
| http/html-1kx1024 | 1048576 | libzstd | 7.24 | 21.63 | 2.99 | 62.95 |
| http/html-1kx1024 | 1048576 | stdx | 7.46 | 22.46 | 3.01 | 76.52 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.50 |
| http/html-16kx64 | 1048576 | stdx | 2.68 | 9.61 | 3.59 | 31.17 |
| http/html-1m | 1048576 | libzstd | 2.02 | 7.88 | 3.90 | 23.90 |
| http/html-1m | 1048576 | stdx | 2.01 | 7.12 | 3.54 | 25.06 |
| http/json-1kx1024 | 1048576 | libzstd | 6.27 | 17.39 | 2.77 | 49.47 |
| http/json-1kx1024 | 1048576 | stdx | 6.20 | 17.86 | 2.88 | 53.66 |
| http/json-16kx64 | 1048576 | libzstd | 2.06 | 7.26 | 3.53 | 28.53 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 19.81 |
| http/json-1m | 1048576 | libzstd | 1.73 | 6.08 | 3.51 | 27.94 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.61 | 14.16 |
| http/js-1kx1024 | 1048576 | libzstd | 8.33 | 26.35 | 3.16 | 73.57 |
| http/js-1kx1024 | 1048576 | stdx | 9.03 | 27.60 | 3.05 | 113.81 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.72 | 4.00 | 24.30 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.73 | 26.67 |
| http/js-1m | 1048576 | libzstd | 2.05 | 8.19 | 3.99 | 20.04 |
| http/js-1m | 1048576 | stdx | 2.10 | 7.48 | 3.56 | 21.54 |
| http/css-1kx1024 | 1048576 | libzstd | 6.88 | 19.69 | 2.86 | 53.66 |
| http/css-1kx1024 | 1048576 | stdx | 6.83 | 19.96 | 2.92 | 63.60 |
| http/css-16kx64 | 1048576 | libzstd | 2.25 | 8.70 | 3.87 | 23.12 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.32 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.58 | 3.86 | 5.47 |
| http/css-1m | 1048576 | stdx | 0.72 | 2.49 | 3.48 | 4.41 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.77 | 9.40 | 3.39 | 28.37 |
| shuffled/dickens-1m | 1048576 | stdx | 2.77 | 9.19 | 3.32 | 12.74 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.64 | 16.93 | 2.21 | 99.81 |
| silesia/dickens | 1048576 | stdx | 5.16 | 12.38 | 2.40 | 54.63 |
| silesia/mozilla | 1048576 | Google | 13.48 | 28.31 | 2.10 | 47.73 |
| silesia/mozilla | 1048576 | stdx | 8.32 | 15.02 | 1.81 | 47.07 |
| silesia/mr | 1048576 | Google | 8.97 | 20.21 | 2.25 | 103.47 |
| silesia/mr | 1048576 | stdx | 5.81 | 13.25 | 2.28 | 88.20 |
| silesia/nci | 1048576 | Google | 2.57 | 5.70 | 2.22 | 52.29 |
| silesia/nci | 1048576 | stdx | 1.97 | 3.95 | 2.00 | 55.90 |
| silesia/ooffice | 1048576 | Google | 14.29 | 29.27 | 2.05 | 289.22 |
| silesia/ooffice | 1048576 | stdx | 11.11 | 20.33 | 1.83 | 324.14 |
| silesia/osdb | 1048576 | Google | 8.31 | 17.48 | 2.10 | 97.05 |
| silesia/osdb | 1048576 | stdx | 5.17 | 10.57 | 2.05 | 91.71 |
| silesia/reymont | 1048576 | Google | 5.51 | 12.62 | 2.29 | 82.56 |
| silesia/reymont | 1048576 | stdx | 3.86 | 9.25 | 2.40 | 47.74 |
| silesia/samba | 1048576 | Google | 7.59 | 16.30 | 2.15 | 95.15 |
| silesia/samba | 1048576 | stdx | 5.23 | 10.71 | 2.05 | 66.63 |
| silesia/sao | 1048576 | Google | 16.94 | 37.18 | 2.20 | 167.93 |
| silesia/sao | 1048576 | stdx | 10.51 | 22.65 | 2.15 | 141.15 |
| silesia/webster | 1048576 | Google | 6.65 | 14.00 | 2.10 | 113.71 |
| silesia/webster | 1048576 | stdx | 4.49 | 9.98 | 2.22 | 69.27 |
| silesia/x-ray | 1048576 | Google | 19.51 | 38.56 | 1.98 | 235.88 |
| silesia/x-ray | 1048576 | stdx | 14.61 | 30.18 | 2.07 | 235.01 |
| silesia/xml | 1048576 | Google | 3.46 | 7.61 | 2.20 | 65.37 |
| silesia/xml | 1048576 | stdx | 2.42 | 5.40 | 2.23 | 47.13 |
| canterbury/alice29.txt | 152089 | Google | 8.84 | 20.55 | 2.32 | 133.50 |
| canterbury/alice29.txt | 152089 | stdx | 6.07 | 15.33 | 2.53 | 80.46 |
| canterbury/asyoulik.txt | 125179 | Google | 10.35 | 23.71 | 2.29 | 166.80 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.09 | 17.43 | 2.46 | 104.94 |
| canterbury/cp.html | 24603 | Google | 9.07 | 22.20 | 2.45 | 116.05 |
| canterbury/cp.html | 24603 | stdx | 5.66 | 17.15 | 3.03 | 28.24 |
| canterbury/fields.c | 11150 | Google | 7.19 | 21.16 | 2.95 | 33.71 |
| canterbury/fields.c | 11150 | stdx | 4.89 | 17.08 | 3.49 | 1.89 |
| canterbury/grammar.lsp | 3721 | Google | 9.83 | 30.16 | 3.07 | 7.15 |
| canterbury/grammar.lsp | 3721 | stdx | 7.15 | 25.04 | 3.50 | 0.41 |
| canterbury/kennedy.xls | 1029744 | Google | 5.45 | 17.05 | 3.13 | 37.49 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.81 | 12.94 | 3.39 | 33.94 |
| canterbury/lcet10.txt | 426754 | Google | 7.80 | 17.36 | 2.22 | 125.02 |
| canterbury/lcet10.txt | 426754 | stdx | 5.22 | 12.96 | 2.48 | 66.36 |
| canterbury/plrabn12.txt | 481861 | Google | 9.14 | 20.82 | 2.28 | 132.47 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.22 | 15.04 | 2.42 | 87.73 |
| canterbury/ptt5 | 513216 | Google | 4.29 | 10.41 | 2.43 | 62.41 |
| canterbury/ptt5 | 513216 | stdx | 2.38 | 4.89 | 2.06 | 66.40 |
| canterbury/sum | 38240 | Google | 10.89 | 26.44 | 2.43 | 159.66 |
| canterbury/sum | 38240 | stdx | 8.40 | 21.11 | 2.51 | 162.06 |
| canterbury/xargs.1 | 4227 | Google | 11.03 | 34.81 | 3.15 | 13.24 |
| canterbury/xargs.1 | 4227 | stdx | 8.50 | 30.44 | 3.58 | 6.15 |
| canterbury-large/E.coli | 1048576 | Google | 8.14 | 19.55 | 2.40 | 1.42 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.28 |
| canterbury-large/bible.txt | 1048576 | Google | 5.39 | 12.28 | 2.28 | 80.91 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.55 | 8.93 | 2.51 | 39.63 |
| canterbury-large/world192.txt | 1048576 | Google | 6.28 | 12.84 | 2.05 | 114.48 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.45 | 9.38 | 2.11 | 77.41 |
| http/html-1kx1024 | 1048576 | Google | 18.02 | 41.93 | 2.33 | 387.63 |
| http/html-1kx1024 | 1048576 | stdx | 15.31 | 37.56 | 2.45 | 360.59 |
| http/html-16kx64 | 1048576 | Google | 6.74 | 14.85 | 2.20 | 149.02 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.75 |
| http/html-1m | 1048576 | Google | 4.08 | 8.94 | 2.19 | 83.14 |
| http/html-1m | 1048576 | stdx | 2.87 | 6.52 | 2.28 | 54.68 |
| http/json-1kx1024 | 1048576 | Google | 14.46 | 36.64 | 2.53 | 241.19 |
| http/json-1kx1024 | 1048576 | stdx | 13.00 | 33.63 | 2.59 | 277.64 |
| http/json-16kx64 | 1048576 | Google | 4.43 | 11.43 | 2.58 | 82.68 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.83 |
| http/json-1m | 1048576 | Google | 3.41 | 8.65 | 2.53 | 60.08 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.44 | 57.64 |
| http/js-1kx1024 | 1048576 | Google | 19.91 | 46.20 | 2.32 | 425.76 |
| http/js-1kx1024 | 1048576 | stdx | 16.40 | 39.90 | 2.43 | 379.32 |
| http/js-16kx64 | 1048576 | Google | 8.03 | 17.73 | 2.21 | 166.56 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.89 |
| http/js-1m | 1048576 | Google | 4.39 | 9.54 | 2.17 | 82.64 |
| http/js-1m | 1048576 | stdx | 3.18 | 7.25 | 2.28 | 55.60 |
| http/css-1kx1024 | 1048576 | Google | 15.50 | 37.36 | 2.41 | 294.07 |
| http/css-1kx1024 | 1048576 | stdx | 13.81 | 34.70 | 2.51 | 302.66 |
| http/css-16kx64 | 1048576 | Google | 4.97 | 11.76 | 2.37 | 102.93 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.49 | 81.00 |
| http/css-1m | 1048576 | Google | 2.44 | 9.42 | 3.86 | 17.01 |
| http/css-1m | 1048576 | stdx | 0.76 | 1.86 | 2.46 | 12.21 |
| shuffled/dickens-1m | 1048576 | Google | 10.12 | 20.65 | 2.04 | 106.66 |
| shuffled/dickens-1m | 1048576 | stdx | 8.75 | 14.53 | 1.66 | 115.49 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.19 | 36.91 | 2.43 | 410.58 |
| silesia/dickens | 10192446 | 1 | stdx | 16.29 | 38.17 | 2.34 | 360.02 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.09 | 87.63 | 1.68 | 693.30 |
| silesia/dickens | 10192446 | 6 | stdx | 49.54 | 84.26 | 1.70 | 1432.05 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.90 | 160.47 | 1.43 | 927.81 |
| silesia/dickens | 10192446 | 9 | stdx | 85.42 | 191.81 | 2.25 | 1712.00 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.12 | 32.62 | 2.31 | 438.45 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.37 | 30.24 | 2.26 | 295.60 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.90 | 70.83 | 2.15 | 580.66 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.56 | 69.96 | 2.22 | 735.51 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.54 | 221.49 | 1.74 | 767.14 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.99 | 126.12 | 2.57 | 790.17 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.93 | 35.02 | 2.94 | 229.38 |
| silesia/mr | 9970564 | 1 | stdx | 12.55 | 34.08 | 2.72 | 187.84 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.27 | 80.54 | 2.10 | 438.06 |
| silesia/mr | 9970564 | 6 | stdx | 39.66 | 83.19 | 2.10 | 969.39 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.82 | 165.48 | 1.69 | 751.33 |
| silesia/mr | 9970564 | 9 | stdx | 87.30 | 206.31 | 2.36 | 1328.53 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.21 | 18.42 | 2.97 | 115.69 |
| silesia/nci | 33553445 | 1 | stdx | 4.96 | 10.88 | 2.19 | 98.46 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.95 | 34.84 | 2.06 | 225.13 |
| silesia/nci | 33553445 | 6 | stdx | 14.35 | 29.54 | 2.06 | 392.82 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.33 | 105.28 | 1.69 | 499.65 |
| silesia/nci | 33553445 | 9 | stdx | 33.25 | 80.64 | 2.43 | 648.71 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.86 | 39.15 | 1.97 | 753.18 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.64 | 39.08 | 2.22 | 430.45 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 41.08 | 79.10 | 1.93 | 956.27 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.61 | 87.83 | 2.11 | 1005.79 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.66 | 127.63 | 1.71 | 1131.93 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.23 | 129.17 | 2.47 | 936.99 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.86 | 30.15 | 2.34 | 352.77 |
| silesia/osdb | 10085684 | 1 | stdx | 12.90 | 27.87 | 2.16 | 293.80 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.31 | 55.67 | 1.97 | 493.07 |
| silesia/osdb | 10085684 | 6 | stdx | 27.02 | 57.40 | 2.12 | 563.12 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.93 | 64.15 | 1.89 | 551.13 |
| silesia/osdb | 10085684 | 9 | stdx | 35.74 | 87.23 | 2.44 | 687.90 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.57 | 32.88 | 2.62 | 310.39 |
| silesia/reymont | 6627202 | 1 | stdx | 13.40 | 33.24 | 2.48 | 271.30 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.22 | 86.58 | 1.80 | 522.15 |
| silesia/reymont | 6627202 | 6 | stdx | 45.15 | 76.82 | 1.70 | 1425.86 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.25 | 276.14 | 1.39 | 837.05 |
| silesia/reymont | 6627202 | 9 | stdx | 87.64 | 189.98 | 2.17 | 1609.28 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.41 | 26.53 | 2.55 | 272.63 |
| silesia/samba | 21606400 | 1 | stdx | 9.82 | 22.23 | 2.26 | 220.88 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.96 | 58.79 | 2.03 | 385.21 |
| silesia/samba | 21606400 | 6 | stdx | 24.08 | 49.84 | 2.07 | 621.48 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.20 | 141.44 | 1.68 | 504.76 |
| silesia/samba | 21606400 | 9 | stdx | 41.80 | 102.63 | 2.46 | 728.70 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.70 | 47.87 | 2.21 | 688.39 |
| silesia/sao | 7251944 | 1 | stdx | 19.04 | 49.92 | 2.62 | 346.29 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.19 | 96.89 | 1.89 | 964.46 |
| silesia/sao | 7251944 | 6 | stdx | 47.10 | 105.66 | 2.24 | 854.22 |
| silesia/sao | 7251944 | 9 | libdeflate | 71.06 | 120.26 | 1.69 | 1105.07 |
| silesia/sao | 7251944 | 9 | stdx | 55.41 | 138.16 | 2.49 | 847.82 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.12 | 30.45 | 2.32 | 387.19 |
| silesia/webster | 41458703 | 1 | stdx | 13.86 | 29.09 | 2.10 | 339.38 |
| silesia/webster | 41458703 | 6 | libdeflate | 36.98 | 66.02 | 1.79 | 570.61 |
| silesia/webster | 41458703 | 6 | stdx | 35.01 | 60.88 | 1.74 | 1099.46 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.60 | 138.85 | 1.47 | 752.61 |
| silesia/webster | 41458703 | 9 | stdx | 61.11 | 135.96 | 2.22 | 1289.20 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.67 | 49.67 | 2.10 | 790.17 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.47 | 50.82 | 2.91 | 261.44 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.87 | 82.77 | 2.52 | 851.53 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.78 | 98.12 | 2.90 | 538.47 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.54 | 91.03 | 2.43 | 1029.81 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.82 | 122.06 | 2.99 | 468.08 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.78 | 21.59 | 2.78 | 176.75 |
| silesia/xml | 5345280 | 1 | stdx | 6.82 | 15.66 | 2.30 | 155.52 |
| silesia/xml | 5345280 | 6 | libdeflate | 20.97 | 40.51 | 1.93 | 263.72 |
| silesia/xml | 5345280 | 6 | stdx | 17.40 | 34.32 | 1.97 | 488.07 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.60 | 89.17 | 1.52 | 369.79 |
| silesia/xml | 5345280 | 9 | stdx | 31.26 | 72.83 | 2.33 | 597.35 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.28 | 35.61 | 2.49 | 379.56 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.02 | 36.13 | 2.41 | 335.33 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.82 | 82.29 | 1.76 | 643.14 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.52 | 77.43 | 1.78 | 1300.01 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.68 | 159.21 | 1.48 | 851.34 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 73.07 | 167.73 | 2.30 | 1504.67 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.18 | 37.20 | 2.45 | 417.71 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.76 | 37.43 | 2.37 | 358.50 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.39 | 85.43 | 1.77 | 719.95 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.01 | 81.93 | 1.78 | 1376.47 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 89.03 | 136.15 | 1.53 | 942.35 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 76.12 | 175.98 | 2.31 | 1603.39 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.67 | 32.02 | 2.74 | 280.63 |
| canterbury/cp.html | 24603 | 1 | stdx | 10.89 | 27.13 | 2.49 | 239.14 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 27.01 | 62.33 | 2.31 | 487.33 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.67 | 57.06 | 2.41 | 616.26 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.97 | 91.97 | 1.96 | 599.27 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.34 | 88.89 | 2.84 | 644.29 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.47 | 35.92 | 3.79 | 60.05 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.09 | 30.06 | 3.71 | 22.96 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.41 | 69.37 | 2.84 | 245.81 |
| canterbury/fields.c | 11150 | 6 | stdx | 21.05 | 57.62 | 2.74 | 441.79 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.99 | 100.81 | 2.24 | 447.42 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.41 | 92.66 | 3.26 | 434.80 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.04 | 51.51 | 3.95 | 15.00 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.89 | 39.03 | 3.95 | 1.08 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.76 | 87.06 | 3.66 | 29.41 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.22 | 70.82 | 4.11 | 16.28 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 31.21 | 102.89 | 3.30 | 65.79 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.48 | 99.32 | 4.23 | 51.99 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.37 | 27.18 | 3.69 | 65.35 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.05 | 22.58 | 3.20 | 63.07 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.84 | 73.85 | 2.65 | 96.23 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.35 | 62.00 | 3.20 | 139.71 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.28 | 664.23 | 1.83 | 163.55 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.74 | 130.89 | 3.47 | 219.51 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.81 | 33.99 | 2.46 | 371.61 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.45 | 33.93 | 2.35 | 328.97 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.08 | 78.22 | 1.74 | 609.08 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.58 | 73.43 | 1.77 | 1217.68 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.85 | 136.94 | 1.49 | 804.53 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 70.97 | 162.25 | 2.29 | 1443.57 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.83 | 38.62 | 2.44 | 427.82 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.72 | 40.25 | 2.41 | 369.20 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.10 | 91.90 | 1.70 | 753.38 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.71 | 88.90 | 1.72 | 1519.71 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.86 | 166.26 | 1.42 | 1000.76 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 89.08 | 201.33 | 2.26 | 1794.35 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.43 | 18.61 | 2.89 | 141.51 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.96 | 11.03 | 2.22 | 123.17 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.26 | 36.17 | 2.54 | 220.03 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.34 | 29.58 | 2.40 | 310.81 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.38 | 120.86 | 2.00 | 372.89 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.26 | 130.09 | 3.01 | 642.09 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.80 | 33.49 | 2.62 | 336.33 |
| canterbury/sum | 38240 | 1 | stdx | 12.62 | 29.36 | 2.33 | 302.73 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.73 | 69.87 | 2.43 | 504.05 |
| canterbury/sum | 38240 | 6 | stdx | 26.86 | 65.74 | 2.45 | 666.84 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.32 | 181.91 | 1.93 | 608.95 |
| canterbury/sum | 38240 | 9 | stdx | 39.40 | 112.34 | 2.85 | 662.47 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.29 | 53.06 | 3.99 | 22.54 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.70 | 43.11 | 4.03 | 2.50 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.83 | 87.70 | 3.84 | 65.41 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 17.94 | 74.37 | 4.15 | 38.41 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 25.58 | 94.34 | 3.69 | 130.27 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.12 | 106.97 | 4.10 | 109.90 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.02 | 40.47 | 3.37 | 164.75 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.51 | 42.29 | 3.38 | 101.22 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.24 | 395.99 | 2.16 | 261.28 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.90 | 374.13 | 3.04 | 1898.69 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 818.05 | 1063.49 | 1.30 | 1323.94 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 228.99 | 755.68 | 3.30 | 2425.69 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.53 | 32.38 | 2.58 | 313.19 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.18 | 32.23 | 2.45 | 280.74 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.06 | 80.12 | 1.74 | 524.57 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.10 | 72.39 | 1.72 | 1253.63 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.70 | 200.28 | 1.41 | 741.63 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.55 | 170.21 | 2.22 | 1440.10 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.31 | 29.72 | 2.23 | 414.40 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.09 | 28.55 | 2.03 | 378.51 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.01 | 60.25 | 1.83 | 558.89 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 31.85 | 56.81 | 1.78 | 978.85 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.52 | 119.11 | 1.48 | 684.18 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 52.28 | 117.95 | 2.26 | 1145.84 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.39 | 103.92 | 2.94 | 452.07 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.37 | 58.69 | 2.75 | 365.20 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.17 | 138.34 | 3.00 | 563.26 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 32.05 | 94.36 | 2.94 | 528.94 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.68 | 142.44 | 2.99 | 588.55 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 36.16 | 112.18 | 3.10 | 538.33 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.47 | 27.96 | 2.67 | 267.73 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.02 | 20.25 | 2.24 | 233.88 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.48 | 52.09 | 2.32 | 404.15 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.82 | 42.87 | 2.28 | 537.11 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 35.09 | 72.54 | 2.07 | 471.45 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.84 | 69.06 | 2.78 | 550.54 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.78 | 23.03 | 2.62 | 224.79 |
| http/html-1m | 1048576 | 1 | stdx | 8.17 | 17.80 | 2.18 | 206.44 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.31 | 49.53 | 1.96 | 327.11 |
| http/html-1m | 1048576 | 6 | stdx | 21.10 | 40.71 | 1.93 | 612.34 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.03 | 109.24 | 1.54 | 432.52 |
| http/html-1m | 1048576 | 9 | stdx | 35.90 | 85.76 | 2.39 | 703.80 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.81 | 94.80 | 2.98 | 301.34 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.50 | 45.22 | 2.74 | 240.80 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.01 | 126.60 | 2.94 | 371.82 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.19 | 78.43 | 2.88 | 375.80 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.02 | 142.45 | 2.74 | 429.14 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.79 | 95.61 | 3.10 | 385.53 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.85 | 23.85 | 3.04 | 134.65 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.45 | 13.94 | 2.56 | 110.38 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.18 | 46.61 | 2.56 | 206.71 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.42 | 35.02 | 2.61 | 276.57 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.10 | 151.99 | 1.90 | 296.02 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.21 | 58.45 | 3.04 | 301.87 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.74 | 19.85 | 2.95 | 124.46 |
| http/json-1m | 1048576 | 1 | stdx | 5.08 | 12.51 | 2.46 | 103.03 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.33 | 45.30 | 2.23 | 175.61 |
| http/json-1m | 1048576 | 6 | stdx | 14.66 | 35.09 | 2.39 | 294.24 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.44 | 205.21 | 1.69 | 275.17 |
| http/json-1m | 1048576 | 9 | stdx | 29.11 | 72.87 | 2.50 | 369.97 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.10 | 107.80 | 2.91 | 518.05 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.65 | 65.45 | 2.77 | 410.51 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.34 | 144.85 | 2.94 | 678.31 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 35.66 | 104.17 | 2.92 | 618.62 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.66 | 150.13 | 2.91 | 716.64 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 40.37 | 125.18 | 3.10 | 625.71 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.74 | 30.90 | 2.63 | 309.97 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.84 | 24.80 | 2.29 | 272.42 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 26.07 | 59.43 | 2.28 | 487.24 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.67 | 50.05 | 2.21 | 674.34 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.88 | 83.31 | 2.04 | 570.27 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.64 | 81.31 | 2.74 | 664.06 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.64 | 25.19 | 2.61 | 247.47 |
| http/js-1m | 1048576 | 1 | stdx | 9.56 | 21.31 | 2.23 | 233.71 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.74 | 56.12 | 1.95 | 370.95 |
| http/js-1m | 1048576 | 6 | stdx | 24.88 | 46.64 | 1.87 | 745.25 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.22 | 120.65 | 1.58 | 499.08 |
| http/js-1m | 1048576 | 9 | stdx | 42.16 | 100.01 | 2.37 | 809.53 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.18 | 97.74 | 2.95 | 373.38 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.43 | 49.57 | 2.69 | 301.06 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.80 | 129.23 | 2.95 | 477.30 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.17 | 82.37 | 2.82 | 502.80 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.72 | 133.80 | 2.93 | 506.10 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.21 | 99.53 | 3.00 | 523.28 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.65 | 25.60 | 2.96 | 173.97 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.70 | 16.96 | 2.53 | 135.71 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.26 | 48.80 | 2.41 | 294.26 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.42 | 38.01 | 2.31 | 458.65 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.80 | 82.40 | 2.02 | 374.44 |
| http/css-16kx64 | 1048576 | 9 | stdx | 23.03 | 65.14 | 2.83 | 479.92 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.93 | 21.15 | 3.05 | 131.85 |
| http/css-1m | 1048576 | 1 | stdx | 5.81 | 14.91 | 2.57 | 108.85 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.76 | 44.50 | 2.14 | 226.69 |
| http/css-1m | 1048576 | 6 | stdx | 16.57 | 35.61 | 2.15 | 442.04 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.62 | 111.58 | 1.60 | 309.83 |
| http/css-1m | 1048576 | 9 | stdx | 32.15 | 83.00 | 2.58 | 512.04 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.27 | 48.89 | 1.93 | 936.45 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.11 | 49.19 | 2.72 | 323.08 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.58 | 86.45 | 2.08 | 1181.55 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.67 | 88.80 | 2.24 | 852.91 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.03 | 94.50 | 2.01 | 1343.18 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.59 | 134.38 | 2.46 | 1136.20 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.05 | 31.22 | 3.11 | 120.34 |
| silesia/dickens | 10192446 | 1 | stdx | 24.24 | 82.03 | 3.38 | 126.95 |
| silesia/dickens | 10192446 | 3 | libzstd | 23.45 | 34.39 | 1.47 | 172.10 |
| silesia/dickens | 10192446 | 3 | stdx | 36.63 | 78.22 | 2.14 | 183.75 |
| silesia/mozilla | 51220480 | 1 | libzstd | 6.99 | 22.69 | 3.25 | 71.15 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.70 | 54.73 | 3.09 | 175.31 |
| silesia/mozilla | 51220480 | 3 | libzstd | 17.49 | 27.89 | 1.59 | 102.97 |
| silesia/mozilla | 51220480 | 3 | stdx | 31.61 | 62.01 | 1.96 | 145.33 |
| silesia/mr | 9970564 | 1 | libzstd | 7.60 | 24.81 | 3.26 | 58.10 |
| silesia/mr | 9970564 | 1 | stdx | 19.96 | 66.82 | 3.35 | 116.34 |
| silesia/mr | 9970564 | 3 | libzstd | 20.66 | 32.19 | 1.56 | 86.90 |
| silesia/mr | 9970564 | 3 | stdx | 34.68 | 72.46 | 2.09 | 115.19 |
| silesia/nci | 33553445 | 1 | libzstd | 3.50 | 9.55 | 2.73 | 57.25 |
| silesia/nci | 33553445 | 1 | stdx | 7.75 | 25.69 | 3.32 | 60.14 |
| silesia/nci | 33553445 | 3 | libzstd | 5.54 | 9.95 | 1.79 | 56.58 |
| silesia/nci | 33553445 | 3 | stdx | 11.49 | 29.15 | 2.54 | 67.02 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.53 | 29.26 | 3.43 | 72.86 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.10 | 72.51 | 3.14 | 181.81 |
| silesia/ooffice | 6152192 | 3 | libzstd | 24.62 | 39.44 | 1.60 | 121.05 |
| silesia/ooffice | 6152192 | 3 | stdx | 43.41 | 82.20 | 1.89 | 185.91 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.03 | 22.29 | 3.17 | 66.41 |
| silesia/osdb | 10085684 | 1 | stdx | 16.54 | 50.52 | 3.05 | 125.22 |
| silesia/osdb | 10085684 | 3 | libzstd | 18.44 | 26.23 | 1.42 | 67.87 |
| silesia/osdb | 10085684 | 3 | stdx | 32.97 | 57.87 | 1.76 | 112.61 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.64 | 27.13 | 2.81 | 150.26 |
| silesia/reymont | 6627202 | 1 | stdx | 20.14 | 72.05 | 3.58 | 97.82 |
| silesia/reymont | 6627202 | 3 | libzstd | 18.94 | 27.10 | 1.43 | 126.84 |
| silesia/reymont | 6627202 | 3 | stdx | 28.54 | 62.18 | 2.18 | 148.65 |
| silesia/samba | 21606400 | 1 | libzstd | 5.92 | 16.88 | 2.85 | 85.49 |
| silesia/samba | 21606400 | 1 | stdx | 13.57 | 42.89 | 3.16 | 126.84 |
| silesia/samba | 21606400 | 3 | libzstd | 12.27 | 18.81 | 1.53 | 99.61 |
| silesia/samba | 21606400 | 3 | stdx | 20.90 | 44.75 | 2.14 | 134.14 |
| silesia/sao | 7251944 | 1 | libzstd | 9.02 | 33.69 | 3.74 | 44.89 |
| silesia/sao | 7251944 | 1 | stdx | 26.06 | 82.03 | 3.15 | 105.08 |
| silesia/sao | 7251944 | 3 | libzstd | 32.44 | 50.03 | 1.54 | 94.96 |
| silesia/sao | 7251944 | 3 | stdx | 53.23 | 95.22 | 1.79 | 143.18 |
| silesia/webster | 41458703 | 1 | libzstd | 8.64 | 24.94 | 2.89 | 131.54 |
| silesia/webster | 41458703 | 1 | stdx | 20.37 | 64.04 | 3.14 | 168.44 |
| silesia/webster | 41458703 | 3 | libzstd | 19.65 | 27.33 | 1.39 | 178.46 |
| silesia/webster | 41458703 | 3 | stdx | 31.80 | 64.55 | 2.03 | 196.14 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.64 | 14.92 | 3.21 | 17.11 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.91 | 76.64 | 3.21 | 93.09 |
| silesia/x-ray | 8474240 | 3 | libzstd | 33.11 | 52.73 | 1.59 | 87.67 |
| silesia/x-ray | 8474240 | 3 | stdx | 49.28 | 92.40 | 1.88 | 107.58 |
| silesia/xml | 5345280 | 1 | libzstd | 4.20 | 11.71 | 2.79 | 71.19 |
| silesia/xml | 5345280 | 1 | stdx | 10.40 | 34.21 | 3.29 | 95.45 |
| silesia/xml | 5345280 | 3 | libzstd | 6.80 | 12.61 | 1.85 | 77.54 |
| silesia/xml | 5345280 | 3 | stdx | 12.90 | 32.28 | 2.50 | 116.71 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.77 | 32.84 | 3.05 | 139.28 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.43 | 76.49 | 3.41 | 190.78 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 16.97 | 39.48 | 2.33 | 203.27 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.65 | 73.76 | 2.77 | 339.17 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.70 | 33.55 | 3.46 | 102.24 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.58 | 79.00 | 3.35 | 221.07 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.54 | 39.27 | 2.53 | 210.39 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.60 | 79.30 | 2.77 | 377.08 |
| canterbury/cp.html | 24603 | 1 | libzstd | 7.05 | 26.64 | 3.78 | 43.91 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.24 | 57.76 | 3.56 | 126.33 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.83 | 31.85 | 3.24 | 47.66 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.34 | 59.76 | 3.26 | 140.80 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.69 | 31.76 | 3.65 | 42.56 |
| canterbury/fields.c | 11150 | 1 | stdx | 17.04 | 65.73 | 3.86 | 88.69 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.34 | 34.14 | 3.66 | 30.07 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.20 | 64.68 | 3.76 | 87.20 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.42 | 38.01 | 4.04 | 8.45 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.34 | 77.57 | 3.81 | 55.54 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.64 | 43.09 | 4.05 | 8.73 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.37 | 79.60 | 3.72 | 64.31 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.01 | 23.56 | 3.92 | 14.81 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.75 | 56.75 | 3.85 | 87.60 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.86 | 23.80 | 2.69 | 27.50 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 20.83 | 56.61 | 2.72 | 108.20 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.81 | 28.52 | 2.91 | 155.39 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.39 | 72.02 | 3.37 | 162.79 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 17.33 | 32.14 | 1.85 | 204.17 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.59 | 67.10 | 2.52 | 298.88 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.28 | 32.37 | 3.15 | 128.43 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.08 | 84.16 | 3.36 | 160.67 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 20.99 | 38.77 | 1.85 | 229.08 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 32.11 | 80.77 | 2.52 | 346.85 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.15 | 8.51 | 2.71 | 66.55 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.55 | 23.15 | 3.07 | 106.96 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 5.09 | 10.97 | 2.16 | 59.37 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.66 | 24.08 | 2.49 | 133.91 |
| canterbury/sum | 38240 | 1 | libzstd | 6.58 | 25.39 | 3.86 | 34.56 |
| canterbury/sum | 38240 | 1 | stdx | 17.02 | 59.13 | 3.47 | 157.80 |
| canterbury/sum | 38240 | 3 | libzstd | 9.78 | 30.67 | 3.14 | 47.88 |
| canterbury/sum | 38240 | 3 | stdx | 19.64 | 61.82 | 3.15 | 183.68 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 9.99 | 39.82 | 3.98 | 13.75 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.94 | 80.38 | 3.84 | 60.58 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.22 | 48.17 | 3.94 | 16.91 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.92 | 83.98 | 3.66 | 82.83 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.31 | 33.44 | 3.24 | 76.05 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.77 | 95.62 | 4.39 | 7.25 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 16.37 | 31.30 | 1.91 | 36.02 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 24.13 | 70.38 | 2.92 | 38.79 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.67 | 27.45 | 2.84 | 149.41 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.41 | 71.86 | 3.52 | 109.21 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 18.71 | 28.20 | 1.51 | 133.40 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 28.63 | 63.36 | 2.21 | 156.70 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.09 | 22.70 | 2.81 | 136.82 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.65 | 55.86 | 3.00 | 195.57 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 16.03 | 23.87 | 1.49 | 176.08 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 25.69 | 51.26 | 1.99 | 239.64 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 16.96 | 52.46 | 3.09 | 159.52 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.87 | 100.54 | 2.80 | 643.66 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 18.95 | 59.20 | 3.12 | 197.04 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 37.93 | 104.00 | 2.74 | 638.38 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.68 | 22.46 | 2.92 | 122.23 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.16 | 46.84 | 3.31 | 183.92 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.74 | 24.61 | 2.82 | 141.13 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.46 | 47.61 | 3.08 | 193.03 |
| http/html-1m | 1048576 | 1 | libzstd | 6.22 | 16.74 | 2.69 | 114.33 |
| http/html-1m | 1048576 | 1 | stdx | 12.98 | 42.00 | 3.24 | 136.41 |
| http/html-1m | 1048576 | 3 | libzstd | 9.71 | 18.18 | 1.87 | 125.90 |
| http/html-1m | 1048576 | 3 | stdx | 16.01 | 39.37 | 2.46 | 178.99 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.24 | 42.52 | 2.99 | 115.80 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.59 | 83.13 | 2.81 | 532.02 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.73 | 44.54 | 3.02 | 129.01 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.63 | 84.87 | 2.77 | 531.13 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.78 | 14.98 | 3.13 | 57.64 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.69 | 33.78 | 3.49 | 117.42 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.33 | 16.21 | 3.04 | 72.48 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.66 | 34.58 | 3.24 | 123.71 |
| http/json-1m | 1048576 | 1 | libzstd | 4.04 | 12.55 | 3.11 | 52.39 |
| http/json-1m | 1048576 | 1 | stdx | 9.04 | 30.70 | 3.40 | 86.95 |
| http/json-1m | 1048576 | 3 | libzstd | 6.43 | 13.78 | 2.14 | 69.00 |
| http/json-1m | 1048576 | 3 | stdx | 11.64 | 30.64 | 2.63 | 121.06 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.44 | 57.26 | 3.10 | 183.66 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 40.08 | 113.49 | 2.83 | 702.61 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.30 | 65.54 | 3.08 | 258.68 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.58 | 116.54 | 2.74 | 690.34 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.80 | 26.52 | 3.01 | 127.28 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.62 | 55.71 | 3.35 | 203.05 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.03 | 28.74 | 2.87 | 153.55 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.92 | 55.35 | 3.09 | 211.98 |
| http/js-1m | 1048576 | 1 | libzstd | 6.52 | 17.87 | 2.74 | 113.42 |
| http/js-1m | 1048576 | 1 | stdx | 13.98 | 45.88 | 3.28 | 138.06 |
| http/js-1m | 1048576 | 3 | libzstd | 10.42 | 19.14 | 1.84 | 125.36 |
| http/js-1m | 1048576 | 3 | stdx | 17.30 | 41.25 | 2.38 | 188.26 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.47 | 46.90 | 3.03 | 136.90 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.40 | 91.65 | 2.83 | 583.63 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.53 | 50.53 | 3.06 | 158.50 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.73 | 93.63 | 2.78 | 584.32 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.11 | 18.99 | 3.11 | 78.83 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.44 | 43.79 | 3.52 | 138.56 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.55 | 19.41 | 2.96 | 96.10 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.97 | 42.34 | 3.26 | 152.80 |
| http/css-1m | 1048576 | 1 | libzstd | 1.49 | 4.59 | 3.07 | 21.66 |
| http/css-1m | 1048576 | 1 | stdx | 4.01 | 14.85 | 3.70 | 30.82 |
| http/css-1m | 1048576 | 3 | libzstd | 2.02 | 5.25 | 2.60 | 19.71 |
| http/css-1m | 1048576 | 3 | stdx | 4.00 | 13.33 | 3.34 | 31.86 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.52 | 12.79 | 3.63 | 6.21 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.17 | 30.66 | 3.34 | 62.90 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 29.74 | 50.53 | 1.70 | 50.68 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 21.50 | 47.43 | 2.21 | 210.04 |

## Hardware counters per input octet, brotli encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | Google q1 | 18.00 | 30.24 | 1.68 | 231.22 |
| silesia/dickens | 10192446 | stdx 1 | 19.54 | 43.43 | 2.22 | 412.81 |
| silesia/dickens | 10192446 | Google q5 | 102.17 | 194.36 | 1.90 | 819.18 |
| silesia/dickens | 10192446 | stdx 5 | 70.78 | 156.51 | 2.21 | 985.56 |
| silesia/mozilla | 51220480 | Google q1 | 13.00 | 25.26 | 1.94 | 144.71 |
| silesia/mozilla | 51220480 | stdx 1 | 12.34 | 32.95 | 2.67 | 214.02 |
| silesia/mozilla | 51220480 | Google q5 | 62.23 | 149.30 | 2.40 | 796.51 |
| silesia/mozilla | 51220480 | stdx 5 | 58.48 | 149.71 | 2.56 | 809.45 |
| silesia/mr | 9970564 | Google q1 | 13.01 | 26.14 | 2.01 | 98.17 |
| silesia/mr | 9970564 | stdx 1 | 13.73 | 37.80 | 2.75 | 165.17 |
| silesia/mr | 9970564 | Google q5 | 80.52 | 177.41 | 2.20 | 608.53 |
| silesia/mr | 9970564 | stdx 5 | 62.19 | 150.44 | 2.42 | 697.78 |
| silesia/nci | 33553445 | Google q1 | 5.21 | 9.71 | 1.86 | 89.15 |
| silesia/nci | 33553445 | stdx 1 | 6.07 | 14.48 | 2.38 | 128.12 |
| silesia/nci | 33553445 | Google q5 | 30.78 | 59.01 | 1.92 | 410.66 |
| silesia/nci | 33553445 | stdx 5 | 26.42 | 58.75 | 2.22 | 473.19 |
| silesia/ooffice | 6152192 | Google q1 | 17.41 | 33.43 | 1.92 | 154.33 |
| silesia/ooffice | 6152192 | stdx 1 | 16.86 | 45.85 | 2.72 | 267.24 |
| silesia/ooffice | 6152192 | Google q5 | 87.66 | 198.80 | 2.27 | 1064.15 |
| silesia/ooffice | 6152192 | stdx 5 | 74.05 | 180.71 | 2.44 | 1066.20 |
| silesia/osdb | 10085684 | Google q1 | 12.29 | 23.47 | 1.91 | 83.99 |
| silesia/osdb | 10085684 | stdx 1 | 11.69 | 32.00 | 2.74 | 141.41 |
| silesia/osdb | 10085684 | Google q5 | 67.22 | 146.01 | 2.17 | 545.17 |
| silesia/osdb | 10085684 | stdx 5 | 49.98 | 125.21 | 2.51 | 518.31 |
| silesia/reymont | 6627202 | Google q1 | 15.24 | 25.54 | 1.68 | 207.78 |
| silesia/reymont | 6627202 | stdx 1 | 14.49 | 33.36 | 2.30 | 282.99 |
| silesia/reymont | 6627202 | Google q5 | 78.94 | 169.16 | 2.14 | 797.85 |
| silesia/reymont | 6627202 | stdx 5 | 60.18 | 140.32 | 2.33 | 886.64 |
| silesia/samba | 21606400 | Google q1 | 9.76 | 17.38 | 1.78 | 127.69 |
| silesia/samba | 21606400 | stdx 1 | 9.93 | 23.94 | 2.41 | 197.06 |
| silesia/samba | 21606400 | Google q5 | 46.83 | 105.54 | 2.25 | 477.93 |
| silesia/samba | 21606400 | stdx 5 | 41.29 | 103.19 | 2.50 | 525.85 |
| silesia/sao | 7251944 | Google q1 | 20.63 | 39.96 | 1.94 | 100.38 |
| silesia/sao | 7251944 | stdx 1 | 18.78 | 55.66 | 2.96 | 189.69 |
| silesia/sao | 7251944 | Google q5 | 109.20 | 259.63 | 2.38 | 928.07 |
| silesia/sao | 7251944 | stdx 5 | 89.34 | 233.57 | 2.61 | 742.97 |
| silesia/webster | 41458703 | Google q1 | 14.42 | 24.40 | 1.69 | 208.68 |
| silesia/webster | 41458703 | stdx 1 | 15.33 | 34.12 | 2.23 | 340.02 |
| silesia/webster | 41458703 | Google q5 | 74.28 | 141.82 | 1.91 | 754.39 |
| silesia/webster | 41458703 | stdx 5 | 56.52 | 122.07 | 2.16 | 837.14 |
| silesia/x-ray | 8474240 | Google q1 | 13.86 | 22.03 | 1.59 | 12.35 |
| silesia/x-ray | 8474240 | stdx 1 | 13.13 | 38.68 | 2.94 | 94.79 |
| silesia/x-ray | 8474240 | Google q5 | 99.27 | 236.76 | 2.39 | 724.84 |
| silesia/x-ray | 8474240 | stdx 5 | 85.88 | 231.05 | 2.69 | 653.26 |
| silesia/xml | 5345280 | Google q1 | 6.95 | 12.28 | 1.77 | 113.93 |
| silesia/xml | 5345280 | stdx 1 | 7.33 | 17.44 | 2.38 | 153.90 |
| silesia/xml | 5345280 | Google q5 | 31.12 | 72.50 | 2.33 | 357.83 |
| silesia/xml | 5345280 | stdx 5 | 25.98 | 65.03 | 2.50 | 403.57 |
| canterbury/alice29.txt | 152089 | Google q1 | 17.10 | 29.72 | 1.74 | 208.89 |
| canterbury/alice29.txt | 152089 | stdx 1 | 18.37 | 40.79 | 2.22 | 449.23 |
| canterbury/alice29.txt | 152089 | Google q5 | 80.16 | 200.77 | 2.50 | 1037.74 |
| canterbury/alice29.txt | 152089 | stdx 5 | 59.37 | 148.01 | 2.49 | 899.41 |
| canterbury/asyoulik.txt | 125179 | Google q1 | 17.74 | 32.37 | 1.82 | 221.33 |
| canterbury/asyoulik.txt | 125179 | stdx 1 | 20.13 | 44.50 | 2.21 | 501.70 |
| canterbury/asyoulik.txt | 125179 | Google q5 | 85.92 | 215.27 | 2.51 | 1077.26 |
| canterbury/asyoulik.txt | 125179 | stdx 5 | 65.72 | 159.47 | 2.43 | 1038.63 |
| canterbury/cp.html | 24603 | Google q1 | 12.89 | 27.30 | 2.12 | 93.30 |
| canterbury/cp.html | 24603 | stdx 1 | 14.60 | 36.07 | 2.47 | 352.15 |
| canterbury/cp.html | 24603 | Google q5 | 61.19 | 163.89 | 2.68 | 942.89 |
| canterbury/cp.html | 24603 | stdx 5 | 46.78 | 128.83 | 2.75 | 716.46 |
| canterbury/fields.c | 11150 | Google q1 | 12.04 | 29.04 | 2.41 | 14.10 |
| canterbury/fields.c | 11150 | stdx 1 | 10.50 | 38.87 | 3.70 | 87.89 |
| canterbury/fields.c | 11150 | Google q5 | 58.99 | 168.16 | 2.85 | 908.14 |
| canterbury/fields.c | 11150 | stdx 5 | 40.09 | 120.96 | 3.02 | 545.54 |
| canterbury/grammar.lsp | 3721 | Google q1 | 14.34 | 39.39 | 2.75 | 9.41 |
| canterbury/grammar.lsp | 3721 | stdx 1 | 13.53 | 55.22 | 4.08 | 31.02 |
| canterbury/grammar.lsp | 3721 | Google q5 | 60.94 | 203.91 | 3.35 | 454.76 |
| canterbury/grammar.lsp | 3721 | stdx 5 | 39.35 | 145.59 | 3.70 | 182.90 |
| canterbury/kennedy.xls | 1029744 | Google q1 | 9.75 | 24.83 | 2.55 | 59.55 |
| canterbury/kennedy.xls | 1029744 | stdx 1 | 7.82 | 27.03 | 3.45 | 77.35 |
| canterbury/kennedy.xls | 1029744 | Google q5 | 47.70 | 162.91 | 3.42 | 261.96 |
| canterbury/kennedy.xls | 1029744 | stdx 5 | 50.13 | 162.41 | 3.24 | 468.26 |
| canterbury/lcet10.txt | 426754 | Google q1 | 15.86 | 27.19 | 1.71 | 202.36 |
| canterbury/lcet10.txt | 426754 | stdx 1 | 16.79 | 37.84 | 2.25 | 380.30 |
| canterbury/lcet10.txt | 426754 | Google q5 | 78.86 | 187.58 | 2.38 | 958.25 |
| canterbury/lcet10.txt | 426754 | stdx 5 | 57.55 | 139.70 | 2.43 | 888.91 |
| canterbury/plrabn12.txt | 481861 | Google q1 | 18.85 | 32.57 | 1.73 | 249.25 |
| canterbury/plrabn12.txt | 481861 | stdx 1 | 20.81 | 46.66 | 2.24 | 473.90 |
| canterbury/plrabn12.txt | 481861 | Google q5 | 97.57 | 229.77 | 2.35 | 1065.02 |
| canterbury/plrabn12.txt | 481861 | stdx 5 | 72.13 | 167.86 | 2.33 | 1170.31 |
| canterbury/ptt5 | 513216 | Google q1 | 4.95 | 9.55 | 1.93 | 80.59 |
| canterbury/ptt5 | 513216 | stdx 1 | 6.65 | 15.64 | 2.35 | 160.42 |
| canterbury/ptt5 | 513216 | Google q5 | 27.56 | 68.87 | 2.50 | 466.75 |
| canterbury/ptt5 | 513216 | stdx 5 | 27.83 | 69.27 | 2.49 | 457.28 |
| canterbury/sum | 38240 | Google q1 | 12.95 | 29.25 | 2.26 | 88.17 |
| canterbury/sum | 38240 | stdx 1 | 15.56 | 36.37 | 2.34 | 408.27 |
| canterbury/sum | 38240 | Google q5 | 66.33 | 182.58 | 2.75 | 1096.90 |
| canterbury/sum | 38240 | stdx 5 | 56.10 | 155.87 | 2.78 | 832.35 |
| canterbury/xargs.1 | 4227 | Google q1 | 16.19 | 43.16 | 2.67 | 14.45 |
| canterbury/xargs.1 | 4227 | stdx 1 | 14.90 | 59.10 | 3.97 | 50.58 |
| canterbury/xargs.1 | 4227 | Google q5 | 70.95 | 219.02 | 3.09 | 753.80 |
| canterbury/xargs.1 | 4227 | stdx 5 | 44.15 | 155.91 | 3.53 | 302.84 |
| canterbury-large/E.coli | 4638690 | Google q1 | 13.54 | 27.46 | 2.03 | 53.34 |
| canterbury-large/E.coli | 4638690 | stdx 1 | 5.57 | 19.24 | 3.45 | 18.16 |
| canterbury-large/E.coli | 4638690 | Google q5 | 88.96 | 262.67 | 2.95 | 993.58 |
| canterbury-large/E.coli | 4638690 | stdx 5 | 30.86 | 93.11 | 3.02 | 64.62 |
| canterbury-large/bible.txt | 4047392 | Google q1 | 14.60 | 24.57 | 1.68 | 176.30 |
| canterbury-large/bible.txt | 4047392 | stdx 1 | 15.27 | 34.29 | 2.25 | 317.38 |
| canterbury-large/bible.txt | 4047392 | Google q5 | 78.54 | 165.65 | 2.11 | 727.98 |
| canterbury-large/bible.txt | 4047392 | stdx 5 | 57.83 | 134.78 | 2.33 | 801.66 |
| canterbury-large/world192.txt | 2473400 | Google q1 | 13.39 | 22.62 | 1.69 | 193.78 |
| canterbury-large/world192.txt | 2473400 | stdx 1 | 13.70 | 31.07 | 2.27 | 315.71 |
| canterbury-large/world192.txt | 2473400 | Google q5 | 67.43 | 129.46 | 1.92 | 739.70 |
| canterbury-large/world192.txt | 2473400 | stdx 5 | 47.54 | 105.74 | 2.22 | 750.02 |
| http/html-1kx1024 | 1048576 | Google q1 | 32.26 | 62.53 | 1.94 | 866.62 |
| http/html-1kx1024 | 1048576 | stdx 1 | 27.29 | 80.73 | 2.96 | 476.06 |
| http/html-1kx1024 | 1048576 | Google q5 | 107.53 | 260.90 | 2.43 | 2128.02 |
| http/html-1kx1024 | 1048576 | stdx 5 | 63.00 | 167.89 | 2.66 | 1112.19 |
| http/html-16kx64 | 1048576 | Google q1 | 11.26 | 20.38 | 1.81 | 216.31 |
| http/html-16kx64 | 1048576 | stdx 1 | 11.49 | 28.46 | 2.48 | 302.76 |
| http/html-16kx64 | 1048576 | Google q5 | 47.07 | 118.53 | 2.52 | 854.72 |
| http/html-16kx64 | 1048576 | stdx 5 | 35.73 | 92.10 | 2.58 | 638.48 |
| http/html-1m | 1048576 | Google q1 | 8.87 | 15.15 | 1.71 | 136.95 |
| http/html-1m | 1048576 | stdx 1 | 9.66 | 22.18 | 2.30 | 226.35 |
| http/html-1m | 1048576 | Google q5 | 44.86 | 104.93 | 2.34 | 573.22 |
| http/html-1m | 1048576 | stdx 5 | 33.58 | 84.11 | 2.50 | 532.31 |
| http/json-1kx1024 | 1048576 | Google q1 | 24.59 | 49.87 | 2.03 | 653.19 |
| http/json-1kx1024 | 1048576 | stdx 1 | 21.00 | 61.64 | 2.94 | 366.51 |
| http/json-1kx1024 | 1048576 | Google q5 | 79.76 | 203.15 | 2.55 | 1334.83 |
| http/json-1kx1024 | 1048576 | stdx 5 | 46.99 | 131.37 | 2.80 | 706.61 |
| http/json-16kx64 | 1048576 | Google q1 | 7.57 | 14.90 | 1.97 | 141.97 |
| http/json-16kx64 | 1048576 | stdx 1 | 7.04 | 19.73 | 2.80 | 159.58 |
| http/json-16kx64 | 1048576 | Google q5 | 36.08 | 97.81 | 2.71 | 557.76 |
| http/json-16kx64 | 1048576 | stdx 5 | 31.64 | 88.58 | 2.80 | 516.66 |
| http/json-1m | 1048576 | Google q1 | 6.15 | 12.65 | 2.06 | 92.37 |
| http/json-1m | 1048576 | stdx 1 | 6.63 | 17.21 | 2.59 | 140.45 |
| http/json-1m | 1048576 | Google q5 | 36.30 | 96.08 | 2.65 | 445.57 |
| http/json-1m | 1048576 | stdx 5 | 34.51 | 92.25 | 2.67 | 563.69 |
| http/js-1kx1024 | 1048576 | Google q1 | 34.84 | 68.18 | 1.96 | 910.14 |
| http/js-1kx1024 | 1048576 | stdx 1 | 30.34 | 90.40 | 2.98 | 531.99 |
| http/js-1kx1024 | 1048576 | Google q5 | 117.91 | 288.57 | 2.45 | 2307.19 |
| http/js-1kx1024 | 1048576 | stdx 5 | 70.18 | 186.45 | 2.66 | 1236.44 |
| http/js-16kx64 | 1048576 | Google q1 | 13.08 | 24.07 | 1.84 | 232.34 |
| http/js-16kx64 | 1048576 | stdx 1 | 13.37 | 32.69 | 2.44 | 357.14 |
| http/js-16kx64 | 1048576 | Google q5 | 55.38 | 141.15 | 2.55 | 996.95 |
| http/js-16kx64 | 1048576 | stdx 5 | 41.65 | 106.28 | 2.55 | 746.61 |
| http/js-1m | 1048576 | Google q1 | 9.65 | 16.69 | 1.73 | 140.44 |
| http/js-1m | 1048576 | stdx 1 | 10.14 | 23.55 | 2.32 | 230.42 |
| http/js-1m | 1048576 | Google q5 | 50.12 | 116.02 | 2.31 | 635.50 |
| http/js-1m | 1048576 | stdx 5 | 36.34 | 90.22 | 2.48 | 574.21 |
| http/css-1kx1024 | 1048576 | Google q1 | 27.63 | 54.06 | 1.96 | 733.82 |
| http/css-1kx1024 | 1048576 | stdx 1 | 23.54 | 68.32 | 2.90 | 434.00 |
| http/css-1kx1024 | 1048576 | Google q5 | 87.29 | 213.92 | 2.45 | 1653.90 |
| http/css-1kx1024 | 1048576 | stdx 5 | 50.99 | 137.20 | 2.69 | 878.26 |
| http/css-16kx64 | 1048576 | Google q1 | 8.94 | 16.85 | 1.88 | 141.17 |
| http/css-16kx64 | 1048576 | stdx 1 | 8.49 | 23.62 | 2.78 | 192.47 |
| http/css-16kx64 | 1048576 | Google q5 | 37.43 | 100.68 | 2.69 | 645.90 |
| http/css-16kx64 | 1048576 | stdx 5 | 28.78 | 80.59 | 2.80 | 484.72 |
| http/css-1m | 1048576 | Google q1 | 5.92 | 11.27 | 1.90 | 75.67 |
| http/css-1m | 1048576 | stdx 1 | 5.43 | 14.38 | 2.65 | 110.43 |
| http/css-1m | 1048576 | Google q5 | 14.32 | 38.50 | 2.69 | 129.42 |
| http/css-1m | 1048576 | stdx 5 | 11.76 | 36.69 | 3.12 | 110.52 |
| shuffled/dickens-1m | 1048576 | Google q1 | 11.42 | 20.96 | 1.84 | 2.80 |
| shuffled/dickens-1m | 1048576 | stdx 1 | 5.24 | 19.75 | 3.77 | 10.17 |
| shuffled/dickens-1m | 1048576 | Google q5 | 96.09 | 235.57 | 2.45 | 724.68 |
| shuffled/dickens-1m | 1048576 | stdx 5 | 42.29 | 122.09 | 2.89 | 203.29 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.117 | 3.00 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 66.6 | 219.6 | 0.088 | 7.87 | 3.30 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 30.6 | 96.1 | 0.164 | 3.62 | 3.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextReader.next_items | 28.3 | 80.8 | 0.152 | 3.35 | 2.85 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 249.2 | 1024.0 | 0.821 | 29.43 | 4.11 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.7 | 107.7 | 0.128 | 3.63 | 3.51 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.8 | 106.2 | 0.292 | 3.28 | 3.82 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 96.7 | 378.2 | 0.369 | 11.42 | 3.91 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.6 | 161.9 | 0.446 | 5.03 | 3.80 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 89.8 | 451.6 | 0.305 | 10.60 | 5.03 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 26.7 | 89.5 | 0.004 | 3.92 | 3.36 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.4 | 234.7 | 0.043 | 10.07 | 3.43 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 29.2 | 99.4 | 0.013 | 4.29 | 3.41 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextReader.next_items | 27.0 | 84.2 | 0.008 | 3.98 | 3.11 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 214.6 | 819.1 | 0.946 | 31.59 | 3.82 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.1 | 107.7 | 0.039 | 4.13 | 3.84 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.8 | 106.0 | 0.046 | 4.24 | 3.68 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 96.0 | 346.2 | 0.324 | 14.12 | 3.61 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 31.7 | 144.5 | 0.052 | 4.67 | 4.55 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 89.6 | 406.5 | 0.117 | 13.18 | 4.54 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 42.3 | 96.3 | 0.193 | 3.96 | 2.28 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 86.3 | 249.4 | 0.235 | 8.08 | 2.89 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 46.4 | 113.8 | 0.284 | 4.35 | 2.45 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextReader.next_items | 43.8 | 99.4 | 0.219 | 4.10 | 2.27 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 311.8 | 1284.6 | 1.045 | 29.20 | 4.12 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 36.3 | 133.1 | 0.193 | 3.40 | 3.66 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 47.3 | 128.6 | 0.758 | 4.43 | 2.72 |
| messages: 11 string members | 96000 | 1025025 | std.json | 126.0 | 451.2 | 1.034 | 11.80 | 3.58 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 67.8 | 204.1 | 0.981 | 6.35 | 3.01 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 135.7 | 572.0 | 0.841 | 12.71 | 4.22 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 24.2 | 78.8 | 0.019 | 3.02 | 3.26 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 67.8 | 239.5 | 0.007 | 8.49 | 3.53 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 28.0 | 93.3 | 0.045 | 3.51 | 3.33 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextReader.next_items | 26.0 | 78.0 | 0.033 | 3.26 | 2.99 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 230.8 | 942.3 | 0.412 | 28.89 | 4.08 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 28.3 | 107.6 | 0.057 | 3.54 | 3.80 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 25.4 | 104.8 | 0.022 | 3.18 | 4.13 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 89.8 | 361.0 | 0.028 | 11.24 | 4.02 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 32.6 | 151.6 | 0.044 | 4.08 | 4.65 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 82.5 | 418.3 | 0.152 | 10.33 | 5.07 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim on | 12.9 | 56.5 | 0.049 | 5.92 | 4.38 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, one token a call | 50.8 | 172.6 | 0.165 | 23.29 | 3.40 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, TextWriter's methods or TextReader.next | 16.5 | 73.4 | 0.079 | 7.56 | 4.45 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, TextReader.next_items | 13.9 | 57.7 | 0.047 | 6.37 | 4.16 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim off | 99.7 | 326.3 | 0.270 | 45.76 | 3.27 |
| messages: a tree of 341 objects | 281100 | 612600 | simdjson | 16.2 | 58.4 | 0.024 | 7.42 | 3.61 |
| messages: a tree of 341 objects | 281100 | 612600 | yyjson | 15.8 | 72.2 | 0.047 | 7.27 | 4.56 |
| messages: a tree of 341 objects | 281100 | 612600 | std.json | 58.4 | 220.1 | 0.117 | 26.81 | 3.77 |
| messages: a tree of 341 objects | 281100 | 612600 | serde_json | 13.6 | 59.5 | 0.093 | 6.25 | 4.37 |
| messages: a tree of 341 objects | 281100 | 612600 | Go jsontext | 43.6 | 216.0 | 0.116 | 19.99 | 4.96 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114566.6 | 403852.2 | 503.845 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 591059.4 | 2495394.2 | 1389.062 | 3.43 | 4.22 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 114147.1 | 404249.2 | 474.588 | 0.66 | 3.54 |
| string: silesia/dickens | 1 | 172528 | stdx, TextReader.next_items | 113841.8 | 404282.2 | 466.010 | 0.66 | 3.55 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3578996.2 | 18223882.2 | 2976.588 | 20.74 | 5.09 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311603.6 | 621744.2 | 617.567 | 1.81 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 223521.6 | 826630.2 | 2203.763 | 1.30 | 3.70 |
| string: silesia/dickens | 1 | 172528 | std.json | 1575724.4 | 4578768.2 | 42430.454 | 9.13 | 2.91 |
| string: silesia/dickens | 1 | 172528 | serde_json | 201934.1 | 802909.2 | 994.907 | 1.17 | 3.98 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1062330.7 | 5282284.5 | 4961.000 | 6.16 | 4.97 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1562491.6 | 4799769.6 | 1256.786 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14187500.1 | 56410893.6 | 39265.929 | 11.92 | 3.98 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1559767.9 | 4799955.6 | 1131.143 | 1.31 | 3.08 |
| string: http/json-1m | 1 | 1190272 | stdx, TextReader.next_items | 1559578.9 | 4799988.6 | 1095.786 | 1.31 | 3.08 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 29065960.6 | 132108259.6 | 159351.000 | 24.42 | 4.55 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4581340.7 | 7062781.6 | 561.500 | 3.85 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1778406.9 | 7322029.6 | 13996.571 | 1.49 | 4.12 |
| string: http/json-1m | 1 | 1190272 | std.json | 10369286.3 | 47381157.6 | 33723.714 | 8.71 | 4.57 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3802426.9 | 15226584.6 | 6042.000 | 3.19 | 4.00 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9151552.9 | 47990690.9 | 27821.000 | 7.69 | 5.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2072075.9 | 5765419.8 | 4500.875 | 1.10 | 2.78 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6171863.1 | 22538840.8 | 6980.875 | 3.28 | 3.65 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2061069.1 | 5765605.8 | 3935.750 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextReader.next_items | 2058614.5 | 5765638.8 | 3781.875 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47301725.5 | 227842326.8 | 275940.750 | 25.12 | 4.82 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3770165.0 | 8446023.8 | 2104.375 | 2.00 | 2.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7136154.4 | 12276717.8 | 276240.750 | 3.79 | 1.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17431260.4 | 63617055.8 | 265289.500 | 9.26 | 3.65 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9403426.4 | 24440998.8 | 323734.625 | 4.99 | 2.60 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39054805.5 | 160373030.3 | 830068.750 | 20.74 | 4.11 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12940708.0 | 42561075.3 | 245762.000 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 173298008.7 | 666700955.3 | 394212.333 | 34.14 | 3.85 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12932986.7 | 42561261.3 | 245942.333 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextReader.next_items | 12984237.0 | 42561294.3 | 246599.667 | 2.56 | 3.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 153158378.0 | 639992668.3 | 424657.667 | 30.18 | 4.18 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17549310.3 | 49745820.3 | 252922.000 | 3.46 | 2.83 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14087756.0 | 45615166.3 | 443900.667 | 2.78 | 3.24 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 80252215.0 | 314900845.3 | 459419.000 | 15.81 | 3.92 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36659391.0 | 131556418.3 | 597097.000 | 7.22 | 3.59 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66230035.0 | 273924979.3 | 838422.333 | 13.05 | 4.14 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 93498.1 | 303842.7 | 6.323 | 0.18 | 3.25 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 187985.8 | 623466.7 | 9.290 | 0.36 | 3.32 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 148465.5 | 557622.7 | 7.677 | 0.28 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextReader.next_items | 148444.7 | 557626.7 | 6.806 | 0.28 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10277517.7 | 53478208.7 | 8.194 | 19.60 | 5.20 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 489191.5 | 1376733.7 | 4.871 | 0.93 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 538331.9 | 2195917.7 | 6.871 | 1.03 | 4.08 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3482383.6 | 12808414.7 | 60973.161 | 6.64 | 3.68 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 292629.3 | 1179969.7 | 5.839 | 0.56 | 4.03 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2257389.2 | 12787193.2 | 243.129 | 4.31 | 5.66 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.8 | 81.8 | 0.109 | 2.34 | 4.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.3 | 153.5 | 0.128 | 4.17 | 4.35 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 21.2 | 91.9 | 0.092 | 2.51 | 4.32 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 218.4 | 981.0 | 0.923 | 25.80 | 4.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 18.8 | 79.5 | 0.107 | 2.22 | 4.23 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.1 | 94.1 | 0.135 | 2.73 | 4.07 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.4 | 105.6 | 0.245 | 3.23 | 3.86 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.8 | 310.8 | 0.363 | 8.24 | 4.45 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 65.3 | 255.3 | 0.498 | 7.72 | 3.91 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.6 | 315.1 | 0.234 | 8.10 | 4.59 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 19.0 | 82.8 | 0.024 | 2.80 | 4.36 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.1 | 153.9 | 0.025 | 5.32 | 4.26 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 22.5 | 92.9 | 0.024 | 3.31 | 4.14 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 169.7 | 718.3 | 1.237 | 24.97 | 4.23 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.4 | 81.5 | 0.025 | 2.71 | 4.42 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.8 | 96.8 | 0.032 | 3.21 | 4.44 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.9 | 117.9 | 0.033 | 4.26 | 4.08 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 60.0 | 271.2 | 0.274 | 8.83 | 4.52 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 49.3 | 212.7 | 0.039 | 7.26 | 4.31 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 81.6 | 331.7 | 0.087 | 12.01 | 4.06 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 31.9 | 85.9 | 0.398 | 2.99 | 2.69 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 43.9 | 151.2 | 0.410 | 4.11 | 3.45 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 30.1 | 91.0 | 0.395 | 2.82 | 3.02 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 274.5 | 1195.0 | 1.140 | 25.71 | 4.35 |
| messages: 11 string members | 96000 | 1025025 | stdx, J11's loop unchecked | 29.7 | 82.8 | 0.395 | 2.78 | 2.79 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 39.0 | 119.1 | 0.588 | 3.65 | 3.05 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 47.6 | 138.2 | 0.697 | 4.46 | 2.90 |
| messages: 11 string members | 96000 | 1025025 | std.json | 101.1 | 370.8 | 1.066 | 9.46 | 3.67 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 91.5 | 315.4 | 0.764 | 8.57 | 3.45 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 109.4 | 400.7 | 0.876 | 10.25 | 3.66 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 20.7 | 80.2 | 0.007 | 2.59 | 3.87 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 38.3 | 152.5 | 0.006 | 4.79 | 3.98 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 23.2 | 92.2 | 0.006 | 2.90 | 3.98 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 197.2 | 866.7 | 0.775 | 24.68 | 4.40 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, J11's loop unchecked | 19.6 | 79.4 | 0.007 | 2.46 | 4.05 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 24.0 | 96.6 | 0.004 | 3.01 | 4.02 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 25.8 | 101.3 | 0.018 | 3.23 | 3.92 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 59.8 | 279.4 | 0.006 | 7.49 | 4.67 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 53.7 | 230.6 | 0.065 | 6.72 | 4.30 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 69.7 | 310.8 | 0.006 | 8.73 | 4.46 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim on | 15.7 | 62.6 | 0.023 | 7.22 | 3.98 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, one token a call | 31.9 | 135.7 | 0.031 | 14.66 | 4.25 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, TextWriter's methods or TextReader.next | 13.7 | 54.5 | 0.034 | 6.27 | 3.99 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim off | 81.5 | 375.6 | 0.240 | 37.42 | 4.61 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, J11's loop unchecked | 14.8 | 61.4 | 0.023 | 6.81 | 4.14 |
| messages: a tree of 341 objects | 281100 | 612600 | simdjson | 12.4 | 45.5 | 0.023 | 5.70 | 3.67 |
| messages: a tree of 341 objects | 281100 | 612600 | yyjson | 15.7 | 56.5 | 0.050 | 7.22 | 3.59 |
| messages: a tree of 341 objects | 281100 | 612600 | std.json | 28.0 | 125.4 | 0.046 | 12.83 | 4.48 |
| messages: a tree of 341 objects | 281100 | 612600 | serde_json | 23.8 | 102.3 | 0.028 | 10.92 | 4.30 |
| messages: a tree of 341 objects | 281100 | 612600 | Go jsontext | 42.6 | 181.3 | 0.119 | 19.54 | 4.26 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 84812.8 | 280786.2 | 719.670 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84906.9 | 280732.2 | 723.072 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 85022.7 | 280696.2 | 725.773 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3416441.7 | 16047574.2 | 2944.495 | 19.80 | 4.70 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 84550.8 | 274401.2 | 716.392 | 0.49 | 3.25 |
| string: silesia/dickens | 1 | 172528 | simdjson | 208558.0 | 674016.2 | 2063.021 | 1.21 | 3.23 |
| string: silesia/dickens | 1 | 172528 | yyjson | 203322.6 | 825518.2 | 1005.227 | 1.18 | 4.06 |
| string: silesia/dickens | 1 | 172528 | std.json | 1373092.0 | 2890892.2 | 53848.041 | 7.96 | 2.11 |
| string: silesia/dickens | 1 | 172528 | serde_json | 398304.6 | 1586249.2 | 2611.557 | 2.31 | 3.98 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 584054.1 | 2970284.0 | 2807.186 | 3.39 | 5.09 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1282837.4 | 3582350.6 | 11730.786 | 1.08 | 2.79 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1271329.4 | 3582290.6 | 11257.357 | 1.07 | 2.82 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1269265.1 | 3582260.6 | 11143.500 | 1.07 | 2.82 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25547421.1 | 109856348.6 | 143137.000 | 21.46 | 4.30 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1227558.9 | 3370022.6 | 10920.500 | 1.03 | 2.75 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2968915.1 | 10460762.6 | 29515.500 | 2.49 | 3.52 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2589445.9 | 10197931.6 | 9680.929 | 2.18 | 3.94 |
| string: http/json-1m | 1 | 1190272 | std.json | 9011422.3 | 43287986.6 | 15775.214 | 7.57 | 4.80 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4033143.3 | 17941088.6 | 11111.286 | 3.39 | 4.45 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5222127.9 | 26999653.2 | 11891.571 | 4.39 | 5.17 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2071808.0 | 6088099.8 | 4625.000 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2062784.8 | 6088043.8 | 4078.875 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2057991.3 | 6088009.8 | 4013.500 | 1.09 | 2.96 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43691162.3 | 193466553.8 | 270133.250 | 23.20 | 4.43 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2066780.0 | 5875346.8 | 4688.875 | 1.10 | 2.84 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2719176.5 | 7144143.8 | 20965.875 | 1.44 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12146426.0 | 23590602.8 | 446461.625 | 6.45 | 1.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20612939.4 | 56837736.8 | 551613.750 | 10.95 | 2.76 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11695132.8 | 33662338.8 | 331064.875 | 6.21 | 2.88 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18212479.1 | 76319429.5 | 250624.125 | 9.67 | 4.19 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113502.3 | 426376.7 | 1.516 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113450.4 | 426318.7 | 3.710 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113326.3 | 426278.7 | 2.290 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 638897.6 | 3146479.7 | 5.774 | 1.22 | 4.92 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113284.8 | 426343.7 | 3.355 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1208320.5 | 3866916.7 | 4.710 | 2.30 | 3.20 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1627049.9 | 5833341.7 | 6.484 | 3.10 | 3.59 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3571171.0 | 13108830.7 | 73432.226 | 6.81 | 3.67 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1882686.5 | 7405810.7 | 4.065 | 3.59 | 3.93 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2390538.5 | 12748343.6 | 15.290 | 4.56 | 5.33 |
