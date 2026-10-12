# bench-profile

| Field | Value |
|---|---|
| Commit | 45efabd |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260927.135.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/37250186969 |
| Date | 2026-10-05 |

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
| silesia/dickens | 10192446 | zlib | 7.89 | 15.77 | 2.00 | 298.20 |
| silesia/dickens | 10192446 | zlib-ng | 4.86 | 10.50 | 2.16 | 68.91 |
| silesia/dickens | 10192446 | libdeflate | 3.46 | 9.56 | 2.76 | 66.61 |
| silesia/dickens | 10192446 | Wuffs | 4.87 | 10.85 | 2.23 | 97.17 |
| silesia/dickens | 10192446 | stdx | 2.92 | 7.16 | 2.45 | 76.21 |
| silesia/mozilla | 51220480 | zlib | 7.71 | 14.13 | 1.83 | 242.00 |
| silesia/mozilla | 51220480 | zlib-ng | 4.95 | 8.95 | 1.81 | 85.81 |
| silesia/mozilla | 51220480 | libdeflate | 3.47 | 7.63 | 2.20 | 71.23 |
| silesia/mozilla | 51220480 | Wuffs | 5.72 | 10.84 | 1.89 | 132.76 |
| silesia/mozilla | 51220480 | stdx | 3.64 | 6.29 | 1.73 | 88.99 |
| silesia/mr | 9970564 | zlib | 7.62 | 15.26 | 2.00 | 193.33 |
| silesia/mr | 9970564 | zlib-ng | 4.80 | 9.98 | 2.08 | 68.41 |
| silesia/mr | 9970564 | libdeflate | 3.36 | 8.58 | 2.55 | 61.80 |
| silesia/mr | 9970564 | Wuffs | 5.28 | 10.93 | 2.07 | 101.61 |
| silesia/mr | 9970564 | stdx | 3.10 | 6.71 | 2.17 | 69.70 |
| silesia/nci | 33553445 | zlib | 2.91 | 7.25 | 2.49 | 78.59 |
| silesia/nci | 33553445 | zlib-ng | 1.60 | 3.13 | 1.96 | 33.88 |
| silesia/nci | 33553445 | libdeflate | 1.15 | 2.66 | 2.31 | 29.81 |
| silesia/nci | 33553445 | Wuffs | 1.71 | 3.38 | 1.98 | 42.42 |
| silesia/nci | 33553445 | stdx | 1.21 | 2.21 | 1.83 | 38.03 |
| silesia/ooffice | 6152192 | zlib | 10.90 | 17.83 | 1.63 | 399.38 |
| silesia/ooffice | 6152192 | zlib-ng | 6.94 | 12.04 | 1.74 | 141.89 |
| silesia/ooffice | 6152192 | libdeflate | 4.90 | 10.45 | 2.13 | 125.15 |
| silesia/ooffice | 6152192 | Wuffs | 8.11 | 14.47 | 1.78 | 220.89 |
| silesia/ooffice | 6152192 | stdx | 5.07 | 8.56 | 1.69 | 150.23 |
| silesia/osdb | 10085684 | zlib | 6.73 | 13.54 | 2.01 | 168.04 |
| silesia/osdb | 10085684 | zlib-ng | 4.30 | 8.38 | 1.95 | 53.44 |
| silesia/osdb | 10085684 | libdeflate | 2.85 | 6.91 | 2.42 | 30.02 |
| silesia/osdb | 10085684 | Wuffs | 5.13 | 10.56 | 2.06 | 79.59 |
| silesia/osdb | 10085684 | stdx | 2.78 | 5.66 | 2.04 | 41.05 |
| silesia/reymont | 6627202 | zlib | 6.57 | 12.73 | 1.94 | 251.21 |
| silesia/reymont | 6627202 | zlib-ng | 3.69 | 7.72 | 2.09 | 60.38 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.29 |
| silesia/reymont | 6627202 | Wuffs | 4.23 | 8.40 | 1.99 | 112.07 |
| silesia/reymont | 6627202 | stdx | 2.28 | 5.12 | 2.24 | 64.73 |
| silesia/samba | 21606400 | zlib | 5.46 | 11.09 | 2.03 | 169.22 |
| silesia/samba | 21606400 | zlib-ng | 3.37 | 6.47 | 1.92 | 56.06 |
| silesia/samba | 21606400 | libdeflate | 2.34 | 5.58 | 2.39 | 43.01 |
| silesia/samba | 21606400 | Wuffs | 3.69 | 7.33 | 1.98 | 81.53 |
| silesia/samba | 21606400 | stdx | 2.31 | 4.47 | 1.93 | 56.39 |
| silesia/sao | 7251944 | zlib | 9.85 | 20.36 | 2.07 | 195.32 |
| silesia/sao | 7251944 | zlib-ng | 7.88 | 14.83 | 1.88 | 80.60 |
| silesia/sao | 7251944 | libdeflate | 5.74 | 12.73 | 2.22 | 79.34 |
| silesia/sao | 7251944 | Wuffs | 8.14 | 18.14 | 2.23 | 85.39 |
| silesia/sao | 7251944 | stdx | 5.58 | 10.33 | 1.85 | 86.73 |
| silesia/webster | 41458703 | zlib | 6.97 | 12.99 | 1.86 | 271.78 |
| silesia/webster | 41458703 | zlib-ng | 4.23 | 8.04 | 1.90 | 85.73 |
| silesia/webster | 41458703 | libdeflate | 2.95 | 7.17 | 2.43 | 68.62 |
| silesia/webster | 41458703 | Wuffs | 4.53 | 8.62 | 1.90 | 123.51 |
| silesia/webster | 41458703 | stdx | 2.84 | 5.57 | 1.96 | 87.07 |
| silesia/x-ray | 8474240 | zlib | 12.18 | 23.82 | 1.96 | 323.66 |
| silesia/x-ray | 8474240 | zlib-ng | 9.05 | 17.39 | 1.92 | 125.38 |
| silesia/x-ray | 8474240 | libdeflate | 6.53 | 15.26 | 2.33 | 124.89 |
| silesia/x-ray | 8474240 | Wuffs | 10.15 | 20.40 | 2.01 | 198.17 |
| silesia/x-ray | 8474240 | stdx | 6.11 | 11.50 | 1.88 | 136.89 |
| silesia/xml | 5345280 | zlib | 3.59 | 8.20 | 2.29 | 115.03 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 43.01 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.44 | 32.00 |
| silesia/xml | 5345280 | Wuffs | 2.19 | 4.14 | 1.89 | 61.03 |
| silesia/xml | 5345280 | stdx | 1.33 | 2.66 | 2.00 | 41.77 |
| canterbury/alice29.txt | 152089 | zlib | 7.54 | 15.08 | 2.00 | 282.72 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.50 | 9.91 | 2.20 | 60.11 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.19 | 8.96 | 2.81 | 55.71 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.70 | 10.37 | 2.20 | 97.41 |
| canterbury/alice29.txt | 152089 | stdx | 2.74 | 7.07 | 2.58 | 63.43 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.09 | 16.11 | 1.99 | 301.36 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 74.15 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.60 | 9.82 | 2.73 | 68.16 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.08 | 11.34 | 2.23 | 99.74 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.07 | 7.61 | 2.48 | 75.79 |
| canterbury/cp.html | 24603 | zlib | 6.43 | 14.20 | 2.21 | 168.37 |
| canterbury/cp.html | 24603 | zlib-ng | 4.20 | 9.50 | 2.26 | 39.29 |
| canterbury/cp.html | 24603 | libdeflate | 2.76 | 7.95 | 2.88 | 8.85 |
| canterbury/cp.html | 24603 | Wuffs | 4.39 | 10.87 | 2.47 | 49.91 |
| canterbury/cp.html | 24603 | stdx | 2.73 | 7.55 | 2.76 | 12.53 |
| canterbury/fields.c | 11150 | zlib | 4.40 | 14.65 | 3.33 | 25.30 |
| canterbury/fields.c | 11150 | zlib-ng | 3.93 | 10.20 | 2.59 | 18.55 |
| canterbury/fields.c | 11150 | libdeflate | 2.80 | 8.32 | 2.97 | 2.18 |
| canterbury/fields.c | 11150 | Wuffs | 3.85 | 11.51 | 2.99 | 10.71 |
| canterbury/fields.c | 11150 | stdx | 2.61 | 8.13 | 3.11 | 4.12 |
| canterbury/grammar.lsp | 3721 | zlib | 6.06 | 21.22 | 3.50 | 2.83 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.84 | 17.48 | 2.99 | 8.17 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.40 | 12.05 | 2.74 | 0.44 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.98 | 18.87 | 3.16 | 3.98 |
| canterbury/grammar.lsp | 3721 | stdx | 3.94 | 13.05 | 3.32 | 1.37 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.93 | 12.20 | 3.10 | 47.57 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.85 | 6.97 | 2.45 | 12.64 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.62 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.20 | 8.67 | 2.71 | 14.87 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.67 | 2.66 | 16.47 |
| canterbury/lcet10.txt | 426754 | zlib | 7.31 | 14.53 | 1.99 | 277.90 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 61.40 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.33 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.56 | 9.85 | 2.16 | 100.44 |
| canterbury/lcet10.txt | 426754 | stdx | 2.60 | 6.45 | 2.48 | 66.87 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.25 | 16.53 | 2.00 | 308.41 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.25 | 11.19 | 2.13 | 77.35 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.70 | 77.62 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.15 | 11.53 | 2.24 | 99.77 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.15 | 7.67 | 2.43 | 84.94 |
| canterbury/ptt5 | 513216 | zlib | 4.38 | 7.79 | 1.78 | 99.41 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.00 | 3.74 | 1.87 | 47.10 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.09 | 38.12 |
| canterbury/ptt5 | 513216 | Wuffs | 2.19 | 4.02 | 1.84 | 58.49 |
| canterbury/ptt5 | 513216 | stdx | 1.46 | 2.57 | 1.76 | 48.97 |
| canterbury/sum | 38240 | zlib | 7.19 | 14.98 | 2.08 | 212.82 |
| canterbury/sum | 38240 | zlib-ng | 4.66 | 10.02 | 2.15 | 58.02 |
| canterbury/sum | 38240 | libdeflate | 3.19 | 8.34 | 2.61 | 24.13 |
| canterbury/sum | 38240 | Wuffs | 5.00 | 11.41 | 2.28 | 76.87 |
| canterbury/sum | 38240 | stdx | 3.12 | 8.02 | 2.57 | 30.65 |
| canterbury/xargs.1 | 4227 | zlib | 6.53 | 22.08 | 3.38 | 6.84 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.55 | 17.97 | 2.74 | 15.76 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.75 | 13.27 | 2.79 | 0.55 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.53 | 19.63 | 3.01 | 11.97 |
| canterbury/xargs.1 | 4227 | stdx | 4.34 | 13.70 | 3.15 | 2.63 |
| canterbury-large/E.coli | 4638690 | zlib | 5.91 | 14.55 | 2.46 | 174.32 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.19 | 9.68 | 2.31 | 47.81 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.30 |
| canterbury-large/E.coli | 4638690 | Wuffs | 3.98 | 9.64 | 2.42 | 61.57 |
| canterbury-large/E.coli | 4638690 | stdx | 2.47 | 6.74 | 2.72 | 53.93 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.67 | 13.26 | 1.99 | 256.89 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.76 | 8.26 | 2.19 | 54.47 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.84 | 45.43 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.15 | 8.72 | 2.10 | 100.61 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.24 | 5.58 | 2.50 | 55.76 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.89 | 12.69 | 1.84 | 269.84 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.18 | 7.78 | 1.86 | 91.80 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.01 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.52 | 8.44 | 1.87 | 130.08 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 5.41 | 1.99 | 90.85 |
| http/html-1kx1024 | 1048576 | zlib | 15.27 | 32.44 | 2.13 | 348.76 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.67 | 28.43 | 2.24 | 220.34 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.54 | 20.05 | 1.90 | 157.97 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.61 | 35.05 | 2.40 | 260.25 |
| http/html-1kx1024 | 1048576 | stdx | 9.01 | 23.39 | 2.59 | 157.78 |
| http/html-16kx64 | 1048576 | zlib | 5.94 | 11.79 | 1.99 | 212.33 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.84 | 7.54 | 1.96 | 85.37 |
| http/html-16kx64 | 1048576 | libdeflate | 2.64 | 6.04 | 2.29 | 60.98 |
| http/html-16kx64 | 1048576 | Wuffs | 4.27 | 8.51 | 1.99 | 117.03 |
| http/html-16kx64 | 1048576 | stdx | 2.62 | 5.96 | 2.27 | 60.31 |
| http/html-1m | 1048576 | zlib | 4.61 | 9.51 | 2.06 | 170.43 |
| http/html-1m | 1048576 | zlib-ng | 2.61 | 5.03 | 1.93 | 60.15 |
| http/html-1m | 1048576 | libdeflate | 1.69 | 4.39 | 2.59 | 37.37 |
| http/html-1m | 1048576 | Wuffs | 2.97 | 5.42 | 1.82 | 90.99 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.47 | 2.11 | 52.53 |
| http/json-1kx1024 | 1048576 | zlib | 9.23 | 20.83 | 2.26 | 191.83 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.26 | 132.37 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.80 | 16.72 | 1.90 | 93.99 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.42 | 31.72 | 2.78 | 143.30 |
| http/json-1kx1024 | 1048576 | stdx | 5.50 | 15.44 | 2.81 | 87.13 |
| http/json-16kx64 | 1048576 | zlib | 3.90 | 9.62 | 2.47 | 101.18 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.73 |
| http/json-16kx64 | 1048576 | libdeflate | 1.92 | 4.24 | 2.21 | 40.80 |
| http/json-16kx64 | 1048576 | Wuffs | 2.81 | 6.35 | 2.26 | 58.12 |
| http/json-16kx64 | 1048576 | stdx | 1.85 | 4.34 | 2.34 | 39.77 |
| http/json-1m | 1048576 | zlib | 3.22 | 8.25 | 2.56 | 81.07 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.02 | 37.52 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.85 |
| http/json-1m | 1048576 | Wuffs | 2.04 | 4.29 | 2.10 | 44.42 |
| http/json-1m | 1048576 | stdx | 1.33 | 2.68 | 2.01 | 40.24 |
| http/js-1kx1024 | 1048576 | zlib | 16.72 | 35.33 | 2.11 | 401.35 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.75 | 31.25 | 2.27 | 241.33 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.22 | 21.58 | 1.92 | 181.11 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.80 | 37.71 | 2.39 | 293.45 |
| http/js-1kx1024 | 1048576 | stdx | 9.98 | 25.38 | 2.54 | 187.11 |
| http/js-16kx64 | 1048576 | zlib | 6.83 | 13.06 | 1.91 | 252.92 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.37 | 8.65 | 1.98 | 92.14 |
| http/js-16kx64 | 1048576 | libdeflate | 3.06 | 7.01 | 2.29 | 72.34 |
| http/js-16kx64 | 1048576 | Wuffs | 4.84 | 9.70 | 2.00 | 130.05 |
| http/js-16kx64 | 1048576 | stdx | 3.13 | 6.93 | 2.21 | 74.23 |
| http/js-1m | 1048576 | zlib | 5.12 | 10.26 | 2.00 | 194.10 |
| http/js-1m | 1048576 | zlib-ng | 2.87 | 5.66 | 1.97 | 60.44 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.74 |
| http/js-1m | 1048576 | Wuffs | 3.26 | 6.10 | 1.87 | 96.13 |
| http/js-1m | 1048576 | stdx | 1.81 | 3.91 | 2.16 | 55.31 |
| http/css-1kx1024 | 1048576 | zlib | 12.63 | 27.18 | 2.15 | 281.10 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.19 | 23.04 | 2.26 | 171.85 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.13 | 17.37 | 1.90 | 123.08 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.04 | 29.48 | 2.45 | 204.49 |
| http/css-1kx1024 | 1048576 | stdx | 7.28 | 20.21 | 2.78 | 115.43 |
| http/css-16kx64 | 1048576 | zlib | 4.61 | 10.12 | 2.20 | 149.84 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.77 | 6.07 | 2.19 | 50.61 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 30.06 |
| http/css-16kx64 | 1048576 | Wuffs | 3.12 | 6.97 | 2.24 | 70.13 |
| http/css-16kx64 | 1048576 | stdx | 1.83 | 4.75 | 2.60 | 28.93 |
| http/css-1m | 1048576 | zlib | 3.35 | 8.00 | 2.39 | 105.29 |
| http/css-1m | 1048576 | zlib-ng | 1.68 | 3.75 | 2.23 | 28.93 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.96 | 13.32 |
| http/css-1m | 1048576 | Wuffs | 1.91 | 4.08 | 2.14 | 44.76 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.57 | 2.54 | 21.36 |
| shuffled/dickens-1m | 1048576 | zlib | 12.58 | 22.42 | 1.78 | 372.63 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.72 | 16.72 | 1.72 | 199.56 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.04 | 14.95 | 2.12 | 195.39 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.71 | 18.95 | 1.95 | 204.20 |
| shuffled/dickens-1m | 1048576 | stdx | 7.04 | 11.92 | 1.69 | 205.35 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.54 | 14.04 | 3.96 | 3.48 |
| silesia/dickens | 10192446 | stdx | 3.65 | 12.47 | 3.41 | 3.69 |
| silesia/mozilla | 51220480 | libzstd | 2.86 | 9.62 | 3.36 | 31.49 |
| silesia/mozilla | 51220480 | stdx | 2.84 | 9.68 | 3.41 | 15.41 |
| silesia/mr | 9970564 | libzstd | 3.02 | 11.98 | 3.96 | 6.27 |
| silesia/mr | 9970564 | stdx | 3.02 | 10.83 | 3.59 | 5.23 |
| silesia/nci | 33553445 | libzstd | 1.60 | 4.84 | 3.03 | 24.32 |
| silesia/nci | 33553445 | stdx | 1.60 | 4.63 | 2.89 | 13.53 |
| silesia/ooffice | 6152192 | libzstd | 3.44 | 12.14 | 3.53 | 32.88 |
| silesia/ooffice | 6152192 | stdx | 3.33 | 12.40 | 3.73 | 12.06 |
| silesia/osdb | 10085684 | libzstd | 2.35 | 8.44 | 3.59 | 15.58 |
| silesia/osdb | 10085684 | stdx | 2.38 | 8.11 | 3.40 | 15.52 |
| silesia/reymont | 6627202 | libzstd | 3.20 | 11.61 | 3.63 | 11.84 |
| silesia/reymont | 6627202 | stdx | 3.30 | 10.36 | 3.13 | 12.83 |
| silesia/samba | 21606400 | libzstd | 2.05 | 7.39 | 3.61 | 19.00 |
| silesia/samba | 21606400 | stdx | 2.08 | 6.83 | 3.28 | 17.46 |
| silesia/sao | 7251944 | libzstd | 3.81 | 12.69 | 3.33 | 27.30 |
| silesia/sao | 7251944 | stdx | 3.47 | 12.58 | 3.63 | 6.16 |
| silesia/webster | 41458703 | libzstd | 3.10 | 11.22 | 3.62 | 16.22 |
| silesia/webster | 41458703 | stdx | 3.24 | 10.05 | 3.10 | 17.34 |
| silesia/x-ray | 8474240 | libzstd | 3.95 | 14.93 | 3.77 | 18.94 |
| silesia/x-ray | 8474240 | stdx | 3.54 | 13.23 | 3.74 | 8.49 |
| silesia/xml | 5345280 | libzstd | 1.54 | 5.55 | 3.61 | 23.35 |
| silesia/xml | 5345280 | stdx | 1.51 | 5.16 | 3.42 | 17.03 |
| canterbury/alice29.txt | 152089 | libzstd | 3.39 | 16.18 | 4.78 | 4.25 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.37 | 0.45 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.03 | 14.25 | 4.70 | 3.32 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.29 | 0.29 |
| canterbury/cp.html | 24603 | libzstd | 2.72 | 10.74 | 3.94 | 11.62 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.11 | 0.26 |
| canterbury/fields.c | 11150 | libzstd | 3.19 | 13.61 | 4.27 | 12.22 |
| canterbury/fields.c | 11150 | stdx | 3.00 | 12.72 | 4.24 | 0.09 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.33 | 16.93 | 3.91 | 11.46 |
| canterbury/grammar.lsp | 3721 | stdx | 4.13 | 16.53 | 4.01 | 0.17 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.52 | 11.22 | 4.46 | 8.05 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.66 | 11.32 | 4.26 | 0.86 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.76 | 12.87 | 4.67 | 5.43 |
| canterbury/lcet10.txt | 426754 | stdx | 2.74 | 11.52 | 4.21 | 4.28 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.20 | 15.14 | 4.73 | 1.57 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.28 | 0.72 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.50 | 3.11 | 24.10 |
| canterbury/ptt5 | 513216 | stdx | 1.33 | 4.46 | 3.36 | 13.56 |
| canterbury/sum | 38240 | libzstd | 2.76 | 10.51 | 3.81 | 17.81 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.26 |
| canterbury/xargs.1 | 4227 | libzstd | 4.35 | 17.40 | 4.00 | 13.34 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.16 | 4.05 | 0.16 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.04 | 13.63 | 4.48 | 2.21 |
| canterbury-large/E.coli | 4638690 | stdx | 3.07 | 12.04 | 3.92 | 2.95 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.96 | 11.99 | 4.05 | 8.54 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.03 | 10.64 | 3.51 | 9.26 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.53 | 9.59 | 3.79 | 19.96 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.59 | 8.64 | 3.33 | 21.26 |
| http/html-1kx1024 | 1048576 | libzstd | 7.41 | 21.63 | 2.92 | 62.69 |
| http/html-1kx1024 | 1048576 | stdx | 7.44 | 22.43 | 3.02 | 76.00 |
| http/html-16kx64 | 1048576 | libzstd | 2.68 | 10.15 | 3.78 | 28.94 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 9.61 | 3.62 | 29.74 |
| http/html-1m | 1048576 | libzstd | 2.01 | 7.86 | 3.92 | 24.47 |
| http/html-1m | 1048576 | stdx | 1.99 | 7.12 | 3.58 | 24.73 |
| http/json-1kx1024 | 1048576 | libzstd | 6.39 | 17.37 | 2.72 | 49.71 |
| http/json-1kx1024 | 1048576 | stdx | 6.20 | 17.84 | 2.88 | 53.38 |
| http/json-16kx64 | 1048576 | libzstd | 2.07 | 7.22 | 3.49 | 28.71 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.59 | 19.63 |
| http/json-1m | 1048576 | libzstd | 1.75 | 6.04 | 3.46 | 28.70 |
| http/json-1m | 1048576 | stdx | 1.62 | 5.91 | 3.64 | 13.98 |
| http/js-1kx1024 | 1048576 | libzstd | 8.46 | 26.38 | 3.12 | 73.47 |
| http/js-1kx1024 | 1048576 | stdx | 9.02 | 27.57 | 3.06 | 112.51 |
| http/js-16kx64 | 1048576 | libzstd | 2.96 | 11.71 | 3.96 | 25.04 |
| http/js-16kx64 | 1048576 | stdx | 2.95 | 11.06 | 3.75 | 25.46 |
| http/js-1m | 1048576 | libzstd | 2.03 | 8.18 | 4.03 | 20.78 |
| http/js-1m | 1048576 | stdx | 2.06 | 7.48 | 3.63 | 21.58 |
| http/css-1kx1024 | 1048576 | libzstd | 7.11 | 19.70 | 2.77 | 58.08 |
| http/css-1kx1024 | 1048576 | stdx | 6.82 | 19.93 | 2.92 | 63.14 |
| http/css-16kx64 | 1048576 | libzstd | 2.32 | 8.69 | 3.75 | 28.04 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.09 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.57 | 3.84 | 5.93 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.54 | 4.16 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.81 | 9.40 | 3.35 | 28.76 |
| shuffled/dickens-1m | 1048576 | stdx | 2.72 | 9.19 | 3.37 | 12.39 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.57 | 17.04 | 2.25 | 101.76 |
| silesia/dickens | 1048576 | stdx | 5.10 | 12.38 | 2.43 | 54.57 |
| silesia/mozilla | 1048576 | Google | 14.61 | 27.77 | 1.90 | 136.93 |
| silesia/mozilla | 1048576 | stdx | 8.32 | 15.02 | 1.81 | 48.01 |
| silesia/mr | 1048576 | Google | 8.94 | 20.24 | 2.27 | 103.56 |
| silesia/mr | 1048576 | stdx | 5.79 | 13.25 | 2.29 | 88.46 |
| silesia/nci | 1048576 | Google | 2.55 | 5.69 | 2.23 | 51.01 |
| silesia/nci | 1048576 | stdx | 1.94 | 3.95 | 2.03 | 55.24 |
| silesia/ooffice | 1048576 | Google | 14.26 | 29.28 | 2.05 | 290.45 |
| silesia/ooffice | 1048576 | stdx | 10.88 | 20.33 | 1.87 | 323.33 |
| silesia/osdb | 1048576 | Google | 8.31 | 17.38 | 2.09 | 102.66 |
| silesia/osdb | 1048576 | stdx | 5.15 | 10.57 | 2.05 | 92.16 |
| silesia/reymont | 1048576 | Google | 5.45 | 12.73 | 2.33 | 81.91 |
| silesia/reymont | 1048576 | stdx | 3.73 | 9.25 | 2.48 | 47.72 |
| silesia/samba | 1048576 | Google | 7.86 | 16.22 | 2.06 | 118.23 |
| silesia/samba | 1048576 | stdx | 5.07 | 10.71 | 2.11 | 66.87 |
| silesia/sao | 1048576 | Google | 16.97 | 36.97 | 2.18 | 174.38 |
| silesia/sao | 1048576 | stdx | 10.41 | 22.65 | 2.18 | 141.73 |
| silesia/webster | 1048576 | Google | 6.59 | 14.07 | 2.13 | 116.24 |
| silesia/webster | 1048576 | stdx | 4.40 | 9.98 | 2.27 | 69.11 |
| silesia/x-ray | 1048576 | Google | 19.44 | 38.46 | 1.98 | 241.10 |
| silesia/x-ray | 1048576 | stdx | 14.51 | 30.18 | 2.08 | 234.82 |
| silesia/xml | 1048576 | Google | 3.48 | 7.65 | 2.20 | 66.10 |
| silesia/xml | 1048576 | stdx | 2.40 | 5.40 | 2.25 | 46.93 |
| canterbury/alice29.txt | 152089 | Google | 8.93 | 20.66 | 2.31 | 137.67 |
| canterbury/alice29.txt | 152089 | stdx | 6.09 | 15.33 | 2.52 | 81.35 |
| canterbury/asyoulik.txt | 125179 | Google | 10.48 | 23.83 | 2.27 | 173.29 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.07 | 17.43 | 2.46 | 105.13 |
| canterbury/cp.html | 24603 | Google | 9.19 | 22.18 | 2.41 | 116.50 |
| canterbury/cp.html | 24603 | stdx | 5.81 | 17.15 | 2.95 | 35.63 |
| canterbury/fields.c | 11150 | Google | 7.10 | 21.25 | 2.99 | 24.70 |
| canterbury/fields.c | 11150 | stdx | 4.90 | 17.08 | 3.49 | 2.74 |
| canterbury/grammar.lsp | 3721 | Google | 9.84 | 30.23 | 3.07 | 6.89 |
| canterbury/grammar.lsp | 3721 | stdx | 7.15 | 25.04 | 3.50 | 1.04 |
| canterbury/kennedy.xls | 1029744 | Google | 5.47 | 17.05 | 3.12 | 36.94 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.81 | 12.94 | 3.40 | 34.09 |
| canterbury/lcet10.txt | 426754 | Google | 7.77 | 17.42 | 2.24 | 131.48 |
| canterbury/lcet10.txt | 426754 | stdx | 5.18 | 12.96 | 2.50 | 66.28 |
| canterbury/plrabn12.txt | 481861 | Google | 9.14 | 20.94 | 2.29 | 135.49 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.14 | 15.04 | 2.45 | 87.13 |
| canterbury/ptt5 | 513216 | Google | 4.31 | 10.36 | 2.41 | 63.52 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.07 | 65.50 |
| canterbury/sum | 38240 | Google | 10.92 | 26.44 | 2.42 | 158.94 |
| canterbury/sum | 38240 | stdx | 8.27 | 21.11 | 2.55 | 150.94 |
| canterbury/xargs.1 | 4227 | Google | 11.02 | 34.81 | 3.16 | 13.25 |
| canterbury/xargs.1 | 4227 | stdx | 8.49 | 30.44 | 3.58 | 6.98 |
| canterbury-large/E.coli | 1048576 | Google | 7.47 | 19.44 | 2.60 | 1.37 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.71 |
| canterbury-large/bible.txt | 1048576 | Google | 5.37 | 12.38 | 2.31 | 81.34 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.55 | 8.93 | 2.52 | 39.95 |
| canterbury-large/world192.txt | 1048576 | Google | 6.26 | 12.88 | 2.06 | 116.81 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.41 | 9.38 | 2.13 | 76.99 |
| http/html-1kx1024 | 1048576 | Google | 17.96 | 42.09 | 2.34 | 389.23 |
| http/html-1kx1024 | 1048576 | stdx | 15.31 | 37.56 | 2.45 | 362.42 |
| http/html-16kx64 | 1048576 | Google | 6.77 | 14.88 | 2.20 | 150.97 |
| http/html-16kx64 | 1048576 | stdx | 5.14 | 12.15 | 2.37 | 114.23 |
| http/html-1m | 1048576 | Google | 4.07 | 8.99 | 2.21 | 83.66 |
| http/html-1m | 1048576 | stdx | 2.86 | 6.52 | 2.28 | 54.82 |
| http/json-1kx1024 | 1048576 | Google | 14.31 | 36.74 | 2.57 | 239.60 |
| http/json-1kx1024 | 1048576 | stdx | 13.02 | 33.63 | 2.58 | 277.07 |
| http/json-16kx64 | 1048576 | Google | 4.42 | 11.42 | 2.58 | 81.25 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.37 |
| http/json-1m | 1048576 | Google | 3.42 | 8.66 | 2.53 | 58.89 |
| http/json-1m | 1048576 | stdx | 2.47 | 5.99 | 2.43 | 57.90 |
| http/js-1kx1024 | 1048576 | Google | 19.85 | 46.38 | 2.34 | 428.04 |
| http/js-1kx1024 | 1048576 | stdx | 16.41 | 39.90 | 2.43 | 382.06 |
| http/js-16kx64 | 1048576 | Google | 8.07 | 17.79 | 2.20 | 169.18 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.38 |
| http/js-1m | 1048576 | Google | 4.38 | 9.60 | 2.19 | 83.59 |
| http/js-1m | 1048576 | stdx | 3.16 | 7.25 | 2.29 | 55.11 |
| http/css-1kx1024 | 1048576 | Google | 15.36 | 37.48 | 2.44 | 293.64 |
| http/css-1kx1024 | 1048576 | stdx | 13.83 | 34.70 | 2.51 | 302.15 |
| http/css-16kx64 | 1048576 | Google | 4.96 | 11.78 | 2.38 | 100.94 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.49 | 80.62 |
| http/css-1m | 1048576 | Google | 2.43 | 9.43 | 3.88 | 16.78 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.46 | 12.15 |
| shuffled/dickens-1m | 1048576 | Google | 9.62 | 20.34 | 2.12 | 106.53 |
| shuffled/dickens-1m | 1048576 | stdx | 8.74 | 14.53 | 1.66 | 114.18 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.3 | 0.118 | 3.01 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 69.1 | 238.3 | 0.104 | 8.16 | 3.45 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 261.1 | 1119.2 | 0.811 | 30.84 | 4.29 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 31.3 | 109.0 | 0.100 | 3.70 | 3.48 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.1 | 107.1 | 0.298 | 3.32 | 3.81 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.4 | 378.2 | 0.383 | 11.26 | 3.97 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 26.8 | 89.6 | 0.004 | 3.94 | 3.34 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 69.6 | 249.9 | 0.042 | 10.25 | 3.59 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 222.1 | 880.2 | 0.914 | 32.69 | 3.96 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 29.7 | 108.7 | 0.029 | 4.37 | 3.66 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.1 | 106.7 | 0.049 | 4.13 | 3.80 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 93.4 | 345.9 | 0.334 | 13.74 | 3.70 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114885.3 | 403839.2 | 519.907 | 0.67 | 3.52 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 616482.6 | 2684141.2 | 1355.711 | 3.57 | 4.35 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3883155.4 | 20639255.2 | 2976.299 | 22.51 | 5.32 |
| string: silesia/dickens | 1 | 172528 | simdjson | 329389.8 | 656791.2 | 505.196 | 1.91 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 230244.5 | 848188.2 | 2594.021 | 1.33 | 3.68 |
| string: silesia/dickens | 1 | 172528 | std.json | 1583040.4 | 4595563.2 | 44729.165 | 9.18 | 2.90 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1563995.7 | 4799762.6 | 1395.357 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 15024326.9 | 60619385.6 | 57909.143 | 12.62 | 4.03 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 31697195.6 | 148769682.6 | 157923.071 | 26.63 | 4.69 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4729359.4 | 7294566.6 | 568.786 | 3.97 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1782042.9 | 7470807.6 | 14504.429 | 1.50 | 4.19 |
| string: http/json-1m | 1 | 1190272 | std.json | 10144850.1 | 47253785.6 | 32249.000 | 8.52 | 4.66 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2066155.8 | 5765412.8 | 4282.250 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6493572.5 | 24133030.8 | 12593.000 | 3.45 | 3.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 51940826.0 | 252608919.8 | 293415.750 | 27.58 | 4.86 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3798178.3 | 8269494.8 | 2033.625 | 2.02 | 2.18 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7167489.0 | 12512113.8 | 279827.250 | 3.81 | 1.75 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17520795.9 | 63922930.8 | 225382.625 | 9.30 | 3.65 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12881389.7 | 42561068.3 | 244112.667 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 161140336.7 | 732363048.3 | 388565.333 | 31.75 | 4.54 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 163779774.0 | 708654908.3 | 420933.000 | 32.27 | 4.33 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 27640300.7 | 63138667.3 | 18196.667 | 5.45 | 2.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 13970654.0 | 45451415.3 | 451501.000 | 2.75 | 3.25 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79168040.7 | 314355510.3 | 452993.333 | 15.60 | 3.97 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 189839.0 | 688807.7 | 5.387 | 0.36 | 3.63 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 190647.5 | 689029.7 | 8.484 | 0.36 | 3.61 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 11165461.1 | 60818249.7 | 8.097 | 21.30 | 5.45 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 552901.4 | 1483247.7 | 3.806 | 1.05 | 2.68 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 542292.6 | 2261447.7 | 8.419 | 1.03 | 4.17 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3356816.1 | 12808414.7 | 60621.581 | 6.40 | 3.82 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 27.0 | 113.7 | 0.156 | 3.19 | 4.21 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 73.4 | 342.1 | 0.196 | 8.67 | 4.66 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 222.4 | 1092.4 | 0.855 | 26.27 | 4.91 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 23.7 | 101.9 | 0.155 | 2.80 | 4.30 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 25.0 | 102.1 | 0.191 | 2.95 | 4.09 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.1 | 105.4 | 0.249 | 3.20 | 3.89 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 68.5 | 310.3 | 0.376 | 8.09 | 4.53 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 24.8 | 110.3 | 0.037 | 3.65 | 4.44 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 69.0 | 324.0 | 0.072 | 10.15 | 4.70 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 171.4 | 790.0 | 1.170 | 25.23 | 4.61 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 22.0 | 100.3 | 0.039 | 3.24 | 4.55 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 22.3 | 100.1 | 0.036 | 3.28 | 4.49 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.2 | 117.7 | 0.033 | 4.14 | 4.18 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.4 | 270.9 | 0.282 | 8.74 | 4.56 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 120847.3 | 464395.2 | 459.742 | 0.70 | 3.84 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 517249.2 | 2182153.2 | 1209.608 | 3.00 | 4.22 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3406875.8 | 18380954.2 | 2948.495 | 19.75 | 5.40 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 125468.2 | 460562.2 | 736.897 | 0.73 | 3.67 |
| string: silesia/dickens | 1 | 172528 | simdjson | 212878.2 | 687839.2 | 1141.041 | 1.23 | 3.23 |
| string: silesia/dickens | 1 | 172528 | yyjson | 216090.1 | 848559.2 | 1604.175 | 1.25 | 3.93 |
| string: silesia/dickens | 1 | 172528 | std.json | 1369412.0 | 2890187.2 | 54899.381 | 7.94 | 2.11 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 3437990.2 | 8766171.6 | 2624.357 | 2.89 | 2.55 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 10165355.5 | 44158803.6 | 25807.714 | 8.54 | 4.34 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 26471591.0 | 124535257.6 | 138592.286 | 22.24 | 4.70 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 3421665.1 | 8990929.6 | 3142.857 | 2.87 | 2.63 |
| string: http/json-1m | 1 | 1190272 | simdjson | 3537484.1 | 10817573.6 | 4239.786 | 2.97 | 3.06 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2447787.1 | 11226214.6 | 9945.429 | 2.06 | 4.59 |
| string: http/json-1m | 1 | 1190272 | std.json | 8732738.3 | 42694254.6 | 15368.429 | 7.34 | 4.89 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2079753.3 | 6046661.8 | 4220.000 | 1.10 | 2.91 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6786853.6 | 23416085.8 | 12438.125 | 3.60 | 3.45 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 45954188.0 | 218527029.8 | 251188.875 | 24.40 | 4.76 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2089443.6 | 6189784.8 | 4559.625 | 1.11 | 2.96 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2652426.3 | 7334579.8 | 10098.250 | 1.41 | 2.77 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 11857968.3 | 26334410.8 | 429161.250 | 6.30 | 2.22 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20824431.5 | 57035436.8 | 560311.375 | 11.06 | 2.74 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 112822.6 | 426364.7 | 5.581 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 112872.5 | 426473.7 | 6.774 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 636213.1 | 3146523.7 | 4.774 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 112844.7 | 426333.7 | 2.387 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1219541.2 | 3932432.7 | 4.452 | 2.33 | 3.22 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1638194.8 | 5898886.7 | 4.710 | 3.12 | 3.60 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3617513.7 | 13174372.7 | 77415.129 | 6.90 | 3.64 |
