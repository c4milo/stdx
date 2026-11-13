# bench-profile

| Field | Value |
|---|---|
| Commit | fc185bf |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261101.172.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43301240988 |
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
| silesia/dickens | 10192446 | zlib | 8.83 | 19.08 | 2.16 | 309.25 |
| silesia/dickens | 10192446 | zlib-ng | 4.91 | 10.50 | 2.14 | 67.61 |
| silesia/dickens | 10192446 | libdeflate | 3.54 | 9.56 | 2.70 | 66.78 |
| silesia/dickens | 10192446 | Wuffs | 5.57 | 13.90 | 2.50 | 97.60 |
| silesia/dickens | 10192446 | stdx | 3.09 | 7.15 | 2.31 | 75.76 |
| silesia/mozilla | 51220480 | zlib | 8.50 | 17.23 | 2.03 | 250.76 |
| silesia/mozilla | 51220480 | zlib-ng | 4.97 | 8.95 | 1.80 | 86.02 |
| silesia/mozilla | 51220480 | libdeflate | 3.50 | 7.63 | 2.18 | 71.19 |
| silesia/mozilla | 51220480 | Wuffs | 6.41 | 13.89 | 2.17 | 133.00 |
| silesia/mozilla | 51220480 | stdx | 3.66 | 6.29 | 1.72 | 89.24 |
| silesia/mr | 9970564 | zlib | 8.47 | 18.46 | 2.18 | 201.35 |
| silesia/mr | 9970564 | zlib-ng | 4.85 | 9.98 | 2.06 | 68.21 |
| silesia/mr | 9970564 | libdeflate | 3.41 | 8.58 | 2.52 | 61.06 |
| silesia/mr | 9970564 | Wuffs | 6.04 | 14.04 | 2.32 | 100.07 |
| silesia/mr | 9970564 | stdx | 3.21 | 6.70 | 2.08 | 69.56 |
| silesia/nci | 33553445 | zlib | 3.65 | 10.18 | 2.78 | 81.62 |
| silesia/nci | 33553445 | zlib-ng | 1.72 | 3.13 | 1.82 | 35.34 |
| silesia/nci | 33553445 | libdeflate | 1.27 | 2.66 | 2.09 | 29.73 |
| silesia/nci | 33553445 | Wuffs | 2.51 | 6.47 | 2.57 | 41.19 |
| silesia/nci | 33553445 | stdx | 1.37 | 2.20 | 1.60 | 36.99 |
| silesia/ooffice | 6152192 | zlib | 11.77 | 21.06 | 1.79 | 413.77 |
| silesia/ooffice | 6152192 | zlib-ng | 6.97 | 12.04 | 1.73 | 141.31 |
| silesia/ooffice | 6152192 | libdeflate | 4.93 | 10.45 | 2.12 | 125.36 |
| silesia/ooffice | 6152192 | Wuffs | 8.83 | 17.54 | 1.99 | 220.14 |
| silesia/ooffice | 6152192 | stdx | 5.20 | 8.55 | 1.64 | 150.77 |
| silesia/osdb | 10085684 | zlib | 7.56 | 16.59 | 2.20 | 182.15 |
| silesia/osdb | 10085684 | zlib-ng | 4.36 | 8.38 | 1.92 | 54.79 |
| silesia/osdb | 10085684 | libdeflate | 2.88 | 6.91 | 2.40 | 29.83 |
| silesia/osdb | 10085684 | Wuffs | 5.83 | 13.61 | 2.33 | 80.36 |
| silesia/osdb | 10085684 | stdx | 2.91 | 5.65 | 1.94 | 40.31 |
| silesia/reymont | 6627202 | zlib | 7.41 | 15.89 | 2.14 | 259.16 |
| silesia/reymont | 6627202 | zlib-ng | 3.75 | 7.72 | 2.06 | 60.07 |
| silesia/reymont | 6627202 | libdeflate | 2.65 | 6.91 | 2.61 | 51.31 |
| silesia/reymont | 6627202 | Wuffs | 4.89 | 11.40 | 2.33 | 112.38 |
| silesia/reymont | 6627202 | stdx | 2.37 | 5.11 | 2.16 | 64.47 |
| silesia/samba | 21606400 | zlib | 6.19 | 14.13 | 2.28 | 174.88 |
| silesia/samba | 21606400 | zlib-ng | 3.43 | 6.47 | 1.89 | 58.19 |
| silesia/samba | 21606400 | libdeflate | 2.40 | 5.58 | 2.32 | 42.87 |
| silesia/samba | 21606400 | Wuffs | 4.35 | 10.39 | 2.39 | 79.83 |
| silesia/samba | 21606400 | stdx | 2.41 | 4.46 | 1.85 | 56.15 |
| silesia/sao | 7251944 | zlib | 10.55 | 23.54 | 2.23 | 206.94 |
| silesia/sao | 7251944 | zlib-ng | 7.89 | 14.83 | 1.88 | 79.09 |
| silesia/sao | 7251944 | libdeflate | 5.78 | 12.73 | 2.20 | 79.09 |
| silesia/sao | 7251944 | Wuffs | 8.93 | 21.26 | 2.38 | 86.24 |
| silesia/sao | 7251944 | stdx | 5.71 | 10.32 | 1.81 | 87.30 |
| silesia/webster | 41458703 | zlib | 7.82 | 16.16 | 2.07 | 282.10 |
| silesia/webster | 41458703 | zlib-ng | 4.24 | 8.04 | 1.90 | 85.09 |
| silesia/webster | 41458703 | libdeflate | 2.95 | 7.17 | 2.43 | 68.53 |
| silesia/webster | 41458703 | Wuffs | 5.14 | 11.67 | 2.27 | 122.00 |
| silesia/webster | 41458703 | stdx | 2.87 | 5.56 | 1.94 | 86.73 |
| silesia/x-ray | 8474240 | zlib | 12.88 | 27.21 | 2.11 | 328.06 |
| silesia/x-ray | 8474240 | zlib-ng | 9.07 | 17.39 | 1.92 | 124.12 |
| silesia/x-ray | 8474240 | libdeflate | 6.58 | 15.26 | 2.32 | 124.78 |
| silesia/x-ray | 8474240 | Wuffs | 10.83 | 23.52 | 2.17 | 191.18 |
| silesia/x-ray | 8474240 | stdx | 6.23 | 11.49 | 1.84 | 138.38 |
| silesia/xml | 5345280 | zlib | 4.23 | 11.16 | 2.64 | 117.63 |
| silesia/xml | 5345280 | zlib-ng | 2.01 | 3.88 | 1.94 | 42.87 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 31.86 |
| silesia/xml | 5345280 | Wuffs | 2.84 | 7.22 | 2.54 | 59.12 |
| silesia/xml | 5345280 | stdx | 1.34 | 2.65 | 1.98 | 41.78 |
| canterbury/alice29.txt | 152089 | zlib | 8.42 | 18.35 | 2.18 | 294.42 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.23 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.17 | 8.96 | 2.83 | 54.14 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.37 | 13.40 | 2.50 | 97.99 |
| canterbury/alice29.txt | 152089 | stdx | 2.70 | 6.99 | 2.59 | 61.87 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.01 | 19.42 | 2.16 | 313.72 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.10 | 10.86 | 2.13 | 73.97 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.62 | 9.82 | 2.71 | 70.38 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.76 | 14.40 | 2.50 | 99.36 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.08 | 7.52 | 2.44 | 78.48 |
| canterbury/cp.html | 24603 | zlib | 7.07 | 17.33 | 2.45 | 172.71 |
| canterbury/cp.html | 24603 | zlib-ng | 4.31 | 9.50 | 2.20 | 46.93 |
| canterbury/cp.html | 24603 | libdeflate | 2.85 | 7.95 | 2.79 | 16.53 |
| canterbury/cp.html | 24603 | Wuffs | 5.22 | 13.91 | 2.67 | 60.44 |
| canterbury/cp.html | 24603 | stdx | 2.73 | 7.19 | 2.63 | 19.35 |
| canterbury/fields.c | 11150 | zlib | 5.23 | 17.73 | 3.39 | 37.98 |
| canterbury/fields.c | 11150 | zlib-ng | 4.02 | 10.20 | 2.54 | 24.51 |
| canterbury/fields.c | 11150 | libdeflate | 2.79 | 8.32 | 2.98 | 1.91 |
| canterbury/fields.c | 11150 | Wuffs | 4.53 | 14.54 | 3.21 | 10.54 |
| canterbury/fields.c | 11150 | stdx | 2.52 | 7.64 | 3.03 | 4.45 |
| canterbury/grammar.lsp | 3721 | zlib | 6.81 | 24.26 | 3.56 | 8.95 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.93 | 17.48 | 2.95 | 14.34 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.40 | 12.05 | 2.74 | 0.67 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.72 | 21.86 | 3.25 | 4.28 |
| canterbury/grammar.lsp | 3721 | stdx | 3.85 | 12.18 | 3.16 | 1.38 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.59 | 15.27 | 3.32 | 48.38 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.85 | 6.97 | 2.45 | 12.60 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.01 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.87 | 11.59 | 2.99 | 14.87 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.66 | 2.67 | 16.76 |
| canterbury/lcet10.txt | 426754 | zlib | 8.19 | 17.78 | 2.17 | 288.74 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.17 | 60.86 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.02 | 8.48 | 2.81 | 54.60 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.23 | 12.88 | 2.46 | 102.04 |
| canterbury/lcet10.txt | 426754 | stdx | 2.59 | 6.42 | 2.48 | 66.12 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.18 | 19.86 | 2.16 | 319.82 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.31 | 11.19 | 2.11 | 79.51 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.70 | 77.43 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.80 | 14.61 | 2.52 | 98.75 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 7.63 | 2.42 | 85.39 |
| canterbury/ptt5 | 513216 | zlib | 5.05 | 10.71 | 2.12 | 103.59 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.01 | 3.74 | 1.86 | 46.82 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.08 | 38.50 |
| canterbury/ptt5 | 513216 | Wuffs | 3.00 | 7.13 | 2.37 | 57.69 |
| canterbury/ptt5 | 513216 | stdx | 1.46 | 2.55 | 1.74 | 48.95 |
| canterbury/sum | 38240 | zlib | 8.04 | 18.12 | 2.25 | 227.67 |
| canterbury/sum | 38240 | zlib-ng | 4.69 | 10.02 | 2.14 | 60.74 |
| canterbury/sum | 38240 | libdeflate | 3.40 | 8.34 | 2.45 | 43.99 |
| canterbury/sum | 38240 | Wuffs | 5.86 | 14.47 | 2.47 | 84.72 |
| canterbury/sum | 38240 | stdx | 3.17 | 7.73 | 2.44 | 40.42 |
| canterbury/xargs.1 | 4227 | zlib | 7.34 | 25.22 | 3.43 | 16.27 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.47 | 17.97 | 2.77 | 16.96 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.76 | 13.27 | 2.79 | 0.90 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.22 | 22.63 | 3.14 | 10.78 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 12.86 | 3.03 | 2.53 |
| canterbury-large/E.coli | 4638690 | zlib | 6.79 | 17.84 | 2.63 | 178.00 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.25 | 9.68 | 2.28 | 47.82 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.04 | 8.86 | 2.91 | 48.76 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.66 | 12.73 | 2.73 | 61.61 |
| canterbury-large/E.coli | 4638690 | stdx | 2.50 | 6.72 | 2.69 | 53.93 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.53 | 16.46 | 2.19 | 265.65 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.79 | 8.26 | 2.18 | 53.45 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.84 | 45.46 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.79 | 11.73 | 2.45 | 100.22 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.25 | 5.57 | 2.48 | 55.78 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.70 | 15.84 | 2.06 | 278.86 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.51 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.25 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.17 | 11.48 | 2.22 | 127.85 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.73 | 5.40 | 1.97 | 90.65 |
| http/html-1kx1024 | 1048576 | zlib | 16.25 | 35.58 | 2.19 | 352.35 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.68 | 28.43 | 2.24 | 217.19 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.50 | 20.05 | 1.91 | 155.51 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.36 | 38.07 | 2.48 | 265.59 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 137.19 |
| http/html-16kx64 | 1048576 | zlib | 6.70 | 14.77 | 2.20 | 221.58 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.44 |
| http/html-16kx64 | 1048576 | libdeflate | 2.64 | 6.04 | 2.29 | 60.91 |
| http/html-16kx64 | 1048576 | Wuffs | 4.92 | 11.57 | 2.35 | 115.16 |
| http/html-16kx64 | 1048576 | stdx | 2.53 | 5.56 | 2.20 | 59.93 |
| http/html-1m | 1048576 | zlib | 5.30 | 12.53 | 2.36 | 175.13 |
| http/html-1m | 1048576 | zlib-ng | 2.64 | 5.03 | 1.91 | 60.71 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.58 | 37.43 |
| http/html-1m | 1048576 | Wuffs | 3.61 | 8.48 | 2.35 | 87.67 |
| http/html-1m | 1048576 | stdx | 1.65 | 3.46 | 2.10 | 52.65 |
| http/json-1kx1024 | 1048576 | zlib | 10.17 | 23.92 | 2.35 | 193.02 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.42 | 16.69 | 2.25 | 132.06 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.78 | 16.72 | 1.90 | 92.26 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.18 | 34.78 | 2.86 | 146.33 |
| http/json-1kx1024 | 1048576 | stdx | 5.02 | 13.12 | 2.61 | 80.64 |
| http/json-16kx64 | 1048576 | zlib | 4.54 | 12.51 | 2.76 | 103.24 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.65 | 5.50 | 2.08 | 53.23 |
| http/json-16kx64 | 1048576 | libdeflate | 1.91 | 4.24 | 2.22 | 40.46 |
| http/json-16kx64 | 1048576 | Wuffs | 3.50 | 9.43 | 2.69 | 57.90 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.26 | 39.48 |
| http/json-1m | 1048576 | zlib | 3.84 | 11.20 | 2.92 | 83.11 |
| http/json-1m | 1048576 | zlib-ng | 1.97 | 3.91 | 1.98 | 39.95 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.79 |
| http/json-1m | 1048576 | Wuffs | 2.72 | 7.37 | 2.71 | 43.16 |
| http/json-1m | 1048576 | stdx | 1.33 | 2.67 | 2.01 | 39.54 |
| http/js-1kx1024 | 1048576 | zlib | 17.82 | 38.46 | 2.16 | 411.69 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.77 | 31.25 | 2.27 | 237.99 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.19 | 21.58 | 1.93 | 179.21 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.56 | 40.70 | 2.46 | 300.41 |
| http/js-1kx1024 | 1048576 | stdx | 9.28 | 22.85 | 2.46 | 159.43 |
| http/js-16kx64 | 1048576 | zlib | 7.64 | 16.08 | 2.11 | 263.85 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.97 | 91.93 |
| http/js-16kx64 | 1048576 | libdeflate | 3.05 | 7.01 | 2.30 | 72.16 |
| http/js-16kx64 | 1048576 | Wuffs | 5.50 | 12.75 | 2.32 | 128.63 |
| http/js-16kx64 | 1048576 | stdx | 2.99 | 6.54 | 2.19 | 71.84 |
| http/js-1m | 1048576 | zlib | 5.86 | 13.31 | 2.27 | 199.02 |
| http/js-1m | 1048576 | zlib-ng | 2.90 | 5.66 | 1.96 | 60.34 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.85 |
| http/js-1m | 1048576 | Wuffs | 3.92 | 9.14 | 2.33 | 93.66 |
| http/js-1m | 1048576 | stdx | 1.82 | 3.89 | 2.13 | 55.62 |
| http/css-1kx1024 | 1048576 | zlib | 13.60 | 30.36 | 2.23 | 281.48 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.26 | 23.04 | 2.25 | 171.21 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.10 | 17.37 | 1.91 | 121.00 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.78 | 32.50 | 2.54 | 210.04 |
| http/css-1kx1024 | 1048576 | stdx | 6.68 | 17.64 | 2.64 | 100.75 |
| http/css-16kx64 | 1048576 | zlib | 5.28 | 13.04 | 2.47 | 153.47 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.81 | 6.07 | 2.16 | 52.37 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 30.23 |
| http/css-16kx64 | 1048576 | Wuffs | 3.79 | 10.01 | 2.65 | 69.24 |
| http/css-16kx64 | 1048576 | stdx | 1.73 | 4.36 | 2.52 | 28.60 |
| http/css-1m | 1048576 | zlib | 3.97 | 10.97 | 2.76 | 107.08 |
| http/css-1m | 1048576 | zlib-ng | 1.72 | 3.75 | 2.18 | 30.75 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.96 | 13.12 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.78 | 43.40 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.52 | 21.20 |
| shuffled/dickens-1m | 1048576 | zlib | 13.32 | 25.88 | 1.94 | 374.00 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.72 | 16.72 | 1.72 | 196.95 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.03 | 14.95 | 2.13 | 194.03 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.35 | 22.08 | 2.13 | 200.97 |
| shuffled/dickens-1m | 1048576 | stdx | 7.09 | 11.89 | 1.68 | 210.09 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.60 | 14.05 | 3.90 | 3.42 |
| silesia/dickens | 10192446 | stdx | 3.75 | 12.47 | 3.33 | 3.57 |
| silesia/mozilla | 51220480 | libzstd | 2.87 | 9.68 | 3.37 | 30.18 |
| silesia/mozilla | 51220480 | stdx | 2.91 | 9.68 | 3.33 | 16.02 |
| silesia/mr | 9970564 | libzstd | 3.10 | 11.99 | 3.87 | 6.16 |
| silesia/mr | 9970564 | stdx | 3.25 | 10.83 | 3.34 | 5.27 |
| silesia/nci | 33553445 | libzstd | 1.75 | 4.88 | 2.78 | 24.91 |
| silesia/nci | 33553445 | stdx | 1.89 | 4.63 | 2.46 | 13.62 |
| silesia/ooffice | 6152192 | libzstd | 3.42 | 12.19 | 3.56 | 31.16 |
| silesia/ooffice | 6152192 | stdx | 3.43 | 12.40 | 3.61 | 12.19 |
| silesia/osdb | 10085684 | libzstd | 2.44 | 8.45 | 3.46 | 14.98 |
| silesia/osdb | 10085684 | stdx | 2.53 | 8.11 | 3.21 | 15.19 |
| silesia/reymont | 6627202 | libzstd | 3.28 | 11.62 | 3.54 | 11.65 |
| silesia/reymont | 6627202 | stdx | 3.44 | 10.36 | 3.01 | 12.87 |
| silesia/samba | 21606400 | libzstd | 2.17 | 7.41 | 3.41 | 18.67 |
| silesia/samba | 21606400 | stdx | 2.27 | 6.83 | 3.01 | 17.95 |
| silesia/sao | 7251944 | libzstd | 3.85 | 12.72 | 3.30 | 26.82 |
| silesia/sao | 7251944 | stdx | 3.60 | 12.58 | 3.50 | 6.19 |
| silesia/webster | 41458703 | libzstd | 3.39 | 11.24 | 3.32 | 16.26 |
| silesia/webster | 41458703 | stdx | 3.57 | 10.05 | 2.81 | 17.63 |
| silesia/x-ray | 8474240 | libzstd | 3.92 | 14.94 | 3.81 | 18.90 |
| silesia/x-ray | 8474240 | stdx | 3.65 | 13.23 | 3.62 | 8.31 |
| silesia/xml | 5345280 | libzstd | 1.57 | 5.57 | 3.55 | 23.27 |
| silesia/xml | 5345280 | stdx | 1.54 | 5.16 | 3.35 | 17.30 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.89 | 4.12 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.38 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.96 | 14.26 | 4.83 | 3.26 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.30 | 0.24 |
| canterbury/cp.html | 24603 | libzstd | 2.63 | 10.74 | 4.08 | 7.08 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.11 | 0.21 |
| canterbury/fields.c | 11150 | libzstd | 3.13 | 13.62 | 4.36 | 9.17 |
| canterbury/fields.c | 11150 | stdx | 3.00 | 12.72 | 4.24 | 0.26 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.20 | 16.94 | 4.04 | 5.66 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.54 | 4.02 | 0.14 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.53 | 11.40 | 4.50 | 7.79 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.68 | 11.32 | 4.22 | 0.90 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.70 | 12.89 | 4.77 | 5.08 |
| canterbury/lcet10.txt | 426754 | stdx | 2.72 | 11.52 | 4.23 | 3.78 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.12 | 15.16 | 4.86 | 1.55 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.26 | 0.92 |
| canterbury/ptt5 | 513216 | libzstd | 1.46 | 4.52 | 3.11 | 25.16 |
| canterbury/ptt5 | 513216 | stdx | 1.34 | 4.46 | 3.33 | 13.19 |
| canterbury/sum | 38240 | libzstd | 2.61 | 10.58 | 4.06 | 9.36 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.09 | 0.38 |
| canterbury/xargs.1 | 4227 | libzstd | 4.25 | 17.41 | 4.10 | 8.76 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 17.17 | 4.06 | 0.37 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.06 | 13.64 | 4.46 | 2.17 |
| canterbury-large/E.coli | 4638690 | stdx | 3.17 | 12.04 | 3.79 | 2.80 |
| canterbury-large/bible.txt | 4047392 | libzstd | 3.01 | 12.00 | 3.99 | 8.49 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.12 | 10.64 | 3.41 | 9.25 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.59 | 9.60 | 3.71 | 19.91 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.68 | 8.64 | 3.22 | 21.24 |
| http/html-1kx1024 | 1048576 | libzstd | 7.26 | 21.63 | 2.98 | 63.46 |
| http/html-1kx1024 | 1048576 | stdx | 7.45 | 22.46 | 3.01 | 76.66 |
| http/html-16kx64 | 1048576 | libzstd | 2.67 | 10.15 | 3.81 | 28.72 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 9.61 | 3.61 | 30.28 |
| http/html-1m | 1048576 | libzstd | 2.02 | 7.88 | 3.91 | 24.31 |
| http/html-1m | 1048576 | stdx | 2.01 | 7.12 | 3.55 | 24.75 |
| http/json-1kx1024 | 1048576 | libzstd | 6.27 | 17.39 | 2.77 | 49.58 |
| http/json-1kx1024 | 1048576 | stdx | 6.21 | 17.86 | 2.88 | 53.29 |
| http/json-16kx64 | 1048576 | libzstd | 2.06 | 7.26 | 3.53 | 28.43 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.58 | 19.94 |
| http/json-1m | 1048576 | libzstd | 1.73 | 6.08 | 3.52 | 27.85 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.63 | 14.26 |
| http/js-1kx1024 | 1048576 | libzstd | 8.33 | 26.35 | 3.16 | 73.51 |
| http/js-1kx1024 | 1048576 | stdx | 9.03 | 27.60 | 3.06 | 113.37 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.72 | 4.00 | 24.54 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.74 | 26.45 |
| http/js-1m | 1048576 | libzstd | 2.04 | 8.19 | 4.01 | 20.53 |
| http/js-1m | 1048576 | stdx | 2.11 | 7.48 | 3.55 | 21.69 |
| http/css-1kx1024 | 1048576 | libzstd | 6.88 | 19.69 | 2.86 | 53.31 |
| http/css-1kx1024 | 1048576 | stdx | 6.84 | 19.96 | 2.92 | 63.54 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.70 | 3.88 | 22.72 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 21.90 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.58 | 3.85 | 5.38 |
| http/css-1m | 1048576 | stdx | 0.72 | 2.49 | 3.47 | 4.18 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.78 | 9.40 | 3.39 | 28.48 |
| shuffled/dickens-1m | 1048576 | stdx | 2.75 | 9.19 | 3.35 | 12.68 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.57 | 16.93 | 2.24 | 99.88 |
| silesia/dickens | 1048576 | stdx | 5.13 | 12.38 | 2.41 | 54.41 |
| silesia/mozilla | 1048576 | Google | 13.49 | 28.31 | 2.10 | 46.62 |
| silesia/mozilla | 1048576 | stdx | 8.35 | 15.02 | 1.80 | 47.63 |
| silesia/mr | 1048576 | Google | 8.98 | 20.21 | 2.25 | 102.90 |
| silesia/mr | 1048576 | stdx | 5.82 | 13.25 | 2.28 | 88.04 |
| silesia/nci | 1048576 | Google | 2.57 | 5.70 | 2.22 | 51.87 |
| silesia/nci | 1048576 | stdx | 1.95 | 3.95 | 2.03 | 54.82 |
| silesia/ooffice | 1048576 | Google | 14.30 | 29.27 | 2.05 | 288.52 |
| silesia/ooffice | 1048576 | stdx | 11.01 | 20.33 | 1.85 | 323.75 |
| silesia/osdb | 1048576 | Google | 8.30 | 17.48 | 2.11 | 96.48 |
| silesia/osdb | 1048576 | stdx | 5.26 | 10.57 | 2.01 | 90.99 |
| silesia/reymont | 1048576 | Google | 5.50 | 12.62 | 2.29 | 82.05 |
| silesia/reymont | 1048576 | stdx | 3.72 | 9.25 | 2.49 | 47.23 |
| silesia/samba | 1048576 | Google | 7.62 | 16.30 | 2.14 | 94.97 |
| silesia/samba | 1048576 | stdx | 5.06 | 10.71 | 2.12 | 66.61 |
| silesia/sao | 1048576 | Google | 16.88 | 37.18 | 2.20 | 163.09 |
| silesia/sao | 1048576 | stdx | 10.47 | 22.65 | 2.16 | 142.80 |
| silesia/webster | 1048576 | Google | 6.62 | 14.00 | 2.12 | 113.65 |
| silesia/webster | 1048576 | stdx | 4.45 | 9.98 | 2.24 | 68.82 |
| silesia/x-ray | 1048576 | Google | 19.78 | 38.56 | 1.95 | 235.76 |
| silesia/x-ray | 1048576 | stdx | 15.04 | 30.18 | 2.01 | 234.98 |
| silesia/xml | 1048576 | Google | 3.46 | 7.61 | 2.20 | 65.41 |
| silesia/xml | 1048576 | stdx | 2.42 | 5.40 | 2.23 | 46.87 |
| canterbury/alice29.txt | 152089 | Google | 8.86 | 20.55 | 2.32 | 133.65 |
| canterbury/alice29.txt | 152089 | stdx | 6.06 | 15.33 | 2.53 | 81.18 |
| canterbury/asyoulik.txt | 125179 | Google | 10.37 | 23.71 | 2.29 | 167.01 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.11 | 17.43 | 2.45 | 107.63 |
| canterbury/cp.html | 24603 | Google | 9.03 | 22.20 | 2.46 | 109.13 |
| canterbury/cp.html | 24603 | stdx | 5.69 | 17.15 | 3.01 | 29.01 |
| canterbury/fields.c | 11150 | Google | 7.07 | 21.16 | 2.99 | 26.33 |
| canterbury/fields.c | 11150 | stdx | 4.87 | 17.08 | 3.50 | 1.83 |
| canterbury/grammar.lsp | 3721 | Google | 9.78 | 30.16 | 3.08 | 6.46 |
| canterbury/grammar.lsp | 3721 | stdx | 7.15 | 25.04 | 3.50 | 0.77 |
| canterbury/kennedy.xls | 1029744 | Google | 5.45 | 17.05 | 3.13 | 37.37 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.84 | 12.94 | 3.37 | 34.38 |
| canterbury/lcet10.txt | 426754 | Google | 7.72 | 17.36 | 2.25 | 125.88 |
| canterbury/lcet10.txt | 426754 | stdx | 5.20 | 12.96 | 2.49 | 66.41 |
| canterbury/plrabn12.txt | 481861 | Google | 9.07 | 20.82 | 2.29 | 132.71 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.19 | 15.04 | 2.43 | 86.98 |
| canterbury/ptt5 | 513216 | Google | 4.29 | 10.41 | 2.43 | 62.13 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.06 | 65.89 |
| canterbury/sum | 38240 | Google | 10.81 | 26.44 | 2.45 | 156.64 |
| canterbury/sum | 38240 | stdx | 8.23 | 21.11 | 2.56 | 147.80 |
| canterbury/xargs.1 | 4227 | Google | 10.93 | 34.81 | 3.19 | 8.34 |
| canterbury/xargs.1 | 4227 | stdx | 8.50 | 30.44 | 3.58 | 7.95 |
| canterbury-large/E.coli | 1048576 | Google | 8.16 | 19.55 | 2.40 | 1.39 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.08 |
| canterbury-large/bible.txt | 1048576 | Google | 5.38 | 12.28 | 2.28 | 80.66 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.56 | 8.93 | 2.51 | 40.02 |
| canterbury-large/world192.txt | 1048576 | Google | 6.24 | 12.84 | 2.06 | 115.06 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.46 | 9.38 | 2.10 | 76.98 |
| http/html-1kx1024 | 1048576 | Google | 18.02 | 41.93 | 2.33 | 387.90 |
| http/html-1kx1024 | 1048576 | stdx | 15.31 | 37.56 | 2.45 | 362.21 |
| http/html-16kx64 | 1048576 | Google | 6.72 | 14.85 | 2.21 | 149.01 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.92 |
| http/html-1m | 1048576 | Google | 4.06 | 8.94 | 2.20 | 83.11 |
| http/html-1m | 1048576 | stdx | 2.87 | 6.52 | 2.28 | 54.69 |
| http/json-1kx1024 | 1048576 | Google | 14.48 | 36.64 | 2.53 | 241.35 |
| http/json-1kx1024 | 1048576 | stdx | 12.99 | 33.63 | 2.59 | 276.94 |
| http/json-16kx64 | 1048576 | Google | 4.41 | 11.43 | 2.59 | 81.52 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.32 |
| http/json-1m | 1048576 | Google | 3.41 | 8.65 | 2.54 | 58.95 |
| http/json-1m | 1048576 | stdx | 2.47 | 5.99 | 2.43 | 57.78 |
| http/js-1kx1024 | 1048576 | Google | 19.90 | 46.20 | 2.32 | 429.08 |
| http/js-1kx1024 | 1048576 | stdx | 16.42 | 39.90 | 2.43 | 382.03 |
| http/js-16kx64 | 1048576 | Google | 8.03 | 17.73 | 2.21 | 167.71 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.95 |
| http/js-1m | 1048576 | Google | 4.39 | 9.54 | 2.17 | 83.05 |
| http/js-1m | 1048576 | stdx | 3.19 | 7.25 | 2.28 | 55.51 |
| http/css-1kx1024 | 1048576 | Google | 15.46 | 37.36 | 2.42 | 294.05 |
| http/css-1kx1024 | 1048576 | stdx | 13.82 | 34.70 | 2.51 | 303.34 |
| http/css-16kx64 | 1048576 | Google | 4.94 | 11.76 | 2.38 | 101.67 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.47 |
| http/css-1m | 1048576 | Google | 2.44 | 9.42 | 3.87 | 16.79 |
| http/css-1m | 1048576 | stdx | 0.76 | 1.86 | 2.45 | 11.75 |
| shuffled/dickens-1m | 1048576 | Google | 10.13 | 20.65 | 2.04 | 106.47 |
| shuffled/dickens-1m | 1048576 | stdx | 8.76 | 14.53 | 1.66 | 116.83 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.27 | 36.91 | 2.42 | 410.30 |
| silesia/dickens | 10192446 | 1 | stdx | 16.40 | 38.17 | 2.33 | 357.94 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.18 | 87.63 | 1.68 | 700.09 |
| silesia/dickens | 10192446 | 6 | stdx | 49.58 | 84.26 | 1.70 | 1431.99 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.86 | 160.47 | 1.43 | 929.82 |
| silesia/dickens | 10192446 | 9 | stdx | 84.90 | 191.80 | 2.26 | 1720.17 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.16 | 32.62 | 2.30 | 440.41 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.40 | 30.24 | 2.26 | 295.38 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.89 | 70.83 | 2.15 | 579.77 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.56 | 69.96 | 2.22 | 732.73 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.53 | 221.49 | 1.74 | 768.26 |
| silesia/mozilla | 51220480 | 9 | stdx | 49.05 | 126.12 | 2.57 | 789.71 |
| silesia/mr | 9970564 | 1 | libdeflate | 12.04 | 35.02 | 2.91 | 230.42 |
| silesia/mr | 9970564 | 1 | stdx | 12.64 | 34.08 | 2.70 | 187.35 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.22 | 80.54 | 2.11 | 436.18 |
| silesia/mr | 9970564 | 6 | stdx | 39.61 | 83.18 | 2.10 | 962.65 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.57 | 165.48 | 1.70 | 755.25 |
| silesia/mr | 9970564 | 9 | stdx | 87.08 | 206.31 | 2.37 | 1329.56 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.26 | 18.42 | 2.94 | 117.27 |
| silesia/nci | 33553445 | 1 | stdx | 5.01 | 10.88 | 2.17 | 97.94 |
| silesia/nci | 33553445 | 6 | libdeflate | 17.02 | 34.84 | 2.05 | 226.19 |
| silesia/nci | 33553445 | 6 | stdx | 14.39 | 29.54 | 2.05 | 391.44 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.41 | 105.28 | 1.69 | 498.79 |
| silesia/nci | 33553445 | 9 | stdx | 33.13 | 80.63 | 2.43 | 648.85 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.98 | 39.15 | 1.96 | 755.05 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.80 | 39.08 | 2.20 | 429.52 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 41.06 | 79.10 | 1.93 | 955.31 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.59 | 87.83 | 2.11 | 1003.15 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.60 | 127.63 | 1.71 | 1133.06 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.57 | 129.17 | 2.46 | 935.86 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.94 | 30.15 | 2.33 | 355.49 |
| silesia/osdb | 10085684 | 1 | stdx | 12.97 | 27.86 | 2.15 | 293.23 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.31 | 55.67 | 1.97 | 492.30 |
| silesia/osdb | 10085684 | 6 | stdx | 27.07 | 57.40 | 2.12 | 566.44 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.95 | 64.15 | 1.89 | 554.18 |
| silesia/osdb | 10085684 | 9 | stdx | 35.51 | 87.23 | 2.46 | 689.56 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.66 | 32.88 | 2.60 | 313.07 |
| silesia/reymont | 6627202 | 1 | stdx | 13.55 | 33.24 | 2.45 | 270.55 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.22 | 86.58 | 1.80 | 522.25 |
| silesia/reymont | 6627202 | 6 | stdx | 45.20 | 76.82 | 1.70 | 1418.33 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.24 | 276.14 | 1.39 | 836.06 |
| silesia/reymont | 6627202 | 9 | stdx | 87.20 | 189.97 | 2.18 | 1608.72 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.47 | 26.53 | 2.53 | 273.22 |
| silesia/samba | 21606400 | 1 | stdx | 9.93 | 22.23 | 2.24 | 220.96 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.99 | 58.79 | 2.03 | 385.71 |
| silesia/samba | 21606400 | 6 | stdx | 24.13 | 49.84 | 2.07 | 621.35 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.24 | 141.44 | 1.68 | 503.61 |
| silesia/samba | 21606400 | 9 | stdx | 41.58 | 102.63 | 2.47 | 730.96 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.76 | 47.87 | 2.20 | 685.83 |
| silesia/sao | 7251944 | 1 | stdx | 19.22 | 49.92 | 2.60 | 347.01 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.19 | 96.89 | 1.89 | 966.92 |
| silesia/sao | 7251944 | 6 | stdx | 47.12 | 105.65 | 2.24 | 851.69 |
| silesia/sao | 7251944 | 9 | libdeflate | 71.06 | 120.26 | 1.69 | 1111.03 |
| silesia/sao | 7251944 | 9 | stdx | 55.63 | 138.16 | 2.48 | 846.94 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.12 | 30.45 | 2.32 | 387.53 |
| silesia/webster | 41458703 | 1 | stdx | 13.89 | 29.08 | 2.09 | 340.11 |
| silesia/webster | 41458703 | 6 | libdeflate | 37.10 | 66.02 | 1.78 | 572.48 |
| silesia/webster | 41458703 | 6 | stdx | 35.15 | 60.88 | 1.73 | 1106.33 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.66 | 138.85 | 1.47 | 754.26 |
| silesia/webster | 41458703 | 9 | stdx | 60.69 | 135.96 | 2.24 | 1293.18 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.71 | 49.67 | 2.09 | 784.75 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.61 | 50.81 | 2.89 | 261.75 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.86 | 82.77 | 2.52 | 851.41 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.84 | 98.11 | 2.90 | 541.18 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.50 | 91.03 | 2.43 | 1034.41 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.77 | 122.05 | 2.99 | 466.36 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.84 | 21.59 | 2.75 | 178.04 |
| silesia/xml | 5345280 | 1 | stdx | 7.04 | 15.66 | 2.22 | 155.14 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.28 | 40.51 | 1.90 | 265.24 |
| silesia/xml | 5345280 | 6 | stdx | 17.73 | 34.32 | 1.94 | 493.67 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.72 | 89.17 | 1.52 | 371.97 |
| silesia/xml | 5345280 | 9 | stdx | 31.22 | 72.83 | 2.33 | 600.45 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.27 | 35.61 | 2.50 | 379.99 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.09 | 36.12 | 2.39 | 337.00 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.75 | 82.29 | 1.76 | 642.74 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.77 | 77.43 | 1.77 | 1314.69 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.58 | 159.21 | 1.48 | 852.27 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 72.64 | 167.73 | 2.31 | 1510.06 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.17 | 37.20 | 2.45 | 417.24 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.77 | 37.43 | 2.37 | 359.51 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.34 | 85.43 | 1.77 | 717.53 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.19 | 81.93 | 1.77 | 1386.85 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.99 | 136.15 | 1.53 | 940.01 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 75.68 | 175.97 | 2.33 | 1610.63 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.66 | 32.02 | 2.75 | 281.95 |
| canterbury/cp.html | 24603 | 1 | stdx | 11.14 | 27.13 | 2.43 | 250.78 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 26.91 | 62.33 | 2.32 | 483.42 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.87 | 57.06 | 2.39 | 623.28 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.94 | 91.97 | 1.96 | 598.76 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.24 | 88.89 | 2.85 | 644.94 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.44 | 35.92 | 3.80 | 59.31 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.17 | 30.05 | 3.68 | 23.03 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.83 | 69.37 | 2.79 | 260.15 |
| canterbury/fields.c | 11150 | 6 | stdx | 21.36 | 57.62 | 2.70 | 447.29 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.69 | 100.81 | 2.26 | 430.44 |
| canterbury/fields.c | 11150 | 9 | stdx | 29.14 | 92.66 | 3.18 | 475.51 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 12.99 | 51.51 | 3.97 | 13.16 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.97 | 39.01 | 3.91 | 2.29 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.76 | 87.06 | 3.66 | 30.49 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.52 | 70.81 | 4.04 | 13.77 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.64 | 102.89 | 3.36 | 40.21 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 24.04 | 99.31 | 4.13 | 67.89 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.37 | 27.18 | 3.69 | 65.31 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.07 | 22.58 | 3.20 | 63.67 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.87 | 73.85 | 2.65 | 96.09 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.40 | 61.99 | 3.20 | 138.55 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.33 | 664.23 | 1.83 | 166.33 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.75 | 130.89 | 3.47 | 220.09 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.78 | 33.99 | 2.47 | 370.12 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.48 | 33.92 | 2.34 | 329.90 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.06 | 78.22 | 1.74 | 608.04 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.67 | 73.43 | 1.76 | 1216.21 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.77 | 136.94 | 1.49 | 805.87 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 70.73 | 162.24 | 2.29 | 1452.73 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.79 | 38.62 | 2.45 | 425.97 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.70 | 40.24 | 2.41 | 366.67 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.22 | 91.90 | 1.69 | 755.48 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.59 | 88.90 | 1.72 | 1498.94 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 117.05 | 166.26 | 1.42 | 1005.72 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 88.63 | 201.33 | 2.27 | 1803.48 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.43 | 18.61 | 2.89 | 142.40 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.99 | 11.03 | 2.21 | 123.31 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.28 | 36.17 | 2.53 | 220.29 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.34 | 29.58 | 2.40 | 308.60 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.49 | 120.86 | 2.00 | 374.64 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.16 | 130.09 | 3.01 | 639.50 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.86 | 33.49 | 2.60 | 341.76 |
| canterbury/sum | 38240 | 1 | stdx | 12.66 | 29.36 | 2.32 | 303.86 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.61 | 69.87 | 2.44 | 499.33 |
| canterbury/sum | 38240 | 6 | stdx | 26.85 | 65.74 | 2.45 | 665.07 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.12 | 181.91 | 1.93 | 602.11 |
| canterbury/sum | 38240 | 9 | stdx | 39.36 | 112.33 | 2.85 | 657.52 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.23 | 53.06 | 4.01 | 19.57 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.80 | 43.10 | 3.99 | 3.12 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 23.01 | 87.70 | 3.81 | 73.79 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 18.73 | 74.35 | 3.97 | 37.48 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 25.05 | 94.34 | 3.77 | 101.18 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.53 | 106.96 | 4.03 | 118.28 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.09 | 40.47 | 3.35 | 163.66 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.82 | 42.29 | 3.30 | 101.92 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.31 | 395.99 | 2.16 | 263.56 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.63 | 374.12 | 3.05 | 1901.16 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.58 | 1063.49 | 1.30 | 1309.85 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 228.34 | 755.68 | 3.31 | 2412.87 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.61 | 32.38 | 2.57 | 312.64 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.50 | 32.23 | 2.39 | 281.13 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.20 | 80.12 | 1.73 | 526.08 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.24 | 72.39 | 1.71 | 1251.60 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.79 | 200.28 | 1.41 | 743.13 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.23 | 170.21 | 2.23 | 1444.05 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.38 | 29.72 | 2.22 | 417.38 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.35 | 28.55 | 1.99 | 379.27 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.27 | 60.25 | 1.81 | 560.77 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.21 | 56.80 | 1.76 | 989.89 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.74 | 119.11 | 1.48 | 686.64 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 52.00 | 117.95 | 2.27 | 1148.75 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.47 | 103.92 | 2.93 | 456.86 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 23.56 | 58.63 | 2.49 | 366.73 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.28 | 138.33 | 2.99 | 565.20 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 33.30 | 94.31 | 2.83 | 530.81 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 48.22 | 142.44 | 2.95 | 590.19 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 37.36 | 112.13 | 3.00 | 537.50 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.47 | 27.96 | 2.67 | 268.29 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.11 | 20.25 | 2.22 | 234.52 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.45 | 52.09 | 2.32 | 397.01 |
| http/html-16kx64 | 1048576 | 6 | stdx | 19.11 | 42.86 | 2.24 | 538.74 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 35.11 | 72.54 | 2.07 | 464.75 |
| http/html-16kx64 | 1048576 | 9 | stdx | 25.14 | 69.05 | 2.75 | 552.24 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.79 | 23.03 | 2.62 | 225.31 |
| http/html-1m | 1048576 | 1 | stdx | 8.18 | 17.79 | 2.18 | 206.05 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.42 | 49.53 | 1.95 | 329.41 |
| http/html-1m | 1048576 | 6 | stdx | 21.32 | 40.71 | 1.91 | 616.24 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.26 | 109.24 | 1.53 | 430.42 |
| http/html-1m | 1048576 | 9 | stdx | 36.00 | 85.76 | 2.38 | 707.62 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.83 | 94.80 | 2.98 | 304.59 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 18.67 | 45.16 | 2.42 | 242.50 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.11 | 126.60 | 2.94 | 372.79 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 28.44 | 78.37 | 2.76 | 380.15 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.63 | 142.45 | 2.71 | 432.22 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 32.10 | 95.56 | 2.98 | 386.21 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.88 | 23.85 | 3.03 | 135.29 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.51 | 13.94 | 2.53 | 110.10 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.22 | 46.61 | 2.56 | 206.50 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.65 | 35.01 | 2.56 | 278.52 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.23 | 151.99 | 1.89 | 296.22 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.44 | 58.45 | 3.01 | 302.70 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.75 | 19.85 | 2.94 | 125.48 |
| http/json-1m | 1048576 | 1 | stdx | 5.08 | 12.51 | 2.46 | 103.05 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.35 | 45.30 | 2.23 | 175.64 |
| http/json-1m | 1048576 | 6 | stdx | 14.80 | 35.09 | 2.37 | 299.31 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.66 | 205.21 | 1.69 | 276.33 |
| http/json-1m | 1048576 | 9 | stdx | 29.19 | 72.87 | 2.50 | 369.59 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.14 | 107.80 | 2.90 | 519.57 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 25.89 | 65.40 | 2.53 | 412.19 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.43 | 144.85 | 2.93 | 677.85 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 37.03 | 104.12 | 2.81 | 625.22 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 52.12 | 150.13 | 2.88 | 716.63 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 41.71 | 125.13 | 3.00 | 626.17 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.76 | 30.90 | 2.63 | 310.36 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.95 | 24.80 | 2.26 | 273.90 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.97 | 59.43 | 2.29 | 472.49 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.98 | 50.05 | 2.18 | 674.65 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.95 | 83.31 | 2.03 | 564.99 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.89 | 81.30 | 2.72 | 664.30 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.67 | 25.19 | 2.61 | 248.66 |
| http/js-1m | 1048576 | 1 | stdx | 9.59 | 21.31 | 2.22 | 234.46 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.86 | 56.12 | 1.95 | 372.02 |
| http/js-1m | 1048576 | 6 | stdx | 24.91 | 46.64 | 1.87 | 737.40 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.52 | 120.65 | 1.58 | 498.85 |
| http/js-1m | 1048576 | 9 | stdx | 42.23 | 100.01 | 2.37 | 815.05 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.23 | 97.73 | 2.94 | 377.70 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 20.73 | 49.52 | 2.39 | 302.16 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.93 | 129.22 | 2.94 | 477.44 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 30.52 | 82.32 | 2.70 | 506.67 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 46.36 | 133.80 | 2.89 | 510.21 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 34.53 | 99.48 | 2.88 | 521.34 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.67 | 25.60 | 2.95 | 175.59 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.75 | 16.96 | 2.51 | 134.96 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.30 | 48.80 | 2.40 | 291.25 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.64 | 38.00 | 2.28 | 461.15 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.98 | 82.40 | 2.01 | 372.54 |
| http/css-16kx64 | 1048576 | 9 | stdx | 23.21 | 65.13 | 2.81 | 480.66 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.96 | 21.15 | 3.04 | 133.72 |
| http/css-1m | 1048576 | 1 | stdx | 5.80 | 14.91 | 2.57 | 107.94 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.79 | 44.50 | 2.14 | 225.98 |
| http/css-1m | 1048576 | 6 | stdx | 16.61 | 35.61 | 2.14 | 440.17 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.89 | 111.58 | 1.60 | 307.86 |
| http/css-1m | 1048576 | 9 | stdx | 32.24 | 83.00 | 2.57 | 511.93 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.21 | 48.89 | 1.94 | 927.65 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.20 | 49.19 | 2.70 | 324.24 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.62 | 86.45 | 2.08 | 1180.89 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.94 | 88.80 | 2.22 | 855.46 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.06 | 94.50 | 2.01 | 1343.31 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.13 | 134.38 | 2.48 | 1135.85 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.10 | 31.22 | 3.09 | 120.75 |
| silesia/dickens | 10192446 | 1 | stdx | 24.38 | 82.03 | 3.36 | 125.16 |
| silesia/dickens | 10192446 | 3 | libzstd | 29.44 | 34.39 | 1.17 | 172.95 |
| silesia/dickens | 10192446 | 3 | stdx | 37.34 | 78.22 | 2.09 | 182.58 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.01 | 22.69 | 3.24 | 70.68 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.76 | 54.73 | 3.08 | 173.47 |
| silesia/mozilla | 51220480 | 3 | libzstd | 18.01 | 27.89 | 1.55 | 103.20 |
| silesia/mozilla | 51220480 | 3 | stdx | 32.19 | 62.01 | 1.93 | 144.77 |
| silesia/mr | 9970564 | 1 | libzstd | 7.69 | 24.81 | 3.23 | 57.45 |
| silesia/mr | 9970564 | 1 | stdx | 19.99 | 66.82 | 3.34 | 114.07 |
| silesia/mr | 9970564 | 3 | libzstd | 21.31 | 32.19 | 1.51 | 87.08 |
| silesia/mr | 9970564 | 3 | stdx | 35.19 | 72.46 | 2.06 | 114.49 |
| silesia/nci | 33553445 | 1 | libzstd | 3.54 | 9.55 | 2.70 | 57.84 |
| silesia/nci | 33553445 | 1 | stdx | 7.79 | 25.69 | 3.30 | 58.68 |
| silesia/nci | 33553445 | 3 | libzstd | 5.67 | 9.95 | 1.75 | 56.62 |
| silesia/nci | 33553445 | 3 | stdx | 11.66 | 29.15 | 2.50 | 66.18 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.57 | 29.26 | 3.42 | 70.48 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.27 | 72.51 | 3.12 | 184.13 |
| silesia/ooffice | 6152192 | 3 | libzstd | 25.45 | 39.44 | 1.55 | 121.16 |
| silesia/ooffice | 6152192 | 3 | stdx | 44.22 | 82.20 | 1.86 | 185.20 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.06 | 22.29 | 3.16 | 66.38 |
| silesia/osdb | 10085684 | 1 | stdx | 16.49 | 50.52 | 3.06 | 119.29 |
| silesia/osdb | 10085684 | 3 | libzstd | 19.04 | 26.23 | 1.38 | 68.27 |
| silesia/osdb | 10085684 | 3 | stdx | 33.71 | 57.87 | 1.72 | 111.30 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.72 | 27.13 | 2.79 | 150.64 |
| silesia/reymont | 6627202 | 1 | stdx | 20.23 | 72.05 | 3.56 | 97.01 |
| silesia/reymont | 6627202 | 3 | libzstd | 19.49 | 27.10 | 1.39 | 126.50 |
| silesia/reymont | 6627202 | 3 | stdx | 29.33 | 62.18 | 2.12 | 147.48 |
| silesia/samba | 21606400 | 1 | libzstd | 5.94 | 16.88 | 2.84 | 85.69 |
| silesia/samba | 21606400 | 1 | stdx | 13.61 | 42.89 | 3.15 | 124.80 |
| silesia/samba | 21606400 | 3 | libzstd | 12.58 | 18.81 | 1.50 | 99.73 |
| silesia/samba | 21606400 | 3 | stdx | 21.23 | 44.75 | 2.11 | 133.45 |
| silesia/sao | 7251944 | 1 | libzstd | 9.06 | 33.69 | 3.72 | 44.59 |
| silesia/sao | 7251944 | 1 | stdx | 26.00 | 82.03 | 3.15 | 107.75 |
| silesia/sao | 7251944 | 3 | libzstd | 33.35 | 50.03 | 1.50 | 96.35 |
| silesia/sao | 7251944 | 3 | stdx | 54.51 | 95.22 | 1.75 | 142.73 |
| silesia/webster | 41458703 | 1 | libzstd | 8.65 | 24.94 | 2.88 | 130.89 |
| silesia/webster | 41458703 | 1 | stdx | 20.42 | 64.04 | 3.14 | 165.59 |
| silesia/webster | 41458703 | 3 | libzstd | 20.19 | 27.33 | 1.35 | 178.40 |
| silesia/webster | 41458703 | 3 | stdx | 32.17 | 64.55 | 2.01 | 194.71 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.76 | 14.92 | 3.14 | 17.21 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.91 | 76.64 | 3.21 | 91.94 |
| silesia/x-ray | 8474240 | 3 | libzstd | 34.18 | 52.73 | 1.54 | 88.58 |
| silesia/x-ray | 8474240 | 3 | stdx | 50.13 | 92.40 | 1.84 | 108.19 |
| silesia/xml | 5345280 | 1 | libzstd | 4.24 | 11.71 | 2.76 | 71.59 |
| silesia/xml | 5345280 | 1 | stdx | 10.50 | 34.21 | 3.26 | 93.83 |
| silesia/xml | 5345280 | 3 | libzstd | 7.08 | 12.61 | 1.78 | 77.86 |
| silesia/xml | 5345280 | 3 | stdx | 13.14 | 32.28 | 2.46 | 115.42 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.76 | 32.84 | 3.05 | 138.79 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.40 | 76.49 | 3.41 | 187.96 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.82 | 39.48 | 2.50 | 204.39 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.68 | 73.76 | 2.76 | 334.15 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.74 | 33.55 | 3.44 | 104.79 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.47 | 79.00 | 3.37 | 211.42 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.21 | 39.27 | 2.58 | 210.21 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.41 | 79.30 | 2.79 | 371.71 |
| canterbury/cp.html | 24603 | 1 | libzstd | 6.89 | 26.64 | 3.87 | 35.43 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.01 | 57.76 | 3.61 | 116.58 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.48 | 31.85 | 3.36 | 46.57 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.12 | 59.76 | 3.30 | 135.76 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.62 | 31.76 | 3.68 | 37.43 |
| canterbury/fields.c | 11150 | 1 | stdx | 16.86 | 65.73 | 3.90 | 81.81 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.64 | 34.13 | 3.54 | 44.35 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.60 | 64.68 | 3.68 | 92.43 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.42 | 38.01 | 4.04 | 7.57 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.13 | 77.57 | 3.85 | 50.13 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.76 | 43.09 | 4.00 | 11.93 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.52 | 79.60 | 3.70 | 68.92 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.00 | 23.56 | 3.93 | 14.93 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.84 | 56.75 | 3.82 | 83.57 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 9.01 | 23.80 | 2.64 | 27.62 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 21.20 | 56.61 | 2.67 | 108.70 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.81 | 28.52 | 2.91 | 156.66 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.50 | 72.02 | 3.35 | 160.38 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 17.34 | 32.14 | 1.85 | 203.71 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.81 | 67.10 | 2.50 | 296.32 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.29 | 32.37 | 3.14 | 128.40 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.11 | 84.16 | 3.35 | 158.58 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 21.68 | 38.77 | 1.79 | 226.65 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 32.66 | 80.77 | 2.47 | 342.86 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.17 | 8.51 | 2.69 | 67.34 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.53 | 23.15 | 3.07 | 105.11 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 5.11 | 10.97 | 2.15 | 58.91 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.68 | 24.08 | 2.49 | 133.22 |
| canterbury/sum | 38240 | 1 | libzstd | 6.48 | 25.39 | 3.92 | 29.41 |
| canterbury/sum | 38240 | 1 | stdx | 16.85 | 59.13 | 3.51 | 150.68 |
| canterbury/sum | 38240 | 3 | libzstd | 9.04 | 30.67 | 3.39 | 48.89 |
| canterbury/sum | 38240 | 3 | stdx | 19.96 | 61.82 | 3.10 | 180.75 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 10.00 | 39.82 | 3.98 | 13.17 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.81 | 80.38 | 3.86 | 57.40 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.29 | 48.17 | 3.92 | 21.68 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 23.09 | 83.98 | 3.64 | 81.28 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.33 | 33.44 | 3.24 | 76.65 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.95 | 95.62 | 4.36 | 7.26 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 16.18 | 31.30 | 1.93 | 36.02 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 24.53 | 70.38 | 2.87 | 38.29 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.72 | 27.45 | 2.83 | 149.19 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.52 | 71.86 | 3.50 | 107.65 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 19.32 | 28.20 | 1.46 | 133.99 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 29.07 | 63.36 | 2.18 | 155.20 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.16 | 22.70 | 2.78 | 137.39 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.77 | 55.86 | 2.98 | 194.02 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 16.46 | 23.87 | 1.45 | 175.61 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 25.96 | 51.26 | 1.97 | 237.80 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 16.98 | 52.46 | 3.09 | 159.88 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.84 | 100.54 | 2.81 | 641.18 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.01 | 59.20 | 3.11 | 197.18 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 38.24 | 104.00 | 2.72 | 631.59 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.70 | 22.46 | 2.92 | 121.64 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.21 | 46.84 | 3.30 | 182.20 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.76 | 24.61 | 2.81 | 141.21 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.66 | 47.61 | 3.04 | 193.23 |
| http/html-1m | 1048576 | 1 | libzstd | 6.22 | 16.74 | 2.69 | 114.79 |
| http/html-1m | 1048576 | 1 | stdx | 13.04 | 42.00 | 3.22 | 134.34 |
| http/html-1m | 1048576 | 3 | libzstd | 9.74 | 18.18 | 1.87 | 125.84 |
| http/html-1m | 1048576 | 3 | stdx | 16.23 | 39.37 | 2.43 | 177.32 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.26 | 42.52 | 2.98 | 116.64 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.64 | 83.13 | 2.80 | 528.10 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.80 | 44.54 | 3.01 | 129.32 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 31.09 | 84.87 | 2.73 | 538.09 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.80 | 14.98 | 3.12 | 57.75 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.72 | 33.78 | 3.47 | 116.40 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.33 | 16.21 | 3.04 | 72.66 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.75 | 34.58 | 3.22 | 122.65 |
| http/json-1m | 1048576 | 1 | libzstd | 4.05 | 12.55 | 3.10 | 53.45 |
| http/json-1m | 1048576 | 1 | stdx | 9.07 | 30.70 | 3.39 | 85.35 |
| http/json-1m | 1048576 | 3 | libzstd | 6.55 | 13.78 | 2.10 | 69.03 |
| http/json-1m | 1048576 | 3 | stdx | 11.73 | 30.64 | 2.61 | 119.86 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.47 | 57.26 | 3.10 | 184.74 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 39.91 | 113.49 | 2.84 | 695.11 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.37 | 65.54 | 3.07 | 261.32 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.36 | 116.54 | 2.75 | 678.52 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.84 | 26.52 | 3.00 | 127.43 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.67 | 55.71 | 3.34 | 200.70 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.04 | 28.74 | 2.86 | 153.21 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.88 | 55.35 | 3.10 | 209.67 |
| http/js-1m | 1048576 | 1 | libzstd | 6.51 | 17.87 | 2.74 | 113.84 |
| http/js-1m | 1048576 | 1 | stdx | 14.05 | 45.88 | 3.27 | 135.50 |
| http/js-1m | 1048576 | 3 | libzstd | 10.46 | 19.14 | 1.83 | 125.55 |
| http/js-1m | 1048576 | 3 | stdx | 17.48 | 41.25 | 2.36 | 186.76 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.46 | 46.90 | 3.03 | 136.43 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.31 | 91.65 | 2.84 | 579.95 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.61 | 50.53 | 3.04 | 160.96 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 34.02 | 93.63 | 2.75 | 582.37 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.11 | 18.99 | 3.11 | 78.61 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.47 | 43.79 | 3.51 | 137.86 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.55 | 19.41 | 2.96 | 95.80 |
| http/css-16kx64 | 1048576 | 3 | stdx | 13.15 | 42.34 | 3.22 | 154.06 |
| http/css-1m | 1048576 | 1 | libzstd | 1.50 | 4.59 | 3.07 | 21.71 |
| http/css-1m | 1048576 | 1 | stdx | 4.02 | 14.85 | 3.69 | 30.57 |
| http/css-1m | 1048576 | 3 | libzstd | 2.03 | 5.25 | 2.59 | 19.67 |
| http/css-1m | 1048576 | 3 | stdx | 4.03 | 13.33 | 3.30 | 31.53 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.53 | 12.79 | 3.63 | 5.88 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.12 | 30.66 | 3.36 | 61.59 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 31.03 | 50.53 | 1.63 | 49.88 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 21.48 | 47.43 | 2.21 | 208.15 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.5 | 74.2 | 0.122 | 3.02 | 2.91 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 66.4 | 219.6 | 0.084 | 7.84 | 3.31 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 30.6 | 96.1 | 0.163 | 3.62 | 3.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 248.5 | 1024.0 | 0.849 | 29.36 | 4.12 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.8 | 107.7 | 0.132 | 3.64 | 3.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.2 | 106.2 | 0.304 | 3.34 | 3.76 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.8 | 378.2 | 0.380 | 11.32 | 3.95 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 43.1 | 161.9 | 0.480 | 5.09 | 3.76 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 92.0 | 451.6 | 0.305 | 10.87 | 4.91 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.5 | 89.5 | 0.004 | 4.05 | 3.25 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 69.5 | 234.7 | 0.051 | 10.23 | 3.38 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 29.6 | 99.4 | 0.012 | 4.36 | 3.36 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 215.2 | 819.1 | 0.937 | 31.68 | 3.81 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.3 | 107.7 | 0.039 | 4.16 | 3.81 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 30.8 | 106.0 | 0.047 | 4.54 | 3.44 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 95.6 | 346.2 | 0.345 | 14.06 | 3.62 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 33.1 | 144.5 | 0.053 | 4.87 | 4.37 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 95.3 | 406.5 | 0.081 | 14.03 | 4.26 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 115195.9 | 403846.2 | 538.392 | 0.67 | 3.51 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 590816.9 | 2503286.2 | 1386.443 | 3.42 | 4.24 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 114646.9 | 404249.2 | 506.268 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3562288.1 | 18223876.2 | 2982.918 | 20.65 | 5.12 |
| string: silesia/dickens | 1 | 172528 | simdjson | 312226.4 | 621744.2 | 637.268 | 1.81 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 224263.2 | 826630.2 | 2173.835 | 1.30 | 3.69 |
| string: silesia/dickens | 1 | 172528 | std.json | 1572072.9 | 4578768.2 | 42353.495 | 9.11 | 2.91 |
| string: silesia/dickens | 1 | 172528 | serde_json | 201905.0 | 802391.2 | 981.959 | 1.17 | 3.97 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1049250.8 | 5280810.3 | 4968.804 | 6.08 | 5.03 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1570874.6 | 4799763.6 | 1478.071 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14422663.5 | 56816152.6 | 39256.571 | 12.12 | 3.94 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1569047.3 | 4799955.6 | 1367.929 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 29213380.4 | 132108253.6 | 159286.214 | 24.54 | 4.52 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4593827.1 | 7062781.6 | 581.000 | 3.86 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1796828.0 | 7322029.6 | 14396.571 | 1.51 | 4.07 |
| string: http/json-1m | 1 | 1190272 | std.json | 10314801.1 | 47381213.6 | 31738.643 | 8.67 | 4.59 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3915005.6 | 15226459.6 | 6162.286 | 3.29 | 3.89 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9066492.9 | 47986992.2 | 27595.929 | 7.62 | 5.29 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2069683.9 | 5765413.8 | 4462.000 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6189449.9 | 22589263.8 | 6985.125 | 3.29 | 3.65 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2059021.3 | 5765605.8 | 3936.375 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47734633.0 | 227842320.8 | 319192.625 | 25.35 | 4.77 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3776303.8 | 8446023.8 | 1926.500 | 2.01 | 2.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7167733.3 | 12276717.8 | 275172.375 | 3.81 | 1.71 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17498666.9 | 63617055.8 | 266245.625 | 9.29 | 3.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9492500.8 | 24440755.8 | 331440.500 | 5.04 | 2.57 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39693316.3 | 160431680.1 | 806499.250 | 21.08 | 4.04 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12924634.7 | 42561069.3 | 244753.333 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 172684968.3 | 667246747.3 | 392875.000 | 34.02 | 3.86 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12895790.7 | 42561261.3 | 243585.333 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 153825876.7 | 639992662.3 | 423928.000 | 30.31 | 4.16 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17570123.7 | 49745820.3 | 252616.667 | 3.46 | 2.83 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14368303.0 | 45615166.3 | 451161.667 | 2.83 | 3.17 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 80512236.3 | 314900845.3 | 457237.000 | 15.86 | 3.91 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 35969187.3 | 131556135.3 | 585104.333 | 7.09 | 3.66 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66767495.7 | 273928536.7 | 840614.333 | 13.15 | 4.10 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 93736.3 | 303836.7 | 7.806 | 0.18 | 3.24 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 186871.9 | 623465.7 | 7.839 | 0.36 | 3.34 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 148015.9 | 557622.7 | 6.516 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10256912.8 | 53478202.7 | 7.645 | 19.56 | 5.21 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 489923.2 | 1376733.7 | 6.677 | 0.93 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 539774.4 | 2195917.7 | 7.387 | 1.03 | 4.07 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3475549.4 | 12808414.7 | 61110.290 | 6.63 | 3.69 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 297913.3 | 1179969.7 | 6.419 | 0.57 | 3.96 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2256204.6 | 12788582.9 | 240.484 | 4.30 | 5.67 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.9 | 81.8 | 0.109 | 2.35 | 4.11 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.1 | 153.6 | 0.127 | 4.15 | 4.37 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 21.2 | 93.4 | 0.090 | 2.50 | 4.41 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 218.5 | 981.0 | 0.927 | 25.82 | 4.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 19.3 | 79.5 | 0.106 | 2.28 | 4.12 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.3 | 94.1 | 0.135 | 2.75 | 4.04 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.5 | 105.6 | 0.247 | 3.25 | 3.84 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.4 | 310.8 | 0.367 | 8.20 | 4.48 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.7 | 255.3 | 0.515 | 7.52 | 4.01 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.4 | 315.1 | 0.236 | 8.08 | 4.61 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.9 | 82.8 | 0.024 | 2.79 | 4.37 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.3 | 153.9 | 0.027 | 5.35 | 4.24 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 22.2 | 94.2 | 0.024 | 3.26 | 4.25 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 169.7 | 718.3 | 1.258 | 24.97 | 4.23 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.7 | 81.5 | 0.024 | 2.75 | 4.37 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 22.2 | 96.8 | 0.032 | 3.26 | 4.37 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 30.2 | 117.9 | 0.033 | 4.45 | 3.90 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 60.8 | 271.2 | 0.269 | 8.95 | 4.46 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 48.4 | 211.0 | 0.037 | 7.13 | 4.35 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 83.4 | 331.7 | 0.107 | 12.28 | 3.98 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 85210.2 | 280786.2 | 722.052 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 85017.1 | 280732.2 | 716.371 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84896.1 | 280721.2 | 714.351 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3408496.1 | 16047574.2 | 2949.454 | 19.76 | 4.71 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 82850.4 | 274401.2 | 658.485 | 0.48 | 3.31 |
| string: silesia/dickens | 1 | 172528 | simdjson | 208936.6 | 674016.2 | 2086.660 | 1.21 | 3.23 |
| string: silesia/dickens | 1 | 172528 | yyjson | 205282.3 | 825518.2 | 1110.876 | 1.19 | 4.02 |
| string: silesia/dickens | 1 | 172528 | std.json | 1359177.9 | 2890892.2 | 54297.536 | 7.88 | 2.13 |
| string: silesia/dickens | 1 | 172528 | serde_json | 376191.4 | 1586249.2 | 2292.505 | 2.18 | 4.22 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 578361.9 | 2970293.2 | 2338.443 | 3.35 | 5.14 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1283589.6 | 3582350.6 | 11951.357 | 1.08 | 2.79 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1276279.4 | 3582290.6 | 11700.786 | 1.07 | 2.81 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1274304.8 | 3582277.6 | 11587.071 | 1.07 | 2.81 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25583090.6 | 109856348.6 | 142424.929 | 21.49 | 4.29 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1234027.1 | 3370022.6 | 11199.857 | 1.04 | 2.73 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2967251.1 | 10460762.6 | 29109.071 | 2.49 | 3.53 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2588171.3 | 10197931.6 | 9742.714 | 2.17 | 3.94 |
| string: http/json-1m | 1 | 1190272 | std.json | 8883997.2 | 43287986.6 | 16886.143 | 7.46 | 4.87 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3902130.3 | 17941088.6 | 11075.357 | 3.28 | 4.60 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5238940.9 | 26999759.5 | 11261.714 | 4.40 | 5.15 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2075565.9 | 6088099.8 | 4634.875 | 1.10 | 2.93 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2061811.6 | 6088039.8 | 4177.625 | 1.09 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2063990.3 | 6088026.8 | 4129.250 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43687245.3 | 193466548.8 | 265946.750 | 23.20 | 4.43 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2070987.8 | 5875346.8 | 4695.125 | 1.10 | 2.84 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2715873.3 | 7144143.8 | 20916.625 | 1.44 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12158803.0 | 23590602.8 | 448865.250 | 6.46 | 1.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20371588.6 | 56837736.8 | 546997.500 | 10.82 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11528913.3 | 33662338.8 | 333070.500 | 6.12 | 2.92 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18823059.3 | 76319389.9 | 249131.125 | 10.00 | 4.05 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113426.6 | 426376.7 | 1.387 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113203.3 | 426318.7 | 1.968 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113251.7 | 426305.7 | 2.452 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 636436.2 | 3146479.7 | 6.871 | 1.21 | 4.94 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113177.5 | 426343.7 | 3.419 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1203869.9 | 3866916.7 | 4.645 | 2.30 | 3.21 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1623427.7 | 5833341.7 | 6.742 | 3.10 | 3.59 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3624239.7 | 13108830.7 | 72433.097 | 6.91 | 3.62 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1781716.4 | 7405810.7 | 4.806 | 3.40 | 4.16 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2409246.2 | 12748281.8 | 16.806 | 4.60 | 5.29 |
