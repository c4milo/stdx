# bench-profile

| Field | Value |
|---|---|
| Commit | 9f728fe |
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
| silesia/dickens | 10192446 | zlib | 7.97 | 15.77 | 1.98 | 300.00 |
| silesia/dickens | 10192446 | zlib-ng | 4.88 | 10.50 | 2.15 | 68.26 |
| silesia/dickens | 10192446 | libdeflate | 3.44 | 9.56 | 2.78 | 65.57 |
| silesia/dickens | 10192446 | Wuffs | 4.84 | 10.85 | 2.24 | 96.63 |
| silesia/dickens | 10192446 | stdx | 3.00 | 7.48 | 2.49 | 77.40 |
| silesia/mozilla | 51220480 | zlib | 7.76 | 14.13 | 1.82 | 243.29 |
| silesia/mozilla | 51220480 | zlib-ng | 4.93 | 8.95 | 1.82 | 85.88 |
| silesia/mozilla | 51220480 | libdeflate | 3.47 | 7.63 | 2.20 | 71.05 |
| silesia/mozilla | 51220480 | Wuffs | 5.71 | 10.84 | 1.90 | 132.53 |
| silesia/mozilla | 51220480 | stdx | 3.76 | 6.98 | 1.86 | 92.39 |
| silesia/mr | 9970564 | zlib | 7.66 | 15.26 | 1.99 | 197.21 |
| silesia/mr | 9970564 | zlib-ng | 4.78 | 9.98 | 2.09 | 68.70 |
| silesia/mr | 9970564 | libdeflate | 3.35 | 8.58 | 2.56 | 61.07 |
| silesia/mr | 9970564 | Wuffs | 5.23 | 10.93 | 2.09 | 99.47 |
| silesia/mr | 9970564 | stdx | 3.19 | 7.18 | 2.26 | 71.45 |
| silesia/nci | 33553445 | zlib | 2.89 | 7.25 | 2.51 | 79.65 |
| silesia/nci | 33553445 | zlib-ng | 1.58 | 3.13 | 1.98 | 34.19 |
| silesia/nci | 33553445 | libdeflate | 1.10 | 2.66 | 2.42 | 27.79 |
| silesia/nci | 33553445 | Wuffs | 1.68 | 3.38 | 2.01 | 42.41 |
| silesia/nci | 33553445 | stdx | 1.15 | 2.29 | 1.99 | 37.37 |
| silesia/ooffice | 6152192 | zlib | 11.02 | 17.83 | 1.62 | 401.80 |
| silesia/ooffice | 6152192 | zlib-ng | 6.89 | 12.04 | 1.75 | 140.49 |
| silesia/ooffice | 6152192 | libdeflate | 4.92 | 10.45 | 2.13 | 125.42 |
| silesia/ooffice | 6152192 | Wuffs | 8.07 | 14.47 | 1.79 | 219.49 |
| silesia/ooffice | 6152192 | stdx | 5.33 | 9.60 | 1.80 | 155.96 |
| silesia/osdb | 10085684 | zlib | 6.78 | 13.54 | 2.00 | 170.88 |
| silesia/osdb | 10085684 | zlib-ng | 4.28 | 8.38 | 1.96 | 53.07 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.91 | 2.43 | 29.75 |
| silesia/osdb | 10085684 | Wuffs | 5.08 | 10.56 | 2.08 | 75.36 |
| silesia/osdb | 10085684 | stdx | 2.91 | 6.25 | 2.15 | 43.10 |
| silesia/reymont | 6627202 | zlib | 6.63 | 12.73 | 1.92 | 252.33 |
| silesia/reymont | 6627202 | zlib-ng | 3.70 | 7.72 | 2.08 | 59.74 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.57 |
| silesia/reymont | 6627202 | Wuffs | 4.22 | 8.40 | 1.99 | 113.28 |
| silesia/reymont | 6627202 | stdx | 2.34 | 5.36 | 2.29 | 64.87 |
| silesia/samba | 21606400 | zlib | 5.46 | 11.09 | 2.03 | 169.85 |
| silesia/samba | 21606400 | zlib-ng | 3.36 | 6.47 | 1.93 | 56.02 |
| silesia/samba | 21606400 | libdeflate | 2.31 | 5.58 | 2.42 | 43.11 |
| silesia/samba | 21606400 | Wuffs | 3.64 | 7.33 | 2.01 | 81.19 |
| silesia/samba | 21606400 | stdx | 2.33 | 4.77 | 2.05 | 57.50 |
| silesia/sao | 7251944 | zlib | 9.93 | 20.36 | 2.05 | 199.99 |
| silesia/sao | 7251944 | zlib-ng | 7.82 | 14.83 | 1.90 | 79.26 |
| silesia/sao | 7251944 | libdeflate | 5.73 | 12.73 | 2.22 | 79.06 |
| silesia/sao | 7251944 | Wuffs | 8.12 | 18.14 | 2.23 | 85.20 |
| silesia/sao | 7251944 | stdx | 5.91 | 11.69 | 1.98 | 92.90 |
| silesia/webster | 41458703 | zlib | 7.00 | 12.99 | 1.86 | 272.75 |
| silesia/webster | 41458703 | zlib-ng | 4.21 | 8.04 | 1.91 | 85.06 |
| silesia/webster | 41458703 | libdeflate | 2.85 | 7.17 | 2.51 | 68.59 |
| silesia/webster | 41458703 | Wuffs | 4.47 | 8.62 | 1.93 | 123.40 |
| silesia/webster | 41458703 | stdx | 2.77 | 5.86 | 2.11 | 88.02 |
| silesia/x-ray | 8474240 | zlib | 12.22 | 23.82 | 1.95 | 323.99 |
| silesia/x-ray | 8474240 | zlib-ng | 9.00 | 17.39 | 1.93 | 124.49 |
| silesia/x-ray | 8474240 | libdeflate | 6.54 | 15.26 | 2.33 | 124.46 |
| silesia/x-ray | 8474240 | Wuffs | 10.03 | 20.40 | 2.03 | 189.59 |
| silesia/x-ray | 8474240 | stdx | 6.35 | 12.46 | 1.96 | 140.60 |
| silesia/xml | 5345280 | zlib | 3.61 | 8.20 | 2.27 | 116.01 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.73 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.46 | 31.68 |
| silesia/xml | 5345280 | Wuffs | 2.19 | 4.14 | 1.89 | 61.02 |
| silesia/xml | 5345280 | stdx | 1.36 | 2.78 | 2.05 | 42.24 |
| canterbury/alice29.txt | 152089 | zlib | 7.62 | 15.08 | 1.98 | 285.06 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.54 | 9.91 | 2.18 | 60.55 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.22 | 8.96 | 2.79 | 57.78 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.69 | 10.37 | 2.21 | 98.85 |
| canterbury/alice29.txt | 152089 | stdx | 2.82 | 7.43 | 2.63 | 63.92 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.16 | 16.11 | 1.97 | 302.90 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.09 | 10.86 | 2.13 | 72.74 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.63 | 9.82 | 2.70 | 71.36 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.09 | 11.34 | 2.23 | 101.24 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.18 | 8.03 | 2.52 | 76.97 |
| canterbury/cp.html | 24603 | zlib | 6.43 | 14.20 | 2.21 | 166.29 |
| canterbury/cp.html | 24603 | zlib-ng | 4.17 | 9.50 | 2.28 | 36.13 |
| canterbury/cp.html | 24603 | libdeflate | 3.02 | 7.95 | 2.64 | 30.23 |
| canterbury/cp.html | 24603 | Wuffs | 4.53 | 10.87 | 2.40 | 60.44 |
| canterbury/cp.html | 24603 | stdx | 3.07 | 8.75 | 2.85 | 20.04 |
| canterbury/fields.c | 11150 | zlib | 4.53 | 14.65 | 3.23 | 31.45 |
| canterbury/fields.c | 11150 | zlib-ng | 3.88 | 10.20 | 2.63 | 14.76 |
| canterbury/fields.c | 11150 | libdeflate | 2.80 | 8.32 | 2.97 | 1.02 |
| canterbury/fields.c | 11150 | Wuffs | 3.81 | 11.51 | 3.02 | 8.51 |
| canterbury/fields.c | 11150 | stdx | 3.16 | 10.60 | 3.35 | 7.55 |
| canterbury/grammar.lsp | 3721 | zlib | 6.20 | 21.22 | 3.42 | 2.72 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.88 | 17.48 | 2.97 | 9.81 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.53 | 12.05 | 2.66 | 1.46 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.98 | 18.87 | 3.15 | 3.66 |
| canterbury/grammar.lsp | 3721 | stdx | 5.50 | 20.07 | 3.65 | 7.74 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.92 | 12.20 | 3.11 | 47.20 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.85 | 6.97 | 2.45 | 12.60 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.30 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.19 | 8.67 | 2.72 | 14.64 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.84 | 4.99 | 2.72 | 17.61 |
| canterbury/lcet10.txt | 426754 | zlib | 7.37 | 14.53 | 1.97 | 278.21 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.17 | 60.88 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.17 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.54 | 9.85 | 2.17 | 100.97 |
| canterbury/lcet10.txt | 426754 | stdx | 2.68 | 6.79 | 2.53 | 67.57 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.35 | 16.53 | 1.98 | 311.44 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.31 | 11.19 | 2.11 | 79.31 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.76 | 10.19 | 2.71 | 76.53 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.13 | 11.53 | 2.25 | 98.70 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.28 | 8.05 | 2.45 | 87.21 |
| canterbury/ptt5 | 513216 | zlib | 4.41 | 7.79 | 1.77 | 100.57 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.00 | 3.74 | 1.88 | 46.74 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.09 | 37.82 |
| canterbury/ptt5 | 513216 | Wuffs | 2.20 | 4.02 | 1.83 | 58.60 |
| canterbury/ptt5 | 513216 | stdx | 1.54 | 2.83 | 1.84 | 50.48 |
| canterbury/sum | 38240 | zlib | 7.21 | 14.98 | 2.08 | 211.10 |
| canterbury/sum | 38240 | zlib-ng | 4.63 | 10.02 | 2.16 | 55.92 |
| canterbury/sum | 38240 | libdeflate | 3.43 | 8.34 | 2.43 | 45.86 |
| canterbury/sum | 38240 | Wuffs | 5.03 | 11.41 | 2.27 | 78.45 |
| canterbury/sum | 38240 | stdx | 3.53 | 9.37 | 2.65 | 43.20 |
| canterbury/xargs.1 | 4227 | zlib | 6.64 | 22.08 | 3.33 | 5.28 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.40 | 17.97 | 2.81 | 9.11 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.83 | 13.27 | 2.75 | 0.16 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.49 | 19.63 | 3.03 | 9.66 |
| canterbury/xargs.1 | 4227 | stdx | 5.70 | 19.83 | 3.48 | 8.26 |
| canterbury-large/E.coli | 4638690 | zlib | 5.99 | 14.55 | 2.43 | 175.36 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.23 | 9.68 | 2.29 | 47.21 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.45 |
| canterbury-large/E.coli | 4638690 | Wuffs | 3.98 | 9.64 | 2.42 | 61.39 |
| canterbury-large/E.coli | 4638690 | stdx | 2.52 | 6.89 | 2.74 | 53.94 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.73 | 13.26 | 1.97 | 258.09 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.78 | 8.26 | 2.19 | 53.94 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.43 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.13 | 8.72 | 2.11 | 100.25 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.30 | 5.82 | 2.53 | 56.79 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.98 | 12.69 | 1.82 | 272.86 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.21 | 7.78 | 1.85 | 92.16 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.21 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.51 | 8.44 | 1.87 | 130.02 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.80 | 5.70 | 2.04 | 91.58 |
| http/html-1kx1024 | 1048576 | zlib | 15.82 | 32.44 | 2.05 | 351.37 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.66 | 28.43 | 2.25 | 214.03 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.84 | 20.05 | 1.85 | 156.29 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.66 | 35.04 | 2.39 | 267.01 |
| http/html-1kx1024 | 1048576 | stdx | 15.35 | 45.05 | 2.94 | 253.61 |
| http/html-16kx64 | 1048576 | zlib | 6.02 | 11.79 | 1.96 | 214.41 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 84.94 |
| http/html-16kx64 | 1048576 | libdeflate | 2.66 | 6.04 | 2.28 | 60.52 |
| http/html-16kx64 | 1048576 | Wuffs | 4.27 | 8.51 | 1.99 | 117.53 |
| http/html-16kx64 | 1048576 | stdx | 3.10 | 7.68 | 2.48 | 67.37 |
| http/html-1m | 1048576 | zlib | 4.64 | 9.51 | 2.05 | 172.05 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 59.74 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.71 |
| http/html-1m | 1048576 | Wuffs | 2.96 | 5.42 | 1.83 | 90.51 |
| http/html-1m | 1048576 | stdx | 1.69 | 3.67 | 2.17 | 53.19 |
| http/json-1kx1024 | 1048576 | zlib | 9.71 | 20.83 | 2.15 | 192.65 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.26 | 128.62 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.10 | 16.72 | 1.84 | 91.90 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.41 | 31.72 | 2.78 | 146.82 |
| http/json-1kx1024 | 1048576 | stdx | 9.47 | 28.05 | 2.96 | 153.56 |
| http/json-16kx64 | 1048576 | zlib | 3.94 | 9.62 | 2.44 | 101.84 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.27 |
| http/json-16kx64 | 1048576 | libdeflate | 1.93 | 4.24 | 2.20 | 40.07 |
| http/json-16kx64 | 1048576 | Wuffs | 2.82 | 6.35 | 2.26 | 58.53 |
| http/json-16kx64 | 1048576 | stdx | 2.30 | 5.89 | 2.56 | 46.34 |
| http/json-1m | 1048576 | zlib | 3.24 | 8.25 | 2.55 | 81.98 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.02 | 37.28 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.42 | 32.26 |
| http/json-1m | 1048576 | Wuffs | 2.04 | 4.29 | 2.11 | 44.26 |
| http/json-1m | 1048576 | stdx | 1.36 | 2.82 | 2.07 | 40.73 |
| http/js-1kx1024 | 1048576 | zlib | 17.30 | 35.33 | 2.04 | 404.88 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.73 | 31.25 | 2.28 | 235.34 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.53 | 21.58 | 1.87 | 179.72 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.84 | 37.70 | 2.38 | 300.20 |
| http/js-1kx1024 | 1048576 | stdx | 16.56 | 48.10 | 2.91 | 289.45 |
| http/js-16kx64 | 1048576 | zlib | 6.93 | 13.06 | 1.88 | 255.23 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.98 | 91.59 |
| http/js-16kx64 | 1048576 | libdeflate | 3.08 | 7.01 | 2.28 | 72.15 |
| http/js-16kx64 | 1048576 | Wuffs | 4.84 | 9.70 | 2.01 | 130.40 |
| http/js-16kx64 | 1048576 | stdx | 3.58 | 8.67 | 2.42 | 79.79 |
| http/js-1m | 1048576 | zlib | 5.16 | 10.26 | 1.99 | 195.43 |
| http/js-1m | 1048576 | zlib-ng | 2.89 | 5.66 | 1.96 | 60.41 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 42.25 |
| http/js-1m | 1048576 | Wuffs | 3.25 | 6.10 | 1.87 | 96.25 |
| http/js-1m | 1048576 | stdx | 1.86 | 4.10 | 2.21 | 55.99 |
| http/css-1kx1024 | 1048576 | zlib | 13.16 | 27.18 | 2.07 | 284.02 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.22 | 23.04 | 2.25 | 169.60 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.44 | 17.37 | 1.84 | 122.45 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.11 | 29.48 | 2.43 | 213.51 |
| http/css-1kx1024 | 1048576 | stdx | 13.12 | 39.50 | 3.01 | 201.36 |
| http/css-16kx64 | 1048576 | zlib | 4.67 | 10.12 | 2.17 | 150.70 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.18 | 50.20 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.47 | 28.85 |
| http/css-16kx64 | 1048576 | Wuffs | 3.12 | 6.97 | 2.23 | 70.67 |
| http/css-16kx64 | 1048576 | stdx | 2.25 | 6.24 | 2.77 | 35.25 |
| http/css-1m | 1048576 | zlib | 3.37 | 8.00 | 2.37 | 106.98 |
| http/css-1m | 1048576 | zlib-ng | 1.70 | 3.75 | 2.21 | 29.46 |
| http/css-1m | 1048576 | libdeflate | 1.05 | 3.18 | 3.03 | 10.85 |
| http/css-1m | 1048576 | Wuffs | 1.90 | 4.08 | 2.15 | 44.41 |
| http/css-1m | 1048576 | stdx | 1.04 | 2.69 | 2.57 | 21.82 |
| shuffled/dickens-1m | 1048576 | zlib | 12.77 | 22.42 | 1.76 | 376.28 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.70 | 16.72 | 1.72 | 198.60 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.04 | 14.95 | 2.12 | 193.70 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.64 | 18.95 | 1.97 | 202.29 |
| shuffled/dickens-1m | 1048576 | stdx | 7.27 | 12.73 | 1.75 | 210.67 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.35 | 14.04 | 4.18 | 3.49 |
| silesia/dickens | 10192446 | stdx | 3.45 | 12.47 | 3.61 | 3.58 |
| silesia/mozilla | 51220480 | libzstd | 2.78 | 9.62 | 3.46 | 30.14 |
| silesia/mozilla | 51220480 | stdx | 2.74 | 9.68 | 3.53 | 15.55 |
| silesia/mr | 9970564 | libzstd | 2.94 | 11.98 | 4.07 | 6.23 |
| silesia/mr | 9970564 | stdx | 2.96 | 10.83 | 3.66 | 5.16 |
| silesia/nci | 33553445 | libzstd | 1.54 | 4.84 | 3.15 | 23.52 |
| silesia/nci | 33553445 | stdx | 1.55 | 4.63 | 2.98 | 13.48 |
| silesia/ooffice | 6152192 | libzstd | 3.36 | 12.14 | 3.61 | 31.16 |
| silesia/ooffice | 6152192 | stdx | 3.28 | 12.40 | 3.79 | 12.12 |
| silesia/osdb | 10085684 | libzstd | 2.30 | 8.44 | 3.68 | 15.22 |
| silesia/osdb | 10085684 | stdx | 2.33 | 8.11 | 3.48 | 15.48 |
| silesia/reymont | 6627202 | libzstd | 3.06 | 11.61 | 3.80 | 11.58 |
| silesia/reymont | 6627202 | stdx | 3.20 | 10.36 | 3.24 | 12.81 |
| silesia/samba | 21606400 | libzstd | 1.99 | 7.39 | 3.71 | 18.62 |
| silesia/samba | 21606400 | stdx | 2.06 | 6.83 | 3.31 | 17.73 |
| silesia/sao | 7251944 | libzstd | 3.75 | 12.69 | 3.38 | 26.91 |
| silesia/sao | 7251944 | stdx | 3.42 | 12.58 | 3.68 | 6.21 |
| silesia/webster | 41458703 | libzstd | 3.02 | 11.22 | 3.72 | 16.22 |
| silesia/webster | 41458703 | stdx | 3.14 | 10.05 | 3.20 | 17.79 |
| silesia/x-ray | 8474240 | libzstd | 3.93 | 14.93 | 3.80 | 18.85 |
| silesia/x-ray | 8474240 | stdx | 3.51 | 13.23 | 3.77 | 8.25 |
| silesia/xml | 5345280 | libzstd | 1.52 | 5.55 | 3.65 | 22.80 |
| silesia/xml | 5345280 | stdx | 1.49 | 5.16 | 3.46 | 17.03 |
| canterbury/alice29.txt | 152089 | libzstd | 3.36 | 16.18 | 4.82 | 4.26 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.37 | 0.34 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.01 | 14.25 | 4.74 | 3.31 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.30 | 0.20 |
| canterbury/cp.html | 24603 | libzstd | 2.67 | 10.74 | 4.02 | 9.24 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.11 | 0.22 |
| canterbury/fields.c | 11150 | libzstd | 3.14 | 13.61 | 4.34 | 10.54 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.22 | 0.29 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.24 | 16.93 | 4.00 | 6.67 |
| canterbury/grammar.lsp | 3721 | stdx | 4.14 | 16.53 | 4.00 | 0.22 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.48 | 11.22 | 4.52 | 7.70 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.66 | 11.32 | 4.26 | 0.81 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.73 | 12.87 | 4.71 | 5.27 |
| canterbury/lcet10.txt | 426754 | stdx | 2.69 | 11.52 | 4.28 | 1.77 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.17 | 15.14 | 4.78 | 1.57 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.27 | 0.87 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.50 | 3.11 | 24.55 |
| canterbury/ptt5 | 513216 | stdx | 1.34 | 4.46 | 3.33 | 14.24 |
| canterbury/sum | 38240 | libzstd | 2.65 | 10.51 | 3.96 | 10.85 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.22 |
| canterbury/xargs.1 | 4227 | libzstd | 4.29 | 17.40 | 4.06 | 10.23 |
| canterbury/xargs.1 | 4227 | stdx | 4.25 | 17.16 | 4.04 | 0.42 |
| canterbury-large/E.coli | 4638690 | libzstd | 2.99 | 13.63 | 4.56 | 2.20 |
| canterbury-large/E.coli | 4638690 | stdx | 3.07 | 12.04 | 3.93 | 2.86 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.91 | 11.99 | 4.12 | 8.46 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.01 | 10.64 | 3.53 | 9.34 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.49 | 9.59 | 3.84 | 19.90 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.57 | 8.64 | 3.36 | 21.23 |
| http/html-1kx1024 | 1048576 | libzstd | 7.41 | 21.63 | 2.92 | 63.18 |
| http/html-1kx1024 | 1048576 | stdx | 7.45 | 22.43 | 3.01 | 76.30 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.76 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 9.61 | 3.61 | 30.29 |
| http/html-1m | 1048576 | libzstd | 1.99 | 7.86 | 3.96 | 24.32 |
| http/html-1m | 1048576 | stdx | 1.99 | 7.12 | 3.58 | 25.55 |
| http/json-1kx1024 | 1048576 | libzstd | 6.39 | 17.37 | 2.72 | 49.29 |
| http/json-1kx1024 | 1048576 | stdx | 6.21 | 17.84 | 2.87 | 53.32 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.22 | 3.52 | 28.00 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 19.79 |
| http/json-1m | 1048576 | libzstd | 1.71 | 6.04 | 3.52 | 27.64 |
| http/json-1m | 1048576 | stdx | 1.61 | 5.91 | 3.67 | 14.42 |
| http/js-1kx1024 | 1048576 | libzstd | 8.45 | 26.38 | 3.12 | 73.90 |
| http/js-1kx1024 | 1048576 | stdx | 9.05 | 27.57 | 3.05 | 112.66 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.71 | 4.00 | 24.44 |
| http/js-16kx64 | 1048576 | stdx | 2.95 | 11.06 | 3.75 | 25.67 |
| http/js-1m | 1048576 | libzstd | 2.01 | 8.18 | 4.07 | 20.48 |
| http/js-1m | 1048576 | stdx | 2.05 | 7.48 | 3.65 | 21.07 |
| http/css-1kx1024 | 1048576 | libzstd | 7.04 | 19.70 | 2.80 | 54.14 |
| http/css-1kx1024 | 1048576 | stdx | 6.86 | 19.93 | 2.91 | 63.24 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.69 | 3.88 | 23.36 |
| http/css-16kx64 | 1048576 | stdx | 2.28 | 8.43 | 3.70 | 21.84 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.57 | 3.88 | 5.57 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.52 | 4.03 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.80 | 9.40 | 3.36 | 28.68 |
| shuffled/dickens-1m | 1048576 | stdx | 2.71 | 9.19 | 3.39 | 12.40 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.46 | 17.04 | 2.28 | 102.30 |
| silesia/dickens | 1048576 | stdx | 5.06 | 12.38 | 2.45 | 54.35 |
| silesia/mozilla | 1048576 | Google | 13.57 | 27.77 | 2.05 | 46.87 |
| silesia/mozilla | 1048576 | stdx | 8.31 | 15.02 | 1.81 | 47.52 |
| silesia/mr | 1048576 | Google | 8.88 | 20.24 | 2.28 | 102.41 |
| silesia/mr | 1048576 | stdx | 5.87 | 13.25 | 2.26 | 88.13 |
| silesia/nci | 1048576 | Google | 2.54 | 5.69 | 2.23 | 52.52 |
| silesia/nci | 1048576 | stdx | 1.94 | 3.95 | 2.04 | 54.97 |
| silesia/ooffice | 1048576 | Google | 14.10 | 29.28 | 2.08 | 287.90 |
| silesia/ooffice | 1048576 | stdx | 10.95 | 20.33 | 1.86 | 324.08 |
| silesia/osdb | 1048576 | Google | 8.18 | 17.38 | 2.13 | 96.09 |
| silesia/osdb | 1048576 | stdx | 5.18 | 10.57 | 2.04 | 92.06 |
| silesia/reymont | 1048576 | Google | 5.37 | 12.73 | 2.37 | 82.57 |
| silesia/reymont | 1048576 | stdx | 3.81 | 9.25 | 2.43 | 47.83 |
| silesia/samba | 1048576 | Google | 7.56 | 16.22 | 2.14 | 96.56 |
| silesia/samba | 1048576 | stdx | 5.05 | 10.71 | 2.12 | 66.83 |
| silesia/sao | 1048576 | Google | 16.77 | 36.97 | 2.20 | 162.92 |
| silesia/sao | 1048576 | stdx | 10.45 | 22.65 | 2.17 | 141.98 |
| silesia/webster | 1048576 | Google | 6.53 | 14.07 | 2.16 | 115.59 |
| silesia/webster | 1048576 | stdx | 4.43 | 9.98 | 2.25 | 68.72 |
| silesia/x-ray | 1048576 | Google | 19.54 | 38.46 | 1.97 | 234.45 |
| silesia/x-ray | 1048576 | stdx | 14.85 | 30.18 | 2.03 | 235.62 |
| silesia/xml | 1048576 | Google | 3.45 | 7.65 | 2.21 | 66.13 |
| silesia/xml | 1048576 | stdx | 2.40 | 5.40 | 2.25 | 47.26 |
| canterbury/alice29.txt | 152089 | Google | 8.99 | 20.66 | 2.30 | 138.26 |
| canterbury/alice29.txt | 152089 | stdx | 6.07 | 15.33 | 2.53 | 81.39 |
| canterbury/asyoulik.txt | 125179 | Google | 10.43 | 23.83 | 2.28 | 172.37 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.09 | 17.43 | 2.46 | 106.28 |
| canterbury/cp.html | 24603 | Google | 9.14 | 22.18 | 2.43 | 115.51 |
| canterbury/cp.html | 24603 | stdx | 5.68 | 17.15 | 3.02 | 30.36 |
| canterbury/fields.c | 11150 | Google | 7.15 | 21.25 | 2.97 | 27.88 |
| canterbury/fields.c | 11150 | stdx | 4.85 | 17.08 | 3.53 | 1.35 |
| canterbury/grammar.lsp | 3721 | Google | 9.91 | 30.23 | 3.05 | 10.68 |
| canterbury/grammar.lsp | 3721 | stdx | 7.14 | 25.04 | 3.50 | 0.53 |
| canterbury/kennedy.xls | 1029744 | Google | 5.43 | 17.05 | 3.14 | 37.49 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.80 | 12.94 | 3.41 | 34.05 |
| canterbury/lcet10.txt | 426754 | Google | 7.78 | 17.42 | 2.24 | 131.41 |
| canterbury/lcet10.txt | 426754 | stdx | 5.22 | 12.96 | 2.48 | 65.97 |
| canterbury/plrabn12.txt | 481861 | Google | 9.10 | 20.94 | 2.30 | 135.23 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.16 | 15.04 | 2.44 | 87.31 |
| canterbury/ptt5 | 513216 | Google | 4.28 | 10.36 | 2.42 | 62.18 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.06 | 65.75 |
| canterbury/sum | 38240 | Google | 10.80 | 26.44 | 2.45 | 157.29 |
| canterbury/sum | 38240 | stdx | 8.21 | 21.11 | 2.57 | 145.98 |
| canterbury/xargs.1 | 4227 | Google | 10.97 | 34.81 | 3.17 | 12.00 |
| canterbury/xargs.1 | 4227 | stdx | 8.49 | 30.44 | 3.59 | 7.01 |
| canterbury-large/E.coli | 1048576 | Google | 7.47 | 19.44 | 2.60 | 1.34 |
| canterbury-large/E.coli | 1048576 | stdx | 6.72 | 13.48 | 2.01 | 2.41 |
| canterbury-large/bible.txt | 1048576 | Google | 5.31 | 12.38 | 2.33 | 81.45 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.55 | 8.93 | 2.52 | 39.91 |
| canterbury-large/world192.txt | 1048576 | Google | 6.17 | 12.88 | 2.09 | 116.19 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.43 | 9.38 | 2.12 | 77.67 |
| http/html-1kx1024 | 1048576 | Google | 17.95 | 42.09 | 2.34 | 390.09 |
| http/html-1kx1024 | 1048576 | stdx | 15.24 | 37.56 | 2.46 | 359.99 |
| http/html-16kx64 | 1048576 | Google | 6.75 | 14.88 | 2.21 | 150.72 |
| http/html-16kx64 | 1048576 | stdx | 5.14 | 12.15 | 2.36 | 114.87 |
| http/html-1m | 1048576 | Google | 4.04 | 8.99 | 2.22 | 83.87 |
| http/html-1m | 1048576 | stdx | 2.86 | 6.52 | 2.28 | 55.02 |
| http/json-1kx1024 | 1048576 | Google | 14.32 | 36.74 | 2.57 | 239.73 |
| http/json-1kx1024 | 1048576 | stdx | 12.94 | 33.63 | 2.60 | 276.47 |
| http/json-16kx64 | 1048576 | Google | 4.42 | 11.42 | 2.59 | 82.12 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.81 |
| http/json-1m | 1048576 | Google | 3.40 | 8.66 | 2.54 | 59.64 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.44 | 58.06 |
| http/js-1kx1024 | 1048576 | Google | 19.88 | 46.38 | 2.33 | 430.11 |
| http/js-1kx1024 | 1048576 | stdx | 16.33 | 39.90 | 2.44 | 378.41 |
| http/js-16kx64 | 1048576 | Google | 8.05 | 17.79 | 2.21 | 168.44 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.49 |
| http/js-1m | 1048576 | Google | 4.34 | 9.60 | 2.21 | 83.80 |
| http/js-1m | 1048576 | stdx | 3.16 | 7.25 | 2.30 | 55.72 |
| http/css-1kx1024 | 1048576 | Google | 15.37 | 37.48 | 2.44 | 293.49 |
| http/css-1kx1024 | 1048576 | stdx | 13.76 | 34.70 | 2.52 | 300.67 |
| http/css-16kx64 | 1048576 | Google | 4.95 | 11.78 | 2.38 | 101.59 |
| http/css-16kx64 | 1048576 | stdx | 3.82 | 9.54 | 2.49 | 80.08 |
| http/css-1m | 1048576 | Google | 2.43 | 9.43 | 3.88 | 16.84 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.47 | 12.32 |
| shuffled/dickens-1m | 1048576 | Google | 9.69 | 20.34 | 2.10 | 110.56 |
| shuffled/dickens-1m | 1048576 | stdx | 8.77 | 14.53 | 1.66 | 118.24 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.3 | 0.118 | 3.00 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 69.2 | 238.3 | 0.106 | 8.18 | 3.44 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 260.0 | 1119.2 | 0.819 | 30.71 | 4.30 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 31.1 | 109.0 | 0.098 | 3.67 | 3.50 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.9 | 107.1 | 0.299 | 3.30 | 3.83 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.3 | 378.2 | 0.382 | 11.26 | 3.97 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 26.7 | 89.6 | 0.004 | 3.93 | 3.36 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 69.6 | 249.9 | 0.041 | 10.24 | 3.59 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 223.0 | 880.2 | 0.930 | 32.83 | 3.95 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 29.6 | 108.7 | 0.029 | 4.35 | 3.68 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 27.4 | 106.7 | 0.049 | 4.04 | 3.89 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 93.8 | 345.9 | 0.350 | 13.80 | 3.69 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 115019.8 | 403839.2 | 525.381 | 0.67 | 3.51 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 614894.4 | 2684141.2 | 1346.134 | 3.56 | 4.37 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3890762.0 | 20639255.2 | 2976.485 | 22.55 | 5.30 |
| string: silesia/dickens | 1 | 172528 | simdjson | 329753.2 | 656791.2 | 502.835 | 1.91 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 230689.9 | 848188.2 | 2623.887 | 1.34 | 3.68 |
| string: silesia/dickens | 1 | 172528 | std.json | 1590332.8 | 4595563.2 | 44590.134 | 9.22 | 2.89 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1562440.1 | 4799762.6 | 1233.357 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 15051770.4 | 60619385.6 | 59662.929 | 12.65 | 4.03 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 31895132.1 | 148769682.6 | 158078.500 | 26.80 | 4.66 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4724564.8 | 7294566.6 | 538.357 | 3.97 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1786686.9 | 7470807.6 | 14728.500 | 1.50 | 4.18 |
| string: http/json-1m | 1 | 1190272 | std.json | 10058810.9 | 47253785.6 | 32465.714 | 8.45 | 4.70 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2066092.8 | 5765412.8 | 4277.125 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6495647.3 | 24133030.8 | 12649.625 | 3.45 | 3.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 51821050.0 | 252608919.8 | 283519.625 | 27.52 | 4.87 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3797842.8 | 8269494.8 | 2063.250 | 2.02 | 2.18 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7135092.1 | 12512113.8 | 279426.250 | 3.79 | 1.75 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17506126.9 | 63922930.8 | 225077.875 | 9.30 | 3.65 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12954879.7 | 42561068.3 | 245683.667 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 160728823.0 | 732363048.3 | 388678.333 | 31.67 | 4.56 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 162769035.3 | 708654908.3 | 422843.667 | 32.07 | 4.35 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 27696884.7 | 63138667.3 | 18243.333 | 5.46 | 2.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 13606780.0 | 45451415.3 | 465368.333 | 2.68 | 3.34 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 78312438.3 | 314355510.3 | 452227.000 | 15.43 | 4.01 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 185382.2 | 688807.7 | 4.903 | 0.35 | 3.72 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 183868.6 | 689029.7 | 12.484 | 0.35 | 3.75 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 11169640.3 | 60818249.7 | 9.161 | 21.30 | 5.44 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 552510.5 | 1483247.7 | 4.290 | 1.05 | 2.68 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 544066.6 | 2261447.7 | 5.613 | 1.04 | 4.16 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3374309.0 | 12808414.7 | 62038.387 | 6.44 | 3.80 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 26.8 | 113.7 | 0.156 | 3.17 | 4.24 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 73.0 | 342.1 | 0.195 | 8.63 | 4.68 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 221.3 | 1092.4 | 0.853 | 26.14 | 4.94 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 23.7 | 101.9 | 0.155 | 2.80 | 4.31 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 24.7 | 102.1 | 0.190 | 2.92 | 4.13 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.0 | 105.4 | 0.248 | 3.19 | 3.90 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 68.7 | 310.3 | 0.374 | 8.11 | 4.52 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 24.4 | 110.3 | 0.037 | 3.60 | 4.51 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.4 | 324.0 | 0.064 | 10.07 | 4.74 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 171.0 | 790.0 | 1.138 | 25.17 | 4.62 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 21.9 | 100.3 | 0.039 | 3.23 | 4.57 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 22.2 | 100.1 | 0.036 | 3.27 | 4.51 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.1 | 117.7 | 0.032 | 4.13 | 4.19 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.8 | 270.9 | 0.285 | 8.81 | 4.53 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 120678.9 | 464395.2 | 444.423 | 0.70 | 3.85 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 516141.4 | 2182153.2 | 1215.134 | 2.99 | 4.23 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3444587.1 | 18380954.2 | 2945.814 | 19.97 | 5.34 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 125270.6 | 460562.2 | 748.732 | 0.73 | 3.68 |
| string: silesia/dickens | 1 | 172528 | simdjson | 211537.7 | 687839.2 | 1125.515 | 1.23 | 3.25 |
| string: silesia/dickens | 1 | 172528 | yyjson | 217072.6 | 848559.2 | 1614.753 | 1.26 | 3.91 |
| string: silesia/dickens | 1 | 172528 | std.json | 1364160.2 | 2890187.2 | 54358.701 | 7.91 | 2.12 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 3433969.6 | 8766171.6 | 2582.214 | 2.89 | 2.55 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 10095500.3 | 44158803.6 | 23524.000 | 8.48 | 4.37 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 26532321.4 | 124535257.6 | 138368.714 | 22.29 | 4.69 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 3425793.1 | 8990929.6 | 3449.071 | 2.88 | 2.62 |
| string: http/json-1m | 1 | 1190272 | simdjson | 3536430.5 | 10817573.6 | 4226.857 | 2.97 | 3.06 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2446890.9 | 11226214.6 | 9771.571 | 2.06 | 4.59 |
| string: http/json-1m | 1 | 1190272 | std.json | 8685628.3 | 42694254.6 | 15481.786 | 7.30 | 4.92 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2081372.3 | 6046661.8 | 4206.500 | 1.11 | 2.91 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6780959.6 | 23416085.8 | 12566.500 | 3.60 | 3.45 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 46097200.6 | 218527029.8 | 250780.625 | 24.48 | 4.74 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2089428.4 | 6189784.8 | 4568.000 | 1.11 | 2.96 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2650440.1 | 7334579.8 | 10125.625 | 1.41 | 2.77 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 11849029.5 | 26334410.8 | 428469.500 | 6.29 | 2.22 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20707198.4 | 57035436.8 | 558772.625 | 11.00 | 2.75 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 112750.6 | 426364.7 | 3.742 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 112751.9 | 426473.7 | 3.871 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 638201.9 | 3146523.7 | 6.161 | 1.22 | 4.93 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 112683.0 | 426333.7 | 4.000 | 0.21 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1219431.9 | 3932432.7 | 6.548 | 2.33 | 3.22 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1637896.5 | 5898886.7 | 6.839 | 3.12 | 3.60 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3580340.3 | 13174372.7 | 77104.000 | 6.83 | 3.68 |
