# bench-json

| Field | Value |
|---|---|
| Commit | 413a510 |
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
| CLDR supplemental, 34 texts | 920675 | 1032.2 ± 1.2% | 0.509 | 1.049 | 1.095 | 1.097 | 0.454 | 1.094 | 1.097 | 0.432 | 0.863 | 0.968 | 0.109 |
| qlog records, JSON text sequence | 1467503 | 682.4 ± 1.6% | 0.955 | 1.052 | 1.026 | 1.050 | 0.530 | 1.059 | 1.058 | 0.513 | 0.956 | 1.089 | 0.158 |
| messages: 11 string members | 1025025 | 797.7 ± 2.9% | 0.658 | 1.029 | 1.050 | 1.049 | 0.564 | 1.057 | 1.054 | 0.568 | 0.935 | 1.001 | 0.140 |
| messages: 50 nested objects | 1121600 | 1037.0 ± 0.2% | 0.770 | 1.087 | 1.077 | 1.079 | 0.422 | 1.084 | 1.081 | 0.397 | 0.915 | 1.029 | 0.111 |
| messages: a tree of 341 objects | 612600 | 496.7 ± 0.4% | 0.841 | 1.073 | 1.050 | 1.024 | 0.299 | 1.036 | 1.025 | 0.261 | 0.760 | 0.984 | 0.131 |
| string: silesia/dickens | 172528 | 5891.4 ± 1.4% | 0.025 | 0.642 | 0.892 | 0.917 | 0.174 | 0.914 | 0.931 | 0.175 | 1.002 | 1.005 | 0.025 |
| string: silesia/nci | 1075110 | 5009.8 ± 1.6% | 0.030 | 0.654 | 0.908 | 0.922 | 0.244 | 0.940 | 0.923 | 0.245 | 1.004 | 1.005 | 0.030 |
| string: silesia/reymont | 1075159 | 3162.8 ± 1.3% | 0.047 | 0.612 | 0.832 | 0.824 | 0.316 | 0.834 | 0.835 | 0.317 | 1.000 | 1.008 | 0.047 |
| string: silesia/samba | 97582 | 2784.5 ± 0.5% | 0.047 | 0.919 | 1.043 | 1.054 | 0.089 | 0.892 | 1.054 | 0.089 | 0.996 | 0.998 | 0.047 |
| string: silesia/webster | 1098490 | 3810.1 ± 1.0% | 0.038 | 0.647 | 0.916 | 0.945 | 0.197 | 0.901 | 0.932 | 0.198 | 0.996 | 1.004 | 0.038 |
| string: silesia/xml | 1090118 | 4682.4 ± 0.9% | 0.032 | 0.794 | 0.987 | 1.008 | 0.253 | 0.965 | 1.012 | 0.253 | 1.002 | 1.008 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5174.5 ± 0.7% | 0.028 | 0.679 | 0.924 | 0.925 | 0.153 | 0.931 | 0.976 | 0.152 | 1.002 | 1.011 | 0.028 |
| string: canterbury/asyoulik.txt | 132198 | 3439.4 ± 0.9% | 0.041 | 0.802 | 1.110 | 1.141 | 0.191 | 1.078 | 1.154 | 0.192 | 1.001 | 1.009 | 0.041 |
| string: canterbury/lcet10.txt | 441884 | 5942.4 ± 2.1% | 0.025 | 0.557 | 0.894 | 0.917 | 0.168 | 0.914 | 0.921 | 0.168 | 1.005 | 1.008 | 0.025 |
| string: canterbury/plrabn12.txt | 503330 | 3966.4 ± 0.6% | 0.037 | 0.775 | 1.085 | 1.104 | 0.226 | 1.035 | 1.114 | 0.226 | 1.002 | 1.005 | 0.037 |
| string: canterbury-large/E.coli | 1048578 | 15214.0 ± 0.6% | 0.103 | 1.006 | 0.941 | 1.007 | 0.651 | 1.007 | 1.007 | 0.650 | 1.564 | 1.563 | 0.011 |
| string: canterbury-large/bible.txt | 1055886 | 8261.6 ± 3.3% | 0.019 | 0.547 | 0.718 | 0.691 | 0.331 | 0.736 | 0.714 | 0.332 | 1.011 | 1.019 | 0.019 |
| string: canterbury-large/world192.txt | 1103121 | 3587.3 ± 1.6% | 0.040 | 0.679 | 0.913 | 0.933 | 0.192 | 0.903 | 0.928 | 0.191 | 1.003 | 1.007 | 0.040 |
| string: http/html-1m | 1058582 | 7873.5 ± 1.4% | 0.020 | 0.551 | 0.723 | 0.730 | 0.301 | 0.709 | 0.732 | 0.300 | 0.997 | 1.006 | 0.020 |
| string: http/json-1m | 1190272 | 2833.0 ± 0.5% | 0.048 | 0.376 | 0.439 | 0.446 | 0.119 | 0.452 | 0.446 | 0.119 | 1.006 | 1.010 | 0.048 |
| string: http/js-1m | 1144362 | 2502.3 ± 1.0% | 0.054 | 0.687 | 0.832 | 0.861 | 0.169 | 0.811 | 0.861 | 0.169 | 1.009 | 1.010 | 0.054 |
| string: http/css-1m | 1097820 | 2734.2 ± 1.0% | 0.051 | 0.738 | 0.956 | 0.990 | 0.256 | 0.936 | 0.991 | 0.257 | 1.005 | 1.006 | 0.052 |
| string: dickens as Cyrillic and CJK | 1883069 | 4703.3 ± 0.6% | 0.024 | 0.062 | 0.462 | 0.462 | 0.186 | 0.458 | 0.463 | 0.186 | 1.004 | 1.005 | 0.024 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 904.8 ± 1.0% | 0.123 | 0.999 | 1.003 | 1.005 | 0.118 | 0.779 | 1.003 | 0.118 | 1.003 | 1.002 | 0.123 |
| hex: silesia/dickens | 524290 | 34697.5 ± 0.3% | 0.047 | 1.003 | 0.605 | 0.999 | 0.393 | 1.002 | 1.002 | 0.392 | 0.700 | 0.700 | 0.005 |
| hex: silesia/mozilla | 524290 | 34676.3 ± 0.6% | 0.047 | 1.001 | 0.625 | 1.002 | 0.397 | 1.002 | 1.002 | 0.397 | 0.700 | 0.700 | 0.005 |
| hex: silesia/mr | 524290 | 29369.4 ± 0.5% | 0.056 | 1.003 | 0.689 | 1.004 | 0.445 | 1.003 | 1.004 | 0.444 | 0.827 | 0.826 | 0.005 |
| hex: silesia/nci | 524290 | 41024.9 ± 0.4% | 0.040 | 1.000 | 0.527 | 0.998 | 0.347 | 1.003 | 1.002 | 0.348 | 0.592 | 0.592 | 0.004 |
| hex: silesia/ooffice | 524290 | 38405.9 ± 1.1% | 0.043 | 1.002 | 0.546 | 1.003 | 0.364 | 1.006 | 1.004 | 0.364 | 0.632 | 0.632 | 0.004 |
| hex: silesia/osdb | 524290 | 33016.7 ± 3.0% | 0.050 | 1.001 | 0.624 | 1.001 | 0.410 | 1.002 | 1.002 | 0.409 | 0.736 | 0.736 | 0.005 |
| hex: silesia/reymont | 524290 | 40252.0 ± 0.4% | 0.041 | 0.999 | 0.556 | 1.001 | 0.354 | 1.004 | 0.998 | 0.354 | 0.603 | 0.603 | 0.004 |
| hex: silesia/samba | 524290 | 25184.3 ± 0.3% | 0.064 | 1.003 | 0.776 | 1.004 | 0.498 | 1.004 | 1.003 | 0.498 | 0.964 | 0.964 | 0.006 |
| hex: silesia/sao | 524290 | 40868.1 ± 1.8% | 0.040 | 0.996 | 0.543 | 0.995 | 0.348 | 0.990 | 0.997 | 0.346 | 0.594 | 0.594 | 0.004 |
| hex: silesia/webster | 524290 | 42131.2 ± 0.4% | 0.039 | 0.997 | 0.517 | 1.000 | 0.338 | 1.000 | 1.000 | 0.338 | 0.577 | 0.575 | 0.004 |
| hex: silesia/x-ray | 524290 | 41822.1 ± 1.0% | 0.039 | 1.005 | 0.524 | 1.005 | 0.341 | 1.004 | 1.005 | 0.341 | 0.581 | 0.580 | 0.004 |
| hex: silesia/xml | 524290 | 40399.1 ± 13.6% | 0.041 | 1.004 | 0.532 | 1.006 | 0.351 | 1.007 | 1.006 | 0.352 | 0.600 | 0.601 | 0.004 |
| hex: canterbury/alice29.txt | 304180 | 41372.5 ± 0.2% | 0.040 | 1.003 | 0.515 | 1.003 | 0.344 | 1.003 | 1.005 | 0.344 | 0.585 | 0.585 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 41448.8 ± 0.3% | 0.040 | 1.000 | 0.529 | 1.001 | 0.344 | 1.002 | 1.001 | 0.344 | 0.583 | 0.583 | 0.004 |
| hex: canterbury/cp.html | 49208 | 33877.3 ± 0.2% | 0.048 | 1.006 | 0.643 | 1.005 | 0.395 | 1.005 | 1.007 | 0.397 | 0.701 | 0.702 | 0.005 |
| hex: canterbury/fields.c | 22302 | 43924.2 ± 0.6% | 0.038 | 0.994 | 0.482 | 1.004 | 0.338 | 1.002 | 1.003 | 0.344 | 0.536 | 0.536 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 35130.7 ± 0.5% | 0.047 | 1.063 | 0.553 | 1.060 | 0.392 | 1.068 | 1.058 | 0.413 | 0.607 | 0.607 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 33091.3 ± 9.7% | 0.049 | 1.001 | 0.642 | 1.003 | 0.393 | 1.003 | 1.003 | 0.393 | 0.734 | 0.734 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 41484.5 ± 0.5% | 0.040 | 0.999 | 0.541 | 1.004 | 0.344 | 1.003 | 1.005 | 0.344 | 0.586 | 0.585 | 0.004 |
| hex: canterbury/plrabn12.txt | 524290 | 31778.0 ± 0.9% | 0.051 | 1.006 | 0.626 | 1.006 | 0.420 | 1.005 | 1.007 | 0.420 | 0.764 | 0.764 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 34086.3 ± 0.4% | 0.048 | 0.998 | 0.606 | 1.000 | 0.397 | 1.003 | 1.001 | 0.397 | 0.711 | 0.712 | 0.005 |
| hex: canterbury/sum | 76482 | 40440.4 ± 0.2% | 0.041 | 0.994 | 0.533 | 1.000 | 0.346 | 1.004 | 1.002 | 0.349 | 0.589 | 0.590 | 0.004 |
| hex: canterbury/xargs.1 | 8456 | 38108.5 ± 6.5% | 0.044 | 1.021 | 0.519 | 1.015 | 0.374 | 1.022 | 1.015 | 0.388 | 0.570 | 0.571 | 0.004 |
| hex: canterbury-large/E.coli | 524290 | 40476.2 ± 1.3% | 0.041 | 1.005 | 0.552 | 1.002 | 0.353 | 1.004 | 1.005 | 0.352 | 0.600 | 0.600 | 0.004 |
| hex: canterbury-large/bible.txt | 524290 | 28772.4 ± 0.4% | 0.057 | 1.001 | 0.693 | 1.003 | 0.453 | 1.002 | 1.001 | 0.453 | 0.845 | 0.843 | 0.006 |
| hex: canterbury-large/world192.txt | 524290 | 40021.4 ± 1.9% | 0.041 | 1.005 | 0.536 | 1.006 | 0.355 | 1.004 | 1.007 | 0.355 | 0.607 | 0.607 | 0.004 |
| hex: http/html-1kx1024 | 2099200 | 14145.4 ± 0.9% | 0.114 | 1.035 | 0.865 | 1.033 | 0.604 | 1.042 | 1.037 | 0.674 | 0.938 | 0.935 | 0.011 |
| hex: http/html-16kx64 | 2097280 | 24805.8 ± 0.4% | 0.066 | 1.002 | 0.772 | 1.002 | 0.544 | 1.002 | 1.002 | 0.552 | 0.869 | 0.867 | 0.007 |
| hex: http/html-1m | 524290 | 41445.2 ± 1.1% | 0.040 | 1.010 | 0.513 | 1.012 | 0.343 | 1.013 | 1.011 | 0.343 | 0.586 | 0.585 | 0.004 |
| hex: http/json-1kx1024 | 2099200 | 14118.2 ± 0.6% | 0.114 | 1.032 | 0.868 | 1.038 | 0.585 | 1.043 | 1.038 | 0.669 | 0.939 | 0.938 | 0.011 |
| hex: http/json-16kx64 | 2097280 | 25495.4 ± 0.6% | 0.065 | 1.004 | 0.750 | 1.003 | 0.529 | 1.004 | 1.006 | 0.533 | 0.850 | 0.850 | 0.006 |
| hex: http/json-1m | 524290 | 29431.5 ± 0.9% | 0.055 | 1.001 | 0.710 | 1.004 | 0.450 | 1.003 | 1.003 | 0.450 | 0.825 | 0.825 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 14068.9 ± 1.9% | 0.115 | 1.038 | 0.874 | 1.045 | 0.620 | 1.051 | 1.046 | 0.690 | 0.945 | 0.943 | 0.011 |
| hex: http/js-16kx64 | 2097280 | 24609.2 ± 0.4% | 0.067 | 1.003 | 0.777 | 1.003 | 0.547 | 1.004 | 1.003 | 0.552 | 0.876 | 0.876 | 0.007 |
| hex: http/js-1m | 524290 | 40384.5 ± 1.0% | 0.041 | 1.004 | 0.557 | 1.002 | 0.353 | 1.006 | 1.004 | 0.353 | 0.600 | 0.602 | 0.004 |
| hex: http/css-1kx1024 | 2099200 | 13971.4 ± 1.8% | 0.116 | 1.036 | 0.879 | 1.050 | 0.625 | 1.056 | 1.049 | 0.696 | 0.949 | 0.945 | 0.011 |
| hex: http/css-16kx64 | 2097280 | 24394.9 ± 0.4% | 0.067 | 1.006 | 0.787 | 1.003 | 0.554 | 1.006 | 1.005 | 0.559 | 0.888 | 0.887 | 0.007 |
| hex: http/css-1m | 524290 | 32012.3 ± 0.3% | 0.051 | 1.000 | 0.646 | 0.999 | 0.418 | 1.004 | 1.003 | 0.419 | 0.758 | 0.757 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 36704.4 ± 0.4% | 0.045 | 1.001 | 0.571 | 1.003 | 0.379 | 1.005 | 1.004 | 0.378 | 0.662 | 0.660 | 0.004 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1378.3 ± 0.4% | 0.427 | 0.962 | 0.966 | 0.997 | 0.997 | 0.267 | 0.997 | 0.466 | 0.856 | 0.093 | 1.011 |
| qlog records, JSON text sequence | 1467503 | 1052.2 ± 1.9% | 0.744 | 0.963 | 1.014 | 1.012 | 1.012 | 0.301 | 1.017 | 0.505 | 0.884 | 0.131 | 1.053 |
| messages: 11 string members | 1025025 | 1036.9 ± 2.0% | 0.521 | 0.985 | 0.990 | 1.001 | 0.988 | 0.371 | 0.990 | 0.631 | 0.991 | 0.114 | 0.996 |
| messages: 50 nested objects | 1121600 | 1401.2 ± 0.7% | 0.596 | 0.968 | 0.981 | 0.963 | 0.972 | 0.252 | 0.976 | 0.427 | 0.851 | 0.095 | 1.006 |
| messages: a tree of 341 objects | 612600 | 483.1 ± 9.2% | 0.935 | 1.008 | 1.025 | 1.036 | 1.030 | 0.238 | 1.034 | 0.382 | 1.022 | 0.183 | 1.080 |
| string: silesia/dickens | 172528 | 9863.7 ± 1.1% | 0.017 | 0.515 | 0.394 | 0.503 | 0.525 | 0.109 | 0.527 | 0.996 | 1.010 | 0.017 | 1.023 |
| string: silesia/nci | 1075110 | 8364.2 ± 1.3% | 0.020 | 0.527 | 0.397 | 0.516 | 0.528 | 0.171 | 0.527 | 0.998 | 1.001 | 0.020 | 1.031 |
| string: silesia/reymont | 1075159 | 4434.7 ± 4.9% | 0.038 | 0.576 | 0.440 | 0.566 | 0.580 | 0.234 | 0.583 | 1.002 | 1.011 | 0.038 | 1.035 |
| string: silesia/samba | 97582 | 4422.7 ± 0.7% | 0.048 | 0.906 | 0.773 | 0.903 | 0.913 | 0.122 | 0.911 | 1.000 | 1.002 | 0.048 | 1.183 |
| string: silesia/webster | 1098490 | 5697.7 ± 1.0% | 0.029 | 0.569 | 0.438 | 0.562 | 0.567 | 0.135 | 0.571 | 0.992 | 1.006 | 0.029 | 1.016 |
| string: silesia/xml | 1090118 | 7879.7 ± 1.1% | 0.022 | 0.570 | 0.485 | 0.559 | 0.570 | 0.194 | 0.573 | 0.995 | 1.007 | 0.022 | 1.054 |
| string: canterbury/alice29.txt | 159425 | 9049.8 ± 2.4% | 0.018 | 0.476 | 0.401 | 0.457 | 0.496 | 0.089 | 0.512 | 0.985 | 1.005 | 0.018 | 1.047 |
| string: canterbury/asyoulik.txt | 132198 | 8035.8 ± 2.2% | 0.020 | 0.434 | 0.334 | 0.406 | 0.442 | 0.084 | 0.443 | 0.985 | 1.004 | 0.020 | 1.039 |
| string: canterbury/lcet10.txt | 441884 | 8852.9 ± 3.6% | 0.019 | 0.573 | 0.385 | 0.545 | 0.572 | 0.118 | 0.572 | 1.003 | 1.016 | 0.019 | 1.049 |
| string: canterbury/plrabn12.txt | 503330 | 6822.0 ± 1.4% | 0.024 | 0.609 | 0.456 | 0.591 | 0.609 | 0.139 | 0.610 | 0.989 | 1.010 | 0.024 | 1.027 |
| string: canterbury-large/E.coli | 1048578 | 15092.2 ± 0.9% | 0.104 | 1.003 | 1.005 | 0.989 | 1.005 | 0.665 | 1.003 | 1.005 | 1.005 | 0.012 | 1.003 |
| string: canterbury-large/bible.txt | 1055886 | 8347.0 ± 2.1% | 0.021 | 0.639 | 0.549 | 0.672 | 0.663 | 0.342 | 0.658 | 0.923 | 0.932 | 0.021 | 1.029 |
| string: canterbury-large/world192.txt | 1103121 | 5273.3 ± 2.2% | 0.031 | 0.594 | 0.467 | 0.584 | 0.594 | 0.134 | 0.592 | 1.018 | 1.029 | 0.031 | 1.042 |
| string: http/html-1m | 1058582 | 8394.8 ± 0.6% | 0.021 | 0.598 | 0.538 | 0.612 | 0.599 | 0.285 | 0.599 | 0.995 | 1.004 | 0.021 | 1.006 |
| string: http/json-1m | 1190272 | 6415.9 ± 0.3% | 0.026 | 0.204 | 0.168 | 0.202 | 0.204 | 0.063 | 0.204 | 1.000 | 0.995 | 0.026 | 1.026 |
| string: http/js-1m | 1144362 | 5165.7 ± 3.4% | 0.031 | 0.381 | 0.335 | 0.383 | 0.381 | 0.083 | 0.381 | 1.035 | 1.039 | 0.030 | 1.068 |
| string: http/css-1m | 1097820 | 7258.4 ± 1.3% | 0.022 | 0.343 | 0.278 | 0.340 | 0.343 | 0.108 | 0.341 | 1.001 | 1.011 | 0.022 | 1.042 |
| string: dickens as Cyrillic and CJK | 1883069 | 4517.1 ± 8.4% | 0.028 | 0.465 | 0.066 | 0.465 | 0.464 | 0.183 | 0.466 | 0.995 | 1.004 | 0.028 | 0.988 |
| hex: silesia/dickens | 524290 | 28753.6 ± 0.6% | 1.000 | 0.080 | 1.001 | 0.556 | 1.001 | 0.999 | 0.996 | 0.998 | 1.001 | 0.080 | 1.001 |
| hex: silesia/mozilla | 524290 | 29200.5 ± 0.6% | 1.000 | 0.079 | 1.000 | 0.551 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 0.079 | 0.995 |
| hex: silesia/mr | 524290 | 29300.8 ± 0.5% | 1.000 | 0.079 | 0.999 | 0.552 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 0.079 | 1.000 |
| hex: silesia/nci | 524290 | 30242.8 ± 0.4% | 1.000 | 0.076 | 1.001 | 0.531 | 1.000 | 1.001 | 1.001 | 1.000 | 1.001 | 0.076 | 1.001 |
| hex: silesia/ooffice | 524290 | 29410.4 ± 0.6% | 1.001 | 0.078 | 1.001 | 0.547 | 1.001 | 1.001 | 1.001 | 1.001 | 1.002 | 0.079 | 1.002 |
| hex: silesia/osdb | 524290 | 28784.3 ± 0.2% | 1.000 | 0.080 | 1.001 | 0.553 | 1.000 | 1.001 | 1.001 | 1.000 | 1.000 | 0.080 | 1.002 |
| hex: silesia/reymont | 524290 | 29495.4 ± 0.2% | 1.001 | 0.078 | 1.000 | 0.549 | 1.001 | 1.000 | 0.995 | 1.000 | 1.002 | 0.078 | 1.001 |
| hex: silesia/samba | 524290 | 29612.8 ± 0.4% | 1.001 | 0.078 | 1.002 | 0.539 | 1.002 | 1.001 | 1.002 | 1.000 | 1.003 | 0.078 | 1.003 |
| hex: silesia/sao | 524290 | 29150.8 ± 0.5% | 1.001 | 0.079 | 1.002 | 0.553 | 1.001 | 1.002 | 1.001 | 1.001 | 1.002 | 0.079 | 1.002 |
| hex: silesia/webster | 524290 | 31162.5 ± 0.5% | 1.001 | 0.074 | 1.000 | 0.522 | 1.000 | 0.998 | 1.000 | 1.000 | 1.003 | 0.074 | 1.001 |
| hex: silesia/x-ray | 524290 | 29147.2 ± 0.8% | 1.003 | 0.079 | 1.002 | 0.553 | 1.003 | 1.001 | 1.002 | 1.001 | 1.002 | 0.079 | 1.003 |
| hex: silesia/xml | 524290 | 30212.3 ± 0.6% | 1.002 | 0.076 | 1.002 | 0.532 | 1.002 | 1.001 | 1.002 | 1.002 | 1.002 | 0.076 | 1.002 |
| hex: canterbury/alice29.txt | 304180 | 28740.3 ± 0.5% | 1.003 | 0.080 | 1.003 | 0.548 | 1.003 | 1.002 | 1.003 | 1.001 | 1.003 | 0.080 | 1.002 |
| hex: canterbury/asyoulik.txt | 250360 | 29149.9 ± 1.2% | 1.002 | 0.079 | 1.002 | 0.552 | 1.001 | 1.000 | 1.002 | 1.001 | 1.002 | 0.079 | 1.001 |
| hex: canterbury/cp.html | 49208 | 28479.9 ± 0.5% | 1.003 | 0.081 | 1.002 | 0.559 | 1.002 | 0.996 | 1.003 | 1.001 | 1.006 | 0.081 | 1.004 |
| hex: canterbury/fields.c | 22302 | 29226.7 ± 0.6% | 1.003 | 0.079 | 1.000 | 0.540 | 0.998 | 0.990 | 0.999 | 0.999 | 1.010 | 0.078 | 1.004 |
| hex: canterbury/grammar.lsp | 7444 | 27440.4 ± 0.4% | 0.999 | 0.083 | 1.002 | 0.547 | 1.002 | 0.972 | 1.002 | 1.000 | 1.020 | 0.083 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 29373.6 ± 0.8% | 1.001 | 0.079 | 1.002 | 0.547 | 1.002 | 1.001 | 1.002 | 1.002 | 1.003 | 0.079 | 1.002 |
| hex: canterbury/lcet10.txt | 524290 | 30193.6 ± 12.3% | 1.002 | 0.077 | 1.002 | 0.534 | 1.003 | 1.002 | 1.003 | 1.001 | 1.003 | 0.077 | 1.002 |
| hex: canterbury/plrabn12.txt | 524290 | 29219.7 ± 0.3% | 1.001 | 0.079 | 1.001 | 0.549 | 1.002 | 1.001 | 1.002 | 1.001 | 1.001 | 0.079 | 1.000 |
| hex: canterbury/ptt5 | 524290 | 29247.6 ± 0.2% | 1.001 | 0.079 | 1.001 | 0.548 | 1.001 | 1.000 | 1.000 | 1.000 | 1.001 | 0.079 | 1.001 |
| hex: canterbury/sum | 76482 | 28783.1 ± 0.7% | 1.001 | 0.080 | 1.000 | 0.558 | 1.001 | 0.997 | 1.001 | 1.000 | 1.002 | 0.080 | 1.002 |
| hex: canterbury/xargs.1 | 8456 | 27586.0 ± 11.4% | 1.001 | 0.083 | 1.002 | 0.548 | 1.001 | 0.960 | 1.002 | 1.003 | 1.019 | 0.082 | 1.005 |
| hex: canterbury-large/E.coli | 524290 | 28589.0 ± 4.1% | 1.002 | 0.081 | 1.005 | 0.555 | 1.005 | 1.005 | 1.006 | 1.004 | 1.006 | 0.081 | 1.006 |
| hex: canterbury-large/bible.txt | 524290 | 30226.1 ± 0.9% | 1.001 | 0.077 | 1.001 | 0.531 | 1.001 | 1.001 | 1.001 | 1.000 | 1.002 | 0.076 | 1.002 |
| hex: canterbury-large/world192.txt | 524290 | 29419.7 ± 0.6% | 1.000 | 0.079 | 1.001 | 0.549 | 1.001 | 1.000 | 1.001 | 0.999 | 1.000 | 0.079 | 1.002 |
| hex: http/html-1kx1024 | 2099200 | 17887.4 ± 1.3% | 1.010 | 0.126 | 1.013 | 0.809 | 1.009 | 0.933 | 1.011 | 1.014 | 1.031 | 0.122 | 1.017 |
| hex: http/html-16kx64 | 2097280 | 18954.2 ± 0.8% | 1.007 | 0.121 | 1.006 | 0.860 | 1.006 | 1.001 | 1.004 | 1.006 | 1.009 | 0.121 | 1.007 |
| hex: http/html-1m | 524290 | 29247.2 ± 0.1% | 0.999 | 0.079 | 1.000 | 0.559 | 1.000 | 1.001 | 1.000 | 1.000 | 1.001 | 0.079 | 1.000 |
| hex: http/json-1kx1024 | 2099200 | 17772.8 ± 7.5% | 1.003 | 0.126 | 1.003 | 0.812 | 1.000 | 0.923 | 1.003 | 1.002 | 1.023 | 0.123 | 1.009 |
| hex: http/json-16kx64 | 2097280 | 18573.9 ± 0.6% | 1.005 | 0.124 | 1.004 | 0.868 | 1.004 | 0.999 | 1.003 | 1.004 | 1.007 | 0.123 | 1.003 |
| hex: http/json-1m | 524290 | 29432.5 ± 0.2% | 1.000 | 0.078 | 1.000 | 0.558 | 1.000 | 1.000 | 1.000 | 1.001 | 1.000 | 0.079 | 1.001 |
| hex: http/js-1kx1024 | 2099200 | 18028.3 ± 0.4% | 1.003 | 0.125 | 1.002 | 0.802 | 1.004 | 0.923 | 1.003 | 1.004 | 1.024 | 0.121 | 1.010 |
| hex: http/js-16kx64 | 2097280 | 19083.8 ± 0.4% | 1.003 | 0.121 | 1.002 | 0.852 | 1.002 | 0.995 | 1.001 | 1.000 | 1.004 | 0.120 | 1.001 |
| hex: http/js-1m | 524290 | 29157.7 ± 1.1% | 1.002 | 0.079 | 1.002 | 0.563 | 1.003 | 1.001 | 1.003 | 1.001 | 1.004 | 0.079 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 17820.0 ± 0.6% | 1.001 | 0.126 | 0.998 | 0.811 | 1.000 | 0.925 | 1.002 | 1.002 | 1.024 | 0.122 | 1.007 |
| hex: http/css-16kx64 | 2097280 | 18768.1 ± 0.5% | 1.005 | 0.123 | 1.003 | 0.863 | 1.004 | 0.995 | 1.005 | 1.002 | 1.007 | 0.122 | 1.006 |
| hex: http/css-1m | 524290 | 29381.9 ± 1.9% | 0.996 | 0.079 | 1.001 | 0.557 | 1.002 | 1.000 | 1.002 | 1.001 | 1.001 | 0.079 | 1.002 |
| hex: shuffled/dickens-1m | 524290 | 29272.9 ± 0.2% | 1.001 | 0.079 | 1.000 | 0.557 | 1.001 | 1.000 | 1.002 | 1.001 | 1.003 | 0.079 | 1.001 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.095 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.097 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.094 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.097 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.058 of all on.
- messages: 11 string members, decoding: J12 decoder escape words off runs at 1.057 of all on.
- messages: 11 string members, decoding: J13 decoder escape blocks off runs at 1.054 of all on.
- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.087 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.077 of all on.
- messages: 50 nested objects, decoding: J8 decoder fast path off runs at 1.079 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.084 of all on.
- messages: 50 nested objects, decoding: J13 decoder escape blocks off runs at 1.081 of all on.
- messages: a tree of 341 objects, decoding: J5 UTF-8 vectors off runs at 1.073 of all on.
- messages: a tree of 341 objects, decoding: J7 wide vectors off runs at 1.050 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.054 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.054 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.110 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.141 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.078 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.154 of all on.
- string: canterbury/plrabn12.txt, decoding: J7 wide vectors off runs at 1.085 of all on.
- string: canterbury/plrabn12.txt, decoding: J8 decoder fast path off runs at 1.104 of all on.
- string: canterbury/plrabn12.txt, decoding: J13 decoder escape blocks off runs at 1.114 of all on.
- hex: canterbury/grammar.lsp, decoding: J5 UTF-8 vectors off runs at 1.063 of all on.
- hex: canterbury/grammar.lsp, decoding: J8 decoder fast path off runs at 1.060 of all on.
- hex: canterbury/grammar.lsp, decoding: J12 decoder escape words off runs at 1.068 of all on.
- hex: canterbury/grammar.lsp, decoding: J13 decoder escape blocks off runs at 1.058 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.051 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.050 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 158079.4 ± 1.0% | 105176.1 ± 0.7% | 1.503 | 93295.1 ± 1.0% | 1.694 |
| string: silesia/nci | 1048576 | 82346.7 ± 0.3% | 73432.9 ± 0.4% | 1.121 | 69168.2 ± 0.2% | 1.191 |
| string: silesia/reymont | 1048576 | 150407.4 ± 3.8% | 104988.3 ± 19.0% | 1.433 | 90752.6 ± 0.9% | 1.657 |
| string: silesia/samba | 65546 | 151540.4 ± 0.5% | 102942.3 ± 0.3% | 1.472 | 91673.0 ± 1.0% | 1.653 |
| string: silesia/webster | 1048576 | 99344.5 ± 4.4% | 54393.0 ± 1.8% | 1.826 | 75263.8 ± 2.8% | 1.320 |
| string: silesia/xml | 1048576 | 154018.4 ± 0.7% | 106102.6 ± 0.4% | 1.452 | 91965.5 ± 0.3% | 1.675 |
| string: canterbury/alice29.txt | 152089 | 158223.6 ± 0.1% | 105142.4 ± 1.1% | 1.505 | 93243.8 ± 0.6% | 1.697 |
| string: canterbury/asyoulik.txt | 125179 | 157484.6 ± 1.3% | 105349.9 ± 1.4% | 1.495 | 94448.8 ± 0.2% | 1.667 |
| string: canterbury/lcet10.txt | 426754 | 155052.6 ± 1.9% | 106068.2 ± 0.5% | 1.462 | 94802.5 ± 16.1% | 1.636 |
| string: canterbury/plrabn12.txt | 481861 | 155042.3 ± 0.3% | 106511.3 ± 4.4% | 1.456 | 95322.4 ± 3.1% | 1.627 |
| string: canterbury-large/E.coli | 1048576 | 154843.4 ± 0.8% | 105794.5 ± 0.2% | 1.464 | 93130.5 ± 0.7% | 1.663 |
| string: canterbury-large/bible.txt | 1048576 | 109379.0 ± 0.7% | 89157.5 ± 0.3% | 1.227 | 80482.4 ± 0.4% | 1.359 |
| string: canterbury-large/world192.txt | 1048576 | 128367.9 ± 6.3% | 97362.0 ± 0.7% | 1.318 | 86092.4 ± 0.2% | 1.491 |
| string: http/html-1m | 1048576 | 112101.4 ± 0.2% | 89460.9 ± 2.0% | 1.253 | 77219.5 ± 2.1% | 1.452 |
| string: http/json-1m | 1048576 | 81249.5 ± 0.3% | 74284.1 ± 0.4% | 1.094 | 62151.6 ± 0.4% | 1.307 |
| string: http/js-1m | 1048576 | 152288.9 ± 0.2% | 105713.9 ± 0.9% | 1.441 | 93820.3 ± 0.2% | 1.623 |
| string: http/css-1m | 1048576 | 153548.2 ± 0.5% | 105000.4 ± 0.6% | 1.462 | 94421.5 ± 0.8% | 1.626 |
| string: dickens as Cyrillic and CJK | 1847045 | 20656.4 ± 0.7% | 17865.6 ± 0.4% | 1.156 | 13343.0 ± 0.1% | 1.548 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 155675.7 ± 0.2% | 53951.7 ± 0.1% | 2.885 | 95232.2 ± 3.3% | 1.635 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 153943.7 ± 0.8% | 106551.5 ± 14.8% | 1.445 | 93233.3 ± 0.5% | 1.651 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 153748.0 ± 0.5% | 106116.1 ± 1.1% | 1.449 | 93008.4 ± 5.9% | 1.653 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 153975.6 ± 0.8% | 106527.5 ± 2.5% | 1.445 | 93217.1 ± 1.4% | 1.652 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 153925.0 ± 0.5% | 106620.6 ± 0.5% | 1.444 | 92534.9 ± 2.7% | 1.663 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 154001.4 ± 1.1% | 106834.9 ± 0.3% | 1.441 | 95292.8 ± 0.5% | 1.616 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 20949.9 ± 0.7% | 18570.1 ± 0.5% | 1.128 | 13400.8 ± 3.0% | 1.563 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 20944.8 ± 0.2% | 18577.1 ± 0.2% | 1.127 | 13400.6 ± 5.0% | 1.563 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 20949.5 ± 4.1% | 18535.4 ± 9.4% | 1.130 | 13477.2 ± 0.9% | 1.554 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 20946.7 ± 0.2% | 18552.2 ± 0.3% | 1.129 | 13465.7 ± 0.8% | 1.556 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 20947.9 ± 0.4% | 18578.7 ± 0.2% | 1.128 | 13481.5 ± 0.3% | 1.554 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 20936.9 ± 0.3% | 18555.5 ± 0.5% | 1.128 | 13489.9 ± 0.3% | 1.552 |

