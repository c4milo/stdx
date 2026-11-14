# bench-json

| Field | Value |
|---|---|
| Commit | 77b711d |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.370.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43464730913 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1021.0 ± 2.2% | 0.473 | 1.010 | 1.066 | 1.039 | 0.415 | 1.082 | 1.083 | 0.366 | 0.815 | 0.961 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 770.8 ± 7.8% | 0.744 | 1.038 | 1.078 | 1.068 | 0.411 | 1.074 | 1.081 | 0.343 | 0.927 | 1.102 | 0.118 |
| string: silesia/dickens | 172528 | 5273.4 ± 0.9% | 0.026 | 0.678 | 1.075 | 1.086 | 0.181 | 1.045 | 1.086 | 0.181 | 1.002 | 0.999 | 0.026 |
| string: silesia/nci | 1075110 | 5179.6 ± 0.2% | 0.027 | 0.686 | 1.017 | 1.018 | 0.231 | 0.990 | 1.017 | 0.231 | 1.009 | 1.008 | 0.027 |
| string: silesia/reymont | 1075159 | 2722.8 ± 3.1% | 0.051 | 0.702 | 0.994 | 0.997 | 0.350 | 0.989 | 0.999 | 0.351 | 1.000 | 0.995 | 0.051 |
| string: silesia/samba | 97582 | 3286.1 ± 1.3% | 0.037 | 0.909 | 1.037 | 1.041 | 0.067 | 0.848 | 1.041 | 0.067 | 1.001 | 1.001 | 0.037 |
| string: silesia/webster | 1098490 | 3566.9 ± 0.1% | 0.038 | 0.688 | 1.055 | 1.075 | 0.199 | 1.042 | 1.075 | 0.199 | 1.001 | 1.004 | 0.038 |
| string: silesia/xml | 1090118 | 4992.3 ± 1.0% | 0.028 | 0.863 | 1.006 | 1.013 | 0.223 | 1.013 | 1.012 | 0.221 | 1.001 | 0.999 | 0.028 |
| string: canterbury/alice29.txt | 159425 | 4276.0 ± 1.1% | 0.032 | 0.796 | 1.069 | 1.146 | 0.172 | 1.090 | 1.148 | 0.173 | 1.003 | 1.004 | 0.032 |
| string: canterbury/asyoulik.txt | 132198 | 3672.6 ± 3.6% | 0.036 | 0.857 | 1.128 | 1.162 | 0.168 | 1.064 | 1.159 | 0.168 | 1.008 | 0.980 | 0.036 |
| string: canterbury/lcet10.txt | 441884 | 5550.0 ± 1.2% | 0.025 | 0.592 | 1.075 | 1.094 | 0.166 | 1.047 | 1.094 | 0.168 | 0.995 | 0.999 | 0.025 |
| string: canterbury/plrabn12.txt | 503330 | 4512.3 ± 1.0% | 0.030 | 0.765 | 1.016 | 1.063 | 0.184 | 0.994 | 1.064 | 0.184 | 1.008 | 1.011 | 0.030 |
| string: canterbury-large/E.coli | 1048578 | 32749.8 ± 2.7% | 0.044 | 1.029 | 0.652 | 1.027 | 0.532 | 1.031 | 1.033 | 0.529 | 1.026 | 1.029 | 0.004 |
| string: canterbury-large/bible.txt | 1055886 | 6545.9 ± 1.3% | 0.022 | 0.696 | 0.917 | 0.912 | 0.405 | 0.994 | 0.912 | 0.404 | 1.001 | 0.999 | 0.022 |
| string: canterbury-large/world192.txt | 1103121 | 3331.1 ± 5.2% | 0.041 | 0.728 | 1.070 | 1.094 | 0.192 | 1.046 | 1.092 | 0.192 | 1.001 | 1.001 | 0.041 |
| string: http/html-1m | 1058582 | 6177.1 ± 5.2% | 0.023 | 0.686 | 0.961 | 0.959 | 0.369 | 0.994 | 0.960 | 0.368 | 1.001 | 1.001 | 0.023 |
| string: http/json-1m | 1190272 | 3312.6 ± 1.3% | 0.038 | 0.382 | 0.433 | 0.436 | 0.094 | 0.393 | 0.436 | 0.094 | 1.006 | 1.003 | 0.038 |
| string: http/js-1m | 1144362 | 2201.7 ± 6.7% | 0.059 | 0.792 | 1.051 | 1.085 | 0.179 | 1.039 | 1.083 | 0.179 | 0.998 | 1.002 | 0.058 |
| string: http/css-1m | 1097820 | 2934.2 ± 0.6% | 0.045 | 0.758 | 1.017 | 1.052 | 0.224 | 1.032 | 1.054 | 0.224 | 1.003 | 1.006 | 0.046 |
| string: dickens as Cyrillic and CJK | 1883069 | 5187.6 ± 1.1% | 0.021 | 0.059 | 0.498 | 0.498 | 0.182 | 0.496 | 0.498 | 0.181 | 1.005 | 1.007 | 0.021 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1055.9 ± 1.1% | 0.093 | 0.976 | 0.977 | 0.978 | 0.089 | 0.709 | 0.978 | 0.089 | 1.004 | 1.006 | 0.093 |
| hex: silesia/dickens | 524290 | 37037.3 ± 6.5% | 0.039 | 1.027 | 0.598 | 1.038 | 0.479 | 1.036 | 1.032 | 0.482 | 0.901 | 0.900 | 0.004 |
| hex: silesia/mozilla | 524290 | 37446.4 ± 2.9% | 0.039 | 1.022 | 0.591 | 1.028 | 0.478 | 1.031 | 1.034 | 0.478 | 0.893 | 0.892 | 0.004 |
| hex: silesia/mr | 524290 | 37474.2 ± 1.2% | 0.039 | 1.018 | 0.594 | 1.017 | 0.480 | 1.018 | 1.026 | 0.478 | 0.890 | 0.890 | 0.004 |
| hex: silesia/nci | 524290 | 35529.1 ± 1.3% | 0.041 | 1.023 | 0.618 | 1.026 | 0.491 | 1.023 | 1.027 | 0.491 | 0.940 | 0.941 | 0.004 |
| hex: silesia/ooffice | 524290 | 37073.4 ± 2.6% | 0.039 | 1.026 | 0.592 | 1.030 | 0.482 | 1.037 | 1.037 | 0.482 | 0.902 | 0.900 | 0.004 |
| hex: silesia/osdb | 524290 | 37312.6 ± 2.7% | 0.039 | 1.035 | 0.597 | 1.035 | 0.482 | 1.046 | 1.040 | 0.479 | 0.896 | 0.892 | 0.004 |
| hex: silesia/reymont | 524290 | 36423.3 ± 1.3% | 0.040 | 1.015 | 0.607 | 1.024 | 0.486 | 1.025 | 1.029 | 0.485 | 0.920 | 0.919 | 0.004 |
| hex: silesia/samba | 524290 | 37470.6 ± 0.9% | 0.039 | 1.028 | 0.593 | 1.033 | 0.477 | 1.030 | 1.032 | 0.476 | 0.895 | 0.892 | 0.004 |
| hex: silesia/sao | 524290 | 37614.5 ± 1.6% | 0.039 | 1.023 | 0.588 | 1.029 | 0.482 | 1.029 | 1.034 | 0.479 | 0.888 | 0.887 | 0.004 |
| hex: silesia/webster | 524290 | 31780.4 ± 1.5% | 0.046 | 1.020 | 0.675 | 1.023 | 0.540 | 1.025 | 1.027 | 0.539 | 1.051 | 1.053 | 0.005 |
| hex: silesia/x-ray | 524290 | 37021.7 ± 1.3% | 0.039 | 1.029 | 0.601 | 1.031 | 0.487 | 1.035 | 1.035 | 0.485 | 0.906 | 0.903 | 0.004 |
| hex: silesia/xml | 524290 | 37540.8 ± 1.6% | 0.039 | 1.019 | 0.592 | 1.024 | 0.476 | 1.025 | 1.029 | 0.474 | 0.894 | 0.896 | 0.004 |
| hex: canterbury/alice29.txt | 304180 | 38462.8 ± 2.5% | 0.038 | 1.024 | 0.583 | 1.027 | 0.470 | 1.034 | 1.034 | 0.471 | 0.873 | 0.877 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 35946.7 ± 2.0% | 0.041 | 1.004 | 0.609 | 1.023 | 0.494 | 1.023 | 1.026 | 0.493 | 0.927 | 0.933 | 0.004 |
| hex: canterbury/cp.html | 49208 | 39764.8 ± 7.6% | 0.036 | 1.006 | 0.552 | 1.009 | 0.458 | 1.010 | 1.011 | 0.462 | 0.820 | 0.824 | 0.004 |
| hex: canterbury/fields.c | 22302 | 35959.4 ± 0.6% | 0.039 | 1.006 | 0.593 | 1.006 | 0.478 | 1.002 | 1.005 | 0.490 | 0.875 | 0.883 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 36687.6 ± 1.8% | 0.038 | 1.012 | 0.529 | 1.018 | 0.408 | 1.013 | 1.016 | 0.442 | 0.747 | 0.756 | 0.004 |
| hex: canterbury/kennedy.xls | 524290 | 29272.0 ± 2.8% | 0.049 | 1.031 | 0.706 | 1.032 | 0.582 | 1.030 | 1.037 | 0.579 | 1.134 | 1.138 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 36655.0 ± 4.9% | 0.039 | 1.040 | 0.605 | 1.042 | 0.478 | 1.048 | 1.046 | 0.478 | 0.909 | 0.909 | 0.004 |
| hex: canterbury/plrabn12.txt | 524290 | 37061.8 ± 2.8% | 0.038 | 1.033 | 0.594 | 1.034 | 0.483 | 1.027 | 1.033 | 0.478 | 0.905 | 0.902 | 0.004 |
| hex: canterbury/ptt5 | 524290 | 37825.6 ± 2.7% | 0.038 | 1.034 | 0.587 | 1.032 | 0.476 | 1.034 | 1.048 | 0.475 | 0.888 | 0.887 | 0.004 |
| hex: canterbury/sum | 76482 | 39571.7 ± 0.4% | 0.035 | 1.004 | 0.563 | 1.008 | 0.467 | 1.010 | 1.007 | 0.469 | 0.839 | 0.841 | 0.004 |
| hex: canterbury/xargs.1 | 8456 | 38335.7 ± 2.7% | 0.035 | 0.986 | 0.518 | 1.012 | 0.414 | 0.985 | 1.004 | 0.441 | 0.731 | 0.740 | 0.004 |
| hex: canterbury-large/E.coli | 524290 | 36695.8 ± 12.2% | 0.039 | 1.032 | 0.600 | 1.049 | 0.486 | 1.039 | 1.054 | 0.484 | 0.913 | 0.910 | 0.004 |
| hex: canterbury-large/bible.txt | 524290 | 37249.6 ± 9.8% | 0.040 | 1.036 | 0.597 | 1.027 | 0.482 | 1.030 | 1.040 | 0.479 | 0.905 | 0.905 | 0.004 |
| hex: canterbury-large/world192.txt | 524290 | 37533.7 ± 1.9% | 0.040 | 1.019 | 0.594 | 1.026 | 0.483 | 1.031 | 1.032 | 0.481 | 0.890 | 0.892 | 0.004 |
| hex: http/html-1kx1024 | 2099200 | 17162.3 ± 2.9% | 0.084 | 1.019 | 0.787 | 1.021 | 0.580 | 1.030 | 1.025 | 0.671 | 0.972 | 0.991 | 0.008 |
| hex: http/html-16kx64 | 2097280 | 34970.8 ± 2.2% | 0.042 | 1.015 | 0.601 | 1.026 | 0.498 | 1.031 | 1.029 | 0.497 | 0.881 | 0.878 | 0.004 |
| hex: http/html-1m | 524290 | 37889.5 ± 3.9% | 0.038 | 1.023 | 0.586 | 1.030 | 0.471 | 1.028 | 1.029 | 0.475 | 0.885 | 0.884 | 0.004 |
| hex: http/json-1kx1024 | 2099200 | 17032.1 ± 3.2% | 0.080 | 1.020 | 0.792 | 1.042 | 0.565 | 1.040 | 1.039 | 0.641 | 0.985 | 0.999 | 0.008 |
| hex: http/json-16kx64 | 2097280 | 34516.0 ± 0.8% | 0.041 | 1.010 | 0.605 | 1.018 | 0.501 | 1.015 | 1.022 | 0.501 | 0.895 | 0.893 | 0.004 |
| hex: http/json-1m | 524290 | 37130.6 ± 7.2% | 0.040 | 1.033 | 0.598 | 1.036 | 0.480 | 1.040 | 1.039 | 0.478 | 0.904 | 0.901 | 0.004 |
| hex: http/js-1kx1024 | 2099200 | 16924.3 ± 6.5% | 0.084 | 1.035 | 0.793 | 1.044 | 0.568 | 1.055 | 1.046 | 0.647 | 0.974 | 1.005 | 0.008 |
| hex: http/js-16kx64 | 2097280 | 34594.8 ± 1.0% | 0.041 | 1.009 | 0.604 | 1.011 | 0.498 | 1.022 | 1.016 | 0.499 | 0.894 | 0.892 | 0.004 |
| hex: http/js-1m | 524290 | 36499.0 ± 3.5% | 0.039 | 1.045 | 0.601 | 1.050 | 0.488 | 1.049 | 1.048 | 0.489 | 0.911 | 0.908 | 0.004 |
| hex: http/css-1kx1024 | 2099200 | 16899.2 ± 3.6% | 0.081 | 1.020 | 0.790 | 1.040 | 0.587 | 1.035 | 1.032 | 0.681 | 0.986 | 1.015 | 0.009 |
| hex: http/css-16kx64 | 2097280 | 35054.7 ± 1.5% | 0.042 | 1.010 | 0.597 | 1.020 | 0.495 | 1.018 | 1.025 | 0.495 | 0.880 | 0.881 | 0.004 |
| hex: http/css-1m | 524290 | 36486.2 ± 4.7% | 0.040 | 1.030 | 0.605 | 1.025 | 0.489 | 1.031 | 1.033 | 0.489 | 0.914 | 0.911 | 0.004 |
| hex: shuffled/dickens-1m | 524290 | 36876.6 ± 1.4% | 0.039 | 1.034 | 0.603 | 1.038 | 0.483 | 1.049 | 1.048 | 0.483 | 0.911 | 0.910 | 0.004 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1343.3 ± 0.5% | 0.435 | 0.978 | 0.972 | 0.984 | 0.987 | 0.230 | 0.988 | 0.436 | 0.844 | 0.084 | 1.021 |
| qlog records, JSON text sequence | 1467503 | 1134.1 ± 2.0% | 0.712 | 0.951 | 0.995 | 0.984 | 0.993 | 0.232 | 0.986 | 0.417 | 0.843 | 0.106 | 1.008 |
| string: silesia/dickens | 172528 | 8831.7 ± 1.4% | 0.018 | 0.604 | 0.430 | 0.613 | 0.603 | 0.121 | 0.605 | 0.997 | 1.000 | 0.018 | 1.028 |
| string: silesia/nci | 1075110 | 8696.8 ± 1.4% | 0.018 | 0.593 | 0.402 | 0.591 | 0.594 | 0.165 | 0.593 | 1.004 | 1.008 | 0.018 | 1.028 |
| string: silesia/reymont | 1075159 | 3825.8 ± 0.9% | 0.041 | 0.677 | 0.517 | 0.670 | 0.678 | 0.283 | 0.678 | 1.002 | 1.003 | 0.041 | 1.008 |
| string: silesia/samba | 97582 | 4292.1 ± 0.3% | 0.046 | 1.008 | 0.866 | 1.012 | 1.009 | 0.108 | 1.009 | 0.997 | 1.002 | 0.046 | 1.101 |
| string: silesia/webster | 1098490 | 5127.4 ± 3.7% | 0.030 | 0.694 | 0.494 | 0.698 | 0.684 | 0.153 | 0.692 | 0.997 | 0.995 | 0.030 | 0.996 |
| string: silesia/xml | 1090118 | 7694.7 ± 1.8% | 0.021 | 0.650 | 0.581 | 0.658 | 0.652 | 0.204 | 0.651 | 1.010 | 1.029 | 0.021 | 1.064 |
| string: canterbury/alice29.txt | 159425 | 9476.1 ± 1.2% | 0.016 | 0.531 | 0.405 | 0.526 | 0.533 | 0.085 | 0.541 | 0.997 | 1.003 | 0.016 | 1.033 |
| string: canterbury/asyoulik.txt | 132198 | 8445.6 ± 1.0% | 0.018 | 0.480 | 0.369 | 0.476 | 0.482 | 0.082 | 0.488 | 1.006 | 1.012 | 0.018 | 1.049 |
| string: canterbury/lcet10.txt | 441884 | 8132.1 ± 0.4% | 0.019 | 0.659 | 0.425 | 0.671 | 0.660 | 0.128 | 0.660 | 1.003 | 1.006 | 0.019 | 1.054 |
| string: canterbury/plrabn12.txt | 503330 | 6103.4 ± 1.4% | 0.025 | 0.763 | 0.582 | 0.756 | 0.761 | 0.154 | 0.761 | 1.003 | 1.003 | 0.025 | 1.055 |
| string: canterbury-large/E.coli | 1048578 | 37793.5 ± 5.1% | 0.040 | 1.014 | 1.021 | 0.590 | 1.018 | 0.469 | 1.012 | 1.004 | 1.021 | 0.004 | 1.020 |
| string: canterbury-large/bible.txt | 1055886 | 6951.5 ± 2.6% | 0.023 | 0.803 | 0.667 | 0.832 | 0.804 | 0.418 | 0.803 | 1.001 | 1.004 | 0.023 | 1.054 |
| string: canterbury-large/world192.txt | 1103121 | 5076.5 ± 5.8% | 0.030 | 0.674 | 0.504 | 0.649 | 0.672 | 0.139 | 0.667 | 0.981 | 0.964 | 0.030 | 0.947 |
| string: http/html-1m | 1058582 | 8520.8 ± 0.8% | 0.019 | 0.621 | 0.515 | 0.651 | 0.623 | 0.291 | 0.622 | 0.998 | 1.013 | 0.018 | 1.020 |
| string: http/json-1m | 1190272 | 6810.1 ± 10.4% | 0.021 | 0.210 | 0.183 | 0.213 | 0.210 | 0.060 | 0.210 | 1.003 | 1.002 | 0.021 | 1.027 |
| string: http/js-1m | 1144362 | 5114.1 ± 1.0% | 0.029 | 0.439 | 0.352 | 0.437 | 0.441 | 0.085 | 0.440 | 0.998 | 1.005 | 0.029 | 0.996 |
| string: http/css-1m | 1097820 | 6896.7 ± 1.9% | 0.022 | 0.500 | 0.354 | 0.506 | 0.500 | 0.114 | 0.504 | 0.998 | 1.002 | 0.022 | 1.058 |
| string: dickens as Cyrillic and CJK | 1883069 | 5324.7 ± 0.5% | 0.024 | 0.467 | 0.058 | 0.470 | 0.468 | 0.173 | 0.468 | 1.001 | 1.002 | 0.024 | 1.011 |
| hex: silesia/dickens | 524290 | 30721.1 ± 0.8% | 1.008 | 0.082 | 1.006 | 0.621 | 1.007 | 1.005 | 1.006 | 1.004 | 1.006 | 0.080 | 1.006 |
| hex: silesia/mozilla | 524290 | 35340.8 ± 0.9% | 1.014 | 0.072 | 1.012 | 0.570 | 1.013 | 1.012 | 1.013 | 1.011 | 1.012 | 0.068 | 1.008 |
| hex: silesia/mr | 524290 | 34434.7 ± 6.6% | 1.015 | 0.074 | 1.015 | 0.583 | 1.013 | 1.014 | 1.017 | 1.011 | 1.016 | 0.069 | 1.017 |
| hex: silesia/nci | 524290 | 34483.4 ± 0.3% | 1.008 | 0.073 | 1.011 | 0.587 | 1.012 | 1.010 | 1.015 | 1.009 | 1.009 | 0.072 | 1.012 |
| hex: silesia/ooffice | 524290 | 34694.3 ± 0.3% | 1.011 | 0.073 | 1.009 | 0.581 | 1.008 | 1.005 | 1.004 | 1.005 | 1.011 | 0.073 | 1.010 |
| hex: silesia/osdb | 524290 | 34806.7 ± 1.9% | 1.012 | 0.073 | 1.012 | 0.579 | 1.011 | 1.011 | 1.012 | 1.003 | 1.012 | 0.072 | 1.012 |
| hex: silesia/reymont | 524290 | 33222.7 ± 14.7% | 1.008 | 0.076 | 1.012 | 0.602 | 1.012 | 1.010 | 1.013 | 1.006 | 1.010 | 0.075 | 1.008 |
| hex: silesia/samba | 524290 | 33313.3 ± 1.3% | 1.013 | 0.076 | 1.012 | 0.607 | 1.016 | 1.014 | 1.014 | 1.010 | 1.016 | 0.076 | 1.016 |
| hex: silesia/sao | 524290 | 33403.4 ± 0.5% | 1.010 | 0.076 | 1.005 | 0.600 | 1.010 | 1.008 | 1.008 | 1.009 | 1.012 | 0.073 | 1.012 |
| hex: silesia/webster | 524290 | 36760.4 ± 0.5% | 1.017 | 0.069 | 1.014 | 0.549 | 1.018 | 1.015 | 1.019 | 1.016 | 1.015 | 0.065 | 1.020 |
| hex: silesia/x-ray | 524290 | 34883.6 ± 1.3% | 1.012 | 0.073 | 1.014 | 0.574 | 1.015 | 1.008 | 1.015 | 1.012 | 1.014 | 0.068 | 1.017 |
| hex: silesia/xml | 524290 | 33893.8 ± 0.7% | 1.011 | 0.075 | 1.008 | 0.594 | 1.015 | 1.011 | 1.016 | 1.011 | 1.016 | 0.070 | 1.016 |
| hex: canterbury/alice29.txt | 304180 | 34350.2 ± 0.8% | 1.008 | 0.074 | 1.006 | 0.582 | 1.005 | 0.999 | 1.004 | 1.005 | 1.010 | 0.068 | 1.005 |
| hex: canterbury/asyoulik.txt | 250360 | 31068.0 ± 2.2% | 1.003 | 0.081 | 1.005 | 0.605 | 1.006 | 1.003 | 1.004 | 1.004 | 1.003 | 0.075 | 1.003 |
| hex: canterbury/cp.html | 49208 | 31513.5 ± 0.3% | 1.000 | 0.080 | 0.999 | 0.618 | 1.003 | 1.001 | 1.003 | 1.007 | 1.010 | 0.074 | 1.004 |
| hex: canterbury/fields.c | 22302 | 31993.8 ± 1.6% | 0.998 | 0.078 | 1.002 | 0.602 | 1.004 | 0.984 | 1.003 | 1.007 | 1.016 | 0.071 | 1.008 |
| hex: canterbury/grammar.lsp | 7444 | 32387.7 ± 1.4% | 0.998 | 0.077 | 0.998 | 0.570 | 0.997 | 0.947 | 0.994 | 1.003 | 1.028 | 0.067 | 1.014 |
| hex: canterbury/kennedy.xls | 524290 | 29908.7 ± 5.1% | 1.016 | 0.084 | 1.013 | 0.641 | 1.014 | 1.013 | 1.013 | 1.009 | 1.012 | 0.077 | 1.018 |
| hex: canterbury/lcet10.txt | 524290 | 32671.9 ± 2.4% | 1.009 | 0.076 | 1.010 | 0.616 | 1.011 | 1.006 | 1.010 | 1.005 | 1.011 | 0.071 | 1.006 |
| hex: canterbury/plrabn12.txt | 524290 | 33285.8 ± 0.8% | 1.013 | 0.076 | 1.013 | 0.598 | 1.013 | 1.005 | 1.014 | 1.012 | 1.013 | 0.070 | 1.015 |
| hex: canterbury/ptt5 | 524290 | 33535.7 ± 1.5% | 1.019 | 0.076 | 1.018 | 0.601 | 1.018 | 1.016 | 1.017 | 1.017 | 1.016 | 0.071 | 1.018 |
| hex: canterbury/sum | 76482 | 35396.3 ± 0.7% | 0.998 | 0.072 | 0.999 | 0.571 | 0.998 | 0.994 | 1.000 | 1.006 | 1.002 | 0.064 | 1.003 |
| hex: canterbury/xargs.1 | 8456 | 34740.1 ± 0.6% | 0.996 | 0.073 | 0.997 | 0.543 | 0.996 | 0.952 | 0.995 | 1.001 | 1.028 | 0.066 | 1.009 |
| hex: canterbury-large/E.coli | 524290 | 30453.3 ± 6.1% | 1.009 | 0.083 | 1.006 | 0.630 | 1.009 | 1.006 | 1.007 | 1.006 | 1.007 | 0.082 | 1.010 |
| hex: canterbury-large/bible.txt | 524290 | 35371.0 ± 1.2% | 1.011 | 0.072 | 1.009 | 0.570 | 1.013 | 1.011 | 1.013 | 1.011 | 1.014 | 0.069 | 1.014 |
| hex: canterbury-large/world192.txt | 524290 | 35053.3 ± 0.6% | 1.011 | 0.072 | 1.010 | 0.567 | 1.011 | 1.009 | 1.011 | 1.010 | 1.009 | 0.069 | 1.014 |
| hex: http/html-1kx1024 | 2099200 | 23778.0 ± 0.7% | 0.994 | 0.103 | 0.971 | 0.676 | 0.975 | 0.870 | 0.977 | 0.970 | 1.034 | 0.093 | 1.001 |
| hex: http/html-16kx64 | 2097280 | 29460.6 ± 1.8% | 1.027 | 0.085 | 1.024 | 0.658 | 1.027 | 1.014 | 1.027 | 1.028 | 1.033 | 0.082 | 1.029 |
| hex: http/html-1m | 524290 | 29138.1 ± 0.8% | 1.006 | 0.087 | 1.009 | 0.668 | 1.009 | 1.005 | 1.011 | 1.008 | 1.007 | 0.082 | 1.009 |
| hex: http/json-1kx1024 | 2099200 | 23956.6 ± 0.9% | 0.988 | 0.102 | 0.969 | 0.668 | 0.972 | 0.871 | 0.970 | 0.976 | 1.031 | 0.094 | 1.002 |
| hex: http/json-16kx64 | 2097280 | 29801.5 ± 2.4% | 1.023 | 0.085 | 1.023 | 0.651 | 1.018 | 1.003 | 1.019 | 1.016 | 1.025 | 0.080 | 1.020 |
| hex: http/json-1m | 524290 | 31433.0 ± 0.6% | 1.011 | 0.080 | 1.001 | 0.634 | 1.010 | 1.008 | 1.011 | 1.008 | 1.006 | 0.076 | 1.012 |
| hex: http/js-1kx1024 | 2099200 | 23792.2 ± 2.1% | 0.995 | 0.103 | 0.989 | 0.683 | 0.997 | 0.888 | 0.995 | 0.999 | 1.055 | 0.093 | 1.030 |
| hex: http/js-16kx64 | 2097280 | 29763.9 ± 1.8% | 1.020 | 0.085 | 1.021 | 0.651 | 1.024 | 1.013 | 1.024 | 1.021 | 1.026 | 0.082 | 1.024 |
| hex: http/js-1m | 524290 | 30503.4 ± 1.6% | 1.012 | 0.083 | 1.011 | 0.647 | 1.009 | 1.004 | 1.009 | 1.005 | 1.007 | 0.077 | 1.006 |
| hex: http/css-1kx1024 | 2099200 | 23858.1 ± 0.6% | 0.986 | 0.103 | 0.981 | 0.680 | 0.989 | 0.884 | 0.987 | 0.984 | 1.040 | 0.095 | 1.020 |
| hex: http/css-16kx64 | 2097280 | 29957.5 ± 0.6% | 1.012 | 0.084 | 1.012 | 0.648 | 1.013 | 1.001 | 1.014 | 1.011 | 1.020 | 0.083 | 1.012 |
| hex: http/css-1m | 524290 | 31621.7 ± 0.3% | 1.006 | 0.080 | 1.008 | 0.631 | 1.006 | 1.006 | 1.010 | 1.004 | 1.005 | 0.077 | 1.007 |
| hex: shuffled/dickens-1m | 524290 | 34610.2 ± 0.9% | 1.012 | 0.073 | 1.016 | 0.583 | 1.014 | 1.009 | 1.014 | 1.012 | 1.016 | 0.073 | 1.017 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.066 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.082 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.083 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.081 of all on.
- string: silesia/dickens, decoding: J7 wide vectors off runs at 1.075 of all on.
- string: silesia/dickens, decoding: J8 decoder fast path off runs at 1.086 of all on.
- string: silesia/dickens, decoding: J13 decoder escape blocks off runs at 1.086 of all on.
- string: silesia/webster, decoding: J7 wide vectors off runs at 1.055 of all on.
- string: silesia/webster, decoding: J8 decoder fast path off runs at 1.075 of all on.
- string: silesia/webster, decoding: J13 decoder escape blocks off runs at 1.075 of all on.
- string: canterbury/alice29.txt, decoding: J7 wide vectors off runs at 1.069 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.146 of all on.
- string: canterbury/alice29.txt, decoding: J12 decoder escape words off runs at 1.090 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.148 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.128 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.162 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.064 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.159 of all on.
- string: canterbury/lcet10.txt, decoding: J7 wide vectors off runs at 1.075 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.094 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.094 of all on.
- string: canterbury/plrabn12.txt, decoding: J8 decoder fast path off runs at 1.063 of all on.
- string: canterbury/plrabn12.txt, decoding: J13 decoder escape blocks off runs at 1.064 of all on.
- string: canterbury-large/world192.txt, decoding: J8 decoder fast path off runs at 1.094 of all on.
- string: canterbury-large/world192.txt, decoding: J13 decoder escape blocks off runs at 1.092 of all on.
- string: http/js-1m, decoding: J8 decoder fast path off runs at 1.085 of all on.
- string: http/js-1m, decoding: J13 decoder escape blocks off runs at 1.083 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 100503.5 ± 2.5% | 91638.6 ± 0.6% | 1.097 | — | — |
| string: silesia/nci | 1048576 | 73071.7 ± 11.9% | 72006.4 ± 24.6% | 1.015 | — | — |
| string: silesia/reymont | 1048576 | 72836.2 ± 6.5% | 72444.2 ± 0.9% | 1.005 | — | — |
| string: silesia/samba | 65546 | 97927.8 ± 1.2% | 90190.3 ± 0.2% | 1.086 | — | — |
| string: silesia/webster | 1048576 | 73233.7 ± 12.8% | 76321.1 ± 1.1% | 0.960 | — | — |
| string: silesia/xml | 1048576 | 73619.4 ± 1.8% | 72545.6 ± 0.5% | 1.015 | — | — |
| string: canterbury/alice29.txt | 152089 | 99874.5 ± 2.1% | 91100.3 ± 0.8% | 1.096 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 99815.5 ± 0.6% | 91681.1 ± 0.3% | 1.089 | — | — |
| string: canterbury/lcet10.txt | 426754 | 86260.4 ± 3.9% | 80038.2 ± 1.1% | 1.078 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 78710.1 ± 1.8% | 77004.2 ± 1.4% | 1.022 | — | — |
| string: canterbury-large/E.coli | 1048576 | 72214.9 ± 2.1% | 70959.7 ± 0.4% | 1.018 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 72721.5 ± 0.9% | 71798.3 ± 1.9% | 1.013 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 73896.3 ± 2.5% | 72085.4 ± 0.6% | 1.025 | — | — |
| string: http/html-1m | 1048576 | 68178.0 ± 1.1% | 67944.1 ± 1.6% | 1.003 | — | — |
| string: http/json-1m | 1048576 | 61152.9 ± 1.4% | 65412.5 ± 0.8% | 0.935 | — | — |
| string: http/js-1m | 1048576 | 71252.4 ± 3.3% | 71218.2 ± 10.4% | 1.000 | — | — |
| string: http/css-1m | 1048576 | 72983.5 ± 1.5% | 72220.1 ± 1.0% | 1.011 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 14616.7 ± 0.5% | 15336.2 ± 0.7% | 0.953 | — | — |

