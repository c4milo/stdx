# bench-json

| Field | Value |
|---|---|
| Commit | 22f5139 |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.127.1 |
| CPU model | Intel(R) Xeon(R) 6975P-C |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1014-aws |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43657154259 |
| Date | 2026-11-15 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1383.1 ± 0.7% | 0.490 | 1.017 | 1.063 | 1.059 | 0.409 | 1.074 | 1.066 | 0.368 | 0.827 | 0.942 | 0.106 |
| qlog records, JSON text sequence | 1467503 | 1086.8 ± 1.3% | 0.799 | 1.060 | 1.067 | 1.065 | 0.397 | 1.071 | 1.066 | 0.368 | 0.931 | 1.078 | 0.127 |
| string: silesia/dickens | 172528 | 6612.1 ± 3.1% | 0.029 | 0.704 | 1.109 | 1.113 | 0.199 | 1.044 | 1.134 | 0.199 | 0.975 | 0.984 | 0.029 |
| string: silesia/nci | 1075110 | 5399.8 ± 0.9% | 0.036 | 0.712 | 1.037 | 1.036 | 0.287 | 1.036 | 1.030 | 0.287 | 1.005 | 1.005 | 0.036 |
| string: silesia/reymont | 1075159 | 3491.5 ± 2.8% | 0.055 | 0.631 | 0.878 | 0.871 | 0.345 | 0.821 | 0.875 | 0.349 | 0.983 | 0.988 | 0.056 |
| string: silesia/samba | 97582 | 3993.6 ± 0.8% | 0.041 | 0.903 | 1.062 | 1.062 | 0.074 | 0.859 | 1.064 | 0.075 | 1.005 | 1.006 | 0.041 |
| string: silesia/webster | 1098490 | 4402.4 ± 0.4% | 0.043 | 0.652 | 0.981 | 0.989 | 0.212 | 0.927 | 0.995 | 0.213 | 1.003 | 1.009 | 0.043 |
| string: silesia/xml | 1090118 | 6061.2 ± 1.1% | 0.032 | 0.776 | 0.951 | 0.960 | 0.244 | 0.950 | 0.962 | 0.244 | 0.998 | 1.002 | 0.032 |
| string: canterbury/alice29.txt | 159425 | 5721.6 ± 1.4% | 0.033 | 0.746 | 1.087 | 1.118 | 0.173 | 1.021 | 1.137 | 0.173 | 0.995 | 1.003 | 0.033 |
| string: canterbury/asyoulik.txt | 132198 | 4292.4 ± 1.1% | 0.042 | 0.813 | 1.134 | 1.130 | 0.189 | 1.065 | 1.142 | 0.190 | 0.993 | 1.006 | 0.043 |
| string: canterbury/lcet10.txt | 441884 | 6694.8 ± 0.4% | 0.029 | 0.606 | 1.094 | 1.102 | 0.189 | 1.040 | 1.114 | 0.189 | 0.997 | 1.003 | 0.029 |
| string: canterbury/plrabn12.txt | 503330 | 5455.1 ± 0.5% | 0.035 | 0.777 | 0.973 | 0.975 | 0.212 | 0.869 | 0.978 | 0.213 | 1.001 | 1.001 | 0.035 |
| string: canterbury-large/E.coli | 1048578 | 29011.7 ± 1.4% | 0.062 | 1.002 | 0.776 | 1.003 | 0.542 | 1.003 | 1.002 | 0.544 | 1.176 | 1.170 | 0.007 |
| string: canterbury-large/bible.txt | 1055886 | 8492.7 ± 1.4% | 0.024 | 0.623 | 0.877 | 0.876 | 0.386 | 0.888 | 0.898 | 0.382 | 1.006 | 1.008 | 0.024 |
| string: canterbury-large/world192.txt | 1103121 | 4148.8 ± 0.1% | 0.046 | 0.688 | 0.973 | 0.979 | 0.204 | 0.930 | 0.984 | 0.205 | 1.001 | 1.006 | 0.046 |
| string: http/html-1m | 1058582 | 9017.6 ± 3.6% | 0.022 | 0.566 | 0.791 | 0.796 | 0.315 | 0.759 | 0.804 | 0.315 | 0.968 | 1.059 | 0.022 |
| string: http/json-1m | 1190272 | 3243.7 ± 0.9% | 0.054 | 0.404 | 0.453 | 0.453 | 0.147 | 0.468 | 0.453 | 0.146 | 0.997 | 1.001 | 0.054 |
| string: http/js-1m | 1144362 | 2873.3 ± 0.5% | 0.062 | 0.695 | 0.886 | 0.916 | 0.184 | 0.845 | 0.919 | 0.184 | 1.006 | 1.006 | 0.062 |
| string: http/css-1m | 1097820 | 3289.0 ± 1.1% | 0.056 | 0.769 | 0.944 | 0.975 | 0.280 | 0.957 | 0.973 | 0.280 | 1.004 | 1.009 | 0.055 |
| string: dickens as Cyrillic and CJK | 1883069 | 5761.2 ± 1.2% | 0.026 | 0.059 | 0.442 | 0.440 | 0.197 | 0.432 | 0.441 | 0.196 | 1.002 | 1.006 | 0.025 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1185.1 ± 0.6% | 0.113 | 1.002 | 1.009 | 1.010 | 0.108 | 0.721 | 1.010 | 0.107 | 1.007 | 1.016 | 0.113 |
| hex: silesia/dickens | 524290 | 45665.7 ± 1.1% | 0.040 | 0.992 | 0.622 | 0.998 | 0.393 | 0.996 | 0.989 | 0.394 | 0.741 | 0.740 | 0.005 |
| hex: silesia/mozilla | 524290 | 45056.3 ± 0.9% | 0.041 | 0.993 | 0.639 | 0.990 | 0.396 | 0.991 | 0.993 | 0.397 | 0.750 | 0.751 | 0.005 |
| hex: silesia/mr | 524290 | 44010.9 ± 1.8% | 0.041 | 0.993 | 0.609 | 0.998 | 0.388 | 0.999 | 0.996 | 0.389 | 0.766 | 0.767 | 0.005 |
| hex: silesia/nci | 524290 | 45663.0 ± 2.0% | 0.040 | 0.997 | 0.621 | 1.005 | 0.394 | 1.002 | 1.003 | 0.395 | 0.739 | 0.743 | 0.005 |
| hex: silesia/ooffice | 524290 | 34998.9 ± 0.9% | 0.052 | 1.001 | 0.717 | 1.001 | 0.475 | 1.001 | 1.005 | 0.475 | 0.964 | 0.966 | 0.006 |
| hex: silesia/osdb | 524290 | 41801.0 ± 1.0% | 0.044 | 1.000 | 0.654 | 1.004 | 0.408 | 1.005 | 1.001 | 0.410 | 0.809 | 0.809 | 0.005 |
| hex: silesia/reymont | 524290 | 45188.3 ± 1.8% | 0.040 | 1.004 | 0.633 | 1.005 | 0.395 | 0.993 | 0.993 | 0.397 | 0.746 | 0.747 | 0.005 |
| hex: silesia/samba | 524290 | 46360.0 ± 1.5% | 0.039 | 0.994 | 0.612 | 0.998 | 0.388 | 0.992 | 0.998 | 0.388 | 0.728 | 0.728 | 0.005 |
| hex: silesia/sao | 524290 | 48269.7 ± 2.3% | 0.038 | 0.993 | 0.589 | 0.989 | 0.374 | 0.994 | 0.997 | 0.373 | 0.701 | 0.702 | 0.004 |
| hex: silesia/webster | 524290 | 38158.9 ± 0.9% | 0.048 | 1.006 | 0.659 | 1.003 | 0.452 | 1.000 | 1.000 | 0.453 | 0.886 | 0.890 | 0.006 |
| hex: silesia/x-ray | 524290 | 40486.8 ± 1.0% | 0.045 | 1.005 | 0.651 | 1.006 | 0.434 | 1.007 | 1.010 | 0.436 | 0.832 | 0.839 | 0.005 |
| hex: silesia/xml | 524290 | 45381.9 ± 1.9% | 0.040 | 0.999 | 0.629 | 0.997 | 0.397 | 0.998 | 1.000 | 0.397 | 0.744 | 0.743 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 45451.6 ± 1.9% | 0.040 | 1.002 | 0.628 | 1.001 | 0.392 | 1.003 | 1.002 | 0.392 | 0.742 | 0.739 | 0.005 |
| hex: canterbury/asyoulik.txt | 250360 | 45376.5 ± 1.2% | 0.040 | 0.996 | 0.611 | 1.000 | 0.394 | 0.997 | 0.996 | 0.395 | 0.741 | 0.740 | 0.005 |
| hex: canterbury/cp.html | 49208 | 45467.0 ± 1.1% | 0.040 | 1.004 | 0.608 | 1.000 | 0.387 | 1.006 | 1.000 | 0.389 | 0.732 | 0.734 | 0.005 |
| hex: canterbury/fields.c | 22302 | 48728.1 ± 0.9% | 0.038 | 1.033 | 0.558 | 1.009 | 0.405 | 1.000 | 1.011 | 0.414 | 0.673 | 0.672 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 43301.9 ± 2.0% | 0.042 | 0.983 | 0.585 | 1.009 | 0.416 | 0.994 | 1.011 | 0.437 | 0.686 | 0.683 | 0.005 |
| hex: canterbury/kennedy.xls | 524290 | 46117.8 ± 1.5% | 0.040 | 0.999 | 0.615 | 0.995 | 0.388 | 0.998 | 0.998 | 0.389 | 0.731 | 0.731 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 45159.4 ± 1.2% | 0.040 | 0.997 | 0.627 | 0.999 | 0.397 | 0.996 | 0.997 | 0.398 | 0.749 | 0.746 | 0.005 |
| hex: canterbury/plrabn12.txt | 524290 | 46641.1 ± 2.1% | 0.039 | 0.989 | 0.610 | 0.995 | 0.376 | 0.993 | 0.997 | 0.378 | 0.725 | 0.726 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 46394.8 ± 1.2% | 0.039 | 0.996 | 0.604 | 0.997 | 0.386 | 0.995 | 0.994 | 0.387 | 0.729 | 0.730 | 0.005 |
| hex: canterbury/sum | 76482 | 45926.9 ± 0.8% | 0.040 | 1.002 | 0.602 | 0.998 | 0.385 | 1.000 | 1.002 | 0.387 | 0.723 | 0.724 | 0.005 |
| hex: canterbury/xargs.1 | 8456 | 44080.7 ± 2.3% | 0.042 | 0.986 | 0.584 | 1.021 | 0.418 | 1.002 | 1.014 | 0.439 | 0.683 | 0.682 | 0.005 |
| hex: canterbury-large/E.coli | 524290 | 44970.2 ± 1.8% | 0.041 | 1.006 | 0.634 | 1.000 | 0.400 | 1.003 | 1.004 | 0.400 | 0.751 | 0.751 | 0.005 |
| hex: canterbury-large/bible.txt | 524290 | 45442.4 ± 2.2% | 0.040 | 0.999 | 0.618 | 0.999 | 0.394 | 0.999 | 0.998 | 0.394 | 0.742 | 0.746 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 45481.4 ± 0.4% | 0.040 | 0.997 | 0.632 | 0.996 | 0.397 | 0.996 | 0.999 | 0.396 | 0.747 | 0.746 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 16972.8 ± 1.8% | 0.106 | 1.029 | 0.817 | 0.996 | 0.595 | 1.001 | 0.996 | 0.651 | 0.875 | 0.854 | 0.012 |
| hex: http/html-16kx64 | 2097280 | 32024.7 ± 1.4% | 0.057 | 1.003 | 0.723 | 1.008 | 0.497 | 1.005 | 1.008 | 0.503 | 0.835 | 0.833 | 0.007 |
| hex: http/html-1m | 524290 | 44807.2 ± 0.9% | 0.041 | 0.998 | 0.640 | 0.997 | 0.398 | 0.997 | 0.998 | 0.401 | 0.755 | 0.755 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 17073.0 ± 0.8% | 0.106 | 1.041 | 0.821 | 1.000 | 0.614 | 1.008 | 1.000 | 0.669 | 0.874 | 0.853 | 0.012 |
| hex: http/json-16kx64 | 2097280 | 33868.1 ± 0.4% | 0.054 | 1.004 | 0.693 | 1.003 | 0.476 | 1.005 | 1.005 | 0.481 | 0.814 | 0.811 | 0.006 |
| hex: http/json-1m | 524290 | 45039.1 ± 0.4% | 0.041 | 0.998 | 0.635 | 1.000 | 0.403 | 0.998 | 0.998 | 0.403 | 0.756 | 0.755 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 16614.5 ± 1.0% | 0.109 | 1.051 | 0.828 | 1.007 | 0.626 | 1.007 | 1.009 | 0.681 | 0.889 | 0.861 | 0.013 |
| hex: http/js-16kx64 | 2097280 | 34066.6 ± 3.6% | 0.054 | 1.004 | 0.697 | 1.005 | 0.476 | 1.004 | 1.004 | 0.480 | 0.815 | 0.814 | 0.006 |
| hex: http/js-1m | 524290 | 43518.9 ± 1.0% | 0.042 | 0.997 | 0.622 | 0.999 | 0.410 | 0.997 | 0.997 | 0.410 | 0.782 | 0.782 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 16652.6 ± 3.7% | 0.109 | 1.059 | 0.835 | 1.012 | 0.609 | 1.010 | 1.011 | 0.665 | 0.887 | 0.864 | 0.013 |
| hex: http/css-16kx64 | 2097280 | 33084.0 ± 0.5% | 0.055 | 1.006 | 0.711 | 1.006 | 0.487 | 1.005 | 1.005 | 0.491 | 0.822 | 0.823 | 0.006 |
| hex: http/css-1m | 524290 | 44696.6 ± 5.8% | 0.041 | 0.996 | 0.619 | 0.999 | 0.401 | 0.997 | 1.002 | 0.400 | 0.760 | 0.754 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 44829.4 ± 1.7% | 0.041 | 0.995 | 0.636 | 1.000 | 0.397 | 0.998 | 0.996 | 0.398 | 0.754 | 0.751 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1727.9 ± 0.6% | 0.430 | 1.008 | 0.972 | 1.017 | 1.013 | 0.269 | 1.016 | 0.515 | 0.909 | 0.095 | 1.033 |
| qlog records, JSON text sequence | 1467503 | 1632.1 ± 3.8% | 0.649 | 0.974 | 0.989 | 1.020 | 0.995 | 0.237 | 1.000 | 0.442 | 0.880 | 0.108 | 1.049 |
| string: silesia/dickens | 172528 | 12019.1 ± 3.5% | 0.019 | 0.566 | 0.388 | 0.561 | 0.597 | 0.125 | 0.603 | 1.008 | 0.998 | 0.019 | 1.105 |
| string: silesia/nci | 1075110 | 10803.1 ± 1.6% | 0.021 | 0.545 | 0.388 | 0.554 | 0.542 | 0.188 | 0.539 | 1.003 | 1.004 | 0.021 | 1.069 |
| string: silesia/reymont | 1075159 | 5204.3 ± 5.1% | 0.043 | 0.585 | 0.442 | 0.578 | 0.583 | 0.271 | 0.585 | 1.000 | 1.012 | 0.043 | 1.037 |
| string: silesia/samba | 97582 | 6274.1 ± 0.4% | 0.045 | 0.901 | 0.755 | 0.909 | 0.902 | 0.118 | 0.904 | 1.002 | 1.003 | 0.045 | 1.161 |
| string: silesia/webster | 1098490 | 6573.8 ± 1.7% | 0.034 | 0.612 | 0.422 | 0.588 | 0.614 | 0.162 | 0.609 | 1.000 | 1.007 | 0.034 | 1.055 |
| string: silesia/xml | 1090118 | 9679.5 ± 1.2% | 0.024 | 0.619 | 0.514 | 0.617 | 0.622 | 0.213 | 0.622 | 1.001 | 1.010 | 0.024 | 1.139 |
| string: canterbury/alice29.txt | 159425 | 10353.9 ± 6.0% | 0.022 | 0.542 | 0.438 | 0.523 | 0.569 | 0.110 | 0.595 | 1.006 | 1.006 | 0.021 | 1.229 |
| string: canterbury/asyoulik.txt | 132198 | 10266.9 ± 3.5% | 0.021 | 0.425 | 0.356 | 0.417 | 0.442 | 0.092 | 0.453 | 0.984 | 1.031 | 0.021 | 1.125 |
| string: canterbury/lcet10.txt | 441884 | 10635.1 ± 0.9% | 0.021 | 0.649 | 0.388 | 0.640 | 0.656 | 0.136 | 0.659 | 1.000 | 1.002 | 0.021 | 1.199 |
| string: canterbury/plrabn12.txt | 503330 | 7912.1 ± 3.9% | 0.028 | 0.692 | 0.556 | 0.691 | 0.691 | 0.172 | 0.691 | 0.999 | 0.999 | 0.028 | 1.130 |
| string: canterbury-large/E.coli | 1048578 | 30930.4 ± 5.3% | 0.058 | 1.002 | 1.002 | 0.754 | 1.001 | 0.509 | 1.002 | 1.001 | 1.002 | 0.008 | 1.003 |
| string: canterbury-large/bible.txt | 1055886 | 8866.8 ± 0.7% | 0.027 | 0.811 | 0.624 | 0.808 | 0.819 | 0.416 | 0.822 | 0.998 | 1.003 | 0.027 | 1.106 |
| string: canterbury-large/world192.txt | 1103121 | 6382.4 ± 1.1% | 0.035 | 0.610 | 0.432 | 0.580 | 0.612 | 0.153 | 0.615 | 1.000 | 0.996 | 0.035 | 1.019 |
| string: http/html-1m | 1058582 | 9779.3 ± 1.4% | 0.024 | 0.655 | 0.546 | 0.653 | 0.660 | 0.317 | 0.661 | 1.004 | 1.010 | 0.024 | 1.036 |
| string: http/json-1m | 1190272 | 8015.2 ± 4.9% | 0.025 | 0.192 | 0.167 | 0.192 | 0.192 | 0.076 | 0.192 | 0.998 | 1.001 | 0.025 | 1.014 |
| string: http/js-1m | 1144362 | 6348.0 ± 1.2% | 0.033 | 0.382 | 0.323 | 0.372 | 0.381 | 0.094 | 0.382 | 0.996 | 1.005 | 0.033 | 1.045 |
| string: http/css-1m | 1097820 | 7966.5 ± 1.8% | 0.027 | 0.412 | 0.329 | 0.391 | 0.412 | 0.139 | 0.411 | 1.000 | 1.003 | 0.027 | 1.167 |
| string: dickens as Cyrillic and CJK | 1883069 | 5420.5 ± 0.5% | 0.030 | 0.463 | 0.064 | 0.460 | 0.466 | 0.208 | 0.464 | 1.001 | 1.000 | 0.031 | 1.049 |
| hex: silesia/dickens | 524290 | 43245.5 ± 0.6% | 1.002 | 0.089 | 1.002 | 0.592 | 0.996 | 0.997 | 0.997 | 0.996 | 0.991 | 0.091 | 1.003 |
| hex: silesia/mozilla | 524290 | 43057.0 ± 1.7% | 1.001 | 0.089 | 1.002 | 0.594 | 0.997 | 0.992 | 0.994 | 0.992 | 0.993 | 0.094 | 0.992 |
| hex: silesia/mr | 524290 | 42897.0 ± 0.3% | 1.001 | 0.090 | 0.999 | 0.602 | 0.996 | 0.995 | 0.995 | 0.996 | 0.995 | 0.091 | 0.997 |
| hex: silesia/nci | 524290 | 43522.0 ± 0.2% | 1.001 | 0.089 | 0.999 | 0.591 | 0.979 | 0.982 | 0.979 | 0.980 | 0.973 | 0.092 | 0.978 |
| hex: silesia/ooffice | 524290 | 42725.0 ± 0.7% | 1.002 | 0.090 | 1.000 | 0.598 | 0.995 | 0.994 | 0.995 | 0.995 | 0.995 | 0.094 | 0.995 |
| hex: silesia/osdb | 524290 | 42773.0 ± 1.4% | 1.001 | 0.090 | 1.004 | 0.601 | 1.002 | 0.997 | 0.998 | 0.998 | 0.998 | 0.095 | 0.998 |
| hex: silesia/reymont | 524290 | 42678.5 ± 0.8% | 1.004 | 0.090 | 1.005 | 0.604 | 0.996 | 0.998 | 0.998 | 0.997 | 0.997 | 0.096 | 0.999 |
| hex: silesia/samba | 524290 | 43459.5 ± 0.5% | 1.002 | 0.089 | 1.001 | 0.593 | 0.980 | 0.984 | 0.982 | 0.985 | 0.977 | 0.093 | 0.980 |
| hex: silesia/sao | 524290 | 42233.9 ± 0.7% | 1.002 | 0.091 | 0.999 | 0.606 | 0.984 | 0.989 | 0.985 | 0.987 | 0.980 | 0.096 | 0.989 |
| hex: silesia/webster | 524290 | 43683.5 ± 7.5% | 1.002 | 0.088 | 0.999 | 0.592 | 0.978 | 0.984 | 0.977 | 0.981 | 0.974 | 0.093 | 0.980 |
| hex: silesia/x-ray | 524290 | 43083.7 ± 1.0% | 0.999 | 0.089 | 1.001 | 0.594 | 0.995 | 0.999 | 1.004 | 0.994 | 0.998 | 0.092 | 1.004 |
| hex: silesia/xml | 524290 | 43290.8 ± 0.3% | 1.001 | 0.088 | 0.999 | 0.590 | 0.986 | 0.989 | 0.983 | 0.984 | 0.981 | 0.092 | 0.990 |
| hex: canterbury/alice29.txt | 304180 | 42798.2 ± 1.7% | 0.996 | 0.090 | 0.998 | 0.598 | 1.000 | 1.003 | 1.003 | 1.005 | 1.002 | 0.096 | 1.003 |
| hex: canterbury/asyoulik.txt | 250360 | 42910.8 ± 0.8% | 0.993 | 0.089 | 1.000 | 0.597 | 0.994 | 0.999 | 0.994 | 1.000 | 0.999 | 0.096 | 0.998 |
| hex: canterbury/cp.html | 49208 | 41912.9 ± 1.1% | 1.001 | 0.091 | 1.002 | 0.599 | 1.007 | 0.998 | 1.006 | 1.006 | 1.003 | 0.097 | 1.004 |
| hex: canterbury/fields.c | 22302 | 41346.2 ± 1.1% | 0.998 | 0.092 | 0.996 | 0.604 | 1.000 | 0.986 | 1.001 | 1.001 | 1.005 | 0.099 | 1.003 |
| hex: canterbury/grammar.lsp | 7444 | 38941.4 ± 0.8% | 0.998 | 0.097 | 1.004 | 0.610 | 1.015 | 0.983 | 1.009 | 1.009 | 1.024 | 0.103 | 1.014 |
| hex: canterbury/kennedy.xls | 524290 | 41470.0 ± 0.7% | 1.001 | 0.092 | 1.003 | 0.609 | 1.001 | 0.995 | 0.998 | 0.997 | 0.994 | 0.097 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 43275.1 ± 0.9% | 1.000 | 0.088 | 1.000 | 0.589 | 0.994 | 0.994 | 0.986 | 0.989 | 0.990 | 0.093 | 0.989 |
| hex: canterbury/plrabn12.txt | 524290 | 43324.7 ± 1.2% | 1.000 | 0.088 | 1.000 | 0.590 | 0.995 | 0.990 | 0.993 | 0.988 | 0.990 | 0.090 | 0.998 |
| hex: canterbury/ptt5 | 524290 | 43218.6 ± 1.4% | 0.996 | 0.088 | 0.998 | 0.591 | 0.995 | 0.993 | 0.990 | 0.990 | 0.991 | 0.090 | 0.988 |
| hex: canterbury/sum | 76482 | 42269.3 ± 6.4% | 1.005 | 0.090 | 1.002 | 0.597 | 1.002 | 1.001 | 1.004 | 0.999 | 1.003 | 0.097 | 1.003 |
| hex: canterbury/xargs.1 | 8456 | 39449.7 ± 4.1% | 0.986 | 0.096 | 0.990 | 0.609 | 1.007 | 0.959 | 1.000 | 0.993 | 1.025 | 0.103 | 1.005 |
| hex: canterbury-large/E.coli | 524290 | 42897.4 ± 0.8% | 0.999 | 0.089 | 0.999 | 0.595 | 0.993 | 0.995 | 0.999 | 0.995 | 0.995 | 0.093 | 0.999 |
| hex: canterbury-large/bible.txt | 524290 | 43448.9 ± 0.7% | 1.000 | 0.088 | 0.997 | 0.589 | 0.990 | 0.989 | 0.990 | 0.990 | 0.992 | 0.094 | 0.995 |
| hex: canterbury-large/world192.txt | 524290 | 43250.4 ± 1.4% | 0.995 | 0.088 | 0.995 | 0.594 | 0.994 | 0.993 | 0.991 | 0.993 | 0.992 | 0.092 | 0.991 |
| hex: http/html-1kx1024 | 2099200 | 20619.7 ± 0.3% | 1.003 | 0.178 | 1.005 | 0.927 | 1.001 | 1.002 | 1.004 | 1.003 | 1.004 | 0.185 | 1.005 |
| hex: http/html-16kx64 | 2097280 | 21553.1 ± 0.4% | 1.001 | 0.175 | 1.001 | 0.974 | 0.985 | 1.001 | 1.000 | 1.003 | 1.004 | 0.190 | 1.003 |
| hex: http/html-1m | 524290 | 40158.0 ± 0.8% | 1.001 | 0.096 | 1.001 | 0.641 | 0.990 | 0.992 | 0.990 | 0.991 | 0.989 | 0.100 | 0.990 |
| hex: http/json-1kx1024 | 2099200 | 20654.7 ± 0.4% | 1.002 | 0.177 | 1.002 | 0.926 | 1.003 | 0.999 | 1.004 | 1.003 | 1.004 | 0.186 | 1.005 |
| hex: http/json-16kx64 | 2097280 | 22449.2 ± 0.4% | 1.003 | 0.168 | 1.004 | 0.947 | 1.002 | 1.001 | 1.003 | 1.002 | 1.003 | 0.182 | 1.003 |
| hex: http/json-1m | 524290 | 43001.2 ± 0.4% | 1.003 | 0.089 | 1.000 | 0.596 | 0.994 | 0.994 | 0.994 | 0.994 | 0.993 | 0.094 | 0.993 |
| hex: http/js-1kx1024 | 2099200 | 19964.4 ± 0.8% | 1.001 | 0.184 | 1.003 | 0.951 | 1.003 | 1.008 | 1.004 | 1.003 | 1.006 | 0.192 | 1.003 |
| hex: http/js-16kx64 | 2097280 | 21049.8 ± 0.5% | 1.004 | 0.179 | 1.003 | 0.986 | 1.005 | 1.005 | 1.006 | 1.004 | 1.005 | 0.194 | 1.006 |
| hex: http/js-1m | 524290 | 42341.9 ± 0.5% | 1.004 | 0.090 | 1.005 | 0.605 | 0.990 | 0.997 | 0.999 | 1.001 | 0.994 | 0.095 | 0.998 |
| hex: http/css-1kx1024 | 2099200 | 20585.5 ± 0.3% | 1.002 | 0.177 | 1.005 | 0.922 | 1.005 | 1.001 | 1.004 | 1.004 | 1.007 | 0.184 | 1.002 |
| hex: http/css-16kx64 | 2097280 | 21582.1 ± 0.6% | 1.001 | 0.175 | 1.002 | 0.973 | 1.000 | 1.001 | 1.002 | 0.999 | 1.003 | 0.177 | 1.003 |
| hex: http/css-1m | 524290 | 43145.5 ± 0.7% | 0.999 | 0.088 | 0.998 | 0.590 | 0.992 | 0.991 | 0.993 | 0.994 | 0.993 | 0.091 | 0.992 |
| hex: shuffled/dickens-1m | 524290 | 43228.8 ± 1.2% | 1.005 | 0.088 | 1.000 | 0.591 | 0.998 | 1.002 | 1.007 | 1.005 | 1.000 | 0.094 | 1.005 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.063 of all on.
- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.059 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.074 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.066 of all on.
- qlog records, JSON text sequence, decoding: J5 UTF-8 vectors off runs at 1.060 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.067 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.065 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.071 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.066 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.109 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.113 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.134 of all on.
- string: silesia/samba, decoding: J7 wide vectors off runs at 1.062 of all on.
- string: silesia/samba, decoding: J8 decoder fast path off runs at 1.062 of all on.
- string: silesia/samba, decoding: J13 decoder escape blocks off runs at 1.064 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.087 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.118 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.137 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.134 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.130 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.065 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.142 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.094 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.102 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.114 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.051 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.059 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 167610.4 ± 0.4% | 121843.1 ± 0.6% | 1.376 | 100534.7 ± 0.5% | 1.667 |
| string: silesia/nci | 1048576 | 166686.3 ± 0.6% | 121309.5 ± 0.7% | 1.374 | 100689.9 ± 0.4% | 1.655 |
| string: silesia/reymont | 1048576 | 168319.9 ± 0.5% | 122203.8 ± 1.0% | 1.377 | 100934.2 ± 0.8% | 1.668 |
| string: silesia/samba | 65546 | 161638.0 ± 0.8% | 119455.8 ± 0.5% | 1.353 | 98879.9 ± 0.4% | 1.635 |
| string: silesia/webster | 1048576 | 130945.3 ± 0.6% | 106145.0 ± 2.8% | 1.234 | 91192.3 ± 1.7% | 1.436 |
| string: silesia/xml | 1048576 | 163449.9 ± 2.8% | 121497.0 ± 2.1% | 1.345 | 100759.1 ± 2.1% | 1.622 |
| string: canterbury/alice29.txt | 152089 | 166822.3 ± 0.8% | 121264.9 ± 0.2% | 1.376 | 100067.6 ± 0.4% | 1.667 |
| string: canterbury/asyoulik.txt | 125179 | 166488.1 ± 0.5% | 121308.2 ± 0.3% | 1.372 | 100768.5 ± 0.9% | 1.652 |
| string: canterbury/lcet10.txt | 426754 | 168664.7 ± 0.6% | 122303.0 ± 1.0% | 1.379 | 101123.3 ± 0.7% | 1.668 |
| string: canterbury/plrabn12.txt | 481861 | 167715.8 ± 0.8% | 122173.6 ± 0.3% | 1.373 | 101247.0 ± 0.4% | 1.657 |
| string: canterbury-large/E.coli | 1048576 | 168118.9 ± 0.4% | 122528.3 ± 0.5% | 1.372 | 100846.7 ± 0.5% | 1.667 |
| string: canterbury-large/bible.txt | 1048576 | 151779.6 ± 0.6% | 114692.8 ± 0.3% | 1.323 | 95792.2 ± 1.0% | 1.584 |
| string: canterbury-large/world192.txt | 1048576 | 167136.7 ± 0.9% | 121819.3 ± 0.8% | 1.372 | 100402.0 ± 0.5% | 1.665 |
| string: http/html-1m | 1048576 | 121831.1 ± 0.9% | 100440.7 ± 1.9% | 1.213 | 85696.0 ± 1.4% | 1.422 |
| string: http/json-1m | 1048576 | 117266.6 ± 0.7% | 103323.0 ± 0.2% | 1.135 | 80474.9 ± 0.4% | 1.457 |
| string: http/js-1m | 1048576 | 158202.8 ± 1.4% | 118320.9 ± 0.3% | 1.337 | 97207.6 ± 0.5% | 1.627 |
| string: http/css-1m | 1048576 | 151073.5 ± 0.8% | 114731.9 ± 0.3% | 1.317 | 96106.0 ± 0.4% | 1.572 |
| string: dickens as Cyrillic and CJK | 1847045 | 23428.3 ± 0.6% | 20459.9 ± 1.0% | 1.145 | 14841.4 ± 0.6% | 1.579 |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 163577.3 ± 1.0% | 120017.0 ± 0.3% | 1.363 | 99684.3 ± 0.2% | 1.641 |
| string: canterbury-large/bible.txt | 1048576 | 1 | 162569.9 ± 0.5% | 119651.3 ± 0.2% | 1.359 | 99177.2 ± 0.2% | 1.639 |
| string: canterbury-large/bible.txt | 1048576 | 8 | 161575.8 ± 0.9% | 119656.0 ± 4.9% | 1.350 | 99179.8 ± 0.5% | 1.629 |
| string: canterbury-large/bible.txt | 1048576 | 16 | 162239.4 ± 2.1% | 119725.8 ± 0.2% | 1.355 | 99104.2 ± 0.2% | 1.637 |
| string: canterbury-large/bible.txt | 1048576 | 32 | 163559.9 ± 0.6% | 120031.1 ± 0.4% | 1.363 | 99261.5 ± 2.4% | 1.648 |
| string: canterbury-large/bible.txt | 1048576 | 48 | 163981.1 ± 2.0% | 121073.0 ± 1.9% | 1.354 | 100530.0 ± 1.6% | 1.631 |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 24220.0 ± 0.8% | 21618.2 ± 0.1% | 1.120 | 15263.6 ± 0.5% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 24166.8 ± 0.6% | 21617.9 ± 0.6% | 1.118 | 15228.5 ± 1.1% | 1.587 |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 24160.3 ± 0.5% | 21583.7 ± 0.3% | 1.119 | 15205.6 ± 0.5% | 1.589 |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 24170.1 ± 0.2% | 21561.6 ± 0.4% | 1.121 | 15248.4 ± 0.2% | 1.585 |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 24142.3 ± 0.7% | 21577.4 ± 1.3% | 1.119 | 15195.4 ± 0.5% | 1.589 |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 24151.3 ± 0.2% | 21535.1 ± 0.7% | 1.121 | 15229.8 ± 0.3% | 1.586 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1383.1 ± 0.7% | 1501.9 ± 1.7% | 1116.3 ± 1.7% | 401.1 ± 1.1% | 665.5 ± 1.3% | 365.3 ± 2.1% | 0.921 | 1.239 | 3.449 | 2.078 | 3.787 |
| qlog records, JSON text sequence | 1467503 | 1086.8 ± 1.3% | 1229.1 ± 0.7% | 1126.2 ± 1.8% | 344.2 ± 1.7% | 747.3 ± 1.2% | 317.9 ± 1.3% | 0.884 | 0.965 | 3.157 | 1.454 | 3.418 |
| string: silesia/dickens | 172528 | 6612.1 ± 3.1% | 3458.3 ± 0.7% | 2841.0 ± 1.7% | 308.9 ± 2.0% | 3055.8 ± 1.0% | 562.1 ± 1.1% | 1.912 | 2.327 | 21.406 | 2.164 | 11.763 |
| string: silesia/nci | 1075110 | 5399.8 ± 0.9% | 3893.0 ± 0.6% | 3012.3 ± 0.8% | 642.4 ± 0.5% | 3614.8 ± 0.6% | 565.8 ± 1.3% | 1.387 | 1.793 | 8.406 | 1.494 | 9.543 |
| string: silesia/reymont | 1075159 | 3491.5 ± 2.8% | 3409.1 ± 0.6% | 1935.2 ± 1.7% | 324.8 ± 3.7% | 2082.6 ± 1.0% | 488.4 ± 2.3% | 1.024 | 1.804 | 10.749 | 1.677 | 7.148 |
| string: silesia/samba | 97582 | 3993.6 ± 0.8% | 3792.9 ± 0.7% | 3068.3 ± 4.4% | 333.5 ± 1.0% | 1895.1 ± 0.8% | 418.1 ± 1.9% | 1.053 | 1.302 | 11.974 | 2.107 | 9.552 |
| string: silesia/webster | 1098490 | 4402.4 ± 0.4% | 2443.6 ± 1.1% | 1737.8 ± 0.9% | 301.8 ± 0.5% | 2064.2 ± 0.7% | 460.2 ± 4.2% | 1.802 | 2.533 | 14.587 | 2.133 | 9.566 |
| string: silesia/xml | 1090118 | 6061.2 ± 1.1% | 4963.1 ± 1.1% | 2424.9 ± 1.0% | 503.2 ± 1.3% | 3300.1 ± 0.7% | 539.8 ± 1.3% | 1.221 | 2.500 | 12.046 | 1.837 | 11.229 |
| string: canterbury/alice29.txt | 159425 | 5721.6 ± 1.4% | 2751.6 ± 3.0% | 2790.7 ± 2.1% | 293.5 ± 1.0% | 2752.6 ± 1.6% | 513.4 ± 0.7% | 2.079 | 2.050 | 19.493 | 2.079 | 11.144 |
| string: canterbury/asyoulik.txt | 132198 | 4292.4 ± 1.1% | 2624.5 ± 3.0% | 2816.5 ± 1.2% | 298.4 ± 0.9% | 2382.0 ± 1.5% | 452.9 ± 1.5% | 1.636 | 1.524 | 14.385 | 1.802 | 9.478 |
| string: canterbury/lcet10.txt | 441884 | 6694.8 ± 0.4% | 3285.0 ± 0.4% | 2334.4 ± 0.4% | 341.3 ± 0.5% | 2774.5 ± 2.3% | 554.4 ± 2.8% | 2.038 | 2.868 | 19.618 | 2.413 | 12.075 |
| string: canterbury/plrabn12.txt | 503330 | 5455.1 ± 0.5% | 3151.4 ± 1.2% | 1839.3 ± 1.4% | 321.1 ± 1.0% | 2827.9 ± 0.4% | 530.8 ± 0.7% | 1.731 | 2.966 | 16.986 | 1.929 | 10.278 |
| string: canterbury-large/E.coli | 1048578 | 29011.7 ± 1.4% | 13034.0 ± 0.2% | 3377.8 ± 0.8% | 1282.7 ± 0.4% | 8910.1 ± 5.4% | 935.3 ± 6.5% | 2.226 | 8.589 | 22.618 | 3.256 | 31.017 |
| string: canterbury-large/bible.txt | 1055886 | 8492.7 ± 1.4% | 5252.4 ± 1.1% | 2789.1 ± 0.9% | 353.4 ± 0.7% | 3855.5 ± 1.0% | 620.1 ± 1.8% | 1.617 | 3.045 | 24.031 | 2.203 | 13.695 |
| string: canterbury-large/world192.txt | 1103121 | 4148.8 ± 0.1% | 2306.1 ± 1.9% | 1765.6 ± 0.4% | 327.8 ± 1.1% | 2099.2 ± 1.8% | 456.7 ± 1.7% | 1.799 | 2.350 | 12.656 | 1.976 | 9.084 |
| string: http/html-1m | 1058582 | 9017.6 ± 3.6% | 4705.2 ± 2.0% | 2673.4 ± 0.8% | 399.6 ± 1.0% | 3596.7 ± 1.3% | 580.7 ± 4.5% | 1.917 | 3.373 | 22.567 | 2.507 | 15.530 |
| string: http/json-1m | 1190272 | 3243.7 ± 0.9% | 1254.0 ± 1.2% | 2029.0 ± 1.2% | 480.7 ± 1.7% | 1339.8 ± 2.1% | 431.3 ± 3.1% | 2.587 | 1.599 | 6.748 | 2.421 | 7.521 |
| string: http/js-1m | 1144362 | 2873.3 ± 0.5% | 1614.9 ± 0.2% | 1331.0 ± 0.9% | 322.7 ± 0.1% | 1420.7 ± 0.3% | 376.9 ± 1.0% | 1.779 | 2.159 | 8.905 | 2.022 | 7.624 |
| string: http/css-1m | 1097820 | 3289.0 ± 1.1% | 2888.3 ± 0.8% | 2260.6 ± 0.5% | 442.3 ± 1.1% | 2076.6 ± 0.6% | 432.6 ± 0.9% | 1.139 | 1.455 | 7.436 | 1.584 | 7.603 |
| string: dickens as Cyrillic and CJK | 1883069 | 5761.2 ± 1.2% | 2896.8 ± 5.4% | 661.6 ± 0.6% | 371.7 ± 1.3% | 510.0 ± 1.3% | 165.8 ± 4.3% | 1.989 | 8.708 | 15.500 | 11.296 | 34.751 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1185.1 ± 0.6% | 1228.1 ± 1.6% | 1088.8 ± 0.7% | 265.5 ± 1.0% | 476.8 ± 0.5% | 227.4 ± 4.7% | 0.965 | 1.088 | 4.463 | 2.486 | 5.212 |
| hex: silesia/dickens | 524290 | 45665.7 ± 1.1% | 14953.9 ± 0.8% | 3484.7 ± 0.9% | 479.1 ± 1.0% | 8840.2 ± 1.2% | 1125.7 ± 2.4% | 3.054 | 13.105 | 95.325 | 5.166 | 40.567 |
| hex: silesia/mozilla | 524290 | 45056.3 ± 0.9% | 15002.0 ± 1.1% | 3571.0 ± 1.3% | 429.2 ± 1.9% | 8939.7 ± 0.8% | 1132.3 ± 1.9% | 3.003 | 12.617 | 104.972 | 5.040 | 39.791 |
| hex: silesia/mr | 524290 | 44010.9 ± 1.8% | 14971.3 ± 2.1% | 3548.5 ± 1.4% | 641.1 ± 0.3% | 8872.2 ± 0.9% | 1124.4 ± 1.0% | 2.940 | 12.403 | 68.652 | 4.961 | 39.143 |
| hex: silesia/nci | 524290 | 45663.0 ± 2.0% | 14999.1 ± 0.8% | 3500.1 ± 1.2% | 796.5 ± 0.4% | 8860.3 ± 0.8% | 1130.9 ± 0.7% | 3.044 | 13.046 | 57.330 | 5.154 | 40.378 |
| hex: silesia/ooffice | 524290 | 34998.9 ± 0.9% | 14965.4 ± 0.8% | 3551.4 ± 0.9% | 342.9 ± 1.2% | 8879.7 ± 1.1% | 1130.0 ± 3.4% | 2.339 | 9.855 | 102.081 | 3.941 | 30.972 |
| hex: silesia/osdb | 524290 | 41801.0 ± 1.0% | 14988.2 ± 0.7% | 3539.0 ± 0.9% | 447.9 ± 2.7% | 8870.3 ± 0.9% | 1128.4 ± 1.2% | 2.789 | 11.812 | 93.324 | 4.712 | 37.044 |
| hex: silesia/reymont | 524290 | 45188.3 ± 1.8% | 15008.9 ± 0.3% | 3471.8 ± 3.4% | 502.9 ± 1.3% | 8868.0 ± 0.5% | 1128.6 ± 0.9% | 3.011 | 13.016 | 89.856 | 5.096 | 40.038 |
| hex: silesia/samba | 524290 | 46360.0 ± 1.5% | 14955.0 ± 0.9% | 3545.4 ± 0.7% | 365.6 ± 0.6% | 8854.5 ± 1.1% | 1126.3 ± 0.8% | 3.100 | 13.076 | 126.801 | 5.236 | 41.161 |
| hex: silesia/sao | 524290 | 48269.7 ± 2.3% | 15007.8 ± 1.2% | 3447.4 ± 3.7% | 276.6 ± 1.3% | 8875.7 ± 0.6% | 1127.7 ± 0.7% | 3.216 | 14.002 | 174.498 | 5.438 | 42.802 |
| hex: silesia/webster | 524290 | 38158.9 ± 0.9% | 15054.9 ± 0.7% | 3574.6 ± 1.2% | 448.6 ± 1.7% | 8856.6 ± 2.0% | 1126.2 ± 0.9% | 2.535 | 10.675 | 85.064 | 4.309 | 33.884 |
| hex: silesia/x-ray | 524290 | 40486.8 ± 1.0% | 14967.0 ± 0.8% | 3459.8 ± 2.7% | 422.8 ± 1.5% | 8884.5 ± 1.0% | 1126.1 ± 1.1% | 2.705 | 11.702 | 95.768 | 4.557 | 35.952 |
| hex: silesia/xml | 524290 | 45381.9 ± 1.9% | 14976.0 ± 1.0% | 3549.7 ± 0.8% | 728.2 ± 2.4% | 8890.0 ± 0.6% | 1125.5 ± 1.0% | 3.030 | 12.785 | 62.319 | 5.105 | 40.322 |
| hex: canterbury/alice29.txt | 304180 | 45451.6 ± 1.9% | 14050.7 ± 0.8% | 3542.4 ± 2.3% | 484.2 ± 0.7% | 8874.8 ± 1.0% | 1135.9 ± 0.9% | 3.235 | 12.831 | 93.879 | 5.121 | 40.015 |
| hex: canterbury/asyoulik.txt | 250360 | 45376.5 ± 1.2% | 14859.4 ± 0.4% | 3478.8 ± 0.7% | 468.9 ± 2.7% | 8840.5 ± 0.6% | 1131.3 ± 1.2% | 3.054 | 13.044 | 96.765 | 5.133 | 40.111 |
| hex: canterbury/cp.html | 49208 | 45467.0 ± 1.1% | 14392.6 ± 0.9% | 3542.7 ± 0.6% | 500.4 ± 1.3% | 9236.2 ± 1.0% | 1115.5 ± 1.4% | 3.159 | 12.834 | 90.860 | 4.923 | 40.758 |
| hex: canterbury/fields.c | 22302 | 48728.1 ± 0.9% | 17217.0 ± 1.2% | 3651.2 ± 1.2% | 560.1 ± 1.2% | 9153.6 ± 1.4% | 1084.3 ± 2.5% | 2.830 | 13.346 | 87.006 | 5.323 | 44.941 |
| hex: canterbury/grammar.lsp | 7444 | 43301.9 ± 2.0% | 17107.1 ± 0.6% | 3603.2 ± 0.8% | 751.1 ± 5.3% | 8878.3 ± 0.5% | 1030.1 ± 4.5% | 2.531 | 12.017 | 57.652 | 4.877 | 42.039 |
| hex: canterbury/kennedy.xls | 524290 | 46117.8 ± 1.5% | 13938.8 ± 0.6% | 3493.2 ± 0.4% | 749.8 ± 0.9% | 8855.4 ± 0.5% | 1112.4 ± 8.9% | 3.309 | 13.202 | 61.505 | 5.208 | 41.456 |
| hex: canterbury/lcet10.txt | 524290 | 45159.4 ± 1.2% | 13951.4 ± 0.4% | 3542.5 ± 1.2% | 485.4 ± 0.3% | 8856.8 ± 5.1% | 1100.4 ± 3.0% | 3.237 | 12.748 | 93.030 | 5.099 | 41.040 |
| hex: canterbury/plrabn12.txt | 524290 | 46641.1 ± 2.1% | 14010.0 ± 0.4% | 3547.1 ± 1.3% | 466.0 ± 0.5% | 8876.4 ± 4.4% | 1116.9 ± 0.9% | 3.329 | 13.149 | 100.092 | 5.254 | 41.758 |
| hex: canterbury/ptt5 | 524290 | 46394.8 ± 1.2% | 13990.2 ± 0.4% | 3488.6 ± 0.4% | 666.3 ± 2.2% | 8874.0 ± 0.6% | 1127.2 ± 0.9% | 3.316 | 13.299 | 69.632 | 5.228 | 41.160 |
| hex: canterbury/sum | 76482 | 45926.9 ± 0.8% | 15398.8 ± 0.4% | 3547.2 ± 0.2% | 581.6 ± 0.7% | 8883.0 ± 0.6% | 1112.4 ± 2.8% | 2.983 | 12.947 | 78.972 | 5.170 | 41.285 |
| hex: canterbury/xargs.1 | 8456 | 44080.7 ± 2.3% | 17325.5 ± 1.2% | 3553.4 ± 0.7% | 721.9 ± 2.3% | 8921.2 ± 0.6% | 1082.8 ± 4.3% | 2.544 | 12.405 | 61.064 | 4.941 | 40.710 |
| hex: canterbury-large/E.coli | 524290 | 44970.2 ± 1.8% | 14961.4 ± 1.2% | 3484.0 ± 0.9% | 958.8 ± 0.8% | 8872.7 ± 0.7% | 1098.9 ± 6.5% | 3.006 | 12.908 | 46.903 | 5.068 | 40.923 |
| hex: canterbury-large/bible.txt | 524290 | 45442.4 ± 2.2% | 14962.8 ± 1.0% | 3489.2 ± 1.1% | 499.0 ± 0.9% | 8887.4 ± 1.1% | 1109.6 ± 2.8% | 3.037 | 13.024 | 91.068 | 5.113 | 40.953 |
| hex: canterbury-large/world192.txt | 524290 | 45481.4 ± 0.4% | 15045.1 ± 0.7% | 3556.3 ± 1.1% | 470.2 ± 1.1% | 8921.0 ± 1.2% | 1119.8 ± 0.7% | 3.023 | 12.789 | 96.738 | 5.098 | 40.616 |
| hex: http/html-1kx1024 | 2099200 | 16972.8 ± 1.8% | 11907.3 ± 11.6% | 3116.2 ± 0.9% | 503.9 ± 0.8% | 7372.5 ± 1.9% | 961.2 ± 1.5% | 1.425 | 5.447 | 33.684 | 2.302 | 17.657 |
| hex: http/html-16kx64 | 2097280 | 32024.7 ± 1.4% | 13613.1 ± 0.2% | 3380.1 ± 0.8% | 513.3 ± 1.9% | 8318.1 ± 1.3% | 1056.2 ± 3.9% | 2.352 | 9.475 | 62.396 | 3.850 | 30.320 |
| hex: http/html-1m | 524290 | 44807.2 ± 0.9% | 15042.8 ± 0.8% | 3506.2 ± 0.9% | 505.1 ± 1.2% | 8902.7 ± 0.9% | 1089.9 ± 3.3% | 2.979 | 12.779 | 88.708 | 5.033 | 41.113 |
| hex: http/json-1kx1024 | 2099200 | 17073.0 ± 0.8% | 12144.0 ± 0.6% | 3137.2 ± 0.4% | 681.7 ± 0.9% | 7321.3 ± 3.9% | 956.2 ± 2.3% | 1.406 | 5.442 | 25.046 | 2.332 | 17.855 |
| hex: http/json-16kx64 | 2097280 | 33868.1 ± 0.4% | 13675.8 ± 0.2% | 3400.0 ± 0.4% | 693.8 ± 1.1% | 8390.2 ± 7.8% | 1064.0 ± 4.1% | 2.477 | 9.961 | 48.814 | 4.037 | 31.830 |
| hex: http/json-1m | 524290 | 45039.1 ± 0.4% | 15079.3 ± 0.5% | 3555.0 ± 0.5% | 717.9 ± 0.8% | 8934.3 ± 0.4% | 1118.1 ± 2.6% | 2.987 | 12.669 | 62.738 | 5.041 | 40.281 |
| hex: http/js-1kx1024 | 2099200 | 16614.5 ± 1.0% | 12404.9 ± 0.5% | 3125.8 ± 0.3% | 491.9 ± 0.6% | 7394.0 ± 2.3% | 939.9 ± 4.4% | 1.339 | 5.315 | 33.776 | 2.247 | 17.677 |
| hex: http/js-16kx64 | 2097280 | 34066.6 ± 3.6% | 13798.8 ± 0.8% | 3387.6 ± 1.1% | 498.0 ± 0.6% | 8591.7 ± 1.0% | 1036.7 ± 3.2% | 2.469 | 10.056 | 68.411 | 3.965 | 32.860 |
| hex: http/js-1m | 524290 | 43518.9 ± 1.0% | 15022.2 ± 3.1% | 3564.8 ± 0.4% | 515.6 ± 2.7% | 8950.3 ± 0.9% | 1114.4 ± 2.6% | 2.897 | 12.208 | 84.404 | 4.862 | 39.050 |
| hex: http/css-1kx1024 | 2099200 | 16652.6 ± 3.7% | 12348.7 ± 1.1% | 3130.8 ± 0.5% | 570.7 ± 0.4% | 7287.8 ± 4.1% | 947.7 ± 1.1% | 1.349 | 5.319 | 29.178 | 2.285 | 17.572 |
| hex: http/css-16kx64 | 2097280 | 33084.0 ± 0.5% | 13941.2 ± 0.2% | 3392.4 ± 0.6% | 581.7 ± 1.0% | 8432.6 ± 8.0% | 1053.5 ± 3.6% | 2.373 | 9.752 | 56.872 | 3.923 | 31.403 |
| hex: http/css-1m | 524290 | 44696.6 ± 5.8% | 14978.5 ± 1.1% | 3540.0 ± 1.3% | 561.4 ± 3.5% | 8947.1 ± 1.3% | 1109.5 ± 2.3% | 2.984 | 12.626 | 79.611 | 4.996 | 40.286 |
| hex: shuffled/dickens-1m | 524290 | 44829.4 ± 1.7% | 14950.7 ± 0.9% | 3486.1 ± 1.2% | 478.1 ± 1.5% | 8862.3 ± 1.4% | 1110.8 ± 4.1% | 2.998 | 12.860 | 93.767 | 5.058 | 40.357 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1727.9 ± 0.6% | 1469.5 ± 2.8% | 1018.4 ± 0.8% | 482.1 ± 0.8% | 486.1 ± 2.4% | 501.7 ± 0.8% | 1.176 | 1.697 | 3.584 | 3.555 | 3.444 |
| qlog records, JSON text sequence | 1467503 | 1632.1 ± 3.8% | 1223.9 ± 2.3% | 920.5 ± 2.1% | 455.1 ± 4.2% | 570.7 ± 1.1% | 350.1 ± 1.6% | 1.334 | 1.773 | 3.587 | 2.860 | 4.662 |
| string: silesia/dickens | 172528 | 12019.1 ± 3.5% | 3926.2 ± 0.6% | 3060.2 ± 1.9% | 354.8 ± 0.4% | 1702.4 ± 1.1% | 1182.1 ± 0.8% | 3.061 | 3.928 | 33.879 | 7.060 | 10.167 |
| string: silesia/nci | 1075110 | 10803.1 ± 1.6% | 4591.2 ± 2.4% | 3098.2 ± 0.6% | 849.6 ± 0.6% | 1889.3 ± 3.9% | 1271.7 ± 0.8% | 2.353 | 3.487 | 12.715 | 5.718 | 8.495 |
| string: silesia/reymont | 1075159 | 5204.3 ± 5.1% | 1835.7 ± 1.1% | 1878.5 ± 1.0% | 392.6 ± 0.9% | 1431.7 ± 1.4% | 1035.3 ± 1.3% | 2.835 | 2.770 | 13.257 | 3.635 | 5.027 |
| string: silesia/samba | 97582 | 6274.1 ± 0.4% | 2686.5 ± 0.5% | 4078.5 ± 0.2% | 380.8 ± 0.3% | 1333.6 ± 0.2% | 1188.4 ± 1.6% | 2.335 | 1.538 | 16.475 | 4.705 | 5.279 |
| string: silesia/webster | 1098490 | 6573.8 ± 1.7% | 1960.9 ± 0.9% | 1750.0 ± 1.2% | 386.1 ± 1.8% | 1396.6 ± 1.5% | 596.8 ± 0.8% | 3.352 | 3.756 | 17.024 | 4.707 | 11.015 |
| string: silesia/xml | 1090118 | 9679.5 ± 1.2% | 3156.3 ± 0.5% | 2528.2 ± 1.0% | 628.9 ± 0.9% | 1930.9 ± 0.9% | 958.9 ± 0.3% | 3.067 | 3.829 | 15.391 | 5.013 | 10.095 |
| string: canterbury/alice29.txt | 159425 | 10353.9 ± 6.0% | 2898.6 ± 1.7% | 3101.6 ± 2.2% | 344.1 ± 2.9% | 1547.8 ± 1.6% | 1092.6 ± 1.0% | 3.572 | 3.338 | 30.091 | 6.690 | 9.477 |
| string: canterbury/asyoulik.txt | 132198 | 10266.9 ± 3.5% | 2117.5 ± 0.9% | 3139.2 ± 0.4% | 351.2 ± 0.4% | 1375.5 ± 1.2% | 968.1 ± 0.7% | 4.849 | 3.271 | 29.232 | 7.464 | 10.605 |
| string: canterbury/lcet10.txt | 441884 | 10635.1 ± 0.9% | 3074.0 ± 0.6% | 2590.9 ± 0.4% | 387.3 ± 1.2% | 1678.3 ± 1.8% | 1195.3 ± 1.9% | 3.460 | 4.105 | 27.460 | 6.337 | 8.897 |
| string: canterbury/plrabn12.txt | 503330 | 7912.1 ± 3.9% | 2311.3 ± 0.5% | 2093.2 ± 5.1% | 364.1 ± 1.4% | 1608.0 ± 2.1% | 1114.8 ± 1.8% | 3.423 | 3.780 | 21.732 | 4.921 | 7.097 |
| string: canterbury-large/E.coli | 1048578 | 30930.4 ± 5.3% | 14964.8 ± 1.4% | 3455.5 ± 3.9% | 1687.9 ± 1.2% | 3123.4 ± 1.2% | 1399.5 ± 0.8% | 2.067 | 8.951 | 18.325 | 9.903 | 22.101 |
| string: canterbury-large/bible.txt | 1055886 | 8866.8 ± 0.7% | 4717.6 ± 2.4% | 3006.3 ± 1.5% | 422.4 ± 0.3% | 2229.3 ± 0.3% | 1488.1 ± 0.5% | 1.880 | 2.949 | 20.994 | 3.977 | 5.959 |
| string: canterbury-large/world192.txt | 1103121 | 6382.4 ± 1.1% | 1712.0 ± 0.7% | 1890.9 ± 2.1% | 387.2 ± 3.6% | 1385.3 ± 2.1% | 962.0 ± 1.3% | 3.728 | 3.375 | 16.482 | 4.607 | 6.635 |
| string: http/html-1m | 1058582 | 9779.3 ± 1.4% | 4314.8 ± 2.4% | 2874.8 ± 0.5% | 461.1 ± 1.4% | 2152.8 ± 1.3% | 845.4 ± 4.0% | 2.266 | 3.402 | 21.210 | 4.543 | 11.568 |
| string: http/json-1m | 1190272 | 8015.2 ± 4.9% | 1569.5 ± 0.8% | 1557.9 ± 0.8% | 535.8 ± 0.7% | 1151.8 ± 0.7% | 846.4 ± 3.3% | 5.107 | 5.145 | 14.959 | 6.959 | 9.470 |
| string: http/js-1m | 1144362 | 6348.0 ± 1.2% | 1114.2 ± 1.1% | 1392.3 ± 0.9% | 362.7 ± 2.2% | 1124.1 ± 1.0% | 755.6 ± 0.5% | 5.698 | 4.559 | 17.500 | 5.647 | 8.402 |
| string: http/css-1m | 1097820 | 7966.5 ± 1.8% | 1470.2 ± 1.1% | 2281.9 ± 0.9% | 543.7 ± 1.1% | 1260.1 ± 1.3% | 878.7 ± 1.5% | 5.419 | 3.491 | 14.653 | 6.322 | 9.066 |
| string: dickens as Cyrillic and CJK | 1883069 | 5420.5 ± 0.5% | 3664.7 ± 1.7% | 483.3 ± 0.9% | 251.0 ± 1.1% | 463.9 ± 1.1% | 355.7 ± 0.4% | 1.479 | 11.215 | 21.598 | 11.685 | 15.240 |
| hex: silesia/dickens | 524290 | 43245.5 ± 0.6% | 2580.1 ± 0.6% | 1495.6 ± 0.7% | 467.8 ± 2.9% | 1547.8 ± 0.7% | 1052.5 ± 0.9% | 16.761 | 28.916 | 92.440 | 27.940 | 41.089 |
| hex: silesia/mozilla | 524290 | 43057.0 ± 1.7% | 2579.7 ± 0.7% | 1500.7 ± 0.5% | 416.8 ± 0.8% | 1553.1 ± 0.7% | 1062.2 ± 1.0% | 16.691 | 28.691 | 103.299 | 27.723 | 40.537 |
| hex: silesia/mr | 524290 | 42897.0 ± 0.3% | 2570.3 ± 0.1% | 1507.6 ± 0.1% | 611.0 ± 0.4% | 1570.5 ± 5.7% | 1064.9 ± 1.5% | 16.690 | 28.454 | 70.212 | 27.315 | 40.282 |
| hex: silesia/nci | 524290 | 43522.0 ± 0.2% | 2561.5 ± 0.8% | 1502.3 ± 0.9% | 750.2 ± 0.1% | 1546.6 ± 0.8% | 1063.1 ± 3.9% | 16.991 | 28.971 | 58.018 | 28.141 | 40.940 |
| hex: silesia/ooffice | 524290 | 42725.0 ± 0.7% | 2591.7 ± 0.5% | 1511.1 ± 0.2% | 346.5 ± 1.1% | 1570.6 ± 4.7% | 1067.1 ± 1.4% | 16.485 | 28.274 | 123.291 | 27.203 | 40.039 |
| hex: silesia/osdb | 524290 | 42773.0 ± 1.4% | 2576.8 ± 0.3% | 1506.5 ± 0.6% | 454.6 ± 0.4% | 1555.0 ± 0.9% | 1064.0 ± 5.3% | 16.599 | 28.392 | 94.096 | 27.507 | 40.200 |
| hex: silesia/reymont | 524290 | 42678.5 ± 0.8% | 2597.2 ± 0.2% | 1507.9 ± 0.1% | 499.0 ± 0.4% | 1575.0 ± 0.1% | 1068.9 ± 0.2% | 16.432 | 28.303 | 85.527 | 27.098 | 39.929 |
| hex: silesia/samba | 524290 | 43459.5 ± 0.5% | 2588.9 ± 0.8% | 1506.5 ± 0.5% | 367.5 ± 1.0% | 1576.4 ± 0.9% | 1065.8 ± 0.9% | 16.787 | 28.848 | 118.272 | 27.569 | 40.777 |
| hex: silesia/sao | 524290 | 42233.9 ± 0.7% | 2589.4 ± 1.1% | 1507.3 ± 0.8% | 281.6 ± 1.1% | 1576.4 ± 1.3% | 1068.2 ± 1.2% | 16.310 | 28.020 | 149.988 | 26.792 | 39.539 |
| hex: silesia/webster | 524290 | 43683.5 ± 7.5% | 2597.9 ± 0.1% | 1512.6 ± 0.2% | 454.9 ± 1.0% | 1583.4 ± 0.4% | 1066.7 ± 0.4% | 16.815 | 28.880 | 96.029 | 27.589 | 40.954 |
| hex: silesia/x-ray | 524290 | 43083.7 ± 1.0% | 2583.9 ± 0.3% | 1496.8 ± 4.1% | 429.8 ± 0.9% | 1573.9 ± 0.8% | 1061.6 ± 1.1% | 16.674 | 28.783 | 100.250 | 27.374 | 40.583 |
| hex: silesia/xml | 524290 | 43290.8 ± 0.3% | 2582.0 ± 0.7% | 1507.3 ± 5.3% | 737.6 ± 2.1% | 1568.0 ± 2.4% | 1062.2 ± 1.2% | 16.766 | 28.720 | 58.694 | 27.609 | 40.756 |
| hex: canterbury/alice29.txt | 304180 | 42798.2 ± 1.7% | 2590.2 ± 1.3% | 1514.1 ± 1.1% | 477.5 ± 0.9% | 1584.0 ± 0.9% | 1082.3 ± 0.8% | 16.523 | 28.267 | 89.633 | 27.019 | 39.544 |
| hex: canterbury/asyoulik.txt | 250360 | 42910.8 ± 0.8% | 2602.2 ± 0.7% | 1528.2 ± 1.0% | 464.9 ± 1.3% | 1585.5 ± 1.5% | 1079.1 ± 1.1% | 16.490 | 28.079 | 92.300 | 27.064 | 39.765 |
| hex: canterbury/cp.html | 49208 | 41912.9 ± 1.1% | 2575.3 ± 0.5% | 1514.9 ± 0.6% | 510.9 ± 0.9% | 1581.5 ± 0.6% | 1085.3 ± 0.6% | 16.275 | 27.666 | 82.037 | 26.502 | 38.617 |
| hex: canterbury/fields.c | 22302 | 41346.2 ± 1.1% | 2631.0 ± 0.4% | 1524.1 ± 0.5% | 627.2 ± 0.7% | 1596.4 ± 0.9% | 1095.3 ± 0.4% | 15.715 | 27.129 | 65.919 | 25.899 | 37.748 |
| hex: canterbury/grammar.lsp | 7444 | 38941.4 ± 0.8% | 2689.8 ± 0.7% | 1531.8 ± 5.4% | 797.6 ± 1.0% | 1602.2 ± 1.1% | 1100.2 ± 0.6% | 14.477 | 25.423 | 48.822 | 24.305 | 35.395 |
| hex: canterbury/kennedy.xls | 524290 | 41470.0 ± 0.7% | 2561.4 ± 0.4% | 1491.8 ± 4.9% | 742.2 ± 0.7% | 1554.9 ± 0.9% | 1054.4 ± 0.6% | 16.190 | 27.798 | 55.874 | 26.671 | 39.330 |
| hex: canterbury/lcet10.txt | 524290 | 43275.1 ± 0.9% | 2573.9 ± 0.7% | 1493.4 ± 1.0% | 473.8 ± 1.0% | 1557.4 ± 0.8% | 1057.3 ± 1.3% | 16.813 | 28.977 | 91.342 | 27.788 | 40.929 |
| hex: canterbury/plrabn12.txt | 524290 | 43324.7 ± 1.2% | 2583.9 ± 0.6% | 1499.9 ± 0.8% | 454.9 ± 0.9% | 1507.4 ± 0.7% | 1055.6 ± 0.8% | 16.767 | 28.884 | 95.231 | 28.742 | 41.042 |
| hex: canterbury/ptt5 | 524290 | 43218.6 ± 1.4% | 2543.8 ± 0.9% | 1492.0 ± 1.8% | 609.8 ± 2.2% | 1557.6 ± 3.2% | 1055.3 ± 1.3% | 16.990 | 28.966 | 70.870 | 27.747 | 40.953 |
| hex: canterbury/sum | 76482 | 42269.3 ± 6.4% | 2566.9 ± 1.1% | 1506.1 ± 0.5% | 588.2 ± 0.7% | 1570.7 ± 0.4% | 1077.9 ± 4.3% | 16.467 | 28.066 | 71.860 | 26.911 | 39.214 |
| hex: canterbury/xargs.1 | 8456 | 39449.7 ± 4.1% | 2665.8 ± 7.8% | 1528.6 ± 1.1% | 825.3 ± 0.7% | 1599.2 ± 1.0% | 1103.6 ± 0.8% | 14.798 | 25.808 | 47.801 | 24.669 | 35.745 |
| hex: canterbury-large/E.coli | 524290 | 42897.4 ± 0.8% | 2566.0 ± 1.2% | 1491.8 ± 1.3% | 810.2 ± 1.1% | 1553.3 ± 5.7% | 1053.8 ± 2.5% | 16.718 | 28.755 | 52.947 | 27.617 | 40.707 |
| hex: canterbury-large/bible.txt | 524290 | 43448.9 ± 0.7% | 2581.6 ± 0.8% | 1496.0 ± 1.3% | 485.1 ± 3.5% | 1538.0 ± 0.6% | 1058.9 ± 5.8% | 16.830 | 29.043 | 89.574 | 28.249 | 41.030 |
| hex: canterbury-large/world192.txt | 524290 | 43250.4 ± 1.4% | 2558.0 ± 8.9% | 1495.2 ± 0.9% | 463.3 ± 0.7% | 1536.5 ± 0.6% | 1057.2 ± 0.4% | 16.908 | 28.925 | 93.360 | 28.150 | 40.909 |
| hex: http/html-1kx1024 | 2099200 | 20619.7 ± 0.3% | 2426.7 ± 1.5% | 1456.2 ± 3.8% | 513.2 ± 0.4% | 1501.8 ± 0.6% | 1073.5 ± 1.3% | 8.497 | 14.160 | 40.182 | 13.730 | 19.209 |
| hex: http/html-16kx64 | 2097280 | 21553.1 ± 0.4% | 2355.9 ± 7.0% | 1441.0 ± 0.9% | 516.5 ± 1.1% | 1492.4 ± 1.1% | 1076.8 ± 1.4% | 9.149 | 14.957 | 41.731 | 14.442 | 20.017 |
| hex: http/html-1m | 524290 | 40158.0 ± 0.8% | 2575.7 ± 1.2% | 1507.2 ± 0.6% | 504.9 ± 1.0% | 1564.2 ± 5.7% | 1062.9 ± 0.4% | 15.591 | 26.644 | 79.538 | 25.674 | 37.782 |
| hex: http/json-1kx1024 | 2099200 | 20654.7 ± 0.4% | 2430.5 ± 0.3% | 1454.9 ± 1.0% | 687.8 ± 1.2% | 1499.7 ± 1.6% | 1073.7 ± 1.4% | 8.498 | 14.196 | 30.029 | 13.772 | 19.237 |
| hex: http/json-16kx64 | 2097280 | 22449.2 ± 0.4% | 2350.4 ± 1.4% | 1434.4 ± 1.2% | 661.9 ± 0.9% | 1343.2 ± 1.1% | 1078.0 ± 1.0% | 9.551 | 15.651 | 33.914 | 16.714 | 20.825 |
| hex: http/json-1m | 524290 | 43001.2 ± 0.4% | 2559.7 ± 0.6% | 1504.6 ± 0.7% | 705.7 ± 1.3% | 1488.5 ± 0.7% | 1062.7 ± 1.2% | 16.800 | 28.579 | 60.933 | 28.889 | 40.463 |
| hex: http/js-1kx1024 | 2099200 | 19964.4 ± 0.8% | 2422.3 ± 1.4% | 1461.1 ± 1.5% | 497.9 ± 1.0% | 1504.9 ± 0.9% | 1070.1 ± 1.3% | 8.242 | 13.664 | 40.096 | 13.267 | 18.656 |
| hex: http/js-16kx64 | 2097280 | 21049.8 ± 0.5% | 2354.3 ± 7.6% | 1437.6 ± 0.7% | 497.8 ± 0.6% | 1489.3 ± 0.4% | 1075.7 ± 0.9% | 8.941 | 14.643 | 42.283 | 14.134 | 19.569 |
| hex: http/js-1m | 524290 | 42341.9 ± 0.5% | 2576.9 ± 1.0% | 1497.9 ± 0.8% | 514.4 ± 0.8% | 1565.4 ± 0.7% | 1057.5 ± 0.4% | 16.431 | 28.268 | 82.318 | 27.049 | 40.040 |
| hex: http/css-1kx1024 | 2099200 | 20585.5 ± 0.3% | 2423.3 ± 0.7% | 1452.4 ± 4.6% | 570.7 ± 1.2% | 1500.3 ± 0.6% | 1067.6 ± 0.5% | 8.495 | 14.173 | 36.070 | 13.721 | 19.282 |
| hex: http/css-16kx64 | 2097280 | 21582.1 ± 0.6% | 2358.0 ± 0.5% | 1438.5 ± 0.9% | 578.9 ± 1.5% | 1491.0 ± 0.9% | 1078.6 ± 0.8% | 9.153 | 15.003 | 37.283 | 14.475 | 20.009 |
| hex: http/css-1m | 524290 | 43145.5 ± 0.7% | 2562.8 ± 0.6% | 1496.1 ± 1.1% | 552.4 ± 1.2% | 1513.9 ± 1.3% | 1057.7 ± 0.6% | 16.835 | 28.839 | 78.103 | 28.500 | 40.793 |
| hex: shuffled/dickens-1m | 524290 | 43228.8 ± 1.2% | 2591.5 ± 1.5% | 1501.7 ± 0.7% | 465.2 ± 0.9% | 1529.9 ± 1.0% | 1057.2 ± 1.1% | 16.681 | 28.786 | 92.931 | 28.256 | 40.889 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1785.3 ± 2.2% | 1469.5 ± 2.8% | 1018.4 ± 0.8% | 482.1 ± 0.8% | 486.1 ± 2.4% | 501.7 ± 0.8% | 1.215 | 1.753 | 3.703 | 3.673 | 3.558 |
| qlog records, JSON text sequence | 1467503 | 1712.5 ± 0.5% | 1223.9 ± 2.3% | 920.5 ± 2.1% | 455.1 ± 4.2% | 570.7 ± 1.1% | 350.1 ± 1.6% | 1.399 | 1.860 | 3.763 | 3.001 | 4.891 |
| string: silesia/dickens | 172528 | 13284.4 ± 1.2% | 3926.2 ± 0.6% | 3060.2 ± 1.9% | 354.8 ± 0.4% | 1702.4 ± 1.1% | 1182.1 ± 0.8% | 3.384 | 4.341 | 37.446 | 7.803 | 11.238 |
| string: silesia/nci | 1075110 | 11547.9 ± 4.6% | 4591.2 ± 2.4% | 3098.2 ± 0.6% | 849.6 ± 0.6% | 1889.3 ± 3.9% | 1271.7 ± 0.8% | 2.515 | 3.727 | 13.592 | 6.112 | 9.081 |
| string: silesia/reymont | 1075159 | 5396.9 ± 2.0% | 1835.7 ± 1.1% | 1878.5 ± 1.0% | 392.6 ± 0.9% | 1431.7 ± 1.4% | 1035.3 ± 1.3% | 2.940 | 2.873 | 13.748 | 3.770 | 5.213 |
| string: silesia/samba | 97582 | 7286.5 ± 0.8% | 2686.5 ± 0.5% | 4078.5 ± 0.2% | 380.8 ± 0.3% | 1333.6 ± 0.2% | 1188.4 ± 1.6% | 2.712 | 1.787 | 19.134 | 5.464 | 6.131 |
| string: silesia/webster | 1098490 | 6933.9 ± 1.1% | 1960.9 ± 0.9% | 1750.0 ± 1.2% | 386.1 ± 1.8% | 1396.6 ± 1.5% | 596.8 ± 0.8% | 3.536 | 3.962 | 17.957 | 4.965 | 11.618 |
| string: silesia/xml | 1090118 | 11025.0 ± 1.2% | 3156.3 ± 0.5% | 2528.2 ± 1.0% | 628.9 ± 0.9% | 1930.9 ± 0.9% | 958.9 ± 0.3% | 3.493 | 4.361 | 17.531 | 5.710 | 11.498 |
| string: canterbury/alice29.txt | 159425 | 12728.8 ± 3.0% | 2898.6 ± 1.7% | 3101.6 ± 2.2% | 344.1 ± 2.9% | 1547.8 ± 1.6% | 1092.6 ± 1.0% | 4.391 | 4.104 | 36.994 | 8.224 | 11.650 |
| string: canterbury/asyoulik.txt | 132198 | 11554.3 ± 0.9% | 2117.5 ± 0.9% | 3139.2 ± 0.4% | 351.2 ± 0.4% | 1375.5 ± 1.2% | 968.1 ± 0.7% | 5.457 | 3.681 | 32.898 | 8.400 | 11.935 |
| string: canterbury/lcet10.txt | 441884 | 12755.8 ± 0.8% | 3074.0 ± 0.6% | 2590.9 ± 0.4% | 387.3 ± 1.2% | 1678.3 ± 1.8% | 1195.3 ± 1.9% | 4.150 | 4.923 | 32.936 | 7.600 | 10.671 |
| string: canterbury/plrabn12.txt | 503330 | 8943.8 ± 1.8% | 2311.3 ± 0.5% | 2093.2 ± 5.1% | 364.1 ± 1.4% | 1608.0 ± 2.1% | 1114.8 ± 1.8% | 3.870 | 4.273 | 24.566 | 5.562 | 8.023 |
| string: canterbury-large/E.coli | 1048578 | 31026.6 ± 0.1% | 14964.8 ± 1.4% | 3455.5 ± 3.9% | 1687.9 ± 1.2% | 3123.4 ± 1.2% | 1399.5 ± 0.8% | 2.073 | 8.979 | 18.382 | 9.934 | 22.170 |
| string: canterbury-large/bible.txt | 1055886 | 9809.0 ± 0.7% | 4717.6 ± 2.4% | 3006.3 ± 1.5% | 422.4 ± 0.3% | 2229.3 ± 0.3% | 1488.1 ± 0.5% | 2.079 | 3.263 | 23.225 | 4.400 | 6.592 |
| string: canterbury-large/world192.txt | 1103121 | 6504.3 ± 2.1% | 1712.0 ± 0.7% | 1890.9 ± 2.1% | 387.2 ± 3.6% | 1385.3 ± 2.1% | 962.0 ± 1.3% | 3.799 | 3.440 | 16.796 | 4.695 | 6.761 |
| string: http/html-1m | 1058582 | 10132.2 ± 1.5% | 4314.8 ± 2.4% | 2874.8 ± 0.5% | 461.1 ± 1.4% | 2152.8 ± 1.3% | 845.4 ± 4.0% | 2.348 | 3.524 | 21.975 | 4.707 | 11.985 |
| string: http/json-1m | 1190272 | 8129.4 ± 0.5% | 1569.5 ± 0.8% | 1557.9 ± 0.8% | 535.8 ± 0.7% | 1151.8 ± 0.7% | 846.4 ± 3.3% | 5.179 | 5.218 | 15.172 | 7.058 | 9.605 |
| string: http/js-1m | 1144362 | 6636.8 ± 0.7% | 1114.2 ± 1.1% | 1392.3 ± 0.9% | 362.7 ± 2.2% | 1124.1 ± 1.0% | 755.6 ± 0.5% | 5.957 | 4.767 | 18.296 | 5.904 | 8.784 |
| string: http/css-1m | 1097820 | 9293.3 ± 1.2% | 1470.2 ± 1.1% | 2281.9 ± 0.9% | 543.7 ± 1.1% | 1260.1 ± 1.3% | 878.7 ± 1.5% | 6.321 | 4.073 | 17.093 | 7.375 | 10.576 |
| string: dickens as Cyrillic and CJK | 1883069 | 5686.5 ± 1.3% | 3664.7 ± 1.7% | 483.3 ± 0.9% | 251.0 ± 1.1% | 463.9 ± 1.1% | 355.7 ± 0.4% | 1.552 | 11.766 | 22.658 | 12.258 | 15.988 |
| hex: silesia/dickens | 524290 | 43389.2 ± 1.3% | 2580.1 ± 0.6% | 1495.6 ± 0.7% | 467.8 ± 2.9% | 1547.8 ± 0.7% | 1052.5 ± 0.9% | 16.817 | 29.012 | 92.747 | 28.033 | 41.226 |
| hex: silesia/mozilla | 524290 | 42730.2 ± 3.4% | 2579.7 ± 0.7% | 1500.7 ± 0.5% | 416.8 ± 0.8% | 1553.1 ± 0.7% | 1062.2 ± 1.0% | 16.564 | 28.473 | 102.514 | 27.512 | 40.229 |
| hex: silesia/mr | 524290 | 42764.9 ± 0.3% | 2570.3 ± 0.1% | 1507.6 ± 0.1% | 611.0 ± 0.4% | 1570.5 ± 5.7% | 1064.9 ± 1.5% | 16.638 | 28.366 | 69.996 | 27.231 | 40.158 |
| hex: silesia/nci | 524290 | 42549.8 ± 0.8% | 2561.5 ± 0.8% | 1502.3 ± 0.9% | 750.2 ± 0.1% | 1546.6 ± 0.8% | 1063.1 ± 3.9% | 16.611 | 28.324 | 56.722 | 27.512 | 40.026 |
| hex: silesia/ooffice | 524290 | 42513.5 ± 0.3% | 2591.7 ± 0.5% | 1511.1 ± 0.2% | 346.5 ± 1.1% | 1570.6 ± 4.7% | 1067.1 ± 1.4% | 16.403 | 28.134 | 122.680 | 27.068 | 39.841 |
| hex: silesia/osdb | 524290 | 42699.7 ± 0.8% | 2576.8 ± 0.3% | 1506.5 ± 0.6% | 454.6 ± 0.4% | 1555.0 ± 0.9% | 1064.0 ± 5.3% | 16.571 | 28.344 | 93.935 | 27.460 | 40.131 |
| hex: silesia/reymont | 524290 | 42618.1 ± 0.3% | 2597.2 ± 0.2% | 1507.9 ± 0.1% | 499.0 ± 0.4% | 1575.0 ± 0.1% | 1068.9 ± 0.2% | 16.409 | 28.263 | 85.406 | 27.060 | 39.872 |
| hex: silesia/samba | 524290 | 42600.1 ± 1.3% | 2588.9 ± 0.8% | 1506.5 ± 0.5% | 367.5 ± 1.0% | 1576.4 ± 0.9% | 1065.8 ± 0.9% | 16.455 | 28.277 | 115.933 | 27.024 | 39.970 |
| hex: silesia/sao | 524290 | 41766.6 ± 1.3% | 2589.4 ± 1.1% | 1507.3 ± 0.8% | 281.6 ± 1.1% | 1576.4 ± 1.3% | 1068.2 ± 1.2% | 16.130 | 27.710 | 148.329 | 26.495 | 39.102 |
| hex: silesia/webster | 524290 | 42804.4 ± 0.6% | 2597.9 ± 0.1% | 1512.6 ± 0.2% | 454.9 ± 1.0% | 1583.4 ± 0.4% | 1066.7 ± 0.4% | 16.477 | 28.299 | 94.097 | 27.034 | 40.129 |
| hex: silesia/x-ray | 524290 | 43237.8 ± 5.0% | 2583.9 ± 0.3% | 1496.8 ± 4.1% | 429.8 ± 0.9% | 1573.9 ± 0.8% | 1061.6 ± 1.1% | 16.734 | 28.886 | 100.609 | 27.472 | 40.729 |
| hex: silesia/xml | 524290 | 42863.8 ± 2.0% | 2582.0 ± 0.7% | 1507.3 ± 5.3% | 737.6 ± 2.1% | 1568.0 ± 2.4% | 1062.2 ± 1.2% | 16.601 | 28.437 | 58.115 | 27.336 | 40.354 |
| hex: canterbury/alice29.txt | 304180 | 42932.4 ± 0.6% | 2590.2 ± 1.3% | 1514.1 ± 1.1% | 477.5 ± 0.9% | 1584.0 ± 0.9% | 1082.3 ± 0.8% | 16.575 | 28.356 | 89.914 | 27.103 | 39.668 |
| hex: canterbury/asyoulik.txt | 250360 | 42842.3 ± 1.3% | 2602.2 ± 0.7% | 1528.2 ± 1.0% | 464.9 ± 1.3% | 1585.5 ± 1.5% | 1079.1 ± 1.1% | 16.464 | 28.034 | 92.152 | 27.021 | 39.701 |
| hex: canterbury/cp.html | 49208 | 42078.0 ± 0.6% | 2575.3 ± 0.5% | 1514.9 ± 0.6% | 510.9 ± 0.9% | 1581.5 ± 0.6% | 1085.3 ± 0.6% | 16.339 | 27.775 | 82.360 | 26.607 | 38.769 |
| hex: canterbury/fields.c | 22302 | 41479.0 ± 1.1% | 2631.0 ± 0.4% | 1524.1 ± 0.5% | 627.2 ± 0.7% | 1596.4 ± 0.9% | 1095.3 ± 0.4% | 15.766 | 27.216 | 66.131 | 25.983 | 37.869 |
| hex: canterbury/grammar.lsp | 7444 | 39487.2 ± 1.0% | 2689.8 ± 0.7% | 1531.8 ± 5.4% | 797.6 ± 1.0% | 1602.2 ± 1.1% | 1100.2 ± 0.6% | 14.680 | 25.779 | 49.506 | 24.646 | 35.891 |
| hex: canterbury/kennedy.xls | 524290 | 41468.8 ± 1.0% | 2561.4 ± 0.4% | 1491.8 ± 4.9% | 742.2 ± 0.7% | 1554.9 ± 0.9% | 1054.4 ± 0.6% | 16.190 | 27.797 | 55.872 | 26.670 | 39.329 |
| hex: canterbury/lcet10.txt | 524290 | 42796.4 ± 1.8% | 2573.9 ± 0.7% | 1493.4 ± 1.0% | 473.8 ± 1.0% | 1557.4 ± 0.8% | 1057.3 ± 1.3% | 16.627 | 28.656 | 90.332 | 27.480 | 40.477 |
| hex: canterbury/plrabn12.txt | 524290 | 43232.5 ± 1.7% | 2583.9 ± 0.6% | 1499.9 ± 0.8% | 454.9 ± 0.9% | 1507.4 ± 0.7% | 1055.6 ± 0.8% | 16.731 | 28.823 | 95.028 | 28.681 | 40.954 |
| hex: canterbury/ptt5 | 524290 | 42706.4 ± 1.4% | 2543.8 ± 0.9% | 1492.0 ± 1.8% | 609.8 ± 2.2% | 1557.6 ± 3.2% | 1055.3 ± 1.3% | 16.788 | 28.623 | 70.030 | 27.418 | 40.467 |
| hex: canterbury/sum | 76482 | 42389.6 ± 1.4% | 2566.9 ± 1.1% | 1506.1 ± 0.5% | 588.2 ± 0.7% | 1570.7 ± 0.4% | 1077.9 ± 4.3% | 16.514 | 28.146 | 72.065 | 26.987 | 39.326 |
| hex: canterbury/xargs.1 | 8456 | 39634.4 ± 3.1% | 2665.8 ± 7.8% | 1528.6 ± 1.1% | 825.3 ± 0.7% | 1599.2 ± 1.0% | 1103.6 ± 0.8% | 14.868 | 25.929 | 48.025 | 24.784 | 35.913 |
| hex: canterbury-large/E.coli | 524290 | 42874.5 ± 1.9% | 2566.0 ± 1.2% | 1491.8 ± 1.3% | 810.2 ± 1.1% | 1553.3 ± 5.7% | 1053.8 ± 2.5% | 16.709 | 28.740 | 52.919 | 27.602 | 40.685 |
| hex: canterbury-large/bible.txt | 524290 | 43219.3 ± 1.6% | 2581.6 ± 0.8% | 1496.0 ± 1.3% | 485.1 ± 3.5% | 1538.0 ± 0.6% | 1058.9 ± 5.8% | 16.741 | 28.889 | 89.101 | 28.100 | 40.813 |
| hex: canterbury-large/world192.txt | 524290 | 42869.5 ± 0.8% | 2558.0 ± 8.9% | 1495.2 ± 0.9% | 463.3 ± 0.7% | 1536.5 ± 0.6% | 1057.2 ± 0.4% | 16.759 | 28.671 | 92.538 | 27.902 | 40.549 |
| hex: http/html-1kx1024 | 2099200 | 20724.9 ± 1.2% | 2426.7 ± 1.5% | 1456.2 ± 3.8% | 513.2 ± 0.4% | 1501.8 ± 0.6% | 1073.5 ± 1.3% | 8.540 | 14.232 | 40.387 | 13.800 | 19.307 |
| hex: http/html-16kx64 | 2097280 | 21617.9 ± 0.4% | 2355.9 ± 7.0% | 1441.0 ± 0.9% | 516.5 ± 1.1% | 1492.4 ± 1.1% | 1076.8 ± 1.4% | 9.176 | 15.002 | 41.857 | 14.485 | 20.077 |
| hex: http/html-1m | 524290 | 39737.5 ± 0.7% | 2575.7 ± 1.2% | 1507.2 ± 0.6% | 504.9 ± 1.0% | 1564.2 ± 5.7% | 1062.9 ± 0.4% | 15.428 | 26.365 | 78.705 | 25.405 | 37.387 |
| hex: http/json-1kx1024 | 2099200 | 20751.8 ± 2.2% | 2430.5 ± 0.3% | 1454.9 ± 1.0% | 687.8 ± 1.2% | 1499.7 ± 1.6% | 1073.7 ± 1.4% | 8.538 | 14.263 | 30.170 | 13.837 | 19.327 |
| hex: http/json-16kx64 | 2097280 | 22515.7 ± 0.1% | 2350.4 ± 1.4% | 1434.4 ± 1.2% | 661.9 ± 0.9% | 1343.2 ± 1.1% | 1078.0 ± 1.0% | 9.579 | 15.697 | 34.015 | 16.763 | 20.887 |
| hex: http/json-1m | 524290 | 42715.6 ± 0.6% | 2559.7 ± 0.6% | 1504.6 ± 0.7% | 705.7 ± 1.3% | 1488.5 ± 0.7% | 1062.7 ± 1.2% | 16.688 | 28.389 | 60.528 | 28.697 | 40.195 |
| hex: http/js-1kx1024 | 2099200 | 20033.7 ± 0.3% | 2422.3 ± 1.4% | 1461.1 ± 1.5% | 497.9 ± 1.0% | 1504.9 ± 0.9% | 1070.1 ± 1.3% | 8.270 | 13.712 | 40.235 | 13.313 | 18.721 |
| hex: http/js-16kx64 | 2097280 | 21171.3 ± 0.4% | 2354.3 ± 7.6% | 1437.6 ± 0.7% | 497.8 ± 0.6% | 1489.3 ± 0.4% | 1075.7 ± 0.9% | 8.992 | 14.727 | 42.527 | 14.216 | 19.682 |
| hex: http/js-1m | 524290 | 42244.8 ± 8.3% | 2576.9 ± 1.0% | 1497.9 ± 0.8% | 514.4 ± 0.8% | 1565.4 ± 0.7% | 1057.5 ± 0.4% | 16.393 | 28.203 | 82.129 | 26.987 | 39.948 |
| hex: http/css-1kx1024 | 2099200 | 20637.0 ± 2.2% | 2423.3 ± 0.7% | 1452.4 ± 4.6% | 570.7 ± 1.2% | 1500.3 ± 0.6% | 1067.6 ± 0.5% | 8.516 | 14.209 | 36.161 | 13.756 | 19.331 |
| hex: http/css-16kx64 | 2097280 | 21644.0 ± 0.4% | 2358.0 ± 0.5% | 1438.5 ± 0.9% | 578.9 ± 1.5% | 1491.0 ± 0.9% | 1078.6 ± 0.8% | 9.179 | 15.046 | 37.390 | 14.517 | 20.067 |
| hex: http/css-1m | 524290 | 42814.3 ± 1.3% | 2562.8 ± 0.6% | 1496.1 ± 1.1% | 552.4 ± 1.2% | 1513.9 ± 1.3% | 1057.7 ± 0.6% | 16.706 | 28.617 | 77.504 | 28.282 | 40.479 |
| hex: shuffled/dickens-1m | 524290 | 43454.8 ± 1.5% | 2591.5 ± 1.5% | 1501.7 ± 0.7% | 465.2 ± 0.9% | 1529.9 ± 1.0% | 1057.2 ± 1.1% | 16.768 | 28.936 | 93.417 | 28.404 | 41.102 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1143.5 ± 1.1% | 1501.9 ± 1.7% | 1116.3 ± 1.7% | 401.1 ± 1.1% | 665.5 ± 1.3% | 365.3 ± 2.1% | 0.761 | 1.024 | 2.851 | 1.718 | 3.131 |
| qlog records, JSON text sequence | 1467503 | 1011.9 ± 2.6% | 1229.1 ± 0.7% | 1126.2 ± 1.8% | 344.2 ± 1.7% | 747.3 ± 1.2% | 317.9 ± 1.3% | 0.823 | 0.899 | 2.940 | 1.354 | 3.183 |
| string: silesia/dickens | 172528 | 6444.1 ± 5.6% | 3458.3 ± 0.7% | 2841.0 ± 1.7% | 308.9 ± 2.0% | 3055.8 ± 1.0% | 562.1 ± 1.1% | 1.863 | 2.268 | 20.863 | 2.109 | 11.464 |
| string: silesia/nci | 1075110 | 5424.7 ± 1.0% | 3893.0 ± 0.6% | 3012.3 ± 0.8% | 642.4 ± 0.5% | 3614.8 ± 0.6% | 565.8 ± 1.3% | 1.393 | 1.801 | 8.445 | 1.501 | 9.587 |
| string: silesia/reymont | 1075159 | 3432.7 ± 1.9% | 3409.1 ± 0.6% | 1935.2 ± 1.7% | 324.8 ± 3.7% | 2082.6 ± 1.0% | 488.4 ± 2.3% | 1.007 | 1.774 | 10.567 | 1.648 | 7.028 |
| string: silesia/samba | 97582 | 4012.9 ± 4.7% | 3792.9 ± 0.7% | 3068.3 ± 4.4% | 333.5 ± 1.0% | 1895.1 ± 0.8% | 418.1 ± 1.9% | 1.058 | 1.308 | 12.032 | 2.118 | 9.598 |
| string: silesia/webster | 1098490 | 4417.6 ± 0.8% | 2443.6 ± 1.1% | 1737.8 ± 0.9% | 301.8 ± 0.5% | 2064.2 ± 0.7% | 460.2 ± 4.2% | 1.808 | 2.542 | 14.637 | 2.140 | 9.599 |
| string: silesia/xml | 1090118 | 6047.5 ± 0.8% | 4963.1 ± 1.1% | 2424.9 ± 1.0% | 503.2 ± 1.3% | 3300.1 ± 0.7% | 539.8 ± 1.3% | 1.218 | 2.494 | 12.019 | 1.833 | 11.203 |
| string: canterbury/alice29.txt | 159425 | 5690.7 ± 1.2% | 2751.6 ± 3.0% | 2790.7 ± 2.1% | 293.5 ± 1.0% | 2752.6 ± 1.6% | 513.4 ± 0.7% | 2.068 | 2.039 | 19.387 | 2.067 | 11.084 |
| string: canterbury/asyoulik.txt | 132198 | 4261.7 ± 1.7% | 2624.5 ± 3.0% | 2816.5 ± 1.2% | 298.4 ± 0.9% | 2382.0 ± 1.5% | 452.9 ± 1.5% | 1.624 | 1.513 | 14.282 | 1.789 | 9.410 |
| string: canterbury/lcet10.txt | 441884 | 6677.1 ± 0.2% | 3285.0 ± 0.4% | 2334.4 ± 0.4% | 341.3 ± 0.5% | 2774.5 ± 2.3% | 554.4 ± 2.8% | 2.033 | 2.860 | 19.566 | 2.407 | 12.044 |
| string: canterbury/plrabn12.txt | 503330 | 5461.1 ± 1.8% | 3151.4 ± 1.2% | 1839.3 ± 1.4% | 321.1 ± 1.0% | 2827.9 ± 0.4% | 530.8 ± 0.7% | 1.733 | 2.969 | 17.005 | 1.931 | 10.289 |
| string: canterbury-large/E.coli | 1048578 | 34115.6 ± 0.9% | 13034.0 ± 0.2% | 3377.8 ± 0.8% | 1282.7 ± 0.4% | 8910.1 ± 5.4% | 935.3 ± 6.5% | 2.617 | 10.100 | 26.597 | 3.829 | 36.474 |
| string: canterbury-large/bible.txt | 1055886 | 8544.1 ± 0.7% | 5252.4 ± 1.1% | 2789.1 ± 0.9% | 353.4 ± 0.7% | 3855.5 ± 1.0% | 620.1 ± 1.8% | 1.627 | 3.063 | 24.176 | 2.216 | 13.778 |
| string: canterbury-large/world192.txt | 1103121 | 4151.2 ± 0.6% | 2306.1 ± 1.9% | 1765.6 ± 0.4% | 327.8 ± 1.1% | 2099.2 ± 1.8% | 456.7 ± 1.7% | 1.800 | 2.351 | 12.663 | 1.977 | 9.090 |
| string: http/html-1m | 1058582 | 8730.8 ± 6.1% | 4705.2 ± 2.0% | 2673.4 ± 0.8% | 399.6 ± 1.0% | 3596.7 ± 1.3% | 580.7 ± 4.5% | 1.856 | 3.266 | 21.849 | 2.427 | 15.036 |
| string: http/json-1m | 1190272 | 3235.1 ± 1.6% | 1254.0 ± 1.2% | 2029.0 ± 1.2% | 480.7 ± 1.7% | 1339.8 ± 2.1% | 431.3 ± 3.1% | 2.580 | 1.594 | 6.730 | 2.415 | 7.501 |
| string: http/js-1m | 1144362 | 2889.3 ± 0.5% | 1614.9 ± 0.2% | 1331.0 ± 0.9% | 322.7 ± 0.1% | 1420.7 ± 0.3% | 376.9 ± 1.0% | 1.789 | 2.171 | 8.954 | 2.034 | 7.666 |
| string: http/css-1m | 1097820 | 3303.6 ± 1.1% | 2888.3 ± 0.8% | 2260.6 ± 0.5% | 442.3 ± 1.1% | 2076.6 ± 0.6% | 432.6 ± 0.9% | 1.144 | 1.461 | 7.469 | 1.591 | 7.637 |
| string: dickens as Cyrillic and CJK | 1883069 | 5770.7 ± 0.8% | 2896.8 ± 5.4% | 661.6 ± 0.6% | 371.7 ± 1.3% | 510.0 ± 1.3% | 165.8 ± 4.3% | 1.992 | 8.722 | 15.526 | 11.315 | 34.808 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1193.5 ± 1.2% | 1228.1 ± 1.6% | 1088.8 ± 0.7% | 265.5 ± 1.0% | 476.8 ± 0.5% | 227.4 ± 4.7% | 0.972 | 1.096 | 4.495 | 2.503 | 5.249 |
| hex: silesia/dickens | 524290 | 33828.1 ± 0.5% | 14953.9 ± 0.8% | 3484.7 ± 0.9% | 479.1 ± 1.0% | 8840.2 ± 1.2% | 1125.7 ± 2.4% | 2.262 | 9.708 | 70.614 | 3.827 | 30.051 |
| hex: silesia/mozilla | 524290 | 33784.7 ± 1.5% | 15002.0 ± 1.1% | 3571.0 ± 1.3% | 429.2 ± 1.9% | 8939.7 ± 0.8% | 1132.3 ± 1.9% | 2.252 | 9.461 | 78.712 | 3.779 | 29.837 |
| hex: silesia/mr | 524290 | 33724.9 ± 0.5% | 14971.3 ± 2.1% | 3548.5 ± 1.4% | 641.1 ± 0.3% | 8872.2 ± 0.9% | 1124.4 ± 1.0% | 2.253 | 9.504 | 52.607 | 3.801 | 29.994 |
| hex: silesia/nci | 524290 | 33757.5 ± 0.8% | 14999.1 ± 0.8% | 3500.1 ± 1.2% | 796.5 ± 0.4% | 8860.3 ± 0.8% | 1130.9 ± 0.7% | 2.251 | 9.645 | 42.383 | 3.810 | 29.850 |
| hex: silesia/ooffice | 524290 | 33743.3 ± 0.7% | 14965.4 ± 0.8% | 3551.4 ± 0.9% | 342.9 ± 1.2% | 8879.7 ± 1.1% | 1130.0 ± 3.4% | 2.255 | 9.501 | 98.418 | 3.800 | 29.861 |
| hex: silesia/osdb | 524290 | 33804.2 ± 0.9% | 14988.2 ± 0.7% | 3539.0 ± 0.9% | 447.9 ± 2.7% | 8870.3 ± 0.9% | 1128.4 ± 1.2% | 2.255 | 9.552 | 75.470 | 3.811 | 29.957 |
| hex: silesia/reymont | 524290 | 33717.9 ± 1.0% | 15008.9 ± 0.3% | 3471.8 ± 3.4% | 502.9 ± 1.3% | 8868.0 ± 0.5% | 1128.6 ± 0.9% | 2.247 | 9.712 | 67.047 | 3.802 | 29.875 |
| hex: silesia/samba | 524290 | 33743.3 ± 0.7% | 14955.0 ± 0.9% | 3545.4 ± 0.7% | 365.6 ± 0.6% | 8854.5 ± 1.1% | 1126.3 ± 0.8% | 2.256 | 9.517 | 92.293 | 3.811 | 29.959 |
| hex: silesia/sao | 524290 | 33850.9 ± 0.7% | 15007.8 ± 1.2% | 3447.4 ± 3.7% | 276.6 ± 1.3% | 8875.7 ± 0.6% | 1127.7 ± 0.7% | 2.256 | 9.819 | 122.373 | 3.814 | 30.016 |
| hex: silesia/webster | 524290 | 33796.2 ± 1.3% | 15054.9 ± 0.7% | 3574.6 ± 1.2% | 448.6 ± 1.7% | 8856.6 ± 2.0% | 1126.2 ± 0.9% | 2.245 | 9.455 | 75.339 | 3.816 | 30.010 |
| hex: silesia/x-ray | 524290 | 33695.6 ± 0.9% | 14967.0 ± 0.8% | 3459.8 ± 2.7% | 422.8 ± 1.5% | 8884.5 ± 1.0% | 1126.1 ± 1.1% | 2.251 | 9.739 | 79.704 | 3.793 | 29.921 |
| hex: silesia/xml | 524290 | 33743.7 ± 1.0% | 14976.0 ± 1.0% | 3549.7 ± 0.8% | 728.2 ± 2.4% | 8890.0 ± 0.6% | 1125.5 ± 1.0% | 2.253 | 9.506 | 46.337 | 3.796 | 29.981 |
| hex: canterbury/alice29.txt | 304180 | 33706.4 ± 0.4% | 14050.7 ± 0.8% | 3542.4 ± 2.3% | 484.2 ± 0.7% | 8874.8 ± 1.0% | 1135.9 ± 0.9% | 2.399 | 9.515 | 69.619 | 3.798 | 29.675 |
| hex: canterbury/asyoulik.txt | 250360 | 33626.6 ± 0.9% | 14859.4 ± 0.4% | 3478.8 ± 0.7% | 468.9 ± 2.7% | 8840.5 ± 0.6% | 1131.3 ± 1.2% | 2.263 | 9.666 | 71.709 | 3.804 | 29.724 |
| hex: canterbury/cp.html | 49208 | 33272.6 ± 3.3% | 14392.6 ± 0.9% | 3542.7 ± 0.6% | 500.4 ± 1.3% | 9236.2 ± 1.0% | 1115.5 ± 1.4% | 2.312 | 9.392 | 66.491 | 3.602 | 29.826 |
| hex: canterbury/fields.c | 22302 | 32777.6 ± 1.1% | 17217.0 ± 1.2% | 3651.2 ± 1.2% | 560.1 ± 1.2% | 9153.6 ± 1.4% | 1084.3 ± 2.5% | 1.904 | 8.977 | 58.526 | 3.581 | 30.230 |
| hex: canterbury/grammar.lsp | 7444 | 29697.7 ± 3.6% | 17107.1 ± 0.6% | 3603.2 ± 0.8% | 751.1 ± 5.3% | 8878.3 ± 0.5% | 1030.1 ± 4.5% | 1.736 | 8.242 | 39.540 | 3.345 | 28.831 |
| hex: canterbury/kennedy.xls | 524290 | 33711.6 ± 1.0% | 13938.8 ± 0.6% | 3493.2 ± 0.4% | 749.8 ± 0.9% | 8855.4 ± 0.5% | 1112.4 ± 8.9% | 2.419 | 9.651 | 44.959 | 3.807 | 30.304 |
| hex: canterbury/lcet10.txt | 524290 | 33814.8 ± 0.5% | 13951.4 ± 0.4% | 3542.5 ± 1.2% | 485.4 ± 0.3% | 8856.8 ± 5.1% | 1100.4 ± 3.0% | 2.424 | 9.545 | 69.659 | 3.818 | 30.730 |
| hex: canterbury/plrabn12.txt | 524290 | 33812.6 ± 0.4% | 14010.0 ± 0.4% | 3547.1 ± 1.3% | 466.0 ± 0.5% | 8876.4 ± 4.4% | 1116.9 ± 0.9% | 2.413 | 9.533 | 72.562 | 3.809 | 30.273 |
| hex: canterbury/ptt5 | 524290 | 33832.0 ± 4.5% | 13990.2 ± 0.4% | 3488.6 ± 0.4% | 666.3 ± 2.2% | 8874.0 ± 0.6% | 1127.2 ± 0.9% | 2.418 | 9.698 | 50.777 | 3.812 | 30.015 |
| hex: canterbury/sum | 76482 | 33201.3 ± 0.7% | 15398.8 ± 0.4% | 3547.2 ± 0.2% | 581.6 ± 0.7% | 8883.0 ± 0.6% | 1112.4 ± 2.8% | 2.156 | 9.360 | 57.090 | 3.738 | 29.845 |
| hex: canterbury/xargs.1 | 8456 | 30116.3 ± 3.9% | 17325.5 ± 1.2% | 3553.4 ± 0.7% | 721.9 ± 2.3% | 8921.2 ± 0.6% | 1082.8 ± 4.3% | 1.738 | 8.475 | 41.719 | 3.376 | 27.813 |
| hex: canterbury-large/E.coli | 524290 | 33752.0 ± 0.5% | 14961.4 ± 1.2% | 3484.0 ± 0.9% | 958.8 ± 0.8% | 8872.7 ± 0.7% | 1098.9 ± 6.5% | 2.256 | 9.688 | 35.203 | 3.804 | 30.714 |
| hex: canterbury-large/bible.txt | 524290 | 33740.8 ± 1.2% | 14962.8 ± 1.0% | 3489.2 ± 1.1% | 499.0 ± 0.9% | 8887.4 ± 1.1% | 1109.6 ± 2.8% | 2.255 | 9.670 | 67.618 | 3.797 | 30.407 |
| hex: canterbury-large/world192.txt | 524290 | 33979.9 ± 1.3% | 15045.1 ± 0.7% | 3556.3 ± 1.1% | 470.2 ± 1.1% | 8921.0 ± 1.2% | 1119.8 ± 0.7% | 2.259 | 9.555 | 72.274 | 3.809 | 30.345 |
| hex: http/html-1kx1024 | 2099200 | 14848.2 ± 1.0% | 11907.3 ± 11.6% | 3116.2 ± 0.9% | 503.9 ± 0.8% | 7372.5 ± 1.9% | 961.2 ± 1.5% | 1.247 | 4.765 | 29.467 | 2.014 | 15.447 |
| hex: http/html-16kx64 | 2097280 | 26744.8 ± 0.5% | 13613.1 ± 0.2% | 3380.1 ± 0.8% | 513.3 ± 1.9% | 8318.1 ± 1.3% | 1056.2 ± 3.9% | 1.965 | 7.913 | 52.109 | 3.215 | 25.321 |
| hex: http/html-1m | 524290 | 33826.8 ± 1.0% | 15042.8 ± 0.8% | 3506.2 ± 0.9% | 505.1 ± 1.2% | 8902.7 ± 0.9% | 1089.9 ± 3.3% | 2.249 | 9.648 | 66.969 | 3.800 | 31.038 |
| hex: http/json-1kx1024 | 2099200 | 14915.0 ± 1.7% | 12144.0 ± 0.6% | 3137.2 ± 0.4% | 681.7 ± 0.9% | 7321.3 ± 3.9% | 956.2 ± 2.3% | 1.228 | 4.754 | 21.880 | 2.037 | 15.598 |
| hex: http/json-16kx64 | 2097280 | 27567.1 ± 0.2% | 13675.8 ± 0.2% | 3400.0 ± 0.4% | 693.8 ± 1.1% | 8390.2 ± 7.8% | 1064.0 ± 4.1% | 2.016 | 8.108 | 39.732 | 3.286 | 25.908 |
| hex: http/json-1m | 524290 | 34034.3 ± 0.5% | 15079.3 ± 0.5% | 3555.0 ± 0.5% | 717.9 ± 0.8% | 8934.3 ± 0.4% | 1118.1 ± 2.6% | 2.257 | 9.574 | 47.409 | 3.809 | 30.439 |
| hex: http/js-1kx1024 | 2099200 | 14762.5 ± 1.7% | 12404.9 ± 0.5% | 3125.8 ± 0.3% | 491.9 ± 0.6% | 7394.0 ± 2.3% | 939.9 ± 4.4% | 1.190 | 4.723 | 30.011 | 1.997 | 15.706 |
| hex: http/js-16kx64 | 2097280 | 27778.9 ± 0.5% | 13798.8 ± 0.8% | 3387.6 ± 1.1% | 498.0 ± 0.6% | 8591.7 ± 1.0% | 1036.7 ± 3.2% | 2.013 | 8.200 | 55.785 | 3.233 | 26.795 |
| hex: http/js-1m | 524290 | 34021.0 ± 0.1% | 15022.2 ± 3.1% | 3564.8 ± 0.4% | 515.6 ± 2.7% | 8950.3 ± 0.9% | 1114.4 ± 2.6% | 2.265 | 9.543 | 65.983 | 3.801 | 30.527 |
| hex: http/css-1kx1024 | 2099200 | 14767.5 ± 0.6% | 12348.7 ± 1.1% | 3130.8 ± 0.5% | 570.7 ± 0.4% | 7287.8 ± 4.1% | 947.7 ± 1.1% | 1.196 | 4.717 | 25.875 | 2.026 | 15.583 |
| hex: http/css-16kx64 | 2097280 | 27210.6 ± 0.4% | 13941.2 ± 0.2% | 3392.4 ± 0.6% | 581.7 ± 1.0% | 8432.6 ± 8.0% | 1053.5 ± 3.6% | 1.952 | 8.021 | 46.775 | 3.227 | 25.828 |
| hex: http/css-1m | 524290 | 33948.5 ± 1.2% | 14978.5 ± 1.1% | 3540.0 ± 1.3% | 561.4 ± 3.5% | 8947.1 ± 1.3% | 1109.5 ± 2.3% | 2.266 | 9.590 | 60.467 | 3.794 | 30.598 |
| hex: shuffled/dickens-1m | 524290 | 33802.8 ± 0.9% | 14950.7 ± 0.9% | 3486.1 ± 1.2% | 478.1 ± 1.5% | 8862.3 ± 1.4% | 1110.8 ± 4.1% | 2.261 | 9.696 | 70.703 | 3.814 | 30.431 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1302.9 ± 1.1% | 1501.9 ± 1.7% | 1116.3 ± 1.7% | 401.1 ± 1.1% | 665.5 ± 1.3% | 365.3 ± 2.1% | 0.868 | 1.167 | 3.249 | 1.958 | 3.567 |
| qlog records, JSON text sequence | 1467503 | 1171.3 ± 2.1% | 1229.1 ± 0.7% | 1126.2 ± 1.8% | 344.2 ± 1.7% | 747.3 ± 1.2% | 317.9 ± 1.3% | 0.953 | 1.040 | 3.403 | 1.567 | 3.684 |
| string: silesia/dickens | 172528 | 6505.6 ± 1.0% | 3458.3 ± 0.7% | 2841.0 ± 1.7% | 308.9 ± 2.0% | 3055.8 ± 1.0% | 562.1 ± 1.1% | 1.881 | 2.290 | 21.062 | 2.129 | 11.573 |
| string: silesia/nci | 1075110 | 5429.1 ± 0.5% | 3893.0 ± 0.6% | 3012.3 ± 0.8% | 642.4 ± 0.5% | 3614.8 ± 0.6% | 565.8 ± 1.3% | 1.395 | 1.802 | 8.451 | 1.502 | 9.595 |
| string: silesia/reymont | 1075159 | 3447.9 ± 2.9% | 3409.1 ± 0.6% | 1935.2 ± 1.7% | 324.8 ± 3.7% | 2082.6 ± 1.0% | 488.4 ± 2.3% | 1.011 | 1.782 | 10.614 | 1.656 | 7.059 |
| string: silesia/samba | 97582 | 4018.1 ± 0.9% | 3792.9 ± 0.7% | 3068.3 ± 4.4% | 333.5 ± 1.0% | 1895.1 ± 0.8% | 418.1 ± 1.9% | 1.059 | 1.310 | 12.048 | 2.120 | 9.611 |
| string: silesia/webster | 1098490 | 4443.9 ± 1.2% | 2443.6 ± 1.1% | 1737.8 ± 0.9% | 301.8 ± 0.5% | 2064.2 ± 0.7% | 460.2 ± 4.2% | 1.819 | 2.557 | 14.725 | 2.153 | 9.656 |
| string: silesia/xml | 1090118 | 6071.0 ± 1.1% | 4963.1 ± 1.1% | 2424.9 ± 1.0% | 503.2 ± 1.3% | 3300.1 ± 0.7% | 539.8 ± 1.3% | 1.223 | 2.504 | 12.065 | 1.840 | 11.247 |
| string: canterbury/alice29.txt | 159425 | 5737.3 ± 1.0% | 2751.6 ± 3.0% | 2790.7 ± 2.1% | 293.5 ± 1.0% | 2752.6 ± 1.6% | 513.4 ± 0.7% | 2.085 | 2.056 | 19.546 | 2.084 | 11.175 |
| string: canterbury/asyoulik.txt | 132198 | 4319.8 ± 2.2% | 2624.5 ± 3.0% | 2816.5 ± 1.2% | 298.4 ± 0.9% | 2382.0 ± 1.5% | 452.9 ± 1.5% | 1.646 | 1.534 | 14.477 | 1.813 | 9.538 |
| string: canterbury/lcet10.txt | 441884 | 6715.3 ± 0.5% | 3285.0 ± 0.4% | 2334.4 ± 0.4% | 341.3 ± 0.5% | 2774.5 ± 2.3% | 554.4 ± 2.8% | 2.044 | 2.877 | 19.678 | 2.420 | 12.112 |
| string: canterbury/plrabn12.txt | 503330 | 5459.2 ± 1.0% | 3151.4 ± 1.2% | 1839.3 ± 1.4% | 321.1 ± 1.0% | 2827.9 ± 0.4% | 530.8 ± 0.7% | 1.732 | 2.968 | 16.999 | 1.930 | 10.285 |
| string: canterbury-large/E.coli | 1048578 | 33946.7 ± 1.1% | 13034.0 ± 0.2% | 3377.8 ± 0.8% | 1282.7 ± 0.4% | 8910.1 ± 5.4% | 935.3 ± 6.5% | 2.604 | 10.050 | 26.465 | 3.810 | 36.293 |
| string: canterbury-large/bible.txt | 1055886 | 8562.8 ± 0.9% | 5252.4 ± 1.1% | 2789.1 ± 0.9% | 353.4 ± 0.7% | 3855.5 ± 1.0% | 620.1 ± 1.8% | 1.630 | 3.070 | 24.229 | 2.221 | 13.808 |
| string: canterbury-large/world192.txt | 1103121 | 4174.4 ± 1.0% | 2306.1 ± 1.9% | 1765.6 ± 0.4% | 327.8 ± 1.1% | 2099.2 ± 1.8% | 456.7 ± 1.7% | 1.810 | 2.364 | 12.734 | 1.989 | 9.140 |
| string: http/html-1m | 1058582 | 9545.2 ± 2.1% | 4705.2 ± 2.0% | 2673.4 ± 0.8% | 399.6 ± 1.0% | 3596.7 ± 1.3% | 580.7 ± 4.5% | 2.029 | 3.570 | 23.887 | 2.654 | 16.438 |
| string: http/json-1m | 1190272 | 3245.6 ± 1.7% | 1254.0 ± 1.2% | 2029.0 ± 1.2% | 480.7 ± 1.7% | 1339.8 ± 2.1% | 431.3 ± 3.1% | 2.588 | 1.600 | 6.752 | 2.422 | 7.526 |
| string: http/js-1m | 1144362 | 2890.9 ± 0.6% | 1614.9 ± 0.2% | 1331.0 ± 0.9% | 322.7 ± 0.1% | 1420.7 ± 0.3% | 376.9 ± 1.0% | 1.790 | 2.172 | 8.959 | 2.035 | 7.671 |
| string: http/css-1m | 1097820 | 3320.1 ± 1.4% | 2888.3 ± 0.8% | 2260.6 ± 0.5% | 442.3 ± 1.1% | 2076.6 ± 0.6% | 432.6 ± 0.9% | 1.150 | 1.469 | 7.506 | 1.599 | 7.675 |
| string: dickens as Cyrillic and CJK | 1883069 | 5795.0 ± 0.7% | 2896.8 ± 5.4% | 661.6 ± 0.6% | 371.7 ± 1.3% | 510.0 ± 1.3% | 165.8 ± 4.3% | 2.000 | 8.759 | 15.591 | 11.362 | 34.955 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1203.9 ± 0.3% | 1228.1 ± 1.6% | 1088.8 ± 0.7% | 265.5 ± 1.0% | 476.8 ± 0.5% | 227.4 ± 4.7% | 0.980 | 1.106 | 4.534 | 2.525 | 5.295 |
| hex: silesia/dickens | 524290 | 33795.8 ± 0.7% | 14953.9 ± 0.8% | 3484.7 ± 0.9% | 479.1 ± 1.0% | 8840.2 ± 1.2% | 1125.7 ± 2.4% | 2.260 | 9.698 | 70.547 | 3.823 | 30.023 |
| hex: silesia/mozilla | 524290 | 33825.9 ± 1.2% | 15002.0 ± 1.1% | 3571.0 ± 1.3% | 429.2 ± 1.9% | 8939.7 ± 0.8% | 1132.3 ± 1.9% | 2.255 | 9.472 | 78.808 | 3.784 | 29.873 |
| hex: silesia/mr | 524290 | 33759.9 ± 0.4% | 14971.3 ± 2.1% | 3548.5 ± 1.4% | 641.1 ± 0.3% | 8872.2 ± 0.9% | 1124.4 ± 1.0% | 2.255 | 9.514 | 52.662 | 3.805 | 30.026 |
| hex: silesia/nci | 524290 | 33917.3 ± 1.3% | 14999.1 ± 0.8% | 3500.1 ± 1.2% | 796.5 ± 0.4% | 8860.3 ± 0.8% | 1130.9 ± 0.7% | 2.261 | 9.690 | 42.583 | 3.828 | 29.991 |
| hex: silesia/ooffice | 524290 | 33800.8 ± 0.8% | 14965.4 ± 0.8% | 3551.4 ± 0.9% | 342.9 ± 1.2% | 8879.7 ± 1.1% | 1130.0 ± 3.4% | 2.259 | 9.518 | 98.586 | 3.807 | 29.912 |
| hex: silesia/osdb | 524290 | 33826.0 ± 0.6% | 14988.2 ± 0.7% | 3539.0 ± 0.9% | 447.9 ± 2.7% | 8870.3 ± 0.9% | 1128.4 ± 1.2% | 2.257 | 9.558 | 75.519 | 3.813 | 29.977 |
| hex: silesia/reymont | 524290 | 33768.5 ± 4.5% | 15008.9 ± 0.3% | 3471.8 ± 3.4% | 502.9 ± 1.3% | 8868.0 ± 0.5% | 1128.6 ± 0.9% | 2.250 | 9.726 | 67.148 | 3.808 | 29.919 |
| hex: silesia/samba | 524290 | 33742.5 ± 0.5% | 14955.0 ± 0.9% | 3545.4 ± 0.7% | 365.6 ± 0.6% | 8854.5 ± 1.1% | 1126.3 ± 0.8% | 2.256 | 9.517 | 92.290 | 3.811 | 29.959 |
| hex: silesia/sao | 524290 | 33869.9 ± 0.5% | 15007.8 ± 1.2% | 3447.4 ± 3.7% | 276.6 ± 1.3% | 8875.7 ± 0.6% | 1127.7 ± 0.7% | 2.257 | 9.825 | 122.442 | 3.816 | 30.033 |
| hex: silesia/webster | 524290 | 33944.1 ± 1.0% | 15054.9 ± 0.7% | 3574.6 ± 1.2% | 448.6 ± 1.7% | 8856.6 ± 2.0% | 1126.2 ± 0.9% | 2.255 | 9.496 | 75.668 | 3.833 | 30.141 |
| hex: silesia/x-ray | 524290 | 33961.0 ± 1.0% | 14967.0 ± 0.8% | 3459.8 ± 2.7% | 422.8 ± 1.5% | 8884.5 ± 1.0% | 1126.1 ± 1.1% | 2.269 | 9.816 | 80.332 | 3.822 | 30.157 |
| hex: silesia/xml | 524290 | 33706.1 ± 0.3% | 14976.0 ± 1.0% | 3549.7 ± 0.8% | 728.2 ± 2.4% | 8890.0 ± 0.6% | 1125.5 ± 1.0% | 2.251 | 9.495 | 46.286 | 3.791 | 29.948 |
| hex: canterbury/alice29.txt | 304180 | 33572.5 ± 0.5% | 14050.7 ± 0.8% | 3542.4 ± 2.3% | 484.2 ± 0.7% | 8874.8 ± 1.0% | 1135.9 ± 0.9% | 2.389 | 9.477 | 69.343 | 3.783 | 29.557 |
| hex: canterbury/asyoulik.txt | 250360 | 33598.2 ± 0.8% | 14859.4 ± 0.4% | 3478.8 ± 0.7% | 468.9 ± 2.7% | 8840.5 ± 0.6% | 1131.3 ± 1.2% | 2.261 | 9.658 | 71.648 | 3.801 | 29.699 |
| hex: canterbury/cp.html | 49208 | 33355.0 ± 1.0% | 14392.6 ± 0.9% | 3542.7 ± 0.6% | 500.4 ± 1.3% | 9236.2 ± 1.0% | 1115.5 ± 1.4% | 2.318 | 9.415 | 66.656 | 3.611 | 29.900 |
| hex: canterbury/fields.c | 22302 | 32768.8 ± 0.9% | 17217.0 ± 1.2% | 3651.2 ± 1.2% | 560.1 ± 1.2% | 9153.6 ± 1.4% | 1084.3 ± 2.5% | 1.903 | 8.975 | 58.510 | 3.580 | 30.222 |
| hex: canterbury/grammar.lsp | 7444 | 29567.0 ± 0.8% | 17107.1 ± 0.6% | 3603.2 ± 0.8% | 751.1 ± 5.3% | 8878.3 ± 0.5% | 1030.1 ± 4.5% | 1.728 | 8.206 | 39.366 | 3.330 | 28.704 |
| hex: canterbury/kennedy.xls | 524290 | 33730.5 ± 0.5% | 13938.8 ± 0.6% | 3493.2 ± 0.4% | 749.8 ± 0.9% | 8855.4 ± 0.5% | 1112.4 ± 8.9% | 2.420 | 9.656 | 44.985 | 3.809 | 30.321 |
| hex: canterbury/lcet10.txt | 524290 | 33687.0 ± 0.3% | 13951.4 ± 0.4% | 3542.5 ± 1.2% | 485.4 ± 0.3% | 8856.8 ± 5.1% | 1100.4 ± 3.0% | 2.415 | 9.509 | 69.396 | 3.804 | 30.614 |
| hex: canterbury/plrabn12.txt | 524290 | 33853.5 ± 0.4% | 14010.0 ± 0.4% | 3547.1 ± 1.3% | 466.0 ± 0.5% | 8876.4 ± 4.4% | 1116.9 ± 0.9% | 2.416 | 9.544 | 72.650 | 3.814 | 30.309 |
| hex: canterbury/ptt5 | 524290 | 33886.9 ± 0.7% | 13990.2 ± 0.4% | 3488.6 ± 0.4% | 666.3 ± 2.2% | 8874.0 ± 0.6% | 1127.2 ± 0.9% | 2.422 | 9.714 | 50.859 | 3.819 | 30.064 |
| hex: canterbury/sum | 76482 | 33245.0 ± 0.4% | 15398.8 ± 0.4% | 3547.2 ± 0.2% | 581.6 ± 0.7% | 8883.0 ± 0.6% | 1112.4 ± 2.8% | 2.159 | 9.372 | 57.165 | 3.743 | 29.885 |
| hex: canterbury/xargs.1 | 8456 | 30064.4 ± 1.3% | 17325.5 ± 1.2% | 3553.4 ± 0.7% | 721.9 ± 2.3% | 8921.2 ± 0.6% | 1082.8 ± 4.3% | 1.735 | 8.461 | 41.647 | 3.370 | 27.765 |
| hex: canterbury-large/E.coli | 524290 | 33770.8 ± 0.5% | 14961.4 ± 1.2% | 3484.0 ± 0.9% | 958.8 ± 0.8% | 8872.7 ± 0.7% | 1098.9 ± 6.5% | 2.257 | 9.693 | 35.222 | 3.806 | 30.731 |
| hex: canterbury-large/bible.txt | 524290 | 33902.9 ± 0.6% | 14962.8 ± 1.0% | 3489.2 ± 1.1% | 499.0 ± 0.9% | 8887.4 ± 1.1% | 1109.6 ± 2.8% | 2.266 | 9.716 | 67.943 | 3.815 | 30.553 |
| hex: canterbury-large/world192.txt | 524290 | 33919.3 ± 1.4% | 15045.1 ± 0.7% | 3556.3 ± 1.1% | 470.2 ± 1.1% | 8921.0 ± 1.2% | 1119.8 ± 0.7% | 2.255 | 9.538 | 72.146 | 3.802 | 30.291 |
| hex: http/html-1kx1024 | 2099200 | 14497.3 ± 3.2% | 11907.3 ± 11.6% | 3116.2 ± 0.9% | 503.9 ± 0.8% | 7372.5 ± 1.9% | 961.2 ± 1.5% | 1.218 | 4.652 | 28.771 | 1.966 | 15.082 |
| hex: http/html-16kx64 | 2097280 | 26663.0 ± 0.7% | 13613.1 ± 0.2% | 3380.1 ± 0.8% | 513.3 ± 1.9% | 8318.1 ± 1.3% | 1056.2 ± 3.9% | 1.959 | 7.888 | 51.949 | 3.205 | 25.244 |
| hex: http/html-1m | 524290 | 33808.5 ± 1.1% | 15042.8 ± 0.8% | 3506.2 ± 0.9% | 505.1 ± 1.2% | 8902.7 ± 0.9% | 1089.9 ± 3.3% | 2.247 | 9.643 | 66.933 | 3.798 | 31.021 |
| hex: http/json-1kx1024 | 2099200 | 14569.7 ± 0.6% | 12144.0 ± 0.6% | 3137.2 ± 0.4% | 681.7 ± 0.9% | 7321.3 ± 3.9% | 956.2 ± 2.3% | 1.200 | 4.644 | 21.373 | 1.990 | 15.237 |
| hex: http/json-16kx64 | 2097280 | 27483.0 ± 4.1% | 13675.8 ± 0.2% | 3400.0 ± 0.4% | 693.8 ± 1.1% | 8390.2 ± 7.8% | 1064.0 ± 4.1% | 2.010 | 8.083 | 39.611 | 3.276 | 25.829 |
| hex: http/json-1m | 524290 | 33998.2 ± 0.2% | 15079.3 ± 0.5% | 3555.0 ± 0.5% | 717.9 ± 0.8% | 8934.3 ± 0.4% | 1118.1 ± 2.6% | 2.255 | 9.564 | 47.359 | 3.805 | 30.406 |
| hex: http/js-1kx1024 | 2099200 | 14300.3 ± 1.0% | 12404.9 ± 0.5% | 3125.8 ± 0.3% | 491.9 ± 0.6% | 7394.0 ± 2.3% | 939.9 ± 4.4% | 1.153 | 4.575 | 29.072 | 1.934 | 15.215 |
| hex: http/js-16kx64 | 2097280 | 27736.3 ± 0.2% | 13798.8 ± 0.8% | 3387.6 ± 1.1% | 498.0 ± 0.6% | 8591.7 ± 1.0% | 1036.7 ± 3.2% | 2.010 | 8.188 | 55.699 | 3.228 | 26.754 |
| hex: http/js-1m | 524290 | 34036.9 ± 0.1% | 15022.2 ± 3.1% | 3564.8 ± 0.4% | 515.6 ± 2.7% | 8950.3 ± 0.9% | 1114.4 ± 2.6% | 2.266 | 9.548 | 66.014 | 3.803 | 30.542 |
| hex: http/css-1kx1024 | 2099200 | 14385.2 ± 0.4% | 12348.7 ± 1.1% | 3130.8 ± 0.5% | 570.7 ± 0.4% | 7287.8 ± 4.1% | 947.7 ± 1.1% | 1.165 | 4.595 | 25.205 | 1.974 | 15.179 |
| hex: http/css-16kx64 | 2097280 | 27233.4 ± 0.2% | 13941.2 ± 0.2% | 3392.4 ± 0.6% | 581.7 ± 1.0% | 8432.6 ± 8.0% | 1053.5 ± 3.6% | 1.953 | 8.028 | 46.814 | 3.230 | 25.849 |
| hex: http/css-1m | 524290 | 33705.8 ± 5.4% | 14978.5 ± 1.1% | 3540.0 ± 1.3% | 561.4 ± 3.5% | 8947.1 ± 1.3% | 1109.5 ± 2.3% | 2.250 | 9.521 | 60.035 | 3.767 | 30.380 |
| hex: shuffled/dickens-1m | 524290 | 33666.6 ± 0.9% | 14950.7 ± 0.9% | 3486.1 ± 1.2% | 478.1 ± 1.5% | 8862.3 ± 1.4% | 1110.8 ± 4.1% | 2.252 | 9.657 | 70.418 | 3.799 | 30.308 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1570.4 ± 0.7% | 1469.5 ± 2.8% | 1018.4 ± 0.8% | 482.1 ± 0.8% | 486.1 ± 2.4% | 501.7 ± 0.8% | 1.069 | 1.542 | 3.258 | 3.231 | 3.130 |
| qlog records, JSON text sequence | 1467503 | 1436.4 ± 0.8% | 1223.9 ± 2.3% | 920.5 ± 2.1% | 455.1 ± 4.2% | 570.7 ± 1.1% | 350.1 ± 1.6% | 1.174 | 1.560 | 3.156 | 2.517 | 4.103 |
| string: silesia/dickens | 172528 | 11989.5 ± 1.2% | 3926.2 ± 0.6% | 3060.2 ± 1.9% | 354.8 ± 0.4% | 1702.4 ± 1.1% | 1182.1 ± 0.8% | 3.054 | 3.918 | 33.796 | 7.043 | 10.142 |
| string: silesia/nci | 1075110 | 10847.6 ± 1.2% | 4591.2 ± 2.4% | 3098.2 ± 0.6% | 849.6 ± 0.6% | 1889.3 ± 3.9% | 1271.7 ± 0.8% | 2.363 | 3.501 | 12.767 | 5.742 | 8.530 |
| string: silesia/reymont | 1075159 | 5264.8 ± 1.7% | 1835.7 ± 1.1% | 1878.5 ± 1.0% | 392.6 ± 0.9% | 1431.7 ± 1.4% | 1035.3 ± 1.3% | 2.868 | 2.803 | 13.411 | 3.677 | 5.085 |
| string: silesia/samba | 97582 | 6295.0 ± 0.5% | 2686.5 ± 0.5% | 4078.5 ± 0.2% | 380.8 ± 0.3% | 1333.6 ± 0.2% | 1188.4 ± 1.6% | 2.343 | 1.543 | 16.530 | 4.720 | 5.297 |
| string: silesia/webster | 1098490 | 6620.5 ± 0.8% | 1960.9 ± 0.9% | 1750.0 ± 1.2% | 386.1 ± 1.8% | 1396.6 ± 1.5% | 596.8 ± 0.8% | 3.376 | 3.783 | 17.145 | 4.741 | 11.093 |
| string: silesia/xml | 1090118 | 9777.3 ± 1.4% | 3156.3 ± 0.5% | 2528.2 ± 1.0% | 628.9 ± 0.9% | 1930.9 ± 0.9% | 958.9 ± 0.3% | 3.098 | 3.867 | 15.547 | 5.064 | 10.197 |
| string: canterbury/alice29.txt | 159425 | 10419.7 ± 0.4% | 2898.6 ± 1.7% | 3101.6 ± 2.2% | 344.1 ± 2.9% | 1547.8 ± 1.6% | 1092.6 ± 1.0% | 3.595 | 3.359 | 30.283 | 6.732 | 9.537 |
| string: canterbury/asyoulik.txt | 132198 | 10590.2 ± 2.2% | 2117.5 ± 0.9% | 3139.2 ± 0.4% | 351.2 ± 0.4% | 1375.5 ± 1.2% | 968.1 ± 0.7% | 5.001 | 3.373 | 30.152 | 7.699 | 10.939 |
| string: canterbury/lcet10.txt | 441884 | 10655.3 ± 1.0% | 3074.0 ± 0.6% | 2590.9 ± 0.4% | 387.3 ± 1.2% | 1678.3 ± 1.8% | 1195.3 ± 1.9% | 3.466 | 4.113 | 27.512 | 6.349 | 8.914 |
| string: canterbury/plrabn12.txt | 503330 | 7901.8 ± 1.0% | 2311.3 ± 0.5% | 2093.2 ± 5.1% | 364.1 ± 1.4% | 1608.0 ± 2.1% | 1114.8 ± 1.8% | 3.419 | 3.775 | 21.704 | 4.914 | 7.088 |
| string: canterbury-large/E.coli | 1048578 | 31000.0 ± 0.4% | 14964.8 ± 1.4% | 3455.5 ± 3.9% | 1687.9 ± 1.2% | 3123.4 ± 1.2% | 1399.5 ± 0.8% | 2.072 | 8.971 | 18.366 | 9.925 | 22.151 |
| string: canterbury-large/bible.txt | 1055886 | 8896.2 ± 0.5% | 4717.6 ± 2.4% | 3006.3 ± 1.5% | 422.4 ± 0.3% | 2229.3 ± 0.3% | 1488.1 ± 0.5% | 1.886 | 2.959 | 21.064 | 3.991 | 5.978 |
| string: canterbury-large/world192.txt | 1103121 | 6354.0 ± 1.8% | 1712.0 ± 0.7% | 1890.9 ± 2.1% | 387.2 ± 3.6% | 1385.3 ± 2.1% | 962.0 ± 1.3% | 3.711 | 3.360 | 16.408 | 4.587 | 6.605 |
| string: http/html-1m | 1058582 | 9873.0 ± 1.4% | 4314.8 ± 2.4% | 2874.8 ± 0.5% | 461.1 ± 1.4% | 2152.8 ± 1.3% | 845.4 ± 4.0% | 2.288 | 3.434 | 21.413 | 4.586 | 11.678 |
| string: http/json-1m | 1190272 | 8023.6 ± 0.8% | 1569.5 ± 0.8% | 1557.9 ± 0.8% | 535.8 ± 0.7% | 1151.8 ± 0.7% | 846.4 ± 3.3% | 5.112 | 5.150 | 14.975 | 6.966 | 9.480 |
| string: http/js-1m | 1144362 | 6378.2 ± 2.3% | 1114.2 ± 1.1% | 1392.3 ± 0.9% | 362.7 ± 2.2% | 1124.1 ± 1.0% | 755.6 ± 0.5% | 5.725 | 4.581 | 17.584 | 5.674 | 8.442 |
| string: http/css-1m | 1097820 | 7988.8 ± 1.1% | 1470.2 ± 1.1% | 2281.9 ± 0.9% | 543.7 ± 1.1% | 1260.1 ± 1.3% | 878.7 ± 1.5% | 5.434 | 3.501 | 14.694 | 6.340 | 9.091 |
| string: dickens as Cyrillic and CJK | 1883069 | 5422.1 ± 1.0% | 3664.7 ± 1.7% | 483.3 ± 0.9% | 251.0 ± 1.1% | 463.9 ± 1.1% | 355.7 ± 0.4% | 1.480 | 11.219 | 21.604 | 11.688 | 15.244 |
| hex: silesia/dickens | 524290 | 42858.8 ± 1.5% | 2580.1 ± 0.6% | 1495.6 ± 0.7% | 467.8 ± 2.9% | 1547.8 ± 0.7% | 1052.5 ± 0.9% | 16.612 | 28.657 | 91.614 | 27.690 | 40.722 |
| hex: silesia/mozilla | 524290 | 42767.1 ± 1.2% | 2579.7 ± 0.7% | 1500.7 ± 0.5% | 416.8 ± 0.8% | 1553.1 ± 0.7% | 1062.2 ± 1.0% | 16.578 | 28.498 | 102.603 | 27.536 | 40.264 |
| hex: silesia/mr | 524290 | 42690.5 ± 0.1% | 2570.3 ± 0.1% | 1507.6 ± 0.1% | 611.0 ± 0.4% | 1570.5 ± 5.7% | 1064.9 ± 1.5% | 16.609 | 28.317 | 69.874 | 27.183 | 40.088 |
| hex: silesia/nci | 524290 | 42353.7 ± 0.7% | 2561.5 ± 0.8% | 1502.3 ± 0.9% | 750.2 ± 0.1% | 1546.6 ± 0.8% | 1063.1 ± 3.9% | 16.535 | 28.193 | 56.460 | 27.385 | 39.842 |
| hex: silesia/ooffice | 524290 | 42490.0 ± 0.4% | 2591.7 ± 0.5% | 1511.1 ± 0.2% | 346.5 ± 1.1% | 1570.6 ± 4.7% | 1067.1 ± 1.4% | 16.394 | 28.118 | 122.613 | 27.053 | 39.819 |
| hex: silesia/osdb | 524290 | 42699.0 ± 1.9% | 2576.8 ± 0.3% | 1506.5 ± 0.6% | 454.6 ± 0.4% | 1555.0 ± 0.9% | 1064.0 ± 5.3% | 16.571 | 28.343 | 93.933 | 27.460 | 40.130 |
| hex: silesia/reymont | 524290 | 42540.4 ± 0.7% | 2597.2 ± 0.2% | 1507.9 ± 0.1% | 499.0 ± 0.4% | 1575.0 ± 0.1% | 1068.9 ± 0.2% | 16.379 | 28.212 | 85.250 | 27.010 | 39.799 |
| hex: silesia/samba | 524290 | 42472.6 ± 1.7% | 2588.9 ± 0.8% | 1506.5 ± 0.5% | 367.5 ± 1.0% | 1576.4 ± 0.9% | 1065.8 ± 0.9% | 16.405 | 28.193 | 115.586 | 26.943 | 39.851 |
| hex: silesia/sao | 524290 | 41381.6 ± 1.8% | 2589.4 ± 1.1% | 1507.3 ± 0.8% | 281.6 ± 1.1% | 1576.4 ± 1.3% | 1068.2 ± 1.2% | 15.981 | 27.455 | 146.962 | 26.251 | 38.741 |
| hex: silesia/webster | 524290 | 42538.8 ± 0.3% | 2597.9 ± 0.1% | 1512.6 ± 0.2% | 454.9 ± 1.0% | 1583.4 ± 0.4% | 1066.7 ± 0.4% | 16.374 | 28.123 | 93.513 | 26.866 | 39.880 |
| hex: silesia/x-ray | 524290 | 43002.5 ± 1.3% | 2583.9 ± 0.3% | 1496.8 ± 4.1% | 429.8 ± 0.9% | 1573.9 ± 0.8% | 1061.6 ± 1.1% | 16.643 | 28.729 | 100.061 | 27.322 | 40.507 |
| hex: silesia/xml | 524290 | 42461.8 ± 5.5% | 2582.0 ± 0.7% | 1507.3 ± 5.3% | 737.6 ± 2.1% | 1568.0 ± 2.4% | 1062.2 ± 1.2% | 16.445 | 28.170 | 57.570 | 27.080 | 39.975 |
| hex: canterbury/alice29.txt | 304180 | 42902.1 ± 0.7% | 2590.2 ± 1.3% | 1514.1 ± 1.1% | 477.5 ± 0.9% | 1584.0 ± 0.9% | 1082.3 ± 0.8% | 16.563 | 28.335 | 89.851 | 27.084 | 39.640 |
| hex: canterbury/asyoulik.txt | 250360 | 42885.1 ± 1.8% | 2602.2 ± 0.7% | 1528.2 ± 1.0% | 464.9 ± 1.3% | 1585.5 ± 1.5% | 1079.1 ± 1.1% | 16.480 | 28.062 | 92.244 | 27.048 | 39.741 |
| hex: canterbury/cp.html | 49208 | 42049.7 ± 0.7% | 2575.3 ± 0.5% | 1514.9 ± 0.6% | 510.9 ± 0.9% | 1581.5 ± 0.6% | 1085.3 ± 0.6% | 16.328 | 27.757 | 82.305 | 26.589 | 38.743 |
| hex: canterbury/fields.c | 22302 | 41571.1 ± 0.9% | 2631.0 ± 0.4% | 1524.1 ± 0.5% | 627.2 ± 0.7% | 1596.4 ± 0.9% | 1095.3 ± 0.4% | 15.801 | 27.276 | 66.277 | 26.040 | 37.954 |
| hex: canterbury/grammar.lsp | 7444 | 39895.5 ± 2.1% | 2689.8 ± 0.7% | 1531.8 ± 5.4% | 797.6 ± 1.0% | 1602.2 ± 1.1% | 1100.2 ± 0.6% | 14.832 | 26.046 | 50.018 | 24.901 | 36.262 |
| hex: canterbury/kennedy.xls | 524290 | 41217.8 ± 1.6% | 2561.4 ± 0.4% | 1491.8 ± 4.9% | 742.2 ± 0.7% | 1554.9 ± 0.9% | 1054.4 ± 0.6% | 16.092 | 27.629 | 55.534 | 26.509 | 39.091 |
| hex: canterbury/lcet10.txt | 524290 | 42846.3 ± 1.5% | 2573.9 ± 0.7% | 1493.4 ± 1.0% | 473.8 ± 1.0% | 1557.4 ± 0.8% | 1057.3 ± 1.3% | 16.647 | 28.689 | 90.437 | 27.512 | 40.524 |
| hex: canterbury/plrabn12.txt | 524290 | 42903.1 ± 8.5% | 2583.9 ± 0.6% | 1499.9 ± 0.8% | 454.9 ± 0.9% | 1507.4 ± 0.7% | 1055.6 ± 0.8% | 16.604 | 28.603 | 94.304 | 28.463 | 40.642 |
| hex: canterbury/ptt5 | 524290 | 42839.4 ± 1.0% | 2543.8 ± 0.9% | 1492.0 ± 1.8% | 609.8 ± 2.2% | 1557.6 ± 3.2% | 1055.3 ± 1.3% | 16.841 | 28.712 | 70.248 | 27.504 | 40.594 |
| hex: canterbury/sum | 76482 | 42385.4 ± 6.3% | 2566.9 ± 1.1% | 1506.1 ± 0.5% | 588.2 ± 0.7% | 1570.7 ± 0.4% | 1077.9 ± 4.3% | 16.513 | 28.143 | 72.058 | 26.985 | 39.322 |
| hex: canterbury/xargs.1 | 8456 | 40444.7 ± 3.7% | 2665.8 ± 7.8% | 1528.6 ± 1.1% | 825.3 ± 0.7% | 1599.2 ± 1.0% | 1103.6 ± 0.8% | 15.172 | 26.459 | 49.007 | 25.291 | 36.647 |
| hex: canterbury-large/E.coli | 524290 | 42667.0 ± 0.7% | 2566.0 ± 1.2% | 1491.8 ± 1.3% | 810.2 ± 1.1% | 1553.3 ± 5.7% | 1053.8 ± 2.5% | 16.628 | 28.601 | 52.663 | 27.468 | 40.488 |
| hex: canterbury-large/bible.txt | 524290 | 43084.4 ± 1.7% | 2581.6 ± 0.8% | 1496.0 ± 1.3% | 485.1 ± 3.5% | 1538.0 ± 0.6% | 1058.9 ± 5.8% | 16.689 | 28.799 | 88.823 | 28.012 | 40.686 |
| hex: canterbury-large/world192.txt | 524290 | 42917.9 ± 1.9% | 2558.0 ± 8.9% | 1495.2 ± 0.9% | 463.3 ± 0.7% | 1536.5 ± 0.6% | 1057.2 ± 0.4% | 16.778 | 28.703 | 92.643 | 27.933 | 40.594 |
| hex: http/html-1kx1024 | 2099200 | 20695.0 ± 1.7% | 2426.7 ± 1.5% | 1456.2 ± 3.8% | 513.2 ± 0.4% | 1501.8 ± 0.6% | 1073.5 ± 1.3% | 8.528 | 14.212 | 40.328 | 13.780 | 19.279 |
| hex: http/html-16kx64 | 2097280 | 21647.4 ± 0.4% | 2355.9 ± 7.0% | 1441.0 ± 0.9% | 516.5 ± 1.1% | 1492.4 ± 1.1% | 1076.8 ± 1.4% | 9.189 | 15.023 | 41.914 | 14.505 | 20.104 |
| hex: http/html-1m | 524290 | 39728.8 ± 0.7% | 2575.7 ± 1.2% | 1507.2 ± 0.6% | 504.9 ± 1.0% | 1564.2 ± 5.7% | 1062.9 ± 0.4% | 15.425 | 26.359 | 78.688 | 25.399 | 37.379 |
| hex: http/json-1kx1024 | 2099200 | 20735.5 ± 0.2% | 2430.5 ± 0.3% | 1454.9 ± 1.0% | 687.8 ± 1.2% | 1499.7 ± 1.6% | 1073.7 ± 1.4% | 8.532 | 14.252 | 30.146 | 13.826 | 19.312 |
| hex: http/json-16kx64 | 2097280 | 22506.6 ± 0.2% | 2350.4 ± 1.4% | 1434.4 ± 1.2% | 661.9 ± 0.9% | 1343.2 ± 1.1% | 1078.0 ± 1.0% | 9.576 | 15.691 | 34.001 | 16.756 | 20.879 |
| hex: http/json-1m | 524290 | 42693.3 ± 0.6% | 2559.7 ± 0.6% | 1504.6 ± 0.7% | 705.7 ± 1.3% | 1488.5 ± 0.7% | 1062.7 ± 1.2% | 16.679 | 28.374 | 60.496 | 28.682 | 40.173 |
| hex: http/js-1kx1024 | 2099200 | 20088.0 ± 0.3% | 2422.3 ± 1.4% | 1461.1 ± 1.5% | 497.9 ± 1.0% | 1504.9 ± 0.9% | 1070.1 ± 1.3% | 8.293 | 13.749 | 40.344 | 13.349 | 18.772 |
| hex: http/js-16kx64 | 2097280 | 21151.4 ± 0.3% | 2354.3 ± 7.6% | 1437.6 ± 0.7% | 497.8 ± 0.6% | 1489.3 ± 0.4% | 1075.7 ± 0.9% | 8.984 | 14.713 | 42.487 | 14.203 | 19.663 |
| hex: http/js-1m | 524290 | 42075.4 ± 2.0% | 2576.9 ± 1.0% | 1497.9 ± 0.8% | 514.4 ± 0.8% | 1565.4 ± 0.7% | 1057.5 ± 0.4% | 16.328 | 28.090 | 81.800 | 26.878 | 39.788 |
| hex: http/css-1kx1024 | 2099200 | 20731.8 ± 0.4% | 2423.3 ± 0.7% | 1452.4 ± 4.6% | 570.7 ± 1.2% | 1500.3 ± 0.6% | 1067.6 ± 0.5% | 8.555 | 14.274 | 36.327 | 13.819 | 19.419 |
| hex: http/css-16kx64 | 2097280 | 21646.1 ± 0.5% | 2358.0 ± 0.5% | 1438.5 ± 0.9% | 578.9 ± 1.5% | 1491.0 ± 0.9% | 1078.6 ± 0.8% | 9.180 | 15.048 | 37.394 | 14.518 | 20.069 |
| hex: http/css-1m | 524290 | 42832.6 ± 0.4% | 2562.8 ± 0.6% | 1496.1 ± 1.1% | 552.4 ± 1.2% | 1513.9 ± 1.3% | 1057.7 ± 0.6% | 16.713 | 28.630 | 77.537 | 28.294 | 40.497 |
| hex: shuffled/dickens-1m | 524290 | 43223.4 ± 2.4% | 2591.5 ± 1.5% | 1501.7 ± 0.7% | 465.2 ± 0.9% | 1529.9 ± 1.0% | 1057.2 ± 1.1% | 16.679 | 28.782 | 92.919 | 28.253 | 40.883 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: stdx runs at 0.921 of simdjson.
- qlog records, JSON text sequence, decoding: stdx runs at 0.884 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.761 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.823 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.899 of yyjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.868 of simdjson.
