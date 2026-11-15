# bench-json

| Field | Value |
|---|---|
| Commit | d843c6f |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.127.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1014-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43654501495 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1375.4 ± 0.2% | 0.491 | 1.023 | 1.069 | 1.068 | 0.411 | 1.072 | 1.069 | 0.371 | 0.834 | 0.931 | 0.107 |
| qlog records, JSON text sequence | 1467503 | 1095.5 ± 0.4% | 0.795 | 1.063 | 1.070 | 1.067 | 0.394 | 1.071 | 1.068 | 0.363 | 0.929 | 1.047 | 0.125 |
| messages: 11 string members | 1025025 | 1075.2 ± 0.7% | 0.576 | 1.000 | 1.018 | 1.019 | 0.544 | 1.018 | 1.025 | 0.533 | 0.890 | 0.949 | 0.135 |
| messages: 50 nested objects | 1121600 | 1328.4 ± 0.9% | 0.806 | 1.091 | 1.090 | 1.090 | 0.397 | 1.096 | 1.090 | 0.352 | 0.926 | 0.967 | 0.114 |
| string: silesia/dickens | 172528 | 6651.2 ± 0.6% | 0.029 | 0.701 | 1.098 | 1.101 | 0.210 | 1.027 | 1.114 | 0.210 | 1.002 | 1.002 | 0.029 |
| string: silesia/nci | 1075110 | 5345.6 ± 1.0% | 0.036 | 0.713 | 1.036 | 1.039 | 0.304 | 1.044 | 1.038 | 0.306 | 1.014 | 1.011 | 0.036 |
| string: silesia/reymont | 1075159 | 3513.1 ± 2.0% | 0.055 | 0.626 | 0.863 | 0.863 | 0.355 | 0.816 | 0.872 | 0.354 | 0.984 | 1.001 | 0.055 |
| string: silesia/samba | 97582 | 3960.4 ± 1.3% | 0.041 | 0.909 | 1.063 | 1.063 | 0.075 | 0.858 | 1.064 | 0.075 | 1.003 | 1.006 | 0.041 |
| string: silesia/webster | 1098490 | 4360.5 ± 0.3% | 0.043 | 0.651 | 0.989 | 0.990 | 0.229 | 0.933 | 0.997 | 0.228 | 1.011 | 1.018 | 0.043 |
| string: silesia/xml | 1090118 | 6007.4 ± 0.7% | 0.032 | 0.778 | 0.970 | 0.974 | 0.253 | 0.960 | 0.973 | 0.254 | 1.006 | 1.010 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5734.8 ± 1.2% | 0.033 | 0.760 | 1.077 | 1.127 | 0.185 | 1.013 | 1.163 | 0.186 | 0.994 | 1.011 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 4272.4 ± 1.0% | 0.042 | 0.806 | 1.130 | 1.121 | 0.201 | 1.036 | 1.128 | 0.202 | 0.994 | 1.005 | 0.043 |
| string: canterbury/lcet10.txt | 441884 | 6643.3 ± 1.0% | 0.029 | 0.604 | 1.104 | 1.110 | 0.200 | 1.043 | 1.119 | 0.200 | 1.006 | 1.007 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 5467.4 ± 1.3% | 0.035 | 0.776 | 0.968 | 0.974 | 0.228 | 0.861 | 0.975 | 0.228 | 0.999 | 1.004 | 0.035 |
| string: canterbury-large/E.coli | 1048578 | 26480.0 ± 0.4% | 0.067 | 1.007 | 0.848 | 1.007 | 0.558 | 1.006 | 1.007 | 0.560 | 1.269 | 1.272 | 0.008 |
| string: canterbury-large/bible.txt | 1055886 | 8454.3 ± 1.3% | 0.024 | 0.628 | 0.878 | 0.877 | 0.399 | 0.892 | 0.897 | 0.398 | 1.001 | 1.014 | 0.024 |
| string: canterbury-large/world192.txt | 1103121 | 4136.8 ± 1.6% | 0.045 | 0.694 | 0.975 | 0.979 | 0.216 | 0.926 | 0.986 | 0.217 | 1.004 | 1.011 | 0.045 |
| string: http/html-1m | 1058582 | 9108.8 ± 6.5% | 0.022 | 0.563 | 0.776 | 0.780 | 0.318 | 0.743 | 0.788 | 0.318 | 0.972 | 1.045 | 0.022 |
| string: http/json-1m | 1190272 | 3295.8 ± 1.7% | 0.053 | 0.396 | 0.442 | 0.447 | 0.150 | 0.460 | 0.447 | 0.149 | 1.006 | 1.002 | 0.053 |
| string: http/js-1m | 1144362 | 2839.7 ± 0.6% | 0.062 | 0.701 | 0.915 | 0.918 | 0.194 | 0.845 | 0.922 | 0.193 | 1.006 | 1.013 | 0.062 |
| string: http/css-1m | 1097820 | 3291.0 ± 1.2% | 0.055 | 0.772 | 0.996 | 1.003 | 0.290 | 0.962 | 1.007 | 0.290 | 1.002 | 1.006 | 0.055 |
| string: dickens as Cyrillic and CJK | 1883069 | 5797.8 ± 1.4% | 0.025 | 0.063 | 0.452 | 0.452 | 0.200 | 0.453 | 0.453 | 0.199 | 1.002 | 1.002 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1185.6 ± 1.8% | 0.113 | 0.997 | 1.006 | 1.008 | 0.107 | 0.719 | 1.009 | 0.107 | 1.008 | 1.022 | 0.113 |
| hex: silesia/dickens | 524290 | 44717.9 ± 1.3% | 0.041 | 1.001 | 0.640 | 1.001 | 0.405 | 0.998 | 1.001 | 0.407 | 0.758 | 0.761 | 0.005 |
| hex: silesia/mozilla | 524290 | 45339.9 ± 0.4% | 0.040 | 1.001 | 0.632 | 1.000 | 0.396 | 0.996 | 1.001 | 0.397 | 0.750 | 0.748 | 0.005 |
| hex: silesia/mr | 524290 | 45539.2 ± 0.4% | 0.040 | 1.004 | 0.630 | 1.005 | 0.397 | 0.999 | 1.004 | 0.397 | 0.748 | 0.747 | 0.005 |
| hex: silesia/nci | 524290 | 39127.3 ± 0.3% | 0.047 | 1.003 | 0.656 | 1.003 | 0.451 | 1.002 | 1.003 | 0.453 | 0.870 | 0.870 | 0.005 |
| hex: silesia/ooffice | 524290 | 44713.6 ± 0.9% | 0.041 | 1.003 | 0.636 | 0.998 | 0.402 | 0.994 | 0.997 | 0.401 | 0.757 | 0.757 | 0.005 |
| hex: silesia/osdb | 524290 | 45135.7 ± 0.9% | 0.040 | 1.005 | 0.625 | 1.004 | 0.397 | 0.997 | 1.002 | 0.398 | 0.748 | 0.748 | 0.005 |
| hex: silesia/reymont | 524290 | 45344.2 ± 1.1% | 0.040 | 0.999 | 0.626 | 1.003 | 0.396 | 0.999 | 1.001 | 0.395 | 0.744 | 0.742 | 0.005 |
| hex: silesia/samba | 524290 | 44462.8 ± 4.6% | 0.041 | 1.005 | 0.628 | 1.003 | 0.396 | 1.003 | 1.007 | 0.396 | 0.759 | 0.760 | 0.005 |
| hex: silesia/sao | 524290 | 44540.4 ± 1.5% | 0.041 | 1.006 | 0.623 | 1.001 | 0.396 | 1.002 | 1.004 | 0.396 | 0.757 | 0.756 | 0.005 |
| hex: silesia/webster | 524290 | 44984.8 ± 1.4% | 0.040 | 1.004 | 0.632 | 0.999 | 0.398 | 1.000 | 1.005 | 0.399 | 0.748 | 0.749 | 0.005 |
| hex: silesia/x-ray | 524290 | 45041.9 ± 1.1% | 0.041 | 0.999 | 0.637 | 0.997 | 0.401 | 0.990 | 0.995 | 0.398 | 0.747 | 0.749 | 0.005 |
| hex: silesia/xml | 524290 | 48175.9 ± 9.8% | 0.038 | 1.005 | 0.590 | 1.002 | 0.374 | 0.992 | 1.004 | 0.375 | 0.700 | 0.704 | 0.004 |
| hex: canterbury/alice29.txt | 304180 | 45615.7 ± 0.8% | 0.040 | 1.002 | 0.625 | 1.005 | 0.396 | 1.000 | 1.003 | 0.396 | 0.743 | 0.741 | 0.005 |
| hex: canterbury/asyoulik.txt | 250360 | 45716.3 ± 1.3% | 0.040 | 1.000 | 0.625 | 0.998 | 0.395 | 0.992 | 0.997 | 0.394 | 0.737 | 0.737 | 0.005 |
| hex: canterbury/cp.html | 49208 | 44889.5 ± 0.6% | 0.041 | 0.999 | 0.621 | 0.997 | 0.393 | 0.996 | 0.996 | 0.396 | 0.743 | 0.743 | 0.005 |
| hex: canterbury/fields.c | 22302 | 51399.2 ± 0.9% | 0.036 | 1.004 | 0.534 | 1.004 | 0.385 | 0.994 | 0.999 | 0.392 | 0.642 | 0.641 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 45137.1 ± 0.9% | 0.041 | 1.006 | 0.564 | 1.009 | 0.401 | 0.998 | 1.011 | 0.421 | 0.660 | 0.660 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 45500.7 ± 3.0% | 0.040 | 0.995 | 0.619 | 0.992 | 0.396 | 0.977 | 0.984 | 0.395 | 0.745 | 0.745 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 46285.8 ± 0.7% | 0.040 | 1.004 | 0.606 | 1.006 | 0.388 | 0.994 | 1.003 | 0.389 | 0.729 | 0.729 | 0.005 |
| hex: canterbury/plrabn12.txt | 524290 | 45462.9 ± 3.6% | 0.040 | 0.998 | 0.612 | 1.004 | 0.394 | 1.001 | 1.005 | 0.395 | 0.742 | 0.742 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 44875.7 ± 2.3% | 0.041 | 1.000 | 0.636 | 0.994 | 0.397 | 0.995 | 1.001 | 0.396 | 0.753 | 0.751 | 0.005 |
| hex: canterbury/sum | 76482 | 42855.7 ± 1.5% | 0.042 | 1.005 | 0.653 | 1.004 | 0.400 | 1.004 | 1.003 | 0.403 | 0.772 | 0.773 | 0.005 |
| hex: canterbury/xargs.1 | 8456 | 45630.5 ± 1.9% | 0.040 | 1.009 | 0.564 | 1.013 | 0.404 | 1.005 | 1.015 | 0.422 | 0.661 | 0.662 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 48134.8 ± 2.5% | 0.038 | 1.002 | 0.581 | 1.001 | 0.374 | 0.996 | 1.003 | 0.373 | 0.701 | 0.701 | 0.004 |
| hex: canterbury-large/bible.txt | 524290 | 45196.9 ± 0.9% | 0.040 | 1.003 | 0.632 | 1.004 | 0.398 | 0.998 | 1.001 | 0.396 | 0.745 | 0.745 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 46116.7 ± 1.8% | 0.039 | 1.004 | 0.617 | 1.004 | 0.386 | 0.999 | 1.003 | 0.385 | 0.734 | 0.731 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 18043.1 ± 1.1% | 0.100 | 1.025 | 0.819 | 0.996 | 0.573 | 1.007 | 1.001 | 0.630 | 0.851 | 0.833 | 0.012 |
| hex: http/html-16kx64 | 2097280 | 34748.0 ± 0.6% | 0.052 | 1.008 | 0.687 | 1.009 | 0.470 | 1.006 | 1.008 | 0.475 | 0.808 | 0.806 | 0.006 |
| hex: http/html-1m | 524290 | 45421.5 ± 0.6% | 0.040 | 1.000 | 0.626 | 1.002 | 0.396 | 0.995 | 0.998 | 0.397 | 0.744 | 0.745 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 17948.4 ± 0.8% | 0.101 | 1.021 | 0.826 | 1.000 | 0.591 | 1.006 | 1.000 | 0.648 | 0.853 | 0.836 | 0.012 |
| hex: http/json-16kx64 | 2097280 | 34128.5 ± 0.9% | 0.053 | 1.003 | 0.692 | 1.007 | 0.471 | 1.004 | 1.006 | 0.476 | 0.806 | 0.807 | 0.006 |
| hex: http/json-1m | 524290 | 40924.0 ± 2.3% | 0.044 | 0.996 | 0.651 | 1.001 | 0.427 | 0.999 | 1.004 | 0.427 | 0.824 | 0.825 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 18131.3 ± 2.5% | 0.099 | 1.028 | 0.825 | 1.001 | 0.588 | 1.011 | 1.003 | 0.648 | 0.855 | 0.837 | 0.012 |
| hex: http/js-16kx64 | 2097280 | 33946.2 ± 5.7% | 0.054 | 1.005 | 0.705 | 1.005 | 0.480 | 1.003 | 1.005 | 0.485 | 0.818 | 0.819 | 0.006 |
| hex: http/js-1m | 524290 | 45626.8 ± 1.4% | 0.040 | 1.005 | 0.626 | 1.006 | 0.393 | 1.005 | 1.007 | 0.394 | 0.739 | 0.740 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 17917.4 ± 0.5% | 0.100 | 1.026 | 0.830 | 1.003 | 0.578 | 1.008 | 1.000 | 0.637 | 0.858 | 0.841 | 0.012 |
| hex: http/css-16kx64 | 2097280 | 34397.8 ± 4.9% | 0.053 | 1.008 | 0.693 | 1.008 | 0.473 | 1.010 | 1.009 | 0.477 | 0.808 | 0.810 | 0.006 |
| hex: http/css-1m | 524290 | 44530.8 ± 5.5% | 0.041 | 1.002 | 0.645 | 1.002 | 0.389 | 0.998 | 1.003 | 0.390 | 0.762 | 0.760 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 45379.9 ± 1.8% | 0.040 | 1.005 | 0.625 | 1.003 | 0.393 | 0.994 | 1.003 | 0.395 | 0.745 | 0.745 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1741.4 ± 1.3% | 0.425 | 1.006 | 0.981 | 1.015 | 1.012 | 0.272 | 1.013 | 0.515 | 0.907 | 0.095 | 1.034 |
| qlog records, JSON text sequence | 1467503 | 1671.1 ± 1.8% | 0.627 | 0.961 | 0.974 | 1.006 | 0.979 | 0.232 | 0.982 | 0.436 | 0.863 | 0.106 | 1.028 |
| messages: 11 string members | 1025025 | 1339.2 ± 0.7% | 0.493 | 0.960 | 0.977 | 0.984 | 0.971 | 0.377 | 0.974 | 0.664 | 0.947 | 0.121 | 0.996 |
| messages: 50 nested objects | 1121600 | 1996.0 ± 0.8% | 0.581 | 0.978 | 0.966 | 0.989 | 0.975 | 0.241 | 0.973 | 0.458 | 0.853 | 0.092 | 1.005 |
| string: silesia/dickens | 172528 | 13024.6 ± 1.3% | 0.017 | 0.526 | 0.359 | 0.509 | 0.540 | 0.119 | 0.547 | 0.998 | 1.001 | 0.017 | 1.023 |
| string: silesia/nci | 1075110 | 10980.7 ± 1.4% | 0.020 | 0.534 | 0.378 | 0.546 | 0.536 | 0.189 | 0.536 | 1.003 | 1.006 | 0.020 | 1.044 |
| string: silesia/reymont | 1075159 | 5325.9 ± 2.4% | 0.042 | 0.575 | 0.431 | 0.566 | 0.578 | 0.266 | 0.574 | 0.999 | 1.010 | 0.042 | 1.020 |
| string: silesia/samba | 97582 | 6290.9 ± 0.5% | 0.045 | 0.888 | 0.743 | 0.885 | 0.891 | 0.122 | 0.894 | 0.999 | 1.003 | 0.045 | 1.166 |
| string: silesia/webster | 1098490 | 6866.7 ± 0.7% | 0.032 | 0.588 | 0.409 | 0.565 | 0.593 | 0.160 | 0.592 | 0.990 | 1.009 | 0.032 | 1.017 |
| string: silesia/xml | 1090118 | 10356.4 ± 1.0% | 0.022 | 0.579 | 0.484 | 0.577 | 0.585 | 0.216 | 0.586 | 0.996 | 1.009 | 0.022 | 1.089 |
| string: canterbury/alice29.txt | 159425 | 12500.6 ± 7.0% | 0.018 | 0.443 | 0.362 | 0.426 | 0.466 | 0.093 | 0.481 | 1.003 | 1.007 | 0.018 | 1.067 |
| string: canterbury/asyoulik.txt | 132198 | 10506.9 ± 4.3% | 0.020 | 0.403 | 0.346 | 0.400 | 0.426 | 0.094 | 0.435 | 0.991 | 1.021 | 0.020 | 1.095 |
| string: canterbury/lcet10.txt | 441884 | 11949.7 ± 1.4% | 0.019 | 0.578 | 0.343 | 0.565 | 0.583 | 0.124 | 0.585 | 0.997 | 1.013 | 0.019 | 1.058 |
| string: canterbury/plrabn12.txt | 503330 | 8252.8 ± 1.9% | 0.027 | 0.658 | 0.531 | 0.660 | 0.660 | 0.170 | 0.661 | 0.999 | 1.012 | 0.027 | 1.085 |
| string: canterbury-large/E.coli | 1048578 | 33959.2 ± 1.5% | 0.053 | 1.003 | 1.004 | 0.739 | 1.006 | 0.485 | 1.003 | 1.003 | 1.005 | 0.007 | 1.003 |
| string: canterbury-large/bible.txt | 1055886 | 9346.0 ± 0.7% | 0.025 | 0.763 | 0.585 | 0.764 | 0.779 | 0.405 | 0.774 | 0.993 | 1.001 | 0.025 | 1.048 |
| string: canterbury-large/world192.txt | 1103121 | 6582.9 ± 1.9% | 0.034 | 0.592 | 0.429 | 0.561 | 0.595 | 0.154 | 0.596 | 0.992 | 0.998 | 0.034 | 0.980 |
| string: http/html-1m | 1058582 | 10057.7 ± 0.9% | 0.023 | 0.644 | 0.539 | 0.640 | 0.648 | 0.317 | 0.649 | 0.998 | 1.016 | 0.023 | 1.011 |
| string: http/json-1m | 1190272 | 8342.6 ± 0.8% | 0.024 | 0.185 | 0.161 | 0.184 | 0.185 | 0.074 | 0.185 | 1.003 | 1.003 | 0.024 | 1.019 |
| string: http/js-1m | 1144362 | 6508.7 ± 0.8% | 0.033 | 0.371 | 0.313 | 0.360 | 0.372 | 0.094 | 0.372 | 0.994 | 1.008 | 0.033 | 1.021 |
| string: http/css-1m | 1097820 | 8995.7 ± 1.1% | 0.024 | 0.364 | 0.294 | 0.355 | 0.365 | 0.128 | 0.365 | 0.997 | 1.000 | 0.024 | 1.040 |
| string: dickens as Cyrillic and CJK | 1883069 | 5445.9 ± 0.7% | 0.030 | 0.468 | 0.069 | 0.466 | 0.468 | 0.210 | 0.467 | 1.000 | 1.000 | 0.030 | 1.043 |
| hex: silesia/dickens | 524290 | 42900.6 ± 4.8% | 1.006 | 0.089 | 1.005 | 0.596 | 1.013 | 1.006 | 1.008 | 1.004 | 1.005 | 0.092 | 1.008 |
| hex: silesia/mozilla | 524290 | 43599.7 ± 0.4% | 0.972 | 0.088 | 1.002 | 0.589 | 1.001 | 1.002 | 1.000 | 1.002 | 1.003 | 0.094 | 0.999 |
| hex: silesia/mr | 524290 | 43429.2 ± 3.9% | 1.006 | 0.088 | 1.006 | 0.592 | 1.007 | 1.002 | 1.001 | 1.001 | 1.002 | 0.094 | 1.000 |
| hex: silesia/nci | 524290 | 43266.5 ± 8.0% | 1.001 | 0.088 | 1.005 | 0.591 | 0.992 | 0.997 | 1.003 | 1.008 | 1.007 | 0.092 | 1.002 |
| hex: silesia/ooffice | 524290 | 42588.9 ± 1.0% | 1.003 | 0.090 | 0.999 | 0.601 | 0.998 | 0.998 | 1.000 | 1.001 | 0.999 | 0.096 | 1.003 |
| hex: silesia/osdb | 524290 | 43279.1 ± 1.2% | 1.003 | 0.088 | 1.004 | 0.591 | 0.999 | 1.001 | 1.000 | 1.005 | 1.003 | 0.094 | 1.000 |
| hex: silesia/reymont | 524290 | 43196.1 ± 2.0% | 0.999 | 0.088 | 0.997 | 0.591 | 0.996 | 0.993 | 0.991 | 0.993 | 0.993 | 0.094 | 0.990 |
| hex: silesia/samba | 524290 | 43642.7 ± 1.4% | 1.000 | 0.088 | 0.996 | 0.587 | 0.999 | 0.999 | 0.999 | 1.000 | 1.001 | 0.091 | 1.000 |
| hex: silesia/sao | 524290 | 43749.6 ± 0.1% | 1.000 | 0.088 | 1.000 | 0.589 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 0.091 | 0.998 |
| hex: silesia/webster | 524290 | 44062.7 ± 0.3% | 1.002 | 0.087 | 1.001 | 0.586 | 1.001 | 1.000 | 0.999 | 1.001 | 1.001 | 0.092 | 1.001 |
| hex: silesia/x-ray | 524290 | 43534.5 ± 0.7% | 1.002 | 0.088 | 1.000 | 0.590 | 1.000 | 0.997 | 0.995 | 0.998 | 0.996 | 0.092 | 0.999 |
| hex: silesia/xml | 524290 | 43164.0 ± 1.7% | 1.001 | 0.089 | 1.000 | 0.595 | 1.001 | 0.994 | 0.994 | 1.000 | 0.994 | 0.093 | 0.998 |
| hex: canterbury/alice29.txt | 304180 | 43605.6 ± 0.6% | 1.001 | 0.088 | 1.002 | 0.589 | 1.002 | 1.002 | 1.003 | 1.002 | 1.002 | 0.092 | 1.003 |
| hex: canterbury/asyoulik.txt | 250360 | 43098.0 ± 0.1% | 1.000 | 0.089 | 0.999 | 0.595 | 0.999 | 0.995 | 0.998 | 0.999 | 0.999 | 0.094 | 0.998 |
| hex: canterbury/cp.html | 49208 | 42601.2 ± 0.3% | 1.001 | 0.090 | 1.001 | 0.593 | 1.002 | 0.994 | 1.002 | 1.002 | 1.001 | 0.097 | 1.001 |
| hex: canterbury/fields.c | 22302 | 42126.4 ± 1.4% | 1.000 | 0.091 | 1.001 | 0.598 | 1.002 | 0.989 | 1.002 | 1.003 | 1.011 | 0.097 | 1.004 |
| hex: canterbury/grammar.lsp | 7444 | 39220.7 ± 0.3% | 0.993 | 0.096 | 1.011 | 0.608 | 1.016 | 0.988 | 1.018 | 1.016 | 1.033 | 0.103 | 1.018 |
| hex: canterbury/kennedy.xls | 524290 | 43550.9 ± 0.3% | 0.999 | 0.088 | 1.003 | 0.591 | 1.003 | 1.000 | 1.003 | 1.002 | 1.003 | 0.093 | 1.003 |
| hex: canterbury/lcet10.txt | 524290 | 43584.5 ± 0.3% | 1.001 | 0.088 | 1.000 | 0.590 | 1.000 | 0.998 | 0.999 | 1.000 | 0.999 | 0.093 | 0.958 |
| hex: canterbury/plrabn12.txt | 524290 | 42614.4 ± 0.2% | 1.001 | 0.090 | 1.002 | 0.601 | 1.002 | 1.000 | 1.001 | 1.001 | 1.001 | 0.094 | 0.998 |
| hex: canterbury/ptt5 | 524290 | 43530.7 ± 0.4% | 1.005 | 0.089 | 1.003 | 0.590 | 1.002 | 1.001 | 1.003 | 1.002 | 1.000 | 0.092 | 1.004 |
| hex: canterbury/sum | 76482 | 42896.9 ± 0.7% | 1.000 | 0.090 | 1.000 | 0.592 | 1.001 | 0.996 | 1.001 | 1.002 | 1.004 | 0.096 | 0.998 |
| hex: canterbury/xargs.1 | 8456 | 40292.2 ± 0.2% | 1.003 | 0.094 | 1.001 | 0.601 | 1.002 | 0.950 | 1.001 | 0.991 | 1.021 | 0.101 | 1.004 |
| hex: canterbury-large/E.coli | 524290 | 43544.7 ± 0.1% | 1.001 | 0.088 | 0.967 | 0.590 | 1.000 | 0.999 | 1.001 | 0.961 | 0.963 | 0.093 | 1.000 |
| hex: canterbury-large/bible.txt | 524290 | 43728.0 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.566 | 1.001 | 0.999 | 1.000 | 1.000 | 0.992 | 0.092 | 1.000 |
| hex: canterbury-large/world192.txt | 524290 | 43633.1 ± 0.4% | 1.002 | 0.088 | 1.000 | 0.590 | 1.001 | 0.999 | 1.001 | 1.000 | 1.001 | 0.094 | 1.001 |
| hex: http/html-1kx1024 | 2099200 | 20471.0 ± 0.3% | 1.004 | 0.179 | 1.004 | 0.987 | 1.001 | 1.003 | 1.002 | 1.003 | 1.007 | 0.187 | 1.005 |
| hex: http/html-16kx64 | 2097280 | 21306.1 ± 0.4% | 1.004 | 0.178 | 1.004 | 0.986 | 1.004 | 1.003 | 1.003 | 1.004 | 1.004 | 0.193 | 1.004 |
| hex: http/html-1m | 524290 | 43551.2 ± 3.6% | 1.000 | 0.088 | 1.001 | 0.589 | 1.001 | 0.999 | 1.002 | 1.002 | 1.001 | 0.092 | 1.003 |
| hex: http/json-1kx1024 | 2099200 | 20329.6 ± 0.4% | 1.004 | 0.181 | 1.004 | 0.987 | 1.003 | 1.002 | 1.003 | 1.003 | 1.008 | 0.188 | 1.005 |
| hex: http/json-16kx64 | 2097280 | 21678.6 ± 0.4% | 1.002 | 0.174 | 1.003 | 0.983 | 1.003 | 1.002 | 1.003 | 1.003 | 1.004 | 0.190 | 1.003 |
| hex: http/json-1m | 524290 | 43399.4 ± 0.2% | 1.001 | 0.089 | 1.001 | 0.595 | 1.000 | 0.999 | 1.001 | 1.000 | 1.000 | 0.092 | 1.001 |
| hex: http/js-1kx1024 | 2099200 | 20520.4 ± 0.2% | 1.004 | 0.179 | 1.003 | 0.985 | 1.004 | 1.003 | 1.004 | 1.005 | 1.008 | 0.187 | 1.006 |
| hex: http/js-16kx64 | 2097280 | 21896.1 ± 0.3% | 1.001 | 0.173 | 1.001 | 0.968 | 1.002 | 1.000 | 1.001 | 1.001 | 1.002 | 0.188 | 1.001 |
| hex: http/js-1m | 524290 | 43680.0 ± 0.1% | 1.001 | 0.088 | 1.001 | 0.591 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 0.090 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 22666.7 ± 0.2% | 1.002 | 0.162 | 1.002 | 0.930 | 1.002 | 0.985 | 1.002 | 1.003 | 1.008 | 0.168 | 1.005 |
| hex: http/css-16kx64 | 2097280 | 22602.1 ± 0.1% | 1.000 | 0.168 | 1.002 | 0.963 | 1.002 | 1.000 | 0.999 | 1.001 | 1.003 | 0.182 | 1.002 |
| hex: http/css-1m | 524290 | 43402.8 ± 0.4% | 1.002 | 0.089 | 1.002 | 0.592 | 0.999 | 0.998 | 1.002 | 0.998 | 1.000 | 0.092 | 1.001 |
| hex: shuffled/dickens-1m | 524290 | 43692.4 ± 0.8% | 1.002 | 0.088 | 1.000 | 0.590 | 1.001 | 0.997 | 1.001 | 1.001 | 1.001 | 0.093 | 1.000 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.069 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.068 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.069 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.063 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.070 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.067 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.071 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.068 of all on.
- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.091 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.090 of all on.
- messages: 50 nested objects, decoding: J8 decoder fast path off runs at 1.090 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.096 of all on.
- messages: 50 nested objects, decoding: J13 decoder escape blocks off runs at 1.090 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.098 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.101 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.114 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.063 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.063 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.064 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.077 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.127 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.163 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.130 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.121 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.128 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.104 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.110 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.119 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 167978.9 ± 0.5% | 122295.3 ± 0.1% | 1.374 | 100904.1 ± 0.1% | 1.665 |
| string: silesia/nci | 1048576 | 169120.3 ± 0.4% | 123035.8 ± 0.1% | 1.375 | 101413.8 ± 0.2% | 1.668 |
| string: silesia/reymont | 1048576 | 144823.6 ± 0.7% | 114359.7 ± 0.1% | 1.266 | 95739.8 ± 0.3% | 1.513 |
| string: silesia/samba | 65546 | 163031.3 ± 0.2% | 120396.7 ± 0.1% | 1.354 | 99636.4 ± 4.2% | 1.636 |
| string: silesia/webster | 1048576 | 148184.2 ± 0.6% | 115616.7 ± 5.9% | 1.282 | 97516.8 ± 0.3% | 1.520 |
| string: silesia/xml | 1048576 | 167595.9 ± 10.4% | 122895.6 ± 0.3% | 1.364 | 101439.9 ± 0.2% | 1.652 |
| string: canterbury/alice29.txt | 152089 | 167349.7 ± 2.2% | 121961.8 ± 0.2% | 1.372 | 100483.4 ± 3.0% | 1.665 |
| string: canterbury/asyoulik.txt | 125179 | 166170.6 ± 0.8% | 121383.2 ± 0.3% | 1.369 | 100878.7 ± 0.6% | 1.647 |
| string: canterbury/lcet10.txt | 426754 | 168399.9 ± 4.6% | 122445.0 ± 0.7% | 1.375 | 101207.6 ± 2.0% | 1.664 |
| string: canterbury/plrabn12.txt | 481861 | 168395.9 ± 0.6% | 122443.2 ± 5.6% | 1.375 | 101414.0 ± 0.2% | 1.660 |
| string: canterbury-large/E.coli | 1048576 | 167454.6 ± 10.1% | 122335.7 ± 0.4% | 1.369 | 100831.0 ± 0.5% | 1.661 |
| string: canterbury-large/bible.txt | 1048576 | 167998.0 ± 0.6% | 122411.4 ± 0.5% | 1.372 | 101817.4 ± 0.8% | 1.650 |
| string: canterbury-large/world192.txt | 1048576 | 167794.7 ± 2.2% | 122568.9 ± 0.4% | 1.369 | 100876.9 ± 3.6% | 1.663 |
| string: http/html-1m | 1048576 | 136355.6 ± 0.6% | 107405.6 ± 7.9% | 1.270 | 90196.2 ± 2.1% | 1.512 |
| string: http/json-1m | 1048576 | 121558.8 ± 5.1% | 106544.9 ± 0.3% | 1.141 | 82937.3 ± 0.3% | 1.466 |
| string: http/js-1m | 1048576 | 164724.7 ± 0.3% | 121930.7 ± 0.5% | 1.351 | 99738.1 ± 0.4% | 1.652 |
| string: http/css-1m | 1048576 | 167365.0 ± 0.6% | 122381.2 ± 0.2% | 1.368 | 100435.0 ± 0.6% | 1.666 |
| string: dickens as Cyrillic and CJK | 1847045 | 23772.4 ± 0.4% | 20917.9 ± 0.9% | 1.136 | 14931.3 ± 0.2% | 1.592 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 167861.7 ± 0.1% | 123054.7 ± 0.2% | 1.364 | 101994.3 ± 0.2% | 1.646 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 169009.5 ± 0.3% | 122998.7 ± 0.2% | 1.374 | 101503.6 ± 0.2% | 1.665 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 168658.0 ± 0.2% | 122979.8 ± 0.2% | 1.371 | 101382.0 ± 0.2% | 1.664 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 169249.0 ± 1.4% | 122746.8 ± 0.2% | 1.379 | 101345.8 ± 0.2% | 1.670 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 168942.1 ± 0.7% | 122686.5 ± 0.4% | 1.377 | 101448.3 ± 0.4% | 1.665 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 169024.5 ± 0.3% | 122980.3 ± 0.1% | 1.374 | 102095.0 ± 0.3% | 1.656 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24359.3 ± 0.3% | 21774.8 ± 0.2% | 1.119 | 15351.3 ± 0.2% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24363.0 ± 0.1% | 21719.3 ± 3.8% | 1.122 | 15330.5 ± 0.1% | 1.589 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24347.8 ± 0.2% | 21735.9 ± 0.4% | 1.120 | 15327.9 ± 0.2% | 1.588 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24372.2 ± 0.4% | 21741.3 ± 0.4% | 1.121 | 15326.3 ± 0.1% | 1.590 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24350.0 ± 0.4% | 21762.2 ± 0.6% | 1.119 | 15331.7 ± 0.2% | 1.588 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24355.0 ± 0.3% | 21736.4 ± 0.6% | 1.120 | 15349.5 ± 0.2% | 1.587 |

