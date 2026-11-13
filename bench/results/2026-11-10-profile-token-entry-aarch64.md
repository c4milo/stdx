# bench-profile

| Field | Value |
|---|---|
| Commit | b8bcaa4 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261101.172.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/42850767353 |
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
| silesia/dickens | 10192446 | zlib | 7.98 | 15.77 | 1.98 | 301.21 |
| silesia/dickens | 10192446 | zlib-ng | 4.89 | 10.50 | 2.15 | 67.65 |
| silesia/dickens | 10192446 | libdeflate | 3.48 | 9.56 | 2.75 | 66.01 |
| silesia/dickens | 10192446 | Wuffs | 4.90 | 10.85 | 2.21 | 97.35 |
| silesia/dickens | 10192446 | stdx | 2.97 | 7.15 | 2.40 | 76.27 |
| silesia/mozilla | 51220480 | zlib | 7.78 | 14.13 | 1.82 | 243.30 |
| silesia/mozilla | 51220480 | zlib-ng | 4.95 | 8.95 | 1.81 | 85.52 |
| silesia/mozilla | 51220480 | libdeflate | 3.48 | 7.63 | 2.20 | 71.09 |
| silesia/mozilla | 51220480 | Wuffs | 5.73 | 10.84 | 1.89 | 133.04 |
| silesia/mozilla | 51220480 | stdx | 3.64 | 6.29 | 1.73 | 88.99 |
| silesia/mr | 9970564 | zlib | 7.72 | 15.26 | 1.98 | 198.98 |
| silesia/mr | 9970564 | zlib-ng | 4.82 | 9.98 | 2.07 | 67.73 |
| silesia/mr | 9970564 | libdeflate | 3.36 | 8.58 | 2.55 | 61.15 |
| silesia/mr | 9970564 | Wuffs | 5.31 | 10.93 | 2.06 | 101.05 |
| silesia/mr | 9970564 | stdx | 3.14 | 6.70 | 2.13 | 69.49 |
| silesia/nci | 33553445 | zlib | 2.95 | 7.25 | 2.46 | 80.27 |
| silesia/nci | 33553445 | zlib-ng | 1.64 | 3.13 | 1.91 | 33.54 |
| silesia/nci | 33553445 | libdeflate | 1.18 | 2.66 | 2.26 | 27.62 |
| silesia/nci | 33553445 | Wuffs | 1.75 | 3.38 | 1.93 | 42.49 |
| silesia/nci | 33553445 | stdx | 1.31 | 2.20 | 1.68 | 37.13 |
| silesia/ooffice | 6152192 | zlib | 11.05 | 17.83 | 1.61 | 402.01 |
| silesia/ooffice | 6152192 | zlib-ng | 6.93 | 12.04 | 1.74 | 140.06 |
| silesia/ooffice | 6152192 | libdeflate | 4.91 | 10.45 | 2.13 | 125.36 |
| silesia/ooffice | 6152192 | Wuffs | 8.15 | 14.47 | 1.78 | 222.03 |
| silesia/ooffice | 6152192 | stdx | 5.12 | 8.55 | 1.67 | 150.41 |
| silesia/osdb | 10085684 | zlib | 6.83 | 13.54 | 1.98 | 172.29 |
| silesia/osdb | 10085684 | zlib-ng | 4.32 | 8.38 | 1.94 | 53.10 |
| silesia/osdb | 10085684 | libdeflate | 2.85 | 6.91 | 2.42 | 29.74 |
| silesia/osdb | 10085684 | Wuffs | 5.20 | 10.56 | 2.03 | 83.12 |
| silesia/osdb | 10085684 | stdx | 2.82 | 5.65 | 2.00 | 41.43 |
| silesia/reymont | 6627202 | zlib | 6.65 | 12.73 | 1.92 | 254.28 |
| silesia/reymont | 6627202 | zlib-ng | 3.72 | 7.72 | 2.07 | 59.90 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.18 |
| silesia/reymont | 6627202 | Wuffs | 4.25 | 8.40 | 1.98 | 112.43 |
| silesia/reymont | 6627202 | stdx | 2.29 | 5.11 | 2.23 | 64.15 |
| silesia/samba | 21606400 | zlib | 5.50 | 11.09 | 2.02 | 170.66 |
| silesia/samba | 21606400 | zlib-ng | 3.38 | 6.47 | 1.92 | 55.89 |
| silesia/samba | 21606400 | libdeflate | 2.35 | 5.58 | 2.38 | 42.98 |
| silesia/samba | 21606400 | Wuffs | 3.68 | 7.33 | 1.99 | 81.22 |
| silesia/samba | 21606400 | stdx | 2.32 | 4.46 | 1.92 | 56.13 |
| silesia/sao | 7251944 | zlib | 9.92 | 20.36 | 2.05 | 196.50 |
| silesia/sao | 7251944 | zlib-ng | 7.87 | 14.83 | 1.88 | 79.36 |
| silesia/sao | 7251944 | libdeflate | 5.83 | 12.73 | 2.18 | 78.90 |
| silesia/sao | 7251944 | Wuffs | 8.21 | 18.14 | 2.21 | 85.62 |
| silesia/sao | 7251944 | stdx | 5.81 | 10.32 | 1.78 | 87.58 |
| silesia/webster | 41458703 | zlib | 7.01 | 12.99 | 1.85 | 273.54 |
| silesia/webster | 41458703 | zlib-ng | 4.23 | 8.04 | 1.90 | 84.99 |
| silesia/webster | 41458703 | libdeflate | 2.93 | 7.17 | 2.44 | 68.39 |
| silesia/webster | 41458703 | Wuffs | 4.51 | 8.62 | 1.91 | 123.21 |
| silesia/webster | 41458703 | stdx | 2.84 | 5.56 | 1.96 | 86.92 |
| silesia/x-ray | 8474240 | zlib | 12.30 | 23.82 | 1.94 | 324.50 |
| silesia/x-ray | 8474240 | zlib-ng | 9.06 | 17.39 | 1.92 | 124.38 |
| silesia/x-ray | 8474240 | libdeflate | 6.54 | 15.26 | 2.33 | 124.40 |
| silesia/x-ray | 8474240 | Wuffs | 10.14 | 20.40 | 2.01 | 192.30 |
| silesia/x-ray | 8474240 | stdx | 6.20 | 11.49 | 1.85 | 137.39 |
| silesia/xml | 5345280 | zlib | 3.62 | 8.20 | 2.26 | 116.24 |
| silesia/xml | 5345280 | zlib-ng | 1.99 | 3.88 | 1.96 | 42.68 |
| silesia/xml | 5345280 | libdeflate | 1.35 | 3.33 | 2.46 | 31.50 |
| silesia/xml | 5345280 | Wuffs | 2.19 | 4.14 | 1.89 | 60.93 |
| silesia/xml | 5345280 | stdx | 1.32 | 2.65 | 2.01 | 41.63 |
| canterbury/alice29.txt | 152089 | zlib | 7.59 | 15.08 | 1.99 | 285.59 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.51 | 9.91 | 2.20 | 59.79 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.20 | 8.96 | 2.80 | 56.60 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.69 | 10.37 | 2.21 | 97.94 |
| canterbury/alice29.txt | 152089 | stdx | 2.72 | 6.99 | 2.57 | 63.31 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.14 | 16.11 | 1.98 | 303.53 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 72.53 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.59 | 9.82 | 2.73 | 67.36 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.08 | 11.34 | 2.23 | 99.90 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.09 | 7.52 | 2.43 | 80.49 |
| canterbury/cp.html | 24603 | zlib | 6.57 | 14.20 | 2.16 | 175.45 |
| canterbury/cp.html | 24603 | zlib-ng | 4.19 | 9.50 | 2.27 | 37.26 |
| canterbury/cp.html | 24603 | libdeflate | 2.85 | 7.95 | 2.79 | 14.68 |
| canterbury/cp.html | 24603 | Wuffs | 4.53 | 10.87 | 2.40 | 60.46 |
| canterbury/cp.html | 24603 | stdx | 2.68 | 7.19 | 2.68 | 14.43 |
| canterbury/fields.c | 11150 | zlib | 4.60 | 14.65 | 3.18 | 36.21 |
| canterbury/fields.c | 11150 | zlib-ng | 3.88 | 10.20 | 2.63 | 14.44 |
| canterbury/fields.c | 11150 | libdeflate | 2.81 | 8.32 | 2.96 | 1.45 |
| canterbury/fields.c | 11150 | Wuffs | 3.84 | 11.51 | 3.00 | 10.24 |
| canterbury/fields.c | 11150 | stdx | 2.50 | 7.64 | 3.06 | 4.10 |
| canterbury/grammar.lsp | 3721 | zlib | 6.24 | 21.22 | 3.40 | 3.80 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.84 | 17.48 | 2.99 | 8.32 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.47 | 12.05 | 2.69 | 0.10 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.96 | 18.87 | 3.17 | 3.76 |
| canterbury/grammar.lsp | 3721 | stdx | 3.84 | 12.18 | 3.17 | 1.10 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.96 | 12.20 | 3.08 | 49.04 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.60 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.23 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.20 | 8.67 | 2.71 | 14.74 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.74 | 4.66 | 2.68 | 16.70 |
| canterbury/lcet10.txt | 426754 | zlib | 7.38 | 14.53 | 1.97 | 280.41 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.17 | 60.97 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.25 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.56 | 9.85 | 2.16 | 100.95 |
| canterbury/lcet10.txt | 426754 | stdx | 2.59 | 6.42 | 2.48 | 66.21 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.31 | 16.53 | 1.99 | 310.62 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.28 | 11.19 | 2.12 | 76.91 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.76 | 10.19 | 2.71 | 76.26 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.15 | 11.53 | 2.24 | 99.57 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.18 | 7.63 | 2.40 | 85.91 |
| canterbury/ptt5 | 513216 | zlib | 4.40 | 7.79 | 1.77 | 100.30 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.89 | 46.35 |
| canterbury/ptt5 | 513216 | libdeflate | 1.44 | 3.02 | 2.09 | 37.87 |
| canterbury/ptt5 | 513216 | Wuffs | 2.19 | 4.02 | 1.84 | 58.63 |
| canterbury/ptt5 | 513216 | stdx | 1.44 | 2.55 | 1.77 | 49.08 |
| canterbury/sum | 38240 | zlib | 7.31 | 14.98 | 2.05 | 217.70 |
| canterbury/sum | 38240 | zlib-ng | 4.64 | 10.02 | 2.16 | 56.81 |
| canterbury/sum | 38240 | libdeflate | 3.40 | 8.34 | 2.45 | 44.47 |
| canterbury/sum | 38240 | Wuffs | 5.01 | 11.41 | 2.28 | 76.39 |
| canterbury/sum | 38240 | stdx | 3.03 | 7.73 | 2.56 | 28.87 |
| canterbury/xargs.1 | 4227 | zlib | 6.67 | 22.08 | 3.31 | 6.66 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.38 | 17.97 | 2.82 | 9.23 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.84 | 13.27 | 2.74 | 1.10 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.47 | 19.63 | 3.03 | 8.50 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 12.86 | 3.04 | 1.91 |
| canterbury-large/E.coli | 4638690 | zlib | 5.94 | 14.55 | 2.45 | 174.54 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.24 | 9.68 | 2.29 | 47.41 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.51 |
| canterbury-large/E.coli | 4638690 | Wuffs | 3.99 | 9.64 | 2.41 | 61.58 |
| canterbury-large/E.coli | 4638690 | stdx | 2.46 | 6.72 | 2.73 | 53.54 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.75 | 13.26 | 1.97 | 260.21 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.78 | 8.26 | 2.18 | 53.91 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.46 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.15 | 8.72 | 2.10 | 100.68 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.23 | 5.57 | 2.50 | 55.87 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.96 | 12.69 | 1.82 | 272.54 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.19 | 7.78 | 1.86 | 91.12 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.41 | 75.07 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.51 | 8.44 | 1.87 | 129.39 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 5.40 | 1.99 | 90.53 |
| http/html-1kx1024 | 1048576 | zlib | 15.94 | 32.44 | 2.04 | 350.39 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.72 | 28.43 | 2.23 | 218.97 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.91 | 20.05 | 1.84 | 155.79 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.65 | 35.05 | 2.39 | 264.45 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 137.46 |
| http/html-16kx64 | 1048576 | zlib | 6.02 | 11.79 | 1.96 | 214.61 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.26 |
| http/html-16kx64 | 1048576 | libdeflate | 2.65 | 6.04 | 2.28 | 60.62 |
| http/html-16kx64 | 1048576 | Wuffs | 4.26 | 8.51 | 2.00 | 116.62 |
| http/html-16kx64 | 1048576 | stdx | 2.50 | 5.56 | 2.22 | 58.48 |
| http/html-1m | 1048576 | zlib | 4.65 | 9.51 | 2.05 | 172.68 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 60.05 |
| http/html-1m | 1048576 | libdeflate | 1.69 | 4.39 | 2.59 | 37.40 |
| http/html-1m | 1048576 | Wuffs | 2.96 | 5.42 | 1.83 | 90.19 |
| http/html-1m | 1048576 | stdx | 1.63 | 3.46 | 2.12 | 52.40 |
| http/json-1kx1024 | 1048576 | zlib | 9.71 | 20.83 | 2.14 | 192.14 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.41 | 16.69 | 2.25 | 130.75 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.11 | 16.72 | 1.83 | 92.24 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.43 | 31.72 | 2.78 | 145.59 |
| http/json-1kx1024 | 1048576 | stdx | 5.03 | 13.12 | 2.61 | 81.20 |
| http/json-16kx64 | 1048576 | zlib | 3.94 | 9.62 | 2.44 | 101.65 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.75 |
| http/json-16kx64 | 1048576 | libdeflate | 1.92 | 4.24 | 2.20 | 39.60 |
| http/json-16kx64 | 1048576 | Wuffs | 2.81 | 6.35 | 2.26 | 58.11 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.26 | 39.68 |
| http/json-1m | 1048576 | zlib | 3.25 | 8.25 | 2.54 | 82.13 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.02 | 37.32 |
| http/json-1m | 1048576 | libdeflate | 1.37 | 3.33 | 2.42 | 32.17 |
| http/json-1m | 1048576 | Wuffs | 2.04 | 4.29 | 2.11 | 44.22 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.02 | 40.10 |
| http/js-1kx1024 | 1048576 | zlib | 17.32 | 35.33 | 2.04 | 401.90 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.76 | 31.25 | 2.27 | 238.78 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.54 | 21.58 | 1.87 | 179.46 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.74 | 37.71 | 2.40 | 295.84 |
| http/js-1kx1024 | 1048576 | stdx | 9.28 | 22.85 | 2.46 | 159.50 |
| http/js-16kx64 | 1048576 | zlib | 6.92 | 13.06 | 1.89 | 255.84 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.98 | 91.71 |
| http/js-16kx64 | 1048576 | libdeflate | 3.07 | 7.01 | 2.28 | 72.02 |
| http/js-16kx64 | 1048576 | Wuffs | 4.84 | 9.70 | 2.01 | 130.28 |
| http/js-16kx64 | 1048576 | stdx | 3.01 | 6.54 | 2.17 | 72.30 |
| http/js-1m | 1048576 | zlib | 5.15 | 10.26 | 1.99 | 195.70 |
| http/js-1m | 1048576 | zlib-ng | 2.87 | 5.66 | 1.97 | 59.92 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.94 |
| http/js-1m | 1048576 | Wuffs | 3.26 | 6.10 | 1.87 | 96.00 |
| http/js-1m | 1048576 | stdx | 1.80 | 3.89 | 2.16 | 55.36 |
| http/css-1kx1024 | 1048576 | zlib | 13.17 | 27.18 | 2.06 | 281.39 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.28 | 23.04 | 2.24 | 173.12 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.43 | 17.37 | 1.84 | 121.11 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.04 | 29.48 | 2.45 | 209.18 |
| http/css-1kx1024 | 1048576 | stdx | 6.68 | 17.64 | 2.64 | 100.83 |
| http/css-16kx64 | 1048576 | zlib | 4.67 | 10.12 | 2.17 | 151.41 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.19 | 49.91 |
| http/css-16kx64 | 1048576 | libdeflate | 1.88 | 4.69 | 2.49 | 28.25 |
| http/css-16kx64 | 1048576 | Wuffs | 3.12 | 6.97 | 2.24 | 70.25 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.54 | 28.31 |
| http/css-1m | 1048576 | zlib | 3.38 | 8.00 | 2.37 | 107.61 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.22 | 28.66 |
| http/css-1m | 1048576 | libdeflate | 1.05 | 3.18 | 3.04 | 10.58 |
| http/css-1m | 1048576 | Wuffs | 1.91 | 4.08 | 2.14 | 44.73 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.52 | 21.54 |
| shuffled/dickens-1m | 1048576 | zlib | 12.73 | 22.42 | 1.76 | 371.85 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.79 | 16.72 | 1.71 | 197.26 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.05 | 14.95 | 2.12 | 192.36 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.79 | 18.95 | 1.94 | 206.76 |
| shuffled/dickens-1m | 1048576 | stdx | 7.25 | 11.89 | 1.64 | 206.29 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.77 | 14.04 | 3.72 | 3.54 |
| silesia/dickens | 10192446 | stdx | 4.04 | 12.47 | 3.09 | 3.58 |
| silesia/mozilla | 51220480 | libzstd | 2.83 | 9.62 | 3.39 | 30.07 |
| silesia/mozilla | 51220480 | stdx | 2.85 | 9.68 | 3.40 | 15.64 |
| silesia/mr | 9970564 | libzstd | 3.02 | 11.98 | 3.96 | 6.24 |
| silesia/mr | 9970564 | stdx | 3.06 | 10.83 | 3.54 | 5.30 |
| silesia/nci | 33553445 | libzstd | 1.60 | 4.84 | 3.02 | 23.53 |
| silesia/nci | 33553445 | stdx | 1.72 | 4.63 | 2.70 | 13.52 |
| silesia/ooffice | 6152192 | libzstd | 3.41 | 12.14 | 3.56 | 31.14 |
| silesia/ooffice | 6152192 | stdx | 3.33 | 12.40 | 3.73 | 12.14 |
| silesia/osdb | 10085684 | libzstd | 2.36 | 8.44 | 3.57 | 15.48 |
| silesia/osdb | 10085684 | stdx | 2.43 | 8.11 | 3.33 | 15.19 |
| silesia/reymont | 6627202 | libzstd | 3.09 | 11.61 | 3.75 | 11.63 |
| silesia/reymont | 6627202 | stdx | 3.25 | 10.36 | 3.19 | 12.80 |
| silesia/samba | 21606400 | libzstd | 2.04 | 7.39 | 3.62 | 18.65 |
| silesia/samba | 21606400 | stdx | 2.10 | 6.83 | 3.25 | 17.52 |
| silesia/sao | 7251944 | libzstd | 3.84 | 12.69 | 3.31 | 26.63 |
| silesia/sao | 7251944 | stdx | 3.52 | 12.58 | 3.58 | 6.27 |
| silesia/webster | 41458703 | libzstd | 3.15 | 11.22 | 3.56 | 16.25 |
| silesia/webster | 41458703 | stdx | 3.29 | 10.05 | 3.05 | 16.97 |
| silesia/x-ray | 8474240 | libzstd | 3.97 | 14.93 | 3.76 | 18.80 |
| silesia/x-ray | 8474240 | stdx | 3.55 | 13.23 | 3.73 | 8.52 |
| silesia/xml | 5345280 | libzstd | 1.53 | 5.55 | 3.64 | 22.79 |
| silesia/xml | 5345280 | stdx | 1.51 | 5.16 | 3.42 | 17.10 |
| canterbury/alice29.txt | 152089 | libzstd | 3.36 | 16.18 | 4.82 | 4.17 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.44 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.01 | 14.25 | 4.74 | 3.32 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.30 | 0.19 |
| canterbury/cp.html | 24603 | libzstd | 2.67 | 10.74 | 4.01 | 9.18 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.11 | 0.20 |
| canterbury/fields.c | 11150 | libzstd | 3.15 | 13.61 | 4.33 | 10.42 |
| canterbury/fields.c | 11150 | stdx | 3.00 | 12.72 | 4.24 | 0.14 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.22 | 16.93 | 4.01 | 5.70 |
| canterbury/grammar.lsp | 3721 | stdx | 4.13 | 16.54 | 4.01 | 0.22 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.48 | 11.22 | 4.52 | 7.67 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.24 | 0.85 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.74 | 12.87 | 4.71 | 5.30 |
| canterbury/lcet10.txt | 426754 | stdx | 2.71 | 11.52 | 4.26 | 2.25 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.17 | 15.14 | 4.78 | 1.56 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.26 | 0.98 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.50 | 3.11 | 24.37 |
| canterbury/ptt5 | 513216 | stdx | 1.34 | 4.46 | 3.34 | 13.05 |
| canterbury/sum | 38240 | libzstd | 2.65 | 10.51 | 3.96 | 10.92 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.26 |
| canterbury/xargs.1 | 4227 | libzstd | 4.29 | 17.40 | 4.06 | 10.48 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 17.17 | 4.06 | 0.20 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.00 | 13.63 | 4.54 | 2.25 |
| canterbury-large/E.coli | 4638690 | stdx | 3.06 | 12.04 | 3.93 | 3.05 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.90 | 11.99 | 4.13 | 8.53 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.00 | 10.64 | 3.55 | 9.33 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.49 | 9.59 | 3.86 | 19.82 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.56 | 8.64 | 3.37 | 21.31 |
| http/html-1kx1024 | 1048576 | libzstd | 7.41 | 21.63 | 2.92 | 62.82 |
| http/html-1kx1024 | 1048576 | stdx | 7.46 | 22.46 | 3.01 | 76.27 |
| http/html-16kx64 | 1048576 | libzstd | 2.67 | 10.15 | 3.80 | 28.67 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.60 | 30.68 |
| http/html-1m | 1048576 | libzstd | 1.99 | 7.86 | 3.95 | 24.34 |
| http/html-1m | 1048576 | stdx | 1.99 | 7.12 | 3.57 | 25.25 |
| http/json-1kx1024 | 1048576 | libzstd | 6.38 | 17.37 | 2.72 | 48.94 |
| http/json-1kx1024 | 1048576 | stdx | 6.21 | 17.86 | 2.87 | 53.49 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.22 | 3.53 | 27.67 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.58 | 19.88 |
| http/json-1m | 1048576 | libzstd | 1.71 | 6.04 | 3.53 | 27.49 |
| http/json-1m | 1048576 | stdx | 1.62 | 5.91 | 3.65 | 14.11 |
| http/js-1kx1024 | 1048576 | libzstd | 8.45 | 26.38 | 3.12 | 73.32 |
| http/js-1kx1024 | 1048576 | stdx | 9.03 | 27.60 | 3.06 | 112.68 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.71 | 4.00 | 24.37 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.73 | 26.45 |
| http/js-1m | 1048576 | libzstd | 2.01 | 8.18 | 4.07 | 20.31 |
| http/js-1m | 1048576 | stdx | 2.06 | 7.48 | 3.62 | 21.67 |
| http/css-1kx1024 | 1048576 | libzstd | 7.04 | 19.70 | 2.80 | 53.76 |
| http/css-1kx1024 | 1048576 | stdx | 6.84 | 19.96 | 2.92 | 63.46 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.69 | 3.87 | 23.55 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.30 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.57 | 3.89 | 5.49 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.51 | 4.30 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.80 | 9.40 | 3.35 | 28.61 |
| shuffled/dickens-1m | 1048576 | stdx | 2.72 | 9.19 | 3.38 | 12.44 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.61 | 17.04 | 2.24 | 100.93 |
| silesia/dickens | 1048576 | stdx | 5.10 | 12.38 | 2.43 | 54.60 |
| silesia/mozilla | 1048576 | Google | 13.58 | 27.77 | 2.04 | 46.79 |
| silesia/mozilla | 1048576 | stdx | 8.32 | 15.02 | 1.81 | 47.57 |
| silesia/mr | 1048576 | Google | 8.92 | 20.24 | 2.27 | 102.50 |
| silesia/mr | 1048576 | stdx | 5.84 | 13.25 | 2.27 | 88.50 |
| silesia/nci | 1048576 | Google | 2.56 | 5.69 | 2.22 | 52.30 |
| silesia/nci | 1048576 | stdx | 1.94 | 3.95 | 2.04 | 55.20 |
| silesia/ooffice | 1048576 | Google | 14.21 | 29.28 | 2.06 | 288.11 |
| silesia/ooffice | 1048576 | stdx | 10.83 | 20.33 | 1.88 | 322.89 |
| silesia/osdb | 1048576 | Google | 8.25 | 17.38 | 2.11 | 96.30 |
| silesia/osdb | 1048576 | stdx | 5.14 | 10.57 | 2.06 | 92.36 |
| silesia/reymont | 1048576 | Google | 5.43 | 12.73 | 2.34 | 81.67 |
| silesia/reymont | 1048576 | stdx | 3.72 | 9.25 | 2.49 | 48.00 |
| silesia/samba | 1048576 | Google | 7.57 | 16.22 | 2.14 | 95.52 |
| silesia/samba | 1048576 | stdx | 5.05 | 10.71 | 2.12 | 66.76 |
| silesia/sao | 1048576 | Google | 16.83 | 36.97 | 2.20 | 161.82 |
| silesia/sao | 1048576 | stdx | 10.38 | 22.65 | 2.18 | 142.04 |
| silesia/webster | 1048576 | Google | 6.54 | 14.07 | 2.15 | 114.85 |
| silesia/webster | 1048576 | stdx | 4.39 | 9.98 | 2.27 | 68.71 |
| silesia/x-ray | 1048576 | Google | 19.33 | 38.46 | 1.99 | 233.93 |
| silesia/x-ray | 1048576 | stdx | 14.45 | 30.18 | 2.09 | 235.14 |
| silesia/xml | 1048576 | Google | 3.46 | 7.65 | 2.21 | 65.61 |
| silesia/xml | 1048576 | stdx | 2.40 | 5.40 | 2.25 | 47.20 |
| canterbury/alice29.txt | 152089 | Google | 8.89 | 20.66 | 2.32 | 135.77 |
| canterbury/alice29.txt | 152089 | stdx | 6.08 | 15.33 | 2.52 | 82.83 |
| canterbury/asyoulik.txt | 125179 | Google | 10.41 | 23.83 | 2.29 | 170.12 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.09 | 17.43 | 2.46 | 106.17 |
| canterbury/cp.html | 24603 | Google | 9.15 | 22.18 | 2.42 | 111.36 |
| canterbury/cp.html | 24603 | stdx | 5.89 | 17.15 | 2.91 | 42.73 |
| canterbury/fields.c | 11150 | Google | 7.01 | 21.25 | 3.03 | 19.46 |
| canterbury/fields.c | 11150 | stdx | 4.88 | 17.08 | 3.50 | 2.66 |
| canterbury/grammar.lsp | 3721 | Google | 9.86 | 30.23 | 3.06 | 6.05 |
| canterbury/grammar.lsp | 3721 | stdx | 7.15 | 25.04 | 3.50 | 0.72 |
| canterbury/kennedy.xls | 1029744 | Google | 5.49 | 17.05 | 3.11 | 37.01 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.78 | 12.94 | 3.42 | 33.94 |
| canterbury/lcet10.txt | 426754 | Google | 7.75 | 17.42 | 2.25 | 129.39 |
| canterbury/lcet10.txt | 426754 | stdx | 5.20 | 12.96 | 2.49 | 66.42 |
| canterbury/plrabn12.txt | 481861 | Google | 9.08 | 20.94 | 2.31 | 132.81 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.14 | 15.04 | 2.45 | 87.07 |
| canterbury/ptt5 | 513216 | Google | 4.29 | 10.36 | 2.42 | 62.29 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.07 | 65.59 |
| canterbury/sum | 38240 | Google | 10.79 | 26.44 | 2.45 | 155.75 |
| canterbury/sum | 38240 | stdx | 8.36 | 21.11 | 2.53 | 158.53 |
| canterbury/xargs.1 | 4227 | Google | 11.01 | 34.81 | 3.16 | 8.85 |
| canterbury/xargs.1 | 4227 | stdx | 8.46 | 30.44 | 3.60 | 6.48 |
| canterbury-large/E.coli | 1048576 | Google | 7.47 | 19.44 | 2.60 | 1.35 |
| canterbury-large/E.coli | 1048576 | stdx | 6.70 | 13.48 | 2.01 | 1.29 |
| canterbury-large/bible.txt | 1048576 | Google | 5.35 | 12.38 | 2.32 | 80.99 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.52 | 8.93 | 2.54 | 39.62 |
| canterbury-large/world192.txt | 1048576 | Google | 6.20 | 12.88 | 2.08 | 115.16 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.38 | 9.38 | 2.14 | 77.67 |
| http/html-1kx1024 | 1048576 | Google | 18.01 | 42.09 | 2.34 | 387.64 |
| http/html-1kx1024 | 1048576 | stdx | 15.25 | 37.56 | 2.46 | 360.72 |
| http/html-16kx64 | 1048576 | Google | 6.78 | 14.88 | 2.20 | 149.94 |
| http/html-16kx64 | 1048576 | stdx | 5.14 | 12.15 | 2.36 | 114.89 |
| http/html-1m | 1048576 | Google | 4.06 | 8.99 | 2.21 | 83.38 |
| http/html-1m | 1048576 | stdx | 2.85 | 6.52 | 2.29 | 54.79 |
| http/json-1kx1024 | 1048576 | Google | 14.30 | 36.74 | 2.57 | 238.85 |
| http/json-1kx1024 | 1048576 | stdx | 12.94 | 33.63 | 2.60 | 276.23 |
| http/json-16kx64 | 1048576 | Google | 4.42 | 11.42 | 2.58 | 81.23 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.58 |
| http/json-1m | 1048576 | Google | 3.41 | 8.66 | 2.54 | 58.87 |
| http/json-1m | 1048576 | stdx | 2.45 | 5.99 | 2.45 | 57.52 |
| http/js-1kx1024 | 1048576 | Google | 19.89 | 46.38 | 2.33 | 427.94 |
| http/js-1kx1024 | 1048576 | stdx | 16.36 | 39.90 | 2.44 | 380.65 |
| http/js-16kx64 | 1048576 | Google | 8.06 | 17.79 | 2.21 | 166.87 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 126.39 |
| http/js-1m | 1048576 | Google | 4.37 | 9.60 | 2.20 | 83.61 |
| http/js-1m | 1048576 | stdx | 3.16 | 7.25 | 2.30 | 55.79 |
| http/css-1kx1024 | 1048576 | Google | 15.37 | 37.48 | 2.44 | 292.31 |
| http/css-1kx1024 | 1048576 | stdx | 13.81 | 34.70 | 2.51 | 302.68 |
| http/css-16kx64 | 1048576 | Google | 4.97 | 11.78 | 2.37 | 101.08 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.87 |
| http/css-1m | 1048576 | Google | 2.43 | 9.43 | 3.88 | 16.73 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.49 | 12.03 |
| shuffled/dickens-1m | 1048576 | Google | 9.70 | 20.34 | 2.10 | 110.77 |
| shuffled/dickens-1m | 1048576 | stdx | 8.81 | 14.53 | 1.65 | 121.62 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.22 | 36.91 | 2.43 | 409.98 |
| silesia/dickens | 10192446 | 1 | stdx | 16.39 | 38.17 | 2.33 | 361.70 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.06 | 87.63 | 1.68 | 693.72 |
| silesia/dickens | 10192446 | 6 | stdx | 49.59 | 84.25 | 1.70 | 1448.71 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.86 | 160.47 | 1.43 | 930.64 |
| silesia/dickens | 10192446 | 9 | stdx | 64.80 | 150.06 | 2.32 | 1397.49 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.11 | 32.62 | 2.31 | 436.56 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.33 | 30.24 | 2.27 | 295.20 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.85 | 70.83 | 2.16 | 579.02 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.52 | 69.96 | 2.22 | 736.68 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.66 | 221.49 | 1.74 | 771.69 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.59 | 125.42 | 2.58 | 781.23 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.97 | 35.02 | 2.93 | 229.30 |
| silesia/mr | 9970564 | 1 | stdx | 12.57 | 34.08 | 2.71 | 187.17 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.22 | 80.54 | 2.11 | 437.45 |
| silesia/mr | 9970564 | 6 | stdx | 39.89 | 83.18 | 2.09 | 992.48 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.62 | 165.48 | 1.70 | 749.89 |
| silesia/mr | 9970564 | 9 | stdx | 78.84 | 184.93 | 2.35 | 1219.59 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.19 | 18.42 | 2.97 | 113.93 |
| silesia/nci | 33553445 | 1 | stdx | 4.92 | 10.88 | 2.21 | 97.42 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.97 | 34.84 | 2.05 | 225.79 |
| silesia/nci | 33553445 | 6 | stdx | 14.40 | 29.54 | 2.05 | 397.24 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.44 | 105.28 | 1.69 | 501.48 |
| silesia/nci | 33553445 | 9 | stdx | 28.27 | 69.01 | 2.44 | 559.38 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.90 | 39.15 | 1.97 | 752.07 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.75 | 39.08 | 2.20 | 429.76 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 41.00 | 79.10 | 1.93 | 954.42 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.61 | 87.83 | 2.11 | 1009.13 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.60 | 127.63 | 1.71 | 1131.54 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.11 | 129.03 | 2.48 | 929.35 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.87 | 30.15 | 2.34 | 351.92 |
| silesia/osdb | 10085684 | 1 | stdx | 12.89 | 27.86 | 2.16 | 293.45 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.31 | 55.67 | 1.97 | 489.81 |
| silesia/osdb | 10085684 | 6 | stdx | 27.18 | 57.39 | 2.11 | 578.05 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.92 | 64.15 | 1.89 | 553.55 |
| silesia/osdb | 10085684 | 9 | stdx | 35.28 | 87.16 | 2.47 | 684.50 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.63 | 32.88 | 2.60 | 310.83 |
| silesia/reymont | 6627202 | 1 | stdx | 13.48 | 33.24 | 2.47 | 270.97 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.09 | 86.58 | 1.80 | 518.33 |
| silesia/reymont | 6627202 | 6 | stdx | 45.24 | 76.81 | 1.70 | 1428.86 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.32 | 276.14 | 1.39 | 834.72 |
| silesia/reymont | 6627202 | 9 | stdx | 74.02 | 160.03 | 2.16 | 1430.74 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.43 | 26.53 | 2.54 | 271.27 |
| silesia/samba | 21606400 | 1 | stdx | 9.89 | 22.23 | 2.25 | 221.10 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.92 | 58.79 | 2.03 | 384.88 |
| silesia/samba | 21606400 | 6 | stdx | 24.16 | 49.83 | 2.06 | 631.73 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.20 | 141.44 | 1.68 | 504.10 |
| silesia/samba | 21606400 | 9 | stdx | 36.11 | 90.81 | 2.51 | 643.93 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.70 | 47.87 | 2.21 | 682.58 |
| silesia/sao | 7251944 | 1 | stdx | 19.13 | 49.92 | 2.61 | 345.48 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.12 | 96.89 | 1.90 | 963.40 |
| silesia/sao | 7251944 | 6 | stdx | 47.11 | 105.66 | 2.24 | 858.16 |
| silesia/sao | 7251944 | 9 | libdeflate | 70.94 | 120.26 | 1.70 | 1106.49 |
| silesia/sao | 7251944 | 9 | stdx | 55.08 | 137.71 | 2.50 | 837.58 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.11 | 30.45 | 2.32 | 386.82 |
| silesia/webster | 41458703 | 1 | stdx | 13.84 | 29.08 | 2.10 | 340.28 |
| silesia/webster | 41458703 | 6 | libdeflate | 36.97 | 66.02 | 1.79 | 568.43 |
| silesia/webster | 41458703 | 6 | stdx | 35.24 | 60.87 | 1.73 | 1127.78 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.64 | 138.85 | 1.47 | 757.00 |
| silesia/webster | 41458703 | 9 | stdx | 48.39 | 110.73 | 2.29 | 1084.29 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.67 | 49.67 | 2.10 | 783.14 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.56 | 50.81 | 2.89 | 261.35 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.83 | 82.77 | 2.52 | 854.44 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.85 | 98.12 | 2.90 | 540.37 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.50 | 91.03 | 2.43 | 1031.83 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.48 | 121.58 | 3.00 | 467.44 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.79 | 21.59 | 2.77 | 175.29 |
| silesia/xml | 5345280 | 1 | stdx | 6.97 | 15.66 | 2.25 | 154.85 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.13 | 40.51 | 1.92 | 263.78 |
| silesia/xml | 5345280 | 6 | stdx | 17.68 | 34.32 | 1.94 | 503.09 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.69 | 89.17 | 1.52 | 372.57 |
| silesia/xml | 5345280 | 9 | stdx | 26.59 | 63.43 | 2.39 | 526.47 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.26 | 35.61 | 2.50 | 378.77 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.04 | 36.12 | 2.40 | 336.31 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.67 | 82.29 | 1.76 | 638.66 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.81 | 77.41 | 1.77 | 1328.73 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.44 | 159.21 | 1.48 | 848.05 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 58.17 | 138.20 | 2.38 | 1267.19 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.12 | 37.20 | 2.46 | 412.44 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.77 | 37.43 | 2.37 | 359.35 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.28 | 85.43 | 1.77 | 711.99 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.31 | 81.92 | 1.77 | 1404.52 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.91 | 136.15 | 1.53 | 939.15 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 60.18 | 144.56 | 2.40 | 1335.79 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.66 | 32.02 | 2.75 | 283.12 |
| canterbury/cp.html | 24603 | 1 | stdx | 11.01 | 27.13 | 2.46 | 245.75 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 26.87 | 62.33 | 2.32 | 483.81 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.76 | 57.05 | 2.40 | 626.76 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.98 | 91.97 | 1.96 | 599.90 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.24 | 88.88 | 2.85 | 642.93 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.67 | 35.92 | 3.72 | 71.57 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.09 | 30.05 | 3.72 | 23.62 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.17 | 69.37 | 2.87 | 227.00 |
| canterbury/fields.c | 11150 | 6 | stdx | 21.02 | 57.62 | 2.74 | 444.78 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.20 | 100.81 | 2.28 | 405.00 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.30 | 92.65 | 3.27 | 445.14 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.08 | 51.51 | 3.94 | 17.91 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.86 | 39.01 | 3.96 | 1.66 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.62 | 87.06 | 3.69 | 23.44 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.16 | 70.80 | 4.13 | 17.37 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.61 | 102.89 | 3.36 | 37.55 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.68 | 99.30 | 4.19 | 52.47 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.37 | 27.18 | 3.69 | 65.30 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.04 | 22.58 | 3.21 | 63.54 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.82 | 73.85 | 2.65 | 96.13 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.31 | 61.98 | 3.21 | 139.43 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.18 | 664.23 | 1.83 | 163.26 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 30.19 | 107.06 | 3.55 | 144.81 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.77 | 33.99 | 2.47 | 369.65 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.46 | 33.92 | 2.35 | 330.38 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.01 | 78.22 | 1.74 | 606.03 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.75 | 73.42 | 1.76 | 1238.93 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.78 | 136.94 | 1.49 | 804.21 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 55.15 | 130.91 | 2.37 | 1197.67 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.81 | 38.62 | 2.44 | 426.66 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.73 | 40.24 | 2.41 | 370.76 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.17 | 91.90 | 1.70 | 753.44 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.75 | 88.89 | 1.72 | 1527.43 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.92 | 166.26 | 1.42 | 1003.66 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 67.77 | 158.18 | 2.33 | 1466.44 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.42 | 18.61 | 2.90 | 141.09 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.96 | 11.03 | 2.22 | 123.38 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.23 | 36.17 | 2.54 | 218.56 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.31 | 29.57 | 2.40 | 309.71 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.58 | 120.86 | 1.99 | 378.81 |
| canterbury/ptt5 | 513216 | 9 | stdx | 41.30 | 126.55 | 3.06 | 591.96 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.78 | 33.49 | 2.62 | 336.14 |
| canterbury/sum | 38240 | 1 | stdx | 12.54 | 29.36 | 2.34 | 295.82 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.56 | 69.87 | 2.45 | 494.77 |
| canterbury/sum | 38240 | 6 | stdx | 26.74 | 65.73 | 2.46 | 663.28 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.41 | 181.91 | 1.93 | 608.33 |
| canterbury/sum | 38240 | 9 | stdx | 39.21 | 112.32 | 2.86 | 659.90 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.41 | 53.06 | 3.96 | 30.20 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.77 | 43.10 | 4.00 | 2.72 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.95 | 87.70 | 3.82 | 75.70 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 18.12 | 74.35 | 4.10 | 52.38 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 24.97 | 94.34 | 3.78 | 92.22 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 25.63 | 106.95 | 4.17 | 91.17 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.06 | 40.47 | 3.36 | 164.49 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.66 | 42.29 | 3.34 | 101.20 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.24 | 395.99 | 2.16 | 262.89 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.91 | 374.12 | 3.04 | 1921.80 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.51 | 1063.49 | 1.30 | 1322.63 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 230.47 | 751.65 | 3.26 | 2441.94 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.53 | 32.38 | 2.58 | 311.80 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.32 | 32.23 | 2.42 | 281.75 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.03 | 80.12 | 1.74 | 522.22 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.30 | 72.38 | 1.71 | 1274.73 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.81 | 200.28 | 1.41 | 743.21 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 60.50 | 136.73 | 2.26 | 1223.58 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.31 | 29.72 | 2.23 | 414.19 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.13 | 28.55 | 2.02 | 378.84 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 32.99 | 60.25 | 1.83 | 556.89 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.13 | 56.80 | 1.77 | 1004.63 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.68 | 119.11 | 1.48 | 687.98 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 41.63 | 97.56 | 2.34 | 973.33 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.40 | 103.92 | 2.94 | 454.97 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.36 | 58.63 | 2.74 | 366.41 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.20 | 138.33 | 2.99 | 564.83 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 32.92 | 94.30 | 2.86 | 531.77 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.74 | 142.44 | 2.98 | 587.53 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 36.93 | 112.10 | 3.04 | 538.22 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.45 | 27.96 | 2.68 | 266.84 |
| http/html-16kx64 | 1048576 | 1 | stdx | 8.98 | 20.25 | 2.25 | 233.13 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.28 | 52.09 | 2.34 | 390.04 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.86 | 42.86 | 2.27 | 542.96 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 34.88 | 72.54 | 2.08 | 462.68 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.69 | 69.05 | 2.80 | 551.15 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.76 | 23.03 | 2.63 | 223.68 |
| http/html-1m | 1048576 | 1 | stdx | 8.14 | 17.79 | 2.18 | 205.70 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.27 | 49.53 | 1.96 | 326.47 |
| http/html-1m | 1048576 | 6 | stdx | 21.22 | 40.70 | 1.92 | 629.84 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.07 | 109.24 | 1.54 | 432.80 |
| http/html-1m | 1048576 | 9 | stdx | 29.85 | 73.42 | 2.46 | 614.51 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.74 | 94.80 | 2.99 | 302.39 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.48 | 45.16 | 2.74 | 242.87 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.02 | 126.60 | 2.94 | 373.67 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.07 | 78.36 | 2.89 | 379.87 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.11 | 142.45 | 2.73 | 430.51 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.61 | 95.54 | 3.12 | 385.10 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.84 | 23.85 | 3.04 | 134.40 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.45 | 13.94 | 2.56 | 110.39 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.14 | 46.61 | 2.57 | 204.24 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.36 | 35.01 | 2.62 | 281.48 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.27 | 151.99 | 1.89 | 299.37 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.11 | 58.29 | 3.05 | 302.03 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.73 | 19.85 | 2.95 | 124.65 |
| http/json-1m | 1048576 | 1 | stdx | 5.06 | 12.51 | 2.47 | 103.70 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.31 | 45.30 | 2.23 | 175.37 |
| http/json-1m | 1048576 | 6 | stdx | 14.68 | 35.08 | 2.39 | 298.62 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.75 | 205.21 | 1.69 | 279.74 |
| http/json-1m | 1048576 | 9 | stdx | 27.30 | 69.14 | 2.53 | 336.69 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.03 | 107.80 | 2.91 | 517.70 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.72 | 65.40 | 2.76 | 410.02 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.39 | 144.85 | 2.93 | 679.09 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 36.55 | 104.11 | 2.85 | 620.15 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.72 | 150.13 | 2.90 | 716.18 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 41.26 | 125.11 | 3.03 | 626.09 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.70 | 30.90 | 2.64 | 308.32 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.81 | 24.80 | 2.29 | 272.94 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.80 | 59.43 | 2.30 | 468.52 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.73 | 50.04 | 2.20 | 681.75 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.77 | 83.31 | 2.04 | 564.54 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.50 | 81.30 | 2.76 | 663.86 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.64 | 25.19 | 2.61 | 247.55 |
| http/js-1m | 1048576 | 1 | stdx | 9.52 | 21.31 | 2.24 | 232.04 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.68 | 56.12 | 1.96 | 368.87 |
| http/js-1m | 1048576 | 6 | stdx | 24.88 | 46.64 | 1.87 | 747.92 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.39 | 120.65 | 1.58 | 500.75 |
| http/js-1m | 1048576 | 9 | stdx | 34.96 | 84.80 | 2.43 | 707.10 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.21 | 97.73 | 2.94 | 377.81 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.33 | 49.52 | 2.70 | 301.65 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.84 | 129.22 | 2.95 | 480.50 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.05 | 82.31 | 2.83 | 503.20 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.90 | 133.80 | 2.91 | 509.99 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.15 | 99.46 | 3.00 | 521.29 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.65 | 25.60 | 2.96 | 174.69 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.66 | 16.96 | 2.55 | 134.47 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.15 | 48.80 | 2.42 | 287.48 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.42 | 38.00 | 2.31 | 468.66 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.77 | 82.40 | 2.02 | 371.55 |
| http/css-16kx64 | 1048576 | 9 | stdx | 22.91 | 65.13 | 2.84 | 479.17 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.94 | 21.15 | 3.05 | 132.21 |
| http/css-1m | 1048576 | 1 | stdx | 5.76 | 14.91 | 2.59 | 108.09 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.76 | 44.50 | 2.14 | 226.13 |
| http/css-1m | 1048576 | 6 | stdx | 16.60 | 35.61 | 2.15 | 448.36 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.71 | 111.58 | 1.60 | 309.61 |
| http/css-1m | 1048576 | 9 | stdx | 28.05 | 72.54 | 2.59 | 474.00 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.21 | 48.89 | 1.94 | 929.33 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.08 | 49.19 | 2.72 | 323.16 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.54 | 86.45 | 2.08 | 1181.91 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.59 | 88.79 | 2.24 | 855.16 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.12 | 94.50 | 2.01 | 1346.64 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 53.65 | 133.83 | 2.49 | 1122.68 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.20 | 31.13 | 3.05 | 123.71 |
| silesia/dickens | 10192446 | 1 | stdx | 24.12 | 82.03 | 3.40 | 124.96 |
| silesia/dickens | 10192446 | 3 | libzstd | 22.29 | 35.01 | 1.57 | 171.64 |
| silesia/dickens | 10192446 | 3 | stdx | 34.55 | 78.22 | 2.26 | 182.29 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.00 | 22.57 | 3.22 | 72.16 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.48 | 54.73 | 3.13 | 172.95 |
| silesia/mozilla | 51220480 | 3 | libzstd | 16.64 | 28.71 | 1.73 | 102.55 |
| silesia/mozilla | 51220480 | 3 | stdx | 29.33 | 62.01 | 2.11 | 144.45 |
| silesia/mr | 9970564 | 1 | libzstd | 7.63 | 24.73 | 3.24 | 57.70 |
| silesia/mr | 9970564 | 1 | stdx | 19.79 | 66.82 | 3.38 | 113.75 |
| silesia/mr | 9970564 | 3 | libzstd | 19.63 | 32.97 | 1.68 | 86.31 |
| silesia/mr | 9970564 | 3 | stdx | 32.35 | 72.46 | 2.24 | 114.61 |
| silesia/nci | 33553445 | 1 | libzstd | 3.53 | 9.49 | 2.69 | 58.57 |
| silesia/nci | 33553445 | 1 | stdx | 7.60 | 25.69 | 3.38 | 59.06 |
| silesia/nci | 33553445 | 3 | libzstd | 5.34 | 10.11 | 1.89 | 56.76 |
| silesia/nci | 33553445 | 3 | stdx | 11.45 | 29.15 | 2.55 | 66.29 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.52 | 29.17 | 3.42 | 71.56 |
| silesia/ooffice | 6152192 | 1 | stdx | 22.99 | 72.51 | 3.15 | 179.82 |
| silesia/ooffice | 6152192 | 3 | libzstd | 23.46 | 40.82 | 1.74 | 121.51 |
| silesia/ooffice | 6152192 | 3 | stdx | 39.99 | 82.20 | 2.06 | 184.72 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.08 | 22.22 | 3.14 | 66.71 |
| silesia/osdb | 10085684 | 1 | stdx | 16.21 | 50.52 | 3.12 | 119.34 |
| silesia/osdb | 10085684 | 3 | libzstd | 17.49 | 27.06 | 1.55 | 70.10 |
| silesia/osdb | 10085684 | 3 | stdx | 30.24 | 57.87 | 1.91 | 110.09 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.80 | 27.02 | 2.76 | 155.72 |
| silesia/reymont | 6627202 | 1 | stdx | 20.02 | 72.05 | 3.60 | 96.39 |
| silesia/reymont | 6627202 | 3 | libzstd | 17.75 | 27.53 | 1.55 | 127.18 |
| silesia/reymont | 6627202 | 3 | stdx | 27.15 | 62.18 | 2.29 | 146.60 |
| silesia/samba | 21606400 | 1 | libzstd | 5.97 | 16.80 | 2.82 | 88.19 |
| silesia/samba | 21606400 | 1 | stdx | 13.40 | 42.89 | 3.20 | 124.47 |
| silesia/samba | 21606400 | 3 | libzstd | 11.64 | 19.20 | 1.65 | 99.66 |
| silesia/samba | 21606400 | 3 | stdx | 19.61 | 44.75 | 2.28 | 132.74 |
| silesia/sao | 7251944 | 1 | libzstd | 9.02 | 33.64 | 3.73 | 43.58 |
| silesia/sao | 7251944 | 1 | stdx | 25.89 | 82.03 | 3.17 | 105.30 |
| silesia/sao | 7251944 | 3 | libzstd | 30.92 | 52.14 | 1.69 | 95.32 |
| silesia/sao | 7251944 | 3 | stdx | 48.91 | 95.22 | 1.95 | 142.23 |
| silesia/webster | 41458703 | 1 | libzstd | 8.72 | 24.86 | 2.85 | 135.60 |
| silesia/webster | 41458703 | 1 | stdx | 20.22 | 64.04 | 3.17 | 165.86 |
| silesia/webster | 41458703 | 3 | libzstd | 18.61 | 27.84 | 1.50 | 178.18 |
| silesia/webster | 41458703 | 3 | stdx | 29.88 | 64.55 | 2.16 | 194.44 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.66 | 14.89 | 3.20 | 17.09 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.73 | 76.64 | 3.23 | 92.53 |
| silesia/x-ray | 8474240 | 3 | libzstd | 31.75 | 54.96 | 1.73 | 86.21 |
| silesia/x-ray | 8474240 | 3 | stdx | 45.30 | 92.40 | 2.04 | 107.82 |
| silesia/xml | 5345280 | 1 | libzstd | 4.26 | 11.65 | 2.74 | 72.74 |
| silesia/xml | 5345280 | 1 | stdx | 10.30 | 34.21 | 3.32 | 94.44 |
| silesia/xml | 5345280 | 3 | libzstd | 6.67 | 12.84 | 1.93 | 78.78 |
| silesia/xml | 5345280 | 3 | stdx | 12.43 | 32.28 | 2.60 | 115.32 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.91 | 32.86 | 3.01 | 146.06 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.28 | 76.49 | 3.43 | 185.37 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.38 | 39.93 | 2.60 | 204.00 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.08 | 73.76 | 2.83 | 334.92 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.78 | 33.59 | 3.43 | 109.36 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.44 | 79.00 | 3.37 | 213.72 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.45 | 40.28 | 2.61 | 207.09 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 27.67 | 79.30 | 2.87 | 372.58 |
| canterbury/cp.html | 24603 | 1 | libzstd | 6.99 | 26.65 | 3.81 | 38.16 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.01 | 57.76 | 3.61 | 116.12 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.29 | 32.88 | 3.54 | 18.54 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.02 | 59.76 | 3.32 | 139.48 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.75 | 31.77 | 3.63 | 39.54 |
| canterbury/fields.c | 11150 | 1 | stdx | 16.96 | 65.73 | 3.88 | 84.96 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.03 | 34.41 | 3.81 | 8.87 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.49 | 64.68 | 3.70 | 87.50 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.51 | 37.98 | 3.99 | 8.19 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.09 | 77.57 | 3.86 | 47.68 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.65 | 43.28 | 4.06 | 1.56 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.37 | 79.60 | 3.72 | 67.81 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.01 | 23.37 | 3.89 | 14.93 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.62 | 56.75 | 3.88 | 83.62 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.48 | 24.26 | 2.86 | 27.53 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 19.92 | 56.61 | 2.84 | 107.69 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.90 | 28.42 | 2.87 | 161.39 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.28 | 72.02 | 3.39 | 159.94 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 16.75 | 32.77 | 1.96 | 202.58 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 25.82 | 67.10 | 2.60 | 295.50 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.36 | 32.28 | 3.12 | 131.08 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 24.91 | 84.16 | 3.38 | 157.95 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 20.28 | 39.60 | 1.95 | 225.85 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 31.11 | 80.77 | 2.60 | 342.14 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.15 | 8.48 | 2.69 | 67.26 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.45 | 23.15 | 3.11 | 104.05 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 4.92 | 11.28 | 2.29 | 59.54 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.29 | 24.08 | 2.59 | 132.50 |
| canterbury/sum | 38240 | 1 | libzstd | 6.51 | 25.37 | 3.90 | 30.13 |
| canterbury/sum | 38240 | 1 | stdx | 16.82 | 59.13 | 3.52 | 149.03 |
| canterbury/sum | 38240 | 3 | libzstd | 8.81 | 31.64 | 3.59 | 22.47 |
| canterbury/sum | 38240 | 3 | stdx | 19.73 | 61.82 | 3.13 | 182.47 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 10.02 | 39.84 | 3.97 | 12.25 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.78 | 80.38 | 3.87 | 56.19 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.07 | 48.45 | 4.01 | 1.78 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.86 | 83.98 | 3.67 | 81.24 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.51 | 33.29 | 3.17 | 75.46 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.85 | 95.62 | 4.38 | 7.24 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 15.08 | 31.71 | 2.10 | 35.85 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.28 | 70.38 | 3.02 | 38.32 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.80 | 27.35 | 2.79 | 154.72 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.32 | 71.86 | 3.54 | 108.67 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 17.76 | 28.64 | 1.61 | 133.56 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 27.16 | 63.36 | 2.33 | 155.13 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.19 | 22.62 | 2.76 | 140.29 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.58 | 55.86 | 3.01 | 192.69 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 15.32 | 24.36 | 1.59 | 175.29 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 24.24 | 51.26 | 2.11 | 236.03 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.20 | 52.52 | 3.05 | 168.72 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.69 | 100.54 | 2.82 | 634.10 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.31 | 59.34 | 3.07 | 205.96 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 37.72 | 104.00 | 2.76 | 629.50 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.85 | 22.47 | 2.86 | 127.43 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.12 | 46.84 | 3.32 | 182.27 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.91 | 24.79 | 2.78 | 145.99 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.15 | 47.61 | 3.14 | 191.22 |
| http/html-1m | 1048576 | 1 | libzstd | 6.28 | 16.66 | 2.65 | 117.30 |
| http/html-1m | 1048576 | 1 | stdx | 12.86 | 42.00 | 3.27 | 134.12 |
| http/html-1m | 1048576 | 3 | libzstd | 9.39 | 18.50 | 1.97 | 125.87 |
| http/html-1m | 1048576 | 3 | stdx | 15.41 | 39.37 | 2.56 | 177.21 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.43 | 42.58 | 2.95 | 119.69 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.47 | 83.13 | 2.82 | 524.00 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.98 | 44.69 | 2.98 | 133.38 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.56 | 84.87 | 2.78 | 532.56 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.83 | 15.00 | 3.11 | 59.16 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.68 | 33.78 | 3.49 | 116.05 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.43 | 16.31 | 3.01 | 73.51 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.44 | 34.58 | 3.31 | 122.62 |
| http/json-1m | 1048576 | 1 | libzstd | 4.05 | 12.47 | 3.08 | 53.37 |
| http/json-1m | 1048576 | 1 | stdx | 8.95 | 30.70 | 3.43 | 85.33 |
| http/json-1m | 1048576 | 3 | libzstd | 6.24 | 14.06 | 2.25 | 68.76 |
| http/json-1m | 1048576 | 3 | stdx | 11.10 | 30.64 | 2.76 | 119.06 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.72 | 57.29 | 3.06 | 196.34 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 39.84 | 113.49 | 2.85 | 692.11 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.64 | 65.62 | 3.03 | 267.76 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.15 | 116.54 | 2.77 | 678.49 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 9.01 | 26.53 | 2.94 | 133.67 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.62 | 55.71 | 3.35 | 200.61 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.24 | 28.96 | 2.83 | 159.67 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.53 | 55.35 | 3.16 | 208.63 |
| http/js-1m | 1048576 | 1 | libzstd | 6.62 | 17.80 | 2.69 | 116.41 |
| http/js-1m | 1048576 | 1 | stdx | 13.91 | 45.88 | 3.30 | 136.39 |
| http/js-1m | 1048576 | 3 | libzstd | 10.16 | 19.49 | 1.92 | 125.04 |
| http/js-1m | 1048576 | 3 | stdx | 16.55 | 41.25 | 2.49 | 186.98 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.73 | 46.97 | 2.99 | 143.09 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.31 | 91.65 | 2.84 | 580.31 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.84 | 50.68 | 3.01 | 165.62 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.73 | 93.63 | 2.78 | 582.93 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.24 | 18.99 | 3.04 | 80.41 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.43 | 43.79 | 3.52 | 137.10 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.61 | 19.53 | 2.96 | 94.55 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.88 | 42.34 | 3.29 | 152.34 |
| http/css-1m | 1048576 | 1 | libzstd | 1.51 | 4.57 | 3.02 | 22.10 |
| http/css-1m | 1048576 | 1 | stdx | 3.96 | 14.85 | 3.75 | 30.51 |
| http/css-1m | 1048576 | 3 | libzstd | 1.98 | 5.34 | 2.69 | 19.55 |
| http/css-1m | 1048576 | 3 | stdx | 3.92 | 13.33 | 3.40 | 31.68 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.53 | 12.79 | 3.63 | 6.46 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.04 | 30.66 | 3.39 | 61.55 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 28.89 | 53.05 | 1.84 | 47.32 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 20.42 | 47.43 | 2.32 | 206.90 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.120 | 3.00 | 2.93 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 75.3 | 239.0 | 0.091 | 8.90 | 3.17 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 44.1 | 194.4 | 0.074 | 5.20 | 4.41 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 283.6 | 1193.5 | 0.818 | 33.50 | 4.21 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.4 | 107.5 | 0.143 | 3.59 | 3.53 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.0 | 106.0 | 0.293 | 3.31 | 3.78 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.0 | 378.2 | 0.379 | 11.23 | 3.98 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.4 | 161.9 | 0.447 | 5.01 | 3.81 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 91.9 | 451.7 | 0.304 | 10.86 | 4.91 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.8 | 89.5 | 0.004 | 4.10 | 3.22 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 76.6 | 250.2 | 0.070 | 11.27 | 3.27 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 48.4 | 205.1 | 0.048 | 7.13 | 4.23 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 241.5 | 927.9 | 0.975 | 35.54 | 3.84 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 27.9 | 107.7 | 0.040 | 4.11 | 3.86 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 31.2 | 105.7 | 0.047 | 4.59 | 3.39 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 95.3 | 346.2 | 0.319 | 14.03 | 3.63 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 32.4 | 144.5 | 0.054 | 4.77 | 4.46 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 96.8 | 406.5 | 0.078 | 14.24 | 4.20 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114059.5 | 403845.2 | 480.361 | 0.66 | 3.54 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 647069.1 | 2749355.2 | 1414.577 | 3.75 | 4.25 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 646967.3 | 2749752.2 | 1406.629 | 3.75 | 4.25 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 4480494.7 | 22490188.2 | 2976.320 | 25.97 | 5.02 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311006.7 | 621743.2 | 636.361 | 1.80 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 223992.9 | 826618.2 | 2140.124 | 1.30 | 3.69 |
| string: silesia/dickens | 1 | 172528 | std.json | 1598001.0 | 4578768.2 | 43351.670 | 9.26 | 2.87 |
| string: silesia/dickens | 1 | 172528 | serde_json | 202101.2 | 802391.2 | 1003.918 | 1.17 | 3.97 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1052657.3 | 5280539.4 | 4950.567 | 6.10 | 5.02 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1566230.2 | 4799762.6 | 1229.714 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 15258107.0 | 62777133.6 | 38857.000 | 12.82 | 4.11 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 15305160.5 | 62777455.6 | 38853.500 | 12.86 | 4.10 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 35672074.4 | 160729111.6 | 158858.571 | 29.97 | 4.51 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4573951.9 | 7053838.6 | 571.286 | 3.84 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1794570.3 | 7322017.6 | 13853.571 | 1.51 | 4.08 |
| string: http/json-1m | 1 | 1190272 | std.json | 10265734.2 | 47381213.6 | 31220.714 | 8.62 | 4.62 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3792867.2 | 15226459.6 | 6094.500 | 3.19 | 4.01 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9020731.9 | 48001233.0 | 27844.714 | 7.58 | 5.32 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2067236.9 | 5765412.8 | 4471.375 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6510322.8 | 24513270.8 | 6955.625 | 3.46 | 3.77 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 6518008.9 | 24513592.8 | 6859.875 | 3.46 | 3.76 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 59390877.4 | 273034491.8 | 270370.000 | 31.54 | 4.60 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3689908.9 | 7945848.8 | 2039.500 | 1.96 | 2.15 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7241623.4 | 12276727.8 | 275897.625 | 3.85 | 1.70 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 18212357.0 | 63617055.8 | 219746.250 | 9.67 | 3.49 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9557535.0 | 24440755.8 | 293043.250 | 5.08 | 2.56 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39380069.0 | 160319824.4 | 796446.375 | 20.91 | 4.07 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12935384.3 | 42561068.3 | 245944.667 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 190792068.3 | 782100838.3 | 389621.000 | 37.59 | 4.10 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 183388238.0 | 782101160.3 | 393223.333 | 36.13 | 4.26 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 184305870.0 | 760206171.3 | 423250.667 | 36.31 | 4.12 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17588897.3 | 49745819.3 | 215040.333 | 3.47 | 2.83 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14287906.3 | 44816977.3 | 438890.000 | 2.82 | 3.14 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79715802.3 | 314900845.3 | 479796.000 | 15.71 | 3.95 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36562022.3 | 131556135.3 | 593752.667 | 7.20 | 3.60 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66843539.3 | 273932601.0 | 839443.000 | 13.17 | 4.10 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 92013.8 | 303836.7 | 8.323 | 0.18 | 3.30 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 185852.8 | 623498.7 | 10.097 | 0.35 | 3.35 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 185397.4 | 623231.7 | 10.516 | 0.35 | 3.36 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 13185683.3 | 66585428.7 | 9.387 | 25.15 | 5.05 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 490668.5 | 1376732.7 | 7.452 | 0.94 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 538167.5 | 2195905.7 | 8.258 | 1.03 | 4.08 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3519345.5 | 12808414.7 | 61656.677 | 6.71 | 3.64 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 284425.3 | 1179969.7 | 6.355 | 0.54 | 4.15 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2255589.3 | 12788771.7 | 244.774 | 4.30 | 5.67 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.8 | 81.5 | 0.107 | 2.34 | 4.11 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.1 | 153.6 | 0.129 | 4.15 | 4.38 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 33.4 | 151.5 | 0.094 | 3.94 | 4.54 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 257.6 | 1182.8 | 0.905 | 30.44 | 4.59 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 19.3 | 79.5 | 0.104 | 2.28 | 4.12 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 22.9 | 94.1 | 0.132 | 2.70 | 4.11 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.7 | 105.4 | 0.244 | 3.27 | 3.81 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.4 | 310.8 | 0.374 | 8.19 | 4.48 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.3 | 255.3 | 0.485 | 7.48 | 4.03 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 67.7 | 315.1 | 0.236 | 8.00 | 4.65 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 19.0 | 82.5 | 0.024 | 2.80 | 4.34 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.0 | 153.9 | 0.027 | 5.30 | 4.27 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 32.7 | 142.5 | 0.025 | 4.82 | 4.35 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 197.5 | 848.0 | 1.256 | 29.07 | 4.29 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.3 | 81.5 | 0.024 | 2.70 | 4.44 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.3 | 96.6 | 0.032 | 3.14 | 4.53 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.4 | 117.7 | 0.033 | 4.33 | 4.00 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.8 | 271.2 | 0.269 | 8.80 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 48.1 | 211.7 | 0.041 | 7.08 | 4.40 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 82.3 | 331.7 | 0.090 | 12.11 | 4.03 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 84777.1 | 280780.2 | 716.227 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84711.8 | 280730.2 | 713.289 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84683.9 | 280758.2 | 712.268 | 0.49 | 3.32 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 4091213.1 | 20167466.2 | 2948.804 | 23.71 | 4.93 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 83526.6 | 274401.2 | 670.990 | 0.48 | 3.29 |
| string: silesia/dickens | 1 | 172528 | simdjson | 207255.1 | 674008.2 | 2052.052 | 1.20 | 3.25 |
| string: silesia/dickens | 1 | 172528 | yyjson | 210569.9 | 848559.2 | 1368.825 | 1.22 | 4.03 |
| string: silesia/dickens | 1 | 172528 | std.json | 1355577.5 | 2890892.2 | 51347.814 | 7.86 | 2.13 |
| string: silesia/dickens | 1 | 172528 | serde_json | 370778.8 | 1586249.2 | 2263.278 | 2.15 | 4.28 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 578010.9 | 2970296.1 | 2344.134 | 3.35 | 5.14 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1280648.3 | 3582346.6 | 11913.429 | 1.08 | 2.80 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1269459.2 | 3582290.6 | 11522.357 | 1.07 | 2.82 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1268254.6 | 3582318.6 | 11490.571 | 1.07 | 2.82 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 30116383.6 | 134936069.6 | 139384.429 | 25.30 | 4.48 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1223287.2 | 3370022.6 | 10930.286 | 1.03 | 2.75 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2973462.6 | 10460754.6 | 29221.857 | 2.50 | 3.52 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2417711.6 | 11226214.6 | 9589.929 | 2.03 | 4.64 |
| string: http/json-1m | 1 | 1190272 | std.json | 9048312.4 | 43287986.6 | 16364.429 | 7.60 | 4.78 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4207110.9 | 17941088.6 | 10981.286 | 3.53 | 4.26 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5244447.3 | 26999673.6 | 11472.214 | 4.41 | 5.15 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2072611.8 | 6088095.8 | 4712.125 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2063470.6 | 6088039.8 | 4192.500 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2067575.5 | 6088067.8 | 4127.875 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 52567571.6 | 238556376.8 | 260328.250 | 27.92 | 4.54 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2077151.1 | 5875346.8 | 4816.750 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2724386.1 | 7144135.8 | 21012.000 | 1.45 | 2.62 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 11856516.6 | 26334410.8 | 429767.500 | 6.30 | 2.22 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20372252.1 | 56837736.8 | 524960.125 | 10.82 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11669092.0 | 33662338.8 | 306490.000 | 6.20 | 2.88 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18881682.0 | 76319355.0 | 255088.625 | 10.03 | 4.04 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113738.6 | 426373.7 | 7.194 | 0.22 | 3.75 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113662.3 | 426318.7 | 5.613 | 0.22 | 3.75 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113631.9 | 426335.7 | 2.323 | 0.22 | 3.75 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 636714.1 | 3146562.7 | 5.613 | 1.21 | 4.94 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113565.6 | 426343.7 | 2.258 | 0.22 | 3.75 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1239741.8 | 3866907.7 | 4.645 | 2.36 | 3.12 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1664502.5 | 5833344.7 | 4.871 | 3.17 | 3.50 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3618849.6 | 13108830.7 | 73974.871 | 6.90 | 3.62 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1824439.7 | 7405810.7 | 4.581 | 3.48 | 4.06 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2390274.8 | 12748307.2 | 17.194 | 4.56 | 5.33 |
