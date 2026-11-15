# bench-json

| Field | Value |
|---|---|
| Commit | 6e0508c |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.127.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1014-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43674617437 |
| Date | 2026-11-15 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1377.7 ± 0.3% | 0.489 | 1.025 | 1.066 | 1.069 | 0.410 | 1.070 | 1.068 | 0.371 | 0.834 | 0.929 | 0.105 |
| qlog records, JSON text sequence | 1467503 | 1076.0 ± 2.4% | 0.770 | 1.065 | 1.071 | 1.077 | 0.401 | 1.080 | 1.078 | 0.373 | 0.924 | 1.060 | 0.126 |
| messages: 11 string members | 1025025 | 1063.8 ± 1.1% | 0.583 | 1.000 | 1.013 | 1.031 | 0.546 | 1.014 | 1.025 | 0.544 | 0.886 | 0.963 | 0.138 |
| messages: 50 nested objects | 1121600 | 1332.5 ± 0.5% | 0.805 | 1.084 | 1.085 | 1.087 | 0.394 | 1.094 | 1.088 | 0.351 | 0.924 | 0.966 | 0.114 |
| messages: a tree of 341 objects | 612600 | 660.2 ± 1.1% | 0.823 | 1.047 | 1.033 | 1.033 | 0.265 | 1.028 | 1.032 | 0.221 | 0.830 | 0.983 | 0.118 |
| string: silesia/dickens | 172528 | 6681.9 ± 0.7% | 0.029 | 0.693 | 1.087 | 1.093 | 0.207 | 1.033 | 1.112 | 0.206 | 0.997 | 1.000 | 0.029 |
| string: silesia/nci | 1075110 | 5350.6 ± 0.8% | 0.036 | 0.728 | 1.034 | 1.035 | 0.311 | 1.038 | 1.035 | 0.311 | 1.005 | 1.009 | 0.036 |
| string: silesia/reymont | 1075159 | 3518.0 ± 1.1% | 0.055 | 0.626 | 0.867 | 0.869 | 0.353 | 0.820 | 0.874 | 0.352 | 0.993 | 1.000 | 0.055 |
| string: silesia/samba | 97582 | 3998.6 ± 0.6% | 0.041 | 0.909 | 1.061 | 1.061 | 0.075 | 0.855 | 1.061 | 0.074 | 1.002 | 1.002 | 0.041 |
| string: silesia/webster | 1098490 | 4409.2 ± 0.8% | 0.042 | 0.646 | 0.977 | 0.983 | 0.221 | 0.923 | 0.990 | 0.221 | 1.000 | 1.008 | 0.043 |
| string: silesia/xml | 1090118 | 6070.2 ± 0.3% | 0.032 | 0.778 | 0.959 | 0.966 | 0.249 | 0.958 | 0.971 | 0.249 | 1.001 | 1.006 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5701.6 ± 1.4% | 0.033 | 0.760 | 1.086 | 1.112 | 0.186 | 1.026 | 1.163 | 0.186 | 1.007 | 1.011 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 4264.9 ± 0.4% | 0.042 | 0.813 | 1.137 | 1.136 | 0.202 | 1.063 | 1.141 | 0.202 | 1.000 | 0.998 | 0.042 |
| string: canterbury/lcet10.txt | 441884 | 6618.5 ± 0.9% | 0.029 | 0.613 | 1.106 | 1.116 | 0.198 | 1.042 | 1.120 | 0.198 | 1.002 | 1.003 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 5481.6 ± 0.3% | 0.035 | 0.766 | 0.969 | 0.977 | 0.227 | 0.866 | 0.975 | 0.227 | 1.001 | 1.001 | 0.035 |
| string: canterbury-large/E.coli | 1048578 | 34040.9 ± 0.5% | 0.053 | 1.003 | 0.693 | 1.005 | 0.481 | 1.005 | 1.004 | 0.482 | 0.998 | 1.000 | 0.006 |
| string: canterbury-large/bible.txt | 1055886 | 8495.3 ± 1.3% | 0.024 | 0.622 | 0.875 | 0.880 | 0.400 | 0.886 | 0.899 | 0.401 | 1.006 | 1.014 | 0.024 |
| string: canterbury-large/world192.txt | 1103121 | 4130.2 ± 1.2% | 0.045 | 0.693 | 0.977 | 0.980 | 0.215 | 0.927 | 0.989 | 0.217 | 1.002 | 1.005 | 0.045 |
| string: http/html-1m | 1058582 | 9158.9 ± 1.4% | 0.022 | 0.559 | 0.777 | 0.781 | 0.317 | 0.744 | 0.790 | 0.317 | 0.918 | 1.009 | 0.022 |
| string: http/json-1m | 1190272 | 3343.5 ± 0.7% | 0.052 | 0.391 | 0.437 | 0.441 | 0.147 | 0.454 | 0.442 | 0.147 | 1.000 | 0.998 | 0.052 |
| string: http/js-1m | 1144362 | 2839.4 ± 0.9% | 0.062 | 0.703 | 0.899 | 0.924 | 0.191 | 0.851 | 0.926 | 0.192 | 1.004 | 1.006 | 0.062 |
| string: http/css-1m | 1097820 | 3291.8 ± 0.6% | 0.055 | 0.779 | 0.973 | 1.022 | 0.288 | 0.960 | 1.028 | 0.288 | 1.004 | 1.007 | 0.055 |
| string: dickens as Cyrillic and CJK | 1883069 | 5820.8 ± 0.4% | 0.025 | 0.062 | 0.444 | 0.446 | 0.198 | 0.444 | 0.445 | 0.198 | 1.002 | 1.001 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1201.9 ± 1.1% | 0.112 | 1.002 | 1.001 | 1.001 | 0.106 | 0.713 | 1.002 | 0.106 | 1.008 | 1.007 | 0.112 |
| hex: silesia/dickens | 524290 | 46893.6 ± 0.3% | 0.039 | 1.003 | 0.611 | 1.002 | 0.385 | 1.004 | 1.001 | 0.385 | 0.724 | 0.725 | 0.005 |
| hex: silesia/mozilla | 524290 | 47328.5 ± 0.1% | 0.039 | 1.000 | 0.606 | 0.999 | 0.381 | 1.003 | 0.999 | 0.381 | 0.718 | 0.718 | 0.004 |
| hex: silesia/mr | 524290 | 45874.0 ± 0.1% | 0.040 | 1.000 | 0.627 | 0.999 | 0.395 | 0.999 | 0.999 | 0.396 | 0.740 | 0.740 | 0.005 |
| hex: silesia/nci | 524290 | 41472.1 ± 0.7% | 0.044 | 1.002 | 0.614 | 1.001 | 0.421 | 1.000 | 1.001 | 0.422 | 0.818 | 0.818 | 0.005 |
| hex: silesia/ooffice | 524290 | 48693.8 ± 3.0% | 0.038 | 1.000 | 0.578 | 1.000 | 0.371 | 1.000 | 1.001 | 0.372 | 0.698 | 0.697 | 0.004 |
| hex: silesia/osdb | 524290 | 46542.8 ± 0.4% | 0.039 | 0.999 | 0.603 | 0.999 | 0.388 | 1.001 | 0.999 | 0.389 | 0.728 | 0.729 | 0.005 |
| hex: silesia/reymont | 524290 | 45642.3 ± 0.7% | 0.040 | 0.997 | 0.628 | 1.000 | 0.392 | 1.004 | 1.000 | 0.393 | 0.742 | 0.740 | 0.005 |
| hex: silesia/samba | 524290 | 45729.5 ± 0.3% | 0.040 | 1.001 | 0.625 | 1.001 | 0.396 | 1.003 | 1.002 | 0.396 | 0.742 | 0.742 | 0.005 |
| hex: silesia/sao | 524290 | 45742.6 ± 0.3% | 0.040 | 1.000 | 0.624 | 1.000 | 0.395 | 1.001 | 0.999 | 0.396 | 0.742 | 0.742 | 0.005 |
| hex: silesia/webster | 524290 | 46646.3 ± 0.4% | 0.039 | 1.001 | 0.613 | 1.002 | 0.385 | 1.005 | 1.002 | 0.385 | 0.728 | 0.727 | 0.005 |
| hex: silesia/x-ray | 524290 | 48915.6 ± 0.6% | 0.037 | 0.997 | 0.583 | 0.997 | 0.370 | 1.000 | 0.997 | 0.370 | 0.693 | 0.694 | 0.004 |
| hex: silesia/xml | 524290 | 39152.9 ± 0.3% | 0.047 | 1.001 | 0.646 | 1.002 | 0.448 | 1.003 | 1.003 | 0.448 | 0.867 | 0.867 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 48787.6 ± 0.3% | 0.038 | 1.002 | 0.576 | 1.000 | 0.371 | 1.003 | 1.001 | 0.371 | 0.693 | 0.695 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 46646.6 ± 2.5% | 0.039 | 1.001 | 0.612 | 1.000 | 0.386 | 1.000 | 0.999 | 0.386 | 0.727 | 0.728 | 0.005 |
| hex: canterbury/cp.html | 49208 | 44329.1 ± 0.8% | 0.041 | 1.002 | 0.632 | 1.003 | 0.398 | 1.002 | 1.003 | 0.402 | 0.754 | 0.753 | 0.005 |
| hex: canterbury/fields.c | 22302 | 51837.0 ± 0.4% | 0.036 | 1.001 | 0.532 | 0.999 | 0.384 | 1.003 | 0.999 | 0.392 | 0.638 | 0.637 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 44112.0 ± 0.8% | 0.042 | 1.011 | 0.577 | 1.002 | 0.410 | 1.001 | 1.002 | 0.431 | 0.679 | 0.676 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 40083.2 ± 1.0% | 0.045 | 1.003 | 0.617 | 1.002 | 0.431 | 1.002 | 1.002 | 0.432 | 0.848 | 0.847 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 46033.0 ± 0.5% | 0.040 | 1.001 | 0.619 | 1.002 | 0.387 | 1.003 | 1.001 | 0.387 | 0.737 | 0.735 | 0.005 |
| hex: canterbury/plrabn12.txt | 524290 | 37694.3 ± 0.5% | 0.048 | 1.002 | 0.683 | 1.002 | 0.455 | 1.003 | 1.001 | 0.454 | 0.901 | 0.900 | 0.006 |
| hex: canterbury/ptt5 | 524290 | 45595.5 ± 0.8% | 0.040 | 0.998 | 0.626 | 1.000 | 0.397 | 1.001 | 1.001 | 0.398 | 0.745 | 0.745 | 0.005 |
| hex: canterbury/sum | 76482 | 45523.5 ± 0.1% | 0.040 | 1.002 | 0.618 | 1.002 | 0.391 | 1.002 | 1.001 | 0.393 | 0.734 | 0.734 | 0.005 |
| hex: canterbury/xargs.1 | 8456 | 45719.6 ± 0.5% | 0.041 | 1.009 | 0.565 | 0.998 | 0.405 | 1.000 | 1.000 | 0.424 | 0.665 | 0.663 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 45675.4 ± 0.8% | 0.040 | 1.000 | 0.626 | 1.000 | 0.381 | 1.002 | 0.999 | 0.382 | 0.744 | 0.743 | 0.005 |
| hex: canterbury-large/bible.txt | 524290 | 45201.9 ± 2.4% | 0.041 | 1.004 | 0.628 | 1.005 | 0.396 | 1.005 | 1.004 | 0.396 | 0.752 | 0.752 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 46129.6 ± 0.2% | 0.040 | 1.000 | 0.609 | 0.998 | 0.392 | 1.000 | 0.999 | 0.392 | 0.736 | 0.736 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 17923.8 ± 0.8% | 0.101 | 1.004 | 0.820 | 0.998 | 0.568 | 1.005 | 0.998 | 0.633 | 0.854 | 0.831 | 0.012 |
| hex: http/html-16kx64 | 2097280 | 35270.3 ± 1.1% | 0.052 | 1.002 | 0.680 | 1.005 | 0.460 | 1.002 | 1.004 | 0.465 | 0.795 | 0.796 | 0.006 |
| hex: http/html-1m | 524290 | 48686.2 ± 0.4% | 0.038 | 0.999 | 0.579 | 0.999 | 0.370 | 1.001 | 1.000 | 0.370 | 0.697 | 0.697 | 0.004 |
| hex: http/json-1kx1024 | 2099200 | 17814.2 ± 3.8% | 0.101 | 1.003 | 0.831 | 0.997 | 0.575 | 1.004 | 0.997 | 0.631 | 0.854 | 0.833 | 0.012 |
| hex: http/json-16kx64 | 2097280 | 33996.7 ± 0.4% | 0.054 | 1.003 | 0.696 | 1.003 | 0.478 | 1.004 | 1.003 | 0.481 | 0.805 | 0.804 | 0.006 |
| hex: http/json-1m | 524290 | 45712.7 ± 0.3% | 0.040 | 1.000 | 0.629 | 1.000 | 0.375 | 0.999 | 0.998 | 0.375 | 0.743 | 0.742 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 17924.0 ± 1.3% | 0.101 | 1.006 | 0.827 | 1.001 | 0.594 | 1.007 | 1.000 | 0.653 | 0.858 | 0.835 | 0.012 |
| hex: http/js-16kx64 | 2097280 | 35130.1 ± 1.7% | 0.052 | 1.004 | 0.680 | 1.002 | 0.464 | 1.005 | 1.005 | 0.467 | 0.797 | 0.797 | 0.006 |
| hex: http/js-1m | 524290 | 45675.6 ± 0.8% | 0.040 | 1.003 | 0.628 | 1.002 | 0.395 | 1.002 | 1.002 | 0.396 | 0.743 | 0.743 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 17967.8 ± 1.0% | 0.100 | 1.004 | 0.828 | 0.996 | 0.591 | 1.003 | 0.997 | 0.650 | 0.853 | 0.834 | 0.012 |
| hex: http/css-16kx64 | 2097280 | 34726.1 ± 5.9% | 0.052 | 1.001 | 0.684 | 1.002 | 0.466 | 1.001 | 1.001 | 0.470 | 0.797 | 0.796 | 0.006 |
| hex: http/css-1m | 524290 | 46030.3 ± 1.0% | 0.040 | 0.999 | 0.617 | 0.999 | 0.389 | 0.996 | 1.000 | 0.391 | 0.732 | 0.731 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 45506.8 ± 0.8% | 0.040 | 1.002 | 0.618 | 1.001 | 0.395 | 1.002 | 1.000 | 0.395 | 0.743 | 0.744 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1734.6 ± 0.7% | 0.426 | 1.003 | 0.979 | 1.018 | 1.012 | 0.270 | 1.016 | 0.523 | 0.862 | 0.095 | 1.034 |
| qlog records, JSON text sequence | 1467503 | 1640.2 ± 5.7% | 0.640 | 0.979 | 0.988 | 1.019 | 0.997 | 0.236 | 0.998 | 0.452 | 0.832 | 0.108 | 1.042 |
| messages: 11 string members | 1025025 | 1313.4 ± 2.7% | 0.503 | 0.965 | 0.987 | 0.996 | 0.985 | 0.376 | 0.983 | 0.672 | 0.950 | 0.123 | 1.003 |
| messages: 50 nested objects | 1121600 | 1978.7 ± 6.0% | 0.581 | 0.979 | 0.968 | 0.992 | 0.973 | 0.241 | 0.973 | 0.446 | 0.821 | 0.092 | 1.005 |
| messages: a tree of 341 objects | 612600 | 592.2 ± 4.0% | 0.979 | 1.059 | 1.063 | 1.077 | 1.080 | 0.260 | 1.080 | 0.454 | 0.907 | 0.194 | 1.088 |
| string: silesia/dickens | 172528 | 12871.5 ± 5.4% | 0.018 | 0.545 | 0.364 | 0.540 | 0.564 | 0.121 | 0.570 | 1.003 | 1.001 | 0.018 | 1.045 |
| string: silesia/nci | 1075110 | 11351.2 ± 1.1% | 0.020 | 0.521 | 0.359 | 0.531 | 0.523 | 0.184 | 0.523 | 1.003 | 1.006 | 0.020 | 1.036 |
| string: silesia/reymont | 1075159 | 5259.6 ± 2.0% | 0.043 | 0.582 | 0.437 | 0.576 | 0.580 | 0.268 | 0.577 | 1.013 | 1.016 | 0.043 | 1.028 |
| string: silesia/samba | 97582 | 6093.5 ± 0.5% | 0.047 | 0.912 | 0.768 | 0.927 | 0.916 | 0.124 | 0.922 | 1.005 | 1.004 | 0.047 | 1.149 |
| string: silesia/webster | 1098490 | 7044.6 ± 1.1% | 0.032 | 0.573 | 0.408 | 0.549 | 0.577 | 0.155 | 0.572 | 0.991 | 1.010 | 0.032 | 0.986 |
| string: silesia/xml | 1090118 | 10901.0 ± 0.8% | 0.021 | 0.548 | 0.456 | 0.542 | 0.550 | 0.194 | 0.552 | 1.000 | 1.015 | 0.021 | 1.042 |
| string: canterbury/alice29.txt | 159425 | 12528.6 ± 1.1% | 0.018 | 0.438 | 0.357 | 0.427 | 0.456 | 0.093 | 0.473 | 0.997 | 1.004 | 0.018 | 1.048 |
| string: canterbury/asyoulik.txt | 132198 | 10910.1 ± 1.4% | 0.020 | 0.397 | 0.331 | 0.385 | 0.412 | 0.090 | 0.415 | 0.992 | 1.011 | 0.020 | 1.037 |
| string: canterbury/lcet10.txt | 441884 | 12643.5 ± 5.6% | 0.018 | 0.546 | 0.325 | 0.534 | 0.547 | 0.118 | 0.554 | 1.001 | 1.021 | 0.018 | 0.996 |
| string: canterbury/plrabn12.txt | 503330 | 8890.3 ± 1.0% | 0.025 | 0.613 | 0.493 | 0.614 | 0.615 | 0.158 | 0.616 | 1.002 | 1.023 | 0.025 | 1.009 |
| string: canterbury-large/E.coli | 1048578 | 28448.0 ± 0.8% | 0.062 | 1.002 | 1.002 | 0.829 | 1.003 | 0.539 | 1.003 | 1.003 | 1.003 | 0.008 | 1.002 |
| string: canterbury-large/bible.txt | 1055886 | 9547.3 ± 0.7% | 0.025 | 0.745 | 0.573 | 0.744 | 0.758 | 0.391 | 0.759 | 0.994 | 1.010 | 0.025 | 1.025 |
| string: canterbury-large/world192.txt | 1103121 | 6619.0 ± 0.7% | 0.033 | 0.587 | 0.423 | 0.554 | 0.591 | 0.150 | 0.592 | 0.993 | 1.010 | 0.034 | 0.977 |
| string: http/html-1m | 1058582 | 9996.3 ± 0.8% | 0.023 | 0.648 | 0.537 | 0.641 | 0.650 | 0.317 | 0.652 | 0.996 | 1.012 | 0.023 | 1.012 |
| string: http/json-1m | 1190272 | 8316.4 ± 6.2% | 0.025 | 0.185 | 0.162 | 0.185 | 0.186 | 0.074 | 0.186 | 1.001 | 1.007 | 0.024 | 1.016 |
| string: http/js-1m | 1144362 | 6517.9 ± 0.9% | 0.033 | 0.371 | 0.313 | 0.361 | 0.371 | 0.094 | 0.371 | 0.992 | 1.005 | 0.033 | 1.011 |
| string: http/css-1m | 1097820 | 9300.1 ± 0.9% | 0.023 | 0.347 | 0.281 | 0.338 | 0.348 | 0.123 | 0.346 | 0.992 | 1.009 | 0.023 | 1.006 |
| string: dickens as Cyrillic and CJK | 1883069 | 5458.8 ± 0.9% | 0.031 | 0.467 | 0.067 | 0.466 | 0.468 | 0.208 | 0.468 | 1.002 | 1.005 | 0.031 | 1.044 |
| hex: silesia/dickens | 524290 | 42504.4 ± 1.0% | 1.004 | 0.091 | 1.002 | 0.604 | 1.003 | 1.001 | 1.003 | 1.003 | 1.003 | 0.095 | 1.004 |
| hex: silesia/mozilla | 524290 | 43729.7 ± 0.5% | 1.002 | 0.088 | 1.000 | 0.589 | 1.001 | 0.999 | 1.002 | 1.001 | 1.001 | 0.093 | 1.001 |
| hex: silesia/mr | 524290 | 43581.1 ± 0.3% | 1.001 | 0.088 | 1.002 | 0.590 | 1.003 | 1.001 | 1.001 | 1.000 | 1.002 | 0.094 | 1.001 |
| hex: silesia/nci | 524290 | 43598.4 ± 1.4% | 0.981 | 0.088 | 0.997 | 0.589 | 1.001 | 1.001 | 0.994 | 0.989 | 0.988 | 0.091 | 0.992 |
| hex: silesia/ooffice | 524290 | 43080.1 ± 1.4% | 0.999 | 0.089 | 0.993 | 0.591 | 0.996 | 0.991 | 1.000 | 0.996 | 1.002 | 0.094 | 0.969 |
| hex: silesia/osdb | 524290 | 42032.3 ± 1.1% | 1.000 | 0.091 | 1.002 | 0.609 | 1.002 | 1.000 | 1.003 | 1.002 | 1.001 | 0.094 | 1.001 |
| hex: silesia/reymont | 524290 | 43477.3 ± 0.3% | 1.003 | 0.088 | 1.001 | 0.590 | 1.004 | 0.996 | 1.002 | 0.999 | 0.998 | 0.093 | 0.999 |
| hex: silesia/samba | 524290 | 43750.8 ± 0.4% | 1.001 | 0.088 | 0.995 | 0.587 | 0.999 | 0.996 | 1.000 | 0.964 | 0.999 | 0.092 | 0.997 |
| hex: silesia/sao | 524290 | 43541.6 ± 0.5% | 1.002 | 0.088 | 1.001 | 0.590 | 1.004 | 1.002 | 1.003 | 1.003 | 1.003 | 0.093 | 1.003 |
| hex: silesia/webster | 524290 | 44059.2 ± 0.2% | 1.001 | 0.087 | 1.000 | 0.586 | 1.001 | 1.000 | 1.001 | 1.000 | 0.999 | 0.092 | 1.000 |
| hex: silesia/x-ray | 524290 | 43755.0 ± 0.3% | 1.001 | 0.088 | 1.000 | 0.588 | 1.001 | 0.999 | 0.999 | 0.999 | 1.000 | 0.092 | 0.998 |
| hex: silesia/xml | 524290 | 43583.6 ± 2.1% | 1.001 | 0.088 | 1.002 | 0.590 | 1.004 | 1.001 | 1.001 | 1.001 | 1.001 | 0.092 | 1.002 |
| hex: canterbury/alice29.txt | 304180 | 41423.4 ± 1.8% | 1.004 | 0.092 | 1.005 | 0.598 | 1.002 | 1.002 | 1.003 | 1.001 | 1.001 | 0.097 | 0.999 |
| hex: canterbury/asyoulik.txt | 250360 | 43447.3 ± 0.4% | 1.001 | 0.088 | 1.001 | 0.591 | 1.001 | 1.001 | 1.003 | 1.002 | 1.001 | 0.093 | 1.002 |
| hex: canterbury/cp.html | 49208 | 41407.5 ± 0.3% | 1.000 | 0.092 | 1.002 | 0.599 | 1.001 | 0.995 | 1.001 | 1.001 | 1.001 | 0.100 | 1.001 |
| hex: canterbury/fields.c | 22302 | 41932.0 ± 1.4% | 1.002 | 0.091 | 0.997 | 0.597 | 1.000 | 0.988 | 1.000 | 1.001 | 1.008 | 0.098 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 39008.0 ± 1.4% | 0.998 | 0.097 | 1.006 | 0.611 | 1.008 | 0.974 | 1.009 | 1.008 | 1.036 | 0.104 | 1.015 |
| hex: canterbury/kennedy.xls | 524290 | 43495.6 ± 0.5% | 0.961 | 0.088 | 1.002 | 0.591 | 1.003 | 1.001 | 0.944 | 1.002 | 1.002 | 0.092 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 43383.7 ± 1.3% | 1.002 | 0.088 | 1.004 | 0.591 | 1.005 | 1.002 | 0.999 | 1.004 | 1.004 | 0.092 | 0.987 |
| hex: canterbury/plrabn12.txt | 524290 | 43582.5 ± 0.6% | 1.001 | 0.088 | 1.000 | 0.588 | 1.000 | 0.997 | 1.001 | 0.998 | 0.999 | 0.091 | 0.999 |
| hex: canterbury/ptt5 | 524290 | 43555.0 ± 0.5% | 1.001 | 0.088 | 1.001 | 0.590 | 1.000 | 1.001 | 1.003 | 1.002 | 1.002 | 0.092 | 1.002 |
| hex: canterbury/sum | 76482 | 42709.8 ± 1.5% | 1.001 | 0.089 | 0.997 | 0.592 | 0.999 | 0.996 | 1.002 | 0.996 | 0.999 | 0.096 | 1.003 |
| hex: canterbury/xargs.1 | 8456 | 39874.2 ± 1.3% | 1.001 | 0.095 | 1.003 | 0.602 | 1.003 | 0.951 | 0.996 | 0.992 | 1.016 | 0.102 | 0.998 |
| hex: canterbury-large/E.coli | 524290 | 41669.0 ± 1.3% | 1.000 | 0.092 | 0.999 | 0.607 | 0.999 | 1.000 | 1.001 | 1.003 | 1.001 | 0.097 | 1.003 |
| hex: canterbury-large/bible.txt | 524290 | 43574.1 ± 1.1% | 1.000 | 0.088 | 0.999 | 0.587 | 0.992 | 0.997 | 0.996 | 0.996 | 0.998 | 0.092 | 0.996 |
| hex: canterbury-large/world192.txt | 524290 | 42927.2 ± 3.8% | 1.005 | 0.089 | 1.007 | 0.596 | 1.004 | 1.000 | 1.001 | 1.004 | 1.005 | 0.095 | 1.006 |
| hex: http/html-1kx1024 | 2099200 | 20436.2 ± 0.5% | 1.002 | 0.178 | 1.003 | 0.980 | 1.002 | 1.002 | 1.006 | 1.003 | 1.006 | 0.185 | 1.007 |
| hex: http/html-16kx64 | 2097280 | 21658.6 ± 0.4% | 1.000 | 0.174 | 1.001 | 0.970 | 1.003 | 1.000 | 1.001 | 1.000 | 0.999 | 0.189 | 1.002 |
| hex: http/html-1m | 524290 | 43294.5 ± 0.8% | 1.004 | 0.089 | 1.001 | 0.592 | 0.997 | 0.999 | 1.002 | 1.003 | 0.988 | 0.094 | 1.002 |
| hex: http/json-1kx1024 | 2099200 | 20136.8 ± 0.4% | 1.000 | 0.181 | 1.001 | 0.985 | 1.002 | 1.004 | 1.004 | 1.004 | 1.005 | 0.188 | 1.006 |
| hex: http/json-16kx64 | 2097280 | 21405.3 ± 0.3% | 1.006 | 0.175 | 1.005 | 0.983 | 1.005 | 1.005 | 1.005 | 1.005 | 1.004 | 0.190 | 1.006 |
| hex: http/json-1m | 524290 | 43618.7 ± 1.0% | 1.001 | 0.088 | 1.000 | 0.590 | 1.000 | 0.999 | 0.999 | 1.001 | 0.999 | 0.093 | 0.996 |
| hex: http/js-1kx1024 | 2099200 | 20896.8 ± 3.2% | 1.004 | 0.175 | 1.004 | 0.965 | 1.005 | 0.999 | 1.005 | 1.005 | 1.009 | 0.183 | 1.005 |
| hex: http/js-16kx64 | 2097280 | 22150.4 ± 0.7% | 1.002 | 0.170 | 1.004 | 0.958 | 1.004 | 1.004 | 1.003 | 1.002 | 1.003 | 0.185 | 1.003 |
| hex: http/js-1m | 524290 | 43606.0 ± 9.3% | 0.996 | 0.088 | 1.002 | 0.591 | 1.003 | 1.000 | 1.000 | 1.001 | 1.000 | 0.093 | 1.003 |
| hex: http/css-1kx1024 | 2099200 | 20159.9 ± 0.4% | 1.003 | 0.181 | 1.004 | 0.991 | 1.003 | 1.005 | 1.002 | 1.002 | 1.007 | 0.189 | 1.005 |
| hex: http/css-16kx64 | 2097280 | 21213.5 ± 2.4% | 1.005 | 0.177 | 1.005 | 0.989 | 1.008 | 1.008 | 1.007 | 1.004 | 1.007 | 0.192 | 1.006 |
| hex: http/css-1m | 524290 | 43347.6 ± 1.3% | 1.001 | 0.088 | 1.001 | 0.590 | 1.002 | 0.997 | 1.003 | 0.999 | 1.000 | 0.092 | 1.003 |
| hex: shuffled/dickens-1m | 524290 | 42195.2 ± 0.5% | 1.001 | 0.091 | 1.000 | 0.607 | 1.002 | 0.997 | 1.001 | 0.999 | 0.995 | 0.095 | 0.995 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.066 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.069 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.070 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.068 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.065 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.071 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.077 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.080 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.078 of all on.
- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.084 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.085 of all on.
- messages: 50 nested objects, decoding: J8 decoder fast path off runs at 1.087 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.094 of all on.
- messages: 50 nested objects, decoding: J13 decoder escape blocks off runs at 1.088 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.087 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.093 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.112 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.061 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.061 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.061 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.086 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.112 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.163 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.137 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.136 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.063 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.141 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.106 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.116 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.120 of all on.
- messages: a tree of 341 objects, encoding: J2 hex vectors off runs at 1.059 of all on.
- messages: a tree of 341 objects, encoding: J5 UTF-8 vectors off runs at 1.063 of all on.
- messages: a tree of 341 objects, encoding: J7 wide vectors off runs at 1.077 of all on.
- messages: a tree of 341 objects, encoding: J9 encoder fast path off runs at 1.080 of all on.
- messages: a tree of 341 objects, encoding: J14 encoder escape blocks off runs at 1.080 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 165717.7 ± 1.2% | 121313.9 ± 1.0% | 1.366 | 100242.2 ± 0.3% | 1.653 |
| string: silesia/nci | 1048576 | 166705.7 ± 1.1% | 122039.4 ± 0.5% | 1.366 | 100205.3 ± 0.9% | 1.664 |
| string: silesia/reymont | 1048576 | 167176.3 ± 0.4% | 121794.6 ± 0.7% | 1.373 | 100653.0 ± 0.6% | 1.661 |
| string: silesia/samba | 65546 | 160362.4 ± 1.1% | 118527.9 ± 1.0% | 1.353 | 98382.2 ± 0.5% | 1.630 |
| string: silesia/webster | 1048576 | 164551.6 ± 2.3% | 121060.9 ± 0.8% | 1.359 | 100520.3 ± 0.9% | 1.637 |
| string: silesia/xml | 1048576 | 165277.3 ± 1.3% | 121776.4 ± 0.8% | 1.357 | 100236.2 ± 1.0% | 1.649 |
| string: canterbury/alice29.txt | 152089 | 164853.0 ± 0.9% | 120755.9 ± 1.0% | 1.365 | 99622.6 ± 0.6% | 1.655 |
| string: canterbury/asyoulik.txt | 125179 | 164563.3 ± 1.1% | 120456.2 ± 0.8% | 1.366 | 99721.2 ± 0.6% | 1.650 |
| string: canterbury/lcet10.txt | 426754 | 166153.9 ± 6.9% | 121214.3 ± 1.7% | 1.371 | 100265.2 ± 0.7% | 1.657 |
| string: canterbury/plrabn12.txt | 481861 | 166878.5 ± 1.9% | 121596.2 ± 0.5% | 1.372 | 100569.1 ± 5.2% | 1.659 |
| string: canterbury-large/E.coli | 1048576 | 165362.3 ± 10.5% | 121447.1 ± 2.0% | 1.362 | 99770.6 ± 1.0% | 1.657 |
| string: canterbury-large/bible.txt | 1048576 | 166359.4 ± 1.1% | 121714.5 ± 0.8% | 1.367 | 100733.1 ± 0.8% | 1.651 |
| string: canterbury-large/world192.txt | 1048576 | 166360.1 ± 0.5% | 121465.8 ± 0.6% | 1.370 | 100303.0 ± 0.6% | 1.659 |
| string: http/html-1m | 1048576 | 143893.5 ± 11.1% | 110478.7 ± 0.8% | 1.302 | 92938.7 ± 1.1% | 1.548 |
| string: http/json-1m | 1048576 | 120655.6 ± 1.7% | 105237.4 ± 1.1% | 1.147 | 81091.1 ± 1.5% | 1.488 |
| string: http/js-1m | 1048576 | 162402.1 ± 0.8% | 120196.0 ± 1.2% | 1.351 | 98259.4 ± 0.7% | 1.653 |
| string: http/css-1m | 1048576 | 164051.7 ± 1.6% | 120184.7 ± 1.0% | 1.365 | 98867.1 ± 1.3% | 1.659 |
| string: dickens as Cyrillic and CJK | 1847045 | 23242.9 ± 0.8% | 20408.5 ± 0.5% | 1.139 | 14753.7 ± 0.6% | 1.575 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 165597.3 ± 0.3% | 122088.8 ± 0.4% | 1.356 | 101237.1 ± 0.6% | 1.636 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 167246.9 ± 0.8% | 122247.4 ± 0.2% | 1.368 | 100621.0 ± 0.5% | 1.662 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 166623.8 ± 0.6% | 122476.8 ± 0.5% | 1.360 | 100788.1 ± 0.4% | 1.653 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 167512.1 ± 0.4% | 122408.8 ± 0.5% | 1.368 | 100799.7 ± 0.5% | 1.662 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 167296.0 ± 0.8% | 122375.9 ± 0.5% | 1.367 | 100922.4 ± 0.7% | 1.658 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 167367.1 ± 1.7% | 122298.4 ± 0.4% | 1.369 | 101274.2 ± 0.7% | 1.653 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24278.3 ± 0.4% | 21660.7 ± 0.3% | 1.121 | 15303.8 ± 0.2% | 1.586 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24229.0 ± 0.2% | 21647.2 ± 0.2% | 1.119 | 15280.5 ± 0.5% | 1.586 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24171.4 ± 0.3% | 21661.7 ± 0.7% | 1.116 | 15229.9 ± 0.6% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24167.0 ± 0.3% | 21579.4 ± 0.4% | 1.120 | 15228.1 ± 0.8% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24145.1 ± 0.1% | 21514.6 ± 0.7% | 1.122 | 15220.5 ± 0.4% | 1.586 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24178.4 ± 0.3% | 21570.7 ± 0.4% | 1.121 | 15261.9 ± 0.7% | 1.584 |

