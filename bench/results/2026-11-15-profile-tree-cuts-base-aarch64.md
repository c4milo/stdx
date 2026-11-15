# bench-profile

| Field | Value |
|---|---|
| Commit | 936cf02 |
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
| silesia/dickens | 10192446 | zlib | 8.82 | 19.08 | 2.16 | 310.68 |
| silesia/dickens | 10192446 | zlib-ng | 4.87 | 10.50 | 2.15 | 67.58 |
| silesia/dickens | 10192446 | libdeflate | 3.46 | 9.56 | 2.77 | 66.06 |
| silesia/dickens | 10192446 | Wuffs | 5.54 | 13.90 | 2.51 | 97.84 |
| silesia/dickens | 10192446 | stdx | 2.94 | 7.15 | 2.43 | 76.32 |
| silesia/mozilla | 51220480 | zlib | 8.48 | 17.23 | 2.03 | 251.74 |
| silesia/mozilla | 51220480 | zlib-ng | 4.95 | 8.95 | 1.81 | 85.60 |
| silesia/mozilla | 51220480 | libdeflate | 3.48 | 7.63 | 2.19 | 71.09 |
| silesia/mozilla | 51220480 | Wuffs | 6.42 | 13.89 | 2.16 | 132.63 |
| silesia/mozilla | 51220480 | stdx | 3.65 | 6.29 | 1.72 | 89.53 |
| silesia/mr | 9970564 | zlib | 8.37 | 18.46 | 2.21 | 202.72 |
| silesia/mr | 9970564 | zlib-ng | 4.79 | 9.98 | 2.08 | 67.96 |
| silesia/mr | 9970564 | libdeflate | 3.34 | 8.58 | 2.56 | 61.27 |
| silesia/mr | 9970564 | Wuffs | 5.98 | 14.04 | 2.35 | 99.97 |
| silesia/mr | 9970564 | stdx | 3.06 | 6.70 | 2.19 | 69.74 |
| silesia/nci | 33553445 | zlib | 3.54 | 10.18 | 2.87 | 81.45 |
| silesia/nci | 33553445 | zlib-ng | 1.57 | 3.13 | 1.99 | 33.77 |
| silesia/nci | 33553445 | libdeflate | 1.13 | 2.66 | 2.36 | 29.77 |
| silesia/nci | 33553445 | Wuffs | 2.44 | 6.47 | 2.65 | 41.47 |
| silesia/nci | 33553445 | stdx | 1.14 | 2.20 | 1.93 | 37.23 |
| silesia/ooffice | 6152192 | zlib | 11.79 | 21.06 | 1.79 | 418.43 |
| silesia/ooffice | 6152192 | zlib-ng | 6.92 | 12.04 | 1.74 | 141.38 |
| silesia/ooffice | 6152192 | libdeflate | 4.90 | 10.45 | 2.13 | 125.29 |
| silesia/ooffice | 6152192 | Wuffs | 8.81 | 17.54 | 1.99 | 220.40 |
| silesia/ooffice | 6152192 | stdx | 5.07 | 8.55 | 1.69 | 151.71 |
| silesia/osdb | 10085684 | zlib | 7.47 | 16.59 | 2.22 | 183.72 |
| silesia/osdb | 10085684 | zlib-ng | 4.29 | 8.38 | 1.95 | 52.98 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.91 | 2.43 | 29.69 |
| silesia/osdb | 10085684 | Wuffs | 5.80 | 13.61 | 2.35 | 79.09 |
| silesia/osdb | 10085684 | stdx | 2.77 | 5.65 | 2.04 | 40.73 |
| silesia/reymont | 6627202 | zlib | 7.37 | 15.89 | 2.16 | 259.81 |
| silesia/reymont | 6627202 | zlib-ng | 3.70 | 7.72 | 2.09 | 59.67 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.34 |
| silesia/reymont | 6627202 | Wuffs | 4.88 | 11.40 | 2.33 | 112.64 |
| silesia/reymont | 6627202 | stdx | 2.29 | 5.11 | 2.24 | 64.45 |
| silesia/samba | 21606400 | zlib | 6.15 | 14.13 | 2.30 | 175.16 |
| silesia/samba | 21606400 | zlib-ng | 3.34 | 6.47 | 1.94 | 55.92 |
| silesia/samba | 21606400 | libdeflate | 2.31 | 5.58 | 2.41 | 42.94 |
| silesia/samba | 21606400 | Wuffs | 4.32 | 10.39 | 2.40 | 79.62 |
| silesia/samba | 21606400 | stdx | 2.25 | 4.46 | 1.98 | 56.38 |
| silesia/sao | 7251944 | zlib | 10.49 | 23.54 | 2.24 | 203.94 |
| silesia/sao | 7251944 | zlib-ng | 7.84 | 14.83 | 1.89 | 79.41 |
| silesia/sao | 7251944 | libdeflate | 5.73 | 12.73 | 2.22 | 79.16 |
| silesia/sao | 7251944 | Wuffs | 8.89 | 21.26 | 2.39 | 86.36 |
| silesia/sao | 7251944 | stdx | 5.56 | 10.32 | 1.86 | 87.13 |
| silesia/webster | 41458703 | zlib | 7.82 | 16.16 | 2.07 | 283.06 |
| silesia/webster | 41458703 | zlib-ng | 4.22 | 8.04 | 1.91 | 85.42 |
| silesia/webster | 41458703 | libdeflate | 2.88 | 7.17 | 2.49 | 68.45 |
| silesia/webster | 41458703 | Wuffs | 5.14 | 11.67 | 2.27 | 122.45 |
| silesia/webster | 41458703 | stdx | 2.71 | 5.56 | 2.05 | 87.23 |
| silesia/x-ray | 8474240 | zlib | 12.87 | 27.21 | 2.11 | 329.12 |
| silesia/x-ray | 8474240 | zlib-ng | 9.04 | 17.39 | 1.92 | 124.14 |
| silesia/x-ray | 8474240 | libdeflate | 6.53 | 15.26 | 2.34 | 124.45 |
| silesia/x-ray | 8474240 | Wuffs | 10.81 | 23.52 | 2.18 | 190.80 |
| silesia/x-ray | 8474240 | stdx | 6.12 | 11.49 | 1.88 | 138.90 |
| silesia/xml | 5345280 | zlib | 4.22 | 11.16 | 2.65 | 118.13 |
| silesia/xml | 5345280 | zlib-ng | 1.99 | 3.88 | 1.95 | 42.89 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 31.90 |
| silesia/xml | 5345280 | Wuffs | 2.84 | 7.22 | 2.54 | 59.01 |
| silesia/xml | 5345280 | stdx | 1.33 | 2.65 | 1.99 | 42.00 |
| canterbury/alice29.txt | 152089 | zlib | 8.43 | 18.35 | 2.18 | 294.06 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.53 | 9.91 | 2.19 | 60.50 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.19 | 8.96 | 2.81 | 55.60 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.37 | 13.40 | 2.50 | 98.02 |
| canterbury/alice29.txt | 152089 | stdx | 2.71 | 6.99 | 2.58 | 62.31 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.04 | 19.42 | 2.15 | 315.73 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 72.78 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.61 | 9.82 | 2.72 | 69.29 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.76 | 14.40 | 2.50 | 100.20 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.05 | 7.52 | 2.47 | 76.69 |
| canterbury/cp.html | 24603 | zlib | 7.01 | 17.33 | 2.47 | 167.72 |
| canterbury/cp.html | 24603 | zlib-ng | 4.17 | 9.50 | 2.28 | 36.42 |
| canterbury/cp.html | 24603 | libdeflate | 2.82 | 7.95 | 2.82 | 11.82 |
| canterbury/cp.html | 24603 | Wuffs | 5.33 | 13.91 | 2.61 | 69.71 |
| canterbury/cp.html | 24603 | stdx | 2.64 | 7.19 | 2.73 | 12.21 |
| canterbury/fields.c | 11150 | zlib | 5.24 | 17.73 | 3.39 | 35.83 |
| canterbury/fields.c | 11150 | zlib-ng | 3.88 | 10.20 | 2.63 | 15.11 |
| canterbury/fields.c | 11150 | libdeflate | 2.79 | 8.32 | 2.99 | 1.34 |
| canterbury/fields.c | 11150 | Wuffs | 4.52 | 14.54 | 3.22 | 9.77 |
| canterbury/fields.c | 11150 | stdx | 2.50 | 7.64 | 3.06 | 4.20 |
| canterbury/grammar.lsp | 3721 | zlib | 6.88 | 24.26 | 3.53 | 6.07 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.82 | 17.48 | 3.00 | 7.58 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.41 | 12.05 | 2.73 | 1.06 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.70 | 21.86 | 3.26 | 5.14 |
| canterbury/grammar.lsp | 3721 | stdx | 3.84 | 12.18 | 3.18 | 0.98 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.59 | 15.27 | 3.33 | 48.28 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.85 | 6.97 | 2.45 | 12.60 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.05 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.86 | 11.59 | 3.00 | 14.87 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.66 | 2.66 | 16.61 |
| canterbury/lcet10.txt | 426754 | zlib | 8.23 | 17.78 | 2.16 | 292.97 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 60.62 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.20 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.23 | 12.88 | 2.46 | 101.39 |
| canterbury/lcet10.txt | 426754 | stdx | 2.59 | 6.42 | 2.48 | 66.82 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.21 | 19.86 | 2.16 | 322.20 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.27 | 11.19 | 2.12 | 76.74 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.70 | 77.44 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.81 | 14.61 | 2.51 | 98.67 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 7.63 | 2.42 | 84.98 |
| canterbury/ptt5 | 513216 | zlib | 5.05 | 10.71 | 2.12 | 103.12 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.63 |
| canterbury/ptt5 | 513216 | libdeflate | 1.46 | 3.02 | 2.07 | 39.14 |
| canterbury/ptt5 | 513216 | Wuffs | 3.00 | 7.13 | 2.38 | 57.41 |
| canterbury/ptt5 | 513216 | stdx | 1.44 | 2.55 | 1.77 | 48.69 |
| canterbury/sum | 38240 | zlib | 7.99 | 18.12 | 2.27 | 223.88 |
| canterbury/sum | 38240 | zlib-ng | 4.64 | 10.02 | 2.16 | 56.73 |
| canterbury/sum | 38240 | libdeflate | 3.26 | 8.34 | 2.56 | 30.43 |
| canterbury/sum | 38240 | Wuffs | 5.77 | 14.47 | 2.51 | 80.71 |
| canterbury/sum | 38240 | stdx | 3.02 | 7.73 | 2.56 | 28.17 |
| canterbury/xargs.1 | 4227 | zlib | 7.43 | 25.22 | 3.39 | 12.81 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.37 | 17.97 | 2.82 | 9.28 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.77 | 13.27 | 2.78 | 1.15 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.20 | 22.63 | 3.14 | 9.48 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 12.86 | 3.04 | 1.66 |
| canterbury-large/E.coli | 4638690 | zlib | 6.76 | 17.84 | 2.64 | 177.82 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.23 | 9.68 | 2.29 | 47.58 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.37 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.66 | 12.73 | 2.73 | 61.56 |
| canterbury-large/E.coli | 4638690 | stdx | 2.48 | 6.72 | 2.71 | 53.98 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.52 | 16.46 | 2.19 | 267.98 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.77 | 8.26 | 2.19 | 53.64 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.32 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.80 | 11.73 | 2.44 | 99.87 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.23 | 5.57 | 2.50 | 55.74 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.74 | 15.84 | 2.05 | 283.26 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.19 | 7.78 | 1.85 | 91.75 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.06 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.18 | 11.48 | 2.21 | 128.06 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 5.40 | 1.98 | 90.32 |
| http/html-1kx1024 | 1048576 | zlib | 16.69 | 35.58 | 2.13 | 352.40 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.70 | 28.43 | 2.24 | 218.13 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.60 | 20.05 | 1.89 | 155.59 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.34 | 38.07 | 2.48 | 266.22 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 136.74 |
| http/html-16kx64 | 1048576 | zlib | 6.73 | 14.77 | 2.20 | 221.59 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.84 | 7.54 | 1.96 | 84.90 |
| http/html-16kx64 | 1048576 | libdeflate | 2.64 | 6.04 | 2.29 | 60.81 |
| http/html-16kx64 | 1048576 | Wuffs | 4.92 | 11.57 | 2.35 | 114.92 |
| http/html-16kx64 | 1048576 | stdx | 2.51 | 5.56 | 2.22 | 58.82 |
| http/html-1m | 1048576 | zlib | 5.31 | 12.53 | 2.36 | 176.60 |
| http/html-1m | 1048576 | zlib-ng | 2.63 | 5.03 | 1.92 | 60.20 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.53 |
| http/html-1m | 1048576 | Wuffs | 3.61 | 8.48 | 2.35 | 88.22 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.10 | 52.50 |
| http/json-1kx1024 | 1048576 | zlib | 10.60 | 23.92 | 2.26 | 192.07 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.26 | 130.31 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.86 | 16.72 | 1.89 | 92.21 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.12 | 34.78 | 2.87 | 146.60 |
| http/json-1kx1024 | 1048576 | stdx | 5.04 | 13.12 | 2.60 | 80.73 |
| http/json-16kx64 | 1048576 | zlib | 4.57 | 12.51 | 2.74 | 103.41 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.62 | 5.50 | 2.10 | 50.95 |
| http/json-16kx64 | 1048576 | libdeflate | 1.92 | 4.24 | 2.21 | 40.73 |
| http/json-16kx64 | 1048576 | Wuffs | 3.50 | 9.43 | 2.70 | 57.86 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.26 | 39.14 |
| http/json-1m | 1048576 | zlib | 3.84 | 11.20 | 2.92 | 83.10 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.02 | 37.28 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.82 |
| http/json-1m | 1048576 | Wuffs | 2.73 | 7.37 | 2.70 | 43.56 |
| http/json-1m | 1048576 | stdx | 1.33 | 2.67 | 2.01 | 40.07 |
| http/js-1kx1024 | 1048576 | zlib | 18.23 | 38.46 | 2.11 | 410.14 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.76 | 31.25 | 2.27 | 237.61 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.28 | 21.58 | 1.91 | 179.07 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.55 | 40.70 | 2.46 | 300.96 |
| http/js-1kx1024 | 1048576 | stdx | 9.27 | 22.85 | 2.46 | 159.12 |
| http/js-16kx64 | 1048576 | zlib | 7.67 | 16.08 | 2.10 | 264.05 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.97 | 91.89 |
| http/js-16kx64 | 1048576 | libdeflate | 3.06 | 7.01 | 2.29 | 72.37 |
| http/js-16kx64 | 1048576 | Wuffs | 5.50 | 12.75 | 2.32 | 129.07 |
| http/js-16kx64 | 1048576 | stdx | 2.99 | 6.54 | 2.19 | 71.58 |
| http/js-1m | 1048576 | zlib | 5.86 | 13.31 | 2.27 | 200.99 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.96 | 59.95 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.85 |
| http/js-1m | 1048576 | Wuffs | 3.90 | 9.14 | 2.34 | 93.74 |
| http/js-1m | 1048576 | stdx | 1.80 | 3.89 | 2.16 | 55.50 |
| http/css-1kx1024 | 1048576 | zlib | 14.05 | 30.36 | 2.16 | 282.18 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.24 | 23.04 | 2.25 | 170.61 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.19 | 17.37 | 1.89 | 121.45 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.78 | 32.50 | 2.54 | 210.91 |
| http/css-1kx1024 | 1048576 | stdx | 6.67 | 17.64 | 2.65 | 100.32 |
| http/css-16kx64 | 1048576 | zlib | 5.32 | 13.04 | 2.45 | 154.55 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.77 | 6.07 | 2.19 | 49.92 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.49 | 29.84 |
| http/css-16kx64 | 1048576 | Wuffs | 3.79 | 10.01 | 2.64 | 69.60 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.54 | 28.09 |
| http/css-1m | 1048576 | zlib | 3.98 | 10.97 | 2.76 | 107.83 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.21 | 29.22 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.97 | 12.70 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.78 | 43.58 |
| http/css-1m | 1048576 | stdx | 1.02 | 2.56 | 2.52 | 21.33 |
| shuffled/dickens-1m | 1048576 | zlib | 13.30 | 25.88 | 1.95 | 373.54 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.72 | 16.72 | 1.72 | 196.83 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.02 | 14.95 | 2.13 | 192.56 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.45 | 22.08 | 2.11 | 203.87 |
| shuffled/dickens-1m | 1048576 | stdx | 7.05 | 11.89 | 1.69 | 205.54 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.50 | 14.05 | 4.01 | 3.40 |
| silesia/dickens | 10192446 | stdx | 3.66 | 12.47 | 3.41 | 4.07 |
| silesia/mozilla | 51220480 | libzstd | 2.83 | 9.68 | 3.42 | 30.13 |
| silesia/mozilla | 51220480 | stdx | 2.81 | 9.68 | 3.44 | 15.84 |
| silesia/mr | 9970564 | libzstd | 3.07 | 11.99 | 3.91 | 6.13 |
| silesia/mr | 9970564 | stdx | 3.13 | 10.83 | 3.46 | 5.19 |
| silesia/nci | 33553445 | libzstd | 1.62 | 4.88 | 3.01 | 24.76 |
| silesia/nci | 33553445 | stdx | 1.59 | 4.63 | 2.91 | 13.64 |
| silesia/ooffice | 6152192 | libzstd | 3.37 | 12.19 | 3.62 | 30.97 |
| silesia/ooffice | 6152192 | stdx | 3.34 | 12.40 | 3.72 | 12.31 |
| silesia/osdb | 10085684 | libzstd | 2.36 | 8.45 | 3.58 | 14.90 |
| silesia/osdb | 10085684 | stdx | 2.43 | 8.11 | 3.33 | 15.58 |
| silesia/reymont | 6627202 | libzstd | 3.16 | 11.62 | 3.67 | 11.55 |
| silesia/reymont | 6627202 | stdx | 3.29 | 10.36 | 3.14 | 13.08 |
| silesia/samba | 21606400 | libzstd | 2.06 | 7.41 | 3.60 | 18.64 |
| silesia/samba | 21606400 | stdx | 2.11 | 6.83 | 3.24 | 17.75 |
| silesia/sao | 7251944 | libzstd | 3.75 | 12.72 | 3.39 | 26.95 |
| silesia/sao | 7251944 | stdx | 3.46 | 12.58 | 3.64 | 6.21 |
| silesia/webster | 41458703 | libzstd | 3.18 | 11.24 | 3.53 | 16.15 |
| silesia/webster | 41458703 | stdx | 3.36 | 10.05 | 2.99 | 17.62 |
| silesia/x-ray | 8474240 | libzstd | 3.89 | 14.94 | 3.84 | 18.76 |
| silesia/x-ray | 8474240 | stdx | 3.55 | 13.23 | 3.73 | 8.41 |
| silesia/xml | 5345280 | libzstd | 1.55 | 5.57 | 3.60 | 23.30 |
| silesia/xml | 5345280 | stdx | 1.52 | 5.16 | 3.40 | 17.27 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.89 | 4.06 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.35 | 0.54 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.95 | 14.26 | 4.83 | 3.27 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.29 | 0.36 |
| canterbury/cp.html | 24603 | libzstd | 2.62 | 10.74 | 4.09 | 7.41 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.11 | 0.20 |
| canterbury/fields.c | 11150 | libzstd | 3.12 | 13.62 | 4.36 | 9.11 |
| canterbury/fields.c | 11150 | stdx | 3.00 | 12.72 | 4.24 | 0.37 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.19 | 16.94 | 4.04 | 4.82 |
| canterbury/grammar.lsp | 3721 | stdx | 4.13 | 16.54 | 4.00 | 0.16 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.54 | 11.40 | 4.49 | 7.85 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.68 | 11.32 | 4.22 | 0.88 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.70 | 12.89 | 4.78 | 5.22 |
| canterbury/lcet10.txt | 426754 | stdx | 2.75 | 11.52 | 4.19 | 5.39 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.10 | 15.16 | 4.89 | 1.53 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.18 | 13.51 | 4.25 | 1.03 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.52 | 3.12 | 24.92 |
| canterbury/ptt5 | 513216 | stdx | 1.34 | 4.46 | 3.32 | 13.79 |
| canterbury/sum | 38240 | libzstd | 2.62 | 10.58 | 4.03 | 10.59 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.38 |
| canterbury/xargs.1 | 4227 | libzstd | 4.25 | 17.41 | 4.09 | 9.10 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.17 | 4.05 | 0.19 |
| canterbury-large/E.coli | 4638690 | libzstd | 2.97 | 13.64 | 4.59 | 2.15 |
| canterbury-large/E.coli | 4638690 | stdx | 3.09 | 12.04 | 3.89 | 2.88 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.95 | 12.00 | 4.07 | 8.28 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.09 | 10.64 | 3.45 | 9.96 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.54 | 9.60 | 3.78 | 19.69 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.62 | 8.64 | 3.29 | 21.09 |
| http/html-1kx1024 | 1048576 | libzstd | 7.25 | 21.63 | 2.99 | 63.11 |
| http/html-1kx1024 | 1048576 | stdx | 7.47 | 22.46 | 3.01 | 77.02 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.82 | 28.50 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.61 | 30.06 |
| http/html-1m | 1048576 | libzstd | 2.01 | 7.88 | 3.92 | 24.08 |
| http/html-1m | 1048576 | stdx | 2.01 | 7.12 | 3.54 | 25.37 |
| http/json-1kx1024 | 1048576 | libzstd | 6.27 | 17.39 | 2.77 | 49.61 |
| http/json-1kx1024 | 1048576 | stdx | 6.20 | 17.86 | 2.88 | 53.66 |
| http/json-16kx64 | 1048576 | libzstd | 2.06 | 7.26 | 3.53 | 28.50 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.58 | 19.80 |
| http/json-1m | 1048576 | libzstd | 1.72 | 6.08 | 3.53 | 27.89 |
| http/json-1m | 1048576 | stdx | 1.64 | 5.91 | 3.61 | 14.50 |
| http/js-1kx1024 | 1048576 | libzstd | 8.33 | 26.35 | 3.16 | 73.61 |
| http/js-1kx1024 | 1048576 | stdx | 9.04 | 27.60 | 3.05 | 113.77 |
| http/js-16kx64 | 1048576 | libzstd | 2.92 | 11.72 | 4.01 | 24.22 |
| http/js-16kx64 | 1048576 | stdx | 2.95 | 11.06 | 3.75 | 25.77 |
| http/js-1m | 1048576 | libzstd | 2.03 | 8.19 | 4.04 | 20.08 |
| http/js-1m | 1048576 | stdx | 2.07 | 7.48 | 3.62 | 20.57 |
| http/css-1kx1024 | 1048576 | libzstd | 6.88 | 19.69 | 2.86 | 53.53 |
| http/css-1kx1024 | 1048576 | stdx | 6.84 | 19.96 | 2.92 | 63.75 |
| http/css-16kx64 | 1048576 | libzstd | 2.25 | 8.70 | 3.87 | 23.18 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.10 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.58 | 3.85 | 5.49 |
| http/css-1m | 1048576 | stdx | 0.72 | 2.49 | 3.47 | 4.30 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.77 | 9.40 | 3.39 | 28.36 |
| shuffled/dickens-1m | 1048576 | stdx | 2.75 | 9.19 | 3.35 | 12.79 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.53 | 16.93 | 2.25 | 99.82 |
| silesia/dickens | 1048576 | stdx | 5.14 | 12.38 | 2.41 | 54.71 |
| silesia/mozilla | 1048576 | Google | 13.48 | 28.31 | 2.10 | 47.78 |
| silesia/mozilla | 1048576 | stdx | 8.32 | 15.02 | 1.81 | 47.08 |
| silesia/mr | 1048576 | Google | 8.94 | 20.21 | 2.26 | 103.33 |
| silesia/mr | 1048576 | stdx | 5.80 | 13.25 | 2.29 | 88.44 |
| silesia/nci | 1048576 | Google | 2.56 | 5.70 | 2.22 | 52.32 |
| silesia/nci | 1048576 | stdx | 1.95 | 3.95 | 2.03 | 55.08 |
| silesia/ooffice | 1048576 | Google | 14.19 | 29.27 | 2.06 | 288.49 |
| silesia/ooffice | 1048576 | stdx | 11.00 | 20.33 | 1.85 | 323.77 |
| silesia/osdb | 1048576 | Google | 8.25 | 17.48 | 2.12 | 97.18 |
| silesia/osdb | 1048576 | stdx | 5.16 | 10.57 | 2.05 | 91.82 |
| silesia/reymont | 1048576 | Google | 5.44 | 12.62 | 2.32 | 82.64 |
| silesia/reymont | 1048576 | stdx | 3.73 | 9.25 | 2.48 | 47.75 |
| silesia/samba | 1048576 | Google | 7.60 | 16.30 | 2.15 | 95.16 |
| silesia/samba | 1048576 | stdx | 5.08 | 10.71 | 2.11 | 67.07 |
| silesia/sao | 1048576 | Google | 16.86 | 37.18 | 2.21 | 167.22 |
| silesia/sao | 1048576 | stdx | 10.42 | 22.65 | 2.17 | 141.38 |
| silesia/webster | 1048576 | Google | 6.54 | 14.00 | 2.14 | 113.41 |
| silesia/webster | 1048576 | stdx | 4.41 | 9.98 | 2.26 | 69.13 |
| silesia/x-ray | 1048576 | Google | 19.64 | 38.56 | 1.96 | 236.11 |
| silesia/x-ray | 1048576 | stdx | 14.57 | 30.18 | 2.07 | 234.16 |
| silesia/xml | 1048576 | Google | 3.46 | 7.61 | 2.20 | 65.26 |
| silesia/xml | 1048576 | stdx | 2.42 | 5.40 | 2.24 | 46.77 |
| canterbury/alice29.txt | 152089 | Google | 8.85 | 20.55 | 2.32 | 132.91 |
| canterbury/alice29.txt | 152089 | stdx | 6.13 | 15.33 | 2.50 | 82.34 |
| canterbury/asyoulik.txt | 125179 | Google | 10.36 | 23.71 | 2.29 | 166.76 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.20 | 17.43 | 2.42 | 101.88 |
| canterbury/cp.html | 24603 | Google | 9.03 | 22.20 | 2.46 | 113.10 |
| canterbury/cp.html | 24603 | stdx | 6.09 | 17.15 | 2.82 | 47.56 |
| canterbury/fields.c | 11150 | Google | 7.15 | 21.16 | 2.96 | 30.53 |
| canterbury/fields.c | 11150 | stdx | 4.98 | 17.08 | 3.43 | 1.84 |
| canterbury/grammar.lsp | 3721 | Google | 9.85 | 30.16 | 3.06 | 8.11 |
| canterbury/grammar.lsp | 3721 | stdx | 7.26 | 25.04 | 3.45 | 0.34 |
| canterbury/kennedy.xls | 1029744 | Google | 5.44 | 17.05 | 3.13 | 37.53 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.84 | 12.94 | 3.37 | 34.03 |
| canterbury/lcet10.txt | 426754 | Google | 7.74 | 17.36 | 2.24 | 125.21 |
| canterbury/lcet10.txt | 426754 | stdx | 5.20 | 12.96 | 2.49 | 66.06 |
| canterbury/plrabn12.txt | 481861 | Google | 9.06 | 20.82 | 2.30 | 132.36 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.19 | 15.04 | 2.43 | 87.66 |
| canterbury/ptt5 | 513216 | Google | 4.30 | 10.41 | 2.42 | 62.51 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.06 | 66.01 |
| canterbury/sum | 38240 | Google | 10.91 | 26.44 | 2.42 | 161.89 |
| canterbury/sum | 38240 | stdx | 8.38 | 21.11 | 2.52 | 158.00 |
| canterbury/xargs.1 | 4227 | Google | 11.02 | 34.81 | 3.16 | 12.96 |
| canterbury/xargs.1 | 4227 | stdx | 8.67 | 30.44 | 3.51 | 6.99 |
| canterbury-large/E.coli | 1048576 | Google | 8.13 | 19.55 | 2.40 | 1.46 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.61 |
| canterbury-large/bible.txt | 1048576 | Google | 5.33 | 12.28 | 2.30 | 80.78 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.56 | 8.93 | 2.51 | 39.84 |
| canterbury-large/world192.txt | 1048576 | Google | 6.21 | 12.84 | 2.07 | 114.50 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.44 | 9.38 | 2.11 | 77.15 |
| http/html-1kx1024 | 1048576 | Google | 18.02 | 41.93 | 2.33 | 386.86 |
| http/html-1kx1024 | 1048576 | stdx | 15.41 | 37.56 | 2.44 | 359.82 |
| http/html-16kx64 | 1048576 | Google | 6.74 | 14.85 | 2.20 | 149.26 |
| http/html-16kx64 | 1048576 | stdx | 5.25 | 12.15 | 2.31 | 115.13 |
| http/html-1m | 1048576 | Google | 4.06 | 8.94 | 2.20 | 82.92 |
| http/html-1m | 1048576 | stdx | 2.87 | 6.52 | 2.27 | 55.22 |
| http/json-1kx1024 | 1048576 | Google | 14.46 | 36.64 | 2.53 | 240.82 |
| http/json-1kx1024 | 1048576 | stdx | 13.06 | 33.63 | 2.58 | 278.64 |
| http/json-16kx64 | 1048576 | Google | 4.44 | 11.43 | 2.58 | 82.93 |
| http/json-16kx64 | 1048576 | stdx | 3.41 | 8.42 | 2.47 | 83.96 |
| http/json-1m | 1048576 | Google | 3.42 | 8.65 | 2.53 | 60.06 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.44 | 57.30 |
| http/js-1kx1024 | 1048576 | Google | 19.90 | 46.20 | 2.32 | 424.30 |
| http/js-1kx1024 | 1048576 | stdx | 16.52 | 39.90 | 2.41 | 379.49 |
| http/js-16kx64 | 1048576 | Google | 8.03 | 17.73 | 2.21 | 166.31 |
| http/js-16kx64 | 1048576 | stdx | 6.14 | 14.36 | 2.34 | 125.90 |
| http/js-1m | 1048576 | Google | 4.37 | 9.54 | 2.18 | 82.73 |
| http/js-1m | 1048576 | stdx | 3.19 | 7.25 | 2.27 | 55.69 |
| http/css-1kx1024 | 1048576 | Google | 15.51 | 37.36 | 2.41 | 294.44 |
| http/css-1kx1024 | 1048576 | stdx | 13.88 | 34.70 | 2.50 | 301.74 |
| http/css-16kx64 | 1048576 | Google | 4.97 | 11.76 | 2.37 | 102.96 |
| http/css-16kx64 | 1048576 | stdx | 3.89 | 9.54 | 2.45 | 80.77 |
| http/css-1m | 1048576 | Google | 2.45 | 9.42 | 3.85 | 17.04 |
| http/css-1m | 1048576 | stdx | 0.76 | 1.86 | 2.45 | 12.17 |
| shuffled/dickens-1m | 1048576 | Google | 10.10 | 20.65 | 2.04 | 106.01 |
| shuffled/dickens-1m | 1048576 | stdx | 8.76 | 14.53 | 1.66 | 117.83 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.21 | 36.91 | 2.43 | 410.05 |
| silesia/dickens | 10192446 | 1 | stdx | 16.39 | 38.17 | 2.33 | 360.84 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.02 | 87.63 | 1.68 | 693.36 |
| silesia/dickens | 10192446 | 6 | stdx | 49.60 | 84.26 | 1.70 | 1446.16 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.72 | 160.47 | 1.44 | 927.91 |
| silesia/dickens | 10192446 | 9 | stdx | 85.57 | 191.81 | 2.24 | 1714.69 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.11 | 32.62 | 2.31 | 438.36 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.37 | 30.24 | 2.26 | 295.54 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.87 | 70.83 | 2.15 | 580.81 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.57 | 69.96 | 2.22 | 736.86 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.47 | 221.49 | 1.74 | 767.22 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.96 | 126.12 | 2.58 | 790.05 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.94 | 35.02 | 2.93 | 229.49 |
| silesia/mr | 9970564 | 1 | stdx | 12.55 | 34.08 | 2.72 | 186.80 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.20 | 80.54 | 2.11 | 437.27 |
| silesia/mr | 9970564 | 6 | stdx | 39.69 | 83.19 | 2.10 | 973.96 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.63 | 165.48 | 1.69 | 751.39 |
| silesia/mr | 9970564 | 9 | stdx | 87.29 | 206.31 | 2.36 | 1326.20 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.21 | 18.42 | 2.96 | 115.61 |
| silesia/nci | 33553445 | 1 | stdx | 4.96 | 10.88 | 2.19 | 98.16 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.94 | 34.84 | 2.06 | 225.23 |
| silesia/nci | 33553445 | 6 | stdx | 14.38 | 29.54 | 2.05 | 393.97 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.30 | 105.28 | 1.69 | 499.00 |
| silesia/nci | 33553445 | 9 | stdx | 33.24 | 80.64 | 2.43 | 648.24 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.88 | 39.15 | 1.97 | 754.11 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.64 | 39.08 | 2.22 | 428.50 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 40.89 | 79.10 | 1.93 | 951.40 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.43 | 87.83 | 2.12 | 998.86 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.51 | 127.63 | 1.71 | 1128.77 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.22 | 129.17 | 2.47 | 935.91 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.85 | 30.15 | 2.35 | 352.77 |
| silesia/osdb | 10085684 | 1 | stdx | 12.90 | 27.87 | 2.16 | 294.16 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.26 | 55.67 | 1.97 | 491.87 |
| silesia/osdb | 10085684 | 6 | stdx | 26.94 | 57.40 | 2.13 | 565.93 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.88 | 64.15 | 1.89 | 552.39 |
| silesia/osdb | 10085684 | 9 | stdx | 35.73 | 87.23 | 2.44 | 686.85 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.58 | 32.88 | 2.61 | 311.89 |
| silesia/reymont | 6627202 | 1 | stdx | 13.38 | 33.24 | 2.48 | 271.53 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.08 | 86.58 | 1.80 | 522.33 |
| silesia/reymont | 6627202 | 6 | stdx | 45.11 | 76.82 | 1.70 | 1424.62 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.08 | 276.14 | 1.39 | 837.69 |
| silesia/reymont | 6627202 | 9 | stdx | 87.64 | 189.98 | 2.17 | 1609.20 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.43 | 26.53 | 2.54 | 272.96 |
| silesia/samba | 21606400 | 1 | stdx | 9.90 | 22.23 | 2.25 | 220.57 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.93 | 58.79 | 2.03 | 385.24 |
| silesia/samba | 21606400 | 6 | stdx | 24.07 | 49.84 | 2.07 | 618.70 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.15 | 141.44 | 1.68 | 505.22 |
| silesia/samba | 21606400 | 9 | stdx | 41.77 | 102.63 | 2.46 | 728.37 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.71 | 47.87 | 2.20 | 688.77 |
| silesia/sao | 7251944 | 1 | stdx | 19.07 | 49.92 | 2.62 | 346.87 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.10 | 96.89 | 1.90 | 964.35 |
| silesia/sao | 7251944 | 6 | stdx | 47.04 | 105.66 | 2.25 | 849.13 |
| silesia/sao | 7251944 | 9 | libdeflate | 70.92 | 120.26 | 1.70 | 1108.42 |
| silesia/sao | 7251944 | 9 | stdx | 55.43 | 138.16 | 2.49 | 846.29 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.12 | 30.45 | 2.32 | 388.33 |
| silesia/webster | 41458703 | 1 | stdx | 13.85 | 29.09 | 2.10 | 339.80 |
| silesia/webster | 41458703 | 6 | libdeflate | 36.99 | 66.02 | 1.78 | 570.03 |
| silesia/webster | 41458703 | 6 | stdx | 35.01 | 60.88 | 1.74 | 1097.90 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.50 | 138.85 | 1.47 | 752.83 |
| silesia/webster | 41458703 | 9 | stdx | 61.12 | 135.96 | 2.22 | 1287.23 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.73 | 49.67 | 2.09 | 790.70 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.53 | 50.82 | 2.90 | 261.41 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.84 | 82.77 | 2.52 | 852.70 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.81 | 98.12 | 2.90 | 540.87 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.48 | 91.03 | 2.43 | 1029.36 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.78 | 122.06 | 2.99 | 466.78 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.78 | 21.59 | 2.77 | 176.34 |
| silesia/xml | 5345280 | 1 | stdx | 6.85 | 15.66 | 2.29 | 155.71 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.01 | 40.51 | 1.93 | 264.24 |
| silesia/xml | 5345280 | 6 | stdx | 17.54 | 34.32 | 1.96 | 496.94 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.44 | 89.17 | 1.53 | 370.00 |
| silesia/xml | 5345280 | 9 | stdx | 31.06 | 72.83 | 2.34 | 597.10 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.28 | 35.61 | 2.49 | 380.92 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.01 | 36.13 | 2.41 | 335.46 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.69 | 82.29 | 1.76 | 641.09 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.59 | 77.43 | 1.78 | 1311.28 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.58 | 159.21 | 1.48 | 851.93 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 73.09 | 167.73 | 2.29 | 1505.96 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.17 | 37.20 | 2.45 | 416.66 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.79 | 37.43 | 2.37 | 359.25 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.33 | 85.43 | 1.77 | 719.70 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 45.99 | 81.93 | 1.78 | 1370.30 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.96 | 136.15 | 1.53 | 943.57 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 76.08 | 175.98 | 2.31 | 1606.26 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.74 | 32.02 | 2.73 | 285.67 |
| canterbury/cp.html | 24603 | 1 | stdx | 10.87 | 27.13 | 2.49 | 238.82 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 27.08 | 62.33 | 2.30 | 494.15 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.77 | 57.06 | 2.40 | 625.79 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.94 | 91.97 | 1.96 | 601.80 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.26 | 88.89 | 2.84 | 637.96 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.47 | 35.92 | 3.79 | 59.80 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.10 | 30.06 | 3.71 | 23.41 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.46 | 69.37 | 2.84 | 246.00 |
| canterbury/fields.c | 11150 | 6 | stdx | 21.14 | 57.62 | 2.73 | 444.35 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.73 | 100.81 | 2.25 | 432.27 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.52 | 92.66 | 3.25 | 445.47 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.01 | 51.51 | 3.96 | 12.75 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.91 | 39.03 | 3.94 | 1.69 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.72 | 87.06 | 3.67 | 27.17 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.28 | 70.82 | 4.10 | 19.31 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 31.13 | 102.89 | 3.31 | 64.05 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.62 | 99.32 | 4.21 | 57.99 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.37 | 27.18 | 3.69 | 65.17 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.05 | 22.58 | 3.20 | 63.28 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.80 | 73.85 | 2.66 | 96.14 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.33 | 62.00 | 3.21 | 138.26 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.19 | 664.23 | 1.83 | 163.08 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.73 | 130.89 | 3.47 | 219.37 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.77 | 33.99 | 2.47 | 370.33 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.46 | 33.93 | 2.35 | 329.21 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.04 | 78.22 | 1.74 | 609.70 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.65 | 73.43 | 1.76 | 1225.69 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.68 | 136.94 | 1.49 | 804.35 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 71.02 | 162.25 | 2.28 | 1441.99 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.81 | 38.62 | 2.44 | 426.99 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.74 | 40.25 | 2.40 | 370.27 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.16 | 91.90 | 1.70 | 755.43 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.49 | 88.90 | 1.73 | 1495.46 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.79 | 166.26 | 1.42 | 1002.58 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 89.20 | 201.33 | 2.26 | 1797.78 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.42 | 18.61 | 2.90 | 141.41 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.97 | 11.03 | 2.22 | 123.29 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.26 | 36.17 | 2.54 | 219.73 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.35 | 29.58 | 2.40 | 310.59 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.43 | 120.86 | 2.00 | 372.91 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.27 | 130.09 | 3.01 | 641.61 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.85 | 33.49 | 2.61 | 339.95 |
| canterbury/sum | 38240 | 1 | stdx | 12.68 | 29.36 | 2.32 | 305.37 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.75 | 69.87 | 2.43 | 508.51 |
| canterbury/sum | 38240 | 6 | stdx | 26.77 | 65.74 | 2.46 | 662.62 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.24 | 181.91 | 1.93 | 608.48 |
| canterbury/sum | 38240 | 9 | stdx | 39.31 | 112.34 | 2.86 | 657.20 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.33 | 53.06 | 3.98 | 24.90 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.69 | 43.11 | 4.03 | 2.27 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.86 | 87.70 | 3.84 | 64.95 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 17.94 | 74.37 | 4.15 | 38.64 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 25.76 | 94.34 | 3.66 | 136.44 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 25.95 | 106.97 | 4.12 | 103.81 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.04 | 40.47 | 3.36 | 164.86 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.54 | 42.29 | 3.37 | 101.01 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.14 | 395.99 | 2.16 | 261.36 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.85 | 374.13 | 3.05 | 1903.78 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.76 | 1063.49 | 1.30 | 1322.66 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 229.16 | 755.68 | 3.30 | 2424.61 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.53 | 32.38 | 2.58 | 312.26 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.19 | 32.23 | 2.44 | 281.85 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 45.95 | 80.12 | 1.74 | 523.53 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 41.88 | 72.39 | 1.73 | 1249.83 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.63 | 200.28 | 1.41 | 743.89 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.60 | 170.21 | 2.22 | 1440.38 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.30 | 29.72 | 2.23 | 413.96 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.09 | 28.55 | 2.03 | 379.07 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 32.95 | 60.25 | 1.83 | 559.46 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 31.69 | 56.81 | 1.79 | 971.94 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.44 | 119.11 | 1.48 | 685.38 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 52.15 | 117.95 | 2.26 | 1144.30 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.41 | 103.92 | 2.93 | 453.37 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.34 | 58.69 | 2.75 | 365.56 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.13 | 138.34 | 3.00 | 562.73 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 32.12 | 94.36 | 2.94 | 529.00 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.65 | 142.44 | 2.99 | 587.59 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 36.20 | 112.18 | 3.10 | 540.01 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.46 | 27.96 | 2.67 | 267.33 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.01 | 20.25 | 2.25 | 233.23 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.45 | 52.09 | 2.32 | 404.53 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.85 | 42.87 | 2.27 | 538.67 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 34.98 | 72.54 | 2.07 | 470.65 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.83 | 69.06 | 2.78 | 549.82 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.77 | 23.03 | 2.63 | 224.75 |
| http/html-1m | 1048576 | 1 | stdx | 8.18 | 17.80 | 2.18 | 206.70 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.25 | 49.53 | 1.96 | 327.53 |
| http/html-1m | 1048576 | 6 | stdx | 21.14 | 40.71 | 1.93 | 616.24 |
| http/html-1m | 1048576 | 9 | libdeflate | 70.97 | 109.24 | 1.54 | 431.84 |
| http/html-1m | 1048576 | 9 | stdx | 35.94 | 85.76 | 2.39 | 704.85 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.82 | 94.80 | 2.98 | 302.27 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.51 | 45.22 | 2.74 | 240.80 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 42.99 | 126.60 | 2.94 | 371.26 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.26 | 78.43 | 2.88 | 376.46 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.04 | 142.45 | 2.74 | 431.73 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.85 | 95.61 | 3.10 | 386.37 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.86 | 23.85 | 3.03 | 134.95 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.44 | 13.94 | 2.56 | 110.12 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.18 | 46.61 | 2.56 | 206.11 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.40 | 35.02 | 2.61 | 275.22 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.08 | 151.99 | 1.90 | 296.03 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.22 | 58.45 | 3.04 | 302.31 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.73 | 19.85 | 2.95 | 124.31 |
| http/json-1m | 1048576 | 1 | stdx | 5.09 | 12.51 | 2.46 | 102.83 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.31 | 45.30 | 2.23 | 175.76 |
| http/json-1m | 1048576 | 6 | stdx | 14.69 | 35.09 | 2.39 | 297.77 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.35 | 205.21 | 1.69 | 275.11 |
| http/json-1m | 1048576 | 9 | stdx | 29.12 | 72.87 | 2.50 | 369.60 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.08 | 107.80 | 2.91 | 518.05 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.72 | 65.45 | 2.76 | 410.43 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.31 | 144.85 | 2.94 | 675.02 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 35.69 | 104.17 | 2.92 | 619.68 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.63 | 150.13 | 2.91 | 717.96 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 40.38 | 125.18 | 3.10 | 627.67 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.71 | 30.90 | 2.64 | 308.67 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.83 | 24.80 | 2.29 | 272.74 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.98 | 59.43 | 2.29 | 481.98 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.69 | 50.05 | 2.21 | 676.72 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.86 | 83.31 | 2.04 | 571.45 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.65 | 81.31 | 2.74 | 664.92 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.64 | 25.19 | 2.61 | 247.49 |
| http/js-1m | 1048576 | 1 | stdx | 9.56 | 21.31 | 2.23 | 233.58 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.73 | 56.12 | 1.95 | 371.47 |
| http/js-1m | 1048576 | 6 | stdx | 24.85 | 46.64 | 1.88 | 738.87 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.17 | 120.65 | 1.58 | 499.58 |
| http/js-1m | 1048576 | 9 | stdx | 42.12 | 100.01 | 2.37 | 808.62 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.21 | 97.74 | 2.94 | 375.62 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.43 | 49.57 | 2.69 | 301.34 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.80 | 129.23 | 2.95 | 477.82 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.13 | 82.37 | 2.83 | 500.50 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.72 | 133.80 | 2.93 | 505.98 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.22 | 99.53 | 3.00 | 522.75 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.64 | 25.60 | 2.96 | 173.76 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.69 | 16.96 | 2.54 | 134.89 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.29 | 48.80 | 2.41 | 295.50 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.43 | 38.01 | 2.31 | 461.47 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.81 | 82.40 | 2.02 | 375.18 |
| http/css-16kx64 | 1048576 | 9 | stdx | 23.02 | 65.14 | 2.83 | 479.02 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.97 | 21.15 | 3.03 | 134.42 |
| http/css-1m | 1048576 | 1 | stdx | 5.80 | 14.91 | 2.57 | 108.35 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.76 | 44.50 | 2.14 | 227.25 |
| http/css-1m | 1048576 | 6 | stdx | 16.56 | 35.61 | 2.15 | 441.33 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.62 | 111.58 | 1.60 | 310.22 |
| http/css-1m | 1048576 | 9 | stdx | 32.16 | 83.00 | 2.58 | 511.32 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.26 | 48.89 | 1.94 | 935.64 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.13 | 49.19 | 2.71 | 323.59 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.46 | 86.45 | 2.09 | 1181.94 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.70 | 88.80 | 2.24 | 852.60 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.00 | 94.50 | 2.01 | 1345.66 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.44 | 134.38 | 2.47 | 1132.53 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.05 | 31.22 | 3.11 | 120.05 |
| silesia/dickens | 10192446 | 1 | stdx | 24.32 | 82.03 | 3.37 | 126.66 |
| silesia/dickens | 10192446 | 3 | libzstd | 23.37 | 34.39 | 1.47 | 170.91 |
| silesia/dickens | 10192446 | 3 | stdx | 36.83 | 78.22 | 2.12 | 183.01 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.00 | 22.69 | 3.24 | 71.30 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.72 | 54.73 | 3.09 | 175.48 |
| silesia/mozilla | 51220480 | 3 | libzstd | 17.47 | 27.89 | 1.60 | 102.76 |
| silesia/mozilla | 51220480 | 3 | stdx | 31.72 | 62.01 | 1.95 | 145.29 |
| silesia/mr | 9970564 | 1 | libzstd | 7.62 | 24.81 | 3.26 | 58.35 |
| silesia/mr | 9970564 | 1 | stdx | 19.97 | 66.82 | 3.35 | 116.30 |
| silesia/mr | 9970564 | 3 | libzstd | 20.56 | 32.19 | 1.57 | 87.23 |
| silesia/mr | 9970564 | 3 | stdx | 34.56 | 72.46 | 2.10 | 114.95 |
| silesia/nci | 33553445 | 1 | libzstd | 3.51 | 9.55 | 2.72 | 57.30 |
| silesia/nci | 33553445 | 1 | stdx | 7.80 | 25.69 | 3.29 | 60.50 |
| silesia/nci | 33553445 | 3 | libzstd | 5.51 | 9.95 | 1.81 | 56.53 |
| silesia/nci | 33553445 | 3 | stdx | 11.55 | 29.15 | 2.52 | 67.13 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.54 | 29.26 | 3.43 | 72.35 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.15 | 72.51 | 3.13 | 182.10 |
| silesia/ooffice | 6152192 | 3 | libzstd | 24.24 | 39.44 | 1.63 | 120.23 |
| silesia/ooffice | 6152192 | 3 | stdx | 43.37 | 82.20 | 1.90 | 186.11 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.03 | 22.29 | 3.17 | 66.58 |
| silesia/osdb | 10085684 | 1 | stdx | 16.52 | 50.52 | 3.06 | 125.24 |
| silesia/osdb | 10085684 | 3 | libzstd | 18.42 | 26.23 | 1.42 | 68.08 |
| silesia/osdb | 10085684 | 3 | stdx | 33.01 | 57.87 | 1.75 | 111.98 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.69 | 27.13 | 2.80 | 150.50 |
| silesia/reymont | 6627202 | 1 | stdx | 20.28 | 72.05 | 3.55 | 97.99 |
| silesia/reymont | 6627202 | 3 | libzstd | 18.67 | 27.10 | 1.45 | 126.27 |
| silesia/reymont | 6627202 | 3 | stdx | 28.58 | 62.18 | 2.18 | 148.11 |
| silesia/samba | 21606400 | 1 | libzstd | 5.91 | 16.88 | 2.86 | 85.44 |
| silesia/samba | 21606400 | 1 | stdx | 13.57 | 42.89 | 3.16 | 126.60 |
| silesia/samba | 21606400 | 3 | libzstd | 12.19 | 18.81 | 1.54 | 99.58 |
| silesia/samba | 21606400 | 3 | stdx | 20.90 | 44.75 | 2.14 | 134.27 |
| silesia/sao | 7251944 | 1 | libzstd | 9.04 | 33.69 | 3.73 | 45.46 |
| silesia/sao | 7251944 | 1 | stdx | 25.95 | 82.03 | 3.16 | 109.45 |
| silesia/sao | 7251944 | 3 | libzstd | 32.20 | 50.03 | 1.55 | 95.48 |
| silesia/sao | 7251944 | 3 | stdx | 53.09 | 95.22 | 1.79 | 143.00 |
| silesia/webster | 41458703 | 1 | libzstd | 8.64 | 24.94 | 2.89 | 131.31 |
| silesia/webster | 41458703 | 1 | stdx | 20.36 | 64.04 | 3.14 | 168.43 |
| silesia/webster | 41458703 | 3 | libzstd | 19.56 | 27.33 | 1.40 | 177.82 |
| silesia/webster | 41458703 | 3 | stdx | 31.70 | 64.55 | 2.04 | 196.21 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.66 | 14.92 | 3.20 | 17.03 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.82 | 76.64 | 3.22 | 92.98 |
| silesia/x-ray | 8474240 | 3 | libzstd | 32.99 | 52.73 | 1.60 | 88.44 |
| silesia/x-ray | 8474240 | 3 | stdx | 49.13 | 92.40 | 1.88 | 105.73 |
| silesia/xml | 5345280 | 1 | libzstd | 4.21 | 11.71 | 2.78 | 71.27 |
| silesia/xml | 5345280 | 1 | stdx | 10.37 | 34.21 | 3.30 | 95.40 |
| silesia/xml | 5345280 | 3 | libzstd | 6.76 | 12.61 | 1.86 | 77.53 |
| silesia/xml | 5345280 | 3 | stdx | 12.90 | 32.28 | 2.50 | 116.78 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.78 | 32.84 | 3.05 | 139.45 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.37 | 76.49 | 3.42 | 190.86 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.54 | 39.48 | 2.54 | 203.64 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.73 | 73.76 | 2.76 | 338.36 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.70 | 33.55 | 3.46 | 102.32 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.60 | 79.00 | 3.35 | 219.34 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.19 | 39.27 | 2.58 | 209.15 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.28 | 79.30 | 2.80 | 377.31 |
| canterbury/cp.html | 24603 | 1 | libzstd | 7.03 | 26.64 | 3.79 | 43.35 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.21 | 57.76 | 3.56 | 125.78 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.50 | 31.85 | 3.35 | 48.29 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.25 | 59.76 | 3.27 | 137.31 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.67 | 31.76 | 3.66 | 41.92 |
| canterbury/fields.c | 11150 | 1 | stdx | 17.09 | 65.73 | 3.85 | 90.99 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.26 | 34.14 | 3.68 | 25.43 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.31 | 64.68 | 3.74 | 92.45 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.47 | 38.01 | 4.01 | 11.05 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.39 | 77.57 | 3.80 | 55.65 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.61 | 43.09 | 4.06 | 7.44 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.36 | 79.60 | 3.73 | 63.94 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.03 | 23.56 | 3.91 | 14.80 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.75 | 56.75 | 3.85 | 87.77 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.68 | 23.80 | 2.74 | 27.39 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 20.86 | 56.61 | 2.71 | 108.62 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.81 | 28.52 | 2.91 | 155.96 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.45 | 72.02 | 3.36 | 162.67 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 16.80 | 32.14 | 1.91 | 202.58 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.71 | 67.10 | 2.51 | 298.92 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.32 | 32.37 | 3.14 | 128.80 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.17 | 84.16 | 3.34 | 160.80 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 21.03 | 38.77 | 1.84 | 228.96 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 32.25 | 80.77 | 2.50 | 345.46 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.14 | 8.51 | 2.71 | 66.76 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.53 | 23.15 | 3.08 | 106.44 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 5.02 | 10.97 | 2.19 | 59.12 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.67 | 24.08 | 2.49 | 133.99 |
| canterbury/sum | 38240 | 1 | libzstd | 6.56 | 25.39 | 3.87 | 33.59 |
| canterbury/sum | 38240 | 1 | stdx | 17.02 | 59.13 | 3.47 | 158.23 |
| canterbury/sum | 38240 | 3 | libzstd | 9.02 | 30.67 | 3.40 | 47.50 |
| canterbury/sum | 38240 | 3 | stdx | 19.84 | 61.82 | 3.12 | 184.68 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 9.96 | 39.82 | 4.00 | 11.98 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 21.00 | 80.38 | 3.83 | 62.39 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.17 | 48.17 | 3.96 | 13.77 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.85 | 83.98 | 3.68 | 78.87 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.33 | 33.44 | 3.24 | 76.36 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.77 | 95.62 | 4.39 | 7.20 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 15.26 | 31.30 | 2.05 | 35.90 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 24.06 | 70.38 | 2.92 | 39.02 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.68 | 27.45 | 2.83 | 149.92 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.37 | 71.86 | 3.53 | 109.35 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 18.53 | 28.20 | 1.52 | 132.94 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 28.70 | 63.36 | 2.21 | 156.28 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.14 | 22.70 | 2.79 | 137.34 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.68 | 55.86 | 2.99 | 196.03 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 15.87 | 23.87 | 1.50 | 175.95 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 25.73 | 51.26 | 1.99 | 240.01 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 16.96 | 52.46 | 3.09 | 159.72 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.91 | 100.54 | 2.80 | 643.25 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 18.94 | 59.20 | 3.13 | 196.98 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 37.94 | 104.00 | 2.74 | 637.23 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.71 | 22.46 | 2.91 | 122.69 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.14 | 46.84 | 3.31 | 184.02 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.76 | 24.61 | 2.81 | 141.99 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.55 | 47.61 | 3.06 | 194.16 |
| http/html-1m | 1048576 | 1 | libzstd | 6.21 | 16.74 | 2.70 | 114.40 |
| http/html-1m | 1048576 | 1 | stdx | 12.96 | 42.00 | 3.24 | 135.78 |
| http/html-1m | 1048576 | 3 | libzstd | 9.60 | 18.18 | 1.89 | 126.92 |
| http/html-1m | 1048576 | 3 | stdx | 16.00 | 39.37 | 2.46 | 179.07 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.24 | 42.52 | 2.99 | 115.53 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.59 | 83.13 | 2.81 | 529.76 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.73 | 44.54 | 3.03 | 128.95 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.73 | 84.87 | 2.76 | 535.10 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.78 | 14.98 | 3.13 | 57.43 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.69 | 33.78 | 3.49 | 117.33 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.33 | 16.21 | 3.04 | 72.47 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.63 | 34.58 | 3.25 | 123.37 |
| http/json-1m | 1048576 | 1 | libzstd | 4.03 | 12.55 | 3.12 | 52.28 |
| http/json-1m | 1048576 | 1 | stdx | 9.05 | 30.70 | 3.39 | 86.96 |
| http/json-1m | 1048576 | 3 | libzstd | 6.32 | 13.78 | 2.18 | 68.68 |
| http/json-1m | 1048576 | 3 | stdx | 11.53 | 30.64 | 2.66 | 120.48 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.44 | 57.26 | 3.10 | 184.02 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 40.04 | 113.49 | 2.83 | 702.73 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.31 | 65.54 | 3.08 | 259.98 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.05 | 116.54 | 2.77 | 684.22 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.81 | 26.52 | 3.01 | 127.38 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.61 | 55.71 | 3.35 | 202.87 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.05 | 28.74 | 2.86 | 154.90 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.82 | 55.35 | 3.11 | 211.61 |
| http/js-1m | 1048576 | 1 | libzstd | 6.53 | 17.87 | 2.74 | 113.58 |
| http/js-1m | 1048576 | 1 | stdx | 13.99 | 45.88 | 3.28 | 137.86 |
| http/js-1m | 1048576 | 3 | libzstd | 10.23 | 19.14 | 1.87 | 125.20 |
| http/js-1m | 1048576 | 3 | stdx | 17.27 | 41.25 | 2.39 | 188.37 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.47 | 46.90 | 3.03 | 137.70 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.37 | 91.65 | 2.83 | 583.92 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.53 | 50.53 | 3.06 | 158.95 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.58 | 93.63 | 2.79 | 584.97 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.11 | 18.99 | 3.11 | 78.42 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.40 | 43.79 | 3.53 | 138.09 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.55 | 19.41 | 2.96 | 95.39 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.96 | 42.34 | 3.27 | 152.72 |
| http/css-1m | 1048576 | 1 | libzstd | 1.50 | 4.59 | 3.05 | 21.76 |
| http/css-1m | 1048576 | 1 | stdx | 4.01 | 14.85 | 3.70 | 30.66 |
| http/css-1m | 1048576 | 3 | libzstd | 2.00 | 5.25 | 2.62 | 19.75 |
| http/css-1m | 1048576 | 3 | stdx | 4.01 | 13.33 | 3.32 | 31.86 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.51 | 12.79 | 3.64 | 6.17 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.15 | 30.66 | 3.35 | 62.79 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 29.14 | 50.53 | 1.73 | 49.42 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 21.32 | 47.43 | 2.22 | 210.29 |

