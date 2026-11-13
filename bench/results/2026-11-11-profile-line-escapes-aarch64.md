# bench-profile

| Field | Value |
|---|---|
| Commit | 58ee13c |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261101.172.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/42951744892 |
| Date | 2026-11-11 |

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
| silesia/dickens | 10192446 | zlib | 7.95 | 15.77 | 1.98 | 300.83 |
| silesia/dickens | 10192446 | zlib-ng | 4.88 | 10.50 | 2.15 | 67.62 |
| silesia/dickens | 10192446 | libdeflate | 3.47 | 9.56 | 2.76 | 66.24 |
| silesia/dickens | 10192446 | Wuffs | 4.87 | 10.85 | 2.23 | 97.41 |
| silesia/dickens | 10192446 | stdx | 2.92 | 7.15 | 2.44 | 76.14 |
| silesia/mozilla | 51220480 | zlib | 7.78 | 14.13 | 1.82 | 243.52 |
| silesia/mozilla | 51220480 | zlib-ng | 4.95 | 8.95 | 1.81 | 85.50 |
| silesia/mozilla | 51220480 | libdeflate | 3.47 | 7.63 | 2.20 | 71.09 |
| silesia/mozilla | 51220480 | Wuffs | 5.73 | 10.84 | 1.89 | 132.94 |
| silesia/mozilla | 51220480 | stdx | 3.63 | 6.29 | 1.73 | 88.98 |
| silesia/mr | 9970564 | zlib | 7.68 | 15.26 | 1.99 | 198.81 |
| silesia/mr | 9970564 | zlib-ng | 4.79 | 9.98 | 2.08 | 67.79 |
| silesia/mr | 9970564 | libdeflate | 3.34 | 8.58 | 2.57 | 61.04 |
| silesia/mr | 9970564 | Wuffs | 5.26 | 10.93 | 2.08 | 100.73 |
| silesia/mr | 9970564 | stdx | 3.07 | 6.70 | 2.19 | 69.59 |
| silesia/nci | 33553445 | zlib | 2.89 | 7.25 | 2.50 | 80.14 |
| silesia/nci | 33553445 | zlib-ng | 1.57 | 3.13 | 1.99 | 33.62 |
| silesia/nci | 33553445 | libdeflate | 1.10 | 2.66 | 2.42 | 27.61 |
| silesia/nci | 33553445 | Wuffs | 1.69 | 3.38 | 2.00 | 42.56 |
| silesia/nci | 33553445 | stdx | 1.14 | 2.20 | 1.93 | 37.21 |
| silesia/ooffice | 6152192 | zlib | 11.05 | 17.83 | 1.61 | 402.67 |
| silesia/ooffice | 6152192 | zlib-ng | 6.90 | 12.04 | 1.74 | 140.07 |
| silesia/ooffice | 6152192 | libdeflate | 4.90 | 10.45 | 2.13 | 125.48 |
| silesia/ooffice | 6152192 | Wuffs | 8.11 | 14.47 | 1.78 | 222.35 |
| silesia/ooffice | 6152192 | stdx | 5.06 | 8.55 | 1.69 | 150.90 |
| silesia/osdb | 10085684 | zlib | 6.80 | 13.54 | 1.99 | 172.48 |
| silesia/osdb | 10085684 | zlib-ng | 4.28 | 8.38 | 1.96 | 52.98 |
| silesia/osdb | 10085684 | libdeflate | 2.83 | 6.91 | 2.44 | 29.74 |
| silesia/osdb | 10085684 | Wuffs | 5.15 | 10.56 | 2.05 | 82.27 |
| silesia/osdb | 10085684 | stdx | 2.77 | 5.65 | 2.04 | 41.59 |
| silesia/reymont | 6627202 | zlib | 6.64 | 12.73 | 1.92 | 254.77 |
| silesia/reymont | 6627202 | zlib-ng | 3.72 | 7.72 | 2.08 | 60.12 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 50.94 |
| silesia/reymont | 6627202 | Wuffs | 4.23 | 8.40 | 1.99 | 112.74 |
| silesia/reymont | 6627202 | stdx | 2.28 | 5.11 | 2.24 | 64.38 |
| silesia/samba | 21606400 | zlib | 5.46 | 11.09 | 2.03 | 170.36 |
| silesia/samba | 21606400 | zlib-ng | 3.34 | 6.47 | 1.94 | 56.00 |
| silesia/samba | 21606400 | libdeflate | 2.34 | 5.58 | 2.39 | 42.81 |
| silesia/samba | 21606400 | Wuffs | 3.65 | 7.33 | 2.01 | 81.26 |
| silesia/samba | 21606400 | stdx | 2.25 | 4.46 | 1.98 | 56.28 |
| silesia/sao | 7251944 | zlib | 9.90 | 20.36 | 2.06 | 197.25 |
| silesia/sao | 7251944 | zlib-ng | 7.85 | 14.83 | 1.89 | 79.20 |
| silesia/sao | 7251944 | libdeflate | 5.73 | 12.73 | 2.22 | 79.08 |
| silesia/sao | 7251944 | Wuffs | 8.15 | 18.14 | 2.22 | 86.01 |
| silesia/sao | 7251944 | stdx | 5.60 | 10.32 | 1.84 | 87.14 |
| silesia/webster | 41458703 | zlib | 7.00 | 12.99 | 1.86 | 273.64 |
| silesia/webster | 41458703 | zlib-ng | 4.21 | 8.04 | 1.91 | 85.11 |
| silesia/webster | 41458703 | libdeflate | 2.89 | 7.17 | 2.48 | 68.43 |
| silesia/webster | 41458703 | Wuffs | 4.50 | 8.62 | 1.92 | 122.98 |
| silesia/webster | 41458703 | stdx | 2.73 | 5.56 | 2.04 | 86.98 |
| silesia/x-ray | 8474240 | zlib | 12.25 | 23.82 | 1.94 | 325.00 |
| silesia/x-ray | 8474240 | zlib-ng | 9.02 | 17.39 | 1.93 | 124.14 |
| silesia/x-ray | 8474240 | libdeflate | 6.53 | 15.26 | 2.34 | 124.51 |
| silesia/x-ray | 8474240 | Wuffs | 10.10 | 20.40 | 2.02 | 193.04 |
| silesia/x-ray | 8474240 | stdx | 6.11 | 11.49 | 1.88 | 137.35 |
| silesia/xml | 5345280 | zlib | 3.61 | 8.20 | 2.27 | 116.23 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.70 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.46 | 31.61 |
| silesia/xml | 5345280 | Wuffs | 2.19 | 4.14 | 1.89 | 60.83 |
| silesia/xml | 5345280 | stdx | 1.33 | 2.65 | 2.00 | 41.55 |
| canterbury/alice29.txt | 152089 | zlib | 7.60 | 15.08 | 1.98 | 285.69 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.11 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.19 | 8.96 | 2.81 | 54.63 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.72 | 10.37 | 2.20 | 99.04 |
| canterbury/alice29.txt | 152089 | stdx | 2.72 | 6.99 | 2.57 | 62.70 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.15 | 16.11 | 1.98 | 304.42 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.07 | 10.86 | 2.14 | 72.53 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.62 | 9.82 | 2.71 | 70.40 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.09 | 11.34 | 2.23 | 100.51 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.04 | 7.52 | 2.47 | 76.06 |
| canterbury/cp.html | 24603 | zlib | 6.56 | 14.20 | 2.17 | 175.06 |
| canterbury/cp.html | 24603 | zlib-ng | 4.15 | 9.50 | 2.29 | 34.95 |
| canterbury/cp.html | 24603 | libdeflate | 2.93 | 7.95 | 2.71 | 22.86 |
| canterbury/cp.html | 24603 | Wuffs | 4.46 | 10.87 | 2.44 | 55.58 |
| canterbury/cp.html | 24603 | stdx | 2.67 | 7.19 | 2.69 | 14.62 |
| canterbury/fields.c | 11150 | zlib | 4.64 | 14.65 | 3.16 | 38.64 |
| canterbury/fields.c | 11150 | zlib-ng | 3.86 | 10.20 | 2.64 | 13.71 |
| canterbury/fields.c | 11150 | libdeflate | 2.82 | 8.32 | 2.95 | 2.29 |
| canterbury/fields.c | 11150 | Wuffs | 3.80 | 11.51 | 3.02 | 7.85 |
| canterbury/fields.c | 11150 | stdx | 2.52 | 7.64 | 3.03 | 6.19 |
| canterbury/grammar.lsp | 3721 | zlib | 6.22 | 21.22 | 3.41 | 2.74 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.82 | 17.48 | 3.00 | 7.52 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.49 | 12.05 | 2.69 | 0.67 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.99 | 18.87 | 3.15 | 4.80 |
| canterbury/grammar.lsp | 3721 | stdx | 3.86 | 12.18 | 3.16 | 2.18 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.96 | 12.20 | 3.08 | 49.21 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.85 | 6.97 | 2.45 | 12.60 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.30 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.20 | 8.67 | 2.71 | 14.81 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.66 | 2.66 | 16.65 |
| canterbury/lcet10.txt | 426754 | zlib | 7.37 | 14.53 | 1.97 | 279.26 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 60.15 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.02 | 8.48 | 2.81 | 54.27 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.57 | 9.85 | 2.16 | 101.57 |
| canterbury/lcet10.txt | 426754 | stdx | 2.59 | 6.42 | 2.48 | 66.54 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.31 | 16.53 | 1.99 | 310.80 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.27 | 11.19 | 2.12 | 76.68 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.76 | 10.19 | 2.71 | 76.92 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.13 | 11.53 | 2.25 | 99.11 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.14 | 7.63 | 2.43 | 84.75 |
| canterbury/ptt5 | 513216 | zlib | 4.40 | 7.79 | 1.77 | 100.63 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.66 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.08 | 38.57 |
| canterbury/ptt5 | 513216 | Wuffs | 2.19 | 4.02 | 1.84 | 58.52 |
| canterbury/ptt5 | 513216 | stdx | 1.44 | 2.55 | 1.77 | 48.90 |
| canterbury/sum | 38240 | zlib | 7.29 | 14.98 | 2.05 | 216.48 |
| canterbury/sum | 38240 | zlib-ng | 4.64 | 10.02 | 2.16 | 56.54 |
| canterbury/sum | 38240 | libdeflate | 3.46 | 8.34 | 2.41 | 49.15 |
| canterbury/sum | 38240 | Wuffs | 5.00 | 11.41 | 2.28 | 76.69 |
| canterbury/sum | 38240 | stdx | 3.06 | 7.73 | 2.52 | 31.15 |
| canterbury/xargs.1 | 4227 | zlib | 6.70 | 22.08 | 3.30 | 8.17 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.39 | 17.97 | 2.81 | 10.06 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.84 | 13.27 | 2.74 | 1.23 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.47 | 19.63 | 3.03 | 8.27 |
| canterbury/xargs.1 | 4227 | stdx | 4.25 | 12.86 | 3.03 | 3.18 |
| canterbury-large/E.coli | 4638690 | zlib | 5.94 | 14.55 | 2.45 | 174.75 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.23 | 9.68 | 2.29 | 47.45 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.49 |
| canterbury-large/E.coli | 4638690 | Wuffs | 3.99 | 9.64 | 2.42 | 61.82 |
| canterbury-large/E.coli | 4638690 | stdx | 2.47 | 6.72 | 2.72 | 53.79 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.73 | 13.26 | 1.97 | 259.57 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.77 | 8.26 | 2.19 | 53.54 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.84 | 45.58 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.15 | 8.72 | 2.10 | 100.65 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.24 | 5.57 | 2.49 | 55.76 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.95 | 12.69 | 1.83 | 272.26 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.19 | 7.78 | 1.86 | 91.51 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.02 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.51 | 8.44 | 1.87 | 129.51 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 5.40 | 1.98 | 90.51 |
| http/html-1kx1024 | 1048576 | zlib | 15.85 | 32.44 | 2.05 | 351.79 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.69 | 28.43 | 2.24 | 216.68 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.85 | 20.05 | 1.85 | 155.95 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.59 | 35.04 | 2.40 | 263.52 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 137.55 |
| http/html-16kx64 | 1048576 | zlib | 6.02 | 11.79 | 1.96 | 214.52 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.84 | 7.54 | 1.96 | 85.00 |
| http/html-16kx64 | 1048576 | libdeflate | 2.66 | 6.04 | 2.28 | 60.55 |
| http/html-16kx64 | 1048576 | Wuffs | 4.26 | 8.51 | 2.00 | 116.97 |
| http/html-16kx64 | 1048576 | stdx | 2.54 | 5.56 | 2.19 | 59.77 |
| http/html-1m | 1048576 | zlib | 4.65 | 9.51 | 2.05 | 172.75 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 60.03 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.23 |
| http/html-1m | 1048576 | Wuffs | 2.96 | 5.42 | 1.83 | 90.42 |
| http/html-1m | 1048576 | stdx | 1.65 | 3.46 | 2.10 | 52.90 |
| http/json-1kx1024 | 1048576 | zlib | 9.71 | 20.83 | 2.15 | 191.70 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.39 | 16.69 | 2.26 | 130.75 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.12 | 16.72 | 1.83 | 92.18 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.45 | 31.72 | 2.77 | 145.41 |
| http/json-1kx1024 | 1048576 | stdx | 5.04 | 13.12 | 2.60 | 81.36 |
| http/json-16kx64 | 1048576 | zlib | 3.95 | 9.62 | 2.44 | 101.80 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.85 |
| http/json-16kx64 | 1048576 | libdeflate | 1.93 | 4.24 | 2.20 | 39.64 |
| http/json-16kx64 | 1048576 | Wuffs | 2.81 | 6.35 | 2.26 | 58.16 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.26 | 39.33 |
| http/json-1m | 1048576 | zlib | 3.25 | 8.25 | 2.54 | 82.18 |
| http/json-1m | 1048576 | zlib-ng | 1.94 | 3.91 | 2.02 | 37.19 |
| http/json-1m | 1048576 | libdeflate | 1.37 | 3.33 | 2.42 | 32.13 |
| http/json-1m | 1048576 | Wuffs | 2.04 | 4.29 | 2.10 | 44.39 |
| http/json-1m | 1048576 | stdx | 1.33 | 2.67 | 2.01 | 40.07 |
| http/js-1kx1024 | 1048576 | zlib | 17.30 | 35.33 | 2.04 | 401.43 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.78 | 31.25 | 2.27 | 238.78 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.53 | 21.58 | 1.87 | 178.93 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.77 | 37.70 | 2.39 | 296.25 |
| http/js-1kx1024 | 1048576 | stdx | 9.29 | 22.85 | 2.46 | 159.67 |
| http/js-16kx64 | 1048576 | zlib | 6.92 | 13.06 | 1.89 | 255.41 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.97 | 91.88 |
| http/js-16kx64 | 1048576 | libdeflate | 3.07 | 7.01 | 2.28 | 72.09 |
| http/js-16kx64 | 1048576 | Wuffs | 4.84 | 9.70 | 2.01 | 130.34 |
| http/js-16kx64 | 1048576 | stdx | 3.02 | 6.54 | 2.17 | 72.62 |
| http/js-1m | 1048576 | zlib | 5.16 | 10.26 | 1.99 | 195.88 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.96 | 60.06 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.88 |
| http/js-1m | 1048576 | Wuffs | 3.25 | 6.10 | 1.88 | 96.07 |
| http/js-1m | 1048576 | stdx | 1.80 | 3.89 | 2.16 | 55.41 |
| http/css-1kx1024 | 1048576 | zlib | 13.14 | 27.18 | 2.07 | 280.81 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.26 | 23.04 | 2.25 | 171.12 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.45 | 17.37 | 1.84 | 121.97 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.06 | 29.48 | 2.44 | 208.87 |
| http/css-1kx1024 | 1048576 | stdx | 6.68 | 17.64 | 2.64 | 100.90 |
| http/css-16kx64 | 1048576 | zlib | 4.68 | 10.12 | 2.16 | 151.96 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.18 | 50.27 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 28.33 |
| http/css-16kx64 | 1048576 | Wuffs | 3.12 | 6.97 | 2.23 | 70.61 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.54 | 28.12 |
| http/css-1m | 1048576 | zlib | 3.38 | 8.00 | 2.37 | 107.54 |
| http/css-1m | 1048576 | zlib-ng | 1.68 | 3.75 | 2.23 | 28.55 |
| http/css-1m | 1048576 | libdeflate | 1.05 | 3.18 | 3.04 | 10.42 |
| http/css-1m | 1048576 | Wuffs | 1.91 | 4.08 | 2.14 | 44.90 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.53 | 21.24 |
| shuffled/dickens-1m | 1048576 | zlib | 12.73 | 22.42 | 1.76 | 372.14 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.75 | 16.72 | 1.71 | 199.09 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.04 | 14.95 | 2.12 | 195.62 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.66 | 18.95 | 1.96 | 205.38 |
| shuffled/dickens-1m | 1048576 | stdx | 7.05 | 11.89 | 1.69 | 206.89 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.52 | 14.04 | 3.99 | 3.54 |
| silesia/dickens | 10192446 | stdx | 3.65 | 12.47 | 3.42 | 3.63 |
| silesia/mozilla | 51220480 | libzstd | 2.83 | 9.62 | 3.40 | 30.03 |
| silesia/mozilla | 51220480 | stdx | 2.80 | 9.68 | 3.45 | 15.63 |
| silesia/mr | 9970564 | libzstd | 3.03 | 11.98 | 3.95 | 6.20 |
| silesia/mr | 9970564 | stdx | 3.06 | 10.83 | 3.54 | 5.26 |
| silesia/nci | 33553445 | libzstd | 1.58 | 4.84 | 3.06 | 23.54 |
| silesia/nci | 33553445 | stdx | 1.59 | 4.63 | 2.91 | 13.57 |
| silesia/ooffice | 6152192 | libzstd | 3.40 | 12.14 | 3.57 | 31.14 |
| silesia/ooffice | 6152192 | stdx | 3.32 | 12.40 | 3.73 | 12.24 |
| silesia/osdb | 10085684 | libzstd | 2.36 | 8.44 | 3.58 | 15.33 |
| silesia/osdb | 10085684 | stdx | 2.42 | 8.11 | 3.35 | 15.42 |
| silesia/reymont | 6627202 | libzstd | 3.21 | 11.61 | 3.61 | 11.65 |
| silesia/reymont | 6627202 | stdx | 3.38 | 10.36 | 3.06 | 12.80 |
| silesia/samba | 21606400 | libzstd | 2.08 | 7.39 | 3.55 | 18.70 |
| silesia/samba | 21606400 | stdx | 2.11 | 6.83 | 3.24 | 17.59 |
| silesia/sao | 7251944 | libzstd | 3.85 | 12.69 | 3.30 | 26.46 |
| silesia/sao | 7251944 | stdx | 3.48 | 12.58 | 3.61 | 6.18 |
| silesia/webster | 41458703 | libzstd | 3.17 | 11.22 | 3.54 | 16.23 |
| silesia/webster | 41458703 | stdx | 3.43 | 10.05 | 2.93 | 17.68 |
| silesia/x-ray | 8474240 | libzstd | 3.97 | 14.93 | 3.76 | 19.09 |
| silesia/x-ray | 8474240 | stdx | 3.55 | 13.23 | 3.73 | 8.33 |
| silesia/xml | 5345280 | libzstd | 1.54 | 5.55 | 3.61 | 22.88 |
| silesia/xml | 5345280 | stdx | 1.51 | 5.16 | 3.41 | 17.07 |
| canterbury/alice29.txt | 152089 | libzstd | 3.36 | 16.18 | 4.82 | 4.14 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.46 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.00 | 14.25 | 4.74 | 3.32 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.29 | 0.27 |
| canterbury/cp.html | 24603 | libzstd | 2.67 | 10.74 | 4.02 | 9.31 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.11 | 0.22 |
| canterbury/fields.c | 11150 | libzstd | 3.14 | 13.61 | 4.33 | 10.10 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.23 | 0.18 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.23 | 16.93 | 4.00 | 6.77 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.54 | 4.01 | 0.24 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.49 | 11.22 | 4.51 | 7.70 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.24 | 0.90 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.74 | 12.87 | 4.71 | 5.34 |
| canterbury/lcet10.txt | 426754 | stdx | 2.73 | 11.52 | 4.22 | 3.89 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.16 | 15.14 | 4.79 | 1.59 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.26 | 1.05 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.50 | 3.11 | 24.57 |
| canterbury/ptt5 | 513216 | stdx | 1.34 | 4.46 | 3.33 | 13.74 |
| canterbury/sum | 38240 | libzstd | 2.64 | 10.51 | 3.98 | 10.54 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.09 | 0.29 |
| canterbury/xargs.1 | 4227 | libzstd | 4.29 | 17.40 | 4.05 | 11.15 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 17.17 | 4.06 | 0.21 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.07 | 13.63 | 4.45 | 2.16 |
| canterbury-large/E.coli | 4638690 | stdx | 3.13 | 12.04 | 3.85 | 3.00 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.97 | 11.99 | 4.04 | 8.52 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.08 | 10.64 | 3.46 | 9.34 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.58 | 9.59 | 3.72 | 19.86 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.66 | 8.64 | 3.24 | 21.46 |
| http/html-1kx1024 | 1048576 | libzstd | 7.41 | 21.63 | 2.92 | 62.81 |
| http/html-1kx1024 | 1048576 | stdx | 7.46 | 22.46 | 3.01 | 76.11 |
| http/html-16kx64 | 1048576 | libzstd | 2.67 | 10.15 | 3.81 | 28.78 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 9.61 | 3.61 | 30.43 |
| http/html-1m | 1048576 | libzstd | 2.00 | 7.86 | 3.94 | 24.38 |
| http/html-1m | 1048576 | stdx | 2.01 | 7.12 | 3.55 | 24.49 |
| http/json-1kx1024 | 1048576 | libzstd | 6.39 | 17.37 | 2.72 | 49.35 |
| http/json-1kx1024 | 1048576 | stdx | 6.21 | 17.86 | 2.88 | 52.99 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.22 | 3.53 | 27.85 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.58 | 19.98 |
| http/json-1m | 1048576 | libzstd | 1.71 | 6.04 | 3.53 | 27.47 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.62 | 14.24 |
| http/js-1kx1024 | 1048576 | libzstd | 8.44 | 26.38 | 3.12 | 72.96 |
| http/js-1kx1024 | 1048576 | stdx | 9.03 | 27.60 | 3.06 | 112.95 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.71 | 4.00 | 24.45 |
| http/js-16kx64 | 1048576 | stdx | 2.95 | 11.06 | 3.75 | 25.70 |
| http/js-1m | 1048576 | libzstd | 2.01 | 8.18 | 4.06 | 20.20 |
| http/js-1m | 1048576 | stdx | 2.07 | 7.48 | 3.61 | 21.59 |
| http/css-1kx1024 | 1048576 | libzstd | 7.04 | 19.70 | 2.80 | 53.56 |
| http/css-1kx1024 | 1048576 | stdx | 6.84 | 19.96 | 2.92 | 63.36 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.69 | 3.88 | 23.20 |
| http/css-16kx64 | 1048576 | stdx | 2.28 | 8.43 | 3.70 | 22.23 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.57 | 3.88 | 5.55 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.49 | 4.62 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.80 | 9.40 | 3.35 | 28.60 |
| shuffled/dickens-1m | 1048576 | stdx | 2.73 | 9.19 | 3.36 | 12.53 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.57 | 17.04 | 2.25 | 101.02 |
| silesia/dickens | 1048576 | stdx | 5.08 | 12.38 | 2.44 | 54.73 |
| silesia/mozilla | 1048576 | Google | 13.58 | 27.77 | 2.04 | 47.13 |
| silesia/mozilla | 1048576 | stdx | 8.34 | 15.02 | 1.80 | 47.46 |
| silesia/mr | 1048576 | Google | 8.95 | 20.24 | 2.26 | 102.35 |
| silesia/mr | 1048576 | stdx | 5.79 | 13.25 | 2.29 | 88.95 |
| silesia/nci | 1048576 | Google | 2.58 | 5.69 | 2.21 | 51.87 |
| silesia/nci | 1048576 | stdx | 1.95 | 3.95 | 2.03 | 55.62 |
| silesia/ooffice | 1048576 | Google | 14.26 | 29.28 | 2.05 | 288.51 |
| silesia/ooffice | 1048576 | stdx | 10.85 | 20.33 | 1.87 | 323.22 |
| silesia/osdb | 1048576 | Google | 8.27 | 17.38 | 2.10 | 96.19 |
| silesia/osdb | 1048576 | stdx | 5.17 | 10.57 | 2.05 | 92.59 |
| silesia/reymont | 1048576 | Google | 5.47 | 12.73 | 2.33 | 81.62 |
| silesia/reymont | 1048576 | stdx | 3.73 | 9.25 | 2.48 | 47.54 |
| silesia/samba | 1048576 | Google | 7.58 | 16.22 | 2.14 | 95.61 |
| silesia/samba | 1048576 | stdx | 5.07 | 10.71 | 2.11 | 67.37 |
| silesia/sao | 1048576 | Google | 16.82 | 36.97 | 2.20 | 161.98 |
| silesia/sao | 1048576 | stdx | 10.41 | 22.65 | 2.17 | 142.46 |
| silesia/webster | 1048576 | Google | 6.58 | 14.07 | 2.14 | 114.98 |
| silesia/webster | 1048576 | stdx | 4.39 | 9.98 | 2.27 | 68.84 |
| silesia/x-ray | 1048576 | Google | 19.29 | 38.46 | 1.99 | 233.65 |
| silesia/x-ray | 1048576 | stdx | 14.74 | 30.18 | 2.05 | 235.20 |
| silesia/xml | 1048576 | Google | 3.47 | 7.65 | 2.20 | 65.61 |
| silesia/xml | 1048576 | stdx | 2.41 | 5.40 | 2.24 | 47.21 |
| canterbury/alice29.txt | 152089 | Google | 8.89 | 20.66 | 2.32 | 136.38 |
| canterbury/alice29.txt | 152089 | stdx | 6.07 | 15.33 | 2.53 | 81.25 |
| canterbury/asyoulik.txt | 125179 | Google | 10.42 | 23.83 | 2.29 | 171.01 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.07 | 17.43 | 2.47 | 104.31 |
| canterbury/cp.html | 24603 | Google | 9.14 | 22.18 | 2.43 | 112.13 |
| canterbury/cp.html | 24603 | stdx | 5.73 | 17.15 | 2.99 | 32.25 |
| canterbury/fields.c | 11150 | Google | 7.09 | 21.25 | 3.00 | 24.01 |
| canterbury/fields.c | 11150 | stdx | 4.88 | 17.08 | 3.50 | 2.44 |
| canterbury/grammar.lsp | 3721 | Google | 9.85 | 30.23 | 3.07 | 5.21 |
| canterbury/grammar.lsp | 3721 | stdx | 7.16 | 25.04 | 3.50 | 0.34 |
| canterbury/kennedy.xls | 1029744 | Google | 5.43 | 17.05 | 3.14 | 37.10 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.80 | 12.94 | 3.41 | 33.89 |
| canterbury/lcet10.txt | 426754 | Google | 7.75 | 17.42 | 2.25 | 129.76 |
| canterbury/lcet10.txt | 426754 | stdx | 5.21 | 12.96 | 2.49 | 66.20 |
| canterbury/plrabn12.txt | 481861 | Google | 9.11 | 20.94 | 2.30 | 132.97 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.16 | 15.04 | 2.44 | 87.63 |
| canterbury/ptt5 | 513216 | Google | 4.29 | 10.36 | 2.42 | 62.34 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.07 | 65.80 |
| canterbury/sum | 38240 | Google | 10.82 | 26.44 | 2.44 | 158.91 |
| canterbury/sum | 38240 | stdx | 8.28 | 21.11 | 2.55 | 151.61 |
| canterbury/xargs.1 | 4227 | Google | 10.98 | 34.81 | 3.17 | 9.89 |
| canterbury/xargs.1 | 4227 | stdx | 8.53 | 30.44 | 3.57 | 7.94 |
| canterbury-large/E.coli | 1048576 | Google | 7.47 | 19.44 | 2.60 | 1.38 |
| canterbury-large/E.coli | 1048576 | stdx | 6.72 | 13.48 | 2.01 | 1.80 |
| canterbury-large/bible.txt | 1048576 | Google | 5.34 | 12.38 | 2.32 | 80.90 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.54 | 8.93 | 2.52 | 39.81 |
| canterbury-large/world192.txt | 1048576 | Google | 6.24 | 12.88 | 2.06 | 115.33 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.38 | 9.38 | 2.14 | 77.02 |
| http/html-1kx1024 | 1048576 | Google | 18.00 | 42.09 | 2.34 | 388.55 |
| http/html-1kx1024 | 1048576 | stdx | 15.26 | 37.56 | 2.46 | 359.84 |
| http/html-16kx64 | 1048576 | Google | 6.76 | 14.88 | 2.20 | 149.44 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 115.10 |
| http/html-1m | 1048576 | Google | 4.07 | 8.99 | 2.21 | 83.17 |
| http/html-1m | 1048576 | stdx | 2.86 | 6.52 | 2.28 | 54.63 |
| http/json-1kx1024 | 1048576 | Google | 14.31 | 36.74 | 2.57 | 239.23 |
| http/json-1kx1024 | 1048576 | stdx | 12.95 | 33.63 | 2.60 | 277.32 |
| http/json-16kx64 | 1048576 | Google | 4.41 | 11.42 | 2.59 | 81.46 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.68 |
| http/json-1m | 1048576 | Google | 3.40 | 8.66 | 2.54 | 58.63 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.44 | 57.63 |
| http/js-1kx1024 | 1048576 | Google | 19.91 | 46.38 | 2.33 | 428.51 |
| http/js-1kx1024 | 1048576 | stdx | 16.39 | 39.90 | 2.43 | 381.61 |
| http/js-16kx64 | 1048576 | Google | 8.05 | 17.79 | 2.21 | 166.98 |
| http/js-16kx64 | 1048576 | stdx | 6.04 | 14.36 | 2.38 | 125.77 |
| http/js-1m | 1048576 | Google | 4.37 | 9.60 | 2.20 | 82.97 |
| http/js-1m | 1048576 | stdx | 3.16 | 7.25 | 2.29 | 55.58 |
| http/css-1kx1024 | 1048576 | Google | 15.38 | 37.48 | 2.44 | 292.38 |
| http/css-1kx1024 | 1048576 | stdx | 13.80 | 34.70 | 2.51 | 302.74 |
| http/css-16kx64 | 1048576 | Google | 4.96 | 11.78 | 2.38 | 100.81 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.52 |
| http/css-1m | 1048576 | Google | 2.43 | 9.43 | 3.87 | 16.82 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.48 | 11.86 |
| shuffled/dickens-1m | 1048576 | Google | 9.72 | 20.34 | 2.09 | 111.50 |
| shuffled/dickens-1m | 1048576 | stdx | 8.78 | 14.53 | 1.65 | 117.94 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.16 | 36.91 | 2.44 | 410.51 |
| silesia/dickens | 10192446 | 1 | stdx | 16.19 | 38.17 | 2.36 | 361.00 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.04 | 87.63 | 1.68 | 696.09 |
| silesia/dickens | 10192446 | 6 | stdx | 49.63 | 84.25 | 1.70 | 1457.96 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.76 | 160.47 | 1.44 | 930.38 |
| silesia/dickens | 10192446 | 9 | stdx | 64.89 | 150.06 | 2.31 | 1399.61 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.11 | 32.62 | 2.31 | 436.68 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.31 | 30.24 | 2.27 | 294.56 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.84 | 70.83 | 2.16 | 578.44 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.51 | 69.96 | 2.22 | 736.39 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.77 | 221.49 | 1.73 | 771.73 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.59 | 125.42 | 2.58 | 780.70 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.92 | 35.02 | 2.94 | 229.54 |
| silesia/mr | 9970564 | 1 | stdx | 12.38 | 34.08 | 2.75 | 186.92 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.19 | 80.54 | 2.11 | 436.86 |
| silesia/mr | 9970564 | 6 | stdx | 39.82 | 83.18 | 2.09 | 987.65 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.79 | 165.48 | 1.69 | 752.21 |
| silesia/mr | 9970564 | 9 | stdx | 78.92 | 184.93 | 2.34 | 1221.61 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.20 | 18.42 | 2.97 | 114.74 |
| silesia/nci | 33553445 | 1 | stdx | 4.92 | 10.88 | 2.21 | 97.50 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.93 | 34.84 | 2.06 | 226.08 |
| silesia/nci | 33553445 | 6 | stdx | 14.39 | 29.54 | 2.05 | 395.07 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.36 | 105.28 | 1.69 | 501.90 |
| silesia/nci | 33553445 | 9 | stdx | 28.25 | 69.01 | 2.44 | 558.38 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.86 | 39.15 | 1.97 | 752.01 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.61 | 39.08 | 2.22 | 429.62 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 40.92 | 79.10 | 1.93 | 953.79 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.61 | 87.83 | 2.11 | 1011.76 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.55 | 127.63 | 1.71 | 1132.55 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.14 | 129.03 | 2.47 | 931.66 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.90 | 30.15 | 2.34 | 352.39 |
| silesia/osdb | 10085684 | 1 | stdx | 12.88 | 27.86 | 2.16 | 293.69 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.24 | 55.67 | 1.97 | 490.63 |
| silesia/osdb | 10085684 | 6 | stdx | 27.14 | 57.39 | 2.11 | 576.63 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.84 | 64.15 | 1.90 | 552.46 |
| silesia/osdb | 10085684 | 9 | stdx | 35.15 | 87.16 | 2.48 | 684.47 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.58 | 32.88 | 2.61 | 311.00 |
| silesia/reymont | 6627202 | 1 | stdx | 13.23 | 33.24 | 2.51 | 271.19 |
| silesia/reymont | 6627202 | 6 | libdeflate | 47.91 | 86.58 | 1.81 | 517.79 |
| silesia/reymont | 6627202 | 6 | stdx | 45.48 | 76.81 | 1.69 | 1450.05 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.33 | 276.14 | 1.39 | 837.42 |
| silesia/reymont | 6627202 | 9 | stdx | 74.07 | 160.03 | 2.16 | 1435.22 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.43 | 26.53 | 2.54 | 271.49 |
| silesia/samba | 21606400 | 1 | stdx | 9.82 | 22.23 | 2.26 | 220.76 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.92 | 58.79 | 2.03 | 385.13 |
| silesia/samba | 21606400 | 6 | stdx | 24.15 | 49.83 | 2.06 | 630.70 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.15 | 141.44 | 1.68 | 504.27 |
| silesia/samba | 21606400 | 9 | stdx | 36.10 | 90.81 | 2.52 | 644.20 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.68 | 47.87 | 2.21 | 682.44 |
| silesia/sao | 7251944 | 1 | stdx | 19.04 | 49.92 | 2.62 | 346.23 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.02 | 96.89 | 1.90 | 960.13 |
| silesia/sao | 7251944 | 6 | stdx | 47.08 | 105.66 | 2.24 | 855.68 |
| silesia/sao | 7251944 | 9 | libdeflate | 70.88 | 120.26 | 1.70 | 1107.80 |
| silesia/sao | 7251944 | 9 | stdx | 54.99 | 137.71 | 2.50 | 831.97 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.10 | 30.45 | 2.32 | 385.53 |
| silesia/webster | 41458703 | 1 | stdx | 13.83 | 29.08 | 2.10 | 339.64 |
| silesia/webster | 41458703 | 6 | libdeflate | 36.92 | 66.02 | 1.79 | 569.65 |
| silesia/webster | 41458703 | 6 | stdx | 35.34 | 60.87 | 1.72 | 1134.16 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.54 | 138.85 | 1.47 | 757.82 |
| silesia/webster | 41458703 | 9 | stdx | 48.41 | 110.73 | 2.29 | 1085.30 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.68 | 49.67 | 2.10 | 783.36 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.56 | 50.81 | 2.89 | 261.46 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.82 | 82.77 | 2.52 | 853.37 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.76 | 98.12 | 2.91 | 539.28 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.49 | 91.03 | 2.43 | 1031.15 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.48 | 121.58 | 3.00 | 467.21 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.78 | 21.59 | 2.78 | 175.87 |
| silesia/xml | 5345280 | 1 | stdx | 6.89 | 15.66 | 2.27 | 155.14 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.06 | 40.51 | 1.92 | 263.63 |
| silesia/xml | 5345280 | 6 | stdx | 17.53 | 34.32 | 1.96 | 498.68 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.55 | 89.17 | 1.52 | 372.52 |
| silesia/xml | 5345280 | 9 | stdx | 26.48 | 63.43 | 2.40 | 525.48 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.24 | 35.61 | 2.50 | 377.72 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.03 | 36.12 | 2.40 | 335.46 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.70 | 82.29 | 1.76 | 638.74 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.82 | 77.41 | 1.77 | 1332.49 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.34 | 159.21 | 1.48 | 849.30 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 58.21 | 138.20 | 2.37 | 1269.20 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.14 | 37.20 | 2.46 | 413.58 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.76 | 37.43 | 2.37 | 358.03 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.27 | 85.43 | 1.77 | 713.06 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.40 | 81.92 | 1.77 | 1408.57 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.84 | 136.15 | 1.53 | 941.08 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 60.17 | 144.56 | 2.40 | 1337.30 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.67 | 32.02 | 2.74 | 283.42 |
| canterbury/cp.html | 24603 | 1 | stdx | 11.12 | 27.13 | 2.44 | 251.78 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 26.84 | 62.33 | 2.32 | 484.82 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.71 | 57.05 | 2.41 | 625.63 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.82 | 91.97 | 1.96 | 597.13 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.22 | 88.88 | 2.85 | 641.87 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.80 | 35.92 | 3.66 | 80.46 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.07 | 30.05 | 3.72 | 22.64 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.24 | 69.37 | 2.86 | 230.32 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.79 | 57.62 | 2.77 | 424.94 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.56 | 100.81 | 2.26 | 426.03 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.45 | 92.65 | 3.26 | 451.36 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.10 | 51.51 | 3.93 | 17.65 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.86 | 39.01 | 3.96 | 2.37 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.82 | 87.06 | 3.65 | 28.37 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.26 | 70.80 | 4.10 | 21.30 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.76 | 102.89 | 3.35 | 36.84 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.74 | 99.30 | 4.18 | 54.69 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.36 | 27.18 | 3.69 | 65.14 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.04 | 22.58 | 3.21 | 63.37 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.85 | 73.85 | 2.65 | 96.17 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.32 | 61.98 | 3.21 | 138.86 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.28 | 664.23 | 1.83 | 163.88 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 30.14 | 107.06 | 3.55 | 144.19 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.77 | 33.99 | 2.47 | 369.60 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.46 | 33.92 | 2.35 | 329.71 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 44.95 | 78.22 | 1.74 | 604.95 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.88 | 73.42 | 1.75 | 1247.24 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.67 | 136.94 | 1.49 | 804.75 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 55.15 | 130.91 | 2.37 | 1197.74 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.80 | 38.62 | 2.44 | 425.93 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.74 | 40.24 | 2.40 | 370.78 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.05 | 91.90 | 1.70 | 752.21 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.81 | 88.89 | 1.72 | 1527.39 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.79 | 166.26 | 1.42 | 1002.38 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 67.72 | 158.18 | 2.34 | 1464.35 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.43 | 18.61 | 2.89 | 141.54 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.98 | 11.03 | 2.22 | 123.41 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.25 | 36.17 | 2.54 | 218.79 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.35 | 29.57 | 2.39 | 312.22 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.57 | 120.86 | 2.00 | 381.32 |
| canterbury/ptt5 | 513216 | 9 | stdx | 41.32 | 126.55 | 3.06 | 591.57 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.79 | 33.49 | 2.62 | 335.54 |
| canterbury/sum | 38240 | 1 | stdx | 12.59 | 29.36 | 2.33 | 300.41 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.56 | 69.87 | 2.45 | 497.06 |
| canterbury/sum | 38240 | 6 | stdx | 26.81 | 65.73 | 2.45 | 670.18 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.35 | 181.91 | 1.93 | 607.21 |
| canterbury/sum | 38240 | 9 | stdx | 39.25 | 112.32 | 2.86 | 661.06 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.42 | 53.06 | 3.95 | 29.09 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.74 | 43.10 | 4.01 | 2.04 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.97 | 87.70 | 3.82 | 69.67 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 18.00 | 74.35 | 4.13 | 43.42 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 24.83 | 94.34 | 3.80 | 84.58 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 25.68 | 106.95 | 4.16 | 94.18 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.02 | 40.47 | 3.37 | 163.44 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.54 | 42.29 | 3.37 | 101.25 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.36 | 395.99 | 2.16 | 264.16 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 123.02 | 374.12 | 3.04 | 1922.88 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 818.02 | 1063.49 | 1.30 | 1323.83 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 229.38 | 751.65 | 3.28 | 2429.12 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.52 | 32.38 | 2.59 | 311.95 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.17 | 32.23 | 2.45 | 280.90 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.01 | 80.12 | 1.74 | 523.65 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.35 | 72.38 | 1.71 | 1276.94 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.67 | 200.28 | 1.41 | 743.08 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 60.53 | 136.73 | 2.26 | 1223.36 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.29 | 29.72 | 2.24 | 413.37 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.15 | 28.55 | 2.02 | 379.14 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 32.94 | 60.25 | 1.83 | 556.85 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.16 | 56.80 | 1.77 | 996.29 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.65 | 119.11 | 1.48 | 688.80 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 41.61 | 97.56 | 2.34 | 972.88 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.41 | 103.92 | 2.93 | 455.69 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.28 | 58.63 | 2.76 | 364.16 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.17 | 138.33 | 3.00 | 565.82 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 32.86 | 94.30 | 2.87 | 528.27 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.65 | 142.44 | 2.99 | 587.28 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 36.98 | 112.10 | 3.03 | 539.22 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.45 | 27.96 | 2.68 | 266.38 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.01 | 20.25 | 2.25 | 234.00 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.28 | 52.09 | 2.34 | 391.05 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.89 | 42.86 | 2.27 | 546.71 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 34.92 | 72.54 | 2.08 | 463.84 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.69 | 69.05 | 2.80 | 551.51 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.75 | 23.03 | 2.63 | 222.80 |
| http/html-1m | 1048576 | 1 | stdx | 8.14 | 17.79 | 2.19 | 205.29 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.24 | 49.53 | 1.96 | 327.80 |
| http/html-1m | 1048576 | 6 | stdx | 21.24 | 40.70 | 1.92 | 630.42 |
| http/html-1m | 1048576 | 9 | libdeflate | 70.90 | 109.24 | 1.54 | 432.33 |
| http/html-1m | 1048576 | 9 | stdx | 29.90 | 73.42 | 2.46 | 615.07 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.77 | 94.80 | 2.98 | 302.11 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.45 | 45.16 | 2.75 | 242.43 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.04 | 126.60 | 2.94 | 375.65 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.03 | 78.36 | 2.90 | 380.72 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.08 | 142.45 | 2.74 | 432.44 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.56 | 95.54 | 3.13 | 384.31 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.84 | 23.85 | 3.04 | 133.92 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.47 | 13.94 | 2.55 | 110.57 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.15 | 46.61 | 2.57 | 203.91 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.37 | 35.01 | 2.62 | 281.09 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.20 | 151.99 | 1.90 | 299.47 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.04 | 58.29 | 3.06 | 301.80 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.73 | 19.85 | 2.95 | 124.08 |
| http/json-1m | 1048576 | 1 | stdx | 5.06 | 12.51 | 2.47 | 103.63 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.29 | 45.30 | 2.23 | 175.60 |
| http/json-1m | 1048576 | 6 | stdx | 14.67 | 35.08 | 2.39 | 297.94 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.52 | 205.21 | 1.69 | 279.86 |
| http/json-1m | 1048576 | 9 | stdx | 27.28 | 69.14 | 2.53 | 337.08 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.06 | 107.80 | 2.91 | 518.16 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.63 | 65.40 | 2.77 | 410.91 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.29 | 144.85 | 2.94 | 676.76 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 36.43 | 104.11 | 2.86 | 618.55 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.66 | 150.13 | 2.91 | 718.50 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 41.11 | 125.11 | 3.04 | 625.57 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.71 | 30.90 | 2.64 | 308.14 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.80 | 24.80 | 2.29 | 272.57 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.81 | 59.43 | 2.30 | 468.84 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.71 | 50.04 | 2.20 | 682.97 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.80 | 83.31 | 2.04 | 564.94 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.42 | 81.30 | 2.76 | 663.42 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.64 | 25.19 | 2.61 | 247.73 |
| http/js-1m | 1048576 | 1 | stdx | 9.54 | 21.31 | 2.23 | 232.76 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.68 | 56.12 | 1.96 | 369.44 |
| http/js-1m | 1048576 | 6 | stdx | 24.88 | 46.64 | 1.87 | 747.53 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.16 | 120.65 | 1.58 | 500.61 |
| http/js-1m | 1048576 | 9 | stdx | 34.89 | 84.80 | 2.43 | 709.18 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.21 | 97.73 | 2.94 | 376.30 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.31 | 49.52 | 2.70 | 301.36 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.78 | 129.22 | 2.95 | 479.83 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.04 | 82.31 | 2.83 | 504.00 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.77 | 133.80 | 2.92 | 509.74 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.03 | 99.46 | 3.01 | 522.17 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.63 | 25.60 | 2.97 | 173.05 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.68 | 16.96 | 2.54 | 134.94 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.18 | 48.80 | 2.42 | 288.59 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.40 | 38.00 | 2.32 | 467.25 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.79 | 82.40 | 2.02 | 371.32 |
| http/css-16kx64 | 1048576 | 9 | stdx | 22.89 | 65.13 | 2.85 | 478.83 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.95 | 21.15 | 3.04 | 132.56 |
| http/css-1m | 1048576 | 1 | stdx | 5.77 | 14.91 | 2.58 | 107.97 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.74 | 44.50 | 2.15 | 226.63 |
| http/css-1m | 1048576 | 6 | stdx | 16.59 | 35.61 | 2.15 | 445.44 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.64 | 111.58 | 1.60 | 309.49 |
| http/css-1m | 1048576 | 9 | stdx | 28.02 | 72.54 | 2.59 | 473.44 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.23 | 48.89 | 1.94 | 929.48 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.08 | 49.19 | 2.72 | 322.96 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.50 | 86.45 | 2.08 | 1179.36 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.57 | 88.79 | 2.24 | 851.79 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.02 | 94.50 | 2.01 | 1343.74 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 53.35 | 133.83 | 2.51 | 1123.99 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.14 | 31.13 | 3.07 | 123.01 |
| silesia/dickens | 10192446 | 1 | stdx | 24.23 | 82.03 | 3.39 | 125.10 |
| silesia/dickens | 10192446 | 3 | libzstd | 22.97 | 35.01 | 1.52 | 172.30 |
| silesia/dickens | 10192446 | 3 | stdx | 35.61 | 78.22 | 2.20 | 182.55 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.02 | 22.57 | 3.22 | 72.17 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.60 | 54.73 | 3.11 | 173.22 |
| silesia/mozilla | 51220480 | 3 | libzstd | 17.49 | 28.71 | 1.64 | 102.66 |
| silesia/mozilla | 51220480 | 3 | stdx | 30.75 | 62.01 | 2.02 | 144.61 |
| silesia/mr | 9970564 | 1 | libzstd | 7.67 | 24.73 | 3.22 | 57.65 |
| silesia/mr | 9970564 | 1 | stdx | 19.88 | 66.82 | 3.36 | 113.75 |
| silesia/mr | 9970564 | 3 | libzstd | 20.69 | 32.97 | 1.59 | 86.69 |
| silesia/mr | 9970564 | 3 | stdx | 33.79 | 72.46 | 2.14 | 114.76 |
| silesia/nci | 33553445 | 1 | libzstd | 3.55 | 9.49 | 2.67 | 58.69 |
| silesia/nci | 33553445 | 1 | stdx | 7.70 | 25.69 | 3.34 | 59.14 |
| silesia/nci | 33553445 | 3 | libzstd | 5.53 | 10.11 | 1.83 | 56.97 |
| silesia/nci | 33553445 | 3 | stdx | 11.27 | 29.15 | 2.59 | 66.44 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.53 | 29.17 | 3.42 | 71.95 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.10 | 72.51 | 3.14 | 180.11 |
| silesia/ooffice | 6152192 | 3 | libzstd | 24.57 | 40.82 | 1.66 | 121.12 |
| silesia/ooffice | 6152192 | 3 | stdx | 42.03 | 82.20 | 1.96 | 185.02 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.10 | 22.22 | 3.13 | 66.71 |
| silesia/osdb | 10085684 | 1 | stdx | 16.39 | 50.52 | 3.08 | 120.18 |
| silesia/osdb | 10085684 | 3 | libzstd | 18.46 | 27.06 | 1.47 | 69.93 |
| silesia/osdb | 10085684 | 3 | stdx | 32.03 | 57.87 | 1.81 | 110.27 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.79 | 27.02 | 2.76 | 155.84 |
| silesia/reymont | 6627202 | 1 | stdx | 20.10 | 72.05 | 3.58 | 96.60 |
| silesia/reymont | 6627202 | 3 | libzstd | 18.59 | 27.53 | 1.48 | 127.42 |
| silesia/reymont | 6627202 | 3 | stdx | 28.12 | 62.18 | 2.21 | 147.48 |
| silesia/samba | 21606400 | 1 | libzstd | 5.95 | 16.80 | 2.82 | 88.11 |
| silesia/samba | 21606400 | 1 | stdx | 13.50 | 42.89 | 3.18 | 124.72 |
| silesia/samba | 21606400 | 3 | libzstd | 12.10 | 19.20 | 1.59 | 100.13 |
| silesia/samba | 21606400 | 3 | stdx | 20.33 | 44.75 | 2.20 | 132.94 |
| silesia/sao | 7251944 | 1 | libzstd | 8.99 | 33.64 | 3.74 | 43.72 |
| silesia/sao | 7251944 | 1 | stdx | 26.12 | 82.03 | 3.14 | 103.31 |
| silesia/sao | 7251944 | 3 | libzstd | 32.79 | 52.14 | 1.59 | 95.52 |
| silesia/sao | 7251944 | 3 | stdx | 51.31 | 95.22 | 1.86 | 141.97 |
| silesia/webster | 41458703 | 1 | libzstd | 8.73 | 24.86 | 2.85 | 135.95 |
| silesia/webster | 41458703 | 1 | stdx | 20.33 | 64.04 | 3.15 | 166.24 |
| silesia/webster | 41458703 | 3 | libzstd | 19.51 | 27.84 | 1.43 | 178.32 |
| silesia/webster | 41458703 | 3 | stdx | 31.12 | 64.55 | 2.07 | 194.93 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.71 | 14.89 | 3.16 | 16.94 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.85 | 76.64 | 3.21 | 92.29 |
| silesia/x-ray | 8474240 | 3 | libzstd | 33.42 | 54.96 | 1.64 | 86.28 |
| silesia/x-ray | 8474240 | 3 | stdx | 47.68 | 92.40 | 1.94 | 106.21 |
| silesia/xml | 5345280 | 1 | libzstd | 4.25 | 11.65 | 2.74 | 72.87 |
| silesia/xml | 5345280 | 1 | stdx | 10.42 | 34.21 | 3.28 | 94.01 |
| silesia/xml | 5345280 | 3 | libzstd | 6.87 | 12.84 | 1.87 | 79.34 |
| silesia/xml | 5345280 | 3 | stdx | 12.77 | 32.28 | 2.53 | 115.25 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.89 | 32.86 | 3.02 | 145.43 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.36 | 76.49 | 3.42 | 187.86 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.94 | 39.93 | 2.50 | 203.34 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.34 | 73.76 | 2.80 | 334.69 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.79 | 33.59 | 3.43 | 109.50 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.51 | 79.00 | 3.36 | 215.31 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.52 | 40.28 | 2.60 | 206.50 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.08 | 79.30 | 2.82 | 371.87 |
| canterbury/cp.html | 24603 | 1 | libzstd | 6.96 | 26.65 | 3.83 | 37.07 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.01 | 57.76 | 3.61 | 115.71 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.22 | 32.88 | 3.57 | 13.95 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.29 | 59.76 | 3.27 | 138.17 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.75 | 31.77 | 3.63 | 38.60 |
| canterbury/fields.c | 11150 | 1 | stdx | 16.96 | 65.73 | 3.87 | 85.77 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.06 | 34.41 | 3.80 | 10.28 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.24 | 64.68 | 3.75 | 89.31 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.62 | 37.98 | 3.95 | 11.70 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.11 | 77.57 | 3.86 | 48.00 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.62 | 43.28 | 4.07 | 1.57 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.33 | 79.60 | 3.73 | 65.60 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.00 | 23.37 | 3.89 | 14.78 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.66 | 56.75 | 3.87 | 83.72 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.81 | 24.26 | 2.75 | 27.42 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 20.44 | 56.61 | 2.77 | 108.33 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.90 | 28.42 | 2.87 | 160.44 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.34 | 72.02 | 3.37 | 159.42 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 17.23 | 32.77 | 1.90 | 202.79 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.34 | 67.10 | 2.55 | 296.01 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.33 | 32.28 | 3.12 | 130.86 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.03 | 84.16 | 3.36 | 158.83 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 20.94 | 39.60 | 1.89 | 225.47 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 31.80 | 80.77 | 2.54 | 342.54 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.15 | 8.48 | 2.69 | 67.56 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.49 | 23.15 | 3.09 | 104.07 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 5.15 | 11.28 | 2.19 | 60.05 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.56 | 24.08 | 2.52 | 132.28 |
| canterbury/sum | 38240 | 1 | libzstd | 6.49 | 25.37 | 3.91 | 29.81 |
| canterbury/sum | 38240 | 1 | stdx | 16.82 | 59.13 | 3.52 | 147.77 |
| canterbury/sum | 38240 | 3 | libzstd | 8.97 | 31.64 | 3.53 | 30.27 |
| canterbury/sum | 38240 | 3 | stdx | 19.52 | 61.82 | 3.17 | 180.59 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 10.03 | 39.84 | 3.97 | 11.54 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.80 | 80.38 | 3.86 | 57.48 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.06 | 48.45 | 4.02 | 1.96 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.89 | 83.98 | 3.67 | 77.55 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.48 | 33.29 | 3.18 | 75.27 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.75 | 95.62 | 4.40 | 7.20 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 15.42 | 31.71 | 2.06 | 35.79 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.70 | 70.38 | 2.97 | 38.41 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.81 | 27.35 | 2.79 | 154.28 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.40 | 71.86 | 3.52 | 108.07 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 18.48 | 28.64 | 1.55 | 133.89 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 28.08 | 63.36 | 2.26 | 154.94 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.20 | 22.62 | 2.76 | 140.07 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.59 | 55.86 | 3.00 | 193.18 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 15.74 | 24.36 | 1.55 | 175.63 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 25.25 | 51.26 | 2.03 | 236.34 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.17 | 52.52 | 3.06 | 167.59 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.62 | 100.54 | 2.82 | 633.59 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.29 | 59.34 | 3.08 | 205.04 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 37.72 | 104.00 | 2.76 | 631.62 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.86 | 22.47 | 2.86 | 127.42 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.12 | 46.84 | 3.32 | 181.84 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.90 | 24.79 | 2.79 | 146.13 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.32 | 47.61 | 3.11 | 192.02 |
| http/html-1m | 1048576 | 1 | libzstd | 6.31 | 16.66 | 2.64 | 117.60 |
| http/html-1m | 1048576 | 1 | stdx | 12.92 | 42.00 | 3.25 | 133.82 |
| http/html-1m | 1048576 | 3 | libzstd | 9.74 | 18.50 | 1.90 | 126.84 |
| http/html-1m | 1048576 | 3 | stdx | 15.86 | 39.37 | 2.48 | 177.76 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.41 | 42.58 | 2.95 | 119.45 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.40 | 83.13 | 2.83 | 524.82 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.98 | 44.69 | 2.98 | 134.04 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.51 | 84.87 | 2.78 | 532.76 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.84 | 15.00 | 3.10 | 59.32 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.67 | 33.78 | 3.49 | 116.19 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.42 | 16.31 | 3.01 | 73.00 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.62 | 34.58 | 3.26 | 122.71 |
| http/json-1m | 1048576 | 1 | libzstd | 4.07 | 12.47 | 3.07 | 53.33 |
| http/json-1m | 1048576 | 1 | stdx | 9.01 | 30.70 | 3.41 | 85.46 |
| http/json-1m | 1048576 | 3 | libzstd | 6.43 | 14.06 | 2.19 | 68.67 |
| http/json-1m | 1048576 | 3 | stdx | 11.45 | 30.64 | 2.68 | 119.40 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.73 | 57.29 | 3.06 | 197.10 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 39.80 | 113.49 | 2.85 | 692.86 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.64 | 65.62 | 3.03 | 268.02 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.13 | 116.54 | 2.77 | 682.09 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 9.00 | 26.53 | 2.95 | 133.58 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.65 | 55.71 | 3.35 | 200.44 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.21 | 28.96 | 2.84 | 157.95 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.72 | 55.35 | 3.12 | 208.76 |
| http/js-1m | 1048576 | 1 | libzstd | 6.62 | 17.80 | 2.69 | 116.43 |
| http/js-1m | 1048576 | 1 | stdx | 14.02 | 45.88 | 3.27 | 135.79 |
| http/js-1m | 1048576 | 3 | libzstd | 10.34 | 19.49 | 1.88 | 124.94 |
| http/js-1m | 1048576 | 3 | stdx | 16.99 | 41.25 | 2.43 | 186.97 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.71 | 46.97 | 2.99 | 143.10 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.18 | 91.65 | 2.85 | 579.68 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.85 | 50.68 | 3.01 | 166.59 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.58 | 93.63 | 2.79 | 586.10 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.24 | 18.99 | 3.04 | 80.63 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.41 | 43.79 | 3.53 | 137.35 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.62 | 19.53 | 2.95 | 94.61 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.92 | 42.34 | 3.28 | 152.36 |
| http/css-1m | 1048576 | 1 | libzstd | 1.52 | 4.57 | 3.01 | 22.15 |
| http/css-1m | 1048576 | 1 | stdx | 3.98 | 14.85 | 3.73 | 30.46 |
| http/css-1m | 1048576 | 3 | libzstd | 2.02 | 5.34 | 2.64 | 19.69 |
| http/css-1m | 1048576 | 3 | stdx | 3.96 | 13.33 | 3.36 | 31.69 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.53 | 12.79 | 3.63 | 6.48 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.07 | 30.66 | 3.38 | 61.36 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 30.16 | 53.05 | 1.76 | 46.50 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 20.88 | 47.43 | 2.27 | 206.28 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.118 | 3.00 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 65.6 | 219.6 | 0.086 | 7.75 | 3.35 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 39.9 | 177.7 | 0.074 | 4.72 | 4.45 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 251.6 | 1024.0 | 0.842 | 29.72 | 4.07 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.3 | 107.5 | 0.130 | 3.58 | 3.55 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.8 | 106.0 | 0.296 | 3.29 | 3.81 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.0 | 378.2 | 0.365 | 11.22 | 3.98 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.6 | 161.9 | 0.446 | 5.04 | 3.80 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 90.1 | 451.7 | 0.301 | 10.64 | 5.01 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.4 | 89.5 | 0.004 | 4.03 | 3.27 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.6 | 234.7 | 0.052 | 10.09 | 3.42 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 44.9 | 194.5 | 0.049 | 6.61 | 4.33 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 218.1 | 819.1 | 0.955 | 32.10 | 3.76 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.1 | 107.7 | 0.040 | 4.14 | 3.83 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 30.0 | 105.7 | 0.048 | 4.41 | 3.53 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 95.0 | 346.2 | 0.354 | 13.99 | 3.64 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 32.6 | 144.5 | 0.053 | 4.80 | 4.43 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 88.5 | 406.5 | 0.093 | 13.02 | 4.60 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114902.6 | 403846.2 | 516.052 | 0.67 | 3.51 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 589377.2 | 2503286.2 | 1390.309 | 3.42 | 4.25 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 114111.5 | 404040.2 | 473.515 | 0.66 | 3.54 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3562482.6 | 18223876.2 | 2976.814 | 20.65 | 5.12 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311030.1 | 621743.2 | 607.711 | 1.80 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 227577.3 | 826618.2 | 2339.258 | 1.32 | 3.63 |
| string: silesia/dickens | 1 | 172528 | std.json | 1575157.8 | 4578768.2 | 42397.041 | 9.13 | 2.91 |
| string: silesia/dickens | 1 | 172528 | serde_json | 206582.7 | 802391.2 | 1017.536 | 1.20 | 3.88 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1061796.5 | 5279601.3 | 4890.536 | 6.15 | 4.97 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1563929.7 | 4799763.6 | 1244.214 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14421544.9 | 56816152.6 | 39269.714 | 12.12 | 3.94 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1561402.9 | 4799854.6 | 1078.357 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 29124812.4 | 132108253.6 | 160061.357 | 24.47 | 4.54 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4563787.9 | 7053838.6 | 549.429 | 3.83 | 1.55 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1811009.2 | 7322017.6 | 14023.786 | 1.52 | 4.04 |
| string: http/json-1m | 1 | 1190272 | std.json | 10412145.4 | 47381213.6 | 32566.143 | 8.75 | 4.55 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3764140.9 | 15226459.6 | 5974.714 | 3.16 | 4.05 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9218763.1 | 48020868.7 | 27333.714 | 7.75 | 5.21 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2069425.9 | 5765413.8 | 4460.875 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6162734.5 | 22589263.8 | 6993.500 | 3.27 | 3.67 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2059022.4 | 5765504.8 | 3946.125 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47251676.0 | 227842320.8 | 277833.500 | 25.09 | 4.82 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3683107.1 | 7945848.8 | 1906.625 | 1.96 | 2.16 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7167886.3 | 12276727.8 | 279477.500 | 3.81 | 1.71 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17478030.6 | 63617055.8 | 267903.875 | 9.28 | 3.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9396123.6 | 24440755.8 | 327070.750 | 4.99 | 2.60 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39121935.8 | 160429593.8 | 825584.625 | 20.78 | 4.10 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12908851.0 | 42561069.3 | 245233.333 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 161354787.0 | 667246747.3 | 396588.333 | 31.79 | 4.14 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12902478.7 | 42561160.3 | 245967.667 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 159531122.0 | 639992662.3 | 424247.667 | 31.43 | 4.01 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17593184.0 | 49745819.3 | 220108.000 | 3.47 | 2.83 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 13631544.0 | 44816977.3 | 456591.000 | 2.69 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79366005.7 | 314900845.3 | 457238.000 | 15.64 | 3.97 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36116890.7 | 131556135.3 | 591493.000 | 7.12 | 3.64 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66045624.3 | 273918938.3 | 838860.667 | 13.01 | 4.15 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 94084.7 | 303836.7 | 2.903 | 0.18 | 3.23 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 189965.2 | 623465.7 | 7.516 | 0.36 | 3.28 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 188316.5 | 623245.7 | 8.387 | 0.36 | 3.31 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10293884.4 | 53478202.7 | 8.387 | 19.63 | 5.20 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 490950.5 | 1376732.7 | 4.581 | 0.94 | 2.80 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 537475.5 | 2195905.7 | 7.903 | 1.03 | 4.09 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3520298.6 | 12808414.7 | 61433.935 | 6.71 | 3.64 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 287713.0 | 1179969.7 | 5.161 | 0.55 | 4.10 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2247618.9 | 12786837.8 | 233.000 | 4.29 | 5.69 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.4 | 81.8 | 0.107 | 2.29 | 4.23 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.2 | 153.6 | 0.127 | 4.15 | 4.37 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 23.2 | 103.2 | 0.096 | 2.74 | 4.45 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 216.1 | 981.0 | 0.935 | 25.53 | 4.54 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 18.7 | 79.5 | 0.106 | 2.21 | 4.25 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 22.9 | 94.1 | 0.134 | 2.70 | 4.11 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 26.7 | 105.4 | 0.243 | 3.16 | 3.94 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 68.9 | 310.8 | 0.363 | 8.14 | 4.51 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.5 | 255.3 | 0.494 | 7.50 | 4.02 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.7 | 315.1 | 0.251 | 8.11 | 4.59 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.2 | 82.8 | 0.025 | 2.68 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.1 | 153.9 | 0.026 | 5.31 | 4.26 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 22.5 | 101.7 | 0.024 | 3.32 | 4.52 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 167.8 | 718.3 | 1.240 | 24.69 | 4.28 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 17.7 | 81.5 | 0.024 | 2.60 | 4.61 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.4 | 96.6 | 0.032 | 3.14 | 4.52 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.1 | 117.7 | 0.032 | 4.14 | 4.18 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.5 | 271.2 | 0.244 | 8.76 | 4.56 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 50.2 | 211.7 | 0.038 | 7.39 | 4.22 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 81.9 | 331.7 | 0.088 | 12.06 | 4.05 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 85061.2 | 280786.2 | 723.691 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84910.8 | 280732.2 | 718.237 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84840.9 | 280724.2 | 718.454 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3351174.8 | 16047574.2 | 2950.763 | 19.42 | 4.79 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 82832.4 | 274401.2 | 650.464 | 0.48 | 3.31 |
| string: silesia/dickens | 1 | 172528 | simdjson | 206415.1 | 674008.2 | 2042.351 | 1.20 | 3.27 |
| string: silesia/dickens | 1 | 172528 | yyjson | 215784.6 | 848559.2 | 1404.443 | 1.25 | 3.93 |
| string: silesia/dickens | 1 | 172528 | std.json | 1363567.2 | 2890892.2 | 54633.268 | 7.90 | 2.12 |
| string: silesia/dickens | 1 | 172528 | serde_json | 373757.2 | 1586249.2 | 2279.742 | 2.17 | 4.24 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 584958.8 | 2970251.9 | 2902.680 | 3.39 | 5.08 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1281036.6 | 3582350.6 | 11933.714 | 1.08 | 2.80 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1274399.6 | 3582290.6 | 11695.429 | 1.07 | 2.81 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1271991.1 | 3582278.6 | 11612.286 | 1.07 | 2.82 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25072372.1 | 109856348.6 | 140954.857 | 21.06 | 4.38 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1230375.8 | 3370022.6 | 11127.857 | 1.03 | 2.74 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2997739.9 | 10460754.6 | 29611.786 | 2.52 | 3.49 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2668266.4 | 11226214.6 | 9733.286 | 2.24 | 4.21 |
| string: http/json-1m | 1 | 1190272 | std.json | 8958252.2 | 43287986.6 | 16299.357 | 7.53 | 4.83 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4206117.9 | 17941088.6 | 10891.857 | 3.53 | 4.27 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5226913.4 | 26999472.1 | 11036.714 | 4.39 | 5.17 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2070926.1 | 6088099.8 | 4616.000 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2060879.9 | 6088039.8 | 4141.125 | 1.09 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2061953.5 | 6088027.8 | 4084.250 | 1.09 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43502472.4 | 193466548.8 | 272268.750 | 23.10 | 4.45 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2067964.8 | 5875346.8 | 4701.000 | 1.10 | 2.84 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2706990.0 | 7144135.8 | 20793.625 | 1.44 | 2.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12452076.8 | 26334410.8 | 417732.750 | 6.61 | 2.11 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20483219.9 | 56837736.8 | 550818.250 | 10.88 | 2.77 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11415520.5 | 33662338.8 | 343500.375 | 6.06 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18229252.8 | 76318998.5 | 251822.125 | 9.68 | 4.19 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113163.9 | 426376.7 | 5.871 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113082.4 | 426318.7 | 2.194 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113099.3 | 426299.7 | 2.387 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 635495.2 | 3146479.7 | 5.387 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113241.7 | 426343.7 | 2.290 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1204992.7 | 3866907.7 | 4.774 | 2.30 | 3.21 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1628286.8 | 5833344.7 | 5.419 | 3.11 | 3.58 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3580530.8 | 13108830.7 | 61468.742 | 6.83 | 3.66 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1789553.8 | 7405810.7 | 4.032 | 3.41 | 4.14 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2385713.3 | 12748182.9 | 14.097 | 4.55 | 5.34 |
