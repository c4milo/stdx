# bench-profile

| Field | Value |
|---|---|
| Commit | d8eb2e8 |
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
| silesia/dickens | 10192446 | zlib | 8.01 | 15.77 | 1.97 | 307.97 |
| silesia/dickens | 10192446 | zlib-ng | 4.85 | 10.50 | 2.16 | 67.67 |
| silesia/dickens | 10192446 | libdeflate | 3.44 | 9.56 | 2.78 | 66.32 |
| silesia/dickens | 10192446 | Wuffs | 4.84 | 10.85 | 2.24 | 96.93 |
| silesia/dickens | 10192446 | stdx | 2.93 | 7.19 | 2.45 | 75.90 |
| silesia/mozilla | 51220480 | zlib | 7.76 | 14.13 | 1.82 | 244.96 |
| silesia/mozilla | 51220480 | zlib-ng | 4.91 | 8.95 | 1.82 | 85.54 |
| silesia/mozilla | 51220480 | libdeflate | 3.46 | 7.63 | 2.20 | 71.46 |
| silesia/mozilla | 51220480 | Wuffs | 5.68 | 10.84 | 1.91 | 132.85 |
| silesia/mozilla | 51220480 | stdx | 3.57 | 6.27 | 1.76 | 89.70 |
| silesia/mr | 9970564 | zlib | 7.68 | 15.26 | 1.99 | 202.65 |
| silesia/mr | 9970564 | zlib-ng | 4.77 | 9.98 | 2.09 | 67.68 |
| silesia/mr | 9970564 | libdeflate | 3.35 | 8.58 | 2.56 | 61.47 |
| silesia/mr | 9970564 | Wuffs | 5.24 | 10.93 | 2.09 | 100.96 |
| silesia/mr | 9970564 | stdx | 3.07 | 6.70 | 2.18 | 70.15 |
| silesia/nci | 33553445 | zlib | 2.90 | 7.25 | 2.50 | 79.79 |
| silesia/nci | 33553445 | zlib-ng | 1.58 | 3.13 | 1.98 | 34.71 |
| silesia/nci | 33553445 | libdeflate | 1.10 | 2.66 | 2.42 | 28.37 |
| silesia/nci | 33553445 | Wuffs | 1.68 | 3.38 | 2.01 | 42.45 |
| silesia/nci | 33553445 | stdx | 1.13 | 2.22 | 1.96 | 37.32 |
| silesia/ooffice | 6152192 | zlib | 10.98 | 17.83 | 1.62 | 402.24 |
| silesia/ooffice | 6152192 | zlib-ng | 6.87 | 12.04 | 1.75 | 140.79 |
| silesia/ooffice | 6152192 | libdeflate | 4.92 | 10.45 | 2.12 | 126.30 |
| silesia/ooffice | 6152192 | Wuffs | 8.08 | 14.47 | 1.79 | 221.64 |
| silesia/ooffice | 6152192 | stdx | 5.06 | 8.52 | 1.68 | 151.58 |
| silesia/osdb | 10085684 | zlib | 6.85 | 13.54 | 1.98 | 177.25 |
| silesia/osdb | 10085684 | zlib-ng | 4.28 | 8.38 | 1.96 | 53.64 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.91 | 2.43 | 29.84 |
| silesia/osdb | 10085684 | Wuffs | 5.14 | 10.56 | 2.05 | 82.01 |
| silesia/osdb | 10085684 | stdx | 2.77 | 5.64 | 2.04 | 40.87 |
| silesia/reymont | 6627202 | zlib | 6.68 | 12.73 | 1.91 | 260.36 |
| silesia/reymont | 6627202 | zlib-ng | 3.70 | 7.72 | 2.09 | 59.98 |
| silesia/reymont | 6627202 | libdeflate | 2.60 | 6.91 | 2.66 | 51.70 |
| silesia/reymont | 6627202 | Wuffs | 4.22 | 8.40 | 1.99 | 112.39 |
| silesia/reymont | 6627202 | stdx | 2.29 | 5.13 | 2.24 | 64.57 |
| silesia/samba | 21606400 | zlib | 5.47 | 11.09 | 2.03 | 172.06 |
| silesia/samba | 21606400 | zlib-ng | 3.33 | 6.47 | 1.95 | 55.78 |
| silesia/samba | 21606400 | libdeflate | 2.31 | 5.58 | 2.42 | 43.22 |
| silesia/samba | 21606400 | Wuffs | 3.64 | 7.33 | 2.01 | 81.25 |
| silesia/samba | 21606400 | stdx | 2.25 | 4.48 | 1.99 | 56.41 |
| silesia/sao | 7251944 | zlib | 9.95 | 20.36 | 2.05 | 203.55 |
| silesia/sao | 7251944 | zlib-ng | 7.80 | 14.83 | 1.90 | 79.10 |
| silesia/sao | 7251944 | libdeflate | 5.74 | 12.73 | 2.22 | 79.11 |
| silesia/sao | 7251944 | Wuffs | 8.09 | 18.14 | 2.24 | 85.94 |
| silesia/sao | 7251944 | stdx | 5.56 | 10.27 | 1.85 | 86.87 |
| silesia/webster | 41458703 | zlib | 7.02 | 12.99 | 1.85 | 277.33 |
| silesia/webster | 41458703 | zlib-ng | 4.16 | 8.04 | 1.93 | 85.11 |
| silesia/webster | 41458703 | libdeflate | 2.85 | 7.17 | 2.51 | 68.96 |
| silesia/webster | 41458703 | Wuffs | 4.47 | 8.62 | 1.93 | 123.31 |
| silesia/webster | 41458703 | stdx | 2.69 | 5.59 | 2.08 | 87.11 |
| silesia/x-ray | 8474240 | zlib | 12.20 | 23.82 | 1.95 | 323.65 |
| silesia/x-ray | 8474240 | zlib-ng | 8.97 | 17.39 | 1.94 | 124.04 |
| silesia/x-ray | 8474240 | libdeflate | 6.54 | 15.26 | 2.33 | 124.31 |
| silesia/x-ray | 8474240 | Wuffs | 10.04 | 20.40 | 2.03 | 192.94 |
| silesia/x-ray | 8474240 | stdx | 6.12 | 11.46 | 1.87 | 137.57 |
| silesia/xml | 5345280 | zlib | 3.63 | 8.20 | 2.26 | 117.33 |
| silesia/xml | 5345280 | zlib-ng | 1.97 | 3.88 | 1.97 | 42.74 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 31.87 |
| silesia/xml | 5345280 | Wuffs | 2.19 | 4.14 | 1.89 | 60.87 |
| silesia/xml | 5345280 | stdx | 1.32 | 2.67 | 2.01 | 42.11 |
| canterbury/alice29.txt | 152089 | zlib | 7.66 | 15.08 | 1.97 | 292.85 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.99 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.18 | 8.96 | 2.82 | 55.02 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.69 | 10.37 | 2.21 | 98.17 |
| canterbury/alice29.txt | 152089 | stdx | 2.73 | 7.04 | 2.58 | 62.83 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.20 | 16.11 | 1.97 | 308.45 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.07 | 10.86 | 2.14 | 72.84 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.55 | 9.82 | 2.77 | 64.01 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.07 | 11.34 | 2.24 | 99.83 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.07 | 7.57 | 2.47 | 75.46 |
| canterbury/cp.html | 24603 | zlib | 6.54 | 14.20 | 2.17 | 173.09 |
| canterbury/cp.html | 24603 | zlib-ng | 4.24 | 9.50 | 2.24 | 42.71 |
| canterbury/cp.html | 24603 | libdeflate | 2.81 | 7.95 | 2.83 | 10.62 |
| canterbury/cp.html | 24603 | Wuffs | 4.45 | 10.87 | 2.44 | 54.53 |
| canterbury/cp.html | 24603 | stdx | 2.70 | 7.27 | 2.70 | 13.20 |
| canterbury/fields.c | 11150 | zlib | 4.71 | 14.65 | 3.11 | 46.06 |
| canterbury/fields.c | 11150 | zlib-ng | 3.89 | 10.20 | 2.62 | 15.81 |
| canterbury/fields.c | 11150 | libdeflate | 2.81 | 8.32 | 2.96 | 0.94 |
| canterbury/fields.c | 11150 | Wuffs | 3.79 | 11.51 | 3.04 | 8.10 |
| canterbury/fields.c | 11150 | stdx | 2.59 | 7.81 | 3.02 | 3.60 |
| canterbury/grammar.lsp | 3721 | zlib | 6.21 | 21.22 | 3.41 | 4.83 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.83 | 17.48 | 3.00 | 8.19 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.50 | 12.05 | 2.68 | 0.66 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.95 | 18.87 | 3.17 | 3.88 |
| canterbury/grammar.lsp | 3721 | stdx | 4.18 | 12.79 | 3.06 | 0.77 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.93 | 12.20 | 3.10 | 48.09 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.53 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.13 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.19 | 8.67 | 2.72 | 14.76 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.66 | 2.67 | 17.04 |
| canterbury/lcet10.txt | 426754 | zlib | 7.45 | 14.53 | 1.95 | 288.90 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 60.81 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 56.15 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.55 | 9.85 | 2.17 | 100.90 |
| canterbury/lcet10.txt | 426754 | stdx | 2.63 | 6.45 | 2.46 | 66.79 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.37 | 16.53 | 1.97 | 318.68 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.27 | 11.19 | 2.12 | 77.69 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.70 | 78.89 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.12 | 11.53 | 2.25 | 99.13 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 7.68 | 2.43 | 84.95 |
| canterbury/ptt5 | 513216 | zlib | 4.41 | 7.79 | 1.77 | 100.45 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.98 | 3.74 | 1.89 | 46.41 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.09 | 37.96 |
| canterbury/ptt5 | 513216 | Wuffs | 2.19 | 4.02 | 1.84 | 58.88 |
| canterbury/ptt5 | 513216 | stdx | 1.47 | 2.55 | 1.74 | 51.45 |
| canterbury/sum | 38240 | zlib | 7.23 | 14.98 | 2.07 | 212.89 |
| canterbury/sum | 38240 | zlib-ng | 4.65 | 10.02 | 2.15 | 57.64 |
| canterbury/sum | 38240 | libdeflate | 3.24 | 8.34 | 2.57 | 26.62 |
| canterbury/sum | 38240 | Wuffs | 5.03 | 11.41 | 2.27 | 79.19 |
| canterbury/sum | 38240 | stdx | 3.00 | 7.69 | 2.56 | 27.20 |
| canterbury/xargs.1 | 4227 | zlib | 6.75 | 22.08 | 3.27 | 14.60 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.40 | 17.97 | 2.81 | 11.05 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.86 | 13.27 | 2.73 | 2.23 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.45 | 19.63 | 3.04 | 8.30 |
| canterbury/xargs.1 | 4227 | stdx | 4.50 | 13.39 | 2.97 | 0.42 |
| canterbury-large/E.coli | 4638690 | zlib | 5.99 | 14.55 | 2.43 | 178.09 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.22 | 9.68 | 2.29 | 47.31 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.02 | 8.86 | 2.94 | 48.52 |
| canterbury-large/E.coli | 4638690 | Wuffs | 3.95 | 9.64 | 2.44 | 60.96 |
| canterbury-large/E.coli | 4638690 | stdx | 2.49 | 6.78 | 2.72 | 53.94 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.79 | 13.26 | 1.95 | 265.80 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.76 | 8.26 | 2.20 | 53.80 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.61 | 7.45 | 2.85 | 45.91 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.14 | 8.72 | 2.11 | 100.49 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.24 | 5.60 | 2.50 | 55.78 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.99 | 12.69 | 1.81 | 276.15 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.17 | 7.78 | 1.86 | 91.94 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.89 | 6.92 | 2.39 | 75.87 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.49 | 8.44 | 1.88 | 129.12 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.73 | 5.43 | 1.99 | 90.45 |
| http/html-1kx1024 | 1048576 | zlib | 15.77 | 32.44 | 2.06 | 354.17 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.62 | 28.43 | 2.25 | 216.75 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.88 | 20.05 | 1.84 | 156.67 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.50 | 35.05 | 2.42 | 259.00 |
| http/html-1kx1024 | 1048576 | stdx | 10.24 | 23.73 | 2.32 | 171.63 |
| http/html-16kx64 | 1048576 | zlib | 6.02 | 11.79 | 1.96 | 215.48 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.83 | 7.54 | 1.97 | 85.22 |
| http/html-16kx64 | 1048576 | libdeflate | 2.66 | 6.04 | 2.27 | 60.67 |
| http/html-16kx64 | 1048576 | Wuffs | 4.26 | 8.51 | 2.00 | 116.74 |
| http/html-16kx64 | 1048576 | stdx | 2.62 | 5.70 | 2.17 | 61.25 |
| http/html-1m | 1048576 | zlib | 4.67 | 9.51 | 2.04 | 175.07 |
| http/html-1m | 1048576 | zlib-ng | 2.61 | 5.03 | 1.93 | 60.23 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.58 | 38.08 |
| http/html-1m | 1048576 | Wuffs | 2.96 | 5.42 | 1.83 | 90.61 |
| http/html-1m | 1048576 | stdx | 1.65 | 3.47 | 2.11 | 52.77 |
| http/json-1kx1024 | 1048576 | zlib | 9.68 | 20.83 | 2.15 | 192.61 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.26 | 130.97 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.14 | 16.72 | 1.83 | 93.34 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.30 | 31.72 | 2.81 | 142.02 |
| http/json-1kx1024 | 1048576 | stdx | 6.20 | 15.05 | 2.43 | 101.15 |
| http/json-16kx64 | 1048576 | zlib | 3.94 | 9.62 | 2.44 | 101.29 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.60 | 5.50 | 2.12 | 50.44 |
| http/json-16kx64 | 1048576 | libdeflate | 1.94 | 4.24 | 2.19 | 40.56 |
| http/json-16kx64 | 1048576 | Wuffs | 2.80 | 6.35 | 2.27 | 57.73 |
| http/json-16kx64 | 1048576 | stdx | 1.85 | 4.12 | 2.22 | 40.44 |
| http/json-1m | 1048576 | zlib | 3.24 | 8.25 | 2.54 | 81.87 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.02 | 37.49 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.67 |
| http/json-1m | 1048576 | Wuffs | 2.04 | 4.29 | 2.11 | 44.22 |
| http/json-1m | 1048576 | stdx | 1.33 | 2.68 | 2.02 | 40.28 |
| http/js-1kx1024 | 1048576 | zlib | 17.23 | 35.33 | 2.05 | 404.83 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.70 | 31.25 | 2.28 | 238.03 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.58 | 21.58 | 1.86 | 180.59 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.65 | 37.71 | 2.41 | 292.26 |
| http/js-1kx1024 | 1048576 | stdx | 11.09 | 25.49 | 2.30 | 194.77 |
| http/js-16kx64 | 1048576 | zlib | 6.93 | 13.06 | 1.88 | 257.41 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.36 | 8.65 | 1.98 | 92.30 |
| http/js-16kx64 | 1048576 | libdeflate | 3.08 | 7.01 | 2.28 | 72.24 |
| http/js-16kx64 | 1048576 | Wuffs | 4.83 | 9.70 | 2.01 | 129.55 |
| http/js-16kx64 | 1048576 | stdx | 3.08 | 6.66 | 2.16 | 72.89 |
| http/js-1m | 1048576 | zlib | 5.20 | 10.26 | 1.97 | 199.90 |
| http/js-1m | 1048576 | zlib-ng | 2.87 | 5.66 | 1.98 | 60.25 |
| http/js-1m | 1048576 | libdeflate | 1.93 | 4.98 | 2.59 | 42.32 |
| http/js-1m | 1048576 | Wuffs | 3.26 | 6.10 | 1.87 | 96.10 |
| http/js-1m | 1048576 | stdx | 1.81 | 3.91 | 2.16 | 55.69 |
| http/css-1kx1024 | 1048576 | zlib | 13.12 | 27.18 | 2.07 | 284.25 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.20 | 23.04 | 2.26 | 171.09 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.48 | 17.37 | 1.83 | 123.36 |
| http/css-1kx1024 | 1048576 | Wuffs | 11.90 | 29.48 | 2.48 | 203.45 |
| http/css-1kx1024 | 1048576 | stdx | 8.42 | 20.71 | 2.46 | 120.03 |
| http/css-16kx64 | 1048576 | zlib | 4.68 | 10.12 | 2.16 | 152.08 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.18 | 51.40 |
| http/css-16kx64 | 1048576 | libdeflate | 1.90 | 4.69 | 2.47 | 29.08 |
| http/css-16kx64 | 1048576 | Wuffs | 3.10 | 6.97 | 2.25 | 69.50 |
| http/css-16kx64 | 1048576 | stdx | 1.82 | 4.53 | 2.49 | 29.25 |
| http/css-1m | 1048576 | zlib | 3.39 | 8.00 | 2.36 | 108.02 |
| http/css-1m | 1048576 | zlib-ng | 1.70 | 3.75 | 2.20 | 30.51 |
| http/css-1m | 1048576 | libdeflate | 1.05 | 3.18 | 3.04 | 10.51 |
| http/css-1m | 1048576 | Wuffs | 1.91 | 4.08 | 2.14 | 44.80 |
| http/css-1m | 1048576 | stdx | 1.02 | 2.57 | 2.53 | 21.36 |
| shuffled/dickens-1m | 1048576 | zlib | 12.65 | 22.42 | 1.77 | 371.45 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.63 | 16.72 | 1.74 | 197.74 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.06 | 14.95 | 2.12 | 193.21 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.61 | 18.95 | 1.97 | 205.43 |
| shuffled/dickens-1m | 1048576 | stdx | 7.08 | 11.99 | 1.69 | 207.29 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.47 | 14.04 | 4.05 | 3.52 |
| silesia/dickens | 10192446 | stdx | 3.62 | 12.47 | 3.44 | 3.52 |
| silesia/mozilla | 51220480 | libzstd | 2.77 | 9.62 | 3.47 | 30.17 |
| silesia/mozilla | 51220480 | stdx | 2.74 | 9.68 | 3.53 | 15.57 |
| silesia/mr | 9970564 | libzstd | 2.97 | 11.98 | 4.04 | 6.26 |
| silesia/mr | 9970564 | stdx | 3.02 | 10.83 | 3.58 | 5.25 |
| silesia/nci | 33553445 | libzstd | 1.57 | 4.84 | 3.09 | 24.14 |
| silesia/nci | 33553445 | stdx | 1.56 | 4.63 | 2.98 | 13.52 |
| silesia/ooffice | 6152192 | libzstd | 3.36 | 12.14 | 3.61 | 31.28 |
| silesia/ooffice | 6152192 | stdx | 3.29 | 12.40 | 3.77 | 12.18 |
| silesia/osdb | 10085684 | libzstd | 2.30 | 8.44 | 3.67 | 15.15 |
| silesia/osdb | 10085684 | stdx | 2.34 | 8.11 | 3.47 | 15.42 |
| silesia/reymont | 6627202 | libzstd | 3.07 | 11.61 | 3.78 | 11.65 |
| silesia/reymont | 6627202 | stdx | 3.20 | 10.36 | 3.23 | 13.03 |
| silesia/samba | 21606400 | libzstd | 2.01 | 7.39 | 3.68 | 18.63 |
| silesia/samba | 21606400 | stdx | 2.07 | 6.83 | 3.31 | 17.65 |
| silesia/sao | 7251944 | libzstd | 3.73 | 12.69 | 3.40 | 26.37 |
| silesia/sao | 7251944 | stdx | 3.43 | 12.58 | 3.66 | 6.22 |
| silesia/webster | 41458703 | libzstd | 3.03 | 11.22 | 3.70 | 16.26 |
| silesia/webster | 41458703 | stdx | 3.16 | 10.05 | 3.18 | 18.01 |
| silesia/x-ray | 8474240 | libzstd | 3.94 | 14.93 | 3.79 | 18.87 |
| silesia/x-ray | 8474240 | stdx | 3.53 | 13.23 | 3.75 | 8.35 |
| silesia/xml | 5345280 | libzstd | 1.52 | 5.55 | 3.64 | 22.92 |
| silesia/xml | 5345280 | stdx | 1.50 | 5.16 | 3.43 | 17.11 |
| canterbury/alice29.txt | 152089 | libzstd | 3.35 | 16.18 | 4.83 | 4.15 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.46 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.00 | 14.25 | 4.75 | 3.31 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.31 | 0.26 |
| canterbury/cp.html | 24603 | libzstd | 2.67 | 10.74 | 4.01 | 8.85 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.11 | 0.19 |
| canterbury/fields.c | 11150 | libzstd | 3.19 | 13.61 | 4.27 | 10.15 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.22 | 0.18 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.25 | 16.93 | 3.99 | 7.64 |
| canterbury/grammar.lsp | 3721 | stdx | 4.13 | 16.53 | 4.00 | 0.44 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.48 | 11.22 | 4.52 | 7.77 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.66 | 11.32 | 4.25 | 0.93 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.72 | 12.87 | 4.73 | 5.26 |
| canterbury/lcet10.txt | 426754 | stdx | 2.73 | 11.52 | 4.22 | 4.46 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.16 | 15.14 | 4.80 | 1.57 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.26 | 1.23 |
| canterbury/ptt5 | 513216 | libzstd | 1.44 | 4.50 | 3.13 | 24.07 |
| canterbury/ptt5 | 513216 | stdx | 1.33 | 4.46 | 3.36 | 13.10 |
| canterbury/sum | 38240 | libzstd | 2.66 | 10.51 | 3.95 | 11.95 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.34 |
| canterbury/xargs.1 | 4227 | libzstd | 4.30 | 17.40 | 4.05 | 10.64 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.16 | 4.05 | 0.17 |
| canterbury-large/E.coli | 4638690 | libzstd | 2.98 | 13.63 | 4.57 | 2.21 |
| canterbury-large/E.coli | 4638690 | stdx | 3.06 | 12.04 | 3.93 | 2.93 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.90 | 11.99 | 4.13 | 8.54 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.99 | 10.64 | 3.56 | 9.54 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.49 | 9.59 | 3.85 | 19.64 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.59 | 8.64 | 3.33 | 21.38 |
| http/html-1kx1024 | 1048576 | libzstd | 7.38 | 21.63 | 2.93 | 62.64 |
| http/html-1kx1024 | 1048576 | stdx | 7.47 | 22.43 | 3.00 | 77.15 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.64 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 9.61 | 3.61 | 30.40 |
| http/html-1m | 1048576 | libzstd | 1.98 | 7.86 | 3.96 | 24.13 |
| http/html-1m | 1048576 | stdx | 1.99 | 7.12 | 3.58 | 25.35 |
| http/json-1kx1024 | 1048576 | libzstd | 6.35 | 17.37 | 2.74 | 49.24 |
| http/json-1kx1024 | 1048576 | stdx | 6.23 | 17.84 | 2.86 | 54.51 |
| http/json-16kx64 | 1048576 | libzstd | 2.04 | 7.22 | 3.54 | 27.97 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 20.01 |
| http/json-1m | 1048576 | libzstd | 1.71 | 6.04 | 3.54 | 27.62 |
| http/json-1m | 1048576 | stdx | 1.61 | 5.91 | 3.66 | 14.25 |
| http/js-1kx1024 | 1048576 | libzstd | 8.42 | 26.38 | 3.13 | 72.60 |
| http/js-1kx1024 | 1048576 | stdx | 9.06 | 27.57 | 3.04 | 113.55 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.71 | 4.00 | 24.36 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.73 | 25.81 |
| http/js-1m | 1048576 | libzstd | 2.01 | 8.18 | 4.07 | 20.22 |
| http/js-1m | 1048576 | stdx | 2.07 | 7.48 | 3.62 | 21.68 |
| http/css-1kx1024 | 1048576 | libzstd | 7.01 | 19.70 | 2.81 | 53.73 |
| http/css-1kx1024 | 1048576 | stdx | 6.86 | 19.93 | 2.90 | 64.12 |
| http/css-16kx64 | 1048576 | libzstd | 2.25 | 8.69 | 3.86 | 24.20 |
| http/css-16kx64 | 1048576 | stdx | 2.28 | 8.43 | 3.70 | 22.23 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.57 | 3.86 | 5.69 |
| http/css-1m | 1048576 | stdx | 0.70 | 2.49 | 3.56 | 3.97 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.80 | 9.40 | 3.36 | 28.43 |
| shuffled/dickens-1m | 1048576 | stdx | 2.73 | 9.19 | 3.37 | 12.51 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.49 | 17.04 | 2.27 | 100.93 |
| silesia/dickens | 1048576 | stdx | 5.09 | 12.38 | 2.43 | 54.58 |
| silesia/mozilla | 1048576 | Google | 13.60 | 27.77 | 2.04 | 46.49 |
| silesia/mozilla | 1048576 | stdx | 8.32 | 15.02 | 1.81 | 47.48 |
| silesia/mr | 1048576 | Google | 8.89 | 20.24 | 2.28 | 101.94 |
| silesia/mr | 1048576 | stdx | 5.78 | 13.25 | 2.29 | 88.57 |
| silesia/nci | 1048576 | Google | 2.54 | 5.69 | 2.24 | 51.41 |
| silesia/nci | 1048576 | stdx | 1.95 | 3.95 | 2.03 | 55.78 |
| silesia/ooffice | 1048576 | Google | 14.24 | 29.28 | 2.06 | 289.17 |
| silesia/ooffice | 1048576 | stdx | 10.94 | 20.33 | 1.86 | 326.53 |
| silesia/osdb | 1048576 | Google | 8.20 | 17.38 | 2.12 | 96.15 |
| silesia/osdb | 1048576 | stdx | 5.12 | 10.57 | 2.07 | 92.05 |
| silesia/reymont | 1048576 | Google | 5.48 | 12.73 | 2.32 | 81.94 |
| silesia/reymont | 1048576 | stdx | 3.73 | 9.25 | 2.48 | 47.66 |
| silesia/samba | 1048576 | Google | 7.58 | 16.22 | 2.14 | 96.13 |
| silesia/samba | 1048576 | stdx | 5.05 | 10.71 | 2.12 | 67.21 |
| silesia/sao | 1048576 | Google | 16.82 | 36.97 | 2.20 | 164.84 |
| silesia/sao | 1048576 | stdx | 10.42 | 22.65 | 2.17 | 143.84 |
| silesia/webster | 1048576 | Google | 6.55 | 14.07 | 2.15 | 115.40 |
| silesia/webster | 1048576 | stdx | 4.40 | 9.98 | 2.27 | 69.65 |
| silesia/x-ray | 1048576 | Google | 19.54 | 38.46 | 1.97 | 234.97 |
| silesia/x-ray | 1048576 | stdx | 14.54 | 30.18 | 2.08 | 233.70 |
| silesia/xml | 1048576 | Google | 3.48 | 7.65 | 2.20 | 65.57 |
| silesia/xml | 1048576 | stdx | 2.40 | 5.40 | 2.25 | 46.95 |
| canterbury/alice29.txt | 152089 | Google | 8.91 | 20.66 | 2.32 | 136.13 |
| canterbury/alice29.txt | 152089 | stdx | 6.06 | 15.33 | 2.53 | 81.29 |
| canterbury/asyoulik.txt | 125179 | Google | 10.44 | 23.83 | 2.28 | 170.82 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.09 | 17.43 | 2.46 | 106.32 |
| canterbury/cp.html | 24603 | Google | 9.12 | 22.18 | 2.43 | 110.26 |
| canterbury/cp.html | 24603 | stdx | 5.72 | 17.15 | 3.00 | 31.16 |
| canterbury/fields.c | 11150 | Google | 7.10 | 21.25 | 2.99 | 23.36 |
| canterbury/fields.c | 11150 | stdx | 4.90 | 17.08 | 3.49 | 2.15 |
| canterbury/grammar.lsp | 3721 | Google | 9.81 | 30.23 | 3.08 | 3.69 |
| canterbury/grammar.lsp | 3721 | stdx | 7.18 | 25.04 | 3.49 | 0.47 |
| canterbury/kennedy.xls | 1029744 | Google | 5.46 | 17.05 | 3.12 | 37.58 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.78 | 12.94 | 3.42 | 33.99 |
| canterbury/lcet10.txt | 426754 | Google | 7.75 | 17.42 | 2.25 | 129.94 |
| canterbury/lcet10.txt | 426754 | stdx | 5.20 | 12.96 | 2.49 | 66.44 |
| canterbury/plrabn12.txt | 481861 | Google | 9.08 | 20.94 | 2.31 | 133.73 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.17 | 15.04 | 2.44 | 86.94 |
| canterbury/ptt5 | 513216 | Google | 4.27 | 10.36 | 2.42 | 62.06 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.06 | 65.50 |
| canterbury/sum | 38240 | Google | 10.86 | 26.44 | 2.43 | 158.59 |
| canterbury/sum | 38240 | stdx | 8.25 | 21.11 | 2.56 | 148.96 |
| canterbury/xargs.1 | 4227 | Google | 10.95 | 34.81 | 3.18 | 9.22 |
| canterbury/xargs.1 | 4227 | stdx | 8.47 | 30.44 | 3.60 | 6.29 |
| canterbury-large/E.coli | 1048576 | Google | 7.47 | 19.44 | 2.60 | 1.35 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.87 |
| canterbury-large/bible.txt | 1048576 | Google | 5.34 | 12.38 | 2.32 | 81.28 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.54 | 8.93 | 2.52 | 40.01 |
| canterbury-large/world192.txt | 1048576 | Google | 6.19 | 12.88 | 2.08 | 116.26 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.38 | 9.38 | 2.14 | 77.41 |
| http/html-1kx1024 | 1048576 | Google | 17.97 | 42.09 | 2.34 | 386.82 |
| http/html-1kx1024 | 1048576 | stdx | 15.32 | 37.56 | 2.45 | 360.43 |
| http/html-16kx64 | 1048576 | Google | 6.77 | 14.88 | 2.20 | 150.39 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.72 |
| http/html-1m | 1048576 | Google | 4.06 | 8.99 | 2.21 | 83.40 |
| http/html-1m | 1048576 | stdx | 2.85 | 6.52 | 2.29 | 54.68 |
| http/json-1kx1024 | 1048576 | Google | 14.36 | 36.74 | 2.56 | 239.76 |
| http/json-1kx1024 | 1048576 | stdx | 13.00 | 33.63 | 2.59 | 277.22 |
| http/json-16kx64 | 1048576 | Google | 4.41 | 11.42 | 2.59 | 80.67 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.13 |
| http/json-1m | 1048576 | Google | 3.41 | 8.66 | 2.54 | 58.99 |
| http/json-1m | 1048576 | stdx | 2.45 | 5.99 | 2.44 | 57.79 |
| http/js-1kx1024 | 1048576 | Google | 19.87 | 46.38 | 2.33 | 427.17 |
| http/js-1kx1024 | 1048576 | stdx | 16.37 | 39.90 | 2.44 | 378.92 |
| http/js-16kx64 | 1048576 | Google | 8.07 | 17.79 | 2.20 | 167.88 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.69 |
| http/js-1m | 1048576 | Google | 4.37 | 9.60 | 2.20 | 83.58 |
| http/js-1m | 1048576 | stdx | 3.17 | 7.25 | 2.29 | 55.88 |
| http/css-1kx1024 | 1048576 | Google | 15.44 | 37.48 | 2.43 | 294.01 |
| http/css-1kx1024 | 1048576 | stdx | 13.80 | 34.70 | 2.51 | 301.95 |
| http/css-16kx64 | 1048576 | Google | 4.96 | 11.78 | 2.38 | 100.77 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.48 | 80.42 |
| http/css-1m | 1048576 | Google | 2.43 | 9.43 | 3.89 | 16.69 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.47 | 12.14 |
| shuffled/dickens-1m | 1048576 | Google | 9.78 | 20.34 | 2.08 | 115.05 |
| shuffled/dickens-1m | 1048576 | stdx | 8.75 | 14.53 | 1.66 | 115.18 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.3 | 0.119 | 3.00 | 2.93 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 70.7 | 238.3 | 0.106 | 8.35 | 3.37 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 261.8 | 1119.2 | 0.820 | 30.92 | 4.28 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.1 | 106.7 | 0.136 | 3.56 | 3.54 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.9 | 107.1 | 0.298 | 3.29 | 3.84 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 94.9 | 378.2 | 0.390 | 11.21 | 3.99 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 26.6 | 89.6 | 0.004 | 3.91 | 3.37 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 70.7 | 249.9 | 0.042 | 10.40 | 3.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 224.2 | 880.2 | 0.925 | 33.00 | 3.93 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 27.7 | 107.5 | 0.039 | 4.07 | 3.88 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 27.5 | 106.7 | 0.049 | 4.05 | 3.87 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 93.5 | 345.9 | 0.340 | 13.77 | 3.70 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 113650.7 | 403839.2 | 459.062 | 0.66 | 3.55 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 612461.9 | 2684141.2 | 1347.928 | 3.55 | 4.38 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3915059.7 | 20639255.2 | 2976.577 | 22.69 | 5.27 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311502.1 | 621748.2 | 637.464 | 1.81 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 227766.7 | 848188.2 | 2293.670 | 1.32 | 3.72 |
| string: silesia/dickens | 1 | 172528 | std.json | 1585062.4 | 4595563.2 | 44824.660 | 9.19 | 2.90 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1561533.6 | 4799762.6 | 1206.000 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 15108154.6 | 60619385.6 | 57609.286 | 12.69 | 4.01 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 31513064.4 | 148769682.6 | 158233.643 | 26.48 | 4.72 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4571659.7 | 7053853.6 | 566.786 | 3.84 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1771144.7 | 7470807.6 | 14542.500 | 1.49 | 4.22 |
| string: http/json-1m | 1 | 1190272 | std.json | 10003689.3 | 47253785.6 | 31995.071 | 8.40 | 4.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2064978.4 | 5765412.8 | 4456.875 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6452189.3 | 24133030.8 | 12667.750 | 3.43 | 3.74 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 51761490.9 | 252608919.8 | 286551.875 | 27.49 | 4.88 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3676762.6 | 7945848.8 | 1874.750 | 1.95 | 2.16 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7125693.1 | 12512113.8 | 277127.250 | 3.78 | 1.76 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17471036.8 | 63922930.8 | 224643.375 | 9.28 | 3.66 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12928149.0 | 42561068.3 | 246510.000 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 173133078.3 | 732363048.3 | 388574.667 | 34.11 | 4.23 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 165777489.0 | 708654908.3 | 420441.333 | 32.66 | 4.27 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17630591.3 | 49745827.3 | 224302.667 | 3.47 | 2.82 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 13895508.3 | 45451415.3 | 457842.333 | 2.74 | 3.27 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 78283331.0 | 314355510.3 | 450957.333 | 15.42 | 4.02 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 187903.8 | 688807.7 | 7.387 | 0.36 | 3.67 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 189087.4 | 689029.7 | 7.903 | 0.36 | 3.64 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 11148910.1 | 60818249.7 | 8.387 | 21.26 | 5.46 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 489735.5 | 1376743.7 | 3.548 | 0.93 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 541755.8 | 2261447.7 | 7.806 | 1.03 | 4.17 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3631961.0 | 12808414.7 | 66563.710 | 6.93 | 3.53 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 21.1 | 91.8 | 0.107 | 2.49 | 4.35 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 73.0 | 342.1 | 0.195 | 8.62 | 4.69 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 221.4 | 1092.4 | 0.855 | 26.15 | 4.93 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 20.5 | 87.2 | 0.109 | 2.43 | 4.25 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 21.5 | 83.9 | 0.135 | 2.54 | 3.90 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 26.8 | 105.4 | 0.244 | 3.16 | 3.94 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 68.4 | 310.3 | 0.379 | 8.08 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 20.9 | 92.6 | 0.037 | 3.08 | 4.42 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 69.2 | 324.0 | 0.062 | 10.19 | 4.68 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 172.2 | 790.0 | 1.192 | 25.34 | 4.59 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 20.1 | 88.8 | 0.038 | 2.96 | 4.41 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 19.5 | 87.1 | 0.032 | 2.88 | 4.46 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.4 | 117.7 | 0.032 | 4.18 | 4.14 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.4 | 270.9 | 0.276 | 8.74 | 4.56 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 122637.2 | 464403.2 | 539.402 | 0.71 | 3.79 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 518143.1 | 2182153.2 | 1205.443 | 3.00 | 4.21 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3408958.0 | 18380954.2 | 2945.381 | 19.76 | 5.39 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 125158.0 | 460565.2 | 740.103 | 0.73 | 3.68 |
| string: silesia/dickens | 1 | 172528 | simdjson | 192833.9 | 627385.2 | 1944.969 | 1.12 | 3.25 |
| string: silesia/dickens | 1 | 172528 | yyjson | 216706.1 | 848559.2 | 1426.062 | 1.26 | 3.92 |
| string: silesia/dickens | 1 | 172528 | std.json | 1358498.4 | 2890187.2 | 54161.526 | 7.87 | 2.13 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 3436112.1 | 8766181.6 | 2684.143 | 2.89 | 2.55 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 10052375.1 | 44158803.6 | 21997.714 | 8.45 | 4.39 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 26313733.1 | 124535257.6 | 138795.714 | 22.11 | 4.73 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 3429573.1 | 8990926.6 | 3502.643 | 2.88 | 2.62 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2903932.1 | 10119250.6 | 29451.071 | 2.44 | 3.48 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2671521.0 | 11226214.6 | 9661.357 | 2.24 | 4.20 |
| string: http/json-1m | 1 | 1190272 | std.json | 8668829.4 | 42694254.6 | 15252.071 | 7.28 | 4.93 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2083775.4 | 6046671.8 | 4311.625 | 1.11 | 2.90 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6770723.6 | 23416085.8 | 12377.000 | 3.60 | 3.46 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 46259202.4 | 218527029.8 | 252383.375 | 24.57 | 4.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2086830.6 | 6189781.8 | 4498.500 | 1.11 | 2.97 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2637936.6 | 6858904.8 | 21020.250 | 1.40 | 2.60 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12423581.8 | 26334410.8 | 418704.750 | 6.60 | 2.12 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20764901.0 | 57035436.8 | 556195.625 | 11.03 | 2.75 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 112822.9 | 426377.7 | 3.645 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 112717.4 | 426473.7 | 3.032 | 0.21 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 637573.5 | 3146523.7 | 6.677 | 1.22 | 4.94 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 112720.5 | 426345.7 | 2.129 | 0.21 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1218554.0 | 3932432.7 | 4.323 | 2.32 | 3.23 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1634982.7 | 5898886.7 | 6.032 | 3.12 | 3.61 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3558643.3 | 13174372.7 | 73302.161 | 6.79 | 3.70 |
