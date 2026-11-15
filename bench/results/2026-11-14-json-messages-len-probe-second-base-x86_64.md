# bench-json

| Field | Value |
|---|---|
| Commit | 7696e57 |
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
| CLDR supplemental, 34 texts | 920675 | 1369.7 ± 1.0% | 0.490 | 1.022 | 1.068 | 1.068 | 0.411 | 1.070 | 1.070 | 0.371 | 0.836 | 0.931 | 0.106 |
| qlog records, JSON text sequence | 1467503 | 1085.2 ± 1.0% | 0.795 | 1.073 | 1.080 | 1.084 | 0.386 | 1.065 | 1.080 | 0.368 | 0.932 | 1.042 | 0.127 |
| messages: 11 string members | 1025025 | 1061.5 ± 0.4% | 0.580 | 1.008 | 1.022 | 1.023 | 0.543 | 1.018 | 1.029 | 0.545 | 0.888 | 0.960 | 0.138 |
| messages: 50 nested objects | 1121600 | 1333.7 ± 0.6% | 0.804 | 1.090 | 1.087 | 1.092 | 0.396 | 1.100 | 1.091 | 0.351 | 0.920 | 0.975 | 0.114 |
| string: silesia/dickens | 172528 | 6687.8 ± 0.5% | 0.029 | 0.706 | 1.082 | 1.088 | 0.209 | 1.041 | 1.105 | 0.208 | 0.998 | 0.998 | 0.029 |
| string: silesia/nci | 1075110 | 5354.2 ± 1.6% | 0.035 | 0.717 | 1.045 | 1.039 | 0.305 | 1.042 | 1.039 | 0.307 | 1.013 | 1.014 | 0.036 |
| string: silesia/reymont | 1075159 | 3511.2 ± 1.0% | 0.054 | 0.625 | 0.864 | 0.863 | 0.352 | 0.815 | 0.873 | 0.354 | 0.981 | 0.989 | 0.054 |
| string: silesia/samba | 97582 | 3957.1 ± 0.2% | 0.041 | 0.907 | 1.062 | 1.065 | 0.075 | 0.858 | 1.065 | 0.075 | 1.007 | 1.008 | 0.041 |
| string: silesia/webster | 1098490 | 4400.4 ± 0.8% | 0.042 | 0.650 | 0.980 | 0.991 | 0.223 | 0.926 | 0.997 | 0.222 | 1.004 | 1.009 | 0.042 |
| string: silesia/xml | 1090118 | 6026.9 ± 1.7% | 0.032 | 0.784 | 0.951 | 0.982 | 0.250 | 0.966 | 0.985 | 0.249 | 1.007 | 1.010 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5752.6 ± 0.3% | 0.033 | 0.757 | 1.080 | 1.121 | 0.187 | 1.021 | 1.164 | 0.187 | 0.995 | 1.002 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 4291.9 ± 1.1% | 0.042 | 0.811 | 1.125 | 1.141 | 0.202 | 1.049 | 1.138 | 0.201 | 0.995 | 1.003 | 0.042 |
| string: canterbury/lcet10.txt | 441884 | 6683.6 ± 0.2% | 0.029 | 0.603 | 1.100 | 1.106 | 0.198 | 1.035 | 1.110 | 0.199 | 0.999 | 1.004 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 5463.0 ± 0.3% | 0.034 | 0.774 | 0.970 | 0.977 | 0.229 | 0.865 | 0.979 | 0.229 | 1.000 | 1.000 | 0.034 |
| string: canterbury-large/E.coli | 1048578 | 30294.4 ± 0.2% | 0.059 | 1.006 | 0.803 | 1.003 | 0.527 | 1.005 | 1.003 | 0.528 | 1.115 | 1.117 | 0.007 |
| string: canterbury-large/bible.txt | 1055886 | 8469.0 ± 1.9% | 0.024 | 0.624 | 0.882 | 0.875 | 0.407 | 0.887 | 0.895 | 0.408 | 1.002 | 1.010 | 0.024 |
| string: canterbury-large/world192.txt | 1103121 | 4137.5 ± 1.0% | 0.045 | 0.693 | 0.974 | 0.980 | 0.214 | 0.929 | 0.992 | 0.214 | 0.995 | 1.002 | 0.045 |
| string: http/html-1m | 1058582 | 8993.7 ± 4.4% | 0.022 | 0.571 | 0.788 | 0.803 | 0.319 | 0.761 | 0.812 | 0.319 | 0.982 | 1.070 | 0.022 |
| string: http/json-1m | 1190272 | 3314.1 ± 0.7% | 0.052 | 0.395 | 0.439 | 0.447 | 0.146 | 0.459 | 0.447 | 0.146 | 0.996 | 0.996 | 0.052 |
| string: http/js-1m | 1144362 | 2852.2 ± 0.3% | 0.061 | 0.701 | 0.883 | 0.923 | 0.191 | 0.852 | 0.925 | 0.191 | 1.007 | 1.009 | 0.061 |
| string: http/css-1m | 1097820 | 3296.7 ± 0.7% | 0.055 | 0.778 | 0.924 | 1.026 | 0.283 | 0.976 | 1.027 | 0.284 | 1.005 | 1.007 | 0.055 |
| string: dickens as Cyrillic and CJK | 1883069 | 5823.5 ± 0.6% | 0.025 | 0.058 | 0.450 | 0.451 | 0.197 | 0.452 | 0.453 | 0.197 | 0.999 | 1.002 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1193.1 ± 1.5% | 0.112 | 1.005 | 1.007 | 1.004 | 0.107 | 0.715 | 1.003 | 0.107 | 1.014 | 1.017 | 0.113 |
| hex: silesia/dickens | 524290 | 45701.9 ± 0.6% | 0.040 | 1.001 | 0.628 | 0.999 | 0.395 | 0.998 | 0.998 | 0.397 | 0.742 | 0.742 | 0.005 |
| hex: silesia/mozilla | 524290 | 45850.9 ± 1.2% | 0.039 | 0.996 | 0.614 | 0.997 | 0.370 | 0.999 | 1.000 | 0.370 | 0.736 | 0.736 | 0.005 |
| hex: silesia/mr | 524290 | 44853.2 ± 1.1% | 0.041 | 1.001 | 0.620 | 0.999 | 0.396 | 0.997 | 1.001 | 0.396 | 0.755 | 0.755 | 0.005 |
| hex: silesia/nci | 524290 | 45399.7 ± 1.4% | 0.040 | 0.999 | 0.625 | 1.000 | 0.396 | 0.998 | 0.999 | 0.396 | 0.743 | 0.745 | 0.005 |
| hex: silesia/ooffice | 524290 | 46363.8 ± 0.4% | 0.039 | 0.999 | 0.612 | 0.997 | 0.373 | 0.999 | 0.998 | 0.375 | 0.731 | 0.729 | 0.004 |
| hex: silesia/osdb | 524290 | 45749.1 ± 1.2% | 0.040 | 1.004 | 0.620 | 1.003 | 0.392 | 1.001 | 1.004 | 0.392 | 0.739 | 0.739 | 0.005 |
| hex: silesia/reymont | 524290 | 46311.7 ± 0.7% | 0.040 | 1.001 | 0.615 | 0.999 | 0.390 | 1.000 | 0.999 | 0.391 | 0.733 | 0.734 | 0.004 |
| hex: silesia/samba | 524290 | 45990.1 ± 0.5% | 0.040 | 1.000 | 0.604 | 0.994 | 0.388 | 0.997 | 0.998 | 0.389 | 0.736 | 0.736 | 0.004 |
| hex: silesia/sao | 524290 | 43643.0 ± 5.9% | 0.041 | 1.000 | 0.627 | 0.994 | 0.394 | 0.996 | 0.996 | 0.395 | 0.773 | 0.775 | 0.005 |
| hex: silesia/webster | 524290 | 45286.7 ± 2.5% | 0.040 | 1.005 | 0.632 | 1.000 | 0.397 | 1.004 | 1.002 | 0.395 | 0.744 | 0.747 | 0.005 |
| hex: silesia/x-ray | 524290 | 38859.6 ± 2.6% | 0.047 | 1.005 | 0.679 | 1.003 | 0.444 | 1.005 | 1.004 | 0.444 | 0.869 | 0.872 | 0.005 |
| hex: silesia/xml | 524290 | 46332.6 ± 1.8% | 0.039 | 1.007 | 0.611 | 1.005 | 0.389 | 1.007 | 1.004 | 0.388 | 0.728 | 0.728 | 0.004 |
| hex: canterbury/alice29.txt | 304180 | 46085.7 ± 1.1% | 0.040 | 0.998 | 0.616 | 0.998 | 0.389 | 0.998 | 0.995 | 0.390 | 0.731 | 0.729 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 45329.8 ± 0.6% | 0.040 | 0.998 | 0.628 | 1.000 | 0.397 | 0.999 | 0.999 | 0.396 | 0.743 | 0.744 | 0.005 |
| hex: canterbury/cp.html | 49208 | 44689.5 ± 0.7% | 0.041 | 1.001 | 0.621 | 1.001 | 0.392 | 1.001 | 0.999 | 0.395 | 0.744 | 0.743 | 0.005 |
| hex: canterbury/fields.c | 22302 | 51265.9 ± 1.3% | 0.036 | 1.007 | 0.536 | 1.011 | 0.385 | 1.005 | 1.013 | 0.393 | 0.640 | 0.639 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 43717.8 ± 2.1% | 0.042 | 1.004 | 0.577 | 1.010 | 0.411 | 1.000 | 1.010 | 0.431 | 0.678 | 0.679 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 45218.7 ± 0.9% | 0.040 | 1.002 | 0.614 | 1.002 | 0.396 | 1.000 | 0.999 | 0.396 | 0.744 | 0.747 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 48251.4 ± 1.9% | 0.038 | 0.999 | 0.577 | 0.998 | 0.371 | 0.995 | 0.992 | 0.371 | 0.697 | 0.700 | 0.004 |
| hex: canterbury/plrabn12.txt | 524290 | 45496.1 ± 2.3% | 0.040 | 0.999 | 0.617 | 0.995 | 0.394 | 0.999 | 0.998 | 0.394 | 0.745 | 0.743 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 45043.8 ± 2.1% | 0.041 | 0.996 | 0.634 | 0.994 | 0.399 | 0.999 | 0.990 | 0.398 | 0.751 | 0.753 | 0.005 |
| hex: canterbury/sum | 76482 | 45815.1 ± 1.0% | 0.040 | 0.997 | 0.613 | 1.003 | 0.385 | 0.999 | 1.003 | 0.387 | 0.722 | 0.722 | 0.005 |
| hex: canterbury/xargs.1 | 8456 | 45545.8 ± 1.8% | 0.041 | 1.009 | 0.565 | 1.007 | 0.405 | 1.006 | 1.007 | 0.423 | 0.665 | 0.663 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 46738.5 ± 0.8% | 0.039 | 1.000 | 0.598 | 1.006 | 0.383 | 1.006 | 1.005 | 0.383 | 0.720 | 0.720 | 0.004 |
| hex: canterbury-large/bible.txt | 524290 | 45628.8 ± 0.6% | 0.040 | 0.998 | 0.627 | 0.997 | 0.393 | 0.994 | 0.997 | 0.394 | 0.741 | 0.741 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 45634.1 ± 0.5% | 0.040 | 1.000 | 0.626 | 0.999 | 0.394 | 0.998 | 1.000 | 0.394 | 0.742 | 0.743 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 17653.5 ± 5.2% | 0.102 | 1.015 | 0.808 | 1.012 | 0.582 | 1.031 | 1.007 | 0.638 | 0.872 | 0.840 | 0.012 |
| hex: http/html-16kx64 | 2097280 | 34215.8 ± 3.0% | 0.053 | 1.005 | 0.683 | 1.003 | 0.468 | 1.006 | 1.001 | 0.471 | 0.816 | 0.811 | 0.006 |
| hex: http/html-1m | 524290 | 45911.3 ± 1.1% | 0.040 | 1.000 | 0.618 | 1.006 | 0.392 | 1.005 | 1.004 | 0.394 | 0.737 | 0.734 | 0.004 |
| hex: http/json-1kx1024 | 2099200 | 17565.7 ± 1.0% | 0.103 | 1.011 | 0.815 | 1.001 | 0.597 | 1.031 | 1.002 | 0.662 | 0.878 | 0.850 | 0.012 |
| hex: http/json-16kx64 | 2097280 | 34650.9 ± 1.0% | 0.053 | 1.003 | 0.690 | 1.003 | 0.469 | 1.003 | 1.003 | 0.474 | 0.801 | 0.801 | 0.006 |
| hex: http/json-1m | 524290 | 49050.3 ± 0.6% | 0.037 | 0.999 | 0.585 | 0.999 | 0.369 | 0.998 | 0.995 | 0.368 | 0.691 | 0.693 | 0.004 |
| hex: http/js-1kx1024 | 2099200 | 18143.5 ± 2.4% | 0.100 | 1.003 | 0.793 | 0.992 | 0.582 | 1.009 | 0.998 | 0.642 | 0.856 | 0.829 | 0.011 |
| hex: http/js-16kx64 | 2097280 | 34364.3 ± 1.4% | 0.053 | 0.998 | 0.688 | 1.004 | 0.468 | 1.003 | 1.003 | 0.473 | 0.799 | 0.799 | 0.006 |
| hex: http/js-1m | 524290 | 46958.0 ± 2.1% | 0.039 | 1.000 | 0.607 | 1.001 | 0.383 | 1.002 | 0.999 | 0.383 | 0.723 | 0.722 | 0.004 |
| hex: http/css-1kx1024 | 2099200 | 17847.1 ± 1.7% | 0.101 | 1.011 | 0.807 | 1.008 | 0.574 | 1.023 | 1.006 | 0.637 | 0.863 | 0.843 | 0.011 |
| hex: http/css-16kx64 | 2097280 | 34985.1 ± 0.6% | 0.052 | 0.999 | 0.682 | 1.003 | 0.467 | 1.005 | 1.004 | 0.470 | 0.791 | 0.789 | 0.006 |
| hex: http/css-1m | 524290 | 45487.5 ± 0.7% | 0.040 | 0.999 | 0.629 | 1.000 | 0.394 | 0.997 | 0.997 | 0.393 | 0.743 | 0.744 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 44680.2 ± 0.8% | 0.041 | 1.003 | 0.637 | 1.002 | 0.396 | 1.002 | 1.002 | 0.396 | 0.760 | 0.759 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1720.4 ± 4.8% | 0.436 | 1.022 | 1.022 | 1.043 | 1.045 | 0.283 | 1.049 | 0.528 | 0.924 | 0.093 | 1.041 |
| qlog records, JSON text sequence | 1467503 | 1673.4 ± 3.6% | 0.637 | 0.957 | 0.969 | 1.008 | 0.983 | 0.244 | 0.983 | 0.438 | 0.863 | 0.102 | 1.023 |
| messages: 11 string members | 1025025 | 1308.4 ± 0.7% | 0.523 | 0.991 | 1.001 | 1.008 | 0.997 | 0.391 | 1.000 | 0.692 | 0.973 | 0.121 | 1.005 |
| messages: 50 nested objects | 1121600 | 2000.1 ± 0.8% | 0.587 | 0.978 | 0.980 | 0.978 | 0.984 | 0.246 | 0.983 | 0.431 | 0.854 | 0.090 | 1.001 |
| string: silesia/dickens | 172528 | 12905.3 ± 0.9% | 0.018 | 0.540 | 0.363 | 0.528 | 0.557 | 0.121 | 0.556 | 1.000 | 1.006 | 0.017 | 1.043 |
| string: silesia/nci | 1075110 | 11253.7 ± 0.5% | 0.020 | 0.523 | 0.364 | 0.533 | 0.524 | 0.187 | 0.523 | 0.999 | 0.995 | 0.020 | 1.031 |
| string: silesia/reymont | 1075159 | 5369.9 ± 2.9% | 0.042 | 0.567 | 0.430 | 0.566 | 0.566 | 0.270 | 0.566 | 0.994 | 1.003 | 0.042 | 1.010 |
| string: silesia/samba | 97582 | 6356.0 ± 0.6% | 0.045 | 0.882 | 0.741 | 0.891 | 0.884 | 0.120 | 0.885 | 0.998 | 0.999 | 0.045 | 1.162 |
| string: silesia/webster | 1098490 | 7085.2 ± 0.3% | 0.032 | 0.574 | 0.396 | 0.549 | 0.576 | 0.157 | 0.572 | 0.991 | 1.007 | 0.031 | 0.983 |
| string: silesia/xml | 1090118 | 10671.5 ± 1.3% | 0.021 | 0.563 | 0.466 | 0.556 | 0.564 | 0.210 | 0.565 | 1.000 | 1.014 | 0.021 | 1.041 |
| string: canterbury/alice29.txt | 159425 | 12637.7 ± 0.6% | 0.018 | 0.426 | 0.358 | 0.422 | 0.458 | 0.094 | 0.466 | 1.001 | 1.008 | 0.018 | 1.048 |
| string: canterbury/asyoulik.txt | 132198 | 11038.4 ± 1.1% | 0.019 | 0.393 | 0.325 | 0.383 | 0.412 | 0.091 | 0.420 | 0.993 | 1.011 | 0.019 | 1.035 |
| string: canterbury/lcet10.txt | 441884 | 12302.1 ± 0.8% | 0.018 | 0.559 | 0.335 | 0.545 | 0.562 | 0.122 | 0.563 | 1.002 | 1.021 | 0.018 | 1.027 |
| string: canterbury/plrabn12.txt | 503330 | 8845.5 ± 6.8% | 0.025 | 0.619 | 0.494 | 0.619 | 0.620 | 0.161 | 0.618 | 0.990 | 1.018 | 0.025 | 1.004 |
| string: canterbury-large/E.coli | 1048578 | 31248.8 ± 1.0% | 0.057 | 1.004 | 1.003 | 0.782 | 1.004 | 0.503 | 1.003 | 1.004 | 1.004 | 0.008 | 1.003 |
| string: canterbury-large/bible.txt | 1055886 | 9630.8 ± 0.7% | 0.024 | 0.741 | 0.571 | 0.743 | 0.754 | 0.399 | 0.755 | 1.000 | 1.010 | 0.024 | 1.031 |
| string: canterbury-large/world192.txt | 1103121 | 6616.2 ± 1.0% | 0.034 | 0.591 | 0.423 | 0.562 | 0.593 | 0.155 | 0.595 | 0.990 | 1.006 | 0.033 | 0.974 |
| string: http/html-1m | 1058582 | 9998.5 ± 0.7% | 0.023 | 0.644 | 0.537 | 0.643 | 0.645 | 0.326 | 0.643 | 0.999 | 1.013 | 0.023 | 1.012 |
| string: http/json-1m | 1190272 | 8600.3 ± 0.6% | 0.024 | 0.179 | 0.157 | 0.179 | 0.180 | 0.071 | 0.180 | 1.001 | 1.002 | 0.024 | 1.021 |
| string: http/js-1m | 1144362 | 6485.2 ± 0.6% | 0.033 | 0.370 | 0.315 | 0.363 | 0.369 | 0.095 | 0.368 | 0.995 | 1.005 | 0.033 | 1.012 |
| string: http/css-1m | 1097820 | 9260.8 ± 0.9% | 0.023 | 0.347 | 0.284 | 0.342 | 0.348 | 0.125 | 0.346 | 1.001 | 1.007 | 0.023 | 1.029 |
| string: dickens as Cyrillic and CJK | 1883069 | 5455.1 ± 1.4% | 0.030 | 0.467 | 0.063 | 0.466 | 0.468 | 0.210 | 0.470 | 1.004 | 1.006 | 0.031 | 1.049 |
| hex: silesia/dickens | 524290 | 43418.2 ± 0.7% | 1.002 | 0.088 | 1.003 | 0.591 | 0.999 | 1.000 | 1.002 | 1.003 | 0.997 | 0.090 | 1.003 |
| hex: silesia/mozilla | 524290 | 43389.5 ± 1.7% | 1.003 | 0.088 | 0.989 | 0.579 | 0.997 | 1.000 | 1.001 | 0.971 | 0.999 | 0.090 | 1.003 |
| hex: silesia/mr | 524290 | 43470.5 ± 0.6% | 0.999 | 0.087 | 0.999 | 0.590 | 1.001 | 1.005 | 1.005 | 1.002 | 1.002 | 0.091 | 1.004 |
| hex: silesia/nci | 524290 | 42652.1 ± 0.9% | 1.006 | 0.088 | 1.006 | 0.600 | 1.004 | 1.006 | 1.003 | 1.007 | 1.006 | 0.093 | 1.006 |
| hex: silesia/ooffice | 524290 | 42754.2 ± 1.1% | 0.998 | 0.088 | 1.002 | 0.598 | 1.001 | 1.001 | 0.998 | 1.007 | 1.004 | 0.095 | 1.000 |
| hex: silesia/osdb | 524290 | 43534.8 ± 0.8% | 1.001 | 0.087 | 1.001 | 0.589 | 0.995 | 1.000 | 0.998 | 1.000 | 0.998 | 0.092 | 0.999 |
| hex: silesia/reymont | 524290 | 43457.2 ± 1.7% | 0.999 | 0.087 | 1.000 | 0.589 | 0.998 | 1.003 | 1.001 | 1.004 | 1.002 | 0.091 | 1.004 |
| hex: silesia/samba | 524290 | 42907.8 ± 1.4% | 1.005 | 0.088 | 1.007 | 0.596 | 0.996 | 0.999 | 1.001 | 1.008 | 1.005 | 0.091 | 1.006 |
| hex: silesia/sao | 524290 | 43256.5 ± 0.8% | 1.002 | 0.087 | 1.004 | 0.592 | 1.005 | 0.999 | 1.006 | 1.005 | 1.006 | 0.088 | 1.006 |
| hex: silesia/webster | 524290 | 43821.5 ± 0.6% | 1.001 | 0.086 | 0.999 | 0.585 | 0.998 | 0.998 | 0.998 | 1.001 | 0.998 | 0.089 | 0.996 |
| hex: silesia/x-ray | 524290 | 43015.8 ± 1.2% | 0.999 | 0.088 | 1.005 | 0.594 | 1.010 | 1.007 | 1.005 | 1.007 | 1.005 | 0.091 | 1.009 |
| hex: silesia/xml | 524290 | 42981.8 ± 2.1% | 1.005 | 0.088 | 0.990 | 0.596 | 0.996 | 0.989 | 0.995 | 0.996 | 0.993 | 0.090 | 0.996 |
| hex: canterbury/alice29.txt | 304180 | 42793.7 ± 1.2% | 1.001 | 0.089 | 1.003 | 0.596 | 1.005 | 1.010 | 1.002 | 1.001 | 1.002 | 0.091 | 1.007 |
| hex: canterbury/asyoulik.txt | 250360 | 42683.3 ± 2.1% | 1.000 | 0.089 | 0.997 | 0.597 | 0.998 | 0.995 | 0.997 | 0.999 | 1.003 | 0.094 | 1.002 |
| hex: canterbury/cp.html | 49208 | 42236.3 ± 5.8% | 1.004 | 0.090 | 1.001 | 0.595 | 1.006 | 0.997 | 1.004 | 1.005 | 1.000 | 0.097 | 1.001 |
| hex: canterbury/fields.c | 22302 | 41801.2 ± 0.6% | 1.003 | 0.091 | 1.003 | 0.597 | 1.005 | 0.986 | 0.997 | 1.003 | 1.007 | 0.098 | 0.998 |
| hex: canterbury/grammar.lsp | 7444 | 39540.4 ± 1.8% | 0.985 | 0.095 | 0.983 | 0.603 | 0.998 | 0.952 | 1.003 | 0.986 | 1.012 | 0.102 | 1.002 |
| hex: canterbury/kennedy.xls | 524290 | 43629.8 ± 1.1% | 1.001 | 0.087 | 1.002 | 0.590 | 1.001 | 1.000 | 0.998 | 1.001 | 1.000 | 0.090 | 1.003 |
| hex: canterbury/lcet10.txt | 524290 | 42874.6 ± 1.9% | 1.010 | 0.088 | 1.009 | 0.598 | 1.010 | 1.001 | 1.007 | 1.007 | 1.001 | 0.091 | 1.006 |
| hex: canterbury/plrabn12.txt | 524290 | 42415.4 ± 0.8% | 1.003 | 0.089 | 1.000 | 0.602 | 1.002 | 1.003 | 0.998 | 1.002 | 1.001 | 0.092 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 43303.0 ± 0.9% | 1.004 | 0.086 | 0.969 | 0.591 | 1.002 | 1.002 | 1.006 | 0.941 | 1.002 | 0.093 | 1.001 |
| hex: canterbury/sum | 76482 | 42823.4 ± 6.6% | 0.998 | 0.089 | 0.998 | 0.591 | 0.996 | 0.995 | 0.996 | 0.996 | 1.001 | 0.096 | 1.000 |
| hex: canterbury/xargs.1 | 8456 | 40150.0 ± 0.4% | 0.998 | 0.094 | 1.001 | 0.598 | 1.003 | 0.948 | 1.000 | 1.004 | 1.020 | 0.101 | 1.001 |
| hex: canterbury-large/E.coli | 524290 | 43635.8 ± 0.1% | 0.999 | 0.087 | 1.000 | 0.589 | 1.000 | 0.999 | 0.999 | 0.999 | 0.998 | 0.091 | 1.000 |
| hex: canterbury-large/bible.txt | 524290 | 43455.1 ± 0.7% | 1.001 | 0.087 | 1.002 | 0.591 | 1.001 | 0.998 | 1.003 | 1.003 | 1.003 | 0.088 | 1.003 |
| hex: canterbury-large/world192.txt | 524290 | 43615.2 ± 0.3% | 1.002 | 0.086 | 1.002 | 0.590 | 1.001 | 1.002 | 1.000 | 1.003 | 1.002 | 0.092 | 1.004 |
| hex: http/html-1kx1024 | 2099200 | 20587.8 ± 0.2% | 1.002 | 0.178 | 1.003 | 0.978 | 1.003 | 0.999 | 1.003 | 1.002 | 1.007 | 0.185 | 1.003 |
| hex: http/html-16kx64 | 2097280 | 21206.9 ± 0.5% | 1.004 | 0.179 | 1.004 | 0.993 | 1.004 | 1.005 | 1.004 | 1.004 | 1.005 | 0.194 | 1.005 |
| hex: http/html-1m | 524290 | 43554.7 ± 0.5% | 1.002 | 0.087 | 1.003 | 0.592 | 1.003 | 1.003 | 1.003 | 1.005 | 1.003 | 0.090 | 1.003 |
| hex: http/json-1kx1024 | 2099200 | 20595.5 ± 0.7% | 1.001 | 0.178 | 1.002 | 0.975 | 1.003 | 1.001 | 1.002 | 1.001 | 1.006 | 0.185 | 1.004 |
| hex: http/json-16kx64 | 2097280 | 21969.5 ± 2.1% | 1.004 | 0.173 | 1.004 | 0.978 | 1.003 | 1.004 | 1.003 | 1.004 | 1.004 | 0.187 | 1.005 |
| hex: http/json-1m | 524290 | 43235.3 ± 1.9% | 0.999 | 0.087 | 0.997 | 0.596 | 1.003 | 0.993 | 0.998 | 1.000 | 0.995 | 0.091 | 0.999 |
| hex: http/js-1kx1024 | 2099200 | 20202.9 ± 0.5% | 1.000 | 0.181 | 1.002 | 0.987 | 1.003 | 1.004 | 1.004 | 1.001 | 1.006 | 0.187 | 1.003 |
| hex: http/js-16kx64 | 2097280 | 21710.7 ± 0.1% | 1.002 | 0.174 | 1.003 | 0.972 | 1.000 | 1.003 | 1.004 | 1.003 | 1.004 | 0.189 | 1.003 |
| hex: http/js-1m | 524290 | 43144.6 ± 2.5% | 1.000 | 0.087 | 1.004 | 0.594 | 1.002 | 1.004 | 1.000 | 1.001 | 0.999 | 0.091 | 0.999 |
| hex: http/css-1kx1024 | 2099200 | 20325.6 ± 2.8% | 1.002 | 0.179 | 1.003 | 0.983 | 1.004 | 1.003 | 1.001 | 0.998 | 1.005 | 0.185 | 1.004 |
| hex: http/css-16kx64 | 2097280 | 21675.3 ± 0.3% | 1.004 | 0.174 | 1.005 | 0.984 | 1.004 | 1.004 | 1.004 | 1.003 | 1.004 | 0.189 | 1.004 |
| hex: http/css-1m | 524290 | 43166.4 ± 1.9% | 0.997 | 0.087 | 0.999 | 0.592 | 0.993 | 0.998 | 0.996 | 0.999 | 0.997 | 0.090 | 0.998 |
| hex: shuffled/dickens-1m | 524290 | 43344.9 ± 1.4% | 1.000 | 0.087 | 0.999 | 0.590 | 0.996 | 1.000 | 1.002 | 1.003 | 1.001 | 0.092 | 1.003 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.068 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.068 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.070 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.070 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.073 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.080 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.084 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.065 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.080 of all on.
- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.090 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.087 of all on.
- messages: 50 nested objects, decoding: J8 decoder fast path off runs at 1.092 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.100 of all on.
- messages: 50 nested objects, decoding: J13 decoder escape blocks off runs at 1.091 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.082 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.088 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.105 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.062 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.065 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.065 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.080 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.121 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.164 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.125 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.141 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.138 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.100 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.106 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.110 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 164132.8 ± 1.8% | 119642.1 ± 1.2% | 1.372 | 99277.7 ± 1.4% | 1.653 |
| string: silesia/nci | 1048576 | 166255.3 ± 1.4% | 120906.1 ± 0.9% | 1.375 | 100548.2 ± 0.8% | 1.653 |
| string: silesia/reymont | 1048576 | 142522.0 ± 0.9% | 112126.4 ± 1.1% | 1.271 | 94855.7 ± 1.0% | 1.503 |
| string: silesia/samba | 65546 | 158718.4 ± 1.5% | 118289.3 ± 1.8% | 1.342 | 97689.8 ± 0.9% | 1.625 |
| string: silesia/webster | 1048576 | 164071.8 ± 1.1% | 120511.5 ± 0.7% | 1.361 | 100585.8 ± 1.4% | 1.631 |
| string: silesia/xml | 1048576 | 161569.7 ± 1.8% | 119573.4 ± 1.7% | 1.351 | 99536.9 ± 0.4% | 1.623 |
| string: canterbury/alice29.txt | 152089 | 162430.8 ± 2.5% | 119505.9 ± 0.8% | 1.359 | 98503.0 ± 1.2% | 1.649 |
| string: canterbury/asyoulik.txt | 125179 | 163008.5 ± 2.4% | 118980.1 ± 0.9% | 1.370 | 99016.5 ± 1.0% | 1.646 |
| string: canterbury/lcet10.txt | 426754 | 166225.5 ± 2.4% | 120966.7 ± 1.7% | 1.374 | 100766.0 ± 1.4% | 1.650 |
| string: canterbury/plrabn12.txt | 481861 | 165707.9 ± 2.3% | 121297.1 ± 0.4% | 1.366 | 100400.3 ± 1.1% | 1.650 |
| string: canterbury-large/E.coli | 1048576 | 166367.8 ± 0.6% | 121366.6 ± 0.7% | 1.371 | 100263.4 ± 0.6% | 1.659 |
| string: canterbury-large/bible.txt | 1048576 | 167321.1 ± 1.1% | 121877.4 ± 0.7% | 1.373 | 101513.9 ± 0.6% | 1.648 |
| string: canterbury-large/world192.txt | 1048576 | 167221.4 ± 1.0% | 121743.8 ± 0.9% | 1.374 | 100473.0 ± 0.4% | 1.664 |
| string: http/html-1m | 1048576 | 146133.5 ± 1.7% | 110614.4 ± 1.1% | 1.321 | 92972.2 ± 1.6% | 1.572 |
| string: http/json-1m | 1048576 | 101779.5 ± 0.7% | 94850.5 ± 1.0% | 1.073 | 75418.9 ± 0.6% | 1.350 |
| string: http/js-1m | 1048576 | 163850.0 ± 2.5% | 121054.1 ± 1.0% | 1.354 | 98956.6 ± 1.5% | 1.656 |
| string: http/css-1m | 1048576 | 136391.2 ± 1.4% | 109247.8 ± 1.4% | 1.248 | 92223.4 ± 0.9% | 1.479 |
| string: dickens as Cyrillic and CJK | 1847045 | 23511.2 ± 0.6% | 20645.7 ± 0.6% | 1.139 | 14750.1 ± 0.9% | 1.594 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 167134.3 ± 1.0% | 121904.7 ± 1.2% | 1.371 | 101580.3 ± 0.4% | 1.645 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 167491.8 ± 0.4% | 121798.2 ± 0.2% | 1.375 | 100924.4 ± 1.2% | 1.660 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 166157.8 ± 1.4% | 121808.0 ± 1.3% | 1.364 | 101130.8 ± 0.6% | 1.643 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 166705.2 ± 1.4% | 121093.6 ± 1.2% | 1.377 | 100797.7 ± 1.1% | 1.654 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 165654.4 ± 2.1% | 120428.9 ± 0.8% | 1.376 | 100313.4 ± 1.0% | 1.651 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 165047.6 ± 1.6% | 119811.5 ± 1.0% | 1.378 | 100303.7 ± 0.9% | 1.645 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24115.7 ± 0.7% | 21519.0 ± 0.9% | 1.121 | 15197.0 ± 0.8% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24113.4 ± 0.4% | 21511.7 ± 0.4% | 1.121 | 15183.4 ± 0.5% | 1.588 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24116.7 ± 0.9% | 21551.5 ± 0.8% | 1.119 | 15185.3 ± 1.0% | 1.588 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24102.9 ± 0.6% | 21503.9 ± 2.7% | 1.121 | 15194.5 ± 0.2% | 1.586 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24120.6 ± 0.6% | 21570.6 ± 0.7% | 1.118 | 15218.2 ± 0.6% | 1.585 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24224.5 ± 0.6% | 21597.4 ± 1.3% | 1.122 | 15281.6 ± 0.5% | 1.585 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1369.7 ± 1.0% | 1496.1 ± 1.0% | 1106.8 ± 0.5% | 360.0 ± 2.0% | 665.4 ± 0.6% | 363.9 ± 11.7% | 0.916 | 1.238 | 3.804 | 2.058 | 3.764 |
| qlog records, JSON text sequence | 1467503 | 1085.2 ± 1.0% | 1216.2 ± 0.7% | 1117.6 ± 1.9% | 302.1 ± 2.5% | 753.8 ± 0.7% | 315.4 ± 0.6% | 0.892 | 0.971 | 3.592 | 1.440 | 3.441 |
| messages: 11 string members | 1025025 | 1061.5 ± 0.4% | 1984.7 ± 1.9% | 703.2 ± 3.1% | 313.9 ± 1.3% | 508.3 ± 0.6% | 302.1 ± 1.3% | 0.535 | 1.510 | 3.382 | 2.088 | 3.514 |
| messages: 50 nested objects | 1121600 | 1333.7 ± 0.6% | 1723.0 ± 1.4% | 1450.0 ± 0.7% | 375.6 ± 0.8% | 896.0 ± 0.3% | 418.7 ± 0.9% | 0.774 | 0.920 | 3.551 | 1.488 | 3.186 |
| string: silesia/dickens | 172528 | 6687.8 ± 0.5% | 3432.3 ± 4.0% | 2818.2 ± 1.4% | 303.2 ± 1.9% | 3015.1 ± 1.8% | 569.9 ± 2.8% | 1.948 | 2.373 | 22.054 | 2.218 | 11.735 |
| string: silesia/nci | 1075110 | 5354.2 ± 1.6% | 3880.1 ± 0.3% | 2993.3 ± 0.6% | 562.6 ± 1.5% | 3616.6 ± 0.8% | 553.6 ± 2.1% | 1.380 | 1.789 | 9.517 | 1.480 | 9.672 |
| string: silesia/reymont | 1075159 | 3511.2 ± 1.0% | 3375.7 ± 0.5% | 1954.3 ± 1.0% | 325.6 ± 1.4% | 2088.7 ± 0.7% | 476.3 ± 4.2% | 1.040 | 1.797 | 10.784 | 1.681 | 7.372 |
| string: silesia/samba | 97582 | 3957.1 ± 0.2% | 3760.5 ± 0.5% | 3093.7 ± 0.8% | 311.2 ± 1.0% | 1947.1 ± 1.9% | 419.1 ± 1.0% | 1.052 | 1.279 | 12.714 | 2.032 | 9.442 |
| string: silesia/webster | 1098490 | 4400.4 ± 0.8% | 2428.2 ± 0.5% | 1731.9 ± 2.5% | 305.2 ± 0.4% | 2058.9 ± 0.4% | 464.1 ± 2.7% | 1.812 | 2.541 | 14.419 | 2.137 | 9.482 |
| string: silesia/xml | 1090118 | 6026.9 ± 1.7% | 4974.9 ± 0.2% | 2448.3 ± 0.3% | 458.3 ± 0.6% | 3307.7 ± 0.2% | 539.8 ± 1.1% | 1.211 | 2.462 | 13.151 | 1.822 | 11.165 |
| string: canterbury/alice29.txt | 159425 | 5752.6 ± 0.3% | 2729.2 ± 0.6% | 2850.4 ± 1.3% | 288.6 ± 0.7% | 2722.9 ± 2.1% | 518.3 ± 0.9% | 2.108 | 2.018 | 19.930 | 2.113 | 11.099 |
| string: canterbury/asyoulik.txt | 132198 | 4291.9 ± 1.1% | 2625.7 ± 0.3% | 2760.6 ± 0.8% | 294.8 ± 1.1% | 2386.4 ± 1.0% | 454.5 ± 1.7% | 1.635 | 1.555 | 14.558 | 1.798 | 9.444 |
| string: canterbury/lcet10.txt | 441884 | 6683.6 ± 0.2% | 3285.8 ± 0.3% | 2301.4 ± 0.3% | 323.6 ± 1.5% | 2760.4 ± 0.5% | 570.5 ± 0.5% | 2.034 | 2.904 | 20.654 | 2.421 | 11.715 |
| string: canterbury/plrabn12.txt | 503330 | 5463.0 ± 0.3% | 3162.9 ± 1.2% | 1817.8 ± 0.9% | 301.1 ± 0.8% | 2803.6 ± 2.0% | 530.6 ± 0.9% | 1.727 | 3.005 | 18.142 | 1.949 | 10.295 |
| string: canterbury-large/E.coli | 1048578 | 30294.4 ± 0.2% | 13412.7 ± 1.3% | 3388.2 ± 0.8% | 1156.0 ± 6.0% | 8898.0 ± 0.8% | 931.0 ± 2.8% | 2.259 | 8.941 | 26.206 | 3.405 | 32.540 |
| string: canterbury-large/bible.txt | 1055886 | 8469.0 ± 1.9% | 5249.1 ± 1.2% | 2761.7 ± 0.7% | 332.2 ± 0.7% | 3865.8 ± 0.9% | 614.1 ± 3.6% | 1.613 | 3.067 | 25.495 | 2.191 | 13.791 |
| string: canterbury-large/world192.txt | 1103121 | 4137.5 ± 1.0% | 2293.4 ± 1.0% | 1772.5 ± 1.3% | 312.2 ± 1.1% | 2111.6 ± 1.2% | 462.5 ± 1.7% | 1.804 | 2.334 | 13.254 | 1.959 | 8.947 |
| string: http/html-1m | 1058582 | 8993.7 ± 4.4% | 4762.5 ± 1.9% | 2656.6 ± 0.8% | 385.4 ± 1.1% | 3630.7 ± 0.8% | 589.7 ± 7.2% | 1.888 | 3.385 | 23.336 | 2.477 | 15.252 |
| string: http/json-1m | 1190272 | 3314.1 ± 0.7% | 1246.7 ± 0.8% | 2085.1 ± 2.8% | 400.6 ± 4.6% | 1342.6 ± 0.6% | 438.0 ± 1.4% | 2.658 | 1.589 | 8.273 | 2.468 | 7.566 |
| string: http/js-1m | 1144362 | 2852.2 ± 0.3% | 1612.5 ± 0.1% | 1333.4 ± 0.3% | 304.1 ± 3.8% | 1420.7 ± 0.6% | 379.8 ± 1.6% | 1.769 | 2.139 | 9.378 | 2.008 | 7.510 |
| string: http/css-1m | 1097820 | 3296.7 ± 0.7% | 2892.6 ± 0.4% | 2274.0 ± 0.8% | 401.7 ± 1.7% | 2068.0 ± 0.5% | 439.3 ± 1.7% | 1.140 | 1.450 | 8.206 | 1.594 | 7.505 |
| string: dickens as Cyrillic and CJK | 1883069 | 5823.5 ± 0.6% | 3040.8 ± 2.8% | 659.9 ± 1.0% | 323.8 ± 0.6% | 512.1 ± 0.9% | 162.5 ± 5.7% | 1.915 | 8.825 | 17.983 | 11.372 | 35.832 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1193.1 ± 1.5% | 1243.7 ± 1.4% | 1100.3 ± 1.1% | 234.8 ± 0.9% | 476.0 ± 0.7% | 225.1 ± 4.7% | 0.959 | 1.084 | 5.081 | 2.507 | 5.300 |
| hex: silesia/dickens | 524290 | 45701.9 ± 0.6% | 15084.7 ± 0.5% | 3555.6 ± 0.3% | 452.0 ± 0.5% | 8910.5 ± 0.7% | 1139.3 ± 3.8% | 3.030 | 12.854 | 101.103 | 5.129 | 40.113 |
| hex: silesia/mozilla | 524290 | 45850.9 ± 1.2% | 14944.1 ± 2.6% | 3473.2 ± 0.8% | 415.1 ± 2.0% | 8862.1 ± 1.0% | 1135.7 ± 1.2% | 3.068 | 13.201 | 110.462 | 5.174 | 40.373 |
| hex: silesia/mr | 524290 | 44853.2 ± 1.1% | 15063.0 ± 1.3% | 3483.0 ± 0.4% | 621.1 ± 3.4% | 8882.8 ± 0.4% | 1139.6 ± 0.6% | 2.978 | 12.878 | 72.213 | 5.049 | 39.359 |
| hex: silesia/nci | 524290 | 45399.7 ± 1.4% | 15042.4 ± 0.8% | 3499.7 ± 3.1% | 712.6 ± 1.9% | 8916.0 ± 1.3% | 1137.2 ± 5.4% | 3.018 | 12.972 | 63.709 | 5.092 | 39.921 |
| hex: silesia/ooffice | 524290 | 46363.8 ± 0.4% | 15027.5 ± 0.6% | 3484.5 ± 0.5% | 332.2 ± 0.4% | 8907.6 ± 0.3% | 1139.9 ± 0.9% | 3.085 | 13.306 | 139.574 | 5.205 | 40.673 |
| hex: silesia/osdb | 524290 | 45749.1 ± 1.2% | 14996.6 ± 0.8% | 3481.5 ± 0.8% | 428.0 ± 0.4% | 8872.1 ± 0.9% | 1136.1 ± 0.2% | 3.051 | 13.141 | 106.890 | 5.157 | 40.270 |
| hex: silesia/reymont | 524290 | 46311.7 ± 0.7% | 15124.0 ± 0.4% | 3552.9 ± 0.2% | 459.4 ± 0.8% | 8941.0 ± 0.1% | 1144.5 ± 0.7% | 3.062 | 13.035 | 100.814 | 5.180 | 40.465 |
| hex: silesia/samba | 524290 | 45990.1 ± 0.5% | 15058.7 ± 0.6% | 3489.9 ± 0.6% | 344.7 ± 0.5% | 8862.5 ± 4.8% | 1138.4 ± 0.8% | 3.054 | 13.178 | 133.436 | 5.189 | 40.398 |
| hex: silesia/sao | 524290 | 43643.0 ± 5.9% | 14939.3 ± 4.1% | 3471.1 ± 0.6% | 274.3 ± 0.7% | 8831.6 ± 0.8% | 1131.5 ± 0.8% | 2.921 | 12.573 | 159.101 | 4.942 | 38.570 |
| hex: silesia/webster | 524290 | 45286.7 ± 2.5% | 14972.8 ± 1.2% | 3533.8 ± 1.2% | 416.3 ± 1.9% | 8865.1 ± 0.8% | 1132.7 ± 1.1% | 3.025 | 12.815 | 108.774 | 5.108 | 39.981 |
| hex: silesia/x-ray | 524290 | 38859.6 ± 2.6% | 15005.9 ± 1.0% | 3491.7 ± 3.5% | 409.6 ± 0.9% | 8844.6 ± 0.7% | 1130.2 ± 1.1% | 2.590 | 11.129 | 94.869 | 4.394 | 34.383 |
| hex: silesia/xml | 524290 | 46332.6 ± 1.8% | 14957.5 ± 3.2% | 3542.6 ± 1.0% | 526.1 ± 0.8% | 8851.5 ± 4.8% | 1129.8 ± 0.8% | 3.098 | 13.079 | 88.076 | 5.234 | 41.008 |
| hex: canterbury/alice29.txt | 304180 | 46085.7 ± 1.1% | 14115.1 ± 2.4% | 3546.5 ± 2.9% | 457.7 ± 0.9% | 8865.9 ± 0.4% | 1141.4 ± 0.8% | 3.265 | 12.995 | 100.690 | 5.198 | 40.378 |
| hex: canterbury/asyoulik.txt | 250360 | 45329.8 ± 0.6% | 14972.5 ± 0.7% | 3486.0 ± 0.5% | 443.7 ± 0.3% | 8838.6 ± 5.0% | 1143.6 ± 0.7% | 3.028 | 13.003 | 102.158 | 5.129 | 39.638 |
| hex: canterbury/cp.html | 49208 | 44689.5 ± 0.7% | 14378.1 ± 0.4% | 3549.1 ± 0.5% | 434.8 ± 0.6% | 9198.4 ± 4.0% | 1113.3 ± 1.1% | 3.108 | 12.592 | 102.781 | 4.858 | 40.141 |
| hex: canterbury/fields.c | 22302 | 51265.9 ± 1.3% | 17524.1 ± 1.0% | 3651.1 ± 0.6% | 473.8 ± 1.4% | 9177.0 ± 0.5% | 1099.1 ± 3.3% | 2.925 | 14.041 | 108.199 | 5.586 | 46.645 |
| hex: canterbury/grammar.lsp | 7444 | 43717.8 ± 2.1% | 17121.5 ± 0.9% | 3595.7 ± 1.1% | 584.4 ± 0.7% | 8895.8 ± 1.3% | 1055.9 ± 1.8% | 2.553 | 12.158 | 74.806 | 4.914 | 41.403 |
| hex: canterbury/kennedy.xls | 524290 | 45218.7 ± 0.9% | 14960.9 ± 0.7% | 3540.0 ± 0.8% | 692.9 ± 0.9% | 8877.5 ± 1.1% | 1115.5 ± 4.4% | 3.022 | 12.773 | 65.263 | 5.094 | 40.538 |
| hex: canterbury/lcet10.txt | 524290 | 48251.4 ± 1.9% | 14979.9 ± 0.8% | 3532.2 ± 3.0% | 457.9 ± 0.4% | 8848.4 ± 0.8% | 1124.5 ± 4.2% | 3.221 | 13.661 | 105.383 | 5.453 | 42.908 |
| hex: canterbury/plrabn12.txt | 524290 | 45496.1 ± 2.3% | 15075.8 ± 1.0% | 3544.5 ± 3.5% | 441.6 ± 0.8% | 8873.7 ± 0.7% | 1121.8 ± 3.6% | 3.018 | 12.836 | 103.014 | 5.127 | 40.555 |
| hex: canterbury/ptt5 | 524290 | 45043.8 ± 2.1% | 15054.4 ± 1.2% | 3484.1 ± 1.4% | 653.0 ± 1.0% | 8883.1 ± 0.9% | 1127.3 ± 5.1% | 2.992 | 12.928 | 68.979 | 5.071 | 39.958 |
| hex: canterbury/sum | 76482 | 45815.1 ± 1.0% | 15315.4 ± 0.5% | 3536.3 ± 0.4% | 531.1 ± 0.4% | 8802.1 ± 0.5% | 1122.2 ± 2.6% | 2.991 | 12.956 | 86.265 | 5.205 | 40.825 |
| hex: canterbury/xargs.1 | 8456 | 45545.8 ± 1.8% | 17375.2 ± 0.9% | 3567.3 ± 0.7% | 556.1 ± 1.5% | 8936.1 ± 0.6% | 1105.1 ± 1.4% | 2.621 | 12.768 | 81.895 | 5.097 | 41.213 |
| hex: canterbury-large/E.coli | 524290 | 46738.5 ± 0.8% | 14992.7 ± 0.8% | 3467.0 ± 0.6% | 956.6 ± 0.7% | 8875.7 ± 0.4% | 1108.8 ± 4.8% | 3.117 | 13.481 | 48.861 | 5.266 | 42.152 |
| hex: canterbury-large/bible.txt | 524290 | 45628.8 ± 0.6% | 14995.2 ± 0.5% | 3483.7 ± 0.9% | 471.4 ± 0.5% | 8867.5 ± 5.1% | 1130.5 ± 2.2% | 3.043 | 13.098 | 96.796 | 5.146 | 40.362 |
| hex: canterbury-large/world192.txt | 524290 | 45634.1 ± 0.5% | 15044.2 ± 0.8% | 3552.8 ± 0.8% | 438.8 ± 0.8% | 8905.7 ± 1.1% | 1135.1 ± 2.9% | 3.033 | 12.845 | 104.003 | 5.124 | 40.201 |
| hex: http/html-1kx1024 | 2099200 | 17653.5 ± 5.2% | 12257.0 ± 8.7% | 3177.6 ± 2.0% | 462.6 ± 0.2% | 7405.9 ± 1.2% | 971.8 ± 2.1% | 1.440 | 5.556 | 38.160 | 2.384 | 18.166 |
| hex: http/html-16kx64 | 2097280 | 34215.8 ± 3.0% | 14004.7 ± 3.7% | 3388.8 ± 1.4% | 458.1 ± 2.0% | 8521.1 ± 8.0% | 1067.9 ± 3.2% | 2.443 | 10.097 | 74.696 | 4.015 | 32.040 |
| hex: http/html-1m | 524290 | 45911.3 ± 1.1% | 15045.5 ± 0.6% | 3475.7 ± 3.8% | 445.9 ± 2.7% | 8876.7 ± 3.5% | 1114.3 ± 7.4% | 3.051 | 13.209 | 102.954 | 5.172 | 41.201 |
| hex: http/json-1kx1024 | 2099200 | 17565.7 ± 1.0% | 12366.8 ± 1.3% | 3180.9 ± 1.2% | 623.4 ± 0.8% | 7410.2 ± 0.8% | 971.2 ± 5.0% | 1.420 | 5.522 | 28.178 | 2.370 | 18.086 |
| hex: http/json-16kx64 | 2097280 | 34650.9 ± 1.0% | 13970.4 ± 2.4% | 3427.5 ± 3.2% | 628.8 ± 0.4% | 8635.9 ± 0.8% | 1087.9 ± 4.3% | 2.480 | 10.110 | 55.102 | 4.012 | 31.851 |
| hex: http/json-1m | 524290 | 49050.3 ± 0.6% | 15125.7 ± 1.1% | 3569.7 ± 0.2% | 600.1 ± 1.4% | 8925.9 ± 0.2% | 1121.3 ± 3.9% | 3.243 | 13.741 | 81.741 | 5.495 | 43.743 |
| hex: http/js-1kx1024 | 2099200 | 18143.5 ± 2.4% | 11854.8 ± 0.6% | 3194.9 ± 1.0% | 456.3 ± 0.8% | 7331.1 ± 4.5% | 975.0 ± 1.6% | 1.530 | 5.679 | 39.763 | 2.475 | 18.608 |
| hex: http/js-16kx64 | 2097280 | 34364.3 ± 1.4% | 13984.2 ± 2.6% | 3414.1 ± 0.3% | 458.6 ± 0.5% | 8188.6 ± 0.6% | 1088.2 ± 2.1% | 2.457 | 10.066 | 74.934 | 4.197 | 31.580 |
| hex: http/js-1m | 524290 | 46958.0 ± 2.1% | 15053.9 ± 0.8% | 3562.3 ± 0.8% | 451.7 ± 2.4% | 8915.8 ± 0.8% | 1131.6 ± 1.7% | 3.119 | 13.182 | 103.966 | 5.267 | 41.496 |
| hex: http/css-1kx1024 | 2099200 | 17847.1 ± 1.7% | 12063.7 ± 0.6% | 3174.0 ± 1.1% | 503.5 ± 1.5% | 7354.2 ± 3.7% | 970.1 ± 1.8% | 1.479 | 5.623 | 35.448 | 2.427 | 18.397 |
| hex: http/css-16kx64 | 2097280 | 34985.1 ± 0.6% | 13861.3 ± 2.5% | 3400.0 ± 3.4% | 506.9 ± 0.6% | 8525.9 ± 0.7% | 1082.7 ± 1.3% | 2.524 | 10.290 | 69.021 | 4.103 | 32.312 |
| hex: http/css-1m | 524290 | 45487.5 ± 0.7% | 15011.5 ± 1.2% | 3564.3 ± 1.0% | 454.4 ± 1.5% | 8876.6 ± 0.6% | 1108.1 ± 4.7% | 3.030 | 12.762 | 100.103 | 5.124 | 41.050 |
| hex: shuffled/dickens-1m | 524290 | 44680.2 ± 0.8% | 15139.8 ± 0.6% | 3492.8 ± 0.3% | 453.4 ± 0.3% | 8906.0 ± 0.3% | 1128.3 ± 1.3% | 2.951 | 12.792 | 98.536 | 5.017 | 39.599 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1720.4 ± 4.8% | 1488.6 ± 1.2% | 1032.3 ± 0.9% | 459.4 ± 0.2% | 470.7 ± 1.9% | 502.4 ± 1.1% | 1.156 | 1.667 | 3.745 | 3.655 | 3.424 |
| qlog records, JSON text sequence | 1467503 | 1673.4 ± 3.6% | 1244.3 ± 3.1% | 941.7 ± 4.4% | 423.2 ± 1.2% | 570.3 ± 2.5% | 348.1 ± 1.4% | 1.345 | 1.777 | 3.954 | 2.934 | 4.807 |
| messages: 11 string members | 1025025 | 1308.4 ± 0.7% | 1107.6 ± 1.6% | 771.4 ± 1.1% | 410.3 ± 2.7% | 442.3 ± 3.3% | 428.6 ± 4.1% | 1.181 | 1.696 | 3.189 | 2.958 | 3.052 |
| messages: 50 nested objects | 1121600 | 2000.1 ± 0.8% | 1880.6 ± 1.2% | 1347.7 ± 1.0% | 588.1 ± 0.9% | 653.6 ± 1.6% | 518.4 ± 5.1% | 1.064 | 1.484 | 3.401 | 3.060 | 3.858 |
| string: silesia/dickens | 172528 | 12905.3 ± 0.9% | 3946.3 ± 0.8% | 3061.0 ± 2.9% | 331.3 ± 0.5% | 1692.1 ± 0.8% | 1175.8 ± 0.7% | 3.270 | 4.216 | 38.951 | 7.627 | 10.976 |
| string: silesia/nci | 1075110 | 11253.7 ± 0.5% | 4671.0 ± 6.1% | 3106.0 ± 0.9% | 909.2 ± 0.7% | 1886.3 ± 1.3% | 1198.5 ± 0.2% | 2.409 | 3.623 | 12.378 | 5.966 | 9.390 |
| string: silesia/reymont | 1075159 | 5369.9 ± 2.9% | 1852.8 ± 2.1% | 1891.4 ± 0.5% | 379.3 ± 1.8% | 1436.5 ± 0.7% | 1040.7 ± 0.9% | 2.898 | 2.839 | 14.157 | 3.738 | 5.160 |
| string: silesia/samba | 97582 | 6356.0 ± 0.6% | 2710.0 ± 0.7% | 4070.3 ± 0.8% | 349.1 ± 0.6% | 1327.5 ± 1.6% | 1173.6 ± 0.3% | 2.345 | 1.562 | 18.205 | 4.788 | 5.416 |
| string: silesia/webster | 1098490 | 7085.2 ± 0.3% | 1979.1 ± 0.6% | 1776.8 ± 1.6% | 351.5 ± 0.7% | 1406.5 ± 1.1% | 603.3 ± 0.8% | 3.580 | 3.988 | 20.160 | 5.037 | 11.745 |
| string: silesia/xml | 1090118 | 10671.5 ± 1.3% | 3193.1 ± 0.8% | 2515.2 ± 0.6% | 603.5 ± 0.6% | 1930.8 ± 1.0% | 954.4 ± 0.8% | 3.342 | 4.243 | 17.682 | 5.527 | 11.181 |
| string: canterbury/alice29.txt | 159425 | 12637.7 ± 0.6% | 2891.5 ± 2.9% | 2998.2 ± 1.6% | 316.9 ± 1.1% | 1512.7 ± 5.4% | 1088.1 ± 0.7% | 4.371 | 4.215 | 39.885 | 8.354 | 11.615 |
| string: canterbury/asyoulik.txt | 132198 | 11038.4 ± 1.1% | 2093.9 ± 1.4% | 3081.6 ± 3.5% | 314.3 ± 1.5% | 1353.8 ± 1.2% | 958.1 ± 1.0% | 5.272 | 3.582 | 35.120 | 8.154 | 11.522 |
| string: canterbury/lcet10.txt | 441884 | 12302.1 ± 0.8% | 3090.8 ± 1.1% | 2540.7 ± 0.6% | 367.9 ± 1.2% | 1657.8 ± 1.4% | 1192.7 ± 4.1% | 3.980 | 4.842 | 33.435 | 7.421 | 10.315 |
| string: canterbury/plrabn12.txt | 503330 | 8845.5 ± 6.8% | 2301.4 ± 0.3% | 2084.3 ± 1.4% | 346.1 ± 1.3% | 1596.0 ± 0.9% | 1109.6 ± 1.4% | 3.844 | 4.244 | 25.554 | 5.542 | 7.972 |
| string: canterbury-large/E.coli | 1048578 | 31248.8 ± 1.0% | 16092.9 ± 1.7% | 3480.1 ± 0.9% | 1690.9 ± 0.5% | 3135.2 ± 0.4% | 1413.5 ± 0.6% | 1.942 | 8.979 | 18.480 | 9.967 | 22.107 |
| string: canterbury-large/bible.txt | 1055886 | 9630.8 ± 0.7% | 4886.0 ± 1.1% | 2997.3 ± 0.4% | 404.4 ± 1.7% | 2213.9 ± 0.8% | 1489.9 ± 0.7% | 1.971 | 3.213 | 23.815 | 4.350 | 6.464 |
| string: canterbury-large/world192.txt | 1103121 | 6616.2 ± 1.0% | 1725.5 ± 1.3% | 1887.4 ± 3.4% | 345.3 ± 0.8% | 1384.8 ± 0.9% | 961.2 ± 0.8% | 3.834 | 3.505 | 19.161 | 4.778 | 6.883 |
| string: http/html-1m | 1058582 | 9998.5 ± 0.7% | 4377.4 ± 1.1% | 2869.3 ± 0.6% | 417.7 ± 0.9% | 2152.1 ± 0.7% | 844.5 ± 1.3% | 2.284 | 3.485 | 23.936 | 4.646 | 11.839 |
| string: http/json-1m | 1190272 | 8600.3 ± 0.6% | 1574.3 ± 1.1% | 1566.3 ± 0.5% | 554.9 ± 1.2% | 1172.8 ± 0.6% | 850.6 ± 1.4% | 5.463 | 5.491 | 15.499 | 7.333 | 10.111 |
| string: http/js-1m | 1144362 | 6485.2 ± 0.6% | 1112.4 ± 0.6% | 1393.2 ± 0.8% | 330.8 ± 1.3% | 1110.5 ± 0.8% | 758.5 ± 0.5% | 5.830 | 4.655 | 19.606 | 5.840 | 8.550 |
| string: http/css-1m | 1097820 | 9260.8 ± 0.9% | 1488.1 ± 0.8% | 2281.6 ± 1.1% | 508.0 ± 0.3% | 1262.7 ± 0.7% | 875.9 ± 1.6% | 6.223 | 4.059 | 18.229 | 7.334 | 10.573 |
| string: dickens as Cyrillic and CJK | 1883069 | 5455.1 ± 1.4% | 3633.0 ± 1.1% | 486.9 ± 0.7% | 246.5 ± 0.2% | 464.4 ± 1.1% | 355.3 ± 0.6% | 1.502 | 11.204 | 22.126 | 11.746 | 15.353 |
| hex: silesia/dickens | 524290 | 43418.2 ± 0.7% | 2577.6 ± 0.7% | 1496.2 ± 0.4% | 460.7 ± 0.5% | 1567.8 ± 0.5% | 1064.1 ± 0.4% | 16.845 | 29.018 | 94.238 | 27.694 | 40.802 |
| hex: silesia/mozilla | 524290 | 43389.5 ± 1.7% | 2580.3 ± 1.6% | 1494.5 ± 0.7% | 388.4 ± 2.4% | 1567.0 ± 0.3% | 1065.4 ± 0.6% | 16.816 | 29.034 | 111.710 | 27.689 | 40.725 |
| hex: silesia/mr | 524290 | 43470.5 ± 0.6% | 2566.3 ± 1.0% | 1500.4 ± 0.4% | 597.4 ± 0.8% | 1565.0 ± 0.8% | 1066.3 ± 0.7% | 16.939 | 28.972 | 72.770 | 27.777 | 40.768 |
| hex: silesia/nci | 524290 | 42652.1 ± 0.9% | 2557.3 ± 0.7% | 1491.2 ± 1.3% | 755.9 ± 1.5% | 1561.2 ± 0.9% | 1060.4 ± 1.4% | 16.679 | 28.603 | 56.425 | 27.320 | 40.221 |
| hex: silesia/ooffice | 524290 | 42754.2 ± 1.1% | 2600.3 ± 0.9% | 1507.3 ± 1.1% | 323.3 ± 1.1% | 1566.4 ± 0.9% | 1062.0 ± 0.9% | 16.442 | 28.365 | 132.242 | 27.294 | 40.259 |
| hex: silesia/osdb | 524290 | 43534.8 ± 0.8% | 2595.8 ± 0.8% | 1504.2 ± 0.7% | 429.7 ± 0.6% | 1577.7 ± 0.4% | 1068.6 ± 0.7% | 16.771 | 28.942 | 101.324 | 27.594 | 40.739 |
| hex: silesia/reymont | 524290 | 43457.2 ± 1.7% | 2589.8 ± 1.3% | 1504.6 ± 0.7% | 481.6 ± 0.8% | 1571.7 ± 0.7% | 1067.8 ± 1.2% | 16.780 | 28.882 | 90.233 | 27.651 | 40.699 |
| hex: silesia/samba | 524290 | 42907.8 ± 1.4% | 2577.4 ± 0.8% | 1496.2 ± 0.4% | 333.0 ± 1.6% | 1571.8 ± 0.7% | 1064.8 ± 1.2% | 16.648 | 28.678 | 128.836 | 27.298 | 40.298 |
| hex: silesia/sao | 524290 | 43256.5 ± 0.8% | 2594.1 ± 1.0% | 1504.8 ± 0.5% | 270.0 ± 3.2% | 1573.0 ± 0.5% | 1063.6 ± 0.7% | 16.675 | 28.746 | 160.214 | 27.500 | 40.669 |
| hex: silesia/webster | 524290 | 43821.5 ± 0.6% | 2596.4 ± 0.6% | 1504.0 ± 2.1% | 433.7 ± 0.6% | 1571.0 ± 0.5% | 1068.7 ± 2.9% | 16.878 | 29.137 | 101.038 | 27.894 | 41.005 |
| hex: silesia/x-ray | 524290 | 43015.8 ± 1.2% | 2577.0 ± 0.6% | 1501.2 ± 0.4% | 421.8 ± 0.9% | 1567.9 ± 0.9% | 1063.4 ± 0.7% | 16.692 | 28.654 | 101.980 | 27.434 | 40.450 |
| hex: silesia/xml | 524290 | 42981.8 ± 2.1% | 2582.8 ± 1.2% | 1498.2 ± 1.1% | 687.2 ± 1.1% | 1564.6 ± 0.9% | 1064.5 ± 1.0% | 16.641 | 28.690 | 62.549 | 27.472 | 40.378 |
| hex: canterbury/alice29.txt | 304180 | 42793.7 ± 1.2% | 2598.4 ± 0.6% | 1516.0 ± 0.2% | 465.2 ± 0.9% | 1582.7 ± 0.7% | 1083.2 ± 5.5% | 16.469 | 28.227 | 91.991 | 27.039 | 39.505 |
| hex: canterbury/asyoulik.txt | 250360 | 42683.3 ± 2.1% | 2607.5 ± 0.6% | 1533.8 ± 1.2% | 456.1 ± 0.5% | 1583.3 ± 1.6% | 1082.9 ± 0.7% | 16.370 | 27.828 | 93.579 | 26.959 | 39.415 |
| hex: canterbury/cp.html | 49208 | 42236.3 ± 5.8% | 2581.7 ± 6.4% | 1516.8 ± 0.5% | 480.0 ± 1.4% | 1585.7 ± 0.8% | 1082.9 ± 8.2% | 16.360 | 27.845 | 87.986 | 26.637 | 39.004 |
| hex: canterbury/fields.c | 22302 | 41801.2 ± 0.6% | 2630.5 ± 1.6% | 1529.1 ± 7.3% | 597.1 ± 0.9% | 1601.0 ± 0.5% | 1092.4 ± 0.9% | 15.891 | 27.337 | 70.011 | 26.110 | 38.265 |
| hex: canterbury/grammar.lsp | 7444 | 39540.4 ± 1.8% | 2690.0 ± 0.7% | 1547.5 ± 1.2% | 810.6 ± 0.6% | 1603.7 ± 0.6% | 1100.1 ± 0.9% | 14.699 | 25.551 | 48.780 | 24.656 | 35.941 |
| hex: canterbury/kennedy.xls | 524290 | 43629.8 ± 1.1% | 2571.5 ± 0.6% | 1502.2 ± 0.3% | 776.6 ± 0.4% | 1530.5 ± 0.2% | 1071.3 ± 0.4% | 16.967 | 29.045 | 56.181 | 28.506 | 40.726 |
| hex: canterbury/lcet10.txt | 524290 | 42874.6 ± 1.9% | 2574.3 ± 1.3% | 1498.2 ± 0.9% | 458.7 ± 0.7% | 1482.7 ± 0.5% | 1061.8 ± 0.7% | 16.655 | 28.618 | 93.471 | 28.917 | 40.380 |
| hex: canterbury/plrabn12.txt | 524290 | 42415.4 ± 0.8% | 2586.4 ± 0.7% | 1501.8 ± 0.7% | 450.5 ± 0.7% | 1543.5 ± 0.5% | 1058.3 ± 1.0% | 16.399 | 28.244 | 94.156 | 27.481 | 40.077 |
| hex: canterbury/ptt5 | 524290 | 43303.0 ± 0.9% | 2580.5 ± 0.5% | 1495.0 ± 1.0% | 582.2 ± 0.9% | 1484.6 ± 0.7% | 1066.4 ± 0.4% | 16.781 | 28.965 | 74.379 | 29.169 | 40.605 |
| hex: canterbury/sum | 76482 | 42823.4 ± 6.6% | 2594.6 ± 0.8% | 1515.9 ± 0.4% | 560.2 ± 0.6% | 1582.8 ± 0.4% | 1086.8 ± 3.9% | 16.505 | 28.250 | 76.444 | 27.055 | 39.402 |
| hex: canterbury/xargs.1 | 8456 | 40150.0 ± 0.4% | 2677.4 ± 1.2% | 1553.0 ± 0.3% | 837.8 ± 0.3% | 1611.6 ± 0.6% | 1108.9 ± 0.9% | 14.996 | 25.853 | 47.921 | 24.914 | 36.208 |
| hex: canterbury-large/E.coli | 524290 | 43635.8 ± 0.1% | 2585.4 ± 0.4% | 1505.2 ± 0.2% | 816.3 ± 0.6% | 1568.6 ± 5.9% | 1069.1 ± 6.4% | 16.878 | 28.989 | 53.453 | 27.818 | 40.815 |
| hex: canterbury-large/bible.txt | 524290 | 43455.1 ± 0.7% | 2585.4 ± 6.0% | 1502.1 ± 1.9% | 477.2 ± 0.5% | 1524.5 ± 5.7% | 1067.8 ± 0.9% | 16.808 | 28.929 | 91.064 | 28.504 | 40.697 |
| hex: canterbury-large/world192.txt | 524290 | 43615.2 ± 0.3% | 2599.8 ± 0.7% | 1505.5 ± 5.4% | 459.2 ± 0.6% | 1575.1 ± 0.3% | 1069.5 ± 0.4% | 16.776 | 28.970 | 94.973 | 27.690 | 40.781 |
| hex: http/html-1kx1024 | 2099200 | 20587.8 ± 0.2% | 2334.8 ± 1.3% | 1458.3 ± 1.0% | 500.3 ± 0.5% | 1494.6 ± 5.6% | 1076.8 ± 1.0% | 8.818 | 14.118 | 41.151 | 13.775 | 19.120 |
| hex: http/html-16kx64 | 2097280 | 21206.9 ± 0.5% | 2246.8 ± 6.2% | 1456.6 ± 0.3% | 504.8 ± 0.4% | 1474.3 ± 1.7% | 1082.2 ± 3.9% | 9.439 | 14.559 | 42.013 | 14.384 | 19.596 |
| hex: http/html-1m | 524290 | 43554.7 ± 0.5% | 2593.1 ± 0.5% | 1506.9 ± 0.3% | 487.2 ± 0.3% | 1531.8 ± 1.0% | 1068.9 ± 0.4% | 16.796 | 28.903 | 89.402 | 28.434 | 40.746 |
| hex: http/json-1kx1024 | 2099200 | 20595.5 ± 0.7% | 2315.7 ± 1.7% | 1457.5 ± 0.3% | 697.2 ± 0.1% | 1487.1 ± 1.9% | 1077.3 ± 0.6% | 8.894 | 14.131 | 29.542 | 13.849 | 19.117 |
| hex: http/json-16kx64 | 2097280 | 21969.5 ± 2.1% | 2240.1 ± 0.2% | 1453.4 ± 0.3% | 707.3 ± 0.3% | 1473.9 ± 0.3% | 1087.3 ± 0.4% | 9.807 | 15.116 | 31.061 | 14.906 | 20.205 |
| hex: http/json-1m | 524290 | 43235.3 ± 1.9% | 2586.2 ± 1.3% | 1501.4 ± 0.5% | 722.1 ± 4.0% | 1525.8 ± 0.9% | 1061.5 ± 0.9% | 16.717 | 28.797 | 59.872 | 28.336 | 40.729 |
| hex: http/js-1kx1024 | 2099200 | 20202.9 ± 0.5% | 2320.2 ± 1.1% | 1457.8 ± 5.5% | 487.8 ± 0.6% | 1497.4 ± 0.6% | 1069.7 ± 2.5% | 8.708 | 13.859 | 41.413 | 13.492 | 18.886 |
| hex: http/js-16kx64 | 2097280 | 21710.7 ± 0.1% | 2226.2 ± 0.8% | 1448.2 ± 0.9% | 490.5 ± 1.0% | 1466.6 ± 0.9% | 1079.7 ± 1.1% | 9.752 | 14.991 | 44.266 | 14.803 | 20.108 |
| hex: http/js-1m | 524290 | 43144.6 ± 2.5% | 2580.9 ± 0.7% | 1497.6 ± 1.7% | 505.2 ± 0.7% | 1566.5 ± 4.2% | 1060.8 ± 1.3% | 16.717 | 28.809 | 85.397 | 27.542 | 40.671 |
| hex: http/css-1kx1024 | 2099200 | 20325.6 ± 2.8% | 2332.4 ± 0.9% | 1449.9 ± 4.4% | 552.4 ± 1.0% | 1485.6 ± 0.8% | 1065.9 ± 1.0% | 8.715 | 14.019 | 36.796 | 13.682 | 19.069 |
| hex: http/css-16kx64 | 2097280 | 21675.3 ± 0.3% | 2220.4 ± 1.5% | 1445.8 ± 0.6% | 560.0 ± 0.7% | 1459.0 ± 0.6% | 1075.1 ± 0.7% | 9.762 | 14.992 | 38.707 | 14.856 | 20.162 |
| hex: http/css-1m | 524290 | 43166.4 ± 1.9% | 2577.1 ± 1.0% | 1501.1 ± 1.6% | 532.6 ± 0.5% | 1558.9 ± 0.5% | 1059.9 ± 0.7% | 16.750 | 28.756 | 81.054 | 27.690 | 40.727 |
| hex: shuffled/dickens-1m | 524290 | 43344.9 ± 1.4% | 2590.3 ± 0.9% | 1501.0 ± 0.6% | 460.5 ± 0.7% | 1573.0 ± 0.7% | 1061.8 ± 0.5% | 16.734 | 28.877 | 94.122 | 27.556 | 40.821 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1791.4 ± 1.4% | 1488.6 ± 1.2% | 1032.3 ± 0.9% | 459.4 ± 0.2% | 470.7 ± 1.9% | 502.4 ± 1.1% | 1.203 | 1.735 | 3.899 | 3.806 | 3.565 |
| qlog records, JSON text sequence | 1467503 | 1712.4 ± 1.0% | 1244.3 ± 3.1% | 941.7 ± 4.4% | 423.2 ± 1.2% | 570.3 ± 2.5% | 348.1 ± 1.4% | 1.376 | 1.818 | 4.046 | 3.003 | 4.919 |
| messages: 11 string members | 1025025 | 1314.8 ± 0.7% | 1107.6 ± 1.6% | 771.4 ± 1.1% | 410.3 ± 2.7% | 442.3 ± 3.3% | 428.6 ± 4.1% | 1.187 | 1.705 | 3.205 | 2.973 | 3.067 |
| messages: 50 nested objects | 1121600 | 2001.2 ± 0.7% | 1880.6 ± 1.2% | 1347.7 ± 1.0% | 588.1 ± 0.9% | 653.6 ± 1.6% | 518.4 ± 5.1% | 1.064 | 1.485 | 3.403 | 3.062 | 3.860 |
| string: silesia/dickens | 172528 | 13466.6 ± 1.3% | 3946.3 ± 0.8% | 3061.0 ± 2.9% | 331.3 ± 0.5% | 1692.1 ± 0.8% | 1175.8 ± 0.7% | 3.412 | 4.399 | 40.646 | 7.959 | 11.454 |
| string: silesia/nci | 1075110 | 11607.7 ± 0.9% | 4671.0 ± 6.1% | 3106.0 ± 0.9% | 909.2 ± 0.7% | 1886.3 ± 1.3% | 1198.5 ± 0.2% | 2.485 | 3.737 | 12.767 | 6.154 | 9.685 |
| string: silesia/reymont | 1075159 | 5422.6 ± 3.1% | 1852.8 ± 2.1% | 1891.4 ± 0.5% | 379.3 ± 1.8% | 1436.5 ± 0.7% | 1040.7 ± 0.9% | 2.927 | 2.867 | 14.296 | 3.775 | 5.211 |
| string: silesia/samba | 97582 | 7382.9 ± 0.6% | 2710.0 ± 0.7% | 4070.3 ± 0.8% | 349.1 ± 0.6% | 1327.5 ± 1.6% | 1173.6 ± 0.3% | 2.724 | 1.814 | 21.146 | 5.561 | 6.291 |
| string: silesia/webster | 1098490 | 6967.7 ± 1.0% | 1979.1 ± 0.6% | 1776.8 ± 1.6% | 351.5 ± 0.7% | 1406.5 ± 1.1% | 603.3 ± 0.8% | 3.521 | 3.922 | 19.825 | 4.954 | 11.550 |
| string: silesia/xml | 1090118 | 11110.2 ± 2.9% | 3193.1 ± 0.8% | 2515.2 ± 0.6% | 603.5 ± 0.6% | 1930.8 ± 1.0% | 954.4 ± 0.8% | 3.479 | 4.417 | 18.409 | 5.754 | 11.641 |
| string: canterbury/alice29.txt | 159425 | 13245.6 ± 1.6% | 2891.5 ± 2.9% | 2998.2 ± 1.6% | 316.9 ± 1.1% | 1512.7 ± 5.4% | 1088.1 ± 0.7% | 4.581 | 4.418 | 41.804 | 8.756 | 12.174 |
| string: canterbury/asyoulik.txt | 132198 | 11419.8 ± 0.4% | 2093.9 ± 1.4% | 3081.6 ± 3.5% | 314.3 ± 1.5% | 1353.8 ± 1.2% | 958.1 ± 1.0% | 5.454 | 3.706 | 36.333 | 8.435 | 11.920 |
| string: canterbury/lcet10.txt | 441884 | 12632.7 ± 1.4% | 3090.8 ± 1.1% | 2540.7 ± 0.6% | 367.9 ± 1.2% | 1657.8 ± 1.4% | 1192.7 ± 4.1% | 4.087 | 4.972 | 34.334 | 7.620 | 10.592 |
| string: canterbury/plrabn12.txt | 503330 | 8884.7 ± 2.4% | 2301.4 ± 0.3% | 2084.3 ± 1.4% | 346.1 ± 1.3% | 1596.0 ± 0.9% | 1109.6 ± 1.4% | 3.861 | 4.263 | 25.668 | 5.567 | 8.007 |
| string: canterbury-large/E.coli | 1048578 | 31342.0 ± 1.0% | 16092.9 ± 1.7% | 3480.1 ± 0.9% | 1690.9 ± 0.5% | 3135.2 ± 0.4% | 1413.5 ± 0.6% | 1.948 | 9.006 | 18.535 | 9.997 | 22.173 |
| string: canterbury-large/bible.txt | 1055886 | 9928.6 ± 0.9% | 4886.0 ± 1.1% | 2997.3 ± 0.4% | 404.4 ± 1.7% | 2213.9 ± 0.8% | 1489.9 ± 0.7% | 2.032 | 3.312 | 24.552 | 4.485 | 6.664 |
| string: canterbury-large/world192.txt | 1103121 | 6445.3 ± 0.6% | 1725.5 ± 1.3% | 1887.4 ± 3.4% | 345.3 ± 0.8% | 1384.8 ± 0.9% | 961.2 ± 0.8% | 3.735 | 3.415 | 18.666 | 4.654 | 6.705 |
| string: http/html-1m | 1058582 | 10115.7 ± 0.8% | 4377.4 ± 1.1% | 2869.3 ± 0.6% | 417.7 ± 0.9% | 2152.1 ± 0.7% | 844.5 ± 1.3% | 2.311 | 3.526 | 24.216 | 4.700 | 11.978 |
| string: http/json-1m | 1190272 | 8778.0 ± 0.7% | 1574.3 ± 1.1% | 1566.3 ± 0.5% | 554.9 ± 1.2% | 1172.8 ± 0.6% | 850.6 ± 1.4% | 5.576 | 5.604 | 15.819 | 7.485 | 10.320 |
| string: http/js-1m | 1144362 | 6564.4 ± 1.3% | 1112.4 ± 0.6% | 1393.2 ± 0.8% | 330.8 ± 1.3% | 1110.5 ± 0.8% | 758.5 ± 0.5% | 5.901 | 4.712 | 19.845 | 5.911 | 8.654 |
| string: http/css-1m | 1097820 | 9530.6 ± 1.1% | 1488.1 ± 0.8% | 2281.6 ± 1.1% | 508.0 ± 0.3% | 1262.7 ± 0.7% | 875.9 ± 1.6% | 6.405 | 4.177 | 18.760 | 7.548 | 10.881 |
| string: dickens as Cyrillic and CJK | 1883069 | 5724.6 ± 0.6% | 3633.0 ± 1.1% | 486.9 ± 0.7% | 246.5 ± 0.2% | 464.4 ± 1.1% | 355.3 ± 0.6% | 1.576 | 11.758 | 23.220 | 12.326 | 16.112 |
| hex: silesia/dickens | 524290 | 43551.6 ± 0.5% | 2577.6 ± 0.7% | 1496.2 ± 0.4% | 460.7 ± 0.5% | 1567.8 ± 0.5% | 1064.1 ± 0.4% | 16.896 | 29.107 | 94.527 | 27.779 | 40.928 |
| hex: silesia/mozilla | 524290 | 43521.6 ± 0.6% | 2580.3 ± 1.6% | 1494.5 ± 0.7% | 388.4 ± 2.4% | 1567.0 ± 0.3% | 1065.4 ± 0.6% | 16.867 | 29.122 | 112.050 | 27.773 | 40.849 |
| hex: silesia/mr | 524290 | 43654.2 ± 1.0% | 2566.3 ± 1.0% | 1500.4 ± 0.4% | 597.4 ± 0.8% | 1565.0 ± 0.8% | 1066.3 ± 0.7% | 17.011 | 29.095 | 73.078 | 27.894 | 40.940 |
| hex: silesia/nci | 524290 | 42908.5 ± 2.4% | 2557.3 ± 0.7% | 1491.2 ± 1.3% | 755.9 ± 1.5% | 1561.2 ± 0.9% | 1060.4 ± 1.4% | 16.779 | 28.775 | 56.764 | 27.484 | 40.463 |
| hex: silesia/ooffice | 524290 | 42772.1 ± 1.3% | 2600.3 ± 0.9% | 1507.3 ± 1.1% | 323.3 ± 1.1% | 1566.4 ± 0.9% | 1062.0 ± 0.9% | 16.449 | 28.377 | 132.297 | 27.305 | 40.276 |
| hex: silesia/osdb | 524290 | 43481.5 ± 0.6% | 2595.8 ± 0.8% | 1504.2 ± 0.7% | 429.7 ± 0.6% | 1577.7 ± 0.4% | 1068.6 ± 0.7% | 16.750 | 28.907 | 101.200 | 27.560 | 40.690 |
| hex: silesia/reymont | 524290 | 43639.0 ± 1.0% | 2589.8 ± 1.3% | 1504.6 ± 0.7% | 481.6 ± 0.8% | 1571.7 ± 0.7% | 1067.8 ± 1.2% | 16.851 | 29.003 | 90.611 | 27.766 | 40.869 |
| hex: silesia/samba | 524290 | 43150.0 ± 1.2% | 2577.4 ± 0.8% | 1496.2 ± 0.4% | 333.0 ± 1.6% | 1571.8 ± 0.7% | 1064.8 ± 1.2% | 16.742 | 28.840 | 129.564 | 27.453 | 40.526 |
| hex: silesia/sao | 524290 | 43516.0 ± 1.1% | 2594.1 ± 1.0% | 1504.8 ± 0.5% | 270.0 ± 3.2% | 1573.0 ± 0.5% | 1063.6 ± 0.7% | 16.775 | 28.919 | 161.175 | 27.665 | 40.913 |
| hex: silesia/webster | 524290 | 43652.0 ± 6.6% | 2596.4 ± 0.6% | 1504.0 ± 2.1% | 433.7 ± 0.6% | 1571.0 ± 0.5% | 1068.7 ± 2.9% | 16.812 | 29.024 | 100.647 | 27.786 | 40.847 |
| hex: silesia/x-ray | 524290 | 43387.7 ± 2.2% | 2577.0 ± 0.6% | 1501.2 ± 0.4% | 421.8 ± 0.9% | 1567.9 ± 0.9% | 1063.4 ± 0.7% | 16.837 | 28.902 | 102.862 | 27.672 | 40.800 |
| hex: silesia/xml | 524290 | 42828.8 ± 1.4% | 2582.8 ± 1.2% | 1498.2 ± 1.1% | 687.2 ± 1.1% | 1564.6 ± 0.9% | 1064.5 ± 1.0% | 16.582 | 28.588 | 62.326 | 27.374 | 40.235 |
| hex: canterbury/alice29.txt | 304180 | 43101.4 ± 1.6% | 2598.4 ± 0.6% | 1516.0 ± 0.2% | 465.2 ± 0.9% | 1582.7 ± 0.7% | 1083.2 ± 5.5% | 16.587 | 28.430 | 92.652 | 27.233 | 39.789 |
| hex: canterbury/asyoulik.txt | 250360 | 42783.8 ± 1.4% | 2607.5 ± 0.6% | 1533.8 ± 1.2% | 456.1 ± 0.5% | 1583.3 ± 1.6% | 1082.9 ± 0.7% | 16.408 | 27.894 | 93.800 | 27.023 | 39.508 |
| hex: canterbury/cp.html | 49208 | 42288.3 ± 5.3% | 2581.7 ± 6.4% | 1516.8 ± 0.5% | 480.0 ± 1.4% | 1585.7 ± 0.8% | 1082.9 ± 8.2% | 16.380 | 27.879 | 88.094 | 26.669 | 39.052 |
| hex: canterbury/fields.c | 22302 | 41705.9 ± 1.8% | 2630.5 ± 1.6% | 1529.1 ± 7.3% | 597.1 ± 0.9% | 1601.0 ± 0.5% | 1092.4 ± 0.9% | 15.855 | 27.275 | 69.851 | 26.051 | 38.178 |
| hex: canterbury/grammar.lsp | 7444 | 39638.3 ± 0.6% | 2690.0 ± 0.7% | 1547.5 ± 1.2% | 810.6 ± 0.6% | 1603.7 ± 0.6% | 1100.1 ± 0.9% | 14.735 | 25.615 | 48.900 | 24.717 | 36.030 |
| hex: canterbury/kennedy.xls | 524290 | 43756.5 ± 0.3% | 2571.5 ± 0.6% | 1502.2 ± 0.3% | 776.6 ± 0.4% | 1530.5 ± 0.2% | 1071.3 ± 0.4% | 17.016 | 29.129 | 56.344 | 28.589 | 40.845 |
| hex: canterbury/lcet10.txt | 524290 | 43121.9 ± 1.7% | 2574.3 ± 1.3% | 1498.2 ± 0.9% | 458.7 ± 0.7% | 1482.7 ± 0.5% | 1061.8 ± 0.7% | 16.751 | 28.783 | 94.010 | 29.084 | 40.613 |
| hex: canterbury/plrabn12.txt | 524290 | 42464.1 ± 8.3% | 2586.4 ± 0.7% | 1501.8 ± 0.7% | 450.5 ± 0.7% | 1543.5 ± 0.5% | 1058.3 ± 1.0% | 16.418 | 28.276 | 94.264 | 27.512 | 40.123 |
| hex: canterbury/ptt5 | 524290 | 43350.0 ± 1.0% | 2580.5 ± 0.5% | 1495.0 ± 1.0% | 582.2 ± 0.9% | 1484.6 ± 0.7% | 1066.4 ± 0.4% | 16.799 | 28.997 | 74.460 | 29.201 | 40.649 |
| hex: canterbury/sum | 76482 | 42811.4 ± 0.6% | 2594.6 ± 0.8% | 1515.9 ± 0.4% | 560.2 ± 0.6% | 1582.8 ± 0.4% | 1086.8 ± 3.9% | 16.500 | 28.242 | 76.422 | 27.048 | 39.391 |
| hex: canterbury/xargs.1 | 8456 | 40198.5 ± 0.5% | 2677.4 ± 1.2% | 1553.0 ± 0.3% | 837.8 ± 0.3% | 1611.6 ± 0.6% | 1108.9 ± 0.9% | 15.014 | 25.884 | 47.979 | 24.944 | 36.252 |
| hex: canterbury-large/E.coli | 524290 | 43619.0 ± 0.4% | 2585.4 ± 0.4% | 1505.2 ± 0.2% | 816.3 ± 0.6% | 1568.6 ± 5.9% | 1069.1 ± 6.4% | 16.871 | 28.978 | 53.432 | 27.807 | 40.799 |
| hex: canterbury-large/bible.txt | 524290 | 43603.5 ± 1.4% | 2585.4 ± 6.0% | 1502.1 ± 1.9% | 477.2 ± 0.5% | 1524.5 ± 5.7% | 1067.8 ± 0.9% | 16.865 | 29.028 | 91.375 | 28.601 | 40.836 |
| hex: canterbury-large/world192.txt | 524290 | 43777.3 ± 1.0% | 2599.8 ± 0.7% | 1505.5 ± 5.4% | 459.2 ± 0.6% | 1575.1 ± 0.3% | 1069.5 ± 0.4% | 16.839 | 29.077 | 95.326 | 27.793 | 40.933 |
| hex: http/html-1kx1024 | 2099200 | 20646.2 ± 0.5% | 2334.8 ± 1.3% | 1458.3 ± 1.0% | 500.3 ± 0.5% | 1494.6 ± 5.6% | 1076.8 ± 1.0% | 8.843 | 14.158 | 41.268 | 13.814 | 19.175 |
| hex: http/html-16kx64 | 2097280 | 21311.4 ± 0.3% | 2246.8 ± 6.2% | 1456.6 ± 0.3% | 504.8 ± 0.4% | 1474.3 ± 1.7% | 1082.2 ± 3.9% | 9.485 | 14.631 | 42.220 | 14.455 | 19.692 |
| hex: http/html-1m | 524290 | 43674.7 ± 0.4% | 2593.1 ± 0.5% | 1506.9 ± 0.3% | 487.2 ± 0.3% | 1531.8 ± 1.0% | 1068.9 ± 0.4% | 16.843 | 28.982 | 89.648 | 28.512 | 40.858 |
| hex: http/json-1kx1024 | 2099200 | 20687.4 ± 0.2% | 2315.7 ± 1.7% | 1457.5 ± 0.3% | 697.2 ± 0.1% | 1487.1 ± 1.9% | 1077.3 ± 0.6% | 8.933 | 14.194 | 29.674 | 13.911 | 19.202 |
| hex: http/json-16kx64 | 2097280 | 22070.8 ± 0.5% | 2240.1 ± 0.2% | 1453.4 ± 0.3% | 707.3 ± 0.3% | 1473.9 ± 0.3% | 1087.3 ± 0.4% | 9.853 | 15.186 | 31.205 | 14.975 | 20.299 |
| hex: http/json-1m | 524290 | 43199.0 ± 0.8% | 2586.2 ± 1.3% | 1501.4 ± 0.5% | 722.1 ± 4.0% | 1525.8 ± 0.9% | 1061.5 ± 0.9% | 16.703 | 28.772 | 59.821 | 28.313 | 40.695 |
| hex: http/js-1kx1024 | 2099200 | 20269.4 ± 1.1% | 2320.2 ± 1.1% | 1457.8 ± 5.5% | 487.8 ± 0.6% | 1497.4 ± 0.6% | 1069.7 ± 2.5% | 8.736 | 13.904 | 41.550 | 13.536 | 18.948 |
| hex: http/js-16kx64 | 2097280 | 21779.2 ± 0.3% | 2226.2 ± 0.8% | 1448.2 ± 0.9% | 490.5 ± 1.0% | 1466.6 ± 0.9% | 1079.7 ± 1.1% | 9.783 | 15.038 | 44.405 | 14.850 | 20.172 |
| hex: http/js-1m | 524290 | 43102.0 ± 3.0% | 2580.9 ± 0.7% | 1497.6 ± 1.7% | 505.2 ± 0.7% | 1566.5 ± 4.2% | 1060.8 ± 1.3% | 16.700 | 28.781 | 85.313 | 27.515 | 40.631 |
| hex: http/css-1kx1024 | 2099200 | 20408.8 ± 2.3% | 2332.4 ± 0.9% | 1449.9 ± 4.4% | 552.4 ± 1.0% | 1485.6 ± 0.8% | 1065.9 ± 1.0% | 8.750 | 14.076 | 36.946 | 13.738 | 19.147 |
| hex: http/css-16kx64 | 2097280 | 21761.9 ± 0.2% | 2220.4 ± 1.5% | 1445.8 ± 0.6% | 560.0 ± 0.7% | 1459.0 ± 0.6% | 1075.1 ± 0.7% | 9.801 | 15.052 | 38.862 | 14.916 | 20.242 |
| hex: http/css-1m | 524290 | 43072.3 ± 0.9% | 2577.1 ± 1.0% | 1501.1 ± 1.6% | 532.6 ± 0.5% | 1558.9 ± 0.5% | 1059.9 ± 0.7% | 16.713 | 28.694 | 80.877 | 27.630 | 40.638 |
| hex: shuffled/dickens-1m | 524290 | 43484.9 ± 0.8% | 2590.3 ± 0.9% | 1501.0 ± 0.6% | 460.5 ± 0.7% | 1573.0 ± 0.7% | 1061.8 ± 0.5% | 16.788 | 28.970 | 94.426 | 27.645 | 40.953 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1144.9 ± 1.1% | 1496.1 ± 1.0% | 1106.8 ± 0.5% | 360.0 ± 2.0% | 665.4 ± 0.6% | 363.9 ± 11.7% | 0.765 | 1.034 | 3.180 | 1.720 | 3.146 |
| qlog records, JSON text sequence | 1467503 | 1011.2 ± 1.0% | 1216.2 ± 0.7% | 1117.6 ± 1.9% | 302.1 ± 2.5% | 753.8 ± 0.7% | 315.4 ± 0.6% | 0.831 | 0.905 | 3.347 | 1.341 | 3.206 |
| messages: 11 string members | 1025025 | 942.4 ± 0.4% | 1984.7 ± 1.9% | 703.2 ± 3.1% | 313.9 ± 1.3% | 508.3 ± 0.6% | 302.1 ± 1.3% | 0.475 | 1.340 | 3.003 | 1.854 | 3.119 |
| messages: 50 nested objects | 1121600 | 1226.9 ± 0.6% | 1723.0 ± 1.4% | 1450.0 ± 0.7% | 375.6 ± 0.8% | 896.0 ± 0.3% | 418.7 ± 0.9% | 0.712 | 0.846 | 3.267 | 1.369 | 2.931 |
| string: silesia/dickens | 172528 | 6672.3 ± 0.3% | 3432.3 ± 4.0% | 2818.2 ± 1.4% | 303.2 ± 1.9% | 3015.1 ± 1.8% | 569.9 ± 2.8% | 1.944 | 2.368 | 22.003 | 2.213 | 11.708 |
| string: silesia/nci | 1075110 | 5422.8 ± 1.1% | 3880.1 ± 0.3% | 2993.3 ± 0.6% | 562.6 ± 1.5% | 3616.6 ± 0.8% | 553.6 ± 2.1% | 1.398 | 1.812 | 9.639 | 1.499 | 9.796 |
| string: silesia/reymont | 1075159 | 3444.5 ± 2.1% | 3375.7 ± 0.5% | 1954.3 ± 1.0% | 325.6 ± 1.4% | 2088.7 ± 0.7% | 476.3 ± 4.2% | 1.020 | 1.762 | 10.579 | 1.649 | 7.232 |
| string: silesia/samba | 97582 | 3986.6 ± 0.9% | 3760.5 ± 0.5% | 3093.7 ± 0.8% | 311.2 ± 1.0% | 1947.1 ± 1.9% | 419.1 ± 1.0% | 1.060 | 1.289 | 12.809 | 2.047 | 9.513 |
| string: silesia/webster | 1098490 | 4415.9 ± 1.1% | 2428.2 ± 0.5% | 1731.9 ± 2.5% | 305.2 ± 0.4% | 2058.9 ± 0.4% | 464.1 ± 2.7% | 1.819 | 2.550 | 14.469 | 2.145 | 9.515 |
| string: silesia/xml | 1090118 | 6068.3 ± 0.1% | 4974.9 ± 0.2% | 2448.3 ± 0.3% | 458.3 ± 0.6% | 3307.7 ± 0.2% | 539.8 ± 1.1% | 1.220 | 2.479 | 13.242 | 1.835 | 11.242 |
| string: canterbury/alice29.txt | 159425 | 5723.3 ± 1.2% | 2729.2 ± 0.6% | 2850.4 ± 1.3% | 288.6 ± 0.7% | 2722.9 ± 2.1% | 518.3 ± 0.9% | 2.097 | 2.008 | 19.829 | 2.102 | 11.042 |
| string: canterbury/asyoulik.txt | 132198 | 4269.8 ± 1.1% | 2625.7 ± 0.3% | 2760.6 ± 0.8% | 294.8 ± 1.1% | 2386.4 ± 1.0% | 454.5 ± 1.7% | 1.626 | 1.547 | 14.483 | 1.789 | 9.396 |
| string: canterbury/lcet10.txt | 441884 | 6678.2 ± 0.8% | 3285.8 ± 0.3% | 2301.4 ± 0.3% | 323.6 ± 1.5% | 2760.4 ± 0.5% | 570.5 ± 0.5% | 2.032 | 2.902 | 20.638 | 2.419 | 11.705 |
| string: canterbury/plrabn12.txt | 503330 | 5461.9 ± 0.7% | 3162.9 ± 1.2% | 1817.8 ± 0.9% | 301.1 ± 0.8% | 2803.6 ± 2.0% | 530.6 ± 0.9% | 1.727 | 3.005 | 18.139 | 1.948 | 10.293 |
| string: canterbury-large/E.coli | 1048578 | 33768.4 ± 0.8% | 13412.7 ± 1.3% | 3388.2 ± 0.8% | 1156.0 ± 6.0% | 8898.0 ± 0.8% | 931.0 ± 2.8% | 2.518 | 9.967 | 29.211 | 3.795 | 36.271 |
| string: canterbury-large/bible.txt | 1055886 | 8484.2 ± 1.0% | 5249.1 ± 1.2% | 2761.7 ± 0.7% | 332.2 ± 0.7% | 3865.8 ± 0.9% | 614.1 ± 3.6% | 1.616 | 3.072 | 25.541 | 2.195 | 13.816 |
| string: canterbury-large/world192.txt | 1103121 | 4117.5 ± 1.2% | 2293.4 ± 1.0% | 1772.5 ± 1.3% | 312.2 ± 1.1% | 2111.6 ± 1.2% | 462.5 ± 1.7% | 1.795 | 2.323 | 13.189 | 1.950 | 8.904 |
| string: http/html-1m | 1058582 | 8829.0 ± 7.4% | 4762.5 ± 1.9% | 2656.6 ± 0.8% | 385.4 ± 1.1% | 3630.7 ± 0.8% | 589.7 ± 7.2% | 1.854 | 3.323 | 22.909 | 2.432 | 14.973 |
| string: http/json-1m | 1190272 | 3300.3 ± 0.7% | 1246.7 ± 0.8% | 2085.1 ± 2.8% | 400.6 ± 4.6% | 1342.6 ± 0.6% | 438.0 ± 1.4% | 2.647 | 1.583 | 8.239 | 2.458 | 7.534 |
| string: http/js-1m | 1144362 | 2871.0 ± 0.4% | 1612.5 ± 0.1% | 1333.4 ± 0.3% | 304.1 ± 3.8% | 1420.7 ± 0.6% | 379.8 ± 1.6% | 1.780 | 2.153 | 9.440 | 2.021 | 7.559 |
| string: http/css-1m | 1097820 | 3312.2 ± 0.9% | 2892.6 ± 0.4% | 2274.0 ± 0.8% | 401.7 ± 1.7% | 2068.0 ± 0.5% | 439.3 ± 1.7% | 1.145 | 1.457 | 8.245 | 1.602 | 7.540 |
| string: dickens as Cyrillic and CJK | 1883069 | 5816.9 ± 0.7% | 3040.8 ± 2.8% | 659.9 ± 1.0% | 323.8 ± 0.6% | 512.1 ± 0.9% | 162.5 ± 5.7% | 1.913 | 8.815 | 17.963 | 11.359 | 35.791 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1210.3 ± 1.3% | 1243.7 ± 1.4% | 1100.3 ± 1.1% | 234.8 ± 0.9% | 476.0 ± 0.7% | 225.1 ± 4.7% | 0.973 | 1.100 | 5.155 | 2.543 | 5.377 |
| hex: silesia/dickens | 524290 | 33926.9 ± 4.2% | 15084.7 ± 0.5% | 3555.6 ± 0.3% | 452.0 ± 0.5% | 8910.5 ± 0.7% | 1139.3 ± 3.8% | 2.249 | 9.542 | 75.054 | 3.808 | 29.778 |
| hex: silesia/mozilla | 524290 | 33745.1 ± 0.6% | 14944.1 ± 2.6% | 3473.2 ± 0.8% | 415.1 ± 2.0% | 8862.1 ± 1.0% | 1135.7 ± 1.2% | 2.258 | 9.716 | 81.297 | 3.808 | 29.713 |
| hex: silesia/mr | 524290 | 33844.2 ± 0.5% | 15063.0 ± 1.3% | 3483.0 ± 0.4% | 621.1 ± 3.4% | 8882.8 ± 0.4% | 1139.6 ± 0.6% | 2.247 | 9.717 | 54.489 | 3.810 | 29.698 |
| hex: silesia/nci | 524290 | 33730.7 ± 3.5% | 15042.4 ± 0.8% | 3499.7 ± 3.1% | 712.6 ± 1.9% | 8916.0 ± 1.3% | 1137.2 ± 5.4% | 2.242 | 9.638 | 47.334 | 3.783 | 29.660 |
| hex: silesia/ooffice | 524290 | 33891.8 ± 0.4% | 15027.5 ± 0.6% | 3484.5 ± 0.5% | 332.2 ± 0.4% | 8907.6 ± 0.3% | 1139.9 ± 0.9% | 2.255 | 9.726 | 102.028 | 3.805 | 29.732 |
| hex: silesia/osdb | 524290 | 33825.8 ± 0.6% | 14996.6 ± 0.8% | 3481.5 ± 0.8% | 428.0 ± 0.4% | 8872.1 ± 0.9% | 1136.1 ± 0.2% | 2.256 | 9.716 | 79.032 | 3.813 | 29.775 |
| hex: silesia/reymont | 524290 | 33958.8 ± 0.4% | 15124.0 ± 0.4% | 3552.9 ± 0.2% | 459.4 ± 0.8% | 8941.0 ± 0.1% | 1144.5 ± 0.7% | 2.245 | 9.558 | 73.924 | 3.798 | 29.672 |
| hex: silesia/samba | 524290 | 33862.1 ± 0.7% | 15058.7 ± 0.6% | 3489.9 ± 0.6% | 344.7 ± 0.5% | 8862.5 ± 4.8% | 1138.4 ± 0.8% | 2.249 | 9.703 | 98.248 | 3.821 | 29.744 |
| hex: silesia/sao | 524290 | 33742.8 ± 0.5% | 14939.3 ± 4.1% | 3471.1 ± 0.6% | 274.3 ± 0.7% | 8831.6 ± 0.8% | 1131.5 ± 0.8% | 2.259 | 9.721 | 123.010 | 3.821 | 29.821 |
| hex: silesia/webster | 524290 | 33700.8 ± 0.5% | 14972.8 ± 1.2% | 3533.8 ± 1.2% | 416.3 ± 1.9% | 8865.1 ± 0.8% | 1132.7 ± 1.1% | 2.251 | 9.537 | 80.946 | 3.801 | 29.752 |
| hex: silesia/x-ray | 524290 | 33754.4 ± 0.6% | 15005.9 ± 1.0% | 3491.7 ± 3.5% | 409.6 ± 0.9% | 8844.6 ± 0.7% | 1130.2 ± 1.1% | 2.249 | 9.667 | 82.406 | 3.816 | 29.866 |
| hex: silesia/xml | 524290 | 33730.7 ± 1.3% | 14957.5 ± 3.2% | 3542.6 ± 1.0% | 526.1 ± 0.8% | 8851.5 ± 4.8% | 1129.8 ± 0.8% | 2.255 | 9.521 | 64.120 | 3.811 | 29.854 |
| hex: canterbury/alice29.txt | 304180 | 33688.8 ± 1.0% | 14115.1 ± 2.4% | 3546.5 ± 2.9% | 457.7 ± 0.9% | 8865.9 ± 0.4% | 1141.4 ± 0.8% | 2.387 | 9.499 | 73.605 | 3.800 | 29.516 |
| hex: canterbury/asyoulik.txt | 250360 | 33666.0 ± 4.6% | 14972.5 ± 0.7% | 3486.0 ± 0.5% | 443.7 ± 0.3% | 8838.6 ± 5.0% | 1143.6 ± 0.7% | 2.249 | 9.657 | 75.872 | 3.809 | 29.438 |
| hex: canterbury/cp.html | 49208 | 33245.0 ± 5.7% | 14378.1 ± 0.4% | 3549.1 ± 0.5% | 434.8 ± 0.6% | 9198.4 ± 4.0% | 1113.3 ± 1.1% | 2.312 | 9.367 | 76.460 | 3.614 | 29.861 |
| hex: canterbury/fields.c | 22302 | 32796.5 ± 0.3% | 17524.1 ± 1.0% | 3651.1 ± 0.6% | 473.8 ± 1.4% | 9177.0 ± 0.5% | 1099.1 ± 3.3% | 1.872 | 8.983 | 69.219 | 3.574 | 29.840 |
| hex: canterbury/grammar.lsp | 7444 | 29635.1 ± 0.4% | 17121.5 ± 0.9% | 3595.7 ± 1.1% | 584.4 ± 0.7% | 8895.8 ± 1.3% | 1055.9 ± 1.8% | 1.731 | 8.242 | 50.709 | 3.331 | 28.066 |
| hex: canterbury/kennedy.xls | 524290 | 33644.0 ± 4.7% | 14960.9 ± 0.7% | 3540.0 ± 0.8% | 692.9 ± 0.9% | 8877.5 ± 1.1% | 1115.5 ± 4.4% | 2.249 | 9.504 | 48.558 | 3.790 | 30.161 |
| hex: canterbury/lcet10.txt | 524290 | 33615.2 ± 0.6% | 14979.9 ± 0.8% | 3532.2 ± 3.0% | 457.9 ± 0.4% | 8848.4 ± 0.8% | 1124.5 ± 4.2% | 2.244 | 9.517 | 73.417 | 3.799 | 29.893 |
| hex: canterbury/plrabn12.txt | 524290 | 33891.7 ± 0.4% | 15075.8 ± 1.0% | 3544.5 ± 3.5% | 441.6 ± 0.8% | 8873.7 ± 0.7% | 1121.8 ± 3.6% | 2.248 | 9.562 | 76.739 | 3.819 | 30.211 |
| hex: canterbury/ptt5 | 524290 | 33845.2 ± 1.1% | 15054.4 ± 1.2% | 3484.1 ± 1.4% | 653.0 ± 1.0% | 8883.1 ± 0.9% | 1127.3 ± 5.1% | 2.248 | 9.714 | 51.830 | 3.810 | 30.024 |
| hex: canterbury/sum | 76482 | 33056.9 ± 3.5% | 15315.4 ± 0.5% | 3536.3 ± 0.4% | 531.1 ± 0.4% | 8802.1 ± 0.5% | 1122.2 ± 2.6% | 2.158 | 9.348 | 62.243 | 3.756 | 29.457 |
| hex: canterbury/xargs.1 | 8456 | 30299.4 ± 0.4% | 17375.2 ± 0.9% | 3567.3 ± 0.7% | 556.1 ± 1.5% | 8936.1 ± 0.6% | 1105.1 ± 1.4% | 1.744 | 8.494 | 54.481 | 3.391 | 27.417 |
| hex: canterbury-large/E.coli | 524290 | 33637.0 ± 4.0% | 14992.7 ± 0.8% | 3467.0 ± 0.6% | 956.6 ± 0.7% | 8875.7 ± 0.4% | 1108.8 ± 4.8% | 2.244 | 9.702 | 35.165 | 3.790 | 30.337 |
| hex: canterbury-large/bible.txt | 524290 | 33789.9 ± 0.8% | 14995.2 ± 0.5% | 3483.7 ± 0.9% | 471.4 ± 0.5% | 8867.5 ± 5.1% | 1130.5 ± 2.2% | 2.253 | 9.699 | 71.681 | 3.811 | 29.890 |
| hex: canterbury-large/world192.txt | 524290 | 33863.4 ± 4.6% | 15044.2 ± 0.8% | 3552.8 ± 0.8% | 438.8 ± 0.8% | 8905.7 ± 1.1% | 1135.1 ± 2.9% | 2.251 | 9.532 | 77.177 | 3.802 | 29.832 |
| hex: http/html-1kx1024 | 2099200 | 15396.8 ± 4.1% | 12257.0 ± 8.7% | 3177.6 ± 2.0% | 462.6 ± 0.2% | 7405.9 ± 1.2% | 971.8 ± 2.1% | 1.256 | 4.845 | 33.282 | 2.079 | 15.844 |
| hex: http/html-16kx64 | 2097280 | 27904.8 ± 4.8% | 14004.7 ± 3.7% | 3388.8 ± 1.4% | 458.1 ± 2.0% | 8521.1 ± 8.0% | 1067.9 ± 3.2% | 1.993 | 8.234 | 60.919 | 3.275 | 26.130 |
| hex: http/html-1m | 524290 | 33835.4 ± 2.6% | 15045.5 ± 0.6% | 3475.7 ± 3.8% | 445.9 ± 2.7% | 8876.7 ± 3.5% | 1114.3 ± 7.4% | 2.249 | 9.735 | 75.874 | 3.812 | 30.364 |
| hex: http/json-1kx1024 | 2099200 | 15416.4 ± 1.1% | 12366.8 ± 1.3% | 3180.9 ± 1.2% | 623.4 ± 0.8% | 7410.2 ± 0.8% | 971.2 ± 5.0% | 1.247 | 4.846 | 24.730 | 2.080 | 15.873 |
| hex: http/json-16kx64 | 2097280 | 27760.0 ± 0.3% | 13970.4 ± 2.4% | 3427.5 ± 3.2% | 628.8 ± 0.4% | 8635.9 ± 0.8% | 1087.9 ± 4.3% | 1.987 | 8.099 | 44.144 | 3.214 | 25.517 |
| hex: http/json-1m | 524290 | 33911.3 ± 0.3% | 15125.7 ± 1.1% | 3569.7 ± 0.2% | 600.1 ± 1.4% | 8925.9 ± 0.2% | 1121.3 ± 3.9% | 2.242 | 9.500 | 56.512 | 3.799 | 30.242 |
| hex: http/js-1kx1024 | 2099200 | 15526.0 ± 0.6% | 11854.8 ± 0.6% | 3194.9 ± 1.0% | 456.3 ± 0.8% | 7331.1 ± 4.5% | 975.0 ± 1.6% | 1.310 | 4.860 | 34.026 | 2.118 | 15.924 |
| hex: http/js-16kx64 | 2097280 | 27467.4 ± 0.4% | 13984.2 ± 2.6% | 3414.1 ± 0.3% | 458.6 ± 0.5% | 8188.6 ± 0.6% | 1088.2 ± 2.1% | 1.964 | 8.045 | 59.895 | 3.354 | 25.242 |
| hex: http/js-1m | 524290 | 33943.0 ± 0.2% | 15053.9 ± 0.8% | 3562.3 ± 0.8% | 451.7 ± 2.4% | 8915.8 ± 0.8% | 1131.6 ± 1.7% | 2.255 | 9.528 | 75.151 | 3.807 | 29.995 |
| hex: http/css-1kx1024 | 2099200 | 15394.8 ± 0.9% | 12063.7 ± 0.6% | 3174.0 ± 1.1% | 503.5 ± 1.5% | 7354.2 ± 3.7% | 970.1 ± 1.8% | 1.276 | 4.850 | 30.577 | 2.093 | 15.869 |
| hex: http/css-16kx64 | 2097280 | 27685.0 ± 2.1% | 13861.3 ± 2.5% | 3400.0 ± 3.4% | 506.9 ± 0.6% | 8525.9 ± 0.7% | 1082.7 ± 1.3% | 1.997 | 8.143 | 54.619 | 3.247 | 25.570 |
| hex: http/css-1m | 524290 | 33782.4 ± 1.8% | 15011.5 ± 1.2% | 3564.3 ± 1.0% | 454.4 ± 1.5% | 8876.6 ± 0.6% | 1108.1 ± 4.7% | 2.250 | 9.478 | 74.344 | 3.806 | 30.487 |
| hex: shuffled/dickens-1m | 524290 | 33973.9 ± 0.3% | 15139.8 ± 0.6% | 3492.8 ± 0.3% | 453.4 ± 0.3% | 8906.0 ± 0.3% | 1128.3 ± 1.3% | 2.244 | 9.727 | 74.924 | 3.815 | 30.110 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1275.2 ± 0.5% | 1496.1 ± 1.0% | 1106.8 ± 0.5% | 360.0 ± 2.0% | 665.4 ± 0.6% | 363.9 ± 11.7% | 0.852 | 1.152 | 3.542 | 1.916 | 3.505 |
| qlog records, JSON text sequence | 1467503 | 1131.3 ± 0.5% | 1216.2 ± 0.7% | 1117.6 ± 1.9% | 302.1 ± 2.5% | 753.8 ± 0.7% | 315.4 ± 0.6% | 0.930 | 1.012 | 3.745 | 1.501 | 3.587 |
| messages: 11 string members | 1025025 | 1018.6 ± 0.8% | 1984.7 ± 1.9% | 703.2 ± 3.1% | 313.9 ± 1.3% | 508.3 ± 0.6% | 302.1 ± 1.3% | 0.513 | 1.449 | 3.245 | 2.004 | 3.372 |
| messages: 50 nested objects | 1121600 | 1300.8 ± 0.9% | 1723.0 ± 1.4% | 1450.0 ± 0.7% | 375.6 ± 0.8% | 896.0 ± 0.3% | 418.7 ± 0.9% | 0.755 | 0.897 | 3.463 | 1.452 | 3.107 |
| string: silesia/dickens | 172528 | 6672.4 ± 0.8% | 3432.3 ± 4.0% | 2818.2 ± 1.4% | 303.2 ± 1.9% | 3015.1 ± 1.8% | 569.9 ± 2.8% | 1.944 | 2.368 | 22.004 | 2.213 | 11.708 |
| string: silesia/nci | 1075110 | 5428.0 ± 0.8% | 3880.1 ± 0.3% | 2993.3 ± 0.6% | 562.6 ± 1.5% | 3616.6 ± 0.8% | 553.6 ± 2.1% | 1.399 | 1.813 | 9.648 | 1.501 | 9.805 |
| string: silesia/reymont | 1075159 | 3471.7 ± 3.0% | 3375.7 ± 0.5% | 1954.3 ± 1.0% | 325.6 ± 1.4% | 2088.7 ± 0.7% | 476.3 ± 4.2% | 1.028 | 1.776 | 10.663 | 1.662 | 7.289 |
| string: silesia/samba | 97582 | 3990.0 ± 1.0% | 3760.5 ± 0.5% | 3093.7 ± 0.8% | 311.2 ± 1.0% | 1947.1 ± 1.9% | 419.1 ± 1.0% | 1.061 | 1.290 | 12.820 | 2.049 | 9.521 |
| string: silesia/webster | 1098490 | 4438.5 ± 1.5% | 2428.2 ± 0.5% | 1731.9 ± 2.5% | 305.2 ± 0.4% | 2058.9 ± 0.4% | 464.1 ± 2.7% | 1.828 | 2.563 | 14.543 | 2.156 | 9.564 |
| string: silesia/xml | 1090118 | 6088.7 ± 0.4% | 4974.9 ± 0.2% | 2448.3 ± 0.3% | 458.3 ± 0.6% | 3307.7 ± 0.2% | 539.8 ± 1.1% | 1.224 | 2.487 | 13.286 | 1.841 | 11.279 |
| string: canterbury/alice29.txt | 159425 | 5763.3 ± 0.6% | 2729.2 ± 0.6% | 2850.4 ± 1.3% | 288.6 ± 0.7% | 2722.9 ± 2.1% | 518.3 ± 0.9% | 2.112 | 2.022 | 19.967 | 2.117 | 11.120 |
| string: canterbury/asyoulik.txt | 132198 | 4306.2 ± 0.6% | 2625.7 ± 0.3% | 2760.6 ± 0.8% | 294.8 ± 1.1% | 2386.4 ± 1.0% | 454.5 ± 1.7% | 1.640 | 1.560 | 14.606 | 1.804 | 9.476 |
| string: canterbury/lcet10.txt | 441884 | 6707.5 ± 0.4% | 3285.8 ± 0.3% | 2301.4 ± 0.3% | 323.6 ± 1.5% | 2760.4 ± 0.5% | 570.5 ± 0.5% | 2.041 | 2.915 | 20.728 | 2.430 | 11.757 |
| string: canterbury/plrabn12.txt | 503330 | 5461.1 ± 1.1% | 3162.9 ± 1.2% | 1817.8 ± 0.9% | 301.1 ± 0.8% | 2803.6 ± 2.0% | 530.6 ± 0.9% | 1.727 | 3.004 | 18.136 | 1.948 | 10.292 |
| string: canterbury-large/E.coli | 1048578 | 33849.6 ± 0.7% | 13412.7 ± 1.3% | 3388.2 ± 0.8% | 1156.0 ± 6.0% | 8898.0 ± 0.8% | 931.0 ± 2.8% | 2.524 | 9.991 | 29.281 | 3.804 | 36.358 |
| string: canterbury-large/bible.txt | 1055886 | 8557.5 ± 0.8% | 5249.1 ± 1.2% | 2761.7 ± 0.7% | 332.2 ± 0.7% | 3865.8 ± 0.9% | 614.1 ± 3.6% | 1.630 | 3.099 | 25.762 | 2.214 | 13.935 |
| string: canterbury-large/world192.txt | 1103121 | 4147.8 ± 1.5% | 2293.4 ± 1.0% | 1772.5 ± 1.3% | 312.2 ± 1.1% | 2111.6 ± 1.2% | 462.5 ± 1.7% | 1.809 | 2.340 | 13.286 | 1.964 | 8.969 |
| string: http/html-1m | 1058582 | 9623.0 ± 2.9% | 4762.5 ± 1.9% | 2656.6 ± 0.8% | 385.4 ± 1.1% | 3630.7 ± 0.8% | 589.7 ± 7.2% | 2.021 | 3.622 | 24.969 | 2.650 | 16.319 |
| string: http/json-1m | 1190272 | 3301.9 ± 0.8% | 1246.7 ± 0.8% | 2085.1 ± 2.8% | 400.6 ± 4.6% | 1342.6 ± 0.6% | 438.0 ± 1.4% | 2.649 | 1.584 | 8.242 | 2.459 | 7.538 |
| string: http/js-1m | 1144362 | 2877.5 ± 0.2% | 1612.5 ± 0.1% | 1333.4 ± 0.3% | 304.1 ± 3.8% | 1420.7 ± 0.6% | 379.8 ± 1.6% | 1.784 | 2.158 | 9.461 | 2.025 | 7.576 |
| string: http/css-1m | 1097820 | 3318.3 ± 0.8% | 2892.6 ± 0.4% | 2274.0 ± 0.8% | 401.7 ± 1.7% | 2068.0 ± 0.5% | 439.3 ± 1.7% | 1.147 | 1.459 | 8.260 | 1.605 | 7.554 |
| string: dickens as Cyrillic and CJK | 1883069 | 5834.5 ± 1.0% | 3040.8 ± 2.8% | 659.9 ± 1.0% | 323.8 ± 0.6% | 512.1 ± 0.9% | 162.5 ± 5.7% | 1.919 | 8.842 | 18.017 | 11.394 | 35.900 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1213.5 ± 0.7% | 1243.7 ± 1.4% | 1100.3 ± 1.1% | 234.8 ± 0.9% | 476.0 ± 0.7% | 225.1 ± 4.7% | 0.976 | 1.103 | 5.168 | 2.549 | 5.391 |
| hex: silesia/dickens | 524290 | 33918.7 ± 0.3% | 15084.7 ± 0.5% | 3555.6 ± 0.3% | 452.0 ± 0.5% | 8910.5 ± 0.7% | 1139.3 ± 3.8% | 2.249 | 9.540 | 75.035 | 3.807 | 29.770 |
| hex: silesia/mozilla | 524290 | 33766.7 ± 0.8% | 14944.1 ± 2.6% | 3473.2 ± 0.8% | 415.1 ± 2.0% | 8862.1 ± 1.0% | 1135.7 ± 1.2% | 2.260 | 9.722 | 81.349 | 3.810 | 29.732 |
| hex: silesia/mr | 524290 | 33855.5 ± 0.4% | 15063.0 ± 1.3% | 3483.0 ± 0.4% | 621.1 ± 3.4% | 8882.8 ± 0.4% | 1139.6 ± 0.6% | 2.248 | 9.720 | 54.507 | 3.811 | 29.708 |
| hex: silesia/nci | 524290 | 33825.9 ± 0.7% | 15042.4 ± 0.8% | 3499.7 ± 3.1% | 712.6 ± 1.9% | 8916.0 ± 1.3% | 1137.2 ± 5.4% | 2.249 | 9.665 | 47.468 | 3.794 | 29.744 |
| hex: silesia/ooffice | 524290 | 33794.2 ± 0.9% | 15027.5 ± 0.6% | 3484.5 ± 0.5% | 332.2 ± 0.4% | 8907.6 ± 0.3% | 1139.9 ± 0.9% | 2.249 | 9.698 | 101.734 | 3.794 | 29.646 |
| hex: silesia/osdb | 524290 | 33789.4 ± 0.5% | 14996.6 ± 0.8% | 3481.5 ± 0.8% | 428.0 ± 0.4% | 8872.1 ± 0.9% | 1136.1 ± 0.2% | 2.253 | 9.705 | 78.947 | 3.809 | 29.743 |
| hex: silesia/reymont | 524290 | 33973.5 ± 0.5% | 15124.0 ± 0.4% | 3552.9 ± 0.2% | 459.4 ± 0.8% | 8941.0 ± 0.1% | 1144.5 ± 0.7% | 2.246 | 9.562 | 73.956 | 3.800 | 29.684 |
| hex: silesia/samba | 524290 | 33866.5 ± 0.4% | 15058.7 ± 0.6% | 3489.9 ± 0.6% | 344.7 ± 0.5% | 8862.5 ± 4.8% | 1138.4 ± 0.8% | 2.249 | 9.704 | 98.261 | 3.821 | 29.748 |
| hex: silesia/sao | 524290 | 33829.6 ± 0.6% | 14939.3 ± 4.1% | 3471.1 ± 0.6% | 274.3 ± 0.7% | 8831.6 ± 0.8% | 1131.5 ± 0.8% | 2.264 | 9.746 | 123.326 | 3.831 | 29.897 |
| hex: silesia/webster | 524290 | 33820.4 ± 1.1% | 14972.8 ± 1.2% | 3533.8 ± 1.2% | 416.3 ± 1.9% | 8865.1 ± 0.8% | 1132.7 ± 1.1% | 2.259 | 9.570 | 81.233 | 3.815 | 29.858 |
| hex: silesia/x-ray | 524290 | 33893.2 ± 5.2% | 15005.9 ± 1.0% | 3491.7 ± 3.5% | 409.6 ± 0.9% | 8844.6 ± 0.7% | 1130.2 ± 1.1% | 2.259 | 9.707 | 82.745 | 3.832 | 29.989 |
| hex: silesia/xml | 524290 | 33723.5 ± 0.7% | 14957.5 ± 3.2% | 3542.6 ± 1.0% | 526.1 ± 0.8% | 8851.5 ± 4.8% | 1129.8 ± 0.8% | 2.255 | 9.519 | 64.107 | 3.810 | 29.848 |
| hex: canterbury/alice29.txt | 304180 | 33583.8 ± 0.6% | 14115.1 ± 2.4% | 3546.5 ± 2.9% | 457.7 ± 0.9% | 8865.9 ± 0.4% | 1141.4 ± 0.8% | 2.379 | 9.470 | 73.375 | 3.788 | 29.424 |
| hex: canterbury/asyoulik.txt | 250360 | 33723.5 ± 0.4% | 14972.5 ± 0.7% | 3486.0 ± 0.5% | 443.7 ± 0.3% | 8838.6 ± 5.0% | 1143.6 ± 0.7% | 2.252 | 9.674 | 76.002 | 3.815 | 29.489 |
| hex: canterbury/cp.html | 49208 | 33222.7 ± 0.4% | 14378.1 ± 0.4% | 3549.1 ± 0.5% | 434.8 ± 0.6% | 9198.4 ± 4.0% | 1113.3 ± 1.1% | 2.311 | 9.361 | 76.408 | 3.612 | 29.841 |
| hex: canterbury/fields.c | 22302 | 32754.5 ± 0.4% | 17524.1 ± 1.0% | 3651.1 ± 0.6% | 473.8 ± 1.4% | 9177.0 ± 0.5% | 1099.1 ± 3.3% | 1.869 | 8.971 | 69.130 | 3.569 | 29.802 |
| hex: canterbury/grammar.lsp | 7444 | 29684.8 ± 0.8% | 17121.5 ± 0.9% | 3595.7 ± 1.1% | 584.4 ± 0.7% | 8895.8 ± 1.3% | 1055.9 ± 1.8% | 1.734 | 8.256 | 50.794 | 3.337 | 28.113 |
| hex: canterbury/kennedy.xls | 524290 | 33769.3 ± 1.1% | 14960.9 ± 0.7% | 3540.0 ± 0.8% | 692.9 ± 0.9% | 8877.5 ± 1.1% | 1115.5 ± 4.4% | 2.257 | 9.539 | 48.739 | 3.804 | 30.274 |
| hex: canterbury/lcet10.txt | 524290 | 33787.5 ± 0.7% | 14979.9 ± 0.8% | 3532.2 ± 3.0% | 457.9 ± 0.4% | 8848.4 ± 0.8% | 1124.5 ± 4.2% | 2.256 | 9.566 | 73.793 | 3.818 | 30.046 |
| hex: canterbury/plrabn12.txt | 524290 | 33824.7 ± 1.0% | 15075.8 ± 1.0% | 3544.5 ± 3.5% | 441.6 ± 0.8% | 8873.7 ± 0.7% | 1121.8 ± 3.6% | 2.244 | 9.543 | 76.587 | 3.812 | 30.151 |
| hex: canterbury/ptt5 | 524290 | 33918.5 ± 0.5% | 15054.4 ± 1.2% | 3484.1 ± 1.4% | 653.0 ± 1.0% | 8883.1 ± 0.9% | 1127.3 ± 5.1% | 2.253 | 9.735 | 51.942 | 3.818 | 30.089 |
| hex: canterbury/sum | 76482 | 33064.8 ± 0.7% | 15315.4 ± 0.5% | 3536.3 ± 0.4% | 531.1 ± 0.4% | 8802.1 ± 0.5% | 1122.2 ± 2.6% | 2.159 | 9.350 | 62.258 | 3.756 | 29.464 |
| hex: canterbury/xargs.1 | 8456 | 30177.4 ± 3.8% | 17375.2 ± 0.9% | 3567.3 ± 0.7% | 556.1 ± 1.5% | 8936.1 ± 0.6% | 1105.1 ± 1.4% | 1.737 | 8.459 | 54.262 | 3.377 | 27.306 |
| hex: canterbury-large/E.coli | 524290 | 33674.5 ± 0.7% | 14992.7 ± 0.8% | 3467.0 ± 0.6% | 956.6 ± 0.7% | 8875.7 ± 0.4% | 1108.8 ± 4.8% | 2.246 | 9.713 | 35.204 | 3.794 | 30.370 |
| hex: canterbury-large/bible.txt | 524290 | 33793.6 ± 0.4% | 14995.2 ± 0.5% | 3483.7 ± 0.9% | 471.4 ± 0.5% | 8867.5 ± 5.1% | 1130.5 ± 2.2% | 2.254 | 9.701 | 71.689 | 3.811 | 29.893 |
| hex: canterbury-large/world192.txt | 524290 | 33927.9 ± 0.5% | 15044.2 ± 0.8% | 3552.8 ± 0.8% | 438.8 ± 0.8% | 8905.7 ± 1.1% | 1135.1 ± 2.9% | 2.255 | 9.550 | 77.324 | 3.810 | 29.888 |
| hex: http/html-1kx1024 | 2099200 | 14835.6 ± 1.8% | 12257.0 ± 8.7% | 3177.6 ± 2.0% | 462.6 ± 0.2% | 7405.9 ± 1.2% | 971.8 ± 2.1% | 1.210 | 4.669 | 32.069 | 2.003 | 15.266 |
| hex: http/html-16kx64 | 2097280 | 27753.2 ± 3.4% | 14004.7 ± 3.7% | 3388.8 ± 1.4% | 458.1 ± 2.0% | 8521.1 ± 8.0% | 1067.9 ± 3.2% | 1.982 | 8.190 | 60.588 | 3.257 | 25.988 |
| hex: http/html-1m | 524290 | 33706.5 ± 1.0% | 15045.5 ± 0.6% | 3475.7 ± 3.8% | 445.9 ± 2.7% | 8876.7 ± 3.5% | 1114.3 ± 7.4% | 2.240 | 9.698 | 75.585 | 3.797 | 30.248 |
| hex: http/json-1kx1024 | 2099200 | 14923.5 ± 0.4% | 12366.8 ± 1.3% | 3180.9 ± 1.2% | 623.4 ± 0.8% | 7410.2 ± 0.8% | 971.2 ± 5.0% | 1.207 | 4.692 | 23.939 | 2.014 | 15.365 |
| hex: http/json-16kx64 | 2097280 | 27757.6 ± 0.1% | 13970.4 ± 2.4% | 3427.5 ± 3.2% | 628.8 ± 0.4% | 8635.9 ± 0.8% | 1087.9 ± 4.3% | 1.987 | 8.099 | 44.141 | 3.214 | 25.515 |
| hex: http/json-1m | 524290 | 33975.0 ± 0.3% | 15125.7 ± 1.1% | 3569.7 ± 0.2% | 600.1 ± 1.4% | 8925.9 ± 0.2% | 1121.3 ± 3.9% | 2.246 | 9.518 | 56.618 | 3.806 | 30.299 |
| hex: http/js-1kx1024 | 2099200 | 15034.7 ± 0.6% | 11854.8 ± 0.6% | 3194.9 ± 1.0% | 456.3 ± 0.8% | 7331.1 ± 4.5% | 975.0 ± 1.6% | 1.268 | 4.706 | 32.950 | 2.051 | 15.420 |
| hex: http/js-16kx64 | 2097280 | 27442.6 ± 0.3% | 13984.2 ± 2.6% | 3414.1 ± 0.3% | 458.6 ± 0.5% | 8188.6 ± 0.6% | 1088.2 ± 2.1% | 1.962 | 8.038 | 59.841 | 3.351 | 25.219 |
| hex: http/js-1m | 524290 | 33887.8 ± 4.3% | 15053.9 ± 0.8% | 3562.3 ± 0.8% | 451.7 ± 2.4% | 8915.8 ± 0.8% | 1131.6 ± 1.7% | 2.251 | 9.513 | 75.028 | 3.801 | 29.946 |
| hex: http/css-1kx1024 | 2099200 | 15052.3 ± 1.4% | 12063.7 ± 0.6% | 3174.0 ± 1.1% | 503.5 ± 1.5% | 7354.2 ± 3.7% | 970.1 ± 1.8% | 1.248 | 4.742 | 29.897 | 2.047 | 15.516 |
| hex: http/css-16kx64 | 2097280 | 27620.5 ± 2.4% | 13861.3 ± 2.5% | 3400.0 ± 3.4% | 506.9 ± 0.6% | 8525.9 ± 0.7% | 1082.7 ± 1.3% | 1.993 | 8.124 | 54.492 | 3.240 | 25.510 |
| hex: http/css-1m | 524290 | 33827.1 ± 1.5% | 15011.5 ± 1.2% | 3564.3 ± 1.0% | 454.4 ± 1.5% | 8876.6 ± 0.6% | 1108.1 ± 4.7% | 2.253 | 9.491 | 74.443 | 3.811 | 30.527 |
| hex: shuffled/dickens-1m | 524290 | 33921.7 ± 0.4% | 15139.8 ± 0.6% | 3492.8 ± 0.3% | 453.4 ± 0.3% | 8906.0 ± 0.3% | 1128.3 ± 1.3% | 2.241 | 9.712 | 74.809 | 3.809 | 30.064 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1588.9 ± 2.1% | 1488.6 ± 1.2% | 1032.3 ± 0.9% | 459.4 ± 0.2% | 470.7 ± 1.9% | 502.4 ± 1.1% | 1.067 | 1.539 | 3.459 | 3.376 | 3.162 |
| qlog records, JSON text sequence | 1467503 | 1444.5 ± 0.6% | 1244.3 ± 3.1% | 941.7 ± 4.4% | 423.2 ± 1.2% | 570.3 ± 2.5% | 348.1 ± 1.4% | 1.161 | 1.534 | 3.413 | 2.533 | 4.150 |
| messages: 11 string members | 1025025 | 1272.7 ± 0.6% | 1107.6 ± 1.6% | 771.4 ± 1.1% | 410.3 ± 2.7% | 442.3 ± 3.3% | 428.6 ± 4.1% | 1.149 | 1.650 | 3.102 | 2.878 | 2.969 |
| messages: 50 nested objects | 1121600 | 1708.4 ± 4.8% | 1880.6 ± 1.2% | 1347.7 ± 1.0% | 588.1 ± 0.9% | 653.6 ± 1.6% | 518.4 ± 5.1% | 0.908 | 1.268 | 2.905 | 2.614 | 3.296 |
| string: silesia/dickens | 172528 | 12983.6 ± 0.9% | 3946.3 ± 0.8% | 3061.0 ± 2.9% | 331.3 ± 0.5% | 1692.1 ± 0.8% | 1175.8 ± 0.7% | 3.290 | 4.242 | 39.188 | 7.673 | 11.043 |
| string: silesia/nci | 1075110 | 11199.1 ± 1.4% | 4671.0 ± 6.1% | 3106.0 ± 0.9% | 909.2 ± 0.7% | 1886.3 ± 1.3% | 1198.5 ± 0.2% | 2.398 | 3.606 | 12.318 | 5.937 | 9.344 |
| string: silesia/reymont | 1075159 | 5385.1 ± 1.0% | 1852.8 ± 2.1% | 1891.4 ± 0.5% | 379.3 ± 1.8% | 1436.5 ± 0.7% | 1040.7 ± 0.9% | 2.906 | 2.847 | 14.197 | 3.749 | 5.175 |
| string: silesia/samba | 97582 | 6351.7 ± 0.4% | 2710.0 ± 0.7% | 4070.3 ± 0.8% | 349.1 ± 0.6% | 1327.5 ± 1.6% | 1173.6 ± 0.3% | 2.344 | 1.560 | 18.193 | 4.785 | 5.412 |
| string: silesia/webster | 1098490 | 7132.6 ± 1.2% | 1979.1 ± 0.6% | 1776.8 ± 1.6% | 351.5 ± 0.7% | 1406.5 ± 1.1% | 603.3 ± 0.8% | 3.604 | 4.014 | 20.294 | 5.071 | 11.823 |
| string: silesia/xml | 1090118 | 10820.5 ± 0.7% | 3193.1 ± 0.8% | 2515.2 ± 0.6% | 603.5 ± 0.6% | 1930.8 ± 1.0% | 954.4 ± 0.8% | 3.389 | 4.302 | 17.929 | 5.604 | 11.337 |
| string: canterbury/alice29.txt | 159425 | 12739.8 ± 0.6% | 2891.5 ± 2.9% | 2998.2 ± 1.6% | 316.9 ± 1.1% | 1512.7 ± 5.4% | 1088.1 ± 0.7% | 4.406 | 4.249 | 40.208 | 8.422 | 11.709 |
| string: canterbury/asyoulik.txt | 132198 | 11157.9 ± 1.4% | 2093.9 ± 1.4% | 3081.6 ± 3.5% | 314.3 ± 1.5% | 1353.8 ± 1.2% | 958.1 ± 1.0% | 5.329 | 3.621 | 35.500 | 8.242 | 11.646 |
| string: canterbury/lcet10.txt | 441884 | 12564.0 ± 1.6% | 3090.8 ± 1.1% | 2540.7 ± 0.6% | 367.9 ± 1.2% | 1657.8 ± 1.4% | 1192.7 ± 4.1% | 4.065 | 4.945 | 34.147 | 7.579 | 10.534 |
| string: canterbury/plrabn12.txt | 503330 | 9003.9 ± 2.4% | 2301.4 ± 0.3% | 2084.3 ± 1.4% | 346.1 ± 1.3% | 1596.0 ± 0.9% | 1109.6 ± 1.4% | 3.912 | 4.320 | 26.012 | 5.641 | 8.114 |
| string: canterbury-large/E.coli | 1048578 | 31377.8 ± 0.7% | 16092.9 ± 1.7% | 3480.1 ± 0.9% | 1690.9 ± 0.5% | 3135.2 ± 0.4% | 1413.5 ± 0.6% | 1.950 | 9.016 | 18.557 | 10.008 | 22.198 |
| string: canterbury-large/bible.txt | 1055886 | 9728.5 ± 0.3% | 4886.0 ± 1.1% | 2997.3 ± 0.4% | 404.4 ± 1.7% | 2213.9 ± 0.8% | 1489.9 ± 0.7% | 1.991 | 3.246 | 24.057 | 4.394 | 6.529 |
| string: canterbury-large/world192.txt | 1103121 | 6656.4 ± 1.1% | 1725.5 ± 1.3% | 1887.4 ± 3.4% | 345.3 ± 0.8% | 1384.8 ± 0.9% | 961.2 ± 0.8% | 3.858 | 3.527 | 19.277 | 4.807 | 6.925 |
| string: http/html-1m | 1058582 | 10126.2 ± 1.0% | 4377.4 ± 1.1% | 2869.3 ± 0.6% | 417.7 ± 0.9% | 2152.1 ± 0.7% | 844.5 ± 1.3% | 2.313 | 3.529 | 24.241 | 4.705 | 11.991 |
| string: http/json-1m | 1190272 | 8616.5 ± 0.6% | 1574.3 ± 1.1% | 1566.3 ± 0.5% | 554.9 ± 1.2% | 1172.8 ± 0.6% | 850.6 ± 1.4% | 5.473 | 5.501 | 15.528 | 7.347 | 10.130 |
| string: http/js-1m | 1144362 | 6520.1 ± 0.6% | 1112.4 ± 0.6% | 1393.2 ± 0.8% | 330.8 ± 1.3% | 1110.5 ± 0.8% | 758.5 ± 0.5% | 5.861 | 4.680 | 19.711 | 5.871 | 8.596 |
| string: http/css-1m | 1097820 | 9322.5 ± 1.0% | 1488.1 ± 0.8% | 2281.6 ± 1.1% | 508.0 ± 0.3% | 1262.7 ± 0.7% | 875.9 ± 1.6% | 6.265 | 4.086 | 18.351 | 7.383 | 10.643 |
| string: dickens as Cyrillic and CJK | 1883069 | 5488.9 ± 0.9% | 3633.0 ± 1.1% | 486.9 ± 0.7% | 246.5 ± 0.2% | 464.4 ± 1.1% | 355.3 ± 0.6% | 1.511 | 11.274 | 22.264 | 11.819 | 15.449 |
| hex: silesia/dickens | 524290 | 43295.7 ± 1.5% | 2577.6 ± 0.7% | 1496.2 ± 0.4% | 460.7 ± 0.5% | 1567.8 ± 0.5% | 1064.1 ± 0.4% | 16.797 | 28.936 | 93.972 | 27.616 | 40.687 |
| hex: silesia/mozilla | 524290 | 43336.4 ± 0.6% | 2580.3 ± 1.6% | 1494.5 ± 0.7% | 388.4 ± 2.4% | 1567.0 ± 0.3% | 1065.4 ± 0.6% | 16.795 | 28.998 | 111.574 | 27.655 | 40.675 |
| hex: silesia/mr | 524290 | 43548.0 ± 0.6% | 2566.3 ± 1.0% | 1500.4 ± 0.4% | 597.4 ± 0.8% | 1565.0 ± 0.8% | 1066.3 ± 0.7% | 16.969 | 29.024 | 72.900 | 27.827 | 40.840 |
| hex: silesia/nci | 524290 | 42912.3 ± 1.2% | 2557.3 ± 0.7% | 1491.2 ± 1.3% | 755.9 ± 1.5% | 1561.2 ± 0.9% | 1060.4 ± 1.4% | 16.780 | 28.777 | 56.769 | 27.487 | 40.467 |
| hex: silesia/ooffice | 524290 | 42921.1 ± 1.2% | 2600.3 ± 0.9% | 1507.3 ± 1.1% | 323.3 ± 1.1% | 1566.4 ± 0.9% | 1062.0 ± 0.9% | 16.506 | 28.476 | 132.758 | 27.401 | 40.416 |
| hex: silesia/osdb | 524290 | 43466.8 ± 1.5% | 2595.8 ± 0.8% | 1504.2 ± 0.7% | 429.7 ± 0.6% | 1577.7 ± 0.4% | 1068.6 ± 0.7% | 16.745 | 28.897 | 101.166 | 27.551 | 40.676 |
| hex: silesia/reymont | 524290 | 43527.7 ± 1.2% | 2589.8 ± 1.3% | 1504.6 ± 0.7% | 481.6 ± 0.8% | 1571.7 ± 0.7% | 1067.8 ± 1.2% | 16.808 | 28.929 | 90.380 | 27.695 | 40.765 |
| hex: silesia/samba | 524290 | 43117.0 ± 1.2% | 2577.4 ± 0.8% | 1496.2 ± 0.4% | 333.0 ± 1.6% | 1571.8 ± 0.7% | 1064.8 ± 1.2% | 16.729 | 28.818 | 129.465 | 27.432 | 40.495 |
| hex: silesia/sao | 524290 | 43534.3 ± 1.4% | 2594.1 ± 1.0% | 1504.8 ± 0.5% | 270.0 ± 3.2% | 1573.0 ± 0.5% | 1063.6 ± 0.7% | 16.782 | 28.931 | 161.243 | 27.676 | 40.930 |
| hex: silesia/webster | 524290 | 43713.9 ± 0.3% | 2596.4 ± 0.6% | 1504.0 ± 2.1% | 433.7 ± 0.6% | 1571.0 ± 0.5% | 1068.7 ± 2.9% | 16.836 | 29.065 | 100.790 | 27.826 | 40.905 |
| hex: silesia/x-ray | 524290 | 43249.4 ± 1.4% | 2577.0 ± 0.6% | 1501.2 ± 0.4% | 421.8 ± 0.9% | 1567.9 ± 0.9% | 1063.4 ± 0.7% | 16.783 | 28.810 | 102.534 | 27.584 | 40.670 |
| hex: silesia/xml | 524290 | 42694.8 ± 4.5% | 2582.8 ± 1.2% | 1498.2 ± 1.1% | 687.2 ± 1.1% | 1564.6 ± 0.9% | 1064.5 ± 1.0% | 16.530 | 28.498 | 62.131 | 27.289 | 40.109 |
| hex: canterbury/alice29.txt | 304180 | 42883.4 ± 1.2% | 2598.4 ± 0.6% | 1516.0 ± 0.2% | 465.2 ± 0.9% | 1582.7 ± 0.7% | 1083.2 ± 5.5% | 16.503 | 28.286 | 92.184 | 27.095 | 39.588 |
| hex: canterbury/asyoulik.txt | 250360 | 42803.2 ± 1.5% | 2607.5 ± 0.6% | 1533.8 ± 1.2% | 456.1 ± 0.5% | 1583.3 ± 1.6% | 1082.9 ± 0.7% | 16.416 | 27.906 | 93.842 | 27.035 | 39.526 |
| hex: canterbury/cp.html | 49208 | 42231.5 ± 0.6% | 2581.7 ± 6.4% | 1516.8 ± 0.5% | 480.0 ± 1.4% | 1585.7 ± 0.8% | 1082.9 ± 8.2% | 16.358 | 27.842 | 87.976 | 26.634 | 38.999 |
| hex: canterbury/fields.c | 22302 | 42107.7 ± 4.6% | 2630.5 ± 1.6% | 1529.1 ± 7.3% | 597.1 ± 0.9% | 1601.0 ± 0.5% | 1092.4 ± 0.9% | 16.007 | 27.538 | 70.524 | 26.302 | 38.546 |
| hex: canterbury/grammar.lsp | 7444 | 40011.4 ± 8.8% | 2690.0 ± 0.7% | 1547.5 ± 1.2% | 810.6 ± 0.6% | 1603.7 ± 0.6% | 1100.1 ± 0.9% | 14.874 | 25.856 | 49.361 | 24.949 | 36.369 |
| hex: canterbury/kennedy.xls | 524290 | 43649.3 ± 0.3% | 2571.5 ± 0.6% | 1502.2 ± 0.3% | 776.6 ± 0.4% | 1530.5 ± 0.2% | 1071.3 ± 0.4% | 16.974 | 29.058 | 56.206 | 28.519 | 40.745 |
| hex: canterbury/lcet10.txt | 524290 | 42934.9 ± 2.0% | 2574.3 ± 1.3% | 1498.2 ± 0.9% | 458.7 ± 0.7% | 1482.7 ± 0.5% | 1061.8 ± 0.7% | 16.678 | 28.658 | 93.603 | 28.958 | 40.437 |
| hex: canterbury/plrabn12.txt | 524290 | 42474.1 ± 0.9% | 2586.4 ± 0.7% | 1501.8 ± 0.7% | 450.5 ± 0.7% | 1543.5 ± 0.5% | 1058.3 ± 1.0% | 16.422 | 28.283 | 94.286 | 27.519 | 40.133 |
| hex: canterbury/ptt5 | 524290 | 43379.1 ± 0.8% | 2580.5 ± 0.5% | 1495.0 ± 1.0% | 582.2 ± 0.9% | 1484.6 ± 0.7% | 1066.4 ± 0.4% | 16.810 | 29.016 | 74.509 | 29.220 | 40.677 |
| hex: canterbury/sum | 76482 | 42883.9 ± 3.0% | 2594.6 ± 0.8% | 1515.9 ± 0.4% | 560.2 ± 0.6% | 1582.8 ± 0.4% | 1086.8 ± 3.9% | 16.528 | 28.289 | 76.552 | 27.094 | 39.458 |
| hex: canterbury/xargs.1 | 8456 | 40958.6 ± 0.8% | 2677.4 ± 1.2% | 1553.0 ± 0.3% | 837.8 ± 0.3% | 1611.6 ± 0.6% | 1108.9 ± 0.9% | 15.298 | 26.373 | 48.886 | 25.416 | 36.937 |
| hex: canterbury-large/E.coli | 524290 | 43544.2 ± 0.5% | 2585.4 ± 0.4% | 1505.2 ± 0.2% | 816.3 ± 0.6% | 1568.6 ± 5.9% | 1069.1 ± 6.4% | 16.842 | 28.929 | 53.340 | 27.759 | 40.729 |
| hex: canterbury-large/bible.txt | 524290 | 43590.3 ± 0.8% | 2585.4 ± 6.0% | 1502.1 ± 1.9% | 477.2 ± 0.5% | 1524.5 ± 5.7% | 1067.8 ± 0.9% | 16.860 | 29.019 | 91.347 | 28.593 | 40.823 |
| hex: canterbury-large/world192.txt | 524290 | 43693.9 ± 0.8% | 2599.8 ± 0.7% | 1505.5 ± 5.4% | 459.2 ± 0.6% | 1575.1 ± 0.3% | 1069.5 ± 0.4% | 16.806 | 29.022 | 95.145 | 27.740 | 40.855 |
| hex: http/html-1kx1024 | 2099200 | 20722.9 ± 0.3% | 2334.8 ± 1.3% | 1458.3 ± 1.0% | 500.3 ± 0.5% | 1494.6 ± 5.6% | 1076.8 ± 1.0% | 8.876 | 14.210 | 41.421 | 13.866 | 19.246 |
| hex: http/html-16kx64 | 2097280 | 21316.4 ± 0.2% | 2246.8 ± 6.2% | 1456.6 ± 0.3% | 504.8 ± 0.4% | 1474.3 ± 1.7% | 1082.2 ± 3.9% | 9.488 | 14.634 | 42.230 | 14.459 | 19.697 |
| hex: http/html-1m | 524290 | 43688.4 ± 0.5% | 2593.1 ± 0.5% | 1506.9 ± 0.3% | 487.2 ± 0.3% | 1531.8 ± 1.0% | 1068.9 ± 0.4% | 16.848 | 28.991 | 89.677 | 28.521 | 40.871 |
| hex: http/json-1kx1024 | 2099200 | 20729.0 ± 0.2% | 2315.7 ± 1.7% | 1457.5 ± 0.3% | 697.2 ± 0.1% | 1487.1 ± 1.9% | 1077.3 ± 0.6% | 8.951 | 14.223 | 29.733 | 13.939 | 19.241 |
| hex: http/json-16kx64 | 2097280 | 22064.3 ± 0.7% | 2240.1 ± 0.2% | 1453.4 ± 0.3% | 707.3 ± 0.3% | 1473.9 ± 0.3% | 1087.3 ± 0.4% | 9.850 | 15.181 | 31.195 | 14.970 | 20.293 |
| hex: http/json-1m | 524290 | 43033.3 ± 1.6% | 2586.2 ± 1.3% | 1501.4 ± 0.5% | 722.1 ± 4.0% | 1525.8 ± 0.9% | 1061.5 ± 0.9% | 16.639 | 28.662 | 59.592 | 28.204 | 40.539 |
| hex: http/js-1kx1024 | 2099200 | 20327.8 ± 0.4% | 2320.2 ± 1.1% | 1457.8 ± 5.5% | 487.8 ± 0.6% | 1497.4 ± 0.6% | 1069.7 ± 2.5% | 8.761 | 13.944 | 41.669 | 13.575 | 19.003 |
| hex: http/js-16kx64 | 2097280 | 21798.2 ± 0.4% | 2226.2 ± 0.8% | 1448.2 ± 0.9% | 490.5 ± 1.0% | 1466.6 ± 0.9% | 1079.7 ± 1.1% | 9.792 | 15.052 | 44.444 | 14.863 | 20.189 |
| hex: http/js-1m | 524290 | 43094.2 ± 0.5% | 2580.9 ± 0.7% | 1497.6 ± 1.7% | 505.2 ± 0.7% | 1566.5 ± 4.2% | 1060.8 ± 1.3% | 16.697 | 28.775 | 85.298 | 27.510 | 40.624 |
| hex: http/css-1kx1024 | 2099200 | 20432.1 ± 0.9% | 2332.4 ± 0.9% | 1449.9 ± 4.4% | 552.4 ± 1.0% | 1485.6 ± 0.8% | 1065.9 ± 1.0% | 8.760 | 14.092 | 36.989 | 13.754 | 19.169 |
| hex: http/css-16kx64 | 2097280 | 21756.6 ± 0.4% | 2220.4 ± 1.5% | 1445.8 ± 0.6% | 560.0 ± 0.7% | 1459.0 ± 0.6% | 1075.1 ± 0.7% | 9.799 | 15.048 | 38.853 | 14.912 | 20.238 |
| hex: http/css-1m | 524290 | 43022.4 ± 1.4% | 2577.1 ± 1.0% | 1501.1 ± 1.6% | 532.6 ± 0.5% | 1558.9 ± 0.5% | 1059.9 ± 0.7% | 16.694 | 28.660 | 80.783 | 27.597 | 40.591 |
| hex: shuffled/dickens-1m | 524290 | 43396.8 ± 1.9% | 2590.3 ± 0.9% | 1501.0 ± 0.6% | 460.5 ± 0.7% | 1573.0 ± 0.7% | 1061.8 ± 0.5% | 16.754 | 28.911 | 94.235 | 27.589 | 40.870 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.916 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.892 of simdjson.
- messages: 11 string members, decoding: stdx runs at 0.535 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.774 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.920 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.765 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.831 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.905 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.475 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.712 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.846 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.852 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.930 of simdjson.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.513 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.755 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.897 of yyjson.
- messages: 50 nested objects, encoding through TextWriter's methods: stdx runs at 0.908 of simdjson.
