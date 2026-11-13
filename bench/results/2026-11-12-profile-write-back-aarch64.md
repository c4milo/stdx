# bench-profile

| Field | Value |
|---|---|
| Commit | 41ab56a |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43215850776 |
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
| silesia/dickens | 10192446 | zlib | 8.82 | 19.08 | 2.16 | 309.92 |
| silesia/dickens | 10192446 | zlib-ng | 4.87 | 10.50 | 2.16 | 67.48 |
| silesia/dickens | 10192446 | libdeflate | 3.45 | 9.56 | 2.77 | 66.21 |
| silesia/dickens | 10192446 | Wuffs | 5.52 | 13.90 | 2.52 | 97.10 |
| silesia/dickens | 10192446 | stdx | 2.92 | 7.15 | 2.45 | 76.13 |
| silesia/mozilla | 51220480 | zlib | 8.47 | 17.23 | 2.03 | 250.75 |
| silesia/mozilla | 51220480 | zlib-ng | 4.96 | 8.95 | 1.81 | 86.17 |
| silesia/mozilla | 51220480 | libdeflate | 3.47 | 7.63 | 2.20 | 71.07 |
| silesia/mozilla | 51220480 | Wuffs | 6.40 | 13.89 | 2.17 | 132.88 |
| silesia/mozilla | 51220480 | stdx | 3.64 | 6.29 | 1.73 | 89.36 |
| silesia/mr | 9970564 | zlib | 8.37 | 18.46 | 2.20 | 202.11 |
| silesia/mr | 9970564 | zlib-ng | 4.80 | 9.98 | 2.08 | 67.91 |
| silesia/mr | 9970564 | libdeflate | 3.34 | 8.58 | 2.57 | 61.12 |
| silesia/mr | 9970564 | Wuffs | 5.98 | 14.04 | 2.35 | 100.09 |
| silesia/mr | 9970564 | stdx | 3.07 | 6.70 | 2.18 | 69.65 |
| silesia/nci | 33553445 | zlib | 3.55 | 10.18 | 2.86 | 81.16 |
| silesia/nci | 33553445 | zlib-ng | 1.63 | 3.13 | 1.92 | 35.31 |
| silesia/nci | 33553445 | libdeflate | 1.17 | 2.66 | 2.27 | 29.78 |
| silesia/nci | 33553445 | Wuffs | 2.47 | 6.47 | 2.62 | 41.22 |
| silesia/nci | 33553445 | stdx | 1.20 | 2.20 | 1.84 | 37.14 |
| silesia/ooffice | 6152192 | zlib | 11.73 | 21.06 | 1.79 | 412.96 |
| silesia/ooffice | 6152192 | zlib-ng | 6.93 | 12.04 | 1.74 | 141.27 |
| silesia/ooffice | 6152192 | libdeflate | 4.89 | 10.45 | 2.14 | 125.25 |
| silesia/ooffice | 6152192 | Wuffs | 8.80 | 17.54 | 1.99 | 220.23 |
| silesia/ooffice | 6152192 | stdx | 5.06 | 8.55 | 1.69 | 151.05 |
| silesia/osdb | 10085684 | zlib | 7.44 | 16.59 | 2.23 | 181.46 |
| silesia/osdb | 10085684 | zlib-ng | 4.32 | 8.38 | 1.94 | 54.59 |
| silesia/osdb | 10085684 | libdeflate | 2.84 | 6.91 | 2.44 | 29.75 |
| silesia/osdb | 10085684 | Wuffs | 5.81 | 13.61 | 2.34 | 80.04 |
| silesia/osdb | 10085684 | stdx | 2.78 | 5.65 | 2.04 | 41.49 |
| silesia/reymont | 6627202 | zlib | 7.38 | 15.89 | 2.15 | 260.01 |
| silesia/reymont | 6627202 | zlib-ng | 3.71 | 7.72 | 2.08 | 60.19 |
| silesia/reymont | 6627202 | libdeflate | 2.61 | 6.91 | 2.65 | 51.48 |
| silesia/reymont | 6627202 | Wuffs | 4.89 | 11.40 | 2.33 | 113.22 |
| silesia/reymont | 6627202 | stdx | 2.27 | 5.11 | 2.25 | 64.04 |
| silesia/samba | 21606400 | zlib | 6.16 | 14.13 | 2.29 | 175.31 |
| silesia/samba | 21606400 | zlib-ng | 3.39 | 6.47 | 1.91 | 58.06 |
| silesia/samba | 21606400 | libdeflate | 2.31 | 5.58 | 2.41 | 42.85 |
| silesia/samba | 21606400 | Wuffs | 4.32 | 10.39 | 2.41 | 79.76 |
| silesia/samba | 21606400 | stdx | 2.26 | 4.46 | 1.98 | 56.13 |
| silesia/sao | 7251944 | zlib | 10.51 | 23.54 | 2.24 | 206.49 |
| silesia/sao | 7251944 | zlib-ng | 7.84 | 14.83 | 1.89 | 79.20 |
| silesia/sao | 7251944 | libdeflate | 5.73 | 12.73 | 2.22 | 79.28 |
| silesia/sao | 7251944 | Wuffs | 8.88 | 21.26 | 2.39 | 86.22 |
| silesia/sao | 7251944 | stdx | 5.56 | 10.32 | 1.86 | 87.43 |
| silesia/webster | 41458703 | zlib | 7.79 | 16.16 | 2.07 | 280.96 |
| silesia/webster | 41458703 | zlib-ng | 4.23 | 8.04 | 1.90 | 85.29 |
| silesia/webster | 41458703 | libdeflate | 2.91 | 7.17 | 2.46 | 68.42 |
| silesia/webster | 41458703 | Wuffs | 5.14 | 11.67 | 2.27 | 122.40 |
| silesia/webster | 41458703 | stdx | 2.79 | 5.56 | 2.00 | 87.12 |
| silesia/x-ray | 8474240 | zlib | 12.86 | 27.21 | 2.12 | 328.87 |
| silesia/x-ray | 8474240 | zlib-ng | 9.04 | 17.39 | 1.92 | 124.12 |
| silesia/x-ray | 8474240 | libdeflate | 6.53 | 15.26 | 2.34 | 124.77 |
| silesia/x-ray | 8474240 | Wuffs | 10.81 | 23.52 | 2.18 | 190.98 |
| silesia/x-ray | 8474240 | stdx | 6.13 | 11.49 | 1.87 | 138.64 |
| silesia/xml | 5345280 | zlib | 4.21 | 11.16 | 2.65 | 117.29 |
| silesia/xml | 5345280 | zlib-ng | 1.98 | 3.88 | 1.96 | 42.71 |
| silesia/xml | 5345280 | libdeflate | 1.36 | 3.33 | 2.45 | 31.93 |
| silesia/xml | 5345280 | Wuffs | 2.84 | 7.22 | 2.55 | 59.15 |
| silesia/xml | 5345280 | stdx | 1.32 | 2.65 | 2.01 | 41.75 |
| canterbury/alice29.txt | 152089 | zlib | 8.41 | 18.35 | 2.18 | 293.82 |
| canterbury/alice29.txt | 152089 | zlib-ng | 4.52 | 9.91 | 2.19 | 60.57 |
| canterbury/alice29.txt | 152089 | libdeflate | 3.19 | 8.96 | 2.81 | 55.29 |
| canterbury/alice29.txt | 152089 | Wuffs | 5.38 | 13.40 | 2.49 | 98.34 |
| canterbury/alice29.txt | 152089 | stdx | 2.71 | 6.99 | 2.58 | 62.39 |
| canterbury/asyoulik.txt | 125179 | zlib | 9.01 | 19.42 | 2.16 | 313.37 |
| canterbury/asyoulik.txt | 125179 | zlib-ng | 5.09 | 10.86 | 2.13 | 73.53 |
| canterbury/asyoulik.txt | 125179 | libdeflate | 3.59 | 9.82 | 2.73 | 67.66 |
| canterbury/asyoulik.txt | 125179 | Wuffs | 5.78 | 14.40 | 2.49 | 101.20 |
| canterbury/asyoulik.txt | 125179 | stdx | 3.06 | 7.52 | 2.46 | 76.65 |
| canterbury/cp.html | 24603 | zlib | 7.09 | 17.33 | 2.45 | 173.09 |
| canterbury/cp.html | 24603 | zlib-ng | 4.33 | 9.50 | 2.19 | 47.31 |
| canterbury/cp.html | 24603 | libdeflate | 2.90 | 7.95 | 2.74 | 20.59 |
| canterbury/cp.html | 24603 | Wuffs | 5.21 | 13.91 | 2.67 | 60.44 |
| canterbury/cp.html | 24603 | stdx | 2.72 | 7.19 | 2.64 | 18.79 |
| canterbury/fields.c | 11150 | zlib | 5.28 | 17.73 | 3.36 | 39.49 |
| canterbury/fields.c | 11150 | zlib-ng | 4.01 | 10.20 | 2.54 | 24.23 |
| canterbury/fields.c | 11150 | libdeflate | 2.79 | 8.32 | 2.98 | 1.40 |
| canterbury/fields.c | 11150 | Wuffs | 4.52 | 14.54 | 3.22 | 10.18 |
| canterbury/fields.c | 11150 | stdx | 2.52 | 7.64 | 3.03 | 5.83 |
| canterbury/grammar.lsp | 3721 | zlib | 6.90 | 24.26 | 3.51 | 6.65 |
| canterbury/grammar.lsp | 3721 | zlib-ng | 5.93 | 17.48 | 2.95 | 14.64 |
| canterbury/grammar.lsp | 3721 | libdeflate | 4.41 | 12.05 | 2.73 | 1.25 |
| canterbury/grammar.lsp | 3721 | Wuffs | 6.66 | 21.86 | 3.28 | 3.38 |
| canterbury/grammar.lsp | 3721 | stdx | 3.85 | 12.18 | 3.16 | 1.95 |
| canterbury/kennedy.xls | 1029744 | zlib | 4.58 | 15.27 | 3.33 | 48.14 |
| canterbury/kennedy.xls | 1029744 | zlib-ng | 2.84 | 6.97 | 2.45 | 12.64 |
| canterbury/kennedy.xls | 1029744 | libdeflate | 2.75 | 5.97 | 2.18 | 9.03 |
| canterbury/kennedy.xls | 1029744 | Wuffs | 3.86 | 11.59 | 3.00 | 14.78 |
| canterbury/kennedy.xls | 1029744 | stdx | 1.74 | 4.66 | 2.68 | 16.60 |
| canterbury/lcet10.txt | 426754 | zlib | 8.18 | 17.78 | 2.17 | 288.54 |
| canterbury/lcet10.txt | 426754 | zlib-ng | 4.30 | 9.39 | 2.18 | 60.11 |
| canterbury/lcet10.txt | 426754 | libdeflate | 3.03 | 8.48 | 2.80 | 55.48 |
| canterbury/lcet10.txt | 426754 | Wuffs | 5.22 | 12.88 | 2.47 | 101.34 |
| canterbury/lcet10.txt | 426754 | stdx | 2.58 | 6.42 | 2.48 | 66.31 |
| canterbury/plrabn12.txt | 481861 | zlib | 9.19 | 19.86 | 2.16 | 320.57 |
| canterbury/plrabn12.txt | 481861 | zlib-ng | 5.30 | 11.19 | 2.11 | 79.67 |
| canterbury/plrabn12.txt | 481861 | libdeflate | 3.77 | 10.19 | 2.70 | 77.12 |
| canterbury/plrabn12.txt | 481861 | Wuffs | 5.81 | 14.61 | 2.52 | 99.43 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.14 | 7.63 | 2.43 | 84.81 |
| canterbury/ptt5 | 513216 | zlib | 5.06 | 10.71 | 2.12 | 103.93 |
| canterbury/ptt5 | 513216 | zlib-ng | 2.00 | 3.74 | 1.88 | 46.60 |
| canterbury/ptt5 | 513216 | libdeflate | 1.44 | 3.02 | 2.09 | 37.73 |
| canterbury/ptt5 | 513216 | Wuffs | 3.01 | 7.13 | 2.37 | 57.63 |
| canterbury/ptt5 | 513216 | stdx | 1.45 | 2.55 | 1.76 | 48.71 |
| canterbury/sum | 38240 | zlib | 8.01 | 18.12 | 2.26 | 225.70 |
| canterbury/sum | 38240 | zlib-ng | 4.70 | 10.02 | 2.13 | 61.46 |
| canterbury/sum | 38240 | libdeflate | 3.36 | 8.34 | 2.48 | 40.50 |
| canterbury/sum | 38240 | Wuffs | 5.84 | 14.47 | 2.48 | 83.93 |
| canterbury/sum | 38240 | stdx | 3.17 | 7.73 | 2.44 | 40.28 |
| canterbury/xargs.1 | 4227 | zlib | 7.51 | 25.22 | 3.36 | 18.68 |
| canterbury/xargs.1 | 4227 | zlib-ng | 6.49 | 17.97 | 2.77 | 17.98 |
| canterbury/xargs.1 | 4227 | libdeflate | 4.77 | 13.27 | 2.78 | 1.12 |
| canterbury/xargs.1 | 4227 | Wuffs | 7.19 | 22.63 | 3.15 | 9.85 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 12.86 | 3.04 | 2.47 |
| canterbury-large/E.coli | 4638690 | zlib | 6.77 | 17.84 | 2.64 | 178.30 |
| canterbury-large/E.coli | 4638690 | zlib-ng | 4.23 | 9.68 | 2.29 | 47.39 |
| canterbury-large/E.coli | 4638690 | libdeflate | 3.03 | 8.86 | 2.92 | 48.56 |
| canterbury-large/E.coli | 4638690 | Wuffs | 4.66 | 12.73 | 2.73 | 61.88 |
| canterbury-large/E.coli | 4638690 | stdx | 2.47 | 6.72 | 2.72 | 54.01 |
| canterbury-large/bible.txt | 4047392 | zlib | 7.52 | 16.46 | 2.19 | 266.83 |
| canterbury-large/bible.txt | 4047392 | zlib-ng | 3.77 | 8.26 | 2.19 | 53.63 |
| canterbury-large/bible.txt | 4047392 | libdeflate | 2.62 | 7.45 | 2.85 | 45.53 |
| canterbury-large/bible.txt | 4047392 | Wuffs | 4.78 | 11.73 | 2.45 | 99.87 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.23 | 5.57 | 2.50 | 55.92 |
| canterbury-large/world192.txt | 2473400 | zlib | 7.71 | 15.84 | 2.05 | 281.89 |
| canterbury-large/world192.txt | 2473400 | zlib-ng | 4.19 | 7.78 | 1.86 | 91.49 |
| canterbury-large/world192.txt | 2473400 | libdeflate | 2.87 | 6.92 | 2.41 | 74.93 |
| canterbury-large/world192.txt | 2473400 | Wuffs | 5.17 | 11.48 | 2.22 | 127.87 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.72 | 5.40 | 1.99 | 90.58 |
| http/html-1kx1024 | 1048576 | zlib | 16.70 | 35.58 | 2.13 | 353.57 |
| http/html-1kx1024 | 1048576 | zlib-ng | 12.69 | 28.43 | 2.24 | 217.30 |
| http/html-1kx1024 | 1048576 | libdeflate | 10.58 | 20.05 | 1.90 | 155.59 |
| http/html-1kx1024 | 1048576 | Wuffs | 15.34 | 38.07 | 2.48 | 266.57 |
| http/html-1kx1024 | 1048576 | stdx | 8.41 | 20.88 | 2.48 | 137.67 |
| http/html-16kx64 | 1048576 | zlib | 6.72 | 14.77 | 2.20 | 221.27 |
| http/html-16kx64 | 1048576 | zlib-ng | 3.85 | 7.54 | 1.96 | 85.61 |
| http/html-16kx64 | 1048576 | libdeflate | 2.64 | 6.04 | 2.29 | 60.65 |
| http/html-16kx64 | 1048576 | Wuffs | 4.92 | 11.57 | 2.35 | 115.02 |
| http/html-16kx64 | 1048576 | stdx | 2.51 | 5.56 | 2.22 | 59.04 |
| http/html-1m | 1048576 | zlib | 5.30 | 12.53 | 2.36 | 175.90 |
| http/html-1m | 1048576 | zlib-ng | 2.63 | 5.03 | 1.92 | 60.45 |
| http/html-1m | 1048576 | libdeflate | 1.70 | 4.39 | 2.59 | 37.39 |
| http/html-1m | 1048576 | Wuffs | 3.60 | 8.48 | 2.35 | 87.91 |
| http/html-1m | 1048576 | stdx | 1.64 | 3.46 | 2.11 | 52.39 |
| http/json-1kx1024 | 1048576 | zlib | 10.60 | 23.92 | 2.26 | 192.58 |
| http/json-1kx1024 | 1048576 | zlib-ng | 7.42 | 16.69 | 2.25 | 132.01 |
| http/json-1kx1024 | 1048576 | libdeflate | 8.85 | 16.72 | 1.89 | 92.17 |
| http/json-1kx1024 | 1048576 | Wuffs | 12.12 | 34.78 | 2.87 | 146.45 |
| http/json-1kx1024 | 1048576 | stdx | 5.04 | 13.12 | 2.60 | 80.40 |
| http/json-16kx64 | 1048576 | zlib | 4.57 | 12.51 | 2.74 | 103.18 |
| http/json-16kx64 | 1048576 | zlib-ng | 2.64 | 5.50 | 2.08 | 53.51 |
| http/json-16kx64 | 1048576 | libdeflate | 1.92 | 4.24 | 2.21 | 40.61 |
| http/json-16kx64 | 1048576 | Wuffs | 3.50 | 9.43 | 2.70 | 57.79 |
| http/json-16kx64 | 1048576 | stdx | 1.76 | 3.97 | 2.25 | 39.55 |
| http/json-1m | 1048576 | zlib | 3.84 | 11.20 | 2.92 | 83.03 |
| http/json-1m | 1048576 | zlib-ng | 1.96 | 3.91 | 1.99 | 39.91 |
| http/json-1m | 1048576 | libdeflate | 1.38 | 3.33 | 2.41 | 32.76 |
| http/json-1m | 1048576 | Wuffs | 2.72 | 7.37 | 2.71 | 43.26 |
| http/json-1m | 1048576 | stdx | 1.32 | 2.67 | 2.02 | 39.92 |
| http/js-1kx1024 | 1048576 | zlib | 18.24 | 38.46 | 2.11 | 410.92 |
| http/js-1kx1024 | 1048576 | zlib-ng | 13.76 | 31.25 | 2.27 | 238.46 |
| http/js-1kx1024 | 1048576 | libdeflate | 11.25 | 21.58 | 1.92 | 178.28 |
| http/js-1kx1024 | 1048576 | Wuffs | 16.54 | 40.70 | 2.46 | 300.94 |
| http/js-1kx1024 | 1048576 | stdx | 9.30 | 22.85 | 2.46 | 159.31 |
| http/js-16kx64 | 1048576 | zlib | 7.67 | 16.08 | 2.10 | 264.59 |
| http/js-16kx64 | 1048576 | zlib-ng | 4.38 | 8.65 | 1.97 | 91.97 |
| http/js-16kx64 | 1048576 | libdeflate | 3.06 | 7.01 | 2.29 | 72.36 |
| http/js-16kx64 | 1048576 | Wuffs | 5.50 | 12.75 | 2.32 | 128.72 |
| http/js-16kx64 | 1048576 | stdx | 3.01 | 6.54 | 2.17 | 72.38 |
| http/js-1m | 1048576 | zlib | 5.87 | 13.31 | 2.27 | 201.64 |
| http/js-1m | 1048576 | zlib-ng | 2.88 | 5.66 | 1.97 | 60.37 |
| http/js-1m | 1048576 | libdeflate | 1.92 | 4.98 | 2.59 | 41.81 |
| http/js-1m | 1048576 | Wuffs | 3.90 | 9.14 | 2.34 | 93.53 |
| http/js-1m | 1048576 | stdx | 1.80 | 3.89 | 2.16 | 55.10 |
| http/css-1kx1024 | 1048576 | zlib | 14.04 | 30.36 | 2.16 | 281.67 |
| http/css-1kx1024 | 1048576 | zlib-ng | 10.27 | 23.04 | 2.24 | 172.37 |
| http/css-1kx1024 | 1048576 | libdeflate | 9.16 | 17.37 | 1.90 | 121.40 |
| http/css-1kx1024 | 1048576 | Wuffs | 12.76 | 32.50 | 2.55 | 210.09 |
| http/css-1kx1024 | 1048576 | stdx | 6.69 | 17.64 | 2.63 | 100.75 |
| http/css-16kx64 | 1048576 | zlib | 5.31 | 13.04 | 2.46 | 153.89 |
| http/css-16kx64 | 1048576 | zlib-ng | 2.81 | 6.07 | 2.16 | 52.36 |
| http/css-16kx64 | 1048576 | libdeflate | 1.89 | 4.69 | 2.48 | 30.32 |
| http/css-16kx64 | 1048576 | Wuffs | 3.79 | 10.01 | 2.65 | 69.39 |
| http/css-16kx64 | 1048576 | stdx | 1.72 | 4.36 | 2.53 | 28.40 |
| http/css-1m | 1048576 | zlib | 3.97 | 10.97 | 2.76 | 107.36 |
| http/css-1m | 1048576 | zlib-ng | 1.72 | 3.75 | 2.18 | 30.89 |
| http/css-1m | 1048576 | libdeflate | 1.07 | 3.18 | 2.97 | 13.13 |
| http/css-1m | 1048576 | Wuffs | 2.57 | 7.14 | 2.78 | 43.59 |
| http/css-1m | 1048576 | stdx | 1.01 | 2.56 | 2.53 | 21.20 |
| shuffled/dickens-1m | 1048576 | zlib | 13.31 | 25.88 | 1.94 | 374.17 |
| shuffled/dickens-1m | 1048576 | zlib-ng | 9.69 | 16.72 | 1.73 | 195.20 |
| shuffled/dickens-1m | 1048576 | libdeflate | 7.03 | 14.95 | 2.12 | 195.06 |
| shuffled/dickens-1m | 1048576 | Wuffs | 10.39 | 22.08 | 2.12 | 205.65 |
| shuffled/dickens-1m | 1048576 | stdx | 7.04 | 11.89 | 1.69 | 208.10 |