## Messages against serde_json's typed code

stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.

| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |
|---|---|---|---|---|
| messages: 11 string members | 1025025 | 1252.0 ± 3.3% | 781.8 ± 0.1% | 1.601 |
| messages: 50 nested objects | 1121600 | 1701.8 ± 1.0% | 980.3 ± 0.2% | 1.736 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1375.4 ± 0.2% | 1525.4 ± 0.9% | 1105.8 ± 0.4% | 392.1 ± 0.7% | 657.4 ± 0.3% | 363.2 ± 1.6% | 0.902 | 1.244 | 3.507 | 2.092 | 3.787 |
| qlog records, JSON text sequence | 1467503 | 1095.5 ± 0.4% | 1230.6 ± 1.3% | 1104.8 ± 3.9% | 330.0 ± 0.9% | 735.2 ± 0.2% | 306.9 ± 0.7% | 0.890 | 0.992 | 3.319 | 1.490 | 3.569 |
| messages: 11 string members | 1025025 | 1075.2 ± 0.7% | 2014.4 ± 4.4% | 760.5 ± 0.6% | 334.3 ± 2.0% | 498.0 ± 0.7% | 293.0 ± 1.2% | 0.534 | 1.414 | 3.217 | 2.159 | 3.669 |
| messages: 50 nested objects | 1121600 | 1328.4 ± 0.9% | 1740.3 ± 3.1% | 1428.3 ± 0.8% | 427.0 ± 1.1% | 897.5 ± 0.6% | 416.8 ± 3.2% | 0.763 | 0.930 | 3.111 | 1.480 | 3.187 |
| string: silesia/dickens | 172528 | 6651.2 ± 0.6% | 3403.1 ± 1.7% | 2818.2 ± 0.9% | 315.3 ± 1.0% | 3357.1 ± 1.9% | 564.7 ± 2.6% | 1.954 | 2.360 | 21.093 | 1.981 | 11.779 |
| string: silesia/nci | 1075110 | 5345.6 ± 1.0% | 3892.8 ± 2.3% | 2989.5 ± 1.3% | 649.0 ± 0.3% | 3659.1 ± 0.9% | 544.2 ± 1.3% | 1.373 | 1.788 | 8.237 | 1.461 | 9.823 |
| string: silesia/reymont | 1075159 | 3513.1 ± 2.0% | 3402.3 ± 0.5% | 1971.1 ± 2.6% | 339.0 ± 0.8% | 2078.3 ± 0.9% | 469.3 ± 2.8% | 1.033 | 1.782 | 10.362 | 1.690 | 7.487 |
| string: silesia/samba | 97582 | 3960.4 ± 1.3% | 3772.8 ± 0.2% | 3094.2 ± 0.7% | 325.6 ± 0.9% | 2036.9 ± 7.1% | 414.4 ± 0.7% | 1.050 | 1.280 | 12.162 | 1.944 | 9.556 |
| string: silesia/webster | 1098490 | 4360.5 ± 0.3% | 2435.5 ± 0.4% | 1735.4 ± 3.1% | 308.4 ± 0.6% | 2115.1 ± 1.2% | 443.1 ± 1.1% | 1.790 | 2.513 | 14.140 | 2.062 | 9.842 |
| string: silesia/xml | 1090118 | 6007.4 ± 0.7% | 5021.8 ± 1.1% | 2485.5 ± 0.9% | 505.8 ± 0.7% | 3364.9 ± 1.0% | 517.4 ± 2.7% | 1.196 | 2.417 | 11.878 | 1.785 | 11.611 |
| string: canterbury/alice29.txt | 159425 | 5734.8 ± 1.2% | 2745.2 ± 2.0% | 2848.3 ± 1.7% | 298.3 ± 0.9% | 3022.5 ± 1.6% | 510.8 ± 1.4% | 2.089 | 2.013 | 19.222 | 1.897 | 11.228 |
| string: canterbury/asyoulik.txt | 132198 | 4272.4 ± 1.0% | 2611.3 ± 1.5% | 2676.1 ± 0.8% | 301.5 ± 1.7% | 2444.1 ± 1.2% | 449.3 ± 1.2% | 1.636 | 1.597 | 14.170 | 1.748 | 9.508 |
| string: canterbury/lcet10.txt | 441884 | 6643.3 ± 1.0% | 3281.6 ± 0.7% | 2353.3 ± 1.5% | 346.9 ± 0.4% | 3029.8 ± 1.7% | 550.9 ± 1.3% | 2.024 | 2.823 | 19.148 | 2.193 | 12.060 |
| string: canterbury/plrabn12.txt | 503330 | 5467.4 ± 1.3% | 3157.0 ± 0.7% | 1858.5 ± 1.8% | 322.2 ± 0.7% | 2874.2 ± 1.5% | 526.9 ± 1.5% | 1.732 | 2.942 | 16.970 | 1.902 | 10.377 |
| string: canterbury-large/E.coli | 1048578 | 26480.0 ± 0.4% | 12909.4 ± 1.2% | 3365.4 ± 1.4% | 1270.9 ± 1.1% | 8888.9 ± 1.3% | 904.6 ± 4.8% | 2.051 | 7.868 | 20.835 | 2.979 | 29.274 |
| string: canterbury-large/bible.txt | 1055886 | 8454.3 ± 1.3% | 5215.7 ± 0.8% | 2797.2 ± 0.8% | 356.0 ± 1.6% | 3854.4 ± 1.2% | 607.8 ± 1.9% | 1.621 | 3.022 | 23.747 | 2.193 | 13.911 |
| string: canterbury-large/world192.txt | 1103121 | 4136.8 ± 1.6% | 2293.3 ± 1.5% | 1806.6 ± 0.9% | 327.5 ± 0.9% | 2178.6 ± 1.0% | 451.9 ± 3.2% | 1.804 | 2.290 | 12.632 | 1.899 | 9.154 |
| string: http/html-1m | 1058582 | 9108.8 ± 6.5% | 4706.4 ± 1.0% | 2717.2 ± 1.7% | 424.7 ± 0.8% | 3559.4 ± 0.5% | 589.2 ± 1.0% | 1.935 | 3.352 | 21.450 | 2.559 | 15.461 |
| string: http/json-1m | 1190272 | 3295.8 ± 1.7% | 1253.3 ± 1.0% | 2120.8 ± 0.7% | 468.7 ± 1.5% | 1357.0 ± 1.6% | 430.5 ± 1.7% | 2.630 | 1.554 | 7.031 | 2.429 | 7.657 |
| string: http/js-1m | 1144362 | 2839.7 ± 0.6% | 1598.9 ± 0.7% | 1321.1 ± 0.8% | 326.7 ± 0.5% | 1407.4 ± 0.3% | 375.4 ± 1.1% | 1.776 | 2.149 | 8.692 | 2.018 | 7.564 |
| string: http/css-1m | 1097820 | 3291.0 ± 1.2% | 2869.0 ± 1.1% | 2278.3 ± 1.3% | 456.6 ± 0.6% | 2120.8 ± 1.1% | 434.2 ± 2.1% | 1.147 | 1.444 | 7.207 | 1.552 | 7.580 |
| string: dickens as Cyrillic and CJK | 1883069 | 5797.8 ± 1.4% | 3405.8 ± 3.1% | 685.1 ± 0.9% | 376.5 ± 1.6% | 494.0 ± 0.9% | 161.0 ± 2.7% | 1.702 | 8.463 | 15.397 | 11.737 | 36.004 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1185.6 ± 1.8% | 1237.4 ± 2.0% | 1099.1 ± 1.0% | 263.6 ± 1.5% | 466.7 ± 0.9% | 222.4 ± 3.4% | 0.958 | 1.079 | 4.498 | 2.540 | 5.330 |
| hex: silesia/dickens | 524290 | 44717.9 ± 1.3% | 15093.6 ± 1.1% | 3563.9 ± 0.6% | 479.5 ± 0.4% | 8978.5 ± 0.8% | 1115.5 ± 6.8% | 2.963 | 12.547 | 93.251 | 4.981 | 40.086 |
| hex: silesia/mozilla | 524290 | 45339.9 ± 0.4% | 15094.3 ± 1.1% | 3489.7 ± 3.1% | 429.4 ± 0.9% | 8951.9 ± 0.8% | 1116.6 ± 5.1% | 3.004 | 12.992 | 105.587 | 5.065 | 40.604 |
| hex: silesia/mr | 524290 | 45539.2 ± 0.4% | 15106.3 ± 4.2% | 3498.2 ± 9.5% | 651.5 ± 0.2% | 8959.9 ± 0.1% | 1112.9 ± 1.9% | 3.015 | 13.018 | 69.896 | 5.083 | 40.920 |
| hex: silesia/nci | 524290 | 39127.3 ± 0.3% | 15120.0 ± 0.7% | 3572.1 ± 2.5% | 761.7 ± 0.8% | 8979.4 ± 0.6% | 1116.5 ± 2.9% | 2.588 | 10.954 | 51.369 | 4.357 | 35.046 |
| hex: silesia/ooffice | 524290 | 44713.6 ± 0.9% | 15043.2 ± 0.9% | 3494.2 ± 1.2% | 342.3 ± 1.2% | 8860.7 ± 1.2% | 1123.5 ± 0.9% | 2.972 | 12.797 | 130.640 | 5.046 | 39.798 |
| hex: silesia/osdb | 524290 | 45135.7 ± 0.9% | 15024.2 ± 1.0% | 3484.3 ± 0.8% | 454.1 ± 0.9% | 8872.9 ± 0.9% | 1123.8 ± 1.5% | 3.004 | 12.954 | 99.385 | 5.087 | 40.164 |
| hex: silesia/reymont | 524290 | 45344.2 ± 1.1% | 15005.6 ± 0.4% | 3526.2 ± 1.0% | 491.0 ± 2.3% | 8903.4 ± 1.1% | 1117.3 ± 2.2% | 3.022 | 12.859 | 92.347 | 5.093 | 40.583 |
| hex: silesia/samba | 524290 | 44462.8 ± 4.6% | 14960.9 ± 0.5% | 3466.0 ± 0.4% | 362.8 ± 0.7% | 8887.7 ± 0.5% | 1112.5 ± 1.1% | 2.972 | 12.828 | 122.562 | 5.003 | 39.968 |
| hex: silesia/sao | 524290 | 44540.4 ± 1.5% | 14933.9 ± 0.5% | 3471.5 ± 1.1% | 278.2 ± 1.1% | 8901.9 ± 0.8% | 1117.0 ± 3.2% | 2.983 | 12.830 | 160.103 | 5.003 | 39.876 |
| hex: silesia/webster | 524290 | 44984.8 ± 1.4% | 14975.6 ± 0.6% | 3529.0 ± 0.4% | 448.3 ± 0.9% | 8887.4 ± 0.7% | 1114.7 ± 1.2% | 3.004 | 12.747 | 100.356 | 5.062 | 40.357 |
| hex: silesia/x-ray | 524290 | 45041.9 ± 1.1% | 15079.1 ± 1.2% | 3479.3 ± 1.2% | 425.0 ± 0.8% | 8936.0 ± 1.0% | 1122.4 ± 1.2% | 2.987 | 12.946 | 105.979 | 5.040 | 40.131 |
| hex: silesia/xml | 524290 | 48175.9 ± 9.8% | 15081.6 ± 0.8% | 3556.3 ± 0.8% | 705.0 ± 0.9% | 8932.6 ± 0.7% | 1123.5 ± 1.0% | 3.194 | 13.547 | 68.337 | 5.393 | 42.880 |
| hex: canterbury/alice29.txt | 304180 | 45615.7 ± 0.8% | 14226.7 ± 0.6% | 3566.4 ± 0.9% | 484.8 ± 0.4% | 8964.5 ± 0.2% | 1144.8 ± 1.4% | 3.206 | 12.790 | 94.086 | 5.088 | 39.845 |
| hex: canterbury/asyoulik.txt | 250360 | 45716.3 ± 1.3% | 15040.7 ± 1.1% | 3476.7 ± 0.6% | 467.4 ± 1.0% | 8871.9 ± 0.5% | 1135.0 ± 1.2% | 3.040 | 13.149 | 97.803 | 5.153 | 40.280 |
| hex: canterbury/cp.html | 49208 | 44889.5 ± 0.6% | 14413.0 ± 0.6% | 3561.3 ± 0.3% | 499.1 ± 0.8% | 9308.2 ± 0.5% | 1110.9 ± 1.8% | 3.115 | 12.605 | 89.943 | 4.823 | 40.407 |
| hex: canterbury/fields.c | 22302 | 51399.2 ± 0.9% | 17648.4 ± 0.5% | 3669.1 ± 0.5% | 525.5 ± 0.4% | 9291.1 ± 0.4% | 1088.5 ± 1.9% | 2.912 | 14.009 | 97.803 | 5.532 | 47.218 |
| hex: canterbury/grammar.lsp | 7444 | 45137.1 ± 0.9% | 17252.7 ± 0.1% | 3594.5 ± 0.4% | 699.9 ± 1.3% | 9019.7 ± 0.4% | 1053.0 ± 6.7% | 2.616 | 12.557 | 64.488 | 5.004 | 42.867 |
| hex: canterbury/kennedy.xls | 524290 | 45500.7 ± 3.0% | 14438.2 ± 1.0% | 3557.9 ± 1.3% | 755.4 ± 1.4% | 8952.8 ± 1.4% | 1080.0 ± 4.4% | 3.151 | 12.789 | 60.230 | 5.082 | 42.129 |
| hex: canterbury/lcet10.txt | 524290 | 46285.8 ± 0.7% | 14810.3 ± 1.2% | 3545.4 ± 1.2% | 481.1 ± 1.2% | 8904.2 ± 1.3% | 1087.1 ± 4.8% | 3.125 | 13.055 | 96.215 | 5.198 | 42.577 |
| hex: canterbury/plrabn12.txt | 524290 | 45462.9 ± 3.6% | 14360.8 ± 1.3% | 3537.9 ± 2.0% | 464.6 ± 0.4% | 8882.5 ± 5.5% | 1101.0 ± 4.5% | 3.166 | 12.850 | 97.845 | 5.118 | 41.292 |
| hex: canterbury/ptt5 | 524290 | 44875.7 ± 2.3% | 14838.4 ± 4.1% | 3472.7 ± 0.6% | 660.3 ± 3.6% | 8876.5 ± 1.2% | 1101.6 ± 4.1% | 3.024 | 12.922 | 67.966 | 5.056 | 40.735 |
| hex: canterbury/sum | 76482 | 42855.7 ± 1.5% | 15323.7 ± 0.5% | 3540.4 ± 0.4% | 569.9 ± 1.8% | 8865.7 ± 0.4% | 1116.0 ± 1.4% | 2.797 | 12.105 | 75.196 | 4.834 | 38.402 |
| hex: canterbury/xargs.1 | 8456 | 45630.5 ± 1.9% | 17306.5 ± 0.5% | 3551.5 ± 0.4% | 680.5 ± 1.4% | 8990.7 ± 0.4% | 1085.3 ± 3.4% | 2.637 | 12.848 | 67.053 | 5.075 | 42.046 |
| hex: canterbury-large/E.coli | 524290 | 48134.8 ± 2.5% | 14932.9 ± 1.4% | 3489.3 ± 0.8% | 955.6 ± 0.5% | 8886.5 ± 0.8% | 1069.2 ± 7.2% | 3.223 | 13.795 | 50.373 | 5.417 | 45.021 |
| hex: canterbury-large/bible.txt | 524290 | 45196.9 ± 0.9% | 14947.4 ± 0.4% | 3479.3 ± 0.6% | 498.9 ± 0.5% | 8891.3 ± 0.6% | 1085.0 ± 5.8% | 3.024 | 12.990 | 90.595 | 5.083 | 41.654 |
| hex: canterbury-large/world192.txt | 524290 | 46116.7 ± 1.8% | 15002.6 ± 0.8% | 3541.8 ± 0.6% | 460.5 ± 0.5% | 8916.3 ± 0.5% | 1094.7 ± 3.6% | 3.074 | 13.021 | 100.144 | 5.172 | 42.129 |
| hex: http/html-1kx1024 | 2099200 | 18043.1 ± 1.1% | 12439.6 ± 5.7% | 3157.5 ± 0.6% | 492.7 ± 0.6% | 7760.4 ± 0.6% | 954.1 ± 3.2% | 1.450 | 5.714 | 36.622 | 2.325 | 18.911 |
| hex: http/html-16kx64 | 2097280 | 34748.0 ± 0.6% | 14010.6 ± 0.7% | 3383.8 ± 1.0% | 499.5 ± 0.3% | 8698.4 ± 0.7% | 1037.5 ± 3.8% | 2.480 | 10.269 | 69.560 | 3.995 | 33.491 |
| hex: http/html-1m | 524290 | 45421.5 ± 0.6% | 15049.4 ± 0.9% | 3470.3 ± 0.9% | 497.9 ± 0.7% | 8884.2 ± 1.1% | 1115.3 ± 1.5% | 3.018 | 13.089 | 91.224 | 5.113 | 40.727 |
| hex: http/json-1kx1024 | 2099200 | 17948.4 ± 0.8% | 12098.3 ± 1.1% | 3155.9 ± 0.5% | 652.8 ± 0.9% | 7759.1 ± 0.4% | 947.6 ± 1.5% | 1.484 | 5.687 | 27.495 | 2.313 | 18.942 |
| hex: http/json-16kx64 | 2097280 | 34128.5 ± 0.9% | 13874.8 ± 0.6% | 3383.6 ± 0.4% | 665.8 ± 3.0% | 8495.5 ± 0.7% | 1039.6 ± 3.1% | 2.460 | 10.086 | 51.256 | 4.017 | 32.830 |
| hex: http/json-1m | 524290 | 40924.0 ± 2.3% | 15015.3 ± 1.1% | 3541.8 ± 1.1% | 693.7 ± 1.0% | 8917.8 ± 0.9% | 1071.8 ± 7.5% | 2.725 | 11.554 | 58.998 | 4.589 | 38.181 |
| hex: http/js-1kx1024 | 2099200 | 18131.3 ± 2.5% | 12294.4 ± 2.4% | 3159.0 ± 0.6% | 474.0 ± 0.4% | 7748.7 ± 1.8% | 948.3 ± 3.9% | 1.475 | 5.739 | 38.254 | 2.340 | 19.119 |
| hex: http/js-16kx64 | 2097280 | 33946.2 ± 5.7% | 13960.2 ± 1.2% | 3406.5 ± 0.9% | 482.5 ± 1.2% | 8650.9 ± 4.7% | 1055.8 ± 2.0% | 2.432 | 9.965 | 70.358 | 3.924 | 32.153 |
| hex: http/js-1m | 524290 | 45626.8 ± 1.4% | 15019.2 ± 1.0% | 3544.2 ± 0.9% | 493.3 ± 1.3% | 8903.3 ± 1.2% | 1080.9 ± 3.4% | 3.038 | 12.874 | 92.498 | 5.125 | 42.213 |
| hex: http/css-1kx1024 | 2099200 | 17917.4 ± 0.5% | 12085.5 ± 2.6% | 3164.2 ± 0.6% | 549.1 ± 1.2% | 7767.4 ± 1.0% | 950.2 ± 1.3% | 1.483 | 5.663 | 32.630 | 2.307 | 18.857 |
| hex: http/css-16kx64 | 2097280 | 34397.8 ± 4.9% | 13879.9 ± 0.7% | 3379.0 ± 0.8% | 561.3 ± 0.7% | 8599.5 ± 1.5% | 1046.2 ± 3.1% | 2.478 | 10.180 | 61.284 | 4.000 | 32.879 |
| hex: http/css-1m | 524290 | 44530.8 ± 5.5% | 15076.2 ± 0.8% | 3537.1 ± 3.5% | 543.7 ± 1.4% | 8969.6 ± 1.1% | 1093.4 ± 2.4% | 2.954 | 12.590 | 81.907 | 4.965 | 40.729 |
| hex: shuffled/dickens-1m | 524290 | 45379.9 ± 1.8% | 15062.3 ± 1.2% | 3479.8 ± 1.1% | 474.6 ± 1.4% | 8892.6 ± 0.5% | 1102.5 ± 3.3% | 3.013 | 13.041 | 95.609 | 5.103 | 41.160 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1741.4 ± 1.3% | 1465.7 ± 0.3% | 1014.6 ± 0.9% | 460.2 ± 1.1% | 432.2 ± 2.4% | 498.7 ± 0.6% | 1.188 | 1.716 | 3.784 | 4.030 | 3.492 |
| qlog records, JSON text sequence | 1467503 | 1671.1 ± 1.8% | 1224.0 ± 1.0% | 934.3 ± 1.2% | 431.3 ± 1.2% | 537.2 ± 1.7% | 352.5 ± 1.2% | 1.365 | 1.789 | 3.875 | 3.110 | 4.741 |
| messages: 11 string members | 1025025 | 1339.2 ± 0.7% | 1099.7 ± 0.6% | 744.7 ± 0.8% | 408.8 ± 0.7% | 425.5 ± 1.0% | 431.4 ± 0.7% | 1.218 | 1.798 | 3.276 | 3.148 | 3.104 |
| messages: 50 nested objects | 1121600 | 1996.0 ± 0.8% | 1862.8 ± 4.3% | 1324.0 ± 1.1% | 573.7 ± 0.8% | 613.8 ± 0.9% | 508.1 ± 0.8% | 1.071 | 1.508 | 3.479 | 3.252 | 3.928 |
| string: silesia/dickens | 172528 | 13024.6 ± 1.3% | 3877.8 ± 1.6% | 3096.8 ± 1.8% | 331.8 ± 0.8% | 1707.8 ± 0.9% | 1173.5 ± 1.5% | 3.359 | 4.206 | 39.260 | 7.627 | 11.098 |
| string: silesia/nci | 1075110 | 10980.7 ± 1.4% | 4663.4 ± 1.5% | 3122.6 ± 0.5% | 904.6 ± 0.8% | 1890.4 ± 2.3% | 1187.2 ± 5.2% | 2.355 | 3.517 | 12.138 | 5.809 | 9.249 |
| string: silesia/reymont | 1075159 | 5325.9 ± 2.4% | 1843.6 ± 1.4% | 1999.1 ± 0.5% | 375.2 ± 1.3% | 1422.0 ± 0.5% | 1038.6 ± 0.7% | 2.889 | 2.664 | 14.193 | 3.745 | 5.128 |
| string: silesia/samba | 97582 | 6290.9 ± 0.5% | 2663.4 ± 0.6% | 4069.1 ± 0.4% | 346.5 ± 1.0% | 1325.6 ± 0.5% | 1166.8 ± 1.0% | 2.362 | 1.546 | 18.157 | 4.746 | 5.392 |
| string: silesia/webster | 1098490 | 6866.7 ± 0.7% | 1966.6 ± 2.4% | 1873.0 ± 1.4% | 348.6 ± 0.7% | 1397.9 ± 3.2% | 600.1 ± 0.5% | 3.492 | 3.666 | 19.700 | 4.912 | 11.442 |
| string: silesia/xml | 1090118 | 10356.4 ± 1.0% | 3128.2 ± 2.6% | 2629.5 ± 1.2% | 604.8 ± 1.5% | 1967.1 ± 1.3% | 962.9 ± 1.6% | 3.311 | 3.939 | 17.124 | 5.265 | 10.755 |
| string: canterbury/alice29.txt | 159425 | 12500.6 ± 7.0% | 2856.2 ± 1.2% | 3156.2 ± 2.7% | 318.1 ± 1.9% | 1547.1 ± 1.2% | 1092.4 ± 1.7% | 4.377 | 3.961 | 39.296 | 8.080 | 11.443 |
| string: canterbury/asyoulik.txt | 132198 | 10506.9 ± 4.3% | 2095.6 ± 1.6% | 3132.5 ± 1.1% | 317.5 ± 1.0% | 1367.7 ± 0.9% | 958.0 ± 0.7% | 5.014 | 3.354 | 33.093 | 7.682 | 10.967 |
| string: canterbury/lcet10.txt | 441884 | 11949.7 ± 1.4% | 3083.2 ± 0.4% | 2635.1 ± 0.7% | 364.5 ± 2.0% | 1668.1 ± 0.6% | 1193.6 ± 1.2% | 3.876 | 4.535 | 32.781 | 7.163 | 10.011 |
| string: canterbury/plrabn12.txt | 503330 | 8252.8 ± 1.9% | 2307.8 ± 1.0% | 2164.8 ± 1.0% | 345.2 ± 0.6% | 1619.7 ± 1.8% | 1117.0 ± 1.6% | 3.576 | 3.812 | 23.910 | 5.095 | 7.389 |
| string: canterbury-large/E.coli | 1048578 | 33959.2 ± 1.5% | 15989.2 ± 1.1% | 3470.5 ± 0.5% | 1685.4 ± 0.5% | 3159.3 ± 0.4% | 1407.7 ± 1.0% | 2.124 | 9.785 | 20.149 | 10.749 | 24.123 |
| string: canterbury-large/bible.txt | 1055886 | 9346.0 ± 0.7% | 4844.4 ± 1.7% | 3026.7 ± 0.5% | 400.9 ± 0.7% | 2133.8 ± 0.9% | 1486.2 ± 0.8% | 1.929 | 3.088 | 23.310 | 4.380 | 6.288 |
| string: canterbury-large/world192.txt | 1103121 | 6582.9 ± 1.9% | 1726.6 ± 1.4% | 1999.2 ± 1.2% | 346.9 ± 1.3% | 1382.2 ± 0.3% | 953.0 ± 5.2% | 3.813 | 3.293 | 18.976 | 4.762 | 6.907 |
| string: http/html-1m | 1058582 | 10057.7 ± 0.9% | 4356.2 ± 1.3% | 2920.3 ± 3.2% | 418.9 ± 0.8% | 2156.5 ± 1.0% | 848.0 ± 0.8% | 2.309 | 3.444 | 24.009 | 4.664 | 11.860 |
| string: http/json-1m | 1190272 | 8342.6 ± 0.8% | 1576.9 ± 1.2% | 1960.1 ± 1.2% | 554.9 ± 0.7% | 1183.8 ± 1.1% | 842.4 ± 7.5% | 5.291 | 4.256 | 15.035 | 7.048 | 9.903 |
| string: http/js-1m | 1144362 | 6508.7 ± 0.8% | 1120.3 ± 1.1% | 1526.6 ± 3.0% | 332.3 ± 0.5% | 1114.4 ± 0.6% | 758.3 ± 2.9% | 5.810 | 4.264 | 19.584 | 5.841 | 8.583 |
| string: http/css-1m | 1097820 | 8995.7 ± 1.1% | 1484.4 ± 0.7% | 2374.7 ± 0.4% | 509.3 ± 0.5% | 1269.6 ± 0.5% | 877.9 ± 0.8% | 6.060 | 3.788 | 17.663 | 7.086 | 10.247 |
| string: dickens as Cyrillic and CJK | 1883069 | 5445.9 ± 0.7% | 3619.1 ± 2.2% | 498.5 ± 2.0% | 245.7 ± 0.8% | 448.9 ± 0.9% | 355.6 ± 0.4% | 1.505 | 10.925 | 22.168 | 12.131 | 15.314 |
| hex: silesia/dickens | 524290 | 42900.6 ± 4.8% | 2559.2 ± 0.7% | 1502.0 ± 0.4% | 459.2 ± 0.3% | 1538.0 ± 0.5% | 1060.0 ± 3.3% | 16.763 | 28.562 | 93.421 | 27.893 | 40.473 |
| hex: silesia/mozilla | 524290 | 43599.7 ± 0.4% | 2583.4 ± 0.8% | 1505.1 ± 0.5% | 387.6 ± 2.9% | 1567.8 ± 0.3% | 1062.4 ± 0.9% | 16.877 | 28.968 | 112.480 | 27.809 | 41.040 |
| hex: silesia/mr | 524290 | 43429.2 ± 3.9% | 2563.6 ± 1.0% | 1503.7 ± 0.8% | 594.2 ± 0.7% | 1536.5 ± 0.4% | 1066.2 ± 0.6% | 16.941 | 28.881 | 73.090 | 28.264 | 40.733 |
| hex: silesia/nci | 524290 | 43266.5 ± 8.0% | 2549.6 ± 0.9% | 1499.1 ± 1.1% | 754.9 ± 0.2% | 1552.7 ± 0.4% | 1059.5 ± 0.9% | 16.970 | 28.861 | 57.317 | 27.866 | 40.839 |
| hex: silesia/ooffice | 524290 | 42588.9 ± 1.0% | 2588.1 ± 1.2% | 1506.2 ± 0.9% | 320.7 ± 2.8% | 1536.6 ± 6.3% | 1061.9 ± 1.1% | 16.456 | 28.275 | 132.801 | 27.717 | 40.108 |
| hex: silesia/osdb | 524290 | 43279.1 ± 1.2% | 2558.2 ± 0.3% | 1503.1 ± 0.2% | 428.5 ± 0.4% | 1565.5 ± 0.8% | 1058.9 ± 0.9% | 16.917 | 28.794 | 101.012 | 27.645 | 40.871 |
| hex: silesia/reymont | 524290 | 43196.1 ± 2.0% | 2568.4 ± 1.3% | 1504.0 ± 0.8% | 479.3 ± 1.0% | 1536.6 ± 0.7% | 1062.2 ± 0.5% | 16.818 | 28.720 | 90.116 | 28.111 | 40.666 |
| hex: silesia/samba | 524290 | 43642.7 ± 1.4% | 2594.3 ± 0.9% | 1509.2 ± 0.6% | 336.4 ± 1.4% | 1568.0 ± 1.5% | 1068.8 ± 0.4% | 16.823 | 28.919 | 129.747 | 27.833 | 40.832 |
| hex: silesia/sao | 524290 | 43749.6 ± 0.1% | 2581.4 ± 0.2% | 1516.8 ± 0.2% | 271.9 ± 0.6% | 1575.1 ± 0.1% | 1068.5 ± 0.1% | 16.948 | 28.844 | 160.874 | 27.776 | 40.944 |
| hex: silesia/webster | 524290 | 44062.7 ± 0.3% | 2594.9 ± 0.4% | 1511.3 ± 0.2% | 437.3 ± 0.6% | 1577.0 ± 0.1% | 1067.4 ± 0.3% | 16.980 | 29.156 | 100.765 | 27.941 | 41.279 |
| hex: silesia/x-ray | 524290 | 43534.5 ± 0.7% | 2584.4 ± 1.6% | 1507.1 ± 0.9% | 422.3 ± 0.5% | 1566.8 ± 0.5% | 1065.6 ± 0.5% | 16.845 | 28.886 | 103.090 | 27.786 | 40.853 |
| hex: silesia/xml | 524290 | 43164.0 ± 1.7% | 2571.5 ± 1.5% | 1506.5 ± 5.3% | 686.2 ± 1.4% | 1556.2 ± 3.7% | 1062.2 ± 0.8% | 16.785 | 28.652 | 62.907 | 27.737 | 40.638 |
| hex: canterbury/alice29.txt | 304180 | 43605.6 ± 0.6% | 2612.1 ± 0.3% | 1532.9 ± 0.5% | 470.0 ± 0.7% | 1588.4 ± 0.4% | 1088.1 ± 0.2% | 16.694 | 28.447 | 92.788 | 27.453 | 40.073 |
| hex: canterbury/asyoulik.txt | 250360 | 43098.0 ± 0.1% | 2607.6 ± 0.3% | 1544.5 ± 0.5% | 457.3 ± 0.4% | 1587.4 ± 1.0% | 1088.3 ± 0.3% | 16.528 | 27.904 | 94.236 | 27.150 | 39.602 |
| hex: canterbury/cp.html | 49208 | 42601.2 ± 0.3% | 2585.8 ± 0.7% | 1534.0 ± 0.4% | 481.6 ± 0.4% | 1585.2 ± 7.4% | 1092.4 ± 0.1% | 16.475 | 27.772 | 88.452 | 26.874 | 38.998 |
| hex: canterbury/fields.c | 22302 | 42126.4 ± 1.4% | 2641.9 ± 0.9% | 1550.9 ± 1.2% | 600.5 ± 3.6% | 1602.2 ± 0.4% | 1098.7 ± 3.1% | 15.946 | 27.162 | 70.156 | 26.293 | 38.343 |
| hex: canterbury/grammar.lsp | 7444 | 39220.7 ± 0.3% | 2662.2 ± 1.6% | 1563.0 ± 0.6% | 813.8 ± 0.6% | 1598.7 ± 0.4% | 1104.1 ± 0.6% | 14.732 | 25.094 | 48.192 | 24.532 | 35.524 |
| hex: canterbury/kennedy.xls | 524290 | 43550.9 ± 0.3% | 2567.7 ± 0.4% | 1507.8 ± 0.4% | 778.3 ± 0.8% | 1521.9 ± 0.8% | 1067.0 ± 0.8% | 16.961 | 28.884 | 55.959 | 28.615 | 40.818 |
| hex: canterbury/lcet10.txt | 524290 | 43584.5 ± 0.3% | 2594.1 ± 0.5% | 1512.9 ± 0.5% | 468.9 ± 0.3% | 1567.4 ± 0.4% | 1064.6 ± 0.7% | 16.801 | 28.808 | 92.949 | 27.807 | 40.941 |
| hex: canterbury/plrabn12.txt | 524290 | 42614.4 ± 0.2% | 2580.4 ± 0.6% | 1511.9 ± 0.4% | 450.8 ± 0.4% | 1525.6 ± 4.8% | 1068.3 ± 4.7% | 16.515 | 28.185 | 94.529 | 27.934 | 39.890 |
| hex: canterbury/ptt5 | 524290 | 43530.7 ± 0.4% | 2570.8 ± 5.2% | 1504.0 ± 0.2% | 592.6 ± 0.7% | 1549.1 ± 0.3% | 1064.6 ± 0.6% | 16.933 | 28.942 | 73.455 | 28.101 | 40.890 |
| hex: canterbury/sum | 76482 | 42896.9 ± 0.7% | 2587.7 ± 0.6% | 1527.3 ± 0.1% | 562.4 ± 3.0% | 1580.2 ± 0.4% | 1090.8 ± 0.1% | 16.577 | 28.086 | 76.273 | 27.147 | 39.325 |
| hex: canterbury/xargs.1 | 8456 | 40292.2 ± 0.2% | 2672.4 ± 0.1% | 1566.3 ± 0.7% | 840.5 ± 3.6% | 1604.5 ± 0.1% | 1111.0 ± 0.3% | 15.077 | 25.724 | 47.941 | 25.113 | 36.267 |
| hex: canterbury-large/E.coli | 524290 | 43544.7 ± 0.1% | 2574.2 ± 0.3% | 1512.2 ± 0.2% | 818.5 ± 0.2% | 1571.8 ± 0.1% | 1070.9 ± 0.1% | 16.916 | 28.795 | 53.202 | 27.704 | 40.661 |
| hex: canterbury-large/bible.txt | 524290 | 43728.0 ± 0.1% | 2595.8 ± 0.4% | 1516.8 ± 0.1% | 483.1 ± 0.2% | 1573.3 ± 0.1% | 1067.9 ± 0.3% | 16.846 | 28.829 | 90.511 | 27.793 | 40.948 |
| hex: canterbury-large/world192.txt | 524290 | 43633.1 ± 0.4% | 2580.5 ± 0.7% | 1511.6 ± 0.4% | 459.4 ± 0.2% | 1557.5 ± 0.2% | 1066.7 ± 0.2% | 16.909 | 28.865 | 94.979 | 28.014 | 40.905 |
| hex: http/html-1kx1024 | 2099200 | 20471.0 ± 0.3% | 2348.8 ± 2.3% | 1479.0 ± 0.7% | 500.2 ± 4.8% | 1494.5 ± 1.4% | 1077.5 ± 2.3% | 8.716 | 13.841 | 40.927 | 13.698 | 18.998 |
| hex: http/html-16kx64 | 2097280 | 21306.1 ± 0.4% | 2231.2 ± 0.6% | 1460.5 ± 0.9% | 504.3 ± 0.4% | 1445.7 ± 0.3% | 1085.3 ± 0.5% | 9.549 | 14.588 | 42.245 | 14.737 | 19.632 |
| hex: http/html-1m | 524290 | 43551.2 ± 3.6% | 2582.2 ± 0.4% | 1507.9 ± 0.7% | 482.8 ± 0.4% | 1488.1 ± 0.4% | 1064.6 ± 0.2% | 16.866 | 28.881 | 90.205 | 29.267 | 40.908 |
| hex: http/json-1kx1024 | 2099200 | 20329.6 ± 0.4% | 2336.4 ± 1.8% | 1475.2 ± 0.6% | 695.1 ± 1.1% | 1485.6 ± 0.9% | 1078.5 ± 0.8% | 8.701 | 13.781 | 29.248 | 13.685 | 18.850 |
| hex: http/json-16kx64 | 2097280 | 21678.6 ± 0.4% | 2219.4 ± 0.5% | 1452.3 ± 0.5% | 704.8 ± 0.6% | 1436.7 ± 4.9% | 1082.8 ± 1.0% | 9.768 | 14.927 | 30.759 | 15.089 | 20.021 |
| hex: http/json-1m | 524290 | 43399.4 ± 0.2% | 2588.0 ± 0.2% | 1508.6 ± 0.6% | 734.6 ± 4.5% | 1555.8 ± 0.7% | 1068.2 ± 0.3% | 16.770 | 28.768 | 59.079 | 27.894 | 40.628 |
| hex: http/js-1kx1024 | 2099200 | 20520.4 ± 0.2% | 2359.1 ± 1.9% | 1480.4 ± 0.3% | 490.5 ± 0.1% | 1492.8 ± 1.7% | 1076.5 ± 1.2% | 8.698 | 13.862 | 41.833 | 13.746 | 19.061 |
| hex: http/js-16kx64 | 2097280 | 21896.1 ± 0.3% | 2231.8 ± 0.2% | 1462.5 ± 0.3% | 492.5 ± 0.2% | 1449.2 ± 0.4% | 1087.9 ± 0.4% | 9.811 | 14.971 | 44.461 | 15.109 | 20.127 |
| hex: http/js-1m | 524290 | 43680.0 ± 0.1% | 2586.0 ± 0.4% | 1515.8 ± 0.4% | 507.5 ± 0.6% | 1573.3 ± 0.2% | 1060.0 ± 0.5% | 16.891 | 28.817 | 86.069 | 27.763 | 41.207 |
| hex: http/css-1kx1024 | 2099200 | 22666.7 ± 0.2% | 2346.4 ± 0.9% | 1478.6 ± 1.0% | 557.0 ± 0.4% | 1496.1 ± 1.1% | 1078.2 ± 0.5% | 9.660 | 15.330 | 40.698 | 15.150 | 21.022 |
| hex: http/css-16kx64 | 2097280 | 22602.1 ± 0.1% | 2230.5 ± 0.3% | 1456.7 ± 0.6% | 562.3 ± 4.9% | 1444.3 ± 1.1% | 1084.9 ± 0.4% | 10.133 | 15.516 | 40.193 | 15.649 | 20.833 |
| hex: http/css-1m | 524290 | 43402.8 ± 0.4% | 2585.8 ± 0.7% | 1511.1 ± 0.6% | 538.0 ± 0.4% | 1568.3 ± 6.4% | 1062.9 ± 0.4% | 16.785 | 28.723 | 80.669 | 27.674 | 40.836 |
| hex: shuffled/dickens-1m | 524290 | 43692.4 ± 0.8% | 2598.6 ± 0.2% | 1512.6 ± 0.4% | 463.4 ± 0.5% | 1568.1 ± 6.8% | 1068.3 ± 0.8% | 16.814 | 28.886 | 94.284 | 27.863 | 40.899 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1801.2 ± 0.6% | 1465.7 ± 0.3% | 1014.6 ± 0.9% | 460.2 ± 1.1% | 432.2 ± 2.4% | 498.7 ± 0.6% | 1.229 | 1.775 | 3.914 | 4.168 | 3.612 |
| qlog records, JSON text sequence | 1467503 | 1718.3 ± 0.7% | 1224.0 ± 1.0% | 934.3 ± 1.2% | 431.3 ± 1.2% | 537.2 ± 1.7% | 352.5 ± 1.2% | 1.404 | 1.839 | 3.984 | 3.198 | 4.875 |
| messages: 11 string members | 1025025 | 1333.7 ± 1.0% | 1099.7 ± 0.6% | 744.7 ± 0.8% | 408.8 ± 0.7% | 425.5 ± 1.0% | 431.4 ± 0.7% | 1.213 | 1.791 | 3.262 | 3.135 | 3.092 |
| messages: 50 nested objects | 1121600 | 2005.6 ± 6.4% | 1862.8 ± 4.3% | 1324.0 ± 1.1% | 573.7 ± 0.8% | 613.8 ± 0.9% | 508.1 ± 0.8% | 1.077 | 1.515 | 3.496 | 3.267 | 3.947 |
| string: silesia/dickens | 172528 | 13328.1 ± 2.2% | 3877.8 ± 1.6% | 3096.8 ± 1.8% | 331.8 ± 0.8% | 1707.8 ± 0.9% | 1173.5 ± 1.5% | 3.437 | 4.304 | 40.175 | 7.804 | 11.357 |
| string: silesia/nci | 1075110 | 11468.9 ± 0.4% | 4663.4 ± 1.5% | 3122.6 ± 0.5% | 904.6 ± 0.8% | 1890.4 ± 2.3% | 1187.2 ± 5.2% | 2.459 | 3.673 | 12.678 | 6.067 | 9.661 |
| string: silesia/reymont | 1075159 | 5430.9 ± 0.7% | 1843.6 ± 1.4% | 1999.1 ± 0.5% | 375.2 ± 1.3% | 1422.0 ± 0.5% | 1038.6 ± 0.7% | 2.946 | 2.717 | 14.473 | 3.819 | 5.229 |
| string: silesia/samba | 97582 | 7332.7 ± 4.3% | 2663.4 ± 0.6% | 4069.1 ± 0.4% | 346.5 ± 1.0% | 1325.6 ± 0.5% | 1166.8 ± 1.0% | 2.753 | 1.802 | 21.164 | 5.532 | 6.284 |
| string: silesia/webster | 1098490 | 6981.4 ± 0.5% | 1966.6 ± 2.4% | 1873.0 ± 1.4% | 348.6 ± 0.7% | 1397.9 ± 3.2% | 600.1 ± 0.5% | 3.550 | 3.727 | 20.029 | 4.994 | 11.633 |
| string: silesia/xml | 1090118 | 11273.4 ± 1.9% | 3128.2 ± 2.6% | 2629.5 ± 1.2% | 604.8 ± 1.5% | 1967.1 ± 1.3% | 962.9 ± 1.6% | 3.604 | 4.287 | 18.641 | 5.731 | 11.707 |
| string: canterbury/alice29.txt | 159425 | 13334.5 ± 1.1% | 2856.2 ± 1.2% | 3156.2 ± 2.7% | 318.1 ± 1.9% | 1547.1 ± 1.2% | 1092.4 ± 1.7% | 4.669 | 4.225 | 41.917 | 8.619 | 12.206 |
| string: canterbury/asyoulik.txt | 132198 | 11510.2 ± 0.7% | 2095.6 ± 1.6% | 3132.5 ± 1.1% | 317.5 ± 1.0% | 1367.7 ± 0.9% | 958.0 ± 0.7% | 5.493 | 3.674 | 36.253 | 8.416 | 12.014 |
| string: canterbury/lcet10.txt | 441884 | 12642.4 ± 1.2% | 3083.2 ± 0.4% | 2635.1 ± 0.7% | 364.5 ± 2.0% | 1668.1 ± 0.6% | 1193.6 ± 1.2% | 4.100 | 4.798 | 34.681 | 7.579 | 10.591 |
| string: canterbury/plrabn12.txt | 503330 | 8954.4 ± 2.6% | 2307.8 ± 1.0% | 2164.8 ± 1.0% | 345.2 ± 0.6% | 1619.7 ± 1.8% | 1117.0 ± 1.6% | 3.880 | 4.136 | 25.943 | 5.528 | 8.017 |
| string: canterbury-large/E.coli | 1048578 | 34073.0 ± 1.0% | 15989.2 ± 1.1% | 3470.5 ± 0.5% | 1685.4 ± 0.5% | 3159.3 ± 0.4% | 1407.7 ± 1.0% | 2.131 | 9.818 | 20.216 | 10.785 | 24.204 |
| string: canterbury-large/bible.txt | 1055886 | 9790.4 ± 0.9% | 4844.4 ± 1.7% | 3026.7 ± 0.5% | 400.9 ± 0.7% | 2133.8 ± 0.9% | 1486.2 ± 0.8% | 2.021 | 3.235 | 24.418 | 4.588 | 6.587 |
| string: canterbury-large/world192.txt | 1103121 | 6450.7 ± 1.1% | 1726.6 ± 1.4% | 1999.2 ± 1.2% | 346.9 ± 1.3% | 1382.2 ± 0.3% | 953.0 ± 5.2% | 3.736 | 3.227 | 18.595 | 4.667 | 6.769 |
| string: http/html-1m | 1058582 | 10173.2 ± 0.3% | 4356.2 ± 1.3% | 2920.3 ± 3.2% | 418.9 ± 0.8% | 2156.5 ± 1.0% | 848.0 ± 0.8% | 2.335 | 3.484 | 24.285 | 4.717 | 11.996 |
| string: http/json-1m | 1190272 | 8501.1 ± 5.7% | 1576.9 ± 1.2% | 1960.1 ± 1.2% | 554.9 ± 0.7% | 1183.8 ± 1.1% | 842.4 ± 7.5% | 5.391 | 4.337 | 15.320 | 7.181 | 10.091 |
| string: http/js-1m | 1144362 | 6643.5 ± 0.8% | 1120.3 ± 1.1% | 1526.6 ± 3.0% | 332.3 ± 0.5% | 1114.4 ± 0.6% | 758.3 ± 2.9% | 5.930 | 4.352 | 19.990 | 5.962 | 8.761 |
| string: http/css-1m | 1097820 | 9352.9 ± 0.9% | 1484.4 ± 0.7% | 2374.7 ± 0.4% | 509.3 ± 0.5% | 1269.6 ± 0.5% | 877.9 ± 0.8% | 6.301 | 3.939 | 18.365 | 7.367 | 10.654 |
| string: dickens as Cyrillic and CJK | 1883069 | 5679.6 ± 0.9% | 3619.1 ± 2.2% | 498.5 ± 2.0% | 245.7 ± 0.8% | 448.9 ± 0.9% | 355.6 ± 0.4% | 1.569 | 11.394 | 23.119 | 12.652 | 15.971 |
| hex: silesia/dickens | 524290 | 43260.8 ± 1.4% | 2559.2 ± 0.7% | 1502.0 ± 0.4% | 459.2 ± 0.3% | 1538.0 ± 0.5% | 1060.0 ± 3.3% | 16.904 | 28.802 | 94.206 | 28.128 | 40.813 |
| hex: silesia/mozilla | 524290 | 43571.4 ± 3.2% | 2583.4 ± 0.8% | 1505.1 ± 0.5% | 387.6 ± 2.9% | 1567.8 ± 0.3% | 1062.4 ± 0.9% | 16.866 | 28.950 | 112.407 | 27.791 | 41.014 |
| hex: silesia/mr | 524290 | 43407.5 ± 1.0% | 2563.6 ± 1.0% | 1503.7 ± 0.8% | 594.2 ± 0.7% | 1536.5 ± 0.4% | 1066.2 ± 0.6% | 16.932 | 28.867 | 73.054 | 28.250 | 40.712 |
| hex: silesia/nci | 524290 | 43373.5 ± 2.0% | 2549.6 ± 0.9% | 1499.1 ± 1.1% | 754.9 ± 0.2% | 1552.7 ± 0.4% | 1059.5 ± 0.9% | 17.012 | 28.932 | 57.459 | 27.935 | 40.940 |
| hex: silesia/ooffice | 524290 | 42725.6 ± 0.8% | 2588.1 ± 1.2% | 1506.2 ± 0.9% | 320.7 ± 2.8% | 1536.6 ± 6.3% | 1061.9 ± 1.1% | 16.508 | 28.366 | 133.227 | 27.806 | 40.236 |
| hex: silesia/osdb | 524290 | 43262.2 ± 2.1% | 2558.2 ± 0.3% | 1503.1 ± 0.2% | 428.5 ± 0.4% | 1565.5 ± 0.8% | 1058.9 ± 0.9% | 16.911 | 28.783 | 100.973 | 27.635 | 40.855 |
| hex: silesia/reymont | 524290 | 42754.5 ± 7.0% | 2568.4 ± 1.3% | 1504.0 ± 0.8% | 479.3 ± 1.0% | 1536.6 ± 0.7% | 1062.2 ± 0.5% | 16.646 | 28.426 | 89.195 | 27.824 | 40.250 |
| hex: silesia/samba | 524290 | 43626.1 ± 0.8% | 2594.3 ± 0.9% | 1509.2 ± 0.6% | 336.4 ± 1.4% | 1568.0 ± 1.5% | 1068.8 ± 0.4% | 16.816 | 28.908 | 129.697 | 27.823 | 40.817 |
| hex: silesia/sao | 524290 | 43657.1 ± 5.9% | 2581.4 ± 0.2% | 1516.8 ± 0.2% | 271.9 ± 0.6% | 1575.1 ± 0.1% | 1068.5 ± 0.1% | 16.912 | 28.783 | 160.534 | 27.718 | 40.857 |
| hex: silesia/webster | 524290 | 44087.2 ± 0.1% | 2594.9 ± 0.4% | 1511.3 ± 0.2% | 437.3 ± 0.6% | 1577.0 ± 0.1% | 1067.4 ± 0.3% | 16.990 | 29.172 | 100.821 | 27.957 | 41.302 |
| hex: silesia/x-ray | 524290 | 43475.2 ± 2.6% | 2584.4 ± 1.6% | 1507.1 ± 0.9% | 422.3 ± 0.5% | 1566.8 ± 0.5% | 1065.6 ± 0.5% | 16.822 | 28.847 | 102.949 | 27.748 | 40.798 |
| hex: silesia/xml | 524290 | 43063.5 ± 1.5% | 2571.5 ± 1.5% | 1506.5 ± 5.3% | 686.2 ± 1.4% | 1556.2 ± 3.7% | 1062.2 ± 0.8% | 16.746 | 28.586 | 62.761 | 27.672 | 40.543 |
| hex: canterbury/alice29.txt | 304180 | 43753.8 ± 7.3% | 2612.1 ± 0.3% | 1532.9 ± 0.5% | 470.0 ± 0.7% | 1588.4 ± 0.4% | 1088.1 ± 0.2% | 16.750 | 28.544 | 93.103 | 27.546 | 40.209 |
| hex: canterbury/asyoulik.txt | 250360 | 43029.8 ± 1.1% | 2607.6 ± 0.3% | 1544.5 ± 0.5% | 457.3 ± 0.4% | 1587.4 ± 1.0% | 1088.3 ± 0.3% | 16.502 | 27.860 | 94.087 | 27.107 | 39.539 |
| hex: canterbury/cp.html | 49208 | 42645.4 ± 0.4% | 2585.8 ± 0.7% | 1534.0 ± 0.4% | 481.6 ± 0.4% | 1585.2 ± 7.4% | 1092.4 ± 0.1% | 16.492 | 27.801 | 88.544 | 26.902 | 39.039 |
| hex: canterbury/fields.c | 22302 | 42311.0 ± 0.5% | 2641.9 ± 0.9% | 1550.9 ± 1.2% | 600.5 ± 3.6% | 1602.2 ± 0.4% | 1098.7 ± 3.1% | 16.015 | 27.281 | 70.463 | 26.409 | 38.511 |
| hex: canterbury/grammar.lsp | 7444 | 39917.7 ± 0.9% | 2662.2 ± 1.6% | 1563.0 ± 0.6% | 813.8 ± 0.6% | 1598.7 ± 0.4% | 1104.1 ± 0.6% | 14.994 | 25.540 | 49.049 | 24.968 | 36.155 |
| hex: canterbury/kennedy.xls | 524290 | 43676.1 ± 0.8% | 2567.7 ± 0.4% | 1507.8 ± 0.4% | 778.3 ± 0.8% | 1521.9 ± 0.8% | 1067.0 ± 0.8% | 17.010 | 28.967 | 56.120 | 28.698 | 40.935 |
| hex: canterbury/lcet10.txt | 524290 | 41771.9 ± 7.8% | 2594.1 ± 0.5% | 1512.9 ± 0.5% | 468.9 ± 0.3% | 1567.4 ± 0.4% | 1064.6 ± 0.7% | 16.103 | 27.610 | 89.084 | 26.651 | 39.238 |
| hex: canterbury/plrabn12.txt | 524290 | 42525.3 ± 0.7% | 2580.4 ± 0.6% | 1511.9 ± 0.4% | 450.8 ± 0.4% | 1525.6 ± 4.8% | 1068.3 ± 4.7% | 16.480 | 28.126 | 94.332 | 27.875 | 39.806 |
| hex: canterbury/ptt5 | 524290 | 43696.5 ± 0.2% | 2570.8 ± 5.2% | 1504.0 ± 0.2% | 592.6 ± 0.7% | 1549.1 ± 0.3% | 1064.6 ± 0.6% | 16.997 | 29.053 | 73.735 | 28.208 | 41.046 |
| hex: canterbury/sum | 76482 | 42813.4 ± 6.9% | 2587.7 ± 0.6% | 1527.3 ± 0.1% | 562.4 ± 3.0% | 1580.2 ± 0.4% | 1090.8 ± 0.1% | 16.545 | 28.032 | 76.125 | 27.094 | 39.248 |
| hex: canterbury/xargs.1 | 8456 | 40455.7 ± 7.7% | 2672.4 ± 0.1% | 1566.3 ± 0.7% | 840.5 ± 3.6% | 1604.5 ± 0.1% | 1111.0 ± 0.3% | 15.138 | 25.828 | 48.136 | 25.215 | 36.414 |
| hex: canterbury-large/E.coli | 524290 | 43562.6 ± 0.2% | 2574.2 ± 0.3% | 1512.2 ± 0.2% | 818.5 ± 0.2% | 1571.8 ± 0.1% | 1070.9 ± 0.1% | 16.923 | 28.807 | 53.224 | 27.715 | 40.678 |
| hex: canterbury-large/bible.txt | 524290 | 43737.2 ± 0.5% | 2595.8 ± 0.4% | 1516.8 ± 0.1% | 483.1 ± 0.2% | 1573.3 ± 0.1% | 1067.9 ± 0.3% | 16.849 | 28.835 | 90.531 | 27.799 | 40.957 |
| hex: canterbury-large/world192.txt | 524290 | 43691.6 ± 0.6% | 2580.5 ± 0.7% | 1511.6 ± 0.4% | 459.4 ± 0.2% | 1557.5 ± 0.2% | 1066.7 ± 0.2% | 16.931 | 28.904 | 95.106 | 28.052 | 40.960 |
| hex: http/html-1kx1024 | 2099200 | 20574.0 ± 0.4% | 2348.8 ± 2.3% | 1479.0 ± 0.7% | 500.2 ± 4.8% | 1494.5 ± 1.4% | 1077.5 ± 2.3% | 8.760 | 13.911 | 41.133 | 13.767 | 19.094 |
| hex: http/html-16kx64 | 2097280 | 21385.5 ± 0.2% | 2231.2 ± 0.6% | 1460.5 ± 0.9% | 504.3 ± 0.4% | 1445.7 ± 0.3% | 1085.3 ± 0.5% | 9.585 | 14.643 | 42.403 | 14.792 | 19.705 |
| hex: http/html-1m | 524290 | 43674.3 ± 0.4% | 2582.2 ± 0.4% | 1507.9 ± 0.7% | 482.8 ± 0.4% | 1488.1 ± 0.4% | 1064.6 ± 0.2% | 16.914 | 28.963 | 90.460 | 29.350 | 41.023 |
| hex: http/json-1kx1024 | 2099200 | 20429.4 ± 0.3% | 2336.4 ± 1.8% | 1475.2 ± 0.6% | 695.1 ± 1.1% | 1485.6 ± 0.9% | 1078.5 ± 0.8% | 8.744 | 13.848 | 29.392 | 13.752 | 18.942 |
| hex: http/json-16kx64 | 2097280 | 21746.9 ± 0.2% | 2219.4 ± 0.5% | 1452.3 ± 0.5% | 704.8 ± 0.6% | 1436.7 ± 4.9% | 1082.8 ± 1.0% | 9.799 | 14.974 | 30.856 | 15.136 | 20.085 |
| hex: http/json-1m | 524290 | 43439.5 ± 0.2% | 2588.0 ± 0.2% | 1508.6 ± 0.6% | 734.6 ± 4.5% | 1555.8 ± 0.7% | 1068.2 ± 0.3% | 16.785 | 28.795 | 59.134 | 27.920 | 40.666 |
| hex: http/js-1kx1024 | 2099200 | 20645.7 ± 0.5% | 2359.1 ± 1.9% | 1480.4 ± 0.3% | 490.5 ± 0.1% | 1492.8 ± 1.7% | 1076.5 ± 1.2% | 8.751 | 13.946 | 42.089 | 13.830 | 19.178 |
| hex: http/js-16kx64 | 2097280 | 21914.9 ± 0.4% | 2231.8 ± 0.2% | 1462.5 ± 0.3% | 492.5 ± 0.2% | 1449.2 ± 0.4% | 1087.9 ± 0.4% | 9.820 | 14.984 | 44.500 | 15.122 | 20.145 |
| hex: http/js-1m | 524290 | 43728.9 ± 0.1% | 2586.0 ± 0.4% | 1515.8 ± 0.4% | 507.5 ± 0.6% | 1573.3 ± 0.2% | 1060.0 ± 0.5% | 16.910 | 28.849 | 86.166 | 27.794 | 41.253 |
| hex: http/css-1kx1024 | 2099200 | 22770.3 ± 0.4% | 2346.4 ± 0.9% | 1478.6 ± 1.0% | 557.0 ± 0.4% | 1496.1 ± 1.1% | 1078.2 ± 0.5% | 9.705 | 15.400 | 40.884 | 15.220 | 21.118 |
| hex: http/css-16kx64 | 2097280 | 22638.9 ± 0.2% | 2230.5 ± 0.3% | 1456.7 ± 0.6% | 562.3 ± 4.9% | 1444.3 ± 1.1% | 1084.9 ± 0.4% | 10.150 | 15.542 | 40.258 | 15.675 | 20.867 |
| hex: http/css-1m | 524290 | 43430.7 ± 1.2% | 2585.8 ± 0.7% | 1511.1 ± 0.6% | 538.0 ± 0.4% | 1568.3 ± 6.4% | 1062.9 ± 0.4% | 16.796 | 28.742 | 80.721 | 27.692 | 40.862 |
| hex: shuffled/dickens-1m | 524290 | 43676.7 ± 0.5% | 2598.6 ± 0.2% | 1512.6 ± 0.4% | 463.4 ± 0.5% | 1568.1 ± 6.8% | 1068.3 ± 0.8% | 16.808 | 28.876 | 94.250 | 27.853 | 40.884 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1146.8 ± 0.5% | 1525.4 ± 0.9% | 1105.8 ± 0.4% | 392.1 ± 0.7% | 657.4 ± 0.3% | 363.2 ± 1.6% | 0.752 | 1.037 | 2.924 | 1.744 | 3.157 |
| qlog records, JSON text sequence | 1467503 | 1017.3 ± 2.4% | 1230.6 ± 1.3% | 1104.8 ± 3.9% | 330.0 ± 0.9% | 735.2 ± 0.2% | 306.9 ± 0.7% | 0.827 | 0.921 | 3.083 | 1.384 | 3.315 |
| messages: 11 string members | 1025025 | 956.4 ± 0.6% | 2014.4 ± 4.4% | 760.5 ± 0.6% | 334.3 ± 2.0% | 498.0 ± 0.7% | 293.0 ± 1.2% | 0.475 | 1.258 | 2.861 | 1.921 | 3.264 |
| messages: 50 nested objects | 1121600 | 1230.4 ± 0.4% | 1740.3 ± 3.1% | 1428.3 ± 0.8% | 427.0 ± 1.1% | 897.5 ± 0.6% | 416.8 ± 3.2% | 0.707 | 0.861 | 2.881 | 1.371 | 2.952 |
| string: silesia/dickens | 172528 | 6664.1 ± 0.4% | 3403.1 ± 1.7% | 2818.2 ± 0.9% | 315.3 ± 1.0% | 3357.1 ± 1.9% | 564.7 ± 2.6% | 1.958 | 2.365 | 21.134 | 1.985 | 11.802 |
| string: silesia/nci | 1075110 | 5421.2 ± 0.7% | 3892.8 ± 2.3% | 2989.5 ± 1.3% | 649.0 ± 0.3% | 3659.1 ± 0.9% | 544.2 ± 1.3% | 1.393 | 1.813 | 8.353 | 1.482 | 9.962 |
| string: silesia/reymont | 1075159 | 3455.6 ± 2.1% | 3402.3 ± 0.5% | 1971.1 ± 2.6% | 339.0 ± 0.8% | 2078.3 ± 0.9% | 469.3 ± 2.8% | 1.016 | 1.753 | 10.192 | 1.663 | 7.364 |
| string: silesia/samba | 97582 | 3971.7 ± 0.8% | 3772.8 ± 0.2% | 3094.2 ± 0.7% | 325.6 ± 0.9% | 2036.9 ± 7.1% | 414.4 ± 0.7% | 1.053 | 1.284 | 12.197 | 1.950 | 9.584 |
| string: silesia/webster | 1098490 | 4409.1 ± 1.2% | 2435.5 ± 0.4% | 1735.4 ± 3.1% | 308.4 ± 0.6% | 2115.1 ± 1.2% | 443.1 ± 1.1% | 1.810 | 2.541 | 14.297 | 2.085 | 9.951 |
| string: silesia/xml | 1090118 | 6040.6 ± 0.3% | 5021.8 ± 1.1% | 2485.5 ± 0.9% | 505.8 ± 0.7% | 3364.9 ± 1.0% | 517.4 ± 2.7% | 1.203 | 2.430 | 11.944 | 1.795 | 11.675 |
| string: canterbury/alice29.txt | 159425 | 5700.6 ± 1.8% | 2745.2 ± 2.0% | 2848.3 ± 1.7% | 298.3 ± 0.9% | 3022.5 ± 1.6% | 510.8 ± 1.4% | 2.077 | 2.001 | 19.108 | 1.886 | 11.161 |
| string: canterbury/asyoulik.txt | 132198 | 4248.1 ± 2.0% | 2611.3 ± 1.5% | 2676.1 ± 0.8% | 301.5 ± 1.7% | 2444.1 ± 1.2% | 449.3 ± 1.2% | 1.627 | 1.587 | 14.090 | 1.738 | 9.454 |
| string: canterbury/lcet10.txt | 441884 | 6681.2 ± 0.7% | 3281.6 ± 0.7% | 2353.3 ± 1.5% | 346.9 ± 0.4% | 3029.8 ± 1.7% | 550.9 ± 1.3% | 2.036 | 2.839 | 19.257 | 2.205 | 12.129 |
| string: canterbury/plrabn12.txt | 503330 | 5464.5 ± 1.6% | 3157.0 ± 0.7% | 1858.5 ± 1.8% | 322.2 ± 0.7% | 2874.2 ± 1.5% | 526.9 ± 1.5% | 1.731 | 2.940 | 16.961 | 1.901 | 10.372 |
| string: canterbury-large/E.coli | 1048578 | 33591.7 ± 5.7% | 12909.4 ± 1.2% | 3365.4 ± 1.4% | 1270.9 ± 1.1% | 8888.9 ± 1.3% | 904.6 ± 4.8% | 2.602 | 9.981 | 26.431 | 3.779 | 37.136 |
| string: canterbury-large/bible.txt | 1055886 | 8464.9 ± 2.1% | 5215.7 ± 0.8% | 2797.2 ± 0.8% | 356.0 ± 1.6% | 3854.4 ± 1.2% | 607.8 ± 1.9% | 1.623 | 3.026 | 23.777 | 2.196 | 13.928 |
| string: canterbury-large/world192.txt | 1103121 | 4154.1 ± 0.4% | 2293.3 ± 1.5% | 1806.6 ± 0.9% | 327.5 ± 0.9% | 2178.6 ± 1.0% | 451.9 ± 3.2% | 1.811 | 2.299 | 12.685 | 1.907 | 9.192 |
| string: http/html-1m | 1058582 | 8853.1 ± 2.8% | 4706.4 ± 1.0% | 2717.2 ± 1.7% | 424.7 ± 0.8% | 3559.4 ± 0.5% | 589.2 ± 1.0% | 1.881 | 3.258 | 20.848 | 2.487 | 15.027 |
| string: http/json-1m | 1190272 | 3314.3 ± 0.7% | 1253.3 ± 1.0% | 2120.8 ± 0.7% | 468.7 ± 1.5% | 1357.0 ± 1.6% | 430.5 ± 1.7% | 2.645 | 1.563 | 7.071 | 2.442 | 7.700 |
| string: http/js-1m | 1144362 | 2856.3 ± 1.3% | 1598.9 ± 0.7% | 1321.1 ± 0.8% | 326.7 ± 0.5% | 1407.4 ± 0.3% | 375.4 ± 1.1% | 1.786 | 2.162 | 8.743 | 2.030 | 7.609 |
| string: http/css-1m | 1097820 | 3296.1 ± 1.3% | 2869.0 ± 1.1% | 2278.3 ± 1.3% | 456.6 ± 0.6% | 2120.8 ± 1.1% | 434.2 ± 2.1% | 1.149 | 1.447 | 7.219 | 1.554 | 7.592 |
| string: dickens as Cyrillic and CJK | 1883069 | 5810.7 ± 0.4% | 3405.8 ± 3.1% | 685.1 ± 0.9% | 376.5 ± 1.6% | 494.0 ± 0.9% | 161.0 ± 2.7% | 1.706 | 8.481 | 15.432 | 11.763 | 36.084 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1195.4 ± 1.0% | 1237.4 ± 2.0% | 1099.1 ± 1.0% | 263.6 ± 1.5% | 466.7 ± 0.9% | 222.4 ± 3.4% | 0.966 | 1.088 | 4.535 | 2.561 | 5.374 |
| hex: silesia/dickens | 524290 | 33884.6 ± 0.7% | 15093.6 ± 1.1% | 3563.9 ± 0.6% | 479.5 ± 0.4% | 8978.5 ± 0.8% | 1115.5 ± 6.8% | 2.245 | 9.508 | 70.660 | 3.774 | 30.375 |
| hex: silesia/mozilla | 524290 | 34017.1 ± 0.9% | 15094.3 ± 1.1% | 3489.7 ± 3.1% | 429.4 ± 0.9% | 8951.9 ± 0.8% | 1116.6 ± 5.1% | 2.254 | 9.748 | 79.219 | 3.800 | 30.464 |
| hex: silesia/mr | 524290 | 34044.6 ± 0.3% | 15106.3 ± 4.2% | 3498.2 ± 9.5% | 651.5 ± 0.2% | 8959.9 ± 0.1% | 1112.9 ± 1.9% | 2.254 | 9.732 | 52.254 | 3.800 | 30.591 |
| hex: silesia/nci | 524290 | 34021.9 ± 0.2% | 15120.0 ± 0.7% | 3572.1 ± 2.5% | 761.7 ± 0.8% | 8979.4 ± 0.6% | 1116.5 ± 2.9% | 2.250 | 9.524 | 44.666 | 3.789 | 30.473 |
| hex: silesia/ooffice | 524290 | 33857.9 ± 0.5% | 15043.2 ± 0.9% | 3494.2 ± 1.2% | 342.3 ± 1.2% | 8860.7 ± 1.2% | 1123.5 ± 0.9% | 2.251 | 9.690 | 98.923 | 3.821 | 30.136 |
| hex: silesia/osdb | 524290 | 33764.2 ± 1.4% | 15024.2 ± 1.0% | 3484.3 ± 0.8% | 454.1 ± 0.9% | 8872.9 ± 0.9% | 1123.8 ± 1.5% | 2.247 | 9.690 | 74.346 | 3.805 | 30.045 |
| hex: silesia/reymont | 524290 | 33742.5 ± 0.9% | 15005.6 ± 0.4% | 3526.2 ± 1.0% | 491.0 ± 2.3% | 8903.4 ± 1.1% | 1117.3 ± 2.2% | 2.249 | 9.569 | 68.719 | 3.790 | 30.200 |
| hex: silesia/samba | 524290 | 33753.2 ± 0.7% | 14960.9 ± 0.5% | 3466.0 ± 0.4% | 362.8 ± 0.7% | 8887.7 ± 0.5% | 1112.5 ± 1.1% | 2.256 | 9.738 | 93.041 | 3.798 | 30.341 |
| hex: silesia/sao | 524290 | 33727.7 ± 0.9% | 14933.9 ± 0.5% | 3471.5 ± 1.1% | 278.2 ± 1.1% | 8901.9 ± 0.8% | 1117.0 ± 3.2% | 2.258 | 9.716 | 121.236 | 3.789 | 30.196 |
| hex: silesia/webster | 524290 | 33632.7 ± 0.6% | 14975.6 ± 0.6% | 3529.0 ± 0.4% | 448.3 ± 0.9% | 8887.4 ± 0.7% | 1114.7 ± 1.2% | 2.246 | 9.530 | 75.031 | 3.784 | 30.173 |
| hex: silesia/x-ray | 524290 | 33655.2 ± 1.6% | 15079.1 ± 1.2% | 3479.3 ± 1.2% | 425.0 ± 0.8% | 8936.0 ± 1.0% | 1122.4 ± 1.2% | 2.232 | 9.673 | 79.187 | 3.766 | 29.986 |
| hex: silesia/xml | 524290 | 33702.4 ± 1.1% | 15081.6 ± 0.8% | 3556.3 ± 0.8% | 705.0 ± 0.9% | 8932.6 ± 0.7% | 1123.5 ± 1.0% | 2.235 | 9.477 | 47.807 | 3.773 | 29.997 |
| hex: canterbury/alice29.txt | 304180 | 33886.1 ± 1.1% | 14226.7 ± 0.6% | 3566.4 ± 0.9% | 484.8 ± 0.4% | 8964.5 ± 0.2% | 1144.8 ± 1.4% | 2.382 | 9.501 | 69.892 | 3.780 | 29.599 |
| hex: canterbury/asyoulik.txt | 250360 | 33712.6 ± 0.5% | 15040.7 ± 1.1% | 3476.7 ± 0.6% | 467.4 ± 1.0% | 8871.9 ± 0.5% | 1135.0 ± 1.2% | 2.241 | 9.697 | 72.123 | 3.800 | 29.704 |
| hex: canterbury/cp.html | 49208 | 33346.7 ± 0.7% | 14413.0 ± 0.6% | 3561.3 ± 0.3% | 499.1 ± 0.8% | 9308.2 ± 0.5% | 1110.9 ± 1.8% | 2.314 | 9.364 | 66.815 | 3.583 | 30.017 |
| hex: canterbury/fields.c | 22302 | 32972.8 ± 0.4% | 17648.4 ± 0.5% | 3669.1 ± 0.5% | 525.5 ± 0.4% | 9291.1 ± 0.4% | 1088.5 ± 1.9% | 1.868 | 8.987 | 62.741 | 3.549 | 30.291 |
| hex: canterbury/grammar.lsp | 7444 | 29790.9 ± 1.4% | 17252.7 ± 0.1% | 3594.5 ± 0.4% | 699.9 ± 1.3% | 9019.7 ± 0.4% | 1053.0 ± 6.7% | 1.727 | 8.288 | 42.563 | 3.303 | 28.293 |
| hex: canterbury/kennedy.xls | 524290 | 33878.6 ± 0.8% | 14438.2 ± 1.0% | 3557.9 ± 1.3% | 755.4 ± 1.4% | 8952.8 ± 1.4% | 1080.0 ± 4.4% | 2.346 | 9.522 | 44.846 | 3.784 | 31.368 |
| hex: canterbury/lcet10.txt | 524290 | 33747.0 ± 1.1% | 14810.3 ± 1.2% | 3545.4 ± 1.2% | 481.1 ± 1.2% | 8904.2 ± 1.3% | 1087.1 ± 4.8% | 2.279 | 9.519 | 70.150 | 3.790 | 31.043 |
| hex: canterbury/plrabn12.txt | 524290 | 33717.7 ± 0.5% | 14360.8 ± 1.3% | 3537.9 ± 2.0% | 464.6 ± 0.4% | 8882.5 ± 5.5% | 1101.0 ± 4.5% | 2.348 | 9.530 | 72.567 | 3.796 | 30.625 |
| hex: canterbury/ptt5 | 524290 | 33791.4 ± 0.5% | 14838.4 ± 4.1% | 3472.7 ± 0.6% | 660.3 ± 3.6% | 8876.5 ± 1.2% | 1101.6 ± 4.1% | 2.277 | 9.731 | 51.178 | 3.807 | 30.673 |
| hex: canterbury/sum | 76482 | 33105.1 ± 0.5% | 15323.7 ± 0.5% | 3540.4 ± 0.4% | 569.9 ± 1.8% | 8865.7 ± 0.4% | 1116.0 ± 1.4% | 2.160 | 9.351 | 58.087 | 3.734 | 29.665 |
| hex: canterbury/xargs.1 | 8456 | 30139.1 ± 0.7% | 17306.5 ± 0.5% | 3551.5 ± 0.4% | 680.5 ± 1.4% | 8990.7 ± 0.4% | 1085.3 ± 3.4% | 1.741 | 8.486 | 44.289 | 3.352 | 27.771 |
| hex: canterbury-large/E.coli | 524290 | 33742.9 ± 0.7% | 14932.9 ± 1.4% | 3489.3 ± 0.8% | 955.6 ± 0.5% | 8886.5 ± 0.8% | 1069.2 ± 7.2% | 2.260 | 9.671 | 35.312 | 3.797 | 31.560 |
| hex: canterbury-large/bible.txt | 524290 | 33689.3 ± 0.2% | 14947.4 ± 0.4% | 3479.3 ± 0.6% | 498.9 ± 0.5% | 8891.3 ± 0.6% | 1085.0 ± 5.8% | 2.254 | 9.683 | 67.528 | 3.789 | 31.049 |
| hex: canterbury-large/world192.txt | 524290 | 33842.4 ± 0.7% | 15002.6 ± 0.8% | 3541.8 ± 0.6% | 460.5 ± 0.5% | 8916.3 ± 0.5% | 1094.7 ± 3.6% | 2.256 | 9.555 | 73.490 | 3.796 | 30.916 |
| hex: http/html-1kx1024 | 2099200 | 15361.7 ± 0.8% | 12439.6 ± 5.7% | 3157.5 ± 0.6% | 492.7 ± 0.6% | 7760.4 ± 0.6% | 954.1 ± 3.2% | 1.235 | 4.865 | 31.179 | 1.979 | 16.101 |
| hex: http/html-16kx64 | 2097280 | 28072.6 ± 0.5% | 14010.6 ± 0.7% | 3383.8 ± 1.0% | 499.5 ± 0.3% | 8698.4 ± 0.7% | 1037.5 ± 3.8% | 2.004 | 8.296 | 56.197 | 3.227 | 27.057 |
| hex: http/html-1m | 524290 | 33780.5 ± 1.1% | 15049.4 ± 0.9% | 3470.3 ± 0.9% | 497.9 ± 0.7% | 8884.2 ± 1.1% | 1115.3 ± 1.5% | 2.245 | 9.734 | 67.844 | 3.802 | 30.289 |
| hex: http/json-1kx1024 | 2099200 | 15303.9 ± 0.6% | 12098.3 ± 1.1% | 3155.9 ± 0.5% | 652.8 ± 0.9% | 7759.1 ± 0.4% | 947.6 ± 1.5% | 1.265 | 4.849 | 23.444 | 1.972 | 16.151 |
| hex: http/json-16kx64 | 2097280 | 27511.6 ± 1.0% | 13874.8 ± 0.6% | 3383.6 ± 0.4% | 665.8 ± 3.0% | 8495.5 ± 0.7% | 1039.6 ± 3.1% | 1.983 | 8.131 | 41.318 | 3.238 | 26.465 |
| hex: http/json-1m | 524290 | 33726.2 ± 1.1% | 15015.3 ± 1.1% | 3541.8 ± 1.1% | 693.7 ± 1.0% | 8917.8 ± 0.9% | 1071.8 ± 7.5% | 2.246 | 9.522 | 48.621 | 3.782 | 31.466 |
| hex: http/js-1kx1024 | 2099200 | 15497.0 ± 1.1% | 12294.4 ± 2.4% | 3159.0 ± 0.6% | 474.0 ± 0.4% | 7748.7 ± 1.8% | 948.3 ± 3.9% | 1.260 | 4.906 | 32.696 | 2.000 | 16.341 |
| hex: http/js-16kx64 | 2097280 | 27783.7 ± 0.7% | 13960.2 ± 1.2% | 3406.5 ± 0.9% | 482.5 ± 1.2% | 8650.9 ± 4.7% | 1055.8 ± 2.0% | 1.990 | 8.156 | 57.585 | 3.212 | 26.316 |
| hex: http/js-1m | 524290 | 33724.6 ± 1.3% | 15019.2 ± 1.0% | 3544.2 ± 0.9% | 493.3 ± 1.3% | 8903.3 ± 1.2% | 1080.9 ± 3.4% | 2.245 | 9.515 | 68.369 | 3.788 | 31.201 |
| hex: http/css-1kx1024 | 2099200 | 15378.0 ± 0.5% | 12085.5 ± 2.6% | 3164.2 ± 0.6% | 549.1 ± 1.2% | 7767.4 ± 1.0% | 950.2 ± 1.3% | 1.272 | 4.860 | 28.005 | 1.980 | 16.184 |
| hex: http/css-16kx64 | 2097280 | 27807.2 ± 0.5% | 13879.9 ± 0.7% | 3379.0 ± 0.8% | 561.3 ± 0.7% | 8599.5 ± 1.5% | 1046.2 ± 3.1% | 2.003 | 8.229 | 49.542 | 3.234 | 26.580 |
| hex: http/css-1m | 524290 | 33910.9 ± 0.7% | 15076.2 ± 0.8% | 3537.1 ± 3.5% | 543.7 ± 1.4% | 8969.6 ± 1.1% | 1093.4 ± 2.4% | 2.249 | 9.587 | 62.373 | 3.781 | 31.015 |
| hex: shuffled/dickens-1m | 524290 | 33800.8 ± 1.2% | 15062.3 ± 1.2% | 3479.8 ± 1.1% | 474.6 ± 1.4% | 8892.6 ± 0.5% | 1102.5 ± 3.3% | 2.244 | 9.714 | 71.214 | 3.801 | 30.658 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1280.2 ± 0.3% | 1525.4 ± 0.9% | 1105.8 ± 0.4% | 392.1 ± 0.7% | 657.4 ± 0.3% | 363.2 ± 1.6% | 0.839 | 1.158 | 3.265 | 1.947 | 3.525 |
| qlog records, JSON text sequence | 1467503 | 1146.9 ± 0.3% | 1230.6 ± 1.3% | 1104.8 ± 3.9% | 330.0 ± 0.9% | 735.2 ± 0.2% | 306.9 ± 0.7% | 0.932 | 1.038 | 3.475 | 1.560 | 3.737 |
| messages: 11 string members | 1025025 | 1020.3 ± 1.1% | 2014.4 ± 4.4% | 760.5 ± 0.6% | 334.3 ± 2.0% | 498.0 ± 0.7% | 293.0 ± 1.2% | 0.507 | 1.342 | 3.053 | 2.049 | 3.482 |
| messages: 50 nested objects | 1121600 | 1284.0 ± 0.5% | 1740.3 ± 3.1% | 1428.3 ± 0.8% | 427.0 ± 1.1% | 897.5 ± 0.6% | 416.8 ± 3.2% | 0.738 | 0.899 | 3.007 | 1.431 | 3.081 |
| string: silesia/dickens | 172528 | 6667.5 ± 0.8% | 3403.1 ± 1.7% | 2818.2 ± 0.9% | 315.3 ± 1.0% | 3357.1 ± 1.9% | 564.7 ± 2.6% | 1.959 | 2.366 | 21.144 | 1.986 | 11.808 |
| string: silesia/nci | 1075110 | 5404.3 ± 0.7% | 3892.8 ± 2.3% | 2989.5 ± 1.3% | 649.0 ± 0.3% | 3659.1 ± 0.9% | 544.2 ± 1.3% | 1.388 | 1.808 | 8.327 | 1.477 | 9.931 |
| string: silesia/reymont | 1075159 | 3518.0 ± 3.1% | 3402.3 ± 0.5% | 1971.1 ± 2.6% | 339.0 ± 0.8% | 2078.3 ± 0.9% | 469.3 ± 2.8% | 1.034 | 1.785 | 10.377 | 1.693 | 7.497 |
| string: silesia/samba | 97582 | 3984.6 ± 5.3% | 3772.8 ± 0.2% | 3094.2 ± 0.7% | 325.6 ± 0.9% | 2036.9 ± 7.1% | 414.4 ± 0.7% | 1.056 | 1.288 | 12.236 | 1.956 | 9.615 |
| string: silesia/webster | 1098490 | 4440.4 ± 1.5% | 2435.5 ± 0.4% | 1735.4 ± 3.1% | 308.4 ± 0.6% | 2115.1 ± 1.2% | 443.1 ± 1.1% | 1.823 | 2.559 | 14.399 | 2.099 | 10.022 |
| string: silesia/xml | 1090118 | 6068.3 ± 1.2% | 5021.8 ± 1.1% | 2485.5 ± 0.9% | 505.8 ± 0.7% | 3364.9 ± 1.0% | 517.4 ± 2.7% | 1.208 | 2.441 | 11.998 | 1.803 | 11.729 |
| string: canterbury/alice29.txt | 159425 | 5795.2 ± 1.4% | 2745.2 ± 2.0% | 2848.3 ± 1.7% | 298.3 ± 0.9% | 3022.5 ± 1.6% | 510.8 ± 1.4% | 2.111 | 2.035 | 19.425 | 1.917 | 11.346 |
| string: canterbury/asyoulik.txt | 132198 | 4292.4 ± 1.7% | 2611.3 ± 1.5% | 2676.1 ± 0.8% | 301.5 ± 1.7% | 2444.1 ± 1.2% | 449.3 ± 1.2% | 1.644 | 1.604 | 14.236 | 1.756 | 9.553 |
| string: canterbury/lcet10.txt | 441884 | 6692.1 ± 1.4% | 3281.6 ± 0.7% | 2353.3 ± 1.5% | 346.9 ± 0.4% | 3029.8 ± 1.7% | 550.9 ± 1.3% | 2.039 | 2.844 | 19.289 | 2.209 | 12.148 |
| string: canterbury/plrabn12.txt | 503330 | 5490.3 ± 0.9% | 3157.0 ± 0.7% | 1858.5 ± 1.8% | 322.2 ± 0.7% | 2874.2 ± 1.5% | 526.9 ± 1.5% | 1.739 | 2.954 | 17.041 | 1.910 | 10.421 |
| string: canterbury-large/E.coli | 1048578 | 33691.5 ± 1.2% | 12909.4 ± 1.2% | 3365.4 ± 1.4% | 1270.9 ± 1.1% | 8888.9 ± 1.3% | 904.6 ± 4.8% | 2.610 | 10.011 | 26.510 | 3.790 | 37.246 |
| string: canterbury-large/bible.txt | 1055886 | 8575.0 ± 1.7% | 5215.7 ± 0.8% | 2797.2 ± 0.8% | 356.0 ± 1.6% | 3854.4 ± 1.2% | 607.8 ± 1.9% | 1.644 | 3.066 | 24.086 | 2.225 | 14.109 |
| string: canterbury-large/world192.txt | 1103121 | 4183.1 ± 1.0% | 2293.3 ± 1.5% | 1806.6 ± 0.9% | 327.5 ± 0.9% | 2178.6 ± 1.0% | 451.9 ± 3.2% | 1.824 | 2.315 | 12.773 | 1.920 | 9.256 |
| string: http/html-1m | 1058582 | 9517.9 ± 2.3% | 4706.4 ± 1.0% | 2717.2 ± 1.7% | 424.7 ± 0.8% | 3559.4 ± 0.5% | 589.2 ± 1.0% | 2.022 | 3.503 | 22.413 | 2.674 | 16.155 |
| string: http/json-1m | 1190272 | 3302.9 ± 1.6% | 1253.3 ± 1.0% | 2120.8 ± 0.7% | 468.7 ± 1.5% | 1357.0 ± 1.6% | 430.5 ± 1.7% | 2.635 | 1.557 | 7.046 | 2.434 | 7.673 |
| string: http/js-1m | 1144362 | 2877.4 ± 1.2% | 1598.9 ± 0.7% | 1321.1 ± 0.8% | 326.7 ± 0.5% | 1407.4 ± 0.3% | 375.4 ± 1.1% | 1.800 | 2.178 | 8.807 | 2.044 | 7.665 |
| string: http/css-1m | 1097820 | 3310.2 ± 0.9% | 2869.0 ± 1.1% | 2278.3 ± 1.3% | 456.6 ± 0.6% | 2120.8 ± 1.1% | 434.2 ± 2.1% | 1.154 | 1.453 | 7.250 | 1.561 | 7.624 |
| string: dickens as Cyrillic and CJK | 1883069 | 5807.9 ± 2.4% | 3405.8 ± 3.1% | 685.1 ± 0.9% | 376.5 ± 1.6% | 494.0 ± 0.9% | 161.0 ± 2.7% | 1.705 | 8.477 | 15.424 | 11.757 | 36.066 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1211.1 ± 1.0% | 1237.4 ± 2.0% | 1099.1 ± 1.0% | 263.6 ± 1.5% | 466.7 ± 0.9% | 222.4 ± 3.4% | 0.979 | 1.102 | 4.595 | 2.595 | 5.445 |
| hex: silesia/dickens | 524290 | 34043.9 ± 0.4% | 15093.6 ± 1.1% | 3563.9 ± 0.6% | 479.5 ± 0.4% | 8978.5 ± 0.8% | 1115.5 ± 6.8% | 2.256 | 9.552 | 70.993 | 3.792 | 30.518 |
| hex: silesia/mozilla | 524290 | 33920.5 ± 4.3% | 15094.3 ± 1.1% | 3489.7 ± 3.1% | 429.4 ± 0.9% | 8951.9 ± 0.8% | 1116.6 ± 5.1% | 2.247 | 9.720 | 78.994 | 3.789 | 30.377 |
| hex: silesia/mr | 524290 | 34006.3 ± 0.5% | 15106.3 ± 4.2% | 3498.2 ± 9.5% | 651.5 ± 0.2% | 8959.9 ± 0.1% | 1112.9 ± 1.9% | 2.251 | 9.721 | 52.195 | 3.795 | 30.557 |
| hex: silesia/nci | 524290 | 34024.2 ± 0.5% | 15120.0 ± 0.7% | 3572.1 ± 2.5% | 761.7 ± 0.8% | 8979.4 ± 0.6% | 1116.5 ± 2.9% | 2.250 | 9.525 | 44.669 | 3.789 | 30.475 |
| hex: silesia/ooffice | 524290 | 33826.5 ± 1.3% | 15043.2 ± 0.9% | 3494.2 ± 1.2% | 342.3 ± 1.2% | 8860.7 ± 1.2% | 1123.5 ± 0.9% | 2.249 | 9.681 | 98.831 | 3.818 | 30.108 |
| hex: silesia/osdb | 524290 | 33749.8 ± 1.0% | 15024.2 ± 1.0% | 3484.3 ± 0.8% | 454.1 ± 0.9% | 8872.9 ± 0.9% | 1123.8 ± 1.5% | 2.246 | 9.686 | 74.314 | 3.804 | 30.033 |
| hex: silesia/reymont | 524290 | 33655.2 ± 0.8% | 15005.6 ± 0.4% | 3526.2 ± 1.0% | 491.0 ± 2.3% | 8903.4 ± 1.1% | 1117.3 ± 2.2% | 2.243 | 9.544 | 68.541 | 3.780 | 30.122 |
| hex: silesia/samba | 524290 | 33799.5 ± 0.6% | 14960.9 ± 0.5% | 3466.0 ± 0.4% | 362.8 ± 0.7% | 8887.7 ± 0.5% | 1112.5 ± 1.1% | 2.259 | 9.752 | 93.169 | 3.803 | 30.383 |
| hex: silesia/sao | 524290 | 33663.0 ± 0.5% | 14933.9 ± 0.5% | 3471.5 ± 1.1% | 278.2 ± 1.1% | 8901.9 ± 0.8% | 1117.0 ± 3.2% | 2.254 | 9.697 | 121.004 | 3.782 | 30.138 |
| hex: silesia/webster | 524290 | 33684.5 ± 0.7% | 14975.6 ± 0.6% | 3529.0 ± 0.4% | 448.3 ± 0.9% | 8887.4 ± 0.7% | 1114.7 ± 1.2% | 2.249 | 9.545 | 75.146 | 3.790 | 30.219 |
| hex: silesia/x-ray | 524290 | 33746.1 ± 1.2% | 15079.1 ± 1.2% | 3479.3 ± 1.2% | 425.0 ± 0.8% | 8936.0 ± 1.0% | 1122.4 ± 1.2% | 2.238 | 9.699 | 79.401 | 3.776 | 30.067 |
| hex: silesia/xml | 524290 | 33904.3 ± 1.0% | 15081.6 ± 0.8% | 3556.3 ± 0.8% | 705.0 ± 0.9% | 8932.6 ± 0.7% | 1123.5 ± 1.0% | 2.248 | 9.534 | 48.093 | 3.796 | 30.177 |
| hex: canterbury/alice29.txt | 304180 | 33810.6 ± 0.7% | 14226.7 ± 0.6% | 3566.4 ± 0.9% | 484.8 ± 0.4% | 8964.5 ± 0.2% | 1144.8 ± 1.4% | 2.377 | 9.480 | 69.737 | 3.772 | 29.533 |
| hex: canterbury/asyoulik.txt | 250360 | 33692.2 ± 1.0% | 15040.7 ± 1.1% | 3476.7 ± 0.6% | 467.4 ± 1.0% | 8871.9 ± 0.5% | 1135.0 ± 1.2% | 2.240 | 9.691 | 72.080 | 3.798 | 29.686 |
| hex: canterbury/cp.html | 49208 | 33334.2 ± 0.4% | 14413.0 ± 0.6% | 3561.3 ± 0.3% | 499.1 ± 0.8% | 9308.2 ± 0.5% | 1110.9 ± 1.8% | 2.313 | 9.360 | 66.790 | 3.581 | 30.005 |
| hex: canterbury/fields.c | 22302 | 32946.5 ± 0.3% | 17648.4 ± 0.5% | 3669.1 ± 0.5% | 525.5 ± 0.4% | 9291.1 ± 0.4% | 1088.5 ± 1.9% | 1.867 | 8.979 | 62.691 | 3.546 | 30.267 |
| hex: canterbury/grammar.lsp | 7444 | 29784.8 ± 0.5% | 17252.7 ± 0.1% | 3594.5 ± 0.4% | 699.9 ± 1.3% | 9019.7 ± 0.4% | 1053.0 ± 6.7% | 1.726 | 8.286 | 42.554 | 3.302 | 28.287 |
| hex: canterbury/kennedy.xls | 524290 | 33902.6 ± 0.6% | 14438.2 ± 1.0% | 3557.9 ± 1.3% | 755.4 ± 1.4% | 8952.8 ± 1.4% | 1080.0 ± 4.4% | 2.348 | 9.529 | 44.878 | 3.787 | 31.390 |
| hex: canterbury/lcet10.txt | 524290 | 33741.6 ± 1.1% | 14810.3 ± 1.2% | 3545.4 ± 1.2% | 481.1 ± 1.2% | 8904.2 ± 1.3% | 1087.1 ± 4.8% | 2.278 | 9.517 | 70.139 | 3.789 | 31.038 |
| hex: canterbury/plrabn12.txt | 524290 | 33749.0 ± 0.2% | 14360.8 ± 1.3% | 3537.9 ± 2.0% | 464.6 ± 0.4% | 8882.5 ± 5.5% | 1101.0 ± 4.5% | 2.350 | 9.539 | 72.634 | 3.800 | 30.653 |
| hex: canterbury/ptt5 | 524290 | 33717.6 ± 1.0% | 14838.4 ± 4.1% | 3472.7 ± 0.6% | 660.3 ± 3.6% | 8876.5 ± 1.2% | 1101.6 ± 4.1% | 2.272 | 9.709 | 51.066 | 3.799 | 30.606 |
| hex: canterbury/sum | 76482 | 33146.6 ± 0.8% | 15323.7 ± 0.5% | 3540.4 ± 0.4% | 569.9 ± 1.8% | 8865.7 ± 0.4% | 1116.0 ± 1.4% | 2.163 | 9.363 | 58.160 | 3.739 | 29.702 |
| hex: canterbury/xargs.1 | 8456 | 30206.2 ± 0.5% | 17306.5 ± 0.5% | 3551.5 ± 0.4% | 680.5 ± 1.4% | 8990.7 ± 0.4% | 1085.3 ± 3.4% | 1.745 | 8.505 | 44.387 | 3.360 | 27.833 |
| hex: canterbury-large/E.coli | 524290 | 33735.9 ± 0.9% | 14932.9 ± 1.4% | 3489.3 ± 0.8% | 955.6 ± 0.5% | 8886.5 ± 0.8% | 1069.2 ± 7.2% | 2.259 | 9.669 | 35.305 | 3.796 | 31.553 |
| hex: canterbury-large/bible.txt | 524290 | 33679.0 ± 0.5% | 14947.4 ± 0.4% | 3479.3 ± 0.6% | 498.9 ± 0.5% | 8891.3 ± 0.6% | 1085.0 ± 5.8% | 2.253 | 9.680 | 67.508 | 3.788 | 31.039 |
| hex: canterbury-large/world192.txt | 524290 | 33714.3 ± 0.8% | 15002.6 ± 0.8% | 3541.8 ± 0.6% | 460.5 ± 0.5% | 8916.3 ± 0.5% | 1094.7 ± 3.6% | 2.247 | 9.519 | 73.212 | 3.781 | 30.799 |
| hex: http/html-1kx1024 | 2099200 | 15026.8 ± 0.5% | 12439.6 ± 5.7% | 3157.5 ± 0.6% | 492.7 ± 0.6% | 7760.4 ± 0.6% | 954.1 ± 3.2% | 1.208 | 4.759 | 30.500 | 1.936 | 15.750 |
| hex: http/html-16kx64 | 2097280 | 28023.4 ± 0.5% | 14010.6 ± 0.7% | 3383.8 ± 1.0% | 499.5 ± 0.3% | 8698.4 ± 0.7% | 1037.5 ± 3.8% | 2.000 | 8.282 | 56.098 | 3.222 | 27.010 |
| hex: http/html-1m | 524290 | 33833.7 ± 1.1% | 15049.4 ± 0.9% | 3470.3 ± 0.9% | 497.9 ± 0.7% | 8884.2 ± 1.1% | 1115.3 ± 1.5% | 2.248 | 9.750 | 67.951 | 3.808 | 30.337 |
| hex: http/json-1kx1024 | 2099200 | 14999.7 ± 0.6% | 12098.3 ± 1.1% | 3155.9 ± 0.5% | 652.8 ± 0.9% | 7759.1 ± 0.4% | 947.6 ± 1.5% | 1.240 | 4.753 | 22.978 | 1.933 | 15.830 |
| hex: http/json-16kx64 | 2097280 | 27557.3 ± 1.0% | 13874.8 ± 0.6% | 3383.6 ± 0.4% | 665.8 ± 3.0% | 8495.5 ± 0.7% | 1039.6 ± 3.1% | 1.986 | 8.144 | 41.387 | 3.244 | 26.509 |
| hex: http/json-1m | 524290 | 33746.8 ± 1.4% | 15015.3 ± 1.1% | 3541.8 ± 1.1% | 693.7 ± 1.0% | 8917.8 ± 0.9% | 1071.8 ± 7.5% | 2.247 | 9.528 | 48.651 | 3.784 | 31.485 |
| hex: http/js-1kx1024 | 2099200 | 15172.4 ± 2.6% | 12294.4 ± 2.4% | 3159.0 ± 0.6% | 474.0 ± 0.4% | 7748.7 ± 1.8% | 948.3 ± 3.9% | 1.234 | 4.803 | 32.012 | 1.958 | 15.999 |
| hex: http/js-16kx64 | 2097280 | 27810.1 ± 0.8% | 13960.2 ± 1.2% | 3406.5 ± 0.9% | 482.5 ± 1.2% | 8650.9 ± 4.7% | 1055.8 ± 2.0% | 1.992 | 8.164 | 57.640 | 3.215 | 26.341 |
| hex: http/js-1m | 524290 | 33744.9 ± 5.4% | 15019.2 ± 1.0% | 3544.2 ± 0.9% | 493.3 ± 1.3% | 8903.3 ± 1.2% | 1080.9 ± 3.4% | 2.247 | 9.521 | 68.410 | 3.790 | 31.220 |
| hex: http/css-1kx1024 | 2099200 | 15062.4 ± 0.4% | 12085.5 ± 2.6% | 3164.2 ± 0.6% | 549.1 ± 1.2% | 7767.4 ± 1.0% | 950.2 ± 1.3% | 1.246 | 4.760 | 27.430 | 1.939 | 15.852 |
| hex: http/css-16kx64 | 2097280 | 27877.0 ± 0.6% | 13879.9 ± 0.7% | 3379.0 ± 0.8% | 561.3 ± 0.7% | 8599.5 ± 1.5% | 1046.2 ± 3.1% | 2.008 | 8.250 | 49.666 | 3.242 | 26.646 |
| hex: http/css-1m | 524290 | 33840.6 ± 0.7% | 15076.2 ± 0.8% | 3537.1 ± 3.5% | 543.7 ± 1.4% | 8969.6 ± 1.1% | 1093.4 ± 2.4% | 2.245 | 9.567 | 62.244 | 3.773 | 30.951 |
| hex: shuffled/dickens-1m | 524290 | 33810.4 ± 0.8% | 15062.3 ± 1.2% | 3479.8 ± 1.1% | 474.6 ± 1.4% | 8892.6 ± 0.5% | 1102.5 ± 3.3% | 2.245 | 9.716 | 71.234 | 3.802 | 30.666 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1580.0 ± 0.5% | 1465.7 ± 0.3% | 1014.6 ± 0.9% | 460.2 ± 1.1% | 432.2 ± 2.4% | 498.7 ± 0.6% | 1.078 | 1.557 | 3.433 | 3.656 | 3.168 |
| qlog records, JSON text sequence | 1467503 | 1442.0 ± 0.8% | 1224.0 ± 1.0% | 934.3 ± 1.2% | 431.3 ± 1.2% | 537.2 ± 1.7% | 352.5 ± 1.2% | 1.178 | 1.543 | 3.344 | 2.684 | 4.091 |
| messages: 11 string members | 1025025 | 1268.2 ± 0.9% | 1099.7 ± 0.6% | 744.7 ± 0.8% | 408.8 ± 0.7% | 425.5 ± 1.0% | 431.4 ± 0.7% | 1.153 | 1.703 | 3.102 | 2.981 | 2.940 |
| messages: 50 nested objects | 1121600 | 1703.4 ± 0.1% | 1862.8 ± 4.3% | 1324.0 ± 1.1% | 573.7 ± 0.8% | 613.8 ± 0.9% | 508.1 ± 0.8% | 0.914 | 1.287 | 2.969 | 2.775 | 3.352 |
| string: silesia/dickens | 172528 | 13038.4 ± 1.3% | 3877.8 ± 1.6% | 3096.8 ± 1.8% | 331.8 ± 0.8% | 1707.8 ± 0.9% | 1173.5 ± 1.5% | 3.362 | 4.210 | 39.301 | 7.635 | 11.110 |
| string: silesia/nci | 1075110 | 11046.2 ± 0.3% | 4663.4 ± 1.5% | 3122.6 ± 0.5% | 904.6 ± 0.8% | 1890.4 ± 2.3% | 1187.2 ± 5.2% | 2.369 | 3.537 | 12.211 | 5.843 | 9.305 |
| string: silesia/reymont | 1075159 | 5379.9 ± 0.6% | 1843.6 ± 1.4% | 1999.1 ± 0.5% | 375.2 ± 1.3% | 1422.0 ± 0.5% | 1038.6 ± 0.7% | 2.918 | 2.691 | 14.337 | 3.783 | 5.180 |
| string: silesia/samba | 97582 | 6311.8 ± 0.8% | 2663.4 ± 0.6% | 4069.1 ± 0.4% | 346.5 ± 1.0% | 1325.6 ± 0.5% | 1166.8 ± 1.0% | 2.370 | 1.551 | 18.218 | 4.761 | 5.410 |
| string: silesia/webster | 1098490 | 6925.6 ± 1.0% | 1966.6 ± 2.4% | 1873.0 ± 1.4% | 348.6 ± 0.7% | 1397.9 ± 3.2% | 600.1 ± 0.5% | 3.522 | 3.698 | 19.869 | 4.954 | 11.540 |
| string: silesia/xml | 1090118 | 10445.7 ± 1.3% | 3128.2 ± 2.6% | 2629.5 ± 1.2% | 604.8 ± 1.5% | 1967.1 ± 1.3% | 962.9 ± 1.6% | 3.339 | 3.972 | 17.272 | 5.310 | 10.848 |
| string: canterbury/alice29.txt | 159425 | 12586.7 ± 1.8% | 2856.2 ± 1.2% | 3156.2 ± 2.7% | 318.1 ± 1.9% | 1547.1 ± 1.2% | 1092.4 ± 1.7% | 4.407 | 3.988 | 39.567 | 8.136 | 11.522 |
| string: canterbury/asyoulik.txt | 132198 | 10724.2 ± 2.7% | 2095.6 ± 1.6% | 3132.5 ± 1.1% | 317.5 ± 1.0% | 1367.7 ± 0.9% | 958.0 ± 0.7% | 5.118 | 3.424 | 33.777 | 7.841 | 11.194 |
| string: canterbury/lcet10.txt | 441884 | 12103.2 ± 0.9% | 3083.2 ± 0.4% | 2635.1 ± 0.7% | 364.5 ± 2.0% | 1668.1 ± 0.6% | 1193.6 ± 1.2% | 3.926 | 4.593 | 33.202 | 7.256 | 10.140 |
| string: canterbury/plrabn12.txt | 503330 | 8352.0 ± 0.6% | 2307.8 ± 1.0% | 2164.8 ± 1.0% | 345.2 ± 0.6% | 1619.7 ± 1.8% | 1117.0 ± 1.6% | 3.619 | 3.858 | 24.198 | 5.156 | 7.477 |
| string: canterbury-large/E.coli | 1048578 | 34140.8 ± 0.6% | 15989.2 ± 1.1% | 3470.5 ± 0.5% | 1685.4 ± 0.5% | 3159.3 ± 0.4% | 1407.7 ± 1.0% | 2.135 | 9.838 | 20.256 | 10.807 | 24.252 |
| string: canterbury-large/bible.txt | 1055886 | 9353.0 ± 1.0% | 4844.4 ± 1.7% | 3026.7 ± 0.5% | 400.9 ± 0.7% | 2133.8 ± 0.9% | 1486.2 ± 0.8% | 1.931 | 3.090 | 23.327 | 4.383 | 6.293 |
| string: canterbury-large/world192.txt | 1103121 | 6567.3 ± 1.3% | 1726.6 ± 1.4% | 1999.2 ± 1.2% | 346.9 ± 1.3% | 1382.2 ± 0.3% | 953.0 ± 5.2% | 3.804 | 3.285 | 18.931 | 4.751 | 6.891 |
| string: http/html-1m | 1058582 | 10215.4 ± 1.3% | 4356.2 ± 1.3% | 2920.3 ± 3.2% | 418.9 ± 0.8% | 2156.5 ± 1.0% | 848.0 ± 0.8% | 2.345 | 3.498 | 24.385 | 4.737 | 12.046 |
| string: http/json-1m | 1190272 | 8371.3 ± 0.8% | 1576.9 ± 1.2% | 1960.1 ± 1.2% | 554.9 ± 0.7% | 1183.8 ± 1.1% | 842.4 ± 7.5% | 5.309 | 4.271 | 15.086 | 7.072 | 9.937 |
| string: http/js-1m | 1144362 | 6559.0 ± 1.2% | 1120.3 ± 1.1% | 1526.6 ± 3.0% | 332.3 ± 0.5% | 1114.4 ± 0.6% | 758.3 ± 2.9% | 5.855 | 4.297 | 19.736 | 5.886 | 8.649 |
| string: http/css-1m | 1097820 | 8997.0 ± 0.5% | 1484.4 ± 0.7% | 2374.7 ± 0.4% | 509.3 ± 0.5% | 1269.6 ± 0.5% | 877.9 ± 0.8% | 6.061 | 3.789 | 17.666 | 7.087 | 10.248 |
| string: dickens as Cyrillic and CJK | 1883069 | 5447.9 ± 1.2% | 3619.1 ± 2.2% | 498.5 ± 2.0% | 245.7 ± 0.8% | 448.9 ± 0.9% | 355.6 ± 0.4% | 1.505 | 10.929 | 22.176 | 12.135 | 15.320 |
| hex: silesia/dickens | 524290 | 43097.8 ± 1.1% | 2559.2 ± 0.7% | 1502.0 ± 0.4% | 459.2 ± 0.3% | 1538.0 ± 0.5% | 1060.0 ± 3.3% | 16.840 | 28.693 | 93.851 | 28.022 | 40.659 |
| hex: silesia/mozilla | 524290 | 43745.9 ± 1.3% | 2583.4 ± 0.8% | 1505.1 ± 0.5% | 387.6 ± 2.9% | 1567.8 ± 0.3% | 1062.4 ± 0.9% | 16.934 | 29.066 | 112.858 | 27.903 | 41.178 |
| hex: silesia/mr | 524290 | 43509.6 ± 0.4% | 2563.6 ± 1.0% | 1503.7 ± 0.8% | 594.2 ± 0.7% | 1536.5 ± 0.4% | 1066.2 ± 0.6% | 16.972 | 28.934 | 73.226 | 28.317 | 40.808 |
| hex: silesia/nci | 524290 | 43577.5 ± 2.6% | 2549.6 ± 0.9% | 1499.1 ± 1.1% | 754.9 ± 0.2% | 1552.7 ± 0.4% | 1059.5 ± 0.9% | 17.092 | 29.069 | 57.729 | 28.066 | 41.132 |
| hex: silesia/ooffice | 524290 | 42532.5 ± 0.7% | 2588.1 ± 1.2% | 1506.2 ± 0.9% | 320.7 ± 2.8% | 1536.6 ± 6.3% | 1061.9 ± 1.1% | 16.434 | 28.238 | 132.625 | 27.680 | 40.054 |
| hex: silesia/osdb | 524290 | 43387.7 ± 1.5% | 2558.2 ± 0.3% | 1503.1 ± 0.2% | 428.5 ± 0.4% | 1565.5 ± 0.8% | 1058.9 ± 0.9% | 16.960 | 28.866 | 101.266 | 27.715 | 40.973 |
| hex: silesia/reymont | 524290 | 42912.6 ± 1.4% | 2568.4 ± 1.3% | 1504.0 ± 0.8% | 479.3 ± 1.0% | 1536.6 ± 0.7% | 1062.2 ± 0.5% | 16.708 | 28.532 | 89.524 | 27.927 | 40.399 |
| hex: silesia/samba | 524290 | 43701.3 ± 2.1% | 2594.3 ± 0.9% | 1509.2 ± 0.6% | 336.4 ± 1.4% | 1568.0 ± 1.5% | 1068.8 ± 0.4% | 16.845 | 28.957 | 129.921 | 27.870 | 40.887 |
| hex: silesia/sao | 524290 | 43774.4 ± 0.1% | 2581.4 ± 0.2% | 1516.8 ± 0.2% | 271.9 ± 0.6% | 1575.1 ± 0.1% | 1068.5 ± 0.1% | 16.958 | 28.860 | 160.965 | 27.792 | 40.967 |
| hex: silesia/webster | 524290 | 44090.6 ± 0.6% | 2594.9 ± 0.4% | 1511.3 ± 0.2% | 437.3 ± 0.6% | 1577.0 ± 0.1% | 1067.4 ± 0.3% | 16.991 | 29.175 | 100.828 | 27.959 | 41.305 |
| hex: silesia/x-ray | 524290 | 43350.2 ± 1.0% | 2584.4 ± 1.6% | 1507.1 ± 0.9% | 422.3 ± 0.5% | 1566.8 ± 0.5% | 1065.6 ± 0.5% | 16.774 | 28.764 | 102.653 | 27.668 | 40.680 |
| hex: silesia/xml | 524290 | 42897.6 ± 1.7% | 2571.5 ± 1.5% | 1506.5 ± 5.3% | 686.2 ± 1.4% | 1556.2 ± 3.7% | 1062.2 ± 0.8% | 16.682 | 28.476 | 62.519 | 27.565 | 40.387 |
| hex: canterbury/alice29.txt | 304180 | 43713.8 ± 0.5% | 2612.1 ± 0.3% | 1532.9 ± 0.5% | 470.0 ± 0.7% | 1588.4 ± 0.4% | 1088.1 ± 0.2% | 16.735 | 28.518 | 93.018 | 27.521 | 40.173 |
| hex: canterbury/asyoulik.txt | 250360 | 43062.4 ± 0.4% | 2607.6 ± 0.3% | 1544.5 ± 0.5% | 457.3 ± 0.4% | 1587.4 ± 1.0% | 1088.3 ± 0.3% | 16.514 | 27.881 | 94.158 | 27.128 | 39.569 |
| hex: canterbury/cp.html | 49208 | 42647.8 ± 0.3% | 2585.8 ± 0.7% | 1534.0 ± 0.4% | 481.6 ± 0.4% | 1585.2 ± 7.4% | 1092.4 ± 0.1% | 16.493 | 27.802 | 88.549 | 26.904 | 39.041 |
| hex: canterbury/fields.c | 22302 | 42588.7 ± 0.6% | 2641.9 ± 0.9% | 1550.9 ± 1.2% | 600.5 ± 3.6% | 1602.2 ± 0.4% | 1098.7 ± 3.1% | 16.121 | 27.460 | 70.926 | 26.582 | 38.764 |
| hex: canterbury/grammar.lsp | 7444 | 40532.5 ± 1.0% | 2662.2 ± 1.6% | 1563.0 ± 0.6% | 813.8 ± 0.6% | 1598.7 ± 0.4% | 1104.1 ± 0.6% | 15.225 | 25.933 | 49.804 | 25.353 | 36.712 |
| hex: canterbury/kennedy.xls | 524290 | 43675.6 ± 0.4% | 2567.7 ± 0.4% | 1507.8 ± 0.4% | 778.3 ± 0.8% | 1521.9 ± 0.8% | 1067.0 ± 0.8% | 17.010 | 28.967 | 56.119 | 28.697 | 40.934 |
| hex: canterbury/lcet10.txt | 524290 | 43549.5 ± 0.2% | 2594.1 ± 0.5% | 1512.9 ± 0.5% | 468.9 ± 0.3% | 1567.4 ± 0.4% | 1064.6 ± 0.7% | 16.788 | 28.785 | 92.874 | 27.785 | 40.908 |
| hex: canterbury/plrabn12.txt | 524290 | 42666.2 ± 1.0% | 2580.4 ± 0.6% | 1511.9 ± 0.4% | 450.8 ± 0.4% | 1525.6 ± 4.8% | 1068.3 ± 4.7% | 16.535 | 28.219 | 94.644 | 27.968 | 39.938 |
| hex: canterbury/ptt5 | 524290 | 43540.7 ± 0.5% | 2570.8 ± 5.2% | 1504.0 ± 0.2% | 592.6 ± 0.7% | 1549.1 ± 0.3% | 1064.6 ± 0.6% | 16.937 | 28.949 | 73.472 | 28.108 | 40.900 |
| hex: canterbury/sum | 76482 | 43085.3 ± 0.9% | 2587.7 ± 0.6% | 1527.3 ± 0.1% | 562.4 ± 3.0% | 1580.2 ± 0.4% | 1090.8 ± 0.1% | 16.650 | 28.210 | 76.608 | 27.266 | 39.498 |
| hex: canterbury/xargs.1 | 8456 | 41132.8 ± 0.2% | 2672.4 ± 0.1% | 1566.3 ± 0.7% | 840.5 ± 3.6% | 1604.5 ± 0.1% | 1111.0 ± 0.3% | 15.391 | 26.260 | 48.941 | 25.637 | 37.024 |
| hex: canterbury-large/E.coli | 524290 | 41918.2 ± 7.5% | 2574.2 ± 0.3% | 1512.2 ± 0.2% | 818.5 ± 0.2% | 1571.8 ± 0.1% | 1070.9 ± 0.1% | 16.284 | 27.720 | 51.215 | 26.669 | 39.142 |
| hex: canterbury-large/bible.txt | 524290 | 43364.3 ± 8.3% | 2595.8 ± 0.4% | 1516.8 ± 0.1% | 483.1 ± 0.2% | 1573.3 ± 0.1% | 1067.9 ± 0.3% | 16.706 | 28.589 | 89.759 | 27.562 | 40.608 |
| hex: canterbury-large/world192.txt | 524290 | 43692.0 ± 0.0% | 2580.5 ± 0.7% | 1511.6 ± 0.4% | 459.4 ± 0.2% | 1557.5 ± 0.2% | 1066.7 ± 0.2% | 16.931 | 28.904 | 95.107 | 28.052 | 40.960 |
| hex: http/html-1kx1024 | 2099200 | 20612.6 ± 0.2% | 2348.8 ± 2.3% | 1479.0 ± 0.7% | 500.2 ± 4.8% | 1494.5 ± 1.4% | 1077.5 ± 2.3% | 8.776 | 13.937 | 41.210 | 13.793 | 19.129 |
| hex: http/html-16kx64 | 2097280 | 21399.9 ± 0.2% | 2231.2 ± 0.6% | 1460.5 ± 0.9% | 504.3 ± 0.4% | 1445.7 ± 0.3% | 1085.3 ± 0.5% | 9.591 | 14.653 | 42.431 | 14.802 | 19.718 |
| hex: http/html-1m | 524290 | 43611.2 ± 0.3% | 2582.2 ± 0.4% | 1507.9 ± 0.7% | 482.8 ± 0.4% | 1488.1 ± 0.4% | 1064.6 ± 0.2% | 16.889 | 28.921 | 90.330 | 29.307 | 40.964 |
| hex: http/json-1kx1024 | 2099200 | 20484.9 ± 0.5% | 2336.4 ± 1.8% | 1475.2 ± 0.6% | 695.1 ± 1.1% | 1485.6 ± 0.9% | 1078.5 ± 0.8% | 8.768 | 13.886 | 29.472 | 13.789 | 18.994 |
| hex: http/json-16kx64 | 2097280 | 21756.1 ± 0.1% | 2219.4 ± 0.5% | 1452.3 ± 0.5% | 704.8 ± 0.6% | 1436.7 ± 4.9% | 1082.8 ± 1.0% | 9.803 | 14.981 | 30.869 | 15.143 | 20.093 |
| hex: http/json-1m | 524290 | 43407.6 ± 0.2% | 2588.0 ± 0.2% | 1508.6 ± 0.6% | 734.6 ± 4.5% | 1555.8 ± 0.7% | 1068.2 ± 0.3% | 16.773 | 28.773 | 59.090 | 27.900 | 40.636 |
| hex: http/js-1kx1024 | 2099200 | 20675.8 ± 0.3% | 2359.1 ± 1.9% | 1480.4 ± 0.3% | 490.5 ± 0.1% | 1492.8 ± 1.7% | 1076.5 ± 1.2% | 8.764 | 13.967 | 42.150 | 13.850 | 19.206 |
| hex: http/js-16kx64 | 2097280 | 21938.9 ± 0.3% | 2231.8 ± 0.2% | 1462.5 ± 0.3% | 492.5 ± 0.2% | 1449.2 ± 0.4% | 1087.9 ± 0.4% | 9.830 | 15.000 | 44.548 | 15.138 | 20.167 |
| hex: http/js-1m | 524290 | 43703.9 ± 0.5% | 2586.0 ± 0.4% | 1515.8 ± 0.4% | 507.5 ± 0.6% | 1573.3 ± 0.2% | 1060.0 ± 0.5% | 16.900 | 28.833 | 86.117 | 27.778 | 41.229 |
| hex: http/css-1kx1024 | 2099200 | 22846.9 ± 0.2% | 2346.4 ± 0.9% | 1478.6 ± 1.0% | 557.0 ± 0.4% | 1496.1 ± 1.1% | 1078.2 ± 0.5% | 9.737 | 15.452 | 41.021 | 15.271 | 21.189 |
| hex: http/css-16kx64 | 2097280 | 22664.0 ± 0.2% | 2230.5 ± 0.3% | 1456.7 ± 0.6% | 562.3 ± 4.9% | 1444.3 ± 1.1% | 1084.9 ± 0.4% | 10.161 | 15.559 | 40.303 | 15.692 | 20.890 |
| hex: http/css-1m | 524290 | 43408.5 ± 1.7% | 2585.8 ± 0.7% | 1511.1 ± 0.6% | 538.0 ± 0.4% | 1568.3 ± 6.4% | 1062.9 ± 0.4% | 16.787 | 28.727 | 80.680 | 27.678 | 40.841 |
| hex: shuffled/dickens-1m | 524290 | 43734.2 ± 0.5% | 2598.6 ± 0.2% | 1512.6 ± 0.4% | 463.4 ± 0.5% | 1568.1 ± 6.8% | 1068.3 ± 0.8% | 16.830 | 28.914 | 94.374 | 27.889 | 40.938 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.902 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.890 of simdjson.
- messages: 11 string members, decoding: stdx runs at 0.534 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.763 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.930 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.752 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.827 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.921 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.475 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.707 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.861 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.839 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.932 of simdjson.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.507 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.738 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.899 of yyjson.
- messages: 50 nested objects, encoding through TextWriter's methods: stdx runs at 0.914 of simdjson.
