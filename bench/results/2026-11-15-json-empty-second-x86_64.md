# bench-json

| Field | Value |
|---|---|
| Commit | d885b0e |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.370.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43678686331 |
| Date | 2026-11-15 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1025.8 ± 0.7% | 0.470 | 1.000 | 1.034 | 1.002 | 0.414 | 1.031 | 1.053 | 0.364 | 0.819 | 0.939 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 840.7 ± 0.7% | 0.735 | 1.023 | 1.024 | 1.012 | 0.394 | 1.029 | 1.011 | 0.346 | 0.912 | 0.975 | 0.111 |
| messages: 11 string members | 1025025 | 909.2 ± 0.8% | 0.579 | 0.978 | 1.007 | 0.998 | 0.504 | 1.011 | 0.998 | 0.482 | 0.867 | 1.006 | 0.109 |
| messages: 50 nested objects | 1121600 | 1020.3 ± 4.9% | 0.714 | 1.057 | 1.060 | 1.030 | 0.392 | 1.086 | 1.059 | 0.332 | 0.906 | 1.041 | 0.100 |
| messages: a tree of 341 objects | 612600 | 406.6 ± 13.2% | 0.880 | 1.088 | 1.030 | 1.034 | 0.322 | 1.024 | 1.034 | 0.259 | 0.780 | 1.001 | 0.139 |
| string: silesia/dickens | 172528 | 6235.8 ± 0.9% | 0.022 | 0.571 | 0.897 | 0.915 | 0.156 | 0.883 | 0.915 | 0.156 | 0.991 | 0.990 | 0.022 |
| string: silesia/nci | 1075110 | 5105.6 ± 1.3% | 0.027 | 0.701 | 1.038 | 1.036 | 0.234 | 1.007 | 1.033 | 0.235 | 1.003 | 1.003 | 0.027 |
| string: silesia/reymont | 1075159 | 3291.3 ± 0.5% | 0.042 | 0.569 | 0.824 | 0.826 | 0.289 | 0.818 | 0.826 | 0.288 | 1.001 | 1.001 | 0.042 |
| string: silesia/samba | 97582 | 3348.7 ± 0.2% | 0.036 | 0.889 | 1.020 | 1.022 | 0.066 | 0.828 | 1.021 | 0.066 | 1.000 | 0.999 | 0.036 |
| string: silesia/webster | 1098490 | 4098.1 ± 0.6% | 0.033 | 0.596 | 0.921 | 0.946 | 0.176 | 0.912 | 0.939 | 0.175 | 1.002 | 1.003 | 0.033 |
| string: silesia/xml | 1090118 | 5472.4 ± 1.7% | 0.025 | 0.792 | 0.939 | 0.933 | 0.204 | 0.927 | 0.938 | 0.204 | 1.002 | 1.004 | 0.025 |
| string: canterbury/alice29.txt | 159425 | 4878.7 ± 0.5% | 0.028 | 0.679 | 0.938 | 1.005 | 0.150 | 0.957 | 0.999 | 0.150 | 1.006 | 1.005 | 0.028 |
| string: canterbury/asyoulik.txt | 132198 | 3701.4 ± 2.8% | 0.036 | 0.793 | 1.079 | 1.161 | 0.168 | 0.981 | 1.159 | 0.167 | 0.980 | 0.969 | 0.036 |
| string: canterbury/lcet10.txt | 441884 | 6101.3 ± 0.6% | 0.023 | 0.538 | 0.970 | 0.994 | 0.153 | 0.955 | 0.996 | 0.155 | 1.003 | 1.003 | 0.023 |
| string: canterbury/plrabn12.txt | 503330 | 4733.0 ± 0.4% | 0.029 | 0.736 | 0.975 | 1.009 | 0.175 | 0.947 | 1.009 | 0.173 | 0.999 | 1.000 | 0.029 |
| string: canterbury-large/E.coli | 1048578 | 28522.1 ± 4.0% | 0.053 | 1.018 | 0.777 | 1.019 | 0.551 | 1.021 | 1.019 | 0.548 | 1.176 | 1.175 | 0.005 |
| string: canterbury-large/bible.txt | 1055886 | 9572.3 ± 0.6% | 0.015 | 0.475 | 0.630 | 0.623 | 0.276 | 0.682 | 0.623 | 0.277 | 1.006 | 1.008 | 0.015 |
| string: canterbury-large/world192.txt | 1103121 | 3764.6 ± 1.0% | 0.036 | 0.635 | 0.944 | 0.963 | 0.172 | 0.925 | 0.963 | 0.171 | 1.005 | 1.005 | 0.036 |
| string: http/html-1m | 1058582 | 7822.8 ± 2.5% | 0.018 | 0.548 | 0.754 | 0.756 | 0.290 | 0.778 | 0.756 | 0.292 | 1.021 | 1.014 | 0.018 |
| string: http/json-1m | 1190272 | 3311.5 ± 9.1% | 0.038 | 0.383 | 0.437 | 0.437 | 0.094 | 0.393 | 0.436 | 0.094 | 1.003 | 1.002 | 0.038 |
| string: http/js-1m | 1144362 | 2667.7 ± 0.7% | 0.048 | 0.653 | 0.866 | 0.903 | 0.148 | 0.858 | 0.894 | 0.148 | 1.001 | 1.000 | 0.048 |
| string: http/css-1m | 1097820 | 3023.6 ± 3.1% | 0.044 | 0.721 | 0.998 | 1.083 | 0.218 | 1.041 | 1.089 | 0.218 | 1.002 | 1.003 | 0.044 |
| string: dickens as Cyrillic and CJK | 1883069 | 5341.2 ± 1.5% | 0.020 | 0.055 | 0.484 | 0.484 | 0.175 | 0.482 | 0.483 | 0.175 | 1.002 | 1.003 | 0.020 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1061.7 ± 1.1% | 0.091 | 0.976 | 0.976 | 0.976 | 0.088 | 0.701 | 0.975 | 0.088 | 1.001 | 1.003 | 0.090 |
| hex: silesia/dickens | 524290 | 29234.3 ± 2.7% | 0.052 | 1.007 | 0.750 | 1.011 | 0.555 | 1.006 | 1.006 | 0.553 | 1.134 | 1.135 | 0.005 |
| hex: silesia/mozilla | 524290 | 28617.1 ± 2.2% | 0.053 | 1.028 | 0.774 | 1.024 | 0.562 | 1.037 | 1.039 | 0.558 | 1.161 | 1.162 | 0.005 |
| hex: silesia/mr | 524290 | 28858.6 ± 4.0% | 0.052 | 1.015 | 0.770 | 1.014 | 0.554 | 1.016 | 1.012 | 0.556 | 1.155 | 1.154 | 0.005 |
| hex: silesia/nci | 524290 | 29352.3 ± 3.5% | 0.051 | 1.015 | 0.756 | 1.007 | 0.553 | 1.011 | 0.996 | 0.552 | 1.146 | 1.139 | 0.005 |
| hex: silesia/ooffice | 524290 | 29366.0 ± 1.5% | 0.051 | 1.006 | 0.742 | 1.022 | 0.553 | 1.015 | 1.025 | 0.550 | 1.138 | 1.133 | 0.005 |
| hex: silesia/osdb | 524290 | 29149.8 ± 3.4% | 0.052 | 1.010 | 0.753 | 1.003 | 0.554 | 1.012 | 1.013 | 0.553 | 1.140 | 1.143 | 0.005 |
| hex: silesia/reymont | 524290 | 29431.3 ± 5.4% | 0.051 | 1.000 | 0.751 | 1.006 | 0.552 | 0.994 | 1.010 | 0.550 | 1.131 | 1.133 | 0.005 |
| hex: silesia/samba | 524290 | 28833.4 ± 2.4% | 0.052 | 1.010 | 0.762 | 1.012 | 0.556 | 1.012 | 1.019 | 0.555 | 1.158 | 1.163 | 0.005 |
| hex: silesia/sao | 524290 | 29446.9 ± 2.1% | 0.051 | 1.019 | 0.756 | 1.006 | 0.553 | 1.009 | 1.003 | 0.552 | 1.141 | 1.117 | 0.005 |
| hex: silesia/webster | 524290 | 28876.5 ± 2.7% | 0.052 | 1.001 | 0.755 | 1.005 | 0.556 | 1.004 | 1.003 | 0.551 | 1.166 | 1.160 | 0.005 |
| hex: silesia/x-ray | 524290 | 28163.9 ± 6.1% | 0.054 | 1.026 | 0.784 | 1.015 | 0.570 | 1.025 | 1.032 | 0.570 | 1.193 | 1.191 | 0.005 |
| hex: silesia/xml | 524290 | 29065.8 ± 2.3% | 0.052 | 0.998 | 0.761 | 0.999 | 0.547 | 0.999 | 0.990 | 0.545 | 1.138 | 1.144 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 35368.8 ± 3.1% | 0.043 | 1.029 | 0.629 | 1.028 | 0.493 | 1.030 | 1.032 | 0.492 | 0.949 | 0.954 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 36673.4 ± 1.1% | 0.042 | 1.026 | 0.593 | 1.021 | 0.494 | 1.013 | 1.019 | 0.495 | 0.921 | 0.920 | 0.004 |
| hex: canterbury/cp.html | 49208 | 40776.5 ± 0.3% | 0.038 | 1.002 | 0.541 | 1.002 | 0.447 | 1.000 | 1.001 | 0.452 | 0.803 | 0.802 | 0.004 |
| hex: canterbury/fields.c | 22302 | 38356.3 ± 1.0% | 0.040 | 0.997 | 0.555 | 1.008 | 0.453 | 1.008 | 1.004 | 0.462 | 0.825 | 0.820 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 34279.3 ± 1.9% | 0.045 | 0.997 | 0.547 | 1.009 | 0.460 | 0.986 | 1.013 | 0.489 | 0.802 | 0.798 | 0.004 |
| hex: canterbury/kennedy.xls | 524290 | 29600.6 ± 4.8% | 0.051 | 0.992 | 0.745 | 1.002 | 0.548 | 1.003 | 1.012 | 0.548 | 1.121 | 1.123 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 28727.6 ± 4.5% | 0.052 | 1.010 | 0.768 | 0.997 | 0.557 | 1.011 | 1.009 | 0.555 | 1.152 | 1.162 | 0.005 |
| hex: canterbury/plrabn12.txt | 524290 | 29275.1 ± 2.3% | 0.052 | 1.020 | 0.761 | 1.024 | 0.559 | 1.017 | 1.023 | 0.556 | 1.144 | 1.146 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 28896.4 ± 0.9% | 0.052 | 1.006 | 0.755 | 1.016 | 0.551 | 1.003 | 1.007 | 0.549 | 1.153 | 1.149 | 0.005 |
| hex: canterbury/sum | 76482 | 39480.4 ± 12.2% | 0.039 | 1.000 | 0.557 | 1.004 | 0.463 | 1.002 | 1.002 | 0.465 | 0.842 | 0.842 | 0.004 |
| hex: canterbury/xargs.1 | 8456 | 38241.1 ± 1.2% | 0.040 | 0.980 | 0.515 | 1.011 | 0.403 | 0.978 | 1.009 | 0.422 | 0.734 | 0.730 | 0.004 |
| hex: canterbury-large/E.coli | 524290 | 29571.3 ± 0.5% | 0.051 | 1.006 | 0.754 | 0.998 | 0.551 | 1.016 | 1.005 | 0.554 | 1.135 | 1.135 | 0.005 |
| hex: canterbury-large/bible.txt | 524290 | 29372.4 ± 3.8% | 0.051 | 1.036 | 0.753 | 1.028 | 0.554 | 1.029 | 1.034 | 0.553 | 1.135 | 1.138 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 28462.0 ± 6.3% | 0.053 | 1.004 | 0.775 | 1.021 | 0.560 | 1.004 | 1.023 | 0.563 | 1.184 | 1.180 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 16919.0 ± 1.9% | 0.088 | 0.978 | 0.780 | 0.997 | 0.596 | 1.003 | 1.000 | 0.688 | 0.980 | 0.989 | 0.009 |
| hex: http/html-16kx64 | 2097280 | 34700.4 ± 10.3% | 0.044 | 0.994 | 0.599 | 1.012 | 0.498 | 0.997 | 1.015 | 0.502 | 0.881 | 0.886 | 0.004 |
| hex: http/html-1m | 524290 | 29318.7 ± 5.8% | 0.052 | 1.013 | 0.757 | 1.014 | 0.555 | 1.017 | 1.028 | 0.552 | 1.139 | 1.143 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 16830.5 ± 0.7% | 0.088 | 0.988 | 0.784 | 1.010 | 0.580 | 1.008 | 1.004 | 0.669 | 0.983 | 0.994 | 0.008 |
| hex: http/json-16kx64 | 2097280 | 33965.3 ± 1.9% | 0.045 | 1.017 | 0.615 | 1.023 | 0.510 | 1.029 | 1.025 | 0.516 | 0.905 | 0.904 | 0.004 |
| hex: http/json-1m | 524290 | 31333.8 ± 2.0% | 0.048 | 1.008 | 0.705 | 1.010 | 0.528 | 1.012 | 1.010 | 0.525 | 1.059 | 1.057 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 17114.6 ± 0.6% | 0.087 | 0.986 | 0.772 | 1.000 | 0.573 | 1.009 | 1.005 | 0.659 | 0.962 | 0.978 | 0.008 |
| hex: http/js-16kx64 | 2097280 | 34927.8 ± 1.0% | 0.044 | 1.006 | 0.595 | 1.022 | 0.498 | 1.012 | 1.024 | 0.503 | 0.872 | 0.877 | 0.004 |
| hex: http/js-1m | 524290 | 28632.6 ± 5.0% | 0.053 | 1.018 | 0.764 | 1.018 | 0.559 | 1.023 | 1.016 | 0.555 | 1.156 | 1.163 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 17006.1 ± 1.0% | 0.088 | 0.989 | 0.781 | 1.000 | 0.594 | 1.006 | 1.005 | 0.684 | 0.978 | 0.981 | 0.008 |
| hex: http/css-16kx64 | 2097280 | 35097.0 ± 1.1% | 0.044 | 1.000 | 0.595 | 1.008 | 0.495 | 1.007 | 1.015 | 0.502 | 0.872 | 0.875 | 0.004 |
| hex: http/css-1m | 524290 | 25291.1 ± 0.6% | 0.060 | 1.014 | 0.813 | 1.013 | 0.618 | 1.012 | 1.016 | 0.617 | 1.318 | 1.311 | 0.006 |
| hex: shuffled/dickens-1m | 524290 | 29229.2 ± 3.0% | 0.052 | 1.007 | 0.759 | 1.000 | 0.550 | 1.002 | 0.999 | 0.546 | 1.147 | 1.146 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1347.3 ± 1.2% | 0.439 | 0.973 | 0.973 | 0.995 | 0.983 | 0.234 | 0.987 | 0.441 | 0.843 | 0.085 | 0.998 |
| qlog records, JSON text sequence | 1467503 | 1166.8 ± 2.3% | 0.698 | 0.946 | 0.972 | 0.974 | 0.969 | 0.226 | 0.968 | 0.413 | 0.830 | 0.103 | 1.000 |
| messages: 11 string members | 1025025 | 1071.7 ± 3.3% | 0.571 | 1.026 | 1.019 | 1.013 | 1.013 | 0.328 | 1.015 | 0.602 | 1.060 | 0.105 | 1.034 |
| messages: 50 nested objects | 1121600 | 1366.9 ± 1.7% | 0.621 | 0.974 | 0.959 | 0.958 | 0.966 | 0.225 | 0.952 | 0.410 | 0.818 | 0.092 | 0.994 |
| messages: a tree of 341 objects | 612600 | 457.0 ± 2.1% | 0.935 | 1.008 | 1.049 | 1.061 | 1.055 | 0.200 | 1.052 | 0.376 | 1.014 | 0.164 | 1.086 |
| string: silesia/dickens | 172528 | 8541.2 ± 0.8% | 0.018 | 0.626 | 0.439 | 0.640 | 0.627 | 0.127 | 0.627 | 1.001 | 1.004 | 0.018 | 1.052 |
| string: silesia/nci | 1075110 | 8082.5 ± 1.6% | 0.019 | 0.639 | 0.430 | 0.638 | 0.638 | 0.178 | 0.640 | 1.003 | 1.003 | 0.019 | 1.025 |
| string: silesia/reymont | 1075159 | 3818.0 ± 0.3% | 0.041 | 0.678 | 0.502 | 0.672 | 0.680 | 0.280 | 0.680 | 1.000 | 1.002 | 0.041 | 1.003 |
| string: silesia/samba | 97582 | 4537.7 ± 2.8% | 0.043 | 0.953 | 0.795 | 0.954 | 0.953 | 0.114 | 0.955 | 1.001 | 1.004 | 0.044 | 1.116 |
| string: silesia/webster | 1098490 | 5067.0 ± 2.3% | 0.030 | 0.703 | 0.493 | 0.708 | 0.703 | 0.156 | 0.703 | 0.998 | 0.991 | 0.030 | 0.992 |
| string: silesia/xml | 1090118 | 7678.3 ± 4.6% | 0.021 | 0.649 | 0.568 | 0.659 | 0.649 | 0.205 | 0.649 | 1.005 | 1.006 | 0.021 | 1.057 |
| string: canterbury/alice29.txt | 159425 | 9251.6 ± 0.4% | 0.017 | 0.546 | 0.398 | 0.543 | 0.546 | 0.088 | 0.553 | 1.001 | 1.005 | 0.017 | 1.029 |
| string: canterbury/asyoulik.txt | 132198 | 7348.7 ± 0.7% | 0.021 | 0.552 | 0.410 | 0.553 | 0.558 | 0.094 | 0.559 | 1.002 | 1.004 | 0.021 | 1.039 |
| string: canterbury/lcet10.txt | 441884 | 8367.6 ± 6.0% | 0.019 | 0.642 | 0.409 | 0.653 | 0.643 | 0.125 | 0.643 | 1.006 | 1.013 | 0.019 | 1.035 |
| string: canterbury/plrabn12.txt | 503330 | 5869.7 ± 0.4% | 0.026 | 0.794 | 0.591 | 0.782 | 0.792 | 0.162 | 0.792 | 1.002 | 1.005 | 0.026 | 1.042 |
| string: canterbury-large/E.coli | 1048578 | 28271.0 ± 5.4% | 0.053 | 1.020 | 1.017 | 0.786 | 1.035 | 0.552 | 1.029 | 1.011 | 1.034 | 0.006 | 1.026 |
| string: canterbury-large/bible.txt | 1055886 | 6979.9 ± 0.3% | 0.023 | 0.802 | 0.658 | 0.829 | 0.802 | 0.415 | 0.801 | 1.002 | 1.003 | 0.023 | 1.044 |
| string: canterbury-large/world192.txt | 1103121 | 4831.8 ± 6.6% | 0.032 | 0.683 | 0.516 | 0.680 | 0.710 | 0.146 | 0.683 | 1.039 | 0.992 | 0.032 | 0.981 |
| string: http/html-1m | 1058582 | 8445.4 ± 0.5% | 0.019 | 0.627 | 0.521 | 0.647 | 0.628 | 0.293 | 0.625 | 0.998 | 1.006 | 0.019 | 1.016 |
| string: http/json-1m | 1190272 | 6334.9 ± 9.5% | 0.023 | 0.225 | 0.196 | 0.229 | 0.226 | 0.065 | 0.226 | 1.001 | 1.000 | 0.023 | 1.021 |
| string: http/js-1m | 1144362 | 4963.3 ± 2.3% | 0.030 | 0.453 | 0.360 | 0.438 | 0.454 | 0.087 | 0.453 | 1.008 | 1.018 | 0.030 | 1.009 |
| string: http/css-1m | 1097820 | 6545.2 ± 1.8% | 0.023 | 0.529 | 0.358 | 0.532 | 0.530 | 0.119 | 0.532 | 1.000 | 1.004 | 0.023 | 1.045 |
| string: dickens as Cyrillic and CJK | 1883069 | 5327.3 ± 0.3% | 0.024 | 0.467 | 0.056 | 0.471 | 0.468 | 0.176 | 0.468 | 0.999 | 1.001 | 0.024 | 0.977 |
| hex: silesia/dickens | 524290 | 30711.9 ± 1.1% | 1.005 | 0.082 | 1.000 | 0.621 | 1.001 | 1.003 | 0.999 | 1.004 | 1.005 | 0.083 | 1.004 |
| hex: silesia/mozilla | 524290 | 34279.7 ± 1.2% | 1.003 | 0.074 | 1.004 | 0.588 | 1.003 | 1.002 | 1.002 | 1.002 | 1.008 | 0.074 | 1.003 |
| hex: silesia/mr | 524290 | 34678.1 ± 0.5% | 1.008 | 0.073 | 1.005 | 0.577 | 1.004 | 1.005 | 1.007 | 1.004 | 1.007 | 0.073 | 1.007 |
| hex: silesia/nci | 524290 | 35059.1 ± 0.7% | 1.007 | 0.072 | 1.000 | 0.574 | 0.999 | 1.003 | 1.004 | 1.001 | 1.006 | 0.073 | 1.003 |
| hex: silesia/ooffice | 524290 | 33615.2 ± 2.0% | 1.002 | 0.075 | 1.005 | 0.596 | 1.002 | 1.001 | 1.001 | 1.004 | 1.005 | 0.075 | 1.002 |
| hex: silesia/osdb | 524290 | 32260.8 ± 0.8% | 1.008 | 0.079 | 1.006 | 0.619 | 1.002 | 1.005 | 1.002 | 1.006 | 1.010 | 0.079 | 1.002 |
| hex: silesia/reymont | 524290 | 33451.7 ± 1.1% | 1.007 | 0.076 | 1.006 | 0.600 | 1.012 | 1.007 | 1.011 | 1.003 | 1.007 | 0.076 | 1.004 |
| hex: silesia/samba | 524290 | 36020.0 ± 9.1% | 1.004 | 0.070 | 1.005 | 0.559 | 1.002 | 1.000 | 0.995 | 1.004 | 1.009 | 0.071 | 1.005 |
| hex: silesia/sao | 524290 | 33823.5 ± 0.8% | 1.009 | 0.075 | 1.005 | 0.593 | 1.006 | 1.004 | 1.006 | 1.004 | 1.007 | 0.075 | 1.008 |
| hex: silesia/webster | 524290 | 36025.5 ± 4.1% | 1.005 | 0.070 | 0.994 | 0.562 | 0.997 | 0.993 | 0.993 | 0.992 | 0.992 | 0.071 | 0.991 |
| hex: silesia/x-ray | 524290 | 34225.5 ± 10.6% | 1.001 | 0.074 | 0.995 | 0.589 | 1.000 | 0.996 | 0.996 | 0.997 | 1.001 | 0.075 | 1.002 |
| hex: silesia/xml | 524290 | 34718.8 ± 0.4% | 1.002 | 0.073 | 1.001 | 0.579 | 1.004 | 1.001 | 1.002 | 0.997 | 1.003 | 0.073 | 1.004 |
| hex: canterbury/alice29.txt | 304180 | 33529.7 ± 0.7% | 1.001 | 0.076 | 0.998 | 0.578 | 1.001 | 1.001 | 1.000 | 0.996 | 1.002 | 0.076 | 0.998 |
| hex: canterbury/asyoulik.txt | 250360 | 31978.1 ± 0.5% | 0.999 | 0.079 | 0.998 | 0.616 | 1.002 | 0.998 | 0.999 | 1.000 | 1.003 | 0.080 | 1.002 |
| hex: canterbury/cp.html | 49208 | 31752.1 ± 0.2% | 0.999 | 0.080 | 0.999 | 0.609 | 1.000 | 0.992 | 1.001 | 0.998 | 1.005 | 0.080 | 0.999 |
| hex: canterbury/fields.c | 22302 | 32005.3 ± 0.3% | 0.998 | 0.079 | 0.997 | 0.587 | 0.999 | 0.983 | 0.998 | 1.001 | 1.009 | 0.079 | 0.999 |
| hex: canterbury/grammar.lsp | 7444 | 31729.8 ± 0.2% | 0.995 | 0.079 | 0.993 | 0.564 | 0.994 | 0.950 | 0.994 | 1.003 | 1.032 | 0.079 | 1.014 |
| hex: canterbury/kennedy.xls | 524290 | 30899.9 ± 0.7% | 1.001 | 0.082 | 1.002 | 0.627 | 1.003 | 1.002 | 1.003 | 1.000 | 1.005 | 0.082 | 1.002 |
| hex: canterbury/lcet10.txt | 524290 | 35387.2 ± 0.8% | 1.008 | 0.072 | 1.005 | 0.569 | 1.005 | 1.006 | 1.008 | 1.004 | 1.008 | 0.072 | 1.009 |
| hex: canterbury/plrabn12.txt | 524290 | 34597.3 ± 1.1% | 1.005 | 0.073 | 1.006 | 0.579 | 1.005 | 1.005 | 1.006 | 1.001 | 1.009 | 0.074 | 1.007 |
| hex: canterbury/ptt5 | 524290 | 33806.6 ± 2.3% | 1.011 | 0.075 | 1.007 | 0.593 | 1.007 | 1.011 | 1.007 | 1.008 | 1.014 | 0.075 | 1.014 |
| hex: canterbury/sum | 76482 | 35036.5 ± 0.4% | 1.000 | 0.072 | 0.998 | 0.575 | 0.998 | 0.998 | 0.997 | 1.000 | 1.006 | 0.073 | 1.003 |
| hex: canterbury/xargs.1 | 8456 | 34619.6 ± 0.5% | 0.993 | 0.073 | 0.995 | 0.545 | 0.994 | 0.955 | 0.993 | 0.995 | 1.027 | 0.073 | 1.009 |
| hex: canterbury-large/E.coli | 524290 | 30239.6 ± 1.4% | 1.006 | 0.084 | 1.003 | 0.618 | 1.003 | 1.003 | 1.004 | 1.005 | 1.006 | 0.084 | 1.005 |
| hex: canterbury-large/bible.txt | 524290 | 34749.9 ± 1.3% | 1.004 | 0.073 | 1.007 | 0.578 | 1.006 | 1.003 | 1.003 | 1.005 | 1.008 | 0.073 | 1.004 |
| hex: canterbury-large/world192.txt | 524290 | 33165.8 ± 0.5% | 1.008 | 0.076 | 1.002 | 0.605 | 1.001 | 0.998 | 0.997 | 1.007 | 1.009 | 0.077 | 1.006 |
| hex: http/html-1kx1024 | 2099200 | 23607.1 ± 21.5% | 0.999 | 0.104 | 0.964 | 0.684 | 0.974 | 0.867 | 0.975 | 0.978 | 1.036 | 0.100 | 1.010 |
| hex: http/html-16kx64 | 2097280 | 29952.9 ± 1.4% | 1.009 | 0.084 | 0.999 | 0.644 | 0.999 | 0.988 | 1.001 | 0.998 | 1.008 | 0.084 | 1.003 |
| hex: http/html-1m | 524290 | 31238.5 ± 0.9% | 1.005 | 0.081 | 1.003 | 0.634 | 1.006 | 1.002 | 1.004 | 1.002 | 1.007 | 0.082 | 1.004 |
| hex: http/json-1kx1024 | 2099200 | 23405.2 ± 0.9% | 0.998 | 0.105 | 0.967 | 0.687 | 0.971 | 0.878 | 0.970 | 0.992 | 1.061 | 0.101 | 1.008 |
| hex: http/json-16kx64 | 2097280 | 29633.6 ± 1.6% | 1.015 | 0.085 | 1.003 | 0.652 | 1.002 | 0.998 | 1.005 | 1.010 | 1.014 | 0.085 | 1.010 |
| hex: http/json-1m | 524290 | 30943.7 ± 1.2% | 1.005 | 0.082 | 1.003 | 0.643 | 1.001 | 1.003 | 1.002 | 1.002 | 1.005 | 0.082 | 1.002 |
| hex: http/js-1kx1024 | 2099200 | 23723.1 ± 1.3% | 0.996 | 0.103 | 0.967 | 0.678 | 0.969 | 0.882 | 0.967 | 0.973 | 1.029 | 0.100 | 1.009 |
| hex: http/js-16kx64 | 2097280 | 29739.0 ± 2.7% | 1.012 | 0.085 | 1.000 | 0.649 | 1.001 | 0.986 | 1.002 | 0.998 | 1.012 | 0.085 | 1.002 |
| hex: http/js-1m | 524290 | 30844.5 ± 1.0% | 1.007 | 0.082 | 1.009 | 0.646 | 1.009 | 1.007 | 1.008 | 1.004 | 1.008 | 0.083 | 1.008 |
| hex: http/css-1kx1024 | 2099200 | 23153.7 ± 10.8% | 0.983 | 0.105 | 0.989 | 0.694 | 0.982 | 0.894 | 0.981 | 0.993 | 1.045 | 0.103 | 1.030 |
| hex: http/css-16kx64 | 2097280 | 30180.2 ± 1.0% | 1.005 | 0.083 | 0.992 | 0.641 | 0.996 | 0.982 | 0.994 | 0.994 | 1.002 | 0.084 | 0.996 |
| hex: http/css-1m | 524290 | 30580.0 ± 7.2% | 1.005 | 0.083 | 1.004 | 0.649 | 1.006 | 1.005 | 1.008 | 1.001 | 1.005 | 0.083 | 1.006 |
| hex: shuffled/dickens-1m | 524290 | 32616.1 ± 13.9% | 1.012 | 0.078 | 1.008 | 0.619 | 0.999 | 1.007 | 1.006 | 1.000 | 1.017 | 0.078 | 1.009 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.053 of all on.
- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.057 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.060 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.086 of all on.
- messages: 50 nested objects, decoding: J13 decoder escape blocks off runs at 1.059 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.079 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.161 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.159 of all on.
- string: http/css-1m, decoding: J8 decoder fast path off runs at 1.083 of all on.
- string: http/css-1m, decoding: J13 decoder escape blocks off runs at 1.089 of all on.
- messages: a tree of 341 objects, encoding: J7 wide vectors off runs at 1.061 of all on.
- messages: a tree of 341 objects, encoding: J9 encoder fast path off runs at 1.055 of all on.
- messages: a tree of 341 objects, encoding: J14 encoder escape blocks off runs at 1.052 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 96870.8 ± 1.0% | 90864.3 ± 1.8% | 1.066 | — | — |
| string: silesia/nci | 1048576 | 58011.7 ± 2.2% | 58144.6 ± 2.9% | 0.998 | — | — |
| string: silesia/reymont | 1048576 | 60021.0 ± 1.7% | 59588.6 ± 1.0% | 1.007 | — | — |
| string: silesia/samba | 65546 | 98382.9 ± 0.5% | 90458.0 ± 0.4% | 1.088 | — | — |
| string: silesia/webster | 1048576 | 60339.5 ± 4.4% | 60502.9 ± 4.2% | 0.997 | — | — |
| string: silesia/xml | 1048576 | 59914.7 ± 1.0% | 59034.4 ± 2.1% | 1.015 | — | — |
| string: canterbury/alice29.txt | 152089 | 100341.2 ± 0.2% | 91248.4 ± 0.8% | 1.100 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 100067.2 ± 0.2% | 91761.3 ± 0.6% | 1.091 | — | — |
| string: canterbury/lcet10.txt | 426754 | 91924.8 ± 2.3% | 85777.7 ± 0.7% | 1.072 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 81154.5 ± 0.9% | 76153.0 ± 1.7% | 1.066 | — | — |
| string: canterbury-large/E.coli | 1048576 | 61032.2 ± 0.8% | 60127.6 ± 1.9% | 1.015 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 58687.1 ± 2.6% | 58498.0 ± 11.8% | 1.003 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 58864.7 ± 3.8% | 58895.7 ± 2.7% | 0.999 | — | — |
| string: http/html-1m | 1048576 | 58164.6 ± 1.1% | 59406.7 ± 2.6% | 0.979 | — | — |
| string: http/json-1m | 1048576 | 51850.7 ± 0.7% | 55153.6 ± 1.9% | 0.940 | — | — |
| string: http/js-1m | 1048576 | 59890.9 ± 2.0% | 60182.9 ± 1.7% | 0.995 | — | — |
| string: http/css-1m | 1048576 | 58949.1 ± 4.1% | 59643.6 ± 3.0% | 0.988 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 14617.8 ± 0.8% | 15354.0 ± 0.5% | 0.952 | — | — |

