# bench-profile

| Field | Value |
|---|---|
| Commit | 9e5d87d |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261101.172.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43144950644 |
| Date | 2026-11-12 |

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
| silesia/dickens | 10192446 | zlib | 8.79 | 19.08 | 2.17 | 309.12 |
| silesia/dickens | 10192446 | zlib-ng | 4.86 | 10.50 | 2.16 | 67.62 |
| silesia/dickens | 10192446 | libdeflate | 3.45 | 9.56 | 2.77 | 66.36 |
| silesia/dickens | 10192446 | Wuffs | 5.52 | 13.90 | 2.52 | 97.19 |
| silesia/dickens | 10192446 | stdx | 2.92 | 7.15 | 2.45 | 76.10 |
| silesia/mozilla | 51220480 | zlib | 8.41 | 17.23 | 2.05 | 250.31 |
| silesia/mozilla | 51220480 | zlib-ng | 4.91 | 8.95 | 1.82 | 85.95 |
| silesia/mozilla | 51220480 | libdeflate | 3.43 | 7.63 | 2.23 | 71.04 |
| silesia/mozilla | 51220480 | Wuffs | 6.38 | 13.89 | 2.18 | 132.93 |
| silesia/mozilla | 51220480 | stdx | 3.53 | 6.29 | 1.78 | 89.33 |
| silesia/mr | 9970564 | zlib | 8.34 | 18.46 | 2.21 | 201.19 |
| silesia/mr | 9970564 | zlib-ng | 4.78 | 9.98 | 2.09 | 68.15 |
| silesia/mr | 9970564 | libdeflate | 3.34 | 8.58 | 2.57 | 61.14 |
| silesia/mr | 9970564 | Wuffs | 5.98 | 14.04 | 2.35 | 100.29 |
| silesia/mr | 9970564 | stdx | 3.07 | 6.70 | 2.18 | 69.44 |
| silesia/nci | 33553445 | zlib | 3.52 | 10.18 | 2.89 | 81.26 |
| silesia/nci | 33553445 | zlib-ng | 1.59 | 3.13 | 1.97 | 35.34 |
| silesia/nci | 33553445 | libdeflate | 1.12 | 2.66 | 2.37 | 29.76 |
| silesia/nci | 33553445 | Wuffs | 2.44 | 6.47 | 2.65 | 41.26 |
| silesia/nci | 33553445 | stdx | 1.13 | 2.20 | 1.95 | 37.04 |
| silesia/ooffice | 6152192 | zlib | 11.73 | 21.06 | 1.80 | 413.95 |
| silesia/ooffice | 6152192 | zlib-ng | 6.92 | 12.04 | 1.74 | 141.35 |
| silesia/ooffice | 6152192 | libdeflate | 4.90 | 10.45 | 2.13 | 125.90 |
| silesia/ooffice | 6152192 | Wuffs | 8.81 | 17.54 | 1.99 | 220.02 |
| silesia/ooffice | 6152192 | stdx | 5.06 | 8.55 | 1.69 | 151.03 |
| silesia/osdb | 10085684 | zlib | 7.43 | 16.59 | 2.23 | 180.61 |
| silesia/osdb | 10085684 | zlib-ng | 4.30 | 8.38 | 1.95 | 54.75 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.91 | 2.43 | 29.81 |
| silesia/osdb | 10085684 | Wuffs | 5.80 | 13.61 | 2.35 | 79.80 |
| silesia/osdb | 10085684 | stdx | 2.77 | 5.65 | 2.04 | 40.33 |
| silesia/reymont | 6627202 | zlib | 7.37 | 15.89 | 2.16 | 259.54 |
| silesia/reymont | 6627202 | zlib-ng | 3.71 | 7.72 | 2.08 | 60.42 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.17 |
| silesia/reymont | 6627202 | Wuffs | 4.87 | 11.40 | 2.34 | 112.22 |
| silesia/reymont | 6627202 | stdx | 2.28 | 5.11 | 2.24 | 63.89 |
| silesia/samba | 21606400 | zlib | 6.11 | 14.13 | 2.31 | 175.46 |
| silesia/samba | 21606400 | zlib-ng | 3.37 | 6.47 | 1.92 | 58.06 |
| silesia/samba | 21606400 | libdeflate | 2.30 | 5.58 | 2.42 | 42.91 |
| silesia/samba | 21606400 | Wuffs | 4.31 | 10.39 | 2.41 | 79.59 |
| silesia/samba | 21606400 | stdx | 2.24 | 4.46 | 1.99 | 56.05 |
| silesia/sao | 7251944 | zlib | 10.49 | 23.54 | 2.24 | 205.51 |
| silesia/sao | 7251944 | zlib-ng | 7.83 | 14.83 | 1.89 | 79.11 |
| silesia/sao | 7251944 | libdeflate | 5.72 | 12.73 | 2.22 | 79.09 |
| silesia/sao | 7251944 | Wuffs | 8.89 | 21.26 | 2.39 | 86.20 |
| silesia/sao | 7251944 | stdx | 5.55 | 10.32 | 1.86 | 86.73 |
| silesia/webster | 41458703 | zlib | 7.72 | 16.16 | 2.09 | 280.27 |
| silesia/webster | 41458703 | zlib-ng | 4.18 | 8.04 | 1.92 | 85.23 |
| silesia/webster | 41458703 | libdeflate | 2.84 | 7.17 | 2.52 | 68.49 |
| silesia/webster | 41458703 | Wuffs | 5.12 | 11.67 | 2.28 | 121.89 |
| silesia/webster | 41458703 | stdx | 2.68 | 5.56 | 2.08 | 86.79 |
| silesia/x-ray | 8474240 | zlib | 12.85 | 27.21 | 2.12 | 329.09 |
| silesia/x-ray | 8474240 | zlib-ng | 9.02 | 17.39 | 1.93 | 124.08 |
| silesia/x-ray | 8474240 | libdeflate | 6.52 | 15.26 | 2.34 | 124.82 |
| silesia/x-ray | 8474240 | Wuffs | 10.80 | 23.52 | 2.18 | 191.02 |
| silesia/x-ray | 8474240 | stdx | 6.11 | 11.49 | 1.88 | 138.68 |
| silesia/xml | 5345280 | zlib | 4.22 | 11.16 | 2.64 | 117.77 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.91 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 31.89 |
| silesia/xml | 5345280 | Wuffs | 2.84 | 7.22 | 2.55 | 59.09 |
| silesia/xml | 5345280 | stdx | 1.33 | 2.65 | 2.00 | 41.80 |
| canterbury/alice29.txt | 152089 | zlib | 8.43 | 18.35 | 2.18 | 294.25 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.58 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.20 | 8.96 | 2.80 | 55.60 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.36 | 13.40 | 2.50 | 97.58 |
| canterbury/alice29.txt | 152089 | stdx | 2.71 | 6.99 | 2.58 | 62.25 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.02 | 19.42 | 2.15 | 314.17 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.10 | 10.86 | 2.13 | 74.48 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.62 | 9.82 | 2.71 | 70.04 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.75 | 14.40 | 2.50 | 99.19 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.05 | 7.52 | 2.47 | 75.73 |
| canterbury/cp.html | 24603 | zlib | 7.10 | 17.33 | 2.44 | 173.02 |
| canterbury/cp.html | 24603 | zlib-ng | 4.29 | 9.50 | 2.21 | 45.52 |
| canterbury/cp.html | 24603 | libdeflate | 2.96 | 7.95 | 2.69 | 24.87 |
| canterbury/cp.html | 24603 | Wuffs | 5.20 | 13.91 | 2.68 | 59.33 |
| canterbury/cp.html | 24603 | stdx | 2.71 | 7.19 | 2.65 | 18.36 |
| canterbury/fields.c | 11150 | zlib | 5.31 | 17.73 | 3.34 | 40.46 |
| canterbury/fields.c | 11150 | zlib-ng | 4.02 | 10.20 | 2.54 | 24.94 |
| canterbury/fields.c | 11150 | libdeflate | 2.83 | 8.32 | 2.94 | 2.22 |
| canterbury/fields.c | 11150 | Wuffs | 4.57 | 14.54 | 3.18 | 13.44 |
| canterbury/fields.c | 11150 | stdx | 2.52 | 7.64 | 3.04 | 4.97 |
| canterbury/grammar.lsp | 3721 | zlib | 6.94 | 24.26 | 3.50 | 8.78 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.87 | 17.48 | 2.98 | 10.42 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.49 | 12.05 | 2.69 | 0.77 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.68 | 21.86 | 3.27 | 5.06 |
| canterbury/grammar.lsp | 3721 | stdx | 3.84 | 12.18 | 3.17 | 1.01 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.59 | 15.27 | 3.33 | 48.20 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.59 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.06 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.86 | 11.59 | 3.00 | 14.80 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.73 | 4.66 | 2.69 | 16.33 |
| canterbury/lcet10.txt | 426754 | zlib | 8.21 | 17.78 | 2.17 | 290.37 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.17 | 60.15 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.40 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.22 | 12.88 | 2.47 | 101.16 |
| canterbury/lcet10.txt | 426754 | stdx | 2.60 | 6.42 | 2.47 | 66.01 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.19 | 19.86 | 2.16 | 320.93 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.30 | 11.19 | 2.11 | 79.56 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.71 | 77.09 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.80 | 14.61 | 2.52 | 98.78 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.15 | 7.63 | 2.43 | 85.02 |
| canterbury/ptt5 | 513216 | zlib | 5.07 | 10.71 | 2.11 | 103.85 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.00 | 3.74 | 1.87 | 47.02 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.08 | 38.76 |
| canterbury/ptt5 | 513216 | Wuffs | 3.01 | 7.13 | 2.36 | 57.68 |
| canterbury/ptt5 | 513216 | stdx | 1.44 | 2.55 | 1.76 | 48.57 |
| canterbury/sum | 38240 | zlib | 7.99 | 18.12 | 2.27 | 223.71 |
| canterbury/sum | 38240 | zlib-ng | 4.70 | 10.02 | 2.13 | 60.47 |
| canterbury/sum | 38240 | libdeflate | 3.40 | 8.34 | 2.45 | 42.72 |
| canterbury/sum | 38240 | Wuffs | 5.86 | 14.47 | 2.47 | 84.48 |
| canterbury/sum | 38240 | stdx | 3.15 | 7.73 | 2.45 | 39.20 |
| canterbury/xargs.1 | 4227 | zlib | 7.50 | 25.22 | 3.36 | 18.99 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.46 | 17.97 | 2.78 | 15.99 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.83 | 13.27 | 2.75 | 0.62 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.18 | 22.63 | 3.15 | 9.33 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 12.86 | 3.04 | 1.69 |
| canterbury-large/E.coli | 4638690 | zlib | 6.78 | 17.84 | 2.63 | 178.58 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.23 | 9.68 | 2.29 | 48.02 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.63 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.66 | 12.73 | 2.74 | 61.54 |
| canterbury-large/E.coli | 4638690 | stdx | 2.47 | 6.72 | 2.72 | 53.50 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.54 | 16.46 | 2.18 | 269.27 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.77 | 8.26 | 2.19 | 53.33 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.41 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.79 | 11.73 | 2.45 | 100.19 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.23 | 5.57 | 2.49 | 55.90 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.71 | 15.84 | 2.06 | 280.34 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.19 | 7.78 | 1.85 | 91.95 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 74.79 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.17 | 11.48 | 2.22 | 127.77 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 5.40 | 1.98 | 90.44 |
| http/html-1kx1024 | 1048576 | zlib | 16.70 | 35.58 | 2.13 | 353.25 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.68 | 28.43 | 2.24 | 217.48 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.84 | 20.05 | 1.85 | 155.47 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.34 | 38.07 | 2.48 | 266.00 |
| http/html-1kx1024 | 1048576 | stdx | 8.38 | 20.88 | 2.49 | 137.41 |
| http/html-16kx64 | 1048576 | zlib | 6.72 | 14.77 | 2.20 | 220.86 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.46 |
| http/html-16kx64 | 1048576 | libdeflate | 2.65 | 6.04 | 2.28 | 60.66 |
| http/html-16kx64 | 1048576 | Wuffs | 4.92 | 11.57 | 2.35 | 114.79 |
| http/html-16kx64 | 1048576 | stdx | 2.51 | 5.56 | 2.21 | 59.24 |
| http/html-1m | 1048576 | zlib | 5.31 | 12.53 | 2.36 | 175.67 |
| http/html-1m | 1048576 | zlib-ng | 2.63 | 5.03 | 1.92 | 60.44 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.41 |
| http/html-1m | 1048576 | Wuffs | 3.60 | 8.48 | 2.35 | 87.83 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.11 | 52.33 |
| http/json-1kx1024 | 1048576 | zlib | 10.61 | 23.92 | 2.26 | 192.88 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.42 | 16.69 | 2.25 | 131.71 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.12 | 16.72 | 1.83 | 92.51 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.12 | 34.78 | 2.87 | 146.31 |
| http/json-1kx1024 | 1048576 | stdx | 5.02 | 13.12 | 2.61 | 80.56 |
| http/json-16kx64 | 1048576 | zlib | 4.56 | 12.51 | 2.74 | 102.89 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.64 | 5.50 | 2.08 | 53.21 |
| http/json-16kx64 | 1048576 | libdeflate | 1.93 | 4.24 | 2.19 | 40.62 |
| http/json-16kx64 | 1048576 | Wuffs | 3.49 | 9.43 | 2.70 | 57.57 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.26 | 39.42 |
| http/json-1m | 1048576 | zlib | 3.84 | 11.20 | 2.92 | 83.09 |
| http/json-1m | 1048576 | zlib-ng | 1.97 | 3.91 | 1.99 | 39.98 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.40 | 32.79 |
| http/json-1m | 1048576 | Wuffs | 2.72 | 7.37 | 2.71 | 43.13 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.01 | 39.97 |
| http/js-1kx1024 | 1048576 | zlib | 18.24 | 38.46 | 2.11 | 410.83 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.78 | 31.25 | 2.27 | 238.69 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.53 | 21.58 | 1.87 | 179.02 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.51 | 40.70 | 2.46 | 300.19 |
| http/js-1kx1024 | 1048576 | stdx | 9.27 | 22.85 | 2.46 | 159.56 |
| http/js-16kx64 | 1048576 | zlib | 7.67 | 16.08 | 2.10 | 263.86 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.98 | 91.74 |
| http/js-16kx64 | 1048576 | libdeflate | 3.07 | 7.01 | 2.28 | 71.97 |
| http/js-16kx64 | 1048576 | Wuffs | 5.50 | 12.75 | 2.32 | 128.80 |
| http/js-16kx64 | 1048576 | stdx | 3.01 | 6.54 | 2.17 | 72.48 |
| http/js-1m | 1048576 | zlib | 5.85 | 13.31 | 2.28 | 199.47 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 59.89 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 42.00 |
| http/js-1m | 1048576 | Wuffs | 3.91 | 9.14 | 2.34 | 94.04 |
| http/js-1m | 1048576 | stdx | 1.81 | 3.89 | 2.16 | 55.32 |
| http/css-1kx1024 | 1048576 | zlib | 14.04 | 30.36 | 2.16 | 281.53 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.27 | 23.04 | 2.24 | 171.82 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.43 | 17.37 | 1.84 | 121.64 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.75 | 32.50 | 2.55 | 210.45 |
| http/css-1kx1024 | 1048576 | stdx | 6.67 | 17.64 | 2.64 | 100.84 |
| http/css-16kx64 | 1048576 | zlib | 5.32 | 13.04 | 2.45 | 154.08 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.81 | 6.07 | 2.16 | 52.38 |
| http/css-16kx64 | 1048576 | libdeflate | 1.91 | 4.69 | 2.46 | 30.11 |
| http/css-16kx64 | 1048576 | Wuffs | 3.78 | 10.01 | 2.65 | 69.28 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.53 | 28.46 |
| http/css-1m | 1048576 | zlib | 3.97 | 10.97 | 2.76 | 107.26 |
| http/css-1m | 1048576 | zlib-ng | 1.72 | 3.75 | 2.18 | 30.85 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.96 | 13.07 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.78 | 43.42 |
| http/css-1m | 1048576 | stdx | 1.02 | 2.56 | 2.52 | 21.25 |
| shuffled/dickens-1m | 1048576 | zlib | 13.30 | 25.88 | 1.95 | 372.62 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.72 | 16.72 | 1.72 | 197.86 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.03 | 14.95 | 2.12 | 195.14 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.38 | 22.08 | 2.13 | 204.66 |
| shuffled/dickens-1m | 1048576 | stdx | 7.06 | 11.89 | 1.68 | 206.93 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.55 | 14.05 | 3.96 | 3.43 |
| silesia/dickens | 10192446 | stdx | 3.70 | 12.47 | 3.37 | 3.51 |
| silesia/mozilla | 51220480 | libzstd | 2.78 | 9.68 | 3.48 | 30.17 |
| silesia/mozilla | 51220480 | stdx | 2.72 | 9.68 | 3.56 | 15.82 |
| silesia/mr | 9970564 | libzstd | 3.00 | 11.99 | 3.99 | 6.07 |
| silesia/mr | 9970564 | stdx | 3.09 | 10.83 | 3.51 | 5.56 |
| silesia/nci | 33553445 | libzstd | 1.61 | 4.88 | 3.03 | 24.75 |
| silesia/nci | 33553445 | stdx | 1.59 | 4.63 | 2.90 | 13.64 |
| silesia/ooffice | 6152192 | libzstd | 3.35 | 12.19 | 3.64 | 31.00 |
| silesia/ooffice | 6152192 | stdx | 3.33 | 12.40 | 3.72 | 12.32 |
| silesia/osdb | 10085684 | libzstd | 2.36 | 8.45 | 3.58 | 15.01 |
| silesia/osdb | 10085684 | stdx | 2.44 | 8.11 | 3.33 | 15.23 |
| silesia/reymont | 6627202 | libzstd | 3.23 | 11.62 | 3.60 | 11.62 |
| silesia/reymont | 6627202 | stdx | 3.35 | 10.36 | 3.09 | 12.67 |
| silesia/samba | 21606400 | libzstd | 2.04 | 7.41 | 3.63 | 18.65 |
| silesia/samba | 21606400 | stdx | 2.11 | 6.83 | 3.23 | 17.82 |
| silesia/sao | 7251944 | libzstd | 3.73 | 12.72 | 3.41 | 26.65 |
| silesia/sao | 7251944 | stdx | 3.46 | 12.58 | 3.63 | 6.19 |
| silesia/webster | 41458703 | libzstd | 3.17 | 11.24 | 3.54 | 16.25 |
| silesia/webster | 41458703 | stdx | 3.31 | 10.05 | 3.03 | 17.99 |
| silesia/x-ray | 8474240 | libzstd | 3.84 | 14.94 | 3.89 | 18.88 |
| silesia/x-ray | 8474240 | stdx | 3.52 | 13.23 | 3.76 | 8.37 |
| silesia/xml | 5345280 | libzstd | 1.55 | 5.57 | 3.60 | 23.32 |
| silesia/xml | 5345280 | stdx | 1.51 | 5.16 | 3.42 | 17.17 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.89 | 4.07 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.43 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.95 | 14.26 | 4.83 | 3.23 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.30 | 0.31 |
| canterbury/cp.html | 24603 | libzstd | 2.63 | 10.74 | 4.08 | 7.07 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.12 | 0.22 |
| canterbury/fields.c | 11150 | libzstd | 3.12 | 13.62 | 4.37 | 8.97 |
| canterbury/fields.c | 11150 | stdx | 3.00 | 12.72 | 4.24 | 0.29 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.19 | 16.94 | 4.05 | 4.56 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.54 | 4.02 | 0.23 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.54 | 11.40 | 4.49 | 7.79 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.23 | 0.91 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.70 | 12.89 | 4.78 | 5.14 |
| canterbury/lcet10.txt | 426754 | stdx | 2.70 | 11.52 | 4.26 | 2.23 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.10 | 15.16 | 4.89 | 1.50 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.27 | 0.83 |
| canterbury/ptt5 | 513216 | libzstd | 1.46 | 4.52 | 3.09 | 26.01 |
| canterbury/ptt5 | 513216 | stdx | 1.34 | 4.46 | 3.33 | 13.28 |
| canterbury/sum | 38240 | libzstd | 2.61 | 10.58 | 4.06 | 9.46 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.38 |
| canterbury/xargs.1 | 4227 | libzstd | 4.24 | 17.41 | 4.10 | 9.03 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.17 | 4.05 | 0.40 |
| canterbury-large/E.coli | 4638690 | libzstd | 2.97 | 13.64 | 4.59 | 2.11 |
| canterbury-large/E.coli | 4638690 | stdx | 3.11 | 12.04 | 3.87 | 2.85 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.97 | 12.00 | 4.04 | 8.49 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.08 | 10.64 | 3.45 | 9.31 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.55 | 9.60 | 3.77 | 19.88 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.64 | 8.64 | 3.27 | 20.98 |
| http/html-1kx1024 | 1048576 | libzstd | 7.25 | 21.63 | 2.98 | 63.34 |
| http/html-1kx1024 | 1048576 | stdx | 7.49 | 22.46 | 3.00 | 76.95 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.58 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.60 | 30.52 |
| http/html-1m | 1048576 | libzstd | 2.01 | 7.88 | 3.92 | 24.22 |
| http/html-1m | 1048576 | stdx | 2.01 | 7.12 | 3.54 | 24.97 |
| http/json-1kx1024 | 1048576 | libzstd | 6.27 | 17.39 | 2.77 | 49.90 |
| http/json-1kx1024 | 1048576 | stdx | 6.22 | 17.86 | 2.87 | 53.48 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.26 | 3.54 | 28.19 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.58 | 19.79 |
| http/json-1m | 1048576 | libzstd | 1.72 | 6.08 | 3.53 | 27.77 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.61 | 14.49 |
| http/js-1kx1024 | 1048576 | libzstd | 8.33 | 26.35 | 3.16 | 73.32 |
| http/js-1kx1024 | 1048576 | stdx | 9.06 | 27.60 | 3.05 | 113.77 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.72 | 4.00 | 24.40 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.74 | 26.37 |
| http/js-1m | 1048576 | libzstd | 2.03 | 8.19 | 4.04 | 20.42 |
| http/js-1m | 1048576 | stdx | 2.07 | 7.48 | 3.61 | 21.57 |
| http/css-1kx1024 | 1048576 | libzstd | 6.88 | 19.69 | 2.86 | 53.35 |
| http/css-1kx1024 | 1048576 | stdx | 6.86 | 19.96 | 2.91 | 64.14 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.70 | 3.89 | 22.44 |
| http/css-16kx64 | 1048576 | stdx | 2.28 | 8.43 | 3.70 | 22.28 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.58 | 3.86 | 5.40 |
| http/css-1m | 1048576 | stdx | 0.70 | 2.49 | 3.54 | 3.42 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.77 | 9.40 | 3.39 | 28.44 |
| shuffled/dickens-1m | 1048576 | stdx | 2.75 | 9.19 | 3.34 | 13.03 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.48 | 16.93 | 2.26 | 99.98 |
| silesia/dickens | 1048576 | stdx | 5.11 | 12.38 | 2.42 | 54.65 |
| silesia/mozilla | 1048576 | Google | 13.45 | 28.31 | 2.10 | 46.63 |
| silesia/mozilla | 1048576 | stdx | 8.32 | 15.02 | 1.81 | 47.17 |
| silesia/mr | 1048576 | Google | 8.89 | 20.21 | 2.27 | 102.72 |
| silesia/mr | 1048576 | stdx | 5.79 | 13.25 | 2.29 | 88.78 |
| silesia/nci | 1048576 | Google | 2.55 | 5.70 | 2.23 | 51.76 |
| silesia/nci | 1048576 | stdx | 1.95 | 3.95 | 2.02 | 55.63 |
| silesia/ooffice | 1048576 | Google | 14.15 | 29.27 | 2.07 | 288.06 |
| silesia/ooffice | 1048576 | stdx | 10.89 | 20.33 | 1.87 | 323.11 |
| silesia/osdb | 1048576 | Google | 8.21 | 17.48 | 2.13 | 96.26 |
| silesia/osdb | 1048576 | stdx | 5.16 | 10.57 | 2.05 | 91.30 |
| silesia/reymont | 1048576 | Google | 5.40 | 12.62 | 2.33 | 82.21 |
| silesia/reymont | 1048576 | stdx | 3.73 | 9.25 | 2.48 | 47.31 |
| silesia/samba | 1048576 | Google | 7.57 | 16.30 | 2.15 | 94.87 |
| silesia/samba | 1048576 | stdx | 5.07 | 10.71 | 2.11 | 67.06 |
| silesia/sao | 1048576 | Google | 16.79 | 37.18 | 2.21 | 162.87 |
| silesia/sao | 1048576 | stdx | 10.42 | 22.65 | 2.17 | 142.85 |
| silesia/webster | 1048576 | Google | 6.53 | 14.00 | 2.14 | 113.86 |
| silesia/webster | 1048576 | stdx | 4.44 | 9.98 | 2.25 | 69.59 |
| silesia/x-ray | 1048576 | Google | 19.31 | 38.56 | 2.00 | 234.90 |
| silesia/x-ray | 1048576 | stdx | 14.59 | 30.18 | 2.07 | 235.96 |
| silesia/xml | 1048576 | Google | 3.44 | 7.61 | 2.21 | 65.32 |
| silesia/xml | 1048576 | stdx | 2.41 | 5.40 | 2.25 | 47.20 |
| canterbury/alice29.txt | 152089 | Google | 8.85 | 20.55 | 2.32 | 133.72 |
| canterbury/alice29.txt | 152089 | stdx | 6.07 | 15.33 | 2.53 | 80.75 |
| canterbury/asyoulik.txt | 125179 | Google | 10.34 | 23.71 | 2.29 | 167.51 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.09 | 17.43 | 2.46 | 105.41 |
| canterbury/cp.html | 24603 | Google | 9.02 | 22.20 | 2.46 | 108.81 |
| canterbury/cp.html | 24603 | stdx | 5.83 | 17.15 | 2.94 | 37.28 |
| canterbury/fields.c | 11150 | Google | 7.07 | 21.16 | 2.99 | 26.15 |
| canterbury/fields.c | 11150 | stdx | 4.89 | 17.08 | 3.49 | 2.43 |
| canterbury/grammar.lsp | 3721 | Google | 9.82 | 30.16 | 3.07 | 7.39 |
| canterbury/grammar.lsp | 3721 | stdx | 7.14 | 25.04 | 3.50 | 0.39 |
| canterbury/kennedy.xls | 1029744 | Google | 5.49 | 17.05 | 3.11 | 37.37 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.81 | 12.94 | 3.40 | 33.92 |
| canterbury/lcet10.txt | 426754 | Google | 7.74 | 17.36 | 2.24 | 126.08 |
| canterbury/lcet10.txt | 426754 | stdx | 5.19 | 12.96 | 2.50 | 66.12 |
| canterbury/plrabn12.txt | 481861 | Google | 9.07 | 20.82 | 2.30 | 132.62 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.16 | 15.04 | 2.44 | 87.22 |
| canterbury/ptt5 | 513216 | Google | 4.27 | 10.41 | 2.44 | 61.93 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.06 | 66.07 |
| canterbury/sum | 38240 | Google | 10.84 | 26.44 | 2.44 | 157.82 |
| canterbury/sum | 38240 | stdx | 8.36 | 21.11 | 2.53 | 158.46 |
| canterbury/xargs.1 | 4227 | Google | 10.98 | 34.81 | 3.17 | 9.73 |
| canterbury/xargs.1 | 4227 | stdx | 8.49 | 30.44 | 3.58 | 6.17 |
| canterbury-large/E.coli | 1048576 | Google | 8.12 | 19.55 | 2.41 | 1.33 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.18 |
| canterbury-large/bible.txt | 1048576 | Google | 5.32 | 12.28 | 2.31 | 80.61 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.55 | 8.93 | 2.51 | 39.75 |
| canterbury-large/world192.txt | 1048576 | Google | 6.19 | 12.84 | 2.07 | 114.88 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.44 | 9.38 | 2.11 | 77.20 |
| http/html-1kx1024 | 1048576 | Google | 18.05 | 41.93 | 2.32 | 386.57 |
| http/html-1kx1024 | 1048576 | stdx | 15.29 | 37.56 | 2.46 | 360.78 |
| http/html-16kx64 | 1048576 | Google | 6.72 | 14.85 | 2.21 | 149.16 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.77 |
| http/html-1m | 1048576 | Google | 4.04 | 8.94 | 2.21 | 83.12 |
| http/html-1m | 1048576 | stdx | 2.87 | 6.52 | 2.27 | 54.73 |
| http/json-1kx1024 | 1048576 | Google | 14.51 | 36.64 | 2.52 | 241.57 |
| http/json-1kx1024 | 1048576 | stdx | 12.95 | 33.63 | 2.60 | 276.55 |
| http/json-16kx64 | 1048576 | Google | 4.41 | 11.43 | 2.59 | 81.54 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.42 |
| http/json-1m | 1048576 | Google | 3.39 | 8.65 | 2.55 | 58.76 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.44 | 57.75 |
| http/js-1kx1024 | 1048576 | Google | 19.97 | 46.20 | 2.31 | 429.73 |
| http/js-1kx1024 | 1048576 | stdx | 16.40 | 39.90 | 2.43 | 382.21 |
| http/js-16kx64 | 1048576 | Google | 8.03 | 17.73 | 2.21 | 167.89 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.39 |
| http/js-1m | 1048576 | Google | 4.35 | 9.54 | 2.19 | 82.88 |
| http/js-1m | 1048576 | stdx | 3.17 | 7.25 | 2.29 | 55.58 |
| http/css-1kx1024 | 1048576 | Google | 15.50 | 37.36 | 2.41 | 292.74 |
| http/css-1kx1024 | 1048576 | stdx | 13.79 | 34.70 | 2.52 | 302.91 |
| http/css-16kx64 | 1048576 | Google | 4.94 | 11.76 | 2.38 | 101.82 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.66 |
| http/css-1m | 1048576 | Google | 2.43 | 9.42 | 3.87 | 16.97 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.47 | 12.09 |
| shuffled/dickens-1m | 1048576 | Google | 10.19 | 20.65 | 2.03 | 109.35 |
| shuffled/dickens-1m | 1048576 | stdx | 8.77 | 14.53 | 1.66 | 117.95 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.16 | 36.91 | 2.44 | 411.58 |
| silesia/dickens | 10192446 | 1 | stdx | 16.10 | 38.17 | 2.37 | 360.18 |
| silesia/dickens | 10192446 | 6 | libdeflate | 51.97 | 87.63 | 1.69 | 694.98 |
| silesia/dickens | 10192446 | 6 | stdx | 49.14 | 84.26 | 1.71 | 1425.61 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.73 | 160.47 | 1.44 | 931.08 |
| silesia/dickens | 10192446 | 9 | stdx | 84.77 | 191.80 | 2.26 | 1723.42 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.10 | 32.62 | 2.31 | 440.07 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.28 | 30.24 | 2.28 | 295.26 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.79 | 70.83 | 2.16 | 579.10 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.49 | 69.96 | 2.22 | 735.03 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.48 | 221.49 | 1.74 | 767.95 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.96 | 126.12 | 2.58 | 788.95 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.90 | 35.02 | 2.94 | 230.32 |
| silesia/mr | 9970564 | 1 | stdx | 12.33 | 34.08 | 2.76 | 187.78 |
| silesia/mr | 9970564 | 6 | libdeflate | 37.96 | 80.54 | 2.12 | 435.13 |
| silesia/mr | 9970564 | 6 | stdx | 39.21 | 83.18 | 2.12 | 958.84 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.55 | 165.48 | 1.70 | 754.92 |
| silesia/mr | 9970564 | 9 | stdx | 86.86 | 206.31 | 2.38 | 1330.16 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.18 | 18.42 | 2.98 | 117.22 |
| silesia/nci | 33553445 | 1 | stdx | 4.81 | 10.88 | 2.26 | 97.62 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.83 | 34.84 | 2.07 | 226.04 |
| silesia/nci | 33553445 | 6 | stdx | 14.20 | 29.54 | 2.08 | 390.61 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.28 | 105.28 | 1.69 | 498.33 |
| silesia/nci | 33553445 | 9 | stdx | 32.98 | 80.63 | 2.45 | 648.93 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.85 | 39.15 | 1.97 | 753.68 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.49 | 39.08 | 2.23 | 431.11 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 40.82 | 79.10 | 1.94 | 952.81 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.30 | 87.83 | 2.13 | 1013.21 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.43 | 127.63 | 1.71 | 1134.50 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.19 | 129.17 | 2.47 | 932.83 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.86 | 30.15 | 2.34 | 356.36 |
| silesia/osdb | 10085684 | 1 | stdx | 12.64 | 27.86 | 2.20 | 293.67 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.13 | 55.67 | 1.98 | 490.79 |
| silesia/osdb | 10085684 | 6 | stdx | 26.77 | 57.40 | 2.14 | 572.71 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.83 | 64.15 | 1.90 | 553.73 |
| silesia/osdb | 10085684 | 9 | stdx | 35.17 | 87.23 | 2.48 | 690.77 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.56 | 32.88 | 2.62 | 311.36 |
| silesia/reymont | 6627202 | 1 | stdx | 13.20 | 33.24 | 2.52 | 271.33 |
| silesia/reymont | 6627202 | 6 | libdeflate | 47.90 | 86.58 | 1.81 | 519.72 |
| silesia/reymont | 6627202 | 6 | stdx | 44.63 | 76.82 | 1.72 | 1405.66 |
| silesia/reymont | 6627202 | 9 | libdeflate | 197.98 | 276.14 | 1.39 | 829.83 |
| silesia/reymont | 6627202 | 9 | stdx | 86.94 | 189.97 | 2.19 | 1611.09 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.39 | 26.53 | 2.55 | 273.82 |
| silesia/samba | 21606400 | 1 | stdx | 9.62 | 22.23 | 2.31 | 221.14 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.70 | 58.79 | 2.05 | 386.24 |
| silesia/samba | 21606400 | 6 | stdx | 23.83 | 49.84 | 2.09 | 623.54 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.02 | 141.44 | 1.68 | 503.79 |
| silesia/samba | 21606400 | 9 | stdx | 41.34 | 102.63 | 2.48 | 730.78 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.64 | 47.87 | 2.21 | 685.37 |
| silesia/sao | 7251944 | 1 | stdx | 18.87 | 49.92 | 2.65 | 346.88 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.05 | 96.89 | 1.90 | 962.84 |
| silesia/sao | 7251944 | 6 | stdx | 46.72 | 105.65 | 2.26 | 848.80 |
| silesia/sao | 7251944 | 9 | libdeflate | 70.87 | 120.26 | 1.70 | 1112.72 |
| silesia/sao | 7251944 | 9 | stdx | 55.21 | 138.16 | 2.50 | 844.70 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.06 | 30.45 | 2.33 | 387.49 |
| silesia/webster | 41458703 | 1 | stdx | 13.71 | 29.08 | 2.12 | 340.34 |
| silesia/webster | 41458703 | 6 | libdeflate | 36.94 | 66.02 | 1.79 | 570.74 |
| silesia/webster | 41458703 | 6 | stdx | 35.02 | 60.88 | 1.74 | 1103.49 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.51 | 138.85 | 1.47 | 754.25 |
| silesia/webster | 41458703 | 9 | stdx | 60.57 | 135.96 | 2.24 | 1290.12 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.60 | 49.67 | 2.10 | 785.81 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.31 | 50.81 | 2.94 | 261.88 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.72 | 82.77 | 2.53 | 851.17 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.47 | 98.11 | 2.93 | 540.16 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.39 | 91.03 | 2.43 | 1033.60 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.55 | 122.05 | 3.01 | 466.56 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.78 | 21.59 | 2.78 | 177.31 |
| silesia/xml | 5345280 | 1 | stdx | 6.81 | 15.66 | 2.30 | 155.11 |
| silesia/xml | 5345280 | 6 | libdeflate | 20.97 | 40.51 | 1.93 | 264.89 |
| silesia/xml | 5345280 | 6 | stdx | 17.38 | 34.32 | 1.98 | 494.60 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.31 | 89.17 | 1.53 | 371.11 |
| silesia/xml | 5345280 | 9 | stdx | 30.85 | 72.83 | 2.36 | 599.97 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.25 | 35.61 | 2.50 | 379.16 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.03 | 36.12 | 2.40 | 337.32 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.70 | 82.29 | 1.76 | 644.18 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.65 | 77.43 | 1.77 | 1304.05 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.62 | 159.21 | 1.48 | 850.51 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 72.64 | 167.73 | 2.31 | 1508.30 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.17 | 37.20 | 2.45 | 417.07 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.75 | 37.43 | 2.38 | 357.82 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.33 | 85.43 | 1.77 | 718.00 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.25 | 81.93 | 1.77 | 1394.31 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.88 | 136.15 | 1.53 | 941.76 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 75.66 | 175.97 | 2.33 | 1608.72 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.71 | 32.02 | 2.73 | 285.29 |
| canterbury/cp.html | 24603 | 1 | stdx | 10.92 | 27.13 | 2.48 | 242.08 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 26.98 | 62.33 | 2.31 | 487.54 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.75 | 57.06 | 2.40 | 622.93 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.99 | 91.97 | 1.96 | 602.95 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.16 | 88.89 | 2.85 | 644.51 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.40 | 35.92 | 3.82 | 57.57 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.05 | 30.05 | 3.73 | 22.79 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.55 | 69.37 | 2.83 | 246.76 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.98 | 57.62 | 2.75 | 437.93 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.39 | 100.81 | 2.27 | 413.84 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.50 | 92.66 | 3.25 | 456.72 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.00 | 51.51 | 3.96 | 12.98 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.90 | 39.01 | 3.94 | 1.90 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.75 | 87.06 | 3.67 | 27.16 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.13 | 70.81 | 4.13 | 15.38 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.71 | 102.89 | 3.35 | 40.54 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.59 | 99.31 | 4.21 | 63.82 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.37 | 27.18 | 3.68 | 65.42 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.05 | 22.58 | 3.20 | 63.51 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.88 | 73.85 | 2.65 | 96.39 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.31 | 61.99 | 3.21 | 138.43 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.20 | 664.23 | 1.83 | 166.65 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.47 | 130.89 | 3.49 | 220.22 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.80 | 33.99 | 2.46 | 371.78 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.47 | 33.92 | 2.34 | 330.09 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.03 | 78.22 | 1.74 | 609.88 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.62 | 73.43 | 1.76 | 1218.10 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.69 | 136.94 | 1.49 | 806.04 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 70.55 | 162.24 | 2.30 | 1449.20 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.81 | 38.62 | 2.44 | 426.87 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.68 | 40.24 | 2.41 | 366.65 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.15 | 91.90 | 1.70 | 754.55 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.46 | 88.90 | 1.73 | 1486.36 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.96 | 166.26 | 1.42 | 1006.35 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 88.44 | 201.33 | 2.28 | 1800.63 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.44 | 18.61 | 2.89 | 142.68 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.97 | 11.03 | 2.22 | 123.12 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.29 | 36.17 | 2.53 | 220.66 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.31 | 29.58 | 2.40 | 306.43 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.45 | 120.86 | 2.00 | 375.20 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.09 | 130.09 | 3.02 | 639.36 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.86 | 33.49 | 2.60 | 341.66 |
| canterbury/sum | 38240 | 1 | stdx | 12.55 | 29.36 | 2.34 | 298.94 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.62 | 69.87 | 2.44 | 501.12 |
| canterbury/sum | 38240 | 6 | stdx | 26.66 | 65.74 | 2.47 | 657.30 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.05 | 181.91 | 1.93 | 600.54 |
| canterbury/sum | 38240 | 9 | stdx | 39.26 | 112.33 | 2.86 | 659.84 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.20 | 53.06 | 4.02 | 18.16 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.66 | 43.10 | 4.04 | 3.53 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.95 | 87.70 | 3.82 | 69.52 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 17.92 | 74.35 | 4.15 | 40.29 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 25.12 | 94.34 | 3.76 | 103.03 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.13 | 106.96 | 4.09 | 120.14 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.01 | 40.47 | 3.37 | 163.68 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.48 | 42.29 | 3.39 | 102.22 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.19 | 395.99 | 2.16 | 262.86 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.31 | 374.12 | 3.06 | 1901.42 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.56 | 1063.49 | 1.30 | 1310.44 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 229.60 | 755.68 | 3.29 | 2421.24 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.50 | 32.38 | 2.59 | 312.47 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.19 | 32.23 | 2.44 | 282.50 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 45.95 | 80.12 | 1.74 | 523.24 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 41.82 | 72.39 | 1.73 | 1254.57 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.55 | 200.28 | 1.41 | 742.44 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 75.79 | 170.21 | 2.25 | 1442.09 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.31 | 29.72 | 2.23 | 415.21 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.08 | 28.55 | 2.03 | 378.98 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.00 | 60.25 | 1.83 | 562.46 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 31.82 | 56.80 | 1.79 | 984.12 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.40 | 119.11 | 1.48 | 685.22 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 51.55 | 117.95 | 2.29 | 1145.51 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.40 | 103.92 | 2.94 | 455.99 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.28 | 58.63 | 2.76 | 365.57 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.15 | 138.33 | 3.00 | 564.37 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 31.89 | 94.31 | 2.96 | 528.19 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.77 | 142.44 | 2.98 | 589.11 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 35.97 | 112.13 | 3.12 | 538.87 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.47 | 27.96 | 2.67 | 268.48 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.01 | 20.25 | 2.25 | 234.52 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.35 | 52.09 | 2.33 | 394.67 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.87 | 42.86 | 2.27 | 542.62 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 34.97 | 72.54 | 2.07 | 464.30 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.72 | 69.05 | 2.79 | 552.09 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.79 | 23.03 | 2.62 | 225.37 |
| http/html-1m | 1048576 | 1 | stdx | 8.16 | 17.79 | 2.18 | 205.95 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.29 | 49.53 | 1.96 | 329.32 |
| http/html-1m | 1048576 | 6 | stdx | 21.17 | 40.71 | 1.92 | 617.30 |
| http/html-1m | 1048576 | 9 | libdeflate | 70.94 | 109.24 | 1.54 | 430.14 |
| http/html-1m | 1048576 | 9 | stdx | 35.68 | 85.76 | 2.40 | 708.40 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.74 | 94.80 | 2.99 | 302.71 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.46 | 45.16 | 2.74 | 242.73 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.04 | 126.60 | 2.94 | 373.12 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.10 | 78.37 | 2.89 | 380.30 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.20 | 142.45 | 2.73 | 431.82 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.60 | 95.56 | 3.12 | 386.22 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.86 | 23.85 | 3.03 | 135.40 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.46 | 13.94 | 2.55 | 110.68 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.21 | 46.61 | 2.56 | 206.84 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.44 | 35.01 | 2.60 | 279.84 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.17 | 151.99 | 1.90 | 296.75 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.15 | 58.45 | 3.05 | 303.50 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.75 | 19.85 | 2.94 | 125.58 |
| http/json-1m | 1048576 | 1 | stdx | 5.07 | 12.51 | 2.46 | 103.17 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.33 | 45.30 | 2.23 | 175.92 |
| http/json-1m | 1048576 | 6 | stdx | 14.68 | 35.09 | 2.39 | 295.98 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.53 | 205.21 | 1.69 | 276.06 |
| http/json-1m | 1048576 | 9 | stdx | 29.00 | 72.87 | 2.51 | 369.68 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.06 | 107.80 | 2.91 | 518.39 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.60 | 65.40 | 2.77 | 412.17 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.26 | 144.85 | 2.94 | 677.40 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 35.52 | 104.12 | 2.93 | 622.85 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.70 | 150.13 | 2.90 | 714.87 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 40.13 | 125.13 | 3.12 | 625.79 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.74 | 30.90 | 2.63 | 309.95 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.85 | 24.80 | 2.28 | 274.08 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.89 | 59.43 | 2.29 | 472.91 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.66 | 50.05 | 2.21 | 674.51 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.82 | 83.31 | 2.04 | 565.89 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.51 | 81.30 | 2.75 | 665.38 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.65 | 25.19 | 2.61 | 248.22 |
| http/js-1m | 1048576 | 1 | stdx | 9.54 | 21.31 | 2.23 | 232.95 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.76 | 56.12 | 1.95 | 372.11 |
| http/js-1m | 1048576 | 6 | stdx | 24.86 | 46.64 | 1.88 | 741.73 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.13 | 120.65 | 1.58 | 499.46 |
| http/js-1m | 1048576 | 9 | stdx | 41.85 | 100.01 | 2.39 | 813.84 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.18 | 97.73 | 2.95 | 377.13 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.37 | 49.52 | 2.70 | 302.09 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.77 | 129.22 | 2.95 | 477.41 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 28.94 | 82.32 | 2.84 | 502.79 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.88 | 133.80 | 2.92 | 509.32 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 32.97 | 99.48 | 3.02 | 521.55 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.66 | 25.60 | 2.96 | 175.24 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.67 | 16.96 | 2.54 | 134.88 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.25 | 48.80 | 2.41 | 291.52 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.38 | 38.00 | 2.32 | 459.05 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.83 | 82.40 | 2.02 | 371.23 |
| http/css-16kx64 | 1048576 | 9 | stdx | 22.92 | 65.13 | 2.84 | 480.79 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.93 | 21.15 | 3.05 | 131.83 |
| http/css-1m | 1048576 | 1 | stdx | 5.79 | 14.91 | 2.57 | 108.57 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.77 | 44.50 | 2.14 | 226.20 |
| http/css-1m | 1048576 | 6 | stdx | 16.57 | 35.61 | 2.15 | 441.90 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.64 | 111.58 | 1.60 | 307.85 |
| http/css-1m | 1048576 | 9 | stdx | 31.99 | 83.00 | 2.59 | 511.17 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.20 | 48.89 | 1.94 | 927.78 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.10 | 49.19 | 2.72 | 323.17 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.53 | 86.45 | 2.08 | 1181.74 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.66 | 88.80 | 2.24 | 856.25 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.00 | 94.50 | 2.01 | 1344.27 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 53.82 | 134.38 | 2.50 | 1139.25 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.06 | 31.22 | 3.10 | 121.20 |
| silesia/dickens | 10192446 | 1 | stdx | 24.28 | 82.03 | 3.38 | 124.88 |
| silesia/dickens | 10192446 | 3 | libzstd | 22.92 | 34.39 | 1.50 | 171.14 |
| silesia/dickens | 10192446 | 3 | stdx | 36.74 | 78.22 | 2.13 | 182.23 |
| silesia/mozilla | 51220480 | 1 | libzstd | 6.98 | 22.69 | 3.25 | 70.80 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.71 | 54.73 | 3.09 | 173.30 |
| silesia/mozilla | 51220480 | 3 | libzstd | 17.35 | 27.89 | 1.61 | 102.55 |
| silesia/mozilla | 51220480 | 3 | stdx | 31.80 | 62.01 | 1.95 | 145.11 |
| silesia/mr | 9970564 | 1 | libzstd | 7.61 | 24.81 | 3.26 | 57.54 |
| silesia/mr | 9970564 | 1 | stdx | 19.92 | 66.82 | 3.35 | 113.83 |
| silesia/mr | 9970564 | 3 | libzstd | 20.33 | 32.19 | 1.58 | 86.64 |
| silesia/mr | 9970564 | 3 | stdx | 34.68 | 72.46 | 2.09 | 115.03 |
| silesia/nci | 33553445 | 1 | libzstd | 3.46 | 9.55 | 2.76 | 57.75 |
| silesia/nci | 33553445 | 1 | stdx | 7.68 | 25.69 | 3.34 | 58.83 |
| silesia/nci | 33553445 | 3 | libzstd | 5.35 | 9.95 | 1.86 | 56.60 |
| silesia/nci | 33553445 | 3 | stdx | 11.52 | 29.15 | 2.53 | 66.16 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.50 | 29.26 | 3.44 | 70.70 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.18 | 72.51 | 3.13 | 179.50 |
| silesia/ooffice | 6152192 | 3 | libzstd | 24.10 | 39.44 | 1.64 | 120.18 |
| silesia/ooffice | 6152192 | 3 | stdx | 43.42 | 82.20 | 1.89 | 185.58 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.01 | 22.29 | 3.18 | 66.66 |
| silesia/osdb | 10085684 | 1 | stdx | 16.40 | 50.52 | 3.08 | 124.96 |
| silesia/osdb | 10085684 | 3 | libzstd | 18.19 | 26.23 | 1.44 | 67.53 |
| silesia/osdb | 10085684 | 3 | stdx | 32.95 | 57.87 | 1.76 | 111.30 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.65 | 27.13 | 2.81 | 150.67 |
| silesia/reymont | 6627202 | 1 | stdx | 20.09 | 72.05 | 3.59 | 96.54 |
| silesia/reymont | 6627202 | 3 | libzstd | 18.49 | 27.10 | 1.47 | 126.56 |
| silesia/reymont | 6627202 | 3 | stdx | 28.83 | 62.18 | 2.16 | 146.23 |
| silesia/samba | 21606400 | 1 | libzstd | 5.85 | 16.88 | 2.88 | 85.67 |
| silesia/samba | 21606400 | 1 | stdx | 13.48 | 42.89 | 3.18 | 124.68 |
| silesia/samba | 21606400 | 3 | libzstd | 12.03 | 18.81 | 1.56 | 99.50 |
| silesia/samba | 21606400 | 3 | stdx | 20.77 | 44.75 | 2.15 | 133.24 |
| silesia/sao | 7251944 | 1 | libzstd | 9.00 | 33.69 | 3.74 | 45.09 |
| silesia/sao | 7251944 | 1 | stdx | 25.95 | 82.03 | 3.16 | 107.38 |
| silesia/sao | 7251944 | 3 | libzstd | 31.56 | 50.03 | 1.59 | 94.64 |
| silesia/sao | 7251944 | 3 | stdx | 53.25 | 95.22 | 1.79 | 142.66 |
| silesia/webster | 41458703 | 1 | libzstd | 8.62 | 24.94 | 2.89 | 131.51 |
| silesia/webster | 41458703 | 1 | stdx | 20.37 | 64.04 | 3.14 | 166.15 |
| silesia/webster | 41458703 | 3 | libzstd | 19.47 | 27.33 | 1.40 | 177.59 |
| silesia/webster | 41458703 | 3 | stdx | 31.86 | 64.55 | 2.03 | 194.87 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.65 | 14.92 | 3.21 | 17.27 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.94 | 76.64 | 3.20 | 93.83 |
| silesia/x-ray | 8474240 | 3 | libzstd | 32.31 | 52.73 | 1.63 | 87.93 |
| silesia/x-ray | 8474240 | 3 | stdx | 49.35 | 92.40 | 1.87 | 107.80 |
| silesia/xml | 5345280 | 1 | libzstd | 4.21 | 11.71 | 2.78 | 71.37 |
| silesia/xml | 5345280 | 1 | stdx | 10.34 | 34.21 | 3.31 | 93.78 |
| silesia/xml | 5345280 | 3 | libzstd | 6.70 | 12.61 | 1.88 | 77.58 |
| silesia/xml | 5345280 | 3 | stdx | 12.98 | 32.28 | 2.49 | 115.53 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.76 | 32.84 | 3.05 | 139.17 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.39 | 76.49 | 3.42 | 186.81 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.69 | 39.48 | 2.52 | 204.52 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.71 | 73.76 | 2.76 | 334.18 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.76 | 33.55 | 3.44 | 105.28 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.54 | 79.00 | 3.36 | 214.13 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.21 | 39.27 | 2.58 | 208.24 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.16 | 79.30 | 2.82 | 372.29 |
| canterbury/cp.html | 24603 | 1 | libzstd | 6.90 | 26.64 | 3.86 | 36.71 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.00 | 57.76 | 3.61 | 116.14 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.49 | 31.85 | 3.36 | 47.84 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.23 | 59.76 | 3.28 | 136.95 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.61 | 31.76 | 3.69 | 36.48 |
| canterbury/fields.c | 11150 | 1 | stdx | 16.96 | 65.73 | 3.87 | 85.21 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.63 | 34.13 | 3.54 | 46.26 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.36 | 64.68 | 3.73 | 90.52 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.43 | 38.01 | 4.03 | 6.15 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.18 | 77.57 | 3.84 | 51.54 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.83 | 43.09 | 3.98 | 14.93 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.39 | 79.60 | 3.72 | 67.42 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.02 | 23.56 | 3.92 | 14.68 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.73 | 56.75 | 3.85 | 83.42 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.65 | 23.80 | 2.75 | 27.74 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 20.92 | 56.61 | 2.71 | 109.67 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.83 | 28.52 | 2.90 | 156.65 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.50 | 72.02 | 3.35 | 160.19 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 16.54 | 32.14 | 1.94 | 202.26 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.92 | 67.10 | 2.49 | 296.68 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.31 | 32.37 | 3.14 | 128.68 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.06 | 84.16 | 3.36 | 157.23 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 20.74 | 38.77 | 1.87 | 228.08 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 32.33 | 80.77 | 2.50 | 342.56 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.16 | 8.51 | 2.70 | 67.08 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.51 | 23.15 | 3.08 | 104.40 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 4.90 | 10.97 | 2.24 | 58.55 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.69 | 24.08 | 2.49 | 132.75 |
| canterbury/sum | 38240 | 1 | libzstd | 6.49 | 25.39 | 3.91 | 29.61 |
| canterbury/sum | 38240 | 1 | stdx | 16.82 | 59.13 | 3.52 | 148.37 |
| canterbury/sum | 38240 | 3 | libzstd | 9.02 | 30.67 | 3.40 | 46.81 |
| canterbury/sum | 38240 | 3 | stdx | 19.70 | 61.82 | 3.14 | 178.69 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 9.98 | 39.82 | 3.99 | 12.14 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.83 | 80.38 | 3.86 | 60.41 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.33 | 48.17 | 3.91 | 20.18 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.79 | 83.98 | 3.68 | 75.98 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.33 | 33.44 | 3.24 | 77.20 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.82 | 95.62 | 4.38 | 7.20 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 15.10 | 31.30 | 2.07 | 35.84 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 24.30 | 70.38 | 2.90 | 38.27 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.68 | 27.45 | 2.83 | 149.21 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.54 | 71.86 | 3.50 | 109.01 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 18.35 | 28.20 | 1.54 | 133.44 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 28.74 | 63.36 | 2.20 | 156.04 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.14 | 22.70 | 2.79 | 137.75 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.69 | 55.86 | 2.99 | 192.06 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 15.80 | 23.87 | 1.51 | 174.93 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 25.76 | 51.26 | 1.99 | 237.97 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.08 | 52.46 | 3.07 | 160.18 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.64 | 100.54 | 2.82 | 641.19 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.07 | 59.20 | 3.10 | 197.21 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 37.78 | 104.00 | 2.75 | 634.31 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.70 | 22.46 | 2.92 | 122.17 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.13 | 46.84 | 3.32 | 182.46 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.74 | 24.61 | 2.82 | 140.33 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.35 | 47.61 | 3.10 | 192.17 |
| http/html-1m | 1048576 | 1 | libzstd | 6.23 | 16.74 | 2.68 | 114.88 |
| http/html-1m | 1048576 | 1 | stdx | 12.96 | 42.00 | 3.24 | 134.25 |
| http/html-1m | 1048576 | 3 | libzstd | 9.48 | 18.18 | 1.92 | 125.42 |
| http/html-1m | 1048576 | 3 | stdx | 16.13 | 39.37 | 2.44 | 177.05 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.37 | 42.52 | 2.96 | 116.18 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.40 | 83.13 | 2.83 | 525.65 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.84 | 44.54 | 3.00 | 128.65 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.54 | 84.87 | 2.78 | 536.50 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.80 | 14.98 | 3.12 | 57.51 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.68 | 33.78 | 3.49 | 115.98 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.35 | 16.21 | 3.03 | 72.84 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.64 | 34.58 | 3.25 | 122.73 |
| http/json-1m | 1048576 | 1 | libzstd | 4.06 | 12.55 | 3.09 | 53.47 |
| http/json-1m | 1048576 | 1 | stdx | 9.04 | 30.70 | 3.40 | 85.16 |
| http/json-1m | 1048576 | 3 | libzstd | 6.27 | 13.78 | 2.20 | 68.79 |
| http/json-1m | 1048576 | 3 | stdx | 11.61 | 30.64 | 2.64 | 119.53 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.57 | 57.26 | 3.08 | 184.08 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 39.71 | 113.49 | 2.86 | 693.01 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.44 | 65.54 | 3.06 | 260.36 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 41.82 | 116.54 | 2.79 | 680.05 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.82 | 26.52 | 3.01 | 127.34 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.58 | 55.71 | 3.36 | 200.74 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.04 | 28.74 | 2.86 | 152.83 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.70 | 55.35 | 3.13 | 209.37 |
| http/js-1m | 1048576 | 1 | libzstd | 6.55 | 17.87 | 2.73 | 114.09 |
| http/js-1m | 1048576 | 1 | stdx | 14.02 | 45.88 | 3.27 | 135.74 |
| http/js-1m | 1048576 | 3 | libzstd | 10.11 | 19.14 | 1.89 | 125.34 |
| http/js-1m | 1048576 | 3 | stdx | 17.35 | 41.25 | 2.38 | 187.53 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.58 | 46.90 | 3.01 | 136.86 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.12 | 91.65 | 2.85 | 579.16 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.67 | 50.53 | 3.03 | 160.49 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.45 | 93.63 | 2.80 | 586.22 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.11 | 18.99 | 3.11 | 78.15 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.42 | 43.79 | 3.52 | 137.28 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.57 | 19.41 | 2.96 | 95.75 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.82 | 42.34 | 3.30 | 152.84 |
| http/css-1m | 1048576 | 1 | libzstd | 1.50 | 4.59 | 3.07 | 21.67 |
| http/css-1m | 1048576 | 1 | stdx | 4.01 | 14.85 | 3.70 | 30.51 |
| http/css-1m | 1048576 | 3 | libzstd | 1.98 | 5.25 | 2.65 | 19.62 |
| http/css-1m | 1048576 | 3 | stdx | 4.01 | 13.33 | 3.32 | 31.83 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.53 | 12.79 | 3.63 | 6.22 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.11 | 30.66 | 3.37 | 61.39 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 28.54 | 50.53 | 1.77 | 49.53 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 21.40 | 47.43 | 2.22 | 207.85 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.5 | 74.2 | 0.119 | 3.01 | 2.91 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 65.8 | 219.6 | 0.088 | 7.78 | 3.33 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 37.3 | 163.0 | 0.069 | 4.40 | 4.37 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 251.6 | 1024.0 | 0.829 | 29.73 | 4.07 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.9 | 107.7 | 0.134 | 3.65 | 3.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.8 | 106.2 | 0.293 | 3.28 | 3.82 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.7 | 378.2 | 0.372 | 11.30 | 3.95 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 43.1 | 161.9 | 0.471 | 5.10 | 3.75 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 91.6 | 451.7 | 0.301 | 10.82 | 4.93 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.0 | 89.5 | 0.004 | 3.98 | 3.31 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.1 | 234.7 | 0.051 | 10.02 | 3.45 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 42.5 | 179.3 | 0.071 | 6.25 | 4.22 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 217.4 | 819.1 | 0.950 | 32.00 | 3.77 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.3 | 107.7 | 0.040 | 4.16 | 3.81 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.6 | 106.0 | 0.046 | 4.21 | 3.71 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 94.9 | 346.2 | 0.349 | 13.97 | 3.65 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 32.9 | 144.5 | 0.052 | 4.84 | 4.40 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 90.5 | 406.5 | 0.102 | 13.33 | 4.49 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114282.6 | 403846.2 | 499.515 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 594299.1 | 2503286.2 | 1392.320 | 3.44 | 4.21 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 113759.8 | 404053.2 | 464.784 | 0.66 | 3.55 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3556774.5 | 18223876.2 | 2976.722 | 20.62 | 5.12 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311173.5 | 621744.2 | 585.907 | 1.80 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 222866.6 | 826630.2 | 2172.113 | 1.29 | 3.71 |
| string: silesia/dickens | 1 | 172528 | std.json | 1579550.1 | 4578768.2 | 42538.423 | 9.16 | 2.90 |
| string: silesia/dickens | 1 | 172528 | serde_json | 204335.3 | 802391.2 | 999.381 | 1.18 | 3.93 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1049404.3 | 5281884.3 | 5018.680 | 6.08 | 5.03 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1574632.9 | 4799763.6 | 1751.429 | 1.32 | 3.05 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14273599.0 | 56816152.6 | 39237.500 | 11.99 | 3.98 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1572202.6 | 4799865.6 | 1617.786 | 1.32 | 3.05 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 28752131.6 | 132108253.6 | 159319.643 | 24.16 | 4.59 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4583166.0 | 7062781.6 | 539.429 | 3.85 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1788088.6 | 7322029.6 | 14102.500 | 1.50 | 4.09 |
| string: http/json-1m | 1 | 1190272 | std.json | 10305690.2 | 47381213.6 | 32997.643 | 8.66 | 4.60 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3796027.3 | 15226459.6 | 6139.000 | 3.19 | 4.01 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 8951752.8 | 48002071.4 | 27578.357 | 7.52 | 5.36 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2066266.3 | 5765413.8 | 4447.375 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6243533.8 | 22589263.8 | 8583.625 | 3.32 | 3.62 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2059266.0 | 5765515.8 | 3919.125 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47267321.5 | 227842320.8 | 279269.750 | 25.10 | 4.82 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3764168.1 | 8446023.8 | 1952.875 | 2.00 | 2.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7123549.5 | 12276717.8 | 275206.500 | 3.78 | 1.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17437687.9 | 63617055.8 | 267452.875 | 9.26 | 3.65 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9587570.4 | 24440755.8 | 338803.375 | 5.09 | 2.55 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39221187.6 | 160320152.1 | 800900.500 | 20.83 | 4.09 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12948120.0 | 42561069.3 | 245029.333 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 160366037.0 | 667246747.3 | 395565.667 | 31.60 | 4.16 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12970262.0 | 42561171.3 | 245501.667 | 2.56 | 3.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 159431958.3 | 639992662.3 | 423787.000 | 31.41 | 4.01 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17595536.0 | 49745820.3 | 254780.333 | 3.47 | 2.83 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14063506.3 | 45615166.3 | 447244.000 | 2.77 | 3.24 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79283117.3 | 314900845.3 | 459638.000 | 15.62 | 3.97 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36292833.3 | 131556135.3 | 581315.333 | 7.15 | 3.62 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66047051.7 | 273938971.0 | 837114.000 | 13.01 | 4.15 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 94323.3 | 303836.7 | 4.484 | 0.18 | 3.22 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 184130.8 | 623465.7 | 8.613 | 0.35 | 3.39 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 148225.9 | 557689.7 | 5.613 | 0.28 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10206627.5 | 53478202.7 | 6.484 | 19.47 | 5.24 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 489750.9 | 1376733.7 | 3.968 | 0.93 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 538879.9 | 2195917.7 | 9.097 | 1.03 | 4.07 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3463970.2 | 12808414.7 | 60513.290 | 6.61 | 3.70 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 298149.9 | 1179969.7 | 5.903 | 0.57 | 3.96 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2249471.1 | 12789199.1 | 244.419 | 4.29 | 5.69 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.1 | 81.8 | 0.108 | 2.26 | 4.27 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.1 | 153.6 | 0.126 | 4.15 | 4.37 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 23.3 | 103.2 | 0.097 | 2.75 | 4.43 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 216.0 | 981.0 | 0.933 | 25.51 | 4.54 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 18.7 | 79.5 | 0.106 | 2.21 | 4.24 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.1 | 94.1 | 0.135 | 2.73 | 4.08 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.5 | 105.6 | 0.248 | 3.25 | 3.83 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.1 | 310.8 | 0.359 | 8.16 | 4.50 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.9 | 255.3 | 0.520 | 7.55 | 3.99 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 67.7 | 315.1 | 0.236 | 7.99 | 4.66 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.4 | 82.8 | 0.024 | 2.70 | 4.51 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.0 | 153.9 | 0.026 | 5.30 | 4.27 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 22.9 | 101.7 | 0.024 | 3.37 | 4.44 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 168.7 | 718.3 | 1.266 | 24.84 | 4.26 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 17.9 | 81.5 | 0.024 | 2.63 | 4.56 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.7 | 96.8 | 0.032 | 3.20 | 4.46 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.8 | 117.9 | 0.033 | 4.24 | 4.09 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.6 | 271.2 | 0.249 | 8.78 | 4.55 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 49.0 | 211.7 | 0.037 | 7.21 | 4.32 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 81.5 | 331.7 | 0.086 | 11.99 | 4.07 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 84957.2 | 280786.2 | 724.330 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84684.8 | 280732.2 | 713.000 | 0.49 | 3.32 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84517.7 | 280724.2 | 707.722 | 0.49 | 3.32 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3276806.4 | 16047574.2 | 2942.691 | 18.99 | 4.90 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 82713.1 | 274401.2 | 658.278 | 0.48 | 3.32 |
| string: silesia/dickens | 1 | 172528 | simdjson | 208064.7 | 674016.2 | 2052.144 | 1.21 | 3.24 |
| string: silesia/dickens | 1 | 172528 | yyjson | 203657.6 | 825518.2 | 978.526 | 1.18 | 4.05 |
| string: silesia/dickens | 1 | 172528 | std.json | 1361340.7 | 2890892.2 | 53205.392 | 7.89 | 2.12 |
| string: silesia/dickens | 1 | 172528 | serde_json | 371679.7 | 1586249.2 | 2249.598 | 2.15 | 4.27 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 579245.3 | 2970293.3 | 2338.278 | 3.36 | 5.13 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1284487.6 | 3582350.6 | 12084.929 | 1.08 | 2.79 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1276554.9 | 3582290.6 | 11684.071 | 1.07 | 2.81 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1275155.9 | 3582278.6 | 11645.643 | 1.07 | 2.81 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25142580.9 | 109856348.6 | 142756.143 | 21.12 | 4.37 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1236889.4 | 3370022.6 | 11431.000 | 1.04 | 2.72 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2964519.7 | 10460762.6 | 29337.929 | 2.49 | 3.53 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2583258.2 | 10197931.6 | 9533.857 | 2.17 | 3.95 |
| string: http/json-1m | 1 | 1190272 | std.json | 8995179.2 | 43287986.6 | 16370.214 | 7.56 | 4.81 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4211981.4 | 17941088.6 | 11261.000 | 3.54 | 4.26 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5226469.3 | 26999739.0 | 11283.143 | 4.39 | 5.17 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2070438.6 | 6088099.8 | 4612.500 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2065889.5 | 6088039.8 | 4156.375 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2065086.5 | 6088027.8 | 4070.875 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43521657.5 | 193466548.8 | 265728.375 | 23.11 | 4.45 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2069427.9 | 5875346.8 | 4790.000 | 1.10 | 2.84 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2703691.3 | 7144143.8 | 20680.375 | 1.44 | 2.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12056243.4 | 23590602.8 | 446188.625 | 6.40 | 1.96 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20506120.8 | 56837736.8 | 549032.875 | 10.89 | 2.77 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11403599.1 | 33662338.8 | 331473.500 | 6.06 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18856556.0 | 76319473.5 | 252499.500 | 10.01 | 4.05 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113258.2 | 426376.7 | 3.645 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113057.1 | 426318.7 | 1.581 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113260.2 | 426299.7 | 2.452 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 637816.7 | 3146479.7 | 5.839 | 1.22 | 4.93 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113197.7 | 426343.7 | 1.484 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1201132.3 | 3866916.7 | 6.065 | 2.29 | 3.22 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1626245.4 | 5833341.7 | 6.097 | 3.10 | 3.59 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3607728.4 | 13108830.7 | 62701.000 | 6.88 | 3.63 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1784629.5 | 7405810.7 | 3.903 | 3.40 | 4.15 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2394850.8 | 12748343.6 | 15.935 | 4.57 | 5.32 |