## Losses to simdutf

- string: http/json-1m: stdx runs at 0.935 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 77694.7 ± 5.9% | 78376.5 ± 0.8% | 0.991 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 78231.6 ± 0.8% | 75946.2 ± 0.5% | 1.030 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 78124.0 ± 0.6% | 76043.5 ± 0.6% | 1.027 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 77844.7 ± 1.5% | 76066.5 ± 1.4% | 1.023 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 78282.7 ± 2.5% | 78900.4 ± 0.6% | 0.992 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 77899.1 ± 0.5% | 76414.7 ± 3.5% | 1.019 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 14621.7 ± 0.7% | 15251.5 ± 0.4% | 0.959 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 14582.9 ± 1.2% | 15273.7 ± 2.0% | 0.955 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 14582.6 ± 2.3% | 15314.1 ± 0.3% | 0.952 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 14617.6 ± 0.2% | 15283.0 ± 0.6% | 0.956 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 14604.0 ± 3.5% | 15265.0 ± 0.4% | 0.957 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 14585.9 ± 0.3% | 15270.9 ± 0.4% | 0.955 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1021.0 ± 2.2% | 1006.6 ± 1.0% | 956.7 ± 1.4% | 285.4 ± 20.5% | 532.4 ± 2.1% | 254.6 ± 3.2% | 1.014 | 1.067 | 3.578 | 1.918 | 4.010 |
| qlog records, JSON text sequence | 1467503 | 770.8 ± 7.8% | 805.5 ± 0.3% | 744.6 ± 6.8% | 226.3 ± 3.8% | 527.0 ± 26.4% | 219.2 ± 4.9% | 0.957 | 1.035 | 3.407 | 1.462 | 3.517 |
| string: silesia/dickens | 172528 | 5273.4 ± 0.9% | 2876.3 ± 0.6% | 2065.0 ± 0.7% | 302.2 ± 1.1% | 2182.0 ± 10.1% | 459.7 ± 7.5% | 1.833 | 2.554 | 17.450 | 2.417 | 11.472 |
| string: silesia/nci | 1075110 | 5179.6 ± 0.2% | 3464.1 ± 0.3% | 2771.9 ± 1.9% | 499.3 ± 1.3% | 2421.1 ± 1.1% | 499.7 ± 1.7% | 1.495 | 1.869 | 10.373 | 2.139 | 10.365 |
| string: silesia/reymont | 1075159 | 2722.8 ± 3.1% | 2187.8 ± 0.4% | 1786.3 ± 5.6% | 317.8 ± 0.9% | 1667.9 ± 1.8% | 445.5 ± 1.6% | 1.245 | 1.524 | 8.566 | 1.632 | 6.111 |
| string: silesia/samba | 97582 | 3286.1 ± 1.3% | 2770.0 ± 1.5% | 1714.3 ± 5.4% | 258.4 ± 0.4% | 1339.5 ± 9.9% | 335.3 ± 3.3% | 1.186 | 1.917 | 12.715 | 2.453 | 9.801 |
| string: silesia/webster | 1098490 | 3566.9 ± 0.1% | 2023.5 ± 1.2% | 1643.1 ± 2.8% | 307.4 ± 14.4% | 1670.2 ± 1.1% | 424.0 ± 4.5% | 1.763 | 2.171 | 11.602 | 2.136 | 8.412 |
| string: silesia/xml | 1090118 | 4992.3 ± 1.0% | 3656.8 ± 1.8% | 2129.2 ± 2.3% | 406.6 ± 0.9% | 2368.5 ± 1.3% | 493.6 ± 4.1% | 1.365 | 2.345 | 12.278 | 2.108 | 10.113 |
| string: canterbury/alice29.txt | 159425 | 4276.0 ± 1.1% | 2380.9 ± 4.2% | 1840.5 ± 5.5% | 284.4 ± 2.3% | 1931.2 ± 0.6% | 435.2 ± 5.2% | 1.796 | 2.323 | 15.033 | 2.214 | 9.826 |
| string: canterbury/asyoulik.txt | 132198 | 3672.6 ± 3.6% | 2109.2 ± 0.7% | 1490.4 ± 2.8% | 274.3 ± 1.1% | 1571.7 ± 0.6% | 384.9 ± 2.0% | 1.741 | 2.464 | 13.390 | 2.337 | 9.542 |
| string: canterbury/lcet10.txt | 441884 | 5550.0 ± 1.2% | 2773.3 ± 0.7% | 1959.9 ± 3.4% | 325.6 ± 1.2% | 2153.9 ± 15.1% | 467.0 ± 7.2% | 2.001 | 2.832 | 17.046 | 2.577 | 11.885 |
| string: canterbury/plrabn12.txt | 503330 | 4512.3 ± 1.0% | 2691.9 ± 2.2% | 1667.1 ± 0.9% | 298.0 ± 0.4% | 2025.8 ± 7.4% | 432.0 ± 8.0% | 1.676 | 2.707 | 15.140 | 2.227 | 10.445 |
| string: canterbury-large/E.coli | 1048578 | 32749.8 ± 2.7% | 7759.3 ± 0.7% | 3476.9 ± 0.8% | 798.2 ± 0.3% | 5325.4 ± 1.7% | 780.4 ± 2.1% | 4.221 | 9.419 | 41.031 | 6.150 | 41.967 |
| string: canterbury-large/bible.txt | 1055886 | 6545.9 ± 1.3% | 3905.6 ± 2.1% | 2571.1 ± 0.8% | 351.3 ± 4.0% | 3015.5 ± 3.2% | 579.4 ± 1.9% | 1.676 | 2.546 | 18.633 | 2.171 | 11.297 |
| string: canterbury-large/world192.txt | 1103121 | 3331.1 ± 5.2% | 1975.4 ± 1.3% | 1633.6 ± 5.7% | 296.1 ± 1.5% | 1679.2 ± 0.8% | 420.5 ± 3.8% | 1.686 | 2.039 | 11.248 | 1.984 | 7.922 |
| string: http/html-1m | 1058582 | 6177.1 ± 5.2% | 3394.7 ± 0.7% | 2390.7 ± 1.4% | 406.9 ± 2.0% | 2760.5 ± 0.5% | 412.8 ± 15.6% | 1.820 | 2.584 | 15.181 | 2.238 | 14.963 |
| string: http/json-1m | 1190272 | 3312.6 ± 1.3% | 1198.6 ± 0.7% | 1543.8 ± 6.8% | 356.0 ± 0.6% | 841.6 ± 16.7% | 286.7 ± 1.5% | 2.764 | 2.146 | 9.306 | 3.936 | 11.555 |
| string: http/js-1m | 1144362 | 2201.7 ± 6.7% | 1326.1 ± 0.5% | 1148.1 ± 1.5% | 278.4 ± 2.7% | 1167.0 ± 1.7% | 283.3 ± 1.2% | 1.660 | 1.918 | 7.908 | 1.887 | 7.773 |
| string: http/css-1m | 1097820 | 2934.2 ± 0.6% | 2504.7 ± 1.4% | 1554.1 ± 1.0% | 372.2 ± 0.4% | 1555.3 ± 2.2% | 319.6 ± 15.8% | 1.171 | 1.888 | 7.884 | 1.887 | 9.182 |
| string: dickens as Cyrillic and CJK | 1883069 | 5187.6 ± 1.1% | 3169.7 ± 2.3% | 692.9 ± 0.8% | 254.2 ± 16.0% | 499.6 ± 3.9% | 133.9 ± 1.7% | 1.637 | 7.487 | 20.412 | 10.383 | 38.751 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1055.9 ± 1.1% | 1070.1 ± 0.6% | 842.6 ± 1.5% | 157.0 ± 0.5% | 384.3 ± 3.7% | 197.8 ± 3.6% | 0.987 | 1.253 | 6.726 | 2.747 | 5.338 |
| hex: silesia/dickens | 524290 | 37037.3 ± 6.5% | 7747.2 ± 0.5% | 3459.4 ± 1.1% | 451.1 ± 3.1% | 5276.7 ± 1.2% | 761.0 ± 3.2% | 4.781 | 10.706 | 82.108 | 7.019 | 48.672 |
| hex: silesia/mozilla | 524290 | 37446.4 ± 2.9% | 7749.0 ± 0.7% | 3501.6 ± 2.3% | 406.3 ± 8.0% | 5316.3 ± 2.5% | 772.2 ± 1.1% | 4.832 | 10.694 | 92.174 | 7.044 | 48.495 |
| hex: silesia/mr | 524290 | 37474.2 ± 1.2% | 7757.0 ± 0.6% | 3500.9 ± 0.6% | 581.4 ± 0.3% | 5346.9 ± 0.8% | 782.5 ± 2.1% | 4.831 | 10.704 | 64.452 | 7.009 | 47.888 |
| hex: silesia/nci | 524290 | 35529.1 ± 1.3% | 7759.6 ± 1.5% | 3487.4 ± 1.1% | 642.7 ± 1.5% | 5315.3 ± 2.0% | 770.7 ± 2.5% | 4.579 | 10.188 | 55.278 | 6.684 | 46.099 |
| hex: silesia/ooffice | 524290 | 37073.4 ± 2.6% | 7768.5 ± 0.3% | 3472.6 ± 1.6% | 355.6 ± 0.5% | 5333.5 ± 1.6% | 755.8 ± 6.7% | 4.772 | 10.676 | 104.258 | 6.951 | 49.049 |
| hex: silesia/osdb | 524290 | 37312.6 ± 2.7% | 7753.6 ± 0.9% | 3471.1 ± 1.6% | 447.2 ± 2.8% | 5337.4 ± 1.1% | 759.6 ± 7.7% | 4.812 | 10.749 | 83.433 | 6.991 | 49.121 |
| hex: silesia/reymont | 524290 | 36423.3 ± 1.3% | 7765.8 ± 0.5% | 3448.8 ± 1.1% | 470.3 ± 4.2% | 5297.3 ± 0.6% | 769.2 ± 2.4% | 4.690 | 10.561 | 77.444 | 6.876 | 47.355 |
| hex: silesia/samba | 524290 | 37470.6 ± 0.9% | 7759.5 ± 0.4% | 3479.0 ± 4.0% | 350.6 ± 2.8% | 5325.8 ± 1.8% | 765.6 ± 2.3% | 4.829 | 10.771 | 106.888 | 7.036 | 48.945 |
| hex: silesia/sao | 524290 | 37614.5 ± 1.6% | 7758.7 ± 1.0% | 3457.5 ± 0.7% | 287.0 ± 3.2% | 5300.7 ± 1.3% | 771.6 ± 4.8% | 4.848 | 10.879 | 131.078 | 7.096 | 48.749 |
| hex: silesia/webster | 524290 | 31780.4 ± 1.5% | 7753.0 ± 0.4% | 3476.5 ± 9.0% | 432.8 ± 1.7% | 5341.0 ± 3.4% | 768.2 ± 2.0% | 4.099 | 9.141 | 73.434 | 5.950 | 41.371 |
| hex: silesia/x-ray | 524290 | 37021.7 ± 1.3% | 7774.5 ± 0.7% | 3462.3 ± 2.1% | 428.6 ± 5.5% | 5315.3 ± 11.1% | 764.6 ± 2.3% | 4.762 | 10.693 | 86.376 | 6.965 | 48.420 |
| hex: silesia/xml | 524290 | 37540.8 ± 1.6% | 7759.7 ± 1.1% | 3486.9 ± 1.8% | 603.2 ± 0.6% | 5376.6 ± 1.2% | 776.7 ± 2.5% | 4.838 | 10.766 | 62.232 | 6.982 | 48.335 |
| hex: canterbury/alice29.txt | 304180 | 38462.8 ± 2.5% | 7750.7 ± 0.5% | 3493.0 ± 1.7% | 469.4 ± 0.3% | 5311.1 ± 0.3% | 752.6 ± 3.4% | 4.962 | 11.011 | 81.939 | 7.242 | 51.105 |
| hex: canterbury/asyoulik.txt | 250360 | 35946.7 ± 2.0% | 7790.1 ± 2.2% | 3507.5 ± 0.9% | 461.4 ± 0.4% | 5332.6 ± 1.8% | 773.0 ± 2.0% | 4.614 | 10.249 | 77.911 | 6.741 | 46.504 |
| hex: canterbury/cp.html | 49208 | 39764.8 ± 7.6% | 7779.6 ± 0.6% | 3523.2 ± 1.1% | 462.2 ± 0.5% | 5324.7 ± 1.3% | 745.9 ± 4.7% | 5.111 | 11.287 | 86.033 | 7.468 | 53.311 |
| hex: canterbury/fields.c | 22302 | 35959.4 ± 0.6% | 7677.1 ± 3.3% | 3508.5 ± 0.9% | 483.5 ± 2.2% | 5344.3 ± 2.5% | 740.2 ± 6.2% | 4.684 | 10.249 | 74.373 | 6.729 | 48.582 |
| hex: canterbury/grammar.lsp | 7444 | 36687.6 ± 1.8% | 7485.2 ± 0.4% | 3569.2 ± 0.2% | 530.4 ± 4.0% | 5246.3 ± 2.2% | 719.8 ± 10.2% | 4.901 | 10.279 | 69.168 | 6.993 | 50.968 |
| hex: canterbury/kennedy.xls | 524290 | 29272.0 ± 2.8% | 7770.3 ± 0.6% | 3481.4 ± 1.1% | 665.5 ± 4.9% | 5290.3 ± 0.2% | 726.9 ± 15.3% | 3.767 | 8.408 | 43.985 | 5.533 | 40.267 |
| hex: canterbury/lcet10.txt | 524290 | 36655.0 ± 4.9% | 7761.0 ± 0.6% | 3471.1 ± 0.3% | 454.8 ± 1.8% | 5290.5 ± 0.8% | 729.9 ± 2.3% | 4.723 | 10.560 | 80.601 | 6.928 | 50.221 |
| hex: canterbury/plrabn12.txt | 524290 | 37061.8 ± 2.8% | 7727.5 ± 0.8% | 3464.2 ± 1.6% | 439.8 ± 7.6% | 5288.2 ± 1.3% | 730.5 ± 5.1% | 4.796 | 10.698 | 84.266 | 7.008 | 50.733 |
| hex: canterbury/ptt5 | 524290 | 37825.6 ± 2.7% | 7780.7 ± 0.9% | 3476.6 ± 0.4% | 560.7 ± 13.8% | 5249.0 ± 0.7% | 750.9 ± 1.7% | 4.861 | 10.880 | 67.460 | 7.206 | 50.374 |
| hex: canterbury/sum | 76482 | 39571.7 ± 0.4% | 7786.1 ± 0.6% | 3491.1 ± 0.7% | 504.7 ± 0.8% | 5266.2 ± 1.0% | 746.9 ± 1.9% | 5.082 | 11.335 | 78.404 | 7.514 | 52.983 |
| hex: canterbury/xargs.1 | 8456 | 38335.7 ± 2.7% | 7517.6 ± 1.9% | 3540.4 ± 1.0% | 496.1 ± 5.9% | 5211.6 ± 0.5% | 746.3 ± 2.1% | 5.099 | 10.828 | 77.270 | 7.356 | 51.365 |
| hex: canterbury-large/E.coli | 524290 | 36695.8 ± 12.2% | 7777.3 ± 1.3% | 3460.6 ± 1.2% | 709.2 ± 0.6% | 5279.8 ± 1.3% | 757.1 ± 7.1% | 4.718 | 10.604 | 51.743 | 6.950 | 48.470 |
| hex: canterbury-large/bible.txt | 524290 | 37249.6 ± 9.8% | 7724.2 ± 0.2% | 3485.3 ± 0.3% | 487.9 ± 0.3% | 5329.9 ± 13.6% | 771.0 ± 2.4% | 4.822 | 10.688 | 76.342 | 6.989 | 48.314 |
| hex: canterbury-large/world192.txt | 524290 | 37533.7 ± 1.9% | 7780.2 ± 1.2% | 3490.6 ± 4.2% | 454.0 ± 2.9% | 5358.0 ± 1.2% | 772.1 ± 3.2% | 4.824 | 10.753 | 82.681 | 7.005 | 48.615 |
| hex: http/html-1kx1024 | 2099200 | 17162.3 ± 2.9% | 6632.7 ± 0.2% | 3188.7 ± 0.7% | 479.4 ± 0.9% | 4715.4 ± 1.3% | 627.2 ± 18.2% | 2.588 | 5.382 | 35.798 | 3.640 | 27.363 |
| hex: http/html-16kx64 | 2097280 | 34970.8 ± 2.2% | 7635.8 ± 0.8% | 3431.6 ± 0.6% | 494.1 ± 3.5% | 5316.0 ± 2.6% | 721.0 ± 7.1% | 4.580 | 10.191 | 70.773 | 6.578 | 48.506 |
| hex: http/html-1m | 524290 | 37889.5 ± 3.9% | 7760.8 ± 6.0% | 3461.7 ± 2.9% | 486.1 ± 2.5% | 5269.4 ± 0.8% | 751.6 ± 2.5% | 4.882 | 10.945 | 77.950 | 7.190 | 50.412 |
| hex: http/json-1kx1024 | 2099200 | 17032.1 ± 3.2% | 6621.6 ± 1.4% | 3181.5 ± 1.1% | 609.6 ± 2.0% | 4772.8 ± 2.2% | 628.2 ± 3.9% | 2.572 | 5.354 | 27.941 | 3.569 | 27.115 |
| hex: http/json-16kx64 | 2097280 | 34516.0 ± 0.8% | 7655.7 ± 0.3% | 3411.9 ± 9.1% | 631.2 ± 1.8% | 5347.7 ± 1.2% | 705.3 ± 13.9% | 4.509 | 10.116 | 54.684 | 6.454 | 48.938 |
| hex: http/json-1m | 524290 | 37130.6 ± 7.2% | 7717.0 ± 1.9% | 3483.0 ± 1.2% | 642.8 ± 0.6% | 5380.4 ± 0.9% | 761.9 ± 4.4% | 4.812 | 10.660 | 57.762 | 6.901 | 48.732 |
| hex: http/js-1kx1024 | 2099200 | 16924.3 ± 6.5% | 6634.8 ± 0.8% | 3171.9 ± 1.4% | 464.5 ± 2.3% | 4709.3 ± 4.4% | 613.3 ± 8.5% | 2.551 | 5.336 | 36.438 | 3.594 | 27.596 |
| hex: http/js-16kx64 | 2097280 | 34594.8 ± 1.0% | 7631.1 ± 1.1% | 3447.1 ± 0.6% | 460.3 ± 5.2% | 5341.7 ± 1.5% | 704.9 ± 12.9% | 4.533 | 10.036 | 75.160 | 6.476 | 49.080 |
| hex: http/js-1m | 524290 | 36499.0 ± 3.5% | 7712.0 ± 2.0% | 3473.7 ± 2.4% | 471.0 ± 3.0% | 5283.5 ± 5.8% | 720.8 ± 12.9% | 4.733 | 10.507 | 77.492 | 6.908 | 50.634 |
| hex: http/css-1kx1024 | 2099200 | 16899.2 ± 3.6% | 6636.5 ± 0.2% | 3184.6 ± 1.3% | 528.7 ± 2.7% | 4753.7 ± 2.4% | 625.2 ± 4.2% | 2.546 | 5.306 | 31.965 | 3.555 | 27.029 |
| hex: http/css-16kx64 | 2097280 | 35054.7 ± 1.5% | 7670.7 ± 0.8% | 3450.0 ± 0.7% | 549.2 ± 0.6% | 5403.3 ± 2.5% | 747.7 ± 1.6% | 4.570 | 10.161 | 63.830 | 6.488 | 46.881 |
| hex: http/css-1m | 524290 | 36486.2 ± 4.7% | 7770.1 ± 0.9% | 3490.2 ± 0.6% | 531.9 ± 0.5% | 5306.3 ± 14.3% | 765.9 ± 2.6% | 4.696 | 10.454 | 68.599 | 6.876 | 47.636 |
| hex: shuffled/dickens-1m | 524290 | 36876.6 ± 1.4% | 7728.0 ± 1.2% | 3454.9 ± 0.7% | 461.8 ± 2.6% | 5312.0 ± 2.9% | 749.3 ± 2.6% | 4.772 | 10.674 | 79.851 | 6.942 | 49.216 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1343.3 ± 0.5% | 1136.5 ± 0.6% | 847.6 ± 1.6% | 327.6 ± 2.2% | 351.1 ± 1.8% | 306.6 ± 2.3% | 1.182 | 1.585 | 4.100 | 3.826 | 4.381 |
| qlog records, JSON text sequence | 1467503 | 1134.1 ± 2.0% | 851.0 ± 2.1% | 683.7 ± 1.9% | 308.5 ± 6.0% | 367.5 ± 0.7% | 222.1 ± 9.3% | 1.333 | 1.659 | 3.677 | 3.086 | 5.106 |
| string: silesia/dickens | 172528 | 8831.7 ± 1.4% | 2985.4 ± 3.2% | 2103.3 ± 1.1% | 344.6 ± 0.6% | 1049.7 ± 0.9% | 556.5 ± 0.2% | 2.958 | 4.199 | 25.625 | 8.414 | 15.869 |
| string: silesia/nci | 1075110 | 8696.8 ± 1.4% | 3194.4 ± 0.5% | 2826.7 ± 10.8% | 772.7 ± 0.8% | 1105.2 ± 1.0% | 558.4 ± 0.9% | 2.722 | 3.077 | 11.255 | 7.869 | 15.574 |
| string: silesia/reymont | 1075159 | 3825.8 ± 0.9% | 1638.4 ± 0.7% | 1792.6 ± 10.4% | 348.0 ± 1.0% | 965.9 ± 0.6% | 548.9 ± 0.3% | 2.335 | 2.134 | 10.995 | 3.961 | 6.970 |
| string: silesia/samba | 97582 | 4292.1 ± 0.3% | 1906.8 ± 1.6% | 2245.2 ± 1.3% | 290.6 ± 3.8% | 911.5 ± 9.2% | 620.3 ± 0.2% | 2.251 | 1.912 | 14.767 | 4.709 | 6.919 |
| string: silesia/webster | 1098490 | 5127.4 ± 3.7% | 1615.5 ± 1.4% | 1583.5 ± 0.4% | 354.5 ± 1.7% | 942.0 ± 2.3% | 454.0 ± 1.1% | 3.174 | 3.238 | 14.463 | 5.443 | 11.294 |
| string: silesia/xml | 1090118 | 7694.7 ± 1.8% | 2680.2 ± 0.9% | 2247.2 ± 0.5% | 538.2 ± 1.2% | 1134.1 ± 0.8% | 559.1 ± 0.6% | 2.871 | 3.424 | 14.297 | 6.785 | 13.763 |
| string: canterbury/alice29.txt | 159425 | 9476.1 ± 1.2% | 2423.6 ± 3.4% | 1913.4 ± 3.2% | 336.8 ± 0.5% | 1047.1 ± 0.9% | 550.5 ± 4.7% | 3.910 | 4.953 | 28.137 | 9.050 | 17.213 |
| string: canterbury/asyoulik.txt | 132198 | 8445.6 ± 1.0% | 2164.9 ± 4.9% | 1643.5 ± 0.9% | 343.0 ± 3.2% | 914.7 ± 1.3% | 539.3 ± 0.8% | 3.901 | 5.139 | 24.621 | 9.234 | 15.660 |
| string: canterbury/lcet10.txt | 441884 | 8132.1 ± 0.4% | 2459.1 ± 0.6% | 2050.7 ± 0.2% | 385.1 ± 1.4% | 1031.5 ± 2.1% | 548.4 ± 1.3% | 3.307 | 3.965 | 21.119 | 7.884 | 14.828 |
| string: canterbury/plrabn12.txt | 503330 | 6103.4 ± 1.4% | 1828.2 ± 12.9% | 1749.9 ± 0.6% | 356.1 ± 0.6% | 1000.1 ± 1.1% | 554.3 ± 0.3% | 3.339 | 3.488 | 17.139 | 6.103 | 11.011 |
| string: canterbury-large/E.coli | 1048578 | 37793.5 ± 5.1% | 10876.0 ± 0.7% | 3321.5 ± 0.3% | 1417.8 ± 1.5% | 1439.1 ± 4.3% | 568.2 ± 1.1% | 3.475 | 11.379 | 26.657 | 26.262 | 66.512 |
| string: canterbury-large/bible.txt | 1055886 | 6951.5 ± 2.6% | 3938.6 ± 0.9% | 2718.8 ± 17.5% | 429.4 ± 4.7% | 1210.7 ± 1.8% | 563.7 ± 0.6% | 1.765 | 2.557 | 16.190 | 5.742 | 12.331 |
| string: canterbury-large/world192.txt | 1103121 | 5076.5 ± 5.8% | 1435.5 ± 0.9% | 1684.9 ± 1.0% | 361.6 ± 3.5% | 922.1 ± 0.5% | 535.8 ± 0.5% | 3.537 | 3.013 | 14.039 | 5.506 | 9.475 |
| string: http/html-1m | 1058582 | 8520.8 ± 0.8% | 3855.6 ± 1.2% | 2498.0 ± 0.1% | 389.9 ± 0.6% | 1202.1 ± 1.3% | 516.5 ± 2.8% | 2.210 | 3.411 | 21.856 | 7.088 | 16.499 |
| string: http/json-1m | 1190272 | 6810.1 ± 10.4% | 1224.6 ± 1.0% | 1282.1 ± 0.3% | 373.8 ± 0.3% | 774.0 ± 2.8% | 503.3 ± 16.6% | 5.561 | 5.312 | 18.221 | 8.798 | 13.532 |
| string: http/js-1m | 1144362 | 5114.1 ± 1.0% | 979.2 ± 1.4% | 1222.4 ± 3.8% | 283.1 ± 13.6% | 784.8 ± 2.3% | 471.8 ± 0.4% | 5.223 | 4.184 | 18.064 | 6.516 | 10.840 |
| string: http/css-1m | 1097820 | 6896.7 ± 1.9% | 1287.7 ± 1.2% | 1601.7 ± 0.4% | 401.1 ± 1.5% | 863.8 ± 1.9% | 526.6 ± 1.0% | 5.356 | 4.306 | 17.193 | 7.984 | 13.096 |
| string: dickens as Cyrillic and CJK | 1883069 | 5324.7 ± 0.5% | 3031.9 ± 1.5% | 339.9 ± 0.7% | 268.6 ± 0.5% | 410.4 ± 0.8% | 290.8 ± 0.5% | 1.756 | 15.666 | 19.824 | 12.974 | 18.313 |
| hex: silesia/dickens | 524290 | 30721.1 ± 0.8% | 1556.3 ± 2.8% | 1083.6 ± 3.0% | 412.8 ± 6.0% | 791.1 ± 1.0% | 434.6 ± 2.3% | 19.740 | 28.351 | 74.415 | 38.834 | 70.686 |
| hex: silesia/mozilla | 524290 | 35340.8 ± 0.9% | 1567.3 ± 1.6% | 1085.4 ± 0.3% | 359.6 ± 4.3% | 791.0 ± 0.6% | 428.5 ± 1.3% | 22.549 | 32.562 | 98.278 | 44.680 | 82.466 |
| hex: silesia/mr | 524290 | 34434.7 ± 6.6% | 1567.6 ± 0.7% | 1086.1 ± 0.6% | 493.3 ± 1.8% | 788.7 ± 1.9% | 431.6 ± 1.2% | 21.966 | 31.704 | 69.799 | 43.658 | 79.775 |
| hex: silesia/nci | 524290 | 34483.4 ± 0.3% | 1564.2 ± 1.6% | 1085.6 ± 0.8% | 558.3 ± 1.0% | 793.7 ± 0.2% | 434.7 ± 1.8% | 22.046 | 31.766 | 61.766 | 43.445 | 79.325 |
| hex: silesia/ooffice | 524290 | 34694.3 ± 0.3% | 1565.6 ± 0.7% | 1082.8 ± 0.4% | 323.2 ± 3.2% | 790.7 ± 1.3% | 437.0 ± 2.3% | 22.160 | 32.043 | 107.347 | 43.877 | 79.391 |
| hex: silesia/osdb | 524290 | 34806.7 ± 1.9% | 1572.3 ± 0.4% | 1088.4 ± 0.2% | 409.7 ± 3.3% | 792.2 ± 16.9% | 433.2 ± 2.6% | 22.137 | 31.980 | 84.958 | 43.934 | 80.340 |
| hex: silesia/reymont | 524290 | 33222.7 ± 14.7% | 1563.1 ± 1.7% | 1085.6 ± 0.6% | 437.2 ± 2.3% | 790.0 ± 0.5% | 437.3 ± 4.1% | 21.255 | 30.604 | 75.986 | 42.054 | 75.974 |
| hex: silesia/samba | 524290 | 33313.3 ± 1.3% | 1567.0 ± 1.5% | 1084.5 ± 1.1% | 330.5 ± 0.8% | 792.4 ± 0.6% | 436.6 ± 1.5% | 21.259 | 30.719 | 100.806 | 42.043 | 76.299 |
| hex: silesia/sao | 524290 | 33403.4 ± 0.5% | 1568.2 ± 2.2% | 1085.2 ± 0.9% | 261.0 ± 2.2% | 791.5 ± 1.7% | 435.0 ± 4.6% | 21.300 | 30.782 | 127.996 | 42.205 | 76.781 |
| hex: silesia/webster | 524290 | 36760.4 ± 0.5% | 1570.4 ± 0.6% | 1087.0 ± 0.5% | 384.8 ± 4.6% | 791.3 ± 1.1% | 431.1 ± 1.5% | 23.408 | 33.819 | 95.522 | 46.458 | 85.280 |
| hex: silesia/x-ray | 524290 | 34883.6 ± 1.3% | 1571.9 ± 4.8% | 1080.7 ± 0.6% | 387.2 ± 2.9% | 789.7 ± 1.1% | 428.2 ± 1.0% | 22.192 | 32.279 | 90.100 | 44.171 | 81.459 |
| hex: silesia/xml | 524290 | 33893.8 ± 0.7% | 1570.1 ± 2.1% | 1085.7 ± 0.4% | 580.7 ± 2.6% | 794.6 ± 0.6% | 426.6 ± 3.6% | 21.586 | 31.220 | 58.367 | 42.655 | 79.450 |
| hex: canterbury/alice29.txt | 304180 | 34350.2 ± 0.8% | 1576.9 ± 4.0% | 1090.3 ± 1.0% | 412.6 ± 2.2% | 800.1 ± 0.3% | 430.5 ± 3.8% | 21.783 | 31.506 | 83.256 | 42.931 | 79.800 |
| hex: canterbury/asyoulik.txt | 250360 | 31068.0 ± 2.2% | 1583.4 ± 0.2% | 1086.1 ± 0.4% | 405.1 ± 2.0% | 799.4 ± 0.5% | 429.2 ± 0.8% | 19.621 | 28.605 | 76.683 | 38.863 | 72.391 |
| hex: canterbury/cp.html | 49208 | 31513.5 ± 0.3% | 1606.0 ± 1.5% | 1109.9 ± 1.1% | 433.9 ± 3.2% | 804.1 ± 1.3% | 432.7 ± 0.8% | 19.623 | 28.392 | 72.634 | 39.189 | 72.830 |
| hex: canterbury/fields.c | 22302 | 31993.8 ± 1.6% | 1573.9 ± 1.0% | 1097.3 ± 2.6% | 511.9 ± 1.8% | 798.8 ± 2.8% | 426.5 ± 1.7% | 20.327 | 29.157 | 62.494 | 40.055 | 75.011 |
| hex: canterbury/grammar.lsp | 7444 | 32387.7 ± 1.4% | 1610.9 ± 1.8% | 1115.6 ± 1.4% | 551.8 ± 4.0% | 799.2 ± 32.3% | 434.0 ± 1.0% | 20.105 | 29.032 | 58.698 | 40.527 | 74.628 |
| hex: canterbury/kennedy.xls | 524290 | 29908.7 ± 5.1% | 1539.4 ± 1.6% | 1070.9 ± 1.9% | 570.3 ± 2.7% | 779.2 ± 2.3% | 423.7 ± 0.8% | 19.429 | 27.928 | 52.442 | 38.386 | 70.584 |
| hex: canterbury/lcet10.txt | 524290 | 32671.9 ± 2.4% | 1547.9 ± 3.1% | 1080.3 ± 1.7% | 407.3 ± 0.8% | 789.8 ± 0.8% | 426.0 ± 1.9% | 21.108 | 30.242 | 80.214 | 41.369 | 76.700 |
| hex: canterbury/plrabn12.txt | 524290 | 33285.8 ± 0.8% | 1564.3 ± 1.3% | 1081.7 ± 1.4% | 403.7 ± 2.2% | 790.2 ± 0.9% | 429.5 ± 2.1% | 21.278 | 30.773 | 82.458 | 42.124 | 77.494 |
| hex: canterbury/ptt5 | 524290 | 33535.7 ± 1.5% | 1565.9 ± 1.2% | 1083.6 ± 6.1% | 491.0 ± 2.8% | 792.5 ± 0.2% | 432.0 ± 3.0% | 21.416 | 30.948 | 68.303 | 42.318 | 77.625 |
| hex: canterbury/sum | 76482 | 35396.3 ± 0.7% | 1596.8 ± 1.7% | 1102.1 ± 1.5% | 486.8 ± 1.4% | 804.8 ± 0.6% | 437.6 ± 2.8% | 22.167 | 32.117 | 72.717 | 43.980 | 80.891 |
| hex: canterbury/xargs.1 | 8456 | 34740.1 ± 0.6% | 1630.1 ± 0.1% | 1122.1 ± 0.8% | 598.5 ± 4.6% | 809.6 ± 0.6% | 439.5 ± 0.2% | 21.311 | 30.959 | 58.046 | 42.908 | 79.044 |
| hex: canterbury-large/E.coli | 524290 | 30453.3 ± 6.1% | 1558.2 ± 4.3% | 1081.9 ± 0.7% | 606.4 ± 1.1% | 790.5 ± 0.4% | 440.1 ± 2.1% | 19.543 | 28.147 | 50.222 | 38.526 | 69.201 |
| hex: canterbury-large/bible.txt | 524290 | 35371.0 ± 1.2% | 1571.1 ± 10.0% | 1085.8 ± 0.6% | 432.5 ± 1.9% | 791.9 ± 1.7% | 434.3 ± 1.2% | 22.514 | 32.577 | 81.774 | 44.667 | 81.445 |
| hex: canterbury-large/world192.txt | 524290 | 35053.3 ± 0.6% | 1570.3 ± 1.1% | 1084.8 ± 0.8% | 413.6 ± 5.5% | 791.3 ± 0.6% | 431.5 ± 1.7% | 22.323 | 32.313 | 84.761 | 44.297 | 81.232 |
| hex: http/html-1kx1024 | 2099200 | 23778.0 ± 0.7% | 1602.5 ± 1.7% | 1099.8 ± 0.1% | 437.0 ± 4.4% | 802.5 ± 0.7% | 437.8 ± 1.7% | 14.838 | 21.620 | 54.409 | 29.630 | 54.311 |
| hex: http/html-16kx64 | 2097280 | 29460.6 ± 1.8% | 1603.0 ± 1.3% | 1112.0 ± 0.4% | 431.8 ± 2.6% | 804.4 ± 0.2% | 439.3 ± 3.3% | 18.379 | 26.493 | 68.235 | 36.624 | 67.061 |
| hex: http/html-1m | 524290 | 29138.1 ± 0.8% | 1562.5 ± 0.6% | 1082.8 ± 0.9% | 431.8 ± 9.0% | 788.6 ± 0.4% | 430.4 ± 2.0% | 18.649 | 26.909 | 67.479 | 36.951 | 67.696 |
| hex: http/json-1kx1024 | 2099200 | 23956.6 ± 0.9% | 1607.5 ± 0.3% | 1098.5 ± 0.3% | 556.8 ± 2.6% | 803.6 ± 0.4% | 432.4 ± 3.8% | 14.903 | 21.808 | 43.027 | 29.812 | 55.398 |
| hex: http/json-16kx64 | 2097280 | 29801.5 ± 2.4% | 1600.6 ± 0.3% | 1108.2 ± 0.4% | 521.8 ± 2.5% | 760.2 ± 0.6% | 436.6 ± 2.3% | 18.619 | 26.891 | 57.114 | 39.200 | 68.264 |
| hex: http/json-1m | 524290 | 31433.0 ± 0.6% | 1560.4 ± 2.2% | 1083.6 ± 1.1% | 583.1 ± 2.3% | 785.6 ± 0.5% | 431.5 ± 2.8% | 20.144 | 29.009 | 53.910 | 40.010 | 72.850 |
| hex: http/js-1kx1024 | 2099200 | 23792.2 ± 2.1% | 1605.7 ± 0.2% | 1087.4 ± 0.3% | 422.1 ± 2.8% | 802.1 ± 0.1% | 433.3 ± 1.6% | 14.818 | 21.880 | 56.366 | 29.662 | 54.912 |
| hex: http/js-16kx64 | 2097280 | 29763.9 ± 1.8% | 1594.4 ± 1.8% | 1109.1 ± 0.4% | 405.2 ± 1.6% | 759.4 ± 0.4% | 439.5 ± 1.8% | 18.667 | 26.836 | 73.460 | 39.193 | 67.722 |
| hex: http/js-1m | 524290 | 30503.4 ± 1.6% | 1561.8 ± 0.5% | 1083.0 ± 1.5% | 424.9 ± 2.4% | 781.8 ± 0.6% | 430.0 ± 2.4% | 19.531 | 28.166 | 71.782 | 39.015 | 70.946 |
| hex: http/css-1kx1024 | 2099200 | 23858.1 ± 0.6% | 1604.9 ± 4.4% | 1097.8 ± 1.8% | 489.0 ± 1.6% | 803.2 ± 16.2% | 437.6 ± 1.3% | 14.866 | 21.734 | 48.793 | 29.705 | 54.519 |
| hex: http/css-16kx64 | 2097280 | 29957.5 ± 0.6% | 1603.5 ± 0.6% | 1109.2 ± 0.5% | 474.9 ± 3.0% | 760.5 ± 0.6% | 441.9 ± 2.9% | 18.683 | 27.009 | 63.082 | 39.392 | 67.790 |
| hex: http/css-1m | 524290 | 31621.7 ± 0.3% | 1563.4 ± 0.6% | 1082.8 ± 0.6% | 450.0 ± 1.3% | 784.3 ± 1.5% | 432.8 ± 2.4% | 20.226 | 29.204 | 70.270 | 40.320 | 73.062 |
| hex: shuffled/dickens-1m | 524290 | 34610.2 ± 0.9% | 1560.6 ± 0.4% | 1084.8 ± 0.9% | 421.7 ± 0.8% | 779.0 ± 7.5% | 437.8 ± 1.9% | 22.177 | 31.906 | 82.078 | 44.426 | 79.048 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1371.3 ± 7.3% | 1136.5 ± 0.6% | 847.6 ± 1.6% | 327.6 ± 2.2% | 351.1 ± 1.8% | 306.6 ± 2.3% | 1.207 | 1.618 | 4.186 | 3.906 | 4.472 |
| qlog records, JSON text sequence | 1467503 | 1143.3 ± 2.1% | 851.0 ± 2.1% | 683.7 ± 1.9% | 308.5 ± 6.0% | 367.5 ± 0.7% | 222.1 ± 9.3% | 1.343 | 1.672 | 3.706 | 3.111 | 5.147 |
| string: silesia/dickens | 172528 | 9079.7 ± 0.6% | 2985.4 ± 3.2% | 2103.3 ± 1.1% | 344.6 ± 0.6% | 1049.7 ± 0.9% | 556.5 ± 0.2% | 3.041 | 4.317 | 26.345 | 8.650 | 16.315 |
| string: silesia/nci | 1075110 | 8936.6 ± 0.4% | 3194.4 ± 0.5% | 2826.7 ± 10.8% | 772.7 ± 0.8% | 1105.2 ± 1.0% | 558.4 ± 0.9% | 2.798 | 3.162 | 11.565 | 8.086 | 16.003 |
| string: silesia/reymont | 1075159 | 3854.7 ± 1.2% | 1638.4 ± 0.7% | 1792.6 ± 10.4% | 348.0 ± 1.0% | 965.9 ± 0.6% | 548.9 ± 0.3% | 2.353 | 2.150 | 11.078 | 3.991 | 7.023 |
| string: silesia/samba | 97582 | 4724.9 ± 5.2% | 1906.8 ± 1.6% | 2245.2 ± 1.3% | 290.6 ± 3.8% | 911.5 ± 9.2% | 620.3 ± 0.2% | 2.478 | 2.104 | 16.256 | 5.184 | 7.617 |
| string: silesia/webster | 1098490 | 5107.7 ± 0.9% | 1615.5 ± 1.4% | 1583.5 ± 0.4% | 354.5 ± 1.7% | 942.0 ± 2.3% | 454.0 ± 1.1% | 3.162 | 3.226 | 14.407 | 5.422 | 11.251 |
| string: silesia/xml | 1090118 | 8184.0 ± 0.7% | 2680.2 ± 0.9% | 2247.2 ± 0.5% | 538.2 ± 1.2% | 1134.1 ± 0.8% | 559.1 ± 0.6% | 3.053 | 3.642 | 15.207 | 7.216 | 14.638 |
| string: canterbury/alice29.txt | 159425 | 9786.6 ± 0.2% | 2423.6 ± 3.4% | 1913.4 ± 3.2% | 336.8 ± 0.5% | 1047.1 ± 0.9% | 550.5 ± 4.7% | 4.038 | 5.115 | 29.059 | 9.347 | 17.777 |
| string: canterbury/asyoulik.txt | 132198 | 8858.6 ± 0.6% | 2164.9 ± 4.9% | 1643.5 ± 0.9% | 343.0 ± 3.2% | 914.7 ± 1.3% | 539.3 ± 0.8% | 4.092 | 5.390 | 25.825 | 9.685 | 16.425 |
| string: canterbury/lcet10.txt | 441884 | 8574.0 ± 0.7% | 2459.1 ± 0.6% | 2050.7 ± 0.2% | 385.1 ± 1.4% | 1031.5 ± 2.1% | 548.4 ± 1.3% | 3.487 | 4.181 | 22.266 | 8.312 | 15.634 |
| string: canterbury/plrabn12.txt | 503330 | 6440.3 ± 0.3% | 1828.2 ± 12.9% | 1749.9 ± 0.6% | 356.1 ± 0.6% | 1000.1 ± 1.1% | 554.3 ± 0.3% | 3.523 | 3.680 | 18.085 | 6.440 | 11.618 |
| string: canterbury-large/E.coli | 1048578 | 38556.5 ± 0.5% | 10876.0 ± 0.7% | 3321.5 ± 0.3% | 1417.8 ± 1.5% | 1439.1 ± 4.3% | 568.2 ± 1.1% | 3.545 | 11.608 | 27.195 | 26.792 | 67.855 |
| string: canterbury-large/bible.txt | 1055886 | 7326.5 ± 0.3% | 3938.6 ± 0.9% | 2718.8 ± 17.5% | 429.4 ± 4.7% | 1210.7 ± 1.8% | 563.7 ± 0.6% | 1.860 | 2.695 | 17.064 | 6.052 | 12.996 |
| string: canterbury-large/world192.txt | 1103121 | 4807.2 ± 1.1% | 1435.5 ± 0.9% | 1684.9 ± 1.0% | 361.6 ± 3.5% | 922.1 ± 0.5% | 535.8 ± 0.5% | 3.349 | 2.853 | 13.294 | 5.213 | 8.973 |
| string: http/html-1m | 1058582 | 8689.3 ± 0.5% | 3855.6 ± 1.2% | 2498.0 ± 0.1% | 389.9 ± 0.6% | 1202.1 ± 1.3% | 516.5 ± 2.8% | 2.254 | 3.478 | 22.288 | 7.229 | 16.825 |
| string: http/json-1m | 1190272 | 6994.9 ± 0.3% | 1224.6 ± 1.0% | 1282.1 ± 0.3% | 373.8 ± 0.3% | 774.0 ± 2.8% | 503.3 ± 16.6% | 5.712 | 5.456 | 18.715 | 9.037 | 13.899 |
| string: http/js-1m | 1144362 | 5093.6 ± 0.4% | 979.2 ± 1.4% | 1222.4 ± 3.8% | 283.1 ± 13.6% | 784.8 ± 2.3% | 471.8 ± 0.4% | 5.202 | 4.167 | 17.992 | 6.490 | 10.796 |
| string: http/css-1m | 1097820 | 7296.3 ± 1.3% | 1287.7 ± 1.2% | 1601.7 ± 0.4% | 401.1 ± 1.5% | 863.8 ± 1.9% | 526.6 ± 1.0% | 5.666 | 4.555 | 18.189 | 8.447 | 13.854 |
| string: dickens as Cyrillic and CJK | 1883069 | 5385.4 ± 0.5% | 3031.9 ± 1.5% | 339.9 ± 0.7% | 268.6 ± 0.5% | 410.4 ± 0.8% | 290.8 ± 0.5% | 1.776 | 15.844 | 20.050 | 13.122 | 18.522 |
| hex: silesia/dickens | 524290 | 30917.2 ± 0.5% | 1556.3 ± 2.8% | 1083.6 ± 3.0% | 412.8 ± 6.0% | 791.1 ± 1.0% | 434.6 ± 2.3% | 19.866 | 28.532 | 74.890 | 39.082 | 71.138 |
| hex: silesia/mozilla | 524290 | 35623.1 ± 0.4% | 1567.3 ± 1.6% | 1085.4 ± 0.3% | 359.6 ± 4.3% | 791.0 ± 0.6% | 428.5 ± 1.3% | 22.729 | 32.822 | 99.063 | 45.037 | 83.125 |
| hex: silesia/mr | 524290 | 35005.6 ± 0.6% | 1567.6 ± 0.7% | 1086.1 ± 0.6% | 493.3 ± 1.8% | 788.7 ± 1.9% | 431.6 ± 1.2% | 22.331 | 32.229 | 70.957 | 44.382 | 81.097 |
| hex: silesia/nci | 524290 | 34902.2 ± 0.7% | 1564.2 ± 1.6% | 1085.6 ± 0.8% | 558.3 ± 1.0% | 793.7 ± 0.2% | 434.7 ± 1.8% | 22.313 | 32.151 | 62.517 | 43.972 | 80.289 |
| hex: silesia/ooffice | 524290 | 35055.2 ± 0.5% | 1565.6 ± 0.7% | 1082.8 ± 0.4% | 323.2 ± 3.2% | 790.7 ± 1.3% | 437.0 ± 2.3% | 22.391 | 32.376 | 108.464 | 44.334 | 80.217 |
| hex: silesia/osdb | 524290 | 35214.6 ± 0.6% | 1572.3 ± 0.4% | 1088.4 ± 0.2% | 409.7 ± 3.3% | 792.2 ± 16.9% | 433.2 ± 2.6% | 22.397 | 32.355 | 85.953 | 44.449 | 81.282 |
| hex: silesia/reymont | 524290 | 33494.2 ± 0.1% | 1563.1 ± 1.7% | 1085.6 ± 0.6% | 437.2 ± 2.3% | 790.0 ± 0.5% | 437.3 ± 4.1% | 21.428 | 30.854 | 76.607 | 42.398 | 76.595 |
| hex: silesia/samba | 524290 | 33832.7 ± 2.1% | 1567.0 ± 1.5% | 1084.5 ± 1.1% | 330.5 ± 0.8% | 792.4 ± 0.6% | 436.6 ± 1.5% | 21.591 | 31.198 | 102.378 | 42.699 | 77.489 |
| hex: silesia/sao | 524290 | 33790.3 ± 1.8% | 1568.2 ± 2.2% | 1085.2 ± 0.9% | 261.0 ± 2.2% | 791.5 ± 1.7% | 435.0 ± 4.6% | 21.547 | 31.138 | 129.478 | 42.693 | 77.671 |
| hex: silesia/webster | 524290 | 37508.1 ± 0.8% | 1570.4 ± 0.6% | 1087.0 ± 0.5% | 384.8 ± 4.6% | 791.3 ± 1.1% | 431.1 ± 1.5% | 23.884 | 34.507 | 97.465 | 47.403 | 87.015 |
| hex: silesia/x-ray | 524290 | 35471.5 ± 0.7% | 1571.9 ± 4.8% | 1080.7 ± 0.6% | 387.2 ± 2.9% | 789.7 ± 1.1% | 428.2 ± 1.0% | 22.566 | 32.822 | 91.618 | 44.916 | 82.832 |
| hex: silesia/xml | 524290 | 34441.5 ± 1.4% | 1570.1 ± 2.1% | 1085.7 ± 0.4% | 580.7 ± 2.6% | 794.6 ± 0.6% | 426.6 ± 3.6% | 21.935 | 31.724 | 59.310 | 43.344 | 80.733 |
| hex: canterbury/alice29.txt | 304180 | 34531.5 ± 0.8% | 1576.9 ± 4.0% | 1090.3 ± 1.0% | 412.6 ± 2.2% | 800.1 ± 0.3% | 430.5 ± 3.8% | 21.898 | 31.672 | 83.696 | 43.158 | 80.221 |
| hex: canterbury/asyoulik.txt | 250360 | 31158.0 ± 1.1% | 1583.4 ± 0.2% | 1086.1 ± 0.4% | 405.1 ± 2.0% | 799.4 ± 0.5% | 429.2 ± 0.8% | 19.678 | 28.688 | 76.905 | 38.976 | 72.601 |
| hex: canterbury/cp.html | 49208 | 31627.0 ± 0.4% | 1606.0 ± 1.5% | 1109.9 ± 1.1% | 433.9 ± 3.2% | 804.1 ± 1.3% | 432.7 ± 0.8% | 19.693 | 28.494 | 72.896 | 39.330 | 73.093 |
| hex: canterbury/fields.c | 22302 | 32244.8 ± 2.3% | 1573.9 ± 1.0% | 1097.3 ± 2.6% | 511.9 ± 1.8% | 798.8 ± 2.8% | 426.5 ± 1.7% | 20.487 | 29.386 | 62.984 | 40.369 | 75.599 |
| hex: canterbury/grammar.lsp | 7444 | 32844.9 ± 2.7% | 1610.9 ± 1.8% | 1115.6 ± 1.4% | 551.8 ± 4.0% | 799.2 ± 32.3% | 434.0 ± 1.0% | 20.389 | 29.442 | 59.527 | 41.099 | 75.682 |
| hex: canterbury/kennedy.xls | 524290 | 30450.9 ± 2.8% | 1539.4 ± 1.6% | 1070.9 ± 1.9% | 570.3 ± 2.7% | 779.2 ± 2.3% | 423.7 ± 0.8% | 19.781 | 28.434 | 53.393 | 39.082 | 71.864 |
| hex: canterbury/lcet10.txt | 524290 | 32868.9 ± 2.3% | 1547.9 ± 3.1% | 1080.3 ± 1.7% | 407.3 ± 0.8% | 789.8 ± 0.8% | 426.0 ± 1.9% | 21.235 | 30.425 | 80.698 | 41.619 | 77.163 |
| hex: canterbury/plrabn12.txt | 524290 | 33779.8 ± 0.4% | 1564.3 ± 1.3% | 1081.7 ± 1.4% | 403.7 ± 2.2% | 790.2 ± 0.9% | 429.5 ± 2.1% | 21.594 | 31.229 | 83.682 | 42.749 | 78.644 |
| hex: canterbury/ptt5 | 524290 | 34129.0 ± 0.6% | 1565.9 ± 1.2% | 1083.6 ± 6.1% | 491.0 ± 2.8% | 792.5 ± 0.2% | 432.0 ± 3.0% | 21.795 | 31.496 | 69.511 | 43.066 | 78.999 |
| hex: canterbury/sum | 76482 | 35509.3 ± 13.4% | 1596.8 ± 1.7% | 1102.1 ± 1.5% | 486.8 ± 1.4% | 804.8 ± 0.6% | 437.6 ± 2.8% | 22.238 | 32.220 | 72.949 | 44.120 | 81.149 |
| hex: canterbury/xargs.1 | 8456 | 35065.8 ± 0.6% | 1630.1 ± 0.1% | 1122.1 ± 0.8% | 598.5 ± 4.6% | 809.6 ± 0.6% | 439.5 ± 0.2% | 21.511 | 31.249 | 58.590 | 43.310 | 79.785 |
| hex: canterbury-large/E.coli | 524290 | 30755.8 ± 0.5% | 1558.2 ± 4.3% | 1081.9 ± 0.7% | 606.4 ± 1.1% | 790.5 ± 0.4% | 440.1 ± 2.1% | 19.738 | 28.427 | 50.721 | 38.909 | 69.888 |
| hex: canterbury-large/bible.txt | 524290 | 35863.7 ± 0.5% | 1571.1 ± 10.0% | 1085.8 ± 0.6% | 432.5 ± 1.9% | 791.9 ± 1.7% | 434.3 ± 1.2% | 22.827 | 33.030 | 82.913 | 45.289 | 82.580 |
| hex: canterbury-large/world192.txt | 524290 | 35535.2 ± 0.5% | 1570.3 ± 1.1% | 1084.8 ± 0.8% | 413.6 ± 5.5% | 791.3 ± 0.6% | 431.5 ± 1.7% | 22.630 | 32.757 | 85.926 | 44.906 | 82.349 |
| hex: http/html-1kx1024 | 2099200 | 23813.4 ± 1.0% | 1602.5 ± 1.7% | 1099.8 ± 0.1% | 437.0 ± 4.4% | 802.5 ± 0.7% | 437.8 ± 1.7% | 14.860 | 21.652 | 54.490 | 29.674 | 54.392 |
| hex: http/html-16kx64 | 2097280 | 30319.1 ± 0.3% | 1603.0 ± 1.3% | 1112.0 ± 0.4% | 431.8 ± 2.6% | 804.4 ± 0.2% | 439.3 ± 3.3% | 18.914 | 27.265 | 70.223 | 37.691 | 69.015 |
| hex: http/html-1m | 524290 | 29392.8 ± 1.1% | 1562.5 ± 0.6% | 1082.8 ± 0.9% | 431.8 ± 9.0% | 788.6 ± 0.4% | 430.4 ± 2.0% | 18.812 | 27.144 | 68.068 | 37.274 | 68.287 |
| hex: http/json-1kx1024 | 2099200 | 24000.9 ± 1.3% | 1607.5 ± 0.3% | 1098.5 ± 0.3% | 556.8 ± 2.6% | 803.6 ± 0.4% | 432.4 ± 3.8% | 14.931 | 21.848 | 43.107 | 29.867 | 55.501 |
| hex: http/json-16kx64 | 2097280 | 30407.4 ± 1.1% | 1600.6 ± 0.3% | 1108.2 ± 0.4% | 521.8 ± 2.5% | 760.2 ± 0.6% | 436.6 ± 2.3% | 18.997 | 27.438 | 58.275 | 39.997 | 69.652 |
| hex: http/json-1m | 524290 | 31800.7 ± 0.5% | 1560.4 ± 2.2% | 1083.6 ± 1.1% | 583.1 ± 2.3% | 785.6 ± 0.5% | 431.5 ± 2.8% | 20.380 | 29.349 | 54.541 | 40.478 | 73.702 |
| hex: http/js-1kx1024 | 2099200 | 24495.7 ± 0.5% | 1605.7 ± 0.2% | 1087.4 ± 0.3% | 422.1 ± 2.8% | 802.1 ± 0.1% | 433.3 ± 1.6% | 15.256 | 22.527 | 58.033 | 30.539 | 56.535 |
| hex: http/js-16kx64 | 2097280 | 30475.8 ± 0.8% | 1594.4 ± 1.8% | 1109.1 ± 0.4% | 405.2 ± 1.6% | 759.4 ± 0.4% | 439.5 ± 1.8% | 19.114 | 27.478 | 75.217 | 40.130 | 69.342 |
| hex: http/js-1m | 524290 | 30676.9 ± 0.6% | 1561.8 ± 0.5% | 1083.0 ± 1.5% | 424.9 ± 2.4% | 781.8 ± 0.6% | 430.0 ± 2.4% | 19.642 | 28.326 | 72.190 | 39.237 | 71.349 |
| hex: http/css-1kx1024 | 2099200 | 24334.9 ± 2.5% | 1604.9 ± 4.4% | 1097.8 ± 1.8% | 489.0 ± 1.6% | 803.2 ± 16.2% | 437.6 ± 1.3% | 15.163 | 22.168 | 49.768 | 30.298 | 55.609 |
| hex: http/css-16kx64 | 2097280 | 30322.4 ± 0.5% | 1603.5 ± 0.6% | 1109.2 ± 0.5% | 474.9 ± 3.0% | 760.5 ± 0.6% | 441.9 ± 2.9% | 18.910 | 27.338 | 63.850 | 39.872 | 68.616 |
| hex: http/css-1m | 524290 | 31840.3 ± 3.3% | 1563.4 ± 0.6% | 1082.8 ± 0.6% | 450.0 ± 1.3% | 784.3 ± 1.5% | 432.8 ± 2.4% | 20.366 | 29.406 | 70.756 | 40.599 | 73.567 |
| hex: shuffled/dickens-1m | 524290 | 35196.6 ± 0.4% | 1560.6 ± 0.4% | 1084.8 ± 0.9% | 421.7 ± 0.8% | 779.0 ± 7.5% | 437.8 ± 1.9% | 22.553 | 32.446 | 83.469 | 45.179 | 80.388 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 831.9 ± 1.9% | 1006.6 ± 1.0% | 956.7 ± 1.4% | 285.4 ± 20.5% | 532.4 ± 2.1% | 254.6 ± 3.2% | 0.826 | 0.869 | 2.915 | 1.562 | 3.268 |
| qlog records, JSON text sequence | 1467503 | 714.7 ± 8.4% | 805.5 ± 0.3% | 744.6 ± 6.8% | 226.3 ± 3.8% | 527.0 ± 26.4% | 219.2 ± 4.9% | 0.887 | 0.960 | 3.159 | 1.356 | 3.261 |
| string: silesia/dickens | 172528 | 5281.9 ± 0.4% | 2876.3 ± 0.6% | 2065.0 ± 0.7% | 302.2 ± 1.1% | 2182.0 ± 10.1% | 459.7 ± 7.5% | 1.836 | 2.558 | 17.478 | 2.421 | 11.490 |
| string: silesia/nci | 1075110 | 5225.8 ± 0.5% | 3464.1 ± 0.3% | 2771.9 ± 1.9% | 499.3 ± 1.3% | 2421.1 ± 1.1% | 499.7 ± 1.7% | 1.509 | 1.885 | 10.465 | 2.158 | 10.458 |
| string: silesia/reymont | 1075159 | 2723.8 ± 1.7% | 2187.8 ± 0.4% | 1786.3 ± 5.6% | 317.8 ± 0.9% | 1667.9 ± 1.8% | 445.5 ± 1.6% | 1.245 | 1.525 | 8.570 | 1.633 | 6.113 |
| string: silesia/samba | 97582 | 3290.4 ± 0.2% | 2770.0 ± 1.5% | 1714.3 ± 5.4% | 258.4 ± 0.4% | 1339.5 ± 9.9% | 335.3 ± 3.3% | 1.188 | 1.919 | 12.732 | 2.456 | 9.814 |
| string: silesia/webster | 1098490 | 3572.2 ± 2.7% | 2023.5 ± 1.2% | 1643.1 ± 2.8% | 307.4 ± 14.4% | 1670.2 ± 1.1% | 424.0 ± 4.5% | 1.765 | 2.174 | 11.620 | 2.139 | 8.424 |
| string: silesia/xml | 1090118 | 4999.0 ± 0.8% | 3656.8 ± 1.8% | 2129.2 ± 2.3% | 406.6 ± 0.9% | 2368.5 ± 1.3% | 493.6 ± 4.1% | 1.367 | 2.348 | 12.295 | 2.111 | 10.127 |
| string: canterbury/alice29.txt | 159425 | 4288.8 ± 0.3% | 2380.9 ± 4.2% | 1840.5 ± 5.5% | 284.4 ± 2.3% | 1931.2 ± 0.6% | 435.2 ± 5.2% | 1.801 | 2.330 | 15.078 | 2.221 | 9.855 |
| string: canterbury/asyoulik.txt | 132198 | 3701.6 ± 4.2% | 2109.2 ± 0.7% | 1490.4 ± 2.8% | 274.3 ± 1.1% | 1571.7 ± 0.6% | 384.9 ± 2.0% | 1.755 | 2.484 | 13.496 | 2.355 | 9.617 |
| string: canterbury/lcet10.txt | 441884 | 5522.6 ± 0.7% | 2773.3 ± 0.7% | 1959.9 ± 3.4% | 325.6 ± 1.2% | 2153.9 ± 15.1% | 467.0 ± 7.2% | 1.991 | 2.818 | 16.962 | 2.564 | 11.826 |
| string: canterbury/plrabn12.txt | 503330 | 4546.8 ± 0.6% | 2691.9 ± 2.2% | 1667.1 ± 0.9% | 298.0 ± 0.4% | 2025.8 ± 7.4% | 432.0 ± 8.0% | 1.689 | 2.727 | 15.256 | 2.245 | 10.524 |
| string: canterbury-large/E.coli | 1048578 | 33604.2 ± 0.4% | 7759.3 ± 0.7% | 3476.9 ± 0.8% | 798.2 ± 0.3% | 5325.4 ± 1.7% | 780.4 ± 2.1% | 4.331 | 9.665 | 42.101 | 6.310 | 43.062 |
| string: canterbury-large/bible.txt | 1055886 | 6550.4 ± 0.6% | 3905.6 ± 2.1% | 2571.1 ± 0.8% | 351.3 ± 4.0% | 3015.5 ± 3.2% | 579.4 ± 1.9% | 1.677 | 2.548 | 18.646 | 2.172 | 11.305 |
| string: canterbury-large/world192.txt | 1103121 | 3334.5 ± 0.4% | 1975.4 ± 1.3% | 1633.6 ± 5.7% | 296.1 ± 1.5% | 1679.2 ± 0.8% | 420.5 ± 3.8% | 1.688 | 2.041 | 11.260 | 1.986 | 7.931 |
| string: http/html-1m | 1058582 | 6185.1 ± 1.1% | 3394.7 ± 0.7% | 2390.7 ± 1.4% | 406.9 ± 2.0% | 2760.5 ± 0.5% | 412.8 ± 15.6% | 1.822 | 2.587 | 15.201 | 2.241 | 14.982 |
| string: http/json-1m | 1190272 | 3330.8 ± 19.4% | 1198.6 ± 0.7% | 1543.8 ± 6.8% | 356.0 ± 0.6% | 841.6 ± 16.7% | 286.7 ± 1.5% | 2.779 | 2.157 | 9.357 | 3.958 | 11.618 |
| string: http/js-1m | 1144362 | 2198.2 ± 8.1% | 1326.1 ± 0.5% | 1148.1 ± 1.5% | 278.4 ± 2.7% | 1167.0 ± 1.7% | 283.3 ± 1.2% | 1.658 | 1.915 | 7.896 | 1.884 | 7.760 |
| string: http/css-1m | 1097820 | 2943.5 ± 4.5% | 2504.7 ± 1.4% | 1554.1 ± 1.0% | 372.2 ± 0.4% | 1555.3 ± 2.2% | 319.6 ± 15.8% | 1.175 | 1.894 | 7.909 | 1.893 | 9.211 |
| string: dickens as Cyrillic and CJK | 1883069 | 5212.7 ± 1.2% | 3169.7 ± 2.3% | 692.9 ± 0.8% | 254.2 ± 16.0% | 499.6 ± 3.9% | 133.9 ± 1.7% | 1.645 | 7.524 | 20.510 | 10.433 | 38.938 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1059.8 ± 2.0% | 1070.1 ± 0.6% | 842.6 ± 1.5% | 157.0 ± 0.5% | 384.3 ± 3.7% | 197.8 ± 3.6% | 0.990 | 1.258 | 6.750 | 2.757 | 5.358 |
| hex: silesia/dickens | 524290 | 33367.9 ± 0.5% | 7747.2 ± 0.5% | 3459.4 ± 1.1% | 451.1 ± 3.1% | 5276.7 ± 1.2% | 761.0 ± 3.2% | 4.307 | 9.646 | 73.973 | 6.324 | 43.850 |
| hex: silesia/mozilla | 524290 | 33428.4 ± 0.7% | 7749.0 ± 0.7% | 3501.6 ± 2.3% | 406.3 ± 8.0% | 5316.3 ± 2.5% | 772.2 ± 1.1% | 4.314 | 9.547 | 82.283 | 6.288 | 43.291 |
| hex: silesia/mr | 524290 | 33337.4 ± 0.4% | 7757.0 ± 0.6% | 3500.9 ± 0.6% | 581.4 ± 0.3% | 5346.9 ± 0.8% | 782.5 ± 2.1% | 4.298 | 9.523 | 57.338 | 6.235 | 42.602 |
| hex: silesia/nci | 524290 | 33406.5 ± 0.5% | 7759.6 ± 1.5% | 3487.4 ± 1.1% | 642.7 ± 1.5% | 5315.3 ± 2.0% | 770.7 ± 2.5% | 4.305 | 9.579 | 51.975 | 6.285 | 43.345 |
| hex: silesia/ooffice | 524290 | 33440.1 ± 0.7% | 7768.5 ± 0.3% | 3472.6 ± 1.6% | 355.6 ± 0.5% | 5333.5 ± 1.6% | 755.8 ± 6.7% | 4.305 | 9.630 | 94.040 | 6.270 | 44.242 |
| hex: silesia/osdb | 524290 | 33417.1 ± 1.9% | 7753.6 ± 0.9% | 3471.1 ± 1.6% | 447.2 ± 2.8% | 5337.4 ± 1.1% | 759.6 ± 7.7% | 4.310 | 9.627 | 74.722 | 6.261 | 43.993 |
| hex: silesia/reymont | 524290 | 33513.2 ± 0.6% | 7765.8 ± 0.5% | 3448.8 ± 1.1% | 470.3 ± 4.2% | 5297.3 ± 0.6% | 769.2 ± 2.4% | 4.315 | 9.717 | 71.256 | 6.326 | 43.572 |
| hex: silesia/samba | 524290 | 33524.7 ± 2.7% | 7759.5 ± 0.4% | 3479.0 ± 4.0% | 350.6 ± 2.8% | 5325.8 ± 1.8% | 765.6 ± 2.3% | 4.320 | 9.636 | 95.632 | 6.295 | 43.791 |
| hex: silesia/sao | 524290 | 33394.6 ± 1.7% | 7758.7 ± 1.0% | 3457.5 ± 0.7% | 287.0 ± 3.2% | 5300.7 ± 1.3% | 771.6 ± 4.8% | 4.304 | 9.659 | 116.373 | 6.300 | 43.280 |
| hex: silesia/webster | 524290 | 33416.2 ± 0.5% | 7753.0 ± 0.4% | 3476.5 ± 9.0% | 432.8 ± 1.7% | 5341.0 ± 3.4% | 768.2 ± 2.0% | 4.310 | 9.612 | 77.213 | 6.257 | 43.501 |
| hex: silesia/x-ray | 524290 | 33555.8 ± 0.4% | 7774.5 ± 0.7% | 3462.3 ± 2.1% | 428.6 ± 5.5% | 5315.3 ± 11.1% | 764.6 ± 2.3% | 4.316 | 9.692 | 78.290 | 6.313 | 43.887 |
| hex: silesia/xml | 524290 | 33575.2 ± 0.9% | 7759.7 ± 1.1% | 3486.9 ± 1.8% | 603.2 ± 0.6% | 5376.6 ± 1.2% | 776.7 ± 2.5% | 4.327 | 9.629 | 55.658 | 6.245 | 43.229 |
| hex: canterbury/alice29.txt | 304180 | 33580.6 ± 0.7% | 7750.7 ± 0.5% | 3493.0 ± 1.7% | 469.4 ± 0.3% | 5311.1 ± 0.3% | 752.6 ± 3.4% | 4.333 | 9.614 | 71.539 | 6.323 | 44.618 |
| hex: canterbury/asyoulik.txt | 250360 | 33319.0 ± 0.5% | 7790.1 ± 2.2% | 3507.5 ± 0.9% | 461.4 ± 0.4% | 5332.6 ± 1.8% | 773.0 ± 2.0% | 4.277 | 9.499 | 72.216 | 6.248 | 43.105 |
| hex: canterbury/cp.html | 49208 | 32597.3 ± 1.4% | 7779.6 ± 0.6% | 3523.2 ± 1.1% | 462.2 ± 0.5% | 5324.7 ± 1.3% | 745.9 ± 4.7% | 4.190 | 9.252 | 70.526 | 6.122 | 43.702 |
| hex: canterbury/fields.c | 22302 | 31482.3 ± 18.3% | 7677.1 ± 3.3% | 3508.5 ± 0.9% | 483.5 ± 2.2% | 5344.3 ± 2.5% | 740.2 ± 6.2% | 4.101 | 8.973 | 65.113 | 5.891 | 42.534 |
| hex: canterbury/grammar.lsp | 7444 | 27400.8 ± 0.6% | 7485.2 ± 0.4% | 3569.2 ± 0.2% | 530.4 ± 4.0% | 5246.3 ± 2.2% | 719.8 ± 10.2% | 3.661 | 7.677 | 51.659 | 5.223 | 38.066 |
| hex: canterbury/kennedy.xls | 524290 | 33202.3 ± 0.7% | 7770.3 ± 0.6% | 3481.4 ± 1.1% | 665.5 ± 4.9% | 5290.3 ± 0.2% | 726.9 ± 15.3% | 4.273 | 9.537 | 49.891 | 6.276 | 45.674 |
| hex: canterbury/lcet10.txt | 524290 | 33332.9 ± 1.0% | 7761.0 ± 0.6% | 3471.1 ± 0.3% | 454.8 ± 1.8% | 5290.5 ± 0.8% | 729.9 ± 2.3% | 4.295 | 9.603 | 73.296 | 6.300 | 45.669 |
| hex: canterbury/plrabn12.txt | 524290 | 33539.0 ± 0.8% | 7727.5 ± 0.8% | 3464.2 ± 1.6% | 439.8 ± 7.6% | 5288.2 ± 1.3% | 730.5 ± 5.1% | 4.340 | 9.682 | 76.257 | 6.342 | 45.911 |
| hex: canterbury/ptt5 | 524290 | 33598.2 ± 0.6% | 7780.7 ± 0.9% | 3476.6 ± 0.4% | 560.7 ± 13.8% | 5249.0 ± 0.7% | 750.9 ± 1.7% | 4.318 | 9.664 | 59.920 | 6.401 | 44.745 |
| hex: canterbury/sum | 76482 | 33186.7 ± 0.1% | 7786.1 ± 0.6% | 3491.1 ± 0.7% | 504.7 ± 0.8% | 5266.2 ± 1.0% | 746.9 ± 1.9% | 4.262 | 9.506 | 65.753 | 6.302 | 44.434 |
| hex: canterbury/xargs.1 | 8456 | 28011.1 ± 3.0% | 7517.6 ± 1.9% | 3540.4 ± 1.0% | 496.1 ± 5.9% | 5211.6 ± 0.5% | 746.3 ± 2.1% | 3.726 | 7.912 | 56.459 | 5.375 | 37.531 |
| hex: canterbury-large/E.coli | 524290 | 33505.0 ± 0.4% | 7777.3 ± 1.3% | 3460.6 ± 1.2% | 709.2 ± 0.6% | 5279.8 ± 1.3% | 757.1 ± 7.1% | 4.308 | 9.682 | 47.244 | 6.346 | 44.256 |
| hex: canterbury-large/bible.txt | 524290 | 33721.3 ± 0.3% | 7724.2 ± 0.2% | 3485.3 ± 0.3% | 487.9 ± 0.3% | 5329.9 ± 13.6% | 771.0 ± 2.4% | 4.366 | 9.675 | 69.111 | 6.327 | 43.738 |
| hex: canterbury-large/world192.txt | 524290 | 33410.5 ± 0.5% | 7780.2 ± 1.2% | 3490.6 ± 4.2% | 454.0 ± 2.9% | 5358.0 ± 1.2% | 772.1 ± 3.2% | 4.294 | 9.572 | 73.599 | 6.236 | 43.274 |
| hex: http/html-1kx1024 | 2099200 | 16686.1 ± 0.7% | 6632.7 ± 0.2% | 3188.7 ± 0.7% | 479.4 ± 0.9% | 4715.4 ± 1.3% | 627.2 ± 18.2% | 2.516 | 5.233 | 34.805 | 3.539 | 26.604 |
| hex: http/html-16kx64 | 2097280 | 30802.0 ± 1.0% | 7635.8 ± 0.8% | 3431.6 ± 0.6% | 494.1 ± 3.5% | 5316.0 ± 2.6% | 721.0 ± 7.1% | 4.034 | 8.976 | 62.337 | 5.794 | 42.724 |
| hex: http/html-1m | 524290 | 33539.5 ± 1.1% | 7760.8 ± 6.0% | 3461.7 ± 2.9% | 486.1 ± 2.5% | 5269.4 ± 0.8% | 751.6 ± 2.5% | 4.322 | 9.689 | 69.001 | 6.365 | 44.624 |
| hex: http/json-1kx1024 | 2099200 | 16777.2 ± 1.6% | 6621.6 ± 1.4% | 3181.5 ± 1.1% | 609.6 ± 2.0% | 4772.8 ± 2.2% | 628.2 ± 3.9% | 2.534 | 5.273 | 27.522 | 3.515 | 26.709 |
| hex: http/json-16kx64 | 2097280 | 30904.1 ± 1.1% | 7655.7 ± 0.3% | 3411.9 ± 9.1% | 631.2 ± 1.8% | 5347.7 ± 1.2% | 705.3 ± 13.9% | 4.037 | 9.058 | 48.962 | 5.779 | 43.817 |
| hex: http/json-1m | 524290 | 33555.1 ± 0.5% | 7717.0 ± 1.9% | 3483.0 ± 1.2% | 642.8 ± 0.6% | 5380.4 ± 0.9% | 761.9 ± 4.4% | 4.348 | 9.634 | 52.200 | 6.237 | 44.040 |
| hex: http/js-1kx1024 | 2099200 | 16477.6 ± 1.3% | 6634.8 ± 0.8% | 3171.9 ± 1.4% | 464.5 ± 2.3% | 4709.3 ± 4.4% | 613.3 ± 8.5% | 2.484 | 5.195 | 35.476 | 3.499 | 26.867 |
| hex: http/js-16kx64 | 2097280 | 30913.1 ± 1.1% | 7631.1 ± 1.1% | 3447.1 ± 0.6% | 460.3 ± 5.2% | 5341.7 ± 1.5% | 704.9 ± 12.9% | 4.051 | 8.968 | 67.161 | 5.787 | 43.857 |
| hex: http/js-1m | 524290 | 33256.3 ± 1.0% | 7712.0 ± 2.0% | 3473.7 ± 2.4% | 471.0 ± 3.0% | 5283.5 ± 5.8% | 720.8 ± 12.9% | 4.312 | 9.574 | 70.607 | 6.294 | 46.136 |
| hex: http/css-1kx1024 | 2099200 | 16662.2 ± 8.2% | 6636.5 ± 0.2% | 3184.6 ± 1.3% | 528.7 ± 2.7% | 4753.7 ± 2.4% | 625.2 ± 4.2% | 2.511 | 5.232 | 31.517 | 3.505 | 26.650 |
| hex: http/css-16kx64 | 2097280 | 30843.3 ± 3.4% | 7670.7 ± 0.8% | 3450.0 ± 0.7% | 549.2 ± 0.6% | 5403.3 ± 2.5% | 747.7 ± 1.6% | 4.021 | 8.940 | 56.162 | 5.708 | 41.249 |
| hex: http/css-1m | 524290 | 33334.0 ± 3.4% | 7770.1 ± 0.9% | 3490.2 ± 0.6% | 531.9 ± 0.5% | 5306.3 ± 14.3% | 765.9 ± 2.6% | 4.290 | 9.551 | 62.673 | 6.282 | 43.521 |
| hex: shuffled/dickens-1m | 524290 | 33581.7 ± 0.4% | 7728.0 ± 1.2% | 3454.9 ± 0.7% | 461.8 ± 2.6% | 5312.0 ± 2.9% | 749.3 ± 2.6% | 4.345 | 9.720 | 72.717 | 6.322 | 44.819 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 981.5 ± 3.4% | 1006.6 ± 1.0% | 956.7 ± 1.4% | 285.4 ± 20.5% | 532.4 ± 2.1% | 254.6 ± 3.2% | 0.975 | 1.026 | 3.439 | 1.844 | 3.855 |
| qlog records, JSON text sequence | 1467503 | 849.4 ± 13.3% | 805.5 ± 0.3% | 744.6 ± 6.8% | 226.3 ± 3.8% | 527.0 ± 26.4% | 219.2 ± 4.9% | 1.055 | 1.141 | 3.754 | 1.612 | 3.875 |
| string: silesia/dickens | 172528 | 5265.7 ± 1.7% | 2876.3 ± 0.6% | 2065.0 ± 0.7% | 302.2 ± 1.1% | 2182.0 ± 10.1% | 459.7 ± 7.5% | 1.831 | 2.550 | 17.425 | 2.413 | 11.455 |
| string: silesia/nci | 1075110 | 5218.5 ± 0.5% | 3464.1 ± 0.3% | 2771.9 ± 1.9% | 499.3 ± 1.3% | 2421.1 ± 1.1% | 499.7 ± 1.7% | 1.506 | 1.883 | 10.451 | 2.155 | 10.443 |
| string: silesia/reymont | 1075159 | 2709.8 ± 2.3% | 2187.8 ± 0.4% | 1786.3 ± 5.6% | 317.8 ± 0.9% | 1667.9 ± 1.8% | 445.5 ± 1.6% | 1.239 | 1.517 | 8.526 | 1.625 | 6.082 |
| string: silesia/samba | 97582 | 3290.8 ± 1.0% | 2770.0 ± 1.5% | 1714.3 ± 5.4% | 258.4 ± 0.4% | 1339.5 ± 9.9% | 335.3 ± 3.3% | 1.188 | 1.920 | 12.734 | 2.457 | 9.815 |
| string: silesia/webster | 1098490 | 3582.8 ± 0.4% | 2023.5 ± 1.2% | 1643.1 ± 2.8% | 307.4 ± 14.4% | 1670.2 ± 1.1% | 424.0 ± 4.5% | 1.771 | 2.181 | 11.654 | 2.145 | 8.449 |
| string: silesia/xml | 1090118 | 4985.6 ± 2.3% | 3656.8 ± 1.8% | 2129.2 ± 2.3% | 406.6 ± 0.9% | 2368.5 ± 1.3% | 493.6 ± 4.1% | 1.363 | 2.342 | 12.262 | 2.105 | 10.100 |
| string: canterbury/alice29.txt | 159425 | 4294.1 ± 0.4% | 2380.9 ± 4.2% | 1840.5 ± 5.5% | 284.4 ± 2.3% | 1931.2 ± 0.6% | 435.2 ± 5.2% | 1.804 | 2.333 | 15.097 | 2.224 | 9.868 |
| string: canterbury/asyoulik.txt | 132198 | 3598.6 ± 4.6% | 2109.2 ± 0.7% | 1490.4 ± 2.8% | 274.3 ± 1.1% | 1571.7 ± 0.6% | 384.9 ± 2.0% | 1.706 | 2.415 | 13.121 | 2.290 | 9.350 |
| string: canterbury/lcet10.txt | 441884 | 5544.5 ± 0.2% | 2773.3 ± 0.7% | 1959.9 ± 3.4% | 325.6 ± 1.2% | 2153.9 ± 15.1% | 467.0 ± 7.2% | 1.999 | 2.829 | 17.029 | 2.574 | 11.873 |
| string: canterbury/plrabn12.txt | 503330 | 4560.4 ± 0.5% | 2691.9 ± 2.2% | 1667.1 ± 0.9% | 298.0 ± 0.4% | 2025.8 ± 7.4% | 432.0 ± 8.0% | 1.694 | 2.735 | 15.302 | 2.251 | 10.556 |
| string: canterbury-large/E.coli | 1048578 | 33690.4 ± 0.4% | 7759.3 ± 0.7% | 3476.9 ± 0.8% | 798.2 ± 0.3% | 5325.4 ± 1.7% | 780.4 ± 2.1% | 4.342 | 9.690 | 42.209 | 6.326 | 43.172 |
| string: canterbury-large/bible.txt | 1055886 | 6538.6 ± 0.9% | 3905.6 ± 2.1% | 2571.1 ± 0.8% | 351.3 ± 4.0% | 3015.5 ± 3.2% | 579.4 ± 1.9% | 1.674 | 2.543 | 18.613 | 2.168 | 11.285 |
| string: canterbury-large/world192.txt | 1103121 | 3334.6 ± 0.3% | 1975.4 ± 1.3% | 1633.6 ± 5.7% | 296.1 ± 1.5% | 1679.2 ± 0.8% | 420.5 ± 3.8% | 1.688 | 2.041 | 11.260 | 1.986 | 7.931 |
| string: http/html-1m | 1058582 | 6181.3 ± 0.4% | 3394.7 ± 0.7% | 2390.7 ± 1.4% | 406.9 ± 2.0% | 2760.5 ± 0.5% | 412.8 ± 15.6% | 1.821 | 2.586 | 15.191 | 2.239 | 14.973 |
| string: http/json-1m | 1190272 | 3324.1 ± 1.4% | 1198.6 ± 0.7% | 1543.8 ± 6.8% | 356.0 ± 0.6% | 841.6 ± 16.7% | 286.7 ± 1.5% | 2.773 | 2.153 | 9.338 | 3.950 | 11.595 |
| string: http/js-1m | 1144362 | 2206.9 ± 1.0% | 1326.1 ± 0.5% | 1148.1 ± 1.5% | 278.4 ± 2.7% | 1167.0 ± 1.7% | 283.3 ± 1.2% | 1.664 | 1.922 | 7.927 | 1.891 | 7.791 |
| string: http/css-1m | 1097820 | 2952.1 ± 0.5% | 2504.7 ± 1.4% | 1554.1 ± 1.0% | 372.2 ± 0.4% | 1555.3 ± 2.2% | 319.6 ± 15.8% | 1.179 | 1.900 | 7.932 | 1.898 | 9.238 |
| string: dickens as Cyrillic and CJK | 1883069 | 5223.6 ± 0.5% | 3169.7 ± 2.3% | 692.9 ± 0.8% | 254.2 ± 16.0% | 499.6 ± 3.9% | 133.9 ± 1.7% | 1.648 | 7.539 | 20.553 | 10.455 | 39.019 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1062.3 ± 0.4% | 1070.1 ± 0.6% | 842.6 ± 1.5% | 157.0 ± 0.5% | 384.3 ± 3.7% | 197.8 ± 3.6% | 0.993 | 1.261 | 6.766 | 2.764 | 5.370 |
| hex: silesia/dickens | 524290 | 33347.9 ± 0.6% | 7747.2 ± 0.5% | 3459.4 ± 1.1% | 451.1 ± 3.1% | 5276.7 ± 1.2% | 761.0 ± 3.2% | 4.304 | 9.640 | 73.929 | 6.320 | 43.823 |
| hex: silesia/mozilla | 524290 | 33414.6 ± 0.4% | 7749.0 ± 0.7% | 3501.6 ± 2.3% | 406.3 ± 8.0% | 5316.3 ± 2.5% | 772.2 ± 1.1% | 4.312 | 9.543 | 82.250 | 6.285 | 43.274 |
| hex: silesia/mr | 524290 | 33359.5 ± 0.6% | 7757.0 ± 0.6% | 3500.9 ± 0.6% | 581.4 ± 0.3% | 5346.9 ± 0.8% | 782.5 ± 2.1% | 4.301 | 9.529 | 57.376 | 6.239 | 42.630 |
| hex: silesia/nci | 524290 | 33430.4 ± 0.7% | 7759.6 ± 1.5% | 3487.4 ± 1.1% | 642.7 ± 1.5% | 5315.3 ± 2.0% | 770.7 ± 2.5% | 4.308 | 9.586 | 52.012 | 6.289 | 43.376 |
| hex: silesia/ooffice | 524290 | 33383.9 ± 0.4% | 7768.5 ± 0.3% | 3472.6 ± 1.6% | 355.6 ± 0.5% | 5333.5 ± 1.6% | 755.8 ± 6.7% | 4.297 | 9.613 | 93.882 | 6.259 | 44.168 |
| hex: silesia/osdb | 524290 | 33280.2 ± 1.1% | 7753.6 ± 0.9% | 3471.1 ± 1.6% | 447.2 ± 2.8% | 5337.4 ± 1.1% | 759.6 ± 7.7% | 4.292 | 9.588 | 74.416 | 6.235 | 43.812 |
| hex: silesia/reymont | 524290 | 33461.4 ± 1.2% | 7765.8 ± 0.5% | 3448.8 ± 1.1% | 470.3 ± 4.2% | 5297.3 ± 0.6% | 769.2 ± 2.4% | 4.309 | 9.702 | 71.146 | 6.317 | 43.504 |
| hex: silesia/samba | 524290 | 33442.1 ± 0.1% | 7759.5 ± 0.4% | 3479.0 ± 4.0% | 350.6 ± 2.8% | 5325.8 ± 1.8% | 765.6 ± 2.3% | 4.310 | 9.613 | 95.396 | 6.279 | 43.683 |
| hex: silesia/sao | 524290 | 33378.3 ± 0.4% | 7758.7 ± 1.0% | 3457.5 ± 0.7% | 287.0 ± 3.2% | 5300.7 ± 1.3% | 771.6 ± 4.8% | 4.302 | 9.654 | 116.316 | 6.297 | 43.259 |
| hex: silesia/webster | 524290 | 33459.3 ± 0.4% | 7753.0 ± 0.4% | 3476.5 ± 9.0% | 432.8 ± 1.7% | 5341.0 ± 3.4% | 768.2 ± 2.0% | 4.316 | 9.624 | 77.313 | 6.265 | 43.557 |
| hex: silesia/x-ray | 524290 | 33436.6 ± 0.3% | 7774.5 ± 0.7% | 3462.3 ± 2.1% | 428.6 ± 5.5% | 5315.3 ± 11.1% | 764.6 ± 2.3% | 4.301 | 9.657 | 78.012 | 6.291 | 43.731 |
| hex: silesia/xml | 524290 | 33654.5 ± 0.4% | 7759.7 ± 1.1% | 3486.9 ± 1.8% | 603.2 ± 0.6% | 5376.6 ± 1.2% | 776.7 ± 2.5% | 4.337 | 9.652 | 55.790 | 6.259 | 43.331 |
| hex: canterbury/alice29.txt | 304180 | 33741.1 ± 0.2% | 7750.7 ± 0.5% | 3493.0 ± 1.7% | 469.4 ± 0.3% | 5311.1 ± 0.3% | 752.6 ± 3.4% | 4.353 | 9.660 | 71.881 | 6.353 | 44.831 |
| hex: canterbury/asyoulik.txt | 250360 | 33553.6 ± 0.5% | 7790.1 ± 2.2% | 3507.5 ± 0.9% | 461.4 ± 0.4% | 5332.6 ± 1.8% | 773.0 ± 2.0% | 4.307 | 9.566 | 72.724 | 6.292 | 43.408 |
| hex: canterbury/cp.html | 49208 | 32748.0 ± 0.3% | 7779.6 ± 0.6% | 3523.2 ± 1.1% | 462.2 ± 0.5% | 5324.7 ± 1.3% | 745.9 ± 4.7% | 4.209 | 9.295 | 70.852 | 6.150 | 43.904 |
| hex: canterbury/fields.c | 22302 | 31764.2 ± 0.5% | 7677.1 ± 3.3% | 3508.5 ± 0.9% | 483.5 ± 2.2% | 5344.3 ± 2.5% | 740.2 ± 6.2% | 4.138 | 9.053 | 65.696 | 5.944 | 42.914 |
| hex: canterbury/grammar.lsp | 7444 | 27748.4 ± 13.1% | 7485.2 ± 0.4% | 3569.2 ± 0.2% | 530.4 ± 4.0% | 5246.3 ± 2.2% | 719.8 ± 10.2% | 3.707 | 7.774 | 52.315 | 5.289 | 38.549 |
| hex: canterbury/kennedy.xls | 524290 | 33313.7 ± 0.8% | 7770.3 ± 0.6% | 3481.4 ± 1.1% | 665.5 ± 4.9% | 5290.3 ± 0.2% | 726.9 ± 15.3% | 4.287 | 9.569 | 50.058 | 6.297 | 45.827 |
| hex: canterbury/lcet10.txt | 524290 | 33311.8 ± 1.5% | 7761.0 ± 0.6% | 3471.1 ± 0.3% | 454.8 ± 1.8% | 5290.5 ± 0.8% | 729.9 ± 2.3% | 4.292 | 9.597 | 73.250 | 6.296 | 45.640 |
| hex: canterbury/plrabn12.txt | 524290 | 33425.6 ± 0.7% | 7727.5 ± 0.8% | 3464.2 ± 1.6% | 439.8 ± 7.6% | 5288.2 ± 1.3% | 730.5 ± 5.1% | 4.326 | 9.649 | 75.999 | 6.321 | 45.756 |
| hex: canterbury/ptt5 | 524290 | 33562.4 ± 0.8% | 7780.7 ± 0.9% | 3476.6 ± 0.4% | 560.7 ± 13.8% | 5249.0 ± 0.7% | 750.9 ± 1.7% | 4.314 | 9.654 | 59.857 | 6.394 | 44.697 |
| hex: canterbury/sum | 76482 | 33265.1 ± 0.4% | 7786.1 ± 0.6% | 3491.1 ± 0.7% | 504.7 ± 0.8% | 5266.2 ± 1.0% | 746.9 ± 1.9% | 4.272 | 9.529 | 65.908 | 6.317 | 44.539 |
| hex: canterbury/xargs.1 | 8456 | 28352.7 ± 8.4% | 7517.6 ± 1.9% | 3540.4 ± 1.0% | 496.1 ± 5.9% | 5211.6 ± 0.5% | 746.3 ± 2.1% | 3.771 | 8.008 | 57.148 | 5.440 | 37.989 |
| hex: canterbury-large/E.coli | 524290 | 33386.9 ± 7.1% | 7777.3 ± 1.3% | 3460.6 ± 1.2% | 709.2 ± 0.6% | 5279.8 ± 1.3% | 757.1 ± 7.1% | 4.293 | 9.648 | 47.078 | 6.324 | 44.100 |
| hex: canterbury-large/bible.txt | 524290 | 33709.1 ± 1.8% | 7724.2 ± 0.2% | 3485.3 ± 0.3% | 487.9 ± 0.3% | 5329.9 ± 13.6% | 771.0 ± 2.4% | 4.364 | 9.672 | 69.086 | 6.324 | 43.722 |
| hex: canterbury-large/world192.txt | 524290 | 33497.9 ± 0.4% | 7780.2 ± 1.2% | 3490.6 ± 4.2% | 454.0 ± 2.9% | 5358.0 ± 1.2% | 772.1 ± 3.2% | 4.306 | 9.597 | 73.791 | 6.252 | 43.388 |
| hex: http/html-1kx1024 | 2099200 | 17009.1 ± 2.7% | 6632.7 ± 0.2% | 3188.7 ± 0.7% | 479.4 ± 0.9% | 4715.4 ± 1.3% | 627.2 ± 18.2% | 2.564 | 5.334 | 35.479 | 3.607 | 27.119 |
| hex: http/html-16kx64 | 2097280 | 30717.5 ± 0.5% | 7635.8 ± 0.8% | 3431.6 ± 0.6% | 494.1 ± 3.5% | 5316.0 ± 2.6% | 721.0 ± 7.1% | 4.023 | 8.951 | 62.166 | 5.778 | 42.607 |
| hex: http/html-1m | 524290 | 33510.3 ± 0.3% | 7760.8 ± 6.0% | 3461.7 ± 2.9% | 486.1 ± 2.5% | 5269.4 ± 0.8% | 751.6 ± 2.5% | 4.318 | 9.680 | 68.941 | 6.359 | 44.585 |
| hex: http/json-1kx1024 | 2099200 | 17012.5 ± 1.2% | 6621.6 ± 1.4% | 3181.5 ± 1.1% | 609.6 ± 2.0% | 4772.8 ± 2.2% | 628.2 ± 3.9% | 2.569 | 5.347 | 27.908 | 3.564 | 27.083 |
| hex: http/json-16kx64 | 2097280 | 30812.5 ± 0.5% | 7655.7 ± 0.3% | 3411.9 ± 9.1% | 631.2 ± 1.8% | 5347.7 ± 1.2% | 705.3 ± 13.9% | 4.025 | 9.031 | 48.817 | 5.762 | 43.687 |
| hex: http/json-1m | 524290 | 33455.3 ± 10.6% | 7717.0 ± 1.9% | 3483.0 ± 1.2% | 642.8 ± 0.6% | 5380.4 ± 0.9% | 761.9 ± 4.4% | 4.335 | 9.605 | 52.044 | 6.218 | 43.909 |
| hex: http/js-1kx1024 | 2099200 | 17007.2 ± 1.1% | 6634.8 ± 0.8% | 3171.9 ± 1.4% | 464.5 ± 2.3% | 4709.3 ± 4.4% | 613.3 ± 8.5% | 2.563 | 5.362 | 36.616 | 3.611 | 27.731 |
| hex: http/js-16kx64 | 2097280 | 30845.5 ± 0.4% | 7631.1 ± 1.1% | 3447.1 ± 0.6% | 460.3 ± 5.2% | 5341.7 ± 1.5% | 704.9 ± 12.9% | 4.042 | 8.948 | 67.015 | 5.775 | 43.761 |
| hex: http/js-1m | 524290 | 33123.7 ± 1.5% | 7712.0 ± 2.0% | 3473.7 ± 2.4% | 471.0 ± 3.0% | 5283.5 ± 5.8% | 720.8 ± 12.9% | 4.295 | 9.536 | 70.326 | 6.269 | 45.952 |
| hex: http/css-1kx1024 | 2099200 | 17154.9 ± 1.4% | 6636.5 ± 0.2% | 3184.6 ± 1.3% | 528.7 ± 2.7% | 4753.7 ± 2.4% | 625.2 ± 4.2% | 2.585 | 5.387 | 32.449 | 3.609 | 27.438 |
| hex: http/css-16kx64 | 2097280 | 30866.0 ± 0.7% | 7670.7 ± 0.8% | 3450.0 ± 0.7% | 549.2 ± 0.6% | 5403.3 ± 2.5% | 747.7 ± 1.6% | 4.024 | 8.947 | 56.203 | 5.712 | 41.279 |
| hex: http/css-1m | 524290 | 33245.5 ± 1.0% | 7770.1 ± 0.9% | 3490.2 ± 0.6% | 531.9 ± 0.5% | 5306.3 ± 14.3% | 765.9 ± 2.6% | 4.279 | 9.525 | 62.506 | 6.265 | 43.405 |
| hex: shuffled/dickens-1m | 524290 | 33562.0 ± 0.5% | 7728.0 ± 1.2% | 3454.9 ± 0.7% | 461.8 ± 2.6% | 5312.0 ± 2.9% | 749.3 ± 2.6% | 4.343 | 9.714 | 72.674 | 6.318 | 44.792 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1133.4 ± 0.7% | 1136.5 ± 0.6% | 847.6 ± 1.6% | 327.6 ± 2.2% | 351.1 ± 1.8% | 306.6 ± 2.3% | 0.997 | 1.337 | 3.460 | 3.228 | 3.697 |
| qlog records, JSON text sequence | 1467503 | 956.5 ± 1.6% | 851.0 ± 2.1% | 683.7 ± 1.9% | 308.5 ± 6.0% | 367.5 ± 0.7% | 222.1 ± 9.3% | 1.124 | 1.399 | 3.101 | 2.603 | 4.306 |
| string: silesia/dickens | 172528 | 8832.7 ± 0.6% | 2985.4 ± 3.2% | 2103.3 ± 1.1% | 344.6 ± 0.6% | 1049.7 ± 0.9% | 556.5 ± 0.2% | 2.959 | 4.199 | 25.628 | 8.415 | 15.871 |
| string: silesia/nci | 1075110 | 8762.7 ± 1.6% | 3194.4 ± 0.5% | 2826.7 ± 10.8% | 772.7 ± 0.8% | 1105.2 ± 1.0% | 558.4 ± 0.9% | 2.743 | 3.100 | 11.340 | 7.928 | 15.692 |
| string: silesia/reymont | 1075159 | 3838.2 ± 0.5% | 1638.4 ± 0.7% | 1792.6 ± 10.4% | 348.0 ± 1.0% | 965.9 ± 0.6% | 548.9 ± 0.3% | 2.343 | 2.141 | 11.031 | 3.974 | 6.993 |
| string: silesia/samba | 97582 | 4299.5 ± 0.6% | 1906.8 ± 1.6% | 2245.2 ± 1.3% | 290.6 ± 3.8% | 911.5 ± 9.2% | 620.3 ± 0.2% | 2.255 | 1.915 | 14.793 | 4.717 | 6.931 |
| string: silesia/webster | 1098490 | 5103.5 ± 4.2% | 1615.5 ± 1.4% | 1583.5 ± 0.4% | 354.5 ± 1.7% | 942.0 ± 2.3% | 454.0 ± 1.1% | 3.159 | 3.223 | 14.396 | 5.418 | 11.242 |
| string: silesia/xml | 1090118 | 7917.0 ± 4.9% | 2680.2 ± 0.9% | 2247.2 ± 0.5% | 538.2 ± 1.2% | 1134.1 ± 0.8% | 559.1 ± 0.6% | 2.954 | 3.523 | 14.710 | 6.981 | 14.160 |
| string: canterbury/alice29.txt | 159425 | 9501.6 ± 8.8% | 2423.6 ± 3.4% | 1913.4 ± 3.2% | 336.8 ± 0.5% | 1047.1 ± 0.9% | 550.5 ± 4.7% | 3.920 | 4.966 | 28.212 | 9.075 | 17.260 |
| string: canterbury/asyoulik.txt | 132198 | 8544.4 ± 0.9% | 2164.9 ± 4.9% | 1643.5 ± 0.9% | 343.0 ± 3.2% | 914.7 ± 1.3% | 539.3 ± 0.8% | 3.947 | 5.199 | 24.909 | 9.342 | 15.843 |
| string: canterbury/lcet10.txt | 441884 | 8181.5 ± 9.9% | 2459.1 ± 0.6% | 2050.7 ± 0.2% | 385.1 ± 1.4% | 1031.5 ± 2.1% | 548.4 ± 1.3% | 3.327 | 3.990 | 21.247 | 7.932 | 14.918 |
| string: canterbury/plrabn12.txt | 503330 | 6124.3 ± 0.4% | 1828.2 ± 12.9% | 1749.9 ± 0.6% | 356.1 ± 0.6% | 1000.1 ± 1.1% | 554.3 ± 0.3% | 3.350 | 3.500 | 17.198 | 6.124 | 11.048 |
| string: canterbury-large/E.coli | 1048578 | 38586.0 ± 1.1% | 10876.0 ± 0.7% | 3321.5 ± 0.3% | 1417.8 ± 1.5% | 1439.1 ± 4.3% | 568.2 ± 1.1% | 3.548 | 11.617 | 27.216 | 26.813 | 67.907 |
| string: canterbury-large/bible.txt | 1055886 | 6976.9 ± 1.1% | 3938.6 ± 0.9% | 2718.8 ± 17.5% | 429.4 ± 4.7% | 1210.7 ± 1.8% | 563.7 ± 0.6% | 1.771 | 2.566 | 16.249 | 5.763 | 12.376 |
| string: canterbury-large/world192.txt | 1103121 | 4896.2 ± 1.0% | 1435.5 ± 0.9% | 1684.9 ± 1.0% | 361.6 ± 3.5% | 922.1 ± 0.5% | 535.8 ± 0.5% | 3.411 | 2.906 | 13.540 | 5.310 | 9.139 |
| string: http/html-1m | 1058582 | 8629.5 ± 0.8% | 3855.6 ± 1.2% | 2498.0 ± 0.1% | 389.9 ± 0.6% | 1202.1 ± 1.3% | 516.5 ± 2.8% | 2.238 | 3.455 | 22.134 | 7.179 | 16.709 |
| string: http/json-1m | 1190272 | 6823.9 ± 1.6% | 1224.6 ± 1.0% | 1282.1 ± 0.3% | 373.8 ± 0.3% | 774.0 ± 2.8% | 503.3 ± 16.6% | 5.572 | 5.323 | 18.258 | 8.816 | 13.559 |
| string: http/js-1m | 1144362 | 5141.0 ± 0.3% | 979.2 ± 1.4% | 1222.4 ± 3.8% | 283.1 ± 13.6% | 784.8 ± 2.3% | 471.8 ± 0.4% | 5.250 | 4.206 | 18.159 | 6.551 | 10.897 |
| string: http/css-1m | 1097820 | 6911.4 ± 0.4% | 1287.7 ± 1.2% | 1601.7 ± 0.4% | 401.1 ± 1.5% | 863.8 ± 1.9% | 526.6 ± 1.0% | 5.367 | 4.315 | 17.229 | 8.001 | 13.123 |
| string: dickens as Cyrillic and CJK | 1883069 | 5336.2 ± 0.7% | 3031.9 ± 1.5% | 339.9 ± 0.7% | 268.6 ± 0.5% | 410.4 ± 0.8% | 290.8 ± 0.5% | 1.760 | 15.699 | 19.867 | 13.002 | 18.353 |
| hex: silesia/dickens | 524290 | 30891.3 ± 0.9% | 1556.3 ± 2.8% | 1083.6 ± 3.0% | 412.8 ± 6.0% | 791.1 ± 1.0% | 434.6 ± 2.3% | 19.850 | 28.508 | 74.827 | 39.049 | 71.078 |
| hex: silesia/mozilla | 524290 | 35765.8 ± 0.8% | 1567.3 ± 1.6% | 1085.4 ± 0.3% | 359.6 ± 4.3% | 791.0 ± 0.6% | 428.5 ± 1.3% | 22.820 | 32.953 | 99.459 | 45.218 | 83.458 |
| hex: silesia/mr | 524290 | 34978.8 ± 0.3% | 1567.6 ± 0.7% | 1086.1 ± 0.6% | 493.3 ± 1.8% | 788.7 ± 1.9% | 431.6 ± 1.2% | 22.313 | 32.205 | 70.902 | 44.348 | 81.035 |
| hex: silesia/nci | 524290 | 34780.9 ± 0.8% | 1564.2 ± 1.6% | 1085.6 ± 0.8% | 558.3 ± 1.0% | 793.7 ± 0.2% | 434.7 ± 1.8% | 22.236 | 32.040 | 62.299 | 43.820 | 80.010 |
| hex: silesia/ooffice | 524290 | 35058.9 ± 0.4% | 1565.6 ± 0.7% | 1082.8 ± 0.4% | 323.2 ± 3.2% | 790.7 ± 1.3% | 437.0 ± 2.3% | 22.393 | 32.379 | 108.475 | 44.339 | 80.226 |
| hex: silesia/osdb | 524290 | 35222.2 ± 0.4% | 1572.3 ± 0.4% | 1088.4 ± 0.2% | 409.7 ± 3.3% | 792.2 ± 16.9% | 433.2 ± 2.6% | 22.402 | 32.362 | 85.972 | 44.459 | 81.299 |
| hex: silesia/reymont | 524290 | 33554.6 ± 0.4% | 1563.1 ± 1.7% | 1085.6 ± 0.6% | 437.2 ± 2.3% | 790.0 ± 0.5% | 437.3 ± 4.1% | 21.467 | 30.910 | 76.746 | 42.475 | 76.733 |
| hex: silesia/samba | 524290 | 33831.3 ± 0.4% | 1567.0 ± 1.5% | 1084.5 ± 1.1% | 330.5 ± 0.8% | 792.4 ± 0.6% | 436.6 ± 1.5% | 21.590 | 31.197 | 102.374 | 42.697 | 77.485 |
| hex: silesia/sao | 524290 | 33798.1 ± 0.3% | 1568.2 ± 2.2% | 1085.2 ± 0.9% | 261.0 ± 2.2% | 791.5 ± 1.7% | 435.0 ± 4.6% | 21.552 | 31.145 | 129.508 | 42.703 | 77.689 |
| hex: silesia/webster | 524290 | 37324.7 ± 2.1% | 1570.4 ± 0.6% | 1087.0 ± 0.5% | 384.8 ± 4.6% | 791.3 ± 1.1% | 431.1 ± 1.5% | 23.768 | 34.338 | 96.989 | 47.171 | 86.589 |
| hex: silesia/x-ray | 524290 | 35361.8 ± 0.6% | 1571.9 ± 4.8% | 1080.7 ± 0.6% | 387.2 ± 2.9% | 789.7 ± 1.1% | 428.2 ± 1.0% | 22.496 | 32.721 | 91.335 | 44.777 | 82.576 |
| hex: silesia/xml | 524290 | 34437.7 ± 1.0% | 1570.1 ± 2.1% | 1085.7 ± 0.4% | 580.7 ± 2.6% | 794.6 ± 0.6% | 426.6 ± 3.6% | 21.933 | 31.721 | 59.304 | 43.340 | 80.725 |
| hex: canterbury/alice29.txt | 304180 | 34681.3 ± 1.1% | 1576.9 ± 4.0% | 1090.3 ± 1.0% | 412.6 ± 2.2% | 800.1 ± 0.3% | 430.5 ± 3.8% | 21.993 | 31.809 | 84.059 | 43.345 | 80.569 |
| hex: canterbury/asyoulik.txt | 250360 | 31170.3 ± 1.5% | 1583.4 ± 0.2% | 1086.1 ± 0.4% | 405.1 ± 2.0% | 799.4 ± 0.5% | 429.2 ± 0.8% | 19.685 | 28.700 | 76.936 | 38.991 | 72.630 |
| hex: canterbury/cp.html | 49208 | 31830.7 ± 0.5% | 1606.0 ± 1.5% | 1109.9 ± 1.1% | 433.9 ± 3.2% | 804.1 ± 1.3% | 432.7 ± 0.8% | 19.820 | 28.678 | 73.365 | 39.584 | 73.564 |
| hex: canterbury/fields.c | 22302 | 32497.5 ± 2.2% | 1573.9 ± 1.0% | 1097.3 ± 2.6% | 511.9 ± 1.8% | 798.8 ± 2.8% | 426.5 ± 1.7% | 20.647 | 29.616 | 63.478 | 40.685 | 76.192 |
| hex: canterbury/grammar.lsp | 7444 | 33291.3 ± 1.3% | 1610.9 ± 1.8% | 1115.6 ± 1.4% | 551.8 ± 4.0% | 799.2 ± 32.3% | 434.0 ± 1.0% | 20.666 | 29.842 | 60.336 | 41.657 | 76.710 |
| hex: canterbury/kennedy.xls | 524290 | 30280.1 ± 1.8% | 1539.4 ± 1.6% | 1070.9 ± 1.9% | 570.3 ± 2.7% | 779.2 ± 2.3% | 423.7 ± 0.8% | 19.670 | 28.275 | 53.094 | 38.863 | 71.461 |
| hex: canterbury/lcet10.txt | 524290 | 33043.2 ± 2.8% | 1547.9 ± 3.1% | 1080.3 ± 1.7% | 407.3 ± 0.8% | 789.8 ± 0.8% | 426.0 ± 1.9% | 21.348 | 30.586 | 81.126 | 41.840 | 77.572 |
| hex: canterbury/plrabn12.txt | 524290 | 33704.4 ± 0.4% | 1564.3 ± 1.3% | 1081.7 ± 1.4% | 403.7 ± 2.2% | 790.2 ± 0.9% | 429.5 ± 2.1% | 21.546 | 31.159 | 83.495 | 42.654 | 78.469 |
| hex: canterbury/ptt5 | 524290 | 34077.9 ± 0.5% | 1565.9 ± 1.2% | 1083.6 ± 6.1% | 491.0 ± 2.8% | 792.5 ± 0.2% | 432.0 ± 3.0% | 21.762 | 31.449 | 69.407 | 43.002 | 78.880 |
| hex: canterbury/sum | 76482 | 35455.3 ± 0.2% | 1596.8 ± 1.7% | 1102.1 ± 1.5% | 486.8 ± 1.4% | 804.8 ± 0.6% | 437.6 ± 2.8% | 22.204 | 32.171 | 72.838 | 44.053 | 81.026 |
| hex: canterbury/xargs.1 | 8456 | 35704.5 ± 2.0% | 1630.1 ± 0.1% | 1122.1 ± 0.8% | 598.5 ± 4.6% | 809.6 ± 0.6% | 439.5 ± 0.2% | 21.903 | 31.819 | 59.657 | 44.099 | 81.238 |
| hex: canterbury-large/E.coli | 524290 | 30680.3 ± 1.8% | 1558.2 ± 4.3% | 1081.9 ± 0.7% | 606.4 ± 1.1% | 790.5 ± 0.4% | 440.1 ± 2.1% | 19.689 | 28.357 | 50.596 | 38.813 | 69.716 |
| hex: canterbury-large/bible.txt | 524290 | 35869.1 ± 0.5% | 1571.1 ± 10.0% | 1085.8 ± 0.6% | 432.5 ± 1.9% | 791.9 ± 1.7% | 434.3 ± 1.2% | 22.831 | 33.035 | 82.925 | 45.296 | 82.592 |
| hex: canterbury-large/world192.txt | 524290 | 35385.4 ± 0.9% | 1570.3 ± 1.1% | 1084.8 ± 0.8% | 413.6 ± 5.5% | 791.3 ± 0.6% | 431.5 ± 1.7% | 22.534 | 32.619 | 85.564 | 44.717 | 82.002 |
| hex: http/html-1kx1024 | 2099200 | 24576.7 ± 2.7% | 1602.5 ± 1.7% | 1099.8 ± 0.1% | 437.0 ± 4.4% | 802.5 ± 0.7% | 437.8 ± 1.7% | 15.336 | 22.346 | 56.237 | 30.625 | 56.135 |
| hex: http/html-16kx64 | 2097280 | 30432.9 ± 0.6% | 1603.0 ± 1.3% | 1112.0 ± 0.4% | 431.8 ± 2.6% | 804.4 ± 0.2% | 439.3 ± 3.3% | 18.985 | 27.368 | 70.487 | 37.832 | 69.274 |
| hex: http/html-1m | 524290 | 29338.6 ± 1.4% | 1562.5 ± 0.6% | 1082.8 ± 0.9% | 431.8 ± 9.0% | 788.6 ± 0.4% | 430.4 ± 2.0% | 18.777 | 27.094 | 67.943 | 37.205 | 68.162 |
| hex: http/json-1kx1024 | 2099200 | 24710.1 ± 0.9% | 1607.5 ± 0.3% | 1098.5 ± 0.3% | 556.8 ± 2.6% | 803.6 ± 0.4% | 432.4 ± 3.8% | 15.372 | 22.494 | 44.381 | 30.750 | 57.141 |
| hex: http/json-16kx64 | 2097280 | 30546.3 ± 0.6% | 1600.6 ± 0.3% | 1108.2 ± 0.4% | 521.8 ± 2.5% | 760.2 ± 0.6% | 436.6 ± 2.3% | 19.084 | 27.563 | 58.541 | 40.180 | 69.970 |
| hex: http/json-1m | 524290 | 31624.2 ± 0.3% | 1560.4 ± 2.2% | 1083.6 ± 1.1% | 583.1 ± 2.3% | 785.6 ± 0.5% | 431.5 ± 2.8% | 20.267 | 29.186 | 54.238 | 40.253 | 73.293 |
| hex: http/js-1kx1024 | 2099200 | 25103.0 ± 0.7% | 1605.7 ± 0.2% | 1087.4 ± 0.3% | 422.1 ± 2.8% | 802.1 ± 0.1% | 433.3 ± 1.6% | 15.634 | 23.086 | 59.472 | 31.296 | 57.937 |
| hex: http/js-16kx64 | 2097280 | 30548.3 ± 0.6% | 1594.4 ± 1.8% | 1109.1 ± 0.4% | 405.2 ± 1.6% | 759.4 ± 0.4% | 439.5 ± 1.8% | 19.159 | 27.544 | 75.395 | 40.225 | 69.507 |
| hex: http/js-1m | 524290 | 30712.1 ± 1.0% | 1561.8 ± 0.5% | 1083.0 ± 1.5% | 424.9 ± 2.4% | 781.8 ± 0.6% | 430.0 ± 2.4% | 19.665 | 28.359 | 72.273 | 39.282 | 71.431 |
| hex: http/css-1kx1024 | 2099200 | 24804.7 ± 2.2% | 1604.9 ± 4.4% | 1097.8 ± 1.8% | 489.0 ± 1.6% | 803.2 ± 16.2% | 437.6 ± 1.3% | 15.456 | 22.596 | 50.729 | 30.883 | 56.683 |
| hex: http/css-16kx64 | 2097280 | 30557.4 ± 17.5% | 1603.5 ± 0.6% | 1109.2 ± 0.5% | 474.9 ± 3.0% | 760.5 ± 0.6% | 441.9 ± 2.9% | 19.057 | 27.550 | 64.345 | 40.181 | 69.148 |
| hex: http/css-1m | 524290 | 31785.7 ± 0.6% | 1563.4 ± 0.6% | 1082.8 ± 0.6% | 450.0 ± 1.3% | 784.3 ± 1.5% | 432.8 ± 2.4% | 20.331 | 29.356 | 70.635 | 40.529 | 73.441 |
| hex: shuffled/dickens-1m | 524290 | 35150.8 ± 7.3% | 1560.6 ± 0.4% | 1084.8 ± 0.9% | 421.7 ± 0.8% | 779.0 ± 7.5% | 437.8 ± 1.9% | 22.524 | 32.404 | 83.361 | 45.120 | 80.283 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.826 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.869 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.887 of simdjson.