## Hardware counters per decoded octet, Zstandard at libzstd level 3

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | libzstd | 3.40 | 14.05 | 4.13 | 3.39 |
| silesia/dickens | 10192446 | stdx | 3.56 | 12.47 | 3.50 | 3.50 |
| silesia/mozilla | 51220480 | libzstd | 2.80 | 9.68 | 3.46 | 30.19 |
| silesia/mozilla | 51220480 | stdx | 2.83 | 9.68 | 3.42 | 15.85 |
| silesia/mr | 9970564 | libzstd | 2.95 | 11.99 | 4.07 | 6.11 |
| silesia/mr | 9970564 | stdx | 3.00 | 10.83 | 3.60 | 5.24 |
| silesia/nci | 33553445 | libzstd | 1.59 | 4.88 | 3.06 | 24.83 |
| silesia/nci | 33553445 | stdx | 1.56 | 4.63 | 2.98 | 13.60 |
| silesia/ooffice | 6152192 | libzstd | 3.34 | 12.19 | 3.65 | 31.05 |
| silesia/ooffice | 6152192 | stdx | 3.30 | 12.40 | 3.75 | 12.22 |
| silesia/osdb | 10085684 | libzstd | 2.31 | 8.45 | 3.65 | 14.98 |
| silesia/osdb | 10085684 | stdx | 2.36 | 8.11 | 3.43 | 15.34 |
| silesia/reymont | 6627202 | libzstd | 3.10 | 11.62 | 3.75 | 11.68 |
| silesia/reymont | 6627202 | stdx | 3.21 | 10.36 | 3.22 | 12.64 |
| silesia/samba | 21606400 | libzstd | 2.05 | 7.41 | 3.61 | 18.66 |
| silesia/samba | 21606400 | stdx | 2.12 | 6.83 | 3.22 | 17.95 |
| silesia/sao | 7251944 | libzstd | 3.73 | 12.72 | 3.41 | 26.68 |
| silesia/sao | 7251944 | stdx | 3.44 | 12.58 | 3.65 | 6.26 |
| silesia/webster | 41458703 | libzstd | 3.04 | 11.24 | 3.69 | 16.28 |
| silesia/webster | 41458703 | stdx | 3.19 | 10.05 | 3.15 | 17.77 |
| silesia/x-ray | 8474240 | libzstd | 3.87 | 14.94 | 3.86 | 18.82 |
| silesia/x-ray | 8474240 | stdx | 3.53 | 13.23 | 3.74 | 8.32 |
| silesia/xml | 5345280 | libzstd | 1.54 | 5.57 | 3.62 | 23.26 |
| silesia/xml | 5345280 | stdx | 1.50 | 5.16 | 3.44 | 17.26 |
| canterbury/alice29.txt | 152089 | libzstd | 3.31 | 16.20 | 4.89 | 4.12 |
| canterbury/alice29.txt | 152089 | stdx | 3.31 | 14.41 | 4.35 | 0.46 |
| canterbury/asyoulik.txt | 125179 | libzstd | 2.95 | 14.26 | 4.83 | 3.24 |
| canterbury/asyoulik.txt | 125179 | stdx | 2.98 | 12.83 | 4.30 | 0.23 |
| canterbury/cp.html | 24603 | libzstd | 2.63 | 10.74 | 4.08 | 7.76 |
| canterbury/cp.html | 24603 | stdx | 2.53 | 10.42 | 4.12 | 0.18 |
| canterbury/fields.c | 11150 | libzstd | 3.11 | 13.62 | 4.38 | 8.80 |
| canterbury/fields.c | 11150 | stdx | 3.01 | 12.72 | 4.23 | 0.19 |
| canterbury/grammar.lsp | 3721 | libzstd | 4.26 | 16.94 | 3.98 | 4.83 |
| canterbury/grammar.lsp | 3721 | stdx | 4.13 | 16.54 | 4.01 | 0.20 |
| canterbury/kennedy.xls | 1029744 | libzstd | 2.53 | 11.40 | 4.51 | 7.82 |
| canterbury/kennedy.xls | 1029744 | stdx | 2.67 | 11.32 | 4.23 | 0.95 |
| canterbury/lcet10.txt | 426754 | libzstd | 2.70 | 12.89 | 4.77 | 5.07 |
| canterbury/lcet10.txt | 426754 | stdx | 2.72 | 11.52 | 4.23 | 3.60 |
| canterbury/plrabn12.txt | 481861 | libzstd | 3.10 | 15.16 | 4.89 | 1.52 |
| canterbury/plrabn12.txt | 481861 | stdx | 3.17 | 13.51 | 4.26 | 0.86 |
| canterbury/ptt5 | 513216 | libzstd | 1.46 | 4.52 | 3.11 | 25.39 |
| canterbury/ptt5 | 513216 | stdx | 1.33 | 4.46 | 3.34 | 13.19 |
| canterbury/sum | 38240 | libzstd | 2.61 | 10.58 | 4.06 | 9.27 |
| canterbury/sum | 38240 | stdx | 2.62 | 10.74 | 4.10 | 0.32 |
| canterbury/xargs.1 | 4227 | libzstd | 4.26 | 17.41 | 4.09 | 9.51 |
| canterbury/xargs.1 | 4227 | stdx | 4.24 | 17.17 | 4.05 | 0.21 |
| canterbury-large/E.coli | 4638690 | libzstd | 2.99 | 13.64 | 4.56 | 2.12 |
| canterbury-large/E.coli | 4638690 | stdx | 3.06 | 12.04 | 3.94 | 2.90 |
| canterbury-large/bible.txt | 4047392 | libzstd | 2.89 | 12.00 | 4.15 | 8.43 |
| canterbury-large/bible.txt | 4047392 | stdx | 2.98 | 10.64 | 3.56 | 9.29 |
| canterbury-large/world192.txt | 2473400 | libzstd | 2.50 | 9.60 | 3.85 | 19.83 |
| canterbury-large/world192.txt | 2473400 | stdx | 2.56 | 8.64 | 3.37 | 21.64 |
| http/html-1kx1024 | 1048576 | libzstd | 7.25 | 21.63 | 2.98 | 63.16 |
| http/html-1kx1024 | 1048576 | stdx | 7.46 | 22.46 | 3.01 | 76.73 |
| http/html-16kx64 | 1048576 | libzstd | 2.66 | 10.15 | 3.81 | 28.61 |
| http/html-16kx64 | 1048576 | stdx | 2.66 | 9.61 | 3.61 | 30.13 |
| http/html-1m | 1048576 | libzstd | 2.00 | 7.88 | 3.94 | 24.25 |
| http/html-1m | 1048576 | stdx | 1.98 | 7.12 | 3.60 | 24.56 |
| http/json-1kx1024 | 1048576 | libzstd | 6.27 | 17.39 | 2.77 | 49.62 |
| http/json-1kx1024 | 1048576 | stdx | 6.22 | 17.86 | 2.87 | 53.74 |
| http/json-16kx64 | 1048576 | libzstd | 2.05 | 7.26 | 3.54 | 28.20 |
| http/json-16kx64 | 1048576 | stdx | 2.03 | 7.25 | 3.57 | 19.97 |
| http/json-1m | 1048576 | libzstd | 1.72 | 6.08 | 3.54 | 28.05 |
| http/json-1m | 1048576 | stdx | 1.62 | 5.91 | 3.64 | 14.61 |
| http/js-1kx1024 | 1048576 | libzstd | 8.33 | 26.35 | 3.16 | 73.34 |
| http/js-1kx1024 | 1048576 | stdx | 9.04 | 27.60 | 3.05 | 113.15 |
| http/js-16kx64 | 1048576 | libzstd | 2.93 | 11.72 | 4.00 | 24.44 |
| http/js-16kx64 | 1048576 | stdx | 2.96 | 11.06 | 3.73 | 26.65 |
| http/js-1m | 1048576 | libzstd | 2.02 | 8.19 | 4.06 | 20.39 |
| http/js-1m | 1048576 | stdx | 2.05 | 7.48 | 3.64 | 21.60 |
| http/css-1kx1024 | 1048576 | libzstd | 6.88 | 19.69 | 2.86 | 53.30 |
| http/css-1kx1024 | 1048576 | stdx | 6.85 | 19.96 | 2.91 | 63.82 |
| http/css-16kx64 | 1048576 | libzstd | 2.24 | 8.70 | 3.88 | 22.66 |
| http/css-16kx64 | 1048576 | stdx | 2.27 | 8.43 | 3.71 | 22.00 |
| http/css-1m | 1048576 | libzstd | 0.66 | 2.58 | 3.88 | 5.45 |
| http/css-1m | 1048576 | stdx | 0.70 | 2.49 | 3.54 | 3.67 |
| shuffled/dickens-1m | 1048576 | libzstd | 2.76 | 9.40 | 3.40 | 28.59 |
| shuffled/dickens-1m | 1048576 | stdx | 2.73 | 9.19 | 3.37 | 12.66 |

