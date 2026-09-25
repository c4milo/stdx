# bench-deflate

| Field | Value |
|---|---|
| Commit | 1275b1c |
| Runner label | ubuntu-24.04-arm |
| Image version | 20260920.129.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 6.17.0-1022-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/36184402242 |
| Date | 2026-09-25 |

## Decoding, gzip at zlib level 6

| File | Octets | zlib, MB/s | Wuffs, MB/s | Wuffs / zlib |
|---|---|---|---|---|
| silesia/dickens | 10192446 | 427 ± 0.2% | 692 ± 0.3% | 1.62 |
| silesia/mozilla | 51220480 | 437 ± 0.2% | 591 ± 0.1% | 1.35 |
| silesia/mr | 9970564 | 442 ± 0.2% | 639 ± 0.2% | 1.45 |
| silesia/nci | 33553445 | 1160 ± 0.7% | 1946 ± 0.9% | 1.68 |
| silesia/ooffice | 6152192 | 308 ± 0.2% | 416 ± 0.1% | 1.35 |
| silesia/osdb | 10085684 | 497 ± 0.6% | 649 ± 0.7% | 1.31 |
| silesia/reymont | 6627202 | 514 ± 0.2% | 797 ± 0.3% | 1.55 |
| silesia/samba | 21606400 | 620 ± 0.1% | 918 ± 0.1% | 1.48 |
| silesia/sao | 7251944 | 342 ± 0.2% | 415 ± 0.1% | 1.21 |
| silesia/webster | 41458703 | 485 ± 0.2% | 747 ± 0.4% | 1.54 |
| silesia/x-ray | 8474240 | 276 ± 0.3% | 332 ± 0.2% | 1.20 |
| silesia/xml | 5345280 | 939 ± 0.4% | 1535 ± 0.3% | 1.63 |
| canterbury/alice29.txt | 152089 | 448 ± 0.5% | 726 ± 0.2% | 1.62 |
| canterbury/asyoulik.txt | 125179 | 418 ± 0.3% | 671 ± 0.2% | 1.61 |
| canterbury/cp.html | 24603 | 516 ± 2.4% | 755 ± 2.2% | 1.46 |
| canterbury/fields.c | 11150 | 719 ± 1.2% | 870 ± 0.8% | 1.21 |
| canterbury/grammar.lsp | 3721 | 489 ± 0.4% | 546 ± 0.4% | 1.12 |
| canterbury/kennedy.xls | 1029744 | 860 ± 0.2% | 1053 ± 0.4% | 1.23 |
| canterbury/lcet10.txt | 426754 | 460 ± 0.2% | 743 ± 0.4% | 1.61 |
| canterbury/plrabn12.txt | 481861 | 409 ± 0.2% | 657 ± 0.1% | 1.61 |
| canterbury/ptt5 | 513216 | 770 ± 0.2% | 1549 ± 0.3% | 2.01 |
| canterbury/sum | 38240 | 465 ± 0.7% | 677 ± 0.2% | 1.46 |
| canterbury/xargs.1 | 4227 | 468 ± 1.4% | 506 ± 0.2% | 1.08 |
| canterbury-large/E.coli | 4638690 | 568 ± 0.1% | 849 ± 0.2% | 1.49 |
| canterbury-large/bible.txt | 4047392 | 505 ± 0.4% | 813 ± 0.6% | 1.61 |
| canterbury-large/world192.txt | 2473400 | 490 ± 0.1% | 749 ± 0.6% | 1.53 |
| http/html-1k | 1024 | 215 ± 0.2% | 237 ± 0.4% | 1.10 |
| http/html-16k | 16384 | 707 ± 2.5% | 914 ± 1.5% | 1.29 |
| http/html-1m | 1048576 | 732 ± 0.1% | 1138 ± 0.2% | 1.56 |
| http/json-1k | 1024 | 318 ± 0.1% | 376 ± 0.6% | 1.18 |
| http/json-16k | 16384 | 1417 ± 0.5% | 2147 ± 0.3% | 1.52 |
| http/json-1m | 1048576 | 1045 ± 0.2% | 1647 ± 0.5% | 1.58 |
| http/js-1k | 1024 | 238 ± 0.2% | 260 ± 0.3% | 1.10 |
| http/js-16k | 16384 | 949 ± 2.2% | 1197 ± 0.7% | 1.26 |
| http/js-1m | 1048576 | 659 ± 0.2% | 1036 ± 0.4% | 1.57 |
| http/css-1k | 1024 | 231 ± 0.2% | 252 ± 0.3% | 1.09 |
| http/css-16k | 16384 | 726 ± 2.2% | 935 ± 1.6% | 1.29 |
| http/css-1m | 1048576 | 1007 ± 0.2% | 1776 ± 0.6% | 1.76 |

