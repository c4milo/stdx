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
| Run URL | https://github.com/c4milo/stdx/actions/runs/37244999318 |
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
| silesia/dickens | 10192446 | zlib | 7.97 | 15.77 | 1.98 | 299.37 |
| silesia/dickens | 10192446 | zlib-ng | 4.90 | 10.50 | 2.14 | 68.16 |
| silesia/dickens | 10192446 | libdeflate | 3.45 | 9.56 | 2.77 | 66.10 |
| silesia/dickens | 10192446 | Wuffs | 4.87 | 10.85 | 2.22 | 96.93 |
| silesia/dickens | 10192446 | stdx | 3.01 | 7.48 | 2.48 | 76.97 |
| silesia/mozilla | 51220480 | zlib | 7.77 | 14.13 | 1.82 | 243.03 |
| silesia/mozilla | 51220480 | zlib-ng | 4.95 | 8.95 | 1.81 | 85.74 |
| silesia/mozilla | 51220480 | libdeflate | 3.48 | 7.63 | 2.19 | 71.00 |
| silesia/mozilla | 51220480 | Wuffs | 5.72 | 10.84 | 1.89 | 132.77 |
| silesia/mozilla | 51220480 | stdx | 3.82 | 6.98 | 1.83 | 92.38 |
| silesia/mr | 9970564 | zlib | 7.68 | 15.26 | 1.99 | 197.81 |
| silesia/mr | 9970564 | zlib-ng | 4.78 | 9.98 | 2.09 | 68.33 |
| silesia/mr | 9970564 | libdeflate | 3.35 | 8.58 | 2.56 | 61.28 |
| silesia/mr | 9970564 | Wuffs | 5.26 | 10.93 | 2.08 | 99.41 |
| silesia/mr | 9970564 | stdx | 3.19 | 7.18 | 2.25 | 71.34 |
| silesia/nci | 33553445 | zlib | 2.90 | 7.25 | 2.50 | 79.56 |
| silesia/nci | 33553445 | zlib-ng | 1.59 | 3.13 | 1.96 | 34.11 |
| silesia/nci | 33553445 | libdeflate | 1.12 | 2.66 | 2.38 | 27.76 |
| silesia/nci | 33553445 | Wuffs | 1.72 | 3.38 | 1.97 | 42.29 |
| silesia/nci | 33553445 | stdx | 1.23 | 2.29 | 1.86 | 37.51 |
| silesia/ooffice | 6152192 | zlib | 11.02 | 17.83 | 1.62 | 401.62 |
| silesia/ooffice | 6152192 | zlib-ng | 6.91 | 12.04 | 1.74 | 140.75 |
| silesia/ooffice | 6152192 | libdeflate | 4.91 | 10.45 | 2.13 | 125.03 |
| silesia/ooffice | 6152192 | Wuffs | 8.09 | 14.47 | 1.79 | 219.37 |
| silesia/ooffice | 6152192 | stdx | 5.34 | 9.60 | 1.80 | 155.93 |
| silesia/osdb | 10085684 | zlib | 6.77 | 13.54 | 2.00 | 170.15 |
| silesia/osdb | 10085684 | zlib-ng | 4.29 | 8.38 | 1.95 | 53.19 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.91 | 2.43 | 29.93 |
| silesia/osdb | 10085684 | Wuffs | 5.09 | 10.56 | 2.07 | 75.79 |
| silesia/osdb | 10085684 | stdx | 2.93 | 6.25 | 2.14 | 43.14 |
| silesia/reymont | 6627202 | zlib | 6.64 | 12.73 | 1.92 | 253.69 |
| silesia/reymont | 6627202 | zlib-ng | 3.73 | 7.72 | 2.07 | 60.84 |
| silesia/reymont | 6627202 | libdeflate | 2.60 | 6.91 | 2.65 | 50.97 |
| silesia/reymont | 6627202 | Wuffs | 4.24 | 8.40 | 1.98 | 112.89 |
| silesia/reymont | 6627202 | stdx | 2.35 | 5.36 | 2.28 | 65.43 |
| silesia/samba | 21606400 | zlib | 5.47 | 11.09 | 2.03 | 169.92 |
| silesia/samba | 21606400 | zlib-ng | 3.35 | 6.47 | 1.93 | 56.14 |
| silesia/samba | 21606400 | libdeflate | 2.31 | 5.58 | 2.42 | 42.87 |
| silesia/samba | 21606400 | Wuffs | 3.66 | 7.33 | 2.00 | 81.25 |
| silesia/samba | 21606400 | stdx | 2.33 | 4.77 | 2.05 | 57.47 |
| silesia/sao | 7251944 | zlib | 9.94 | 20.36 | 2.05 | 200.18 |
| silesia/sao | 7251944 | zlib-ng | 7.84 | 14.83 | 1.89 | 79.27 |
| silesia/sao | 7251944 | libdeflate | 5.74 | 12.73 | 2.22 | 79.14 |
| silesia/sao | 7251944 | Wuffs | 8.15 | 18.14 | 2.23 | 85.51 |
| silesia/sao | 7251944 | stdx | 5.93 | 11.69 | 1.97 | 93.15 |
| silesia/webster | 41458703 | zlib | 7.02 | 12.99 | 1.85 | 273.12 |
| silesia/webster | 41458703 | zlib-ng | 4.23 | 8.04 | 1.90 | 85.16 |
| silesia/webster | 41458703 | libdeflate | 2.91 | 7.17 | 2.46 | 68.47 |
| silesia/webster | 41458703 | Wuffs | 4.53 | 8.62 | 1.90 | 123.39 |
| silesia/webster | 41458703 | stdx | 2.89 | 5.86 | 2.03 | 87.89 |
| silesia/x-ray | 8474240 | zlib | 12.23 | 23.82 | 1.95 | 324.18 |
| silesia/x-ray | 8474240 | zlib-ng | 9.02 | 17.39 | 1.93 | 124.76 |
| silesia/x-ray | 8474240 | libdeflate | 6.54 | 15.26 | 2.33 | 124.33 |
| silesia/x-ray | 8474240 | Wuffs | 10.09 | 20.40 | 2.02 | 189.40 |
| silesia/x-ray | 8474240 | stdx | 6.39 | 12.46 | 1.95 | 140.73 |
| silesia/xml | 5345280 | zlib | 3.62 | 8.20 | 2.27 | 115.94 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.54 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.46 | 31.66 |
| silesia/xml | 5345280 | Wuffs | 2.20 | 4.14 | 1.88 | 61.09 |
| silesia/xml | 5345280 | stdx | 1.35 | 2.78 | 2.06 | 42.33 |
| canterbury/alice29.txt | 152089 | zlib | 7.62 | 15.08 | 1.98 | 284.93 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.53 | 9.91 | 2.19 | 60.43 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.20 | 8.96 | 2.80 | 56.17 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.72 | 10.37 | 2.20 | 99.63 |
| canterbury/alice29.txt | 152089 | stdx | 2.82 | 7.43 | 2.63 | 63.63 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.17 | 16.11 | 1.97 | 302.43 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.09 | 10.86 | 2.13 | 72.70 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.63 | 9.82 | 2.71 | 70.96 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.11 | 11.34 | 2.22 | 101.62 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.19 | 8.03 | 2.52 | 77.30 |
| canterbury/cp.html | 24603 | zlib | 6.41 | 14.20 | 2.21 | 165.18 |
| canterbury/cp.html | 24603 | zlib-ng | 4.14 | 9.50 | 2.29 | 34.33 |
| canterbury/cp.html | 24603 | libdeflate | 2.88 | 7.95 | 2.76 | 18.46 |
| canterbury/cp.html | 24603 | Wuffs | 4.48 | 10.87 | 2.43 | 56.41 |
| canterbury/cp.html | 24603 | stdx | 3.08 | 8.75 | 2.84 | 20.11 |
| canterbury/fields.c | 11150 | zlib | 4.52 | 14.65 | 3.24 | 31.14 |
| canterbury/fields.c | 11150 | zlib-ng | 3.87 | 10.20 | 2.63 | 13.56 |
| canterbury/fields.c | 11150 | libdeflate | 2.78 | 8.32 | 2.99 | 1.48 |
| canterbury/fields.c | 11150 | Wuffs | 3.85 | 11.51 | 2.99 | 9.47 |
| canterbury/fields.c | 11150 | stdx | 3.18 | 10.60 | 3.34 | 8.40 |
| canterbury/grammar.lsp | 3721 | zlib | 6.18 | 21.22 | 3.43 | 2.11 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.85 | 17.48 | 2.99 | 7.75 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.39 | 12.05 | 2.74 | 0.60 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.96 | 18.87 | 3.17 | 2.74 |
| canterbury/grammar.lsp | 3721 | stdx | 5.53 | 20.07 | 3.63 | 8.54 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.92 | 12.20 | 3.11 | 47.29 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.57 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.34 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.18 | 8.67 | 2.73 | 14.70 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.84 | 4.99 | 2.71 | 17.93 |
| canterbury/lcet10.txt | 426754 | zlib | 7.38 | 14.53 | 1.97 | 278.84 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.32 | 9.39 | 2.17 | 60.64 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.02 | 8.48 | 2.81 | 54.23 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.56 | 9.85 | 2.16 | 101.38 |
| canterbury/lcet10.txt | 426754 | stdx | 2.69 | 6.79 | 2.53 | 67.73 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.34 | 16.53 | 1.98 | 310.91 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.32 | 11.19 | 2.10 | 79.42 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.71 | 76.56 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.16 | 11.53 | 2.23 | 99.15 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.28 | 8.05 | 2.45 | 86.87 |
| canterbury/ptt5 | 513216 | zlib | 4.41 | 7.79 | 1.77 | 100.67 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.68 |
| canterbury/ptt5 | 513216 | libdeflate | 1.44 | 3.02 | 2.09 | 37.75 |
| canterbury/ptt5 | 513216 | Wuffs | 2.19 | 4.02 | 1.83 | 59.04 |
| canterbury/ptt5 | 513216 | stdx | 1.52 | 2.83 | 1.86 | 50.04 |
| canterbury/sum | 38240 | zlib | 7.24 | 14.98 | 2.07 | 211.38 |
| canterbury/sum | 38240 | zlib-ng | 4.62 | 10.02 | 2.17 | 55.48 |
| canterbury/sum | 38240 | libdeflate | 3.43 | 8.34 | 2.43 | 45.54 |
| canterbury/sum | 38240 | Wuffs | 5.08 | 11.41 | 2.25 | 80.43 |
| canterbury/sum | 38240 | stdx | 3.55 | 9.37 | 2.64 | 43.54 |
| canterbury/xargs.1 | 4227 | zlib | 6.64 | 22.08 | 3.33 | 5.48 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.39 | 17.97 | 2.81 | 8.80 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.76 | 13.27 | 2.79 | 0.93 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.48 | 19.63 | 3.03 | 8.83 |
| canterbury/xargs.1 | 4227 | stdx | 5.74 | 19.83 | 3.45 | 8.41 |
| canterbury-large/E.coli | 4638690 | zlib | 5.98 | 14.55 | 2.43 | 174.99 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.23 | 9.68 | 2.29 | 47.17 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.92 | 48.83 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.00 | 9.64 | 2.41 | 61.78 |
| canterbury-large/E.coli | 4638690 | stdx | 2.53 | 6.89 | 2.73 | 54.69 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.74 | 13.26 | 1.97 | 257.59 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.77 | 8.26 | 2.19 | 53.83 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.84 | 45.73 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.15 | 8.72 | 2.10 | 100.96 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.30 | 5.82 | 2.53 | 56.65 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.97 | 12.69 | 1.82 | 272.49 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.20 | 7.78 | 1.85 | 91.75 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.89 | 6.92 | 2.39 | 75.17 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.52 | 8.44 | 1.87 | 129.85 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.80 | 5.70 | 2.04 | 91.48 |
| http/html-1kx1024 | 1048576 | zlib | 15.81 | 32.44 | 2.05 | 350.81 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.65 | 28.43 | 2.25 | 213.53 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.56 | 20.05 | 1.90 | 156.05 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.68 | 35.05 | 2.39 | 267.76 |
| http/html-1kx1024 | 1048576 | stdx | 15.39 | 45.05 | 2.93 | 254.10 |
| http/html-16kx64 | 1048576 | zlib | 6.02 | 11.79 | 1.96 | 214.39 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 84.86 |
| http/html-16kx64 | 1048576 | libdeflate | 2.64 | 6.04 | 2.29 | 60.71 |
| http/html-16kx64 | 1048576 | Wuffs | 4.28 | 8.51 | 1.99 | 117.35 |
| http/html-16kx64 | 1048576 | stdx | 3.09 | 7.68 | 2.49 | 66.63 |
| http/html-1m | 1048576 | zlib | 4.65 | 9.51 | 2.05 | 172.21 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 59.96 |
| http/html-1m | 1048576 | libdeflate | 1.69 | 4.39 | 2.59 | 37.39 |
| http/html-1m | 1048576 | Wuffs | 2.96 | 5.42 | 1.83 | 90.50 |
| http/html-1m | 1048576 | stdx | 1.69 | 3.67 | 2.17 | 53.21 |
| http/json-1kx1024 | 1048576 | zlib | 9.72 | 20.83 | 2.14 | 193.23 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.40 | 16.69 | 2.26 | 128.39 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.83 | 16.72 | 1.89 | 91.76 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.44 | 31.72 | 2.77 | 146.65 |
| http/json-1kx1024 | 1048576 | stdx | 9.48 | 28.05 | 2.96 | 153.15 |
| http/json-16kx64 | 1048576 | zlib | 3.94 | 9.62 | 2.44 | 101.39 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.10 | 50.47 |
| http/json-16kx64 | 1048576 | libdeflate | 1.91 | 4.24 | 2.22 | 40.10 |
| http/json-16kx64 | 1048576 | Wuffs | 2.82 | 6.35 | 2.25 | 58.48 |
| http/json-16kx64 | 1048576 | stdx | 2.30 | 5.89 | 2.56 | 46.41 |
| http/json-1m | 1048576 | zlib | 3.25 | 8.25 | 2.54 | 82.20 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.03 | 37.26 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.42 | 32.28 |
| http/json-1m | 1048576 | Wuffs | 2.05 | 4.29 | 2.10 | 44.20 |
| http/json-1m | 1048576 | stdx | 1.36 | 2.82 | 2.07 | 40.43 |
| http/js-1kx1024 | 1048576 | zlib | 17.33 | 35.33 | 2.04 | 405.18 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.73 | 31.25 | 2.28 | 235.39 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.25 | 21.58 | 1.92 | 179.59 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.88 | 37.71 | 2.37 | 300.99 |
| http/js-1kx1024 | 1048576 | stdx | 16.56 | 48.10 | 2.90 | 288.37 |
| http/js-16kx64 | 1048576 | zlib | 6.92 | 13.06 | 1.89 | 254.26 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.97 | 91.57 |
| http/js-16kx64 | 1048576 | libdeflate | 3.06 | 7.01 | 2.29 | 72.31 |
| http/js-16kx64 | 1048576 | Wuffs | 4.85 | 9.70 | 2.00 | 130.82 |
| http/js-16kx64 | 1048576 | stdx | 3.57 | 8.67 | 2.43 | 79.42 |
| http/js-1m | 1048576 | zlib | 5.16 | 10.26 | 1.99 | 195.24 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.96 | 60.25 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 42.17 |
| http/js-1m | 1048576 | Wuffs | 3.26 | 6.10 | 1.87 | 96.44 |
| http/js-1m | 1048576 | stdx | 1.85 | 4.10 | 2.21 | 55.79 |
| http/css-1kx1024 | 1048576 | zlib | 13.16 | 27.18 | 2.06 | 283.63 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.22 | 23.04 | 2.25 | 168.60 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.16 | 17.37 | 1.90 | 122.44 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.10 | 29.48 | 2.44 | 211.34 |
| http/css-1kx1024 | 1048576 | stdx | 13.16 | 39.50 | 3.00 | 202.98 |
| http/css-16kx64 | 1048576 | zlib | 4.67 | 10.12 | 2.17 | 151.33 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.79 | 6.07 | 2.18 | 50.00 |
| http/css-16kx64 | 1048576 | libdeflate | 1.88 | 4.69 | 2.50 | 29.01 |
| http/css-16kx64 | 1048576 | Wuffs | 3.13 | 6.97 | 2.23 | 70.76 |
| http/css-16kx64 | 1048576 | stdx | 2.25 | 6.24 | 2.77 | 35.01 |
| http/css-1m | 1048576 | zlib | 3.37 | 8.00 | 2.37 | 107.07 |
| http/css-1m | 1048576 | zlib-ng | 1.70 | 3.75 | 2.21 | 29.60 |
| http/css-1m | 1048576 | libdeflate | 1.05 | 3.18 | 3.03 | 10.76 |
| http/css-1m | 1048576 | Wuffs | 1.91 | 4.08 | 2.14 | 44.69 |
| http/css-1m | 1048576 | stdx | 1.04 | 2.69 | 2.57 | 21.76 |
| shuffled/dickens-1m | 1048576 | zlib | 12.76 | 22.42 | 1.76 | 375.76 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.69 | 16.72 | 1.72 | 197.63 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.05 | 14.95 | 2.12 | 195.52 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.70 | 18.95 | 1.95 | 206.66 |
| shuffled/dickens-1m | 1048576 | stdx | 7.27 | 12.73 | 1.75 | 209.99 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.45 | 14.04 | 4.07 | 3.53 |
| silesia/dickens | 10192446 | stdx | 3.57 | 12.47 | 3.50 | 3.42 |
| silesia/mozilla | 51220480 | libzstd | 2.83 | 9.62 | 3.40 | 30.18 |
| silesia/mozilla | 51220480 | stdx | 2.81 | 9.68 | 3.44 | 15.59 |
| silesia/mr | 9970564 | libzstd | 2.97 | 11.98 | 4.03 | 6.25 |
| silesia/mr | 9970564 | stdx | 2.99 | 10.83 | 3.63 | 5.11 |
| silesia/nci | 33553445 | libzstd | 1.58 | 4.84 | 3.06 | 23.63 |
| silesia/nci | 33553445 | stdx | 1.59 | 4.63 | 2.91 | 13.46 |
| silesia/ooffice | 6152192 | libzstd | 3.39 | 12.14 | 3.58 | 31.29 |
| silesia/ooffice | 6152192 | stdx | 3.29 | 12.40 | 3.76 | 11.97 |
| silesia/osdb | 10085684 | libzstd | 2.31 | 8.44 | 3.65 | 15.27 |
| silesia/osdb | 10085684 | stdx | 2.36 | 8.11 | 3.44 | 15.26 |
| silesia/reymont | 6627202 | libzstd | 3.07 | 11.61 | 3.79 | 11.62 |
| silesia/reymont | 6627202 | stdx | 3.20 | 10.36 | 3.24 | 12.74 |
| silesia/samba | 21606400 | libzstd | 2.02 | 7.39 | 3.65 | 18.62 |
| silesia/samba | 21606400 | stdx | 2.08 | 6.83 | 3.28 | 17.65 |
| silesia/sao | 7251944 | libzstd | 3.80 | 12.69 | 3.34 | 26.56 |
| silesia/sao | 7251944 | stdx | 3.46 | 12.58 | 3.64 | 6.16 |
| silesia/webster | 41458703 | libzstd | 3.08 | 11.22 | 3.64 | 16.21 |
| silesia/webster | 41458703 | stdx | 3.26 | 10.05 | 3.08 | 17.59 |
| silesia/x-ray | 8474240 | libzstd | 3.96 | 14.93 | 3.76 | 18.80 |
| silesia/x-ray | 8474240 | stdx | 3.55 | 13.23 | 3.73 | 8.24 |
| silesia/xml | 5345280 | libzstd | 1.52 | 5.55 | 3.64 | 22.77 |
| silesia/xml | 5345280 | stdx | 1.50 | 5.16 | 3.45 | 17.03 |
| canterbury/alice29.txt | 152089 | libzstd | 3.36 | 16.18 | 4.82 | 4.13 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.37 | 0.38 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.00 | 14.25 | 4.75 | 3.32 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.30 | 0.17 |
| canterbury/cp.html | 24603 | libzstd | 2.68 | 10.74 | 4.01 | 9.16 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.11 | 0.16 |
| canterbury/fields.c | 11150 | libzstd | 3.14 | 13.61 | 4.34 | 9.96 |
| canterbury/fields.c | 11150 | stdx | 3.00 | 12.72 | 4.24 | 0.18 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.24 | 16.93 | 3.99 | 7.00 |
| canterbury/grammar.lsp | 3721 | stdx | 4.15 | 16.53 | 3.98 | 0.35 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.48 | 11.22 | 4.52 | 7.69 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.66 | 11.32 | 4.26 | 0.89 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.73 | 12.87 | 4.71 | 5.27 |
| canterbury/lcet10.txt | 426754 | stdx | 2.73 | 11.52 | 4.23 | 3.55 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.17 | 15.14 | 4.78 | 1.57 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.28 | 0.81 |
| canterbury/ptt5 | 513216 | libzstd | 1.44 | 4.50 | 3.12 | 24.21 |
| canterbury/ptt5 | 513216 | stdx | 1.33 | 4.46 | 3.36 | 13.13 |
| canterbury/sum | 38240 | libzstd | 2.66 | 10.51 | 3.95 | 11.16 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.25 |
| canterbury/xargs.1 | 4227 | libzstd | 4.28 | 17.40 | 4.06 | 10.26 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.16 | 4.04 | 0.39 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.00 | 13.63 | 4.55 | 2.24 |
| canterbury-large/E.coli | 4638690 | stdx | 3.06 | 12.04 | 3.93 | 2.82 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.91 | 11.99 | 4.12 | 8.54 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.00 | 10.64 | 3.55 | 9.36 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.50 | 9.59 | 3.83 | 19.75 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.58 | 8.64 | 3.35 | 21.79 |
| http/html-1kx1024 | 1048576 | libzstd | 7.43 | 21.63 | 2.91 | 63.06 |
| http/html-1kx1024 | 1048576 | stdx | 7.49 | 22.43 | 3.00 | 76.52 |
| http/html-16kx64 | 1048576 | libzstd | 2.67 | 10.15 | 3.80 | 28.81 |
| http/html-16kx64 | 1048576 | stdx | 2.67 | 9.61 | 3.60 | 30.77 |
| http/html-1m | 1048576 | libzstd | 2.00 | 7.86 | 3.94 | 24.46 |
| http/html-1m | 1048576 | stdx | 1.98 | 7.12 | 3.59 | 25.17 |
| http/json-1kx1024 | 1048576 | libzstd | 6.38 | 17.37 | 2.72 | 49.13 |
| http/json-1kx1024 | 1048576 | stdx | 6.24 | 17.84 | 2.86 | 53.33 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.22 | 3.52 | 28.13 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.59 | 19.71 |
| http/json-1m | 1048576 | libzstd | 1.72 | 6.04 | 3.51 | 27.76 |
| http/json-1m | 1048576 | stdx | 1.62 | 5.91 | 3.64 | 14.65 |
| http/js-1kx1024 | 1048576 | libzstd | 8.45 | 26.38 | 3.12 | 73.31 |
| http/js-1kx1024 | 1048576 | stdx | 9.07 | 27.57 | 3.04 | 112.87 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.71 | 3.99 | 24.51 |
| http/js-16kx64 | 1048576 | stdx | 2.95 | 11.06 | 3.75 | 25.53 |
| http/js-1m | 1048576 | libzstd | 2.01 | 8.18 | 4.07 | 20.40 |
| http/js-1m | 1048576 | stdx | 2.07 | 7.48 | 3.62 | 21.80 |
| http/css-1kx1024 | 1048576 | libzstd | 7.03 | 19.70 | 2.80 | 53.72 |
| http/css-1kx1024 | 1048576 | stdx | 6.86 | 19.93 | 2.90 | 63.57 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.69 | 3.88 | 23.34 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 21.84 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.57 | 3.88 | 5.56 |
| http/css-1m | 1048576 | stdx | 0.72 | 2.49 | 3.49 | 4.52 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.80 | 9.40 | 3.36 | 28.61 |
| shuffled/dickens-1m | 1048576 | stdx | 2.73 | 9.19 | 3.37 | 12.58 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.51 | 17.04 | 2.27 | 102.17 |
| silesia/dickens | 1048576 | stdx | 5.05 | 12.38 | 2.45 | 54.56 |
| silesia/mozilla | 1048576 | Google | 13.57 | 27.77 | 2.05 | 46.64 |
| silesia/mozilla | 1048576 | stdx | 8.31 | 15.02 | 1.81 | 47.34 |
| silesia/mr | 1048576 | Google | 8.95 | 20.24 | 2.26 | 102.55 |
| silesia/mr | 1048576 | stdx | 5.77 | 13.25 | 2.30 | 88.29 |
| silesia/nci | 1048576 | Google | 2.57 | 5.69 | 2.21 | 52.45 |
| silesia/nci | 1048576 | stdx | 1.93 | 3.95 | 2.05 | 55.05 |
| silesia/ooffice | 1048576 | Google | 14.26 | 29.28 | 2.05 | 287.57 |
| silesia/ooffice | 1048576 | stdx | 10.89 | 20.33 | 1.87 | 324.88 |
| silesia/osdb | 1048576 | Google | 8.27 | 17.38 | 2.10 | 96.22 |
| silesia/osdb | 1048576 | stdx | 5.13 | 10.57 | 2.06 | 92.40 |
| silesia/reymont | 1048576 | Google | 5.47 | 12.73 | 2.33 | 81.85 |
| silesia/reymont | 1048576 | stdx | 3.71 | 9.25 | 2.50 | 47.68 |
| silesia/samba | 1048576 | Google | 7.58 | 16.22 | 2.14 | 96.54 |
| silesia/samba | 1048576 | stdx | 5.04 | 10.71 | 2.12 | 66.87 |
| silesia/sao | 1048576 | Google | 16.84 | 36.97 | 2.20 | 162.75 |
| silesia/sao | 1048576 | stdx | 10.40 | 22.65 | 2.18 | 141.36 |
| silesia/webster | 1048576 | Google | 6.58 | 14.07 | 2.14 | 115.51 |
| silesia/webster | 1048576 | stdx | 4.35 | 9.98 | 2.30 | 68.53 |
| silesia/x-ray | 1048576 | Google | 19.64 | 38.46 | 1.96 | 234.59 |
| silesia/x-ray | 1048576 | stdx | 14.50 | 30.18 | 2.08 | 235.66 |
| silesia/xml | 1048576 | Google | 3.46 | 7.65 | 2.21 | 66.06 |
| silesia/xml | 1048576 | stdx | 2.41 | 5.40 | 2.24 | 47.02 |
| canterbury/alice29.txt | 152089 | Google | 8.94 | 20.66 | 2.31 | 137.65 |
| canterbury/alice29.txt | 152089 | stdx | 6.06 | 15.33 | 2.53 | 80.43 |
| canterbury/asyoulik.txt | 125179 | Google | 10.42 | 23.83 | 2.29 | 172.16 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.07 | 17.43 | 2.47 | 104.69 |
| canterbury/cp.html | 24603 | Google | 9.16 | 22.18 | 2.42 | 115.27 |
| canterbury/cp.html | 24603 | stdx | 5.62 | 17.15 | 3.05 | 25.86 |
| canterbury/fields.c | 11150 | Google | 7.14 | 21.25 | 2.98 | 27.07 |
| canterbury/fields.c | 11150 | stdx | 4.85 | 17.08 | 3.52 | 1.66 |
| canterbury/grammar.lsp | 3721 | Google | 9.88 | 30.23 | 3.06 | 8.89 |
| canterbury/grammar.lsp | 3721 | stdx | 7.15 | 25.04 | 3.50 | 0.41 |
| canterbury/kennedy.xls | 1029744 | Google | 5.49 | 17.05 | 3.11 | 37.29 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.82 | 12.94 | 3.38 | 34.19 |
| canterbury/lcet10.txt | 426754 | Google | 7.79 | 17.42 | 2.24 | 131.32 |
| canterbury/lcet10.txt | 426754 | stdx | 5.18 | 12.96 | 2.50 | 65.68 |
| canterbury/plrabn12.txt | 481861 | Google | 9.11 | 20.94 | 2.30 | 134.88 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.13 | 15.04 | 2.45 | 87.61 |
| canterbury/ptt5 | 513216 | Google | 4.28 | 10.36 | 2.42 | 62.36 |
| canterbury/ptt5 | 513216 | stdx | 2.38 | 4.89 | 2.05 | 66.24 |
| canterbury/sum | 38240 | Google | 10.83 | 26.44 | 2.44 | 158.03 |
| canterbury/sum | 38240 | stdx | 8.30 | 21.11 | 2.54 | 149.92 |
| canterbury/xargs.1 | 4227 | Google | 10.99 | 34.81 | 3.17 | 12.42 |
| canterbury/xargs.1 | 4227 | stdx | 8.50 | 30.44 | 3.58 | 6.87 |
| canterbury-large/E.coli | 1048576 | Google | 7.48 | 19.44 | 2.60 | 1.41 |
| canterbury-large/E.coli | 1048576 | stdx | 6.72 | 13.48 | 2.01 | 2.22 |
| canterbury-large/bible.txt | 1048576 | Google | 5.36 | 12.38 | 2.31 | 81.53 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.52 | 8.93 | 2.54 | 39.86 |
| canterbury-large/world192.txt | 1048576 | Google | 6.23 | 12.88 | 2.07 | 116.02 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.36 | 9.38 | 2.15 | 76.98 |
| http/html-1kx1024 | 1048576 | Google | 17.93 | 42.09 | 2.35 | 389.29 |
| http/html-1kx1024 | 1048576 | stdx | 15.23 | 37.56 | 2.47 | 359.06 |
| http/html-16kx64 | 1048576 | Google | 6.75 | 14.88 | 2.20 | 151.08 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.92 |
| http/html-1m | 1048576 | Google | 4.07 | 8.99 | 2.21 | 84.03 |
| http/html-1m | 1048576 | stdx | 2.85 | 6.52 | 2.29 | 54.89 |
| http/json-1kx1024 | 1048576 | Google | 14.28 | 36.74 | 2.57 | 239.70 |
| http/json-1kx1024 | 1048576 | stdx | 12.94 | 33.63 | 2.60 | 275.40 |
| http/json-16kx64 | 1048576 | Google | 4.41 | 11.42 | 2.59 | 82.02 |
| http/json-16kx64 | 1048576 | stdx | 3.38 | 8.42 | 2.49 | 83.80 |
| http/json-1m | 1048576 | Google | 3.42 | 8.66 | 2.53 | 59.71 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.44 | 57.63 |
| http/js-1kx1024 | 1048576 | Google | 19.81 | 46.38 | 2.34 | 429.51 |
| http/js-1kx1024 | 1048576 | stdx | 16.33 | 39.90 | 2.44 | 377.48 |
| http/js-16kx64 | 1048576 | Google | 8.05 | 17.79 | 2.21 | 168.18 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.13 |
| http/js-1m | 1048576 | Google | 4.38 | 9.60 | 2.19 | 83.59 |
| http/js-1m | 1048576 | stdx | 3.15 | 7.25 | 2.30 | 55.63 |
| http/css-1kx1024 | 1048576 | Google | 15.34 | 37.48 | 2.44 | 293.04 |
| http/css-1kx1024 | 1048576 | stdx | 13.77 | 34.70 | 2.52 | 300.91 |
| http/css-16kx64 | 1048576 | Google | 4.96 | 11.78 | 2.38 | 101.87 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.55 |
| http/css-1m | 1048576 | Google | 2.43 | 9.43 | 3.88 | 16.84 |
| http/css-1m | 1048576 | stdx | 0.76 | 1.86 | 2.46 | 12.33 |
| shuffled/dickens-1m | 1048576 | Google | 9.66 | 20.34 | 2.11 | 108.52 |
| shuffled/dickens-1m | 1048576 | stdx | 8.75 | 14.53 | 1.66 | 114.90 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.5 | 74.3 | 0.117 | 3.01 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 69.0 | 238.3 | 0.104 | 8.16 | 3.45 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 259.4 | 1119.2 | 0.821 | 30.64 | 4.32 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 31.4 | 109.0 | 0.101 | 3.71 | 3.47 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 28.2 | 107.1 | 0.298 | 3.34 | 3.79 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.5 | 378.2 | 0.384 | 11.28 | 3.96 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 26.9 | 89.6 | 0.004 | 3.97 | 3.33 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 69.5 | 249.9 | 0.043 | 10.23 | 3.60 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 223.3 | 880.2 | 0.927 | 32.87 | 3.94 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 29.7 | 108.7 | 0.029 | 4.37 | 3.66 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.1 | 106.7 | 0.049 | 4.29 | 3.66 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 93.5 | 345.9 | 0.338 | 13.76 | 3.70 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114732.4 | 403839.2 | 518.021 | 0.67 | 3.52 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 612812.5 | 2684141.2 | 1340.505 | 3.55 | 4.38 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3893367.4 | 20639255.2 | 2982.309 | 22.57 | 5.30 |
| string: silesia/dickens | 1 | 172528 | simdjson | 329387.3 | 656791.2 | 497.804 | 1.91 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 230878.8 | 848188.2 | 2669.485 | 1.34 | 3.67 |
| string: silesia/dickens | 1 | 172528 | std.json | 1588305.5 | 4595563.2 | 44791.485 | 9.21 | 2.89 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1566387.4 | 4799762.6 | 1440.071 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 15060854.4 | 60619385.6 | 59017.000 | 12.65 | 4.02 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 31905894.4 | 148769682.6 | 157997.643 | 26.81 | 4.66 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4719271.3 | 7294566.6 | 537.786 | 3.96 | 1.55 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1801337.9 | 7470807.6 | 14854.500 | 1.51 | 4.15 |
| string: http/json-1m | 1 | 1190272 | std.json | 10091021.1 | 47253785.6 | 30516.786 | 8.48 | 4.68 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2064652.9 | 5765412.8 | 4266.000 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6485481.8 | 24133030.8 | 12603.375 | 3.44 | 3.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 52083113.3 | 252608919.8 | 288787.375 | 27.66 | 4.85 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3804053.5 | 8269494.8 | 2060.250 | 2.02 | 2.17 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7178306.4 | 12512113.8 | 279092.625 | 3.81 | 1.74 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17505407.8 | 63922930.8 | 224639.875 | 9.30 | 3.65 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12913115.0 | 42561068.3 | 244513.333 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 161392215.0 | 732363048.3 | 388717.000 | 31.80 | 4.54 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 163884485.0 | 708654908.3 | 422439.333 | 32.29 | 4.32 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 27698821.0 | 63138667.3 | 18181.667 | 5.46 | 2.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 13938925.0 | 45451415.3 | 462790.667 | 2.75 | 3.26 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79250172.0 | 314355510.3 | 452660.667 | 15.61 | 3.97 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 189032.6 | 688807.7 | 5.226 | 0.36 | 3.64 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 189237.0 | 689029.7 | 8.710 | 0.36 | 3.64 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 11164494.8 | 60818249.7 | 3.548 | 21.29 | 5.45 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 552967.3 | 1483247.7 | 6.097 | 1.05 | 2.68 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 541937.8 | 2261447.7 | 5.129 | 1.03 | 4.17 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3506913.6 | 12808414.7 | 63102.194 | 6.69 | 3.65 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 27.3 | 113.7 | 0.156 | 3.23 | 4.16 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 73.2 | 342.1 | 0.195 | 8.65 | 4.67 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 223.8 | 1092.4 | 0.859 | 26.44 | 4.88 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 23.8 | 101.9 | 0.152 | 2.81 | 4.29 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 25.0 | 102.1 | 0.192 | 2.96 | 4.08 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.1 | 105.4 | 0.249 | 3.20 | 3.89 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 68.3 | 310.3 | 0.370 | 8.07 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 24.9 | 110.3 | 0.037 | 3.66 | 4.43 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.9 | 324.0 | 0.066 | 10.14 | 4.70 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 171.0 | 790.0 | 1.100 | 25.17 | 4.62 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 22.1 | 100.3 | 0.038 | 3.25 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 22.2 | 100.1 | 0.036 | 3.27 | 4.51 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.2 | 117.7 | 0.033 | 4.15 | 4.18 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 59.5 | 270.9 | 0.283 | 8.75 | 4.56 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 120911.8 | 464395.2 | 457.619 | 0.70 | 3.84 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 517859.5 | 2182153.2 | 1216.412 | 3.00 | 4.21 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3432107.5 | 18380954.2 | 2951.876 | 19.89 | 5.36 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 125648.6 | 460562.2 | 755.495 | 0.73 | 3.67 |
| string: silesia/dickens | 1 | 172528 | simdjson | 212142.1 | 687839.2 | 1126.680 | 1.23 | 3.24 |
| string: silesia/dickens | 1 | 172528 | yyjson | 216879.5 | 848559.2 | 1639.412 | 1.26 | 3.91 |
| string: silesia/dickens | 1 | 172528 | std.json | 1370739.1 | 2890187.2 | 54682.258 | 7.95 | 2.11 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 3435443.4 | 8766171.6 | 2599.714 | 2.89 | 2.55 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 10018658.2 | 44158803.6 | 20722.571 | 8.42 | 4.41 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 26509548.4 | 124535257.6 | 138727.714 | 22.27 | 4.70 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 3422996.9 | 8990929.6 | 3177.857 | 2.88 | 2.63 |
| string: http/json-1m | 1 | 1190272 | simdjson | 3544452.4 | 10817573.6 | 4554.643 | 2.98 | 3.05 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2445586.6 | 11226214.6 | 9872.786 | 2.05 | 4.59 |
| string: http/json-1m | 1 | 1190272 | std.json | 8730684.0 | 42694254.6 | 15429.286 | 7.34 | 4.89 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2079803.6 | 6046661.8 | 4192.375 | 1.10 | 2.91 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6784445.9 | 23416085.8 | 12365.875 | 3.60 | 3.45 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 46052196.4 | 218527029.8 | 251517.875 | 24.46 | 4.75 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2089694.9 | 6189784.8 | 4619.375 | 1.11 | 2.96 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2652629.8 | 7334579.8 | 10149.750 | 1.41 | 2.77 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 11878908.8 | 26334410.8 | 430123.875 | 6.31 | 2.22 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20837669.9 | 57035436.8 | 560714.250 | 11.07 | 2.74 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 112763.0 | 426364.7 | 4.097 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 112804.4 | 426473.7 | 2.161 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 636103.7 | 3146523.7 | 6.000 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 112752.9 | 426333.7 | 2.419 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1223300.3 | 3932432.7 | 5.742 | 2.33 | 3.21 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1640489.5 | 5898886.7 | 6.516 | 3.13 | 3.60 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3610087.1 | 13174372.7 | 77517.677 | 6.89 | 3.65 |
