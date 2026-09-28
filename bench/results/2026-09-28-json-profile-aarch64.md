# bench-profile

| Field | Value |
|---|---|
| Commit | f6f3e1f |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260920.129.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/36472497642 |
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
| silesia/dickens | 10192446 | zlib | 7.91 | 15.78 | 1.99 | 299.36 |
| silesia/dickens | 10192446 | zlib-ng | 4.89 | 10.50 | 2.14 | 68.40 |
| silesia/dickens | 10192446 | libdeflate | 3.46 | 9.57 | 2.77 | 66.28 |
| silesia/dickens | 10192446 | Wuffs | 4.93 | 10.91 | 2.22 | 97.35 |
| silesia/dickens | 10192446 | stdx | 4.98 | 17.08 | 3.43 | 68.64 |
| silesia/mozilla | 51220480 | zlib | 7.74 | 14.13 | 1.83 | 242.81 |
| silesia/mozilla | 51220480 | zlib-ng | 4.97 | 9.03 | 1.82 | 85.32 |
| silesia/mozilla | 51220480 | libdeflate | 3.47 | 7.64 | 2.20 | 71.02 |
| silesia/mozilla | 51220480 | Wuffs | 5.77 | 10.93 | 1.89 | 132.89 |
| silesia/mozilla | 51220480 | stdx | 5.28 | 15.26 | 2.89 | 85.28 |
| silesia/mr | 9970564 | zlib | 7.65 | 15.27 | 2.00 | 198.92 |
| silesia/mr | 9970564 | zlib-ng | 4.92 | 10.29 | 2.09 | 68.07 |
| silesia/mr | 9970564 | libdeflate | 3.36 | 8.59 | 2.55 | 61.35 |
| silesia/mr | 9970564 | Wuffs | 5.30 | 11.01 | 2.08 | 99.42 |
| silesia/mr | 9970564 | stdx | 4.95 | 17.44 | 3.52 | 71.09 |
| silesia/nci | 33553445 | zlib | 2.87 | 7.25 | 2.52 | 78.35 |
| silesia/nci | 33553445 | zlib-ng | 1.57 | 3.13 | 1.99 | 33.92 |
| silesia/nci | 33553445 | libdeflate | 1.10 | 2.66 | 2.42 | 27.65 |
| silesia/nci | 33553445 | Wuffs | 1.70 | 3.40 | 2.00 | 42.55 |
| silesia/nci | 33553445 | stdx | 1.67 | 4.88 | 2.92 | 33.08 |
| silesia/ooffice | 6152192 | zlib | 10.96 | 17.83 | 1.63 | 400.84 |
| silesia/ooffice | 6152192 | zlib-ng | 6.91 | 12.05 | 1.75 | 140.86 |
| silesia/ooffice | 6152192 | libdeflate | 4.92 | 10.47 | 2.13 | 125.06 |
| silesia/ooffice | 6152192 | Wuffs | 8.19 | 14.59 | 1.78 | 219.81 |
| silesia/ooffice | 6152192 | stdx | 7.62 | 21.04 | 2.76 | 149.06 |
| silesia/osdb | 10085684 | zlib | 6.78 | 13.54 | 2.00 | 173.05 |
| silesia/osdb | 10085684 | zlib-ng | 4.29 | 8.38 | 1.95 | 53.18 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.92 | 2.43 | 29.72 |
| silesia/osdb | 10085684 | Wuffs | 5.12 | 10.65 | 2.08 | 76.14 |
| silesia/osdb | 10085684 | stdx | 3.94 | 12.78 | 3.25 | 36.18 |
| silesia/reymont | 6627202 | zlib | 6.60 | 12.73 | 1.93 | 253.57 |
| silesia/reymont | 6627202 | zlib-ng | 3.71 | 7.72 | 2.08 | 59.74 |
| silesia/reymont | 6627202 | libdeflate | 2.62 | 6.92 | 2.64 | 51.12 |
| silesia/reymont | 6627202 | Wuffs | 4.28 | 8.45 | 1.98 | 113.31 |
| silesia/reymont | 6627202 | stdx | 3.81 | 12.48 | 3.28 | 56.46 |
| silesia/samba | 21606400 | zlib | 5.44 | 11.09 | 2.04 | 169.76 |
| silesia/samba | 21606400 | zlib-ng | 3.37 | 6.52 | 1.93 | 56.05 |
| silesia/samba | 21606400 | libdeflate | 2.31 | 5.59 | 2.42 | 42.80 |
| silesia/samba | 21606400 | Wuffs | 3.68 | 7.39 | 2.01 | 81.15 |
| silesia/samba | 21606400 | stdx | 3.31 | 10.25 | 3.10 | 48.33 |
| silesia/sao | 7251944 | zlib | 9.91 | 20.36 | 2.06 | 198.93 |
| silesia/sao | 7251944 | zlib-ng | 7.84 | 14.83 | 1.89 | 79.63 |
| silesia/sao | 7251944 | libdeflate | 5.74 | 12.75 | 2.22 | 79.17 |
| silesia/sao | 7251944 | Wuffs | 8.25 | 18.34 | 2.22 | 86.16 |
| silesia/sao | 7251944 | stdx | 8.06 | 24.21 | 3.00 | 90.93 |
| silesia/webster | 41458703 | zlib | 6.97 | 12.99 | 1.86 | 273.61 |
| silesia/webster | 41458703 | zlib-ng | 4.24 | 8.04 | 1.90 | 85.04 |
| silesia/webster | 41458703 | libdeflate | 2.90 | 7.17 | 2.47 | 68.26 |
| silesia/webster | 41458703 | Wuffs | 4.55 | 8.68 | 1.91 | 123.64 |
| silesia/webster | 41458703 | stdx | 4.35 | 13.00 | 2.99 | 74.00 |
| silesia/x-ray | 8474240 | zlib | 12.17 | 23.83 | 1.96 | 324.87 |
| silesia/x-ray | 8474240 | zlib-ng | 8.98 | 17.39 | 1.94 | 124.05 |
| silesia/x-ray | 8474240 | libdeflate | 6.53 | 15.27 | 2.34 | 124.25 |
| silesia/x-ray | 8474240 | Wuffs | 10.21 | 20.58 | 2.01 | 190.78 |
| silesia/x-ray | 8474240 | stdx | 9.66 | 31.07 | 3.22 | 148.63 |
| silesia/xml | 5345280 | zlib | 3.59 | 8.21 | 2.28 | 115.56 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.89 | 1.96 | 42.53 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.34 | 2.46 | 31.37 |
| silesia/xml | 5345280 | Wuffs | 2.21 | 4.16 | 1.88 | 61.01 |
| silesia/xml | 5345280 | stdx | 2.03 | 6.04 | 2.98 | 37.97 |
| canterbury/alice29.txt | 152089 | zlib | 7.59 | 15.22 | 2.00 | 283.61 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.53 | 9.90 | 2.19 | 59.99 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.27 | 9.19 | 2.81 | 56.30 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.76 | 10.44 | 2.19 | 98.85 |
| canterbury/alice29.txt | 152089 | stdx | 4.58 | 16.08 | 3.51 | 58.42 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.14 | 16.28 | 2.00 | 302.20 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.10 | 10.86 | 2.13 | 72.73 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.71 | 10.09 | 2.72 | 70.15 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.16 | 11.43 | 2.22 | 100.84 |
| canterbury/asyoulik.txt | 125179 | stdx | 5.20 | 17.90 | 3.44 | 72.95 |
| canterbury/cp.html | 24603 | zlib | 6.57 | 15.04 | 2.29 | 160.23 |
| canterbury/cp.html | 24603 | zlib-ng | 4.26 | 9.49 | 2.23 | 42.67 |
| canterbury/cp.html | 24603 | libdeflate | 3.26 | 9.33 | 2.86 | 12.78 |
| canterbury/cp.html | 24603 | Wuffs | 4.73 | 11.09 | 2.35 | 68.50 |
| canterbury/cp.html | 24603 | stdx | 4.09 | 15.61 | 3.81 | 28.37 |
| canterbury/fields.c | 11150 | zlib | 5.05 | 16.50 | 3.27 | 29.69 |
| canterbury/fields.c | 11150 | zlib-ng | 3.91 | 10.19 | 2.61 | 15.60 |
| canterbury/fields.c | 11150 | libdeflate | 3.84 | 11.36 | 2.96 | 1.57 |
| canterbury/fields.c | 11150 | Wuffs | 4.05 | 12.00 | 2.96 | 13.57 |
| canterbury/fields.c | 11150 | stdx | 3.88 | 16.37 | 4.23 | 7.56 |
| canterbury/grammar.lsp | 3721 | zlib | 7.87 | 26.75 | 3.40 | 4.82 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.87 | 17.48 | 2.98 | 9.10 |
| canterbury/grammar.lsp | 3721 | libdeflate | 7.49 | 21.16 | 2.82 | 1.72 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.51 | 20.33 | 3.13 | 6.18 |
| canterbury/grammar.lsp | 3721 | stdx | 5.96 | 25.41 | 4.26 | 3.40 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.94 | 12.22 | 3.10 | 47.31 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.58 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.76 | 6.01 | 2.18 | 9.12 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.20 | 8.73 | 2.73 | 14.71 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.08 | 12.95 | 4.21 | 16.00 |
| canterbury/lcet10.txt | 426754 | zlib | 7.34 | 14.58 | 1.99 | 278.54 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.18 | 60.17 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.06 | 8.57 | 2.80 | 55.81 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.61 | 9.92 | 2.15 | 101.23 |
| canterbury/lcet10.txt | 426754 | stdx | 4.33 | 15.09 | 3.48 | 58.32 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.27 | 16.57 | 2.00 | 310.13 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.28 | 11.19 | 2.12 | 77.00 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.80 | 10.27 | 2.70 | 77.78 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.19 | 11.61 | 2.24 | 98.62 |
| canterbury/plrabn12.txt | 481861 | stdx | 5.46 | 18.52 | 3.39 | 80.82 |
| canterbury/ptt5 | 513216 | zlib | 4.41 | 7.83 | 1.78 | 100.28 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.24 | 4.40 | 1.96 | 46.56 |
| canterbury/ptt5 | 513216 | libdeflate | 1.46 | 3.09 | 2.11 | 37.61 |
| canterbury/ptt5 | 513216 | Wuffs | 2.21 | 4.05 | 1.83 | 58.73 |
| canterbury/ptt5 | 513216 | stdx | 2.11 | 5.86 | 2.77 | 46.46 |
| canterbury/sum | 38240 | zlib | 7.37 | 15.51 | 2.10 | 213.07 |
| canterbury/sum | 38240 | zlib-ng | 4.69 | 10.01 | 2.14 | 59.83 |
| canterbury/sum | 38240 | libdeflate | 3.53 | 9.22 | 2.61 | 27.81 |
| canterbury/sum | 38240 | Wuffs | 5.17 | 11.56 | 2.24 | 82.11 |
| canterbury/sum | 38240 | stdx | 4.94 | 17.57 | 3.56 | 56.05 |
| canterbury/xargs.1 | 4227 | zlib | 8.10 | 26.94 | 3.33 | 6.80 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.47 | 17.97 | 2.78 | 14.90 |
| canterbury/xargs.1 | 4227 | libdeflate | 7.46 | 21.29 | 2.85 | 0.57 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.94 | 20.90 | 3.01 | 10.69 |
| canterbury/xargs.1 | 4227 | stdx | 6.45 | 27.28 | 4.23 | 5.64 |
| canterbury-large/E.coli | 4638690 | zlib | 5.91 | 14.55 | 2.46 | 174.46 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.25 | 9.68 | 2.28 | 48.13 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.88 | 2.93 | 48.40 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.04 | 9.70 | 2.40 | 61.62 |
| canterbury-large/E.coli | 4638690 | stdx | 4.35 | 15.92 | 3.66 | 50.91 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.71 | 13.27 | 1.98 | 258.43 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.78 | 8.26 | 2.18 | 54.16 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.63 | 7.47 | 2.84 | 45.52 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.18 | 8.77 | 2.10 | 100.13 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.75 | 13.09 | 3.49 | 48.41 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.93 | 12.70 | 1.83 | 272.37 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.77 | 1.85 | 91.70 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.89 | 6.94 | 2.40 | 75.11 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.56 | 8.49 | 1.86 | 129.56 |
| canterbury-large/world192.txt | 2473400 | stdx | 4.27 | 12.60 | 2.95 | 81.73 |
| http/html-1k | 1024 | zlib | 18.99 | 60.81 | 3.20 | 9.30 |
| http/html-1k | 1024 | zlib-ng | 11.78 | 37.31 | 3.17 | 12.44 |
| http/html-1k | 1024 | libdeflate | 21.16 | 56.23 | 2.66 | 8.35 |
| http/html-1k | 1024 | Wuffs | 15.19 | 47.56 | 3.13 | 21.72 |
| http/html-1k | 1024 | stdx | 13.20 | 54.05 | 4.10 | 15.07 |
| http/html-16k | 16384 | zlib | 4.95 | 14.77 | 2.98 | 54.58 |
| http/html-16k | 16384 | zlib-ng | 3.61 | 9.15 | 2.54 | 18.32 |
| http/html-16k | 16384 | libdeflate | 3.17 | 9.34 | 2.95 | 2.07 |
| http/html-16k | 16384 | Wuffs | 3.82 | 10.78 | 2.82 | 21.06 |
| http/html-16k | 16384 | stdx | 3.57 | 14.85 | 4.15 | 12.24 |
| http/html-1m | 1048576 | zlib | 4.64 | 9.53 | 2.05 | 171.71 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 59.85 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.42 | 2.60 | 37.16 |
| http/html-1m | 1048576 | Wuffs | 2.98 | 5.45 | 1.83 | 90.46 |
| http/html-1m | 1048576 | stdx | 2.54 | 7.83 | 3.08 | 45.77 |
| http/json-1k | 1024 | zlib | 14.04 | 43.19 | 3.08 | 1.09 |
| http/json-1k | 1024 | zlib-ng | 6.42 | 19.00 | 2.96 | 0.09 |
| http/json-1k | 1024 | libdeflate | 18.30 | 48.86 | 2.67 | 1.54 |
| http/json-1k | 1024 | Wuffs | 9.88 | 31.52 | 3.19 | 7.94 |
| http/json-1k | 1024 | stdx | 9.21 | 37.60 | 4.08 | 9.25 |
| http/json-16k | 16384 | zlib | 2.62 | 9.28 | 3.54 | 1.27 |
| http/json-16k | 16384 | zlib-ng | 1.37 | 4.10 | 2.99 | 0.68 |
| http/json-16k | 16384 | libdeflate | 1.79 | 5.10 | 2.85 | 0.23 |
| http/json-16k | 16384 | Wuffs | 1.65 | 5.17 | 3.14 | 2.28 |
| http/json-16k | 16384 | stdx | 1.51 | 6.60 | 4.37 | 1.25 |
| http/json-1m | 1048576 | zlib | 3.24 | 8.27 | 2.55 | 81.72 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.03 | 37.06 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.36 | 2.43 | 31.92 |
| http/json-1m | 1048576 | Wuffs | 2.05 | 4.32 | 2.10 | 44.24 |
| http/json-1m | 1048576 | stdx | 2.08 | 6.43 | 3.10 | 38.43 |
| http/js-1k | 1024 | zlib | 17.61 | 55.96 | 3.18 | 7.60 |
| http/js-1k | 1024 | zlib-ng | 10.26 | 32.00 | 3.12 | 4.30 |
| http/js-1k | 1024 | libdeflate | 20.23 | 54.47 | 2.69 | 2.08 |
| http/js-1k | 1024 | Wuffs | 13.87 | 44.29 | 3.19 | 18.65 |
| http/js-1k | 1024 | stdx | 12.46 | 51.82 | 4.16 | 18.65 |
| http/js-16k | 16384 | zlib | 3.84 | 12.66 | 3.30 | 18.96 |
| http/js-16k | 16384 | zlib-ng | 2.69 | 7.25 | 2.69 | 6.47 |
| http/js-16k | 16384 | libdeflate | 2.64 | 7.81 | 2.96 | 1.09 |
| http/js-16k | 16384 | Wuffs | 2.95 | 8.65 | 2.94 | 9.61 |
| http/js-16k | 16384 | stdx | 2.74 | 11.69 | 4.27 | 4.89 |
| http/js-1m | 1048576 | zlib | 5.15 | 10.28 | 2.00 | 195.17 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 59.70 |
| http/js-1m | 1048576 | libdeflate | 1.93 | 5.01 | 2.59 | 41.94 |
| http/js-1m | 1048576 | Wuffs | 3.29 | 6.14 | 1.87 | 96.31 |
| http/js-1m | 1048576 | stdx | 2.85 | 8.94 | 3.14 | 48.49 |
| http/css-1k | 1024 | zlib | 17.99 | 56.49 | 3.14 | 5.15 |
| http/css-1k | 1024 | zlib-ng | 10.69 | 32.03 | 3.00 | 5.98 |
| http/css-1k | 1024 | libdeflate | 20.48 | 54.79 | 2.68 | 2.91 |
| http/css-1k | 1024 | Wuffs | 14.41 | 44.95 | 3.12 | 21.23 |
| http/css-1k | 1024 | stdx | 12.35 | 50.62 | 4.10 | 9.64 |
| http/css-16k | 16384 | zlib | 4.84 | 14.39 | 2.97 | 56.01 |
| http/css-16k | 16384 | zlib-ng | 3.44 | 8.66 | 2.52 | 16.82 |
| http/css-16k | 16384 | libdeflate | 3.07 | 9.10 | 2.96 | 0.92 |
| http/css-16k | 16384 | Wuffs | 3.71 | 10.43 | 2.81 | 21.31 |
| http/css-16k | 16384 | stdx | 3.33 | 13.74 | 4.13 | 8.13 |
| http/css-1m | 1048576 | zlib | 3.36 | 8.02 | 2.39 | 105.67 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.21 | 28.98 |
| http/css-1m | 1048576 | libdeflate | 1.06 | 3.21 | 3.04 | 10.40 |
| http/css-1m | 1048576 | Wuffs | 1.92 | 4.10 | 2.14 | 45.17 |
| http/css-1m | 1048576 | stdx | 1.58 | 5.58 | 3.54 | 18.75 |
| shuffled/dickens-1m | 1048576 | zlib | 12.73 | 22.44 | 1.76 | 380.08 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.70 | 16.72 | 1.72 | 198.55 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.07 | 15.00 | 2.12 | 194.28 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.81 | 19.12 | 1.95 | 204.55 |
| shuffled/dickens-1m | 1048576 | stdx | 10.85 | 29.16 | 2.69 | 219.66 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.51 | 14.05 | 4.00 | 3.57 |
| silesia/dickens | 10192446 | stdx | 3.59 | 12.47 | 3.47 | 3.56 |
| silesia/mozilla | 51220480 | libzstd | 2.85 | 9.66 | 3.39 | 30.14 |
| silesia/mozilla | 51220480 | stdx | 2.79 | 9.67 | 3.46 | 15.78 |
| silesia/mr | 9970564 | libzstd | 3.00 | 11.99 | 4.00 | 6.22 |
| silesia/mr | 9970564 | stdx | 3.01 | 10.82 | 3.59 | 5.15 |
| silesia/nci | 33553445 | libzstd | 1.61 | 4.86 | 3.01 | 23.41 |
| silesia/nci | 33553445 | stdx | 1.61 | 4.63 | 2.88 | 13.50 |
| silesia/ooffice | 6152192 | libzstd | 3.41 | 12.17 | 3.57 | 31.25 |
| silesia/ooffice | 6152192 | stdx | 3.32 | 12.40 | 3.74 | 12.32 |
| silesia/osdb | 10085684 | libzstd | 2.35 | 8.45 | 3.59 | 15.28 |
| silesia/osdb | 10085684 | stdx | 2.38 | 8.10 | 3.41 | 15.60 |
| silesia/reymont | 6627202 | libzstd | 3.24 | 11.62 | 3.58 | 11.69 |
| silesia/reymont | 6627202 | stdx | 3.33 | 10.36 | 3.11 | 13.02 |
| silesia/samba | 21606400 | libzstd | 2.08 | 7.41 | 3.57 | 18.63 |
| silesia/samba | 21606400 | stdx | 2.12 | 6.83 | 3.23 | 17.74 |
| silesia/sao | 7251944 | libzstd | 3.82 | 12.78 | 3.34 | 26.42 |
| silesia/sao | 7251944 | stdx | 3.45 | 12.57 | 3.65 | 6.30 |
| silesia/webster | 41458703 | libzstd | 3.20 | 11.24 | 3.51 | 16.32 |
| silesia/webster | 41458703 | stdx | 3.32 | 10.05 | 3.03 | 17.68 |
| silesia/x-ray | 8474240 | libzstd | 3.94 | 14.94 | 3.80 | 19.08 |
| silesia/x-ray | 8474240 | stdx | 3.53 | 13.23 | 3.75 | 8.48 |
| silesia/xml | 5345280 | libzstd | 1.55 | 5.57 | 3.60 | 22.69 |
| silesia/xml | 5345280 | stdx | 1.51 | 5.16 | 3.42 | 16.98 |
| canterbury/alice29.txt | 152089 | libzstd | 3.36 | 16.21 | 4.82 | 4.25 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.57 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.01 | 14.27 | 4.74 | 3.31 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.31 | 0.26 |
| canterbury/cp.html | 24603 | libzstd | 2.71 | 10.82 | 3.99 | 9.03 |
| canterbury/cp.html | 24603 | stdx | 2.55 | 10.41 | 4.08 | 0.93 |
| canterbury/fields.c | 11150 | libzstd | 3.22 | 13.80 | 4.29 | 9.70 |
| canterbury/fields.c | 11150 | stdx | 3.02 | 12.71 | 4.21 | 0.95 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.45 | 17.48 | 3.93 | 6.46 |
| canterbury/grammar.lsp | 3721 | stdx | 4.13 | 16.45 | 3.98 | 0.94 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.50 | 11.24 | 4.49 | 7.69 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.24 | 1.00 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.74 | 12.89 | 4.71 | 5.29 |
| canterbury/lcet10.txt | 426754 | stdx | 2.71 | 11.52 | 4.25 | 3.23 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.17 | 15.16 | 4.78 | 1.59 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.27 | 0.98 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.51 | 3.10 | 24.24 |
| canterbury/ptt5 | 513216 | stdx | 1.32 | 4.46 | 3.38 | 13.15 |
| canterbury/sum | 38240 | libzstd | 2.69 | 10.57 | 3.92 | 11.46 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.73 | 4.10 | 0.60 |
| canterbury/xargs.1 | 4227 | libzstd | 4.49 | 17.89 | 3.98 | 10.75 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.12 | 4.03 | 1.28 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.05 | 13.64 | 4.48 | 2.21 |
| canterbury-large/E.coli | 4638690 | stdx | 3.08 | 12.04 | 3.91 | 2.88 |
| canterbury-large/bible.txt | 4047392 | libzstd | 3.02 | 12.01 | 3.97 | 8.59 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.08 | 10.64 | 3.45 | 9.41 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.57 | 9.61 | 3.74 | 19.74 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.62 | 8.64 | 3.29 | 21.49 |
| http/html-1k | 1024 | libzstd | 6.20 | 21.07 | 3.40 | 1.16 |
| http/html-1k | 1024 | stdx | 5.65 | 20.23 | 3.58 | 0.28 |
| http/html-16k | 16384 | libzstd | 2.97 | 11.93 | 4.02 | 13.94 |
| http/html-16k | 16384 | stdx | 2.81 | 11.73 | 4.17 | 1.02 |
| http/html-1m | 1048576 | libzstd | 2.01 | 7.88 | 3.91 | 24.30 |
| http/html-1m | 1048576 | stdx | 1.99 | 7.12 | 3.57 | 24.61 |
| http/json-1k | 1024 | libzstd | 6.56 | 18.26 | 2.78 | 4.46 |
| http/json-1k | 1024 | stdx | 5.69 | 17.01 | 2.99 | 0.29 |
| http/json-16k | 16384 | libzstd | 1.33 | 5.44 | 4.09 | 2.96 |
| http/json-16k | 16384 | stdx | 1.33 | 5.35 | 4.02 | 1.68 |
| http/json-1m | 1048576 | libzstd | 1.74 | 6.06 | 3.48 | 27.93 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.90 | 3.62 | 14.45 |
| http/js-1k | 1024 | libzstd | 6.09 | 21.04 | 3.45 | 1.44 |
| http/js-1k | 1024 | stdx | 5.74 | 20.49 | 3.57 | 0.32 |
| http/js-16k | 16384 | libzstd | 2.21 | 9.18 | 4.16 | 5.95 |
| http/js-16k | 16384 | stdx | 2.15 | 8.90 | 4.14 | 0.63 |
| http/js-1m | 1048576 | libzstd | 2.03 | 8.19 | 4.03 | 20.09 |
| http/js-1m | 1048576 | stdx | 2.05 | 7.47 | 3.65 | 20.56 |
| http/css-1k | 1024 | libzstd | 8.35 | 29.01 | 3.48 | 3.98 |
| http/css-1k | 1024 | stdx | 7.78 | 28.40 | 3.65 | 0.50 |
| http/css-16k | 16384 | libzstd | 3.01 | 12.36 | 4.11 | 10.63 |
| http/css-16k | 16384 | stdx | 2.90 | 12.07 | 4.16 | 1.16 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.58 | 3.89 | 5.54 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.54 | 4.24 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.83 | 9.41 | 3.33 | 28.63 |
| shuffled/dickens-1m | 1048576 | stdx | 2.73 | 9.19 | 3.37 | 12.75 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 169.8 | 601.5 | 0.313 | 20.05 | 3.54 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 278.4 | 1205.5 | 0.795 | 32.89 | 4.33 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 31.1 | 109.0 | 0.098 | 3.68 | 3.50 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.9 | 107.1 | 0.297 | 3.29 | 3.84 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 94.7 | 378.5 | 0.374 | 11.19 | 4.00 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 187.6 | 623.6 | 0.617 | 27.62 | 3.32 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 258.6 | 997.2 | 1.107 | 38.06 | 3.86 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 29.6 | 108.7 | 0.029 | 4.36 | 3.67 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.4 | 106.7 | 0.049 | 4.19 | 3.75 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 101.6 | 365.4 | 0.335 | 14.95 | 3.60 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 609068.2 | 2639809.2 | 1309.289 | 3.53 | 4.33 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3861232.8 | 20639273.2 | 2978.351 | 22.38 | 5.35 |
| string: silesia/dickens | 1 | 172528 | simdjson | 332223.4 | 656791.2 | 654.381 | 1.93 | 1.98 |
| string: silesia/dickens | 1 | 172528 | yyjson | 227841.3 | 848188.2 | 2448.289 | 1.32 | 3.72 |
| string: silesia/dickens | 1 | 172528 | std.json | 1545667.2 | 4596185.2 | 42196.464 | 8.96 | 2.97 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 14335923.0 | 61747971.6 | 56198.286 | 12.04 | 4.31 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 31695979.9 | 148769700.6 | 157874.929 | 26.63 | 4.69 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4718796.8 | 7294566.6 | 551.071 | 3.96 | 1.55 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1804072.0 | 7470807.6 | 15188.571 | 1.52 | 4.14 |
| string: http/json-1m | 1 | 1190272 | std.json | 9942339.3 | 47254136.6 | 30225.357 | 8.35 | 4.75 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 10124650.6 | 31295431.8 | 58711.875 | 5.38 | 3.09 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 51743990.9 | 252608937.8 | 283610.250 | 27.48 | 4.88 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3801624.9 | 8269494.8 | 2057.375 | 2.02 | 2.18 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7142699.3 | 12512113.8 | 277578.875 | 3.79 | 1.75 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17614432.1 | 63923762.8 | 267170.000 | 9.35 | 3.63 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 238602.1 | 689105.7 | 7.516 | 0.46 | 2.89 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 11094440.2 | 60818267.7 | 7.419 | 21.16 | 5.48 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 554220.7 | 1483247.7 | 6.065 | 1.06 | 2.68 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 544805.4 | 2261447.7 | 7.161 | 1.04 | 4.15 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3365608.6 | 12808414.7 | 60424.742 | 6.42 | 3.81 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 129.9 | 598.7 | 0.289 | 15.34 | 4.61 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 185.2 | 910.0 | 0.596 | 21.87 | 4.91 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 25.1 | 102.1 | 0.191 | 2.96 | 4.07 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.1 | 105.4 | 0.242 | 3.20 | 3.89 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 67.5 | 310.3 | 0.362 | 7.97 | 4.60 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 120.1 | 541.2 | 0.262 | 17.67 | 4.51 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 155.4 | 691.8 | 1.107 | 22.88 | 4.45 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 22.4 | 100.1 | 0.036 | 3.29 | 4.47 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.3 | 117.7 | 0.032 | 4.17 | 4.15 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 58.1 | 270.9 | 0.247 | 8.55 | 4.66 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 516365.1 | 2122698.2 | 1216.979 | 2.99 | 4.11 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 2586109.7 | 13921831.2 | 2950.485 | 14.99 | 5.38 |
| string: silesia/dickens | 1 | 172528 | simdjson | 212116.2 | 687839.2 | 1138.113 | 1.23 | 3.24 |
| string: silesia/dickens | 1 | 172528 | yyjson | 215915.1 | 848559.2 | 1602.794 | 1.25 | 3.93 |
| string: silesia/dickens | 1 | 172528 | std.json | 1346247.8 | 2890187.2 | 53276.371 | 7.80 | 2.15 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 10126980.7 | 43964480.6 | 25695.214 | 8.51 | 4.34 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 19949642.4 | 97222065.6 | 85345.286 | 16.76 | 4.87 |
| string: http/json-1m | 1 | 1190272 | simdjson | 3543513.4 | 10817573.6 | 4309.000 | 2.98 | 3.05 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2443522.5 | 11226214.6 | 9716.857 | 2.05 | 4.59 |
| string: http/json-1m | 1 | 1190272 | std.json | 8546962.8 | 42694254.6 | 15691.429 | 7.18 | 5.00 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 10283203.8 | 30629413.8 | 57006.000 | 5.46 | 2.98 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 35985859.3 | 171303990.8 | 261902.750 | 19.11 | 4.76 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2662932.8 | 7334579.8 | 10370.875 | 1.41 | 2.75 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 11927036.5 | 26334410.8 | 432224.750 | 6.33 | 2.21 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20478478.8 | 57035436.8 | 553673.000 | 10.88 | 2.79 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 114447.0 | 393926.7 | 4.129 | 0.22 | 3.44 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 635865.8 | 3146388.7 | 6.323 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1222980.8 | 3932432.7 | 4.645 | 2.33 | 3.22 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1636263.2 | 5898886.7 | 4.355 | 3.12 | 3.61 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3618946.9 | 13174372.7 | 62100.548 | 6.90 | 3.64 |
