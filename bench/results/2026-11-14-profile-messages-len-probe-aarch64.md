# bench-profile

| Field | Value |
|---|---|
| Commit | 3a70a3d |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43648383354 |
| Date | 2026-11-14 |

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
| silesia/dickens | 10192446 | zlib | 8.81 | 19.08 | 2.16 | 311.75 |
| silesia/dickens | 10192446 | zlib-ng | 4.86 | 10.50 | 2.16 | 67.95 |
| silesia/dickens | 10192446 | libdeflate | 3.45 | 9.56 | 2.77 | 66.68 |
| silesia/dickens | 10192446 | Wuffs | 5.53 | 13.90 | 2.51 | 97.53 |
| silesia/dickens | 10192446 | stdx | 2.91 | 7.15 | 2.45 | 76.05 |
| silesia/mozilla | 51220480 | zlib | 8.44 | 17.23 | 2.04 | 251.87 |
| silesia/mozilla | 51220480 | zlib-ng | 4.93 | 8.95 | 1.82 | 85.52 |
| silesia/mozilla | 51220480 | libdeflate | 3.45 | 7.63 | 2.21 | 71.03 |
| silesia/mozilla | 51220480 | Wuffs | 6.39 | 13.89 | 2.17 | 132.45 |
| silesia/mozilla | 51220480 | stdx | 3.59 | 6.29 | 1.75 | 89.82 |
| silesia/mr | 9970564 | zlib | 8.36 | 18.46 | 2.21 | 202.47 |
| silesia/mr | 9970564 | zlib-ng | 4.78 | 9.98 | 2.09 | 67.77 |
| silesia/mr | 9970564 | libdeflate | 3.34 | 8.58 | 2.57 | 61.17 |
| silesia/mr | 9970564 | Wuffs | 5.98 | 14.04 | 2.35 | 99.81 |
| silesia/mr | 9970564 | stdx | 3.06 | 6.70 | 2.19 | 70.10 |
| silesia/nci | 33553445 | zlib | 3.52 | 10.18 | 2.89 | 81.03 |
| silesia/nci | 33553445 | zlib-ng | 1.57 | 3.13 | 2.00 | 33.68 |
| silesia/nci | 33553445 | libdeflate | 1.12 | 2.66 | 2.38 | 29.75 |
| silesia/nci | 33553445 | Wuffs | 2.44 | 6.47 | 2.65 | 41.68 |
| silesia/nci | 33553445 | stdx | 1.12 | 2.20 | 1.97 | 37.28 |
| silesia/ooffice | 6152192 | zlib | 11.76 | 21.06 | 1.79 | 416.45 |
| silesia/ooffice | 6152192 | zlib-ng | 6.91 | 12.04 | 1.74 | 141.25 |
| silesia/ooffice | 6152192 | libdeflate | 4.90 | 10.45 | 2.14 | 125.24 |
| silesia/ooffice | 6152192 | Wuffs | 8.81 | 17.54 | 1.99 | 220.58 |
| silesia/ooffice | 6152192 | stdx | 5.07 | 8.55 | 1.69 | 151.89 |
| silesia/osdb | 10085684 | zlib | 7.46 | 16.59 | 2.22 | 183.18 |
| silesia/osdb | 10085684 | zlib-ng | 4.28 | 8.38 | 1.96 | 53.02 |
| silesia/osdb | 10085684 | libdeflate | 2.83 | 6.91 | 2.44 | 29.84 |
| silesia/osdb | 10085684 | Wuffs | 5.80 | 13.61 | 2.35 | 79.14 |
| silesia/osdb | 10085684 | stdx | 2.77 | 5.65 | 2.04 | 41.15 |
| silesia/reymont | 6627202 | zlib | 7.35 | 15.89 | 2.16 | 258.40 |
| silesia/reymont | 6627202 | zlib-ng | 3.72 | 7.72 | 2.08 | 60.86 |
| silesia/reymont | 6627202 | libdeflate | 2.60 | 6.91 | 2.65 | 51.00 |
| silesia/reymont | 6627202 | Wuffs | 4.89 | 11.40 | 2.33 | 113.17 |
| silesia/reymont | 6627202 | stdx | 2.28 | 5.11 | 2.24 | 64.52 |
| silesia/samba | 21606400 | zlib | 6.10 | 14.13 | 2.32 | 175.09 |
| silesia/samba | 21606400 | zlib-ng | 3.34 | 6.47 | 1.94 | 56.00 |
| silesia/samba | 21606400 | libdeflate | 2.30 | 5.58 | 2.42 | 42.89 |
| silesia/samba | 21606400 | Wuffs | 4.32 | 10.39 | 2.41 | 79.61 |
| silesia/samba | 21606400 | stdx | 2.25 | 4.46 | 1.99 | 56.59 |
| silesia/sao | 7251944 | zlib | 10.49 | 23.54 | 2.24 | 205.35 |
| silesia/sao | 7251944 | zlib-ng | 7.84 | 14.83 | 1.89 | 79.44 |
| silesia/sao | 7251944 | libdeflate | 5.73 | 12.73 | 2.22 | 79.06 |
| silesia/sao | 7251944 | Wuffs | 8.89 | 21.26 | 2.39 | 86.61 |
| silesia/sao | 7251944 | stdx | 5.58 | 10.32 | 1.85 | 89.25 |
| silesia/webster | 41458703 | zlib | 7.79 | 16.16 | 2.07 | 281.97 |
| silesia/webster | 41458703 | zlib-ng | 4.21 | 8.04 | 1.91 | 85.09 |
| silesia/webster | 41458703 | libdeflate | 2.86 | 7.17 | 2.50 | 68.40 |
| silesia/webster | 41458703 | Wuffs | 5.13 | 11.67 | 2.27 | 122.45 |
| silesia/webster | 41458703 | stdx | 2.69 | 5.56 | 2.06 | 87.18 |
| silesia/x-ray | 8474240 | zlib | 12.87 | 27.21 | 2.11 | 329.89 |
| silesia/x-ray | 8474240 | zlib-ng | 9.02 | 17.39 | 1.93 | 124.09 |
| silesia/x-ray | 8474240 | libdeflate | 6.52 | 15.26 | 2.34 | 124.40 |
| silesia/x-ray | 8474240 | Wuffs | 10.81 | 23.52 | 2.18 | 190.89 |
| silesia/x-ray | 8474240 | stdx | 6.10 | 11.49 | 1.88 | 138.71 |
| silesia/xml | 5345280 | zlib | 4.21 | 11.16 | 2.65 | 117.91 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.73 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 32.00 |
| silesia/xml | 5345280 | Wuffs | 2.83 | 7.22 | 2.55 | 58.91 |
| silesia/xml | 5345280 | stdx | 1.32 | 2.65 | 2.01 | 41.92 |
| canterbury/alice29.txt | 152089 | zlib | 8.43 | 18.35 | 2.18 | 294.96 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.53 | 9.91 | 2.19 | 61.01 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.17 | 8.96 | 2.83 | 53.81 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.39 | 13.40 | 2.49 | 98.68 |
| canterbury/alice29.txt | 152089 | stdx | 2.73 | 6.99 | 2.56 | 64.53 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.02 | 19.42 | 2.15 | 314.36 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.11 | 10.86 | 2.12 | 75.16 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.60 | 9.82 | 2.73 | 68.91 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.77 | 14.40 | 2.50 | 100.22 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.08 | 7.52 | 2.44 | 78.03 |
| canterbury/cp.html | 24603 | zlib | 7.04 | 17.33 | 2.46 | 169.33 |
| canterbury/cp.html | 24603 | zlib-ng | 4.18 | 9.50 | 2.27 | 37.04 |
| canterbury/cp.html | 24603 | libdeflate | 2.80 | 7.95 | 2.83 | 10.79 |
| canterbury/cp.html | 24603 | Wuffs | 5.24 | 13.91 | 2.66 | 62.02 |
| canterbury/cp.html | 24603 | stdx | 2.66 | 7.19 | 2.70 | 13.54 |
| canterbury/fields.c | 11150 | zlib | 5.30 | 17.73 | 3.35 | 38.75 |
| canterbury/fields.c | 11150 | zlib-ng | 3.86 | 10.20 | 2.64 | 13.36 |
| canterbury/fields.c | 11150 | libdeflate | 2.81 | 8.32 | 2.97 | 0.90 |
| canterbury/fields.c | 11150 | Wuffs | 4.52 | 14.54 | 3.22 | 10.04 |
| canterbury/fields.c | 11150 | stdx | 2.50 | 7.64 | 3.06 | 4.17 |
| canterbury/grammar.lsp | 3721 | zlib | 6.87 | 24.26 | 3.53 | 5.15 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.80 | 17.48 | 3.01 | 6.47 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.48 | 12.05 | 2.69 | 0.43 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.70 | 21.86 | 3.26 | 5.06 |
| canterbury/grammar.lsp | 3721 | stdx | 3.84 | 12.18 | 3.17 | 0.75 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.59 | 15.27 | 3.33 | 48.68 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.60 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.08 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.86 | 11.59 | 3.00 | 14.87 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.74 | 4.66 | 2.68 | 16.81 |
| canterbury/lcet10.txt | 426754 | zlib | 8.22 | 17.78 | 2.16 | 291.58 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.33 | 9.39 | 2.17 | 61.28 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.02 | 8.48 | 2.80 | 54.77 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.24 | 12.88 | 2.46 | 101.62 |
| canterbury/lcet10.txt | 426754 | stdx | 2.60 | 6.42 | 2.47 | 66.72 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.20 | 19.86 | 2.16 | 321.13 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.27 | 11.19 | 2.12 | 76.67 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.78 | 10.19 | 2.70 | 78.02 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.83 | 14.61 | 2.51 | 100.24 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 7.63 | 2.41 | 86.31 |
| canterbury/ptt5 | 513216 | zlib | 5.05 | 10.71 | 2.12 | 103.40 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 47.10 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.08 | 38.77 |
| canterbury/ptt5 | 513216 | Wuffs | 3.00 | 7.13 | 2.37 | 57.42 |
| canterbury/ptt5 | 513216 | stdx | 1.44 | 2.55 | 1.77 | 49.25 |
| canterbury/sum | 38240 | zlib | 7.99 | 18.12 | 2.27 | 223.92 |
| canterbury/sum | 38240 | zlib-ng | 4.63 | 10.02 | 2.16 | 56.11 |
| canterbury/sum | 38240 | libdeflate | 3.25 | 8.34 | 2.57 | 29.02 |
| canterbury/sum | 38240 | Wuffs | 5.78 | 14.47 | 2.51 | 81.12 |
| canterbury/sum | 38240 | stdx | 3.03 | 7.73 | 2.55 | 29.26 |
| canterbury/xargs.1 | 4227 | zlib | 7.42 | 25.22 | 3.40 | 13.26 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.36 | 17.97 | 2.82 | 9.16 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.85 | 13.27 | 2.74 | 1.03 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.19 | 22.63 | 3.15 | 9.80 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 12.86 | 3.04 | 1.44 |
| canterbury-large/E.coli | 4638690 | zlib | 6.75 | 17.84 | 2.64 | 177.09 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.22 | 9.68 | 2.29 | 47.39 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.15 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.66 | 12.73 | 2.73 | 61.76 |
| canterbury-large/E.coli | 4638690 | stdx | 2.47 | 6.72 | 2.72 | 53.83 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.57 | 16.46 | 2.18 | 271.30 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.77 | 8.26 | 2.19 | 53.92 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.42 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.80 | 11.73 | 2.44 | 100.57 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.23 | 5.57 | 2.50 | 55.86 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.72 | 15.84 | 2.05 | 282.52 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.19 | 7.78 | 1.86 | 91.79 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.07 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.18 | 11.48 | 2.22 | 128.05 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 5.40 | 1.99 | 90.66 |
| http/html-1kx1024 | 1048576 | zlib | 16.70 | 35.58 | 2.13 | 352.95 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.68 | 28.43 | 2.24 | 217.03 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.84 | 20.05 | 1.85 | 155.22 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.36 | 38.07 | 2.48 | 266.71 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 137.63 |
| http/html-16kx64 | 1048576 | zlib | 6.74 | 14.77 | 2.19 | 222.46 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.86 | 7.54 | 1.95 | 85.82 |
| http/html-16kx64 | 1048576 | libdeflate | 2.67 | 6.04 | 2.26 | 60.54 |
| http/html-16kx64 | 1048576 | Wuffs | 4.93 | 11.56 | 2.34 | 114.94 |
| http/html-16kx64 | 1048576 | stdx | 2.51 | 5.56 | 2.22 | 58.81 |
| http/html-1m | 1048576 | zlib | 5.33 | 12.53 | 2.35 | 178.16 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 60.01 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.45 |
| http/html-1m | 1048576 | Wuffs | 3.61 | 8.48 | 2.35 | 88.18 |
| http/html-1m | 1048576 | stdx | 1.65 | 3.46 | 2.10 | 52.78 |
| http/json-1kx1024 | 1048576 | zlib | 10.59 | 23.92 | 2.26 | 191.95 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.41 | 16.69 | 2.25 | 131.40 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.13 | 16.72 | 1.83 | 92.26 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.16 | 34.78 | 2.86 | 146.93 |
| http/json-1kx1024 | 1048576 | stdx | 5.02 | 13.12 | 2.61 | 80.71 |
| http/json-16kx64 | 1048576 | zlib | 4.57 | 12.51 | 2.74 | 103.30 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.62 | 5.50 | 2.10 | 51.07 |
| http/json-16kx64 | 1048576 | libdeflate | 1.93 | 4.24 | 2.19 | 40.57 |
| http/json-16kx64 | 1048576 | Wuffs | 3.50 | 9.43 | 2.70 | 58.00 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.26 | 39.50 |
| http/json-1m | 1048576 | zlib | 3.84 | 11.20 | 2.91 | 83.15 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.02 | 37.39 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.87 |
| http/json-1m | 1048576 | Wuffs | 2.73 | 7.37 | 2.70 | 43.75 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.02 | 40.16 |
| http/js-1kx1024 | 1048576 | zlib | 18.23 | 38.46 | 2.11 | 409.44 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.76 | 31.25 | 2.27 | 238.31 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.54 | 21.58 | 1.87 | 179.06 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.54 | 40.70 | 2.46 | 300.15 |
| http/js-1kx1024 | 1048576 | stdx | 9.27 | 22.85 | 2.46 | 159.09 |
| http/js-16kx64 | 1048576 | zlib | 7.67 | 16.08 | 2.10 | 263.58 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.97 | 92.26 |
| http/js-16kx64 | 1048576 | libdeflate | 3.08 | 7.01 | 2.28 | 72.19 |
| http/js-16kx64 | 1048576 | Wuffs | 5.51 | 12.75 | 2.32 | 128.87 |
| http/js-16kx64 | 1048576 | stdx | 3.01 | 6.54 | 2.18 | 72.30 |
| http/js-1m | 1048576 | zlib | 5.85 | 13.31 | 2.28 | 199.67 |
| http/js-1m | 1048576 | zlib-ng | 2.89 | 5.66 | 1.96 | 60.64 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 42.00 |
| http/js-1m | 1048576 | Wuffs | 3.90 | 9.14 | 2.34 | 93.86 |
| http/js-1m | 1048576 | stdx | 1.80 | 3.89 | 2.16 | 55.35 |
| http/css-1kx1024 | 1048576 | zlib | 14.03 | 30.36 | 2.16 | 281.16 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.25 | 23.04 | 2.25 | 171.15 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.45 | 17.37 | 1.84 | 121.19 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.77 | 32.49 | 2.55 | 210.99 |
| http/css-1kx1024 | 1048576 | stdx | 6.68 | 17.64 | 2.64 | 100.70 |
| http/css-16kx64 | 1048576 | zlib | 5.31 | 13.04 | 2.46 | 153.48 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.19 | 50.07 |
| http/css-16kx64 | 1048576 | libdeflate | 1.90 | 4.69 | 2.46 | 29.71 |
| http/css-16kx64 | 1048576 | Wuffs | 3.79 | 10.01 | 2.64 | 69.66 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.54 | 28.27 |
| http/css-1m | 1048576 | zlib | 3.98 | 10.97 | 2.75 | 108.43 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.22 | 28.97 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.97 | 12.89 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.78 | 43.17 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.52 | 21.59 |
| shuffled/dickens-1m | 1048576 | zlib | 13.30 | 25.88 | 1.95 | 373.69 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.71 | 16.72 | 1.72 | 196.18 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.01 | 14.95 | 2.13 | 192.47 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.44 | 22.08 | 2.12 | 201.14 |
| shuffled/dickens-1m | 1048576 | stdx | 7.04 | 11.89 | 1.69 | 207.67 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.47 | 14.05 | 4.05 | 3.42 |
| silesia/dickens | 10192446 | stdx | 3.62 | 12.47 | 3.44 | 3.59 |
| silesia/mozilla | 51220480 | libzstd | 2.78 | 9.68 | 3.48 | 30.10 |
| silesia/mozilla | 51220480 | stdx | 2.77 | 9.68 | 3.50 | 15.68 |
| silesia/mr | 9970564 | libzstd | 2.98 | 11.99 | 4.02 | 6.11 |
| silesia/mr | 9970564 | stdx | 3.03 | 10.83 | 3.57 | 5.16 |
| silesia/nci | 33553445 | libzstd | 1.58 | 4.88 | 3.08 | 24.85 |
| silesia/nci | 33553445 | stdx | 1.55 | 4.63 | 2.99 | 13.62 |
| silesia/ooffice | 6152192 | libzstd | 3.34 | 12.19 | 3.65 | 30.95 |
| silesia/ooffice | 6152192 | stdx | 3.30 | 12.40 | 3.76 | 12.19 |
| silesia/osdb | 10085684 | libzstd | 2.34 | 8.45 | 3.61 | 14.92 |
| silesia/osdb | 10085684 | stdx | 2.40 | 8.11 | 3.38 | 15.66 |
| silesia/reymont | 6627202 | libzstd | 3.15 | 11.62 | 3.68 | 11.52 |
| silesia/reymont | 6627202 | stdx | 3.30 | 10.36 | 3.14 | 12.77 |
| silesia/samba | 21606400 | libzstd | 2.02 | 7.41 | 3.66 | 18.59 |
| silesia/samba | 21606400 | stdx | 2.07 | 6.83 | 3.30 | 17.55 |
| silesia/sao | 7251944 | libzstd | 3.73 | 12.72 | 3.41 | 26.77 |
| silesia/sao | 7251944 | stdx | 3.45 | 12.58 | 3.65 | 6.31 |
| silesia/webster | 41458703 | libzstd | 3.13 | 11.24 | 3.59 | 16.11 |
| silesia/webster | 41458703 | stdx | 3.21 | 10.05 | 3.13 | 17.50 |
| silesia/x-ray | 8474240 | libzstd | 3.86 | 14.94 | 3.87 | 18.86 |
| silesia/x-ray | 8474240 | stdx | 3.54 | 13.23 | 3.74 | 8.51 |
| silesia/xml | 5345280 | libzstd | 1.55 | 5.57 | 3.59 | 23.32 |
| silesia/xml | 5345280 | stdx | 1.51 | 5.16 | 3.42 | 17.01 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.89 | 4.10 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.36 | 0.40 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.95 | 14.26 | 4.84 | 3.21 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.29 | 0.22 |
| canterbury/cp.html | 24603 | libzstd | 2.63 | 10.74 | 4.08 | 7.83 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.11 | 0.25 |
| canterbury/fields.c | 11150 | libzstd | 3.13 | 13.62 | 4.36 | 9.77 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.23 | 0.18 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.19 | 16.94 | 4.05 | 4.37 |
| canterbury/grammar.lsp | 3721 | stdx | 4.13 | 16.54 | 4.00 | 0.21 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.52 | 11.40 | 4.52 | 7.80 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.24 | 0.90 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.70 | 12.89 | 4.77 | 5.17 |
| canterbury/lcet10.txt | 426754 | stdx | 2.73 | 11.52 | 4.22 | 3.88 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.10 | 15.16 | 4.89 | 1.53 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.27 | 0.91 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.52 | 3.13 | 24.69 |
| canterbury/ptt5 | 513216 | stdx | 1.33 | 4.46 | 3.35 | 12.89 |
| canterbury/sum | 38240 | libzstd | 2.62 | 10.58 | 4.05 | 10.17 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.33 |
| canterbury/xargs.1 | 4227 | libzstd | 4.25 | 17.41 | 4.09 | 9.25 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.17 | 4.05 | 0.43 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.02 | 13.64 | 4.52 | 2.16 |
| canterbury-large/E.coli | 4638690 | stdx | 3.13 | 12.04 | 3.84 | 2.89 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.93 | 12.00 | 4.10 | 8.35 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.04 | 10.64 | 3.50 | 9.35 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.59 | 9.60 | 3.71 | 19.77 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.69 | 8.64 | 3.21 | 20.78 |
| http/html-1kx1024 | 1048576 | libzstd | 7.24 | 21.63 | 2.99 | 62.85 |
| http/html-1kx1024 | 1048576 | stdx | 7.48 | 22.46 | 3.00 | 76.78 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.55 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.61 | 30.22 |
| http/html-1m | 1048576 | libzstd | 2.01 | 7.88 | 3.92 | 23.85 |
| http/html-1m | 1048576 | stdx | 2.01 | 7.12 | 3.53 | 24.83 |
| http/json-1kx1024 | 1048576 | libzstd | 6.27 | 17.39 | 2.77 | 49.66 |
| http/json-1kx1024 | 1048576 | stdx | 6.24 | 17.86 | 2.86 | 53.58 |
| http/json-16kx64 | 1048576 | libzstd | 2.06 | 7.26 | 3.53 | 28.47 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 19.65 |
| http/json-1m | 1048576 | libzstd | 1.72 | 6.08 | 3.54 | 28.19 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.62 | 14.44 |
| http/js-1kx1024 | 1048576 | libzstd | 8.33 | 26.35 | 3.16 | 73.47 |
| http/js-1kx1024 | 1048576 | stdx | 9.05 | 27.60 | 3.05 | 113.09 |
| http/js-16kx64 | 1048576 | libzstd | 2.92 | 11.72 | 4.01 | 24.20 |
| http/js-16kx64 | 1048576 | stdx | 2.95 | 11.06 | 3.74 | 26.05 |
| http/js-1m | 1048576 | libzstd | 2.03 | 8.19 | 4.04 | 20.13 |
| http/js-1m | 1048576 | stdx | 2.05 | 7.48 | 3.64 | 20.38 |
| http/css-1kx1024 | 1048576 | libzstd | 6.89 | 19.69 | 2.86 | 53.75 |
| http/css-1kx1024 | 1048576 | stdx | 6.85 | 19.96 | 2.91 | 63.31 |
| http/css-16kx64 | 1048576 | libzstd | 2.25 | 8.70 | 3.87 | 23.11 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.09 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.58 | 3.87 | 5.52 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.53 | 3.96 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.78 | 9.40 | 3.39 | 28.43 |
| shuffled/dickens-1m | 1048576 | stdx | 2.74 | 9.19 | 3.36 | 12.66 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.47 | 16.93 | 2.27 | 100.08 |
| silesia/dickens | 1048576 | stdx | 5.13 | 12.38 | 2.41 | 54.71 |
| silesia/mozilla | 1048576 | Google | 13.47 | 28.31 | 2.10 | 47.93 |
| silesia/mozilla | 1048576 | stdx | 8.31 | 15.02 | 1.81 | 47.28 |
| silesia/mr | 1048576 | Google | 8.92 | 20.21 | 2.27 | 103.26 |
| silesia/mr | 1048576 | stdx | 5.85 | 13.25 | 2.27 | 88.33 |
| silesia/nci | 1048576 | Google | 2.54 | 5.70 | 2.24 | 52.43 |
| silesia/nci | 1048576 | stdx | 1.94 | 3.95 | 2.04 | 54.80 |
| silesia/ooffice | 1048576 | Google | 14.13 | 29.27 | 2.07 | 289.38 |
| silesia/ooffice | 1048576 | stdx | 10.92 | 20.33 | 1.86 | 323.55 |
| silesia/osdb | 1048576 | Google | 8.20 | 17.48 | 2.13 | 97.33 |
| silesia/osdb | 1048576 | stdx | 5.15 | 10.57 | 2.05 | 91.37 |
| silesia/reymont | 1048576 | Google | 5.40 | 12.62 | 2.34 | 82.89 |
| silesia/reymont | 1048576 | stdx | 3.76 | 9.25 | 2.46 | 47.70 |
| silesia/samba | 1048576 | Google | 7.57 | 16.30 | 2.15 | 95.37 |
| silesia/samba | 1048576 | stdx | 5.06 | 10.71 | 2.12 | 66.85 |
| silesia/sao | 1048576 | Google | 16.81 | 37.18 | 2.21 | 167.61 |
| silesia/sao | 1048576 | stdx | 10.41 | 22.65 | 2.18 | 142.03 |
| silesia/webster | 1048576 | Google | 6.49 | 14.00 | 2.16 | 113.59 |
| silesia/webster | 1048576 | stdx | 4.46 | 9.98 | 2.24 | 69.05 |
| silesia/x-ray | 1048576 | Google | 19.23 | 38.56 | 2.01 | 235.46 |
| silesia/x-ray | 1048576 | stdx | 14.76 | 30.18 | 2.05 | 234.39 |
| silesia/xml | 1048576 | Google | 3.43 | 7.61 | 2.22 | 65.33 |
| silesia/xml | 1048576 | stdx | 2.41 | 5.40 | 2.24 | 47.00 |
| canterbury/alice29.txt | 152089 | Google | 8.83 | 20.55 | 2.33 | 133.20 |
| canterbury/alice29.txt | 152089 | stdx | 6.04 | 15.33 | 2.54 | 79.53 |
| canterbury/asyoulik.txt | 125179 | Google | 10.35 | 23.71 | 2.29 | 166.73 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.02 | 17.43 | 2.48 | 100.94 |
| canterbury/cp.html | 24603 | Google | 9.04 | 22.20 | 2.46 | 113.49 |
| canterbury/cp.html | 24603 | stdx | 5.75 | 17.15 | 2.98 | 34.25 |
| canterbury/fields.c | 11150 | Google | 7.11 | 21.16 | 2.98 | 29.63 |
| canterbury/fields.c | 11150 | stdx | 4.88 | 17.08 | 3.50 | 2.06 |
| canterbury/grammar.lsp | 3721 | Google | 9.82 | 30.16 | 3.07 | 7.78 |
| canterbury/grammar.lsp | 3721 | stdx | 7.14 | 25.04 | 3.51 | 0.42 |
| canterbury/kennedy.xls | 1029744 | Google | 5.40 | 17.05 | 3.16 | 37.68 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.81 | 12.94 | 3.40 | 34.02 |
| canterbury/lcet10.txt | 426754 | Google | 7.73 | 17.36 | 2.25 | 125.48 |
| canterbury/lcet10.txt | 426754 | stdx | 5.20 | 12.96 | 2.49 | 66.09 |
| canterbury/plrabn12.txt | 481861 | Google | 9.07 | 20.82 | 2.29 | 132.20 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.19 | 15.04 | 2.43 | 87.40 |
| canterbury/ptt5 | 513216 | Google | 4.28 | 10.41 | 2.43 | 62.26 |
| canterbury/ptt5 | 513216 | stdx | 2.36 | 4.89 | 2.07 | 64.88 |
| canterbury/sum | 38240 | Google | 10.86 | 26.44 | 2.44 | 159.91 |
| canterbury/sum | 38240 | stdx | 8.45 | 21.11 | 2.50 | 166.19 |
| canterbury/xargs.1 | 4227 | Google | 11.01 | 34.81 | 3.16 | 11.90 |
| canterbury/xargs.1 | 4227 | stdx | 8.45 | 30.44 | 3.60 | 6.15 |
| canterbury-large/E.coli | 1048576 | Google | 8.14 | 19.55 | 2.40 | 1.46 |
| canterbury-large/E.coli | 1048576 | stdx | 6.70 | 13.48 | 2.01 | 1.31 |
| canterbury-large/bible.txt | 1048576 | Google | 5.31 | 12.28 | 2.31 | 80.84 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.59 | 8.93 | 2.49 | 40.14 |
| canterbury-large/world192.txt | 1048576 | Google | 6.18 | 12.84 | 2.08 | 114.89 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.42 | 9.38 | 2.12 | 77.83 |
| http/html-1kx1024 | 1048576 | Google | 18.02 | 41.93 | 2.33 | 386.59 |
| http/html-1kx1024 | 1048576 | stdx | 15.28 | 37.56 | 2.46 | 360.20 |
| http/html-16kx64 | 1048576 | Google | 6.73 | 14.85 | 2.21 | 148.97 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.50 |
| http/html-1m | 1048576 | Google | 4.03 | 8.94 | 2.22 | 83.09 |
| http/html-1m | 1048576 | stdx | 2.85 | 6.52 | 2.29 | 54.87 |
| http/json-1kx1024 | 1048576 | Google | 14.49 | 36.64 | 2.53 | 241.30 |
| http/json-1kx1024 | 1048576 | stdx | 12.97 | 33.63 | 2.59 | 276.50 |
| http/json-16kx64 | 1048576 | Google | 4.43 | 11.43 | 2.58 | 83.10 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.25 |
| http/json-1m | 1048576 | Google | 3.40 | 8.65 | 2.55 | 59.89 |
| http/json-1m | 1048576 | stdx | 2.45 | 5.99 | 2.45 | 57.43 |
| http/js-1kx1024 | 1048576 | Google | 19.94 | 46.20 | 2.32 | 425.91 |
| http/js-1kx1024 | 1048576 | stdx | 16.40 | 39.90 | 2.43 | 381.60 |
| http/js-16kx64 | 1048576 | Google | 8.01 | 17.73 | 2.21 | 165.81 |
| http/js-16kx64 | 1048576 | stdx | 6.02 | 14.36 | 2.39 | 125.53 |
| http/js-1m | 1048576 | Google | 4.34 | 9.54 | 2.20 | 82.79 |
| http/js-1m | 1048576 | stdx | 3.16 | 7.25 | 2.29 | 55.32 |
| http/css-1kx1024 | 1048576 | Google | 15.53 | 37.36 | 2.41 | 294.85 |
| http/css-1kx1024 | 1048576 | stdx | 13.77 | 34.70 | 2.52 | 300.85 |
| http/css-16kx64 | 1048576 | Google | 4.96 | 11.76 | 2.37 | 102.78 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.57 |
| http/css-1m | 1048576 | Google | 2.43 | 9.42 | 3.88 | 16.96 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.49 | 11.84 |
| shuffled/dickens-1m | 1048576 | Google | 10.07 | 20.65 | 2.05 | 104.77 |
| shuffled/dickens-1m | 1048576 | stdx | 8.80 | 14.53 | 1.65 | 119.84 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.16 | 36.91 | 2.43 | 410.91 |
| silesia/dickens | 10192446 | 1 | stdx | 16.10 | 38.17 | 2.37 | 357.81 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.08 | 87.63 | 1.68 | 695.44 |
| silesia/dickens | 10192446 | 6 | stdx | 49.51 | 84.26 | 1.70 | 1433.20 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.78 | 160.47 | 1.44 | 928.68 |
| silesia/dickens | 10192446 | 9 | stdx | 85.08 | 191.81 | 2.25 | 1717.22 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.11 | 32.62 | 2.31 | 438.46 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.35 | 30.24 | 2.26 | 295.89 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.87 | 70.83 | 2.15 | 580.68 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.58 | 69.96 | 2.22 | 735.31 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.58 | 221.49 | 1.74 | 766.81 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.94 | 126.12 | 2.58 | 791.79 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.91 | 35.02 | 2.94 | 229.12 |
| silesia/mr | 9970564 | 1 | stdx | 12.43 | 34.08 | 2.74 | 187.82 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.27 | 80.54 | 2.10 | 438.03 |
| silesia/mr | 9970564 | 6 | stdx | 39.58 | 83.19 | 2.10 | 974.96 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.83 | 165.48 | 1.69 | 752.52 |
| silesia/mr | 9970564 | 9 | stdx | 87.16 | 206.31 | 2.37 | 1328.31 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.18 | 18.42 | 2.98 | 116.40 |
| silesia/nci | 33553445 | 1 | stdx | 4.87 | 10.88 | 2.24 | 98.39 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.95 | 34.84 | 2.06 | 225.59 |
| silesia/nci | 33553445 | 6 | stdx | 14.34 | 29.54 | 2.06 | 393.19 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.33 | 105.28 | 1.69 | 500.01 |
| silesia/nci | 33553445 | 9 | stdx | 33.06 | 80.64 | 2.44 | 646.83 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.86 | 39.15 | 1.97 | 753.47 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.48 | 39.08 | 2.24 | 430.55 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 40.87 | 79.10 | 1.94 | 954.41 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.42 | 87.83 | 2.12 | 1014.69 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.47 | 127.63 | 1.71 | 1130.40 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.11 | 129.17 | 2.48 | 939.13 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.83 | 30.15 | 2.35 | 352.81 |
| silesia/osdb | 10085684 | 1 | stdx | 12.68 | 27.87 | 2.20 | 293.81 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.22 | 55.67 | 1.97 | 491.98 |
| silesia/osdb | 10085684 | 6 | stdx | 26.86 | 57.40 | 2.14 | 564.92 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.87 | 64.15 | 1.89 | 550.50 |
| silesia/osdb | 10085684 | 9 | stdx | 35.58 | 87.23 | 2.45 | 686.10 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.57 | 32.88 | 2.62 | 310.94 |
| silesia/reymont | 6627202 | 1 | stdx | 13.21 | 33.24 | 2.52 | 272.64 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.00 | 86.58 | 1.80 | 520.22 |
| silesia/reymont | 6627202 | 6 | stdx | 44.96 | 76.82 | 1.71 | 1433.87 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.16 | 276.14 | 1.39 | 836.74 |
| silesia/reymont | 6627202 | 9 | stdx | 87.29 | 189.98 | 2.18 | 1608.52 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.41 | 26.53 | 2.55 | 272.42 |
| silesia/samba | 21606400 | 1 | stdx | 9.72 | 22.23 | 2.29 | 221.06 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.92 | 58.79 | 2.03 | 385.63 |
| silesia/samba | 21606400 | 6 | stdx | 24.06 | 49.84 | 2.07 | 622.11 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.15 | 141.44 | 1.68 | 504.88 |
| silesia/samba | 21606400 | 9 | stdx | 41.63 | 102.63 | 2.47 | 731.33 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.69 | 47.87 | 2.21 | 689.46 |
| silesia/sao | 7251944 | 1 | stdx | 19.05 | 49.92 | 2.62 | 346.53 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.09 | 96.89 | 1.90 | 964.20 |
| silesia/sao | 7251944 | 6 | stdx | 47.02 | 105.66 | 2.25 | 851.35 |
| silesia/sao | 7251944 | 9 | libdeflate | 70.91 | 120.26 | 1.70 | 1105.16 |
| silesia/sao | 7251944 | 9 | stdx | 55.40 | 138.16 | 2.49 | 849.98 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.12 | 30.45 | 2.32 | 388.06 |
| silesia/webster | 41458703 | 1 | stdx | 13.85 | 29.09 | 2.10 | 340.04 |
| silesia/webster | 41458703 | 6 | libdeflate | 37.01 | 66.02 | 1.78 | 570.94 |
| silesia/webster | 41458703 | 6 | stdx | 35.09 | 60.88 | 1.74 | 1106.17 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.50 | 138.85 | 1.47 | 752.73 |
| silesia/webster | 41458703 | 9 | stdx | 60.79 | 135.96 | 2.24 | 1290.62 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.71 | 49.67 | 2.10 | 790.61 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.34 | 50.82 | 2.93 | 261.87 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.79 | 82.77 | 2.52 | 852.85 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.66 | 98.12 | 2.91 | 539.57 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.42 | 91.03 | 2.43 | 1029.17 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.66 | 122.06 | 3.00 | 466.60 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.77 | 21.59 | 2.78 | 175.92 |
| silesia/xml | 5345280 | 1 | stdx | 6.79 | 15.66 | 2.31 | 155.13 |
| silesia/xml | 5345280 | 6 | libdeflate | 20.95 | 40.51 | 1.93 | 264.01 |
| silesia/xml | 5345280 | 6 | stdx | 17.38 | 34.32 | 1.98 | 498.84 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.32 | 89.17 | 1.53 | 369.84 |
| silesia/xml | 5345280 | 9 | stdx | 30.88 | 72.83 | 2.36 | 598.94 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.28 | 35.61 | 2.49 | 380.67 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.02 | 36.13 | 2.41 | 334.37 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.77 | 82.29 | 1.76 | 642.53 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.70 | 77.43 | 1.77 | 1317.67 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.35 | 159.21 | 1.48 | 849.71 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 73.01 | 167.73 | 2.30 | 1515.40 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.19 | 37.20 | 2.45 | 417.30 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.75 | 37.43 | 2.38 | 357.69 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.28 | 85.43 | 1.77 | 715.61 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.03 | 81.93 | 1.78 | 1372.64 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.81 | 136.15 | 1.53 | 941.41 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 75.84 | 175.98 | 2.32 | 1609.26 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.79 | 32.02 | 2.71 | 289.19 |
| canterbury/cp.html | 24603 | 1 | stdx | 10.98 | 27.13 | 2.47 | 245.72 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 27.06 | 62.33 | 2.30 | 493.19 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.74 | 57.06 | 2.40 | 620.53 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.94 | 91.97 | 1.96 | 603.36 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.45 | 88.89 | 2.83 | 643.39 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.51 | 35.92 | 3.78 | 62.87 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.06 | 30.06 | 3.73 | 21.16 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.53 | 69.37 | 2.83 | 243.68 |
| canterbury/fields.c | 11150 | 6 | stdx | 21.23 | 57.62 | 2.71 | 450.08 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.99 | 100.81 | 2.24 | 438.13 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.72 | 92.66 | 3.23 | 446.18 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.00 | 51.51 | 3.96 | 12.48 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.96 | 39.03 | 3.92 | 4.09 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.77 | 87.06 | 3.66 | 27.91 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.18 | 70.82 | 4.12 | 14.11 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 31.37 | 102.89 | 3.28 | 68.26 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.93 | 99.32 | 4.15 | 70.33 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.36 | 27.18 | 3.69 | 65.28 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.04 | 22.58 | 3.21 | 62.82 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.92 | 73.85 | 2.65 | 96.49 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.32 | 62.00 | 3.21 | 138.50 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.20 | 664.23 | 1.83 | 163.67 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.61 | 130.89 | 3.48 | 220.19 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.80 | 33.99 | 2.46 | 370.75 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.49 | 33.93 | 2.34 | 331.51 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.03 | 78.22 | 1.74 | 608.70 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.62 | 73.43 | 1.76 | 1226.14 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.62 | 136.94 | 1.49 | 802.97 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 70.74 | 162.25 | 2.29 | 1450.69 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.80 | 38.62 | 2.44 | 426.23 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.73 | 40.25 | 2.40 | 369.10 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.10 | 91.90 | 1.70 | 754.65 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.36 | 88.90 | 1.73 | 1485.60 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.82 | 166.26 | 1.42 | 1004.42 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 88.87 | 201.33 | 2.27 | 1805.92 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.43 | 18.61 | 2.89 | 141.81 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.99 | 11.03 | 2.21 | 124.09 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.26 | 36.17 | 2.54 | 220.04 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.34 | 29.58 | 2.40 | 311.60 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.43 | 120.86 | 2.00 | 374.05 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.20 | 130.09 | 3.01 | 641.57 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.79 | 33.49 | 2.62 | 336.09 |
| canterbury/sum | 38240 | 1 | stdx | 12.55 | 29.36 | 2.34 | 298.55 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.66 | 69.87 | 2.44 | 504.63 |
| canterbury/sum | 38240 | 6 | stdx | 26.79 | 65.74 | 2.45 | 666.34 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.22 | 181.91 | 1.93 | 610.06 |
| canterbury/sum | 38240 | 9 | stdx | 39.41 | 112.34 | 2.85 | 658.26 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.27 | 53.06 | 4.00 | 21.32 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.68 | 43.11 | 4.03 | 1.88 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.83 | 87.70 | 3.84 | 62.44 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 18.04 | 74.37 | 4.12 | 44.28 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 25.66 | 94.34 | 3.68 | 127.96 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.53 | 106.97 | 4.03 | 125.95 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.04 | 40.47 | 3.36 | 165.31 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.44 | 42.29 | 3.40 | 101.29 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.34 | 395.99 | 2.16 | 260.68 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.69 | 374.13 | 3.05 | 1897.79 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.83 | 1063.49 | 1.30 | 1317.75 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 229.31 | 755.68 | 3.30 | 2441.08 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.52 | 32.38 | 2.59 | 313.07 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.17 | 32.23 | 2.45 | 281.14 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 45.94 | 80.12 | 1.74 | 524.12 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 41.88 | 72.39 | 1.73 | 1263.82 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.56 | 200.28 | 1.41 | 742.36 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.07 | 170.21 | 2.24 | 1439.46 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.29 | 29.72 | 2.24 | 414.59 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.09 | 28.55 | 2.03 | 379.83 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 32.95 | 60.25 | 1.83 | 558.60 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 31.76 | 56.81 | 1.79 | 980.13 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.46 | 119.11 | 1.48 | 685.35 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 51.78 | 117.95 | 2.28 | 1146.39 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.42 | 103.92 | 2.93 | 452.33 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.42 | 58.69 | 2.74 | 365.15 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.13 | 138.34 | 3.00 | 563.20 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 32.02 | 94.36 | 2.95 | 530.96 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.64 | 142.44 | 2.99 | 587.64 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 36.11 | 112.18 | 3.11 | 536.66 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.45 | 27.96 | 2.68 | 267.05 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.03 | 20.25 | 2.24 | 234.42 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.44 | 52.09 | 2.32 | 402.76 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.84 | 42.87 | 2.28 | 538.18 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 35.00 | 72.54 | 2.07 | 471.80 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.95 | 69.06 | 2.77 | 551.17 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.77 | 23.03 | 2.63 | 224.37 |
| http/html-1m | 1048576 | 1 | stdx | 8.16 | 17.80 | 2.18 | 205.92 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.28 | 49.53 | 1.96 | 327.24 |
| http/html-1m | 1048576 | 6 | stdx | 21.15 | 40.71 | 1.92 | 621.17 |
| http/html-1m | 1048576 | 9 | libdeflate | 70.92 | 109.24 | 1.54 | 432.28 |
| http/html-1m | 1048576 | 9 | stdx | 35.75 | 85.76 | 2.40 | 705.93 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.80 | 94.80 | 2.98 | 301.64 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.57 | 45.22 | 2.73 | 242.42 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.00 | 126.60 | 2.94 | 372.42 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.17 | 78.43 | 2.89 | 376.71 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.04 | 142.45 | 2.74 | 429.05 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.77 | 95.61 | 3.11 | 384.78 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.85 | 23.85 | 3.04 | 134.33 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.45 | 13.94 | 2.56 | 110.63 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.19 | 46.61 | 2.56 | 205.86 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.41 | 35.02 | 2.61 | 278.04 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.10 | 151.99 | 1.90 | 296.46 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.27 | 58.45 | 3.03 | 301.86 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.73 | 19.85 | 2.95 | 124.55 |
| http/json-1m | 1048576 | 1 | stdx | 5.07 | 12.51 | 2.47 | 102.91 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.32 | 45.30 | 2.23 | 175.57 |
| http/json-1m | 1048576 | 6 | stdx | 14.65 | 35.09 | 2.39 | 294.83 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.31 | 205.21 | 1.69 | 275.25 |
| http/json-1m | 1048576 | 9 | stdx | 29.05 | 72.87 | 2.51 | 367.73 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.06 | 107.80 | 2.91 | 516.59 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.71 | 65.45 | 2.76 | 411.97 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.31 | 144.85 | 2.94 | 676.59 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 35.66 | 104.17 | 2.92 | 624.59 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.67 | 150.13 | 2.91 | 718.15 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 40.40 | 125.18 | 3.10 | 627.45 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.73 | 30.90 | 2.63 | 309.65 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.83 | 24.80 | 2.29 | 273.63 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 26.05 | 59.43 | 2.28 | 487.51 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.60 | 50.05 | 2.21 | 670.59 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.86 | 83.31 | 2.04 | 570.33 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.75 | 81.31 | 2.73 | 663.66 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.64 | 25.19 | 2.61 | 247.55 |
| http/js-1m | 1048576 | 1 | stdx | 9.53 | 21.31 | 2.24 | 233.34 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.73 | 56.12 | 1.95 | 371.30 |
| http/js-1m | 1048576 | 6 | stdx | 24.79 | 46.64 | 1.88 | 741.19 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.18 | 120.65 | 1.58 | 499.11 |
| http/js-1m | 1048576 | 9 | stdx | 41.95 | 100.01 | 2.38 | 812.96 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.24 | 97.74 | 2.94 | 375.24 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.35 | 49.57 | 2.70 | 299.61 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.78 | 129.23 | 2.95 | 477.72 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.04 | 82.37 | 2.84 | 501.42 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.73 | 133.80 | 2.93 | 506.61 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.18 | 99.53 | 3.00 | 521.62 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.65 | 25.60 | 2.96 | 174.20 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.66 | 16.96 | 2.55 | 134.68 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.27 | 48.80 | 2.41 | 293.68 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.36 | 38.01 | 2.32 | 457.63 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.85 | 82.40 | 2.02 | 375.29 |
| http/css-16kx64 | 1048576 | 9 | stdx | 23.10 | 65.14 | 2.82 | 478.71 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.96 | 21.15 | 3.04 | 133.22 |
| http/css-1m | 1048576 | 1 | stdx | 5.78 | 14.91 | 2.58 | 108.36 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.77 | 44.50 | 2.14 | 226.64 |
| http/css-1m | 1048576 | 6 | stdx | 16.52 | 35.61 | 2.16 | 441.73 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.60 | 111.58 | 1.60 | 309.29 |
| http/css-1m | 1048576 | 9 | stdx | 32.04 | 83.00 | 2.59 | 511.11 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.29 | 48.89 | 1.93 | 935.91 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.09 | 49.19 | 2.72 | 322.70 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.51 | 86.45 | 2.08 | 1177.02 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.68 | 88.80 | 2.24 | 855.00 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.01 | 94.50 | 2.01 | 1342.38 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 54.24 | 134.38 | 2.48 | 1136.97 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.00 | 31.22 | 3.12 | 119.62 |
| silesia/dickens | 10192446 | 1 | stdx | 24.16 | 82.03 | 3.40 | 126.67 |
| silesia/dickens | 10192446 | 3 | libzstd | 21.75 | 34.39 | 1.58 | 170.69 |
| silesia/dickens | 10192446 | 3 | stdx | 34.75 | 78.22 | 2.25 | 183.08 |
| silesia/mozilla | 51220480 | 1 | libzstd | 6.97 | 22.69 | 3.26 | 71.20 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.58 | 54.73 | 3.11 | 175.56 |
| silesia/mozilla | 51220480 | 3 | libzstd | 16.25 | 27.89 | 1.72 | 102.52 |
| silesia/mozilla | 51220480 | 3 | stdx | 29.90 | 62.01 | 2.07 | 145.75 |
| silesia/mr | 9970564 | 1 | libzstd | 7.60 | 24.81 | 3.26 | 58.36 |
| silesia/mr | 9970564 | 1 | stdx | 19.83 | 66.82 | 3.37 | 116.63 |
| silesia/mr | 9970564 | 3 | libzstd | 19.03 | 32.19 | 1.69 | 86.57 |
| silesia/mr | 9970564 | 3 | stdx | 32.61 | 72.46 | 2.22 | 116.15 |
| silesia/nci | 33553445 | 1 | libzstd | 3.46 | 9.55 | 2.76 | 57.14 |
| silesia/nci | 33553445 | 1 | stdx | 7.66 | 25.69 | 3.35 | 60.27 |
| silesia/nci | 33553445 | 3 | libzstd | 5.23 | 9.95 | 1.90 | 56.35 |
| silesia/nci | 33553445 | 3 | stdx | 10.99 | 29.15 | 2.65 | 66.94 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.51 | 29.26 | 3.44 | 72.03 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.00 | 72.51 | 3.15 | 181.14 |
| silesia/ooffice | 6152192 | 3 | libzstd | 22.48 | 39.44 | 1.75 | 119.81 |
| silesia/ooffice | 6152192 | 3 | stdx | 40.76 | 82.20 | 2.02 | 186.44 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.01 | 22.29 | 3.18 | 66.69 |
| silesia/osdb | 10085684 | 1 | stdx | 16.27 | 50.52 | 3.10 | 123.14 |
| silesia/osdb | 10085684 | 3 | libzstd | 16.96 | 26.23 | 1.55 | 67.88 |
| silesia/osdb | 10085684 | 3 | stdx | 30.89 | 57.87 | 1.87 | 111.54 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.67 | 27.13 | 2.81 | 150.62 |
| silesia/reymont | 6627202 | 1 | stdx | 20.04 | 72.05 | 3.60 | 97.25 |
| silesia/reymont | 6627202 | 3 | libzstd | 17.52 | 27.10 | 1.55 | 126.22 |
| silesia/reymont | 6627202 | 3 | stdx | 27.37 | 62.18 | 2.27 | 147.32 |
| silesia/samba | 21606400 | 1 | libzstd | 5.84 | 16.88 | 2.89 | 85.53 |
| silesia/samba | 21606400 | 1 | stdx | 13.42 | 42.89 | 3.20 | 126.42 |
| silesia/samba | 21606400 | 3 | libzstd | 11.42 | 18.81 | 1.65 | 98.67 |
| silesia/samba | 21606400 | 3 | stdx | 19.92 | 44.75 | 2.25 | 134.37 |
| silesia/sao | 7251944 | 1 | libzstd | 9.00 | 33.69 | 3.74 | 45.41 |
| silesia/sao | 7251944 | 1 | stdx | 25.83 | 82.03 | 3.18 | 104.51 |
| silesia/sao | 7251944 | 3 | libzstd | 29.57 | 50.03 | 1.69 | 94.73 |
| silesia/sao | 7251944 | 3 | stdx | 49.83 | 95.22 | 1.91 | 143.35 |
| silesia/webster | 41458703 | 1 | libzstd | 8.62 | 24.94 | 2.90 | 131.00 |
| silesia/webster | 41458703 | 1 | stdx | 20.29 | 64.04 | 3.16 | 167.78 |
| silesia/webster | 41458703 | 3 | libzstd | 18.42 | 27.33 | 1.48 | 176.64 |
| silesia/webster | 41458703 | 3 | stdx | 30.17 | 64.55 | 2.14 | 195.54 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.63 | 14.92 | 3.22 | 17.10 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.73 | 76.64 | 3.23 | 93.45 |
| silesia/x-ray | 8474240 | 3 | libzstd | 30.01 | 52.73 | 1.76 | 87.58 |
| silesia/x-ray | 8474240 | 3 | stdx | 46.29 | 92.40 | 2.00 | 106.42 |
| silesia/xml | 5345280 | 1 | libzstd | 4.19 | 11.71 | 2.80 | 71.05 |
| silesia/xml | 5345280 | 1 | stdx | 10.27 | 34.21 | 3.33 | 95.17 |
| silesia/xml | 5345280 | 3 | libzstd | 6.47 | 12.61 | 1.95 | 77.58 |
| silesia/xml | 5345280 | 3 | stdx | 12.47 | 32.28 | 2.59 | 116.27 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.77 | 32.84 | 3.05 | 139.01 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.35 | 76.49 | 3.42 | 190.46 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.55 | 39.48 | 2.54 | 204.39 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.39 | 73.76 | 2.80 | 340.41 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.71 | 33.55 | 3.45 | 102.07 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.60 | 79.00 | 3.35 | 219.81 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.25 | 39.27 | 2.57 | 210.78 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.13 | 79.30 | 2.82 | 380.19 |
| canterbury/cp.html | 24603 | 1 | libzstd | 7.04 | 26.64 | 3.78 | 43.20 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.15 | 57.76 | 3.58 | 122.21 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.52 | 31.85 | 3.35 | 46.07 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.46 | 59.76 | 3.24 | 154.98 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.73 | 31.76 | 3.64 | 44.00 |
| canterbury/fields.c | 11150 | 1 | stdx | 17.03 | 65.73 | 3.86 | 89.36 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.30 | 34.14 | 3.67 | 26.76 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.54 | 64.68 | 3.69 | 99.41 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.55 | 38.01 | 3.98 | 12.80 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.26 | 77.57 | 3.83 | 53.46 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.67 | 43.09 | 4.04 | 6.75 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.48 | 79.60 | 3.71 | 70.60 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.01 | 23.56 | 3.92 | 14.63 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.66 | 56.75 | 3.87 | 87.25 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.32 | 23.80 | 2.86 | 27.49 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 19.99 | 56.61 | 2.83 | 111.18 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.82 | 28.52 | 2.90 | 155.34 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.31 | 72.02 | 3.38 | 162.55 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 16.13 | 32.14 | 1.99 | 202.28 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.21 | 67.10 | 2.56 | 299.31 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.32 | 32.37 | 3.14 | 129.20 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 24.95 | 84.16 | 3.37 | 160.79 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 19.85 | 38.77 | 1.95 | 226.74 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 31.48 | 80.77 | 2.57 | 347.02 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.16 | 8.51 | 2.69 | 67.43 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.53 | 23.15 | 3.08 | 106.37 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 4.79 | 10.97 | 2.29 | 59.16 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.39 | 24.08 | 2.56 | 133.77 |
| canterbury/sum | 38240 | 1 | libzstd | 6.57 | 25.39 | 3.86 | 33.35 |
| canterbury/sum | 38240 | 1 | stdx | 17.01 | 59.13 | 3.48 | 154.29 |
| canterbury/sum | 38240 | 3 | libzstd | 9.10 | 30.67 | 3.37 | 48.39 |
| canterbury/sum | 38240 | 3 | stdx | 20.06 | 61.82 | 3.08 | 191.51 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 10.00 | 39.82 | 3.98 | 13.16 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.90 | 80.38 | 3.85 | 60.34 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.23 | 48.17 | 3.94 | 16.73 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 23.07 | 83.98 | 3.64 | 82.29 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.32 | 33.44 | 3.24 | 76.87 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.67 | 95.62 | 4.41 | 7.28 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 14.86 | 31.30 | 2.11 | 35.83 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.35 | 70.38 | 3.01 | 38.36 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.65 | 27.45 | 2.84 | 148.60 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.23 | 71.86 | 3.55 | 108.69 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 17.52 | 28.20 | 1.61 | 132.66 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 27.30 | 63.36 | 2.32 | 155.83 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.11 | 22.70 | 2.80 | 136.53 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.55 | 55.86 | 3.01 | 195.75 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 15.00 | 23.87 | 1.59 | 173.98 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 24.64 | 51.26 | 2.08 | 238.14 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.06 | 52.46 | 3.07 | 159.63 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.74 | 100.54 | 2.81 | 644.49 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.06 | 59.20 | 3.11 | 197.31 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 37.96 | 104.00 | 2.74 | 639.77 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.69 | 22.46 | 2.92 | 121.86 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.13 | 46.84 | 3.32 | 184.03 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.74 | 24.61 | 2.82 | 141.49 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.21 | 47.61 | 3.13 | 193.84 |
| http/html-1m | 1048576 | 1 | libzstd | 6.21 | 16.74 | 2.70 | 114.45 |
| http/html-1m | 1048576 | 1 | stdx | 12.89 | 42.00 | 3.26 | 136.23 |
| http/html-1m | 1048576 | 3 | libzstd | 9.12 | 18.18 | 1.99 | 125.69 |
| http/html-1m | 1048576 | 3 | stdx | 15.61 | 39.37 | 2.52 | 178.50 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.35 | 42.52 | 2.96 | 115.48 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.49 | 83.13 | 2.82 | 537.40 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.83 | 44.54 | 3.00 | 129.06 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.61 | 84.87 | 2.77 | 542.34 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.80 | 14.98 | 3.12 | 57.53 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.68 | 33.78 | 3.49 | 117.92 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.33 | 16.21 | 3.04 | 72.25 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.63 | 34.58 | 3.25 | 123.93 |
| http/json-1m | 1048576 | 1 | libzstd | 4.03 | 12.55 | 3.11 | 52.42 |
| http/json-1m | 1048576 | 1 | stdx | 8.98 | 30.70 | 3.42 | 86.85 |
| http/json-1m | 1048576 | 3 | libzstd | 6.06 | 13.78 | 2.27 | 68.43 |
| http/json-1m | 1048576 | 3 | stdx | 11.24 | 30.64 | 2.73 | 121.38 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.55 | 57.26 | 3.09 | 183.91 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 39.89 | 113.49 | 2.85 | 703.79 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.43 | 65.54 | 3.06 | 260.53 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 41.94 | 116.54 | 2.78 | 694.98 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.82 | 26.52 | 3.01 | 127.71 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.58 | 55.71 | 3.36 | 202.45 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.08 | 28.74 | 2.85 | 157.92 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.57 | 55.35 | 3.15 | 212.58 |
| http/js-1m | 1048576 | 1 | libzstd | 6.53 | 17.87 | 2.74 | 113.67 |
| http/js-1m | 1048576 | 1 | stdx | 13.94 | 45.88 | 3.29 | 137.78 |
| http/js-1m | 1048576 | 3 | libzstd | 9.80 | 19.14 | 1.95 | 124.45 |
| http/js-1m | 1048576 | 3 | stdx | 16.75 | 41.25 | 2.46 | 188.44 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.56 | 46.90 | 3.01 | 136.39 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.21 | 91.65 | 2.85 | 584.81 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.65 | 50.53 | 3.04 | 158.89 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.51 | 93.63 | 2.79 | 587.65 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.11 | 18.99 | 3.11 | 78.72 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.41 | 43.79 | 3.53 | 138.12 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.56 | 19.41 | 2.96 | 96.67 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.80 | 42.34 | 3.31 | 154.17 |
| http/css-1m | 1048576 | 1 | libzstd | 1.49 | 4.59 | 3.08 | 21.90 |
| http/css-1m | 1048576 | 1 | stdx | 3.98 | 14.85 | 3.73 | 30.47 |
| http/css-1m | 1048576 | 3 | libzstd | 1.94 | 5.25 | 2.70 | 19.67 |
| http/css-1m | 1048576 | 3 | stdx | 3.95 | 13.33 | 3.37 | 32.01 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.51 | 12.79 | 3.65 | 6.39 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.12 | 30.66 | 3.36 | 62.92 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 26.77 | 50.53 | 1.89 | 51.00 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 20.59 | 47.43 | 2.30 | 213.86 |