## Messages against serde_json's typed code

stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.

| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |
|---|---|---|---|---|
| messages: 11 string members | 1025025 | 1212.5 ± 3.1% | 818.5 ± 0.6% | 1.481 |
| messages: 50 nested objects | 1121600 | 1611.7 ± 1.0% | 916.4 ± 0.7% | 1.759 |
| messages: a tree of 341 objects | 612600 | 516.4 ± 1.5% | 512.1 ± 2.3% | 1.008 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1377.7 ± 0.3% | 1501.1 ± 1.1% | 1110.2 ± 0.7% | 391.5 ± 1.3% | 671.4 ± 0.5% | 362.4 ± 2.0% | 0.918 | 1.241 | 3.519 | 2.052 | 3.801 |
| qlog records, JSON text sequence | 1467503 | 1076.0 ± 2.4% | 1240.2 ± 1.5% | 1114.7 ± 0.3% | 329.4 ± 0.9% | 755.5 ± 0.8% | 317.8 ± 0.4% | 0.868 | 0.965 | 3.266 | 1.424 | 3.386 |
| messages: 11 string members | 1025025 | 1063.8 ± 1.1% | 1965.4 ± 8.1% | 698.7 ± 2.2% | 335.0 ± 0.9% | 510.9 ± 1.5% | 302.7 ± 1.6% | 0.541 | 1.523 | 3.176 | 2.082 | 3.515 |
| messages: 50 nested objects | 1121600 | 1332.5 ± 0.5% | 1724.3 ± 1.6% | 1442.0 ± 1.1% | 421.8 ± 1.8% | 900.0 ± 0.7% | 418.8 ± 0.6% | 0.773 | 0.924 | 3.159 | 1.481 | 3.182 |
| messages: a tree of 341 objects | 612600 | 660.2 ± 1.1% | 835.7 ± 2.2% | 696.5 ± 0.7% | 181.2 ± 0.8% | 607.1 ± 1.3% | 207.4 ± 0.5% | 0.790 | 0.948 | 3.642 | 1.087 | 3.184 |
| string: silesia/dickens | 172528 | 6681.9 ± 0.7% | 3430.3 ± 5.9% | 2876.7 ± 1.5% | 315.4 ± 1.2% | 3073.4 ± 1.4% | 568.5 ± 2.2% | 1.948 | 2.323 | 21.188 | 2.174 | 11.754 |
| string: silesia/nci | 1075110 | 5350.6 ± 0.8% | 3891.1 ± 0.9% | 2998.1 ± 0.3% | 645.1 ± 0.6% | 3603.0 ± 0.5% | 565.0 ± 3.8% | 1.375 | 1.785 | 8.294 | 1.485 | 9.471 |
| string: silesia/reymont | 1075159 | 3518.0 ± 1.1% | 3385.4 ± 0.4% | 1943.4 ± 1.8% | 342.2 ± 0.6% | 2081.9 ± 0.6% | 490.5 ± 0.6% | 1.039 | 1.810 | 10.280 | 1.690 | 7.173 |
| string: silesia/samba | 97582 | 3998.6 ± 0.6% | 3807.4 ± 0.3% | 3055.4 ± 0.6% | 327.6 ± 0.5% | 1949.7 ± 0.5% | 420.9 ± 0.8% | 1.050 | 1.309 | 12.205 | 2.051 | 9.500 |
| string: silesia/webster | 1098490 | 4409.2 ± 0.8% | 2430.4 ± 0.4% | 1738.7 ± 0.3% | 309.6 ± 0.4% | 2075.6 ± 0.2% | 466.2 ± 1.1% | 1.814 | 2.536 | 14.243 | 2.124 | 9.457 |
| string: silesia/xml | 1090118 | 6070.2 ± 0.3% | 5010.1 ± 0.7% | 2445.8 ± 0.5% | 510.4 ± 0.5% | 3283.9 ± 0.5% | 539.6 ± 2.1% | 1.212 | 2.482 | 11.893 | 1.849 | 11.250 |
| string: canterbury/alice29.txt | 159425 | 5701.6 ± 1.4% | 2790.0 ± 1.6% | 2802.9 ± 1.7% | 298.7 ± 1.3% | 2778.6 ± 1.1% | 512.8 ± 1.1% | 2.044 | 2.034 | 19.089 | 2.052 | 11.119 |
| string: canterbury/asyoulik.txt | 132198 | 4264.9 ± 0.4% | 2594.9 ± 3.6% | 2758.3 ± 1.4% | 302.7 ± 0.9% | 2367.7 ± 1.5% | 453.4 ± 3.7% | 1.644 | 1.546 | 14.088 | 1.801 | 9.407 |
| string: canterbury/lcet10.txt | 441884 | 6618.5 ± 0.9% | 3290.0 ± 1.5% | 2345.1 ± 0.7% | 345.0 ± 0.5% | 2795.1 ± 1.4% | 568.0 ± 3.0% | 2.012 | 2.822 | 19.183 | 2.368 | 11.653 |
| string: canterbury/plrabn12.txt | 503330 | 5481.6 ± 0.3% | 3171.0 ± 0.7% | 1844.6 ± 1.5% | 322.3 ± 0.6% | 2817.2 ± 0.4% | 532.5 ± 1.3% | 1.729 | 2.972 | 17.008 | 1.946 | 10.294 |
| string: canterbury-large/E.coli | 1048578 | 34040.9 ± 0.5% | 13417.2 ± 0.3% | 3430.9 ± 0.2% | 1281.3 ± 1.3% | 8919.7 ± 4.2% | 962.4 ± 2.1% | 2.537 | 9.922 | 26.568 | 3.816 | 35.370 |
| string: canterbury-large/bible.txt | 1055886 | 8495.3 ± 1.3% | 5256.2 ± 0.7% | 2788.0 ± 5.6% | 356.4 ± 0.8% | 3870.5 ± 0.5% | 629.4 ± 2.2% | 1.616 | 3.047 | 23.838 | 2.195 | 13.496 |
| string: canterbury-large/world192.txt | 1103121 | 4130.2 ± 1.2% | 2301.6 ± 0.3% | 1770.5 ± 0.4% | 326.5 ± 0.4% | 2116.9 ± 0.2% | 467.0 ± 1.7% | 1.795 | 2.333 | 12.652 | 1.951 | 8.844 |
| string: http/html-1m | 1058582 | 9158.9 ± 1.4% | 4741.5 ± 0.6% | 2668.9 ± 3.0% | 425.3 ± 0.3% | 3633.0 ± 0.2% | 602.8 ± 2.0% | 1.932 | 3.432 | 21.536 | 2.521 | 15.193 |
| string: http/json-1m | 1190272 | 3343.5 ± 0.7% | 1250.5 ± 0.2% | 2082.4 ± 0.3% | 475.9 ± 1.0% | 1332.8 ± 1.0% | 437.9 ± 3.0% | 2.674 | 1.606 | 7.026 | 2.509 | 7.636 |
| string: http/js-1m | 1144362 | 2839.4 ± 0.9% | 1604.8 ± 0.5% | 1325.0 ± 0.2% | 325.2 ± 0.5% | 1412.5 ± 0.2% | 378.8 ± 0.7% | 1.769 | 2.143 | 8.733 | 2.010 | 7.496 |
| string: http/css-1m | 1097820 | 3291.8 ± 0.6% | 2884.5 ± 0.2% | 2271.2 ± 0.5% | 452.0 ± 0.3% | 2057.7 ± 0.6% | 440.3 ± 1.1% | 1.141 | 1.449 | 7.283 | 1.600 | 7.476 |
| string: dickens as Cyrillic and CJK | 1883069 | 5820.8 ± 0.4% | 3171.1 ± 4.5% | 662.7 ± 0.5% | 378.5 ± 1.7% | 511.2 ± 0.4% | 164.3 ± 3.8% | 1.836 | 8.783 | 15.378 | 11.387 | 35.428 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1201.9 ± 1.1% | 1243.7 ± 0.8% | 1101.0 ± 0.7% | 263.4 ± 1.1% | 480.5 ± 0.4% | 230.1 ± 2.9% | 0.966 | 1.092 | 4.564 | 2.502 | 5.222 |
| hex: silesia/dickens | 524290 | 46893.6 ± 0.3% | 15153.6 ± 0.1% | 3562.5 ± 0.3% | 479.1 ± 0.6% | 8923.1 ± 0.7% | 1139.3 ± 1.6% | 3.095 | 13.163 | 97.871 | 5.255 | 41.160 |
| hex: silesia/mozilla | 524290 | 47328.5 ± 0.1% | 15154.1 ± 0.1% | 3492.5 ± 0.2% | 431.4 ± 0.2% | 8921.5 ± 0.5% | 1136.0 ± 0.6% | 3.123 | 13.551 | 109.712 | 5.305 | 41.663 |
| hex: silesia/mr | 524290 | 45874.0 ± 0.1% | 15142.2 ± 0.2% | 3500.0 ± 0.5% | 645.5 ± 0.3% | 8918.6 ± 0.2% | 1136.7 ± 0.3% | 3.030 | 13.107 | 71.063 | 5.144 | 40.358 |
| hex: silesia/nci | 524290 | 41472.1 ± 0.7% | 15146.8 ± 0.4% | 3567.7 ± 0.3% | 803.8 ± 3.8% | 8924.6 ± 0.5% | 1133.7 ± 0.7% | 2.738 | 11.624 | 51.593 | 4.647 | 36.582 |
| hex: silesia/ooffice | 524290 | 48693.8 ± 3.0% | 15126.5 ± 3.0% | 3490.6 ± 0.2% | 345.2 ± 0.4% | 8900.4 ± 4.4% | 1134.9 ± 0.4% | 3.219 | 13.950 | 141.049 | 5.471 | 42.907 |
| hex: silesia/osdb | 524290 | 46542.8 ± 0.4% | 15126.1 ± 0.5% | 3495.3 ± 0.3% | 457.7 ± 0.9% | 8904.0 ± 0.4% | 1129.7 ± 1.1% | 3.077 | 13.316 | 101.683 | 5.227 | 41.200 |
| hex: silesia/reymont | 524290 | 45642.3 ± 0.7% | 15045.1 ± 0.4% | 3558.9 ± 0.5% | 498.9 ± 0.7% | 8876.6 ± 0.5% | 1131.4 ± 0.5% | 3.034 | 12.825 | 91.485 | 5.142 | 40.341 |
| hex: silesia/samba | 524290 | 45729.5 ± 0.3% | 15130.7 ± 0.1% | 3493.4 ± 0.3% | 367.7 ± 0.5% | 8920.0 ± 0.2% | 1136.3 ± 0.4% | 3.022 | 13.090 | 124.365 | 5.127 | 40.244 |
| hex: silesia/sao | 524290 | 45742.6 ± 0.3% | 15118.2 ± 0.3% | 3496.3 ± 0.1% | 280.4 ± 0.5% | 8907.9 ± 3.6% | 1135.3 ± 0.7% | 3.026 | 13.083 | 163.145 | 5.135 | 40.292 |
| hex: silesia/webster | 524290 | 46646.3 ± 0.4% | 15115.1 ± 0.5% | 3560.2 ± 2.1% | 451.9 ± 1.6% | 8942.0 ± 0.3% | 1136.1 ± 0.7% | 3.086 | 13.102 | 103.221 | 5.217 | 41.057 |
| hex: silesia/x-ray | 524290 | 48915.6 ± 0.6% | 15099.9 ± 0.5% | 3491.9 ± 0.4% | 426.0 ± 0.8% | 8902.6 ± 0.3% | 1133.3 ± 0.7% | 3.239 | 14.008 | 114.826 | 5.495 | 43.163 |
| hex: silesia/xml | 524290 | 39152.9 ± 0.3% | 15134.5 ± 0.5% | 3560.6 ± 0.3% | 730.0 ± 0.6% | 8924.8 ± 0.1% | 1135.1 ± 0.7% | 2.587 | 10.996 | 53.632 | 4.387 | 34.492 |
| hex: canterbury/alice29.txt | 304180 | 48787.6 ± 0.3% | 14205.7 ± 0.2% | 3566.7 ± 0.3% | 482.9 ± 0.6% | 8933.3 ± 4.6% | 1146.3 ± 0.3% | 3.434 | 13.679 | 101.037 | 5.461 | 42.560 |
| hex: canterbury/asyoulik.txt | 250360 | 46646.6 ± 2.5% | 15096.2 ± 0.1% | 3500.8 ± 0.2% | 470.8 ± 0.5% | 8923.2 ± 0.5% | 1143.2 ± 0.9% | 3.090 | 13.325 | 99.081 | 5.228 | 40.803 |
| hex: canterbury/cp.html | 49208 | 44329.1 ± 0.8% | 14444.0 ± 2.3% | 3571.4 ± 0.2% | 509.7 ± 4.5% | 9249.4 ± 2.4% | 1113.8 ± 2.5% | 3.069 | 12.412 | 86.976 | 4.793 | 39.799 |
| hex: canterbury/fields.c | 22302 | 51837.0 ± 0.4% | 17671.5 ± 0.1% | 3676.0 ± 5.2% | 566.4 ± 0.9% | 9255.6 ± 0.5% | 1096.8 ± 1.5% | 2.933 | 14.102 | 91.517 | 5.601 | 47.262 |
| hex: canterbury/grammar.lsp | 7444 | 44112.0 ± 0.8% | 17276.1 ± 0.3% | 3632.0 ± 0.2% | 743.3 ± 0.6% | 8964.3 ± 0.1% | 1058.2 ± 4.8% | 2.553 | 12.145 | 59.347 | 4.921 | 41.687 |
| hex: canterbury/kennedy.xls | 524290 | 40083.2 ± 1.0% | 15137.6 ± 0.2% | 3566.1 ± 0.2% | 760.0 ± 1.0% | 8927.8 ± 0.1% | 1119.0 ± 5.7% | 2.648 | 11.240 | 52.741 | 4.490 | 35.822 |
| hex: canterbury/lcet10.txt | 524290 | 46033.0 ± 0.5% | 15063.0 ± 0.7% | 3517.9 ± 2.1% | 480.2 ± 1.1% | 8896.5 ± 0.5% | 1124.9 ± 2.4% | 3.056 | 13.085 | 95.857 | 5.174 | 40.923 |
| hex: canterbury/plrabn12.txt | 524290 | 37694.3 ± 0.5% | 15142.4 ± 0.3% | 3556.7 ± 0.3% | 465.8 ± 0.4% | 8919.0 ± 5.6% | 1126.4 ± 0.6% | 2.489 | 10.598 | 80.917 | 4.226 | 33.464 |
| hex: canterbury/ptt5 | 524290 | 45595.5 ± 0.8% | 15143.1 ± 0.1% | 3499.0 ± 0.4% | 664.9 ± 0.2% | 8901.0 ± 5.4% | 1125.2 ± 2.8% | 3.011 | 13.031 | 68.577 | 5.123 | 40.522 |
| hex: canterbury/sum | 76482 | 45523.5 ± 0.1% | 15465.8 ± 0.2% | 3572.0 ± 0.6% | 587.6 ± 0.5% | 8924.2 ± 4.9% | 1136.8 ± 0.8% | 2.943 | 12.745 | 77.472 | 5.101 | 40.044 |
| hex: canterbury/xargs.1 | 8456 | 45719.6 ± 0.5% | 17421.4 ± 0.1% | 3565.6 ± 0.3% | 721.1 ± 1.5% | 8969.5 ± 0.1% | 1107.2 ± 2.0% | 2.624 | 12.822 | 63.399 | 5.097 | 41.291 |
| hex: canterbury-large/E.coli | 524290 | 45675.4 ± 0.8% | 15137.4 ± 0.2% | 3487.6 ± 0.5% | 961.7 ± 0.4% | 8905.4 ± 1.3% | 1096.5 ± 6.4% | 3.017 | 13.097 | 47.496 | 5.129 | 41.655 |
| hex: canterbury-large/bible.txt | 524290 | 45201.9 ± 2.4% | 15154.3 ± 0.4% | 3497.2 ± 0.4% | 500.1 ± 0.5% | 8915.6 ± 0.4% | 1119.9 ± 3.0% | 2.983 | 12.925 | 90.384 | 5.070 | 40.362 |
| hex: canterbury-large/world192.txt | 524290 | 46129.6 ± 0.2% | 15151.9 ± 0.2% | 3571.5 ± 0.3% | 468.5 ± 0.8% | 8946.5 ± 0.5% | 1137.3 ± 0.3% | 3.044 | 12.916 | 98.466 | 5.156 | 40.561 |
| hex: http/html-1kx1024 | 2099200 | 17923.8 ± 0.8% | 12101.6 ± 11.8% | 3188.1 ± 0.4% | 505.8 ± 0.6% | 7591.3 ± 0.9% | 973.7 ± 2.3% | 1.481 | 5.622 | 35.434 | 2.361 | 18.407 |
| hex: http/html-16kx64 | 2097280 | 35270.3 ± 1.1% | 13969.3 ± 0.4% | 3396.2 ± 0.3% | 511.7 ± 0.2% | 8639.5 ± 0.8% | 1069.0 ± 2.6% | 2.525 | 10.385 | 68.932 | 4.082 | 32.992 |
| hex: http/html-1m | 524290 | 48686.2 ± 0.4% | 15089.7 ± 0.4% | 3493.3 ± 0.6% | 507.5 ± 0.5% | 8898.4 ± 1.1% | 1117.0 ± 3.9% | 3.226 | 13.937 | 95.931 | 5.471 | 43.587 |
| hex: http/json-1kx1024 | 2099200 | 17814.2 ± 3.8% | 12524.5 ± 2.9% | 3174.5 ± 0.5% | 670.8 ± 1.2% | 7577.6 ± 0.7% | 962.1 ± 0.8% | 1.422 | 5.612 | 26.557 | 2.351 | 18.515 |
| hex: http/json-16kx64 | 2097280 | 33996.7 ± 0.4% | 13995.3 ± 2.7% | 3387.8 ± 0.3% | 682.8 ± 2.4% | 8484.5 ± 1.0% | 1073.2 ± 2.6% | 2.429 | 10.035 | 49.790 | 4.007 | 31.678 |
| hex: http/json-1m | 524290 | 45712.7 ± 0.3% | 15092.0 ± 0.3% | 3509.8 ± 0.5% | 702.1 ± 0.9% | 8917.8 ± 3.2% | 1110.1 ± 1.6% | 3.029 | 13.024 | 65.105 | 5.126 | 41.179 |
| hex: http/js-1kx1024 | 2099200 | 17924.0 ± 1.3% | 12180.7 ± 1.2% | 3186.5 ± 0.3% | 487.8 ± 0.3% | 7606.5 ± 0.4% | 973.7 ± 1.4% | 1.472 | 5.625 | 36.747 | 2.356 | 18.408 |
| hex: http/js-16kx64 | 2097280 | 35130.1 ± 1.7% | 13885.5 ± 0.4% | 3392.8 ± 0.8% | 493.0 ± 0.6% | 8565.1 ± 1.0% | 1050.0 ± 4.0% | 2.530 | 10.354 | 71.252 | 4.102 | 33.456 |
| hex: http/js-1m | 524290 | 45675.6 ± 0.8% | 15118.5 ± 0.6% | 3539.0 ± 0.2% | 511.5 ± 3.5% | 8904.3 ± 1.8% | 1113.8 ± 1.5% | 3.021 | 12.906 | 89.291 | 5.130 | 41.009 |
| hex: http/css-1kx1024 | 2099200 | 17967.8 ± 1.0% | 11889.5 ± 0.4% | 3189.4 ± 0.1% | 570.1 ± 0.6% | 7549.9 ± 1.0% | 978.3 ± 1.4% | 1.511 | 5.634 | 31.517 | 2.380 | 18.367 |
| hex: http/css-16kx64 | 2097280 | 34726.1 ± 5.9% | 13937.4 ± 1.0% | 3377.9 ± 1.0% | 579.6 ± 0.6% | 8361.5 ± 0.5% | 1073.0 ± 3.9% | 2.492 | 10.280 | 59.916 | 4.153 | 32.365 |
| hex: http/css-1m | 524290 | 46030.3 ± 1.0% | 14953.7 ± 3.2% | 3541.8 ± 0.5% | 556.1 ± 0.4% | 8867.1 ± 6.0% | 1114.5 ± 3.4% | 3.078 | 12.996 | 82.774 | 5.191 | 41.303 |
| hex: shuffled/dickens-1m | 524290 | 45506.8 ± 0.8% | 15057.9 ± 0.5% | 3485.5 ± 0.4% | 475.3 ± 0.3% | 8866.2 ± 0.6% | 1123.9 ± 4.9% | 3.022 | 13.056 | 95.749 | 5.133 | 40.491 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1734.6 ± 0.7% | 1473.5 ± 0.5% | 1025.3 ± 0.4% | 458.4 ± 0.6% | 437.9 ± 1.1% | 501.5 ± 5.5% | 1.177 | 1.692 | 3.784 | 3.962 | 3.459 |
| qlog records, JSON text sequence | 1467503 | 1640.2 ± 5.7% | 1216.4 ± 1.5% | 924.5 ± 4.3% | 437.0 ± 0.4% | 537.2 ± 0.5% | 352.2 ± 1.2% | 1.348 | 1.774 | 3.753 | 3.053 | 4.657 |
| messages: 11 string members | 1025025 | 1313.4 ± 2.7% | 1106.3 ± 0.6% | 760.7 ± 0.6% | 403.3 ± 0.7% | 410.7 ± 0.4% | 432.2 ± 1.3% | 1.187 | 1.727 | 3.257 | 3.198 | 3.039 |
| messages: 50 nested objects | 1121600 | 1978.7 ± 6.0% | 1867.9 ± 1.5% | 1336.7 ± 0.9% | 593.5 ± 1.3% | 604.8 ± 2.0% | 516.9 ± 6.3% | 1.059 | 1.480 | 3.334 | 3.272 | 3.828 |
| messages: a tree of 341 objects | 612600 | 592.2 ± 4.0% | 672.7 ± 1.0% | 576.6 ± 0.4% | 333.6 ± 1.0% | 346.6 ± 4.7% | 218.3 ± 0.4% | 0.880 | 1.027 | 1.775 | 1.709 | 2.713 |
| string: silesia/dickens | 172528 | 12871.5 ± 5.4% | 3968.5 ± 1.0% | 3081.2 ± 2.9% | 332.4 ± 1.2% | 1518.8 ± 2.6% | 1182.3 ± 1.0% | 3.243 | 4.178 | 38.722 | 8.475 | 10.887 |
| string: silesia/nci | 1075110 | 11351.2 ± 1.1% | 4751.7 ± 0.3% | 3104.4 ± 0.3% | 907.9 ± 0.8% | 1593.9 ± 2.0% | 1196.8 ± 0.8% | 2.389 | 3.656 | 12.503 | 7.122 | 9.485 |
| string: silesia/reymont | 1075159 | 5259.6 ± 2.0% | 1860.4 ± 0.6% | 1877.9 ± 2.8% | 379.9 ± 0.9% | 1308.9 ± 0.9% | 1038.8 ± 0.8% | 2.827 | 2.801 | 13.844 | 4.018 | 5.063 |
| string: silesia/samba | 97582 | 6093.5 ± 0.5% | 2711.6 ± 0.9% | 4044.3 ± 0.4% | 347.7 ± 1.8% | 1273.3 ± 0.5% | 1173.5 ± 1.2% | 2.247 | 1.507 | 17.527 | 4.785 | 5.193 |
| string: silesia/webster | 1098490 | 7044.6 ± 1.1% | 1978.5 ± 0.3% | 1748.3 ± 1.2% | 351.1 ± 1.7% | 1262.9 ± 1.5% | 601.1 ± 0.8% | 3.561 | 4.029 | 20.062 | 5.578 | 11.719 |
| string: silesia/xml | 1090118 | 10901.0 ± 0.8% | 3156.7 ± 1.4% | 2510.6 ± 1.1% | 603.4 ± 1.1% | 1711.2 ± 0.9% | 963.7 ± 1.2% | 3.453 | 4.342 | 18.066 | 6.370 | 11.312 |
| string: canterbury/alice29.txt | 159425 | 12528.6 ± 1.1% | 2892.1 ± 1.3% | 2970.2 ± 5.5% | 316.1 ± 0.7% | 1356.4 ± 0.9% | 1090.1 ± 1.8% | 4.332 | 4.218 | 39.634 | 9.236 | 11.493 |
| string: canterbury/asyoulik.txt | 132198 | 10910.1 ± 1.4% | 2111.7 ± 2.5% | 3132.4 ± 0.7% | 316.1 ± 0.7% | 1225.3 ± 1.8% | 959.7 ± 1.0% | 5.166 | 3.483 | 34.512 | 8.904 | 11.368 |
| string: canterbury/lcet10.txt | 441884 | 12643.5 ± 5.6% | 3116.8 ± 1.1% | 2561.1 ± 1.4% | 367.5 ± 1.0% | 1478.8 ± 2.5% | 1192.9 ± 0.8% | 4.057 | 4.937 | 34.403 | 8.550 | 10.599 |
| string: canterbury/plrabn12.txt | 503330 | 8890.3 ± 1.0% | 2322.2 ± 0.6% | 2105.8 ± 0.9% | 346.2 ± 1.3% | 1379.6 ± 3.0% | 1108.2 ± 0.9% | 3.828 | 4.222 | 25.682 | 6.444 | 8.022 |
| string: canterbury-large/E.coli | 1048578 | 28448.0 ± 0.8% | 16112.4 ± 1.6% | 3455.7 ± 0.8% | 1681.1 ± 0.6% | 3098.3 ± 2.1% | 1403.4 ± 0.5% | 1.766 | 8.232 | 16.922 | 9.182 | 20.271 |
| string: canterbury-large/bible.txt | 1055886 | 9547.3 ± 0.7% | 4870.4 ± 2.3% | 2989.2 ± 0.7% | 405.0 ± 3.5% | 2023.0 ± 1.1% | 1481.2 ± 0.5% | 1.960 | 3.194 | 23.572 | 4.719 | 6.446 |
| string: canterbury-large/world192.txt | 1103121 | 6619.0 ± 0.7% | 1733.4 ± 0.6% | 1857.9 ± 2.4% | 347.3 ± 1.2% | 1267.1 ± 0.6% | 963.2 ± 0.4% | 3.818 | 3.563 | 19.056 | 5.224 | 6.872 |
| string: http/html-1m | 1058582 | 9996.3 ± 0.8% | 4360.1 ± 1.7% | 2863.4 ± 1.0% | 417.5 ± 2.4% | 2026.7 ± 0.5% | 849.7 ± 0.5% | 2.293 | 3.491 | 23.942 | 4.932 | 11.765 |
| string: http/json-1m | 1190272 | 8316.4 ± 6.2% | 1585.6 ± 0.4% | 1563.4 ± 0.3% | 556.9 ± 0.3% | 1013.6 ± 0.4% | 849.0 ± 0.8% | 5.245 | 5.319 | 14.935 | 8.204 | 9.795 |
| string: http/js-1m | 1144362 | 6517.9 ± 0.9% | 1120.5 ± 1.0% | 1390.7 ± 0.4% | 333.0 ± 0.3% | 1039.1 ± 3.2% | 757.0 ± 1.0% | 5.817 | 4.687 | 19.573 | 6.272 | 8.610 |
| string: http/css-1m | 1097820 | 9300.1 ± 0.9% | 1483.7 ± 0.6% | 2276.3 ± 1.1% | 506.5 ± 0.8% | 1129.3 ± 1.4% | 875.1 ± 1.1% | 6.268 | 4.086 | 18.360 | 8.236 | 10.628 |
| string: dickens as Cyrillic and CJK | 1883069 | 5458.8 ± 0.9% | 3640.1 ± 0.9% | 490.6 ± 0.4% | 247.7 ± 0.9% | 454.9 ± 0.8% | 356.8 ± 0.8% | 1.500 | 11.126 | 22.041 | 12.000 | 15.298 |
| hex: silesia/dickens | 524290 | 42504.4 ± 1.0% | 2611.3 ± 0.3% | 1504.9 ± 0.6% | 465.1 ± 0.4% | 1573.3 ± 0.6% | 1066.7 ± 0.3% | 16.277 | 28.244 | 91.386 | 27.017 | 39.845 |
| hex: silesia/mozilla | 524290 | 43729.7 ± 0.5% | 2593.4 ± 0.2% | 1502.9 ± 1.3% | 390.4 ± 2.9% | 1547.9 ± 1.2% | 1062.3 ± 0.2% | 16.862 | 29.096 | 112.005 | 28.250 | 41.164 |
| hex: silesia/mr | 524290 | 43581.1 ± 0.3% | 2591.1 ± 0.3% | 1494.8 ± 0.5% | 595.1 ± 0.7% | 1532.4 ± 0.8% | 1066.9 ± 0.2% | 16.819 | 29.155 | 73.229 | 28.439 | 40.848 |
| hex: silesia/nci | 524290 | 43598.4 ± 1.4% | 2563.4 ± 1.1% | 1490.0 ± 1.2% | 750.4 ± 1.1% | 1547.0 ± 1.4% | 1056.7 ± 1.1% | 17.008 | 29.261 | 58.097 | 28.183 | 41.260 |
| hex: silesia/ooffice | 524290 | 43080.1 ± 1.4% | 2578.9 ± 10.0% | 1497.9 ± 0.9% | 322.2 ± 1.5% | 1552.8 ± 1.1% | 1054.0 ± 1.2% | 16.705 | 28.760 | 133.711 | 27.744 | 40.874 |
| hex: silesia/osdb | 524290 | 42032.3 ± 1.1% | 2588.1 ± 1.2% | 1500.6 ± 0.6% | 428.5 ± 1.3% | 1553.8 ± 3.9% | 1057.8 ± 1.5% | 16.241 | 28.010 | 98.084 | 27.051 | 39.734 |
| hex: silesia/reymont | 524290 | 43477.3 ± 0.3% | 2577.9 ± 0.7% | 1495.6 ± 0.7% | 480.3 ± 0.8% | 1524.8 ± 1.0% | 1061.3 ± 0.8% | 16.865 | 29.070 | 90.515 | 28.514 | 40.964 |
| hex: silesia/samba | 524290 | 43750.8 ± 0.4% | 2590.0 ± 0.7% | 1502.0 ± 0.3% | 335.5 ± 1.3% | 1536.5 ± 1.5% | 1062.3 ± 0.9% | 16.892 | 29.129 | 130.387 | 28.474 | 41.185 |
| hex: silesia/sao | 524290 | 43541.6 ± 0.5% | 2600.5 ± 0.7% | 1500.4 ± 0.9% | 271.0 ± 2.4% | 1538.2 ± 0.4% | 1066.4 ± 0.5% | 16.744 | 29.020 | 160.652 | 28.306 | 40.830 |
| hex: silesia/webster | 524290 | 44059.2 ± 0.2% | 2610.7 ± 0.2% | 1504.9 ± 0.1% | 436.4 ± 0.4% | 1568.3 ± 0.5% | 1066.3 ± 0.3% | 16.876 | 29.277 | 100.970 | 28.093 | 41.320 |
| hex: silesia/x-ray | 524290 | 43755.0 ± 0.3% | 2608.5 ± 0.7% | 1502.6 ± 0.2% | 422.2 ± 0.3% | 1542.3 ± 0.7% | 1065.8 ± 0.3% | 16.774 | 29.119 | 103.642 | 28.369 | 41.055 |
| hex: silesia/xml | 524290 | 43583.6 ± 2.1% | 2595.5 ± 0.4% | 1503.5 ± 0.3% | 690.1 ± 0.5% | 1567.1 ± 0.8% | 1065.0 ± 0.3% | 16.792 | 28.989 | 63.153 | 27.811 | 40.924 |
| hex: canterbury/alice29.txt | 304180 | 41423.4 ± 1.8% | 2599.8 ± 1.3% | 1510.7 ± 0.8% | 465.7 ± 3.3% | 1536.2 ± 1.1% | 1077.1 ± 0.4% | 15.933 | 27.419 | 88.942 | 26.965 | 38.458 |
| hex: canterbury/asyoulik.txt | 250360 | 43447.3 ± 0.4% | 2618.2 ± 0.6% | 1536.6 ± 0.8% | 457.3 ± 0.4% | 1561.9 ± 1.1% | 1082.9 ± 6.6% | 16.594 | 28.275 | 95.003 | 27.817 | 40.121 |
| hex: canterbury/cp.html | 49208 | 41407.5 ± 0.3% | 2595.5 ± 1.0% | 1523.4 ± 0.6% | 480.0 ± 0.6% | 1582.2 ± 1.5% | 1081.8 ± 0.5% | 15.954 | 27.181 | 86.267 | 26.171 | 38.277 |
| hex: canterbury/fields.c | 22302 | 41932.0 ± 1.4% | 2643.1 ± 0.6% | 1526.9 ± 0.8% | 599.6 ± 3.0% | 1599.5 ± 5.0% | 1077.5 ± 0.6% | 15.865 | 27.462 | 69.930 | 26.216 | 38.915 |
| hex: canterbury/grammar.lsp | 7444 | 39008.0 ± 1.4% | 2681.8 ± 6.4% | 1534.5 ± 1.0% | 813.1 ± 1.0% | 1605.0 ± 0.3% | 1067.6 ± 1.3% | 14.546 | 25.420 | 47.973 | 24.304 | 36.538 |
| hex: canterbury/kennedy.xls | 524290 | 43495.6 ± 0.5% | 2594.2 ± 0.3% | 1499.9 ± 0.3% | 788.4 ± 0.3% | 1563.9 ± 0.2% | 1067.5 ± 0.4% | 16.767 | 29.000 | 55.171 | 27.813 | 40.747 |
| hex: canterbury/lcet10.txt | 524290 | 43383.7 ± 1.3% | 2583.8 ± 0.7% | 1499.3 ± 0.7% | 467.7 ± 0.7% | 1549.4 ± 1.9% | 1059.5 ± 0.4% | 16.791 | 28.937 | 92.764 | 28.000 | 40.949 |
| hex: canterbury/plrabn12.txt | 524290 | 43582.5 ± 0.6% | 2598.3 ± 0.7% | 1499.4 ± 1.1% | 452.8 ± 0.8% | 1568.5 ± 1.1% | 1060.7 ± 0.7% | 16.774 | 29.067 | 96.251 | 27.785 | 41.087 |
| hex: canterbury/ptt5 | 524290 | 43555.0 ± 0.5% | 2568.0 ± 0.5% | 1494.9 ± 0.4% | 591.7 ± 0.7% | 1552.8 ± 0.8% | 1057.2 ± 0.8% | 16.961 | 29.135 | 73.605 | 28.049 | 41.198 |
| hex: canterbury/sum | 76482 | 42709.8 ± 1.5% | 2587.3 ± 1.0% | 1509.6 ± 0.4% | 559.0 ± 0.7% | 1573.1 ± 0.6% | 1077.1 ± 0.6% | 16.508 | 28.292 | 76.407 | 27.149 | 39.653 |
| hex: canterbury/xargs.1 | 8456 | 39874.2 ± 1.3% | 2676.9 ± 0.8% | 1530.7 ± 0.5% | 833.5 ± 0.7% | 1602.2 ± 5.3% | 1062.3 ± 1.3% | 14.896 | 26.050 | 47.842 | 24.886 | 37.537 |
| hex: canterbury-large/E.coli | 524290 | 41669.0 ± 1.3% | 2583.2 ± 0.3% | 1493.9 ± 5.5% | 814.9 ± 3.2% | 1560.8 ± 1.1% | 1060.3 ± 0.7% | 16.131 | 27.893 | 51.135 | 26.697 | 39.300 |
| hex: canterbury-large/bible.txt | 524290 | 43574.1 ± 1.1% | 2574.1 ± 9.7% | 1425.0 ± 5.2% | 477.3 ± 1.3% | 1542.1 ± 1.1% | 1059.7 ± 0.7% | 16.928 | 30.578 | 91.292 | 28.256 | 41.121 |
| hex: canterbury-large/world192.txt | 524290 | 42927.2 ± 3.8% | 2574.2 ± 0.8% | 1495.5 ± 0.5% | 457.4 ± 0.7% | 1529.3 ± 1.2% | 1058.2 ± 0.7% | 16.676 | 28.704 | 93.847 | 28.069 | 40.567 |
| hex: http/html-1kx1024 | 2099200 | 20436.2 ± 0.5% | 2621.6 ± 0.6% | 1444.0 ± 0.3% | 498.2 ± 0.4% | 1571.8 ± 0.6% | 1036.6 ± 0.8% | 7.795 | 14.152 | 41.024 | 13.001 | 19.714 |
| hex: http/html-16kx64 | 2097280 | 21658.6 ± 0.4% | 2227.1 ± 1.1% | 1448.4 ± 0.3% | 502.3 ± 0.5% | 1443.6 ± 0.7% | 1070.8 ± 0.3% | 9.725 | 14.954 | 43.122 | 15.003 | 20.226 |
| hex: http/html-1m | 524290 | 43294.5 ± 0.8% | 2588.1 ± 10.9% | 1497.6 ± 2.2% | 485.8 ± 3.6% | 1506.3 ± 1.3% | 1056.9 ± 0.7% | 16.729 | 28.909 | 89.119 | 28.742 | 40.965 |
| hex: http/json-1kx1024 | 2099200 | 20136.8 ± 0.4% | 2643.1 ± 1.6% | 1442.9 ± 1.3% | 690.6 ± 1.1% | 1572.0 ± 2.4% | 1039.6 ± 1.0% | 7.619 | 13.955 | 29.158 | 12.810 | 19.369 |
| hex: http/json-16kx64 | 2097280 | 21405.3 ± 0.3% | 2231.7 ± 1.8% | 1442.7 ± 0.7% | 700.6 ± 0.7% | 1436.4 ± 0.4% | 1068.4 ± 0.9% | 9.592 | 14.837 | 30.552 | 14.902 | 20.035 |
| hex: http/json-1m | 524290 | 43618.7 ± 1.0% | 2581.0 ± 9.0% | 1497.6 ± 0.5% | 735.2 ± 0.7% | 1571.7 ± 1.0% | 1065.6 ± 0.3% | 16.900 | 29.127 | 59.330 | 27.752 | 40.934 |
| hex: http/js-1kx1024 | 2099200 | 20896.8 ± 3.2% | 2651.6 ± 1.8% | 1448.8 ± 5.7% | 489.2 ± 0.4% | 1583.0 ± 0.3% | 1041.1 ± 0.4% | 7.881 | 14.423 | 42.719 | 13.201 | 20.072 |
| hex: http/js-16kx64 | 2097280 | 22150.4 ± 0.7% | 2229.9 ± 0.6% | 1449.3 ± 5.0% | 492.4 ± 4.9% | 1445.5 ± 5.3% | 1071.6 ± 6.8% | 9.933 | 15.283 | 44.988 | 15.324 | 20.671 |
| hex: http/js-1m | 524290 | 43606.0 ± 9.3% | 2596.1 ± 0.5% | 1504.5 ± 0.4% | 502.5 ± 0.3% | 1508.8 ± 0.2% | 1066.6 ± 0.4% | 16.797 | 28.984 | 86.778 | 28.901 | 40.885 |
| hex: http/css-1kx1024 | 2099200 | 20159.9 ± 0.4% | 2666.8 ± 0.6% | 1452.7 ± 0.5% | 555.1 ± 0.5% | 1584.2 ± 7.8% | 1042.5 ± 0.3% | 7.559 | 13.878 | 36.314 | 12.726 | 19.338 |
| hex: http/css-16kx64 | 2097280 | 21213.5 ± 2.4% | 2213.0 ± 0.5% | 1446.7 ± 1.4% | 560.6 ± 0.5% | 1440.5 ± 0.4% | 1067.7 ± 1.0% | 9.586 | 14.664 | 37.840 | 14.727 | 19.869 |
| hex: http/css-1m | 524290 | 43347.6 ± 1.3% | 2587.7 ± 2.6% | 1491.5 ± 1.1% | 535.6 ± 0.6% | 1559.2 ± 1.0% | 1056.7 ± 0.5% | 16.751 | 29.062 | 80.926 | 27.801 | 41.023 |
| hex: shuffled/dickens-1m | 524290 | 42195.2 ± 0.5% | 2593.5 ± 0.9% | 1498.2 ± 0.5% | 461.4 ± 0.7% | 1554.6 ± 7.7% | 1057.4 ± 0.7% | 16.270 | 28.165 | 91.455 | 27.141 | 39.905 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1794.4 ± 0.4% | 1473.5 ± 0.5% | 1025.3 ± 0.4% | 458.4 ± 0.6% | 437.9 ± 1.1% | 501.5 ± 5.5% | 1.218 | 1.750 | 3.914 | 4.098 | 3.578 |
| qlog records, JSON text sequence | 1467503 | 1709.3 ± 0.4% | 1216.4 ± 1.5% | 924.5 ± 4.3% | 437.0 ± 0.4% | 537.2 ± 0.5% | 352.2 ± 1.2% | 1.405 | 1.849 | 3.911 | 3.182 | 4.853 |
| messages: 11 string members | 1025025 | 1317.8 ± 0.5% | 1106.3 ± 0.6% | 760.7 ± 0.6% | 403.3 ± 0.7% | 410.7 ± 0.4% | 432.2 ± 1.3% | 1.191 | 1.732 | 3.268 | 3.208 | 3.049 |
| messages: 50 nested objects | 1121600 | 1988.7 ± 5.9% | 1867.9 ± 1.5% | 1336.7 ± 0.9% | 593.5 ± 1.3% | 604.8 ± 2.0% | 516.9 ± 6.3% | 1.065 | 1.488 | 3.351 | 3.288 | 3.847 |
| messages: a tree of 341 objects | 612600 | 644.1 ± 1.3% | 672.7 ± 1.0% | 576.6 ± 0.4% | 333.6 ± 1.0% | 346.6 ± 4.7% | 218.3 ± 0.4% | 0.957 | 1.117 | 1.931 | 1.858 | 2.950 |
| string: silesia/dickens | 172528 | 13452.4 ± 1.1% | 3968.5 ± 1.0% | 3081.2 ± 2.9% | 332.4 ± 1.2% | 1518.8 ± 2.6% | 1182.3 ± 1.0% | 3.390 | 4.366 | 40.470 | 8.857 | 11.378 |
| string: silesia/nci | 1075110 | 11758.3 ± 4.5% | 4751.7 ± 0.3% | 3104.4 ± 0.3% | 907.9 ± 0.8% | 1593.9 ± 2.0% | 1196.8 ± 0.8% | 2.475 | 3.788 | 12.951 | 7.377 | 9.825 |
| string: silesia/reymont | 1075159 | 5409.3 ± 1.4% | 1860.4 ± 0.6% | 1877.9 ± 2.8% | 379.9 ± 0.9% | 1308.9 ± 0.9% | 1038.8 ± 0.8% | 2.908 | 2.880 | 14.238 | 4.133 | 5.208 |
| string: silesia/samba | 97582 | 6998.7 ± 0.9% | 2711.6 ± 0.9% | 4044.3 ± 0.4% | 347.7 ± 1.8% | 1273.3 ± 0.5% | 1173.5 ± 1.2% | 2.581 | 1.731 | 20.130 | 5.496 | 5.964 |
| string: silesia/webster | 1098490 | 6948.9 ± 0.8% | 1978.5 ± 0.3% | 1748.3 ± 1.2% | 351.1 ± 1.7% | 1262.9 ± 1.5% | 601.1 ± 0.8% | 3.512 | 3.975 | 19.789 | 5.502 | 11.559 |
| string: silesia/xml | 1090118 | 11363.7 ± 1.0% | 3156.7 ± 1.4% | 2510.6 ± 1.1% | 603.4 ± 1.1% | 1711.2 ± 0.9% | 963.7 ± 1.2% | 3.600 | 4.526 | 18.832 | 6.641 | 11.792 |
| string: canterbury/alice29.txt | 159425 | 13128.1 ± 1.4% | 2892.1 ± 1.3% | 2970.2 ± 5.5% | 316.1 ± 0.7% | 1356.4 ± 0.9% | 1090.1 ± 1.8% | 4.539 | 4.420 | 41.531 | 9.678 | 12.043 |
| string: canterbury/asyoulik.txt | 132198 | 11311.5 ± 8.4% | 2111.7 ± 2.5% | 3132.4 ± 0.7% | 316.1 ± 0.7% | 1225.3 ± 1.8% | 959.7 ± 1.0% | 5.356 | 3.611 | 35.782 | 9.231 | 11.786 |
| string: canterbury/lcet10.txt | 441884 | 12593.9 ± 5.4% | 3116.8 ± 1.1% | 2561.1 ± 1.4% | 367.5 ± 1.0% | 1478.8 ± 2.5% | 1192.9 ± 0.8% | 4.041 | 4.917 | 34.268 | 8.516 | 10.557 |
| string: canterbury/plrabn12.txt | 503330 | 8966.1 ± 3.8% | 2322.2 ± 0.6% | 2105.8 ± 0.9% | 346.2 ± 1.3% | 1379.6 ± 3.0% | 1108.2 ± 0.9% | 3.861 | 4.258 | 25.901 | 6.499 | 8.091 |
| string: canterbury-large/E.coli | 1048578 | 28515.6 ± 0.9% | 16112.4 ± 1.6% | 3455.7 ± 0.8% | 1681.1 ± 0.6% | 3098.3 ± 2.1% | 1403.4 ± 0.5% | 1.770 | 8.252 | 16.963 | 9.204 | 20.319 |
| string: canterbury-large/bible.txt | 1055886 | 9788.8 ± 1.0% | 4870.4 ± 2.3% | 2989.2 ± 0.7% | 405.0 ± 3.5% | 2023.0 ± 1.1% | 1481.2 ± 0.5% | 2.010 | 3.275 | 24.169 | 4.839 | 6.609 |
| string: canterbury-large/world192.txt | 1103121 | 6467.0 ± 0.9% | 1733.4 ± 0.6% | 1857.9 ± 2.4% | 347.3 ± 1.2% | 1267.1 ± 0.6% | 963.2 ± 0.4% | 3.731 | 3.481 | 18.619 | 5.104 | 6.714 |
| string: http/html-1m | 1058582 | 10114.6 ± 0.4% | 4360.1 ± 1.7% | 2863.4 ± 1.0% | 417.5 ± 2.4% | 2026.7 ± 0.5% | 849.7 ± 0.5% | 2.320 | 3.532 | 24.225 | 4.991 | 11.904 |
| string: http/json-1m | 1190272 | 8450.1 ± 0.2% | 1585.6 ± 0.4% | 1563.4 ± 0.3% | 556.9 ± 0.3% | 1013.6 ± 0.4% | 849.0 ± 0.8% | 5.329 | 5.405 | 15.175 | 8.336 | 9.953 |
| string: http/js-1m | 1144362 | 6592.5 ± 1.1% | 1120.5 ± 1.0% | 1390.7 ± 0.4% | 333.0 ± 0.3% | 1039.1 ± 3.2% | 757.0 ± 1.0% | 5.883 | 4.741 | 19.797 | 6.344 | 8.708 |
| string: http/css-1m | 1097820 | 9353.3 ± 1.2% | 1483.7 ± 0.6% | 2276.3 ± 1.1% | 506.5 ± 0.8% | 1129.3 ± 1.4% | 875.1 ± 1.1% | 6.304 | 4.109 | 18.465 | 8.283 | 10.689 |
| string: dickens as Cyrillic and CJK | 1883069 | 5701.6 ± 0.7% | 3640.1 ± 0.9% | 490.6 ± 0.4% | 247.7 ± 0.9% | 454.9 ± 0.8% | 356.8 ± 0.8% | 1.566 | 11.621 | 23.021 | 12.534 | 15.979 |
| hex: silesia/dickens | 524290 | 42667.9 ± 2.9% | 2611.3 ± 0.3% | 1504.9 ± 0.6% | 465.1 ± 0.4% | 1573.3 ± 0.6% | 1066.7 ± 0.3% | 16.339 | 28.352 | 91.738 | 27.120 | 39.998 |
| hex: silesia/mozilla | 524290 | 43768.7 ± 0.3% | 2593.4 ± 0.2% | 1502.9 ± 1.3% | 390.4 ± 2.9% | 1547.9 ± 1.2% | 1062.3 ± 0.2% | 16.877 | 29.122 | 112.105 | 28.276 | 41.200 |
| hex: silesia/mr | 524290 | 43636.6 ± 0.3% | 2591.1 ± 0.3% | 1494.8 ± 0.5% | 595.1 ± 0.7% | 1532.4 ± 0.8% | 1066.9 ± 0.2% | 16.841 | 29.192 | 73.322 | 28.476 | 40.900 |
| hex: silesia/nci | 524290 | 43236.3 ± 9.3% | 2563.4 ± 1.1% | 1490.0 ± 1.2% | 750.4 ± 1.1% | 1547.0 ± 1.4% | 1056.7 ± 1.1% | 16.867 | 29.018 | 57.615 | 27.948 | 40.918 |
| hex: silesia/ooffice | 524290 | 41756.9 ± 7.6% | 2578.9 ± 10.0% | 1497.9 ± 0.9% | 322.2 ± 1.5% | 1552.8 ± 1.1% | 1054.0 ± 1.2% | 16.192 | 27.877 | 129.604 | 26.892 | 39.618 |
| hex: silesia/osdb | 524290 | 42095.2 ± 1.3% | 2588.1 ± 1.2% | 1500.6 ± 0.6% | 428.5 ± 1.3% | 1553.8 ± 3.9% | 1057.8 ± 1.5% | 16.265 | 28.052 | 98.231 | 27.092 | 39.793 |
| hex: silesia/reymont | 524290 | 43429.2 ± 1.6% | 2577.9 ± 0.7% | 1495.6 ± 0.7% | 480.3 ± 0.8% | 1524.8 ± 1.0% | 1061.3 ± 0.8% | 16.846 | 29.038 | 90.415 | 28.482 | 40.919 |
| hex: silesia/samba | 524290 | 43638.5 ± 0.7% | 2590.0 ± 0.7% | 1502.0 ± 0.3% | 335.5 ± 1.3% | 1536.5 ± 1.5% | 1062.3 ± 0.9% | 16.849 | 29.054 | 130.052 | 28.401 | 41.079 |
| hex: silesia/sao | 524290 | 43672.9 ± 4.4% | 2600.5 ± 0.7% | 1500.4 ± 0.9% | 271.0 ± 2.4% | 1538.2 ± 0.4% | 1066.4 ± 0.5% | 16.794 | 29.107 | 161.136 | 28.392 | 40.953 |
| hex: silesia/webster | 524290 | 44063.5 ± 7.7% | 2610.7 ± 0.2% | 1504.9 ± 0.1% | 436.4 ± 0.4% | 1568.3 ± 0.5% | 1066.3 ± 0.3% | 16.878 | 29.280 | 100.980 | 28.096 | 41.324 |
| hex: silesia/x-ray | 524290 | 43662.7 ± 4.4% | 2608.5 ± 0.7% | 1502.6 ± 0.2% | 422.2 ± 0.3% | 1542.3 ± 0.7% | 1065.8 ± 0.3% | 16.738 | 29.058 | 103.423 | 28.309 | 40.969 |
| hex: silesia/xml | 524290 | 43690.8 ± 0.3% | 2595.5 ± 0.4% | 1503.5 ± 0.3% | 690.1 ± 0.5% | 1567.1 ± 0.8% | 1065.0 ± 0.3% | 16.833 | 29.060 | 63.308 | 27.879 | 41.025 |
| hex: canterbury/alice29.txt | 304180 | 41363.8 ± 6.7% | 2599.8 ± 1.3% | 1510.7 ± 0.8% | 465.7 ± 3.3% | 1536.2 ± 1.1% | 1077.1 ± 0.4% | 15.910 | 27.380 | 88.815 | 26.926 | 38.402 |
| hex: canterbury/asyoulik.txt | 250360 | 43519.7 ± 0.6% | 2618.2 ± 0.6% | 1536.6 ± 0.8% | 457.3 ± 0.4% | 1561.9 ± 1.1% | 1082.9 ± 6.6% | 16.622 | 28.322 | 95.162 | 27.863 | 40.188 |
| hex: canterbury/cp.html | 49208 | 41468.8 ± 0.4% | 2595.5 ± 1.0% | 1523.4 ± 0.6% | 480.0 ± 0.6% | 1582.2 ± 1.5% | 1081.8 ± 0.5% | 15.978 | 27.221 | 86.395 | 26.209 | 38.334 |
| hex: canterbury/fields.c | 22302 | 41955.3 ± 0.7% | 2643.1 ± 0.6% | 1526.9 ± 0.8% | 599.6 ± 3.0% | 1599.5 ± 5.0% | 1077.5 ± 0.6% | 15.873 | 27.477 | 69.969 | 26.231 | 38.936 |
| hex: canterbury/grammar.lsp | 7444 | 39584.7 ± 1.6% | 2681.8 ± 6.4% | 1534.5 ± 1.0% | 813.1 ± 1.0% | 1605.0 ± 0.3% | 1067.6 ± 1.3% | 14.761 | 25.796 | 48.682 | 24.664 | 37.078 |
| hex: canterbury/kennedy.xls | 524290 | 43483.0 ± 3.1% | 2594.2 ± 0.3% | 1499.9 ± 0.3% | 788.4 ± 0.3% | 1563.9 ± 0.2% | 1067.5 ± 0.4% | 16.762 | 28.992 | 55.155 | 27.805 | 40.735 |
| hex: canterbury/lcet10.txt | 524290 | 42827.8 ± 8.6% | 2583.8 ± 0.7% | 1499.3 ± 0.7% | 467.7 ± 0.7% | 1549.4 ± 1.9% | 1059.5 ± 0.4% | 16.575 | 28.566 | 91.575 | 27.641 | 40.424 |
| hex: canterbury/plrabn12.txt | 524290 | 43531.9 ± 1.1% | 2598.3 ± 0.7% | 1499.4 ± 1.1% | 452.8 ± 0.8% | 1568.5 ± 1.1% | 1060.7 ± 0.7% | 16.754 | 29.033 | 96.139 | 27.753 | 41.040 |
| hex: canterbury/ptt5 | 524290 | 43663.8 ± 0.4% | 2568.0 ± 0.5% | 1494.9 ± 0.4% | 591.7 ± 0.7% | 1552.8 ± 0.8% | 1057.2 ± 0.8% | 17.003 | 29.208 | 73.789 | 28.119 | 41.301 |
| hex: canterbury/sum | 76482 | 42837.7 ± 0.8% | 2587.3 ± 1.0% | 1509.6 ± 0.4% | 559.0 ± 0.7% | 1573.1 ± 0.6% | 1077.1 ± 0.6% | 16.557 | 28.377 | 76.636 | 27.231 | 39.771 |
| hex: canterbury/xargs.1 | 8456 | 39799.1 ± 1.1% | 2676.9 ± 0.8% | 1530.7 ± 0.5% | 833.5 ± 0.7% | 1602.2 ± 5.3% | 1062.3 ± 1.3% | 14.868 | 26.000 | 47.751 | 24.840 | 37.466 |
| hex: canterbury-large/E.coli | 524290 | 41790.6 ± 1.2% | 2583.2 ± 0.3% | 1493.9 ± 5.5% | 814.9 ± 3.2% | 1560.8 ± 1.1% | 1060.3 ± 0.7% | 16.178 | 27.974 | 51.284 | 26.775 | 39.415 |
| hex: canterbury-large/bible.txt | 524290 | 43392.0 ± 0.9% | 2574.1 ± 9.7% | 1425.0 ± 5.2% | 477.3 ± 1.3% | 1542.1 ± 1.1% | 1059.7 ± 0.7% | 16.857 | 30.450 | 90.910 | 28.137 | 40.949 |
| hex: canterbury-large/world192.txt | 524290 | 43182.1 ± 1.3% | 2574.2 ± 0.8% | 1495.5 ± 0.5% | 457.4 ± 0.7% | 1529.3 ± 1.2% | 1058.2 ± 0.7% | 16.775 | 28.875 | 94.405 | 28.236 | 40.808 |
| hex: http/html-1kx1024 | 2099200 | 20578.0 ± 0.2% | 2621.6 ± 0.6% | 1444.0 ± 0.3% | 498.2 ± 0.4% | 1571.8 ± 0.6% | 1036.6 ± 0.8% | 7.849 | 14.250 | 41.309 | 13.092 | 19.851 |
| hex: http/html-16kx64 | 2097280 | 21700.4 ± 0.6% | 2227.1 ± 1.1% | 1448.4 ± 0.3% | 502.3 ± 0.5% | 1443.6 ± 0.7% | 1070.8 ± 0.3% | 9.744 | 14.983 | 43.205 | 15.032 | 20.265 |
| hex: http/html-1m | 524290 | 43366.2 ± 2.0% | 2588.1 ± 10.9% | 1497.6 ± 2.2% | 485.8 ± 3.6% | 1506.3 ± 1.3% | 1056.9 ± 0.7% | 16.756 | 28.957 | 89.266 | 28.789 | 41.033 |
| hex: http/json-1kx1024 | 2099200 | 20264.9 ± 0.5% | 2643.1 ± 1.6% | 1442.9 ± 1.3% | 690.6 ± 1.1% | 1572.0 ± 2.4% | 1039.6 ± 1.0% | 7.667 | 14.044 | 29.343 | 12.891 | 19.492 |
| hex: http/json-16kx64 | 2097280 | 21529.5 ± 0.5% | 2231.7 ± 1.8% | 1442.7 ± 0.7% | 700.6 ± 0.7% | 1436.4 ± 0.4% | 1068.4 ± 0.9% | 9.647 | 14.923 | 30.729 | 14.988 | 20.151 |
| hex: http/json-1m | 524290 | 43454.0 ± 0.5% | 2581.0 ± 9.0% | 1497.6 ± 0.5% | 735.2 ± 0.7% | 1571.7 ± 1.0% | 1065.6 ± 0.3% | 16.836 | 29.017 | 59.106 | 27.648 | 40.779 |
| hex: http/js-1kx1024 | 2099200 | 20995.3 ± 1.1% | 2651.6 ± 1.8% | 1448.8 ± 5.7% | 489.2 ± 0.4% | 1583.0 ± 0.3% | 1041.1 ± 0.4% | 7.918 | 14.491 | 42.921 | 13.263 | 20.167 |
| hex: http/js-16kx64 | 2097280 | 22214.0 ± 0.3% | 2229.9 ± 0.6% | 1449.3 ± 5.0% | 492.4 ± 4.9% | 1445.5 ± 5.3% | 1071.6 ± 6.8% | 9.962 | 15.327 | 45.118 | 15.368 | 20.730 |
| hex: http/js-1m | 524290 | 43720.0 ± 0.8% | 2596.1 ± 0.5% | 1504.5 ± 0.4% | 502.5 ± 0.3% | 1508.8 ± 0.2% | 1066.6 ± 0.4% | 16.840 | 29.059 | 87.005 | 28.976 | 40.991 |
| hex: http/css-1kx1024 | 2099200 | 20262.1 ± 0.4% | 2666.8 ± 0.6% | 1452.7 ± 0.5% | 555.1 ± 0.5% | 1584.2 ± 7.8% | 1042.5 ± 0.3% | 7.598 | 13.948 | 36.498 | 12.790 | 19.436 |
| hex: http/css-16kx64 | 2097280 | 21349.6 ± 2.1% | 2213.0 ± 0.5% | 1446.7 ± 1.4% | 560.6 ± 0.5% | 1440.5 ± 0.4% | 1067.7 ± 1.0% | 9.648 | 14.758 | 38.083 | 14.821 | 19.996 |
| hex: http/css-1m | 524290 | 43490.6 ± 0.9% | 2587.7 ± 2.6% | 1491.5 ± 1.1% | 535.6 ± 0.6% | 1559.2 ± 1.0% | 1056.7 ± 0.5% | 16.807 | 29.158 | 81.193 | 27.892 | 41.158 |
| hex: shuffled/dickens-1m | 524290 | 41973.1 ± 1.8% | 2593.5 ± 0.9% | 1498.2 ± 0.5% | 461.4 ± 0.7% | 1554.6 ± 7.7% | 1057.4 ± 0.7% | 16.184 | 28.017 | 90.973 | 26.998 | 39.695 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1149.3 ± 0.5% | 1501.1 ± 1.1% | 1110.2 ± 0.7% | 391.5 ± 1.3% | 671.4 ± 0.5% | 362.4 ± 2.0% | 0.766 | 1.035 | 2.936 | 1.712 | 3.171 |
| qlog records, JSON text sequence | 1467503 | 994.7 ± 0.4% | 1240.2 ± 1.5% | 1114.7 ± 0.3% | 329.4 ± 0.9% | 755.5 ± 0.8% | 317.8 ± 0.4% | 0.802 | 0.892 | 3.019 | 1.317 | 3.130 |
| messages: 11 string members | 1025025 | 942.8 ± 2.0% | 1965.4 ± 8.1% | 698.7 ± 2.2% | 335.0 ± 0.9% | 510.9 ± 1.5% | 302.7 ± 1.6% | 0.480 | 1.349 | 2.814 | 1.845 | 3.115 |
| messages: 50 nested objects | 1121600 | 1231.4 ± 1.2% | 1724.3 ± 1.6% | 1442.0 ± 1.1% | 421.8 ± 1.8% | 900.0 ± 0.7% | 418.8 ± 0.6% | 0.714 | 0.854 | 2.920 | 1.368 | 2.941 |
| messages: a tree of 341 objects | 612600 | 548.0 ± 1.0% | 835.7 ± 2.2% | 696.5 ± 0.7% | 181.2 ± 0.8% | 607.1 ± 1.3% | 207.4 ± 0.5% | 0.656 | 0.787 | 3.024 | 0.903 | 2.643 |
| string: silesia/dickens | 172528 | 6663.4 ± 0.7% | 3430.3 ± 5.9% | 2876.7 ± 1.5% | 315.4 ± 1.2% | 3073.4 ± 1.4% | 568.5 ± 2.2% | 1.943 | 2.316 | 21.130 | 2.168 | 11.722 |
| string: silesia/nci | 1075110 | 5378.9 ± 0.7% | 3891.1 ± 0.9% | 2998.1 ± 0.3% | 645.1 ± 0.6% | 3603.0 ± 0.5% | 565.0 ± 3.8% | 1.382 | 1.794 | 8.337 | 1.493 | 9.521 |
| string: silesia/reymont | 1075159 | 3494.9 ± 1.2% | 3385.4 ± 0.4% | 1943.4 ± 1.8% | 342.2 ± 0.6% | 2081.9 ± 0.6% | 490.5 ± 0.6% | 1.032 | 1.798 | 10.212 | 1.679 | 7.126 |
| string: silesia/samba | 97582 | 4007.6 ± 0.3% | 3807.4 ± 0.3% | 3055.4 ± 0.6% | 327.6 ± 0.5% | 1949.7 ± 0.5% | 420.9 ± 0.8% | 1.053 | 1.312 | 12.232 | 2.055 | 9.521 |
| string: silesia/webster | 1098490 | 4409.8 ± 0.6% | 2430.4 ± 0.4% | 1738.7 ± 0.3% | 309.6 ± 0.4% | 2075.6 ± 0.2% | 466.2 ± 1.1% | 1.814 | 2.536 | 14.245 | 2.125 | 9.458 |
| string: silesia/xml | 1090118 | 6077.2 ± 0.3% | 5010.1 ± 0.7% | 2445.8 ± 0.5% | 510.4 ± 0.5% | 3283.9 ± 0.5% | 539.6 ± 2.1% | 1.213 | 2.485 | 11.907 | 1.851 | 11.263 |
| string: canterbury/alice29.txt | 159425 | 5739.2 ± 0.9% | 2790.0 ± 1.6% | 2802.9 ± 1.7% | 298.7 ± 1.3% | 2778.6 ± 1.1% | 512.8 ± 1.1% | 2.057 | 2.048 | 19.214 | 2.065 | 11.192 |
| string: canterbury/asyoulik.txt | 132198 | 4266.0 ± 1.1% | 2594.9 ± 3.6% | 2758.3 ± 1.4% | 302.7 ± 0.9% | 2367.7 ± 1.5% | 453.4 ± 3.7% | 1.644 | 1.547 | 14.092 | 1.802 | 9.409 |
| string: canterbury/lcet10.txt | 441884 | 6634.5 ± 0.8% | 3290.0 ± 1.5% | 2345.1 ± 0.7% | 345.0 ± 0.5% | 2795.1 ± 1.4% | 568.0 ± 3.0% | 2.017 | 2.829 | 19.229 | 2.374 | 11.681 |
| string: canterbury/plrabn12.txt | 503330 | 5489.3 ± 1.4% | 3171.0 ± 0.7% | 1844.6 ± 1.5% | 322.3 ± 0.6% | 2817.2 ± 0.4% | 532.5 ± 1.3% | 1.731 | 2.976 | 17.032 | 1.949 | 10.309 |
| string: canterbury-large/E.coli | 1048578 | 33969.6 ± 0.1% | 13417.2 ± 0.3% | 3430.9 ± 0.2% | 1281.3 ± 1.3% | 8919.7 ± 4.2% | 962.4 ± 2.1% | 2.532 | 9.901 | 26.513 | 3.808 | 35.296 |
| string: canterbury-large/bible.txt | 1055886 | 8542.6 ± 0.6% | 5256.2 ± 0.7% | 2788.0 ± 5.6% | 356.4 ± 0.8% | 3870.5 ± 0.5% | 629.4 ± 2.2% | 1.625 | 3.064 | 23.970 | 2.207 | 13.572 |
| string: canterbury-large/world192.txt | 1103121 | 4137.9 ± 0.5% | 2301.6 ± 0.3% | 1770.5 ± 0.4% | 326.5 ± 0.4% | 2116.9 ± 0.2% | 467.0 ± 1.7% | 1.798 | 2.337 | 12.675 | 1.955 | 8.861 |
| string: http/html-1m | 1058582 | 8405.1 ± 6.7% | 4741.5 ± 0.6% | 2668.9 ± 3.0% | 425.3 ± 0.3% | 3633.0 ± 0.2% | 602.8 ± 2.0% | 1.773 | 3.149 | 19.763 | 2.314 | 13.943 |
| string: http/json-1m | 1190272 | 3344.9 ± 0.9% | 1250.5 ± 0.2% | 2082.4 ± 0.3% | 475.9 ± 1.0% | 1332.8 ± 1.0% | 437.9 ± 3.0% | 2.675 | 1.606 | 7.029 | 2.510 | 7.639 |
| string: http/js-1m | 1144362 | 2852.0 ± 0.1% | 1604.8 ± 0.5% | 1325.0 ± 0.2% | 325.2 ± 0.5% | 1412.5 ± 0.2% | 378.8 ± 0.7% | 1.777 | 2.152 | 8.771 | 2.019 | 7.530 |
| string: http/css-1m | 1097820 | 3303.8 ± 0.2% | 2884.5 ± 0.2% | 2271.2 ± 0.5% | 452.0 ± 0.3% | 2057.7 ± 0.6% | 440.3 ± 1.1% | 1.145 | 1.455 | 7.310 | 1.606 | 7.503 |
| string: dickens as Cyrillic and CJK | 1883069 | 5831.1 ± 0.7% | 3171.1 ± 4.5% | 662.7 ± 0.5% | 378.5 ± 1.7% | 511.2 ± 0.4% | 164.3 ± 3.8% | 1.839 | 8.798 | 15.405 | 11.407 | 35.490 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1212.1 ± 0.7% | 1243.7 ± 0.8% | 1101.0 ± 0.7% | 263.4 ± 1.1% | 480.5 ± 0.4% | 230.1 ± 2.9% | 0.975 | 1.101 | 4.602 | 2.523 | 5.267 |
| hex: silesia/dickens | 524290 | 33960.0 ± 0.2% | 15153.6 ± 0.1% | 3562.5 ± 0.3% | 479.1 ± 0.6% | 8923.1 ± 0.7% | 1139.3 ± 1.6% | 2.241 | 9.533 | 70.877 | 3.806 | 29.807 |
| hex: silesia/mozilla | 524290 | 33973.8 ± 0.5% | 15154.1 ± 0.1% | 3492.5 ± 0.2% | 431.4 ± 0.2% | 8921.5 ± 0.5% | 1136.0 ± 0.6% | 2.242 | 9.728 | 78.755 | 3.808 | 29.907 |
| hex: silesia/mr | 524290 | 33949.3 ± 0.2% | 15142.2 ± 0.2% | 3500.0 ± 0.5% | 645.5 ± 0.3% | 8918.6 ± 0.2% | 1136.7 ± 0.3% | 2.242 | 9.700 | 52.590 | 3.807 | 29.867 |
| hex: silesia/nci | 524290 | 33916.8 ± 0.3% | 15146.8 ± 0.4% | 3567.7 ± 0.3% | 803.8 ± 3.8% | 8924.6 ± 0.5% | 1133.7 ± 0.7% | 2.239 | 9.507 | 42.194 | 3.800 | 29.918 |
| hex: silesia/ooffice | 524290 | 33967.7 ± 0.3% | 15126.5 ± 3.0% | 3490.6 ± 0.2% | 345.2 ± 0.4% | 8900.4 ± 4.4% | 1134.9 ± 0.4% | 2.246 | 9.731 | 98.392 | 3.816 | 29.931 |
| hex: silesia/osdb | 524290 | 33885.4 ± 0.3% | 15126.1 ± 0.5% | 3495.3 ± 0.3% | 457.7 ± 0.9% | 8904.0 ± 0.4% | 1129.7 ± 1.1% | 2.240 | 9.695 | 74.030 | 3.806 | 29.996 |
| hex: silesia/reymont | 524290 | 33853.2 ± 0.4% | 15045.1 ± 0.4% | 3558.9 ± 0.5% | 498.9 ± 0.7% | 8876.6 ± 0.5% | 1131.4 ± 0.5% | 2.250 | 9.512 | 67.855 | 3.814 | 29.921 |
| hex: silesia/samba | 524290 | 33951.2 ± 0.2% | 15130.7 ± 0.1% | 3493.4 ± 0.3% | 367.7 ± 0.5% | 8920.0 ± 0.2% | 1136.3 ± 0.4% | 2.244 | 9.719 | 92.333 | 3.806 | 29.879 |
| hex: silesia/sao | 524290 | 33960.7 ± 0.2% | 15118.2 ± 0.3% | 3496.3 ± 0.1% | 280.4 ± 0.5% | 8907.9 ± 3.6% | 1135.3 ± 0.7% | 2.246 | 9.713 | 121.124 | 3.812 | 29.914 |
| hex: silesia/webster | 524290 | 33977.4 ± 0.1% | 15115.1 ± 0.5% | 3560.2 ± 2.1% | 451.9 ± 1.6% | 8942.0 ± 0.3% | 1136.1 ± 0.7% | 2.248 | 9.544 | 75.187 | 3.800 | 29.906 |
| hex: silesia/x-ray | 524290 | 33916.4 ± 0.3% | 15099.9 ± 0.5% | 3491.9 ± 0.4% | 426.0 ± 0.8% | 8902.6 ± 0.3% | 1133.3 ± 0.7% | 2.246 | 9.713 | 79.616 | 3.810 | 29.928 |
| hex: silesia/xml | 524290 | 33933.6 ± 0.1% | 15134.5 ± 0.5% | 3560.6 ± 0.3% | 730.0 ± 0.6% | 8924.8 ± 0.1% | 1135.1 ± 0.7% | 2.242 | 9.530 | 46.482 | 3.802 | 29.894 |
| hex: canterbury/alice29.txt | 304180 | 33822.9 ± 0.0% | 14205.7 ± 0.2% | 3566.7 ± 0.3% | 482.9 ± 0.6% | 8933.3 ± 4.6% | 1146.3 ± 0.3% | 2.381 | 9.483 | 70.046 | 3.786 | 29.506 |
| hex: canterbury/asyoulik.txt | 250360 | 33931.1 ± 0.1% | 15096.2 ± 0.1% | 3500.8 ± 0.2% | 470.8 ± 0.5% | 8923.2 ± 0.5% | 1143.2 ± 0.9% | 2.248 | 9.692 | 72.072 | 3.803 | 29.680 |
| hex: canterbury/cp.html | 49208 | 33403.5 ± 0.2% | 14444.0 ± 2.3% | 3571.4 ± 0.2% | 509.7 ± 4.5% | 9249.4 ± 2.4% | 1113.8 ± 2.5% | 2.313 | 9.353 | 65.539 | 3.611 | 29.990 |
| hex: canterbury/fields.c | 22302 | 33060.9 ± 0.2% | 17671.5 ± 0.1% | 3676.0 ± 5.2% | 566.4 ± 0.9% | 9255.6 ± 0.5% | 1096.8 ± 1.5% | 1.871 | 8.994 | 58.368 | 3.572 | 30.143 |
| hex: canterbury/grammar.lsp | 7444 | 29947.2 ± 0.1% | 17276.1 ± 0.3% | 3632.0 ± 0.2% | 743.3 ± 0.6% | 8964.3 ± 0.1% | 1058.2 ± 4.8% | 1.733 | 8.245 | 40.290 | 3.341 | 28.301 |
| hex: canterbury/kennedy.xls | 524290 | 33973.4 ± 0.2% | 15137.6 ± 0.2% | 3566.1 ± 0.2% | 760.0 ± 1.0% | 8927.8 ± 0.1% | 1119.0 ± 5.7% | 2.244 | 9.527 | 44.702 | 3.805 | 30.362 |
| hex: canterbury/lcet10.txt | 524290 | 33948.0 ± 0.7% | 15063.0 ± 0.7% | 3517.9 ± 2.1% | 480.2 ± 1.1% | 8896.5 ± 0.5% | 1124.9 ± 2.4% | 2.254 | 9.650 | 70.691 | 3.816 | 30.180 |
| hex: canterbury/plrabn12.txt | 524290 | 33964.0 ± 0.3% | 15142.4 ± 0.3% | 3556.7 ± 0.3% | 465.8 ± 0.4% | 8919.0 ± 5.6% | 1126.4 ± 0.6% | 2.243 | 9.549 | 72.909 | 3.808 | 30.152 |
| hex: canterbury/ptt5 | 524290 | 33972.0 ± 0.2% | 15143.1 ± 0.1% | 3499.0 ± 0.4% | 664.9 ± 0.2% | 8901.0 ± 5.4% | 1125.2 ± 2.8% | 2.243 | 9.709 | 51.095 | 3.817 | 30.192 |
| hex: canterbury/sum | 76482 | 33396.5 ± 0.2% | 15465.8 ± 0.2% | 3572.0 ± 0.6% | 587.6 ± 0.5% | 8924.2 ± 4.9% | 1136.8 ± 0.8% | 2.159 | 9.350 | 56.834 | 3.742 | 29.377 |
| hex: canterbury/xargs.1 | 8456 | 30390.1 ± 0.3% | 17421.4 ± 0.1% | 3565.6 ± 0.3% | 721.1 ± 1.5% | 8969.5 ± 0.1% | 1107.2 ± 2.0% | 1.744 | 8.523 | 42.142 | 3.388 | 27.447 |
| hex: canterbury-large/E.coli | 524290 | 33983.4 ± 0.2% | 15137.4 ± 0.2% | 3487.6 ± 0.5% | 961.7 ± 0.4% | 8905.4 ± 1.3% | 1096.5 ± 6.4% | 2.245 | 9.744 | 35.338 | 3.816 | 30.992 |
| hex: canterbury-large/bible.txt | 524290 | 33993.8 ± 0.1% | 15154.3 ± 0.4% | 3497.2 ± 0.4% | 500.1 ± 0.5% | 8915.6 ± 0.4% | 1119.9 ± 3.0% | 2.243 | 9.720 | 67.973 | 3.813 | 30.354 |
| hex: canterbury-large/world192.txt | 524290 | 33964.9 ± 0.3% | 15151.9 ± 0.2% | 3571.5 ± 0.3% | 468.5 ± 0.8% | 8946.5 ± 0.5% | 1137.3 ± 0.3% | 2.242 | 9.510 | 72.499 | 3.796 | 29.865 |
| hex: http/html-1kx1024 | 2099200 | 15314.4 ± 0.6% | 12101.6 ± 11.8% | 3188.1 ± 0.4% | 505.8 ± 0.6% | 7591.3 ± 0.9% | 973.7 ± 2.3% | 1.265 | 4.804 | 30.275 | 2.017 | 15.728 |
| hex: http/html-16kx64 | 2097280 | 28046.3 ± 0.7% | 13969.3 ± 0.4% | 3396.2 ± 0.3% | 511.7 ± 0.2% | 8639.5 ± 0.8% | 1069.0 ± 2.6% | 2.008 | 8.258 | 54.813 | 3.246 | 26.235 |
| hex: http/html-1m | 524290 | 33915.0 ± 0.5% | 15089.7 ± 0.4% | 3493.3 ± 0.6% | 507.5 ± 0.5% | 8898.4 ± 1.1% | 1117.0 ± 3.9% | 2.248 | 9.709 | 66.826 | 3.811 | 30.363 |
| hex: http/json-1kx1024 | 2099200 | 15217.3 ± 3.4% | 12524.5 ± 2.9% | 3174.5 ± 0.5% | 670.8 ± 1.2% | 7577.6 ± 0.7% | 962.1 ± 0.8% | 1.215 | 4.794 | 22.686 | 2.008 | 15.816 |
| hex: http/json-16kx64 | 2097280 | 27371.9 ± 0.2% | 13995.3 ± 2.7% | 3387.8 ± 0.3% | 682.8 ± 2.4% | 8484.5 ± 1.0% | 1073.2 ± 2.6% | 1.956 | 8.079 | 40.088 | 3.226 | 25.505 |
| hex: http/json-1m | 524290 | 33967.9 ± 0.2% | 15092.0 ± 0.3% | 3509.8 ± 0.5% | 702.1 ± 0.9% | 8917.8 ± 3.2% | 1110.1 ± 1.6% | 2.251 | 9.678 | 48.378 | 3.809 | 30.599 |
| hex: http/js-1kx1024 | 2099200 | 15380.7 ± 0.3% | 12180.7 ± 1.2% | 3186.5 ± 0.3% | 487.8 ± 0.3% | 7606.5 ± 0.4% | 973.7 ± 1.4% | 1.263 | 4.827 | 31.532 | 2.022 | 15.796 |
| hex: http/js-16kx64 | 2097280 | 28012.3 ± 0.3% | 13885.5 ± 0.4% | 3392.8 ± 0.8% | 493.0 ± 0.6% | 8565.1 ± 1.0% | 1050.0 ± 4.0% | 2.017 | 8.256 | 56.816 | 3.271 | 26.677 |
| hex: http/js-1m | 524290 | 33926.2 ± 0.2% | 15118.5 ± 0.6% | 3539.0 ± 0.2% | 511.5 ± 3.5% | 8904.3 ± 1.8% | 1113.8 ± 1.5% | 2.244 | 9.586 | 66.322 | 3.810 | 30.460 |
| hex: http/css-1kx1024 | 2099200 | 15334.6 ± 0.5% | 11889.5 ± 0.4% | 3189.4 ± 0.1% | 570.1 ± 0.6% | 7549.9 ± 1.0% | 978.3 ± 1.4% | 1.290 | 4.808 | 26.898 | 2.031 | 15.676 |
| hex: http/css-16kx64 | 2097280 | 27675.8 ± 1.0% | 13937.4 ± 1.0% | 3377.9 ± 1.0% | 579.6 ± 0.6% | 8361.5 ± 0.5% | 1073.0 ± 3.9% | 1.986 | 8.193 | 47.751 | 3.310 | 25.794 |
| hex: http/css-1m | 524290 | 33709.4 ± 0.5% | 14953.7 ± 3.2% | 3541.8 ± 0.5% | 556.1 ± 0.4% | 8867.1 ± 6.0% | 1114.5 ± 3.4% | 2.254 | 9.518 | 60.618 | 3.802 | 30.247 |
| hex: shuffled/dickens-1m | 524290 | 33827.8 ± 0.5% | 15057.9 ± 0.5% | 3485.5 ± 0.4% | 475.3 ± 0.3% | 8866.2 ± 0.6% | 1123.9 ± 4.9% | 2.247 | 9.705 | 71.175 | 3.815 | 30.099 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1280.4 ± 0.3% | 1501.1 ± 1.1% | 1110.2 ± 0.7% | 391.5 ± 1.3% | 671.4 ± 0.5% | 362.4 ± 2.0% | 0.853 | 1.153 | 3.271 | 1.907 | 3.533 |
| qlog records, JSON text sequence | 1467503 | 1140.9 ± 0.2% | 1240.2 ± 1.5% | 1114.7 ± 0.3% | 329.4 ± 0.9% | 755.5 ± 0.8% | 317.8 ± 0.4% | 0.920 | 1.024 | 3.463 | 1.510 | 3.590 |
| messages: 11 string members | 1025025 | 1024.8 ± 1.7% | 1965.4 ± 8.1% | 698.7 ± 2.2% | 335.0 ± 0.9% | 510.9 ± 1.5% | 302.7 ± 1.6% | 0.521 | 1.467 | 3.059 | 2.006 | 3.386 |
| messages: 50 nested objects | 1121600 | 1287.3 ± 0.7% | 1724.3 ± 1.6% | 1442.0 ± 1.1% | 421.8 ± 1.8% | 900.0 ± 0.7% | 418.8 ± 0.6% | 0.747 | 0.893 | 3.052 | 1.430 | 3.074 |
| messages: a tree of 341 objects | 612600 | 649.2 ± 1.0% | 835.7 ± 2.2% | 696.5 ± 0.7% | 181.2 ± 0.8% | 607.1 ± 1.3% | 207.4 ± 0.5% | 0.777 | 0.932 | 3.582 | 1.069 | 3.131 |
| string: silesia/dickens | 172528 | 6682.3 ± 0.7% | 3430.3 ± 5.9% | 2876.7 ± 1.5% | 315.4 ± 1.2% | 3073.4 ± 1.4% | 568.5 ± 2.2% | 1.948 | 2.323 | 21.189 | 2.174 | 11.755 |
| string: silesia/nci | 1075110 | 5397.8 ± 0.5% | 3891.1 ± 0.9% | 2998.1 ± 0.3% | 645.1 ± 0.6% | 3603.0 ± 0.5% | 565.0 ± 3.8% | 1.387 | 1.800 | 8.367 | 1.498 | 9.554 |
| string: silesia/reymont | 1075159 | 3519.5 ± 1.5% | 3385.4 ± 0.4% | 1943.4 ± 1.8% | 342.2 ± 0.6% | 2081.9 ± 0.6% | 490.5 ± 0.6% | 1.040 | 1.811 | 10.284 | 1.691 | 7.176 |
| string: silesia/samba | 97582 | 4008.2 ± 0.2% | 3807.4 ± 0.3% | 3055.4 ± 0.6% | 327.6 ± 0.5% | 1949.7 ± 0.5% | 420.9 ± 0.8% | 1.053 | 1.312 | 12.234 | 2.056 | 9.523 |
| string: silesia/webster | 1098490 | 4443.3 ± 0.4% | 2430.4 ± 0.4% | 1738.7 ± 0.3% | 309.6 ± 0.4% | 2075.6 ± 0.2% | 466.2 ± 1.1% | 1.828 | 2.556 | 14.353 | 2.141 | 9.530 |
| string: silesia/xml | 1090118 | 6108.1 ± 0.1% | 5010.1 ± 0.7% | 2445.8 ± 0.5% | 510.4 ± 0.5% | 3283.9 ± 0.5% | 539.6 ± 2.1% | 1.219 | 2.497 | 11.967 | 1.860 | 11.320 |
| string: canterbury/alice29.txt | 159425 | 5763.0 ± 1.5% | 2790.0 ± 1.6% | 2802.9 ± 1.7% | 298.7 ± 1.3% | 2778.6 ± 1.1% | 512.8 ± 1.1% | 2.066 | 2.056 | 19.294 | 2.074 | 11.239 |
| string: canterbury/asyoulik.txt | 132198 | 4256.4 ± 1.2% | 2594.9 ± 3.6% | 2758.3 ± 1.4% | 302.7 ± 0.9% | 2367.7 ± 1.5% | 453.4 ± 3.7% | 1.640 | 1.543 | 14.060 | 1.798 | 9.388 |
| string: canterbury/lcet10.txt | 441884 | 6639.6 ± 1.1% | 3290.0 ± 1.5% | 2345.1 ± 0.7% | 345.0 ± 0.5% | 2795.1 ± 1.4% | 568.0 ± 3.0% | 2.018 | 2.831 | 19.244 | 2.375 | 11.690 |
| string: canterbury/plrabn12.txt | 503330 | 5489.1 ± 0.5% | 3171.0 ± 0.7% | 1844.6 ± 1.5% | 322.3 ± 0.6% | 2817.2 ± 0.4% | 532.5 ± 1.3% | 1.731 | 2.976 | 17.031 | 1.948 | 10.308 |
| string: canterbury-large/E.coli | 1048578 | 34042.8 ± 0.5% | 13417.2 ± 0.3% | 3430.9 ± 0.2% | 1281.3 ± 1.3% | 8919.7 ± 4.2% | 962.4 ± 2.1% | 2.537 | 9.922 | 26.570 | 3.817 | 35.372 |
| string: canterbury-large/bible.txt | 1055886 | 8612.0 ± 0.7% | 5256.2 ± 0.7% | 2788.0 ± 5.6% | 356.4 ± 0.8% | 3870.5 ± 0.5% | 629.4 ± 2.2% | 1.638 | 3.089 | 24.165 | 2.225 | 13.682 |
| string: canterbury-large/world192.txt | 1103121 | 4149.9 ± 1.0% | 2301.6 ± 0.3% | 1770.5 ± 0.4% | 326.5 ± 0.4% | 2116.9 ± 0.2% | 467.0 ± 1.7% | 1.803 | 2.344 | 12.712 | 1.960 | 8.886 |
| string: http/html-1m | 1058582 | 9244.9 ± 5.4% | 4741.5 ± 0.6% | 2668.9 ± 3.0% | 425.3 ± 0.3% | 3633.0 ± 0.2% | 602.8 ± 2.0% | 1.950 | 3.464 | 21.738 | 2.545 | 15.336 |
| string: http/json-1m | 1190272 | 3337.0 ± 1.9% | 1250.5 ± 0.2% | 2082.4 ± 0.3% | 475.9 ± 1.0% | 1332.8 ± 1.0% | 437.9 ± 3.0% | 2.669 | 1.603 | 7.012 | 2.504 | 7.621 |
| string: http/js-1m | 1144362 | 2857.5 ± 0.3% | 1604.8 ± 0.5% | 1325.0 ± 0.2% | 325.2 ± 0.5% | 1412.5 ± 0.2% | 378.8 ± 0.7% | 1.781 | 2.157 | 8.788 | 2.023 | 7.544 |
| string: http/css-1m | 1097820 | 3315.2 ± 0.2% | 2884.5 ± 0.2% | 2271.2 ± 0.5% | 452.0 ± 0.3% | 2057.7 ± 0.6% | 440.3 ± 1.1% | 1.149 | 1.460 | 7.335 | 1.611 | 7.529 |
| string: dickens as Cyrillic and CJK | 1883069 | 5825.7 ± 0.3% | 3171.1 ± 4.5% | 662.7 ± 0.5% | 378.5 ± 1.7% | 511.2 ± 0.4% | 164.3 ± 3.8% | 1.837 | 8.790 | 15.390 | 11.397 | 35.457 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1210.8 ± 0.4% | 1243.7 ± 0.8% | 1101.0 ± 0.7% | 263.4 ± 1.1% | 480.5 ± 0.4% | 230.1 ± 2.9% | 0.974 | 1.100 | 4.597 | 2.520 | 5.261 |
| hex: silesia/dickens | 524290 | 33995.7 ± 0.1% | 15153.6 ± 0.1% | 3562.5 ± 0.3% | 479.1 ± 0.6% | 8923.1 ± 0.7% | 1139.3 ± 1.6% | 2.243 | 9.543 | 70.952 | 3.810 | 29.839 |
| hex: silesia/mozilla | 524290 | 33985.3 ± 0.1% | 15154.1 ± 0.1% | 3492.5 ± 0.2% | 431.4 ± 0.2% | 8921.5 ± 0.5% | 1136.0 ± 0.6% | 2.243 | 9.731 | 78.781 | 3.809 | 29.917 |
| hex: silesia/mr | 524290 | 33958.0 ± 0.1% | 15142.2 ± 0.2% | 3500.0 ± 0.5% | 645.5 ± 0.3% | 8918.6 ± 0.2% | 1136.7 ± 0.3% | 2.243 | 9.702 | 52.604 | 3.808 | 29.874 |
| hex: silesia/nci | 524290 | 33929.8 ± 0.5% | 15146.8 ± 0.4% | 3567.7 ± 0.3% | 803.8 ± 3.8% | 8924.6 ± 0.5% | 1133.7 ± 0.7% | 2.240 | 9.510 | 42.210 | 3.802 | 29.929 |
| hex: silesia/ooffice | 524290 | 33955.7 ± 0.3% | 15126.5 ± 3.0% | 3490.6 ± 0.2% | 345.2 ± 0.4% | 8900.4 ± 4.4% | 1134.9 ± 0.4% | 2.245 | 9.728 | 98.358 | 3.815 | 29.921 |
| hex: silesia/osdb | 524290 | 33925.3 ± 0.6% | 15126.1 ± 0.5% | 3495.3 ± 0.3% | 457.7 ± 0.9% | 8904.0 ± 0.4% | 1129.7 ± 1.1% | 2.243 | 9.706 | 74.117 | 3.810 | 30.031 |
| hex: silesia/reymont | 524290 | 33753.9 ± 0.3% | 15045.1 ± 0.4% | 3558.9 ± 0.5% | 498.9 ± 0.7% | 8876.6 ± 0.5% | 1131.4 ± 0.5% | 2.244 | 9.484 | 67.656 | 3.803 | 29.834 |
| hex: silesia/samba | 524290 | 33917.5 ± 0.3% | 15130.7 ± 0.1% | 3493.4 ± 0.3% | 367.7 ± 0.5% | 8920.0 ± 0.2% | 1136.3 ± 0.4% | 2.242 | 9.709 | 92.241 | 3.802 | 29.849 |
| hex: silesia/sao | 524290 | 33936.2 ± 0.2% | 15118.2 ± 0.3% | 3496.3 ± 0.1% | 280.4 ± 0.5% | 8907.9 ± 3.6% | 1135.3 ± 0.7% | 2.245 | 9.706 | 121.036 | 3.810 | 29.892 |
| hex: silesia/webster | 524290 | 33931.2 ± 0.4% | 15115.1 ± 0.5% | 3560.2 ± 2.1% | 451.9 ± 1.6% | 8942.0 ± 0.3% | 1136.1 ± 0.7% | 2.245 | 9.531 | 75.085 | 3.795 | 29.865 |
| hex: silesia/x-ray | 524290 | 33958.3 ± 0.6% | 15099.9 ± 0.5% | 3491.9 ± 0.4% | 426.0 ± 0.8% | 8902.6 ± 0.3% | 1133.3 ± 0.7% | 2.249 | 9.725 | 79.715 | 3.814 | 29.964 |
| hex: silesia/xml | 524290 | 33953.5 ± 0.3% | 15134.5 ± 0.5% | 3560.6 ± 0.3% | 730.0 ± 0.6% | 8924.8 ± 0.1% | 1135.1 ± 0.7% | 2.243 | 9.536 | 46.510 | 3.804 | 29.912 |
| hex: canterbury/alice29.txt | 304180 | 33890.4 ± 0.2% | 14205.7 ± 0.2% | 3566.7 ± 0.3% | 482.9 ± 0.6% | 8933.3 ± 4.6% | 1146.3 ± 0.3% | 2.386 | 9.502 | 70.186 | 3.794 | 29.564 |
| hex: canterbury/asyoulik.txt | 250360 | 33941.0 ± 0.2% | 15096.2 ± 0.1% | 3500.8 ± 0.2% | 470.8 ± 0.5% | 8923.2 ± 0.5% | 1143.2 ± 0.9% | 2.248 | 9.695 | 72.093 | 3.804 | 29.689 |
| hex: canterbury/cp.html | 49208 | 33396.1 ± 1.2% | 14444.0 ± 2.3% | 3571.4 ± 0.2% | 509.7 ± 4.5% | 9249.4 ± 2.4% | 1113.8 ± 2.5% | 2.312 | 9.351 | 65.525 | 3.611 | 29.984 |
| hex: canterbury/fields.c | 22302 | 33001.8 ± 0.3% | 17671.5 ± 0.1% | 3676.0 ± 5.2% | 566.4 ± 0.9% | 9255.6 ± 0.5% | 1096.8 ± 1.5% | 1.868 | 8.978 | 58.264 | 3.566 | 30.089 |
| hex: canterbury/grammar.lsp | 7444 | 29825.1 ± 0.4% | 17276.1 ± 0.3% | 3632.0 ± 0.2% | 743.3 ± 0.6% | 8964.3 ± 0.1% | 1058.2 ± 4.8% | 1.726 | 8.212 | 40.126 | 3.327 | 28.185 |
| hex: canterbury/kennedy.xls | 524290 | 33961.7 ± 0.1% | 15137.6 ± 0.2% | 3566.1 ± 0.2% | 760.0 ± 1.0% | 8927.8 ± 0.1% | 1119.0 ± 5.7% | 2.244 | 9.524 | 44.686 | 3.804 | 30.351 |
| hex: canterbury/lcet10.txt | 524290 | 33820.3 ± 0.7% | 15063.0 ± 0.7% | 3517.9 ± 2.1% | 480.2 ± 1.1% | 8896.5 ± 0.5% | 1124.9 ± 2.4% | 2.245 | 9.614 | 70.426 | 3.802 | 30.066 |
| hex: canterbury/plrabn12.txt | 524290 | 33943.6 ± 0.2% | 15142.4 ± 0.3% | 3556.7 ± 0.3% | 465.8 ± 0.4% | 8919.0 ± 5.6% | 1126.4 ± 0.6% | 2.242 | 9.544 | 72.866 | 3.806 | 30.134 |
| hex: canterbury/ptt5 | 524290 | 33963.7 ± 4.9% | 15143.1 ± 0.1% | 3499.0 ± 0.4% | 664.9 ± 0.2% | 8901.0 ± 5.4% | 1125.2 ± 2.8% | 2.243 | 9.707 | 51.082 | 3.816 | 30.184 |
| hex: canterbury/sum | 76482 | 33392.2 ± 0.2% | 15465.8 ± 0.2% | 3572.0 ± 0.6% | 587.6 ± 0.5% | 8924.2 ± 4.9% | 1136.8 ± 0.8% | 2.159 | 9.348 | 56.827 | 3.742 | 29.373 |
| hex: canterbury/xargs.1 | 8456 | 30298.6 ± 0.4% | 17421.4 ± 0.1% | 3565.6 ± 0.3% | 721.1 ± 1.5% | 8969.5 ± 0.1% | 1107.2 ± 2.0% | 1.739 | 8.497 | 42.015 | 3.378 | 27.364 |
| hex: canterbury-large/E.coli | 524290 | 33941.8 ± 0.2% | 15137.4 ± 0.2% | 3487.6 ± 0.5% | 961.7 ± 0.4% | 8905.4 ± 1.3% | 1096.5 ± 6.4% | 2.242 | 9.732 | 35.295 | 3.811 | 30.955 |
| hex: canterbury-large/bible.txt | 524290 | 33986.0 ± 0.3% | 15154.3 ± 0.4% | 3497.2 ± 0.4% | 500.1 ± 0.5% | 8915.6 ± 0.4% | 1119.9 ± 3.0% | 2.243 | 9.718 | 67.957 | 3.812 | 30.347 |
| hex: canterbury-large/world192.txt | 524290 | 33958.9 ± 0.1% | 15151.9 ± 0.2% | 3571.5 ± 0.3% | 468.5 ± 0.8% | 8946.5 ± 0.5% | 1137.3 ± 0.3% | 2.241 | 9.508 | 72.487 | 3.796 | 29.859 |
| hex: http/html-1kx1024 | 2099200 | 14898.1 ± 0.2% | 12101.6 ± 11.8% | 3188.1 ± 0.4% | 505.8 ± 0.6% | 7591.3 ± 0.9% | 973.7 ± 2.3% | 1.231 | 4.673 | 29.452 | 1.963 | 15.300 |
| hex: http/html-16kx64 | 2097280 | 28081.0 ± 0.3% | 13969.3 ± 0.4% | 3396.2 ± 0.3% | 511.7 ± 0.2% | 8639.5 ± 0.8% | 1069.0 ± 2.6% | 2.010 | 8.268 | 54.881 | 3.250 | 26.267 |
| hex: http/html-1m | 524290 | 33914.5 ± 0.2% | 15089.7 ± 0.4% | 3493.3 ± 0.6% | 507.5 ± 0.5% | 8898.4 ± 1.1% | 1117.0 ± 3.9% | 2.248 | 9.709 | 66.825 | 3.811 | 30.363 |
| hex: http/json-1kx1024 | 2099200 | 14847.7 ± 0.2% | 12524.5 ± 2.9% | 3174.5 ± 0.5% | 670.8 ± 1.2% | 7577.6 ± 0.7% | 962.1 ± 0.8% | 1.185 | 4.677 | 22.135 | 1.959 | 15.432 |
| hex: http/json-16kx64 | 2097280 | 27341.7 ± 0.4% | 13995.3 ± 2.7% | 3387.8 ± 0.3% | 682.8 ± 2.4% | 8484.5 ± 1.0% | 1073.2 ± 2.6% | 1.954 | 8.071 | 40.044 | 3.223 | 25.477 |
| hex: http/json-1m | 524290 | 33914.9 ± 0.3% | 15092.0 ± 0.3% | 3509.8 ± 0.5% | 702.1 ± 0.9% | 8917.8 ± 3.2% | 1110.1 ± 1.6% | 2.247 | 9.663 | 48.302 | 3.803 | 30.551 |
| hex: http/js-1kx1024 | 2099200 | 14964.5 ± 0.4% | 12180.7 ± 1.2% | 3186.5 ± 0.3% | 487.8 ± 0.3% | 7606.5 ± 0.4% | 973.7 ± 1.4% | 1.229 | 4.696 | 30.679 | 1.967 | 15.368 |
| hex: http/js-16kx64 | 2097280 | 27993.0 ± 0.3% | 13885.5 ± 0.4% | 3392.8 ± 0.8% | 493.0 ± 0.6% | 8565.1 ± 1.0% | 1050.0 ± 4.0% | 2.016 | 8.251 | 56.777 | 3.268 | 26.659 |
| hex: http/js-1m | 524290 | 33941.6 ± 0.4% | 15118.5 ± 0.6% | 3539.0 ± 0.2% | 511.5 ± 3.5% | 8904.3 ± 1.8% | 1113.8 ± 1.5% | 2.245 | 9.591 | 66.353 | 3.812 | 30.474 |
| hex: http/css-1kx1024 | 2099200 | 14988.8 ± 0.6% | 11889.5 ± 0.4% | 3189.4 ± 0.1% | 570.1 ± 0.6% | 7549.9 ± 1.0% | 978.3 ± 1.4% | 1.261 | 4.700 | 26.292 | 1.985 | 15.322 |
| hex: http/css-16kx64 | 2097280 | 27652.0 ± 0.5% | 13937.4 ± 1.0% | 3377.9 ± 1.0% | 579.6 ± 0.6% | 8361.5 ± 0.5% | 1073.0 ± 3.9% | 1.984 | 8.186 | 47.710 | 3.307 | 25.771 |
| hex: http/css-1m | 524290 | 33659.9 ± 0.6% | 14953.7 ± 3.2% | 3541.8 ± 0.5% | 556.1 ± 0.4% | 8867.1 ± 6.0% | 1114.5 ± 3.4% | 2.251 | 9.504 | 60.529 | 3.796 | 30.203 |
| hex: shuffled/dickens-1m | 524290 | 33851.4 ± 0.4% | 15057.9 ± 0.5% | 3485.5 ± 0.4% | 475.3 ± 0.3% | 8866.2 ± 0.6% | 1123.9 ± 4.9% | 2.248 | 9.712 | 71.225 | 3.818 | 30.120 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1495.3 ± 0.4% | 1473.5 ± 0.5% | 1025.3 ± 0.4% | 458.4 ± 0.6% | 437.9 ± 1.1% | 501.5 ± 5.5% | 1.015 | 1.458 | 3.262 | 3.415 | 2.981 |
| qlog records, JSON text sequence | 1467503 | 1364.6 ± 0.4% | 1216.4 ± 1.5% | 924.5 ± 4.3% | 437.0 ± 0.4% | 537.2 ± 0.5% | 352.2 ± 1.2% | 1.122 | 1.476 | 3.122 | 2.540 | 3.875 |
| messages: 11 string members | 1025025 | 1247.8 ± 0.4% | 1106.3 ± 0.6% | 760.7 ± 0.6% | 403.3 ± 0.7% | 410.7 ± 0.4% | 432.2 ± 1.3% | 1.128 | 1.640 | 3.094 | 3.038 | 2.887 |
| messages: 50 nested objects | 1121600 | 1625.4 ± 0.7% | 1867.9 ± 1.5% | 1336.7 ± 0.9% | 593.5 ± 1.3% | 604.8 ± 2.0% | 516.9 ± 6.3% | 0.870 | 1.216 | 2.739 | 2.688 | 3.145 |
| messages: a tree of 341 objects | 612600 | 537.4 ± 0.8% | 672.7 ± 1.0% | 576.6 ± 0.4% | 333.6 ± 1.0% | 346.6 ± 4.7% | 218.3 ± 0.4% | 0.799 | 0.932 | 1.611 | 1.550 | 2.462 |
| string: silesia/dickens | 172528 | 12878.6 ± 2.1% | 3968.5 ± 1.0% | 3081.2 ± 2.9% | 332.4 ± 1.2% | 1518.8 ± 2.6% | 1182.3 ± 1.0% | 3.245 | 4.180 | 38.743 | 8.480 | 10.893 |
| string: silesia/nci | 1075110 | 11416.1 ± 5.3% | 4751.7 ± 0.3% | 3104.4 ± 0.3% | 907.9 ± 0.8% | 1593.9 ± 2.0% | 1196.8 ± 0.8% | 2.402 | 3.677 | 12.574 | 7.162 | 9.539 |
| string: silesia/reymont | 1075159 | 5345.1 ± 1.1% | 1860.4 ± 0.6% | 1877.9 ± 2.8% | 379.9 ± 0.9% | 1308.9 ± 0.9% | 1038.8 ± 0.8% | 2.873 | 2.846 | 14.068 | 4.084 | 5.146 |
| string: silesia/samba | 97582 | 6116.5 ± 0.4% | 2711.6 ± 0.9% | 4044.3 ± 0.4% | 347.7 ± 1.8% | 1273.3 ± 0.5% | 1173.5 ± 1.2% | 2.256 | 1.512 | 17.593 | 4.803 | 5.212 |
| string: silesia/webster | 1098490 | 7114.6 ± 0.6% | 1978.5 ± 0.3% | 1748.3 ± 1.2% | 351.1 ± 1.7% | 1262.9 ± 1.5% | 601.1 ± 0.8% | 3.596 | 4.069 | 20.261 | 5.633 | 11.835 |
| string: silesia/xml | 1090118 | 11067.2 ± 1.4% | 3156.7 ± 1.4% | 2510.6 ± 1.1% | 603.4 ± 1.1% | 1711.2 ± 0.9% | 963.7 ± 1.2% | 3.506 | 4.408 | 18.341 | 6.468 | 11.484 |
| string: canterbury/alice29.txt | 159425 | 12577.3 ± 0.6% | 2892.1 ± 1.3% | 2970.2 ± 5.5% | 316.1 ± 0.7% | 1356.4 ± 0.9% | 1090.1 ± 1.8% | 4.349 | 4.234 | 39.788 | 9.272 | 11.538 |
| string: canterbury/asyoulik.txt | 132198 | 11031.2 ± 0.9% | 2111.7 ± 2.5% | 3132.4 ± 0.7% | 316.1 ± 0.7% | 1225.3 ± 1.8% | 959.7 ± 1.0% | 5.224 | 3.522 | 34.895 | 9.003 | 11.494 |
| string: canterbury/lcet10.txt | 441884 | 12910.1 ± 2.5% | 3116.8 ± 1.1% | 2561.1 ± 1.4% | 367.5 ± 1.0% | 1478.8 ± 2.5% | 1192.9 ± 0.8% | 4.142 | 5.041 | 35.128 | 8.730 | 10.822 |
| string: canterbury/plrabn12.txt | 503330 | 9091.4 ± 1.1% | 2322.2 ± 0.6% | 2105.8 ± 0.9% | 346.2 ± 1.3% | 1379.6 ± 3.0% | 1108.2 ± 0.9% | 3.915 | 4.317 | 26.263 | 6.590 | 8.204 |
| string: canterbury-large/E.coli | 1048578 | 28545.6 ± 3.4% | 16112.4 ± 1.6% | 3455.7 ± 0.8% | 1681.1 ± 0.6% | 3098.3 ± 2.1% | 1403.4 ± 0.5% | 1.772 | 8.260 | 16.980 | 9.213 | 20.341 |
| string: canterbury-large/bible.txt | 1055886 | 9639.3 ± 1.3% | 4870.4 ± 2.3% | 2989.2 ± 0.7% | 405.0 ± 3.5% | 2023.0 ± 1.1% | 1481.2 ± 0.5% | 1.979 | 3.225 | 23.800 | 4.765 | 6.508 |
| string: canterbury-large/world192.txt | 1103121 | 6683.1 ± 1.2% | 1733.4 ± 0.6% | 1857.9 ± 2.4% | 347.3 ± 1.2% | 1267.1 ± 0.6% | 963.2 ± 0.4% | 3.855 | 3.597 | 19.241 | 5.275 | 6.938 |
| string: http/html-1m | 1058582 | 10118.3 ± 0.6% | 4360.1 ± 1.7% | 2863.4 ± 1.0% | 417.5 ± 2.4% | 2026.7 ± 0.5% | 849.7 ± 0.5% | 2.321 | 3.534 | 24.234 | 4.993 | 11.908 |
| string: http/json-1m | 1190272 | 8372.0 ± 0.6% | 1585.6 ± 0.4% | 1563.4 ± 0.3% | 556.9 ± 0.3% | 1013.6 ± 0.4% | 849.0 ± 0.8% | 5.280 | 5.355 | 15.035 | 8.259 | 9.861 |
| string: http/js-1m | 1144362 | 6552.9 ± 0.8% | 1120.5 ± 1.0% | 1390.7 ± 0.4% | 333.0 ± 0.3% | 1039.1 ± 3.2% | 757.0 ± 1.0% | 5.848 | 4.712 | 19.678 | 6.306 | 8.656 |
| string: http/css-1m | 1097820 | 9386.2 ± 1.3% | 1483.7 ± 0.6% | 2276.3 ± 1.1% | 506.5 ± 0.8% | 1129.3 ± 1.4% | 875.1 ± 1.1% | 6.326 | 4.123 | 18.530 | 8.312 | 10.726 |
| string: dickens as Cyrillic and CJK | 1883069 | 5487.6 ± 2.4% | 3640.1 ± 0.9% | 490.6 ± 0.4% | 247.7 ± 0.9% | 454.9 ± 0.8% | 356.8 ± 0.8% | 1.508 | 11.185 | 22.157 | 12.063 | 15.379 |
| hex: silesia/dickens | 524290 | 42617.8 ± 0.2% | 2611.3 ± 0.3% | 1504.9 ± 0.6% | 465.1 ± 0.4% | 1573.3 ± 0.6% | 1066.7 ± 0.3% | 16.320 | 28.319 | 91.630 | 27.089 | 39.951 |
| hex: silesia/mozilla | 524290 | 43757.2 ± 0.1% | 2593.4 ± 0.2% | 1502.9 ± 1.3% | 390.4 ± 2.9% | 1547.9 ± 1.2% | 1062.3 ± 0.2% | 16.872 | 29.114 | 112.075 | 28.268 | 41.190 |
| hex: silesia/mr | 524290 | 43652.0 ± 0.3% | 2591.1 ± 0.3% | 1494.8 ± 0.5% | 595.1 ± 0.7% | 1532.4 ± 0.8% | 1066.9 ± 0.2% | 16.847 | 29.203 | 73.348 | 28.486 | 40.915 |
| hex: silesia/nci | 524290 | 43067.0 ± 2.3% | 2563.4 ± 1.1% | 1490.0 ± 1.2% | 750.4 ± 1.1% | 1547.0 ± 1.4% | 1056.7 ± 1.1% | 16.801 | 28.905 | 57.389 | 27.839 | 40.757 |
| hex: silesia/ooffice | 524290 | 43157.5 ± 2.0% | 2578.9 ± 10.0% | 1497.9 ± 0.9% | 322.2 ± 1.5% | 1552.8 ± 1.1% | 1054.0 ± 1.2% | 16.735 | 28.812 | 133.951 | 27.794 | 40.947 |
| hex: silesia/osdb | 524290 | 42082.5 ± 1.8% | 2588.1 ± 1.2% | 1500.6 ± 0.6% | 428.5 ± 1.3% | 1553.8 ± 3.9% | 1057.8 ± 1.5% | 16.260 | 28.044 | 98.201 | 27.083 | 39.781 |
| hex: silesia/reymont | 524290 | 43402.6 ± 0.7% | 2577.9 ± 0.7% | 1495.6 ± 0.7% | 480.3 ± 0.8% | 1524.8 ± 1.0% | 1061.3 ± 0.8% | 16.836 | 29.020 | 90.360 | 28.465 | 40.894 |
| hex: silesia/samba | 524290 | 43721.5 ± 0.3% | 2590.0 ± 0.7% | 1502.0 ± 0.3% | 335.5 ± 1.3% | 1536.5 ± 1.5% | 1062.3 ± 0.9% | 16.881 | 29.110 | 130.299 | 28.455 | 41.157 |
| hex: silesia/sao | 524290 | 43664.8 ± 1.0% | 2600.5 ± 0.7% | 1500.4 ± 0.9% | 271.0 ± 2.4% | 1538.2 ± 0.4% | 1066.4 ± 0.5% | 16.791 | 29.102 | 161.106 | 28.386 | 40.946 |
| hex: silesia/webster | 524290 | 44021.9 ± 1.3% | 2610.7 ± 0.2% | 1504.9 ± 0.1% | 436.4 ± 0.4% | 1568.3 ± 0.5% | 1066.3 ± 0.3% | 16.862 | 29.252 | 100.885 | 28.070 | 41.285 |
| hex: silesia/x-ray | 524290 | 43762.5 ± 0.3% | 2608.5 ± 0.7% | 1502.6 ± 0.2% | 422.2 ± 0.3% | 1542.3 ± 0.7% | 1065.8 ± 0.3% | 16.777 | 29.124 | 103.660 | 28.374 | 41.062 |
| hex: silesia/xml | 524290 | 43632.1 ± 0.2% | 2595.5 ± 0.4% | 1503.5 ± 0.3% | 690.1 ± 0.5% | 1567.1 ± 0.8% | 1065.0 ± 0.3% | 16.811 | 29.021 | 63.223 | 27.842 | 40.970 |
| hex: canterbury/alice29.txt | 304180 | 41485.3 ± 1.0% | 2599.8 ± 1.3% | 1510.7 ± 0.8% | 465.7 ± 3.3% | 1536.2 ± 1.1% | 1077.1 ± 0.4% | 15.957 | 27.460 | 89.075 | 27.005 | 38.515 |
| hex: canterbury/asyoulik.txt | 250360 | 43476.8 ± 1.0% | 2618.2 ± 0.6% | 1536.6 ± 0.8% | 457.3 ± 0.4% | 1561.9 ± 1.1% | 1082.9 ± 6.6% | 16.606 | 28.294 | 95.068 | 27.836 | 40.149 |
| hex: canterbury/cp.html | 49208 | 41435.0 ± 0.4% | 2595.5 ± 1.0% | 1523.4 ± 0.6% | 480.0 ± 0.6% | 1582.2 ± 1.5% | 1081.8 ± 0.5% | 15.964 | 27.199 | 86.324 | 26.188 | 38.303 |
| hex: canterbury/fields.c | 22302 | 42258.8 ± 0.8% | 2643.1 ± 0.6% | 1526.9 ± 0.8% | 599.6 ± 3.0% | 1599.5 ± 5.0% | 1077.5 ± 0.6% | 15.988 | 27.676 | 70.475 | 26.421 | 39.218 |
| hex: canterbury/grammar.lsp | 7444 | 40426.9 ± 1.4% | 2681.8 ± 6.4% | 1534.5 ± 1.0% | 813.1 ± 1.0% | 1605.0 ± 0.3% | 1067.6 ± 1.3% | 15.075 | 26.345 | 49.718 | 25.189 | 37.867 |
| hex: canterbury/kennedy.xls | 524290 | 43574.3 ± 0.2% | 2594.2 ± 0.3% | 1499.9 ± 0.3% | 788.4 ± 0.3% | 1563.9 ± 0.2% | 1067.5 ± 0.4% | 16.797 | 29.052 | 55.270 | 27.863 | 40.821 |
| hex: canterbury/lcet10.txt | 524290 | 43547.5 ± 1.0% | 2583.8 ± 0.7% | 1499.3 ± 0.7% | 467.7 ± 0.7% | 1549.4 ± 1.9% | 1059.5 ± 0.4% | 16.854 | 29.046 | 93.114 | 28.106 | 41.103 |
| hex: canterbury/plrabn12.txt | 524290 | 43521.5 ± 0.6% | 2598.3 ± 0.7% | 1499.4 ± 1.1% | 452.8 ± 0.8% | 1568.5 ± 1.1% | 1060.7 ± 0.7% | 16.750 | 29.026 | 96.116 | 27.747 | 41.030 |
| hex: canterbury/ptt5 | 524290 | 43663.4 ± 0.3% | 2568.0 ± 0.5% | 1494.9 ± 0.4% | 591.7 ± 0.7% | 1552.8 ± 0.8% | 1057.2 ± 0.8% | 17.003 | 29.208 | 73.788 | 28.119 | 41.301 |
| hex: canterbury/sum | 76482 | 42677.3 ± 1.2% | 2587.3 ± 1.0% | 1509.6 ± 0.4% | 559.0 ± 0.7% | 1573.1 ± 0.6% | 1077.1 ± 0.6% | 16.495 | 28.271 | 76.349 | 27.129 | 39.622 |
| hex: canterbury/xargs.1 | 8456 | 40493.5 ± 0.4% | 2676.9 ± 0.8% | 1530.7 ± 0.5% | 833.5 ± 0.7% | 1602.2 ± 5.3% | 1062.3 ± 1.3% | 15.127 | 26.454 | 48.585 | 25.273 | 38.120 |
| hex: canterbury-large/E.coli | 524290 | 41706.3 ± 1.0% | 2583.2 ± 0.3% | 1493.9 ± 5.5% | 814.9 ± 3.2% | 1560.8 ± 1.1% | 1060.3 ± 0.7% | 16.145 | 27.918 | 51.181 | 26.721 | 39.336 |
| hex: canterbury-large/bible.txt | 524290 | 43494.6 ± 2.4% | 2574.1 ± 9.7% | 1425.0 ± 5.2% | 477.3 ± 1.3% | 1542.1 ± 1.1% | 1059.7 ± 0.7% | 16.897 | 30.522 | 91.125 | 28.204 | 41.046 |
| hex: canterbury-large/world192.txt | 524290 | 43144.6 ± 1.0% | 2574.2 ± 0.8% | 1495.5 ± 0.5% | 457.4 ± 0.7% | 1529.3 ± 1.2% | 1058.2 ± 0.7% | 16.760 | 28.849 | 94.323 | 28.211 | 40.772 |
| hex: http/html-1kx1024 | 2099200 | 20557.4 ± 0.7% | 2621.6 ± 0.6% | 1444.0 ± 0.3% | 498.2 ± 0.4% | 1571.8 ± 0.6% | 1036.6 ± 0.8% | 7.842 | 14.236 | 41.267 | 13.079 | 19.831 |
| hex: http/html-16kx64 | 2097280 | 21629.8 ± 2.9% | 2227.1 ± 1.1% | 1448.4 ± 0.3% | 502.3 ± 0.5% | 1443.6 ± 0.7% | 1070.8 ± 0.3% | 9.712 | 14.934 | 43.065 | 14.983 | 20.199 |
| hex: http/html-1m | 524290 | 42785.7 ± 8.8% | 2588.1 ± 10.9% | 1497.6 ± 2.2% | 485.8 ± 3.6% | 1506.3 ± 1.3% | 1056.9 ± 0.7% | 16.532 | 28.569 | 88.071 | 28.404 | 40.484 |
| hex: http/json-1kx1024 | 2099200 | 20238.1 ± 0.6% | 2643.1 ± 1.6% | 1442.9 ± 1.3% | 690.6 ± 1.1% | 1572.0 ± 2.4% | 1039.6 ± 1.0% | 7.657 | 14.026 | 29.304 | 12.874 | 19.467 |
| hex: http/json-16kx64 | 2097280 | 21486.3 ± 0.5% | 2231.7 ± 1.8% | 1442.7 ± 0.7% | 700.6 ± 0.7% | 1436.4 ± 0.4% | 1068.4 ± 0.9% | 9.628 | 14.893 | 30.667 | 14.958 | 20.111 |
| hex: http/json-1m | 524290 | 43554.6 ± 3.9% | 2581.0 ± 9.0% | 1497.6 ± 0.5% | 735.2 ± 0.7% | 1571.7 ± 1.0% | 1065.6 ± 0.3% | 16.875 | 29.084 | 59.243 | 27.712 | 40.874 |
| hex: http/js-1kx1024 | 2099200 | 21085.1 ± 0.3% | 2651.6 ± 1.8% | 1448.8 ± 5.7% | 489.2 ± 0.4% | 1583.0 ± 0.3% | 1041.1 ± 0.4% | 7.952 | 14.553 | 43.104 | 13.320 | 20.253 |
| hex: http/js-16kx64 | 2097280 | 22223.7 ± 0.3% | 2229.9 ± 0.6% | 1449.3 ± 5.0% | 492.4 ± 4.9% | 1445.5 ± 5.3% | 1071.6 ± 6.8% | 9.966 | 15.334 | 45.137 | 15.375 | 20.739 |
| hex: http/js-1m | 524290 | 43593.7 ± 0.5% | 2596.1 ± 0.5% | 1504.5 ± 0.4% | 502.5 ± 0.3% | 1508.8 ± 0.2% | 1066.6 ± 0.4% | 16.792 | 28.975 | 86.753 | 28.893 | 40.873 |
| hex: http/css-1kx1024 | 2099200 | 20291.7 ± 0.6% | 2666.8 ± 0.6% | 1452.7 ± 0.5% | 555.1 ± 0.5% | 1584.2 ± 7.8% | 1042.5 ± 0.3% | 7.609 | 13.969 | 36.552 | 12.809 | 19.465 |
| hex: http/css-16kx64 | 2097280 | 21357.9 ± 0.4% | 2213.0 ± 0.5% | 1446.7 ± 1.4% | 560.6 ± 0.5% | 1440.5 ± 0.4% | 1067.7 ± 1.0% | 9.651 | 14.764 | 38.098 | 14.827 | 20.004 |
| hex: http/css-1m | 524290 | 43362.3 ± 1.2% | 2587.7 ± 2.6% | 1491.5 ± 1.1% | 535.6 ± 0.6% | 1559.2 ± 1.0% | 1056.7 ± 0.5% | 16.757 | 29.072 | 80.953 | 27.810 | 41.037 |
| hex: shuffled/dickens-1m | 524290 | 42001.3 ± 0.9% | 2593.5 ± 0.9% | 1498.2 ± 0.5% | 461.4 ± 0.7% | 1554.6 ± 7.7% | 1057.4 ± 0.7% | 16.195 | 28.035 | 91.034 | 27.017 | 39.722 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.918 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.868 of simdjson.
- messages: 11 string members, decoding: stdx runs at 0.541 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.773 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.924 of yyjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.790 of simdjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.948 of yyjson.
- messages: a tree of 341 objects, encoding: stdx runs at 0.880 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.766 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.802 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.892 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.480 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.714 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.854 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.656 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.787 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.903 of serde_json.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.853 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next_items: stdx runs at 0.920 of simdjson.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.521 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.747 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next_items: stdx runs at 0.893 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.777 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.932 of yyjson.
- messages: 50 nested objects, encoding through TextWriter's methods: stdx runs at 0.870 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.799 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.932 of yyjson.
