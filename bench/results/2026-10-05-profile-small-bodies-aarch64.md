# bench-profile

| Field | Value |
|---|---|
| Commit | 5b2577b |
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
| silesia/dickens | 10192446 | zlib | 8.06 | 15.77 | 1.96 | 308.61 |
| silesia/dickens | 10192446 | zlib-ng | 4.88 | 10.50 | 2.15 | 67.46 |
| silesia/dickens | 10192446 | libdeflate | 3.42 | 9.56 | 2.80 | 66.87 |
| silesia/dickens | 10192446 | Wuffs | 4.92 | 10.85 | 2.20 | 97.30 |
| silesia/dickens | 10192446 | stdx | 2.92 | 7.16 | 2.45 | 76.12 |
| silesia/mozilla | 51220480 | zlib | 7.80 | 14.13 | 1.81 | 243.97 |
| silesia/mozilla | 51220480 | zlib-ng | 4.94 | 8.95 | 1.81 | 85.52 |
| silesia/mozilla | 51220480 | libdeflate | 3.51 | 7.63 | 2.18 | 71.14 |
| silesia/mozilla | 51220480 | Wuffs | 5.73 | 10.84 | 1.89 | 132.30 |
| silesia/mozilla | 51220480 | stdx | 3.65 | 6.29 | 1.72 | 89.11 |
| silesia/mr | 9970564 | zlib | 7.70 | 15.26 | 1.98 | 201.27 |
| silesia/mr | 9970564 | zlib-ng | 4.80 | 9.98 | 2.08 | 67.87 |
| silesia/mr | 9970564 | libdeflate | 3.34 | 8.58 | 2.57 | 61.13 |
| silesia/mr | 9970564 | Wuffs | 5.28 | 10.93 | 2.07 | 100.68 |
| silesia/mr | 9970564 | stdx | 3.07 | 6.71 | 2.18 | 69.89 |
| silesia/nci | 33553445 | zlib | 2.96 | 7.25 | 2.45 | 80.19 |
| silesia/nci | 33553445 | zlib-ng | 1.60 | 3.13 | 1.96 | 34.59 |
| silesia/nci | 33553445 | libdeflate | 1.12 | 2.66 | 2.37 | 27.91 |
| silesia/nci | 33553445 | Wuffs | 1.70 | 3.38 | 1.99 | 42.41 |
| silesia/nci | 33553445 | stdx | 1.19 | 2.21 | 1.86 | 38.06 |
| silesia/ooffice | 6152192 | zlib | 11.04 | 17.83 | 1.61 | 401.80 |
| silesia/ooffice | 6152192 | zlib-ng | 6.88 | 12.04 | 1.75 | 140.15 |
| silesia/ooffice | 6152192 | libdeflate | 4.97 | 10.45 | 2.10 | 125.17 |
| silesia/ooffice | 6152192 | Wuffs | 8.11 | 14.47 | 1.78 | 220.87 |
| silesia/ooffice | 6152192 | stdx | 5.06 | 8.56 | 1.69 | 150.23 |
| silesia/osdb | 10085684 | zlib | 6.87 | 13.54 | 1.97 | 175.14 |
| silesia/osdb | 10085684 | zlib-ng | 4.29 | 8.38 | 1.95 | 53.45 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.91 | 2.44 | 29.82 |
| silesia/osdb | 10085684 | Wuffs | 5.12 | 10.56 | 2.06 | 77.43 |
| silesia/osdb | 10085684 | stdx | 2.77 | 5.66 | 2.04 | 40.97 |
| silesia/reymont | 6627202 | zlib | 6.73 | 12.73 | 1.89 | 260.48 |
| silesia/reymont | 6627202 | zlib-ng | 3.71 | 7.72 | 2.08 | 59.31 |
| silesia/reymont | 6627202 | libdeflate | 2.58 | 6.91 | 2.68 | 51.21 |
| silesia/reymont | 6627202 | Wuffs | 4.28 | 8.40 | 1.96 | 112.74 |
| silesia/reymont | 6627202 | stdx | 2.30 | 5.11 | 2.23 | 64.79 |
| silesia/samba | 21606400 | zlib | 5.49 | 11.09 | 2.02 | 171.89 |
| silesia/samba | 21606400 | zlib-ng | 3.36 | 6.47 | 1.93 | 56.00 |
| silesia/samba | 21606400 | libdeflate | 2.31 | 5.58 | 2.42 | 43.03 |
| silesia/samba | 21606400 | Wuffs | 3.68 | 7.33 | 1.99 | 81.32 |
| silesia/samba | 21606400 | stdx | 2.28 | 4.47 | 1.96 | 56.28 |
| silesia/sao | 7251944 | zlib | 9.94 | 20.36 | 2.05 | 200.81 |
| silesia/sao | 7251944 | zlib-ng | 7.85 | 14.83 | 1.89 | 79.21 |
| silesia/sao | 7251944 | libdeflate | 5.75 | 12.73 | 2.21 | 79.21 |
| silesia/sao | 7251944 | Wuffs | 8.15 | 18.14 | 2.23 | 85.93 |
| silesia/sao | 7251944 | stdx | 5.57 | 10.32 | 1.85 | 86.89 |
| silesia/webster | 41458703 | zlib | 7.07 | 12.99 | 1.84 | 276.91 |
| silesia/webster | 41458703 | zlib-ng | 4.24 | 8.04 | 1.90 | 85.14 |
| silesia/webster | 41458703 | libdeflate | 2.92 | 7.17 | 2.46 | 68.60 |
| silesia/webster | 41458703 | Wuffs | 4.56 | 8.62 | 1.89 | 123.43 |
| silesia/webster | 41458703 | stdx | 2.82 | 5.57 | 1.97 | 86.81 |
| silesia/x-ray | 8474240 | zlib | 12.24 | 23.82 | 1.95 | 322.14 |
| silesia/x-ray | 8474240 | zlib-ng | 9.03 | 17.39 | 1.93 | 124.20 |
| silesia/x-ray | 8474240 | libdeflate | 6.55 | 15.26 | 2.33 | 124.42 |
| silesia/x-ray | 8474240 | Wuffs | 10.08 | 20.40 | 2.02 | 191.36 |
| silesia/x-ray | 8474240 | stdx | 6.15 | 11.50 | 1.87 | 138.03 |
| silesia/xml | 5345280 | zlib | 3.64 | 8.20 | 2.25 | 116.74 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.82 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.46 | 31.66 |
| silesia/xml | 5345280 | Wuffs | 2.20 | 4.14 | 1.88 | 61.01 |
| silesia/xml | 5345280 | stdx | 1.34 | 2.66 | 1.99 | 41.67 |
| canterbury/alice29.txt | 152089 | zlib | 7.69 | 15.08 | 1.96 | 291.10 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.55 | 9.91 | 2.18 | 59.92 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.16 | 8.96 | 2.84 | 55.69 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.74 | 10.37 | 2.19 | 98.52 |
| canterbury/alice29.txt | 152089 | stdx | 2.71 | 7.00 | 2.59 | 61.96 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.23 | 16.11 | 1.96 | 309.23 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.11 | 10.86 | 2.12 | 72.42 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.58 | 9.82 | 2.74 | 70.68 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.12 | 11.34 | 2.22 | 100.00 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.06 | 7.53 | 2.46 | 77.07 |
| canterbury/cp.html | 24603 | zlib | 6.39 | 14.20 | 2.22 | 162.23 |
| canterbury/cp.html | 24603 | zlib-ng | 4.25 | 9.50 | 2.23 | 42.13 |
| canterbury/cp.html | 24603 | libdeflate | 2.84 | 7.95 | 2.80 | 14.94 |
| canterbury/cp.html | 24603 | Wuffs | 4.44 | 10.87 | 2.45 | 53.30 |
| canterbury/cp.html | 24603 | stdx | 2.66 | 7.19 | 2.70 | 13.92 |
| canterbury/fields.c | 11150 | zlib | 4.48 | 14.65 | 3.27 | 27.44 |
| canterbury/fields.c | 11150 | zlib-ng | 3.90 | 10.20 | 2.62 | 15.28 |
| canterbury/fields.c | 11150 | libdeflate | 2.79 | 8.32 | 2.99 | 2.18 |
| canterbury/fields.c | 11150 | Wuffs | 3.82 | 11.51 | 3.01 | 8.99 |
| canterbury/fields.c | 11150 | stdx | 2.50 | 7.64 | 3.06 | 4.70 |
| canterbury/grammar.lsp | 3721 | zlib | 6.16 | 21.22 | 3.44 | 1.55 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.82 | 17.48 | 3.00 | 7.01 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.46 | 12.05 | 2.70 | 0.85 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.97 | 18.87 | 3.16 | 3.57 |
| canterbury/grammar.lsp | 3721 | stdx | 3.84 | 12.18 | 3.17 | 1.35 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.95 | 12.20 | 3.09 | 48.01 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.85 | 6.97 | 2.45 | 12.55 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.74 | 5.97 | 2.18 | 9.39 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.20 | 8.67 | 2.71 | 14.80 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.75 | 4.66 | 2.66 | 16.62 |
| canterbury/lcet10.txt | 426754 | zlib | 7.46 | 14.53 | 1.95 | 286.38 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.34 | 9.39 | 2.16 | 60.90 |
| canterbury/lcet10.txt | 426754 | libdeflate | 2.99 | 8.48 | 2.83 | 55.13 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.61 | 9.85 | 2.14 | 101.04 |
| canterbury/lcet10.txt | 426754 | stdx | 2.60 | 6.43 | 2.48 | 66.47 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.41 | 16.53 | 1.97 | 318.18 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.31 | 11.19 | 2.11 | 78.05 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.72 | 10.19 | 2.74 | 77.05 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.19 | 11.53 | 2.22 | 99.32 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.15 | 7.64 | 2.42 | 85.03 |
| canterbury/ptt5 | 513216 | zlib | 4.43 | 7.79 | 1.76 | 100.32 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.52 |
| canterbury/ptt5 | 513216 | libdeflate | 1.45 | 3.02 | 2.08 | 37.96 |
| canterbury/ptt5 | 513216 | Wuffs | 2.19 | 4.02 | 1.83 | 58.63 |
| canterbury/ptt5 | 513216 | stdx | 1.45 | 2.55 | 1.76 | 49.16 |
| canterbury/sum | 38240 | zlib | 7.27 | 14.98 | 2.06 | 213.07 |
| canterbury/sum | 38240 | zlib-ng | 4.64 | 10.02 | 2.16 | 55.50 |
| canterbury/sum | 38240 | libdeflate | 3.39 | 8.34 | 2.46 | 43.02 |
| canterbury/sum | 38240 | Wuffs | 5.04 | 11.41 | 2.27 | 79.11 |
| canterbury/sum | 38240 | stdx | 3.02 | 7.73 | 2.56 | 28.84 |
| canterbury/xargs.1 | 4227 | zlib | 6.66 | 22.08 | 3.32 | 6.47 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.37 | 17.97 | 2.82 | 8.27 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.79 | 13.27 | 2.77 | 0.15 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.47 | 19.63 | 3.04 | 6.45 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 12.86 | 3.04 | 1.35 |
| canterbury-large/E.coli | 4638690 | zlib | 6.01 | 14.55 | 2.42 | 176.96 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.24 | 9.68 | 2.28 | 47.27 |
| canterbury-large/E.coli | 4638690 | libdeflate | 2.98 | 8.86 | 2.97 | 48.82 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.02 | 9.64 | 2.40 | 61.52 |
| canterbury-large/E.coli | 4638690 | stdx | 2.49 | 6.74 | 2.70 | 54.80 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.82 | 13.26 | 1.94 | 264.96 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.78 | 8.26 | 2.19 | 53.92 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.58 | 7.45 | 2.89 | 45.53 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.19 | 8.72 | 2.08 | 101.13 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.24 | 5.58 | 2.49 | 55.81 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.04 | 12.69 | 1.80 | 276.64 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.19 | 7.78 | 1.86 | 91.51 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 74.93 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.55 | 8.44 | 1.85 | 129.87 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 5.41 | 1.98 | 90.30 |
| http/html-1kx1024 | 1048576 | zlib | 15.84 | 32.44 | 2.05 | 353.75 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.66 | 28.43 | 2.25 | 216.79 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.90 | 20.05 | 1.84 | 157.07 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.63 | 35.05 | 2.40 | 264.74 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.86 | 2.49 | 137.02 |
| http/html-16kx64 | 1048576 | zlib | 6.07 | 11.79 | 1.94 | 217.62 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.86 | 7.54 | 1.95 | 84.84 |
| http/html-16kx64 | 1048576 | libdeflate | 2.66 | 6.04 | 2.27 | 60.25 |
| http/html-16kx64 | 1048576 | Wuffs | 4.28 | 8.51 | 1.99 | 117.12 |
| http/html-16kx64 | 1048576 | stdx | 2.52 | 5.57 | 2.21 | 59.41 |
| http/html-1m | 1048576 | zlib | 4.69 | 9.51 | 2.03 | 173.77 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 60.14 |
| http/html-1m | 1048576 | libdeflate | 1.69 | 4.39 | 2.60 | 37.25 |
| http/html-1m | 1048576 | Wuffs | 2.98 | 5.42 | 1.82 | 90.25 |
| http/html-1m | 1048576 | stdx | 1.65 | 3.46 | 2.10 | 52.47 |
| http/json-1kx1024 | 1048576 | zlib | 9.74 | 20.83 | 2.14 | 195.81 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.42 | 16.69 | 2.25 | 132.88 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.15 | 16.72 | 1.83 | 93.58 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.46 | 31.72 | 2.77 | 145.65 |
| http/json-1kx1024 | 1048576 | stdx | 5.02 | 13.11 | 2.61 | 80.72 |
| http/json-16kx64 | 1048576 | zlib | 3.97 | 9.62 | 2.42 | 101.62 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.53 |
| http/json-16kx64 | 1048576 | libdeflate | 1.93 | 4.24 | 2.19 | 39.78 |
| http/json-16kx64 | 1048576 | Wuffs | 2.82 | 6.35 | 2.25 | 58.38 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.26 | 39.23 |
| http/json-1m | 1048576 | zlib | 3.26 | 8.25 | 2.53 | 81.89 |
| http/json-1m | 1048576 | zlib-ng | 1.94 | 3.91 | 2.01 | 37.80 |
| http/json-1m | 1048576 | libdeflate | 1.37 | 3.33 | 2.42 | 32.25 |
| http/json-1m | 1048576 | Wuffs | 2.05 | 4.29 | 2.09 | 44.35 |
| http/json-1m | 1048576 | stdx | 1.33 | 2.67 | 2.01 | 39.87 |
| http/js-1kx1024 | 1048576 | zlib | 17.30 | 35.33 | 2.04 | 405.50 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.75 | 31.25 | 2.27 | 239.19 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.59 | 21.58 | 1.86 | 180.59 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.79 | 37.71 | 2.39 | 297.37 |
| http/js-1kx1024 | 1048576 | stdx | 9.29 | 22.84 | 2.46 | 159.49 |
| http/js-16kx64 | 1048576 | zlib | 6.95 | 13.06 | 1.88 | 256.27 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.39 | 8.65 | 1.97 | 91.58 |
| http/js-16kx64 | 1048576 | libdeflate | 3.08 | 7.01 | 2.28 | 72.00 |
| http/js-16kx64 | 1048576 | Wuffs | 4.86 | 9.70 | 2.00 | 130.55 |
| http/js-16kx64 | 1048576 | stdx | 3.02 | 6.54 | 2.17 | 72.50 |
| http/js-1m | 1048576 | zlib | 5.21 | 10.26 | 1.97 | 198.61 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 60.42 |
| http/js-1m | 1048576 | libdeflate | 1.91 | 4.98 | 2.60 | 42.17 |
| http/js-1m | 1048576 | Wuffs | 3.27 | 6.10 | 1.86 | 95.91 |
| http/js-1m | 1048576 | stdx | 1.81 | 3.90 | 2.16 | 55.17 |
| http/css-1kx1024 | 1048576 | zlib | 13.22 | 27.18 | 2.06 | 288.64 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.22 | 23.04 | 2.26 | 172.18 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.50 | 17.37 | 1.83 | 125.26 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.07 | 29.48 | 2.44 | 208.46 |
| http/css-1kx1024 | 1048576 | stdx | 6.68 | 17.62 | 2.64 | 100.75 |
| http/css-16kx64 | 1048576 | zlib | 4.68 | 10.12 | 2.16 | 151.32 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.79 | 6.07 | 2.17 | 50.90 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 28.83 |
| http/css-16kx64 | 1048576 | Wuffs | 3.12 | 6.97 | 2.24 | 70.04 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.37 | 2.54 | 28.12 |
| http/css-1m | 1048576 | zlib | 3.40 | 8.00 | 2.36 | 107.34 |
| http/css-1m | 1048576 | zlib-ng | 1.71 | 3.75 | 2.20 | 30.18 |
| http/css-1m | 1048576 | libdeflate | 1.04 | 3.18 | 3.06 | 10.70 |
| http/css-1m | 1048576 | Wuffs | 1.91 | 4.08 | 2.13 | 44.96 |
| http/css-1m | 1048576 | stdx | 1.02 | 2.56 | 2.51 | 21.57 |
| shuffled/dickens-1m | 1048576 | zlib | 12.75 | 22.42 | 1.76 | 369.39 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.66 | 16.72 | 1.73 | 198.48 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.16 | 14.95 | 2.09 | 194.11 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.65 | 18.95 | 1.96 | 206.74 |
| shuffled/dickens-1m | 1048576 | stdx | 7.04 | 11.91 | 1.69 | 205.18 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.63 | 14.04 | 3.87 | 3.51 |
| silesia/dickens | 10192446 | stdx | 3.83 | 12.47 | 3.26 | 3.59 |
| silesia/mozilla | 51220480 | libzstd | 2.87 | 9.62 | 3.35 | 31.50 |
| silesia/mozilla | 51220480 | stdx | 2.86 | 9.68 | 3.38 | 15.49 |
| silesia/mr | 9970564 | libzstd | 3.10 | 11.98 | 3.87 | 6.26 |
| silesia/mr | 9970564 | stdx | 3.12 | 10.83 | 3.47 | 5.19 |
| silesia/nci | 33553445 | libzstd | 1.66 | 4.84 | 2.92 | 24.40 |
| silesia/nci | 33553445 | stdx | 1.65 | 4.63 | 2.80 | 13.51 |
| silesia/ooffice | 6152192 | libzstd | 3.44 | 12.14 | 3.53 | 32.75 |
| silesia/ooffice | 6152192 | stdx | 3.33 | 12.40 | 3.72 | 12.11 |
| silesia/osdb | 10085684 | libzstd | 2.40 | 8.44 | 3.52 | 15.12 |
| silesia/osdb | 10085684 | stdx | 2.49 | 8.11 | 3.26 | 15.48 |
| silesia/reymont | 6627202 | libzstd | 3.27 | 11.61 | 3.55 | 11.82 |
| silesia/reymont | 6627202 | stdx | 3.39 | 10.36 | 3.05 | 12.72 |
| silesia/samba | 21606400 | libzstd | 2.10 | 7.39 | 3.52 | 19.05 |
| silesia/samba | 21606400 | stdx | 2.13 | 6.83 | 3.21 | 17.49 |
| silesia/sao | 7251944 | libzstd | 3.82 | 12.69 | 3.32 | 26.51 |
| silesia/sao | 7251944 | stdx | 3.50 | 12.58 | 3.59 | 6.32 |
| silesia/webster | 41458703 | libzstd | 3.31 | 11.22 | 3.40 | 16.19 |
| silesia/webster | 41458703 | stdx | 3.48 | 10.05 | 2.89 | 17.73 |
| silesia/x-ray | 8474240 | libzstd | 4.00 | 14.93 | 3.73 | 18.72 |
| silesia/x-ray | 8474240 | stdx | 3.59 | 13.23 | 3.69 | 8.49 |
| silesia/xml | 5345280 | libzstd | 1.54 | 5.55 | 3.60 | 23.18 |
| silesia/xml | 5345280 | stdx | 1.52 | 5.16 | 3.40 | 17.01 |
| canterbury/alice29.txt | 152089 | libzstd | 3.37 | 16.18 | 4.81 | 4.32 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.37 | 0.42 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.00 | 14.25 | 4.75 | 3.37 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.30 | 0.32 |
| canterbury/cp.html | 24603 | libzstd | 2.71 | 10.74 | 3.96 | 11.72 |
| canterbury/cp.html | 24603 | stdx | 2.54 | 10.42 | 4.10 | 0.16 |
| canterbury/fields.c | 11150 | libzstd | 3.17 | 13.61 | 4.30 | 12.36 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.23 | 0.11 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.39 | 16.93 | 3.86 | 11.16 |
| canterbury/grammar.lsp | 3721 | stdx | 4.13 | 16.53 | 4.01 | 0.22 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.51 | 11.22 | 4.48 | 8.07 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.24 | 0.84 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.74 | 12.87 | 4.70 | 5.43 |
| canterbury/lcet10.txt | 426754 | stdx | 2.71 | 11.52 | 4.25 | 3.17 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.17 | 15.14 | 4.77 | 1.54 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.27 | 0.87 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.50 | 3.11 | 24.39 |
| canterbury/ptt5 | 513216 | stdx | 1.36 | 4.46 | 3.28 | 16.52 |
| canterbury/sum | 38240 | libzstd | 2.75 | 10.51 | 3.83 | 17.67 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.30 |
| canterbury/xargs.1 | 4227 | libzstd | 4.34 | 17.40 | 4.01 | 13.92 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.16 | 4.05 | 0.21 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.07 | 13.63 | 4.44 | 2.11 |
| canterbury-large/E.coli | 4638690 | stdx | 3.11 | 12.04 | 3.87 | 3.02 |
| canterbury-large/bible.txt | 4047392 | libzstd | 3.00 | 11.99 | 4.00 | 8.50 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.11 | 10.64 | 3.42 | 9.34 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.57 | 9.59 | 3.73 | 19.76 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.68 | 8.64 | 3.22 | 21.27 |
| http/html-1kx1024 | 1048576 | libzstd | 7.40 | 21.63 | 2.92 | 62.76 |
| http/html-1kx1024 | 1048576 | stdx | 7.47 | 22.43 | 3.00 | 75.85 |
| http/html-16kx64 | 1048576 | libzstd | 2.67 | 10.15 | 3.80 | 29.11 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.61 | 30.59 |
| http/html-1m | 1048576 | libzstd | 2.01 | 7.86 | 3.91 | 24.75 |
| http/html-1m | 1048576 | stdx | 2.00 | 7.12 | 3.56 | 24.93 |
| http/json-1kx1024 | 1048576 | libzstd | 6.38 | 17.37 | 2.72 | 50.21 |
| http/json-1kx1024 | 1048576 | stdx | 6.24 | 17.84 | 2.86 | 53.75 |
| http/json-16kx64 | 1048576 | libzstd | 2.06 | 7.22 | 3.51 | 28.76 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 19.56 |
| http/json-1m | 1048576 | libzstd | 1.74 | 6.04 | 3.47 | 28.87 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.63 | 14.00 |
| http/js-1kx1024 | 1048576 | libzstd | 8.44 | 26.38 | 3.12 | 73.19 |
| http/js-1kx1024 | 1048576 | stdx | 9.06 | 27.57 | 3.04 | 112.90 |
| http/js-16kx64 | 1048576 | libzstd | 2.94 | 11.71 | 3.99 | 25.05 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.74 | 26.21 |
| http/js-1m | 1048576 | libzstd | 2.03 | 8.18 | 4.02 | 20.85 |
| http/js-1m | 1048576 | stdx | 2.07 | 7.48 | 3.62 | 21.67 |
| http/css-1kx1024 | 1048576 | libzstd | 7.08 | 19.70 | 2.78 | 57.65 |
| http/css-1kx1024 | 1048576 | stdx | 6.86 | 19.93 | 2.90 | 63.78 |
| http/css-16kx64 | 1048576 | libzstd | 2.30 | 8.69 | 3.78 | 27.45 |
| http/css-16kx64 | 1048576 | stdx | 2.28 | 8.43 | 3.70 | 22.12 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.57 | 3.82 | 6.04 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.49 | 3.79 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.81 | 9.40 | 3.35 | 28.60 |
| shuffled/dickens-1m | 1048576 | stdx | 2.74 | 9.19 | 3.36 | 12.47 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.58 | 17.04 | 2.25 | 102.16 |
| silesia/dickens | 1048576 | stdx | 5.13 | 12.38 | 2.41 | 54.61 |
| silesia/mozilla | 1048576 | Google | 13.63 | 27.77 | 2.04 | 46.39 |
| silesia/mozilla | 1048576 | stdx | 8.33 | 15.02 | 1.80 | 47.90 |
| silesia/mr | 1048576 | Google | 8.93 | 20.24 | 2.27 | 103.70 |
| silesia/mr | 1048576 | stdx | 5.79 | 13.25 | 2.29 | 88.71 |
| silesia/nci | 1048576 | Google | 2.57 | 5.69 | 2.22 | 51.78 |
| silesia/nci | 1048576 | stdx | 1.95 | 3.95 | 2.03 | 54.69 |
| silesia/ooffice | 1048576 | Google | 14.27 | 29.28 | 2.05 | 292.11 |
| silesia/ooffice | 1048576 | stdx | 10.91 | 20.33 | 1.86 | 323.04 |
| silesia/osdb | 1048576 | Google | 8.26 | 17.38 | 2.11 | 96.20 |
| silesia/osdb | 1048576 | stdx | 5.16 | 10.57 | 2.05 | 91.85 |
| silesia/reymont | 1048576 | Google | 5.46 | 12.73 | 2.33 | 82.38 |
| silesia/reymont | 1048576 | stdx | 3.75 | 9.25 | 2.47 | 47.70 |
| silesia/samba | 1048576 | Google | 7.62 | 16.22 | 2.13 | 96.52 |
| silesia/samba | 1048576 | stdx | 5.07 | 10.71 | 2.11 | 66.84 |
| silesia/sao | 1048576 | Google | 16.83 | 36.97 | 2.20 | 165.43 |
| silesia/sao | 1048576 | stdx | 10.41 | 22.65 | 2.17 | 141.17 |
| silesia/webster | 1048576 | Google | 6.62 | 14.07 | 2.12 | 116.43 |
| silesia/webster | 1048576 | stdx | 4.43 | 9.98 | 2.25 | 69.04 |
| silesia/x-ray | 1048576 | Google | 19.66 | 38.46 | 1.96 | 237.72 |
| silesia/x-ray | 1048576 | stdx | 14.59 | 30.18 | 2.07 | 235.11 |
| silesia/xml | 1048576 | Google | 3.49 | 7.65 | 2.19 | 66.01 |
| silesia/xml | 1048576 | stdx | 2.41 | 5.40 | 2.25 | 46.95 |
| canterbury/alice29.txt | 152089 | Google | 8.93 | 20.66 | 2.31 | 137.58 |
| canterbury/alice29.txt | 152089 | stdx | 6.09 | 15.33 | 2.52 | 83.04 |
| canterbury/asyoulik.txt | 125179 | Google | 10.51 | 23.83 | 2.27 | 173.12 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.09 | 17.43 | 2.46 | 106.10 |
| canterbury/cp.html | 24603 | Google | 9.18 | 22.18 | 2.42 | 116.46 |
| canterbury/cp.html | 24603 | stdx | 6.00 | 17.15 | 2.86 | 48.94 |
| canterbury/fields.c | 11150 | Google | 7.22 | 21.25 | 2.95 | 31.08 |
| canterbury/fields.c | 11150 | stdx | 4.88 | 17.08 | 3.50 | 1.49 |
| canterbury/grammar.lsp | 3721 | Google | 9.83 | 30.23 | 3.08 | 6.87 |
| canterbury/grammar.lsp | 3721 | stdx | 7.15 | 25.04 | 3.50 | 1.33 |
| canterbury/kennedy.xls | 1029744 | Google | 5.48 | 17.05 | 3.11 | 37.30 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.81 | 12.94 | 3.40 | 34.12 |
| canterbury/lcet10.txt | 426754 | Google | 7.78 | 17.42 | 2.24 | 130.89 |
| canterbury/lcet10.txt | 426754 | stdx | 5.18 | 12.96 | 2.50 | 66.31 |
| canterbury/plrabn12.txt | 481861 | Google | 9.14 | 20.94 | 2.29 | 135.64 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.15 | 15.04 | 2.45 | 87.34 |
| canterbury/ptt5 | 513216 | Google | 4.30 | 10.36 | 2.41 | 63.48 |
| canterbury/ptt5 | 513216 | stdx | 2.36 | 4.89 | 2.08 | 64.74 |
| canterbury/sum | 38240 | Google | 10.86 | 26.44 | 2.43 | 160.08 |
| canterbury/sum | 38240 | stdx | 8.35 | 21.11 | 2.53 | 158.78 |
| canterbury/xargs.1 | 4227 | Google | 10.96 | 34.81 | 3.17 | 12.47 |
| canterbury/xargs.1 | 4227 | stdx | 8.51 | 30.44 | 3.58 | 6.90 |
| canterbury-large/E.coli | 1048576 | Google | 7.48 | 19.44 | 2.60 | 1.45 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.20 |
| canterbury-large/bible.txt | 1048576 | Google | 5.38 | 12.38 | 2.30 | 81.60 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.55 | 8.93 | 2.51 | 39.97 |
| canterbury-large/world192.txt | 1048576 | Google | 6.27 | 12.88 | 2.05 | 117.53 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.42 | 9.38 | 2.12 | 77.16 |
| http/html-1kx1024 | 1048576 | Google | 17.99 | 42.09 | 2.34 | 386.29 |
| http/html-1kx1024 | 1048576 | stdx | 15.26 | 37.56 | 2.46 | 360.55 |
| http/html-16kx64 | 1048576 | Google | 6.77 | 14.88 | 2.20 | 150.97 |
| http/html-16kx64 | 1048576 | stdx | 5.14 | 12.15 | 2.36 | 114.37 |
| http/html-1m | 1048576 | Google | 4.09 | 8.99 | 2.20 | 83.86 |
| http/html-1m | 1048576 | stdx | 2.87 | 6.52 | 2.28 | 54.72 |
| http/json-1kx1024 | 1048576 | Google | 14.35 | 36.74 | 2.56 | 238.98 |
| http/json-1kx1024 | 1048576 | stdx | 13.00 | 33.63 | 2.59 | 277.08 |
| http/json-16kx64 | 1048576 | Google | 4.41 | 11.42 | 2.59 | 81.16 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.72 |
| http/json-1m | 1048576 | Google | 3.42 | 8.66 | 2.53 | 58.69 |
| http/json-1m | 1048576 | stdx | 2.47 | 5.99 | 2.43 | 57.98 |
| http/js-1kx1024 | 1048576 | Google | 19.92 | 46.38 | 2.33 | 426.03 |
| http/js-1kx1024 | 1048576 | stdx | 16.36 | 39.90 | 2.44 | 381.16 |
| http/js-16kx64 | 1048576 | Google | 8.09 | 17.79 | 2.20 | 169.32 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.73 |
| http/js-1m | 1048576 | Google | 4.42 | 9.60 | 2.17 | 83.89 |
| http/js-1m | 1048576 | stdx | 3.16 | 7.25 | 2.29 | 55.20 |
| http/css-1kx1024 | 1048576 | Google | 15.43 | 37.48 | 2.43 | 292.51 |
| http/css-1kx1024 | 1048576 | stdx | 13.79 | 34.70 | 2.52 | 302.38 |
| http/css-16kx64 | 1048576 | Google | 4.97 | 11.78 | 2.37 | 101.39 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.49 | 80.87 |
| http/css-1m | 1048576 | Google | 2.45 | 9.43 | 3.85 | 16.73 |
| http/css-1m | 1048576 | stdx | 0.76 | 1.86 | 2.46 | 11.99 |
| shuffled/dickens-1m | 1048576 | Google | 9.64 | 20.34 | 2.11 | 106.18 |
| shuffled/dickens-1m | 1048576 | stdx | 8.74 | 14.53 | 1.66 | 115.01 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.5 | 74.3 | 0.119 | 3.01 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 70.6 | 238.3 | 0.105 | 8.33 | 3.38 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 261.8 | 1119.2 | 0.813 | 30.92 | 4.28 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.2 | 106.7 | 0.139 | 3.57 | 3.53 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.1 | 107.1 | 0.297 | 3.31 | 3.82 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 94.8 | 378.2 | 0.391 | 11.20 | 3.99 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.0 | 89.6 | 0.004 | 3.98 | 3.32 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 71.0 | 249.9 | 0.042 | 10.45 | 3.52 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 225.0 | 880.2 | 0.913 | 33.12 | 3.91 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 27.7 | 107.5 | 0.039 | 4.08 | 3.88 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.4 | 106.7 | 0.050 | 4.32 | 3.63 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 94.1 | 345.9 | 0.344 | 13.85 | 3.68 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 113773.2 | 403839.2 | 470.041 | 0.66 | 3.55 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 612117.0 | 2684141.2 | 1340.732 | 3.55 | 4.39 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3857925.9 | 20639255.2 | 2976.845 | 22.36 | 5.35 |
| string: silesia/dickens | 1 | 172528 | simdjson | 311819.7 | 621748.2 | 643.485 | 1.81 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 226689.0 | 848188.2 | 2305.495 | 1.31 | 3.74 |
| string: silesia/dickens | 1 | 172528 | std.json | 1619148.6 | 4595563.3 | 45394.804 | 9.38 | 2.84 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1562674.7 | 4799762.6 | 1263.143 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 15038335.6 | 60619385.6 | 57208.286 | 12.63 | 4.03 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 31578021.0 | 148769682.6 | 157852.500 | 26.53 | 4.71 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4586712.5 | 7053853.6 | 566.143 | 3.85 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1787627.6 | 7470807.6 | 14635.357 | 1.50 | 4.18 |
| string: http/json-1m | 1 | 1190272 | std.json | 10014624.5 | 47253785.6 | 31199.857 | 8.41 | 4.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2063423.1 | 5765412.8 | 4345.875 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6472042.3 | 24133030.8 | 12614.750 | 3.44 | 3.73 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 51754358.6 | 252608919.8 | 289002.625 | 27.48 | 4.88 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3683376.6 | 7945848.8 | 1948.875 | 1.96 | 2.16 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7148111.9 | 12512113.8 | 276880.625 | 3.80 | 1.75 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17510348.6 | 63922930.8 | 225129.000 | 9.30 | 3.65 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12950101.0 | 42561068.3 | 245715.667 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 173862996.7 | 732363048.3 | 388484.333 | 34.26 | 4.21 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 165828040.7 | 708654908.3 | 420901.000 | 32.67 | 4.27 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17560234.7 | 49745827.3 | 219624.000 | 3.46 | 2.83 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14265136.3 | 45451415.3 | 451976.667 | 2.81 | 3.19 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 78160865.0 | 314355510.3 | 453491.000 | 15.40 | 4.02 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 187213.5 | 688807.7 | 4.323 | 0.36 | 3.68 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 185081.6 | 689029.7 | 11.613 | 0.35 | 3.72 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 11151853.8 | 60818249.7 | 7.806 | 21.27 | 5.45 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 491235.5 | 1376743.7 | 2.871 | 0.94 | 2.80 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 545190.8 | 2261447.7 | 8.484 | 1.04 | 4.15 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3443921.2 | 12808414.7 | 62728.548 | 6.57 | 3.72 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 21.7 | 91.8 | 0.108 | 2.56 | 4.23 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 73.8 | 342.1 | 0.193 | 8.72 | 4.64 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 221.7 | 1092.4 | 0.855 | 26.19 | 4.93 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 20.9 | 87.2 | 0.109 | 2.47 | 4.18 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 22.0 | 83.9 | 0.137 | 2.60 | 3.82 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 26.9 | 105.4 | 0.244 | 3.18 | 3.91 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 68.5 | 310.3 | 0.370 | 8.09 | 4.53 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 21.6 | 92.6 | 0.037 | 3.18 | 4.29 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 69.9 | 324.0 | 0.062 | 10.30 | 4.63 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 173.0 | 790.0 | 1.195 | 25.46 | 4.57 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 20.2 | 88.8 | 0.038 | 2.97 | 4.40 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 20.3 | 87.1 | 0.032 | 2.99 | 4.29 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.1 | 117.7 | 0.032 | 4.28 | 4.05 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.3 | 270.9 | 0.280 | 8.72 | 4.57 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 122436.2 | 464403.2 | 521.062 | 0.71 | 3.79 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 518725.1 | 2182153.2 | 1210.588 | 3.01 | 4.21 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3412215.2 | 18380954.2 | 2945.629 | 19.78 | 5.39 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 125089.4 | 460565.2 | 729.753 | 0.73 | 3.68 |
| string: silesia/dickens | 1 | 172528 | simdjson | 192143.8 | 627385.2 | 1947.969 | 1.11 | 3.27 |
| string: silesia/dickens | 1 | 172528 | yyjson | 215096.9 | 848559.2 | 1400.093 | 1.25 | 3.95 |
| string: silesia/dickens | 1 | 172528 | std.json | 1369834.3 | 2890187.2 | 54695.041 | 7.94 | 2.11 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 3436220.3 | 8766181.6 | 2633.571 | 2.89 | 2.55 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 10043739.3 | 44158803.6 | 21750.214 | 8.44 | 4.40 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 26393364.8 | 124535257.6 | 139686.000 | 22.17 | 4.72 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 3421884.0 | 8990926.6 | 3168.786 | 2.87 | 2.63 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2910357.3 | 10119250.6 | 29572.286 | 2.45 | 3.48 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2674748.9 | 11226214.6 | 9714.071 | 2.25 | 4.20 |
| string: http/json-1m | 1 | 1190272 | std.json | 8739665.9 | 42694254.6 | 15365.071 | 7.34 | 4.89 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2087036.4 | 6046671.8 | 4346.375 | 1.11 | 2.90 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6778661.3 | 23416085.8 | 12352.625 | 3.60 | 3.45 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 46349087.6 | 218527029.8 | 252304.125 | 24.61 | 4.71 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2087302.0 | 6189781.8 | 4521.375 | 1.11 | 2.97 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2640541.8 | 6858904.8 | 20867.500 | 1.40 | 2.60 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12389166.5 | 26334410.8 | 418202.625 | 6.58 | 2.13 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20720584.5 | 57035436.8 | 560108.500 | 11.00 | 2.75 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 112826.8 | 426377.7 | 5.161 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 112768.4 | 426473.7 | 4.290 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 638111.7 | 3146523.7 | 6.645 | 1.22 | 4.93 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 112714.2 | 426345.7 | 1.516 | 0.21 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1223899.2 | 3932432.7 | 4.613 | 2.33 | 3.21 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1641922.9 | 5898886.7 | 5.935 | 3.13 | 3.59 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3564438.8 | 13174372.7 | 76491.968 | 6.80 | 3.70 |
