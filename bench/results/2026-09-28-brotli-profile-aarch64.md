# bench-profile

| Field | Value |
|---|---|
| Commit | 4c0d5c6 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260920.129.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/36498010645 |
| Date | 2026-09-28 |

## S2: how stdx's decoder took each symbol, raw DEFLATE at zlib level 6

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
| http/html-1k | 568 | 563 | 0 | 5 | 0.9912 |
| http/html-16k | 4343 | 4317 | 20 | 6 | 0.9940 |
| http/html-1m | 158301 | 157787 | 509 | 5 | 0.9968 |
| http/json-1k | 217 | 213 | 0 | 4 | 0.9816 |
| http/json-16k | 1354 | 1350 | 0 | 4 | 0.9970 |
| http/json-1m | 123160 | 122759 | 397 | 4 | 0.9967 |
| http/js-1k | 463 | 459 | 0 | 4 | 0.9914 |
| http/js-16k | 3224 | 3217 | 3 | 4 | 0.9978 |
| http/js-1m | 183438 | 182999 | 436 | 3 | 0.9976 |
| http/css-1k | 538 | 532 | 0 | 6 | 0.9888 |
| http/css-16k | 4213 | 4202 | 7 | 4 | 0.9974 |
| http/css-1m | 106766 | 106306 | 455 | 5 | 0.9957 |
| shuffled/dickens-1m | 726094 | 723324 | 2765 | 5 | 0.9962 |

