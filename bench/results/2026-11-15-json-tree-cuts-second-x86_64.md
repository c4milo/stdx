# bench-json

| Field | Value |
|---|---|
| Commit | d49e5bd |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.127.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1014-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43668089875 |
| Date | 2026-11-15 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1380.0 ± 7.2% | 0.492 | 1.023 | 1.069 | 1.070 | 0.411 | 1.076 | 1.072 | 0.373 | 0.837 | 0.931 | 0.106 |
| qlog records, JSON text sequence | 1467503 | 1100.0 ± 2.6% | 0.794 | 1.065 | 1.068 | 1.064 | 0.392 | 1.071 | 1.067 | 0.360 | 0.934 | 1.048 | 0.125 |
| messages: 11 string members | 1025025 | 1097.7 ± 0.7% | 0.565 | 1.018 | 1.035 | 1.037 | 0.532 | 1.010 | 1.035 | 0.519 | 0.884 | 0.943 | 0.134 |
| messages: 50 nested objects | 1121600 | 1346.1 ± 0.2% | 0.804 | 1.087 | 1.088 | 1.090 | 0.396 | 1.097 | 1.089 | 0.351 | 0.923 | 0.968 | 0.114 |
| messages: a tree of 341 objects | 612600 | 666.1 ± 0.4% | 0.822 | 1.056 | 1.039 | 1.038 | 0.266 | 1.032 | 1.038 | 0.221 | 0.819 | 0.984 | 0.117 |
| string: silesia/dickens | 172528 | 6737.6 ± 0.4% | 0.029 | 0.695 | 1.082 | 1.092 | 0.201 | 1.036 | 1.105 | 0.201 | 1.001 | 1.001 | 0.029 |
| string: silesia/nci | 1075110 | 5439.1 ± 0.3% | 0.035 | 0.729 | 1.033 | 1.035 | 0.307 | 1.039 | 1.035 | 0.307 | 1.006 | 1.006 | 0.035 |
| string: silesia/reymont | 1075159 | 3533.2 ± 0.8% | 0.055 | 0.626 | 0.869 | 0.871 | 0.351 | 0.818 | 0.876 | 0.352 | 0.991 | 1.002 | 0.055 |
| string: silesia/samba | 97582 | 3994.9 ± 0.6% | 0.041 | 0.913 | 1.063 | 1.062 | 0.075 | 0.856 | 1.064 | 0.075 | 1.004 | 1.002 | 0.041 |
| string: silesia/webster | 1098490 | 4381.6 ± 1.5% | 0.043 | 0.653 | 0.987 | 0.992 | 0.221 | 0.935 | 1.005 | 0.221 | 1.001 | 1.011 | 0.043 |
| string: silesia/xml | 1090118 | 6051.8 ± 0.3% | 0.032 | 0.787 | 0.971 | 0.980 | 0.251 | 0.965 | 0.985 | 0.250 | 1.001 | 1.004 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5837.7 ± 0.3% | 0.033 | 0.739 | 1.066 | 1.117 | 0.179 | 1.012 | 1.149 | 0.179 | 0.996 | 1.013 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 4329.7 ± 0.7% | 0.042 | 0.799 | 1.123 | 1.129 | 0.199 | 1.046 | 1.135 | 0.199 | 0.997 | 0.999 | 0.042 |
| string: canterbury/lcet10.txt | 441884 | 6674.2 ± 0.9% | 0.029 | 0.610 | 1.093 | 1.104 | 0.194 | 1.037 | 1.113 | 0.194 | 0.998 | 0.997 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 5500.7 ± 0.1% | 0.035 | 0.765 | 0.970 | 0.975 | 0.223 | 0.861 | 0.974 | 0.224 | 1.001 | 1.001 | 0.035 |
| string: canterbury-large/E.coli | 1048578 | 28675.8 ± 0.2% | 0.063 | 1.002 | 0.790 | 1.002 | 0.545 | 1.002 | 1.003 | 0.545 | 1.185 | 1.189 | 0.007 |
| string: canterbury-large/bible.txt | 1055886 | 8561.6 ± 2.0% | 0.024 | 0.620 | 0.876 | 0.880 | 0.396 | 0.889 | 0.892 | 0.398 | 1.004 | 1.011 | 0.024 |
| string: canterbury-large/world192.txt | 1103121 | 4169.8 ± 0.3% | 0.045 | 0.691 | 0.974 | 0.977 | 0.213 | 0.930 | 0.990 | 0.213 | 1.002 | 1.007 | 0.045 |
| string: http/html-1m | 1058582 | 9169.2 ± 6.8% | 0.022 | 0.562 | 0.780 | 0.786 | 0.319 | 0.752 | 0.794 | 0.318 | 0.976 | 1.059 | 0.022 |
| string: http/json-1m | 1190272 | 3344.5 ± 1.1% | 0.052 | 0.394 | 0.440 | 0.445 | 0.148 | 0.457 | 0.446 | 0.148 | 1.004 | 1.003 | 0.052 |
| string: http/js-1m | 1144362 | 2848.3 ± 0.3% | 0.062 | 0.706 | 0.904 | 0.935 | 0.191 | 0.854 | 0.937 | 0.191 | 1.005 | 1.005 | 0.062 |
| string: http/css-1m | 1097820 | 3310.3 ± 0.4% | 0.055 | 0.776 | 0.967 | 1.029 | 0.289 | 0.957 | 1.030 | 0.289 | 1.004 | 1.008 | 0.055 |
| string: dickens as Cyrillic and CJK | 1883069 | 5851.9 ± 0.5% | 0.025 | 0.062 | 0.448 | 0.448 | 0.198 | 0.445 | 0.448 | 0.198 | 0.998 | 1.003 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1215.1 ± 0.6% | 0.112 | 0.997 | 0.996 | 0.997 | 0.105 | 0.709 | 0.997 | 0.106 | 1.005 | 1.005 | 0.111 |
| hex: silesia/dickens | 524290 | 41076.5 ± 0.3% | 0.045 | 1.002 | 0.644 | 1.002 | 0.433 | 1.003 | 1.003 | 0.433 | 0.829 | 0.829 | 0.005 |
| hex: silesia/mozilla | 524290 | 45877.8 ± 0.9% | 0.040 | 1.000 | 0.628 | 1.000 | 0.391 | 0.999 | 1.000 | 0.391 | 0.742 | 0.742 | 0.005 |
| hex: silesia/mr | 524290 | 45156.8 ± 0.6% | 0.041 | 1.000 | 0.636 | 1.001 | 0.394 | 0.999 | 1.000 | 0.394 | 0.754 | 0.754 | 0.005 |
| hex: silesia/nci | 524290 | 45948.4 ± 0.2% | 0.040 | 1.000 | 0.616 | 1.000 | 0.394 | 1.000 | 1.001 | 0.394 | 0.741 | 0.742 | 0.005 |
| hex: silesia/ooffice | 524290 | 46739.6 ± 2.5% | 0.039 | 1.000 | 0.605 | 0.999 | 0.378 | 1.001 | 0.999 | 0.378 | 0.728 | 0.729 | 0.005 |
| hex: silesia/osdb | 524290 | 45495.8 ± 0.3% | 0.040 | 1.000 | 0.617 | 1.001 | 0.393 | 1.002 | 1.001 | 0.393 | 0.748 | 0.749 | 0.005 |
| hex: silesia/reymont | 524290 | 46050.8 ± 0.1% | 0.040 | 1.000 | 0.626 | 0.999 | 0.393 | 0.999 | 1.000 | 0.394 | 0.740 | 0.740 | 0.005 |
| hex: silesia/samba | 524290 | 46580.6 ± 0.3% | 0.039 | 0.999 | 0.615 | 1.000 | 0.388 | 0.999 | 0.999 | 0.388 | 0.732 | 0.731 | 0.005 |
| hex: silesia/sao | 524290 | 47710.6 ± 2.7% | 0.039 | 0.999 | 0.600 | 1.000 | 0.381 | 0.997 | 0.999 | 0.381 | 0.714 | 0.714 | 0.004 |
| hex: silesia/webster | 524290 | 46188.2 ± 0.1% | 0.040 | 1.000 | 0.621 | 1.000 | 0.393 | 0.999 | 1.000 | 0.394 | 0.738 | 0.737 | 0.005 |
| hex: silesia/x-ray | 524290 | 46995.4 ± 0.1% | 0.039 | 0.999 | 0.609 | 0.998 | 0.364 | 1.000 | 1.000 | 0.365 | 0.725 | 0.725 | 0.005 |
| hex: silesia/xml | 524290 | 46997.0 ± 0.3% | 0.039 | 1.000 | 0.602 | 0.999 | 0.386 | 0.998 | 0.999 | 0.386 | 0.724 | 0.725 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 46546.6 ± 3.7% | 0.040 | 1.000 | 0.606 | 0.999 | 0.388 | 0.999 | 0.999 | 0.389 | 0.730 | 0.730 | 0.005 |
| hex: canterbury/asyoulik.txt | 250360 | 46134.3 ± 2.0% | 0.040 | 1.000 | 0.622 | 0.999 | 0.393 | 1.000 | 1.000 | 0.393 | 0.737 | 0.737 | 0.005 |
| hex: canterbury/cp.html | 49208 | 45206.7 ± 0.3% | 0.041 | 1.001 | 0.623 | 1.002 | 0.392 | 1.000 | 1.002 | 0.394 | 0.742 | 0.742 | 0.005 |
| hex: canterbury/fields.c | 22302 | 52370.3 ± 0.8% | 0.036 | 0.992 | 0.529 | 0.999 | 0.383 | 0.999 | 0.998 | 0.388 | 0.633 | 0.633 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 44709.2 ± 0.7% | 0.042 | 1.010 | 0.571 | 1.004 | 0.408 | 1.004 | 1.002 | 0.428 | 0.671 | 0.671 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 46401.2 ± 1.8% | 0.040 | 1.000 | 0.617 | 1.001 | 0.392 | 1.000 | 1.001 | 0.393 | 0.735 | 0.734 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 49106.3 ± 0.4% | 0.037 | 0.998 | 0.584 | 0.999 | 0.370 | 0.998 | 0.999 | 0.370 | 0.694 | 0.694 | 0.004 |
| hex: canterbury/plrabn12.txt | 524290 | 45951.5 ± 0.1% | 0.040 | 1.001 | 0.622 | 1.001 | 0.395 | 1.000 | 1.001 | 0.395 | 0.741 | 0.741 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 46620.6 ± 0.4% | 0.039 | 1.001 | 0.614 | 1.000 | 0.388 | 1.001 | 1.001 | 0.388 | 0.731 | 0.731 | 0.005 |
| hex: canterbury/sum | 76482 | 47709.9 ± 0.6% | 0.039 | 1.001 | 0.592 | 1.001 | 0.374 | 1.001 | 1.001 | 0.376 | 0.701 | 0.702 | 0.004 |
| hex: canterbury/xargs.1 | 8456 | 45894.5 ± 0.4% | 0.041 | 1.007 | 0.565 | 1.005 | 0.406 | 1.006 | 1.003 | 0.424 | 0.664 | 0.664 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 47628.4 ± 0.5% | 0.039 | 1.000 | 0.600 | 1.002 | 0.382 | 0.999 | 1.002 | 0.382 | 0.715 | 0.715 | 0.004 |
| hex: canterbury-large/bible.txt | 524290 | 46677.2 ± 0.6% | 0.039 | 0.999 | 0.614 | 1.001 | 0.390 | 1.000 | 1.002 | 0.391 | 0.730 | 0.730 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 45757.1 ± 1.4% | 0.040 | 1.000 | 0.616 | 1.002 | 0.395 | 1.000 | 1.002 | 0.395 | 0.744 | 0.745 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 18322.4 ± 0.8% | 0.100 | 1.009 | 0.818 | 1.000 | 0.587 | 1.015 | 1.001 | 0.646 | 0.855 | 0.835 | 0.012 |
| hex: http/html-16kx64 | 2097280 | 35822.3 ± 0.7% | 0.051 | 1.003 | 0.672 | 1.004 | 0.459 | 1.001 | 1.004 | 0.463 | 0.787 | 0.787 | 0.006 |
| hex: http/html-1m | 524290 | 46445.6 ± 0.6% | 0.040 | 0.999 | 0.609 | 0.999 | 0.390 | 1.000 | 0.999 | 0.391 | 0.733 | 0.733 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 18130.4 ± 2.1% | 0.101 | 1.006 | 0.823 | 0.997 | 0.586 | 1.019 | 0.998 | 0.643 | 0.855 | 0.835 | 0.012 |
| hex: http/json-16kx64 | 2097280 | 35478.7 ± 3.4% | 0.052 | 1.000 | 0.680 | 1.003 | 0.463 | 1.003 | 1.002 | 0.467 | 0.790 | 0.790 | 0.006 |
| hex: http/json-1m | 524290 | 47637.8 ± 0.3% | 0.039 | 1.000 | 0.604 | 1.000 | 0.381 | 0.997 | 0.999 | 0.382 | 0.715 | 0.715 | 0.004 |
| hex: http/js-1kx1024 | 2099200 | 17885.4 ± 3.3% | 0.102 | 1.006 | 0.829 | 1.003 | 0.576 | 1.024 | 1.000 | 0.630 | 0.859 | 0.842 | 0.012 |
| hex: http/js-16kx64 | 2097280 | 35117.7 ± 1.1% | 0.052 | 1.008 | 0.687 | 1.010 | 0.466 | 1.007 | 1.008 | 0.471 | 0.799 | 0.799 | 0.006 |
| hex: http/js-1m | 524290 | 46265.4 ± 0.3% | 0.040 | 0.999 | 0.620 | 1.000 | 0.390 | 1.000 | 1.001 | 0.390 | 0.736 | 0.736 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 17889.2 ± 3.3% | 0.102 | 1.004 | 0.832 | 1.002 | 0.574 | 1.025 | 0.996 | 0.629 | 0.863 | 0.841 | 0.012 |
| hex: http/css-16kx64 | 2097280 | 34006.1 ± 0.5% | 0.054 | 1.004 | 0.690 | 1.002 | 0.474 | 0.999 | 1.004 | 0.478 | 0.802 | 0.803 | 0.006 |
| hex: http/css-1m | 524290 | 42795.8 ± 0.1% | 0.043 | 1.002 | 0.647 | 1.002 | 0.408 | 1.002 | 1.002 | 0.409 | 0.795 | 0.796 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 47521.6 ± 0.4% | 0.039 | 0.999 | 0.589 | 0.998 | 0.380 | 0.998 | 0.998 | 0.381 | 0.717 | 0.717 | 0.004 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1768.9 ± 4.1% | 0.423 | 0.999 | 0.973 | 1.008 | 1.009 | 0.270 | 1.010 | 0.520 | 0.885 | 0.094 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1701.2 ± 0.6% | 0.623 | 0.951 | 0.963 | 0.991 | 0.973 | 0.229 | 0.973 | 0.446 | 0.831 | 0.105 | 1.020 |
| messages: 11 string members | 1025025 | 1335.6 ± 0.5% | 0.502 | 0.964 | 0.985 | 0.989 | 0.981 | 0.383 | 0.983 | 0.672 | 0.934 | 0.122 | 0.998 |
| messages: 50 nested objects | 1121600 | 2021.1 ± 0.4% | 0.582 | 0.973 | 0.964 | 0.987 | 0.971 | 0.242 | 0.969 | 0.461 | 0.831 | 0.091 | 1.003 |
| messages: a tree of 341 objects | 612600 | 615.8 ± 1.8% | 0.953 | 1.033 | 1.049 | 1.054 | 1.053 | 0.257 | 1.052 | 0.447 | 0.952 | 0.190 | 1.061 |
| string: silesia/dickens | 172528 | 13109.1 ± 0.9% | 0.017 | 0.542 | 0.360 | 0.533 | 0.557 | 0.120 | 0.561 | 1.001 | 1.003 | 0.017 | 1.029 |
| string: silesia/nci | 1075110 | 11377.0 ± 0.3% | 0.020 | 0.519 | 0.375 | 0.533 | 0.520 | 0.186 | 0.517 | 1.000 | 1.000 | 0.020 | 1.031 |
| string: silesia/reymont | 1075159 | 5299.3 ± 2.1% | 0.043 | 0.582 | 0.437 | 0.569 | 0.580 | 0.271 | 0.579 | 1.018 | 1.024 | 0.043 | 1.032 |
| string: silesia/samba | 97582 | 6350.4 ± 0.5% | 0.045 | 0.886 | 0.743 | 0.897 | 0.894 | 0.122 | 0.896 | 1.000 | 1.001 | 0.045 | 1.156 |
| string: silesia/webster | 1098490 | 7098.2 ± 0.6% | 0.032 | 0.572 | 0.403 | 0.551 | 0.576 | 0.155 | 0.570 | 0.988 | 1.010 | 0.032 | 0.988 |
| string: silesia/xml | 1090118 | 10574.7 ± 0.8% | 0.022 | 0.574 | 0.474 | 0.569 | 0.577 | 0.197 | 0.578 | 0.998 | 1.018 | 0.022 | 1.029 |
| string: canterbury/alice29.txt | 159425 | 12762.4 ± 0.4% | 0.018 | 0.445 | 0.357 | 0.421 | 0.458 | 0.093 | 0.474 | 1.001 | 1.009 | 0.018 | 1.050 |
| string: canterbury/asyoulik.txt | 132198 | 11013.2 ± 2.1% | 0.020 | 0.397 | 0.329 | 0.389 | 0.415 | 0.090 | 0.420 | 0.999 | 1.019 | 0.020 | 1.046 |
| string: canterbury/lcet10.txt | 441884 | 12779.3 ± 1.4% | 0.018 | 0.543 | 0.325 | 0.533 | 0.547 | 0.118 | 0.549 | 0.994 | 1.016 | 0.018 | 0.996 |
| string: canterbury/plrabn12.txt | 503330 | 8914.6 ± 1.9% | 0.025 | 0.616 | 0.493 | 0.584 | 0.616 | 0.159 | 0.617 | 0.998 | 1.018 | 0.025 | 1.019 |
| string: canterbury-large/E.coli | 1048578 | 29761.4 ± 1.2% | 0.061 | 1.003 | 1.001 | 0.812 | 1.001 | 0.530 | 1.002 | 1.002 | 1.004 | 0.008 | 1.000 |
| string: canterbury-large/bible.txt | 1055886 | 9713.3 ± 0.4% | 0.024 | 0.739 | 0.573 | 0.746 | 0.746 | 0.383 | 0.750 | 0.991 | 1.007 | 0.024 | 1.020 |
| string: canterbury-large/world192.txt | 1103121 | 6666.5 ± 3.3% | 0.034 | 0.591 | 0.426 | 0.551 | 0.593 | 0.153 | 0.594 | 0.989 | 1.005 | 0.034 | 0.976 |
| string: http/html-1m | 1058582 | 10156.9 ± 0.6% | 0.023 | 0.640 | 0.538 | 0.633 | 0.642 | 0.313 | 0.642 | 0.995 | 1.010 | 0.023 | 1.009 |
| string: http/json-1m | 1190272 | 8614.9 ± 0.3% | 0.024 | 0.181 | 0.158 | 0.181 | 0.181 | 0.072 | 0.181 | 1.001 | 1.003 | 0.024 | 1.019 |
| string: http/js-1m | 1144362 | 6584.8 ± 1.6% | 0.032 | 0.367 | 0.313 | 0.360 | 0.367 | 0.095 | 0.367 | 0.987 | 1.003 | 0.032 | 1.014 |
| string: http/css-1m | 1097820 | 9288.2 ± 0.5% | 0.023 | 0.349 | 0.286 | 0.335 | 0.348 | 0.125 | 0.348 | 1.006 | 1.012 | 0.023 | 0.992 |
| string: dickens as Cyrillic and CJK | 1883069 | 5522.1 ± 0.2% | 0.030 | 0.466 | 0.067 | 0.464 | 0.466 | 0.209 | 0.466 | 1.000 | 1.003 | 0.030 | 1.036 |
| hex: silesia/dickens | 524290 | 42677.4 ± 1.8% | 1.002 | 0.090 | 1.002 | 0.603 | 1.002 | 1.001 | 1.002 | 1.001 | 1.002 | 0.092 | 1.002 |
| hex: silesia/mozilla | 524290 | 43838.0 ± 0.2% | 1.001 | 0.088 | 1.001 | 0.589 | 1.000 | 1.000 | 1.001 | 1.001 | 1.002 | 0.089 | 1.001 |
| hex: silesia/mr | 524290 | 43750.9 ± 0.2% | 1.002 | 0.088 | 1.001 | 0.590 | 1.001 | 1.000 | 1.002 | 1.001 | 1.001 | 0.094 | 1.001 |
| hex: silesia/nci | 524290 | 43954.8 ± 0.0% | 1.001 | 0.088 | 1.000 | 0.586 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 0.090 | 1.000 |
| hex: silesia/ooffice | 524290 | 43716.6 ± 0.2% | 1.001 | 0.088 | 1.000 | 0.590 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.093 | 1.001 |
| hex: silesia/osdb | 524290 | 42309.3 ± 0.1% | 1.002 | 0.091 | 1.000 | 0.608 | 1.002 | 1.000 | 1.002 | 1.001 | 1.001 | 0.094 | 1.001 |
| hex: silesia/reymont | 524290 | 43843.7 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.589 | 1.001 | 1.000 | 1.001 | 0.999 | 1.001 | 0.090 | 1.001 |
| hex: silesia/samba | 524290 | 43808.8 ± 0.3% | 1.001 | 0.088 | 1.001 | 0.589 | 1.001 | 1.001 | 1.001 | 1.001 | 1.002 | 0.092 | 1.001 |
| hex: silesia/sao | 524290 | 43764.4 ± 0.1% | 1.002 | 0.088 | 1.001 | 0.589 | 1.001 | 1.000 | 1.002 | 1.001 | 1.001 | 0.093 | 1.001 |
| hex: silesia/webster | 524290 | 44200.6 ± 0.1% | 1.001 | 0.087 | 0.999 | 0.586 | 1.000 | 0.999 | 1.001 | 0.999 | 1.001 | 0.092 | 1.000 |
| hex: silesia/x-ray | 524290 | 43879.6 ± 0.1% | 1.002 | 0.088 | 1.001 | 0.589 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.090 | 1.000 |
| hex: silesia/xml | 524290 | 43945.8 ± 0.4% | 1.001 | 0.088 | 1.001 | 0.588 | 1.001 | 0.999 | 1.000 | 1.000 | 1.001 | 0.092 | 1.000 |
| hex: canterbury/alice29.txt | 304180 | 41826.7 ± 1.0% | 1.001 | 0.092 | 1.002 | 0.597 | 1.002 | 1.000 | 1.002 | 1.001 | 1.001 | 0.098 | 1.002 |
| hex: canterbury/asyoulik.txt | 250360 | 43789.2 ± 0.1% | 1.002 | 0.088 | 0.998 | 0.589 | 1.001 | 0.999 | 1.001 | 0.998 | 1.001 | 0.093 | 1.000 |
| hex: canterbury/cp.html | 49208 | 42741.9 ± 0.2% | 1.000 | 0.090 | 1.001 | 0.593 | 1.002 | 0.995 | 1.002 | 1.002 | 1.001 | 0.098 | 1.003 |
| hex: canterbury/fields.c | 22302 | 40005.6 ± 0.1% | 0.999 | 0.096 | 0.999 | 0.614 | 1.001 | 0.989 | 1.000 | 1.002 | 1.010 | 0.103 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 39339.7 ± 0.2% | 0.992 | 0.096 | 1.004 | 0.611 | 1.003 | 0.974 | 1.002 | 1.010 | 1.033 | 0.104 | 1.012 |
| hex: canterbury/kennedy.xls | 524290 | 43845.4 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.589 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 0.093 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 43884.4 ± 0.1% | 1.001 | 0.088 | 1.001 | 0.589 | 1.002 | 1.000 | 1.001 | 1.001 | 1.002 | 0.094 | 1.001 |
| hex: canterbury/plrabn12.txt | 524290 | 43877.7 ± 0.1% | 1.002 | 0.088 | 1.001 | 0.588 | 1.001 | 0.991 | 1.002 | 1.000 | 1.001 | 0.091 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 43869.4 ± 0.1% | 1.002 | 0.088 | 1.001 | 0.589 | 1.001 | 0.998 | 1.002 | 1.001 | 1.001 | 0.093 | 1.000 |
| hex: canterbury/sum | 76482 | 43141.2 ± 6.7% | 1.001 | 0.090 | 0.999 | 0.593 | 1.001 | 0.995 | 1.001 | 0.999 | 1.000 | 0.096 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 40373.0 ± 0.2% | 1.001 | 0.094 | 1.001 | 0.600 | 1.001 | 0.951 | 1.000 | 0.985 | 1.025 | 0.101 | 1.005 |
| hex: canterbury-large/E.coli | 524290 | 41916.4 ± 0.3% | 1.003 | 0.092 | 1.002 | 0.609 | 1.002 | 1.001 | 1.002 | 1.002 | 1.002 | 0.097 | 1.002 |
| hex: canterbury-large/bible.txt | 524290 | 43902.6 ± 0.2% | 1.001 | 0.088 | 1.001 | 0.588 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.093 | 1.000 |
| hex: canterbury-large/world192.txt | 524290 | 43595.7 ± 0.3% | 1.002 | 0.089 | 1.001 | 0.593 | 1.001 | 1.001 | 1.002 | 1.001 | 1.002 | 0.092 | 1.002 |
| hex: http/html-1kx1024 | 2099200 | 21800.9 ± 0.2% | 1.003 | 0.170 | 1.002 | 0.953 | 1.000 | 0.996 | 1.001 | 1.002 | 1.004 | 0.177 | 1.004 |
| hex: http/html-16kx64 | 2097280 | 22069.7 ± 0.3% | 1.004 | 0.173 | 1.003 | 0.975 | 1.004 | 1.004 | 1.004 | 1.003 | 1.003 | 0.187 | 1.004 |
| hex: http/html-1m | 524290 | 43860.9 ± 0.1% | 1.001 | 0.088 | 1.000 | 0.590 | 1.001 | 1.000 | 1.001 | 1.000 | 1.002 | 0.091 | 0.999 |
| hex: http/json-1kx1024 | 2099200 | 21082.1 ± 0.4% | 1.005 | 0.175 | 1.003 | 0.969 | 1.003 | 1.000 | 1.003 | 1.004 | 1.009 | 0.183 | 1.006 |
| hex: http/json-16kx64 | 2097280 | 21697.2 ± 0.2% | 1.002 | 0.176 | 1.002 | 0.976 | 1.003 | 1.002 | 1.002 | 1.002 | 1.003 | 0.191 | 1.003 |
| hex: http/json-1m | 524290 | 43784.4 ± 0.1% | 1.002 | 0.088 | 1.001 | 0.591 | 1.002 | 1.000 | 1.002 | 1.001 | 1.002 | 0.091 | 1.001 |
| hex: http/js-1kx1024 | 2099200 | 20786.3 ± 0.5% | 1.005 | 0.178 | 1.004 | 0.977 | 1.004 | 1.003 | 1.004 | 1.005 | 1.005 | 0.185 | 1.006 |
| hex: http/js-16kx64 | 2097280 | 21217.4 ± 0.2% | 1.003 | 0.180 | 1.002 | 0.991 | 1.002 | 1.002 | 1.003 | 1.003 | 1.003 | 0.195 | 1.003 |
| hex: http/js-1m | 524290 | 43855.2 ± 0.1% | 0.999 | 0.088 | 1.001 | 0.590 | 1.002 | 1.000 | 0.999 | 1.001 | 1.001 | 0.091 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 21148.3 ± 0.5% | 1.004 | 0.175 | 1.003 | 0.967 | 1.003 | 0.999 | 1.003 | 1.004 | 1.008 | 0.182 | 1.005 |
| hex: http/css-16kx64 | 2097280 | 22047.7 ± 0.3% | 1.002 | 0.173 | 1.001 | 0.968 | 1.002 | 1.003 | 1.002 | 1.002 | 1.004 | 0.187 | 1.003 |
| hex: http/css-1m | 524290 | 43847.5 ± 0.0% | 1.001 | 0.088 | 1.001 | 0.590 | 1.000 | 1.000 | 1.001 | 1.000 | 1.001 | 0.090 | 1.001 |
| hex: shuffled/dickens-1m | 524290 | 42632.9 ± 0.3% | 1.003 | 0.091 | 1.001 | 0.607 | 1.003 | 1.001 | 1.002 | 1.002 | 1.002 | 0.095 | 1.002 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.065 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.068 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.064 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.071 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.067 of all on.
- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.087 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.088 of all on.
- messages: 50 nested objects, decoding: J8 decoder fast path off runs at 1.090 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.097 of all on.
- messages: 50 nested objects, decoding: J13 decoder escape blocks off runs at 1.089 of all on.
- messages: a tree of 341 objects, decoding: J5 UTF-8 vectors off runs at 1.056 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.082 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.092 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.105 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.063 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.062 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.064 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.066 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.117 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.149 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.123 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.129 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.135 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.093 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.104 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.113 of all on.
- messages: a tree of 341 objects, encoding: J7 wide vectors off runs at 1.054 of all on.
- messages: a tree of 341 objects, encoding: J9 encoder fast path off runs at 1.053 of all on.
- messages: a tree of 341 objects, encoding: J14 encoder escape blocks off runs at 1.052 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 169623.9 ± 0.2% | 122522.6 ± 0.2% | 1.384 | 101282.4 ± 0.2% | 1.675 |
| string: silesia/nci | 1048576 | 170410.6 ± 0.2% | 123212.5 ± 0.3% | 1.383 | 101663.0 ± 0.1% | 1.676 |
| string: silesia/reymont | 1048576 | 170579.7 ± 0.2% | 123256.7 ± 0.3% | 1.384 | 101710.6 ± 0.2% | 1.677 |
| string: silesia/samba | 65546 | 164264.6 ± 0.5% | 120804.4 ± 0.1% | 1.360 | 99934.1 ± 0.1% | 1.644 |
| string: silesia/webster | 1048576 | 169768.0 ± 0.2% | 123288.2 ± 0.2% | 1.377 | 102065.2 ± 4.8% | 1.663 |
| string: silesia/xml | 1048576 | 153361.4 ± 0.4% | 116336.3 ± 0.2% | 1.318 | 96688.3 ± 0.2% | 1.586 |
| string: canterbury/alice29.txt | 152089 | 168960.1 ± 0.1% | 122380.9 ± 0.3% | 1.381 | 101056.0 ± 0.1% | 1.672 |
| string: canterbury/asyoulik.txt | 125179 | 168483.2 ± 0.1% | 122132.1 ± 0.3% | 1.380 | 101275.3 ± 0.1% | 1.664 |
| string: canterbury/lcet10.txt | 426754 | 170357.6 ± 0.4% | 123185.9 ± 0.1% | 1.383 | 101956.9 ± 0.2% | 1.671 |
| string: canterbury/plrabn12.txt | 481861 | 170582.9 ± 11.7% | 123161.7 ± 0.1% | 1.385 | 102024.7 ± 0.1% | 1.672 |
| string: canterbury-large/E.coli | 1048576 | 170208.7 ± 0.1% | 123202.1 ± 0.1% | 1.382 | 101486.9 ± 4.3% | 1.677 |
| string: canterbury-large/bible.txt | 1048576 | 170344.8 ± 1.4% | 122981.0 ± 0.4% | 1.385 | 102258.6 ± 0.3% | 1.666 |
| string: canterbury-large/world192.txt | 1048576 | 169974.4 ± 0.6% | 123223.0 ± 0.1% | 1.379 | 101488.3 ± 0.2% | 1.675 |
| string: http/html-1m | 1048576 | 125975.2 ± 1.0% | 101761.8 ± 0.3% | 1.238 | 85546.9 ± 0.6% | 1.473 |
| string: http/json-1m | 1048576 | 123224.1 ± 0.5% | 106999.3 ± 0.2% | 1.152 | 82925.0 ± 1.6% | 1.486 |
| string: http/js-1m | 1048576 | 151159.8 ± 0.2% | 115299.2 ± 6.2% | 1.311 | 95778.0 ± 1.0% | 1.578 |
| string: http/css-1m | 1048576 | 132873.5 ± 5.7% | 106987.1 ± 2.0% | 1.242 | 90036.6 ± 0.5% | 1.476 |
| string: dickens as Cyrillic and CJK | 1847045 | 23431.6 ± 0.3% | 20885.2 ± 4.1% | 1.122 | 15024.4 ± 0.2% | 1.560 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 169518.8 ± 0.3% | 123186.8 ± 6.2% | 1.376 | 102287.1 ± 0.2% | 1.657 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 169573.3 ± 0.6% | 123239.2 ± 6.1% | 1.376 | 101558.9 ± 0.1% | 1.670 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 169274.4 ± 0.1% | 123080.7 ± 0.8% | 1.375 | 101501.8 ± 0.1% | 1.668 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 169799.7 ± 0.3% | 123195.2 ± 0.2% | 1.378 | 101514.7 ± 0.1% | 1.673 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 169545.9 ± 0.2% | 123223.0 ± 0.0% | 1.376 | 101551.6 ± 0.1% | 1.670 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 169596.7 ± 0.4% | 123217.3 ± 0.5% | 1.376 | 102053.2 ± 0.1% | 1.662 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24413.9 ± 0.5% | 21825.4 ± 0.5% | 1.119 | 15400.2 ± 0.2% | 1.585 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24438.8 ± 0.4% | 21819.4 ± 0.3% | 1.120 | 15384.7 ± 0.2% | 1.589 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24410.3 ± 0.3% | 21804.1 ± 4.6% | 1.120 | 15387.9 ± 0.1% | 1.586 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24427.9 ± 0.6% | 21802.9 ± 1.8% | 1.120 | 15387.2 ± 1.1% | 1.588 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24410.2 ± 0.5% | 21803.3 ± 0.2% | 1.120 | 15390.7 ± 0.2% | 1.586 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24411.5 ± 0.1% | 21809.4 ± 0.2% | 1.119 | 15407.1 ± 0.2% | 1.584 |