## Hardware counters per decoded octet, brotli at quality 11, window 22, first 1024 KiB

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Decoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|
| silesia/dickens | 1048576 | Google | 7.42 | 16.93 | 2.28 | 99.97 |
| silesia/dickens | 1048576 | stdx | 5.06 | 12.38 | 2.45 | 54.64 |
| silesia/mozilla | 1048576 | Google | 13.44 | 28.31 | 2.11 | 46.54 |
| silesia/mozilla | 1048576 | stdx | 8.32 | 15.02 | 1.81 | 47.66 |
| silesia/mr | 1048576 | Google | 8.87 | 20.21 | 2.28 | 102.71 |
| silesia/mr | 1048576 | stdx | 5.76 | 13.25 | 2.30 | 88.30 |
| silesia/nci | 1048576 | Google | 2.54 | 5.70 | 2.24 | 52.16 |
| silesia/nci | 1048576 | stdx | 1.94 | 3.95 | 2.04 | 54.78 |
| silesia/ooffice | 1048576 | Google | 14.10 | 29.27 | 2.08 | 287.75 |
| silesia/ooffice | 1048576 | stdx | 10.86 | 20.33 | 1.87 | 324.54 |
| silesia/osdb | 1048576 | Google | 8.19 | 17.48 | 2.14 | 96.03 |
| silesia/osdb | 1048576 | stdx | 5.16 | 10.57 | 2.05 | 91.89 |
| silesia/reymont | 1048576 | Google | 5.39 | 12.62 | 2.34 | 82.68 |
| silesia/reymont | 1048576 | stdx | 3.69 | 9.25 | 2.50 | 47.30 |
| silesia/samba | 1048576 | Google | 7.56 | 16.30 | 2.16 | 95.03 |
| silesia/samba | 1048576 | stdx | 5.07 | 10.71 | 2.11 | 67.00 |
| silesia/sao | 1048576 | Google | 16.82 | 37.18 | 2.21 | 163.05 |
| silesia/sao | 1048576 | stdx | 10.41 | 22.65 | 2.18 | 142.83 |
| silesia/webster | 1048576 | Google | 6.49 | 14.00 | 2.16 | 113.82 |
| silesia/webster | 1048576 | stdx | 4.41 | 9.98 | 2.26 | 69.26 |
| silesia/x-ray | 1048576 | Google | 19.28 | 38.56 | 2.00 | 235.31 |
| silesia/x-ray | 1048576 | stdx | 14.48 | 30.18 | 2.09 | 234.86 |
| silesia/xml | 1048576 | Google | 3.44 | 7.61 | 2.21 | 65.29 |
| silesia/xml | 1048576 | stdx | 2.40 | 5.40 | 2.25 | 46.93 |
| canterbury/alice29.txt | 152089 | Google | 8.87 | 20.55 | 2.32 | 134.26 |
| canterbury/alice29.txt | 152089 | stdx | 6.08 | 15.33 | 2.52 | 79.83 |
| canterbury/asyoulik.txt | 125179 | Google | 10.36 | 23.71 | 2.29 | 167.70 |
| canterbury/asyoulik.txt | 125179 | stdx | 7.07 | 17.43 | 2.47 | 103.20 |
| canterbury/cp.html | 24603 | Google | 8.99 | 22.20 | 2.47 | 106.76 |
| canterbury/cp.html | 24603 | stdx | 6.02 | 17.15 | 2.85 | 49.17 |
| canterbury/fields.c | 11150 | Google | 7.08 | 21.16 | 2.99 | 25.48 |
| canterbury/fields.c | 11150 | stdx | 4.92 | 17.08 | 3.47 | 4.17 |
| canterbury/grammar.lsp | 3721 | Google | 9.80 | 30.16 | 3.08 | 6.52 |
| canterbury/grammar.lsp | 3721 | stdx | 7.15 | 25.04 | 3.50 | 0.41 |
| canterbury/kennedy.xls | 1029744 | Google | 5.44 | 17.05 | 3.13 | 37.37 |
| canterbury/kennedy.xls | 1029744 | stdx | 3.79 | 12.94 | 3.41 | 34.02 |
| canterbury/lcet10.txt | 426754 | Google | 7.71 | 17.36 | 2.25 | 126.02 |
| canterbury/lcet10.txt | 426754 | stdx | 5.22 | 12.96 | 2.48 | 66.11 |
| canterbury/plrabn12.txt | 481861 | Google | 9.05 | 20.82 | 2.30 | 132.58 |
| canterbury/plrabn12.txt | 481861 | stdx | 6.17 | 15.04 | 2.44 | 87.16 |
| canterbury/ptt5 | 513216 | Google | 4.28 | 10.41 | 2.43 | 62.07 |
| canterbury/ptt5 | 513216 | stdx | 2.38 | 4.89 | 2.05 | 65.46 |
| canterbury/sum | 38240 | Google | 10.85 | 26.44 | 2.44 | 159.37 |
| canterbury/sum | 38240 | stdx | 8.41 | 21.11 | 2.51 | 156.26 |
| canterbury/xargs.1 | 4227 | Google | 10.99 | 34.81 | 3.17 | 9.55 |
| canterbury/xargs.1 | 4227 | stdx | 8.51 | 30.44 | 3.58 | 6.95 |
| canterbury-large/E.coli | 1048576 | Google | 8.13 | 19.55 | 2.40 | 1.66 |
| canterbury-large/E.coli | 1048576 | stdx | 6.71 | 13.48 | 2.01 | 1.21 |
| canterbury-large/bible.txt | 1048576 | Google | 5.29 | 12.28 | 2.32 | 80.75 |
| canterbury-large/bible.txt | 1048576 | stdx | 3.53 | 8.93 | 2.53 | 39.86 |
| canterbury-large/world192.txt | 1048576 | Google | 6.14 | 12.84 | 2.09 | 115.03 |
| canterbury-large/world192.txt | 1048576 | stdx | 4.39 | 9.38 | 2.13 | 77.42 |
| http/html-1kx1024 | 1048576 | Google | 18.04 | 41.93 | 2.32 | 386.56 |
| http/html-1kx1024 | 1048576 | stdx | 15.33 | 37.56 | 2.45 | 361.26 |
| http/html-16kx64 | 1048576 | Google | 6.72 | 14.85 | 2.21 | 149.12 |
| http/html-16kx64 | 1048576 | stdx | 5.15 | 12.15 | 2.36 | 114.35 |
| http/html-1m | 1048576 | Google | 4.02 | 8.94 | 2.22 | 83.14 |
| http/html-1m | 1048576 | stdx | 2.85 | 6.52 | 2.29 | 54.84 |
| http/json-1kx1024 | 1048576 | Google | 14.47 | 36.64 | 2.53 | 241.01 |
| http/json-1kx1024 | 1048576 | stdx | 12.97 | 33.63 | 2.59 | 276.75 |
| http/json-16kx64 | 1048576 | Google | 4.41 | 11.43 | 2.59 | 81.54 |
| http/json-16kx64 | 1048576 | stdx | 3.37 | 8.42 | 2.50 | 83.32 |
| http/json-1m | 1048576 | Google | 3.39 | 8.65 | 2.55 | 58.90 |
| http/json-1m | 1048576 | stdx | 2.46 | 5.99 | 2.44 | 58.08 |
| http/js-1kx1024 | 1048576 | Google | 19.98 | 46.20 | 2.31 | 429.90 |
| http/js-1kx1024 | 1048576 | stdx | 16.42 | 39.90 | 2.43 | 381.74 |
| http/js-16kx64 | 1048576 | Google | 8.03 | 17.73 | 2.21 | 167.43 |
| http/js-16kx64 | 1048576 | stdx | 6.03 | 14.36 | 2.38 | 125.24 |
| http/js-1m | 1048576 | Google | 4.32 | 9.54 | 2.21 | 82.94 |
| http/js-1m | 1048576 | stdx | 3.16 | 7.25 | 2.30 | 55.37 |
| http/css-1kx1024 | 1048576 | Google | 15.48 | 37.36 | 2.41 | 293.68 |
| http/css-1kx1024 | 1048576 | stdx | 13.81 | 34.70 | 2.51 | 303.37 |
| http/css-16kx64 | 1048576 | Google | 4.94 | 11.76 | 2.38 | 101.58 |
| http/css-16kx64 | 1048576 | stdx | 3.84 | 9.54 | 2.49 | 80.54 |
| http/css-1m | 1048576 | Google | 2.43 | 9.42 | 3.88 | 16.91 |
| http/css-1m | 1048576 | stdx | 0.75 | 1.86 | 2.49 | 11.80 |
| shuffled/dickens-1m | 1048576 | Google | 10.09 | 20.65 | 2.05 | 105.64 |
| shuffled/dickens-1m | 1048576 | stdx | 8.78 | 14.53 | 1.65 | 119.65 |

