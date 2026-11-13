# bench-profile

| Field | Value |
|---|---|
| Commit | c695b3e |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261101.172.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43144950644 |
| Date | 2026-11-12 |

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
| silesia/dickens | 10192446 | zlib | 8.79 | 19.08 | 2.17 | 309.52 |
| silesia/dickens | 10192446 | zlib-ng | 4.87 | 10.50 | 2.16 | 68.06 |
| silesia/dickens | 10192446 | libdeflate | 3.45 | 9.56 | 2.78 | 66.07 |
| silesia/dickens | 10192446 | Wuffs | 5.52 | 13.90 | 2.52 | 97.51 |
| silesia/dickens | 10192446 | stdx | 2.91 | 7.15 | 2.45 | 75.87 |
| silesia/mozilla | 51220480 | zlib | 8.47 | 17.23 | 2.03 | 250.40 |
| silesia/mozilla | 51220480 | zlib-ng | 4.95 | 8.95 | 1.81 | 85.92 |
| silesia/mozilla | 51220480 | libdeflate | 3.47 | 7.63 | 2.20 | 71.15 |
| silesia/mozilla | 51220480 | Wuffs | 6.41 | 13.89 | 2.17 | 133.08 |
| silesia/mozilla | 51220480 | stdx | 3.62 | 6.29 | 1.74 | 89.22 |
| silesia/mr | 9970564 | zlib | 8.36 | 18.46 | 2.21 | 201.46 |
| silesia/mr | 9970564 | zlib-ng | 4.78 | 9.98 | 2.09 | 68.01 |
| silesia/mr | 9970564 | libdeflate | 3.34 | 8.58 | 2.57 | 61.08 |
| silesia/mr | 9970564 | Wuffs | 5.98 | 14.04 | 2.35 | 99.99 |
| silesia/mr | 9970564 | stdx | 3.06 | 6.70 | 2.19 | 69.58 |
| silesia/nci | 33553445 | zlib | 3.54 | 10.18 | 2.88 | 81.35 |
| silesia/nci | 33553445 | zlib-ng | 1.59 | 3.13 | 1.97 | 35.34 |
| silesia/nci | 33553445 | libdeflate | 1.13 | 2.66 | 2.36 | 29.72 |
| silesia/nci | 33553445 | Wuffs | 2.45 | 6.47 | 2.64 | 41.33 |
| silesia/nci | 33553445 | stdx | 1.13 | 2.20 | 1.94 | 37.09 |
| silesia/ooffice | 6152192 | zlib | 11.73 | 21.06 | 1.80 | 413.48 |
| silesia/ooffice | 6152192 | zlib-ng | 6.92 | 12.04 | 1.74 | 141.66 |
| silesia/ooffice | 6152192 | libdeflate | 4.90 | 10.45 | 2.13 | 125.63 |
| silesia/ooffice | 6152192 | Wuffs | 8.80 | 17.54 | 1.99 | 220.90 |
| silesia/ooffice | 6152192 | stdx | 5.06 | 8.55 | 1.69 | 150.90 |
| silesia/osdb | 10085684 | zlib | 7.44 | 16.59 | 2.23 | 182.17 |
| silesia/osdb | 10085684 | zlib-ng | 4.30 | 8.38 | 1.95 | 54.85 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.91 | 2.43 | 29.92 |
| silesia/osdb | 10085684 | Wuffs | 5.81 | 13.61 | 2.34 | 80.30 |
| silesia/osdb | 10085684 | stdx | 2.77 | 5.65 | 2.04 | 40.62 |
| silesia/reymont | 6627202 | zlib | 7.37 | 15.89 | 2.16 | 260.01 |
| silesia/reymont | 6627202 | zlib-ng | 3.70 | 7.72 | 2.08 | 59.75 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.31 |
| silesia/reymont | 6627202 | Wuffs | 4.88 | 11.40 | 2.33 | 113.27 |
| silesia/reymont | 6627202 | stdx | 2.28 | 5.11 | 2.24 | 63.93 |
| silesia/samba | 21606400 | zlib | 6.10 | 14.13 | 2.31 | 174.99 |
| silesia/samba | 21606400 | zlib-ng | 3.37 | 6.47 | 1.92 | 58.21 |
| silesia/samba | 21606400 | libdeflate | 2.30 | 5.58 | 2.42 | 42.89 |
| silesia/samba | 21606400 | Wuffs | 4.31 | 10.39 | 2.41 | 79.54 |
| silesia/samba | 21606400 | stdx | 2.25 | 4.46 | 1.99 | 56.11 |
| silesia/sao | 7251944 | zlib | 10.49 | 23.54 | 2.24 | 205.08 |
| silesia/sao | 7251944 | zlib-ng | 7.83 | 14.83 | 1.89 | 79.21 |
| silesia/sao | 7251944 | libdeflate | 5.73 | 12.73 | 2.22 | 79.27 |
| silesia/sao | 7251944 | Wuffs | 8.88 | 21.26 | 2.39 | 86.30 |
| silesia/sao | 7251944 | stdx | 5.55 | 10.32 | 1.86 | 87.23 |
| silesia/webster | 41458703 | zlib | 7.74 | 16.16 | 2.09 | 279.73 |
| silesia/webster | 41458703 | zlib-ng | 4.20 | 8.04 | 1.92 | 84.95 |
| silesia/webster | 41458703 | libdeflate | 2.85 | 7.17 | 2.51 | 68.52 |
| silesia/webster | 41458703 | Wuffs | 5.13 | 11.67 | 2.28 | 122.32 |
| silesia/webster | 41458703 | stdx | 2.68 | 5.56 | 2.07 | 86.88 |
| silesia/x-ray | 8474240 | zlib | 12.84 | 27.21 | 2.12 | 327.96 |
| silesia/x-ray | 8474240 | zlib-ng | 9.01 | 17.39 | 1.93 | 124.19 |
| silesia/x-ray | 8474240 | libdeflate | 6.52 | 15.26 | 2.34 | 124.76 |
| silesia/x-ray | 8474240 | Wuffs | 10.80 | 23.52 | 2.18 | 190.76 |
| silesia/x-ray | 8474240 | stdx | 6.11 | 11.49 | 1.88 | 138.12 |
| silesia/xml | 5345280 | zlib | 4.21 | 11.16 | 2.65 | 117.46 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.84 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.44 | 31.90 |
| silesia/xml | 5345280 | Wuffs | 2.83 | 7.22 | 2.55 | 59.04 |
| silesia/xml | 5345280 | stdx | 1.33 | 2.65 | 2.00 | 41.71 |
| canterbury/alice29.txt | 152089 | zlib | 8.42 | 18.35 | 2.18 | 293.61 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.58 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.18 | 8.96 | 2.82 | 54.01 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.38 | 13.40 | 2.49 | 98.32 |
| canterbury/alice29.txt | 152089 | stdx | 2.70 | 6.99 | 2.59 | 61.91 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.02 | 19.42 | 2.15 | 313.92 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.11 | 10.86 | 2.13 | 75.27 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.58 | 9.82 | 2.74 | 66.64 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.76 | 14.40 | 2.50 | 100.13 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.06 | 7.52 | 2.45 | 77.02 |
| canterbury/cp.html | 24603 | zlib | 7.08 | 17.33 | 2.45 | 171.44 |
| canterbury/cp.html | 24603 | zlib-ng | 4.32 | 9.50 | 2.20 | 47.00 |
| canterbury/cp.html | 24603 | libdeflate | 2.86 | 7.95 | 2.78 | 16.85 |
| canterbury/cp.html | 24603 | Wuffs | 5.24 | 13.91 | 2.65 | 62.29 |
| canterbury/cp.html | 24603 | stdx | 2.73 | 7.19 | 2.64 | 19.08 |
| canterbury/fields.c | 11150 | zlib | 5.33 | 17.73 | 3.33 | 42.78 |
| canterbury/fields.c | 11150 | zlib-ng | 4.02 | 10.20 | 2.54 | 24.65 |
| canterbury/fields.c | 11150 | libdeflate | 2.78 | 8.32 | 2.99 | 1.60 |
| canterbury/fields.c | 11150 | Wuffs | 4.51 | 14.54 | 3.22 | 9.45 |
| canterbury/fields.c | 11150 | stdx | 2.52 | 7.64 | 3.03 | 6.10 |
| canterbury/grammar.lsp | 3721 | zlib | 6.93 | 24.26 | 3.50 | 8.60 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.88 | 17.48 | 2.97 | 10.86 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.40 | 12.05 | 2.74 | 0.68 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.67 | 21.86 | 3.28 | 3.49 |
| canterbury/grammar.lsp | 3721 | stdx | 3.85 | 12.18 | 3.17 | 1.30 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.59 | 15.27 | 3.33 | 48.30 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.62 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.17 | 9.16 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.87 | 11.59 | 3.00 | 14.86 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.74 | 4.66 | 2.67 | 16.43 |
| canterbury/lcet10.txt | 426754 | zlib | 8.20 | 17.78 | 2.17 | 289.08 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.31 | 9.39 | 2.18 | 60.25 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 54.90 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.21 | 12.88 | 2.47 | 100.98 |
| canterbury/lcet10.txt | 426754 | stdx | 2.58 | 6.42 | 2.49 | 66.11 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.19 | 19.86 | 2.16 | 320.93 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.27 | 11.19 | 2.12 | 76.90 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.78 | 10.19 | 2.70 | 77.47 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.83 | 14.61 | 2.51 | 100.54 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.15 | 7.63 | 2.42 | 85.22 |
| canterbury/ptt5 | 513216 | zlib | 5.05 | 10.71 | 2.12 | 103.68 |
| canterbury/ptt5 | 513216 | zlib-ng | 1.99 | 3.74 | 1.88 | 46.99 |
| canterbury/ptt5 | 513216 | libdeflate | 1.44 | 3.02 | 2.10 | 37.53 |
| canterbury/ptt5 | 513216 | Wuffs | 3.01 | 7.13 | 2.37 | 57.64 |
| canterbury/ptt5 | 513216 | stdx | 1.44 | 2.55 | 1.77 | 48.64 |
| canterbury/sum | 38240 | zlib | 8.03 | 18.12 | 2.26 | 226.53 |
| canterbury/sum | 38240 | zlib-ng | 4.71 | 10.02 | 2.13 | 61.14 |
| canterbury/sum | 38240 | libdeflate | 3.38 | 8.34 | 2.47 | 42.04 |
| canterbury/sum | 38240 | Wuffs | 5.84 | 14.47 | 2.48 | 83.74 |
| canterbury/sum | 38240 | stdx | 3.15 | 7.73 | 2.45 | 39.40 |
| canterbury/xargs.1 | 4227 | zlib | 7.47 | 25.22 | 3.38 | 15.38 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.47 | 17.97 | 2.78 | 16.49 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.78 | 13.27 | 2.78 | 2.24 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.19 | 22.63 | 3.15 | 9.17 |
| canterbury/xargs.1 | 4227 | stdx | 4.23 | 12.86 | 3.04 | 2.27 |
| canterbury-large/E.coli | 4638690 | zlib | 6.77 | 17.84 | 2.63 | 177.92 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.23 | 9.68 | 2.29 | 47.79 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.93 | 48.26 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.66 | 12.73 | 2.73 | 61.37 |
| canterbury-large/E.coli | 4638690 | stdx | 2.47 | 6.72 | 2.72 | 53.58 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.50 | 16.46 | 2.19 | 265.67 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.77 | 8.26 | 2.19 | 53.42 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.84 | 45.55 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.79 | 11.73 | 2.45 | 100.27 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.23 | 5.57 | 2.50 | 55.60 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.71 | 15.84 | 2.05 | 281.40 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.19 | 7.78 | 1.86 | 91.70 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.88 | 6.92 | 2.40 | 75.04 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.17 | 11.48 | 2.22 | 127.78 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 5.40 | 1.99 | 90.28 |
| http/html-1kx1024 | 1048576 | zlib | 16.73 | 35.58 | 2.13 | 354.79 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.68 | 28.43 | 2.24 | 217.01 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.58 | 20.05 | 1.90 | 155.78 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.36 | 38.07 | 2.48 | 265.81 |
| http/html-1kx1024 | 1048576 | stdx | 8.39 | 20.88 | 2.49 | 137.56 |
| http/html-16kx64 | 1048576 | zlib | 6.73 | 14.77 | 2.19 | 222.25 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.86 | 7.54 | 1.96 | 85.55 |
| http/html-16kx64 | 1048576 | libdeflate | 2.63 | 6.04 | 2.29 | 60.45 |
| http/html-16kx64 | 1048576 | Wuffs | 4.92 | 11.57 | 2.35 | 115.10 |
| http/html-16kx64 | 1048576 | stdx | 2.51 | 5.56 | 2.22 | 59.16 |
| http/html-1m | 1048576 | zlib | 5.30 | 12.53 | 2.37 | 175.12 |
| http/html-1m | 1048576 | zlib-ng | 2.62 | 5.03 | 1.92 | 60.31 |
| http/html-1m | 1048576 | libdeflate | 1.69 | 4.39 | 2.59 | 37.21 |
| http/html-1m | 1048576 | Wuffs | 3.60 | 8.48 | 2.35 | 87.68 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.11 | 52.36 |
| http/json-1kx1024 | 1048576 | zlib | 10.61 | 23.92 | 2.25 | 193.28 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.44 | 16.69 | 2.24 | 132.67 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.85 | 16.72 | 1.89 | 92.53 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.12 | 34.78 | 2.87 | 146.29 |
| http/json-1kx1024 | 1048576 | stdx | 5.02 | 13.12 | 2.61 | 80.81 |
| http/json-16kx64 | 1048576 | zlib | 4.56 | 12.51 | 2.74 | 102.75 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.64 | 5.50 | 2.08 | 53.17 |
| http/json-16kx64 | 1048576 | libdeflate | 1.92 | 4.24 | 2.21 | 40.67 |
| http/json-16kx64 | 1048576 | Wuffs | 3.50 | 9.43 | 2.70 | 57.63 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.26 | 39.46 |
| http/json-1m | 1048576 | zlib | 3.84 | 11.20 | 2.92 | 82.93 |
| http/json-1m | 1048576 | zlib-ng | 1.96 | 3.91 | 1.99 | 39.91 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.75 |
| http/json-1m | 1048576 | Wuffs | 2.73 | 7.37 | 2.70 | 43.19 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.02 | 39.95 |
| http/js-1kx1024 | 1048576 | zlib | 18.26 | 38.46 | 2.11 | 412.44 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.78 | 31.25 | 2.27 | 239.21 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.27 | 21.58 | 1.92 | 179.18 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.51 | 40.70 | 2.47 | 299.37 |
| http/js-1kx1024 | 1048576 | stdx | 9.27 | 22.85 | 2.47 | 159.21 |
| http/js-16kx64 | 1048576 | zlib | 7.68 | 16.08 | 2.09 | 265.65 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.98 | 91.81 |
| http/js-16kx64 | 1048576 | libdeflate | 3.06 | 7.01 | 2.29 | 72.41 |
| http/js-16kx64 | 1048576 | Wuffs | 5.51 | 12.75 | 2.32 | 128.74 |
| http/js-16kx64 | 1048576 | stdx | 3.00 | 6.54 | 2.18 | 72.15 |
| http/js-1m | 1048576 | zlib | 5.85 | 13.31 | 2.27 | 200.04 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 59.96 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.97 |
| http/js-1m | 1048576 | Wuffs | 3.90 | 9.14 | 2.34 | 93.87 |
| http/js-1m | 1048576 | stdx | 1.81 | 3.89 | 2.15 | 55.18 |
| http/css-1kx1024 | 1048576 | zlib | 14.02 | 30.36 | 2.17 | 280.00 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.25 | 23.04 | 2.25 | 170.84 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.16 | 17.37 | 1.90 | 120.81 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.77 | 32.50 | 2.54 | 211.75 |
| http/css-1kx1024 | 1048576 | stdx | 6.67 | 17.64 | 2.64 | 100.71 |
| http/css-16kx64 | 1048576 | zlib | 5.31 | 13.04 | 2.46 | 152.77 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.81 | 6.07 | 2.16 | 52.63 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 30.36 |
| http/css-16kx64 | 1048576 | Wuffs | 3.78 | 10.01 | 2.65 | 69.16 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.53 | 28.57 |
| http/css-1m | 1048576 | zlib | 3.97 | 10.97 | 2.76 | 107.11 |
| http/css-1m | 1048576 | zlib-ng | 1.72 | 3.75 | 2.18 | 30.90 |
| http/css-1m | 1048576 | libdeflate | 1.08 | 3.18 | 2.96 | 13.10 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.78 | 43.31 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.52 | 21.18 |
| shuffled/dickens-1m | 1048576 | zlib | 13.32 | 25.88 | 1.94 | 374.04 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.75 | 16.72 | 1.72 | 199.40 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.03 | 14.95 | 2.13 | 194.83 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.39 | 22.08 | 2.13 | 204.25 |
| shuffled/dickens-1m | 1048576 | stdx | 7.03 | 11.89 | 1.69 | 206.20 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.57 | 14.05 | 3.94 | 3.44 |
| silesia/dickens | 10192446 | stdx | 3.73 | 12.47 | 3.34 | 3.52 |
| silesia/mozilla | 51220480 | libzstd | 2.84 | 9.68 | 3.41 | 30.18 |
| silesia/mozilla | 51220480 | stdx | 2.85 | 9.68 | 3.39 | 15.86 |
| silesia/mr | 9970564 | libzstd | 3.00 | 11.99 | 3.99 | 6.16 |
| silesia/mr | 9970564 | stdx | 3.07 | 10.83 | 3.53 | 5.17 |
| silesia/nci | 33553445 | libzstd | 1.62 | 4.88 | 3.01 | 24.80 |
| silesia/nci | 33553445 | stdx | 1.61 | 4.63 | 2.87 | 13.62 |
| silesia/ooffice | 6152192 | libzstd | 3.35 | 12.19 | 3.64 | 31.02 |
| silesia/ooffice | 6152192 | stdx | 3.33 | 12.40 | 3.72 | 12.05 |
| silesia/osdb | 10085684 | libzstd | 2.37 | 8.45 | 3.57 | 14.98 |
| silesia/osdb | 10085684 | stdx | 2.42 | 8.11 | 3.35 | 15.38 |
| silesia/reymont | 6627202 | libzstd | 3.24 | 11.62 | 3.59 | 11.65 |
| silesia/reymont | 6627202 | stdx | 3.38 | 10.36 | 3.06 | 12.80 |
| silesia/samba | 21606400 | libzstd | 2.04 | 7.41 | 3.63 | 18.66 |
| silesia/samba | 21606400 | stdx | 2.11 | 6.83 | 3.24 | 17.80 |
| silesia/sao | 7251944 | libzstd | 3.72 | 12.72 | 3.42 | 26.68 |
| silesia/sao | 7251944 | stdx | 3.45 | 12.58 | 3.64 | 6.34 |
| silesia/webster | 41458703 | libzstd | 3.19 | 11.24 | 3.53 | 16.26 |
| silesia/webster | 41458703 | stdx | 3.31 | 10.05 | 3.04 | 17.79 |
| silesia/x-ray | 8474240 | libzstd | 3.86 | 14.94 | 3.87 | 18.93 |
| silesia/x-ray | 8474240 | stdx | 3.54 | 13.23 | 3.74 | 8.26 |
| silesia/xml | 5345280 | libzstd | 1.57 | 5.57 | 3.56 | 23.24 |
| silesia/xml | 5345280 | stdx | 1.55 | 5.16 | 3.33 | 17.18 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.90 | 4.09 |
| canterbury/alice29.txt | 152089 | stdx | 3.30 | 14.41 | 4.36 | 0.45 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.95 | 14.26 | 4.83 | 3.24 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.99 | 12.83 | 4.30 | 0.25 |
| canterbury/cp.html | 24603 | libzstd | 2.62 | 10.74 | 4.09 | 7.05 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.11 | 0.16 |
| canterbury/fields.c | 11150 | libzstd | 3.12 | 13.62 | 4.37 | 9.00 |
| canterbury/fields.c | 11150 | stdx | 3.00 | 12.72 | 4.24 | 0.19 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.18 | 16.94 | 4.05 | 4.67 |
| canterbury/grammar.lsp | 3721 | stdx | 4.12 | 16.54 | 4.01 | 0.15 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.53 | 11.40 | 4.51 | 7.80 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.68 | 11.32 | 4.22 | 0.92 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.70 | 12.89 | 4.77 | 5.14 |
| canterbury/lcet10.txt | 426754 | stdx | 2.73 | 11.52 | 4.22 | 4.07 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.10 | 15.16 | 4.90 | 1.53 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.16 | 13.51 | 4.27 | 0.80 |
| canterbury/ptt5 | 513216 | libzstd | 1.45 | 4.52 | 3.11 | 25.15 |
| canterbury/ptt5 | 513216 | stdx | 1.34 | 4.46 | 3.34 | 13.24 |
| canterbury/sum | 38240 | libzstd | 2.61 | 10.58 | 4.06 | 9.28 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.09 | 0.24 |
| canterbury/xargs.1 | 4227 | libzstd | 4.24 | 17.41 | 4.11 | 8.80 |
| canterbury/xargs.1 | 4227 | stdx | 4.26 | 17.17 | 4.03 | 0.34 |
| canterbury-large/E.coli | 4638690 | libzstd | 3.07 | 13.64 | 4.44 | 2.14 |
| canterbury-large/E.coli | 4638690 | stdx | 3.19 | 12.04 | 3.78 | 2.88 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.99 | 12.00 | 4.02 | 8.46 |
| canterbury-large/bible.txt | 4047392 | stdx | 3.09 | 10.64 | 3.44 | 9.34 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.55 | 9.60 | 3.76 | 19.94 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.63 | 8.64 | 3.29 | 21.01 |
| http/html-1kx1024 | 1048576 | libzstd | 7.25 | 21.63 | 2.98 | 63.29 |
| http/html-1kx1024 | 1048576 | stdx | 7.46 | 22.46 | 3.01 | 76.78 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.68 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 9.61 | 3.61 | 30.32 |
| http/html-1m | 1048576 | libzstd | 2.04 | 7.88 | 3.87 | 24.48 |
| http/html-1m | 1048576 | stdx | 2.06 | 7.12 | 3.45 | 24.82 |
| http/json-1kx1024 | 1048576 | libzstd | 6.27 | 17.39 | 2.77 | 49.65 |
| http/json-1kx1024 | 1048576 | stdx | 6.20 | 17.86 | 2.88 | 53.35 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.26 | 3.54 | 28.32 |
| http/json-16kx64 | 1048576 | stdx | 2.02 | 7.25 | 3.58 | 19.68 |
| http/json-1m | 1048576 | libzstd | 1.73 | 6.08 | 3.52 | 27.81 |
| http/json-1m | 1048576 | stdx | 1.64 | 5.91 | 3.59 | 14.66 |
| http/js-1kx1024 | 1048576 | libzstd | 8.33 | 26.35 | 3.16 | 73.36 |
| http/js-1kx1024 | 1048576 | stdx | 9.04 | 27.60 | 3.05 | 113.27 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.72 | 4.00 | 24.57 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.73 | 26.77 |
| http/js-1m | 1048576 | libzstd | 2.04 | 8.19 | 4.01 | 20.49 |
| http/js-1m | 1048576 | stdx | 2.10 | 7.48 | 3.57 | 21.77 |
| http/css-1kx1024 | 1048576 | libzstd | 6.88 | 19.69 | 2.86 | 53.31 |
| http/css-1kx1024 | 1048576 | stdx | 6.85 | 19.96 | 2.91 | 64.12 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.70 | 3.88 | 22.56 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.05 |
| http/css-1m | 1048576 | libzstd | 0.67 | 2.58 | 3.84 | 5.40 |
| http/css-1m | 1048576 | stdx | 0.71 | 2.49 | 3.49 | 3.45 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.77 | 9.40 | 3.39 | 28.51 |
| shuffled/dickens-1m | 1048576 | stdx | 2.74 | 9.19 | 3.36 | 12.77 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.55 | 16.93 | 2.24 | 100.07 |
| silesia/dickens | 1048576 | stdx | 5.09 | 12.38 | 2.43 | 54.42 |
| silesia/mozilla | 1048576 | Google | 13.46 | 28.31 | 2.10 | 46.60 |
| silesia/mozilla | 1048576 | stdx | 8.34 | 15.02 | 1.80 | 47.88 |
| silesia/mr | 1048576 | Google | 8.91 | 20.21 | 2.27 | 102.79 |
| silesia/mr | 1048576 | stdx | 5.82 | 13.25 | 2.28 | 88.13 |
| silesia/nci | 1048576 | Google | 2.55 | 5.70 | 2.23 | 51.92 |
| silesia/nci | 1048576 | stdx | 1.95 | 3.95 | 2.02 | 54.91 |
| silesia/ooffice | 1048576 | Google | 14.17 | 29.27 | 2.07 | 288.87 |
| silesia/ooffice | 1048576 | stdx | 10.90 | 20.33 | 1.86 | 323.76 |
| silesia/osdb | 1048576 | Google | 8.25 | 17.48 | 2.12 | 95.88 |
| silesia/osdb | 1048576 | stdx | 5.18 | 10.57 | 2.04 | 91.98 |
| silesia/reymont | 1048576 | Google | 5.44 | 12.62 | 2.32 | 82.60 |
| silesia/reymont | 1048576 | stdx | 3.72 | 9.25 | 2.48 | 47.57 |
| silesia/samba | 1048576 | Google | 7.58 | 16.30 | 2.15 | 95.02 |
| silesia/samba | 1048576 | stdx | 5.07 | 10.71 | 2.11 | 67.38 |
| silesia/sao | 1048576 | Google | 16.81 | 37.18 | 2.21 | 163.24 |
| silesia/sao | 1048576 | stdx | 10.43 | 22.65 | 2.17 | 142.35 |
| silesia/webster | 1048576 | Google | 6.54 | 14.00 | 2.14 | 113.82 |
| silesia/webster | 1048576 | stdx | 4.42 | 9.98 | 2.26 | 68.63 |
| silesia/x-ray | 1048576 | Google | 19.49 | 38.56 | 1.98 | 234.70 |
| silesia/x-ray | 1048576 | stdx | 14.58 | 30.18 | 2.07 | 234.66 |
| silesia/xml | 1048576 | Google | 3.45 | 7.61 | 2.21 | 65.26 |
| silesia/xml | 1048576 | stdx | 2.42 | 5.40 | 2.23 | 46.89 |
| canterbury/alice29.txt | 152089 | Google | 8.84 | 20.55 | 2.32 | 133.58 |
| canterbury/alice29.txt | 152089 | stdx | 6.05 | 15.33 | 2.53 | 79.75 |
| canterbury/asyoulik.txt | 125179 | Google | 10.35 | 23.71 | 2.29 | 167.30 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.07 | 17.43 | 2.47 | 103.21 |
| canterbury/cp.html | 24603 | Google | 8.99 | 22.20 | 2.47 | 107.63 |
| canterbury/cp.html | 24603 | stdx | 5.93 | 17.15 | 2.89 | 42.54 |
| canterbury/fields.c | 11150 | Google | 7.07 | 21.16 | 3.00 | 25.07 |
| canterbury/fields.c | 11150 | stdx | 4.88 | 17.08 | 3.50 | 1.20 |
| canterbury/grammar.lsp | 3721 | Google | 9.81 | 30.16 | 3.07 | 5.74 |
| canterbury/grammar.lsp | 3721 | stdx | 7.17 | 25.04 | 3.49 | 0.39 |
| canterbury/kennedy.xls | 1029744 | Google | 5.45 | 17.05 | 3.13 | 37.38 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.81 | 12.94 | 3.40 | 33.97 |
| canterbury/lcet10.txt | 426754 | Google | 7.72 | 17.36 | 2.25 | 125.90 |
| canterbury/lcet10.txt | 426754 | stdx | 5.20 | 12.96 | 2.49 | 66.34 |
| canterbury/plrabn12.txt | 481861 | Google | 9.07 | 20.82 | 2.29 | 132.82 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.19 | 15.04 | 2.43 | 86.85 |
| canterbury/ptt5 | 513216 | Google | 4.28 | 10.41 | 2.43 | 62.04 |
| canterbury/ptt5 | 513216 | stdx | 2.37 | 4.89 | 2.06 | 65.78 |
| canterbury/sum | 38240 | Google | 10.81 | 26.44 | 2.45 | 156.81 |
| canterbury/sum | 38240 | stdx | 8.37 | 21.11 | 2.52 | 158.25 |
| canterbury/xargs.1 | 4227 | Google | 11.04 | 34.81 | 3.15 | 12.99 |
| canterbury/xargs.1 | 4227 | stdx | 8.53 | 30.44 | 3.57 | 6.35 |
| canterbury-large/E.coli | 1048576 | Google | 8.20 | 19.55 | 2.39 | 5.42 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.48 |
| canterbury-large/bible.txt | 1048576 | Google | 5.35 | 12.28 | 2.30 | 80.64 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.55 | 8.93 | 2.51 | 39.71 |
| canterbury-large/world192.txt | 1048576 | Google | 6.21 | 12.84 | 2.07 | 114.74 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.41 | 9.38 | 2.13 | 77.51 |
| http/html-1kx1024 | 1048576 | Google | 18.03 | 41.93 | 2.33 | 387.07 |
| http/html-1kx1024 | 1048576 | stdx | 15.33 | 37.56 | 2.45 | 362.21 |
| http/html-16kx64 | 1048576 | Google | 6.72 | 14.85 | 2.21 | 149.02 |
| http/html-16kx64 | 1048576 | stdx | 5.16 | 12.15 | 2.36 | 114.35 |
| http/html-1m | 1048576 | Google | 4.04 | 8.94 | 2.21 | 83.07 |
| http/html-1m | 1048576 | stdx | 2.87 | 6.52 | 2.27 | 55.05 |
| http/json-1kx1024 | 1048576 | Google | 14.45 | 36.64 | 2.54 | 240.93 |
| http/json-1kx1024 | 1048576 | stdx | 13.01 | 33.63 | 2.58 | 277.27 |
| http/json-16kx64 | 1048576 | Google | 4.41 | 11.43 | 2.59 | 81.43 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.20 |
| http/json-1m | 1048576 | Google | 3.40 | 8.65 | 2.55 | 58.88 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.44 | 57.78 |
| http/js-1kx1024 | 1048576 | Google | 19.94 | 46.20 | 2.32 | 429.62 |
| http/js-1kx1024 | 1048576 | stdx | 16.43 | 39.90 | 2.43 | 381.84 |
| http/js-16kx64 | 1048576 | Google | 8.03 | 17.73 | 2.21 | 167.37 |
| http/js-16kx64 | 1048576 | stdx | 6.04 | 14.36 | 2.38 | 125.18 |
| http/js-1m | 1048576 | Google | 4.36 | 9.54 | 2.19 | 82.95 |
| http/js-1m | 1048576 | stdx | 3.18 | 7.25 | 2.28 | 55.39 |
| http/css-1kx1024 | 1048576 | Google | 15.47 | 37.36 | 2.42 | 292.71 |
| http/css-1kx1024 | 1048576 | stdx | 13.79 | 34.70 | 2.52 | 302.33 |
| http/css-16kx64 | 1048576 | Google | 4.94 | 11.76 | 2.38 | 101.86 |
| http/css-16kx64 | 1048576 | stdx | 3.83 | 9.54 | 2.49 | 80.51 |
| http/css-1m | 1048576 | Google | 2.44 | 9.42 | 3.87 | 16.87 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.47 | 11.85 |
| shuffled/dickens-1m | 1048576 | Google | 10.16 | 20.65 | 2.03 | 109.19 |
| shuffled/dickens-1m | 1048576 | stdx | 8.73 | 14.53 | 1.66 | 114.28 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.15 | 36.91 | 2.44 | 410.52 |
| silesia/dickens | 10192446 | 1 | stdx | 16.07 | 38.17 | 2.37 | 358.69 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.07 | 87.63 | 1.68 | 698.50 |
| silesia/dickens | 10192446 | 6 | stdx | 49.17 | 84.26 | 1.71 | 1419.23 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.79 | 160.47 | 1.44 | 931.78 |
| silesia/dickens | 10192446 | 9 | stdx | 84.58 | 191.80 | 2.27 | 1717.38 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.12 | 32.62 | 2.31 | 440.17 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.30 | 30.24 | 2.27 | 294.78 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.86 | 70.83 | 2.16 | 579.14 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.54 | 69.96 | 2.22 | 734.49 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.54 | 221.49 | 1.74 | 768.15 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.99 | 126.12 | 2.57 | 788.96 |
| silesia/mr | 9970564 | 1 | libdeflate | 11.91 | 35.02 | 2.94 | 230.49 |
| silesia/mr | 9970564 | 1 | stdx | 12.32 | 34.08 | 2.77 | 186.86 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.15 | 80.54 | 2.11 | 436.24 |
| silesia/mr | 9970564 | 6 | stdx | 39.44 | 83.18 | 2.11 | 960.89 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.62 | 165.48 | 1.70 | 755.62 |
| silesia/mr | 9970564 | 9 | stdx | 86.93 | 206.31 | 2.37 | 1328.99 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.20 | 18.42 | 2.97 | 117.33 |
| silesia/nci | 33553445 | 1 | stdx | 4.81 | 10.88 | 2.26 | 97.65 |
| silesia/nci | 33553445 | 6 | libdeflate | 16.92 | 34.84 | 2.06 | 226.96 |
| silesia/nci | 33553445 | 6 | stdx | 14.25 | 29.54 | 2.07 | 391.16 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.38 | 105.28 | 1.69 | 498.98 |
| silesia/nci | 33553445 | 9 | stdx | 33.09 | 80.63 | 2.44 | 648.82 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.88 | 39.15 | 1.97 | 754.34 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.51 | 39.08 | 2.23 | 428.90 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 40.87 | 79.10 | 1.94 | 953.19 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.29 | 87.83 | 2.13 | 1005.86 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.49 | 127.63 | 1.71 | 1132.98 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.23 | 129.17 | 2.47 | 936.77 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.86 | 30.15 | 2.34 | 355.95 |
| silesia/osdb | 10085684 | 1 | stdx | 12.65 | 27.86 | 2.20 | 294.23 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.20 | 55.67 | 1.97 | 492.85 |
| silesia/osdb | 10085684 | 6 | stdx | 26.87 | 57.40 | 2.14 | 570.84 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.91 | 64.15 | 1.89 | 555.22 |
| silesia/osdb | 10085684 | 9 | stdx | 35.19 | 87.23 | 2.48 | 691.63 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.56 | 32.88 | 2.62 | 310.75 |
| silesia/reymont | 6627202 | 1 | stdx | 13.19 | 33.24 | 2.52 | 271.23 |
| silesia/reymont | 6627202 | 6 | libdeflate | 47.95 | 86.58 | 1.81 | 520.69 |
| silesia/reymont | 6627202 | 6 | stdx | 44.95 | 76.82 | 1.71 | 1421.79 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.03 | 276.14 | 1.39 | 829.82 |
| silesia/reymont | 6627202 | 9 | stdx | 86.87 | 189.97 | 2.19 | 1608.00 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.40 | 26.53 | 2.55 | 273.32 |
| silesia/samba | 21606400 | 1 | stdx | 9.66 | 22.23 | 2.30 | 220.94 |
| silesia/samba | 21606400 | 6 | libdeflate | 28.86 | 58.79 | 2.04 | 386.02 |
| silesia/samba | 21606400 | 6 | stdx | 23.97 | 49.84 | 2.08 | 623.05 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.15 | 141.44 | 1.68 | 503.62 |
| silesia/samba | 21606400 | 9 | stdx | 41.61 | 102.63 | 2.47 | 731.27 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.72 | 47.87 | 2.20 | 685.69 |
| silesia/sao | 7251944 | 1 | stdx | 19.05 | 49.92 | 2.62 | 346.92 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.22 | 96.89 | 1.89 | 967.36 |
| silesia/sao | 7251944 | 6 | stdx | 46.97 | 105.65 | 2.25 | 844.37 |
| silesia/sao | 7251944 | 9 | libdeflate | 71.04 | 120.26 | 1.69 | 1111.82 |
| silesia/sao | 7251944 | 9 | stdx | 55.57 | 138.16 | 2.49 | 846.71 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.10 | 30.45 | 2.32 | 387.69 |
| silesia/webster | 41458703 | 1 | stdx | 13.84 | 29.08 | 2.10 | 339.92 |
| silesia/webster | 41458703 | 6 | libdeflate | 37.05 | 66.02 | 1.78 | 573.64 |
| silesia/webster | 41458703 | 6 | stdx | 35.10 | 60.88 | 1.73 | 1102.32 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.57 | 138.85 | 1.47 | 755.07 |
| silesia/webster | 41458703 | 9 | stdx | 60.60 | 135.96 | 2.24 | 1293.28 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.60 | 49.67 | 2.10 | 785.40 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.33 | 50.81 | 2.93 | 261.77 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.82 | 82.77 | 2.52 | 850.71 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.65 | 98.11 | 2.92 | 538.84 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.49 | 91.03 | 2.43 | 1030.07 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.78 | 122.05 | 2.99 | 467.06 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.78 | 21.59 | 2.77 | 177.39 |
| silesia/xml | 5345280 | 1 | stdx | 6.81 | 15.66 | 2.30 | 155.34 |
| silesia/xml | 5345280 | 6 | libdeflate | 20.98 | 40.51 | 1.93 | 264.69 |
| silesia/xml | 5345280 | 6 | stdx | 17.39 | 34.32 | 1.97 | 493.40 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.41 | 89.17 | 1.53 | 371.62 |
| silesia/xml | 5345280 | 9 | stdx | 30.92 | 72.83 | 2.36 | 600.10 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.28 | 35.61 | 2.49 | 380.07 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.05 | 36.12 | 2.40 | 336.74 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.71 | 82.29 | 1.76 | 642.17 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.65 | 77.43 | 1.77 | 1305.42 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.59 | 159.21 | 1.48 | 850.07 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 72.60 | 167.73 | 2.31 | 1512.01 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.15 | 37.20 | 2.45 | 416.10 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.75 | 37.43 | 2.38 | 359.23 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.33 | 85.43 | 1.77 | 718.59 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.36 | 81.93 | 1.77 | 1398.79 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 88.86 | 136.15 | 1.53 | 940.47 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 75.57 | 175.97 | 2.33 | 1609.96 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.66 | 32.02 | 2.74 | 281.28 |
| canterbury/cp.html | 24603 | 1 | stdx | 11.09 | 27.13 | 2.45 | 250.40 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 27.03 | 62.33 | 2.31 | 489.60 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.89 | 57.06 | 2.39 | 632.97 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 47.01 | 91.97 | 1.96 | 601.35 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.25 | 88.89 | 2.84 | 648.32 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.39 | 35.92 | 3.82 | 56.69 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.08 | 30.05 | 3.72 | 22.71 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.65 | 69.37 | 2.81 | 252.85 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.95 | 57.62 | 2.75 | 439.46 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 43.94 | 100.81 | 2.29 | 393.30 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.18 | 92.66 | 3.29 | 432.44 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 12.98 | 51.51 | 3.97 | 11.91 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.88 | 39.01 | 3.95 | 2.98 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.66 | 87.06 | 3.68 | 24.86 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.21 | 70.81 | 4.11 | 18.60 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.70 | 102.89 | 3.35 | 40.46 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.59 | 99.31 | 4.21 | 61.67 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.38 | 27.18 | 3.68 | 65.32 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.05 | 22.58 | 3.20 | 63.39 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.85 | 73.85 | 2.65 | 96.45 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.31 | 61.99 | 3.21 | 139.28 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.37 | 664.23 | 1.83 | 168.46 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.54 | 130.89 | 3.49 | 219.44 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.83 | 33.99 | 2.46 | 372.01 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.47 | 33.92 | 2.34 | 329.38 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.05 | 78.22 | 1.74 | 608.75 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.67 | 73.43 | 1.76 | 1217.27 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.76 | 136.94 | 1.49 | 804.85 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 70.54 | 162.24 | 2.30 | 1449.78 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.80 | 38.62 | 2.44 | 425.48 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.69 | 40.24 | 2.41 | 367.40 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.24 | 91.90 | 1.69 | 755.91 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.48 | 88.90 | 1.73 | 1491.53 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.96 | 166.26 | 1.42 | 1006.57 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 88.48 | 201.33 | 2.28 | 1801.95 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.44 | 18.61 | 2.89 | 142.44 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.97 | 11.03 | 2.22 | 123.23 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.30 | 36.17 | 2.53 | 221.05 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.34 | 29.58 | 2.40 | 309.34 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.44 | 120.86 | 2.00 | 375.19 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.10 | 130.09 | 3.02 | 640.94 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.87 | 33.49 | 2.60 | 342.91 |
| canterbury/sum | 38240 | 1 | stdx | 12.57 | 29.36 | 2.34 | 299.30 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.92 | 69.87 | 2.42 | 500.37 |
| canterbury/sum | 38240 | 6 | stdx | 26.67 | 65.74 | 2.47 | 656.49 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.49 | 181.91 | 1.93 | 603.20 |
| canterbury/sum | 38240 | 9 | stdx | 39.27 | 112.33 | 2.86 | 660.21 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.25 | 53.06 | 4.00 | 20.94 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.63 | 43.10 | 4.05 | 2.97 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 23.04 | 87.70 | 3.81 | 75.82 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 17.91 | 74.35 | 4.15 | 41.60 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 24.98 | 94.34 | 3.78 | 97.55 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.19 | 106.96 | 4.08 | 124.41 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.01 | 40.47 | 3.37 | 163.56 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.48 | 42.29 | 3.39 | 102.06 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.28 | 395.99 | 2.16 | 263.57 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.55 | 374.12 | 3.05 | 1902.49 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.53 | 1063.49 | 1.30 | 1310.20 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 228.65 | 755.68 | 3.30 | 2422.54 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.53 | 32.38 | 2.58 | 312.98 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.15 | 32.23 | 2.45 | 280.66 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 45.95 | 80.12 | 1.74 | 522.90 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 41.87 | 72.39 | 1.73 | 1251.64 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.66 | 200.28 | 1.41 | 742.48 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.03 | 170.21 | 2.24 | 1442.79 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.32 | 29.72 | 2.23 | 415.30 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.08 | 28.55 | 2.03 | 379.01 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.01 | 60.25 | 1.83 | 562.49 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 31.84 | 56.80 | 1.78 | 981.16 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.50 | 119.11 | 1.48 | 687.03 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 51.61 | 117.95 | 2.29 | 1145.32 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.42 | 103.92 | 2.93 | 457.10 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.29 | 58.63 | 2.75 | 365.43 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.22 | 138.33 | 2.99 | 566.77 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 31.89 | 94.31 | 2.96 | 529.28 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.78 | 142.44 | 2.98 | 587.91 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 35.93 | 112.13 | 3.12 | 537.05 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.48 | 27.96 | 2.67 | 268.68 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.01 | 20.25 | 2.25 | 233.99 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.38 | 52.09 | 2.33 | 395.21 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.85 | 42.86 | 2.27 | 539.17 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 34.96 | 72.54 | 2.07 | 463.93 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.73 | 69.05 | 2.79 | 552.40 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.78 | 23.03 | 2.62 | 225.05 |
| http/html-1m | 1048576 | 1 | stdx | 8.16 | 17.79 | 2.18 | 206.37 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.32 | 49.53 | 1.96 | 328.91 |
| http/html-1m | 1048576 | 6 | stdx | 21.15 | 40.71 | 1.93 | 617.07 |
| http/html-1m | 1048576 | 9 | libdeflate | 70.96 | 109.24 | 1.54 | 429.68 |
| http/html-1m | 1048576 | 9 | stdx | 35.65 | 85.76 | 2.41 | 706.17 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 31.77 | 94.80 | 2.98 | 303.44 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.44 | 45.16 | 2.75 | 242.50 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.02 | 126.60 | 2.94 | 372.11 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.10 | 78.37 | 2.89 | 381.79 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.23 | 142.45 | 2.73 | 433.78 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.62 | 95.56 | 3.12 | 385.13 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.86 | 23.85 | 3.03 | 135.38 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.45 | 13.94 | 2.56 | 110.32 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.22 | 46.61 | 2.56 | 207.02 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.42 | 35.01 | 2.61 | 279.54 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.08 | 151.99 | 1.90 | 296.60 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.10 | 58.45 | 3.06 | 302.93 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.75 | 19.85 | 2.94 | 125.51 |
| http/json-1m | 1048576 | 1 | stdx | 5.07 | 12.51 | 2.47 | 103.11 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.33 | 45.30 | 2.23 | 175.50 |
| http/json-1m | 1048576 | 6 | stdx | 14.69 | 35.09 | 2.39 | 298.10 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.43 | 205.21 | 1.69 | 275.63 |
| http/json-1m | 1048576 | 9 | stdx | 28.99 | 72.87 | 2.51 | 369.57 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.04 | 107.80 | 2.91 | 519.05 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.61 | 65.40 | 2.77 | 412.13 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.30 | 144.85 | 2.94 | 676.42 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 35.56 | 104.12 | 2.93 | 621.84 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.69 | 150.13 | 2.90 | 715.20 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 40.16 | 125.13 | 3.12 | 625.99 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.76 | 30.90 | 2.63 | 311.12 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.84 | 24.80 | 2.29 | 273.90 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.91 | 59.43 | 2.29 | 473.48 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.69 | 50.05 | 2.21 | 675.94 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.79 | 83.31 | 2.04 | 564.60 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.49 | 81.30 | 2.76 | 663.89 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.67 | 25.19 | 2.61 | 249.10 |
| http/js-1m | 1048576 | 1 | stdx | 9.55 | 21.31 | 2.23 | 233.28 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.78 | 56.12 | 1.95 | 372.13 |
| http/js-1m | 1048576 | 6 | stdx | 24.87 | 46.64 | 1.88 | 744.52 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.19 | 120.65 | 1.58 | 499.63 |
| http/js-1m | 1048576 | 9 | stdx | 41.81 | 100.01 | 2.39 | 812.49 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.19 | 97.73 | 2.94 | 379.64 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.33 | 49.52 | 2.70 | 301.71 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.77 | 129.22 | 2.95 | 477.38 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 29.01 | 82.32 | 2.84 | 505.50 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 45.87 | 133.80 | 2.92 | 508.36 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 32.98 | 99.48 | 3.02 | 521.43 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.65 | 25.60 | 2.96 | 174.86 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.68 | 16.96 | 2.54 | 135.46 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.23 | 48.80 | 2.41 | 290.81 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.44 | 38.00 | 2.31 | 463.68 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.80 | 82.40 | 2.02 | 372.22 |
| http/css-16kx64 | 1048576 | 9 | stdx | 22.92 | 65.13 | 2.84 | 482.22 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.94 | 21.15 | 3.05 | 132.82 |
| http/css-1m | 1048576 | 1 | stdx | 5.79 | 14.91 | 2.58 | 107.71 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.78 | 44.50 | 2.14 | 226.34 |
| http/css-1m | 1048576 | 6 | stdx | 16.55 | 35.61 | 2.15 | 441.92 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.63 | 111.58 | 1.60 | 307.66 |
| http/css-1m | 1048576 | 9 | stdx | 32.00 | 83.00 | 2.59 | 512.57 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.20 | 48.89 | 1.94 | 927.15 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.12 | 49.19 | 2.71 | 324.00 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.64 | 86.45 | 2.08 | 1181.76 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.70 | 88.80 | 2.24 | 857.00 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.08 | 94.50 | 2.01 | 1342.79 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 53.80 | 134.38 | 2.50 | 1137.04 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.04 | 31.22 | 3.11 | 119.96 |
| silesia/dickens | 10192446 | 1 | stdx | 24.24 | 82.03 | 3.38 | 125.29 |
| silesia/dickens | 10192446 | 3 | libzstd | 23.29 | 34.39 | 1.48 | 171.61 |
| silesia/dickens | 10192446 | 3 | stdx | 36.80 | 78.22 | 2.13 | 182.54 |
| silesia/mozilla | 51220480 | 1 | libzstd | 6.96 | 22.69 | 3.26 | 70.82 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.73 | 54.73 | 3.09 | 177.35 |
| silesia/mozilla | 51220480 | 3 | libzstd | 17.51 | 27.89 | 1.59 | 102.86 |
| silesia/mozilla | 51220480 | 3 | stdx | 31.83 | 62.01 | 1.95 | 145.18 |
| silesia/mr | 9970564 | 1 | libzstd | 7.60 | 24.81 | 3.27 | 57.22 |
| silesia/mr | 9970564 | 1 | stdx | 19.79 | 66.82 | 3.38 | 113.83 |
| silesia/mr | 9970564 | 3 | libzstd | 20.54 | 32.19 | 1.57 | 87.01 |
| silesia/mr | 9970564 | 3 | stdx | 34.65 | 72.46 | 2.09 | 114.27 |
| silesia/nci | 33553445 | 1 | libzstd | 3.47 | 9.55 | 2.75 | 57.68 |
| silesia/nci | 33553445 | 1 | stdx | 7.72 | 25.69 | 3.33 | 58.76 |
| silesia/nci | 33553445 | 3 | libzstd | 5.41 | 9.95 | 1.84 | 56.66 |
| silesia/nci | 33553445 | 3 | stdx | 11.47 | 29.15 | 2.54 | 66.14 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.49 | 29.26 | 3.44 | 70.67 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.20 | 72.51 | 3.13 | 180.23 |
| silesia/ooffice | 6152192 | 3 | libzstd | 24.39 | 39.44 | 1.62 | 121.25 |
| silesia/ooffice | 6152192 | 3 | stdx | 43.39 | 82.20 | 1.89 | 185.41 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.01 | 22.29 | 3.18 | 66.48 |
| silesia/osdb | 10085684 | 1 | stdx | 16.32 | 50.52 | 3.10 | 119.08 |
| silesia/osdb | 10085684 | 3 | libzstd | 18.36 | 26.23 | 1.43 | 68.59 |
| silesia/osdb | 10085684 | 3 | stdx | 33.02 | 57.87 | 1.75 | 111.33 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.66 | 27.13 | 2.81 | 150.81 |
| silesia/reymont | 6627202 | 1 | stdx | 20.11 | 72.05 | 3.58 | 96.97 |
| silesia/reymont | 6627202 | 3 | libzstd | 18.72 | 27.10 | 1.45 | 126.53 |
| silesia/reymont | 6627202 | 3 | stdx | 28.75 | 62.18 | 2.16 | 147.41 |
| silesia/samba | 21606400 | 1 | libzstd | 5.87 | 16.88 | 2.88 | 85.68 |
| silesia/samba | 21606400 | 1 | stdx | 13.46 | 42.89 | 3.19 | 124.60 |
| silesia/samba | 21606400 | 3 | libzstd | 12.11 | 18.81 | 1.55 | 99.57 |
| silesia/samba | 21606400 | 3 | stdx | 21.01 | 44.75 | 2.13 | 133.34 |
| silesia/sao | 7251944 | 1 | libzstd | 9.01 | 33.69 | 3.74 | 45.01 |
| silesia/sao | 7251944 | 1 | stdx | 25.87 | 82.03 | 3.17 | 103.92 |
| silesia/sao | 7251944 | 3 | libzstd | 32.29 | 50.03 | 1.55 | 96.20 |
| silesia/sao | 7251944 | 3 | stdx | 53.21 | 95.22 | 1.79 | 143.75 |
| silesia/webster | 41458703 | 1 | libzstd | 8.63 | 24.94 | 2.89 | 131.04 |
| silesia/webster | 41458703 | 1 | stdx | 20.33 | 64.04 | 3.15 | 166.15 |
| silesia/webster | 41458703 | 3 | libzstd | 19.63 | 27.33 | 1.39 | 178.19 |
| silesia/webster | 41458703 | 3 | stdx | 31.98 | 64.55 | 2.02 | 194.76 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.63 | 14.92 | 3.22 | 17.20 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.76 | 76.64 | 3.23 | 91.75 |
| silesia/x-ray | 8474240 | 3 | libzstd | 33.01 | 52.73 | 1.60 | 88.60 |
| silesia/x-ray | 8474240 | 3 | stdx | 49.47 | 92.40 | 1.87 | 106.17 |
| silesia/xml | 5345280 | 1 | libzstd | 4.21 | 11.71 | 2.78 | 71.26 |
| silesia/xml | 5345280 | 1 | stdx | 10.35 | 34.21 | 3.31 | 93.86 |
| silesia/xml | 5345280 | 3 | libzstd | 6.76 | 12.61 | 1.87 | 77.76 |
| silesia/xml | 5345280 | 3 | stdx | 12.92 | 32.28 | 2.50 | 115.36 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.78 | 32.84 | 3.05 | 139.64 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.37 | 76.49 | 3.42 | 185.04 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.63 | 39.48 | 2.53 | 205.14 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.59 | 73.76 | 2.77 | 334.03 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.75 | 33.55 | 3.44 | 104.99 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.55 | 79.00 | 3.35 | 213.14 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.24 | 39.27 | 2.58 | 209.16 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 28.24 | 79.30 | 2.81 | 371.63 |
| canterbury/cp.html | 24603 | 1 | libzstd | 6.90 | 26.64 | 3.86 | 37.09 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.05 | 57.76 | 3.60 | 118.15 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.49 | 31.85 | 3.36 | 48.09 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.11 | 59.76 | 3.30 | 134.99 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.57 | 31.76 | 3.70 | 35.94 |
| canterbury/fields.c | 11150 | 1 | stdx | 16.92 | 65.73 | 3.88 | 83.08 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.61 | 34.13 | 3.55 | 43.60 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.24 | 64.68 | 3.75 | 87.85 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.38 | 38.01 | 4.05 | 7.95 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.21 | 77.57 | 3.84 | 49.58 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.79 | 43.09 | 3.99 | 15.27 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.39 | 79.60 | 3.72 | 67.11 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.01 | 23.56 | 3.92 | 14.75 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.73 | 56.75 | 3.85 | 83.58 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.70 | 23.80 | 2.74 | 27.65 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 21.08 | 56.61 | 2.69 | 109.64 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.81 | 28.52 | 2.91 | 156.32 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.43 | 72.02 | 3.36 | 160.02 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 17.04 | 32.14 | 1.89 | 204.24 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 26.66 | 67.10 | 2.52 | 296.20 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.32 | 32.37 | 3.14 | 128.87 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 25.08 | 84.16 | 3.36 | 157.82 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 21.18 | 38.77 | 1.83 | 227.75 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 32.30 | 80.77 | 2.50 | 342.93 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.15 | 8.51 | 2.70 | 67.34 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.57 | 23.15 | 3.06 | 104.77 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 5.03 | 10.97 | 2.18 | 59.29 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.66 | 24.08 | 2.49 | 133.42 |
| canterbury/sum | 38240 | 1 | libzstd | 6.47 | 25.39 | 3.92 | 29.09 |
| canterbury/sum | 38240 | 1 | stdx | 16.77 | 59.13 | 3.53 | 146.00 |
| canterbury/sum | 38240 | 3 | libzstd | 9.18 | 30.67 | 3.34 | 45.43 |
| canterbury/sum | 38240 | 3 | stdx | 19.78 | 61.82 | 3.13 | 179.47 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 9.94 | 39.82 | 4.01 | 10.88 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.87 | 80.38 | 3.85 | 59.21 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.33 | 48.17 | 3.91 | 20.03 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.88 | 83.98 | 3.67 | 80.10 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.31 | 33.44 | 3.24 | 76.29 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.79 | 95.62 | 4.39 | 7.27 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 15.39 | 31.30 | 2.03 | 35.84 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.98 | 70.38 | 2.93 | 38.19 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.69 | 27.45 | 2.83 | 149.34 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.35 | 71.86 | 3.53 | 108.48 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 18.63 | 28.20 | 1.51 | 133.39 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 28.73 | 63.36 | 2.21 | 155.51 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.15 | 22.70 | 2.78 | 137.33 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.61 | 55.86 | 3.00 | 191.64 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 15.97 | 23.87 | 1.49 | 175.50 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 25.54 | 51.26 | 2.01 | 237.07 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 16.97 | 52.46 | 3.09 | 159.42 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.78 | 100.54 | 2.81 | 640.46 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 18.96 | 59.20 | 3.12 | 197.24 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 37.77 | 104.00 | 2.75 | 631.36 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.70 | 22.46 | 2.92 | 122.14 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.14 | 46.84 | 3.31 | 182.40 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.77 | 24.61 | 2.81 | 141.41 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.32 | 47.61 | 3.11 | 191.74 |
| http/html-1m | 1048576 | 1 | libzstd | 6.24 | 16.74 | 2.68 | 114.82 |
| http/html-1m | 1048576 | 1 | stdx | 13.00 | 42.00 | 3.23 | 134.08 |
| http/html-1m | 1048576 | 3 | libzstd | 9.63 | 18.18 | 1.89 | 126.51 |
| http/html-1m | 1048576 | 3 | stdx | 16.07 | 39.37 | 2.45 | 177.62 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.26 | 42.52 | 2.98 | 116.16 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.55 | 83.13 | 2.81 | 525.86 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.74 | 44.54 | 3.02 | 129.48 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.56 | 84.87 | 2.78 | 533.51 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.79 | 14.98 | 3.13 | 57.52 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.70 | 33.78 | 3.48 | 116.80 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.35 | 16.21 | 3.03 | 72.73 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.68 | 34.58 | 3.24 | 123.22 |
| http/json-1m | 1048576 | 1 | libzstd | 4.06 | 12.55 | 3.09 | 53.48 |
| http/json-1m | 1048576 | 1 | stdx | 9.03 | 30.70 | 3.40 | 85.27 |
| http/json-1m | 1048576 | 3 | libzstd | 6.36 | 13.78 | 2.17 | 68.84 |
| http/json-1m | 1048576 | 3 | stdx | 11.63 | 30.64 | 2.64 | 119.50 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.45 | 57.26 | 3.10 | 184.48 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 39.86 | 113.49 | 2.85 | 692.66 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.32 | 65.54 | 3.07 | 260.71 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 41.90 | 116.54 | 2.78 | 679.81 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.81 | 26.52 | 3.01 | 126.68 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.58 | 55.71 | 3.36 | 200.87 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.04 | 28.74 | 2.86 | 153.20 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.75 | 55.35 | 3.12 | 210.44 |
| http/js-1m | 1048576 | 1 | libzstd | 6.54 | 17.87 | 2.73 | 113.91 |
| http/js-1m | 1048576 | 1 | stdx | 14.01 | 45.88 | 3.28 | 136.18 |
| http/js-1m | 1048576 | 3 | libzstd | 10.37 | 19.14 | 1.85 | 125.96 |
| http/js-1m | 1048576 | 3 | stdx | 17.42 | 41.25 | 2.37 | 187.02 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.48 | 46.90 | 3.03 | 136.72 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.28 | 91.65 | 2.84 | 579.11 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.56 | 50.53 | 3.05 | 160.10 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.62 | 93.63 | 2.78 | 579.13 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.11 | 18.99 | 3.11 | 78.29 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.41 | 43.79 | 3.53 | 136.92 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.56 | 19.41 | 2.96 | 95.74 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.93 | 42.34 | 3.28 | 153.25 |
| http/css-1m | 1048576 | 1 | libzstd | 1.50 | 4.59 | 3.06 | 21.82 |
| http/css-1m | 1048576 | 1 | stdx | 4.01 | 14.85 | 3.71 | 30.53 |
| http/css-1m | 1048576 | 3 | libzstd | 2.00 | 5.25 | 2.63 | 19.81 |
| http/css-1m | 1048576 | 3 | stdx | 4.00 | 13.33 | 3.33 | 31.76 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.53 | 12.79 | 3.63 | 6.23 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.10 | 30.66 | 3.37 | 61.55 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 29.91 | 50.53 | 1.69 | 49.77 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 21.26 | 47.43 | 2.23 | 207.88 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.5 | 74.2 | 0.121 | 3.01 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 65.6 | 219.6 | 0.084 | 7.75 | 3.35 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 30.7 | 96.1 | 0.164 | 3.63 | 3.13 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 251.3 | 1024.0 | 0.843 | 29.69 | 4.07 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 30.8 | 107.7 | 0.130 | 3.63 | 3.50 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.8 | 106.2 | 0.294 | 3.28 | 3.82 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.8 | 378.2 | 0.360 | 11.32 | 3.95 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 43.0 | 161.9 | 0.472 | 5.08 | 3.76 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 91.5 | 451.7 | 0.303 | 10.81 | 4.94 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 27.2 | 89.5 | 0.004 | 4.00 | 3.30 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 67.9 | 234.7 | 0.040 | 9.99 | 3.46 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 29.3 | 99.4 | 0.011 | 4.32 | 3.39 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 216.3 | 819.1 | 0.943 | 31.84 | 3.79 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.2 | 107.7 | 0.040 | 4.15 | 3.82 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.4 | 106.0 | 0.047 | 4.18 | 3.73 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 94.2 | 346.2 | 0.316 | 13.86 | 3.68 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 32.1 | 144.5 | 0.052 | 4.72 | 4.51 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 90.0 | 406.5 | 0.075 | 13.24 | 4.52 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 114337.7 | 403846.2 | 492.866 | 0.66 | 3.53 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 594345.1 | 2503286.2 | 1387.969 | 3.44 | 4.21 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 114019.9 | 404249.2 | 475.536 | 0.66 | 3.55 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3578408.4 | 18223876.2 | 2976.649 | 20.74 | 5.09 |
| string: silesia/dickens | 1 | 172528 | simdjson | 312126.4 | 621744.2 | 641.113 | 1.81 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 224003.0 | 826630.2 | 2167.082 | 1.30 | 3.69 |
| string: silesia/dickens | 1 | 172528 | std.json | 1585132.9 | 4578768.3 | 42586.165 | 9.19 | 2.89 |
| string: silesia/dickens | 1 | 172528 | serde_json | 203752.7 | 802391.2 | 1001.268 | 1.18 | 3.94 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1043819.7 | 5281708.2 | 4966.247 | 6.05 | 5.06 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1563715.1 | 4799763.6 | 1291.071 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14368911.6 | 56816152.6 | 39383.571 | 12.07 | 3.95 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1561465.9 | 4799955.6 | 1125.643 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 28804009.1 | 132108253.6 | 159744.500 | 24.20 | 4.59 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4582280.4 | 7062781.6 | 544.000 | 3.85 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1802589.5 | 7322029.6 | 14305.786 | 1.51 | 4.06 |
| string: http/json-1m | 1 | 1190272 | std.json | 10338959.0 | 47381213.6 | 29838.143 | 8.69 | 4.58 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3783764.6 | 15226459.6 | 6061.714 | 3.18 | 4.02 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 8964177.9 | 47985932.0 | 28163.143 | 7.53 | 5.35 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2062690.1 | 5765413.8 | 4411.250 | 1.10 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6176568.9 | 22589263.8 | 6965.250 | 3.28 | 3.66 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2060110.5 | 5765605.8 | 3940.500 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47265587.5 | 227842320.8 | 279260.250 | 25.10 | 4.82 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3764769.1 | 8446023.8 | 2069.625 | 2.00 | 2.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7089949.0 | 12276717.8 | 274874.500 | 3.77 | 1.73 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17461464.9 | 63617055.8 | 265180.250 | 9.27 | 3.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9609176.3 | 24440755.8 | 330792.750 | 5.10 | 2.54 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39112999.1 | 160311542.6 | 795677.250 | 20.77 | 4.10 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12900355.3 | 42561069.3 | 245054.000 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 160148205.0 | 667246747.3 | 395390.667 | 31.55 | 4.17 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12937304.7 | 42561261.3 | 245207.333 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 159295708.7 | 639992662.3 | 423583.000 | 31.39 | 4.02 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17523331.0 | 49745820.3 | 250902.000 | 3.45 | 2.84 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14014167.0 | 45615166.3 | 442238.667 | 2.76 | 3.25 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79222035.0 | 314900845.3 | 459013.000 | 15.61 | 3.97 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36786456.3 | 131556135.3 | 587570.000 | 7.25 | 3.58 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66115777.3 | 273933773.7 | 831080.333 | 13.03 | 4.14 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 94600.0 | 303836.7 | 7.742 | 0.18 | 3.21 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 186510.6 | 623465.7 | 10.581 | 0.36 | 3.34 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 148059.6 | 557622.7 | 6.387 | 0.28 | 3.77 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10206968.9 | 53478202.7 | 8.194 | 19.47 | 5.24 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 489166.7 | 1376733.7 | 4.903 | 0.93 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 538808.5 | 2195917.7 | 7.290 | 1.03 | 4.08 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3464439.2 | 12808414.7 | 60726.839 | 6.61 | 3.70 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 297333.7 | 1179969.7 | 6.355 | 0.57 | 3.97 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2246104.5 | 12789823.5 | 239.806 | 4.28 | 5.69 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.4 | 81.8 | 0.109 | 2.29 | 4.22 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.1 | 153.6 | 0.127 | 4.14 | 4.38 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 23.3 | 103.2 | 0.098 | 2.75 | 4.43 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 216.2 | 981.0 | 0.936 | 25.54 | 4.54 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 18.7 | 79.5 | 0.106 | 2.21 | 4.24 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.2 | 94.1 | 0.136 | 2.74 | 4.05 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.5 | 105.6 | 0.245 | 3.25 | 3.84 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.5 | 310.8 | 0.385 | 8.21 | 4.47 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.7 | 255.3 | 0.511 | 7.52 | 4.01 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.4 | 315.1 | 0.235 | 8.08 | 4.60 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 18.5 | 82.8 | 0.024 | 2.72 | 4.48 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.0 | 153.9 | 0.026 | 5.30 | 4.27 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 22.9 | 101.7 | 0.024 | 3.37 | 4.45 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 169.9 | 718.3 | 1.268 | 25.01 | 4.23 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 17.8 | 81.5 | 0.024 | 2.62 | 4.57 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.6 | 96.8 | 0.032 | 3.18 | 4.48 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.9 | 117.9 | 0.033 | 4.25 | 4.08 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 61.3 | 271.2 | 0.275 | 9.02 | 4.42 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 48.2 | 211.7 | 0.039 | 7.09 | 4.39 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 82.0 | 331.7 | 0.087 | 12.08 | 4.04 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 84931.0 | 280786.2 | 723.546 | 0.49 | 3.31 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84680.9 | 280732.2 | 714.155 | 0.49 | 3.32 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84606.4 | 280724.2 | 710.670 | 0.49 | 3.32 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3361669.9 | 16047574.2 | 2949.732 | 19.48 | 4.77 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 83979.8 | 274401.2 | 694.732 | 0.49 | 3.27 |
| string: silesia/dickens | 1 | 172528 | simdjson | 209153.9 | 674016.2 | 2096.474 | 1.21 | 3.22 |
| string: silesia/dickens | 1 | 172528 | yyjson | 205166.0 | 825518.2 | 1066.825 | 1.19 | 4.02 |
| string: silesia/dickens | 1 | 172528 | std.json | 1377501.2 | 2890892.2 | 55930.216 | 7.98 | 2.10 |
| string: silesia/dickens | 1 | 172528 | serde_json | 372351.6 | 1586249.2 | 2296.938 | 2.16 | 4.26 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 577166.7 | 2970293.2 | 2340.381 | 3.35 | 5.15 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1254020.6 | 3582350.6 | 10891.071 | 1.05 | 2.86 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1245069.9 | 3582290.6 | 10508.571 | 1.05 | 2.88 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1242227.4 | 3582278.6 | 10407.071 | 1.04 | 2.88 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 24963795.0 | 109856348.6 | 142884.643 | 20.97 | 4.40 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1220831.2 | 3370022.6 | 10919.000 | 1.03 | 2.76 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2964028.2 | 10460762.6 | 29132.714 | 2.49 | 3.53 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2583117.4 | 10197931.6 | 9559.286 | 2.17 | 3.95 |
| string: http/json-1m | 1 | 1190272 | std.json | 8899720.4 | 43287986.6 | 16628.571 | 7.48 | 4.86 |
| string: http/json-1m | 1 | 1190272 | serde_json | 4203494.3 | 17941088.6 | 10924.429 | 3.53 | 4.27 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5229916.4 | 26999628.6 | 11108.286 | 4.39 | 5.16 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2074376.6 | 6088099.8 | 4767.000 | 1.10 | 2.93 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2066715.0 | 6088039.8 | 4263.875 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2065567.4 | 6088027.8 | 4118.250 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43554852.1 | 193466548.8 | 269810.250 | 23.13 | 4.44 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2072974.6 | 5875346.8 | 4815.375 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2711099.3 | 7144143.8 | 21073.000 | 1.44 | 2.64 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12483389.4 | 23590602.8 | 462904.000 | 6.63 | 1.89 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20240050.0 | 56837736.8 | 549474.500 | 10.75 | 2.81 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11460351.3 | 33662338.8 | 333366.125 | 6.09 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18754841.0 | 76319355.4 | 249206.000 | 9.96 | 4.07 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 112745.3 | 426376.7 | 2.452 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 112723.8 | 426318.7 | 3.258 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 112699.4 | 426299.7 | 2.387 | 0.21 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 636137.2 | 3146479.7 | 6.968 | 1.21 | 4.95 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 112846.2 | 426343.7 | 1.581 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1203552.4 | 3866916.7 | 5.839 | 2.30 | 3.21 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1625618.0 | 5833341.7 | 5.516 | 3.10 | 3.59 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3524036.6 | 13108830.7 | 77486.806 | 6.72 | 3.72 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1775340.3 | 7405810.7 | 3.645 | 3.39 | 4.17 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2394387.2 | 12748267.7 | 14.032 | 4.57 | 5.32 |