## Messages against serde_json's typed code

stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.

| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |
|---|---|---|---|---|
| messages: 11 string members | 1025025 | 1228.6 ± 2.0% | 812.2 ± 0.3% | 1.513 |
| messages: 50 nested objects | 1121600 | 1668.7 ± 0.6% | 921.2 ± 0.3% | 1.811 |
| messages: a tree of 341 objects | 612600 | 583.2 ± 4.3% | 506.6 ± 0.4% | 1.151 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1380.0 ± 7.2% | 1541.1 ± 48.4% | 1089.6 ± 55.5% | 392.0 ± 50.1% | 675.8 ± 53.0% | 367.3 ± 66.0% | 0.895 | 1.267 | 3.521 | 2.042 | 3.757 |
| qlog records, JSON text sequence | 1467503 | 1100.0 ± 2.6% | 1244.7 ± 2.5% | 1128.3 ± 0.4% | 328.0 ± 1.0% | 768.8 ± 0.8% | 319.7 ± 0.6% | 0.884 | 0.975 | 3.354 | 1.431 | 3.441 |
| messages: 11 string members | 1025025 | 1097.7 ± 0.7% | 2011.3 ± 0.6% | 697.6 ± 4.2% | 340.2 ± 0.4% | 516.7 ± 0.3% | 307.5 ± 1.5% | 0.546 | 1.574 | 3.227 | 2.125 | 3.570 |
| messages: 50 nested objects | 1121600 | 1346.1 ± 0.2% | 1769.9 ± 1.0% | 1428.3 ± 0.0% | 431.5 ± 1.6% | 908.2 ± 0.4% | 425.3 ± 0.5% | 0.761 | 0.942 | 3.120 | 1.482 | 3.165 |
| messages: a tree of 341 objects | 612600 | 666.1 ± 0.4% | 858.7 ± 0.9% | 697.4 ± 1.1% | 183.3 ± 0.6% | 619.4 ± 0.3% | 209.8 ± 0.7% | 0.776 | 0.955 | 3.634 | 1.075 | 3.175 |
| string: silesia/dickens | 172528 | 6737.6 ± 0.4% | 3394.4 ± 3.2% | 2868.2 ± 1.1% | 318.8 ± 0.4% | 3096.5 ± 0.8% | 571.1 ± 1.3% | 1.985 | 2.349 | 21.133 | 2.176 | 11.798 |
| string: silesia/nci | 1075110 | 5439.1 ± 0.3% | 3916.3 ± 0.4% | 3052.1 ± 0.1% | 657.1 ± 0.7% | 3640.6 ± 0.3% | 579.8 ± 0.4% | 1.389 | 1.782 | 8.278 | 1.494 | 9.380 |
| string: silesia/reymont | 1075159 | 3533.2 ± 0.8% | 3420.9 ± 0.3% | 1965.8 ± 2.2% | 344.0 ± 0.3% | 2111.7 ± 0.3% | 497.9 ± 1.2% | 1.033 | 1.797 | 10.272 | 1.673 | 7.097 |
| string: silesia/samba | 97582 | 3994.9 ± 0.6% | 3797.7 ± 0.2% | 3066.5 ± 0.2% | 331.3 ± 1.8% | 1966.0 ± 1.2% | 423.0 ± 1.3% | 1.052 | 1.303 | 12.059 | 2.032 | 9.444 |
| string: silesia/webster | 1098490 | 4381.6 ± 1.5% | 2447.7 ± 0.3% | 1742.7 ± 0.3% | 311.2 ± 0.5% | 2078.4 ± 0.5% | 470.7 ± 1.8% | 1.790 | 2.514 | 14.078 | 2.108 | 9.308 |
| string: silesia/xml | 1090118 | 6051.8 ± 0.3% | 5056.8 ± 0.2% | 2462.0 ± 0.3% | 514.2 ± 0.2% | 3331.1 ± 2.1% | 553.6 ± 2.0% | 1.197 | 2.458 | 11.770 | 1.817 | 10.931 |
| string: canterbury/alice29.txt | 159425 | 5837.7 ± 0.3% | 2785.6 ± 1.8% | 2826.7 ± 1.3% | 302.2 ± 0.2% | 2777.9 ± 1.8% | 522.0 ± 1.5% | 2.096 | 2.065 | 19.320 | 2.101 | 11.183 |
| string: canterbury/asyoulik.txt | 132198 | 4329.7 ± 0.7% | 2644.2 ± 1.2% | 2786.7 ± 1.2% | 307.0 ± 0.3% | 2403.9 ± 0.6% | 457.9 ± 1.3% | 1.637 | 1.554 | 14.103 | 1.801 | 9.455 |
| string: canterbury/lcet10.txt | 441884 | 6674.2 ± 0.9% | 3280.9 ± 0.8% | 2322.3 ± 4.8% | 348.2 ± 0.3% | 2794.2 ± 0.8% | 576.4 ± 0.4% | 2.034 | 2.874 | 19.169 | 2.389 | 11.578 |
| string: canterbury/plrabn12.txt | 503330 | 5500.7 ± 0.1% | 3177.3 ± 0.1% | 1838.0 ± 0.4% | 324.2 ± 0.3% | 2837.7 ± 0.4% | 537.5 ± 1.1% | 1.731 | 2.993 | 16.966 | 1.938 | 10.233 |
| string: canterbury-large/E.coli | 1048578 | 28675.8 ± 0.2% | 13605.9 ± 0.2% | 3456.9 ± 0.2% | 1287.7 ± 0.1% | 8933.1 ± 0.3% | 978.2 ± 1.3% | 2.108 | 8.295 | 22.269 | 3.210 | 29.314 |
| string: canterbury-large/bible.txt | 1055886 | 8561.6 ± 2.0% | 5286.2 ± 0.7% | 2844.8 ± 0.3% | 360.2 ± 0.7% | 3892.6 ± 2.0% | 636.2 ± 2.6% | 1.620 | 3.010 | 23.770 | 2.199 | 13.457 |
| string: canterbury-large/world192.txt | 1103121 | 4169.8 ± 0.3% | 2315.9 ± 0.1% | 1778.5 ± 0.3% | 331.4 ± 0.5% | 2111.7 ± 0.8% | 470.8 ± 0.9% | 1.801 | 2.345 | 12.584 | 1.975 | 8.858 |
| string: http/html-1m | 1058582 | 9169.2 ± 6.8% | 4817.0 ± 0.7% | 2733.3 ± 0.8% | 432.0 ± 0.4% | 3631.9 ± 0.9% | 610.2 ± 1.1% | 1.904 | 3.355 | 21.225 | 2.525 | 15.026 |
| string: http/json-1m | 1190272 | 3344.5 ± 1.1% | 1262.5 ± 0.9% | 2105.8 ± 0.3% | 484.2 ± 3.9% | 1341.2 ± 0.7% | 437.3 ± 0.8% | 2.649 | 1.588 | 6.907 | 2.494 | 7.648 |
| string: http/js-1m | 1144362 | 2848.3 ± 0.3% | 1618.3 ± 0.8% | 1333.7 ± 0.4% | 330.3 ± 0.4% | 1429.0 ± 0.3% | 384.4 ± 0.5% | 1.760 | 2.136 | 8.622 | 1.993 | 7.410 |
| string: http/css-1m | 1097820 | 3310.3 ± 0.4% | 2908.2 ± 0.1% | 2297.8 ± 0.3% | 460.3 ± 0.7% | 2072.5 ± 0.4% | 443.5 ± 1.6% | 1.138 | 1.441 | 7.192 | 1.597 | 7.464 |
| string: dickens as Cyrillic and CJK | 1883069 | 5851.9 ± 0.5% | 2912.6 ± 3.6% | 665.6 ± 0.5% | 380.3 ± 0.7% | 515.4 ± 0.2% | 165.1 ± 2.3% | 2.009 | 8.792 | 15.386 | 11.354 | 35.438 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1215.1 ± 0.6% | 1244.1 ± 1.2% | 1110.2 ± 0.6% | 264.9 ± 0.8% | 481.7 ± 0.5% | 232.1 ± 3.0% | 0.977 | 1.094 | 4.586 | 2.523 | 5.235 |
| hex: silesia/dickens | 524290 | 41076.5 ± 0.3% | 15121.6 ± 0.4% | 3539.2 ± 1.3% | 478.7 ± 0.5% | 8940.5 ± 0.3% | 1145.8 ± 1.9% | 2.716 | 11.606 | 85.805 | 4.594 | 35.850 |
| hex: silesia/mozilla | 524290 | 45877.8 ± 0.9% | 15130.8 ± 0.3% | 3507.0 ± 0.2% | 432.4 ± 0.2% | 8948.2 ± 0.2% | 1145.4 ± 0.1% | 3.032 | 13.082 | 106.099 | 5.127 | 40.056 |
| hex: silesia/mr | 524290 | 45156.8 ± 0.6% | 15122.8 ± 1.4% | 3510.0 ± 0.2% | 647.1 ± 0.2% | 8946.0 ± 0.2% | 1147.0 ± 0.3% | 2.986 | 12.865 | 69.779 | 5.048 | 39.368 |
| hex: silesia/nci | 524290 | 45948.4 ± 0.2% | 15125.8 ± 2.7% | 3583.0 ± 0.0% | 810.7 ± 3.7% | 8955.4 ± 0.2% | 1146.6 ± 1.0% | 3.038 | 12.824 | 56.676 | 5.131 | 40.072 |
| hex: silesia/ooffice | 524290 | 46739.6 ± 2.5% | 15117.3 ± 1.0% | 3514.4 ± 1.9% | 346.0 ± 0.6% | 8943.8 ± 0.4% | 1147.1 ± 0.5% | 3.092 | 13.299 | 135.070 | 5.226 | 40.746 |
| hex: silesia/osdb | 524290 | 45495.8 ± 0.3% | 15131.1 ± 0.4% | 3506.6 ± 0.3% | 459.4 ± 0.5% | 8943.3 ± 0.3% | 1146.3 ± 0.5% | 3.007 | 12.974 | 99.028 | 5.087 | 39.691 |
| hex: silesia/reymont | 524290 | 46050.8 ± 0.1% | 15120.7 ± 0.3% | 3556.5 ± 0.2% | 499.8 ± 0.6% | 8936.1 ± 5.2% | 1145.7 ± 1.3% | 3.046 | 12.948 | 92.144 | 5.153 | 40.195 |
| hex: silesia/samba | 524290 | 46580.6 ± 0.3% | 15126.1 ± 0.1% | 3510.8 ± 0.3% | 370.0 ± 0.7% | 8948.0 ± 0.3% | 1145.4 ± 0.3% | 3.079 | 13.268 | 125.908 | 5.206 | 40.666 |
| hex: silesia/sao | 524290 | 47710.6 ± 2.7% | 15116.3 ± 2.6% | 3511.8 ± 3.3% | 280.7 ± 1.5% | 8938.1 ± 0.3% | 1148.8 ± 0.8% | 3.156 | 13.586 | 169.974 | 5.338 | 41.531 |
| hex: silesia/webster | 524290 | 46188.2 ± 0.1% | 15130.6 ± 0.1% | 3580.8 ± 0.2% | 455.1 ± 0.2% | 8967.6 ± 5.0% | 1145.9 ± 0.2% | 3.053 | 12.899 | 101.497 | 5.151 | 40.306 |
| hex: silesia/x-ray | 524290 | 46995.4 ± 0.1% | 15119.4 ± 0.2% | 3510.8 ± 0.1% | 427.4 ± 2.0% | 8942.1 ± 0.3% | 1146.6 ± 1.1% | 3.108 | 13.386 | 109.969 | 5.256 | 40.986 |
| hex: silesia/xml | 524290 | 46997.0 ± 0.3% | 15131.9 ± 0.1% | 3574.6 ± 3.5% | 731.2 ± 0.6% | 8950.7 ± 0.5% | 1146.5 ± 4.3% | 3.106 | 13.147 | 64.272 | 5.251 | 40.991 |
| hex: canterbury/alice29.txt | 304180 | 46546.6 ± 3.7% | 14167.3 ± 0.1% | 3579.9 ± 0.1% | 485.6 ± 0.6% | 8971.2 ± 0.1% | 1156.2 ± 0.3% | 3.286 | 13.002 | 95.845 | 5.188 | 40.258 |
| hex: canterbury/asyoulik.txt | 250360 | 46134.3 ± 2.0% | 15011.5 ± 0.0% | 3508.7 ± 3.4% | 471.9 ± 0.5% | 8937.9 ± 0.1% | 1153.6 ± 0.2% | 3.073 | 13.148 | 97.762 | 5.162 | 39.993 |
| hex: canterbury/cp.html | 49208 | 45206.7 ± 0.3% | 14488.8 ± 0.1% | 3581.9 ± 0.1% | 512.9 ± 0.7% | 9294.5 ± 0.2% | 1131.5 ± 0.7% | 3.120 | 12.621 | 88.141 | 4.864 | 39.953 |
| hex: canterbury/fields.c | 22302 | 52370.3 ± 0.8% | 17709.3 ± 0.1% | 3687.3 ± 0.1% | 578.0 ± 0.3% | 9281.6 ± 0.2% | 1116.8 ± 1.5% | 2.957 | 14.203 | 90.600 | 5.642 | 46.895 |
| hex: canterbury/grammar.lsp | 7444 | 44709.2 ± 0.7% | 17342.1 ± 0.1% | 3639.5 ± 0.5% | 735.0 ± 1.2% | 8985.7 ± 0.2% | 1077.1 ± 1.9% | 2.578 | 12.284 | 60.825 | 4.976 | 41.509 |
| hex: canterbury/kennedy.xls | 524290 | 46401.2 ± 1.8% | 15119.2 ± 2.5% | 3580.2 ± 0.1% | 761.2 ± 2.5% | 8950.0 ± 0.2% | 1130.4 ± 4.7% | 3.069 | 12.961 | 60.955 | 5.185 | 41.048 |
| hex: canterbury/lcet10.txt | 524290 | 49106.3 ± 0.4% | 15113.8 ± 0.4% | 3557.7 ± 0.2% | 484.3 ± 0.3% | 8942.2 ± 0.2% | 1123.8 ± 2.8% | 3.249 | 13.803 | 101.402 | 5.492 | 43.696 |
| hex: canterbury/plrabn12.txt | 524290 | 45951.5 ± 0.1% | 15123.6 ± 0.1% | 3570.1 ± 0.2% | 466.6 ± 1.1% | 8958.7 ± 0.2% | 1145.3 ± 4.3% | 3.038 | 12.871 | 98.472 | 5.129 | 40.121 |
| hex: canterbury/ptt5 | 524290 | 46620.6 ± 0.4% | 15115.7 ± 2.1% | 3490.8 ± 0.1% | 667.6 ± 0.2% | 8931.0 ± 0.7% | 1147.6 ± 1.0% | 3.084 | 13.355 | 69.831 | 5.220 | 40.624 |
| hex: canterbury/sum | 76482 | 47709.9 ± 0.6% | 15510.4 ± 0.1% | 3582.7 ± 0.1% | 589.7 ± 0.4% | 8947.9 ± 3.7% | 1155.2 ± 1.1% | 3.076 | 13.317 | 80.912 | 5.332 | 41.299 |
| hex: canterbury/xargs.1 | 8456 | 45894.5 ± 0.4% | 17470.5 ± 0.1% | 3581.0 ± 0.1% | 724.9 ± 2.0% | 9025.4 ± 0.1% | 1129.5 ± 4.4% | 2.627 | 12.816 | 63.311 | 5.085 | 40.633 |
| hex: canterbury-large/E.coli | 524290 | 47628.4 ± 0.5% | 15129.3 ± 1.8% | 3515.4 ± 0.2% | 966.8 ± 0.2% | 8939.6 ± 3.9% | 1129.6 ± 7.3% | 3.148 | 13.549 | 49.265 | 5.328 | 42.165 |
| hex: canterbury-large/bible.txt | 524290 | 46677.2 ± 0.6% | 15122.6 ± 0.1% | 3511.3 ± 0.1% | 501.3 ± 0.4% | 8949.9 ± 0.2% | 1145.4 ± 4.8% | 3.087 | 13.294 | 93.114 | 5.215 | 40.751 |
| hex: canterbury-large/world192.txt | 524290 | 45757.1 ± 1.4% | 15124.7 ± 2.4% | 3580.0 ± 0.3% | 470.2 ± 0.4% | 8959.6 ± 4.5% | 1115.6 ± 2.7% | 3.025 | 12.781 | 97.315 | 5.107 | 41.017 |
| hex: http/html-1kx1024 | 2099200 | 18322.4 ± 0.8% | 12508.1 ± 0.3% | 3206.2 ± 3.1% | 507.3 ± 3.6% | 7390.6 ± 1.1% | 987.4 ± 1.8% | 1.465 | 5.715 | 36.118 | 2.479 | 18.555 |
| hex: http/html-16kx64 | 2097280 | 35822.3 ± 0.7% | 14095.6 ± 0.2% | 3431.0 ± 0.1% | 515.8 ± 0.3% | 8516.5 ± 1.0% | 1096.6 ± 2.9% | 2.541 | 10.441 | 69.452 | 4.206 | 32.665 |
| hex: http/html-1m | 524290 | 46445.6 ± 0.6% | 15120.1 ± 0.1% | 3509.9 ± 3.5% | 509.3 ± 0.2% | 8947.1 ± 0.2% | 1141.9 ± 3.1% | 3.072 | 13.233 | 91.190 | 5.191 | 40.673 |
| hex: http/json-1kx1024 | 2099200 | 18130.4 ± 2.1% | 12141.1 ± 0.3% | 3208.7 ± 0.4% | 672.0 ± 0.9% | 7415.4 ± 1.7% | 1003.9 ± 1.4% | 1.493 | 5.650 | 26.982 | 2.445 | 18.060 |
| hex: http/json-16kx64 | 2097280 | 35478.7 ± 3.4% | 13955.9 ± 0.4% | 3426.7 ± 3.3% | 687.2 ± 0.7% | 8638.6 ± 0.6% | 1110.8 ± 2.5% | 2.542 | 10.354 | 51.630 | 4.107 | 31.939 |
| hex: http/json-1m | 524290 | 47637.8 ± 0.3% | 15123.1 ± 0.1% | 3573.5 ± 0.1% | 701.3 ± 0.6% | 8957.0 ± 0.1% | 1142.2 ± 1.9% | 3.150 | 13.331 | 67.929 | 5.319 | 41.708 |
| hex: http/js-1kx1024 | 2099200 | 17885.4 ± 3.3% | 12875.3 ± 0.5% | 3211.1 ± 0.1% | 491.5 ± 0.4% | 7432.3 ± 2.2% | 1006.2 ± 2.5% | 1.389 | 5.570 | 36.389 | 2.406 | 17.775 |
| hex: http/js-16kx64 | 2097280 | 35117.7 ± 1.1% | 14243.9 ± 0.2% | 3426.8 ± 0.1% | 495.8 ± 1.5% | 8757.2 ± 6.1% | 1087.0 ± 2.2% | 2.465 | 10.248 | 70.835 | 4.010 | 32.306 |
| hex: http/js-1m | 524290 | 46265.4 ± 0.3% | 15137.3 ± 0.1% | 3530.2 ± 3.3% | 515.4 ± 0.5% | 8962.8 ± 0.2% | 1139.4 ± 1.6% | 3.056 | 13.106 | 89.772 | 5.162 | 40.606 |
| hex: http/css-1kx1024 | 2099200 | 17889.2 ± 3.3% | 12028.8 ± 1.8% | 3205.6 ± 3.0% | 572.5 ± 0.2% | 7414.0 ± 1.2% | 1011.5 ± 1.4% | 1.487 | 5.581 | 31.249 | 2.413 | 17.685 |
| hex: http/css-16kx64 | 2097280 | 34006.1 ± 0.5% | 14000.1 ± 0.4% | 3417.2 ± 0.1% | 583.1 ± 0.4% | 7692.9 ± 4.5% | 1109.0 ± 5.7% | 2.429 | 9.952 | 58.322 | 4.420 | 30.663 |
| hex: http/css-1m | 524290 | 42795.8 ± 0.1% | 15130.5 ± 0.2% | 3577.6 ± 0.1% | 563.1 ± 0.4% | 8958.4 ± 0.2% | 1139.7 ± 1.3% | 2.828 | 11.962 | 75.996 | 4.777 | 37.550 |
| hex: shuffled/dickens-1m | 524290 | 47521.6 ± 0.4% | 15122.3 ± 0.1% | 3511.6 ± 3.4% | 478.2 ± 0.5% | 8943.9 ± 0.1% | 1144.1 ± 4.1% | 3.142 | 13.533 | 99.386 | 5.313 | 41.536 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1768.9 ± 4.1% | 1482.4 ± 0.4% | 1036.2 ± 0.3% | 467.1 ± 0.3% | 444.8 ± 1.1% | 504.1 ± 1.4% | 1.193 | 1.707 | 3.787 | 3.977 | 3.509 |
| qlog records, JSON text sequence | 1467503 | 1701.2 ± 0.6% | 1224.0 ± 2.0% | 948.5 ± 3.1% | 431.4 ± 3.4% | 541.8 ± 0.8% | 355.7 ± 2.0% | 1.390 | 1.794 | 3.944 | 3.140 | 4.783 |
| messages: 11 string members | 1025025 | 1335.6 ± 0.5% | 1117.7 ± 1.8% | 774.4 ± 0.5% | 406.7 ± 0.5% | 422.6 ± 0.3% | 438.4 ± 0.6% | 1.195 | 1.725 | 3.284 | 3.160 | 3.046 |
| messages: 50 nested objects | 1121600 | 2021.1 ± 0.4% | 1901.2 ± 0.3% | 1365.3 ± 0.7% | 602.7 ± 0.9% | 609.2 ± 6.7% | 526.8 ± 0.9% | 1.063 | 1.480 | 3.354 | 3.318 | 3.837 |
| messages: a tree of 341 objects | 612600 | 615.8 ± 1.8% | 691.3 ± 3.4% | 578.8 ± 0.4% | 339.5 ± 0.5% | 353.0 ± 1.0% | 221.6 ± 0.7% | 0.891 | 1.064 | 1.814 | 1.745 | 2.779 |
| string: silesia/dickens | 172528 | 13109.1 ± 0.9% | 3984.0 ± 0.8% | 3098.1 ± 1.0% | 334.4 ± 0.9% | 1515.8 ± 1.5% | 1190.3 ± 2.4% | 3.290 | 4.231 | 39.206 | 8.648 | 11.013 |
| string: silesia/nci | 1075110 | 11377.0 ± 0.3% | 4675.8 ± 0.1% | 3133.1 ± 0.1% | 914.0 ± 0.4% | 1592.0 ± 1.6% | 1200.8 ± 0.2% | 2.433 | 3.631 | 12.448 | 7.146 | 9.474 |
| string: silesia/reymont | 1075159 | 5299.3 ± 2.1% | 1877.4 ± 0.4% | 1893.2 ± 3.0% | 378.7 ± 0.5% | 1300.8 ± 3.4% | 1050.2 ± 1.1% | 2.823 | 2.799 | 13.992 | 4.074 | 5.046 |
| string: silesia/samba | 97582 | 6350.4 ± 0.5% | 2706.0 ± 0.4% | 4087.7 ± 0.1% | 350.5 ± 0.7% | 1274.7 ± 0.8% | 1187.1 ± 1.1% | 2.347 | 1.554 | 18.120 | 4.982 | 5.350 |
| string: silesia/webster | 1098490 | 7098.2 ± 0.6% | 1999.0 ± 0.6% | 1769.0 ± 1.6% | 352.5 ± 0.3% | 1280.9 ± 0.5% | 604.0 ± 0.2% | 3.551 | 4.013 | 20.137 | 5.542 | 11.752 |
| string: silesia/xml | 1090118 | 10574.7 ± 0.8% | 3268.4 ± 0.5% | 2534.7 ± 0.2% | 609.1 ± 0.4% | 1721.1 ± 1.4% | 964.2 ± 0.6% | 3.235 | 4.172 | 17.360 | 6.144 | 10.968 |
| string: canterbury/alice29.txt | 159425 | 12762.4 ± 0.4% | 2896.5 ± 0.3% | 3074.9 ± 0.7% | 316.5 ± 1.8% | 1370.5 ± 0.4% | 1090.2 ± 1.0% | 4.406 | 4.151 | 40.328 | 9.312 | 11.706 |
| string: canterbury/asyoulik.txt | 132198 | 11013.2 ± 2.1% | 2108.6 ± 0.6% | 3140.0 ± 1.6% | 316.1 ± 2.1% | 1220.3 ± 1.2% | 969.5 ± 1.0% | 5.223 | 3.507 | 34.837 | 9.025 | 11.360 |
| string: canterbury/lcet10.txt | 441884 | 12779.3 ± 1.4% | 3094.6 ± 1.3% | 2598.4 ± 0.5% | 368.8 ± 1.1% | 1464.7 ± 1.9% | 1194.7 ± 0.8% | 4.130 | 4.918 | 34.654 | 8.725 | 10.696 |
| string: canterbury/plrabn12.txt | 503330 | 8914.6 ± 1.9% | 2327.4 ± 0.3% | 2103.3 ± 1.2% | 348.5 ± 0.7% | 1377.9 ± 1.7% | 1128.3 ± 1.4% | 3.830 | 4.238 | 25.583 | 6.470 | 7.901 |
| string: canterbury-large/E.coli | 1048578 | 29761.4 ± 1.2% | 15708.6 ± 0.4% | 3506.8 ± 0.2% | 1704.8 ± 0.2% | 2916.2 ± 3.9% | 1422.5 ± 0.5% | 1.895 | 8.487 | 17.457 | 10.206 | 20.923 |
| string: canterbury-large/bible.txt | 1055886 | 9713.3 ± 0.4% | 4899.6 ± 0.3% | 3017.4 ± 0.4% | 408.8 ± 0.6% | 2023.1 ± 2.2% | 1492.5 ± 2.1% | 1.982 | 3.219 | 23.762 | 4.801 | 6.508 |
| string: canterbury-large/world192.txt | 1103121 | 6666.5 ± 3.3% | 1744.5 ± 0.4% | 1892.3 ± 2.1% | 347.1 ± 2.2% | 1282.3 ± 1.2% | 966.9 ± 0.2% | 3.821 | 3.523 | 19.207 | 5.199 | 6.895 |
| string: http/html-1m | 1058582 | 10156.9 ± 0.6% | 4406.6 ± 2.1% | 2898.1 ± 1.3% | 422.8 ± 0.4% | 2030.8 ± 1.4% | 855.3 ± 0.3% | 2.305 | 3.505 | 24.021 | 5.001 | 11.876 |
| string: http/json-1m | 1190272 | 8614.9 ± 0.3% | 1589.2 ± 0.3% | 1589.6 ± 2.0% | 557.5 ± 0.9% | 1025.6 ± 3.6% | 853.9 ± 0.9% | 5.421 | 5.419 | 15.452 | 8.400 | 10.089 |
| string: http/js-1m | 1144362 | 6584.8 ± 1.6% | 1131.0 ± 0.3% | 1393.2 ± 0.2% | 332.3 ± 0.2% | 1038.3 ± 1.0% | 764.9 ± 0.5% | 5.822 | 4.726 | 19.816 | 6.342 | 8.608 |
| string: http/css-1m | 1097820 | 9288.2 ± 0.5% | 1504.3 ± 0.2% | 2307.7 ± 0.6% | 512.7 ± 0.5% | 1119.6 ± 2.4% | 887.1 ± 0.5% | 6.174 | 4.025 | 18.116 | 8.296 | 10.470 |
| string: dickens as Cyrillic and CJK | 1883069 | 5522.1 ± 0.2% | 3683.0 ± 0.2% | 490.7 ± 0.5% | 248.4 ± 2.6% | 458.8 ± 0.2% | 358.8 ± 0.9% | 1.499 | 11.252 | 22.230 | 12.035 | 15.391 |
| hex: silesia/dickens | 524290 | 42677.4 ± 1.8% | 2601.3 ± 3.2% | 1515.7 ± 0.0% | 466.2 ± 0.3% | 1571.8 ± 0.6% | 1067.0 ± 0.2% | 16.406 | 28.158 | 91.551 | 27.152 | 39.998 |
| hex: silesia/mozilla | 524290 | 43838.0 ± 0.2% | 2601.4 ± 6.1% | 1485.2 ± 5.0% | 389.2 ± 1.2% | 1565.9 ± 0.3% | 1071.7 ± 0.5% | 16.851 | 29.517 | 112.624 | 27.995 | 40.904 |
| hex: silesia/mr | 524290 | 43750.9 ± 0.2% | 2589.9 ± 9.5% | 1508.1 ± 0.4% | 596.6 ± 0.3% | 1538.2 ± 1.0% | 1073.7 ± 0.2% | 16.893 | 29.011 | 73.336 | 28.443 | 40.749 |
| hex: silesia/nci | 524290 | 43954.8 ± 0.0% | 2583.8 ± 0.2% | 1508.3 ± 0.1% | 760.4 ± 0.1% | 1573.1 ± 0.3% | 1073.9 ± 0.1% | 17.012 | 29.142 | 57.803 | 27.942 | 40.932 |
| hex: silesia/ooffice | 524290 | 43716.6 ± 0.2% | 2605.2 ± 0.2% | 1514.9 ± 0.1% | 323.8 ± 1.8% | 1546.8 ± 0.3% | 1072.0 ± 0.2% | 16.781 | 28.857 | 135.032 | 28.263 | 40.782 |
| hex: silesia/osdb | 524290 | 42309.3 ± 0.1% | 2599.1 ± 0.1% | 1513.6 ± 1.9% | 431.0 ± 1.5% | 1571.2 ± 0.2% | 1070.0 ± 0.3% | 16.278 | 27.954 | 98.156 | 26.928 | 39.541 |
| hex: silesia/reymont | 524290 | 43843.7 ± 0.1% | 2601.8 ± 0.1% | 1513.3 ± 5.0% | 484.1 ± 3.4% | 1545.7 ± 0.8% | 1072.1 ± 0.1% | 16.851 | 28.973 | 90.570 | 28.365 | 40.896 |
| hex: silesia/samba | 524290 | 43808.8 ± 0.3% | 2599.8 ± 3.5% | 1512.7 ± 3.9% | 337.9 ± 1.0% | 1557.2 ± 2.1% | 1069.9 ± 0.1% | 16.851 | 28.961 | 129.634 | 28.133 | 40.945 |
| hex: silesia/sao | 524290 | 43764.4 ± 0.1% | 2616.0 ± 0.1% | 1513.4 ± 0.1% | 267.2 ± 10.0% | 1545.9 ± 0.2% | 1072.2 ± 0.1% | 16.730 | 28.918 | 163.770 | 28.310 | 40.817 |
| hex: silesia/webster | 524290 | 44200.6 ± 0.1% | 2609.6 ± 0.2% | 1516.7 ± 0.1% | 437.8 ± 0.1% | 1579.7 ± 0.2% | 1071.3 ± 0.3% | 16.938 | 29.143 | 100.950 | 27.980 | 41.260 |
| hex: silesia/x-ray | 524290 | 43879.6 ± 0.1% | 2618.8 ± 0.5% | 1515.9 ± 0.1% | 425.3 ± 0.5% | 1572.5 ± 0.4% | 1073.7 ± 0.2% | 16.755 | 28.946 | 103.176 | 27.904 | 40.868 |
| hex: silesia/xml | 524290 | 43945.8 ± 0.4% | 2607.5 ± 0.3% | 1515.7 ± 0.1% | 692.7 ± 0.2% | 1570.9 ± 0.8% | 1070.1 ± 0.5% | 16.854 | 28.993 | 63.443 | 27.975 | 41.068 |
| hex: canterbury/alice29.txt | 304180 | 41826.7 ± 1.0% | 2626.1 ± 0.2% | 1531.7 ± 0.1% | 470.7 ± 0.2% | 1562.0 ± 1.4% | 1091.9 ± 0.4% | 15.927 | 27.307 | 88.853 | 26.778 | 38.308 |
| hex: canterbury/asyoulik.txt | 250360 | 43789.2 ± 0.1% | 2631.0 ± 3.8% | 1543.9 ± 1.3% | 459.4 ± 0.2% | 1570.9 ± 0.8% | 1091.7 ± 0.2% | 16.644 | 28.362 | 95.310 | 27.875 | 40.110 |
| hex: canterbury/cp.html | 49208 | 42741.9 ± 0.2% | 2604.5 ± 0.5% | 1531.1 ± 0.1% | 481.9 ± 0.5% | 1593.3 ± 0.2% | 1096.8 ± 0.1% | 16.411 | 27.917 | 88.694 | 26.825 | 38.970 |
| hex: canterbury/fields.c | 22302 | 40005.6 ± 0.1% | 2647.0 ± 0.1% | 1537.7 ± 0.4% | 601.2 ± 0.7% | 1609.2 ± 0.2% | 1104.7 ± 0.1% | 15.113 | 26.016 | 66.546 | 24.861 | 36.215 |
| hex: canterbury/grammar.lsp | 7444 | 39339.7 ± 0.2% | 2718.2 ± 0.2% | 1546.6 ± 0.1% | 819.1 ± 0.4% | 1619.1 ± 0.1% | 1114.5 ± 0.1% | 14.473 | 25.437 | 48.028 | 24.297 | 35.297 |
| hex: canterbury/kennedy.xls | 524290 | 43845.4 ± 0.1% | 2595.3 ± 0.1% | 1510.5 ± 0.1% | 794.1 ± 0.4% | 1571.9 ± 0.2% | 1074.3 ± 0.3% | 16.894 | 29.027 | 55.214 | 27.893 | 40.812 |
| hex: canterbury/lcet10.txt | 524290 | 43884.4 ± 0.1% | 2592.5 ± 0.4% | 1512.3 ± 0.1% | 470.2 ± 0.1% | 1572.7 ± 0.2% | 1074.0 ± 0.9% | 16.927 | 29.018 | 93.327 | 27.904 | 40.862 |
| hex: canterbury/plrabn12.txt | 524290 | 43877.7 ± 0.1% | 2603.2 ± 0.1% | 1513.4 ± 0.1% | 455.8 ± 0.2% | 1563.8 ± 0.7% | 1071.6 ± 0.3% | 16.855 | 28.994 | 96.275 | 28.058 | 40.945 |
| hex: canterbury/ptt5 | 524290 | 43869.4 ± 0.1% | 2582.4 ± 0.2% | 1508.1 ± 0.5% | 594.2 ± 0.8% | 1535.0 ± 0.7% | 1072.9 ± 0.1% | 16.988 | 29.089 | 73.834 | 28.579 | 40.890 |
| hex: canterbury/sum | 76482 | 43141.2 ± 6.7% | 2610.4 ± 0.4% | 1524.8 ± 0.2% | 562.8 ± 0.1% | 1587.2 ± 0.2% | 1094.7 ± 0.2% | 16.527 | 28.294 | 76.655 | 27.181 | 39.409 |
| hex: canterbury/xargs.1 | 8456 | 40373.0 ± 0.2% | 2692.7 ± 0.5% | 1546.8 ± 0.1% | 843.5 ± 0.4% | 1615.9 ± 0.3% | 1115.8 ± 1.2% | 14.993 | 26.102 | 47.862 | 24.985 | 36.184 |
| hex: canterbury-large/E.coli | 524290 | 41916.4 ± 0.3% | 2592.0 ± 0.3% | 1510.7 ± 0.1% | 818.6 ± 0.2% | 1564.3 ± 0.5% | 1071.0 ± 0.2% | 16.171 | 27.746 | 51.205 | 26.796 | 39.137 |
| hex: canterbury-large/bible.txt | 524290 | 43902.6 ± 0.2% | 2607.3 ± 0.2% | 1511.9 ± 0.9% | 484.0 ± 0.2% | 1567.8 ± 0.4% | 1073.1 ± 0.0% | 16.838 | 29.038 | 90.709 | 28.003 | 40.913 |
| hex: canterbury-large/world192.txt | 524290 | 43595.7 ± 0.3% | 2602.5 ± 0.5% | 1516.8 ± 0.1% | 462.3 ± 0.4% | 1564.1 ± 0.9% | 1071.2 ± 0.4% | 16.751 | 28.742 | 94.300 | 27.873 | 40.699 |
| hex: http/html-1kx1024 | 2099200 | 21800.9 ± 0.2% | 2384.8 ± 1.4% | 1523.2 ± 0.2% | 502.3 ± 0.2% | 1512.8 ± 0.8% | 1081.8 ± 0.8% | 9.142 | 14.313 | 43.400 | 14.411 | 20.152 |
| hex: http/html-16kx64 | 2097280 | 22069.7 ± 0.3% | 2237.9 ± 0.2% | 1524.7 ± 0.1% | 505.8 ± 0.2% | 1457.4 ± 0.1% | 1089.5 ± 0.3% | 9.862 | 14.475 | 43.633 | 15.143 | 20.257 |
| hex: http/html-1m | 524290 | 43860.9 ± 0.1% | 2615.6 ± 0.1% | 1516.6 ± 0.0% | 493.7 ± 0.2% | 1572.2 ± 0.4% | 1070.2 ± 0.2% | 16.769 | 28.921 | 88.834 | 27.897 | 40.984 |
| hex: http/json-1kx1024 | 2099200 | 21082.1 ± 0.4% | 2373.0 ± 2.7% | 1520.7 ± 0.3% | 698.5 ± 0.2% | 1510.4 ± 6.7% | 1081.2 ± 0.2% | 8.884 | 13.863 | 30.183 | 13.958 | 19.499 |
| hex: http/json-16kx64 | 2097280 | 21697.2 ± 0.2% | 2235.5 ± 0.3% | 1522.8 ± 0.1% | 708.8 ± 0.2% | 1455.0 ± 0.1% | 1089.5 ± 0.4% | 9.706 | 14.248 | 30.609 | 14.912 | 19.914 |
| hex: http/json-1m | 524290 | 43784.4 ± 0.1% | 2596.0 ± 0.2% | 1509.0 ± 0.1% | 728.6 ± 0.1% | 1515.4 ± 0.6% | 1069.9 ± 0.1% | 16.866 | 29.015 | 60.098 | 28.894 | 40.923 |
| hex: http/js-1kx1024 | 2099200 | 20786.3 ± 0.5% | 2378.9 ± 1.7% | 1521.5 ± 0.4% | 491.9 ± 0.2% | 1512.8 ± 0.7% | 1080.9 ± 0.9% | 8.738 | 13.662 | 42.256 | 13.740 | 19.230 |
| hex: http/js-16kx64 | 2097280 | 21217.4 ± 0.2% | 2236.1 ± 0.8% | 1524.3 ± 0.1% | 494.8 ± 0.2% | 1458.8 ± 0.1% | 1090.4 ± 0.2% | 9.488 | 13.919 | 42.884 | 14.545 | 19.459 |
| hex: http/js-1m | 524290 | 43855.2 ± 0.1% | 2604.1 ± 2.0% | 1511.9 ± 0.1% | 508.5 ± 0.1% | 1568.1 ± 0.4% | 1075.2 ± 0.3% | 16.841 | 29.007 | 86.236 | 27.967 | 40.787 |
| hex: http/css-1kx1024 | 2099200 | 21148.3 ± 0.5% | 2368.8 ± 1.8% | 1521.8 ± 0.4% | 559.5 ± 0.4% | 1511.8 ± 0.5% | 1082.5 ± 0.3% | 8.928 | 13.897 | 37.796 | 13.989 | 19.537 |
| hex: http/css-16kx64 | 2097280 | 22047.7 ± 0.3% | 2232.6 ± 0.2% | 1524.4 ± 0.2% | 566.1 ± 0.3% | 1458.1 ± 0.1% | 1089.3 ± 0.4% | 9.875 | 14.463 | 38.943 | 15.120 | 20.241 |
| hex: http/css-1m | 524290 | 43847.5 ± 0.0% | 2590.5 ± 10.7% | 1514.9 ± 0.2% | 540.5 ± 0.2% | 1570.2 ± 0.8% | 1073.9 ± 0.1% | 16.926 | 28.944 | 81.122 | 27.924 | 40.830 |
| hex: shuffled/dickens-1m | 524290 | 42632.9 ± 0.3% | 2607.8 ± 0.0% | 1516.2 ± 5.9% | 465.7 ± 0.3% | 1563.5 ± 1.4% | 1076.7 ± 0.3% | 16.348 | 28.118 | 91.540 | 27.267 | 39.596 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1817.1 ± 0.1% | 1482.4 ± 0.4% | 1036.2 ± 0.3% | 467.1 ± 0.3% | 444.8 ± 1.1% | 504.1 ± 1.4% | 1.226 | 1.754 | 3.890 | 4.085 | 3.605 |
| qlog records, JSON text sequence | 1467503 | 1734.9 ± 0.4% | 1224.0 ± 2.0% | 948.5 ± 3.1% | 431.4 ± 3.4% | 541.8 ± 0.8% | 355.7 ± 2.0% | 1.417 | 1.829 | 4.022 | 3.202 | 4.877 |
| messages: 11 string members | 1025025 | 1333.0 ± 0.2% | 1117.7 ± 1.8% | 774.4 ± 0.5% | 406.7 ± 0.5% | 422.6 ± 0.3% | 438.4 ± 0.6% | 1.193 | 1.721 | 3.277 | 3.154 | 3.040 |
| messages: 50 nested objects | 1121600 | 2027.5 ± 0.3% | 1901.2 ± 0.3% | 1365.3 ± 0.7% | 602.7 ± 0.9% | 609.2 ± 6.7% | 526.8 ± 0.9% | 1.066 | 1.485 | 3.364 | 3.328 | 3.849 |
| messages: a tree of 341 objects | 612600 | 653.5 ± 0.3% | 691.3 ± 3.4% | 578.8 ± 0.4% | 339.5 ± 0.5% | 353.0 ± 1.0% | 221.6 ± 0.7% | 0.945 | 1.129 | 1.925 | 1.851 | 2.949 |
| string: silesia/dickens | 172528 | 13488.5 ± 0.6% | 3984.0 ± 0.8% | 3098.1 ± 1.0% | 334.4 ± 0.9% | 1515.8 ± 1.5% | 1190.3 ± 2.4% | 3.386 | 4.354 | 40.341 | 8.899 | 11.332 |
| string: silesia/nci | 1075110 | 11726.6 ± 0.6% | 4675.8 ± 0.1% | 3133.1 ± 0.1% | 914.0 ± 0.4% | 1592.0 ± 1.6% | 1200.8 ± 0.2% | 2.508 | 3.743 | 12.831 | 7.366 | 9.765 |
| string: silesia/reymont | 1075159 | 5466.3 ± 0.4% | 1877.4 ± 0.4% | 1893.2 ± 3.0% | 378.7 ± 0.5% | 1300.8 ± 3.4% | 1050.2 ± 1.1% | 2.912 | 2.887 | 14.433 | 4.202 | 5.205 |
| string: silesia/samba | 97582 | 7337.9 ± 1.0% | 2706.0 ± 0.4% | 4087.7 ± 0.1% | 350.5 ± 0.7% | 1274.7 ± 0.8% | 1187.1 ± 1.1% | 2.712 | 1.795 | 20.938 | 5.757 | 6.181 |
| string: silesia/webster | 1098490 | 7010.0 ± 0.2% | 1999.0 ± 0.6% | 1769.0 ± 1.6% | 352.5 ± 0.3% | 1280.9 ± 0.5% | 604.0 ± 0.2% | 3.507 | 3.963 | 19.887 | 5.473 | 11.606 |
| string: silesia/xml | 1090118 | 10880.4 ± 0.5% | 3268.4 ± 0.5% | 2534.7 ± 0.2% | 609.1 ± 0.4% | 1721.1 ± 1.4% | 964.2 ± 0.6% | 3.329 | 4.293 | 17.862 | 6.322 | 11.285 |
| string: canterbury/alice29.txt | 159425 | 13403.8 ± 3.6% | 2896.5 ± 0.3% | 3074.9 ± 0.7% | 316.5 ± 1.8% | 1370.5 ± 0.4% | 1090.2 ± 1.0% | 4.628 | 4.359 | 42.355 | 9.780 | 12.294 |
| string: canterbury/asyoulik.txt | 132198 | 11516.9 ± 1.3% | 2108.6 ± 0.6% | 3140.0 ± 1.6% | 316.1 ± 2.1% | 1220.3 ± 1.2% | 969.5 ± 1.0% | 5.462 | 3.668 | 36.431 | 9.437 | 11.879 |
| string: canterbury/lcet10.txt | 441884 | 12733.9 ± 1.3% | 3094.6 ± 1.3% | 2598.4 ± 0.5% | 368.8 ± 1.1% | 1464.7 ± 1.9% | 1194.7 ± 0.8% | 4.115 | 4.901 | 34.531 | 8.694 | 10.658 |
| string: canterbury/plrabn12.txt | 503330 | 9087.6 ± 2.0% | 2327.4 ± 0.3% | 2103.3 ± 1.2% | 348.5 ± 0.7% | 1377.9 ± 1.7% | 1128.3 ± 1.4% | 3.905 | 4.321 | 26.079 | 6.595 | 8.054 |
| string: canterbury-large/E.coli | 1048578 | 29755.2 ± 1.4% | 15708.6 ± 0.4% | 3506.8 ± 0.2% | 1704.8 ± 0.2% | 2916.2 ± 3.9% | 1422.5 ± 0.5% | 1.894 | 8.485 | 17.453 | 10.204 | 20.918 |
| string: canterbury-large/bible.txt | 1055886 | 9902.7 ± 0.4% | 4899.6 ± 0.3% | 3017.4 ± 0.4% | 408.8 ± 0.6% | 2023.1 ± 2.2% | 1492.5 ± 2.1% | 2.021 | 3.282 | 24.225 | 4.895 | 6.635 |
| string: canterbury-large/world192.txt | 1103121 | 6505.9 ± 0.3% | 1744.5 ± 0.4% | 1892.3 ± 2.1% | 347.1 ± 2.2% | 1282.3 ± 1.2% | 966.9 ± 0.2% | 3.729 | 3.438 | 18.744 | 5.074 | 6.729 |
| string: http/html-1m | 1058582 | 10250.6 ± 0.5% | 4406.6 ± 2.1% | 2898.1 ± 1.3% | 422.8 ± 0.4% | 2030.8 ± 1.4% | 855.3 ± 0.3% | 2.326 | 3.537 | 24.243 | 5.047 | 11.985 |
| string: http/json-1m | 1190272 | 8779.8 ± 0.4% | 1589.2 ± 0.3% | 1589.6 ± 2.0% | 557.5 ± 0.9% | 1025.6 ± 3.6% | 853.9 ± 0.9% | 5.525 | 5.523 | 15.747 | 8.560 | 10.282 |
| string: http/js-1m | 1144362 | 6674.6 ± 0.2% | 1131.0 ± 0.3% | 1393.2 ± 0.2% | 332.3 ± 0.2% | 1038.3 ± 1.0% | 764.9 ± 0.5% | 5.902 | 4.791 | 20.087 | 6.429 | 8.726 |
| string: http/css-1m | 1097820 | 9210.7 ± 6.7% | 1504.3 ± 0.2% | 2307.7 ± 0.6% | 512.7 ± 0.5% | 1119.6 ± 2.4% | 887.1 ± 0.5% | 6.123 | 3.991 | 17.964 | 8.227 | 10.383 |
| string: dickens as Cyrillic and CJK | 1883069 | 5718.6 ± 0.3% | 3683.0 ± 0.2% | 490.7 ± 0.5% | 248.4 ± 2.6% | 458.8 ± 0.2% | 358.8 ± 0.9% | 1.553 | 11.653 | 23.021 | 12.464 | 15.938 |
| hex: silesia/dickens | 524290 | 42774.3 ± 0.3% | 2601.3 ± 3.2% | 1515.7 ± 0.0% | 466.2 ± 0.3% | 1571.8 ± 0.6% | 1067.0 ± 0.2% | 16.443 | 28.222 | 91.759 | 27.214 | 40.089 |
| hex: silesia/mozilla | 524290 | 43866.2 ± 0.0% | 2601.4 ± 6.1% | 1485.2 ± 5.0% | 389.2 ± 1.2% | 1565.9 ± 0.3% | 1071.7 ± 0.5% | 16.862 | 29.536 | 112.696 | 28.013 | 40.930 |
| hex: silesia/mr | 524290 | 43813.1 ± 0.0% | 2589.9 ± 9.5% | 1508.1 ± 0.4% | 596.6 ± 0.3% | 1538.2 ± 1.0% | 1073.7 ± 0.2% | 16.917 | 29.052 | 73.441 | 28.484 | 40.807 |
| hex: silesia/nci | 524290 | 43952.1 ± 0.1% | 2583.8 ± 0.2% | 1508.3 ± 0.1% | 760.4 ± 0.1% | 1573.1 ± 0.3% | 1073.9 ± 0.1% | 17.010 | 29.140 | 57.800 | 27.940 | 40.929 |
| hex: silesia/ooffice | 524290 | 43742.4 ± 0.3% | 2605.2 ± 0.2% | 1514.9 ± 0.1% | 323.8 ± 1.8% | 1546.8 ± 0.3% | 1072.0 ± 0.2% | 16.791 | 28.874 | 135.112 | 28.279 | 40.806 |
| hex: silesia/osdb | 524290 | 42343.0 ± 0.2% | 2599.1 ± 0.1% | 1513.6 ± 1.9% | 431.0 ± 1.5% | 1571.2 ± 0.2% | 1070.0 ± 0.3% | 16.291 | 27.976 | 98.234 | 26.950 | 39.573 |
| hex: silesia/reymont | 524290 | 43870.2 ± 0.1% | 2601.8 ± 0.1% | 1513.3 ± 5.0% | 484.1 ± 3.4% | 1545.7 ± 0.8% | 1072.1 ± 0.1% | 16.862 | 28.990 | 90.625 | 28.382 | 40.921 |
| hex: silesia/samba | 524290 | 43847.6 ± 0.2% | 2599.8 ± 3.5% | 1512.7 ± 3.9% | 337.9 ± 1.0% | 1557.2 ± 2.1% | 1069.9 ± 0.1% | 16.866 | 28.987 | 129.749 | 28.157 | 40.981 |
| hex: silesia/sao | 524290 | 43808.0 ± 0.1% | 2616.0 ± 0.1% | 1513.4 ± 0.1% | 267.2 ± 10.0% | 1545.9 ± 0.2% | 1072.2 ± 0.1% | 16.746 | 28.947 | 163.933 | 28.338 | 40.858 |
| hex: silesia/webster | 524290 | 44196.5 ± 0.1% | 2609.6 ± 0.2% | 1516.7 ± 0.1% | 437.8 ± 0.1% | 1579.7 ± 0.2% | 1071.3 ± 0.3% | 16.936 | 29.141 | 100.941 | 27.977 | 41.256 |
| hex: silesia/x-ray | 524290 | 43897.9 ± 0.3% | 2618.8 ± 0.5% | 1515.9 ± 0.1% | 425.3 ± 0.5% | 1572.5 ± 0.4% | 1073.7 ± 0.2% | 16.762 | 28.959 | 103.219 | 27.915 | 40.885 |
| hex: silesia/xml | 524290 | 43943.0 ± 0.2% | 2607.5 ± 0.3% | 1515.7 ± 0.1% | 692.7 ± 0.2% | 1570.9 ± 0.8% | 1070.1 ± 0.5% | 16.852 | 28.991 | 63.439 | 27.973 | 41.066 |
| hex: canterbury/alice29.txt | 304180 | 41896.2 ± 0.0% | 2626.1 ± 0.2% | 1531.7 ± 0.1% | 470.7 ± 0.2% | 1562.0 ± 1.4% | 1091.9 ± 0.4% | 15.954 | 27.352 | 89.001 | 26.822 | 38.372 |
| hex: canterbury/asyoulik.txt | 250360 | 43798.4 ± 0.1% | 2631.0 ± 3.8% | 1543.9 ± 1.3% | 459.4 ± 0.2% | 1570.9 ± 0.8% | 1091.7 ± 0.2% | 16.647 | 28.368 | 95.330 | 27.881 | 40.118 |
| hex: canterbury/cp.html | 49208 | 42851.1 ± 0.4% | 2604.5 ± 0.5% | 1531.1 ± 0.1% | 481.9 ± 0.5% | 1593.3 ± 0.2% | 1096.8 ± 0.1% | 16.453 | 27.988 | 88.920 | 26.894 | 39.070 |
| hex: canterbury/fields.c | 22302 | 40065.2 ± 0.2% | 2647.0 ± 0.1% | 1537.7 ± 0.4% | 601.2 ± 0.7% | 1609.2 ± 0.2% | 1104.7 ± 0.1% | 15.136 | 26.055 | 66.645 | 24.898 | 36.269 |
| hex: canterbury/grammar.lsp | 7444 | 39807.2 ± 0.3% | 2718.2 ± 0.2% | 1546.6 ± 0.1% | 819.1 ± 0.4% | 1619.1 ± 0.1% | 1114.5 ± 0.1% | 14.645 | 25.739 | 48.599 | 24.585 | 35.717 |
| hex: canterbury/kennedy.xls | 524290 | 43865.5 ± 0.2% | 2595.3 ± 0.1% | 1510.5 ± 0.1% | 794.1 ± 0.4% | 1571.9 ± 0.2% | 1074.3 ± 0.3% | 16.902 | 29.041 | 55.240 | 27.906 | 40.831 |
| hex: canterbury/lcet10.txt | 524290 | 43939.0 ± 0.1% | 2592.5 ± 0.4% | 1512.3 ± 0.1% | 470.2 ± 0.1% | 1572.7 ± 0.2% | 1074.0 ± 0.9% | 16.948 | 29.054 | 93.443 | 27.939 | 40.913 |
| hex: canterbury/plrabn12.txt | 524290 | 43906.9 ± 0.1% | 2603.2 ± 0.1% | 1513.4 ± 0.1% | 455.8 ± 0.2% | 1563.8 ± 0.7% | 1071.6 ± 0.3% | 16.867 | 29.013 | 96.339 | 28.077 | 40.972 |
| hex: canterbury/ptt5 | 524290 | 43878.4 ± 0.1% | 2582.4 ± 0.2% | 1508.1 ± 0.5% | 594.2 ± 0.8% | 1535.0 ± 0.7% | 1072.9 ± 0.1% | 16.991 | 29.095 | 73.849 | 28.585 | 40.899 |
| hex: canterbury/sum | 76482 | 43169.5 ± 0.1% | 2610.4 ± 0.4% | 1524.8 ± 0.2% | 562.8 ± 0.1% | 1587.2 ± 0.2% | 1094.7 ± 0.2% | 16.538 | 28.312 | 76.706 | 27.199 | 39.435 |
| hex: canterbury/xargs.1 | 8456 | 40560.9 ± 0.6% | 2692.7 ± 0.5% | 1546.8 ± 0.1% | 843.5 ± 0.4% | 1615.9 ± 0.3% | 1115.8 ± 1.2% | 15.063 | 26.223 | 48.085 | 25.101 | 36.352 |
| hex: canterbury-large/E.coli | 524290 | 41983.0 ± 0.8% | 2592.0 ± 0.3% | 1510.7 ± 0.1% | 818.6 ± 0.2% | 1564.3 ± 0.5% | 1071.0 ± 0.2% | 16.197 | 27.790 | 51.286 | 26.839 | 39.199 |
| hex: canterbury-large/bible.txt | 524290 | 43913.9 ± 0.1% | 2607.3 ± 0.2% | 1511.9 ± 0.9% | 484.0 ± 0.2% | 1567.8 ± 0.4% | 1073.1 ± 0.0% | 16.843 | 29.046 | 90.733 | 28.010 | 40.924 |
| hex: canterbury-large/world192.txt | 524290 | 43664.3 ± 0.1% | 2602.5 ± 0.5% | 1516.8 ± 0.1% | 462.3 ± 0.4% | 1564.1 ± 0.9% | 1071.2 ± 0.4% | 16.778 | 28.788 | 94.449 | 27.917 | 40.763 |
| hex: http/html-1kx1024 | 2099200 | 21889.8 ± 0.3% | 2384.8 ± 1.4% | 1523.2 ± 0.2% | 502.3 ± 0.2% | 1512.8 ± 0.8% | 1081.8 ± 0.8% | 9.179 | 14.371 | 43.577 | 14.470 | 20.234 |
| hex: http/html-16kx64 | 2097280 | 22150.1 ± 0.2% | 2237.9 ± 0.2% | 1524.7 ± 0.1% | 505.8 ± 0.2% | 1457.4 ± 0.1% | 1089.5 ± 0.3% | 9.898 | 14.528 | 43.792 | 15.199 | 20.331 |
| hex: http/html-1m | 524290 | 43807.8 ± 0.2% | 2615.6 ± 0.1% | 1516.6 ± 0.0% | 493.7 ± 0.2% | 1572.2 ± 0.4% | 1070.2 ± 0.2% | 16.748 | 28.886 | 88.726 | 27.863 | 40.935 |
| hex: http/json-1kx1024 | 2099200 | 21207.4 ± 0.2% | 2373.0 ± 2.7% | 1520.7 ± 0.3% | 698.5 ± 0.2% | 1510.4 ± 6.7% | 1081.2 ± 0.2% | 8.937 | 13.945 | 30.362 | 14.041 | 19.615 |
| hex: http/json-16kx64 | 2097280 | 21756.4 ± 0.3% | 2235.5 ± 0.3% | 1522.8 ± 0.1% | 708.8 ± 0.2% | 1455.0 ± 0.1% | 1089.5 ± 0.4% | 9.732 | 14.287 | 30.693 | 14.953 | 19.969 |
| hex: http/json-1m | 524290 | 43819.0 ± 0.1% | 2596.0 ± 0.2% | 1509.0 ± 0.1% | 728.6 ± 0.1% | 1515.4 ± 0.6% | 1069.9 ± 0.1% | 16.879 | 29.038 | 60.145 | 28.916 | 40.956 |
| hex: http/js-1kx1024 | 2099200 | 20914.7 ± 0.2% | 2378.9 ± 1.7% | 1521.5 ± 0.4% | 491.9 ± 0.2% | 1512.8 ± 0.7% | 1080.9 ± 0.9% | 8.792 | 13.746 | 42.517 | 13.825 | 19.348 |
| hex: http/js-16kx64 | 2097280 | 21273.8 ± 3.1% | 2236.1 ± 0.8% | 1524.3 ± 0.1% | 494.8 ± 0.2% | 1458.8 ± 0.1% | 1090.4 ± 0.2% | 9.514 | 13.956 | 42.998 | 14.583 | 19.511 |
| hex: http/js-1m | 524290 | 43917.8 ± 0.3% | 2604.1 ± 2.0% | 1511.9 ± 0.1% | 508.5 ± 0.1% | 1568.1 ± 0.4% | 1075.2 ± 0.3% | 16.865 | 29.048 | 86.359 | 28.007 | 40.846 |
| hex: http/css-1kx1024 | 2099200 | 21261.3 ± 0.3% | 2368.8 ± 1.8% | 1521.8 ± 0.4% | 559.5 ± 0.4% | 1511.8 ± 0.5% | 1082.5 ± 0.3% | 8.976 | 13.971 | 37.998 | 14.064 | 19.642 |
| hex: http/css-16kx64 | 2097280 | 22106.2 ± 0.1% | 2232.6 ± 0.2% | 1524.4 ± 0.2% | 566.1 ± 0.3% | 1458.1 ± 0.1% | 1089.3 ± 0.4% | 9.901 | 14.502 | 39.047 | 15.161 | 20.294 |
| hex: http/css-1m | 524290 | 43885.4 ± 0.0% | 2590.5 ± 10.7% | 1514.9 ± 0.2% | 540.5 ± 0.2% | 1570.2 ± 0.8% | 1073.9 ± 0.1% | 16.941 | 28.969 | 81.192 | 27.949 | 40.865 |
| hex: shuffled/dickens-1m | 524290 | 42699.7 ± 5.0% | 2607.8 ± 0.0% | 1516.2 ± 5.9% | 465.7 ± 0.3% | 1563.5 ± 1.4% | 1076.7 ± 0.3% | 16.374 | 28.162 | 91.683 | 27.310 | 39.658 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1155.3 ± 42.7% | 1541.1 ± 48.4% | 1089.6 ± 55.5% | 392.0 ± 50.1% | 675.8 ± 53.0% | 367.3 ± 66.0% | 0.750 | 1.060 | 2.948 | 1.709 | 3.146 |
| qlog records, JSON text sequence | 1467503 | 1027.4 ± 1.0% | 1244.7 ± 2.5% | 1128.3 ± 0.4% | 328.0 ± 1.0% | 768.8 ± 0.8% | 319.7 ± 0.6% | 0.825 | 0.911 | 3.132 | 1.336 | 3.213 |
| messages: 11 string members | 1025025 | 970.6 ± 0.2% | 2011.3 ± 0.6% | 697.6 ± 4.2% | 340.2 ± 0.4% | 516.7 ± 0.3% | 307.5 ± 1.5% | 0.483 | 1.391 | 2.853 | 1.879 | 3.157 |
| messages: 50 nested objects | 1121600 | 1243.0 ± 0.2% | 1769.9 ± 1.0% | 1428.3 ± 0.0% | 431.5 ± 1.6% | 908.2 ± 0.4% | 425.3 ± 0.5% | 0.702 | 0.870 | 2.881 | 1.369 | 2.923 |
| messages: a tree of 341 objects | 612600 | 545.7 ± 1.1% | 858.7 ± 0.9% | 697.4 ± 1.1% | 183.3 ± 0.6% | 619.4 ± 0.3% | 209.8 ± 0.7% | 0.635 | 0.782 | 2.977 | 0.881 | 2.601 |
| string: silesia/dickens | 172528 | 6741.9 ± 0.1% | 3394.4 ± 3.2% | 2868.2 ± 1.1% | 318.8 ± 0.4% | 3096.5 ± 0.8% | 571.1 ± 1.3% | 1.986 | 2.351 | 21.147 | 2.177 | 11.805 |
| string: silesia/nci | 1075110 | 5473.3 ± 0.1% | 3916.3 ± 0.4% | 3052.1 ± 0.1% | 657.1 ± 0.7% | 3640.6 ± 0.3% | 579.8 ± 0.4% | 1.398 | 1.793 | 8.330 | 1.503 | 9.439 |
| string: silesia/reymont | 1075159 | 3501.8 ± 1.9% | 3420.9 ± 0.3% | 1965.8 ± 2.2% | 344.0 ± 0.3% | 2111.7 ± 0.3% | 497.9 ± 1.2% | 1.024 | 1.781 | 10.180 | 1.658 | 7.034 |
| string: silesia/samba | 97582 | 4009.4 ± 0.3% | 3797.7 ± 0.2% | 3066.5 ± 0.2% | 331.3 ± 1.8% | 1966.0 ± 1.2% | 423.0 ± 1.3% | 1.056 | 1.307 | 12.103 | 2.039 | 9.478 |
| string: silesia/webster | 1098490 | 4384.0 ± 1.0% | 2447.7 ± 0.3% | 1742.7 ± 0.3% | 311.2 ± 0.5% | 2078.4 ± 0.5% | 470.7 ± 1.8% | 1.791 | 2.516 | 14.086 | 2.109 | 9.313 |
| string: silesia/xml | 1090118 | 6054.9 ± 1.3% | 5056.8 ± 0.2% | 2462.0 ± 0.3% | 514.2 ± 0.2% | 3331.1 ± 2.1% | 553.6 ± 2.0% | 1.197 | 2.459 | 11.776 | 1.818 | 10.937 |
| string: canterbury/alice29.txt | 159425 | 5814.0 ± 1.2% | 2785.6 ± 1.8% | 2826.7 ± 1.3% | 302.2 ± 0.2% | 2777.9 ± 1.8% | 522.0 ± 1.5% | 2.087 | 2.057 | 19.242 | 2.093 | 11.138 |
| string: canterbury/asyoulik.txt | 132198 | 4318.0 ± 1.3% | 2644.2 ± 1.2% | 2786.7 ± 1.2% | 307.0 ± 0.3% | 2403.9 ± 0.6% | 457.9 ± 1.3% | 1.633 | 1.550 | 14.065 | 1.796 | 9.430 |
| string: canterbury/lcet10.txt | 441884 | 6660.0 ± 0.7% | 3280.9 ± 0.8% | 2322.3 ± 4.8% | 348.2 ± 0.3% | 2794.2 ± 0.8% | 576.4 ± 0.4% | 2.030 | 2.868 | 19.128 | 2.383 | 11.554 |
| string: canterbury/plrabn12.txt | 503330 | 5506.6 ± 0.1% | 3177.3 ± 0.1% | 1838.0 ± 0.4% | 324.2 ± 0.3% | 2837.7 ± 0.4% | 537.5 ± 1.1% | 1.733 | 2.996 | 16.984 | 1.940 | 10.244 |
| string: canterbury-large/E.coli | 1048578 | 33977.8 ± 0.1% | 13605.9 ± 0.2% | 3456.9 ± 0.2% | 1287.7 ± 0.1% | 8933.1 ± 0.3% | 978.2 ± 1.3% | 2.497 | 9.829 | 26.387 | 3.804 | 34.735 |
| string: canterbury-large/bible.txt | 1055886 | 8596.3 ± 1.0% | 5286.2 ± 0.7% | 2844.8 ± 0.3% | 360.2 ± 0.7% | 3892.6 ± 2.0% | 636.2 ± 2.6% | 1.626 | 3.022 | 23.866 | 2.208 | 13.511 |
| string: canterbury-large/world192.txt | 1103121 | 4179.4 ± 0.8% | 2315.9 ± 0.1% | 1778.5 ± 0.3% | 331.4 ± 0.5% | 2111.7 ± 0.8% | 470.8 ± 0.9% | 1.805 | 2.350 | 12.613 | 1.979 | 8.878 |
| string: http/html-1m | 1058582 | 8946.2 ± 10.5% | 4817.0 ± 0.7% | 2733.3 ± 0.8% | 432.0 ± 0.4% | 3631.9 ± 0.9% | 610.2 ± 1.1% | 1.857 | 3.273 | 20.709 | 2.463 | 14.660 |
| string: http/json-1m | 1190272 | 3358.8 ± 0.5% | 1262.5 ± 0.9% | 2105.8 ± 0.3% | 484.2 ± 3.9% | 1341.2 ± 0.7% | 437.3 ± 0.8% | 2.660 | 1.595 | 6.937 | 2.504 | 7.681 |
| string: http/js-1m | 1144362 | 2863.1 ± 1.9% | 1618.3 ± 0.8% | 1333.7 ± 0.4% | 330.3 ± 0.4% | 1429.0 ± 0.3% | 384.4 ± 0.5% | 1.769 | 2.147 | 8.667 | 2.003 | 7.448 |
| string: http/css-1m | 1097820 | 3322.4 ± 0.3% | 2908.2 ± 0.1% | 2297.8 ± 0.3% | 460.3 ± 0.7% | 2072.5 ± 0.4% | 443.5 ± 1.6% | 1.142 | 1.446 | 7.219 | 1.603 | 7.491 |
| string: dickens as Cyrillic and CJK | 1883069 | 5843.1 ± 0.6% | 2912.6 ± 3.6% | 665.6 ± 0.5% | 380.3 ± 0.7% | 515.4 ± 0.2% | 165.1 ± 2.3% | 2.006 | 8.779 | 15.363 | 11.337 | 35.385 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1221.6 ± 0.1% | 1244.1 ± 1.2% | 1110.2 ± 0.6% | 264.9 ± 0.8% | 481.7 ± 0.5% | 232.1 ± 3.0% | 0.982 | 1.100 | 4.611 | 2.536 | 5.263 |
| hex: silesia/dickens | 524290 | 34048.9 ± 0.1% | 15121.6 ± 0.4% | 3539.2 ± 1.3% | 478.7 ± 0.5% | 8940.5 ± 0.3% | 1145.8 ± 1.9% | 2.252 | 9.621 | 71.125 | 3.808 | 29.717 |
| hex: silesia/mozilla | 524290 | 34051.6 ± 0.1% | 15130.8 ± 0.3% | 3507.0 ± 0.2% | 432.4 ± 0.2% | 8948.2 ± 0.2% | 1145.4 ± 0.1% | 2.250 | 9.710 | 78.749 | 3.805 | 29.730 |
| hex: silesia/mr | 524290 | 34028.5 ± 0.2% | 15122.8 ± 1.4% | 3510.0 ± 0.2% | 647.1 ± 0.2% | 8946.0 ± 0.2% | 1147.0 ± 0.3% | 2.250 | 9.695 | 52.583 | 3.804 | 29.666 |
| hex: silesia/nci | 524290 | 34059.6 ± 0.1% | 15125.8 ± 2.7% | 3583.0 ± 0.0% | 810.7 ± 3.7% | 8955.4 ± 0.2% | 1146.6 ± 1.0% | 2.252 | 9.506 | 42.011 | 3.803 | 29.704 |
| hex: silesia/ooffice | 524290 | 34026.9 ± 0.2% | 15117.3 ± 1.0% | 3514.4 ± 1.9% | 346.0 ± 0.6% | 8943.8 ± 0.4% | 1147.1 ± 0.5% | 2.251 | 9.682 | 98.333 | 3.805 | 29.663 |
| hex: silesia/osdb | 524290 | 34037.0 ± 0.1% | 15131.1 ± 0.4% | 3506.6 ± 0.3% | 459.4 ± 0.5% | 8943.3 ± 0.3% | 1146.3 ± 0.5% | 2.249 | 9.707 | 74.086 | 3.806 | 29.694 |
| hex: silesia/reymont | 524290 | 34064.7 ± 0.1% | 15120.7 ± 0.3% | 3556.5 ± 0.2% | 499.8 ± 0.6% | 8936.1 ± 5.2% | 1145.7 ± 1.3% | 2.253 | 9.578 | 68.161 | 3.812 | 29.733 |
| hex: silesia/samba | 524290 | 34074.2 ± 4.3% | 15126.1 ± 0.1% | 3510.8 ± 0.3% | 370.0 ± 0.7% | 8948.0 ± 0.3% | 1145.4 ± 0.3% | 2.253 | 9.706 | 92.103 | 3.808 | 29.748 |
| hex: silesia/sao | 524290 | 34067.0 ± 0.1% | 15116.3 ± 2.6% | 3511.8 ± 3.3% | 280.7 ± 1.5% | 8938.1 ± 0.3% | 1148.8 ± 0.8% | 2.254 | 9.701 | 121.368 | 3.811 | 29.654 |
| hex: silesia/webster | 524290 | 34068.4 ± 0.3% | 15130.6 ± 0.1% | 3580.8 ± 0.2% | 455.1 ± 0.2% | 8967.6 ± 5.0% | 1145.9 ± 0.2% | 2.252 | 9.514 | 74.864 | 3.799 | 29.730 |
| hex: silesia/x-ray | 524290 | 34078.0 ± 0.1% | 15119.4 ± 0.2% | 3510.8 ± 0.1% | 427.4 ± 2.0% | 8942.1 ± 0.3% | 1146.6 ± 1.1% | 2.254 | 9.707 | 79.742 | 3.811 | 29.720 |
| hex: silesia/xml | 524290 | 34046.2 ± 4.3% | 15131.9 ± 0.1% | 3574.6 ± 3.5% | 731.2 ± 0.6% | 8950.7 ± 0.5% | 1146.5 ± 4.3% | 2.250 | 9.524 | 46.560 | 3.804 | 29.695 |
| hex: canterbury/alice29.txt | 304180 | 33957.7 ± 0.2% | 14167.3 ± 0.1% | 3579.9 ± 0.1% | 485.6 ± 0.6% | 8971.2 ± 0.1% | 1156.2 ± 0.3% | 2.397 | 9.486 | 69.923 | 3.785 | 29.370 |
| hex: canterbury/asyoulik.txt | 250360 | 34015.7 ± 0.1% | 15011.5 ± 0.0% | 3508.7 ± 3.4% | 471.9 ± 0.5% | 8937.9 ± 0.1% | 1153.6 ± 0.2% | 2.266 | 9.695 | 72.082 | 3.806 | 29.488 |
| hex: canterbury/cp.html | 49208 | 33528.0 ± 0.1% | 14488.8 ± 0.1% | 3581.9 ± 0.1% | 512.9 ± 0.7% | 9294.5 ± 0.2% | 1131.5 ± 0.7% | 2.314 | 9.360 | 65.370 | 3.607 | 29.632 |
| hex: canterbury/fields.c | 22302 | 33160.5 ± 0.2% | 17709.3 ± 0.1% | 3687.3 ± 0.1% | 578.0 ± 0.3% | 9281.6 ± 0.2% | 1116.8 ± 1.5% | 1.872 | 8.993 | 57.367 | 3.573 | 29.693 |
| hex: canterbury/grammar.lsp | 7444 | 30015.1 ± 0.2% | 17342.1 ± 0.1% | 3639.5 ± 0.5% | 735.0 ± 1.2% | 8985.7 ± 0.2% | 1077.1 ± 1.9% | 1.731 | 8.247 | 40.835 | 3.340 | 27.867 |
| hex: canterbury/kennedy.xls | 524290 | 34083.1 ± 0.1% | 15119.2 ± 2.5% | 3580.2 ± 0.1% | 761.2 ± 2.5% | 8950.0 ± 0.2% | 1130.4 ± 4.7% | 2.254 | 9.520 | 44.773 | 3.808 | 30.151 |
| hex: canterbury/lcet10.txt | 524290 | 34062.9 ± 0.3% | 15113.8 ± 0.4% | 3557.7 ± 0.2% | 484.3 ± 0.3% | 8942.2 ± 0.2% | 1123.8 ± 2.8% | 2.254 | 9.574 | 70.338 | 3.809 | 30.310 |
| hex: canterbury/plrabn12.txt | 524290 | 34065.1 ± 0.1% | 15123.6 ± 0.1% | 3570.1 ± 0.2% | 466.6 ± 1.1% | 8958.7 ± 0.2% | 1145.3 ± 4.3% | 2.252 | 9.542 | 73.000 | 3.802 | 29.742 |
| hex: canterbury/ptt5 | 524290 | 34070.9 ± 0.1% | 15115.7 ± 2.1% | 3490.8 ± 0.1% | 667.6 ± 0.2% | 8931.0 ± 0.7% | 1147.6 ± 1.0% | 2.254 | 9.760 | 51.033 | 3.815 | 29.689 |
| hex: canterbury/sum | 76482 | 33468.1 ± 0.1% | 15510.4 ± 0.1% | 3582.7 ± 0.1% | 589.7 ± 0.4% | 8947.9 ± 3.7% | 1155.2 ± 1.1% | 2.158 | 9.342 | 56.759 | 3.740 | 28.971 |
| hex: canterbury/xargs.1 | 8456 | 30471.3 ± 1.2% | 17470.5 ± 0.1% | 3581.0 ± 0.1% | 724.9 ± 2.0% | 9025.4 ± 0.1% | 1129.5 ± 4.4% | 1.744 | 8.509 | 42.035 | 3.376 | 26.978 |
| hex: canterbury-large/E.coli | 524290 | 34064.4 ± 0.2% | 15129.3 ± 1.8% | 3515.4 ± 0.2% | 966.8 ± 0.2% | 8939.6 ± 3.9% | 1129.6 ± 7.3% | 2.252 | 9.690 | 35.235 | 3.810 | 30.157 |
| hex: canterbury-large/bible.txt | 524290 | 34071.9 ± 3.7% | 15122.6 ± 0.1% | 3511.3 ± 0.1% | 501.3 ± 0.4% | 8949.9 ± 0.2% | 1145.4 ± 4.8% | 2.253 | 9.704 | 67.968 | 3.807 | 29.746 |
| hex: canterbury-large/world192.txt | 524290 | 34061.9 ± 0.1% | 15124.7 ± 2.4% | 3580.0 ± 0.3% | 470.2 ± 0.4% | 8959.6 ± 4.5% | 1115.6 ± 2.7% | 2.252 | 9.514 | 72.442 | 3.802 | 30.533 |
| hex: http/html-1kx1024 | 2099200 | 15671.1 ± 0.5% | 12508.1 ± 0.3% | 3206.2 ± 3.1% | 507.3 ± 3.6% | 7390.6 ± 1.1% | 987.4 ± 1.8% | 1.253 | 4.888 | 30.892 | 2.120 | 15.870 |
| hex: http/html-16kx64 | 2097280 | 28195.4 ± 0.1% | 14095.6 ± 0.2% | 3431.0 ± 0.1% | 515.8 ± 0.3% | 8516.5 ± 1.0% | 1096.6 ± 2.9% | 2.000 | 8.218 | 54.665 | 3.311 | 25.711 |
| hex: http/html-1m | 524290 | 34043.3 ± 1.1% | 15120.1 ± 0.1% | 3509.9 ± 3.5% | 509.3 ± 0.2% | 8947.1 ± 0.2% | 1141.9 ± 3.1% | 2.252 | 9.699 | 66.839 | 3.805 | 29.812 |
| hex: http/json-1kx1024 | 2099200 | 15495.9 ± 0.5% | 12141.1 ± 0.3% | 3208.7 ± 0.4% | 672.0 ± 0.9% | 7415.4 ± 1.7% | 1003.9 ± 1.4% | 1.276 | 4.829 | 23.061 | 2.090 | 15.435 |
| hex: http/json-16kx64 | 2097280 | 28028.1 ± 0.2% | 13955.9 ± 0.4% | 3426.7 ± 3.3% | 687.2 ± 0.7% | 8638.6 ± 0.6% | 1110.8 ± 2.5% | 2.008 | 8.179 | 40.788 | 3.245 | 25.232 |
| hex: http/json-1m | 524290 | 34077.6 ± 0.1% | 15123.1 ± 0.1% | 3573.5 ± 0.1% | 701.3 ± 0.6% | 8957.0 ± 0.1% | 1142.2 ± 1.9% | 2.253 | 9.536 | 48.593 | 3.805 | 29.835 |
| hex: http/js-1kx1024 | 2099200 | 15368.7 ± 0.9% | 12875.3 ± 0.5% | 3211.1 ± 0.1% | 491.5 ± 0.4% | 7432.3 ± 2.2% | 1006.2 ± 2.5% | 1.194 | 4.786 | 31.268 | 2.068 | 15.274 |
| hex: http/js-16kx64 | 2097280 | 28062.6 ± 0.2% | 14243.9 ± 0.2% | 3426.8 ± 0.1% | 495.8 ± 1.5% | 8757.2 ± 6.1% | 1087.0 ± 2.2% | 1.970 | 8.189 | 56.604 | 3.205 | 25.816 |
| hex: http/js-1m | 524290 | 34046.7 ± 0.1% | 15137.3 ± 0.1% | 3530.2 ± 3.3% | 515.4 ± 0.5% | 8962.8 ± 0.2% | 1139.4 ± 1.6% | 2.249 | 9.644 | 66.063 | 3.799 | 29.882 |
| hex: http/css-1kx1024 | 2099200 | 15431.1 ± 0.7% | 12028.8 ± 1.8% | 3205.6 ± 3.0% | 572.5 ± 0.2% | 7414.0 ± 1.2% | 1011.5 ± 1.4% | 1.283 | 4.814 | 26.955 | 2.081 | 15.255 |
| hex: http/css-16kx64 | 2097280 | 27273.9 ± 0.4% | 14000.1 ± 0.4% | 3417.2 ± 0.1% | 583.1 ± 0.4% | 7692.9 ± 4.5% | 1109.0 ± 5.7% | 1.948 | 7.981 | 46.776 | 3.545 | 24.593 |
| hex: http/css-1m | 524290 | 34041.2 ± 0.5% | 15130.5 ± 0.2% | 3577.6 ± 0.1% | 563.1 ± 0.4% | 8958.4 ± 0.2% | 1139.7 ± 1.3% | 2.250 | 9.515 | 60.450 | 3.800 | 29.868 |
| hex: shuffled/dickens-1m | 524290 | 34052.1 ± 0.1% | 15122.3 ± 0.1% | 3511.6 ± 3.4% | 478.2 ± 0.5% | 8943.9 ± 0.1% | 1144.1 ± 4.1% | 2.252 | 9.697 | 71.216 | 3.807 | 29.763 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1284.4 ± 39.1% | 1541.1 ± 48.4% | 1089.6 ± 55.5% | 392.0 ± 50.1% | 675.8 ± 53.0% | 367.3 ± 66.0% | 0.833 | 1.179 | 3.277 | 1.901 | 3.497 |
| qlog records, JSON text sequence | 1467503 | 1153.0 ± 0.1% | 1244.7 ± 2.5% | 1128.3 ± 0.4% | 328.0 ± 1.0% | 768.8 ± 0.8% | 319.7 ± 0.6% | 0.926 | 1.022 | 3.515 | 1.500 | 3.606 |
| messages: 11 string members | 1025025 | 1035.2 ± 0.4% | 2011.3 ± 0.6% | 697.6 ± 4.2% | 340.2 ± 0.4% | 516.7 ± 0.3% | 307.5 ± 1.5% | 0.515 | 1.484 | 3.043 | 2.004 | 3.367 |
| messages: 50 nested objects | 1121600 | 1303.6 ± 0.3% | 1769.9 ± 1.0% | 1428.3 ± 0.0% | 431.5 ± 1.6% | 908.2 ± 0.4% | 425.3 ± 0.5% | 0.737 | 0.913 | 3.021 | 1.435 | 3.065 |
| messages: a tree of 341 objects | 612600 | 655.4 ± 0.4% | 858.7 ± 0.9% | 697.4 ± 1.1% | 183.3 ± 0.6% | 619.4 ± 0.3% | 209.8 ± 0.7% | 0.763 | 0.940 | 3.576 | 1.058 | 3.124 |
| string: silesia/dickens | 172528 | 6745.0 ± 0.2% | 3394.4 ± 3.2% | 2868.2 ± 1.1% | 318.8 ± 0.4% | 3096.5 ± 0.8% | 571.1 ± 1.3% | 1.987 | 2.352 | 21.156 | 2.178 | 11.811 |
| string: silesia/nci | 1075110 | 5472.6 ± 0.4% | 3916.3 ± 0.4% | 3052.1 ± 0.1% | 657.1 ± 0.7% | 3640.6 ± 0.3% | 579.8 ± 0.4% | 1.397 | 1.793 | 8.329 | 1.503 | 9.438 |
| string: silesia/reymont | 1075159 | 3539.7 ± 2.0% | 3420.9 ± 0.3% | 1965.8 ± 2.2% | 344.0 ± 0.3% | 2111.7 ± 0.3% | 497.9 ± 1.2% | 1.035 | 1.801 | 10.291 | 1.676 | 7.110 |
| string: silesia/samba | 97582 | 4003.7 ± 0.6% | 3797.7 ± 0.2% | 3066.5 ± 0.2% | 331.3 ± 1.8% | 1966.0 ± 1.2% | 423.0 ± 1.3% | 1.054 | 1.306 | 12.085 | 2.036 | 9.465 |
| string: silesia/webster | 1098490 | 4431.6 ± 0.4% | 2447.7 ± 0.3% | 1742.7 ± 0.3% | 311.2 ± 0.5% | 2078.4 ± 0.5% | 470.7 ± 1.8% | 1.811 | 2.543 | 14.239 | 2.132 | 9.414 |
| string: silesia/xml | 1090118 | 6076.3 ± 1.2% | 5056.8 ± 0.2% | 2462.0 ± 0.3% | 514.2 ± 0.2% | 3331.1 ± 2.1% | 553.6 ± 2.0% | 1.202 | 2.468 | 11.818 | 1.824 | 10.976 |
| string: canterbury/alice29.txt | 159425 | 5913.2 ± 1.5% | 2785.6 ± 1.8% | 2826.7 ± 1.3% | 302.2 ± 0.2% | 2777.9 ± 1.8% | 522.0 ± 1.5% | 2.123 | 2.092 | 19.570 | 2.129 | 11.328 |
| string: canterbury/asyoulik.txt | 132198 | 4325.6 ± 0.5% | 2644.2 ± 1.2% | 2786.7 ± 1.2% | 307.0 ± 0.3% | 2403.9 ± 0.6% | 457.9 ± 1.3% | 1.636 | 1.552 | 14.089 | 1.799 | 9.446 |
| string: canterbury/lcet10.txt | 441884 | 6653.4 ± 0.8% | 3280.9 ± 0.8% | 2322.3 ± 4.8% | 348.2 ± 0.3% | 2794.2 ± 0.8% | 576.4 ± 0.4% | 2.028 | 2.865 | 19.109 | 2.381 | 11.542 |
| string: canterbury/plrabn12.txt | 503330 | 5506.8 ± 0.1% | 3177.3 ± 0.1% | 1838.0 ± 0.4% | 324.2 ± 0.3% | 2837.7 ± 0.4% | 537.5 ± 1.1% | 1.733 | 2.996 | 16.985 | 1.941 | 10.245 |
| string: canterbury-large/E.coli | 1048578 | 34104.4 ± 0.1% | 13605.9 ± 0.2% | 3456.9 ± 0.2% | 1287.7 ± 0.1% | 8933.1 ± 0.3% | 978.2 ± 1.3% | 2.507 | 9.866 | 26.485 | 3.818 | 34.864 |
| string: canterbury-large/bible.txt | 1055886 | 8654.5 ± 0.7% | 5286.2 ± 0.7% | 2844.8 ± 0.3% | 360.2 ± 0.7% | 3892.6 ± 2.0% | 636.2 ± 2.6% | 1.637 | 3.042 | 24.028 | 2.223 | 13.603 |
| string: canterbury-large/world192.txt | 1103121 | 4199.3 ± 1.8% | 2315.9 ± 0.1% | 1778.5 ± 0.3% | 331.4 ± 0.5% | 2111.7 ± 0.8% | 470.8 ± 0.9% | 1.813 | 2.361 | 12.673 | 1.989 | 8.920 |
| string: http/html-1m | 1058582 | 9711.7 ± 2.5% | 4817.0 ± 0.7% | 2733.3 ± 0.8% | 432.0 ± 0.4% | 3631.9 ± 0.9% | 610.2 ± 1.1% | 2.016 | 3.553 | 22.481 | 2.674 | 15.915 |
| string: http/json-1m | 1190272 | 3355.6 ± 0.5% | 1262.5 ± 0.9% | 2105.8 ± 0.3% | 484.2 ± 3.9% | 1341.2 ± 0.7% | 437.3 ± 0.8% | 2.658 | 1.594 | 6.930 | 2.502 | 7.674 |
| string: http/js-1m | 1144362 | 2863.9 ± 0.6% | 1618.3 ± 0.8% | 1333.7 ± 0.4% | 330.3 ± 0.4% | 1429.0 ± 0.3% | 384.4 ± 0.5% | 1.770 | 2.147 | 8.669 | 2.004 | 7.450 |
| string: http/css-1m | 1097820 | 3335.5 ± 0.1% | 2908.2 ± 0.1% | 2297.8 ± 0.3% | 460.3 ± 0.7% | 2072.5 ± 0.4% | 443.5 ± 1.6% | 1.147 | 1.452 | 7.247 | 1.609 | 7.521 |
| string: dickens as Cyrillic and CJK | 1883069 | 5870.3 ± 0.5% | 2912.6 ± 3.6% | 665.6 ± 0.5% | 380.3 ± 0.7% | 515.4 ± 0.2% | 165.1 ± 2.3% | 2.015 | 8.819 | 15.434 | 11.390 | 35.550 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1221.0 ± 0.5% | 1244.1 ± 1.2% | 1110.2 ± 0.6% | 264.9 ± 0.8% | 481.7 ± 0.5% | 232.1 ± 3.0% | 0.981 | 1.100 | 4.609 | 2.535 | 5.260 |
| hex: silesia/dickens | 524290 | 34055.3 ± 0.1% | 15121.6 ± 0.4% | 3539.2 ± 1.3% | 478.7 ± 0.5% | 8940.5 ± 0.3% | 1145.8 ± 1.9% | 2.252 | 9.622 | 71.138 | 3.809 | 29.722 |
| hex: silesia/mozilla | 524290 | 34061.8 ± 0.2% | 15130.8 ± 0.3% | 3507.0 ± 0.2% | 432.4 ± 0.2% | 8948.2 ± 0.2% | 1145.4 ± 0.1% | 2.251 | 9.713 | 78.773 | 3.807 | 29.739 |
| hex: silesia/mr | 524290 | 34069.5 ± 0.0% | 15122.8 ± 1.4% | 3510.0 ± 0.2% | 647.1 ± 0.2% | 8946.0 ± 0.2% | 1147.0 ± 0.3% | 2.253 | 9.706 | 52.646 | 3.808 | 29.702 |
| hex: silesia/nci | 524290 | 34071.7 ± 0.1% | 15125.8 ± 2.7% | 3583.0 ± 0.0% | 810.7 ± 3.7% | 8955.4 ± 0.2% | 1146.6 ± 1.0% | 2.253 | 9.509 | 42.026 | 3.805 | 29.714 |
| hex: silesia/ooffice | 524290 | 34075.0 ± 0.1% | 15117.3 ± 1.0% | 3514.4 ± 1.9% | 346.0 ± 0.6% | 8943.8 ± 0.4% | 1147.1 ± 0.5% | 2.254 | 9.696 | 98.471 | 3.810 | 29.705 |
| hex: silesia/osdb | 524290 | 34060.5 ± 0.1% | 15131.1 ± 0.4% | 3506.6 ± 0.3% | 459.4 ± 0.5% | 8943.3 ± 0.3% | 1146.3 ± 0.5% | 2.251 | 9.713 | 74.138 | 3.808 | 29.714 |
| hex: silesia/reymont | 524290 | 34066.8 ± 0.2% | 15120.7 ± 0.3% | 3556.5 ± 0.2% | 499.8 ± 0.6% | 8936.1 ± 5.2% | 1145.7 ± 1.3% | 2.253 | 9.579 | 68.165 | 3.812 | 29.735 |
| hex: silesia/samba | 524290 | 34060.5 ± 0.1% | 15126.1 ± 0.1% | 3510.8 ± 0.3% | 370.0 ± 0.7% | 8948.0 ± 0.3% | 1145.4 ± 0.3% | 2.252 | 9.702 | 92.066 | 3.807 | 29.736 |
| hex: silesia/sao | 524290 | 34049.7 ± 0.1% | 15116.3 ± 2.6% | 3511.8 ± 3.3% | 280.7 ± 1.5% | 8938.1 ± 0.3% | 1148.8 ± 0.8% | 2.253 | 9.696 | 121.306 | 3.809 | 29.639 |
| hex: silesia/webster | 524290 | 34061.1 ± 0.1% | 15130.6 ± 0.1% | 3580.8 ± 0.2% | 455.1 ± 0.2% | 8967.6 ± 5.0% | 1145.9 ± 0.2% | 2.251 | 9.512 | 74.848 | 3.798 | 29.723 |
| hex: silesia/x-ray | 524290 | 34053.8 ± 0.3% | 15119.4 ± 0.2% | 3510.8 ± 0.1% | 427.4 ± 2.0% | 8942.1 ± 0.3% | 1146.6 ± 1.1% | 2.252 | 9.700 | 79.685 | 3.808 | 29.699 |
| hex: silesia/xml | 524290 | 34069.0 ± 0.2% | 15131.9 ± 0.1% | 3574.6 ± 3.5% | 731.2 ± 0.6% | 8950.7 ± 0.5% | 1146.5 ± 4.3% | 2.251 | 9.531 | 46.592 | 3.806 | 29.715 |
| hex: canterbury/alice29.txt | 304180 | 33974.5 ± 0.2% | 14167.3 ± 0.1% | 3579.9 ± 0.1% | 485.6 ± 0.6% | 8971.2 ± 0.1% | 1156.2 ± 0.3% | 2.398 | 9.490 | 69.958 | 3.787 | 29.384 |
| hex: canterbury/asyoulik.txt | 250360 | 34013.6 ± 0.1% | 15011.5 ± 0.0% | 3508.7 ± 3.4% | 471.9 ± 0.5% | 8937.9 ± 0.1% | 1153.6 ± 0.2% | 2.266 | 9.694 | 72.077 | 3.806 | 29.486 |
| hex: canterbury/cp.html | 49208 | 33547.6 ± 0.1% | 14488.8 ± 0.1% | 3581.9 ± 0.1% | 512.9 ± 0.7% | 9294.5 ± 0.2% | 1131.5 ± 0.7% | 2.315 | 9.366 | 65.409 | 3.609 | 29.649 |
| hex: canterbury/fields.c | 22302 | 33150.5 ± 0.1% | 17709.3 ± 0.1% | 3687.3 ± 0.1% | 578.0 ± 0.3% | 9281.6 ± 0.2% | 1116.8 ± 1.5% | 1.872 | 8.991 | 57.350 | 3.572 | 29.684 |
| hex: canterbury/grammar.lsp | 7444 | 29984.8 ± 0.3% | 17342.1 ± 0.1% | 3639.5 ± 0.5% | 735.0 ± 1.2% | 8985.7 ± 0.2% | 1077.1 ± 1.9% | 1.729 | 8.239 | 40.793 | 3.337 | 27.839 |
| hex: canterbury/kennedy.xls | 524290 | 34052.1 ± 0.6% | 15119.2 ± 2.5% | 3580.2 ± 0.1% | 761.2 ± 2.5% | 8950.0 ± 0.2% | 1130.4 ± 4.7% | 2.252 | 9.511 | 44.732 | 3.805 | 30.124 |
| hex: canterbury/lcet10.txt | 524290 | 34060.5 ± 4.3% | 15113.8 ± 0.4% | 3557.7 ± 0.2% | 484.3 ± 0.3% | 8942.2 ± 0.2% | 1123.8 ± 2.8% | 2.254 | 9.574 | 70.333 | 3.809 | 30.308 |
| hex: canterbury/plrabn12.txt | 524290 | 34069.8 ± 0.3% | 15123.6 ± 0.1% | 3570.1 ± 0.2% | 466.6 ± 1.1% | 8958.7 ± 0.2% | 1145.3 ± 4.3% | 2.253 | 9.543 | 73.010 | 3.803 | 29.747 |
| hex: canterbury/ptt5 | 524290 | 34059.9 ± 0.1% | 15115.7 ± 2.1% | 3490.8 ± 0.1% | 667.6 ± 0.2% | 8931.0 ± 0.7% | 1147.6 ± 1.0% | 2.253 | 9.757 | 51.017 | 3.814 | 29.679 |
| hex: canterbury/sum | 76482 | 33503.4 ± 0.1% | 15510.4 ± 0.1% | 3582.7 ± 0.1% | 589.7 ± 0.4% | 8947.9 ± 3.7% | 1155.2 ± 1.1% | 2.160 | 9.351 | 56.819 | 3.744 | 29.002 |
| hex: canterbury/xargs.1 | 8456 | 30470.5 ± 0.1% | 17470.5 ± 0.1% | 3581.0 ± 0.1% | 724.9 ± 2.0% | 9025.4 ± 0.1% | 1129.5 ± 4.4% | 1.744 | 8.509 | 42.034 | 3.376 | 26.977 |
| hex: canterbury-large/E.coli | 524290 | 34057.0 ± 0.1% | 15129.3 ± 1.8% | 3515.4 ± 0.2% | 966.8 ± 0.2% | 8939.6 ± 3.9% | 1129.6 ± 7.3% | 2.251 | 9.688 | 35.227 | 3.810 | 30.151 |
| hex: canterbury-large/bible.txt | 524290 | 34067.8 ± 0.1% | 15122.6 ± 0.1% | 3511.3 ± 0.1% | 501.3 ± 0.4% | 8949.9 ± 0.2% | 1145.4 ± 4.8% | 2.253 | 9.702 | 67.960 | 3.806 | 29.742 |
| hex: canterbury-large/world192.txt | 524290 | 34072.2 ± 0.2% | 15124.7 ± 2.4% | 3580.0 ± 0.3% | 470.2 ± 0.4% | 8959.6 ± 4.5% | 1115.6 ± 2.7% | 2.253 | 9.517 | 72.464 | 3.803 | 30.543 |
| hex: http/html-1kx1024 | 2099200 | 15306.8 ± 0.7% | 12508.1 ± 0.3% | 3206.2 ± 3.1% | 507.3 ± 3.6% | 7390.6 ± 1.1% | 987.4 ± 1.8% | 1.224 | 4.774 | 30.174 | 2.071 | 15.501 |
| hex: http/html-16kx64 | 2097280 | 28199.5 ± 0.1% | 14095.6 ± 0.2% | 3431.0 ± 0.1% | 515.8 ± 0.3% | 8516.5 ± 1.0% | 1096.6 ± 2.9% | 2.001 | 8.219 | 54.673 | 3.311 | 25.714 |
| hex: http/html-1m | 524290 | 34059.7 ± 0.1% | 15120.1 ± 0.1% | 3509.9 ± 3.5% | 509.3 ± 0.2% | 8947.1 ± 0.2% | 1141.9 ± 3.1% | 2.253 | 9.704 | 66.872 | 3.807 | 29.827 |
| hex: http/json-1kx1024 | 2099200 | 15144.0 ± 2.7% | 12141.1 ± 0.3% | 3208.7 ± 0.4% | 672.0 ± 0.9% | 7415.4 ± 1.7% | 1003.9 ± 1.4% | 1.247 | 4.720 | 22.537 | 2.042 | 15.085 |
| hex: http/json-16kx64 | 2097280 | 28020.1 ± 0.5% | 13955.9 ± 0.4% | 3426.7 ± 3.3% | 687.2 ± 0.7% | 8638.6 ± 0.6% | 1110.8 ± 2.5% | 2.008 | 8.177 | 40.776 | 3.244 | 25.225 |
| hex: http/json-1m | 524290 | 34056.1 ± 0.3% | 15123.1 ± 0.1% | 3573.5 ± 0.1% | 701.3 ± 0.6% | 8957.0 ± 0.1% | 1142.2 ± 1.9% | 2.252 | 9.530 | 48.563 | 3.802 | 29.817 |
| hex: http/js-1kx1024 | 2099200 | 15059.4 ± 0.2% | 12875.3 ± 0.5% | 3211.1 ± 0.1% | 491.5 ± 0.4% | 7432.3 ± 2.2% | 1006.2 ± 2.5% | 1.170 | 4.690 | 30.639 | 2.026 | 14.967 |
| hex: http/js-16kx64 | 2097280 | 28063.7 ± 0.2% | 14243.9 ± 0.2% | 3426.8 ± 0.1% | 495.8 ± 1.5% | 8757.2 ± 6.1% | 1087.0 ± 2.2% | 1.970 | 8.189 | 56.606 | 3.205 | 25.817 |
| hex: http/js-1m | 524290 | 34058.9 ± 0.4% | 15137.3 ± 0.1% | 3530.2 ± 3.3% | 515.4 ± 0.5% | 8962.8 ± 0.2% | 1139.4 ± 1.6% | 2.250 | 9.648 | 66.087 | 3.800 | 29.892 |
| hex: http/css-1kx1024 | 2099200 | 15036.5 ± 0.5% | 12028.8 ± 1.8% | 3205.6 ± 3.0% | 572.5 ± 0.2% | 7414.0 ± 1.2% | 1011.5 ± 1.4% | 1.250 | 4.691 | 26.266 | 2.028 | 14.865 |
| hex: http/css-16kx64 | 2097280 | 27310.4 ± 0.5% | 14000.1 ± 0.4% | 3417.2 ± 0.1% | 583.1 ± 0.4% | 7692.9 ± 4.5% | 1109.0 ± 5.7% | 1.951 | 7.992 | 46.838 | 3.550 | 24.626 |
| hex: http/css-1m | 524290 | 34061.8 ± 0.1% | 15130.5 ± 0.2% | 3577.6 ± 0.1% | 563.1 ± 0.4% | 8958.4 ± 0.2% | 1139.7 ± 1.3% | 2.251 | 9.521 | 60.486 | 3.802 | 29.886 |
| hex: shuffled/dickens-1m | 524290 | 34068.0 ± 0.1% | 15122.3 ± 0.1% | 3511.6 ± 3.4% | 478.2 ± 0.5% | 8943.9 ± 0.1% | 1144.1 ± 4.1% | 2.253 | 9.702 | 71.249 | 3.809 | 29.777 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1565.9 ± 2.6% | 1482.4 ± 0.4% | 1036.2 ± 0.3% | 467.1 ± 0.3% | 444.8 ± 1.1% | 504.1 ± 1.4% | 1.056 | 1.511 | 3.352 | 3.521 | 3.106 |
| qlog records, JSON text sequence | 1467503 | 1413.2 ± 0.2% | 1224.0 ± 2.0% | 948.5 ± 3.1% | 431.4 ± 3.4% | 541.8 ± 0.8% | 355.7 ± 2.0% | 1.155 | 1.490 | 3.276 | 2.608 | 3.973 |
| messages: 11 string members | 1025025 | 1247.4 ± 0.3% | 1117.7 ± 1.8% | 774.4 ± 0.5% | 406.7 ± 0.5% | 422.6 ± 0.3% | 438.4 ± 0.6% | 1.116 | 1.611 | 3.067 | 2.952 | 2.845 |
| messages: 50 nested objects | 1121600 | 1679.5 ± 0.1% | 1901.2 ± 0.3% | 1365.3 ± 0.7% | 602.7 ± 0.9% | 609.2 ± 6.7% | 526.8 ± 0.9% | 0.883 | 1.230 | 2.787 | 2.757 | 3.188 |
| messages: a tree of 341 objects | 612600 | 586.1 ± 0.7% | 691.3 ± 3.4% | 578.8 ± 0.4% | 339.5 ± 0.5% | 353.0 ± 1.0% | 221.6 ± 0.7% | 0.848 | 1.013 | 1.726 | 1.660 | 2.644 |
| string: silesia/dickens | 172528 | 13142.9 ± 0.5% | 3984.0 ± 0.8% | 3098.1 ± 1.0% | 334.4 ± 0.9% | 1515.8 ± 1.5% | 1190.3 ± 2.4% | 3.299 | 4.242 | 39.307 | 8.671 | 11.042 |
| string: silesia/nci | 1075110 | 11381.1 ± 0.2% | 4675.8 ± 0.1% | 3133.1 ± 0.1% | 914.0 ± 0.4% | 1592.0 ± 1.6% | 1200.8 ± 0.2% | 2.434 | 3.633 | 12.453 | 7.149 | 9.478 |
| string: silesia/reymont | 1075159 | 5424.3 ± 1.0% | 1877.4 ± 0.4% | 1893.2 ± 3.0% | 378.7 ± 0.5% | 1300.8 ± 3.4% | 1050.2 ± 1.1% | 2.889 | 2.865 | 14.322 | 4.170 | 5.165 |
| string: silesia/samba | 97582 | 6357.9 ± 0.4% | 2706.0 ± 0.4% | 4087.7 ± 0.1% | 350.5 ± 0.7% | 1274.7 ± 0.8% | 1187.1 ± 1.1% | 2.350 | 1.555 | 18.142 | 4.988 | 5.356 |
| string: silesia/webster | 1098490 | 7169.8 ± 1.1% | 1999.0 ± 0.6% | 1769.0 ± 1.6% | 352.5 ± 0.3% | 1280.9 ± 0.5% | 604.0 ± 0.2% | 3.587 | 4.053 | 20.340 | 5.598 | 11.871 |
| string: silesia/xml | 1090118 | 10761.0 ± 0.9% | 3268.4 ± 0.5% | 2534.7 ± 0.2% | 609.1 ± 0.4% | 1721.1 ± 1.4% | 964.2 ± 0.6% | 3.292 | 4.245 | 17.666 | 6.252 | 11.161 |
| string: canterbury/alice29.txt | 159425 | 12871.9 ± 0.6% | 2896.5 ± 0.3% | 3074.9 ± 0.7% | 316.5 ± 1.8% | 1370.5 ± 0.4% | 1090.2 ± 1.0% | 4.444 | 4.186 | 40.674 | 9.392 | 11.807 |
| string: canterbury/asyoulik.txt | 132198 | 11219.5 ± 1.2% | 2108.6 ± 0.6% | 3140.0 ± 1.6% | 316.1 ± 2.1% | 1220.3 ± 1.2% | 969.5 ± 1.0% | 5.321 | 3.573 | 35.490 | 9.194 | 11.572 |
| string: canterbury/lcet10.txt | 441884 | 12988.8 ± 1.7% | 3094.6 ± 1.3% | 2598.4 ± 0.5% | 368.8 ± 1.1% | 1464.7 ± 1.9% | 1194.7 ± 0.8% | 4.197 | 4.999 | 35.222 | 8.868 | 10.872 |
| string: canterbury/plrabn12.txt | 503330 | 9076.2 ± 0.6% | 2327.4 ± 0.3% | 2103.3 ± 1.2% | 348.5 ± 0.7% | 1377.9 ± 1.7% | 1128.3 ± 1.4% | 3.900 | 4.315 | 26.047 | 6.587 | 8.044 |
| string: canterbury-large/E.coli | 1048578 | 29875.3 ± 0.6% | 15708.6 ± 0.4% | 3506.8 ± 0.2% | 1704.8 ± 0.2% | 2916.2 ± 3.9% | 1422.5 ± 0.5% | 1.902 | 8.519 | 17.524 | 10.245 | 21.003 |
| string: canterbury-large/bible.txt | 1055886 | 9778.1 ± 0.5% | 4899.6 ± 0.3% | 3017.4 ± 0.4% | 408.8 ± 0.6% | 2023.1 ± 2.2% | 1492.5 ± 2.1% | 1.996 | 3.241 | 23.921 | 4.833 | 6.551 |
| string: canterbury-large/world192.txt | 1103121 | 6702.9 ± 0.9% | 1744.5 ± 0.4% | 1892.3 ± 2.1% | 347.1 ± 2.2% | 1282.3 ± 1.2% | 966.9 ± 0.2% | 3.842 | 3.542 | 19.312 | 5.227 | 6.933 |
| string: http/html-1m | 1058582 | 10253.5 ± 0.5% | 4406.6 ± 2.1% | 2898.1 ± 1.3% | 422.8 ± 0.4% | 2030.8 ± 1.4% | 855.3 ± 0.3% | 2.327 | 3.538 | 24.250 | 5.049 | 11.989 |
| string: http/json-1m | 1190272 | 8640.5 ± 6.3% | 1589.2 ± 0.3% | 1589.6 ± 2.0% | 557.5 ± 0.9% | 1025.6 ± 3.6% | 853.9 ± 0.9% | 5.437 | 5.436 | 15.498 | 8.425 | 10.119 |
| string: http/js-1m | 1144362 | 6604.3 ± 1.1% | 1131.0 ± 0.3% | 1393.2 ± 0.2% | 332.3 ± 0.2% | 1038.3 ± 1.0% | 764.9 ± 0.5% | 5.840 | 4.740 | 19.875 | 6.361 | 8.634 |
| string: http/css-1m | 1097820 | 9399.2 ± 1.0% | 1504.3 ± 0.2% | 2307.7 ± 0.6% | 512.7 ± 0.5% | 1119.6 ± 2.4% | 887.1 ± 0.5% | 6.248 | 4.073 | 18.332 | 8.395 | 10.595 |
| string: dickens as Cyrillic and CJK | 1883069 | 5539.4 ± 0.7% | 3683.0 ± 0.2% | 490.7 ± 0.5% | 248.4 ± 2.6% | 458.8 ± 0.2% | 358.8 ± 0.9% | 1.504 | 11.288 | 22.300 | 12.073 | 15.439 |
| hex: silesia/dickens | 524290 | 42756.7 ± 0.2% | 2601.3 ± 3.2% | 1515.7 ± 0.0% | 466.2 ± 0.3% | 1571.8 ± 0.6% | 1067.0 ± 0.2% | 16.437 | 28.210 | 91.721 | 27.203 | 40.072 |
| hex: silesia/mozilla | 524290 | 43907.1 ± 0.0% | 2601.4 ± 6.1% | 1485.2 ± 5.0% | 389.2 ± 1.2% | 1565.9 ± 0.3% | 1071.7 ± 0.5% | 16.878 | 29.564 | 112.802 | 28.039 | 40.969 |
| hex: silesia/mr | 524290 | 43808.2 ± 0.2% | 2589.9 ± 9.5% | 1508.1 ± 0.4% | 596.6 ± 0.3% | 1538.2 ± 1.0% | 1073.7 ± 0.2% | 16.915 | 29.049 | 73.432 | 28.480 | 40.802 |
| hex: silesia/nci | 524290 | 43991.3 ± 0.3% | 2583.8 ± 0.2% | 1508.3 ± 0.1% | 760.4 ± 0.1% | 1573.1 ± 0.3% | 1073.9 ± 0.1% | 17.026 | 29.166 | 57.851 | 27.965 | 40.966 |
| hex: silesia/ooffice | 524290 | 43776.5 ± 0.1% | 2605.2 ± 0.2% | 1514.9 ± 0.1% | 323.8 ± 1.8% | 1546.8 ± 0.3% | 1072.0 ± 0.2% | 16.804 | 28.897 | 135.217 | 28.301 | 40.838 |
| hex: silesia/osdb | 524290 | 42358.2 ± 0.2% | 2599.1 ± 0.1% | 1513.6 ± 1.9% | 431.0 ± 1.5% | 1571.2 ± 0.2% | 1070.0 ± 0.3% | 16.297 | 27.986 | 98.269 | 26.960 | 39.587 |
| hex: silesia/reymont | 524290 | 43904.3 ± 0.1% | 2601.8 ± 0.1% | 1513.3 ± 5.0% | 484.1 ± 3.4% | 1545.7 ± 0.8% | 1072.1 ± 0.1% | 16.875 | 29.013 | 90.695 | 28.404 | 40.953 |
| hex: silesia/samba | 524290 | 43894.5 ± 0.0% | 2599.8 ± 3.5% | 1512.7 ± 3.9% | 337.9 ± 1.0% | 1557.2 ± 2.1% | 1069.9 ± 0.1% | 16.884 | 29.018 | 129.887 | 28.188 | 41.025 |
| hex: silesia/sao | 524290 | 43789.2 ± 0.3% | 2616.0 ± 0.1% | 1513.4 ± 0.1% | 267.2 ± 10.0% | 1545.9 ± 0.2% | 1072.2 ± 0.1% | 16.739 | 28.934 | 163.863 | 28.326 | 40.841 |
| hex: silesia/webster | 524290 | 44233.9 ± 0.2% | 2609.6 ± 0.2% | 1516.7 ± 0.1% | 437.8 ± 0.1% | 1579.7 ± 0.2% | 1071.3 ± 0.3% | 16.951 | 29.165 | 101.026 | 28.001 | 41.291 |
| hex: silesia/x-ray | 524290 | 43942.3 ± 0.1% | 2618.8 ± 0.5% | 1515.9 ± 0.1% | 425.3 ± 0.5% | 1572.5 ± 0.4% | 1073.7 ± 0.2% | 16.779 | 28.988 | 103.323 | 27.944 | 40.926 |
| hex: silesia/xml | 524290 | 43989.3 ± 0.0% | 2607.5 ± 0.3% | 1515.7 ± 0.1% | 692.7 ± 0.2% | 1570.9 ± 0.8% | 1070.1 ± 0.5% | 16.870 | 29.022 | 63.505 | 28.003 | 41.109 |
| hex: canterbury/alice29.txt | 304180 | 41861.5 ± 0.3% | 2626.1 ± 0.2% | 1531.7 ± 0.1% | 470.7 ± 0.2% | 1562.0 ± 1.4% | 1091.9 ± 0.4% | 15.941 | 27.330 | 88.927 | 26.800 | 38.340 |
| hex: canterbury/asyoulik.txt | 250360 | 43829.8 ± 0.1% | 2631.0 ± 3.8% | 1543.9 ± 1.3% | 459.4 ± 0.2% | 1570.9 ± 0.8% | 1091.7 ± 0.2% | 16.659 | 28.388 | 95.398 | 27.901 | 40.147 |
| hex: canterbury/cp.html | 49208 | 42795.3 ± 0.1% | 2604.5 ± 0.5% | 1531.1 ± 0.1% | 481.9 ± 0.5% | 1593.3 ± 0.2% | 1096.8 ± 0.1% | 16.431 | 27.952 | 88.805 | 26.859 | 39.019 |
| hex: canterbury/fields.c | 22302 | 40420.2 ± 0.1% | 2647.0 ± 0.1% | 1537.7 ± 0.4% | 601.2 ± 0.7% | 1609.2 ± 0.2% | 1104.7 ± 0.1% | 15.270 | 26.286 | 67.236 | 25.118 | 36.590 |
| hex: canterbury/grammar.lsp | 7444 | 40646.0 ± 0.2% | 2718.2 ± 0.2% | 1546.6 ± 0.1% | 819.1 ± 0.4% | 1619.1 ± 0.1% | 1114.5 ± 0.1% | 14.953 | 26.281 | 49.623 | 25.104 | 36.469 |
| hex: canterbury/kennedy.xls | 524290 | 43900.5 ± 0.3% | 2595.3 ± 0.1% | 1510.5 ± 0.1% | 794.1 ± 0.4% | 1571.9 ± 0.2% | 1074.3 ± 0.3% | 16.915 | 29.064 | 55.284 | 27.928 | 40.864 |
| hex: canterbury/lcet10.txt | 524290 | 43955.9 ± 0.1% | 2592.5 ± 0.4% | 1512.3 ± 0.1% | 470.2 ± 0.1% | 1572.7 ± 0.2% | 1074.0 ± 0.9% | 16.955 | 29.065 | 93.479 | 27.949 | 40.929 |
| hex: canterbury/plrabn12.txt | 524290 | 43937.7 ± 0.2% | 2603.2 ± 0.1% | 1513.4 ± 0.1% | 455.8 ± 0.2% | 1563.8 ± 0.7% | 1071.6 ± 0.3% | 16.878 | 29.033 | 96.407 | 28.097 | 41.001 |
| hex: canterbury/ptt5 | 524290 | 43922.3 ± 0.1% | 2582.4 ± 0.2% | 1508.1 ± 0.5% | 594.2 ± 0.8% | 1535.0 ± 0.7% | 1072.9 ± 0.1% | 17.008 | 29.124 | 73.923 | 28.613 | 40.940 |
| hex: canterbury/sum | 76482 | 43122.0 ± 4.3% | 2610.4 ± 0.4% | 1524.8 ± 0.2% | 562.8 ± 0.1% | 1587.2 ± 0.2% | 1094.7 ± 0.2% | 16.519 | 28.281 | 76.621 | 27.169 | 39.392 |
| hex: canterbury/xargs.1 | 8456 | 41366.1 ± 0.6% | 2692.7 ± 0.5% | 1546.8 ± 0.1% | 843.5 ± 0.4% | 1615.9 ± 0.3% | 1115.8 ± 1.2% | 15.362 | 26.744 | 49.040 | 25.599 | 37.074 |
| hex: canterbury-large/E.coli | 524290 | 42006.4 ± 0.6% | 2592.0 ± 0.3% | 1510.7 ± 0.1% | 818.6 ± 0.2% | 1564.3 ± 0.5% | 1071.0 ± 0.2% | 16.206 | 27.806 | 51.315 | 26.854 | 39.221 |
| hex: canterbury-large/bible.txt | 524290 | 43963.7 ± 0.0% | 2607.3 ± 0.2% | 1511.9 ± 0.9% | 484.0 ± 0.2% | 1567.8 ± 0.4% | 1073.1 ± 0.0% | 16.862 | 29.079 | 90.835 | 28.042 | 40.970 |
| hex: canterbury-large/world192.txt | 524290 | 43665.5 ± 0.1% | 2602.5 ± 0.5% | 1516.8 ± 0.1% | 462.3 ± 0.4% | 1564.1 ± 0.9% | 1071.2 ± 0.4% | 16.778 | 28.788 | 94.451 | 27.918 | 40.764 |
| hex: http/html-1kx1024 | 2099200 | 21877.8 ± 4.1% | 2384.8 ± 1.4% | 1523.2 ± 0.2% | 502.3 ± 0.2% | 1512.8 ± 0.8% | 1081.8 ± 0.8% | 9.174 | 14.363 | 43.553 | 14.462 | 20.223 |
| hex: http/html-16kx64 | 2097280 | 22125.6 ± 3.6% | 2237.9 ± 0.2% | 1524.7 ± 0.1% | 505.8 ± 0.2% | 1457.4 ± 0.1% | 1089.5 ± 0.3% | 9.887 | 14.512 | 43.743 | 15.182 | 20.308 |
| hex: http/html-1m | 524290 | 43934.6 ± 0.2% | 2615.6 ± 0.1% | 1516.6 ± 0.0% | 493.7 ± 0.2% | 1572.2 ± 0.4% | 1070.2 ± 0.2% | 16.797 | 28.969 | 88.983 | 27.944 | 41.053 |
| hex: http/json-1kx1024 | 2099200 | 21263.5 ± 0.1% | 2373.0 ± 2.7% | 1520.7 ± 0.3% | 698.5 ± 0.2% | 1510.4 ± 6.7% | 1081.2 ± 0.2% | 8.960 | 13.982 | 30.442 | 14.078 | 19.667 |
| hex: http/json-16kx64 | 2097280 | 21752.0 ± 0.3% | 2235.5 ± 0.3% | 1522.8 ± 0.1% | 708.8 ± 0.2% | 1455.0 ± 0.1% | 1089.5 ± 0.4% | 9.730 | 14.284 | 30.687 | 14.950 | 19.965 |
| hex: http/json-1m | 524290 | 43863.0 ± 8.9% | 2596.0 ± 0.2% | 1509.0 ± 0.1% | 728.6 ± 0.1% | 1515.4 ± 0.6% | 1069.9 ± 0.1% | 16.896 | 29.067 | 60.206 | 28.945 | 40.997 |
| hex: http/js-1kx1024 | 2099200 | 20890.4 ± 0.2% | 2378.9 ± 1.7% | 1521.5 ± 0.4% | 491.9 ± 0.2% | 1512.8 ± 0.7% | 1080.9 ± 0.9% | 8.782 | 13.730 | 42.468 | 13.809 | 19.326 |
| hex: http/js-16kx64 | 2097280 | 21290.1 ± 0.2% | 2236.1 ± 0.8% | 1524.3 ± 0.1% | 494.8 ± 0.2% | 1458.8 ± 0.1% | 1090.4 ± 0.2% | 9.521 | 13.967 | 43.030 | 14.595 | 19.526 |
| hex: http/js-1m | 524290 | 43911.8 ± 0.1% | 2604.1 ± 2.0% | 1511.9 ± 0.1% | 508.5 ± 0.1% | 1568.1 ± 0.4% | 1075.2 ± 0.3% | 16.863 | 29.044 | 86.348 | 28.003 | 40.840 |
| hex: http/css-1kx1024 | 2099200 | 21318.3 ± 0.2% | 2368.8 ± 1.8% | 1521.8 ± 0.4% | 559.5 ± 0.4% | 1511.8 ± 0.5% | 1082.5 ± 0.3% | 9.000 | 14.009 | 38.099 | 14.101 | 19.694 |
| hex: http/css-16kx64 | 2097280 | 22144.5 ± 0.4% | 2232.6 ± 0.2% | 1524.4 ± 0.2% | 566.1 ± 0.3% | 1458.1 ± 0.1% | 1089.3 ± 0.4% | 9.919 | 14.527 | 39.114 | 15.187 | 20.330 |
| hex: http/css-1m | 524290 | 43902.2 ± 0.1% | 2590.5 ± 10.7% | 1514.9 ± 0.2% | 540.5 ± 0.2% | 1570.2 ± 0.8% | 1073.9 ± 0.1% | 16.947 | 28.980 | 81.223 | 27.959 | 40.881 |
| hex: shuffled/dickens-1m | 524290 | 42728.3 ± 0.0% | 2607.8 ± 0.0% | 1516.2 ± 5.9% | 465.7 ± 0.3% | 1563.5 ± 1.4% | 1076.7 ± 0.3% | 16.384 | 28.181 | 91.744 | 27.328 | 39.684 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.884 of simdjson.
- messages: 11 string members, decoding: stdx runs at 0.546 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.761 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.942 of yyjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.776 of simdjson.
- messages: a tree of 341 objects, encoding: stdx runs at 0.891 of simdjson.
- messages: a tree of 341 objects, encoding with J11's loop unchecked: stdx runs at 0.945 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.825 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.911 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.483 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.702 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.870 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.635 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.782 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.881 of serde_json.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.926 of simdjson.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.515 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.737 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.913 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.763 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.940 of yyjson.
- messages: 50 nested objects, encoding through TextWriter's methods: stdx runs at 0.883 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.848 of simdjson.