## Hardware counters per input octet, gzip encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libdeflate | 15.23 | 36.91 | 2.42 | 410.36 |
| silesia/dickens | 10192446 | 1 | stdx | 16.32 | 38.17 | 2.34 | 359.09 |
| silesia/dickens | 10192446 | 6 | libdeflate | 52.12 | 87.63 | 1.68 | 696.18 |
| silesia/dickens | 10192446 | 6 | stdx | 49.37 | 84.26 | 1.71 | 1418.62 |
| silesia/dickens | 10192446 | 9 | libdeflate | 111.84 | 160.47 | 1.43 | 929.80 |
| silesia/dickens | 10192446 | 9 | stdx | 84.89 | 191.80 | 2.26 | 1713.67 |
| silesia/mozilla | 51220480 | 1 | libdeflate | 14.16 | 32.62 | 2.30 | 440.53 |
| silesia/mozilla | 51220480 | 1 | stdx | 13.35 | 30.24 | 2.27 | 295.22 |
| silesia/mozilla | 51220480 | 6 | libdeflate | 32.90 | 70.83 | 2.15 | 579.18 |
| silesia/mozilla | 51220480 | 6 | stdx | 31.53 | 69.96 | 2.22 | 734.27 |
| silesia/mozilla | 51220480 | 9 | libdeflate | 127.58 | 221.49 | 1.74 | 768.42 |
| silesia/mozilla | 51220480 | 9 | stdx | 48.99 | 126.12 | 2.57 | 789.83 |
| silesia/mr | 9970564 | 1 | libdeflate | 12.00 | 35.02 | 2.92 | 230.26 |
| silesia/mr | 9970564 | 1 | stdx | 12.62 | 34.08 | 2.70 | 187.15 |
| silesia/mr | 9970564 | 6 | libdeflate | 38.24 | 80.54 | 2.11 | 437.50 |
| silesia/mr | 9970564 | 6 | stdx | 39.59 | 83.18 | 2.10 | 962.61 |
| silesia/mr | 9970564 | 9 | libdeflate | 97.73 | 165.48 | 1.69 | 754.91 |
| silesia/mr | 9970564 | 9 | stdx | 86.95 | 206.31 | 2.37 | 1328.02 |
| silesia/nci | 33553445 | 1 | libdeflate | 6.27 | 18.42 | 2.94 | 117.41 |
| silesia/nci | 33553445 | 1 | stdx | 4.96 | 10.88 | 2.19 | 97.97 |
| silesia/nci | 33553445 | 6 | libdeflate | 17.01 | 34.84 | 2.05 | 226.31 |
| silesia/nci | 33553445 | 6 | stdx | 14.35 | 29.54 | 2.06 | 389.77 |
| silesia/nci | 33553445 | 9 | libdeflate | 62.41 | 105.28 | 1.69 | 498.49 |
| silesia/nci | 33553445 | 9 | stdx | 33.06 | 80.63 | 2.44 | 648.23 |
| silesia/ooffice | 6152192 | 1 | libdeflate | 19.95 | 39.15 | 1.96 | 754.02 |
| silesia/ooffice | 6152192 | 1 | stdx | 17.76 | 39.08 | 2.20 | 429.56 |
| silesia/ooffice | 6152192 | 6 | libdeflate | 41.09 | 79.10 | 1.92 | 955.91 |
| silesia/ooffice | 6152192 | 6 | stdx | 41.64 | 87.83 | 2.11 | 1010.71 |
| silesia/ooffice | 6152192 | 9 | libdeflate | 74.64 | 127.63 | 1.71 | 1133.43 |
| silesia/ooffice | 6152192 | 9 | stdx | 52.55 | 129.17 | 2.46 | 936.53 |
| silesia/osdb | 10085684 | 1 | libdeflate | 12.92 | 30.15 | 2.33 | 355.32 |
| silesia/osdb | 10085684 | 1 | stdx | 12.93 | 27.86 | 2.16 | 294.66 |
| silesia/osdb | 10085684 | 6 | libdeflate | 28.28 | 55.67 | 1.97 | 491.96 |
| silesia/osdb | 10085684 | 6 | stdx | 27.06 | 57.40 | 2.12 | 568.64 |
| silesia/osdb | 10085684 | 9 | libdeflate | 33.97 | 64.15 | 1.89 | 554.95 |
| silesia/osdb | 10085684 | 9 | stdx | 35.46 | 87.23 | 2.46 | 690.38 |
| silesia/reymont | 6627202 | 1 | libdeflate | 12.59 | 32.88 | 2.61 | 311.22 |
| silesia/reymont | 6627202 | 1 | stdx | 13.42 | 33.24 | 2.48 | 270.26 |
| silesia/reymont | 6627202 | 6 | libdeflate | 48.09 | 86.58 | 1.80 | 520.24 |
| silesia/reymont | 6627202 | 6 | stdx | 44.91 | 76.82 | 1.71 | 1404.85 |
| silesia/reymont | 6627202 | 9 | libdeflate | 198.12 | 276.14 | 1.39 | 835.41 |
| silesia/reymont | 6627202 | 9 | stdx | 87.24 | 189.97 | 2.18 | 1610.63 |
| silesia/samba | 21606400 | 1 | libdeflate | 10.45 | 26.53 | 2.54 | 273.49 |
| silesia/samba | 21606400 | 1 | stdx | 9.87 | 22.23 | 2.25 | 220.89 |
| silesia/samba | 21606400 | 6 | libdeflate | 29.00 | 58.79 | 2.03 | 386.67 |
| silesia/samba | 21606400 | 6 | stdx | 24.05 | 49.84 | 2.07 | 619.20 |
| silesia/samba | 21606400 | 9 | libdeflate | 84.20 | 141.44 | 1.68 | 503.85 |
| silesia/samba | 21606400 | 9 | stdx | 41.51 | 102.63 | 2.47 | 730.84 |
| silesia/sao | 7251944 | 1 | libdeflate | 21.74 | 47.87 | 2.20 | 686.14 |
| silesia/sao | 7251944 | 1 | stdx | 19.15 | 49.92 | 2.61 | 346.66 |
| silesia/sao | 7251944 | 6 | libdeflate | 51.24 | 96.89 | 1.89 | 969.65 |
| silesia/sao | 7251944 | 6 | stdx | 47.07 | 105.65 | 2.24 | 853.02 |
| silesia/sao | 7251944 | 9 | libdeflate | 70.99 | 120.26 | 1.69 | 1106.77 |
| silesia/sao | 7251944 | 9 | stdx | 55.56 | 138.16 | 2.49 | 846.18 |
| silesia/webster | 41458703 | 1 | libdeflate | 13.13 | 30.45 | 2.32 | 387.68 |
| silesia/webster | 41458703 | 1 | stdx | 13.84 | 29.08 | 2.10 | 339.73 |
| silesia/webster | 41458703 | 6 | libdeflate | 37.10 | 66.02 | 1.78 | 574.01 |
| silesia/webster | 41458703 | 6 | stdx | 35.10 | 60.88 | 1.73 | 1105.95 |
| silesia/webster | 41458703 | 9 | libdeflate | 94.63 | 138.85 | 1.47 | 757.70 |
| silesia/webster | 41458703 | 9 | stdx | 60.61 | 135.96 | 2.24 | 1292.32 |
| silesia/x-ray | 8474240 | 1 | libdeflate | 23.68 | 49.67 | 2.10 | 785.12 |
| silesia/x-ray | 8474240 | 1 | stdx | 17.60 | 50.81 | 2.89 | 261.47 |
| silesia/x-ray | 8474240 | 6 | libdeflate | 32.89 | 82.77 | 2.52 | 851.51 |
| silesia/x-ray | 8474240 | 6 | stdx | 33.85 | 98.11 | 2.90 | 541.77 |
| silesia/x-ray | 8474240 | 9 | libdeflate | 37.53 | 91.03 | 2.43 | 1030.14 |
| silesia/x-ray | 8474240 | 9 | stdx | 40.92 | 122.05 | 2.98 | 467.73 |
| silesia/xml | 5345280 | 1 | libdeflate | 7.80 | 21.59 | 2.77 | 176.97 |
| silesia/xml | 5345280 | 1 | stdx | 6.95 | 15.66 | 2.25 | 155.25 |
| silesia/xml | 5345280 | 6 | libdeflate | 21.24 | 40.51 | 1.91 | 265.31 |
| silesia/xml | 5345280 | 6 | stdx | 17.71 | 34.32 | 1.94 | 494.90 |
| silesia/xml | 5345280 | 9 | libdeflate | 58.66 | 89.17 | 1.52 | 371.11 |
| silesia/xml | 5345280 | 9 | stdx | 31.15 | 72.83 | 2.34 | 599.21 |
| canterbury/alice29.txt | 152089 | 1 | libdeflate | 14.29 | 35.61 | 2.49 | 380.62 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 15.01 | 36.12 | 2.41 | 334.78 |
| canterbury/alice29.txt | 152089 | 6 | libdeflate | 46.78 | 82.29 | 1.76 | 643.05 |
| canterbury/alice29.txt | 152089 | 6 | stdx | 43.68 | 77.43 | 1.77 | 1307.30 |
| canterbury/alice29.txt | 152089 | 9 | libdeflate | 107.56 | 159.21 | 1.48 | 850.95 |
| canterbury/alice29.txt | 152089 | 9 | stdx | 72.60 | 167.73 | 2.31 | 1510.05 |
| canterbury/asyoulik.txt | 125179 | 1 | libdeflate | 15.17 | 37.20 | 2.45 | 417.47 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 15.76 | 37.43 | 2.38 | 357.89 |
| canterbury/asyoulik.txt | 125179 | 6 | libdeflate | 48.37 | 85.43 | 1.77 | 718.09 |
| canterbury/asyoulik.txt | 125179 | 6 | stdx | 46.07 | 81.93 | 1.78 | 1373.07 |
| canterbury/asyoulik.txt | 125179 | 9 | libdeflate | 89.01 | 136.15 | 1.53 | 940.34 |
| canterbury/asyoulik.txt | 125179 | 9 | stdx | 75.53 | 175.97 | 2.33 | 1609.76 |
| canterbury/cp.html | 24603 | 1 | libdeflate | 11.69 | 32.02 | 2.74 | 282.93 |
| canterbury/cp.html | 24603 | 1 | stdx | 11.05 | 27.13 | 2.46 | 249.62 |
| canterbury/cp.html | 24603 | 6 | libdeflate | 27.02 | 62.33 | 2.31 | 489.34 |
| canterbury/cp.html | 24603 | 6 | stdx | 23.88 | 57.06 | 2.39 | 634.85 |
| canterbury/cp.html | 24603 | 9 | libdeflate | 46.93 | 91.97 | 1.96 | 594.81 |
| canterbury/cp.html | 24603 | 9 | stdx | 31.18 | 88.89 | 2.85 | 646.33 |
| canterbury/fields.c | 11150 | 1 | libdeflate | 9.45 | 35.92 | 3.80 | 57.09 |
| canterbury/fields.c | 11150 | 1 | stdx | 8.08 | 30.05 | 3.72 | 22.52 |
| canterbury/fields.c | 11150 | 6 | libdeflate | 24.13 | 69.37 | 2.87 | 224.93 |
| canterbury/fields.c | 11150 | 6 | stdx | 20.92 | 57.62 | 2.75 | 435.79 |
| canterbury/fields.c | 11150 | 9 | libdeflate | 44.73 | 100.81 | 2.25 | 432.04 |
| canterbury/fields.c | 11150 | 9 | stdx | 28.42 | 92.66 | 3.26 | 448.40 |
| canterbury/grammar.lsp | 3721 | 1 | libdeflate | 13.08 | 51.51 | 3.94 | 12.07 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 9.87 | 39.01 | 3.95 | 1.87 |
| canterbury/grammar.lsp | 3721 | 6 | libdeflate | 23.82 | 87.06 | 3.65 | 30.77 |
| canterbury/grammar.lsp | 3721 | 6 | stdx | 17.24 | 70.81 | 4.11 | 19.73 |
| canterbury/grammar.lsp | 3721 | 9 | libdeflate | 30.85 | 102.89 | 3.34 | 43.59 |
| canterbury/grammar.lsp | 3721 | 9 | stdx | 23.63 | 99.31 | 4.20 | 69.19 |
| canterbury/kennedy.xls | 1029744 | 1 | libdeflate | 7.38 | 27.18 | 3.68 | 65.39 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 7.04 | 22.58 | 3.21 | 63.44 |
| canterbury/kennedy.xls | 1029744 | 6 | libdeflate | 27.94 | 73.85 | 2.64 | 96.77 |
| canterbury/kennedy.xls | 1029744 | 6 | stdx | 19.32 | 61.99 | 3.21 | 139.03 |
| canterbury/kennedy.xls | 1029744 | 9 | libdeflate | 362.39 | 664.23 | 1.83 | 167.07 |
| canterbury/kennedy.xls | 1029744 | 9 | stdx | 37.60 | 130.89 | 3.48 | 221.38 |
| canterbury/lcet10.txt | 426754 | 1 | libdeflate | 13.81 | 33.99 | 2.46 | 371.89 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 14.48 | 33.92 | 2.34 | 331.42 |
| canterbury/lcet10.txt | 426754 | 6 | libdeflate | 45.05 | 78.22 | 1.74 | 609.33 |
| canterbury/lcet10.txt | 426754 | 6 | stdx | 41.58 | 73.43 | 1.77 | 1208.97 |
| canterbury/lcet10.txt | 426754 | 9 | libdeflate | 91.77 | 136.94 | 1.49 | 804.77 |
| canterbury/lcet10.txt | 426754 | 9 | stdx | 70.49 | 162.24 | 2.30 | 1449.90 |
| canterbury/plrabn12.txt | 481861 | 1 | libdeflate | 15.81 | 38.62 | 2.44 | 425.75 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 16.67 | 40.24 | 2.41 | 366.82 |
| canterbury/plrabn12.txt | 481861 | 6 | libdeflate | 54.16 | 91.90 | 1.70 | 752.29 |
| canterbury/plrabn12.txt | 481861 | 6 | stdx | 51.44 | 88.90 | 1.73 | 1491.53 |
| canterbury/plrabn12.txt | 481861 | 9 | libdeflate | 116.97 | 166.26 | 1.42 | 1005.02 |
| canterbury/plrabn12.txt | 481861 | 9 | stdx | 88.51 | 201.33 | 2.27 | 1800.36 |
| canterbury/ptt5 | 513216 | 1 | libdeflate | 6.43 | 18.61 | 2.89 | 142.01 |
| canterbury/ptt5 | 513216 | 1 | stdx | 4.96 | 11.03 | 2.22 | 123.21 |
| canterbury/ptt5 | 513216 | 6 | libdeflate | 14.32 | 36.17 | 2.52 | 221.13 |
| canterbury/ptt5 | 513216 | 6 | stdx | 12.30 | 29.58 | 2.41 | 306.52 |
| canterbury/ptt5 | 513216 | 9 | libdeflate | 60.50 | 120.86 | 2.00 | 375.03 |
| canterbury/ptt5 | 513216 | 9 | stdx | 43.08 | 130.09 | 3.02 | 639.48 |
| canterbury/sum | 38240 | 1 | libdeflate | 12.89 | 33.49 | 2.60 | 341.97 |
| canterbury/sum | 38240 | 1 | stdx | 12.51 | 29.36 | 2.35 | 295.73 |
| canterbury/sum | 38240 | 6 | libdeflate | 28.70 | 69.87 | 2.43 | 499.33 |
| canterbury/sum | 38240 | 6 | stdx | 26.78 | 65.74 | 2.45 | 665.66 |
| canterbury/sum | 38240 | 9 | libdeflate | 94.22 | 181.91 | 1.93 | 598.55 |
| canterbury/sum | 38240 | 9 | stdx | 39.26 | 112.33 | 2.86 | 658.78 |
| canterbury/xargs.1 | 4227 | 1 | libdeflate | 13.36 | 53.06 | 3.97 | 21.78 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 10.68 | 43.10 | 4.03 | 4.60 |
| canterbury/xargs.1 | 4227 | 6 | libdeflate | 22.89 | 87.70 | 3.83 | 67.31 |
| canterbury/xargs.1 | 4227 | 6 | stdx | 17.94 | 74.35 | 4.14 | 40.49 |
| canterbury/xargs.1 | 4227 | 9 | libdeflate | 24.88 | 94.34 | 3.79 | 90.66 |
| canterbury/xargs.1 | 4227 | 9 | stdx | 26.23 | 106.96 | 4.08 | 125.39 |
| canterbury-large/E.coli | 4638690 | 1 | libdeflate | 12.06 | 40.47 | 3.36 | 163.33 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 12.69 | 42.29 | 3.33 | 102.01 |
| canterbury-large/E.coli | 4638690 | 6 | libdeflate | 183.45 | 395.99 | 2.16 | 262.92 |
| canterbury-large/E.coli | 4638690 | 6 | stdx | 122.64 | 374.12 | 3.05 | 1903.41 |
| canterbury-large/E.coli | 4638690 | 9 | libdeflate | 817.49 | 1063.49 | 1.30 | 1310.91 |
| canterbury-large/E.coli | 4638690 | 9 | stdx | 229.10 | 755.68 | 3.30 | 2425.55 |
| canterbury-large/bible.txt | 4047392 | 1 | libdeflate | 12.56 | 32.38 | 2.58 | 311.87 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 13.32 | 32.23 | 2.42 | 281.08 |
| canterbury-large/bible.txt | 4047392 | 6 | libdeflate | 46.11 | 80.12 | 1.74 | 523.62 |
| canterbury-large/bible.txt | 4047392 | 6 | stdx | 42.18 | 72.39 | 1.72 | 1250.15 |
| canterbury-large/bible.txt | 4047392 | 9 | libdeflate | 141.67 | 200.28 | 1.41 | 741.73 |
| canterbury-large/bible.txt | 4047392 | 9 | stdx | 76.18 | 170.21 | 2.23 | 1441.84 |
| canterbury-large/world192.txt | 2473400 | 1 | libdeflate | 13.33 | 29.72 | 2.23 | 415.52 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 14.16 | 28.55 | 2.02 | 379.34 |
| canterbury-large/world192.txt | 2473400 | 6 | libdeflate | 33.11 | 60.25 | 1.82 | 561.37 |
| canterbury-large/world192.txt | 2473400 | 6 | stdx | 31.99 | 56.80 | 1.78 | 982.57 |
| canterbury-large/world192.txt | 2473400 | 9 | libdeflate | 80.65 | 119.11 | 1.48 | 686.91 |
| canterbury-large/world192.txt | 2473400 | 9 | stdx | 51.79 | 117.95 | 2.28 | 1144.07 |
| http/html-1kx1024 | 1048576 | 1 | libdeflate | 35.82 | 103.92 | 2.90 | 457.02 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 21.38 | 58.63 | 2.74 | 366.16 |
| http/html-1kx1024 | 1048576 | 6 | libdeflate | 46.30 | 138.33 | 2.99 | 565.78 |
| http/html-1kx1024 | 1048576 | 6 | stdx | 31.93 | 94.31 | 2.95 | 527.42 |
| http/html-1kx1024 | 1048576 | 9 | libdeflate | 47.93 | 142.44 | 2.97 | 590.10 |
| http/html-1kx1024 | 1048576 | 9 | stdx | 35.97 | 112.13 | 3.12 | 537.45 |
| http/html-16kx64 | 1048576 | 1 | libdeflate | 10.50 | 27.96 | 2.66 | 268.89 |
| http/html-16kx64 | 1048576 | 1 | stdx | 9.02 | 20.25 | 2.25 | 234.73 |
| http/html-16kx64 | 1048576 | 6 | libdeflate | 22.43 | 52.09 | 2.32 | 395.68 |
| http/html-16kx64 | 1048576 | 6 | stdx | 18.88 | 42.86 | 2.27 | 542.88 |
| http/html-16kx64 | 1048576 | 9 | libdeflate | 35.11 | 72.54 | 2.07 | 463.91 |
| http/html-16kx64 | 1048576 | 9 | stdx | 24.75 | 69.05 | 2.79 | 552.19 |
| http/html-1m | 1048576 | 1 | libdeflate | 8.78 | 23.03 | 2.62 | 224.96 |
| http/html-1m | 1048576 | 1 | stdx | 8.14 | 17.79 | 2.19 | 206.04 |
| http/html-1m | 1048576 | 6 | libdeflate | 25.35 | 49.53 | 1.95 | 330.01 |
| http/html-1m | 1048576 | 6 | stdx | 21.17 | 40.71 | 1.92 | 615.91 |
| http/html-1m | 1048576 | 9 | libdeflate | 71.13 | 109.24 | 1.54 | 429.87 |
| http/html-1m | 1048576 | 9 | stdx | 35.73 | 85.76 | 2.40 | 706.27 |
| http/json-1kx1024 | 1048576 | 1 | libdeflate | 32.16 | 94.80 | 2.95 | 302.48 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 16.48 | 45.16 | 2.74 | 242.45 |
| http/json-1kx1024 | 1048576 | 6 | libdeflate | 43.17 | 126.60 | 2.93 | 372.74 |
| http/json-1kx1024 | 1048576 | 6 | stdx | 27.09 | 78.37 | 2.89 | 379.46 |
| http/json-1kx1024 | 1048576 | 9 | libdeflate | 52.66 | 142.45 | 2.71 | 433.92 |
| http/json-1kx1024 | 1048576 | 9 | stdx | 30.62 | 95.56 | 3.12 | 386.12 |
| http/json-16kx64 | 1048576 | 1 | libdeflate | 7.89 | 23.85 | 3.02 | 135.63 |
| http/json-16kx64 | 1048576 | 1 | stdx | 5.43 | 13.94 | 2.57 | 110.48 |
| http/json-16kx64 | 1048576 | 6 | libdeflate | 18.23 | 46.61 | 2.56 | 206.44 |
| http/json-16kx64 | 1048576 | 6 | stdx | 13.41 | 35.01 | 2.61 | 279.70 |
| http/json-16kx64 | 1048576 | 9 | libdeflate | 80.26 | 151.99 | 1.89 | 295.94 |
| http/json-16kx64 | 1048576 | 9 | stdx | 19.17 | 58.45 | 3.05 | 303.33 |
| http/json-1m | 1048576 | 1 | libdeflate | 6.75 | 19.85 | 2.94 | 125.30 |
| http/json-1m | 1048576 | 1 | stdx | 5.05 | 12.51 | 2.47 | 102.61 |
| http/json-1m | 1048576 | 6 | libdeflate | 20.33 | 45.30 | 2.23 | 175.57 |
| http/json-1m | 1048576 | 6 | stdx | 14.67 | 35.09 | 2.39 | 297.69 |
| http/json-1m | 1048576 | 9 | libdeflate | 121.49 | 205.21 | 1.69 | 276.40 |
| http/json-1m | 1048576 | 9 | stdx | 29.00 | 72.87 | 2.51 | 369.33 |
| http/js-1kx1024 | 1048576 | 1 | libdeflate | 37.49 | 107.80 | 2.88 | 520.53 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 23.65 | 65.40 | 2.77 | 410.93 |
| http/js-1kx1024 | 1048576 | 6 | libdeflate | 49.50 | 144.85 | 2.93 | 681.97 |
| http/js-1kx1024 | 1048576 | 6 | stdx | 35.58 | 104.12 | 2.93 | 622.04 |
| http/js-1kx1024 | 1048576 | 9 | libdeflate | 51.97 | 150.13 | 2.89 | 715.35 |
| http/js-1kx1024 | 1048576 | 9 | stdx | 40.18 | 125.13 | 3.11 | 626.81 |
| http/js-16kx64 | 1048576 | 1 | libdeflate | 11.78 | 30.90 | 2.62 | 310.87 |
| http/js-16kx64 | 1048576 | 1 | stdx | 10.83 | 24.80 | 2.29 | 273.45 |
| http/js-16kx64 | 1048576 | 6 | libdeflate | 25.93 | 59.43 | 2.29 | 471.36 |
| http/js-16kx64 | 1048576 | 6 | stdx | 22.66 | 50.05 | 2.21 | 674.45 |
| http/js-16kx64 | 1048576 | 9 | libdeflate | 40.89 | 83.31 | 2.04 | 564.61 |
| http/js-16kx64 | 1048576 | 9 | stdx | 29.61 | 81.30 | 2.75 | 666.18 |
| http/js-1m | 1048576 | 1 | libdeflate | 9.66 | 25.19 | 2.61 | 248.61 |
| http/js-1m | 1048576 | 1 | stdx | 9.54 | 21.31 | 2.23 | 234.11 |
| http/js-1m | 1048576 | 6 | libdeflate | 28.78 | 56.12 | 1.95 | 372.30 |
| http/js-1m | 1048576 | 6 | stdx | 24.84 | 46.64 | 1.88 | 742.58 |
| http/js-1m | 1048576 | 9 | libdeflate | 76.18 | 120.65 | 1.58 | 498.98 |
| http/js-1m | 1048576 | 9 | stdx | 41.94 | 100.01 | 2.38 | 815.13 |
| http/css-1kx1024 | 1048576 | 1 | libdeflate | 33.57 | 97.73 | 2.91 | 375.75 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 18.36 | 49.52 | 2.70 | 301.56 |
| http/css-1kx1024 | 1048576 | 6 | libdeflate | 43.87 | 129.22 | 2.95 | 477.48 |
| http/css-1kx1024 | 1048576 | 6 | stdx | 28.99 | 82.32 | 2.84 | 504.81 |
| http/css-1kx1024 | 1048576 | 9 | libdeflate | 46.04 | 133.80 | 2.91 | 508.02 |
| http/css-1kx1024 | 1048576 | 9 | stdx | 33.02 | 99.48 | 3.01 | 522.75 |
| http/css-16kx64 | 1048576 | 1 | libdeflate | 8.67 | 25.60 | 2.95 | 174.52 |
| http/css-16kx64 | 1048576 | 1 | stdx | 6.66 | 16.96 | 2.55 | 135.51 |
| http/css-16kx64 | 1048576 | 6 | libdeflate | 20.27 | 48.80 | 2.41 | 291.50 |
| http/css-16kx64 | 1048576 | 6 | stdx | 16.41 | 38.00 | 2.32 | 458.29 |
| http/css-16kx64 | 1048576 | 9 | libdeflate | 40.89 | 82.40 | 2.02 | 372.51 |
| http/css-16kx64 | 1048576 | 9 | stdx | 22.94 | 65.13 | 2.84 | 480.73 |
| http/css-1m | 1048576 | 1 | libdeflate | 6.96 | 21.15 | 3.04 | 133.83 |
| http/css-1m | 1048576 | 1 | stdx | 5.77 | 14.91 | 2.58 | 107.80 |
| http/css-1m | 1048576 | 6 | libdeflate | 20.81 | 44.50 | 2.14 | 226.22 |
| http/css-1m | 1048576 | 6 | stdx | 16.54 | 35.61 | 2.15 | 440.69 |
| http/css-1m | 1048576 | 9 | libdeflate | 69.70 | 111.58 | 1.60 | 308.29 |
| http/css-1m | 1048576 | 9 | stdx | 31.98 | 83.00 | 2.60 | 512.08 |
| shuffled/dickens-1m | 1048576 | 1 | libdeflate | 25.20 | 48.89 | 1.94 | 927.58 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 18.10 | 49.19 | 2.72 | 323.13 |
| shuffled/dickens-1m | 1048576 | 6 | libdeflate | 41.68 | 86.45 | 2.07 | 1181.32 |
| shuffled/dickens-1m | 1048576 | 6 | stdx | 39.75 | 88.80 | 2.23 | 858.92 |
| shuffled/dickens-1m | 1048576 | 9 | libdeflate | 47.09 | 94.50 | 2.01 | 1343.37 |
| shuffled/dickens-1m | 1048576 | 9 | stdx | 53.86 | 134.38 | 2.50 | 1138.16 |

