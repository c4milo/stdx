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
| Run URL | https://github.com/c4milo/stdx/actions/runs/37254647085 |
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
| silesia/dickens | 10192446 | zlib | 8.04 | 15.77 | 1.96 | 306.97 |
| silesia/dickens | 10192446 | zlib-ng | 4.89 | 10.50 | 2.15 | 67.65 |
| silesia/dickens | 10192446 | libdeflate | 3.41 | 9.56 | 2.81 | 66.42 |
| silesia/dickens | 10192446 | Wuffs | 4.91 | 10.85 | 2.21 | 96.99 |
| silesia/dickens | 10192446 | stdx | 2.96 | 7.19 | 2.43 | 76.38 |
| silesia/mozilla | 51220480 | zlib | 7.80 | 14.13 | 1.81 | 244.06 |
| silesia/mozilla | 51220480 | zlib-ng | 4.94 | 8.95 | 1.81 | 85.51 |
| silesia/mozilla | 51220480 | libdeflate | 3.51 | 7.63 | 2.18 | 71.32 |
| silesia/mozilla | 51220480 | Wuffs | 5.74 | 10.84 | 1.89 | 132.32 |
| silesia/mozilla | 51220480 | stdx | 3.66 | 6.27 | 1.71 | 89.80 |
| silesia/mr | 9970564 | zlib | 7.71 | 15.26 | 1.98 | 202.25 |
| silesia/mr | 9970564 | zlib-ng | 4.80 | 9.98 | 2.08 | 68.01 |
| silesia/mr | 9970564 | libdeflate | 3.34 | 8.58 | 2.57 | 61.32 |
| silesia/mr | 9970564 | Wuffs | 5.28 | 10.93 | 2.07 | 100.35 |
| silesia/mr | 9970564 | stdx | 3.08 | 6.70 | 2.18 | 70.31 |
| silesia/nci | 33553445 | zlib | 2.96 | 7.25 | 2.45 | 79.28 |
| silesia/nci | 33553445 | zlib-ng | 1.62 | 3.13 | 1.93 | 34.13 |
| silesia/nci | 33553445 | libdeflate | 1.14 | 2.66 | 2.32 | 27.94 |
| silesia/nci | 33553445 | Wuffs | 1.75 | 3.38 | 1.93 | 42.36 |
| silesia/nci | 33553445 | stdx | 1.18 | 2.22 | 1.88 | 37.55 |
| silesia/ooffice | 6152192 | zlib | 11.04 | 17.83 | 1.61 | 401.45 |
| silesia/ooffice | 6152192 | zlib-ng | 6.86 | 12.04 | 1.75 | 139.54 |
| silesia/ooffice | 6152192 | libdeflate | 4.97 | 10.45 | 2.10 | 125.89 |
| silesia/ooffice | 6152192 | Wuffs | 8.10 | 14.47 | 1.79 | 220.44 |
| silesia/ooffice | 6152192 | stdx | 5.08 | 8.52 | 1.68 | 152.15 |
| silesia/osdb | 10085684 | zlib | 6.83 | 13.54 | 1.98 | 173.02 |
| silesia/osdb | 10085684 | zlib-ng | 4.32 | 8.38 | 1.94 | 53.31 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.91 | 2.43 | 29.93 |
| silesia/osdb | 10085684 | Wuffs | 5.12 | 10.56 | 2.06 | 78.39 |
| silesia/osdb | 10085684 | stdx | 2.78 | 5.64 | 2.03 | 40.60 |
| silesia/reymont | 6627202 | zlib | 6.69 | 12.73 | 1.90 | 257.59 |
| silesia/reymont | 6627202 | zlib-ng | 3.72 | 7.72 | 2.07 | 60.05 |
| silesia/reymont | 6627202 | libdeflate | 2.58 | 6.91 | 2.68 | 51.37 |
| silesia/reymont | 6627202 | Wuffs | 4.26 | 8.40 | 1.97 | 112.07 |
| silesia/reymont | 6627202 | stdx | 2.31 | 5.13 | 2.23 | 64.62 |
| silesia/samba | 21606400 | zlib | 5.49 | 11.09 | 2.02 | 171.51 |
| silesia/samba | 21606400 | zlib-ng | 3.35 | 6.47 | 1.93 | 55.86 |
| silesia/samba | 21606400 | libdeflate | 2.30 | 5.58 | 2.42 | 42.86 |
| silesia/samba | 21606400 | Wuffs | 3.67 | 7.33 | 2.00 | 81.09 |
| silesia/samba | 21606400 | stdx | 2.28 | 4.48 | 1.97 | 56.46 |
| silesia/sao | 7251944 | zlib | 9.95 | 20.36 | 2.05 | 201.01 |
| silesia/sao | 7251944 | zlib-ng | 7.86 | 14.83 | 1.89 | 79.25 |
| silesia/sao | 7251944 | libdeflate | 5.76 | 12.73 | 2.21 | 79.45 |
| silesia/sao | 7251944 | Wuffs | 8.13 | 18.14 | 2.23 | 85.37 |
| silesia/sao | 7251944 | stdx | 5.58 | 10.27 | 1.84 | 86.91 |
| silesia/webster | 41458703 | zlib | 7.07 | 12.99 | 1.84 | 275.65 |
| silesia/webster | 41458703 | zlib-ng | 4.23 | 8.04 | 1.90 | 85.02 |
| silesia/webster | 41458703 | libdeflate | 2.90 | 7.17 | 2.47 | 68.74 |
| silesia/webster | 41458703 | Wuffs | 4.56 | 8.62 | 1.89 | 123.10 |
| silesia/webster | 41458703 | stdx | 2.82 | 5.59 | 1.98 | 86.83 |
| silesia/x-ray | 8474240 | zlib | 12.26 | 23.82 | 1.94 | 323.32 |
| silesia/x-ray | 8474240 | zlib-ng | 8.99 | 17.39 | 1.93 | 123.97 |
| silesia/x-ray | 8474240 | libdeflate | 6.55 | 15.26 | 2.33 | 124.87 |
| silesia/x-ray | 8474240 | Wuffs | 10.10 | 20.40 | 2.02 | 192.51 |
| silesia/x-ray | 8474240 | stdx | 6.14 | 11.46 | 1.87 | 138.04 |
| silesia/xml | 5345280 | zlib | 3.64 | 8.20 | 2.25 | 116.44 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.50 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.46 | 31.53 |
| silesia/xml | 5345280 | Wuffs | 2.20 | 4.14 | 1.88 | 60.81 |
| silesia/xml | 5345280 | stdx | 1.34 | 2.67 | 1.99 | 42.08 |
| canterbury/alice29.txt | 152089 | zlib | 7.66 | 15.08 | 1.97 | 290.31 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.54 | 9.91 | 2.18 | 59.78 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.14 | 8.96 | 2.85 | 55.17 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.74 | 10.37 | 2.19 | 98.42 |
| canterbury/alice29.txt | 152089 | stdx | 2.73 | 7.05 | 2.59 | 62.50 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.23 | 16.11 | 1.96 | 308.16 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.13 | 10.86 | 2.12 | 73.68 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.56 | 9.82 | 2.76 | 67.94 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.12 | 11.34 | 2.22 | 99.92 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.11 | 7.59 | 2.44 | 79.31 |
| canterbury/cp.html | 24603 | zlib | 6.45 | 14.20 | 2.20 | 166.97 |
| canterbury/cp.html | 24603 | zlib-ng | 4.20 | 9.50 | 2.26 | 38.56 |
| canterbury/cp.html | 24603 | libdeflate | 2.86 | 7.95 | 2.78 | 16.60 |
| canterbury/cp.html | 24603 | Wuffs | 4.47 | 10.87 | 2.43 | 56.17 |
| canterbury/cp.html | 24603 | stdx | 2.70 | 7.38 | 2.73 | 11.91 |
| canterbury/fields.c | 11150 | zlib | 4.55 | 14.65 | 3.22 | 36.39 |
| canterbury/fields.c | 11150 | zlib-ng | 3.86 | 10.20 | 2.64 | 12.75 |
| canterbury/fields.c | 11150 | libdeflate | 2.75 | 8.32 | 3.03 | 1.79 |
| canterbury/fields.c | 11150 | Wuffs | 3.85 | 11.51 | 2.99 | 10.68 |
| canterbury/fields.c | 11150 | stdx | 2.64 | 8.05 | 3.05 | 3.85 |
| canterbury/grammar.lsp | 3721 | zlib | 6.10 | 21.22 | 3.48 | 4.86 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.82 | 17.48 | 3.00 | 7.30 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.36 | 12.05 | 2.76 | 0.40 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.99 | 18.87 | 3.15 | 4.24 |
| canterbury/grammar.lsp | 3721 | stdx | 4.25 | 13.38 | 3.15 | 0.67 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.96 | 12.20 | 3.08 | 48.44 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.85 | 6.97 | 2.45 | 12.62 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.74 | 5.97 | 2.18 | 9.16 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.19 | 8.67 | 2.72 | 14.64 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.66 | 2.66 | 16.78 |
| canterbury/lcet10.txt | 426754 | zlib | 7.46 | 14.53 | 1.95 | 285.62 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.17 | 60.06 |
| canterbury/lcet10.txt | 426754 | libdeflate | 2.99 | 8.48 | 2.84 | 55.41 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.58 | 9.85 | 2.15 | 100.89 |
| canterbury/lcet10.txt | 426754 | stdx | 2.61 | 6.46 | 2.48 | 66.83 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.39 | 16.53 | 1.97 | 317.49 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.32 | 11.19 | 2.10 | 79.24 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.72 | 10.19 | 2.74 | 77.44 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.17 | 11.53 | 2.23 | 99.34 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 7.68 | 2.43 | 85.27 |
| canterbury/ptt5 | 513216 | zlib | 4.43 | 7.79 | 1.76 | 100.23 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.00 | 3.74 | 1.87 | 46.58 |
| canterbury/ptt5 | 513216 | libdeflate | 1.46 | 3.02 | 2.07 | 38.57 |
| canterbury/ptt5 | 513216 | Wuffs | 2.20 | 4.02 | 1.83 | 58.80 |
| canterbury/ptt5 | 513216 | stdx | 1.46 | 2.55 | 1.76 | 49.60 |
| canterbury/sum | 38240 | zlib | 7.29 | 14.98 | 2.05 | 214.88 |
| canterbury/sum | 38240 | zlib-ng | 4.65 | 10.02 | 2.15 | 56.22 |
| canterbury/sum | 38240 | libdeflate | 3.29 | 8.34 | 2.53 | 34.45 |
| canterbury/sum | 38240 | Wuffs | 5.17 | 11.41 | 2.21 | 89.38 |
| canterbury/sum | 38240 | stdx | 3.02 | 7.76 | 2.56 | 27.58 |
| canterbury/xargs.1 | 4227 | zlib | 6.57 | 22.08 | 3.36 | 9.28 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.40 | 17.97 | 2.81 | 10.54 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.70 | 13.27 | 2.82 | 0.46 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.54 | 19.63 | 3.00 | 11.83 |
| canterbury/xargs.1 | 4227 | stdx | 4.55 | 13.96 | 3.07 | 1.00 |
| canterbury-large/E.coli | 4638690 | zlib | 6.03 | 14.55 | 2.41 | 177.99 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.24 | 9.68 | 2.28 | 47.50 |
| canterbury-large/E.coli | 4638690 | libdeflate | 2.98 | 8.86 | 2.98 | 48.65 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.00 | 9.64 | 2.41 | 61.15 |
| canterbury-large/E.coli | 4638690 | stdx | 2.50 | 6.78 | 2.71 | 54.32 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.82 | 13.26 | 1.94 | 263.93 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.78 | 8.26 | 2.18 | 53.98 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.58 | 7.45 | 2.89 | 45.27 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.18 | 8.72 | 2.09 | 100.66 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.25 | 5.60 | 2.49 | 55.94 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.00 | 12.69 | 1.81 | 274.96 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.57 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.14 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.53 | 8.44 | 1.86 | 129.65 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.74 | 5.43 | 1.98 | 90.58 |
| http/html-1kx1024 | 1048576 | zlib | 15.39 | 32.44 | 2.11 | 354.73 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.67 | 28.43 | 2.24 | 219.97 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.55 | 20.05 | 1.90 | 155.70 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.61 | 35.05 | 2.40 | 264.55 |
| http/html-1kx1024 | 1048576 | stdx | 10.84 | 25.92 | 2.39 | 194.18 |
| http/html-16kx64 | 1048576 | zlib | 6.01 | 11.79 | 1.96 | 214.74 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.86 | 7.54 | 1.95 | 84.94 |
| http/html-16kx64 | 1048576 | libdeflate | 2.64 | 6.04 | 2.29 | 60.19 |
| http/html-16kx64 | 1048576 | Wuffs | 4.28 | 8.51 | 1.99 | 117.29 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 5.83 | 2.19 | 62.25 |
| http/html-1m | 1048576 | zlib | 4.68 | 9.51 | 2.03 | 173.25 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 60.08 |
| http/html-1m | 1048576 | libdeflate | 1.69 | 4.39 | 2.60 | 37.49 |
| http/html-1m | 1048576 | Wuffs | 2.98 | 5.42 | 1.82 | 90.60 |
| http/html-1m | 1048576 | stdx | 1.65 | 3.47 | 2.10 | 52.76 |
| http/json-1kx1024 | 1048576 | zlib | 9.30 | 20.83 | 2.24 | 196.08 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.25 | 131.38 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.80 | 16.72 | 1.90 | 92.65 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.47 | 31.72 | 2.76 | 144.88 |
| http/json-1kx1024 | 1048576 | stdx | 6.61 | 17.03 | 2.58 | 107.20 |
| http/json-16kx64 | 1048576 | zlib | 3.95 | 9.62 | 2.44 | 102.28 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.60 | 5.50 | 2.11 | 50.20 |
| http/json-16kx64 | 1048576 | libdeflate | 1.91 | 4.24 | 2.22 | 39.95 |
| http/json-16kx64 | 1048576 | Wuffs | 2.82 | 6.35 | 2.26 | 58.45 |
| http/json-16kx64 | 1048576 | stdx | 1.88 | 4.24 | 2.26 | 40.87 |
| http/json-1m | 1048576 | zlib | 3.26 | 8.25 | 2.53 | 81.65 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.02 | 37.35 |
| http/json-1m | 1048576 | libdeflate | 1.37 | 3.33 | 2.42 | 32.27 |
| http/json-1m | 1048576 | Wuffs | 2.05 | 4.29 | 2.09 | 44.62 |
| http/json-1m | 1048576 | stdx | 1.34 | 2.68 | 2.00 | 40.15 |
| http/js-1kx1024 | 1048576 | zlib | 16.86 | 35.33 | 2.10 | 407.06 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.75 | 31.25 | 2.27 | 239.78 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.25 | 21.58 | 1.92 | 179.70 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.78 | 37.71 | 2.39 | 294.57 |
| http/js-1kx1024 | 1048576 | stdx | 11.77 | 27.69 | 2.35 | 225.06 |
| http/js-16kx64 | 1048576 | zlib | 6.92 | 13.06 | 1.89 | 255.84 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.40 | 8.65 | 1.97 | 92.18 |
| http/js-16kx64 | 1048576 | libdeflate | 3.06 | 7.01 | 2.29 | 71.84 |
| http/js-16kx64 | 1048576 | Wuffs | 4.85 | 9.70 | 2.00 | 130.16 |
| http/js-16kx64 | 1048576 | stdx | 3.14 | 6.80 | 2.16 | 75.06 |
| http/js-1m | 1048576 | zlib | 5.20 | 10.26 | 1.97 | 197.91 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.96 | 60.10 |
| http/js-1m | 1048576 | libdeflate | 1.91 | 4.98 | 2.61 | 41.99 |
| http/js-1m | 1048576 | Wuffs | 3.28 | 6.10 | 1.86 | 95.57 |
| http/js-1m | 1048576 | stdx | 1.82 | 3.91 | 2.15 | 55.49 |
| http/css-1kx1024 | 1048576 | zlib | 12.74 | 27.18 | 2.13 | 286.36 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.23 | 23.04 | 2.25 | 172.85 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.14 | 17.37 | 1.90 | 122.19 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.08 | 29.48 | 2.44 | 208.65 |
| http/css-1kx1024 | 1048576 | stdx | 9.00 | 22.95 | 2.55 | 137.82 |
| http/css-16kx64 | 1048576 | zlib | 4.66 | 10.12 | 2.17 | 151.75 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.79 | 6.07 | 2.18 | 50.10 |
| http/css-16kx64 | 1048576 | libdeflate | 1.87 | 4.69 | 2.51 | 28.51 |
| http/css-16kx64 | 1048576 | Wuffs | 3.12 | 6.97 | 2.24 | 70.02 |
| http/css-16kx64 | 1048576 | stdx | 1.85 | 4.66 | 2.52 | 29.88 |
| http/css-1m | 1048576 | zlib | 3.39 | 8.00 | 2.36 | 106.75 |
| http/css-1m | 1048576 | zlib-ng | 1.70 | 3.75 | 2.20 | 29.72 |
| http/css-1m | 1048576 | libdeflate | 1.04 | 3.18 | 3.07 | 10.33 |
| http/css-1m | 1048576 | Wuffs | 1.91 | 4.08 | 2.13 | 44.95 |
| http/css-1m | 1048576 | stdx | 1.02 | 2.57 | 2.51 | 21.54 |
| shuffled/dickens-1m | 1048576 | zlib | 12.75 | 22.42 | 1.76 | 371.19 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.69 | 16.72 | 1.72 | 199.38 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.14 | 14.95 | 2.09 | 193.54 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.63 | 18.95 | 1.97 | 205.06 |
| shuffled/dickens-1m | 1048576 | stdx | 7.11 | 11.99 | 1.69 | 207.15 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.55 | 14.04 | 3.95 | 3.45 |
| silesia/dickens | 10192446 | stdx | 3.68 | 12.47 | 3.39 | 3.77 |
| silesia/mozilla | 51220480 | libzstd | 2.86 | 9.62 | 3.37 | 30.04 |
| silesia/mozilla | 51220480 | stdx | 2.85 | 9.68 | 3.39 | 15.68 |
| silesia/mr | 9970564 | libzstd | 3.08 | 11.98 | 3.89 | 6.25 |
| silesia/mr | 9970564 | stdx | 3.11 | 10.83 | 3.48 | 5.49 |
| silesia/nci | 33553445 | libzstd | 1.62 | 4.84 | 2.98 | 23.59 |
| silesia/nci | 33553445 | stdx | 1.63 | 4.63 | 2.84 | 13.50 |
| silesia/ooffice | 6152192 | libzstd | 3.41 | 12.14 | 3.56 | 31.16 |
| silesia/ooffice | 6152192 | stdx | 3.35 | 12.40 | 3.70 | 12.08 |
| silesia/osdb | 10085684 | libzstd | 2.38 | 8.44 | 3.55 | 15.01 |
| silesia/osdb | 10085684 | stdx | 2.44 | 8.11 | 3.32 | 15.39 |
| silesia/reymont | 6627202 | libzstd | 3.29 | 11.61 | 3.52 | 11.61 |
| silesia/reymont | 6627202 | stdx | 3.43 | 10.36 | 3.02 | 12.97 |
| silesia/samba | 21606400 | libzstd | 2.08 | 7.39 | 3.55 | 18.62 |
| silesia/samba | 21606400 | stdx | 2.14 | 6.83 | 3.19 | 17.66 |
| silesia/sao | 7251944 | libzstd | 3.79 | 12.69 | 3.35 | 26.41 |
| silesia/sao | 7251944 | stdx | 3.49 | 12.58 | 3.61 | 6.17 |
| silesia/webster | 41458703 | libzstd | 3.20 | 11.22 | 3.51 | 16.22 |
| silesia/webster | 41458703 | stdx | 3.36 | 10.05 | 2.99 | 18.12 |
| silesia/x-ray | 8474240 | libzstd | 3.96 | 14.93 | 3.77 | 18.82 |
| silesia/x-ray | 8474240 | stdx | 3.57 | 13.23 | 3.71 | 8.37 |
| silesia/xml | 5345280 | libzstd | 1.54 | 5.55 | 3.61 | 22.75 |
| silesia/xml | 5345280 | stdx | 1.52 | 5.16 | 3.39 | 17.07 |
| canterbury/alice29.txt | 152089 | libzstd | 3.36 | 16.18 | 4.82 | 4.23 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.47 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.01 | 14.25 | 4.74 | 3.31 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.30 | 0.24 |
| canterbury/cp.html | 24603 | libzstd | 2.68 | 10.74 | 4.01 | 9.28 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.11 | 0.17 |
| canterbury/fields.c | 11150 | libzstd | 3.14 | 13.61 | 4.33 | 10.12 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.23 | 0.08 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.26 | 16.93 | 3.98 | 7.99 |
| canterbury/grammar.lsp | 3721 | stdx | 4.13 | 16.53 | 4.00 | 0.40 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.51 | 11.22 | 4.48 | 7.75 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.25 | 0.83 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.74 | 12.87 | 4.70 | 5.25 |
| canterbury/lcet10.txt | 426754 | stdx | 2.71 | 11.52 | 4.25 | 2.83 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.17 | 15.14 | 4.77 | 1.60 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.27 | 1.15 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.50 | 3.11 | 24.27 |
| canterbury/ptt5 | 513216 | stdx | 1.33 | 4.46 | 3.34 | 13.35 |
| canterbury/sum | 38240 | libzstd | 2.67 | 10.51 | 3.93 | 12.67 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.43 |
| canterbury/xargs.1 | 4227 | libzstd | 4.28 | 17.40 | 4.06 | 10.41 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 17.16 | 4.06 | 0.16 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.07 | 13.63 | 4.44 | 2.07 |
| canterbury-large/E.coli | 4638690 | stdx | 3.09 | 12.04 | 3.89 | 2.97 |
| canterbury-large/bible.txt | 4047392 | libzstd | 3.01 | 11.99 | 3.99 | 8.46 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.10 | 10.64 | 3.43 | 9.43 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.57 | 9.59 | 3.73 | 19.77 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.65 | 8.64 | 3.26 | 21.57 |
| http/html-1kx1024 | 1048576 | libzstd | 7.41 | 21.63 | 2.92 | 62.72 |
| http/html-1kx1024 | 1048576 | stdx | 7.46 | 22.43 | 3.01 | 76.75 |
| http/html-16kx64 | 1048576 | libzstd | 2.67 | 10.15 | 3.80 | 28.71 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.60 | 30.90 |
| http/html-1m | 1048576 | libzstd | 2.00 | 7.86 | 3.94 | 24.34 |
| http/html-1m | 1048576 | stdx | 2.00 | 7.12 | 3.56 | 24.88 |
| http/json-1kx1024 | 1048576 | libzstd | 6.38 | 17.37 | 2.72 | 48.98 |
| http/json-1kx1024 | 1048576 | stdx | 6.23 | 17.84 | 2.86 | 54.27 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.22 | 3.53 | 27.92 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.59 | 19.66 |
| http/json-1m | 1048576 | libzstd | 1.72 | 6.04 | 3.50 | 27.82 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.63 | 14.33 |
| http/js-1kx1024 | 1048576 | libzstd | 8.44 | 26.38 | 3.12 | 72.38 |
| http/js-1kx1024 | 1048576 | stdx | 9.03 | 27.57 | 3.05 | 113.13 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.71 | 4.00 | 24.47 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.73 | 26.55 |
| http/js-1m | 1048576 | libzstd | 2.02 | 8.18 | 4.04 | 20.34 |
| http/js-1m | 1048576 | stdx | 2.07 | 7.48 | 3.62 | 20.65 |
| http/css-1kx1024 | 1048576 | libzstd | 7.03 | 19.70 | 2.80 | 53.22 |
| http/css-1kx1024 | 1048576 | stdx | 6.85 | 19.93 | 2.91 | 63.83 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.69 | 3.88 | 23.16 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.03 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.57 | 3.86 | 5.40 |
| http/css-1m | 1048576 | stdx | 0.72 | 2.49 | 3.47 | 4.38 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.81 | 9.40 | 3.35 | 28.63 |
| shuffled/dickens-1m | 1048576 | stdx | 2.74 | 9.19 | 3.36 | 12.79 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.58 | 17.04 | 2.25 | 100.95 |
| silesia/dickens | 1048576 | stdx | 5.23 | 12.38 | 2.37 | 54.69 |
| silesia/mozilla | 1048576 | Google | 13.61 | 27.77 | 2.04 | 46.28 |
| silesia/mozilla | 1048576 | stdx | 8.34 | 15.02 | 1.80 | 47.92 |
| silesia/mr | 1048576 | Google | 8.97 | 20.24 | 2.26 | 101.92 |
| silesia/mr | 1048576 | stdx | 5.81 | 13.25 | 2.28 | 88.23 |
| silesia/nci | 1048576 | Google | 2.57 | 5.69 | 2.21 | 51.04 |
| silesia/nci | 1048576 | stdx | 1.95 | 3.95 | 2.03 | 54.94 |
| silesia/ooffice | 1048576 | Google | 14.31 | 29.28 | 2.05 | 288.94 |
| silesia/ooffice | 1048576 | stdx | 10.97 | 20.33 | 1.85 | 324.23 |
| silesia/osdb | 1048576 | Google | 8.31 | 17.38 | 2.09 | 96.61 |
| silesia/osdb | 1048576 | stdx | 5.20 | 10.57 | 2.03 | 92.71 |
| silesia/reymont | 1048576 | Google | 5.52 | 12.73 | 2.30 | 82.26 |
| silesia/reymont | 1048576 | stdx | 3.75 | 9.25 | 2.47 | 47.77 |
| silesia/samba | 1048576 | Google | 7.60 | 16.22 | 2.13 | 95.73 |
| silesia/samba | 1048576 | stdx | 5.07 | 10.71 | 2.11 | 66.99 |
| silesia/sao | 1048576 | Google | 16.86 | 36.97 | 2.19 | 164.16 |
| silesia/sao | 1048576 | stdx | 10.45 | 22.65 | 2.17 | 143.29 |
| silesia/webster | 1048576 | Google | 6.63 | 14.07 | 2.12 | 115.02 |
| silesia/webster | 1048576 | stdx | 4.44 | 9.98 | 2.25 | 68.75 |
| silesia/x-ray | 1048576 | Google | 19.52 | 38.46 | 1.97 | 234.14 |
| silesia/x-ray | 1048576 | stdx | 14.89 | 30.18 | 2.03 | 234.55 |
| silesia/xml | 1048576 | Google | 3.49 | 7.65 | 2.19 | 65.48 |
| silesia/xml | 1048576 | stdx | 2.42 | 5.40 | 2.24 | 47.17 |
| canterbury/alice29.txt | 152089 | Google | 8.93 | 20.66 | 2.31 | 135.61 |
| canterbury/alice29.txt | 152089 | stdx | 6.06 | 15.33 | 2.53 | 81.59 |
| canterbury/asyoulik.txt | 125179 | Google | 10.43 | 23.83 | 2.28 | 170.29 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.07 | 17.43 | 2.46 | 104.33 |
| canterbury/cp.html | 24603 | Google | 9.10 | 22.18 | 2.44 | 111.09 |
| canterbury/cp.html | 24603 | stdx | 5.69 | 17.15 | 3.01 | 30.65 |
| canterbury/fields.c | 11150 | Google | 7.09 | 21.25 | 3.00 | 25.04 |
| canterbury/fields.c | 11150 | stdx | 4.90 | 17.08 | 3.49 | 2.41 |
| canterbury/grammar.lsp | 3721 | Google | 9.86 | 30.23 | 3.07 | 7.80 |
| canterbury/grammar.lsp | 3721 | stdx | 7.20 | 25.04 | 3.48 | 0.73 |
| canterbury/kennedy.xls | 1029744 | Google | 5.48 | 17.05 | 3.11 | 37.36 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.86 | 12.94 | 3.36 | 34.03 |
| canterbury/lcet10.txt | 426754 | Google | 7.77 | 17.42 | 2.24 | 129.54 |
| canterbury/lcet10.txt | 426754 | stdx | 5.21 | 12.96 | 2.49 | 66.61 |
| canterbury/plrabn12.txt | 481861 | Google | 9.12 | 20.94 | 2.30 | 133.56 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.14 | 15.04 | 2.45 | 87.07 |
| canterbury/ptt5 | 513216 | Google | 4.29 | 10.36 | 2.42 | 61.94 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.06 | 65.60 |
| canterbury/sum | 38240 | Google | 10.78 | 26.44 | 2.45 | 154.59 |
| canterbury/sum | 38240 | stdx | 8.26 | 21.11 | 2.56 | 149.94 |
| canterbury/xargs.1 | 4227 | Google | 10.92 | 34.81 | 3.19 | 7.26 |
| canterbury/xargs.1 | 4227 | stdx | 8.46 | 30.44 | 3.60 | 6.44 |
| canterbury-large/E.coli | 1048576 | Google | 7.48 | 19.44 | 2.60 | 1.31 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.23 |
| canterbury-large/bible.txt | 1048576 | Google | 5.40 | 12.38 | 2.30 | 81.21 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.55 | 8.93 | 2.51 | 39.84 |
| canterbury-large/world192.txt | 1048576 | Google | 6.27 | 12.88 | 2.05 | 115.81 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.47 | 9.38 | 2.10 | 77.54 |
| http/html-1kx1024 | 1048576 | Google | 17.93 | 42.09 | 2.35 | 385.47 |
| http/html-1kx1024 | 1048576 | stdx | 15.32 | 37.56 | 2.45 | 360.13 |
| http/html-16kx64 | 1048576 | Google | 6.75 | 14.88 | 2.21 | 149.19 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.54 |
| http/html-1m | 1048576 | Google | 4.08 | 8.99 | 2.20 | 83.38 |
| http/html-1m | 1048576 | stdx | 2.90 | 6.52 | 2.25 | 54.81 |
| http/json-1kx1024 | 1048576 | Google | 14.31 | 36.74 | 2.57 | 238.47 |
| http/json-1kx1024 | 1048576 | stdx | 13.05 | 33.63 | 2.58 | 277.19 |
| http/json-16kx64 | 1048576 | Google | 4.41 | 11.42 | 2.59 | 80.50 |
| http/json-16kx64 | 1048576 | stdx | 3.38 | 8.42 | 2.49 | 83.40 |
| http/json-1m | 1048576 | Google | 3.41 | 8.66 | 2.53 | 58.46 |
| http/json-1m | 1048576 | stdx | 2.48 | 5.99 | 2.42 | 57.85 |
| http/js-1kx1024 | 1048576 | Google | 19.83 | 46.38 | 2.34 | 424.81 |
| http/js-1kx1024 | 1048576 | stdx | 16.40 | 39.90 | 2.43 | 378.84 |
| http/js-16kx64 | 1048576 | Google | 8.06 | 17.79 | 2.21 | 167.34 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.38 |
| http/js-1m | 1048576 | Google | 4.42 | 9.60 | 2.17 | 83.30 |
| http/js-1m | 1048576 | stdx | 3.18 | 7.25 | 2.28 | 55.45 |
| http/css-1kx1024 | 1048576 | Google | 15.38 | 37.48 | 2.44 | 292.65 |
| http/css-1kx1024 | 1048576 | stdx | 13.83 | 34.70 | 2.51 | 301.59 |
| http/css-16kx64 | 1048576 | Google | 4.94 | 11.78 | 2.38 | 100.11 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.48 | 80.22 |
| http/css-1m | 1048576 | Google | 2.44 | 9.43 | 3.86 | 16.75 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.47 | 11.82 |
| shuffled/dickens-1m | 1048576 | Google | 9.63 | 20.34 | 2.11 | 105.98 |
| shuffled/dickens-1m | 1048576 | stdx | 8.77 | 14.53 | 1.66 | 116.80 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.3 | 0.117 | 3.01 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 70.7 | 238.3 | 0.105 | 8.35 | 3.37 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 261.8 | 1119.2 | 0.813 | 30.93 | 4.28 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.3 | 106.7 | 0.137 | 3.58 | 3.53 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.0 | 107.1 | 0.296 | 3.31 | 3.82 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.0 | 378.2 | 0.390 | 11.22 | 3.98 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.0 | 89.6 | 0.004 | 3.97 | 3.32 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 70.8 | 249.9 | 0.039 | 10.43 | 3.53 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 224.9 | 880.2 | 0.930 | 33.10 | 3.91 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 27.7 | 107.5 | 0.039 | 4.08 | 3.88 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.3 | 106.7 | 0.049 | 4.16 | 3.77 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 93.6 | 345.9 | 0.377 | 13.78 | 3.69 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 113466.5 | 403839.2 | 455.216 | 0.66 | 3.56 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 613439.6 | 2684141.2 | 1349.990 | 3.56 | 4.38 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3867568.6 | 20639255.2 | 2976.959 | 22.42 | 5.34 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311565.1 | 621748.2 | 637.691 | 1.81 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 226663.9 | 848188.2 | 2246.722 | 1.31 | 3.74 |
| string: silesia/dickens | 1 | 172528 | std.json | 1575109.2 | 4595563.2 | 44497.340 | 9.13 | 2.92 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1564642.8 | 4799762.6 | 1255.643 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 15009693.6 | 60619385.6 | 56652.500 | 12.61 | 4.04 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 31549821.0 | 148769682.6 | 157169.786 | 26.51 | 4.72 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4588839.1 | 7053853.6 | 529.714 | 3.86 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1787221.6 | 7470807.6 | 14578.857 | 1.50 | 4.18 |
| string: http/json-1m | 1 | 1190272 | std.json | 9961024.6 | 47253785.6 | 32188.929 | 8.37 | 4.74 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2065080.3 | 5765412.8 | 4405.625 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6489370.6 | 24133030.8 | 12711.000 | 3.45 | 3.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 51697143.4 | 252608919.8 | 283162.875 | 27.45 | 4.89 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3678629.3 | 7945848.8 | 1863.625 | 1.95 | 2.16 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7120183.8 | 12512113.8 | 276603.250 | 3.78 | 1.76 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17489041.6 | 63922930.8 | 224361.625 | 9.29 | 3.66 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12940071.0 | 42561068.3 | 245705.333 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 173631143.0 | 732363048.3 | 388513.333 | 34.21 | 4.22 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 165585903.3 | 708654908.3 | 420159.333 | 32.62 | 4.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17578034.3 | 49745827.3 | 221622.000 | 3.46 | 2.83 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14168029.3 | 45451415.3 | 458183.333 | 2.79 | 3.21 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 77830207.7 | 314355510.3 | 455130.333 | 15.33 | 4.04 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 187998.6 | 688807.7 | 7.677 | 0.36 | 3.66 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 187323.6 | 689029.7 | 11.258 | 0.36 | 3.68 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 11123104.9 | 60818249.7 | 6.419 | 21.22 | 5.47 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 491219.7 | 1376743.7 | 3.452 | 0.94 | 2.80 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 545443.4 | 2261447.7 | 6.419 | 1.04 | 4.15 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3523800.1 | 12808414.7 | 63861.613 | 6.72 | 3.63 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 21.3 | 91.8 | 0.108 | 2.52 | 4.30 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 73.0 | 342.1 | 0.193 | 8.62 | 4.69 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 222.7 | 1092.4 | 0.853 | 26.31 | 4.90 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 20.7 | 87.2 | 0.109 | 2.45 | 4.21 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 21.9 | 83.9 | 0.136 | 2.59 | 3.83 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 26.9 | 105.4 | 0.245 | 3.18 | 3.91 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 68.8 | 310.3 | 0.376 | 8.13 | 4.51 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 21.6 | 92.6 | 0.037 | 3.18 | 4.29 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 69.4 | 324.0 | 0.062 | 10.21 | 4.67 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 172.8 | 790.0 | 1.206 | 25.44 | 4.57 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 20.1 | 88.8 | 0.038 | 2.96 | 4.42 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 19.8 | 87.1 | 0.032 | 2.92 | 4.40 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 27.8 | 117.7 | 0.032 | 4.08 | 4.24 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.4 | 270.9 | 0.278 | 8.74 | 4.56 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 122231.0 | 464403.2 | 519.691 | 0.71 | 3.80 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 518210.5 | 2182153.2 | 1212.175 | 3.00 | 4.21 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3410588.1 | 18380954.2 | 2946.000 | 19.77 | 5.39 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 125467.5 | 460565.2 | 751.515 | 0.73 | 3.67 |
| string: silesia/dickens | 1 | 172528 | simdjson | 192941.1 | 627385.2 | 1982.649 | 1.12 | 3.25 |
| string: silesia/dickens | 1 | 172528 | yyjson | 216900.2 | 848559.2 | 1438.175 | 1.26 | 3.91 |
| string: silesia/dickens | 1 | 172528 | std.json | 1363045.2 | 2890187.2 | 54317.691 | 7.90 | 2.12 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 3436362.0 | 8766181.6 | 2650.500 | 2.89 | 2.55 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 10068595.6 | 44158803.6 | 21478.571 | 8.46 | 4.39 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 26474072.1 | 124535257.6 | 138500.286 | 22.24 | 4.70 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 3421154.7 | 8990926.6 | 3150.857 | 2.87 | 2.63 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2907433.8 | 10119250.6 | 29648.929 | 2.44 | 3.48 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2673452.9 | 11226214.6 | 9582.500 | 2.25 | 4.20 |
| string: http/json-1m | 1 | 1190272 | std.json | 8695943.9 | 42694254.6 | 15636.429 | 7.31 | 4.91 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2080051.4 | 6046671.8 | 4276.125 | 1.10 | 2.91 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6768474.6 | 23416085.8 | 12345.125 | 3.59 | 3.46 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 46375892.8 | 218527029.8 | 252030.625 | 24.63 | 4.71 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2090326.6 | 6189781.8 | 4533.875 | 1.11 | 2.96 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2642972.5 | 6858904.8 | 20973.125 | 1.40 | 2.60 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12403992.0 | 26334410.8 | 419214.000 | 6.59 | 2.12 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20848060.6 | 57035436.8 | 559588.375 | 11.07 | 2.74 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 112809.3 | 426377.7 | 4.323 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 112738.7 | 426473.7 | 3.452 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 635954.8 | 3146523.7 | 6.613 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 112696.1 | 426345.7 | 2.452 | 0.21 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1223785.5 | 3932432.7 | 4.387 | 2.33 | 3.21 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1640887.4 | 5898886.7 | 5.419 | 3.13 | 3.59 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3559004.0 | 13174372.7 | 73295.129 | 6.79 | 3.70 |
