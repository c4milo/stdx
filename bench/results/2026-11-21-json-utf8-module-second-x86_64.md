# bench-json

| Field | Value |
|---|---|
| Commit | 4354b93 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | Intel(R) Xeon(R) Platinum 8370C CPU @ 2.80GHz |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44941876810 |
| Date | 2026-11-21 |
| simdjson | 5.1.1 |
| yyjson | 0.13.0 |
| std.json | 0.16.0 |
| serde_json | 1.0.154, rustc 1.100.0 |
| Go jsontext | 1.27.3 |
| simdutf | 9.3.3 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1034.3 ± 0.6% | 0.510 | 1.047 | 1.092 | 1.097 | 0.457 | 1.095 | 1.097 | 0.433 | 0.861 | 0.967 | 0.109 |
| qlog records, JSON text sequence | 1467503 | 681.5 ± 1.8% | 0.959 | 1.064 | 1.038 | 1.047 | 0.536 | 1.069 | 1.053 | 0.514 | 0.959 | 1.096 | 0.157 |
| messages: 11 string members | 1025025 | 797.1 ± 1.8% | 0.653 | 1.026 | 1.052 | 1.053 | 0.578 | 1.057 | 1.056 | 0.604 | 0.933 | 1.001 | 0.139 |
| messages: 50 nested objects | 1121600 | 1037.1 ± 0.5% | 0.766 | 1.087 | 1.079 | 1.082 | 0.424 | 1.085 | 1.080 | 0.399 | 0.916 | 1.029 | 0.111 |
| messages: a tree of 341 objects | 612600 | 496.2 ± 0.4% | 0.841 | 1.071 | 1.052 | 1.027 | 0.299 | 1.037 | 1.026 | 0.261 | 0.757 | 0.980 | 0.131 |
| string: silesia/dickens | 172528 | 5854.1 ± 4.4% | 0.025 | 0.650 | 0.893 | 0.919 | 0.176 | 0.919 | 0.933 | 0.176 | 1.001 | 1.003 | 0.025 |
| string: silesia/nci | 1075110 | 4969.6 ± 2.6% | 0.030 | 0.664 | 0.917 | 0.931 | 0.248 | 0.954 | 0.930 | 0.247 | 1.011 | 1.011 | 0.030 |
| string: silesia/reymont | 1075159 | 3168.4 ± 1.9% | 0.047 | 0.612 | 0.825 | 0.825 | 0.318 | 0.838 | 0.834 | 0.319 | 1.001 | 1.007 | 0.047 |
| string: silesia/samba | 97582 | 2802.3 ± 0.7% | 0.047 | 0.920 | 1.045 | 1.054 | 0.088 | 0.889 | 1.055 | 0.088 | 0.994 | 0.990 | 0.047 |
| string: silesia/webster | 1098490 | 3799.0 ± 0.8% | 0.037 | 0.649 | 0.922 | 0.947 | 0.199 | 0.904 | 0.930 | 0.199 | 1.005 | 1.011 | 0.038 |
| string: silesia/xml | 1090118 | 4672.2 ± 0.5% | 0.032 | 0.798 | 0.998 | 1.014 | 0.255 | 0.971 | 1.016 | 0.254 | 1.004 | 1.007 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5175.5 ± 1.2% | 0.028 | 0.692 | 0.909 | 0.932 | 0.153 | 0.921 | 0.979 | 0.153 | 0.999 | 1.009 | 0.028 |
| string: canterbury/asyoulik.txt | 132198 | 3451.3 ± 0.9% | 0.041 | 0.781 | 1.112 | 1.128 | 0.191 | 1.075 | 1.158 | 0.190 | 0.998 | 1.007 | 0.040 |
| string: canterbury/lcet10.txt | 441884 | 5979.2 ± 0.5% | 0.025 | 0.554 | 0.890 | 0.904 | 0.167 | 0.898 | 0.917 | 0.167 | 0.990 | 0.990 | 0.025 |
| string: canterbury/plrabn12.txt | 503330 | 3986.9 ± 0.2% | 0.037 | 0.781 | 1.086 | 1.107 | 0.227 | 1.034 | 1.111 | 0.226 | 1.002 | 1.003 | 0.037 |
| string: canterbury-large/E.coli | 1048578 | 15208.0 ± 8.2% | 0.104 | 1.006 | 0.942 | 1.004 | 0.664 | 1.006 | 1.004 | 0.665 | 1.581 | 1.583 | 0.011 |
| string: canterbury-large/bible.txt | 1055886 | 8340.6 ± 3.3% | 0.019 | 0.544 | 0.712 | 0.685 | 0.329 | 0.726 | 0.708 | 0.329 | 0.997 | 1.016 | 0.019 |
| string: canterbury-large/world192.txt | 1103121 | 3603.6 ± 1.1% | 0.040 | 0.679 | 0.910 | 0.926 | 0.192 | 0.905 | 0.920 | 0.191 | 0.994 | 1.000 | 0.040 |
| string: http/html-1m | 1058582 | 7847.4 ± 1.1% | 0.020 | 0.555 | 0.730 | 0.735 | 0.303 | 0.711 | 0.735 | 0.302 | 0.977 | 1.016 | 0.020 |
| string: http/json-1m | 1190272 | 2834.0 ± 0.5% | 0.048 | 0.376 | 0.440 | 0.447 | 0.120 | 0.454 | 0.447 | 0.120 | 1.005 | 1.007 | 0.048 |
| string: http/js-1m | 1144362 | 2514.7 ± 0.2% | 0.053 | 0.684 | 0.829 | 0.857 | 0.168 | 0.806 | 0.858 | 0.167 | 0.999 | 0.998 | 0.053 |
| string: http/css-1m | 1097820 | 2734.4 ± 4.4% | 0.051 | 0.743 | 0.952 | 0.990 | 0.259 | 0.939 | 0.992 | 0.258 | 1.004 | 1.007 | 0.052 |
| string: dickens as Cyrillic and CJK | 1883069 | 4711.4 ± 10.0% | 0.024 | 0.062 | 0.461 | 0.461 | 0.186 | 0.458 | 0.462 | 0.186 | 1.000 | 1.004 | 0.024 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 906.9 ± 0.9% | 0.123 | 1.000 | 1.002 | 1.002 | 0.118 | 0.780 | 1.001 | 0.118 | 1.004 | 1.005 | 0.123 |
| hex: silesia/dickens | 524290 | 38035.1 ± 4.6% | 0.043 | 1.006 | 0.559 | 1.007 | 0.367 | 1.006 | 1.004 | 0.366 | 0.636 | 0.638 | 0.004 |
| hex: silesia/mozilla | 524290 | 37209.7 ± 0.5% | 0.044 | 1.002 | 0.585 | 1.002 | 0.376 | 1.005 | 1.005 | 0.376 | 0.653 | 0.653 | 0.004 |
| hex: silesia/mr | 524290 | 30219.3 ± 0.5% | 0.054 | 1.000 | 0.664 | 1.000 | 0.435 | 1.000 | 1.000 | 0.436 | 0.804 | 0.803 | 0.005 |
| hex: silesia/nci | 524290 | 35694.1 ± 1.0% | 0.046 | 1.005 | 0.588 | 1.003 | 0.383 | 1.005 | 1.006 | 0.384 | 0.680 | 0.680 | 0.005 |
| hex: silesia/ooffice | 524290 | 41454.5 ± 0.7% | 0.040 | 1.004 | 0.516 | 1.003 | 0.344 | 1.005 | 1.004 | 0.343 | 0.586 | 0.586 | 0.004 |
| hex: silesia/osdb | 524290 | 28997.7 ± 0.5% | 0.056 | 1.000 | 0.680 | 1.002 | 0.448 | 1.003 | 1.002 | 0.449 | 0.838 | 0.837 | 0.006 |
| hex: silesia/reymont | 524290 | 36916.2 ± 2.0% | 0.044 | 1.002 | 0.593 | 1.003 | 0.375 | 1.002 | 1.004 | 0.375 | 0.659 | 0.658 | 0.004 |
| hex: silesia/samba | 524290 | 34940.5 ± 0.9% | 0.047 | 1.002 | 0.619 | 1.002 | 0.390 | 1.004 | 1.005 | 0.389 | 0.695 | 0.694 | 0.005 |
| hex: silesia/sao | 524290 | 36757.8 ± 0.3% | 0.045 | 1.004 | 0.589 | 1.002 | 0.377 | 1.005 | 1.005 | 0.374 | 0.661 | 0.660 | 0.004 |
| hex: silesia/webster | 524290 | 32270.3 ± 0.4% | 0.051 | 1.001 | 0.636 | 1.000 | 0.411 | 1.003 | 1.004 | 0.411 | 0.753 | 0.751 | 0.005 |
| hex: silesia/x-ray | 524290 | 35526.0 ± 3.0% | 0.046 | 1.003 | 0.596 | 1.003 | 0.388 | 1.004 | 1.006 | 0.388 | 0.684 | 0.684 | 0.005 |
| hex: silesia/xml | 524290 | 33221.2 ± 0.4% | 0.049 | 1.004 | 0.611 | 1.002 | 0.408 | 1.003 | 1.002 | 0.407 | 0.731 | 0.731 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 41453.5 ± 1.1% | 0.040 | 1.001 | 0.514 | 0.999 | 0.344 | 1.001 | 1.002 | 0.344 | 0.584 | 0.584 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 41414.4 ± 6.6% | 0.040 | 1.002 | 0.530 | 1.003 | 0.344 | 0.943 | 1.002 | 0.344 | 0.584 | 0.584 | 0.004 |
| hex: canterbury/cp.html | 49208 | 33820.9 ± 0.3% | 0.048 | 1.006 | 0.646 | 1.006 | 0.396 | 1.007 | 1.006 | 0.398 | 0.703 | 0.702 | 0.005 |
| hex: canterbury/fields.c | 22302 | 42505.4 ± 0.9% | 0.039 | 1.010 | 0.499 | 1.013 | 0.346 | 1.013 | 1.009 | 0.352 | 0.554 | 0.554 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 36962.6 ± 0.5% | 0.045 | 1.023 | 0.525 | 1.017 | 0.376 | 1.024 | 1.015 | 0.393 | 0.579 | 0.580 | 0.004 |
| hex: canterbury/kennedy.xls | 524290 | 39051.6 ± 1.6% | 0.042 | 1.006 | 0.564 | 1.005 | 0.359 | 1.008 | 1.006 | 0.358 | 0.622 | 0.622 | 0.004 |
| hex: canterbury/lcet10.txt | 524290 | 40233.8 ± 1.0% | 0.041 | 0.999 | 0.549 | 0.996 | 0.351 | 1.005 | 1.005 | 0.350 | 0.604 | 0.604 | 0.004 |
| hex: canterbury/plrabn12.txt | 524290 | 36173.1 ± 1.1% | 0.045 | 1.000 | 0.599 | 1.001 | 0.380 | 1.002 | 1.002 | 0.380 | 0.672 | 0.671 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 36937.3 ± 0.4% | 0.044 | 1.003 | 0.574 | 1.002 | 0.370 | 1.002 | 1.002 | 0.370 | 0.658 | 0.658 | 0.004 |
| hex: canterbury/sum | 76482 | 39963.5 ± 0.8% | 0.041 | 1.006 | 0.540 | 1.005 | 0.351 | 1.007 | 1.006 | 0.352 | 0.596 | 0.597 | 0.004 |
| hex: canterbury/xargs.1 | 8456 | 37132.0 ± 1.1% | 0.045 | 1.040 | 0.530 | 1.037 | 0.382 | 1.044 | 1.031 | 0.394 | 0.584 | 0.585 | 0.004 |
| hex: canterbury-large/E.coli | 524290 | 38189.9 ± 1.6% | 0.043 | 1.001 | 0.572 | 1.000 | 0.366 | 1.002 | 1.003 | 0.367 | 0.636 | 0.636 | 0.004 |
| hex: canterbury-large/bible.txt | 524290 | 38337.2 ± 0.5% | 0.043 | 0.999 | 0.558 | 1.002 | 0.364 | 1.003 | 1.003 | 0.364 | 0.633 | 0.634 | 0.004 |
| hex: canterbury-large/world192.txt | 524290 | 35489.8 ± 0.3% | 0.046 | 1.003 | 0.584 | 1.004 | 0.378 | 1.001 | 1.004 | 0.378 | 0.684 | 0.684 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 14165.2 ± 1.2% | 0.114 | 1.042 | 0.871 | 1.040 | 0.619 | 1.045 | 1.041 | 0.689 | 0.939 | 0.937 | 0.011 |
| hex: http/html-16kx64 | 2097280 | 24577.3 ± 0.9% | 0.067 | 1.004 | 0.775 | 1.004 | 0.548 | 1.005 | 1.005 | 0.552 | 0.877 | 0.878 | 0.007 |
| hex: http/html-1m | 524290 | 41590.0 ± 0.3% | 0.040 | 1.000 | 0.513 | 1.001 | 0.342 | 1.002 | 1.002 | 0.342 | 0.582 | 0.584 | 0.004 |
| hex: http/json-1kx1024 | 2099200 | 14172.9 ± 1.0% | 0.114 | 1.041 | 0.875 | 1.042 | 0.618 | 1.051 | 1.045 | 0.693 | 0.942 | 0.939 | 0.011 |
| hex: http/json-16kx64 | 2097280 | 24682.5 ± 0.2% | 0.067 | 1.004 | 0.776 | 1.002 | 0.545 | 1.003 | 1.004 | 0.551 | 0.876 | 0.876 | 0.007 |
| hex: http/json-1m | 524290 | 31621.0 ± 1.4% | 0.052 | 1.004 | 0.673 | 1.005 | 0.426 | 1.004 | 1.006 | 0.425 | 0.769 | 0.768 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 14138.2 ± 0.5% | 0.115 | 1.037 | 0.873 | 1.043 | 0.619 | 1.051 | 1.039 | 0.692 | 0.943 | 0.939 | 0.011 |
| hex: http/js-16kx64 | 2097280 | 24449.0 ± 0.4% | 0.067 | 1.004 | 0.785 | 1.003 | 0.551 | 1.004 | 1.003 | 0.556 | 0.884 | 0.883 | 0.007 |
| hex: http/js-1m | 524290 | 38512.6 ± 1.5% | 0.043 | 1.000 | 0.573 | 0.996 | 0.366 | 1.002 | 1.001 | 0.367 | 0.631 | 0.631 | 0.004 |
| hex: http/css-1kx1024 | 2099200 | 13993.7 ± 8.8% | 0.116 | 1.041 | 0.881 | 1.051 | 0.625 | 1.061 | 1.054 | 0.699 | 0.948 | 0.944 | 0.011 |
| hex: http/css-16kx64 | 2097280 | 24476.6 ± 1.2% | 0.067 | 1.003 | 0.786 | 1.003 | 0.551 | 1.004 | 1.004 | 0.557 | 0.883 | 0.882 | 0.007 |
| hex: http/css-1m | 524290 | 41949.1 ± 1.4% | 0.039 | 1.003 | 0.524 | 1.004 | 0.339 | 1.005 | 1.005 | 0.339 | 0.577 | 0.579 | 0.004 |
| hex: shuffled/dickens-1m | 524290 | 40828.8 ± 1.2% | 0.040 | 1.000 | 0.529 | 1.002 | 0.349 | 1.004 | 1.003 | 0.348 | 0.595 | 0.595 | 0.004 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1374.2 ± 0.4% | 0.427 | 0.962 | 0.969 | 0.997 | 0.997 | 0.267 | 0.999 | 0.467 | 0.857 | 0.093 | 1.010 |
| qlog records, JSON text sequence | 1467503 | 1052.6 ± 2.2% | 0.748 | 0.977 | 1.020 | 1.007 | 1.018 | 0.301 | 1.021 | 0.509 | 0.893 | 0.131 | 1.052 |
| messages: 11 string members | 1025025 | 1042.6 ± 0.4% | 0.526 | 0.981 | 0.990 | 0.998 | 0.985 | 0.373 | 0.987 | 0.635 | 0.992 | 0.113 | 0.994 |
| messages: 50 nested objects | 1121600 | 1401.9 ± 13.8% | 0.599 | 0.964 | 0.980 | 0.974 | 0.979 | 0.253 | 0.977 | 0.436 | 0.860 | 0.097 | 1.007 |
| messages: a tree of 341 objects | 612600 | 480.3 ± 5.7% | 0.900 | 1.013 | 1.025 | 1.040 | 1.026 | 0.236 | 1.028 | 0.367 | 1.028 | 0.181 | 1.075 |
| string: silesia/dickens | 172528 | 9914.0 ± 1.6% | 0.017 | 0.516 | 0.393 | 0.500 | 0.520 | 0.113 | 0.524 | 0.995 | 1.009 | 0.017 | 1.034 |
| string: silesia/nci | 1075110 | 8365.8 ± 2.3% | 0.020 | 0.528 | 0.398 | 0.515 | 0.528 | 0.177 | 0.528 | 0.997 | 1.001 | 0.020 | 1.026 |
| string: silesia/reymont | 1075159 | 4395.5 ± 4.7% | 0.039 | 0.579 | 0.444 | 0.568 | 0.587 | 0.254 | 0.583 | 0.981 | 0.986 | 0.039 | 1.037 |
| string: silesia/samba | 97582 | 4428.3 ± 9.2% | 0.048 | 0.887 | 0.770 | 0.902 | 0.906 | 0.124 | 0.909 | 0.999 | 1.002 | 0.048 | 1.179 |
| string: silesia/webster | 1098490 | 5691.7 ± 2.3% | 0.029 | 0.568 | 0.440 | 0.563 | 0.569 | 0.142 | 0.569 | 0.999 | 1.009 | 0.029 | 1.005 |
| string: silesia/xml | 1090118 | 7925.0 ± 2.0% | 0.022 | 0.562 | 0.481 | 0.561 | 0.567 | 0.202 | 0.564 | 0.996 | 1.005 | 0.022 | 1.050 |
| string: canterbury/alice29.txt | 159425 | 9230.0 ± 3.0% | 0.018 | 0.471 | 0.389 | 0.443 | 0.489 | 0.092 | 0.497 | 0.995 | 1.017 | 0.018 | 1.053 |
| string: canterbury/asyoulik.txt | 132198 | 8047.1 ± 0.5% | 0.020 | 0.430 | 0.335 | 0.416 | 0.442 | 0.090 | 0.451 | 0.995 | 1.006 | 0.020 | 1.038 |
| string: canterbury/lcet10.txt | 441884 | 8852.3 ± 2.5% | 0.019 | 0.568 | 0.385 | 0.547 | 0.571 | 0.123 | 0.571 | 1.000 | 1.027 | 0.019 | 1.059 |
| string: canterbury/plrabn12.txt | 503330 | 6721.8 ± 3.1% | 0.025 | 0.618 | 0.464 | 0.601 | 0.619 | 0.147 | 0.618 | 0.988 | 1.016 | 0.025 | 1.042 |
| string: canterbury-large/E.coli | 1048578 | 15937.3 ± 0.5% | 0.099 | 1.002 | 1.002 | 0.970 | 1.002 | 0.635 | 1.003 | 1.001 | 1.002 | 0.011 | 1.002 |
| string: canterbury-large/bible.txt | 1055886 | 8235.7 ± 2.8% | 0.021 | 0.672 | 0.556 | 0.683 | 0.669 | 0.358 | 0.667 | 0.949 | 0.960 | 0.021 | 1.043 |
| string: canterbury-large/world192.txt | 1103121 | 5354.9 ± 2.8% | 0.031 | 0.586 | 0.462 | 0.575 | 0.585 | 0.139 | 0.587 | 1.002 | 1.012 | 0.031 | 1.023 |
| string: http/html-1m | 1058582 | 8373.8 ± 12.8% | 0.021 | 0.596 | 0.538 | 0.612 | 0.601 | 0.300 | 0.599 | 0.999 | 1.008 | 0.021 | 1.008 |
| string: http/json-1m | 1190272 | 6436.6 ± 0.8% | 0.026 | 0.203 | 0.167 | 0.201 | 0.204 | 0.067 | 0.204 | 1.001 | 1.001 | 0.026 | 1.029 |
| string: http/js-1m | 1144362 | 5323.4 ± 3.2% | 0.030 | 0.370 | 0.325 | 0.372 | 0.370 | 0.085 | 0.370 | 0.998 | 1.010 | 0.030 | 1.041 |
| string: http/css-1m | 1097820 | 7258.6 ± 1.3% | 0.022 | 0.343 | 0.279 | 0.340 | 0.343 | 0.114 | 0.342 | 0.998 | 1.006 | 0.022 | 1.035 |
| string: dickens as Cyrillic and CJK | 1883069 | 4521.5 ± 0.4% | 0.028 | 0.465 | 0.066 | 0.463 | 0.465 | 0.190 | 0.465 | 0.994 | 0.998 | 0.028 | 0.993 |
| hex: silesia/dickens | 524290 | 28720.8 ± 0.3% | 1.001 | 0.081 | 1.002 | 0.582 | 0.999 | 1.001 | 0.998 | 1.000 | 1.002 | 0.080 | 1.002 |
| hex: silesia/mozilla | 524290 | 29233.8 ± 0.3% | 1.000 | 0.079 | 1.001 | 0.548 | 1.002 | 1.000 | 1.002 | 1.000 | 1.002 | 0.079 | 1.001 |
| hex: silesia/mr | 524290 | 29304.2 ± 2.1% | 1.001 | 0.079 | 1.001 | 0.555 | 1.000 | 1.001 | 1.001 | 0.999 | 1.002 | 0.079 | 1.001 |
| hex: silesia/nci | 524290 | 30082.8 ± 0.6% | 1.004 | 0.077 | 1.005 | 0.540 | 1.006 | 1.005 | 1.006 | 1.003 | 1.005 | 0.077 | 1.005 |
| hex: silesia/ooffice | 524290 | 29418.9 ± 0.3% | 1.001 | 0.078 | 0.998 | 0.543 | 0.998 | 0.995 | 0.998 | 0.998 | 1.000 | 0.078 | 0.997 |
| hex: silesia/osdb | 524290 | 28769.3 ± 0.3% | 1.002 | 0.080 | 1.002 | 0.579 | 1.002 | 1.002 | 1.002 | 1.001 | 1.002 | 0.080 | 1.001 |
| hex: silesia/reymont | 524290 | 29470.2 ± 4.2% | 1.002 | 0.078 | 1.002 | 0.547 | 1.002 | 1.001 | 1.001 | 1.000 | 1.003 | 0.078 | 1.000 |
| hex: silesia/samba | 524290 | 30218.1 ± 0.3% | 1.001 | 0.076 | 1.001 | 0.532 | 1.001 | 1.000 | 1.001 | 0.999 | 1.001 | 0.076 | 1.001 |
| hex: silesia/sao | 524290 | 29214.8 ± 0.9% | 1.001 | 0.079 | 1.001 | 0.559 | 1.000 | 1.002 | 1.002 | 1.001 | 1.002 | 0.079 | 1.001 |
| hex: silesia/webster | 524290 | 31167.5 ± 0.9% | 0.998 | 0.074 | 1.001 | 0.533 | 1.001 | 0.999 | 1.000 | 0.999 | 1.001 | 0.074 | 1.001 |
| hex: silesia/x-ray | 524290 | 29223.1 ± 0.6% | 0.999 | 0.079 | 1.001 | 0.549 | 1.000 | 1.000 | 1.001 | 1.000 | 1.000 | 0.079 | 1.001 |
| hex: silesia/xml | 524290 | 30258.5 ± 0.5% | 1.001 | 0.076 | 1.001 | 0.530 | 1.001 | 1.001 | 1.001 | 1.001 | 0.998 | 0.076 | 1.002 |
| hex: canterbury/alice29.txt | 304180 | 28802.3 ± 0.1% | 1.000 | 0.080 | 1.000 | 0.547 | 1.001 | 0.999 | 1.001 | 1.000 | 1.000 | 0.080 | 1.000 |
| hex: canterbury/asyoulik.txt | 250360 | 29153.6 ± 0.7% | 0.999 | 0.079 | 1.000 | 0.552 | 1.001 | 1.000 | 1.002 | 1.000 | 1.000 | 0.079 | 1.000 |
| hex: canterbury/cp.html | 49208 | 28567.1 ± 1.0% | 1.000 | 0.081 | 1.000 | 0.557 | 1.001 | 0.994 | 1.001 | 0.999 | 1.005 | 0.081 | 1.001 |
| hex: canterbury/fields.c | 22302 | 29306.9 ± 0.5% | 0.999 | 0.079 | 1.001 | 0.540 | 1.001 | 0.986 | 1.000 | 1.001 | 1.009 | 0.078 | 1.003 |
| hex: canterbury/grammar.lsp | 7444 | 27491.7 ± 0.2% | 0.999 | 0.083 | 0.999 | 0.546 | 1.000 | 0.971 | 1.000 | 0.999 | 1.017 | 0.082 | 1.002 |
| hex: canterbury/kennedy.xls | 524290 | 29364.4 ± 0.7% | 1.003 | 0.079 | 1.003 | 0.549 | 1.003 | 1.002 | 1.002 | 1.002 | 1.003 | 0.079 | 1.003 |
| hex: canterbury/lcet10.txt | 524290 | 30195.7 ± 0.4% | 1.002 | 0.076 | 1.002 | 0.536 | 1.002 | 1.002 | 1.002 | 1.001 | 1.002 | 0.077 | 1.002 |
| hex: canterbury/plrabn12.txt | 524290 | 29187.3 ± 0.3% | 1.000 | 0.079 | 1.001 | 0.555 | 1.001 | 1.001 | 1.002 | 0.999 | 1.001 | 0.079 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 29216.0 ± 0.4% | 1.002 | 0.079 | 1.001 | 0.548 | 1.001 | 1.000 | 1.001 | 1.000 | 1.002 | 0.079 | 1.002 |
| hex: canterbury/sum | 76482 | 28778.4 ± 7.5% | 1.001 | 0.080 | 1.002 | 0.557 | 1.000 | 0.997 | 1.001 | 1.000 | 1.004 | 0.080 | 1.002 |
| hex: canterbury/xargs.1 | 8456 | 27624.5 ± 0.3% | 1.002 | 0.083 | 1.001 | 0.547 | 1.001 | 0.958 | 1.000 | 1.003 | 1.018 | 0.082 | 1.004 |
| hex: canterbury-large/E.coli | 524290 | 28735.4 ± 0.2% | 1.000 | 0.080 | 1.001 | 0.554 | 1.000 | 1.001 | 1.000 | 1.001 | 0.998 | 0.080 | 1.001 |
| hex: canterbury-large/bible.txt | 524290 | 30247.1 ± 0.2% | 1.001 | 0.076 | 1.002 | 0.537 | 1.001 | 1.002 | 1.001 | 1.001 | 1.001 | 0.076 | 1.002 |
| hex: canterbury-large/world192.txt | 524290 | 29421.0 ± 0.2% | 1.001 | 0.078 | 1.000 | 0.549 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 0.079 | 1.001 |
| hex: http/html-1kx1024 | 2099200 | 18057.6 ± 1.8% | 1.002 | 0.125 | 1.001 | 0.799 | 0.997 | 0.920 | 1.001 | 1.002 | 1.023 | 0.121 | 1.005 |
| hex: http/html-16kx64 | 2097280 | 18951.4 ± 2.9% | 1.005 | 0.121 | 1.003 | 0.862 | 1.001 | 0.999 | 1.004 | 1.005 | 1.008 | 0.121 | 1.005 |
| hex: http/html-1m | 524290 | 29241.9 ± 0.2% | 1.001 | 0.079 | 1.001 | 0.591 | 1.001 | 1.000 | 0.997 | 1.000 | 1.001 | 0.079 | 1.001 |
| hex: http/json-1kx1024 | 2099200 | 17824.1 ± 0.5% | 1.000 | 0.126 | 0.998 | 0.810 | 1.002 | 0.924 | 1.002 | 1.001 | 1.023 | 0.123 | 1.006 |
| hex: http/json-16kx64 | 2097280 | 18596.3 ± 0.5% | 1.004 | 0.124 | 1.001 | 0.869 | 1.004 | 0.997 | 1.003 | 1.001 | 1.007 | 0.123 | 1.002 |
| hex: http/json-1m | 524290 | 29396.6 ± 15.1% | 1.002 | 0.078 | 1.001 | 0.554 | 1.002 | 1.001 | 1.001 | 1.001 | 1.001 | 0.078 | 1.002 |
| hex: http/js-1kx1024 | 2099200 | 18023.5 ± 1.7% | 1.002 | 0.125 | 1.002 | 0.801 | 1.003 | 0.922 | 1.003 | 1.000 | 1.023 | 0.121 | 1.007 |
| hex: http/js-16kx64 | 2097280 | 18938.3 ± 2.8% | 1.004 | 0.121 | 1.007 | 0.855 | 1.006 | 1.001 | 1.005 | 1.005 | 1.012 | 0.121 | 1.008 |
| hex: http/js-1m | 524290 | 29248.1 ± 0.2% | 1.002 | 0.079 | 1.001 | 0.559 | 1.001 | 1.000 | 1.002 | 1.001 | 1.002 | 0.079 | 1.002 |
| hex: http/css-1kx1024 | 2099200 | 17788.5 ± 4.5% | 1.004 | 0.126 | 1.004 | 0.812 | 1.003 | 0.926 | 1.005 | 1.003 | 1.026 | 0.123 | 1.009 |
| hex: http/css-16kx64 | 2097280 | 18792.3 ± 0.3% | 1.004 | 0.122 | 1.003 | 0.862 | 1.003 | 0.994 | 1.003 | 1.001 | 1.007 | 0.122 | 1.003 |
| hex: http/css-1m | 524290 | 29366.2 ± 5.9% | 1.001 | 0.079 | 1.002 | 0.557 | 1.001 | 1.001 | 1.002 | 1.000 | 1.001 | 0.079 | 1.002 |
| hex: shuffled/dickens-1m | 524290 | 29307.8 ± 0.5% | 1.000 | 0.079 | 1.001 | 0.560 | 1.002 | 1.001 | 1.002 | 0.999 | 0.999 | 0.079 | 1.002 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.092 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.097 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.095 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.097 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.064 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.069 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.053 of all on.
- messages: 11 string members, decoding: J7 wide vectors off runs at 1.052 of all on.
- messages: 11 string members, decoding: J12 decoder escape words off runs at 1.057 of all on.
- messages: 11 string members, decoding: J13 decoder escape blocks off runs at 1.056 of all on.
- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.087 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.079 of all on.
- messages: 50 nested objects, decoding: J8 decoder fast path off runs at 1.082 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.085 of all on.
- messages: 50 nested objects, decoding: J13 decoder escape blocks off runs at 1.080 of all on.
- messages: a tree of 341 objects, decoding: J5 UTF-8 vectors off runs at 1.071 of all on.
- messages: a tree of 341 objects, decoding: J7 wide vectors off runs at 1.052 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.054 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.055 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.112 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.128 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.075 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.158 of all on.
- string: canterbury/plrabn12.txt, decoding: J7 wide vectors off runs at 1.086 of all on.
- string: canterbury/plrabn12.txt, decoding: J8 decoder fast path off runs at 1.107 of all on.
- string: canterbury/plrabn12.txt, decoding: J13 decoder escape blocks off runs at 1.111 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.051 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.051 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 157874.8 ± 0.2% | 104880.7 ± 22.0% | 1.505 | 93629.8 ± 0.3% | 1.686 |
| string: silesia/nci | 1048576 | 89930.6 ± 0.2% | 78841.8 ± 2.3% | 1.141 | 73164.7 ± 0.3% | 1.229 |
| string: silesia/reymont | 1048576 | 140239.1 ± 1.2% | 101601.5 ± 0.2% | 1.380 | 87463.7 ± 0.4% | 1.603 |
| string: silesia/samba | 65546 | 151562.5 ± 0.3% | 102954.6 ± 1.5% | 1.472 | 91795.1 ± 0.6% | 1.651 |
| string: silesia/webster | 1048576 | 102496.7 ± 0.8% | 52650.1 ± 0.6% | 1.947 | 75997.0 ± 11.8% | 1.349 |
| string: silesia/xml | 1048576 | 111967.6 ± 6.7% | 89311.1 ± 11.8% | 1.254 | 81173.3 ± 3.0% | 1.379 |
| string: canterbury/alice29.txt | 152089 | 157914.4 ± 0.2% | 104638.6 ± 2.4% | 1.509 | 93402.7 ± 0.2% | 1.691 |
| string: canterbury/asyoulik.txt | 125179 | 157412.5 ± 0.1% | 104487.9 ± 0.9% | 1.507 | 94480.7 ± 0.3% | 1.666 |
| string: canterbury/lcet10.txt | 426754 | 155019.9 ± 0.1% | 106336.2 ± 0.1% | 1.458 | 95161.9 ± 1.5% | 1.629 |
| string: canterbury/plrabn12.txt | 481861 | 155262.5 ± 0.2% | 106402.7 ± 15.9% | 1.459 | 92590.9 ± 3.9% | 1.677 |
| string: canterbury-large/E.coli | 1048576 | 121754.0 ± 2.1% | 92347.9 ± 0.7% | 1.318 | 84061.1 ± 0.5% | 1.448 |
| string: canterbury-large/bible.txt | 1048576 | 132067.2 ± 0.3% | 97726.3 ± 2.2% | 1.351 | 86909.5 ± 1.7% | 1.520 |
| string: canterbury-large/world192.txt | 1048576 | 104894.5 ± 3.2% | 87704.9 ± 3.8% | 1.196 | 79518.2 ± 2.9% | 1.319 |
| string: http/html-1m | 1048576 | 94974.9 ± 0.3% | 79510.1 ± 2.4% | 1.195 | 71764.4 ± 1.7% | 1.323 |
| string: http/json-1m | 1048576 | 98059.3 ± 0.5% | 83525.5 ± 0.5% | 1.174 | 67669.0 ± 0.4% | 1.449 |
| string: http/js-1m | 1048576 | 118632.8 ± 0.2% | 92415.9 ± 17.3% | 1.284 | 82792.4 ± 1.3% | 1.433 |
| string: http/css-1m | 1048576 | 103904.3 ± 1.1% | 85390.3 ± 14.2% | 1.217 | 79237.3 ± 0.3% | 1.311 |
| string: dickens as Cyrillic and CJK | 1847045 | 20685.6 ± 0.1% | 17872.8 ± 1.0% | 1.157 | 13349.1 ± 0.1% | 1.550 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 155806.4 ± 0.8% | 53940.9 ± 0.2% | 2.888 | 95155.0 ± 0.5% | 1.637 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 154040.2 ± 0.5% | 107042.4 ± 0.4% | 1.439 | 93260.3 ± 1.3% | 1.652 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 153923.1 ± 1.9% | 106925.3 ± 1.6% | 1.440 | 93219.7 ± 1.4% | 1.651 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 153861.1 ± 1.9% | 107141.2 ± 3.2% | 1.436 | 93162.7 ± 0.3% | 1.652 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 154313.5 ± 0.8% | 106943.6 ± 1.6% | 1.443 | 93271.5 ± 23.6% | 1.654 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 154264.8 ± 0.2% | 107173.9 ± 1.7% | 1.439 | 95218.9 ± 0.3% | 1.620 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 20735.7 ± 0.4% | 17799.8 ± 0.6% | 1.165 | 13233.6 ± 0.0% | 1.567 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 20661.6 ± 0.2% | 17800.3 ± 0.4% | 1.161 | 13289.6 ± 0.7% | 1.555 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 20647.2 ± 0.1% | 17815.1 ± 0.1% | 1.159 | 13276.1 ± 0.5% | 1.555 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 20614.0 ± 1.0% | 17798.1 ± 0.2% | 1.158 | 12942.1 ± 5.3% | 1.593 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 20679.2 ± 0.2% | 17803.9 ± 0.5% | 1.161 | 12939.6 ± 2.8% | 1.598 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 20646.2 ± 2.6% | 17627.0 ± 1.4% | 1.171 | 13220.9 ± 2.5% | 1.562 |