## Hardware counters per input octet, brotli encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | Google q1 | 17.90 | 30.24 | 1.69 | 231.59 |
| silesia/dickens | 10192446 | stdx 1 | 19.47 | 43.43 | 2.23 | 413.72 |
| silesia/dickens | 10192446 | Google q5 | 101.77 | 194.36 | 1.91 | 818.54 |
| silesia/dickens | 10192446 | stdx 5 | 70.77 | 156.51 | 2.21 | 981.93 |
| silesia/mozilla | 51220480 | Google q1 | 12.91 | 25.26 | 1.96 | 144.68 |
| silesia/mozilla | 51220480 | stdx 1 | 12.34 | 32.95 | 2.67 | 213.96 |
| silesia/mozilla | 51220480 | Google q5 | 61.86 | 149.30 | 2.41 | 796.30 |
| silesia/mozilla | 51220480 | stdx 5 | 58.42 | 149.71 | 2.56 | 809.60 |
| silesia/mr | 9970564 | Google q1 | 12.92 | 26.14 | 2.02 | 97.70 |
| silesia/mr | 9970564 | stdx 1 | 13.69 | 37.80 | 2.76 | 164.89 |
| silesia/mr | 9970564 | Google q5 | 79.53 | 177.41 | 2.23 | 607.65 |
| silesia/mr | 9970564 | stdx 5 | 62.33 | 150.44 | 2.41 | 698.51 |
| silesia/nci | 33553445 | Google q1 | 5.20 | 9.71 | 1.87 | 89.03 |
| silesia/nci | 33553445 | stdx 1 | 6.07 | 14.48 | 2.39 | 127.88 |
| silesia/nci | 33553445 | Google q5 | 30.66 | 59.01 | 1.92 | 410.26 |
| silesia/nci | 33553445 | stdx 5 | 26.46 | 58.75 | 2.22 | 474.85 |
| silesia/ooffice | 6152192 | Google q1 | 17.01 | 33.43 | 1.97 | 154.39 |
| silesia/ooffice | 6152192 | stdx 1 | 16.83 | 45.85 | 2.72 | 266.78 |
| silesia/ooffice | 6152192 | Google q5 | 86.74 | 198.80 | 2.29 | 1062.50 |
| silesia/ooffice | 6152192 | stdx 5 | 73.99 | 180.71 | 2.44 | 1065.96 |
| silesia/osdb | 10085684 | Google q1 | 12.22 | 23.47 | 1.92 | 83.92 |
| silesia/osdb | 10085684 | stdx 1 | 11.63 | 32.00 | 2.75 | 141.60 |
| silesia/osdb | 10085684 | Google q5 | 66.65 | 146.01 | 2.19 | 545.64 |
| silesia/osdb | 10085684 | stdx 5 | 50.02 | 125.21 | 2.50 | 517.44 |
| silesia/reymont | 6627202 | Google q1 | 15.19 | 25.54 | 1.68 | 207.03 |
| silesia/reymont | 6627202 | stdx 1 | 14.44 | 33.36 | 2.31 | 283.69 |
| silesia/reymont | 6627202 | Google q5 | 78.77 | 169.16 | 2.15 | 797.99 |
| silesia/reymont | 6627202 | stdx 5 | 60.17 | 140.32 | 2.33 | 893.92 |
| silesia/samba | 21606400 | Google q1 | 9.72 | 17.38 | 1.79 | 127.48 |
| silesia/samba | 21606400 | stdx 1 | 9.94 | 23.94 | 2.41 | 198.07 |
| silesia/samba | 21606400 | Google q5 | 46.81 | 105.54 | 2.25 | 478.22 |
| silesia/samba | 21606400 | stdx 5 | 41.10 | 103.19 | 2.51 | 525.21 |
| silesia/sao | 7251944 | Google q1 | 20.21 | 39.96 | 1.98 | 100.38 |
| silesia/sao | 7251944 | stdx 1 | 18.77 | 55.66 | 2.96 | 189.90 |
| silesia/sao | 7251944 | Google q5 | 107.48 | 259.63 | 2.42 | 926.41 |
| silesia/sao | 7251944 | stdx 5 | 89.47 | 233.57 | 2.61 | 742.22 |
| silesia/webster | 41458703 | Google q1 | 14.36 | 24.40 | 1.70 | 208.51 |
| silesia/webster | 41458703 | stdx 1 | 15.32 | 34.12 | 2.23 | 339.84 |
| silesia/webster | 41458703 | Google q5 | 74.11 | 141.82 | 1.91 | 751.59 |
| silesia/webster | 41458703 | stdx 5 | 56.30 | 122.07 | 2.17 | 839.70 |
| silesia/x-ray | 8474240 | Google q1 | 13.80 | 22.03 | 1.60 | 12.34 |
| silesia/x-ray | 8474240 | stdx 1 | 13.09 | 38.68 | 2.95 | 94.24 |
| silesia/x-ray | 8474240 | Google q5 | 98.76 | 236.76 | 2.40 | 725.03 |
| silesia/x-ray | 8474240 | stdx 5 | 85.74 | 231.05 | 2.69 | 653.34 |
| silesia/xml | 5345280 | Google q1 | 6.92 | 12.28 | 1.77 | 114.05 |
| silesia/xml | 5345280 | stdx 1 | 7.27 | 17.44 | 2.40 | 152.90 |
| silesia/xml | 5345280 | Google q5 | 30.96 | 72.50 | 2.34 | 357.90 |
| silesia/xml | 5345280 | stdx 5 | 26.15 | 65.03 | 2.49 | 404.11 |
| canterbury/alice29.txt | 152089 | Google q1 | 16.73 | 29.72 | 1.78 | 208.43 |
| canterbury/alice29.txt | 152089 | stdx 1 | 18.35 | 40.79 | 2.22 | 449.83 |
| canterbury/alice29.txt | 152089 | Google q5 | 80.64 | 200.77 | 2.49 | 1036.56 |
| canterbury/alice29.txt | 152089 | stdx 5 | 59.33 | 148.01 | 2.49 | 898.71 |
| canterbury/asyoulik.txt | 125179 | Google q1 | 17.99 | 32.37 | 1.80 | 223.40 |
| canterbury/asyoulik.txt | 125179 | stdx 1 | 20.14 | 44.50 | 2.21 | 501.43 |
| canterbury/asyoulik.txt | 125179 | Google q5 | 86.37 | 215.27 | 2.49 | 1079.99 |
| canterbury/asyoulik.txt | 125179 | stdx 5 | 65.77 | 159.47 | 2.42 | 1041.58 |
| canterbury/cp.html | 24603 | Google q1 | 13.15 | 27.30 | 2.08 | 113.31 |
| canterbury/cp.html | 24603 | stdx 1 | 14.58 | 36.07 | 2.47 | 352.21 |
| canterbury/cp.html | 24603 | Google q5 | 60.98 | 163.89 | 2.69 | 943.95 |
| canterbury/cp.html | 24603 | stdx 5 | 46.43 | 128.83 | 2.77 | 720.14 |
| canterbury/fields.c | 11150 | Google q1 | 11.99 | 29.04 | 2.42 | 12.20 |
| canterbury/fields.c | 11150 | stdx 1 | 10.50 | 38.87 | 3.70 | 87.49 |
| canterbury/fields.c | 11150 | Google q5 | 58.87 | 168.16 | 2.86 | 909.88 |
| canterbury/fields.c | 11150 | stdx 5 | 40.03 | 120.96 | 3.02 | 546.27 |
| canterbury/grammar.lsp | 3721 | Google q1 | 14.31 | 39.39 | 2.75 | 7.87 |
| canterbury/grammar.lsp | 3721 | stdx 1 | 13.51 | 55.22 | 4.09 | 32.05 |
| canterbury/grammar.lsp | 3721 | Google q5 | 60.90 | 203.91 | 3.35 | 438.16 |
| canterbury/grammar.lsp | 3721 | stdx 5 | 39.36 | 145.59 | 3.70 | 179.87 |
| canterbury/kennedy.xls | 1029744 | Google q1 | 9.74 | 24.83 | 2.55 | 59.57 |
| canterbury/kennedy.xls | 1029744 | stdx 1 | 7.82 | 27.03 | 3.46 | 77.04 |
| canterbury/kennedy.xls | 1029744 | Google q5 | 47.76 | 162.91 | 3.41 | 262.88 |
| canterbury/kennedy.xls | 1029744 | stdx 5 | 50.20 | 162.41 | 3.24 | 468.74 |
| canterbury/lcet10.txt | 426754 | Google q1 | 15.86 | 27.19 | 1.71 | 203.22 |
| canterbury/lcet10.txt | 426754 | stdx 1 | 16.81 | 37.84 | 2.25 | 381.18 |
| canterbury/lcet10.txt | 426754 | Google q5 | 78.65 | 187.58 | 2.38 | 957.92 |
| canterbury/lcet10.txt | 426754 | stdx 5 | 57.61 | 139.70 | 2.43 | 891.00 |
| canterbury/plrabn12.txt | 481861 | Google q1 | 18.95 | 32.57 | 1.72 | 250.48 |
| canterbury/plrabn12.txt | 481861 | stdx 1 | 20.81 | 46.66 | 2.24 | 472.63 |
| canterbury/plrabn12.txt | 481861 | Google q5 | 97.05 | 229.77 | 2.37 | 1067.76 |
| canterbury/plrabn12.txt | 481861 | stdx 5 | 72.22 | 167.86 | 2.32 | 1169.75 |
| canterbury/ptt5 | 513216 | Google q1 | 4.91 | 9.55 | 1.95 | 80.28 |
| canterbury/ptt5 | 513216 | stdx 1 | 6.66 | 15.64 | 2.35 | 160.46 |
| canterbury/ptt5 | 513216 | Google q5 | 27.46 | 68.87 | 2.51 | 468.42 |
| canterbury/ptt5 | 513216 | stdx 5 | 27.80 | 69.27 | 2.49 | 457.44 |
| canterbury/sum | 38240 | Google q1 | 12.92 | 29.25 | 2.26 | 89.03 |
| canterbury/sum | 38240 | stdx 1 | 15.55 | 36.37 | 2.34 | 406.73 |
| canterbury/sum | 38240 | Google q5 | 66.33 | 182.58 | 2.75 | 1095.36 |
| canterbury/sum | 38240 | stdx 5 | 56.23 | 155.87 | 2.77 | 827.11 |
| canterbury/xargs.1 | 4227 | Google q1 | 16.19 | 43.16 | 2.67 | 13.55 |
| canterbury/xargs.1 | 4227 | stdx 1 | 14.68 | 59.10 | 4.02 | 41.74 |
| canterbury/xargs.1 | 4227 | Google q5 | 71.17 | 219.02 | 3.08 | 734.98 |
| canterbury/xargs.1 | 4227 | stdx 5 | 43.98 | 155.91 | 3.55 | 295.12 |
| canterbury-large/E.coli | 4638690 | Google q1 | 13.54 | 27.46 | 2.03 | 53.50 |
| canterbury-large/E.coli | 4638690 | stdx 1 | 5.62 | 19.24 | 3.43 | 18.11 |
| canterbury-large/E.coli | 4638690 | Google q5 | 89.04 | 262.67 | 2.95 | 997.42 |
| canterbury-large/E.coli | 4638690 | stdx 5 | 30.85 | 93.11 | 3.02 | 64.71 |
| canterbury-large/bible.txt | 4047392 | Google q1 | 14.57 | 24.57 | 1.69 | 175.88 |
| canterbury-large/bible.txt | 4047392 | stdx 1 | 15.22 | 34.29 | 2.25 | 317.49 |
| canterbury-large/bible.txt | 4047392 | Google q5 | 78.02 | 165.65 | 2.12 | 729.94 |
| canterbury-large/bible.txt | 4047392 | stdx 5 | 57.94 | 134.78 | 2.33 | 800.68 |
| canterbury-large/world192.txt | 2473400 | Google q1 | 13.39 | 22.62 | 1.69 | 194.23 |
| canterbury-large/world192.txt | 2473400 | stdx 1 | 13.70 | 31.07 | 2.27 | 316.24 |
| canterbury-large/world192.txt | 2473400 | Google q5 | 67.12 | 129.46 | 1.93 | 739.54 |
| canterbury-large/world192.txt | 2473400 | stdx 5 | 47.61 | 105.74 | 2.22 | 750.01 |
| http/html-1kx1024 | 1048576 | Google q1 | 32.25 | 62.53 | 1.94 | 864.86 |
| http/html-1kx1024 | 1048576 | stdx 1 | 27.29 | 80.73 | 2.96 | 476.18 |
| http/html-1kx1024 | 1048576 | Google q5 | 107.89 | 260.90 | 2.42 | 2129.21 |
| http/html-1kx1024 | 1048576 | stdx 5 | 63.35 | 167.89 | 2.65 | 1111.68 |
| http/html-16kx64 | 1048576 | Google q1 | 11.25 | 20.38 | 1.81 | 214.98 |
| http/html-16kx64 | 1048576 | stdx 1 | 11.47 | 28.46 | 2.48 | 302.53 |
| http/html-16kx64 | 1048576 | Google q5 | 46.92 | 118.53 | 2.53 | 854.20 |
| http/html-16kx64 | 1048576 | stdx 5 | 35.67 | 92.10 | 2.58 | 636.35 |
| http/html-1m | 1048576 | Google q1 | 8.84 | 15.15 | 1.71 | 137.78 |
| http/html-1m | 1048576 | stdx 1 | 9.66 | 22.18 | 2.30 | 226.45 |
| http/html-1m | 1048576 | Google q5 | 44.89 | 104.93 | 2.34 | 573.00 |
| http/html-1m | 1048576 | stdx 5 | 33.57 | 84.11 | 2.51 | 533.28 |
| http/json-1kx1024 | 1048576 | Google q1 | 24.62 | 49.87 | 2.03 | 651.36 |
| http/json-1kx1024 | 1048576 | stdx 1 | 20.86 | 61.64 | 2.96 | 364.29 |
| http/json-1kx1024 | 1048576 | Google q5 | 80.26 | 203.15 | 2.53 | 1333.86 |
| http/json-1kx1024 | 1048576 | stdx 5 | 47.21 | 131.37 | 2.78 | 708.34 |
| http/json-16kx64 | 1048576 | Google q1 | 7.57 | 14.90 | 1.97 | 141.46 |
| http/json-16kx64 | 1048576 | stdx 1 | 7.04 | 19.73 | 2.80 | 159.73 |
| http/json-16kx64 | 1048576 | Google q5 | 35.97 | 97.81 | 2.72 | 556.32 |
| http/json-16kx64 | 1048576 | stdx 5 | 31.63 | 88.58 | 2.80 | 517.15 |
| http/json-1m | 1048576 | Google q1 | 6.13 | 12.65 | 2.06 | 91.89 |
| http/json-1m | 1048576 | stdx 1 | 6.62 | 17.21 | 2.60 | 140.37 |
| http/json-1m | 1048576 | Google q5 | 36.22 | 96.08 | 2.65 | 446.68 |
| http/json-1m | 1048576 | stdx 5 | 34.57 | 92.25 | 2.67 | 564.09 |
| http/js-1kx1024 | 1048576 | Google q1 | 34.87 | 68.18 | 1.96 | 912.36 |
| http/js-1kx1024 | 1048576 | stdx 1 | 30.38 | 90.40 | 2.98 | 535.15 |
| http/js-1kx1024 | 1048576 | Google q5 | 118.28 | 288.57 | 2.44 | 2311.65 |
| http/js-1kx1024 | 1048576 | stdx 5 | 69.89 | 186.45 | 2.67 | 1235.69 |
| http/js-16kx64 | 1048576 | Google q1 | 13.11 | 24.07 | 1.84 | 233.41 |
| http/js-16kx64 | 1048576 | stdx 1 | 13.36 | 32.69 | 2.45 | 356.57 |
| http/js-16kx64 | 1048576 | Google q5 | 55.27 | 141.15 | 2.55 | 997.33 |
| http/js-16kx64 | 1048576 | stdx 5 | 41.63 | 106.28 | 2.55 | 746.73 |
| http/js-1m | 1048576 | Google q1 | 9.62 | 16.69 | 1.74 | 140.80 |
| http/js-1m | 1048576 | stdx 1 | 10.17 | 23.55 | 2.32 | 230.86 |
| http/js-1m | 1048576 | Google q5 | 50.14 | 116.02 | 2.31 | 634.45 |
| http/js-1m | 1048576 | stdx 5 | 36.39 | 90.22 | 2.48 | 574.52 |
| http/css-1kx1024 | 1048576 | Google q1 | 27.64 | 54.06 | 1.96 | 728.31 |
| http/css-1kx1024 | 1048576 | stdx 1 | 23.53 | 68.32 | 2.90 | 433.70 |
| http/css-1kx1024 | 1048576 | Google q5 | 87.15 | 213.92 | 2.45 | 1664.74 |
| http/css-1kx1024 | 1048576 | stdx 5 | 50.81 | 137.20 | 2.70 | 878.48 |
| http/css-16kx64 | 1048576 | Google q1 | 8.94 | 16.85 | 1.88 | 140.86 |
| http/css-16kx64 | 1048576 | stdx 1 | 8.49 | 23.62 | 2.78 | 192.39 |
| http/css-16kx64 | 1048576 | Google q5 | 37.46 | 100.68 | 2.69 | 645.74 |
| http/css-16kx64 | 1048576 | stdx 5 | 28.82 | 80.59 | 2.80 | 486.36 |
| http/css-1m | 1048576 | Google q1 | 5.93 | 11.27 | 1.90 | 75.86 |
| http/css-1m | 1048576 | stdx 1 | 5.43 | 14.38 | 2.65 | 110.59 |
| http/css-1m | 1048576 | Google q5 | 14.32 | 38.50 | 2.69 | 129.18 |
| http/css-1m | 1048576 | stdx 5 | 11.67 | 36.69 | 3.14 | 110.61 |
| shuffled/dickens-1m | 1048576 | Google q1 | 11.41 | 20.96 | 1.84 | 2.77 |
| shuffled/dickens-1m | 1048576 | stdx 1 | 5.23 | 19.75 | 3.77 | 10.09 |
| shuffled/dickens-1m | 1048576 | Google q5 | 94.97 | 235.57 | 2.48 | 723.77 |
| shuffled/dickens-1m | 1048576 | stdx 5 | 42.21 | 122.09 | 2.89 | 202.68 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.117 | 3.00 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 66.7 | 219.6 | 0.087 | 7.88 | 3.29 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 30.6 | 96.1 | 0.163 | 3.61 | 3.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextReader.next_items | 28.3 | 80.8 | 0.152 | 3.35 | 2.85 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 248.4 | 1024.0 | 0.821 | 29.34 | 4.12 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.7 | 107.7 | 0.127 | 3.63 | 3.51 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.9 | 106.2 | 0.296 | 3.29 | 3.81 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.3 | 378.2 | 0.365 | 11.26 | 3.97 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.6 | 161.9 | 0.443 | 5.03 | 3.80 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 89.7 | 451.7 | 0.303 | 10.60 | 5.04 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.0 | 89.5 | 0.004 | 3.98 | 3.31 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 69.1 | 234.7 | 0.077 | 10.17 | 3.40 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 29.5 | 99.4 | 0.014 | 4.34 | 3.37 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextReader.next_items | 27.3 | 84.2 | 0.009 | 4.01 | 3.09 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 213.2 | 819.1 | 0.932 | 31.38 | 3.84 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.3 | 107.7 | 0.039 | 4.16 | 3.81 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.6 | 106.0 | 0.047 | 4.21 | 3.70 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 94.7 | 346.2 | 0.313 | 13.94 | 3.65 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 31.7 | 144.5 | 0.052 | 4.67 | 4.56 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 88.4 | 406.5 | 0.074 | 13.01 | 4.60 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 42.0 | 96.3 | 0.198 | 3.94 | 2.29 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 86.3 | 249.4 | 0.235 | 8.08 | 2.89 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 46.5 | 113.8 | 0.280 | 4.35 | 2.45 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextReader.next_items | 43.9 | 99.4 | 0.209 | 4.11 | 2.26 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 312.5 | 1284.6 | 1.067 | 29.27 | 4.11 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 36.2 | 133.1 | 0.184 | 3.39 | 3.68 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 46.5 | 128.6 | 0.686 | 4.35 | 2.77 |
| messages: 11 string members | 96000 | 1025025 | std.json | 123.9 | 451.2 | 1.032 | 11.60 | 3.64 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 67.5 | 204.1 | 0.983 | 6.32 | 3.02 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 135.2 | 572.0 | 0.828 | 12.66 | 4.23 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 24.3 | 78.8 | 0.019 | 3.04 | 3.24 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 68.1 | 239.5 | 0.006 | 8.53 | 3.51 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 28.0 | 93.3 | 0.043 | 3.50 | 3.34 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextReader.next_items | 26.0 | 78.0 | 0.033 | 3.26 | 3.00 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 230.5 | 942.3 | 0.432 | 28.86 | 4.09 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 27.9 | 107.6 | 0.038 | 3.50 | 3.85 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 25.4 | 104.8 | 0.022 | 3.18 | 4.12 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 89.1 | 361.0 | 0.028 | 11.16 | 4.05 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 32.3 | 151.6 | 0.032 | 4.05 | 4.69 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 79.3 | 418.3 | 0.008 | 9.93 | 5.27 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim on | 12.9 | 56.5 | 0.049 | 5.94 | 4.37 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, one token a call | 50.4 | 172.6 | 0.140 | 23.13 | 3.43 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, TextWriter's methods or TextReader.next | 16.4 | 73.4 | 0.078 | 7.52 | 4.48 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, TextReader.next_items | 13.8 | 57.7 | 0.049 | 6.35 | 4.17 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim off | 99.8 | 326.3 | 0.267 | 45.81 | 3.27 |
| messages: a tree of 341 objects | 281100 | 612600 | simdjson | 16.2 | 58.4 | 0.024 | 7.43 | 3.60 |
| messages: a tree of 341 objects | 281100 | 612600 | yyjson | 15.8 | 72.2 | 0.047 | 7.27 | 4.56 |
| messages: a tree of 341 objects | 281100 | 612600 | std.json | 58.6 | 220.1 | 0.116 | 26.90 | 3.75 |
| messages: a tree of 341 objects | 281100 | 612600 | serde_json | 13.5 | 59.5 | 0.093 | 6.21 | 4.40 |
| messages: a tree of 341 objects | 281100 | 612600 | Go jsontext | 43.4 | 216.0 | 0.115 | 19.93 | 4.97 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114814.4 | 403852.2 | 514.258 | 0.67 | 3.52 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 591476.1 | 2495394.2 | 1388.392 | 3.43 | 4.22 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 114275.3 | 404249.2 | 481.969 | 0.66 | 3.54 |
| string: silesia/dickens | 1 | 172528 | stdx, TextReader.next_items | 114220.8 | 404282.2 | 478.887 | 0.66 | 3.54 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3574043.2 | 18223882.2 | 2976.443 | 20.72 | 5.10 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311267.8 | 621744.2 | 568.928 | 1.80 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 224454.5 | 826630.2 | 2289.371 | 1.30 | 3.68 |
| string: silesia/dickens | 1 | 172528 | std.json | 1576641.2 | 4578768.2 | 42470.320 | 9.14 | 2.90 |
| string: silesia/dickens | 1 | 172528 | serde_json | 202332.3 | 802909.2 | 994.938 | 1.17 | 3.97 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1067677.0 | 5280705.0 | 4964.495 | 6.19 | 4.95 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1574374.5 | 4799769.6 | 1731.214 | 1.32 | 3.05 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14178819.7 | 56410893.6 | 39321.143 | 11.91 | 3.98 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1572996.4 | 4799955.6 | 1660.643 | 1.32 | 3.05 |
| string: http/json-1m | 1 | 1190272 | stdx, TextReader.next_items | 1572007.4 | 4799988.6 | 1633.286 | 1.32 | 3.05 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 28949962.1 | 132108259.6 | 159667.214 | 24.32 | 4.56 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4586981.6 | 7062781.6 | 540.286 | 3.85 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1781281.2 | 7322029.6 | 14200.214 | 1.50 | 4.11 |
| string: http/json-1m | 1 | 1190272 | std.json | 10316145.6 | 47381157.6 | 32541.500 | 8.67 | 4.59 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3910038.3 | 15226584.6 | 6247.500 | 3.28 | 3.89 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9204305.8 | 48026017.4 | 27710.714 | 7.73 | 5.22 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2067285.5 | 5765419.8 | 4422.750 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6161279.9 | 22538840.8 | 6949.875 | 3.27 | 3.66 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2060033.6 | 5765605.8 | 3923.750 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextReader.next_items | 2057252.6 | 5765638.8 | 3785.625 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47212892.9 | 227842326.8 | 279843.500 | 25.07 | 4.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3760244.1 | 8446023.8 | 1927.375 | 2.00 | 2.25 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7121671.3 | 12276717.8 | 276249.625 | 3.78 | 1.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17438215.6 | 63617055.8 | 267453.875 | 9.26 | 3.65 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9489088.4 | 24440998.8 | 331206.625 | 5.04 | 2.58 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 38915753.5 | 160315684.3 | 835498.750 | 20.67 | 4.12 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12959776.7 | 42561075.3 | 246624.667 | 2.55 | 3.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 173278697.0 | 666700955.3 | 394118.333 | 34.14 | 3.85 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12921156.3 | 42561261.3 | 244902.000 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextReader.next_items | 12929551.7 | 42561294.3 | 244938.333 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 152985456.3 | 639992668.3 | 423981.667 | 30.14 | 4.18 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17552203.0 | 49745820.3 | 252708.667 | 3.46 | 2.83 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14194231.3 | 45615166.3 | 440736.000 | 2.80 | 3.21 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 80221115.7 | 314900845.3 | 453535.333 | 15.81 | 3.93 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36542330.0 | 131556418.3 | 587709.000 | 7.20 | 3.60 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66319166.7 | 273934558.7 | 837663.000 | 13.07 | 4.13 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 94100.3 | 303842.7 | 5.581 | 0.18 | 3.23 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 188146.1 | 623466.7 | 11.968 | 0.36 | 3.31 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 147987.0 | 557622.7 | 5.548 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextReader.next_items | 147957.1 | 557626.7 | 8.871 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10262044.2 | 53478208.7 | 9.129 | 19.57 | 5.21 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 489702.0 | 1376733.7 | 6.742 | 0.93 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 538636.3 | 2195917.7 | 7.677 | 1.03 | 4.08 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3458669.9 | 12808414.7 | 60664.548 | 6.60 | 3.70 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 285311.3 | 1179969.7 | 5.290 | 0.54 | 4.14 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2263792.9 | 12788184.6 | 244.548 | 4.32 | 5.65 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.5 | 81.8 | 0.110 | 2.31 | 4.19 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.4 | 153.5 | 0.131 | 4.18 | 4.34 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 21.4 | 93.4 | 0.090 | 2.53 | 4.37 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 219.2 | 981.0 | 0.929 | 25.89 | 4.48 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 18.8 | 79.5 | 0.109 | 2.22 | 4.23 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.1 | 94.1 | 0.136 | 2.73 | 4.08 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.4 | 105.6 | 0.248 | 3.24 | 3.85 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.6 | 310.8 | 0.373 | 8.22 | 4.47 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 65.5 | 255.3 | 0.509 | 7.73 | 3.90 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.1 | 315.1 | 0.237 | 8.04 | 4.63 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.9 | 82.8 | 0.025 | 2.78 | 4.38 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.2 | 153.9 | 0.025 | 5.33 | 4.25 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 21.6 | 94.2 | 0.024 | 3.17 | 4.37 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 171.7 | 718.3 | 1.283 | 25.27 | 4.18 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.0 | 81.5 | 0.025 | 2.65 | 4.52 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.8 | 96.8 | 0.032 | 3.21 | 4.44 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.9 | 117.9 | 0.033 | 4.26 | 4.07 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 60.1 | 271.2 | 0.271 | 8.85 | 4.51 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 50.6 | 212.7 | 0.039 | 7.45 | 4.20 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 81.0 | 331.7 | 0.081 | 11.92 | 4.10 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 30.8 | 85.9 | 0.382 | 2.88 | 2.79 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 43.8 | 151.2 | 0.428 | 4.10 | 3.46 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 29.9 | 92.6 | 0.396 | 2.80 | 3.09 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 275.9 | 1195.0 | 1.141 | 25.84 | 4.33 |
| messages: 11 string members | 96000 | 1025025 | stdx, J11's loop unchecked | 29.4 | 82.8 | 0.384 | 2.76 | 2.81 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 39.0 | 119.1 | 0.579 | 3.65 | 3.05 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 48.0 | 138.2 | 0.721 | 4.49 | 2.88 |
| messages: 11 string members | 96000 | 1025025 | std.json | 101.0 | 370.8 | 1.070 | 9.46 | 3.67 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 91.1 | 315.4 | 0.749 | 8.53 | 3.46 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 108.2 | 400.7 | 0.864 | 10.14 | 3.70 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 20.5 | 80.2 | 0.007 | 2.56 | 3.92 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 38.2 | 152.5 | 0.006 | 4.78 | 3.99 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 22.0 | 93.2 | 0.007 | 2.76 | 4.23 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 197.4 | 866.7 | 0.764 | 24.72 | 4.39 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, J11's loop unchecked | 19.7 | 79.4 | 0.007 | 2.46 | 4.04 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 24.0 | 96.6 | 0.004 | 3.00 | 4.03 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 25.7 | 101.3 | 0.018 | 3.22 | 3.94 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 59.5 | 279.4 | 0.006 | 7.45 | 4.70 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 53.0 | 230.6 | 0.049 | 6.63 | 4.36 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 68.6 | 310.8 | 0.006 | 8.59 | 4.53 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim on | 15.4 | 62.6 | 0.023 | 7.08 | 4.06 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, one token a call | 31.9 | 135.7 | 0.031 | 14.64 | 4.25 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, TextWriter's methods or TextReader.next | 18.4 | 81.6 | 0.026 | 8.44 | 4.44 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, every claim off | 81.4 | 375.6 | 0.234 | 37.36 | 4.61 |
| messages: a tree of 341 objects | 281100 | 612600 | stdx, J11's loop unchecked | 14.8 | 61.4 | 0.023 | 6.81 | 4.14 |
| messages: a tree of 341 objects | 281100 | 612600 | simdjson | 12.5 | 45.5 | 0.023 | 5.75 | 3.63 |
| messages: a tree of 341 objects | 281100 | 612600 | yyjson | 15.7 | 56.5 | 0.050 | 7.21 | 3.59 |
| messages: a tree of 341 objects | 281100 | 612600 | std.json | 27.9 | 125.4 | 0.045 | 12.82 | 4.49 |
| messages: a tree of 341 objects | 281100 | 612600 | serde_json | 24.0 | 102.3 | 0.044 | 11.00 | 4.27 |
| messages: a tree of 341 objects | 281100 | 612600 | Go jsontext | 42.1 | 181.3 | 0.117 | 19.34 | 4.30 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 85075.2 | 280786.2 | 723.495 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84966.4 | 280732.2 | 722.093 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84813.2 | 280721.2 | 719.948 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3383279.6 | 16047574.2 | 2949.485 | 19.61 | 4.74 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 82894.6 | 274401.2 | 656.546 | 0.48 | 3.31 |
| string: silesia/dickens | 1 | 172528 | simdjson | 209522.8 | 674016.2 | 2107.938 | 1.21 | 3.22 |
| string: silesia/dickens | 1 | 172528 | yyjson | 203477.3 | 825518.2 | 1015.608 | 1.18 | 4.06 |
| string: silesia/dickens | 1 | 172528 | std.json | 1384017.5 | 2890892.2 | 55381.753 | 8.02 | 2.09 |
| string: silesia/dickens | 1 | 172528 | serde_json | 399628.9 | 1586249.2 | 2703.299 | 2.32 | 3.97 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 592125.7 | 2970285.9 | 3336.289 | 3.43 | 5.02 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1321262.0 | 3582350.6 | 13061.429 | 1.11 | 2.71 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1305814.1 | 3582290.6 | 12408.714 | 1.10 | 2.74 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1301375.6 | 3582277.6 | 12293.500 | 1.09 | 2.75 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25602499.8 | 109856348.6 | 142262.429 | 21.51 | 4.29 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1227756.2 | 3370022.6 | 10918.286 | 1.03 | 2.74 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2987290.4 | 10460762.6 | 30307.500 | 2.51 | 3.50 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2587084.3 | 10197931.6 | 9705.286 | 2.17 | 3.94 |
| string: http/json-1m | 1 | 1190272 | std.json | 8994992.4 | 43287986.6 | 16360.571 | 7.56 | 4.81 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4039900.4 | 17941088.6 | 11465.357 | 3.39 | 4.44 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5259816.9 | 26999740.1 | 11801.714 | 4.42 | 5.13 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2068998.0 | 6088099.8 | 4557.000 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2064896.0 | 6088043.8 | 4115.750 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2060730.1 | 6088026.8 | 4083.500 | 1.09 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43797200.4 | 193466553.8 | 265237.125 | 23.26 | 4.42 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2076557.5 | 5875346.8 | 4986.000 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2716683.6 | 7144143.8 | 21235.625 | 1.44 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12075621.5 | 23590602.8 | 445773.500 | 6.41 | 1.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20722534.6 | 56837736.8 | 558399.500 | 11.00 | 2.74 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11542123.6 | 33662338.8 | 332404.500 | 6.13 | 2.92 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18194331.0 | 76319602.5 | 250647.750 | 9.66 | 4.19 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113263.0 | 426376.7 | 3.065 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113114.8 | 426318.7 | 4.613 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113248.6 | 426305.7 | 2.806 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 637644.9 | 3146479.7 | 4.645 | 1.22 | 4.93 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113134.0 | 426343.7 | 1.871 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1203598.1 | 3866916.7 | 3.871 | 2.30 | 3.21 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1628278.8 | 5833341.7 | 5.935 | 3.11 | 3.58 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3570406.7 | 13108830.7 | 74144.613 | 6.81 | 3.67 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1890637.0 | 7405810.7 | 3.710 | 3.61 | 3.92 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2393357.9 | 12748283.9 | 18.355 | 4.56 | 5.33 |