## Hardware counters per input octet, brotli encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | Google q1 | 17.97 | 30.24 | 1.68 | 231.91 |
| silesia/dickens | 10192446 | stdx 1 | 19.37 | 43.43 | 2.24 | 413.61 |
| silesia/dickens | 10192446 | Google q5 | 103.50 | 194.36 | 1.88 | 823.69 |
| silesia/dickens | 10192446 | stdx 5 | 70.85 | 155.43 | 2.19 | 992.14 |
| silesia/mozilla | 51220480 | Google q1 | 12.97 | 25.26 | 1.95 | 145.03 |
| silesia/mozilla | 51220480 | stdx 1 | 12.32 | 32.95 | 2.68 | 213.60 |
| silesia/mozilla | 51220480 | Google q5 | 62.79 | 149.30 | 2.38 | 800.05 |
| silesia/mozilla | 51220480 | stdx 5 | 58.94 | 148.04 | 2.51 | 814.13 |
| silesia/mr | 9970564 | Google q1 | 13.00 | 26.14 | 2.01 | 98.00 |
| silesia/mr | 9970564 | stdx 1 | 13.58 | 37.80 | 2.78 | 165.09 |
| silesia/mr | 9970564 | Google q5 | 81.74 | 177.41 | 2.17 | 608.26 |
| silesia/mr | 9970564 | stdx 5 | 66.12 | 149.01 | 2.25 | 703.86 |
| silesia/nci | 33553445 | Google q1 | 5.27 | 9.71 | 1.84 | 89.06 |
| silesia/nci | 33553445 | stdx 1 | 6.03 | 14.48 | 2.40 | 127.46 |
| silesia/nci | 33553445 | Google q5 | 30.84 | 59.01 | 1.91 | 410.72 |
| silesia/nci | 33553445 | stdx 5 | 29.72 | 58.51 | 1.97 | 486.79 |
| silesia/ooffice | 6152192 | Google q1 | 17.11 | 33.43 | 1.95 | 154.66 |
| silesia/ooffice | 6152192 | stdx 1 | 16.85 | 45.85 | 2.72 | 267.53 |
| silesia/ooffice | 6152192 | Google q5 | 89.23 | 198.80 | 2.23 | 1069.43 |
| silesia/ooffice | 6152192 | stdx 5 | 73.06 | 178.18 | 2.44 | 1075.17 |
| silesia/osdb | 10085684 | Google q1 | 12.29 | 23.47 | 1.91 | 85.21 |
| silesia/osdb | 10085684 | stdx 1 | 11.66 | 32.00 | 2.74 | 141.28 |
| silesia/osdb | 10085684 | Google q5 | 68.98 | 146.01 | 2.12 | 548.82 |
| silesia/osdb | 10085684 | stdx 5 | 52.47 | 123.53 | 2.35 | 522.89 |
| silesia/reymont | 6627202 | Google q1 | 15.29 | 25.54 | 1.67 | 208.23 |
| silesia/reymont | 6627202 | stdx 1 | 14.32 | 33.36 | 2.33 | 283.88 |
| silesia/reymont | 6627202 | Google q5 | 80.67 | 169.16 | 2.10 | 801.62 |
| silesia/reymont | 6627202 | stdx 5 | 62.49 | 139.71 | 2.24 | 904.23 |
| silesia/samba | 21606400 | Google q1 | 9.78 | 17.38 | 1.78 | 127.40 |
| silesia/samba | 21606400 | stdx 1 | 9.85 | 23.94 | 2.43 | 196.86 |
| silesia/samba | 21606400 | Google q5 | 47.47 | 105.54 | 2.22 | 479.81 |
| silesia/samba | 21606400 | stdx 5 | 42.80 | 102.32 | 2.39 | 530.84 |
| silesia/sao | 7251944 | Google q1 | 20.21 | 39.96 | 1.98 | 100.67 |
| silesia/sao | 7251944 | stdx 1 | 18.65 | 55.66 | 2.98 | 190.05 |
| silesia/sao | 7251944 | Google q5 | 112.25 | 259.63 | 2.31 | 932.11 |
| silesia/sao | 7251944 | stdx 5 | 86.49 | 229.67 | 2.66 | 755.56 |
| silesia/webster | 41458703 | Google q1 | 14.40 | 24.40 | 1.69 | 206.92 |
| silesia/webster | 41458703 | stdx 1 | 15.31 | 34.12 | 2.23 | 339.26 |
| silesia/webster | 41458703 | Google q5 | 76.20 | 141.82 | 1.86 | 756.78 |
| silesia/webster | 41458703 | stdx 5 | 61.32 | 121.03 | 1.97 | 852.26 |
| silesia/x-ray | 8474240 | Google q1 | 13.83 | 22.03 | 1.59 | 12.26 |
| silesia/x-ray | 8474240 | stdx 1 | 13.05 | 38.68 | 2.96 | 95.06 |
| silesia/x-ray | 8474240 | Google q5 | 103.09 | 236.76 | 2.30 | 725.06 |
| silesia/x-ray | 8474240 | stdx 5 | 83.31 | 226.78 | 2.72 | 645.28 |
| silesia/xml | 5345280 | Google q1 | 7.00 | 12.28 | 1.76 | 113.14 |
| silesia/xml | 5345280 | stdx 1 | 7.29 | 17.44 | 2.39 | 153.74 |
| silesia/xml | 5345280 | Google q5 | 31.63 | 72.50 | 2.29 | 359.02 |
| silesia/xml | 5345280 | stdx 5 | 28.98 | 64.66 | 2.23 | 413.53 |
| canterbury/alice29.txt | 152089 | Google q1 | 17.18 | 29.72 | 1.73 | 209.53 |
| canterbury/alice29.txt | 152089 | stdx 1 | 18.35 | 40.79 | 2.22 | 445.80 |
| canterbury/alice29.txt | 152089 | Google q5 | 79.01 | 200.77 | 2.54 | 1040.43 |
| canterbury/alice29.txt | 152089 | stdx 5 | 67.01 | 150.37 | 2.24 | 908.87 |
| canterbury/asyoulik.txt | 125179 | Google q1 | 17.86 | 32.37 | 1.81 | 223.63 |
| canterbury/asyoulik.txt | 125179 | stdx 1 | 20.05 | 44.50 | 2.22 | 498.19 |
| canterbury/asyoulik.txt | 125179 | Google q5 | 84.37 | 215.27 | 2.55 | 1081.45 |
| canterbury/asyoulik.txt | 125179 | stdx 5 | 74.37 | 162.29 | 2.18 | 1047.44 |
| canterbury/cp.html | 24603 | Google q1 | 12.90 | 27.30 | 2.12 | 90.50 |
| canterbury/cp.html | 24603 | stdx 1 | 14.56 | 36.07 | 2.48 | 347.75 |
| canterbury/cp.html | 24603 | Google q5 | 61.42 | 163.89 | 2.67 | 947.73 |
| canterbury/cp.html | 24603 | stdx 5 | 56.72 | 131.75 | 2.32 | 729.62 |
| canterbury/fields.c | 11150 | Google q1 | 12.04 | 29.04 | 2.41 | 10.57 |
| canterbury/fields.c | 11150 | stdx 1 | 10.48 | 38.87 | 3.71 | 86.49 |
| canterbury/fields.c | 11150 | Google q5 | 59.35 | 168.16 | 2.83 | 908.77 |
| canterbury/fields.c | 11150 | stdx 5 | 44.11 | 123.30 | 2.80 | 547.44 |
| canterbury/grammar.lsp | 3721 | Google q1 | 14.32 | 39.39 | 2.75 | 6.37 |
| canterbury/grammar.lsp | 3721 | stdx 1 | 13.51 | 55.22 | 4.09 | 30.54 |
| canterbury/grammar.lsp | 3721 | Google q5 | 60.50 | 203.91 | 3.37 | 439.85 |
| canterbury/grammar.lsp | 3721 | stdx 5 | 41.22 | 148.73 | 3.61 | 150.41 |
| canterbury/kennedy.xls | 1029744 | Google q1 | 9.81 | 24.83 | 2.53 | 59.61 |
| canterbury/kennedy.xls | 1029744 | stdx 1 | 7.77 | 27.03 | 3.48 | 76.36 |
| canterbury/kennedy.xls | 1029744 | Google q5 | 46.96 | 162.91 | 3.47 | 262.28 |
| canterbury/kennedy.xls | 1029744 | stdx 5 | 51.65 | 162.45 | 3.15 | 473.96 |
| canterbury/lcet10.txt | 426754 | Google q1 | 16.01 | 27.19 | 1.70 | 200.96 |
| canterbury/lcet10.txt | 426754 | stdx 1 | 16.75 | 37.84 | 2.26 | 378.20 |
| canterbury/lcet10.txt | 426754 | Google q5 | 76.52 | 187.58 | 2.45 | 957.01 |
| canterbury/lcet10.txt | 426754 | stdx 5 | 64.14 | 140.50 | 2.19 | 911.09 |
| canterbury/plrabn12.txt | 481861 | Google q1 | 18.93 | 32.57 | 1.72 | 250.02 |
| canterbury/plrabn12.txt | 481861 | stdx 1 | 20.80 | 46.66 | 2.24 | 472.22 |
| canterbury/plrabn12.txt | 481861 | Google q5 | 94.11 | 229.77 | 2.44 | 1068.50 |
| canterbury/plrabn12.txt | 481861 | stdx 5 | 80.46 | 168.65 | 2.10 | 1191.40 |
| canterbury/ptt5 | 513216 | Google q1 | 5.03 | 9.55 | 1.90 | 80.10 |
| canterbury/ptt5 | 513216 | stdx 1 | 6.65 | 15.64 | 2.35 | 160.59 |
| canterbury/ptt5 | 513216 | Google q5 | 27.21 | 68.87 | 2.53 | 468.44 |
| canterbury/ptt5 | 513216 | stdx 5 | 29.44 | 69.96 | 2.38 | 468.92 |
| canterbury/sum | 38240 | Google q1 | 13.01 | 29.25 | 2.25 | 94.05 |
| canterbury/sum | 38240 | stdx 1 | 15.44 | 36.37 | 2.36 | 399.02 |
| canterbury/sum | 38240 | Google q5 | 65.19 | 182.58 | 2.80 | 1094.38 |
| canterbury/sum | 38240 | stdx 5 | 64.55 | 159.26 | 2.47 | 855.54 |
| canterbury/xargs.1 | 4227 | Google q1 | 16.30 | 43.16 | 2.65 | 14.04 |
| canterbury/xargs.1 | 4227 | stdx 1 | 14.89 | 59.10 | 3.97 | 50.93 |
| canterbury/xargs.1 | 4227 | Google q5 | 70.08 | 219.02 | 3.13 | 748.45 |
| canterbury/xargs.1 | 4227 | stdx 5 | 47.13 | 159.53 | 3.38 | 255.81 |
| canterbury-large/E.coli | 4638690 | Google q1 | 13.60 | 27.46 | 2.02 | 53.48 |
| canterbury-large/E.coli | 4638690 | stdx 1 | 5.52 | 19.24 | 3.48 | 17.84 |
| canterbury-large/E.coli | 4638690 | Google q5 | 89.76 | 262.67 | 2.93 | 997.84 |
| canterbury-large/E.coli | 4638690 | stdx 5 | 31.47 | 93.28 | 2.96 | 64.26 |
| canterbury-large/bible.txt | 4047392 | Google q1 | 14.64 | 24.57 | 1.68 | 175.27 |
| canterbury-large/bible.txt | 4047392 | stdx 1 | 15.17 | 34.29 | 2.26 | 316.95 |
| canterbury-large/bible.txt | 4047392 | Google q5 | 80.43 | 165.65 | 2.06 | 733.12 |
| canterbury-large/bible.txt | 4047392 | stdx 5 | 58.76 | 134.16 | 2.28 | 808.07 |
| canterbury-large/world192.txt | 2473400 | Google q1 | 13.45 | 22.62 | 1.68 | 195.19 |
| canterbury-large/world192.txt | 2473400 | stdx 1 | 13.61 | 31.07 | 2.28 | 313.22 |
| canterbury-large/world192.txt | 2473400 | Google q5 | 69.26 | 129.46 | 1.87 | 744.38 |
| canterbury-large/world192.txt | 2473400 | stdx 5 | 53.27 | 105.07 | 1.97 | 774.94 |
| http/html-1kx1024 | 1048576 | Google q1 | 32.32 | 62.53 | 1.93 | 863.28 |
| http/html-1kx1024 | 1048576 | stdx 1 | 27.29 | 80.73 | 2.96 | 472.30 |
| http/html-1kx1024 | 1048576 | Google q5 | 105.80 | 260.90 | 2.47 | 2117.61 |
| http/html-1kx1024 | 1048576 | stdx 5 | 67.82 | 169.39 | 2.50 | 1179.36 |
| http/html-16kx64 | 1048576 | Google q1 | 11.32 | 20.38 | 1.80 | 216.13 |
| http/html-16kx64 | 1048576 | stdx 1 | 11.48 | 28.46 | 2.48 | 302.47 |
| http/html-16kx64 | 1048576 | Google q5 | 47.33 | 118.53 | 2.50 | 859.85 |
| http/html-16kx64 | 1048576 | stdx 5 | 40.52 | 92.79 | 2.29 | 669.46 |
| http/html-1m | 1048576 | Google q1 | 8.91 | 15.15 | 1.70 | 137.60 |
| http/html-1m | 1048576 | stdx 1 | 9.62 | 22.18 | 2.31 | 224.43 |
| http/html-1m | 1048576 | Google q5 | 45.79 | 104.93 | 2.29 | 576.45 |
| http/html-1m | 1048576 | stdx 5 | 36.60 | 84.09 | 2.30 | 544.58 |
| http/json-1kx1024 | 1048576 | Google q1 | 24.71 | 49.87 | 2.02 | 652.48 |
| http/json-1kx1024 | 1048576 | stdx 1 | 20.95 | 61.64 | 2.94 | 364.92 |
| http/json-1kx1024 | 1048576 | Google q5 | 78.97 | 203.15 | 2.57 | 1338.80 |
| http/json-1kx1024 | 1048576 | stdx 5 | 49.88 | 132.48 | 2.66 | 735.95 |
| http/json-16kx64 | 1048576 | Google q1 | 7.64 | 14.90 | 1.95 | 141.38 |
| http/json-16kx64 | 1048576 | stdx 1 | 7.02 | 19.73 | 2.81 | 158.38 |
| http/json-16kx64 | 1048576 | Google q5 | 36.22 | 97.81 | 2.70 | 559.53 |
| http/json-16kx64 | 1048576 | stdx 5 | 35.77 | 89.00 | 2.49 | 532.58 |
| http/json-1m | 1048576 | Google q1 | 6.20 | 12.65 | 2.04 | 91.84 |
| http/json-1m | 1048576 | stdx 1 | 6.62 | 17.21 | 2.60 | 139.58 |
| http/json-1m | 1048576 | Google q5 | 36.77 | 96.08 | 2.61 | 446.91 |
| http/json-1m | 1048576 | stdx 5 | 38.63 | 92.44 | 2.39 | 574.20 |
| http/js-1kx1024 | 1048576 | Google q1 | 34.94 | 68.18 | 1.95 | 908.85 |
| http/js-1kx1024 | 1048576 | stdx 1 | 30.33 | 90.40 | 2.98 | 529.87 |
| http/js-1kx1024 | 1048576 | Google q5 | 115.85 | 288.57 | 2.49 | 2311.45 |
| http/js-1kx1024 | 1048576 | stdx 5 | 75.59 | 188.24 | 2.49 | 1320.34 |
| http/js-16kx64 | 1048576 | Google q1 | 13.14 | 24.07 | 1.83 | 230.80 |
| http/js-16kx64 | 1048576 | stdx 1 | 13.33 | 32.69 | 2.45 | 354.47 |
| http/js-16kx64 | 1048576 | Google q5 | 55.59 | 141.15 | 2.54 | 1000.97 |
| http/js-16kx64 | 1048576 | stdx 5 | 47.20 | 107.16 | 2.27 | 787.14 |
| http/js-1m | 1048576 | Google q1 | 9.68 | 16.69 | 1.72 | 141.06 |
| http/js-1m | 1048576 | stdx 1 | 10.13 | 23.55 | 2.32 | 229.92 |
| http/js-1m | 1048576 | Google q5 | 51.35 | 116.02 | 2.26 | 637.75 |
| http/js-1m | 1048576 | stdx 5 | 39.10 | 90.08 | 2.30 | 591.45 |
| http/css-1kx1024 | 1048576 | Google q1 | 27.72 | 54.06 | 1.95 | 732.42 |
| http/css-1kx1024 | 1048576 | stdx 1 | 23.54 | 68.32 | 2.90 | 432.33 |
| http/css-1kx1024 | 1048576 | Google q5 | 86.16 | 213.92 | 2.48 | 1666.23 |
| http/css-1kx1024 | 1048576 | stdx 5 | 53.45 | 139.00 | 2.60 | 907.40 |
| http/css-16kx64 | 1048576 | Google q1 | 9.01 | 16.85 | 1.87 | 141.08 |
| http/css-16kx64 | 1048576 | stdx 1 | 8.48 | 23.62 | 2.79 | 193.24 |
| http/css-16kx64 | 1048576 | Google q5 | 37.66 | 100.68 | 2.67 | 647.44 |
| http/css-16kx64 | 1048576 | stdx 5 | 31.51 | 81.52 | 2.59 | 495.78 |
| http/css-1m | 1048576 | Google q1 | 6.00 | 11.27 | 1.88 | 75.91 |
| http/css-1m | 1048576 | stdx 1 | 5.43 | 14.38 | 2.65 | 110.42 |
| http/css-1m | 1048576 | Google q5 | 14.37 | 38.50 | 2.68 | 130.11 |
| http/css-1m | 1048576 | stdx 5 | 14.21 | 36.87 | 2.59 | 111.10 |
| shuffled/dickens-1m | 1048576 | Google q1 | 11.43 | 20.96 | 1.83 | 2.82 |
| shuffled/dickens-1m | 1048576 | stdx 1 | 5.31 | 19.75 | 3.72 | 16.58 |
| shuffled/dickens-1m | 1048576 | Google q5 | 100.12 | 235.57 | 2.35 | 725.65 |
| shuffled/dickens-1m | 1048576 | stdx 5 | 44.60 | 123.05 | 2.76 | 253.89 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.116 | 3.00 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 66.6 | 219.6 | 0.090 | 7.87 | 3.30 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 30.6 | 96.1 | 0.162 | 3.62 | 3.14 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextReader.next_items | 29.3 | 80.8 | 0.152 | 3.46 | 2.76 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 250.4 | 1024.0 | 0.828 | 29.58 | 4.09 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.9 | 107.7 | 0.135 | 3.65 | 3.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.8 | 106.2 | 0.295 | 3.28 | 3.82 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 93.3 | 378.2 | 0.386 | 11.02 | 4.05 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.9 | 161.9 | 0.469 | 5.07 | 3.77 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 90.8 | 451.7 | 0.306 | 10.73 | 4.97 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 26.9 | 89.5 | 0.004 | 3.95 | 3.33 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.3 | 234.7 | 0.043 | 10.05 | 3.44 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 29.1 | 99.4 | 0.011 | 4.29 | 3.41 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextReader.next_items | 28.2 | 84.2 | 0.009 | 4.15 | 2.98 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 213.8 | 819.1 | 0.962 | 31.47 | 3.83 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.2 | 107.7 | 0.039 | 4.16 | 3.81 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 27.8 | 106.0 | 0.047 | 4.10 | 3.81 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 92.1 | 346.2 | 0.321 | 13.55 | 3.76 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 31.8 | 144.5 | 0.052 | 4.68 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 89.2 | 406.5 | 0.079 | 13.13 | 4.56 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 41.5 | 96.3 | 0.195 | 3.89 | 2.32 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 86.4 | 249.4 | 0.232 | 8.09 | 2.89 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 45.9 | 113.8 | 0.285 | 4.30 | 2.48 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextReader.next_items | 44.2 | 99.4 | 0.213 | 4.14 | 2.25 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 311.7 | 1284.6 | 1.041 | 29.19 | 4.12 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 36.5 | 133.1 | 0.195 | 3.41 | 3.65 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 45.6 | 128.6 | 0.711 | 4.27 | 2.82 |
| messages: 11 string members | 96000 | 1025025 | std.json | 121.0 | 451.2 | 1.074 | 11.33 | 3.73 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 67.5 | 204.1 | 1.009 | 6.32 | 3.02 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 134.6 | 572.0 | 0.847 | 12.61 | 4.25 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 24.2 | 78.8 | 0.018 | 3.03 | 3.26 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 67.3 | 239.5 | 0.006 | 8.42 | 3.56 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 27.9 | 93.3 | 0.043 | 3.49 | 3.35 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextReader.next_items | 26.8 | 78.0 | 0.033 | 3.36 | 2.91 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 232.1 | 942.3 | 0.392 | 29.06 | 4.06 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 27.9 | 107.6 | 0.035 | 3.50 | 3.85 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 25.3 | 104.8 | 0.022 | 3.17 | 4.14 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 85.7 | 361.0 | 0.029 | 10.73 | 4.21 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 32.8 | 151.6 | 0.057 | 4.11 | 4.62 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 80.6 | 418.3 | 0.008 | 10.09 | 5.19 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114001.8 | 403846.2 | 481.485 | 0.66 | 3.54 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 602784.9 | 2503286.2 | 1395.258 | 3.49 | 4.15 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 113689.0 | 404249.2 | 457.887 | 0.66 | 3.56 |
| string: silesia/dickens | 1 | 172528 | stdx, TextReader.next_items | 114073.6 | 404282.2 | 460.918 | 0.66 | 3.54 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3582665.2 | 18223876.2 | 2977.918 | 20.77 | 5.09 |
| string: silesia/dickens | 1 | 172528 | simdjson | 312129.4 | 621744.2 | 636.722 | 1.81 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 225278.6 | 826630.2 | 2240.990 | 1.31 | 3.67 |
| string: silesia/dickens | 1 | 172528 | std.json | 1578734.6 | 4578768.2 | 43184.866 | 9.15 | 2.90 |
| string: silesia/dickens | 1 | 172528 | serde_json | 203526.7 | 802909.2 | 975.165 | 1.18 | 3.94 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1039735.5 | 5283265.7 | 4951.371 | 6.03 | 5.08 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1560284.0 | 4799769.6 | 1235.000 | 1.31 | 3.08 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14821912.0 | 56410893.6 | 39262.929 | 12.45 | 3.81 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1558367.6 | 4799955.6 | 1091.286 | 1.31 | 3.08 |
| string: http/json-1m | 1 | 1190272 | stdx, TextReader.next_items | 1557461.1 | 4799988.6 | 1062.071 | 1.31 | 3.08 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 28999583.3 | 132108259.6 | 160447.214 | 24.36 | 4.56 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4585594.7 | 7062781.6 | 546.571 | 3.85 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1792954.0 | 7322029.6 | 14636.786 | 1.51 | 4.08 |
| string: http/json-1m | 1 | 1190272 | std.json | 10342009.1 | 47381157.6 | 33350.857 | 8.69 | 4.58 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3845861.4 | 15226584.6 | 6106.357 | 3.23 | 3.96 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 8928428.1 | 47988114.6 | 27793.000 | 7.50 | 5.37 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2064237.3 | 5765419.8 | 4300.750 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6248431.3 | 22538840.8 | 6977.500 | 3.32 | 3.61 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2053399.0 | 5765605.8 | 3742.375 | 1.09 | 2.81 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextReader.next_items | 2053933.3 | 5765638.8 | 3626.500 | 1.09 | 2.81 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47141684.3 | 227842326.8 | 278589.875 | 25.03 | 4.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3759752.0 | 8446023.8 | 1929.875 | 2.00 | 2.25 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7134458.3 | 12276717.8 | 276847.000 | 3.79 | 1.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17440080.8 | 63617055.8 | 286013.875 | 9.26 | 3.65 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9486233.5 | 24440998.8 | 328223.375 | 5.04 | 2.58 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39030563.1 | 160312868.9 | 801207.250 | 20.73 | 4.11 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12926058.0 | 42561075.3 | 245240.667 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 172405143.0 | 666700955.3 | 392112.000 | 33.97 | 3.87 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12903162.0 | 42561261.3 | 243733.667 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextReader.next_items | 12910901.3 | 42561294.3 | 243964.667 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 153762416.0 | 639992668.3 | 423840.667 | 30.30 | 4.16 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17553090.3 | 49745820.3 | 253372.667 | 3.46 | 2.83 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 13991352.7 | 45615166.3 | 432005.667 | 2.76 | 3.26 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 80340175.0 | 314900845.3 | 475203.000 | 15.83 | 3.92 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36724224.7 | 131556418.3 | 583101.000 | 7.24 | 3.58 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66191545.3 | 273934153.0 | 834900.667 | 13.04 | 4.14 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 93275.9 | 303842.7 | 6.645 | 0.18 | 3.26 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 189633.9 | 623466.7 | 7.097 | 0.36 | 3.29 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 148133.7 | 557622.7 | 4.258 | 0.28 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextReader.next_items | 148069.5 | 557626.7 | 8.839 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10228933.9 | 53478208.7 | 8.065 | 19.51 | 5.23 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 489303.3 | 1376733.7 | 5.613 | 0.93 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 537297.9 | 2195917.7 | 7.935 | 1.02 | 4.09 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3354493.8 | 12808414.7 | 60970.194 | 6.40 | 3.82 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 295071.4 | 1179969.7 | 6.000 | 0.56 | 4.00 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2238418.3 | 12789173.6 | 249.258 | 4.27 | 5.71 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.5 | 81.8 | 0.108 | 2.30 | 4.20 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.2 | 153.5 | 0.135 | 4.15 | 4.37 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 21.3 | 94.0 | 0.091 | 2.52 | 4.42 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 217.4 | 981.0 | 0.927 | 25.68 | 4.51 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 18.6 | 79.5 | 0.104 | 2.19 | 4.28 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.0 | 94.1 | 0.135 | 2.72 | 4.09 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.4 | 105.6 | 0.248 | 3.23 | 3.86 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.0 | 310.8 | 0.362 | 8.15 | 4.50 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.6 | 255.3 | 0.515 | 7.51 | 4.02 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.4 | 315.1 | 0.234 | 8.08 | 4.61 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.5 | 82.8 | 0.024 | 2.73 | 4.46 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 35.9 | 153.9 | 0.025 | 5.28 | 4.29 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 22.4 | 94.9 | 0.024 | 3.30 | 4.24 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 170.3 | 718.3 | 1.292 | 25.06 | 4.22 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 17.8 | 81.5 | 0.024 | 2.61 | 4.59 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.8 | 96.8 | 0.032 | 3.20 | 4.45 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.3 | 117.9 | 0.033 | 4.31 | 4.03 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.7 | 271.2 | 0.243 | 8.79 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 48.8 | 213.2 | 0.041 | 7.18 | 4.37 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 83.8 | 331.7 | 0.084 | 12.33 | 3.96 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim on | 30.6 | 85.9 | 0.392 | 2.87 | 2.81 |
| messages: 11 string members | 96000 | 1025025 | stdx, one token a call | 42.9 | 151.2 | 0.429 | 4.02 | 3.53 |
| messages: 11 string members | 96000 | 1025025 | stdx, TextWriter's methods or TextReader.next | 28.8 | 93.1 | 0.392 | 2.70 | 3.23 |
| messages: 11 string members | 96000 | 1025025 | stdx, every claim off | 274.4 | 1195.0 | 1.244 | 25.70 | 4.36 |
| messages: 11 string members | 96000 | 1025025 | stdx, J11's loop unchecked | 28.9 | 82.8 | 0.384 | 2.71 | 2.86 |
| messages: 11 string members | 96000 | 1025025 | simdjson | 37.9 | 119.1 | 0.569 | 3.55 | 3.14 |
| messages: 11 string members | 96000 | 1025025 | yyjson | 46.7 | 138.2 | 0.692 | 4.37 | 2.96 |
| messages: 11 string members | 96000 | 1025025 | std.json | 99.4 | 370.8 | 1.068 | 9.31 | 3.73 |
| messages: 11 string members | 96000 | 1025025 | serde_json | 88.0 | 315.4 | 0.772 | 8.24 | 3.58 |
| messages: 11 string members | 96000 | 1025025 | Go jsontext | 106.7 | 400.7 | 0.849 | 9.99 | 3.76 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim on | 19.6 | 80.2 | 0.007 | 2.45 | 4.09 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, one token a call | 37.9 | 152.5 | 0.006 | 4.75 | 4.02 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, TextWriter's methods or TextReader.next | 21.8 | 93.8 | 0.006 | 2.73 | 4.30 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, every claim off | 196.0 | 866.7 | 0.746 | 24.53 | 4.42 |
| messages: 50 nested objects | 140400 | 1121600 | stdx, J11's loop unchecked | 19.1 | 79.4 | 0.007 | 2.39 | 4.16 |
| messages: 50 nested objects | 140400 | 1121600 | simdjson | 23.4 | 96.6 | 0.004 | 2.93 | 4.12 |
| messages: 50 nested objects | 140400 | 1121600 | yyjson | 25.4 | 101.3 | 0.018 | 3.18 | 3.99 |
| messages: 50 nested objects | 140400 | 1121600 | std.json | 58.6 | 279.4 | 0.006 | 7.34 | 4.77 |
| messages: 50 nested objects | 140400 | 1121600 | serde_json | 52.1 | 230.6 | 0.065 | 6.52 | 4.43 |
| messages: 50 nested objects | 140400 | 1121600 | Go jsontext | 69.8 | 310.8 | 0.006 | 8.73 | 4.45 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 85723.1 | 280786.2 | 758.701 | 0.50 | 3.28 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 85516.5 | 280732.2 | 753.639 | 0.50 | 3.28 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 85469.7 | 280722.2 | 753.835 | 0.50 | 3.28 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3404623.1 | 16047574.2 | 2945.701 | 19.73 | 4.71 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 83266.3 | 274401.2 | 675.866 | 0.48 | 3.30 |
| string: silesia/dickens | 1 | 172528 | simdjson | 208468.6 | 674016.2 | 2052.289 | 1.21 | 3.23 |
| string: silesia/dickens | 1 | 172528 | yyjson | 209478.7 | 825518.2 | 1240.268 | 1.21 | 3.94 |
| string: silesia/dickens | 1 | 172528 | std.json | 1361235.9 | 2890892.2 | 55646.773 | 7.89 | 2.12 |
| string: silesia/dickens | 1 | 172528 | serde_json | 373498.1 | 1586249.2 | 2249.206 | 2.16 | 4.25 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 576632.4 | 2970293.3 | 2314.577 | 3.34 | 5.15 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1257353.6 | 3582350.6 | 10981.286 | 1.06 | 2.85 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1246653.9 | 3582290.6 | 10551.000 | 1.05 | 2.87 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1246934.1 | 3582278.6 | 10579.071 | 1.05 | 2.87 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25225190.9 | 109856348.6 | 143169.357 | 21.19 | 4.36 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1224884.3 | 3370022.6 | 11045.643 | 1.03 | 2.75 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2967006.0 | 10460762.6 | 29200.929 | 2.49 | 3.53 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2593203.6 | 10197931.6 | 9778.857 | 2.18 | 3.93 |
| string: http/json-1m | 1 | 1190272 | std.json | 8914627.8 | 43287986.6 | 17256.143 | 7.49 | 4.86 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3896055.1 | 17941088.6 | 10777.000 | 3.27 | 4.60 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5262433.8 | 26999740.1 | 11159.643 | 4.42 | 5.13 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2071119.5 | 6088099.8 | 4563.000 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2064896.9 | 6088043.8 | 4106.000 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2060805.3 | 6088027.8 | 4035.000 | 1.09 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43614242.0 | 193466553.8 | 267368.625 | 23.16 | 4.44 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2070729.8 | 5875346.8 | 4664.000 | 1.10 | 2.84 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2714179.8 | 7144143.8 | 20772.250 | 1.44 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12143973.4 | 23590602.8 | 448503.875 | 6.45 | 1.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20680440.3 | 56837736.8 | 546620.875 | 10.98 | 2.75 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11482950.3 | 33662338.8 | 339055.125 | 6.10 | 2.93 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18846962.4 | 76319429.1 | 254377.250 | 10.01 | 4.05 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113317.0 | 426376.7 | 2.710 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113132.5 | 426318.7 | 3.129 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113090.5 | 426306.7 | 2.548 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 635958.0 | 3146479.7 | 6.000 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113112.8 | 426343.7 | 3.774 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1199797.2 | 3866916.7 | 4.935 | 2.29 | 3.22 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1621493.2 | 5833341.7 | 7.323 | 3.09 | 3.60 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3499988.5 | 13108830.7 | 63595.161 | 6.68 | 3.75 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1784455.6 | 7405810.7 | 3.839 | 3.40 | 4.15 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2386660.8 | 12748296.7 | 15.419 | 4.55 | 5.34 |