## Hardware counters per input octet, Zstandard encoders

A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| File | Octets | Level | Encoder | Cycles per octet | Instructions per octet | Instructions per cycle | Branch misses per KiB |
|---|---|---|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | libzstd | 10.08 | 31.22 | 3.10 | 120.50 |
| silesia/dickens | 10192446 | 1 | stdx | 24.21 | 82.03 | 3.39 | 125.11 |
| silesia/dickens | 10192446 | 3 | libzstd | 21.54 | 34.39 | 1.60 | 170.31 |
| silesia/dickens | 10192446 | 3 | stdx | 34.64 | 78.22 | 2.26 | 182.45 |
| silesia/mozilla | 51220480 | 1 | libzstd | 6.98 | 22.69 | 3.25 | 70.82 |
| silesia/mozilla | 51220480 | 1 | stdx | 17.56 | 54.73 | 3.12 | 175.38 |
| silesia/mozilla | 51220480 | 3 | libzstd | 15.96 | 27.89 | 1.75 | 102.23 |
| silesia/mozilla | 51220480 | 3 | stdx | 29.40 | 62.01 | 2.11 | 144.81 |
| silesia/mr | 9970564 | 1 | libzstd | 7.64 | 24.81 | 3.25 | 57.88 |
| silesia/mr | 9970564 | 1 | stdx | 19.79 | 66.82 | 3.38 | 113.85 |
| silesia/mr | 9970564 | 3 | libzstd | 18.81 | 32.19 | 1.71 | 86.33 |
| silesia/mr | 9970564 | 3 | stdx | 32.34 | 72.46 | 2.24 | 114.14 |
| silesia/nci | 33553445 | 1 | libzstd | 3.48 | 9.55 | 2.74 | 57.64 |
| silesia/nci | 33553445 | 1 | stdx | 7.66 | 25.69 | 3.35 | 58.86 |
| silesia/nci | 33553445 | 3 | libzstd | 5.22 | 9.95 | 1.91 | 56.30 |
| silesia/nci | 33553445 | 3 | stdx | 11.05 | 29.15 | 2.64 | 66.00 |
| silesia/ooffice | 6152192 | 1 | libzstd | 8.54 | 29.26 | 3.43 | 70.80 |
| silesia/ooffice | 6152192 | 1 | stdx | 23.04 | 72.51 | 3.15 | 179.37 |
| silesia/ooffice | 6152192 | 3 | libzstd | 22.16 | 39.44 | 1.78 | 119.83 |
| silesia/ooffice | 6152192 | 3 | stdx | 40.30 | 82.20 | 2.04 | 184.90 |
| silesia/osdb | 10085684 | 1 | libzstd | 7.05 | 22.29 | 3.16 | 66.43 |
| silesia/osdb | 10085684 | 1 | stdx | 16.27 | 50.52 | 3.10 | 119.51 |
| silesia/osdb | 10085684 | 3 | libzstd | 16.84 | 26.23 | 1.56 | 68.06 |
| silesia/osdb | 10085684 | 3 | stdx | 30.40 | 57.87 | 1.90 | 111.42 |
| silesia/reymont | 6627202 | 1 | libzstd | 9.64 | 27.13 | 2.81 | 150.31 |
| silesia/reymont | 6627202 | 1 | stdx | 20.08 | 72.05 | 3.59 | 96.24 |
| silesia/reymont | 6627202 | 3 | libzstd | 17.54 | 27.10 | 1.55 | 126.32 |
| silesia/reymont | 6627202 | 3 | stdx | 27.21 | 62.18 | 2.29 | 146.43 |
| silesia/samba | 21606400 | 1 | libzstd | 5.90 | 16.88 | 2.86 | 85.83 |
| silesia/samba | 21606400 | 1 | stdx | 13.44 | 42.89 | 3.19 | 124.63 |
| silesia/samba | 21606400 | 3 | libzstd | 11.32 | 18.81 | 1.66 | 98.81 |
| silesia/samba | 21606400 | 3 | stdx | 19.82 | 44.75 | 2.26 | 132.98 |
| silesia/sao | 7251944 | 1 | libzstd | 9.01 | 33.69 | 3.74 | 44.23 |
| silesia/sao | 7251944 | 1 | stdx | 25.88 | 82.03 | 3.17 | 103.26 |
| silesia/sao | 7251944 | 3 | libzstd | 29.08 | 50.03 | 1.72 | 94.64 |
| silesia/sao | 7251944 | 3 | stdx | 49.02 | 95.22 | 1.94 | 142.71 |
| silesia/webster | 41458703 | 1 | libzstd | 8.64 | 24.94 | 2.89 | 131.27 |
| silesia/webster | 41458703 | 1 | stdx | 20.27 | 64.04 | 3.16 | 165.86 |
| silesia/webster | 41458703 | 3 | libzstd | 18.16 | 27.33 | 1.51 | 175.76 |
| silesia/webster | 41458703 | 3 | stdx | 29.96 | 64.55 | 2.15 | 193.61 |
| silesia/x-ray | 8474240 | 1 | libzstd | 4.66 | 14.92 | 3.20 | 17.36 |
| silesia/x-ray | 8474240 | 1 | stdx | 23.70 | 76.64 | 3.23 | 91.93 |
| silesia/x-ray | 8474240 | 3 | libzstd | 29.49 | 52.73 | 1.79 | 87.53 |
| silesia/x-ray | 8474240 | 3 | stdx | 45.52 | 92.40 | 2.03 | 108.07 |
| silesia/xml | 5345280 | 1 | libzstd | 4.20 | 11.71 | 2.79 | 71.54 |
| silesia/xml | 5345280 | 1 | stdx | 10.30 | 34.21 | 3.32 | 93.75 |
| silesia/xml | 5345280 | 3 | libzstd | 6.41 | 12.61 | 1.97 | 77.34 |
| silesia/xml | 5345280 | 3 | stdx | 12.39 | 32.28 | 2.60 | 115.28 |
| canterbury/alice29.txt | 152089 | 1 | libzstd | 10.79 | 32.84 | 3.04 | 139.87 |
| canterbury/alice29.txt | 152089 | 1 | stdx | 22.35 | 76.49 | 3.42 | 187.02 |
| canterbury/alice29.txt | 152089 | 3 | libzstd | 15.36 | 39.48 | 2.57 | 202.87 |
| canterbury/alice29.txt | 152089 | 3 | stdx | 26.25 | 73.76 | 2.81 | 335.32 |
| canterbury/asyoulik.txt | 125179 | 1 | libzstd | 9.75 | 33.55 | 3.44 | 104.53 |
| canterbury/asyoulik.txt | 125179 | 1 | stdx | 23.55 | 79.00 | 3.35 | 214.55 |
| canterbury/asyoulik.txt | 125179 | 3 | libzstd | 15.20 | 39.27 | 2.58 | 208.67 |
| canterbury/asyoulik.txt | 125179 | 3 | stdx | 27.92 | 79.30 | 2.84 | 374.59 |
| canterbury/cp.html | 24603 | 1 | libzstd | 6.89 | 26.64 | 3.86 | 37.02 |
| canterbury/cp.html | 24603 | 1 | stdx | 16.00 | 57.76 | 3.61 | 115.61 |
| canterbury/cp.html | 24603 | 3 | libzstd | 9.50 | 31.85 | 3.35 | 47.23 |
| canterbury/cp.html | 24603 | 3 | stdx | 18.08 | 59.76 | 3.31 | 133.68 |
| canterbury/fields.c | 11150 | 1 | libzstd | 8.60 | 31.76 | 3.69 | 37.57 |
| canterbury/fields.c | 11150 | 1 | stdx | 17.00 | 65.73 | 3.87 | 86.33 |
| canterbury/fields.c | 11150 | 3 | libzstd | 9.51 | 34.13 | 3.59 | 40.38 |
| canterbury/fields.c | 11150 | 3 | stdx | 17.25 | 64.68 | 3.75 | 90.09 |
| canterbury/grammar.lsp | 3721 | 1 | libzstd | 9.41 | 38.01 | 4.04 | 9.00 |
| canterbury/grammar.lsp | 3721 | 1 | stdx | 20.19 | 77.57 | 3.84 | 50.52 |
| canterbury/grammar.lsp | 3721 | 3 | libzstd | 10.83 | 43.09 | 3.98 | 17.10 |
| canterbury/grammar.lsp | 3721 | 3 | stdx | 21.45 | 79.60 | 3.71 | 69.19 |
| canterbury/kennedy.xls | 1029744 | 1 | libzstd | 6.01 | 23.56 | 3.92 | 14.85 |
| canterbury/kennedy.xls | 1029744 | 1 | stdx | 14.61 | 56.75 | 3.88 | 83.37 |
| canterbury/kennedy.xls | 1029744 | 3 | libzstd | 8.18 | 23.80 | 2.91 | 27.48 |
| canterbury/kennedy.xls | 1029744 | 3 | stdx | 19.87 | 56.61 | 2.85 | 109.50 |
| canterbury/lcet10.txt | 426754 | 1 | libzstd | 9.82 | 28.52 | 2.90 | 156.49 |
| canterbury/lcet10.txt | 426754 | 1 | stdx | 21.33 | 72.02 | 3.38 | 159.62 |
| canterbury/lcet10.txt | 426754 | 3 | libzstd | 15.74 | 32.14 | 2.04 | 200.76 |
| canterbury/lcet10.txt | 426754 | 3 | stdx | 25.88 | 67.10 | 2.59 | 296.15 |
| canterbury/plrabn12.txt | 481861 | 1 | libzstd | 10.31 | 32.37 | 3.14 | 128.52 |
| canterbury/plrabn12.txt | 481861 | 1 | stdx | 24.92 | 84.16 | 3.38 | 158.69 |
| canterbury/plrabn12.txt | 481861 | 3 | libzstd | 19.73 | 38.77 | 1.96 | 227.01 |
| canterbury/plrabn12.txt | 481861 | 3 | stdx | 31.19 | 80.77 | 2.59 | 342.30 |
| canterbury/ptt5 | 513216 | 1 | libzstd | 3.16 | 8.51 | 2.70 | 66.70 |
| canterbury/ptt5 | 513216 | 1 | stdx | 7.49 | 23.15 | 3.09 | 105.65 |
| canterbury/ptt5 | 513216 | 3 | libzstd | 4.67 | 10.97 | 2.35 | 59.21 |
| canterbury/ptt5 | 513216 | 3 | stdx | 9.32 | 24.08 | 2.58 | 132.74 |
| canterbury/sum | 38240 | 1 | libzstd | 6.47 | 25.39 | 3.92 | 29.14 |
| canterbury/sum | 38240 | 1 | stdx | 16.80 | 59.13 | 3.52 | 147.65 |
| canterbury/sum | 38240 | 3 | libzstd | 9.15 | 30.67 | 3.35 | 47.39 |
| canterbury/sum | 38240 | 3 | stdx | 19.49 | 61.82 | 3.17 | 178.91 |
| canterbury/xargs.1 | 4227 | 1 | libzstd | 9.95 | 39.82 | 4.00 | 12.40 |
| canterbury/xargs.1 | 4227 | 1 | stdx | 20.90 | 80.38 | 3.85 | 59.07 |
| canterbury/xargs.1 | 4227 | 3 | libzstd | 12.31 | 48.17 | 3.91 | 20.34 |
| canterbury/xargs.1 | 4227 | 3 | stdx | 22.86 | 83.98 | 3.67 | 78.16 |
| canterbury-large/E.coli | 4638690 | 1 | libzstd | 10.32 | 33.44 | 3.24 | 76.91 |
| canterbury-large/E.coli | 4638690 | 1 | stdx | 21.79 | 95.62 | 4.39 | 7.33 |
| canterbury-large/E.coli | 4638690 | 3 | libzstd | 14.58 | 31.30 | 2.15 | 35.85 |
| canterbury-large/E.coli | 4638690 | 3 | stdx | 23.39 | 70.38 | 3.01 | 38.14 |
| canterbury-large/bible.txt | 4047392 | 1 | libzstd | 9.67 | 27.45 | 2.84 | 149.23 |
| canterbury-large/bible.txt | 4047392 | 1 | stdx | 20.31 | 71.86 | 3.54 | 107.96 |
| canterbury-large/bible.txt | 4047392 | 3 | libzstd | 17.31 | 28.20 | 1.63 | 132.53 |
| canterbury-large/bible.txt | 4047392 | 3 | stdx | 27.20 | 63.36 | 2.33 | 155.11 |
| canterbury-large/world192.txt | 2473400 | 1 | libzstd | 8.15 | 22.70 | 2.79 | 137.89 |
| canterbury-large/world192.txt | 2473400 | 1 | stdx | 18.55 | 55.86 | 3.01 | 193.12 |
| canterbury-large/world192.txt | 2473400 | 3 | libzstd | 14.77 | 23.87 | 1.62 | 173.20 |
| canterbury-large/world192.txt | 2473400 | 3 | stdx | 24.17 | 51.26 | 2.12 | 236.82 |
| http/html-1kx1024 | 1048576 | 1 | libzstd | 16.99 | 52.46 | 3.09 | 160.24 |
| http/html-1kx1024 | 1048576 | 1 | stdx | 35.76 | 100.54 | 2.81 | 641.46 |
| http/html-1kx1024 | 1048576 | 3 | libzstd | 18.96 | 59.20 | 3.12 | 197.25 |
| http/html-1kx1024 | 1048576 | 3 | stdx | 37.76 | 104.00 | 2.75 | 632.59 |
| http/html-16kx64 | 1048576 | 1 | libzstd | 7.68 | 22.46 | 2.92 | 121.88 |
| http/html-16kx64 | 1048576 | 1 | stdx | 14.12 | 46.84 | 3.32 | 182.28 |
| http/html-16kx64 | 1048576 | 3 | libzstd | 8.76 | 24.61 | 2.81 | 141.86 |
| http/html-16kx64 | 1048576 | 3 | stdx | 15.44 | 47.61 | 3.08 | 192.52 |
| http/html-1m | 1048576 | 1 | libzstd | 6.21 | 16.74 | 2.69 | 115.10 |
| http/html-1m | 1048576 | 1 | stdx | 12.91 | 42.00 | 3.25 | 133.41 |
| http/html-1m | 1048576 | 3 | libzstd | 9.04 | 18.18 | 2.01 | 125.43 |
| http/html-1m | 1048576 | 3 | stdx | 15.56 | 39.37 | 2.53 | 176.71 |
| http/json-1kx1024 | 1048576 | 1 | libzstd | 14.26 | 42.52 | 2.98 | 116.24 |
| http/json-1kx1024 | 1048576 | 1 | stdx | 29.59 | 83.13 | 2.81 | 527.45 |
| http/json-1kx1024 | 1048576 | 3 | libzstd | 14.74 | 44.54 | 3.02 | 129.11 |
| http/json-1kx1024 | 1048576 | 3 | stdx | 30.52 | 84.87 | 2.78 | 535.60 |
| http/json-16kx64 | 1048576 | 1 | libzstd | 4.79 | 14.98 | 3.13 | 57.73 |
| http/json-16kx64 | 1048576 | 1 | stdx | 9.69 | 33.78 | 3.48 | 116.39 |
| http/json-16kx64 | 1048576 | 3 | libzstd | 5.34 | 16.21 | 3.03 | 72.58 |
| http/json-16kx64 | 1048576 | 3 | stdx | 10.44 | 34.58 | 3.31 | 122.49 |
| http/json-1m | 1048576 | 1 | libzstd | 4.04 | 12.55 | 3.11 | 53.21 |
| http/json-1m | 1048576 | 1 | stdx | 8.96 | 30.70 | 3.43 | 84.78 |
| http/json-1m | 1048576 | 3 | libzstd | 5.99 | 13.78 | 2.30 | 68.58 |
| http/json-1m | 1048576 | 3 | stdx | 11.15 | 30.64 | 2.75 | 119.45 |
| http/js-1kx1024 | 1048576 | 1 | libzstd | 18.47 | 57.26 | 3.10 | 183.95 |
| http/js-1kx1024 | 1048576 | 1 | stdx | 39.91 | 113.49 | 2.84 | 695.71 |
| http/js-1kx1024 | 1048576 | 3 | libzstd | 21.31 | 65.54 | 3.08 | 260.45 |
| http/js-1kx1024 | 1048576 | 3 | stdx | 41.86 | 116.54 | 2.78 | 679.58 |
| http/js-16kx64 | 1048576 | 1 | libzstd | 8.81 | 26.52 | 3.01 | 126.98 |
| http/js-16kx64 | 1048576 | 1 | stdx | 16.56 | 55.71 | 3.36 | 199.93 |
| http/js-16kx64 | 1048576 | 3 | libzstd | 10.04 | 28.74 | 2.86 | 152.83 |
| http/js-16kx64 | 1048576 | 3 | stdx | 17.54 | 55.35 | 3.16 | 210.41 |
| http/js-1m | 1048576 | 1 | libzstd | 6.50 | 17.87 | 2.75 | 113.86 |
| http/js-1m | 1048576 | 1 | stdx | 13.91 | 45.88 | 3.30 | 135.37 |
| http/js-1m | 1048576 | 3 | libzstd | 9.62 | 19.14 | 1.99 | 124.41 |
| http/js-1m | 1048576 | 3 | stdx | 16.65 | 41.25 | 2.48 | 186.50 |
| http/css-1kx1024 | 1048576 | 1 | libzstd | 15.46 | 46.90 | 3.03 | 135.76 |
| http/css-1kx1024 | 1048576 | 1 | stdx | 32.27 | 91.65 | 2.84 | 576.72 |
| http/css-1kx1024 | 1048576 | 3 | libzstd | 16.56 | 50.53 | 3.05 | 160.50 |
| http/css-1kx1024 | 1048576 | 3 | stdx | 33.36 | 93.63 | 2.81 | 578.38 |
| http/css-16kx64 | 1048576 | 1 | libzstd | 6.10 | 18.99 | 3.11 | 78.67 |
| http/css-16kx64 | 1048576 | 1 | stdx | 12.40 | 43.79 | 3.53 | 137.09 |
| http/css-16kx64 | 1048576 | 3 | libzstd | 6.56 | 19.41 | 2.96 | 95.72 |
| http/css-16kx64 | 1048576 | 3 | stdx | 12.88 | 42.34 | 3.29 | 152.30 |
| http/css-1m | 1048576 | 1 | libzstd | 1.49 | 4.59 | 3.07 | 21.78 |
| http/css-1m | 1048576 | 1 | stdx | 3.96 | 14.85 | 3.75 | 30.49 |
| http/css-1m | 1048576 | 3 | libzstd | 1.92 | 5.25 | 2.73 | 19.53 |
| http/css-1m | 1048576 | 3 | stdx | 3.90 | 13.33 | 3.42 | 31.52 |
| shuffled/dickens-1m | 1048576 | 1 | libzstd | 3.52 | 12.79 | 3.64 | 6.21 |
| shuffled/dickens-1m | 1048576 | 1 | stdx | 9.01 | 30.66 | 3.40 | 61.85 |
| shuffled/dickens-1m | 1048576 | 3 | libzstd | 25.95 | 50.53 | 1.95 | 49.33 |
| shuffled/dickens-1m | 1048576 | 3 | stdx | 20.43 | 47.43 | 2.32 | 207.14 |

