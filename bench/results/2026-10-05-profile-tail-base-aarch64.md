# bench-profile

| Field | Value |
|---|---|
| Commit | c33aab1 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260927.135.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/37254091339 |
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
| silesia/dickens | 10192446 | zlib | 8.04 | 15.77 | 1.96 | 306.12 |
| silesia/dickens | 10192446 | zlib-ng | 4.89 | 10.50 | 2.15 | 67.75 |
| silesia/dickens | 10192446 | libdeflate | 3.40 | 9.56 | 2.81 | 66.68 |
| silesia/dickens | 10192446 | Wuffs | 4.89 | 10.85 | 2.22 | 96.99 |
| silesia/dickens | 10192446 | stdx | 2.95 | 7.19 | 2.43 | 75.95 |
| silesia/mozilla | 51220480 | zlib | 7.79 | 14.13 | 1.81 | 244.03 |
| silesia/mozilla | 51220480 | zlib-ng | 4.94 | 8.95 | 1.81 | 85.40 |
| silesia/mozilla | 51220480 | libdeflate | 3.49 | 7.63 | 2.19 | 70.96 |
| silesia/mozilla | 51220480 | Wuffs | 5.73 | 10.84 | 1.89 | 132.17 |
| silesia/mozilla | 51220480 | stdx | 3.63 | 6.27 | 1.73 | 89.73 |
| silesia/mr | 9970564 | zlib | 7.71 | 15.26 | 1.98 | 202.60 |
| silesia/mr | 9970564 | zlib-ng | 4.81 | 9.98 | 2.07 | 67.94 |
| silesia/mr | 9970564 | libdeflate | 3.33 | 8.58 | 2.57 | 61.13 |
| silesia/mr | 9970564 | Wuffs | 5.28 | 10.93 | 2.07 | 100.44 |
| silesia/mr | 9970564 | stdx | 3.08 | 6.70 | 2.17 | 69.96 |
| silesia/nci | 33553445 | zlib | 2.92 | 7.25 | 2.48 | 79.25 |
| silesia/nci | 33553445 | zlib-ng | 1.58 | 3.13 | 1.98 | 34.19 |
| silesia/nci | 33553445 | libdeflate | 1.10 | 2.66 | 2.41 | 27.99 |
| silesia/nci | 33553445 | Wuffs | 1.69 | 3.38 | 2.00 | 42.36 |
| silesia/nci | 33553445 | stdx | 1.14 | 2.22 | 1.95 | 37.39 |
| silesia/ooffice | 6152192 | zlib | 11.02 | 17.83 | 1.62 | 400.56 |
| silesia/ooffice | 6152192 | zlib-ng | 6.87 | 12.04 | 1.75 | 139.84 |
| silesia/ooffice | 6152192 | libdeflate | 4.97 | 10.45 | 2.10 | 127.03 |
| silesia/ooffice | 6152192 | Wuffs | 8.09 | 14.47 | 1.79 | 220.32 |
| silesia/ooffice | 6152192 | stdx | 5.07 | 8.52 | 1.68 | 152.30 |
| silesia/osdb | 10085684 | zlib | 6.83 | 13.54 | 1.98 | 173.53 |
| silesia/osdb | 10085684 | zlib-ng | 4.29 | 8.38 | 1.95 | 53.46 |
| silesia/osdb | 10085684 | libdeflate | 2.83 | 6.91 | 2.44 | 29.91 |
| silesia/osdb | 10085684 | Wuffs | 5.11 | 10.56 | 2.07 | 78.39 |
| silesia/osdb | 10085684 | stdx | 2.77 | 5.64 | 2.04 | 40.30 |
| silesia/reymont | 6627202 | zlib | 6.69 | 12.73 | 1.90 | 257.48 |
| silesia/reymont | 6627202 | zlib-ng | 3.73 | 7.72 | 2.07 | 60.44 |
| silesia/reymont | 6627202 | libdeflate | 2.57 | 6.91 | 2.68 | 51.48 |
| silesia/reymont | 6627202 | Wuffs | 4.26 | 8.40 | 1.97 | 112.33 |
| silesia/reymont | 6627202 | stdx | 2.29 | 5.13 | 2.24 | 64.42 |
| silesia/samba | 21606400 | zlib | 5.49 | 11.09 | 2.02 | 171.50 |
| silesia/samba | 21606400 | zlib-ng | 3.34 | 6.47 | 1.94 | 55.86 |
| silesia/samba | 21606400 | libdeflate | 2.30 | 5.58 | 2.43 | 43.01 |
| silesia/samba | 21606400 | Wuffs | 3.66 | 7.33 | 2.00 | 81.19 |
| silesia/samba | 21606400 | stdx | 2.26 | 4.48 | 1.98 | 56.42 |
| silesia/sao | 7251944 | zlib | 9.95 | 20.36 | 2.05 | 201.15 |
| silesia/sao | 7251944 | zlib-ng | 7.85 | 14.83 | 1.89 | 79.14 |
| silesia/sao | 7251944 | libdeflate | 5.75 | 12.73 | 2.22 | 79.46 |
| silesia/sao | 7251944 | Wuffs | 8.13 | 18.14 | 2.23 | 85.40 |
| silesia/sao | 7251944 | stdx | 5.57 | 10.27 | 1.84 | 87.17 |
| silesia/webster | 41458703 | zlib | 7.05 | 12.99 | 1.84 | 275.16 |
| silesia/webster | 41458703 | zlib-ng | 4.22 | 8.04 | 1.91 | 85.15 |
| silesia/webster | 41458703 | libdeflate | 2.87 | 7.17 | 2.49 | 69.16 |
| silesia/webster | 41458703 | Wuffs | 4.55 | 8.62 | 1.90 | 123.26 |
| silesia/webster | 41458703 | stdx | 2.75 | 5.59 | 2.03 | 87.16 |
| silesia/x-ray | 8474240 | zlib | 12.26 | 23.82 | 1.94 | 322.72 |
| silesia/x-ray | 8474240 | zlib-ng | 9.00 | 17.39 | 1.93 | 123.95 |
| silesia/x-ray | 8474240 | libdeflate | 6.54 | 15.26 | 2.33 | 124.44 |
| silesia/x-ray | 8474240 | Wuffs | 10.12 | 20.40 | 2.02 | 192.50 |
| silesia/x-ray | 8474240 | stdx | 6.17 | 11.46 | 1.86 | 139.09 |
| silesia/xml | 5345280 | zlib | 3.64 | 8.20 | 2.25 | 116.31 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.62 |
| silesia/xml | 5345280 | libdeflate | 1.35 | 3.33 | 2.47 | 31.49 |
| silesia/xml | 5345280 | Wuffs | 2.20 | 4.14 | 1.89 | 60.90 |
| silesia/xml | 5345280 | stdx | 1.33 | 2.67 | 2.01 | 41.82 |
| canterbury/alice29.txt | 152089 | zlib | 7.65 | 15.08 | 1.97 | 288.55 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.55 | 9.91 | 2.18 | 59.81 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.16 | 8.96 | 2.84 | 56.14 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.73 | 10.37 | 2.19 | 98.08 |
| canterbury/alice29.txt | 152089 | stdx | 2.73 | 7.05 | 2.58 | 62.05 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.21 | 16.11 | 1.96 | 307.33 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.09 | 10.86 | 2.13 | 72.40 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.54 | 9.82 | 2.77 | 65.77 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.12 | 11.34 | 2.21 | 100.32 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.10 | 7.59 | 2.45 | 77.63 |
| canterbury/cp.html | 24603 | zlib | 6.42 | 14.20 | 2.21 | 163.20 |
| canterbury/cp.html | 24603 | zlib-ng | 4.22 | 9.50 | 2.25 | 38.79 |
| canterbury/cp.html | 24603 | libdeflate | 2.87 | 7.95 | 2.77 | 18.42 |
| canterbury/cp.html | 24603 | Wuffs | 4.49 | 10.87 | 2.42 | 57.04 |
| canterbury/cp.html | 24603 | stdx | 2.70 | 7.38 | 2.73 | 12.44 |
| canterbury/fields.c | 11150 | zlib | 4.56 | 14.65 | 3.22 | 33.80 |
| canterbury/fields.c | 11150 | zlib-ng | 3.89 | 10.20 | 2.62 | 14.65 |
| canterbury/fields.c | 11150 | libdeflate | 2.78 | 8.32 | 3.00 | 1.26 |
| canterbury/fields.c | 11150 | Wuffs | 3.84 | 11.51 | 3.00 | 10.63 |
| canterbury/fields.c | 11150 | stdx | 2.65 | 8.05 | 3.04 | 4.47 |
| canterbury/grammar.lsp | 3721 | zlib | 6.22 | 21.22 | 3.41 | 5.60 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.86 | 17.48 | 2.98 | 8.72 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.47 | 12.05 | 2.70 | 0.87 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.01 | 18.87 | 3.14 | 5.72 |
| canterbury/grammar.lsp | 3721 | stdx | 4.20 | 13.38 | 3.19 | 0.73 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.95 | 12.20 | 3.09 | 48.33 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.59 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.73 | 5.97 | 2.18 | 9.03 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.19 | 8.67 | 2.72 | 14.57 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.66 | 2.67 | 16.92 |
| canterbury/lcet10.txt | 426754 | zlib | 7.46 | 14.53 | 1.95 | 285.39 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.33 | 9.39 | 2.17 | 59.96 |
| canterbury/lcet10.txt | 426754 | libdeflate | 2.99 | 8.48 | 2.84 | 55.13 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.58 | 9.85 | 2.15 | 100.60 |
| canterbury/lcet10.txt | 426754 | stdx | 2.61 | 6.46 | 2.47 | 66.86 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.37 | 16.53 | 1.97 | 316.45 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.29 | 11.19 | 2.11 | 76.99 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.72 | 10.19 | 2.74 | 77.62 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.17 | 11.53 | 2.23 | 99.26 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.19 | 7.68 | 2.41 | 85.74 |
| canterbury/ptt5 | 513216 | zlib | 4.43 | 7.79 | 1.76 | 100.03 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.63 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.08 | 37.46 |
| canterbury/ptt5 | 513216 | Wuffs | 2.20 | 4.02 | 1.83 | 58.97 |
| canterbury/ptt5 | 513216 | stdx | 1.45 | 2.55 | 1.76 | 49.48 |
| canterbury/sum | 38240 | zlib | 7.29 | 14.98 | 2.05 | 214.28 |
| canterbury/sum | 38240 | zlib-ng | 4.65 | 10.02 | 2.15 | 56.61 |
| canterbury/sum | 38240 | libdeflate | 3.29 | 8.34 | 2.53 | 33.44 |
| canterbury/sum | 38240 | Wuffs | 5.16 | 11.41 | 2.21 | 87.75 |
| canterbury/sum | 38240 | stdx | 3.01 | 7.76 | 2.58 | 26.69 |
| canterbury/xargs.1 | 4227 | zlib | 6.69 | 22.08 | 3.30 | 8.73 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.39 | 17.97 | 2.81 | 10.38 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.79 | 13.27 | 2.77 | 0.39 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.50 | 19.63 | 3.02 | 9.20 |
| canterbury/xargs.1 | 4227 | stdx | 4.56 | 13.96 | 3.06 | 1.50 |
| canterbury-large/E.coli | 4638690 | zlib | 6.03 | 14.55 | 2.41 | 178.14 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.23 | 9.68 | 2.29 | 47.22 |
| canterbury-large/E.coli | 4638690 | libdeflate | 2.97 | 8.86 | 2.98 | 48.32 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.01 | 9.64 | 2.40 | 62.14 |
| canterbury-large/E.coli | 4638690 | stdx | 2.50 | 6.78 | 2.71 | 53.67 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.82 | 13.26 | 1.94 | 265.07 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.77 | 8.26 | 2.19 | 53.53 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.57 | 7.45 | 2.90 | 45.18 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.17 | 8.72 | 2.09 | 100.41 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.25 | 5.60 | 2.49 | 55.79 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.00 | 12.69 | 1.81 | 274.32 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.74 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.87 | 6.92 | 2.41 | 75.09 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.54 | 8.44 | 1.86 | 129.47 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.74 | 5.43 | 1.98 | 90.80 |
| http/html-1kx1024 | 1048576 | zlib | 15.81 | 32.44 | 2.05 | 353.57 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.67 | 28.43 | 2.24 | 219.36 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.88 | 20.05 | 1.84 | 156.54 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.62 | 35.05 | 2.40 | 264.64 |
| http/html-1kx1024 | 1048576 | stdx | 10.85 | 25.92 | 2.39 | 193.94 |
| http/html-16kx64 | 1048576 | zlib | 6.03 | 11.79 | 1.96 | 214.77 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.86 | 7.54 | 1.95 | 85.05 |
| http/html-16kx64 | 1048576 | libdeflate | 2.66 | 6.04 | 2.27 | 60.32 |
| http/html-16kx64 | 1048576 | Wuffs | 4.29 | 8.51 | 1.99 | 117.49 |
| http/html-16kx64 | 1048576 | stdx | 2.65 | 5.83 | 2.20 | 61.86 |
| http/html-1m | 1048576 | zlib | 4.69 | 9.51 | 2.03 | 173.64 |
| http/html-1m | 1048576 | zlib-ng | 2.63 | 5.03 | 1.91 | 60.13 |
| http/html-1m | 1048576 | libdeflate | 1.69 | 4.39 | 2.60 | 37.33 |
| http/html-1m | 1048576 | Wuffs | 2.98 | 5.42 | 1.82 | 90.78 |
| http/html-1m | 1048576 | stdx | 1.65 | 3.47 | 2.10 | 52.43 |
| http/json-1kx1024 | 1048576 | zlib | 9.75 | 20.83 | 2.14 | 196.41 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.26 | 130.88 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.14 | 16.72 | 1.83 | 92.49 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.46 | 31.72 | 2.77 | 144.52 |
| http/json-1kx1024 | 1048576 | stdx | 6.62 | 17.03 | 2.57 | 107.59 |
| http/json-16kx64 | 1048576 | zlib | 3.97 | 9.62 | 2.43 | 101.95 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.60 | 5.50 | 2.11 | 50.24 |
| http/json-16kx64 | 1048576 | libdeflate | 1.93 | 4.24 | 2.20 | 39.87 |
| http/json-16kx64 | 1048576 | Wuffs | 2.82 | 6.35 | 2.26 | 58.41 |
| http/json-16kx64 | 1048576 | stdx | 1.88 | 4.24 | 2.26 | 40.83 |
| http/json-1m | 1048576 | zlib | 3.26 | 8.25 | 2.53 | 81.48 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.02 | 37.27 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.11 |
| http/json-1m | 1048576 | Wuffs | 2.05 | 4.29 | 2.10 | 44.55 |
| http/json-1m | 1048576 | stdx | 1.33 | 2.68 | 2.01 | 40.11 |
| http/js-1kx1024 | 1048576 | zlib | 17.29 | 35.33 | 2.04 | 406.96 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.74 | 31.25 | 2.27 | 239.27 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.58 | 21.58 | 1.86 | 179.28 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.77 | 37.71 | 2.39 | 295.12 |
| http/js-1kx1024 | 1048576 | stdx | 11.76 | 27.69 | 2.35 | 225.15 |
| http/js-16kx64 | 1048576 | zlib | 6.94 | 13.06 | 1.88 | 255.73 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.40 | 8.65 | 1.97 | 91.75 |
| http/js-16kx64 | 1048576 | libdeflate | 3.08 | 7.01 | 2.27 | 71.78 |
| http/js-16kx64 | 1048576 | Wuffs | 4.86 | 9.70 | 2.00 | 130.31 |
| http/js-16kx64 | 1048576 | stdx | 3.12 | 6.80 | 2.18 | 74.40 |
| http/js-1m | 1048576 | zlib | 5.20 | 10.26 | 1.97 | 197.27 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 60.32 |
| http/js-1m | 1048576 | libdeflate | 1.91 | 4.98 | 2.61 | 41.95 |
| http/js-1m | 1048576 | Wuffs | 3.27 | 6.10 | 1.87 | 95.80 |
| http/js-1m | 1048576 | stdx | 1.81 | 3.91 | 2.16 | 55.29 |
| http/css-1kx1024 | 1048576 | zlib | 13.21 | 27.18 | 2.06 | 289.60 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.21 | 23.04 | 2.26 | 172.27 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.47 | 17.37 | 1.84 | 122.41 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.05 | 29.48 | 2.45 | 209.08 |
| http/css-1kx1024 | 1048576 | stdx | 9.00 | 22.95 | 2.55 | 138.33 |
| http/css-16kx64 | 1048576 | zlib | 4.69 | 10.12 | 2.16 | 152.05 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.79 | 6.07 | 2.17 | 50.64 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 28.66 |
| http/css-16kx64 | 1048576 | Wuffs | 3.12 | 6.97 | 2.23 | 70.12 |
| http/css-16kx64 | 1048576 | stdx | 1.85 | 4.66 | 2.51 | 29.75 |
| http/css-1m | 1048576 | zlib | 3.39 | 8.00 | 2.36 | 106.36 |
| http/css-1m | 1048576 | zlib-ng | 1.71 | 3.75 | 2.20 | 29.92 |
| http/css-1m | 1048576 | libdeflate | 1.03 | 3.18 | 3.09 | 10.09 |
| http/css-1m | 1048576 | Wuffs | 1.91 | 4.08 | 2.14 | 44.53 |
| http/css-1m | 1048576 | stdx | 1.02 | 2.57 | 2.53 | 21.29 |
| shuffled/dickens-1m | 1048576 | zlib | 12.75 | 22.42 | 1.76 | 370.93 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.69 | 16.72 | 1.73 | 199.84 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.13 | 14.95 | 2.10 | 192.40 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.66 | 18.95 | 1.96 | 208.29 |
| shuffled/dickens-1m | 1048576 | stdx | 7.10 | 11.99 | 1.69 | 207.40 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.40 | 14.04 | 4.13 | 3.47 |
| silesia/dickens | 10192446 | stdx | 3.50 | 12.47 | 3.56 | 3.64 |
| silesia/mozilla | 51220480 | libzstd | 2.79 | 9.62 | 3.45 | 30.05 |
| silesia/mozilla | 51220480 | stdx | 2.81 | 9.68 | 3.44 | 15.64 |
| silesia/mr | 9970564 | libzstd | 2.96 | 11.98 | 4.05 | 6.23 |
| silesia/mr | 9970564 | stdx | 3.01 | 10.83 | 3.60 | 5.34 |
| silesia/nci | 33553445 | libzstd | 1.56 | 4.84 | 3.11 | 23.55 |
| silesia/nci | 33553445 | stdx | 1.56 | 4.63 | 2.96 | 13.50 |
| silesia/ooffice | 6152192 | libzstd | 3.38 | 12.14 | 3.60 | 31.11 |
| silesia/ooffice | 6152192 | stdx | 3.29 | 12.40 | 3.77 | 11.99 |
| silesia/osdb | 10085684 | libzstd | 2.30 | 8.44 | 3.67 | 15.21 |
| silesia/osdb | 10085684 | stdx | 2.34 | 8.11 | 3.46 | 15.80 |
| silesia/reymont | 6627202 | libzstd | 3.07 | 11.61 | 3.78 | 11.56 |
| silesia/reymont | 6627202 | stdx | 3.17 | 10.36 | 3.27 | 12.94 |
| silesia/samba | 21606400 | libzstd | 2.02 | 7.39 | 3.67 | 18.65 |
| silesia/samba | 21606400 | stdx | 2.06 | 6.83 | 3.32 | 17.71 |
| silesia/sao | 7251944 | libzstd | 3.80 | 12.69 | 3.34 | 27.37 |
| silesia/sao | 7251944 | stdx | 3.46 | 12.58 | 3.64 | 6.19 |
| silesia/webster | 41458703 | libzstd | 3.06 | 11.22 | 3.67 | 16.23 |
| silesia/webster | 41458703 | stdx | 3.25 | 10.05 | 3.09 | 18.68 |
| silesia/x-ray | 8474240 | libzstd | 3.95 | 14.93 | 3.78 | 19.19 |
| silesia/x-ray | 8474240 | stdx | 3.52 | 13.23 | 3.76 | 8.41 |
| silesia/xml | 5345280 | libzstd | 1.53 | 5.55 | 3.64 | 22.75 |
| silesia/xml | 5345280 | stdx | 1.50 | 5.16 | 3.44 | 17.06 |
| canterbury/alice29.txt | 152089 | libzstd | 3.37 | 16.18 | 4.81 | 4.22 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.49 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.00 | 14.25 | 4.75 | 3.32 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.31 | 0.21 |
| canterbury/cp.html | 24603 | libzstd | 2.67 | 10.74 | 4.01 | 9.48 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.10 | 0.17 |
| canterbury/fields.c | 11150 | libzstd | 3.14 | 13.61 | 4.34 | 10.01 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.22 | 0.28 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.25 | 16.93 | 3.98 | 7.27 |
| canterbury/grammar.lsp | 3721 | stdx | 4.15 | 16.53 | 3.98 | 0.33 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.49 | 11.22 | 4.51 | 7.73 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.66 | 11.32 | 4.25 | 0.86 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.73 | 12.87 | 4.71 | 5.23 |
| canterbury/lcet10.txt | 426754 | stdx | 2.71 | 11.52 | 4.25 | 3.38 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.18 | 15.14 | 4.77 | 1.55 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.28 | 1.07 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.50 | 3.10 | 24.59 |
| canterbury/ptt5 | 513216 | stdx | 1.37 | 4.46 | 3.25 | 16.23 |
| canterbury/sum | 38240 | libzstd | 2.67 | 10.51 | 3.94 | 12.07 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.29 |
| canterbury/xargs.1 | 4227 | libzstd | 4.29 | 17.40 | 4.05 | 11.11 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.16 | 4.05 | 0.18 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.02 | 13.63 | 4.51 | 2.19 |
| canterbury-large/E.coli | 4638690 | stdx | 3.05 | 12.04 | 3.95 | 2.86 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.91 | 11.99 | 4.12 | 8.46 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.00 | 10.64 | 3.55 | 9.68 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.50 | 9.59 | 3.84 | 19.80 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.57 | 8.64 | 3.37 | 21.55 |
| http/html-1kx1024 | 1048576 | libzstd | 7.40 | 21.63 | 2.92 | 62.57 |
| http/html-1kx1024 | 1048576 | stdx | 7.48 | 22.43 | 3.00 | 76.78 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.72 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.60 | 30.60 |
| http/html-1m | 1048576 | libzstd | 1.99 | 7.86 | 3.95 | 24.39 |
| http/html-1m | 1048576 | stdx | 1.99 | 7.12 | 3.58 | 25.29 |
| http/json-1kx1024 | 1048576 | libzstd | 6.37 | 17.37 | 2.73 | 48.70 |
| http/json-1kx1024 | 1048576 | stdx | 6.23 | 17.84 | 2.86 | 54.31 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.22 | 3.53 | 28.02 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 19.81 |
| http/json-1m | 1048576 | libzstd | 1.71 | 6.04 | 3.52 | 27.53 |
| http/json-1m | 1048576 | stdx | 1.62 | 5.91 | 3.64 | 14.41 |
| http/js-1kx1024 | 1048576 | libzstd | 8.44 | 26.38 | 3.13 | 72.51 |
| http/js-1kx1024 | 1048576 | stdx | 9.06 | 27.57 | 3.04 | 113.62 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.71 | 4.00 | 24.46 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.74 | 26.29 |
| http/js-1m | 1048576 | libzstd | 2.01 | 8.18 | 4.08 | 20.25 |
| http/js-1m | 1048576 | stdx | 2.06 | 7.48 | 3.63 | 21.33 |
| http/css-1kx1024 | 1048576 | libzstd | 7.02 | 19.70 | 2.81 | 53.23 |
| http/css-1kx1024 | 1048576 | stdx | 6.86 | 19.93 | 2.91 | 64.02 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.69 | 3.88 | 23.19 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.07 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.57 | 3.89 | 5.50 |
| http/css-1m | 1048576 | stdx | 0.70 | 2.49 | 3.55 | 4.46 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.80 | 9.40 | 3.36 | 28.62 |
| shuffled/dickens-1m | 1048576 | stdx | 2.71 | 9.19 | 3.39 | 12.42 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.45 | 17.04 | 2.29 | 100.58 |
| silesia/dickens | 1048576 | stdx | 5.07 | 12.38 | 2.44 | 54.82 |
| silesia/mozilla | 1048576 | Google | 13.60 | 27.77 | 2.04 | 46.27 |
| silesia/mozilla | 1048576 | stdx | 8.31 | 15.02 | 1.81 | 47.10 |
| silesia/mr | 1048576 | Google | 8.88 | 20.24 | 2.28 | 102.11 |
| silesia/mr | 1048576 | stdx | 5.77 | 13.25 | 2.30 | 88.58 |
| silesia/nci | 1048576 | Google | 2.53 | 5.69 | 2.25 | 51.00 |
| silesia/nci | 1048576 | stdx | 1.93 | 3.95 | 2.05 | 54.65 |
| silesia/ooffice | 1048576 | Google | 14.18 | 29.28 | 2.07 | 288.66 |
| silesia/ooffice | 1048576 | stdx | 10.88 | 20.33 | 1.87 | 324.81 |
| silesia/osdb | 1048576 | Google | 8.18 | 17.38 | 2.12 | 96.85 |
| silesia/osdb | 1048576 | stdx | 5.13 | 10.57 | 2.06 | 92.52 |
| silesia/reymont | 1048576 | Google | 5.39 | 12.73 | 2.36 | 82.25 |
| silesia/reymont | 1048576 | stdx | 3.70 | 9.25 | 2.50 | 47.64 |
| silesia/samba | 1048576 | Google | 7.58 | 16.22 | 2.14 | 95.61 |
| silesia/samba | 1048576 | stdx | 5.05 | 10.71 | 2.12 | 66.65 |
| silesia/sao | 1048576 | Google | 16.78 | 36.97 | 2.20 | 163.81 |
| silesia/sao | 1048576 | stdx | 10.41 | 22.65 | 2.18 | 142.65 |
| silesia/webster | 1048576 | Google | 6.55 | 14.07 | 2.15 | 115.25 |
| silesia/webster | 1048576 | stdx | 4.37 | 9.98 | 2.29 | 68.99 |
| silesia/x-ray | 1048576 | Google | 19.22 | 38.46 | 2.00 | 234.32 |
| silesia/x-ray | 1048576 | stdx | 14.44 | 30.18 | 2.09 | 234.17 |
| silesia/xml | 1048576 | Google | 3.46 | 7.65 | 2.21 | 65.62 |
| silesia/xml | 1048576 | stdx | 2.39 | 5.40 | 2.26 | 46.80 |
| canterbury/alice29.txt | 152089 | Google | 8.93 | 20.66 | 2.31 | 136.29 |
| canterbury/alice29.txt | 152089 | stdx | 6.05 | 15.33 | 2.53 | 80.44 |
| canterbury/asyoulik.txt | 125179 | Google | 10.45 | 23.83 | 2.28 | 169.95 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.14 | 17.43 | 2.44 | 108.67 |
| canterbury/cp.html | 24603 | Google | 9.09 | 22.18 | 2.44 | 109.31 |
| canterbury/cp.html | 24603 | stdx | 5.71 | 17.15 | 3.00 | 31.25 |
| canterbury/fields.c | 11150 | Google | 7.11 | 21.25 | 2.99 | 23.55 |
| canterbury/fields.c | 11150 | stdx | 4.88 | 17.08 | 3.50 | 1.47 |
| canterbury/grammar.lsp | 3721 | Google | 9.84 | 30.23 | 3.07 | 5.51 |
| canterbury/grammar.lsp | 3721 | stdx | 7.17 | 25.04 | 3.49 | 0.41 |
| canterbury/kennedy.xls | 1029744 | Google | 5.46 | 17.05 | 3.12 | 37.25 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.80 | 12.94 | 3.40 | 33.88 |
| canterbury/lcet10.txt | 426754 | Google | 7.74 | 17.42 | 2.25 | 129.17 |
| canterbury/lcet10.txt | 426754 | stdx | 5.19 | 12.96 | 2.50 | 66.32 |
| canterbury/plrabn12.txt | 481861 | Google | 9.12 | 20.94 | 2.30 | 133.83 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.15 | 15.04 | 2.45 | 87.06 |
| canterbury/ptt5 | 513216 | Google | 4.29 | 10.36 | 2.42 | 62.07 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.07 | 65.52 |
| canterbury/sum | 38240 | Google | 10.83 | 26.44 | 2.44 | 157.91 |
| canterbury/sum | 38240 | stdx | 8.33 | 21.11 | 2.53 | 156.81 |
| canterbury/xargs.1 | 4227 | Google | 10.96 | 34.81 | 3.18 | 10.79 |
| canterbury/xargs.1 | 4227 | stdx | 8.42 | 30.44 | 3.61 | 5.97 |
| canterbury-large/E.coli | 1048576 | Google | 7.47 | 19.44 | 2.60 | 1.40 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.64 |
| canterbury-large/bible.txt | 1048576 | Google | 5.32 | 12.38 | 2.33 | 80.83 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.53 | 8.93 | 2.53 | 39.81 |
| canterbury-large/world192.txt | 1048576 | Google | 6.19 | 12.88 | 2.08 | 116.31 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.36 | 9.38 | 2.15 | 77.37 |
| http/html-1kx1024 | 1048576 | Google | 18.00 | 42.09 | 2.34 | 385.25 |
| http/html-1kx1024 | 1048576 | stdx | 15.27 | 37.56 | 2.46 | 359.16 |
| http/html-16kx64 | 1048576 | Google | 6.77 | 14.88 | 2.20 | 149.62 |
| http/html-16kx64 | 1048576 | stdx | 5.14 | 12.15 | 2.36 | 114.31 |
| http/html-1m | 1048576 | Google | 4.05 | 8.99 | 2.22 | 83.43 |
| http/html-1m | 1048576 | stdx | 2.85 | 6.52 | 2.29 | 54.68 |
| http/json-1kx1024 | 1048576 | Google | 14.37 | 36.74 | 2.56 | 238.74 |
| http/json-1kx1024 | 1048576 | stdx | 13.00 | 33.63 | 2.59 | 276.83 |
| http/json-16kx64 | 1048576 | Google | 4.42 | 11.42 | 2.58 | 80.56 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.49 | 83.50 |
| http/json-1m | 1048576 | Google | 3.40 | 8.66 | 2.55 | 58.38 |
| http/json-1m | 1048576 | stdx | 2.45 | 5.99 | 2.44 | 57.59 |
| http/js-1kx1024 | 1048576 | Google | 19.92 | 46.38 | 2.33 | 423.97 |
| http/js-1kx1024 | 1048576 | stdx | 16.35 | 39.90 | 2.44 | 377.64 |
| http/js-16kx64 | 1048576 | Google | 8.07 | 17.79 | 2.20 | 167.05 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.89 |
| http/js-1m | 1048576 | Google | 4.36 | 9.60 | 2.20 | 83.43 |
| http/js-1m | 1048576 | stdx | 3.15 | 7.25 | 2.30 | 55.55 |
| http/css-1kx1024 | 1048576 | Google | 15.45 | 37.48 | 2.43 | 292.53 |
| http/css-1kx1024 | 1048576 | stdx | 13.79 | 34.70 | 2.52 | 301.50 |
| http/css-16kx64 | 1048576 | Google | 4.96 | 11.78 | 2.38 | 100.22 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.48 | 80.48 |
| http/css-1m | 1048576 | Google | 2.43 | 9.43 | 3.88 | 16.56 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.48 | 12.32 |
| shuffled/dickens-1m | 1048576 | Google | 9.65 | 20.34 | 2.11 | 107.35 |
| shuffled/dickens-1m | 1048576 | stdx | 8.76 | 14.53 | 1.66 | 115.70 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.3 | 74.3 | 0.119 | 2.99 | 2.93 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 71.0 | 238.3 | 0.106 | 8.38 | 3.36 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 262.0 | 1119.2 | 0.814 | 30.95 | 4.27 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.2 | 106.7 | 0.141 | 3.56 | 3.54 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.9 | 107.1 | 0.297 | 3.29 | 3.84 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.1 | 378.2 | 0.387 | 11.24 | 3.98 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 26.9 | 89.6 | 0.004 | 3.96 | 3.33 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 70.7 | 249.9 | 0.041 | 10.41 | 3.53 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 224.2 | 880.2 | 0.925 | 33.00 | 3.93 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 27.7 | 107.5 | 0.039 | 4.07 | 3.88 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 27.6 | 106.7 | 0.049 | 4.06 | 3.87 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 93.7 | 345.9 | 0.350 | 13.79 | 3.69 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 113996.9 | 403839.2 | 468.289 | 0.66 | 3.54 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 615798.8 | 2684141.2 | 1345.887 | 3.57 | 4.36 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3864055.4 | 20639255.2 | 2978.722 | 22.40 | 5.34 |
| string: silesia/dickens | 1 | 172528 | simdjson | 310526.9 | 621748.2 | 624.402 | 1.80 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 226357.3 | 848188.2 | 2304.742 | 1.31 | 3.75 |
| string: silesia/dickens | 1 | 172528 | std.json | 1574936.5 | 4595563.2 | 44509.144 | 9.13 | 2.92 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1560132.4 | 4799762.6 | 1243.214 | 1.31 | 3.08 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 15082838.4 | 60619385.6 | 58426.571 | 12.67 | 4.02 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 31490163.6 | 148769682.6 | 156957.429 | 26.46 | 4.72 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4581229.9 | 7053853.6 | 529.929 | 3.85 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1789059.6 | 7470807.6 | 14624.357 | 1.50 | 4.18 |
| string: http/json-1m | 1 | 1190272 | std.json | 9942024.1 | 47253785.6 | 30028.643 | 8.35 | 4.75 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2070956.3 | 5765412.8 | 4534.500 | 1.10 | 2.78 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6478349.1 | 24133030.8 | 12606.875 | 3.44 | 3.73 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 51720276.3 | 252608919.8 | 289354.125 | 27.47 | 4.88 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3677208.8 | 7945848.8 | 1876.875 | 1.95 | 2.16 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7105871.1 | 12512113.8 | 276807.000 | 3.77 | 1.76 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17503161.4 | 63922930.8 | 225387.625 | 9.30 | 3.65 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12938310.7 | 42561068.3 | 245244.667 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 173535322.3 | 732363048.3 | 388485.333 | 34.19 | 4.22 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 165407729.7 | 708654908.3 | 420760.667 | 32.59 | 4.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17579393.0 | 49745827.3 | 220288.333 | 3.46 | 2.83 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14104903.3 | 45451415.3 | 456973.667 | 2.78 | 3.22 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 77952584.3 | 314355510.3 | 451614.000 | 15.36 | 4.03 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 192497.9 | 688807.7 | 4.516 | 0.37 | 3.58 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 192966.3 | 689029.7 | 7.645 | 0.37 | 3.57 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 11147881.8 | 60818249.7 | 10.097 | 21.26 | 5.46 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 490299.0 | 1376743.7 | 9.032 | 0.94 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 542631.9 | 2261447.7 | 7.065 | 1.03 | 4.17 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3487180.3 | 12808414.7 | 64395.871 | 6.65 | 3.67 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 21.5 | 91.8 | 0.107 | 2.54 | 4.27 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 73.1 | 342.1 | 0.195 | 8.64 | 4.68 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 221.0 | 1092.4 | 0.859 | 26.11 | 4.94 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 20.5 | 87.2 | 0.109 | 2.43 | 4.25 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 21.8 | 83.9 | 0.136 | 2.58 | 3.85 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 26.8 | 105.4 | 0.244 | 3.16 | 3.94 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 68.4 | 310.3 | 0.377 | 8.08 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 21.3 | 92.6 | 0.037 | 3.14 | 4.34 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 69.2 | 324.0 | 0.062 | 10.18 | 4.68 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 172.6 | 790.0 | 1.158 | 25.41 | 4.58 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 20.1 | 88.8 | 0.038 | 2.96 | 4.42 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 19.9 | 87.1 | 0.032 | 2.92 | 4.39 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 27.7 | 117.7 | 0.032 | 4.08 | 4.25 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.4 | 270.9 | 0.280 | 8.75 | 4.56 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 121596.9 | 464403.2 | 492.278 | 0.70 | 3.82 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 518521.1 | 2182153.2 | 1209.309 | 3.01 | 4.21 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3419804.1 | 18380954.2 | 2946.402 | 19.82 | 5.37 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 124928.2 | 460565.2 | 735.629 | 0.72 | 3.69 |
| string: silesia/dickens | 1 | 172528 | simdjson | 192720.6 | 627385.2 | 1953.505 | 1.12 | 3.26 |
| string: silesia/dickens | 1 | 172528 | yyjson | 215354.1 | 848559.2 | 1438.010 | 1.25 | 3.94 |
| string: silesia/dickens | 1 | 172528 | std.json | 1363569.8 | 2890187.2 | 54624.216 | 7.90 | 2.12 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 3439515.6 | 8766181.6 | 2692.643 | 2.89 | 2.55 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 10009760.1 | 44158803.6 | 20835.429 | 8.41 | 4.41 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 26443129.6 | 124535257.6 | 139175.500 | 22.22 | 4.71 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 3418792.4 | 8990926.6 | 3137.500 | 2.87 | 2.63 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2904541.6 | 10119250.6 | 29690.929 | 2.44 | 3.48 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2671369.1 | 11226214.6 | 9967.357 | 2.24 | 4.20 |
| string: http/json-1m | 1 | 1190272 | std.json | 8657461.3 | 42694254.6 | 15530.000 | 7.27 | 4.93 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2082335.8 | 6046671.8 | 4278.250 | 1.11 | 2.90 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6774302.4 | 23416085.8 | 12397.250 | 3.60 | 3.46 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 46325663.6 | 218527029.8 | 251649.875 | 24.60 | 4.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2088120.8 | 6189781.8 | 4524.750 | 1.11 | 2.96 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2637377.0 | 6858904.8 | 20910.125 | 1.40 | 2.60 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12396064.4 | 26334410.8 | 418541.125 | 6.58 | 2.12 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20785990.5 | 57035436.8 | 559543.750 | 11.04 | 2.74 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 112888.7 | 426377.7 | 4.161 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 112877.1 | 426473.7 | 2.871 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 635978.0 | 3146523.7 | 4.935 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113130.9 | 426345.7 | 2.452 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1221699.6 | 3932432.7 | 4.355 | 2.33 | 3.22 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1637771.6 | 5898886.7 | 6.258 | 3.12 | 3.60 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3561978.9 | 13174372.7 | 75173.839 | 6.79 | 3.70 |
