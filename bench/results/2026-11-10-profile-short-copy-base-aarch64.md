# bench-profile

| Field | Value |
|---|---|
| Commit | 8eefa96 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261101.172.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/42924395454 |
| Date | 2026-11-10 |

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
| silesia/dickens | 10192446 | zlib | 7.94 | 15.77 | 1.99 | 300.81 |
| silesia/dickens | 10192446 | zlib-ng | 4.87 | 10.50 | 2.15 | 67.49 |
| silesia/dickens | 10192446 | libdeflate | 3.46 | 9.56 | 2.77 | 66.18 |
| silesia/dickens | 10192446 | Wuffs | 4.90 | 10.85 | 2.21 | 97.61 |
| silesia/dickens | 10192446 | stdx | 2.93 | 7.15 | 2.43 | 75.91 |
| silesia/mozilla | 51220480 | zlib | 7.79 | 14.13 | 1.82 | 243.48 |
| silesia/mozilla | 51220480 | zlib-ng | 4.96 | 8.95 | 1.81 | 85.54 |
| silesia/mozilla | 51220480 | libdeflate | 3.47 | 7.63 | 2.20 | 71.02 |
| silesia/mozilla | 51220480 | Wuffs | 5.72 | 10.84 | 1.89 | 132.98 |
| silesia/mozilla | 51220480 | stdx | 3.64 | 6.29 | 1.73 | 89.02 |
| silesia/mr | 9970564 | zlib | 7.69 | 15.26 | 1.98 | 198.87 |
| silesia/mr | 9970564 | zlib-ng | 4.79 | 9.98 | 2.08 | 67.75 |
| silesia/mr | 9970564 | libdeflate | 3.34 | 8.58 | 2.57 | 61.06 |
| silesia/mr | 9970564 | Wuffs | 5.27 | 10.93 | 2.08 | 100.71 |
| silesia/mr | 9970564 | stdx | 3.10 | 6.70 | 2.16 | 69.47 |
| silesia/nci | 33553445 | zlib | 2.92 | 7.25 | 2.48 | 80.14 |
| silesia/nci | 33553445 | zlib-ng | 1.58 | 3.13 | 1.98 | 33.54 |
| silesia/nci | 33553445 | libdeflate | 1.11 | 2.66 | 2.41 | 27.61 |
| silesia/nci | 33553445 | Wuffs | 1.71 | 3.38 | 1.98 | 42.54 |
| silesia/nci | 33553445 | stdx | 1.17 | 2.20 | 1.88 | 37.26 |
| silesia/ooffice | 6152192 | zlib | 11.06 | 17.83 | 1.61 | 402.61 |
| silesia/ooffice | 6152192 | zlib-ng | 6.92 | 12.04 | 1.74 | 140.28 |
| silesia/ooffice | 6152192 | libdeflate | 4.90 | 10.45 | 2.13 | 125.29 |
| silesia/ooffice | 6152192 | Wuffs | 8.11 | 14.47 | 1.78 | 221.97 |
| silesia/ooffice | 6152192 | stdx | 5.07 | 8.55 | 1.69 | 150.18 |
| silesia/osdb | 10085684 | zlib | 6.82 | 13.54 | 1.99 | 172.85 |
| silesia/osdb | 10085684 | zlib-ng | 4.30 | 8.38 | 1.95 | 52.81 |
| silesia/osdb | 10085684 | libdeflate | 2.85 | 6.91 | 2.43 | 29.83 |
| silesia/osdb | 10085684 | Wuffs | 5.18 | 10.56 | 2.04 | 83.37 |
| silesia/osdb | 10085684 | stdx | 2.79 | 5.65 | 2.03 | 41.13 |
| silesia/reymont | 6627202 | zlib | 6.64 | 12.73 | 1.92 | 254.47 |
| silesia/reymont | 6627202 | zlib-ng | 3.71 | 7.72 | 2.08 | 59.94 |
| silesia/reymont | 6627202 | libdeflate | 2.60 | 6.91 | 2.66 | 50.93 |
| silesia/reymont | 6627202 | Wuffs | 4.22 | 8.40 | 1.99 | 112.14 |
| silesia/reymont | 6627202 | stdx | 2.28 | 5.11 | 2.25 | 64.06 |
| silesia/samba | 21606400 | zlib | 5.49 | 11.09 | 2.02 | 170.48 |
| silesia/samba | 21606400 | zlib-ng | 3.36 | 6.47 | 1.93 | 55.97 |
| silesia/samba | 21606400 | libdeflate | 2.32 | 5.58 | 2.40 | 42.97 |
| silesia/samba | 21606400 | Wuffs | 3.66 | 7.33 | 2.00 | 81.17 |
| silesia/samba | 21606400 | stdx | 2.26 | 4.46 | 1.97 | 56.19 |
| silesia/sao | 7251944 | zlib | 9.90 | 20.36 | 2.06 | 197.45 |
| silesia/sao | 7251944 | zlib-ng | 7.85 | 14.83 | 1.89 | 79.21 |
| silesia/sao | 7251944 | libdeflate | 5.73 | 12.73 | 2.22 | 79.04 |
| silesia/sao | 7251944 | Wuffs | 8.15 | 18.14 | 2.23 | 85.92 |
| silesia/sao | 7251944 | stdx | 5.59 | 10.32 | 1.85 | 87.07 |
| silesia/webster | 41458703 | zlib | 7.01 | 12.99 | 1.85 | 273.67 |
| silesia/webster | 41458703 | zlib-ng | 4.23 | 8.04 | 1.90 | 84.87 |
| silesia/webster | 41458703 | libdeflate | 2.92 | 7.17 | 2.45 | 68.50 |
| silesia/webster | 41458703 | Wuffs | 4.51 | 8.62 | 1.91 | 123.12 |
| silesia/webster | 41458703 | stdx | 2.83 | 5.56 | 1.97 | 86.82 |
| silesia/x-ray | 8474240 | zlib | 12.29 | 23.82 | 1.94 | 324.60 |
| silesia/x-ray | 8474240 | zlib-ng | 9.06 | 17.39 | 1.92 | 124.37 |
| silesia/x-ray | 8474240 | libdeflate | 6.54 | 15.26 | 2.33 | 124.43 |
| silesia/x-ray | 8474240 | Wuffs | 10.13 | 20.40 | 2.01 | 192.82 |
| silesia/x-ray | 8474240 | stdx | 6.15 | 11.49 | 1.87 | 137.65 |
| silesia/xml | 5345280 | zlib | 3.61 | 8.20 | 2.27 | 116.02 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.72 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.46 | 31.56 |
| silesia/xml | 5345280 | Wuffs | 2.19 | 4.14 | 1.89 | 61.00 |
| silesia/xml | 5345280 | stdx | 1.32 | 2.65 | 2.01 | 41.61 |
| canterbury/alice29.txt | 152089 | zlib | 7.60 | 15.08 | 1.99 | 285.25 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.51 | 9.91 | 2.20 | 60.10 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.20 | 8.96 | 2.80 | 56.38 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.70 | 10.37 | 2.20 | 98.77 |
| canterbury/alice29.txt | 152089 | stdx | 2.71 | 6.99 | 2.58 | 62.42 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.13 | 16.11 | 1.98 | 302.39 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 72.48 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.60 | 9.82 | 2.73 | 68.11 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.09 | 11.34 | 2.23 | 100.35 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.05 | 7.52 | 2.47 | 76.71 |
| canterbury/cp.html | 24603 | zlib | 6.52 | 14.20 | 2.18 | 171.08 |
| canterbury/cp.html | 24603 | zlib-ng | 4.16 | 9.50 | 2.28 | 35.85 |
| canterbury/cp.html | 24603 | libdeflate | 2.87 | 7.95 | 2.77 | 18.23 |
| canterbury/cp.html | 24603 | Wuffs | 4.48 | 10.87 | 2.42 | 57.10 |
| canterbury/cp.html | 24603 | stdx | 2.66 | 7.19 | 2.70 | 13.43 |
| canterbury/fields.c | 11150 | zlib | 4.64 | 14.65 | 3.16 | 38.43 |
| canterbury/fields.c | 11150 | zlib-ng | 3.87 | 10.20 | 2.63 | 14.57 |
| canterbury/fields.c | 11150 | libdeflate | 2.78 | 8.32 | 2.99 | 1.40 |
| canterbury/fields.c | 11150 | Wuffs | 3.80 | 11.51 | 3.03 | 8.23 |
| canterbury/fields.c | 11150 | stdx | 2.50 | 7.64 | 3.06 | 4.77 |
| canterbury/grammar.lsp | 3721 | zlib | 6.21 | 21.22 | 3.41 | 1.92 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.86 | 17.48 | 2.98 | 9.54 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.40 | 12.05 | 2.74 | 0.67 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.95 | 18.87 | 3.17 | 2.70 |
| canterbury/grammar.lsp | 3721 | stdx | 3.84 | 12.18 | 3.17 | 0.79 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.96 | 12.20 | 3.08 | 49.12 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.54 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.27 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.20 | 8.67 | 2.71 | 14.77 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.74 | 4.66 | 2.68 | 16.63 |
| canterbury/lcet10.txt | 426754 | zlib | 7.37 | 14.53 | 1.97 | 279.67 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.18 | 60.70 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.04 | 8.48 | 2.79 | 55.19 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.56 | 9.85 | 2.16 | 101.12 |
| canterbury/lcet10.txt | 426754 | stdx | 2.61 | 6.42 | 2.46 | 66.86 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.31 | 16.53 | 1.99 | 310.76 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.27 | 11.19 | 2.12 | 77.45 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.70 | 76.59 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.15 | 11.53 | 2.24 | 99.29 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.15 | 7.63 | 2.42 | 84.72 |
| canterbury/ptt5 | 513216 | zlib | 4.41 | 7.79 | 1.77 | 100.33 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.00 | 3.74 | 1.87 | 46.51 |
| canterbury/ptt5 | 513216 | libdeflate | 1.44 | 3.02 | 2.09 | 37.83 |
| canterbury/ptt5 | 513216 | Wuffs | 2.19 | 4.02 | 1.83 | 58.68 |
| canterbury/ptt5 | 513216 | stdx | 1.45 | 2.55 | 1.76 | 49.04 |
| canterbury/sum | 38240 | zlib | 7.32 | 14.98 | 2.04 | 218.55 |
| canterbury/sum | 38240 | zlib-ng | 4.64 | 10.02 | 2.16 | 55.65 |
| canterbury/sum | 38240 | libdeflate | 3.38 | 8.34 | 2.47 | 41.36 |
| canterbury/sum | 38240 | Wuffs | 5.00 | 11.41 | 2.28 | 76.42 |
| canterbury/sum | 38240 | stdx | 3.06 | 7.73 | 2.53 | 31.11 |
| canterbury/xargs.1 | 4227 | zlib | 6.66 | 22.08 | 3.32 | 5.58 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.40 | 17.97 | 2.81 | 10.85 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.76 | 13.27 | 2.79 | 1.37 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.48 | 19.63 | 3.03 | 9.00 |
| canterbury/xargs.1 | 4227 | stdx | 4.25 | 12.86 | 3.02 | 3.20 |
| canterbury-large/E.coli | 4638690 | zlib | 5.94 | 14.55 | 2.45 | 174.77 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.23 | 9.68 | 2.29 | 47.67 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.92 | 48.54 |
| canterbury-large/E.coli | 4638690 | Wuffs | 3.99 | 9.64 | 2.42 | 61.59 |
| canterbury-large/E.coli | 4638690 | stdx | 2.46 | 6.72 | 2.73 | 53.80 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.72 | 13.26 | 1.97 | 259.34 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.78 | 8.26 | 2.19 | 53.86 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.76 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.14 | 8.72 | 2.11 | 100.69 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.23 | 5.57 | 2.49 | 55.88 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.94 | 12.69 | 1.83 | 272.00 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.19 | 7.78 | 1.85 | 91.59 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.18 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.51 | 8.44 | 1.87 | 129.43 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 5.40 | 1.98 | 90.89 |
| http/html-1kx1024 | 1048576 | zlib | 15.82 | 32.44 | 2.05 | 349.43 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.69 | 28.43 | 2.24 | 217.85 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.58 | 20.05 | 1.90 | 155.88 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.60 | 35.05 | 2.40 | 263.73 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 137.36 |
| http/html-16kx64 | 1048576 | zlib | 6.01 | 11.79 | 1.96 | 215.07 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 84.90 |
| http/html-16kx64 | 1048576 | libdeflate | 2.64 | 6.04 | 2.29 | 60.63 |
| http/html-16kx64 | 1048576 | Wuffs | 4.26 | 8.51 | 2.00 | 116.64 |
| http/html-16kx64 | 1048576 | stdx | 2.52 | 5.56 | 2.21 | 59.01 |
| http/html-1m | 1048576 | zlib | 4.65 | 9.51 | 2.05 | 172.08 |
| http/html-1m | 1048576 | zlib-ng | 2.61 | 5.03 | 1.93 | 59.88 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.98 |
| http/html-1m | 1048576 | Wuffs | 2.95 | 5.42 | 1.84 | 90.28 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.11 | 52.27 |
| http/json-1kx1024 | 1048576 | zlib | 9.70 | 20.83 | 2.15 | 191.84 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.39 | 16.69 | 2.26 | 130.58 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.84 | 16.72 | 1.89 | 92.07 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.39 | 31.72 | 2.78 | 145.08 |
| http/json-1kx1024 | 1048576 | stdx | 5.04 | 13.12 | 2.61 | 81.37 |
| http/json-16kx64 | 1048576 | zlib | 3.94 | 9.62 | 2.44 | 101.93 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.89 |
| http/json-16kx64 | 1048576 | libdeflate | 1.90 | 4.24 | 2.23 | 39.69 |
| http/json-16kx64 | 1048576 | Wuffs | 2.81 | 6.35 | 2.26 | 58.22 |
| http/json-16kx64 | 1048576 | stdx | 1.75 | 3.97 | 2.26 | 39.56 |
| http/json-1m | 1048576 | zlib | 3.25 | 8.25 | 2.54 | 82.22 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.03 | 37.41 |
| http/json-1m | 1048576 | libdeflate | 1.37 | 3.33 | 2.42 | 32.00 |
| http/json-1m | 1048576 | Wuffs | 2.04 | 4.29 | 2.11 | 44.27 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.01 | 40.02 |
| http/js-1kx1024 | 1048576 | zlib | 17.32 | 35.33 | 2.04 | 403.07 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.78 | 31.25 | 2.27 | 239.12 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.27 | 21.58 | 1.92 | 179.42 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.74 | 37.71 | 2.40 | 295.63 |
| http/js-1kx1024 | 1048576 | stdx | 9.28 | 22.85 | 2.46 | 159.69 |
| http/js-16kx64 | 1048576 | zlib | 6.92 | 13.06 | 1.89 | 255.31 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.97 | 92.12 |
| http/js-16kx64 | 1048576 | libdeflate | 3.06 | 7.01 | 2.29 | 72.20 |
| http/js-16kx64 | 1048576 | Wuffs | 4.84 | 9.70 | 2.00 | 130.44 |
| http/js-16kx64 | 1048576 | stdx | 2.98 | 6.54 | 2.19 | 71.43 |
| http/js-1m | 1048576 | zlib | 5.16 | 10.26 | 1.99 | 195.56 |
| http/js-1m | 1048576 | zlib-ng | 2.87 | 5.66 | 1.97 | 59.87 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 42.07 |
| http/js-1m | 1048576 | Wuffs | 3.25 | 6.10 | 1.88 | 96.25 |
| http/js-1m | 1048576 | stdx | 1.80 | 3.89 | 2.16 | 55.25 |
| http/css-1kx1024 | 1048576 | zlib | 13.15 | 27.18 | 2.07 | 280.91 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.27 | 23.04 | 2.24 | 171.13 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.17 | 17.37 | 1.89 | 121.24 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.02 | 29.48 | 2.45 | 210.00 |
| http/css-1kx1024 | 1048576 | stdx | 6.68 | 17.64 | 2.64 | 100.70 |
| http/css-16kx64 | 1048576 | zlib | 4.66 | 10.12 | 2.17 | 151.53 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.77 | 6.07 | 2.19 | 49.83 |
| http/css-16kx64 | 1048576 | libdeflate | 1.87 | 4.69 | 2.51 | 28.35 |
| http/css-16kx64 | 1048576 | Wuffs | 3.12 | 6.97 | 2.23 | 70.53 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.53 | 28.35 |
| http/css-1m | 1048576 | zlib | 3.38 | 8.00 | 2.37 | 107.56 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.22 | 28.73 |
| http/css-1m | 1048576 | libdeflate | 1.05 | 3.18 | 3.04 | 10.46 |
| http/css-1m | 1048576 | Wuffs | 1.91 | 4.08 | 2.14 | 44.72 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.53 | 21.47 |
| shuffled/dickens-1m | 1048576 | zlib | 12.72 | 22.42 | 1.76 | 371.48 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.71 | 16.72 | 1.72 | 196.00 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.02 | 14.95 | 2.13 | 192.95 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.65 | 18.95 | 1.96 | 205.61 |
| shuffled/dickens-1m | 1048576 | stdx | 7.05 | 11.89 | 1.69 | 208.85 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.47 | 14.04 | 4.04 | 3.58 |
| silesia/dickens | 10192446 | stdx | 3.60 | 12.47 | 3.46 | 3.56 |
| silesia/mozilla | 51220480 | libzstd | 2.83 | 9.62 | 3.40 | 30.09 |
| silesia/mozilla | 51220480 | stdx | 2.81 | 9.68 | 3.44 | 15.67 |
| silesia/mr | 9970564 | libzstd | 3.03 | 11.98 | 3.95 | 6.26 |
| silesia/mr | 9970564 | stdx | 3.04 | 10.83 | 3.56 | 5.17 |
| silesia/nci | 33553445 | libzstd | 1.60 | 4.84 | 3.03 | 23.45 |
| silesia/nci | 33553445 | stdx | 1.73 | 4.63 | 2.67 | 13.62 |
| silesia/ooffice | 6152192 | libzstd | 3.40 | 12.14 | 3.57 | 31.08 |
| silesia/ooffice | 6152192 | stdx | 3.34 | 12.40 | 3.71 | 12.15 |
| silesia/osdb | 10085684 | libzstd | 2.33 | 8.44 | 3.62 | 15.55 |
| silesia/osdb | 10085684 | stdx | 2.38 | 8.11 | 3.40 | 15.70 |
| silesia/reymont | 6627202 | libzstd | 3.08 | 11.61 | 3.77 | 11.66 |
| silesia/reymont | 6627202 | stdx | 3.20 | 10.36 | 3.24 | 12.83 |
| silesia/samba | 21606400 | libzstd | 2.02 | 7.39 | 3.65 | 18.68 |
| silesia/samba | 21606400 | stdx | 2.08 | 6.83 | 3.28 | 17.58 |
| silesia/sao | 7251944 | libzstd | 3.81 | 12.69 | 3.33 | 26.45 |
| silesia/sao | 7251944 | stdx | 3.47 | 12.58 | 3.63 | 6.36 |
| silesia/webster | 41458703 | libzstd | 3.13 | 11.22 | 3.59 | 16.31 |
| silesia/webster | 41458703 | stdx | 3.24 | 10.05 | 3.10 | 17.18 |
| silesia/x-ray | 8474240 | libzstd | 3.97 | 14.93 | 3.76 | 18.74 |
| silesia/x-ray | 8474240 | stdx | 3.54 | 13.23 | 3.74 | 8.40 |
| silesia/xml | 5345280 | libzstd | 1.52 | 5.55 | 3.64 | 22.78 |
| silesia/xml | 5345280 | stdx | 1.51 | 5.16 | 3.41 | 17.09 |
| canterbury/alice29.txt | 152089 | libzstd | 3.36 | 16.18 | 4.81 | 4.18 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.35 | 0.46 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.00 | 14.25 | 4.75 | 3.28 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.29 | 0.19 |
| canterbury/cp.html | 24603 | libzstd | 2.67 | 10.74 | 4.03 | 9.14 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.11 | 0.22 |
| canterbury/fields.c | 11150 | libzstd | 3.15 | 13.61 | 4.32 | 9.71 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.23 | 0.09 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.23 | 16.93 | 4.00 | 6.22 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.54 | 4.01 | 0.15 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.48 | 11.22 | 4.52 | 7.67 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.68 | 11.32 | 4.23 | 0.92 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.74 | 12.87 | 4.70 | 5.40 |
| canterbury/lcet10.txt | 426754 | stdx | 2.71 | 11.52 | 4.25 | 2.53 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.17 | 15.14 | 4.78 | 1.58 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.25 | 0.98 |
| canterbury/ptt5 | 513216 | libzstd | 1.44 | 4.50 | 3.11 | 24.41 |
| canterbury/ptt5 | 513216 | stdx | 1.35 | 4.46 | 3.31 | 14.34 |
| canterbury/sum | 38240 | libzstd | 2.64 | 10.51 | 3.98 | 10.36 |
| canterbury/sum | 38240 | stdx | 2.63 | 10.74 | 4.09 | 0.33 |
| canterbury/xargs.1 | 4227 | libzstd | 4.30 | 17.40 | 4.05 | 11.24 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.17 | 4.05 | 0.32 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.00 | 13.63 | 4.55 | 2.14 |
| canterbury-large/E.coli | 4638690 | stdx | 3.06 | 12.04 | 3.93 | 2.94 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.91 | 11.99 | 4.12 | 8.46 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.01 | 10.64 | 3.54 | 9.21 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.50 | 9.59 | 3.84 | 19.83 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.60 | 8.64 | 3.33 | 21.20 |
| http/html-1kx1024 | 1048576 | libzstd | 7.40 | 21.63 | 2.92 | 62.82 |
| http/html-1kx1024 | 1048576 | stdx | 7.44 | 22.46 | 3.02 | 76.08 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.66 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.60 | 30.48 |
| http/html-1m | 1048576 | libzstd | 1.98 | 7.86 | 3.96 | 24.11 |
| http/html-1m | 1048576 | stdx | 2.00 | 7.12 | 3.56 | 24.93 |
| http/json-1kx1024 | 1048576 | libzstd | 6.38 | 17.37 | 2.72 | 49.18 |
| http/json-1kx1024 | 1048576 | stdx | 6.19 | 17.86 | 2.89 | 53.15 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.22 | 3.52 | 27.99 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 19.76 |
| http/json-1m | 1048576 | libzstd | 1.71 | 6.04 | 3.53 | 27.58 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.63 | 14.35 |
| http/js-1kx1024 | 1048576 | libzstd | 8.44 | 26.38 | 3.12 | 72.93 |
| http/js-1kx1024 | 1048576 | stdx | 9.01 | 27.60 | 3.06 | 112.43 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.71 | 4.00 | 24.52 |
| http/js-16kx64 | 1048576 | stdx | 2.95 | 11.06 | 3.75 | 25.56 |
| http/js-1m | 1048576 | libzstd | 2.01 | 8.18 | 4.07 | 20.39 |
| http/js-1m | 1048576 | stdx | 2.07 | 7.48 | 3.62 | 21.20 |
| http/css-1kx1024 | 1048576 | libzstd | 7.03 | 19.70 | 2.80 | 53.46 |
| http/css-1kx1024 | 1048576 | stdx | 6.82 | 19.96 | 2.93 | 63.12 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.69 | 3.88 | 23.27 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.19 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.57 | 3.88 | 5.62 |
| http/css-1m | 1048576 | stdx | 0.72 | 2.49 | 3.47 | 4.51 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.80 | 9.40 | 3.36 | 28.58 |
| shuffled/dickens-1m | 1048576 | stdx | 2.72 | 9.19 | 3.38 | 12.49 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.50 | 17.04 | 2.27 | 100.84 |
| silesia/dickens | 1048576 | stdx | 5.06 | 12.38 | 2.45 | 54.58 |
| silesia/mozilla | 1048576 | Google | 13.58 | 27.77 | 2.04 | 46.60 |
| silesia/mozilla | 1048576 | stdx | 8.31 | 15.02 | 1.81 | 47.02 |
| silesia/mr | 1048576 | Google | 8.91 | 20.24 | 2.27 | 102.31 |
| silesia/mr | 1048576 | stdx | 5.78 | 13.25 | 2.29 | 88.60 |
| silesia/nci | 1048576 | Google | 2.56 | 5.69 | 2.22 | 52.36 |
| silesia/nci | 1048576 | stdx | 1.95 | 3.95 | 2.03 | 55.89 |
| silesia/ooffice | 1048576 | Google | 14.16 | 29.28 | 2.07 | 287.53 |
| silesia/ooffice | 1048576 | stdx | 10.84 | 20.33 | 1.88 | 323.70 |
| silesia/osdb | 1048576 | Google | 8.21 | 17.38 | 2.12 | 95.84 |
| silesia/osdb | 1048576 | stdx | 5.15 | 10.57 | 2.05 | 92.69 |
| silesia/reymont | 1048576 | Google | 5.43 | 12.73 | 2.35 | 81.65 |
| silesia/reymont | 1048576 | stdx | 3.71 | 9.25 | 2.49 | 47.80 |
| silesia/samba | 1048576 | Google | 7.58 | 16.22 | 2.14 | 95.95 |
| silesia/samba | 1048576 | stdx | 5.05 | 10.71 | 2.12 | 67.24 |
| silesia/sao | 1048576 | Google | 16.82 | 36.97 | 2.20 | 162.08 |
| silesia/sao | 1048576 | stdx | 10.39 | 22.65 | 2.18 | 142.51 |
| silesia/webster | 1048576 | Google | 6.54 | 14.07 | 2.15 | 114.94 |
| silesia/webster | 1048576 | stdx | 4.37 | 9.98 | 2.28 | 68.93 |
| silesia/x-ray | 1048576 | Google | 19.30 | 38.46 | 1.99 | 234.04 |
| silesia/x-ray | 1048576 | stdx | 14.53 | 30.18 | 2.08 | 234.11 |
| silesia/xml | 1048576 | Google | 3.47 | 7.65 | 2.21 | 65.44 |
| silesia/xml | 1048576 | stdx | 2.40 | 5.40 | 2.25 | 47.50 |
| canterbury/alice29.txt | 152089 | Google | 8.91 | 20.66 | 2.32 | 135.68 |
| canterbury/alice29.txt | 152089 | stdx | 6.13 | 15.33 | 2.50 | 83.35 |
| canterbury/asyoulik.txt | 125179 | Google | 10.42 | 23.83 | 2.29 | 170.07 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.03 | 17.43 | 2.48 | 102.67 |
| canterbury/cp.html | 24603 | Google | 9.15 | 22.18 | 2.42 | 110.85 |
| canterbury/cp.html | 24603 | stdx | 6.22 | 17.15 | 2.76 | 57.29 |
| canterbury/fields.c | 11150 | Google | 7.08 | 21.25 | 3.00 | 20.94 |
| canterbury/fields.c | 11150 | stdx | 4.86 | 17.08 | 3.51 | 1.82 |
| canterbury/grammar.lsp | 3721 | Google | 9.88 | 30.23 | 3.06 | 5.84 |
| canterbury/grammar.lsp | 3721 | stdx | 7.15 | 25.04 | 3.50 | 0.86 |
| canterbury/kennedy.xls | 1029744 | Google | 5.48 | 17.05 | 3.11 | 37.10 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.80 | 12.94 | 3.40 | 33.94 |
| canterbury/lcet10.txt | 426754 | Google | 7.75 | 17.42 | 2.25 | 129.46 |
| canterbury/lcet10.txt | 426754 | stdx | 5.19 | 12.96 | 2.50 | 66.34 |
| canterbury/plrabn12.txt | 481861 | Google | 9.10 | 20.94 | 2.30 | 134.14 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.14 | 15.04 | 2.45 | 87.98 |
| canterbury/ptt5 | 513216 | Google | 4.30 | 10.36 | 2.41 | 62.34 |
| canterbury/ptt5 | 513216 | stdx | 2.38 | 4.89 | 2.05 | 66.61 |
| canterbury/sum | 38240 | Google | 10.84 | 26.44 | 2.44 | 157.16 |
| canterbury/sum | 38240 | stdx | 8.41 | 21.11 | 2.51 | 159.06 |
| canterbury/xargs.1 | 4227 | Google | 10.90 | 34.81 | 3.19 | 8.84 |
| canterbury/xargs.1 | 4227 | stdx | 8.47 | 30.44 | 3.59 | 7.31 |
| canterbury-large/E.coli | 1048576 | Google | 7.47 | 19.44 | 2.60 | 1.35 |
| canterbury-large/E.coli | 1048576 | stdx | 6.72 | 13.48 | 2.01 | 1.71 |
| canterbury-large/bible.txt | 1048576 | Google | 5.33 | 12.38 | 2.33 | 80.65 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.53 | 8.93 | 2.53 | 39.85 |
| canterbury-large/world192.txt | 1048576 | Google | 6.20 | 12.88 | 2.08 | 115.54 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.39 | 9.38 | 2.14 | 77.46 |
| http/html-1kx1024 | 1048576 | Google | 17.93 | 42.09 | 2.35 | 387.66 |
| http/html-1kx1024 | 1048576 | stdx | 15.25 | 37.56 | 2.46 | 360.72 |
| http/html-16kx64 | 1048576 | Google | 6.78 | 14.88 | 2.20 | 149.69 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 115.05 |
| http/html-1m | 1048576 | Google | 4.06 | 8.99 | 2.22 | 83.30 |
| http/html-1m | 1048576 | stdx | 2.85 | 6.52 | 2.29 | 55.10 |
| http/json-1kx1024 | 1048576 | Google | 14.29 | 36.74 | 2.57 | 239.43 |
| http/json-1kx1024 | 1048576 | stdx | 12.96 | 33.63 | 2.59 | 277.11 |
| http/json-16kx64 | 1048576 | Google | 4.42 | 11.42 | 2.59 | 81.22 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.54 |
| http/json-1m | 1048576 | Google | 3.41 | 8.66 | 2.54 | 58.90 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.44 | 57.61 |
| http/js-1kx1024 | 1048576 | Google | 19.89 | 46.38 | 2.33 | 428.77 |
| http/js-1kx1024 | 1048576 | stdx | 16.33 | 39.90 | 2.44 | 379.62 |
| http/js-16kx64 | 1048576 | Google | 8.08 | 17.79 | 2.20 | 167.42 |
| http/js-16kx64 | 1048576 | stdx | 6.04 | 14.36 | 2.38 | 126.37 |
| http/js-1m | 1048576 | Google | 4.38 | 9.60 | 2.19 | 83.32 |
| http/js-1m | 1048576 | stdx | 3.14 | 7.25 | 2.31 | 55.52 |
| http/css-1kx1024 | 1048576 | Google | 15.34 | 37.48 | 2.44 | 292.18 |
| http/css-1kx1024 | 1048576 | stdx | 13.78 | 34.70 | 2.52 | 302.34 |
| http/css-16kx64 | 1048576 | Google | 4.97 | 11.78 | 2.37 | 100.73 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.52 |
| http/css-1m | 1048576 | Google | 2.43 | 9.43 | 3.88 | 16.78 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.49 | 12.26 |
| shuffled/dickens-1m | 1048576 | Google | 9.68 | 20.34 | 2.10 | 108.99 |
| shuffled/dickens-1m | 1048576 | stdx | 8.77 | 14.53 | 1.66 | 116.10 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.22 | 36.91 | 2.43 | 411.07 |
| silesia/dickens | 10192446 | 1 | stdx | 16.35 | 38.17 | 2.33 | 358.35 |
| silesia/dickens | 10192446 | 6 | libdeflate | 51.98 | 87.63 | 1.69 | 691.70 |
| silesia/dickens | 10192446 | 6 | stdx | 49.59 | 84.25 | 1.70 | 1448.47 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.78 | 160.47 | 1.44 | 930.16 |
| silesia/dickens | 10192446 | 9 | stdx | 64.84 | 150.06 | 2.31 | 1397.64 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.08 | 32.62 | 2.32 | 436.65 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.31 | 30.24 | 2.27 | 294.57 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.84 | 70.83 | 2.16 | 578.28 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.54 | 69.96 | 2.22 | 737.06 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.66 | 221.49 | 1.74 | 772.07 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.62 | 125.42 | 2.58 | 783.77 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.94 | 35.02 | 2.93 | 229.09 |
| silesia/mr | 9970564 | 1 | stdx | 12.53 | 34.08 | 2.72 | 186.97 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.23 | 80.54 | 2.11 | 436.85 |
| silesia/mr | 9970564 | 6 | stdx | 39.77 | 83.18 | 2.09 | 979.61 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.55 | 165.48 | 1.70 | 749.91 |
| silesia/mr | 9970564 | 9 | stdx | 78.94 | 184.93 | 2.34 | 1221.83 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.20 | 18.42 | 2.97 | 114.56 |
| silesia/nci | 33553445 | 1 | stdx | 4.92 | 10.88 | 2.21 | 97.46 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.97 | 34.84 | 2.05 | 225.75 |
| silesia/nci | 33553445 | 6 | stdx | 14.42 | 29.54 | 2.05 | 397.30 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.44 | 105.28 | 1.69 | 501.80 |
| silesia/nci | 33553445 | 9 | stdx | 28.30 | 69.01 | 2.44 | 559.43 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.87 | 39.15 | 1.97 | 751.69 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.73 | 39.08 | 2.20 | 429.25 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 40.99 | 79.10 | 1.93 | 953.34 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.60 | 87.83 | 2.11 | 1011.63 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.63 | 127.63 | 1.71 | 1133.13 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.17 | 129.03 | 2.47 | 931.47 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.86 | 30.15 | 2.34 | 352.78 |
| silesia/osdb | 10085684 | 1 | stdx | 12.88 | 27.86 | 2.16 | 292.94 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.29 | 55.67 | 1.97 | 490.53 |
| silesia/osdb | 10085684 | 6 | stdx | 27.10 | 57.39 | 2.12 | 573.17 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.90 | 64.15 | 1.89 | 552.69 |
| silesia/osdb | 10085684 | 9 | stdx | 35.23 | 87.16 | 2.47 | 680.83 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.55 | 32.88 | 2.62 | 310.00 |
| silesia/reymont | 6627202 | 1 | stdx | 13.37 | 33.24 | 2.49 | 271.47 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.15 | 86.58 | 1.80 | 521.06 |
| silesia/reymont | 6627202 | 6 | stdx | 45.28 | 76.81 | 1.70 | 1432.52 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.31 | 276.14 | 1.39 | 839.65 |
| silesia/reymont | 6627202 | 9 | stdx | 74.20 | 160.03 | 2.16 | 1435.45 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.43 | 26.53 | 2.54 | 271.98 |
| silesia/samba | 21606400 | 1 | stdx | 9.88 | 22.23 | 2.25 | 220.91 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.93 | 58.79 | 2.03 | 384.76 |
| silesia/samba | 21606400 | 6 | stdx | 24.13 | 49.83 | 2.07 | 628.09 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.21 | 141.44 | 1.68 | 504.44 |
| silesia/samba | 21606400 | 9 | stdx | 36.14 | 90.81 | 2.51 | 644.57 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.67 | 47.87 | 2.21 | 682.51 |
| silesia/sao | 7251944 | 1 | stdx | 19.09 | 49.92 | 2.61 | 345.79 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.13 | 96.89 | 1.90 | 961.03 |
| silesia/sao | 7251944 | 6 | stdx | 47.15 | 105.66 | 2.24 | 860.28 |
| silesia/sao | 7251944 | 9 | libdeflate | 70.96 | 120.26 | 1.69 | 1105.36 |
| silesia/sao | 7251944 | 9 | stdx | 55.05 | 137.71 | 2.50 | 834.97 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.11 | 30.45 | 2.32 | 387.50 |
| silesia/webster | 41458703 | 1 | stdx | 13.84 | 29.08 | 2.10 | 340.19 |
| silesia/webster | 41458703 | 6 | libdeflate | 37.00 | 66.02 | 1.78 | 569.85 |
| silesia/webster | 41458703 | 6 | stdx | 35.30 | 60.87 | 1.72 | 1128.56 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.63 | 138.85 | 1.47 | 756.93 |
| silesia/webster | 41458703 | 9 | stdx | 48.43 | 110.73 | 2.29 | 1085.11 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.67 | 49.67 | 2.10 | 783.10 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.53 | 50.81 | 2.90 | 261.62 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.81 | 82.77 | 2.52 | 851.39 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.85 | 98.12 | 2.90 | 538.26 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.52 | 91.03 | 2.43 | 1030.29 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.46 | 121.58 | 3.00 | 466.23 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.77 | 21.59 | 2.78 | 175.44 |
| silesia/xml | 5345280 | 1 | stdx | 6.87 | 15.66 | 2.28 | 154.84 |
| silesia/xml | 5345280 | 6 | libdeflate | 20.98 | 40.51 | 1.93 | 264.24 |
| silesia/xml | 5345280 | 6 | stdx | 17.59 | 34.32 | 1.95 | 503.05 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.69 | 89.17 | 1.52 | 372.32 |
| silesia/xml | 5345280 | 9 | stdx | 26.62 | 63.43 | 2.38 | 525.89 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.23 | 35.61 | 2.50 | 377.49 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.03 | 36.12 | 2.40 | 336.10 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.71 | 82.29 | 1.76 | 639.24 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.80 | 77.41 | 1.77 | 1331.96 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.59 | 159.21 | 1.48 | 850.19 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 58.28 | 138.20 | 2.37 | 1269.65 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.13 | 37.20 | 2.46 | 414.12 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.77 | 37.43 | 2.37 | 360.25 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.29 | 85.43 | 1.77 | 712.51 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.14 | 81.92 | 1.78 | 1388.32 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.91 | 136.15 | 1.53 | 938.39 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 60.22 | 144.56 | 2.40 | 1336.50 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.66 | 32.02 | 2.75 | 284.07 |
| canterbury/cp.html | 24603 | 1 | stdx | 11.21 | 27.13 | 2.42 | 258.70 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 26.93 | 62.33 | 2.31 | 483.16 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.82 | 57.05 | 2.40 | 631.28 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 47.07 | 91.97 | 1.95 | 604.42 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.29 | 88.88 | 2.84 | 645.90 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.83 | 35.92 | 3.66 | 83.01 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.05 | 30.05 | 3.73 | 21.36 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.33 | 69.37 | 2.85 | 233.20 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.89 | 57.62 | 2.76 | 432.57 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.61 | 100.81 | 2.26 | 424.57 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.42 | 92.65 | 3.26 | 450.53 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.09 | 51.51 | 3.94 | 17.18 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.89 | 39.01 | 3.95 | 3.17 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.75 | 87.06 | 3.67 | 28.90 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.17 | 70.80 | 4.12 | 19.25 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.66 | 102.89 | 3.36 | 38.27 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.67 | 99.30 | 4.20 | 50.97 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.37 | 27.18 | 3.69 | 65.20 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.03 | 22.58 | 3.21 | 63.59 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.90 | 73.85 | 2.65 | 96.70 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.32 | 61.98 | 3.21 | 139.41 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.22 | 664.23 | 1.83 | 164.22 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 30.16 | 107.06 | 3.55 | 143.71 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.77 | 33.99 | 2.47 | 370.16 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.44 | 33.92 | 2.35 | 329.53 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.00 | 78.22 | 1.74 | 606.00 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.76 | 73.42 | 1.76 | 1237.12 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.80 | 136.94 | 1.49 | 805.90 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 55.13 | 130.91 | 2.37 | 1197.09 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.79 | 38.62 | 2.45 | 425.90 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.75 | 40.24 | 2.40 | 371.92 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.12 | 91.90 | 1.70 | 751.96 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.74 | 88.89 | 1.72 | 1531.39 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.88 | 166.26 | 1.42 | 1003.83 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 67.86 | 158.18 | 2.33 | 1466.43 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.41 | 18.61 | 2.90 | 141.46 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.96 | 11.03 | 2.22 | 123.38 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.25 | 36.17 | 2.54 | 219.34 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.34 | 29.57 | 2.40 | 310.21 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.60 | 120.86 | 1.99 | 379.36 |
| canterbury/ptt5 | 513216 | 9 | stdx | 41.34 | 126.55 | 3.06 | 591.23 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.78 | 33.49 | 2.62 | 336.39 |
| canterbury/sum | 38240 | 1 | stdx | 12.65 | 29.36 | 2.32 | 302.00 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.61 | 69.87 | 2.44 | 495.96 |
| canterbury/sum | 38240 | 6 | stdx | 26.84 | 65.73 | 2.45 | 670.33 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.40 | 181.91 | 1.93 | 608.04 |
| canterbury/sum | 38240 | 9 | stdx | 39.24 | 112.32 | 2.86 | 660.90 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.51 | 53.06 | 3.93 | 34.34 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.80 | 43.10 | 3.99 | 4.03 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.90 | 87.70 | 3.83 | 64.60 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 17.79 | 74.35 | 4.18 | 34.00 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 25.01 | 94.34 | 3.77 | 90.79 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 25.75 | 106.95 | 4.15 | 95.72 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.01 | 40.47 | 3.37 | 164.23 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.55 | 42.29 | 3.37 | 100.85 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.27 | 395.99 | 2.16 | 262.19 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.80 | 374.12 | 3.05 | 1916.33 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.32 | 1063.49 | 1.30 | 1322.13 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 230.05 | 751.65 | 3.27 | 2438.02 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.54 | 32.38 | 2.58 | 312.27 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.28 | 32.23 | 2.43 | 281.88 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.05 | 80.12 | 1.74 | 523.71 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.30 | 72.38 | 1.71 | 1276.97 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.76 | 200.28 | 1.41 | 743.59 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 60.60 | 136.73 | 2.26 | 1225.44 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.30 | 29.72 | 2.23 | 413.90 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.11 | 28.55 | 2.02 | 378.92 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 32.99 | 60.25 | 1.83 | 557.59 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.04 | 56.80 | 1.77 | 998.32 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.69 | 119.11 | 1.48 | 688.25 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 41.65 | 97.56 | 2.34 | 973.37 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.39 | 103.92 | 2.94 | 456.87 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.36 | 58.63 | 2.75 | 365.58 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.16 | 138.33 | 3.00 | 564.35 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 32.85 | 94.30 | 2.87 | 528.22 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.63 | 142.44 | 2.99 | 587.33 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 37.00 | 112.10 | 3.03 | 538.71 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.44 | 27.96 | 2.68 | 267.12 |
| http/html-16kx64 | 1048576 | 1 | stdx | 8.98 | 20.25 | 2.26 | 232.70 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.28 | 52.09 | 2.34 | 390.64 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.87 | 42.86 | 2.27 | 541.69 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 34.90 | 72.54 | 2.08 | 463.32 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.75 | 69.05 | 2.79 | 550.95 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.76 | 23.03 | 2.63 | 224.14 |
| http/html-1m | 1048576 | 1 | stdx | 8.12 | 17.79 | 2.19 | 205.27 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.27 | 49.53 | 1.96 | 326.47 |
| http/html-1m | 1048576 | 6 | stdx | 21.25 | 40.70 | 1.92 | 631.24 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.05 | 109.24 | 1.54 | 433.49 |
| http/html-1m | 1048576 | 9 | stdx | 29.89 | 73.42 | 2.46 | 614.25 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.78 | 94.80 | 2.98 | 302.57 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.42 | 45.16 | 2.75 | 242.35 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.03 | 126.60 | 2.94 | 373.89 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.05 | 78.36 | 2.90 | 381.15 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.05 | 142.45 | 2.74 | 431.55 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.64 | 95.54 | 3.12 | 385.44 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.85 | 23.85 | 3.04 | 134.41 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.46 | 13.94 | 2.55 | 110.48 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.15 | 46.61 | 2.57 | 204.55 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.36 | 35.01 | 2.62 | 282.06 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.28 | 151.99 | 1.89 | 298.97 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.11 | 58.29 | 3.05 | 302.76 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.72 | 19.85 | 2.95 | 123.99 |
| http/json-1m | 1048576 | 1 | stdx | 5.05 | 12.51 | 2.48 | 103.18 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.30 | 45.30 | 2.23 | 175.40 |
| http/json-1m | 1048576 | 6 | stdx | 14.68 | 35.08 | 2.39 | 298.88 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.67 | 205.21 | 1.69 | 280.07 |
| http/json-1m | 1048576 | 9 | stdx | 27.30 | 69.14 | 2.53 | 336.42 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.04 | 107.80 | 2.91 | 518.47 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.65 | 65.40 | 2.77 | 410.80 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.32 | 144.85 | 2.94 | 678.04 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 36.55 | 104.11 | 2.85 | 622.17 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.61 | 150.13 | 2.91 | 716.91 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 41.19 | 125.11 | 3.04 | 628.15 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.72 | 30.90 | 2.64 | 308.81 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.80 | 24.80 | 2.30 | 272.42 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.82 | 59.43 | 2.30 | 469.59 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.69 | 50.04 | 2.21 | 681.07 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.77 | 83.31 | 2.04 | 563.24 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.50 | 81.30 | 2.76 | 664.66 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.63 | 25.19 | 2.62 | 246.91 |
| http/js-1m | 1048576 | 1 | stdx | 9.52 | 21.31 | 2.24 | 233.02 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.69 | 56.12 | 1.96 | 368.48 |
| http/js-1m | 1048576 | 6 | stdx | 24.96 | 46.64 | 1.87 | 757.37 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.21 | 120.65 | 1.58 | 500.88 |
| http/js-1m | 1048576 | 9 | stdx | 34.97 | 84.80 | 2.42 | 709.86 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.20 | 97.73 | 2.94 | 378.13 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.29 | 49.52 | 2.71 | 300.35 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.83 | 129.22 | 2.95 | 480.70 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.11 | 82.31 | 2.83 | 507.32 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.74 | 133.80 | 2.92 | 509.13 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.13 | 99.46 | 3.00 | 524.05 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.62 | 25.60 | 2.97 | 172.99 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.67 | 16.96 | 2.54 | 134.25 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.18 | 48.80 | 2.42 | 288.34 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.42 | 38.00 | 2.31 | 469.99 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.78 | 82.40 | 2.02 | 371.12 |
| http/css-16kx64 | 1048576 | 9 | stdx | 22.95 | 65.13 | 2.84 | 479.61 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.93 | 21.15 | 3.05 | 132.22 |
| http/css-1m | 1048576 | 1 | stdx | 5.77 | 14.91 | 2.59 | 108.10 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.74 | 44.50 | 2.15 | 226.24 |
| http/css-1m | 1048576 | 6 | stdx | 16.55 | 35.61 | 2.15 | 443.54 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.65 | 111.58 | 1.60 | 309.35 |
| http/css-1m | 1048576 | 9 | stdx | 28.10 | 72.54 | 2.58 | 475.34 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.20 | 48.89 | 1.94 | 928.42 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.11 | 49.19 | 2.72 | 323.52 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.57 | 86.45 | 2.08 | 1182.67 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.59 | 88.79 | 2.24 | 856.29 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.12 | 94.50 | 2.01 | 1345.47 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 53.34 | 133.83 | 2.51 | 1123.98 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.13 | 31.13 | 3.07 | 122.97 |
| silesia/dickens | 10192446 | 1 | stdx | 24.14 | 82.03 | 3.40 | 125.09 |
| silesia/dickens | 10192446 | 3 | libzstd | 22.22 | 35.01 | 1.58 | 171.02 |
| silesia/dickens | 10192446 | 3 | stdx | 34.83 | 78.22 | 2.25 | 182.26 |
| silesia/mozilla | 51220480 | 1 | libzstd | 6.99 | 22.57 | 3.23 | 72.21 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.56 | 54.73 | 3.12 | 173.62 |
| silesia/mozilla | 51220480 | 3 | libzstd | 16.81 | 28.71 | 1.71 | 102.32 |
| silesia/mozilla | 51220480 | 3 | stdx | 29.84 | 62.01 | 2.08 | 144.59 |
| silesia/mr | 9970564 | 1 | libzstd | 7.66 | 24.73 | 3.23 | 57.06 |
| silesia/mr | 9970564 | 1 | stdx | 19.78 | 66.82 | 3.38 | 113.92 |
| silesia/mr | 9970564 | 3 | libzstd | 19.70 | 32.97 | 1.67 | 86.65 |
| silesia/mr | 9970564 | 3 | stdx | 32.84 | 72.46 | 2.21 | 114.37 |
| silesia/nci | 33553445 | 1 | libzstd | 3.54 | 9.49 | 2.68 | 58.64 |
| silesia/nci | 33553445 | 1 | stdx | 7.65 | 25.69 | 3.36 | 59.01 |
| silesia/nci | 33553445 | 3 | libzstd | 5.37 | 10.11 | 1.88 | 56.77 |
| silesia/nci | 33553445 | 3 | stdx | 11.18 | 29.15 | 2.61 | 66.31 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.55 | 29.17 | 3.41 | 73.20 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.09 | 72.51 | 3.14 | 180.49 |
| silesia/ooffice | 6152192 | 3 | libzstd | 23.59 | 40.82 | 1.73 | 121.47 |
| silesia/ooffice | 6152192 | 3 | stdx | 40.88 | 82.20 | 2.01 | 185.17 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.07 | 22.22 | 3.14 | 66.85 |
| silesia/osdb | 10085684 | 1 | stdx | 16.24 | 50.52 | 3.11 | 119.93 |
| silesia/osdb | 10085684 | 3 | libzstd | 17.67 | 27.06 | 1.53 | 69.95 |
| silesia/osdb | 10085684 | 3 | stdx | 30.91 | 57.87 | 1.87 | 110.38 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.80 | 27.02 | 2.76 | 155.79 |
| silesia/reymont | 6627202 | 1 | stdx | 20.04 | 72.05 | 3.59 | 96.85 |
| silesia/reymont | 6627202 | 3 | libzstd | 17.82 | 27.53 | 1.54 | 126.86 |
| silesia/reymont | 6627202 | 3 | stdx | 27.51 | 62.18 | 2.26 | 146.53 |
| silesia/samba | 21606400 | 1 | libzstd | 5.96 | 16.80 | 2.82 | 88.18 |
| silesia/samba | 21606400 | 1 | stdx | 13.44 | 42.89 | 3.19 | 124.98 |
| silesia/samba | 21606400 | 3 | libzstd | 11.73 | 19.20 | 1.64 | 99.76 |
| silesia/samba | 21606400 | 3 | stdx | 19.94 | 44.75 | 2.24 | 132.76 |
| silesia/sao | 7251944 | 1 | libzstd | 9.02 | 33.64 | 3.73 | 43.67 |
| silesia/sao | 7251944 | 1 | stdx | 25.92 | 82.03 | 3.16 | 104.41 |
| silesia/sao | 7251944 | 3 | libzstd | 31.45 | 52.14 | 1.66 | 95.70 |
| silesia/sao | 7251944 | 3 | stdx | 49.73 | 95.22 | 1.91 | 142.13 |
| silesia/webster | 41458703 | 1 | libzstd | 8.72 | 24.86 | 2.85 | 135.71 |
| silesia/webster | 41458703 | 1 | stdx | 20.23 | 64.04 | 3.17 | 165.59 |
| silesia/webster | 41458703 | 3 | libzstd | 18.75 | 27.84 | 1.48 | 177.96 |
| silesia/webster | 41458703 | 3 | stdx | 30.33 | 64.55 | 2.13 | 194.86 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.66 | 14.89 | 3.19 | 17.08 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.71 | 76.64 | 3.23 | 92.40 |
| silesia/x-ray | 8474240 | 3 | libzstd | 32.08 | 54.96 | 1.71 | 87.11 |
| silesia/x-ray | 8474240 | 3 | stdx | 46.15 | 92.40 | 2.00 | 105.79 |
| silesia/xml | 5345280 | 1 | libzstd | 4.26 | 11.65 | 2.74 | 72.90 |
| silesia/xml | 5345280 | 1 | stdx | 10.31 | 34.21 | 3.32 | 94.21 |
| silesia/xml | 5345280 | 3 | libzstd | 6.68 | 12.84 | 1.92 | 79.09 |
| silesia/xml | 5345280 | 3 | stdx | 12.61 | 32.28 | 2.56 | 115.28 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.88 | 32.86 | 3.02 | 145.97 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.27 | 76.49 | 3.43 | 184.14 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.40 | 39.93 | 2.59 | 204.08 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.29 | 73.76 | 2.81 | 335.59 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.78 | 33.59 | 3.43 | 109.60 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.49 | 79.00 | 3.36 | 215.42 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.90 | 40.28 | 2.53 | 207.91 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 27.94 | 79.30 | 2.84 | 371.63 |
| canterbury/cp.html | 24603 | 1 | libzstd | 7.01 | 26.65 | 3.80 | 39.82 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.06 | 57.76 | 3.60 | 118.22 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.23 | 32.88 | 3.56 | 15.32 |
| canterbury/cp.html | 24603 | 3 | stdx | 17.99 | 59.76 | 3.32 | 136.00 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.76 | 31.77 | 3.63 | 38.42 |
| canterbury/fields.c | 11150 | 1 | stdx | 16.95 | 65.73 | 3.88 | 83.99 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.04 | 34.41 | 3.81 | 10.09 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.25 | 64.68 | 3.75 | 89.77 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.57 | 37.98 | 3.97 | 10.98 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.24 | 77.57 | 3.83 | 53.03 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.65 | 43.28 | 4.06 | 4.43 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.45 | 79.60 | 3.71 | 70.25 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.01 | 23.37 | 3.89 | 14.83 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.61 | 56.75 | 3.88 | 83.85 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.47 | 24.26 | 2.87 | 27.40 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 20.12 | 56.61 | 2.81 | 108.40 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.88 | 28.42 | 2.88 | 160.66 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.29 | 72.02 | 3.38 | 159.22 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 16.42 | 32.77 | 2.00 | 201.13 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.22 | 67.10 | 2.56 | 297.04 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.35 | 32.28 | 3.12 | 131.14 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.00 | 84.16 | 3.37 | 158.65 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 20.54 | 39.60 | 1.93 | 226.35 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 31.46 | 80.77 | 2.57 | 342.48 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.15 | 8.48 | 2.69 | 67.71 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.48 | 23.15 | 3.10 | 104.29 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 4.97 | 11.28 | 2.27 | 60.21 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.38 | 24.08 | 2.57 | 131.98 |
| canterbury/sum | 38240 | 1 | libzstd | 6.50 | 25.37 | 3.90 | 30.26 |
| canterbury/sum | 38240 | 1 | stdx | 16.83 | 59.13 | 3.51 | 148.68 |
| canterbury/sum | 38240 | 3 | libzstd | 8.93 | 31.64 | 3.54 | 29.73 |
| canterbury/sum | 38240 | 3 | stdx | 19.51 | 61.82 | 3.17 | 180.99 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 10.04 | 39.84 | 3.97 | 12.43 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.85 | 80.38 | 3.86 | 58.54 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.07 | 48.45 | 4.01 | 2.40 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.84 | 83.98 | 3.68 | 77.33 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.49 | 33.29 | 3.17 | 75.87 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.78 | 95.62 | 4.39 | 7.21 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 14.90 | 31.71 | 2.13 | 36.04 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.59 | 70.38 | 2.98 | 38.51 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.81 | 27.35 | 2.79 | 154.40 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.28 | 71.86 | 3.54 | 107.29 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 17.68 | 28.64 | 1.62 | 133.30 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 27.60 | 63.36 | 2.30 | 155.60 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.17 | 22.62 | 2.77 | 139.92 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.56 | 55.86 | 3.01 | 192.18 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 15.36 | 24.36 | 1.59 | 174.47 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 24.50 | 51.26 | 2.09 | 236.85 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.10 | 52.52 | 3.07 | 168.70 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.81 | 100.54 | 2.81 | 634.84 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.22 | 59.34 | 3.09 | 206.73 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 37.91 | 104.00 | 2.74 | 629.11 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.85 | 22.47 | 2.86 | 128.15 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.11 | 46.84 | 3.32 | 181.68 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.91 | 24.79 | 2.78 | 146.43 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.25 | 47.61 | 3.12 | 191.28 |
| http/html-1m | 1048576 | 1 | libzstd | 6.34 | 16.66 | 2.63 | 117.78 |
| http/html-1m | 1048576 | 1 | stdx | 12.89 | 42.00 | 3.26 | 134.38 |
| http/html-1m | 1048576 | 3 | libzstd | 9.38 | 18.50 | 1.97 | 125.96 |
| http/html-1m | 1048576 | 3 | stdx | 15.65 | 39.37 | 2.52 | 177.65 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.34 | 42.58 | 2.97 | 119.62 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.52 | 83.13 | 2.82 | 524.20 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.91 | 44.69 | 3.00 | 135.64 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.63 | 84.87 | 2.77 | 531.26 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.82 | 15.00 | 3.11 | 59.18 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.68 | 33.78 | 3.49 | 116.59 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.42 | 16.31 | 3.01 | 73.22 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.51 | 34.58 | 3.29 | 122.35 |
| http/json-1m | 1048576 | 1 | libzstd | 4.06 | 12.47 | 3.07 | 53.55 |
| http/json-1m | 1048576 | 1 | stdx | 8.98 | 30.70 | 3.42 | 84.92 |
| http/json-1m | 1048576 | 3 | libzstd | 6.30 | 14.06 | 2.23 | 68.46 |
| http/json-1m | 1048576 | 3 | stdx | 11.22 | 30.64 | 2.73 | 119.50 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.62 | 57.29 | 3.08 | 196.48 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 40.02 | 113.49 | 2.84 | 692.88 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.53 | 65.62 | 3.05 | 268.03 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.00 | 116.54 | 2.77 | 680.32 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.98 | 26.53 | 2.95 | 132.50 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.62 | 55.71 | 3.35 | 200.22 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.20 | 28.96 | 2.84 | 157.92 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.66 | 55.35 | 3.14 | 209.34 |
| http/js-1m | 1048576 | 1 | libzstd | 6.64 | 17.80 | 2.68 | 116.81 |
| http/js-1m | 1048576 | 1 | stdx | 13.91 | 45.88 | 3.30 | 135.75 |
| http/js-1m | 1048576 | 3 | libzstd | 10.11 | 19.49 | 1.93 | 125.01 |
| http/js-1m | 1048576 | 3 | stdx | 16.67 | 41.25 | 2.47 | 187.13 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.63 | 46.97 | 3.01 | 143.31 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.41 | 91.65 | 2.83 | 580.10 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.75 | 50.68 | 3.03 | 166.14 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.67 | 93.63 | 2.78 | 580.51 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.23 | 18.99 | 3.05 | 80.52 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.43 | 43.79 | 3.52 | 137.57 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.60 | 19.53 | 2.96 | 94.72 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.90 | 42.34 | 3.28 | 152.75 |
| http/css-1m | 1048576 | 1 | libzstd | 1.51 | 4.57 | 3.03 | 21.94 |
| http/css-1m | 1048576 | 1 | stdx | 3.98 | 14.85 | 3.73 | 30.70 |
| http/css-1m | 1048576 | 3 | libzstd | 1.98 | 5.34 | 2.69 | 19.57 |
| http/css-1m | 1048576 | 3 | stdx | 3.91 | 13.33 | 3.41 | 31.46 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.53 | 12.79 | 3.62 | 6.40 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.05 | 30.66 | 3.39 | 61.92 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 28.67 | 53.05 | 1.85 | 47.98 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 20.59 | 47.43 | 2.30 | 207.21 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.119 | 3.00 | 2.93 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 75.3 | 239.0 | 0.087 | 8.89 | 3.17 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 44.1 | 194.4 | 0.075 | 5.22 | 4.40 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 284.6 | 1193.5 | 0.822 | 33.62 | 4.19 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.4 | 107.5 | 0.145 | 3.59 | 3.53 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.8 | 106.0 | 0.293 | 3.29 | 3.81 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 94.4 | 378.2 | 0.381 | 11.15 | 4.01 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.4 | 161.9 | 0.447 | 5.01 | 3.81 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 91.5 | 451.6 | 0.303 | 10.81 | 4.94 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 26.9 | 89.5 | 0.004 | 3.96 | 3.33 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 74.5 | 250.2 | 0.040 | 10.96 | 3.36 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 47.9 | 205.1 | 0.053 | 7.05 | 4.28 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 239.0 | 927.9 | 0.965 | 35.18 | 3.88 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 27.9 | 107.7 | 0.041 | 4.11 | 3.86 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 27.9 | 105.7 | 0.047 | 4.11 | 3.78 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 93.9 | 346.2 | 0.317 | 13.81 | 3.69 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 32.3 | 144.5 | 0.053 | 4.75 | 4.48 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 90.9 | 406.5 | 0.099 | 13.39 | 4.47 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114133.6 | 403845.2 | 475.031 | 0.66 | 3.54 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 644879.4 | 2749355.2 | 1416.010 | 3.74 | 4.26 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 645267.3 | 2749752.2 | 1399.969 | 3.74 | 4.26 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 4542546.3 | 22490188.2 | 2976.536 | 26.33 | 4.95 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311865.6 | 621743.2 | 637.979 | 1.81 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 225506.3 | 826618.2 | 2203.660 | 1.31 | 3.67 |
| string: silesia/dickens | 1 | 172528 | std.json | 1656233.7 | 4578768.2 | 43470.711 | 9.60 | 2.76 |
| string: silesia/dickens | 1 | 172528 | serde_json | 200931.5 | 802391.2 | 1001.093 | 1.16 | 3.99 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1050814.4 | 5284240.8 | 4976.979 | 6.09 | 5.03 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1565551.4 | 4799762.6 | 1266.071 | 1.32 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 15317774.4 | 62777133.6 | 38940.571 | 12.87 | 4.10 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 15302877.8 | 62777455.6 | 38805.286 | 12.86 | 4.10 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 35794207.6 | 160729111.6 | 158847.143 | 30.07 | 4.49 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4577140.4 | 7053838.6 | 580.857 | 3.85 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1790631.3 | 7322017.6 | 13907.929 | 1.50 | 4.09 |
| string: http/json-1m | 1 | 1190272 | std.json | 10857614.5 | 47381213.6 | 30266.214 | 9.12 | 4.36 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3787334.9 | 15226459.6 | 6050.500 | 3.18 | 4.02 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 8940911.4 | 48023898.3 | 28147.500 | 7.51 | 5.37 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2064307.5 | 5765412.8 | 4479.500 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6584285.9 | 24513270.8 | 6983.875 | 3.50 | 3.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 6555708.9 | 24513592.8 | 6975.375 | 3.48 | 3.74 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 59602086.3 | 273034491.8 | 262482.125 | 31.65 | 4.58 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3683790.5 | 7945848.8 | 2155.250 | 1.96 | 2.16 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7195849.0 | 12276727.8 | 276344.000 | 3.82 | 1.71 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 18606408.6 | 63617055.8 | 219718.500 | 9.88 | 3.42 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9492019.8 | 24440755.8 | 290522.250 | 5.04 | 2.57 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39191545.4 | 160313214.5 | 796212.625 | 20.81 | 4.09 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12917829.3 | 42561068.3 | 244884.000 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 192186621.7 | 782100838.3 | 390401.000 | 37.87 | 4.07 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 183327443.0 | 782101160.3 | 393516.667 | 36.12 | 4.27 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 185387922.7 | 760206171.3 | 424289.333 | 36.53 | 4.10 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17541817.7 | 49745819.3 | 214659.667 | 3.46 | 2.84 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14165111.0 | 44816977.3 | 441594.000 | 2.79 | 3.16 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79887471.7 | 314900845.3 | 483600.667 | 15.74 | 3.94 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 35865243.7 | 131556135.3 | 566642.667 | 7.07 | 3.67 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66428048.0 | 273934818.3 | 841043.000 | 13.09 | 4.12 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 92449.3 | 303836.7 | 6.806 | 0.18 | 3.29 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 184088.6 | 623498.7 | 15.065 | 0.35 | 3.39 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 183528.5 | 623231.7 | 9.097 | 0.35 | 3.40 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 13270267.7 | 66585428.7 | 9.129 | 25.31 | 5.02 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 490992.1 | 1376732.7 | 7.290 | 0.94 | 2.80 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 535140.3 | 2195905.7 | 6.806 | 1.02 | 4.10 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3496190.1 | 12808414.7 | 61401.258 | 6.67 | 3.66 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 282960.4 | 1179969.7 | 7.903 | 0.54 | 4.17 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2248830.5 | 12790033.4 | 246.065 | 4.29 | 5.69 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.7 | 81.5 | 0.109 | 2.32 | 4.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.1 | 153.6 | 0.128 | 4.14 | 4.38 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 33.3 | 151.5 | 0.094 | 3.94 | 4.55 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 256.9 | 1182.8 | 0.902 | 30.34 | 4.60 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 18.7 | 79.5 | 0.104 | 2.21 | 4.24 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 22.9 | 94.1 | 0.134 | 2.71 | 4.11 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.4 | 105.4 | 0.242 | 3.24 | 3.84 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.2 | 310.8 | 0.372 | 8.18 | 4.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.3 | 255.3 | 0.484 | 7.48 | 4.03 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 67.5 | 315.1 | 0.236 | 7.98 | 4.67 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 19.0 | 82.5 | 0.024 | 2.79 | 4.35 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.0 | 153.9 | 0.026 | 5.30 | 4.28 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 32.7 | 142.5 | 0.026 | 4.81 | 4.36 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 196.6 | 848.0 | 1.224 | 28.93 | 4.31 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.0 | 81.5 | 0.024 | 2.65 | 4.52 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.3 | 96.6 | 0.032 | 3.13 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.0 | 117.7 | 0.032 | 4.28 | 4.05 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.4 | 271.2 | 0.269 | 8.75 | 4.56 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 48.0 | 211.7 | 0.042 | 7.07 | 4.41 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 81.2 | 331.7 | 0.078 | 11.96 | 4.08 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 85335.3 | 280780.2 | 740.206 | 0.49 | 3.29 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84836.1 | 280730.2 | 724.237 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84807.8 | 280758.2 | 721.938 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 4096129.8 | 20167466.2 | 2951.062 | 23.74 | 4.92 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 83192.1 | 274401.2 | 661.990 | 0.48 | 3.30 |
| string: silesia/dickens | 1 | 172528 | simdjson | 208333.7 | 674008.2 | 2078.670 | 1.21 | 3.24 |
| string: silesia/dickens | 1 | 172528 | yyjson | 210690.5 | 848559.2 | 1337.660 | 1.22 | 4.03 |
| string: silesia/dickens | 1 | 172528 | std.json | 1353623.0 | 2890892.2 | 51283.278 | 7.85 | 2.14 |
| string: silesia/dickens | 1 | 172528 | serde_json | 371339.5 | 1586249.2 | 2272.052 | 2.15 | 4.27 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 578140.1 | 2970293.2 | 2339.237 | 3.35 | 5.14 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1280686.1 | 3582346.6 | 11959.429 | 1.08 | 2.80 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1267866.1 | 3582290.6 | 11462.286 | 1.07 | 2.83 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1266340.4 | 3582318.6 | 11493.500 | 1.06 | 2.83 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 29980894.6 | 134936069.6 | 138851.286 | 25.19 | 4.50 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1223950.4 | 3370022.6 | 10999.071 | 1.03 | 2.75 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2978220.2 | 10460754.6 | 29639.571 | 2.50 | 3.51 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2414146.1 | 11226214.6 | 9692.929 | 2.03 | 4.65 |
| string: http/json-1m | 1 | 1190272 | std.json | 8992326.2 | 43287986.6 | 16039.500 | 7.55 | 4.81 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4211434.1 | 17941088.6 | 10895.071 | 3.54 | 4.26 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5241236.5 | 26999710.4 | 11026.357 | 4.40 | 5.15 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2072339.5 | 6088095.8 | 4748.750 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2064712.3 | 6088039.8 | 4298.500 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2062337.4 | 6088067.8 | 4123.375 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 52550803.1 | 238556376.8 | 262974.750 | 27.91 | 4.54 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2072008.6 | 5875346.8 | 4770.375 | 1.10 | 2.84 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2714800.8 | 7144135.8 | 20878.125 | 1.44 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 11848618.1 | 26334410.8 | 429731.625 | 6.29 | 2.22 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20423636.0 | 56837736.8 | 528021.500 | 10.85 | 2.78 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11555275.1 | 33662338.8 | 309191.250 | 6.14 | 2.91 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18871336.1 | 76319450.4 | 254328.375 | 10.02 | 4.04 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113137.8 | 426373.7 | 2.935 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113416.8 | 426318.7 | 2.935 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113378.2 | 426335.7 | 5.065 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 635652.6 | 3146562.7 | 5.258 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113186.1 | 426343.7 | 1.581 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1239650.9 | 3866907.7 | 4.710 | 2.36 | 3.12 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1664706.6 | 5833344.7 | 6.097 | 3.18 | 3.50 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3605047.4 | 13108830.7 | 68315.903 | 6.88 | 3.64 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1820588.6 | 7405810.7 | 3.516 | 3.47 | 4.07 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2388463.5 | 12748343.7 | 13.903 | 4.56 | 5.34 |
