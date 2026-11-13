# bench-profile

| Field | Value |
|---|---|
| Commit | 1bf0a87 |
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
| silesia/dickens | 10192446 | zlib | 7.99 | 15.77 | 1.97 | 300.66 |
| silesia/dickens | 10192446 | zlib-ng | 4.92 | 10.50 | 2.13 | 67.70 |
| silesia/dickens | 10192446 | libdeflate | 3.49 | 9.56 | 2.74 | 66.09 |
| silesia/dickens | 10192446 | Wuffs | 4.92 | 10.85 | 2.20 | 97.33 |
| silesia/dickens | 10192446 | stdx | 3.02 | 7.15 | 2.36 | 76.19 |
| silesia/mozilla | 51220480 | zlib | 7.87 | 14.13 | 1.80 | 243.43 |
| silesia/mozilla | 51220480 | zlib-ng | 4.97 | 8.95 | 1.80 | 85.50 |
| silesia/mozilla | 51220480 | libdeflate | 3.49 | 7.63 | 2.19 | 71.05 |
| silesia/mozilla | 51220480 | Wuffs | 5.74 | 10.84 | 1.89 | 132.94 |
| silesia/mozilla | 51220480 | stdx | 3.65 | 6.29 | 1.72 | 89.04 |
| silesia/mr | 9970564 | zlib | 7.72 | 15.26 | 1.98 | 198.25 |
| silesia/mr | 9970564 | zlib-ng | 4.85 | 9.98 | 2.06 | 67.88 |
| silesia/mr | 9970564 | libdeflate | 3.38 | 8.58 | 2.54 | 61.07 |
| silesia/mr | 9970564 | Wuffs | 5.30 | 10.93 | 2.06 | 101.02 |
| silesia/mr | 9970564 | stdx | 3.14 | 6.70 | 2.13 | 69.75 |
| silesia/nci | 33553445 | zlib | 2.96 | 7.25 | 2.45 | 80.16 |
| silesia/nci | 33553445 | zlib-ng | 1.64 | 3.13 | 1.91 | 33.59 |
| silesia/nci | 33553445 | libdeflate | 1.16 | 2.66 | 2.29 | 27.65 |
| silesia/nci | 33553445 | Wuffs | 1.77 | 3.38 | 1.92 | 42.49 |
| silesia/nci | 33553445 | stdx | 1.27 | 2.20 | 1.73 | 37.36 |
| silesia/ooffice | 6152192 | zlib | 11.07 | 17.83 | 1.61 | 402.17 |
| silesia/ooffice | 6152192 | zlib-ng | 6.93 | 12.04 | 1.74 | 140.76 |
| silesia/ooffice | 6152192 | libdeflate | 4.91 | 10.45 | 2.13 | 125.47 |
| silesia/ooffice | 6152192 | Wuffs | 8.14 | 14.47 | 1.78 | 221.76 |
| silesia/ooffice | 6152192 | stdx | 5.13 | 8.55 | 1.67 | 150.42 |
| silesia/osdb | 10085684 | zlib | 6.86 | 13.54 | 1.97 | 172.86 |
| silesia/osdb | 10085684 | zlib-ng | 4.34 | 8.38 | 1.93 | 53.02 |
| silesia/osdb | 10085684 | libdeflate | 2.87 | 6.91 | 2.40 | 30.01 |
| silesia/osdb | 10085684 | Wuffs | 5.20 | 10.56 | 2.03 | 82.91 |
| silesia/osdb | 10085684 | stdx | 2.85 | 5.65 | 1.98 | 41.00 |
| silesia/reymont | 6627202 | zlib | 6.65 | 12.73 | 1.91 | 254.33 |
| silesia/reymont | 6627202 | zlib-ng | 3.71 | 7.72 | 2.08 | 59.30 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 50.94 |
| silesia/reymont | 6627202 | Wuffs | 4.23 | 8.40 | 1.98 | 112.34 |
| silesia/reymont | 6627202 | stdx | 2.29 | 5.11 | 2.23 | 64.68 |
| silesia/samba | 21606400 | zlib | 5.51 | 11.09 | 2.01 | 170.52 |
| silesia/samba | 21606400 | zlib-ng | 3.39 | 6.47 | 1.91 | 55.90 |
| silesia/samba | 21606400 | libdeflate | 2.36 | 5.58 | 2.36 | 42.81 |
| silesia/samba | 21606400 | Wuffs | 3.69 | 7.33 | 1.98 | 81.15 |
| silesia/samba | 21606400 | stdx | 2.37 | 4.46 | 1.88 | 56.16 |
| silesia/sao | 7251944 | zlib | 9.94 | 20.36 | 2.05 | 197.12 |
| silesia/sao | 7251944 | zlib-ng | 7.89 | 14.83 | 1.88 | 79.15 |
| silesia/sao | 7251944 | libdeflate | 5.75 | 12.73 | 2.21 | 78.90 |
| silesia/sao | 7251944 | Wuffs | 8.17 | 18.14 | 2.22 | 85.60 |
| silesia/sao | 7251944 | stdx | 5.63 | 10.32 | 1.83 | 87.06 |
| silesia/webster | 41458703 | zlib | 7.00 | 12.99 | 1.86 | 273.44 |
| silesia/webster | 41458703 | zlib-ng | 4.23 | 8.04 | 1.90 | 85.01 |
| silesia/webster | 41458703 | libdeflate | 2.93 | 7.17 | 2.45 | 68.35 |
| silesia/webster | 41458703 | Wuffs | 4.52 | 8.62 | 1.91 | 123.24 |
| silesia/webster | 41458703 | stdx | 2.84 | 5.56 | 1.96 | 87.15 |
| silesia/x-ray | 8474240 | zlib | 12.29 | 23.82 | 1.94 | 324.84 |
| silesia/x-ray | 8474240 | zlib-ng | 9.07 | 17.39 | 1.92 | 124.19 |
| silesia/x-ray | 8474240 | libdeflate | 6.55 | 15.26 | 2.33 | 124.56 |
| silesia/x-ray | 8474240 | Wuffs | 10.16 | 20.40 | 2.01 | 192.72 |
| silesia/x-ray | 8474240 | stdx | 6.19 | 11.49 | 1.86 | 137.25 |
| silesia/xml | 5345280 | zlib | 3.62 | 8.20 | 2.27 | 116.19 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.56 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.46 | 31.59 |
| silesia/xml | 5345280 | Wuffs | 2.19 | 4.14 | 1.89 | 60.93 |
| silesia/xml | 5345280 | stdx | 1.32 | 2.65 | 2.00 | 41.59 |
| canterbury/alice29.txt | 152089 | zlib | 7.57 | 15.08 | 1.99 | 284.70 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.51 | 9.91 | 2.20 | 59.96 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.20 | 8.96 | 2.80 | 57.10 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.71 | 10.37 | 2.20 | 98.85 |
| canterbury/alice29.txt | 152089 | stdx | 2.71 | 6.99 | 2.58 | 62.09 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.14 | 16.11 | 1.98 | 303.80 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 72.66 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.59 | 9.82 | 2.73 | 67.44 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.10 | 11.34 | 2.22 | 100.49 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.04 | 7.52 | 2.47 | 76.04 |
| canterbury/cp.html | 24603 | zlib | 6.54 | 14.20 | 2.17 | 174.36 |
| canterbury/cp.html | 24603 | zlib-ng | 4.17 | 9.50 | 2.28 | 35.89 |
| canterbury/cp.html | 24603 | libdeflate | 2.84 | 7.95 | 2.80 | 16.10 |
| canterbury/cp.html | 24603 | Wuffs | 4.47 | 10.87 | 2.43 | 56.07 |
| canterbury/cp.html | 24603 | stdx | 2.68 | 7.19 | 2.68 | 15.61 |
| canterbury/fields.c | 11150 | zlib | 4.58 | 14.65 | 3.20 | 37.01 |
| canterbury/fields.c | 11150 | zlib-ng | 3.87 | 10.20 | 2.64 | 13.94 |
| canterbury/fields.c | 11150 | libdeflate | 2.78 | 8.32 | 3.00 | 1.13 |
| canterbury/fields.c | 11150 | Wuffs | 3.81 | 11.51 | 3.02 | 8.62 |
| canterbury/fields.c | 11150 | stdx | 2.52 | 7.64 | 3.03 | 5.70 |
| canterbury/grammar.lsp | 3721 | zlib | 6.12 | 21.22 | 3.47 | 4.25 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.85 | 17.48 | 2.99 | 9.87 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.38 | 12.05 | 2.75 | 0.38 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.98 | 18.87 | 3.15 | 3.82 |
| canterbury/grammar.lsp | 3721 | stdx | 3.85 | 12.18 | 3.16 | 1.45 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.96 | 12.20 | 3.08 | 49.21 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.61 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.18 | 9.19 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.20 | 8.67 | 2.71 | 14.79 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.74 | 4.66 | 2.68 | 16.63 |
| canterbury/lcet10.txt | 426754 | zlib | 7.38 | 14.53 | 1.97 | 280.15 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 60.49 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.53 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.55 | 9.85 | 2.17 | 101.00 |
| canterbury/lcet10.txt | 426754 | stdx | 2.59 | 6.42 | 2.48 | 66.18 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.29 | 16.53 | 1.99 | 310.23 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.27 | 11.19 | 2.12 | 76.82 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.75 | 10.19 | 2.72 | 76.04 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.14 | 11.53 | 2.25 | 99.55 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.13 | 7.63 | 2.44 | 83.97 |
| canterbury/ptt5 | 513216 | zlib | 4.41 | 7.79 | 1.77 | 100.40 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.00 | 3.74 | 1.87 | 46.82 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.09 | 37.87 |
| canterbury/ptt5 | 513216 | Wuffs | 2.20 | 4.02 | 1.83 | 58.50 |
| canterbury/ptt5 | 513216 | stdx | 1.46 | 2.55 | 1.74 | 48.89 |
| canterbury/sum | 38240 | zlib | 7.29 | 14.98 | 2.06 | 217.15 |
| canterbury/sum | 38240 | zlib-ng | 4.62 | 10.02 | 2.17 | 54.76 |
| canterbury/sum | 38240 | libdeflate | 3.41 | 8.34 | 2.44 | 45.96 |
| canterbury/sum | 38240 | Wuffs | 4.99 | 11.41 | 2.29 | 75.82 |
| canterbury/sum | 38240 | stdx | 3.06 | 7.73 | 2.53 | 31.21 |
| canterbury/xargs.1 | 4227 | zlib | 6.56 | 22.08 | 3.36 | 7.00 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.39 | 17.97 | 2.81 | 10.37 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.76 | 13.27 | 2.79 | 1.55 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.49 | 19.63 | 3.03 | 9.95 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 12.86 | 3.04 | 1.54 |
| canterbury-large/E.coli | 4638690 | zlib | 5.94 | 14.55 | 2.45 | 174.71 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.25 | 9.68 | 2.28 | 47.33 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.92 | 48.63 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.00 | 9.64 | 2.41 | 61.30 |
| canterbury-large/E.coli | 4638690 | stdx | 2.47 | 6.72 | 2.72 | 53.69 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.74 | 13.26 | 1.97 | 259.82 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.79 | 8.26 | 2.18 | 53.65 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.36 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.17 | 8.72 | 2.09 | 100.69 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.24 | 5.57 | 2.49 | 55.67 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.96 | 12.69 | 1.82 | 272.93 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.60 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.87 | 6.92 | 2.41 | 74.93 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.52 | 8.44 | 1.87 | 129.69 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 5.40 | 1.99 | 90.36 |
| http/html-1kx1024 | 1048576 | zlib | 15.42 | 32.44 | 2.10 | 350.41 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.71 | 28.43 | 2.24 | 218.05 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.51 | 20.05 | 1.91 | 155.89 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.58 | 35.05 | 2.40 | 263.61 |
| http/html-1kx1024 | 1048576 | stdx | 8.40 | 20.88 | 2.48 | 137.68 |
| http/html-16kx64 | 1048576 | zlib | 5.98 | 11.79 | 1.97 | 214.66 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.02 |
| http/html-16kx64 | 1048576 | libdeflate | 2.63 | 6.04 | 2.30 | 60.48 |
| http/html-16kx64 | 1048576 | Wuffs | 4.26 | 8.51 | 2.00 | 116.87 |
| http/html-16kx64 | 1048576 | stdx | 2.51 | 5.56 | 2.22 | 58.80 |
| http/html-1m | 1048576 | zlib | 4.64 | 9.51 | 2.05 | 172.35 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 59.95 |
| http/html-1m | 1048576 | libdeflate | 1.69 | 4.39 | 2.59 | 37.37 |
| http/html-1m | 1048576 | Wuffs | 2.95 | 5.42 | 1.83 | 90.39 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.11 | 52.50 |
| http/json-1kx1024 | 1048576 | zlib | 9.27 | 20.83 | 2.25 | 191.75 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.26 | 131.22 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.78 | 16.72 | 1.90 | 92.12 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.43 | 31.72 | 2.78 | 145.22 |
| http/json-1kx1024 | 1048576 | stdx | 5.04 | 13.12 | 2.60 | 81.27 |
| http/json-16kx64 | 1048576 | zlib | 3.92 | 9.62 | 2.46 | 101.64 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.83 |
| http/json-16kx64 | 1048576 | libdeflate | 1.90 | 4.24 | 2.23 | 39.77 |
| http/json-16kx64 | 1048576 | Wuffs | 2.81 | 6.35 | 2.26 | 58.27 |
| http/json-16kx64 | 1048576 | stdx | 1.75 | 3.97 | 2.26 | 39.53 |
| http/json-1m | 1048576 | zlib | 3.24 | 8.25 | 2.54 | 82.12 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.03 | 37.16 |
| http/json-1m | 1048576 | libdeflate | 1.37 | 3.33 | 2.42 | 32.02 |
| http/json-1m | 1048576 | Wuffs | 2.04 | 4.29 | 2.11 | 44.40 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.01 | 39.82 |
| http/js-1kx1024 | 1048576 | zlib | 16.86 | 35.33 | 2.10 | 402.07 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.76 | 31.25 | 2.27 | 238.43 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.21 | 21.58 | 1.93 | 179.05 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.79 | 37.71 | 2.39 | 295.25 |
| http/js-1kx1024 | 1048576 | stdx | 9.29 | 22.85 | 2.46 | 160.10 |
| http/js-16kx64 | 1048576 | zlib | 6.88 | 13.06 | 1.90 | 254.99 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.98 | 91.53 |
| http/js-16kx64 | 1048576 | libdeflate | 3.05 | 7.01 | 2.29 | 72.27 |
| http/js-16kx64 | 1048576 | Wuffs | 4.84 | 9.70 | 2.01 | 130.16 |
| http/js-16kx64 | 1048576 | stdx | 3.02 | 6.54 | 2.16 | 72.48 |
| http/js-1m | 1048576 | zlib | 5.16 | 10.26 | 1.99 | 195.85 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 59.82 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.99 |
| http/js-1m | 1048576 | Wuffs | 3.25 | 6.10 | 1.88 | 95.93 |
| http/js-1m | 1048576 | stdx | 1.80 | 3.89 | 2.16 | 55.34 |
| http/css-1kx1024 | 1048576 | zlib | 12.71 | 27.18 | 2.14 | 280.66 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.27 | 23.04 | 2.24 | 171.50 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.09 | 17.37 | 1.91 | 121.13 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.05 | 29.48 | 2.45 | 209.63 |
| http/css-1kx1024 | 1048576 | stdx | 6.69 | 17.64 | 2.64 | 101.07 |
| http/css-16kx64 | 1048576 | zlib | 4.64 | 10.12 | 2.18 | 151.76 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.77 | 6.07 | 2.19 | 49.45 |
| http/css-16kx64 | 1048576 | libdeflate | 1.87 | 4.69 | 2.51 | 28.39 |
| http/css-16kx64 | 1048576 | Wuffs | 3.12 | 6.97 | 2.23 | 70.31 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.54 | 28.09 |
| http/css-1m | 1048576 | zlib | 3.37 | 8.00 | 2.37 | 107.44 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.22 | 28.82 |
| http/css-1m | 1048576 | libdeflate | 1.04 | 3.18 | 3.05 | 10.57 |
| http/css-1m | 1048576 | Wuffs | 1.91 | 4.08 | 2.14 | 45.05 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.54 | 21.28 |
| shuffled/dickens-1m | 1048576 | zlib | 12.72 | 22.42 | 1.76 | 370.34 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.72 | 16.72 | 1.72 | 197.38 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.01 | 14.95 | 2.13 | 192.96 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.66 | 18.95 | 1.96 | 205.23 |
| shuffled/dickens-1m | 1048576 | stdx | 7.03 | 11.89 | 1.69 | 207.16 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.43 | 14.04 | 4.10 | 3.48 |
| silesia/dickens | 10192446 | stdx | 3.54 | 12.47 | 3.52 | 3.59 |
| silesia/mozilla | 51220480 | libzstd | 2.84 | 9.62 | 3.39 | 30.07 |
| silesia/mozilla | 51220480 | stdx | 2.83 | 9.68 | 3.41 | 15.63 |
| silesia/mr | 9970564 | libzstd | 2.99 | 11.98 | 4.01 | 6.25 |
| silesia/mr | 9970564 | stdx | 3.03 | 10.83 | 3.58 | 5.42 |
| silesia/nci | 33553445 | libzstd | 1.63 | 4.84 | 2.97 | 23.52 |
| silesia/nci | 33553445 | stdx | 1.71 | 4.63 | 2.71 | 13.59 |
| silesia/ooffice | 6152192 | libzstd | 3.42 | 12.14 | 3.56 | 31.22 |
| silesia/ooffice | 6152192 | stdx | 3.32 | 12.40 | 3.74 | 12.29 |
| silesia/osdb | 10085684 | libzstd | 2.33 | 8.44 | 3.62 | 15.59 |
| silesia/osdb | 10085684 | stdx | 2.38 | 8.11 | 3.40 | 15.70 |
| silesia/reymont | 6627202 | libzstd | 3.07 | 11.61 | 3.78 | 11.67 |
| silesia/reymont | 6627202 | stdx | 3.20 | 10.36 | 3.23 | 12.70 |
| silesia/samba | 21606400 | libzstd | 2.08 | 7.39 | 3.55 | 18.66 |
| silesia/samba | 21606400 | stdx | 2.13 | 6.83 | 3.20 | 17.56 |
| silesia/sao | 7251944 | libzstd | 3.83 | 12.69 | 3.31 | 26.52 |
| silesia/sao | 7251944 | stdx | 3.51 | 12.58 | 3.59 | 6.36 |
| silesia/webster | 41458703 | libzstd | 3.14 | 11.22 | 3.57 | 16.23 |
| silesia/webster | 41458703 | stdx | 3.36 | 10.05 | 2.99 | 17.20 |
| silesia/x-ray | 8474240 | libzstd | 3.99 | 14.93 | 3.74 | 18.77 |
| silesia/x-ray | 8474240 | stdx | 3.58 | 13.23 | 3.69 | 8.50 |
| silesia/xml | 5345280 | libzstd | 1.54 | 5.55 | 3.60 | 22.83 |
| silesia/xml | 5345280 | stdx | 1.54 | 5.16 | 3.36 | 17.11 |
| canterbury/alice29.txt | 152089 | libzstd | 3.36 | 16.18 | 4.81 | 4.20 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.41 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.01 | 14.25 | 4.73 | 3.27 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.30 | 0.23 |
| canterbury/cp.html | 24603 | libzstd | 2.67 | 10.74 | 4.01 | 9.09 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.12 | 0.24 |
| canterbury/fields.c | 11150 | libzstd | 3.14 | 13.61 | 4.34 | 9.73 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.23 | 0.09 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.24 | 16.93 | 4.00 | 6.22 |
| canterbury/grammar.lsp | 3721 | stdx | 4.11 | 16.54 | 4.02 | 0.17 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.48 | 11.22 | 4.52 | 7.68 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.24 | 0.86 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.74 | 12.87 | 4.70 | 5.30 |
| canterbury/lcet10.txt | 426754 | stdx | 2.71 | 11.52 | 4.25 | 2.59 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.17 | 15.14 | 4.77 | 1.55 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.27 | 0.97 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.50 | 3.11 | 24.40 |
| canterbury/ptt5 | 513216 | stdx | 1.34 | 4.46 | 3.33 | 13.26 |
| canterbury/sum | 38240 | libzstd | 2.65 | 10.51 | 3.96 | 10.80 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.27 |
| canterbury/xargs.1 | 4227 | libzstd | 4.29 | 17.40 | 4.06 | 10.36 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.17 | 4.05 | 0.13 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.01 | 13.63 | 4.52 | 2.23 |
| canterbury-large/E.coli | 4638690 | stdx | 3.07 | 12.04 | 3.93 | 2.96 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.92 | 11.99 | 4.11 | 8.54 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.02 | 10.64 | 3.53 | 9.20 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.49 | 9.59 | 3.85 | 19.80 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.57 | 8.64 | 3.37 | 21.17 |
| http/html-1kx1024 | 1048576 | libzstd | 7.41 | 21.63 | 2.92 | 62.72 |
| http/html-1kx1024 | 1048576 | stdx | 7.43 | 22.46 | 3.02 | 75.78 |
| http/html-16kx64 | 1048576 | libzstd | 2.67 | 10.15 | 3.81 | 28.71 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.60 | 30.43 |
| http/html-1m | 1048576 | libzstd | 1.99 | 7.86 | 3.96 | 24.17 |
| http/html-1m | 1048576 | stdx | 1.99 | 7.12 | 3.58 | 25.11 |
| http/json-1kx1024 | 1048576 | libzstd | 6.39 | 17.37 | 2.72 | 48.96 |
| http/json-1kx1024 | 1048576 | stdx | 6.19 | 17.86 | 2.88 | 53.06 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.22 | 3.52 | 27.88 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 19.69 |
| http/json-1m | 1048576 | libzstd | 1.71 | 6.04 | 3.52 | 27.55 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.63 | 14.60 |
| http/js-1kx1024 | 1048576 | libzstd | 8.44 | 26.38 | 3.12 | 72.74 |
| http/js-1kx1024 | 1048576 | stdx | 9.00 | 27.60 | 3.07 | 112.21 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.71 | 3.99 | 24.31 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.73 | 26.56 |
| http/js-1m | 1048576 | libzstd | 2.01 | 8.18 | 4.06 | 20.36 |
| http/js-1m | 1048576 | stdx | 2.06 | 7.48 | 3.62 | 21.86 |
| http/css-1kx1024 | 1048576 | libzstd | 7.05 | 19.70 | 2.80 | 53.61 |
| http/css-1kx1024 | 1048576 | stdx | 6.81 | 19.96 | 2.93 | 63.07 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.69 | 3.88 | 23.23 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.11 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.57 | 3.89 | 5.59 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.49 | 4.38 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.80 | 9.40 | 3.35 | 28.56 |
| shuffled/dickens-1m | 1048576 | stdx | 2.72 | 9.19 | 3.38 | 12.74 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.46 | 17.04 | 2.28 | 100.80 |
| silesia/dickens | 1048576 | stdx | 5.05 | 12.38 | 2.45 | 54.51 |
| silesia/mozilla | 1048576 | Google | 13.59 | 27.77 | 2.04 | 46.89 |
| silesia/mozilla | 1048576 | stdx | 8.31 | 15.02 | 1.81 | 46.88 |
| silesia/mr | 1048576 | Google | 8.89 | 20.24 | 2.28 | 102.47 |
| silesia/mr | 1048576 | stdx | 5.78 | 13.25 | 2.29 | 88.34 |
| silesia/nci | 1048576 | Google | 2.56 | 5.69 | 2.22 | 52.24 |
| silesia/nci | 1048576 | stdx | 1.94 | 3.95 | 2.04 | 55.36 |
| silesia/ooffice | 1048576 | Google | 14.18 | 29.28 | 2.07 | 289.35 |
| silesia/ooffice | 1048576 | stdx | 10.85 | 20.33 | 1.87 | 323.66 |
| silesia/osdb | 1048576 | Google | 8.20 | 17.38 | 2.12 | 96.35 |
| silesia/osdb | 1048576 | stdx | 5.14 | 10.57 | 2.06 | 92.94 |
| silesia/reymont | 1048576 | Google | 5.39 | 12.73 | 2.36 | 81.41 |
| silesia/reymont | 1048576 | stdx | 3.71 | 9.25 | 2.50 | 47.71 |
| silesia/samba | 1048576 | Google | 7.58 | 16.22 | 2.14 | 95.48 |
| silesia/samba | 1048576 | stdx | 5.03 | 10.71 | 2.13 | 66.84 |
| silesia/sao | 1048576 | Google | 16.80 | 36.97 | 2.20 | 162.11 |
| silesia/sao | 1048576 | stdx | 10.41 | 22.65 | 2.18 | 143.05 |
| silesia/webster | 1048576 | Google | 6.53 | 14.07 | 2.15 | 114.96 |
| silesia/webster | 1048576 | stdx | 4.38 | 9.98 | 2.28 | 69.21 |
| silesia/x-ray | 1048576 | Google | 19.23 | 38.46 | 2.00 | 234.21 |
| silesia/x-ray | 1048576 | stdx | 14.66 | 30.18 | 2.06 | 235.23 |
| silesia/xml | 1048576 | Google | 3.47 | 7.65 | 2.21 | 65.54 |
| silesia/xml | 1048576 | stdx | 2.39 | 5.40 | 2.26 | 46.93 |
| canterbury/alice29.txt | 152089 | Google | 8.89 | 20.66 | 2.32 | 135.64 |
| canterbury/alice29.txt | 152089 | stdx | 6.02 | 15.33 | 2.55 | 79.63 |
| canterbury/asyoulik.txt | 125179 | Google | 10.41 | 23.83 | 2.29 | 170.12 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.03 | 17.43 | 2.48 | 103.31 |
| canterbury/cp.html | 24603 | Google | 9.13 | 22.18 | 2.43 | 111.98 |
| canterbury/cp.html | 24603 | stdx | 5.77 | 17.15 | 2.97 | 33.90 |
| canterbury/fields.c | 11150 | Google | 7.06 | 21.25 | 3.01 | 21.47 |
| canterbury/fields.c | 11150 | stdx | 4.87 | 17.08 | 3.51 | 1.96 |
| canterbury/grammar.lsp | 3721 | Google | 9.82 | 30.23 | 3.08 | 4.77 |
| canterbury/grammar.lsp | 3721 | stdx | 7.15 | 25.04 | 3.50 | 0.93 |
| canterbury/kennedy.xls | 1029744 | Google | 5.48 | 17.05 | 3.11 | 37.05 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.81 | 12.94 | 3.40 | 33.80 |
| canterbury/lcet10.txt | 426754 | Google | 7.73 | 17.42 | 2.25 | 129.51 |
| canterbury/lcet10.txt | 426754 | stdx | 5.18 | 12.96 | 2.50 | 66.64 |
| canterbury/plrabn12.txt | 481861 | Google | 9.09 | 20.94 | 2.30 | 134.08 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.15 | 15.04 | 2.45 | 87.35 |
| canterbury/ptt5 | 513216 | Google | 4.29 | 10.36 | 2.42 | 62.38 |
| canterbury/ptt5 | 513216 | stdx | 2.39 | 4.89 | 2.05 | 68.14 |
| canterbury/sum | 38240 | Google | 10.80 | 26.44 | 2.45 | 156.21 |
| canterbury/sum | 38240 | stdx | 8.31 | 21.11 | 2.54 | 152.93 |
| canterbury/xargs.1 | 4227 | Google | 10.95 | 34.81 | 3.18 | 11.25 |
| canterbury/xargs.1 | 4227 | stdx | 8.47 | 30.44 | 3.60 | 7.00 |
| canterbury-large/E.coli | 1048576 | Google | 7.47 | 19.44 | 2.60 | 1.33 |
| canterbury-large/E.coli | 1048576 | stdx | 6.70 | 13.48 | 2.01 | 1.14 |
| canterbury-large/bible.txt | 1048576 | Google | 5.30 | 12.38 | 2.34 | 80.60 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.51 | 8.93 | 2.55 | 39.66 |
| canterbury-large/world192.txt | 1048576 | Google | 6.16 | 12.88 | 2.09 | 114.85 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.38 | 9.38 | 2.14 | 77.79 |
| http/html-1kx1024 | 1048576 | Google | 17.92 | 42.09 | 2.35 | 388.34 |
| http/html-1kx1024 | 1048576 | stdx | 15.27 | 37.56 | 2.46 | 361.38 |
| http/html-16kx64 | 1048576 | Google | 6.76 | 14.88 | 2.20 | 149.61 |
| http/html-16kx64 | 1048576 | stdx | 5.14 | 12.15 | 2.36 | 114.67 |
| http/html-1m | 1048576 | Google | 4.05 | 8.99 | 2.22 | 83.44 |
| http/html-1m | 1048576 | stdx | 2.84 | 6.52 | 2.30 | 54.95 |
| http/json-1kx1024 | 1048576 | Google | 14.26 | 36.74 | 2.58 | 239.00 |
| http/json-1kx1024 | 1048576 | stdx | 12.99 | 33.63 | 2.59 | 277.32 |
| http/json-16kx64 | 1048576 | Google | 4.41 | 11.42 | 2.59 | 81.02 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.67 |
| http/json-1m | 1048576 | Google | 3.41 | 8.66 | 2.54 | 59.04 |
| http/json-1m | 1048576 | stdx | 2.45 | 5.99 | 2.45 | 57.36 |
| http/js-1kx1024 | 1048576 | Google | 19.82 | 46.38 | 2.34 | 427.44 |
| http/js-1kx1024 | 1048576 | stdx | 16.37 | 39.90 | 2.44 | 381.51 |
| http/js-16kx64 | 1048576 | Google | 8.07 | 17.79 | 2.21 | 167.73 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 126.41 |
| http/js-1m | 1048576 | Google | 4.37 | 9.60 | 2.20 | 83.57 |
| http/js-1m | 1048576 | stdx | 3.13 | 7.25 | 2.31 | 55.46 |
| http/css-1kx1024 | 1048576 | Google | 15.31 | 37.48 | 2.45 | 291.79 |
| http/css-1kx1024 | 1048576 | stdx | 13.81 | 34.70 | 2.51 | 302.61 |
| http/css-16kx64 | 1048576 | Google | 4.96 | 11.78 | 2.37 | 100.88 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.48 | 81.02 |
| http/css-1m | 1048576 | Google | 2.43 | 9.43 | 3.88 | 16.71 |
| http/css-1m | 1048576 | stdx | 0.74 | 1.86 | 2.51 | 11.84 |
| shuffled/dickens-1m | 1048576 | Google | 9.73 | 20.34 | 2.09 | 110.95 |
| shuffled/dickens-1m | 1048576 | stdx | 8.83 | 14.53 | 1.65 | 121.74 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.25 | 36.91 | 2.42 | 410.80 |
| silesia/dickens | 10192446 | 1 | stdx | 16.42 | 38.17 | 2.33 | 360.86 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.04 | 87.63 | 1.68 | 694.86 |
| silesia/dickens | 10192446 | 6 | stdx | 49.66 | 84.25 | 1.70 | 1456.63 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.80 | 160.47 | 1.44 | 929.44 |
| silesia/dickens | 10192446 | 9 | stdx | 64.85 | 150.06 | 2.31 | 1398.24 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.09 | 32.62 | 2.31 | 436.64 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.32 | 30.24 | 2.27 | 294.86 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.83 | 70.83 | 2.16 | 578.44 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.54 | 69.96 | 2.22 | 736.97 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.68 | 221.49 | 1.73 | 771.58 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.61 | 125.42 | 2.58 | 781.27 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.98 | 35.02 | 2.92 | 229.21 |
| silesia/mr | 9970564 | 1 | stdx | 12.62 | 34.08 | 2.70 | 187.15 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.21 | 80.54 | 2.11 | 436.84 |
| silesia/mr | 9970564 | 6 | stdx | 39.78 | 83.18 | 2.09 | 977.56 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.62 | 165.48 | 1.70 | 749.83 |
| silesia/mr | 9970564 | 9 | stdx | 78.87 | 184.93 | 2.34 | 1218.05 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.20 | 18.42 | 2.97 | 114.06 |
| silesia/nci | 33553445 | 1 | stdx | 4.93 | 10.88 | 2.21 | 97.00 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.98 | 34.84 | 2.05 | 226.74 |
| silesia/nci | 33553445 | 6 | stdx | 14.43 | 29.54 | 2.05 | 398.45 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.45 | 105.28 | 1.69 | 501.64 |
| silesia/nci | 33553445 | 9 | stdx | 28.27 | 69.01 | 2.44 | 558.29 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.94 | 39.15 | 1.96 | 752.24 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.75 | 39.08 | 2.20 | 430.33 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 40.97 | 79.10 | 1.93 | 952.85 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.67 | 87.83 | 2.11 | 1013.42 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.61 | 127.63 | 1.71 | 1131.97 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.14 | 129.03 | 2.47 | 929.31 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.89 | 30.15 | 2.34 | 351.58 |
| silesia/osdb | 10085684 | 1 | stdx | 12.91 | 27.86 | 2.16 | 293.55 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.32 | 55.67 | 1.97 | 493.65 |
| silesia/osdb | 10085684 | 6 | stdx | 27.19 | 57.39 | 2.11 | 579.54 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.88 | 64.15 | 1.89 | 552.41 |
| silesia/osdb | 10085684 | 9 | stdx | 35.20 | 87.16 | 2.48 | 679.40 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.63 | 32.88 | 2.60 | 311.65 |
| silesia/reymont | 6627202 | 1 | stdx | 13.53 | 33.24 | 2.46 | 272.20 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.09 | 86.58 | 1.80 | 518.93 |
| silesia/reymont | 6627202 | 6 | stdx | 45.44 | 76.81 | 1.69 | 1441.10 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.30 | 276.14 | 1.39 | 837.57 |
| silesia/reymont | 6627202 | 9 | stdx | 74.06 | 160.03 | 2.16 | 1432.43 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.43 | 26.53 | 2.54 | 271.79 |
| silesia/samba | 21606400 | 1 | stdx | 9.90 | 22.23 | 2.25 | 220.92 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.93 | 58.79 | 2.03 | 384.86 |
| silesia/samba | 21606400 | 6 | stdx | 24.15 | 49.83 | 2.06 | 628.53 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.21 | 141.44 | 1.68 | 504.52 |
| silesia/samba | 21606400 | 9 | stdx | 36.12 | 90.81 | 2.51 | 644.56 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.71 | 47.87 | 2.21 | 682.38 |
| silesia/sao | 7251944 | 1 | stdx | 19.18 | 49.92 | 2.60 | 346.04 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.09 | 96.89 | 1.90 | 961.26 |
| silesia/sao | 7251944 | 6 | stdx | 47.12 | 105.66 | 2.24 | 858.90 |
| silesia/sao | 7251944 | 9 | libdeflate | 70.93 | 120.26 | 1.70 | 1105.17 |
| silesia/sao | 7251944 | 9 | stdx | 55.10 | 137.71 | 2.50 | 833.06 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.09 | 30.45 | 2.33 | 386.11 |
| silesia/webster | 41458703 | 1 | stdx | 13.85 | 29.08 | 2.10 | 340.15 |
| silesia/webster | 41458703 | 6 | libdeflate | 36.98 | 66.02 | 1.79 | 570.23 |
| silesia/webster | 41458703 | 6 | stdx | 35.26 | 60.87 | 1.73 | 1127.13 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.68 | 138.85 | 1.47 | 757.17 |
| silesia/webster | 41458703 | 9 | stdx | 48.38 | 110.73 | 2.29 | 1083.76 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.68 | 49.67 | 2.10 | 783.33 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.58 | 50.81 | 2.89 | 261.54 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.80 | 82.77 | 2.52 | 849.27 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.86 | 98.12 | 2.90 | 540.39 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.47 | 91.03 | 2.43 | 1027.24 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.68 | 121.58 | 2.99 | 467.02 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.83 | 21.59 | 2.76 | 175.86 |
| silesia/xml | 5345280 | 1 | stdx | 7.03 | 15.66 | 2.23 | 154.91 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.19 | 40.51 | 1.91 | 264.14 |
| silesia/xml | 5345280 | 6 | stdx | 17.74 | 34.32 | 1.93 | 504.06 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.72 | 89.17 | 1.52 | 372.52 |
| silesia/xml | 5345280 | 9 | stdx | 26.59 | 63.43 | 2.39 | 525.68 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.25 | 35.61 | 2.50 | 378.76 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.06 | 36.12 | 2.40 | 336.36 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.66 | 82.29 | 1.76 | 638.02 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.84 | 77.41 | 1.77 | 1324.31 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.50 | 159.21 | 1.48 | 847.91 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 58.25 | 138.20 | 2.37 | 1269.88 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.13 | 37.20 | 2.46 | 413.07 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.78 | 37.43 | 2.37 | 359.07 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.26 | 85.43 | 1.77 | 711.59 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.20 | 81.92 | 1.77 | 1390.92 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.95 | 136.15 | 1.53 | 937.86 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 60.16 | 144.56 | 2.40 | 1332.67 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.68 | 32.02 | 2.74 | 283.99 |
| canterbury/cp.html | 24603 | 1 | stdx | 11.08 | 27.13 | 2.45 | 247.26 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 26.93 | 62.33 | 2.31 | 486.32 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.70 | 57.05 | 2.41 | 623.36 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.81 | 91.97 | 1.96 | 592.66 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.33 | 88.88 | 2.84 | 641.65 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.88 | 35.92 | 3.64 | 84.63 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.16 | 30.05 | 3.68 | 22.90 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.12 | 69.37 | 2.88 | 228.13 |
| canterbury/fields.c | 11150 | 6 | stdx | 21.37 | 57.62 | 2.70 | 446.04 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.09 | 100.81 | 2.29 | 401.86 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.82 | 92.65 | 3.21 | 459.13 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.02 | 51.51 | 3.96 | 15.50 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 10.43 | 39.01 | 3.74 | 1.32 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.69 | 87.06 | 3.68 | 28.15 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 18.15 | 70.80 | 3.90 | 16.29 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.66 | 102.89 | 3.36 | 39.41 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 24.21 | 99.30 | 4.10 | 49.18 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.37 | 27.18 | 3.69 | 65.11 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.04 | 22.58 | 3.21 | 63.40 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.82 | 73.85 | 2.65 | 95.74 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.38 | 61.98 | 3.20 | 139.17 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.21 | 664.23 | 1.83 | 162.68 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 30.27 | 107.06 | 3.54 | 144.57 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.77 | 33.99 | 2.47 | 369.24 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.46 | 33.92 | 2.35 | 329.56 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.02 | 78.22 | 1.74 | 607.52 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.83 | 73.42 | 1.76 | 1245.74 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.84 | 136.94 | 1.49 | 805.06 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 55.16 | 130.91 | 2.37 | 1197.49 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.81 | 38.62 | 2.44 | 426.34 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.72 | 40.24 | 2.41 | 369.46 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.13 | 91.90 | 1.70 | 752.85 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.75 | 88.89 | 1.72 | 1525.47 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.91 | 166.26 | 1.42 | 1002.41 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 67.87 | 158.18 | 2.33 | 1464.38 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.43 | 18.61 | 2.90 | 141.99 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.97 | 11.03 | 2.22 | 123.35 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.25 | 36.17 | 2.54 | 218.59 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.36 | 29.57 | 2.39 | 311.99 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.65 | 120.86 | 1.99 | 378.66 |
| canterbury/ptt5 | 513216 | 9 | stdx | 41.33 | 126.55 | 3.06 | 591.94 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.78 | 33.49 | 2.62 | 337.33 |
| canterbury/sum | 38240 | 1 | stdx | 12.59 | 29.36 | 2.33 | 299.89 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.54 | 69.87 | 2.45 | 492.55 |
| canterbury/sum | 38240 | 6 | stdx | 26.83 | 65.73 | 2.45 | 662.96 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.48 | 181.91 | 1.93 | 606.56 |
| canterbury/sum | 38240 | 9 | stdx | 39.29 | 112.32 | 2.86 | 659.65 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.44 | 53.06 | 3.95 | 32.00 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.91 | 43.10 | 3.95 | 2.19 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.90 | 87.70 | 3.83 | 72.31 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 18.29 | 74.35 | 4.07 | 40.00 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 24.77 | 94.34 | 3.81 | 85.19 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.57 | 106.95 | 4.03 | 96.68 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.07 | 40.47 | 3.35 | 164.12 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.76 | 42.29 | 3.32 | 100.95 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.25 | 395.99 | 2.16 | 261.28 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.81 | 374.12 | 3.05 | 1918.38 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.35 | 1063.49 | 1.30 | 1322.21 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 230.10 | 751.65 | 3.27 | 2429.20 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.56 | 32.38 | 2.58 | 311.02 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.43 | 32.23 | 2.40 | 280.78 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.06 | 80.12 | 1.74 | 522.39 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.40 | 72.38 | 1.71 | 1280.46 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.77 | 200.28 | 1.41 | 742.74 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 60.58 | 136.73 | 2.26 | 1224.30 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.32 | 29.72 | 2.23 | 412.45 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.29 | 28.55 | 2.00 | 378.54 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.14 | 60.25 | 1.82 | 557.13 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.19 | 56.80 | 1.76 | 1001.46 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.77 | 119.11 | 1.47 | 688.22 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 41.76 | 97.56 | 2.34 | 972.99 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.40 | 103.92 | 2.94 | 454.72 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.73 | 58.63 | 2.70 | 365.48 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.22 | 138.33 | 2.99 | 565.10 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 34.57 | 94.30 | 2.73 | 529.96 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.78 | 142.44 | 2.98 | 586.41 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 38.65 | 112.10 | 2.90 | 539.02 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.45 | 27.96 | 2.68 | 266.42 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.07 | 20.25 | 2.23 | 233.49 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.31 | 52.09 | 2.33 | 390.65 |
| http/html-16kx64 | 1048576 | 6 | stdx | 19.12 | 42.86 | 2.24 | 544.11 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 35.03 | 72.54 | 2.07 | 463.02 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.95 | 69.05 | 2.77 | 549.97 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.76 | 23.03 | 2.63 | 224.08 |
| http/html-1m | 1048576 | 1 | stdx | 8.14 | 17.79 | 2.18 | 205.29 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.28 | 49.53 | 1.96 | 326.23 |
| http/html-1m | 1048576 | 6 | stdx | 21.31 | 40.70 | 1.91 | 628.74 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.18 | 109.24 | 1.53 | 433.49 |
| http/html-1m | 1048576 | 9 | stdx | 29.99 | 73.42 | 2.45 | 615.10 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.76 | 94.80 | 2.98 | 303.39 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 18.61 | 45.16 | 2.43 | 242.31 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.10 | 126.60 | 2.94 | 376.12 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 28.35 | 78.36 | 2.76 | 379.92 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.18 | 142.45 | 2.73 | 431.66 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 31.86 | 95.54 | 3.00 | 385.67 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.84 | 23.85 | 3.04 | 133.80 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.54 | 13.94 | 2.51 | 110.66 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.16 | 46.61 | 2.57 | 204.56 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.48 | 35.01 | 2.60 | 281.07 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.33 | 151.99 | 1.89 | 299.98 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.29 | 58.29 | 3.02 | 302.07 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.73 | 19.85 | 2.95 | 124.16 |
| http/json-1m | 1048576 | 1 | stdx | 5.05 | 12.51 | 2.47 | 103.36 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.31 | 45.30 | 2.23 | 175.76 |
| http/json-1m | 1048576 | 6 | stdx | 14.74 | 35.08 | 2.38 | 300.59 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.82 | 205.21 | 1.68 | 279.95 |
| http/json-1m | 1048576 | 9 | stdx | 27.42 | 69.14 | 2.52 | 336.77 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.05 | 107.80 | 2.91 | 518.08 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 24.01 | 65.40 | 2.72 | 411.30 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.38 | 144.85 | 2.93 | 677.87 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 38.19 | 104.11 | 2.73 | 618.08 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.71 | 150.13 | 2.90 | 715.86 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 42.68 | 125.11 | 2.93 | 625.34 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.72 | 30.90 | 2.64 | 309.19 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.88 | 24.80 | 2.28 | 273.22 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.86 | 59.43 | 2.30 | 470.49 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.94 | 50.04 | 2.18 | 678.88 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.85 | 83.31 | 2.04 | 563.61 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.73 | 81.30 | 2.73 | 664.22 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.63 | 25.19 | 2.62 | 247.09 |
| http/js-1m | 1048576 | 1 | stdx | 9.53 | 21.31 | 2.24 | 233.15 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.71 | 56.12 | 1.95 | 368.82 |
| http/js-1m | 1048576 | 6 | stdx | 25.00 | 46.64 | 1.87 | 749.64 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.42 | 120.65 | 1.58 | 501.35 |
| http/js-1m | 1048576 | 9 | stdx | 34.97 | 84.80 | 2.42 | 707.18 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.16 | 97.73 | 2.95 | 377.11 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 20.48 | 49.52 | 2.42 | 301.05 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.89 | 129.22 | 2.94 | 479.34 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 30.34 | 82.31 | 2.71 | 504.34 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.88 | 133.80 | 2.92 | 509.82 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 34.37 | 99.46 | 2.89 | 521.06 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.64 | 25.60 | 2.96 | 173.92 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.76 | 16.96 | 2.51 | 134.71 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.17 | 48.80 | 2.42 | 287.69 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.55 | 38.00 | 2.30 | 470.10 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.84 | 82.40 | 2.02 | 370.86 |
| http/css-16kx64 | 1048576 | 9 | stdx | 23.06 | 65.13 | 2.82 | 477.59 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.94 | 21.15 | 3.05 | 132.64 |
| http/css-1m | 1048576 | 1 | stdx | 5.78 | 14.91 | 2.58 | 108.23 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.78 | 44.50 | 2.14 | 226.30 |
| http/css-1m | 1048576 | 6 | stdx | 16.65 | 35.61 | 2.14 | 448.91 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.84 | 111.58 | 1.60 | 309.35 |
| http/css-1m | 1048576 | 9 | stdx | 28.16 | 72.54 | 2.58 | 473.54 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.22 | 48.89 | 1.94 | 929.60 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.14 | 49.19 | 2.71 | 323.02 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.58 | 86.45 | 2.08 | 1182.28 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.77 | 88.79 | 2.23 | 855.17 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.27 | 94.50 | 2.00 | 1344.94 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 53.89 | 133.83 | 2.48 | 1123.96 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.12 | 31.13 | 3.08 | 122.87 |
| silesia/dickens | 10192446 | 1 | stdx | 24.15 | 82.03 | 3.40 | 125.16 |
| silesia/dickens | 10192446 | 3 | libzstd | 21.98 | 35.01 | 1.59 | 171.20 |
| silesia/dickens | 10192446 | 3 | stdx | 34.70 | 78.22 | 2.25 | 182.12 |
| silesia/mozilla | 51220480 | 1 | libzstd | 6.99 | 22.57 | 3.23 | 72.22 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.52 | 54.73 | 3.12 | 173.13 |
| silesia/mozilla | 51220480 | 3 | libzstd | 16.59 | 28.71 | 1.73 | 102.11 |
| silesia/mozilla | 51220480 | 3 | stdx | 29.49 | 62.01 | 2.10 | 144.81 |
| silesia/mr | 9970564 | 1 | libzstd | 7.64 | 24.73 | 3.24 | 57.29 |
| silesia/mr | 9970564 | 1 | stdx | 19.81 | 66.82 | 3.37 | 113.30 |
| silesia/mr | 9970564 | 3 | libzstd | 19.38 | 32.97 | 1.70 | 86.62 |
| silesia/mr | 9970564 | 3 | stdx | 32.48 | 72.46 | 2.23 | 114.66 |
| silesia/nci | 33553445 | 1 | libzstd | 3.55 | 9.49 | 2.67 | 58.69 |
| silesia/nci | 33553445 | 1 | stdx | 7.61 | 25.69 | 3.37 | 59.03 |
| silesia/nci | 33553445 | 3 | libzstd | 5.34 | 10.11 | 1.89 | 56.94 |
| silesia/nci | 33553445 | 3 | stdx | 11.12 | 29.15 | 2.62 | 66.29 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.56 | 29.17 | 3.41 | 72.08 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.03 | 72.51 | 3.15 | 179.89 |
| silesia/ooffice | 6152192 | 3 | libzstd | 23.19 | 40.82 | 1.76 | 120.18 |
| silesia/ooffice | 6152192 | 3 | stdx | 40.24 | 82.20 | 2.04 | 184.34 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.10 | 22.22 | 3.13 | 67.27 |
| silesia/osdb | 10085684 | 1 | stdx | 16.27 | 50.52 | 3.11 | 120.17 |
| silesia/osdb | 10085684 | 3 | libzstd | 17.43 | 27.06 | 1.55 | 69.56 |
| silesia/osdb | 10085684 | 3 | stdx | 30.54 | 57.87 | 1.89 | 110.04 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.82 | 27.02 | 2.75 | 155.65 |
| silesia/reymont | 6627202 | 1 | stdx | 20.08 | 72.05 | 3.59 | 96.76 |
| silesia/reymont | 6627202 | 3 | libzstd | 17.71 | 27.53 | 1.55 | 127.47 |
| silesia/reymont | 6627202 | 3 | stdx | 27.23 | 62.18 | 2.28 | 146.96 |
| silesia/samba | 21606400 | 1 | libzstd | 5.97 | 16.80 | 2.82 | 88.17 |
| silesia/samba | 21606400 | 1 | stdx | 13.42 | 42.89 | 3.20 | 124.65 |
| silesia/samba | 21606400 | 3 | libzstd | 11.61 | 19.20 | 1.65 | 99.38 |
| silesia/samba | 21606400 | 3 | stdx | 19.82 | 44.75 | 2.26 | 132.65 |
| silesia/sao | 7251944 | 1 | libzstd | 9.03 | 33.64 | 3.73 | 43.81 |
| silesia/sao | 7251944 | 1 | stdx | 25.79 | 82.03 | 3.18 | 103.29 |
| silesia/sao | 7251944 | 3 | libzstd | 30.66 | 52.14 | 1.70 | 94.69 |
| silesia/sao | 7251944 | 3 | stdx | 49.27 | 95.22 | 1.93 | 142.13 |
| silesia/webster | 41458703 | 1 | libzstd | 8.72 | 24.86 | 2.85 | 135.87 |
| silesia/webster | 41458703 | 1 | stdx | 20.22 | 64.04 | 3.17 | 166.21 |
| silesia/webster | 41458703 | 3 | libzstd | 18.56 | 27.84 | 1.50 | 177.01 |
| silesia/webster | 41458703 | 3 | stdx | 30.05 | 64.55 | 2.15 | 194.53 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.72 | 14.89 | 3.16 | 17.10 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.77 | 76.64 | 3.22 | 92.88 |
| silesia/x-ray | 8474240 | 3 | libzstd | 31.14 | 54.96 | 1.77 | 86.28 |
| silesia/x-ray | 8474240 | 3 | stdx | 45.50 | 92.40 | 2.03 | 105.47 |
| silesia/xml | 5345280 | 1 | libzstd | 4.27 | 11.65 | 2.73 | 72.76 |
| silesia/xml | 5345280 | 1 | stdx | 10.32 | 34.21 | 3.31 | 94.08 |
| silesia/xml | 5345280 | 3 | libzstd | 6.61 | 12.84 | 1.94 | 78.42 |
| silesia/xml | 5345280 | 3 | stdx | 12.54 | 32.28 | 2.57 | 115.10 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.89 | 32.86 | 3.02 | 145.57 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.24 | 76.49 | 3.44 | 185.08 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.24 | 39.93 | 2.62 | 203.00 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.01 | 73.76 | 2.84 | 334.06 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.79 | 33.59 | 3.43 | 109.77 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.48 | 79.00 | 3.37 | 214.43 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.54 | 40.28 | 2.59 | 206.96 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 27.77 | 79.30 | 2.86 | 372.03 |
| canterbury/cp.html | 24603 | 1 | libzstd | 7.02 | 26.65 | 3.80 | 39.76 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.04 | 57.76 | 3.60 | 118.12 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.19 | 32.88 | 3.58 | 14.72 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.15 | 59.76 | 3.29 | 137.42 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.77 | 31.77 | 3.62 | 39.77 |
| canterbury/fields.c | 11150 | 1 | stdx | 16.90 | 65.73 | 3.89 | 85.31 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.02 | 34.41 | 3.82 | 9.52 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.44 | 64.68 | 3.71 | 89.59 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.58 | 37.98 | 3.96 | 11.69 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.14 | 77.57 | 3.85 | 51.34 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.61 | 43.28 | 4.08 | 1.30 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.41 | 79.60 | 3.72 | 67.60 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.01 | 23.37 | 3.89 | 14.80 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.69 | 56.75 | 3.86 | 83.66 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.37 | 24.26 | 2.90 | 27.54 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 19.97 | 56.61 | 2.83 | 108.14 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.86 | 28.42 | 2.88 | 160.20 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.26 | 72.02 | 3.39 | 160.05 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 16.09 | 32.77 | 2.04 | 201.08 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 25.91 | 67.10 | 2.59 | 295.57 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.35 | 32.28 | 3.12 | 130.64 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.16 | 84.16 | 3.35 | 158.05 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 20.15 | 39.60 | 1.97 | 224.45 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 31.74 | 80.77 | 2.55 | 342.49 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.15 | 8.48 | 2.69 | 67.93 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.47 | 23.15 | 3.10 | 104.86 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 4.86 | 11.28 | 2.32 | 59.77 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.33 | 24.08 | 2.58 | 132.69 |
| canterbury/sum | 38240 | 1 | libzstd | 6.50 | 25.37 | 3.90 | 29.98 |
| canterbury/sum | 38240 | 1 | stdx | 16.81 | 59.13 | 3.52 | 148.54 |
| canterbury/sum | 38240 | 3 | libzstd | 8.84 | 31.64 | 3.58 | 23.27 |
| canterbury/sum | 38240 | 3 | stdx | 19.39 | 61.82 | 3.19 | 181.32 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 10.02 | 39.84 | 3.98 | 12.73 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.74 | 80.38 | 3.88 | 57.14 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.03 | 48.45 | 4.03 | 2.34 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.87 | 83.98 | 3.67 | 78.47 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.49 | 33.29 | 3.17 | 75.97 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.77 | 95.62 | 4.39 | 7.23 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 14.65 | 31.71 | 2.16 | 35.72 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.45 | 70.38 | 3.00 | 38.47 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.81 | 27.35 | 2.79 | 154.07 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.33 | 71.86 | 3.53 | 107.89 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 17.53 | 28.64 | 1.63 | 133.61 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 27.33 | 63.36 | 2.32 | 154.61 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.19 | 22.62 | 2.76 | 140.30 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.63 | 55.86 | 3.00 | 192.25 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 15.06 | 24.36 | 1.62 | 173.35 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 24.33 | 51.26 | 2.11 | 236.70 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.09 | 52.52 | 3.07 | 167.81 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.62 | 100.54 | 2.82 | 634.87 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.24 | 59.34 | 3.08 | 206.71 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 38.05 | 104.00 | 2.73 | 630.66 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.85 | 22.47 | 2.86 | 127.51 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.17 | 46.84 | 3.31 | 181.79 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.89 | 24.79 | 2.79 | 146.29 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.44 | 47.61 | 3.08 | 191.42 |
| http/html-1m | 1048576 | 1 | libzstd | 6.31 | 16.66 | 2.64 | 117.56 |
| http/html-1m | 1048576 | 1 | stdx | 12.92 | 42.00 | 3.25 | 134.36 |
| http/html-1m | 1048576 | 3 | libzstd | 9.22 | 18.50 | 2.01 | 125.07 |
| http/html-1m | 1048576 | 3 | stdx | 15.53 | 39.37 | 2.54 | 177.49 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.32 | 42.58 | 2.97 | 119.24 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.54 | 83.13 | 2.81 | 522.84 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.91 | 44.69 | 3.00 | 134.20 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.79 | 84.87 | 2.76 | 532.64 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.82 | 15.00 | 3.11 | 59.33 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.70 | 33.78 | 3.48 | 115.95 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.40 | 16.31 | 3.02 | 73.09 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.63 | 34.58 | 3.25 | 122.63 |
| http/json-1m | 1048576 | 1 | libzstd | 4.03 | 12.47 | 3.09 | 53.39 |
| http/json-1m | 1048576 | 1 | stdx | 8.95 | 30.70 | 3.43 | 85.31 |
| http/json-1m | 1048576 | 3 | libzstd | 6.17 | 14.06 | 2.28 | 68.44 |
| http/json-1m | 1048576 | 3 | stdx | 11.18 | 30.64 | 2.74 | 119.24 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.63 | 57.29 | 3.08 | 197.24 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 39.88 | 113.49 | 2.85 | 690.12 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.58 | 65.62 | 3.04 | 269.51 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 42.11 | 116.54 | 2.77 | 681.52 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 9.00 | 26.53 | 2.95 | 132.66 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.65 | 55.71 | 3.35 | 198.96 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.20 | 28.96 | 2.84 | 158.56 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.81 | 55.35 | 3.11 | 209.26 |
| http/js-1m | 1048576 | 1 | libzstd | 6.60 | 17.80 | 2.70 | 116.40 |
| http/js-1m | 1048576 | 1 | stdx | 13.92 | 45.88 | 3.30 | 135.08 |
| http/js-1m | 1048576 | 3 | libzstd | 9.94 | 19.49 | 1.96 | 124.54 |
| http/js-1m | 1048576 | 3 | stdx | 16.74 | 41.25 | 2.46 | 186.85 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.62 | 46.97 | 3.01 | 143.55 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.29 | 91.65 | 2.84 | 578.40 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.78 | 50.68 | 3.02 | 167.63 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.82 | 93.63 | 2.77 | 583.17 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.24 | 18.99 | 3.04 | 80.61 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.43 | 43.79 | 3.52 | 137.40 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.60 | 19.53 | 2.96 | 95.72 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.95 | 42.34 | 3.27 | 152.55 |
| http/css-1m | 1048576 | 1 | libzstd | 1.52 | 4.57 | 3.00 | 22.08 |
| http/css-1m | 1048576 | 1 | stdx | 3.97 | 14.85 | 3.74 | 30.69 |
| http/css-1m | 1048576 | 3 | libzstd | 1.97 | 5.34 | 2.71 | 19.49 |
| http/css-1m | 1048576 | 3 | stdx | 3.93 | 13.33 | 3.39 | 31.65 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.55 | 12.79 | 3.61 | 6.58 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.07 | 30.66 | 3.38 | 62.17 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 27.76 | 53.05 | 1.91 | 46.90 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 20.34 | 47.43 | 2.33 | 206.20 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.3 | 74.2 | 0.119 | 2.99 | 2.93 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 72.0 | 234.8 | 0.087 | 8.51 | 3.26 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 78.6 | 293.2 | 0.094 | 9.29 | 3.73 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 284.0 | 1193.5 | 0.818 | 33.55 | 4.20 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.7 | 107.5 | 0.145 | 3.62 | 3.51 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.1 | 106.0 | 0.295 | 3.31 | 3.78 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.1 | 378.2 | 0.390 | 11.23 | 3.98 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.1 | 161.9 | 0.443 | 4.97 | 3.84 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 92.2 | 451.7 | 0.306 | 10.89 | 4.90 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.2 | 89.5 | 0.005 | 4.00 | 3.30 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 76.0 | 251.1 | 0.098 | 11.19 | 3.30 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 85.2 | 310.3 | 0.123 | 12.53 | 3.64 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 239.5 | 927.9 | 0.975 | 35.25 | 3.87 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.0 | 107.7 | 0.040 | 4.13 | 3.84 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 32.3 | 105.7 | 0.049 | 4.76 | 3.27 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 94.3 | 346.2 | 0.330 | 13.88 | 3.67 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 32.8 | 144.5 | 0.052 | 4.82 | 4.41 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 93.9 | 406.5 | 0.095 | 13.83 | 4.33 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114781.0 | 403845.2 | 505.010 | 0.67 | 3.52 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 648331.4 | 2749464.2 | 1397.021 | 3.76 | 4.24 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 648167.6 | 2749586.2 | 1401.711 | 3.76 | 4.24 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 4479626.5 | 22490188.2 | 2979.361 | 25.96 | 5.02 |
| string: silesia/dickens | 1 | 172528 | simdjson | 313742.5 | 621743.2 | 653.773 | 1.82 | 1.98 |
| string: silesia/dickens | 1 | 172528 | yyjson | 225199.1 | 826618.2 | 2205.082 | 1.31 | 3.67 |
| string: silesia/dickens | 1 | 172528 | std.json | 1602403.5 | 4578768.2 | 43354.856 | 9.29 | 2.86 |
| string: silesia/dickens | 1 | 172528 | serde_json | 202697.6 | 802391.2 | 1000.701 | 1.17 | 3.96 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1051548.2 | 5279914.6 | 5058.536 | 6.09 | 5.02 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1568284.8 | 4799762.6 | 1539.714 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 15335213.6 | 62777242.6 | 38831.571 | 12.88 | 4.09 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 15360404.9 | 62777364.6 | 38807.286 | 12.90 | 4.09 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 35409124.0 | 160729111.6 | 158429.571 | 29.75 | 4.54 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4592045.2 | 7053838.6 | 558.357 | 3.86 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1781737.5 | 7322017.6 | 13885.000 | 1.50 | 4.11 |
| string: http/json-1m | 1 | 1190272 | std.json | 10302639.7 | 47381213.6 | 32221.071 | 8.66 | 4.60 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3807980.1 | 15226459.6 | 6151.143 | 3.20 | 4.00 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9012414.5 | 47988666.8 | 27756.214 | 7.57 | 5.32 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2065933.1 | 5765412.8 | 4405.000 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6556498.9 | 24513379.8 | 6927.625 | 3.48 | 3.74 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 6556978.9 | 24513501.8 | 6937.750 | 3.48 | 3.74 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 59214569.1 | 273034491.8 | 266206.625 | 31.45 | 4.61 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3677198.6 | 7945848.8 | 1864.375 | 1.95 | 2.16 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7164205.8 | 12276727.8 | 276156.625 | 3.80 | 1.71 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 18172271.4 | 63617055.8 | 219054.750 | 9.65 | 3.50 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9528556.9 | 24440755.8 | 336987.750 | 5.06 | 2.57 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39437391.8 | 160313110.5 | 787473.250 | 20.94 | 4.07 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12918696.0 | 42561068.3 | 244887.333 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 191226966.3 | 782100947.3 | 390363.000 | 37.68 | 4.09 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 182864914.0 | 782101069.3 | 390223.333 | 36.03 | 4.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 185203132.7 | 760206171.3 | 423109.000 | 36.49 | 4.10 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17681809.7 | 49745819.3 | 224609.333 | 3.48 | 2.81 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14194233.7 | 44816977.3 | 454822.333 | 2.80 | 3.16 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79796892.7 | 314900845.3 | 482455.667 | 15.72 | 3.95 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36220939.7 | 131556135.3 | 566223.667 | 7.14 | 3.63 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66488757.7 | 273922838.7 | 830709.000 | 13.10 | 4.12 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 91657.1 | 303836.7 | 8.323 | 0.17 | 3.31 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 181918.5 | 623607.7 | 9.903 | 0.35 | 3.43 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 182068.6 | 623729.7 | 9.387 | 0.35 | 3.43 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 13134612.0 | 66585428.7 | 7.645 | 25.05 | 5.07 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 495010.9 | 1376732.7 | 7.129 | 0.94 | 2.78 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 534410.0 | 2195905.7 | 7.000 | 1.02 | 4.11 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3544502.9 | 12808414.7 | 62201.839 | 6.76 | 3.61 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 289463.5 | 1179969.7 | 7.613 | 0.55 | 4.08 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2255509.5 | 12786380.9 | 237.032 | 4.30 | 5.67 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.9 | 81.5 | 0.111 | 2.35 | 4.10 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 74.9 | 342.9 | 0.199 | 8.85 | 4.58 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 95.0 | 452.8 | 0.179 | 11.23 | 4.77 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 258.0 | 1182.8 | 0.915 | 30.47 | 4.58 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 19.3 | 79.5 | 0.104 | 2.27 | 4.13 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.2 | 94.1 | 0.134 | 2.74 | 4.06 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.0 | 105.4 | 0.244 | 3.19 | 3.90 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.1 | 310.8 | 0.380 | 8.17 | 4.50 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.1 | 255.3 | 0.481 | 7.45 | 4.05 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.1 | 315.1 | 0.254 | 8.05 | 4.62 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 19.4 | 82.5 | 0.024 | 2.86 | 4.25 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 71.4 | 324.2 | 0.135 | 10.52 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 91.9 | 431.8 | 0.099 | 13.52 | 4.70 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 198.7 | 848.0 | 1.405 | 29.25 | 4.27 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 18.4 | 81.5 | 0.024 | 2.72 | 4.42 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.5 | 96.6 | 0.032 | 3.16 | 4.49 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.7 | 117.7 | 0.033 | 4.22 | 4.11 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.6 | 271.2 | 0.267 | 8.77 | 4.55 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 49.2 | 211.7 | 0.040 | 7.24 | 4.30 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 82.0 | 331.7 | 0.089 | 12.07 | 4.05 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 85095.7 | 280780.2 | 738.247 | 0.49 | 3.30 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 542501.7 | 2218394.2 | 1276.072 | 3.14 | 4.09 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 542129.9 | 2218521.2 | 1276.794 | 3.14 | 4.09 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 4103210.2 | 20167466.2 | 2950.361 | 23.78 | 4.92 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 83040.7 | 274401.2 | 660.876 | 0.48 | 3.30 |
| string: silesia/dickens | 1 | 172528 | simdjson | 209047.8 | 674008.2 | 2118.237 | 1.21 | 3.22 |
| string: silesia/dickens | 1 | 172528 | yyjson | 215771.8 | 848559.2 | 1417.412 | 1.25 | 3.93 |
| string: silesia/dickens | 1 | 172528 | std.json | 1358362.6 | 2890892.2 | 51318.216 | 7.87 | 2.13 |
| string: silesia/dickens | 1 | 172528 | serde_json | 366523.8 | 1586249.2 | 2299.351 | 2.12 | 4.33 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 578280.4 | 2970284.7 | 2307.567 | 3.35 | 5.14 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1268787.1 | 3582346.6 | 11178.643 | 1.07 | 2.82 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 10958623.4 | 44839315.6 | 51850.429 | 9.21 | 4.09 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 10909598.6 | 44839436.6 | 46056.000 | 9.17 | 4.11 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 30036261.2 | 134936069.6 | 139202.286 | 25.23 | 4.49 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1237720.9 | 3370022.6 | 11180.571 | 1.04 | 2.72 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2996173.3 | 10460754.6 | 28976.786 | 2.52 | 3.49 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2668051.9 | 11226214.6 | 9533.000 | 2.24 | 4.21 |
| string: http/json-1m | 1 | 1190272 | std.json | 9057051.6 | 43287986.6 | 16165.714 | 7.61 | 4.78 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4185403.5 | 17941088.6 | 10835.143 | 3.52 | 4.29 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5240378.5 | 26999707.9 | 11064.714 | 4.40 | 5.15 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2082616.4 | 6088095.8 | 5031.500 | 1.11 | 2.92 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6755920.4 | 23973379.8 | 6551.000 | 3.59 | 3.55 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 6809600.0 | 23973500.8 | 6511.250 | 3.62 | 3.52 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 53438669.8 | 238556376.8 | 256185.500 | 28.38 | 4.46 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2072867.0 | 5875346.8 | 4826.750 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2723332.6 | 7144135.8 | 21098.625 | 1.45 | 2.62 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12290854.0 | 26334410.8 | 415755.000 | 6.53 | 2.14 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20426001.6 | 56837736.8 | 529910.375 | 10.85 | 2.78 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11386853.0 | 33662338.8 | 335713.375 | 6.05 | 2.96 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18792938.4 | 76319367.3 | 249214.250 | 9.98 | 4.06 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113308.7 | 426373.7 | 1.581 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113478.9 | 426473.7 | 6.323 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 113587.7 | 426547.7 | 5.129 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 635939.2 | 3146562.7 | 6.290 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113172.4 | 426343.7 | 1.548 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1240071.9 | 3866907.7 | 5.355 | 2.37 | 3.12 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1664000.4 | 5833344.7 | 6.613 | 3.17 | 3.51 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3615576.3 | 13108830.7 | 72721.806 | 6.90 | 3.63 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1823009.2 | 7405810.7 | 4.387 | 3.48 | 4.06 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2388363.5 | 12748301.1 | 17.000 | 4.56 | 5.34 |
