# bench-profile

| Field | Value |
|---|---|
| Commit | 62875f6 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260927.135.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/37230114053 |
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
| silesia/dickens | 10192446 | zlib | 7.97 | 15.77 | 1.98 | 299.71 |
| silesia/dickens | 10192446 | zlib-ng | 4.88 | 10.50 | 2.15 | 68.19 |
| silesia/dickens | 10192446 | libdeflate | 3.45 | 9.56 | 2.78 | 65.95 |
| silesia/dickens | 10192446 | Wuffs | 4.84 | 10.85 | 2.24 | 97.12 |
| silesia/dickens | 10192446 | stdx | 3.01 | 7.48 | 2.49 | 77.44 |
| silesia/mozilla | 51220480 | zlib | 7.75 | 14.13 | 1.82 | 243.36 |
| silesia/mozilla | 51220480 | zlib-ng | 4.92 | 8.95 | 1.82 | 85.80 |
| silesia/mozilla | 51220480 | libdeflate | 3.45 | 7.63 | 2.21 | 70.98 |
| silesia/mozilla | 51220480 | Wuffs | 5.68 | 10.84 | 1.91 | 132.70 |
| silesia/mozilla | 51220480 | stdx | 3.71 | 6.98 | 1.88 | 92.44 |
| silesia/mr | 9970564 | zlib | 7.66 | 15.26 | 1.99 | 196.94 |
| silesia/mr | 9970564 | zlib-ng | 4.79 | 9.98 | 2.09 | 68.44 |
| silesia/mr | 9970564 | libdeflate | 3.35 | 8.58 | 2.56 | 61.25 |
| silesia/mr | 9970564 | Wuffs | 5.25 | 10.93 | 2.08 | 99.63 |
| silesia/mr | 9970564 | stdx | 3.19 | 7.18 | 2.25 | 71.46 |
| silesia/nci | 33553445 | zlib | 2.90 | 7.25 | 2.50 | 79.57 |
| silesia/nci | 33553445 | zlib-ng | 1.58 | 3.13 | 1.98 | 34.20 |
| silesia/nci | 33553445 | libdeflate | 1.10 | 2.66 | 2.42 | 27.90 |
| silesia/nci | 33553445 | Wuffs | 1.68 | 3.38 | 2.01 | 42.42 |
| silesia/nci | 33553445 | stdx | 1.14 | 2.29 | 2.00 | 37.41 |
| silesia/ooffice | 6152192 | zlib | 11.00 | 17.83 | 1.62 | 401.62 |
| silesia/ooffice | 6152192 | zlib-ng | 6.89 | 12.04 | 1.75 | 140.55 |
| silesia/ooffice | 6152192 | libdeflate | 4.92 | 10.45 | 2.13 | 125.42 |
| silesia/ooffice | 6152192 | Wuffs | 8.08 | 14.47 | 1.79 | 219.64 |
| silesia/ooffice | 6152192 | stdx | 5.33 | 9.60 | 1.80 | 155.75 |
| silesia/osdb | 10085684 | zlib | 6.78 | 13.54 | 2.00 | 171.49 |
| silesia/osdb | 10085684 | zlib-ng | 4.28 | 8.38 | 1.96 | 53.01 |
| silesia/osdb | 10085684 | libdeflate | 2.83 | 6.91 | 2.44 | 29.74 |
| silesia/osdb | 10085684 | Wuffs | 5.08 | 10.56 | 2.08 | 75.60 |
| silesia/osdb | 10085684 | stdx | 2.92 | 6.25 | 2.14 | 42.44 |
| silesia/reymont | 6627202 | zlib | 6.63 | 12.73 | 1.92 | 252.33 |
| silesia/reymont | 6627202 | zlib-ng | 3.71 | 7.72 | 2.08 | 60.32 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.18 |
| silesia/reymont | 6627202 | Wuffs | 4.23 | 8.40 | 1.98 | 113.37 |
| silesia/reymont | 6627202 | stdx | 2.35 | 5.36 | 2.28 | 65.18 |
| silesia/samba | 21606400 | zlib | 5.46 | 11.09 | 2.03 | 169.81 |
| silesia/samba | 21606400 | zlib-ng | 3.35 | 6.47 | 1.93 | 55.95 |
| silesia/samba | 21606400 | libdeflate | 2.31 | 5.58 | 2.42 | 42.88 |
| silesia/samba | 21606400 | Wuffs | 3.64 | 7.33 | 2.02 | 81.27 |
| silesia/samba | 21606400 | stdx | 2.33 | 4.77 | 2.04 | 57.51 |
| silesia/sao | 7251944 | zlib | 9.93 | 20.36 | 2.05 | 200.16 |
| silesia/sao | 7251944 | zlib-ng | 7.83 | 14.83 | 1.89 | 79.35 |
| silesia/sao | 7251944 | libdeflate | 5.74 | 12.73 | 2.22 | 79.07 |
| silesia/sao | 7251944 | Wuffs | 8.13 | 18.14 | 2.23 | 85.22 |
| silesia/sao | 7251944 | stdx | 5.92 | 11.69 | 1.97 | 93.40 |
| silesia/webster | 41458703 | zlib | 6.98 | 12.99 | 1.86 | 272.96 |
| silesia/webster | 41458703 | zlib-ng | 4.19 | 8.04 | 1.92 | 85.03 |
| silesia/webster | 41458703 | libdeflate | 2.85 | 7.17 | 2.52 | 68.41 |
| silesia/webster | 41458703 | Wuffs | 4.47 | 8.62 | 1.93 | 123.48 |
| silesia/webster | 41458703 | stdx | 2.76 | 5.86 | 2.12 | 88.01 |
| silesia/x-ray | 8474240 | zlib | 12.21 | 23.82 | 1.95 | 322.94 |
| silesia/x-ray | 8474240 | zlib-ng | 9.00 | 17.39 | 1.93 | 124.40 |
| silesia/x-ray | 8474240 | libdeflate | 6.53 | 15.26 | 2.33 | 124.52 |
| silesia/x-ray | 8474240 | Wuffs | 10.05 | 20.40 | 2.03 | 189.50 |
| silesia/x-ray | 8474240 | stdx | 6.35 | 12.46 | 1.96 | 140.77 |
| silesia/xml | 5345280 | zlib | 3.61 | 8.20 | 2.27 | 115.90 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.63 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 31.81 |
| silesia/xml | 5345280 | Wuffs | 2.19 | 4.14 | 1.89 | 61.06 |
| silesia/xml | 5345280 | stdx | 1.36 | 2.78 | 2.05 | 42.16 |
| canterbury/alice29.txt | 152089 | zlib | 7.60 | 15.08 | 1.98 | 284.04 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.54 | 9.91 | 2.18 | 60.59 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.19 | 8.96 | 2.81 | 55.22 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.69 | 10.37 | 2.21 | 98.82 |
| canterbury/alice29.txt | 152089 | stdx | 2.88 | 7.43 | 2.58 | 68.08 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.18 | 16.11 | 1.97 | 303.02 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.11 | 10.86 | 2.13 | 74.50 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.64 | 9.82 | 2.70 | 71.90 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.09 | 11.34 | 2.23 | 100.93 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.19 | 8.03 | 2.52 | 77.59 |
| canterbury/cp.html | 24603 | zlib | 6.42 | 14.20 | 2.21 | 166.14 |
| canterbury/cp.html | 24603 | zlib-ng | 4.20 | 9.50 | 2.26 | 38.31 |
| canterbury/cp.html | 24603 | libdeflate | 2.86 | 7.95 | 2.78 | 16.10 |
| canterbury/cp.html | 24603 | Wuffs | 4.55 | 10.87 | 2.39 | 62.59 |
| canterbury/cp.html | 24603 | stdx | 3.10 | 8.75 | 2.82 | 22.36 |
| canterbury/fields.c | 11150 | zlib | 4.50 | 14.65 | 3.25 | 29.55 |
| canterbury/fields.c | 11150 | zlib-ng | 3.86 | 10.20 | 2.64 | 13.25 |
| canterbury/fields.c | 11150 | libdeflate | 2.81 | 8.32 | 2.96 | 1.66 |
| canterbury/fields.c | 11150 | Wuffs | 3.78 | 11.51 | 3.04 | 7.19 |
| canterbury/fields.c | 11150 | stdx | 3.17 | 10.60 | 3.34 | 8.36 |
| canterbury/grammar.lsp | 3721 | zlib | 6.20 | 21.22 | 3.42 | 3.26 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.84 | 17.48 | 2.99 | 7.00 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.48 | 12.05 | 2.69 | 0.72 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.99 | 18.87 | 3.15 | 5.55 |
| canterbury/grammar.lsp | 3721 | stdx | 5.50 | 20.07 | 3.65 | 7.35 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.92 | 12.20 | 3.11 | 47.53 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.61 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.33 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.19 | 8.67 | 2.72 | 14.70 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.84 | 4.99 | 2.72 | 17.83 |
| canterbury/lcet10.txt | 426754 | zlib | 7.39 | 14.53 | 1.97 | 278.61 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.34 | 9.39 | 2.17 | 60.66 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.04 | 8.48 | 2.79 | 55.57 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.55 | 9.85 | 2.17 | 100.89 |
| canterbury/lcet10.txt | 426754 | stdx | 2.70 | 6.79 | 2.52 | 67.66 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.34 | 16.53 | 1.98 | 310.94 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.32 | 11.19 | 2.10 | 79.49 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.70 | 77.50 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.13 | 11.53 | 2.25 | 98.82 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.26 | 8.05 | 2.47 | 86.35 |
| canterbury/ptt5 | 513216 | zlib | 4.41 | 7.79 | 1.77 | 100.59 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.29 |
| canterbury/ptt5 | 513216 | libdeflate | 1.44 | 3.02 | 2.10 | 37.51 |
| canterbury/ptt5 | 513216 | Wuffs | 2.20 | 4.02 | 1.83 | 58.84 |
| canterbury/ptt5 | 513216 | stdx | 1.53 | 2.83 | 1.85 | 50.32 |
| canterbury/sum | 38240 | zlib | 7.23 | 14.98 | 2.07 | 212.27 |
| canterbury/sum | 38240 | zlib-ng | 4.65 | 10.02 | 2.16 | 57.47 |
| canterbury/sum | 38240 | libdeflate | 3.44 | 8.34 | 2.42 | 47.17 |
| canterbury/sum | 38240 | Wuffs | 5.05 | 11.41 | 2.26 | 80.52 |
| canterbury/sum | 38240 | stdx | 3.54 | 9.37 | 2.64 | 43.67 |
| canterbury/xargs.1 | 4227 | zlib | 6.66 | 22.08 | 3.31 | 6.73 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.41 | 17.97 | 2.80 | 10.25 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.83 | 13.27 | 2.75 | 0.63 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.46 | 19.63 | 3.04 | 6.50 |
| canterbury/xargs.1 | 4227 | stdx | 5.71 | 19.83 | 3.47 | 9.47 |
| canterbury-large/E.coli | 4638690 | zlib | 5.98 | 14.55 | 2.43 | 174.84 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.23 | 9.68 | 2.29 | 47.24 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.40 |
| canterbury-large/E.coli | 4638690 | Wuffs | 3.98 | 9.64 | 2.42 | 61.65 |
| canterbury-large/E.coli | 4638690 | stdx | 2.52 | 6.89 | 2.73 | 54.30 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.74 | 13.26 | 1.97 | 257.49 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.77 | 8.26 | 2.19 | 53.74 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.48 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.13 | 8.72 | 2.11 | 100.56 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.30 | 5.82 | 2.53 | 56.67 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.96 | 12.69 | 1.82 | 271.91 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.80 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.24 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.51 | 8.44 | 1.87 | 129.87 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.80 | 5.70 | 2.04 | 91.23 |
| http/html-1kx1024 | 1048576 | zlib | 15.82 | 32.44 | 2.05 | 351.50 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.66 | 28.43 | 2.24 | 213.79 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.83 | 20.05 | 1.85 | 156.13 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.66 | 35.05 | 2.39 | 267.21 |
| http/html-1kx1024 | 1048576 | stdx | 15.34 | 45.05 | 2.94 | 253.50 |
| http/html-16kx64 | 1048576 | zlib | 6.02 | 11.79 | 1.96 | 214.26 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.84 | 7.54 | 1.96 | 84.64 |
| http/html-16kx64 | 1048576 | libdeflate | 2.66 | 6.04 | 2.28 | 60.50 |
| http/html-16kx64 | 1048576 | Wuffs | 4.27 | 8.51 | 1.99 | 117.34 |
| http/html-16kx64 | 1048576 | stdx | 3.10 | 7.68 | 2.48 | 67.15 |
| http/html-1m | 1048576 | zlib | 4.66 | 9.51 | 2.04 | 172.33 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 59.78 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.35 |
| http/html-1m | 1048576 | Wuffs | 2.96 | 5.42 | 1.83 | 90.43 |
| http/html-1m | 1048576 | stdx | 1.69 | 3.67 | 2.16 | 53.11 |
| http/json-1kx1024 | 1048576 | zlib | 9.72 | 20.83 | 2.14 | 192.99 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.25 | 128.61 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.10 | 16.72 | 1.84 | 92.15 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.43 | 31.72 | 2.78 | 146.87 |
| http/json-1kx1024 | 1048576 | stdx | 9.46 | 28.05 | 2.96 | 153.05 |
| http/json-16kx64 | 1048576 | zlib | 3.94 | 9.62 | 2.44 | 101.97 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.12 |
| http/json-16kx64 | 1048576 | libdeflate | 1.93 | 4.24 | 2.20 | 40.22 |
| http/json-16kx64 | 1048576 | Wuffs | 2.81 | 6.35 | 2.26 | 58.46 |
| http/json-16kx64 | 1048576 | stdx | 2.30 | 5.89 | 2.56 | 46.47 |
| http/json-1m | 1048576 | zlib | 3.24 | 8.25 | 2.54 | 82.02 |
| http/json-1m | 1048576 | zlib-ng | 1.94 | 3.91 | 2.02 | 37.31 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.27 |
| http/json-1m | 1048576 | Wuffs | 2.05 | 4.29 | 2.10 | 44.50 |
| http/json-1m | 1048576 | stdx | 1.37 | 2.82 | 2.07 | 40.54 |
| http/js-1kx1024 | 1048576 | zlib | 17.30 | 35.33 | 2.04 | 405.06 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.76 | 31.25 | 2.27 | 236.91 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.53 | 21.58 | 1.87 | 180.09 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.81 | 37.71 | 2.38 | 299.05 |
| http/js-1kx1024 | 1048576 | stdx | 16.52 | 48.10 | 2.91 | 287.59 |
| http/js-16kx64 | 1048576 | zlib | 6.93 | 13.06 | 1.88 | 255.31 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.39 | 8.65 | 1.97 | 91.94 |
| http/js-16kx64 | 1048576 | libdeflate | 3.07 | 7.01 | 2.28 | 72.14 |
| http/js-16kx64 | 1048576 | Wuffs | 4.83 | 9.70 | 2.01 | 130.50 |
| http/js-16kx64 | 1048576 | stdx | 3.57 | 8.67 | 2.43 | 79.48 |
| http/js-1m | 1048576 | zlib | 5.15 | 10.26 | 1.99 | 194.98 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.96 | 60.20 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.81 |
| http/js-1m | 1048576 | Wuffs | 3.26 | 6.10 | 1.87 | 96.32 |
| http/js-1m | 1048576 | stdx | 1.86 | 4.10 | 2.20 | 56.19 |
| http/css-1kx1024 | 1048576 | zlib | 13.15 | 27.18 | 2.07 | 283.15 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.22 | 23.04 | 2.25 | 169.20 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.43 | 17.37 | 1.84 | 122.17 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.08 | 29.48 | 2.44 | 212.06 |
| http/css-1kx1024 | 1048576 | stdx | 13.12 | 39.50 | 3.01 | 202.22 |
| http/css-16kx64 | 1048576 | zlib | 4.66 | 10.12 | 2.17 | 150.90 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.18 | 49.91 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 28.93 |
| http/css-16kx64 | 1048576 | Wuffs | 3.12 | 6.97 | 2.24 | 70.41 |
| http/css-16kx64 | 1048576 | stdx | 2.24 | 6.24 | 2.78 | 34.85 |
| http/css-1m | 1048576 | zlib | 3.37 | 8.00 | 2.37 | 106.81 |
| http/css-1m | 1048576 | zlib-ng | 1.70 | 3.75 | 2.21 | 29.36 |
| http/css-1m | 1048576 | libdeflate | 1.05 | 3.18 | 3.04 | 10.50 |
| http/css-1m | 1048576 | Wuffs | 1.91 | 4.08 | 2.14 | 44.85 |
| http/css-1m | 1048576 | stdx | 1.04 | 2.69 | 2.58 | 21.75 |
| shuffled/dickens-1m | 1048576 | zlib | 12.76 | 22.42 | 1.76 | 375.66 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.71 | 16.72 | 1.72 | 198.67 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.07 | 14.95 | 2.11 | 195.83 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.63 | 18.95 | 1.97 | 201.55 |
| shuffled/dickens-1m | 1048576 | stdx | 7.28 | 12.73 | 1.75 | 211.79 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.52 | 14.04 | 3.99 | 3.50 |
| silesia/dickens | 10192446 | stdx | 3.68 | 12.47 | 3.39 | 3.45 |
| silesia/mozilla | 51220480 | libzstd | 2.79 | 9.62 | 3.44 | 30.16 |
| silesia/mozilla | 51220480 | stdx | 2.71 | 9.68 | 3.57 | 15.53 |
| silesia/mr | 9970564 | libzstd | 3.00 | 11.98 | 3.99 | 6.20 |
| silesia/mr | 9970564 | stdx | 3.06 | 10.83 | 3.54 | 5.22 |
| silesia/nci | 33553445 | libzstd | 1.57 | 4.84 | 3.08 | 23.61 |
| silesia/nci | 33553445 | stdx | 1.57 | 4.63 | 2.95 | 13.47 |
| silesia/ooffice | 6152192 | libzstd | 3.38 | 12.14 | 3.59 | 31.26 |
| silesia/ooffice | 6152192 | stdx | 3.30 | 12.40 | 3.75 | 12.15 |
| silesia/osdb | 10085684 | libzstd | 2.31 | 8.44 | 3.65 | 15.29 |
| silesia/osdb | 10085684 | stdx | 2.35 | 8.11 | 3.45 | 15.57 |
| silesia/reymont | 6627202 | libzstd | 3.12 | 11.61 | 3.72 | 11.58 |
| silesia/reymont | 6627202 | stdx | 3.26 | 10.36 | 3.17 | 12.77 |
| silesia/samba | 21606400 | libzstd | 2.02 | 7.39 | 3.67 | 18.74 |
| silesia/samba | 21606400 | stdx | 2.08 | 6.83 | 3.28 | 17.63 |
| silesia/sao | 7251944 | libzstd | 3.76 | 12.69 | 3.38 | 26.67 |
| silesia/sao | 7251944 | stdx | 3.45 | 12.58 | 3.64 | 6.09 |
| silesia/webster | 41458703 | libzstd | 3.07 | 11.22 | 3.65 | 16.24 |
| silesia/webster | 41458703 | stdx | 3.19 | 10.05 | 3.15 | 17.52 |
| silesia/x-ray | 8474240 | libzstd | 3.94 | 14.93 | 3.79 | 18.81 |
| silesia/x-ray | 8474240 | stdx | 3.54 | 13.23 | 3.74 | 8.49 |
| silesia/xml | 5345280 | libzstd | 1.53 | 5.55 | 3.62 | 22.97 |
| silesia/xml | 5345280 | stdx | 1.51 | 5.16 | 3.42 | 17.08 |
| canterbury/alice29.txt | 152089 | libzstd | 3.38 | 16.18 | 4.79 | 4.17 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.36 | 0.40 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.01 | 14.25 | 4.73 | 3.30 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.30 | 0.25 |
| canterbury/cp.html | 24603 | libzstd | 2.68 | 10.74 | 4.01 | 9.16 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.11 | 0.18 |
| canterbury/fields.c | 11150 | libzstd | 3.13 | 13.61 | 4.35 | 9.79 |
| canterbury/fields.c | 11150 | stdx | 3.03 | 12.72 | 4.21 | 0.09 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.25 | 16.93 | 3.99 | 7.31 |
| canterbury/grammar.lsp | 3721 | stdx | 4.18 | 16.53 | 3.95 | 0.50 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.49 | 11.22 | 4.50 | 7.68 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.24 | 0.85 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.74 | 12.87 | 4.69 | 5.25 |
| canterbury/lcet10.txt | 426754 | stdx | 2.71 | 11.52 | 4.26 | 2.42 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.18 | 15.14 | 4.76 | 1.57 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.15 | 13.51 | 4.28 | 0.81 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.50 | 3.11 | 24.47 |
| canterbury/ptt5 | 513216 | stdx | 1.33 | 4.46 | 3.35 | 13.59 |
| canterbury/sum | 38240 | libzstd | 2.67 | 10.51 | 3.94 | 11.10 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.27 |
| canterbury/xargs.1 | 4227 | libzstd | 4.29 | 17.40 | 4.06 | 10.11 |
| canterbury/xargs.1 | 4227 | stdx | 4.27 | 17.16 | 4.02 | 0.40 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.02 | 13.63 | 4.51 | 2.22 |
| canterbury-large/E.coli | 4638690 | stdx | 3.09 | 12.04 | 3.90 | 2.83 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.96 | 11.99 | 4.05 | 8.49 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.04 | 10.64 | 3.50 | 9.35 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.52 | 9.59 | 3.80 | 19.94 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.61 | 8.64 | 3.31 | 21.18 |
| http/html-1kx1024 | 1048576 | libzstd | 7.41 | 21.63 | 2.92 | 63.26 |
| http/html-1kx1024 | 1048576 | stdx | 7.54 | 22.43 | 2.97 | 76.35 |
| http/html-16kx64 | 1048576 | libzstd | 2.67 | 10.15 | 3.80 | 28.83 |
| http/html-16kx64 | 1048576 | stdx | 2.68 | 9.61 | 3.59 | 31.03 |
| http/html-1m | 1048576 | libzstd | 2.00 | 7.86 | 3.94 | 24.34 |
| http/html-1m | 1048576 | stdx | 1.99 | 7.12 | 3.57 | 25.24 |
| http/json-1kx1024 | 1048576 | libzstd | 6.38 | 17.37 | 2.72 | 49.33 |
| http/json-1kx1024 | 1048576 | stdx | 6.24 | 17.84 | 2.86 | 53.57 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.22 | 3.52 | 27.90 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.57 | 19.89 |
| http/json-1m | 1048576 | libzstd | 1.72 | 6.04 | 3.51 | 27.61 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.63 | 14.55 |
| http/js-1kx1024 | 1048576 | libzstd | 8.45 | 26.38 | 3.12 | 73.60 |
| http/js-1kx1024 | 1048576 | stdx | 9.14 | 27.57 | 3.02 | 112.62 |
| http/js-16kx64 | 1048576 | libzstd | 2.94 | 11.71 | 3.99 | 24.55 |
| http/js-16kx64 | 1048576 | stdx | 2.95 | 11.06 | 3.74 | 25.54 |
| http/js-1m | 1048576 | libzstd | 2.02 | 8.18 | 4.04 | 20.40 |
| http/js-1m | 1048576 | stdx | 2.06 | 7.48 | 3.63 | 21.89 |
| http/css-1kx1024 | 1048576 | libzstd | 7.04 | 19.70 | 2.80 | 54.04 |
| http/css-1kx1024 | 1048576 | stdx | 6.89 | 19.93 | 2.89 | 63.54 |
| http/css-16kx64 | 1048576 | libzstd | 2.25 | 8.69 | 3.87 | 23.76 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.70 | 21.74 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.57 | 3.87 | 5.50 |
| http/css-1m | 1048576 | stdx | 0.70 | 2.49 | 3.55 | 4.03 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.80 | 9.40 | 3.35 | 28.77 |
| shuffled/dickens-1m | 1048576 | stdx | 2.73 | 9.19 | 3.37 | 12.82 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.54 | 17.04 | 2.26 | 102.21 |
| silesia/dickens | 1048576 | stdx | 5.09 | 12.38 | 2.43 | 54.50 |
| silesia/mozilla | 1048576 | Google | 13.57 | 27.77 | 2.05 | 46.80 |
| silesia/mozilla | 1048576 | stdx | 8.33 | 15.02 | 1.80 | 47.66 |
| silesia/mr | 1048576 | Google | 8.92 | 20.24 | 2.27 | 102.39 |
| silesia/mr | 1048576 | stdx | 5.78 | 13.25 | 2.29 | 88.01 |
| silesia/nci | 1048576 | Google | 2.56 | 5.69 | 2.22 | 52.47 |
| silesia/nci | 1048576 | stdx | 1.94 | 3.95 | 2.04 | 55.08 |
| silesia/ooffice | 1048576 | Google | 14.25 | 29.28 | 2.05 | 288.00 |
| silesia/ooffice | 1048576 | stdx | 10.90 | 20.33 | 1.87 | 322.48 |
| silesia/osdb | 1048576 | Google | 8.25 | 17.38 | 2.11 | 95.95 |
| silesia/osdb | 1048576 | stdx | 5.17 | 10.57 | 2.05 | 92.24 |
| silesia/reymont | 1048576 | Google | 5.45 | 12.73 | 2.33 | 81.99 |
| silesia/reymont | 1048576 | stdx | 3.73 | 9.25 | 2.48 | 47.56 |
| silesia/samba | 1048576 | Google | 7.59 | 16.22 | 2.14 | 96.85 |
| silesia/samba | 1048576 | stdx | 5.06 | 10.71 | 2.12 | 67.15 |
| silesia/sao | 1048576 | Google | 16.83 | 36.97 | 2.20 | 162.47 |
| silesia/sao | 1048576 | stdx | 10.40 | 22.65 | 2.18 | 141.91 |
| silesia/webster | 1048576 | Google | 6.58 | 14.07 | 2.14 | 115.66 |
| silesia/webster | 1048576 | stdx | 4.44 | 9.98 | 2.25 | 70.12 |
| silesia/x-ray | 1048576 | Google | 19.92 | 38.46 | 1.93 | 234.13 |
| silesia/x-ray | 1048576 | stdx | 14.77 | 30.18 | 2.04 | 234.59 |
| silesia/xml | 1048576 | Google | 3.47 | 7.65 | 2.20 | 66.32 |
| silesia/xml | 1048576 | stdx | 2.40 | 5.40 | 2.25 | 46.86 |
| canterbury/alice29.txt | 152089 | Google | 8.97 | 20.66 | 2.30 | 137.36 |
| canterbury/alice29.txt | 152089 | stdx | 6.11 | 15.33 | 2.51 | 84.79 |
| canterbury/asyoulik.txt | 125179 | Google | 10.43 | 23.83 | 2.29 | 171.57 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.10 | 17.43 | 2.45 | 107.37 |
| canterbury/cp.html | 24603 | Google | 9.12 | 22.18 | 2.43 | 112.05 |
| canterbury/cp.html | 24603 | stdx | 5.55 | 17.15 | 3.09 | 22.42 |
| canterbury/fields.c | 11150 | Google | 7.15 | 21.25 | 2.97 | 26.89 |
| canterbury/fields.c | 11150 | stdx | 4.87 | 17.08 | 3.51 | 1.85 |
| canterbury/grammar.lsp | 3721 | Google | 9.83 | 30.23 | 3.07 | 5.66 |
| canterbury/grammar.lsp | 3721 | stdx | 7.15 | 25.04 | 3.50 | 0.45 |
| canterbury/kennedy.xls | 1029744 | Google | 5.49 | 17.05 | 3.10 | 37.22 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.81 | 12.94 | 3.40 | 34.07 |
| canterbury/lcet10.txt | 426754 | Google | 7.76 | 17.42 | 2.24 | 131.24 |
| canterbury/lcet10.txt | 426754 | stdx | 5.20 | 12.96 | 2.49 | 66.17 |
| canterbury/plrabn12.txt | 481861 | Google | 9.10 | 20.94 | 2.30 | 135.36 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.15 | 15.04 | 2.45 | 87.54 |
| canterbury/ptt5 | 513216 | Google | 4.29 | 10.36 | 2.42 | 62.33 |
| canterbury/ptt5 | 513216 | stdx | 2.36 | 4.89 | 2.07 | 65.00 |
| canterbury/sum | 38240 | Google | 10.80 | 26.44 | 2.45 | 156.48 |
| canterbury/sum | 38240 | stdx | 8.24 | 21.11 | 2.56 | 150.02 |
| canterbury/xargs.1 | 4227 | Google | 10.95 | 34.81 | 3.18 | 10.99 |
| canterbury/xargs.1 | 4227 | stdx | 8.50 | 30.44 | 3.58 | 7.59 |
| canterbury-large/E.coli | 1048576 | Google | 7.47 | 19.44 | 2.60 | 1.30 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.44 |
| canterbury-large/bible.txt | 1048576 | Google | 5.37 | 12.38 | 2.31 | 81.50 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.56 | 8.93 | 2.51 | 39.86 |
| canterbury-large/world192.txt | 1048576 | Google | 6.23 | 12.88 | 2.07 | 115.99 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.42 | 9.38 | 2.12 | 77.44 |
| http/html-1kx1024 | 1048576 | Google | 17.95 | 42.09 | 2.34 | 389.35 |
| http/html-1kx1024 | 1048576 | stdx | 15.24 | 37.56 | 2.46 | 360.70 |
| http/html-16kx64 | 1048576 | Google | 6.74 | 14.88 | 2.21 | 150.76 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.54 |
| http/html-1m | 1048576 | Google | 4.06 | 8.99 | 2.21 | 84.06 |
| http/html-1m | 1048576 | stdx | 2.86 | 6.52 | 2.28 | 54.54 |
| http/json-1kx1024 | 1048576 | Google | 14.31 | 36.74 | 2.57 | 239.62 |
| http/json-1kx1024 | 1048576 | stdx | 12.93 | 33.63 | 2.60 | 275.67 |
| http/json-16kx64 | 1048576 | Google | 4.42 | 11.42 | 2.58 | 82.08 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.67 |
| http/json-1m | 1048576 | Google | 3.41 | 8.66 | 2.54 | 59.63 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.44 | 57.93 |
| http/js-1kx1024 | 1048576 | Google | 19.85 | 46.38 | 2.34 | 430.12 |
| http/js-1kx1024 | 1048576 | stdx | 16.33 | 39.90 | 2.44 | 378.05 |
| http/js-16kx64 | 1048576 | Google | 8.05 | 17.79 | 2.21 | 168.78 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.43 |
| http/js-1m | 1048576 | Google | 4.38 | 9.60 | 2.20 | 83.61 |
| http/js-1m | 1048576 | stdx | 3.16 | 7.25 | 2.29 | 55.90 |
| http/css-1kx1024 | 1048576 | Google | 15.36 | 37.48 | 2.44 | 292.84 |
| http/css-1kx1024 | 1048576 | stdx | 13.78 | 34.70 | 2.52 | 302.11 |
| http/css-16kx64 | 1048576 | Google | 4.96 | 11.78 | 2.38 | 101.83 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.49 | 80.77 |
| http/css-1m | 1048576 | Google | 2.43 | 9.43 | 3.88 | 16.72 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.47 | 12.18 |
| shuffled/dickens-1m | 1048576 | Google | 9.68 | 20.34 | 2.10 | 109.15 |
| shuffled/dickens-1m | 1048576 | stdx | 8.80 | 14.53 | 1.65 | 121.12 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.2 | 74.0 | 0.117 | 2.98 | 2.93 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 70.6 | 238.3 | 0.105 | 8.33 | 3.38 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 264.9 | 1119.2 | 0.845 | 31.30 | 4.22 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 31.1 | 109.0 | 0.100 | 3.68 | 3.50 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.9 | 107.1 | 0.295 | 3.30 | 3.84 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.9 | 378.2 | 0.397 | 11.33 | 3.94 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 26.8 | 89.6 | 0.004 | 3.94 | 3.34 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 70.9 | 249.9 | 0.042 | 10.43 | 3.53 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 225.0 | 880.2 | 0.934 | 33.11 | 3.91 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 29.6 | 108.7 | 0.029 | 4.35 | 3.68 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 27.9 | 106.7 | 0.049 | 4.11 | 3.82 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 94.6 | 345.9 | 0.465 | 13.92 | 3.66 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 115017.9 | 402837.2 | 470.227 | 0.67 | 3.50 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 622181.8 | 2684141.2 | 1343.113 | 3.61 | 4.31 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3819697.0 | 20639255.2 | 2975.928 | 22.14 | 5.40 |
| string: silesia/dickens | 1 | 172528 | simdjson | 329329.9 | 656791.2 | 506.825 | 1.91 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 230576.2 | 848188.2 | 2642.608 | 1.34 | 3.68 |
| string: silesia/dickens | 1 | 172528 | std.json | 1675810.1 | 4595563.2 | 42857.196 | 9.71 | 2.74 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 3345427.6 | 7739137.6 | 3031.143 | 2.81 | 2.31 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 15123710.5 | 60619385.6 | 59058.714 | 12.71 | 4.01 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 31275834.6 | 148769682.6 | 159192.857 | 26.28 | 4.76 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4706926.9 | 7294566.6 | 582.000 | 3.95 | 1.55 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1777171.1 | 7470807.6 | 14164.571 | 1.49 | 4.20 |
| string: http/json-1m | 1 | 1190272 | std.json | 10737389.9 | 47253785.6 | 30876.000 | 9.02 | 4.40 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2052364.1 | 5764560.8 | 4139.500 | 1.09 | 2.81 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6509222.8 | 24133030.8 | 12608.125 | 3.46 | 3.71 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 51589959.8 | 252608919.8 | 286850.625 | 27.40 | 4.90 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3795795.5 | 8269494.8 | 1969.375 | 2.02 | 2.18 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7146324.4 | 12512113.8 | 278880.250 | 3.80 | 1.75 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17799189.1 | 63922930.8 | 235861.125 | 9.45 | 3.59 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12823904.3 | 42527362.3 | 246786.000 | 2.53 | 3.32 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 173062755.3 | 732363048.3 | 388479.667 | 34.10 | 4.23 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 164308211.0 | 708654908.3 | 420789.000 | 32.37 | 4.31 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 27668561.0 | 63138667.3 | 18216.667 | 5.45 | 2.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 13652161.3 | 45451415.3 | 458692.000 | 2.69 | 3.33 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 78140826.0 | 314355510.3 | 462762.000 | 15.40 | 4.02 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 195348.9 | 688807.7 | 5.484 | 0.37 | 3.53 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 194866.9 | 689029.7 | 10.323 | 0.37 | 3.54 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 11065775.5 | 60818249.7 | 9.065 | 21.11 | 5.50 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 552807.8 | 1483247.7 | 5.419 | 1.05 | 2.68 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 545835.2 | 2261447.7 | 7.484 | 1.04 | 4.14 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3655149.3 | 12808414.7 | 80601.839 | 6.97 | 3.50 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 26.8 | 113.7 | 0.156 | 3.17 | 4.24 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 73.0 | 342.1 | 0.197 | 8.62 | 4.69 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 220.0 | 1092.4 | 0.862 | 25.99 | 4.97 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 24.0 | 101.9 | 0.159 | 2.84 | 4.25 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 24.6 | 102.1 | 0.191 | 2.90 | 4.15 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.0 | 105.4 | 0.247 | 3.19 | 3.90 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 68.0 | 310.3 | 0.360 | 8.03 | 4.56 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 24.5 | 110.3 | 0.037 | 3.61 | 4.50 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.9 | 324.0 | 0.060 | 10.14 | 4.70 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 172.1 | 790.0 | 1.169 | 25.33 | 4.59 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 22.2 | 100.3 | 0.040 | 3.26 | 4.52 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 22.1 | 100.1 | 0.036 | 3.26 | 4.52 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.0 | 117.7 | 0.032 | 4.12 | 4.21 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 60.0 | 270.9 | 0.250 | 8.83 | 4.51 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 120958.2 | 464395.2 | 451.505 | 0.70 | 3.84 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 524546.9 | 2182153.2 | 1282.629 | 3.04 | 4.16 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3416503.8 | 18380954.2 | 2950.010 | 19.80 | 5.38 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 125553.5 | 460562.2 | 755.567 | 0.73 | 3.67 |
| string: silesia/dickens | 1 | 172528 | simdjson | 212155.9 | 687839.2 | 1131.041 | 1.23 | 3.24 |
| string: silesia/dickens | 1 | 172528 | yyjson | 216655.2 | 848559.2 | 1596.670 | 1.26 | 3.92 |
| string: silesia/dickens | 1 | 172528 | std.json | 1356431.1 | 2890187.2 | 53226.515 | 7.86 | 2.13 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 3435191.9 | 8766171.6 | 2598.643 | 2.89 | 2.55 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 10054867.0 | 44158803.6 | 21548.643 | 8.45 | 4.39 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 26389972.5 | 124535257.6 | 138910.500 | 22.17 | 4.72 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 3427166.1 | 8990929.6 | 3470.143 | 2.88 | 2.62 |
| string: http/json-1m | 1 | 1190272 | simdjson | 3539260.6 | 10817573.6 | 4288.214 | 2.97 | 3.06 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2441182.8 | 11226214.6 | 9744.214 | 2.05 | 4.60 |
| string: http/json-1m | 1 | 1190272 | std.json | 8660632.9 | 42694254.6 | 14819.429 | 7.28 | 4.93 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2081213.1 | 6046661.8 | 4196.125 | 1.11 | 2.91 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6765171.8 | 23416085.8 | 12408.000 | 3.59 | 3.46 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 45927968.9 | 218527029.8 | 251892.875 | 24.39 | 4.76 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2089432.5 | 6189784.8 | 4558.750 | 1.11 | 2.96 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2650377.4 | 7334579.8 | 10169.625 | 1.41 | 2.77 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 11803891.0 | 26334410.8 | 427877.125 | 6.27 | 2.23 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20536664.4 | 57035436.8 | 560228.125 | 10.91 | 2.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 113542.9 | 426364.7 | 1.226 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 113309.5 | 426473.7 | 4.226 | 0.22 | 3.76 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 639669.9 | 3146523.7 | 4.839 | 1.22 | 4.92 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 113233.3 | 426333.7 | 3.258 | 0.22 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1225842.5 | 3932432.7 | 3.677 | 2.34 | 3.21 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1641636.7 | 5898886.7 | 7.645 | 3.13 | 3.59 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3610893.2 | 13174372.7 | 62063.613 | 6.89 | 3.65 |
