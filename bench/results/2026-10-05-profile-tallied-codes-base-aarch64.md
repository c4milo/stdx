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
| silesia/dickens | 10192446 | zlib | 7.91 | 15.77 | 1.99 | 299.18 |
| silesia/dickens | 10192446 | zlib-ng | 4.86 | 10.50 | 2.16 | 68.35 |
| silesia/dickens | 10192446 | libdeflate | 3.45 | 9.56 | 2.77 | 66.14 |
| silesia/dickens | 10192446 | Wuffs | 4.86 | 10.85 | 2.23 | 97.32 |
| silesia/dickens | 10192446 | stdx | 2.94 | 7.19 | 2.44 | 76.06 |
| silesia/mozilla | 51220480 | zlib | 7.70 | 14.13 | 1.83 | 241.08 |
| silesia/mozilla | 51220480 | zlib-ng | 4.96 | 8.95 | 1.81 | 86.27 |
| silesia/mozilla | 51220480 | libdeflate | 3.48 | 7.63 | 2.20 | 71.18 |
| silesia/mozilla | 51220480 | Wuffs | 5.72 | 10.84 | 1.89 | 132.89 |
| silesia/mozilla | 51220480 | stdx | 3.63 | 6.27 | 1.73 | 89.86 |
| silesia/mr | 9970564 | zlib | 7.60 | 15.26 | 2.01 | 193.17 |
| silesia/mr | 9970564 | zlib-ng | 4.80 | 9.98 | 2.08 | 68.34 |
| silesia/mr | 9970564 | libdeflate | 3.35 | 8.58 | 2.56 | 61.42 |
| silesia/mr | 9970564 | Wuffs | 5.28 | 10.93 | 2.07 | 102.38 |
| silesia/mr | 9970564 | stdx | 3.08 | 6.70 | 2.17 | 70.01 |
| silesia/nci | 33553445 | zlib | 2.89 | 7.25 | 2.51 | 78.69 |
| silesia/nci | 33553445 | zlib-ng | 1.57 | 3.13 | 1.99 | 33.99 |
| silesia/nci | 33553445 | libdeflate | 1.11 | 2.66 | 2.41 | 27.67 |
| silesia/nci | 33553445 | Wuffs | 1.70 | 3.38 | 1.99 | 43.20 |
| silesia/nci | 33553445 | stdx | 1.15 | 2.22 | 1.94 | 37.27 |
| silesia/ooffice | 6152192 | zlib | 10.89 | 17.83 | 1.64 | 397.57 |
| silesia/ooffice | 6152192 | zlib-ng | 6.94 | 12.04 | 1.74 | 142.53 |
| silesia/ooffice | 6152192 | libdeflate | 4.91 | 10.45 | 2.13 | 126.02 |
| silesia/ooffice | 6152192 | Wuffs | 8.11 | 14.47 | 1.78 | 221.66 |
| silesia/ooffice | 6152192 | stdx | 5.08 | 8.52 | 1.68 | 151.99 |
| silesia/osdb | 10085684 | zlib | 6.73 | 13.54 | 2.01 | 168.91 |
| silesia/osdb | 10085684 | zlib-ng | 4.29 | 8.38 | 1.95 | 53.39 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.91 | 2.43 | 30.19 |
| silesia/osdb | 10085684 | Wuffs | 5.18 | 10.56 | 2.04 | 84.85 |
| silesia/osdb | 10085684 | stdx | 2.78 | 5.64 | 2.03 | 40.71 |
| silesia/reymont | 6627202 | zlib | 6.56 | 12.73 | 1.94 | 251.24 |
| silesia/reymont | 6627202 | zlib-ng | 3.70 | 7.72 | 2.09 | 60.65 |
| silesia/reymont | 6627202 | libdeflate | 2.60 | 6.91 | 2.65 | 50.69 |
| silesia/reymont | 6627202 | Wuffs | 4.23 | 8.40 | 1.98 | 112.72 |
| silesia/reymont | 6627202 | stdx | 2.29 | 5.13 | 2.24 | 63.98 |
| silesia/samba | 21606400 | zlib | 5.43 | 11.09 | 2.04 | 169.31 |
| silesia/samba | 21606400 | zlib-ng | 3.34 | 6.47 | 1.94 | 56.14 |
| silesia/samba | 21606400 | libdeflate | 2.32 | 5.58 | 2.41 | 42.87 |
| silesia/samba | 21606400 | Wuffs | 3.65 | 7.33 | 2.01 | 81.41 |
| silesia/samba | 21606400 | stdx | 2.26 | 4.48 | 1.98 | 56.73 |
| silesia/sao | 7251944 | zlib | 9.84 | 20.36 | 2.07 | 195.00 |
| silesia/sao | 7251944 | zlib-ng | 7.88 | 14.83 | 1.88 | 81.25 |
| silesia/sao | 7251944 | libdeflate | 5.74 | 12.73 | 2.22 | 78.89 |
| silesia/sao | 7251944 | Wuffs | 8.13 | 18.14 | 2.23 | 84.88 |
| silesia/sao | 7251944 | stdx | 5.57 | 10.28 | 1.84 | 87.35 |
| silesia/webster | 41458703 | zlib | 6.95 | 12.99 | 1.87 | 271.04 |
| silesia/webster | 41458703 | zlib-ng | 4.20 | 8.04 | 1.91 | 85.58 |
| silesia/webster | 41458703 | libdeflate | 2.86 | 7.17 | 2.50 | 67.99 |
| silesia/webster | 41458703 | Wuffs | 4.51 | 8.62 | 1.91 | 123.84 |
| silesia/webster | 41458703 | stdx | 2.74 | 5.59 | 2.04 | 86.96 |
| silesia/x-ray | 8474240 | zlib | 12.16 | 23.82 | 1.96 | 323.78 |
| silesia/x-ray | 8474240 | zlib-ng | 9.04 | 17.39 | 1.92 | 125.69 |
| silesia/x-ray | 8474240 | libdeflate | 6.53 | 15.26 | 2.34 | 124.30 |
| silesia/x-ray | 8474240 | Wuffs | 10.18 | 20.40 | 2.00 | 198.85 |
| silesia/x-ray | 8474240 | stdx | 6.13 | 11.46 | 1.87 | 137.89 |
| silesia/xml | 5345280 | zlib | 3.59 | 8.20 | 2.29 | 114.98 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 43.01 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.46 | 31.43 |
| silesia/xml | 5345280 | Wuffs | 2.19 | 4.14 | 1.89 | 61.05 |
| silesia/xml | 5345280 | stdx | 1.32 | 2.67 | 2.01 | 41.87 |
| canterbury/alice29.txt | 152089 | zlib | 7.54 | 15.08 | 2.00 | 283.30 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.51 | 9.91 | 2.20 | 60.98 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.15 | 8.96 | 2.84 | 51.76 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.69 | 10.37 | 2.21 | 97.02 |
| canterbury/alice29.txt | 152089 | stdx | 2.74 | 7.11 | 2.59 | 62.87 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.10 | 16.11 | 1.99 | 301.36 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 73.74 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.62 | 9.82 | 2.71 | 70.05 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.06 | 11.34 | 2.24 | 98.42 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.09 | 7.65 | 2.48 | 75.83 |
| canterbury/cp.html | 24603 | zlib | 6.41 | 14.20 | 2.22 | 163.19 |
| canterbury/cp.html | 24603 | zlib-ng | 4.22 | 9.50 | 2.25 | 40.09 |
| canterbury/cp.html | 24603 | libdeflate | 2.79 | 7.95 | 2.85 | 7.82 |
| canterbury/cp.html | 24603 | Wuffs | 4.47 | 10.87 | 2.43 | 53.68 |
| canterbury/cp.html | 24603 | stdx | 2.86 | 7.63 | 2.67 | 18.70 |
| canterbury/fields.c | 11150 | zlib | 4.50 | 14.65 | 3.26 | 32.67 |
| canterbury/fields.c | 11150 | zlib-ng | 3.97 | 10.20 | 2.57 | 18.38 |
| canterbury/fields.c | 11150 | libdeflate | 2.79 | 8.32 | 2.99 | 1.08 |
| canterbury/fields.c | 11150 | Wuffs | 3.81 | 11.51 | 3.02 | 8.25 |
| canterbury/fields.c | 11150 | stdx | 2.71 | 8.30 | 3.06 | 3.88 |
| canterbury/grammar.lsp | 3721 | zlib | 6.05 | 21.22 | 3.51 | 2.47 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.87 | 17.48 | 2.98 | 10.05 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.38 | 12.05 | 2.75 | 0.12 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.99 | 18.87 | 3.15 | 3.94 |
| canterbury/grammar.lsp | 3721 | stdx | 4.27 | 13.66 | 3.20 | 0.46 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.93 | 12.20 | 3.10 | 47.66 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.65 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.35 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.20 | 8.67 | 2.71 | 15.00 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.67 | 2.67 | 16.92 |
| canterbury/lcet10.txt | 426754 | zlib | 7.32 | 14.53 | 1.99 | 278.35 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 61.41 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.04 | 8.48 | 2.79 | 56.45 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.55 | 9.85 | 2.17 | 100.67 |
| canterbury/lcet10.txt | 426754 | stdx | 2.61 | 6.48 | 2.48 | 66.55 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.25 | 16.53 | 2.00 | 308.45 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.26 | 11.19 | 2.13 | 78.38 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.70 | 77.22 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.13 | 11.53 | 2.25 | 98.90 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.19 | 7.70 | 2.42 | 84.97 |
| canterbury/ptt5 | 513216 | zlib | 4.38 | 7.79 | 1.78 | 99.47 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.00 | 3.74 | 1.87 | 46.95 |
| canterbury/ptt5 | 513216 | libdeflate | 1.44 | 3.02 | 2.09 | 37.97 |
| canterbury/ptt5 | 513216 | Wuffs | 2.19 | 4.02 | 1.84 | 58.60 |
| canterbury/ptt5 | 513216 | stdx | 1.47 | 2.57 | 1.75 | 50.07 |
| canterbury/sum | 38240 | zlib | 7.22 | 14.98 | 2.07 | 214.30 |
| canterbury/sum | 38240 | zlib-ng | 4.68 | 10.02 | 2.14 | 59.79 |
| canterbury/sum | 38240 | libdeflate | 3.20 | 8.34 | 2.61 | 24.52 |
| canterbury/sum | 38240 | Wuffs | 5.01 | 11.41 | 2.28 | 77.64 |
| canterbury/sum | 38240 | stdx | 3.08 | 7.97 | 2.59 | 27.30 |
| canterbury/xargs.1 | 4227 | zlib | 6.52 | 22.08 | 3.39 | 4.96 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.47 | 17.97 | 2.78 | 15.99 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.75 | 13.27 | 2.79 | 0.31 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.50 | 19.63 | 3.02 | 9.16 |
| canterbury/xargs.1 | 4227 | stdx | 4.64 | 14.23 | 3.07 | 1.48 |
| canterbury-large/E.coli | 4638690 | zlib | 5.91 | 14.55 | 2.46 | 174.34 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.19 | 9.68 | 2.31 | 47.73 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.92 | 48.79 |
| canterbury-large/E.coli | 4638690 | Wuffs | 3.97 | 9.64 | 2.43 | 61.26 |
| canterbury-large/E.coli | 4638690 | stdx | 2.49 | 6.78 | 2.72 | 53.63 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.66 | 13.26 | 1.99 | 256.80 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.76 | 8.26 | 2.20 | 54.50 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.13 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.15 | 8.72 | 2.10 | 100.37 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.25 | 5.61 | 2.49 | 55.86 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.89 | 12.69 | 1.84 | 270.03 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.19 | 7.78 | 1.86 | 92.20 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.41 | 74.74 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.52 | 8.44 | 1.87 | 130.11 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.74 | 5.43 | 1.98 | 90.99 |
| http/html-1kx1024 | 1048576 | zlib | 15.26 | 32.44 | 2.13 | 347.50 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.64 | 28.43 | 2.25 | 219.25 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.52 | 20.05 | 1.91 | 157.20 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.60 | 35.05 | 2.40 | 260.37 |
| http/html-1kx1024 | 1048576 | stdx | 10.94 | 26.26 | 2.40 | 193.27 |
| http/html-16kx64 | 1048576 | zlib | 5.94 | 11.79 | 1.99 | 212.32 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.74 |
| http/html-16kx64 | 1048576 | libdeflate | 2.63 | 6.04 | 2.29 | 60.22 |
| http/html-16kx64 | 1048576 | Wuffs | 4.27 | 8.51 | 1.99 | 117.22 |
| http/html-16kx64 | 1048576 | stdx | 2.72 | 6.09 | 2.24 | 61.84 |
| http/html-1m | 1048576 | zlib | 4.61 | 9.51 | 2.06 | 170.76 |
| http/html-1m | 1048576 | zlib-ng | 2.61 | 5.03 | 1.93 | 60.10 |
| http/html-1m | 1048576 | libdeflate | 1.69 | 4.39 | 2.59 | 37.08 |
| http/html-1m | 1048576 | Wuffs | 2.97 | 5.42 | 1.83 | 91.09 |
| http/html-1m | 1048576 | stdx | 1.66 | 3.48 | 2.10 | 52.73 |
| http/json-1kx1024 | 1048576 | zlib | 9.20 | 20.83 | 2.27 | 190.10 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.38 | 16.69 | 2.26 | 131.59 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.77 | 16.72 | 1.91 | 92.32 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.41 | 31.72 | 2.78 | 142.47 |
| http/json-1kx1024 | 1048576 | stdx | 6.71 | 17.36 | 2.59 | 107.37 |
| http/json-16kx64 | 1048576 | zlib | 3.89 | 9.62 | 2.47 | 100.33 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 51.03 |
| http/json-16kx64 | 1048576 | libdeflate | 1.91 | 4.24 | 2.22 | 39.66 |
| http/json-16kx64 | 1048576 | Wuffs | 2.81 | 6.35 | 2.26 | 58.39 |
| http/json-16kx64 | 1048576 | stdx | 1.96 | 4.50 | 2.30 | 40.89 |
| http/json-1m | 1048576 | zlib | 3.23 | 8.25 | 2.55 | 81.58 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.02 | 37.54 |
| http/json-1m | 1048576 | libdeflate | 1.37 | 3.33 | 2.42 | 31.84 |
| http/json-1m | 1048576 | Wuffs | 2.04 | 4.29 | 2.10 | 44.71 |
| http/json-1m | 1048576 | stdx | 1.33 | 2.68 | 2.01 | 40.39 |
| http/js-1kx1024 | 1048576 | zlib | 16.70 | 35.33 | 2.12 | 398.15 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.74 | 31.25 | 2.28 | 241.19 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.21 | 21.58 | 1.93 | 180.98 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.80 | 37.71 | 2.39 | 293.68 |
| http/js-1kx1024 | 1048576 | stdx | 11.87 | 28.03 | 2.36 | 225.30 |
| http/js-16kx64 | 1048576 | zlib | 6.82 | 13.06 | 1.91 | 252.47 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.37 | 8.65 | 1.98 | 92.57 |
| http/js-16kx64 | 1048576 | libdeflate | 3.05 | 7.01 | 2.30 | 71.83 |
| http/js-16kx64 | 1048576 | Wuffs | 4.84 | 9.70 | 2.01 | 130.04 |
| http/js-16kx64 | 1048576 | stdx | 3.19 | 7.05 | 2.21 | 74.46 |
| http/js-1m | 1048576 | zlib | 5.12 | 10.26 | 2.00 | 194.55 |
| http/js-1m | 1048576 | zlib-ng | 2.87 | 5.66 | 1.97 | 60.36 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.84 |
| http/js-1m | 1048576 | Wuffs | 3.25 | 6.10 | 1.88 | 96.03 |
| http/js-1m | 1048576 | stdx | 1.81 | 3.92 | 2.16 | 55.45 |
| http/css-1kx1024 | 1048576 | zlib | 12.63 | 27.18 | 2.15 | 280.22 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.21 | 23.04 | 2.26 | 174.37 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.12 | 17.37 | 1.91 | 122.34 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.02 | 29.48 | 2.45 | 204.73 |
| http/css-1kx1024 | 1048576 | stdx | 9.07 | 23.29 | 2.57 | 137.66 |
| http/css-16kx64 | 1048576 | zlib | 4.60 | 10.12 | 2.20 | 148.91 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.77 | 6.07 | 2.19 | 50.27 |
| http/css-16kx64 | 1048576 | libdeflate | 1.87 | 4.69 | 2.51 | 28.02 |
| http/css-16kx64 | 1048576 | Wuffs | 3.13 | 6.97 | 2.23 | 71.33 |
| http/css-16kx64 | 1048576 | stdx | 1.94 | 4.91 | 2.53 | 29.86 |
| http/css-1m | 1048576 | zlib | 3.35 | 8.00 | 2.39 | 105.40 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.22 | 28.95 |
| http/css-1m | 1048576 | libdeflate | 1.04 | 3.18 | 3.05 | 10.15 |
| http/css-1m | 1048576 | Wuffs | 1.92 | 4.08 | 2.12 | 46.14 |
| http/css-1m | 1048576 | stdx | 1.03 | 2.58 | 2.51 | 21.49 |
| shuffled/dickens-1m | 1048576 | zlib | 12.59 | 22.42 | 1.78 | 372.94 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.75 | 16.72 | 1.71 | 201.14 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.02 | 14.95 | 2.13 | 193.86 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.72 | 18.95 | 1.95 | 205.65 |
| shuffled/dickens-1m | 1048576 | stdx | 7.08 | 12.00 | 1.69 | 206.74 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.51 | 14.04 | 4.00 | 3.53 |
| silesia/dickens | 10192446 | stdx | 3.59 | 12.47 | 3.47 | 3.85 |
| silesia/mozilla | 51220480 | libzstd | 2.84 | 9.62 | 3.38 | 31.50 |
| silesia/mozilla | 51220480 | stdx | 2.76 | 9.68 | 3.50 | 15.59 |
| silesia/mr | 9970564 | libzstd | 3.03 | 11.98 | 3.95 | 6.24 |
| silesia/mr | 9970564 | stdx | 3.07 | 10.83 | 3.53 | 5.23 |
| silesia/nci | 33553445 | libzstd | 1.60 | 4.84 | 3.02 | 24.39 |
| silesia/nci | 33553445 | stdx | 1.59 | 4.63 | 2.91 | 13.52 |
| silesia/ooffice | 6152192 | libzstd | 3.42 | 12.14 | 3.55 | 32.89 |
| silesia/ooffice | 6152192 | stdx | 3.31 | 12.40 | 3.74 | 12.15 |
| silesia/osdb | 10085684 | libzstd | 2.32 | 8.44 | 3.64 | 15.06 |
| silesia/osdb | 10085684 | stdx | 2.35 | 8.11 | 3.44 | 15.36 |
| silesia/reymont | 6627202 | libzstd | 3.12 | 11.61 | 3.72 | 11.78 |
| silesia/reymont | 6627202 | stdx | 3.23 | 10.36 | 3.20 | 12.90 |
| silesia/samba | 21606400 | libzstd | 2.03 | 7.39 | 3.64 | 19.09 |
| silesia/samba | 21606400 | stdx | 2.07 | 6.83 | 3.29 | 17.65 |
| silesia/sao | 7251944 | libzstd | 3.78 | 12.69 | 3.36 | 27.30 |
| silesia/sao | 7251944 | stdx | 3.43 | 12.58 | 3.66 | 6.26 |
| silesia/webster | 41458703 | libzstd | 3.10 | 11.22 | 3.62 | 16.16 |
| silesia/webster | 41458703 | stdx | 3.25 | 10.05 | 3.09 | 18.22 |
| silesia/x-ray | 8474240 | libzstd | 3.96 | 14.93 | 3.77 | 18.84 |
| silesia/x-ray | 8474240 | stdx | 3.53 | 13.23 | 3.75 | 8.50 |
| silesia/xml | 5345280 | libzstd | 1.54 | 5.55 | 3.61 | 23.26 |
| silesia/xml | 5345280 | stdx | 1.50 | 5.16 | 3.43 | 17.11 |
| canterbury/alice29.txt | 152089 | libzstd | 3.39 | 16.18 | 4.78 | 4.24 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.42 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.05 | 14.25 | 4.68 | 3.34 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.31 | 0.24 |
| canterbury/cp.html | 24603 | libzstd | 2.72 | 10.74 | 3.94 | 11.72 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.12 | 0.24 |
| canterbury/fields.c | 11150 | libzstd | 3.19 | 13.61 | 4.27 | 11.64 |
| canterbury/fields.c | 11150 | stdx | 3.00 | 12.72 | 4.24 | 0.08 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.33 | 16.93 | 3.91 | 11.35 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.53 | 4.01 | 0.26 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.51 | 11.22 | 4.46 | 7.96 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.24 | 0.91 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.76 | 12.87 | 4.67 | 5.42 |
| canterbury/lcet10.txt | 426754 | stdx | 2.74 | 11.52 | 4.20 | 4.63 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.20 | 15.14 | 4.73 | 1.56 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.27 | 1.07 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.50 | 3.10 | 24.55 |
| canterbury/ptt5 | 513216 | stdx | 1.33 | 4.46 | 3.35 | 12.93 |
| canterbury/sum | 38240 | libzstd | 2.74 | 10.51 | 3.83 | 16.59 |
| canterbury/sum | 38240 | stdx | 2.61 | 10.74 | 4.11 | 0.31 |
| canterbury/xargs.1 | 4227 | libzstd | 4.36 | 17.40 | 4.00 | 13.64 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.16 | 4.05 | 0.12 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.04 | 13.63 | 4.48 | 2.23 |
| canterbury-large/E.coli | 4638690 | stdx | 3.06 | 12.04 | 3.94 | 2.95 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.95 | 11.99 | 4.06 | 8.46 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.04 | 10.64 | 3.50 | 9.32 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.52 | 9.59 | 3.80 | 19.83 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.60 | 8.64 | 3.33 | 21.51 |
| http/html-1kx1024 | 1048576 | libzstd | 7.42 | 21.63 | 2.91 | 62.95 |
| http/html-1kx1024 | 1048576 | stdx | 7.43 | 22.43 | 3.02 | 76.98 |
| http/html-16kx64 | 1048576 | libzstd | 2.68 | 10.15 | 3.78 | 29.09 |
| http/html-16kx64 | 1048576 | stdx | 2.65 | 9.61 | 3.62 | 29.90 |
| http/html-1m | 1048576 | libzstd | 2.00 | 7.86 | 3.93 | 24.51 |
| http/html-1m | 1048576 | stdx | 2.00 | 7.12 | 3.56 | 25.58 |
| http/json-1kx1024 | 1048576 | libzstd | 6.40 | 17.37 | 2.71 | 49.88 |
| http/json-1kx1024 | 1048576 | stdx | 6.20 | 17.84 | 2.88 | 54.04 |
| http/json-16kx64 | 1048576 | libzstd | 2.07 | 7.22 | 3.48 | 28.81 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 19.82 |
| http/json-1m | 1048576 | libzstd | 1.74 | 6.04 | 3.47 | 28.80 |
| http/json-1m | 1048576 | stdx | 1.62 | 5.91 | 3.65 | 14.07 |
| http/js-1kx1024 | 1048576 | libzstd | 8.45 | 26.38 | 3.12 | 73.02 |
| http/js-1kx1024 | 1048576 | stdx | 9.02 | 27.57 | 3.06 | 113.30 |
| http/js-16kx64 | 1048576 | libzstd | 2.96 | 11.71 | 3.96 | 25.15 |
| http/js-16kx64 | 1048576 | stdx | 2.95 | 11.06 | 3.75 | 25.49 |
| http/js-1m | 1048576 | libzstd | 2.03 | 8.18 | 4.02 | 20.83 |
| http/js-1m | 1048576 | stdx | 2.06 | 7.48 | 3.63 | 21.33 |
| http/css-1kx1024 | 1048576 | libzstd | 7.11 | 19.70 | 2.77 | 57.83 |
| http/css-1kx1024 | 1048576 | stdx | 6.82 | 19.93 | 2.92 | 63.82 |
| http/css-16kx64 | 1048576 | libzstd | 2.31 | 8.69 | 3.75 | 27.76 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.05 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.57 | 3.83 | 6.03 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.54 | 3.73 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.81 | 9.40 | 3.35 | 28.66 |
| shuffled/dickens-1m | 1048576 | stdx | 2.72 | 9.19 | 3.38 | 12.42 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.53 | 17.04 | 2.26 | 101.25 |
| silesia/dickens | 1048576 | stdx | 5.11 | 12.38 | 2.42 | 55.38 |
| silesia/mozilla | 1048576 | Google | 13.61 | 27.77 | 2.04 | 46.51 |
| silesia/mozilla | 1048576 | stdx | 8.32 | 15.02 | 1.81 | 47.48 |
| silesia/mr | 1048576 | Google | 8.90 | 20.24 | 2.27 | 102.01 |
| silesia/mr | 1048576 | stdx | 5.80 | 13.25 | 2.29 | 88.40 |
| silesia/nci | 1048576 | Google | 2.56 | 5.69 | 2.22 | 51.41 |
| silesia/nci | 1048576 | stdx | 1.94 | 3.95 | 2.03 | 54.95 |
| silesia/ooffice | 1048576 | Google | 14.22 | 29.28 | 2.06 | 288.13 |
| silesia/ooffice | 1048576 | stdx | 10.90 | 20.33 | 1.86 | 325.10 |
| silesia/osdb | 1048576 | Google | 8.21 | 17.38 | 2.12 | 96.33 |
| silesia/osdb | 1048576 | stdx | 5.17 | 10.57 | 2.05 | 92.35 |
| silesia/reymont | 1048576 | Google | 5.42 | 12.73 | 2.35 | 81.63 |
| silesia/reymont | 1048576 | stdx | 3.71 | 9.25 | 2.49 | 47.61 |
| silesia/samba | 1048576 | Google | 7.61 | 16.22 | 2.13 | 96.18 |
| silesia/samba | 1048576 | stdx | 5.07 | 10.71 | 2.11 | 67.36 |
| silesia/sao | 1048576 | Google | 16.79 | 36.97 | 2.20 | 163.38 |
| silesia/sao | 1048576 | stdx | 10.41 | 22.65 | 2.18 | 142.38 |
| silesia/webster | 1048576 | Google | 6.58 | 14.07 | 2.14 | 115.72 |
| silesia/webster | 1048576 | stdx | 4.41 | 9.98 | 2.26 | 68.73 |
| silesia/x-ray | 1048576 | Google | 19.26 | 38.46 | 2.00 | 234.44 |
| silesia/x-ray | 1048576 | stdx | 14.59 | 30.18 | 2.07 | 233.65 |
| silesia/xml | 1048576 | Google | 3.48 | 7.65 | 2.19 | 65.67 |
| silesia/xml | 1048576 | stdx | 2.40 | 5.40 | 2.25 | 46.98 |
| canterbury/alice29.txt | 152089 | Google | 8.92 | 20.66 | 2.32 | 137.37 |
| canterbury/alice29.txt | 152089 | stdx | 6.07 | 15.33 | 2.53 | 82.06 |
| canterbury/asyoulik.txt | 125179 | Google | 10.43 | 23.83 | 2.29 | 171.70 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.12 | 17.43 | 2.45 | 107.94 |
| canterbury/cp.html | 24603 | Google | 9.07 | 22.18 | 2.45 | 109.48 |
| canterbury/cp.html | 24603 | stdx | 5.85 | 17.15 | 2.93 | 39.09 |
| canterbury/fields.c | 11150 | Google | 7.08 | 21.25 | 3.00 | 22.49 |
| canterbury/fields.c | 11150 | stdx | 4.89 | 17.08 | 3.49 | 1.85 |
| canterbury/grammar.lsp | 3721 | Google | 9.81 | 30.23 | 3.08 | 5.71 |
| canterbury/grammar.lsp | 3721 | stdx | 7.18 | 25.04 | 3.49 | 0.52 |
| canterbury/kennedy.xls | 1029744 | Google | 5.47 | 17.05 | 3.12 | 37.27 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.83 | 12.94 | 3.38 | 33.92 |
| canterbury/lcet10.txt | 426754 | Google | 7.79 | 17.42 | 2.23 | 130.69 |
| canterbury/lcet10.txt | 426754 | stdx | 5.21 | 12.96 | 2.49 | 66.24 |
| canterbury/plrabn12.txt | 481861 | Google | 9.14 | 20.94 | 2.29 | 134.82 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.15 | 15.04 | 2.44 | 87.62 |
| canterbury/ptt5 | 513216 | Google | 4.28 | 10.36 | 2.42 | 62.64 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.07 | 65.76 |
| canterbury/sum | 38240 | Google | 10.82 | 26.44 | 2.44 | 155.73 |
| canterbury/sum | 38240 | stdx | 8.40 | 21.11 | 2.51 | 160.86 |
| canterbury/xargs.1 | 4227 | Google | 11.00 | 34.81 | 3.16 | 10.72 |
| canterbury/xargs.1 | 4227 | stdx | 8.47 | 30.44 | 3.59 | 7.40 |
| canterbury-large/E.coli | 1048576 | Google | 7.47 | 19.44 | 2.60 | 1.29 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.00 |
| canterbury-large/bible.txt | 1048576 | Google | 5.36 | 12.38 | 2.31 | 81.15 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.55 | 8.93 | 2.52 | 40.02 |
| canterbury-large/world192.txt | 1048576 | Google | 6.23 | 12.88 | 2.07 | 116.75 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.40 | 9.38 | 2.13 | 77.35 |
| http/html-1kx1024 | 1048576 | Google | 17.91 | 42.09 | 2.35 | 385.97 |
| http/html-1kx1024 | 1048576 | stdx | 15.27 | 37.56 | 2.46 | 358.62 |
| http/html-16kx64 | 1048576 | Google | 6.77 | 14.88 | 2.20 | 150.48 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.70 |
| http/html-1m | 1048576 | Google | 4.08 | 8.99 | 2.20 | 83.49 |
| http/html-1m | 1048576 | stdx | 2.86 | 6.52 | 2.28 | 54.81 |
| http/json-1kx1024 | 1048576 | Google | 14.29 | 36.74 | 2.57 | 238.48 |
| http/json-1kx1024 | 1048576 | stdx | 12.99 | 33.63 | 2.59 | 275.91 |
| http/json-16kx64 | 1048576 | Google | 4.42 | 11.42 | 2.58 | 81.07 |
| http/json-16kx64 | 1048576 | stdx | 3.38 | 8.42 | 2.49 | 83.53 |
| http/json-1m | 1048576 | Google | 3.43 | 8.66 | 2.52 | 59.17 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.44 | 57.73 |
| http/js-1kx1024 | 1048576 | Google | 19.77 | 46.38 | 2.35 | 422.60 |
| http/js-1kx1024 | 1048576 | stdx | 16.36 | 39.90 | 2.44 | 378.56 |
| http/js-16kx64 | 1048576 | Google | 8.07 | 17.79 | 2.20 | 168.54 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 126.27 |
| http/js-1m | 1048576 | Google | 4.40 | 9.60 | 2.18 | 83.45 |
| http/js-1m | 1048576 | stdx | 3.18 | 7.25 | 2.28 | 55.27 |
| http/css-1kx1024 | 1048576 | Google | 15.34 | 37.48 | 2.44 | 291.71 |
| http/css-1kx1024 | 1048576 | stdx | 13.81 | 34.70 | 2.51 | 302.32 |
| http/css-16kx64 | 1048576 | Google | 4.96 | 11.78 | 2.37 | 101.12 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 79.97 |
| http/css-1m | 1048576 | Google | 2.43 | 9.43 | 3.88 | 16.76 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.47 | 11.96 |
| shuffled/dickens-1m | 1048576 | Google | 9.59 | 20.34 | 2.12 | 105.62 |
| shuffled/dickens-1m | 1048576 | stdx | 8.75 | 14.53 | 1.66 | 114.25 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.5 | 74.3 | 0.118 | 3.01 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 69.0 | 238.3 | 0.104 | 8.15 | 3.45 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 259.7 | 1119.2 | 0.816 | 30.68 | 4.31 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 31.3 | 109.0 | 0.101 | 3.70 | 3.48 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.2 | 107.1 | 0.298 | 3.33 | 3.80 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.2 | 378.2 | 0.381 | 11.25 | 3.97 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 26.6 | 89.6 | 0.004 | 3.92 | 3.37 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 69.9 | 249.9 | 0.069 | 10.29 | 3.57 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 221.7 | 880.2 | 0.931 | 32.63 | 3.97 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 29.9 | 108.7 | 0.033 | 4.39 | 3.64 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 27.8 | 106.7 | 0.049 | 4.10 | 3.83 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 93.2 | 345.9 | 0.336 | 13.72 | 3.71 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114943.1 | 403839.2 | 523.887 | 0.67 | 3.51 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 617956.8 | 2684141.2 | 1352.969 | 3.58 | 4.34 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3891208.6 | 20639255.2 | 2976.031 | 22.55 | 5.30 |
| string: silesia/dickens | 1 | 172528 | simdjson | 329667.1 | 656791.2 | 509.794 | 1.91 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 230590.3 | 848188.2 | 2645.237 | 1.34 | 3.68 |
| string: silesia/dickens | 1 | 172528 | std.json | 1595857.9 | 4595563.2 | 44783.196 | 9.25 | 2.88 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1560550.3 | 4799762.6 | 1223.143 | 1.31 | 3.08 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 15062793.6 | 60619385.6 | 58141.429 | 12.65 | 4.02 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 31803537.6 | 148769682.6 | 159336.429 | 26.72 | 4.68 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4709471.1 | 7294566.6 | 516.357 | 3.96 | 1.55 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1777458.9 | 7470807.6 | 14327.357 | 1.49 | 4.20 |
| string: http/json-1m | 1 | 1190272 | std.json | 10070555.7 | 47253785.6 | 31363.857 | 8.46 | 4.69 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2068678.6 | 5765412.8 | 4444.000 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6483665.8 | 24133030.8 | 12698.375 | 3.44 | 3.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 51937571.4 | 252608919.8 | 303820.625 | 27.58 | 4.86 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3797292.3 | 8269494.8 | 2034.750 | 2.02 | 2.18 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7121068.1 | 12512113.8 | 279208.250 | 3.78 | 1.76 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17500897.1 | 63922930.8 | 224212.625 | 9.29 | 3.65 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12934607.3 | 42561068.3 | 244472.333 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 160041075.7 | 732363048.3 | 388519.667 | 31.53 | 4.58 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 163797838.3 | 708654908.3 | 420049.333 | 32.27 | 4.33 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 27678254.3 | 63138667.3 | 18170.000 | 5.45 | 2.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 13705042.0 | 45451415.3 | 466455.667 | 2.70 | 3.32 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79186841.0 | 314355510.3 | 455322.667 | 15.60 | 3.97 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 187245.7 | 688807.7 | 4.710 | 0.36 | 3.68 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 186380.3 | 689029.7 | 10.935 | 0.36 | 3.70 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 11159368.0 | 60818249.7 | 6.290 | 21.28 | 5.45 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 553382.3 | 1483247.7 | 5.290 | 1.06 | 2.68 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 545886.3 | 2261447.7 | 8.129 | 1.04 | 4.14 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3510610.4 | 12808414.7 | 64121.355 | 6.70 | 3.65 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 27.1 | 113.7 | 0.158 | 3.20 | 4.19 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 73.2 | 342.1 | 0.196 | 8.65 | 4.67 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 223.2 | 1092.4 | 0.856 | 26.36 | 4.90 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 23.7 | 101.9 | 0.154 | 2.80 | 4.30 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 25.0 | 102.1 | 0.190 | 2.95 | 4.09 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.1 | 105.4 | 0.248 | 3.20 | 3.89 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 68.3 | 310.3 | 0.372 | 8.07 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 24.6 | 110.3 | 0.037 | 3.62 | 4.48 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.7 | 324.0 | 0.063 | 10.11 | 4.72 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 171.0 | 790.0 | 1.164 | 25.17 | 4.62 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 21.9 | 100.3 | 0.038 | 3.23 | 4.57 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 22.3 | 100.1 | 0.036 | 3.28 | 4.50 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.2 | 117.7 | 0.032 | 4.15 | 4.17 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.4 | 270.9 | 0.279 | 8.74 | 4.56 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 120887.5 | 464395.2 | 456.990 | 0.70 | 3.84 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 517258.3 | 2182153.2 | 1229.825 | 3.00 | 4.22 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3408665.2 | 18380954.2 | 2950.113 | 19.76 | 5.39 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 125083.6 | 460562.2 | 739.845 | 0.73 | 3.68 |
| string: silesia/dickens | 1 | 172528 | simdjson | 212224.7 | 687839.2 | 1137.289 | 1.23 | 3.24 |
| string: silesia/dickens | 1 | 172528 | yyjson | 216299.8 | 848559.2 | 1610.485 | 1.25 | 3.92 |
| string: silesia/dickens | 1 | 172528 | std.json | 1370737.0 | 2890187.2 | 54465.072 | 7.95 | 2.11 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 3436596.0 | 8766171.6 | 2623.357 | 2.89 | 2.55 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 10106402.1 | 44158803.6 | 22180.857 | 8.49 | 4.37 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 26466846.4 | 124535257.6 | 139149.500 | 22.24 | 4.71 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 3428892.1 | 8990929.6 | 3409.429 | 2.88 | 2.62 |
| string: http/json-1m | 1 | 1190272 | simdjson | 3538911.1 | 10817573.6 | 4208.786 | 2.97 | 3.06 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2439756.3 | 11226214.6 | 9656.071 | 2.05 | 4.60 |
| string: http/json-1m | 1 | 1190272 | std.json | 8707323.4 | 42694254.6 | 15859.786 | 7.32 | 4.90 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2081917.9 | 6046661.8 | 4171.250 | 1.11 | 2.90 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6778906.9 | 23416085.8 | 12408.250 | 3.60 | 3.45 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 46017653.1 | 218527029.8 | 251567.125 | 24.44 | 4.75 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2089674.3 | 6189784.8 | 4618.000 | 1.11 | 2.96 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2653304.5 | 7334579.8 | 10209.125 | 1.41 | 2.76 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 11885543.0 | 26334410.8 | 430625.750 | 6.31 | 2.22 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20801576.4 | 57035436.8 | 553799.125 | 11.05 | 2.74 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 112842.9 | 426364.7 | 3.774 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 112850.3 | 426473.7 | 3.774 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 636252.6 | 3146523.7 | 5.323 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 112708.1 | 426333.7 | 2.290 | 0.21 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1221700.4 | 3932432.7 | 5.452 | 2.33 | 3.22 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1641007.0 | 5898886.7 | 5.677 | 3.13 | 3.59 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3607292.1 | 13174372.7 | 76730.419 | 6.88 | 3.65 |
