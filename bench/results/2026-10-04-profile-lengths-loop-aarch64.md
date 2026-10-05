# bench-profile

| Field | Value |
|---|---|
| Commit | cbb1353 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260927.135.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/37244999318 |
| Date | 2026-10-04 |

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
| silesia/dickens | 10192446 | zlib | 7.92 | 15.77 | 1.99 | 299.07 |
| silesia/dickens | 10192446 | zlib-ng | 4.87 | 10.50 | 2.15 | 68.90 |
| silesia/dickens | 10192446 | libdeflate | 3.46 | 9.56 | 2.76 | 66.03 |
| silesia/dickens | 10192446 | Wuffs | 4.88 | 10.85 | 2.22 | 97.13 |
| silesia/dickens | 10192446 | stdx | 2.98 | 7.19 | 2.41 | 76.17 |
| silesia/mozilla | 51220480 | zlib | 7.71 | 14.13 | 1.83 | 241.08 |
| silesia/mozilla | 51220480 | zlib-ng | 4.96 | 8.95 | 1.80 | 86.34 |
| silesia/mozilla | 51220480 | libdeflate | 3.49 | 7.63 | 2.19 | 71.17 |
| silesia/mozilla | 51220480 | Wuffs | 5.72 | 10.84 | 1.89 | 132.90 |
| silesia/mozilla | 51220480 | stdx | 3.66 | 6.27 | 1.71 | 89.91 |
| silesia/mr | 9970564 | zlib | 7.63 | 15.26 | 2.00 | 193.04 |
| silesia/mr | 9970564 | zlib-ng | 4.81 | 9.98 | 2.08 | 68.47 |
| silesia/mr | 9970564 | libdeflate | 3.35 | 8.58 | 2.56 | 61.17 |
| silesia/mr | 9970564 | Wuffs | 5.28 | 10.93 | 2.07 | 102.30 |
| silesia/mr | 9970564 | stdx | 3.10 | 6.70 | 2.16 | 69.83 |
| silesia/nci | 33553445 | zlib | 2.92 | 7.25 | 2.48 | 78.63 |
| silesia/nci | 33553445 | zlib-ng | 1.62 | 3.13 | 1.93 | 34.02 |
| silesia/nci | 33553445 | libdeflate | 1.15 | 2.66 | 2.31 | 27.75 |
| silesia/nci | 33553445 | Wuffs | 1.74 | 3.38 | 1.95 | 43.27 |
| silesia/nci | 33553445 | stdx | 1.28 | 2.22 | 1.73 | 37.53 |
| silesia/ooffice | 6152192 | zlib | 10.91 | 17.83 | 1.63 | 398.06 |
| silesia/ooffice | 6152192 | zlib-ng | 6.95 | 12.04 | 1.73 | 142.70 |
| silesia/ooffice | 6152192 | libdeflate | 4.91 | 10.45 | 2.13 | 125.57 |
| silesia/ooffice | 6152192 | Wuffs | 8.12 | 14.47 | 1.78 | 221.46 |
| silesia/ooffice | 6152192 | stdx | 5.10 | 8.52 | 1.67 | 151.94 |
| silesia/osdb | 10085684 | zlib | 6.77 | 13.54 | 2.00 | 169.74 |
| silesia/osdb | 10085684 | zlib-ng | 4.30 | 8.38 | 1.95 | 53.32 |
| silesia/osdb | 10085684 | libdeflate | 2.85 | 6.91 | 2.43 | 29.75 |
| silesia/osdb | 10085684 | Wuffs | 5.20 | 10.56 | 2.03 | 85.36 |
| silesia/osdb | 10085684 | stdx | 2.81 | 5.64 | 2.01 | 41.11 |
| silesia/reymont | 6627202 | zlib | 6.58 | 12.73 | 1.93 | 251.12 |
| silesia/reymont | 6627202 | zlib-ng | 3.72 | 7.72 | 2.07 | 60.80 |
| silesia/reymont | 6627202 | libdeflate | 2.60 | 6.91 | 2.65 | 50.91 |
| silesia/reymont | 6627202 | Wuffs | 4.24 | 8.40 | 1.98 | 112.13 |
| silesia/reymont | 6627202 | stdx | 2.30 | 5.13 | 2.24 | 64.75 |
| silesia/samba | 21606400 | zlib | 5.46 | 11.09 | 2.03 | 169.01 |
| silesia/samba | 21606400 | zlib-ng | 3.38 | 6.47 | 1.91 | 56.32 |
| silesia/samba | 21606400 | libdeflate | 2.34 | 5.58 | 2.39 | 42.73 |
| silesia/samba | 21606400 | Wuffs | 3.69 | 7.33 | 1.99 | 81.38 |
| silesia/samba | 21606400 | stdx | 2.33 | 4.48 | 1.92 | 56.49 |
| silesia/sao | 7251944 | zlib | 9.84 | 20.36 | 2.07 | 194.37 |
| silesia/sao | 7251944 | zlib-ng | 7.89 | 14.83 | 1.88 | 81.24 |
| silesia/sao | 7251944 | libdeflate | 5.75 | 12.73 | 2.22 | 78.82 |
| silesia/sao | 7251944 | Wuffs | 8.16 | 18.14 | 2.22 | 84.54 |
| silesia/sao | 7251944 | stdx | 5.60 | 10.28 | 1.83 | 86.91 |
| silesia/webster | 41458703 | zlib | 6.96 | 12.99 | 1.87 | 271.44 |
| silesia/webster | 41458703 | zlib-ng | 4.22 | 8.04 | 1.90 | 85.63 |
| silesia/webster | 41458703 | libdeflate | 2.93 | 7.17 | 2.45 | 68.16 |
| silesia/webster | 41458703 | Wuffs | 4.52 | 8.62 | 1.91 | 123.72 |
| silesia/webster | 41458703 | stdx | 2.85 | 5.59 | 1.96 | 87.13 |
| silesia/x-ray | 8474240 | zlib | 12.17 | 23.82 | 1.96 | 322.94 |
| silesia/x-ray | 8474240 | zlib-ng | 9.05 | 17.39 | 1.92 | 125.56 |
| silesia/x-ray | 8474240 | libdeflate | 6.54 | 15.26 | 2.33 | 124.56 |
| silesia/x-ray | 8474240 | Wuffs | 10.19 | 20.40 | 2.00 | 199.08 |
| silesia/x-ray | 8474240 | stdx | 6.18 | 11.46 | 1.85 | 139.02 |
| silesia/xml | 5345280 | zlib | 3.60 | 8.20 | 2.28 | 115.24 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.89 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.46 | 31.43 |
| silesia/xml | 5345280 | Wuffs | 2.19 | 4.14 | 1.89 | 61.25 |
| silesia/xml | 5345280 | stdx | 1.33 | 2.67 | 2.00 | 41.97 |
| canterbury/alice29.txt | 152089 | zlib | 7.55 | 15.08 | 2.00 | 283.70 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 61.62 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.18 | 8.96 | 2.82 | 54.08 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.68 | 10.37 | 2.22 | 96.61 |
| canterbury/alice29.txt | 152089 | stdx | 2.76 | 7.11 | 2.57 | 63.85 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.10 | 16.11 | 1.99 | 301.32 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.09 | 10.86 | 2.13 | 75.15 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.60 | 9.82 | 2.73 | 68.05 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.05 | 11.34 | 2.24 | 98.07 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.12 | 7.65 | 2.45 | 78.94 |
| canterbury/cp.html | 24603 | zlib | 6.43 | 14.20 | 2.21 | 167.64 |
| canterbury/cp.html | 24603 | zlib-ng | 4.21 | 9.50 | 2.26 | 39.15 |
| canterbury/cp.html | 24603 | libdeflate | 2.74 | 7.95 | 2.90 | 5.22 |
| canterbury/cp.html | 24603 | Wuffs | 4.42 | 10.87 | 2.46 | 52.33 |
| canterbury/cp.html | 24603 | stdx | 2.79 | 7.63 | 2.74 | 12.99 |
| canterbury/fields.c | 11150 | zlib | 4.53 | 14.65 | 3.23 | 29.15 |
| canterbury/fields.c | 11150 | zlib-ng | 3.92 | 10.20 | 2.60 | 17.77 |
| canterbury/fields.c | 11150 | libdeflate | 2.81 | 8.32 | 2.96 | 0.84 |
| canterbury/fields.c | 11150 | Wuffs | 3.82 | 11.51 | 3.02 | 8.77 |
| canterbury/fields.c | 11150 | stdx | 2.73 | 8.30 | 3.05 | 4.76 |
| canterbury/grammar.lsp | 3721 | zlib | 6.19 | 21.22 | 3.43 | 2.97 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.86 | 17.48 | 2.98 | 10.09 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.48 | 12.05 | 2.69 | 0.14 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.98 | 18.87 | 3.15 | 3.62 |
| canterbury/grammar.lsp | 3721 | stdx | 4.30 | 13.66 | 3.18 | 2.08 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.93 | 12.20 | 3.10 | 47.62 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.61 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.26 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.20 | 8.67 | 2.71 | 15.07 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.67 | 2.67 | 16.84 |
| canterbury/lcet10.txt | 426754 | zlib | 7.33 | 14.53 | 1.98 | 278.59 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 61.22 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.38 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.55 | 9.85 | 2.16 | 100.37 |
| canterbury/lcet10.txt | 426754 | stdx | 2.62 | 6.48 | 2.47 | 67.32 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.26 | 16.53 | 2.00 | 309.37 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.26 | 11.19 | 2.13 | 78.39 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.71 | 76.69 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.13 | 11.53 | 2.25 | 98.87 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.18 | 7.70 | 2.42 | 85.15 |
| canterbury/ptt5 | 513216 | zlib | 4.38 | 7.79 | 1.78 | 99.32 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.73 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.09 | 38.07 |
| canterbury/ptt5 | 513216 | Wuffs | 2.19 | 4.02 | 1.84 | 58.70 |
| canterbury/ptt5 | 513216 | stdx | 1.46 | 2.57 | 1.76 | 49.63 |
| canterbury/sum | 38240 | zlib | 7.24 | 14.98 | 2.07 | 215.41 |
| canterbury/sum | 38240 | zlib-ng | 4.68 | 10.02 | 2.14 | 59.46 |
| canterbury/sum | 38240 | libdeflate | 3.20 | 8.34 | 2.61 | 23.27 |
| canterbury/sum | 38240 | Wuffs | 5.02 | 11.41 | 2.28 | 78.52 |
| canterbury/sum | 38240 | stdx | 3.10 | 7.97 | 2.57 | 29.13 |
| canterbury/xargs.1 | 4227 | zlib | 6.75 | 22.08 | 3.27 | 4.12 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.47 | 17.97 | 2.78 | 15.81 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.97 | 13.27 | 2.67 | 0.44 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.57 | 19.63 | 2.99 | 6.92 |
| canterbury/xargs.1 | 4227 | stdx | 4.63 | 14.23 | 3.07 | 1.07 |
| canterbury-large/E.coli | 4638690 | zlib | 5.93 | 14.55 | 2.45 | 174.73 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.21 | 9.68 | 2.30 | 48.14 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.02 |
| canterbury-large/E.coli | 4638690 | Wuffs | 3.98 | 9.64 | 2.42 | 61.30 |
| canterbury-large/E.coli | 4638690 | stdx | 2.49 | 6.78 | 2.73 | 53.61 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.68 | 13.26 | 1.99 | 256.93 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.77 | 8.26 | 2.19 | 54.35 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.84 | 45.31 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.15 | 8.72 | 2.10 | 100.62 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.24 | 5.61 | 2.50 | 55.82 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.90 | 12.69 | 1.84 | 270.41 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.18 | 7.78 | 1.86 | 91.92 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 74.93 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.52 | 8.44 | 1.87 | 130.01 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.73 | 5.43 | 1.99 | 90.40 |
| http/html-1kx1024 | 1048576 | zlib | 15.68 | 32.44 | 2.07 | 346.39 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.66 | 28.43 | 2.25 | 219.54 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.87 | 20.05 | 1.85 | 157.46 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.59 | 35.05 | 2.40 | 260.94 |
| http/html-1kx1024 | 1048576 | stdx | 10.94 | 26.26 | 2.40 | 194.01 |
| http/html-16kx64 | 1048576 | zlib | 5.96 | 11.79 | 1.98 | 212.34 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.84 | 7.54 | 1.96 | 85.43 |
| http/html-16kx64 | 1048576 | libdeflate | 2.66 | 6.04 | 2.28 | 60.12 |
| http/html-16kx64 | 1048576 | Wuffs | 4.27 | 8.51 | 1.99 | 117.20 |
| http/html-16kx64 | 1048576 | stdx | 2.72 | 6.09 | 2.24 | 62.08 |
| http/html-1m | 1048576 | zlib | 4.61 | 9.51 | 2.06 | 170.97 |
| http/html-1m | 1048576 | zlib-ng | 2.61 | 5.03 | 1.93 | 60.17 |
| http/html-1m | 1048576 | libdeflate | 1.69 | 4.39 | 2.59 | 37.09 |
| http/html-1m | 1048576 | Wuffs | 2.96 | 5.42 | 1.83 | 90.90 |
| http/html-1m | 1048576 | stdx | 1.65 | 3.48 | 2.11 | 52.77 |
| http/json-1kx1024 | 1048576 | zlib | 9.63 | 20.83 | 2.16 | 190.39 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.37 | 16.69 | 2.26 | 130.95 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.12 | 16.72 | 1.83 | 92.21 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.37 | 31.72 | 2.79 | 142.27 |
| http/json-1kx1024 | 1048576 | stdx | 6.71 | 17.36 | 2.59 | 107.46 |
| http/json-16kx64 | 1048576 | zlib | 3.91 | 9.62 | 2.46 | 100.44 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.74 |
| http/json-16kx64 | 1048576 | libdeflate | 1.93 | 4.24 | 2.20 | 39.62 |
| http/json-16kx64 | 1048576 | Wuffs | 2.81 | 6.35 | 2.26 | 58.29 |
| http/json-16kx64 | 1048576 | stdx | 1.97 | 4.50 | 2.29 | 40.93 |
| http/json-1m | 1048576 | zlib | 3.23 | 8.25 | 2.55 | 81.52 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.02 | 37.55 |
| http/json-1m | 1048576 | libdeflate | 1.37 | 3.33 | 2.42 | 31.95 |
| http/json-1m | 1048576 | Wuffs | 2.05 | 4.29 | 2.10 | 44.71 |
| http/json-1m | 1048576 | stdx | 1.33 | 2.68 | 2.02 | 40.35 |
| http/js-1kx1024 | 1048576 | zlib | 17.14 | 35.33 | 2.06 | 399.25 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.74 | 31.25 | 2.27 | 240.92 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.55 | 21.58 | 1.87 | 180.73 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.77 | 37.71 | 2.39 | 293.64 |
| http/js-1kx1024 | 1048576 | stdx | 11.86 | 28.03 | 2.36 | 224.85 |
| http/js-16kx64 | 1048576 | zlib | 6.85 | 13.06 | 1.91 | 252.59 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.97 | 92.19 |
| http/js-16kx64 | 1048576 | libdeflate | 3.08 | 7.01 | 2.28 | 72.14 |
| http/js-16kx64 | 1048576 | Wuffs | 4.84 | 9.70 | 2.01 | 129.96 |
| http/js-16kx64 | 1048576 | stdx | 3.21 | 7.05 | 2.20 | 75.07 |
| http/js-1m | 1048576 | zlib | 5.13 | 10.26 | 2.00 | 194.78 |
| http/js-1m | 1048576 | zlib-ng | 2.87 | 5.66 | 1.97 | 60.84 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.88 |
| http/js-1m | 1048576 | Wuffs | 3.26 | 6.10 | 1.87 | 96.36 |
| http/js-1m | 1048576 | stdx | 1.82 | 3.92 | 2.15 | 55.89 |
| http/css-1kx1024 | 1048576 | zlib | 13.05 | 27.18 | 2.08 | 278.42 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.21 | 23.04 | 2.26 | 174.30 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.47 | 17.37 | 1.83 | 122.90 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.03 | 29.48 | 2.45 | 205.22 |
| http/css-1kx1024 | 1048576 | stdx | 9.07 | 23.29 | 2.57 | 137.52 |
| http/css-16kx64 | 1048576 | zlib | 4.63 | 10.12 | 2.19 | 148.96 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.77 | 6.07 | 2.19 | 50.09 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 28.15 |
| http/css-16kx64 | 1048576 | Wuffs | 3.13 | 6.97 | 2.23 | 71.24 |
| http/css-16kx64 | 1048576 | stdx | 1.92 | 4.91 | 2.56 | 29.69 |
| http/css-1m | 1048576 | zlib | 3.35 | 8.00 | 2.39 | 105.34 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.22 | 29.37 |
| http/css-1m | 1048576 | libdeflate | 1.04 | 3.18 | 3.05 | 10.15 |
| http/css-1m | 1048576 | Wuffs | 1.92 | 4.08 | 2.12 | 46.07 |
| http/css-1m | 1048576 | stdx | 1.02 | 2.58 | 2.53 | 21.44 |
| shuffled/dickens-1m | 1048576 | zlib | 12.58 | 22.42 | 1.78 | 372.92 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.74 | 16.72 | 1.72 | 200.64 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.03 | 14.95 | 2.13 | 193.70 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.73 | 18.95 | 1.95 | 205.66 |
| shuffled/dickens-1m | 1048576 | stdx | 7.08 | 12.00 | 1.69 | 206.55 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.51 | 14.04 | 4.00 | 3.47 |
| silesia/dickens | 10192446 | stdx | 3.59 | 12.47 | 3.47 | 3.84 |
| silesia/mozilla | 51220480 | libzstd | 2.87 | 9.62 | 3.35 | 31.53 |
| silesia/mozilla | 51220480 | stdx | 2.86 | 9.68 | 3.38 | 15.62 |
| silesia/mr | 9970564 | libzstd | 3.04 | 11.98 | 3.94 | 6.25 |
| silesia/mr | 9970564 | stdx | 3.06 | 10.83 | 3.54 | 5.27 |
| silesia/nci | 33553445 | libzstd | 1.63 | 4.84 | 2.97 | 24.40 |
| silesia/nci | 33553445 | stdx | 1.68 | 4.63 | 2.76 | 13.50 |
| silesia/ooffice | 6152192 | libzstd | 3.45 | 12.14 | 3.52 | 32.83 |
| silesia/ooffice | 6152192 | stdx | 3.35 | 12.40 | 3.70 | 12.10 |
| silesia/osdb | 10085684 | libzstd | 2.34 | 8.44 | 3.61 | 15.15 |
| silesia/osdb | 10085684 | stdx | 2.38 | 8.11 | 3.40 | 15.46 |
| silesia/reymont | 6627202 | libzstd | 3.16 | 11.61 | 3.67 | 11.82 |
| silesia/reymont | 6627202 | stdx | 3.29 | 10.36 | 3.15 | 13.06 |
| silesia/samba | 21606400 | libzstd | 2.08 | 7.39 | 3.56 | 19.12 |
| silesia/samba | 21606400 | stdx | 2.13 | 6.83 | 3.21 | 17.70 |
| silesia/sao | 7251944 | libzstd | 3.84 | 12.69 | 3.30 | 26.33 |
| silesia/sao | 7251944 | stdx | 3.53 | 12.58 | 3.56 | 6.25 |
| silesia/webster | 41458703 | libzstd | 3.17 | 11.22 | 3.54 | 16.22 |
| silesia/webster | 41458703 | stdx | 3.33 | 10.05 | 3.02 | 17.49 |
| silesia/x-ray | 8474240 | libzstd | 3.99 | 14.93 | 3.74 | 18.84 |
| silesia/x-ray | 8474240 | stdx | 3.56 | 13.23 | 3.71 | 8.39 |
| silesia/xml | 5345280 | libzstd | 1.54 | 5.55 | 3.61 | 23.23 |
| silesia/xml | 5345280 | stdx | 1.50 | 5.16 | 3.43 | 17.09 |
| canterbury/alice29.txt | 152089 | libzstd | 3.39 | 16.18 | 4.77 | 4.26 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.53 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.03 | 14.25 | 4.70 | 3.31 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.31 | 0.24 |
| canterbury/cp.html | 24603 | libzstd | 2.72 | 10.74 | 3.94 | 11.68 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.10 | 0.24 |
| canterbury/fields.c | 11150 | libzstd | 3.18 | 13.61 | 4.28 | 11.56 |
| canterbury/fields.c | 11150 | stdx | 3.02 | 12.72 | 4.22 | 0.08 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.32 | 16.93 | 3.92 | 11.45 |
| canterbury/grammar.lsp | 3721 | stdx | 4.15 | 16.53 | 3.99 | 0.20 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.51 | 11.22 | 4.46 | 7.97 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.66 | 11.32 | 4.25 | 0.91 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.76 | 12.87 | 4.67 | 5.44 |
| canterbury/lcet10.txt | 426754 | stdx | 2.72 | 11.52 | 4.24 | 3.25 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.20 | 15.14 | 4.73 | 1.60 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.27 | 1.26 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.50 | 3.10 | 24.35 |
| canterbury/ptt5 | 513216 | stdx | 1.34 | 4.46 | 3.33 | 13.98 |
| canterbury/sum | 38240 | libzstd | 2.75 | 10.51 | 3.82 | 17.00 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.37 |
| canterbury/xargs.1 | 4227 | libzstd | 4.35 | 17.40 | 4.00 | 13.38 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.16 | 4.05 | 0.24 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.03 | 13.63 | 4.50 | 2.20 |
| canterbury-large/E.coli | 4638690 | stdx | 3.06 | 12.04 | 3.94 | 2.92 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.93 | 11.99 | 4.09 | 8.45 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.00 | 10.64 | 3.55 | 9.43 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.51 | 9.59 | 3.83 | 19.73 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.58 | 8.64 | 3.35 | 21.54 |
| http/html-1kx1024 | 1048576 | libzstd | 7.41 | 21.63 | 2.92 | 62.46 |
| http/html-1kx1024 | 1048576 | stdx | 7.47 | 22.43 | 3.00 | 77.13 |
| http/html-16kx64 | 1048576 | libzstd | 2.68 | 10.15 | 3.79 | 28.87 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 9.61 | 3.61 | 30.13 |
| http/html-1m | 1048576 | libzstd | 2.00 | 7.86 | 3.93 | 24.41 |
| http/html-1m | 1048576 | stdx | 2.00 | 7.12 | 3.56 | 25.39 |
| http/json-1kx1024 | 1048576 | libzstd | 6.39 | 17.37 | 2.72 | 50.03 |
| http/json-1kx1024 | 1048576 | stdx | 6.21 | 17.84 | 2.87 | 54.10 |
| http/json-16kx64 | 1048576 | libzstd | 2.07 | 7.22 | 3.49 | 28.74 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.57 | 20.13 |
| http/json-1m | 1048576 | libzstd | 1.74 | 6.04 | 3.47 | 28.81 |
| http/json-1m | 1048576 | stdx | 1.62 | 5.91 | 3.64 | 14.35 |
| http/js-1kx1024 | 1048576 | libzstd | 8.45 | 26.38 | 3.12 | 72.88 |
| http/js-1kx1024 | 1048576 | stdx | 9.05 | 27.57 | 3.05 | 113.61 |
| http/js-16kx64 | 1048576 | libzstd | 2.96 | 11.71 | 3.96 | 25.06 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.74 | 25.81 |
| http/js-1m | 1048576 | libzstd | 2.03 | 8.18 | 4.03 | 20.64 |
| http/js-1m | 1048576 | stdx | 2.06 | 7.48 | 3.64 | 21.56 |
| http/css-1kx1024 | 1048576 | libzstd | 7.10 | 19.70 | 2.78 | 57.46 |
| http/css-1kx1024 | 1048576 | stdx | 6.85 | 19.93 | 2.91 | 63.99 |
| http/css-16kx64 | 1048576 | libzstd | 2.32 | 8.69 | 3.75 | 27.69 |
| http/css-16kx64 | 1048576 | stdx | 2.28 | 8.43 | 3.70 | 22.06 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.57 | 3.83 | 5.99 |
| http/css-1m | 1048576 | stdx | 0.70 | 2.49 | 3.56 | 4.11 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.81 | 9.40 | 3.35 | 28.54 |
| shuffled/dickens-1m | 1048576 | stdx | 2.72 | 9.19 | 3.38 | 12.74 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.54 | 17.04 | 2.26 | 101.17 |
| silesia/dickens | 1048576 | stdx | 5.06 | 12.38 | 2.44 | 54.96 |
| silesia/mozilla | 1048576 | Google | 13.62 | 27.77 | 2.04 | 46.40 |
| silesia/mozilla | 1048576 | stdx | 8.32 | 15.02 | 1.81 | 47.76 |
| silesia/mr | 1048576 | Google | 8.93 | 20.24 | 2.27 | 102.09 |
| silesia/mr | 1048576 | stdx | 5.78 | 13.25 | 2.29 | 88.18 |
| silesia/nci | 1048576 | Google | 2.56 | 5.69 | 2.22 | 51.65 |
| silesia/nci | 1048576 | stdx | 1.94 | 3.95 | 2.04 | 54.55 |
| silesia/ooffice | 1048576 | Google | 14.27 | 29.28 | 2.05 | 288.16 |
| silesia/ooffice | 1048576 | stdx | 10.95 | 20.33 | 1.86 | 324.58 |
| silesia/osdb | 1048576 | Google | 8.23 | 17.38 | 2.11 | 95.88 |
| silesia/osdb | 1048576 | stdx | 5.14 | 10.57 | 2.06 | 92.46 |
| silesia/reymont | 1048576 | Google | 5.47 | 12.73 | 2.33 | 82.00 |
| silesia/reymont | 1048576 | stdx | 3.73 | 9.25 | 2.48 | 47.68 |
| silesia/samba | 1048576 | Google | 7.61 | 16.22 | 2.13 | 96.38 |
| silesia/samba | 1048576 | stdx | 5.06 | 10.71 | 2.12 | 66.78 |
| silesia/sao | 1048576 | Google | 16.83 | 36.97 | 2.20 | 162.79 |
| silesia/sao | 1048576 | stdx | 10.41 | 22.65 | 2.18 | 142.60 |
| silesia/webster | 1048576 | Google | 6.59 | 14.07 | 2.14 | 115.44 |
| silesia/webster | 1048576 | stdx | 4.39 | 9.98 | 2.27 | 69.05 |
| silesia/x-ray | 1048576 | Google | 19.43 | 38.46 | 1.98 | 234.49 |
| silesia/x-ray | 1048576 | stdx | 14.53 | 30.18 | 2.08 | 235.18 |
| silesia/xml | 1048576 | Google | 3.49 | 7.65 | 2.19 | 65.63 |
| silesia/xml | 1048576 | stdx | 2.40 | 5.40 | 2.25 | 46.93 |
| canterbury/alice29.txt | 152089 | Google | 8.93 | 20.66 | 2.31 | 136.97 |
| canterbury/alice29.txt | 152089 | stdx | 6.09 | 15.33 | 2.52 | 82.52 |
| canterbury/asyoulik.txt | 125179 | Google | 10.45 | 23.83 | 2.28 | 171.78 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.08 | 17.43 | 2.46 | 104.95 |
| canterbury/cp.html | 24603 | Google | 9.08 | 22.18 | 2.44 | 109.51 |
| canterbury/cp.html | 24603 | stdx | 5.86 | 17.15 | 2.93 | 40.92 |
| canterbury/fields.c | 11150 | Google | 7.07 | 21.25 | 3.01 | 22.24 |
| canterbury/fields.c | 11150 | stdx | 4.90 | 17.08 | 3.49 | 2.16 |
| canterbury/grammar.lsp | 3721 | Google | 9.85 | 30.23 | 3.07 | 6.21 |
| canterbury/grammar.lsp | 3721 | stdx | 7.18 | 25.04 | 3.49 | 1.23 |
| canterbury/kennedy.xls | 1029744 | Google | 5.47 | 17.05 | 3.12 | 37.45 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.79 | 12.94 | 3.42 | 34.11 |
| canterbury/lcet10.txt | 426754 | Google | 7.77 | 17.42 | 2.24 | 130.29 |
| canterbury/lcet10.txt | 426754 | stdx | 5.19 | 12.96 | 2.50 | 66.33 |
| canterbury/plrabn12.txt | 481861 | Google | 9.12 | 20.94 | 2.30 | 134.75 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.16 | 15.04 | 2.44 | 87.21 |
| canterbury/ptt5 | 513216 | Google | 4.29 | 10.36 | 2.42 | 62.32 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.07 | 65.44 |
| canterbury/sum | 38240 | Google | 10.85 | 26.44 | 2.44 | 156.97 |
| canterbury/sum | 38240 | stdx | 8.44 | 21.11 | 2.50 | 164.28 |
| canterbury/xargs.1 | 4227 | Google | 11.00 | 34.81 | 3.17 | 11.67 |
| canterbury/xargs.1 | 4227 | stdx | 8.43 | 30.44 | 3.61 | 4.28 |
| canterbury-large/E.coli | 1048576 | Google | 7.48 | 19.44 | 2.60 | 1.32 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.07 |
| canterbury-large/bible.txt | 1048576 | Google | 5.37 | 12.38 | 2.30 | 81.05 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.53 | 8.93 | 2.53 | 39.87 |
| canterbury-large/world192.txt | 1048576 | Google | 6.21 | 12.88 | 2.07 | 116.16 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.41 | 9.38 | 2.13 | 76.92 |
| http/html-1kx1024 | 1048576 | Google | 17.97 | 42.09 | 2.34 | 384.53 |
| http/html-1kx1024 | 1048576 | stdx | 15.28 | 37.56 | 2.46 | 359.92 |
| http/html-16kx64 | 1048576 | Google | 6.78 | 14.88 | 2.20 | 150.81 |
| http/html-16kx64 | 1048576 | stdx | 5.14 | 12.15 | 2.36 | 114.60 |
| http/html-1m | 1048576 | Google | 4.07 | 8.99 | 2.21 | 83.56 |
| http/html-1m | 1048576 | stdx | 2.85 | 6.52 | 2.29 | 55.02 |
| http/json-1kx1024 | 1048576 | Google | 14.35 | 36.74 | 2.56 | 238.36 |
| http/json-1kx1024 | 1048576 | stdx | 13.00 | 33.63 | 2.59 | 276.48 |
| http/json-16kx64 | 1048576 | Google | 4.43 | 11.42 | 2.57 | 81.29 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.49 | 83.55 |
| http/json-1m | 1048576 | Google | 3.43 | 8.66 | 2.52 | 59.49 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.44 | 57.92 |
| http/js-1kx1024 | 1048576 | Google | 19.88 | 46.38 | 2.33 | 424.94 |
| http/js-1kx1024 | 1048576 | stdx | 16.34 | 39.90 | 2.44 | 377.42 |
| http/js-16kx64 | 1048576 | Google | 8.08 | 17.79 | 2.20 | 168.74 |
| http/js-16kx64 | 1048576 | stdx | 6.02 | 14.36 | 2.38 | 125.35 |
| http/js-1m | 1048576 | Google | 4.39 | 9.60 | 2.19 | 83.28 |
| http/js-1m | 1048576 | stdx | 3.17 | 7.25 | 2.29 | 55.57 |
| http/css-1kx1024 | 1048576 | Google | 15.42 | 37.48 | 2.43 | 292.15 |
| http/css-1kx1024 | 1048576 | stdx | 13.80 | 34.70 | 2.52 | 300.88 |
| http/css-16kx64 | 1048576 | Google | 4.97 | 11.78 | 2.37 | 101.24 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.48 | 80.44 |
| http/css-1m | 1048576 | Google | 2.43 | 9.43 | 3.88 | 16.72 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.47 | 11.78 |
| shuffled/dickens-1m | 1048576 | Google | 9.58 | 20.34 | 2.12 | 104.36 |
| shuffled/dickens-1m | 1048576 | stdx | 8.77 | 14.53 | 1.66 | 118.27 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.3 | 0.118 | 3.00 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 69.2 | 238.3 | 0.105 | 8.18 | 3.44 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 259.8 | 1119.2 | 0.815 | 30.69 | 4.31 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 31.2 | 109.0 | 0.101 | 3.68 | 3.50 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.0 | 107.1 | 0.297 | 3.31 | 3.82 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.2 | 378.2 | 0.385 | 11.24 | 3.97 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 26.8 | 89.6 | 0.004 | 3.94 | 3.35 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 69.8 | 249.9 | 0.040 | 10.28 | 3.58 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 224.4 | 880.2 | 0.927 | 33.02 | 3.92 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 29.6 | 108.7 | 0.028 | 4.35 | 3.68 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.6 | 106.7 | 0.059 | 4.36 | 3.60 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 94.1 | 345.9 | 0.338 | 13.85 | 3.68 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114905.2 | 403839.2 | 524.412 | 0.67 | 3.51 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 617880.1 | 2684141.2 | 1342.330 | 3.58 | 4.34 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3909771.8 | 20639255.2 | 2977.938 | 22.66 | 5.28 |
| string: silesia/dickens | 1 | 172528 | simdjson | 329851.6 | 656791.2 | 498.155 | 1.91 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 230498.7 | 848188.2 | 2628.835 | 1.34 | 3.68 |
| string: silesia/dickens | 1 | 172528 | std.json | 1573063.5 | 4595563.3 | 44070.464 | 9.12 | 2.92 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1560296.2 | 4799762.6 | 1201.286 | 1.31 | 3.08 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 15033056.6 | 60619385.6 | 58352.857 | 12.63 | 4.03 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 31708665.1 | 148769682.6 | 157906.571 | 26.64 | 4.69 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4708063.9 | 7294566.6 | 531.786 | 3.96 | 1.55 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1788261.1 | 7470807.6 | 14655.214 | 1.50 | 4.18 |
| string: http/json-1m | 1 | 1190272 | std.json | 10116917.4 | 47253785.6 | 32031.357 | 8.50 | 4.67 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2066145.1 | 5765412.8 | 4306.125 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6508805.4 | 24133030.8 | 12612.625 | 3.46 | 3.71 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 52004659.5 | 252608919.8 | 272239.625 | 27.62 | 4.86 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3802934.5 | 8269494.8 | 2067.500 | 2.02 | 2.17 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7189045.8 | 12512113.8 | 280605.250 | 3.82 | 1.74 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17488179.1 | 63922930.8 | 224034.625 | 9.29 | 3.66 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12926447.3 | 42561068.3 | 244260.333 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 160953037.3 | 732363048.3 | 388688.333 | 31.71 | 4.55 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 163897013.7 | 708654908.3 | 419996.000 | 32.29 | 4.32 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 27710907.0 | 63138667.3 | 18234.667 | 5.46 | 2.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 13944047.0 | 45451415.3 | 459774.667 | 2.75 | 3.26 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 78310055.7 | 314355510.3 | 453234.667 | 15.43 | 4.01 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 190132.2 | 688807.7 | 6.000 | 0.36 | 3.62 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 188564.5 | 689029.7 | 10.839 | 0.36 | 3.65 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 11207462.4 | 60818249.7 | 7.935 | 21.38 | 5.43 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 552863.7 | 1483247.7 | 6.839 | 1.05 | 2.68 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 544434.8 | 2261447.7 | 6.226 | 1.04 | 4.15 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3489383.6 | 12808414.7 | 62833.548 | 6.66 | 3.67 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 27.3 | 113.7 | 0.156 | 3.22 | 4.17 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 73.1 | 342.1 | 0.197 | 8.64 | 4.68 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 223.4 | 1092.4 | 0.859 | 26.39 | 4.89 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 23.8 | 101.9 | 0.154 | 2.81 | 4.28 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 25.0 | 102.1 | 0.192 | 2.96 | 4.08 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.0 | 105.4 | 0.250 | 3.19 | 3.90 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 68.4 | 310.3 | 0.375 | 8.08 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 24.8 | 110.3 | 0.037 | 3.65 | 4.44 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.5 | 324.0 | 0.064 | 10.08 | 4.73 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 170.8 | 790.0 | 1.112 | 25.14 | 4.63 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 22.1 | 100.3 | 0.038 | 3.26 | 4.53 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 22.6 | 100.1 | 0.036 | 3.33 | 4.43 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.1 | 117.7 | 0.032 | 4.14 | 4.19 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.7 | 270.9 | 0.285 | 8.78 | 4.54 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 121037.1 | 464395.2 | 464.351 | 0.70 | 3.84 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 518570.3 | 2182153.2 | 1214.742 | 3.01 | 4.21 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3423138.3 | 18380954.2 | 2946.371 | 19.84 | 5.37 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 125298.9 | 460562.2 | 755.247 | 0.73 | 3.68 |
| string: silesia/dickens | 1 | 172528 | simdjson | 212871.0 | 687839.2 | 1148.082 | 1.23 | 3.23 |
| string: silesia/dickens | 1 | 172528 | yyjson | 216616.2 | 848559.2 | 1617.474 | 1.26 | 3.92 |
| string: silesia/dickens | 1 | 172528 | std.json | 1362920.3 | 2890187.2 | 54468.670 | 7.90 | 2.12 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 3436854.2 | 8766171.6 | 2628.214 | 2.89 | 2.55 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 10017048.5 | 44158803.6 | 21477.071 | 8.42 | 4.41 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 26572461.1 | 124535257.6 | 138502.500 | 22.32 | 4.69 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 3423828.7 | 8990929.6 | 3463.000 | 2.88 | 2.63 |
| string: http/json-1m | 1 | 1190272 | simdjson | 3540806.2 | 10817573.6 | 4320.786 | 2.97 | 3.06 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2442610.6 | 11226214.6 | 9776.000 | 2.05 | 4.60 |
| string: http/json-1m | 1 | 1190272 | std.json | 8697901.9 | 42694254.6 | 15449.357 | 7.31 | 4.91 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2087778.8 | 6046661.8 | 4186.000 | 1.11 | 2.90 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6790518.6 | 23416085.8 | 12402.750 | 3.61 | 3.45 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 46153383.0 | 218527029.8 | 251531.250 | 24.51 | 4.73 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2088093.9 | 6189784.8 | 4473.500 | 1.11 | 2.96 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2651793.3 | 7334579.8 | 10120.000 | 1.41 | 2.77 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 11892545.8 | 26334410.8 | 430674.625 | 6.32 | 2.21 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20729018.1 | 57035436.8 | 552491.250 | 11.01 | 2.75 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 112723.5 | 426364.7 | 4.387 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 112730.0 | 426473.7 | 2.677 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 637148.2 | 3146523.7 | 6.323 | 1.22 | 4.94 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 112714.9 | 426333.7 | 3.097 | 0.21 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1220248.2 | 3932432.7 | 5.484 | 2.33 | 3.22 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1639680.0 | 5898886.7 | 7.742 | 3.13 | 3.60 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3599332.7 | 13174372.7 | 76560.355 | 6.87 | 3.66 |
