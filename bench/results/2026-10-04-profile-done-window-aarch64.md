# bench-profile

| Field | Value |
|---|---|
| Commit | 6ecc20d |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260927.135.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/37242523677 |
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
| silesia/dickens | 10192446 | zlib | 7.93 | 15.77 | 1.99 | 300.88 |
| silesia/dickens | 10192446 | zlib-ng | 4.87 | 10.50 | 2.16 | 67.86 |
| silesia/dickens | 10192446 | libdeflate | 3.44 | 9.56 | 2.78 | 66.02 |
| silesia/dickens | 10192446 | Wuffs | 4.93 | 10.85 | 2.20 | 97.38 |
| silesia/dickens | 10192446 | stdx | 3.01 | 7.48 | 2.49 | 77.58 |
| silesia/mozilla | 51220480 | zlib | 7.73 | 14.13 | 1.83 | 243.69 |
| silesia/mozilla | 51220480 | zlib-ng | 4.93 | 8.95 | 1.82 | 85.54 |
| silesia/mozilla | 51220480 | libdeflate | 3.45 | 7.63 | 2.21 | 71.11 |
| silesia/mozilla | 51220480 | Wuffs | 5.75 | 10.84 | 1.89 | 133.61 |
| silesia/mozilla | 51220480 | stdx | 3.75 | 6.98 | 1.86 | 92.24 |
| silesia/mr | 9970564 | zlib | 7.64 | 15.26 | 2.00 | 198.18 |
| silesia/mr | 9970564 | zlib-ng | 4.79 | 9.98 | 2.08 | 67.86 |
| silesia/mr | 9970564 | libdeflate | 3.34 | 8.58 | 2.57 | 61.22 |
| silesia/mr | 9970564 | Wuffs | 5.31 | 10.93 | 2.06 | 100.29 |
| silesia/mr | 9970564 | stdx | 3.21 | 7.18 | 2.24 | 71.46 |
| silesia/nci | 33553445 | zlib | 2.88 | 7.25 | 2.52 | 79.47 |
| silesia/nci | 33553445 | zlib-ng | 1.56 | 3.13 | 2.00 | 33.81 |
| silesia/nci | 33553445 | libdeflate | 1.12 | 2.66 | 2.38 | 29.76 |
| silesia/nci | 33553445 | Wuffs | 1.70 | 3.38 | 1.99 | 42.63 |
| silesia/nci | 33553445 | stdx | 1.14 | 2.29 | 2.01 | 37.45 |
| silesia/ooffice | 6152192 | zlib | 10.99 | 17.83 | 1.62 | 404.37 |
| silesia/ooffice | 6152192 | zlib-ng | 6.92 | 12.04 | 1.74 | 141.22 |
| silesia/ooffice | 6152192 | libdeflate | 4.89 | 10.45 | 2.14 | 124.90 |
| silesia/ooffice | 6152192 | Wuffs | 8.15 | 14.47 | 1.78 | 221.17 |
| silesia/ooffice | 6152192 | stdx | 5.33 | 9.60 | 1.80 | 155.29 |
| silesia/osdb | 10085684 | zlib | 6.80 | 13.54 | 1.99 | 174.22 |
| silesia/osdb | 10085684 | zlib-ng | 4.28 | 8.38 | 1.96 | 52.97 |
| silesia/osdb | 10085684 | libdeflate | 2.83 | 6.91 | 2.44 | 29.68 |
| silesia/osdb | 10085684 | Wuffs | 5.15 | 10.56 | 2.05 | 80.64 |
| silesia/osdb | 10085684 | stdx | 2.93 | 6.25 | 2.14 | 43.59 |
| silesia/reymont | 6627202 | zlib | 6.62 | 12.73 | 1.92 | 255.16 |
| silesia/reymont | 6627202 | zlib-ng | 3.70 | 7.72 | 2.09 | 59.41 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.70 |
| silesia/reymont | 6627202 | Wuffs | 4.26 | 8.40 | 1.97 | 112.78 |
| silesia/reymont | 6627202 | stdx | 2.34 | 5.36 | 2.29 | 64.96 |
| silesia/samba | 21606400 | zlib | 5.44 | 11.09 | 2.04 | 170.40 |
| silesia/samba | 21606400 | zlib-ng | 3.34 | 6.47 | 1.94 | 55.86 |
| silesia/samba | 21606400 | libdeflate | 2.31 | 5.58 | 2.42 | 42.83 |
| silesia/samba | 21606400 | Wuffs | 3.69 | 7.33 | 1.99 | 81.53 |
| silesia/samba | 21606400 | stdx | 2.33 | 4.76 | 2.04 | 57.33 |
| silesia/sao | 7251944 | zlib | 9.92 | 20.36 | 2.05 | 200.02 |
| silesia/sao | 7251944 | zlib-ng | 7.84 | 14.83 | 1.89 | 79.24 |
| silesia/sao | 7251944 | libdeflate | 5.73 | 12.73 | 2.22 | 78.82 |
| silesia/sao | 7251944 | Wuffs | 8.16 | 18.14 | 2.22 | 84.63 |
| silesia/sao | 7251944 | stdx | 5.92 | 11.69 | 1.97 | 93.56 |
| silesia/webster | 41458703 | zlib | 6.98 | 12.99 | 1.86 | 274.00 |
| silesia/webster | 41458703 | zlib-ng | 4.20 | 8.04 | 1.92 | 85.05 |
| silesia/webster | 41458703 | libdeflate | 2.85 | 7.17 | 2.51 | 68.24 |
| silesia/webster | 41458703 | Wuffs | 4.54 | 8.62 | 1.90 | 122.54 |
| silesia/webster | 41458703 | stdx | 2.78 | 5.86 | 2.11 | 88.00 |
| silesia/x-ray | 8474240 | zlib | 12.19 | 23.82 | 1.95 | 326.45 |
| silesia/x-ray | 8474240 | zlib-ng | 9.01 | 17.39 | 1.93 | 124.11 |
| silesia/x-ray | 8474240 | libdeflate | 6.52 | 15.26 | 2.34 | 124.34 |
| silesia/x-ray | 8474240 | Wuffs | 10.15 | 20.40 | 2.01 | 191.72 |
| silesia/x-ray | 8474240 | stdx | 6.35 | 12.46 | 1.96 | 139.33 |
| silesia/xml | 5345280 | zlib | 3.60 | 8.20 | 2.28 | 115.92 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.78 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 32.02 |
| silesia/xml | 5345280 | Wuffs | 2.21 | 4.14 | 1.87 | 61.04 |
| silesia/xml | 5345280 | stdx | 1.36 | 2.78 | 2.05 | 42.23 |
| canterbury/alice29.txt | 152089 | zlib | 7.54 | 15.08 | 2.00 | 283.56 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.11 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.15 | 8.96 | 2.84 | 52.04 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.78 | 10.37 | 2.17 | 98.86 |
| canterbury/alice29.txt | 152089 | stdx | 2.82 | 7.38 | 2.62 | 64.02 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.08 | 16.11 | 1.99 | 301.44 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 72.41 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.59 | 9.82 | 2.74 | 67.41 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.16 | 11.34 | 2.20 | 100.25 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.22 | 7.96 | 2.47 | 81.91 |
| canterbury/cp.html | 24603 | zlib | 6.44 | 14.20 | 2.21 | 170.32 |
| canterbury/cp.html | 24603 | zlib-ng | 4.19 | 9.50 | 2.27 | 37.22 |
| canterbury/cp.html | 24603 | libdeflate | 2.75 | 7.95 | 2.89 | 7.35 |
| canterbury/cp.html | 24603 | Wuffs | 4.82 | 10.87 | 2.26 | 77.74 |
| canterbury/cp.html | 24603 | stdx | 3.01 | 8.50 | 2.82 | 20.39 |
| canterbury/fields.c | 11150 | zlib | 4.67 | 14.65 | 3.14 | 44.39 |
| canterbury/fields.c | 11150 | zlib-ng | 3.89 | 10.20 | 2.62 | 15.80 |
| canterbury/fields.c | 11150 | libdeflate | 2.80 | 8.32 | 2.98 | 1.70 |
| canterbury/fields.c | 11150 | Wuffs | 3.86 | 11.51 | 2.99 | 8.45 |
| canterbury/fields.c | 11150 | stdx | 3.10 | 10.34 | 3.33 | 8.47 |
| canterbury/grammar.lsp | 3721 | zlib | 6.08 | 21.22 | 3.49 | 5.23 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.82 | 17.48 | 3.00 | 6.83 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.39 | 12.05 | 2.74 | 0.70 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.00 | 18.87 | 3.14 | 4.86 |
| canterbury/grammar.lsp | 3721 | stdx | 5.43 | 19.80 | 3.64 | 7.91 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.94 | 12.20 | 3.10 | 47.58 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.69 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.09 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.19 | 8.67 | 2.72 | 14.75 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.83 | 4.98 | 2.72 | 17.78 |
| canterbury/lcet10.txt | 426754 | zlib | 7.33 | 14.53 | 1.98 | 278.48 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.18 | 60.56 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.04 | 8.48 | 2.79 | 55.97 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.62 | 9.85 | 2.13 | 101.05 |
| canterbury/lcet10.txt | 426754 | stdx | 2.68 | 6.77 | 2.52 | 67.44 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.26 | 16.53 | 2.00 | 310.89 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.27 | 11.19 | 2.12 | 77.20 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.71 | 77.56 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.21 | 11.53 | 2.21 | 98.52 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.26 | 8.03 | 2.47 | 86.60 |
| canterbury/ptt5 | 513216 | zlib | 4.41 | 7.79 | 1.77 | 101.40 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.00 | 3.74 | 1.87 | 47.10 |
| canterbury/ptt5 | 513216 | libdeflate | 1.44 | 3.02 | 2.09 | 37.91 |
| canterbury/ptt5 | 513216 | Wuffs | 2.21 | 4.02 | 1.82 | 58.95 |
| canterbury/ptt5 | 513216 | stdx | 1.52 | 2.81 | 1.85 | 50.63 |
| canterbury/sum | 38240 | zlib | 7.22 | 14.98 | 2.07 | 215.22 |
| canterbury/sum | 38240 | zlib-ng | 4.64 | 10.02 | 2.16 | 57.01 |
| canterbury/sum | 38240 | libdeflate | 3.28 | 8.34 | 2.54 | 33.00 |
| canterbury/sum | 38240 | Wuffs | 5.16 | 11.41 | 2.21 | 83.89 |
| canterbury/sum | 38240 | stdx | 3.46 | 9.15 | 2.64 | 40.90 |
| canterbury/xargs.1 | 4227 | zlib | 6.61 | 22.08 | 3.34 | 13.39 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.39 | 17.97 | 2.81 | 10.89 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.74 | 13.27 | 2.80 | 0.67 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.50 | 19.63 | 3.02 | 9.30 |
| canterbury/xargs.1 | 4227 | stdx | 5.60 | 19.56 | 3.49 | 6.99 |
| canterbury-large/E.coli | 4638690 | zlib | 5.92 | 14.55 | 2.46 | 174.75 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.23 | 9.68 | 2.29 | 47.35 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.40 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.05 | 9.64 | 2.38 | 61.44 |
| canterbury-large/E.coli | 4638690 | stdx | 2.52 | 6.89 | 2.73 | 54.30 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.71 | 13.26 | 1.98 | 259.44 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.77 | 8.26 | 2.19 | 53.74 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.30 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.20 | 8.72 | 2.08 | 100.32 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.30 | 5.82 | 2.53 | 56.72 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.94 | 12.69 | 1.83 | 273.07 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.19 | 7.78 | 1.86 | 91.34 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.87 | 6.92 | 2.41 | 74.91 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.56 | 8.44 | 1.85 | 129.14 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.80 | 5.70 | 2.04 | 91.45 |
| http/html-1kx1024 | 1048576 | zlib | 15.29 | 32.44 | 2.12 | 352.04 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.67 | 28.43 | 2.24 | 215.66 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.50 | 20.05 | 1.91 | 156.03 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.62 | 35.04 | 2.40 | 263.71 |
| http/html-1kx1024 | 1048576 | stdx | 15.31 | 44.71 | 2.92 | 257.17 |
| http/html-16kx64 | 1048576 | zlib | 5.97 | 11.79 | 1.98 | 214.47 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.38 |
| http/html-16kx64 | 1048576 | libdeflate | 2.63 | 6.04 | 2.30 | 60.21 |
| http/html-16kx64 | 1048576 | Wuffs | 4.30 | 8.51 | 1.98 | 117.31 |
| http/html-16kx64 | 1048576 | stdx | 3.02 | 7.43 | 2.46 | 66.56 |
| http/html-1m | 1048576 | zlib | 4.63 | 9.51 | 2.05 | 171.82 |
| http/html-1m | 1048576 | zlib-ng | 2.63 | 5.03 | 1.92 | 60.31 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.35 |
| http/html-1m | 1048576 | Wuffs | 2.99 | 5.42 | 1.81 | 90.37 |
| http/html-1m | 1048576 | stdx | 1.69 | 3.66 | 2.16 | 53.37 |
| http/json-1kx1024 | 1048576 | zlib | 9.20 | 20.83 | 2.26 | 192.05 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.26 | 129.80 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.77 | 16.72 | 1.91 | 92.25 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.39 | 31.72 | 2.78 | 145.32 |
| http/json-1kx1024 | 1048576 | stdx | 9.38 | 27.71 | 2.95 | 153.07 |
| http/json-16kx64 | 1048576 | zlib | 3.89 | 9.62 | 2.47 | 100.97 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.86 |
| http/json-16kx64 | 1048576 | libdeflate | 1.91 | 4.24 | 2.22 | 40.47 |
| http/json-16kx64 | 1048576 | Wuffs | 2.83 | 6.35 | 2.25 | 58.34 |
| http/json-16kx64 | 1048576 | stdx | 2.22 | 5.63 | 2.53 | 46.50 |
| http/json-1m | 1048576 | zlib | 3.23 | 8.25 | 2.55 | 81.78 |
| http/json-1m | 1048576 | zlib-ng | 1.94 | 3.91 | 2.02 | 37.37 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.70 |
| http/json-1m | 1048576 | Wuffs | 2.06 | 4.29 | 2.08 | 44.56 |
| http/json-1m | 1048576 | stdx | 1.36 | 2.82 | 2.07 | 40.48 |
| http/js-1kx1024 | 1048576 | zlib | 16.77 | 35.33 | 2.11 | 406.16 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.78 | 31.25 | 2.27 | 238.91 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.18 | 21.58 | 1.93 | 179.10 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.78 | 37.70 | 2.39 | 294.12 |
| http/js-1kx1024 | 1048576 | stdx | 16.49 | 47.77 | 2.90 | 290.11 |
| http/js-16kx64 | 1048576 | zlib | 6.86 | 13.06 | 1.90 | 254.75 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.97 | 91.90 |
| http/js-16kx64 | 1048576 | libdeflate | 3.05 | 7.01 | 2.29 | 72.24 |
| http/js-16kx64 | 1048576 | Wuffs | 4.90 | 9.70 | 1.98 | 130.60 |
| http/js-16kx64 | 1048576 | stdx | 3.51 | 8.42 | 2.40 | 79.72 |
| http/js-1m | 1048576 | zlib | 5.15 | 10.26 | 1.99 | 195.83 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.96 | 60.40 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.60 | 41.86 |
| http/js-1m | 1048576 | Wuffs | 3.30 | 6.10 | 1.85 | 96.43 |
| http/js-1m | 1048576 | stdx | 1.87 | 4.10 | 2.20 | 56.47 |
| http/css-1kx1024 | 1048576 | zlib | 12.63 | 27.18 | 2.15 | 283.14 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.27 | 23.04 | 2.24 | 171.47 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.09 | 17.37 | 1.91 | 121.40 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.08 | 29.48 | 2.44 | 210.55 |
| http/css-1kx1024 | 1048576 | stdx | 13.08 | 39.16 | 2.99 | 204.99 |
| http/css-16kx64 | 1048576 | zlib | 4.63 | 10.12 | 2.19 | 150.57 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.18 | 50.22 |
| http/css-16kx64 | 1048576 | libdeflate | 1.88 | 4.69 | 2.49 | 29.59 |
| http/css-16kx64 | 1048576 | Wuffs | 3.15 | 6.97 | 2.21 | 71.18 |
| http/css-16kx64 | 1048576 | stdx | 2.17 | 5.99 | 2.76 | 34.64 |
| http/css-1m | 1048576 | zlib | 3.36 | 8.00 | 2.38 | 105.90 |
| http/css-1m | 1048576 | zlib-ng | 1.70 | 3.75 | 2.21 | 29.48 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.99 | 12.48 |
| http/css-1m | 1048576 | Wuffs | 1.93 | 4.08 | 2.12 | 45.61 |
| http/css-1m | 1048576 | stdx | 1.05 | 2.68 | 2.56 | 22.09 |
| shuffled/dickens-1m | 1048576 | zlib | 12.77 | 22.42 | 1.76 | 385.28 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.71 | 16.72 | 1.72 | 196.68 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.01 | 14.95 | 2.13 | 192.70 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.70 | 18.95 | 1.95 | 200.02 |
| shuffled/dickens-1m | 1048576 | stdx | 7.25 | 12.72 | 1.75 | 208.22 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.47 | 14.04 | 4.04 | 3.49 |
| silesia/dickens | 10192446 | stdx | 3.57 | 12.47 | 3.49 | 3.57 |
| silesia/mozilla | 51220480 | libzstd | 2.80 | 9.62 | 3.43 | 30.09 |
| silesia/mozilla | 51220480 | stdx | 2.78 | 9.68 | 3.48 | 15.55 |
| silesia/mr | 9970564 | libzstd | 2.98 | 11.98 | 4.02 | 6.25 |
| silesia/mr | 9970564 | stdx | 3.01 | 10.83 | 3.60 | 5.25 |
| silesia/nci | 33553445 | libzstd | 1.57 | 4.84 | 3.09 | 23.33 |
| silesia/nci | 33553445 | stdx | 1.54 | 4.63 | 3.00 | 13.64 |
| silesia/ooffice | 6152192 | libzstd | 3.39 | 12.14 | 3.58 | 31.22 |
| silesia/ooffice | 6152192 | stdx | 3.30 | 12.40 | 3.76 | 12.38 |
| silesia/osdb | 10085684 | libzstd | 2.35 | 8.44 | 3.58 | 15.12 |
| silesia/osdb | 10085684 | stdx | 2.38 | 8.11 | 3.40 | 15.40 |
| silesia/reymont | 6627202 | libzstd | 3.12 | 11.61 | 3.72 | 11.62 |
| silesia/reymont | 6627202 | stdx | 3.24 | 10.36 | 3.20 | 12.47 |
| silesia/samba | 21606400 | libzstd | 2.01 | 7.39 | 3.68 | 18.60 |
| silesia/samba | 21606400 | stdx | 2.07 | 6.83 | 3.31 | 17.66 |
| silesia/sao | 7251944 | libzstd | 3.76 | 12.69 | 3.38 | 26.74 |
| silesia/sao | 7251944 | stdx | 3.43 | 12.58 | 3.67 | 6.25 |
| silesia/webster | 41458703 | libzstd | 3.07 | 11.22 | 3.66 | 16.32 |
| silesia/webster | 41458703 | stdx | 3.14 | 10.05 | 3.20 | 17.38 |
| silesia/x-ray | 8474240 | libzstd | 3.94 | 14.93 | 3.78 | 18.87 |
| silesia/x-ray | 8474240 | stdx | 3.52 | 13.23 | 3.76 | 8.43 |
| silesia/xml | 5345280 | libzstd | 1.53 | 5.55 | 3.63 | 22.79 |
| silesia/xml | 5345280 | stdx | 1.50 | 5.16 | 3.44 | 17.17 |
| canterbury/alice29.txt | 152089 | libzstd | 3.35 | 16.18 | 4.83 | 4.12 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.41 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.00 | 14.25 | 4.75 | 3.33 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.31 | 0.23 |
| canterbury/cp.html | 24603 | libzstd | 2.69 | 10.74 | 3.99 | 9.38 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.10 | 0.25 |
| canterbury/fields.c | 11150 | libzstd | 3.14 | 13.61 | 4.34 | 9.86 |
| canterbury/fields.c | 11150 | stdx | 3.00 | 12.72 | 4.24 | 0.15 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.26 | 16.93 | 3.98 | 6.73 |
| canterbury/grammar.lsp | 3721 | stdx | 4.13 | 16.53 | 4.00 | 0.13 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.48 | 11.22 | 4.53 | 7.70 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.66 | 11.32 | 4.26 | 0.88 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.73 | 12.87 | 4.72 | 5.20 |
| canterbury/lcet10.txt | 426754 | stdx | 2.71 | 11.52 | 4.25 | 3.04 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.16 | 15.14 | 4.80 | 1.54 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.27 | 1.06 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.50 | 3.11 | 24.30 |
| canterbury/ptt5 | 513216 | stdx | 1.33 | 4.46 | 3.36 | 12.96 |
| canterbury/sum | 38240 | libzstd | 2.66 | 10.51 | 3.95 | 11.00 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.36 |
| canterbury/xargs.1 | 4227 | libzstd | 4.30 | 17.40 | 4.05 | 10.38 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.16 | 4.05 | 0.14 |
| canterbury-large/E.coli | 4638690 | libzstd | 2.99 | 13.63 | 4.55 | 2.17 |
| canterbury-large/E.coli | 4638690 | stdx | 3.04 | 12.04 | 3.95 | 2.89 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.92 | 11.99 | 4.11 | 8.52 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.99 | 10.64 | 3.56 | 9.35 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.51 | 9.59 | 3.83 | 19.72 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.57 | 8.64 | 3.37 | 21.44 |
| http/html-1kx1024 | 1048576 | libzstd | 7.40 | 21.63 | 2.92 | 62.83 |
| http/html-1kx1024 | 1048576 | stdx | 7.43 | 22.43 | 3.02 | 75.89 |
| http/html-16kx64 | 1048576 | libzstd | 2.68 | 10.15 | 3.79 | 28.74 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.60 | 30.62 |
| http/html-1m | 1048576 | libzstd | 2.00 | 7.86 | 3.93 | 24.35 |
| http/html-1m | 1048576 | stdx | 1.98 | 7.12 | 3.59 | 24.85 |
| http/json-1kx1024 | 1048576 | libzstd | 6.37 | 17.37 | 2.73 | 49.82 |
| http/json-1kx1024 | 1048576 | stdx | 6.20 | 17.84 | 2.88 | 53.26 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.22 | 3.52 | 27.83 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 19.84 |
| http/json-1m | 1048576 | libzstd | 1.71 | 6.04 | 3.53 | 27.40 |
| http/json-1m | 1048576 | stdx | 1.62 | 5.91 | 3.66 | 14.44 |
| http/js-1kx1024 | 1048576 | libzstd | 8.43 | 26.38 | 3.13 | 72.85 |
| http/js-1kx1024 | 1048576 | stdx | 9.02 | 27.57 | 3.06 | 112.53 |
| http/js-16kx64 | 1048576 | libzstd | 2.94 | 11.71 | 3.99 | 24.38 |
| http/js-16kx64 | 1048576 | stdx | 2.95 | 11.06 | 3.75 | 25.66 |
| http/js-1m | 1048576 | libzstd | 2.02 | 8.18 | 4.06 | 20.34 |
| http/js-1m | 1048576 | stdx | 2.05 | 7.48 | 3.64 | 21.96 |
| http/css-1kx1024 | 1048576 | libzstd | 7.03 | 19.70 | 2.80 | 53.87 |
| http/css-1kx1024 | 1048576 | stdx | 6.82 | 19.93 | 2.92 | 63.82 |
| http/css-16kx64 | 1048576 | libzstd | 2.25 | 8.69 | 3.86 | 23.32 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.70 | 22.45 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.57 | 3.89 | 5.42 |
| http/css-1m | 1048576 | stdx | 0.70 | 2.49 | 3.55 | 3.91 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.80 | 9.40 | 3.35 | 28.70 |
| shuffled/dickens-1m | 1048576 | stdx | 2.71 | 9.19 | 3.39 | 12.22 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.51 | 17.04 | 2.27 | 101.82 |
| silesia/dickens | 1048576 | stdx | 5.06 | 12.38 | 2.45 | 55.09 |
| silesia/mozilla | 1048576 | Google | 13.62 | 27.77 | 2.04 | 46.24 |
| silesia/mozilla | 1048576 | stdx | 8.32 | 15.02 | 1.81 | 47.99 |
| silesia/mr | 1048576 | Google | 8.93 | 20.24 | 2.27 | 102.24 |
| silesia/mr | 1048576 | stdx | 5.76 | 13.25 | 2.30 | 88.85 |
| silesia/nci | 1048576 | Google | 2.55 | 5.69 | 2.23 | 51.59 |
| silesia/nci | 1048576 | stdx | 1.93 | 3.95 | 2.05 | 54.83 |
| silesia/ooffice | 1048576 | Google | 14.17 | 29.28 | 2.07 | 287.50 |
| silesia/ooffice | 1048576 | stdx | 10.91 | 20.33 | 1.86 | 324.56 |
| silesia/osdb | 1048576 | Google | 8.19 | 17.38 | 2.12 | 95.26 |
| silesia/osdb | 1048576 | stdx | 5.14 | 10.57 | 2.06 | 92.19 |
| silesia/reymont | 1048576 | Google | 5.41 | 12.73 | 2.35 | 82.08 |
| silesia/reymont | 1048576 | stdx | 3.69 | 9.25 | 2.51 | 47.76 |
| silesia/samba | 1048576 | Google | 7.56 | 16.22 | 2.14 | 96.16 |
| silesia/samba | 1048576 | stdx | 5.05 | 10.71 | 2.12 | 67.00 |
| silesia/sao | 1048576 | Google | 16.74 | 36.97 | 2.21 | 161.84 |
| silesia/sao | 1048576 | stdx | 10.39 | 22.65 | 2.18 | 141.86 |
| silesia/webster | 1048576 | Google | 6.53 | 14.07 | 2.15 | 115.72 |
| silesia/webster | 1048576 | stdx | 4.35 | 9.98 | 2.30 | 68.89 |
| silesia/x-ray | 1048576 | Google | 19.56 | 38.46 | 1.97 | 233.74 |
| silesia/x-ray | 1048576 | stdx | 14.49 | 30.18 | 2.08 | 234.46 |
| silesia/xml | 1048576 | Google | 3.45 | 7.65 | 2.22 | 65.83 |
| silesia/xml | 1048576 | stdx | 2.40 | 5.40 | 2.26 | 47.04 |
| canterbury/alice29.txt | 152089 | Google | 8.86 | 20.66 | 2.33 | 138.15 |
| canterbury/alice29.txt | 152089 | stdx | 6.07 | 15.33 | 2.53 | 82.71 |
| canterbury/asyoulik.txt | 125179 | Google | 10.39 | 23.83 | 2.29 | 172.24 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.04 | 17.43 | 2.47 | 104.09 |
| canterbury/cp.html | 24603 | Google | 9.09 | 22.18 | 2.44 | 112.81 |
| canterbury/cp.html | 24603 | stdx | 5.83 | 17.15 | 2.94 | 39.02 |
| canterbury/fields.c | 11150 | Google | 7.00 | 21.25 | 3.04 | 20.10 |
| canterbury/fields.c | 11150 | stdx | 4.88 | 17.08 | 3.50 | 2.50 |
| canterbury/grammar.lsp | 3721 | Google | 9.82 | 30.23 | 3.08 | 5.78 |
| canterbury/grammar.lsp | 3721 | stdx | 7.15 | 25.04 | 3.50 | 1.08 |
| canterbury/kennedy.xls | 1029744 | Google | 5.47 | 17.05 | 3.12 | 37.16 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.82 | 12.94 | 3.39 | 34.04 |
| canterbury/lcet10.txt | 426754 | Google | 7.72 | 17.42 | 2.26 | 131.53 |
| canterbury/lcet10.txt | 426754 | stdx | 5.18 | 12.96 | 2.50 | 66.52 |
| canterbury/plrabn12.txt | 481861 | Google | 9.06 | 20.94 | 2.31 | 134.60 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.13 | 15.04 | 2.45 | 86.74 |
| canterbury/ptt5 | 513216 | Google | 4.28 | 10.36 | 2.42 | 62.12 |
| canterbury/ptt5 | 513216 | stdx | 2.36 | 4.89 | 2.07 | 65.39 |
| canterbury/sum | 38240 | Google | 10.79 | 26.44 | 2.45 | 155.53 |
| canterbury/sum | 38240 | stdx | 8.32 | 21.11 | 2.54 | 154.21 |
| canterbury/xargs.1 | 4227 | Google | 11.00 | 34.81 | 3.16 | 14.79 |
| canterbury/xargs.1 | 4227 | stdx | 8.49 | 30.44 | 3.59 | 6.41 |
| canterbury-large/E.coli | 1048576 | Google | 7.57 | 19.44 | 2.57 | 1.40 |
| canterbury-large/E.coli | 1048576 | stdx | 6.70 | 13.48 | 2.01 | 1.39 |
| canterbury-large/bible.txt | 1048576 | Google | 5.30 | 12.38 | 2.34 | 81.24 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.53 | 8.93 | 2.53 | 39.88 |
| canterbury-large/world192.txt | 1048576 | Google | 6.18 | 12.88 | 2.08 | 116.69 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.38 | 9.38 | 2.14 | 77.80 |
| http/html-1kx1024 | 1048576 | Google | 17.87 | 42.09 | 2.36 | 389.52 |
| http/html-1kx1024 | 1048576 | stdx | 15.29 | 37.56 | 2.46 | 360.35 |
| http/html-16kx64 | 1048576 | Google | 6.73 | 14.88 | 2.21 | 151.85 |
| http/html-16kx64 | 1048576 | stdx | 5.14 | 12.15 | 2.36 | 114.90 |
| http/html-1m | 1048576 | Google | 4.04 | 8.99 | 2.23 | 83.79 |
| http/html-1m | 1048576 | stdx | 2.85 | 6.52 | 2.29 | 55.03 |
| http/json-1kx1024 | 1048576 | Google | 14.22 | 36.74 | 2.58 | 239.41 |
| http/json-1kx1024 | 1048576 | stdx | 12.99 | 33.63 | 2.59 | 276.57 |
| http/json-16kx64 | 1048576 | Google | 4.40 | 11.42 | 2.60 | 80.97 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.49 | 83.53 |
| http/json-1m | 1048576 | Google | 3.40 | 8.66 | 2.54 | 58.78 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.44 | 58.04 |
| http/js-1kx1024 | 1048576 | Google | 19.72 | 46.38 | 2.35 | 427.84 |
| http/js-1kx1024 | 1048576 | stdx | 16.38 | 39.90 | 2.44 | 378.95 |
| http/js-16kx64 | 1048576 | Google | 8.02 | 17.79 | 2.22 | 168.44 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.67 |
| http/js-1m | 1048576 | Google | 4.35 | 9.60 | 2.21 | 83.51 |
| http/js-1m | 1048576 | stdx | 3.15 | 7.25 | 2.30 | 55.42 |
| http/css-1kx1024 | 1048576 | Google | 15.27 | 37.48 | 2.46 | 292.84 |
| http/css-1kx1024 | 1048576 | stdx | 13.79 | 34.70 | 2.52 | 300.25 |
| http/css-16kx64 | 1048576 | Google | 4.92 | 11.78 | 2.39 | 100.79 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.49 | 80.72 |
| http/css-1m | 1048576 | Google | 2.43 | 9.43 | 3.88 | 16.73 |
| http/css-1m | 1048576 | stdx | 0.74 | 1.86 | 2.50 | 11.87 |
| shuffled/dickens-1m | 1048576 | Google | 9.69 | 20.34 | 2.10 | 107.96 |
| shuffled/dickens-1m | 1048576 | stdx | 8.76 | 14.53 | 1.66 | 117.57 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.3 | 0.117 | 3.00 | 2.93 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 70.6 | 238.3 | 0.105 | 8.34 | 3.37 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 261.3 | 1119.2 | 0.820 | 30.87 | 4.28 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 31.2 | 109.0 | 0.097 | 3.69 | 3.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.9 | 107.1 | 0.300 | 3.29 | 3.84 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.3 | 378.2 | 0.380 | 11.25 | 3.97 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 26.9 | 89.6 | 0.004 | 3.95 | 3.34 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 70.4 | 249.9 | 0.039 | 10.37 | 3.55 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 224.3 | 880.2 | 0.929 | 33.02 | 3.92 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 29.6 | 108.7 | 0.029 | 4.36 | 3.67 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 27.7 | 106.7 | 0.057 | 4.07 | 3.85 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 93.2 | 345.9 | 0.336 | 13.72 | 3.71 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 115458.8 | 403839.2 | 539.144 | 0.67 | 3.50 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 617087.1 | 2684141.2 | 1343.629 | 3.58 | 4.35 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3859228.9 | 20639255.2 | 2977.175 | 22.37 | 5.35 |
| string: silesia/dickens | 1 | 172528 | simdjson | 329548.4 | 656791.2 | 493.381 | 1.91 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 231123.9 | 848188.2 | 2615.515 | 1.34 | 3.67 |
| string: silesia/dickens | 1 | 172528 | std.json | 1603647.7 | 4595563.2 | 44942.907 | 9.29 | 2.87 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1560472.3 | 4799762.6 | 1184.143 | 1.31 | 3.08 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 15089819.7 | 60619385.6 | 56441.857 | 12.68 | 4.02 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 31459398.8 | 148769682.6 | 157896.857 | 26.43 | 4.73 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4702810.9 | 7294566.6 | 578.929 | 3.95 | 1.55 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1783769.5 | 7470807.6 | 14540.000 | 1.50 | 4.19 |
| string: http/json-1m | 1 | 1190272 | std.json | 10043627.6 | 47253785.6 | 30871.000 | 8.44 | 4.70 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2067095.9 | 5765412.8 | 4214.875 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6473427.8 | 24133030.8 | 12643.125 | 3.44 | 3.73 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 51725283.9 | 252608919.8 | 287484.000 | 27.47 | 4.88 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3803738.6 | 8269494.8 | 2069.625 | 2.02 | 2.17 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7189781.5 | 12512113.8 | 279522.125 | 3.82 | 1.74 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17522586.0 | 63922930.8 | 226169.125 | 9.31 | 3.65 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12935737.0 | 42561068.3 | 246652.000 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 172993240.7 | 732363048.3 | 388542.667 | 34.08 | 4.23 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 166031178.0 | 708654908.3 | 421879.000 | 32.71 | 4.27 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 27654035.7 | 63138667.3 | 18269.000 | 5.45 | 2.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 13753041.7 | 45451415.3 | 462911.333 | 2.71 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 78510446.7 | 314355510.3 | 452566.000 | 15.47 | 4.00 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 184448.8 | 688807.7 | 7.129 | 0.35 | 3.73 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 183134.7 | 689029.7 | 8.839 | 0.35 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 11126328.8 | 60818249.7 | 8.323 | 21.22 | 5.47 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 553004.5 | 1483247.7 | 4.419 | 1.05 | 2.68 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 543190.8 | 2261447.7 | 7.613 | 1.04 | 4.16 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3450854.9 | 12808414.7 | 64087.258 | 6.58 | 3.71 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 26.8 | 113.7 | 0.159 | 3.17 | 4.24 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 73.4 | 342.1 | 0.197 | 8.68 | 4.66 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 222.7 | 1092.4 | 0.861 | 26.31 | 4.90 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 23.6 | 101.9 | 0.155 | 2.79 | 4.31 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 24.9 | 102.1 | 0.192 | 2.94 | 4.10 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.0 | 105.4 | 0.248 | 3.19 | 3.90 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 68.4 | 310.3 | 0.373 | 8.07 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 24.5 | 110.3 | 0.037 | 3.61 | 4.50 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 69.5 | 324.0 | 0.076 | 10.23 | 4.66 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 170.7 | 790.0 | 1.107 | 25.12 | 4.63 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 22.0 | 100.3 | 0.038 | 3.24 | 4.56 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 22.2 | 100.1 | 0.036 | 3.27 | 4.50 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.1 | 117.7 | 0.033 | 4.13 | 4.19 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.4 | 270.9 | 0.283 | 8.74 | 4.56 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 120806.4 | 464395.2 | 454.588 | 0.70 | 3.84 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 520334.5 | 2182153.2 | 1208.113 | 3.02 | 4.19 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3402205.0 | 18380954.2 | 2945.619 | 19.72 | 5.40 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 125067.5 | 460562.2 | 742.216 | 0.72 | 3.68 |
| string: silesia/dickens | 1 | 172528 | simdjson | 212969.8 | 687839.2 | 1131.216 | 1.23 | 3.23 |
| string: silesia/dickens | 1 | 172528 | yyjson | 215295.3 | 848559.2 | 1571.969 | 1.25 | 3.94 |
| string: silesia/dickens | 1 | 172528 | std.json | 1369060.3 | 2890187.2 | 54787.433 | 7.94 | 2.11 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 3438688.6 | 8766171.6 | 2641.214 | 2.89 | 2.55 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 10144402.2 | 44158803.6 | 23793.857 | 8.52 | 4.35 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 26437478.6 | 124535257.6 | 138610.286 | 22.21 | 4.71 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 3426261.6 | 8990929.6 | 3465.429 | 2.88 | 2.62 |
| string: http/json-1m | 1 | 1190272 | simdjson | 3533086.2 | 10817573.6 | 4231.714 | 2.97 | 3.06 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2444369.9 | 11226214.6 | 9855.714 | 2.05 | 4.59 |
| string: http/json-1m | 1 | 1190272 | std.json | 8623089.6 | 42694254.6 | 15170.857 | 7.24 | 4.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2081492.8 | 6046661.8 | 4295.000 | 1.11 | 2.90 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6796165.6 | 23416085.8 | 12341.125 | 3.61 | 3.45 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 45893422.1 | 218527029.8 | 251518.750 | 24.37 | 4.76 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2085725.0 | 6189784.8 | 4513.500 | 1.11 | 2.97 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2649046.6 | 7334579.8 | 10077.500 | 1.41 | 2.77 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 11886115.0 | 26334410.8 | 431014.625 | 6.31 | 2.22 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20690688.8 | 57035436.8 | 555719.625 | 10.99 | 2.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 112769.1 | 426364.7 | 2.903 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 112715.9 | 426473.7 | 2.419 | 0.21 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 636134.3 | 3146523.7 | 7.097 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 112843.5 | 426333.7 | 2.258 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1223863.3 | 3932432.7 | 5.742 | 2.33 | 3.21 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1637674.3 | 5898886.7 | 7.097 | 3.12 | 3.60 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3577617.9 | 13174372.7 | 76519.258 | 6.82 | 3.68 |
