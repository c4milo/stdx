# bench-profile

| Field | Value |
|---|---|
| Commit | fd91729 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43215850776 |
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
| silesia/dickens | 10192446 | zlib | 8.84 | 19.08 | 2.16 | 309.18 |
| silesia/dickens | 10192446 | zlib-ng | 4.90 | 10.50 | 2.14 | 67.84 |
| silesia/dickens | 10192446 | libdeflate | 3.49 | 9.56 | 2.74 | 66.33 |
| silesia/dickens | 10192446 | Wuffs | 5.54 | 13.90 | 2.51 | 96.96 |
| silesia/dickens | 10192446 | stdx | 3.01 | 7.15 | 2.38 | 76.05 |
| silesia/mozilla | 51220480 | zlib | 8.48 | 17.23 | 2.03 | 250.28 |
| silesia/mozilla | 51220480 | zlib-ng | 4.96 | 8.95 | 1.81 | 85.90 |
| silesia/mozilla | 51220480 | libdeflate | 3.48 | 7.63 | 2.19 | 71.11 |
| silesia/mozilla | 51220480 | Wuffs | 6.42 | 13.89 | 2.16 | 133.08 |
| silesia/mozilla | 51220480 | stdx | 3.64 | 6.29 | 1.72 | 89.21 |
| silesia/mr | 9970564 | zlib | 8.43 | 18.46 | 2.19 | 201.13 |
| silesia/mr | 9970564 | zlib-ng | 4.83 | 9.98 | 2.07 | 67.97 |
| silesia/mr | 9970564 | libdeflate | 3.38 | 8.58 | 2.54 | 61.11 |
| silesia/mr | 9970564 | Wuffs | 6.02 | 14.04 | 2.33 | 100.02 |
| silesia/mr | 9970564 | stdx | 3.17 | 6.70 | 2.12 | 69.57 |
| silesia/nci | 33553445 | zlib | 3.59 | 10.18 | 2.83 | 81.48 |
| silesia/nci | 33553445 | zlib-ng | 1.63 | 3.13 | 1.91 | 35.38 |
| silesia/nci | 33553445 | libdeflate | 1.21 | 2.66 | 2.20 | 29.79 |
| silesia/nci | 33553445 | Wuffs | 2.50 | 6.47 | 2.59 | 41.11 |
| silesia/nci | 33553445 | stdx | 1.40 | 2.20 | 1.58 | 37.11 |
| silesia/ooffice | 6152192 | zlib | 11.80 | 21.06 | 1.79 | 414.24 |
| silesia/ooffice | 6152192 | zlib-ng | 6.96 | 12.04 | 1.73 | 141.48 |
| silesia/ooffice | 6152192 | libdeflate | 4.91 | 10.45 | 2.13 | 124.95 |
| silesia/ooffice | 6152192 | Wuffs | 8.85 | 17.54 | 1.98 | 221.54 |
| silesia/ooffice | 6152192 | stdx | 5.17 | 8.55 | 1.65 | 151.19 |
| silesia/osdb | 10085684 | zlib | 7.46 | 16.59 | 2.22 | 179.74 |
| silesia/osdb | 10085684 | zlib-ng | 4.35 | 8.38 | 1.93 | 54.95 |
| silesia/osdb | 10085684 | libdeflate | 2.85 | 6.91 | 2.42 | 29.80 |
| silesia/osdb | 10085684 | Wuffs | 5.81 | 13.61 | 2.34 | 78.95 |
| silesia/osdb | 10085684 | stdx | 2.83 | 5.65 | 2.00 | 40.32 |
| silesia/reymont | 6627202 | zlib | 7.39 | 15.89 | 2.15 | 259.43 |
| silesia/reymont | 6627202 | zlib-ng | 3.71 | 7.72 | 2.08 | 59.54 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.22 |
| silesia/reymont | 6627202 | Wuffs | 4.86 | 11.40 | 2.35 | 111.29 |
| silesia/reymont | 6627202 | stdx | 2.27 | 5.11 | 2.25 | 63.83 |
| silesia/samba | 21606400 | zlib | 6.18 | 14.13 | 2.29 | 174.93 |
| silesia/samba | 21606400 | zlib-ng | 3.41 | 6.47 | 1.90 | 58.05 |
| silesia/samba | 21606400 | libdeflate | 2.36 | 5.58 | 2.37 | 42.88 |
| silesia/samba | 21606400 | Wuffs | 4.36 | 10.39 | 2.38 | 79.87 |
| silesia/samba | 21606400 | stdx | 2.34 | 4.46 | 1.91 | 56.01 |
| silesia/sao | 7251944 | zlib | 10.52 | 23.54 | 2.24 | 205.85 |
| silesia/sao | 7251944 | zlib-ng | 7.88 | 14.83 | 1.88 | 79.30 |
| silesia/sao | 7251944 | libdeflate | 5.75 | 12.73 | 2.21 | 79.10 |
| silesia/sao | 7251944 | Wuffs | 8.90 | 21.26 | 2.39 | 86.39 |
| silesia/sao | 7251944 | stdx | 5.63 | 10.32 | 1.83 | 86.81 |
| silesia/webster | 41458703 | zlib | 7.79 | 16.16 | 2.07 | 279.74 |
| silesia/webster | 41458703 | zlib-ng | 4.23 | 8.04 | 1.90 | 85.34 |
| silesia/webster | 41458703 | libdeflate | 2.93 | 7.17 | 2.45 | 68.46 |
| silesia/webster | 41458703 | Wuffs | 5.15 | 11.67 | 2.27 | 122.29 |
| silesia/webster | 41458703 | stdx | 2.83 | 5.56 | 1.97 | 86.98 |
| silesia/x-ray | 8474240 | zlib | 12.86 | 27.21 | 2.12 | 327.91 |
| silesia/x-ray | 8474240 | zlib-ng | 9.06 | 17.39 | 1.92 | 124.03 |
| silesia/x-ray | 8474240 | libdeflate | 6.56 | 15.26 | 2.32 | 124.88 |
| silesia/x-ray | 8474240 | Wuffs | 10.82 | 23.52 | 2.17 | 190.99 |
| silesia/x-ray | 8474240 | stdx | 6.21 | 11.49 | 1.85 | 137.78 |
| silesia/xml | 5345280 | zlib | 4.23 | 11.16 | 2.63 | 117.99 |
| silesia/xml | 5345280 | zlib-ng | 2.00 | 3.88 | 1.94 | 43.00 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 31.97 |
| silesia/xml | 5345280 | Wuffs | 2.84 | 7.22 | 2.54 | 59.11 |
| silesia/xml | 5345280 | stdx | 1.31 | 2.65 | 2.02 | 41.56 |
| canterbury/alice29.txt | 152089 | zlib | 8.43 | 18.35 | 2.18 | 295.00 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.71 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.20 | 8.96 | 2.80 | 56.04 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.37 | 13.40 | 2.50 | 98.26 |
| canterbury/alice29.txt | 152089 | stdx | 2.72 | 6.99 | 2.57 | 63.17 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.01 | 19.42 | 2.16 | 313.05 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.11 | 10.86 | 2.13 | 75.09 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.62 | 9.82 | 2.71 | 70.28 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.75 | 14.40 | 2.50 | 99.11 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.11 | 7.52 | 2.42 | 81.44 |
| canterbury/cp.html | 24603 | zlib | 7.10 | 17.33 | 2.44 | 174.53 |
| canterbury/cp.html | 24603 | zlib-ng | 4.31 | 9.50 | 2.20 | 46.19 |
| canterbury/cp.html | 24603 | libdeflate | 2.87 | 7.95 | 2.77 | 16.56 |
| canterbury/cp.html | 24603 | Wuffs | 5.28 | 13.91 | 2.64 | 65.01 |
| canterbury/cp.html | 24603 | stdx | 2.76 | 7.19 | 2.61 | 21.55 |
| canterbury/fields.c | 11150 | zlib | 5.33 | 17.73 | 3.33 | 41.83 |
| canterbury/fields.c | 11150 | zlib-ng | 4.04 | 10.20 | 2.52 | 26.39 |
| canterbury/fields.c | 11150 | libdeflate | 2.82 | 8.32 | 2.95 | 1.86 |
| canterbury/fields.c | 11150 | Wuffs | 4.54 | 14.54 | 3.20 | 11.45 |
| canterbury/fields.c | 11150 | stdx | 2.50 | 7.64 | 3.05 | 4.68 |
| canterbury/grammar.lsp | 3721 | zlib | 6.92 | 24.26 | 3.51 | 7.87 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.87 | 17.48 | 2.98 | 10.22 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.49 | 12.05 | 2.68 | 0.98 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.69 | 21.86 | 3.27 | 5.16 |
| canterbury/grammar.lsp | 3721 | stdx | 3.86 | 12.18 | 3.16 | 2.05 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.59 | 15.27 | 3.33 | 48.14 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.66 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.74 | 5.97 | 2.18 | 8.90 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.86 | 11.59 | 3.00 | 14.92 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.73 | 4.66 | 2.69 | 16.46 |
| canterbury/lcet10.txt | 426754 | zlib | 8.19 | 17.78 | 2.17 | 288.86 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 60.86 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.81 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.23 | 12.88 | 2.46 | 101.58 |
| canterbury/lcet10.txt | 426754 | stdx | 2.59 | 6.42 | 2.48 | 66.61 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.19 | 19.86 | 2.16 | 320.45 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.26 | 11.19 | 2.13 | 76.62 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.76 | 10.19 | 2.71 | 76.51 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.80 | 14.61 | 2.52 | 98.97 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.15 | 7.63 | 2.43 | 84.90 |
| canterbury/ptt5 | 513216 | zlib | 5.05 | 10.71 | 2.12 | 103.78 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.42 |
| canterbury/ptt5 | 513216 | libdeflate | 1.44 | 3.02 | 2.09 | 38.05 |
| canterbury/ptt5 | 513216 | Wuffs | 3.00 | 7.13 | 2.37 | 57.64 |
| canterbury/ptt5 | 513216 | stdx | 1.45 | 2.55 | 1.76 | 49.14 |
| canterbury/sum | 38240 | zlib | 8.03 | 18.12 | 2.26 | 224.01 |
| canterbury/sum | 38240 | zlib-ng | 4.68 | 10.02 | 2.14 | 59.78 |
| canterbury/sum | 38240 | libdeflate | 3.42 | 8.34 | 2.44 | 44.90 |
| canterbury/sum | 38240 | Wuffs | 5.86 | 14.47 | 2.47 | 83.51 |
| canterbury/sum | 38240 | stdx | 3.20 | 7.73 | 2.42 | 42.08 |
| canterbury/xargs.1 | 4227 | zlib | 7.45 | 25.22 | 3.39 | 14.88 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.45 | 17.97 | 2.78 | 15.11 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.83 | 13.27 | 2.74 | 0.23 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.23 | 22.63 | 3.13 | 11.06 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 12.86 | 3.03 | 2.38 |
| canterbury-large/E.coli | 4638690 | zlib | 6.78 | 17.84 | 2.63 | 178.20 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.24 | 9.68 | 2.28 | 47.37 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.27 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.67 | 12.73 | 2.73 | 62.16 |
| canterbury-large/E.coli | 4638690 | stdx | 2.49 | 6.72 | 2.70 | 53.95 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.57 | 16.46 | 2.17 | 270.45 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.79 | 8.26 | 2.18 | 53.50 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.37 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.80 | 11.73 | 2.45 | 100.09 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.23 | 5.57 | 2.50 | 55.64 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.71 | 15.84 | 2.05 | 281.08 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.46 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.13 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.17 | 11.48 | 2.22 | 127.98 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.71 | 5.40 | 1.99 | 90.15 |
| http/html-1kx1024 | 1048576 | zlib | 16.69 | 35.58 | 2.13 | 352.73 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.69 | 28.43 | 2.24 | 217.77 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.85 | 20.05 | 1.85 | 156.09 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.36 | 38.07 | 2.48 | 265.73 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 137.66 |
| http/html-16kx64 | 1048576 | zlib | 6.73 | 14.77 | 2.20 | 221.79 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.38 |
| http/html-16kx64 | 1048576 | libdeflate | 2.66 | 6.04 | 2.28 | 60.70 |
| http/html-16kx64 | 1048576 | Wuffs | 4.93 | 11.57 | 2.35 | 115.15 |
| http/html-16kx64 | 1048576 | stdx | 2.53 | 5.56 | 2.20 | 60.15 |
| http/html-1m | 1048576 | zlib | 5.31 | 12.53 | 2.36 | 175.48 |
| http/html-1m | 1048576 | zlib-ng | 2.63 | 5.03 | 1.92 | 60.45 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.41 |
| http/html-1m | 1048576 | Wuffs | 3.60 | 8.48 | 2.35 | 87.67 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.11 | 52.67 |
| http/json-1kx1024 | 1048576 | zlib | 10.60 | 23.92 | 2.26 | 192.60 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.43 | 16.69 | 2.25 | 132.11 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.12 | 16.72 | 1.83 | 92.10 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.16 | 34.78 | 2.86 | 146.57 |
| http/json-1kx1024 | 1048576 | stdx | 5.02 | 13.12 | 2.62 | 80.39 |
| http/json-16kx64 | 1048576 | zlib | 4.56 | 12.51 | 2.74 | 103.21 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.64 | 5.50 | 2.08 | 53.12 |
| http/json-16kx64 | 1048576 | libdeflate | 1.93 | 4.24 | 2.19 | 40.49 |
| http/json-16kx64 | 1048576 | Wuffs | 3.50 | 9.43 | 2.70 | 57.78 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.25 | 39.52 |
| http/json-1m | 1048576 | zlib | 3.84 | 11.20 | 2.92 | 82.89 |
| http/json-1m | 1048576 | zlib-ng | 1.97 | 3.91 | 1.98 | 39.90 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.76 |
| http/json-1m | 1048576 | Wuffs | 2.72 | 7.37 | 2.71 | 43.25 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.02 | 39.93 |
| http/js-1kx1024 | 1048576 | zlib | 18.25 | 38.46 | 2.11 | 411.50 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.77 | 31.25 | 2.27 | 238.31 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.53 | 21.58 | 1.87 | 179.07 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.55 | 40.70 | 2.46 | 299.04 |
| http/js-1kx1024 | 1048576 | stdx | 9.27 | 22.85 | 2.46 | 159.46 |
| http/js-16kx64 | 1048576 | zlib | 7.65 | 16.08 | 2.10 | 263.23 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.98 | 91.85 |
| http/js-16kx64 | 1048576 | libdeflate | 3.10 | 7.01 | 2.26 | 72.12 |
| http/js-16kx64 | 1048576 | Wuffs | 5.51 | 12.75 | 2.31 | 128.65 |
| http/js-16kx64 | 1048576 | stdx | 3.00 | 6.54 | 2.18 | 72.17 |
| http/js-1m | 1048576 | zlib | 5.85 | 13.31 | 2.27 | 200.00 |
| http/js-1m | 1048576 | zlib-ng | 2.87 | 5.66 | 1.97 | 60.05 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 42.11 |
| http/js-1m | 1048576 | Wuffs | 3.91 | 9.14 | 2.34 | 93.75 |
| http/js-1m | 1048576 | stdx | 1.80 | 3.89 | 2.16 | 55.15 |
| http/css-1kx1024 | 1048576 | zlib | 14.02 | 30.36 | 2.17 | 279.73 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.26 | 23.04 | 2.25 | 171.56 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.43 | 17.37 | 1.84 | 121.36 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.76 | 32.50 | 2.55 | 210.63 |
| http/css-1kx1024 | 1048576 | stdx | 6.67 | 17.64 | 2.64 | 100.84 |
| http/css-16kx64 | 1048576 | zlib | 5.31 | 13.04 | 2.46 | 152.87 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.81 | 6.07 | 2.16 | 52.72 |
| http/css-16kx64 | 1048576 | libdeflate | 1.91 | 4.69 | 2.46 | 30.38 |
| http/css-16kx64 | 1048576 | Wuffs | 3.78 | 10.01 | 2.65 | 69.13 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.53 | 28.53 |
| http/css-1m | 1048576 | zlib | 3.98 | 10.97 | 2.75 | 107.35 |
| http/css-1m | 1048576 | zlib-ng | 1.71 | 3.75 | 2.18 | 30.83 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.96 | 13.17 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.78 | 43.21 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.54 | 21.26 |
| shuffled/dickens-1m | 1048576 | zlib | 13.32 | 25.88 | 1.94 | 374.95 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.72 | 16.72 | 1.72 | 197.50 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.02 | 14.95 | 2.13 | 193.83 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.34 | 22.08 | 2.13 | 201.56 |
| shuffled/dickens-1m | 1048576 | stdx | 7.03 | 11.89 | 1.69 | 206.67 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.45 | 14.05 | 4.07 | 3.47 |
| silesia/dickens | 10192446 | stdx | 3.62 | 12.47 | 3.44 | 3.67 |
| silesia/mozilla | 51220480 | libzstd | 2.83 | 9.68 | 3.43 | 30.24 |
| silesia/mozilla | 51220480 | stdx | 2.85 | 9.68 | 3.39 | 15.92 |
| silesia/mr | 9970564 | libzstd | 3.00 | 11.99 | 4.00 | 6.10 |
| silesia/mr | 9970564 | stdx | 3.09 | 10.83 | 3.50 | 5.32 |
| silesia/nci | 33553445 | libzstd | 1.65 | 4.88 | 2.95 | 24.89 |
| silesia/nci | 33553445 | stdx | 1.75 | 4.63 | 2.64 | 13.65 |
| silesia/ooffice | 6152192 | libzstd | 3.38 | 12.19 | 3.61 | 31.18 |
| silesia/ooffice | 6152192 | stdx | 3.36 | 12.40 | 3.69 | 12.20 |
| silesia/osdb | 10085684 | libzstd | 2.34 | 8.45 | 3.60 | 14.95 |
| silesia/osdb | 10085684 | stdx | 2.40 | 8.11 | 3.38 | 15.28 |
| silesia/reymont | 6627202 | libzstd | 3.16 | 11.62 | 3.68 | 11.64 |
| silesia/reymont | 6627202 | stdx | 3.29 | 10.36 | 3.15 | 12.71 |
| silesia/samba | 21606400 | libzstd | 2.10 | 7.41 | 3.53 | 18.75 |
| silesia/samba | 21606400 | stdx | 2.17 | 6.83 | 3.15 | 17.95 |
| silesia/sao | 7251944 | libzstd | 3.81 | 12.72 | 3.34 | 26.58 |
| silesia/sao | 7251944 | stdx | 3.54 | 12.58 | 3.55 | 6.12 |
| silesia/webster | 41458703 | libzstd | 3.18 | 11.24 | 3.53 | 16.28 |
| silesia/webster | 41458703 | stdx | 3.38 | 10.05 | 2.97 | 17.31 |
| silesia/x-ray | 8474240 | libzstd | 3.89 | 14.94 | 3.84 | 18.85 |
| silesia/x-ray | 8474240 | stdx | 3.60 | 13.23 | 3.68 | 8.61 |
| silesia/xml | 5345280 | libzstd | 1.55 | 5.57 | 3.58 | 23.31 |
| silesia/xml | 5345280 | stdx | 1.52 | 5.16 | 3.39 | 17.35 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.89 | 4.06 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.45 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.95 | 14.26 | 4.83 | 3.20 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.30 | 0.27 |
| canterbury/cp.html | 24603 | libzstd | 2.63 | 10.74 | 4.09 | 7.33 |
| canterbury/cp.html | 24603 | stdx | 2.55 | 10.42 | 4.09 | 0.17 |
| canterbury/fields.c | 11150 | libzstd | 3.12 | 13.62 | 4.37 | 8.96 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.23 | 0.28 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.18 | 16.94 | 4.05 | 4.56 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.54 | 4.01 | 0.20 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.52 | 11.40 | 4.52 | 7.80 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.23 | 0.90 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.69 | 12.89 | 4.78 | 5.10 |
| canterbury/lcet10.txt | 426754 | stdx | 2.72 | 11.52 | 4.24 | 3.48 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.09 | 15.16 | 4.90 | 1.52 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.28 | 0.95 |
| canterbury/ptt5 | 513216 | libzstd | 1.46 | 4.52 | 3.10 | 25.73 |
| canterbury/ptt5 | 513216 | stdx | 1.34 | 4.46 | 3.33 | 13.33 |
| canterbury/sum | 38240 | libzstd | 2.60 | 10.58 | 4.07 | 9.02 |
| canterbury/sum | 38240 | stdx | 2.61 | 10.74 | 4.11 | 0.25 |
| canterbury/xargs.1 | 4227 | libzstd | 4.24 | 17.41 | 4.11 | 8.78 |
| canterbury/xargs.1 | 4227 | stdx | 4.25 | 17.17 | 4.04 | 0.21 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.04 | 13.64 | 4.49 | 2.17 |
| canterbury-large/E.coli | 4638690 | stdx | 3.10 | 12.04 | 3.88 | 2.81 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.96 | 12.00 | 4.06 | 8.46 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.06 | 10.64 | 3.47 | 9.12 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.52 | 9.60 | 3.81 | 19.95 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.59 | 8.64 | 3.34 | 21.15 |
| http/html-1kx1024 | 1048576 | libzstd | 7.26 | 21.63 | 2.98 | 63.43 |
| http/html-1kx1024 | 1048576 | stdx | 7.48 | 22.46 | 3.00 | 76.67 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.71 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.61 | 30.75 |
| http/html-1m | 1048576 | libzstd | 2.01 | 7.88 | 3.92 | 24.42 |
| http/html-1m | 1048576 | stdx | 1.99 | 7.12 | 3.58 | 25.17 |
| http/json-1kx1024 | 1048576 | libzstd | 6.28 | 17.39 | 2.77 | 49.81 |
| http/json-1kx1024 | 1048576 | stdx | 6.23 | 17.86 | 2.87 | 53.42 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.26 | 3.54 | 28.28 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.58 | 19.74 |
| http/json-1m | 1048576 | libzstd | 1.71 | 6.08 | 3.55 | 27.80 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.63 | 14.53 |
| http/js-1kx1024 | 1048576 | libzstd | 8.34 | 26.35 | 3.16 | 73.79 |
| http/js-1kx1024 | 1048576 | stdx | 9.06 | 27.60 | 3.05 | 113.52 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.72 | 4.00 | 24.50 |
| http/js-16kx64 | 1048576 | stdx | 2.95 | 11.06 | 3.74 | 25.74 |
| http/js-1m | 1048576 | libzstd | 2.05 | 8.19 | 4.00 | 20.45 |
| http/js-1m | 1048576 | stdx | 2.14 | 7.48 | 3.50 | 21.86 |
| http/css-1kx1024 | 1048576 | libzstd | 6.89 | 19.69 | 2.86 | 53.14 |
| http/css-1kx1024 | 1048576 | stdx | 6.86 | 19.96 | 2.91 | 64.03 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.70 | 3.88 | 22.58 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.11 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.58 | 3.89 | 5.37 |
| http/css-1m | 1048576 | stdx | 0.70 | 2.49 | 3.56 | 4.29 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.77 | 9.40 | 3.40 | 28.49 |
| shuffled/dickens-1m | 1048576 | stdx | 2.72 | 9.19 | 3.38 | 12.58 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.46 | 16.93 | 2.27 | 99.79 |
| silesia/dickens | 1048576 | stdx | 5.08 | 12.38 | 2.43 | 54.56 |
| silesia/mozilla | 1048576 | Google | 13.45 | 28.31 | 2.10 | 46.49 |
| silesia/mozilla | 1048576 | stdx | 8.32 | 15.02 | 1.81 | 47.29 |
| silesia/mr | 1048576 | Google | 8.87 | 20.21 | 2.28 | 103.00 |
| silesia/mr | 1048576 | stdx | 5.79 | 13.25 | 2.29 | 88.45 |
| silesia/nci | 1048576 | Google | 2.54 | 5.70 | 2.25 | 52.08 |
| silesia/nci | 1048576 | stdx | 1.95 | 3.95 | 2.03 | 55.06 |
| silesia/ooffice | 1048576 | Google | 14.10 | 29.27 | 2.08 | 288.09 |
| silesia/ooffice | 1048576 | stdx | 11.08 | 20.33 | 1.84 | 324.79 |
| silesia/osdb | 1048576 | Google | 8.15 | 17.48 | 2.14 | 95.18 |
| silesia/osdb | 1048576 | stdx | 5.18 | 10.57 | 2.04 | 91.44 |
| silesia/reymont | 1048576 | Google | 5.39 | 12.62 | 2.34 | 82.21 |
| silesia/reymont | 1048576 | stdx | 3.73 | 9.25 | 2.48 | 47.40 |
| silesia/samba | 1048576 | Google | 7.57 | 16.30 | 2.15 | 95.15 |
| silesia/samba | 1048576 | stdx | 5.05 | 10.71 | 2.12 | 66.98 |
| silesia/sao | 1048576 | Google | 16.77 | 37.18 | 2.22 | 162.57 |
| silesia/sao | 1048576 | stdx | 10.46 | 22.65 | 2.17 | 142.68 |
| silesia/webster | 1048576 | Google | 6.48 | 14.00 | 2.16 | 113.70 |
| silesia/webster | 1048576 | stdx | 4.45 | 9.98 | 2.24 | 68.68 |
| silesia/x-ray | 1048576 | Google | 19.24 | 38.56 | 2.00 | 235.34 |
| silesia/x-ray | 1048576 | stdx | 14.62 | 30.18 | 2.06 | 234.71 |
| silesia/xml | 1048576 | Google | 3.44 | 7.61 | 2.22 | 65.34 |
| silesia/xml | 1048576 | stdx | 2.39 | 5.40 | 2.26 | 46.87 |
| canterbury/alice29.txt | 152089 | Google | 8.85 | 20.55 | 2.32 | 134.36 |
| canterbury/alice29.txt | 152089 | stdx | 6.04 | 15.33 | 2.54 | 79.34 |
| canterbury/asyoulik.txt | 125179 | Google | 10.35 | 23.71 | 2.29 | 167.33 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.12 | 17.43 | 2.45 | 107.25 |
| canterbury/cp.html | 24603 | Google | 9.02 | 22.20 | 2.46 | 109.23 |
| canterbury/cp.html | 24603 | stdx | 5.64 | 17.15 | 3.04 | 25.93 |
| canterbury/fields.c | 11150 | Google | 7.09 | 21.16 | 2.99 | 27.87 |
| canterbury/fields.c | 11150 | stdx | 4.92 | 17.08 | 3.47 | 3.68 |
| canterbury/grammar.lsp | 3721 | Google | 9.80 | 30.16 | 3.08 | 4.99 |
| canterbury/grammar.lsp | 3721 | stdx | 7.14 | 25.04 | 3.51 | 0.46 |
| canterbury/kennedy.xls | 1029744 | Google | 5.42 | 17.05 | 3.14 | 37.39 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.80 | 12.94 | 3.41 | 34.18 |
| canterbury/lcet10.txt | 426754 | Google | 7.71 | 17.36 | 2.25 | 125.86 |
| canterbury/lcet10.txt | 426754 | stdx | 5.17 | 12.96 | 2.50 | 66.43 |
| canterbury/plrabn12.txt | 481861 | Google | 9.05 | 20.82 | 2.30 | 132.71 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.19 | 15.04 | 2.43 | 87.24 |
| canterbury/ptt5 | 513216 | Google | 4.28 | 10.41 | 2.43 | 62.11 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.07 | 65.71 |
| canterbury/sum | 38240 | Google | 10.78 | 26.44 | 2.45 | 155.44 |
| canterbury/sum | 38240 | stdx | 8.34 | 21.11 | 2.53 | 157.20 |
| canterbury/xargs.1 | 4227 | Google | 11.07 | 34.81 | 3.14 | 12.67 |
| canterbury/xargs.1 | 4227 | stdx | 8.48 | 30.44 | 3.59 | 5.37 |
| canterbury-large/E.coli | 1048576 | Google | 8.13 | 19.55 | 2.41 | 1.45 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.15 |
| canterbury-large/bible.txt | 1048576 | Google | 5.29 | 12.28 | 2.32 | 80.79 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.52 | 8.93 | 2.54 | 39.77 |
| canterbury-large/world192.txt | 1048576 | Google | 6.14 | 12.84 | 2.09 | 114.71 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.40 | 9.38 | 2.13 | 77.42 |
| http/html-1kx1024 | 1048576 | Google | 18.09 | 41.93 | 2.32 | 387.17 |
| http/html-1kx1024 | 1048576 | stdx | 15.29 | 37.56 | 2.46 | 361.69 |
| http/html-16kx64 | 1048576 | Google | 6.72 | 14.85 | 2.21 | 149.03 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.51 |
| http/html-1m | 1048576 | Google | 4.01 | 8.94 | 2.23 | 82.84 |
| http/html-1m | 1048576 | stdx | 2.85 | 6.52 | 2.29 | 54.68 |
| http/json-1kx1024 | 1048576 | Google | 14.49 | 36.64 | 2.53 | 241.03 |
| http/json-1kx1024 | 1048576 | stdx | 12.96 | 33.63 | 2.59 | 276.22 |
| http/json-16kx64 | 1048576 | Google | 4.42 | 11.43 | 2.59 | 81.67 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.36 |
| http/json-1m | 1048576 | Google | 3.39 | 8.65 | 2.55 | 58.99 |
| http/json-1m | 1048576 | stdx | 2.45 | 5.99 | 2.44 | 57.78 |
| http/js-1kx1024 | 1048576 | Google | 19.99 | 46.20 | 2.31 | 429.42 |
| http/js-1kx1024 | 1048576 | stdx | 16.38 | 39.90 | 2.44 | 381.47 |
| http/js-16kx64 | 1048576 | Google | 8.03 | 17.73 | 2.21 | 167.56 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.37 |
| http/js-1m | 1048576 | Google | 4.33 | 9.54 | 2.20 | 83.28 |
| http/js-1m | 1048576 | stdx | 3.14 | 7.25 | 2.31 | 55.22 |
| http/css-1kx1024 | 1048576 | Google | 15.52 | 37.36 | 2.41 | 293.18 |
| http/css-1kx1024 | 1048576 | stdx | 13.79 | 34.70 | 2.52 | 302.56 |
| http/css-16kx64 | 1048576 | Google | 4.95 | 11.76 | 2.38 | 101.84 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.35 |
| http/css-1m | 1048576 | Google | 2.43 | 9.42 | 3.88 | 16.85 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.49 | 12.11 |
| shuffled/dickens-1m | 1048576 | Google | 10.16 | 20.65 | 2.03 | 108.32 |
| shuffled/dickens-1m | 1048576 | stdx | 8.75 | 14.53 | 1.66 | 116.72 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.25 | 36.91 | 2.42 | 411.17 |
| silesia/dickens | 10192446 | 1 | stdx | 16.36 | 38.17 | 2.33 | 359.69 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.02 | 87.63 | 1.68 | 696.42 |
| silesia/dickens | 10192446 | 6 | stdx | 49.41 | 84.26 | 1.71 | 1422.84 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.68 | 160.47 | 1.44 | 930.45 |
| silesia/dickens | 10192446 | 9 | stdx | 84.74 | 191.80 | 2.26 | 1714.49 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.15 | 32.62 | 2.31 | 440.12 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.37 | 30.24 | 2.26 | 295.33 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.83 | 70.83 | 2.16 | 579.43 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.54 | 69.96 | 2.22 | 734.36 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.41 | 221.49 | 1.74 | 768.37 |
| silesia/mozilla | 51220480 | 9 | stdx | 49.02 | 126.12 | 2.57 | 789.79 |
| silesia/mr | 9970564 | 1 | libdeflate | 12.00 | 35.02 | 2.92 | 229.92 |
| silesia/mr | 9970564 | 1 | stdx | 12.63 | 34.08 | 2.70 | 187.65 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.15 | 80.54 | 2.11 | 436.10 |
| silesia/mr | 9970564 | 6 | stdx | 39.57 | 83.18 | 2.10 | 958.52 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.64 | 165.48 | 1.69 | 755.28 |
| silesia/mr | 9970564 | 9 | stdx | 87.04 | 206.31 | 2.37 | 1326.42 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.25 | 18.42 | 2.95 | 117.28 |
| silesia/nci | 33553445 | 1 | stdx | 4.97 | 10.88 | 2.19 | 98.06 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.94 | 34.84 | 2.06 | 226.38 |
| silesia/nci | 33553445 | 6 | stdx | 14.34 | 29.54 | 2.06 | 388.77 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.27 | 105.28 | 1.69 | 498.50 |
| silesia/nci | 33553445 | 9 | stdx | 33.10 | 80.63 | 2.44 | 648.93 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.94 | 39.15 | 1.96 | 753.89 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.79 | 39.08 | 2.20 | 429.73 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 40.96 | 79.10 | 1.93 | 953.66 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.72 | 87.83 | 2.11 | 1014.88 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.47 | 127.63 | 1.71 | 1132.61 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.57 | 129.17 | 2.46 | 935.76 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.93 | 30.15 | 2.33 | 355.53 |
| silesia/osdb | 10085684 | 1 | stdx | 12.95 | 27.86 | 2.15 | 293.74 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.19 | 55.67 | 1.97 | 490.12 |
| silesia/osdb | 10085684 | 6 | stdx | 27.07 | 57.40 | 2.12 | 568.59 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.88 | 64.15 | 1.89 | 555.74 |
| silesia/osdb | 10085684 | 9 | stdx | 35.49 | 87.23 | 2.46 | 691.46 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.64 | 32.88 | 2.60 | 311.16 |
| silesia/reymont | 6627202 | 1 | stdx | 13.56 | 33.24 | 2.45 | 271.65 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.03 | 86.58 | 1.80 | 519.60 |
| silesia/reymont | 6627202 | 6 | stdx | 45.29 | 76.82 | 1.70 | 1436.33 |
| silesia/reymont | 6627202 | 9 | libdeflate | 197.94 | 276.14 | 1.40 | 831.75 |
| silesia/reymont | 6627202 | 9 | stdx | 87.24 | 189.97 | 2.18 | 1616.22 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.47 | 26.53 | 2.53 | 273.16 |
| silesia/samba | 21606400 | 1 | stdx | 9.91 | 22.23 | 2.24 | 221.29 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.93 | 58.79 | 2.03 | 386.32 |
| silesia/samba | 21606400 | 6 | stdx | 24.09 | 49.84 | 2.07 | 620.62 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.09 | 141.44 | 1.68 | 503.24 |
| silesia/samba | 21606400 | 9 | stdx | 41.56 | 102.63 | 2.47 | 731.16 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.74 | 47.87 | 2.20 | 685.68 |
| silesia/sao | 7251944 | 1 | stdx | 19.18 | 49.92 | 2.60 | 346.52 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.04 | 96.89 | 1.90 | 962.82 |
| silesia/sao | 7251944 | 6 | stdx | 47.03 | 105.65 | 2.25 | 848.80 |
| silesia/sao | 7251944 | 9 | libdeflate | 70.89 | 120.26 | 1.70 | 1113.31 |
| silesia/sao | 7251944 | 9 | stdx | 55.62 | 138.16 | 2.48 | 847.54 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.13 | 30.45 | 2.32 | 387.88 |
| silesia/webster | 41458703 | 1 | stdx | 13.84 | 29.08 | 2.10 | 338.83 |
| silesia/webster | 41458703 | 6 | libdeflate | 36.99 | 66.02 | 1.78 | 574.10 |
| silesia/webster | 41458703 | 6 | stdx | 35.03 | 60.88 | 1.74 | 1095.67 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.45 | 138.85 | 1.47 | 754.90 |
| silesia/webster | 41458703 | 9 | stdx | 60.66 | 135.96 | 2.24 | 1290.40 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.69 | 49.67 | 2.10 | 784.87 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.60 | 50.81 | 2.89 | 261.68 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.80 | 82.77 | 2.52 | 851.56 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.83 | 98.11 | 2.90 | 538.53 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.43 | 91.03 | 2.43 | 1031.28 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.90 | 122.05 | 2.98 | 466.47 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.82 | 21.59 | 2.76 | 177.38 |
| silesia/xml | 5345280 | 1 | stdx | 7.00 | 15.66 | 2.24 | 154.90 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.19 | 40.51 | 1.91 | 264.72 |
| silesia/xml | 5345280 | 6 | stdx | 17.74 | 34.32 | 1.94 | 499.14 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.60 | 89.17 | 1.52 | 371.77 |
| silesia/xml | 5345280 | 9 | stdx | 31.20 | 72.83 | 2.33 | 599.75 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.27 | 35.61 | 2.50 | 380.45 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.06 | 36.12 | 2.40 | 337.20 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.69 | 82.29 | 1.76 | 642.83 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.65 | 77.43 | 1.77 | 1301.96 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.44 | 159.21 | 1.48 | 849.13 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 72.63 | 167.73 | 2.31 | 1512.49 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.17 | 37.20 | 2.45 | 416.77 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.76 | 37.43 | 2.37 | 358.76 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.25 | 85.43 | 1.77 | 717.42 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.12 | 81.93 | 1.78 | 1388.85 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.76 | 136.15 | 1.53 | 940.96 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 75.70 | 175.97 | 2.32 | 1614.69 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.67 | 32.02 | 2.74 | 282.14 |
| canterbury/cp.html | 24603 | 1 | stdx | 10.92 | 27.13 | 2.48 | 242.67 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 26.91 | 62.33 | 2.32 | 486.41 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.72 | 57.06 | 2.41 | 620.43 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.81 | 91.97 | 1.96 | 596.62 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.15 | 88.89 | 2.85 | 644.25 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.53 | 35.92 | 3.77 | 64.09 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.52 | 30.05 | 3.53 | 48.74 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.10 | 69.37 | 2.88 | 220.48 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.92 | 57.62 | 2.75 | 438.14 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.09 | 100.81 | 2.29 | 402.93 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.46 | 92.66 | 3.26 | 452.00 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.00 | 51.51 | 3.96 | 13.23 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.89 | 39.01 | 3.95 | 1.87 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.80 | 87.06 | 3.66 | 32.99 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.20 | 70.81 | 4.12 | 16.28 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.69 | 102.89 | 3.35 | 40.96 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.71 | 99.31 | 4.19 | 68.60 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.38 | 27.18 | 3.68 | 65.53 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.04 | 22.58 | 3.21 | 63.46 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.80 | 73.85 | 2.66 | 96.29 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.32 | 61.99 | 3.21 | 139.06 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.26 | 664.23 | 1.83 | 166.51 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.66 | 130.89 | 3.48 | 220.85 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.78 | 33.99 | 2.47 | 370.85 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.44 | 33.92 | 2.35 | 328.89 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 44.97 | 78.22 | 1.74 | 609.06 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.59 | 73.43 | 1.77 | 1217.12 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.63 | 136.94 | 1.49 | 805.55 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 70.65 | 162.24 | 2.30 | 1452.91 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.79 | 38.62 | 2.45 | 426.04 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.72 | 40.24 | 2.41 | 370.60 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.04 | 91.90 | 1.70 | 752.51 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.38 | 88.90 | 1.73 | 1484.93 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.80 | 166.26 | 1.42 | 1005.32 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 88.49 | 201.33 | 2.28 | 1801.39 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.43 | 18.61 | 2.89 | 142.49 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.98 | 11.03 | 2.22 | 123.20 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.26 | 36.17 | 2.54 | 220.42 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.37 | 29.58 | 2.39 | 312.21 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.42 | 120.86 | 2.00 | 376.20 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.10 | 130.09 | 3.02 | 640.21 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.92 | 33.49 | 2.59 | 346.32 |
| canterbury/sum | 38240 | 1 | stdx | 12.57 | 29.36 | 2.34 | 299.34 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.60 | 69.87 | 2.44 | 498.26 |
| canterbury/sum | 38240 | 6 | stdx | 26.71 | 65.74 | 2.46 | 659.72 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.09 | 181.91 | 1.93 | 600.91 |
| canterbury/sum | 38240 | 9 | stdx | 39.30 | 112.33 | 2.86 | 659.77 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.29 | 53.06 | 3.99 | 20.21 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.67 | 43.10 | 4.04 | 3.40 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.78 | 87.70 | 3.85 | 64.22 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 17.92 | 74.35 | 4.15 | 38.67 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 24.98 | 94.34 | 3.78 | 98.89 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.22 | 106.96 | 4.08 | 127.63 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.05 | 40.47 | 3.36 | 163.03 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.75 | 42.29 | 3.32 | 101.91 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.24 | 395.99 | 2.16 | 263.94 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.93 | 374.12 | 3.04 | 1908.32 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.33 | 1063.49 | 1.30 | 1310.16 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 228.26 | 755.68 | 3.31 | 2420.70 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.54 | 32.38 | 2.58 | 312.68 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.42 | 32.23 | 2.40 | 281.27 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.08 | 80.12 | 1.74 | 525.60 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.24 | 72.39 | 1.71 | 1258.55 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.56 | 200.28 | 1.41 | 741.99 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.07 | 170.21 | 2.24 | 1439.20 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.32 | 29.72 | 2.23 | 414.93 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.24 | 28.55 | 2.00 | 379.08 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.16 | 60.25 | 1.82 | 563.40 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.03 | 56.80 | 1.77 | 982.76 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.55 | 119.11 | 1.48 | 684.60 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 51.87 | 117.95 | 2.27 | 1145.93 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.43 | 103.92 | 2.93 | 457.24 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.32 | 58.63 | 2.75 | 366.87 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.18 | 138.33 | 3.00 | 564.63 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 31.92 | 94.31 | 2.95 | 528.34 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.99 | 142.44 | 2.97 | 588.51 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 35.99 | 112.13 | 3.12 | 538.56 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.47 | 27.96 | 2.67 | 268.21 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.00 | 20.25 | 2.25 | 234.08 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.34 | 52.09 | 2.33 | 397.11 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.87 | 42.86 | 2.27 | 540.08 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 34.93 | 72.54 | 2.08 | 464.47 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.79 | 69.05 | 2.79 | 552.26 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.78 | 23.03 | 2.62 | 225.95 |
| http/html-1m | 1048576 | 1 | stdx | 8.16 | 17.79 | 2.18 | 206.37 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.25 | 49.53 | 1.96 | 328.86 |
| http/html-1m | 1048576 | 6 | stdx | 21.16 | 40.71 | 1.92 | 619.54 |
| http/html-1m | 1048576 | 9 | libdeflate | 70.92 | 109.24 | 1.54 | 430.48 |
| http/html-1m | 1048576 | 9 | stdx | 35.73 | 85.76 | 2.40 | 707.12 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.75 | 94.80 | 2.99 | 301.35 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.48 | 45.16 | 2.74 | 243.07 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.00 | 126.60 | 2.94 | 373.62 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.14 | 78.37 | 2.89 | 379.80 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.43 | 142.45 | 2.72 | 432.92 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.73 | 95.56 | 3.11 | 385.56 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.86 | 23.85 | 3.03 | 135.57 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.43 | 13.94 | 2.57 | 110.35 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.16 | 46.61 | 2.57 | 206.46 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.46 | 35.01 | 2.60 | 281.30 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.11 | 151.99 | 1.90 | 297.10 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.19 | 58.45 | 3.05 | 303.96 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.75 | 19.85 | 2.94 | 125.40 |
| http/json-1m | 1048576 | 1 | stdx | 5.06 | 12.51 | 2.47 | 102.95 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.28 | 45.30 | 2.23 | 175.60 |
| http/json-1m | 1048576 | 6 | stdx | 14.68 | 35.09 | 2.39 | 297.01 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.48 | 205.21 | 1.69 | 276.14 |
| http/json-1m | 1048576 | 9 | stdx | 29.10 | 72.87 | 2.50 | 369.21 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.06 | 107.80 | 2.91 | 517.73 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.73 | 65.40 | 2.76 | 414.09 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.39 | 144.85 | 2.93 | 679.39 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 35.68 | 104.12 | 2.92 | 620.78 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 52.01 | 150.13 | 2.89 | 713.30 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 40.35 | 125.13 | 3.10 | 626.82 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.74 | 30.90 | 2.63 | 310.12 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.83 | 24.80 | 2.29 | 273.23 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.88 | 59.43 | 2.30 | 473.13 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.73 | 50.05 | 2.20 | 675.11 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.83 | 83.31 | 2.04 | 565.05 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.60 | 81.30 | 2.75 | 664.13 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.66 | 25.19 | 2.61 | 248.53 |
| http/js-1m | 1048576 | 1 | stdx | 9.54 | 21.31 | 2.23 | 233.01 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.73 | 56.12 | 1.95 | 371.16 |
| http/js-1m | 1048576 | 6 | stdx | 24.87 | 46.64 | 1.88 | 742.28 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.29 | 120.65 | 1.58 | 499.10 |
| http/js-1m | 1048576 | 9 | stdx | 42.02 | 100.01 | 2.38 | 812.47 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.22 | 97.73 | 2.94 | 378.65 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.47 | 49.52 | 2.68 | 301.84 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.86 | 129.22 | 2.95 | 476.55 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.22 | 82.32 | 2.82 | 503.75 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 46.10 | 133.80 | 2.90 | 508.59 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.22 | 99.48 | 2.99 | 521.70 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.65 | 25.60 | 2.96 | 175.03 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.67 | 16.96 | 2.54 | 135.50 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.22 | 48.80 | 2.41 | 291.71 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.41 | 38.00 | 2.32 | 457.67 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.80 | 82.40 | 2.02 | 372.04 |
| http/css-16kx64 | 1048576 | 9 | stdx | 22.98 | 65.13 | 2.83 | 481.39 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.95 | 21.15 | 3.04 | 133.22 |
| http/css-1m | 1048576 | 1 | stdx | 5.77 | 14.91 | 2.58 | 108.06 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.74 | 44.50 | 2.15 | 226.33 |
| http/css-1m | 1048576 | 6 | stdx | 16.60 | 35.61 | 2.14 | 443.54 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.69 | 111.58 | 1.60 | 308.13 |
| http/css-1m | 1048576 | 9 | stdx | 32.10 | 83.00 | 2.59 | 512.97 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.19 | 48.89 | 1.94 | 928.34 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.11 | 49.19 | 2.72 | 322.96 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.52 | 86.45 | 2.08 | 1181.30 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.82 | 88.80 | 2.23 | 859.60 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 46.94 | 94.50 | 2.01 | 1344.12 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.00 | 134.38 | 2.49 | 1136.18 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.13 | 31.22 | 3.08 | 121.18 |
| silesia/dickens | 10192446 | 1 | stdx | 24.25 | 82.03 | 3.38 | 125.35 |
| silesia/dickens | 10192446 | 3 | libzstd | 21.63 | 34.39 | 1.59 | 169.98 |
| silesia/dickens | 10192446 | 3 | stdx | 34.56 | 78.22 | 2.26 | 182.02 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.00 | 22.69 | 3.24 | 70.74 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.56 | 54.73 | 3.12 | 173.60 |
| silesia/mozilla | 51220480 | 3 | libzstd | 15.95 | 27.89 | 1.75 | 102.42 |
| silesia/mozilla | 51220480 | 3 | stdx | 29.50 | 62.01 | 2.10 | 144.93 |
| silesia/mr | 9970564 | 1 | libzstd | 7.66 | 24.81 | 3.24 | 57.21 |
| silesia/mr | 9970564 | 1 | stdx | 19.82 | 66.82 | 3.37 | 113.82 |
| silesia/mr | 9970564 | 3 | libzstd | 18.86 | 32.19 | 1.71 | 86.46 |
| silesia/mr | 9970564 | 3 | stdx | 32.42 | 72.46 | 2.24 | 115.05 |
| silesia/nci | 33553445 | 1 | libzstd | 3.52 | 9.55 | 2.71 | 57.72 |
| silesia/nci | 33553445 | 1 | stdx | 7.68 | 25.69 | 3.35 | 58.69 |
| silesia/nci | 33553445 | 3 | libzstd | 5.27 | 9.95 | 1.89 | 56.31 |
| silesia/nci | 33553445 | 3 | stdx | 11.06 | 29.15 | 2.64 | 66.00 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.58 | 29.26 | 3.41 | 71.03 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.15 | 72.51 | 3.13 | 179.98 |
| silesia/ooffice | 6152192 | 3 | libzstd | 22.28 | 39.44 | 1.77 | 119.98 |
| silesia/ooffice | 6152192 | 3 | stdx | 40.36 | 82.20 | 2.04 | 185.03 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.06 | 22.29 | 3.15 | 66.89 |
| silesia/osdb | 10085684 | 1 | stdx | 16.28 | 50.52 | 3.10 | 119.60 |
| silesia/osdb | 10085684 | 3 | libzstd | 16.86 | 26.23 | 1.56 | 67.73 |
| silesia/osdb | 10085684 | 3 | stdx | 30.58 | 57.87 | 1.89 | 110.88 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.70 | 27.13 | 2.80 | 150.48 |
| silesia/reymont | 6627202 | 1 | stdx | 20.15 | 72.05 | 3.58 | 96.49 |
| silesia/reymont | 6627202 | 3 | libzstd | 17.55 | 27.10 | 1.54 | 126.22 |
| silesia/reymont | 6627202 | 3 | stdx | 27.48 | 62.18 | 2.26 | 146.98 |
| silesia/samba | 21606400 | 1 | libzstd | 5.94 | 16.88 | 2.84 | 85.82 |
| silesia/samba | 21606400 | 1 | stdx | 13.47 | 42.89 | 3.18 | 124.74 |
| silesia/samba | 21606400 | 3 | libzstd | 11.44 | 18.81 | 1.65 | 99.03 |
| silesia/samba | 21606400 | 3 | stdx | 19.82 | 44.75 | 2.26 | 132.65 |
| silesia/sao | 7251944 | 1 | libzstd | 9.06 | 33.69 | 3.72 | 44.85 |
| silesia/sao | 7251944 | 1 | stdx | 25.92 | 82.03 | 3.17 | 103.69 |
| silesia/sao | 7251944 | 3 | libzstd | 29.21 | 50.03 | 1.71 | 94.82 |
| silesia/sao | 7251944 | 3 | stdx | 49.29 | 95.22 | 1.93 | 142.58 |
| silesia/webster | 41458703 | 1 | libzstd | 8.65 | 24.94 | 2.88 | 130.90 |
| silesia/webster | 41458703 | 1 | stdx | 20.31 | 64.04 | 3.15 | 165.98 |
| silesia/webster | 41458703 | 3 | libzstd | 18.22 | 27.33 | 1.50 | 176.15 |
| silesia/webster | 41458703 | 3 | stdx | 29.88 | 64.55 | 2.16 | 194.02 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.70 | 14.92 | 3.17 | 17.38 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.76 | 76.64 | 3.23 | 91.82 |
| silesia/x-ray | 8474240 | 3 | libzstd | 29.67 | 52.73 | 1.78 | 88.10 |
| silesia/x-ray | 8474240 | 3 | stdx | 45.70 | 92.40 | 2.02 | 108.13 |
| silesia/xml | 5345280 | 1 | libzstd | 4.23 | 11.71 | 2.77 | 71.70 |
| silesia/xml | 5345280 | 1 | stdx | 10.35 | 34.21 | 3.31 | 93.65 |
| silesia/xml | 5345280 | 3 | libzstd | 6.55 | 12.61 | 1.93 | 77.60 |
| silesia/xml | 5345280 | 3 | stdx | 12.54 | 32.28 | 2.57 | 115.37 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.78 | 32.84 | 3.05 | 139.34 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.39 | 76.49 | 3.42 | 188.97 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.43 | 39.48 | 2.56 | 203.07 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.06 | 73.76 | 2.83 | 334.32 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.77 | 33.55 | 3.43 | 105.62 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.50 | 79.00 | 3.36 | 213.84 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.26 | 39.27 | 2.57 | 211.53 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 27.91 | 79.30 | 2.84 | 374.17 |
| canterbury/cp.html | 24603 | 1 | libzstd | 6.88 | 26.64 | 3.87 | 35.32 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.04 | 57.76 | 3.60 | 118.09 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.50 | 31.85 | 3.35 | 47.90 |
| canterbury/cp.html | 24603 | 3 | stdx | 17.89 | 59.76 | 3.34 | 135.29 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.57 | 31.76 | 3.71 | 34.90 |
| canterbury/fields.c | 11150 | 1 | stdx | 16.93 | 65.73 | 3.88 | 84.60 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.62 | 34.13 | 3.55 | 45.12 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.25 | 64.68 | 3.75 | 88.15 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.42 | 38.01 | 4.04 | 7.90 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.16 | 77.57 | 3.85 | 49.79 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.76 | 43.09 | 4.00 | 11.52 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.43 | 79.60 | 3.71 | 68.39 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.03 | 23.56 | 3.90 | 14.96 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.67 | 56.75 | 3.87 | 83.67 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.22 | 23.80 | 2.90 | 27.63 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 20.11 | 56.61 | 2.82 | 110.00 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.83 | 28.52 | 2.90 | 156.29 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.35 | 72.02 | 3.37 | 159.24 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 15.90 | 32.14 | 2.02 | 201.97 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.02 | 67.10 | 2.58 | 295.55 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.32 | 32.37 | 3.14 | 128.18 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 24.99 | 84.16 | 3.37 | 157.39 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 19.46 | 38.77 | 1.99 | 224.32 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 31.26 | 80.77 | 2.58 | 342.49 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.17 | 8.51 | 2.68 | 66.99 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.45 | 23.15 | 3.11 | 103.79 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 4.69 | 10.97 | 2.34 | 58.87 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.33 | 24.08 | 2.58 | 132.65 |
| canterbury/sum | 38240 | 1 | libzstd | 6.49 | 25.39 | 3.91 | 29.55 |
| canterbury/sum | 38240 | 1 | stdx | 16.85 | 59.13 | 3.51 | 148.04 |
| canterbury/sum | 38240 | 3 | libzstd | 8.99 | 30.67 | 3.41 | 44.70 |
| canterbury/sum | 38240 | 3 | stdx | 19.78 | 61.82 | 3.13 | 178.96 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 9.94 | 39.82 | 4.00 | 10.72 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.86 | 80.38 | 3.85 | 59.83 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.26 | 48.17 | 3.93 | 17.42 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.87 | 83.98 | 3.67 | 79.88 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.33 | 33.44 | 3.24 | 76.53 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.86 | 95.62 | 4.37 | 7.28 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 14.84 | 31.30 | 2.11 | 35.89 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.50 | 70.38 | 2.99 | 38.69 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.73 | 27.45 | 2.82 | 149.26 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.39 | 71.86 | 3.52 | 108.05 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 17.53 | 28.20 | 1.61 | 132.27 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 27.43 | 63.36 | 2.31 | 155.42 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.14 | 22.70 | 2.79 | 136.84 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.62 | 55.86 | 3.00 | 193.25 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 14.89 | 23.87 | 1.60 | 173.24 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 24.44 | 51.26 | 2.10 | 237.16 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.13 | 52.46 | 3.06 | 159.84 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.88 | 100.54 | 2.80 | 638.21 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.06 | 59.20 | 3.11 | 197.27 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 37.98 | 104.00 | 2.74 | 636.55 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.70 | 22.46 | 2.92 | 122.42 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.15 | 46.84 | 3.31 | 182.20 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.77 | 24.61 | 2.81 | 141.66 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.28 | 47.61 | 3.12 | 191.78 |
| http/html-1m | 1048576 | 1 | libzstd | 6.25 | 16.74 | 2.68 | 115.13 |
| http/html-1m | 1048576 | 1 | stdx | 12.90 | 42.00 | 3.26 | 135.08 |
| http/html-1m | 1048576 | 3 | libzstd | 9.11 | 18.18 | 2.00 | 125.54 |
| http/html-1m | 1048576 | 3 | stdx | 15.59 | 39.37 | 2.53 | 177.41 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.39 | 42.52 | 2.95 | 116.25 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.64 | 83.13 | 2.80 | 529.36 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.85 | 44.54 | 3.00 | 130.18 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.69 | 84.87 | 2.77 | 534.02 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.79 | 14.98 | 3.13 | 57.44 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.70 | 33.78 | 3.48 | 116.32 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.34 | 16.21 | 3.03 | 72.47 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.58 | 34.58 | 3.27 | 122.75 |
| http/json-1m | 1048576 | 1 | libzstd | 4.07 | 12.55 | 3.09 | 53.63 |
| http/json-1m | 1048576 | 1 | stdx | 8.98 | 30.70 | 3.42 | 85.14 |
| http/json-1m | 1048576 | 3 | libzstd | 5.99 | 13.78 | 2.30 | 68.76 |
| http/json-1m | 1048576 | 3 | stdx | 11.23 | 30.64 | 2.73 | 119.55 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.62 | 57.26 | 3.08 | 184.53 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 39.91 | 113.49 | 2.84 | 690.11 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.44 | 65.54 | 3.06 | 260.91 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.03 | 116.54 | 2.77 | 682.70 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.83 | 26.52 | 3.00 | 127.83 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.62 | 55.71 | 3.35 | 200.39 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.05 | 28.74 | 2.86 | 154.10 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.53 | 55.35 | 3.16 | 209.10 |
| http/js-1m | 1048576 | 1 | libzstd | 6.54 | 17.87 | 2.73 | 113.61 |
| http/js-1m | 1048576 | 1 | stdx | 13.92 | 45.88 | 3.30 | 135.26 |
| http/js-1m | 1048576 | 3 | libzstd | 9.66 | 19.14 | 1.98 | 124.62 |
| http/js-1m | 1048576 | 3 | stdx | 16.65 | 41.25 | 2.48 | 186.73 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.60 | 46.90 | 3.01 | 136.59 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.26 | 91.65 | 2.84 | 578.35 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.66 | 50.53 | 3.03 | 160.54 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.66 | 93.63 | 2.78 | 582.40 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.11 | 18.99 | 3.11 | 78.40 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.43 | 43.79 | 3.52 | 136.99 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.55 | 19.41 | 2.96 | 95.26 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.87 | 42.34 | 3.29 | 152.21 |
| http/css-1m | 1048576 | 1 | libzstd | 1.49 | 4.59 | 3.07 | 21.72 |
| http/css-1m | 1048576 | 1 | stdx | 3.98 | 14.85 | 3.73 | 30.53 |
| http/css-1m | 1048576 | 3 | libzstd | 1.93 | 5.25 | 2.72 | 19.66 |
| http/css-1m | 1048576 | 3 | stdx | 3.90 | 13.33 | 3.42 | 31.49 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.52 | 12.79 | 3.64 | 6.25 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.05 | 30.66 | 3.39 | 61.81 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 26.65 | 50.53 | 1.90 | 49.85 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 20.59 | 47.43 | 2.30 | 206.98 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.120 | 3.00 | 2.93 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 66.4 | 219.6 | 0.082 | 7.84 | 3.31 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 30.7 | 96.1 | 0.164 | 3.62 | 3.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 248.5 | 1024.0 | 0.838 | 29.36 | 4.12 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 31.0 | 107.7 | 0.135 | 3.67 | 3.47 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.1 | 106.2 | 0.296 | 3.32 | 3.78 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.7 | 378.2 | 0.365 | 11.30 | 3.95 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 43.1 | 161.9 | 0.473 | 5.09 | 3.76 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 91.7 | 451.7 | 0.302 | 10.83 | 4.93 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.0 | 89.5 | 0.004 | 3.98 | 3.31 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.6 | 234.7 | 0.044 | 10.10 | 3.42 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 29.3 | 99.4 | 0.013 | 4.32 | 3.39 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 216.5 | 819.1 | 0.940 | 31.86 | 3.78 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.3 | 107.7 | 0.040 | 4.16 | 3.81 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 30.4 | 106.0 | 0.048 | 4.48 | 3.48 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 94.9 | 346.2 | 0.313 | 13.96 | 3.65 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 32.2 | 144.5 | 0.052 | 4.73 | 4.49 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 93.1 | 406.5 | 0.076 | 13.71 | 4.36 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114807.9 | 403846.2 | 511.845 | 0.67 | 3.52 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 591066.6 | 2503286.2 | 1391.536 | 3.43 | 4.24 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 114580.7 | 404249.2 | 495.505 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3569239.4 | 18223876.2 | 2976.608 | 20.69 | 5.11 |
| string: silesia/dickens | 1 | 172528 | simdjson | 312059.8 | 621744.2 | 641.062 | 1.81 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 224495.0 | 826630.2 | 2166.165 | 1.30 | 3.68 |
| string: silesia/dickens | 1 | 172528 | std.json | 1571168.3 | 4578768.2 | 42342.443 | 9.11 | 2.91 |
| string: silesia/dickens | 1 | 172528 | serde_json | 202825.2 | 802391.2 | 988.041 | 1.18 | 3.96 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1046480.6 | 5282061.2 | 4935.258 | 6.07 | 5.05 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1561636.3 | 4799763.6 | 1275.357 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14452092.8 | 56816152.6 | 39267.429 | 12.14 | 3.93 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1558552.3 | 4799955.6 | 1113.786 | 1.31 | 3.08 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 28991715.4 | 132108253.6 | 159475.571 | 24.36 | 4.56 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4593463.0 | 7062781.6 | 605.929 | 3.86 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1806427.1 | 7322029.6 | 13997.714 | 1.52 | 4.05 |
| string: http/json-1m | 1 | 1190272 | std.json | 10309461.1 | 47381213.6 | 30788.000 | 8.66 | 4.60 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3920978.1 | 15226459.6 | 6285.571 | 3.29 | 3.88 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 8988551.1 | 47989076.2 | 27719.857 | 7.55 | 5.34 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2065475.3 | 5765413.8 | 4369.125 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6175620.5 | 22589263.8 | 6937.625 | 3.28 | 3.66 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2058179.0 | 5765605.8 | 3867.750 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47493789.5 | 227842320.8 | 282492.875 | 25.22 | 4.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3777370.3 | 8446023.8 | 2195.250 | 2.01 | 2.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7133954.9 | 12276717.8 | 275496.875 | 3.79 | 1.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17463558.0 | 63617055.8 | 267755.625 | 9.27 | 3.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9443776.5 | 24440755.8 | 326241.625 | 5.02 | 2.59 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39422451.6 | 160312739.9 | 800648.250 | 20.94 | 4.07 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12960189.3 | 42561069.3 | 244929.000 | 2.55 | 3.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 173757340.3 | 667246747.3 | 391614.000 | 34.23 | 3.84 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12950637.3 | 42561261.3 | 243794.333 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 152041208.0 | 639992662.3 | 426852.667 | 29.96 | 4.21 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17588232.3 | 49745820.3 | 254728.333 | 3.47 | 2.83 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14361227.3 | 45615166.3 | 437239.000 | 2.83 | 3.18 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 80126486.0 | 314900845.3 | 459720.000 | 15.79 | 3.93 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36517458.0 | 131556135.3 | 606153.667 | 7.19 | 3.60 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66498431.0 | 273932374.7 | 836524.000 | 13.10 | 4.12 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 92536.4 | 303836.7 | 9.097 | 0.18 | 3.28 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 186638.1 | 623465.7 | 8.742 | 0.36 | 3.34 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 147930.6 | 557622.7 | 7.806 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10207159.8 | 53478202.7 | 6.806 | 19.47 | 5.24 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 488903.1 | 1376733.7 | 5.452 | 0.93 | 2.82 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 538076.9 | 2195917.7 | 7.194 | 1.03 | 4.08 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3495213.9 | 12808414.7 | 61268.387 | 6.67 | 3.66 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 289280.1 | 1179969.7 | 6.968 | 0.55 | 4.08 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2247794.6 | 12788062.7 | 266.323 | 4.29 | 5.69 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.8 | 81.8 | 0.107 | 2.33 | 4.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.1 | 153.6 | 0.127 | 4.15 | 4.37 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 23.2 | 103.2 | 0.098 | 2.74 | 4.45 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 218.3 | 981.0 | 0.923 | 25.79 | 4.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 19.1 | 79.5 | 0.106 | 2.26 | 4.15 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.2 | 94.1 | 0.136 | 2.74 | 4.06 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.4 | 105.6 | 0.247 | 3.24 | 3.85 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.6 | 310.8 | 0.383 | 8.23 | 4.46 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.3 | 255.3 | 0.509 | 7.48 | 4.03 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.5 | 315.1 | 0.234 | 8.09 | 4.60 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.7 | 82.8 | 0.024 | 2.76 | 4.42 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.0 | 153.9 | 0.025 | 5.30 | 4.27 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 22.9 | 101.7 | 0.024 | 3.37 | 4.45 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 170.8 | 718.3 | 1.265 | 25.14 | 4.21 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.3 | 81.5 | 0.024 | 2.69 | 4.45 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.7 | 96.8 | 0.032 | 3.20 | 4.45 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.3 | 117.9 | 0.033 | 4.31 | 4.03 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 61.7 | 271.2 | 0.275 | 9.08 | 4.40 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 48.5 | 211.7 | 0.039 | 7.14 | 4.36 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 82.9 | 331.7 | 0.088 | 12.20 | 4.00 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 85049.1 | 280786.2 | 726.361 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84889.1 | 280732.2 | 721.371 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84660.1 | 280724.2 | 715.196 | 0.49 | 3.32 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3401828.6 | 16047574.2 | 2957.918 | 19.72 | 4.72 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 84057.7 | 274401.2 | 696.175 | 0.49 | 3.26 |
| string: silesia/dickens | 1 | 172528 | simdjson | 208940.5 | 674016.2 | 2105.567 | 1.21 | 3.23 |
| string: silesia/dickens | 1 | 172528 | yyjson | 204020.4 | 825518.2 | 1006.773 | 1.18 | 4.05 |
| string: silesia/dickens | 1 | 172528 | std.json | 1376477.0 | 2890892.2 | 55368.031 | 7.98 | 2.10 |
| string: silesia/dickens | 1 | 172528 | serde_json | 366648.9 | 1586249.2 | 2260.701 | 2.13 | 4.33 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 576877.7 | 2970289.5 | 2335.237 | 3.34 | 5.15 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1252789.6 | 3582350.6 | 10825.286 | 1.05 | 2.86 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1239859.1 | 3582290.6 | 10343.143 | 1.04 | 2.89 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1238314.4 | 3582278.6 | 10235.214 | 1.04 | 2.89 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25332506.2 | 109856348.6 | 142192.357 | 21.28 | 4.34 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1222367.7 | 3370022.6 | 11020.214 | 1.03 | 2.76 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2968299.3 | 10460762.6 | 29264.357 | 2.49 | 3.52 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2585188.9 | 10197931.6 | 9575.929 | 2.17 | 3.94 |
| string: http/json-1m | 1 | 1190272 | std.json | 8933924.7 | 43287986.6 | 17050.500 | 7.51 | 4.85 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3767598.8 | 17941088.6 | 10734.143 | 3.17 | 4.76 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5226150.2 | 26999670.9 | 11067.071 | 4.39 | 5.17 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2082839.0 | 6088099.8 | 4712.250 | 1.11 | 2.92 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2063379.6 | 6088039.8 | 4201.500 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2062176.8 | 6088027.8 | 4121.000 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43561154.5 | 193466548.8 | 264445.000 | 23.13 | 4.44 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2073648.0 | 5875346.8 | 4865.250 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2718368.5 | 7144143.8 | 21198.625 | 1.44 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12428675.1 | 23590602.8 | 461382.250 | 6.60 | 1.90 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20154631.9 | 56837736.8 | 537721.500 | 10.70 | 2.82 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11732901.3 | 33662338.8 | 331700.750 | 6.23 | 2.87 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18868556.9 | 76319380.8 | 252615.375 | 10.02 | 4.04 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 112901.5 | 426376.7 | 2.903 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 112716.9 | 426318.7 | 2.452 | 0.21 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 112700.8 | 426299.7 | 2.226 | 0.21 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 637877.0 | 3146479.7 | 6.516 | 1.22 | 4.93 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 112679.2 | 426343.7 | 2.226 | 0.21 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1197639.8 | 3866916.7 | 5.839 | 2.28 | 3.23 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1623461.8 | 5833341.7 | 6.677 | 3.10 | 3.59 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3500531.3 | 13108830.7 | 71829.968 | 6.68 | 3.74 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1776428.2 | 7405810.7 | 3.548 | 3.39 | 4.17 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2389986.1 | 12748343.6 | 16.516 | 4.56 | 5.33 |