## Messages against serde_json's typed code

stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.

| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |
|---|---|---|---|---|
| messages: 11 string members | 1025025 | 1014.0 ± 10.1% | 581.7 ± 1.6% | 1.743 |
| messages: 50 nested objects | 1121600 | 1183.6 ± 0.9% | 592.5 ± 0.5% | 1.997 |
| messages: a tree of 341 objects | 612600 | 482.3 ± 2.1% | 381.0 ± 0.5% | 1.266 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1032.2 ± 1.2% | 1064.8 ± 0.7% | 856.9 ± 0.4% | 322.7 ± 0.6% | 527.6 ± 8.8% | 293.9 ± 13.9% | 0.969 | 1.205 | 3.198 | 1.956 | 3.512 |
| qlog records, JSON text sequence | 1467503 | 682.4 ± 1.6% | 936.7 ± 2.9% | 828.6 ± 0.8% | 268.1 ± 8.0% | 598.4 ± 1.4% | 253.9 ± 3.3% | 0.728 | 0.823 | 2.546 | 1.140 | 2.688 |
| messages: 11 string members | 1025025 | 797.7 ± 2.9% | 1187.5 ± 0.4% | 579.9 ± 0.8% | 278.0 ± 0.9% | 418.2 ± 4.0% | 244.0 ± 0.9% | 0.672 | 1.376 | 2.869 | 1.907 | 3.268 |
| messages: 50 nested objects | 1121600 | 1037.0 ± 0.2% | 1034.4 ± 1.2% | 962.8 ± 0.4% | 346.6 ± 0.4% | 647.1 ± 0.5% | 329.1 ± 5.2% | 1.002 | 1.077 | 2.992 | 1.603 | 3.151 |
| messages: a tree of 341 objects | 612600 | 496.7 ± 0.4% | 630.9 ± 0.3% | 468.9 ± 0.7% | 155.1 ± 11.9% | 481.6 ± 0.6% | 156.6 ± 2.8% | 0.787 | 1.059 | 3.202 | 1.031 | 3.171 |
| string: silesia/dickens | 172528 | 5891.4 ± 1.4% | 2897.3 ± 1.1% | 2399.3 ± 1.8% | 264.2 ± 4.1% | 2197.1 ± 1.8% | 503.9 ± 6.2% | 2.033 | 2.455 | 22.295 | 2.681 | 11.692 |
| string: silesia/nci | 1075110 | 5009.8 ± 1.6% | 3213.0 ± 2.2% | 2240.1 ± 0.5% | 562.9 ± 1.7% | 2377.3 ± 0.6% | 531.0 ± 1.6% | 1.559 | 2.236 | 8.900 | 2.107 | 9.435 |
| string: silesia/reymont | 1075159 | 3162.8 ± 1.3% | 2556.7 ± 0.6% | 1551.0 ± 0.4% | 283.4 ± 0.5% | 1604.8 ± 0.3% | 456.8 ± 0.9% | 1.237 | 2.039 | 11.159 | 1.971 | 6.923 |
| string: silesia/samba | 97582 | 2784.5 ± 0.5% | 2832.1 ± 1.8% | 2184.0 ± 1.2% | 274.1 ± 0.2% | 1329.8 ± 1.0% | 352.5 ± 10.4% | 0.983 | 1.275 | 10.157 | 2.094 | 7.900 |
| string: silesia/webster | 1098490 | 3810.1 ± 1.0% | 1998.0 ± 0.4% | 1436.1 ± 0.2% | 256.7 ± 0.7% | 1579.8 ± 1.3% | 416.9 ± 0.9% | 1.907 | 2.653 | 14.842 | 2.412 | 9.139 |
| string: silesia/xml | 1090118 | 4682.4 ± 0.9% | 3576.6 ± 0.2% | 1853.3 ± 0.6% | 420.7 ± 5.5% | 2272.0 ± 0.7% | 499.0 ± 0.7% | 1.309 | 2.526 | 11.131 | 2.061 | 9.384 |
| string: canterbury/alice29.txt | 159425 | 5174.5 ± 0.7% | 2453.6 ± 0.6% | 2351.3 ± 1.6% | 246.7 ± 0.8% | 1993.7 ± 2.5% | 453.3 ± 2.2% | 2.109 | 2.201 | 20.979 | 2.595 | 11.416 |
| string: canterbury/asyoulik.txt | 132198 | 3439.4 ± 0.9% | 1955.7 ± 1.5% | 2112.8 ± 0.2% | 250.5 ± 5.9% | 1639.6 ± 1.8% | 396.4 ± 2.2% | 1.759 | 1.628 | 13.730 | 2.098 | 8.677 |
| string: canterbury/lcet10.txt | 441884 | 5942.4 ± 2.1% | 2728.5 ± 1.1% | 1820.5 ± 0.5% | 289.5 ± 0.3% | 2071.5 ± 1.0% | 475.6 ± 1.7% | 2.178 | 3.264 | 20.529 | 2.869 | 12.494 |
| string: canterbury/plrabn12.txt | 503330 | 3966.4 ± 0.6% | 2338.8 ± 0.6% | 1524.4 ± 4.8% | 267.7 ± 0.4% | 2027.4 ± 0.6% | 435.1 ± 1.3% | 1.696 | 2.602 | 14.814 | 1.956 | 9.116 |
| string: canterbury-large/E.coli | 1048578 | 15214.0 ± 0.6% | 7688.3 ± 1.1% | 2777.5 ± 12.5% | 985.7 ± 0.6% | 5206.8 ± 0.2% | 907.1 ± 0.6% | 1.979 | 5.478 | 15.434 | 2.922 | 16.771 |
| string: canterbury-large/bible.txt | 1055886 | 8261.6 ± 3.3% | 4570.7 ± 14.7% | 2079.3 ± 2.0% | 305.0 ± 2.8% | 3018.8 ± 5.4% | 570.1 ± 11.9% | 1.807 | 3.973 | 27.085 | 2.737 | 14.492 |
| string: canterbury-large/world192.txt | 1103121 | 3587.3 ± 1.6% | 1886.5 ± 1.2% | 1458.9 ± 0.3% | 268.8 ± 0.3% | 1621.1 ± 6.7% | 421.7 ± 1.1% | 1.902 | 2.459 | 13.348 | 2.213 | 8.506 |
| string: http/html-1m | 1058582 | 7873.5 ± 1.4% | 3941.5 ± 0.5% | 2031.2 ± 2.9% | 351.8 ± 0.2% | 2763.7 ± 1.5% | 562.7 ± 1.3% | 1.998 | 3.876 | 22.381 | 2.849 | 13.993 |
| string: http/json-1m | 1190272 | 2833.0 ± 0.5% | 1057.6 ± 1.2% | 1688.1 ± 1.7% | 382.8 ± 0.6% | 841.8 ± 3.3% | 361.7 ± 2.5% | 2.679 | 1.678 | 7.401 | 3.365 | 7.833 |
| string: http/js-1m | 1144362 | 2502.3 ± 1.0% | 1399.8 ± 0.3% | 1130.7 ± 0.9% | 263.1 ± 0.3% | 1097.9 ± 0.5% | 333.5 ± 1.9% | 1.788 | 2.213 | 9.511 | 2.279 | 7.502 |
| string: http/css-1m | 1097820 | 2734.2 ± 1.0% | 2179.2 ± 2.3% | 1640.8 ± 0.6% | 369.6 ± 0.3% | 1446.8 ± 0.2% | 403.4 ± 1.1% | 1.255 | 1.666 | 7.398 | 1.890 | 6.778 |
| string: dickens as Cyrillic and CJK | 1883069 | 4703.3 ± 0.6% | 3239.0 ± 0.7% | 612.3 ± 3.6% | 283.0 ± 1.4% | 443.0 ± 0.2% | 128.4 ± 2.0% | 1.452 | 7.681 | 16.618 | 10.618 | 36.619 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 904.8 ± 1.0% | 1009.9 ± 6.0% | 908.9 ± 5.3% | 194.7 ± 0.8% | 370.7 ± 0.6% | 184.1 ± 4.9% | 0.896 | 0.996 | 4.647 | 2.441 | 4.914 |
| hex: silesia/dickens | 524290 | 34697.5 ± 0.3% | 10686.7 ± 0.4% | 3037.8 ± 0.4% | 398.9 ± 3.6% | 5224.7 ± 0.3% | 942.4 ± 2.8% | 3.247 | 11.422 | 86.991 | 6.641 | 36.817 |
| hex: silesia/mozilla | 524290 | 34676.3 ± 0.6% | 10700.2 ± 0.2% | 2964.1 ± 0.1% | 342.4 ± 1.7% | 5226.1 ± 0.2% | 937.8 ± 0.6% | 3.241 | 11.699 | 101.271 | 6.635 | 36.976 |
| hex: silesia/mr | 524290 | 29369.4 ± 0.5% | 10697.6 ± 0.3% | 2964.2 ± 0.4% | 518.9 ± 0.9% | 5219.8 ± 1.6% | 937.2 ± 2.0% | 2.745 | 9.908 | 56.597 | 5.627 | 31.337 |
| hex: silesia/nci | 524290 | 41024.9 ± 0.4% | 10690.5 ± 0.4% | 3065.2 ± 1.0% | 660.2 ± 0.1% | 5215.9 ± 0.3% | 932.8 ± 1.1% | 3.838 | 13.384 | 62.142 | 7.865 | 43.979 |
| hex: silesia/ooffice | 524290 | 38405.9 ± 1.1% | 10698.4 ± 0.2% | 2997.7 ± 0.5% | 282.2 ± 1.5% | 5217.8 ± 0.5% | 935.1 ± 1.6% | 3.590 | 12.812 | 136.112 | 7.361 | 41.070 |
| hex: silesia/osdb | 524290 | 33016.7 ± 3.0% | 10680.8 ± 1.0% | 2999.4 ± 0.4% | 388.1 ± 3.5% | 5223.0 ± 0.4% | 936.8 ± 1.8% | 3.091 | 11.008 | 85.063 | 6.321 | 35.246 |
| hex: silesia/reymont | 524290 | 40252.0 ± 0.4% | 10684.1 ± 8.5% | 3062.2 ± 16.6% | 434.9 ± 4.5% | 5225.8 ± 0.2% | 931.8 ± 1.2% | 3.767 | 13.145 | 92.563 | 7.703 | 43.199 |
| hex: silesia/samba | 524290 | 25184.3 ± 0.3% | 10679.7 ± 0.3% | 2978.8 ± 0.2% | 300.1 ± 0.3% | 5224.8 ± 0.4% | 936.7 ± 1.7% | 2.358 | 8.454 | 83.933 | 4.820 | 26.887 |
| hex: silesia/sao | 524290 | 40868.1 ± 1.8% | 10702.5 ± 0.3% | 3003.1 ± 0.5% | 224.7 ± 3.2% | 5226.3 ± 9.7% | 932.2 ± 15.5% | 3.819 | 13.608 | 181.862 | 7.820 | 43.842 |
| hex: silesia/webster | 524290 | 42131.2 ± 0.4% | 10674.7 ± 0.4% | 3063.3 ± 0.6% | 382.7 ± 2.8% | 5226.1 ± 0.2% | 931.9 ± 1.4% | 3.947 | 13.754 | 110.096 | 8.062 | 45.211 |
| hex: silesia/x-ray | 524290 | 41822.1 ± 1.0% | 10688.2 ± 0.3% | 3006.9 ± 0.2% | 369.4 ± 2.9% | 5227.7 ± 0.2% | 928.8 ± 0.7% | 3.913 | 13.909 | 113.201 | 8.000 | 45.029 |
| hex: silesia/xml | 524290 | 40399.1 ± 13.6% | 10687.2 ± 0.4% | 3012.2 ± 0.1% | 642.7 ± 1.0% | 5217.7 ± 0.3% | 925.3 ± 2.8% | 3.780 | 13.412 | 62.858 | 7.743 | 43.661 |
| hex: canterbury/alice29.txt | 304180 | 41372.5 ± 0.2% | 11008.1 ± 0.1% | 3003.0 ± 0.2% | 403.4 ± 3.0% | 5217.8 ± 0.5% | 951.6 ± 1.6% | 3.758 | 13.777 | 102.563 | 7.929 | 43.476 |
| hex: canterbury/asyoulik.txt | 250360 | 41448.8 ± 0.3% | 10478.8 ± 0.2% | 2982.5 ± 0.2% | 394.7 ± 3.2% | 5225.6 ± 0.1% | 950.7 ± 0.9% | 3.955 | 13.898 | 105.025 | 7.932 | 43.598 |
| hex: canterbury/cp.html | 49208 | 33877.3 ± 0.2% | 11265.3 ± 1.8% | 3075.9 ± 2.1% | 435.7 ± 1.8% | 5202.9 ± 0.4% | 930.9 ± 1.2% | 3.007 | 11.014 | 77.758 | 6.511 | 36.394 |
| hex: canterbury/fields.c | 22302 | 43924.2 ± 0.6% | 12116.3 ± 0.5% | 3134.5 ± 0.2% | 513.9 ± 0.7% | 5197.2 ± 0.5% | 923.2 ± 2.7% | 3.625 | 14.013 | 85.480 | 8.451 | 47.579 |
| hex: canterbury/grammar.lsp | 7444 | 35130.7 ± 0.5% | 11787.0 ± 0.2% | 3102.1 ± 0.7% | 673.4 ± 2.7% | 5107.7 ± 0.5% | 882.5 ± 2.6% | 2.980 | 11.325 | 52.166 | 6.878 | 39.807 |
| hex: canterbury/kennedy.xls | 524290 | 33091.3 ± 9.7% | 9710.6 ± 0.4% | 3043.4 ± 0.5% | 676.6 ± 0.3% | 5226.8 ± 0.3% | 934.6 ± 1.2% | 3.408 | 10.873 | 48.906 | 6.331 | 35.406 |
| hex: canterbury/lcet10.txt | 524290 | 41484.5 ± 0.5% | 9906.0 ± 0.2% | 3049.9 ± 0.3% | 407.9 ± 3.8% | 5227.1 ± 0.2% | 942.8 ± 1.1% | 4.188 | 13.602 | 101.693 | 7.936 | 44.003 |
| hex: canterbury/plrabn12.txt | 524290 | 31778.0 ± 0.9% | 9864.0 ± 1.4% | 3038.8 ± 0.1% | 390.1 ± 3.4% | 5219.1 ± 0.3% | 936.6 ± 1.2% | 3.222 | 10.457 | 81.456 | 6.089 | 33.930 |
| hex: canterbury/ptt5 | 524290 | 34086.3 ± 0.4% | 9909.1 ± 15.0% | 2938.8 ± 0.3% | 520.1 ± 1.0% | 5222.3 ± 0.2% | 936.8 ± 1.3% | 3.440 | 11.599 | 65.532 | 6.527 | 36.387 |
| hex: canterbury/sum | 76482 | 40440.4 ± 0.2% | 10733.5 ± 1.6% | 3062.6 ± 0.3% | 493.5 ± 3.0% | 5212.8 ± 0.6% | 934.2 ± 2.4% | 3.768 | 13.205 | 81.941 | 7.758 | 43.289 |
| hex: canterbury/xargs.1 | 8456 | 38108.5 ± 6.5% | 11846.5 ± 12.5% | 3035.1 ± 0.1% | 663.0 ± 1.5% | 5115.2 ± 0.3% | 908.3 ± 2.4% | 3.217 | 12.556 | 57.477 | 7.450 | 41.958 |
| hex: canterbury-large/E.coli | 524290 | 40476.2 ± 1.3% | 9850.5 ± 0.5% | 2986.3 ± 0.5% | 693.6 ± 0.5% | 5211.8 ± 0.3% | 931.8 ± 1.8% | 4.109 | 13.554 | 58.359 | 7.766 | 43.441 |
| hex: canterbury-large/bible.txt | 524290 | 28772.4 ± 0.4% | 9803.4 ± 7.7% | 3013.6 ± 1.1% | 428.7 ± 3.0% | 5224.8 ± 0.4% | 935.6 ± 0.7% | 2.935 | 9.547 | 67.122 | 5.507 | 30.754 |
| hex: canterbury-large/world192.txt | 524290 | 40021.4 ± 1.9% | 9835.4 ± 1.0% | 3074.3 ± 0.2% | 397.5 ± 3.3% | 5228.2 ± 1.9% | 938.6 ± 1.4% | 4.069 | 13.018 | 100.689 | 7.655 | 42.638 |
| hex: http/html-1kx1024 | 2099200 | 14145.4 ± 0.9% | 8747.6 ± 0.2% | 2781.2 ± 0.4% | 438.9 ± 3.2% | 4626.6 ± 0.8% | 779.7 ± 2.0% | 1.617 | 5.086 | 32.230 | 3.057 | 18.141 |
| hex: http/html-16kx64 | 2097280 | 24805.8 ± 0.4% | 11280.5 ± 0.9% | 2901.8 ± 0.3% | 432.9 ± 3.4% | 5190.1 ± 0.3% | 879.5 ± 2.6% | 2.199 | 8.548 | 57.297 | 4.779 | 28.205 |
| hex: http/html-1m | 524290 | 41445.2 ± 1.1% | 10014.9 ± 4.3% | 2951.0 ± 4.4% | 432.3 ± 4.3% | 5219.7 ± 1.7% | 925.6 ± 2.2% | 4.138 | 14.045 | 95.876 | 7.940 | 44.775 |
| hex: http/json-1kx1024 | 2099200 | 14118.2 ± 0.6% | 8750.2 ± 0.6% | 2779.8 ± 0.3% | 623.6 ± 1.7% | 4634.3 ± 0.5% | 779.7 ± 2.4% | 1.613 | 5.079 | 22.641 | 3.046 | 18.108 |
| hex: http/json-16kx64 | 2097280 | 25495.4 ± 0.6% | 11300.4 ± 0.4% | 2908.3 ± 0.4% | 640.5 ± 0.7% | 5185.2 ± 1.1% | 875.7 ± 3.4% | 2.256 | 8.766 | 39.805 | 4.917 | 29.113 |
| hex: http/json-1m | 524290 | 29431.5 ± 0.9% | 10357.8 ± 1.4% | 3075.0 ± 0.2% | 675.4 ± 0.4% | 5221.9 ± 0.3% | 932.1 ± 2.3% | 2.841 | 9.571 | 43.579 | 5.636 | 31.576 |
| hex: http/js-1kx1024 | 2099200 | 14068.9 ± 1.9% | 8731.4 ± 0.3% | 2783.6 ± 0.6% | 429.3 ± 3.1% | 4629.4 ± 0.8% | 783.0 ± 2.6% | 1.611 | 5.054 | 32.772 | 3.039 | 17.969 |
| hex: http/js-16kx64 | 2097280 | 24609.2 ± 0.4% | 11287.5 ± 0.4% | 2911.1 ± 0.2% | 431.8 ± 3.0% | 5196.0 ± 0.5% | 888.9 ± 0.9% | 2.180 | 8.454 | 56.990 | 4.736 | 27.684 |
| hex: http/js-1m | 524290 | 40384.5 ± 1.0% | 10391.3 ± 0.4% | 3063.9 ± 0.5% | 442.2 ± 2.7% | 5217.8 ± 1.0% | 925.9 ± 2.1% | 3.886 | 13.181 | 91.318 | 7.740 | 43.615 |
| hex: http/css-1kx1024 | 2099200 | 13971.4 ± 1.8% | 8735.8 ± 2.2% | 2777.7 ± 7.7% | 486.2 ± 2.2% | 4628.4 ± 0.8% | 768.7 ± 8.9% | 1.599 | 5.030 | 28.738 | 3.019 | 18.175 |
| hex: http/css-16kx64 | 2097280 | 24394.9 ± 0.4% | 11309.1 ± 0.2% | 2900.1 ± 0.2% | 495.7 ± 2.5% | 5189.9 ± 0.2% | 881.6 ± 0.6% | 2.157 | 8.412 | 49.209 | 4.700 | 27.672 |
| hex: http/css-1m | 524290 | 32012.3 ± 0.3% | 10286.8 ± 0.2% | 3070.8 ± 6.7% | 473.6 ± 2.6% | 5226.3 ± 0.4% | 935.8 ± 0.9% | 3.112 | 10.425 | 67.593 | 6.125 | 34.210 |
| hex: shuffled/dickens-1m | 524290 | 36704.4 ± 0.4% | 10292.2 ± 1.5% | 3006.7 ± 0.5% | 398.8 ± 3.8% | 5220.7 ± 0.4% | 926.9 ± 0.9% | 3.566 | 12.208 | 92.047 | 7.031 | 39.601 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1378.3 ± 0.4% | 1125.6 ± 14.7% | 837.8 ± 0.8% | 367.7 ± 0.6% | 358.9 ± 0.7% | 390.6 ± 1.8% | 1.224 | 1.645 | 3.748 | 3.840 | 3.528 |
| qlog records, JSON text sequence | 1467503 | 1052.2 ± 1.9% | 830.8 ± 7.8% | 685.4 ± 6.1% | 323.3 ± 5.1% | 346.1 ± 18.4% | 247.5 ± 6.8% | 1.267 | 1.535 | 3.254 | 3.041 | 4.251 |
| messages: 11 string members | 1025025 | 1036.9 ± 2.0% | 836.5 ± 1.9% | 623.0 ± 4.4% | 318.0 ± 1.9% | 322.5 ± 5.5% | 322.4 ± 2.9% | 1.240 | 1.664 | 3.261 | 3.215 | 3.217 |
| messages: 50 nested objects | 1121600 | 1401.2 ± 0.7% | 1207.8 ± 4.8% | 1015.3 ± 9.3% | 439.8 ± 1.3% | 398.6 ± 8.7% | 396.8 ± 1.6% | 1.160 | 1.380 | 3.186 | 3.516 | 3.531 |
| messages: a tree of 341 objects | 612600 | 483.1 ± 9.2% | 609.3 ± 3.7% | 426.6 ± 2.4% | 227.2 ± 2.2% | 263.5 ± 1.8% | 145.9 ± 0.9% | 0.793 | 1.132 | 2.126 | 1.833 | 3.311 |
| string: silesia/dickens | 172528 | 9863.7 ± 1.1% | 2920.8 ± 2.4% | 2398.6 ± 2.6% | 272.7 ± 1.0% | 1143.0 ± 0.6% | 1027.4 ± 0.1% | 3.377 | 4.112 | 36.173 | 8.630 | 9.601 |
| string: silesia/nci | 1075110 | 8364.2 ± 1.3% | 3165.2 ± 1.1% | 2430.2 ± 1.0% | 790.8 ± 0.9% | 1221.6 ± 0.5% | 1016.5 ± 1.6% | 2.643 | 3.442 | 10.577 | 6.847 | 8.229 |
| string: silesia/reymont | 1075159 | 4434.7 ± 4.9% | 1510.2 ± 1.6% | 1597.7 ± 0.3% | 313.0 ± 0.3% | 1036.1 ± 0.2% | 922.6 ± 0.3% | 2.936 | 2.776 | 14.167 | 4.280 | 4.807 |
| string: silesia/samba | 97582 | 4422.7 ± 0.7% | 1994.5 ± 0.5% | 2782.1 ± 0.9% | 265.8 ± 0.5% | 990.9 ± 0.8% | 1003.6 ± 0.6% | 2.217 | 1.590 | 16.637 | 4.463 | 4.407 |
| string: silesia/webster | 1098490 | 5697.7 ± 1.0% | 1510.2 ± 0.4% | 1504.6 ± 0.7% | 290.7 ± 0.8% | 1010.4 ± 2.2% | 516.7 ± 1.7% | 3.773 | 3.787 | 19.601 | 5.639 | 11.027 |
| string: silesia/xml | 1090118 | 7879.7 ± 1.1% | 2378.9 ± 9.7% | 2026.0 ± 0.8% | 499.3 ± 1.2% | 1192.1 ± 2.7% | 809.6 ± 0.9% | 3.312 | 3.889 | 15.781 | 6.610 | 9.733 |
| string: canterbury/alice29.txt | 159425 | 9049.8 ± 2.4% | 2197.9 ± 0.9% | 2222.9 ± 0.3% | 262.0 ± 2.7% | 1092.9 ± 8.2% | 930.0 ± 0.8% | 4.118 | 4.071 | 34.537 | 8.280 | 9.731 |
| string: canterbury/asyoulik.txt | 132198 | 8035.8 ± 2.2% | 1641.0 ± 0.3% | 2240.1 ± 1.2% | 260.8 ± 2.0% | 969.8 ± 2.0% | 825.6 ± 9.0% | 4.897 | 3.587 | 30.812 | 8.286 | 9.733 |
| string: canterbury/lcet10.txt | 441884 | 8852.9 ± 3.6% | 2352.0 ± 6.7% | 2069.0 ± 0.5% | 307.3 ± 0.6% | 1096.4 ± 11.8% | 990.9 ± 1.3% | 3.764 | 4.279 | 28.811 | 8.075 | 8.934 |
| string: canterbury/plrabn12.txt | 503330 | 6822.0 ± 1.4% | 1737.1 ± 0.5% | 1738.4 ± 2.0% | 279.6 ± 1.8% | 1051.3 ± 0.9% | 897.8 ± 12.9% | 3.927 | 3.924 | 24.398 | 6.489 | 7.599 |
| string: canterbury-large/E.coli | 1048578 | 15092.2 ± 0.9% | 8757.7 ± 0.3% | 2598.1 ± 0.2% | 1491.3 ± 0.6% | 1494.3 ± 0.2% | 1078.4 ± 1.0% | 1.723 | 5.809 | 10.120 | 10.100 | 13.995 |
| string: canterbury-large/bible.txt | 1055886 | 8347.0 ± 2.1% | 3686.2 ± 0.2% | 2314.9 ± 1.4% | 330.8 ± 0.8% | 1306.2 ± 0.7% | 1164.9 ± 0.3% | 2.264 | 3.606 | 25.234 | 6.390 | 7.166 |
| string: canterbury-large/world192.txt | 1103121 | 5273.3 ± 2.2% | 1316.3 ± 0.5% | 1599.5 ± 1.9% | 286.3 ± 2.3% | 990.1 ± 4.3% | 839.4 ± 4.8% | 4.006 | 3.297 | 18.420 | 5.326 | 6.282 |
| string: http/html-1m | 1058582 | 8394.8 ± 0.6% | 3371.3 ± 0.6% | 2254.4 ± 0.5% | 339.6 ± 3.3% | 1278.1 ± 1.9% | 711.7 ± 2.2% | 2.490 | 3.724 | 24.722 | 6.568 | 11.795 |
| string: http/json-1m | 1190272 | 6415.9 ± 0.3% | 1157.7 ± 0.4% | 1357.0 ± 0.3% | 435.0 ± 0.5% | 766.1 ± 1.0% | 689.2 ± 1.1% | 5.542 | 4.728 | 14.747 | 8.374 | 9.309 |
| string: http/js-1m | 1144362 | 5165.7 ± 3.4% | 877.7 ± 0.7% | 1191.0 ± 0.3% | 262.0 ± 3.1% | 824.0 ± 0.8% | 664.0 ± 0.4% | 5.885 | 4.337 | 19.720 | 6.269 | 7.780 |
| string: http/css-1m | 1097820 | 7258.4 ± 1.3% | 1141.3 ± 0.9% | 1731.7 ± 0.5% | 396.0 ± 5.6% | 932.6 ± 0.7% | 813.8 ± 1.2% | 6.360 | 4.192 | 18.328 | 7.783 | 8.919 |
| string: dickens as Cyrillic and CJK | 1883069 | 4517.1 ± 8.4% | 2879.0 ± 0.5% | 419.8 ± 0.4% | 209.5 ± 2.0% | 374.0 ± 0.4% | 277.7 ± 6.4% | 1.569 | 10.760 | 21.557 | 12.079 | 16.263 |
| hex: silesia/dickens | 524290 | 28753.6 ± 0.6% | 1702.7 ± 0.2% | 1055.2 ± 0.8% | 385.5 ± 0.1% | 884.2 ± 7.9% | 791.0 ± 7.1% | 16.887 | 27.250 | 74.588 | 32.519 | 36.351 |
| hex: silesia/mozilla | 524290 | 29200.5 ± 0.6% | 1697.8 ± 5.3% | 1061.0 ± 4.4% | 325.0 ± 3.5% | 872.1 ± 4.9% | 802.0 ± 3.0% | 17.199 | 27.522 | 89.834 | 33.484 | 36.409 |
| hex: silesia/mr | 524290 | 29300.8 ± 0.5% | 1706.5 ± 0.5% | 1061.8 ± 0.1% | 487.8 ± 7.6% | 882.6 ± 2.7% | 798.8 ± 2.3% | 17.170 | 27.595 | 60.062 | 33.198 | 36.683 |
| hex: silesia/nci | 524290 | 30242.8 ± 0.4% | 1710.2 ± 1.1% | 1059.1 ± 0.2% | 656.5 ± 0.4% | 883.4 ± 10.9% | 800.5 ± 3.3% | 17.684 | 28.556 | 46.068 | 34.235 | 37.780 |
| hex: silesia/ooffice | 524290 | 29410.4 ± 0.6% | 1711.2 ± 1.1% | 1062.0 ± 0.1% | 267.5 ± 1.2% | 883.5 ± 0.5% | 795.2 ± 3.2% | 17.187 | 27.693 | 109.932 | 33.290 | 36.983 |
| hex: silesia/osdb | 524290 | 28784.3 ± 0.2% | 1710.8 ± 0.3% | 1059.4 ± 0.2% | 362.1 ± 1.5% | 882.8 ± 10.6% | 795.4 ± 1.5% | 16.825 | 27.171 | 79.492 | 32.604 | 36.191 |
| hex: silesia/reymont | 524290 | 29495.4 ± 0.2% | 1707.1 ± 1.2% | 1059.1 ± 0.6% | 406.7 ± 0.4% | 881.1 ± 1.0% | 799.4 ± 1.9% | 17.279 | 27.849 | 72.516 | 33.477 | 36.898 |
| hex: silesia/samba | 524290 | 29612.8 ± 0.4% | 1707.5 ± 0.4% | 1060.6 ± 0.3% | 288.2 ± 0.7% | 882.5 ± 0.4% | 795.3 ± 4.8% | 17.343 | 27.920 | 102.765 | 33.554 | 37.236 |
| hex: silesia/sao | 524290 | 29150.8 ± 0.5% | 1702.3 ± 0.9% | 1059.6 ± 0.2% | 217.1 ± 0.6% | 876.5 ± 0.2% | 794.2 ± 2.9% | 17.124 | 27.511 | 134.274 | 33.257 | 36.706 |
| hex: silesia/webster | 524290 | 31162.5 ± 0.5% | 1705.9 ± 1.1% | 1059.9 ± 9.5% | 351.1 ± 0.4% | 882.5 ± 0.3% | 795.6 ± 1.6% | 18.268 | 29.401 | 88.752 | 35.313 | 39.167 |
| hex: silesia/x-ray | 524290 | 29147.2 ± 0.8% | 1706.6 ± 0.9% | 1059.5 ± 0.6% | 342.4 ± 1.1% | 882.8 ± 0.2% | 794.0 ± 0.7% | 17.079 | 27.511 | 85.125 | 33.018 | 36.711 |
| hex: silesia/xml | 524290 | 30212.3 ± 0.6% | 1708.5 ± 10.8% | 1061.5 ± 0.3% | 584.6 ± 0.6% | 884.4 ± 7.3% | 815.3 ± 3.1% | 17.683 | 28.461 | 51.684 | 34.162 | 37.055 |
| hex: canterbury/alice29.txt | 304180 | 28740.3 ± 0.5% | 1701.5 ± 0.1% | 1073.6 ± 0.2% | 389.4 ± 0.3% | 890.0 ± 0.6% | 834.9 ± 0.7% | 16.891 | 26.771 | 73.803 | 32.293 | 34.423 |
| hex: canterbury/asyoulik.txt | 250360 | 29149.9 ± 1.2% | 1724.2 ± 0.7% | 1082.8 ± 0.3% | 380.5 ± 0.2% | 890.1 ± 0.3% | 825.7 ± 2.3% | 16.906 | 26.920 | 76.612 | 32.750 | 35.302 |
| hex: canterbury/cp.html | 49208 | 28479.9 ± 0.5% | 1721.1 ± 0.2% | 1075.0 ± 15.4% | 385.5 ± 0.6% | 890.5 ± 1.3% | 845.0 ± 1.5% | 16.547 | 26.493 | 73.883 | 31.981 | 33.706 |
| hex: canterbury/fields.c | 22302 | 29226.7 ± 0.6% | 1722.3 ± 0.3% | 1077.6 ± 1.8% | 597.3 ± 0.9% | 892.8 ± 0.3% | 835.9 ± 5.0% | 16.969 | 27.122 | 48.928 | 32.735 | 34.963 |
| hex: canterbury/grammar.lsp | 7444 | 27440.4 ± 0.4% | 1773.3 ± 0.7% | 1091.6 ± 0.8% | 676.5 ± 1.6% | 900.6 ± 0.6% | 838.4 ± 3.3% | 15.474 | 25.138 | 40.565 | 30.469 | 32.729 |
| hex: canterbury/kennedy.xls | 524290 | 29373.6 ± 0.8% | 1708.6 ± 0.3% | 1060.7 ± 1.5% | 646.7 ± 0.3% | 882.8 ± 0.4% | 797.6 ± 1.3% | 17.192 | 27.692 | 45.423 | 33.272 | 36.828 |
| hex: canterbury/lcet10.txt | 524290 | 30193.6 ± 12.3% | 1707.4 ± 13.6% | 1061.0 ± 0.3% | 385.3 ± 0.5% | 860.6 ± 1.5% | 794.7 ± 2.8% | 17.684 | 28.458 | 78.367 | 35.084 | 37.993 |
| hex: canterbury/plrabn12.txt | 524290 | 29219.7 ± 0.3% | 1703.3 ± 0.9% | 1058.2 ± 4.0% | 376.1 ± 2.3% | 881.6 ± 0.4% | 795.9 ± 2.1% | 17.154 | 27.613 | 77.701 | 33.145 | 36.712 |
| hex: canterbury/ptt5 | 524290 | 29247.6 ± 0.2% | 1708.4 ± 0.4% | 1060.9 ± 0.2% | 491.7 ± 0.3% | 883.0 ± 0.7% | 798.0 ± 2.6% | 17.119 | 27.569 | 59.485 | 33.121 | 36.651 |
| hex: canterbury/sum | 76482 | 28783.1 ± 0.7% | 1723.9 ± 0.3% | 1076.9 ± 1.5% | 453.4 ± 5.9% | 891.0 ± 11.6% | 845.2 ± 2.5% | 16.697 | 26.727 | 63.484 | 32.305 | 34.054 |
| hex: canterbury/xargs.1 | 8456 | 27586.0 ± 11.4% | 1770.0 ± 0.8% | 1085.0 ± 11.4% | 685.3 ± 0.3% | 898.1 ± 0.7% | 854.3 ± 2.0% | 15.585 | 25.424 | 40.252 | 30.715 | 32.289 |
| hex: canterbury-large/E.coli | 524290 | 28589.0 ± 4.1% | 1700.4 ± 0.9% | 1060.5 ± 1.1% | 660.2 ± 4.7% | 883.8 ± 4.8% | 793.8 ± 4.9% | 16.813 | 26.957 | 43.304 | 32.349 | 36.013 |
| hex: canterbury-large/bible.txt | 524290 | 30226.1 ± 0.9% | 1709.2 ± 1.2% | 1060.9 ± 0.4% | 401.5 ± 0.6% | 882.5 ± 0.4% | 798.8 ± 3.8% | 17.685 | 28.492 | 75.285 | 34.250 | 37.839 |
| hex: canterbury-large/world192.txt | 524290 | 29419.7 ± 0.6% | 1697.7 ± 0.2% | 1058.3 ± 0.7% | 379.9 ± 0.7% | 884.5 ± 1.0% | 797.9 ± 3.2% | 17.329 | 27.799 | 77.440 | 33.263 | 36.873 |
| hex: http/html-1kx1024 | 2099200 | 17887.4 ± 1.3% | 1747.7 ± 0.5% | 1067.0 ± 0.7% | 409.0 ± 0.8% | 892.7 ± 1.2% | 823.2 ± 0.8% | 10.235 | 16.764 | 43.735 | 20.038 | 21.730 |
| hex: http/html-16kx64 | 2097280 | 18954.2 ± 0.8% | 1728.6 ± 0.6% | 1071.3 ± 0.3% | 409.5 ± 0.3% | 891.5 ± 12.8% | 845.2 ± 1.6% | 10.965 | 17.693 | 46.283 | 21.262 | 22.425 |
| hex: http/html-1m | 524290 | 29247.2 ± 0.1% | 1692.1 ± 0.1% | 1054.8 ± 0.2% | 387.8 ± 0.6% | 854.0 ± 10.3% | 801.4 ± 0.7% | 17.285 | 27.728 | 75.424 | 34.249 | 36.493 |
| hex: http/json-1kx1024 | 2099200 | 17772.8 ± 7.5% | 1749.7 ± 0.2% | 1067.9 ± 15.3% | 592.3 ± 0.8% | 894.0 ± 0.1% | 823.5 ± 5.2% | 10.157 | 16.643 | 30.005 | 19.879 | 21.582 |
| hex: http/json-16kx64 | 2097280 | 18573.9 ± 0.6% | 1728.9 ± 8.2% | 1062.6 ± 6.3% | 600.9 ± 18.0% | 891.7 ± 4.5% | 841.8 ± 3.5% | 10.743 | 17.480 | 30.909 | 20.829 | 22.063 |
| hex: http/json-1m | 524290 | 29432.5 ± 0.2% | 1704.5 ± 7.4% | 1058.4 ± 6.7% | 620.3 ± 0.6% | 866.1 ± 0.3% | 798.9 ± 2.1% | 17.267 | 27.807 | 47.446 | 33.984 | 36.843 |
| hex: http/js-1kx1024 | 2099200 | 18028.3 ± 0.4% | 1749.3 ± 1.1% | 1067.4 ± 0.3% | 404.5 ± 0.3% | 893.6 ± 0.2% | 820.5 ± 1.0% | 10.306 | 16.890 | 44.564 | 20.175 | 21.972 |
| hex: http/js-16kx64 | 2097280 | 19083.8 ± 0.4% | 1730.1 ± 0.3% | 1071.1 ± 1.0% | 407.3 ± 0.2% | 891.7 ± 0.1% | 841.8 ± 1.6% | 11.030 | 17.817 | 46.857 | 21.402 | 22.669 |
| hex: http/js-1m | 524290 | 29157.7 ± 1.1% | 1704.6 ± 1.4% | 1060.7 ± 1.3% | 417.4 ± 0.2% | 885.5 ± 0.2% | 802.8 ± 3.2% | 17.105 | 27.489 | 69.864 | 32.927 | 36.319 |
| hex: http/css-1kx1024 | 2099200 | 17820.0 ± 0.6% | 1746.3 ± 0.3% | 1067.3 ± 0.3% | 454.3 ± 3.3% | 892.3 ± 4.3% | 820.5 ± 1.9% | 10.204 | 16.696 | 39.222 | 19.971 | 21.719 |
| hex: http/css-16kx64 | 2097280 | 18768.1 ± 0.5% | 1728.6 ± 0.3% | 1070.6 ± 0.1% | 460.2 ± 0.6% | 889.9 ± 2.7% | 834.9 ± 2.1% | 10.857 | 17.531 | 40.779 | 21.091 | 22.480 |
| hex: http/css-1m | 524290 | 29381.9 ± 1.9% | 1708.3 ± 0.2% | 1059.5 ± 1.1% | 434.3 ± 0.5% | 869.4 ± 14.9% | 800.0 ± 2.6% | 17.200 | 27.733 | 67.656 | 33.796 | 36.728 |
| hex: shuffled/dickens-1m | 524290 | 29272.9 ± 0.2% | 1695.5 ± 1.0% | 1058.1 ± 0.4% | 386.4 ± 0.7% | 882.0 ± 7.8% | 796.6 ± 7.7% | 17.265 | 27.666 | 75.757 | 33.191 | 36.748 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1392.8 ± 0.4% | 1125.6 ± 14.7% | 837.8 ± 0.8% | 367.7 ± 0.6% | 358.9 ± 0.7% | 390.6 ± 1.8% | 1.237 | 1.663 | 3.788 | 3.881 | 3.566 |
| qlog records, JSON text sequence | 1467503 | 1107.7 ± 1.2% | 830.8 ± 7.8% | 685.4 ± 6.1% | 323.3 ± 5.1% | 346.1 ± 18.4% | 247.5 ± 6.8% | 1.333 | 1.616 | 3.426 | 3.201 | 4.475 |
| messages: 11 string members | 1025025 | 1032.8 ± 2.2% | 836.5 ± 1.9% | 623.0 ± 4.4% | 318.0 ± 1.9% | 322.5 ± 5.5% | 322.4 ± 2.9% | 1.235 | 1.658 | 3.248 | 3.202 | 3.204 |
| messages: 50 nested objects | 1121600 | 1409.1 ± 5.1% | 1207.8 ± 4.8% | 1015.3 ± 9.3% | 439.8 ± 1.3% | 398.6 ± 8.7% | 396.8 ± 1.6% | 1.167 | 1.388 | 3.204 | 3.535 | 3.551 |
| messages: a tree of 341 objects | 612600 | 521.9 ± 1.3% | 609.3 ± 3.7% | 426.6 ± 2.4% | 227.2 ± 2.2% | 263.5 ± 1.8% | 145.9 ± 0.9% | 0.856 | 1.223 | 2.296 | 1.981 | 3.577 |
| string: silesia/dickens | 172528 | 10089.1 ± 4.2% | 2920.8 ± 2.4% | 2398.6 ± 2.6% | 272.7 ± 1.0% | 1143.0 ± 0.6% | 1027.4 ± 0.1% | 3.454 | 4.206 | 36.999 | 8.827 | 9.820 |
| string: silesia/nci | 1075110 | 8626.3 ± 1.2% | 3165.2 ± 1.1% | 2430.2 ± 1.0% | 790.8 ± 0.9% | 1221.6 ± 0.5% | 1016.5 ± 1.6% | 2.725 | 3.550 | 10.909 | 7.062 | 8.486 |
| string: silesia/reymont | 1075159 | 4591.9 ± 2.4% | 1510.2 ± 1.6% | 1597.7 ± 0.3% | 313.0 ± 0.3% | 1036.1 ± 0.2% | 922.6 ± 0.3% | 3.041 | 2.874 | 14.669 | 4.432 | 4.977 |
| string: silesia/samba | 97582 | 5233.4 ± 0.5% | 1994.5 ± 0.5% | 2782.1 ± 0.9% | 265.8 ± 0.5% | 990.9 ± 0.8% | 1003.6 ± 0.6% | 2.624 | 1.881 | 19.687 | 5.282 | 5.214 |
| string: silesia/webster | 1098490 | 5787.5 ± 0.8% | 1510.2 ± 0.4% | 1504.6 ± 0.7% | 290.7 ± 0.8% | 1010.4 ± 2.2% | 516.7 ± 1.7% | 3.832 | 3.846 | 19.910 | 5.728 | 11.201 |
| string: silesia/xml | 1090118 | 8302.7 ± 4.6% | 2378.9 ± 9.7% | 2026.0 ± 0.8% | 499.3 ± 1.2% | 1192.1 ± 2.7% | 809.6 ± 0.9% | 3.490 | 4.098 | 16.628 | 6.965 | 10.255 |
| string: canterbury/alice29.txt | 159425 | 9477.6 ± 0.6% | 2197.9 ± 0.9% | 2222.9 ± 0.3% | 262.0 ± 2.7% | 1092.9 ± 8.2% | 930.0 ± 0.8% | 4.312 | 4.264 | 36.170 | 8.672 | 10.191 |
| string: canterbury/asyoulik.txt | 132198 | 8348.6 ± 0.4% | 1641.0 ± 0.3% | 2240.1 ± 1.2% | 260.8 ± 2.0% | 969.8 ± 2.0% | 825.6 ± 9.0% | 5.088 | 3.727 | 32.011 | 8.609 | 10.112 |
| string: canterbury/lcet10.txt | 441884 | 9285.6 ± 1.1% | 2352.0 ± 6.7% | 2069.0 ± 0.5% | 307.3 ± 0.6% | 1096.4 ± 11.8% | 990.9 ± 1.3% | 3.948 | 4.488 | 30.219 | 8.469 | 9.371 |
| string: canterbury/plrabn12.txt | 503330 | 7008.7 ± 1.6% | 1737.1 ± 0.5% | 1738.4 ± 2.0% | 279.6 ± 1.8% | 1051.3 ± 0.9% | 897.8 ± 12.9% | 4.035 | 4.032 | 25.066 | 6.667 | 7.807 |
| string: canterbury-large/E.coli | 1048578 | 15143.8 ± 0.9% | 8757.7 ± 0.3% | 2598.1 ± 0.2% | 1491.3 ± 0.6% | 1494.3 ± 0.2% | 1078.4 ± 1.0% | 1.729 | 5.829 | 10.155 | 10.134 | 14.042 |
| string: canterbury-large/bible.txt | 1055886 | 8587.7 ± 0.7% | 3686.2 ± 0.2% | 2314.9 ± 1.4% | 330.8 ± 0.8% | 1306.2 ± 0.7% | 1164.9 ± 0.3% | 2.330 | 3.710 | 25.962 | 6.575 | 7.372 |
| string: canterbury-large/world192.txt | 1103121 | 5496.3 ± 2.4% | 1316.3 ± 0.5% | 1599.5 ± 1.9% | 286.3 ± 2.3% | 990.1 ± 4.3% | 839.4 ± 4.8% | 4.176 | 3.436 | 19.199 | 5.551 | 6.548 |
| string: http/html-1m | 1058582 | 8445.5 ± 0.9% | 3371.3 ± 0.6% | 2254.4 ± 0.5% | 339.6 ± 3.3% | 1278.1 ± 1.9% | 711.7 ± 2.2% | 2.505 | 3.746 | 24.871 | 6.608 | 11.866 |
| string: http/json-1m | 1190272 | 6585.4 ± 0.2% | 1157.7 ± 0.4% | 1357.0 ± 0.3% | 435.0 ± 0.5% | 766.1 ± 1.0% | 689.2 ± 1.1% | 5.688 | 4.853 | 15.137 | 8.596 | 9.555 |
| string: http/js-1m | 1144362 | 5518.5 ± 0.5% | 877.7 ± 0.7% | 1191.0 ± 0.3% | 262.0 ± 3.1% | 824.0 ± 0.8% | 664.0 ± 0.4% | 6.287 | 4.634 | 21.066 | 6.697 | 8.312 |
| string: http/css-1m | 1097820 | 7563.9 ± 12.1% | 1141.3 ± 0.9% | 1731.7 ± 0.5% | 396.0 ± 5.6% | 932.6 ± 0.7% | 813.8 ± 1.2% | 6.627 | 4.368 | 19.100 | 8.111 | 9.294 |
| string: dickens as Cyrillic and CJK | 1883069 | 4461.8 ± 0.6% | 2879.0 ± 0.5% | 419.8 ± 0.4% | 209.5 ± 2.0% | 374.0 ± 0.4% | 277.7 ± 6.4% | 1.550 | 10.628 | 21.293 | 11.931 | 16.064 |
| hex: silesia/dickens | 524290 | 28771.2 ± 0.3% | 1702.7 ± 0.2% | 1055.2 ± 0.8% | 385.5 ± 0.1% | 884.2 ± 7.9% | 791.0 ± 7.1% | 16.898 | 27.267 | 74.634 | 32.539 | 36.374 |
| hex: silesia/mozilla | 524290 | 29063.0 ± 1.0% | 1697.8 ± 5.3% | 1061.0 ± 4.4% | 325.0 ± 3.5% | 872.1 ± 4.9% | 802.0 ± 3.0% | 17.118 | 27.393 | 89.411 | 33.327 | 36.237 |
| hex: silesia/mr | 524290 | 29314.6 ± 0.3% | 1706.5 ± 0.5% | 1061.8 ± 0.1% | 487.8 ± 7.6% | 882.6 ± 2.7% | 798.8 ± 2.3% | 17.178 | 27.608 | 60.090 | 33.213 | 36.700 |
| hex: silesia/nci | 524290 | 30267.3 ± 1.4% | 1710.2 ± 1.1% | 1059.1 ± 0.2% | 656.5 ± 0.4% | 883.4 ± 10.9% | 800.5 ± 3.3% | 17.698 | 28.579 | 46.105 | 34.263 | 37.811 |
| hex: silesia/ooffice | 524290 | 29460.3 ± 0.3% | 1711.2 ± 1.1% | 1062.0 ± 0.1% | 267.5 ± 1.2% | 883.5 ± 0.5% | 795.2 ± 3.2% | 17.216 | 27.740 | 110.119 | 33.347 | 37.046 |
| hex: silesia/osdb | 524290 | 28840.5 ± 0.3% | 1710.8 ± 0.3% | 1059.4 ± 0.2% | 362.1 ± 1.5% | 882.8 ± 10.6% | 795.4 ± 1.5% | 16.858 | 27.224 | 79.647 | 32.668 | 36.261 |
| hex: silesia/reymont | 524290 | 29521.6 ± 0.2% | 1707.1 ± 1.2% | 1059.1 ± 0.6% | 406.7 ± 0.4% | 881.1 ± 1.0% | 799.4 ± 1.9% | 17.294 | 27.874 | 72.580 | 33.507 | 36.930 |
| hex: silesia/samba | 524290 | 29689.6 ± 1.0% | 1707.5 ± 0.4% | 1060.6 ± 0.3% | 288.2 ± 0.7% | 882.5 ± 0.4% | 795.3 ± 4.8% | 17.387 | 27.992 | 103.031 | 33.641 | 37.332 |
| hex: silesia/sao | 524290 | 29208.8 ± 0.2% | 1702.3 ± 0.9% | 1059.6 ± 0.2% | 217.1 ± 0.6% | 876.5 ± 0.2% | 794.2 ± 2.9% | 17.158 | 27.565 | 134.541 | 33.323 | 36.779 |
| hex: silesia/webster | 524290 | 31195.7 ± 0.3% | 1705.9 ± 1.1% | 1059.9 ± 9.5% | 351.1 ± 0.4% | 882.5 ± 0.3% | 795.6 ± 1.6% | 18.287 | 29.432 | 88.847 | 35.351 | 39.208 |
| hex: silesia/x-ray | 524290 | 29228.8 ± 0.2% | 1706.6 ± 0.9% | 1059.5 ± 0.6% | 342.4 ± 1.1% | 882.8 ± 0.2% | 794.0 ± 0.7% | 17.127 | 27.588 | 85.363 | 33.110 | 36.813 |
| hex: silesia/xml | 524290 | 30269.3 ± 0.1% | 1708.5 ± 10.8% | 1061.5 ± 0.3% | 584.6 ± 0.6% | 884.4 ± 7.3% | 815.3 ± 3.1% | 17.717 | 28.515 | 51.781 | 34.226 | 37.125 |
| hex: canterbury/alice29.txt | 304180 | 28789.8 ± 0.4% | 1701.5 ± 0.1% | 1073.6 ± 0.2% | 389.4 ± 0.3% | 890.0 ± 0.6% | 834.9 ± 0.7% | 16.920 | 26.817 | 73.930 | 32.348 | 34.482 |
| hex: canterbury/asyoulik.txt | 250360 | 29192.8 ± 0.8% | 1724.2 ± 0.7% | 1082.8 ± 0.3% | 380.5 ± 0.2% | 890.1 ± 0.3% | 825.7 ± 2.3% | 16.931 | 26.960 | 76.724 | 32.798 | 35.354 |
| hex: canterbury/cp.html | 49208 | 28586.3 ± 0.7% | 1721.1 ± 0.2% | 1075.0 ± 15.4% | 385.5 ± 0.6% | 890.5 ± 1.3% | 845.0 ± 1.5% | 16.609 | 26.592 | 74.159 | 32.100 | 33.832 |
| hex: canterbury/fields.c | 22302 | 29342.5 ± 1.0% | 1722.3 ± 0.3% | 1077.6 ± 1.8% | 597.3 ± 0.9% | 892.8 ± 0.3% | 835.9 ± 5.0% | 17.037 | 27.230 | 49.122 | 32.865 | 35.102 |
| hex: canterbury/grammar.lsp | 7444 | 27531.1 ± 0.4% | 1773.3 ± 0.7% | 1091.6 ± 0.8% | 676.5 ± 1.6% | 900.6 ± 0.6% | 838.4 ± 3.3% | 15.525 | 25.221 | 40.699 | 30.570 | 32.837 |
| hex: canterbury/kennedy.xls | 524290 | 29443.5 ± 0.4% | 1708.6 ± 0.3% | 1060.7 ± 1.5% | 646.7 ± 0.3% | 882.8 ± 0.4% | 797.6 ± 1.3% | 17.233 | 27.758 | 45.531 | 33.351 | 36.916 |
| hex: canterbury/lcet10.txt | 524290 | 30268.0 ± 0.6% | 1707.4 ± 13.6% | 1061.0 ± 0.3% | 385.3 ± 0.5% | 860.6 ± 1.5% | 794.7 ± 2.8% | 17.727 | 28.528 | 78.560 | 35.171 | 38.087 |
| hex: canterbury/plrabn12.txt | 524290 | 29224.5 ± 0.6% | 1703.3 ± 0.9% | 1058.2 ± 4.0% | 376.1 ± 2.3% | 881.6 ± 0.4% | 795.9 ± 2.1% | 17.157 | 27.617 | 77.714 | 33.150 | 36.719 |
| hex: canterbury/ptt5 | 524290 | 29273.7 ± 0.2% | 1708.4 ± 0.4% | 1060.9 ± 0.2% | 491.7 ± 0.3% | 883.0 ± 0.7% | 798.0 ± 2.6% | 17.135 | 27.594 | 59.538 | 33.151 | 36.683 |
| hex: canterbury/sum | 76482 | 28837.8 ± 0.8% | 1723.9 ± 0.3% | 1076.9 ± 1.5% | 453.4 ± 5.9% | 891.0 ± 11.6% | 845.2 ± 2.5% | 16.729 | 26.778 | 63.605 | 32.367 | 34.119 |
| hex: canterbury/xargs.1 | 8456 | 27721.6 ± 9.2% | 1770.0 ± 0.8% | 1085.0 ± 11.4% | 685.3 ± 0.3% | 898.1 ± 0.7% | 854.3 ± 2.0% | 15.662 | 25.549 | 40.450 | 30.866 | 32.448 |
| hex: canterbury-large/E.coli | 524290 | 28762.2 ± 0.2% | 1700.4 ± 0.9% | 1060.5 ± 1.1% | 660.2 ± 4.7% | 883.8 ± 4.8% | 793.8 ± 4.9% | 16.915 | 27.120 | 43.567 | 32.545 | 36.232 |
| hex: canterbury-large/bible.txt | 524290 | 30297.4 ± 0.2% | 1709.2 ± 1.2% | 1060.9 ± 0.4% | 401.5 ± 0.6% | 882.5 ± 0.4% | 798.8 ± 3.8% | 17.726 | 28.559 | 75.463 | 34.330 | 37.928 |
| hex: canterbury-large/world192.txt | 524290 | 29466.6 ± 0.2% | 1697.7 ± 0.2% | 1058.3 ± 0.7% | 379.9 ± 0.7% | 884.5 ± 1.0% | 797.9 ± 3.2% | 17.357 | 27.843 | 77.564 | 33.316 | 36.931 |
| hex: http/html-1kx1024 | 2099200 | 18197.7 ± 0.5% | 1747.7 ± 0.5% | 1067.0 ± 0.7% | 409.0 ± 0.8% | 892.7 ± 1.2% | 823.2 ± 0.8% | 10.412 | 17.054 | 44.494 | 20.385 | 22.107 |
| hex: http/html-16kx64 | 2097280 | 19085.7 ± 0.4% | 1728.6 ± 0.6% | 1071.3 ± 0.3% | 409.5 ± 0.3% | 891.5 ± 12.8% | 845.2 ± 1.6% | 11.041 | 17.816 | 46.604 | 21.410 | 22.581 |
| hex: http/html-1m | 524290 | 29251.9 ± 0.1% | 1692.1 ± 0.1% | 1054.8 ± 0.2% | 387.8 ± 0.6% | 854.0 ± 10.3% | 801.4 ± 0.7% | 17.288 | 27.732 | 75.436 | 34.254 | 36.499 |
| hex: http/json-1kx1024 | 2099200 | 17929.3 ± 0.3% | 1749.7 ± 0.2% | 1067.9 ± 15.3% | 592.3 ± 0.8% | 894.0 ± 0.1% | 823.5 ± 5.2% | 10.247 | 16.790 | 30.269 | 20.055 | 21.772 |
| hex: http/json-16kx64 | 2097280 | 18626.5 ± 4.0% | 1728.9 ± 8.2% | 1062.6 ± 6.3% | 600.9 ± 18.0% | 891.7 ± 4.5% | 841.8 ± 3.5% | 10.773 | 17.529 | 30.997 | 20.888 | 22.126 |
| hex: http/json-1m | 524290 | 29458.8 ± 1.0% | 1704.5 ± 7.4% | 1058.4 ± 6.7% | 620.3 ± 0.6% | 866.1 ± 0.3% | 798.9 ± 2.1% | 17.283 | 27.832 | 47.489 | 34.014 | 36.876 |
| hex: http/js-1kx1024 | 2099200 | 18206.8 ± 1.0% | 1749.3 ± 1.1% | 1067.4 ± 0.3% | 404.5 ± 0.3% | 893.6 ± 0.2% | 820.5 ± 1.0% | 10.408 | 17.058 | 45.005 | 20.375 | 22.190 |
| hex: http/js-16kx64 | 2097280 | 19100.6 ± 0.7% | 1730.1 ± 0.3% | 1071.1 ± 1.0% | 407.3 ± 0.2% | 891.7 ± 0.1% | 841.8 ± 1.6% | 11.040 | 17.832 | 46.898 | 21.421 | 22.689 |
| hex: http/js-1m | 524290 | 29195.2 ± 0.9% | 1704.6 ± 1.4% | 1060.7 ± 1.3% | 417.4 ± 0.2% | 885.5 ± 0.2% | 802.8 ± 3.2% | 17.127 | 27.524 | 69.953 | 32.969 | 36.366 |
| hex: http/css-1kx1024 | 2099200 | 17938.7 ± 1.6% | 1746.3 ± 0.3% | 1067.3 ± 0.3% | 454.3 ± 3.3% | 892.3 ± 4.3% | 820.5 ± 1.9% | 10.272 | 16.808 | 39.484 | 20.104 | 21.863 |
| hex: http/css-16kx64 | 2097280 | 18881.2 ± 1.2% | 1728.6 ± 0.3% | 1070.6 ± 0.1% | 460.2 ± 0.6% | 889.9 ± 2.7% | 834.9 ± 2.1% | 10.923 | 17.636 | 41.024 | 21.218 | 22.615 |
| hex: http/css-1m | 524290 | 29449.0 ± 0.3% | 1708.3 ± 0.2% | 1059.5 ± 1.1% | 434.3 ± 0.5% | 869.4 ± 14.9% | 800.0 ± 2.6% | 17.239 | 27.796 | 67.811 | 33.873 | 36.812 |
| hex: shuffled/dickens-1m | 524290 | 29303.6 ± 0.3% | 1695.5 ± 1.0% | 1058.1 ± 0.4% | 386.4 ± 0.7% | 882.0 ± 7.8% | 796.6 ± 7.7% | 17.284 | 27.695 | 75.837 | 33.226 | 36.787 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 891.3 ± 1.2% | 1064.8 ± 0.7% | 856.9 ± 0.4% | 322.7 ± 0.6% | 527.6 ± 8.8% | 293.9 ± 13.9% | 0.837 | 1.040 | 2.762 | 1.689 | 3.032 |
| qlog records, JSON text sequence | 1467503 | 652.2 ± 0.9% | 936.7 ± 2.9% | 828.6 ± 0.8% | 268.1 ± 8.0% | 598.4 ± 1.4% | 253.9 ± 3.3% | 0.696 | 0.787 | 2.433 | 1.090 | 2.569 |
| messages: 11 string members | 1025025 | 745.9 ± 0.7% | 1187.5 ± 0.4% | 579.9 ± 0.8% | 278.0 ± 0.9% | 418.2 ± 4.0% | 244.0 ± 0.9% | 0.628 | 1.286 | 2.683 | 1.784 | 3.056 |
| messages: 50 nested objects | 1121600 | 948.8 ± 0.3% | 1034.4 ± 1.2% | 962.8 ± 0.4% | 346.6 ± 0.4% | 647.1 ± 0.5% | 329.1 ± 5.2% | 0.917 | 0.985 | 2.737 | 1.466 | 2.883 |
| messages: a tree of 341 objects | 612600 | 377.5 ± 0.4% | 630.9 ± 0.3% | 468.9 ± 0.7% | 155.1 ± 11.9% | 481.6 ± 0.6% | 156.6 ± 2.8% | 0.598 | 0.805 | 2.433 | 0.784 | 2.410 |
| string: silesia/dickens | 172528 | 5900.8 ± 5.2% | 2897.3 ± 1.1% | 2399.3 ± 1.8% | 264.2 ± 4.1% | 2197.1 ± 1.8% | 503.9 ± 6.2% | 2.037 | 2.459 | 22.331 | 2.686 | 11.711 |
| string: silesia/nci | 1075110 | 5032.0 ± 1.5% | 3213.0 ± 2.2% | 2240.1 ± 0.5% | 562.9 ± 1.7% | 2377.3 ± 0.6% | 531.0 ± 1.6% | 1.566 | 2.246 | 8.939 | 2.117 | 9.477 |
| string: silesia/reymont | 1075159 | 3162.3 ± 3.9% | 2556.7 ± 0.6% | 1551.0 ± 0.4% | 283.4 ± 0.5% | 1604.8 ± 0.3% | 456.8 ± 0.9% | 1.237 | 2.039 | 11.157 | 1.970 | 6.922 |
| string: silesia/samba | 97582 | 2774.1 ± 0.7% | 2832.1 ± 1.8% | 2184.0 ± 1.2% | 274.1 ± 0.2% | 1329.8 ± 1.0% | 352.5 ± 10.4% | 0.980 | 1.270 | 10.119 | 2.086 | 7.871 |
| string: silesia/webster | 1098490 | 3796.3 ± 1.6% | 1998.0 ± 0.4% | 1436.1 ± 0.2% | 256.7 ± 0.7% | 1579.8 ± 1.3% | 416.9 ± 0.9% | 1.900 | 2.644 | 14.788 | 2.403 | 9.106 |
| string: silesia/xml | 1090118 | 4690.6 ± 0.5% | 3576.6 ± 0.2% | 1853.3 ± 0.6% | 420.7 ± 5.5% | 2272.0 ± 0.7% | 499.0 ± 0.7% | 1.311 | 2.531 | 11.150 | 2.065 | 9.401 |
| string: canterbury/alice29.txt | 159425 | 5182.5 ± 0.7% | 2453.6 ± 0.6% | 2351.3 ± 1.6% | 246.7 ± 0.8% | 1993.7 ± 2.5% | 453.3 ± 2.2% | 2.112 | 2.204 | 21.011 | 2.599 | 11.433 |
| string: canterbury/asyoulik.txt | 132198 | 3443.5 ± 0.4% | 1955.7 ± 1.5% | 2112.8 ± 0.2% | 250.5 ± 5.9% | 1639.6 ± 1.8% | 396.4 ± 2.2% | 1.761 | 1.630 | 13.747 | 2.100 | 8.688 |
| string: canterbury/lcet10.txt | 441884 | 5975.0 ± 1.0% | 2728.5 ± 1.1% | 1820.5 ± 0.5% | 289.5 ± 0.3% | 2071.5 ± 1.0% | 475.6 ± 1.7% | 2.190 | 3.282 | 20.642 | 2.884 | 12.562 |
| string: canterbury/plrabn12.txt | 503330 | 3976.0 ± 1.4% | 2338.8 ± 0.6% | 1524.4 ± 4.8% | 267.7 ± 0.4% | 2027.4 ± 0.6% | 435.1 ± 1.3% | 1.700 | 2.608 | 14.850 | 1.961 | 9.138 |
| string: canterbury-large/E.coli | 1048578 | 23798.4 ± 0.2% | 7688.3 ± 1.1% | 2777.5 ± 12.5% | 985.7 ± 0.6% | 5206.8 ± 0.2% | 907.1 ± 0.6% | 3.095 | 8.568 | 24.143 | 4.571 | 26.235 |
| string: canterbury-large/bible.txt | 1055886 | 8348.8 ± 8.7% | 4570.7 ± 14.7% | 2079.3 ± 2.0% | 305.0 ± 2.8% | 3018.8 ± 5.4% | 570.1 ± 11.9% | 1.827 | 4.015 | 27.370 | 2.766 | 14.645 |
| string: canterbury-large/world192.txt | 1103121 | 3599.2 ± 3.8% | 1886.5 ± 1.2% | 1458.9 ± 0.3% | 268.8 ± 0.3% | 1621.1 ± 6.7% | 421.7 ± 1.1% | 1.908 | 2.467 | 13.392 | 2.220 | 8.535 |
| string: http/html-1m | 1058582 | 7846.9 ± 10.3% | 3941.5 ± 0.5% | 2031.2 ± 2.9% | 351.8 ± 0.2% | 2763.7 ± 1.5% | 562.7 ± 1.3% | 1.991 | 3.863 | 22.305 | 2.839 | 13.945 |
| string: http/json-1m | 1190272 | 2850.7 ± 0.4% | 1057.6 ± 1.2% | 1688.1 ± 1.7% | 382.8 ± 0.6% | 841.8 ± 3.3% | 361.7 ± 2.5% | 2.695 | 1.689 | 7.447 | 3.386 | 7.882 |
| string: http/js-1m | 1144362 | 2524.2 ± 0.5% | 1399.8 ± 0.3% | 1130.7 ± 0.9% | 263.1 ± 0.3% | 1097.9 ± 0.5% | 333.5 ± 1.9% | 1.803 | 2.232 | 9.595 | 2.299 | 7.568 |
| string: http/css-1m | 1097820 | 2748.0 ± 0.6% | 2179.2 ± 2.3% | 1640.8 ± 0.6% | 369.6 ± 0.3% | 1446.8 ± 0.2% | 403.4 ± 1.1% | 1.261 | 1.675 | 7.435 | 1.899 | 6.812 |
| string: dickens as Cyrillic and CJK | 1883069 | 4722.3 ± 2.4% | 3239.0 ± 0.7% | 612.3 ± 3.6% | 283.0 ± 1.4% | 443.0 ± 0.2% | 128.4 ± 2.0% | 1.458 | 7.712 | 16.685 | 10.660 | 36.767 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 907.3 ± 3.3% | 1009.9 ± 6.0% | 908.9 ± 5.3% | 194.7 ± 0.8% | 370.7 ± 0.6% | 184.1 ± 4.9% | 0.898 | 0.998 | 4.660 | 2.448 | 4.928 |
| hex: silesia/dickens | 524290 | 24298.2 ± 4.7% | 10686.7 ± 0.4% | 3037.8 ± 0.4% | 398.9 ± 3.6% | 5224.7 ± 0.3% | 942.4 ± 2.8% | 2.274 | 7.999 | 60.918 | 4.651 | 25.782 |
| hex: silesia/mozilla | 524290 | 24277.9 ± 0.2% | 10700.2 ± 0.2% | 2964.1 ± 0.1% | 342.4 ± 1.7% | 5226.1 ± 0.2% | 937.8 ± 0.6% | 2.269 | 8.191 | 70.903 | 4.646 | 25.888 |
| hex: silesia/mr | 524290 | 24289.9 ± 0.4% | 10697.6 ± 0.3% | 2964.2 ± 0.4% | 518.9 ± 0.9% | 5219.8 ± 1.6% | 937.2 ± 2.0% | 2.271 | 8.195 | 46.808 | 4.653 | 25.917 |
| hex: silesia/nci | 524290 | 24268.1 ± 0.3% | 10690.5 ± 0.4% | 3065.2 ± 1.0% | 660.2 ± 0.1% | 5215.9 ± 0.3% | 932.8 ± 1.1% | 2.270 | 7.917 | 36.760 | 4.653 | 26.016 |
| hex: silesia/ooffice | 524290 | 24281.5 ± 0.4% | 10698.4 ± 0.2% | 2997.7 ± 0.5% | 282.2 ± 1.5% | 5217.8 ± 0.5% | 935.1 ± 1.6% | 2.270 | 8.100 | 86.054 | 4.654 | 25.966 |
| hex: silesia/osdb | 524290 | 24299.1 ± 0.4% | 10680.8 ± 1.0% | 2999.4 ± 0.4% | 388.1 ± 3.5% | 5223.0 ± 0.4% | 936.8 ± 1.8% | 2.275 | 8.101 | 62.603 | 4.652 | 25.940 |
| hex: silesia/reymont | 524290 | 24281.5 ± 0.3% | 10684.1 ± 8.5% | 3062.2 ± 16.6% | 434.9 ± 4.5% | 5225.8 ± 0.2% | 931.8 ± 1.2% | 2.273 | 7.929 | 55.838 | 4.646 | 26.059 |
| hex: silesia/samba | 524290 | 24270.3 ± 0.5% | 10679.7 ± 0.3% | 2978.8 ± 0.2% | 300.1 ± 0.3% | 5224.8 ± 0.4% | 936.7 ± 1.7% | 2.273 | 8.148 | 80.886 | 4.645 | 25.911 |
| hex: silesia/sao | 524290 | 24273.7 ± 1.3% | 10702.5 ± 0.3% | 3003.1 ± 0.5% | 224.7 ± 3.2% | 5226.3 ± 9.7% | 932.2 ± 15.5% | 2.268 | 8.083 | 108.017 | 4.644 | 26.040 |
| hex: silesia/webster | 524290 | 24311.6 ± 0.2% | 10674.7 ± 0.4% | 3063.3 ± 0.6% | 382.7 ± 2.8% | 5226.1 ± 0.2% | 931.9 ± 1.4% | 2.278 | 7.936 | 63.531 | 4.652 | 26.089 |
| hex: silesia/x-ray | 524290 | 24277.8 ± 0.3% | 10688.2 ± 0.3% | 3006.9 ± 0.2% | 369.4 ± 2.9% | 5227.7 ± 0.2% | 928.8 ± 0.7% | 2.271 | 8.074 | 65.714 | 4.644 | 26.139 |
| hex: silesia/xml | 524290 | 24250.3 ± 4.5% | 10687.2 ± 0.4% | 3012.2 ± 0.1% | 642.7 ± 1.0% | 5217.7 ± 0.3% | 925.3 ± 2.8% | 2.269 | 8.051 | 37.732 | 4.648 | 26.209 |
| hex: canterbury/alice29.txt | 304180 | 24185.5 ± 0.3% | 11008.1 ± 0.1% | 3003.0 ± 0.2% | 403.4 ± 3.0% | 5217.8 ± 0.5% | 951.6 ± 1.6% | 2.197 | 8.054 | 59.956 | 4.635 | 25.415 |
| hex: canterbury/asyoulik.txt | 250360 | 24182.4 ± 0.2% | 10478.8 ± 0.2% | 2982.5 ± 0.2% | 394.7 ± 3.2% | 5225.6 ± 0.1% | 950.7 ± 0.9% | 2.308 | 8.108 | 61.275 | 4.628 | 25.436 |
| hex: canterbury/cp.html | 49208 | 23759.6 ± 0.2% | 11265.3 ± 1.8% | 3075.9 ± 2.1% | 435.7 ± 1.8% | 5202.9 ± 0.4% | 930.9 ± 1.2% | 2.109 | 7.724 | 54.535 | 4.567 | 25.524 |
| hex: canterbury/fields.c | 22302 | 23530.6 ± 0.4% | 12116.3 ± 0.5% | 3134.5 ± 0.2% | 513.9 ± 0.7% | 5197.2 ± 0.5% | 923.2 ± 2.7% | 1.942 | 7.507 | 45.792 | 4.528 | 25.488 |
| hex: canterbury/grammar.lsp | 7444 | 21341.0 ± 0.8% | 11787.0 ± 0.2% | 3102.1 ± 0.7% | 673.4 ± 2.7% | 5107.7 ± 0.5% | 882.5 ± 2.6% | 1.811 | 6.880 | 31.689 | 4.178 | 24.182 |
| hex: canterbury/kennedy.xls | 524290 | 24296.0 ± 0.3% | 9710.6 ± 0.4% | 3043.4 ± 0.5% | 676.6 ± 0.3% | 5226.8 ± 0.3% | 934.6 ± 1.2% | 2.502 | 7.983 | 35.907 | 4.648 | 25.996 |
| hex: canterbury/lcet10.txt | 524290 | 24303.7 ± 0.2% | 9906.0 ± 0.2% | 3049.9 ± 0.3% | 407.9 ± 3.8% | 5227.1 ± 0.2% | 942.8 ± 1.1% | 2.453 | 7.969 | 59.577 | 4.650 | 25.779 |
| hex: canterbury/plrabn12.txt | 524290 | 24271.6 ± 0.4% | 9864.0 ± 1.4% | 3038.8 ± 0.1% | 390.1 ± 3.4% | 5219.1 ± 0.3% | 936.6 ± 1.2% | 2.461 | 7.987 | 62.215 | 4.651 | 25.915 |
| hex: canterbury/ptt5 | 524290 | 24246.7 ± 4.8% | 9909.1 ± 15.0% | 2938.8 ± 0.3% | 520.1 ± 1.0% | 5222.3 ± 0.2% | 936.8 ± 1.3% | 2.447 | 8.250 | 46.615 | 4.643 | 25.883 |
| hex: canterbury/sum | 76482 | 23826.2 ± 5.8% | 10733.5 ± 1.6% | 3062.6 ± 0.3% | 493.5 ± 3.0% | 5212.8 ± 0.6% | 934.2 ± 2.4% | 2.220 | 7.780 | 48.277 | 4.571 | 25.505 |
| hex: canterbury/xargs.1 | 8456 | 21715.7 ± 0.4% | 11846.5 ± 12.5% | 3035.1 ± 0.1% | 663.0 ± 1.5% | 5115.2 ± 0.3% | 908.3 ± 2.4% | 1.833 | 7.155 | 32.752 | 4.245 | 23.909 |
| hex: canterbury-large/E.coli | 524290 | 24278.0 ± 0.3% | 9850.5 ± 0.5% | 2986.3 ± 0.5% | 693.6 ± 0.5% | 5211.8 ± 0.3% | 931.8 ± 1.8% | 2.465 | 8.130 | 35.004 | 4.658 | 26.056 |
| hex: canterbury-large/bible.txt | 524290 | 24300.2 ± 6.7% | 9803.4 ± 7.7% | 3013.6 ± 1.1% | 428.7 ± 3.0% | 5224.8 ± 0.4% | 935.6 ± 0.7% | 2.479 | 8.063 | 56.689 | 4.651 | 25.974 |
| hex: canterbury-large/world192.txt | 524290 | 24276.2 ± 0.3% | 9835.4 ± 1.0% | 3074.3 ± 0.2% | 397.5 ± 3.3% | 5228.2 ± 1.9% | 938.6 ± 1.4% | 2.468 | 7.897 | 61.076 | 4.643 | 25.863 |
| hex: http/html-1kx1024 | 2099200 | 13265.0 ± 0.3% | 8747.6 ± 0.2% | 2781.2 ± 0.4% | 438.9 ± 3.2% | 4626.6 ± 0.8% | 779.7 ± 2.0% | 1.516 | 4.770 | 30.224 | 2.867 | 17.012 |
| hex: http/html-16kx64 | 2097280 | 21567.3 ± 0.2% | 11280.5 ± 0.9% | 2901.8 ± 0.3% | 432.9 ± 3.4% | 5190.1 ± 0.3% | 879.5 ± 2.6% | 1.912 | 7.432 | 49.817 | 4.156 | 24.523 |
| hex: http/html-1m | 524290 | 24271.5 ± 0.3% | 10014.9 ± 4.3% | 2951.0 ± 4.4% | 432.3 ± 4.3% | 5219.7 ± 1.7% | 925.6 ± 2.2% | 2.424 | 8.225 | 56.148 | 4.650 | 26.222 |
| hex: http/json-1kx1024 | 2099200 | 13256.4 ± 0.7% | 8750.2 ± 0.6% | 2779.8 ± 0.3% | 623.6 ± 1.7% | 4634.3 ± 0.5% | 779.7 ± 2.4% | 1.515 | 4.769 | 21.259 | 2.861 | 17.002 |
| hex: http/json-16kx64 | 2097280 | 21677.0 ± 3.0% | 11300.4 ± 0.4% | 2908.3 ± 0.4% | 640.5 ± 0.7% | 5185.2 ± 1.1% | 875.7 ± 3.4% | 1.918 | 7.453 | 33.843 | 4.181 | 24.753 |
| hex: http/json-1m | 524290 | 24291.1 ± 0.2% | 10357.8 ± 1.4% | 3075.0 ± 0.2% | 675.4 ± 0.4% | 5221.9 ± 0.3% | 932.1 ± 2.3% | 2.345 | 7.899 | 35.968 | 4.652 | 26.061 |
| hex: http/js-1kx1024 | 2099200 | 13293.1 ± 0.2% | 8731.4 ± 0.3% | 2783.6 ± 0.6% | 429.3 ± 3.1% | 4629.4 ± 0.8% | 783.0 ± 2.6% | 1.522 | 4.775 | 30.965 | 2.871 | 16.978 |
| hex: http/js-16kx64 | 2097280 | 21555.5 ± 0.9% | 11287.5 ± 0.4% | 2911.1 ± 0.2% | 431.8 ± 3.0% | 5196.0 ± 0.5% | 888.9 ± 0.9% | 1.910 | 7.405 | 49.918 | 4.148 | 24.248 |
| hex: http/js-1m | 524290 | 24248.4 ± 0.4% | 10391.3 ± 0.4% | 3063.9 ± 0.5% | 442.2 ± 2.7% | 5217.8 ± 1.0% | 925.9 ± 2.1% | 2.334 | 7.914 | 54.831 | 4.647 | 26.188 |
| hex: http/css-1kx1024 | 2099200 | 13258.5 ± 0.3% | 8735.8 ± 2.2% | 2777.7 ± 7.7% | 486.2 ± 2.2% | 4628.4 ± 0.8% | 768.7 ± 8.9% | 1.518 | 4.773 | 27.271 | 2.865 | 17.247 |
| hex: http/css-16kx64 | 2097280 | 21668.0 ± 0.2% | 11309.1 ± 0.2% | 2900.1 ± 0.2% | 495.7 ± 2.5% | 5189.9 ± 0.2% | 881.6 ± 0.6% | 1.916 | 7.472 | 43.708 | 4.175 | 24.578 |
| hex: http/css-1m | 524290 | 24272.1 ± 0.4% | 10286.8 ± 0.2% | 3070.8 ± 6.7% | 473.6 ± 2.6% | 5226.3 ± 0.4% | 935.8 ± 0.9% | 2.360 | 7.904 | 51.249 | 4.644 | 25.939 |
| hex: shuffled/dickens-1m | 524290 | 24292.8 ± 0.3% | 10292.2 ± 1.5% | 3006.7 ± 0.5% | 398.8 ± 3.8% | 5220.7 ± 0.4% | 926.9 ± 0.9% | 2.360 | 8.080 | 60.921 | 4.653 | 26.210 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 999.0 ± 0.8% | 1064.8 ± 0.7% | 856.9 ± 0.4% | 322.7 ± 0.6% | 527.6 ± 8.8% | 293.9 ± 13.9% | 0.938 | 1.166 | 3.095 | 1.893 | 3.399 |
| qlog records, JSON text sequence | 1467503 | 743.3 ± 1.4% | 936.7 ± 2.9% | 828.6 ± 0.8% | 268.1 ± 8.0% | 598.4 ± 1.4% | 253.9 ± 3.3% | 0.793 | 0.897 | 2.773 | 1.242 | 2.928 |
| messages: 11 string members | 1025025 | 798.8 ± 0.6% | 1187.5 ± 0.4% | 579.9 ± 0.8% | 278.0 ± 0.9% | 418.2 ± 4.0% | 244.0 ± 0.9% | 0.673 | 1.378 | 2.873 | 1.910 | 3.273 |
| messages: 50 nested objects | 1121600 | 1067.3 ± 0.3% | 1034.4 ± 1.2% | 962.8 ± 0.4% | 346.6 ± 0.4% | 647.1 ± 0.5% | 329.1 ± 5.2% | 1.032 | 1.109 | 3.079 | 1.649 | 3.243 |
| messages: a tree of 341 objects | 612600 | 488.7 ± 0.9% | 630.9 ± 0.3% | 468.9 ± 0.7% | 155.1 ± 11.9% | 481.6 ± 0.6% | 156.6 ± 2.8% | 0.775 | 1.042 | 3.150 | 1.015 | 3.120 |
| string: silesia/dickens | 172528 | 5919.9 ± 4.9% | 2897.3 ± 1.1% | 2399.3 ± 1.8% | 264.2 ± 4.1% | 2197.1 ± 1.8% | 503.9 ± 6.2% | 2.043 | 2.467 | 22.403 | 2.694 | 11.749 |
| string: silesia/nci | 1075110 | 5037.0 ± 0.6% | 3213.0 ± 2.2% | 2240.1 ± 0.5% | 562.9 ± 1.7% | 2377.3 ± 0.6% | 531.0 ± 1.6% | 1.568 | 2.249 | 8.948 | 2.119 | 9.486 |
| string: silesia/reymont | 1075159 | 3187.6 ± 3.9% | 2556.7 ± 0.6% | 1551.0 ± 0.4% | 283.4 ± 0.5% | 1604.8 ± 0.3% | 456.8 ± 0.9% | 1.247 | 2.055 | 11.247 | 1.986 | 6.978 |
| string: silesia/samba | 97582 | 2778.9 ± 0.6% | 2832.1 ± 1.8% | 2184.0 ± 1.2% | 274.1 ± 0.2% | 1329.8 ± 1.0% | 352.5 ± 10.4% | 0.981 | 1.272 | 10.136 | 2.090 | 7.884 |
| string: silesia/webster | 1098490 | 3825.4 ± 1.0% | 1998.0 ± 0.4% | 1436.1 ± 0.2% | 256.7 ± 0.7% | 1579.8 ± 1.3% | 416.9 ± 0.9% | 1.915 | 2.664 | 14.901 | 2.421 | 9.176 |
| string: silesia/xml | 1090118 | 4720.3 ± 0.4% | 3576.6 ± 0.2% | 1853.3 ± 0.6% | 420.7 ± 5.5% | 2272.0 ± 0.7% | 499.0 ± 0.7% | 1.320 | 2.547 | 11.221 | 2.078 | 9.460 |
| string: canterbury/alice29.txt | 159425 | 5231.8 ± 1.0% | 2453.6 ± 0.6% | 2351.3 ± 1.6% | 246.7 ± 0.8% | 1993.7 ± 2.5% | 453.3 ± 2.2% | 2.132 | 2.225 | 21.211 | 2.624 | 11.542 |
| string: canterbury/asyoulik.txt | 132198 | 3471.6 ± 1.2% | 1955.7 ± 1.5% | 2112.8 ± 0.2% | 250.5 ± 5.9% | 1639.6 ± 1.8% | 396.4 ± 2.2% | 1.775 | 1.643 | 13.859 | 2.117 | 8.758 |
| string: canterbury/lcet10.txt | 441884 | 5989.1 ± 0.6% | 2728.5 ± 1.1% | 1820.5 ± 0.5% | 289.5 ± 0.3% | 2071.5 ± 1.0% | 475.6 ± 1.7% | 2.195 | 3.290 | 20.690 | 2.891 | 12.592 |
| string: canterbury/plrabn12.txt | 503330 | 3987.2 ± 0.4% | 2338.8 ± 0.6% | 1524.4 ± 4.8% | 267.7 ± 0.4% | 2027.4 ± 0.6% | 435.1 ± 1.3% | 1.705 | 2.616 | 14.892 | 1.967 | 9.163 |
| string: canterbury-large/E.coli | 1048578 | 23785.0 ± 0.3% | 7688.3 ± 1.1% | 2777.5 ± 12.5% | 985.7 ± 0.6% | 5206.8 ± 0.2% | 907.1 ± 0.6% | 3.094 | 8.563 | 24.130 | 4.568 | 26.220 |
| string: canterbury-large/bible.txt | 1055886 | 8415.8 ± 4.4% | 4570.7 ± 14.7% | 2079.3 ± 2.0% | 305.0 ± 2.8% | 3018.8 ± 5.4% | 570.1 ± 11.9% | 1.841 | 4.047 | 27.590 | 2.788 | 14.763 |
| string: canterbury-large/world192.txt | 1103121 | 3610.9 ± 9.2% | 1886.5 ± 1.2% | 1458.9 ± 0.3% | 268.8 ± 0.3% | 1621.1 ± 6.7% | 421.7 ± 1.1% | 1.914 | 2.475 | 13.436 | 2.228 | 8.563 |
| string: http/html-1m | 1058582 | 7921.9 ± 0.7% | 3941.5 ± 0.5% | 2031.2 ± 2.9% | 351.8 ± 0.2% | 2763.7 ± 1.5% | 562.7 ± 1.3% | 2.010 | 3.900 | 22.518 | 2.866 | 14.078 |
| string: http/json-1m | 1190272 | 2860.8 ± 0.3% | 1057.6 ± 1.2% | 1688.1 ± 1.7% | 382.8 ± 0.6% | 841.8 ± 3.3% | 361.7 ± 2.5% | 2.705 | 1.695 | 7.473 | 3.398 | 7.910 |
| string: http/js-1m | 1144362 | 2526.9 ± 1.0% | 1399.8 ± 0.3% | 1130.7 ± 0.9% | 263.1 ± 0.3% | 1097.9 ± 0.5% | 333.5 ± 1.9% | 1.805 | 2.235 | 9.605 | 2.302 | 7.576 |
| string: http/css-1m | 1097820 | 2750.9 ± 0.2% | 2179.2 ± 2.3% | 1640.8 ± 0.6% | 369.6 ± 0.3% | 1446.8 ± 0.2% | 403.4 ± 1.1% | 1.262 | 1.677 | 7.443 | 1.901 | 6.819 |
| string: dickens as Cyrillic and CJK | 1883069 | 4725.0 ± 0.5% | 3239.0 ± 0.7% | 612.3 ± 3.6% | 283.0 ± 1.4% | 443.0 ± 0.2% | 128.4 ± 2.0% | 1.459 | 7.717 | 16.695 | 10.666 | 36.787 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 906.5 ± 2.5% | 1009.9 ± 6.0% | 908.9 ± 5.3% | 194.7 ± 0.8% | 370.7 ± 0.6% | 184.1 ± 4.9% | 0.898 | 0.997 | 4.656 | 2.445 | 4.923 |
| hex: silesia/dickens | 524290 | 24300.6 ± 1.5% | 10686.7 ± 0.4% | 3037.8 ± 0.4% | 398.9 ± 3.6% | 5224.7 ± 0.3% | 942.4 ± 2.8% | 2.274 | 7.999 | 60.924 | 4.651 | 25.785 |
| hex: silesia/mozilla | 524290 | 24273.2 ± 0.4% | 10700.2 ± 0.2% | 2964.1 ± 0.1% | 342.4 ± 1.7% | 5226.1 ± 0.2% | 937.8 ± 0.6% | 2.268 | 8.189 | 70.889 | 4.645 | 25.883 |
| hex: silesia/mr | 524290 | 24255.8 ± 0.3% | 10697.6 ± 0.3% | 2964.2 ± 0.4% | 518.9 ± 0.9% | 5219.8 ± 1.6% | 937.2 ± 2.0% | 2.267 | 8.183 | 46.743 | 4.647 | 25.881 |
| hex: silesia/nci | 524290 | 24274.1 ± 0.2% | 10690.5 ± 0.4% | 3065.2 ± 1.0% | 660.2 ± 0.1% | 5215.9 ± 0.3% | 932.8 ± 1.1% | 2.271 | 7.919 | 36.769 | 4.654 | 26.022 |
| hex: silesia/ooffice | 524290 | 24280.8 ± 0.2% | 10698.4 ± 0.2% | 2997.7 ± 0.5% | 282.2 ± 1.5% | 5217.8 ± 0.5% | 935.1 ± 1.6% | 2.270 | 8.100 | 86.052 | 4.653 | 25.965 |
| hex: silesia/osdb | 524290 | 24299.2 ± 0.2% | 10680.8 ± 1.0% | 2999.4 ± 0.4% | 388.1 ± 3.5% | 5223.0 ± 0.4% | 936.8 ± 1.8% | 2.275 | 8.101 | 62.603 | 4.652 | 25.940 |
| hex: silesia/reymont | 524290 | 24257.9 ± 0.3% | 10684.1 ± 8.5% | 3062.2 ± 16.6% | 434.9 ± 4.5% | 5225.8 ± 0.2% | 931.8 ± 1.2% | 2.270 | 7.922 | 55.783 | 4.642 | 26.034 |
| hex: silesia/samba | 524290 | 24283.7 ± 1.8% | 10679.7 ± 0.3% | 2978.8 ± 0.2% | 300.1 ± 0.3% | 5224.8 ± 0.4% | 936.7 ± 1.7% | 2.274 | 8.152 | 80.931 | 4.648 | 25.926 |
| hex: silesia/sao | 524290 | 24282.8 ± 0.7% | 10702.5 ± 0.3% | 3003.1 ± 0.5% | 224.7 ± 3.2% | 5226.3 ± 9.7% | 932.2 ± 15.5% | 2.269 | 8.086 | 108.058 | 4.646 | 26.050 |
| hex: silesia/webster | 524290 | 24225.7 ± 4.7% | 10674.7 ± 0.4% | 3063.3 ± 0.6% | 382.7 ± 2.8% | 5226.1 ± 0.2% | 931.9 ± 1.4% | 2.269 | 7.908 | 63.306 | 4.636 | 25.997 |
| hex: silesia/x-ray | 524290 | 24243.9 ± 0.3% | 10688.2 ± 0.3% | 3006.9 ± 0.2% | 369.4 ± 2.9% | 5227.7 ± 0.2% | 928.8 ± 0.7% | 2.268 | 8.063 | 65.622 | 4.638 | 26.103 |
| hex: silesia/xml | 524290 | 24291.9 ± 0.2% | 10687.2 ± 0.4% | 3012.2 ± 0.1% | 642.7 ± 1.0% | 5217.7 ± 0.3% | 925.3 ± 2.8% | 2.273 | 8.064 | 37.796 | 4.656 | 26.253 |
| hex: canterbury/alice29.txt | 304180 | 24185.6 ± 6.6% | 11008.1 ± 0.1% | 3003.0 ± 0.2% | 403.4 ± 3.0% | 5217.8 ± 0.5% | 951.6 ± 1.6% | 2.197 | 8.054 | 59.957 | 4.635 | 25.415 |
| hex: canterbury/asyoulik.txt | 250360 | 24179.3 ± 1.4% | 10478.8 ± 0.2% | 2982.5 ± 0.2% | 394.7 ± 3.2% | 5225.6 ± 0.1% | 950.7 ± 0.9% | 2.307 | 8.107 | 61.267 | 4.627 | 25.433 |
| hex: canterbury/cp.html | 49208 | 23773.3 ± 6.8% | 11265.3 ± 1.8% | 3075.9 ± 2.1% | 435.7 ± 1.8% | 5202.9 ± 0.4% | 930.9 ± 1.2% | 2.110 | 7.729 | 54.566 | 4.569 | 25.539 |
| hex: canterbury/fields.c | 22302 | 23549.6 ± 1.1% | 12116.3 ± 0.5% | 3134.5 ± 0.2% | 513.9 ± 0.7% | 5197.2 ± 0.5% | 923.2 ± 2.7% | 1.944 | 7.513 | 45.829 | 4.531 | 25.509 |
| hex: canterbury/grammar.lsp | 7444 | 21327.0 ± 0.1% | 11787.0 ± 0.2% | 3102.1 ± 0.7% | 673.4 ± 2.7% | 5107.7 ± 0.5% | 882.5 ± 2.6% | 1.809 | 6.875 | 31.668 | 4.175 | 24.166 |
| hex: canterbury/kennedy.xls | 524290 | 24297.4 ± 0.2% | 9710.6 ± 0.4% | 3043.4 ± 0.5% | 676.6 ± 0.3% | 5226.8 ± 0.3% | 934.6 ± 1.2% | 2.502 | 7.984 | 35.909 | 4.649 | 25.997 |
| hex: canterbury/lcet10.txt | 524290 | 24265.0 ± 0.9% | 9906.0 ± 0.2% | 3049.9 ± 0.3% | 407.9 ± 3.8% | 5227.1 ± 0.2% | 942.8 ± 1.1% | 2.450 | 7.956 | 59.482 | 4.642 | 25.738 |
| hex: canterbury/plrabn12.txt | 524290 | 24277.0 ± 0.1% | 9864.0 ± 1.4% | 3038.8 ± 0.1% | 390.1 ± 3.4% | 5219.1 ± 0.3% | 936.6 ± 1.2% | 2.461 | 7.989 | 62.229 | 4.652 | 25.921 |
| hex: canterbury/ptt5 | 524290 | 24268.9 ± 21.7% | 9909.1 ± 15.0% | 2938.8 ± 0.3% | 520.1 ± 1.0% | 5222.3 ± 0.2% | 936.8 ± 1.3% | 2.449 | 8.258 | 46.658 | 4.647 | 25.907 |
| hex: canterbury/sum | 76482 | 23868.1 ± 16.6% | 10733.5 ± 1.6% | 3062.6 ± 0.3% | 493.5 ± 3.0% | 5212.8 ± 0.6% | 934.2 ± 2.4% | 2.224 | 7.793 | 48.362 | 4.579 | 25.549 |
| hex: canterbury/xargs.1 | 8456 | 21762.5 ± 0.4% | 11846.5 ± 12.5% | 3035.1 ± 0.1% | 663.0 ± 1.5% | 5115.2 ± 0.3% | 908.3 ± 2.4% | 1.837 | 7.170 | 32.823 | 4.254 | 23.961 |
| hex: canterbury-large/E.coli | 524290 | 24282.8 ± 0.4% | 9850.5 ± 0.5% | 2986.3 ± 0.5% | 693.6 ± 0.5% | 5211.8 ± 0.3% | 931.8 ± 1.8% | 2.465 | 8.131 | 35.011 | 4.659 | 26.061 |
| hex: canterbury-large/bible.txt | 524290 | 24256.3 ± 0.5% | 9803.4 ± 7.7% | 3013.6 ± 1.1% | 428.7 ± 3.0% | 5224.8 ± 0.4% | 935.6 ± 0.7% | 2.474 | 8.049 | 56.587 | 4.643 | 25.927 |
| hex: canterbury-large/world192.txt | 524290 | 24284.7 ± 3.9% | 9835.4 ± 1.0% | 3074.3 ± 0.2% | 397.5 ± 3.3% | 5228.2 ± 1.9% | 938.6 ± 1.4% | 2.469 | 7.899 | 61.097 | 4.645 | 25.872 |
| hex: http/html-1kx1024 | 2099200 | 13229.3 ± 0.9% | 8747.6 ± 0.2% | 2781.2 ± 0.4% | 438.9 ± 3.2% | 4626.6 ± 0.8% | 779.7 ± 2.0% | 1.512 | 4.757 | 30.143 | 2.859 | 16.966 |
| hex: http/html-16kx64 | 2097280 | 21510.5 ± 0.7% | 11280.5 ± 0.9% | 2901.8 ± 0.3% | 432.9 ± 3.4% | 5190.1 ± 0.3% | 879.5 ± 2.6% | 1.907 | 7.413 | 49.686 | 4.145 | 24.458 |
| hex: http/html-1m | 524290 | 24265.1 ± 3.6% | 10014.9 ± 4.3% | 2951.0 ± 4.4% | 432.3 ± 4.3% | 5219.7 ± 1.7% | 925.6 ± 2.2% | 2.423 | 8.223 | 56.133 | 4.649 | 26.215 |
| hex: http/json-1kx1024 | 2099200 | 13239.4 ± 0.6% | 8750.2 ± 0.6% | 2779.8 ± 0.3% | 623.6 ± 1.7% | 4634.3 ± 0.5% | 779.7 ± 2.4% | 1.513 | 4.763 | 21.232 | 2.857 | 16.980 |
| hex: http/json-16kx64 | 2097280 | 21660.3 ± 0.5% | 11300.4 ± 0.4% | 2908.3 ± 0.4% | 640.5 ± 0.7% | 5185.2 ± 1.1% | 875.7 ± 3.4% | 1.917 | 7.448 | 33.817 | 4.177 | 24.734 |
| hex: http/json-1m | 524290 | 24284.0 ± 1.0% | 10357.8 ± 1.4% | 3075.0 ± 0.2% | 675.4 ± 0.4% | 5221.9 ± 0.3% | 932.1 ± 2.3% | 2.345 | 7.897 | 35.957 | 4.650 | 26.053 |
| hex: http/js-1kx1024 | 2099200 | 13268.6 ± 0.5% | 8731.4 ± 0.3% | 2783.6 ± 0.6% | 429.3 ± 3.1% | 4629.4 ± 0.8% | 783.0 ± 2.6% | 1.520 | 4.767 | 30.908 | 2.866 | 16.947 |
| hex: http/js-16kx64 | 2097280 | 21554.5 ± 0.2% | 11287.5 ± 0.4% | 2911.1 ± 0.2% | 431.8 ± 3.0% | 5196.0 ± 0.5% | 888.9 ± 0.9% | 1.910 | 7.404 | 49.916 | 4.148 | 24.247 |
| hex: http/js-1m | 524290 | 24292.6 ± 0.4% | 10391.3 ± 0.4% | 3063.9 ± 0.5% | 442.2 ± 2.7% | 5217.8 ± 1.0% | 925.9 ± 2.1% | 2.338 | 7.929 | 54.931 | 4.656 | 26.236 |
| hex: http/css-1kx1024 | 2099200 | 13206.3 ± 0.2% | 8735.8 ± 2.2% | 2777.7 ± 7.7% | 486.2 ± 2.2% | 4628.4 ± 0.8% | 768.7 ± 8.9% | 1.512 | 4.754 | 27.164 | 2.853 | 17.179 |
| hex: http/css-16kx64 | 2097280 | 21648.6 ± 0.3% | 11309.1 ± 0.2% | 2900.1 ± 0.2% | 495.7 ± 2.5% | 5189.9 ± 0.2% | 881.6 ± 0.6% | 1.914 | 7.465 | 43.669 | 4.171 | 24.556 |
| hex: http/css-1m | 524290 | 24248.4 ± 1.3% | 10286.8 ± 0.2% | 3070.8 ± 6.7% | 473.6 ± 2.6% | 5226.3 ± 0.4% | 935.8 ± 0.9% | 2.357 | 7.896 | 51.199 | 4.640 | 25.913 |
| hex: shuffled/dickens-1m | 524290 | 24229.0 ± 3.1% | 10292.2 ± 1.5% | 3006.7 ± 0.5% | 398.8 ± 3.8% | 5220.7 ± 0.4% | 926.9 ± 0.9% | 2.354 | 8.058 | 60.761 | 4.641 | 26.141 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1179.2 ± 0.3% | 1125.6 ± 14.7% | 837.8 ± 0.8% | 367.7 ± 0.6% | 358.9 ± 0.7% | 390.6 ± 1.8% | 1.048 | 1.408 | 3.207 | 3.286 | 3.019 |
| qlog records, JSON text sequence | 1467503 | 929.9 ± 2.3% | 830.8 ± 7.8% | 685.4 ± 6.1% | 323.3 ± 5.1% | 346.1 ± 18.4% | 247.5 ± 6.8% | 1.119 | 1.357 | 2.876 | 2.687 | 3.757 |
| messages: 11 string members | 1025025 | 1027.8 ± 1.2% | 836.5 ± 1.9% | 623.0 ± 4.4% | 318.0 ± 1.9% | 322.5 ± 5.5% | 322.4 ± 2.9% | 1.229 | 1.650 | 3.232 | 3.187 | 3.189 |
| messages: 50 nested objects | 1121600 | 1191.8 ± 8.4% | 1207.8 ± 4.8% | 1015.3 ± 9.3% | 439.8 ± 1.3% | 398.6 ± 8.7% | 396.8 ± 1.6% | 0.987 | 1.174 | 2.710 | 2.990 | 3.003 |
| messages: a tree of 341 objects | 612600 | 493.8 ± 2.4% | 609.3 ± 3.7% | 426.6 ± 2.4% | 227.2 ± 2.2% | 263.5 ± 1.8% | 145.9 ± 0.9% | 0.810 | 1.158 | 2.173 | 1.874 | 3.385 |
| string: silesia/dickens | 172528 | 9962.1 ± 0.5% | 2920.8 ± 2.4% | 2398.6 ± 2.6% | 272.7 ± 1.0% | 1143.0 ± 0.6% | 1027.4 ± 0.1% | 3.411 | 4.153 | 36.533 | 8.716 | 9.697 |
| string: silesia/nci | 1075110 | 8371.2 ± 0.3% | 3165.2 ± 1.1% | 2430.2 ± 1.0% | 790.8 ± 0.9% | 1221.6 ± 0.5% | 1016.5 ± 1.6% | 2.645 | 3.445 | 10.586 | 6.853 | 8.235 |
| string: silesia/reymont | 1075159 | 4484.7 ± 4.5% | 1510.2 ± 1.6% | 1597.7 ± 0.3% | 313.0 ± 0.3% | 1036.1 ± 0.2% | 922.6 ± 0.3% | 2.970 | 2.807 | 14.326 | 4.328 | 4.861 |
| string: silesia/samba | 97582 | 4432.0 ± 0.7% | 1994.5 ± 0.5% | 2782.1 ± 0.9% | 265.8 ± 0.5% | 990.9 ± 0.8% | 1003.6 ± 0.6% | 2.222 | 1.593 | 16.673 | 4.473 | 4.416 |
| string: silesia/webster | 1098490 | 5732.9 ± 1.5% | 1510.2 ± 0.4% | 1504.6 ± 0.7% | 290.7 ± 0.8% | 1010.4 ± 2.2% | 516.7 ± 1.7% | 3.796 | 3.810 | 19.722 | 5.674 | 11.095 |
| string: silesia/xml | 1090118 | 7933.1 ± 3.2% | 2378.9 ± 9.7% | 2026.0 ± 0.8% | 499.3 ± 1.2% | 1192.1 ± 2.7% | 809.6 ± 0.9% | 3.335 | 3.916 | 15.888 | 6.655 | 9.799 |
| string: canterbury/alice29.txt | 159425 | 9096.2 ± 3.7% | 2197.9 ± 0.9% | 2222.9 ± 0.3% | 262.0 ± 2.7% | 1092.9 ± 8.2% | 930.0 ± 0.8% | 4.139 | 4.092 | 34.714 | 8.323 | 9.781 |
| string: canterbury/asyoulik.txt | 132198 | 8071.4 ± 1.2% | 1641.0 ± 0.3% | 2240.1 ± 1.2% | 260.8 ± 2.0% | 969.8 ± 2.0% | 825.6 ± 9.0% | 4.919 | 3.603 | 30.948 | 8.323 | 9.777 |
| string: canterbury/lcet10.txt | 441884 | 8991.3 ± 1.3% | 2352.0 ± 6.7% | 2069.0 ± 0.5% | 307.3 ± 0.6% | 1096.4 ± 11.8% | 990.9 ± 1.3% | 3.823 | 4.346 | 29.262 | 8.201 | 9.074 |
| string: canterbury/plrabn12.txt | 503330 | 6893.2 ± 2.6% | 1737.1 ± 0.5% | 1738.4 ± 2.0% | 279.6 ± 1.8% | 1051.3 ± 0.9% | 897.8 ± 12.9% | 3.968 | 3.965 | 24.653 | 6.557 | 7.678 |
| string: canterbury-large/E.coli | 1048578 | 15171.7 ± 0.3% | 8757.7 ± 0.3% | 2598.1 ± 0.2% | 1491.3 ± 0.6% | 1494.3 ± 0.2% | 1078.4 ± 1.0% | 1.732 | 5.840 | 10.173 | 10.153 | 14.068 |
| string: canterbury-large/bible.txt | 1055886 | 7776.3 ± 7.4% | 3686.2 ± 0.2% | 2314.9 ± 1.4% | 330.8 ± 0.8% | 1306.2 ± 0.7% | 1164.9 ± 0.3% | 2.110 | 3.359 | 23.508 | 5.954 | 6.676 |
| string: canterbury-large/world192.txt | 1103121 | 5425.9 ± 1.4% | 1316.3 ± 0.5% | 1599.5 ± 1.9% | 286.3 ± 2.3% | 990.1 ± 4.3% | 839.4 ± 4.8% | 4.122 | 3.392 | 18.953 | 5.480 | 6.464 |
| string: http/html-1m | 1058582 | 8429.9 ± 0.6% | 3371.3 ± 0.6% | 2254.4 ± 0.5% | 339.6 ± 3.3% | 1278.1 ± 1.9% | 711.7 ± 2.2% | 2.501 | 3.739 | 24.825 | 6.596 | 11.844 |
| string: http/json-1m | 1190272 | 6385.1 ± 10.0% | 1157.7 ± 0.4% | 1357.0 ± 0.3% | 435.0 ± 0.5% | 766.1 ± 1.0% | 689.2 ± 1.1% | 5.515 | 4.705 | 14.677 | 8.334 | 9.264 |
| string: http/js-1m | 1144362 | 5368.4 ± 1.9% | 877.7 ± 0.7% | 1191.0 ± 0.3% | 262.0 ± 3.1% | 824.0 ± 0.8% | 664.0 ± 0.4% | 6.116 | 4.508 | 20.493 | 6.515 | 8.085 |
| string: http/css-1m | 1097820 | 7340.6 ± 1.1% | 1141.3 ± 0.9% | 1731.7 ± 0.5% | 396.0 ± 5.6% | 932.6 ± 0.7% | 813.8 ± 1.2% | 6.432 | 4.239 | 18.536 | 7.871 | 9.020 |
| string: dickens as Cyrillic and CJK | 1883069 | 4535.7 ± 1.1% | 2879.0 ± 0.5% | 419.8 ± 0.4% | 209.5 ± 2.0% | 374.0 ± 0.4% | 277.7 ± 6.4% | 1.575 | 10.804 | 21.645 | 12.129 | 16.330 |
| hex: silesia/dickens | 524290 | 28781.4 ± 0.2% | 1702.7 ± 0.2% | 1055.2 ± 0.8% | 385.5 ± 0.1% | 884.2 ± 7.9% | 791.0 ± 7.1% | 16.904 | 27.276 | 74.660 | 32.551 | 36.387 |
| hex: silesia/mozilla | 524290 | 29217.5 ± 0.3% | 1697.8 ± 5.3% | 1061.0 ± 4.4% | 325.0 ± 3.5% | 872.1 ± 4.9% | 802.0 ± 3.0% | 17.209 | 27.538 | 89.886 | 33.504 | 36.430 |
| hex: silesia/mr | 524290 | 29304.7 ± 0.2% | 1706.5 ± 0.5% | 1061.8 ± 0.1% | 487.8 ± 7.6% | 882.6 ± 2.7% | 798.8 ± 2.3% | 17.172 | 27.599 | 60.070 | 33.202 | 36.687 |
| hex: silesia/nci | 524290 | 30269.3 ± 0.2% | 1710.2 ± 1.1% | 1059.1 ± 0.2% | 656.5 ± 0.4% | 883.4 ± 10.9% | 800.5 ± 3.3% | 17.699 | 28.581 | 46.108 | 34.265 | 37.813 |
| hex: silesia/ooffice | 524290 | 29460.5 ± 0.2% | 1711.2 ± 1.1% | 1062.0 ± 0.1% | 267.5 ± 1.2% | 883.5 ± 0.5% | 795.2 ± 3.2% | 17.216 | 27.740 | 110.119 | 33.347 | 37.046 |
| hex: silesia/osdb | 524290 | 28788.1 ± 1.1% | 1710.8 ± 0.3% | 1059.4 ± 0.2% | 362.1 ± 1.5% | 882.8 ± 10.6% | 795.4 ± 1.5% | 16.827 | 27.175 | 79.503 | 32.608 | 36.195 |
| hex: silesia/reymont | 524290 | 29556.9 ± 0.5% | 1707.1 ± 1.2% | 1059.1 ± 0.6% | 406.7 ± 0.4% | 881.1 ± 1.0% | 799.4 ± 1.9% | 17.315 | 27.907 | 72.667 | 33.547 | 36.975 |
| hex: silesia/samba | 524290 | 29711.0 ± 0.4% | 1707.5 ± 0.4% | 1060.6 ± 0.3% | 288.2 ± 0.7% | 882.5 ± 0.4% | 795.3 ± 4.8% | 17.400 | 28.012 | 103.106 | 33.666 | 37.359 |
| hex: silesia/sao | 524290 | 29194.8 ± 0.6% | 1702.3 ± 0.9% | 1059.6 ± 0.2% | 217.1 ± 0.6% | 876.5 ± 0.2% | 794.2 ± 2.9% | 17.150 | 27.552 | 134.477 | 33.307 | 36.762 |
| hex: silesia/webster | 524290 | 31246.9 ± 0.3% | 1705.9 ± 1.1% | 1059.9 ± 9.5% | 351.1 ± 0.4% | 882.5 ± 0.3% | 795.6 ± 1.6% | 18.317 | 29.481 | 88.993 | 35.409 | 39.273 |
| hex: silesia/x-ray | 524290 | 29212.7 ± 0.9% | 1706.6 ± 0.9% | 1059.5 ± 0.6% | 342.4 ± 1.1% | 882.8 ± 0.2% | 794.0 ± 0.7% | 17.118 | 27.573 | 85.316 | 33.092 | 36.793 |
| hex: silesia/xml | 524290 | 30277.1 ± 0.2% | 1708.5 ± 10.8% | 1061.5 ± 0.3% | 584.6 ± 0.6% | 884.4 ± 7.3% | 815.3 ± 3.1% | 17.721 | 28.522 | 51.795 | 34.235 | 37.135 |
| hex: canterbury/alice29.txt | 304180 | 28824.0 ± 0.6% | 1701.5 ± 0.1% | 1073.6 ± 0.2% | 389.4 ± 0.3% | 890.0 ± 0.6% | 834.9 ± 0.7% | 16.941 | 26.849 | 74.018 | 32.387 | 34.523 |
| hex: canterbury/asyoulik.txt | 250360 | 29213.2 ± 0.3% | 1724.2 ± 0.7% | 1082.8 ± 0.3% | 380.5 ± 0.2% | 890.1 ± 0.3% | 825.7 ± 2.3% | 16.943 | 26.979 | 76.778 | 32.821 | 35.378 |
| hex: canterbury/cp.html | 49208 | 28660.5 ± 0.2% | 1721.1 ± 0.2% | 1075.0 ± 15.4% | 385.5 ± 0.6% | 890.5 ± 1.3% | 845.0 ± 1.5% | 16.652 | 26.662 | 74.352 | 32.183 | 33.920 |
| hex: canterbury/fields.c | 22302 | 29515.9 ± 0.2% | 1722.3 ± 0.3% | 1077.6 ± 1.8% | 597.3 ± 0.9% | 892.8 ± 0.3% | 835.9 ± 5.0% | 17.137 | 27.390 | 49.412 | 33.059 | 35.309 |
| hex: canterbury/grammar.lsp | 7444 | 27977.9 ± 0.5% | 1773.3 ± 0.7% | 1091.6 ± 0.8% | 676.5 ± 1.6% | 900.6 ± 0.6% | 838.4 ± 3.3% | 15.777 | 25.631 | 41.360 | 31.066 | 33.370 |
| hex: canterbury/kennedy.xls | 524290 | 29450.7 ± 1.0% | 1708.6 ± 0.3% | 1060.7 ± 1.5% | 646.7 ± 0.3% | 882.8 ± 0.4% | 797.6 ± 1.3% | 17.237 | 27.765 | 45.542 | 33.359 | 36.925 |
| hex: canterbury/lcet10.txt | 524290 | 30294.9 ± 0.2% | 1707.4 ± 13.6% | 1061.0 ± 0.3% | 385.3 ± 0.5% | 860.6 ± 1.5% | 794.7 ± 2.8% | 17.743 | 28.554 | 78.630 | 35.202 | 38.121 |
| hex: canterbury/plrabn12.txt | 524290 | 29263.2 ± 0.2% | 1703.3 ± 0.9% | 1058.2 ± 4.0% | 376.1 ± 2.3% | 881.6 ± 0.4% | 795.9 ± 2.1% | 17.180 | 27.654 | 77.817 | 33.194 | 36.767 |
| hex: canterbury/ptt5 | 524290 | 29279.2 ± 8.8% | 1708.4 ± 0.4% | 1060.9 ± 0.2% | 491.7 ± 0.3% | 883.0 ± 0.7% | 798.0 ± 2.6% | 17.138 | 27.599 | 59.549 | 33.157 | 36.690 |
| hex: canterbury/sum | 76482 | 28853.0 ± 0.5% | 1723.9 ± 0.3% | 1076.9 ± 1.5% | 453.4 ± 5.9% | 891.0 ± 11.6% | 845.2 ± 2.5% | 16.737 | 26.792 | 63.638 | 32.384 | 34.137 |
| hex: canterbury/xargs.1 | 8456 | 28105.3 ± 0.4% | 1770.0 ± 0.8% | 1085.0 ± 11.4% | 685.3 ± 0.3% | 898.1 ± 0.7% | 854.3 ± 2.0% | 15.879 | 25.903 | 41.010 | 31.294 | 32.897 |
| hex: canterbury-large/E.coli | 524290 | 28759.2 ± 1.1% | 1700.4 ± 0.9% | 1060.5 ± 1.1% | 660.2 ± 4.7% | 883.8 ± 4.8% | 793.8 ± 4.9% | 16.913 | 27.117 | 43.562 | 32.541 | 36.228 |
| hex: canterbury-large/bible.txt | 524290 | 30274.6 ± 0.2% | 1709.2 ± 1.2% | 1060.9 ± 0.4% | 401.5 ± 0.6% | 882.5 ± 0.4% | 798.8 ± 3.8% | 17.713 | 28.538 | 75.406 | 34.305 | 37.899 |
| hex: canterbury-large/world192.txt | 524290 | 29410.5 ± 1.1% | 1697.7 ± 0.2% | 1058.3 ± 0.7% | 379.9 ± 0.7% | 884.5 ± 1.0% | 797.9 ± 3.2% | 17.324 | 27.790 | 77.416 | 33.253 | 36.861 |
| hex: http/html-1kx1024 | 2099200 | 18437.1 ± 0.5% | 1747.7 ± 0.5% | 1067.0 ± 0.7% | 409.0 ± 0.8% | 892.7 ± 1.2% | 823.2 ± 0.8% | 10.549 | 17.279 | 45.079 | 20.654 | 22.398 |
| hex: http/html-16kx64 | 2097280 | 19131.6 ± 1.4% | 1728.6 ± 0.6% | 1071.3 ± 0.3% | 409.5 ± 0.3% | 891.5 ± 12.8% | 845.2 ± 1.6% | 11.068 | 17.859 | 46.716 | 21.461 | 22.635 |
| hex: http/html-1m | 524290 | 29262.6 ± 0.8% | 1692.1 ± 0.1% | 1054.8 ± 0.2% | 387.8 ± 0.6% | 854.0 ± 10.3% | 801.4 ± 0.7% | 17.294 | 27.743 | 75.463 | 34.267 | 36.512 |
| hex: http/json-1kx1024 | 2099200 | 18186.9 ± 0.6% | 1749.7 ± 0.2% | 1067.9 ± 15.3% | 592.3 ± 0.8% | 894.0 ± 0.1% | 823.5 ± 5.2% | 10.394 | 17.031 | 30.704 | 20.343 | 22.085 |
| hex: http/json-16kx64 | 2097280 | 18706.5 ± 0.4% | 1728.9 ± 8.2% | 1062.6 ± 6.3% | 600.9 ± 18.0% | 891.7 ± 4.5% | 841.8 ± 3.5% | 10.820 | 17.605 | 31.130 | 20.978 | 22.221 |
| hex: http/json-1m | 524290 | 29430.3 ± 0.5% | 1704.5 ± 7.4% | 1058.4 ± 6.7% | 620.3 ± 0.6% | 866.1 ± 0.3% | 798.9 ± 2.1% | 17.266 | 27.805 | 47.442 | 33.981 | 36.840 |
| hex: http/js-1kx1024 | 2099200 | 18469.6 ± 0.2% | 1749.3 ± 1.1% | 1067.4 ± 0.3% | 404.5 ± 0.3% | 893.6 ± 0.2% | 820.5 ± 1.0% | 10.558 | 17.304 | 45.655 | 20.669 | 22.510 |
| hex: http/js-16kx64 | 2097280 | 19161.1 ± 0.5% | 1730.1 ± 0.3% | 1071.1 ± 1.0% | 407.3 ± 0.2% | 891.7 ± 0.1% | 841.8 ± 1.6% | 11.075 | 17.889 | 47.047 | 21.489 | 22.761 |
| hex: http/js-1m | 524290 | 29271.9 ± 0.1% | 1704.6 ± 1.4% | 1060.7 ± 1.3% | 417.4 ± 0.2% | 885.5 ± 0.2% | 802.8 ± 3.2% | 17.173 | 27.596 | 70.137 | 33.056 | 36.462 |
| hex: http/css-1kx1024 | 2099200 | 18247.6 ± 0.5% | 1746.3 ± 0.3% | 1067.3 ± 0.3% | 454.3 ± 3.3% | 892.3 ± 4.3% | 820.5 ± 1.9% | 10.449 | 17.097 | 40.164 | 20.451 | 22.240 |
| hex: http/css-16kx64 | 2097280 | 18902.8 ± 0.4% | 1728.6 ± 0.3% | 1070.6 ± 0.1% | 460.2 ± 0.6% | 889.9 ± 2.7% | 834.9 ± 2.1% | 10.935 | 17.656 | 41.071 | 21.243 | 22.641 |
| hex: http/css-1m | 524290 | 29422.7 ± 0.6% | 1708.3 ± 0.2% | 1059.5 ± 1.1% | 434.3 ± 0.5% | 869.4 ± 14.9% | 800.0 ± 2.6% | 17.223 | 27.772 | 67.750 | 33.843 | 36.779 |
| hex: shuffled/dickens-1m | 524290 | 29355.5 ± 0.3% | 1695.5 ± 1.0% | 1058.1 ± 0.4% | 386.4 ± 0.7% | 882.0 ± 7.8% | 796.6 ± 7.7% | 17.314 | 27.744 | 75.971 | 33.284 | 36.852 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.728 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.823 of yyjson.
- messages: 11 string members, decoding: stdx runs at 0.672 of simdjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.787 of simdjson.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding: stdx runs at 0.896 of simdjson.
- messages: a tree of 341 objects, encoding: stdx runs at 0.793 of simdjson.
- messages: a tree of 341 objects, encoding with J11's loop unchecked: stdx runs at 0.856 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.837 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.696 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.787 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.628 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.917 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.598 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.805 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.784 of serde_json.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next: stdx runs at 0.898 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.938 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.793 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.897 of yyjson.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.673 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.775 of simdjson.
- string: dickens as Cyrillic and CJK, as \u escapes, decoding through TextReader.next_items: stdx runs at 0.898 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.810 of simdjson.
