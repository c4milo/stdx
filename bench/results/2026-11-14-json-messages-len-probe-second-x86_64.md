# bench-json

| Field | Value |
|---|---|
| Commit | 3a70a3d |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.127.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1014-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43648402113 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1371.8 ± 0.8% | 0.488 | 1.023 | 1.068 | 1.070 | 0.411 | 1.076 | 1.074 | 0.370 | 0.833 | 0.928 | 0.106 |
| qlog records, JSON text sequence | 1467503 | 1085.4 ± 1.2% | 0.800 | 1.074 | 1.070 | 1.074 | 0.386 | 1.072 | 1.077 | 0.368 | 0.934 | 1.042 | 0.127 |
| messages: 11 string members | 1025025 | 1069.5 ± 0.5% | 0.578 | 1.004 | 1.023 | 1.026 | 0.541 | 1.016 | 1.027 | 0.537 | 0.886 | 0.951 | 0.136 |
| messages: 50 nested objects | 1121600 | 1326.6 ± 0.8% | 0.805 | 1.092 | 1.087 | 1.091 | 0.398 | 1.099 | 1.092 | 0.351 | 0.922 | 0.978 | 0.115 |
| string: silesia/dickens | 172528 | 6710.9 ± 0.8% | 0.028 | 0.702 | 1.081 | 1.085 | 0.208 | 1.042 | 1.101 | 0.207 | 0.997 | 0.999 | 0.029 |
| string: silesia/nci | 1075110 | 5421.8 ± 1.1% | 0.035 | 0.710 | 1.034 | 1.032 | 0.304 | 1.040 | 1.035 | 0.304 | 1.010 | 1.009 | 0.035 |
| string: silesia/reymont | 1075159 | 3533.5 ± 3.5% | 0.054 | 0.628 | 0.866 | 0.871 | 0.354 | 0.818 | 0.875 | 0.355 | 0.987 | 0.997 | 0.054 |
| string: silesia/samba | 97582 | 3989.8 ± 1.2% | 0.041 | 0.907 | 1.062 | 1.062 | 0.075 | 0.857 | 1.065 | 0.075 | 1.005 | 1.007 | 0.041 |
| string: silesia/webster | 1098490 | 4385.8 ± 0.8% | 0.042 | 0.654 | 0.986 | 0.990 | 0.224 | 0.928 | 1.003 | 0.222 | 1.008 | 1.008 | 0.042 |
| string: silesia/xml | 1090118 | 6065.7 ± 2.1% | 0.032 | 0.774 | 0.942 | 0.960 | 0.250 | 0.952 | 0.974 | 0.249 | 1.004 | 1.000 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5726.4 ± 3.1% | 0.033 | 0.754 | 1.088 | 1.127 | 0.188 | 1.028 | 1.174 | 0.189 | 1.002 | 1.008 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 4257.1 ± 1.0% | 0.042 | 0.814 | 1.125 | 1.141 | 0.202 | 1.053 | 1.140 | 0.201 | 0.996 | 1.003 | 0.042 |
| string: canterbury/lcet10.txt | 441884 | 6611.6 ± 0.9% | 0.029 | 0.606 | 1.106 | 1.110 | 0.199 | 1.040 | 1.115 | 0.199 | 1.004 | 1.006 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 5476.2 ± 1.4% | 0.034 | 0.768 | 0.969 | 0.977 | 0.226 | 0.863 | 0.981 | 0.229 | 1.002 | 1.004 | 0.034 |
| string: canterbury-large/E.coli | 1048578 | 30893.1 ± 0.4% | 0.059 | 1.004 | 0.787 | 1.005 | 0.519 | 1.004 | 1.004 | 0.519 | 1.099 | 1.103 | 0.007 |
| string: canterbury-large/bible.txt | 1055886 | 8361.9 ± 1.8% | 0.024 | 0.631 | 0.888 | 0.888 | 0.409 | 0.898 | 0.902 | 0.409 | 1.012 | 1.019 | 0.024 |
| string: canterbury-large/world192.txt | 1103121 | 4135.4 ± 1.0% | 0.045 | 0.695 | 0.973 | 0.980 | 0.214 | 0.928 | 0.986 | 0.214 | 1.001 | 1.004 | 0.045 |
| string: http/html-1m | 1058582 | 8953.0 ± 3.8% | 0.022 | 0.571 | 0.791 | 0.804 | 0.319 | 0.760 | 0.808 | 0.319 | 0.980 | 1.054 | 0.022 |
| string: http/json-1m | 1190272 | 3316.2 ± 0.8% | 0.052 | 0.394 | 0.440 | 0.447 | 0.146 | 0.458 | 0.444 | 0.145 | 0.998 | 1.000 | 0.052 |
| string: http/js-1m | 1144362 | 2822.5 ± 0.7% | 0.062 | 0.706 | 0.887 | 0.926 | 0.191 | 0.860 | 0.928 | 0.192 | 1.008 | 1.010 | 0.061 |
| string: http/css-1m | 1097820 | 3258.1 ± 0.8% | 0.055 | 0.775 | 0.922 | 1.027 | 0.285 | 0.974 | 1.030 | 0.285 | 1.006 | 1.013 | 0.055 |
| string: dickens as Cyrillic and CJK | 1883069 | 5818.4 ± 1.0% | 0.025 | 0.058 | 0.449 | 0.451 | 0.197 | 0.448 | 0.450 | 0.197 | 0.999 | 1.006 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1186.3 ± 4.1% | 0.113 | 1.002 | 1.009 | 1.012 | 0.107 | 0.718 | 1.010 | 0.107 | 1.006 | 1.018 | 0.112 |
| hex: silesia/dickens | 524290 | 45099.5 ± 0.9% | 0.040 | 1.003 | 0.629 | 1.001 | 0.397 | 0.998 | 1.001 | 0.398 | 0.748 | 0.748 | 0.005 |
| hex: silesia/mozilla | 524290 | 46054.2 ± 1.0% | 0.039 | 0.996 | 0.615 | 0.996 | 0.367 | 0.999 | 0.998 | 0.368 | 0.730 | 0.732 | 0.004 |
| hex: silesia/mr | 524290 | 45670.3 ± 2.0% | 0.040 | 1.001 | 0.619 | 1.000 | 0.390 | 1.000 | 1.000 | 0.390 | 0.741 | 0.742 | 0.005 |
| hex: silesia/nci | 524290 | 44673.2 ± 2.3% | 0.041 | 1.016 | 0.637 | 1.016 | 0.404 | 1.011 | 1.009 | 0.405 | 0.759 | 0.759 | 0.005 |
| hex: silesia/ooffice | 524290 | 45449.2 ± 1.9% | 0.040 | 1.001 | 0.622 | 0.998 | 0.381 | 1.001 | 0.998 | 0.380 | 0.744 | 0.743 | 0.005 |
| hex: silesia/osdb | 524290 | 45620.6 ± 0.9% | 0.040 | 1.004 | 0.623 | 1.004 | 0.392 | 1.002 | 1.004 | 0.393 | 0.739 | 0.739 | 0.005 |
| hex: silesia/reymont | 524290 | 45601.2 ± 1.7% | 0.040 | 1.001 | 0.622 | 1.001 | 0.395 | 0.996 | 1.005 | 0.393 | 0.739 | 0.740 | 0.004 |
| hex: silesia/samba | 524290 | 45877.1 ± 2.1% | 0.040 | 0.999 | 0.607 | 0.998 | 0.388 | 1.000 | 0.998 | 0.390 | 0.737 | 0.736 | 0.005 |
| hex: silesia/sao | 524290 | 37926.3 ± 0.5% | 0.048 | 0.999 | 0.631 | 0.998 | 0.440 | 1.000 | 0.999 | 0.439 | 0.892 | 0.894 | 0.005 |
| hex: silesia/webster | 524290 | 45670.8 ± 2.0% | 0.040 | 0.995 | 0.626 | 0.993 | 0.393 | 0.994 | 0.993 | 0.394 | 0.740 | 0.738 | 0.005 |
| hex: silesia/x-ray | 524290 | 45295.7 ± 1.1% | 0.040 | 0.999 | 0.630 | 0.997 | 0.391 | 0.995 | 0.994 | 0.392 | 0.743 | 0.744 | 0.005 |
| hex: silesia/xml | 524290 | 46619.0 ± 1.0% | 0.039 | 1.000 | 0.607 | 1.004 | 0.385 | 1.007 | 1.006 | 0.386 | 0.723 | 0.722 | 0.004 |
| hex: canterbury/alice29.txt | 304180 | 46029.0 ± 1.2% | 0.040 | 0.999 | 0.615 | 0.993 | 0.389 | 0.997 | 0.995 | 0.389 | 0.732 | 0.729 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 44730.4 ± 2.5% | 0.041 | 1.015 | 0.637 | 1.014 | 0.402 | 1.013 | 1.008 | 0.402 | 0.753 | 0.754 | 0.005 |
| hex: canterbury/cp.html | 49208 | 44888.8 ± 0.5% | 0.041 | 1.003 | 0.619 | 1.002 | 0.392 | 1.000 | 0.999 | 0.394 | 0.745 | 0.742 | 0.005 |
| hex: canterbury/fields.c | 22302 | 50594.0 ± 1.2% | 0.036 | 1.010 | 0.542 | 1.012 | 0.388 | 1.010 | 1.015 | 0.398 | 0.648 | 0.648 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 43964.6 ± 1.8% | 0.042 | 1.003 | 0.577 | 1.009 | 0.408 | 1.003 | 1.011 | 0.430 | 0.675 | 0.674 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 45045.3 ± 2.3% | 0.040 | 0.999 | 0.617 | 0.999 | 0.398 | 0.996 | 0.994 | 0.397 | 0.750 | 0.750 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 47815.1 ± 3.3% | 0.038 | 1.001 | 0.582 | 1.004 | 0.374 | 0.997 | 0.999 | 0.375 | 0.704 | 0.707 | 0.004 |
| hex: canterbury/plrabn12.txt | 524290 | 45055.0 ± 1.9% | 0.040 | 1.002 | 0.623 | 1.003 | 0.398 | 1.003 | 0.996 | 0.398 | 0.748 | 0.750 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 45135.1 ± 7.1% | 0.040 | 0.995 | 0.633 | 0.998 | 0.397 | 0.999 | 1.001 | 0.398 | 0.746 | 0.747 | 0.005 |
| hex: canterbury/sum | 76482 | 45895.4 ± 1.2% | 0.040 | 1.004 | 0.612 | 1.007 | 0.386 | 1.008 | 1.006 | 0.387 | 0.721 | 0.723 | 0.005 |
| hex: canterbury/xargs.1 | 8456 | 44602.3 ± 0.9% | 0.041 | 1.009 | 0.575 | 1.006 | 0.412 | 1.005 | 1.014 | 0.427 | 0.679 | 0.674 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 46368.7 ± 0.8% | 0.039 | 1.000 | 0.602 | 0.998 | 0.386 | 1.002 | 0.999 | 0.386 | 0.725 | 0.727 | 0.004 |
| hex: canterbury-large/bible.txt | 524290 | 45391.7 ± 1.9% | 0.040 | 1.001 | 0.628 | 0.995 | 0.394 | 1.001 | 0.998 | 0.394 | 0.743 | 0.743 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 45464.2 ± 1.3% | 0.040 | 0.997 | 0.625 | 0.998 | 0.393 | 1.001 | 1.000 | 0.393 | 0.744 | 0.743 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 17911.7 ± 2.6% | 0.101 | 1.004 | 0.800 | 1.002 | 0.575 | 1.015 | 0.995 | 0.630 | 0.861 | 0.838 | 0.011 |
| hex: http/html-16kx64 | 2097280 | 34655.4 ± 0.4% | 0.052 | 1.004 | 0.684 | 1.002 | 0.467 | 1.002 | 1.006 | 0.470 | 0.797 | 0.798 | 0.006 |
| hex: http/html-1m | 524290 | 45945.5 ± 0.8% | 0.040 | 1.001 | 0.616 | 0.997 | 0.391 | 1.000 | 0.996 | 0.391 | 0.733 | 0.733 | 0.004 |
| hex: http/json-1kx1024 | 2099200 | 17653.1 ± 4.7% | 0.102 | 1.009 | 0.812 | 0.999 | 0.597 | 1.032 | 0.999 | 0.659 | 0.863 | 0.844 | 0.012 |
| hex: http/json-16kx64 | 2097280 | 34960.6 ± 1.1% | 0.052 | 1.003 | 0.683 | 1.002 | 0.464 | 1.003 | 1.005 | 0.467 | 0.792 | 0.793 | 0.006 |
| hex: http/json-1m | 524290 | 48142.0 ± 2.3% | 0.038 | 1.002 | 0.590 | 0.998 | 0.371 | 0.997 | 0.997 | 0.372 | 0.700 | 0.702 | 0.004 |
| hex: http/js-1kx1024 | 2099200 | 18070.3 ± 1.2% | 0.100 | 0.998 | 0.793 | 0.996 | 0.588 | 1.006 | 0.993 | 0.648 | 0.853 | 0.830 | 0.011 |
| hex: http/js-16kx64 | 2097280 | 33991.8 ± 1.7% | 0.053 | 1.006 | 0.690 | 1.002 | 0.470 | 1.008 | 1.007 | 0.475 | 0.800 | 0.799 | 0.006 |
| hex: http/js-1m | 524290 | 46607.3 ± 0.3% | 0.039 | 0.998 | 0.607 | 0.999 | 0.384 | 0.999 | 0.999 | 0.384 | 0.725 | 0.725 | 0.004 |
| hex: http/css-1kx1024 | 2099200 | 17912.9 ± 0.3% | 0.100 | 1.004 | 0.805 | 1.000 | 0.575 | 1.013 | 1.000 | 0.633 | 0.860 | 0.837 | 0.011 |
| hex: http/css-16kx64 | 2097280 | 34619.9 ± 0.6% | 0.053 | 1.008 | 0.687 | 1.009 | 0.470 | 1.009 | 1.009 | 0.473 | 0.797 | 0.797 | 0.006 |
| hex: http/css-1m | 524290 | 45475.1 ± 0.6% | 0.040 | 1.001 | 0.630 | 0.998 | 0.392 | 0.998 | 0.996 | 0.393 | 0.744 | 0.743 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 42709.0 ± 1.3% | 0.042 | 1.004 | 0.650 | 1.005 | 0.404 | 1.009 | 1.002 | 0.408 | 0.790 | 0.791 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1758.4 ± 3.5% | 0.425 | 0.998 | 0.991 | 1.015 | 1.023 | 0.274 | 1.024 | 0.514 | 0.901 | 0.091 | 1.014 |
| qlog records, JSON text sequence | 1467503 | 1662.8 ± 3.2% | 0.644 | 0.965 | 0.969 | 1.009 | 0.989 | 0.245 | 0.989 | 0.441 | 0.868 | 0.102 | 1.027 |
| messages: 11 string members | 1025025 | 1312.0 ± 0.6% | 0.521 | 0.991 | 0.998 | 1.006 | 0.995 | 0.390 | 0.997 | 0.691 | 0.974 | 0.120 | 1.005 |
| messages: 50 nested objects | 1121600 | 2001.5 ± 0.7% | 0.585 | 0.979 | 0.975 | 0.975 | 0.978 | 0.244 | 0.981 | 0.429 | 0.852 | 0.090 | 1.000 |
| string: silesia/dickens | 172528 | 12966.2 ± 1.3% | 0.017 | 0.532 | 0.360 | 0.531 | 0.555 | 0.121 | 0.561 | 0.997 | 1.000 | 0.017 | 1.029 |
| string: silesia/nci | 1075110 | 11126.7 ± 0.4% | 0.020 | 0.531 | 0.362 | 0.542 | 0.528 | 0.189 | 0.529 | 1.000 | 1.001 | 0.020 | 1.032 |
| string: silesia/reymont | 1075159 | 5352.8 ± 1.8% | 0.042 | 0.571 | 0.433 | 0.570 | 0.572 | 0.273 | 0.569 | 1.001 | 1.006 | 0.042 | 1.017 |
| string: silesia/samba | 97582 | 6323.4 ± 0.9% | 0.045 | 0.887 | 0.742 | 0.894 | 0.889 | 0.121 | 0.890 | 1.000 | 1.002 | 0.045 | 1.162 |
| string: silesia/webster | 1098490 | 7036.0 ± 0.5% | 0.032 | 0.574 | 0.400 | 0.551 | 0.578 | 0.157 | 0.576 | 0.991 | 1.001 | 0.031 | 0.983 |
| string: silesia/xml | 1090118 | 10859.8 ± 1.1% | 0.021 | 0.552 | 0.461 | 0.546 | 0.555 | 0.206 | 0.555 | 1.004 | 1.023 | 0.021 | 1.053 |
| string: canterbury/alice29.txt | 159425 | 12331.2 ± 0.6% | 0.018 | 0.449 | 0.369 | 0.430 | 0.470 | 0.097 | 0.480 | 0.999 | 1.005 | 0.018 | 1.039 |
| string: canterbury/asyoulik.txt | 132198 | 11012.8 ± 1.8% | 0.019 | 0.395 | 0.327 | 0.384 | 0.409 | 0.091 | 0.418 | 1.002 | 1.024 | 0.020 | 1.041 |
| string: canterbury/lcet10.txt | 441884 | 12550.4 ± 1.4% | 0.018 | 0.549 | 0.328 | 0.535 | 0.553 | 0.120 | 0.555 | 0.997 | 1.018 | 0.018 | 1.027 |
| string: canterbury/plrabn12.txt | 503330 | 8717.3 ± 2.7% | 0.026 | 0.623 | 0.499 | 0.621 | 0.622 | 0.162 | 0.624 | 1.007 | 1.031 | 0.026 | 1.018 |
| string: canterbury-large/E.coli | 1048578 | 25944.4 ± 0.4% | 0.069 | 1.002 | 1.002 | 0.868 | 1.002 | 0.588 | 1.002 | 1.000 | 1.002 | 0.009 | 1.002 |
| string: canterbury-large/bible.txt | 1055886 | 9685.5 ± 0.9% | 0.024 | 0.740 | 0.569 | 0.739 | 0.750 | 0.396 | 0.753 | 0.996 | 1.010 | 0.024 | 1.022 |
| string: canterbury-large/world192.txt | 1103121 | 6653.0 ± 0.9% | 0.033 | 0.590 | 0.424 | 0.562 | 0.594 | 0.155 | 0.593 | 0.994 | 1.007 | 0.033 | 0.976 |
| string: http/html-1m | 1058582 | 10091.7 ± 0.5% | 0.023 | 0.639 | 0.533 | 0.640 | 0.641 | 0.322 | 0.641 | 0.995 | 1.006 | 0.023 | 1.011 |
| string: http/json-1m | 1190272 | 8485.8 ± 0.6% | 0.024 | 0.183 | 0.159 | 0.183 | 0.183 | 0.073 | 0.183 | 1.000 | 1.002 | 0.024 | 1.023 |
| string: http/js-1m | 1144362 | 6527.2 ± 0.6% | 0.033 | 0.368 | 0.315 | 0.361 | 0.368 | 0.095 | 0.368 | 0.994 | 1.009 | 0.033 | 1.020 |
| string: http/css-1m | 1097820 | 9109.8 ± 0.7% | 0.024 | 0.350 | 0.288 | 0.348 | 0.349 | 0.127 | 0.351 | 1.001 | 1.006 | 0.024 | 1.024 |
| string: dickens as Cyrillic and CJK | 1883069 | 5482.8 ± 0.5% | 0.030 | 0.466 | 0.063 | 0.465 | 0.467 | 0.209 | 0.467 | 1.000 | 0.993 | 0.030 | 1.043 |
| hex: silesia/dickens | 524290 | 43563.4 ± 0.2% | 1.000 | 0.087 | 1.000 | 0.587 | 1.001 | 1.000 | 1.000 | 1.002 | 1.001 | 0.090 | 1.000 |
| hex: silesia/mozilla | 524290 | 43476.3 ± 0.4% | 1.002 | 0.087 | 1.003 | 0.590 | 1.001 | 1.001 | 1.002 | 0.969 | 1.004 | 0.090 | 1.003 |
| hex: silesia/mr | 524290 | 43407.0 ± 0.9% | 1.001 | 0.087 | 1.004 | 0.590 | 0.998 | 1.003 | 1.002 | 1.002 | 0.999 | 0.091 | 1.000 |
| hex: silesia/nci | 524290 | 43409.9 ± 0.7% | 0.999 | 0.087 | 1.002 | 0.589 | 1.001 | 1.002 | 1.003 | 1.003 | 1.004 | 0.091 | 1.002 |
| hex: silesia/ooffice | 524290 | 43007.2 ± 0.6% | 0.999 | 0.088 | 1.004 | 0.594 | 1.000 | 1.003 | 1.004 | 1.007 | 1.006 | 0.090 | 1.007 |
| hex: silesia/osdb | 524290 | 43524.5 ± 0.4% | 0.999 | 0.087 | 1.002 | 0.588 | 1.001 | 1.000 | 0.998 | 1.001 | 1.000 | 0.090 | 0.999 |
| hex: silesia/reymont | 524290 | 43150.3 ± 2.3% | 1.004 | 0.087 | 0.996 | 0.592 | 0.993 | 0.999 | 0.999 | 1.004 | 1.000 | 0.094 | 1.001 |
| hex: silesia/samba | 524290 | 43122.1 ± 1.1% | 1.002 | 0.088 | 1.005 | 0.593 | 0.999 | 1.001 | 1.001 | 1.003 | 0.998 | 0.092 | 1.003 |
| hex: silesia/sao | 524290 | 43526.0 ± 0.6% | 1.001 | 0.087 | 0.999 | 0.588 | 1.000 | 0.998 | 0.997 | 1.000 | 0.999 | 0.090 | 0.999 |
| hex: silesia/webster | 524290 | 43627.9 ± 0.6% | 1.000 | 0.086 | 1.003 | 0.587 | 0.999 | 1.001 | 1.005 | 1.002 | 1.002 | 0.090 | 1.005 |
| hex: silesia/x-ray | 524290 | 43057.3 ± 1.4% | 1.001 | 0.088 | 1.004 | 0.592 | 1.006 | 1.002 | 1.004 | 1.008 | 1.005 | 0.090 | 1.007 |
| hex: silesia/xml | 524290 | 42775.6 ± 1.4% | 1.003 | 0.088 | 1.008 | 0.597 | 1.007 | 1.006 | 1.008 | 1.008 | 1.007 | 0.093 | 1.012 |
| hex: canterbury/alice29.txt | 304180 | 42919.3 ± 1.1% | 1.007 | 0.088 | 1.000 | 0.594 | 1.010 | 1.009 | 1.008 | 1.007 | 1.008 | 0.093 | 1.004 |
| hex: canterbury/asyoulik.txt | 250360 | 42610.1 ± 8.8% | 1.005 | 0.089 | 1.006 | 0.601 | 1.005 | 0.967 | 1.007 | 1.009 | 1.005 | 0.095 | 1.009 |
| hex: canterbury/cp.html | 49208 | 42377.8 ± 1.0% | 0.998 | 0.090 | 0.991 | 0.588 | 1.001 | 0.995 | 0.995 | 0.998 | 1.002 | 0.097 | 0.997 |
| hex: canterbury/fields.c | 22302 | 41901.0 ± 0.6% | 1.004 | 0.091 | 1.002 | 0.595 | 1.005 | 0.988 | 1.001 | 1.001 | 1.007 | 0.098 | 1.002 |
| hex: canterbury/grammar.lsp | 7444 | 39626.1 ± 0.3% | 1.001 | 0.095 | 0.983 | 0.601 | 1.001 | 0.956 | 1.000 | 0.988 | 1.021 | 0.102 | 1.000 |
| hex: canterbury/kennedy.xls | 524290 | 43454.5 ± 0.7% | 1.000 | 0.087 | 1.002 | 0.591 | 0.998 | 1.002 | 0.998 | 0.998 | 0.997 | 0.090 | 1.001 |
| hex: canterbury/lcet10.txt | 524290 | 43567.5 ± 0.3% | 0.999 | 0.087 | 0.999 | 0.589 | 1.000 | 1.001 | 1.000 | 1.002 | 0.997 | 0.090 | 1.001 |
| hex: canterbury/plrabn12.txt | 524290 | 42447.8 ± 0.6% | 1.001 | 0.089 | 1.002 | 0.602 | 1.003 | 1.002 | 1.002 | 1.002 | 1.003 | 0.093 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 43492.5 ± 1.2% | 1.002 | 0.087 | 1.001 | 0.590 | 0.999 | 1.001 | 1.000 | 0.998 | 0.999 | 0.087 | 1.001 |
| hex: canterbury/sum | 76482 | 42564.2 ± 6.6% | 0.998 | 0.089 | 0.998 | 0.590 | 0.996 | 0.997 | 0.999 | 1.001 | 0.997 | 0.096 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 39836.6 ± 1.4% | 1.002 | 0.095 | 1.008 | 0.601 | 1.003 | 0.949 | 1.001 | 1.001 | 1.024 | 0.102 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 43444.2 ± 0.6% | 0.999 | 0.087 | 1.002 | 0.591 | 1.001 | 1.001 | 1.003 | 0.999 | 1.003 | 0.092 | 1.002 |
| hex: canterbury-large/bible.txt | 524290 | 43508.4 ± 0.6% | 1.001 | 0.086 | 1.002 | 0.591 | 0.995 | 1.001 | 0.999 | 1.003 | 0.999 | 0.088 | 1.002 |
| hex: canterbury-large/world192.txt | 524290 | 43588.9 ± 0.7% | 1.000 | 0.086 | 1.001 | 0.588 | 1.000 | 0.996 | 1.002 | 1.003 | 1.004 | 0.089 | 1.004 |
| hex: http/html-1kx1024 | 2099200 | 19956.1 ± 1.5% | 1.002 | 0.184 | 1.007 | 0.999 | 1.015 | 1.016 | 1.016 | 1.015 | 1.019 | 0.191 | 1.015 |
| hex: http/html-16kx64 | 2097280 | 22051.7 ± 0.8% | 1.008 | 0.172 | 1.008 | 0.970 | 1.012 | 1.008 | 1.010 | 1.010 | 1.007 | 0.186 | 1.010 |
| hex: http/html-1m | 524290 | 43570.9 ± 0.5% | 1.000 | 0.087 | 1.000 | 0.589 | 0.997 | 0.999 | 0.999 | 0.998 | 1.000 | 0.091 | 1.003 |
| hex: http/json-1kx1024 | 2099200 | 21175.6 ± 1.2% | 1.003 | 0.173 | 1.003 | 0.957 | 1.002 | 0.996 | 1.002 | 1.003 | 1.010 | 0.181 | 1.004 |
| hex: http/json-16kx64 | 2097280 | 21424.5 ± 5.5% | 1.006 | 0.177 | 1.005 | 0.986 | 1.006 | 1.006 | 1.007 | 1.006 | 1.005 | 0.192 | 1.006 |
| hex: http/json-1m | 524290 | 43176.2 ± 1.9% | 1.000 | 0.087 | 1.005 | 0.594 | 1.001 | 0.998 | 0.999 | 1.001 | 1.000 | 0.092 | 1.002 |
| hex: http/js-1kx1024 | 2099200 | 21986.7 ± 0.3% | 1.001 | 0.167 | 1.000 | 0.931 | 0.997 | 0.991 | 0.997 | 1.001 | 1.007 | 0.173 | 1.003 |
| hex: http/js-16kx64 | 2097280 | 22105.0 ± 0.4% | 1.002 | 0.170 | 1.003 | 0.969 | 1.004 | 1.001 | 1.002 | 1.002 | 1.004 | 0.186 | 1.001 |
| hex: http/js-1m | 524290 | 43406.7 ± 1.5% | 0.999 | 0.087 | 1.003 | 0.591 | 0.994 | 0.993 | 1.000 | 1.003 | 1.004 | 0.087 | 1.002 |
| hex: http/css-1kx1024 | 2099200 | 20570.0 ± 0.9% | 1.003 | 0.178 | 1.004 | 0.974 | 1.003 | 1.001 | 1.003 | 1.002 | 1.005 | 0.185 | 1.005 |
| hex: http/css-16kx64 | 2097280 | 22250.6 ± 0.5% | 1.003 | 0.171 | 0.992 | 0.961 | 0.988 | 1.003 | 1.003 | 1.005 | 1.005 | 0.185 | 1.004 |
| hex: http/css-1m | 524290 | 43183.3 ± 5.5% | 1.006 | 0.087 | 1.007 | 0.592 | 1.004 | 0.969 | 0.984 | 0.995 | 0.987 | 0.089 | 0.983 |
| hex: shuffled/dickens-1m | 524290 | 43274.3 ± 1.9% | 0.999 | 0.087 | 1.004 | 0.594 | 0.991 | 1.005 | 1.004 | 1.007 | 1.006 | 0.091 | 1.004 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.068 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.070 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.076 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.074 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.074 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.070 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.074 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.072 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.077 of all on.
- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.092 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.087 of all on.
- messages: 50 nested objects, decoding: J8 decoder fast path off runs at 1.091 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.099 of all on.
- messages: 50 nested objects, decoding: J13 decoder escape blocks off runs at 1.092 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.081 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.085 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.101 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.062 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.062 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.065 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.088 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.127 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.174 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.125 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.141 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.053 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.140 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.106 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.110 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.115 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 167058.0 ± 11.6% | 121398.4 ± 4.2% | 1.376 | 99813.7 ± 6.7% | 1.674 |
| string: silesia/nci | 1048576 | 151992.2 ± 0.2% | 115463.1 ± 0.6% | 1.316 | 96805.1 ± 0.4% | 1.570 |
| string: silesia/reymont | 1048576 | 166800.8 ± 1.5% | 121030.6 ± 0.8% | 1.378 | 100882.0 ± 0.4% | 1.653 |
| string: silesia/samba | 65546 | 161040.3 ± 0.5% | 119341.7 ± 1.3% | 1.349 | 98810.3 ± 0.3% | 1.630 |
| string: silesia/webster | 1048576 | 166599.3 ± 1.9% | 121855.6 ± 0.7% | 1.367 | 101481.0 ± 1.2% | 1.642 |
| string: silesia/xml | 1048576 | 150198.7 ± 0.8% | 115142.5 ± 0.5% | 1.304 | 96273.9 ± 0.5% | 1.560 |
| string: canterbury/alice29.txt | 152089 | 166432.5 ± 1.4% | 121520.8 ± 0.9% | 1.370 | 100216.8 ± 0.7% | 1.661 |
| string: canterbury/asyoulik.txt | 125179 | 165953.6 ± 0.6% | 121420.2 ± 0.7% | 1.367 | 100890.6 ± 1.0% | 1.645 |
| string: canterbury/lcet10.txt | 426754 | 167286.6 ± 6.3% | 121913.9 ± 0.4% | 1.372 | 101079.8 ± 0.9% | 1.655 |
| string: canterbury/plrabn12.txt | 481861 | 167937.6 ± 0.5% | 121819.1 ± 1.1% | 1.379 | 101113.1 ± 1.0% | 1.661 |
| string: canterbury-large/E.coli | 1048576 | 167499.8 ± 0.7% | 121555.0 ± 0.4% | 1.378 | 101224.0 ± 0.8% | 1.655 |
| string: canterbury-large/bible.txt | 1048576 | 151918.7 ± 0.3% | 115613.2 ± 0.6% | 1.314 | 97228.9 ± 0.3% | 1.562 |
| string: canterbury-large/world192.txt | 1048576 | 167314.5 ± 1.4% | 121830.0 ± 1.4% | 1.373 | 100727.5 ± 1.1% | 1.661 |
| string: http/html-1m | 1048576 | 144533.3 ± 1.4% | 110215.4 ± 1.3% | 1.311 | 92871.5 ± 1.7% | 1.556 |
| string: http/json-1m | 1048576 | 119596.1 ± 4.9% | 105000.4 ± 1.2% | 1.139 | 81729.8 ± 0.7% | 1.463 |
| string: http/js-1m | 1048576 | 148781.7 ± 0.8% | 113218.5 ± 0.9% | 1.314 | 93633.9 ± 5.3% | 1.589 |
| string: http/css-1m | 1048576 | 165418.2 ± 1.9% | 120753.7 ± 1.0% | 1.370 | 99660.4 ± 0.7% | 1.660 |
| string: dickens as Cyrillic and CJK | 1847045 | 23682.6 ± 0.3% | 20854.9 ± 3.8% | 1.136 | 14823.5 ± 0.7% | 1.598 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 164989.7 ± 1.8% | 120563.9 ± 0.7% | 1.368 | 100216.9 ± 0.4% | 1.646 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 164290.3 ± 1.2% | 120103.1 ± 0.7% | 1.368 | 100005.0 ± 0.6% | 1.643 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 164249.0 ± 2.7% | 120148.8 ± 0.3% | 1.367 | 99589.1 ± 0.4% | 1.649 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 165392.5 ± 1.0% | 121124.5 ± 1.3% | 1.365 | 100562.4 ± 0.9% | 1.645 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 168256.9 ± 2.2% | 121622.6 ± 1.4% | 1.383 | 101043.8 ± 0.7% | 1.665 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 167089.1 ± 1.0% | 121743.5 ± 0.3% | 1.372 | 101625.0 ± 0.8% | 1.644 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24146.0 ± 0.7% | 21603.7 ± 0.3% | 1.118 | 15176.1 ± 0.3% | 1.591 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24175.5 ± 2.0% | 21576.4 ± 1.1% | 1.120 | 15167.8 ± 0.4% | 1.594 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24156.0 ± 1.0% | 21587.2 ± 0.4% | 1.119 | 15187.0 ± 1.7% | 1.591 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24130.0 ± 0.5% | 21548.9 ± 0.3% | 1.120 | 15177.8 ± 1.6% | 1.590 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24128.1 ± 1.2% | 21583.1 ± 0.7% | 1.118 | 15165.7 ± 2.0% | 1.591 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24152.4 ± 0.1% | 21562.4 ± 1.6% | 1.120 | 15230.1 ± 1.3% | 1.586 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1371.8 ± 0.8% | 1495.1 ± 1.5% | 1104.4 ± 1.0% | 359.3 ± 0.6% | 665.6 ± 0.6% | 363.3 ± 2.2% | 0.918 | 1.242 | 3.819 | 2.061 | 3.776 |
| qlog records, JSON text sequence | 1467503 | 1085.4 ± 1.2% | 1225.8 ± 1.2% | 1116.5 ± 1.4% | 304.1 ± 0.9% | 754.1 ± 3.3% | 315.2 ± 2.1% | 0.885 | 0.972 | 3.570 | 1.439 | 3.443 |
| messages: 11 string members | 1025025 | 1069.5 ± 0.5% | 1927.4 ± 3.3% | 706.3 ± 3.2% | 314.9 ± 2.2% | 509.3 ± 0.6% | 303.9 ± 1.6% | 0.555 | 1.514 | 3.396 | 2.100 | 3.519 |
| messages: 50 nested objects | 1121600 | 1326.6 ± 0.8% | 1698.4 ± 4.6% | 1436.7 ± 1.1% | 370.9 ± 2.3% | 893.7 ± 0.8% | 417.1 ± 1.6% | 0.781 | 0.923 | 3.577 | 1.484 | 3.180 |
| string: silesia/dickens | 172528 | 6710.9 ± 0.8% | 3409.0 ± 4.6% | 2822.8 ± 1.9% | 304.6 ± 1.1% | 3052.2 ± 3.0% | 572.1 ± 1.9% | 1.969 | 2.377 | 22.031 | 2.199 | 11.731 |
| string: silesia/nci | 1075110 | 5421.8 ± 1.1% | 3916.7 ± 2.7% | 2999.2 ± 0.7% | 566.1 ± 1.8% | 3640.0 ± 0.6% | 572.3 ± 2.3% | 1.384 | 1.808 | 9.577 | 1.490 | 9.474 |
| string: silesia/reymont | 1075159 | 3533.5 ± 3.5% | 3421.3 ± 0.2% | 1970.9 ± 1.8% | 328.1 ± 0.7% | 2101.7 ± 0.5% | 487.2 ± 1.9% | 1.033 | 1.793 | 10.769 | 1.681 | 7.253 |
| string: silesia/samba | 97582 | 3989.8 ± 1.2% | 3784.9 ± 0.4% | 3111.9 ± 0.9% | 313.6 ± 0.9% | 1915.0 ± 0.6% | 418.3 ± 1.0% | 1.054 | 1.282 | 12.721 | 2.083 | 9.538 |
| string: silesia/webster | 1098490 | 4385.8 ± 0.8% | 2431.5 ± 1.1% | 1727.4 ± 1.5% | 305.5 ± 1.2% | 2068.7 ± 1.4% | 464.3 ± 1.7% | 1.804 | 2.539 | 14.356 | 2.120 | 9.446 |
| string: silesia/xml | 1090118 | 6065.7 ± 2.1% | 4886.3 ± 7.1% | 2452.5 ± 3.3% | 450.5 ± 3.4% | 3302.7 ± 5.1% | 531.9 ± 3.9% | 1.241 | 2.473 | 13.465 | 1.837 | 11.403 |
| string: canterbury/alice29.txt | 159425 | 5726.4 ± 3.1% | 2727.3 ± 4.6% | 2840.5 ± 0.9% | 286.6 ± 2.1% | 2723.8 ± 3.4% | 515.2 ± 1.8% | 2.100 | 2.016 | 19.980 | 2.102 | 11.114 |
| string: canterbury/asyoulik.txt | 132198 | 4257.1 ± 1.0% | 2598.3 ± 1.0% | 2732.9 ± 2.9% | 292.4 ± 3.0% | 2372.8 ± 1.0% | 453.5 ± 1.4% | 1.638 | 1.558 | 14.557 | 1.794 | 9.387 |
| string: canterbury/lcet10.txt | 441884 | 6611.6 ± 0.9% | 3270.2 ± 1.2% | 2289.7 ± 2.3% | 322.3 ± 0.5% | 2757.9 ± 1.3% | 554.8 ± 3.3% | 2.022 | 2.888 | 20.514 | 2.397 | 11.918 |
| string: canterbury/plrabn12.txt | 503330 | 5476.2 ± 1.4% | 3175.8 ± 1.2% | 1830.0 ± 2.7% | 302.1 ± 1.3% | 2827.7 ± 2.3% | 533.3 ± 1.8% | 1.724 | 2.993 | 18.128 | 1.937 | 10.268 |
| string: canterbury-large/E.coli | 1048578 | 30893.1 ± 0.4% | 13501.0 ± 0.8% | 3391.1 ± 0.4% | 1206.6 ± 3.6% | 8871.7 ± 1.2% | 933.6 ± 2.4% | 2.288 | 9.110 | 25.603 | 3.482 | 33.089 |
| string: canterbury-large/bible.txt | 1055886 | 8361.9 ± 1.8% | 5277.8 ± 1.2% | 2770.7 ± 1.2% | 330.6 ± 1.0% | 3869.2 ± 0.9% | 626.0 ± 4.3% | 1.584 | 3.018 | 25.295 | 2.161 | 13.358 |
| string: canterbury-large/world192.txt | 1103121 | 4135.4 ± 1.0% | 2292.8 ± 0.9% | 1776.1 ± 0.8% | 313.2 ± 1.5% | 2099.5 ± 0.4% | 461.6 ± 1.9% | 1.804 | 2.328 | 13.205 | 1.970 | 8.958 |
| string: http/html-1m | 1058582 | 8953.0 ± 3.8% | 4734.4 ± 0.9% | 2659.2 ± 1.1% | 383.5 ± 1.7% | 3631.3 ± 1.3% | 591.7 ± 0.8% | 1.891 | 3.367 | 23.348 | 2.465 | 15.132 |
| string: http/json-1m | 1190272 | 3316.2 ± 0.8% | 1257.2 ± 1.5% | 2082.1 ± 2.9% | 401.6 ± 0.9% | 1345.6 ± 0.6% | 440.9 ± 1.7% | 2.638 | 1.593 | 8.257 | 2.464 | 7.521 |
| string: http/js-1m | 1144362 | 2822.5 ± 0.7% | 1601.3 ± 1.1% | 1323.0 ± 1.2% | 300.9 ± 1.3% | 1413.9 ± 1.3% | 376.4 ± 1.4% | 1.763 | 2.133 | 9.379 | 1.996 | 7.499 |
| string: http/css-1m | 1097820 | 3258.1 ± 0.8% | 2874.8 ± 0.4% | 2264.5 ± 0.9% | 399.9 ± 1.3% | 2051.6 ± 0.9% | 432.8 ± 0.9% | 1.133 | 1.439 | 8.147 | 1.588 | 7.527 |
| string: dickens as Cyrillic and CJK | 1883069 | 5818.4 ± 1.0% | 3019.0 ± 4.6% | 658.8 ± 0.8% | 323.0 ± 0.9% | 511.9 ± 1.4% | 163.1 ± 3.1% | 1.927 | 8.831 | 18.014 | 11.365 | 35.668 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1186.3 ± 4.1% | 1235.8 ± 1.3% | 1090.8 ± 1.4% | 234.7 ± 1.1% | 475.7 ± 0.5% | 227.5 ± 2.5% | 0.960 | 1.087 | 5.055 | 2.494 | 5.216 |
| hex: silesia/dickens | 524290 | 45099.5 ± 0.9% | 14972.5 ± 0.4% | 3528.4 ± 3.7% | 449.2 ± 0.9% | 8830.6 ± 0.9% | 1115.7 ± 1.2% | 3.012 | 12.782 | 100.399 | 5.107 | 40.423 |
| hex: silesia/mozilla | 524290 | 46054.2 ± 1.0% | 14973.1 ± 2.5% | 3464.3 ± 0.6% | 413.4 ± 1.5% | 8833.9 ± 0.4% | 1122.9 ± 2.2% | 3.076 | 13.294 | 111.403 | 5.213 | 41.014 |
| hex: silesia/mr | 524290 | 45670.3 ± 2.0% | 15097.1 ± 0.8% | 3487.5 ± 4.1% | 622.2 ± 0.8% | 8863.0 ± 1.2% | 1130.9 ± 1.6% | 3.025 | 13.095 | 73.401 | 5.153 | 40.385 |
| hex: silesia/nci | 524290 | 44673.2 ± 2.3% | 15076.2 ± 1.0% | 3557.9 ± 1.3% | 720.0 ± 1.2% | 8831.3 ± 4.8% | 1136.1 ± 0.4% | 2.963 | 12.556 | 62.044 | 5.059 | 39.321 |
| hex: silesia/ooffice | 524290 | 45449.2 ± 1.9% | 15019.9 ± 1.0% | 3472.9 ± 1.6% | 331.2 ± 0.7% | 8847.3 ± 1.0% | 1127.2 ± 1.7% | 3.026 | 13.087 | 137.241 | 5.137 | 40.321 |
| hex: silesia/osdb | 524290 | 45620.6 ± 0.9% | 14986.7 ± 0.8% | 3482.5 ± 0.4% | 426.5 ± 1.5% | 8842.0 ± 1.6% | 1126.3 ± 3.6% | 3.044 | 13.100 | 106.955 | 5.160 | 40.503 |
| hex: silesia/reymont | 524290 | 45601.2 ± 1.7% | 14973.1 ± 0.5% | 3526.7 ± 0.7% | 454.6 ± 0.7% | 8827.1 ± 0.4% | 1123.8 ± 4.5% | 3.046 | 12.930 | 100.306 | 5.166 | 40.579 |
| hex: silesia/samba | 524290 | 45877.1 ± 2.1% | 14959.5 ± 0.9% | 3474.3 ± 0.6% | 343.4 ± 1.0% | 8860.0 ± 5.6% | 1123.2 ± 3.4% | 3.067 | 13.205 | 133.597 | 5.178 | 40.845 |
| hex: silesia/sao | 524290 | 37926.3 ± 0.5% | 15058.0 ± 0.6% | 3467.7 ± 0.4% | 275.5 ± 0.7% | 8903.3 ± 1.1% | 1137.2 ± 0.5% | 2.519 | 10.937 | 137.679 | 4.260 | 33.350 |
| hex: silesia/webster | 524290 | 45670.8 ± 2.0% | 15018.6 ± 0.7% | 3518.1 ± 4.0% | 416.2 ± 1.1% | 8823.1 ± 1.1% | 1130.8 ± 1.4% | 3.041 | 12.982 | 109.743 | 5.176 | 40.389 |
| hex: silesia/x-ray | 524290 | 45295.7 ± 1.1% | 15000.1 ± 0.4% | 3455.5 ± 3.3% | 409.0 ± 0.6% | 8828.9 ± 0.6% | 1128.9 ± 0.8% | 3.020 | 13.108 | 110.735 | 5.130 | 40.124 |
| hex: silesia/xml | 524290 | 46619.0 ± 1.0% | 14970.3 ± 0.9% | 3536.0 ± 3.7% | 526.2 ± 1.7% | 8878.6 ± 0.6% | 1122.0 ± 1.3% | 3.114 | 13.184 | 88.593 | 5.251 | 41.550 |
| hex: canterbury/alice29.txt | 304180 | 46029.0 ± 1.2% | 14044.3 ± 0.7% | 3549.0 ± 0.6% | 457.3 ± 0.7% | 8850.8 ± 0.7% | 1134.7 ± 1.7% | 3.277 | 12.970 | 100.651 | 5.201 | 40.563 |
| hex: canterbury/asyoulik.txt | 250360 | 44730.4 ± 2.5% | 14971.5 ± 1.1% | 3487.3 ± 3.1% | 445.0 ± 1.2% | 8850.2 ± 0.4% | 1145.2 ± 2.4% | 2.988 | 12.826 | 100.526 | 5.054 | 39.057 |
| hex: canterbury/cp.html | 49208 | 44888.8 ± 0.5% | 14423.9 ± 1.1% | 3558.3 ± 1.2% | 436.4 ± 1.9% | 9236.5 ± 1.4% | 1125.9 ± 1.2% | 3.112 | 12.615 | 102.865 | 4.860 | 39.869 |
| hex: canterbury/fields.c | 22302 | 50594.0 ± 1.2% | 17408.9 ± 1.8% | 3648.7 ± 3.6% | 473.5 ± 1.6% | 9165.3 ± 0.7% | 1084.1 ± 2.5% | 2.906 | 13.866 | 106.847 | 5.520 | 46.668 |
| hex: canterbury/grammar.lsp | 7444 | 43964.6 ± 1.8% | 17169.9 ± 0.7% | 3608.6 ± 0.3% | 585.4 ± 1.1% | 8900.2 ± 0.4% | 1051.1 ± 2.7% | 2.561 | 12.183 | 75.106 | 4.940 | 41.828 |
| hex: canterbury/kennedy.xls | 524290 | 45045.3 ± 2.3% | 14940.2 ± 1.0% | 3535.6 ± 0.6% | 693.9 ± 0.6% | 8840.2 ± 1.1% | 1063.0 ± 6.7% | 3.015 | 12.740 | 64.914 | 5.096 | 42.377 |
| hex: canterbury/lcet10.txt | 524290 | 47815.1 ± 3.3% | 14929.0 ± 0.7% | 3540.7 ± 0.9% | 456.7 ± 2.1% | 8842.2 ± 0.6% | 1091.4 ± 4.0% | 3.203 | 13.504 | 104.686 | 5.408 | 43.809 |
| hex: canterbury/plrabn12.txt | 524290 | 45055.0 ± 1.9% | 14957.4 ± 0.9% | 3533.6 ± 1.3% | 440.9 ± 1.0% | 8887.3 ± 0.4% | 1115.1 ± 3.1% | 3.012 | 12.750 | 102.190 | 5.070 | 40.406 |
| hex: canterbury/ptt5 | 524290 | 45135.1 ± 7.1% | 14950.0 ± 0.5% | 3470.7 ± 0.9% | 648.2 ± 0.7% | 8846.2 ± 5.0% | 1113.1 ± 3.2% | 3.019 | 13.005 | 69.632 | 5.102 | 40.547 |
| hex: canterbury/sum | 76482 | 45895.4 ± 1.2% | 15379.4 ± 1.2% | 3550.1 ± 0.3% | 529.4 ± 3.0% | 8838.1 ± 4.2% | 1111.4 ± 2.3% | 2.984 | 12.928 | 86.688 | 5.193 | 41.296 |
| hex: canterbury/xargs.1 | 8456 | 44602.3 ± 0.9% | 17275.7 ± 5.6% | 3558.2 ± 1.2% | 553.1 ± 0.6% | 8952.4 ± 1.2% | 1089.5 ± 2.8% | 2.582 | 12.535 | 80.646 | 4.982 | 40.937 |
| hex: canterbury-large/E.coli | 524290 | 46368.7 ± 0.8% | 14916.9 ± 1.0% | 3458.6 ± 0.7% | 958.8 ± 1.0% | 8838.4 ± 0.6% | 1104.4 ± 7.9% | 3.108 | 13.407 | 48.362 | 5.246 | 41.987 |
| hex: canterbury-large/bible.txt | 524290 | 45391.7 ± 1.9% | 14982.2 ± 0.4% | 3472.2 ± 0.6% | 469.6 ± 2.3% | 8850.7 ± 0.6% | 1105.9 ± 2.7% | 3.030 | 13.073 | 96.659 | 5.129 | 41.047 |
| hex: canterbury-large/world192.txt | 524290 | 45464.2 ± 1.3% | 14998.8 ± 0.5% | 3550.8 ± 0.3% | 436.2 ± 2.3% | 8884.2 ± 0.5% | 1106.3 ± 3.4% | 3.031 | 12.804 | 104.224 | 5.117 | 41.097 |
| hex: http/html-1kx1024 | 2099200 | 17911.7 ± 2.6% | 12215.9 ± 8.0% | 3184.1 ± 0.5% | 463.2 ± 1.2% | 7425.0 ± 2.1% | 973.9 ± 1.7% | 1.466 | 5.625 | 38.670 | 2.412 | 18.391 |
| hex: http/html-16kx64 | 2097280 | 34655.4 ± 0.4% | 13865.6 ± 1.1% | 3375.5 ± 1.2% | 459.2 ± 3.6% | 8183.6 ± 8.0% | 1059.9 ± 2.1% | 2.499 | 10.267 | 75.473 | 4.235 | 32.696 |
| hex: http/html-1m | 524290 | 45945.5 ± 0.8% | 14897.5 ± 0.8% | 3468.6 ± 0.4% | 444.5 ± 0.7% | 8835.1 ± 0.6% | 1118.6 ± 5.4% | 3.084 | 13.246 | 103.356 | 5.200 | 41.073 |
| hex: http/json-1kx1024 | 2099200 | 17653.1 ± 4.7% | 12087.8 ± 0.7% | 3172.5 ± 1.0% | 618.2 ± 1.8% | 7342.1 ± 1.0% | 979.8 ± 0.6% | 1.460 | 5.564 | 28.555 | 2.404 | 18.017 |
| hex: http/json-16kx64 | 2097280 | 34960.6 ± 1.1% | 13897.6 ± 0.6% | 3404.7 ± 0.7% | 624.8 ± 0.4% | 8580.2 ± 9.2% | 1074.8 ± 3.6% | 2.516 | 10.268 | 55.951 | 4.075 | 32.528 |
| hex: http/json-1m | 524290 | 48142.0 ± 2.3% | 14981.0 ± 0.6% | 3534.2 ± 0.3% | 593.9 ± 2.7% | 8868.7 ± 1.7% | 1123.7 ± 2.6% | 3.214 | 13.622 | 81.058 | 5.428 | 42.842 |
| hex: http/js-1kx1024 | 2099200 | 18070.3 ± 1.2% | 12279.4 ± 1.8% | 3174.9 ± 0.6% | 456.4 ± 0.5% | 7412.1 ± 0.8% | 970.1 ± 2.4% | 1.472 | 5.692 | 39.595 | 2.438 | 18.628 |
| hex: http/js-16kx64 | 2097280 | 33991.8 ± 1.7% | 13892.4 ± 0.3% | 3385.8 ± 0.9% | 455.7 ± 1.0% | 8360.4 ± 1.3% | 1079.1 ± 2.9% | 2.447 | 10.040 | 74.588 | 4.066 | 31.501 |
| hex: http/js-1m | 524290 | 46607.3 ± 0.3% | 14970.9 ± 0.9% | 3538.8 ± 0.7% | 449.8 ± 0.8% | 8873.3 ± 0.6% | 1127.0 ± 1.8% | 3.113 | 13.170 | 103.621 | 5.253 | 41.355 |
| hex: http/css-1kx1024 | 2099200 | 17912.9 ± 0.3% | 12459.5 ± 1.2% | 3171.6 ± 0.5% | 503.0 ± 0.6% | 7381.7 ± 1.1% | 985.9 ± 0.9% | 1.438 | 5.648 | 35.611 | 2.427 | 18.169 |
| hex: http/css-16kx64 | 2097280 | 34619.9 ± 0.6% | 13747.7 ± 0.5% | 3401.6 ± 0.6% | 504.2 ± 0.3% | 8315.1 ± 0.9% | 1078.4 ± 1.7% | 2.518 | 10.178 | 68.660 | 4.164 | 32.103 |
| hex: http/css-1m | 524290 | 45475.1 ± 0.6% | 15022.6 ± 0.5% | 3554.3 ± 3.5% | 456.8 ± 0.6% | 8881.3 ± 4.8% | 1132.0 ± 3.7% | 3.027 | 12.794 | 99.543 | 5.120 | 40.173 |
| hex: shuffled/dickens-1m | 524290 | 42709.0 ± 1.3% | 14945.4 ± 2.1% | 3440.8 ± 3.5% | 450.2 ± 1.2% | 8860.1 ± 0.9% | 1121.2 ± 0.6% | 2.858 | 12.412 | 94.866 | 4.820 | 38.092 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1758.4 ± 3.5% | 1477.2 ± 0.5% | 1025.0 ± 0.2% | 458.4 ± 0.8% | 467.2 ± 1.2% | 499.3 ± 4.7% | 1.190 | 1.716 | 3.836 | 3.764 | 3.522 |
| qlog records, JSON text sequence | 1467503 | 1662.8 ± 3.2% | 1246.4 ± 3.7% | 948.8 ± 3.1% | 420.7 ± 3.2% | 572.7 ± 0.7% | 349.9 ± 3.3% | 1.334 | 1.753 | 3.952 | 2.903 | 4.753 |
| messages: 11 string members | 1025025 | 1312.0 ± 0.6% | 1111.5 ± 1.0% | 772.1 ± 1.4% | 409.9 ± 0.7% | 443.0 ± 3.4% | 433.9 ± 1.9% | 1.180 | 1.699 | 3.201 | 2.961 | 3.023 |
| messages: 50 nested objects | 1121600 | 2001.5 ± 0.7% | 1877.2 ± 0.5% | 1340.9 ± 0.8% | 584.8 ± 1.4% | 652.8 ± 0.8% | 519.7 ± 1.0% | 1.066 | 1.493 | 3.423 | 3.066 | 3.851 |
| string: silesia/dickens | 172528 | 12966.2 ± 1.3% | 3904.6 ± 1.7% | 3071.4 ± 3.7% | 331.4 ± 1.4% | 1695.2 ± 0.5% | 1177.0 ± 0.6% | 3.321 | 4.222 | 39.126 | 7.649 | 11.017 |
| string: silesia/nci | 1075110 | 11126.7 ± 0.4% | 4691.9 ± 0.8% | 3105.9 ± 3.2% | 906.2 ± 3.7% | 1889.2 ± 2.1% | 1203.3 ± 0.9% | 2.371 | 3.582 | 12.278 | 5.890 | 9.247 |
| string: silesia/reymont | 1075159 | 5352.8 ± 1.8% | 1868.9 ± 1.1% | 1893.8 ± 0.5% | 381.8 ± 1.2% | 1442.3 ± 0.4% | 1041.5 ± 4.8% | 2.864 | 2.827 | 14.021 | 3.711 | 5.140 |
| string: silesia/samba | 97582 | 6323.4 ± 0.9% | 2708.5 ± 0.8% | 4053.0 ± 1.0% | 347.0 ± 1.2% | 1325.1 ± 0.9% | 1172.0 ± 1.2% | 2.335 | 1.560 | 18.223 | 4.772 | 5.395 |
| string: silesia/webster | 1098490 | 7036.0 ± 0.5% | 1974.0 ± 2.4% | 1745.4 ± 2.4% | 351.3 ± 0.5% | 1396.5 ± 1.1% | 602.7 ± 1.3% | 3.564 | 4.031 | 20.028 | 5.038 | 11.675 |
| string: silesia/xml | 1090118 | 10859.8 ± 1.1% | 3192.6 ± 1.4% | 2515.9 ± 1.1% | 604.7 ± 1.6% | 1932.2 ± 0.7% | 951.5 ± 1.0% | 3.402 | 4.317 | 17.958 | 5.621 | 11.413 |
| string: canterbury/alice29.txt | 159425 | 12331.2 ± 0.6% | 2892.7 ± 1.8% | 3003.1 ± 1.9% | 316.7 ± 1.4% | 1519.9 ± 0.9% | 1095.8 ± 1.0% | 4.263 | 4.106 | 38.941 | 8.113 | 11.253 |
| string: canterbury/asyoulik.txt | 132198 | 11012.8 ± 1.8% | 2075.5 ± 1.7% | 3126.3 ± 1.5% | 316.3 ± 0.6% | 1359.7 ± 1.7% | 957.2 ± 0.5% | 5.306 | 3.523 | 34.821 | 8.100 | 11.505 |
| string: canterbury/lcet10.txt | 441884 | 12550.4 ± 1.4% | 3085.2 ± 1.0% | 2546.0 ± 0.9% | 366.4 ± 0.8% | 1634.7 ± 4.7% | 1188.5 ± 1.6% | 4.068 | 4.929 | 34.257 | 7.678 | 10.560 |
| string: canterbury/plrabn12.txt | 503330 | 8717.3 ± 2.7% | 2302.5 ± 0.6% | 2093.2 ± 0.9% | 345.6 ± 2.5% | 1596.6 ± 1.9% | 1117.2 ± 0.3% | 3.786 | 4.165 | 25.220 | 5.460 | 7.803 |
| string: canterbury-large/E.coli | 1048578 | 25944.4 ± 0.4% | 16202.4 ± 0.8% | 3481.6 ± 0.4% | 1689.7 ± 0.4% | 3148.1 ± 0.6% | 1416.2 ± 0.5% | 1.601 | 7.452 | 15.354 | 8.241 | 18.320 |
| string: canterbury-large/bible.txt | 1055886 | 9685.5 ± 0.9% | 4892.1 ± 0.9% | 2990.0 ± 0.9% | 405.6 ± 1.0% | 2223.8 ± 1.1% | 1483.6 ± 0.6% | 1.980 | 3.239 | 23.878 | 4.355 | 6.528 |
| string: canterbury-large/world192.txt | 1103121 | 6653.0 ± 0.9% | 1742.1 ± 0.5% | 1880.0 ± 1.7% | 346.9 ± 0.9% | 1385.9 ± 1.2% | 962.3 ± 0.5% | 3.819 | 3.539 | 19.179 | 4.800 | 6.914 |
| string: http/html-1m | 1058582 | 10091.7 ± 0.5% | 4454.1 ± 1.8% | 2876.5 ± 0.6% | 421.0 ± 2.6% | 2158.0 ± 0.8% | 848.0 ± 0.3% | 2.266 | 3.508 | 23.971 | 4.676 | 11.900 |
| string: http/json-1m | 1190272 | 8485.8 ± 0.6% | 1583.9 ± 0.4% | 1569.4 ± 0.5% | 557.7 ± 1.1% | 1173.5 ± 1.1% | 846.1 ± 1.0% | 5.357 | 5.407 | 15.216 | 7.231 | 10.029 |
| string: http/js-1m | 1144362 | 6527.2 ± 0.6% | 1127.3 ± 1.0% | 1399.4 ± 0.6% | 332.8 ± 0.4% | 1115.3 ± 1.6% | 757.5 ± 0.4% | 5.790 | 4.664 | 19.612 | 5.852 | 8.616 |
| string: http/css-1m | 1097820 | 9109.8 ± 0.7% | 1494.3 ± 0.5% | 2293.1 ± 0.6% | 509.1 ± 0.5% | 1264.2 ± 0.7% | 880.3 ± 0.6% | 6.096 | 3.973 | 17.895 | 7.206 | 10.348 |
| string: dickens as Cyrillic and CJK | 1883069 | 5482.8 ± 0.5% | 3643.3 ± 0.8% | 488.9 ± 0.7% | 246.8 ± 0.8% | 465.6 ± 0.7% | 357.8 ± 0.8% | 1.505 | 11.214 | 22.219 | 11.777 | 15.321 |
| hex: silesia/dickens | 524290 | 43563.4 ± 0.2% | 2602.0 ± 0.6% | 1505.6 ± 0.2% | 463.3 ± 0.3% | 1577.6 ± 0.4% | 1063.2 ± 0.8% | 16.743 | 28.934 | 94.023 | 27.613 | 40.976 |
| hex: silesia/mozilla | 524290 | 43476.3 ± 0.4% | 2592.6 ± 1.3% | 1503.6 ± 0.4% | 388.7 ± 0.9% | 1566.8 ± 0.5% | 1060.7 ± 0.5% | 16.770 | 28.914 | 111.858 | 27.748 | 40.988 |
| hex: silesia/mr | 524290 | 43407.0 ± 0.9% | 2573.7 ± 0.3% | 1495.6 ± 0.3% | 594.6 ± 0.5% | 1561.8 ± 0.5% | 1057.1 ± 0.6% | 16.866 | 29.023 | 72.997 | 27.793 | 41.063 |
| hex: silesia/nci | 524290 | 43409.9 ± 0.7% | 2574.9 ± 0.7% | 1498.0 ± 0.6% | 754.5 ± 0.5% | 1558.9 ± 1.0% | 1063.1 ± 0.7% | 16.859 | 28.978 | 57.534 | 27.846 | 40.833 |
| hex: silesia/ooffice | 524290 | 43007.2 ± 0.6% | 2587.9 ± 0.4% | 1497.9 ± 0.2% | 321.1 ± 1.4% | 1565.6 ± 0.7% | 1056.8 ± 0.3% | 16.619 | 28.713 | 133.958 | 27.470 | 40.695 |
| hex: silesia/osdb | 524290 | 43524.5 ± 0.4% | 2587.2 ± 0.7% | 1503.8 ± 0.6% | 428.9 ± 1.0% | 1573.8 ± 0.5% | 1064.3 ± 0.7% | 16.823 | 28.943 | 101.476 | 27.656 | 40.896 |
| hex: silesia/reymont | 524290 | 43150.3 ± 2.3% | 2568.2 ± 0.3% | 1495.0 ± 0.7% | 479.7 ± 1.0% | 1548.4 ± 1.0% | 1055.9 ± 1.9% | 16.802 | 28.863 | 89.953 | 27.868 | 40.867 |
| hex: silesia/samba | 524290 | 43122.1 ± 1.1% | 2579.0 ± 0.7% | 1495.4 ± 0.5% | 332.3 ± 1.5% | 1567.5 ± 0.7% | 1055.1 ± 5.4% | 16.720 | 28.837 | 129.787 | 27.511 | 40.872 |
| hex: silesia/sao | 524290 | 43526.0 ± 0.6% | 2592.6 ± 0.8% | 1504.5 ± 0.7% | 269.8 ± 6.7% | 1558.2 ± 0.9% | 1061.9 ± 0.9% | 16.788 | 28.931 | 161.330 | 27.934 | 40.988 |
| hex: silesia/webster | 524290 | 43627.9 ± 0.6% | 2577.3 ± 9.1% | 1500.7 ± 0.4% | 433.4 ± 0.4% | 1562.8 ± 0.1% | 1055.5 ± 0.8% | 16.928 | 29.071 | 100.670 | 27.916 | 41.332 |
| hex: silesia/x-ray | 524290 | 43057.3 ± 1.4% | 2595.4 ± 0.7% | 1497.5 ± 5.4% | 420.7 ± 1.0% | 1561.6 ± 1.7% | 1062.1 ± 1.5% | 16.590 | 28.753 | 102.338 | 27.573 | 40.541 |
| hex: silesia/xml | 524290 | 42775.6 ± 1.4% | 2589.1 ± 0.7% | 1501.1 ± 0.4% | 687.6 ± 0.9% | 1563.0 ± 0.6% | 1056.5 ± 5.5% | 16.522 | 28.496 | 62.214 | 27.368 | 40.490 |
| hex: canterbury/alice29.txt | 304180 | 42919.3 ± 1.1% | 2600.4 ± 0.6% | 1508.7 ± 1.2% | 465.4 ± 0.2% | 1584.5 ± 0.7% | 1078.1 ± 0.9% | 16.505 | 28.447 | 92.220 | 27.088 | 39.810 |
| hex: canterbury/asyoulik.txt | 250360 | 42610.1 ± 8.8% | 2611.3 ± 0.3% | 1534.4 ± 1.6% | 452.4 ± 7.3% | 1568.1 ± 9.8% | 1056.3 ± 6.6% | 16.318 | 27.770 | 94.191 | 27.174 | 40.338 |
| hex: canterbury/cp.html | 49208 | 42377.8 ± 1.0% | 2582.6 ± 4.4% | 1516.8 ± 1.8% | 478.7 ± 6.1% | 1579.1 ± 5.8% | 1085.5 ± 1.5% | 16.409 | 27.938 | 88.527 | 26.837 | 39.041 |
| hex: canterbury/fields.c | 22302 | 41901.0 ± 0.6% | 2642.6 ± 0.5% | 1537.2 ± 1.4% | 597.2 ± 1.1% | 1597.8 ± 1.3% | 1093.7 ± 0.8% | 15.856 | 27.258 | 70.162 | 26.224 | 38.311 |
| hex: canterbury/grammar.lsp | 7444 | 39626.1 ± 0.3% | 2683.6 ± 2.4% | 1540.7 ± 5.3% | 810.5 ± 4.8% | 1601.1 ± 0.5% | 1097.6 ± 0.6% | 14.766 | 25.720 | 48.891 | 24.750 | 36.103 |
| hex: canterbury/kennedy.xls | 524290 | 43454.5 ± 0.7% | 2572.4 ± 0.7% | 1495.0 ± 0.7% | 786.9 ± 1.0% | 1569.6 ± 0.5% | 1059.9 ± 0.7% | 16.893 | 29.066 | 55.224 | 27.685 | 41.000 |
| hex: canterbury/lcet10.txt | 524290 | 43567.5 ± 0.3% | 2600.7 ± 0.7% | 1510.0 ± 0.4% | 467.2 ± 0.7% | 1555.9 ± 0.4% | 1064.5 ± 0.3% | 16.752 | 28.852 | 93.258 | 28.001 | 40.927 |
| hex: canterbury/plrabn12.txt | 524290 | 42447.8 ± 0.6% | 2601.9 ± 0.2% | 1504.9 ± 0.8% | 454.8 ± 0.5% | 1575.3 ± 0.4% | 1063.4 ± 0.3% | 16.314 | 28.207 | 93.335 | 26.947 | 39.918 |
| hex: canterbury/ptt5 | 524290 | 43492.5 ± 1.2% | 2577.4 ± 0.6% | 1494.6 ± 0.5% | 581.5 ± 1.5% | 1500.2 ± 0.6% | 1062.1 ± 0.8% | 16.874 | 29.100 | 74.796 | 28.990 | 40.950 |
| hex: canterbury/sum | 76482 | 42564.2 ± 6.6% | 2581.7 ± 0.5% | 1512.1 ± 0.3% | 559.9 ± 1.7% | 1579.6 ± 0.5% | 1083.8 ± 0.5% | 16.487 | 28.149 | 76.028 | 26.946 | 39.275 |
| hex: canterbury/xargs.1 | 8456 | 39836.6 ± 1.4% | 2667.6 ± 1.3% | 1545.4 ± 0.8% | 834.2 ± 0.3% | 1604.3 ± 0.5% | 1103.1 ± 0.6% | 14.934 | 25.778 | 47.752 | 24.831 | 36.113 |
| hex: canterbury-large/E.coli | 524290 | 43444.2 ± 0.6% | 2580.6 ± 0.7% | 1497.7 ± 4.9% | 811.0 ± 2.6% | 1567.4 ± 0.8% | 1062.9 ± 0.2% | 16.835 | 29.008 | 53.567 | 27.717 | 40.873 |
| hex: canterbury-large/bible.txt | 524290 | 43508.4 ± 0.6% | 2577.6 ± 9.5% | 1503.0 ± 0.6% | 480.5 ± 0.4% | 1558.6 ± 0.3% | 1065.9 ± 0.4% | 16.879 | 28.948 | 90.553 | 27.914 | 40.818 |
| hex: canterbury-large/world192.txt | 524290 | 43588.9 ± 0.7% | 2599.6 ± 0.5% | 1506.4 ± 0.5% | 458.3 ± 0.6% | 1570.1 ± 0.6% | 1062.5 ± 0.7% | 16.768 | 28.935 | 95.118 | 27.762 | 41.024 |
| hex: http/html-1kx1024 | 2099200 | 19956.1 ± 1.5% | 2345.3 ± 0.9% | 1460.3 ± 0.3% | 499.7 ± 0.2% | 1498.5 ± 0.6% | 1075.4 ± 6.2% | 8.509 | 13.666 | 39.939 | 13.318 | 18.557 |
| hex: http/html-16kx64 | 2097280 | 22051.7 ± 0.8% | 2232.0 ± 1.0% | 1450.9 ± 0.3% | 502.0 ± 0.4% | 1469.9 ± 0.5% | 1080.8 ± 0.6% | 9.880 | 15.199 | 43.926 | 15.002 | 20.403 |
| hex: http/html-1m | 524290 | 43570.9 ± 0.5% | 2592.6 ± 0.7% | 1500.1 ± 2.3% | 489.1 ± 0.6% | 1576.8 ± 0.9% | 1065.4 ± 0.3% | 16.806 | 29.045 | 89.079 | 27.632 | 40.897 |
| hex: http/json-1kx1024 | 2099200 | 21175.6 ± 1.2% | 2345.4 ± 1.1% | 1461.9 ± 0.5% | 694.7 ± 3.4% | 1496.3 ± 0.7% | 1077.7 ± 0.8% | 9.029 | 14.485 | 30.482 | 14.152 | 19.649 |
| hex: http/json-16kx64 | 2097280 | 21424.5 ± 5.5% | 2243.9 ± 0.5% | 1455.4 ± 1.6% | 706.6 ± 1.2% | 1471.5 ± 0.7% | 1084.1 ± 5.1% | 9.548 | 14.721 | 30.321 | 14.559 | 19.762 |
| hex: http/json-1m | 524290 | 43176.2 ± 1.9% | 2579.3 ± 7.3% | 1500.2 ± 2.4% | 732.2 ± 0.8% | 1565.7 ± 3.1% | 1066.1 ± 4.2% | 16.740 | 28.780 | 58.971 | 27.576 | 40.498 |
| hex: http/js-1kx1024 | 2099200 | 21986.7 ± 0.3% | 2333.2 ± 2.6% | 1457.6 ± 0.6% | 489.7 ± 0.3% | 1494.8 ± 1.3% | 1075.4 ± 0.9% | 9.423 | 15.084 | 44.896 | 14.709 | 20.446 |
| hex: http/js-16kx64 | 2097280 | 22105.0 ± 0.4% | 2227.2 ± 0.9% | 1445.6 ± 0.4% | 489.1 ± 0.5% | 1460.2 ± 6.1% | 1077.6 ± 0.8% | 9.925 | 15.291 | 45.199 | 15.139 | 20.513 |
| hex: http/js-1m | 524290 | 43406.7 ± 1.5% | 2588.4 ± 1.1% | 1502.5 ± 1.2% | 506.4 ± 0.4% | 1561.0 ± 6.6% | 1062.4 ± 0.4% | 16.770 | 28.889 | 85.708 | 27.808 | 40.859 |
| hex: http/css-1kx1024 | 2099200 | 20570.0 ± 0.9% | 2329.0 ± 0.8% | 1458.3 ± 3.6% | 555.7 ± 1.9% | 1506.1 ± 1.3% | 1076.7 ± 2.4% | 8.832 | 14.106 | 37.016 | 13.658 | 19.105 |
| hex: http/css-16kx64 | 2097280 | 22250.6 ± 0.5% | 2246.4 ± 0.1% | 1455.0 ± 0.9% | 563.7 ± 0.2% | 1468.5 ± 0.1% | 1083.3 ± 1.8% | 9.905 | 15.293 | 39.474 | 15.152 | 20.540 |
| hex: http/css-1m | 524290 | 43183.3 ± 5.5% | 2529.9 ± 6.9% | 1491.0 ± 2.2% | 532.9 ± 10.4% | 1564.8 ± 7.6% | 1066.4 ± 5.1% | 17.069 | 28.963 | 81.034 | 27.596 | 40.494 |
| hex: shuffled/dickens-1m | 524290 | 43274.3 ± 1.9% | 2564.8 ± 10.3% | 1494.7 ± 5.8% | 462.5 ± 0.2% | 1575.4 ± 0.5% | 1064.9 ± 0.6% | 16.873 | 28.952 | 93.568 | 27.469 | 40.636 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1782.3 ± 0.7% | 1477.2 ± 0.5% | 1025.0 ± 0.2% | 458.4 ± 0.8% | 467.2 ± 1.2% | 499.3 ± 4.7% | 1.207 | 1.739 | 3.888 | 3.815 | 3.570 |
| qlog records, JSON text sequence | 1467503 | 1707.9 ± 0.7% | 1246.4 ± 3.7% | 948.8 ± 3.1% | 420.7 ± 3.2% | 572.7 ± 0.7% | 349.9 ± 3.3% | 1.370 | 1.800 | 4.059 | 2.982 | 4.881 |
| messages: 11 string members | 1025025 | 1318.8 ± 1.2% | 1111.5 ± 1.0% | 772.1 ± 1.4% | 409.9 ± 0.7% | 443.0 ± 3.4% | 433.9 ± 1.9% | 1.187 | 1.708 | 3.218 | 2.977 | 3.039 |
| messages: 50 nested objects | 1121600 | 2002.4 ± 0.9% | 1877.2 ± 0.5% | 1340.9 ± 0.8% | 584.8 ± 1.4% | 652.8 ± 0.8% | 519.7 ± 1.0% | 1.067 | 1.493 | 3.424 | 3.068 | 3.853 |
| string: silesia/dickens | 172528 | 13346.4 ± 0.6% | 3904.6 ± 1.7% | 3071.4 ± 3.7% | 331.4 ± 1.4% | 1695.2 ± 0.5% | 1177.0 ± 0.6% | 3.418 | 4.345 | 40.274 | 7.873 | 11.340 |
| string: silesia/nci | 1075110 | 11483.4 ± 0.9% | 4691.9 ± 0.8% | 3105.9 ± 3.2% | 906.2 ± 3.7% | 1889.2 ± 2.1% | 1203.3 ± 0.9% | 2.447 | 3.697 | 12.672 | 6.079 | 9.543 |
| string: silesia/reymont | 1075159 | 5443.3 ± 2.1% | 1868.9 ± 1.1% | 1893.8 ± 0.5% | 381.8 ± 1.2% | 1442.3 ± 0.4% | 1041.5 ± 4.8% | 2.912 | 2.874 | 14.258 | 3.774 | 5.226 |
| string: silesia/samba | 97582 | 7345.6 ± 0.8% | 2708.5 ± 0.8% | 4053.0 ± 1.0% | 347.0 ± 1.2% | 1325.1 ± 0.9% | 1172.0 ± 1.2% | 2.712 | 1.812 | 21.169 | 5.544 | 6.267 |
| string: silesia/webster | 1098490 | 6914.2 ± 0.9% | 1974.0 ± 2.4% | 1745.4 ± 2.4% | 351.3 ± 0.5% | 1396.5 ± 1.1% | 602.7 ± 1.3% | 3.503 | 3.961 | 19.682 | 4.951 | 11.473 |
| string: silesia/xml | 1090118 | 11434.0 ± 1.4% | 3192.6 ± 1.4% | 2515.9 ± 1.1% | 604.7 ± 1.6% | 1932.2 ± 0.7% | 951.5 ± 1.0% | 3.581 | 4.545 | 18.907 | 5.918 | 12.016 |
| string: canterbury/alice29.txt | 159425 | 12817.2 ± 1.4% | 2892.7 ± 1.8% | 3003.1 ± 1.9% | 316.7 ± 1.4% | 1519.9 ± 0.9% | 1095.8 ± 1.0% | 4.431 | 4.268 | 40.476 | 8.433 | 11.696 |
| string: canterbury/asyoulik.txt | 132198 | 11464.9 ± 1.6% | 2075.5 ± 1.7% | 3126.3 ± 1.5% | 316.3 ± 0.6% | 1359.7 ± 1.7% | 957.2 ± 0.5% | 5.524 | 3.667 | 36.250 | 8.432 | 11.977 |
| string: canterbury/lcet10.txt | 441884 | 12883.7 ± 0.9% | 3085.2 ± 1.0% | 2546.0 ± 0.9% | 366.4 ± 0.8% | 1634.7 ± 4.7% | 1188.5 ± 1.6% | 4.176 | 5.060 | 35.167 | 7.882 | 10.841 |
| string: canterbury/plrabn12.txt | 503330 | 8870.5 ± 2.8% | 2302.5 ± 0.6% | 2093.2 ± 0.9% | 345.6 ± 2.5% | 1596.6 ± 1.9% | 1117.2 ± 0.3% | 3.853 | 4.238 | 25.663 | 5.556 | 7.940 |
| string: canterbury-large/E.coli | 1048578 | 26008.9 ± 0.2% | 16202.4 ± 0.8% | 3481.6 ± 0.4% | 1689.7 ± 0.4% | 3148.1 ± 0.6% | 1416.2 ± 0.5% | 1.605 | 7.470 | 15.392 | 8.262 | 18.365 |
| string: canterbury-large/bible.txt | 1055886 | 9898.0 ± 0.8% | 4892.1 ± 0.9% | 2990.0 ± 0.9% | 405.6 ± 1.0% | 2223.8 ± 1.1% | 1483.6 ± 0.6% | 2.023 | 3.310 | 24.402 | 4.451 | 6.672 |
| string: canterbury-large/world192.txt | 1103121 | 6495.4 ± 1.0% | 1742.1 ± 0.5% | 1880.0 ± 1.7% | 346.9 ± 0.9% | 1385.9 ± 1.2% | 962.3 ± 0.5% | 3.728 | 3.455 | 18.725 | 4.687 | 6.750 |
| string: http/html-1m | 1058582 | 10206.3 ± 0.8% | 4454.1 ± 1.8% | 2876.5 ± 0.6% | 421.0 ± 2.6% | 2158.0 ± 0.8% | 848.0 ± 0.3% | 2.291 | 3.548 | 24.243 | 4.729 | 12.035 |
| string: http/json-1m | 1190272 | 8679.7 ± 0.8% | 1583.9 ± 0.4% | 1569.4 ± 0.5% | 557.7 ± 1.1% | 1173.5 ± 1.1% | 846.1 ± 1.0% | 5.480 | 5.531 | 15.564 | 7.396 | 10.258 |
| string: http/js-1m | 1144362 | 6655.4 ± 0.7% | 1127.3 ± 1.0% | 1399.4 ± 0.6% | 332.8 ± 0.4% | 1115.3 ± 1.6% | 757.5 ± 0.4% | 5.904 | 4.756 | 19.998 | 5.967 | 8.786 |
| string: http/css-1m | 1097820 | 9326.2 ± 0.5% | 1494.3 ± 0.5% | 2293.1 ± 0.6% | 509.1 ± 0.5% | 1264.2 ± 0.7% | 880.3 ± 0.6% | 6.241 | 4.067 | 18.320 | 7.377 | 10.594 |
| string: dickens as Cyrillic and CJK | 1883069 | 5717.7 ± 0.7% | 3643.3 ± 0.8% | 488.9 ± 0.7% | 246.8 ± 0.8% | 465.6 ± 0.7% | 357.8 ± 0.8% | 1.569 | 11.695 | 23.171 | 12.281 | 15.978 |
| hex: silesia/dickens | 524290 | 43579.6 ± 0.5% | 2602.0 ± 0.6% | 1505.6 ± 0.2% | 463.3 ± 0.3% | 1577.6 ± 0.4% | 1063.2 ± 0.8% | 16.749 | 28.945 | 94.058 | 27.624 | 40.991 |
| hex: silesia/mozilla | 524290 | 43619.6 ± 0.3% | 2592.6 ± 1.3% | 1503.6 ± 0.4% | 388.7 ± 0.9% | 1566.8 ± 0.5% | 1060.7 ± 0.5% | 16.825 | 29.009 | 112.226 | 27.840 | 41.123 |
| hex: silesia/mr | 524290 | 43413.5 ± 2.9% | 2573.7 ± 0.3% | 1495.6 ± 0.3% | 594.6 ± 0.5% | 1561.8 ± 0.5% | 1057.1 ± 0.6% | 16.868 | 29.027 | 73.008 | 27.797 | 41.069 |
| hex: silesia/nci | 524290 | 43492.4 ± 7.8% | 2574.9 ± 0.7% | 1498.0 ± 0.6% | 754.5 ± 0.5% | 1558.9 ± 1.0% | 1063.1 ± 0.7% | 16.891 | 29.033 | 57.643 | 27.899 | 40.911 |
| hex: silesia/ooffice | 524290 | 43303.8 ± 4.0% | 2587.9 ± 0.4% | 1497.9 ± 0.2% | 321.1 ± 1.4% | 1565.6 ± 0.7% | 1056.8 ± 0.3% | 16.733 | 28.911 | 134.882 | 27.660 | 40.976 |
| hex: silesia/osdb | 524290 | 43466.6 ± 0.7% | 2587.2 ± 0.7% | 1503.8 ± 0.6% | 428.9 ± 1.0% | 1573.8 ± 0.5% | 1064.3 ± 0.7% | 16.800 | 28.905 | 101.341 | 27.619 | 40.842 |
| hex: silesia/reymont | 524290 | 43176.7 ± 1.1% | 2568.2 ± 0.3% | 1495.0 ± 0.7% | 479.7 ± 1.0% | 1548.4 ± 1.0% | 1055.9 ± 1.9% | 16.812 | 28.881 | 90.008 | 27.885 | 40.892 |
| hex: silesia/samba | 524290 | 43262.9 ± 1.1% | 2579.0 ± 0.7% | 1495.4 ± 0.5% | 332.3 ± 1.5% | 1567.5 ± 0.7% | 1055.1 ± 5.4% | 16.775 | 28.931 | 130.210 | 27.601 | 41.006 |
| hex: silesia/sao | 524290 | 43482.2 ± 0.8% | 2592.6 ± 0.8% | 1504.5 ± 0.7% | 269.8 ± 6.7% | 1558.2 ± 0.9% | 1061.9 ± 0.9% | 16.771 | 28.902 | 161.167 | 27.906 | 40.947 |
| hex: silesia/webster | 524290 | 43831.6 ± 0.3% | 2577.3 ± 9.1% | 1500.7 ± 0.4% | 433.4 ± 0.4% | 1562.8 ± 0.1% | 1055.5 ± 0.8% | 17.007 | 29.207 | 101.140 | 28.047 | 41.525 |
| hex: silesia/x-ray | 524290 | 43343.6 ± 0.9% | 2595.4 ± 0.7% | 1497.5 ± 5.4% | 420.7 ± 1.0% | 1561.6 ± 1.7% | 1062.1 ± 1.5% | 16.700 | 28.944 | 103.018 | 27.756 | 40.810 |
| hex: silesia/xml | 524290 | 43300.2 ± 1.0% | 2589.1 ± 0.7% | 1501.1 ± 0.4% | 687.6 ± 0.9% | 1563.0 ± 0.6% | 1056.5 ± 5.5% | 16.724 | 28.845 | 62.977 | 27.704 | 40.986 |
| hex: canterbury/alice29.txt | 304180 | 43095.3 ± 7.3% | 2600.4 ± 0.6% | 1508.7 ± 1.2% | 465.4 ± 0.2% | 1584.5 ± 0.7% | 1078.1 ± 0.9% | 16.572 | 28.564 | 92.598 | 27.199 | 39.974 |
| hex: canterbury/asyoulik.txt | 250360 | 42994.2 ± 0.3% | 2611.3 ± 0.3% | 1534.4 ± 1.6% | 452.4 ± 7.3% | 1568.1 ± 9.8% | 1056.3 ± 6.6% | 16.465 | 28.020 | 95.040 | 27.418 | 40.701 |
| hex: canterbury/cp.html | 49208 | 42253.9 ± 1.9% | 2582.6 ± 4.4% | 1516.8 ± 1.8% | 478.7 ± 6.1% | 1579.1 ± 5.8% | 1085.5 ± 1.5% | 16.361 | 27.857 | 88.268 | 26.758 | 38.926 |
| hex: canterbury/fields.c | 22302 | 41969.2 ± 2.6% | 2642.6 ± 0.5% | 1537.2 ± 1.4% | 597.2 ± 1.1% | 1597.8 ± 1.3% | 1093.7 ± 0.8% | 15.882 | 27.303 | 70.276 | 26.267 | 38.373 |
| hex: canterbury/grammar.lsp | 7444 | 39624.6 ± 2.7% | 2683.6 ± 2.4% | 1540.7 ± 5.3% | 810.5 ± 4.8% | 1601.1 ± 0.5% | 1097.6 ± 0.6% | 14.766 | 25.719 | 48.890 | 24.749 | 36.102 |
| hex: canterbury/kennedy.xls | 524290 | 43501.2 ± 0.4% | 2572.4 ± 0.7% | 1495.0 ± 0.7% | 786.9 ± 1.0% | 1569.6 ± 0.5% | 1059.9 ± 0.7% | 16.911 | 29.098 | 55.283 | 27.715 | 41.044 |
| hex: canterbury/lcet10.txt | 524290 | 43629.8 ± 0.6% | 2600.7 ± 0.7% | 1510.0 ± 0.4% | 467.2 ± 0.7% | 1555.9 ± 0.4% | 1064.5 ± 0.3% | 16.776 | 28.893 | 93.392 | 28.041 | 40.985 |
| hex: canterbury/plrabn12.txt | 524290 | 42504.5 ± 0.5% | 2601.9 ± 0.2% | 1504.9 ± 0.8% | 454.8 ± 0.5% | 1575.3 ± 0.4% | 1063.4 ± 0.3% | 16.336 | 28.244 | 93.459 | 26.983 | 39.971 |
| hex: canterbury/ptt5 | 524290 | 43545.7 ± 1.0% | 2577.4 ± 0.6% | 1494.6 ± 0.5% | 581.5 ± 1.5% | 1500.2 ± 0.6% | 1062.1 ± 0.8% | 16.895 | 29.135 | 74.887 | 29.026 | 41.000 |
| hex: canterbury/sum | 76482 | 42593.2 ± 0.7% | 2581.7 ± 0.5% | 1512.1 ± 0.3% | 559.9 ± 1.7% | 1579.6 ± 0.5% | 1083.8 ± 0.5% | 16.498 | 28.168 | 76.080 | 26.965 | 39.301 |
| hex: canterbury/xargs.1 | 8456 | 39974.9 ± 1.4% | 2667.6 ± 1.3% | 1545.4 ± 0.8% | 834.2 ± 0.3% | 1604.3 ± 0.5% | 1103.1 ± 0.6% | 14.986 | 25.867 | 47.917 | 24.917 | 36.238 |
| hex: canterbury-large/E.coli | 524290 | 43524.0 ± 0.8% | 2580.6 ± 0.7% | 1497.7 ± 4.9% | 811.0 ± 2.6% | 1567.4 ± 0.8% | 1062.9 ± 0.2% | 16.866 | 29.061 | 53.665 | 27.768 | 40.948 |
| hex: canterbury-large/bible.txt | 524290 | 43605.2 ± 1.8% | 2577.6 ± 9.5% | 1503.0 ± 0.6% | 480.5 ± 0.4% | 1558.6 ± 0.3% | 1065.9 ± 0.4% | 16.917 | 29.013 | 90.754 | 27.977 | 40.909 |
| hex: canterbury-large/world192.txt | 524290 | 43772.1 ± 0.8% | 2599.6 ± 0.5% | 1506.4 ± 0.5% | 458.3 ± 0.6% | 1570.1 ± 0.6% | 1062.5 ± 0.7% | 16.838 | 29.057 | 95.518 | 27.878 | 41.196 |
| hex: http/html-1kx1024 | 2099200 | 20249.5 ± 1.4% | 2345.3 ± 0.9% | 1460.3 ± 0.3% | 499.7 ± 0.2% | 1498.5 ± 0.6% | 1075.4 ± 6.2% | 8.634 | 13.867 | 40.526 | 13.513 | 18.830 |
| hex: http/html-16kx64 | 2097280 | 22270.1 ± 0.9% | 2232.0 ± 1.0% | 1450.9 ± 0.3% | 502.0 ± 0.4% | 1469.9 ± 0.5% | 1080.8 ± 0.6% | 9.977 | 15.349 | 44.361 | 15.151 | 20.605 |
| hex: http/html-1m | 524290 | 43690.7 ± 0.9% | 2592.6 ± 0.7% | 1500.1 ± 2.3% | 489.1 ± 0.6% | 1576.8 ± 0.9% | 1065.4 ± 0.3% | 16.852 | 29.125 | 89.324 | 27.708 | 41.009 |
| hex: http/json-1kx1024 | 2099200 | 21253.9 ± 0.8% | 2345.4 ± 1.1% | 1461.9 ± 0.5% | 694.7 ± 3.4% | 1496.3 ± 0.7% | 1077.7 ± 0.8% | 9.062 | 14.538 | 30.595 | 14.204 | 19.722 |
| hex: http/json-16kx64 | 2097280 | 21563.8 ± 1.3% | 2243.9 ± 0.5% | 1455.4 ± 1.6% | 706.6 ± 1.2% | 1471.5 ± 0.7% | 1084.1 ± 5.1% | 9.610 | 14.816 | 30.518 | 14.654 | 19.890 |
| hex: http/json-1m | 524290 | 43250.7 ± 1.7% | 2579.3 ± 7.3% | 1500.2 ± 2.4% | 732.2 ± 0.8% | 1565.7 ± 3.1% | 1066.1 ± 4.2% | 16.769 | 28.830 | 59.073 | 27.623 | 40.568 |
| hex: http/js-1kx1024 | 2099200 | 22041.8 ± 0.3% | 2333.2 ± 2.6% | 1457.6 ± 0.6% | 489.7 ± 0.3% | 1494.8 ± 1.3% | 1075.4 ± 0.9% | 9.447 | 15.122 | 45.009 | 14.746 | 20.497 |
| hex: http/js-16kx64 | 2097280 | 22132.5 ± 0.8% | 2227.2 ± 0.9% | 1445.6 ± 0.4% | 489.1 ± 0.5% | 1460.2 ± 6.1% | 1077.6 ± 0.8% | 9.938 | 15.310 | 45.255 | 15.158 | 20.538 |
| hex: http/js-1m | 524290 | 43511.7 ± 0.9% | 2588.4 ± 1.1% | 1502.5 ± 1.2% | 506.4 ± 0.4% | 1561.0 ± 6.6% | 1062.4 ± 0.4% | 16.810 | 28.959 | 85.916 | 27.875 | 40.957 |
| hex: http/css-1kx1024 | 2099200 | 20670.6 ± 1.7% | 2329.0 ± 0.8% | 1458.3 ± 3.6% | 555.7 ± 1.9% | 1506.1 ± 1.3% | 1076.7 ± 2.4% | 8.875 | 14.175 | 37.197 | 13.725 | 19.199 |
| hex: http/css-16kx64 | 2097280 | 22347.0 ± 0.2% | 2246.4 ± 0.1% | 1455.0 ± 0.9% | 563.7 ± 0.2% | 1468.5 ± 0.1% | 1083.3 ± 1.8% | 9.948 | 15.359 | 39.645 | 15.217 | 20.629 |
| hex: http/css-1m | 524290 | 42464.4 ± 11.5% | 2529.9 ± 6.9% | 1491.0 ± 2.2% | 532.9 ± 10.4% | 1564.8 ± 7.6% | 1066.4 ± 5.1% | 16.785 | 28.481 | 79.685 | 27.137 | 39.820 |
| hex: shuffled/dickens-1m | 524290 | 43458.8 ± 8.3% | 2564.8 ± 10.3% | 1494.7 ± 5.8% | 462.5 ± 0.2% | 1575.4 ± 0.5% | 1064.9 ± 0.6% | 16.945 | 29.076 | 93.967 | 27.586 | 40.810 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1142.2 ± 0.6% | 1495.1 ± 1.5% | 1104.4 ± 1.0% | 359.3 ± 0.6% | 665.6 ± 0.6% | 363.3 ± 2.2% | 0.764 | 1.034 | 3.179 | 1.716 | 3.144 |
| qlog records, JSON text sequence | 1467503 | 1013.4 ± 0.6% | 1225.8 ± 1.2% | 1116.5 ± 1.4% | 304.1 ± 0.9% | 754.1 ± 3.3% | 315.2 ± 2.1% | 0.827 | 0.908 | 3.333 | 1.344 | 3.215 |
| messages: 11 string members | 1025025 | 948.0 ± 0.6% | 1927.4 ± 3.3% | 706.3 ± 3.2% | 314.9 ± 2.2% | 509.3 ± 0.6% | 303.9 ± 1.6% | 0.492 | 1.342 | 3.010 | 1.861 | 3.119 |
| messages: 50 nested objects | 1121600 | 1223.5 ± 0.8% | 1698.4 ± 4.6% | 1436.7 ± 1.1% | 370.9 ± 2.3% | 893.7 ± 0.8% | 417.1 ± 1.6% | 0.720 | 0.852 | 3.299 | 1.369 | 2.933 |
| string: silesia/dickens | 172528 | 6690.3 ± 0.9% | 3409.0 ± 4.6% | 2822.8 ± 1.9% | 304.6 ± 1.1% | 3052.2 ± 3.0% | 572.1 ± 1.9% | 1.963 | 2.370 | 21.963 | 2.192 | 11.695 |
| string: silesia/nci | 1075110 | 5476.6 ± 0.7% | 3916.7 ± 2.7% | 2999.2 ± 0.7% | 566.1 ± 1.8% | 3640.0 ± 0.6% | 572.3 ± 2.3% | 1.398 | 1.826 | 9.674 | 1.505 | 9.570 |
| string: silesia/reymont | 1075159 | 3487.5 ± 1.4% | 3421.3 ± 0.2% | 1970.9 ± 1.8% | 328.1 ± 0.7% | 2101.7 ± 0.5% | 487.2 ± 1.9% | 1.019 | 1.770 | 10.629 | 1.659 | 7.159 |
| string: silesia/samba | 97582 | 4007.8 ± 1.2% | 3784.9 ± 0.4% | 3111.9 ± 0.9% | 313.6 ± 0.9% | 1915.0 ± 0.6% | 418.3 ± 1.0% | 1.059 | 1.288 | 12.779 | 2.093 | 9.581 |
| string: silesia/webster | 1098490 | 4419.5 ± 2.0% | 2431.5 ± 1.1% | 1727.4 ± 1.5% | 305.5 ± 1.2% | 2068.7 ± 1.4% | 464.3 ± 1.7% | 1.818 | 2.558 | 14.466 | 2.136 | 9.518 |
| string: silesia/xml | 1090118 | 6093.0 ± 15.7% | 4886.3 ± 7.1% | 2452.5 ± 3.3% | 450.5 ± 3.4% | 3302.7 ± 5.1% | 531.9 ± 3.9% | 1.247 | 2.484 | 13.525 | 1.845 | 11.454 |
| string: canterbury/alice29.txt | 159425 | 5739.9 ± 3.8% | 2727.3 ± 4.6% | 2840.5 ± 0.9% | 286.6 ± 2.1% | 2723.8 ± 3.4% | 515.2 ± 1.8% | 2.105 | 2.021 | 20.027 | 2.107 | 11.141 |
| string: canterbury/asyoulik.txt | 132198 | 4239.6 ± 1.7% | 2598.3 ± 1.0% | 2732.9 ± 2.9% | 292.4 ± 3.0% | 2372.8 ± 1.0% | 453.5 ± 1.4% | 1.632 | 1.551 | 14.497 | 1.787 | 9.349 |
| string: canterbury/lcet10.txt | 441884 | 6635.8 ± 0.6% | 3270.2 ± 1.2% | 2289.7 ± 2.3% | 322.3 ± 0.5% | 2757.9 ± 1.3% | 554.8 ± 3.3% | 2.029 | 2.898 | 20.589 | 2.406 | 11.961 |
| string: canterbury/plrabn12.txt | 503330 | 5488.4 ± 2.2% | 3175.8 ± 1.2% | 1830.0 ± 2.7% | 302.1 ± 1.3% | 2827.7 ± 2.3% | 533.3 ± 1.8% | 1.728 | 2.999 | 18.168 | 1.941 | 10.291 |
| string: canterbury-large/E.coli | 1048578 | 33959.8 ± 0.9% | 13501.0 ± 0.8% | 3391.1 ± 0.4% | 1206.6 ± 3.6% | 8871.7 ± 1.2% | 933.6 ± 2.4% | 2.515 | 10.014 | 28.144 | 3.828 | 36.374 |
| string: canterbury-large/bible.txt | 1055886 | 8458.9 ± 1.5% | 5277.8 ± 1.2% | 2770.7 ± 1.2% | 330.6 ± 1.0% | 3869.2 ± 0.9% | 626.0 ± 4.3% | 1.603 | 3.053 | 25.589 | 2.186 | 13.513 |
| string: canterbury-large/world192.txt | 1103121 | 4141.4 ± 0.5% | 2292.8 ± 0.9% | 1776.1 ± 0.8% | 313.2 ± 1.5% | 2099.5 ± 0.4% | 461.6 ± 1.9% | 1.806 | 2.332 | 13.224 | 1.973 | 8.971 |
| string: http/html-1m | 1058582 | 8774.9 ± 6.8% | 4734.4 ± 0.9% | 2659.2 ± 1.1% | 383.5 ± 1.7% | 3631.3 ± 1.3% | 591.7 ± 0.8% | 1.853 | 3.300 | 22.883 | 2.416 | 14.831 |
| string: http/json-1m | 1190272 | 3308.4 ± 1.4% | 1257.2 ± 1.5% | 2082.1 ± 2.9% | 401.6 ± 0.9% | 1345.6 ± 0.6% | 440.9 ± 1.7% | 2.631 | 1.589 | 8.237 | 2.459 | 7.503 |
| string: http/js-1m | 1144362 | 2845.1 ± 1.1% | 1601.3 ± 1.1% | 1323.0 ± 1.2% | 300.9 ± 1.3% | 1413.9 ± 1.3% | 376.4 ± 1.4% | 1.777 | 2.150 | 9.454 | 2.012 | 7.559 |
| string: http/css-1m | 1097820 | 3276.2 ± 0.6% | 2874.8 ± 0.4% | 2264.5 ± 0.9% | 399.9 ± 1.3% | 2051.6 ± 0.9% | 432.8 ± 0.9% | 1.140 | 1.447 | 8.192 | 1.597 | 7.569 |
| string: dickens as Cyrillic and CJK | 1883069 | 5813.0 ± 0.7% | 3019.0 ± 4.6% | 658.8 ± 0.8% | 323.0 ± 0.9% | 511.9 ± 1.4% | 163.1 ± 3.1% | 1.925 | 8.823 | 17.997 | 11.355 | 35.635 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1193.2 ± 0.8% | 1235.8 ± 1.3% | 1090.8 ± 1.4% | 234.7 ± 1.1% | 475.7 ± 0.5% | 227.5 ± 2.5% | 0.966 | 1.094 | 5.084 | 2.508 | 5.246 |
| hex: silesia/dickens | 524290 | 33722.0 ± 0.5% | 14972.5 ± 0.4% | 3528.4 ± 3.7% | 449.2 ± 0.9% | 8830.6 ± 0.9% | 1115.7 ± 1.2% | 2.252 | 9.557 | 75.071 | 3.819 | 30.225 |
| hex: silesia/mozilla | 524290 | 33632.9 ± 1.3% | 14973.1 ± 2.5% | 3464.3 ± 0.6% | 413.4 ± 1.5% | 8833.9 ± 0.4% | 1122.9 ± 2.2% | 2.246 | 9.708 | 81.357 | 3.807 | 29.952 |
| hex: silesia/mr | 524290 | 33822.1 ± 4.1% | 15097.1 ± 0.8% | 3487.5 ± 4.1% | 622.2 ± 0.8% | 8863.0 ± 1.2% | 1130.9 ± 1.6% | 2.240 | 9.698 | 54.359 | 3.816 | 29.908 |
| hex: silesia/nci | 524290 | 33895.4 ± 1.1% | 15076.2 ± 1.0% | 3557.9 ± 1.3% | 720.0 ± 1.2% | 8831.3 ± 4.8% | 1136.1 ± 0.4% | 2.248 | 9.527 | 47.075 | 3.838 | 29.834 |
| hex: silesia/ooffice | 524290 | 33834.0 ± 0.5% | 15019.9 ± 1.0% | 3472.9 ± 1.6% | 331.2 ± 0.7% | 8847.3 ± 1.0% | 1127.2 ± 1.7% | 2.253 | 9.742 | 102.168 | 3.824 | 30.016 |
| hex: silesia/osdb | 524290 | 33714.9 ± 0.5% | 14986.7 ± 0.8% | 3482.5 ± 0.4% | 426.5 ± 1.5% | 8842.0 ± 1.6% | 1126.3 ± 3.6% | 2.250 | 9.681 | 79.043 | 3.813 | 29.933 |
| hex: silesia/reymont | 524290 | 33693.4 ± 0.7% | 14973.1 ± 0.5% | 3526.7 ± 0.7% | 454.6 ± 0.7% | 8827.1 ± 0.4% | 1123.8 ± 4.5% | 2.250 | 9.554 | 74.113 | 3.817 | 29.983 |
| hex: silesia/samba | 524290 | 33792.1 ± 0.5% | 14959.5 ± 0.9% | 3474.3 ± 0.6% | 343.4 ± 1.0% | 8860.0 ± 5.6% | 1123.2 ± 3.4% | 2.259 | 9.726 | 98.405 | 3.814 | 30.086 |
| hex: silesia/sao | 524290 | 33848.1 ± 0.5% | 15058.0 ± 0.6% | 3467.7 ± 0.4% | 275.5 ± 0.7% | 8903.3 ± 1.1% | 1137.2 ± 0.5% | 2.248 | 9.761 | 122.874 | 3.802 | 29.764 |
| hex: silesia/webster | 524290 | 33805.3 ± 0.7% | 15018.6 ± 0.7% | 3518.1 ± 4.0% | 416.2 ± 1.1% | 8823.1 ± 1.1% | 1130.8 ± 1.4% | 2.251 | 9.609 | 81.231 | 3.831 | 29.896 |
| hex: silesia/x-ray | 524290 | 33639.5 ± 0.7% | 15000.1 ± 0.4% | 3455.5 ± 3.3% | 409.0 ± 0.6% | 8828.9 ± 0.6% | 1128.9 ± 0.8% | 2.243 | 9.735 | 82.239 | 3.810 | 29.799 |
| hex: silesia/xml | 524290 | 33710.1 ± 1.3% | 14970.3 ± 0.9% | 3536.0 ± 3.7% | 526.2 ± 1.7% | 8878.6 ± 0.6% | 1122.0 ± 1.3% | 2.252 | 9.533 | 64.061 | 3.797 | 30.045 |
| hex: canterbury/alice29.txt | 304180 | 33690.0 ± 0.8% | 14044.3 ± 0.7% | 3549.0 ± 0.6% | 457.3 ± 0.7% | 8850.8 ± 0.7% | 1134.7 ± 1.7% | 2.399 | 9.493 | 73.669 | 3.806 | 29.689 |
| hex: canterbury/asyoulik.txt | 250360 | 33694.6 ± 1.1% | 14971.5 ± 1.1% | 3487.3 ± 3.1% | 445.0 ± 1.2% | 8850.2 ± 0.4% | 1145.2 ± 2.4% | 2.251 | 9.662 | 75.725 | 3.807 | 29.421 |
| hex: canterbury/cp.html | 49208 | 33424.5 ± 0.8% | 14423.9 ± 1.1% | 3558.3 ± 1.2% | 436.4 ± 1.9% | 9236.5 ± 1.4% | 1125.9 ± 1.2% | 2.317 | 9.393 | 76.594 | 3.619 | 29.686 |
| hex: canterbury/fields.c | 22302 | 32774.9 ± 0.7% | 17408.9 ± 1.8% | 3648.7 ± 3.6% | 473.5 ± 1.6% | 9165.3 ± 0.7% | 1084.1 ± 2.5% | 1.883 | 8.983 | 69.216 | 3.576 | 30.232 |
| hex: canterbury/grammar.lsp | 7444 | 29686.2 ± 1.4% | 17169.9 ± 0.7% | 3608.6 ± 0.3% | 585.4 ± 1.1% | 8900.2 ± 0.4% | 1051.1 ± 2.7% | 1.729 | 8.227 | 50.714 | 3.335 | 28.243 |
| hex: canterbury/kennedy.xls | 524290 | 33793.7 ± 1.4% | 14940.2 ± 1.0% | 3535.6 ± 0.6% | 693.9 ± 0.6% | 8840.2 ± 1.1% | 1063.0 ± 6.7% | 2.262 | 9.558 | 48.700 | 3.823 | 31.792 |
| hex: canterbury/lcet10.txt | 524290 | 33638.8 ± 0.4% | 14929.0 ± 0.7% | 3540.7 ± 0.9% | 456.7 ± 2.1% | 8842.2 ± 0.6% | 1091.4 ± 4.0% | 2.253 | 9.501 | 73.648 | 3.804 | 30.820 |
| hex: canterbury/plrabn12.txt | 524290 | 33693.5 ± 0.7% | 14957.4 ± 0.9% | 3533.6 ± 1.3% | 440.9 ± 1.0% | 8887.3 ± 0.4% | 1115.1 ± 3.1% | 2.253 | 9.535 | 76.421 | 3.791 | 30.217 |
| hex: canterbury/ptt5 | 524290 | 33655.3 ± 0.9% | 14950.0 ± 0.5% | 3470.7 ± 0.9% | 648.2 ± 0.7% | 8846.2 ± 5.0% | 1113.1 ± 3.2% | 2.251 | 9.697 | 51.922 | 3.805 | 30.234 |
| hex: canterbury/sum | 76482 | 33110.4 ± 0.6% | 15379.4 ± 1.2% | 3550.1 ± 0.3% | 529.4 ± 3.0% | 8838.1 ± 4.2% | 1111.4 ± 2.3% | 2.153 | 9.327 | 62.539 | 3.746 | 29.792 |
| hex: canterbury/xargs.1 | 8456 | 30273.8 ± 0.8% | 17275.7 ± 5.6% | 3558.2 ± 1.2% | 553.1 ± 0.6% | 8952.4 ± 1.2% | 1089.5 ± 2.8% | 1.752 | 8.508 | 54.739 | 3.382 | 27.786 |
| hex: canterbury-large/E.coli | 524290 | 33610.7 ± 1.0% | 14916.9 ± 1.0% | 3458.6 ± 0.7% | 958.8 ± 1.0% | 8838.4 ± 0.6% | 1104.4 ± 7.9% | 2.253 | 9.718 | 35.055 | 3.803 | 30.435 |
| hex: canterbury-large/bible.txt | 524290 | 33722.6 ± 0.4% | 14982.2 ± 0.4% | 3472.2 ± 0.6% | 469.6 ± 2.3% | 8850.7 ± 0.6% | 1105.9 ± 2.7% | 2.251 | 9.712 | 71.810 | 3.810 | 30.494 |
| hex: canterbury-large/world192.txt | 524290 | 33841.3 ± 0.8% | 14998.8 ± 0.5% | 3550.8 ± 0.3% | 436.2 ± 2.3% | 8884.2 ± 0.5% | 1106.3 ± 3.4% | 2.256 | 9.531 | 77.579 | 3.809 | 30.591 |
| hex: http/html-1kx1024 | 2099200 | 15421.7 ± 1.0% | 12215.9 ± 8.0% | 3184.1 ± 0.5% | 463.2 ± 1.2% | 7425.0 ± 2.1% | 973.9 ± 1.7% | 1.262 | 4.843 | 33.294 | 2.077 | 15.835 |
| hex: http/html-16kx64 | 2097280 | 27637.2 ± 1.0% | 13865.6 ± 1.1% | 3375.5 ± 1.2% | 459.2 ± 3.6% | 8183.6 ± 8.0% | 1059.9 ± 2.1% | 1.993 | 8.188 | 60.189 | 3.377 | 26.075 |
| hex: http/html-1m | 524290 | 33699.8 ± 0.8% | 14897.5 ± 0.8% | 3468.6 ± 0.4% | 444.5 ± 0.7% | 8835.1 ± 0.6% | 1118.6 ± 5.4% | 2.262 | 9.716 | 75.809 | 3.814 | 30.126 |
| hex: http/json-1kx1024 | 2099200 | 15236.2 ± 3.6% | 12087.8 ± 0.7% | 3172.5 ± 1.0% | 618.2 ± 1.8% | 7342.1 ± 1.0% | 979.8 ± 0.6% | 1.260 | 4.803 | 24.646 | 2.075 | 15.550 |
| hex: http/json-16kx64 | 2097280 | 27700.1 ± 1.0% | 13897.6 ± 0.6% | 3404.7 ± 0.7% | 624.8 ± 0.4% | 8580.2 ± 9.2% | 1074.8 ± 3.6% | 1.993 | 8.136 | 44.331 | 3.228 | 25.773 |
| hex: http/json-1m | 524290 | 33681.9 ± 4.6% | 14981.0 ± 0.6% | 3534.2 ± 0.3% | 593.9 ± 2.7% | 8868.7 ± 1.7% | 1123.7 ± 2.6% | 2.248 | 9.530 | 56.711 | 3.798 | 29.974 |
| hex: http/js-1kx1024 | 2099200 | 15422.8 ± 1.3% | 12279.4 ± 1.8% | 3174.9 ± 0.6% | 456.4 ± 0.5% | 7412.1 ± 0.8% | 970.1 ± 2.4% | 1.256 | 4.858 | 33.794 | 2.081 | 15.899 |
| hex: http/js-16kx64 | 2097280 | 27204.7 ± 1.0% | 13892.4 ± 0.3% | 3385.8 ± 0.9% | 455.7 ± 1.0% | 8360.4 ± 1.3% | 1079.1 ± 2.9% | 1.958 | 8.035 | 59.696 | 3.254 | 25.211 |
| hex: http/js-1m | 524290 | 33808.0 ± 0.5% | 14970.9 ± 0.9% | 3538.8 ± 0.7% | 449.8 ± 0.8% | 8873.3 ± 0.6% | 1127.0 ± 1.8% | 2.258 | 9.553 | 75.165 | 3.810 | 29.998 |
| hex: http/css-1kx1024 | 2099200 | 15411.4 ± 0.8% | 12459.5 ± 1.2% | 3171.6 ± 0.5% | 503.0 ± 0.6% | 7381.7 ± 1.1% | 985.9 ± 0.9% | 1.237 | 4.859 | 30.638 | 2.088 | 15.631 |
| hex: http/css-16kx64 | 2097280 | 27591.5 ± 1.1% | 13747.7 ± 0.5% | 3401.6 ± 0.6% | 504.2 ± 0.3% | 8315.1 ± 0.9% | 1078.4 ± 1.7% | 2.007 | 8.111 | 54.721 | 3.318 | 25.586 |
| hex: http/css-1m | 524290 | 33853.2 ± 0.3% | 15022.6 ± 0.5% | 3554.3 ± 3.5% | 456.8 ± 0.6% | 8881.3 ± 4.8% | 1132.0 ± 3.7% | 2.253 | 9.524 | 74.103 | 3.812 | 29.906 |
| hex: shuffled/dickens-1m | 524290 | 33730.8 ± 1.0% | 14945.4 ± 2.1% | 3440.8 ± 3.5% | 450.2 ± 1.2% | 8860.1 ± 0.9% | 1121.2 ± 0.6% | 2.257 | 9.803 | 74.923 | 3.807 | 30.084 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1273.0 ± 1.3% | 1495.1 ± 1.5% | 1104.4 ± 1.0% | 359.3 ± 0.6% | 665.6 ± 0.6% | 363.3 ± 2.2% | 0.851 | 1.153 | 3.543 | 1.913 | 3.504 |
| qlog records, JSON text sequence | 1467503 | 1130.6 ± 0.4% | 1225.8 ± 1.2% | 1116.5 ± 1.4% | 304.1 ± 0.9% | 754.1 ± 3.3% | 315.2 ± 2.1% | 0.922 | 1.013 | 3.718 | 1.499 | 3.587 |
| messages: 11 string members | 1025025 | 1016.8 ± 0.5% | 1927.4 ± 3.3% | 706.3 ± 3.2% | 314.9 ± 2.2% | 509.3 ± 0.6% | 303.9 ± 1.6% | 0.528 | 1.440 | 3.229 | 1.996 | 3.345 |
| messages: 50 nested objects | 1121600 | 1297.4 ± 0.3% | 1698.4 ± 4.6% | 1436.7 ± 1.1% | 370.9 ± 2.3% | 893.7 ± 0.8% | 417.1 ± 1.6% | 0.764 | 0.903 | 3.498 | 1.452 | 3.110 |
| string: silesia/dickens | 172528 | 6702.2 ± 1.3% | 3409.0 ± 4.6% | 2822.8 ± 1.9% | 304.6 ± 1.1% | 3052.2 ± 3.0% | 572.1 ± 1.9% | 1.966 | 2.374 | 22.002 | 2.196 | 11.715 |
| string: silesia/nci | 1075110 | 5469.3 ± 1.2% | 3916.7 ± 2.7% | 2999.2 ± 0.7% | 566.1 ± 1.8% | 3640.0 ± 0.6% | 572.3 ± 2.3% | 1.396 | 1.824 | 9.661 | 1.503 | 9.557 |
| string: silesia/reymont | 1075159 | 3524.6 ± 3.3% | 3421.3 ± 0.2% | 1970.9 ± 1.8% | 328.1 ± 0.7% | 2101.7 ± 0.5% | 487.2 ± 1.9% | 1.030 | 1.788 | 10.742 | 1.677 | 7.235 |
| string: silesia/samba | 97582 | 4016.9 ± 0.4% | 3784.9 ± 0.4% | 3111.9 ± 0.9% | 313.6 ± 0.9% | 1915.0 ± 0.6% | 418.3 ± 1.0% | 1.061 | 1.291 | 12.808 | 2.098 | 9.602 |
| string: silesia/webster | 1098490 | 4419.1 ± 2.9% | 2431.5 ± 1.1% | 1727.4 ± 1.5% | 305.5 ± 1.2% | 2068.7 ± 1.4% | 464.3 ± 1.7% | 1.817 | 2.558 | 14.465 | 2.136 | 9.517 |
| string: silesia/xml | 1090118 | 6064.4 ± 12.0% | 4886.3 ± 7.1% | 2452.5 ± 3.3% | 450.5 ± 3.4% | 3302.7 ± 5.1% | 531.9 ± 3.9% | 1.241 | 2.473 | 13.462 | 1.836 | 11.400 |
| string: canterbury/alice29.txt | 159425 | 5772.3 ± 1.6% | 2727.3 ± 4.6% | 2840.5 ± 0.9% | 286.6 ± 2.1% | 2723.8 ± 3.4% | 515.2 ± 1.8% | 2.116 | 2.032 | 20.140 | 2.119 | 11.204 |
| string: canterbury/asyoulik.txt | 132198 | 4267.8 ± 0.6% | 2598.3 ± 1.0% | 2732.9 ± 2.9% | 292.4 ± 3.0% | 2372.8 ± 1.0% | 453.5 ± 1.4% | 1.643 | 1.562 | 14.594 | 1.799 | 9.411 |
| string: canterbury/lcet10.txt | 441884 | 6651.3 ± 1.0% | 3270.2 ± 1.2% | 2289.7 ± 2.3% | 322.3 ± 0.5% | 2757.9 ± 1.3% | 554.8 ± 3.3% | 2.034 | 2.905 | 20.637 | 2.412 | 11.989 |
| string: canterbury/plrabn12.txt | 503330 | 5499.8 ± 1.2% | 3175.8 ± 1.2% | 1830.0 ± 2.7% | 302.1 ± 1.3% | 2827.7 ± 2.3% | 533.3 ± 1.8% | 1.732 | 3.005 | 18.206 | 1.945 | 10.312 |
| string: canterbury-large/E.coli | 1048578 | 34069.4 ± 0.5% | 13501.0 ± 0.8% | 3391.1 ± 0.4% | 1206.6 ± 3.6% | 8871.7 ± 1.2% | 933.6 ± 2.4% | 2.523 | 10.047 | 28.235 | 3.840 | 36.491 |
| string: canterbury-large/bible.txt | 1055886 | 8524.7 ± 1.8% | 5277.8 ± 1.2% | 2770.7 ± 1.2% | 330.6 ± 1.0% | 3869.2 ± 0.9% | 626.0 ± 4.3% | 1.615 | 3.077 | 25.788 | 2.203 | 13.618 |
| string: canterbury-large/world192.txt | 1103121 | 4149.9 ± 0.9% | 2292.8 ± 0.9% | 1776.1 ± 0.8% | 313.2 ± 1.5% | 2099.5 ± 0.4% | 461.6 ± 1.9% | 1.810 | 2.337 | 13.251 | 1.977 | 8.990 |
| string: http/html-1m | 1058582 | 9432.9 ± 2.2% | 4734.4 ± 0.9% | 2659.2 ± 1.1% | 383.5 ± 1.7% | 3631.3 ± 1.3% | 591.7 ± 0.8% | 1.992 | 3.547 | 24.599 | 2.598 | 15.943 |
| string: http/json-1m | 1190272 | 3317.1 ± 2.0% | 1257.2 ± 1.5% | 2082.1 ± 2.9% | 401.6 ± 0.9% | 1345.6 ± 0.6% | 440.9 ± 1.7% | 2.638 | 1.593 | 8.259 | 2.465 | 7.523 |
| string: http/js-1m | 1144362 | 2850.0 ± 1.1% | 1601.3 ± 1.1% | 1323.0 ± 1.2% | 300.9 ± 1.3% | 1413.9 ± 1.3% | 376.4 ± 1.4% | 1.780 | 2.154 | 9.471 | 2.016 | 7.572 |
| string: http/css-1m | 1097820 | 3299.1 ± 1.0% | 2874.8 ± 0.4% | 2264.5 ± 0.9% | 399.9 ± 1.3% | 2051.6 ± 0.9% | 432.8 ± 0.9% | 1.148 | 1.457 | 8.249 | 1.608 | 7.622 |
| string: dickens as Cyrillic and CJK | 1883069 | 5852.0 ± 1.3% | 3019.0 ± 4.6% | 658.8 ± 0.8% | 323.0 ± 0.9% | 511.9 ± 1.4% | 163.1 ± 3.1% | 1.938 | 8.882 | 18.118 | 11.431 | 35.874 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1207.5 ± 0.6% | 1235.8 ± 1.3% | 1090.8 ± 1.4% | 234.7 ± 1.1% | 475.7 ± 0.5% | 227.5 ± 2.5% | 0.977 | 1.107 | 5.145 | 2.538 | 5.309 |
| hex: silesia/dickens | 524290 | 33728.3 ± 4.7% | 14972.5 ± 0.4% | 3528.4 ± 3.7% | 449.2 ± 0.9% | 8830.6 ± 0.9% | 1115.7 ± 1.2% | 2.253 | 9.559 | 75.085 | 3.819 | 30.231 |
| hex: silesia/mozilla | 524290 | 33732.7 ± 0.3% | 14973.1 ± 2.5% | 3464.3 ± 0.6% | 413.4 ± 1.5% | 8833.9 ± 0.4% | 1122.9 ± 2.2% | 2.253 | 9.737 | 81.598 | 3.819 | 30.041 |
| hex: silesia/mr | 524290 | 33884.2 ± 0.7% | 15097.1 ± 0.8% | 3487.5 ± 4.1% | 622.2 ± 0.8% | 8863.0 ± 1.2% | 1130.9 ± 1.6% | 2.244 | 9.716 | 54.459 | 3.823 | 29.963 |
| hex: silesia/nci | 524290 | 33913.2 ± 0.8% | 15076.2 ± 1.0% | 3557.9 ± 1.3% | 720.0 ± 1.2% | 8831.3 ± 4.8% | 1136.1 ± 0.4% | 2.249 | 9.532 | 47.100 | 3.840 | 29.850 |
| hex: silesia/ooffice | 524290 | 33765.5 ± 4.5% | 15019.9 ± 1.0% | 3472.9 ± 1.6% | 331.2 ± 0.7% | 8847.3 ± 1.0% | 1127.2 ± 1.7% | 2.248 | 9.723 | 101.961 | 3.816 | 29.956 |
| hex: silesia/osdb | 524290 | 33704.7 ± 0.4% | 14986.7 ± 0.8% | 3482.5 ± 0.4% | 426.5 ± 1.5% | 8842.0 ± 1.6% | 1126.3 ± 3.6% | 2.249 | 9.678 | 79.019 | 3.812 | 29.924 |
| hex: silesia/reymont | 524290 | 33742.3 ± 0.4% | 14973.1 ± 0.5% | 3526.7 ± 0.7% | 454.6 ± 0.7% | 8827.1 ± 0.4% | 1123.8 ± 4.5% | 2.254 | 9.568 | 74.221 | 3.823 | 30.026 |
| hex: silesia/samba | 524290 | 33765.5 ± 0.4% | 14959.5 ± 0.9% | 3474.3 ± 0.6% | 343.4 ± 1.0% | 8860.0 ± 5.6% | 1123.2 ± 3.4% | 2.257 | 9.719 | 98.328 | 3.811 | 30.062 |
| hex: silesia/sao | 524290 | 33897.2 ± 0.2% | 15058.0 ± 0.6% | 3467.7 ± 0.4% | 275.5 ± 0.7% | 8903.3 ± 1.1% | 1137.2 ± 0.5% | 2.251 | 9.775 | 123.052 | 3.807 | 29.807 |
| hex: silesia/webster | 524290 | 33690.5 ± 1.2% | 15018.6 ± 0.7% | 3518.1 ± 4.0% | 416.2 ± 1.1% | 8823.1 ± 1.1% | 1130.8 ± 1.4% | 2.243 | 9.576 | 80.956 | 3.818 | 29.794 |
| hex: silesia/x-ray | 524290 | 33703.6 ± 0.8% | 15000.1 ± 0.4% | 3455.5 ± 3.3% | 409.0 ± 0.6% | 8828.9 ± 0.6% | 1128.9 ± 0.8% | 2.247 | 9.754 | 82.396 | 3.817 | 29.856 |
| hex: silesia/xml | 524290 | 33646.0 ± 0.4% | 14970.3 ± 0.9% | 3536.0 ± 3.7% | 526.2 ± 1.7% | 8878.6 ± 0.6% | 1122.0 ± 1.3% | 2.248 | 9.515 | 63.940 | 3.790 | 29.988 |
| hex: canterbury/alice29.txt | 304180 | 33554.0 ± 3.7% | 14044.3 ± 0.7% | 3549.0 ± 0.6% | 457.3 ± 0.7% | 8850.8 ± 0.7% | 1134.7 ± 1.7% | 2.389 | 9.455 | 73.372 | 3.791 | 29.570 |
| hex: canterbury/asyoulik.txt | 250360 | 33708.2 ± 1.0% | 14971.5 ± 1.1% | 3487.3 ± 3.1% | 445.0 ± 1.2% | 8850.2 ± 0.4% | 1145.2 ± 2.4% | 2.251 | 9.666 | 75.755 | 3.809 | 29.433 |
| hex: canterbury/cp.html | 49208 | 33293.4 ± 0.9% | 14423.9 ± 1.1% | 3558.3 ± 1.2% | 436.4 ± 1.9% | 9236.5 ± 1.4% | 1125.9 ± 1.2% | 2.308 | 9.357 | 76.294 | 3.605 | 29.570 |
| hex: canterbury/fields.c | 22302 | 32796.6 ± 0.4% | 17408.9 ± 1.8% | 3648.7 ± 3.6% | 473.5 ± 1.6% | 9165.3 ± 0.7% | 1084.1 ± 2.5% | 1.884 | 8.988 | 69.262 | 3.578 | 30.252 |
| hex: canterbury/grammar.lsp | 7444 | 29649.5 ± 0.4% | 17169.9 ± 0.7% | 3608.6 ± 0.3% | 585.4 ± 1.1% | 8900.2 ± 0.4% | 1051.1 ± 2.7% | 1.727 | 8.216 | 50.651 | 3.331 | 28.208 |
| hex: canterbury/kennedy.xls | 524290 | 33774.5 ± 0.6% | 14940.2 ± 1.0% | 3535.6 ± 0.6% | 693.9 ± 0.6% | 8840.2 ± 1.1% | 1063.0 ± 6.7% | 2.261 | 9.553 | 48.672 | 3.821 | 31.774 |
| hex: canterbury/lcet10.txt | 524290 | 33794.7 ± 0.7% | 14929.0 ± 0.7% | 3540.7 ± 0.9% | 456.7 ± 2.1% | 8842.2 ± 0.6% | 1091.4 ± 4.0% | 2.264 | 9.545 | 73.990 | 3.822 | 30.963 |
| hex: canterbury/plrabn12.txt | 524290 | 33772.9 ± 0.7% | 14957.4 ± 0.9% | 3533.6 ± 1.3% | 440.9 ± 1.0% | 8887.3 ± 0.4% | 1115.1 ± 3.1% | 2.258 | 9.558 | 76.601 | 3.800 | 30.288 |
| hex: canterbury/ptt5 | 524290 | 33726.5 ± 0.3% | 14950.0 ± 0.5% | 3470.7 ± 0.9% | 648.2 ± 0.7% | 8846.2 ± 5.0% | 1113.1 ± 3.2% | 2.256 | 9.718 | 52.031 | 3.813 | 30.298 |
| hex: canterbury/sum | 76482 | 33198.4 ± 0.4% | 15379.4 ± 1.2% | 3550.1 ± 0.3% | 529.4 ± 3.0% | 8838.1 ± 4.2% | 1111.4 ± 2.3% | 2.159 | 9.351 | 62.706 | 3.756 | 29.871 |
| hex: canterbury/xargs.1 | 8456 | 30046.0 ± 4.0% | 17275.7 ± 5.6% | 3558.2 ± 1.2% | 553.1 ± 0.6% | 8952.4 ± 1.2% | 1089.5 ± 2.8% | 1.739 | 8.444 | 54.327 | 3.356 | 27.577 |
| hex: canterbury-large/E.coli | 524290 | 33714.1 ± 0.5% | 14916.9 ± 1.0% | 3458.6 ± 0.7% | 958.8 ± 1.0% | 8838.4 ± 0.6% | 1104.4 ± 7.9% | 2.260 | 9.748 | 35.163 | 3.814 | 30.528 |
| hex: canterbury-large/bible.txt | 524290 | 33744.5 ± 0.8% | 14982.2 ± 0.4% | 3472.2 ± 0.6% | 469.6 ± 2.3% | 8850.7 ± 0.6% | 1105.9 ± 2.7% | 2.252 | 9.718 | 71.857 | 3.813 | 30.514 |
| hex: canterbury-large/world192.txt | 524290 | 33780.9 ± 4.4% | 14998.8 ± 0.5% | 3550.8 ± 0.3% | 436.2 ± 2.3% | 8884.2 ± 0.5% | 1106.3 ± 3.4% | 2.252 | 9.514 | 77.440 | 3.802 | 30.536 |
| hex: http/html-1kx1024 | 2099200 | 15001.2 ± 1.3% | 12215.9 ± 8.0% | 3184.1 ± 0.5% | 463.2 ± 1.2% | 7425.0 ± 2.1% | 973.9 ± 1.7% | 1.228 | 4.711 | 32.386 | 2.020 | 15.403 |
| hex: http/html-16kx64 | 2097280 | 27652.8 ± 1.0% | 13865.6 ± 1.1% | 3375.5 ± 1.2% | 459.2 ± 3.6% | 8183.6 ± 8.0% | 1059.9 ± 2.1% | 1.994 | 8.192 | 60.223 | 3.379 | 26.089 |
| hex: http/html-1m | 524290 | 33697.2 ± 0.5% | 14897.5 ± 0.8% | 3468.6 ± 0.4% | 444.5 ± 0.7% | 8835.1 ± 0.6% | 1118.6 ± 5.4% | 2.262 | 9.715 | 75.803 | 3.814 | 30.124 |
| hex: http/json-1kx1024 | 2099200 | 14890.6 ± 1.2% | 12087.8 ± 0.7% | 3172.5 ± 1.0% | 618.2 ± 1.8% | 7342.1 ± 1.0% | 979.8 ± 0.6% | 1.232 | 4.694 | 24.087 | 2.028 | 15.197 |
| hex: http/json-16kx64 | 2097280 | 27719.0 ± 1.5% | 13897.6 ± 0.6% | 3404.7 ± 0.7% | 624.8 ± 0.4% | 8580.2 ± 9.2% | 1074.8 ± 3.6% | 1.995 | 8.141 | 44.362 | 3.231 | 25.790 |
| hex: http/json-1m | 524290 | 33778.2 ± 4.8% | 14981.0 ± 0.6% | 3534.2 ± 0.3% | 593.9 ± 2.7% | 8868.7 ± 1.7% | 1123.7 ± 2.6% | 2.255 | 9.557 | 56.873 | 3.809 | 30.059 |
| hex: http/js-1kx1024 | 2099200 | 15002.9 ± 0.2% | 12279.4 ± 1.8% | 3174.9 ± 0.6% | 456.4 ± 0.5% | 7412.1 ± 0.8% | 970.1 ± 2.4% | 1.222 | 4.725 | 32.874 | 2.024 | 15.466 |
| hex: http/js-16kx64 | 2097280 | 27174.4 ± 0.7% | 13892.4 ± 0.3% | 3385.8 ± 0.9% | 455.7 ± 1.0% | 8360.4 ± 1.3% | 1079.1 ± 2.9% | 1.956 | 8.026 | 59.629 | 3.250 | 25.183 |
| hex: http/js-1m | 524290 | 33794.9 ± 0.8% | 14970.9 ± 0.9% | 3538.8 ± 0.7% | 449.8 ± 0.8% | 8873.3 ± 0.6% | 1127.0 ± 1.8% | 2.257 | 9.550 | 75.135 | 3.809 | 29.986 |
| hex: http/css-1kx1024 | 2099200 | 14999.9 ± 0.5% | 12459.5 ± 1.2% | 3171.6 ± 0.5% | 503.0 ± 0.6% | 7381.7 ± 1.1% | 985.9 ± 0.9% | 1.204 | 4.729 | 29.820 | 2.032 | 15.214 |
| hex: http/css-16kx64 | 2097280 | 27608.1 ± 0.4% | 13747.7 ± 0.5% | 3401.6 ± 0.6% | 504.2 ± 0.3% | 8315.1 ± 0.9% | 1078.4 ± 1.7% | 2.008 | 8.116 | 54.754 | 3.320 | 25.601 |
| hex: http/css-1m | 524290 | 33785.4 ± 0.8% | 15022.6 ± 0.5% | 3554.3 ± 3.5% | 456.8 ± 0.6% | 8881.3 ± 4.8% | 1132.0 ± 3.7% | 2.249 | 9.505 | 73.955 | 3.804 | 29.846 |
| hex: shuffled/dickens-1m | 524290 | 33783.9 ± 1.4% | 14945.4 ± 2.1% | 3440.8 ± 3.5% | 450.2 ± 1.2% | 8860.1 ± 0.9% | 1121.2 ± 0.6% | 2.260 | 9.819 | 75.041 | 3.813 | 30.132 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1584.0 ± 4.3% | 1477.2 ± 0.5% | 1025.0 ± 0.2% | 458.4 ± 0.8% | 467.2 ± 1.2% | 499.3 ± 4.7% | 1.072 | 1.545 | 3.455 | 3.391 | 3.173 |
| qlog records, JSON text sequence | 1467503 | 1443.0 ± 0.7% | 1246.4 ± 3.7% | 948.8 ± 3.1% | 420.7 ± 3.2% | 572.7 ± 0.7% | 349.9 ± 3.3% | 1.158 | 1.521 | 3.430 | 2.520 | 4.124 |
| messages: 11 string members | 1025025 | 1277.3 ± 0.7% | 1111.5 ± 1.0% | 772.1 ± 1.4% | 409.9 ± 0.7% | 443.0 ± 3.4% | 433.9 ± 1.9% | 1.149 | 1.654 | 3.116 | 2.883 | 2.943 |
| messages: 50 nested objects | 1121600 | 1705.1 ± 0.3% | 1877.2 ± 0.5% | 1340.9 ± 0.8% | 584.8 ± 1.4% | 652.8 ± 0.8% | 519.7 ± 1.0% | 0.908 | 1.272 | 2.916 | 2.612 | 3.281 |
| string: silesia/dickens | 172528 | 12972.1 ± 1.6% | 3904.6 ± 1.7% | 3071.4 ± 3.7% | 331.4 ± 1.4% | 1695.2 ± 0.5% | 1177.0 ± 0.6% | 3.322 | 4.223 | 39.144 | 7.652 | 11.022 |
| string: silesia/nci | 1075110 | 11138.9 ± 4.3% | 4691.9 ± 0.8% | 3105.9 ± 3.2% | 906.2 ± 3.7% | 1889.2 ± 2.1% | 1203.3 ± 0.9% | 2.374 | 3.586 | 12.292 | 5.896 | 9.257 |
| string: silesia/reymont | 1075159 | 5386.7 ± 0.3% | 1868.9 ± 1.1% | 1893.8 ± 0.5% | 381.8 ± 1.2% | 1442.3 ± 0.4% | 1041.5 ± 4.8% | 2.882 | 2.844 | 14.110 | 3.735 | 5.172 |
| string: silesia/samba | 97582 | 6333.9 ± 0.6% | 2708.5 ± 0.8% | 4053.0 ± 1.0% | 347.0 ± 1.2% | 1325.1 ± 0.9% | 1172.0 ± 1.2% | 2.339 | 1.563 | 18.253 | 4.780 | 5.404 |
| string: silesia/webster | 1098490 | 7043.7 ± 0.7% | 1974.0 ± 2.4% | 1745.4 ± 2.4% | 351.3 ± 0.5% | 1396.5 ± 1.1% | 602.7 ± 1.3% | 3.568 | 4.036 | 20.050 | 5.044 | 11.687 |
| string: silesia/xml | 1090118 | 11104.7 ± 1.1% | 3192.6 ± 1.4% | 2515.9 ± 1.1% | 604.7 ± 1.6% | 1932.2 ± 0.7% | 951.5 ± 1.0% | 3.478 | 4.414 | 18.363 | 5.747 | 11.670 |
| string: canterbury/alice29.txt | 159425 | 12390.3 ± 0.9% | 2892.7 ± 1.8% | 3003.1 ± 1.9% | 316.7 ± 1.4% | 1519.9 ± 0.9% | 1095.8 ± 1.0% | 4.283 | 4.126 | 39.128 | 8.152 | 11.307 |
| string: canterbury/asyoulik.txt | 132198 | 11273.9 ± 0.3% | 2075.5 ± 1.7% | 3126.3 ± 1.5% | 316.3 ± 0.6% | 1359.7 ± 1.7% | 957.2 ± 0.5% | 5.432 | 3.606 | 35.646 | 8.292 | 11.778 |
| string: canterbury/lcet10.txt | 441884 | 12777.2 ± 1.9% | 3085.2 ± 1.0% | 2546.0 ± 0.9% | 366.4 ± 0.8% | 1634.7 ± 4.7% | 1188.5 ± 1.6% | 4.141 | 5.018 | 34.876 | 7.816 | 10.751 |
| string: canterbury/plrabn12.txt | 503330 | 8988.5 ± 1.0% | 2302.5 ± 0.6% | 2093.2 ± 0.9% | 345.6 ± 2.5% | 1596.6 ± 1.9% | 1117.2 ± 0.3% | 3.904 | 4.294 | 26.005 | 5.630 | 8.046 |
| string: canterbury-large/E.coli | 1048578 | 26008.3 ± 0.3% | 16202.4 ± 0.8% | 3481.6 ± 0.4% | 1689.7 ± 0.4% | 3148.1 ± 0.6% | 1416.2 ± 0.5% | 1.605 | 7.470 | 15.392 | 8.262 | 18.365 |
| string: canterbury-large/bible.txt | 1055886 | 9786.6 ± 1.0% | 4892.1 ± 0.9% | 2990.0 ± 0.9% | 405.6 ± 1.0% | 2223.8 ± 1.1% | 1483.6 ± 0.6% | 2.000 | 3.273 | 24.128 | 4.401 | 6.596 |
| string: canterbury-large/world192.txt | 1103121 | 6702.7 ± 1.3% | 1742.1 ± 0.5% | 1880.0 ± 1.7% | 346.9 ± 0.9% | 1385.9 ± 1.2% | 962.3 ± 0.5% | 3.847 | 3.565 | 19.323 | 4.836 | 6.965 |
| string: http/html-1m | 1058582 | 10156.4 ± 1.6% | 4454.1 ± 1.8% | 2876.5 ± 0.6% | 421.0 ± 2.6% | 2158.0 ± 0.8% | 848.0 ± 0.3% | 2.280 | 3.531 | 24.125 | 4.706 | 11.976 |
| string: http/json-1m | 1190272 | 8501.8 ± 0.2% | 1583.9 ± 0.4% | 1569.4 ± 0.5% | 557.7 ± 1.1% | 1173.5 ± 1.1% | 846.1 ± 1.0% | 5.368 | 5.417 | 15.245 | 7.245 | 10.048 |
| string: http/js-1m | 1144362 | 6585.1 ± 1.1% | 1127.3 ± 1.0% | 1399.4 ± 0.6% | 332.8 ± 0.4% | 1115.3 ± 1.6% | 757.5 ± 0.4% | 5.841 | 4.706 | 19.786 | 5.904 | 8.693 |
| string: http/css-1m | 1097820 | 9161.7 ± 1.3% | 1494.3 ± 0.5% | 2293.1 ± 0.6% | 509.1 ± 0.5% | 1264.2 ± 0.7% | 880.3 ± 0.6% | 6.131 | 3.995 | 17.997 | 7.247 | 10.407 |
| string: dickens as Cyrillic and CJK | 1883069 | 5445.0 ± 0.4% | 3643.3 ± 0.8% | 488.9 ± 0.7% | 246.8 ± 0.8% | 465.6 ± 0.7% | 357.8 ± 0.8% | 1.495 | 11.137 | 22.066 | 11.696 | 15.216 |
| hex: silesia/dickens | 524290 | 43588.5 ± 3.7% | 2602.0 ± 0.6% | 1505.6 ± 0.2% | 463.3 ± 0.3% | 1577.6 ± 0.4% | 1063.2 ± 0.8% | 16.752 | 28.951 | 94.077 | 27.629 | 40.999 |
| hex: silesia/mozilla | 524290 | 43634.1 ± 0.5% | 2592.6 ± 1.3% | 1503.6 ± 0.4% | 388.7 ± 0.9% | 1566.8 ± 0.5% | 1060.7 ± 0.5% | 16.830 | 29.019 | 112.264 | 27.849 | 41.137 |
| hex: silesia/mr | 524290 | 43385.1 ± 0.7% | 2573.7 ± 0.3% | 1495.6 ± 0.3% | 594.6 ± 0.5% | 1561.8 ± 0.5% | 1057.1 ± 0.6% | 16.857 | 29.008 | 72.960 | 27.779 | 41.042 |
| hex: silesia/nci | 524290 | 43604.3 ± 1.6% | 2574.9 ± 0.7% | 1498.0 ± 0.6% | 754.5 ± 0.5% | 1558.9 ± 1.0% | 1063.1 ± 0.7% | 16.934 | 29.108 | 57.791 | 27.970 | 41.016 |
| hex: silesia/ooffice | 524290 | 43285.8 ± 1.0% | 2587.9 ± 0.4% | 1497.9 ± 0.2% | 321.1 ± 1.4% | 1565.6 ± 0.7% | 1056.8 ± 0.3% | 16.726 | 28.899 | 134.825 | 27.648 | 40.959 |
| hex: silesia/osdb | 524290 | 43508.8 ± 1.5% | 2587.2 ± 0.7% | 1503.8 ± 0.6% | 428.9 ± 1.0% | 1573.8 ± 0.5% | 1064.3 ± 0.7% | 16.817 | 28.933 | 101.439 | 27.646 | 40.881 |
| hex: silesia/reymont | 524290 | 43139.5 ± 1.4% | 2568.2 ± 0.3% | 1495.0 ± 0.7% | 479.7 ± 1.0% | 1548.4 ± 1.0% | 1055.9 ± 1.9% | 16.798 | 28.856 | 89.930 | 27.861 | 40.857 |
| hex: silesia/samba | 524290 | 43041.4 ± 1.3% | 2579.0 ± 0.7% | 1495.4 ± 0.5% | 332.3 ± 1.5% | 1567.5 ± 0.7% | 1055.1 ± 5.4% | 16.689 | 28.783 | 129.544 | 27.459 | 40.796 |
| hex: silesia/sao | 524290 | 43490.2 ± 0.8% | 2592.6 ± 0.8% | 1504.5 ± 0.7% | 269.8 ± 6.7% | 1558.2 ± 0.9% | 1061.9 ± 0.9% | 16.775 | 28.907 | 161.197 | 27.911 | 40.954 |
| hex: silesia/webster | 524290 | 43701.0 ± 0.2% | 2577.3 ± 9.1% | 1500.7 ± 0.4% | 433.4 ± 0.4% | 1562.8 ± 0.1% | 1055.5 ± 0.8% | 16.956 | 29.120 | 100.839 | 27.963 | 41.402 |
| hex: silesia/x-ray | 524290 | 43285.4 ± 1.9% | 2595.4 ± 0.7% | 1497.5 ± 5.4% | 420.7 ± 1.0% | 1561.6 ± 1.7% | 1062.1 ± 1.5% | 16.678 | 28.905 | 102.880 | 27.719 | 40.756 |
| hex: silesia/xml | 524290 | 43071.4 ± 1.1% | 2589.1 ± 0.7% | 1501.1 ± 0.4% | 687.6 ± 0.9% | 1563.0 ± 0.6% | 1056.5 ± 5.5% | 16.636 | 28.693 | 62.644 | 27.558 | 40.769 |
| hex: canterbury/alice29.txt | 304180 | 43269.1 ± 1.6% | 2600.4 ± 0.6% | 1508.7 ± 1.2% | 465.4 ± 0.2% | 1584.5 ± 0.7% | 1078.1 ± 0.9% | 16.639 | 28.679 | 92.971 | 27.308 | 40.135 |
| hex: canterbury/asyoulik.txt | 250360 | 42824.4 ± 1.9% | 2611.3 ± 0.3% | 1534.4 ± 1.6% | 452.4 ± 7.3% | 1568.1 ± 9.8% | 1056.3 ± 6.6% | 16.400 | 27.910 | 94.665 | 27.310 | 40.540 |
| hex: canterbury/cp.html | 49208 | 42454.2 ± 0.8% | 2582.6 ± 4.4% | 1516.8 ± 1.8% | 478.7 ± 6.1% | 1579.1 ± 5.8% | 1085.5 ± 1.5% | 16.438 | 27.989 | 88.686 | 26.885 | 39.111 |
| hex: canterbury/fields.c | 22302 | 42184.9 ± 1.2% | 2642.6 ± 0.5% | 1537.2 ± 1.4% | 597.2 ± 1.1% | 1597.8 ± 1.3% | 1093.7 ± 0.8% | 15.964 | 27.443 | 70.637 | 26.402 | 38.570 |
| hex: canterbury/grammar.lsp | 7444 | 40443.6 ± 7.0% | 2683.6 ± 2.4% | 1540.7 ± 5.3% | 810.5 ± 4.8% | 1601.1 ± 0.5% | 1097.6 ± 0.6% | 15.071 | 26.251 | 49.900 | 25.260 | 36.848 |
| hex: canterbury/kennedy.xls | 524290 | 43338.8 ± 0.6% | 2572.4 ± 0.7% | 1495.0 ± 0.7% | 786.9 ± 1.0% | 1569.6 ± 0.5% | 1059.9 ± 0.7% | 16.848 | 28.989 | 55.077 | 27.611 | 40.891 |
| hex: canterbury/lcet10.txt | 524290 | 43435.7 ± 0.9% | 2600.7 ± 0.7% | 1510.0 ± 0.4% | 467.2 ± 0.7% | 1555.9 ± 0.4% | 1064.5 ± 0.3% | 16.702 | 28.765 | 92.976 | 27.917 | 40.803 |
| hex: canterbury/plrabn12.txt | 524290 | 42558.4 ± 0.6% | 2601.9 ± 0.2% | 1504.9 ± 0.8% | 454.8 ± 0.5% | 1575.3 ± 0.4% | 1063.4 ± 0.3% | 16.357 | 28.280 | 93.578 | 27.017 | 40.022 |
| hex: canterbury/ptt5 | 524290 | 43445.1 ± 1.4% | 2577.4 ± 0.6% | 1494.6 ± 0.5% | 581.5 ± 1.5% | 1500.2 ± 0.6% | 1062.1 ± 0.8% | 16.856 | 29.068 | 74.714 | 28.959 | 40.905 |
| hex: canterbury/sum | 76482 | 42436.0 ± 7.0% | 2581.7 ± 0.5% | 1512.1 ± 0.3% | 559.9 ± 1.7% | 1579.6 ± 0.5% | 1083.8 ± 0.5% | 16.437 | 28.064 | 75.799 | 26.865 | 39.156 |
| hex: canterbury/xargs.1 | 8456 | 40777.0 ± 2.1% | 2667.6 ± 1.3% | 1545.4 ± 0.8% | 834.2 ± 0.3% | 1604.3 ± 0.5% | 1103.1 ± 0.6% | 15.286 | 26.387 | 48.879 | 25.417 | 36.965 |
| hex: canterbury-large/E.coli | 524290 | 43557.2 ± 1.0% | 2580.6 ± 0.7% | 1497.7 ± 4.9% | 811.0 ± 2.6% | 1567.4 ± 0.8% | 1062.9 ± 0.2% | 16.879 | 29.083 | 53.706 | 27.789 | 40.980 |
| hex: canterbury-large/bible.txt | 524290 | 43482.1 ± 0.7% | 2577.6 ± 9.5% | 1503.0 ± 0.6% | 480.5 ± 0.4% | 1558.6 ± 0.3% | 1065.9 ± 0.4% | 16.869 | 28.931 | 90.498 | 27.898 | 40.793 |
| hex: canterbury-large/world192.txt | 524290 | 43744.3 ± 3.0% | 2599.6 ± 0.5% | 1506.4 ± 0.5% | 458.3 ± 0.6% | 1570.1 ± 0.6% | 1062.5 ± 0.7% | 16.827 | 29.039 | 95.457 | 27.861 | 41.170 |
| hex: http/html-1kx1024 | 2099200 | 20328.2 ± 1.5% | 2345.3 ± 0.9% | 1460.3 ± 0.3% | 499.7 ± 0.2% | 1498.5 ± 0.6% | 1075.4 ± 6.2% | 8.668 | 13.921 | 40.684 | 13.566 | 18.903 |
| hex: http/html-16kx64 | 2097280 | 22207.2 ± 2.0% | 2232.0 ± 1.0% | 1450.9 ± 0.3% | 502.0 ± 0.4% | 1469.9 ± 0.5% | 1080.8 ± 0.6% | 9.949 | 15.306 | 44.236 | 15.108 | 20.547 |
| hex: http/html-1m | 524290 | 43573.4 ± 1.0% | 2592.6 ± 0.7% | 1500.1 ± 2.3% | 489.1 ± 0.6% | 1576.8 ± 0.9% | 1065.4 ± 0.3% | 16.807 | 29.047 | 89.084 | 27.633 | 40.899 |
| hex: http/json-1kx1024 | 2099200 | 21384.3 ± 0.2% | 2345.4 ± 1.1% | 1461.9 ± 0.5% | 694.7 ± 3.4% | 1496.3 ± 0.7% | 1077.7 ± 0.8% | 9.118 | 14.627 | 30.782 | 14.291 | 19.843 |
| hex: http/json-16kx64 | 2097280 | 21527.5 ± 3.1% | 2243.9 ± 0.5% | 1455.4 ± 1.6% | 706.6 ± 1.2% | 1471.5 ± 0.7% | 1084.1 ± 5.1% | 9.594 | 14.792 | 30.467 | 14.629 | 19.857 |
| hex: http/json-1m | 524290 | 43155.8 ± 2.4% | 2579.3 ± 7.3% | 1500.2 ± 2.4% | 732.2 ± 0.8% | 1565.7 ± 3.1% | 1066.1 ± 4.2% | 16.732 | 28.766 | 58.944 | 27.563 | 40.479 |
| hex: http/js-1kx1024 | 2099200 | 22140.7 ± 0.8% | 2333.2 ± 2.6% | 1457.6 ± 0.6% | 489.7 ± 0.3% | 1494.8 ± 1.3% | 1075.4 ± 0.9% | 9.489 | 15.190 | 45.211 | 14.812 | 20.589 |
| hex: http/js-16kx64 | 2097280 | 22192.5 ± 0.5% | 2227.2 ± 0.9% | 1445.6 ± 0.4% | 489.1 ± 0.5% | 1460.2 ± 6.1% | 1077.6 ± 0.8% | 9.964 | 15.352 | 45.378 | 15.199 | 20.594 |
| hex: http/js-1m | 524290 | 43563.4 ± 0.7% | 2588.4 ± 1.1% | 1502.5 ± 1.2% | 506.4 ± 0.4% | 1561.0 ± 6.6% | 1062.4 ± 0.4% | 16.830 | 28.994 | 86.018 | 27.908 | 41.006 |
| hex: http/css-1kx1024 | 2099200 | 20663.4 ± 1.0% | 2329.0 ± 0.8% | 1458.3 ± 3.6% | 555.7 ± 1.9% | 1506.1 ± 1.3% | 1076.7 ± 2.4% | 8.872 | 14.170 | 37.184 | 13.720 | 19.192 |
| hex: http/css-16kx64 | 2097280 | 22364.4 ± 1.1% | 2246.4 ± 0.1% | 1455.0 ± 0.9% | 563.7 ± 0.2% | 1468.5 ± 0.1% | 1083.3 ± 1.8% | 9.956 | 15.371 | 39.676 | 15.229 | 20.645 |
| hex: http/css-1m | 524290 | 42613.8 ± 2.9% | 2529.9 ± 6.9% | 1491.0 ± 2.2% | 532.9 ± 10.4% | 1564.8 ± 7.6% | 1066.4 ± 5.1% | 16.844 | 28.581 | 79.965 | 27.232 | 39.960 |
| hex: shuffled/dickens-1m | 524290 | 43550.8 ± 0.9% | 2564.8 ± 10.3% | 1494.7 ± 5.8% | 462.5 ± 0.2% | 1575.4 ± 0.5% | 1064.9 ± 0.6% | 16.980 | 29.137 | 94.166 | 27.644 | 40.896 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.918 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.885 of simdjson.
- messages: 11 string members, decoding: stdx runs at 0.555 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.781 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.923 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.764 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.827 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.908 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.492 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.720 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.852 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.851 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.922 of simdjson.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.528 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.764 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.903 of yyjson.
- messages: 50 nested objects, encoding through TextWriter's methods: stdx runs at 0.908 of simdjson.
