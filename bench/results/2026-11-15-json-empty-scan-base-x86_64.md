# bench-json

| Field | Value |
|---|---|
| Commit | e59f48c |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.127.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1014-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43674612420 |
| Date | 2026-11-15 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1377.7 ± 1.0% | 0.490 | 1.026 | 1.065 | 1.069 | 0.411 | 1.073 | 1.069 | 0.371 | 0.832 | 0.929 | 0.105 |
| qlog records, JSON text sequence | 1467503 | 1104.4 ± 0.7% | 0.790 | 1.058 | 1.063 | 1.059 | 0.392 | 1.056 | 1.057 | 0.364 | 0.908 | 1.040 | 0.125 |
| messages: 11 string members | 1025025 | 1080.4 ± 0.5% | 0.581 | 1.002 | 1.040 | 1.019 | 0.541 | 1.012 | 1.017 | 0.538 | 0.884 | 0.952 | 0.136 |
| messages: 50 nested objects | 1121600 | 1341.7 ± 0.4% | 0.805 | 1.089 | 1.089 | 1.090 | 0.397 | 1.098 | 1.089 | 0.352 | 0.924 | 0.968 | 0.114 |
| messages: a tree of 341 objects | 612600 | 669.8 ± 1.1% | 0.815 | 1.043 | 1.027 | 1.026 | 0.264 | 1.018 | 1.029 | 0.219 | 0.817 | 0.975 | 0.117 |
| string: silesia/dickens | 172528 | 6653.9 ± 0.4% | 0.029 | 0.707 | 1.087 | 1.095 | 0.209 | 1.045 | 1.113 | 0.209 | 1.011 | 1.010 | 0.029 |
| string: silesia/nci | 1075110 | 5411.5 ± 0.4% | 0.035 | 0.732 | 1.040 | 1.038 | 0.308 | 1.044 | 1.038 | 0.308 | 1.008 | 1.012 | 0.036 |
| string: silesia/reymont | 1075159 | 3535.4 ± 1.2% | 0.055 | 0.622 | 0.878 | 0.869 | 0.355 | 0.819 | 0.872 | 0.356 | 0.981 | 0.988 | 0.055 |
| string: silesia/samba | 97582 | 3952.0 ± 0.6% | 0.042 | 0.914 | 1.070 | 1.069 | 0.075 | 0.863 | 1.071 | 0.075 | 1.008 | 1.011 | 0.042 |
| string: silesia/webster | 1098490 | 4352.5 ± 1.4% | 0.043 | 0.655 | 0.990 | 1.003 | 0.231 | 0.941 | 1.009 | 0.231 | 1.008 | 1.017 | 0.043 |
| string: silesia/xml | 1090118 | 6061.7 ± 3.0% | 0.032 | 0.784 | 0.960 | 0.975 | 0.252 | 0.955 | 0.977 | 0.252 | 1.009 | 1.012 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5754.0 ± 0.9% | 0.033 | 0.758 | 1.098 | 1.121 | 0.186 | 1.022 | 1.156 | 0.186 | 1.013 | 1.016 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 4287.9 ± 0.9% | 0.043 | 0.799 | 1.138 | 1.136 | 0.201 | 1.060 | 1.141 | 0.201 | 1.006 | 1.013 | 0.043 |
| string: canterbury/lcet10.txt | 441884 | 6578.8 ± 0.6% | 0.029 | 0.614 | 1.108 | 1.117 | 0.203 | 1.045 | 1.131 | 0.203 | 1.015 | 1.014 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 5399.8 ± 1.0% | 0.035 | 0.779 | 0.982 | 0.989 | 0.233 | 0.878 | 0.990 | 0.233 | 1.013 | 1.015 | 0.035 |
| string: canterbury-large/E.coli | 1048578 | 31259.5 ± 3.4% | 0.058 | 1.005 | 0.763 | 1.006 | 0.508 | 1.004 | 1.005 | 0.509 | 1.087 | 1.090 | 0.007 |
| string: canterbury-large/bible.txt | 1055886 | 8640.7 ± 0.4% | 0.023 | 0.615 | 0.864 | 0.871 | 0.397 | 0.878 | 0.885 | 0.398 | 1.004 | 1.011 | 0.023 |
| string: canterbury-large/world192.txt | 1103121 | 4143.7 ± 0.4% | 0.045 | 0.694 | 0.974 | 0.984 | 0.218 | 0.935 | 0.994 | 0.219 | 1.004 | 1.008 | 0.045 |
| string: http/html-1m | 1058582 | 9093.8 ± 2.6% | 0.022 | 0.567 | 0.787 | 0.790 | 0.323 | 0.752 | 0.798 | 0.322 | 0.975 | 1.051 | 0.022 |
| string: http/json-1m | 1190272 | 3340.6 ± 0.5% | 0.052 | 0.394 | 0.440 | 0.444 | 0.149 | 0.456 | 0.444 | 0.149 | 1.007 | 1.010 | 0.052 |
| string: http/js-1m | 1144362 | 2830.4 ± 0.3% | 0.063 | 0.707 | 0.904 | 0.934 | 0.196 | 0.857 | 0.935 | 0.196 | 1.008 | 1.009 | 0.063 |
| string: http/css-1m | 1097820 | 3298.1 ± 0.4% | 0.055 | 0.780 | 0.967 | 1.035 | 0.291 | 1.001 | 1.039 | 0.291 | 1.008 | 1.010 | 0.055 |
| string: dickens as Cyrillic and CJK | 1883069 | 5834.8 ± 0.6% | 0.025 | 0.063 | 0.447 | 0.447 | 0.200 | 0.445 | 0.448 | 0.200 | 0.997 | 1.005 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1205.6 ± 1.2% | 0.112 | 1.002 | 0.999 | 0.999 | 0.106 | 0.712 | 1.001 | 0.106 | 1.006 | 1.009 | 0.112 |
| hex: silesia/dickens | 524290 | 46049.3 ± 0.1% | 0.040 | 0.997 | 0.619 | 0.996 | 0.393 | 0.999 | 0.997 | 0.393 | 0.737 | 0.737 | 0.005 |
| hex: silesia/mozilla | 524290 | 45809.9 ± 1.1% | 0.040 | 0.993 | 0.624 | 0.994 | 0.388 | 0.996 | 0.994 | 0.389 | 0.740 | 0.740 | 0.005 |
| hex: silesia/mr | 524290 | 44938.4 ± 0.4% | 0.041 | 0.999 | 0.636 | 0.998 | 0.394 | 1.000 | 0.998 | 0.394 | 0.756 | 0.755 | 0.005 |
| hex: silesia/nci | 524290 | 45767.5 ± 0.5% | 0.040 | 0.998 | 0.614 | 0.995 | 0.394 | 0.998 | 0.996 | 0.395 | 0.740 | 0.741 | 0.005 |
| hex: silesia/ooffice | 524290 | 46464.7 ± 2.7% | 0.039 | 0.996 | 0.605 | 0.994 | 0.378 | 0.996 | 0.994 | 0.378 | 0.729 | 0.730 | 0.005 |
| hex: silesia/osdb | 524290 | 36693.6 ± 0.7% | 0.050 | 0.997 | 0.673 | 0.999 | 0.467 | 0.999 | 0.999 | 0.466 | 0.924 | 0.925 | 0.006 |
| hex: silesia/reymont | 524290 | 45942.6 ± 0.4% | 0.040 | 0.997 | 0.624 | 0.995 | 0.393 | 0.998 | 0.995 | 0.394 | 0.739 | 0.739 | 0.005 |
| hex: silesia/samba | 524290 | 46524.0 ± 0.4% | 0.039 | 0.995 | 0.613 | 0.994 | 0.389 | 0.997 | 0.996 | 0.389 | 0.730 | 0.729 | 0.005 |
| hex: silesia/sao | 524290 | 47731.5 ± 0.2% | 0.038 | 0.993 | 0.598 | 0.990 | 0.379 | 0.995 | 0.990 | 0.379 | 0.711 | 0.710 | 0.004 |
| hex: silesia/webster | 524290 | 46058.2 ± 0.2% | 0.040 | 0.997 | 0.619 | 0.996 | 0.393 | 0.999 | 0.998 | 0.393 | 0.737 | 0.738 | 0.005 |
| hex: silesia/x-ray | 524290 | 46796.3 ± 2.2% | 0.039 | 0.995 | 0.609 | 0.994 | 0.364 | 0.997 | 0.993 | 0.365 | 0.727 | 0.726 | 0.005 |
| hex: silesia/xml | 524290 | 46983.9 ± 0.4% | 0.039 | 0.991 | 0.599 | 0.991 | 0.384 | 0.995 | 0.991 | 0.384 | 0.721 | 0.722 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 46391.1 ± 0.6% | 0.040 | 0.997 | 0.606 | 0.996 | 0.387 | 0.999 | 0.997 | 0.389 | 0.728 | 0.728 | 0.005 |
| hex: canterbury/asyoulik.txt | 250360 | 45921.3 ± 0.4% | 0.040 | 0.999 | 0.621 | 0.998 | 0.393 | 1.000 | 0.997 | 0.393 | 0.738 | 0.738 | 0.005 |
| hex: canterbury/cp.html | 49208 | 44984.4 ± 0.6% | 0.041 | 1.003 | 0.623 | 0.997 | 0.393 | 0.995 | 0.995 | 0.397 | 0.743 | 0.743 | 0.005 |
| hex: canterbury/fields.c | 22302 | 51215.7 ± 0.5% | 0.036 | 1.006 | 0.536 | 0.990 | 0.389 | 0.978 | 0.990 | 0.395 | 0.643 | 0.645 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 44055.4 ± 1.0% | 0.042 | 0.987 | 0.577 | 1.009 | 0.412 | 0.994 | 1.007 | 0.434 | 0.679 | 0.677 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 46241.5 ± 0.6% | 0.040 | 0.998 | 0.615 | 0.997 | 0.391 | 0.998 | 0.996 | 0.392 | 0.734 | 0.734 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 37898.0 ± 2.6% | 0.048 | 1.002 | 0.649 | 1.002 | 0.447 | 1.003 | 1.001 | 0.447 | 0.894 | 0.896 | 0.006 |
| hex: canterbury/plrabn12.txt | 524290 | 46078.5 ± 1.0% | 0.040 | 0.996 | 0.621 | 0.994 | 0.390 | 0.997 | 0.994 | 0.394 | 0.737 | 0.736 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 46472.8 ± 0.9% | 0.039 | 0.992 | 0.611 | 0.994 | 0.386 | 0.994 | 0.990 | 0.386 | 0.727 | 0.726 | 0.005 |
| hex: canterbury/sum | 76482 | 47238.7 ± 1.5% | 0.039 | 1.001 | 0.593 | 1.001 | 0.376 | 0.994 | 0.997 | 0.378 | 0.705 | 0.703 | 0.004 |
| hex: canterbury/xargs.1 | 8456 | 44954.1 ± 0.6% | 0.041 | 0.989 | 0.573 | 1.011 | 0.408 | 0.984 | 1.013 | 0.427 | 0.676 | 0.673 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 47546.5 ± 0.6% | 0.039 | 0.993 | 0.597 | 0.990 | 0.379 | 0.995 | 0.992 | 0.381 | 0.713 | 0.711 | 0.004 |
| hex: canterbury-large/bible.txt | 524290 | 46347.3 ± 0.7% | 0.040 | 1.000 | 0.615 | 1.000 | 0.390 | 1.000 | 0.997 | 0.391 | 0.731 | 0.730 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 45900.8 ± 0.9% | 0.040 | 0.995 | 0.612 | 0.993 | 0.392 | 0.996 | 0.993 | 0.393 | 0.738 | 0.739 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 18196.1 ± 5.4% | 0.100 | 1.036 | 0.818 | 0.995 | 0.585 | 1.006 | 0.993 | 0.650 | 0.851 | 0.830 | 0.012 |
| hex: http/html-16kx64 | 2097280 | 34426.6 ± 0.8% | 0.053 | 1.004 | 0.693 | 1.003 | 0.472 | 1.003 | 1.004 | 0.476 | 0.800 | 0.800 | 0.006 |
| hex: http/html-1m | 524290 | 46263.6 ± 1.3% | 0.040 | 0.997 | 0.608 | 0.998 | 0.390 | 1.001 | 0.998 | 0.390 | 0.732 | 0.733 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 18107.4 ± 1.0% | 0.100 | 1.052 | 0.824 | 0.995 | 0.587 | 1.006 | 0.996 | 0.647 | 0.856 | 0.832 | 0.012 |
| hex: http/json-16kx64 | 2097280 | 34075.1 ± 0.5% | 0.054 | 1.002 | 0.690 | 1.002 | 0.474 | 1.002 | 1.002 | 0.479 | 0.797 | 0.797 | 0.006 |
| hex: http/json-1m | 524290 | 45357.7 ± 2.2% | 0.040 | 0.999 | 0.631 | 1.000 | 0.375 | 1.001 | 0.997 | 0.375 | 0.744 | 0.743 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 17944.8 ± 1.1% | 0.101 | 1.049 | 0.822 | 0.999 | 0.594 | 1.004 | 0.997 | 0.655 | 0.862 | 0.840 | 0.012 |
| hex: http/js-16kx64 | 2097280 | 34516.1 ± 0.4% | 0.053 | 1.001 | 0.692 | 1.001 | 0.471 | 1.004 | 1.004 | 0.476 | 0.797 | 0.799 | 0.006 |
| hex: http/js-1m | 524290 | 45966.8 ± 0.8% | 0.040 | 0.995 | 0.625 | 0.996 | 0.393 | 0.997 | 0.994 | 0.393 | 0.737 | 0.738 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 17707.6 ± 0.8% | 0.103 | 1.060 | 0.830 | 1.000 | 0.599 | 1.011 | 1.002 | 0.658 | 0.867 | 0.847 | 0.012 |
| hex: http/css-16kx64 | 2097280 | 34589.7 ± 1.0% | 0.053 | 1.002 | 0.690 | 1.003 | 0.471 | 1.003 | 1.004 | 0.475 | 0.800 | 0.800 | 0.006 |
| hex: http/css-1m | 524290 | 46393.6 ± 0.6% | 0.040 | 0.998 | 0.618 | 0.998 | 0.389 | 0.996 | 0.999 | 0.390 | 0.732 | 0.730 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 45705.5 ± 2.8% | 0.040 | 0.998 | 0.616 | 0.997 | 0.394 | 0.998 | 0.998 | 0.395 | 0.742 | 0.743 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1750.5 ± 1.4% | 0.425 | 1.002 | 0.978 | 1.015 | 1.012 | 0.270 | 1.013 | 0.516 | 0.905 | 0.095 | 1.018 |
| qlog records, JSON text sequence | 1467503 | 1663.3 ± 2.1% | 0.640 | 0.970 | 0.979 | 1.010 | 0.988 | 0.235 | 0.988 | 0.439 | 0.868 | 0.107 | 1.040 |
| messages: 11 string members | 1025025 | 1331.4 ± 0.6% | 0.502 | 0.962 | 0.983 | 0.989 | 0.979 | 0.380 | 0.981 | 0.669 | 0.950 | 0.123 | 0.998 |
| messages: 50 nested objects | 1121600 | 2012.6 ± 0.6% | 0.580 | 0.978 | 0.963 | 0.991 | 0.973 | 0.244 | 0.973 | 0.430 | 0.853 | 0.091 | 1.005 |
| messages: a tree of 341 objects | 612600 | 597.4 ± 2.9% | 0.978 | 1.060 | 1.078 | 1.081 | 1.082 | 0.264 | 1.079 | 0.451 | 0.835 | 0.195 | 1.088 |
| string: silesia/dickens | 172528 | 12983.9 ± 1.3% | 0.017 | 0.540 | 0.362 | 0.532 | 0.562 | 0.121 | 0.565 | 1.003 | 1.004 | 0.017 | 1.039 |
| string: silesia/nci | 1075110 | 11295.3 ± 0.4% | 0.020 | 0.527 | 0.357 | 0.537 | 0.527 | 0.185 | 0.526 | 1.004 | 1.004 | 0.020 | 1.037 |
| string: silesia/reymont | 1075159 | 5350.0 ± 2.4% | 0.042 | 0.574 | 0.434 | 0.568 | 0.572 | 0.269 | 0.572 | 1.002 | 1.010 | 0.042 | 1.021 |
| string: silesia/samba | 97582 | 6326.9 ± 0.3% | 0.045 | 0.882 | 0.746 | 0.897 | 0.889 | 0.122 | 0.892 | 0.999 | 0.999 | 0.045 | 1.158 |
| string: silesia/webster | 1098490 | 7083.6 ± 0.9% | 0.031 | 0.574 | 0.397 | 0.551 | 0.580 | 0.157 | 0.577 | 0.992 | 1.008 | 0.032 | 0.991 |
| string: silesia/xml | 1090118 | 10865.3 ± 0.9% | 0.021 | 0.556 | 0.462 | 0.552 | 0.558 | 0.207 | 0.559 | 1.001 | 1.013 | 0.021 | 1.032 |
| string: canterbury/alice29.txt | 159425 | 12736.6 ± 0.9% | 0.018 | 0.433 | 0.358 | 0.420 | 0.454 | 0.092 | 0.471 | 0.999 | 1.004 | 0.017 | 1.050 |
| string: canterbury/asyoulik.txt | 132198 | 11026.5 ± 1.5% | 0.019 | 0.392 | 0.329 | 0.386 | 0.409 | 0.090 | 0.419 | 1.002 | 1.016 | 0.019 | 1.040 |
| string: canterbury/lcet10.txt | 441884 | 12668.0 ± 1.7% | 0.018 | 0.544 | 0.326 | 0.534 | 0.550 | 0.118 | 0.551 | 0.999 | 1.019 | 0.018 | 1.005 |
| string: canterbury/plrabn12.txt | 503330 | 8827.2 ± 1.9% | 0.025 | 0.618 | 0.496 | 0.618 | 0.620 | 0.159 | 0.620 | 1.001 | 1.024 | 0.025 | 1.025 |
| string: canterbury-large/E.coli | 1048578 | 31761.2 ± 1.3% | 0.057 | 1.000 | 1.001 | 0.781 | 1.001 | 0.497 | 0.999 | 1.004 | 0.999 | 0.008 | 1.001 |
| string: canterbury-large/bible.txt | 1055886 | 9705.5 ± 0.7% | 0.024 | 0.736 | 0.563 | 0.743 | 0.748 | 0.391 | 0.752 | 0.991 | 1.005 | 0.024 | 1.021 |
| string: canterbury-large/world192.txt | 1103121 | 6676.8 ± 0.6% | 0.033 | 0.588 | 0.422 | 0.556 | 0.592 | 0.153 | 0.593 | 0.989 | 1.007 | 0.033 | 0.971 |
| string: http/html-1m | 1058582 | 10139.8 ± 0.5% | 0.023 | 0.641 | 0.538 | 0.637 | 0.644 | 0.315 | 0.644 | 0.997 | 1.012 | 0.023 | 1.016 |
| string: http/json-1m | 1190272 | 8118.7 ± 0.7% | 0.025 | 0.190 | 0.166 | 0.191 | 0.191 | 0.076 | 0.191 | 1.000 | 0.999 | 0.025 | 1.018 |
| string: http/js-1m | 1144362 | 6558.4 ± 1.5% | 0.032 | 0.368 | 0.312 | 0.359 | 0.369 | 0.094 | 0.369 | 0.987 | 1.004 | 0.032 | 1.009 |
| string: http/css-1m | 1097820 | 9297.8 ± 0.9% | 0.023 | 0.354 | 0.284 | 0.341 | 0.354 | 0.123 | 0.355 | 1.000 | 1.007 | 0.023 | 0.985 |
| string: dickens as Cyrillic and CJK | 1883069 | 5504.2 ± 2.1% | 0.031 | 0.465 | 0.068 | 0.464 | 0.465 | 0.209 | 0.466 | 1.001 | 1.003 | 0.030 | 1.029 |
| hex: silesia/dickens | 524290 | 42494.9 ± 0.6% | 0.999 | 0.091 | 1.000 | 0.603 | 1.000 | 1.000 | 1.001 | 0.999 | 1.000 | 0.095 | 1.000 |
| hex: silesia/mozilla | 524290 | 43588.3 ± 0.2% | 1.001 | 0.088 | 1.001 | 0.590 | 1.000 | 0.998 | 1.000 | 1.001 | 1.000 | 0.092 | 1.000 |
| hex: silesia/mr | 524290 | 43482.6 ± 1.9% | 1.002 | 0.088 | 0.999 | 0.588 | 0.999 | 0.997 | 1.001 | 1.002 | 1.000 | 0.092 | 1.000 |
| hex: silesia/nci | 524290 | 43445.0 ± 0.7% | 1.003 | 0.088 | 1.000 | 0.590 | 0.998 | 0.994 | 1.001 | 0.997 | 0.996 | 0.092 | 0.997 |
| hex: silesia/ooffice | 524290 | 43138.4 ± 1.0% | 1.003 | 0.089 | 1.002 | 0.592 | 1.003 | 1.002 | 1.004 | 1.005 | 1.009 | 0.094 | 1.005 |
| hex: silesia/osdb | 524290 | 42045.8 ± 0.5% | 1.006 | 0.091 | 0.999 | 0.608 | 1.003 | 1.000 | 1.003 | 0.999 | 0.997 | 0.096 | 1.001 |
| hex: silesia/reymont | 524290 | 43651.2 ± 3.7% | 1.002 | 0.087 | 1.001 | 0.590 | 1.003 | 1.000 | 1.002 | 1.001 | 1.000 | 0.092 | 0.977 |
| hex: silesia/samba | 524290 | 43415.6 ± 1.1% | 0.999 | 0.088 | 0.999 | 0.588 | 1.003 | 0.998 | 0.968 | 1.001 | 1.000 | 0.094 | 0.993 |
| hex: silesia/sao | 524290 | 43596.7 ± 1.1% | 1.000 | 0.088 | 0.999 | 0.589 | 1.003 | 0.999 | 1.000 | 1.002 | 1.003 | 0.090 | 1.002 |
| hex: silesia/webster | 524290 | 43780.9 ± 0.4% | 0.999 | 0.088 | 1.001 | 0.587 | 1.001 | 0.999 | 0.998 | 1.000 | 0.994 | 0.094 | 0.999 |
| hex: silesia/x-ray | 524290 | 43424.9 ± 8.1% | 1.004 | 0.088 | 1.004 | 0.589 | 1.004 | 1.002 | 1.005 | 1.002 | 0.997 | 0.093 | 1.003 |
| hex: silesia/xml | 524290 | 43400.0 ± 8.2% | 1.005 | 0.088 | 1.002 | 0.591 | 1.005 | 1.006 | 1.005 | 1.005 | 1.005 | 0.092 | 1.004 |
| hex: canterbury/alice29.txt | 304180 | 41539.3 ± 6.7% | 1.004 | 0.093 | 1.003 | 0.600 | 1.004 | 0.999 | 1.006 | 1.003 | 0.999 | 0.099 | 1.008 |
| hex: canterbury/asyoulik.txt | 250360 | 43425.3 ± 2.0% | 1.004 | 0.089 | 1.002 | 0.591 | 1.003 | 1.000 | 1.001 | 1.002 | 0.995 | 0.094 | 0.998 |
| hex: canterbury/cp.html | 49208 | 42549.6 ± 1.6% | 1.000 | 0.090 | 1.000 | 0.590 | 0.998 | 0.996 | 1.001 | 0.998 | 0.998 | 0.097 | 1.001 |
| hex: canterbury/fields.c | 22302 | 41809.8 ± 5.8% | 1.006 | 0.091 | 1.004 | 0.599 | 1.005 | 0.993 | 1.002 | 1.007 | 1.013 | 0.099 | 1.003 |
| hex: canterbury/grammar.lsp | 7444 | 38995.7 ± 1.1% | 0.994 | 0.097 | 0.995 | 0.611 | 1.000 | 0.965 | 1.001 | 1.002 | 1.032 | 0.104 | 1.005 |
| hex: canterbury/kennedy.xls | 524290 | 43335.1 ± 1.2% | 1.001 | 0.088 | 0.998 | 0.591 | 1.003 | 0.994 | 0.997 | 0.996 | 0.994 | 0.094 | 0.996 |
| hex: canterbury/lcet10.txt | 524290 | 43244.9 ± 1.9% | 1.003 | 0.088 | 0.991 | 0.593 | 1.000 | 0.991 | 1.002 | 0.997 | 0.999 | 0.093 | 0.997 |
| hex: canterbury/plrabn12.txt | 524290 | 42806.2 ± 2.3% | 1.003 | 0.090 | 0.998 | 0.599 | 1.000 | 0.998 | 0.997 | 1.000 | 0.998 | 0.095 | 0.999 |
| hex: canterbury/ptt5 | 524290 | 42780.0 ± 1.1% | 1.004 | 0.090 | 0.996 | 0.599 | 1.000 | 0.999 | 1.003 | 1.001 | 0.999 | 0.096 | 0.999 |
| hex: canterbury/sum | 76482 | 42068.1 ± 1.0% | 0.998 | 0.091 | 0.999 | 0.599 | 1.008 | 1.000 | 1.008 | 1.004 | 1.001 | 0.098 | 0.998 |
| hex: canterbury/xargs.1 | 8456 | 38141.1 ± 1.2% | 1.002 | 0.100 | 1.021 | 0.632 | 1.009 | 0.997 | 1.006 | 1.021 | 1.027 | 0.107 | 1.010 |
| hex: canterbury-large/E.coli | 524290 | 41277.7 ± 0.9% | 1.007 | 0.093 | 0.991 | 0.613 | 1.003 | 0.985 | 1.003 | 0.999 | 0.997 | 0.096 | 0.994 |
| hex: canterbury-large/bible.txt | 524290 | 43183.5 ± 1.1% | 1.006 | 0.089 | 0.986 | 0.597 | 1.002 | 0.987 | 1.004 | 0.991 | 0.982 | 0.094 | 0.990 |
| hex: canterbury-large/world192.txt | 524290 | 42747.5 ± 0.7% | 1.000 | 0.090 | 0.999 | 0.599 | 0.999 | 0.998 | 1.002 | 0.998 | 0.993 | 0.096 | 1.008 |
| hex: http/html-1kx1024 | 2099200 | 20285.5 ± 0.5% | 1.003 | 0.182 | 1.003 | 0.989 | 1.003 | 1.003 | 1.003 | 1.002 | 1.006 | 0.188 | 1.005 |
| hex: http/html-16kx64 | 2097280 | 21608.0 ± 0.6% | 1.003 | 0.176 | 1.002 | 0.983 | 1.003 | 1.004 | 1.002 | 1.002 | 1.003 | 0.189 | 1.002 |
| hex: http/html-1m | 524290 | 42900.0 ± 1.5% | 1.006 | 0.089 | 1.000 | 0.597 | 1.004 | 0.999 | 0.999 | 1.005 | 1.002 | 0.093 | 0.998 |
| hex: http/json-1kx1024 | 2099200 | 20193.3 ± 0.5% | 1.003 | 0.183 | 1.003 | 0.988 | 1.004 | 1.005 | 1.003 | 1.004 | 1.008 | 0.190 | 1.006 |
| hex: http/json-16kx64 | 2097280 | 21203.1 ± 0.4% | 1.004 | 0.179 | 1.004 | 0.987 | 1.004 | 1.005 | 1.003 | 1.004 | 1.004 | 0.193 | 1.003 |
| hex: http/json-1m | 524290 | 43058.6 ± 1.2% | 1.005 | 0.089 | 0.998 | 0.594 | 1.002 | 1.000 | 1.001 | 0.994 | 0.993 | 0.095 | 0.996 |
| hex: http/js-1kx1024 | 2099200 | 20123.3 ± 0.4% | 1.003 | 0.182 | 1.002 | 0.988 | 1.003 | 1.003 | 1.003 | 1.003 | 1.006 | 0.190 | 1.004 |
| hex: http/js-16kx64 | 2097280 | 22094.8 ± 0.2% | 1.003 | 0.171 | 1.001 | 0.963 | 1.003 | 1.001 | 1.003 | 1.002 | 1.003 | 0.185 | 1.004 |
| hex: http/js-1m | 524290 | 43240.1 ± 8.8% | 1.004 | 0.089 | 1.001 | 0.592 | 1.001 | 0.999 | 0.997 | 1.000 | 0.999 | 0.094 | 0.998 |
| hex: http/css-1kx1024 | 2099200 | 20472.8 ± 0.5% | 1.003 | 0.178 | 1.004 | 0.981 | 1.004 | 1.004 | 1.004 | 1.005 | 1.008 | 0.186 | 1.006 |
| hex: http/css-16kx64 | 2097280 | 22122.5 ± 0.1% | 1.003 | 0.170 | 1.002 | 0.962 | 1.003 | 1.004 | 1.004 | 1.004 | 1.003 | 0.185 | 1.004 |
| hex: http/css-1m | 524290 | 43098.1 ± 0.8% | 0.999 | 0.089 | 0.995 | 0.593 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 0.094 | 1.005 |
| hex: shuffled/dickens-1m | 524290 | 41750.3 ± 8.5% | 1.012 | 0.092 | 1.003 | 0.612 | 1.008 | 1.002 | 1.009 | 1.004 | 1.004 | 0.097 | 1.003 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.058 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.063 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.059 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.056 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.057 of all on.
- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.089 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.089 of all on.
- messages: 50 nested objects, decoding: J8 decoder fast path off runs at 1.090 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.098 of all on.
- messages: 50 nested objects, decoding: J13 decoder escape blocks off runs at 1.089 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.087 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.095 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.113 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.070 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.069 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.071 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.098 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.121 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.156 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.138 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.136 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.060 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.141 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.108 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.117 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.131 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.052 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.060 of all on.
- messages: a tree of 341 objects, encoding: J2 hex vectors off runs at 1.060 of all on.
- messages: a tree of 341 objects, encoding: J5 UTF-8 vectors off runs at 1.078 of all on.
- messages: a tree of 341 objects, encoding: J7 wide vectors off runs at 1.081 of all on.
- messages: a tree of 341 objects, encoding: J9 encoder fast path off runs at 1.082 of all on.
- messages: a tree of 341 objects, encoding: J14 encoder escape blocks off runs at 1.079 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 163950.5 ± 2.3% | 118927.5 ± 1.8% | 1.379 | 98675.1 ± 7.7% | 1.662 |
| string: silesia/nci | 1048576 | 163613.1 ± 1.4% | 120321.0 ± 2.3% | 1.360 | 99169.3 ± 4.1% | 1.650 |
| string: silesia/reymont | 1048576 | 163805.5 ± 2.2% | 120004.6 ± 6.9% | 1.365 | 99227.5 ± 0.5% | 1.651 |
| string: silesia/samba | 65546 | 156783.9 ± 12.0% | 116248.6 ± 3.2% | 1.349 | 96643.2 ± 9.7% | 1.622 |
| string: silesia/webster | 1048576 | 161226.4 ± 3.3% | 119517.2 ± 2.1% | 1.349 | 99240.4 ± 1.0% | 1.625 |
| string: silesia/xml | 1048576 | 159449.6 ± 3.7% | 119530.5 ± 5.3% | 1.334 | 98716.3 ± 16.0% | 1.615 |
| string: canterbury/alice29.txt | 152089 | 161311.2 ± 1.8% | 118778.5 ± 4.8% | 1.358 | 98381.8 ± 0.8% | 1.640 |
| string: canterbury/asyoulik.txt | 125179 | 162075.0 ± 1.3% | 118590.4 ± 1.3% | 1.367 | 98794.6 ± 5.6% | 1.641 |
| string: canterbury/lcet10.txt | 426754 | 163844.9 ± 10.0% | 120189.9 ± 4.9% | 1.363 | 99477.7 ± 2.7% | 1.647 |
| string: canterbury/plrabn12.txt | 481861 | 157356.4 ± 3.5% | 117021.7 ± 8.7% | 1.345 | 98869.8 ± 5.4% | 1.592 |
| string: canterbury-large/E.coli | 1048576 | 147762.6 ± 2.7% | 113307.0 ± 0.4% | 1.304 | 94235.1 ± 1.4% | 1.568 |
| string: canterbury-large/bible.txt | 1048576 | 164293.0 ± 1.8% | 121094.4 ± 1.9% | 1.357 | 99888.3 ± 0.9% | 1.645 |
| string: canterbury-large/world192.txt | 1048576 | 159983.7 ± 4.4% | 119794.5 ± 0.9% | 1.335 | 98889.2 ± 0.6% | 1.618 |
| string: http/html-1m | 1048576 | 142869.9 ± 1.8% | 109200.8 ± 0.6% | 1.308 | 91988.6 ± 0.8% | 1.553 |
| string: http/json-1m | 1048576 | 118406.9 ± 2.5% | 103942.6 ± 0.4% | 1.139 | 80775.1 ± 0.9% | 1.466 |
| string: http/js-1m | 1048576 | 158561.7 ± 2.7% | 119320.1 ± 1.2% | 1.329 | 97296.4 ± 1.3% | 1.630 |
| string: http/css-1m | 1048576 | 161031.6 ± 1.1% | 119218.5 ± 0.8% | 1.351 | 97977.5 ± 0.4% | 1.644 |
| string: dickens as Cyrillic and CJK | 1847045 | 23725.7 ± 0.7% | 21114.9 ± 0.4% | 1.124 | 15106.2 ± 0.9% | 1.571 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 162388.6 ± 1.3% | 119978.3 ± 0.5% | 1.353 | 99752.7 ± 0.7% | 1.628 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 161779.8 ± 10.3% | 119378.4 ± 14.9% | 1.355 | 98834.1 ± 3.9% | 1.637 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 162513.9 ± 2.6% | 120029.3 ± 0.6% | 1.354 | 98967.7 ± 0.3% | 1.642 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 164220.3 ± 3.3% | 120476.6 ± 2.3% | 1.363 | 99230.5 ± 1.0% | 1.655 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 164800.8 ± 1.7% | 120221.9 ± 0.2% | 1.371 | 98990.4 ± 0.9% | 1.665 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 163817.0 ± 3.2% | 120313.3 ± 0.9% | 1.362 | 99555.4 ± 1.1% | 1.645 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24244.6 ± 0.6% | 21640.3 ± 0.9% | 1.120 | 15322.4 ± 1.0% | 1.582 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24218.2 ± 1.0% | 21568.7 ± 1.0% | 1.123 | 15223.7 ± 1.2% | 1.591 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24379.0 ± 0.8% | 21784.4 ± 0.6% | 1.119 | 15364.0 ± 0.1% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24376.5 ± 0.3% | 21773.5 ± 0.4% | 1.120 | 15379.5 ± 0.3% | 1.585 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24383.2 ± 0.4% | 21768.4 ± 0.8% | 1.120 | 15331.3 ± 0.6% | 1.590 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24237.1 ± 1.0% | 21757.4 ± 0.9% | 1.114 | 15328.3 ± 0.8% | 1.581 |

