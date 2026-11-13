# bench-profile

| Field | Value |
|---|---|
| Commit | 3f9f670 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261101.172.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/42951744892 |
| Date | 2026-11-11 |

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
| silesia/dickens | 10192446 | zlib | 7.94 | 15.77 | 1.99 | 300.47 |
| silesia/dickens | 10192446 | zlib-ng | 4.86 | 10.50 | 2.16 | 67.37 |
| silesia/dickens | 10192446 | libdeflate | 3.45 | 9.56 | 2.77 | 66.61 |
| silesia/dickens | 10192446 | Wuffs | 4.86 | 10.85 | 2.23 | 97.44 |
| silesia/dickens | 10192446 | stdx | 2.91 | 7.15 | 2.45 | 75.90 |
| silesia/mozilla | 51220480 | zlib | 7.76 | 14.13 | 1.82 | 243.50 |
| silesia/mozilla | 51220480 | zlib-ng | 4.93 | 8.95 | 1.81 | 85.38 |
| silesia/mozilla | 51220480 | libdeflate | 3.46 | 7.63 | 2.21 | 71.04 |
| silesia/mozilla | 51220480 | Wuffs | 5.71 | 10.84 | 1.90 | 132.97 |
| silesia/mozilla | 51220480 | stdx | 3.59 | 6.29 | 1.75 | 89.32 |
| silesia/mr | 9970564 | zlib | 7.67 | 15.26 | 1.99 | 199.49 |
| silesia/mr | 9970564 | zlib-ng | 4.78 | 9.98 | 2.09 | 67.90 |
| silesia/mr | 9970564 | libdeflate | 3.34 | 8.58 | 2.57 | 61.18 |
| silesia/mr | 9970564 | Wuffs | 5.26 | 10.93 | 2.08 | 100.92 |
| silesia/mr | 9970564 | stdx | 3.06 | 6.70 | 2.19 | 69.79 |
| silesia/nci | 33553445 | zlib | 2.89 | 7.25 | 2.50 | 80.03 |
| silesia/nci | 33553445 | zlib-ng | 1.57 | 3.13 | 1.99 | 33.64 |
| silesia/nci | 33553445 | libdeflate | 1.10 | 2.66 | 2.42 | 27.60 |
| silesia/nci | 33553445 | Wuffs | 1.69 | 3.38 | 2.00 | 42.47 |
| silesia/nci | 33553445 | stdx | 1.13 | 2.20 | 1.95 | 37.20 |
| silesia/ooffice | 6152192 | zlib | 11.03 | 17.83 | 1.62 | 402.47 |
| silesia/ooffice | 6152192 | zlib-ng | 6.90 | 12.04 | 1.74 | 139.85 |
| silesia/ooffice | 6152192 | libdeflate | 4.90 | 10.45 | 2.13 | 125.43 |
| silesia/ooffice | 6152192 | Wuffs | 8.10 | 14.47 | 1.79 | 221.73 |
| silesia/ooffice | 6152192 | stdx | 5.06 | 8.55 | 1.69 | 150.67 |
| silesia/osdb | 10085684 | zlib | 6.79 | 13.54 | 1.99 | 171.88 |
| silesia/osdb | 10085684 | zlib-ng | 4.29 | 8.38 | 1.96 | 52.98 |
| silesia/osdb | 10085684 | libdeflate | 2.83 | 6.91 | 2.44 | 29.69 |
| silesia/osdb | 10085684 | Wuffs | 5.15 | 10.56 | 2.05 | 82.79 |
| silesia/osdb | 10085684 | stdx | 2.77 | 5.65 | 2.04 | 41.19 |
| silesia/reymont | 6627202 | zlib | 6.61 | 12.73 | 1.93 | 253.91 |
| silesia/reymont | 6627202 | zlib-ng | 3.70 | 7.72 | 2.09 | 59.46 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.09 |
| silesia/reymont | 6627202 | Wuffs | 4.22 | 8.40 | 1.99 | 112.20 |
| silesia/reymont | 6627202 | stdx | 2.28 | 5.11 | 2.24 | 64.32 |
| silesia/samba | 21606400 | zlib | 5.45 | 11.09 | 2.03 | 170.22 |
| silesia/samba | 21606400 | zlib-ng | 3.34 | 6.47 | 1.94 | 55.84 |
| silesia/samba | 21606400 | libdeflate | 2.30 | 5.58 | 2.42 | 42.86 |
| silesia/samba | 21606400 | Wuffs | 3.65 | 7.33 | 2.01 | 81.20 |
| silesia/samba | 21606400 | stdx | 2.24 | 4.46 | 1.99 | 56.14 |
| silesia/sao | 7251944 | zlib | 9.89 | 20.36 | 2.06 | 196.85 |
| silesia/sao | 7251944 | zlib-ng | 7.85 | 14.83 | 1.89 | 79.27 |
| silesia/sao | 7251944 | libdeflate | 5.73 | 12.73 | 2.22 | 79.00 |
| silesia/sao | 7251944 | Wuffs | 8.12 | 18.14 | 2.23 | 85.77 |
| silesia/sao | 7251944 | stdx | 5.56 | 10.32 | 1.86 | 87.38 |
| silesia/webster | 41458703 | zlib | 6.99 | 12.99 | 1.86 | 273.59 |
| silesia/webster | 41458703 | zlib-ng | 4.19 | 8.04 | 1.92 | 84.47 |
| silesia/webster | 41458703 | libdeflate | 2.85 | 7.17 | 2.51 | 68.45 |
| silesia/webster | 41458703 | Wuffs | 4.47 | 8.62 | 1.93 | 122.95 |
| silesia/webster | 41458703 | stdx | 2.70 | 5.56 | 2.06 | 87.03 |
| silesia/x-ray | 8474240 | zlib | 12.27 | 23.82 | 1.94 | 324.56 |
| silesia/x-ray | 8474240 | zlib-ng | 9.02 | 17.39 | 1.93 | 124.30 |
| silesia/x-ray | 8474240 | libdeflate | 6.52 | 15.26 | 2.34 | 124.54 |
| silesia/x-ray | 8474240 | Wuffs | 10.10 | 20.40 | 2.02 | 192.63 |
| silesia/x-ray | 8474240 | stdx | 6.11 | 11.49 | 1.88 | 137.70 |
| silesia/xml | 5345280 | zlib | 3.61 | 8.20 | 2.27 | 116.15 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.57 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.46 | 31.51 |
| silesia/xml | 5345280 | Wuffs | 2.19 | 4.14 | 1.89 | 60.87 |
| silesia/xml | 5345280 | stdx | 1.32 | 2.65 | 2.00 | 41.58 |
| canterbury/alice29.txt | 152089 | zlib | 7.57 | 15.08 | 1.99 | 284.06 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.51 | 9.91 | 2.20 | 59.98 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.19 | 8.96 | 2.80 | 55.94 |
| canterbury/alice29.txt | 152089 | Wuffs | 4.70 | 10.37 | 2.20 | 98.48 |
| canterbury/alice29.txt | 152089 | stdx | 2.73 | 6.99 | 2.56 | 64.06 |
| canterbury/asyoulik.txt | 125179 | zlib | 8.14 | 16.11 | 1.98 | 303.04 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.08 | 10.86 | 2.14 | 72.55 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.62 | 9.82 | 2.71 | 69.94 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.08 | 11.34 | 2.23 | 99.80 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.03 | 7.52 | 2.48 | 75.38 |
| canterbury/cp.html | 24603 | zlib | 6.57 | 14.20 | 2.16 | 175.21 |
| canterbury/cp.html | 24603 | zlib-ng | 4.16 | 9.50 | 2.29 | 35.14 |
| canterbury/cp.html | 24603 | libdeflate | 2.87 | 7.95 | 2.77 | 17.08 |
| canterbury/cp.html | 24603 | Wuffs | 4.47 | 10.87 | 2.43 | 56.60 |
| canterbury/cp.html | 24603 | stdx | 2.66 | 7.19 | 2.71 | 13.22 |
| canterbury/fields.c | 11150 | zlib | 4.62 | 14.65 | 3.17 | 36.98 |
| canterbury/fields.c | 11150 | zlib-ng | 3.88 | 10.20 | 2.63 | 14.90 |
| canterbury/fields.c | 11150 | libdeflate | 2.82 | 8.32 | 2.96 | 1.37 |
| canterbury/fields.c | 11150 | Wuffs | 3.81 | 11.51 | 3.02 | 8.74 |
| canterbury/fields.c | 11150 | stdx | 2.53 | 7.64 | 3.03 | 5.00 |
| canterbury/grammar.lsp | 3721 | zlib | 6.20 | 21.22 | 3.42 | 1.76 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.85 | 17.48 | 2.99 | 8.84 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.48 | 12.05 | 2.69 | 0.49 |
| canterbury/grammar.lsp | 3721 | Wuffs | 5.95 | 18.87 | 3.17 | 2.69 |
| canterbury/grammar.lsp | 3721 | stdx | 3.85 | 12.18 | 3.16 | 1.33 |
| canterbury/kennedy.xls | 1029744 | zlib | 3.96 | 12.20 | 3.08 | 49.07 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.50 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.29 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.20 | 8.67 | 2.71 | 14.81 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.74 | 4.66 | 2.68 | 16.50 |
| canterbury/lcet10.txt | 426754 | zlib | 7.37 | 14.53 | 1.97 | 279.78 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 60.61 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.30 |
| canterbury/lcet10.txt | 426754 | Wuffs | 4.55 | 9.85 | 2.16 | 101.41 |
| canterbury/lcet10.txt | 426754 | stdx | 2.59 | 6.42 | 2.48 | 66.52 |
| canterbury/plrabn12.txt | 481861 | zlib | 8.31 | 16.53 | 1.99 | 310.64 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.30 | 11.19 | 2.11 | 79.01 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.78 | 10.19 | 2.70 | 77.54 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.15 | 11.53 | 2.24 | 99.64 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.15 | 7.63 | 2.43 | 84.70 |
| canterbury/ptt5 | 513216 | zlib | 4.41 | 7.79 | 1.77 | 100.51 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.46 |
| canterbury/ptt5 | 513216 | libdeflate | 1.44 | 3.02 | 2.09 | 37.98 |
| canterbury/ptt5 | 513216 | Wuffs | 2.20 | 4.02 | 1.83 | 58.71 |
| canterbury/ptt5 | 513216 | stdx | 1.46 | 2.55 | 1.74 | 49.25 |
| canterbury/sum | 38240 | zlib | 7.28 | 14.98 | 2.06 | 214.43 |
| canterbury/sum | 38240 | zlib-ng | 4.63 | 10.02 | 2.16 | 56.02 |
| canterbury/sum | 38240 | libdeflate | 3.35 | 8.34 | 2.49 | 38.11 |
| canterbury/sum | 38240 | Wuffs | 5.01 | 11.41 | 2.28 | 77.22 |
| canterbury/sum | 38240 | stdx | 3.03 | 7.73 | 2.55 | 28.74 |
| canterbury/xargs.1 | 4227 | zlib | 6.65 | 22.08 | 3.32 | 5.36 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.39 | 17.97 | 2.81 | 10.42 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.87 | 13.27 | 2.72 | 4.24 |
| canterbury/xargs.1 | 4227 | Wuffs | 6.51 | 19.63 | 3.01 | 11.33 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 12.86 | 3.03 | 2.14 |
| canterbury-large/E.coli | 4638690 | zlib | 5.92 | 14.55 | 2.46 | 174.49 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.23 | 9.68 | 2.29 | 47.69 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.49 |
| canterbury-large/E.coli | 4638690 | Wuffs | 3.98 | 9.64 | 2.42 | 61.34 |
| canterbury-large/E.coli | 4638690 | stdx | 2.47 | 6.72 | 2.72 | 53.80 |
| canterbury-large/bible.txt | 4047392 | zlib | 6.72 | 13.26 | 1.97 | 259.63 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.77 | 8.26 | 2.19 | 53.85 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.46 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.14 | 8.72 | 2.11 | 100.65 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.23 | 5.57 | 2.49 | 55.82 |
| canterbury-large/world192.txt | 2473400 | zlib | 6.95 | 12.69 | 1.83 | 272.84 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.19 | 7.78 | 1.86 | 91.44 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.06 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 4.51 | 8.44 | 1.87 | 129.47 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 5.40 | 1.98 | 90.64 |
| http/html-1kx1024 | 1048576 | zlib | 15.83 | 32.44 | 2.05 | 349.69 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.73 | 28.43 | 2.23 | 218.92 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.85 | 20.05 | 1.85 | 155.79 |
| http/html-1kx1024 | 1048576 | Wuffs | 14.59 | 35.04 | 2.40 | 263.01 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 137.33 |
| http/html-16kx64 | 1048576 | zlib | 6.03 | 11.79 | 1.96 | 215.57 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.04 |
| http/html-16kx64 | 1048576 | libdeflate | 2.66 | 6.04 | 2.28 | 60.73 |
| http/html-16kx64 | 1048576 | Wuffs | 4.26 | 8.51 | 2.00 | 116.83 |
| http/html-16kx64 | 1048576 | stdx | 2.51 | 5.56 | 2.22 | 58.77 |
| http/html-1m | 1048576 | zlib | 4.65 | 9.51 | 2.04 | 172.70 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 60.02 |
| http/html-1m | 1048576 | libdeflate | 1.69 | 4.39 | 2.59 | 37.33 |
| http/html-1m | 1048576 | Wuffs | 2.96 | 5.42 | 1.83 | 90.30 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.11 | 52.36 |
| http/json-1kx1024 | 1048576 | zlib | 9.71 | 20.83 | 2.15 | 192.60 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.42 | 16.69 | 2.25 | 129.97 |
| http/json-1kx1024 | 1048576 | libdeflate | 9.12 | 16.72 | 1.83 | 92.05 |
| http/json-1kx1024 | 1048576 | Wuffs | 11.42 | 31.72 | 2.78 | 145.32 |
| http/json-1kx1024 | 1048576 | stdx | 5.03 | 13.12 | 2.61 | 80.96 |
| http/json-16kx64 | 1048576 | zlib | 3.95 | 9.62 | 2.44 | 101.73 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.61 | 5.50 | 2.11 | 50.64 |
| http/json-16kx64 | 1048576 | libdeflate | 1.92 | 4.24 | 2.20 | 39.66 |
| http/json-16kx64 | 1048576 | Wuffs | 2.81 | 6.35 | 2.26 | 58.11 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.26 | 39.52 |
| http/json-1m | 1048576 | zlib | 3.25 | 8.25 | 2.54 | 82.42 |
| http/json-1m | 1048576 | zlib-ng | 1.93 | 3.91 | 2.02 | 37.23 |
| http/json-1m | 1048576 | libdeflate | 1.37 | 3.33 | 2.42 | 32.17 |
| http/json-1m | 1048576 | Wuffs | 2.04 | 4.29 | 2.10 | 44.35 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.02 | 39.84 |
| http/js-1kx1024 | 1048576 | zlib | 17.30 | 35.33 | 2.04 | 402.61 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.83 | 31.25 | 2.26 | 240.90 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.53 | 21.58 | 1.87 | 179.13 |
| http/js-1kx1024 | 1048576 | Wuffs | 15.76 | 37.70 | 2.39 | 296.67 |
| http/js-1kx1024 | 1048576 | stdx | 9.28 | 22.85 | 2.46 | 159.58 |
| http/js-16kx64 | 1048576 | zlib | 6.92 | 13.06 | 1.89 | 255.72 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.97 | 92.14 |
| http/js-16kx64 | 1048576 | libdeflate | 3.07 | 7.01 | 2.28 | 72.03 |
| http/js-16kx64 | 1048576 | Wuffs | 4.84 | 9.70 | 2.00 | 130.43 |
| http/js-16kx64 | 1048576 | stdx | 2.99 | 6.54 | 2.19 | 71.80 |
| http/js-1m | 1048576 | zlib | 5.16 | 10.26 | 1.99 | 195.52 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 60.00 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 42.24 |
| http/js-1m | 1048576 | Wuffs | 3.25 | 6.10 | 1.88 | 96.10 |
| http/js-1m | 1048576 | stdx | 1.80 | 3.89 | 2.16 | 55.27 |
| http/css-1kx1024 | 1048576 | zlib | 13.14 | 27.18 | 2.07 | 281.60 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.29 | 23.04 | 2.24 | 172.43 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.45 | 17.37 | 1.84 | 121.41 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.07 | 29.48 | 2.44 | 208.98 |
| http/css-1kx1024 | 1048576 | stdx | 6.68 | 17.64 | 2.64 | 100.92 |
| http/css-16kx64 | 1048576 | zlib | 4.68 | 10.12 | 2.16 | 151.94 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.78 | 6.07 | 2.19 | 50.03 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 28.32 |
| http/css-16kx64 | 1048576 | Wuffs | 3.11 | 6.97 | 2.24 | 70.18 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.54 | 28.20 |
| http/css-1m | 1048576 | zlib | 3.37 | 8.00 | 2.37 | 107.45 |
| http/css-1m | 1048576 | zlib-ng | 1.69 | 3.75 | 2.22 | 28.80 |
| http/css-1m | 1048576 | libdeflate | 1.05 | 3.18 | 3.04 | 10.39 |
| http/css-1m | 1048576 | Wuffs | 1.90 | 4.08 | 2.15 | 44.40 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.53 | 21.47 |
| shuffled/dickens-1m | 1048576 | zlib | 12.73 | 22.42 | 1.76 | 372.27 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.73 | 16.72 | 1.72 | 197.64 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.04 | 14.95 | 2.12 | 195.52 |
| shuffled/dickens-1m | 1048576 | Wuffs | 9.66 | 18.95 | 1.96 | 205.64 |
| shuffled/dickens-1m | 1048576 | stdx | 7.03 | 11.89 | 1.69 | 205.45 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.50 | 14.04 | 4.01 | 3.48 |
| silesia/dickens | 10192446 | stdx | 3.63 | 12.47 | 3.43 | 3.72 |
| silesia/mozilla | 51220480 | libzstd | 2.80 | 9.62 | 3.44 | 30.03 |
| silesia/mozilla | 51220480 | stdx | 2.73 | 9.68 | 3.54 | 15.65 |
| silesia/mr | 9970564 | libzstd | 3.01 | 11.98 | 3.98 | 6.23 |
| silesia/mr | 9970564 | stdx | 3.03 | 10.83 | 3.57 | 5.25 |
| silesia/nci | 33553445 | libzstd | 1.58 | 4.84 | 3.07 | 23.50 |
| silesia/nci | 33553445 | stdx | 1.57 | 4.63 | 2.94 | 13.61 |
| silesia/ooffice | 6152192 | libzstd | 3.37 | 12.14 | 3.60 | 31.05 |
| silesia/ooffice | 6152192 | stdx | 3.29 | 12.40 | 3.76 | 12.09 |
| silesia/osdb | 10085684 | libzstd | 2.33 | 8.44 | 3.63 | 15.37 |
| silesia/osdb | 10085684 | stdx | 2.39 | 8.11 | 3.39 | 15.09 |
| silesia/reymont | 6627202 | libzstd | 3.15 | 11.61 | 3.69 | 11.66 |
| silesia/reymont | 6627202 | stdx | 3.28 | 10.36 | 3.16 | 12.74 |
| silesia/samba | 21606400 | libzstd | 2.02 | 7.39 | 3.66 | 18.65 |
| silesia/samba | 21606400 | stdx | 2.09 | 6.83 | 3.27 | 17.61 |
| silesia/sao | 7251944 | libzstd | 3.76 | 12.69 | 3.38 | 26.51 |
| silesia/sao | 7251944 | stdx | 3.44 | 12.58 | 3.66 | 6.35 |
| silesia/webster | 41458703 | libzstd | 3.06 | 11.22 | 3.67 | 16.23 |
| silesia/webster | 41458703 | stdx | 3.21 | 10.05 | 3.13 | 17.45 |
| silesia/x-ray | 8474240 | libzstd | 3.95 | 14.93 | 3.78 | 18.79 |
| silesia/x-ray | 8474240 | stdx | 3.51 | 13.23 | 3.77 | 8.35 |
| silesia/xml | 5345280 | libzstd | 1.53 | 5.55 | 3.63 | 22.86 |
| silesia/xml | 5345280 | stdx | 1.52 | 5.16 | 3.40 | 17.16 |
| canterbury/alice29.txt | 152089 | libzstd | 3.36 | 16.18 | 4.82 | 4.20 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.47 |
| canterbury/asyoulik.txt | 125179 | libzstd | 3.00 | 14.25 | 4.74 | 3.33 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.29 | 0.27 |
| canterbury/cp.html | 24603 | libzstd | 2.67 | 10.74 | 4.02 | 9.46 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.12 | 0.17 |
| canterbury/fields.c | 11150 | libzstd | 3.14 | 13.61 | 4.34 | 10.09 |
| canterbury/fields.c | 11150 | stdx | 3.02 | 12.72 | 4.21 | 0.36 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.23 | 16.93 | 4.00 | 5.98 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.54 | 4.02 | 0.18 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.49 | 11.22 | 4.51 | 7.70 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.23 | 0.93 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.73 | 12.87 | 4.71 | 5.30 |
| canterbury/lcet10.txt | 426754 | stdx | 2.72 | 11.52 | 4.24 | 2.83 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.16 | 15.14 | 4.79 | 1.59 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.26 | 1.05 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.50 | 3.11 | 24.51 |
| canterbury/ptt5 | 513216 | stdx | 1.33 | 4.46 | 3.34 | 12.98 |
| canterbury/sum | 38240 | libzstd | 2.65 | 10.51 | 3.96 | 10.63 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.31 |
| canterbury/xargs.1 | 4227 | libzstd | 4.29 | 17.40 | 4.05 | 10.39 |
| canterbury/xargs.1 | 4227 | stdx | 4.27 | 17.17 | 4.03 | 0.39 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.00 | 13.63 | 4.54 | 2.24 |
| canterbury-large/E.coli | 4638690 | stdx | 3.07 | 12.04 | 3.92 | 2.93 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.94 | 11.99 | 4.08 | 8.54 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.05 | 10.64 | 3.49 | 9.27 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.52 | 9.59 | 3.81 | 19.93 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.60 | 8.64 | 3.32 | 21.71 |
| http/html-1kx1024 | 1048576 | libzstd | 7.41 | 21.63 | 2.92 | 63.18 |
| http/html-1kx1024 | 1048576 | stdx | 7.46 | 22.46 | 3.01 | 76.21 |
| http/html-16kx64 | 1048576 | libzstd | 2.67 | 10.15 | 3.81 | 28.75 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 9.61 | 3.61 | 30.01 |
| http/html-1m | 1048576 | libzstd | 1.99 | 7.86 | 3.95 | 24.25 |
| http/html-1m | 1048576 | stdx | 2.00 | 7.12 | 3.56 | 24.96 |
| http/json-1kx1024 | 1048576 | libzstd | 6.39 | 17.37 | 2.72 | 49.25 |
| http/json-1kx1024 | 1048576 | stdx | 6.22 | 17.86 | 2.87 | 53.59 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.22 | 3.53 | 27.75 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 19.88 |
| http/json-1m | 1048576 | libzstd | 1.71 | 6.04 | 3.53 | 27.40 |
| http/json-1m | 1048576 | stdx | 1.63 | 5.91 | 3.63 | 14.36 |
| http/js-1kx1024 | 1048576 | libzstd | 8.45 | 26.38 | 3.12 | 72.41 |
| http/js-1kx1024 | 1048576 | stdx | 9.04 | 27.60 | 3.05 | 112.83 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.71 | 4.00 | 24.39 |
| http/js-16kx64 | 1048576 | stdx | 2.97 | 11.06 | 3.72 | 26.79 |
| http/js-1m | 1048576 | libzstd | 2.01 | 8.18 | 4.06 | 20.25 |
| http/js-1m | 1048576 | stdx | 2.06 | 7.48 | 3.62 | 21.72 |
| http/css-1kx1024 | 1048576 | libzstd | 7.04 | 19.70 | 2.80 | 53.96 |
| http/css-1kx1024 | 1048576 | stdx | 6.84 | 19.96 | 2.92 | 63.32 |
| http/css-16kx64 | 1048576 | libzstd | 2.23 | 8.69 | 3.89 | 23.16 |
| http/css-16kx64 | 1048576 | stdx | 2.28 | 8.43 | 3.70 | 22.18 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.57 | 3.88 | 5.52 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.50 | 4.06 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.80 | 9.40 | 3.35 | 28.59 |
| shuffled/dickens-1m | 1048576 | stdx | 2.73 | 9.19 | 3.37 | 12.67 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.50 | 17.04 | 2.27 | 100.86 |
| silesia/dickens | 1048576 | stdx | 5.10 | 12.38 | 2.43 | 54.54 |
| silesia/mozilla | 1048576 | Google | 13.59 | 27.77 | 2.04 | 47.19 |
| silesia/mozilla | 1048576 | stdx | 8.31 | 15.02 | 1.81 | 46.96 |
| silesia/mr | 1048576 | Google | 8.94 | 20.24 | 2.26 | 102.45 |
| silesia/mr | 1048576 | stdx | 5.78 | 13.25 | 2.29 | 88.73 |
| silesia/nci | 1048576 | Google | 2.56 | 5.69 | 2.22 | 51.77 |
| silesia/nci | 1048576 | stdx | 1.96 | 3.95 | 2.02 | 55.82 |
| silesia/ooffice | 1048576 | Google | 14.19 | 29.28 | 2.06 | 288.59 |
| silesia/ooffice | 1048576 | stdx | 10.86 | 20.33 | 1.87 | 323.00 |
| silesia/osdb | 1048576 | Google | 8.23 | 17.38 | 2.11 | 96.13 |
| silesia/osdb | 1048576 | stdx | 5.16 | 10.57 | 2.05 | 92.17 |
| silesia/reymont | 1048576 | Google | 5.43 | 12.73 | 2.34 | 81.61 |
| silesia/reymont | 1048576 | stdx | 3.72 | 9.25 | 2.48 | 47.79 |
| silesia/samba | 1048576 | Google | 7.57 | 16.22 | 2.14 | 95.67 |
| silesia/samba | 1048576 | stdx | 5.05 | 10.71 | 2.12 | 67.06 |
| silesia/sao | 1048576 | Google | 16.80 | 36.97 | 2.20 | 161.74 |
| silesia/sao | 1048576 | stdx | 10.50 | 22.65 | 2.16 | 142.85 |
| silesia/webster | 1048576 | Google | 6.55 | 14.07 | 2.15 | 115.14 |
| silesia/webster | 1048576 | stdx | 4.49 | 9.98 | 2.22 | 69.30 |
| silesia/x-ray | 1048576 | Google | 19.34 | 38.46 | 1.99 | 234.08 |
| silesia/x-ray | 1048576 | stdx | 14.81 | 30.18 | 2.04 | 235.00 |
| silesia/xml | 1048576 | Google | 3.45 | 7.65 | 2.22 | 65.54 |
| silesia/xml | 1048576 | stdx | 2.42 | 5.40 | 2.23 | 46.97 |
| canterbury/alice29.txt | 152089 | Google | 8.89 | 20.66 | 2.32 | 135.68 |
| canterbury/alice29.txt | 152089 | stdx | 6.08 | 15.33 | 2.52 | 82.40 |
| canterbury/asyoulik.txt | 125179 | Google | 10.41 | 23.83 | 2.29 | 169.66 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.03 | 17.43 | 2.48 | 102.07 |
| canterbury/cp.html | 24603 | Google | 9.14 | 22.18 | 2.43 | 112.53 |
| canterbury/cp.html | 24603 | stdx | 5.79 | 17.15 | 2.96 | 34.90 |
| canterbury/fields.c | 11150 | Google | 7.07 | 21.25 | 3.01 | 21.67 |
| canterbury/fields.c | 11150 | stdx | 4.91 | 17.08 | 3.48 | 4.16 |
| canterbury/grammar.lsp | 3721 | Google | 9.83 | 30.23 | 3.08 | 5.22 |
| canterbury/grammar.lsp | 3721 | stdx | 7.15 | 25.04 | 3.50 | 0.38 |
| canterbury/kennedy.xls | 1029744 | Google | 5.43 | 17.05 | 3.14 | 37.12 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.79 | 12.94 | 3.41 | 33.98 |
| canterbury/lcet10.txt | 426754 | Google | 7.73 | 17.42 | 2.25 | 129.64 |
| canterbury/lcet10.txt | 426754 | stdx | 5.20 | 12.96 | 2.49 | 66.51 |
| canterbury/plrabn12.txt | 481861 | Google | 9.09 | 20.94 | 2.31 | 133.96 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.15 | 15.04 | 2.45 | 87.68 |
| canterbury/ptt5 | 513216 | Google | 4.30 | 10.36 | 2.41 | 62.61 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.06 | 66.32 |
| canterbury/sum | 38240 | Google | 10.80 | 26.44 | 2.45 | 155.50 |
| canterbury/sum | 38240 | stdx | 8.37 | 21.11 | 2.52 | 158.26 |
| canterbury/xargs.1 | 4227 | Google | 10.89 | 34.81 | 3.20 | 8.42 |
| canterbury/xargs.1 | 4227 | stdx | 8.48 | 30.44 | 3.59 | 6.88 |
| canterbury-large/E.coli | 1048576 | Google | 7.47 | 19.44 | 2.60 | 1.41 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 2.00 |
| canterbury-large/bible.txt | 1048576 | Google | 5.33 | 12.38 | 2.32 | 80.64 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.54 | 8.93 | 2.52 | 40.04 |
| canterbury-large/world192.txt | 1048576 | Google | 6.21 | 12.88 | 2.07 | 115.23 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.40 | 9.38 | 2.13 | 77.19 |
| http/html-1kx1024 | 1048576 | Google | 17.97 | 42.09 | 2.34 | 387.93 |
| http/html-1kx1024 | 1048576 | stdx | 15.24 | 37.56 | 2.46 | 360.29 |
| http/html-16kx64 | 1048576 | Google | 6.76 | 14.88 | 2.20 | 149.48 |
| http/html-16kx64 | 1048576 | stdx | 5.16 | 12.15 | 2.36 | 115.42 |
| http/html-1m | 1048576 | Google | 4.06 | 8.99 | 2.22 | 83.29 |
| http/html-1m | 1048576 | stdx | 2.86 | 6.52 | 2.28 | 54.88 |
| http/json-1kx1024 | 1048576 | Google | 14.31 | 36.74 | 2.57 | 238.78 |
| http/json-1kx1024 | 1048576 | stdx | 12.95 | 33.63 | 2.60 | 276.69 |
| http/json-16kx64 | 1048576 | Google | 4.42 | 11.42 | 2.58 | 81.36 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.62 |
| http/json-1m | 1048576 | Google | 3.40 | 8.66 | 2.54 | 58.67 |
| http/json-1m | 1048576 | stdx | 2.45 | 5.99 | 2.44 | 57.75 |
| http/js-1kx1024 | 1048576 | Google | 19.94 | 46.38 | 2.33 | 428.66 |
| http/js-1kx1024 | 1048576 | stdx | 16.34 | 39.90 | 2.44 | 379.68 |
| http/js-16kx64 | 1048576 | Google | 8.08 | 17.79 | 2.20 | 167.90 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.84 |
| http/js-1m | 1048576 | Google | 4.36 | 9.60 | 2.20 | 83.48 |
| http/js-1m | 1048576 | stdx | 3.16 | 7.25 | 2.29 | 55.95 |
| http/css-1kx1024 | 1048576 | Google | 15.39 | 37.48 | 2.44 | 292.75 |
| http/css-1kx1024 | 1048576 | stdx | 13.78 | 34.70 | 2.52 | 302.67 |
| http/css-16kx64 | 1048576 | Google | 4.96 | 11.78 | 2.38 | 100.60 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.64 |
| http/css-1m | 1048576 | Google | 2.43 | 9.43 | 3.88 | 16.72 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.47 | 11.96 |
| shuffled/dickens-1m | 1048576 | Google | 9.71 | 20.34 | 2.09 | 110.72 |
| shuffled/dickens-1m | 1048576 | stdx | 8.77 | 14.53 | 1.66 | 118.33 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.20 | 36.91 | 2.43 | 410.80 |
| silesia/dickens | 10192446 | 1 | stdx | 16.24 | 38.17 | 2.35 | 360.62 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.09 | 87.63 | 1.68 | 693.85 |
| silesia/dickens | 10192446 | 6 | stdx | 49.64 | 84.25 | 1.70 | 1455.26 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.89 | 160.47 | 1.43 | 930.27 |
| silesia/dickens | 10192446 | 9 | stdx | 64.84 | 150.06 | 2.31 | 1398.95 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.12 | 32.62 | 2.31 | 436.81 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.31 | 30.24 | 2.27 | 294.93 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.86 | 70.83 | 2.16 | 578.19 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.52 | 69.96 | 2.22 | 735.76 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.82 | 221.49 | 1.73 | 771.75 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.58 | 125.42 | 2.58 | 780.69 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.96 | 35.02 | 2.93 | 229.75 |
| silesia/mr | 9970564 | 1 | stdx | 12.46 | 34.08 | 2.74 | 187.37 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.24 | 80.54 | 2.11 | 436.54 |
| silesia/mr | 9970564 | 6 | stdx | 39.79 | 83.18 | 2.09 | 982.82 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.85 | 165.48 | 1.69 | 750.74 |
| silesia/mr | 9970564 | 9 | stdx | 78.84 | 184.93 | 2.35 | 1222.12 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.18 | 18.42 | 2.98 | 114.86 |
| silesia/nci | 33553445 | 1 | stdx | 4.85 | 10.88 | 2.24 | 97.23 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.97 | 34.84 | 2.05 | 226.18 |
| silesia/nci | 33553445 | 6 | stdx | 14.40 | 29.54 | 2.05 | 396.11 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.45 | 105.28 | 1.69 | 502.10 |
| silesia/nci | 33553445 | 9 | stdx | 28.27 | 69.01 | 2.44 | 559.35 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.88 | 39.15 | 1.97 | 752.37 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.58 | 39.08 | 2.22 | 429.78 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 40.94 | 79.10 | 1.93 | 955.92 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.58 | 87.83 | 2.11 | 1014.15 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.65 | 127.63 | 1.71 | 1132.21 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.17 | 129.03 | 2.47 | 934.17 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.85 | 30.15 | 2.35 | 351.91 |
| silesia/osdb | 10085684 | 1 | stdx | 12.83 | 27.86 | 2.17 | 293.71 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.31 | 55.67 | 1.97 | 489.28 |
| silesia/osdb | 10085684 | 6 | stdx | 27.11 | 57.39 | 2.12 | 578.30 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.92 | 64.15 | 1.89 | 553.77 |
| silesia/osdb | 10085684 | 9 | stdx | 35.24 | 87.16 | 2.47 | 684.74 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.59 | 32.88 | 2.61 | 310.83 |
| silesia/reymont | 6627202 | 1 | stdx | 13.31 | 33.24 | 2.50 | 271.63 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.16 | 86.58 | 1.80 | 520.26 |
| silesia/reymont | 6627202 | 6 | stdx | 45.40 | 76.81 | 1.69 | 1440.43 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.41 | 276.14 | 1.39 | 837.02 |
| silesia/reymont | 6627202 | 9 | stdx | 74.07 | 160.03 | 2.16 | 1435.42 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.41 | 26.53 | 2.55 | 271.63 |
| silesia/samba | 21606400 | 1 | stdx | 9.88 | 22.23 | 2.25 | 220.94 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.94 | 58.79 | 2.03 | 384.99 |
| silesia/samba | 21606400 | 6 | stdx | 24.09 | 49.83 | 2.07 | 627.68 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.25 | 141.44 | 1.68 | 505.12 |
| silesia/samba | 21606400 | 9 | stdx | 36.10 | 90.81 | 2.52 | 644.23 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.67 | 47.87 | 2.21 | 683.61 |
| silesia/sao | 7251944 | 1 | stdx | 19.00 | 49.92 | 2.63 | 345.76 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.18 | 96.89 | 1.89 | 965.47 |
| silesia/sao | 7251944 | 6 | stdx | 47.09 | 105.66 | 2.24 | 857.24 |
| silesia/sao | 7251944 | 9 | libdeflate | 71.05 | 120.26 | 1.69 | 1112.39 |
| silesia/sao | 7251944 | 9 | stdx | 55.04 | 137.71 | 2.50 | 835.43 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.11 | 30.45 | 2.32 | 385.93 |
| silesia/webster | 41458703 | 1 | stdx | 13.83 | 29.08 | 2.10 | 339.69 |
| silesia/webster | 41458703 | 6 | libdeflate | 37.00 | 66.02 | 1.78 | 569.69 |
| silesia/webster | 41458703 | 6 | stdx | 35.18 | 60.87 | 1.73 | 1118.54 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.69 | 138.85 | 1.47 | 757.61 |
| silesia/webster | 41458703 | 9 | stdx | 48.43 | 110.73 | 2.29 | 1085.54 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.65 | 49.67 | 2.10 | 782.29 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.47 | 50.81 | 2.91 | 261.52 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.78 | 82.77 | 2.52 | 850.76 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.85 | 98.12 | 2.90 | 539.18 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.50 | 91.03 | 2.43 | 1028.84 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.44 | 121.58 | 3.01 | 465.97 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.76 | 21.59 | 2.78 | 175.32 |
| silesia/xml | 5345280 | 1 | stdx | 6.81 | 15.66 | 2.30 | 154.78 |
| silesia/xml | 5345280 | 6 | libdeflate | 20.96 | 40.51 | 1.93 | 264.05 |
| silesia/xml | 5345280 | 6 | stdx | 17.70 | 34.32 | 1.94 | 503.13 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.51 | 89.17 | 1.52 | 372.36 |
| silesia/xml | 5345280 | 9 | stdx | 26.52 | 63.43 | 2.39 | 526.14 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.24 | 35.61 | 2.50 | 377.58 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.05 | 36.12 | 2.40 | 336.00 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.76 | 82.29 | 1.76 | 639.41 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.87 | 77.41 | 1.76 | 1339.98 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.67 | 159.21 | 1.48 | 850.90 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 58.28 | 138.20 | 2.37 | 1273.39 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.15 | 37.20 | 2.46 | 413.87 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.80 | 37.43 | 2.37 | 360.29 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.27 | 85.43 | 1.77 | 712.42 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.40 | 81.92 | 1.77 | 1416.15 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.82 | 136.15 | 1.53 | 938.90 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 60.17 | 144.56 | 2.40 | 1335.69 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.63 | 32.02 | 2.75 | 280.10 |
| canterbury/cp.html | 24603 | 1 | stdx | 11.22 | 27.13 | 2.42 | 260.34 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 26.93 | 62.33 | 2.31 | 488.49 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.69 | 57.05 | 2.41 | 623.36 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.99 | 91.97 | 1.96 | 606.33 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.32 | 88.88 | 2.84 | 650.00 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.73 | 35.92 | 3.69 | 75.81 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.12 | 30.05 | 3.70 | 24.84 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.56 | 69.37 | 2.82 | 249.21 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.81 | 57.62 | 2.77 | 430.26 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.44 | 100.81 | 2.27 | 413.67 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.32 | 92.65 | 3.27 | 446.96 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.07 | 51.51 | 3.94 | 16.25 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.87 | 39.01 | 3.95 | 2.07 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.80 | 87.06 | 3.66 | 30.77 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.10 | 70.80 | 4.14 | 14.90 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.82 | 102.89 | 3.34 | 42.55 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.74 | 99.30 | 4.18 | 53.48 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.36 | 27.18 | 3.69 | 65.20 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.04 | 22.58 | 3.21 | 63.57 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.89 | 73.85 | 2.65 | 95.85 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.34 | 61.98 | 3.21 | 140.21 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.29 | 664.23 | 1.83 | 164.08 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 30.17 | 107.06 | 3.55 | 143.50 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.76 | 33.99 | 2.47 | 369.36 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.46 | 33.92 | 2.35 | 330.84 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.04 | 78.22 | 1.74 | 605.61 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.95 | 73.42 | 1.75 | 1256.11 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.85 | 136.94 | 1.49 | 803.70 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 55.19 | 130.91 | 2.37 | 1199.90 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.81 | 38.62 | 2.44 | 427.15 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.69 | 40.24 | 2.41 | 366.78 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.12 | 91.90 | 1.70 | 750.75 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.85 | 88.89 | 1.71 | 1538.09 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.93 | 166.26 | 1.42 | 1001.46 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 67.82 | 158.18 | 2.33 | 1468.01 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.44 | 18.61 | 2.89 | 141.54 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.98 | 11.03 | 2.21 | 123.48 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.23 | 36.17 | 2.54 | 218.69 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.36 | 29.57 | 2.39 | 312.68 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.61 | 120.86 | 1.99 | 379.00 |
| canterbury/ptt5 | 513216 | 9 | stdx | 41.29 | 126.55 | 3.07 | 590.96 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.81 | 33.49 | 2.62 | 337.12 |
| canterbury/sum | 38240 | 1 | stdx | 12.62 | 29.36 | 2.33 | 297.20 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.58 | 69.87 | 2.44 | 492.73 |
| canterbury/sum | 38240 | 6 | stdx | 26.74 | 65.73 | 2.46 | 664.45 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.46 | 181.91 | 1.93 | 606.92 |
| canterbury/sum | 38240 | 9 | stdx | 39.17 | 112.32 | 2.87 | 656.80 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.38 | 53.06 | 3.96 | 27.17 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.77 | 43.10 | 4.00 | 2.27 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.90 | 87.70 | 3.83 | 69.03 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 18.03 | 74.35 | 4.12 | 45.24 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 24.84 | 94.34 | 3.80 | 87.96 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 25.89 | 106.95 | 4.13 | 101.31 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.08 | 40.47 | 3.35 | 164.16 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.77 | 42.29 | 3.31 | 101.47 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.39 | 395.99 | 2.16 | 263.43 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 123.07 | 374.12 | 3.04 | 1924.42 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 818.08 | 1063.49 | 1.30 | 1321.99 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 229.66 | 751.65 | 3.27 | 2435.67 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.53 | 32.38 | 2.58 | 311.25 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.26 | 32.23 | 2.43 | 281.35 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.13 | 80.12 | 1.74 | 523.66 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.35 | 72.38 | 1.71 | 1280.59 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.89 | 200.28 | 1.41 | 743.41 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 60.62 | 136.73 | 2.26 | 1226.35 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.31 | 29.72 | 2.23 | 413.19 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.19 | 28.55 | 2.01 | 378.77 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.12 | 60.25 | 1.82 | 558.24 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 32.18 | 56.80 | 1.76 | 1004.34 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.76 | 119.11 | 1.47 | 689.19 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 41.70 | 97.56 | 2.34 | 971.04 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.42 | 103.92 | 2.93 | 456.35 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.32 | 58.63 | 2.75 | 365.61 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.16 | 138.33 | 3.00 | 564.74 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 32.87 | 94.30 | 2.87 | 526.80 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.68 | 142.44 | 2.99 | 587.62 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 36.94 | 112.10 | 3.03 | 538.57 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.45 | 27.96 | 2.68 | 266.94 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.01 | 20.25 | 2.25 | 233.39 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.31 | 52.09 | 2.34 | 390.39 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.90 | 42.86 | 2.27 | 544.61 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 35.00 | 72.54 | 2.07 | 463.88 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.69 | 69.05 | 2.80 | 549.85 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.77 | 23.03 | 2.63 | 223.39 |
| http/html-1m | 1048576 | 1 | stdx | 8.14 | 17.79 | 2.19 | 205.24 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.27 | 49.53 | 1.96 | 325.99 |
| http/html-1m | 1048576 | 6 | stdx | 21.22 | 40.70 | 1.92 | 625.19 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.08 | 109.24 | 1.54 | 432.00 |
| http/html-1m | 1048576 | 9 | stdx | 29.86 | 73.42 | 2.46 | 614.70 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.78 | 94.80 | 2.98 | 302.58 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.42 | 45.16 | 2.75 | 241.20 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.01 | 126.60 | 2.94 | 373.35 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.10 | 78.36 | 2.89 | 379.19 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.10 | 142.45 | 2.73 | 431.22 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.70 | 95.54 | 3.11 | 385.07 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.84 | 23.85 | 3.04 | 133.75 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.46 | 13.94 | 2.55 | 110.71 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.17 | 46.61 | 2.57 | 204.45 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.39 | 35.01 | 2.62 | 281.69 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.30 | 151.99 | 1.89 | 298.97 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.07 | 58.29 | 3.06 | 302.01 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.73 | 19.85 | 2.95 | 124.28 |
| http/json-1m | 1048576 | 1 | stdx | 5.10 | 12.51 | 2.45 | 103.41 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.31 | 45.30 | 2.23 | 175.27 |
| http/json-1m | 1048576 | 6 | stdx | 14.69 | 35.08 | 2.39 | 299.01 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.74 | 205.21 | 1.69 | 279.99 |
| http/json-1m | 1048576 | 9 | stdx | 27.30 | 69.14 | 2.53 | 336.55 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.07 | 107.80 | 2.91 | 519.45 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.63 | 65.40 | 2.77 | 410.03 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.32 | 144.85 | 2.94 | 675.68 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 36.47 | 104.11 | 2.85 | 618.54 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.61 | 150.13 | 2.91 | 714.90 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 41.10 | 125.11 | 3.04 | 624.49 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.73 | 30.90 | 2.63 | 308.79 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.81 | 24.80 | 2.29 | 272.87 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.85 | 59.43 | 2.30 | 469.34 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.73 | 50.04 | 2.20 | 681.05 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.88 | 83.31 | 2.04 | 563.87 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.54 | 81.30 | 2.75 | 662.61 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.65 | 25.19 | 2.61 | 247.21 |
| http/js-1m | 1048576 | 1 | stdx | 9.53 | 21.31 | 2.24 | 232.80 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.72 | 56.12 | 1.95 | 369.13 |
| http/js-1m | 1048576 | 6 | stdx | 24.93 | 46.64 | 1.87 | 752.03 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.32 | 120.65 | 1.58 | 499.69 |
| http/js-1m | 1048576 | 9 | stdx | 34.90 | 84.80 | 2.43 | 709.25 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.20 | 97.73 | 2.94 | 376.44 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.31 | 49.52 | 2.70 | 301.53 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.80 | 129.22 | 2.95 | 479.36 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.04 | 82.31 | 2.83 | 505.64 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.82 | 133.80 | 2.92 | 510.90 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.04 | 99.46 | 3.01 | 521.84 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.63 | 25.60 | 2.97 | 173.43 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.69 | 16.96 | 2.54 | 135.05 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.18 | 48.80 | 2.42 | 288.17 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.45 | 38.00 | 2.31 | 471.49 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.81 | 82.40 | 2.02 | 371.15 |
| http/css-16kx64 | 1048576 | 9 | stdx | 22.87 | 65.13 | 2.85 | 478.93 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.94 | 21.15 | 3.05 | 132.53 |
| http/css-1m | 1048576 | 1 | stdx | 5.76 | 14.91 | 2.59 | 107.66 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.79 | 44.50 | 2.14 | 227.41 |
| http/css-1m | 1048576 | 6 | stdx | 16.57 | 35.61 | 2.15 | 445.47 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.79 | 111.58 | 1.60 | 309.93 |
| http/css-1m | 1048576 | 9 | stdx | 28.02 | 72.54 | 2.59 | 472.67 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.22 | 48.89 | 1.94 | 928.77 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.09 | 49.19 | 2.72 | 323.57 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.59 | 86.45 | 2.08 | 1183.26 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.59 | 88.79 | 2.24 | 853.92 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.13 | 94.50 | 2.01 | 1344.69 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 53.39 | 133.83 | 2.51 | 1125.69 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.12 | 31.13 | 3.08 | 123.14 |
| silesia/dickens | 10192446 | 1 | stdx | 24.21 | 82.03 | 3.39 | 125.27 |
| silesia/dickens | 10192446 | 3 | libzstd | 22.83 | 35.01 | 1.53 | 171.70 |
| silesia/dickens | 10192446 | 3 | stdx | 35.94 | 78.22 | 2.18 | 182.84 |
| silesia/mozilla | 51220480 | 1 | libzstd | 7.00 | 22.57 | 3.22 | 72.04 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.58 | 54.73 | 3.11 | 173.12 |
| silesia/mozilla | 51220480 | 3 | libzstd | 17.43 | 28.71 | 1.65 | 102.45 |
| silesia/mozilla | 51220480 | 3 | stdx | 30.84 | 62.01 | 2.01 | 144.96 |
| silesia/mr | 9970564 | 1 | libzstd | 7.62 | 24.73 | 3.25 | 57.51 |
| silesia/mr | 9970564 | 1 | stdx | 19.87 | 66.82 | 3.36 | 113.41 |
| silesia/mr | 9970564 | 3 | libzstd | 20.42 | 32.97 | 1.61 | 86.73 |
| silesia/mr | 9970564 | 3 | stdx | 33.83 | 72.46 | 2.14 | 114.63 |
| silesia/nci | 33553445 | 1 | libzstd | 3.53 | 9.49 | 2.69 | 58.71 |
| silesia/nci | 33553445 | 1 | stdx | 7.68 | 25.69 | 3.34 | 58.95 |
| silesia/nci | 33553445 | 3 | libzstd | 5.45 | 10.11 | 1.86 | 57.11 |
| silesia/nci | 33553445 | 3 | stdx | 11.38 | 29.15 | 2.56 | 66.35 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.52 | 29.17 | 3.42 | 71.83 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.10 | 72.51 | 3.14 | 179.86 |
| silesia/ooffice | 6152192 | 3 | libzstd | 24.48 | 40.82 | 1.67 | 121.74 |
| silesia/ooffice | 6152192 | 3 | stdx | 42.06 | 82.20 | 1.95 | 184.94 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.09 | 22.22 | 3.13 | 66.96 |
| silesia/osdb | 10085684 | 1 | stdx | 16.31 | 50.52 | 3.10 | 119.35 |
| silesia/osdb | 10085684 | 3 | libzstd | 18.37 | 27.06 | 1.47 | 69.70 |
| silesia/osdb | 10085684 | 3 | stdx | 32.06 | 57.87 | 1.81 | 110.34 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.78 | 27.02 | 2.76 | 155.71 |
| silesia/reymont | 6627202 | 1 | stdx | 20.06 | 72.05 | 3.59 | 96.58 |
| silesia/reymont | 6627202 | 3 | libzstd | 18.33 | 27.53 | 1.50 | 126.86 |
| silesia/reymont | 6627202 | 3 | stdx | 28.11 | 62.18 | 2.21 | 147.31 |
| silesia/samba | 21606400 | 1 | libzstd | 5.95 | 16.80 | 2.82 | 88.19 |
| silesia/samba | 21606400 | 1 | stdx | 13.46 | 42.89 | 3.19 | 124.75 |
| silesia/samba | 21606400 | 3 | libzstd | 12.07 | 19.20 | 1.59 | 100.05 |
| silesia/samba | 21606400 | 3 | stdx | 20.43 | 44.75 | 2.19 | 133.07 |
| silesia/sao | 7251944 | 1 | libzstd | 8.99 | 33.64 | 3.74 | 43.66 |
| silesia/sao | 7251944 | 1 | stdx | 26.08 | 82.03 | 3.15 | 104.15 |
| silesia/sao | 7251944 | 3 | libzstd | 32.32 | 52.14 | 1.61 | 95.27 |
| silesia/sao | 7251944 | 3 | stdx | 51.39 | 95.22 | 1.85 | 142.40 |
| silesia/webster | 41458703 | 1 | libzstd | 8.72 | 24.86 | 2.85 | 135.59 |
| silesia/webster | 41458703 | 1 | stdx | 20.31 | 64.04 | 3.15 | 166.23 |
| silesia/webster | 41458703 | 3 | libzstd | 19.37 | 27.84 | 1.44 | 178.17 |
| silesia/webster | 41458703 | 3 | stdx | 31.17 | 64.55 | 2.07 | 194.71 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.61 | 14.89 | 3.23 | 17.00 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.83 | 76.64 | 3.22 | 92.16 |
| silesia/x-ray | 8474240 | 3 | libzstd | 33.41 | 54.96 | 1.64 | 86.48 |
| silesia/x-ray | 8474240 | 3 | stdx | 47.77 | 92.40 | 1.93 | 105.87 |
| silesia/xml | 5345280 | 1 | libzstd | 4.26 | 11.65 | 2.74 | 72.93 |
| silesia/xml | 5345280 | 1 | stdx | 10.35 | 34.21 | 3.31 | 93.92 |
| silesia/xml | 5345280 | 3 | libzstd | 6.81 | 12.84 | 1.89 | 79.13 |
| silesia/xml | 5345280 | 3 | stdx | 12.76 | 32.28 | 2.53 | 115.26 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.92 | 32.86 | 3.01 | 145.89 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.38 | 76.49 | 3.42 | 187.81 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.40 | 39.93 | 2.59 | 203.70 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.27 | 73.76 | 2.81 | 332.38 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.78 | 33.59 | 3.43 | 109.32 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.49 | 79.00 | 3.36 | 214.48 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.44 | 40.28 | 2.61 | 207.02 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.13 | 79.30 | 2.82 | 371.56 |
| canterbury/cp.html | 24603 | 1 | libzstd | 7.01 | 26.65 | 3.80 | 39.50 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.04 | 57.76 | 3.60 | 117.83 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.29 | 32.88 | 3.54 | 18.98 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.42 | 59.76 | 3.24 | 136.72 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.74 | 31.77 | 3.63 | 38.37 |
| canterbury/fields.c | 11150 | 1 | stdx | 16.97 | 65.73 | 3.87 | 86.00 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.02 | 34.41 | 3.81 | 9.41 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.32 | 64.68 | 3.74 | 88.02 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.57 | 37.98 | 3.97 | 9.05 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.22 | 77.57 | 3.84 | 53.27 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.66 | 43.28 | 4.06 | 2.56 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.42 | 79.60 | 3.72 | 68.78 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.00 | 23.37 | 3.89 | 14.79 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.66 | 56.75 | 3.87 | 83.81 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.67 | 24.26 | 2.80 | 27.39 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 20.54 | 56.61 | 2.76 | 108.37 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.91 | 28.42 | 2.87 | 160.90 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.36 | 72.02 | 3.37 | 160.27 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 16.91 | 32.77 | 1.94 | 202.50 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.50 | 67.10 | 2.53 | 296.10 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.35 | 32.28 | 3.12 | 130.57 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 24.99 | 84.16 | 3.37 | 157.73 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 20.94 | 39.60 | 1.89 | 226.81 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 31.82 | 80.77 | 2.54 | 342.52 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.17 | 8.48 | 2.67 | 68.42 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.53 | 23.15 | 3.07 | 106.08 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 5.07 | 11.28 | 2.23 | 60.08 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.51 | 24.08 | 2.53 | 132.51 |
| canterbury/sum | 38240 | 1 | libzstd | 6.47 | 25.37 | 3.92 | 28.92 |
| canterbury/sum | 38240 | 1 | stdx | 16.99 | 59.13 | 3.48 | 148.85 |
| canterbury/sum | 38240 | 3 | libzstd | 9.02 | 31.64 | 3.51 | 33.52 |
| canterbury/sum | 38240 | 3 | stdx | 19.95 | 61.82 | 3.10 | 181.54 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 10.03 | 39.84 | 3.97 | 12.81 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.80 | 80.38 | 3.86 | 55.73 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.07 | 48.45 | 4.01 | 2.20 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.83 | 83.98 | 3.68 | 78.48 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.48 | 33.29 | 3.18 | 75.46 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.81 | 95.62 | 4.38 | 7.29 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 15.21 | 31.71 | 2.08 | 35.99 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.88 | 70.38 | 2.95 | 38.40 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.82 | 27.35 | 2.78 | 154.54 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.39 | 71.86 | 3.52 | 109.13 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 18.17 | 28.64 | 1.58 | 134.02 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 28.03 | 63.36 | 2.26 | 156.06 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.18 | 22.62 | 2.77 | 139.82 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.65 | 55.86 | 3.00 | 193.46 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 15.78 | 24.36 | 1.54 | 175.63 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 25.04 | 51.26 | 2.05 | 236.86 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 17.19 | 52.52 | 3.06 | 168.23 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.61 | 100.54 | 2.82 | 637.05 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 19.31 | 59.34 | 3.07 | 206.23 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 37.87 | 104.00 | 2.75 | 630.83 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.85 | 22.47 | 2.86 | 127.80 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.10 | 46.84 | 3.32 | 182.04 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.90 | 24.79 | 2.79 | 146.48 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.31 | 47.61 | 3.11 | 191.43 |
| http/html-1m | 1048576 | 1 | libzstd | 6.31 | 16.66 | 2.64 | 117.17 |
| http/html-1m | 1048576 | 1 | stdx | 12.96 | 42.00 | 3.24 | 134.34 |
| http/html-1m | 1048576 | 3 | libzstd | 9.60 | 18.50 | 1.93 | 125.92 |
| http/html-1m | 1048576 | 3 | stdx | 15.87 | 39.37 | 2.48 | 177.88 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.43 | 42.58 | 2.95 | 119.76 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.39 | 83.13 | 2.83 | 523.80 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.98 | 44.69 | 2.98 | 134.18 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.48 | 84.87 | 2.78 | 529.85 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.82 | 15.00 | 3.11 | 59.30 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.68 | 33.78 | 3.49 | 115.92 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.41 | 16.31 | 3.01 | 73.35 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.59 | 34.58 | 3.26 | 122.45 |
| http/json-1m | 1048576 | 1 | libzstd | 4.07 | 12.47 | 3.06 | 53.34 |
| http/json-1m | 1048576 | 1 | stdx | 9.01 | 30.70 | 3.41 | 85.01 |
| http/json-1m | 1048576 | 3 | libzstd | 6.41 | 14.06 | 2.19 | 68.91 |
| http/json-1m | 1048576 | 3 | stdx | 11.44 | 30.64 | 2.68 | 119.56 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.71 | 57.29 | 3.06 | 195.74 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 39.68 | 113.49 | 2.86 | 689.58 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.64 | 65.62 | 3.03 | 267.90 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 41.93 | 116.54 | 2.78 | 681.14 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 9.00 | 26.53 | 2.95 | 133.63 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.63 | 55.71 | 3.35 | 200.78 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.18 | 28.96 | 2.85 | 157.19 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.64 | 55.35 | 3.14 | 208.98 |
| http/js-1m | 1048576 | 1 | libzstd | 6.61 | 17.80 | 2.69 | 116.42 |
| http/js-1m | 1048576 | 1 | stdx | 13.96 | 45.88 | 3.29 | 136.37 |
| http/js-1m | 1048576 | 3 | libzstd | 10.27 | 19.49 | 1.90 | 124.92 |
| http/js-1m | 1048576 | 3 | stdx | 17.05 | 41.25 | 2.42 | 187.52 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.72 | 46.97 | 2.99 | 143.13 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.12 | 91.65 | 2.85 | 581.51 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.84 | 50.68 | 3.01 | 167.08 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.66 | 93.63 | 2.78 | 580.63 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.23 | 18.99 | 3.05 | 80.50 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.42 | 43.79 | 3.53 | 137.66 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.60 | 19.53 | 2.96 | 94.78 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.84 | 42.34 | 3.30 | 153.15 |
| http/css-1m | 1048576 | 1 | libzstd | 1.51 | 4.57 | 3.02 | 22.14 |
| http/css-1m | 1048576 | 1 | stdx | 3.99 | 14.85 | 3.73 | 30.60 |
| http/css-1m | 1048576 | 3 | libzstd | 2.01 | 5.34 | 2.65 | 19.58 |
| http/css-1m | 1048576 | 3 | stdx | 3.95 | 13.33 | 3.38 | 31.39 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.52 | 12.79 | 3.63 | 6.46 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.07 | 30.66 | 3.38 | 61.58 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 29.54 | 53.05 | 1.80 | 47.60 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 21.07 | 47.43 | 2.25 | 206.66 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.118 | 3.00 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 67.1 | 223.0 | 0.083 | 7.93 | 3.32 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 41.3 | 179.1 | 0.076 | 4.87 | 4.34 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 250.4 | 1024.0 | 0.834 | 29.58 | 4.09 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.5 | 107.5 | 0.143 | 3.60 | 3.53 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.9 | 106.0 | 0.296 | 3.29 | 3.81 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.7 | 378.2 | 0.379 | 11.30 | 3.95 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 42.7 | 161.9 | 0.449 | 5.04 | 3.79 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 89.4 | 451.7 | 0.306 | 10.56 | 5.05 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.0 | 89.5 | 0.004 | 3.98 | 3.31 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.0 | 235.2 | 0.040 | 10.01 | 3.46 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 44.6 | 192.0 | 0.048 | 6.56 | 4.31 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 216.5 | 819.1 | 0.942 | 31.87 | 3.78 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.0 | 107.7 | 0.040 | 4.12 | 3.84 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 29.2 | 105.7 | 0.048 | 4.30 | 3.62 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 93.9 | 346.2 | 0.357 | 13.82 | 3.69 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 33.3 | 144.5 | 0.052 | 4.91 | 4.33 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 88.4 | 406.5 | 0.104 | 13.01 | 4.60 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114371.9 | 403845.2 | 492.062 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 593407.2 | 2503289.2 | 1394.660 | 3.44 | 4.22 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 592948.0 | 2503705.2 | 1399.711 | 3.44 | 4.22 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3555750.6 | 18223876.2 | 2977.670 | 20.61 | 5.13 |
| string: silesia/dickens | 1 | 172528 | simdjson | 310820.1 | 621743.2 | 613.186 | 1.80 | 2.00 |
| string: silesia/dickens | 1 | 172528 | yyjson | 225860.2 | 826618.2 | 2239.278 | 1.31 | 3.66 |
| string: silesia/dickens | 1 | 172528 | std.json | 1609847.5 | 4578768.2 | 43378.351 | 9.33 | 2.84 |
| string: silesia/dickens | 1 | 172528 | serde_json | 205776.9 | 802391.2 | 988.113 | 1.19 | 3.90 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1056586.1 | 5281897.1 | 4923.856 | 6.12 | 5.00 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1566407.9 | 4799762.6 | 1251.071 | 1.32 | 3.06 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14366483.3 | 56816155.6 | 39134.143 | 12.07 | 3.95 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 14478047.9 | 56816485.6 | 39195.571 | 12.16 | 3.92 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 28721784.4 | 132108253.6 | 159659.429 | 24.13 | 4.60 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4579642.0 | 7053838.6 | 542.071 | 3.85 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1792497.6 | 7322017.6 | 14265.429 | 1.51 | 4.08 |
| string: http/json-1m | 1 | 1190272 | std.json | 10329523.7 | 47381213.6 | 32053.214 | 8.68 | 4.59 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3768167.3 | 15226459.6 | 6315.357 | 3.17 | 4.04 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 9215634.7 | 48019837.1 | 28242.214 | 7.74 | 5.21 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2065966.5 | 5765412.8 | 4376.625 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6174761.3 | 22589266.8 | 7126.875 | 3.28 | 3.66 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 6168307.9 | 22589596.8 | 7125.625 | 3.28 | 3.66 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47117465.0 | 227842320.8 | 270463.000 | 25.02 | 4.84 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3679592.3 | 7945848.8 | 1929.750 | 1.95 | 2.16 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7140729.9 | 12276727.8 | 276871.375 | 3.79 | 1.72 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 18186680.8 | 63617055.8 | 220430.125 | 9.66 | 3.50 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9307847.0 | 24440755.8 | 327688.625 | 4.94 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 38964270.1 | 160372101.4 | 819877.375 | 20.69 | 4.12 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12956154.0 | 42561068.3 | 245137.333 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 171991211.3 | 667246750.3 | 391478.333 | 33.89 | 3.88 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 165999811.7 | 667247080.3 | 392187.667 | 32.71 | 4.02 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 159495962.0 | 639992662.3 | 425146.000 | 31.42 | 4.01 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17597572.7 | 49745819.3 | 220332.333 | 3.47 | 2.83 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 13648356.0 | 44816977.3 | 440447.667 | 2.69 | 3.28 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79956562.0 | 314900845.3 | 482834.000 | 15.75 | 3.94 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36584421.0 | 131556135.3 | 570262.000 | 7.21 | 3.60 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66241780.7 | 273933455.7 | 840975.000 | 13.05 | 4.14 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 93896.2 | 303836.7 | 5.935 | 0.18 | 3.24 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 187098.5 | 623468.7 | 11.452 | 0.36 | 3.33 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 185796.9 | 623253.7 | 11.774 | 0.35 | 3.35 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10262132.6 | 53478202.7 | 9.258 | 19.57 | 5.21 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 490643.9 | 1376732.7 | 6.387 | 0.94 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 536688.6 | 2195905.7 | 7.613 | 1.02 | 4.09 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3497801.1 | 12808414.7 | 61338.806 | 6.67 | 3.66 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 285444.3 | 1179969.7 | 5.613 | 0.54 | 4.13 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2258085.6 | 12787936.3 | 254.613 | 4.31 | 5.66 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.5 | 81.8 | 0.109 | 2.30 | 4.20 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.3 | 153.6 | 0.137 | 4.17 | 4.35 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 23.2 | 103.2 | 0.101 | 2.74 | 4.44 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 217.4 | 981.0 | 0.933 | 25.68 | 4.51 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 18.7 | 79.5 | 0.105 | 2.20 | 4.26 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 22.8 | 94.1 | 0.135 | 2.70 | 4.12 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 26.7 | 105.4 | 0.243 | 3.16 | 3.94 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.5 | 310.8 | 0.382 | 8.21 | 4.47 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.3 | 255.3 | 0.483 | 7.48 | 4.03 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.7 | 315.1 | 0.237 | 8.11 | 4.59 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.2 | 82.8 | 0.024 | 2.68 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.1 | 153.9 | 0.026 | 5.32 | 4.26 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 22.9 | 101.7 | 0.024 | 3.37 | 4.44 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 170.2 | 718.3 | 1.304 | 25.05 | 4.22 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 17.9 | 81.5 | 0.024 | 2.63 | 4.56 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.3 | 96.6 | 0.032 | 3.13 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 27.8 | 117.7 | 0.032 | 4.09 | 4.23 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 60.4 | 271.2 | 0.272 | 8.90 | 4.49 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 49.0 | 211.7 | 0.041 | 7.21 | 4.32 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 83.3 | 331.7 | 0.095 | 12.26 | 3.98 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 85221.2 | 280786.2 | 740.423 | 0.49 | 3.29 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84938.2 | 280732.2 | 727.629 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84751.2 | 280724.2 | 722.423 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3321066.3 | 16047574.2 | 2945.598 | 19.25 | 4.83 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 83237.3 | 274401.2 | 675.505 | 0.48 | 3.30 |
| string: silesia/dickens | 1 | 172528 | simdjson | 208774.8 | 674008.2 | 2123.835 | 1.21 | 3.23 |
| string: silesia/dickens | 1 | 172528 | yyjson | 216726.8 | 848559.2 | 1411.588 | 1.26 | 3.92 |
| string: silesia/dickens | 1 | 172528 | std.json | 1368141.9 | 2890892.2 | 55547.309 | 7.93 | 2.11 |
| string: silesia/dickens | 1 | 172528 | serde_json | 368495.2 | 1586249.2 | 2324.351 | 2.14 | 4.30 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 585126.9 | 2970286.8 | 2882.959 | 3.39 | 5.08 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1315169.6 | 3582350.6 | 12971.000 | 1.10 | 2.72 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1299899.9 | 3582290.6 | 12402.929 | 1.09 | 2.76 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1302372.8 | 3582278.6 | 12475.429 | 1.09 | 2.75 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 24985942.9 | 109856348.6 | 141949.286 | 20.99 | 4.40 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1225390.1 | 3370022.6 | 11021.643 | 1.03 | 2.75 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2987037.8 | 10460754.6 | 29135.143 | 2.51 | 3.50 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2664132.5 | 11226214.6 | 9671.857 | 2.24 | 4.21 |
| string: http/json-1m | 1 | 1190272 | std.json | 8888068.1 | 43287986.6 | 15502.500 | 7.47 | 4.87 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4183203.4 | 17941088.6 | 11175.643 | 3.51 | 4.29 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5255520.6 | 26999739.2 | 11182.571 | 4.42 | 5.14 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2073466.8 | 6088099.8 | 4699.875 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2066037.3 | 6088039.8 | 4185.250 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2062691.4 | 6088027.8 | 4093.500 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43433173.9 | 193466548.8 | 261995.375 | 23.07 | 4.45 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2068742.1 | 5875346.8 | 4689.375 | 1.10 | 2.84 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2711134.1 | 7144135.8 | 20868.000 | 1.44 | 2.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12416950.1 | 26334410.8 | 416559.625 | 6.59 | 2.12 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20329165.0 | 56837736.8 | 544246.875 | 10.80 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11422611.8 | 33662338.8 | 338002.125 | 6.07 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18313191.3 | 76319546.9 | 253973.000 | 9.73 | 4.17 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 112913.7 | 426376.7 | 3.516 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 112663.0 | 426318.7 | 1.516 | 0.21 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 112653.2 | 426299.7 | 1.645 | 0.21 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 635850.7 | 3146479.7 | 3.968 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 112684.7 | 426343.7 | 4.871 | 0.21 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1242343.8 | 3866907.7 | 4.581 | 2.37 | 3.11 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1660136.7 | 5833344.7 | 4.355 | 3.17 | 3.51 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3549795.5 | 13108830.7 | 74811.484 | 6.77 | 3.69 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1823218.8 | 7405810.7 | 4.323 | 3.48 | 4.06 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2390388.1 | 12748306.8 | 19.000 | 4.56 | 5.33 |