## Messages against serde_json's typed code

stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.

| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |
|---|---|---|---|---|
| messages: 11 string members | 1025025 | 1023.1 ± 1.8% | 582.4 ± 1.1% | 1.757 |
| messages: 50 nested objects | 1121600 | 1191.6 ± 1.4% | 594.0 ± 17.3% | 2.006 |
| messages: a tree of 341 objects | 612600 | 494.2 ± 4.9% | 381.5 ± 8.3% | 1.296 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1034.3 ± 0.6% | 1120.9 ± 0.6% | 852.0 ± 2.0% | 322.1 ± 0.8% | 528.9 ± 0.6% | 293.6 ± 2.3% | 0.923 | 1.214 | 3.211 | 1.955 | 3.523 |
| qlog records, JSON text sequence | 1467503 | 681.5 ± 1.8% | 936.4 ± 0.3% | 824.5 ± 2.9% | 268.5 ± 1.2% | 597.1 ± 1.4% | 253.6 ± 1.9% | 0.728 | 0.827 | 2.538 | 1.141 | 2.687 |
| messages: 11 string members | 1025025 | 797.1 ± 1.8% | 1195.8 ± 0.4% | 578.7 ± 0.2% | 278.5 ± 0.9% | 419.3 ± 4.9% | 243.6 ± 1.0% | 0.667 | 1.377 | 2.862 | 1.901 | 3.273 |
| messages: 50 nested objects | 1121600 | 1037.1 ± 0.5% | 1025.8 ± 1.1% | 964.7 ± 0.2% | 346.2 ± 0.6% | 645.2 ± 1.3% | 328.7 ± 1.4% | 1.011 | 1.075 | 2.996 | 1.607 | 3.155 |
| messages: a tree of 341 objects | 612600 | 496.2 ± 0.4% | 634.5 ± 0.1% | 470.0 ± 0.5% | 154.9 ± 0.4% | 488.4 ± 1.7% | 153.0 ± 2.1% | 0.782 | 1.056 | 3.204 | 1.016 | 3.244 |
| string: silesia/dickens | 172528 | 5854.1 ± 4.4% | 2894.6 ± 5.6% | 2359.9 ± 2.3% | 263.6 ± 2.3% | 2204.4 ± 5.0% | 501.5 ± 2.8% | 2.022 | 2.481 | 22.207 | 2.656 | 11.674 |
| string: silesia/nci | 1075110 | 4969.6 ± 2.6% | 3205.6 ± 0.6% | 2224.6 ± 0.2% | 565.5 ± 1.3% | 2370.6 ± 0.4% | 527.2 ± 1.6% | 1.550 | 2.234 | 8.788 | 2.096 | 9.427 |
| string: silesia/reymont | 1075159 | 3168.4 ± 1.9% | 2558.0 ± 0.2% | 1548.9 ± 0.5% | 283.6 ± 0.6% | 1606.4 ± 1.1% | 459.4 ± 1.0% | 1.239 | 2.046 | 11.173 | 1.972 | 6.897 |
| string: silesia/samba | 97582 | 2802.3 ± 0.7% | 2803.0 ± 0.3% | 2178.4 ± 1.8% | 274.0 ± 0.4% | 1345.0 ± 1.1% | 354.7 ± 1.5% | 1.000 | 1.286 | 10.227 | 2.083 | 7.900 |
| string: silesia/webster | 1098490 | 3799.0 ± 0.8% | 1993.2 ± 0.1% | 1436.0 ± 0.5% | 256.9 ± 3.1% | 1596.7 ± 0.8% | 421.1 ± 1.2% | 1.906 | 2.646 | 14.786 | 2.379 | 9.021 |
| string: silesia/xml | 1090118 | 4672.2 ± 0.5% | 3559.3 ± 0.1% | 1849.5 ± 0.5% | 420.6 ± 4.8% | 2273.6 ± 0.3% | 504.4 ± 1.1% | 1.313 | 2.526 | 11.108 | 2.055 | 9.263 |
| string: canterbury/alice29.txt | 159425 | 5175.5 ± 1.2% | 2453.4 ± 0.4% | 2347.3 ± 0.9% | 248.6 ± 0.1% | 2016.0 ± 0.6% | 454.2 ± 1.1% | 2.110 | 2.205 | 20.817 | 2.567 | 11.395 |
| string: canterbury/asyoulik.txt | 132198 | 3451.3 ± 0.9% | 1970.0 ± 1.5% | 2102.2 ± 8.9% | 250.5 ± 0.2% | 1639.0 ± 2.1% | 398.0 ± 1.1% | 1.752 | 1.642 | 13.777 | 2.106 | 8.672 |
| string: canterbury/lcet10.txt | 441884 | 5979.2 ± 0.5% | 2724.6 ± 0.7% | 1808.3 ± 0.6% | 289.5 ± 2.6% | 2071.9 ± 0.8% | 480.1 ± 0.7% | 2.194 | 3.307 | 20.653 | 2.886 | 12.454 |
| string: canterbury/plrabn12.txt | 503330 | 3986.9 ± 0.2% | 2352.7 ± 1.0% | 1536.0 ± 0.3% | 267.6 ± 0.3% | 2022.1 ± 1.0% | 437.8 ± 1.2% | 1.695 | 2.596 | 14.897 | 1.972 | 9.106 |
| string: canterbury-large/E.coli | 1048578 | 15208.0 ± 8.2% | 7674.7 ± 0.4% | 2753.9 ± 0.8% | 986.9 ± 8.0% | 5213.2 ± 7.8% | 908.5 ± 22.1% | 1.982 | 5.522 | 15.409 | 2.917 | 16.740 |
| string: canterbury-large/bible.txt | 1055886 | 8340.6 ± 3.3% | 4598.3 ± 2.7% | 2073.9 ± 0.9% | 306.2 ± 1.7% | 3018.8 ± 1.2% | 584.8 ± 0.9% | 1.814 | 4.022 | 27.236 | 2.763 | 14.261 |
| string: canterbury-large/world192.txt | 1103121 | 3603.6 ± 1.1% | 1882.0 ± 0.6% | 1458.0 ± 0.2% | 268.7 ± 0.6% | 1624.9 ± 1.1% | 420.4 ± 1.9% | 1.915 | 2.472 | 13.411 | 2.218 | 8.571 |
| string: http/html-1m | 1058582 | 7847.4 ± 1.1% | 3922.2 ± 1.3% | 2020.1 ± 0.8% | 351.9 ± 0.3% | 2758.7 ± 1.2% | 565.4 ± 1.3% | 2.001 | 3.885 | 22.301 | 2.845 | 13.878 |
| string: http/json-1m | 1190272 | 2834.0 ± 0.5% | 1057.5 ± 0.2% | 1683.4 ± 5.9% | 383.8 ± 9.3% | 841.7 ± 6.5% | 360.2 ± 2.0% | 2.680 | 1.684 | 7.385 | 3.367 | 7.869 |
| string: http/js-1m | 1144362 | 2514.7 ± 0.2% | 1394.6 ± 3.1% | 1129.0 ± 2.8% | 263.3 ± 2.2% | 1095.5 ± 2.9% | 334.9 ± 3.6% | 1.803 | 2.227 | 9.549 | 2.296 | 7.510 |
| string: http/css-1m | 1097820 | 2734.4 ± 4.4% | 2179.0 ± 3.9% | 1639.2 ± 3.5% | 369.8 ± 2.9% | 1445.4 ± 3.5% | 403.9 ± 2.6% | 1.255 | 1.668 | 7.394 | 1.892 | 6.769 |
| string: dickens as Cyrillic and CJK | 1883069 | 4711.4 ± 10.0% | 3242.4 ± 1.2% | 613.5 ± 0.3% | 283.3 ± 0.8% | 442.5 ± 3.8% | 128.8 ± 0.6% | 1.453 | 7.679 | 16.631 | 10.647 | 36.589 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 906.9 ± 0.9% | 1010.9 ± 0.5% | 929.3 ± 1.0% | 195.1 ± 0.8% | 370.3 ± 0.2% | 185.6 ± 2.5% | 0.897 | 0.976 | 4.648 | 2.449 | 4.887 |
| hex: silesia/dickens | 524290 | 38035.1 ± 4.6% | 10167.0 ± 0.7% | 3048.5 ± 0.2% | 399.1 ± 1.2% | 5225.5 ± 2.5% | 948.8 ± 1.8% | 3.741 | 12.477 | 95.294 | 7.279 | 40.088 |
| hex: silesia/mozilla | 524290 | 37209.7 ± 0.5% | 10163.8 ± 4.2% | 2966.2 ± 0.2% | 343.5 ± 2.0% | 5222.4 ± 0.3% | 955.2 ± 3.1% | 3.661 | 12.545 | 108.315 | 7.125 | 38.953 |
| hex: silesia/mr | 524290 | 30219.3 ± 0.5% | 10162.0 ± 0.6% | 2969.2 ± 0.2% | 519.0 ± 0.9% | 5223.8 ± 0.6% | 948.7 ± 11.9% | 2.974 | 10.178 | 58.222 | 5.785 | 31.853 |
| hex: silesia/nci | 524290 | 35694.1 ± 1.0% | 10165.4 ± 4.5% | 3058.9 ± 5.5% | 660.1 ± 0.9% | 5213.3 ± 0.4% | 947.7 ± 1.3% | 3.511 | 11.669 | 54.073 | 6.847 | 37.665 |
| hex: silesia/ooffice | 524290 | 41454.5 ± 0.7% | 10165.8 ± 0.2% | 2987.1 ± 0.4% | 282.2 ± 2.7% | 5221.9 ± 0.6% | 937.0 ± 1.9% | 4.078 | 13.878 | 146.914 | 7.939 | 44.242 |
| hex: silesia/osdb | 524290 | 28997.7 ± 0.5% | 10166.3 ± 0.2% | 2994.1 ± 6.1% | 387.6 ± 3.1% | 5224.2 ± 1.4% | 941.0 ± 2.9% | 2.852 | 9.685 | 74.819 | 5.551 | 30.816 |
| hex: silesia/reymont | 524290 | 36916.2 ± 2.0% | 10170.9 ± 0.3% | 3027.0 ± 0.8% | 426.9 ± 5.9% | 5223.5 ± 0.6% | 955.2 ± 3.4% | 3.630 | 12.196 | 86.475 | 7.067 | 38.646 |
| hex: silesia/samba | 524290 | 34940.5 ± 0.9% | 10166.2 ± 0.3% | 2998.3 ± 0.3% | 300.3 ± 2.5% | 5225.2 ± 0.2% | 947.9 ± 2.9% | 3.437 | 11.653 | 116.349 | 6.687 | 36.863 |
| hex: silesia/sao | 524290 | 36757.8 ± 0.3% | 10162.5 ± 0.2% | 3003.9 ± 0.1% | 225.2 ± 2.8% | 5217.6 ± 1.1% | 942.4 ± 1.7% | 3.617 | 12.237 | 163.245 | 7.045 | 39.006 |
| hex: silesia/webster | 524290 | 32270.3 ± 0.4% | 10166.3 ± 7.5% | 3023.9 ± 0.4% | 382.6 ± 3.3% | 5221.9 ± 0.3% | 947.5 ± 1.5% | 3.174 | 10.672 | 84.343 | 6.180 | 34.058 |
| hex: silesia/x-ray | 524290 | 35526.0 ± 3.0% | 10160.4 ± 0.1% | 2974.0 ± 0.1% | 362.2 ± 2.8% | 5222.3 ± 1.5% | 935.1 ± 2.1% | 3.497 | 11.945 | 98.074 | 6.803 | 37.993 |
| hex: silesia/xml | 524290 | 33221.2 ± 0.4% | 10166.2 ± 0.1% | 3018.4 ± 0.3% | 642.9 ± 1.5% | 5221.6 ± 0.3% | 953.5 ± 2.4% | 3.268 | 11.006 | 51.674 | 6.362 | 34.841 |
| hex: canterbury/alice29.txt | 304180 | 41453.5 ± 1.1% | 11023.1 ± 0.2% | 3001.4 ± 0.2% | 402.7 ± 3.4% | 5216.1 ± 0.4% | 979.4 ± 14.4% | 3.761 | 13.811 | 102.932 | 7.947 | 42.323 |
| hex: canterbury/asyoulik.txt | 250360 | 41414.4 ± 6.6% | 10476.2 ± 0.2% | 2977.9 ± 0.6% | 395.3 ± 3.1% | 5220.0 ± 7.9% | 961.0 ± 5.6% | 3.953 | 13.907 | 104.756 | 7.934 | 43.096 |
| hex: canterbury/cp.html | 49208 | 33820.9 ± 0.3% | 11258.4 ± 0.6% | 3077.8 ± 0.2% | 433.8 ± 3.5% | 5211.0 ± 0.8% | 943.9 ± 2.8% | 3.004 | 10.988 | 77.970 | 6.490 | 35.831 |
| hex: canterbury/fields.c | 22302 | 42505.4 ± 0.9% | 12132.8 ± 0.4% | 3132.1 ± 0.2% | 513.2 ± 0.9% | 5193.8 ± 0.4% | 929.2 ± 2.9% | 3.503 | 13.571 | 82.821 | 8.184 | 45.746 |
| hex: canterbury/grammar.lsp | 7444 | 36962.6 ± 0.5% | 11787.3 ± 0.5% | 3096.7 ± 10.1% | 666.3 ± 7.5% | 5119.6 ± 0.2% | 889.2 ± 4.0% | 3.136 | 11.936 | 55.471 | 7.220 | 41.567 |
| hex: canterbury/kennedy.xls | 524290 | 39051.6 ± 1.6% | 10302.1 ± 0.3% | 3069.9 ± 2.5% | 677.8 ± 0.1% | 5222.6 ± 0.4% | 926.4 ± 16.6% | 3.791 | 12.721 | 57.619 | 7.477 | 42.156 |
| hex: canterbury/lcet10.txt | 524290 | 40233.8 ± 1.0% | 10297.4 ± 2.1% | 3058.6 ± 1.2% | 401.6 ± 3.8% | 5222.7 ± 1.0% | 905.6 ± 4.7% | 3.907 | 13.154 | 100.191 | 7.704 | 44.427 |
| hex: canterbury/plrabn12.txt | 524290 | 36173.1 ± 1.1% | 10294.9 ± 1.3% | 3046.9 ± 0.2% | 389.0 ± 3.5% | 5223.4 ± 1.3% | 917.0 ± 2.5% | 3.514 | 11.872 | 92.997 | 6.925 | 39.447 |
| hex: canterbury/ptt5 | 524290 | 36937.3 ± 0.4% | 10288.8 ± 0.2% | 2949.7 ± 0.3% | 519.8 ± 3.8% | 5227.0 ± 0.2% | 901.5 ± 3.7% | 3.590 | 12.522 | 71.060 | 7.067 | 40.974 |
| hex: canterbury/sum | 76482 | 39963.5 ± 0.8% | 10740.4 ± 0.2% | 3068.2 ± 0.8% | 491.2 ± 5.5% | 5213.1 ± 0.4% | 938.6 ± 3.5% | 3.721 | 13.025 | 81.363 | 7.666 | 42.579 |
| hex: canterbury/xargs.1 | 8456 | 37132.0 ± 1.1% | 11851.2 ± 0.5% | 3037.6 ± 0.2% | 664.5 ± 1.7% | 5122.6 ± 0.6% | 921.4 ± 3.6% | 3.133 | 12.224 | 55.876 | 7.249 | 40.298 |
| hex: canterbury-large/E.coli | 524290 | 38189.9 ± 1.6% | 10282.0 ± 1.5% | 2992.3 ± 0.4% | 693.7 ± 0.6% | 5211.2 ± 0.5% | 945.0 ± 8.1% | 3.714 | 12.763 | 55.055 | 7.328 | 40.414 |
| hex: canterbury-large/bible.txt | 524290 | 38337.2 ± 0.5% | 10126.9 ± 0.8% | 2999.2 ± 4.3% | 418.2 ± 3.2% | 5225.5 ± 0.2% | 940.4 ± 0.8% | 3.786 | 12.783 | 91.674 | 7.337 | 40.766 |
| hex: canterbury-large/world192.txt | 524290 | 35489.8 ± 0.3% | 10084.8 ± 4.1% | 3033.6 ± 4.8% | 398.6 ± 3.9% | 5216.5 ± 0.5% | 941.3 ± 1.7% | 3.519 | 11.699 | 89.035 | 6.803 | 37.702 |
| hex: http/html-1kx1024 | 2099200 | 14165.2 ± 1.2% | 8780.1 ± 0.2% | 2776.9 ± 0.3% | 438.0 ± 3.0% | 4629.6 ± 0.6% | 780.0 ± 6.3% | 1.613 | 5.101 | 32.340 | 3.060 | 18.160 |
| hex: http/html-16kx64 | 2097280 | 24577.3 ± 0.9% | 11302.2 ± 0.2% | 2910.6 ± 0.1% | 433.6 ± 3.4% | 5195.2 ± 0.3% | 904.4 ± 2.3% | 2.175 | 8.444 | 56.676 | 4.731 | 27.176 |
| hex: http/html-1m | 524290 | 41590.0 ± 0.3% | 10251.0 ± 0.4% | 2952.1 ± 1.4% | 431.0 ± 3.2% | 5219.8 ± 0.6% | 950.6 ± 7.3% | 4.057 | 14.088 | 96.498 | 7.968 | 43.751 |
| hex: http/json-1kx1024 | 2099200 | 14172.9 ± 1.0% | 8783.3 ± 0.2% | 2781.0 ± 0.1% | 623.6 ± 0.8% | 4632.1 ± 1.1% | 791.8 ± 2.3% | 1.614 | 5.096 | 22.729 | 3.060 | 17.899 |
| hex: http/json-16kx64 | 2097280 | 24682.5 ± 0.2% | 11296.0 ± 11.6% | 2901.9 ± 7.0% | 639.5 ± 0.4% | 5188.6 ± 1.0% | 888.8 ± 0.7% | 2.185 | 8.506 | 38.599 | 4.757 | 27.770 |
| hex: http/json-1m | 524290 | 31621.0 ± 1.4% | 10179.7 ± 0.7% | 3034.4 ± 0.3% | 675.8 ± 0.2% | 5228.5 ± 0.2% | 946.3 ± 1.1% | 3.106 | 10.421 | 46.790 | 6.048 | 33.415 |
| hex: http/js-1kx1024 | 2099200 | 14138.2 ± 0.5% | 8766.7 ± 0.2% | 2780.8 ± 0.2% | 430.0 ± 3.1% | 4627.9 ± 1.5% | 789.3 ± 2.1% | 1.613 | 5.084 | 32.876 | 3.055 | 17.912 |
| hex: http/js-16kx64 | 2097280 | 24449.0 ± 0.4% | 11292.3 ± 0.4% | 2909.8 ± 0.6% | 425.4 ± 4.9% | 5192.7 ± 0.5% | 899.4 ± 2.9% | 2.165 | 8.402 | 57.474 | 4.708 | 27.184 |
| hex: http/js-1m | 524290 | 38512.6 ± 1.5% | 10424.9 ± 0.3% | 3068.7 ± 0.4% | 442.3 ± 2.7% | 5216.3 ± 0.4% | 933.2 ± 2.2% | 3.694 | 12.550 | 87.067 | 7.383 | 41.271 |
| hex: http/css-1kx1024 | 2099200 | 13993.7 ± 8.8% | 8786.5 ± 0.4% | 2769.3 ± 0.7% | 485.2 ± 2.6% | 4634.0 ± 1.8% | 780.4 ± 2.5% | 1.593 | 5.053 | 28.838 | 3.020 | 17.932 |
| hex: http/css-16kx64 | 2097280 | 24476.6 ± 1.2% | 11301.0 ± 0.5% | 2901.8 ± 0.1% | 496.4 ± 2.4% | 5186.3 ± 0.2% | 883.1 ± 2.2% | 2.166 | 8.435 | 49.304 | 4.719 | 27.718 |
| hex: http/css-1m | 524290 | 41949.1 ± 1.4% | 10069.4 ± 0.3% | 3038.6 ± 0.3% | 474.1 ± 1.5% | 5224.5 ± 0.3% | 934.3 ± 9.0% | 4.166 | 13.805 | 88.491 | 8.029 | 44.899 |
| hex: shuffled/dickens-1m | 524290 | 40828.8 ± 1.2% | 10253.1 ± 0.4% | 3005.0 ± 0.8% | 410.1 ± 4.0% | 5226.3 ± 0.4% | 939.0 ± 2.1% | 3.982 | 13.587 | 99.548 | 7.812 | 43.479 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1374.2 ± 0.4% | 1108.2 ± 0.9% | 837.2 ± 0.8% | 367.5 ± 0.5% | 359.2 ± 2.6% | 390.2 ± 0.7% | 1.240 | 1.641 | 3.740 | 3.826 | 3.521 |
| qlog records, JSON text sequence | 1467503 | 1052.6 ± 2.2% | 844.8 ± 3.0% | 689.1 ± 3.9% | 326.0 ± 3.1% | 348.8 ± 9.1% | 250.2 ± 5.5% | 1.246 | 1.527 | 3.229 | 3.018 | 4.208 |
| messages: 11 string members | 1025025 | 1042.6 ± 0.4% | 831.4 ± 0.2% | 633.4 ± 0.7% | 329.8 ± 4.4% | 326.7 ± 4.8% | 324.1 ± 1.1% | 1.254 | 1.646 | 3.161 | 3.191 | 3.217 |
| messages: 50 nested objects | 1121600 | 1401.9 ± 13.8% | 1210.2 ± 0.7% | 1019.4 ± 2.7% | 441.0 ± 1.2% | 433.1 ± 0.7% | 395.0 ± 12.0% | 1.158 | 1.375 | 3.179 | 3.237 | 3.549 |
| messages: a tree of 341 objects | 612600 | 480.3 ± 5.7% | 587.9 ± 2.0% | 422.2 ± 3.1% | 240.6 ± 3.0% | 270.3 ± 5.1% | 144.7 ± 2.5% | 0.817 | 1.138 | 1.996 | 1.777 | 3.320 |
| string: silesia/dickens | 172528 | 9914.0 ± 1.6% | 2960.3 ± 1.4% | 2393.6 ± 3.9% | 272.1 ± 0.9% | 1143.5 ± 3.6% | 1028.2 ± 1.3% | 3.349 | 4.142 | 36.434 | 8.670 | 9.642 |
| string: silesia/nci | 1075110 | 8365.8 ± 2.3% | 3197.2 ± 0.4% | 2432.4 ± 0.2% | 791.9 ± 1.4% | 1214.8 ± 1.3% | 1014.3 ± 15.5% | 2.617 | 3.439 | 10.564 | 6.887 | 8.248 |
| string: silesia/reymont | 1075159 | 4395.5 ± 4.7% | 1507.0 ± 0.6% | 1599.2 ± 6.0% | 313.5 ± 0.8% | 1037.3 ± 0.2% | 923.9 ± 0.3% | 2.917 | 2.749 | 14.020 | 4.238 | 4.757 |
| string: silesia/samba | 97582 | 4428.3 ± 9.2% | 2003.7 ± 0.9% | 2776.7 ± 2.1% | 265.2 ± 0.6% | 994.0 ± 0.5% | 1005.3 ± 1.5% | 2.210 | 1.595 | 16.698 | 4.455 | 4.405 |
| string: silesia/webster | 1098490 | 5691.7 ± 2.3% | 1511.3 ± 0.4% | 1503.9 ± 1.1% | 290.6 ± 0.5% | 1009.9 ± 2.1% | 514.9 ± 1.0% | 3.766 | 3.785 | 19.584 | 5.636 | 11.053 |
| string: silesia/xml | 1090118 | 7925.0 ± 2.0% | 2373.6 ± 0.4% | 2015.3 ± 2.3% | 500.6 ± 0.8% | 1192.9 ± 1.8% | 808.7 ± 8.4% | 3.339 | 3.932 | 15.830 | 6.644 | 9.800 |
| string: canterbury/alice29.txt | 159425 | 9230.0 ± 3.0% | 2223.3 ± 1.3% | 2223.0 ± 0.1% | 261.2 ± 1.1% | 1075.5 ± 2.3% | 930.8 ± 0.9% | 4.151 | 4.152 | 35.340 | 8.582 | 9.916 |
| string: canterbury/asyoulik.txt | 132198 | 8047.1 ± 0.5% | 1644.4 ± 0.5% | 2237.4 ± 9.4% | 259.3 ± 0.8% | 967.7 ± 2.2% | 827.3 ± 0.6% | 4.894 | 3.597 | 31.038 | 8.316 | 9.727 |
| string: canterbury/lcet10.txt | 441884 | 8852.3 ± 2.5% | 2358.9 ± 1.4% | 2070.3 ± 0.7% | 306.5 ± 0.8% | 1102.5 ± 8.6% | 996.8 ± 0.9% | 3.753 | 4.276 | 28.885 | 8.030 | 8.881 |
| string: canterbury/plrabn12.txt | 503330 | 6721.8 ± 3.1% | 1733.4 ± 1.1% | 1757.1 ± 1.1% | 279.4 ± 0.9% | 1048.4 ± 1.6% | 896.0 ± 0.5% | 3.878 | 3.826 | 24.054 | 6.411 | 7.502 |
| string: canterbury-large/E.coli | 1048578 | 15937.3 ± 0.5% | 8845.5 ± 0.4% | 2593.5 ± 0.3% | 1488.7 ± 0.6% | 1491.3 ± 0.8% | 1072.2 ± 0.9% | 1.802 | 6.145 | 10.706 | 10.687 | 14.864 |
| string: canterbury-large/bible.txt | 1055886 | 8235.7 ± 2.8% | 3677.0 ± 0.5% | 2307.9 ± 0.9% | 331.2 ± 0.3% | 1308.4 ± 0.8% | 1162.5 ± 1.7% | 2.240 | 3.569 | 24.863 | 6.295 | 7.084 |
| string: canterbury-large/world192.txt | 1103121 | 5354.9 ± 2.8% | 1319.6 ± 0.5% | 1594.8 ± 24.6% | 287.8 ± 1.0% | 992.5 ± 1.1% | 839.2 ± 0.9% | 4.058 | 3.358 | 18.603 | 5.395 | 6.381 |
| string: http/html-1m | 1058582 | 8373.8 ± 12.8% | 3379.9 ± 1.0% | 2252.5 ± 1.1% | 339.4 ± 1.1% | 1283.4 ± 0.3% | 710.2 ± 1.1% | 2.477 | 3.717 | 24.669 | 6.525 | 11.790 |
| string: http/json-1m | 1190272 | 6436.6 ± 0.8% | 1150.5 ± 3.5% | 1353.6 ± 0.7% | 434.3 ± 2.8% | 769.1 ± 0.3% | 688.8 ± 0.4% | 5.595 | 4.755 | 14.822 | 8.369 | 9.345 |
| string: http/js-1m | 1144362 | 5323.4 ± 3.2% | 878.4 ± 0.8% | 1191.8 ± 0.4% | 265.4 ± 1.7% | 823.6 ± 0.7% | 664.4 ± 0.8% | 6.060 | 4.467 | 20.058 | 6.464 | 8.012 |
| string: http/css-1m | 1097820 | 7258.6 ± 1.3% | 1141.2 ± 0.6% | 1732.3 ± 1.2% | 396.6 ± 5.2% | 930.7 ± 0.4% | 811.9 ± 0.6% | 6.361 | 4.190 | 18.301 | 7.799 | 8.941 |
| string: dickens as Cyrillic and CJK | 1883069 | 4521.5 ± 0.4% | 2881.8 ± 1.0% | 421.1 ± 1.8% | 209.8 ± 0.7% | 373.2 ± 0.1% | 277.4 ± 1.1% | 1.569 | 10.737 | 21.552 | 12.114 | 16.302 |
| hex: silesia/dickens | 524290 | 28720.8 ± 0.3% | 1699.7 ± 0.1% | 1060.5 ± 0.2% | 386.1 ± 0.4% | 883.8 ± 1.0% | 799.8 ± 3.0% | 16.897 | 27.082 | 74.394 | 32.497 | 35.912 |
| hex: silesia/mozilla | 524290 | 29233.8 ± 0.3% | 1704.0 ± 0.2% | 1060.0 ± 0.5% | 326.2 ± 1.0% | 879.2 ± 10.6% | 799.3 ± 2.4% | 17.156 | 27.580 | 89.633 | 33.252 | 36.576 |
| hex: silesia/mr | 524290 | 29304.2 ± 2.1% | 1695.5 ± 0.1% | 1058.4 ± 0.3% | 489.1 ± 0.5% | 884.1 ± 0.2% | 794.7 ± 1.1% | 17.284 | 27.686 | 59.916 | 33.145 | 36.873 |
| hex: silesia/nci | 524290 | 30082.8 ± 0.6% | 1705.6 ± 0.1% | 1059.5 ± 14.9% | 653.8 ± 0.5% | 880.0 ± 0.3% | 795.3 ± 1.2% | 17.638 | 28.393 | 46.011 | 34.187 | 37.825 |
| hex: silesia/ooffice | 524290 | 29418.9 ± 0.3% | 1696.1 ± 0.8% | 1057.8 ± 0.5% | 267.5 ± 0.6% | 885.0 ± 0.1% | 799.6 ± 27.6% | 17.346 | 27.812 | 109.957 | 33.243 | 36.793 |
| hex: silesia/osdb | 524290 | 28769.3 ± 0.3% | 1702.5 ± 0.5% | 1061.5 ± 0.2% | 363.6 ± 1.3% | 878.8 ± 0.3% | 794.3 ± 0.9% | 16.899 | 27.102 | 79.129 | 32.737 | 36.222 |
| hex: silesia/reymont | 524290 | 29470.2 ± 4.2% | 1695.4 ± 0.8% | 1060.8 ± 0.2% | 408.4 ± 8.6% | 881.5 ± 4.9% | 796.0 ± 4.2% | 17.383 | 27.780 | 72.161 | 33.432 | 37.022 |
| hex: silesia/samba | 524290 | 30218.1 ± 0.3% | 1703.7 ± 5.2% | 1061.5 ± 4.0% | 288.4 ± 7.9% | 879.1 ± 0.7% | 811.6 ± 3.9% | 17.736 | 28.467 | 104.784 | 34.374 | 37.232 |
| hex: silesia/sao | 524290 | 29214.8 ± 0.9% | 1695.5 ± 1.0% | 1060.8 ± 0.1% | 217.7 ± 0.8% | 881.7 ± 0.5% | 802.4 ± 4.2% | 17.231 | 27.541 | 134.209 | 33.135 | 36.408 |
| hex: silesia/webster | 524290 | 31167.5 ± 0.9% | 1702.8 ± 0.6% | 1059.7 ± 0.3% | 351.4 ± 0.6% | 877.6 ± 1.3% | 798.2 ± 1.3% | 18.304 | 29.412 | 88.703 | 35.514 | 39.047 |
| hex: silesia/x-ray | 524290 | 29223.1 ± 0.6% | 1697.4 ± 0.1% | 1061.9 ± 0.3% | 341.7 ± 1.5% | 881.4 ± 0.3% | 796.3 ± 3.9% | 17.216 | 27.518 | 85.528 | 33.155 | 36.697 |
| hex: silesia/xml | 524290 | 30258.5 ± 0.5% | 1704.6 ± 0.4% | 1060.8 ± 0.3% | 582.0 ± 8.3% | 878.8 ± 0.2% | 796.3 ± 0.8% | 17.751 | 28.525 | 51.995 | 34.433 | 38.001 |
| hex: canterbury/alice29.txt | 304180 | 28802.3 ± 0.1% | 1702.0 ± 10.3% | 1073.4 ± 3.3% | 389.6 ± 0.2% | 891.0 ± 0.2% | 827.8 ± 1.1% | 16.922 | 26.832 | 73.919 | 32.327 | 34.795 |
| hex: canterbury/asyoulik.txt | 250360 | 29153.6 ± 0.7% | 1724.9 ± 0.4% | 1083.8 ± 0.2% | 381.0 ± 0.5% | 888.7 ± 0.8% | 831.3 ± 3.1% | 16.902 | 26.898 | 76.512 | 32.806 | 35.069 |
| hex: canterbury/cp.html | 49208 | 28567.1 ± 1.0% | 1720.8 ± 1.0% | 1075.5 ± 0.2% | 384.7 ± 1.4% | 891.9 ± 0.2% | 844.0 ± 1.7% | 16.601 | 26.562 | 74.266 | 32.031 | 33.846 |
| hex: canterbury/fields.c | 22302 | 29306.9 ± 0.5% | 1723.8 ± 0.2% | 1077.5 ± 0.1% | 597.9 ± 1.2% | 892.5 ± 1.4% | 848.9 ± 2.7% | 17.002 | 27.198 | 49.014 | 32.838 | 34.522 |
| hex: canterbury/grammar.lsp | 7444 | 27491.7 ± 0.2% | 1773.3 ± 1.0% | 1091.9 ± 0.1% | 677.0 ± 1.4% | 901.2 ± 0.1% | 854.7 ± 2.2% | 15.503 | 25.178 | 40.607 | 30.504 | 32.164 |
| hex: canterbury/kennedy.xls | 524290 | 29364.4 ± 0.7% | 1691.5 ± 0.4% | 1059.5 ± 0.2% | 641.2 ± 1.5% | 868.5 ± 0.3% | 797.6 ± 0.8% | 17.360 | 27.715 | 45.795 | 33.809 | 36.817 |
| hex: canterbury/lcet10.txt | 524290 | 30195.7 ± 0.4% | 1705.2 ± 0.2% | 1061.5 ± 2.1% | 388.0 ± 0.2% | 880.8 ± 2.2% | 794.8 ± 1.2% | 17.708 | 28.446 | 77.821 | 34.284 | 37.992 |
| hex: canterbury/plrabn12.txt | 524290 | 29187.3 ± 0.3% | 1692.0 ± 0.2% | 1059.5 ± 0.8% | 373.8 ± 4.4% | 868.1 ± 1.3% | 797.2 ± 4.0% | 17.250 | 27.547 | 78.091 | 33.623 | 36.613 |
| hex: canterbury/ptt5 | 524290 | 29216.0 ± 0.4% | 1698.2 ± 0.5% | 1059.1 ± 0.2% | 492.0 ± 0.4% | 882.7 ± 0.4% | 793.9 ± 3.5% | 17.204 | 27.586 | 59.377 | 33.100 | 36.802 |
| hex: canterbury/sum | 76482 | 28778.4 ± 7.5% | 1723.4 ± 0.6% | 1075.6 ± 4.6% | 453.3 ± 6.3% | 891.8 ± 7.2% | 843.3 ± 10.8% | 16.698 | 26.755 | 63.483 | 32.271 | 34.125 |
| hex: canterbury/xargs.1 | 8456 | 27624.5 ± 0.3% | 1769.6 ± 6.7% | 1089.4 ± 0.2% | 685.0 ± 0.4% | 899.7 ± 0.1% | 855.6 ± 2.1% | 15.610 | 25.358 | 40.330 | 30.705 | 32.286 |
| hex: canterbury-large/E.coli | 524290 | 28735.4 ± 0.2% | 1707.3 ± 1.7% | 1061.6 ± 0.3% | 658.5 ± 1.3% | 879.9 ± 14.6% | 793.7 ± 1.6% | 16.831 | 27.069 | 43.638 | 32.659 | 36.207 |
| hex: canterbury-large/bible.txt | 524290 | 30247.1 ± 0.2% | 1704.4 ± 0.2% | 1061.1 ± 1.0% | 402.4 ± 0.2% | 881.8 ± 0.2% | 795.1 ± 3.9% | 17.746 | 28.507 | 75.176 | 34.303 | 38.040 |
| hex: canterbury-large/world192.txt | 524290 | 29421.0 ± 0.2% | 1702.7 ± 0.2% | 1061.5 ± 0.5% | 379.9 ± 0.3% | 883.3 ± 0.3% | 798.9 ± 4.0% | 17.279 | 27.716 | 77.445 | 33.310 | 36.829 |
| hex: http/html-1kx1024 | 2099200 | 18057.6 ± 1.8% | 1750.1 ± 0.1% | 1067.8 ± 0.2% | 409.4 ± 0.2% | 892.7 ± 15.0% | 822.2 ± 1.8% | 10.318 | 16.911 | 44.110 | 20.229 | 21.963 |
| hex: http/html-16kx64 | 2097280 | 18951.4 ± 2.9% | 1725.9 ± 0.6% | 1071.8 ± 0.2% | 409.9 ± 0.2% | 890.7 ± 0.3% | 836.0 ± 15.8% | 10.981 | 17.682 | 46.233 | 21.276 | 22.668 |
| hex: http/html-1m | 524290 | 29241.9 ± 0.2% | 1701.8 ± 0.1% | 1061.9 ± 0.2% | 390.5 ± 0.2% | 867.6 ± 1.1% | 794.0 ± 7.9% | 17.183 | 27.537 | 74.888 | 33.704 | 36.830 |
| hex: http/json-1kx1024 | 2099200 | 17824.1 ± 0.5% | 1749.3 ± 11.1% | 1067.5 ± 1.2% | 595.1 ± 0.7% | 893.1 ± 1.4% | 830.3 ± 1.6% | 10.189 | 16.697 | 29.952 | 19.959 | 21.467 |
| hex: http/json-16kx64 | 2097280 | 18596.3 ± 0.5% | 1729.5 ± 0.1% | 1068.0 ± 1.3% | 586.0 ± 3.2% | 859.5 ± 0.9% | 843.8 ± 2.5% | 10.752 | 17.413 | 31.734 | 21.637 | 22.039 |
| hex: http/json-1m | 524290 | 29396.6 ± 15.1% | 1698.4 ± 1.0% | 1062.8 ± 0.4% | 627.5 ± 1.8% | 882.8 ± 0.5% | 791.3 ± 11.3% | 17.309 | 27.661 | 46.847 | 33.301 | 37.149 |
| hex: http/js-1kx1024 | 2099200 | 18023.5 ± 1.7% | 1744.2 ± 1.1% | 1065.4 ± 0.1% | 405.6 ± 0.2% | 892.1 ± 0.7% | 820.4 ± 1.4% | 10.333 | 16.917 | 44.441 | 20.203 | 21.969 |
| hex: http/js-16kx64 | 2097280 | 18938.3 ± 2.8% | 1728.0 ± 0.6% | 1071.2 ± 13.5% | 407.0 ± 0.2% | 889.8 ± 0.3% | 837.2 ± 1.6% | 10.959 | 17.679 | 46.531 | 21.285 | 22.620 |
| hex: http/js-1m | 524290 | 29248.1 ± 0.2% | 1700.0 ± 1.0% | 1061.2 ± 0.3% | 410.0 ± 0.5% | 854.2 ± 0.4% | 798.0 ± 2.2% | 17.204 | 27.562 | 71.332 | 34.239 | 36.653 |
| hex: http/css-1kx1024 | 2099200 | 17788.5 ± 4.5% | 1747.8 ± 0.2% | 1066.4 ± 0.1% | 454.4 ± 1.4% | 893.3 ± 1.1% | 819.7 ± 1.8% | 10.177 | 16.681 | 39.149 | 19.913 | 21.701 |
| hex: http/css-16kx64 | 2097280 | 18792.3 ± 0.3% | 1726.6 ± 0.5% | 1070.8 ± 1.1% | 460.7 ± 0.2% | 891.6 ± 0.3% | 842.3 ± 0.6% | 10.884 | 17.550 | 40.788 | 21.077 | 22.312 |
| hex: http/css-1m | 524290 | 29366.2 ± 5.9% | 1698.9 ± 0.2% | 1061.0 ± 0.9% | 433.7 ± 0.4% | 868.1 ± 0.5% | 796.0 ± 3.7% | 17.286 | 27.678 | 67.709 | 33.829 | 36.894 |
| hex: shuffled/dickens-1m | 524290 | 29307.8 ± 0.5% | 1698.0 ± 0.8% | 1060.2 ± 0.3% | 385.0 ± 0.7% | 880.3 ± 0.2% | 800.8 ± 1.4% | 17.260 | 27.643 | 76.120 | 33.294 | 36.598 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1388.3 ± 1.1% | 1108.2 ± 0.9% | 837.2 ± 0.8% | 367.5 ± 0.5% | 359.2 ± 2.6% | 390.2 ± 0.7% | 1.253 | 1.658 | 3.778 | 3.865 | 3.558 |
| qlog records, JSON text sequence | 1467503 | 1107.3 ± 1.0% | 844.8 ± 3.0% | 689.1 ± 3.9% | 326.0 ± 3.1% | 348.8 ± 9.1% | 250.2 ± 5.5% | 1.311 | 1.607 | 3.397 | 3.174 | 4.426 |
| messages: 11 string members | 1025025 | 1036.1 ± 0.5% | 831.4 ± 0.2% | 633.4 ± 0.7% | 329.8 ± 4.4% | 326.7 ± 4.8% | 324.1 ± 1.1% | 1.246 | 1.636 | 3.141 | 3.171 | 3.197 |
| messages: 50 nested objects | 1121600 | 1411.5 ± 20.5% | 1210.2 ± 0.7% | 1019.4 ± 2.7% | 441.0 ± 1.2% | 433.1 ± 0.7% | 395.0 ± 12.0% | 1.166 | 1.385 | 3.200 | 3.259 | 3.573 |
| messages: a tree of 341 objects | 612600 | 516.2 ± 2.0% | 587.9 ± 2.0% | 422.2 ± 3.1% | 240.6 ± 3.0% | 270.3 ± 5.1% | 144.7 ± 2.5% | 0.878 | 1.223 | 2.145 | 1.909 | 3.567 |
| string: silesia/dickens | 172528 | 10253.4 ± 0.9% | 2960.3 ± 1.4% | 2393.6 ± 3.9% | 272.1 ± 0.9% | 1143.5 ± 3.6% | 1028.2 ± 1.3% | 3.464 | 4.284 | 37.682 | 8.966 | 9.972 |
| string: silesia/nci | 1075110 | 8587.5 ± 0.4% | 3197.2 ± 0.4% | 2432.4 ± 0.2% | 791.9 ± 1.4% | 1214.8 ± 1.3% | 1014.3 ± 15.5% | 2.686 | 3.530 | 10.844 | 7.069 | 8.466 |
| string: silesia/reymont | 1075159 | 4557.0 ± 1.1% | 1507.0 ± 0.6% | 1599.2 ± 6.0% | 313.5 ± 0.8% | 1037.3 ± 0.2% | 923.9 ± 0.3% | 3.024 | 2.849 | 14.535 | 4.393 | 4.932 |
| string: silesia/samba | 97582 | 5221.7 ± 0.2% | 2003.7 ± 0.9% | 2776.7 ± 2.1% | 265.2 ± 0.6% | 994.0 ± 0.5% | 1005.3 ± 1.5% | 2.606 | 1.881 | 19.689 | 5.253 | 5.194 |
| string: silesia/webster | 1098490 | 5721.7 ± 5.2% | 1511.3 ± 0.4% | 1503.9 ± 1.1% | 290.6 ± 0.5% | 1009.9 ± 2.1% | 514.9 ± 1.0% | 3.786 | 3.805 | 19.688 | 5.665 | 11.112 |
| string: silesia/xml | 1090118 | 8317.6 ± 0.4% | 2373.6 ± 0.4% | 2015.3 ± 2.3% | 500.6 ± 0.8% | 1192.9 ± 1.8% | 808.7 ± 8.4% | 3.504 | 4.127 | 16.615 | 6.973 | 10.285 |
| string: canterbury/alice29.txt | 159425 | 9720.2 ± 2.4% | 2223.3 ± 1.3% | 2223.0 ± 0.1% | 261.2 ± 1.1% | 1075.5 ± 2.3% | 930.8 ± 0.9% | 4.372 | 4.373 | 37.217 | 9.038 | 10.443 |
| string: canterbury/asyoulik.txt | 132198 | 8348.9 ± 10.3% | 1644.4 ± 0.5% | 2237.4 ± 9.4% | 259.3 ± 0.8% | 967.7 ± 2.2% | 827.3 ± 0.6% | 5.077 | 3.732 | 32.202 | 8.628 | 10.091 |
| string: canterbury/lcet10.txt | 441884 | 9375.9 ± 0.9% | 2358.9 ± 1.4% | 2070.3 ± 0.7% | 306.5 ± 0.8% | 1102.5 ± 8.6% | 996.8 ± 0.9% | 3.975 | 4.529 | 30.593 | 8.505 | 9.406 |
| string: canterbury/plrabn12.txt | 503330 | 7006.2 ± 1.7% | 1733.4 ± 1.1% | 1757.1 ± 1.1% | 279.4 ± 0.9% | 1048.4 ± 1.6% | 896.0 ± 0.5% | 4.042 | 3.987 | 25.072 | 6.683 | 7.819 |
| string: canterbury-large/E.coli | 1048578 | 15975.0 ± 0.6% | 8845.5 ± 0.4% | 2593.5 ± 0.3% | 1488.7 ± 0.6% | 1491.3 ± 0.8% | 1072.2 ± 0.9% | 1.806 | 6.160 | 10.731 | 10.712 | 14.899 |
| string: canterbury-large/bible.txt | 1055886 | 8589.9 ± 0.6% | 3677.0 ± 0.5% | 2307.9 ± 0.9% | 331.2 ± 0.3% | 1308.4 ± 0.8% | 1162.5 ± 1.7% | 2.336 | 3.722 | 25.932 | 6.565 | 7.389 |
| string: canterbury-large/world192.txt | 1103121 | 5479.2 ± 2.2% | 1319.6 ± 0.5% | 1594.8 ± 24.6% | 287.8 ± 1.0% | 992.5 ± 1.1% | 839.2 ± 0.9% | 4.152 | 3.436 | 19.035 | 5.520 | 6.529 |
| string: http/html-1m | 1058582 | 8438.3 ± 0.8% | 3379.9 ± 1.0% | 2252.5 ± 1.1% | 339.4 ± 1.1% | 1283.4 ± 0.3% | 710.2 ± 1.1% | 2.497 | 3.746 | 24.860 | 6.575 | 11.881 |
| string: http/json-1m | 1190272 | 6622.4 ± 0.3% | 1150.5 ± 3.5% | 1353.6 ± 0.7% | 434.3 ± 2.8% | 769.1 ± 0.3% | 688.8 ± 0.4% | 5.756 | 4.892 | 15.250 | 8.611 | 9.614 |
| string: http/js-1m | 1144362 | 5540.3 ± 1.4% | 878.4 ± 0.8% | 1191.8 ± 0.4% | 265.4 ± 1.7% | 823.6 ± 0.7% | 664.4 ± 0.8% | 6.307 | 4.649 | 20.875 | 6.727 | 8.338 |
| string: http/css-1m | 1097820 | 7510.6 ± 1.0% | 1141.2 ± 0.6% | 1732.3 ± 1.2% | 396.6 ± 5.2% | 930.7 ± 0.4% | 811.9 ± 0.6% | 6.581 | 4.336 | 18.936 | 8.070 | 9.251 |
| string: dickens as Cyrillic and CJK | 1883069 | 4488.1 ± 0.5% | 2881.8 ± 1.0% | 421.1 ± 1.8% | 209.8 ± 0.7% | 373.2 ± 0.1% | 277.4 ± 1.1% | 1.557 | 10.658 | 21.393 | 12.025 | 16.182 |
| hex: silesia/dickens | 524290 | 28779.7 ± 0.7% | 1699.7 ± 0.1% | 1060.5 ± 0.2% | 386.1 ± 0.4% | 883.8 ± 1.0% | 799.8 ± 3.0% | 16.932 | 27.137 | 74.546 | 32.564 | 35.985 |
| hex: silesia/mozilla | 524290 | 29268.0 ± 0.8% | 1704.0 ± 0.2% | 1060.0 ± 0.5% | 326.2 ± 1.0% | 879.2 ± 10.6% | 799.3 ± 2.4% | 17.176 | 27.612 | 89.738 | 33.291 | 36.618 |
| hex: silesia/mr | 524290 | 29326.1 ± 0.3% | 1695.5 ± 0.1% | 1058.4 ± 0.3% | 489.1 ± 0.5% | 884.1 ± 0.2% | 794.7 ± 1.1% | 17.297 | 27.707 | 59.961 | 33.170 | 36.901 |
| hex: silesia/nci | 524290 | 30244.4 ± 0.5% | 1705.6 ± 0.1% | 1059.5 ± 14.9% | 653.8 ± 0.5% | 880.0 ± 0.3% | 795.3 ± 1.2% | 17.733 | 28.546 | 46.258 | 34.371 | 38.028 |
| hex: silesia/ooffice | 524290 | 29322.3 ± 10.5% | 1696.1 ± 0.8% | 1057.8 ± 0.5% | 267.5 ± 0.6% | 885.0 ± 0.1% | 799.6 ± 27.6% | 17.289 | 27.721 | 109.596 | 33.134 | 36.672 |
| hex: silesia/osdb | 524290 | 28807.1 ± 0.4% | 1702.5 ± 0.5% | 1061.5 ± 0.2% | 363.6 ± 1.3% | 878.8 ± 0.3% | 794.3 ± 0.9% | 16.921 | 27.138 | 79.233 | 32.780 | 36.269 |
| hex: silesia/reymont | 524290 | 29469.8 ± 0.6% | 1695.4 ± 0.8% | 1060.8 ± 0.2% | 408.4 ± 8.6% | 881.5 ± 4.9% | 796.0 ± 4.2% | 17.383 | 27.780 | 72.160 | 33.432 | 37.021 |
| hex: silesia/samba | 524290 | 30256.0 ± 0.5% | 1703.7 ± 5.2% | 1061.5 ± 4.0% | 288.4 ± 7.9% | 879.1 ± 0.7% | 811.6 ± 3.9% | 17.759 | 28.502 | 104.915 | 34.417 | 37.278 |
| hex: silesia/sao | 524290 | 29235.5 ± 0.8% | 1695.5 ± 1.0% | 1060.8 ± 0.1% | 217.7 ± 0.8% | 881.7 ± 0.5% | 802.4 ± 4.2% | 17.243 | 27.560 | 134.304 | 33.158 | 36.434 |
| hex: silesia/webster | 524290 | 31187.7 ± 0.4% | 1702.8 ± 0.6% | 1059.7 ± 0.3% | 351.4 ± 0.6% | 877.6 ± 1.3% | 798.2 ± 1.3% | 18.316 | 29.431 | 88.760 | 35.537 | 39.072 |
| hex: silesia/x-ray | 524290 | 29242.6 ± 0.1% | 1697.4 ± 0.1% | 1061.9 ± 0.3% | 341.7 ± 1.5% | 881.4 ± 0.3% | 796.3 ± 3.9% | 17.227 | 27.537 | 85.585 | 33.177 | 36.721 |
| hex: silesia/xml | 524290 | 30310.7 ± 0.4% | 1704.6 ± 0.4% | 1060.8 ± 0.3% | 582.0 ± 8.3% | 878.8 ± 0.2% | 796.3 ± 0.8% | 17.782 | 28.575 | 52.084 | 34.492 | 38.067 |
| hex: canterbury/alice29.txt | 304180 | 28808.7 ± 0.2% | 1702.0 ± 10.3% | 1073.4 ± 3.3% | 389.6 ± 0.2% | 891.0 ± 0.2% | 827.8 ± 1.1% | 16.926 | 26.838 | 73.935 | 32.334 | 34.803 |
| hex: canterbury/asyoulik.txt | 250360 | 29164.5 ± 0.3% | 1724.9 ± 0.4% | 1083.8 ± 0.2% | 381.0 ± 0.5% | 888.7 ± 0.8% | 831.3 ± 3.1% | 16.908 | 26.908 | 76.540 | 32.818 | 35.082 |
| hex: canterbury/cp.html | 49208 | 28583.8 ± 1.7% | 1720.8 ± 1.0% | 1075.5 ± 0.2% | 384.7 ± 1.4% | 891.9 ± 0.2% | 844.0 ± 1.7% | 16.611 | 26.578 | 74.309 | 32.050 | 33.866 |
| hex: canterbury/fields.c | 22302 | 29386.1 ± 0.3% | 1723.8 ± 0.2% | 1077.5 ± 0.1% | 597.9 ± 1.2% | 892.5 ± 1.4% | 848.9 ± 2.7% | 17.048 | 27.272 | 49.146 | 32.927 | 34.616 |
| hex: canterbury/grammar.lsp | 7444 | 27546.2 ± 0.4% | 1773.3 ± 1.0% | 1091.9 ± 0.1% | 677.0 ± 1.4% | 901.2 ± 0.1% | 854.7 ± 2.2% | 15.534 | 25.227 | 40.687 | 30.565 | 32.228 |
| hex: canterbury/kennedy.xls | 524290 | 29442.0 ± 0.2% | 1691.5 ± 0.4% | 1059.5 ± 0.2% | 641.2 ± 1.5% | 868.5 ± 0.3% | 797.6 ± 0.8% | 17.406 | 27.788 | 45.916 | 33.898 | 36.914 |
| hex: canterbury/lcet10.txt | 524290 | 30258.0 ± 9.4% | 1705.2 ± 0.2% | 1061.5 ± 2.1% | 388.0 ± 0.2% | 880.8 ± 2.2% | 794.8 ± 1.2% | 17.744 | 28.505 | 77.981 | 34.355 | 38.071 |
| hex: canterbury/plrabn12.txt | 524290 | 29210.3 ± 0.2% | 1692.0 ± 0.2% | 1059.5 ± 0.8% | 373.8 ± 4.4% | 868.1 ± 1.3% | 797.2 ± 4.0% | 17.264 | 27.569 | 78.153 | 33.650 | 36.642 |
| hex: canterbury/ptt5 | 524290 | 29282.9 ± 0.2% | 1698.2 ± 0.5% | 1059.1 ± 0.2% | 492.0 ± 0.4% | 882.7 ± 0.4% | 793.9 ± 3.5% | 17.244 | 27.649 | 59.513 | 33.176 | 36.886 |
| hex: canterbury/sum | 76482 | 28829.6 ± 0.5% | 1723.4 ± 0.6% | 1075.6 ± 4.6% | 453.3 ± 6.3% | 891.8 ± 7.2% | 843.3 ± 10.8% | 16.728 | 26.803 | 63.596 | 32.328 | 34.186 |
| hex: canterbury/xargs.1 | 8456 | 27732.1 ± 0.1% | 1769.6 ± 6.7% | 1089.4 ± 0.2% | 685.0 ± 0.4% | 899.7 ± 0.1% | 855.6 ± 2.1% | 15.671 | 25.457 | 40.487 | 30.825 | 32.411 |
| hex: canterbury-large/E.coli | 524290 | 28761.4 ± 0.3% | 1707.3 ± 1.7% | 1061.6 ± 0.3% | 658.5 ± 1.3% | 879.9 ± 14.6% | 793.7 ± 1.6% | 16.846 | 27.093 | 43.678 | 32.689 | 36.239 |
| hex: canterbury-large/bible.txt | 524290 | 30315.3 ± 0.9% | 1704.4 ± 0.2% | 1061.1 ± 1.0% | 402.4 ± 0.2% | 881.8 ± 0.2% | 795.1 ± 3.9% | 17.786 | 28.571 | 75.345 | 34.380 | 38.126 |
| hex: canterbury-large/world192.txt | 524290 | 29449.9 ± 0.4% | 1702.7 ± 0.2% | 1061.5 ± 0.5% | 379.9 ± 0.3% | 883.3 ± 0.3% | 798.9 ± 4.0% | 17.296 | 27.744 | 77.522 | 33.343 | 36.865 |
| hex: http/html-1kx1024 | 2099200 | 18141.3 ± 0.6% | 1750.1 ± 0.1% | 1067.8 ± 0.2% | 409.4 ± 0.2% | 892.7 ± 15.0% | 822.2 ± 1.8% | 10.366 | 16.989 | 44.315 | 20.323 | 22.064 |
| hex: http/html-16kx64 | 2097280 | 19046.4 ± 0.3% | 1725.9 ± 0.6% | 1071.8 ± 0.2% | 409.9 ± 0.2% | 890.7 ± 0.3% | 836.0 ± 15.8% | 11.036 | 17.771 | 46.465 | 21.383 | 22.782 |
| hex: http/html-1m | 524290 | 29263.3 ± 6.2% | 1701.8 ± 0.1% | 1061.9 ± 0.2% | 390.5 ± 0.2% | 867.6 ± 1.1% | 794.0 ± 7.9% | 17.196 | 27.557 | 74.943 | 33.729 | 36.856 |
| hex: http/json-1kx1024 | 2099200 | 17928.1 ± 0.5% | 1749.3 ± 11.1% | 1067.5 ± 1.2% | 595.1 ± 0.7% | 893.1 ± 1.4% | 830.3 ± 1.6% | 10.249 | 16.794 | 30.127 | 20.075 | 21.593 |
| hex: http/json-16kx64 | 2097280 | 18625.4 ± 1.4% | 1729.5 ± 0.1% | 1068.0 ± 1.3% | 586.0 ± 3.2% | 859.5 ± 0.9% | 843.8 ± 2.5% | 10.769 | 17.440 | 31.784 | 21.671 | 22.074 |
| hex: http/json-1m | 524290 | 29441.0 ± 0.3% | 1698.4 ± 1.0% | 1062.8 ± 0.4% | 627.5 ± 1.8% | 882.8 ± 0.5% | 791.3 ± 11.3% | 17.335 | 27.702 | 46.918 | 33.351 | 37.205 |
| hex: http/js-1kx1024 | 2099200 | 18147.1 ± 8.9% | 1744.2 ± 1.1% | 1065.4 ± 0.1% | 405.6 ± 0.2% | 892.1 ± 0.7% | 820.4 ± 1.4% | 10.404 | 17.033 | 44.745 | 20.342 | 22.119 |
| hex: http/js-16kx64 | 2097280 | 19084.2 ± 1.5% | 1728.0 ± 0.6% | 1071.2 ± 13.5% | 407.0 ± 0.2% | 889.8 ± 0.3% | 837.2 ± 1.6% | 11.044 | 17.815 | 46.889 | 21.449 | 22.794 |
| hex: http/js-1m | 524290 | 29301.5 ± 0.3% | 1700.0 ± 1.0% | 1061.2 ± 0.3% | 410.0 ± 0.5% | 854.2 ± 0.4% | 798.0 ± 2.2% | 17.236 | 27.612 | 71.462 | 34.302 | 36.720 |
| hex: http/css-1kx1024 | 2099200 | 17945.2 ± 1.4% | 1747.8 ± 0.2% | 1066.4 ± 0.1% | 454.4 ± 1.4% | 893.3 ± 1.1% | 819.7 ± 1.8% | 10.267 | 16.828 | 39.494 | 20.088 | 21.892 |
| hex: http/css-16kx64 | 2097280 | 18853.5 ± 1.3% | 1726.6 ± 0.5% | 1070.8 ± 1.1% | 460.7 ± 0.2% | 891.6 ± 0.3% | 842.3 ± 0.6% | 10.920 | 17.607 | 40.921 | 21.146 | 22.385 |
| hex: http/css-1m | 524290 | 29418.0 ± 0.3% | 1698.9 ± 0.2% | 1061.0 ± 0.9% | 433.7 ± 0.4% | 868.1 ± 0.5% | 796.0 ± 3.7% | 17.316 | 27.727 | 67.828 | 33.888 | 36.959 |
| hex: shuffled/dickens-1m | 524290 | 29354.8 ± 0.4% | 1698.0 ± 0.8% | 1060.2 ± 0.3% | 385.0 ± 0.7% | 880.3 ± 0.2% | 800.8 ± 1.4% | 17.288 | 27.688 | 76.242 | 33.348 | 36.656 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 890.2 ± 2.2% | 1120.9 ± 0.6% | 852.0 ± 2.0% | 322.1 ± 0.8% | 528.9 ± 0.6% | 293.6 ± 2.3% | 0.794 | 1.045 | 2.764 | 1.683 | 3.032 |
| qlog records, JSON text sequence | 1467503 | 653.4 ± 1.1% | 936.4 ± 0.3% | 824.5 ± 2.9% | 268.5 ± 1.2% | 597.1 ± 1.4% | 253.6 ± 1.9% | 0.698 | 0.792 | 2.433 | 1.094 | 2.576 |
| messages: 11 string members | 1025025 | 743.5 ± 0.6% | 1195.8 ± 0.4% | 578.7 ± 0.2% | 278.5 ± 0.9% | 419.3 ± 4.9% | 243.6 ± 1.0% | 0.622 | 1.285 | 2.670 | 1.773 | 3.053 |
| messages: 50 nested objects | 1121600 | 949.5 ± 0.3% | 1025.8 ± 1.1% | 964.7 ± 0.2% | 346.2 ± 0.6% | 645.2 ± 1.3% | 328.7 ± 1.4% | 0.926 | 0.984 | 2.743 | 1.472 | 2.889 |
| messages: a tree of 341 objects | 612600 | 375.6 ± 9.7% | 634.5 ± 0.1% | 470.0 ± 0.5% | 154.9 ± 0.4% | 488.4 ± 1.7% | 153.0 ± 2.1% | 0.592 | 0.799 | 2.425 | 0.769 | 2.455 |
| string: silesia/dickens | 172528 | 5861.6 ± 5.4% | 2894.6 ± 5.6% | 2359.9 ± 2.3% | 263.6 ± 2.3% | 2204.4 ± 5.0% | 501.5 ± 2.8% | 2.025 | 2.484 | 22.236 | 2.659 | 11.689 |
| string: silesia/nci | 1075110 | 5024.3 ± 0.3% | 3205.6 ± 0.6% | 2224.6 ± 0.2% | 565.5 ± 1.3% | 2370.6 ± 0.4% | 527.2 ± 1.6% | 1.567 | 2.259 | 8.885 | 2.119 | 9.530 |
| string: silesia/reymont | 1075159 | 3173.2 ± 5.5% | 2558.0 ± 0.2% | 1548.9 ± 0.5% | 283.6 ± 0.6% | 1606.4 ± 1.1% | 459.4 ± 1.0% | 1.240 | 2.049 | 11.190 | 1.975 | 6.907 |
| string: silesia/samba | 97582 | 2785.4 ± 0.1% | 2803.0 ± 0.3% | 2178.4 ± 1.8% | 274.0 ± 0.4% | 1345.0 ± 1.1% | 354.7 ± 1.5% | 0.994 | 1.279 | 10.165 | 2.071 | 7.852 |
| string: silesia/webster | 1098490 | 3817.0 ± 1.2% | 1993.2 ± 0.1% | 1436.0 ± 0.5% | 256.9 ± 3.1% | 1596.7 ± 0.8% | 421.1 ± 1.2% | 1.915 | 2.658 | 14.856 | 2.390 | 9.064 |
| string: silesia/xml | 1090118 | 4691.4 ± 0.4% | 3559.3 ± 0.1% | 1849.5 ± 0.5% | 420.6 ± 4.8% | 2273.6 ± 0.3% | 504.4 ± 1.1% | 1.318 | 2.537 | 11.154 | 2.063 | 9.302 |
| string: canterbury/alice29.txt | 159425 | 5171.8 ± 2.1% | 2453.4 ± 0.4% | 2347.3 ± 0.9% | 248.6 ± 0.1% | 2016.0 ± 0.6% | 454.2 ± 1.1% | 2.108 | 2.203 | 20.802 | 2.565 | 11.387 |
| string: canterbury/asyoulik.txt | 132198 | 3444.8 ± 0.4% | 1970.0 ± 1.5% | 2102.2 ± 8.9% | 250.5 ± 0.2% | 1639.0 ± 2.1% | 398.0 ± 1.1% | 1.749 | 1.639 | 13.751 | 2.102 | 8.656 |
| string: canterbury/lcet10.txt | 441884 | 5917.7 ± 0.7% | 2724.6 ± 0.7% | 1808.3 ± 0.6% | 289.5 ± 2.6% | 2071.9 ± 0.8% | 480.1 ± 0.7% | 2.172 | 3.273 | 20.441 | 2.856 | 12.326 |
| string: canterbury/plrabn12.txt | 503330 | 3995.0 ± 0.2% | 2352.7 ± 1.0% | 1536.0 ± 0.3% | 267.6 ± 0.3% | 2022.1 ± 1.0% | 437.8 ± 1.2% | 1.698 | 2.601 | 14.927 | 1.976 | 9.125 |
| string: canterbury-large/E.coli | 1048578 | 24047.8 ± 0.2% | 7674.7 ± 0.4% | 2753.9 ± 0.8% | 986.9 ± 8.0% | 5213.2 ± 7.8% | 908.5 ± 22.1% | 3.133 | 8.732 | 24.366 | 4.613 | 26.470 |
| string: canterbury-large/bible.txt | 1055886 | 8314.3 ± 17.6% | 4598.3 ± 2.7% | 2073.9 ± 0.9% | 306.2 ± 1.7% | 3018.8 ± 1.2% | 584.8 ± 0.9% | 1.808 | 4.009 | 27.150 | 2.754 | 14.216 |
| string: canterbury-large/world192.txt | 1103121 | 3581.9 ± 2.3% | 1882.0 ± 0.6% | 1458.0 ± 0.2% | 268.7 ± 0.6% | 1624.9 ± 1.1% | 420.4 ± 1.9% | 1.903 | 2.457 | 13.331 | 2.204 | 8.520 |
| string: http/html-1m | 1058582 | 7665.0 ± 7.0% | 3922.2 ± 1.3% | 2020.1 ± 0.8% | 351.9 ± 0.3% | 2758.7 ± 1.2% | 565.4 ± 1.3% | 1.954 | 3.794 | 21.783 | 2.779 | 13.556 |
| string: http/json-1m | 1190272 | 2849.3 ± 0.2% | 1057.5 ± 0.2% | 1683.4 ± 5.9% | 383.8 ± 9.3% | 841.7 ± 6.5% | 360.2 ± 2.0% | 2.694 | 1.693 | 7.425 | 3.385 | 7.911 |
| string: http/js-1m | 1144362 | 2513.4 ± 2.6% | 1394.6 ± 3.1% | 1129.0 ± 2.8% | 263.3 ± 2.2% | 1095.5 ± 2.9% | 334.9 ± 3.6% | 1.802 | 2.226 | 9.544 | 2.294 | 7.506 |
| string: http/css-1m | 1097820 | 2746.2 ± 4.5% | 2179.0 ± 3.9% | 1639.2 ± 3.5% | 369.8 ± 2.9% | 1445.4 ± 3.5% | 403.9 ± 2.6% | 1.260 | 1.675 | 7.426 | 1.900 | 6.799 |
| string: dickens as Cyrillic and CJK | 1883069 | 4713.0 ± 0.9% | 3242.4 ± 1.2% | 613.5 ± 0.3% | 283.3 ± 0.8% | 442.5 ± 3.8% | 128.8 ± 0.6% | 1.454 | 7.682 | 16.637 | 10.651 | 36.602 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 910.5 ± 0.6% | 1010.9 ± 0.5% | 929.3 ± 1.0% | 195.1 ± 0.8% | 370.3 ± 0.2% | 185.6 ± 2.5% | 0.901 | 0.980 | 4.666 | 2.459 | 4.907 |
| hex: silesia/dickens | 524290 | 24196.5 ± 1.4% | 10167.0 ± 0.7% | 3048.5 ± 0.2% | 399.1 ± 1.2% | 5225.5 ± 2.5% | 948.8 ± 1.8% | 2.380 | 7.937 | 60.623 | 4.630 | 25.502 |
| hex: silesia/mozilla | 524290 | 24309.7 ± 0.2% | 10163.8 ± 4.2% | 2966.2 ± 0.2% | 343.5 ± 2.0% | 5222.4 ± 0.3% | 955.2 ± 3.1% | 2.392 | 8.196 | 70.764 | 4.655 | 25.449 |
| hex: silesia/mr | 524290 | 24288.8 ± 0.4% | 10162.0 ± 0.6% | 2969.2 ± 0.2% | 519.0 ± 0.9% | 5223.8 ± 0.6% | 948.7 ± 11.9% | 2.390 | 8.180 | 46.796 | 4.650 | 25.602 |
| hex: silesia/nci | 524290 | 24283.6 ± 3.7% | 10165.4 ± 4.5% | 3058.9 ± 5.5% | 660.1 ± 0.9% | 5213.3 ± 0.4% | 947.7 ± 1.3% | 2.389 | 7.939 | 36.787 | 4.658 | 25.625 |
| hex: silesia/ooffice | 524290 | 24298.7 ± 0.2% | 10165.8 ± 0.2% | 2987.1 ± 0.4% | 282.2 ± 2.7% | 5221.9 ± 0.6% | 937.0 ± 1.9% | 2.390 | 8.135 | 86.114 | 4.653 | 25.932 |
| hex: silesia/osdb | 524290 | 24288.0 ± 0.2% | 10166.3 ± 0.2% | 2994.1 ± 6.1% | 387.6 ± 3.1% | 5224.2 ± 1.4% | 941.0 ± 2.9% | 2.389 | 8.112 | 62.667 | 4.649 | 25.811 |
| hex: silesia/reymont | 524290 | 24315.5 ± 0.4% | 10170.9 ± 0.3% | 3027.0 ± 0.8% | 426.9 ± 5.9% | 5223.5 ± 0.6% | 955.2 ± 3.4% | 2.391 | 8.033 | 56.958 | 4.655 | 25.455 |
| hex: silesia/samba | 524290 | 24299.2 ± 0.0% | 10166.2 ± 0.3% | 2998.3 ± 0.3% | 300.3 ± 2.5% | 5225.2 ± 0.2% | 947.9 ± 2.9% | 2.390 | 8.104 | 80.914 | 4.650 | 25.636 |
| hex: silesia/sao | 524290 | 24300.1 ± 0.7% | 10162.5 ± 0.2% | 3003.9 ± 0.1% | 225.2 ± 2.8% | 5217.6 ± 1.1% | 942.4 ± 1.7% | 2.391 | 8.090 | 107.919 | 4.657 | 25.786 |
| hex: silesia/webster | 524290 | 24284.0 ± 0.2% | 10166.3 ± 7.5% | 3023.9 ± 0.4% | 382.6 ± 3.3% | 5221.9 ± 0.3% | 947.5 ± 1.5% | 2.389 | 8.031 | 63.470 | 4.650 | 25.629 |
| hex: silesia/x-ray | 524290 | 24295.4 ± 0.1% | 10160.4 ± 0.1% | 2974.0 ± 0.1% | 362.2 ± 2.8% | 5222.3 ± 1.5% | 935.1 ± 2.1% | 2.391 | 8.169 | 67.070 | 4.652 | 25.982 |
| hex: silesia/xml | 524290 | 24297.5 ± 0.2% | 10166.2 ± 0.1% | 3018.4 ± 0.3% | 642.9 ± 1.5% | 5221.6 ± 0.3% | 953.5 ± 2.4% | 2.390 | 8.050 | 37.794 | 4.653 | 25.482 |
| hex: canterbury/alice29.txt | 304180 | 24213.6 ± 0.4% | 11023.1 ± 0.2% | 3001.4 ± 0.2% | 402.7 ± 3.4% | 5216.1 ± 0.4% | 979.4 ± 14.4% | 2.197 | 8.067 | 60.124 | 4.642 | 24.722 |
| hex: canterbury/asyoulik.txt | 250360 | 24189.5 ± 0.2% | 10476.2 ± 0.2% | 2977.9 ± 0.6% | 395.3 ± 3.1% | 5220.0 ± 7.9% | 961.0 ± 5.6% | 2.309 | 8.123 | 61.186 | 4.634 | 25.172 |
| hex: canterbury/cp.html | 49208 | 23772.9 ± 0.3% | 11258.4 ± 0.6% | 3077.8 ± 0.2% | 433.8 ± 3.5% | 5211.0 ± 0.8% | 943.9 ± 2.8% | 2.112 | 7.724 | 54.806 | 4.562 | 25.186 |
| hex: canterbury/fields.c | 22302 | 23548.6 ± 1.2% | 12132.8 ± 0.4% | 3132.1 ± 0.2% | 513.2 ± 0.9% | 5193.8 ± 0.4% | 929.2 ± 2.9% | 1.941 | 7.519 | 45.884 | 4.534 | 25.344 |
| hex: canterbury/grammar.lsp | 7444 | 21383.5 ± 0.7% | 11787.3 ± 0.5% | 3096.7 ± 10.1% | 666.3 ± 7.5% | 5119.6 ± 0.2% | 889.2 ± 4.0% | 1.814 | 6.905 | 32.091 | 4.177 | 24.047 |
| hex: canterbury/kennedy.xls | 524290 | 24285.3 ± 0.2% | 10302.1 ± 0.3% | 3069.9 ± 2.5% | 677.8 ± 0.1% | 5222.6 ± 0.4% | 926.4 ± 16.6% | 2.357 | 7.911 | 35.832 | 4.650 | 26.216 |
| hex: canterbury/lcet10.txt | 524290 | 24286.2 ± 3.5% | 10297.4 ± 2.1% | 3058.6 ± 1.2% | 401.6 ± 3.8% | 5222.7 ± 1.0% | 905.6 ± 4.7% | 2.358 | 7.940 | 60.478 | 4.650 | 26.817 |
| hex: canterbury/plrabn12.txt | 524290 | 24302.3 ± 0.2% | 10294.9 ± 1.3% | 3046.9 ± 0.2% | 389.0 ± 3.5% | 5223.4 ± 1.3% | 917.0 ± 2.5% | 2.361 | 7.976 | 62.479 | 4.653 | 26.502 |
| hex: canterbury/ptt5 | 524290 | 24297.3 ± 0.2% | 10288.8 ± 0.2% | 2949.7 ± 0.3% | 519.8 ± 3.8% | 5227.0 ± 0.2% | 901.5 ± 3.7% | 2.362 | 8.237 | 46.743 | 4.648 | 26.953 |
| hex: canterbury/sum | 76482 | 23824.6 ± 0.3% | 10740.4 ± 0.2% | 3068.2 ± 0.8% | 491.2 ± 5.5% | 5213.1 ± 0.4% | 938.6 ± 3.5% | 2.218 | 7.765 | 48.505 | 4.570 | 25.384 |
| hex: canterbury/xargs.1 | 8456 | 21692.9 ± 0.2% | 11851.2 ± 0.5% | 3037.6 ± 0.2% | 664.5 ± 1.7% | 5122.6 ± 0.6% | 921.4 ± 3.6% | 1.830 | 7.141 | 32.643 | 4.235 | 23.543 |
| hex: canterbury-large/E.coli | 524290 | 24278.1 ± 6.4% | 10282.0 ± 1.5% | 2992.3 ± 0.4% | 693.7 ± 0.6% | 5211.2 ± 0.5% | 945.0 ± 8.1% | 2.361 | 8.114 | 34.999 | 4.659 | 25.692 |
| hex: canterbury-large/bible.txt | 524290 | 24277.3 ± 0.2% | 10126.9 ± 0.8% | 2999.2 ± 4.3% | 418.2 ± 3.2% | 5225.5 ± 0.2% | 940.4 ± 0.8% | 2.397 | 8.095 | 58.053 | 4.646 | 25.816 |
| hex: canterbury-large/world192.txt | 524290 | 24273.8 ± 3.7% | 10084.8 ± 4.1% | 3033.6 ± 4.8% | 398.6 ± 3.9% | 5216.5 ± 0.5% | 941.3 ± 1.7% | 2.407 | 8.002 | 60.897 | 4.653 | 25.787 |
| hex: http/html-1kx1024 | 2099200 | 13306.6 ± 0.3% | 8780.1 ± 0.2% | 2776.9 ± 0.3% | 438.0 ± 3.0% | 4629.6 ± 0.6% | 780.0 ± 6.3% | 1.516 | 4.792 | 30.380 | 2.874 | 17.059 |
| hex: http/html-16kx64 | 2097280 | 21560.3 ± 3.5% | 11302.2 ± 0.2% | 2910.6 ± 0.1% | 433.6 ± 3.4% | 5195.2 ± 0.3% | 904.4 ± 2.3% | 1.908 | 7.407 | 49.718 | 4.150 | 23.840 |
| hex: http/html-1m | 524290 | 24200.1 ± 4.9% | 10251.0 ± 0.4% | 2952.1 ± 1.4% | 431.0 ± 3.2% | 5219.8 ± 0.6% | 950.6 ± 7.3% | 2.361 | 8.198 | 56.149 | 4.636 | 25.457 |
| hex: http/json-1kx1024 | 2099200 | 13350.3 ± 0.2% | 8783.3 ± 0.2% | 2781.0 ± 0.1% | 623.6 ± 0.8% | 4632.1 ± 1.1% | 791.8 ± 2.3% | 1.520 | 4.800 | 21.410 | 2.882 | 16.860 |
| hex: http/json-16kx64 | 2097280 | 21628.3 ± 0.2% | 11296.0 ± 11.6% | 2901.9 ± 7.0% | 639.5 ± 0.4% | 5188.6 ± 1.0% | 888.8 ± 0.7% | 1.915 | 7.453 | 33.822 | 4.168 | 24.334 |
| hex: http/json-1m | 524290 | 24300.9 ± 0.3% | 10179.7 ± 0.7% | 3034.4 ± 0.3% | 675.8 ± 0.2% | 5228.5 ± 0.2% | 946.3 ± 1.1% | 2.387 | 8.008 | 35.958 | 4.648 | 25.679 |
| hex: http/js-1kx1024 | 2099200 | 13330.2 ± 0.3% | 8766.7 ± 0.2% | 2780.8 ± 0.2% | 430.0 ± 3.1% | 4627.9 ± 1.5% | 789.3 ± 2.1% | 1.521 | 4.794 | 30.998 | 2.880 | 16.888 |
| hex: http/js-16kx64 | 2097280 | 21601.8 ± 1.6% | 11292.3 ± 0.4% | 2909.8 ± 0.6% | 425.4 ± 4.9% | 5192.7 ± 0.5% | 899.4 ± 2.9% | 1.913 | 7.424 | 50.780 | 4.160 | 24.018 |
| hex: http/js-1m | 524290 | 24298.7 ± 0.7% | 10424.9 ± 0.3% | 3068.7 ± 0.4% | 442.3 ± 2.7% | 5216.3 ± 0.4% | 933.2 ± 2.2% | 2.331 | 7.918 | 54.933 | 4.658 | 26.039 |
| hex: http/css-1kx1024 | 2099200 | 13268.1 ± 0.2% | 8786.5 ± 0.4% | 2769.3 ± 0.7% | 485.2 ± 2.6% | 4634.0 ± 1.8% | 780.4 ± 2.5% | 1.510 | 4.791 | 27.343 | 2.863 | 17.002 |
| hex: http/css-16kx64 | 2097280 | 21618.3 ± 1.5% | 11301.0 ± 0.5% | 2901.8 ± 0.1% | 496.4 ± 2.4% | 5186.3 ± 0.2% | 883.1 ± 2.2% | 1.913 | 7.450 | 43.546 | 4.168 | 24.481 |
| hex: http/css-1m | 524290 | 24221.5 ± 0.6% | 10069.4 ± 0.3% | 3038.6 ± 0.3% | 474.1 ± 1.5% | 5224.5 ± 0.3% | 934.3 ± 9.0% | 2.405 | 7.971 | 51.095 | 4.636 | 25.925 |
| hex: shuffled/dickens-1m | 524290 | 24296.9 ± 0.0% | 10253.1 ± 0.4% | 3005.0 ± 0.8% | 410.1 ± 4.0% | 5226.3 ± 0.4% | 939.0 ± 2.1% | 2.370 | 8.085 | 59.241 | 4.649 | 25.874 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1000.4 ± 0.7% | 1120.9 ± 0.6% | 852.0 ± 2.0% | 322.1 ± 0.8% | 528.9 ± 0.6% | 293.6 ± 2.3% | 0.893 | 1.174 | 3.106 | 1.891 | 3.407 |
| qlog records, JSON text sequence | 1467503 | 746.8 ± 0.8% | 936.4 ± 0.3% | 824.5 ± 2.9% | 268.5 ± 1.2% | 597.1 ± 1.4% | 253.6 ± 1.9% | 0.798 | 0.906 | 2.781 | 1.251 | 2.945 |
| messages: 11 string members | 1025025 | 797.8 ± 0.5% | 1195.8 ± 0.4% | 578.7 ± 0.2% | 278.5 ± 0.9% | 419.3 ± 4.9% | 243.6 ± 1.0% | 0.667 | 1.379 | 2.865 | 1.903 | 3.276 |
| messages: 50 nested objects | 1121600 | 1067.1 ± 0.4% | 1025.8 ± 1.1% | 964.7 ± 0.2% | 346.2 ± 0.6% | 645.2 ± 1.3% | 328.7 ± 1.4% | 1.040 | 1.106 | 3.082 | 1.654 | 3.247 |
| messages: a tree of 341 objects | 612600 | 486.2 ± 1.0% | 634.5 ± 0.1% | 470.0 ± 0.5% | 154.9 ± 0.4% | 488.4 ± 1.7% | 153.0 ± 2.1% | 0.766 | 1.034 | 3.139 | 0.996 | 3.179 |
| string: silesia/dickens | 172528 | 5869.9 ± 0.7% | 2894.6 ± 5.6% | 2359.9 ± 2.3% | 263.6 ± 2.3% | 2204.4 ± 5.0% | 501.5 ± 2.8% | 2.028 | 2.487 | 22.267 | 2.663 | 11.705 |
| string: silesia/nci | 1075110 | 5026.7 ± 0.3% | 3205.6 ± 0.6% | 2224.6 ± 0.2% | 565.5 ± 1.3% | 2370.6 ± 0.4% | 527.2 ± 1.6% | 1.568 | 2.260 | 8.889 | 2.120 | 9.535 |
| string: silesia/reymont | 1075159 | 3191.2 ± 4.7% | 2558.0 ± 0.2% | 1548.9 ± 0.5% | 283.6 ± 0.6% | 1606.4 ± 1.1% | 459.4 ± 1.0% | 1.248 | 2.060 | 11.253 | 1.986 | 6.946 |
| string: silesia/samba | 97582 | 2775.5 ± 0.4% | 2803.0 ± 0.3% | 2178.4 ± 1.8% | 274.0 ± 0.4% | 1345.0 ± 1.1% | 354.7 ± 1.5% | 0.990 | 1.274 | 10.129 | 2.063 | 7.824 |
| string: silesia/webster | 1098490 | 3841.8 ± 1.0% | 1993.2 ± 0.1% | 1436.0 ± 0.5% | 256.9 ± 3.1% | 1596.7 ± 0.8% | 421.1 ± 1.2% | 1.927 | 2.675 | 14.953 | 2.406 | 9.123 |
| string: silesia/xml | 1090118 | 4702.7 ± 0.5% | 3559.3 ± 0.1% | 1849.5 ± 0.5% | 420.6 ± 4.8% | 2273.6 ± 0.3% | 504.4 ± 1.1% | 1.321 | 2.543 | 11.181 | 2.068 | 9.324 |
| string: canterbury/alice29.txt | 159425 | 5221.5 ± 0.7% | 2453.4 ± 0.4% | 2347.3 ± 0.9% | 248.6 ± 0.1% | 2016.0 ± 0.6% | 454.2 ± 1.1% | 2.128 | 2.224 | 21.002 | 2.590 | 11.496 |
| string: canterbury/asyoulik.txt | 132198 | 3473.8 ± 0.3% | 1970.0 ± 1.5% | 2102.2 ± 8.9% | 250.5 ± 0.2% | 1639.0 ± 2.1% | 398.0 ± 1.1% | 1.763 | 1.652 | 13.867 | 2.119 | 8.729 |
| string: canterbury/lcet10.txt | 441884 | 5919.6 ± 0.7% | 2724.6 ± 0.7% | 1808.3 ± 0.6% | 289.5 ± 2.6% | 2071.9 ± 0.8% | 480.1 ± 0.7% | 2.173 | 3.274 | 20.447 | 2.857 | 12.330 |
| string: canterbury/plrabn12.txt | 503330 | 3997.7 ± 2.5% | 2352.7 ± 1.0% | 1536.0 ± 0.3% | 267.6 ± 0.3% | 2022.1 ± 1.0% | 437.8 ± 1.2% | 1.699 | 2.603 | 14.937 | 1.977 | 9.131 |
| string: canterbury-large/E.coli | 1048578 | 24078.1 ± 0.2% | 7674.7 ± 0.4% | 2753.9 ± 0.8% | 986.9 ± 8.0% | 5213.2 ± 7.8% | 908.5 ± 22.1% | 3.137 | 8.743 | 24.397 | 4.619 | 26.503 |
| string: canterbury-large/bible.txt | 1055886 | 8477.8 ± 1.6% | 4598.3 ± 2.7% | 2073.9 ± 0.9% | 306.2 ± 1.7% | 3018.8 ± 1.2% | 584.8 ± 0.9% | 1.844 | 4.088 | 27.684 | 2.808 | 14.496 |
| string: canterbury-large/world192.txt | 1103121 | 3603.0 ± 1.1% | 1882.0 ± 0.6% | 1458.0 ± 0.2% | 268.7 ± 0.6% | 1624.9 ± 1.1% | 420.4 ± 1.9% | 1.915 | 2.471 | 13.409 | 2.217 | 8.570 |
| string: http/html-1m | 1058582 | 7969.4 ± 1.1% | 3922.2 ± 1.3% | 2020.1 ± 0.8% | 351.9 ± 0.3% | 2758.7 ± 1.2% | 565.4 ± 1.3% | 2.032 | 3.945 | 22.648 | 2.889 | 14.094 |
| string: http/json-1m | 1190272 | 2852.6 ± 0.2% | 1057.5 ± 0.2% | 1683.4 ± 5.9% | 383.8 ± 9.3% | 841.7 ± 6.5% | 360.2 ± 2.0% | 2.698 | 1.695 | 7.433 | 3.389 | 7.921 |
| string: http/js-1m | 1144362 | 2508.7 ± 9.1% | 1394.6 ± 3.1% | 1129.0 ± 2.8% | 263.3 ± 2.2% | 1095.5 ± 2.9% | 334.9 ± 3.6% | 1.799 | 2.222 | 9.527 | 2.290 | 7.492 |
| string: http/css-1m | 1097820 | 2752.5 ± 4.5% | 2179.0 ± 3.9% | 1639.2 ± 3.5% | 369.8 ± 2.9% | 1445.4 ± 3.5% | 403.9 ± 2.6% | 1.263 | 1.679 | 7.443 | 1.904 | 6.814 |
| string: dickens as Cyrillic and CJK | 1883069 | 4729.9 ± 7.2% | 3242.4 ± 1.2% | 613.5 ± 0.3% | 283.3 ± 0.8% | 442.5 ± 3.8% | 128.8 ± 0.6% | 1.459 | 7.709 | 16.696 | 10.689 | 36.732 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 911.2 ± 0.6% | 1010.9 ± 0.5% | 929.3 ± 1.0% | 195.1 ± 0.8% | 370.3 ± 0.2% | 185.6 ± 2.5% | 0.901 | 0.981 | 4.670 | 2.461 | 4.911 |
| hex: silesia/dickens | 524290 | 24281.2 ± 0.5% | 10167.0 ± 0.7% | 3048.5 ± 0.2% | 399.1 ± 1.2% | 5225.5 ± 2.5% | 948.8 ± 1.8% | 2.388 | 7.965 | 60.835 | 4.647 | 25.592 |
| hex: silesia/mozilla | 524290 | 24287.7 ± 1.8% | 10163.8 ± 4.2% | 2966.2 ± 0.2% | 343.5 ± 2.0% | 5222.4 ± 0.3% | 955.2 ± 3.1% | 2.390 | 8.188 | 70.700 | 4.651 | 25.426 |
| hex: silesia/mr | 524290 | 24274.9 ± 0.2% | 10162.0 ± 0.6% | 2969.2 ± 0.2% | 519.0 ± 0.9% | 5223.8 ± 0.6% | 948.7 ± 11.9% | 2.389 | 8.176 | 46.769 | 4.647 | 25.587 |
| hex: silesia/nci | 524290 | 24279.9 ± 3.3% | 10165.4 ± 4.5% | 3058.9 ± 5.5% | 660.1 ± 0.9% | 5213.3 ± 0.4% | 947.7 ± 1.3% | 2.388 | 7.937 | 36.781 | 4.657 | 25.621 |
| hex: silesia/ooffice | 524290 | 24290.3 ± 0.3% | 10165.8 ± 0.2% | 2987.1 ± 0.4% | 282.2 ± 2.7% | 5221.9 ± 0.6% | 937.0 ± 1.9% | 2.389 | 8.132 | 86.085 | 4.652 | 25.923 |
| hex: silesia/osdb | 524290 | 24265.8 ± 13.8% | 10166.3 ± 0.2% | 2994.1 ± 6.1% | 387.6 ± 3.1% | 5224.2 ± 1.4% | 941.0 ± 2.9% | 2.387 | 8.105 | 62.610 | 4.645 | 25.787 |
| hex: silesia/reymont | 524290 | 24274.0 ± 0.8% | 10170.9 ± 0.3% | 3027.0 ± 0.8% | 426.9 ± 5.9% | 5223.5 ± 0.6% | 955.2 ± 3.4% | 2.387 | 8.019 | 56.861 | 4.647 | 25.411 |
| hex: silesia/samba | 524290 | 24264.1 ± 0.4% | 10166.2 ± 0.3% | 2998.3 ± 0.3% | 300.3 ± 2.5% | 5225.2 ± 0.2% | 947.9 ± 2.9% | 2.387 | 8.093 | 80.797 | 4.644 | 25.599 |
| hex: silesia/sao | 524290 | 24278.1 ± 9.5% | 10162.5 ± 0.2% | 3003.9 ± 0.1% | 225.2 ± 2.8% | 5217.6 ± 1.1% | 942.4 ± 1.7% | 2.389 | 8.082 | 107.822 | 4.653 | 25.763 |
| hex: silesia/webster | 524290 | 24247.5 ± 0.6% | 10166.3 ± 7.5% | 3023.9 ± 0.4% | 382.6 ± 3.3% | 5221.9 ± 0.3% | 947.5 ± 1.5% | 2.385 | 8.019 | 63.374 | 4.643 | 25.590 |
| hex: silesia/x-ray | 524290 | 24290.6 ± 0.1% | 10160.4 ± 0.1% | 2974.0 ± 0.1% | 362.2 ± 2.8% | 5222.3 ± 1.5% | 935.1 ± 2.1% | 2.391 | 8.168 | 67.057 | 4.651 | 25.977 |
| hex: silesia/xml | 524290 | 24272.0 ± 0.4% | 10166.2 ± 0.1% | 3018.4 ± 0.3% | 642.9 ± 1.5% | 5221.6 ± 0.3% | 953.5 ± 2.4% | 2.388 | 8.041 | 37.754 | 4.648 | 25.456 |
| hex: canterbury/alice29.txt | 304180 | 24216.3 ± 0.1% | 11023.1 ± 0.2% | 3001.4 ± 0.2% | 402.7 ± 3.4% | 5216.1 ± 0.4% | 979.4 ± 14.4% | 2.197 | 8.068 | 60.131 | 4.643 | 24.724 |
| hex: canterbury/asyoulik.txt | 250360 | 24190.2 ± 0.1% | 10476.2 ± 0.2% | 2977.9 ± 0.6% | 395.3 ± 3.1% | 5220.0 ± 7.9% | 961.0 ± 5.6% | 2.309 | 8.123 | 61.188 | 4.634 | 25.173 |
| hex: canterbury/cp.html | 49208 | 23749.6 ± 0.4% | 11258.4 ± 0.6% | 3077.8 ± 0.2% | 433.8 ± 3.5% | 5211.0 ± 0.8% | 943.9 ± 2.8% | 2.109 | 7.716 | 54.752 | 4.558 | 25.161 |
| hex: canterbury/fields.c | 22302 | 23549.8 ± 9.8% | 12132.8 ± 0.4% | 3132.1 ± 0.2% | 513.2 ± 0.9% | 5193.8 ± 0.4% | 929.2 ± 2.9% | 1.941 | 7.519 | 45.886 | 4.534 | 25.345 |
| hex: canterbury/grammar.lsp | 7444 | 21427.4 ± 0.2% | 11787.3 ± 0.5% | 3096.7 ± 10.1% | 666.3 ± 7.5% | 5119.6 ± 0.2% | 889.2 ± 4.0% | 1.818 | 6.919 | 32.157 | 4.185 | 24.096 |
| hex: canterbury/kennedy.xls | 524290 | 24275.5 ± 4.4% | 10302.1 ± 0.3% | 3069.9 ± 2.5% | 677.8 ± 0.1% | 5222.6 ± 0.4% | 926.4 ± 16.6% | 2.356 | 7.907 | 35.818 | 4.648 | 26.205 |
| hex: canterbury/lcet10.txt | 524290 | 24284.0 ± 3.6% | 10297.4 ± 2.1% | 3058.6 ± 1.2% | 401.6 ± 3.8% | 5222.7 ± 1.0% | 905.6 ± 4.7% | 2.358 | 7.939 | 60.472 | 4.650 | 26.815 |
| hex: canterbury/plrabn12.txt | 524290 | 24285.3 ± 0.2% | 10294.9 ± 1.3% | 3046.9 ± 0.2% | 389.0 ± 3.5% | 5223.4 ± 1.3% | 917.0 ± 2.5% | 2.359 | 7.970 | 62.435 | 4.649 | 26.483 |
| hex: canterbury/ptt5 | 524290 | 24290.7 ± 0.5% | 10288.8 ± 0.2% | 2949.7 ± 0.3% | 519.8 ± 3.8% | 5227.0 ± 0.2% | 901.5 ± 3.7% | 2.361 | 8.235 | 46.730 | 4.647 | 26.945 |
| hex: canterbury/sum | 76482 | 23841.9 ± 0.2% | 10740.4 ± 0.2% | 3068.2 ± 0.8% | 491.2 ± 5.5% | 5213.1 ± 0.4% | 938.6 ± 3.5% | 2.220 | 7.771 | 48.540 | 4.573 | 25.403 |
| hex: canterbury/xargs.1 | 8456 | 21731.3 ± 0.4% | 11851.2 ± 0.5% | 3037.6 ± 0.2% | 664.5 ± 1.7% | 5122.6 ± 0.6% | 921.4 ± 3.6% | 1.834 | 7.154 | 32.701 | 4.242 | 23.584 |
| hex: canterbury-large/E.coli | 524290 | 24297.6 ± 0.1% | 10282.0 ± 1.5% | 2992.3 ± 0.4% | 693.7 ± 0.6% | 5211.2 ± 0.5% | 945.0 ± 8.1% | 2.363 | 8.120 | 35.027 | 4.663 | 25.713 |
| hex: canterbury-large/bible.txt | 524290 | 24302.9 ± 0.1% | 10126.9 ± 0.8% | 2999.2 ± 4.3% | 418.2 ± 3.2% | 5225.5 ± 0.2% | 940.4 ± 0.8% | 2.400 | 8.103 | 58.115 | 4.651 | 25.843 |
| hex: canterbury-large/world192.txt | 524290 | 24259.5 ± 3.4% | 10084.8 ± 4.1% | 3033.6 ± 4.8% | 398.6 ± 3.9% | 5216.5 ± 0.5% | 941.3 ± 1.7% | 2.406 | 7.997 | 60.861 | 4.651 | 25.772 |
| hex: http/html-1kx1024 | 2099200 | 13274.6 ± 0.4% | 8780.1 ± 0.2% | 2776.9 ± 0.3% | 438.0 ± 3.0% | 4629.6 ± 0.6% | 780.0 ± 6.3% | 1.512 | 4.780 | 30.306 | 2.867 | 17.018 |
| hex: http/html-16kx64 | 2097280 | 21577.4 ± 0.1% | 11302.2 ± 0.2% | 2910.6 ± 0.1% | 433.6 ± 3.4% | 5195.2 ± 0.3% | 904.4 ± 2.3% | 1.909 | 7.413 | 49.758 | 4.153 | 23.859 |
| hex: http/html-1m | 524290 | 24301.8 ± 0.1% | 10251.0 ± 0.4% | 2952.1 ± 1.4% | 431.0 ± 3.2% | 5219.8 ± 0.6% | 950.6 ± 7.3% | 2.371 | 8.232 | 56.385 | 4.656 | 25.564 |
| hex: http/json-1kx1024 | 2099200 | 13306.5 ± 4.6% | 8783.3 ± 0.2% | 2781.0 ± 0.1% | 623.6 ± 0.8% | 4632.1 ± 1.1% | 791.8 ± 2.3% | 1.515 | 4.785 | 21.340 | 2.873 | 16.804 |
| hex: http/json-16kx64 | 2097280 | 21619.7 ± 0.5% | 11296.0 ± 11.6% | 2901.9 ± 7.0% | 639.5 ± 0.4% | 5188.6 ± 1.0% | 888.8 ± 0.7% | 1.914 | 7.450 | 33.809 | 4.167 | 24.324 |
| hex: http/json-1m | 524290 | 24292.4 ± 0.2% | 10179.7 ± 0.7% | 3034.4 ± 0.3% | 675.8 ± 0.2% | 5228.5 ± 0.2% | 946.3 ± 1.1% | 2.386 | 8.006 | 35.946 | 4.646 | 25.670 |
| hex: http/js-1kx1024 | 2099200 | 13269.0 ± 1.3% | 8766.7 ± 0.2% | 2780.8 ± 0.2% | 430.0 ± 3.1% | 4627.9 ± 1.5% | 789.3 ± 2.1% | 1.514 | 4.772 | 30.855 | 2.867 | 16.811 |
| hex: http/js-16kx64 | 2097280 | 21589.3 ± 3.7% | 11292.3 ± 0.4% | 2909.8 ± 0.6% | 425.4 ± 4.9% | 5192.7 ± 0.5% | 899.4 ± 2.9% | 1.912 | 7.420 | 50.751 | 4.158 | 24.004 |
| hex: http/js-1m | 524290 | 24295.6 ± 0.4% | 10424.9 ± 0.3% | 3068.7 ± 0.4% | 442.3 ± 2.7% | 5216.3 ± 0.4% | 933.2 ± 2.2% | 2.331 | 7.917 | 54.926 | 4.658 | 26.036 |
| hex: http/css-1kx1024 | 2099200 | 13208.9 ± 0.5% | 8786.5 ± 0.4% | 2769.3 ± 0.7% | 485.2 ± 2.6% | 4634.0 ± 1.8% | 780.4 ± 2.5% | 1.503 | 4.770 | 27.221 | 2.850 | 16.926 |
| hex: http/css-16kx64 | 2097280 | 21595.4 ± 0.6% | 11301.0 ± 0.5% | 2901.8 ± 0.1% | 496.4 ± 2.4% | 5186.3 ± 0.2% | 883.1 ± 2.2% | 1.911 | 7.442 | 43.500 | 4.164 | 24.455 |
| hex: http/css-1m | 524290 | 24302.6 ± 0.1% | 10069.4 ± 0.3% | 3038.6 ± 0.3% | 474.1 ± 1.5% | 5224.5 ± 0.3% | 934.3 ± 9.0% | 2.414 | 7.998 | 51.266 | 4.652 | 26.011 |
| hex: shuffled/dickens-1m | 524290 | 24302.4 ± 0.1% | 10253.1 ± 0.4% | 3005.0 ± 0.8% | 410.1 ± 4.0% | 5226.3 ± 0.4% | 939.0 ± 2.1% | 2.370 | 8.087 | 59.254 | 4.650 | 25.880 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1177.1 ± 0.6% | 1108.2 ± 0.9% | 837.2 ± 0.8% | 367.5 ± 0.5% | 359.2 ± 2.6% | 390.2 ± 0.7% | 1.062 | 1.406 | 3.204 | 3.277 | 3.016 |
| qlog records, JSON text sequence | 1467503 | 940.3 ± 0.9% | 844.8 ± 3.0% | 689.1 ± 3.9% | 326.0 ± 3.1% | 348.8 ± 9.1% | 250.2 ± 5.5% | 1.113 | 1.364 | 2.885 | 2.696 | 3.758 |
| messages: 11 string members | 1025025 | 1034.3 ± 1.1% | 831.4 ± 0.2% | 633.4 ± 0.7% | 329.8 ± 4.4% | 326.7 ± 4.8% | 324.1 ± 1.1% | 1.244 | 1.633 | 3.136 | 3.166 | 3.191 |
| messages: 50 nested objects | 1121600 | 1206.2 ± 17.8% | 1210.2 ± 0.7% | 1019.4 ± 2.7% | 441.0 ± 1.2% | 433.1 ± 0.7% | 395.0 ± 12.0% | 0.997 | 1.183 | 2.735 | 2.785 | 3.053 |
| messages: a tree of 341 objects | 612600 | 493.9 ± 4.6% | 587.9 ± 2.0% | 422.2 ± 3.1% | 240.6 ± 3.0% | 270.3 ± 5.1% | 144.7 ± 2.5% | 0.840 | 1.170 | 2.052 | 1.827 | 3.413 |
| string: silesia/dickens | 172528 | 10001.1 ± 1.7% | 2960.3 ± 1.4% | 2393.6 ± 3.9% | 272.1 ± 0.9% | 1143.5 ± 3.6% | 1028.2 ± 1.3% | 3.378 | 4.178 | 36.754 | 8.746 | 9.727 |
| string: silesia/nci | 1075110 | 8371.6 ± 1.8% | 3197.2 ± 0.4% | 2432.4 ± 0.2% | 791.9 ± 1.4% | 1214.8 ± 1.3% | 1014.3 ± 15.5% | 2.618 | 3.442 | 10.571 | 6.891 | 8.253 |
| string: silesia/reymont | 1075159 | 4331.9 ± 4.0% | 1507.0 ± 0.6% | 1599.2 ± 6.0% | 313.5 ± 0.8% | 1037.3 ± 0.2% | 923.9 ± 0.3% | 2.875 | 2.709 | 13.817 | 4.176 | 4.688 |
| string: silesia/samba | 97582 | 4437.2 ± 0.1% | 2003.7 ± 0.9% | 2776.7 ± 2.1% | 265.2 ± 0.6% | 994.0 ± 0.5% | 1005.3 ± 1.5% | 2.215 | 1.598 | 16.731 | 4.464 | 4.414 |
| string: silesia/webster | 1098490 | 5744.4 ± 0.9% | 1511.3 ± 0.4% | 1503.9 ± 1.1% | 290.6 ± 0.5% | 1009.9 ± 2.1% | 514.9 ± 1.0% | 3.801 | 3.820 | 19.766 | 5.688 | 11.156 |
| string: silesia/xml | 1090118 | 7965.6 ± 6.5% | 2373.6 ± 0.4% | 2015.3 ± 2.3% | 500.6 ± 0.8% | 1192.9 ± 1.8% | 808.7 ± 8.4% | 3.356 | 3.953 | 15.912 | 6.678 | 9.850 |
| string: canterbury/alice29.txt | 159425 | 9388.4 ± 2.8% | 2223.3 ± 1.3% | 2223.0 ± 0.1% | 261.2 ± 1.1% | 1075.5 ± 2.3% | 930.8 ± 0.9% | 4.223 | 4.223 | 35.947 | 8.729 | 10.086 |
| string: canterbury/asyoulik.txt | 132198 | 8091.5 ± 0.2% | 1644.4 ± 0.5% | 2237.4 ± 9.4% | 259.3 ± 0.8% | 967.7 ± 2.2% | 827.3 ± 0.6% | 4.920 | 3.617 | 31.209 | 8.362 | 9.780 |
| string: canterbury/lcet10.txt | 441884 | 9089.6 ± 1.1% | 2358.9 ± 1.4% | 2070.3 ± 0.7% | 306.5 ± 0.8% | 1102.5 ± 8.6% | 996.8 ± 0.9% | 3.853 | 4.390 | 29.659 | 8.245 | 9.119 |
| string: canterbury/plrabn12.txt | 503330 | 6827.5 ± 2.6% | 1733.4 ± 1.1% | 1757.1 ± 1.1% | 279.4 ± 0.9% | 1048.4 ± 1.6% | 896.0 ± 0.5% | 3.939 | 3.886 | 24.433 | 6.512 | 7.620 |
| string: canterbury-large/E.coli | 1048578 | 15969.5 ± 0.9% | 8845.5 ± 0.4% | 2593.5 ± 0.3% | 1488.7 ± 0.6% | 1491.3 ± 0.8% | 1072.2 ± 0.9% | 1.805 | 6.157 | 10.727 | 10.709 | 14.894 |
| string: canterbury-large/bible.txt | 1055886 | 7907.8 ± 6.6% | 3677.0 ± 0.5% | 2307.9 ± 0.9% | 331.2 ± 0.3% | 1308.4 ± 0.8% | 1162.5 ± 1.7% | 2.151 | 3.426 | 23.873 | 6.044 | 6.802 |
| string: canterbury-large/world192.txt | 1103121 | 5420.9 ± 1.5% | 1319.6 ± 0.5% | 1594.8 ± 24.6% | 287.8 ± 1.0% | 992.5 ± 1.1% | 839.2 ± 0.9% | 4.108 | 3.399 | 18.833 | 5.462 | 6.459 |
| string: http/html-1m | 1058582 | 8444.2 ± 1.0% | 3379.9 ± 1.0% | 2252.5 ± 1.1% | 339.4 ± 1.1% | 1283.4 ± 0.3% | 710.2 ± 1.1% | 2.498 | 3.749 | 24.877 | 6.579 | 11.890 |
| string: http/json-1m | 1190272 | 6444.2 ± 1.4% | 1150.5 ± 3.5% | 1353.6 ± 0.7% | 434.3 ± 2.8% | 769.1 ± 0.3% | 688.8 ± 0.4% | 5.601 | 4.761 | 14.840 | 8.379 | 9.356 |
| string: http/js-1m | 1144362 | 5378.8 ± 2.5% | 878.4 ± 0.8% | 1191.8 ± 0.4% | 265.4 ± 1.7% | 823.6 ± 0.7% | 664.4 ± 0.8% | 6.123 | 4.513 | 20.266 | 6.531 | 8.095 |
| string: http/css-1m | 1097820 | 7305.4 ± 1.2% | 1141.2 ± 0.6% | 1732.3 ± 1.2% | 396.6 ± 5.2% | 930.7 ± 0.4% | 811.9 ± 0.6% | 6.402 | 4.217 | 18.419 | 7.849 | 8.998 |
| string: dickens as Cyrillic and CJK | 1883069 | 4513.1 ± 1.7% | 2881.8 ± 1.0% | 421.1 ± 1.8% | 209.8 ± 0.7% | 373.2 ± 0.1% | 277.4 ± 1.1% | 1.566 | 10.717 | 21.512 | 12.092 | 16.272 |
| hex: silesia/dickens | 524290 | 28775.7 ± 0.4% | 1699.7 ± 0.1% | 1060.5 ± 0.2% | 386.1 ± 0.4% | 883.8 ± 1.0% | 799.8 ± 3.0% | 16.930 | 27.134 | 74.536 | 32.559 | 35.980 |
| hex: silesia/mozilla | 524290 | 29280.7 ± 0.5% | 1704.0 ± 0.2% | 1060.0 ± 0.5% | 326.2 ± 1.0% | 879.2 ± 10.6% | 799.3 ± 2.4% | 17.184 | 27.624 | 89.776 | 33.305 | 36.634 |
| hex: silesia/mr | 524290 | 29360.7 ± 0.1% | 1695.5 ± 0.1% | 1058.4 ± 0.3% | 489.1 ± 0.5% | 884.1 ± 0.2% | 794.7 ± 1.1% | 17.317 | 27.740 | 60.032 | 33.209 | 36.944 |
| hex: silesia/nci | 524290 | 30234.8 ± 0.1% | 1705.6 ± 0.1% | 1059.5 ± 14.9% | 653.8 ± 0.5% | 880.0 ± 0.3% | 795.3 ± 1.2% | 17.727 | 28.536 | 46.243 | 34.360 | 38.016 |
| hex: silesia/ooffice | 524290 | 29409.3 ± 0.6% | 1696.1 ± 0.8% | 1057.8 ± 0.5% | 267.5 ± 0.6% | 885.0 ± 0.1% | 799.6 ± 27.6% | 17.340 | 27.803 | 109.921 | 33.232 | 36.781 |
| hex: silesia/osdb | 524290 | 28831.9 ± 0.3% | 1702.5 ± 0.5% | 1061.5 ± 0.2% | 363.6 ± 1.3% | 878.8 ± 0.3% | 794.3 ± 0.9% | 16.936 | 27.161 | 79.301 | 32.809 | 36.301 |
| hex: silesia/reymont | 524290 | 29561.3 ± 0.1% | 1695.4 ± 0.8% | 1060.8 ± 0.2% | 408.4 ± 8.6% | 881.5 ± 4.9% | 796.0 ± 4.2% | 17.437 | 27.866 | 72.384 | 33.536 | 37.136 |
| hex: silesia/samba | 524290 | 30243.5 ± 0.1% | 1703.7 ± 5.2% | 1061.5 ± 4.0% | 288.4 ± 7.9% | 879.1 ± 0.7% | 811.6 ± 3.9% | 17.751 | 28.490 | 104.872 | 34.403 | 37.263 |
| hex: silesia/sao | 524290 | 29262.3 ± 0.2% | 1695.5 ± 1.0% | 1060.8 ± 0.1% | 217.7 ± 0.8% | 881.7 ± 0.5% | 802.4 ± 4.2% | 17.259 | 27.585 | 134.427 | 33.189 | 36.467 |
| hex: silesia/webster | 524290 | 31193.7 ± 0.6% | 1702.8 ± 0.6% | 1059.7 ± 0.3% | 351.4 ± 0.6% | 877.6 ± 1.3% | 798.2 ± 1.3% | 18.319 | 29.437 | 88.777 | 35.543 | 39.080 |
| hex: silesia/x-ray | 524290 | 29225.3 ± 0.6% | 1697.4 ± 0.1% | 1061.9 ± 0.3% | 341.7 ± 1.5% | 881.4 ± 0.3% | 796.3 ± 3.9% | 17.217 | 27.521 | 85.534 | 33.157 | 36.699 |
| hex: silesia/xml | 524290 | 30209.9 ± 1.3% | 1704.6 ± 0.4% | 1060.8 ± 0.3% | 582.0 ± 8.3% | 878.8 ± 0.2% | 796.3 ± 0.8% | 17.723 | 28.480 | 51.911 | 34.377 | 37.940 |
| hex: canterbury/alice29.txt | 304180 | 28812.4 ± 1.0% | 1702.0 ± 10.3% | 1073.4 ± 3.3% | 389.6 ± 0.2% | 891.0 ± 0.2% | 827.8 ± 1.1% | 16.928 | 26.841 | 73.945 | 32.338 | 34.807 |
| hex: canterbury/asyoulik.txt | 250360 | 29155.4 ± 0.3% | 1724.9 ± 0.4% | 1083.8 ± 0.2% | 381.0 ± 0.5% | 888.7 ± 0.8% | 831.3 ± 3.1% | 16.903 | 26.900 | 76.516 | 32.808 | 35.072 |
| hex: canterbury/cp.html | 49208 | 28698.0 ± 0.1% | 1720.8 ± 1.0% | 1075.5 ± 0.2% | 384.7 ± 1.4% | 891.9 ± 0.2% | 844.0 ± 1.7% | 16.677 | 26.684 | 74.606 | 32.178 | 34.001 |
| hex: canterbury/fields.c | 22302 | 29559.4 ± 0.1% | 1723.8 ± 0.2% | 1077.5 ± 0.1% | 597.9 ± 1.2% | 892.5 ± 1.4% | 848.9 ± 2.7% | 17.148 | 27.432 | 49.436 | 33.121 | 34.820 |
| hex: canterbury/grammar.lsp | 7444 | 27951.2 ± 1.1% | 1773.3 ± 1.0% | 1091.9 ± 0.1% | 677.0 ± 1.4% | 901.2 ± 0.1% | 854.7 ± 2.2% | 15.762 | 25.598 | 41.285 | 31.014 | 32.701 |
| hex: canterbury/kennedy.xls | 524290 | 29455.5 ± 0.1% | 1691.5 ± 0.4% | 1059.5 ± 0.2% | 641.2 ± 1.5% | 868.5 ± 0.3% | 797.6 ± 0.8% | 17.414 | 27.801 | 45.937 | 33.914 | 36.931 |
| hex: canterbury/lcet10.txt | 524290 | 30255.3 ± 1.0% | 1705.2 ± 0.2% | 1061.5 ± 2.1% | 388.0 ± 0.2% | 880.8 ± 2.2% | 794.8 ± 1.2% | 17.743 | 28.502 | 77.974 | 34.352 | 38.067 |
| hex: canterbury/plrabn12.txt | 524290 | 29213.5 ± 7.1% | 1692.0 ± 0.2% | 1059.5 ± 0.8% | 373.8 ± 4.4% | 868.1 ± 1.3% | 797.2 ± 4.0% | 17.266 | 27.572 | 78.161 | 33.653 | 36.646 |
| hex: canterbury/ptt5 | 524290 | 29279.6 ± 0.8% | 1698.2 ± 0.5% | 1059.1 ± 0.2% | 492.0 ± 0.4% | 882.7 ± 0.4% | 793.9 ± 3.5% | 17.242 | 27.646 | 59.506 | 33.172 | 36.882 |
| hex: canterbury/sum | 76482 | 28889.1 ± 0.1% | 1723.4 ± 0.6% | 1075.6 ± 4.6% | 453.3 ± 6.3% | 891.8 ± 7.2% | 843.3 ± 10.8% | 16.763 | 26.858 | 63.727 | 32.395 | 34.256 |
| hex: canterbury/xargs.1 | 8456 | 28110.5 ± 0.9% | 1769.6 ± 6.7% | 1089.4 ± 0.2% | 685.0 ± 0.4% | 899.7 ± 0.1% | 855.6 ± 2.1% | 15.885 | 25.804 | 41.040 | 31.245 | 32.854 |
| hex: canterbury-large/E.coli | 524290 | 28666.1 ± 0.9% | 1707.3 ± 1.7% | 1061.6 ± 0.3% | 658.5 ± 1.3% | 879.9 ± 14.6% | 793.7 ± 1.6% | 16.790 | 27.004 | 43.533 | 32.581 | 36.119 |
| hex: canterbury-large/bible.txt | 524290 | 30274.7 ± 7.0% | 1704.4 ± 0.2% | 1061.1 ± 1.0% | 402.4 ± 0.2% | 881.8 ± 0.2% | 795.1 ± 3.9% | 17.762 | 28.533 | 75.244 | 34.334 | 38.075 |
| hex: canterbury-large/world192.txt | 524290 | 29457.9 ± 0.3% | 1702.7 ± 0.2% | 1061.5 ± 0.5% | 379.9 ± 0.3% | 883.3 ± 0.3% | 798.9 ± 4.0% | 17.301 | 27.751 | 77.543 | 33.352 | 36.875 |
| hex: http/html-1kx1024 | 2099200 | 18477.4 ± 1.1% | 1750.1 ± 0.1% | 1067.8 ± 0.2% | 409.4 ± 0.2% | 892.7 ± 15.0% | 822.2 ± 1.8% | 10.558 | 17.304 | 45.136 | 20.699 | 22.473 |
| hex: http/html-16kx64 | 2097280 | 19102.2 ± 1.6% | 1725.9 ± 0.6% | 1071.8 ± 0.2% | 409.9 ± 0.2% | 890.7 ± 0.3% | 836.0 ± 15.8% | 11.068 | 17.823 | 46.601 | 21.446 | 22.849 |
| hex: http/html-1m | 524290 | 29274.6 ± 0.2% | 1701.8 ± 0.1% | 1061.9 ± 0.2% | 390.5 ± 0.2% | 867.6 ± 1.1% | 794.0 ± 7.9% | 17.202 | 27.568 | 74.972 | 33.742 | 36.871 |
| hex: http/json-1kx1024 | 2099200 | 18227.1 ± 0.2% | 1749.3 ± 11.1% | 1067.5 ± 1.2% | 595.1 ± 0.7% | 893.1 ± 1.4% | 830.3 ± 1.6% | 10.420 | 17.074 | 30.630 | 20.410 | 21.953 |
| hex: http/json-16kx64 | 2097280 | 18734.7 ± 8.1% | 1729.5 ± 0.1% | 1068.0 ± 1.3% | 586.0 ± 3.2% | 859.5 ± 0.9% | 843.8 ± 2.5% | 10.832 | 17.542 | 31.971 | 21.798 | 22.203 |
| hex: http/json-1m | 524290 | 29436.6 ± 0.2% | 1698.4 ± 1.0% | 1062.8 ± 0.4% | 627.5 ± 1.8% | 882.8 ± 0.5% | 791.3 ± 11.3% | 17.332 | 27.698 | 46.911 | 33.346 | 37.200 |
| hex: http/js-1kx1024 | 2099200 | 18442.9 ± 0.3% | 1744.2 ± 1.1% | 1065.4 ± 0.1% | 405.6 ± 0.2% | 892.1 ± 0.7% | 820.4 ± 1.4% | 10.574 | 17.311 | 45.475 | 20.673 | 22.480 |
| hex: http/js-16kx64 | 2097280 | 19159.5 ± 0.5% | 1728.0 ± 0.6% | 1071.2 ± 13.5% | 407.0 ± 0.2% | 889.8 ± 0.3% | 837.2 ± 1.6% | 11.088 | 17.885 | 47.075 | 21.533 | 22.884 |
| hex: http/js-1m | 524290 | 29318.0 ± 0.3% | 1700.0 ± 1.0% | 1061.2 ± 0.3% | 410.0 ± 0.5% | 854.2 ± 0.4% | 798.0 ± 2.2% | 17.246 | 27.628 | 71.502 | 34.321 | 36.741 |
| hex: http/css-1kx1024 | 2099200 | 18246.5 ± 0.6% | 1747.8 ± 0.2% | 1066.4 ± 0.1% | 454.4 ± 1.4% | 893.3 ± 1.1% | 819.7 ± 1.8% | 10.439 | 17.110 | 40.157 | 20.426 | 22.259 |
| hex: http/css-16kx64 | 2097280 | 18925.0 ± 0.4% | 1726.6 ± 0.5% | 1070.8 ± 1.1% | 460.7 ± 0.2% | 891.6 ± 0.3% | 842.3 ± 0.6% | 10.961 | 17.674 | 41.076 | 21.226 | 22.469 |
| hex: http/css-1m | 524290 | 29382.5 ± 1.1% | 1698.9 ± 0.2% | 1061.0 ± 0.9% | 433.7 ± 0.4% | 868.1 ± 0.5% | 796.0 ± 3.7% | 17.295 | 27.694 | 67.746 | 33.847 | 36.914 |
| hex: shuffled/dickens-1m | 524290 | 29290.3 ± 2.0% | 1698.0 ± 0.8% | 1060.2 ± 0.3% | 385.0 ± 0.7% | 880.3 ± 0.2% | 800.8 ± 1.4% | 17.250 | 27.627 | 76.075 | 33.275 | 36.576 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.923 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.728 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.827 of yyjson.
- messages: 11 string members, decoding: stdx runs at 0.667 of simdjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.782 of simdjson.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding: stdx runs at 0.897 of simdjson.
- messages: a tree of 341 objects, encoding: stdx runs at 0.817 of simdjson.
- messages: a tree of 341 objects, encoding with J11's loop unchecked: stdx runs at 0.878 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.794 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.698 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.792 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.622 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.926 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.592 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.799 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.769 of serde_json.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.901 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.893 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.798 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.906 of yyjson.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.667 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.766 of simdjson.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next_items: stdx runs at 0.901 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.840 of simdjson.