## Messages against serde_json's typed code

stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.

| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |
|---|---|---|---|---|
| messages: 11 string members | 1025025 | 1231.7 ± 3.5% | 814.3 ± 0.7% | 1.513 |
| messages: 50 nested objects | 1121600 | 1699.7 ± 1.0% | 884.6 ± 0.2% | 1.921 |
| messages: a tree of 341 objects | 612600 | 486.9 ± 1.7% | 509.7 ± 0.2% | 0.955 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1377.7 ± 1.0% | 1524.8 ± 46.5% | 1112.0 ± 58.0% | 389.4 ± 3.5% | 673.2 ± 0.3% | 363.8 ± 1.8% | 0.904 | 1.239 | 3.538 | 2.046 | 3.787 |
| qlog records, JSON text sequence | 1467503 | 1104.4 ± 0.7% | 1241.6 ± 1.1% | 1127.6 ± 0.4% | 330.2 ± 0.9% | 754.8 ± 0.4% | 308.8 ± 0.9% | 0.889 | 0.979 | 3.345 | 1.463 | 3.576 |
| messages: 11 string members | 1025025 | 1080.4 ± 0.5% | 2033.8 ± 5.3% | 722.3 ± 1.5% | 336.8 ± 0.2% | 510.5 ± 0.3% | 292.5 ± 1.4% | 0.531 | 1.496 | 3.208 | 2.116 | 3.694 |
| messages: 50 nested objects | 1121600 | 1341.7 ± 0.4% | 1712.3 ± 4.4% | 1455.6 ± 0.4% | 432.6 ± 0.7% | 905.3 ± 0.4% | 419.8 ± 0.3% | 0.784 | 0.922 | 3.101 | 1.482 | 3.196 |
| messages: a tree of 341 objects | 612600 | 669.8 ± 1.1% | 848.9 ± 1.1% | 702.9 ± 1.9% | 182.8 ± 0.9% | 611.2 ± 0.6% | 208.7 ± 1.3% | 0.789 | 0.953 | 3.665 | 1.096 | 3.209 |
| string: silesia/dickens | 172528 | 6653.9 ± 0.4% | 3440.0 ± 1.2% | 2829.7 ± 1.5% | 316.9 ± 0.2% | 3090.7 ± 0.3% | 572.8 ± 2.3% | 1.934 | 2.351 | 20.996 | 2.153 | 11.617 |
| string: silesia/nci | 1075110 | 5411.5 ± 0.4% | 3915.4 ± 1.4% | 3050.3 ± 1.1% | 649.5 ± 0.8% | 3646.7 ± 3.9% | 553.2 ± 5.5% | 1.382 | 1.774 | 8.332 | 1.484 | 9.782 |
| string: silesia/reymont | 1075159 | 3535.4 ± 1.2% | 3419.4 ± 0.3% | 1941.7 ± 1.8% | 342.5 ± 0.5% | 2110.5 ± 0.3% | 492.2 ± 3.3% | 1.034 | 1.821 | 10.323 | 1.675 | 7.182 |
| string: silesia/samba | 97582 | 3952.0 ± 0.6% | 3794.3 ± 2.1% | 3051.5 ± 0.8% | 328.0 ± 3.6% | 1964.0 ± 1.8% | 419.6 ± 2.7% | 1.042 | 1.295 | 12.050 | 2.012 | 9.418 |
| string: silesia/webster | 1098490 | 4352.5 ± 1.4% | 2448.4 ± 0.4% | 1738.6 ± 1.8% | 309.3 ± 10.5% | 2069.7 ± 3.7% | 451.1 ± 1.9% | 1.778 | 2.503 | 14.074 | 2.103 | 9.648 |
| string: silesia/xml | 1090118 | 6061.7 ± 3.0% | 5082.6 ± 9.4% | 2451.9 ± 4.5% | 507.2 ± 1.1% | 3329.3 ± 2.4% | 528.7 ± 4.7% | 1.193 | 2.472 | 11.952 | 1.821 | 11.466 |
| string: canterbury/alice29.txt | 159425 | 5754.0 ± 0.9% | 2787.4 ± 0.9% | 2808.5 ± 3.4% | 299.5 ± 5.1% | 2755.9 ± 11.4% | 514.0 ± 3.3% | 2.064 | 2.049 | 19.213 | 2.088 | 11.194 |
| string: canterbury/asyoulik.txt | 132198 | 4287.9 ± 0.9% | 2585.6 ± 2.6% | 2783.2 ± 1.1% | 305.0 ± 0.5% | 2406.4 ± 1.5% | 450.9 ± 3.6% | 1.658 | 1.541 | 14.059 | 1.782 | 9.510 |
| string: canterbury/lcet10.txt | 441884 | 6578.8 ± 0.6% | 3274.8 ± 0.7% | 2310.0 ± 2.6% | 345.3 ± 0.4% | 2788.3 ± 0.6% | 564.1 ± 2.6% | 2.009 | 2.848 | 19.053 | 2.359 | 11.662 |
| string: canterbury/plrabn12.txt | 503330 | 5399.8 ± 1.0% | 3148.0 ± 0.8% | 1842.2 ± 0.7% | 322.7 ± 0.3% | 2837.8 ± 0.5% | 533.4 ± 0.9% | 1.715 | 2.931 | 16.732 | 1.903 | 10.123 |
| string: canterbury-large/E.coli | 1048578 | 31259.5 ± 3.4% | 12968.6 ± 0.6% | 3408.3 ± 0.3% | 1283.5 ± 0.2% | 8920.8 ± 0.8% | 939.3 ± 4.2% | 2.410 | 9.172 | 24.356 | 3.504 | 33.280 |
| string: canterbury-large/bible.txt | 1055886 | 8640.7 ± 0.4% | 5267.4 ± 0.5% | 2795.4 ± 3.0% | 356.6 ± 0.4% | 3903.3 ± 0.4% | 627.0 ± 2.5% | 1.640 | 3.091 | 24.228 | 2.214 | 13.782 |
| string: canterbury-large/world192.txt | 1103121 | 4143.7 ± 0.4% | 2314.8 ± 0.2% | 1762.4 ± 0.6% | 326.8 ± 0.8% | 2112.3 ± 0.4% | 469.1 ± 2.0% | 1.790 | 2.351 | 12.682 | 1.962 | 8.833 |
| string: http/html-1m | 1058582 | 9093.8 ± 2.6% | 4737.5 ± 1.5% | 2680.8 ± 0.5% | 425.6 ± 0.4% | 3652.7 ± 1.2% | 598.3 ± 0.9% | 1.920 | 3.392 | 21.367 | 2.490 | 15.198 |
| string: http/json-1m | 1190272 | 3340.6 ± 0.5% | 1257.2 ± 0.6% | 2097.9 ± 0.5% | 475.8 ± 1.0% | 1338.6 ± 0.7% | 436.7 ± 1.2% | 2.657 | 1.592 | 7.021 | 2.496 | 7.650 |
| string: http/js-1m | 1144362 | 2830.4 ± 0.3% | 1611.5 ± 0.2% | 1325.9 ± 0.2% | 325.7 ± 0.3% | 1426.1 ± 0.2% | 380.6 ± 0.8% | 1.756 | 2.135 | 8.690 | 1.985 | 7.438 |
| string: http/css-1m | 1097820 | 3298.1 ± 0.4% | 2892.4 ± 0.4% | 2280.5 ± 0.7% | 452.5 ± 0.6% | 2074.1 ± 0.3% | 438.7 ± 1.4% | 1.140 | 1.446 | 7.289 | 1.590 | 7.517 |
| string: dickens as Cyrillic and CJK | 1883069 | 5834.8 ± 0.6% | 3299.2 ± 7.1% | 664.3 ± 0.4% | 377.8 ± 0.5% | 512.2 ± 0.3% | 163.8 ± 2.8% | 1.769 | 8.783 | 15.446 | 11.390 | 35.625 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1205.6 ± 1.2% | 1238.9 ± 0.5% | 1106.5 ± 1.2% | 262.9 ± 1.8% | 479.8 ± 0.4% | 228.0 ± 4.0% | 0.973 | 1.090 | 4.586 | 2.513 | 5.288 |
| hex: silesia/dickens | 524290 | 46049.3 ± 0.1% | 15064.6 ± 0.2% | 3558.1 ± 0.2% | 476.1 ± 0.4% | 8946.7 ± 0.6% | 1142.9 ± 3.7% | 3.057 | 12.942 | 96.731 | 5.147 | 40.291 |
| hex: silesia/mozilla | 524290 | 45809.9 ± 1.1% | 15067.3 ± 0.3% | 3481.9 ± 0.3% | 430.1 ± 0.5% | 8893.5 ± 1.4% | 1141.0 ± 0.8% | 3.040 | 13.157 | 106.505 | 5.151 | 40.147 |
| hex: silesia/mr | 524290 | 44938.4 ± 0.4% | 15057.9 ± 0.5% | 3485.3 ± 0.4% | 645.6 ± 0.6% | 8906.7 ± 5.3% | 1141.5 ± 1.3% | 2.984 | 12.894 | 69.603 | 5.045 | 39.370 |
| hex: silesia/nci | 524290 | 45767.5 ± 0.5% | 15052.0 ± 0.6% | 3565.8 ± 0.4% | 804.7 ± 25.4% | 8922.9 ± 8.1% | 1140.5 ± 0.8% | 3.041 | 12.835 | 56.877 | 5.129 | 40.129 |
| hex: silesia/ooffice | 524290 | 46464.7 ± 2.7% | 15043.5 ± 0.5% | 3490.1 ± 0.5% | 344.4 ± 2.3% | 8909.1 ± 0.8% | 1137.0 ± 0.5% | 3.089 | 13.313 | 134.918 | 5.215 | 40.866 |
| hex: silesia/osdb | 524290 | 36693.6 ± 0.7% | 15059.7 ± 0.4% | 3489.7 ± 0.2% | 456.7 ± 1.1% | 8918.5 ± 0.6% | 1135.6 ± 1.1% | 2.437 | 10.515 | 80.342 | 4.114 | 32.312 |
| hex: silesia/reymont | 524290 | 45942.6 ± 0.4% | 15058.9 ± 0.6% | 3518.9 ± 0.3% | 496.8 ± 0.6% | 8922.8 ± 5.4% | 1132.3 ± 1.8% | 3.051 | 13.056 | 92.475 | 5.149 | 40.574 |
| hex: silesia/samba | 524290 | 46524.0 ± 0.4% | 15061.0 ± 0.4% | 3496.0 ± 0.3% | 367.8 ± 0.5% | 8913.5 ± 0.2% | 1137.2 ± 1.6% | 3.089 | 13.308 | 126.492 | 5.220 | 40.910 |
| hex: silesia/sao | 524290 | 47731.5 ± 0.2% | 15062.8 ± 2.5% | 3490.2 ± 2.2% | 279.5 ± 0.7% | 8909.5 ± 0.3% | 1134.3 ± 0.9% | 3.169 | 13.676 | 170.797 | 5.357 | 42.079 |
| hex: silesia/webster | 524290 | 46058.2 ± 0.2% | 15078.4 ± 0.2% | 3563.5 ± 0.2% | 451.7 ± 0.7% | 8947.0 ± 0.4% | 1139.6 ± 4.2% | 3.055 | 12.925 | 101.957 | 5.148 | 40.417 |
| hex: silesia/x-ray | 524290 | 46796.3 ± 2.2% | 15079.9 ± 2.5% | 3493.0 ± 0.1% | 426.4 ± 0.3% | 8924.1 ± 0.2% | 1139.0 ± 0.4% | 3.103 | 13.397 | 109.752 | 5.244 | 41.086 |
| hex: silesia/xml | 524290 | 46983.9 ± 0.4% | 15078.0 ± 0.4% | 3557.7 ± 3.7% | 729.4 ± 0.7% | 8925.9 ± 0.4% | 1139.2 ± 0.3% | 3.116 | 13.206 | 64.412 | 5.264 | 41.243 |
| hex: canterbury/alice29.txt | 304180 | 46391.1 ± 0.6% | 14124.5 ± 0.2% | 3565.1 ± 0.2% | 482.4 ± 0.8% | 8934.9 ± 0.5% | 1148.0 ± 0.7% | 3.284 | 13.012 | 96.165 | 5.192 | 40.412 |
| hex: canterbury/asyoulik.txt | 250360 | 45921.3 ± 0.4% | 14912.1 ± 0.5% | 3495.1 ± 0.4% | 468.9 ± 0.4% | 8907.0 ± 0.4% | 1143.0 ± 1.2% | 3.079 | 13.139 | 97.932 | 5.156 | 40.175 |
| hex: canterbury/cp.html | 49208 | 44984.4 ± 0.6% | 14453.6 ± 2.1% | 3568.8 ± 1.2% | 510.4 ± 0.7% | 9263.9 ± 0.4% | 1129.3 ± 0.9% | 3.112 | 12.605 | 88.136 | 4.856 | 39.836 |
| hex: canterbury/fields.c | 22302 | 51215.7 ± 0.5% | 17629.4 ± 0.3% | 3666.6 ± 0.8% | 569.6 ± 1.4% | 9232.3 ± 0.3% | 1106.5 ± 1.3% | 2.905 | 13.968 | 89.914 | 5.547 | 46.288 |
| hex: canterbury/grammar.lsp | 7444 | 44055.4 ± 1.0% | 17271.1 ± 0.4% | 3623.8 ± 0.2% | 743.1 ± 0.9% | 8956.5 ± 0.4% | 1064.6 ± 1.8% | 2.551 | 12.157 | 59.282 | 4.919 | 41.384 |
| hex: canterbury/kennedy.xls | 524290 | 46241.5 ± 0.6% | 15018.9 ± 2.7% | 3562.2 ± 0.3% | 754.8 ± 0.9% | 8921.4 ± 0.2% | 1121.2 ± 4.9% | 3.079 | 12.981 | 61.260 | 5.183 | 41.243 |
| hex: canterbury/lcet10.txt | 524290 | 37898.0 ± 2.6% | 15048.5 ± 7.9% | 3540.4 ± 3.2% | 480.9 ± 6.8% | 8832.3 ± 4.3% | 1116.2 ± 1.7% | 2.518 | 10.704 | 78.799 | 4.291 | 33.952 |
| hex: canterbury/plrabn12.txt | 524290 | 46078.5 ± 1.0% | 15056.2 ± 1.0% | 3554.5 ± 0.9% | 466.2 ± 1.0% | 8923.2 ± 0.6% | 1118.5 ± 2.8% | 3.060 | 12.963 | 98.847 | 5.164 | 41.195 |
| hex: canterbury/ptt5 | 524290 | 46472.8 ± 0.9% | 14958.5 ± 0.8% | 3467.1 ± 1.7% | 659.9 ± 0.8% | 8846.1 ± 1.1% | 1120.2 ± 0.9% | 3.107 | 13.404 | 70.427 | 5.253 | 41.485 |
| hex: canterbury/sum | 76482 | 47238.7 ± 1.5% | 15407.7 ± 0.6% | 3558.9 ± 0.5% | 584.7 ± 0.9% | 8913.8 ± 0.7% | 1132.8 ± 0.6% | 3.066 | 13.273 | 80.793 | 5.299 | 41.701 |
| hex: canterbury/xargs.1 | 8456 | 44954.1 ± 0.6% | 17378.4 ± 0.5% | 3547.8 ± 0.6% | 721.6 ± 2.2% | 8942.2 ± 1.0% | 1096.1 ± 2.0% | 2.587 | 12.671 | 62.302 | 5.027 | 41.011 |
| hex: canterbury-large/E.coli | 524290 | 47546.5 ± 0.6% | 14071.1 ± 0.9% | 3484.8 ± 0.7% | 960.4 ± 0.8% | 8889.4 ± 0.4% | 1110.9 ± 2.1% | 3.379 | 13.644 | 49.508 | 5.349 | 42.799 |
| hex: canterbury-large/bible.txt | 524290 | 46347.3 ± 0.7% | 14094.0 ± 0.8% | 3487.7 ± 0.7% | 497.6 ± 1.3% | 8887.6 ± 2.4% | 1124.4 ± 3.2% | 3.288 | 13.289 | 93.138 | 5.215 | 41.220 |
| hex: canterbury-large/world192.txt | 524290 | 45900.8 ± 0.9% | 14931.9 ± 0.7% | 3567.3 ± 3.5% | 465.6 ± 0.8% | 8930.3 ± 1.1% | 1128.5 ± 5.2% | 3.074 | 12.867 | 98.585 | 5.140 | 40.675 |
| hex: http/html-1kx1024 | 2099200 | 18196.1 ± 5.4% | 12289.6 ± 7.1% | 3194.6 ± 1.2% | 505.5 ± 0.5% | 7401.1 ± 1.2% | 978.3 ± 1.2% | 1.481 | 5.696 | 35.997 | 2.459 | 18.600 |
| hex: http/html-16kx64 | 2097280 | 34426.6 ± 0.8% | 13985.9 ± 0.6% | 3404.8 ± 0.6% | 512.3 ± 0.6% | 8514.6 ± 1.6% | 1077.3 ± 3.7% | 2.462 | 10.111 | 67.197 | 4.043 | 31.957 |
| hex: http/html-1m | 524290 | 46263.6 ± 1.3% | 14071.8 ± 1.0% | 3490.1 ± 0.5% | 506.3 ± 0.8% | 8877.4 ± 0.9% | 1110.3 ± 3.3% | 3.288 | 13.256 | 91.373 | 5.211 | 41.669 |
| hex: http/json-1kx1024 | 2099200 | 18107.4 ± 1.0% | 11973.9 ± 1.1% | 3198.2 ± 0.8% | 669.1 ± 0.7% | 7426.5 ± 2.8% | 973.5 ± 2.6% | 1.512 | 5.662 | 27.062 | 2.438 | 18.600 |
| hex: http/json-16kx64 | 2097280 | 34075.1 ± 0.5% | 13907.3 ± 0.3% | 3403.9 ± 0.6% | 684.1 ± 0.5% | 7862.6 ± 4.5% | 1075.2 ± 1.3% | 2.450 | 10.011 | 49.810 | 4.334 | 31.691 |
| hex: http/json-1m | 524290 | 45357.7 ± 2.2% | 14968.9 ± 1.2% | 3545.0 ± 0.8% | 697.4 ± 0.8% | 8882.4 ± 0.7% | 1077.4 ± 3.1% | 3.030 | 12.795 | 65.039 | 5.106 | 42.101 |
| hex: http/js-1kx1024 | 2099200 | 17944.8 ± 1.1% | 12439.1 ± 8.5% | 3202.3 ± 0.9% | 487.7 ± 0.7% | 7404.6 ± 2.3% | 959.0 ± 1.6% | 1.443 | 5.604 | 36.796 | 2.423 | 18.712 |
| hex: http/js-16kx64 | 2097280 | 34516.1 ± 0.4% | 13964.5 ± 0.4% | 3407.8 ± 0.6% | 494.5 ± 1.0% | 8431.8 ± 0.6% | 1081.0 ± 3.5% | 2.472 | 10.129 | 69.796 | 4.094 | 31.929 |
| hex: http/js-1m | 524290 | 45966.8 ± 0.8% | 15038.9 ± 0.5% | 3539.8 ± 0.2% | 512.9 ± 0.5% | 8912.4 ± 0.3% | 1093.2 ± 4.7% | 3.057 | 12.986 | 89.624 | 5.158 | 42.048 |
| hex: http/css-1kx1024 | 2099200 | 17707.6 ± 0.8% | 11967.2 ± 0.7% | 3206.8 ± 0.2% | 567.0 ± 0.8% | 7422.1 ± 1.3% | 970.4 ± 1.0% | 1.480 | 5.522 | 31.230 | 2.386 | 18.248 |
| hex: http/css-16kx64 | 2097280 | 34589.7 ± 1.0% | 13970.8 ± 0.9% | 3413.9 ± 0.8% | 578.8 ± 0.8% | 8514.6 ± 0.2% | 1078.8 ± 1.2% | 2.476 | 10.132 | 59.757 | 4.062 | 32.063 |
| hex: http/css-1m | 524290 | 46393.6 ± 0.6% | 15064.9 ± 0.6% | 3567.1 ± 1.2% | 561.3 ± 0.4% | 8935.6 ± 0.7% | 1127.2 ± 1.4% | 3.080 | 13.006 | 82.657 | 5.192 | 41.158 |
| hex: shuffled/dickens-1m | 524290 | 45705.5 ± 2.8% | 15084.3 ± 7.3% | 3496.2 ± 16.3% | 475.5 ± 2.8% | 8908.2 ± 1.0% | 1127.6 ± 2.9% | 3.030 | 13.073 | 96.125 | 5.131 | 40.534 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1750.5 ± 1.4% | 1476.6 ± 3.5% | 1029.3 ± 2.2% | 461.0 ± 8.3% | 434.8 ± 2.3% | 501.8 ± 0.6% | 1.185 | 1.701 | 3.797 | 4.026 | 3.488 |
| qlog records, JSON text sequence | 1467503 | 1663.3 ± 2.1% | 1217.0 ± 1.7% | 946.9 ± 2.6% | 427.6 ± 0.8% | 536.7 ± 0.7% | 353.2 ± 1.1% | 1.367 | 1.757 | 3.890 | 3.099 | 4.710 |
| messages: 11 string members | 1025025 | 1331.4 ± 0.6% | 1108.2 ± 1.4% | 775.3 ± 0.2% | 412.0 ± 0.4% | 420.5 ± 0.8% | 436.4 ± 4.9% | 1.201 | 1.717 | 3.231 | 3.167 | 3.051 |
| messages: 50 nested objects | 1121600 | 2012.6 ± 0.6% | 1892.1 ± 0.1% | 1359.8 ± 2.2% | 596.5 ± 3.0% | 611.9 ± 0.8% | 507.3 ± 3.1% | 1.064 | 1.480 | 3.374 | 3.289 | 3.968 |
| messages: a tree of 341 objects | 612600 | 597.4 ± 2.9% | 682.9 ± 1.0% | 580.6 ± 0.4% | 336.2 ± 0.8% | 355.2 ± 0.6% | 221.6 ± 5.3% | 0.875 | 1.029 | 1.777 | 1.682 | 2.695 |
| string: silesia/dickens | 172528 | 12983.9 ± 1.3% | 3947.8 ± 2.0% | 3055.8 ± 3.2% | 333.0 ± 0.7% | 1534.2 ± 1.3% | 1183.0 ± 0.6% | 3.289 | 4.249 | 38.992 | 8.463 | 10.975 |
| string: silesia/nci | 1075110 | 11295.3 ± 0.4% | 4733.9 ± 0.7% | 3131.2 ± 0.1% | 913.1 ± 0.5% | 1590.3 ± 1.6% | 1189.7 ± 5.2% | 2.386 | 3.607 | 12.370 | 7.103 | 9.494 |
| string: silesia/reymont | 1075159 | 5350.0 ± 2.4% | 1868.7 ± 0.7% | 1891.0 ± 0.3% | 377.6 ± 0.7% | 1301.7 ± 1.2% | 1042.1 ± 1.3% | 2.863 | 2.829 | 14.170 | 4.110 | 5.134 |
| string: silesia/samba | 97582 | 6326.9 ± 0.3% | 2707.3 ± 0.3% | 4059.6 ± 0.7% | 349.5 ± 0.8% | 1269.0 ± 0.7% | 1175.7 ± 1.0% | 2.337 | 1.558 | 18.104 | 4.986 | 5.382 |
| string: silesia/webster | 1098490 | 7083.6 ± 0.9% | 1993.4 ± 0.5% | 1764.4 ± 0.7% | 352.8 ± 1.1% | 1266.4 ± 0.8% | 610.7 ± 0.4% | 3.554 | 4.015 | 20.079 | 5.593 | 11.599 |
| string: silesia/xml | 1090118 | 10865.3 ± 0.9% | 3217.0 ± 0.4% | 2525.7 ± 0.5% | 607.5 ± 0.6% | 1727.1 ± 1.6% | 979.1 ± 0.6% | 3.377 | 4.302 | 17.884 | 6.291 | 11.097 |
| string: canterbury/alice29.txt | 159425 | 12736.6 ± 0.9% | 2899.4 ± 1.2% | 3052.4 ± 1.3% | 318.0 ± 0.9% | 1373.5 ± 2.4% | 1092.0 ± 2.5% | 4.393 | 4.173 | 40.056 | 9.273 | 11.663 |
| string: canterbury/asyoulik.txt | 132198 | 11026.5 ± 1.5% | 2098.4 ± 1.9% | 3119.6 ± 1.2% | 316.2 ± 1.0% | 1238.9 ± 1.3% | 952.3 ± 0.5% | 5.255 | 3.535 | 34.870 | 8.900 | 11.579 |
| string: canterbury/lcet10.txt | 441884 | 12668.0 ± 1.7% | 3066.8 ± 0.8% | 2577.0 ± 1.1% | 369.2 ± 0.4% | 1467.1 ± 2.1% | 1195.8 ± 1.0% | 4.131 | 4.916 | 34.317 | 8.635 | 10.594 |
| string: canterbury/plrabn12.txt | 503330 | 8827.2 ± 1.9% | 2319.4 ± 0.5% | 2098.9 ± 1.7% | 347.6 ± 1.0% | 1389.6 ± 0.8% | 1123.7 ± 0.9% | 3.806 | 4.206 | 25.392 | 6.352 | 7.855 |
| string: canterbury-large/E.coli | 1048578 | 31761.2 ± 1.3% | 15962.6 ± 1.2% | 3485.7 ± 0.7% | 1692.7 ± 0.4% | 3086.5 ± 2.2% | 1417.5 ± 0.5% | 1.990 | 9.112 | 18.764 | 10.290 | 22.406 |
| string: canterbury-large/bible.txt | 1055886 | 9705.5 ± 0.7% | 4926.3 ± 0.3% | 3015.9 ± 0.2% | 407.3 ± 1.1% | 2026.7 ± 0.5% | 1491.4 ± 4.8% | 1.970 | 3.218 | 23.828 | 4.789 | 6.508 |
| string: canterbury-large/world192.txt | 1103121 | 6676.8 ± 0.6% | 1740.5 ± 3.0% | 1893.6 ± 0.6% | 348.7 ± 0.8% | 1278.8 ± 0.9% | 966.6 ± 4.5% | 3.836 | 3.526 | 19.147 | 5.221 | 6.907 |
| string: http/html-1m | 1058582 | 10139.8 ± 0.5% | 4343.4 ± 1.4% | 2879.3 ± 1.1% | 421.5 ± 2.8% | 2013.5 ± 0.9% | 853.4 ± 0.5% | 2.335 | 3.522 | 24.056 | 5.036 | 11.882 |
| string: http/json-1m | 1190272 | 8118.7 ± 0.7% | 1588.3 ± 0.8% | 1577.2 ± 0.8% | 555.2 ± 0.5% | 1020.6 ± 0.7% | 838.5 ± 1.2% | 5.112 | 5.148 | 14.622 | 7.955 | 9.682 |
| string: http/js-1m | 1144362 | 6558.4 ± 1.5% | 1122.8 ± 0.7% | 1380.9 ± 0.9% | 330.2 ± 0.5% | 1029.4 ± 1.5% | 755.6 ± 1.0% | 5.841 | 4.749 | 19.864 | 6.371 | 8.680 |
| string: http/css-1m | 1097820 | 9297.8 ± 0.9% | 1480.1 ± 0.9% | 2290.6 ± 1.0% | 507.6 ± 0.9% | 1131.9 ± 1.3% | 876.3 ± 1.1% | 6.282 | 4.059 | 18.317 | 8.214 | 10.610 |
| string: dickens as Cyrillic and CJK | 1883069 | 5504.2 ± 2.1% | 3654.3 ± 0.4% | 490.0 ± 0.3% | 246.6 ± 2.5% | 455.1 ± 0.5% | 357.8 ± 0.3% | 1.506 | 11.234 | 22.321 | 12.095 | 15.383 |
| hex: silesia/dickens | 524290 | 42494.9 ± 0.6% | 2600.9 ± 0.4% | 1509.0 ± 0.2% | 460.4 ± 3.9% | 1508.4 ± 0.9% | 1072.1 ± 0.2% | 16.339 | 28.161 | 92.299 | 28.173 | 39.639 |
| hex: silesia/mozilla | 524290 | 43588.3 ± 0.2% | 2591.9 ± 0.6% | 1503.8 ± 1.3% | 386.5 ± 3.0% | 1533.0 ± 0.7% | 1071.1 ± 0.4% | 16.817 | 28.986 | 112.773 | 28.433 | 40.693 |
| hex: silesia/mr | 524290 | 43482.6 ± 1.9% | 2569.8 ± 0.5% | 1500.6 ± 0.8% | 594.4 ± 0.6% | 1552.6 ± 0.7% | 1061.7 ± 1.4% | 16.920 | 28.976 | 73.158 | 28.006 | 40.955 |
| hex: silesia/nci | 524290 | 43445.0 ± 0.7% | 2555.6 ± 9.4% | 1491.5 ± 0.9% | 751.7 ± 0.7% | 1556.6 ± 0.4% | 1063.1 ± 0.7% | 17.000 | 29.129 | 57.793 | 27.911 | 40.868 |
| hex: silesia/ooffice | 524290 | 43138.4 ± 1.0% | 2571.1 ± 0.6% | 1499.6 ± 0.5% | 322.4 ± 1.4% | 1558.8 ± 1.0% | 1057.1 ± 0.3% | 16.778 | 28.766 | 133.798 | 27.674 | 40.806 |
| hex: silesia/osdb | 524290 | 42045.8 ± 0.5% | 2593.7 ± 0.4% | 1506.9 ± 0.4% | 428.0 ± 0.5% | 1548.3 ± 1.0% | 1065.2 ± 0.4% | 16.210 | 27.901 | 98.245 | 27.156 | 39.473 |
| hex: silesia/reymont | 524290 | 43651.2 ± 3.7% | 2587.0 ± 0.4% | 1507.5 ± 0.4% | 482.5 ± 0.2% | 1531.3 ± 0.9% | 1068.6 ± 0.3% | 16.873 | 28.956 | 90.461 | 28.506 | 40.849 |
| hex: silesia/samba | 524290 | 43415.6 ± 1.1% | 2589.9 ± 0.8% | 1499.5 ± 0.7% | 332.7 ± 1.4% | 1529.5 ± 1.1% | 1062.9 ± 0.4% | 16.763 | 28.954 | 130.502 | 28.385 | 40.847 |
| hex: silesia/sao | 524290 | 43596.7 ± 1.1% | 2592.9 ± 0.7% | 1507.6 ± 0.5% | 270.2 ± 2.5% | 1529.9 ± 0.9% | 1066.0 ± 0.5% | 16.814 | 28.917 | 161.351 | 28.496 | 40.899 |
| hex: silesia/webster | 524290 | 43780.9 ± 0.4% | 2582.1 ± 1.5% | 1497.1 ± 0.9% | 435.1 ± 1.0% | 1554.4 ± 1.2% | 1063.1 ± 1.2% | 16.955 | 29.243 | 100.614 | 28.165 | 41.184 |
| hex: silesia/x-ray | 524290 | 43424.9 ± 8.1% | 2576.0 ± 0.7% | 1503.3 ± 0.5% | 419.7 ± 0.7% | 1524.1 ± 1.1% | 1064.4 ± 0.4% | 16.857 | 28.887 | 103.457 | 28.491 | 40.799 |
| hex: silesia/xml | 524290 | 43400.0 ± 8.2% | 2591.3 ± 1.0% | 1506.2 ± 0.4% | 685.7 ± 1.0% | 1538.8 ± 0.8% | 1068.3 ± 0.8% | 16.748 | 28.813 | 63.295 | 28.204 | 40.624 |
| hex: canterbury/alice29.txt | 304180 | 41539.3 ± 6.7% | 2606.9 ± 0.9% | 1519.1 ± 0.7% | 468.8 ± 0.3% | 1544.7 ± 0.7% | 1081.7 ± 0.3% | 15.934 | 27.345 | 88.616 | 26.892 | 38.402 |
| hex: canterbury/asyoulik.txt | 250360 | 43425.3 ± 2.0% | 2612.9 ± 0.6% | 1536.3 ± 0.5% | 456.8 ± 1.1% | 1554.1 ± 1.0% | 1079.3 ± 0.7% | 16.620 | 28.266 | 95.057 | 27.942 | 40.235 |
| hex: canterbury/cp.html | 49208 | 42549.6 ± 1.6% | 2590.0 ± 0.7% | 1521.7 ± 0.8% | 478.5 ± 5.5% | 1582.6 ± 0.9% | 1090.2 ± 0.7% | 16.428 | 27.961 | 88.920 | 26.886 | 39.028 |
| hex: canterbury/fields.c | 22302 | 41809.8 ± 5.8% | 2646.2 ± 0.9% | 1529.2 ± 0.5% | 600.0 ± 5.0% | 1603.5 ± 0.3% | 1098.4 ± 0.8% | 15.800 | 27.340 | 69.680 | 26.074 | 38.063 |
| hex: canterbury/grammar.lsp | 7444 | 38995.7 ± 1.1% | 2665.7 ± 11.6% | 1533.3 ± 6.4% | 809.0 ± 0.4% | 1599.1 ± 0.3% | 1102.7 ± 0.8% | 14.629 | 25.432 | 48.204 | 24.387 | 35.364 |
| hex: canterbury/kennedy.xls | 524290 | 43335.1 ± 1.2% | 2562.7 ± 0.7% | 1501.2 ± 0.5% | 773.7 ± 0.7% | 1494.2 ± 6.3% | 1063.8 ± 0.7% | 16.910 | 28.866 | 56.013 | 29.003 | 40.738 |
| hex: canterbury/lcet10.txt | 524290 | 43244.9 ± 1.9% | 2577.7 ± 0.9% | 1501.9 ± 1.2% | 464.6 ± 1.0% | 1501.0 ± 1.0% | 1058.8 ± 1.1% | 16.776 | 28.793 | 93.086 | 28.811 | 40.844 |
| hex: canterbury/plrabn12.txt | 524290 | 42806.2 ± 2.3% | 2574.3 ± 1.6% | 1501.8 ± 1.7% | 448.6 ± 5.6% | 1506.3 ± 6.5% | 1063.5 ± 1.3% | 16.629 | 28.503 | 95.412 | 28.419 | 40.250 |
| hex: canterbury/ptt5 | 524290 | 42780.0 ± 1.1% | 2561.6 ± 0.9% | 1506.7 ± 1.2% | 592.3 ± 2.1% | 1565.5 ± 1.8% | 1065.8 ± 6.4% | 16.701 | 28.393 | 72.225 | 27.326 | 40.138 |
| hex: canterbury/sum | 76482 | 42068.1 ± 1.0% | 2568.6 ± 0.5% | 1506.4 ± 1.1% | 556.2 ± 1.0% | 1563.1 ± 1.1% | 1080.9 ± 1.5% | 16.378 | 27.926 | 75.630 | 26.913 | 38.919 |
| hex: canterbury/xargs.1 | 8456 | 38141.1 ± 1.2% | 2686.5 ± 0.7% | 1547.1 ± 0.4% | 843.2 ± 0.5% | 1613.3 ± 0.7% | 1106.6 ± 0.9% | 14.197 | 24.653 | 45.234 | 23.641 | 34.467 |
| hex: canterbury-large/E.coli | 524290 | 41277.7 ± 0.9% | 2571.3 ± 0.8% | 1502.1 ± 1.4% | 803.3 ± 1.2% | 1490.5 ± 1.7% | 1065.3 ± 0.9% | 16.053 | 27.479 | 51.382 | 27.694 | 38.747 |
| hex: canterbury-large/bible.txt | 524290 | 43183.5 ± 1.1% | 2574.9 ± 1.0% | 1508.6 ± 0.8% | 481.0 ± 0.7% | 1561.5 ± 1.5% | 1065.3 ± 1.3% | 16.771 | 28.626 | 89.769 | 27.655 | 40.537 |
| hex: canterbury-large/world192.txt | 524290 | 42747.5 ± 0.7% | 2566.2 ± 0.8% | 1501.4 ± 0.8% | 454.4 ± 0.4% | 1499.8 ± 6.2% | 1062.6 ± 0.4% | 16.658 | 28.471 | 94.079 | 28.502 | 40.228 |
| hex: http/html-1kx1024 | 2099200 | 20285.5 ± 0.5% | 2358.5 ± 1.6% | 1456.7 ± 1.2% | 499.0 ± 0.8% | 1491.1 ± 1.1% | 1078.3 ± 1.2% | 8.601 | 13.925 | 40.651 | 13.604 | 18.813 |
| hex: http/html-16kx64 | 2097280 | 21608.0 ± 0.6% | 2217.8 ± 1.3% | 1443.0 ± 1.1% | 503.1 ± 0.9% | 1444.6 ± 1.0% | 1080.0 ± 5.6% | 9.743 | 14.975 | 42.952 | 14.957 | 20.008 |
| hex: http/html-1m | 524290 | 42900.0 ± 1.5% | 2589.1 ± 0.7% | 1507.6 ± 1.0% | 485.1 ± 1.6% | 1508.7 ± 1.5% | 1063.9 ± 1.1% | 16.569 | 28.456 | 88.444 | 28.434 | 40.325 |
| hex: http/json-1kx1024 | 2099200 | 20193.3 ± 0.5% | 2340.3 ± 1.5% | 1456.7 ± 1.3% | 696.5 ± 0.7% | 1506.2 ± 1.4% | 1078.1 ± 1.3% | 8.628 | 13.862 | 28.992 | 13.407 | 18.730 |
| hex: http/json-16kx64 | 2097280 | 21203.1 ± 0.4% | 2226.1 ± 1.1% | 1443.6 ± 1.2% | 701.0 ± 4.0% | 1439.8 ± 1.2% | 1082.0 ± 1.2% | 9.525 | 14.688 | 30.248 | 14.726 | 19.596 |
| hex: http/json-1m | 524290 | 43058.6 ± 1.2% | 2573.9 ± 0.3% | 1496.5 ± 0.7% | 718.7 ± 4.2% | 1492.6 ± 1.7% | 1060.1 ± 6.0% | 16.729 | 28.773 | 59.913 | 28.848 | 40.618 |
| hex: http/js-1kx1024 | 2099200 | 20123.3 ± 0.4% | 2334.1 ± 0.7% | 1442.7 ± 1.1% | 486.3 ± 1.0% | 1485.2 ± 0.4% | 1061.7 ± 7.4% | 8.621 | 13.948 | 41.378 | 13.549 | 18.954 |
| hex: http/js-16kx64 | 2097280 | 22094.8 ± 0.2% | 2213.9 ± 1.4% | 1439.7 ± 1.2% | 489.2 ± 1.2% | 1446.9 ± 1.2% | 1076.3 ± 6.6% | 9.980 | 15.347 | 45.165 | 15.271 | 20.529 |
| hex: http/js-1m | 524290 | 43240.1 ± 8.8% | 2567.4 ± 0.5% | 1497.6 ± 0.5% | 503.6 ± 0.9% | 1557.9 ± 0.7% | 1062.8 ± 0.5% | 16.842 | 28.872 | 85.863 | 27.756 | 40.685 |
| hex: http/css-1kx1024 | 2099200 | 20472.8 ± 0.5% | 2340.1 ± 0.6% | 1447.4 ± 0.9% | 552.6 ± 0.6% | 1496.6 ± 1.1% | 1066.9 ± 0.5% | 8.749 | 14.144 | 37.047 | 13.679 | 19.189 |
| hex: http/css-16kx64 | 2097280 | 22122.5 ± 0.1% | 2209.8 ± 0.9% | 1438.4 ± 1.0% | 560.8 ± 1.0% | 1438.7 ± 0.7% | 1077.9 ± 0.4% | 10.011 | 15.380 | 39.445 | 15.377 | 20.524 |
| hex: http/css-1m | 524290 | 43098.1 ± 0.8% | 2577.3 ± 0.8% | 1499.6 ± 0.3% | 530.5 ± 0.4% | 1499.3 ± 1.6% | 1062.0 ± 0.7% | 16.722 | 28.739 | 81.238 | 28.745 | 40.580 |
| hex: shuffled/dickens-1m | 524290 | 41750.3 ± 8.5% | 2572.0 ± 5.8% | 1492.2 ± 6.9% | 459.7 ± 2.6% | 1560.2 ± 1.3% | 1062.5 ± 1.3% | 16.233 | 27.979 | 90.814 | 26.760 | 39.294 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1782.1 ± 0.5% | 1476.6 ± 3.5% | 1029.3 ± 2.2% | 461.0 ± 8.3% | 434.8 ± 2.3% | 501.8 ± 0.6% | 1.207 | 1.731 | 3.866 | 4.099 | 3.551 |
| qlog records, JSON text sequence | 1467503 | 1730.4 ± 8.6% | 1217.0 ± 1.7% | 946.9 ± 2.6% | 427.6 ± 0.8% | 536.7 ± 0.7% | 353.2 ± 1.1% | 1.422 | 1.827 | 4.047 | 3.224 | 4.900 |
| messages: 11 string members | 1025025 | 1329.2 ± 0.3% | 1108.2 ± 1.4% | 775.3 ± 0.2% | 412.0 ± 0.4% | 420.5 ± 0.8% | 436.4 ± 4.9% | 1.199 | 1.714 | 3.226 | 3.161 | 3.046 |
| messages: 50 nested objects | 1121600 | 2022.8 ± 0.4% | 1892.1 ± 0.1% | 1359.8 ± 2.2% | 596.5 ± 3.0% | 611.9 ± 0.8% | 507.3 ± 3.1% | 1.069 | 1.488 | 3.391 | 3.306 | 3.988 |
| messages: a tree of 341 objects | 612600 | 649.8 ± 0.6% | 682.9 ± 1.0% | 580.6 ± 0.4% | 336.2 ± 0.8% | 355.2 ± 0.6% | 221.6 ± 5.3% | 0.952 | 1.119 | 1.933 | 1.829 | 2.932 |
| string: silesia/dickens | 172528 | 13490.0 ± 1.4% | 3947.8 ± 2.0% | 3055.8 ± 3.2% | 333.0 ± 0.7% | 1534.2 ± 1.3% | 1183.0 ± 0.6% | 3.417 | 4.415 | 40.512 | 8.793 | 11.403 |
| string: silesia/nci | 1075110 | 11716.0 ± 0.3% | 4733.9 ± 0.7% | 3131.2 ± 0.1% | 913.1 ± 0.5% | 1590.3 ± 1.6% | 1189.7 ± 5.2% | 2.475 | 3.742 | 12.831 | 7.367 | 9.848 |
| string: silesia/reymont | 1075159 | 5459.8 ± 1.0% | 1868.7 ± 0.7% | 1891.0 ± 0.3% | 377.6 ± 0.7% | 1301.7 ± 1.2% | 1042.1 ± 1.3% | 2.922 | 2.887 | 14.461 | 4.194 | 5.239 |
| string: silesia/samba | 97582 | 7325.6 ± 0.4% | 2707.3 ± 0.3% | 4059.6 ± 0.7% | 349.5 ± 0.8% | 1269.0 ± 0.7% | 1175.7 ± 1.0% | 2.706 | 1.804 | 20.962 | 5.773 | 6.231 |
| string: silesia/webster | 1098490 | 7018.3 ± 0.5% | 1993.4 ± 0.5% | 1764.4 ± 0.7% | 352.8 ± 1.1% | 1266.4 ± 0.8% | 610.7 ± 0.4% | 3.521 | 3.978 | 19.894 | 5.542 | 11.492 |
| string: silesia/xml | 1090118 | 11209.8 ± 0.5% | 3217.0 ± 0.4% | 2525.7 ± 0.5% | 607.5 ± 0.6% | 1727.1 ± 1.6% | 979.1 ± 0.6% | 3.485 | 4.438 | 18.451 | 6.490 | 11.449 |
| string: canterbury/alice29.txt | 159425 | 13378.2 ± 0.6% | 2899.4 ± 1.2% | 3052.4 ± 1.3% | 318.0 ± 0.9% | 1373.5 ± 2.4% | 1092.0 ± 2.5% | 4.614 | 4.383 | 42.074 | 9.740 | 12.251 |
| string: canterbury/asyoulik.txt | 132198 | 11466.0 ± 0.5% | 2098.4 ± 1.9% | 3119.6 ± 1.2% | 316.2 ± 1.0% | 1238.9 ± 1.3% | 952.3 ± 0.5% | 5.464 | 3.675 | 36.260 | 9.255 | 12.040 |
| string: canterbury/lcet10.txt | 441884 | 12736.6 ± 1.0% | 3066.8 ± 0.8% | 2577.0 ± 1.1% | 369.2 ± 0.4% | 1467.1 ± 2.1% | 1195.8 ± 1.0% | 4.153 | 4.943 | 34.502 | 8.682 | 10.651 |
| string: canterbury/plrabn12.txt | 503330 | 9048.8 ± 0.8% | 2319.4 ± 0.5% | 2098.9 ± 1.7% | 347.6 ± 1.0% | 1389.6 ± 0.8% | 1123.7 ± 0.9% | 3.901 | 4.311 | 26.029 | 6.512 | 8.053 |
| string: canterbury-large/E.coli | 1048578 | 31780.9 ± 0.9% | 15962.6 ± 1.2% | 3485.7 ± 0.7% | 1692.7 ± 0.4% | 3086.5 ± 2.2% | 1417.5 ± 0.5% | 1.991 | 9.117 | 18.775 | 10.297 | 22.420 |
| string: canterbury-large/bible.txt | 1055886 | 9904.6 ± 0.6% | 4926.3 ± 0.3% | 3015.9 ± 0.2% | 407.3 ± 1.1% | 2026.7 ± 0.5% | 1491.4 ± 4.8% | 2.011 | 3.284 | 24.316 | 4.887 | 6.641 |
| string: canterbury-large/world192.txt | 1103121 | 6485.7 ± 0.6% | 1740.5 ± 3.0% | 1893.6 ± 0.6% | 348.7 ± 0.8% | 1278.8 ± 0.9% | 966.6 ± 4.5% | 3.726 | 3.425 | 18.599 | 5.072 | 6.710 |
| string: http/html-1m | 1058582 | 10299.8 ± 0.7% | 4343.4 ± 1.4% | 2879.3 ± 1.1% | 421.5 ± 2.8% | 2013.5 ± 0.9% | 853.4 ± 0.5% | 2.371 | 3.577 | 24.436 | 5.115 | 12.069 |
| string: http/json-1m | 1190272 | 8265.0 ± 0.5% | 1588.3 ± 0.8% | 1577.2 ± 0.8% | 555.2 ± 0.5% | 1020.6 ± 0.7% | 838.5 ± 1.2% | 5.204 | 5.240 | 14.885 | 8.098 | 9.857 |
| string: http/js-1m | 1144362 | 6616.9 ± 0.8% | 1122.8 ± 0.7% | 1380.9 ± 0.9% | 330.2 ± 0.5% | 1029.4 ± 1.5% | 755.6 ± 1.0% | 5.893 | 4.792 | 20.042 | 6.428 | 8.757 |
| string: http/css-1m | 1097820 | 9156.7 ± 2.6% | 1480.1 ± 0.9% | 2290.6 ± 1.0% | 507.6 ± 0.9% | 1131.9 ± 1.3% | 876.3 ± 1.1% | 6.186 | 3.997 | 18.039 | 8.089 | 10.449 |
| string: dickens as Cyrillic and CJK | 1883069 | 5666.5 ± 1.5% | 3654.3 ± 0.4% | 490.0 ± 0.3% | 246.6 ± 2.5% | 455.1 ± 0.5% | 357.8 ± 0.3% | 1.551 | 11.565 | 22.980 | 12.451 | 15.837 |
| hex: silesia/dickens | 524290 | 42474.2 ± 0.3% | 2600.9 ± 0.4% | 1509.0 ± 0.2% | 460.4 ± 3.9% | 1508.4 ± 0.9% | 1072.1 ± 0.2% | 16.331 | 28.147 | 92.254 | 28.159 | 39.619 |
| hex: silesia/mozilla | 524290 | 43609.7 ± 1.2% | 2591.9 ± 0.6% | 1503.8 ± 1.3% | 386.5 ± 3.0% | 1533.0 ± 0.7% | 1071.1 ± 0.4% | 16.825 | 29.000 | 112.829 | 28.447 | 40.713 |
| hex: silesia/mr | 524290 | 43463.9 ± 0.9% | 2569.8 ± 0.5% | 1500.6 ± 0.8% | 594.4 ± 0.6% | 1552.6 ± 0.7% | 1061.7 ± 1.4% | 16.913 | 28.964 | 73.126 | 27.994 | 40.938 |
| hex: silesia/nci | 524290 | 43316.0 ± 1.0% | 2555.6 ± 9.4% | 1491.5 ± 0.9% | 751.7 ± 0.7% | 1556.6 ± 0.4% | 1063.1 ± 0.7% | 16.949 | 29.042 | 57.622 | 27.828 | 40.747 |
| hex: silesia/ooffice | 524290 | 43361.9 ± 1.2% | 2571.1 ± 0.6% | 1499.6 ± 0.5% | 322.4 ± 1.4% | 1558.8 ± 1.0% | 1057.1 ± 0.3% | 16.865 | 28.915 | 134.491 | 27.818 | 41.018 |
| hex: silesia/osdb | 524290 | 42098.2 ± 1.0% | 2593.7 ± 0.4% | 1506.9 ± 0.4% | 428.0 ± 0.5% | 1548.3 ± 1.0% | 1065.2 ± 0.4% | 16.231 | 27.936 | 98.368 | 27.190 | 39.523 |
| hex: silesia/reymont | 524290 | 42637.9 ± 7.6% | 2587.0 ± 0.4% | 1507.5 ± 0.4% | 482.5 ± 0.2% | 1531.3 ± 0.9% | 1068.6 ± 0.3% | 16.482 | 28.283 | 88.361 | 27.844 | 39.901 |
| hex: silesia/samba | 524290 | 43129.0 ± 1.8% | 2589.9 ± 0.8% | 1499.5 ± 0.7% | 332.7 ± 1.4% | 1529.5 ± 1.1% | 1062.9 ± 0.4% | 16.652 | 28.763 | 129.641 | 28.198 | 40.577 |
| hex: silesia/sao | 524290 | 43677.2 ± 0.8% | 2592.9 ± 0.7% | 1507.6 ± 0.5% | 270.2 ± 2.5% | 1529.9 ± 0.9% | 1066.0 ± 0.5% | 16.845 | 28.970 | 161.649 | 28.549 | 40.975 |
| hex: silesia/webster | 524290 | 43741.9 ± 0.6% | 2582.1 ± 1.5% | 1497.1 ± 0.9% | 435.1 ± 1.0% | 1554.4 ± 1.2% | 1063.1 ± 1.2% | 16.940 | 29.217 | 100.524 | 28.140 | 41.147 |
| hex: silesia/x-ray | 524290 | 43538.2 ± 0.8% | 2576.0 ± 0.7% | 1503.3 ± 0.5% | 419.7 ± 0.7% | 1524.1 ± 1.1% | 1064.4 ± 0.4% | 16.901 | 28.962 | 103.727 | 28.566 | 40.905 |
| hex: silesia/xml | 524290 | 43580.8 ± 1.1% | 2591.3 ± 1.0% | 1506.2 ± 0.4% | 685.7 ± 1.0% | 1538.8 ± 0.8% | 1068.3 ± 0.8% | 16.818 | 28.933 | 63.558 | 28.321 | 40.794 |
| hex: canterbury/alice29.txt | 304180 | 41862.4 ± 1.3% | 2606.9 ± 0.9% | 1519.1 ± 0.7% | 468.8 ± 0.3% | 1544.7 ± 0.7% | 1081.7 ± 0.3% | 16.058 | 27.557 | 89.305 | 27.101 | 38.701 |
| hex: canterbury/asyoulik.txt | 250360 | 43354.8 ± 1.3% | 2612.9 ± 0.6% | 1536.3 ± 0.5% | 456.8 ± 1.1% | 1554.1 ± 1.0% | 1079.3 ± 0.7% | 16.593 | 28.221 | 94.902 | 27.896 | 40.170 |
| hex: canterbury/cp.html | 49208 | 42607.6 ± 0.8% | 2590.0 ± 0.7% | 1521.7 ± 0.8% | 478.5 ± 5.5% | 1582.6 ± 0.9% | 1090.2 ± 0.7% | 16.451 | 27.999 | 89.041 | 26.923 | 39.081 |
| hex: canterbury/fields.c | 22302 | 41950.4 ± 0.9% | 2646.2 ± 0.9% | 1529.2 ± 0.5% | 600.0 ± 5.0% | 1603.5 ± 0.3% | 1098.4 ± 0.8% | 15.853 | 27.432 | 69.914 | 26.161 | 38.191 |
| hex: canterbury/grammar.lsp | 7444 | 39199.6 ± 0.6% | 2665.7 ± 11.6% | 1533.3 ± 6.4% | 809.0 ± 0.4% | 1599.1 ± 0.3% | 1102.7 ± 0.8% | 14.705 | 25.565 | 48.456 | 24.514 | 35.549 |
| hex: canterbury/kennedy.xls | 524290 | 43169.5 ± 1.3% | 2562.7 ± 0.7% | 1501.2 ± 0.5% | 773.7 ± 0.7% | 1494.2 ± 6.3% | 1063.8 ± 0.7% | 16.845 | 28.756 | 55.799 | 28.892 | 40.582 |
| hex: canterbury/lcet10.txt | 524290 | 43110.4 ± 2.2% | 2577.7 ± 0.9% | 1501.9 ± 1.2% | 464.6 ± 1.0% | 1501.0 ± 1.0% | 1058.8 ± 1.1% | 16.724 | 28.704 | 92.796 | 28.721 | 40.717 |
| hex: canterbury/plrabn12.txt | 524290 | 42763.4 ± 0.3% | 2574.3 ± 1.6% | 1501.8 ± 1.7% | 448.6 ± 5.6% | 1506.3 ± 6.5% | 1063.5 ± 1.3% | 16.612 | 28.475 | 95.317 | 28.390 | 40.210 |
| hex: canterbury/ptt5 | 524290 | 42723.8 ± 0.1% | 2561.6 ± 0.9% | 1506.7 ± 1.2% | 592.3 ± 2.1% | 1565.5 ± 1.8% | 1065.8 ± 6.4% | 16.679 | 28.355 | 72.130 | 27.290 | 40.085 |
| hex: canterbury/sum | 76482 | 41971.9 ± 6.9% | 2568.6 ± 0.5% | 1506.4 ± 1.1% | 556.2 ± 1.0% | 1563.1 ± 1.1% | 1080.9 ± 1.5% | 16.340 | 27.862 | 75.457 | 26.851 | 38.830 |
| hex: canterbury/xargs.1 | 8456 | 38514.9 ± 2.3% | 2686.5 ± 0.7% | 1547.1 ± 0.4% | 843.2 ± 0.5% | 1613.3 ± 0.7% | 1106.6 ± 0.9% | 14.337 | 24.894 | 45.677 | 23.873 | 34.804 |
| hex: canterbury-large/E.coli | 524290 | 41047.7 ± 1.1% | 2571.3 ± 0.8% | 1502.1 ± 1.4% | 803.3 ± 1.2% | 1490.5 ± 1.7% | 1065.3 ± 0.9% | 15.964 | 27.326 | 51.096 | 27.540 | 38.532 |
| hex: canterbury-large/bible.txt | 524290 | 42758.1 ± 0.9% | 2574.9 ± 1.0% | 1508.6 ± 0.8% | 481.0 ± 0.7% | 1561.5 ± 1.5% | 1065.3 ± 1.3% | 16.606 | 28.344 | 88.885 | 27.383 | 40.138 |
| hex: canterbury-large/world192.txt | 524290 | 43085.4 ± 2.3% | 2566.2 ± 0.8% | 1501.4 ± 0.8% | 454.4 ± 0.4% | 1499.8 ± 6.2% | 1062.6 ± 0.4% | 16.790 | 28.696 | 94.823 | 28.727 | 40.546 |
| hex: http/html-1kx1024 | 2099200 | 20385.1 ± 0.6% | 2358.5 ± 1.6% | 1456.7 ± 1.2% | 499.0 ± 0.8% | 1491.1 ± 1.1% | 1078.3 ± 1.2% | 8.643 | 13.994 | 40.850 | 13.671 | 18.906 |
| hex: http/html-16kx64 | 2097280 | 21641.1 ± 0.2% | 2217.8 ± 1.3% | 1443.0 ± 1.1% | 503.1 ± 0.9% | 1444.6 ± 1.0% | 1080.0 ± 5.6% | 9.758 | 14.998 | 43.018 | 14.980 | 20.038 |
| hex: http/html-1m | 524290 | 42825.1 ± 1.5% | 2589.1 ± 0.7% | 1507.6 ± 1.0% | 485.1 ± 1.6% | 1508.7 ± 1.5% | 1063.9 ± 1.1% | 16.540 | 28.407 | 88.289 | 28.385 | 40.255 |
| hex: http/json-1kx1024 | 2099200 | 20305.7 ± 0.3% | 2340.3 ± 1.5% | 1456.7 ± 1.3% | 696.5 ± 0.7% | 1506.2 ± 1.4% | 1078.1 ± 1.3% | 8.676 | 13.939 | 29.153 | 13.482 | 18.835 |
| hex: http/json-16kx64 | 2097280 | 21261.0 ± 0.4% | 2226.1 ± 1.1% | 1443.6 ± 1.2% | 701.0 ± 4.0% | 1439.8 ± 1.2% | 1082.0 ± 1.2% | 9.551 | 14.728 | 30.330 | 14.766 | 19.649 |
| hex: http/json-1m | 524290 | 42867.7 ± 1.0% | 2573.9 ± 0.3% | 1496.5 ± 0.7% | 718.7 ± 4.2% | 1492.6 ± 1.7% | 1060.1 ± 6.0% | 16.655 | 28.646 | 59.648 | 28.720 | 40.438 |
| hex: http/js-1kx1024 | 2099200 | 20209.4 ± 0.2% | 2334.1 ± 0.7% | 1442.7 ± 1.1% | 486.3 ± 1.0% | 1485.2 ± 0.4% | 1061.7 ± 7.4% | 8.658 | 14.008 | 41.556 | 13.607 | 19.035 |
| hex: http/js-16kx64 | 2097280 | 22176.5 ± 0.4% | 2213.9 ± 1.4% | 1439.7 ± 1.2% | 489.2 ± 1.2% | 1446.9 ± 1.2% | 1076.3 ± 6.6% | 10.017 | 15.404 | 45.332 | 15.327 | 20.605 |
| hex: http/js-1m | 524290 | 43174.4 ± 1.1% | 2567.4 ± 0.5% | 1497.6 ± 0.5% | 503.6 ± 0.9% | 1557.9 ± 0.7% | 1062.8 ± 0.5% | 16.816 | 28.828 | 85.732 | 27.714 | 40.623 |
| hex: http/css-1kx1024 | 2099200 | 20590.6 ± 0.1% | 2340.1 ± 0.6% | 1447.4 ± 0.9% | 552.6 ± 0.6% | 1496.6 ± 1.1% | 1066.9 ± 0.5% | 8.799 | 14.226 | 37.260 | 13.758 | 19.299 |
| hex: http/css-16kx64 | 2097280 | 22205.2 ± 0.1% | 2209.8 ± 0.9% | 1438.4 ± 1.0% | 560.8 ± 1.0% | 1438.7 ± 0.7% | 1077.9 ± 0.4% | 10.049 | 15.438 | 39.592 | 15.435 | 20.601 |
| hex: http/css-1m | 524290 | 43302.2 ± 4.6% | 2577.3 ± 0.8% | 1499.6 ± 0.3% | 530.5 ± 0.4% | 1499.3 ± 1.6% | 1062.0 ± 0.7% | 16.801 | 28.875 | 81.623 | 28.881 | 40.773 |
| hex: shuffled/dickens-1m | 524290 | 41873.7 ± 1.7% | 2572.0 ± 5.8% | 1492.2 ± 6.9% | 459.7 ± 2.6% | 1560.2 ± 1.3% | 1062.5 ± 1.3% | 16.281 | 28.062 | 91.083 | 26.839 | 39.410 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1146.3 ± 42.4% | 1524.8 ± 46.5% | 1112.0 ± 58.0% | 389.4 ± 3.5% | 673.2 ± 0.3% | 363.8 ± 1.8% | 0.752 | 1.031 | 2.944 | 1.703 | 3.151 |
| qlog records, JSON text sequence | 1467503 | 1002.9 ± 0.4% | 1241.6 ± 1.1% | 1127.6 ± 0.4% | 330.2 ± 0.9% | 754.8 ± 0.4% | 308.8 ± 0.9% | 0.808 | 0.889 | 3.037 | 1.329 | 3.247 |
| messages: 11 string members | 1025025 | 954.5 ± 0.3% | 2033.8 ± 5.3% | 722.3 ± 1.5% | 336.8 ± 0.2% | 510.5 ± 0.3% | 292.5 ± 1.4% | 0.469 | 1.322 | 2.834 | 1.870 | 3.264 |
| messages: 50 nested objects | 1121600 | 1240.1 ± 1.2% | 1712.3 ± 4.4% | 1455.6 ± 0.4% | 432.6 ± 0.7% | 905.3 ± 0.4% | 419.8 ± 0.3% | 0.724 | 0.852 | 2.867 | 1.370 | 2.954 |
| messages: a tree of 341 objects | 612600 | 547.4 ± 2.2% | 848.9 ± 1.1% | 702.9 ± 1.9% | 182.8 ± 0.9% | 611.2 ± 0.6% | 208.7 ± 1.3% | 0.645 | 0.779 | 2.995 | 0.896 | 2.623 |
| string: silesia/dickens | 172528 | 6724.4 ± 0.3% | 3440.0 ± 1.2% | 2829.7 ± 1.5% | 316.9 ± 0.2% | 3090.7 ± 0.3% | 572.8 ± 2.3% | 1.955 | 2.376 | 21.219 | 2.176 | 11.740 |
| string: silesia/nci | 1075110 | 5455.0 ± 1.7% | 3915.4 ± 1.4% | 3050.3 ± 1.1% | 649.5 ± 0.8% | 3646.7 ± 3.9% | 553.2 ± 5.5% | 1.393 | 1.788 | 8.399 | 1.496 | 9.861 |
| string: silesia/reymont | 1075159 | 3466.8 ± 1.1% | 3419.4 ± 0.3% | 1941.7 ± 1.8% | 342.5 ± 0.5% | 2110.5 ± 0.3% | 492.2 ± 3.3% | 1.014 | 1.785 | 10.122 | 1.643 | 7.043 |
| string: silesia/samba | 97582 | 3984.3 ± 0.6% | 3794.3 ± 2.1% | 3051.5 ± 0.8% | 328.0 ± 3.6% | 1964.0 ± 1.8% | 419.6 ± 2.7% | 1.050 | 1.306 | 12.149 | 2.029 | 9.495 |
| string: silesia/webster | 1098490 | 4387.6 ± 0.7% | 2448.4 ± 0.4% | 1738.6 ± 1.8% | 309.3 ± 10.5% | 2069.7 ± 3.7% | 451.1 ± 1.9% | 1.792 | 2.524 | 14.188 | 2.120 | 9.726 |
| string: silesia/xml | 1090118 | 6114.6 ± 5.6% | 5082.6 ± 9.4% | 2451.9 ± 4.5% | 507.2 ± 1.1% | 3329.3 ± 2.4% | 528.7 ± 4.7% | 1.203 | 2.494 | 12.056 | 1.837 | 11.566 |
| string: canterbury/alice29.txt | 159425 | 5826.1 ± 1.1% | 2787.4 ± 0.9% | 2808.5 ± 3.4% | 299.5 ± 5.1% | 2755.9 ± 11.4% | 514.0 ± 3.3% | 2.090 | 2.074 | 19.454 | 2.114 | 11.334 |
| string: canterbury/asyoulik.txt | 132198 | 4315.8 ± 0.4% | 2585.6 ± 2.6% | 2783.2 ± 1.1% | 305.0 ± 0.5% | 2406.4 ± 1.5% | 450.9 ± 3.6% | 1.669 | 1.551 | 14.150 | 1.793 | 9.572 |
| string: canterbury/lcet10.txt | 441884 | 6678.2 ± 0.4% | 3274.8 ± 0.7% | 2310.0 ± 2.6% | 345.3 ± 0.4% | 2788.3 ± 0.6% | 564.1 ± 2.6% | 2.039 | 2.891 | 19.341 | 2.395 | 11.838 |
| string: canterbury/plrabn12.txt | 503330 | 5471.0 ± 0.2% | 3148.0 ± 0.8% | 1842.2 ± 0.7% | 322.7 ± 0.3% | 2837.8 ± 0.5% | 533.4 ± 0.9% | 1.738 | 2.970 | 16.953 | 1.928 | 10.257 |
| string: canterbury-large/E.coli | 1048578 | 33976.1 ± 0.4% | 12968.6 ± 0.6% | 3408.3 ± 0.3% | 1283.5 ± 0.2% | 8920.8 ± 0.8% | 939.3 ± 4.2% | 2.620 | 9.969 | 26.472 | 3.809 | 36.172 |
| string: canterbury-large/bible.txt | 1055886 | 8679.5 ± 1.9% | 5267.4 ± 0.5% | 2795.4 ± 3.0% | 356.6 ± 0.4% | 3903.3 ± 0.4% | 627.0 ± 2.5% | 1.648 | 3.105 | 24.336 | 2.224 | 13.844 |
| string: canterbury-large/world192.txt | 1103121 | 4161.0 ± 0.8% | 2314.8 ± 0.2% | 1762.4 ± 0.6% | 326.8 ± 0.8% | 2112.3 ± 0.4% | 469.1 ± 2.0% | 1.798 | 2.361 | 12.734 | 1.970 | 8.870 |
| string: http/html-1m | 1058582 | 8865.4 ± 5.4% | 4737.5 ± 1.5% | 2680.8 ± 0.5% | 425.6 ± 0.4% | 3652.7 ± 1.2% | 598.3 ± 0.9% | 1.871 | 3.307 | 20.830 | 2.427 | 14.817 |
| string: http/json-1m | 1190272 | 3364.5 ± 1.0% | 1257.2 ± 0.6% | 2097.9 ± 0.5% | 475.8 ± 1.0% | 1338.6 ± 0.7% | 436.7 ± 1.2% | 2.676 | 1.604 | 7.071 | 2.513 | 7.704 |
| string: http/js-1m | 1144362 | 2853.4 ± 0.1% | 1611.5 ± 0.2% | 1325.9 ± 0.2% | 325.7 ± 0.3% | 1426.1 ± 0.2% | 380.6 ± 0.8% | 1.771 | 2.152 | 8.760 | 2.001 | 7.498 |
| string: http/css-1m | 1097820 | 3323.0 ± 0.7% | 2892.4 ± 0.4% | 2280.5 ± 0.7% | 452.5 ± 0.6% | 2074.1 ± 0.3% | 438.7 ± 1.4% | 1.149 | 1.457 | 7.344 | 1.602 | 7.574 |
| string: dickens as Cyrillic and CJK | 1883069 | 5816.0 ± 0.9% | 3299.2 ± 7.1% | 664.3 ± 0.4% | 377.8 ± 0.5% | 512.2 ± 0.3% | 163.8 ± 2.8% | 1.763 | 8.755 | 15.396 | 11.354 | 35.510 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1213.1 ± 0.7% | 1238.9 ± 0.5% | 1106.5 ± 1.2% | 262.9 ± 1.8% | 479.8 ± 0.4% | 228.0 ± 4.0% | 0.979 | 1.096 | 4.614 | 2.528 | 5.321 |
| hex: silesia/dickens | 524290 | 33927.2 ± 0.4% | 15064.6 ± 0.2% | 3558.1 ± 0.2% | 476.1 ± 0.4% | 8946.7 ± 0.6% | 1142.9 ± 3.7% | 2.252 | 9.535 | 71.267 | 3.792 | 29.684 |
| hex: silesia/mozilla | 524290 | 33915.8 ± 0.5% | 15067.3 ± 0.3% | 3481.9 ± 0.3% | 430.1 ± 0.5% | 8893.5 ± 1.4% | 1141.0 ± 0.8% | 2.251 | 9.741 | 78.852 | 3.814 | 29.723 |
| hex: silesia/mr | 524290 | 33952.4 ± 0.3% | 15057.9 ± 0.5% | 3485.3 ± 0.4% | 645.6 ± 0.6% | 8906.7 ± 5.3% | 1141.5 ± 1.3% | 2.255 | 9.742 | 52.587 | 3.812 | 29.745 |
| hex: silesia/nci | 524290 | 33872.4 ± 0.8% | 15052.0 ± 0.6% | 3565.8 ± 0.4% | 804.7 ± 25.4% | 8922.9 ± 8.1% | 1140.5 ± 0.8% | 2.250 | 9.499 | 42.094 | 3.796 | 29.699 |
| hex: silesia/ooffice | 524290 | 33874.6 ± 0.5% | 15043.5 ± 0.5% | 3490.1 ± 0.5% | 344.4 ± 2.3% | 8909.1 ± 0.8% | 1137.0 ± 0.5% | 2.252 | 9.706 | 98.360 | 3.802 | 29.793 |
| hex: silesia/osdb | 524290 | 33912.0 ± 0.6% | 15059.7 ± 0.4% | 3489.7 ± 0.2% | 456.7 ± 1.1% | 8918.5 ± 0.6% | 1135.6 ± 1.1% | 2.252 | 9.718 | 74.252 | 3.802 | 29.863 |
| hex: silesia/reymont | 524290 | 33972.0 ± 0.2% | 15058.9 ± 0.6% | 3518.9 ± 0.3% | 496.8 ± 0.6% | 8922.8 ± 5.4% | 1132.3 ± 1.8% | 2.256 | 9.654 | 68.380 | 3.807 | 30.002 |
| hex: silesia/samba | 524290 | 33959.8 ± 0.1% | 15061.0 ± 0.4% | 3496.0 ± 0.3% | 367.8 ± 0.5% | 8913.5 ± 0.2% | 1137.2 ± 1.6% | 2.255 | 9.714 | 92.331 | 3.810 | 29.862 |
| hex: silesia/sao | 524290 | 33919.3 ± 0.3% | 15062.8 ± 2.5% | 3490.2 ± 2.2% | 279.5 ± 0.7% | 8909.5 ± 0.3% | 1134.3 ± 0.9% | 2.252 | 9.719 | 121.373 | 3.807 | 29.902 |
| hex: silesia/webster | 524290 | 33963.6 ± 0.4% | 15078.4 ± 0.2% | 3563.5 ± 0.2% | 451.7 ± 0.7% | 8947.0 ± 0.4% | 1139.6 ± 4.2% | 2.252 | 9.531 | 75.184 | 3.796 | 29.804 |
| hex: silesia/x-ray | 524290 | 34002.5 ± 0.4% | 15079.9 ± 2.5% | 3493.0 ± 0.1% | 426.4 ± 0.3% | 8924.1 ± 0.2% | 1139.0 ± 0.4% | 2.255 | 9.734 | 79.747 | 3.810 | 29.854 |
| hex: silesia/xml | 524290 | 33867.4 ± 4.6% | 15078.0 ± 0.4% | 3557.7 ± 3.7% | 729.4 ± 0.7% | 8925.9 ± 0.4% | 1139.2 ± 0.3% | 2.246 | 9.520 | 46.430 | 3.794 | 29.729 |
| hex: canterbury/alice29.txt | 304180 | 33782.9 ± 0.7% | 14124.5 ± 0.2% | 3565.1 ± 0.2% | 482.4 ± 0.8% | 8934.9 ± 0.5% | 1148.0 ± 0.7% | 2.392 | 9.476 | 70.029 | 3.781 | 29.429 |
| hex: canterbury/asyoulik.txt | 250360 | 33873.3 ± 0.2% | 14912.1 ± 0.5% | 3495.1 ± 0.4% | 468.9 ± 0.4% | 8907.0 ± 0.4% | 1143.0 ± 1.2% | 2.272 | 9.692 | 72.238 | 3.803 | 29.634 |
| hex: canterbury/cp.html | 49208 | 33408.9 ± 0.2% | 14453.6 ± 2.1% | 3568.8 ± 1.2% | 510.4 ± 0.7% | 9263.9 ± 0.4% | 1129.3 ± 0.9% | 2.311 | 9.361 | 65.457 | 3.606 | 29.585 |
| hex: canterbury/fields.c | 22302 | 32936.5 ± 0.5% | 17629.4 ± 0.3% | 3666.6 ± 0.8% | 569.6 ± 1.4% | 9232.3 ± 0.3% | 1106.5 ± 1.3% | 1.868 | 8.983 | 57.823 | 3.568 | 29.767 |
| hex: canterbury/grammar.lsp | 7444 | 29895.8 ± 0.2% | 17271.1 ± 0.4% | 3623.8 ± 0.2% | 743.1 ± 0.9% | 8956.5 ± 0.4% | 1064.6 ± 1.8% | 1.731 | 8.250 | 40.229 | 3.338 | 28.083 |
| hex: canterbury/kennedy.xls | 524290 | 33943.9 ± 0.7% | 15018.9 ± 2.7% | 3562.2 ± 0.3% | 754.8 ± 0.9% | 8921.4 ± 0.2% | 1121.2 ± 4.9% | 2.260 | 9.529 | 44.968 | 3.805 | 30.275 |
| hex: canterbury/lcet10.txt | 524290 | 33895.2 ± 0.5% | 15048.5 ± 7.9% | 3540.4 ± 3.2% | 480.9 ± 6.8% | 8832.3 ± 4.3% | 1116.2 ± 1.7% | 2.252 | 9.574 | 70.476 | 3.838 | 30.366 |
| hex: canterbury/plrabn12.txt | 524290 | 33974.7 ± 2.3% | 15056.2 ± 1.0% | 3554.5 ± 0.9% | 466.2 ± 1.0% | 8923.2 ± 0.6% | 1118.5 ± 2.8% | 2.257 | 9.558 | 72.882 | 3.807 | 30.374 |
| hex: canterbury/ptt5 | 524290 | 33808.4 ± 0.8% | 14958.5 ± 0.8% | 3467.1 ± 1.7% | 659.9 ± 0.8% | 8846.1 ± 1.1% | 1120.2 ± 0.9% | 2.260 | 9.751 | 51.235 | 3.822 | 30.180 |
| hex: canterbury/sum | 76482 | 33326.3 ± 0.7% | 15407.7 ± 0.6% | 3558.9 ± 0.5% | 584.7 ± 0.9% | 8913.8 ± 0.7% | 1132.8 ± 0.6% | 2.163 | 9.364 | 56.999 | 3.739 | 29.420 |
| hex: canterbury/xargs.1 | 8456 | 30370.0 ± 0.4% | 17378.4 ± 0.5% | 3547.8 ± 0.6% | 721.6 ± 2.2% | 8942.2 ± 1.0% | 1096.1 ± 2.0% | 1.748 | 8.560 | 42.090 | 3.396 | 27.706 |
| hex: canterbury-large/E.coli | 524290 | 33877.5 ± 0.1% | 14071.1 ± 0.9% | 3484.8 ± 0.7% | 960.4 ± 0.8% | 8889.4 ± 0.4% | 1110.9 ± 2.1% | 2.408 | 9.722 | 35.275 | 3.811 | 30.495 |
| hex: canterbury-large/bible.txt | 524290 | 33862.1 ± 0.5% | 14094.0 ± 0.8% | 3487.7 ± 0.7% | 497.6 ± 1.3% | 8887.6 ± 2.4% | 1124.4 ± 3.2% | 2.403 | 9.709 | 68.048 | 3.810 | 30.116 |
| hex: canterbury-large/world192.txt | 524290 | 33882.2 ± 0.7% | 14931.9 ± 0.7% | 3567.3 ± 3.5% | 465.6 ± 0.8% | 8930.3 ± 1.1% | 1128.5 ± 5.2% | 2.269 | 9.498 | 72.771 | 3.794 | 30.025 |
| hex: http/html-1kx1024 | 2099200 | 15493.0 ± 4.3% | 12289.6 ± 7.1% | 3194.6 ± 1.2% | 505.5 ± 0.5% | 7401.1 ± 1.2% | 978.3 ± 1.2% | 1.261 | 4.850 | 30.650 | 2.093 | 15.837 |
| hex: http/html-16kx64 | 2097280 | 27533.1 ± 0.6% | 13985.9 ± 0.6% | 3404.8 ± 0.6% | 512.3 ± 0.6% | 8514.6 ± 1.6% | 1077.3 ± 3.7% | 1.969 | 8.087 | 53.742 | 3.234 | 25.558 |
| hex: http/html-1m | 524290 | 33868.1 ± 0.5% | 14071.8 ± 1.0% | 3490.1 ± 0.5% | 506.3 ± 0.8% | 8877.4 ± 0.9% | 1110.3 ± 3.3% | 2.407 | 9.704 | 66.891 | 3.815 | 30.504 |
| hex: http/json-1kx1024 | 2099200 | 15496.0 ± 0.4% | 11973.9 ± 1.1% | 3198.2 ± 0.8% | 669.1 ± 0.7% | 7426.5 ± 2.8% | 973.5 ± 2.6% | 1.294 | 4.845 | 23.159 | 2.087 | 15.918 |
| hex: http/json-16kx64 | 2097280 | 27167.1 ± 0.4% | 13907.3 ± 0.3% | 3403.9 ± 0.6% | 684.1 ± 0.5% | 7862.6 ± 4.5% | 1075.2 ± 1.3% | 1.953 | 7.981 | 39.712 | 3.455 | 25.266 |
| hex: http/json-1m | 524290 | 33744.4 ± 0.9% | 14968.9 ± 1.2% | 3545.0 ± 0.8% | 697.4 ± 0.8% | 8882.4 ± 0.7% | 1077.4 ± 3.1% | 2.254 | 9.519 | 48.387 | 3.799 | 31.321 |
| hex: http/js-1kx1024 | 2099200 | 15462.1 ± 1.0% | 12439.1 ± 8.5% | 3202.3 ± 0.9% | 487.7 ± 0.7% | 7404.6 ± 2.3% | 959.0 ± 1.6% | 1.243 | 4.828 | 31.705 | 2.088 | 16.123 |
| hex: http/js-16kx64 | 2097280 | 27519.0 ± 0.4% | 13964.5 ± 0.4% | 3407.8 ± 0.6% | 494.5 ± 1.0% | 8431.8 ± 0.6% | 1081.0 ± 3.5% | 1.971 | 8.075 | 55.647 | 3.264 | 25.456 |
| hex: http/js-1m | 524290 | 33874.7 ± 0.7% | 15038.9 ± 0.5% | 3539.8 ± 0.2% | 512.9 ± 0.5% | 8912.4 ± 0.3% | 1093.2 ± 4.7% | 2.252 | 9.570 | 66.048 | 3.801 | 30.987 |
| hex: http/css-1kx1024 | 2099200 | 15343.8 ± 0.5% | 11967.2 ± 0.7% | 3206.8 ± 0.2% | 567.0 ± 0.8% | 7422.1 ± 1.3% | 970.4 ± 1.0% | 1.282 | 4.785 | 27.061 | 2.067 | 15.812 |
| hex: http/css-16kx64 | 2097280 | 27688.5 ± 0.2% | 13970.8 ± 0.9% | 3413.9 ± 0.8% | 578.8 ± 0.8% | 8514.6 ± 0.2% | 1078.8 ± 1.2% | 1.982 | 8.111 | 47.834 | 3.252 | 25.666 |
| hex: http/css-1m | 524290 | 33944.2 ± 0.6% | 15064.9 ± 0.6% | 3567.1 ± 1.2% | 561.3 ± 0.4% | 8935.6 ± 0.7% | 1127.2 ± 1.4% | 2.253 | 9.516 | 60.477 | 3.799 | 30.114 |
| hex: shuffled/dickens-1m | 524290 | 33924.9 ± 0.4% | 15084.3 ± 7.3% | 3496.2 ± 16.3% | 475.5 ± 2.8% | 8908.2 ± 1.0% | 1127.6 ± 2.9% | 2.249 | 9.703 | 71.349 | 3.808 | 30.087 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1279.6 ± 39.2% | 1524.8 ± 46.5% | 1112.0 ± 58.0% | 389.4 ± 3.5% | 673.2 ± 0.3% | 363.8 ± 1.8% | 0.839 | 1.151 | 3.286 | 1.901 | 3.518 |
| qlog records, JSON text sequence | 1467503 | 1148.7 ± 0.2% | 1241.6 ± 1.1% | 1127.6 ± 0.4% | 330.2 ± 0.9% | 754.8 ± 0.4% | 308.8 ± 0.9% | 0.925 | 1.019 | 3.479 | 1.522 | 3.720 |
| messages: 11 string members | 1025025 | 1028.7 ± 1.0% | 2033.8 ± 5.3% | 722.3 ± 1.5% | 336.8 ± 0.2% | 510.5 ± 0.3% | 292.5 ± 1.4% | 0.506 | 1.424 | 3.054 | 2.015 | 3.517 |
| messages: 50 nested objects | 1121600 | 1299.5 ± 0.3% | 1712.3 ± 4.4% | 1455.6 ± 0.4% | 432.6 ± 0.7% | 905.3 ± 0.4% | 419.8 ± 0.3% | 0.759 | 0.893 | 3.004 | 1.435 | 3.095 |
| messages: a tree of 341 objects | 612600 | 652.8 ± 0.3% | 848.9 ± 1.1% | 702.9 ± 1.9% | 182.8 ± 0.9% | 611.2 ± 0.6% | 208.7 ± 1.3% | 0.769 | 0.929 | 3.572 | 1.068 | 3.128 |
| string: silesia/dickens | 172528 | 6718.2 ± 0.3% | 3440.0 ± 1.2% | 2829.7 ± 1.5% | 316.9 ± 0.2% | 3090.7 ± 0.3% | 572.8 ± 2.3% | 1.953 | 2.374 | 21.199 | 2.174 | 11.729 |
| string: silesia/nci | 1075110 | 5476.7 ± 0.4% | 3915.4 ± 1.4% | 3050.3 ± 1.1% | 649.5 ± 0.8% | 3646.7 ± 3.9% | 553.2 ± 5.5% | 1.399 | 1.795 | 8.432 | 1.502 | 9.900 |
| string: silesia/reymont | 1075159 | 3491.7 ± 1.0% | 3419.4 ± 0.3% | 1941.7 ± 1.8% | 342.5 ± 0.5% | 2110.5 ± 0.3% | 492.2 ± 3.3% | 1.021 | 1.798 | 10.195 | 1.654 | 7.094 |
| string: silesia/samba | 97582 | 3995.2 ± 5.3% | 3794.3 ± 2.1% | 3051.5 ± 0.8% | 328.0 ± 3.6% | 1964.0 ± 1.8% | 419.6 ± 2.7% | 1.053 | 1.309 | 12.182 | 2.034 | 9.521 |
| string: silesia/webster | 1098490 | 4426.9 ± 0.7% | 2448.4 ± 0.4% | 1738.6 ± 1.8% | 309.3 ± 10.5% | 2069.7 ± 3.7% | 451.1 ± 1.9% | 1.808 | 2.546 | 14.315 | 2.139 | 9.813 |
| string: silesia/xml | 1090118 | 6136.6 ± 12.5% | 5082.6 ± 9.4% | 2451.9 ± 4.5% | 507.2 ± 1.1% | 3329.3 ± 2.4% | 528.7 ± 4.7% | 1.207 | 2.503 | 12.099 | 1.843 | 11.608 |
| string: canterbury/alice29.txt | 159425 | 5846.4 ± 0.9% | 2787.4 ± 0.9% | 2808.5 ± 3.4% | 299.5 ± 5.1% | 2755.9 ± 11.4% | 514.0 ± 3.3% | 2.097 | 2.082 | 19.522 | 2.121 | 11.374 |
| string: canterbury/asyoulik.txt | 132198 | 4342.4 ± 0.3% | 2585.6 ± 2.6% | 2783.2 ± 1.1% | 305.0 ± 0.5% | 2406.4 ± 1.5% | 450.9 ± 3.6% | 1.679 | 1.560 | 14.238 | 1.805 | 9.631 |
| string: canterbury/lcet10.txt | 441884 | 6673.3 ± 0.3% | 3274.8 ± 0.7% | 2310.0 ± 2.6% | 345.3 ± 0.4% | 2788.3 ± 0.6% | 564.1 ± 2.6% | 2.038 | 2.889 | 19.327 | 2.393 | 11.829 |
| string: canterbury/plrabn12.txt | 503330 | 5481.8 ± 0.1% | 3148.0 ± 0.8% | 1842.2 ± 0.7% | 322.7 ± 0.3% | 2837.8 ± 0.5% | 533.4 ± 0.9% | 1.741 | 2.976 | 16.986 | 1.932 | 10.277 |
| string: canterbury-large/E.coli | 1048578 | 34058.9 ± 0.2% | 12968.6 ± 0.6% | 3408.3 ± 0.3% | 1283.5 ± 0.2% | 8920.8 ± 0.8% | 939.3 ± 4.2% | 2.626 | 9.993 | 26.537 | 3.818 | 36.260 |
| string: canterbury-large/bible.txt | 1055886 | 8733.3 ± 1.2% | 5267.4 ± 0.5% | 2795.4 ± 3.0% | 356.6 ± 0.4% | 3903.3 ± 0.4% | 627.0 ± 2.5% | 1.658 | 3.124 | 24.487 | 2.237 | 13.930 |
| string: canterbury-large/world192.txt | 1103121 | 4177.3 ± 1.7% | 2314.8 ± 0.2% | 1762.4 ± 0.6% | 326.8 ± 0.8% | 2112.3 ± 0.4% | 469.1 ± 2.0% | 1.805 | 2.370 | 12.784 | 1.978 | 8.905 |
| string: http/html-1m | 1058582 | 9556.1 ± 1.6% | 4737.5 ± 1.5% | 2680.8 ± 0.5% | 425.6 ± 0.4% | 3652.7 ± 1.2% | 598.3 ± 0.9% | 2.017 | 3.565 | 22.453 | 2.616 | 15.971 |
| string: http/json-1m | 1190272 | 3373.9 ± 1.5% | 1257.2 ± 0.6% | 2097.9 ± 0.5% | 475.8 ± 1.0% | 1338.6 ± 0.7% | 436.7 ± 1.2% | 2.684 | 1.608 | 7.091 | 2.520 | 7.726 |
| string: http/js-1m | 1144362 | 2855.7 ± 0.3% | 1611.5 ± 0.2% | 1325.9 ± 0.2% | 325.7 ± 0.3% | 1426.1 ± 0.2% | 380.6 ± 0.8% | 1.772 | 2.154 | 8.767 | 2.003 | 7.504 |
| string: http/css-1m | 1097820 | 3330.9 ± 3.1% | 2892.4 ± 0.4% | 2280.5 ± 0.7% | 452.5 ± 0.6% | 2074.1 ± 0.3% | 438.7 ± 1.4% | 1.152 | 1.461 | 7.361 | 1.606 | 7.592 |
| string: dickens as Cyrillic and CJK | 1883069 | 5863.0 ± 0.6% | 3299.2 ± 7.1% | 664.3 ± 0.4% | 377.8 ± 0.5% | 512.2 ± 0.3% | 163.8 ± 2.8% | 1.777 | 8.826 | 15.521 | 11.446 | 35.798 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1215.9 ± 0.3% | 1238.9 ± 0.5% | 1106.5 ± 1.2% | 262.9 ± 1.8% | 479.8 ± 0.4% | 228.0 ± 4.0% | 0.981 | 1.099 | 4.625 | 2.534 | 5.333 |
| hex: silesia/dickens | 524290 | 33961.0 ± 0.3% | 15064.6 ± 0.2% | 3558.1 ± 0.2% | 476.1 ± 0.4% | 8946.7 ± 0.6% | 1142.9 ± 3.7% | 2.254 | 9.545 | 71.338 | 3.796 | 29.714 |
| hex: silesia/mozilla | 524290 | 33898.8 ± 0.7% | 15067.3 ± 0.3% | 3481.9 ± 0.3% | 430.1 ± 0.5% | 8893.5 ± 1.4% | 1141.0 ± 0.8% | 2.250 | 9.736 | 78.813 | 3.812 | 29.708 |
| hex: silesia/mr | 524290 | 33930.8 ± 0.6% | 15057.9 ± 0.5% | 3485.3 ± 0.4% | 645.6 ± 0.6% | 8906.7 ± 5.3% | 1141.5 ± 1.3% | 2.253 | 9.735 | 52.554 | 3.810 | 29.726 |
| hex: silesia/nci | 524290 | 33902.2 ± 0.4% | 15052.0 ± 0.6% | 3565.8 ± 0.4% | 804.7 ± 25.4% | 8922.9 ± 8.1% | 1140.5 ± 0.8% | 2.252 | 9.507 | 42.132 | 3.799 | 29.725 |
| hex: silesia/ooffice | 524290 | 33935.0 ± 0.2% | 15043.5 ± 0.5% | 3490.1 ± 0.5% | 344.4 ± 2.3% | 8909.1 ± 0.8% | 1137.0 ± 0.5% | 2.256 | 9.723 | 98.536 | 3.809 | 29.846 |
| hex: silesia/osdb | 524290 | 33945.1 ± 0.6% | 15059.7 ± 0.4% | 3489.7 ± 0.2% | 456.7 ± 1.1% | 8918.5 ± 0.6% | 1135.6 ± 1.1% | 2.254 | 9.727 | 74.324 | 3.806 | 29.892 |
| hex: silesia/reymont | 524290 | 33971.2 ± 0.3% | 15058.9 ± 0.6% | 3518.9 ± 0.3% | 496.8 ± 0.6% | 8922.8 ± 5.4% | 1132.3 ± 1.8% | 2.256 | 9.654 | 68.379 | 3.807 | 30.001 |
| hex: silesia/samba | 524290 | 33939.2 ± 0.2% | 15061.0 ± 0.4% | 3496.0 ± 0.3% | 367.8 ± 0.5% | 8913.5 ± 0.2% | 1137.2 ± 1.6% | 2.253 | 9.708 | 92.276 | 3.808 | 29.844 |
| hex: silesia/sao | 524290 | 33879.1 ± 0.4% | 15062.8 ± 2.5% | 3490.2 ± 2.2% | 279.5 ± 0.7% | 8909.5 ± 0.3% | 1134.3 ± 0.9% | 2.249 | 9.707 | 121.229 | 3.803 | 29.867 |
| hex: silesia/webster | 524290 | 33968.9 ± 0.4% | 15078.4 ± 0.2% | 3563.5 ± 0.2% | 451.7 ± 0.7% | 8947.0 ± 0.4% | 1139.6 ± 4.2% | 2.253 | 9.532 | 75.196 | 3.797 | 29.808 |
| hex: silesia/x-ray | 524290 | 33974.4 ± 0.3% | 15079.9 ± 2.5% | 3493.0 ± 0.1% | 426.4 ± 0.3% | 8924.1 ± 0.2% | 1139.0 ± 0.4% | 2.253 | 9.726 | 79.681 | 3.807 | 29.829 |
| hex: silesia/xml | 524290 | 33922.5 ± 0.3% | 15078.0 ± 0.4% | 3557.7 ± 3.7% | 729.4 ± 0.7% | 8925.9 ± 0.4% | 1139.2 ± 0.3% | 2.250 | 9.535 | 46.506 | 3.800 | 29.778 |
| hex: canterbury/alice29.txt | 304180 | 33790.9 ± 0.4% | 14124.5 ± 0.2% | 3565.1 ± 0.2% | 482.4 ± 0.8% | 8934.9 ± 0.5% | 1148.0 ± 0.7% | 2.392 | 9.478 | 70.046 | 3.782 | 29.436 |
| hex: canterbury/asyoulik.txt | 250360 | 33906.3 ± 0.3% | 14912.1 ± 0.5% | 3495.1 ± 0.4% | 468.9 ± 0.4% | 8907.0 ± 0.4% | 1143.0 ± 1.2% | 2.274 | 9.701 | 72.309 | 3.807 | 29.663 |
| hex: canterbury/cp.html | 49208 | 33409.7 ± 0.1% | 14453.6 ± 2.1% | 3568.8 ± 1.2% | 510.4 ± 0.7% | 9263.9 ± 0.4% | 1129.3 ± 0.9% | 2.312 | 9.362 | 65.458 | 3.606 | 29.586 |
| hex: canterbury/fields.c | 22302 | 33039.3 ± 0.3% | 17629.4 ± 0.3% | 3666.6 ± 0.8% | 569.6 ± 1.4% | 9232.3 ± 0.3% | 1106.5 ± 1.3% | 1.874 | 9.011 | 58.004 | 3.579 | 29.860 |
| hex: canterbury/grammar.lsp | 7444 | 29839.2 ± 0.3% | 17271.1 ± 0.4% | 3623.8 ± 0.2% | 743.1 ± 0.9% | 8956.5 ± 0.4% | 1064.6 ± 1.8% | 1.728 | 8.234 | 40.153 | 3.332 | 28.030 |
| hex: canterbury/kennedy.xls | 524290 | 33938.8 ± 0.2% | 15018.9 ± 2.7% | 3562.2 ± 0.3% | 754.8 ± 0.9% | 8921.4 ± 0.2% | 1121.2 ± 4.9% | 2.260 | 9.527 | 44.962 | 3.804 | 30.270 |
| hex: canterbury/lcet10.txt | 524290 | 33941.5 ± 0.4% | 15048.5 ± 7.9% | 3540.4 ± 3.2% | 480.9 ± 6.8% | 8832.3 ± 4.3% | 1116.2 ± 1.7% | 2.255 | 9.587 | 70.572 | 3.843 | 30.408 |
| hex: canterbury/plrabn12.txt | 524290 | 33921.3 ± 2.3% | 15056.2 ± 1.0% | 3554.5 ± 0.9% | 466.2 ± 1.0% | 8923.2 ± 0.6% | 1118.5 ± 2.8% | 2.253 | 9.543 | 72.767 | 3.801 | 30.327 |
| hex: canterbury/ptt5 | 524290 | 33762.0 ± 0.7% | 14958.5 ± 0.8% | 3467.1 ± 1.7% | 659.9 ± 0.8% | 8846.1 ± 1.1% | 1120.2 ± 0.9% | 2.257 | 9.738 | 51.165 | 3.817 | 30.139 |
| hex: canterbury/sum | 76482 | 33225.9 ± 0.7% | 15407.7 ± 0.6% | 3558.9 ± 0.5% | 584.7 ± 0.9% | 8913.8 ± 0.7% | 1132.8 ± 0.6% | 2.156 | 9.336 | 56.827 | 3.727 | 29.331 |
| hex: canterbury/xargs.1 | 8456 | 30253.2 ± 0.5% | 17378.4 ± 0.5% | 3547.8 ± 0.6% | 721.6 ± 2.2% | 8942.2 ± 1.0% | 1096.1 ± 2.0% | 1.741 | 8.527 | 41.928 | 3.383 | 27.600 |
| hex: canterbury-large/E.coli | 524290 | 33821.8 ± 0.7% | 14071.1 ± 0.9% | 3484.8 ± 0.7% | 960.4 ± 0.8% | 8889.4 ± 0.4% | 1110.9 ± 2.1% | 2.404 | 9.706 | 35.217 | 3.805 | 30.445 |
| hex: canterbury-large/bible.txt | 524290 | 33818.0 ± 2.1% | 14094.0 ± 0.8% | 3487.7 ± 0.7% | 497.6 ± 1.3% | 8887.6 ± 2.4% | 1124.4 ± 3.2% | 2.399 | 9.696 | 67.959 | 3.805 | 30.077 |
| hex: canterbury-large/world192.txt | 524290 | 33923.7 ± 5.5% | 14931.9 ± 0.7% | 3567.3 ± 3.5% | 465.6 ± 0.8% | 8930.3 ± 1.1% | 1128.5 ± 5.2% | 2.272 | 9.510 | 72.860 | 3.799 | 30.062 |
| hex: http/html-1kx1024 | 2099200 | 15111.7 ± 0.3% | 12289.6 ± 7.1% | 3194.6 ± 1.2% | 505.5 ± 0.5% | 7401.1 ± 1.2% | 978.3 ± 1.2% | 1.230 | 4.730 | 29.895 | 2.042 | 15.447 |
| hex: http/html-16kx64 | 2097280 | 27556.4 ± 0.4% | 13985.9 ± 0.6% | 3404.8 ± 0.6% | 512.3 ± 0.6% | 8514.6 ± 1.6% | 1077.3 ± 3.7% | 1.970 | 8.094 | 53.787 | 3.236 | 25.580 |
| hex: http/html-1m | 524290 | 33898.0 ± 0.5% | 14071.8 ± 1.0% | 3490.1 ± 0.5% | 506.3 ± 0.8% | 8877.4 ± 0.9% | 1110.3 ± 3.3% | 2.409 | 9.713 | 66.950 | 3.818 | 30.531 |
| hex: http/json-1kx1024 | 2099200 | 15071.1 ± 0.3% | 11973.9 ± 1.1% | 3198.2 ± 0.8% | 669.1 ± 0.7% | 7426.5 ± 2.8% | 973.5 ± 2.6% | 1.259 | 4.712 | 22.524 | 2.029 | 15.481 |
| hex: http/json-16kx64 | 2097280 | 27166.4 ± 0.2% | 13907.3 ± 0.3% | 3403.9 ± 0.6% | 684.1 ± 0.5% | 7862.6 ± 4.5% | 1075.2 ± 1.3% | 1.953 | 7.981 | 39.711 | 3.455 | 25.266 |
| hex: http/json-1m | 524290 | 33700.5 ± 1.1% | 14968.9 ± 1.2% | 3545.0 ± 0.8% | 697.4 ± 0.8% | 8882.4 ± 0.7% | 1077.4 ± 3.1% | 2.251 | 9.506 | 48.324 | 3.794 | 31.281 |
| hex: http/js-1kx1024 | 2099200 | 15068.2 ± 0.6% | 12439.1 ± 8.5% | 3202.3 ± 0.9% | 487.7 ± 0.7% | 7404.6 ± 2.3% | 959.0 ± 1.6% | 1.211 | 4.705 | 30.897 | 2.035 | 15.712 |
| hex: http/js-16kx64 | 2097280 | 27561.2 ± 0.5% | 13964.5 ± 0.4% | 3407.8 ± 0.6% | 494.5 ± 1.0% | 8431.8 ± 0.6% | 1081.0 ± 3.5% | 1.974 | 8.088 | 55.732 | 3.269 | 25.495 |
| hex: http/js-1m | 524290 | 33909.1 ± 0.4% | 15038.9 ± 0.5% | 3539.8 ± 0.2% | 512.9 ± 0.5% | 8912.4 ± 0.3% | 1093.2 ± 4.7% | 2.255 | 9.579 | 66.115 | 3.805 | 31.018 |
| hex: http/css-1kx1024 | 2099200 | 14996.3 ± 0.5% | 11967.2 ± 0.7% | 3206.8 ± 0.2% | 567.0 ± 0.8% | 7422.1 ± 1.3% | 970.4 ± 1.0% | 1.253 | 4.676 | 26.448 | 2.020 | 15.454 |
| hex: http/css-16kx64 | 2097280 | 27674.6 ± 0.1% | 13970.8 ± 0.9% | 3413.9 ± 0.8% | 578.8 ± 0.8% | 8514.6 ± 0.2% | 1078.8 ± 1.2% | 1.981 | 8.107 | 47.810 | 3.250 | 25.653 |
| hex: http/css-1m | 524290 | 33873.4 ± 1.0% | 15064.9 ± 0.6% | 3567.1 ± 1.2% | 561.3 ± 0.4% | 8935.6 ± 0.7% | 1127.2 ± 1.4% | 2.248 | 9.496 | 60.350 | 3.791 | 30.051 |
| hex: shuffled/dickens-1m | 524290 | 33936.6 ± 0.5% | 15084.3 ± 7.3% | 3496.2 ± 16.3% | 475.5 ± 2.8% | 8908.2 ± 1.0% | 1127.6 ± 2.9% | 2.250 | 9.707 | 71.374 | 3.810 | 30.097 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1583.9 ± 0.5% | 1476.6 ± 3.5% | 1029.3 ± 2.2% | 461.0 ± 8.3% | 434.8 ± 2.3% | 501.8 ± 0.6% | 1.073 | 1.539 | 3.436 | 3.643 | 3.156 |
| qlog records, JSON text sequence | 1467503 | 1444.5 ± 0.8% | 1217.0 ± 1.7% | 946.9 ± 2.6% | 427.6 ± 0.8% | 536.7 ± 0.7% | 353.2 ± 1.1% | 1.187 | 1.525 | 3.378 | 2.691 | 4.090 |
| messages: 11 string members | 1025025 | 1265.0 ± 0.4% | 1108.2 ± 1.4% | 775.3 ± 0.2% | 412.0 ± 0.4% | 420.5 ± 0.8% | 436.4 ± 4.9% | 1.142 | 1.632 | 3.070 | 3.009 | 2.899 |
| messages: 50 nested objects | 1121600 | 1716.1 ± 4.9% | 1892.1 ± 0.1% | 1359.8 ± 2.2% | 596.5 ± 3.0% | 611.9 ± 0.8% | 507.3 ± 3.1% | 0.907 | 1.262 | 2.877 | 2.805 | 3.383 |
| messages: a tree of 341 objects | 612600 | 498.8 ± 0.3% | 682.9 ± 1.0% | 580.6 ± 0.4% | 336.2 ± 0.8% | 355.2 ± 0.6% | 221.6 ± 5.3% | 0.730 | 0.859 | 1.483 | 1.404 | 2.250 |
| string: silesia/dickens | 172528 | 13041.7 ± 0.8% | 3947.8 ± 2.0% | 3055.8 ± 3.2% | 333.0 ± 0.7% | 1534.2 ± 1.3% | 1183.0 ± 0.6% | 3.304 | 4.268 | 39.166 | 8.501 | 11.024 |
| string: silesia/nci | 1075110 | 11336.8 ± 0.1% | 4733.9 ± 0.7% | 3131.2 ± 0.1% | 913.1 ± 0.5% | 1590.3 ± 1.6% | 1189.7 ± 5.2% | 2.395 | 3.621 | 12.416 | 7.129 | 9.529 |
| string: silesia/reymont | 1075159 | 5402.6 ± 0.9% | 1868.7 ± 0.7% | 1891.0 ± 0.3% | 377.6 ± 0.7% | 1301.7 ± 1.2% | 1042.1 ± 1.3% | 2.891 | 2.857 | 14.309 | 4.150 | 5.184 |
| string: silesia/samba | 97582 | 6322.4 ± 0.2% | 2707.3 ± 0.3% | 4059.6 ± 0.7% | 349.5 ± 0.8% | 1269.0 ± 0.7% | 1175.7 ± 1.0% | 2.335 | 1.557 | 18.091 | 4.982 | 5.378 |
| string: silesia/webster | 1098490 | 7138.9 ± 3.8% | 1993.4 ± 0.5% | 1764.4 ± 0.7% | 352.8 ± 1.1% | 1266.4 ± 0.8% | 610.7 ± 0.4% | 3.581 | 4.046 | 20.236 | 5.637 | 11.690 |
| string: silesia/xml | 1090118 | 11006.7 ± 0.9% | 3217.0 ± 0.4% | 2525.7 ± 0.5% | 607.5 ± 0.6% | 1727.1 ± 1.6% | 979.1 ± 0.6% | 3.421 | 4.358 | 18.117 | 6.373 | 11.242 |
| string: canterbury/alice29.txt | 159425 | 12785.3 ± 0.7% | 2899.4 ± 1.2% | 3052.4 ± 1.3% | 318.0 ± 0.9% | 1373.5 ± 2.4% | 1092.0 ± 2.5% | 4.410 | 4.189 | 40.209 | 9.309 | 11.708 |
| string: canterbury/asyoulik.txt | 132198 | 11198.5 ± 0.9% | 2098.4 ± 1.9% | 3119.6 ± 1.2% | 316.2 ± 1.0% | 1238.9 ± 1.3% | 952.3 ± 0.5% | 5.337 | 3.590 | 35.414 | 9.039 | 11.759 |
| string: canterbury/lcet10.txt | 441884 | 12913.3 ± 1.3% | 3066.8 ± 0.8% | 2577.0 ± 1.1% | 369.2 ± 0.4% | 1467.1 ± 2.1% | 1195.8 ± 1.0% | 4.211 | 5.011 | 34.981 | 8.802 | 10.799 |
| string: canterbury/plrabn12.txt | 503330 | 9039.9 ± 1.6% | 2319.4 ± 0.5% | 2098.9 ± 1.7% | 347.6 ± 1.0% | 1389.6 ± 0.8% | 1123.7 ± 0.9% | 3.898 | 4.307 | 26.003 | 6.505 | 8.045 |
| string: canterbury-large/E.coli | 1048578 | 31720.0 ± 0.8% | 15962.6 ± 1.2% | 3485.7 ± 0.7% | 1692.7 ± 0.4% | 3086.5 ± 2.2% | 1417.5 ± 0.5% | 1.987 | 9.100 | 18.739 | 10.277 | 22.377 |
| string: canterbury-large/bible.txt | 1055886 | 9753.7 ± 0.4% | 4926.3 ± 0.3% | 3015.9 ± 0.2% | 407.3 ± 1.1% | 2026.7 ± 0.5% | 1491.4 ± 4.8% | 1.980 | 3.234 | 23.946 | 4.813 | 6.540 |
| string: canterbury-large/world192.txt | 1103121 | 6724.2 ± 0.4% | 1740.5 ± 3.0% | 1893.6 ± 0.6% | 348.7 ± 0.8% | 1278.8 ± 0.9% | 966.6 ± 4.5% | 3.863 | 3.551 | 19.282 | 5.258 | 6.957 |
| string: http/html-1m | 1058582 | 10264.9 ± 0.4% | 4343.4 ± 1.4% | 2879.3 ± 1.1% | 421.5 ± 2.8% | 2013.5 ± 0.9% | 853.4 ± 0.5% | 2.363 | 3.565 | 24.353 | 5.098 | 12.028 |
| string: http/json-1m | 1190272 | 8108.5 ± 5.1% | 1588.3 ± 0.8% | 1577.2 ± 0.8% | 555.2 ± 0.5% | 1020.6 ± 0.7% | 838.5 ± 1.2% | 5.105 | 5.141 | 14.604 | 7.945 | 9.670 |
| string: http/js-1m | 1144362 | 6581.8 ± 1.5% | 1122.8 ± 0.7% | 1380.9 ± 0.9% | 330.2 ± 0.5% | 1029.4 ± 1.5% | 755.6 ± 1.0% | 5.862 | 4.766 | 19.935 | 6.394 | 8.711 |
| string: http/css-1m | 1097820 | 9363.6 ± 1.0% | 1480.1 ± 0.9% | 2290.6 ± 1.0% | 507.6 ± 0.9% | 1131.9 ± 1.3% | 876.3 ± 1.1% | 6.326 | 4.088 | 18.446 | 8.272 | 10.685 |
| string: dickens as Cyrillic and CJK | 1883069 | 5521.8 ± 0.5% | 3654.3 ± 0.4% | 490.0 ± 0.3% | 246.6 ± 2.5% | 455.1 ± 0.5% | 357.8 ± 0.3% | 1.511 | 11.270 | 22.393 | 12.133 | 15.432 |
| hex: silesia/dickens | 524290 | 42497.1 ± 1.0% | 2600.9 ± 0.4% | 1509.0 ± 0.2% | 460.4 ± 3.9% | 1508.4 ± 0.9% | 1072.1 ± 0.2% | 16.340 | 28.163 | 92.303 | 28.174 | 39.641 |
| hex: silesia/mozilla | 524290 | 43607.4 ± 0.7% | 2591.9 ± 0.6% | 1503.8 ± 1.3% | 386.5 ± 3.0% | 1533.0 ± 0.7% | 1071.1 ± 0.4% | 16.824 | 28.998 | 112.823 | 28.445 | 40.711 |
| hex: silesia/mr | 524290 | 43471.3 ± 1.0% | 2569.8 ± 0.5% | 1500.6 ± 0.8% | 594.4 ± 0.6% | 1552.6 ± 0.7% | 1061.7 ± 1.4% | 16.916 | 28.969 | 73.139 | 27.998 | 40.945 |
| hex: silesia/nci | 524290 | 43252.8 ± 1.2% | 2555.6 ± 9.4% | 1491.5 ± 0.9% | 751.7 ± 0.7% | 1556.6 ± 0.4% | 1063.1 ± 0.7% | 16.925 | 29.000 | 57.538 | 27.787 | 40.687 |
| hex: silesia/ooffice | 524290 | 43510.0 ± 1.7% | 2571.1 ± 0.6% | 1499.6 ± 0.5% | 322.4 ± 1.4% | 1558.8 ± 1.0% | 1057.1 ± 0.3% | 16.923 | 29.014 | 134.950 | 27.913 | 41.158 |
| hex: silesia/osdb | 524290 | 41930.3 ± 2.4% | 2593.7 ± 0.4% | 1506.9 ± 0.4% | 428.0 ± 0.5% | 1548.3 ± 1.0% | 1065.2 ± 0.4% | 16.166 | 27.825 | 97.976 | 27.082 | 39.365 |
| hex: silesia/reymont | 524290 | 43645.5 ± 0.9% | 2587.0 ± 0.4% | 1507.5 ± 0.4% | 482.5 ± 0.2% | 1531.3 ± 0.9% | 1068.6 ± 0.3% | 16.871 | 28.952 | 90.449 | 28.502 | 40.844 |
| hex: silesia/samba | 524290 | 43431.3 ± 1.5% | 2589.9 ± 0.8% | 1499.5 ± 0.7% | 332.7 ± 1.4% | 1529.5 ± 1.1% | 1062.9 ± 0.4% | 16.769 | 28.965 | 130.549 | 28.396 | 40.861 |
| hex: silesia/sao | 524290 | 43748.5 ± 0.6% | 2592.9 ± 0.7% | 1507.6 ± 0.5% | 270.2 ± 2.5% | 1529.9 ± 0.9% | 1066.0 ± 0.5% | 16.873 | 29.018 | 161.913 | 28.595 | 41.042 |
| hex: silesia/webster | 524290 | 43523.9 ± 1.8% | 2582.1 ± 1.5% | 1497.1 ± 0.9% | 435.1 ± 1.0% | 1554.4 ± 1.2% | 1063.1 ± 1.2% | 16.856 | 29.072 | 100.023 | 28.000 | 40.942 |
| hex: silesia/x-ray | 524290 | 43287.1 ± 2.2% | 2576.0 ± 0.7% | 1503.3 ± 0.5% | 419.7 ± 0.7% | 1524.1 ± 1.1% | 1064.4 ± 0.4% | 16.804 | 28.795 | 103.129 | 28.401 | 40.669 |
| hex: silesia/xml | 524290 | 43628.4 ± 2.2% | 2591.3 ± 1.0% | 1506.2 ± 0.4% | 685.7 ± 1.0% | 1538.8 ± 0.8% | 1068.3 ± 0.8% | 16.836 | 28.965 | 63.628 | 28.352 | 40.838 |
| hex: canterbury/alice29.txt | 304180 | 41480.1 ± 3.0% | 2606.9 ± 0.9% | 1519.1 ± 0.7% | 468.8 ± 0.3% | 1544.7 ± 0.7% | 1081.7 ± 0.3% | 15.911 | 27.306 | 88.489 | 26.854 | 38.347 |
| hex: canterbury/asyoulik.txt | 250360 | 43206.4 ± 1.2% | 2612.9 ± 0.6% | 1536.3 ± 0.5% | 456.8 ± 1.1% | 1554.1 ± 1.0% | 1079.3 ± 0.7% | 16.536 | 28.124 | 94.577 | 27.801 | 40.033 |
| hex: canterbury/cp.html | 49208 | 42451.3 ± 1.2% | 2590.0 ± 0.7% | 1521.7 ± 0.8% | 478.5 ± 5.5% | 1582.6 ± 0.9% | 1090.2 ± 0.7% | 16.390 | 27.897 | 88.714 | 26.824 | 38.937 |
| hex: canterbury/fields.c | 22302 | 42372.9 ± 0.4% | 2646.2 ± 0.9% | 1529.2 ± 0.5% | 600.0 ± 5.0% | 1603.5 ± 0.3% | 1098.4 ± 0.8% | 16.013 | 27.708 | 70.619 | 26.425 | 38.575 |
| hex: canterbury/grammar.lsp | 7444 | 40225.0 ± 1.0% | 2665.7 ± 11.6% | 1533.3 ± 6.4% | 809.0 ± 0.4% | 1599.1 ± 0.3% | 1102.7 ± 0.8% | 15.090 | 26.234 | 49.724 | 25.155 | 36.479 |
| hex: canterbury/kennedy.xls | 524290 | 43055.5 ± 1.8% | 2562.7 ± 0.7% | 1501.2 ± 0.5% | 773.7 ± 0.7% | 1494.2 ± 6.3% | 1063.8 ± 0.7% | 16.801 | 28.680 | 55.652 | 28.816 | 40.475 |
| hex: canterbury/lcet10.txt | 524290 | 43192.3 ± 2.8% | 2577.7 ± 0.9% | 1501.9 ± 1.2% | 464.6 ± 1.0% | 1501.0 ± 1.0% | 1058.8 ± 1.1% | 16.756 | 28.758 | 92.973 | 28.775 | 40.794 |
| hex: canterbury/plrabn12.txt | 524290 | 42729.6 ± 0.5% | 2574.3 ± 1.6% | 1501.8 ± 1.7% | 448.6 ± 5.6% | 1506.3 ± 6.5% | 1063.5 ± 1.3% | 16.599 | 28.452 | 95.242 | 28.368 | 40.178 |
| hex: canterbury/ptt5 | 524290 | 42718.7 ± 0.2% | 2561.6 ± 0.9% | 1506.7 ± 1.2% | 592.3 ± 2.1% | 1565.5 ± 1.8% | 1065.8 ± 6.4% | 16.677 | 28.352 | 72.122 | 27.287 | 40.080 |
| hex: canterbury/sum | 76482 | 42125.4 ± 1.4% | 2568.6 ± 0.5% | 1506.4 ± 1.1% | 556.2 ± 1.0% | 1563.1 ± 1.1% | 1080.9 ± 1.5% | 16.400 | 27.964 | 75.733 | 26.949 | 38.972 |
| hex: canterbury/xargs.1 | 8456 | 39157.6 ± 1.7% | 2686.5 ± 0.7% | 1547.1 ± 0.4% | 843.2 ± 0.5% | 1613.3 ± 0.7% | 1106.6 ± 0.9% | 14.576 | 25.310 | 46.439 | 24.271 | 35.385 |
| hex: canterbury-large/E.coli | 524290 | 41172.3 ± 1.8% | 2571.3 ± 0.8% | 1502.1 ± 1.4% | 803.3 ± 1.2% | 1490.5 ± 1.7% | 1065.3 ± 0.9% | 16.012 | 27.409 | 51.251 | 27.624 | 38.649 |
| hex: canterbury-large/bible.txt | 524290 | 42420.9 ± 0.2% | 2574.9 ± 1.0% | 1508.6 ± 0.8% | 481.0 ± 0.7% | 1561.5 ± 1.5% | 1065.3 ± 1.3% | 16.475 | 28.120 | 88.184 | 27.167 | 39.821 |
| hex: canterbury-large/world192.txt | 524290 | 42455.4 ± 2.0% | 2566.2 ± 0.8% | 1501.4 ± 0.8% | 454.4 ± 0.4% | 1499.8 ± 6.2% | 1062.6 ± 0.4% | 16.544 | 28.276 | 93.436 | 28.307 | 39.953 |
| hex: http/html-1kx1024 | 2099200 | 20401.5 ± 0.2% | 2358.5 ± 1.6% | 1456.7 ± 1.2% | 499.0 ± 0.8% | 1491.1 ± 1.1% | 1078.3 ± 1.2% | 8.650 | 14.005 | 40.883 | 13.682 | 18.921 |
| hex: http/html-16kx64 | 2097280 | 21668.1 ± 0.4% | 2217.8 ± 1.3% | 1443.0 ± 1.1% | 503.1 ± 0.9% | 1444.6 ± 1.0% | 1080.0 ± 5.6% | 9.770 | 15.016 | 43.071 | 14.999 | 20.063 |
| hex: http/html-1m | 524290 | 42977.5 ± 1.7% | 2589.1 ± 0.7% | 1507.6 ± 1.0% | 485.1 ± 1.6% | 1508.7 ± 1.5% | 1063.9 ± 1.1% | 16.599 | 28.508 | 88.603 | 28.486 | 40.398 |
| hex: http/json-1kx1024 | 2099200 | 20362.8 ± 0.3% | 2340.3 ± 1.5% | 1456.7 ± 1.3% | 696.5 ± 0.7% | 1506.2 ± 1.4% | 1078.1 ± 1.3% | 8.701 | 13.978 | 29.235 | 13.520 | 18.888 |
| hex: http/json-16kx64 | 2097280 | 21292.3 ± 3.2% | 2226.1 ± 1.1% | 1443.6 ± 1.2% | 701.0 ± 4.0% | 1439.8 ± 1.2% | 1082.0 ± 1.2% | 9.565 | 14.750 | 30.375 | 14.788 | 19.678 |
| hex: http/json-1m | 524290 | 42777.8 ± 0.9% | 2573.9 ± 0.3% | 1496.5 ± 0.7% | 718.7 ± 4.2% | 1492.6 ± 1.7% | 1060.1 ± 6.0% | 16.620 | 28.586 | 59.523 | 28.660 | 40.353 |
| hex: http/js-1kx1024 | 2099200 | 20247.2 ± 0.4% | 2334.1 ± 0.7% | 1442.7 ± 1.1% | 486.3 ± 1.0% | 1485.2 ± 0.4% | 1061.7 ± 7.4% | 8.675 | 14.034 | 41.633 | 13.633 | 19.071 |
| hex: http/js-16kx64 | 2097280 | 22158.6 ± 0.2% | 2213.9 ± 1.4% | 1439.7 ± 1.2% | 489.2 ± 1.2% | 1446.9 ± 1.2% | 1076.3 ± 6.6% | 10.009 | 15.391 | 45.295 | 15.315 | 20.588 |
| hex: http/js-1m | 524290 | 43176.4 ± 0.8% | 2567.4 ± 0.5% | 1497.6 ± 0.5% | 503.6 ± 0.9% | 1557.9 ± 0.7% | 1062.8 ± 0.5% | 16.817 | 28.830 | 85.737 | 27.715 | 40.625 |
| hex: http/css-1kx1024 | 2099200 | 20642.8 ± 0.1% | 2340.1 ± 0.6% | 1447.4 ± 0.9% | 552.6 ± 0.6% | 1496.6 ± 1.1% | 1066.9 ± 0.5% | 8.821 | 14.262 | 37.354 | 13.793 | 19.348 |
| hex: http/css-16kx64 | 2097280 | 22192.2 ± 0.4% | 2209.8 ± 0.9% | 1438.4 ± 1.0% | 560.8 ± 1.0% | 1438.7 ± 0.7% | 1077.9 ± 0.4% | 10.043 | 15.429 | 39.569 | 15.426 | 20.589 |
| hex: http/css-1m | 524290 | 43122.1 ± 1.8% | 2577.3 ± 0.8% | 1499.6 ± 0.3% | 530.5 ± 0.4% | 1499.3 ± 1.6% | 1062.0 ± 0.7% | 16.731 | 28.755 | 81.284 | 28.761 | 40.603 |
| hex: shuffled/dickens-1m | 524290 | 41933.7 ± 4.7% | 2572.0 ± 5.8% | 1492.2 ± 6.9% | 459.7 ± 2.6% | 1560.2 ± 1.3% | 1062.5 ± 1.3% | 16.304 | 28.102 | 91.213 | 26.878 | 39.467 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: stdx runs at 0.889 of simdjson.
- messages: 11 string members, decoding: stdx runs at 0.531 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.784 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.922 of yyjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.789 of simdjson.
- messages: a tree of 341 objects, encoding: stdx runs at 0.875 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.808 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.889 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.469 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.724 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.852 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.645 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.779 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.896 of serde_json.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.925 of simdjson.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.506 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.759 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.893 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.769 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.929 of yyjson.
- messages: 50 nested objects, encoding through TextWriter's methods: stdx runs at 0.907 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.730 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.859 of yyjson.
