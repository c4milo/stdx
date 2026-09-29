# bench-profile

| Field | Value |
|---|---|
| Commit | 4c0d5c6 |
| Runner label | ubuntu-24.04 |
| Image version | 20260920.314.1 |
| CPU model | INTEL(R) XEON(R) PLATINUM 8573C |
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

## Hardware counters per decoded octet

Hardware counters are unavailable on this host: perf_event_open refused them.

## Hardware counters per JSON token

Hardware counters are unavailable: perf_event_open refused them.
