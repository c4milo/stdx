# bench-profile

| Field | Value |
|---|---|
| Commit | 6508f50 |
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
| silesia/dickens | 10192446 | zlib | 8.83 | 19.08 | 2.16 | 309.42 |
| silesia/dickens | 10192446 | zlib-ng | 4.90 | 10.50 | 2.14 | 67.71 |
| silesia/dickens | 10192446 | libdeflate | 3.50 | 9.56 | 2.73 | 66.14 |
| silesia/dickens | 10192446 | Wuffs | 5.55 | 13.90 | 2.50 | 97.36 |
| silesia/dickens | 10192446 | stdx | 3.03 | 7.15 | 2.36 | 75.98 |
| silesia/mozilla | 51220480 | zlib | 8.49 | 17.23 | 2.03 | 250.33 |
| silesia/mozilla | 51220480 | zlib-ng | 4.97 | 8.95 | 1.80 | 85.95 |
| silesia/mozilla | 51220480 | libdeflate | 3.50 | 7.63 | 2.18 | 71.04 |
| silesia/mozilla | 51220480 | Wuffs | 6.41 | 13.89 | 2.17 | 133.03 |
| silesia/mozilla | 51220480 | stdx | 3.66 | 6.29 | 1.72 | 89.24 |
| silesia/mr | 9970564 | zlib | 8.45 | 18.46 | 2.19 | 201.44 |
| silesia/mr | 9970564 | zlib-ng | 4.85 | 9.98 | 2.06 | 68.05 |
| silesia/mr | 9970564 | libdeflate | 3.42 | 8.58 | 2.51 | 61.10 |
| silesia/mr | 9970564 | Wuffs | 6.04 | 14.04 | 2.32 | 100.15 |
| silesia/mr | 9970564 | stdx | 3.23 | 6.70 | 2.07 | 69.62 |
| silesia/nci | 33553445 | zlib | 3.61 | 10.18 | 2.82 | 81.16 |
| silesia/nci | 33553445 | zlib-ng | 1.69 | 3.13 | 1.86 | 35.30 |
| silesia/nci | 33553445 | libdeflate | 1.27 | 2.66 | 2.09 | 29.77 |
| silesia/nci | 33553445 | Wuffs | 2.50 | 6.47 | 2.58 | 41.27 |
| silesia/nci | 33553445 | stdx | 1.43 | 2.20 | 1.55 | 37.12 |
| silesia/ooffice | 6152192 | zlib | 11.80 | 21.06 | 1.78 | 414.39 |
| silesia/ooffice | 6152192 | zlib-ng | 6.97 | 12.04 | 1.73 | 141.72 |
| silesia/ooffice | 6152192 | libdeflate | 4.93 | 10.45 | 2.12 | 125.60 |
| silesia/ooffice | 6152192 | Wuffs | 8.81 | 17.54 | 1.99 | 221.75 |
| silesia/ooffice | 6152192 | stdx | 5.18 | 8.55 | 1.65 | 151.41 |
| silesia/osdb | 10085684 | zlib | 7.51 | 16.59 | 2.21 | 181.46 |
| silesia/osdb | 10085684 | zlib-ng | 4.35 | 8.38 | 1.93 | 54.70 |
| silesia/osdb | 10085684 | libdeflate | 2.87 | 6.91 | 2.40 | 29.78 |
| silesia/osdb | 10085684 | Wuffs | 5.81 | 13.61 | 2.34 | 79.19 |
| silesia/osdb | 10085684 | stdx | 2.89 | 5.65 | 1.95 | 40.03 |
| silesia/reymont | 6627202 | zlib | 7.43 | 15.89 | 2.14 | 261.87 |
| silesia/reymont | 6627202 | zlib-ng | 3.74 | 7.72 | 2.06 | 59.97 |
| silesia/reymont | 6627202 | libdeflate | 2.63 | 6.91 | 2.62 | 50.97 |
| silesia/reymont | 6627202 | Wuffs | 4.92 | 11.40 | 2.31 | 114.09 |
| silesia/reymont | 6627202 | stdx | 2.35 | 5.11 | 2.17 | 63.58 |
| silesia/samba | 21606400 | zlib | 6.20 | 14.13 | 2.28 | 175.17 |
| silesia/samba | 21606400 | zlib-ng | 3.44 | 6.47 | 1.88 | 58.20 |
| silesia/samba | 21606400 | libdeflate | 2.40 | 5.58 | 2.33 | 42.96 |
| silesia/samba | 21606400 | Wuffs | 4.34 | 10.39 | 2.39 | 79.59 |
| silesia/samba | 21606400 | stdx | 2.41 | 4.46 | 1.85 | 56.20 |
| silesia/sao | 7251944 | zlib | 10.54 | 23.54 | 2.23 | 206.14 |
| silesia/sao | 7251944 | zlib-ng | 7.96 | 14.83 | 1.86 | 79.24 |
| silesia/sao | 7251944 | libdeflate | 5.85 | 12.73 | 2.18 | 79.23 |
| silesia/sao | 7251944 | Wuffs | 8.99 | 21.26 | 2.36 | 86.07 |
| silesia/sao | 7251944 | stdx | 5.79 | 10.32 | 1.78 | 86.99 |
| silesia/webster | 41458703 | zlib | 7.76 | 16.16 | 2.08 | 279.80 |
| silesia/webster | 41458703 | zlib-ng | 4.24 | 8.04 | 1.90 | 84.78 |
| silesia/webster | 41458703 | libdeflate | 2.95 | 7.17 | 2.43 | 68.42 |
| silesia/webster | 41458703 | Wuffs | 5.15 | 11.67 | 2.27 | 122.55 |
| silesia/webster | 41458703 | stdx | 2.85 | 5.56 | 1.95 | 86.84 |
| silesia/x-ray | 8474240 | zlib | 12.88 | 27.21 | 2.11 | 328.27 |
| silesia/x-ray | 8474240 | zlib-ng | 9.07 | 17.39 | 1.92 | 123.96 |
| silesia/x-ray | 8474240 | libdeflate | 6.58 | 15.26 | 2.32 | 124.58 |
| silesia/x-ray | 8474240 | Wuffs | 10.82 | 23.52 | 2.17 | 190.94 |
| silesia/x-ray | 8474240 | stdx | 6.22 | 11.49 | 1.85 | 137.65 |
| silesia/xml | 5345280 | zlib | 4.23 | 11.16 | 2.64 | 117.97 |
| silesia/xml | 5345280 | zlib-ng | 2.00 | 3.88 | 1.94 | 42.79 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 31.85 |
| silesia/xml | 5345280 | Wuffs | 2.84 | 7.22 | 2.54 | 59.19 |
| silesia/xml | 5345280 | stdx | 1.33 | 2.65 | 1.99 | 41.49 |
| canterbury/alice29.txt | 152089 | zlib | 8.45 | 18.35 | 2.17 | 297.51 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.53 | 9.91 | 2.19 | 60.76 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.18 | 8.96 | 2.82 | 54.55 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.36 | 13.40 | 2.50 | 97.07 |
| canterbury/alice29.txt | 152089 | stdx | 2.71 | 6.99 | 2.58 | 62.54 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.02 | 19.42 | 2.15 | 313.53 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.09 | 10.86 | 2.13 | 73.82 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.62 | 9.82 | 2.71 | 69.93 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.76 | 14.40 | 2.50 | 99.92 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.06 | 7.52 | 2.45 | 77.44 |
| canterbury/cp.html | 24603 | zlib | 7.10 | 17.33 | 2.44 | 173.26 |
| canterbury/cp.html | 24603 | zlib-ng | 4.31 | 9.50 | 2.20 | 47.38 |
| canterbury/cp.html | 24603 | libdeflate | 2.88 | 7.95 | 2.76 | 19.44 |
| canterbury/cp.html | 24603 | Wuffs | 5.23 | 13.91 | 2.66 | 61.26 |
| canterbury/cp.html | 24603 | stdx | 2.71 | 7.19 | 2.65 | 18.14 |
| canterbury/fields.c | 11150 | zlib | 5.28 | 17.73 | 3.36 | 39.19 |
| canterbury/fields.c | 11150 | zlib-ng | 4.03 | 10.20 | 2.53 | 25.28 |
| canterbury/fields.c | 11150 | libdeflate | 2.79 | 8.32 | 2.98 | 1.70 |
| canterbury/fields.c | 11150 | Wuffs | 4.53 | 14.54 | 3.21 | 10.89 |
| canterbury/fields.c | 11150 | stdx | 2.51 | 7.64 | 3.05 | 5.11 |
| canterbury/grammar.lsp | 3721 | zlib | 6.94 | 24.26 | 3.50 | 8.68 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.92 | 17.48 | 2.95 | 14.34 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.40 | 12.05 | 2.74 | 0.69 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.67 | 21.86 | 3.28 | 4.02 |
| canterbury/grammar.lsp | 3721 | stdx | 3.85 | 12.18 | 3.17 | 1.82 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.59 | 15.27 | 3.33 | 48.20 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.69 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.07 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.87 | 11.59 | 3.00 | 14.88 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.76 | 4.66 | 2.65 | 16.69 |
| canterbury/lcet10.txt | 426754 | zlib | 8.20 | 17.78 | 2.17 | 290.17 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 60.00 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.05 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.22 | 12.88 | 2.47 | 101.29 |
| canterbury/lcet10.txt | 426754 | stdx | 2.58 | 6.42 | 2.49 | 66.20 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.18 | 19.86 | 2.16 | 320.20 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.30 | 11.19 | 2.11 | 79.50 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.76 | 10.19 | 2.71 | 77.13 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.79 | 14.61 | 2.52 | 98.81 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.15 | 7.63 | 2.43 | 84.85 |
| canterbury/ptt5 | 513216 | zlib | 5.06 | 10.71 | 2.12 | 103.77 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.00 | 3.74 | 1.87 | 47.05 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.09 | 37.92 |
| canterbury/ptt5 | 513216 | Wuffs | 3.01 | 7.13 | 2.37 | 57.75 |
| canterbury/ptt5 | 513216 | stdx | 1.44 | 2.55 | 1.77 | 49.14 |
| canterbury/sum | 38240 | zlib | 8.02 | 18.12 | 2.26 | 226.41 |
| canterbury/sum | 38240 | zlib-ng | 4.69 | 10.02 | 2.14 | 60.60 |
| canterbury/sum | 38240 | libdeflate | 3.41 | 8.34 | 2.45 | 44.56 |
| canterbury/sum | 38240 | Wuffs | 5.85 | 14.47 | 2.48 | 84.09 |
| canterbury/sum | 38240 | stdx | 3.15 | 7.73 | 2.46 | 38.73 |
| canterbury/xargs.1 | 4227 | zlib | 7.42 | 25.22 | 3.40 | 13.35 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.47 | 17.97 | 2.77 | 16.95 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.76 | 13.27 | 2.79 | 0.39 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.21 | 22.63 | 3.14 | 10.10 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 12.86 | 3.04 | 1.94 |
| canterbury-large/E.coli | 4638690 | zlib | 6.76 | 17.84 | 2.64 | 177.65 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.24 | 9.68 | 2.29 | 47.22 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.92 | 48.31 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.66 | 12.73 | 2.73 | 61.24 |
| canterbury-large/E.coli | 4638690 | stdx | 2.49 | 6.72 | 2.69 | 54.00 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.51 | 16.46 | 2.19 | 265.47 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.79 | 8.26 | 2.18 | 53.60 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.84 | 45.46 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.81 | 11.73 | 2.44 | 100.96 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.24 | 5.57 | 2.49 | 55.83 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.70 | 15.84 | 2.06 | 280.54 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.57 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.08 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.18 | 11.48 | 2.22 | 128.12 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.73 | 5.40 | 1.98 | 90.65 |
| http/html-1kx1024 | 1048576 | zlib | 16.72 | 35.58 | 2.13 | 354.03 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.69 | 28.43 | 2.24 | 218.08 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.58 | 20.05 | 1.90 | 155.97 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.37 | 38.07 | 2.48 | 265.91 |
| http/html-1kx1024 | 1048576 | stdx | 8.38 | 20.88 | 2.49 | 137.14 |
| http/html-16kx64 | 1048576 | zlib | 6.74 | 14.77 | 2.19 | 222.62 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.61 |
| http/html-16kx64 | 1048576 | libdeflate | 2.64 | 6.04 | 2.29 | 60.78 |
| http/html-16kx64 | 1048576 | Wuffs | 4.93 | 11.57 | 2.35 | 115.21 |
| http/html-16kx64 | 1048576 | stdx | 2.53 | 5.56 | 2.20 | 59.86 |
| http/html-1m | 1048576 | zlib | 5.30 | 12.53 | 2.36 | 175.52 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 60.44 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.46 |
| http/html-1m | 1048576 | Wuffs | 3.61 | 8.48 | 2.35 | 88.07 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.10 | 52.63 |
| http/json-1kx1024 | 1048576 | zlib | 10.61 | 23.92 | 2.25 | 192.78 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.43 | 16.69 | 2.25 | 132.30 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.85 | 16.72 | 1.89 | 92.73 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.17 | 34.78 | 2.86 | 146.86 |
| http/json-1kx1024 | 1048576 | stdx | 5.02 | 13.12 | 2.61 | 80.54 |
| http/json-16kx64 | 1048576 | zlib | 4.56 | 12.51 | 2.74 | 102.93 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.64 | 5.50 | 2.08 | 52.91 |
| http/json-16kx64 | 1048576 | libdeflate | 1.92 | 4.24 | 2.21 | 40.64 |
| http/json-16kx64 | 1048576 | Wuffs | 3.50 | 9.43 | 2.70 | 57.64 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.26 | 39.63 |
| http/json-1m | 1048576 | zlib | 3.85 | 11.20 | 2.91 | 83.29 |
| http/json-1m | 1048576 | zlib-ng | 1.97 | 3.91 | 1.98 | 40.06 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.86 |
| http/json-1m | 1048576 | Wuffs | 2.73 | 7.37 | 2.70 | 43.22 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.01 | 39.93 |
| http/js-1kx1024 | 1048576 | zlib | 18.24 | 38.46 | 2.11 | 410.51 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.78 | 31.25 | 2.27 | 239.25 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.26 | 21.58 | 1.92 | 179.01 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.54 | 40.70 | 2.46 | 299.83 |
| http/js-1kx1024 | 1048576 | stdx | 9.27 | 22.85 | 2.47 | 158.98 |
| http/js-16kx64 | 1048576 | zlib | 7.67 | 16.08 | 2.10 | 264.02 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.39 | 8.65 | 1.97 | 91.72 |
| http/js-16kx64 | 1048576 | libdeflate | 3.05 | 7.01 | 2.30 | 72.09 |
| http/js-16kx64 | 1048576 | Wuffs | 5.50 | 12.75 | 2.32 | 128.78 |
| http/js-16kx64 | 1048576 | stdx | 2.99 | 6.54 | 2.19 | 71.74 |
| http/js-1m | 1048576 | zlib | 5.85 | 13.31 | 2.28 | 199.44 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 59.83 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.93 |
| http/js-1m | 1048576 | Wuffs | 3.91 | 9.14 | 2.34 | 93.70 |
| http/js-1m | 1048576 | stdx | 1.81 | 3.89 | 2.15 | 55.60 |
| http/css-1kx1024 | 1048576 | zlib | 14.05 | 30.36 | 2.16 | 282.08 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.27 | 23.04 | 2.24 | 171.79 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.17 | 17.37 | 1.89 | 121.17 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.78 | 32.50 | 2.54 | 210.49 |
| http/css-1kx1024 | 1048576 | stdx | 6.67 | 17.64 | 2.65 | 100.33 |
| http/css-16kx64 | 1048576 | zlib | 5.30 | 13.04 | 2.46 | 153.07 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.81 | 6.07 | 2.16 | 52.65 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 30.18 |
| http/css-16kx64 | 1048576 | Wuffs | 3.79 | 10.01 | 2.64 | 69.43 |
| http/css-16kx64 | 1048576 | stdx | 1.73 | 4.36 | 2.53 | 28.55 |
| http/css-1m | 1048576 | zlib | 3.97 | 10.97 | 2.76 | 106.92 |
| http/css-1m | 1048576 | zlib-ng | 1.72 | 3.75 | 2.18 | 30.76 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.97 | 13.03 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.78 | 43.62 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.52 | 21.25 |
| shuffled/dickens-1m | 1048576 | zlib | 13.31 | 25.88 | 1.94 | 373.70 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.70 | 16.72 | 1.72 | 195.80 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.03 | 14.95 | 2.13 | 194.00 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.44 | 22.08 | 2.12 | 208.56 |
| shuffled/dickens-1m | 1048576 | stdx | 7.07 | 11.89 | 1.68 | 207.85 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.52 | 14.05 | 3.99 | 3.41 |
| silesia/dickens | 10192446 | stdx | 3.66 | 12.47 | 3.40 | 3.62 |
| silesia/mozilla | 51220480 | libzstd | 2.85 | 9.68 | 3.39 | 30.19 |
| silesia/mozilla | 51220480 | stdx | 2.89 | 9.68 | 3.35 | 15.85 |
| silesia/mr | 9970564 | libzstd | 3.01 | 11.99 | 3.99 | 6.15 |
| silesia/mr | 9970564 | stdx | 3.10 | 10.83 | 3.50 | 5.22 |
| silesia/nci | 33553445 | libzstd | 1.71 | 4.88 | 2.84 | 24.92 |
| silesia/nci | 33553445 | stdx | 1.85 | 4.63 | 2.50 | 13.73 |
| silesia/ooffice | 6152192 | libzstd | 3.39 | 12.19 | 3.60 | 31.08 |
| silesia/ooffice | 6152192 | stdx | 3.37 | 12.40 | 3.68 | 12.29 |
| silesia/osdb | 10085684 | libzstd | 2.38 | 8.45 | 3.55 | 15.01 |
| silesia/osdb | 10085684 | stdx | 2.45 | 8.11 | 3.31 | 15.35 |
| silesia/reymont | 6627202 | libzstd | 3.20 | 11.62 | 3.63 | 11.62 |
| silesia/reymont | 6627202 | stdx | 3.31 | 10.36 | 3.13 | 12.97 |
| silesia/samba | 21606400 | libzstd | 2.11 | 7.41 | 3.51 | 18.65 |
| silesia/samba | 21606400 | stdx | 2.22 | 6.83 | 3.07 | 17.86 |
| silesia/sao | 7251944 | libzstd | 3.85 | 12.72 | 3.31 | 26.78 |
| silesia/sao | 7251944 | stdx | 3.59 | 12.58 | 3.51 | 6.25 |
| silesia/webster | 41458703 | libzstd | 3.33 | 11.24 | 3.38 | 16.26 |
| silesia/webster | 41458703 | stdx | 3.54 | 10.05 | 2.84 | 17.55 |
| silesia/x-ray | 8474240 | libzstd | 3.91 | 14.94 | 3.82 | 19.01 |
| silesia/x-ray | 8474240 | stdx | 3.66 | 13.23 | 3.62 | 8.42 |
| silesia/xml | 5345280 | libzstd | 1.57 | 5.57 | 3.55 | 23.35 |
| silesia/xml | 5345280 | stdx | 1.53 | 5.16 | 3.38 | 17.10 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.89 | 4.07 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.35 | 0.40 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.95 | 14.26 | 4.84 | 3.23 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.30 | 0.30 |
| canterbury/cp.html | 24603 | libzstd | 2.63 | 10.74 | 4.08 | 7.39 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.11 | 0.16 |
| canterbury/fields.c | 11150 | libzstd | 3.12 | 13.62 | 4.37 | 8.95 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.22 | 0.19 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.18 | 16.94 | 4.05 | 4.55 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.54 | 4.01 | 0.20 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.53 | 11.40 | 4.50 | 7.84 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.68 | 11.32 | 4.22 | 0.90 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.70 | 12.89 | 4.77 | 5.13 |
| canterbury/lcet10.txt | 426754 | stdx | 2.73 | 11.52 | 4.22 | 3.94 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.10 | 15.16 | 4.88 | 1.55 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.28 | 0.79 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.52 | 3.12 | 25.15 |
| canterbury/ptt5 | 513216 | stdx | 1.33 | 4.46 | 3.36 | 13.06 |
| canterbury/sum | 38240 | libzstd | 2.62 | 10.58 | 4.05 | 9.88 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.09 | 0.29 |
| canterbury/xargs.1 | 4227 | libzstd | 4.24 | 17.41 | 4.10 | 8.76 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.17 | 4.05 | 0.57 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.00 | 13.64 | 4.55 | 2.15 |
| canterbury-large/E.coli | 4638690 | stdx | 3.10 | 12.04 | 3.88 | 2.87 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.99 | 12.00 | 4.01 | 8.46 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.11 | 10.64 | 3.42 | 9.30 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.57 | 9.60 | 3.73 | 19.99 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.65 | 8.64 | 3.26 | 21.08 |
| http/html-1kx1024 | 1048576 | libzstd | 7.25 | 21.63 | 2.98 | 62.99 |
| http/html-1kx1024 | 1048576 | stdx | 7.46 | 22.46 | 3.01 | 76.69 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.68 |
| http/html-16kx64 | 1048576 | stdx | 2.68 | 9.61 | 3.59 | 31.57 |
| http/html-1m | 1048576 | libzstd | 2.01 | 7.88 | 3.92 | 24.36 |
| http/html-1m | 1048576 | stdx | 2.00 | 7.12 | 3.55 | 24.83 |
| http/json-1kx1024 | 1048576 | libzstd | 6.27 | 17.39 | 2.77 | 49.76 |
| http/json-1kx1024 | 1048576 | stdx | 6.21 | 17.86 | 2.87 | 53.48 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.26 | 3.54 | 28.32 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.57 | 20.07 |
| http/json-1m | 1048576 | libzstd | 1.72 | 6.08 | 3.53 | 27.74 |
| http/json-1m | 1048576 | stdx | 1.64 | 5.91 | 3.61 | 14.51 |
| http/js-1kx1024 | 1048576 | libzstd | 8.33 | 26.35 | 3.16 | 73.49 |
| http/js-1kx1024 | 1048576 | stdx | 9.04 | 27.60 | 3.05 | 113.58 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.72 | 4.00 | 24.47 |
| http/js-16kx64 | 1048576 | stdx | 2.97 | 11.06 | 3.72 | 27.01 |
| http/js-1m | 1048576 | libzstd | 2.03 | 8.19 | 4.04 | 20.51 |
| http/js-1m | 1048576 | stdx | 2.08 | 7.48 | 3.60 | 21.91 |
| http/css-1kx1024 | 1048576 | libzstd | 6.88 | 19.69 | 2.86 | 53.34 |
| http/css-1kx1024 | 1048576 | stdx | 6.85 | 19.96 | 2.92 | 63.97 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.70 | 3.88 | 22.71 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.21 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.58 | 3.85 | 5.37 |
| http/css-1m | 1048576 | stdx | 0.72 | 2.49 | 3.45 | 4.45 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.77 | 9.40 | 3.39 | 28.53 |
| shuffled/dickens-1m | 1048576 | stdx | 2.74 | 9.19 | 3.36 | 12.93 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.51 | 16.93 | 2.25 | 100.28 |
| silesia/dickens | 1048576 | stdx | 5.13 | 12.38 | 2.41 | 54.55 |
| silesia/mozilla | 1048576 | Google | 13.48 | 28.31 | 2.10 | 46.32 |
| silesia/mozilla | 1048576 | stdx | 8.34 | 15.02 | 1.80 | 47.71 |
| silesia/mr | 1048576 | Google | 8.92 | 20.21 | 2.27 | 103.08 |
| silesia/mr | 1048576 | stdx | 5.79 | 13.25 | 2.29 | 88.30 |
| silesia/nci | 1048576 | Google | 2.55 | 5.70 | 2.23 | 52.11 |
| silesia/nci | 1048576 | stdx | 1.95 | 3.95 | 2.03 | 55.15 |
| silesia/ooffice | 1048576 | Google | 14.17 | 29.27 | 2.07 | 288.20 |
| silesia/ooffice | 1048576 | stdx | 10.90 | 20.33 | 1.86 | 324.37 |
| silesia/osdb | 1048576 | Google | 8.22 | 17.48 | 2.13 | 95.92 |
| silesia/osdb | 1048576 | stdx | 5.16 | 10.57 | 2.05 | 91.78 |
| silesia/reymont | 1048576 | Google | 5.41 | 12.62 | 2.33 | 82.32 |
| silesia/reymont | 1048576 | stdx | 3.72 | 9.25 | 2.49 | 47.26 |
| silesia/samba | 1048576 | Google | 7.60 | 16.30 | 2.15 | 95.11 |
| silesia/samba | 1048576 | stdx | 5.07 | 10.71 | 2.11 | 67.14 |
| silesia/sao | 1048576 | Google | 16.82 | 37.18 | 2.21 | 162.67 |
| silesia/sao | 1048576 | stdx | 10.42 | 22.65 | 2.17 | 142.18 |
| silesia/webster | 1048576 | Google | 6.54 | 14.00 | 2.14 | 113.78 |
| silesia/webster | 1048576 | stdx | 4.42 | 9.98 | 2.26 | 69.05 |
| silesia/x-ray | 1048576 | Google | 19.29 | 38.56 | 2.00 | 235.08 |
| silesia/x-ray | 1048576 | stdx | 14.71 | 30.18 | 2.05 | 234.55 |
| silesia/xml | 1048576 | Google | 3.46 | 7.61 | 2.20 | 65.35 |
| silesia/xml | 1048576 | stdx | 2.41 | 5.40 | 2.24 | 46.64 |
| canterbury/alice29.txt | 152089 | Google | 8.85 | 20.55 | 2.32 | 133.79 |
| canterbury/alice29.txt | 152089 | stdx | 6.07 | 15.33 | 2.53 | 81.41 |
| canterbury/asyoulik.txt | 125179 | Google | 10.35 | 23.71 | 2.29 | 167.15 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.06 | 17.43 | 2.47 | 102.03 |
| canterbury/cp.html | 24603 | Google | 9.05 | 22.20 | 2.45 | 112.13 |
| canterbury/cp.html | 24603 | stdx | 5.89 | 17.15 | 2.91 | 41.33 |
| canterbury/fields.c | 11150 | Google | 7.08 | 21.16 | 2.99 | 26.05 |
| canterbury/fields.c | 11150 | stdx | 4.91 | 17.08 | 3.48 | 2.41 |
| canterbury/grammar.lsp | 3721 | Google | 9.83 | 30.16 | 3.07 | 6.58 |
| canterbury/grammar.lsp | 3721 | stdx | 7.17 | 25.04 | 3.49 | 0.49 |
| canterbury/kennedy.xls | 1029744 | Google | 5.46 | 17.05 | 3.13 | 37.36 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.81 | 12.94 | 3.39 | 33.93 |
| canterbury/lcet10.txt | 426754 | Google | 7.74 | 17.36 | 2.24 | 125.98 |
| canterbury/lcet10.txt | 426754 | stdx | 5.19 | 12.96 | 2.50 | 66.28 |
| canterbury/plrabn12.txt | 481861 | Google | 9.09 | 20.82 | 2.29 | 132.78 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.14 | 15.04 | 2.45 | 87.10 |
| canterbury/ptt5 | 513216 | Google | 4.27 | 10.41 | 2.44 | 61.80 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.07 | 65.69 |
| canterbury/sum | 38240 | Google | 10.83 | 26.44 | 2.44 | 157.40 |
| canterbury/sum | 38240 | stdx | 8.30 | 21.11 | 2.54 | 154.18 |
| canterbury/xargs.1 | 4227 | Google | 11.01 | 34.81 | 3.16 | 12.07 |
| canterbury/xargs.1 | 4227 | stdx | 8.52 | 30.44 | 3.57 | 6.31 |
| canterbury-large/E.coli | 1048576 | Google | 8.15 | 19.55 | 2.40 | 1.66 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.06 |
| canterbury-large/bible.txt | 1048576 | Google | 5.34 | 12.28 | 2.30 | 80.92 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.54 | 8.93 | 2.52 | 40.00 |
| canterbury-large/world192.txt | 1048576 | Google | 6.20 | 12.84 | 2.07 | 114.73 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.43 | 9.38 | 2.12 | 77.39 |
| http/html-1kx1024 | 1048576 | Google | 18.05 | 41.93 | 2.32 | 387.14 |
| http/html-1kx1024 | 1048576 | stdx | 15.33 | 37.56 | 2.45 | 361.42 |
| http/html-16kx64 | 1048576 | Google | 6.73 | 14.85 | 2.21 | 149.48 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.50 |
| http/html-1m | 1048576 | Google | 4.06 | 8.94 | 2.20 | 83.12 |
| http/html-1m | 1048576 | stdx | 2.87 | 6.52 | 2.28 | 55.04 |
| http/json-1kx1024 | 1048576 | Google | 14.48 | 36.64 | 2.53 | 240.51 |
| http/json-1kx1024 | 1048576 | stdx | 13.00 | 33.63 | 2.59 | 276.52 |
| http/json-16kx64 | 1048576 | Google | 4.41 | 11.43 | 2.59 | 81.54 |
| http/json-16kx64 | 1048576 | stdx | 3.36 | 8.42 | 2.50 | 83.10 |
| http/json-1m | 1048576 | Google | 3.41 | 8.65 | 2.54 | 59.02 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.43 | 57.81 |
| http/js-1kx1024 | 1048576 | Google | 19.95 | 46.20 | 2.32 | 429.32 |
| http/js-1kx1024 | 1048576 | stdx | 16.42 | 39.90 | 2.43 | 381.70 |
| http/js-16kx64 | 1048576 | Google | 8.03 | 17.73 | 2.21 | 167.57 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.49 |
| http/js-1m | 1048576 | Google | 4.37 | 9.54 | 2.18 | 82.99 |
| http/js-1m | 1048576 | stdx | 3.17 | 7.25 | 2.28 | 55.44 |
| http/css-1kx1024 | 1048576 | Google | 15.49 | 37.36 | 2.41 | 293.23 |
| http/css-1kx1024 | 1048576 | stdx | 13.80 | 34.70 | 2.51 | 302.00 |
| http/css-16kx64 | 1048576 | Google | 4.94 | 11.76 | 2.38 | 101.77 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.49 | 80.65 |
| http/css-1m | 1048576 | Google | 2.44 | 9.42 | 3.86 | 16.68 |
| http/css-1m | 1048576 | stdx | 0.76 | 1.86 | 2.45 | 12.01 |
| shuffled/dickens-1m | 1048576 | Google | 10.21 | 20.65 | 2.02 | 110.15 |
| shuffled/dickens-1m | 1048576 | stdx | 8.79 | 14.53 | 1.65 | 119.93 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.27 | 36.91 | 2.42 | 411.30 |
| silesia/dickens | 10192446 | 1 | stdx | 16.42 | 38.17 | 2.32 | 359.27 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.18 | 87.63 | 1.68 | 697.95 |
| silesia/dickens | 10192446 | 6 | stdx | 49.50 | 84.26 | 1.70 | 1426.06 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.89 | 160.47 | 1.43 | 931.63 |
| silesia/dickens | 10192446 | 9 | stdx | 84.83 | 191.80 | 2.26 | 1720.50 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.16 | 32.62 | 2.30 | 440.57 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.37 | 30.24 | 2.26 | 295.34 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.94 | 70.83 | 2.15 | 579.13 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.57 | 69.96 | 2.22 | 733.10 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.60 | 221.49 | 1.74 | 768.34 |
| silesia/mozilla | 51220480 | 9 | stdx | 49.02 | 126.12 | 2.57 | 789.86 |
| silesia/mr | 9970564 | 1 | libdeflate | 12.02 | 35.02 | 2.91 | 230.73 |
| silesia/mr | 9970564 | 1 | stdx | 12.64 | 34.08 | 2.70 | 187.70 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.30 | 80.54 | 2.10 | 436.48 |
| silesia/mr | 9970564 | 6 | stdx | 39.57 | 83.18 | 2.10 | 957.31 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.68 | 165.48 | 1.69 | 754.26 |
| silesia/mr | 9970564 | 9 | stdx | 87.13 | 206.31 | 2.37 | 1329.68 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.25 | 18.42 | 2.94 | 117.18 |
| silesia/nci | 33553445 | 1 | stdx | 4.99 | 10.88 | 2.18 | 97.92 |
| silesia/nci | 33553445 | 6 | libdeflate | 17.05 | 34.84 | 2.04 | 226.29 |
| silesia/nci | 33553445 | 6 | stdx | 14.39 | 29.54 | 2.05 | 390.16 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.44 | 105.28 | 1.69 | 498.87 |
| silesia/nci | 33553445 | 9 | stdx | 33.12 | 80.63 | 2.43 | 648.97 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.98 | 39.15 | 1.96 | 754.49 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.81 | 39.08 | 2.19 | 431.12 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 41.11 | 79.10 | 1.92 | 953.67 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.61 | 87.83 | 2.11 | 1009.94 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.63 | 127.63 | 1.71 | 1134.10 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.59 | 129.17 | 2.46 | 931.65 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.96 | 30.15 | 2.33 | 356.55 |
| silesia/osdb | 10085684 | 1 | stdx | 12.99 | 27.86 | 2.14 | 294.18 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.38 | 55.67 | 1.96 | 491.90 |
| silesia/osdb | 10085684 | 6 | stdx | 27.03 | 57.40 | 2.12 | 561.58 |
| silesia/osdb | 10085684 | 9 | libdeflate | 34.02 | 64.15 | 1.89 | 554.63 |
| silesia/osdb | 10085684 | 9 | stdx | 35.55 | 87.23 | 2.45 | 694.58 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.64 | 32.88 | 2.60 | 310.92 |
| silesia/reymont | 6627202 | 1 | stdx | 13.59 | 33.24 | 2.45 | 272.93 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.19 | 86.58 | 1.80 | 519.63 |
| silesia/reymont | 6627202 | 6 | stdx | 45.18 | 76.82 | 1.70 | 1405.62 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.06 | 276.14 | 1.39 | 828.91 |
| silesia/reymont | 6627202 | 9 | stdx | 87.15 | 189.97 | 2.18 | 1604.75 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.46 | 26.53 | 2.54 | 273.16 |
| silesia/samba | 21606400 | 1 | stdx | 9.92 | 22.23 | 2.24 | 221.05 |
| silesia/samba | 21606400 | 6 | libdeflate | 29.04 | 58.79 | 2.02 | 386.09 |
| silesia/samba | 21606400 | 6 | stdx | 24.12 | 49.84 | 2.07 | 621.59 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.23 | 141.44 | 1.68 | 503.26 |
| silesia/samba | 21606400 | 9 | stdx | 41.55 | 102.63 | 2.47 | 730.92 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.73 | 47.87 | 2.20 | 686.00 |
| silesia/sao | 7251944 | 1 | stdx | 19.19 | 49.92 | 2.60 | 346.21 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.24 | 96.89 | 1.89 | 964.62 |
| silesia/sao | 7251944 | 6 | stdx | 47.08 | 105.65 | 2.24 | 845.77 |
| silesia/sao | 7251944 | 9 | libdeflate | 71.09 | 120.26 | 1.69 | 1111.29 |
| silesia/sao | 7251944 | 9 | stdx | 55.62 | 138.16 | 2.48 | 846.41 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.12 | 30.45 | 2.32 | 387.38 |
| silesia/webster | 41458703 | 1 | stdx | 13.87 | 29.08 | 2.10 | 340.49 |
| silesia/webster | 41458703 | 6 | libdeflate | 37.12 | 66.02 | 1.78 | 571.57 |
| silesia/webster | 41458703 | 6 | stdx | 35.14 | 60.88 | 1.73 | 1103.18 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.65 | 138.85 | 1.47 | 755.90 |
| silesia/webster | 41458703 | 9 | stdx | 60.68 | 135.96 | 2.24 | 1292.70 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.70 | 49.67 | 2.10 | 784.83 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.62 | 50.81 | 2.88 | 262.15 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.97 | 82.77 | 2.51 | 853.17 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.85 | 98.11 | 2.90 | 541.80 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.60 | 91.03 | 2.42 | 1032.27 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.96 | 122.05 | 2.98 | 466.30 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.83 | 21.59 | 2.76 | 177.16 |
| silesia/xml | 5345280 | 1 | stdx | 7.11 | 15.66 | 2.20 | 155.35 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.31 | 40.51 | 1.90 | 265.96 |
| silesia/xml | 5345280 | 6 | stdx | 17.75 | 34.32 | 1.93 | 496.43 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.74 | 89.17 | 1.52 | 372.21 |
| silesia/xml | 5345280 | 9 | stdx | 31.17 | 72.83 | 2.34 | 600.11 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.28 | 35.61 | 2.49 | 380.76 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.01 | 36.12 | 2.41 | 335.01 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 47.02 | 82.29 | 1.75 | 643.64 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.72 | 77.43 | 1.77 | 1308.75 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 108.03 | 159.21 | 1.47 | 853.90 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 72.67 | 167.73 | 2.31 | 1511.35 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.15 | 37.20 | 2.46 | 416.50 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.76 | 37.43 | 2.37 | 358.88 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.38 | 85.43 | 1.77 | 716.79 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.19 | 81.93 | 1.77 | 1386.62 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.99 | 136.15 | 1.53 | 943.04 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 75.49 | 175.97 | 2.33 | 1608.35 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.65 | 32.02 | 2.75 | 280.65 |
| canterbury/cp.html | 24603 | 1 | stdx | 10.89 | 27.13 | 2.49 | 237.90 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 27.02 | 62.33 | 2.31 | 487.64 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.59 | 57.06 | 2.42 | 608.82 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.99 | 91.97 | 1.96 | 603.85 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.23 | 88.89 | 2.85 | 649.27 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.35 | 35.92 | 3.84 | 54.60 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.04 | 30.05 | 3.74 | 20.93 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.32 | 69.37 | 2.85 | 234.18 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.81 | 57.62 | 2.77 | 430.88 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.59 | 100.81 | 2.26 | 427.87 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.54 | 92.66 | 3.25 | 458.79 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.02 | 51.51 | 3.96 | 13.57 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.89 | 39.01 | 3.95 | 2.29 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.75 | 87.06 | 3.67 | 26.82 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.15 | 70.81 | 4.13 | 15.10 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.88 | 102.89 | 3.33 | 45.16 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.75 | 99.31 | 4.18 | 72.56 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.38 | 27.18 | 3.68 | 65.49 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.07 | 22.58 | 3.20 | 63.41 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 28.02 | 73.85 | 2.64 | 96.35 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.38 | 61.99 | 3.20 | 138.69 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.42 | 664.23 | 1.83 | 167.44 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.74 | 130.89 | 3.47 | 221.11 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.80 | 33.99 | 2.46 | 372.93 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.47 | 33.92 | 2.34 | 330.03 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.07 | 78.22 | 1.74 | 607.81 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.69 | 73.43 | 1.76 | 1219.62 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.73 | 136.94 | 1.49 | 806.13 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 70.64 | 162.24 | 2.30 | 1449.12 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.82 | 38.62 | 2.44 | 426.93 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.73 | 40.24 | 2.41 | 370.08 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.21 | 91.90 | 1.70 | 754.45 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.53 | 88.90 | 1.73 | 1492.95 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 117.02 | 166.26 | 1.42 | 1005.85 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 88.55 | 201.33 | 2.27 | 1799.95 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.43 | 18.61 | 2.90 | 142.54 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.98 | 11.03 | 2.21 | 123.08 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.31 | 36.17 | 2.53 | 219.51 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.34 | 29.58 | 2.40 | 307.88 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.57 | 120.86 | 2.00 | 374.95 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.12 | 130.09 | 3.02 | 639.05 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.87 | 33.49 | 2.60 | 342.51 |
| canterbury/sum | 38240 | 1 | stdx | 12.44 | 29.36 | 2.36 | 291.67 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.61 | 69.87 | 2.44 | 496.70 |
| canterbury/sum | 38240 | 6 | stdx | 26.67 | 65.74 | 2.46 | 661.32 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.43 | 181.91 | 1.93 | 606.27 |
| canterbury/sum | 38240 | 9 | stdx | 39.23 | 112.33 | 2.86 | 654.48 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.27 | 53.06 | 4.00 | 22.55 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.62 | 43.10 | 4.06 | 1.91 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 23.00 | 87.70 | 3.81 | 68.89 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 17.93 | 74.35 | 4.15 | 41.65 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 25.04 | 94.34 | 3.77 | 96.65 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.49 | 106.96 | 4.04 | 143.36 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.07 | 40.47 | 3.35 | 163.22 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.81 | 42.29 | 3.30 | 101.82 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.30 | 395.99 | 2.16 | 262.77 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.98 | 374.12 | 3.04 | 1918.63 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.63 | 1063.49 | 1.30 | 1310.65 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 228.59 | 755.68 | 3.31 | 2420.82 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.60 | 32.38 | 2.57 | 313.00 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.57 | 32.23 | 2.38 | 281.81 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.19 | 80.12 | 1.73 | 524.76 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.14 | 72.39 | 1.72 | 1243.71 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.67 | 200.28 | 1.41 | 742.02 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.20 | 170.21 | 2.23 | 1444.48 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.38 | 29.72 | 2.22 | 415.78 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.38 | 28.55 | 1.99 | 378.62 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.29 | 60.25 | 1.81 | 560.86 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.22 | 56.80 | 1.76 | 991.38 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.72 | 119.11 | 1.48 | 685.97 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 51.94 | 117.95 | 2.27 | 1148.14 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.41 | 103.92 | 2.93 | 456.84 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.52 | 58.63 | 2.72 | 366.39 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.32 | 138.33 | 2.99 | 563.11 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 32.20 | 94.31 | 2.93 | 532.07 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 48.18 | 142.44 | 2.96 | 590.81 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 36.28 | 112.13 | 3.09 | 539.29 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.49 | 27.96 | 2.67 | 269.20 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.06 | 20.25 | 2.24 | 233.68 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.45 | 52.09 | 2.32 | 394.81 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.96 | 42.86 | 2.26 | 536.79 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 35.15 | 72.54 | 2.06 | 464.35 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.91 | 69.05 | 2.77 | 552.60 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.79 | 23.03 | 2.62 | 225.19 |
| http/html-1m | 1048576 | 1 | stdx | 8.18 | 17.79 | 2.18 | 205.68 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.44 | 49.53 | 1.95 | 329.76 |
| http/html-1m | 1048576 | 6 | stdx | 21.30 | 40.71 | 1.91 | 618.41 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.23 | 109.24 | 1.53 | 430.49 |
| http/html-1m | 1048576 | 9 | stdx | 35.90 | 85.76 | 2.39 | 706.08 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.81 | 94.80 | 2.98 | 303.17 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.63 | 45.16 | 2.72 | 242.51 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.11 | 126.60 | 2.94 | 371.93 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.37 | 78.37 | 2.86 | 380.55 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.54 | 142.45 | 2.71 | 433.23 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.92 | 95.56 | 3.09 | 386.77 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.88 | 23.85 | 3.03 | 135.84 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.47 | 13.94 | 2.55 | 110.54 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.25 | 46.61 | 2.55 | 206.43 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.52 | 35.01 | 2.59 | 280.08 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.30 | 151.99 | 1.89 | 296.92 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.27 | 58.45 | 3.03 | 303.20 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.75 | 19.85 | 2.94 | 125.58 |
| http/json-1m | 1048576 | 1 | stdx | 5.08 | 12.51 | 2.46 | 103.21 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.38 | 45.30 | 2.22 | 175.94 |
| http/json-1m | 1048576 | 6 | stdx | 14.75 | 35.09 | 2.38 | 298.25 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.73 | 205.21 | 1.69 | 276.56 |
| http/json-1m | 1048576 | 9 | stdx | 29.19 | 72.87 | 2.50 | 369.23 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.11 | 107.80 | 2.90 | 521.07 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.81 | 65.40 | 2.75 | 412.12 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.42 | 144.85 | 2.93 | 676.82 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 35.94 | 104.12 | 2.90 | 621.25 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 52.08 | 150.13 | 2.88 | 714.73 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 40.50 | 125.13 | 3.09 | 626.50 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.76 | 30.90 | 2.63 | 310.67 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.92 | 24.80 | 2.27 | 273.86 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 26.06 | 59.43 | 2.28 | 475.56 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.85 | 50.05 | 2.19 | 675.90 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 41.01 | 83.31 | 2.03 | 564.09 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.76 | 81.30 | 2.73 | 665.50 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.66 | 25.19 | 2.61 | 247.95 |
| http/js-1m | 1048576 | 1 | stdx | 9.58 | 21.31 | 2.22 | 232.53 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.90 | 56.12 | 1.94 | 371.74 |
| http/js-1m | 1048576 | 6 | stdx | 24.97 | 46.64 | 1.87 | 735.90 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.44 | 120.65 | 1.58 | 498.59 |
| http/js-1m | 1048576 | 9 | stdx | 42.16 | 100.01 | 2.37 | 813.51 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.26 | 97.73 | 2.94 | 377.45 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.49 | 49.52 | 2.68 | 300.99 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.88 | 129.22 | 2.95 | 477.92 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.30 | 82.32 | 2.81 | 507.07 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 46.25 | 133.80 | 2.89 | 510.87 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.31 | 99.48 | 2.99 | 521.69 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.66 | 25.60 | 2.96 | 174.65 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.75 | 16.96 | 2.51 | 135.16 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.28 | 48.80 | 2.41 | 290.37 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.45 | 38.00 | 2.31 | 459.72 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.98 | 82.40 | 2.01 | 371.94 |
| http/css-16kx64 | 1048576 | 9 | stdx | 23.04 | 65.13 | 2.83 | 481.85 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.94 | 21.15 | 3.05 | 132.75 |
| http/css-1m | 1048576 | 1 | stdx | 5.80 | 14.91 | 2.57 | 108.66 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.83 | 44.50 | 2.14 | 226.65 |
| http/css-1m | 1048576 | 6 | stdx | 16.61 | 35.61 | 2.14 | 440.29 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.93 | 111.58 | 1.60 | 308.01 |
| http/css-1m | 1048576 | 9 | stdx | 32.20 | 83.00 | 2.58 | 512.37 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.23 | 48.89 | 1.94 | 929.05 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.19 | 49.19 | 2.70 | 323.02 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.68 | 86.45 | 2.07 | 1181.80 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.91 | 88.80 | 2.23 | 855.94 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.18 | 94.50 | 2.00 | 1343.90 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.12 | 134.38 | 2.48 | 1138.16 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.09 | 31.22 | 3.09 | 119.11 |
| silesia/dickens | 10192446 | 1 | stdx | 24.37 | 82.03 | 3.37 | 125.68 |
| silesia/dickens | 10192446 | 3 | libzstd | 23.41 | 34.39 | 1.47 | 170.86 |
| silesia/dickens | 10192446 | 3 | stdx | 37.52 | 78.22 | 2.08 | 182.48 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.07 | 22.69 | 3.21 | 70.77 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.78 | 54.73 | 3.08 | 177.05 |
| silesia/mozilla | 51220480 | 3 | libzstd | 17.72 | 27.89 | 1.57 | 102.38 |
| silesia/mozilla | 51220480 | 3 | stdx | 32.31 | 62.01 | 1.92 | 145.10 |
| silesia/mr | 9970564 | 1 | libzstd | 7.71 | 24.81 | 3.22 | 57.01 |
| silesia/mr | 9970564 | 1 | stdx | 20.02 | 66.82 | 3.34 | 114.14 |
| silesia/mr | 9970564 | 3 | libzstd | 20.77 | 32.19 | 1.55 | 86.96 |
| silesia/mr | 9970564 | 3 | stdx | 35.34 | 72.46 | 2.05 | 114.47 |
| silesia/nci | 33553445 | 1 | libzstd | 3.54 | 9.55 | 2.70 | 57.84 |
| silesia/nci | 33553445 | 1 | stdx | 7.79 | 25.69 | 3.30 | 58.59 |
| silesia/nci | 33553445 | 3 | libzstd | 5.60 | 9.95 | 1.78 | 56.57 |
| silesia/nci | 33553445 | 3 | stdx | 11.73 | 29.15 | 2.48 | 66.49 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.58 | 29.26 | 3.41 | 70.72 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.27 | 72.51 | 3.12 | 179.70 |
| silesia/ooffice | 6152192 | 3 | libzstd | 24.65 | 39.44 | 1.60 | 119.82 |
| silesia/ooffice | 6152192 | 3 | stdx | 44.22 | 82.20 | 1.86 | 185.77 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.07 | 22.29 | 3.15 | 66.20 |
| silesia/osdb | 10085684 | 1 | stdx | 16.51 | 50.52 | 3.06 | 123.69 |
| silesia/osdb | 10085684 | 3 | libzstd | 18.68 | 26.23 | 1.40 | 68.13 |
| silesia/osdb | 10085684 | 3 | stdx | 33.74 | 57.87 | 1.71 | 111.81 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.73 | 27.13 | 2.79 | 150.68 |
| silesia/reymont | 6627202 | 1 | stdx | 20.24 | 72.05 | 3.56 | 96.41 |
| silesia/reymont | 6627202 | 3 | libzstd | 19.12 | 27.10 | 1.42 | 125.86 |
| silesia/reymont | 6627202 | 3 | stdx | 29.36 | 62.18 | 2.12 | 147.33 |
| silesia/samba | 21606400 | 1 | libzstd | 5.96 | 16.88 | 2.83 | 85.70 |
| silesia/samba | 21606400 | 1 | stdx | 13.63 | 42.89 | 3.15 | 124.74 |
| silesia/samba | 21606400 | 3 | libzstd | 12.41 | 18.81 | 1.52 | 98.97 |
| silesia/samba | 21606400 | 3 | stdx | 21.38 | 44.75 | 2.09 | 133.41 |
| silesia/sao | 7251944 | 1 | libzstd | 9.06 | 33.69 | 3.72 | 44.88 |
| silesia/sao | 7251944 | 1 | stdx | 26.04 | 82.03 | 3.15 | 106.26 |
| silesia/sao | 7251944 | 3 | libzstd | 32.27 | 50.03 | 1.55 | 94.64 |
| silesia/sao | 7251944 | 3 | stdx | 54.23 | 95.22 | 1.76 | 142.73 |
| silesia/webster | 41458703 | 1 | libzstd | 8.68 | 24.94 | 2.87 | 130.93 |
| silesia/webster | 41458703 | 1 | stdx | 20.40 | 64.04 | 3.14 | 165.86 |
| silesia/webster | 41458703 | 3 | libzstd | 19.87 | 27.33 | 1.38 | 177.42 |
| silesia/webster | 41458703 | 3 | stdx | 32.49 | 64.55 | 1.99 | 194.47 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.81 | 14.92 | 3.10 | 17.38 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.94 | 76.64 | 3.20 | 91.73 |
| silesia/x-ray | 8474240 | 3 | libzstd | 32.72 | 52.73 | 1.61 | 87.84 |
| silesia/x-ray | 8474240 | 3 | stdx | 50.31 | 92.40 | 1.84 | 108.57 |
| silesia/xml | 5345280 | 1 | libzstd | 4.25 | 11.71 | 2.76 | 71.44 |
| silesia/xml | 5345280 | 1 | stdx | 10.48 | 34.21 | 3.26 | 93.88 |
| silesia/xml | 5345280 | 3 | libzstd | 6.95 | 12.61 | 1.81 | 77.63 |
| silesia/xml | 5345280 | 3 | stdx | 13.23 | 32.28 | 2.44 | 115.37 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.79 | 32.84 | 3.04 | 139.14 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.47 | 76.49 | 3.41 | 188.13 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.55 | 39.48 | 2.54 | 202.91 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.72 | 73.76 | 2.76 | 334.51 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.73 | 33.55 | 3.45 | 104.73 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.61 | 79.00 | 3.35 | 212.85 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.31 | 39.27 | 2.57 | 210.31 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 29.11 | 79.30 | 2.72 | 372.15 |
| canterbury/cp.html | 24603 | 1 | libzstd | 6.91 | 26.64 | 3.85 | 37.06 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.06 | 57.76 | 3.60 | 118.76 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.47 | 31.85 | 3.36 | 46.58 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.11 | 59.76 | 3.30 | 137.56 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.52 | 31.76 | 3.73 | 32.86 |
| canterbury/fields.c | 11150 | 1 | stdx | 16.99 | 65.73 | 3.87 | 83.85 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.62 | 34.13 | 3.55 | 46.16 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.27 | 64.68 | 3.74 | 91.88 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.43 | 38.01 | 4.03 | 8.63 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.24 | 77.57 | 3.83 | 51.65 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.69 | 43.09 | 4.03 | 10.75 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.43 | 79.60 | 3.71 | 68.39 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.05 | 23.56 | 3.90 | 14.89 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.85 | 56.75 | 3.82 | 83.38 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.62 | 23.80 | 2.76 | 27.64 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 21.32 | 56.61 | 2.65 | 109.33 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.83 | 28.52 | 2.90 | 156.27 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.57 | 72.02 | 3.34 | 160.33 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 16.54 | 32.14 | 1.94 | 201.67 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 27.18 | 67.10 | 2.47 | 296.24 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.29 | 32.37 | 3.15 | 128.15 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.19 | 84.16 | 3.34 | 157.92 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 20.23 | 38.77 | 1.92 | 226.19 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 32.79 | 80.77 | 2.46 | 342.52 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.16 | 8.51 | 2.69 | 67.42 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.58 | 23.15 | 3.05 | 104.51 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 4.93 | 10.97 | 2.23 | 59.22 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.78 | 24.08 | 2.46 | 132.55 |
| canterbury/sum | 38240 | 1 | libzstd | 6.46 | 25.39 | 3.93 | 28.75 |
| canterbury/sum | 38240 | 1 | stdx | 16.97 | 59.13 | 3.48 | 148.08 |
| canterbury/sum | 38240 | 3 | libzstd | 9.11 | 30.67 | 3.37 | 45.40 |
| canterbury/sum | 38240 | 3 | stdx | 19.79 | 61.82 | 3.12 | 180.08 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 9.97 | 39.82 | 3.99 | 12.00 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.87 | 80.38 | 3.85 | 60.61 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.30 | 48.17 | 3.92 | 19.69 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.90 | 83.98 | 3.67 | 80.10 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.36 | 33.44 | 3.23 | 76.64 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.94 | 95.62 | 4.36 | 7.27 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 15.61 | 31.30 | 2.00 | 36.00 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 24.52 | 70.38 | 2.87 | 38.12 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.77 | 27.45 | 2.81 | 149.63 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.64 | 71.86 | 3.48 | 108.38 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 18.79 | 28.20 | 1.50 | 133.67 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 29.31 | 63.36 | 2.16 | 155.65 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.20 | 22.70 | 2.77 | 137.66 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.81 | 55.86 | 2.97 | 191.71 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 15.90 | 23.87 | 1.50 | 174.43 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 26.21 | 51.26 | 1.96 | 237.16 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.08 | 52.46 | 3.07 | 160.23 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 36.37 | 100.54 | 2.76 | 639.76 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 18.99 | 59.20 | 3.12 | 197.08 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 38.63 | 104.00 | 2.69 | 632.33 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.71 | 22.46 | 2.91 | 122.44 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.24 | 46.84 | 3.29 | 181.69 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.75 | 24.61 | 2.81 | 141.67 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.67 | 47.61 | 3.04 | 191.39 |
| http/html-1m | 1048576 | 1 | libzstd | 6.27 | 16.74 | 2.67 | 115.12 |
| http/html-1m | 1048576 | 1 | stdx | 13.07 | 42.00 | 3.21 | 134.54 |
| http/html-1m | 1048576 | 3 | libzstd | 9.49 | 18.18 | 1.92 | 125.92 |
| http/html-1m | 1048576 | 3 | stdx | 16.32 | 39.37 | 2.41 | 177.29 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.32 | 42.52 | 2.97 | 115.67 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.91 | 83.13 | 2.78 | 527.06 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.75 | 44.54 | 3.02 | 129.64 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.99 | 84.87 | 2.74 | 533.45 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.80 | 14.98 | 3.12 | 57.38 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.74 | 33.78 | 3.47 | 116.36 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.34 | 16.21 | 3.04 | 72.95 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.78 | 34.58 | 3.21 | 122.81 |
| http/json-1m | 1048576 | 1 | libzstd | 4.04 | 12.55 | 3.11 | 53.41 |
| http/json-1m | 1048576 | 1 | stdx | 9.07 | 30.70 | 3.38 | 85.22 |
| http/json-1m | 1048576 | 3 | libzstd | 6.30 | 13.78 | 2.19 | 68.72 |
| http/json-1m | 1048576 | 3 | stdx | 11.76 | 30.64 | 2.61 | 119.82 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.58 | 57.26 | 3.08 | 185.36 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 40.19 | 113.49 | 2.82 | 690.90 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.33 | 65.54 | 3.07 | 260.38 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.17 | 116.54 | 2.76 | 679.36 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.82 | 26.52 | 3.01 | 126.68 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.78 | 55.71 | 3.32 | 200.51 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.04 | 28.74 | 2.86 | 152.31 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.71 | 55.35 | 3.13 | 209.57 |
| http/js-1m | 1048576 | 1 | libzstd | 6.57 | 17.87 | 2.72 | 114.12 |
| http/js-1m | 1048576 | 1 | stdx | 14.08 | 45.88 | 3.26 | 135.66 |
| http/js-1m | 1048576 | 3 | libzstd | 10.15 | 19.14 | 1.89 | 124.95 |
| http/js-1m | 1048576 | 3 | stdx | 17.69 | 41.25 | 2.33 | 187.26 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.57 | 46.90 | 3.01 | 137.68 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.63 | 91.65 | 2.81 | 579.85 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.57 | 50.53 | 3.05 | 160.50 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.86 | 93.63 | 2.77 | 581.42 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.13 | 18.99 | 3.10 | 78.69 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.54 | 43.79 | 3.49 | 137.30 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.56 | 19.41 | 2.96 | 95.75 |
| http/css-16kx64 | 1048576 | 3 | stdx | 13.05 | 42.34 | 3.25 | 152.47 |
| http/css-1m | 1048576 | 1 | libzstd | 1.51 | 4.59 | 3.04 | 21.76 |
| http/css-1m | 1048576 | 1 | stdx | 4.02 | 14.85 | 3.69 | 30.39 |
| http/css-1m | 1048576 | 3 | libzstd | 2.00 | 5.25 | 2.62 | 19.65 |
| http/css-1m | 1048576 | 3 | stdx | 4.03 | 13.33 | 3.31 | 32.00 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.54 | 12.79 | 3.62 | 6.26 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.15 | 30.66 | 3.35 | 61.77 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 28.60 | 50.53 | 1.77 | 49.66 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 21.72 | 47.43 | 2.18 | 207.16 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.119 | 3.00 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 66.5 | 219.6 | 0.087 | 7.85 | 3.30 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 30.7 | 96.1 | 0.164 | 3.62 | 3.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 249.0 | 1024.0 | 0.837 | 29.42 | 4.11 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.9 | 107.7 | 0.134 | 3.66 | 3.48 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.1 | 106.2 | 0.290 | 3.31 | 3.79 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.4 | 378.2 | 0.362 | 11.27 | 3.96 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.9 | 161.9 | 0.468 | 5.07 | 3.78 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 91.9 | 451.7 | 0.302 | 10.86 | 4.91 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 28.1 | 89.5 | 0.004 | 4.14 | 3.18 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 69.2 | 234.7 | 0.041 | 10.19 | 3.39 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 29.6 | 99.4 | 0.013 | 4.35 | 3.36 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 216.4 | 819.1 | 0.938 | 31.85 | 3.78 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.2 | 107.7 | 0.039 | 4.15 | 3.82 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 31.5 | 106.0 | 0.047 | 4.63 | 3.37 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 96.1 | 346.2 | 0.334 | 14.14 | 3.60 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 33.2 | 144.5 | 0.052 | 4.89 | 4.35 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 94.5 | 406.5 | 0.075 | 13.91 | 4.30 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 115104.6 | 403846.2 | 511.320 | 0.67 | 3.51 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 591159.8 | 2503286.2 | 1387.948 | 3.43 | 4.23 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 114461.5 | 404249.2 | 495.876 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3571109.2 | 18223876.2 | 2977.278 | 20.70 | 5.10 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311963.0 | 621744.2 | 640.155 | 1.81 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 224342.0 | 826630.2 | 2169.361 | 1.30 | 3.68 |
| string: silesia/dickens | 1 | 172528 | std.json | 1572559.8 | 4578768.2 | 42405.371 | 9.11 | 2.91 |
| string: silesia/dickens | 1 | 172528 | serde_json | 201829.1 | 802391.2 | 991.299 | 1.17 | 3.98 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1054129.8 | 5282076.4 | 4950.031 | 6.11 | 5.01 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1563886.0 | 4799763.6 | 1218.286 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14420223.1 | 56816152.6 | 39356.000 | 12.12 | 3.94 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1560003.2 | 4799955.6 | 1077.071 | 1.31 | 3.08 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 29104169.6 | 132108253.6 | 159647.000 | 24.45 | 4.54 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4589757.0 | 7062781.6 | 540.214 | 3.86 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1811610.9 | 7322029.6 | 14125.786 | 1.52 | 4.04 |
| string: http/json-1m | 1 | 1190272 | std.json | 10295629.1 | 47381213.6 | 29582.714 | 8.65 | 4.60 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3957045.6 | 15226459.6 | 6492.643 | 3.32 | 3.85 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9098417.1 | 47987172.2 | 28126.429 | 7.64 | 5.27 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2067848.6 | 5765413.8 | 4339.250 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6203478.4 | 22589263.8 | 6976.250 | 3.29 | 3.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2059695.5 | 5765605.8 | 3885.500 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47428000.0 | 227842320.8 | 287303.875 | 25.19 | 4.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3776640.3 | 8446023.8 | 2189.750 | 2.01 | 2.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7185701.9 | 12276717.8 | 275997.000 | 3.82 | 1.71 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17437493.9 | 63617055.8 | 268393.250 | 9.26 | 3.65 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9530032.1 | 24440755.8 | 329854.500 | 5.06 | 2.56 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39534274.9 | 160311317.6 | 805327.500 | 20.99 | 4.05 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12968040.7 | 42561069.3 | 247974.333 | 2.56 | 3.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 172674728.3 | 667246747.3 | 392758.333 | 34.02 | 3.86 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12961386.7 | 42561261.3 | 247220.333 | 2.55 | 3.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 153906390.0 | 639992662.3 | 423942.667 | 30.32 | 4.16 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17599532.3 | 49745820.3 | 252884.000 | 3.47 | 2.83 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14437625.3 | 45615166.3 | 448864.000 | 2.84 | 3.16 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 80222000.3 | 314900845.3 | 459228.333 | 15.81 | 3.93 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36056427.3 | 131556135.3 | 589169.000 | 7.10 | 3.65 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66814645.3 | 273931917.0 | 839256.333 | 13.16 | 4.10 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 94422.2 | 303836.7 | 7.000 | 0.18 | 3.22 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 182506.3 | 623465.7 | 9.290 | 0.35 | 3.42 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 148068.9 | 557622.7 | 7.065 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10277340.5 | 53478202.7 | 7.516 | 19.60 | 5.20 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 489968.8 | 1376733.7 | 5.000 | 0.93 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 537252.7 | 2195917.7 | 8.839 | 1.02 | 4.09 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3476731.7 | 12808414.7 | 61175.581 | 6.63 | 3.68 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 292406.8 | 1179969.7 | 5.097 | 0.56 | 4.04 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2259510.3 | 12789892.3 | 236.581 | 4.31 | 5.66 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 20.2 | 81.8 | 0.108 | 2.38 | 4.05 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.1 | 153.6 | 0.126 | 4.14 | 4.38 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 22.9 | 100.4 | 0.101 | 2.70 | 4.39 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 218.6 | 981.0 | 0.929 | 25.82 | 4.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 19.3 | 79.5 | 0.106 | 2.28 | 4.12 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.2 | 94.1 | 0.136 | 2.74 | 4.05 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.5 | 105.6 | 0.246 | 3.25 | 3.84 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.7 | 310.8 | 0.383 | 8.23 | 4.46 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.6 | 255.3 | 0.508 | 7.51 | 4.02 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.4 | 315.1 | 0.235 | 8.08 | 4.60 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 19.1 | 82.8 | 0.024 | 2.81 | 4.33 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.1 | 153.9 | 0.025 | 5.32 | 4.26 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 22.0 | 99.5 | 0.024 | 3.24 | 4.52 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 170.8 | 718.3 | 1.300 | 25.14 | 4.21 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.5 | 81.5 | 0.024 | 2.72 | 4.40 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 22.0 | 96.8 | 0.032 | 3.24 | 4.40 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.7 | 117.9 | 0.033 | 4.37 | 3.97 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 62.5 | 271.2 | 0.278 | 9.21 | 4.34 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 50.2 | 211.7 | 0.040 | 7.39 | 4.22 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 82.7 | 331.7 | 0.096 | 12.17 | 4.01 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 84961.9 | 280786.2 | 712.505 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 85127.0 | 280732.2 | 712.165 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84884.3 | 280736.2 | 711.278 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3412486.8 | 16047574.2 | 2947.845 | 19.78 | 4.70 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 84595.3 | 274401.2 | 698.969 | 0.49 | 3.24 |
| string: silesia/dickens | 1 | 172528 | simdjson | 209883.9 | 674016.2 | 2118.990 | 1.22 | 3.21 |
| string: silesia/dickens | 1 | 172528 | yyjson | 205377.6 | 825518.2 | 1085.196 | 1.19 | 4.02 |
| string: silesia/dickens | 1 | 172528 | std.json | 1370662.4 | 2890892.2 | 55387.443 | 7.94 | 2.11 |
| string: silesia/dickens | 1 | 172528 | serde_json | 373901.6 | 1586249.2 | 2247.938 | 2.17 | 4.24 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 578389.5 | 2970251.9 | 2322.608 | 3.35 | 5.14 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1251894.9 | 3582350.6 | 10725.643 | 1.05 | 2.86 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1238328.9 | 3582290.6 | 10201.500 | 1.04 | 2.89 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1234421.9 | 3582287.6 | 10083.143 | 1.04 | 2.90 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25500958.6 | 109856348.6 | 141660.286 | 21.42 | 4.31 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1224363.7 | 3370022.6 | 11014.643 | 1.03 | 2.75 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2975231.4 | 10460762.6 | 29118.714 | 2.50 | 3.52 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2590147.8 | 10197931.6 | 9443.929 | 2.18 | 3.94 |
| string: http/json-1m | 1 | 1190272 | std.json | 8919253.9 | 43287986.6 | 16310.429 | 7.49 | 4.85 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3903512.4 | 17941088.6 | 11131.214 | 3.28 | 4.60 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5272222.0 | 26999452.4 | 11141.571 | 4.43 | 5.12 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2082235.9 | 6088099.8 | 4646.875 | 1.11 | 2.92 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2067607.3 | 6088039.8 | 4212.250 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2063323.5 | 6088036.8 | 4084.375 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43601183.3 | 193466548.8 | 268986.375 | 23.15 | 4.44 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2077247.8 | 5875346.8 | 4918.875 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2716137.1 | 7144143.8 | 21030.000 | 1.44 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12488476.6 | 23590602.8 | 462449.250 | 6.63 | 1.89 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20182205.1 | 56837736.8 | 540515.000 | 10.72 | 2.82 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11665424.0 | 33662338.8 | 328750.375 | 6.19 | 2.89 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18810554.9 | 76318998.3 | 248829.875 | 9.99 | 4.06 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113018.2 | 426376.7 | 5.290 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113051.7 | 426318.7 | 3.806 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 112787.9 | 426306.7 | 3.806 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 636503.1 | 3146479.7 | 5.258 | 1.21 | 4.94 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113130.7 | 426343.7 | 3.226 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1199779.4 | 3866916.7 | 6.452 | 2.29 | 3.22 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1623162.8 | 5833341.7 | 6.323 | 3.10 | 3.59 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3506766.1 | 13108830.7 | 74998.516 | 6.69 | 3.74 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1779335.0 | 7405810.7 | 5.000 | 3.39 | 4.16 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2391905.8 | 12748182.9 | 14.645 | 4.56 | 5.33 |