## Hardware counters per JSON token, decoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 25.4 | 74.2 | 0.121 | 3.00 | 2.92 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 66.7 | 219.6 | 0.086 | 7.88 | 3.29 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 30.7 | 96.1 | 0.163 | 3.62 | 3.13 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 249.3 | 1024.0 | 0.838 | 29.45 | 4.11 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 31.1 | 107.7 | 0.137 | 3.67 | 3.47 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.9 | 106.2 | 0.292 | 3.30 | 3.80 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 95.5 | 378.2 | 0.362 | 11.28 | 3.96 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 43.0 | 161.9 | 0.471 | 5.08 | 3.76 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 91.7 | 451.7 | 0.302 | 10.83 | 4.93 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 26.9 | 89.5 | 0.004 | 3.96 | 3.32 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 68.4 | 234.7 | 0.040 | 10.07 | 3.43 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 29.2 | 99.4 | 0.013 | 4.29 | 3.41 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 213.9 | 819.1 | 0.941 | 31.48 | 3.83 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 28.3 | 107.7 | 0.040 | 4.16 | 3.81 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 27.9 | 106.0 | 0.047 | 4.11 | 3.79 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 94.4 | 346.2 | 0.317 | 13.90 | 3.67 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 32.4 | 144.5 | 0.053 | 4.76 | 4.47 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 90.0 | 406.5 | 0.087 | 13.24 | 4.52 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 115048.6 | 403846.2 | 518.010 | 0.67 | 3.51 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 590833.9 | 2503286.2 | 1389.608 | 3.42 | 4.24 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 114192.1 | 404249.2 | 485.093 | 0.66 | 3.54 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3575010.6 | 18223876.2 | 2977.845 | 20.72 | 5.10 |
| string: silesia/dickens | 1 | 172528 | simdjson | 312201.1 | 621744.2 | 646.052 | 1.81 | 1.99 |
| string: silesia/dickens | 1 | 172528 | yyjson | 224582.7 | 826630.2 | 2157.938 | 1.30 | 3.68 |
| string: silesia/dickens | 1 | 172528 | std.json | 1575769.2 | 4578768.2 | 42409.103 | 9.13 | 2.91 |
| string: silesia/dickens | 1 | 172528 | serde_json | 201956.8 | 802391.2 | 996.000 | 1.17 | 3.97 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 1046219.5 | 5282308.0 | 4960.464 | 6.06 | 5.05 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1560937.3 | 4799763.6 | 1271.929 | 1.31 | 3.07 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 14432399.0 | 56816152.6 | 39249.429 | 12.13 | 3.94 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1558731.2 | 4799955.6 | 1106.000 | 1.31 | 3.08 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 28827403.3 | 132108253.6 | 159622.643 | 24.22 | 4.58 |
| string: http/json-1m | 1 | 1190272 | simdjson | 4589920.4 | 7062781.6 | 555.857 | 3.86 | 1.54 |
| string: http/json-1m | 1 | 1190272 | yyjson | 1791324.8 | 7322029.6 | 13743.286 | 1.50 | 4.09 |
| string: http/json-1m | 1 | 1190272 | std.json | 10307086.4 | 47381213.6 | 29805.286 | 8.66 | 4.60 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3808485.2 | 15226459.6 | 6259.071 | 3.20 | 4.00 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 8949687.3 | 47988397.9 | 27781.000 | 7.52 | 5.36 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2068864.5 | 5765413.8 | 4528.250 | 1.10 | 2.79 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 6169392.6 | 22589263.8 | 6941.500 | 3.28 | 3.66 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2057645.1 | 5765605.8 | 3984.750 | 1.09 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 47282540.1 | 227842320.8 | 277061.500 | 25.11 | 4.82 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 3773123.5 | 8446023.8 | 2171.000 | 2.00 | 2.24 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 7113388.9 | 12276717.8 | 275925.625 | 3.78 | 1.73 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 17433522.0 | 63617055.8 | 264379.125 | 9.26 | 3.65 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 9507340.6 | 24440755.8 | 327906.625 | 5.05 | 2.57 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 39219400.9 | 160310992.6 | 798267.250 | 20.83 | 4.09 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim on | 12910665.7 | 42561069.3 | 244309.333 | 2.54 | 3.30 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, one token a call | 174046587.7 | 667246747.3 | 393041.000 | 34.29 | 3.83 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, TextWriter's methods or TextReader.next | 12937000.0 | 42561261.3 | 246141.333 | 2.55 | 3.29 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | stdx, every claim off | 152066019.3 | 639992662.3 | 424530.667 | 29.96 | 4.21 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | simdjson | 17486932.3 | 49745820.3 | 249062.333 | 3.45 | 2.84 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | yyjson | 14161866.7 | 45615166.3 | 442680.333 | 2.79 | 3.22 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | std.json | 79943394.7 | 314900845.3 | 459420.000 | 15.75 | 3.94 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | serde_json | 36666347.7 | 131556135.3 | 602519.667 | 7.22 | 3.59 |
| string: dickens as Cyrillic and CJK, as \u escapes | 1 | 5075485 | Go jsontext | 66211127.0 | 273932924.7 | 835613.667 | 13.05 | 4.14 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 92778.5 | 303836.7 | 4.871 | 0.18 | 3.27 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 187317.4 | 623465.7 | 8.839 | 0.36 | 3.33 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 148538.5 | 557622.7 | 4.774 | 0.28 | 3.75 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 10294929.4 | 53478202.7 | 6.871 | 19.64 | 5.19 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 489162.5 | 1376733.7 | 5.355 | 0.93 | 2.81 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 537503.0 | 2195917.7 | 8.161 | 1.03 | 4.09 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3467944.3 | 12808414.7 | 60694.129 | 6.61 | 3.69 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 298267.5 | 1179969.7 | 6.968 | 0.57 | 3.96 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2245828.5 | 12789308.2 | 255.355 | 4.28 | 5.69 |