## Encoding, gzip

| File | Octets | Level | zlib, MB/s | Ratio |
|---|---|---|---|---|
| silesia/dickens | 10192446 | 1 | 109.6 ± 0.1% | 2.223 |
| silesia/dickens | 10192446 | 6 | 22.1 ± 0.1% | 2.633 |
| silesia/dickens | 10192446 | 9 | 16.4 ± 0.4% | 2.644 |
| silesia/mozilla | 51220480 | 1 | 110.5 ± 0.1% | 2.489 |
| silesia/mozilla | 51220480 | 6 | 32.8 ± 0.1% | 2.683 |
| silesia/mozilla | 51220480 | 9 | 8.8 ± 0.0% | 2.690 |
| silesia/mr | 9970564 | 1 | 133.6 ± 0.2% | 2.604 |
| silesia/mr | 9970564 | 6 | 25.6 ± 0.2% | 2.712 |
| silesia/mr | 9970564 | 9 | 9.0 ± 0.1% | 2.724 |
| silesia/nci | 33553445 | 1 | 348.7 ± 0.1% | 7.255 |
| silesia/nci | 33553445 | 6 | 99.5 ± 0.1% | 10.485 |
| silesia/nci | 33553445 | 9 | 19.3 ± 0.1% | 11.229 |
| silesia/ooffice | 6152192 | 1 | 79.7 ± 0.1% | 1.870 |
| silesia/ooffice | 6152192 | 6 | 26.1 ± 0.3% | 1.986 |
| silesia/ooffice | 6152192 | 9 | 15.7 ± 0.2% | 1.989 |
| silesia/osdb | 10085684 | 1 | 117.9 ± 0.1% | 2.474 |
| silesia/osdb | 10085684 | 6 | 47.3 ± 0.3% | 2.729 |
| silesia/osdb | 10085684 | 9 | 34.3 ± 0.2% | 2.746 |
| silesia/reymont | 6627202 | 1 | 129.2 ± 0.2% | 2.789 |
| silesia/reymont | 6627202 | 6 | 23.0 ± 0.2% | 3.561 |
| silesia/reymont | 6627202 | 9 | 7.8 ± 0.1% | 3.635 |
| silesia/samba | 21606400 | 1 | 166.0 ± 0.2% | 3.414 |
| silesia/samba | 21606400 | 6 | 54.0 ± 0.2% | 3.963 |
| silesia/samba | 21606400 | 9 | 27.6 ± 0.1% | 3.999 |
| silesia/sao | 7251944 | 1 | 59.5 ± 0.1% | 1.302 |
| silesia/sao | 7251944 | 6 | 22.7 ± 0.3% | 1.360 |
| silesia/sao | 7251944 | 9 | 18.6 ± 0.3% | 1.362 |
| silesia/webster | 41458703 | 1 | 135.1 ± 0.1% | 2.766 |
| silesia/webster | 41458703 | 6 | 36.7 ± 0.0% | 3.394 |
| silesia/webster | 41458703 | 9 | 23.1 ± 0.0% | 3.434 |
| silesia/x-ray | 8474240 | 1 | 71.4 ± 0.1% | 1.404 |
| silesia/x-ray | 8474240 | 6 | 33.7 ± 0.1% | 1.402 |
| silesia/x-ray | 8474240 | 9 | 33.6 ± 0.1% | 1.402 |
| silesia/xml | 5345280 | 1 | 265.0 ± 0.6% | 5.538 |
| silesia/xml | 5345280 | 6 | 74.3 ± 0.1% | 7.769 |
| silesia/xml | 5345280 | 9 | 39.3 ± 0.2% | 8.112 |
| canterbury/alice29.txt | 152089 | 1 | 110.7 ± 0.4% | 2.335 |
| canterbury/alice29.txt | 152089 | 6 | 26.0 ± 0.2% | 2.795 |
| canterbury/alice29.txt | 152089 | 9 | 18.1 ± 0.4% | 2.807 |
| canterbury/asyoulik.txt | 125179 | 1 | 106.9 ± 0.4% | 2.204 |
| canterbury/asyoulik.txt | 125179 | 6 | 23.5 ± 0.3% | 2.559 |
| canterbury/asyoulik.txt | 125179 | 9 | 19.5 ± 0.2% | 2.566 |
| canterbury/cp.html | 24603 | 1 | 117.4 ± 2.0% | 2.720 |
| canterbury/cp.html | 24603 | 6 | 56.3 ± 1.7% | 3.086 |
| canterbury/cp.html | 24603 | 9 | 49.6 ± 0.3% | 3.094 |
| canterbury/fields.c | 11150 | 1 | 120.2 ± 3.7% | 3.042 |
| canterbury/fields.c | 11150 | 6 | 54.6 ± 3.2% | 3.558 |
| canterbury/fields.c | 11150 | 9 | 45.9 ± 1.2% | 3.566 |
| canterbury/grammar.lsp | 3721 | 1 | 71.7 ± 0.9% | 2.769 |
| canterbury/grammar.lsp | 3721 | 6 | 53.3 ± 4.2% | 3.015 |
| canterbury/grammar.lsp | 3721 | 9 | 52.2 ± 2.0% | 3.015 |
| canterbury/kennedy.xls | 1029744 | 1 | 223.9 ± 0.8% | 4.250 |
| canterbury/kennedy.xls | 1029744 | 6 | 41.1 ± 0.3% | 5.048 |
| canterbury/kennedy.xls | 1029744 | 9 | 2.9 ± 0.1% | 4.974 |
| canterbury/lcet10.txt | 426754 | 1 | 118.7 ± 0.3% | 2.451 |
| canterbury/lcet10.txt | 426754 | 6 | 27.2 ± 0.2% | 2.945 |
| canterbury/lcet10.txt | 426754 | 9 | 21.2 ± 0.1% | 2.954 |
| canterbury/plrabn12.txt | 481861 | 1 | 103.1 ± 0.3% | 2.105 |
| canterbury/plrabn12.txt | 481861 | 6 | 20.0 ± 0.5% | 2.468 |
| canterbury/plrabn12.txt | 481861 | 9 | 12.7 ± 0.2% | 2.479 |
| canterbury/ptt5 | 513216 | 1 | 287.4 ± 0.4% | 7.827 |
| canterbury/ptt5 | 513216 | 6 | 69.0 ± 0.4% | 9.087 |
| canterbury/ptt5 | 513216 | 9 | 8.7 ± 0.1% | 9.826 |
| canterbury/sum | 38240 | 1 | 103.1 ± 0.9% | 2.706 |
| canterbury/sum | 38240 | 6 | 28.6 ± 0.7% | 2.941 |
| canterbury/sum | 38240 | 9 | 4.6 ± 0.2% | 2.976 |
| canterbury/xargs.1 | 4227 | 1 | 72.5 ± 2.7% | 2.268 |
| canterbury/xargs.1 | 4227 | 6 | 54.7 ± 3.7% | 2.418 |
| canterbury/xargs.1 | 4227 | 9 | 55.1 ± 2.2% | 2.418 |
| canterbury-large/E.coli | 4638690 | 1 | 112.2 ± 0.1% | 3.037 |
| canterbury-large/E.coli | 4638690 | 6 | 7.1 ± 0.4% | 3.457 |
| canterbury-large/E.coli | 4638690 | 9 | 1.6 ± 0.2% | 3.569 |
| canterbury-large/bible.txt | 4047392 | 1 | 130.7 ± 0.4% | 2.714 |
| canterbury-large/bible.txt | 4047392 | 6 | 26.0 ± 0.3% | 3.396 |
| canterbury-large/bible.txt | 4047392 | 9 | 12.7 ± 0.4% | 3.438 |
| canterbury-large/world192.txt | 2473400 | 1 | 130.0 ± 0.7% | 2.693 |
| canterbury-large/world192.txt | 2473400 | 6 | 40.2 ± 0.2% | 3.412 |
| canterbury-large/world192.txt | 2473400 | 9 | 25.2 ± 0.3% | 3.426 |
| http/html-1k | 1024 | 1 | 25.4 ± 1.3% | 1.996 |
| http/html-1k | 1024 | 6 | 24.4 ± 0.3% | 2.024 |
| http/html-1k | 1024 | 9 | 24.0 ± 0.9% | 2.024 |
| http/html-16k | 16384 | 1 | 141.7 ± 4.1% | 3.427 |
| http/html-16k | 16384 | 6 | 70.8 ± 3.3% | 3.826 |
| http/html-16k | 16384 | 9 | 59.6 ± 1.2% | 3.839 |
| http/html-1m | 1048576 | 1 | 224.4 ± 0.3% | 4.662 |
| http/html-1m | 1048576 | 6 | 60.1 ± 0.7% | 5.927 |
| http/html-1m | 1048576 | 9 | 39.5 ± 0.2% | 5.973 |
| http/json-1k | 1024 | 1 | 29.1 ± 2.1% | 4.031 |
| http/json-1k | 1024 | 6 | 27.4 ± 2.1% | 4.531 |
| http/json-1k | 1024 | 9 | 26.9 ± 1.4% | 4.592 |
| http/json-16k | 16384 | 1 | 300.7 ± 1.3% | 10.357 |
| http/json-16k | 16384 | 6 | 149.2 ± 2.7% | 11.959 |
| http/json-16k | 16384 | 9 | 74.3 ± 2.5% | 13.224 |
| http/json-1m | 1048576 | 1 | 342.9 ± 0.3% | 6.718 |
| http/json-1m | 1048576 | 6 | 93.5 ± 0.4% | 8.004 |
| http/json-1m | 1048576 | 9 | 17.6 ± 0.1% | 8.386 |
| http/js-1k | 1024 | 1 | 26.6 ± 1.3% | 2.312 |
| http/js-1k | 1024 | 6 | 24.6 ± 0.9% | 2.322 |
| http/js-1k | 1024 | 9 | 25.0 ± 0.9% | 2.333 |
| http/js-16k | 16384 | 1 | 175.2 ± 4.4% | 4.453 |
| http/js-16k | 16384 | 6 | 83.1 ± 3.5% | 5.082 |
| http/js-16k | 16384 | 9 | 68.0 ± 1.8% | 5.098 |
| http/js-1m | 1048576 | 1 | 188.8 ± 0.5% | 3.983 |
| http/js-1m | 1048576 | 6 | 49.7 ± 0.9% | 5.160 |
| http/js-1m | 1048576 | 9 | 28.6 ± 0.2% | 5.194 |
| http/css-1k | 1024 | 1 | 25.9 ± 1.2% | 2.048 |
| http/css-1k | 1024 | 6 | 24.3 ± 1.5% | 2.124 |
| http/css-1k | 1024 | 9 | 24.0 ± 1.9% | 2.124 |
| http/css-16k | 16384 | 1 | 144.9 ± 3.2% | 3.390 |
| http/css-16k | 16384 | 6 | 66.3 ± 2.9% | 3.971 |
| http/css-16k | 16384 | 9 | 49.6 ± 0.9% | 3.993 |
| http/css-1m | 1048576 | 1 | 306.9 ± 0.6% | 6.123 |
| http/css-1m | 1048576 | 6 | 82.2 ± 0.4% | 8.683 |
| http/css-1m | 1048576 | 9 | 31.5 ± 0.1% | 8.890 |