## Hardware counters per decoded octet, gzip at zlib level 6

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | zlib | 7.91 | 15.78 | 1.99 | 299.18 |
| silesia/dickens | 10192446 | zlib-ng | 4.87 | 10.50 | 2.16 | 68.36 |
| silesia/dickens | 10192446 | libdeflate | 3.46 | 9.57 | 2.77 | 66.33 |
| silesia/dickens | 10192446 | Wuffs | 4.89 | 10.91 | 2.23 | 96.96 |
| silesia/dickens | 10192446 | stdx | 3.03 | 7.49 | 2.47 | 77.51 |
| silesia/mozilla | 51220480 | zlib | 7.72 | 14.13 | 1.83 | 242.16 |
| silesia/mozilla | 51220480 | zlib-ng | 4.98 | 9.03 | 1.81 | 86.80 |
| silesia/mozilla | 51220480 | libdeflate | 3.48 | 7.64 | 2.20 | 71.50 |
| silesia/mozilla | 51220480 | Wuffs | 5.72 | 10.93 | 1.91 | 133.29 |
| silesia/mozilla | 51220480 | stdx | 3.86 | 6.92 | 1.79 | 92.20 |
| silesia/mr | 9970564 | zlib | 7.61 | 15.27 | 2.01 | 193.83 |
| silesia/mr | 9970564 | zlib-ng | 4.90 | 10.29 | 2.10 | 68.41 |
| silesia/mr | 9970564 | libdeflate | 3.35 | 8.59 | 2.56 | 61.61 |
| silesia/mr | 9970564 | Wuffs | 5.27 | 11.01 | 2.09 | 102.08 |
| silesia/mr | 9970564 | stdx | 3.20 | 7.17 | 2.24 | 71.75 |
| silesia/nci | 33553445 | zlib | 2.89 | 7.25 | 2.51 | 78.68 |
| silesia/nci | 33553445 | zlib-ng | 1.60 | 3.13 | 1.96 | 35.52 |
| silesia/nci | 33553445 | libdeflate | 1.11 | 2.66 | 2.41 | 28.02 |
| silesia/nci | 33553445 | Wuffs | 1.70 | 3.40 | 2.00 | 42.84 |
| silesia/nci | 33553445 | stdx | 1.16 | 2.29 | 1.97 | 37.30 |
| silesia/ooffice | 6152192 | zlib | 10.92 | 17.83 | 1.63 | 400.05 |
| silesia/ooffice | 6152192 | zlib-ng | 6.91 | 12.05 | 1.74 | 142.12 |
| silesia/ooffice | 6152192 | libdeflate | 4.92 | 10.47 | 2.13 | 126.83 |
| silesia/ooffice | 6152192 | Wuffs | 8.08 | 14.59 | 1.81 | 221.77 |
| silesia/ooffice | 6152192 | stdx | 5.37 | 9.56 | 1.78 | 155.74 |
| silesia/osdb | 10085684 | zlib | 6.74 | 13.54 | 2.01 | 170.08 |
| silesia/osdb | 10085684 | zlib-ng | 4.30 | 8.38 | 1.95 | 54.85 |
| silesia/osdb | 10085684 | libdeflate | 2.86 | 6.92 | 2.42 | 31.31 |
| silesia/osdb | 10085684 | Wuffs | 5.16 | 10.65 | 2.07 | 81.83 |
| silesia/osdb | 10085684 | stdx | 2.98 | 6.16 | 2.07 | 43.42 |
| silesia/reymont | 6627202 | zlib | 6.58 | 12.73 | 1.93 | 253.08 |
| silesia/reymont | 6627202 | zlib-ng | 3.70 | 7.72 | 2.09 | 59.79 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.92 | 2.66 | 51.00 |
| silesia/reymont | 6627202 | Wuffs | 4.23 | 8.45 | 2.00 | 112.55 |
| silesia/reymont | 6627202 | stdx | 2.36 | 5.36 | 2.27 | 65.67 |
| silesia/samba | 21606400 | zlib | 5.42 | 11.09 | 2.05 | 169.16 |
| silesia/samba | 21606400 | zlib-ng | 3.39 | 6.52 | 1.92 | 58.42 |
| silesia/samba | 21606400 | libdeflate | 2.31 | 5.59 | 2.42 | 43.14 |
| silesia/samba | 21606400 | Wuffs | 3.65 | 7.39 | 2.02 | 81.27 |
| silesia/samba | 21606400 | stdx | 2.36 | 4.72 | 2.00 | 57.57 |
| silesia/sao | 7251944 | zlib | 9.85 | 20.36 | 2.07 | 195.15 |
| silesia/sao | 7251944 | zlib-ng | 7.83 | 14.83 | 1.89 | 80.54 |
| silesia/sao | 7251944 | libdeflate | 5.75 | 12.75 | 2.22 | 79.91 |
| silesia/sao | 7251944 | Wuffs | 8.16 | 18.34 | 2.25 | 86.88 |
| silesia/sao | 7251944 | stdx | 6.07 | 11.49 | 1.89 | 91.77 |
| silesia/webster | 41458703 | zlib | 6.95 | 12.99 | 1.87 | 271.56 |
| silesia/webster | 41458703 | zlib-ng | 4.22 | 8.04 | 1.91 | 85.23 |
| silesia/webster | 41458703 | libdeflate | 2.91 | 7.17 | 2.46 | 68.80 |
| silesia/webster | 41458703 | Wuffs | 4.50 | 8.68 | 1.93 | 123.23 |
| silesia/webster | 41458703 | stdx | 2.85 | 5.86 | 2.06 | 88.03 |
| silesia/x-ray | 8474240 | zlib | 12.19 | 23.83 | 1.95 | 325.16 |
| silesia/x-ray | 8474240 | zlib-ng | 8.99 | 17.39 | 1.93 | 125.08 |
| silesia/x-ray | 8474240 | libdeflate | 6.54 | 15.27 | 2.34 | 124.87 |
| silesia/x-ray | 8474240 | Wuffs | 10.14 | 20.58 | 2.03 | 201.07 |
| silesia/x-ray | 8474240 | stdx | 6.39 | 12.37 | 1.94 | 139.74 |
| silesia/xml | 5345280 | zlib | 3.60 | 8.21 | 2.28 | 115.59 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.89 | 1.96 | 42.92 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.34 | 2.46 | 31.65 |
| silesia/xml | 5345280 | Wuffs | 2.19 | 4.16 | 1.90 | 60.91 |
| silesia/xml | 5345280 | stdx | 1.37 | 2.78 | 2.02 | 42.37 |
| canterbury/alice29.txt | 152089 | zlib | 7.58 | 15.22 | 2.01 | 282.59 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.90 | 2.19 | 60.46 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.23 | 9.19 | 2.85 | 52.00 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.71 | 10.44 | 2.22 | 97.79 |
| canterbury/alice29.txt | 152089 | stdx | 2.88 | 7.44 | 2.59 | 64.14 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.14 | 16.28 | 2.00 | 301.75 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.10 | 10.86 | 2.13 | 73.22 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.69 | 10.09 | 2.73 | 68.44 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.10 | 11.43 | 2.24 | 99.62 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.32 | 8.03 | 2.42 | 84.86 |
| canterbury/cp.html | 24603 | zlib | 6.70 | 15.04 | 2.24 | 168.25 |
| canterbury/cp.html | 24603 | zlib-ng | 4.29 | 9.49 | 2.21 | 45.65 |
| canterbury/cp.html | 24603 | libdeflate | 3.31 | 9.33 | 2.82 | 19.62 |
| canterbury/cp.html | 24603 | Wuffs | 4.56 | 11.09 | 2.43 | 60.19 |
| canterbury/cp.html | 24603 | stdx | 3.10 | 8.73 | 2.82 | 18.96 |
| canterbury/fields.c | 11150 | zlib | 5.09 | 16.50 | 3.24 | 31.77 |
| canterbury/fields.c | 11150 | zlib-ng | 4.04 | 10.19 | 2.52 | 25.10 |
| canterbury/fields.c | 11150 | libdeflate | 3.76 | 11.36 | 3.02 | 1.88 |
| canterbury/fields.c | 11150 | Wuffs | 3.98 | 12.00 | 3.01 | 9.99 |
| canterbury/fields.c | 11150 | stdx | 3.22 | 10.58 | 3.29 | 9.33 |
| canterbury/grammar.lsp | 3721 | zlib | 7.81 | 26.74 | 3.42 | 2.48 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.96 | 17.48 | 2.93 | 15.70 |
| canterbury/grammar.lsp | 3721 | libdeflate | 7.33 | 21.16 | 2.89 | 1.13 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.46 | 20.33 | 3.15 | 4.69 |
| canterbury/grammar.lsp | 3721 | stdx | 5.54 | 20.05 | 3.62 | 7.34 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.94 | 12.22 | 3.10 | 48.08 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.85 | 6.97 | 2.45 | 12.95 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.76 | 6.01 | 2.18 | 9.37 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.20 | 8.73 | 2.73 | 14.95 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.84 | 4.99 | 2.71 | 17.74 |
| canterbury/lcet10.txt | 426754 | zlib | 7.35 | 14.58 | 1.98 | 279.14 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 61.05 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.05 | 8.57 | 2.80 | 54.99 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.56 | 9.92 | 2.17 | 100.67 |
| canterbury/lcet10.txt | 426754 | stdx | 2.73 | 6.80 | 2.49 | 68.01 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.27 | 16.57 | 2.00 | 309.68 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.28 | 11.19 | 2.12 | 77.80 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.79 | 10.27 | 2.71 | 77.29 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.15 | 11.61 | 2.26 | 98.95 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.27 | 8.06 | 2.47 | 86.67 |
| canterbury/ptt5 | 513216 | zlib | 4.40 | 7.84 | 1.78 | 99.70 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.22 | 4.40 | 1.98 | 46.97 |
| canterbury/ptt5 | 513216 | libdeflate | 1.46 | 3.09 | 2.11 | 37.77 |
| canterbury/ptt5 | 513216 | Wuffs | 2.19 | 4.05 | 1.85 | 58.93 |
| canterbury/ptt5 | 513216 | stdx | 1.56 | 2.82 | 1.81 | 50.84 |
| canterbury/sum | 38240 | zlib | 7.37 | 15.51 | 2.11 | 213.56 |
| canterbury/sum | 38240 | zlib-ng | 4.68 | 10.01 | 2.14 | 59.41 |
| canterbury/sum | 38240 | libdeflate | 3.53 | 9.22 | 2.61 | 29.43 |
| canterbury/sum | 38240 | Wuffs | 5.06 | 11.56 | 2.28 | 80.01 |
| canterbury/sum | 38240 | stdx | 3.49 | 9.35 | 2.68 | 36.12 |
| canterbury/xargs.1 | 4227 | zlib | 8.09 | 26.94 | 3.33 | 5.96 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.55 | 17.97 | 2.74 | 21.13 |
| canterbury/xargs.1 | 4227 | libdeflate | 7.34 | 21.29 | 2.90 | 0.91 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.90 | 20.90 | 3.03 | 8.70 |
| canterbury/xargs.1 | 4227 | stdx | 5.76 | 19.81 | 3.44 | 8.28 |
| canterbury-large/E.coli | 4638690 | zlib | 5.91 | 14.55 | 2.46 | 174.72 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.23 | 9.68 | 2.29 | 47.49 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.88 | 2.93 | 48.16 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.00 | 9.70 | 2.43 | 61.23 |
| canterbury-large/E.coli | 4638690 | stdx | 2.56 | 6.92 | 2.71 | 53.98 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.68 | 13.27 | 1.99 | 257.83 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.76 | 8.26 | 2.20 | 53.63 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.47 | 2.85 | 45.60 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.15 | 8.77 | 2.11 | 100.58 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.32 | 5.82 | 2.51 | 56.67 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.90 | 12.70 | 1.84 | 270.72 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.18 | 7.77 | 1.86 | 92.30 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.89 | 6.94 | 2.40 | 75.26 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.51 | 8.49 | 1.88 | 129.92 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.83 | 5.70 | 2.02 | 91.58 |
| http/html-1k | 1024 | zlib | 19.01 | 60.81 | 3.20 | 12.95 |
| http/html-1k | 1024 | zlib-ng | 12.07 | 37.31 | 3.09 | 30.73 |
| http/html-1k | 1024 | libdeflate | 20.67 | 56.23 | 2.72 | 10.03 |
| http/html-1k | 1024 | Wuffs | 15.14 | 47.56 | 3.14 | 19.80 |
| http/html-1k | 1024 | stdx | 14.12 | 53.30 | 3.78 | 29.99 |
| http/html-16k | 16384 | zlib | 5.04 | 14.77 | 2.93 | 59.49 |
| http/html-16k | 16384 | zlib-ng | 3.71 | 9.15 | 2.47 | 26.19 |
| http/html-16k | 16384 | libdeflate | 3.17 | 9.34 | 2.95 | 5.14 |
| http/html-16k | 16384 | Wuffs | 3.81 | 10.78 | 2.83 | 21.24 |
| http/html-16k | 16384 | stdx | 2.93 | 9.32 | 3.18 | 10.98 |
| http/html-1m | 1048576 | zlib | 4.62 | 9.53 | 2.06 | 170.94 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 60.59 |
| http/html-1m | 1048576 | libdeflate | 1.71 | 4.42 | 2.59 | 37.77 |
| http/html-1m | 1048576 | Wuffs | 2.96 | 5.45 | 1.84 | 90.95 |
| http/html-1m | 1048576 | stdx | 1.71 | 3.66 | 2.14 | 53.11 |
| http/json-1k | 1024 | zlib | 14.00 | 43.22 | 3.09 | 1.08 |
| http/json-1k | 1024 | zlib-ng | 6.43 | 19.02 | 2.96 | 2.15 |
| http/json-1k | 1024 | libdeflate | 17.85 | 48.89 | 2.74 | 2.08 |
| http/json-1k | 1024 | Wuffs | 9.96 | 31.55 | 3.17 | 10.04 |
| http/json-1k | 1024 | stdx | 9.67 | 37.90 | 3.92 | 11.09 |
| http/json-16k | 16384 | zlib | 2.61 | 9.28 | 3.55 | 1.28 |
| http/json-16k | 16384 | zlib-ng | 1.37 | 4.10 | 2.99 | 1.15 |
| http/json-16k | 16384 | libdeflate | 1.75 | 5.10 | 2.91 | 0.62 |
| http/json-16k | 16384 | Wuffs | 1.64 | 5.17 | 3.15 | 1.96 |
| http/json-16k | 16384 | stdx | 1.29 | 4.56 | 3.52 | 1.74 |
| http/json-1m | 1048576 | zlib | 3.24 | 8.27 | 2.56 | 81.55 |
| http/json-1m | 1048576 | zlib-ng | 1.97 | 3.91 | 1.99 | 40.20 |
| http/json-1m | 1048576 | libdeflate | 1.39 | 3.36 | 2.42 | 32.32 |
| http/json-1m | 1048576 | Wuffs | 2.04 | 4.32 | 2.11 | 44.31 |
| http/json-1m | 1048576 | stdx | 1.39 | 2.82 | 2.03 | 40.93 |
| http/js-1k | 1024 | zlib | 17.53 | 55.96 | 3.19 | 4.13 |
| http/js-1k | 1024 | zlib-ng | 10.60 | 32.00 | 3.02 | 28.65 |
| http/js-1k | 1024 | libdeflate | 19.74 | 54.46 | 2.76 | 5.32 |
| http/js-1k | 1024 | Wuffs | 13.93 | 44.28 | 3.18 | 18.13 |
| http/js-1k | 1024 | stdx | 13.23 | 50.75 | 3.84 | 27.78 |
| http/js-16k | 16384 | zlib | 3.83 | 12.66 | 3.31 | 18.58 |
| http/js-16k | 16384 | zlib-ng | 2.75 | 7.25 | 2.64 | 10.67 |
| http/js-16k | 16384 | libdeflate | 2.60 | 7.81 | 3.00 | 1.02 |
| http/js-16k | 16384 | Wuffs | 2.94 | 8.65 | 2.95 | 9.33 |
| http/js-16k | 16384 | stdx | 2.28 | 7.47 | 3.27 | 3.66 |
| http/js-1m | 1048576 | zlib | 5.12 | 10.28 | 2.01 | 194.72 |
| http/js-1m | 1048576 | zlib-ng | 2.87 | 5.66 | 1.97 | 60.53 |
| http/js-1m | 1048576 | libdeflate | 1.93 | 5.01 | 2.59 | 42.19 |
| http/js-1m | 1048576 | Wuffs | 3.25 | 6.14 | 1.89 | 96.31 |
| http/js-1m | 1048576 | stdx | 1.87 | 4.10 | 2.19 | 56.16 |
| http/css-1k | 1024 | zlib | 17.98 | 56.50 | 3.14 | 6.01 |
| http/css-1k | 1024 | zlib-ng | 10.74 | 32.04 | 2.98 | 12.31 |
| http/css-1k | 1024 | libdeflate | 19.91 | 54.79 | 2.75 | 2.27 |
| http/css-1k | 1024 | Wuffs | 14.42 | 44.94 | 3.12 | 21.55 |
| http/css-1k | 1024 | stdx | 12.86 | 47.79 | 3.72 | 19.81 |
| http/css-16k | 16384 | zlib | 4.91 | 14.39 | 2.93 | 60.39 |
| http/css-16k | 16384 | zlib-ng | 3.53 | 8.66 | 2.45 | 24.03 |
| http/css-16k | 16384 | libdeflate | 3.06 | 9.10 | 2.98 | 3.66 |
| http/css-16k | 16384 | Wuffs | 3.72 | 10.43 | 2.80 | 24.16 |
| http/css-16k | 16384 | stdx | 2.79 | 8.58 | 3.08 | 12.22 |
| http/css-1m | 1048576 | zlib | 3.36 | 8.02 | 2.39 | 105.55 |
| http/css-1m | 1048576 | zlib-ng | 1.71 | 3.75 | 2.18 | 31.15 |
| http/css-1m | 1048576 | libdeflate | 1.05 | 3.21 | 3.05 | 10.49 |
| http/css-1m | 1048576 | Wuffs | 1.92 | 4.10 | 2.14 | 46.19 |
| http/css-1m | 1048576 | stdx | 1.07 | 2.69 | 2.52 | 21.88 |
| shuffled/dickens-1m | 1048576 | zlib | 12.60 | 22.44 | 1.78 | 373.44 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.69 | 16.72 | 1.72 | 199.19 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.05 | 15.00 | 2.13 | 194.05 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.55 | 19.12 | 2.00 | 206.06 |
| shuffled/dickens-1m | 1048576 | stdx | 7.34 | 12.70 | 1.73 | 209.97 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.35 | 14.05 | 4.19 | 3.49 |
| silesia/dickens | 10192446 | stdx | 3.47 | 12.47 | 3.60 | 3.80 |
| silesia/mozilla | 51220480 | libzstd | 2.81 | 9.66 | 3.44 | 30.63 |
| silesia/mozilla | 51220480 | stdx | 2.79 | 9.67 | 3.47 | 15.98 |
| silesia/mr | 9970564 | libzstd | 2.95 | 11.99 | 4.06 | 6.30 |
| silesia/mr | 9970564 | stdx | 2.99 | 10.82 | 3.62 | 5.14 |
| silesia/nci | 33553445 | libzstd | 1.56 | 4.86 | 3.11 | 24.05 |
| silesia/nci | 33553445 | stdx | 1.53 | 4.63 | 3.03 | 13.68 |
| silesia/ooffice | 6152192 | libzstd | 3.38 | 12.17 | 3.60 | 31.63 |
| silesia/ooffice | 6152192 | stdx | 3.30 | 12.40 | 3.76 | 12.36 |
| silesia/osdb | 10085684 | libzstd | 2.29 | 8.45 | 3.68 | 15.40 |
| silesia/osdb | 10085684 | stdx | 2.36 | 8.10 | 3.43 | 15.70 |
| silesia/reymont | 6627202 | libzstd | 3.05 | 11.62 | 3.80 | 11.66 |
| silesia/reymont | 6627202 | stdx | 3.17 | 10.36 | 3.27 | 12.84 |
| silesia/samba | 21606400 | libzstd | 2.01 | 7.41 | 3.68 | 18.67 |
| silesia/samba | 21606400 | stdx | 2.05 | 6.83 | 3.34 | 17.69 |
| silesia/sao | 7251944 | libzstd | 3.81 | 12.78 | 3.35 | 26.81 |
| silesia/sao | 7251944 | stdx | 3.44 | 12.57 | 3.65 | 6.64 |
| silesia/webster | 41458703 | libzstd | 3.05 | 11.24 | 3.69 | 16.27 |
| silesia/webster | 41458703 | stdx | 3.15 | 10.05 | 3.19 | 17.49 |
| silesia/x-ray | 8474240 | libzstd | 3.94 | 14.94 | 3.79 | 18.93 |
| silesia/x-ray | 8474240 | stdx | 3.51 | 13.23 | 3.77 | 8.32 |
| silesia/xml | 5345280 | libzstd | 1.53 | 5.57 | 3.64 | 23.02 |
| silesia/xml | 5345280 | stdx | 1.50 | 5.16 | 3.44 | 17.11 |
| canterbury/alice29.txt | 152089 | libzstd | 3.35 | 16.21 | 4.83 | 4.21 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.49 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.00 | 14.27 | 4.76 | 3.27 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.30 | 0.26 |
| canterbury/cp.html | 24603 | libzstd | 2.72 | 10.82 | 3.98 | 9.76 |
| canterbury/cp.html | 24603 | stdx | 2.55 | 10.41 | 4.09 | 0.21 |
| canterbury/fields.c | 11150 | libzstd | 3.20 | 13.80 | 4.31 | 10.46 |
| canterbury/fields.c | 11150 | stdx | 3.00 | 12.71 | 4.24 | 0.10 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.46 | 17.48 | 3.92 | 7.02 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.45 | 3.99 | 0.19 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.49 | 11.24 | 4.52 | 7.68 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.66 | 11.32 | 4.26 | 0.94 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.73 | 12.89 | 4.72 | 5.31 |
| canterbury/lcet10.txt | 426754 | stdx | 2.73 | 11.52 | 4.22 | 4.38 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.15 | 15.16 | 4.82 | 1.58 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.28 | 0.91 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.51 | 3.11 | 24.63 |
| canterbury/ptt5 | 513216 | stdx | 1.33 | 4.46 | 3.36 | 13.20 |
| canterbury/sum | 38240 | libzstd | 2.69 | 10.57 | 3.93 | 11.61 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.73 | 4.09 | 0.33 |
| canterbury/xargs.1 | 4227 | libzstd | 4.45 | 17.89 | 4.02 | 10.46 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 17.12 | 4.05 | 0.18 |
| canterbury-large/E.coli | 4638690 | libzstd | 2.97 | 13.64 | 4.58 | 2.20 |
| canterbury-large/E.coli | 4638690 | stdx | 3.05 | 12.04 | 3.95 | 2.98 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.90 | 12.01 | 4.15 | 8.47 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.99 | 10.64 | 3.56 | 9.50 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.49 | 9.61 | 3.85 | 19.91 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.56 | 8.64 | 3.38 | 21.59 |
| http/html-1k | 1024 | libzstd | 6.17 | 21.07 | 3.42 | 1.17 |
| http/html-1k | 1024 | stdx | 5.66 | 20.23 | 3.57 | 0.57 |
| http/html-16k | 16384 | libzstd | 2.98 | 11.93 | 4.01 | 14.84 |
| http/html-16k | 16384 | stdx | 2.81 | 11.73 | 4.18 | 0.20 |
| http/html-1m | 1048576 | libzstd | 1.99 | 7.88 | 3.96 | 24.10 |
| http/html-1m | 1048576 | stdx | 1.98 | 7.12 | 3.59 | 24.27 |
| http/json-1k | 1024 | libzstd | 6.55 | 18.26 | 2.79 | 4.18 |
| http/json-1k | 1024 | stdx | 5.72 | 17.01 | 2.98 | 0.46 |
| http/json-16k | 16384 | libzstd | 1.33 | 5.44 | 4.10 | 3.12 |
| http/json-16k | 16384 | stdx | 1.33 | 5.35 | 4.01 | 1.83 |
| http/json-1m | 1048576 | libzstd | 1.73 | 6.06 | 3.50 | 28.26 |
| http/json-1m | 1048576 | stdx | 1.61 | 5.90 | 3.66 | 14.25 |
| http/js-1k | 1024 | libzstd | 6.04 | 21.04 | 3.49 | 2.11 |
| http/js-1k | 1024 | stdx | 5.75 | 20.50 | 3.56 | 0.47 |
| http/js-16k | 16384 | libzstd | 2.20 | 9.18 | 4.17 | 5.65 |
| http/js-16k | 16384 | stdx | 2.15 | 8.90 | 4.14 | 0.21 |
| http/js-1m | 1048576 | libzstd | 2.01 | 8.19 | 4.07 | 20.32 |
| http/js-1m | 1048576 | stdx | 2.03 | 7.47 | 3.68 | 20.27 |
| http/css-1k | 1024 | libzstd | 8.25 | 29.01 | 3.51 | 3.26 |
| http/css-1k | 1024 | stdx | 7.72 | 28.40 | 3.68 | 0.56 |
| http/css-16k | 16384 | libzstd | 2.99 | 12.36 | 4.13 | 10.56 |
| http/css-16k | 16384 | stdx | 2.89 | 12.07 | 4.18 | 0.21 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.58 | 3.89 | 5.53 |
| http/css-1m | 1048576 | stdx | 0.70 | 2.49 | 3.55 | 4.59 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.81 | 9.41 | 3.35 | 28.84 |
| shuffled/dickens-1m | 1048576 | stdx | 2.71 | 9.19 | 3.39 | 12.54 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.43 | 17.05 | 2.29 | 101.35 |
| silesia/dickens | 1048576 | stdx | 9.77 | 32.50 | 3.33 | 53.34 |
| silesia/mozilla | 1048576 | Google | 13.60 | 27.77 | 2.04 | 46.49 |
| silesia/mozilla | 1048576 | stdx | 11.08 | 24.57 | 2.22 | 46.02 |
| silesia/mr | 1048576 | Google | 8.88 | 20.25 | 2.28 | 101.90 |
| silesia/mr | 1048576 | stdx | 10.31 | 33.04 | 3.20 | 90.28 |
| silesia/nci | 1048576 | Google | 2.54 | 5.69 | 2.24 | 51.10 |
| silesia/nci | 1048576 | stdx | 3.27 | 9.63 | 2.94 | 50.96 |
| silesia/ooffice | 1048576 | Google | 14.14 | 29.28 | 2.07 | 287.25 |
| silesia/ooffice | 1048576 | stdx | 18.13 | 51.26 | 2.83 | 275.18 |
| silesia/osdb | 1048576 | Google | 8.18 | 17.39 | 2.13 | 96.58 |
| silesia/osdb | 1048576 | stdx | 8.51 | 25.15 | 2.95 | 74.61 |
| silesia/reymont | 1048576 | Google | 5.38 | 12.73 | 2.37 | 82.31 |
| silesia/reymont | 1048576 | stdx | 7.48 | 25.16 | 3.36 | 47.13 |
| silesia/samba | 1048576 | Google | 7.56 | 16.22 | 2.15 | 96.47 |
| silesia/samba | 1048576 | stdx | 8.46 | 24.05 | 2.84 | 66.59 |
| silesia/sao | 1048576 | Google | 16.78 | 36.97 | 2.20 | 161.42 |
| silesia/sao | 1048576 | stdx | 17.58 | 53.62 | 3.05 | 130.89 |
| silesia/webster | 1048576 | Google | 6.50 | 14.07 | 2.16 | 115.54 |
| silesia/webster | 1048576 | stdx | 8.14 | 25.86 | 3.18 | 66.71 |
| silesia/x-ray | 1048576 | Google | 19.19 | 38.46 | 2.00 | 233.69 |
| silesia/x-ray | 1048576 | stdx | 22.54 | 67.41 | 2.99 | 223.45 |
| silesia/xml | 1048576 | Google | 3.45 | 7.65 | 2.22 | 65.65 |
| silesia/xml | 1048576 | stdx | 4.50 | 14.24 | 3.16 | 47.11 |
| canterbury/alice29.txt | 152089 | Google | 8.87 | 20.69 | 2.33 | 137.00 |
| canterbury/alice29.txt | 152089 | stdx | 11.64 | 39.04 | 3.35 | 81.39 |
| canterbury/asyoulik.txt | 125179 | Google | 10.39 | 23.85 | 2.29 | 171.63 |
| canterbury/asyoulik.txt | 125179 | stdx | 13.31 | 43.92 | 3.30 | 107.93 |
| canterbury/cp.html | 24603 | Google | 9.12 | 22.33 | 2.45 | 109.92 |
| canterbury/cp.html | 24603 | stdx | 12.98 | 40.80 | 3.14 | 107.02 |
| canterbury/fields.c | 11150 | Google | 7.16 | 21.59 | 3.02 | 23.41 |
| canterbury/fields.c | 11150 | stdx | 13.19 | 44.07 | 3.34 | 70.32 |
| canterbury/grammar.lsp | 3721 | Google | 10.11 | 31.24 | 3.09 | 4.75 |
| canterbury/grammar.lsp | 3721 | stdx | 19.85 | 66.32 | 3.34 | 71.89 |
| canterbury/kennedy.xls | 1029744 | Google | 5.47 | 17.03 | 3.11 | 37.06 |
| canterbury/kennedy.xls | 1029744 | stdx | 8.81 | 32.31 | 3.67 | 58.70 |
| canterbury/lcet10.txt | 426754 | Google | 7.71 | 17.42 | 2.26 | 131.18 |
| canterbury/lcet10.txt | 426754 | stdx | 9.78 | 32.69 | 3.34 | 64.05 |
| canterbury/plrabn12.txt | 481861 | Google | 9.05 | 20.95 | 2.31 | 134.73 |
| canterbury/plrabn12.txt | 481861 | stdx | 11.75 | 39.21 | 3.34 | 86.30 |
| canterbury/ptt5 | 513216 | Google | 4.28 | 10.37 | 2.42 | 61.81 |
| canterbury/ptt5 | 513216 | stdx | 3.92 | 11.53 | 2.95 | 59.61 |
| canterbury/sum | 38240 | Google | 10.83 | 26.51 | 2.45 | 154.22 |
| canterbury/sum | 38240 | stdx | 16.83 | 52.18 | 3.10 | 175.81 |
| canterbury/xargs.1 | 4227 | Google | 11.30 | 35.70 | 3.16 | 14.28 |
| canterbury/xargs.1 | 4227 | stdx | 22.60 | 76.16 | 3.37 | 91.44 |
| canterbury-large/E.coli | 1048576 | Google | 7.47 | 19.45 | 2.60 | 1.35 |
| canterbury-large/E.coli | 1048576 | stdx | 7.70 | 15.39 | 2.00 | 5.85 |
| canterbury-large/bible.txt | 1048576 | Google | 5.30 | 12.39 | 2.34 | 81.93 |
| canterbury-large/bible.txt | 1048576 | stdx | 7.13 | 23.80 | 3.34 | 37.51 |
| canterbury-large/world192.txt | 1048576 | Google | 6.16 | 12.88 | 2.09 | 116.73 |
| canterbury-large/world192.txt | 1048576 | stdx | 7.82 | 23.23 | 2.97 | 74.40 |
| http/html-1k | 1024 | Google | 16.04 | 52.92 | 3.30 | 5.98 |
| http/html-1k | 1024 | stdx | 35.19 | 118.45 | 3.37 | 54.20 |
| http/html-16k | 16384 | Google | 6.41 | 18.63 | 2.91 | 39.94 |
| http/html-16k | 16384 | stdx | 11.37 | 37.89 | 3.33 | 73.61 |
| http/html-1m | 1048576 | Google | 4.02 | 8.99 | 2.23 | 83.56 |
| http/html-1m | 1048576 | stdx | 5.38 | 16.90 | 3.14 | 53.09 |
| http/json-1k | 1024 | Google | 11.91 | 38.51 | 3.24 | 5.30 |
| http/json-1k | 1024 | stdx | 30.02 | 99.28 | 3.31 | 30.88 |
| http/json-16k | 16384 | Google | 2.50 | 7.98 | 3.19 | 2.90 |
| http/json-16k | 16384 | stdx | 4.40 | 15.69 | 3.56 | 20.31 |
| http/json-1m | 1048576 | Google | 3.40 | 8.66 | 2.55 | 58.35 |
| http/json-1m | 1048576 | stdx | 5.00 | 16.09 | 3.22 | 63.12 |
| http/js-1k | 1024 | Google | 16.98 | 56.77 | 3.34 | 3.70 |
| http/js-1k | 1024 | stdx | 42.92 | 144.13 | 3.36 | 60.34 |
| http/js-16k | 16384 | Google | 4.88 | 14.91 | 3.06 | 20.14 |
| http/js-16k | 16384 | stdx | 8.64 | 29.21 | 3.38 | 49.50 |
| http/js-1m | 1048576 | Google | 4.34 | 9.61 | 2.21 | 83.74 |
| http/js-1m | 1048576 | stdx | 5.94 | 18.62 | 3.14 | 53.83 |
| http/css-1k | 1024 | Google | 17.66 | 56.90 | 3.22 | 3.68 |
| http/css-1k | 1024 | stdx | 36.79 | 123.80 | 3.37 | 50.60 |
| http/css-16k | 16384 | Google | 6.35 | 18.45 | 2.90 | 32.01 |
| http/css-16k | 16384 | stdx | 10.72 | 35.75 | 3.34 | 61.76 |
| http/css-1m | 1048576 | Google | 2.43 | 9.43 | 3.89 | 16.65 |
| http/css-1m | 1048576 | stdx | 1.50 | 5.02 | 3.34 | 12.62 |
| shuffled/dickens-1m | 1048576 | Google | 9.71 | 20.35 | 2.10 | 111.50 |
| shuffled/dickens-1m | 1048576 | stdx | 9.56 | 16.52 | 1.73 | 109.76 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 74.0 | 241.3 | 0.156 | 8.74 | 3.26 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 281.1 | 1153.4 | 0.858 | 33.21 | 4.10 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 31.2 | 109.0 | 0.099 | 3.68 | 3.49 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.8 | 107.1 | 0.295 | 3.28 | 3.86 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.3 | 378.5 | 0.406 | 11.26 | 3.97 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 78.2 | 257.8 | 0.115 | 11.51 | 3.29 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 257.2 | 917.2 | 1.157 | 37.86 | 3.57 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 31.4 | 108.7 | 0.134 | 4.62 | 3.46 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.1 | 106.7 | 0.050 | 4.14 | 3.79 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 100.6 | 365.4 | 0.353 | 14.81 | 3.63 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 626117.4 | 2692383.2 | 1345.381 | 3.63 | 4.30 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3850886.8 | 20639223.2 | 2976.588 | 22.32 | 5.36 |
| string: silesia/dickens | 1 | 172528 | simdjson | 337511.7 | 656791.2 | 638.680 | 1.96 | 1.95 |
| string: silesia/dickens | 1 | 172528 | yyjson | 232255.5 | 848188.2 | 2761.948 | 1.35 | 3.65 |
| string: silesia/dickens | 1 | 172528 | std.json | 1595606.5 | 4596185.2 | 43828.206 | 9.25 | 2.88 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 15501551.4 | 61212695.6 | 56777.929 | 13.02 | 3.95 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 31563313.8 | 148769650.6 | 158838.071 | 26.52 | 4.71 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4767463.5 | 7294566.6 | 518.000 | 4.01 | 1.53 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1748474.6 | 7470807.6 | 14663.286 | 1.47 | 4.27 |
| string: http/json-1m | 1 | 1190272 | std.json | 10141256.0 | 47254136.6 | 32504.000 | 8.52 | 4.66 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 10123780.9 | 31400561.8 | 57740.125 | 5.38 | 3.10 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 52175834.0 | 252608887.8 | 277437.625 | 27.71 | 4.84 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3810847.8 | 8269494.8 | 1959.750 | 2.02 | 2.17 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7102377.3 | 12512113.8 | 275282.750 | 3.77 | 1.76 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 18434366.6 | 63923762.8 | 231301.250 | 9.79 | 3.47 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 241149.6 | 689119.7 | 8.194 | 0.46 | 2.86 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 11067961.9 | 60818217.7 | 8.452 | 21.11 | 5.49 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 552685.1 | 1483247.7 | 4.194 | 1.05 | 2.68 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 541290.2 | 2261447.7 | 8.935 | 1.03 | 4.18 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3552794.9 | 12808414.7 | 75872.129 | 6.78 | 3.61 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 88.9 | 401.5 | 0.237 | 10.50 | 4.52 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 190.4 | 926.9 | 0.523 | 22.49 | 4.87 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 24.9 | 102.1 | 0.193 | 2.94 | 4.11 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.5 | 105.4 | 0.246 | 3.24 | 3.84 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 67.7 | 310.3 | 0.359 | 7.99 | 4.59 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 84.7 | 377.8 | 0.078 | 12.47 | 4.46 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 157.6 | 708.5 | 0.961 | 23.20 | 4.49 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 22.4 | 100.1 | 0.036 | 3.30 | 4.46 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.8 | 117.7 | 0.033 | 4.25 | 4.08 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.1 | 270.9 | 0.249 | 8.70 | 4.58 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 520720.0 | 2103547.2 | 1205.186 | 3.02 | 4.04 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 2585784.6 | 13927706.2 | 2949.423 | 14.99 | 5.39 |
| string: silesia/dickens | 1 | 172528 | simdjson | 212454.2 | 687839.2 | 1140.876 | 1.23 | 3.24 |
| string: silesia/dickens | 1 | 172528 | yyjson | 217136.1 | 848559.2 | 1541.082 | 1.26 | 3.91 |
| string: silesia/dickens | 1 | 172528 | std.json | 1342847.2 | 2890187.2 | 53181.371 | 7.78 | 2.15 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 9745076.8 | 42366117.6 | 16502.571 | 8.19 | 4.35 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 19886703.7 | 97363776.6 | 83813.857 | 16.71 | 4.90 |
| string: http/json-1m | 1 | 1190272 | simdjson | 3542060.2 | 10817573.6 | 4503.357 | 2.98 | 3.05 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2461086.3 | 11226214.6 | 9669.500 | 2.07 | 4.56 |
| string: http/json-1m | 1 | 1190272 | std.json | 8641014.3 | 42694254.6 | 15414.071 | 7.26 | 4.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 10209570.8 | 29999973.8 | 57544.625 | 5.42 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 35565943.0 | 171340029.8 | 262228.625 | 18.89 | 4.82 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2652162.5 | 7334579.8 | 10311.000 | 1.41 | 2.77 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 11859611.9 | 26334410.8 | 427082.125 | 6.30 | 2.22 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20538724.9 | 57035436.8 | 562191.250 | 10.91 | 2.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113685.5 | 393739.7 | 2.548 | 0.22 | 3.46 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 636060.4 | 3146407.7 | 6.194 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1212876.5 | 3932432.7 | 5.258 | 2.31 | 3.24 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1638016.3 | 5898886.7 | 5.710 | 3.12 | 3.60 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3657411.8 | 13174372.7 | 64939.419 | 6.98 | 3.60 |