## Hardware counters per JSON token, encoding

A token is one of stdx's decoder's, and a baseline's counts are per stdx token of the same texts. Octets are those of stdx's texts. Each operation is bench-json's, counted over 16 MiB at least.

| Workload | Tokens | Octets | Operation | Cycles per token | Instructions per token | Branch misses per token | Cycles per octet | Instructions per cycle |
|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim on | 19.5 | 81.8 | 0.108 | 2.30 | 4.20 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, one token a call | 35.0 | 153.6 | 0.127 | 4.14 | 4.38 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, TextWriter's methods or TextReader.next | 22.7 | 100.4 | 0.100 | 2.68 | 4.43 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, every claim off | 217.6 | 981.0 | 0.926 | 25.71 | 4.51 |
| CLDR supplemental, 34 texts | 108761 | 920675 | stdx, J11's loop unchecked | 18.7 | 79.5 | 0.107 | 2.20 | 4.26 |
| CLDR supplemental, 34 texts | 108761 | 920675 | simdjson | 23.0 | 94.1 | 0.136 | 2.72 | 4.09 |
| CLDR supplemental, 34 texts | 108761 | 920675 | yyjson | 27.3 | 105.6 | 0.246 | 3.22 | 3.87 |
| CLDR supplemental, 34 texts | 108761 | 920675 | std.json | 69.4 | 310.8 | 0.381 | 8.20 | 4.48 |
| CLDR supplemental, 34 texts | 108761 | 920675 | serde_json | 63.5 | 255.3 | 0.508 | 7.50 | 4.02 |
| CLDR supplemental, 34 texts | 108761 | 920675 | Go jsontext | 68.3 | 315.1 | 0.233 | 8.07 | 4.61 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim on | 19.0 | 82.8 | 0.024 | 2.79 | 4.37 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, one token a call | 36.0 | 153.9 | 0.025 | 5.29 | 4.28 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, TextWriter's methods or TextReader.next | 21.8 | 99.5 | 0.024 | 3.21 | 4.57 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, every claim off | 170.1 | 718.3 | 1.295 | 25.04 | 4.22 |
| qlog records, JSON text sequence | 216000 | 1467503 | stdx, J11's loop unchecked | 17.9 | 81.5 | 0.024 | 2.64 | 4.54 |
| qlog records, JSON text sequence | 216000 | 1467503 | simdjson | 21.8 | 96.8 | 0.032 | 3.21 | 4.44 |
| qlog records, JSON text sequence | 216000 | 1467503 | yyjson | 28.8 | 117.9 | 0.033 | 4.24 | 4.09 |
| qlog records, JSON text sequence | 216000 | 1467503 | std.json | 61.5 | 271.2 | 0.277 | 9.06 | 4.41 |
| qlog records, JSON text sequence | 216000 | 1467503 | serde_json | 49.4 | 211.7 | 0.041 | 7.28 | 4.28 |
| qlog records, JSON text sequence | 216000 | 1467503 | Go jsontext | 82.1 | 331.7 | 0.090 | 12.08 | 4.04 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim on | 84636.3 | 280786.2 | 711.485 | 0.49 | 3.32 |
| string: silesia/dickens | 1 | 172528 | stdx, one token a call | 84440.3 | 280732.2 | 705.227 | 0.49 | 3.32 |
| string: silesia/dickens | 1 | 172528 | stdx, TextWriter's methods or TextReader.next | 84296.2 | 280736.2 | 701.711 | 0.49 | 3.33 |
| string: silesia/dickens | 1 | 172528 | stdx, every claim off | 3397897.1 | 16047574.2 | 2946.258 | 19.69 | 4.72 |
| string: silesia/dickens | 1 | 172528 | stdx, J11's loop unchecked | 84053.1 | 274401.2 | 696.216 | 0.49 | 3.26 |
| string: silesia/dickens | 1 | 172528 | simdjson | 208033.7 | 674016.2 | 2080.784 | 1.21 | 3.24 |
| string: silesia/dickens | 1 | 172528 | yyjson | 205410.2 | 825518.2 | 1071.309 | 1.19 | 4.02 |
| string: silesia/dickens | 1 | 172528 | std.json | 1367596.4 | 2890892.2 | 54725.773 | 7.93 | 2.11 |
| string: silesia/dickens | 1 | 172528 | serde_json | 365975.1 | 1586249.2 | 2243.351 | 2.12 | 4.33 |
| string: silesia/dickens | 1 | 172528 | Go jsontext | 577209.0 | 2970292.1 | 2332.979 | 3.35 | 5.15 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim on | 1253270.0 | 3582350.6 | 10812.500 | 1.05 | 2.86 |
| string: http/json-1m | 1 | 1190272 | stdx, one token a call | 1239711.4 | 3582290.6 | 10301.500 | 1.04 | 2.89 |
| string: http/json-1m | 1 | 1190272 | stdx, TextWriter's methods or TextReader.next | 1238421.6 | 3582287.6 | 10280.786 | 1.04 | 2.89 |
| string: http/json-1m | 1 | 1190272 | stdx, every claim off | 25173654.1 | 109856348.6 | 141621.857 | 21.15 | 4.36 |
| string: http/json-1m | 1 | 1190272 | stdx, J11's loop unchecked | 1223365.6 | 3370022.6 | 11019.429 | 1.03 | 2.75 |
| string: http/json-1m | 1 | 1190272 | simdjson | 2965860.5 | 10460762.6 | 29234.071 | 2.49 | 3.53 |
| string: http/json-1m | 1 | 1190272 | yyjson | 2586451.9 | 10197931.6 | 9642.000 | 2.17 | 3.94 |
| string: http/json-1m | 1 | 1190272 | std.json | 8914599.0 | 43287986.6 | 16559.286 | 7.49 | 4.86 |
| string: http/json-1m | 1 | 1190272 | serde_json | 3781583.1 | 17941088.6 | 10990.071 | 3.18 | 4.74 |
| string: http/json-1m | 1 | 1190272 | Go jsontext | 5224863.7 | 26999739.4 | 11074.929 | 4.39 | 5.17 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim on | 2069342.0 | 6088099.8 | 4667.625 | 1.10 | 2.94 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, one token a call | 2063155.5 | 6088039.8 | 4248.375 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, TextWriter's methods or TextReader.next | 2063877.1 | 6088036.8 | 4165.875 | 1.10 | 2.95 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, every claim off | 43799537.9 | 193466548.8 | 265554.375 | 23.26 | 4.42 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | stdx, J11's loop unchecked | 2072885.3 | 5875346.8 | 4852.250 | 1.10 | 2.83 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | simdjson | 2714422.8 | 7144143.8 | 21005.000 | 1.44 | 2.63 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | yyjson | 12488983.5 | 23590602.8 | 463781.000 | 6.63 | 1.89 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | std.json | 20291293.4 | 56837736.8 | 545292.875 | 10.78 | 2.80 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | serde_json | 11534728.4 | 33662338.8 | 329579.000 | 6.13 | 2.92 |
| string: dickens as Cyrillic and CJK | 1 | 1883069 | Go jsontext | 18836807.5 | 76319472.4 | 252711.750 | 10.00 | 4.05 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim on | 112784.3 | 426376.7 | 3.613 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, one token a call | 112739.5 | 426318.7 | 4.258 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, TextWriter's methods or TextReader.next | 112783.3 | 426306.7 | 2.581 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | stdx, every claim off | 637917.5 | 3146479.7 | 7.226 | 1.22 | 4.93 |
| hex: silesia/dickens | 1 | 524290 | stdx, J11's loop unchecked | 112832.8 | 426343.7 | 6.226 | 0.22 | 3.78 |
| hex: silesia/dickens | 1 | 524290 | simdjson | 1198447.2 | 3866916.7 | 4.613 | 2.29 | 3.23 |
| hex: silesia/dickens | 1 | 524290 | yyjson | 1620028.1 | 5833341.7 | 5.419 | 3.09 | 3.60 |
| hex: silesia/dickens | 1 | 524290 | std.json | 3525221.4 | 13108830.7 | 71962.774 | 6.72 | 3.72 |
| hex: silesia/dickens | 1 | 524290 | serde_json | 1778306.6 | 7405810.7 | 3.613 | 3.39 | 4.16 |
| hex: silesia/dickens | 1 | 524290 | Go jsontext | 2386113.4 | 12748296.1 | 16.871 | 4.55 | 5.34 |