## Losses to simdutf

- string: http/json-1m: stdx runs at 0.940 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 57734.4 ± 1.2% | 58282.9 ± 1.4% | 0.991 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 58575.0 ± 2.4% | 58359.0 ± 3.9% | 1.004 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 58333.3 ± 3.7% | 58341.2 ± 1.7% | 1.000 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 58201.9 ± 1.0% | 57970.8 ± 4.1% | 1.004 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 58446.0 ± 1.1% | 58631.8 ± 4.1% | 0.997 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 58193.7 ± 2.1% | 57866.0 ± 2.5% | 1.006 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 14566.9 ± 0.6% | 15318.4 ± 0.5% | 0.951 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 14608.5 ± 0.4% | 15326.1 ± 1.6% | 0.953 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 14602.7 ± 3.4% | 15326.1 ± 0.3% | 0.953 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 14619.8 ± 0.3% | 15313.8 ± 1.4% | 0.955 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 14626.6 ± 0.2% | 15323.8 ± 13.7% | 0.955 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 14608.5 ± 0.9% | 15321.4 ± 0.7% | 0.953 | — | — |

## Messages against serde_json's typed code

stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.

| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |
|---|---|---|---|---|
| messages: 11 string members | 1025025 | 1096.7 ± 4.7% | 540.5 ± 0.6% | 2.029 |
| messages: 50 nested objects | 1121600 | 1122.4 ± 3.0% | 631.9 ± 2.5% | 1.776 |
| messages: a tree of 341 objects | 612600 | 454.8 ± 3.8% | 367.8 ± 0.5% | 1.237 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1025.8 ± 0.7% | 982.6 ± 1.3% | 973.2 ± 0.4% | 261.7 ± 19.4% | 527.6 ± 14.8% | 259.5 ± 4.2% | 1.044 | 1.054 | 3.920 | 1.944 | 3.953 |
| qlog records, JSON text sequence | 1467503 | 840.7 ± 0.7% | 797.0 ± 0.4% | 785.8 ± 2.0% | 229.7 ± 0.7% | 588.8 ± 13.7% | 246.9 ± 1.9% | 1.055 | 1.070 | 3.659 | 1.428 | 3.404 |
| messages: 11 string members | 1025025 | 909.2 ± 0.8% | 1119.3 ± 0.4% | 667.3 ± 2.6% | 261.8 ± 1.8% | 451.9 ± 1.4% | 245.6 ± 2.4% | 0.812 | 1.363 | 3.473 | 2.012 | 3.701 |
| messages: 50 nested objects | 1121600 | 1020.3 ± 4.9% | 995.7 ± 0.4% | 1091.9 ± 4.4% | 281.6 ± 1.3% | 689.7 ± 0.2% | 330.3 ± 0.7% | 1.025 | 0.934 | 3.624 | 1.479 | 3.089 |
| messages: a tree of 341 objects | 612600 | 406.6 ± 13.2% | 444.6 ± 0.5% | 505.0 ± 1.0% | 123.6 ± 0.2% | 453.2 ± 2.2% | 146.6 ± 0.7% | 0.915 | 0.805 | 3.291 | 0.897 | 2.774 |
| string: silesia/dickens | 172528 | 6235.8 ± 0.9% | 2883.5 ± 1.0% | 2058.7 ± 2.6% | 290.5 ± 3.6% | 2184.3 ± 4.3% | 495.8 ± 7.1% | 2.163 | 3.029 | 21.463 | 2.855 | 12.578 |
| string: silesia/nci | 1075110 | 5105.6 ± 1.3% | 3469.2 ± 0.2% | 2833.7 ± 23.7% | 467.5 ± 2.0% | 2364.4 ± 1.0% | 526.4 ± 0.9% | 1.472 | 1.802 | 10.921 | 2.159 | 9.699 |
| string: silesia/reymont | 1075159 | 3291.3 ± 0.5% | 2183.3 ± 0.6% | 1766.2 ± 3.7% | 302.8 ± 0.6% | 1634.5 ± 1.0% | 476.3 ± 2.2% | 1.507 | 1.863 | 10.870 | 2.014 | 6.910 |
| string: silesia/samba | 97582 | 3348.7 ± 0.2% | 2864.0 ± 4.9% | 1574.8 ± 8.4% | 253.3 ± 0.3% | 1279.5 ± 0.5% | 355.9 ± 1.5% | 1.169 | 2.126 | 13.222 | 2.617 | 9.410 |
| string: silesia/webster | 1098490 | 4098.1 ± 0.6% | 2034.5 ± 0.4% | 1630.2 ± 0.9% | 292.9 ± 0.6% | 1674.9 ± 10.6% | 443.4 ± 2.0% | 2.014 | 2.514 | 13.991 | 2.447 | 9.243 |
| string: silesia/xml | 1090118 | 5472.4 ± 1.7% | 3719.8 ± 0.9% | 2144.9 ± 1.1% | 385.1 ± 0.4% | 2367.7 ± 1.3% | 516.2 ± 4.8% | 1.471 | 2.551 | 14.212 | 2.311 | 10.602 |
| string: canterbury/alice29.txt | 159425 | 4878.7 ± 0.5% | 2404.3 ± 2.5% | 1816.4 ± 1.7% | 274.5 ± 1.3% | 1933.4 ± 22.3% | 454.6 ± 3.4% | 2.029 | 2.686 | 17.776 | 2.523 | 10.731 |
| string: canterbury/asyoulik.txt | 132198 | 3701.4 ± 2.8% | 2103.7 ± 0.8% | 1473.7 ± 13.5% | 264.8 ± 0.4% | 1600.0 ± 2.3% | 405.8 ± 0.9% | 1.759 | 2.512 | 13.980 | 2.313 | 9.122 |
| string: canterbury/lcet10.txt | 441884 | 6101.3 ± 0.6% | 2790.7 ± 0.3% | 1984.1 ± 0.3% | 313.0 ± 0.4% | 2141.9 ± 0.7% | 491.1 ± 2.0% | 2.186 | 3.075 | 19.493 | 2.848 | 12.425 |
| string: canterbury/plrabn12.txt | 503330 | 4733.0 ± 0.4% | 2687.7 ± 2.9% | 1679.1 ± 3.4% | 286.7 ± 0.7% | 2015.7 ± 0.5% | 462.5 ± 18.2% | 1.761 | 2.819 | 16.508 | 2.348 | 10.234 |
| string: canterbury-large/E.coli | 1048578 | 28522.1 ± 4.0% | 7624.6 ± 0.7% | 3418.7 ± 5.6% | 871.8 ± 0.2% | 5524.4 ± 0.2% | 810.3 ± 1.0% | 3.741 | 8.343 | 32.715 | 5.163 | 35.198 |
| string: canterbury-large/bible.txt | 1055886 | 9572.3 ± 0.6% | 3914.1 ± 0.8% | 2532.3 ± 1.0% | 336.0 ± 0.2% | 2968.6 ± 9.3% | 603.6 ± 4.9% | 2.446 | 3.780 | 28.491 | 3.224 | 15.858 |
| string: canterbury-large/world192.txt | 1103121 | 3764.6 ± 1.0% | 1984.1 ± 0.5% | 1636.4 ± 0.5% | 286.6 ± 1.3% | 1686.1 ± 1.4% | 435.8 ± 0.7% | 1.897 | 2.301 | 13.137 | 2.233 | 8.638 |
| string: http/html-1m | 1058582 | 7822.8 ± 2.5% | 3400.3 ± 0.3% | 2398.7 ± 1.8% | 380.0 ± 1.8% | 2737.4 ± 0.5% | 428.9 ± 1.2% | 2.301 | 3.261 | 20.585 | 2.858 | 18.240 |
| string: http/json-1m | 1190272 | 3311.5 ± 9.1% | 1198.6 ± 0.2% | 1416.4 ± 6.1% | 335.1 ± 7.6% | 849.4 ± 0.5% | 297.4 ± 0.5% | 2.763 | 2.338 | 9.882 | 3.899 | 11.134 |
| string: http/js-1m | 1144362 | 2667.7 ± 0.7% | 1324.7 ± 0.5% | 1156.4 ± 9.4% | 267.0 ± 0.4% | 1171.8 ± 1.1% | 297.6 ± 0.6% | 2.014 | 2.307 | 9.991 | 2.277 | 8.965 |
| string: http/css-1m | 1097820 | 3023.6 ± 3.1% | 2505.7 ± 0.7% | 1550.8 ± 1.1% | 350.9 ± 0.3% | 1514.1 ± 0.6% | 337.7 ± 1.1% | 1.207 | 1.950 | 8.616 | 1.997 | 8.954 |
| string: dickens as Cyrillic and CJK | 1883069 | 5341.2 ± 1.5% | 3170.3 ± 0.7% | 652.1 ± 0.2% | 266.7 ± 1.9% | 496.5 ± 1.1% | 138.1 ± 1.5% | 1.685 | 8.190 | 20.024 | 10.758 | 38.671 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1061.7 ± 1.1% | 1078.2 ± 2.7% | 830.8 ± 0.3% | 159.7 ± 1.8% | 380.7 ± 1.0% | 202.0 ± 3.7% | 0.985 | 1.278 | 6.647 | 2.789 | 5.257 |
| hex: silesia/dickens | 524290 | 29234.3 ± 2.7% | 7654.6 ± 2.1% | 3460.5 ± 0.3% | 444.9 ± 0.4% | 5511.9 ± 0.6% | 823.0 ± 2.8% | 3.819 | 8.448 | 65.711 | 5.304 | 35.521 |
| hex: silesia/mozilla | 524290 | 28617.1 ± 2.2% | 7653.9 ± 1.2% | 3441.6 ± 2.6% | 392.7 ± 4.1% | 5515.9 ± 0.4% | 818.3 ± 2.6% | 3.739 | 8.315 | 72.876 | 5.188 | 34.971 |
| hex: silesia/mr | 524290 | 28858.6 ± 4.0% | 7672.7 ± 1.2% | 3457.1 ± 0.7% | 562.6 ± 0.6% | 5529.8 ± 0.3% | 819.0 ± 1.8% | 3.761 | 8.348 | 51.299 | 5.219 | 35.236 |
| hex: silesia/nci | 524290 | 29352.3 ± 3.5% | 7679.4 ± 1.2% | 3452.8 ± 0.5% | 632.6 ± 0.4% | 5509.9 ± 0.3% | 822.6 ± 2.0% | 3.822 | 8.501 | 46.402 | 5.327 | 35.682 |
| hex: silesia/ooffice | 524290 | 29366.0 ± 1.5% | 7660.7 ± 0.7% | 3450.8 ± 0.3% | 337.1 ± 0.4% | 5497.1 ± 9.5% | 829.7 ± 0.6% | 3.833 | 8.510 | 87.109 | 5.342 | 35.393 |
| hex: silesia/osdb | 524290 | 29149.8 ± 3.4% | 7680.6 ± 0.3% | 3467.0 ± 0.6% | 433.1 ± 0.6% | 5521.2 ± 1.4% | 822.4 ± 1.4% | 3.795 | 8.408 | 67.308 | 5.280 | 35.445 |
| hex: silesia/reymont | 524290 | 29431.3 ± 5.4% | 7679.9 ± 1.2% | 3451.5 ± 1.6% | 464.8 ± 1.9% | 5521.8 ± 3.2% | 824.2 ± 1.5% | 3.832 | 8.527 | 63.321 | 5.330 | 35.710 |
| hex: silesia/samba | 524290 | 28833.4 ± 2.4% | 7680.1 ± 0.5% | 3454.0 ± 1.0% | 342.9 ± 0.3% | 5522.6 ± 0.2% | 825.0 ± 0.7% | 3.754 | 8.348 | 84.081 | 5.221 | 34.952 |
| hex: silesia/sao | 524290 | 29446.9 ± 2.1% | 7676.7 ± 4.1% | 3462.1 ± 0.6% | 273.2 ± 0.2% | 5531.3 ± 0.4% | 817.2 ± 10.1% | 3.836 | 8.506 | 107.793 | 5.324 | 36.034 |
| hex: silesia/webster | 524290 | 28876.5 ± 2.7% | 7668.6 ± 0.8% | 3464.5 ± 0.6% | 405.7 ± 0.7% | 5530.6 ± 0.3% | 826.4 ± 1.9% | 3.766 | 8.335 | 71.175 | 5.221 | 34.941 |
| hex: silesia/x-ray | 524290 | 28163.9 ± 6.1% | 7648.0 ± 1.2% | 3460.5 ± 1.0% | 407.8 ± 0.3% | 5523.2 ± 0.5% | 818.3 ± 2.2% | 3.683 | 8.139 | 69.055 | 5.099 | 34.417 |
| hex: silesia/xml | 524290 | 29065.8 ± 2.3% | 7688.9 ± 0.3% | 3452.4 ± 0.4% | 567.0 ± 0.2% | 5496.6 ± 0.6% | 823.8 ± 0.5% | 3.780 | 8.419 | 51.264 | 5.288 | 35.282 |
| hex: canterbury/alice29.txt | 304180 | 35368.8 ± 3.1% | 7753.9 ± 1.3% | 3562.1 ± 0.5% | 444.6 ± 0.4% | 5531.5 ± 1.1% | 825.8 ± 0.8% | 4.561 | 9.929 | 79.544 | 6.394 | 42.830 |
| hex: canterbury/asyoulik.txt | 250360 | 36673.4 ± 1.1% | 7780.7 ± 3.7% | 3553.9 ± 4.4% | 434.5 ± 0.3% | 5521.0 ± 0.3% | 831.8 ± 1.9% | 4.713 | 10.319 | 84.401 | 6.643 | 44.087 |
| hex: canterbury/cp.html | 49208 | 40776.5 ± 0.3% | 7773.1 ± 0.2% | 3605.9 ± 1.0% | 431.2 ± 0.5% | 5472.0 ± 0.7% | 807.8 ± 8.0% | 5.246 | 11.308 | 94.561 | 7.452 | 50.479 |
| hex: canterbury/fields.c | 22302 | 38356.3 ± 1.0% | 7693.0 ± 0.1% | 3611.5 ± 0.2% | 459.5 ± 1.1% | 5470.6 ± 0.4% | 794.5 ± 4.0% | 4.986 | 10.621 | 83.474 | 7.011 | 48.277 |
| hex: canterbury/grammar.lsp | 7444 | 34279.3 ± 1.9% | 7458.1 ± 0.4% | 3575.1 ± 0.2% | 518.1 ± 16.0% | 5356.4 ± 0.1% | 774.8 ± 2.8% | 4.596 | 9.588 | 66.169 | 6.400 | 44.243 |
| hex: canterbury/kennedy.xls | 524290 | 29600.6 ± 4.8% | 7710.8 ± 0.7% | 3451.9 ± 1.1% | 667.4 ± 0.2% | 5531.2 ± 1.3% | 773.2 ± 7.4% | 3.839 | 8.575 | 44.353 | 5.352 | 38.282 |
| hex: canterbury/lcet10.txt | 524290 | 28727.6 ± 4.5% | 7687.7 ± 1.1% | 3466.2 ± 3.9% | 447.2 ± 6.3% | 5530.6 ± 0.4% | 793.2 ± 5.7% | 3.737 | 8.288 | 64.244 | 5.194 | 36.217 |
| hex: canterbury/plrabn12.txt | 524290 | 29275.1 ± 2.3% | 7698.2 ± 0.6% | 3450.4 ± 1.0% | 434.2 ± 0.4% | 5522.6 ± 0.4% | 799.0 ± 2.5% | 3.803 | 8.485 | 67.428 | 5.301 | 36.641 |
| hex: canterbury/ptt5 | 524290 | 28896.4 ± 0.9% | 7682.9 ± 1.0% | 3467.3 ± 0.4% | 558.9 ± 0.4% | 5518.3 ± 0.1% | 798.2 ± 1.6% | 3.761 | 8.334 | 51.701 | 5.236 | 36.201 |
| hex: canterbury/sum | 76482 | 39480.4 ± 12.2% | 7800.1 ± 0.1% | 3603.1 ± 0.3% | 498.5 ± 0.2% | 5501.5 ± 1.1% | 829.3 ± 5.4% | 5.062 | 10.957 | 79.195 | 7.176 | 47.609 |
| hex: canterbury/xargs.1 | 8456 | 38241.1 ± 1.2% | 7514.7 ± 0.2% | 3508.3 ± 0.3% | 488.3 ± 0.6% | 5359.5 ± 0.4% | 816.7 ± 1.4% | 5.089 | 10.900 | 78.309 | 7.135 | 46.827 |
| hex: canterbury-large/E.coli | 524290 | 29571.3 ± 0.5% | 7697.1 ± 0.8% | 3458.8 ± 0.9% | 711.5 ± 1.0% | 5529.1 ± 0.2% | 765.7 ± 3.0% | 3.842 | 8.550 | 41.562 | 5.348 | 38.618 |
| hex: canterbury-large/bible.txt | 524290 | 29372.4 ± 3.8% | 7703.1 ± 0.5% | 3461.9 ± 0.3% | 464.5 ± 0.7% | 5522.1 ± 0.2% | 769.4 ± 9.9% | 3.813 | 8.484 | 63.241 | 5.319 | 38.177 |
| hex: canterbury-large/world192.txt | 524290 | 28462.0 ± 6.3% | 7659.6 ± 4.8% | 3456.8 ± 1.0% | 429.8 ± 0.1% | 5532.8 ± 0.1% | 755.5 ± 7.4% | 3.716 | 8.234 | 66.221 | 5.144 | 37.672 |
| hex: http/html-1kx1024 | 2099200 | 16919.0 ± 1.9% | 6625.1 ± 0.4% | 3213.7 ± 2.2% | 454.0 ± 0.9% | 4733.8 ± 0.6% | 714.5 ± 2.4% | 2.554 | 5.265 | 37.263 | 3.574 | 23.680 |
| hex: http/html-16kx64 | 2097280 | 34700.4 ± 10.3% | 7678.1 ± 0.6% | 3529.2 ± 0.1% | 460.1 ± 0.9% | 5427.2 ± 0.4% | 794.3 ± 4.7% | 4.519 | 9.832 | 75.422 | 6.394 | 43.687 |
| hex: http/html-1m | 524290 | 29318.7 ± 5.8% | 7702.3 ± 1.6% | 3443.1 ± 0.8% | 461.3 ± 0.4% | 5524.0 ± 0.4% | 771.1 ± 4.6% | 3.806 | 8.515 | 63.556 | 5.307 | 38.022 |
| hex: http/json-1kx1024 | 2099200 | 16830.5 ± 0.7% | 6588.7 ± 1.4% | 3225.5 ± 0.4% | 574.4 ± 0.3% | 4727.5 ± 0.7% | 723.6 ± 7.3% | 2.554 | 5.218 | 29.302 | 3.560 | 23.259 |
| hex: http/json-16kx64 | 2097280 | 33965.3 ± 1.9% | 7671.9 ± 0.6% | 3520.1 ± 8.5% | 585.0 ± 1.3% | 5425.1 ± 0.7% | 794.4 ± 4.6% | 4.427 | 9.649 | 58.056 | 6.261 | 42.756 |
| hex: http/json-1m | 524290 | 31333.8 ± 2.0% | 7701.6 ± 0.6% | 3463.1 ± 0.3% | 604.1 ± 4.0% | 5509.0 ± 0.6% | 773.0 ± 4.3% | 4.068 | 9.048 | 51.867 | 5.688 | 40.536 |
| hex: http/js-1kx1024 | 2099200 | 17114.6 ± 0.6% | 6604.0 ± 0.2% | 3220.6 ± 0.3% | 444.1 ± 0.5% | 4733.2 ± 0.3% | 720.0 ± 4.8% | 2.592 | 5.314 | 38.540 | 3.616 | 23.771 |
| hex: http/js-16kx64 | 2097280 | 34927.8 ± 1.0% | 7666.7 ± 0.7% | 3518.2 ± 0.7% | 449.3 ± 0.4% | 5418.0 ± 4.1% | 806.2 ± 6.0% | 4.556 | 9.928 | 77.742 | 6.447 | 43.322 |
| hex: http/js-1m | 524290 | 28632.6 ± 5.0% | 7666.4 ± 0.6% | 3453.3 ± 0.5% | 467.2 ± 3.4% | 5532.3 ± 5.8% | 780.1 ± 3.4% | 3.735 | 8.291 | 61.284 | 5.176 | 36.704 |
| hex: http/css-1kx1024 | 2099200 | 17006.1 ± 1.0% | 6599.8 ± 0.1% | 3221.3 ± 0.5% | 499.1 ± 0.3% | 4733.5 ± 0.4% | 731.2 ± 1.9% | 2.577 | 5.279 | 34.072 | 3.593 | 23.259 |
| hex: http/css-16kx64 | 2097280 | 35097.0 ± 1.1% | 7662.2 ± 0.9% | 3502.1 ± 0.4% | 508.3 ± 0.6% | 5428.9 ± 0.4% | 806.8 ± 4.3% | 4.581 | 10.022 | 69.052 | 6.465 | 43.499 |
| hex: http/css-1m | 524290 | 25291.1 ± 0.6% | 7643.7 ± 3.9% | 3434.0 ± 1.4% | 500.8 ± 0.9% | 5534.6 ± 0.2% | 777.4 ± 6.8% | 3.309 | 7.365 | 50.497 | 4.570 | 32.533 |
| hex: shuffled/dickens-1m | 524290 | 29229.2 ± 3.0% | 7682.2 ± 0.4% | 3447.1 ± 0.9% | 445.3 ± 0.4% | 5515.5 ± 1.1% | 757.9 ± 3.8% | 3.805 | 8.479 | 65.641 | 5.299 | 38.564 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1347.3 ± 1.2% | 1141.2 ± 1.1% | 899.1 ± 0.8% | 328.0 ± 6.4% | 350.3 ± 1.7% | 314.9 ± 17.3% | 1.181 | 1.499 | 4.107 | 3.847 | 4.279 |
| qlog records, JSON text sequence | 1467503 | 1166.8 ± 2.3% | 872.0 ± 10.7% | 723.3 ± 0.6% | 317.5 ± 0.8% | 384.8 ± 7.7% | 230.8 ± 17.0% | 1.338 | 1.613 | 3.675 | 3.032 | 5.056 |
| messages: 11 string members | 1025025 | 1071.7 ± 3.3% | 892.8 ± 1.9% | 663.6 ± 1.0% | 308.3 ± 2.4% | 323.1 ± 1.3% | 284.6 ± 2.1% | 1.200 | 1.615 | 3.476 | 3.317 | 3.766 |
| messages: 50 nested objects | 1121600 | 1366.9 ± 1.7% | 1214.6 ± 2.9% | 997.3 ± 2.1% | 396.7 ± 0.8% | 433.8 ± 0.6% | 327.2 ± 1.8% | 1.125 | 1.371 | 3.446 | 3.151 | 4.178 |
| messages: a tree of 341 objects | 612600 | 457.0 ± 2.1% | 608.2 ± 1.4% | 411.6 ± 0.8% | 205.2 ± 2.0% | 270.9 ± 2.8% | 129.2 ± 1.6% | 0.751 | 1.110 | 2.226 | 1.687 | 3.538 |
| string: silesia/dickens | 172528 | 8541.2 ± 0.8% | 3027.3 ± 3.1% | 2028.4 ± 0.2% | 360.9 ± 1.4% | 1051.5 ± 1.5% | 561.7 ± 0.2% | 2.821 | 4.211 | 23.667 | 8.123 | 15.205 |
| string: silesia/nci | 1075110 | 8082.5 ± 1.6% | 3235.4 ± 0.9% | 2783.8 ± 0.2% | 775.0 ± 1.8% | 1094.5 ± 1.9% | 562.3 ± 0.7% | 2.498 | 2.903 | 10.429 | 7.384 | 14.374 |
| string: silesia/reymont | 1075159 | 3818.0 ± 0.3% | 1646.0 ± 0.7% | 1721.9 ± 0.4% | 368.7 ± 0.3% | 961.6 ± 0.4% | 550.6 ± 1.0% | 2.320 | 2.217 | 10.356 | 3.970 | 6.934 |
| string: silesia/samba | 97582 | 4537.7 ± 2.8% | 1987.3 ± 4.3% | 2157.3 ± 0.4% | 297.5 ± 0.4% | 895.0 ± 0.3% | 621.5 ± 2.3% | 2.283 | 2.103 | 15.254 | 5.070 | 7.302 |
| string: silesia/webster | 1098490 | 5067.0 ± 2.3% | 1645.2 ± 0.8% | 1514.3 ± 1.2% | 358.9 ± 1.1% | 939.2 ± 1.6% | 455.1 ± 0.5% | 3.080 | 3.346 | 14.116 | 5.395 | 11.134 |
| string: silesia/xml | 1090118 | 7678.3 ± 4.6% | 2682.3 ± 0.7% | 2151.3 ± 1.9% | 527.9 ± 0.3% | 1123.2 ± 0.4% | 561.6 ± 0.5% | 2.863 | 3.569 | 14.544 | 6.836 | 13.672 |
| string: canterbury/alice29.txt | 159425 | 9251.6 ± 0.4% | 2429.8 ± 2.5% | 1790.8 ± 1.0% | 342.5 ± 1.6% | 1025.4 ± 1.3% | 556.2 ± 0.2% | 3.808 | 5.166 | 27.008 | 9.022 | 16.634 |
| string: canterbury/asyoulik.txt | 132198 | 7348.7 ± 0.7% | 2086.1 ± 23.4% | 1523.9 ± 0.4% | 347.2 ± 1.0% | 908.0 ± 13.9% | 543.6 ± 0.9% | 3.523 | 4.822 | 21.168 | 8.093 | 13.519 |
| string: canterbury/lcet10.txt | 441884 | 8367.6 ± 6.0% | 2476.0 ± 0.6% | 1973.9 ± 0.9% | 397.0 ± 0.5% | 1037.7 ± 0.4% | 554.5 ± 8.0% | 3.379 | 4.239 | 21.078 | 8.064 | 15.089 |
| string: canterbury/plrabn12.txt | 503330 | 5869.7 ± 0.4% | 1847.4 ± 0.8% | 1662.7 ± 1.4% | 369.8 ± 1.0% | 1007.7 ± 2.3% | 560.1 ± 1.7% | 3.177 | 3.530 | 15.872 | 5.825 | 10.479 |
| string: canterbury-large/E.coli | 1048578 | 28271.0 ± 5.4% | 10401.3 ± 2.9% | 3379.9 ± 1.3% | 1417.6 ± 2.2% | 1418.6 ± 0.9% | 580.5 ± 0.9% | 2.718 | 8.364 | 19.942 | 19.928 | 48.700 |
| string: canterbury-large/bible.txt | 1055886 | 6979.9 ± 0.3% | 3983.5 ± 2.1% | 2651.5 ± 3.2% | 441.5 ± 1.0% | 1214.2 ± 1.2% | 569.1 ± 0.2% | 1.752 | 2.632 | 15.808 | 5.748 | 12.265 |
| string: canterbury-large/world192.txt | 1103121 | 4831.8 ± 6.6% | 1454.7 ± 0.5% | 1569.7 ± 7.6% | 365.3 ± 0.6% | 932.2 ± 0.7% | 540.1 ± 0.8% | 3.322 | 3.078 | 13.228 | 5.184 | 8.946 |
| string: http/html-1m | 1058582 | 8445.4 ± 0.5% | 3890.3 ± 0.8% | 2475.2 ± 11.5% | 446.5 ± 0.6% | 1189.5 ± 1.2% | 522.5 ± 0.2% | 2.171 | 3.412 | 18.914 | 7.100 | 16.162 |
| string: http/json-1m | 1190272 | 6334.9 ± 9.5% | 1233.1 ± 0.6% | 1267.5 ± 0.6% | 413.8 ± 0.6% | 782.9 ± 0.4% | 512.8 ± 2.5% | 5.137 | 4.998 | 15.308 | 8.092 | 12.355 |
| string: http/js-1m | 1144362 | 4963.3 ± 2.3% | 996.1 ± 1.0% | 1084.2 ± 10.5% | 304.4 ± 11.6% | 786.9 ± 0.2% | 475.2 ± 0.8% | 4.983 | 4.578 | 16.303 | 6.307 | 10.445 |
| string: http/css-1m | 1097820 | 6545.2 ± 1.8% | 1296.6 ± 1.1% | 1597.3 ± 5.6% | 439.5 ± 3.0% | 855.5 ± 2.1% | 530.2 ± 1.0% | 5.048 | 4.098 | 14.892 | 7.651 | 12.345 |
| string: dickens as Cyrillic and CJK | 1883069 | 5327.3 ± 0.3% | 3025.7 ± 0.3% | 342.1 ± 1.3% | 275.7 ± 0.3% | 400.4 ± 0.7% | 292.9 ± 0.5% | 1.761 | 15.574 | 19.325 | 13.306 | 18.189 |
| hex: silesia/dickens | 524290 | 30711.9 ± 1.1% | 1549.0 ± 0.4% | 1088.9 ± 0.4% | 427.3 ± 1.3% | 792.3 ± 0.3% | 451.1 ± 0.2% | 19.827 | 28.204 | 71.874 | 38.762 | 68.088 |
| hex: silesia/mozilla | 524290 | 34279.7 ± 1.2% | 1555.3 ± 0.4% | 1087.7 ± 0.1% | 372.6 ± 0.3% | 795.7 ± 0.2% | 451.3 ± 1.3% | 22.041 | 31.515 | 92.009 | 43.079 | 75.955 |
| hex: silesia/mr | 524290 | 34678.1 ± 0.5% | 1548.9 ± 0.5% | 1085.9 ± 0.4% | 510.2 ± 14.5% | 794.6 ± 1.5% | 451.1 ± 7.5% | 22.389 | 31.934 | 67.975 | 43.643 | 76.882 |
| hex: silesia/nci | 524290 | 35059.1 ± 0.7% | 1555.3 ± 0.6% | 1086.9 ± 1.5% | 583.1 ± 0.2% | 798.4 ± 1.2% | 450.6 ± 0.5% | 22.541 | 32.257 | 60.128 | 43.914 | 77.806 |
| hex: silesia/ooffice | 524290 | 33615.2 ± 2.0% | 1547.9 ± 1.3% | 1087.3 ± 0.2% | 329.1 ± 0.3% | 795.0 ± 3.4% | 451.9 ± 0.8% | 21.716 | 30.917 | 102.145 | 42.282 | 74.390 |
| hex: silesia/osdb | 524290 | 32260.8 ± 0.8% | 1549.0 ± 1.0% | 1087.5 ± 0.4% | 414.9 ± 1.3% | 796.7 ± 0.7% | 448.6 ± 0.7% | 20.827 | 29.666 | 77.752 | 40.496 | 71.912 |
| hex: silesia/reymont | 524290 | 33451.7 ± 1.1% | 1551.4 ± 1.0% | 1087.1 ± 0.9% | 444.8 ± 0.5% | 793.0 ± 1.3% | 449.3 ± 0.9% | 21.562 | 30.771 | 75.206 | 42.183 | 74.453 |
| hex: silesia/samba | 524290 | 36020.0 ± 9.1% | 1555.2 ± 0.7% | 1085.1 ± 1.3% | 334.6 ± 0.3% | 798.9 ± 2.2% | 450.9 ± 4.1% | 23.162 | 33.195 | 107.666 | 45.090 | 79.877 |
| hex: silesia/sao | 524290 | 33823.5 ± 0.8% | 1556.7 ± 0.5% | 1089.4 ± 0.3% | 268.8 ± 0.8% | 797.4 ± 1.5% | 451.3 ± 0.7% | 21.727 | 31.047 | 125.817 | 42.416 | 74.951 |
| hex: silesia/webster | 524290 | 36025.5 ± 4.1% | 1557.9 ± 0.7% | 1089.6 ± 0.4% | 408.1 ± 0.9% | 800.1 ± 0.3% | 450.0 ± 1.5% | 23.124 | 33.065 | 88.284 | 45.027 | 80.058 |
| hex: silesia/x-ray | 524290 | 34225.5 ± 10.6% | 1555.7 ± 1.5% | 1089.4 ± 0.3% | 399.1 ± 0.3% | 798.3 ± 0.6% | 451.3 ± 4.4% | 22.000 | 31.415 | 85.748 | 42.873 | 75.839 |
| hex: silesia/xml | 524290 | 34718.8 ± 0.4% | 1556.6 ± 1.0% | 1086.4 ± 9.3% | 584.3 ± 0.4% | 798.4 ± 1.3% | 450.2 ± 1.1% | 22.305 | 31.959 | 59.416 | 43.487 | 77.112 |
| hex: canterbury/alice29.txt | 304180 | 33529.7 ± 0.7% | 1598.9 ± 0.4% | 1099.4 ± 2.3% | 430.6 ± 0.4% | 807.6 ± 0.4% | 455.1 ± 0.7% | 20.971 | 30.499 | 77.863 | 41.519 | 73.677 |
| hex: canterbury/asyoulik.txt | 250360 | 31978.1 ± 0.5% | 1604.1 ± 0.7% | 1099.8 ± 0.3% | 422.9 ± 0.5% | 808.7 ± 0.9% | 454.9 ± 0.5% | 19.935 | 29.076 | 75.620 | 39.541 | 70.290 |
| hex: canterbury/cp.html | 49208 | 31752.1 ± 0.2% | 1622.1 ± 0.3% | 1110.8 ± 0.9% | 465.9 ± 0.4% | 813.1 ± 0.3% | 456.4 ± 0.2% | 19.575 | 28.584 | 68.147 | 39.052 | 69.571 |
| hex: canterbury/fields.c | 22302 | 32005.3 ± 0.3% | 1595.3 ± 1.5% | 1100.8 ± 7.0% | 543.4 ± 0.3% | 807.5 ± 0.4% | 455.6 ± 0.3% | 20.062 | 29.075 | 58.894 | 39.636 | 70.247 |
| hex: canterbury/grammar.lsp | 7444 | 31729.8 ± 0.2% | 1633.8 ± 0.7% | 1117.8 ± 0.2% | 562.7 ± 0.9% | 811.8 ± 1.2% | 461.6 ± 0.2% | 19.421 | 28.385 | 56.392 | 39.088 | 68.741 |
| hex: canterbury/kennedy.xls | 524290 | 30899.9 ± 0.7% | 1554.0 ± 0.7% | 1087.3 ± 1.9% | 594.8 ± 14.8% | 794.3 ± 1.3% | 452.5 ± 0.5% | 19.884 | 28.419 | 51.954 | 38.903 | 68.292 |
| hex: canterbury/lcet10.txt | 524290 | 35387.2 ± 0.8% | 1550.8 ± 8.5% | 1087.0 ± 0.2% | 431.1 ± 0.2% | 795.8 ± 1.4% | 451.2 ± 0.8% | 22.819 | 32.555 | 82.076 | 44.465 | 78.423 |
| hex: canterbury/plrabn12.txt | 524290 | 34597.3 ± 1.1% | 1559.9 ± 1.6% | 1085.6 ± 5.7% | 421.0 ± 0.4% | 795.4 ± 23.3% | 451.3 ± 0.8% | 22.180 | 31.870 | 82.181 | 43.495 | 76.664 |
| hex: canterbury/ptt5 | 524290 | 33806.6 ± 2.3% | 1552.7 ± 7.8% | 1088.6 ± 0.4% | 500.3 ± 0.1% | 794.6 ± 0.2% | 450.3 ± 1.4% | 21.772 | 31.055 | 67.578 | 42.543 | 75.071 |
| hex: canterbury/sum | 76482 | 35036.5 ± 0.4% | 1614.4 ± 2.0% | 1108.0 ± 0.6% | 522.1 ± 0.8% | 810.5 ± 0.2% | 458.5 ± 0.5% | 21.703 | 31.623 | 67.110 | 43.227 | 76.419 |
| hex: canterbury/xargs.1 | 8456 | 34619.6 ± 0.5% | 1628.1 ± 0.4% | 1111.7 ± 0.6% | 598.5 ± 0.3% | 814.5 ± 0.1% | 461.8 ± 0.7% | 21.263 | 31.141 | 57.841 | 42.506 | 74.970 |
| hex: canterbury-large/E.coli | 524290 | 30239.6 ± 1.4% | 1551.3 ± 0.8% | 1086.9 ± 0.5% | 607.5 ± 1.3% | 797.2 ± 0.5% | 452.2 ± 0.8% | 19.492 | 27.823 | 49.775 | 37.932 | 66.875 |
| hex: canterbury-large/bible.txt | 524290 | 34749.9 ± 1.3% | 1556.1 ± 7.1% | 1086.7 ± 0.4% | 444.0 ± 0.8% | 795.9 ± 0.3% | 451.9 ± 3.1% | 22.331 | 31.977 | 78.262 | 43.662 | 76.892 |
| hex: canterbury-large/world192.txt | 524290 | 33165.8 ± 0.5% | 1552.1 ± 8.2% | 1087.8 ± 0.6% | 421.7 ± 0.5% | 797.6 ± 0.3% | 451.7 ± 0.4% | 21.368 | 30.489 | 78.642 | 41.582 | 73.419 |
| hex: http/html-1kx1024 | 2099200 | 23607.1 ± 21.5% | 1610.3 ± 0.6% | 1089.7 ± 0.9% | 458.4 ± 2.9% | 806.8 ± 13.3% | 453.7 ± 0.7% | 14.660 | 21.664 | 51.501 | 29.260 | 52.029 |
| hex: http/html-16kx64 | 2097280 | 29952.9 ± 1.4% | 1609.5 ± 1.1% | 1104.3 ± 0.2% | 449.2 ± 0.6% | 767.1 ± 1.5% | 452.8 ± 3.6% | 18.610 | 27.124 | 66.685 | 39.045 | 66.152 |
| hex: http/html-1m | 524290 | 31238.5 ± 0.9% | 1550.7 ± 1.2% | 1084.8 ± 1.9% | 447.9 ± 0.4% | 790.7 ± 0.6% | 449.4 ± 0.7% | 20.145 | 28.796 | 69.749 | 39.505 | 69.507 |
| hex: http/json-1kx1024 | 2099200 | 23405.2 ± 0.9% | 1607.8 ± 1.1% | 1089.9 ± 0.2% | 564.1 ± 6.1% | 805.4 ± 0.4% | 450.9 ± 4.6% | 14.558 | 21.475 | 41.495 | 29.059 | 51.907 |
| hex: http/json-16kx64 | 2097280 | 29633.6 ± 1.6% | 1607.4 ± 0.4% | 1103.0 ± 1.5% | 557.6 ± 0.3% | 760.9 ± 1.5% | 457.2 ± 1.4% | 18.436 | 26.867 | 53.149 | 38.944 | 64.821 |
| hex: http/json-1m | 524290 | 30943.7 ± 1.2% | 1544.1 ± 8.5% | 1084.1 ± 1.7% | 588.2 ± 0.2% | 782.8 ± 0.5% | 448.7 ± 1.0% | 20.040 | 28.544 | 52.605 | 39.531 | 68.964 |
| hex: http/js-1kx1024 | 2099200 | 23723.1 ± 1.3% | 1609.7 ± 0.2% | 1088.5 ± 0.2% | 445.2 ± 1.8% | 807.4 ± 0.1% | 450.6 ± 0.7% | 14.738 | 21.795 | 53.291 | 29.381 | 52.652 |
| hex: http/js-16kx64 | 2097280 | 29739.0 ± 2.7% | 1606.0 ± 0.5% | 1102.6 ± 3.2% | 448.6 ± 3.1% | 806.5 ± 12.6% | 455.9 ± 2.2% | 18.518 | 26.971 | 66.299 | 36.876 | 65.230 |
| hex: http/js-1m | 524290 | 30844.5 ± 1.0% | 1552.8 ± 1.9% | 1085.6 ± 0.9% | 455.2 ± 0.4% | 795.5 ± 1.0% | 450.4 ± 2.0% | 19.863 | 28.414 | 67.758 | 38.776 | 68.488 |
| hex: http/css-1kx1024 | 2099200 | 23153.7 ± 10.8% | 1610.6 ± 6.8% | 1088.2 ± 0.4% | 500.7 ± 1.4% | 807.3 ± 0.2% | 451.4 ± 2.0% | 14.376 | 21.276 | 46.247 | 28.681 | 51.289 |
| hex: http/css-16kx64 | 2097280 | 30180.2 ± 1.0% | 1608.9 ± 0.2% | 1104.1 ± 1.3% | 502.7 ± 0.6% | 795.2 ± 0.4% | 457.3 ± 5.1% | 18.759 | 27.335 | 60.038 | 37.951 | 65.999 |
| hex: http/css-1m | 524290 | 30580.0 ± 7.2% | 1551.2 ± 0.7% | 1088.2 ± 1.2% | 485.2 ± 0.3% | 789.0 ± 0.5% | 450.8 ± 0.3% | 19.714 | 28.103 | 63.021 | 38.758 | 67.837 |
| hex: shuffled/dickens-1m | 524290 | 32616.1 ± 13.9% | 1558.8 ± 1.2% | 1089.1 ± 1.0% | 431.0 ± 0.7% | 797.1 ± 1.0% | 448.6 ± 3.9% | 20.923 | 29.949 | 75.684 | 40.917 | 72.702 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1344.6 ± 17.0% | 1141.2 ± 1.1% | 899.1 ± 0.8% | 328.0 ± 6.4% | 350.3 ± 1.7% | 314.9 ± 17.3% | 1.178 | 1.495 | 4.099 | 3.839 | 4.271 |
| qlog records, JSON text sequence | 1467503 | 1167.0 ± 0.3% | 872.0 ± 10.7% | 723.3 ± 0.6% | 317.5 ± 0.8% | 384.8 ± 7.7% | 230.8 ± 17.0% | 1.338 | 1.613 | 3.675 | 3.033 | 5.057 |
| messages: 11 string members | 1025025 | 1107.8 ± 4.1% | 892.8 ± 1.9% | 663.6 ± 1.0% | 308.3 ± 2.4% | 323.1 ± 1.3% | 284.6 ± 2.1% | 1.241 | 1.669 | 3.593 | 3.429 | 3.893 |
| messages: 50 nested objects | 1121600 | 1358.8 ± 1.8% | 1214.6 ± 2.9% | 997.3 ± 2.1% | 396.7 ± 0.8% | 433.8 ± 0.6% | 327.2 ± 1.8% | 1.119 | 1.362 | 3.425 | 3.132 | 4.153 |
| messages: a tree of 341 objects | 612600 | 496.2 ± 13.0% | 608.2 ± 1.4% | 411.6 ± 0.8% | 205.2 ± 2.0% | 270.9 ± 2.8% | 129.2 ± 1.6% | 0.816 | 1.205 | 2.417 | 1.832 | 3.841 |
| string: silesia/dickens | 172528 | 8983.1 ± 0.1% | 3027.3 ± 3.1% | 2028.4 ± 0.2% | 360.9 ± 1.4% | 1051.5 ± 1.5% | 561.7 ± 0.2% | 2.967 | 4.429 | 24.891 | 8.543 | 15.992 |
| string: silesia/nci | 1075110 | 8284.9 ± 0.4% | 3235.4 ± 0.9% | 2783.8 ± 0.2% | 775.0 ± 1.8% | 1094.5 ± 1.9% | 562.3 ± 0.7% | 2.561 | 2.976 | 10.690 | 7.569 | 14.734 |
| string: silesia/reymont | 1075159 | 3830.8 ± 0.2% | 1646.0 ± 0.7% | 1721.9 ± 0.4% | 368.7 ± 0.3% | 961.6 ± 0.4% | 550.6 ± 1.0% | 2.327 | 2.225 | 10.391 | 3.984 | 6.957 |
| string: silesia/samba | 97582 | 5063.3 ± 8.4% | 1987.3 ± 4.3% | 2157.3 ± 0.4% | 297.5 ± 0.4% | 895.0 ± 0.3% | 621.5 ± 2.3% | 2.548 | 2.347 | 17.021 | 5.657 | 8.147 |
| string: silesia/webster | 1098490 | 5027.6 ± 0.4% | 1645.2 ± 0.8% | 1514.3 ± 1.2% | 358.9 ± 1.1% | 939.2 ± 1.6% | 455.1 ± 0.5% | 3.056 | 3.320 | 14.007 | 5.353 | 11.048 |
| string: silesia/xml | 1090118 | 8115.1 ± 1.8% | 2682.3 ± 0.7% | 2151.3 ± 1.9% | 527.9 ± 0.3% | 1123.2 ± 0.4% | 561.6 ± 0.5% | 3.025 | 3.772 | 15.371 | 7.225 | 14.450 |
| string: canterbury/alice29.txt | 159425 | 9515.8 ± 1.3% | 2429.8 ± 2.5% | 1790.8 ± 1.0% | 342.5 ± 1.6% | 1025.4 ± 1.3% | 556.2 ± 0.2% | 3.916 | 5.314 | 27.779 | 9.280 | 17.109 |
| string: canterbury/asyoulik.txt | 132198 | 7638.1 ± 1.0% | 2086.1 ± 23.4% | 1523.9 ± 0.4% | 347.2 ± 1.0% | 908.0 ± 13.9% | 543.6 ± 0.9% | 3.661 | 5.012 | 22.002 | 8.412 | 14.052 |
| string: canterbury/lcet10.txt | 441884 | 8661.1 ± 0.9% | 2476.0 ± 0.6% | 1973.9 ± 0.9% | 397.0 ± 0.5% | 1037.7 ± 0.4% | 554.5 ± 8.0% | 3.498 | 4.388 | 21.817 | 8.347 | 15.618 |
| string: canterbury/plrabn12.txt | 503330 | 6117.7 ± 0.3% | 1847.4 ± 0.8% | 1662.7 ± 1.4% | 369.8 ± 1.0% | 1007.7 ± 2.3% | 560.1 ± 1.7% | 3.312 | 3.679 | 16.543 | 6.071 | 10.922 |
| string: canterbury-large/E.coli | 1048578 | 29019.6 ± 2.8% | 10401.3 ± 2.9% | 3379.9 ± 1.3% | 1417.6 ± 2.2% | 1418.6 ± 0.9% | 580.5 ± 0.9% | 2.790 | 8.586 | 20.470 | 20.456 | 49.989 |
| string: canterbury-large/bible.txt | 1055886 | 7288.4 ± 0.3% | 3983.5 ± 2.1% | 2651.5 ± 3.2% | 441.5 ± 1.0% | 1214.2 ± 1.2% | 569.1 ± 0.2% | 1.830 | 2.749 | 16.507 | 6.002 | 12.807 |
| string: canterbury-large/world192.txt | 1103121 | 4740.0 ± 0.9% | 1454.7 ± 0.5% | 1569.7 ± 7.6% | 365.3 ± 0.6% | 932.2 ± 0.7% | 540.1 ± 0.8% | 3.258 | 3.020 | 12.977 | 5.085 | 8.776 |
| string: http/html-1m | 1058582 | 8583.8 ± 4.6% | 3890.3 ± 0.8% | 2475.2 ± 11.5% | 446.5 ± 0.6% | 1189.5 ± 1.2% | 522.5 ± 0.2% | 2.206 | 3.468 | 19.224 | 7.217 | 16.427 |
| string: http/json-1m | 1190272 | 6466.2 ± 0.3% | 1233.1 ± 0.6% | 1267.5 ± 0.6% | 413.8 ± 0.6% | 782.9 ± 0.4% | 512.8 ± 2.5% | 5.244 | 5.101 | 15.625 | 8.260 | 12.611 |
| string: http/js-1m | 1144362 | 5007.9 ± 0.3% | 996.1 ± 1.0% | 1084.2 ± 10.5% | 304.4 ± 11.6% | 786.9 ± 0.2% | 475.2 ± 0.8% | 5.028 | 4.619 | 16.450 | 6.364 | 10.539 |
| string: http/css-1m | 1097820 | 6842.2 ± 1.6% | 1296.6 ± 1.1% | 1597.3 ± 5.6% | 439.5 ± 3.0% | 855.5 ± 2.1% | 530.2 ± 1.0% | 5.277 | 4.284 | 15.568 | 7.998 | 12.905 |
| string: dickens as Cyrillic and CJK | 1883069 | 5202.7 ± 0.3% | 3025.7 ± 0.3% | 342.1 ± 1.3% | 275.7 ± 0.3% | 400.4 ± 0.7% | 292.9 ± 0.5% | 1.720 | 15.210 | 18.873 | 12.995 | 17.764 |
| hex: silesia/dickens | 524290 | 30825.1 ± 0.5% | 1549.0 ± 0.4% | 1088.9 ± 0.4% | 427.3 ± 1.3% | 792.3 ± 0.3% | 451.1 ± 0.2% | 19.900 | 28.308 | 72.139 | 38.904 | 68.339 |
| hex: silesia/mozilla | 524290 | 34380.9 ± 0.7% | 1555.3 ± 0.4% | 1087.7 ± 0.1% | 372.6 ± 0.3% | 795.7 ± 0.2% | 451.3 ± 1.3% | 22.106 | 31.608 | 92.280 | 43.206 | 76.179 |
| hex: silesia/mr | 524290 | 34907.1 ± 0.5% | 1548.9 ± 0.5% | 1085.9 ± 0.4% | 510.2 ± 14.5% | 794.6 ± 1.5% | 451.1 ± 7.5% | 22.537 | 32.145 | 68.423 | 43.931 | 77.390 |
| hex: silesia/nci | 524290 | 35160.9 ± 0.3% | 1555.3 ± 0.6% | 1086.9 ± 1.5% | 583.1 ± 0.2% | 798.4 ± 1.2% | 450.6 ± 0.5% | 22.607 | 32.351 | 60.303 | 44.042 | 78.032 |
| hex: silesia/ooffice | 524290 | 33668.2 ± 0.7% | 1547.9 ± 1.3% | 1087.3 ± 0.2% | 329.1 ± 0.3% | 795.0 ± 3.4% | 451.9 ± 0.8% | 21.751 | 30.966 | 102.306 | 42.348 | 74.508 |
| hex: silesia/osdb | 524290 | 32313.7 ± 1.9% | 1549.0 ± 1.0% | 1087.5 ± 0.4% | 414.9 ± 1.3% | 796.7 ± 0.7% | 448.6 ± 0.7% | 20.861 | 29.715 | 77.879 | 40.562 | 72.030 |
| hex: silesia/reymont | 524290 | 33596.0 ± 0.7% | 1551.4 ± 1.0% | 1087.1 ± 0.9% | 444.8 ± 0.5% | 793.0 ± 1.3% | 449.3 ± 0.9% | 21.655 | 30.904 | 75.531 | 42.365 | 74.774 |
| hex: silesia/samba | 524290 | 36198.0 ± 0.8% | 1555.2 ± 0.7% | 1085.1 ± 1.3% | 334.6 ± 0.3% | 798.9 ± 2.2% | 450.9 ± 4.1% | 23.276 | 33.358 | 108.197 | 45.312 | 80.272 |
| hex: silesia/sao | 524290 | 34086.1 ± 19.0% | 1556.7 ± 0.5% | 1089.4 ± 0.3% | 268.8 ± 0.8% | 797.4 ± 1.5% | 451.3 ± 0.7% | 21.896 | 31.289 | 126.794 | 42.745 | 75.533 |
| hex: silesia/webster | 524290 | 35705.5 ± 2.0% | 1557.9 ± 0.7% | 1089.6 ± 0.4% | 408.1 ± 0.9% | 800.1 ± 0.3% | 450.0 ± 1.5% | 22.918 | 32.771 | 87.500 | 44.627 | 79.347 |
| hex: silesia/x-ray | 524290 | 34289.1 ± 0.3% | 1555.7 ± 1.5% | 1089.4 ± 0.3% | 399.1 ± 0.3% | 798.3 ± 0.6% | 451.3 ± 4.4% | 22.041 | 31.474 | 85.907 | 42.953 | 75.980 |
| hex: silesia/xml | 524290 | 34849.2 ± 2.6% | 1556.6 ± 1.0% | 1086.4 ± 9.3% | 584.3 ± 0.4% | 798.4 ± 1.3% | 450.2 ± 1.1% | 22.389 | 32.079 | 59.639 | 43.650 | 77.402 |
| hex: canterbury/alice29.txt | 304180 | 33462.5 ± 0.8% | 1598.9 ± 0.4% | 1099.4 ± 2.3% | 430.6 ± 0.4% | 807.6 ± 0.4% | 455.1 ± 0.7% | 20.929 | 30.438 | 77.707 | 41.436 | 73.529 |
| hex: canterbury/asyoulik.txt | 250360 | 32045.5 ± 0.6% | 1604.1 ± 0.7% | 1099.8 ± 0.3% | 422.9 ± 0.5% | 808.7 ± 0.9% | 454.9 ± 0.5% | 19.977 | 29.137 | 75.779 | 39.624 | 70.438 |
| hex: canterbury/cp.html | 49208 | 31735.5 ± 13.9% | 1622.1 ± 0.3% | 1110.8 ± 0.9% | 465.9 ± 0.4% | 813.1 ± 0.3% | 456.4 ± 0.2% | 19.565 | 28.569 | 68.111 | 39.032 | 69.534 |
| hex: canterbury/fields.c | 22302 | 31987.4 ± 1.3% | 1595.3 ± 1.5% | 1100.8 ± 7.0% | 543.4 ± 0.3% | 807.5 ± 0.4% | 455.6 ± 0.3% | 20.051 | 29.059 | 58.862 | 39.613 | 70.208 |
| hex: canterbury/grammar.lsp | 7444 | 32172.4 ± 17.1% | 1633.8 ± 0.7% | 1117.8 ± 0.2% | 562.7 ± 0.9% | 811.8 ± 1.2% | 461.6 ± 0.2% | 19.692 | 28.781 | 57.179 | 39.633 | 69.700 |
| hex: canterbury/kennedy.xls | 524290 | 30975.4 ± 2.1% | 1554.0 ± 0.7% | 1087.3 ± 1.9% | 594.8 ± 14.8% | 794.3 ± 1.3% | 452.5 ± 0.5% | 19.933 | 28.488 | 52.081 | 38.998 | 68.459 |
| hex: canterbury/lcet10.txt | 524290 | 35689.1 ± 0.8% | 1550.8 ± 8.5% | 1087.0 ± 0.2% | 431.1 ± 0.2% | 795.8 ± 1.4% | 451.2 ± 0.8% | 23.013 | 32.832 | 82.777 | 44.844 | 79.092 |
| hex: canterbury/plrabn12.txt | 524290 | 34826.6 ± 0.8% | 1559.9 ± 1.6% | 1085.6 ± 5.7% | 421.0 ± 0.4% | 795.4 ± 23.3% | 451.3 ± 0.8% | 22.327 | 32.081 | 82.726 | 43.783 | 77.172 |
| hex: canterbury/ptt5 | 524290 | 34280.5 ± 2.1% | 1552.7 ± 7.8% | 1088.6 ± 0.4% | 500.3 ± 0.1% | 794.6 ± 0.2% | 450.3 ± 1.4% | 22.077 | 31.490 | 68.525 | 43.139 | 76.123 |
| hex: canterbury/sum | 76482 | 35124.1 ± 0.5% | 1614.4 ± 2.0% | 1108.0 ± 0.6% | 522.1 ± 0.8% | 810.5 ± 0.2% | 458.5 ± 0.5% | 21.757 | 31.702 | 67.278 | 43.335 | 76.610 |
| hex: canterbury/xargs.1 | 8456 | 34918.8 ± 0.1% | 1628.1 ± 0.4% | 1111.7 ± 0.6% | 598.5 ± 0.3% | 814.5 ± 0.1% | 461.8 ± 0.7% | 21.447 | 31.410 | 58.341 | 42.873 | 75.618 |
| hex: canterbury-large/E.coli | 524290 | 30384.8 ± 1.1% | 1551.3 ± 0.8% | 1086.9 ± 0.5% | 607.5 ± 1.3% | 797.2 ± 0.5% | 452.2 ± 0.8% | 19.586 | 27.956 | 50.014 | 38.114 | 67.196 |
| hex: canterbury-large/bible.txt | 524290 | 34905.3 ± 1.9% | 1556.1 ± 7.1% | 1086.7 ± 0.4% | 444.0 ± 0.8% | 795.9 ± 0.3% | 451.9 ± 3.1% | 22.431 | 32.120 | 78.612 | 43.857 | 77.236 |
| hex: canterbury-large/world192.txt | 524290 | 33354.9 ± 0.4% | 1552.1 ± 8.2% | 1087.8 ± 0.6% | 421.7 ± 0.5% | 797.6 ± 0.3% | 451.7 ± 0.4% | 21.490 | 30.663 | 79.090 | 41.819 | 73.837 |
| hex: http/html-1kx1024 | 2099200 | 23854.6 ± 0.8% | 1610.3 ± 0.6% | 1089.7 ± 0.9% | 458.4 ± 2.9% | 806.8 ± 13.3% | 453.7 ± 0.7% | 14.813 | 21.891 | 52.041 | 29.567 | 52.574 |
| hex: http/html-16kx64 | 2097280 | 30045.1 ± 0.8% | 1609.5 ± 1.1% | 1104.3 ± 0.2% | 449.2 ± 0.6% | 767.1 ± 1.5% | 452.8 ± 3.6% | 18.668 | 27.208 | 66.890 | 39.166 | 66.356 |
| hex: http/html-1m | 524290 | 31374.9 ± 0.8% | 1550.7 ± 1.2% | 1084.8 ± 1.9% | 447.9 ± 0.4% | 790.7 ± 0.6% | 449.4 ± 0.7% | 20.233 | 28.922 | 70.054 | 39.678 | 69.810 |
| hex: http/json-1kx1024 | 2099200 | 23587.2 ± 1.1% | 1607.8 ± 1.1% | 1089.9 ± 0.2% | 564.1 ± 6.1% | 805.4 ± 0.4% | 450.9 ± 4.6% | 14.671 | 21.642 | 41.817 | 29.285 | 52.311 |
| hex: http/json-16kx64 | 2097280 | 29917.8 ± 0.4% | 1607.4 ± 0.4% | 1103.0 ± 1.5% | 557.6 ± 0.3% | 760.9 ± 1.5% | 457.2 ± 1.4% | 18.613 | 27.125 | 53.659 | 39.318 | 65.443 |
| hex: http/json-1m | 524290 | 31020.0 ± 1.6% | 1544.1 ± 8.5% | 1084.1 ± 1.7% | 588.2 ± 0.2% | 782.8 ± 0.5% | 448.7 ± 1.0% | 20.089 | 28.614 | 52.735 | 39.628 | 69.134 |
| hex: http/js-1kx1024 | 2099200 | 23940.0 ± 7.7% | 1609.7 ± 0.2% | 1088.5 ± 0.2% | 445.2 ± 1.8% | 807.4 ± 0.1% | 450.6 ± 0.7% | 14.872 | 21.994 | 53.778 | 29.649 | 53.134 |
| hex: http/js-16kx64 | 2097280 | 29812.6 ± 13.8% | 1606.0 ± 0.5% | 1102.6 ± 3.2% | 448.6 ± 3.1% | 806.5 ± 12.6% | 455.9 ± 2.2% | 18.564 | 27.038 | 66.462 | 36.967 | 65.392 |
| hex: http/js-1m | 524290 | 31087.2 ± 0.7% | 1552.8 ± 1.9% | 1085.6 ± 0.9% | 455.2 ± 0.4% | 795.5 ± 1.0% | 450.4 ± 2.0% | 20.020 | 28.637 | 68.291 | 39.081 | 69.027 |
| hex: http/css-1kx1024 | 2099200 | 23853.9 ± 0.4% | 1610.6 ± 6.8% | 1088.2 ± 0.4% | 500.7 ± 1.4% | 807.3 ± 0.2% | 451.4 ± 2.0% | 14.811 | 21.920 | 47.645 | 29.548 | 52.840 |
| hex: http/css-16kx64 | 2097280 | 30049.3 ± 0.7% | 1608.9 ± 0.2% | 1104.1 ± 1.3% | 502.7 ± 0.6% | 795.2 ± 0.4% | 457.3 ± 5.1% | 18.677 | 27.216 | 59.778 | 37.786 | 65.713 |
| hex: http/css-1m | 524290 | 30753.4 ± 0.5% | 1551.2 ± 0.7% | 1088.2 ± 1.2% | 485.2 ± 0.3% | 789.0 ± 0.5% | 450.8 ± 0.3% | 19.826 | 28.262 | 63.378 | 38.978 | 68.222 |
| hex: shuffled/dickens-1m | 524290 | 32897.6 ± 0.4% | 1558.8 ± 1.2% | 1089.1 ± 1.0% | 431.0 ± 0.7% | 797.1 ± 1.0% | 448.6 ± 3.9% | 21.104 | 30.207 | 76.337 | 41.270 | 73.329 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 840.1 ± 0.6% | 982.6 ± 1.3% | 973.2 ± 0.4% | 261.7 ± 19.4% | 527.6 ± 14.8% | 259.5 ± 4.2% | 0.855 | 0.863 | 3.210 | 1.592 | 3.238 |
| qlog records, JSON text sequence | 1467503 | 766.9 ± 2.1% | 797.0 ± 0.4% | 785.8 ± 2.0% | 229.7 ± 0.7% | 588.8 ± 13.7% | 246.9 ± 1.9% | 0.962 | 0.976 | 3.338 | 1.302 | 3.106 |
| messages: 11 string members | 1025025 | 788.0 ± 1.2% | 1119.3 ± 0.4% | 667.3 ± 2.6% | 261.8 ± 1.8% | 451.9 ± 1.4% | 245.6 ± 2.4% | 0.704 | 1.181 | 3.010 | 1.744 | 3.208 |
| messages: 50 nested objects | 1121600 | 924.5 ± 0.7% | 995.7 ± 0.4% | 1091.9 ± 4.4% | 281.6 ± 1.3% | 689.7 ± 0.2% | 330.3 ± 0.7% | 0.929 | 0.847 | 3.283 | 1.341 | 2.799 |
| messages: a tree of 341 objects | 612600 | 317.3 ± 3.8% | 444.6 ± 0.5% | 505.0 ± 1.0% | 123.6 ± 0.2% | 453.2 ± 2.2% | 146.6 ± 0.7% | 0.714 | 0.628 | 2.568 | 0.700 | 2.165 |
| string: silesia/dickens | 172528 | 6182.8 ± 0.4% | 2883.5 ± 1.0% | 2058.7 ± 2.6% | 290.5 ± 3.6% | 2184.3 ± 4.3% | 495.8 ± 7.1% | 2.144 | 3.003 | 21.280 | 2.831 | 12.471 |
| string: silesia/nci | 1075110 | 5118.7 ± 0.7% | 3469.2 ± 0.2% | 2833.7 ± 23.7% | 467.5 ± 2.0% | 2364.4 ± 1.0% | 526.4 ± 0.9% | 1.475 | 1.806 | 10.949 | 2.165 | 9.724 |
| string: silesia/reymont | 1075159 | 3295.7 ± 0.7% | 2183.3 ± 0.6% | 1766.2 ± 3.7% | 302.8 ± 0.6% | 1634.5 ± 1.0% | 476.3 ± 2.2% | 1.509 | 1.866 | 10.885 | 2.016 | 6.919 |
| string: silesia/samba | 97582 | 3348.9 ± 0.2% | 2864.0 ± 4.9% | 1574.8 ± 8.4% | 253.3 ± 0.3% | 1279.5 ± 0.5% | 355.9 ± 1.5% | 1.169 | 2.127 | 13.223 | 2.617 | 9.411 |
| string: silesia/webster | 1098490 | 4106.7 ± 0.4% | 2034.5 ± 0.4% | 1630.2 ± 0.9% | 292.9 ± 0.6% | 1674.9 ± 10.6% | 443.4 ± 2.0% | 2.019 | 2.519 | 14.021 | 2.452 | 9.263 |
| string: silesia/xml | 1090118 | 5482.9 ± 0.8% | 3719.8 ± 0.9% | 2144.9 ± 1.1% | 385.1 ± 0.4% | 2367.7 ± 1.3% | 516.2 ± 4.8% | 1.474 | 2.556 | 14.239 | 2.316 | 10.623 |
| string: canterbury/alice29.txt | 159425 | 4907.1 ± 0.5% | 2404.3 ± 2.5% | 1816.4 ± 1.7% | 274.5 ± 1.3% | 1933.4 ± 22.3% | 454.6 ± 3.4% | 2.041 | 2.702 | 17.879 | 2.538 | 10.793 |
| string: canterbury/asyoulik.txt | 132198 | 3628.7 ± 4.3% | 2103.7 ± 0.8% | 1473.7 ± 13.5% | 264.8 ± 0.4% | 1600.0 ± 2.3% | 405.8 ± 0.9% | 1.725 | 2.462 | 13.706 | 2.268 | 8.943 |
| string: canterbury/lcet10.txt | 441884 | 6117.4 ± 0.5% | 2790.7 ± 0.3% | 1984.1 ± 0.3% | 313.0 ± 0.4% | 2141.9 ± 0.7% | 491.1 ± 2.0% | 2.192 | 3.083 | 19.544 | 2.856 | 12.458 |
| string: canterbury/plrabn12.txt | 503330 | 4726.4 ± 0.5% | 2687.7 ± 2.9% | 1679.1 ± 3.4% | 286.7 ± 0.7% | 2015.7 ± 0.5% | 462.5 ± 18.2% | 1.759 | 2.815 | 16.485 | 2.345 | 10.220 |
| string: canterbury-large/E.coli | 1048578 | 33532.6 ± 0.8% | 7624.6 ± 0.7% | 3418.7 ± 5.6% | 871.8 ± 0.2% | 5524.4 ± 0.2% | 810.3 ± 1.0% | 4.398 | 9.809 | 38.462 | 6.070 | 41.381 |
| string: canterbury-large/bible.txt | 1055886 | 9627.6 ± 0.8% | 3914.1 ± 0.8% | 2532.3 ± 1.0% | 336.0 ± 0.2% | 2968.6 ± 9.3% | 603.6 ± 4.9% | 2.460 | 3.802 | 28.656 | 3.243 | 15.950 |
| string: canterbury-large/world192.txt | 1103121 | 3782.4 ± 1.2% | 1984.1 ± 0.5% | 1636.4 ± 0.5% | 286.6 ± 1.3% | 1686.1 ± 1.4% | 435.8 ± 0.7% | 1.906 | 2.311 | 13.200 | 2.243 | 8.679 |
| string: http/html-1m | 1058582 | 7984.8 ± 1.6% | 3400.3 ± 0.3% | 2398.7 ± 1.8% | 380.0 ± 1.8% | 2737.4 ± 0.5% | 428.9 ± 1.2% | 2.348 | 3.329 | 21.011 | 2.917 | 18.618 |
| string: http/json-1m | 1190272 | 3319.8 ± 0.3% | 1198.6 ± 0.2% | 1416.4 ± 6.1% | 335.1 ± 7.6% | 849.4 ± 0.5% | 297.4 ± 0.5% | 2.770 | 2.344 | 9.907 | 3.908 | 11.162 |
| string: http/js-1m | 1144362 | 2671.1 ± 0.3% | 1324.7 ± 0.5% | 1156.4 ± 9.4% | 267.0 ± 0.4% | 1171.8 ± 1.1% | 297.6 ± 0.6% | 2.016 | 2.310 | 10.003 | 2.279 | 8.977 |
| string: http/css-1m | 1097820 | 3029.8 ± 0.3% | 2505.7 ± 0.7% | 1550.8 ± 1.1% | 350.9 ± 0.3% | 1514.1 ± 0.6% | 337.7 ± 1.1% | 1.209 | 1.954 | 8.633 | 2.001 | 8.972 |
| string: dickens as Cyrillic and CJK | 1883069 | 5354.5 ± 0.7% | 3170.3 ± 0.7% | 652.1 ± 0.2% | 266.7 ± 1.9% | 496.5 ± 1.1% | 138.1 ± 1.5% | 1.689 | 8.211 | 20.074 | 10.784 | 38.766 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1063.1 ± 0.5% | 1078.2 ± 2.7% | 830.8 ± 0.3% | 159.7 ± 1.8% | 380.7 ± 1.0% | 202.0 ± 3.7% | 0.986 | 1.280 | 6.656 | 2.792 | 5.264 |
| hex: silesia/dickens | 524290 | 33138.0 ± 0.8% | 7654.6 ± 2.1% | 3460.5 ± 0.3% | 444.9 ± 0.4% | 5511.9 ± 0.6% | 823.0 ± 2.8% | 4.329 | 9.576 | 74.485 | 6.012 | 40.264 |
| hex: silesia/mozilla | 524290 | 33217.9 ± 5.1% | 7653.9 ± 1.2% | 3441.6 ± 2.6% | 392.7 ± 4.1% | 5515.9 ± 0.4% | 818.3 ± 2.6% | 4.340 | 9.652 | 84.592 | 6.022 | 40.593 |
| hex: silesia/mr | 524290 | 33325.3 ± 0.5% | 7672.7 ± 1.2% | 3457.1 ± 0.7% | 562.6 ± 0.6% | 5529.8 ± 0.3% | 819.0 ± 1.8% | 4.343 | 9.640 | 59.240 | 6.026 | 40.690 |
| hex: silesia/nci | 524290 | 33650.5 ± 0.5% | 7679.4 ± 1.2% | 3452.8 ± 0.5% | 632.6 ± 0.4% | 5509.9 ± 0.3% | 822.6 ± 2.0% | 4.382 | 9.746 | 53.197 | 6.107 | 40.907 |
| hex: silesia/ooffice | 524290 | 33426.5 ± 1.1% | 7660.7 ± 0.7% | 3450.8 ± 0.3% | 337.1 ± 0.4% | 5497.1 ± 9.5% | 829.7 ± 0.6% | 4.363 | 9.687 | 99.154 | 6.081 | 40.287 |
| hex: silesia/osdb | 524290 | 33223.4 ± 0.6% | 7680.6 ± 0.3% | 3467.0 ± 0.6% | 433.1 ± 0.6% | 5521.2 ± 1.4% | 822.4 ± 1.4% | 4.326 | 9.583 | 76.714 | 6.017 | 40.399 |
| hex: silesia/reymont | 524290 | 33279.9 ± 0.6% | 7679.9 ± 1.2% | 3451.5 ± 1.6% | 464.8 ± 1.9% | 5521.8 ± 3.2% | 824.2 ± 1.5% | 4.333 | 9.642 | 71.601 | 6.027 | 40.380 |
| hex: silesia/samba | 524290 | 33388.6 ± 0.8% | 7680.1 ± 0.5% | 3454.0 ± 1.0% | 342.9 ± 0.3% | 5522.6 ± 0.2% | 825.0 ± 0.7% | 4.347 | 9.667 | 97.364 | 6.046 | 40.473 |
| hex: silesia/sao | 524290 | 33603.9 ± 0.3% | 7676.7 ± 4.1% | 3462.1 ± 0.6% | 273.2 ± 0.2% | 5531.3 ± 0.4% | 817.2 ± 10.1% | 4.377 | 9.706 | 123.010 | 6.075 | 41.121 |
| hex: silesia/webster | 524290 | 33673.8 ± 2.2% | 7668.6 ± 0.8% | 3464.5 ± 0.6% | 405.7 ± 0.7% | 5530.6 ± 0.3% | 826.4 ± 1.9% | 4.391 | 9.720 | 82.999 | 6.089 | 40.746 |
| hex: silesia/x-ray | 524290 | 33594.9 ± 0.4% | 7648.0 ± 1.2% | 3460.5 ± 1.0% | 407.8 ± 0.3% | 5523.2 ± 0.5% | 818.3 ± 2.2% | 4.393 | 9.708 | 82.372 | 6.083 | 41.054 |
| hex: silesia/xml | 524290 | 33073.9 ± 9.0% | 7688.9 ± 0.3% | 3452.4 ± 0.4% | 567.0 ± 0.2% | 5496.6 ± 0.6% | 823.8 ± 0.5% | 4.302 | 9.580 | 58.333 | 6.017 | 40.147 |
| hex: canterbury/alice29.txt | 304180 | 33549.8 ± 0.4% | 7753.9 ± 1.3% | 3562.1 ± 0.5% | 444.6 ± 0.4% | 5531.5 ± 1.1% | 825.8 ± 0.8% | 4.327 | 9.419 | 75.453 | 6.065 | 40.627 |
| hex: canterbury/asyoulik.txt | 250360 | 33794.0 ± 1.7% | 7780.7 ± 3.7% | 3553.9 ± 4.4% | 434.5 ± 0.3% | 5521.0 ± 0.3% | 831.8 ± 1.9% | 4.343 | 9.509 | 77.774 | 6.121 | 40.625 |
| hex: canterbury/cp.html | 49208 | 32740.4 ± 2.5% | 7773.1 ± 0.2% | 3605.9 ± 1.0% | 431.2 ± 0.5% | 5472.0 ± 0.7% | 807.8 ± 8.0% | 4.212 | 9.080 | 75.925 | 5.983 | 40.530 |
| hex: canterbury/fields.c | 22302 | 31641.3 ± 0.5% | 7693.0 ± 0.1% | 3611.5 ± 0.2% | 459.5 ± 1.1% | 5470.6 ± 0.4% | 794.5 ± 4.0% | 4.113 | 8.761 | 68.860 | 5.784 | 39.826 |
| hex: canterbury/grammar.lsp | 7444 | 27489.7 ± 3.8% | 7458.1 ± 0.4% | 3575.1 ± 0.2% | 518.1 ± 16.0% | 5356.4 ± 0.1% | 774.8 ± 2.8% | 3.686 | 7.689 | 53.063 | 5.132 | 35.480 |
| hex: canterbury/kennedy.xls | 524290 | 33168.2 ± 0.6% | 7710.8 ± 0.7% | 3451.9 ± 1.1% | 667.4 ± 0.2% | 5531.2 ± 1.3% | 773.2 ± 7.4% | 4.302 | 9.609 | 49.699 | 5.997 | 42.896 |
| hex: canterbury/lcet10.txt | 524290 | 33080.8 ± 1.0% | 7687.7 ± 1.1% | 3466.2 ± 3.9% | 447.2 ± 6.3% | 5530.6 ± 0.4% | 793.2 ± 5.7% | 4.303 | 9.544 | 73.979 | 5.981 | 41.705 |
| hex: canterbury/plrabn12.txt | 524290 | 33484.1 ± 0.4% | 7698.2 ± 0.6% | 3450.4 ± 1.0% | 434.2 ± 0.4% | 5522.6 ± 0.4% | 799.0 ± 2.5% | 4.350 | 9.705 | 77.122 | 6.063 | 41.909 |
| hex: canterbury/ptt5 | 524290 | 33310.8 ± 0.7% | 7682.9 ± 1.0% | 3467.3 ± 0.4% | 558.9 ± 0.4% | 5518.3 ± 0.1% | 798.2 ± 1.6% | 4.336 | 9.607 | 59.599 | 6.036 | 41.731 |
| hex: canterbury/sum | 76482 | 33242.5 ± 0.8% | 7800.1 ± 0.1% | 3603.1 ± 0.3% | 498.5 ± 0.2% | 5501.5 ± 1.1% | 829.3 ± 5.4% | 4.262 | 9.226 | 66.682 | 6.042 | 40.087 |
| hex: canterbury/xargs.1 | 8456 | 28059.4 ± 1.7% | 7514.7 ± 0.2% | 3508.3 ± 0.3% | 488.3 ± 0.6% | 5359.5 ± 0.4% | 816.7 ± 1.4% | 3.734 | 7.998 | 57.460 | 5.235 | 34.359 |
| hex: canterbury-large/E.coli | 524290 | 33560.8 ± 2.3% | 7697.1 ± 0.8% | 3458.8 ± 0.9% | 711.5 ± 1.0% | 5529.1 ± 0.2% | 765.7 ± 3.0% | 4.360 | 9.703 | 47.169 | 6.070 | 43.828 |
| hex: canterbury-large/bible.txt | 524290 | 33342.3 ± 1.8% | 7703.1 ± 0.5% | 3461.9 ± 0.3% | 464.5 ± 0.7% | 5522.1 ± 0.2% | 769.4 ± 9.9% | 4.328 | 9.631 | 71.788 | 6.038 | 43.336 |
| hex: canterbury-large/world192.txt | 524290 | 33691.5 ± 0.3% | 7659.6 ± 4.8% | 3456.8 ± 1.0% | 429.8 ± 0.1% | 5532.8 ± 0.1% | 755.5 ± 7.4% | 4.399 | 9.746 | 78.388 | 6.089 | 44.594 |
| hex: http/html-1kx1024 | 2099200 | 16588.0 ± 5.6% | 6625.1 ± 0.4% | 3213.7 ± 2.2% | 454.0 ± 0.9% | 4733.8 ± 0.6% | 714.5 ± 2.4% | 2.504 | 5.162 | 36.534 | 3.504 | 23.216 |
| hex: http/html-16kx64 | 2097280 | 30554.9 ± 0.8% | 7678.1 ± 0.6% | 3529.2 ± 0.1% | 460.1 ± 0.9% | 5427.2 ± 0.4% | 794.3 ± 4.7% | 3.979 | 8.658 | 66.412 | 5.630 | 38.468 |
| hex: http/html-1m | 524290 | 33383.8 ± 0.5% | 7702.3 ± 1.6% | 3443.1 ± 0.8% | 461.3 ± 0.4% | 5524.0 ± 0.4% | 771.1 ± 4.6% | 4.334 | 9.696 | 72.368 | 6.043 | 43.294 |
| hex: http/json-1kx1024 | 2099200 | 16550.3 ± 1.2% | 6588.7 ± 1.4% | 3225.5 ± 0.4% | 574.4 ± 0.3% | 4727.5 ± 0.7% | 723.6 ± 7.3% | 2.512 | 5.131 | 28.814 | 3.501 | 22.872 |
| hex: http/json-16kx64 | 2097280 | 30749.2 ± 0.4% | 7671.9 ± 0.6% | 3520.1 ± 8.5% | 585.0 ± 1.3% | 5425.1 ± 0.7% | 794.4 ± 4.6% | 4.008 | 8.735 | 52.559 | 5.668 | 38.707 |
| hex: http/json-1m | 524290 | 33174.7 ± 1.9% | 7701.6 ± 0.6% | 3463.1 ± 0.3% | 604.1 ± 4.0% | 5509.0 ± 0.6% | 773.0 ± 4.3% | 4.308 | 9.579 | 54.914 | 6.022 | 42.917 |
| hex: http/js-1kx1024 | 2099200 | 16462.2 ± 1.4% | 6604.0 ± 0.2% | 3220.6 ± 0.3% | 444.1 ± 0.5% | 4733.2 ± 0.3% | 720.0 ± 4.8% | 2.493 | 5.112 | 37.071 | 3.478 | 22.865 |
| hex: http/js-16kx64 | 2097280 | 30439.8 ± 1.3% | 7666.7 ± 0.7% | 3518.2 ± 0.7% | 449.3 ± 0.4% | 5418.0 ± 4.1% | 806.2 ± 6.0% | 3.970 | 8.652 | 67.752 | 5.618 | 37.755 |
| hex: http/js-1m | 524290 | 33111.4 ± 1.6% | 7666.4 ± 0.6% | 3453.3 ± 0.5% | 467.2 ± 3.4% | 5532.3 ± 5.8% | 780.1 ± 3.4% | 4.319 | 9.588 | 70.871 | 5.985 | 42.445 |
| hex: http/css-1kx1024 | 2099200 | 16629.6 ± 0.7% | 6599.8 ± 0.1% | 3221.3 ± 0.5% | 499.1 ± 0.3% | 4733.5 ± 0.4% | 731.2 ± 1.9% | 2.520 | 5.162 | 33.318 | 3.513 | 22.744 |
| hex: http/css-16kx64 | 2097280 | 30604.5 ± 1.1% | 7662.2 ± 0.9% | 3502.1 ± 0.4% | 508.3 ± 0.6% | 5428.9 ± 0.4% | 806.8 ± 4.3% | 3.994 | 8.739 | 60.213 | 5.637 | 37.931 |
| hex: http/css-1m | 524290 | 33326.4 ± 0.7% | 7643.7 ± 3.9% | 3434.0 ± 1.4% | 500.8 ± 0.9% | 5534.6 ± 0.2% | 777.4 ± 6.8% | 4.360 | 9.705 | 66.540 | 6.021 | 42.869 |
| hex: shuffled/dickens-1m | 524290 | 33531.7 ± 0.5% | 7682.2 ± 0.4% | 3447.1 ± 0.9% | 445.3 ± 0.4% | 5515.5 ± 1.1% | 757.9 ± 3.8% | 4.365 | 9.727 | 75.303 | 6.080 | 44.241 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 963.2 ± 1.1% | 982.6 ± 1.3% | 973.2 ± 0.4% | 261.7 ± 19.4% | 527.6 ± 14.8% | 259.5 ± 4.2% | 0.980 | 0.990 | 3.680 | 1.826 | 3.712 |
| qlog records, JSON text sequence | 1467503 | 819.9 ± 0.3% | 797.0 ± 0.4% | 785.8 ± 2.0% | 229.7 ± 0.7% | 588.8 ± 13.7% | 246.9 ± 1.9% | 1.029 | 1.043 | 3.569 | 1.392 | 3.320 |
| messages: 11 string members | 1025025 | 914.7 ± 0.6% | 1119.3 ± 0.4% | 667.3 ± 2.6% | 261.8 ± 1.8% | 451.9 ± 1.4% | 245.6 ± 2.4% | 0.817 | 1.371 | 3.494 | 2.024 | 3.724 |
| messages: 50 nested objects | 1121600 | 1061.9 ± 1.6% | 995.7 ± 0.4% | 1091.9 ± 4.4% | 281.6 ± 1.3% | 689.7 ± 0.2% | 330.3 ± 0.7% | 1.067 | 0.973 | 3.771 | 1.540 | 3.214 |
| messages: a tree of 341 objects | 612600 | 406.9 ± 1.6% | 444.6 ± 0.5% | 505.0 ± 1.0% | 123.6 ± 0.2% | 453.2 ± 2.2% | 146.6 ± 0.7% | 0.915 | 0.806 | 3.293 | 0.898 | 2.776 |
| string: silesia/dickens | 172528 | 6170.9 ± 0.5% | 2883.5 ± 1.0% | 2058.7 ± 2.6% | 290.5 ± 3.6% | 2184.3 ± 4.3% | 495.8 ± 7.1% | 2.140 | 2.997 | 21.239 | 2.825 | 12.447 |
| string: silesia/nci | 1075110 | 5121.1 ± 0.2% | 3469.2 ± 0.2% | 2833.7 ± 23.7% | 467.5 ± 2.0% | 2364.4 ± 1.0% | 526.4 ± 0.9% | 1.476 | 1.807 | 10.954 | 2.166 | 9.729 |
| string: silesia/reymont | 1075159 | 3293.1 ± 0.2% | 2183.3 ± 0.6% | 1766.2 ± 3.7% | 302.8 ± 0.6% | 1634.5 ± 1.0% | 476.3 ± 2.2% | 1.508 | 1.864 | 10.877 | 2.015 | 6.914 |
| string: silesia/samba | 97582 | 3345.5 ± 2.1% | 2864.0 ± 4.9% | 1574.8 ± 8.4% | 253.3 ± 0.3% | 1279.5 ± 0.5% | 355.9 ± 1.5% | 1.168 | 2.124 | 13.209 | 2.615 | 9.401 |
| string: silesia/webster | 1098490 | 4112.4 ± 3.9% | 2034.5 ± 0.4% | 1630.2 ± 0.9% | 292.9 ± 0.6% | 1674.9 ± 10.6% | 443.4 ± 2.0% | 2.021 | 2.523 | 14.040 | 2.455 | 9.276 |
| string: silesia/xml | 1090118 | 5496.6 ± 0.4% | 3719.8 ± 0.9% | 2144.9 ± 1.1% | 385.1 ± 0.4% | 2367.7 ± 1.3% | 516.2 ± 4.8% | 1.478 | 2.563 | 14.274 | 2.322 | 10.649 |
| string: canterbury/alice29.txt | 159425 | 4902.9 ± 0.5% | 2404.3 ± 2.5% | 1816.4 ± 1.7% | 274.5 ± 1.3% | 1933.4 ± 22.3% | 454.6 ± 3.4% | 2.039 | 2.699 | 17.864 | 2.536 | 10.784 |
| string: canterbury/asyoulik.txt | 132198 | 3585.0 ± 1.2% | 2103.7 ± 0.8% | 1473.7 ± 13.5% | 264.8 ± 0.4% | 1600.0 ± 2.3% | 405.8 ± 0.9% | 1.704 | 2.433 | 13.541 | 2.241 | 8.835 |
| string: canterbury/lcet10.txt | 441884 | 6121.7 ± 0.3% | 2790.7 ± 0.3% | 1984.1 ± 0.3% | 313.0 ± 0.4% | 2141.9 ± 0.7% | 491.1 ± 2.0% | 2.194 | 3.085 | 19.558 | 2.858 | 12.467 |
| string: canterbury/plrabn12.txt | 503330 | 4734.1 ± 0.3% | 2687.7 ± 2.9% | 1679.1 ± 3.4% | 286.7 ± 0.7% | 2015.7 ± 0.5% | 462.5 ± 18.2% | 1.761 | 2.819 | 16.512 | 2.349 | 10.237 |
| string: canterbury-large/E.coli | 1048578 | 33519.8 ± 0.7% | 7624.6 ± 0.7% | 3418.7 ± 5.6% | 871.8 ± 0.2% | 5524.4 ± 0.2% | 810.3 ± 1.0% | 4.396 | 9.805 | 38.447 | 6.068 | 41.365 |
| string: canterbury-large/bible.txt | 1055886 | 9653.0 ± 0.9% | 3914.1 ± 0.8% | 2532.3 ± 1.0% | 336.0 ± 0.2% | 2968.6 ± 9.3% | 603.6 ± 4.9% | 2.466 | 3.812 | 28.732 | 3.252 | 15.992 |
| string: canterbury-large/world192.txt | 1103121 | 3785.2 ± 0.2% | 1984.1 ± 0.5% | 1636.4 ± 0.5% | 286.6 ± 1.3% | 1686.1 ± 1.4% | 435.8 ± 0.7% | 1.908 | 2.313 | 13.209 | 2.245 | 8.686 |
| string: http/html-1m | 1058582 | 7934.7 ± 0.6% | 3400.3 ± 0.3% | 2398.7 ± 1.8% | 380.0 ± 1.8% | 2737.4 ± 0.5% | 428.9 ± 1.2% | 2.334 | 3.308 | 20.879 | 2.899 | 18.501 |
| string: http/json-1m | 1190272 | 3317.8 ± 6.0% | 1198.6 ± 0.2% | 1416.4 ± 6.1% | 335.1 ± 7.6% | 849.4 ± 0.5% | 297.4 ± 0.5% | 2.768 | 2.342 | 9.901 | 3.906 | 11.155 |
| string: http/js-1m | 1144362 | 2667.6 ± 0.6% | 1324.7 ± 0.5% | 1156.4 ± 9.4% | 267.0 ± 0.4% | 1171.8 ± 1.1% | 297.6 ± 0.6% | 2.014 | 2.307 | 9.990 | 2.277 | 8.965 |
| string: http/css-1m | 1097820 | 3033.4 ± 0.6% | 2505.7 ± 0.7% | 1550.8 ± 1.1% | 350.9 ± 0.3% | 1514.1 ± 0.6% | 337.7 ± 1.1% | 1.211 | 1.956 | 8.643 | 2.003 | 8.983 |
| string: dickens as Cyrillic and CJK | 1883069 | 5359.5 ± 0.2% | 3170.3 ± 0.7% | 652.1 ± 0.2% | 266.7 ± 1.9% | 496.5 ± 1.1% | 138.1 ± 1.5% | 1.690 | 8.218 | 20.092 | 10.794 | 38.802 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1064.6 ± 8.8% | 1078.2 ± 2.7% | 830.8 ± 0.3% | 159.7 ± 1.8% | 380.7 ± 1.0% | 202.0 ± 3.7% | 0.987 | 1.281 | 6.665 | 2.796 | 5.271 |
| hex: silesia/dickens | 524290 | 33167.0 ± 1.2% | 7654.6 ± 2.1% | 3460.5 ± 0.3% | 444.9 ± 0.4% | 5511.9 ± 0.6% | 823.0 ± 2.8% | 4.333 | 9.584 | 74.550 | 6.017 | 40.299 |
| hex: silesia/mozilla | 524290 | 33267.4 ± 1.0% | 7653.9 ± 1.2% | 3441.6 ± 2.6% | 392.7 ± 4.1% | 5515.9 ± 0.4% | 818.3 ± 2.6% | 4.346 | 9.666 | 84.718 | 6.031 | 40.654 |
| hex: silesia/mr | 524290 | 33307.9 ± 7.9% | 7672.7 ± 1.2% | 3457.1 ± 0.7% | 562.6 ± 0.6% | 5529.8 ± 0.3% | 819.0 ± 1.8% | 4.341 | 9.635 | 59.209 | 6.023 | 40.669 |
| hex: silesia/nci | 524290 | 33443.5 ± 1.6% | 7679.4 ± 1.2% | 3452.8 ± 0.5% | 632.6 ± 0.4% | 5509.9 ± 0.3% | 822.6 ± 2.0% | 4.355 | 9.686 | 52.869 | 6.070 | 40.655 |
| hex: silesia/ooffice | 524290 | 33278.3 ± 0.8% | 7660.7 ± 0.7% | 3450.8 ± 0.3% | 337.1 ± 0.4% | 5497.1 ± 9.5% | 829.7 ± 0.6% | 4.344 | 9.644 | 98.714 | 6.054 | 40.108 |
| hex: silesia/osdb | 524290 | 33313.2 ± 0.8% | 7680.6 ± 0.3% | 3467.0 ± 0.6% | 433.1 ± 0.6% | 5521.2 ± 1.4% | 822.4 ± 1.4% | 4.337 | 9.609 | 76.921 | 6.034 | 40.508 |
| hex: silesia/reymont | 524290 | 33344.3 ± 0.3% | 7679.9 ± 1.2% | 3451.5 ± 1.6% | 464.8 ± 1.9% | 5521.8 ± 3.2% | 824.2 ± 1.5% | 4.342 | 9.661 | 71.739 | 6.039 | 40.458 |
| hex: silesia/samba | 524290 | 33541.9 ± 1.0% | 7680.1 ± 0.5% | 3454.0 ± 1.0% | 342.9 ± 0.3% | 5522.6 ± 0.2% | 825.0 ± 0.7% | 4.367 | 9.711 | 97.811 | 6.074 | 40.659 |
| hex: silesia/sao | 524290 | 32881.0 ± 3.0% | 7676.7 ± 4.1% | 3462.1 ± 0.6% | 273.2 ± 0.2% | 5531.3 ± 0.4% | 817.2 ± 10.1% | 4.283 | 9.497 | 120.363 | 5.944 | 40.236 |
| hex: silesia/webster | 524290 | 33500.9 ± 2.2% | 7668.6 ± 0.8% | 3464.5 ± 0.6% | 405.7 ± 0.7% | 5530.6 ± 0.3% | 826.4 ± 1.9% | 4.369 | 9.670 | 82.573 | 6.057 | 40.537 |
| hex: silesia/x-ray | 524290 | 33540.8 ± 0.5% | 7648.0 ± 1.2% | 3460.5 ± 1.0% | 407.8 ± 0.3% | 5523.2 ± 0.5% | 818.3 ± 2.2% | 4.386 | 9.692 | 82.239 | 6.073 | 40.987 |
| hex: silesia/xml | 524290 | 33250.1 ± 0.2% | 7688.9 ± 0.3% | 3452.4 ± 0.4% | 567.0 ± 0.2% | 5496.6 ± 0.6% | 823.8 ± 0.5% | 4.324 | 9.631 | 58.643 | 6.049 | 40.361 |
| hex: canterbury/alice29.txt | 304180 | 33728.2 ± 0.6% | 7753.9 ± 1.3% | 3562.1 ± 0.5% | 444.6 ± 0.4% | 5531.5 ± 1.1% | 825.8 ± 0.8% | 4.350 | 9.469 | 75.854 | 6.097 | 40.843 |
| hex: canterbury/asyoulik.txt | 250360 | 33737.0 ± 0.3% | 7780.7 ± 3.7% | 3553.9 ± 4.4% | 434.5 ± 0.3% | 5521.0 ± 0.3% | 831.8 ± 1.9% | 4.336 | 9.493 | 77.643 | 6.111 | 40.557 |
| hex: canterbury/cp.html | 49208 | 32687.8 ± 1.9% | 7773.1 ± 0.2% | 3605.9 ± 1.0% | 431.2 ± 0.5% | 5472.0 ± 0.7% | 807.8 ± 8.0% | 4.205 | 9.065 | 75.803 | 5.974 | 40.465 |
| hex: canterbury/fields.c | 22302 | 31461.0 ± 1.0% | 7693.0 ± 0.1% | 3611.5 ± 0.2% | 459.5 ± 1.1% | 5470.6 ± 0.4% | 794.5 ± 4.0% | 4.090 | 8.711 | 68.468 | 5.751 | 39.599 |
| hex: canterbury/grammar.lsp | 7444 | 27366.7 ± 0.4% | 7458.1 ± 0.4% | 3575.1 ± 0.2% | 518.1 ± 16.0% | 5356.4 ± 0.1% | 774.8 ± 2.8% | 3.669 | 7.655 | 52.825 | 5.109 | 35.321 |
| hex: canterbury/kennedy.xls | 524290 | 33242.7 ± 2.0% | 7710.8 ± 0.7% | 3451.9 ± 1.1% | 667.4 ± 0.2% | 5531.2 ± 1.3% | 773.2 ± 7.4% | 4.311 | 9.630 | 49.811 | 6.010 | 42.993 |
| hex: canterbury/lcet10.txt | 524290 | 33372.1 ± 0.7% | 7687.7 ± 1.1% | 3466.2 ± 3.9% | 447.2 ± 6.3% | 5530.6 ± 0.4% | 793.2 ± 5.7% | 4.341 | 9.628 | 74.631 | 6.034 | 42.072 |
| hex: canterbury/plrabn12.txt | 524290 | 33548.4 ± 0.4% | 7698.2 ± 0.6% | 3450.4 ± 1.0% | 434.2 ± 0.4% | 5522.6 ± 0.4% | 799.0 ± 2.5% | 4.358 | 9.723 | 77.270 | 6.075 | 41.990 |
| hex: canterbury/ptt5 | 524290 | 33202.7 ± 0.7% | 7682.9 ± 1.0% | 3467.3 ± 0.4% | 558.9 ± 0.4% | 5518.3 ± 0.1% | 798.2 ± 1.6% | 4.322 | 9.576 | 59.406 | 6.017 | 41.596 |
| hex: canterbury/sum | 76482 | 33247.5 ± 3.3% | 7800.1 ± 0.1% | 3603.1 ± 0.3% | 498.5 ± 0.2% | 5501.5 ± 1.1% | 829.3 ± 5.4% | 4.262 | 9.227 | 66.692 | 6.043 | 40.093 |
| hex: canterbury/xargs.1 | 8456 | 27914.5 ± 0.7% | 7514.7 ± 0.2% | 3508.3 ± 0.3% | 488.3 ± 0.6% | 5359.5 ± 0.4% | 816.7 ± 1.4% | 3.715 | 7.957 | 57.163 | 5.208 | 34.182 |
| hex: canterbury-large/E.coli | 524290 | 33560.0 ± 1.4% | 7697.1 ± 0.8% | 3458.8 ± 0.9% | 711.5 ± 1.0% | 5529.1 ± 0.2% | 765.7 ± 3.0% | 4.360 | 9.703 | 47.168 | 6.070 | 43.827 |
| hex: canterbury-large/bible.txt | 524290 | 33434.5 ± 0.3% | 7703.1 ± 0.5% | 3461.9 ± 0.3% | 464.5 ± 0.7% | 5522.1 ± 0.2% | 769.4 ± 9.9% | 4.340 | 9.658 | 71.987 | 6.055 | 43.456 |
| hex: canterbury-large/world192.txt | 524290 | 33589.8 ± 0.8% | 7659.6 ± 4.8% | 3456.8 ± 1.0% | 429.8 ± 0.1% | 5532.8 ± 0.1% | 755.5 ± 7.4% | 4.385 | 9.717 | 78.151 | 6.071 | 44.459 |
| hex: http/html-1kx1024 | 2099200 | 16735.6 ± 1.4% | 6625.1 ± 0.4% | 3213.7 ± 2.2% | 454.0 ± 0.9% | 4733.8 ± 0.6% | 714.5 ± 2.4% | 2.526 | 5.208 | 36.860 | 3.535 | 23.423 |
| hex: http/html-16kx64 | 2097280 | 30747.1 ± 2.5% | 7678.1 ± 0.6% | 3529.2 ± 0.1% | 460.1 ± 0.9% | 5427.2 ± 0.4% | 794.3 ± 4.7% | 4.005 | 8.712 | 66.830 | 5.665 | 38.710 |
| hex: http/html-1m | 524290 | 33521.5 ± 0.3% | 7702.3 ± 1.6% | 3443.1 ± 0.8% | 461.3 ± 0.4% | 5524.0 ± 0.4% | 771.1 ± 4.6% | 4.352 | 9.736 | 72.667 | 6.068 | 43.473 |
| hex: http/json-1kx1024 | 2099200 | 16728.9 ± 1.1% | 6588.7 ± 1.4% | 3225.5 ± 0.4% | 574.4 ± 0.3% | 4727.5 ± 0.7% | 723.6 ± 7.3% | 2.539 | 5.186 | 29.125 | 3.539 | 23.119 |
| hex: http/json-16kx64 | 2097280 | 30688.2 ± 0.3% | 7671.9 ± 0.6% | 3520.1 ± 8.5% | 585.0 ± 1.3% | 5425.1 ± 0.7% | 794.4 ± 4.6% | 4.000 | 8.718 | 52.455 | 5.657 | 38.631 |
| hex: http/json-1m | 524290 | 33132.1 ± 1.1% | 7701.6 ± 0.6% | 3463.1 ± 0.3% | 604.1 ± 4.0% | 5509.0 ± 0.6% | 773.0 ± 4.3% | 4.302 | 9.567 | 54.843 | 6.014 | 42.862 |
| hex: http/js-1kx1024 | 2099200 | 16729.8 ± 1.2% | 6604.0 ± 0.2% | 3220.6 ± 0.3% | 444.1 ± 0.5% | 4733.2 ± 0.3% | 720.0 ± 4.8% | 2.533 | 5.195 | 37.674 | 3.535 | 23.236 |
| hex: http/js-16kx64 | 2097280 | 30642.0 ± 0.7% | 7666.7 ± 0.7% | 3518.2 ± 0.7% | 449.3 ± 0.4% | 5418.0 ± 4.1% | 806.2 ± 6.0% | 3.997 | 8.710 | 68.202 | 5.656 | 38.006 |
| hex: http/js-1m | 524290 | 33297.4 ± 7.4% | 7666.4 ± 0.6% | 3453.3 ± 0.5% | 467.2 ± 3.4% | 5532.3 ± 5.8% | 780.1 ± 3.4% | 4.343 | 9.642 | 71.269 | 6.019 | 42.684 |
| hex: http/css-1kx1024 | 2099200 | 16686.8 ± 13.7% | 6599.8 ± 0.1% | 3221.3 ± 0.5% | 499.1 ± 0.3% | 4733.5 ± 0.4% | 731.2 ± 1.9% | 2.528 | 5.180 | 33.433 | 3.525 | 22.822 |
| hex: http/css-16kx64 | 2097280 | 30726.2 ± 0.6% | 7662.2 ± 0.9% | 3502.1 ± 0.4% | 508.3 ± 0.6% | 5428.9 ± 0.4% | 806.8 ± 4.3% | 4.010 | 8.774 | 60.453 | 5.660 | 38.082 |
| hex: http/css-1m | 524290 | 33152.7 ± 3.3% | 7643.7 ± 3.9% | 3434.0 ± 1.4% | 500.8 ± 0.9% | 5534.6 ± 0.2% | 777.4 ± 6.8% | 4.337 | 9.654 | 66.193 | 5.990 | 42.646 |
| hex: shuffled/dickens-1m | 524290 | 33482.3 ± 1.3% | 7682.2 ± 0.4% | 3447.1 ± 0.9% | 445.3 ± 0.4% | 5515.5 ± 1.1% | 757.9 ± 3.8% | 4.358 | 9.713 | 75.192 | 6.071 | 44.176 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1135.3 ± 1.0% | 1141.2 ± 1.1% | 899.1 ± 0.8% | 328.0 ± 6.4% | 350.3 ± 1.7% | 314.9 ± 17.3% | 0.995 | 1.263 | 3.461 | 3.241 | 3.606 |
| qlog records, JSON text sequence | 1467503 | 968.1 ± 1.2% | 872.0 ± 10.7% | 723.3 ± 0.6% | 317.5 ± 0.8% | 384.8 ± 7.7% | 230.8 ± 17.0% | 1.110 | 1.339 | 3.049 | 2.516 | 4.195 |
| messages: 11 string members | 1025025 | 1136.2 ± 0.9% | 892.8 ± 1.9% | 663.6 ± 1.0% | 308.3 ± 2.4% | 323.1 ± 1.3% | 284.6 ± 2.1% | 1.273 | 1.712 | 3.685 | 3.517 | 3.992 |
| messages: 50 nested objects | 1121600 | 1118.0 ± 0.9% | 1214.6 ± 2.9% | 997.3 ± 2.1% | 396.7 ± 0.8% | 433.8 ± 0.6% | 327.2 ± 1.8% | 0.921 | 1.121 | 2.818 | 2.577 | 3.417 |
| messages: a tree of 341 objects | 612600 | 463.5 ± 14.3% | 608.2 ± 1.4% | 411.6 ± 0.8% | 205.2 ± 2.0% | 270.9 ± 2.8% | 129.2 ± 1.6% | 0.762 | 1.126 | 2.258 | 1.711 | 3.588 |
| string: silesia/dickens | 172528 | 8572.0 ± 6.3% | 3027.3 ± 3.1% | 2028.4 ± 0.2% | 360.9 ± 1.4% | 1051.5 ± 1.5% | 561.7 ± 0.2% | 2.832 | 4.226 | 23.752 | 8.152 | 15.260 |
| string: silesia/nci | 1075110 | 8104.7 ± 2.4% | 3235.4 ± 0.9% | 2783.8 ± 0.2% | 775.0 ± 1.8% | 1094.5 ± 1.9% | 562.3 ± 0.7% | 2.505 | 2.911 | 10.457 | 7.405 | 14.414 |
| string: silesia/reymont | 1075159 | 3826.5 ± 0.1% | 1646.0 ± 0.7% | 1721.9 ± 0.4% | 368.7 ± 0.3% | 961.6 ± 0.4% | 550.6 ± 1.0% | 2.325 | 2.222 | 10.379 | 3.979 | 6.950 |
| string: silesia/samba | 97582 | 4556.5 ± 0.3% | 1987.3 ± 4.3% | 2157.3 ± 0.4% | 297.5 ± 0.4% | 895.0 ± 0.3% | 621.5 ± 2.3% | 2.293 | 2.112 | 15.317 | 5.091 | 7.332 |
| string: silesia/webster | 1098490 | 5021.4 ± 1.6% | 1645.2 ± 0.8% | 1514.3 ± 1.2% | 358.9 ± 1.1% | 939.2 ± 1.6% | 455.1 ± 0.5% | 3.052 | 3.316 | 13.989 | 5.347 | 11.034 |
| string: silesia/xml | 1090118 | 7721.8 ± 8.4% | 2682.3 ± 0.7% | 2151.3 ± 1.9% | 527.9 ± 0.3% | 1123.2 ± 0.4% | 561.6 ± 0.5% | 2.879 | 3.589 | 14.626 | 6.875 | 13.750 |
| string: canterbury/alice29.txt | 159425 | 9301.2 ± 0.6% | 2429.8 ± 2.5% | 1790.8 ± 1.0% | 342.5 ± 1.6% | 1025.4 ± 1.3% | 556.2 ± 0.2% | 3.828 | 5.194 | 27.153 | 9.071 | 16.723 |
| string: canterbury/asyoulik.txt | 132198 | 7375.7 ± 7.7% | 2086.1 ± 23.4% | 1523.9 ± 0.4% | 347.2 ± 1.0% | 908.0 ± 13.9% | 543.6 ± 0.9% | 3.536 | 4.840 | 21.246 | 8.123 | 13.569 |
| string: canterbury/lcet10.txt | 441884 | 8479.2 ± 14.2% | 2476.0 ± 0.6% | 1973.9 ± 0.9% | 397.0 ± 0.5% | 1037.7 ± 0.4% | 554.5 ± 8.0% | 3.425 | 4.296 | 21.359 | 8.171 | 15.290 |
| string: canterbury/plrabn12.txt | 503330 | 5899.6 ± 1.1% | 1847.4 ± 0.8% | 1662.7 ± 1.4% | 369.8 ± 1.0% | 1007.7 ± 2.3% | 560.1 ± 1.7% | 3.194 | 3.548 | 15.953 | 5.855 | 10.532 |
| string: canterbury-large/E.coli | 1048578 | 29225.6 ± 6.0% | 10401.3 ± 2.9% | 3379.9 ± 1.3% | 1417.6 ± 2.2% | 1418.6 ± 0.9% | 580.5 ± 0.9% | 2.810 | 8.647 | 20.616 | 20.601 | 50.344 |
| string: canterbury-large/bible.txt | 1055886 | 7002.6 ± 0.4% | 3983.5 ± 2.1% | 2651.5 ± 3.2% | 441.5 ± 1.0% | 1214.2 ± 1.2% | 569.1 ± 0.2% | 1.758 | 2.641 | 15.860 | 5.767 | 12.305 |
| string: canterbury-large/world192.txt | 1103121 | 4795.6 ± 6.7% | 1454.7 ± 0.5% | 1569.7 ± 7.6% | 365.3 ± 0.6% | 932.2 ± 0.7% | 540.1 ± 0.8% | 3.297 | 3.055 | 13.129 | 5.145 | 8.879 |
| string: http/html-1m | 1058582 | 8499.2 ± 0.9% | 3890.3 ± 0.8% | 2475.2 ± 11.5% | 446.5 ± 0.6% | 1189.5 ± 1.2% | 522.5 ± 0.2% | 2.185 | 3.434 | 19.034 | 7.145 | 16.265 |
| string: http/json-1m | 1190272 | 6337.1 ± 1.2% | 1233.1 ± 0.6% | 1267.5 ± 0.6% | 413.8 ± 0.6% | 782.9 ± 0.4% | 512.8 ± 2.5% | 5.139 | 5.000 | 15.313 | 8.095 | 12.359 |
| string: http/js-1m | 1144362 | 5053.6 ± 1.0% | 996.1 ± 1.0% | 1084.2 ± 10.5% | 304.4 ± 11.6% | 786.9 ± 0.2% | 475.2 ± 0.8% | 5.073 | 4.661 | 16.600 | 6.422 | 10.635 |
| string: http/css-1m | 1097820 | 6570.6 ± 1.5% | 1296.6 ± 1.1% | 1597.3 ± 5.6% | 439.5 ± 3.0% | 855.5 ± 2.1% | 530.2 ± 1.0% | 5.067 | 4.114 | 14.950 | 7.680 | 12.392 |
| string: dickens as Cyrillic and CJK | 1883069 | 5334.4 ± 14.0% | 3025.7 ± 0.3% | 342.1 ± 1.3% | 275.7 ± 0.3% | 400.4 ± 0.7% | 292.9 ± 0.5% | 1.763 | 15.595 | 19.351 | 13.324 | 18.214 |
| hex: silesia/dickens | 524290 | 30874.5 ± 0.3% | 1549.0 ± 0.4% | 1088.9 ± 0.4% | 427.3 ± 1.3% | 792.3 ± 0.3% | 451.1 ± 0.2% | 19.932 | 28.354 | 72.255 | 38.967 | 68.448 |
| hex: silesia/mozilla | 524290 | 34570.2 ± 1.2% | 1555.3 ± 0.4% | 1087.7 ± 0.1% | 372.6 ± 0.3% | 795.7 ± 0.2% | 451.3 ± 1.3% | 22.228 | 31.782 | 92.789 | 43.444 | 76.598 |
| hex: silesia/mr | 524290 | 34913.7 ± 0.5% | 1548.9 ± 0.5% | 1085.9 ± 0.4% | 510.2 ± 14.5% | 794.6 ± 1.5% | 451.1 ± 7.5% | 22.541 | 32.151 | 68.436 | 43.940 | 77.404 |
| hex: silesia/nci | 524290 | 35252.3 ± 0.2% | 1555.3 ± 0.6% | 1086.9 ± 1.5% | 583.1 ± 0.2% | 798.4 ± 1.2% | 450.6 ± 0.5% | 22.665 | 32.435 | 60.459 | 44.156 | 78.235 |
| hex: silesia/ooffice | 524290 | 33786.9 ± 0.7% | 1547.9 ± 1.3% | 1087.3 ± 0.2% | 329.1 ± 0.3% | 795.0 ± 3.4% | 451.9 ± 0.8% | 21.827 | 31.075 | 102.666 | 42.498 | 74.770 |
| hex: silesia/osdb | 524290 | 32598.9 ± 0.6% | 1549.0 ± 1.0% | 1087.5 ± 0.4% | 414.9 ± 1.3% | 796.7 ± 0.7% | 448.6 ± 0.7% | 21.045 | 29.977 | 78.567 | 40.920 | 72.665 |
| hex: silesia/reymont | 524290 | 33692.8 ± 0.4% | 1551.4 ± 1.0% | 1087.1 ± 0.9% | 444.8 ± 0.5% | 793.0 ± 1.3% | 449.3 ± 0.9% | 21.717 | 30.993 | 75.748 | 42.487 | 74.989 |
| hex: silesia/samba | 524290 | 36355.9 ± 0.7% | 1555.2 ± 0.7% | 1085.1 ± 1.3% | 334.6 ± 0.3% | 798.9 ± 2.2% | 450.9 ± 4.1% | 23.378 | 33.504 | 108.669 | 45.510 | 80.622 |
| hex: silesia/sao | 524290 | 34075.9 ± 0.4% | 1556.7 ± 0.5% | 1089.4 ± 0.3% | 268.8 ± 0.8% | 797.4 ± 1.5% | 451.3 ± 0.7% | 21.889 | 31.279 | 126.756 | 42.732 | 75.511 |
| hex: silesia/webster | 524290 | 35752.7 ± 0.6% | 1557.9 ± 0.7% | 1089.6 ± 0.4% | 408.1 ± 0.9% | 800.1 ± 0.3% | 450.0 ± 1.5% | 22.949 | 32.814 | 87.615 | 44.686 | 79.451 |
| hex: silesia/x-ray | 524290 | 34242.7 ± 18.2% | 1555.7 ± 1.5% | 1089.4 ± 0.3% | 399.1 ± 0.3% | 798.3 ± 0.6% | 451.3 ± 4.4% | 22.011 | 31.431 | 85.791 | 42.895 | 75.877 |
| hex: silesia/xml | 524290 | 34830.5 ± 0.5% | 1556.6 ± 1.0% | 1086.4 ± 9.3% | 584.3 ± 0.4% | 798.4 ± 1.3% | 450.2 ± 1.1% | 22.377 | 32.062 | 59.607 | 43.627 | 77.360 |
| hex: canterbury/alice29.txt | 304180 | 33598.4 ± 0.5% | 1598.9 ± 0.4% | 1099.4 ± 2.3% | 430.6 ± 0.4% | 807.6 ± 0.4% | 455.1 ± 0.7% | 21.014 | 30.561 | 78.022 | 41.605 | 73.828 |
| hex: canterbury/asyoulik.txt | 250360 | 32079.5 ± 0.5% | 1604.1 ± 0.7% | 1099.8 ± 0.3% | 422.9 ± 0.5% | 808.7 ± 0.9% | 454.9 ± 0.5% | 19.998 | 29.168 | 75.860 | 39.666 | 70.512 |
| hex: canterbury/cp.html | 49208 | 31917.7 ± 0.3% | 1622.1 ± 0.3% | 1110.8 ± 0.9% | 465.9 ± 0.4% | 813.1 ± 0.3% | 456.4 ± 0.2% | 19.677 | 28.733 | 68.502 | 39.256 | 69.933 |
| hex: canterbury/fields.c | 22302 | 32298.1 ± 8.9% | 1595.3 ± 1.5% | 1100.8 ± 7.0% | 543.4 ± 0.3% | 807.5 ± 0.4% | 455.6 ± 0.3% | 20.246 | 29.341 | 59.433 | 39.998 | 70.890 |
| hex: canterbury/grammar.lsp | 7444 | 32731.3 ± 0.6% | 1633.8 ± 0.7% | 1117.8 ± 0.2% | 562.7 ± 0.9% | 811.8 ± 1.2% | 461.6 ± 0.2% | 20.034 | 29.281 | 58.172 | 40.322 | 70.910 |
| hex: canterbury/kennedy.xls | 524290 | 31040.9 ± 0.4% | 1554.0 ± 0.7% | 1087.3 ± 1.9% | 594.8 ± 14.8% | 794.3 ± 1.3% | 452.5 ± 0.5% | 19.975 | 28.549 | 52.191 | 39.080 | 68.604 |
| hex: canterbury/lcet10.txt | 524290 | 35657.5 ± 0.8% | 1550.8 ± 8.5% | 1087.0 ± 0.2% | 431.1 ± 0.2% | 795.8 ± 1.4% | 451.2 ± 0.8% | 22.993 | 32.803 | 82.704 | 44.805 | 79.022 |
| hex: canterbury/plrabn12.txt | 524290 | 34910.9 ± 1.5% | 1559.9 ± 1.6% | 1085.6 ± 5.7% | 421.0 ± 0.4% | 795.4 ± 23.3% | 451.3 ± 0.8% | 22.381 | 32.159 | 82.926 | 43.889 | 77.359 |
| hex: canterbury/ptt5 | 524290 | 34293.2 ± 0.5% | 1552.7 ± 7.8% | 1088.6 ± 0.4% | 500.3 ± 0.1% | 794.6 ± 0.2% | 450.3 ± 1.4% | 22.086 | 31.502 | 68.550 | 43.155 | 76.151 |
| hex: canterbury/sum | 76482 | 35245.8 ± 0.5% | 1614.4 ± 2.0% | 1108.0 ± 0.6% | 522.1 ± 0.8% | 810.5 ± 0.2% | 458.5 ± 0.5% | 21.833 | 31.811 | 67.511 | 43.485 | 76.875 |
| hex: canterbury/xargs.1 | 8456 | 35543.3 ± 11.3% | 1628.1 ± 0.4% | 1111.7 ± 0.6% | 598.5 ± 0.3% | 814.5 ± 0.1% | 461.8 ± 0.7% | 21.831 | 31.972 | 59.385 | 43.640 | 76.970 |
| hex: canterbury-large/E.coli | 524290 | 30407.8 ± 0.6% | 1551.3 ± 0.8% | 1086.9 ± 0.5% | 607.5 ± 1.3% | 797.2 ± 0.5% | 452.2 ± 0.8% | 19.601 | 27.978 | 50.052 | 38.143 | 67.247 |
| hex: canterbury-large/bible.txt | 524290 | 35040.0 ± 12.9% | 1556.1 ± 7.1% | 1086.7 ± 0.4% | 444.0 ± 0.8% | 795.9 ± 0.3% | 451.9 ± 3.1% | 22.518 | 32.244 | 78.916 | 44.026 | 77.534 |
| hex: canterbury-large/world192.txt | 524290 | 33475.3 ± 0.7% | 1552.1 ± 8.2% | 1087.8 ± 0.6% | 421.7 ± 0.5% | 797.6 ± 0.3% | 451.7 ± 0.4% | 21.568 | 30.774 | 79.376 | 41.970 | 74.104 |
| hex: http/html-1kx1024 | 2099200 | 24466.8 ± 2.4% | 1610.3 ± 0.6% | 1089.7 ± 0.9% | 458.4 ± 2.9% | 806.8 ± 13.3% | 453.7 ± 0.7% | 15.194 | 22.453 | 53.377 | 30.326 | 53.924 |
| hex: http/html-16kx64 | 2097280 | 30188.9 ± 0.6% | 1609.5 ± 1.1% | 1104.3 ± 0.2% | 449.2 ± 0.6% | 767.1 ± 1.5% | 452.8 ± 3.6% | 18.757 | 27.338 | 67.210 | 39.353 | 66.674 |
| hex: http/html-1m | 524290 | 31445.1 ± 0.4% | 1550.7 ± 1.2% | 1084.8 ± 1.9% | 447.9 ± 0.4% | 790.7 ± 0.6% | 449.4 ± 0.7% | 20.278 | 28.987 | 70.210 | 39.767 | 69.967 |
| hex: http/json-1kx1024 | 2099200 | 24832.0 ± 1.5% | 1607.8 ± 1.1% | 1089.9 ± 0.2% | 564.1 ± 6.1% | 805.4 ± 0.4% | 450.9 ± 4.6% | 15.445 | 22.784 | 44.024 | 30.831 | 55.072 |
| hex: http/json-16kx64 | 2097280 | 30058.2 ± 10.2% | 1607.4 ± 0.4% | 1103.0 ± 1.5% | 557.6 ± 0.3% | 760.9 ± 1.5% | 457.2 ± 1.4% | 18.700 | 27.252 | 53.911 | 39.502 | 65.750 |
| hex: http/json-1m | 524290 | 31090.5 ± 0.6% | 1544.1 ± 8.5% | 1084.1 ± 1.7% | 588.2 ± 0.2% | 782.8 ± 0.5% | 448.7 ± 1.0% | 20.135 | 28.679 | 52.855 | 39.718 | 69.291 |
| hex: http/js-1kx1024 | 2099200 | 24422.5 ± 1.7% | 1609.7 ± 0.2% | 1088.5 ± 0.2% | 445.2 ± 1.8% | 807.4 ± 0.1% | 450.6 ± 0.7% | 15.172 | 22.437 | 54.862 | 30.247 | 54.204 |
| hex: http/js-16kx64 | 2097280 | 30088.0 ± 0.7% | 1606.0 ± 0.5% | 1102.6 ± 3.2% | 448.6 ± 3.1% | 806.5 ± 12.6% | 455.9 ± 2.2% | 18.735 | 27.287 | 67.077 | 37.308 | 65.996 |
| hex: http/js-1m | 524290 | 31099.8 ± 0.6% | 1552.8 ± 1.9% | 1085.6 ± 0.9% | 455.2 ± 0.4% | 795.5 ± 1.0% | 450.4 ± 2.0% | 20.028 | 28.649 | 68.319 | 39.097 | 69.055 |
| hex: http/css-1kx1024 | 2099200 | 24207.1 ± 1.0% | 1610.6 ± 6.8% | 1088.2 ± 0.4% | 500.7 ± 1.4% | 807.3 ± 0.2% | 451.4 ± 2.0% | 15.030 | 22.244 | 48.351 | 29.985 | 53.622 |
| hex: http/css-16kx64 | 2097280 | 30248.5 ± 0.8% | 1608.9 ± 0.2% | 1104.1 ± 1.3% | 502.7 ± 0.6% | 795.2 ± 0.4% | 457.3 ± 5.1% | 18.801 | 27.396 | 60.174 | 38.037 | 66.149 |
| hex: http/css-1m | 524290 | 30745.4 ± 2.4% | 1551.2 ± 0.7% | 1088.2 ± 1.2% | 485.2 ± 0.3% | 789.0 ± 0.5% | 450.8 ± 0.3% | 19.821 | 28.255 | 63.362 | 38.968 | 68.204 |
| hex: shuffled/dickens-1m | 524290 | 33164.4 ± 10.7% | 1558.8 ± 1.2% | 1089.1 ± 1.0% | 431.0 ± 0.7% | 797.1 ± 1.0% | 448.6 ± 3.9% | 21.275 | 30.452 | 76.956 | 41.605 | 73.924 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- messages: 11 string members, decoding: stdx runs at 0.812 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.934 of yyjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.805 of yyjson.
- messages: a tree of 341 objects, encoding: stdx runs at 0.751 of simdjson.
- messages: a tree of 341 objects, encoding with J11's loop unchecked: stdx runs at 0.816 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.855 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.863 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.704 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.929 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.847 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.714 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.628 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.700 of serde_json.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.817 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.915 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.806 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.898 of serde_json.
- messages: 50 nested objects, encoding through TextWriter's methods: stdx runs at 0.921 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.762 of simdjson.
