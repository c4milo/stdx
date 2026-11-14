# bench-json

| Field | Value |
|---|---|
| Commit | f607235 |
| Runner label | ubuntu-24.04 |
| Image version | 20261111.370.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43487600712 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1023.6 ± 0.6% | 0.484 | 0.988 | 1.057 | 1.090 | 0.413 | 1.066 | 1.024 | 0.365 | 0.810 | 0.939 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 822.4 ± 4.5% | 0.737 | 1.049 | 1.050 | 1.037 | 0.401 | 1.053 | 1.039 | 0.341 | 0.932 | 1.059 | 0.111 |
| string: silesia/dickens | 172528 | 5493.1 ± 0.3% | 0.025 | 0.652 | 1.023 | 1.042 | 0.177 | 0.999 | 1.043 | 0.177 | 0.999 | 0.982 | 0.025 |
| string: silesia/nci | 1075110 | 5216.4 ± 0.2% | 0.027 | 0.684 | 1.010 | 1.015 | 0.229 | 0.987 | 1.014 | 0.231 | 1.000 | 0.998 | 0.027 |
| string: silesia/reymont | 1075159 | 2782.8 ± 3.8% | 0.050 | 0.687 | 0.973 | 0.979 | 0.341 | 0.967 | 0.974 | 0.344 | 1.004 | 0.995 | 0.050 |
| string: silesia/samba | 97582 | 3354.3 ± 1.3% | 0.036 | 0.888 | 1.018 | 1.020 | 0.066 | 0.833 | 1.022 | 0.066 | 1.003 | 1.005 | 0.036 |
| string: silesia/webster | 1098490 | 3659.0 ± 1.4% | 0.037 | 0.671 | 1.027 | 1.052 | 0.193 | 1.018 | 1.051 | 0.193 | 1.010 | 1.010 | 0.037 |
| string: silesia/xml | 1090118 | 5138.1 ± 0.4% | 0.027 | 0.847 | 0.996 | 0.996 | 0.217 | 0.984 | 0.996 | 0.217 | 1.001 | 1.005 | 0.027 |
| string: canterbury/alice29.txt | 159425 | 4431.4 ± 3.3% | 0.031 | 0.754 | 0.998 | 1.109 | 0.164 | 1.058 | 1.108 | 0.165 | 1.023 | 1.025 | 0.030 |
| string: canterbury/asyoulik.txt | 132198 | 3812.2 ± 4.5% | 0.035 | 0.807 | 1.066 | 1.125 | 0.161 | 1.024 | 1.118 | 0.162 | 0.982 | 0.992 | 0.035 |
| string: canterbury/lcet10.txt | 441884 | 5700.0 ± 0.7% | 0.024 | 0.573 | 1.043 | 1.061 | 0.162 | 1.015 | 1.058 | 0.163 | 1.001 | 1.000 | 0.024 |
| string: canterbury/plrabn12.txt | 503330 | 4437.4 ± 1.1% | 0.031 | 0.782 | 1.037 | 1.083 | 0.187 | 1.011 | 1.081 | 0.188 | 1.003 | 0.998 | 0.031 |
| string: canterbury-large/E.coli | 1048578 | 26664.3 ± 1.6% | 0.056 | 1.013 | 0.794 | 1.019 | 0.579 | 1.017 | 1.014 | 0.576 | 1.258 | 1.257 | 0.005 |
| string: canterbury-large/bible.txt | 1055886 | 6591.4 ± 1.5% | 0.022 | 0.693 | 0.907 | 0.898 | 0.401 | 0.992 | 0.904 | 0.402 | 1.004 | 1.004 | 0.022 |
| string: canterbury-large/world192.txt | 1103121 | 3440.7 ± 7.1% | 0.039 | 0.703 | 1.031 | 1.061 | 0.185 | 1.017 | 1.059 | 0.187 | 1.013 | 1.012 | 0.039 |
| string: http/html-1m | 1058582 | 6216.5 ± 0.7% | 0.023 | 0.680 | 0.951 | 0.953 | 0.364 | 0.985 | 0.954 | 0.367 | 1.007 | 1.007 | 0.023 |
| string: http/json-1m | 1190272 | 3326.9 ± 0.4% | 0.038 | 0.381 | 0.434 | 0.434 | 0.094 | 0.391 | 0.434 | 0.094 | 1.005 | 1.006 | 0.038 |
| string: http/js-1m | 1144362 | 2255.4 ± 0.4% | 0.057 | 0.777 | 1.024 | 1.059 | 0.175 | 1.011 | 1.062 | 0.175 | 1.002 | 1.002 | 0.057 |
| string: http/css-1m | 1097820 | 2978.4 ± 1.0% | 0.045 | 0.740 | 0.997 | 1.035 | 0.222 | 1.004 | 1.037 | 0.221 | 1.013 | 1.020 | 0.045 |
| string: dickens as Cyrillic and CJK | 1883069 | 5172.1 ± 1.0% | 0.021 | 0.059 | 0.499 | 0.498 | 0.182 | 0.498 | 0.499 | 0.182 | 1.003 | 1.000 | 0.021 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1061.2 ± 1.2% | 0.093 | 0.975 | 0.973 | 0.964 | 0.089 | 0.703 | 0.975 | 0.089 | 0.999 | 1.002 | 0.093 |
| hex: silesia/dickens | 524290 | 28818.8 ± 1.8% | 0.052 | 1.036 | 0.769 | 1.024 | 0.565 | 1.093 | 1.042 | 0.559 | 1.158 | 1.157 | 0.005 |
| hex: silesia/mozilla | 524290 | 29376.5 ± 7.0% | 0.051 | 1.025 | 0.750 | 1.026 | 0.554 | 1.099 | 1.088 | 0.548 | 1.140 | 1.138 | 0.005 |
| hex: silesia/mr | 524290 | 27421.6 ± 3.3% | 0.055 | 1.012 | 0.767 | 1.033 | 0.585 | 1.027 | 1.010 | 0.578 | 1.225 | 1.225 | 0.005 |
| hex: silesia/nci | 524290 | 29932.6 ± 17.5% | 0.050 | 1.084 | 0.737 | 1.007 | 0.543 | 1.023 | 1.070 | 0.535 | 1.110 | 1.113 | 0.005 |
| hex: silesia/ooffice | 524290 | 29439.2 ± 0.8% | 0.051 | 1.068 | 0.747 | 1.028 | 0.555 | 1.025 | 1.028 | 0.548 | 1.142 | 1.139 | 0.005 |
| hex: silesia/osdb | 524290 | 28428.3 ± 1.9% | 0.053 | 1.024 | 0.748 | 1.016 | 0.558 | 1.032 | 1.013 | 0.552 | 1.168 | 1.165 | 0.005 |
| hex: silesia/reymont | 524290 | 29130.4 ± 1.7% | 0.051 | 1.039 | 0.758 | 1.023 | 0.558 | 1.018 | 1.034 | 0.550 | 1.139 | 1.138 | 0.005 |
| hex: silesia/samba | 524290 | 28688.0 ± 0.8% | 0.052 | 1.017 | 0.771 | 1.021 | 0.560 | 1.021 | 1.024 | 0.559 | 1.161 | 1.159 | 0.005 |
| hex: silesia/sao | 524290 | 28847.5 ± 1.7% | 0.052 | 1.011 | 0.761 | 1.005 | 0.559 | 1.011 | 1.011 | 0.554 | 1.160 | 1.157 | 0.005 |
| hex: silesia/webster | 524290 | 28742.8 ± 1.1% | 0.052 | 1.015 | 0.767 | 1.027 | 0.562 | 1.036 | 1.028 | 0.558 | 1.159 | 1.162 | 0.005 |
| hex: silesia/x-ray | 524290 | 29054.2 ± 3.0% | 0.052 | 1.055 | 0.763 | 1.038 | 0.556 | 1.074 | 1.026 | 0.552 | 1.139 | 1.145 | 0.005 |
| hex: silesia/xml | 524290 | 29935.3 ± 2.0% | 0.050 | 1.023 | 0.738 | 1.043 | 0.547 | 1.023 | 1.031 | 0.545 | 1.117 | 1.120 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 34697.7 ± 5.4% | 0.044 | 1.016 | 0.631 | 1.026 | 0.499 | 1.031 | 1.033 | 0.495 | 0.969 | 0.965 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 37675.5 ± 3.2% | 0.041 | 1.008 | 0.578 | 1.012 | 0.483 | 1.013 | 1.012 | 0.484 | 0.892 | 0.892 | 0.004 |
| hex: canterbury/cp.html | 49208 | 39127.2 ± 0.4% | 0.039 | 1.000 | 0.564 | 1.001 | 0.463 | 0.999 | 1.000 | 0.470 | 0.837 | 0.839 | 0.004 |
| hex: canterbury/fields.c | 22302 | 37310.4 ± 5.8% | 0.041 | 1.018 | 0.569 | 1.017 | 0.468 | 1.005 | 1.018 | 0.480 | 0.848 | 0.851 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 36191.1 ± 5.0% | 0.042 | 1.012 | 0.539 | 1.029 | 0.424 | 1.023 | 1.030 | 0.459 | 0.759 | 0.767 | 0.004 |
| hex: canterbury/kennedy.xls | 524290 | 28602.2 ± 9.0% | 0.052 | 1.016 | 0.765 | 1.023 | 0.563 | 1.042 | 1.025 | 0.556 | 1.167 | 1.164 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 28495.2 ± 7.2% | 0.053 | 1.026 | 0.773 | 1.023 | 0.567 | 1.020 | 1.027 | 0.557 | 1.177 | 1.175 | 0.005 |
| hex: canterbury/plrabn12.txt | 524290 | 28776.8 ± 1.7% | 0.052 | 1.024 | 0.770 | 1.031 | 0.557 | 1.035 | 1.036 | 0.554 | 1.164 | 1.162 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 29693.9 ± 3.3% | 0.051 | 1.032 | 0.738 | 1.016 | 0.546 | 1.021 | 1.018 | 0.542 | 1.133 | 1.132 | 0.005 |
| hex: canterbury/sum | 76482 | 40258.2 ± 0.7% | 0.038 | 0.999 | 0.551 | 1.002 | 0.458 | 1.005 | 1.002 | 0.461 | 0.826 | 0.827 | 0.004 |
| hex: canterbury/xargs.1 | 8456 | 37466.9 ± 12.7% | 0.041 | 1.006 | 0.530 | 1.031 | 0.421 | 1.026 | 1.027 | 0.453 | 0.748 | 0.757 | 0.004 |
| hex: canterbury-large/E.coli | 524290 | 28781.2 ± 1.2% | 0.052 | 1.024 | 0.767 | 1.020 | 0.557 | 1.012 | 1.025 | 0.553 | 1.160 | 1.155 | 0.005 |
| hex: canterbury-large/bible.txt | 524290 | 28107.9 ± 1.1% | 0.053 | 1.043 | 0.783 | 1.015 | 0.570 | 1.019 | 1.051 | 0.565 | 1.191 | 1.190 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 28676.7 ± 17.4% | 0.052 | 1.035 | 0.767 | 1.026 | 0.566 | 1.103 | 1.030 | 0.560 | 1.163 | 1.168 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 16133.2 ± 2.4% | 0.092 | 1.034 | 0.812 | 1.038 | 0.598 | 1.033 | 1.043 | 0.699 | 1.008 | 1.034 | 0.009 |
| hex: http/html-16kx64 | 2097280 | 33997.3 ± 10.0% | 0.045 | 1.018 | 0.605 | 1.017 | 0.500 | 1.026 | 1.021 | 0.505 | 0.888 | 0.889 | 0.004 |
| hex: http/html-1m | 524290 | 28467.6 ± 3.5% | 0.053 | 1.019 | 0.771 | 1.023 | 0.562 | 1.023 | 1.024 | 0.560 | 1.167 | 1.160 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 16264.1 ± 2.9% | 0.091 | 1.033 | 0.806 | 1.036 | 0.604 | 1.024 | 1.040 | 0.711 | 1.009 | 1.023 | 0.009 |
| hex: http/json-16kx64 | 2097280 | 34392.8 ± 1.8% | 0.045 | 1.020 | 0.605 | 1.029 | 0.499 | 1.020 | 1.032 | 0.505 | 0.889 | 0.884 | 0.004 |
| hex: http/json-1m | 524290 | 29824.4 ± 12.1% | 0.050 | 1.095 | 0.737 | 1.003 | 0.539 | 1.017 | 1.009 | 0.531 | 1.115 | 1.114 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 16127.7 ± 3.4% | 0.091 | 1.033 | 0.811 | 1.026 | 0.602 | 1.025 | 1.032 | 0.700 | 1.012 | 1.031 | 0.009 |
| hex: http/js-16kx64 | 2097280 | 34444.0 ± 1.5% | 0.045 | 1.030 | 0.605 | 1.039 | 0.501 | 1.037 | 1.042 | 0.505 | 0.882 | 0.881 | 0.004 |
| hex: http/js-1m | 524290 | 28653.9 ± 3.9% | 0.053 | 1.057 | 0.775 | 1.042 | 0.568 | 1.044 | 1.022 | 0.562 | 1.165 | 1.170 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 16093.9 ± 12.2% | 0.092 | 1.027 | 0.800 | 1.040 | 0.590 | 1.029 | 1.045 | 0.689 | 1.019 | 1.035 | 0.009 |
| hex: http/css-16kx64 | 2097280 | 33981.6 ± 1.3% | 0.045 | 1.031 | 0.617 | 1.040 | 0.509 | 1.039 | 1.041 | 0.515 | 0.901 | 0.899 | 0.004 |
| hex: http/css-1m | 524290 | 29930.8 ± 7.1% | 0.050 | 1.018 | 0.730 | 1.026 | 0.546 | 1.054 | 1.019 | 0.539 | 1.111 | 1.111 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 28617.7 ± 5.5% | 0.053 | 1.022 | 0.768 | 1.031 | 0.562 | 1.063 | 1.046 | 0.555 | 1.171 | 1.165 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1340.6 ± 0.8% | 0.440 | 0.974 | 0.962 | 0.980 | 0.986 | 0.231 | 0.987 | 0.443 | 0.851 | 0.085 | 1.005 |
| qlog records, JSON text sequence | 1467503 | 1143.7 ± 13.6% | 0.703 | 0.941 | 0.993 | 0.980 | 0.994 | 0.229 | 0.993 | 0.420 | 0.849 | 0.105 | 1.015 |
| string: silesia/dickens | 172528 | 8540.1 ± 0.3% | 0.018 | 0.622 | 0.443 | 0.636 | 0.623 | 0.126 | 0.625 | 0.998 | 1.005 | 0.018 | 1.041 |
| string: silesia/nci | 1075110 | 8047.2 ± 1.5% | 0.019 | 0.638 | 0.431 | 0.637 | 0.641 | 0.179 | 0.642 | 1.004 | 1.005 | 0.019 | 1.028 |
| string: silesia/reymont | 1075159 | 3792.6 ± 1.9% | 0.041 | 0.683 | 0.519 | 0.676 | 0.684 | 0.286 | 0.684 | 1.005 | 1.005 | 0.041 | 1.007 |
| string: silesia/samba | 97582 | 4560.3 ± 4.9% | 0.043 | 0.949 | 0.800 | 0.950 | 0.945 | 0.107 | 0.950 | 1.001 | 1.002 | 0.043 | 1.105 |
| string: silesia/webster | 1098490 | 5017.7 ± 1.1% | 0.031 | 0.709 | 0.504 | 0.715 | 0.710 | 0.157 | 0.710 | 1.000 | 1.003 | 0.031 | 1.004 |
| string: silesia/xml | 1090118 | 7708.3 ± 0.9% | 0.021 | 0.651 | 0.569 | 0.655 | 0.650 | 0.203 | 0.651 | 0.998 | 1.021 | 0.021 | 1.024 |
| string: canterbury/alice29.txt | 159425 | 8722.4 ± 1.1% | 0.018 | 0.574 | 0.435 | 0.537 | 0.580 | 0.093 | 0.536 | 0.995 | 1.003 | 0.018 | 1.032 |
| string: canterbury/asyoulik.txt | 132198 | 7797.6 ± 1.2% | 0.019 | 0.519 | 0.404 | 0.516 | 0.523 | 0.089 | 0.520 | 0.999 | 1.005 | 0.019 | 1.041 |
| string: canterbury/lcet10.txt | 441884 | 8298.1 ± 0.5% | 0.019 | 0.647 | 0.415 | 0.661 | 0.647 | 0.126 | 0.649 | 1.002 | 1.011 | 0.019 | 1.030 |
| string: canterbury/plrabn12.txt | 503330 | 5971.6 ± 0.4% | 0.026 | 0.772 | 0.589 | 0.768 | 0.774 | 0.157 | 0.773 | 0.999 | 1.001 | 0.026 | 1.041 |
| string: canterbury-large/E.coli | 1048578 | 31047.7 ± 18.2% | 0.048 | 1.127 | 1.228 | 0.710 | 1.226 | 0.568 | 1.178 | 0.948 | 1.084 | 0.005 | 1.135 |
| string: canterbury-large/bible.txt | 1055886 | 6959.9 ± 0.4% | 0.023 | 0.800 | 0.662 | 0.830 | 0.802 | 0.415 | 0.802 | 1.001 | 1.002 | 0.023 | 1.042 |
| string: canterbury-large/world192.txt | 1103121 | 5068.8 ± 6.3% | 0.030 | 0.678 | 0.499 | 0.652 | 0.679 | 0.140 | 0.648 | 0.989 | 0.956 | 0.030 | 0.950 |
| string: http/html-1m | 1058582 | 8355.5 ± 0.9% | 0.019 | 0.631 | 0.523 | 0.659 | 0.632 | 0.297 | 0.632 | 1.008 | 1.015 | 0.019 | 1.023 |
| string: http/json-1m | 1190272 | 6402.7 ± 9.3% | 0.023 | 0.224 | 0.194 | 0.227 | 0.224 | 0.064 | 0.224 | 0.997 | 0.998 | 0.023 | 1.018 |
| string: http/js-1m | 1144362 | 4974.5 ± 2.1% | 0.030 | 0.451 | 0.363 | 0.439 | 0.451 | 0.087 | 0.452 | 0.998 | 1.017 | 0.030 | 1.007 |
| string: http/css-1m | 1097820 | 6451.6 ± 2.6% | 0.023 | 0.513 | 0.365 | 0.542 | 0.518 | 0.121 | 0.540 | 1.001 | 1.004 | 0.023 | 1.050 |
| string: dickens as Cyrillic and CJK | 1883069 | 5366.6 ± 0.2% | 0.024 | 0.464 | 0.058 | 0.466 | 0.465 | 0.171 | 0.464 | 1.001 | 0.997 | 0.024 | 0.977 |
| hex: silesia/dickens | 524290 | 31029.1 ± 1.0% | 1.004 | 0.082 | 1.008 | 0.599 | 1.010 | 1.008 | 1.010 | 1.004 | 1.010 | 0.082 | 1.009 |
| hex: silesia/mozilla | 524290 | 34821.6 ± 3.2% | 1.012 | 0.073 | 1.015 | 0.580 | 1.013 | 1.011 | 1.017 | 1.008 | 1.015 | 0.073 | 1.016 |
| hex: silesia/mr | 524290 | 32779.5 ± 1.8% | 1.008 | 0.077 | 1.012 | 0.608 | 1.010 | 1.007 | 1.014 | 1.008 | 1.012 | 0.077 | 1.011 |
| hex: silesia/nci | 524290 | 32549.8 ± 0.7% | 1.004 | 0.078 | 1.008 | 0.617 | 1.008 | 1.003 | 1.009 | 1.003 | 1.007 | 0.078 | 1.008 |
| hex: silesia/ooffice | 524290 | 32683.9 ± 0.9% | 1.002 | 0.077 | 1.011 | 0.613 | 1.011 | 1.008 | 1.011 | 1.005 | 1.009 | 0.078 | 1.014 |
| hex: silesia/osdb | 524290 | 35647.0 ± 15.8% | 1.009 | 0.071 | 1.008 | 0.563 | 1.010 | 1.014 | 1.012 | 1.008 | 1.018 | 0.071 | 1.013 |
| hex: silesia/reymont | 524290 | 34255.6 ± 2.6% | 1.002 | 0.074 | 1.002 | 0.580 | 1.004 | 0.999 | 1.003 | 0.999 | 1.009 | 0.074 | 1.002 |
| hex: silesia/samba | 524290 | 33482.8 ± 1.5% | 1.015 | 0.076 | 1.012 | 0.598 | 1.013 | 1.020 | 1.010 | 1.008 | 1.018 | 0.076 | 1.013 |
| hex: silesia/sao | 524290 | 34158.4 ± 1.4% | 1.006 | 0.074 | 1.009 | 0.584 | 1.009 | 1.006 | 1.013 | 1.006 | 1.018 | 0.074 | 1.010 |
| hex: silesia/webster | 524290 | 36288.2 ± 1.6% | 1.017 | 0.070 | 1.016 | 0.554 | 1.017 | 1.014 | 1.018 | 1.013 | 1.021 | 0.070 | 1.019 |
| hex: silesia/x-ray | 524290 | 32955.3 ± 1.3% | 1.010 | 0.077 | 1.013 | 0.602 | 1.014 | 1.012 | 1.013 | 1.010 | 1.014 | 0.077 | 1.008 |
| hex: silesia/xml | 524290 | 33176.6 ± 2.4% | 1.009 | 0.076 | 1.017 | 0.607 | 1.016 | 1.009 | 1.017 | 1.010 | 1.020 | 0.077 | 1.019 |
| hex: canterbury/alice29.txt | 304180 | 33299.9 ± 1.9% | 0.999 | 0.076 | 0.996 | 0.597 | 1.002 | 0.990 | 0.994 | 1.002 | 1.002 | 0.076 | 1.000 |
| hex: canterbury/asyoulik.txt | 250360 | 31612.1 ± 0.4% | 0.992 | 0.080 | 0.999 | 0.606 | 0.994 | 0.994 | 0.997 | 1.001 | 0.998 | 0.080 | 0.998 |
| hex: canterbury/cp.html | 49208 | 31867.3 ± 20.7% | 1.002 | 0.080 | 0.999 | 0.591 | 0.999 | 0.990 | 1.000 | 0.999 | 1.002 | 0.080 | 0.995 |
| hex: canterbury/fields.c | 22302 | 32494.0 ± 0.5% | 1.002 | 0.078 | 1.000 | 0.578 | 1.000 | 0.985 | 1.000 | 0.999 | 1.010 | 0.078 | 1.005 |
| hex: canterbury/grammar.lsp | 7444 | 33202.9 ± 0.5% | 0.992 | 0.076 | 0.978 | 0.563 | 0.996 | 0.952 | 0.995 | 1.000 | 1.030 | 0.075 | 1.009 |
| hex: canterbury/kennedy.xls | 524290 | 31482.0 ± 2.2% | 1.003 | 0.080 | 1.005 | 0.602 | 1.006 | 1.005 | 1.006 | 0.999 | 1.008 | 0.081 | 1.006 |
| hex: canterbury/lcet10.txt | 524290 | 34546.1 ± 0.4% | 1.011 | 0.073 | 1.008 | 0.584 | 1.009 | 1.005 | 1.010 | 1.001 | 1.012 | 0.074 | 1.012 |
| hex: canterbury/plrabn12.txt | 524290 | 32902.5 ± 2.7% | 1.003 | 0.077 | 1.008 | 0.608 | 1.008 | 1.004 | 1.007 | 1.004 | 1.007 | 0.077 | 1.008 |
| hex: canterbury/ptt5 | 524290 | 33044.7 ± 0.7% | 1.009 | 0.077 | 1.008 | 0.608 | 1.010 | 1.006 | 1.007 | 1.005 | 1.010 | 0.077 | 1.011 |
| hex: canterbury/sum | 76482 | 34949.0 ± 0.2% | 1.000 | 0.073 | 1.001 | 0.576 | 1.002 | 0.996 | 1.001 | 1.009 | 1.004 | 0.073 | 0.999 |
| hex: canterbury/xargs.1 | 8456 | 34634.4 ± 16.9% | 0.995 | 0.073 | 0.996 | 0.544 | 0.997 | 0.957 | 0.997 | 1.004 | 1.032 | 0.073 | 1.012 |
| hex: canterbury-large/E.coli | 524290 | 30510.4 ± 1.2% | 1.011 | 0.083 | 1.013 | 0.628 | 1.013 | 1.011 | 1.013 | 1.011 | 1.002 | 0.083 | 1.010 |
| hex: canterbury-large/bible.txt | 524290 | 34998.1 ± 1.2% | 1.006 | 0.072 | 1.009 | 0.577 | 1.013 | 1.011 | 1.007 | 1.006 | 1.012 | 0.073 | 1.011 |
| hex: canterbury-large/world192.txt | 524290 | 34483.9 ± 1.3% | 1.010 | 0.073 | 1.011 | 0.580 | 1.009 | 1.009 | 1.012 | 1.002 | 1.015 | 0.074 | 1.017 |
| hex: http/html-1kx1024 | 2099200 | 23371.2 ± 0.9% | 1.004 | 0.105 | 0.998 | 0.690 | 1.004 | 0.894 | 1.005 | 1.012 | 1.070 | 0.102 | 1.036 |
| hex: http/html-16kx64 | 2097280 | 29468.0 ± 1.7% | 1.006 | 0.086 | 1.011 | 0.648 | 1.008 | 0.995 | 1.013 | 1.007 | 1.016 | 0.086 | 1.018 |
| hex: http/html-1m | 524290 | 29028.9 ± 3.2% | 1.011 | 0.087 | 1.002 | 0.670 | 1.009 | 1.005 | 1.009 | 1.005 | 1.008 | 0.088 | 1.008 |
| hex: http/json-1kx1024 | 2099200 | 23314.6 ± 0.7% | 1.002 | 0.105 | 1.008 | 0.692 | 1.007 | 0.895 | 1.005 | 1.019 | 1.077 | 0.102 | 1.034 |
| hex: http/json-16kx64 | 2097280 | 29965.6 ± 3.2% | 1.012 | 0.084 | 1.013 | 0.647 | 1.011 | 0.998 | 1.013 | 1.008 | 1.020 | 0.084 | 1.013 |
| hex: http/json-1m | 524290 | 31182.1 ± 0.4% | 1.002 | 0.081 | 1.007 | 0.641 | 1.010 | 1.007 | 1.009 | 1.005 | 1.008 | 0.081 | 1.006 |
| hex: http/js-1kx1024 | 2099200 | 23563.1 ± 4.7% | 1.001 | 0.104 | 1.001 | 0.687 | 1.003 | 0.891 | 1.001 | 1.011 | 1.074 | 0.101 | 1.028 |
| hex: http/js-16kx64 | 2097280 | 29924.8 ± 0.8% | 1.007 | 0.084 | 1.007 | 0.645 | 1.005 | 0.992 | 1.008 | 1.008 | 1.013 | 0.085 | 1.012 |
| hex: http/js-1m | 524290 | 30336.9 ± 18.4% | 1.007 | 0.083 | 1.008 | 0.647 | 1.012 | 1.013 | 1.013 | 1.010 | 1.010 | 0.084 | 1.014 |
| hex: http/css-1kx1024 | 2099200 | 23399.8 ± 1.0% | 1.000 | 0.105 | 0.996 | 0.687 | 0.997 | 0.894 | 0.998 | 1.005 | 1.066 | 0.102 | 1.032 |
| hex: http/css-16kx64 | 2097280 | 29795.2 ± 15.3% | 1.016 | 0.085 | 1.018 | 0.649 | 1.017 | 1.003 | 1.014 | 1.019 | 1.024 | 0.085 | 1.018 |
| hex: http/css-1m | 524290 | 31441.3 ± 1.5% | 0.999 | 0.080 | 0.998 | 0.631 | 1.001 | 0.999 | 0.999 | 1.000 | 1.001 | 0.081 | 0.999 |
| hex: shuffled/dickens-1m | 524290 | 34537.3 ± 2.8% | 1.014 | 0.073 | 1.008 | 0.584 | 1.012 | 1.011 | 1.013 | 1.008 | 1.017 | 0.074 | 1.017 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.057 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.066 of all on.
- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.050 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.053 of all on.
- string: silesia/webster, decoding: J8 decoder fast path off runs at 1.052 of all on.
- string: silesia/webster, decoding: J13 decoder escape blocks off runs at 1.051 of all on.
- string: canterbury/alice29.txt, decoding: J8 decoder fast path off runs at 1.109 of all on.
- string: canterbury/alice29.txt, decoding: J12 decoder escape words off runs at 1.058 of all on.
- string: canterbury/alice29.txt, decoding: J13 decoder escape blocks off runs at 1.108 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.066 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.125 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.118 of all on.
- string: canterbury/lcet10.txt, decoding: J8 decoder fast path off runs at 1.061 of all on.
- string: canterbury/lcet10.txt, decoding: J13 decoder escape blocks off runs at 1.058 of all on.
- string: canterbury/plrabn12.txt, decoding: J8 decoder fast path off runs at 1.083 of all on.
- string: canterbury/plrabn12.txt, decoding: J13 decoder escape blocks off runs at 1.081 of all on.
- string: http/js-1m, decoding: J13 decoder escape blocks off runs at 1.062 of all on.
- string: canterbury-large/E.coli, encoding: J5 UTF-8 vectors off runs at 1.228 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 98613.4 ± 0.7% | 90806.1 ± 0.2% | 1.086 | — | — |
| string: silesia/nci | 1048576 | 60723.8 ± 1.3% | 60989.2 ± 2.7% | 0.996 | — | — |
| string: silesia/reymont | 1048576 | 60357.3 ± 1.0% | 60052.2 ± 7.8% | 1.005 | — | — |
| string: silesia/samba | 65546 | 98257.9 ± 2.3% | 90230.7 ± 1.1% | 1.089 | — | — |
| string: silesia/webster | 1048576 | 59127.3 ± 7.2% | 59314.6 ± 8.9% | 0.997 | — | — |
| string: silesia/xml | 1048576 | 60788.4 ± 4.4% | 60816.2 ± 1.2% | 1.000 | — | — |
| string: canterbury/alice29.txt | 152089 | 100249.9 ± 1.4% | 91474.2 ± 3.2% | 1.096 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 100097.1 ± 0.3% | 91421.3 ± 2.0% | 1.095 | — | — |
| string: canterbury/lcet10.txt | 426754 | 87405.0 ± 1.3% | 82740.6 ± 11.6% | 1.056 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 79783.8 ± 3.0% | 79858.7 ± 1.6% | 0.999 | — | — |
| string: canterbury-large/E.coli | 1048576 | 60453.4 ± 7.3% | 59567.1 ± 9.6% | 1.015 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 59258.2 ± 0.7% | 59403.7 ± 3.0% | 0.998 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 59399.3 ± 1.7% | 60181.6 ± 5.1% | 0.987 | — | — |
| string: http/html-1m | 1048576 | 58451.1 ± 0.5% | 58913.9 ± 0.6% | 0.992 | — | — |
| string: http/json-1m | 1048576 | 51866.5 ± 2.9% | 55438.1 ± 0.4% | 0.936 | — | — |
| string: http/js-1m | 1048576 | 59200.8 ± 4.5% | 59869.1 ± 8.5% | 0.989 | — | — |
| string: http/css-1m | 1048576 | 58703.9 ± 3.5% | 58833.3 ± 0.5% | 0.998 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 14520.4 ± 0.6% | 15273.9 ± 0.6% | 0.951 | — | — |

## Losses to simdutf

- string: http/json-1m: stdx runs at 0.936 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 59796.7 ± 3.2% | 59950.6 ± 19.1% | 0.997 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 59733.4 ± 1.1% | 60162.1 ± 0.8% | 0.993 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 59581.8 ± 1.1% | 60254.0 ± 4.7% | 0.989 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 59620.0 ± 0.6% | 60250.0 ± 4.4% | 0.990 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 59554.6 ± 6.0% | 60073.1 ± 1.3% | 0.991 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 59814.7 ± 4.3% | 60215.2 ± 1.1% | 0.993 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 14509.1 ± 3.0% | 15245.5 ± 1.2% | 0.952 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 14518.4 ± 0.6% | 15315.5 ± 0.3% | 0.948 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 14547.9 ± 1.7% | 15282.9 ± 0.7% | 0.952 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 14585.1 ± 5.8% | 15298.4 ± 12.9% | 0.953 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 14569.7 ± 4.1% | 15287.1 ± 0.5% | 0.953 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 14582.9 ± 0.4% | 15278.6 ± 0.6% | 0.954 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1023.6 ± 0.6% | 997.7 ± 0.3% | 979.8 ± 2.2% | 287.7 ± 1.0% | 529.9 ± 3.5% | 257.3 ± 2.3% | 1.026 | 1.045 | 3.558 | 1.932 | 3.979 |
| qlog records, JSON text sequence | 1467503 | 822.4 ± 4.5% | 808.9 ± 0.1% | 807.8 ± 1.2% | 237.6 ± 3.0% | 576.2 ± 8.3% | 232.7 ± 17.4% | 1.017 | 1.018 | 3.461 | 1.427 | 3.534 |
| string: silesia/dickens | 172528 | 5493.1 ± 0.3% | 2894.9 ± 0.5% | 2060.0 ± 1.5% | 301.9 ± 0.8% | 2181.1 ± 6.1% | 491.2 ± 3.6% | 1.897 | 2.667 | 18.194 | 2.518 | 11.184 |
| string: silesia/nci | 1075110 | 5216.4 ± 0.2% | 3479.6 ± 0.9% | 2802.7 ± 10.6% | 503.0 ± 0.8% | 2372.9 ± 0.2% | 519.1 ± 0.8% | 1.499 | 1.861 | 10.370 | 2.198 | 10.049 |
| string: silesia/reymont | 1075159 | 2782.8 ± 3.8% | 2195.5 ± 0.3% | 1761.6 ± 6.8% | 318.8 ± 0.3% | 1637.6 ± 0.3% | 471.4 ± 1.5% | 1.268 | 1.580 | 8.728 | 1.699 | 5.904 |
| string: silesia/samba | 97582 | 3354.3 ± 1.3% | 2881.6 ± 0.3% | 1714.3 ± 11.1% | 262.1 ± 0.2% | 1281.2 ± 0.3% | 349.8 ± 0.9% | 1.164 | 1.957 | 12.797 | 2.618 | 9.589 |
| string: silesia/webster | 1098490 | 3659.0 ± 1.4% | 2036.1 ± 0.6% | 1610.2 ± 1.3% | 306.6 ± 1.3% | 1660.8 ± 1.7% | 439.6 ± 1.3% | 1.797 | 2.272 | 11.933 | 2.203 | 8.324 |
| string: silesia/xml | 1090118 | 5138.1 ± 0.4% | 3698.0 ± 1.1% | 2110.7 ± 1.0% | 408.8 ± 0.6% | 2376.5 ± 0.7% | 519.5 ± 0.4% | 1.389 | 2.434 | 12.569 | 2.162 | 9.890 |
| string: canterbury/alice29.txt | 159425 | 4431.4 ± 3.3% | 2406.6 ± 2.1% | 1821.2 ± 5.8% | 283.5 ± 1.8% | 1917.9 ± 1.1% | 437.2 ± 14.8% | 1.841 | 2.433 | 15.630 | 2.311 | 10.136 |
| string: canterbury/asyoulik.txt | 132198 | 3812.2 ± 4.5% | 2100.5 ± 0.3% | 1478.2 ± 1.5% | 274.0 ± 1.9% | 1555.6 ± 18.0% | 396.8 ± 5.2% | 1.815 | 2.579 | 13.913 | 2.451 | 9.607 |
| string: canterbury/lcet10.txt | 441884 | 5700.0 ± 0.7% | 2792.2 ± 0.7% | 1953.3 ± 1.3% | 325.1 ± 7.7% | 2133.2 ± 1.3% | 483.0 ± 1.6% | 2.041 | 2.918 | 17.534 | 2.672 | 11.801 |
| string: canterbury/plrabn12.txt | 503330 | 4437.4 ± 1.1% | 2688.1 ± 0.1% | 1666.7 ± 0.5% | 296.2 ± 2.4% | 2000.3 ± 1.4% | 457.3 ± 1.4% | 1.651 | 2.662 | 14.979 | 2.218 | 9.703 |
| string: canterbury-large/E.coli | 1048578 | 26664.3 ± 1.6% | 7624.4 ± 0.3% | 3419.9 ± 0.4% | 800.9 ± 0.5% | 5518.8 ± 1.3% | 798.4 ± 0.9% | 3.497 | 7.797 | 33.292 | 4.832 | 33.398 |
| string: canterbury-large/bible.txt | 1055886 | 6591.4 ± 1.5% | 3901.7 ± 0.6% | 2491.5 ± 1.1% | 352.8 ± 0.2% | 2982.5 ± 14.6% | 570.9 ± 1.8% | 1.689 | 2.646 | 18.686 | 2.210 | 11.547 |
| string: canterbury-large/world192.txt | 1103121 | 3440.7 ± 7.1% | 1974.8 ± 2.3% | 1620.7 ± 0.3% | 296.2 ± 0.6% | 1696.9 ± 0.6% | 414.4 ± 31.4% | 1.742 | 2.123 | 11.615 | 2.028 | 8.302 |
| string: http/html-1m | 1058582 | 6216.5 ± 0.7% | 3396.2 ± 0.4% | 2350.8 ± 2.3% | 408.1 ± 0.6% | 2731.5 ± 0.8% | 407.5 ± 4.0% | 1.830 | 2.644 | 15.234 | 2.276 | 15.254 |
| string: http/json-1m | 1190272 | 3326.9 ± 0.4% | 1195.6 ± 0.3% | 1480.2 ± 6.5% | 353.3 ± 1.2% | 838.5 ± 1.5% | 283.3 ± 1.3% | 2.783 | 2.248 | 9.417 | 3.968 | 11.745 |
| string: http/js-1m | 1144362 | 2255.4 ± 0.4% | 1323.6 ± 0.3% | 1143.5 ± 1.2% | 278.9 ± 0.8% | 1157.2 ± 3.2% | 284.8 ± 0.9% | 1.704 | 1.972 | 8.087 | 1.949 | 7.919 |
| string: http/css-1m | 1097820 | 2978.4 ± 1.0% | 2501.6 ± 0.3% | 1541.0 ± 2.7% | 372.7 ± 0.3% | 1556.2 ± 1.7% | 317.0 ± 0.9% | 1.191 | 1.933 | 7.990 | 1.914 | 9.395 |
| string: dickens as Cyrillic and CJK | 1883069 | 5172.1 ± 1.0% | 3209.3 ± 0.6% | 647.6 ± 1.0% | 256.8 ± 5.7% | 513.2 ± 3.8% | 137.2 ± 1.5% | 1.612 | 7.987 | 20.141 | 10.078 | 37.691 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1061.2 ± 1.2% | 1076.9 ± 1.9% | 811.6 ± 2.5% | 161.7 ± 0.7% | 383.9 ± 1.3% | 199.5 ± 2.8% | 0.985 | 1.308 | 6.562 | 2.764 | 5.319 |
| hex: silesia/dickens | 524290 | 28818.8 ± 1.8% | 7606.1 ± 1.0% | 3442.0 ± 13.6% | 467.8 ± 14.2% | 5525.4 ± 0.7% | 799.4 ± 2.1% | 3.789 | 8.373 | 61.605 | 5.216 | 36.049 |
| hex: silesia/mozilla | 524290 | 29376.5 ± 7.0% | 7655.5 ± 0.9% | 3432.1 ± 1.7% | 408.3 ± 1.6% | 5510.3 ± 1.0% | 798.2 ± 1.9% | 3.837 | 8.559 | 71.944 | 5.331 | 36.804 |
| hex: silesia/mr | 524290 | 27421.6 ± 3.3% | 7658.8 ± 0.4% | 3437.5 ± 0.5% | 581.8 ± 0.5% | 5524.8 ± 0.9% | 798.5 ± 1.4% | 3.580 | 7.977 | 47.135 | 4.963 | 34.343 |
| hex: silesia/nci | 524290 | 29932.6 ± 17.5% | 7630.9 ± 0.7% | 3439.3 ± 0.5% | 644.5 ± 0.5% | 5489.7 ± 17.4% | 797.0 ± 1.1% | 3.923 | 8.703 | 46.442 | 5.453 | 37.557 |
| hex: silesia/ooffice | 524290 | 29439.2 ± 0.8% | 7646.9 ± 0.3% | 3427.6 ± 0.6% | 356.2 ± 0.6% | 5533.6 ± 1.0% | 800.4 ± 1.1% | 3.850 | 8.589 | 82.657 | 5.320 | 36.779 |
| hex: silesia/osdb | 524290 | 28428.3 ± 1.9% | 7631.8 ± 0.6% | 3446.4 ± 1.1% | 453.4 ± 5.2% | 5506.6 ± 30.9% | 797.3 ± 1.1% | 3.725 | 8.249 | 62.704 | 5.163 | 35.655 |
| hex: silesia/reymont | 524290 | 29130.4 ± 1.7% | 7625.6 ± 5.1% | 3419.6 ± 2.5% | 487.6 ± 0.5% | 5535.0 ± 0.7% | 800.1 ± 1.1% | 3.820 | 8.519 | 59.737 | 5.263 | 36.409 |
| hex: silesia/samba | 524290 | 28688.0 ± 0.8% | 7645.9 ± 0.6% | 3438.1 ± 0.9% | 361.7 ± 0.3% | 5501.9 ± 1.1% | 802.2 ± 0.8% | 3.752 | 8.344 | 79.322 | 5.214 | 35.763 |
| hex: silesia/sao | 524290 | 28847.5 ± 1.7% | 7655.6 ± 0.6% | 3432.0 ± 0.6% | 287.8 ± 4.3% | 5507.7 ± 0.8% | 802.2 ± 0.5% | 3.768 | 8.406 | 100.248 | 5.238 | 35.961 |
| hex: silesia/webster | 524290 | 28742.8 ± 1.1% | 7618.8 ± 0.9% | 3438.9 ± 0.3% | 435.5 ± 0.2% | 5521.6 ± 0.6% | 802.7 ± 0.7% | 3.773 | 8.358 | 66.000 | 5.206 | 35.810 |
| hex: silesia/x-ray | 524290 | 29054.2 ± 3.0% | 7647.6 ± 0.5% | 3423.3 ± 1.4% | 435.2 ± 0.5% | 5510.8 ± 0.8% | 798.3 ± 0.8% | 3.799 | 8.487 | 66.759 | 5.272 | 36.393 |
| hex: silesia/xml | 524290 | 29935.3 ± 2.0% | 7662.5 ± 1.3% | 3428.7 ± 0.4% | 602.5 ± 0.4% | 5496.7 ± 1.2% | 800.7 ± 1.0% | 3.907 | 8.731 | 49.689 | 5.446 | 37.388 |
| hex: canterbury/alice29.txt | 304180 | 34697.7 ± 5.4% | 7778.1 ± 0.9% | 3510.8 ± 1.1% | 469.5 ± 1.2% | 5506.2 ± 0.8% | 802.6 ± 1.1% | 4.461 | 9.883 | 73.903 | 6.302 | 43.232 |
| hex: canterbury/asyoulik.txt | 250360 | 37675.5 ± 3.2% | 7744.2 ± 0.5% | 3532.2 ± 1.6% | 461.4 ± 0.5% | 5507.1 ± 18.0% | 805.5 ± 1.9% | 4.865 | 10.666 | 81.654 | 6.841 | 46.772 |
| hex: canterbury/cp.html | 49208 | 39127.2 ± 0.4% | 7782.7 ± 0.3% | 3609.1 ± 11.0% | 462.0 ± 1.0% | 5486.7 ± 0.6% | 789.4 ± 2.1% | 5.027 | 10.841 | 84.685 | 7.131 | 49.565 |
| hex: canterbury/fields.c | 22302 | 37310.4 ± 5.8% | 7690.7 ± 0.2% | 3607.1 ± 7.0% | 487.9 ± 0.6% | 5472.3 ± 0.9% | 777.1 ± 1.2% | 4.851 | 10.344 | 76.478 | 6.818 | 48.011 |
| hex: canterbury/grammar.lsp | 7444 | 36191.1 ± 5.0% | 7486.8 ± 0.3% | 3563.5 ± 1.3% | 534.2 ± 1.0% | 5371.0 ± 3.2% | 754.8 ± 5.1% | 4.834 | 10.156 | 67.747 | 6.738 | 47.948 |
| hex: canterbury/kennedy.xls | 524290 | 28602.2 ± 9.0% | 7637.9 ± 1.0% | 3446.4 ± 2.5% | 684.6 ± 0.6% | 5486.1 ± 1.1% | 792.5 ± 7.4% | 3.745 | 8.299 | 41.782 | 5.214 | 36.090 |
| hex: canterbury/lcet10.txt | 524290 | 28495.2 ± 7.2% | 7629.2 ± 0.5% | 3442.5 ± 0.5% | 471.8 ± 1.0% | 5515.9 ± 0.4% | 799.5 ± 2.2% | 3.735 | 8.277 | 60.402 | 5.166 | 35.642 |
| hex: canterbury/plrabn12.txt | 524290 | 28776.8 ± 1.7% | 7647.3 ± 0.9% | 3419.5 ± 0.6% | 460.6 ± 1.2% | 5507.8 ± 1.0% | 805.3 ± 0.8% | 3.763 | 8.416 | 62.476 | 5.225 | 35.736 |
| hex: canterbury/ptt5 | 524290 | 29693.9 ± 3.3% | 7603.5 ± 1.3% | 3434.4 ± 0.3% | 565.5 ± 13.0% | 5490.0 ± 1.1% | 796.7 ± 2.4% | 3.905 | 8.646 | 52.507 | 5.409 | 37.269 |
| hex: canterbury/sum | 76482 | 40258.2 ± 0.7% | 7799.2 ± 0.8% | 3617.5 ± 0.3% | 526.1 ± 0.6% | 5503.8 ± 1.8% | 800.7 ± 3.3% | 5.162 | 11.129 | 76.519 | 7.315 | 50.280 |
| hex: canterbury/xargs.1 | 8456 | 37466.9 ± 12.7% | 7518.6 ± 3.4% | 3540.4 ± 1.6% | 523.3 ± 5.4% | 5369.4 ± 0.4% | 781.3 ± 17.8% | 4.983 | 10.583 | 71.603 | 6.978 | 47.957 |
| hex: canterbury-large/E.coli | 524290 | 28781.2 ± 1.2% | 7574.3 ± 0.9% | 3431.0 ± 1.6% | 710.5 ± 0.2% | 5511.5 ± 0.6% | 789.9 ± 4.8% | 3.800 | 8.389 | 40.509 | 5.222 | 36.434 |
| hex: canterbury-large/bible.txt | 524290 | 28107.9 ± 1.1% | 7637.1 ± 0.5% | 3427.3 ± 1.7% | 487.5 ± 1.0% | 5499.5 ± 1.4% | 798.0 ± 2.0% | 3.680 | 8.201 | 57.657 | 5.111 | 35.223 |
| hex: canterbury-large/world192.txt | 524290 | 28676.7 ± 17.4% | 7633.6 ± 0.4% | 3430.4 ± 1.1% | 454.3 ± 0.2% | 5483.3 ± 1.3% | 795.1 ± 0.4% | 3.757 | 8.360 | 63.116 | 5.230 | 36.065 |
| hex: http/html-1kx1024 | 2099200 | 16133.2 ± 2.4% | 6592.4 ± 0.2% | 3232.0 ± 0.7% | 485.7 ± 2.0% | 4698.2 ± 2.5% | 712.0 ± 2.6% | 2.447 | 4.992 | 33.218 | 3.434 | 22.659 |
| hex: http/html-16kx64 | 2097280 | 33997.3 ± 10.0% | 7618.3 ± 0.1% | 3489.8 ± 0.8% | 494.6 ± 6.7% | 5408.3 ± 5.2% | 778.3 ± 4.1% | 4.463 | 9.742 | 68.740 | 6.286 | 43.680 |
| hex: http/html-1m | 524290 | 28467.6 ± 3.5% | 7611.7 ± 1.3% | 3408.2 ± 0.5% | 492.4 ± 0.5% | 5505.5 ± 0.2% | 786.1 ± 3.8% | 3.740 | 8.353 | 57.819 | 5.171 | 36.216 |
| hex: http/json-1kx1024 | 2099200 | 16264.1 ± 2.9% | 6602.1 ± 5.6% | 3225.1 ± 17.4% | 613.6 ± 2.8% | 4707.9 ± 1.0% | 694.7 ± 5.1% | 2.463 | 5.043 | 26.508 | 3.455 | 23.413 |
| hex: http/json-16kx64 | 2097280 | 34392.8 ± 1.8% | 7655.5 ± 0.5% | 3459.8 ± 1.5% | 631.6 ± 0.8% | 5381.7 ± 8.3% | 780.4 ± 2.8% | 4.493 | 9.941 | 54.452 | 6.391 | 44.070 |
| hex: http/json-1m | 524290 | 29824.4 ± 12.1% | 7671.6 ± 1.0% | 3438.0 ± 1.0% | 639.8 ± 0.7% | 5514.4 ± 1.3% | 794.1 ± 3.0% | 3.888 | 8.675 | 46.618 | 5.408 | 37.555 |
| hex: http/js-1kx1024 | 2099200 | 16127.7 ± 3.4% | 6605.4 ± 1.0% | 3213.8 ± 2.5% | 466.5 ± 1.4% | 4705.8 ± 0.4% | 704.0 ± 5.1% | 2.442 | 5.018 | 34.571 | 3.427 | 22.910 |
| hex: http/js-16kx64 | 2097280 | 34444.0 ± 1.5% | 7653.8 ± 0.4% | 3487.8 ± 0.9% | 478.9 ± 1.0% | 5413.9 ± 0.5% | 787.3 ± 2.6% | 4.500 | 9.875 | 71.928 | 6.362 | 43.749 |
| hex: http/js-1m | 524290 | 28653.9 ± 3.9% | 7635.1 ± 0.4% | 3428.1 ± 0.4% | 492.9 ± 2.6% | 5523.2 ± 1.0% | 800.3 ± 3.0% | 3.753 | 8.358 | 58.128 | 5.188 | 35.804 |
| hex: http/css-1kx1024 | 2099200 | 16093.9 ± 12.2% | 6594.9 ± 0.2% | 3211.8 ± 1.1% | 534.8 ± 2.9% | 4700.1 ± 0.4% | 713.1 ± 4.2% | 2.440 | 5.011 | 30.093 | 3.424 | 22.569 |
| hex: http/css-16kx64 | 2097280 | 33981.6 ± 1.3% | 7655.9 ± 0.3% | 3492.0 ± 0.5% | 549.6 ± 7.1% | 5418.5 ± 0.3% | 777.2 ± 3.2% | 4.439 | 9.731 | 61.825 | 6.271 | 43.726 |
| hex: http/css-1m | 524290 | 29930.8 ± 7.1% | 7648.9 ± 0.5% | 3443.8 ± 0.9% | 532.4 ± 0.6% | 5476.4 ± 4.0% | 803.1 ± 1.6% | 3.913 | 8.691 | 56.217 | 5.465 | 37.270 |
| hex: shuffled/dickens-1m | 524290 | 28617.7 ± 5.5% | 7640.1 ± 0.7% | 3427.8 ± 0.7% | 469.9 ± 1.1% | 5516.8 ± 1.0% | 809.9 ± 2.0% | 3.746 | 8.349 | 60.906 | 5.187 | 35.337 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1340.6 ± 0.8% | 1131.3 ± 1.6% | 896.0 ± 0.7% | 328.9 ± 1.0% | 365.8 ± 0.3% | 312.1 ± 1.2% | 1.185 | 1.496 | 4.076 | 3.665 | 4.296 |
| qlog records, JSON text sequence | 1467503 | 1143.7 ± 13.6% | 866.9 ± 0.9% | 720.3 ± 2.3% | 315.1 ± 1.0% | 374.4 ± 13.2% | 224.4 ± 2.0% | 1.319 | 1.588 | 3.629 | 3.054 | 5.096 |
| string: silesia/dickens | 172528 | 8540.1 ± 0.3% | 2946.6 ± 1.8% | 2024.6 ± 0.4% | 355.8 ± 0.4% | 1411.8 ± 1.8% | 561.0 ± 2.0% | 2.898 | 4.218 | 23.999 | 6.049 | 15.224 |
| string: silesia/nci | 1075110 | 8047.2 ± 1.5% | 3181.7 ± 2.1% | 2789.0 ± 0.8% | 773.2 ± 0.7% | 1534.8 ± 0.6% | 560.0 ± 0.4% | 2.529 | 2.885 | 10.407 | 5.243 | 14.371 |
| string: silesia/reymont | 1075159 | 3792.6 ± 1.9% | 1637.5 ± 1.1% | 1718.7 ± 30.1% | 361.0 ± 2.5% | 1248.6 ± 0.8% | 549.3 ± 0.4% | 2.316 | 2.207 | 10.505 | 3.037 | 6.904 |
| string: silesia/samba | 97582 | 4560.3 ± 4.9% | 1976.0 ± 1.4% | 2158.8 ± 0.9% | 298.4 ± 1.0% | 1007.5 ± 19.4% | 623.1 ± 29.4% | 2.308 | 2.112 | 15.282 | 4.526 | 7.319 |
| string: silesia/webster | 1098490 | 5017.7 ± 1.1% | 1624.8 ± 1.9% | 1488.0 ± 0.6% | 352.6 ± 8.0% | 1196.1 ± 1.6% | 453.0 ± 0.4% | 3.088 | 3.372 | 14.231 | 4.195 | 11.076 |
| string: silesia/xml | 1090118 | 7708.3 ± 0.9% | 2659.8 ± 0.5% | 2167.4 ± 0.6% | 540.6 ± 3.0% | 1578.5 ± 0.9% | 562.1 ± 0.5% | 2.898 | 3.556 | 14.259 | 4.883 | 13.713 |
| string: canterbury/alice29.txt | 159425 | 8722.4 ± 1.1% | 2465.8 ± 3.6% | 1786.5 ± 1.8% | 337.6 ± 2.3% | 1256.9 ± 2.3% | 556.4 ± 0.4% | 3.537 | 4.882 | 25.836 | 6.940 | 15.676 |
| string: canterbury/asyoulik.txt | 132198 | 7797.6 ± 1.2% | 2166.1 ± 6.2% | 1528.6 ± 1.0% | 341.4 ± 2.0% | 1117.8 ± 1.2% | 543.5 ± 1.0% | 3.600 | 5.101 | 22.839 | 6.976 | 14.346 |
| string: canterbury/lcet10.txt | 441884 | 8298.1 ± 0.5% | 2473.4 ± 1.8% | 1976.4 ± 0.2% | 388.4 ± 0.9% | 1374.7 ± 0.5% | 553.2 ± 0.6% | 3.355 | 4.199 | 21.365 | 6.036 | 15.001 |
| string: canterbury/plrabn12.txt | 503330 | 5971.6 ± 0.4% | 1819.1 ± 0.9% | 1664.0 ± 0.1% | 360.7 ± 0.7% | 1289.6 ± 2.1% | 554.4 ± 6.3% | 3.283 | 3.589 | 16.556 | 4.631 | 10.770 |
| string: canterbury-large/E.coli | 1048578 | 31047.7 ± 18.2% | 10477.6 ± 2.0% | 3383.8 ± 0.5% | 1407.2 ± 1.0% | 2493.7 ± 2.4% | 581.1 ± 1.0% | 2.963 | 9.175 | 22.064 | 12.451 | 53.430 |
| string: canterbury-large/bible.txt | 1055886 | 6959.9 ± 0.4% | 3917.4 ± 1.4% | 2652.6 ± 0.4% | 432.8 ± 0.2% | 1858.7 ± 0.6% | 570.5 ± 1.7% | 1.777 | 2.624 | 16.081 | 3.744 | 12.200 |
| string: canterbury-large/world192.txt | 1103121 | 5068.8 ± 6.3% | 1441.3 ± 0.7% | 1573.8 ± 2.5% | 367.8 ± 0.9% | 1167.0 ± 0.9% | 539.4 ± 0.7% | 3.517 | 3.221 | 13.783 | 4.344 | 9.397 |
| string: http/html-1m | 1058582 | 8355.5 ± 0.9% | 3859.8 ± 1.6% | 2469.3 ± 5.1% | 394.5 ± 12.3% | 1807.4 ± 0.4% | 521.7 ± 0.8% | 2.165 | 3.384 | 21.180 | 4.623 | 16.016 |
| string: http/json-1m | 1190272 | 6402.7 ± 9.3% | 1228.3 ± 0.3% | 1268.2 ± 0.4% | 373.9 ± 2.5% | 890.2 ± 0.8% | 508.1 ± 1.1% | 5.213 | 5.049 | 17.122 | 7.192 | 12.601 |
| string: http/js-1m | 1144362 | 4974.5 ± 2.1% | 984.4 ± 1.0% | 1083.7 ± 0.4% | 281.9 ± 1.1% | 935.6 ± 1.2% | 471.7 ± 0.6% | 5.053 | 4.590 | 17.646 | 5.317 | 10.546 |
| string: http/css-1m | 1097820 | 6451.6 ± 2.6% | 1294.0 ± 0.3% | 1593.6 ± 0.4% | 401.4 ± 14.0% | 1048.5 ± 0.5% | 529.0 ± 0.2% | 4.986 | 4.049 | 16.074 | 6.153 | 12.195 |
| string: dickens as Cyrillic and CJK | 1883069 | 5366.6 ± 0.2% | 3030.3 ± 14.4% | 346.3 ± 1.7% | 270.8 ± 0.5% | 450.6 ± 5.5% | 290.8 ± 25.4% | 1.771 | 15.499 | 19.819 | 11.911 | 18.453 |
| hex: silesia/dickens | 524290 | 31029.1 ± 1.0% | 1552.4 ± 1.5% | 1085.6 ± 0.3% | 419.8 ± 2.7% | 1047.2 ± 1.0% | 449.0 ± 0.4% | 19.988 | 28.583 | 73.922 | 29.630 | 69.107 |
| hex: silesia/mozilla | 524290 | 34821.6 ± 3.2% | 1550.2 ± 0.6% | 1084.3 ± 0.5% | 369.5 ± 0.8% | 1049.1 ± 1.4% | 448.4 ± 1.0% | 22.463 | 32.114 | 94.251 | 33.193 | 77.661 |
| hex: silesia/mr | 524290 | 32779.5 ± 1.8% | 1549.2 ± 7.0% | 1085.2 ± 1.9% | 511.2 ± 0.7% | 1051.5 ± 1.1% | 448.2 ± 0.6% | 21.159 | 30.207 | 64.127 | 31.174 | 73.129 |
| hex: silesia/nci | 524290 | 32549.8 ± 0.7% | 1551.1 ± 0.4% | 1087.1 ± 9.3% | 556.8 ± 0.5% | 1052.3 ± 0.6% | 448.6 ± 0.6% | 20.985 | 29.942 | 58.462 | 30.932 | 72.562 |
| hex: silesia/ooffice | 524290 | 32683.9 ± 0.9% | 1550.0 ± 0.4% | 1085.1 ± 0.4% | 327.7 ± 1.1% | 1052.1 ± 12.6% | 450.8 ± 0.8% | 21.086 | 30.120 | 99.741 | 31.066 | 72.499 |
| hex: silesia/osdb | 524290 | 35647.0 ± 15.8% | 1552.7 ± 0.9% | 1085.7 ± 0.5% | 414.4 ± 0.3% | 1052.4 ± 1.8% | 451.3 ± 0.2% | 22.959 | 32.832 | 86.013 | 33.871 | 78.993 |
| hex: silesia/reymont | 524290 | 34255.6 ± 2.6% | 1550.4 ± 1.0% | 1085.5 ± 0.3% | 437.9 ± 0.5% | 1054.4 ± 0.6% | 449.1 ± 1.6% | 22.095 | 31.558 | 78.220 | 32.489 | 76.274 |
| hex: silesia/samba | 524290 | 33482.8 ± 1.5% | 1547.7 ± 1.4% | 1083.9 ± 1.5% | 333.3 ± 0.3% | 1055.5 ± 0.2% | 451.4 ± 0.7% | 21.634 | 30.892 | 100.461 | 31.723 | 74.176 |
| hex: silesia/sao | 524290 | 34158.4 ± 1.4% | 1555.4 ± 0.5% | 1085.2 ± 0.2% | 267.0 ± 8.9% | 1057.4 ± 0.2% | 452.3 ± 0.8% | 21.961 | 31.476 | 127.917 | 32.305 | 75.518 |
| hex: silesia/webster | 524290 | 36288.2 ± 1.6% | 1548.5 ± 17.7% | 1083.1 ± 1.4% | 387.4 ± 1.2% | 1053.8 ± 0.3% | 451.6 ± 1.6% | 23.435 | 33.503 | 93.667 | 34.435 | 80.352 |
| hex: silesia/x-ray | 524290 | 32955.3 ± 1.3% | 1553.9 ± 0.9% | 1086.5 ± 0.2% | 394.5 ± 0.7% | 1051.8 ± 15.4% | 448.3 ± 7.5% | 21.208 | 30.331 | 83.530 | 31.334 | 73.517 |
| hex: silesia/xml | 524290 | 33176.6 ± 2.4% | 1551.6 ± 0.3% | 1085.8 ± 2.1% | 586.7 ± 0.2% | 1052.4 ± 0.3% | 449.9 ± 1.7% | 21.382 | 30.555 | 56.551 | 31.525 | 73.738 |
| hex: canterbury/alice29.txt | 304180 | 33299.9 ± 1.9% | 1576.6 ± 1.9% | 1087.7 ± 0.4% | 429.0 ± 0.5% | 1069.8 ± 0.9% | 453.5 ± 0.8% | 21.122 | 30.616 | 77.627 | 31.126 | 73.432 |
| hex: canterbury/asyoulik.txt | 250360 | 31612.1 ± 0.4% | 1601.8 ± 0.6% | 1091.7 ± 1.7% | 424.2 ± 1.7% | 1077.3 ± 20.3% | 454.1 ± 71.4% | 19.735 | 28.957 | 74.521 | 29.343 | 69.611 |
| hex: canterbury/cp.html | 49208 | 31867.3 ± 20.7% | 1620.5 ± 13.2% | 1112.5 ± 0.3% | 457.2 ± 0.6% | 1078.4 ± 0.3% | 459.0 ± 0.2% | 19.665 | 28.645 | 69.705 | 29.551 | 69.429 |
| hex: canterbury/fields.c | 22302 | 32494.0 ± 0.5% | 1599.4 ± 13.3% | 1103.2 ± 2.0% | 547.7 ± 0.9% | 1071.5 ± 0.5% | 460.5 ± 0.1% | 20.317 | 29.455 | 59.327 | 30.325 | 70.560 |
| hex: canterbury/grammar.lsp | 7444 | 33202.9 ± 0.5% | 1626.8 ± 0.8% | 1111.4 ± 1.5% | 584.4 ± 0.4% | 1088.9 ± 0.3% | 462.2 ± 1.7% | 20.410 | 29.875 | 56.820 | 30.492 | 71.841 |
| hex: canterbury/kennedy.xls | 524290 | 31482.0 ± 2.2% | 1541.6 ± 1.3% | 1083.1 ± 7.6% | 593.4 ± 0.4% | 1049.8 ± 0.8% | 450.0 ± 0.5% | 20.421 | 29.065 | 53.050 | 29.987 | 69.957 |
| hex: canterbury/lcet10.txt | 524290 | 34546.1 ± 0.4% | 1556.2 ± 0.6% | 1082.6 ± 1.2% | 421.5 ± 0.6% | 1052.1 ± 7.5% | 451.2 ± 0.6% | 22.199 | 31.910 | 81.968 | 32.834 | 76.567 |
| hex: canterbury/plrabn12.txt | 524290 | 32902.5 ± 2.7% | 1550.5 ± 0.6% | 1083.1 ± 12.3% | 421.4 ± 0.2% | 1054.5 ± 1.1% | 451.2 ± 0.7% | 21.221 | 30.378 | 78.072 | 31.202 | 72.927 |
| hex: canterbury/ptt5 | 524290 | 33044.7 ± 0.7% | 1554.2 ± 0.5% | 1084.0 ± 0.5% | 502.2 ± 2.7% | 1050.8 ± 10.0% | 453.1 ± 4.1% | 21.261 | 30.485 | 65.801 | 31.448 | 72.935 |
| hex: canterbury/sum | 76482 | 34949.0 ± 0.2% | 1614.8 ± 0.2% | 1106.4 ± 0.1% | 507.6 ± 0.5% | 1071.0 ± 0.6% | 460.7 ± 1.2% | 21.643 | 31.587 | 68.847 | 32.633 | 75.856 |
| hex: canterbury/xargs.1 | 8456 | 34634.4 ± 16.9% | 1631.7 ± 0.5% | 1112.0 ± 0.5% | 616.5 ± 1.0% | 1087.7 ± 1.5% | 463.8 ± 0.5% | 21.226 | 31.146 | 56.180 | 31.843 | 74.679 |
| hex: canterbury-large/E.coli | 524290 | 30510.4 ± 1.2% | 1552.7 ± 0.6% | 1084.8 ± 0.3% | 607.3 ± 0.4% | 1052.8 ± 0.7% | 449.0 ± 1.2% | 19.649 | 28.125 | 50.240 | 28.980 | 67.956 |
| hex: canterbury-large/bible.txt | 524290 | 34998.1 ± 1.2% | 1557.7 ± 18.7% | 1086.0 ± 0.2% | 434.7 ± 0.4% | 1043.6 ± 2.1% | 450.9 ± 0.8% | 22.468 | 32.227 | 80.514 | 33.537 | 77.617 |
| hex: canterbury-large/world192.txt | 524290 | 34483.9 ± 1.3% | 1552.4 ± 0.5% | 1083.2 ± 10.3% | 422.7 ± 0.3% | 1048.6 ± 1.1% | 449.4 ± 0.5% | 22.213 | 31.835 | 81.572 | 32.885 | 76.738 |
| hex: http/html-1kx1024 | 2099200 | 23371.2 ± 0.9% | 1607.6 ± 14.9% | 1088.6 ± 17.5% | 447.9 ± 0.2% | 1072.0 ± 2.5% | 455.4 ± 0.4% | 14.538 | 21.469 | 52.182 | 21.801 | 51.325 |
| hex: http/html-16kx64 | 2097280 | 29468.0 ± 1.7% | 1606.3 ± 10.7% | 1103.4 ± 5.7% | 446.8 ± 0.2% | 1036.7 ± 0.5% | 457.0 ± 0.5% | 18.345 | 26.707 | 65.961 | 28.424 | 64.485 |
| hex: http/html-1m | 524290 | 29028.9 ± 3.2% | 1543.0 ± 0.7% | 1082.5 ± 8.4% | 444.4 ± 12.4% | 1045.9 ± 16.5% | 450.6 ± 1.5% | 18.813 | 26.817 | 65.325 | 27.754 | 64.425 |
| hex: http/json-1kx1024 | 2099200 | 23314.6 ± 0.7% | 1611.3 ± 3.5% | 1091.1 ± 0.8% | 564.2 ± 0.2% | 1066.8 ± 0.7% | 454.0 ± 4.5% | 14.469 | 21.367 | 41.327 | 21.854 | 51.358 |
| hex: http/json-16kx64 | 2097280 | 29965.6 ± 3.2% | 1605.5 ± 4.7% | 1103.1 ± 0.2% | 566.7 ± 0.3% | 1053.7 ± 0.4% | 459.6 ± 0.5% | 18.664 | 27.166 | 52.877 | 28.439 | 65.206 |
| hex: http/json-1m | 524290 | 31182.1 ± 0.4% | 1545.5 ± 3.7% | 1084.8 ± 0.5% | 583.2 ± 0.6% | 1038.8 ± 0.8% | 452.0 ± 0.6% | 20.176 | 28.744 | 53.466 | 30.017 | 68.993 |
| hex: http/js-1kx1024 | 2099200 | 23563.1 ± 4.7% | 1611.5 ± 13.7% | 1090.4 ± 0.7% | 438.0 ± 1.0% | 1074.0 ± 1.9% | 455.8 ± 0.4% | 14.622 | 21.609 | 53.792 | 21.940 | 51.692 |
| hex: http/js-16kx64 | 2097280 | 29924.8 ± 0.8% | 1609.9 ± 1.7% | 1104.6 ± 12.0% | 435.1 ± 20.3% | 1041.7 ± 0.6% | 458.9 ± 0.3% | 18.588 | 27.092 | 68.781 | 28.728 | 65.208 |
| hex: http/js-1m | 524290 | 30336.9 ± 18.4% | 1560.5 ± 0.2% | 1089.4 ± 0.2% | 433.4 ± 0.3% | 1043.4 ± 0.3% | 452.1 ± 2.1% | 19.441 | 27.848 | 69.996 | 29.076 | 67.097 |
| hex: http/css-1kx1024 | 2099200 | 23399.8 ± 1.0% | 1608.1 ± 1.7% | 1087.6 ± 1.0% | 496.3 ± 0.2% | 1065.7 ± 1.4% | 454.4 ± 0.4% | 14.551 | 21.515 | 47.146 | 21.958 | 51.502 |
| hex: http/css-16kx64 | 2097280 | 29795.2 ± 15.3% | 1610.0 ± 0.7% | 1103.4 ± 0.2% | 492.5 ± 0.3% | 1021.2 ± 18.1% | 458.7 ± 4.1% | 18.506 | 27.004 | 60.501 | 29.176 | 64.957 |
| hex: http/css-1m | 524290 | 31441.3 ± 1.5% | 1559.8 ± 0.9% | 1085.9 ± 0.7% | 450.4 ± 2.6% | 1038.1 ± 1.0% | 453.1 ± 0.8% | 20.157 | 28.954 | 69.806 | 30.287 | 69.394 |
| hex: shuffled/dickens-1m | 524290 | 34537.3 ± 2.8% | 1550.2 ± 4.9% | 1084.2 ± 0.3% | 429.6 ± 5.4% | 1046.9 ± 1.2% | 452.4 ± 0.7% | 22.279 | 31.855 | 80.400 | 32.989 | 76.347 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1347.1 ± 3.3% | 1131.3 ± 1.6% | 896.0 ± 0.7% | 328.9 ± 1.0% | 365.8 ± 0.3% | 312.1 ± 1.2% | 1.191 | 1.504 | 4.096 | 3.683 | 4.316 |
| qlog records, JSON text sequence | 1467503 | 1160.5 ± 11.6% | 866.9 ± 0.9% | 720.3 ± 2.3% | 315.1 ± 1.0% | 374.4 ± 13.2% | 224.4 ± 2.0% | 1.339 | 1.611 | 3.683 | 3.099 | 5.172 |
| string: silesia/dickens | 172528 | 8890.2 ± 2.2% | 2946.6 ± 1.8% | 2024.6 ± 0.4% | 355.8 ± 0.4% | 1411.8 ± 1.8% | 561.0 ± 2.0% | 3.017 | 4.391 | 24.983 | 6.297 | 15.848 |
| string: silesia/nci | 1075110 | 8271.7 ± 1.6% | 3181.7 ± 2.1% | 2789.0 ± 0.8% | 773.2 ± 0.7% | 1534.8 ± 0.6% | 560.0 ± 0.4% | 2.600 | 2.966 | 10.697 | 5.389 | 14.772 |
| string: silesia/reymont | 1075159 | 3818.4 ± 0.3% | 1637.5 ± 1.1% | 1718.7 ± 30.1% | 361.0 ± 2.5% | 1248.6 ± 0.8% | 549.3 ± 0.4% | 2.332 | 2.222 | 10.577 | 3.058 | 6.951 |
| string: silesia/samba | 97582 | 5037.2 ± 2.5% | 1976.0 ± 1.4% | 2158.8 ± 0.9% | 298.4 ± 1.0% | 1007.5 ± 19.4% | 623.1 ± 29.4% | 2.549 | 2.333 | 16.879 | 5.000 | 8.084 |
| string: silesia/webster | 1098490 | 5037.3 ± 1.3% | 1624.8 ± 1.9% | 1488.0 ± 0.6% | 352.6 ± 8.0% | 1196.1 ± 1.6% | 453.0 ± 0.4% | 3.100 | 3.385 | 14.287 | 4.212 | 11.119 |
| string: silesia/xml | 1090118 | 7897.1 ± 7.4% | 2659.8 ± 0.5% | 2167.4 ± 0.6% | 540.6 ± 3.0% | 1578.5 ± 0.9% | 562.1 ± 0.5% | 2.969 | 3.644 | 14.608 | 5.003 | 14.049 |
| string: canterbury/alice29.txt | 159425 | 9004.5 ± 0.5% | 2465.8 ± 3.6% | 1786.5 ± 1.8% | 337.6 ± 2.3% | 1256.9 ± 2.3% | 556.4 ± 0.4% | 3.652 | 5.040 | 26.672 | 7.164 | 16.183 |
| string: canterbury/asyoulik.txt | 132198 | 8117.0 ± 0.3% | 2166.1 ± 6.2% | 1528.6 ± 1.0% | 341.4 ± 2.0% | 1117.8 ± 1.2% | 543.5 ± 1.0% | 3.747 | 5.310 | 23.775 | 7.262 | 14.934 |
| string: canterbury/lcet10.txt | 441884 | 8544.5 ± 0.6% | 2473.4 ± 1.8% | 1976.4 ± 0.2% | 388.4 ± 0.9% | 1374.7 ± 0.5% | 553.2 ± 0.6% | 3.455 | 4.323 | 22.000 | 6.216 | 15.446 |
| string: canterbury/plrabn12.txt | 503330 | 6218.6 ± 1.0% | 1819.1 ± 0.9% | 1664.0 ± 0.1% | 360.7 ± 0.7% | 1289.6 ± 2.1% | 554.4 ± 6.3% | 3.418 | 3.737 | 17.241 | 4.822 | 11.216 |
| string: canterbury-large/E.coli | 1048578 | 35224.0 ± 22.7% | 10477.6 ± 2.0% | 3383.8 ± 0.5% | 1407.2 ± 1.0% | 2493.7 ± 2.4% | 581.1 ± 1.0% | 3.362 | 10.410 | 25.032 | 14.125 | 60.617 |
| string: canterbury-large/bible.txt | 1055886 | 7255.2 ± 0.3% | 3917.4 ± 1.4% | 2652.6 ± 0.4% | 432.8 ± 0.2% | 1858.7 ± 0.6% | 570.5 ± 1.7% | 1.852 | 2.735 | 16.763 | 3.903 | 12.718 |
| string: canterbury-large/world192.txt | 1103121 | 4815.6 ± 2.5% | 1441.3 ± 0.7% | 1573.8 ± 2.5% | 367.8 ± 0.9% | 1167.0 ± 0.9% | 539.4 ± 0.7% | 3.341 | 3.060 | 13.095 | 4.127 | 8.927 |
| string: http/html-1m | 1058582 | 8548.8 ± 0.3% | 3859.8 ± 1.6% | 2469.3 ± 5.1% | 394.5 ± 12.3% | 1807.4 ± 0.4% | 521.7 ± 0.8% | 2.215 | 3.462 | 21.670 | 4.730 | 16.386 |
| string: http/json-1m | 1190272 | 6517.3 ± 0.3% | 1228.3 ± 0.3% | 1268.2 ± 0.4% | 373.9 ± 2.5% | 890.2 ± 0.8% | 508.1 ± 1.1% | 5.306 | 5.139 | 17.429 | 7.321 | 12.826 |
| string: http/js-1m | 1144362 | 5007.9 ± 1.7% | 984.4 ± 1.0% | 1083.7 ± 0.4% | 281.9 ± 1.1% | 935.6 ± 1.2% | 471.7 ± 0.6% | 5.087 | 4.621 | 17.765 | 5.353 | 10.616 |
| string: http/css-1m | 1097820 | 6772.8 ± 2.7% | 1294.0 ± 0.3% | 1593.6 ± 0.4% | 401.4 ± 14.0% | 1048.5 ± 0.5% | 529.0 ± 0.2% | 5.234 | 4.250 | 16.875 | 6.459 | 12.802 |
| string: dickens as Cyrillic and CJK | 1883069 | 5245.4 ± 0.1% | 3030.3 ± 14.4% | 346.3 ± 1.7% | 270.8 ± 0.5% | 450.6 ± 5.5% | 290.8 ± 25.4% | 1.731 | 15.149 | 19.371 | 11.642 | 18.036 |
| hex: silesia/dickens | 524290 | 31312.7 ± 0.5% | 1552.4 ± 1.5% | 1085.6 ± 0.3% | 419.8 ± 2.7% | 1047.2 ± 1.0% | 449.0 ± 0.4% | 20.171 | 28.844 | 74.597 | 29.901 | 69.738 |
| hex: silesia/mozilla | 524290 | 35379.7 ± 0.5% | 1550.2 ± 0.6% | 1084.3 ± 0.5% | 369.5 ± 0.8% | 1049.1 ± 1.4% | 448.4 ± 1.0% | 22.823 | 32.629 | 95.762 | 33.725 | 78.906 |
| hex: silesia/mr | 524290 | 33136.0 ± 0.2% | 1549.2 ± 7.0% | 1085.2 ± 1.9% | 511.2 ± 0.7% | 1051.5 ± 1.1% | 448.2 ± 0.6% | 21.389 | 30.535 | 64.825 | 31.513 | 73.924 |
| hex: silesia/nci | 524290 | 32799.7 ± 0.3% | 1551.1 ± 0.4% | 1087.1 ± 9.3% | 556.8 ± 0.5% | 1052.3 ± 0.6% | 448.6 ± 0.6% | 21.146 | 30.172 | 58.910 | 31.170 | 73.119 |
| hex: silesia/ooffice | 524290 | 33129.9 ± 1.0% | 1550.0 ± 0.4% | 1085.1 ± 0.4% | 327.7 ± 1.1% | 1052.1 ± 12.6% | 450.8 ± 0.8% | 21.373 | 30.531 | 101.102 | 31.490 | 73.488 |
| hex: silesia/osdb | 524290 | 36117.2 ± 1.1% | 1552.7 ± 0.9% | 1085.7 ± 0.5% | 414.4 ± 0.3% | 1052.4 ± 1.8% | 451.3 ± 0.2% | 23.261 | 33.265 | 87.148 | 34.318 | 80.035 |
| hex: silesia/reymont | 524290 | 34320.9 ± 1.7% | 1550.4 ± 1.0% | 1085.5 ± 0.3% | 437.9 ± 0.5% | 1054.4 ± 0.6% | 449.1 ± 1.6% | 22.137 | 31.618 | 78.369 | 32.551 | 76.420 |
| hex: silesia/samba | 524290 | 33904.0 ± 2.7% | 1547.7 ± 1.4% | 1083.9 ± 1.5% | 333.3 ± 0.3% | 1055.5 ± 0.2% | 451.4 ± 0.7% | 21.906 | 31.280 | 101.725 | 32.122 | 75.109 |
| hex: silesia/sao | 524290 | 34485.4 ± 1.0% | 1555.4 ± 0.5% | 1085.2 ± 0.2% | 267.0 ± 8.9% | 1057.4 ± 0.2% | 452.3 ± 0.8% | 22.172 | 31.777 | 129.142 | 32.615 | 76.241 |
| hex: silesia/webster | 524290 | 36965.6 ± 2.1% | 1548.5 ± 17.7% | 1083.1 ± 1.4% | 387.4 ± 1.2% | 1053.8 ± 0.3% | 451.6 ± 1.6% | 23.873 | 34.129 | 95.415 | 35.078 | 81.852 |
| hex: silesia/x-ray | 524290 | 33231.3 ± 13.4% | 1553.9 ± 0.9% | 1086.5 ± 0.2% | 394.5 ± 0.7% | 1051.8 ± 15.4% | 448.3 ± 7.5% | 21.386 | 30.585 | 84.230 | 31.596 | 74.132 |
| hex: silesia/xml | 524290 | 33790.7 ± 0.9% | 1551.6 ± 0.3% | 1085.8 ± 2.1% | 586.7 ± 0.2% | 1052.4 ± 0.3% | 449.9 ± 1.7% | 21.778 | 31.121 | 57.598 | 32.108 | 75.103 |
| hex: canterbury/alice29.txt | 304180 | 33305.4 ± 0.5% | 1576.6 ± 1.9% | 1087.7 ± 0.4% | 429.0 ± 0.5% | 1069.8 ± 0.9% | 453.5 ± 0.8% | 21.125 | 30.621 | 77.639 | 31.131 | 73.444 |
| hex: canterbury/asyoulik.txt | 250360 | 31547.4 ± 0.3% | 1601.8 ± 0.6% | 1091.7 ± 1.7% | 424.2 ± 1.7% | 1077.3 ± 20.3% | 454.1 ± 71.4% | 19.695 | 28.898 | 74.369 | 29.283 | 69.468 |
| hex: canterbury/cp.html | 49208 | 31698.8 ± 0.3% | 1620.5 ± 13.2% | 1112.5 ± 0.3% | 457.2 ± 0.6% | 1078.4 ± 0.3% | 459.0 ± 0.2% | 19.562 | 28.494 | 69.336 | 29.394 | 69.062 |
| hex: canterbury/fields.c | 22302 | 32656.7 ± 3.2% | 1599.4 ± 13.3% | 1103.2 ± 2.0% | 547.7 ± 0.9% | 1071.5 ± 0.5% | 460.5 ± 0.1% | 20.418 | 29.602 | 59.624 | 30.477 | 70.914 |
| hex: canterbury/grammar.lsp | 7444 | 33510.0 ± 0.2% | 1626.8 ± 0.8% | 1111.4 ± 1.5% | 584.4 ± 0.4% | 1088.9 ± 0.3% | 462.2 ± 1.7% | 20.598 | 30.152 | 57.346 | 30.774 | 72.506 |
| hex: canterbury/kennedy.xls | 524290 | 31668.3 ± 0.6% | 1541.6 ± 1.3% | 1083.1 ± 7.6% | 593.4 ± 0.4% | 1049.8 ± 0.8% | 450.0 ± 0.5% | 20.542 | 29.237 | 53.364 | 30.165 | 70.371 |
| hex: canterbury/lcet10.txt | 524290 | 34972.3 ± 1.7% | 1556.2 ± 0.6% | 1082.6 ± 1.2% | 421.5 ± 0.6% | 1052.1 ± 7.5% | 451.2 ± 0.6% | 22.473 | 32.304 | 82.980 | 33.239 | 77.511 |
| hex: canterbury/plrabn12.txt | 524290 | 33180.5 ± 0.3% | 1550.5 ± 0.6% | 1083.1 ± 12.3% | 421.4 ± 0.2% | 1054.5 ± 1.1% | 451.2 ± 0.7% | 21.400 | 30.634 | 78.732 | 31.466 | 73.543 |
| hex: canterbury/ptt5 | 524290 | 33402.7 ± 15.4% | 1554.2 ± 0.5% | 1084.0 ± 0.5% | 502.2 ± 2.7% | 1050.8 ± 10.0% | 453.1 ± 4.1% | 21.492 | 30.816 | 66.514 | 31.788 | 73.725 |
| hex: canterbury/sum | 76482 | 34919.0 ± 0.2% | 1614.8 ± 0.2% | 1106.4 ± 0.1% | 507.6 ± 0.5% | 1071.0 ± 0.6% | 460.7 ± 1.2% | 21.625 | 31.560 | 68.788 | 32.604 | 75.791 |
| hex: canterbury/xargs.1 | 8456 | 35060.4 ± 0.3% | 1631.7 ± 0.5% | 1112.0 ± 0.5% | 616.5 ± 1.0% | 1087.7 ± 1.5% | 463.8 ± 0.5% | 21.487 | 31.529 | 56.871 | 32.235 | 75.598 |
| hex: canterbury-large/E.coli | 524290 | 30823.1 ± 0.9% | 1552.7 ± 0.6% | 1084.8 ± 0.3% | 607.3 ± 0.4% | 1052.8 ± 0.7% | 449.0 ± 1.2% | 19.851 | 28.413 | 50.755 | 29.277 | 68.652 |
| hex: canterbury-large/bible.txt | 524290 | 35396.6 ± 0.8% | 1557.7 ± 18.7% | 1086.0 ± 0.2% | 434.7 ± 0.4% | 1043.6 ± 2.1% | 450.9 ± 0.8% | 22.723 | 32.594 | 81.431 | 33.918 | 78.501 |
| hex: canterbury-large/world192.txt | 524290 | 35075.9 ± 8.4% | 1552.4 ± 0.5% | 1083.2 ± 10.3% | 422.7 ± 0.3% | 1048.6 ± 1.1% | 449.4 ± 0.5% | 22.594 | 32.381 | 82.972 | 33.450 | 78.055 |
| hex: http/html-1kx1024 | 2099200 | 24211.9 ± 1.3% | 1607.6 ± 14.9% | 1088.6 ± 17.5% | 447.9 ± 0.2% | 1072.0 ± 2.5% | 455.4 ± 0.4% | 15.061 | 22.242 | 54.059 | 22.585 | 53.171 |
| hex: http/html-16kx64 | 2097280 | 29993.8 ± 15.8% | 1606.3 ± 10.7% | 1103.4 ± 5.7% | 446.8 ± 0.2% | 1036.7 ± 0.5% | 457.0 ± 0.5% | 18.672 | 27.183 | 67.137 | 28.931 | 65.636 |
| hex: http/html-1m | 524290 | 29250.4 ± 0.6% | 1543.0 ± 0.7% | 1082.5 ± 8.4% | 444.4 ± 12.4% | 1045.9 ± 16.5% | 450.6 ± 1.5% | 18.956 | 27.022 | 65.824 | 27.966 | 64.917 |
| hex: http/json-1kx1024 | 2099200 | 24115.1 ± 0.9% | 1611.3 ± 3.5% | 1091.1 ± 0.8% | 564.2 ± 0.2% | 1066.8 ± 0.7% | 454.0 ± 4.5% | 14.966 | 22.101 | 42.746 | 22.604 | 53.122 |
| hex: http/json-16kx64 | 2097280 | 30351.7 ± 0.8% | 1605.5 ± 4.7% | 1103.1 ± 0.2% | 566.7 ± 0.3% | 1053.7 ± 0.4% | 459.6 ± 0.5% | 18.904 | 27.516 | 53.559 | 28.805 | 66.046 |
| hex: http/json-1m | 524290 | 31358.3 ± 0.6% | 1545.5 ± 3.7% | 1084.8 ± 0.5% | 583.2 ± 0.6% | 1038.8 ± 0.8% | 452.0 ± 0.6% | 20.290 | 28.906 | 53.768 | 30.187 | 69.383 |
| hex: http/js-1kx1024 | 2099200 | 24216.3 ± 24.5% | 1611.5 ± 13.7% | 1090.4 ± 0.7% | 438.0 ± 1.0% | 1074.0 ± 1.9% | 455.8 ± 0.4% | 15.027 | 22.208 | 55.283 | 22.548 | 53.125 |
| hex: http/js-16kx64 | 2097280 | 30284.9 ± 0.9% | 1609.9 ± 1.7% | 1104.6 ± 12.0% | 435.1 ± 20.3% | 1041.7 ± 0.6% | 458.9 ± 0.3% | 18.812 | 27.418 | 69.609 | 29.074 | 65.993 |
| hex: http/js-1m | 524290 | 30776.2 ± 0.4% | 1560.5 ± 0.2% | 1089.4 ± 0.2% | 433.4 ± 0.3% | 1043.4 ± 0.3% | 452.1 ± 2.1% | 19.722 | 28.252 | 71.010 | 29.497 | 68.069 |
| hex: http/css-1kx1024 | 2099200 | 24151.0 ± 1.9% | 1608.1 ± 1.7% | 1087.6 ± 1.0% | 496.3 ± 0.2% | 1065.7 ± 1.4% | 454.4 ± 0.4% | 15.018 | 22.205 | 48.660 | 22.663 | 53.155 |
| hex: http/css-16kx64 | 2097280 | 30334.6 ± 0.7% | 1610.0 ± 0.7% | 1103.4 ± 0.2% | 492.5 ± 0.3% | 1021.2 ± 18.1% | 458.7 ± 4.1% | 18.842 | 27.492 | 61.596 | 29.704 | 66.133 |
| hex: http/css-1m | 524290 | 31414.2 ± 13.4% | 1559.8 ± 0.9% | 1085.9 ± 0.7% | 450.4 ± 2.6% | 1038.1 ± 1.0% | 453.1 ± 0.8% | 20.140 | 28.929 | 69.746 | 30.261 | 69.335 |
| hex: shuffled/dickens-1m | 524290 | 35128.2 ± 0.4% | 1550.2 ± 4.9% | 1084.2 ± 0.3% | 429.6 ± 5.4% | 1046.9 ± 1.2% | 452.4 ± 0.7% | 22.660 | 32.400 | 81.776 | 33.553 | 77.653 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 829.6 ± 2.7% | 997.7 ± 0.3% | 979.8 ± 2.2% | 287.7 ± 1.0% | 529.9 ± 3.5% | 257.3 ± 2.3% | 0.831 | 0.847 | 2.883 | 1.565 | 3.225 |
| qlog records, JSON text sequence | 1467503 | 766.3 ± 2.4% | 808.9 ± 0.1% | 807.8 ± 1.2% | 237.6 ± 3.0% | 576.2 ± 8.3% | 232.7 ± 17.4% | 0.947 | 0.949 | 3.225 | 1.330 | 3.293 |
| string: silesia/dickens | 172528 | 5490.3 ± 0.8% | 2894.9 ± 0.5% | 2060.0 ± 1.5% | 301.9 ± 0.8% | 2181.1 ± 6.1% | 491.2 ± 3.6% | 1.897 | 2.665 | 18.185 | 2.517 | 11.178 |
| string: silesia/nci | 1075110 | 5218.0 ± 0.4% | 3479.6 ± 0.9% | 2802.7 ± 10.6% | 503.0 ± 0.8% | 2372.9 ± 0.2% | 519.1 ± 0.8% | 1.500 | 1.862 | 10.373 | 2.199 | 10.052 |
| string: silesia/reymont | 1075159 | 2794.5 ± 1.0% | 2195.5 ± 0.3% | 1761.6 ± 6.8% | 318.8 ± 0.3% | 1637.6 ± 0.3% | 471.4 ± 1.5% | 1.273 | 1.586 | 8.765 | 1.706 | 5.929 |
| string: silesia/samba | 97582 | 3365.3 ± 1.8% | 2881.6 ± 0.3% | 1714.3 ± 11.1% | 262.1 ± 0.2% | 1281.2 ± 0.3% | 349.8 ± 0.9% | 1.168 | 1.963 | 12.839 | 2.627 | 9.620 |
| string: silesia/webster | 1098490 | 3694.6 ± 0.9% | 2036.1 ± 0.6% | 1610.2 ± 1.3% | 306.6 ± 1.3% | 1660.8 ± 1.7% | 439.6 ± 1.3% | 1.815 | 2.295 | 12.049 | 2.225 | 8.405 |
| string: silesia/xml | 1090118 | 5145.6 ± 0.4% | 3698.0 ± 1.1% | 2110.7 ± 1.0% | 408.8 ± 0.6% | 2376.5 ± 0.7% | 519.5 ± 0.4% | 1.391 | 2.438 | 12.587 | 2.165 | 9.904 |
| string: canterbury/alice29.txt | 159425 | 4532.2 ± 1.8% | 2406.6 ± 2.1% | 1821.2 ± 5.8% | 283.5 ± 1.8% | 1917.9 ± 1.1% | 437.2 ± 14.8% | 1.883 | 2.489 | 15.986 | 2.363 | 10.367 |
| string: canterbury/asyoulik.txt | 132198 | 3743.5 ± 4.3% | 2100.5 ± 0.3% | 1478.2 ± 1.5% | 274.0 ± 1.9% | 1555.6 ± 18.0% | 396.8 ± 5.2% | 1.782 | 2.532 | 13.662 | 2.406 | 9.434 |
| string: canterbury/lcet10.txt | 441884 | 5703.6 ± 0.9% | 2792.2 ± 0.7% | 1953.3 ± 1.3% | 325.1 ± 7.7% | 2133.2 ± 1.3% | 483.0 ± 1.6% | 2.043 | 2.920 | 17.545 | 2.674 | 11.808 |
| string: canterbury/plrabn12.txt | 503330 | 4449.7 ± 0.3% | 2688.1 ± 0.1% | 1666.7 ± 0.5% | 296.2 ± 2.4% | 2000.3 ± 1.4% | 457.3 ± 1.4% | 1.655 | 2.670 | 15.021 | 2.225 | 9.730 |
| string: canterbury-large/E.coli | 1048578 | 33538.5 ± 0.3% | 7624.4 ± 0.3% | 3419.9 ± 0.4% | 800.9 ± 0.5% | 5518.8 ± 1.3% | 798.4 ± 0.9% | 4.399 | 9.807 | 41.875 | 6.077 | 42.009 |
| string: canterbury-large/bible.txt | 1055886 | 6617.2 ± 1.0% | 3901.7 ± 0.6% | 2491.5 ± 1.1% | 352.8 ± 0.2% | 2982.5 ± 14.6% | 570.9 ± 1.8% | 1.696 | 2.656 | 18.759 | 2.219 | 11.592 |
| string: canterbury-large/world192.txt | 1103121 | 3485.1 ± 0.3% | 1974.8 ± 2.3% | 1620.7 ± 0.3% | 296.2 ± 0.6% | 1696.9 ± 0.6% | 414.4 ± 31.4% | 1.765 | 2.150 | 11.765 | 2.054 | 8.409 |
| string: http/html-1m | 1058582 | 6258.7 ± 0.6% | 3396.2 ± 0.4% | 2350.8 ± 2.3% | 408.1 ± 0.6% | 2731.5 ± 0.8% | 407.5 ± 4.0% | 1.843 | 2.662 | 15.337 | 2.291 | 15.357 |
| string: http/json-1m | 1190272 | 3343.3 ± 1.0% | 1195.6 ± 0.3% | 1480.2 ± 6.5% | 353.3 ± 1.2% | 838.5 ± 1.5% | 283.3 ± 1.3% | 2.796 | 2.259 | 9.463 | 3.987 | 11.803 |
| string: http/js-1m | 1144362 | 2260.2 ± 0.8% | 1323.6 ± 0.3% | 1143.5 ± 1.2% | 278.9 ± 0.8% | 1157.2 ± 3.2% | 284.8 ± 0.9% | 1.708 | 1.976 | 8.104 | 1.953 | 7.935 |
| string: http/css-1m | 1097820 | 3017.3 ± 0.4% | 2501.6 ± 0.3% | 1541.0 ± 2.7% | 372.7 ± 0.3% | 1556.2 ± 1.7% | 317.0 ± 0.9% | 1.206 | 1.958 | 8.095 | 1.939 | 9.517 |
| string: dickens as Cyrillic and CJK | 1883069 | 5187.4 ± 0.5% | 3209.3 ± 0.6% | 647.6 ± 1.0% | 256.8 ± 5.7% | 513.2 ± 3.8% | 137.2 ± 1.5% | 1.616 | 8.010 | 20.200 | 10.108 | 37.803 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1060.5 ± 3.0% | 1076.9 ± 1.9% | 811.6 ± 2.5% | 161.7 ± 0.7% | 383.9 ± 1.3% | 199.5 ± 2.8% | 0.985 | 1.307 | 6.557 | 2.762 | 5.315 |
| hex: silesia/dickens | 524290 | 33367.5 ± 1.4% | 7606.1 ± 1.0% | 3442.0 ± 13.6% | 467.8 ± 14.2% | 5525.4 ± 0.7% | 799.4 ± 2.1% | 4.387 | 9.694 | 71.329 | 6.039 | 41.739 |
| hex: silesia/mozilla | 524290 | 33501.1 ± 0.7% | 7655.5 ± 0.9% | 3432.1 ± 1.7% | 408.3 ± 1.6% | 5510.3 ± 1.0% | 798.2 ± 1.9% | 4.376 | 9.761 | 82.045 | 6.080 | 41.971 |
| hex: silesia/mr | 524290 | 33587.2 ± 0.5% | 7658.8 ± 0.4% | 3437.5 ± 0.5% | 581.8 ± 0.5% | 5524.8 ± 0.9% | 798.5 ± 1.4% | 4.385 | 9.771 | 57.733 | 6.079 | 42.065 |
| hex: silesia/nci | 524290 | 33219.6 ± 0.4% | 7630.9 ± 0.7% | 3439.3 ± 0.5% | 644.5 ± 0.5% | 5489.7 ± 17.4% | 797.0 ± 1.1% | 4.353 | 9.659 | 51.542 | 6.051 | 41.681 |
| hex: silesia/ooffice | 524290 | 33606.7 ± 0.4% | 7646.9 ± 0.3% | 3427.6 ± 0.6% | 356.2 ± 0.6% | 5533.6 ± 1.0% | 800.4 ± 1.1% | 4.395 | 9.805 | 94.358 | 6.073 | 41.986 |
| hex: silesia/osdb | 524290 | 33207.3 ± 0.5% | 7631.8 ± 0.6% | 3446.4 ± 1.1% | 453.4 ± 5.2% | 5506.6 ± 30.9% | 797.3 ± 1.1% | 4.351 | 9.635 | 73.245 | 6.030 | 41.649 |
| hex: silesia/reymont | 524290 | 33187.6 ± 2.1% | 7625.6 ± 5.1% | 3419.6 ± 2.5% | 487.6 ± 0.5% | 5535.0 ± 0.7% | 800.1 ± 1.1% | 4.352 | 9.705 | 68.057 | 5.996 | 41.480 |
| hex: silesia/samba | 524290 | 33293.6 ± 0.4% | 7645.9 ± 0.6% | 3438.1 ± 0.9% | 361.7 ± 0.3% | 5501.9 ± 1.1% | 802.2 ± 0.8% | 4.354 | 9.684 | 92.057 | 6.051 | 41.504 |
| hex: silesia/sao | 524290 | 33471.6 ± 0.4% | 7655.6 ± 0.6% | 3432.0 ± 0.6% | 287.8 ± 4.3% | 5507.7 ± 0.8% | 802.2 ± 0.5% | 4.372 | 9.753 | 116.317 | 6.077 | 41.725 |
| hex: silesia/webster | 524290 | 33320.0 ± 0.7% | 7618.8 ± 0.9% | 3438.9 ± 0.3% | 435.5 ± 0.2% | 5521.6 ± 0.6% | 802.7 ± 0.7% | 4.373 | 9.689 | 76.510 | 6.035 | 41.512 |
| hex: silesia/x-ray | 524290 | 33082.2 ± 0.6% | 7647.6 ± 0.5% | 3423.3 ± 1.4% | 435.2 ± 0.5% | 5510.8 ± 0.8% | 798.3 ± 0.8% | 4.326 | 9.664 | 76.014 | 6.003 | 41.438 |
| hex: silesia/xml | 524290 | 33448.9 ± 0.6% | 7662.5 ± 1.3% | 3428.7 ± 0.4% | 602.5 ± 0.4% | 5496.7 ± 1.2% | 800.7 ± 1.0% | 4.365 | 9.756 | 55.521 | 6.085 | 41.777 |
| hex: canterbury/alice29.txt | 304180 | 33608.2 ± 0.7% | 7778.1 ± 0.9% | 3510.8 ± 1.1% | 469.5 ± 1.2% | 5506.2 ± 0.8% | 802.6 ± 1.1% | 4.321 | 9.573 | 71.583 | 6.104 | 41.874 |
| hex: canterbury/asyoulik.txt | 250360 | 33614.6 ± 1.4% | 7744.2 ± 0.5% | 3532.2 ± 1.6% | 461.4 ± 0.5% | 5507.1 ± 18.0% | 805.5 ± 1.9% | 4.341 | 9.517 | 72.853 | 6.104 | 41.731 |
| hex: canterbury/cp.html | 49208 | 32739.0 ± 8.2% | 7782.7 ± 0.3% | 3609.1 ± 11.0% | 462.0 ± 1.0% | 5486.7 ± 0.6% | 789.4 ± 2.1% | 4.207 | 9.071 | 70.859 | 5.967 | 41.472 |
| hex: canterbury/fields.c | 22302 | 31621.7 ± 0.9% | 7690.7 ± 0.2% | 3607.1 ± 7.0% | 487.9 ± 0.6% | 5472.3 ± 0.9% | 777.1 ± 1.2% | 4.112 | 8.766 | 64.818 | 5.779 | 40.691 |
| hex: canterbury/grammar.lsp | 7444 | 27460.0 ± 11.5% | 7486.8 ± 0.3% | 3563.5 ± 1.3% | 534.2 ± 1.0% | 5371.0 ± 3.2% | 754.8 ± 5.1% | 3.668 | 7.706 | 51.403 | 5.113 | 36.381 |
| hex: canterbury/kennedy.xls | 524290 | 33376.6 ± 0.4% | 7637.9 ± 1.0% | 3446.4 ± 2.5% | 684.6 ± 0.6% | 5486.1 ± 1.1% | 792.5 ± 7.4% | 4.370 | 9.685 | 48.756 | 6.084 | 42.115 |
| hex: canterbury/lcet10.txt | 524290 | 33530.2 ± 1.1% | 7629.2 ± 0.5% | 3442.5 ± 0.5% | 471.8 ± 1.0% | 5515.9 ± 0.4% | 799.5 ± 2.2% | 4.395 | 9.740 | 71.075 | 6.079 | 41.940 |
| hex: canterbury/plrabn12.txt | 524290 | 33504.7 ± 0.3% | 7647.3 ± 0.9% | 3419.5 ± 0.6% | 460.6 ± 1.2% | 5507.8 ± 1.0% | 805.3 ± 0.8% | 4.381 | 9.798 | 72.741 | 6.083 | 41.607 |
| hex: canterbury/ptt5 | 524290 | 33653.9 ± 2.1% | 7603.5 ± 1.3% | 3434.4 ± 0.3% | 565.5 ± 13.0% | 5490.0 ± 1.1% | 796.7 ± 2.4% | 4.426 | 9.799 | 59.510 | 6.130 | 42.240 |
| hex: canterbury/sum | 76482 | 33246.4 ± 0.1% | 7799.2 ± 0.8% | 3617.5 ± 0.3% | 526.1 ± 0.6% | 5503.8 ± 1.8% | 800.7 ± 3.3% | 4.263 | 9.190 | 63.192 | 6.041 | 41.523 |
| hex: canterbury/xargs.1 | 8456 | 28040.1 ± 3.3% | 7518.6 ± 3.4% | 3540.4 ± 1.6% | 523.3 ± 5.4% | 5369.4 ± 0.4% | 781.3 ± 17.8% | 3.729 | 7.920 | 53.587 | 5.222 | 35.891 |
| hex: canterbury-large/E.coli | 524290 | 33374.3 ± 0.3% | 7574.3 ± 0.9% | 3431.0 ± 1.6% | 710.5 ± 0.2% | 5511.5 ± 0.6% | 789.9 ± 4.8% | 4.406 | 9.727 | 46.974 | 6.055 | 42.249 |
| hex: canterbury-large/bible.txt | 524290 | 33468.1 ± 0.4% | 7637.1 ± 0.5% | 3427.3 ± 1.7% | 487.5 ± 1.0% | 5499.5 ± 1.4% | 798.0 ± 2.0% | 4.382 | 9.765 | 68.652 | 6.086 | 41.940 |
| hex: canterbury-large/world192.txt | 524290 | 33357.2 ± 1.7% | 7633.6 ± 0.4% | 3430.4 ± 1.1% | 454.3 ± 0.2% | 5483.3 ± 1.3% | 795.1 ± 0.4% | 4.370 | 9.724 | 73.418 | 6.083 | 41.951 |
| hex: http/html-1kx1024 | 2099200 | 16262.5 ± 2.2% | 6592.4 ± 0.2% | 3232.0 ± 0.7% | 485.7 ± 2.0% | 4698.2 ± 2.5% | 712.0 ± 2.6% | 2.467 | 5.032 | 33.485 | 3.461 | 22.841 |
| hex: http/html-16kx64 | 2097280 | 30183.0 ± 0.7% | 7618.3 ± 0.1% | 3489.8 ± 0.8% | 494.6 ± 6.7% | 5408.3 ± 5.2% | 778.3 ± 4.1% | 3.962 | 8.649 | 61.028 | 5.581 | 38.780 |
| hex: http/html-1m | 524290 | 33210.9 ± 0.3% | 7611.7 ± 1.3% | 3408.2 ± 0.5% | 492.4 ± 0.5% | 5505.5 ± 0.2% | 786.1 ± 3.8% | 4.363 | 9.744 | 67.453 | 6.032 | 42.250 |
| hex: http/json-1kx1024 | 2099200 | 16410.3 ± 0.9% | 6602.1 ± 5.6% | 3225.1 ± 17.4% | 613.6 ± 2.8% | 4707.9 ± 1.0% | 694.7 ± 5.1% | 2.486 | 5.088 | 26.746 | 3.486 | 23.623 |
| hex: http/json-16kx64 | 2097280 | 30575.5 ± 1.6% | 7655.5 ± 0.5% | 3459.8 ± 1.5% | 631.6 ± 0.8% | 5381.7 ± 8.3% | 780.4 ± 2.8% | 3.994 | 8.837 | 48.408 | 5.681 | 39.178 |
| hex: http/json-1m | 524290 | 33264.6 ± 4.8% | 7671.6 ± 1.0% | 3438.0 ± 1.0% | 639.8 ± 0.7% | 5514.4 ± 1.3% | 794.1 ± 3.0% | 4.336 | 9.676 | 51.995 | 6.032 | 41.887 |
| hex: http/js-1kx1024 | 2099200 | 16327.8 ± 6.7% | 6605.4 ± 1.0% | 3213.8 ± 2.5% | 466.5 ± 1.4% | 4705.8 ± 0.4% | 704.0 ± 5.1% | 2.472 | 5.080 | 35.000 | 3.470 | 23.194 |
| hex: http/js-16kx64 | 2097280 | 30378.3 ± 1.4% | 7653.8 ± 0.4% | 3487.8 ± 0.9% | 478.9 ± 1.0% | 5413.9 ± 0.5% | 787.3 ± 2.6% | 3.969 | 8.710 | 63.438 | 5.611 | 38.585 |
| hex: http/js-1m | 524290 | 33395.9 ± 7.7% | 7635.1 ± 0.4% | 3428.1 ± 0.4% | 492.9 ± 2.6% | 5523.2 ± 1.0% | 800.3 ± 3.0% | 4.374 | 9.742 | 67.747 | 6.047 | 41.730 |
| hex: http/css-1kx1024 | 2099200 | 16403.9 ± 1.5% | 6594.9 ± 0.2% | 3211.8 ± 1.1% | 534.8 ± 2.9% | 4700.1 ± 0.4% | 713.1 ± 4.2% | 2.487 | 5.107 | 30.673 | 3.490 | 23.004 |
| hex: http/css-16kx64 | 2097280 | 30625.1 ± 8.3% | 7655.9 ± 0.3% | 3492.0 ± 0.5% | 549.6 ± 7.1% | 5418.5 ± 0.3% | 777.2 ± 3.2% | 4.000 | 8.770 | 55.718 | 5.652 | 39.407 |
| hex: http/css-1m | 524290 | 33265.4 ± 2.4% | 7648.9 ± 0.5% | 3443.8 ± 0.9% | 532.4 ± 0.6% | 5476.4 ± 4.0% | 803.1 ± 1.6% | 4.349 | 9.659 | 62.480 | 6.074 | 41.423 |
| hex: shuffled/dickens-1m | 524290 | 33507.7 ± 0.3% | 7640.1 ± 0.7% | 3427.8 ± 0.7% | 469.9 ± 1.1% | 5516.8 ± 1.0% | 809.9 ± 2.0% | 4.386 | 9.775 | 71.313 | 6.074 | 41.375 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 961.4 ± 8.3% | 997.7 ± 0.3% | 979.8 ± 2.2% | 287.7 ± 1.0% | 529.9 ± 3.5% | 257.3 ± 2.3% | 0.964 | 0.981 | 3.342 | 1.814 | 3.737 |
| qlog records, JSON text sequence | 1467503 | 871.2 ± 3.0% | 808.9 ± 0.1% | 807.8 ± 1.2% | 237.6 ± 3.0% | 576.2 ± 8.3% | 232.7 ± 17.4% | 1.077 | 1.078 | 3.667 | 1.512 | 3.744 |
| string: silesia/dickens | 172528 | 5393.6 ± 0.7% | 2894.9 ± 0.5% | 2060.0 ± 1.5% | 301.9 ± 0.8% | 2181.1 ± 6.1% | 491.2 ± 3.6% | 1.863 | 2.618 | 17.865 | 2.473 | 10.981 |
| string: silesia/nci | 1075110 | 5204.1 ± 0.4% | 3479.6 ± 0.9% | 2802.7 ± 10.6% | 503.0 ± 0.8% | 2372.9 ± 0.2% | 519.1 ± 0.8% | 1.496 | 1.857 | 10.346 | 2.193 | 10.025 |
| string: silesia/reymont | 1075159 | 2768.2 ± 38.2% | 2195.5 ± 0.3% | 1761.6 ± 6.8% | 318.8 ± 0.3% | 1637.6 ± 0.3% | 471.4 ± 1.5% | 1.261 | 1.571 | 8.682 | 1.690 | 5.873 |
| string: silesia/samba | 97582 | 3370.4 ± 0.4% | 2881.6 ± 0.3% | 1714.3 ± 11.1% | 262.1 ± 0.2% | 1281.2 ± 0.3% | 349.8 ± 0.9% | 1.170 | 1.966 | 12.858 | 2.631 | 9.635 |
| string: silesia/webster | 1098490 | 3696.3 ± 1.9% | 2036.1 ± 0.6% | 1610.2 ± 1.3% | 306.6 ± 1.3% | 1660.8 ± 1.7% | 439.6 ± 1.3% | 1.815 | 2.296 | 12.055 | 2.226 | 8.409 |
| string: silesia/xml | 1090118 | 5163.9 ± 0.4% | 3698.0 ± 1.1% | 2110.7 ± 1.0% | 408.8 ± 0.6% | 2376.5 ± 0.7% | 519.5 ± 0.4% | 1.396 | 2.447 | 12.632 | 2.173 | 9.939 |
| string: canterbury/alice29.txt | 159425 | 4543.1 ± 3.1% | 2406.6 ± 2.1% | 1821.2 ± 5.8% | 283.5 ± 1.8% | 1917.9 ± 1.1% | 437.2 ± 14.8% | 1.888 | 2.495 | 16.024 | 2.369 | 10.391 |
| string: canterbury/asyoulik.txt | 132198 | 3782.5 ± 4.3% | 2100.5 ± 0.3% | 1478.2 ± 1.5% | 274.0 ± 1.9% | 1555.6 ± 18.0% | 396.8 ± 5.2% | 1.801 | 2.559 | 13.805 | 2.432 | 9.532 |
| string: canterbury/lcet10.txt | 441884 | 5702.6 ± 0.3% | 2792.2 ± 0.7% | 1953.3 ± 1.3% | 325.1 ± 7.7% | 2133.2 ± 1.3% | 483.0 ± 1.6% | 2.042 | 2.920 | 17.542 | 2.673 | 11.806 |
| string: canterbury/plrabn12.txt | 503330 | 4430.4 ± 1.4% | 2688.1 ± 0.1% | 1666.7 ± 0.5% | 296.2 ± 2.4% | 2000.3 ± 1.4% | 457.3 ± 1.4% | 1.648 | 2.658 | 14.955 | 2.215 | 9.688 |
| string: canterbury-large/E.coli | 1048578 | 33518.6 ± 12.8% | 7624.4 ± 0.3% | 3419.9 ± 0.4% | 800.9 ± 0.5% | 5518.8 ± 1.3% | 798.4 ± 0.9% | 4.396 | 9.801 | 41.851 | 6.074 | 41.984 |
| string: canterbury-large/bible.txt | 1055886 | 6620.4 ± 6.7% | 3901.7 ± 0.6% | 2491.5 ± 1.1% | 352.8 ± 0.2% | 2982.5 ± 14.6% | 570.9 ± 1.8% | 1.697 | 2.657 | 18.768 | 2.220 | 11.597 |
| string: canterbury-large/world192.txt | 1103121 | 3483.6 ± 0.7% | 1974.8 ± 2.3% | 1620.7 ± 0.3% | 296.2 ± 0.6% | 1696.9 ± 0.6% | 414.4 ± 31.4% | 1.764 | 2.149 | 11.760 | 2.053 | 8.406 |
| string: http/html-1m | 1058582 | 6260.2 ± 0.3% | 3396.2 ± 0.4% | 2350.8 ± 2.3% | 408.1 ± 0.6% | 2731.5 ± 0.8% | 407.5 ± 4.0% | 1.843 | 2.663 | 15.341 | 2.292 | 15.361 |
| string: http/json-1m | 1190272 | 3348.1 ± 0.1% | 1195.6 ± 0.3% | 1480.2 ± 6.5% | 353.3 ± 1.2% | 838.5 ± 1.5% | 283.3 ± 1.3% | 2.800 | 2.262 | 9.477 | 3.993 | 11.820 |
| string: http/js-1m | 1144362 | 2260.0 ± 0.9% | 1323.6 ± 0.3% | 1143.5 ± 1.2% | 278.9 ± 0.8% | 1157.2 ± 3.2% | 284.8 ± 0.9% | 1.708 | 1.976 | 8.103 | 1.953 | 7.935 |
| string: http/css-1m | 1097820 | 3037.7 ± 6.2% | 2501.6 ± 0.3% | 1541.0 ± 2.7% | 372.7 ± 0.3% | 1556.2 ± 1.7% | 317.0 ± 0.9% | 1.214 | 1.971 | 8.150 | 1.952 | 9.582 |
| string: dickens as Cyrillic and CJK | 1883069 | 5174.3 ± 0.5% | 3209.3 ± 0.6% | 647.6 ± 1.0% | 256.8 ± 5.7% | 513.2 ± 3.8% | 137.2 ± 1.5% | 1.612 | 7.990 | 20.149 | 10.082 | 37.707 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1063.5 ± 4.3% | 1076.9 ± 1.9% | 811.6 ± 2.5% | 161.7 ± 0.7% | 383.9 ± 1.3% | 199.5 ± 2.8% | 0.988 | 1.310 | 6.576 | 2.770 | 5.330 |
| hex: silesia/dickens | 524290 | 33354.5 ± 0.9% | 7606.1 ± 1.0% | 3442.0 ± 13.6% | 467.8 ± 14.2% | 5525.4 ± 0.7% | 799.4 ± 2.1% | 4.385 | 9.690 | 71.301 | 6.037 | 41.723 |
| hex: silesia/mozilla | 524290 | 33429.9 ± 0.3% | 7655.5 ± 0.9% | 3432.1 ± 1.7% | 408.3 ± 1.6% | 5510.3 ± 1.0% | 798.2 ± 1.9% | 4.367 | 9.740 | 81.870 | 6.067 | 41.882 |
| hex: silesia/mr | 524290 | 33602.5 ± 1.5% | 7658.8 ± 0.4% | 3437.5 ± 0.5% | 581.8 ± 0.5% | 5524.8 ± 0.9% | 798.5 ± 1.4% | 4.387 | 9.775 | 57.759 | 6.082 | 42.084 |
| hex: silesia/nci | 524290 | 33300.5 ± 1.0% | 7630.9 ± 0.7% | 3439.3 ± 0.5% | 644.5 ± 0.5% | 5489.7 ± 17.4% | 797.0 ± 1.1% | 4.364 | 9.682 | 51.667 | 6.066 | 41.783 |
| hex: silesia/ooffice | 524290 | 33518.9 ± 0.5% | 7646.9 ± 0.3% | 3427.6 ± 0.6% | 356.2 ± 0.6% | 5533.6 ± 1.0% | 800.4 ± 1.1% | 4.383 | 9.779 | 94.111 | 6.057 | 41.876 |
| hex: silesia/osdb | 524290 | 33109.0 ± 1.5% | 7631.8 ± 0.6% | 3446.4 ± 1.1% | 453.4 ± 5.2% | 5506.6 ± 30.9% | 797.3 ± 1.1% | 4.338 | 9.607 | 73.028 | 6.013 | 41.525 |
| hex: silesia/reymont | 524290 | 33159.0 ± 0.2% | 7625.6 ± 5.1% | 3419.6 ± 2.5% | 487.6 ± 0.5% | 5535.0 ± 0.7% | 800.1 ± 1.1% | 4.348 | 9.697 | 67.998 | 5.991 | 41.444 |
| hex: silesia/samba | 524290 | 33244.4 ± 2.5% | 7645.9 ± 0.6% | 3438.1 ± 0.9% | 361.7 ± 0.3% | 5501.9 ± 1.1% | 802.2 ± 0.8% | 4.348 | 9.669 | 91.921 | 6.042 | 41.443 |
| hex: silesia/sao | 524290 | 33366.4 ± 0.4% | 7655.6 ± 0.6% | 3432.0 ± 0.6% | 287.8 ± 4.3% | 5507.7 ± 0.8% | 802.2 ± 0.5% | 4.358 | 9.722 | 115.951 | 6.058 | 41.594 |
| hex: silesia/webster | 524290 | 33405.4 ± 0.5% | 7618.8 ± 0.9% | 3438.9 ± 0.3% | 435.5 ± 0.2% | 5521.6 ± 0.6% | 802.7 ± 0.7% | 4.385 | 9.714 | 76.706 | 6.050 | 41.619 |
| hex: silesia/x-ray | 524290 | 33254.6 ± 1.0% | 7647.6 ± 0.5% | 3423.3 ± 1.4% | 435.2 ± 0.5% | 5510.8 ± 0.8% | 798.3 ± 0.8% | 4.348 | 9.714 | 76.411 | 6.034 | 41.654 |
| hex: silesia/xml | 524290 | 33540.8 ± 0.6% | 7662.5 ± 1.3% | 3428.7 ± 0.4% | 602.5 ± 0.4% | 5496.7 ± 1.2% | 800.7 ± 1.0% | 4.377 | 9.782 | 55.674 | 6.102 | 41.891 |
| hex: canterbury/alice29.txt | 304180 | 33496.7 ± 8.5% | 7778.1 ± 0.9% | 3510.8 ± 1.1% | 469.5 ± 1.2% | 5506.2 ± 0.8% | 802.6 ± 1.1% | 4.307 | 9.541 | 71.345 | 6.083 | 41.735 |
| hex: canterbury/asyoulik.txt | 250360 | 33593.2 ± 2.6% | 7744.2 ± 0.5% | 3532.2 ± 1.6% | 461.4 ± 0.5% | 5507.1 ± 18.0% | 805.5 ± 1.9% | 4.338 | 9.511 | 72.806 | 6.100 | 41.704 |
| hex: canterbury/cp.html | 49208 | 32814.1 ± 0.3% | 7782.7 ± 0.3% | 3609.1 ± 11.0% | 462.0 ± 1.0% | 5486.7 ± 0.6% | 789.4 ± 2.1% | 4.216 | 9.092 | 71.022 | 5.981 | 41.567 |
| hex: canterbury/fields.c | 22302 | 31754.6 ± 0.2% | 7690.7 ± 0.2% | 3607.1 ± 7.0% | 487.9 ± 0.6% | 5472.3 ± 0.9% | 777.1 ± 1.2% | 4.129 | 8.803 | 65.090 | 5.803 | 40.862 |
| hex: canterbury/grammar.lsp | 7444 | 27759.3 ± 0.5% | 7486.8 ± 0.3% | 3563.5 ± 1.3% | 534.2 ± 1.0% | 5371.0 ± 3.2% | 754.8 ± 5.1% | 3.708 | 7.790 | 51.963 | 5.168 | 36.777 |
| hex: canterbury/kennedy.xls | 524290 | 33295.4 ± 0.6% | 7637.9 ± 1.0% | 3446.4 ± 2.5% | 684.6 ± 0.6% | 5486.1 ± 1.1% | 792.5 ± 7.4% | 4.359 | 9.661 | 48.638 | 6.069 | 42.012 |
| hex: canterbury/lcet10.txt | 524290 | 33473.1 ± 0.3% | 7629.2 ± 0.5% | 3442.5 ± 0.5% | 471.8 ± 1.0% | 5515.9 ± 0.4% | 799.5 ± 2.2% | 4.388 | 9.723 | 70.954 | 6.068 | 41.869 |
| hex: canterbury/plrabn12.txt | 524290 | 33446.6 ± 0.3% | 7647.3 ± 0.9% | 3419.5 ± 0.6% | 460.6 ± 1.2% | 5507.8 ± 1.0% | 805.3 ± 0.8% | 4.374 | 9.781 | 72.615 | 6.073 | 41.535 |
| hex: canterbury/ptt5 | 524290 | 33610.8 ± 0.3% | 7603.5 ± 1.3% | 3434.4 ± 0.3% | 565.5 ± 13.0% | 5490.0 ± 1.1% | 796.7 ± 2.4% | 4.420 | 9.787 | 59.433 | 6.122 | 42.185 |
| hex: canterbury/sum | 76482 | 33302.0 ± 0.8% | 7799.2 ± 0.8% | 3617.5 ± 0.3% | 526.1 ± 0.6% | 5503.8 ± 1.8% | 800.7 ± 3.3% | 4.270 | 9.206 | 63.297 | 6.051 | 41.592 |
| hex: canterbury/xargs.1 | 8456 | 28375.3 ± 7.3% | 7518.6 ± 3.4% | 3540.4 ± 1.6% | 523.3 ± 5.4% | 5369.4 ± 0.4% | 781.3 ± 17.8% | 3.774 | 8.015 | 54.228 | 5.285 | 36.320 |
| hex: canterbury-large/E.coli | 524290 | 33231.0 ± 10.6% | 7574.3 ± 0.9% | 3431.0 ± 1.6% | 710.5 ± 0.2% | 5511.5 ± 0.6% | 789.9 ± 4.8% | 4.387 | 9.686 | 46.772 | 6.029 | 42.067 |
| hex: canterbury-large/bible.txt | 524290 | 33436.9 ± 0.6% | 7637.1 ± 0.5% | 3427.3 ± 1.7% | 487.5 ± 1.0% | 5499.5 ± 1.4% | 798.0 ± 2.0% | 4.378 | 9.756 | 68.588 | 6.080 | 41.901 |
| hex: canterbury-large/world192.txt | 524290 | 33489.2 ± 0.6% | 7633.6 ± 0.4% | 3430.4 ± 1.1% | 454.3 ± 0.2% | 5483.3 ± 1.3% | 795.1 ± 0.4% | 4.387 | 9.763 | 73.709 | 6.107 | 42.117 |
| hex: http/html-1kx1024 | 2099200 | 16684.7 ± 0.6% | 6592.4 ± 0.2% | 3232.0 ± 0.7% | 485.7 ± 2.0% | 4698.2 ± 2.5% | 712.0 ± 2.6% | 2.531 | 5.162 | 34.354 | 3.551 | 23.434 |
| hex: http/html-16kx64 | 2097280 | 30219.0 ± 0.6% | 7618.3 ± 0.1% | 3489.8 ± 0.8% | 494.6 ± 6.7% | 5408.3 ± 5.2% | 778.3 ± 4.1% | 3.967 | 8.659 | 61.100 | 5.588 | 38.826 |
| hex: http/html-1m | 524290 | 33009.6 ± 0.8% | 7611.7 ± 1.3% | 3408.2 ± 0.5% | 492.4 ± 0.5% | 5505.5 ± 0.2% | 786.1 ± 3.8% | 4.337 | 9.685 | 67.044 | 5.996 | 41.994 |
| hex: http/json-1kx1024 | 2099200 | 16642.7 ± 1.2% | 6602.1 ± 5.6% | 3225.1 ± 17.4% | 613.6 ± 2.8% | 4707.9 ± 1.0% | 694.7 ± 5.1% | 2.521 | 5.160 | 27.125 | 3.535 | 23.958 |
| hex: http/json-16kx64 | 2097280 | 30408.3 ± 2.1% | 7655.5 ± 0.5% | 3459.8 ± 1.5% | 631.6 ± 0.8% | 5381.7 ± 8.3% | 780.4 ± 2.8% | 3.972 | 8.789 | 48.143 | 5.650 | 38.964 |
| hex: http/json-1m | 524290 | 33229.1 ± 0.3% | 7671.6 ± 1.0% | 3438.0 ± 1.0% | 639.8 ± 0.7% | 5514.4 ± 1.3% | 794.1 ± 3.0% | 4.331 | 9.665 | 51.940 | 6.026 | 41.843 |
| hex: http/js-1kx1024 | 2099200 | 16625.5 ± 0.3% | 6605.4 ± 1.0% | 3213.8 ± 2.5% | 466.5 ± 1.4% | 4705.8 ± 0.4% | 704.0 ± 5.1% | 2.517 | 5.173 | 35.638 | 3.533 | 23.617 |
| hex: http/js-16kx64 | 2097280 | 30343.1 ± 1.3% | 7653.8 ± 0.4% | 3487.8 ± 0.9% | 478.9 ± 1.0% | 5413.9 ± 0.5% | 787.3 ± 2.6% | 3.964 | 8.700 | 63.365 | 5.605 | 38.540 |
| hex: http/js-1m | 524290 | 33514.9 ± 0.9% | 7635.1 ± 0.4% | 3428.1 ± 0.4% | 492.9 ± 2.6% | 5523.2 ± 1.0% | 800.3 ± 3.0% | 4.390 | 9.776 | 67.989 | 6.068 | 41.878 |
| hex: http/css-1kx1024 | 2099200 | 16650.7 ± 1.5% | 6594.9 ± 0.2% | 3211.8 ± 1.1% | 534.8 ± 2.9% | 4700.1 ± 0.4% | 713.1 ± 4.2% | 2.525 | 5.184 | 31.134 | 3.543 | 23.350 |
| hex: http/css-16kx64 | 2097280 | 30563.2 ± 2.0% | 7655.9 ± 0.3% | 3492.0 ± 0.5% | 549.6 ± 7.1% | 5418.5 ± 0.3% | 777.2 ± 3.2% | 3.992 | 8.752 | 55.606 | 5.640 | 39.327 |
| hex: http/css-1m | 524290 | 33244.8 ± 0.9% | 7648.9 ± 0.5% | 3443.8 ± 0.9% | 532.4 ± 0.6% | 5476.4 ± 4.0% | 803.1 ± 1.6% | 4.346 | 9.653 | 62.441 | 6.070 | 41.397 |
| hex: shuffled/dickens-1m | 524290 | 33344.4 ± 0.8% | 7640.1 ± 0.7% | 3427.8 ± 0.7% | 469.9 ± 1.1% | 5516.8 ± 1.0% | 809.9 ± 2.0% | 4.364 | 9.728 | 70.965 | 6.044 | 41.173 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1140.4 ± 1.0% | 1131.3 ± 1.6% | 896.0 ± 0.7% | 328.9 ± 1.0% | 365.8 ± 0.3% | 312.1 ± 1.2% | 1.008 | 1.273 | 3.468 | 3.118 | 3.654 |
| qlog records, JSON text sequence | 1467503 | 971.0 ± 0.8% | 866.9 ± 0.9% | 720.3 ± 2.3% | 315.1 ± 1.0% | 374.4 ± 13.2% | 224.4 ± 2.0% | 1.120 | 1.348 | 3.081 | 2.593 | 4.327 |
| string: silesia/dickens | 172528 | 8578.6 ± 0.2% | 2946.6 ± 1.8% | 2024.6 ± 0.4% | 355.8 ± 0.4% | 1411.8 ± 1.8% | 561.0 ± 2.0% | 2.911 | 4.237 | 24.107 | 6.076 | 15.293 |
| string: silesia/nci | 1075110 | 8089.1 ± 0.3% | 3181.7 ± 2.1% | 2789.0 ± 0.8% | 773.2 ± 0.7% | 1534.8 ± 0.6% | 560.0 ± 0.4% | 2.542 | 2.900 | 10.461 | 5.270 | 14.446 |
| string: silesia/reymont | 1075159 | 3810.3 ± 0.7% | 1637.5 ± 1.1% | 1718.7 ± 30.1% | 361.0 ± 2.5% | 1248.6 ± 0.8% | 549.3 ± 0.4% | 2.327 | 2.217 | 10.555 | 3.052 | 6.936 |
| string: silesia/samba | 97582 | 4568.0 ± 0.3% | 1976.0 ± 1.4% | 2158.8 ± 0.9% | 298.4 ± 1.0% | 1007.5 ± 19.4% | 623.1 ± 29.4% | 2.312 | 2.116 | 15.307 | 4.534 | 7.331 |
| string: silesia/webster | 1098490 | 5034.9 ± 0.2% | 1624.8 ± 1.9% | 1488.0 ± 0.6% | 352.6 ± 8.0% | 1196.1 ± 1.6% | 453.0 ± 0.4% | 3.099 | 3.384 | 14.280 | 4.210 | 11.114 |
| string: silesia/xml | 1090118 | 7866.7 ± 0.9% | 2659.8 ± 0.5% | 2167.4 ± 0.6% | 540.6 ± 3.0% | 1578.5 ± 0.9% | 562.1 ± 0.5% | 2.958 | 3.630 | 14.552 | 4.984 | 13.995 |
| string: canterbury/alice29.txt | 159425 | 8748.9 ± 7.8% | 2465.8 ± 3.6% | 1786.5 ± 1.8% | 337.6 ± 2.3% | 1256.9 ± 2.3% | 556.4 ± 0.4% | 3.548 | 4.897 | 25.915 | 6.961 | 15.724 |
| string: canterbury/asyoulik.txt | 132198 | 7833.4 ± 1.5% | 2166.1 ± 6.2% | 1528.6 ± 1.0% | 341.4 ± 2.0% | 1117.8 ± 1.2% | 543.5 ± 1.0% | 3.616 | 5.125 | 22.944 | 7.008 | 14.412 |
| string: canterbury/lcet10.txt | 441884 | 8387.8 ± 0.4% | 2473.4 ± 1.8% | 1976.4 ± 0.2% | 388.4 ± 0.9% | 1374.7 ± 0.5% | 553.2 ± 0.6% | 3.391 | 4.244 | 21.596 | 6.102 | 15.163 |
| string: canterbury/plrabn12.txt | 503330 | 5975.6 ± 0.6% | 1819.1 ± 0.9% | 1664.0 ± 0.1% | 360.7 ± 0.7% | 1289.6 ± 2.1% | 554.4 ± 6.3% | 3.285 | 3.591 | 16.568 | 4.634 | 10.778 |
| string: canterbury-large/E.coli | 1048578 | 33650.4 ± 28.2% | 10477.6 ± 2.0% | 3383.8 ± 0.5% | 1407.2 ± 1.0% | 2493.7 ± 2.4% | 581.1 ± 1.0% | 3.212 | 9.945 | 23.913 | 13.494 | 57.909 |
| string: canterbury-large/bible.txt | 1055886 | 6975.6 ± 0.6% | 3917.4 ± 1.4% | 2652.6 ± 0.4% | 432.8 ± 0.2% | 1858.7 ± 0.6% | 570.5 ± 1.7% | 1.781 | 2.630 | 16.117 | 3.753 | 12.227 |
| string: canterbury-large/world192.txt | 1103121 | 4845.5 ± 6.4% | 1441.3 ± 0.7% | 1573.8 ± 2.5% | 367.8 ± 0.9% | 1167.0 ± 0.9% | 539.4 ± 0.7% | 3.362 | 3.079 | 13.176 | 4.152 | 8.983 |
| string: http/html-1m | 1058582 | 8479.2 ± 0.5% | 3859.8 ± 1.6% | 2469.3 ± 5.1% | 394.5 ± 12.3% | 1807.4 ± 0.4% | 521.7 ± 0.8% | 2.197 | 3.434 | 21.494 | 4.691 | 16.253 |
| string: http/json-1m | 1190272 | 6391.5 ± 8.9% | 1228.3 ± 0.3% | 1268.2 ± 0.4% | 373.9 ± 2.5% | 890.2 ± 0.8% | 508.1 ± 1.1% | 5.204 | 5.040 | 17.092 | 7.180 | 12.579 |
| string: http/js-1m | 1144362 | 5057.2 ± 1.2% | 984.4 ± 1.0% | 1083.7 ± 0.4% | 281.9 ± 1.1% | 935.6 ± 1.2% | 471.7 ± 0.6% | 5.137 | 4.666 | 17.939 | 5.405 | 10.721 |
| string: http/css-1m | 1097820 | 6475.5 ± 1.3% | 1294.0 ± 0.3% | 1593.6 ± 0.4% | 401.4 ± 14.0% | 1048.5 ± 0.5% | 529.0 ± 0.2% | 5.004 | 4.063 | 16.134 | 6.176 | 12.240 |
| string: dickens as Cyrillic and CJK | 1883069 | 5350.0 ± 1.8% | 3030.3 ± 14.4% | 346.3 ± 1.7% | 270.8 ± 0.5% | 450.6 ± 5.5% | 290.8 ± 25.4% | 1.766 | 15.451 | 19.758 | 11.874 | 18.396 |
| hex: silesia/dickens | 524290 | 31341.3 ± 0.4% | 1552.4 ± 1.5% | 1085.6 ± 0.3% | 419.8 ± 2.7% | 1047.2 ± 1.0% | 449.0 ± 0.4% | 20.190 | 28.871 | 74.666 | 29.928 | 69.802 |
| hex: silesia/mozilla | 524290 | 35340.5 ± 0.8% | 1550.2 ± 0.6% | 1084.3 ± 0.5% | 369.5 ± 0.8% | 1049.1 ± 1.4% | 448.4 ± 1.0% | 22.798 | 32.593 | 95.656 | 33.688 | 78.819 |
| hex: silesia/mr | 524290 | 33183.4 ± 8.6% | 1549.2 ± 7.0% | 1085.2 ± 1.9% | 511.2 ± 0.7% | 1051.5 ± 1.1% | 448.2 ± 0.6% | 21.420 | 30.579 | 64.917 | 31.558 | 74.030 |
| hex: silesia/nci | 524290 | 32770.3 ± 0.6% | 1551.1 ± 0.4% | 1087.1 ± 9.3% | 556.8 ± 0.5% | 1052.3 ± 0.6% | 448.6 ± 0.6% | 21.127 | 30.145 | 58.858 | 31.142 | 73.053 |
| hex: silesia/ooffice | 524290 | 32989.8 ± 1.3% | 1550.0 ± 0.4% | 1085.1 ± 0.4% | 327.7 ± 1.1% | 1052.1 ± 12.6% | 450.8 ± 0.8% | 21.283 | 30.402 | 100.675 | 31.356 | 73.177 |
| hex: silesia/osdb | 524290 | 36293.6 ± 0.3% | 1552.7 ± 0.9% | 1085.7 ± 0.5% | 414.4 ± 0.3% | 1052.4 ± 1.8% | 451.3 ± 0.2% | 23.375 | 33.428 | 87.573 | 34.485 | 80.426 |
| hex: silesia/reymont | 524290 | 34565.7 ± 2.3% | 1550.4 ± 1.0% | 1085.5 ± 0.3% | 437.9 ± 0.5% | 1054.4 ± 0.6% | 449.1 ± 1.6% | 22.295 | 31.843 | 78.928 | 32.783 | 76.965 |
| hex: silesia/samba | 524290 | 34087.5 ± 0.5% | 1547.7 ± 1.4% | 1083.9 ± 1.5% | 333.3 ± 0.3% | 1055.5 ± 0.2% | 451.4 ± 0.7% | 22.025 | 31.450 | 102.275 | 32.296 | 75.515 |
| hex: silesia/sao | 524290 | 34771.7 ± 0.3% | 1555.4 ± 0.5% | 1085.2 ± 0.2% | 267.0 ± 8.9% | 1057.4 ± 0.2% | 452.3 ± 0.8% | 22.356 | 32.041 | 130.214 | 32.886 | 76.874 |
| hex: silesia/webster | 524290 | 37060.2 ± 1.8% | 1548.5 ± 17.7% | 1083.1 ± 1.4% | 387.4 ± 1.2% | 1053.8 ± 0.3% | 451.6 ± 1.6% | 23.934 | 34.216 | 95.659 | 35.168 | 82.061 |
| hex: silesia/x-ray | 524290 | 33401.6 ± 0.4% | 1553.9 ± 0.9% | 1086.5 ± 0.2% | 394.5 ± 0.7% | 1051.8 ± 15.4% | 448.3 ± 7.5% | 21.495 | 30.742 | 84.661 | 31.758 | 74.512 |
| hex: silesia/xml | 524290 | 33856.6 ± 0.6% | 1551.6 ± 0.3% | 1085.8 ± 2.1% | 586.7 ± 0.2% | 1052.4 ± 0.3% | 449.9 ± 1.7% | 21.820 | 31.182 | 57.710 | 32.171 | 75.249 |
| hex: canterbury/alice29.txt | 304180 | 33372.3 ± 0.3% | 1576.6 ± 1.9% | 1087.7 ± 0.4% | 429.0 ± 0.5% | 1069.8 ± 0.9% | 453.5 ± 0.8% | 21.168 | 30.683 | 77.795 | 31.194 | 73.591 |
| hex: canterbury/asyoulik.txt | 250360 | 31542.8 ± 0.3% | 1601.8 ± 0.6% | 1091.7 ± 1.7% | 424.2 ± 1.7% | 1077.3 ± 20.3% | 454.1 ± 71.4% | 19.692 | 28.894 | 74.358 | 29.279 | 69.458 |
| hex: canterbury/cp.html | 49208 | 31923.0 ± 0.4% | 1620.5 ± 13.2% | 1112.5 ± 0.3% | 457.2 ± 0.6% | 1078.4 ± 0.3% | 459.0 ± 0.2% | 19.700 | 28.695 | 69.826 | 29.602 | 69.551 |
| hex: canterbury/fields.c | 22302 | 32804.9 ± 25.2% | 1599.4 ± 13.3% | 1103.2 ± 2.0% | 547.7 ± 0.9% | 1071.5 ± 0.5% | 460.5 ± 0.1% | 20.511 | 29.736 | 59.894 | 30.615 | 71.235 |
| hex: canterbury/grammar.lsp | 7444 | 34185.5 ± 1.2% | 1626.8 ± 0.8% | 1111.4 ± 1.5% | 584.4 ± 0.4% | 1088.9 ± 0.3% | 462.2 ± 1.7% | 21.014 | 30.759 | 58.502 | 31.395 | 73.968 |
| hex: canterbury/kennedy.xls | 524290 | 31743.0 ± 0.7% | 1541.6 ± 1.3% | 1083.1 ± 7.6% | 593.4 ± 0.4% | 1049.8 ± 0.8% | 450.0 ± 0.5% | 20.591 | 29.306 | 53.490 | 30.236 | 70.537 |
| hex: canterbury/lcet10.txt | 524290 | 34977.7 ± 11.8% | 1556.2 ± 0.6% | 1082.6 ± 1.2% | 421.5 ± 0.6% | 1052.1 ± 7.5% | 451.2 ± 0.6% | 22.476 | 32.309 | 82.993 | 33.244 | 77.523 |
| hex: canterbury/plrabn12.txt | 524290 | 33121.5 ± 1.8% | 1550.5 ± 0.6% | 1083.1 ± 12.3% | 421.4 ± 0.2% | 1054.5 ± 1.1% | 451.2 ± 0.7% | 21.362 | 30.580 | 78.592 | 31.410 | 73.412 |
| hex: canterbury/ptt5 | 524290 | 33374.2 ± 0.8% | 1554.2 ± 0.5% | 1084.0 ± 0.5% | 502.2 ± 2.7% | 1050.8 ± 10.0% | 453.1 ± 4.1% | 21.473 | 30.789 | 66.457 | 31.761 | 73.662 |
| hex: canterbury/sum | 76482 | 35078.4 ± 2.5% | 1614.8 ± 0.2% | 1106.4 ± 0.1% | 507.6 ± 0.5% | 1071.0 ± 0.6% | 460.7 ± 1.2% | 21.723 | 31.704 | 69.102 | 32.753 | 76.137 |
| hex: canterbury/xargs.1 | 8456 | 35741.8 ± 1.5% | 1631.7 ± 0.5% | 1112.0 ± 0.5% | 616.5 ± 1.0% | 1087.7 ± 1.5% | 463.8 ± 0.5% | 21.905 | 32.142 | 57.976 | 32.861 | 77.067 |
| hex: canterbury-large/E.coli | 524290 | 30557.1 ± 3.9% | 1552.7 ± 0.6% | 1084.8 ± 0.3% | 607.3 ± 0.4% | 1052.8 ± 0.7% | 449.0 ± 1.2% | 19.680 | 28.168 | 50.317 | 29.025 | 68.060 |
| hex: canterbury-large/bible.txt | 524290 | 35417.2 ± 1.1% | 1557.7 ± 18.7% | 1086.0 ± 0.2% | 434.7 ± 0.4% | 1043.6 ± 2.1% | 450.9 ± 0.8% | 22.737 | 32.613 | 81.478 | 33.938 | 78.546 |
| hex: canterbury-large/world192.txt | 524290 | 34987.0 ± 0.4% | 1552.4 ± 0.5% | 1083.2 ± 10.3% | 422.7 ± 0.3% | 1048.6 ± 1.1% | 449.4 ± 0.5% | 22.537 | 32.299 | 82.762 | 33.365 | 77.857 |
| hex: http/html-1kx1024 | 2099200 | 25008.0 ± 5.4% | 1607.6 ± 14.9% | 1088.6 ± 17.5% | 447.9 ± 0.2% | 1072.0 ± 2.5% | 455.4 ± 0.4% | 15.556 | 22.973 | 55.836 | 23.328 | 54.919 |
| hex: http/html-16kx64 | 2097280 | 29940.8 ± 1.0% | 1606.3 ± 10.7% | 1103.4 ± 5.7% | 446.8 ± 0.2% | 1036.7 ± 0.5% | 457.0 ± 0.5% | 18.639 | 27.135 | 67.019 | 28.880 | 65.520 |
| hex: http/html-1m | 524290 | 29250.1 ± 0.7% | 1543.0 ± 0.7% | 1082.5 ± 8.4% | 444.4 ± 12.4% | 1045.9 ± 16.5% | 450.6 ± 1.5% | 18.956 | 27.022 | 65.823 | 27.965 | 64.916 |
| hex: http/json-1kx1024 | 2099200 | 25111.6 ± 1.5% | 1611.3 ± 3.5% | 1091.1 ± 0.8% | 564.2 ± 0.2% | 1066.8 ± 0.7% | 454.0 ± 4.5% | 15.585 | 23.014 | 44.512 | 23.538 | 55.317 |
| hex: http/json-16kx64 | 2097280 | 30554.3 ± 0.6% | 1605.5 ± 4.7% | 1103.1 ± 0.2% | 566.7 ± 0.3% | 1053.7 ± 0.4% | 459.6 ± 0.5% | 19.030 | 27.699 | 53.916 | 28.997 | 66.487 |
| hex: http/json-1m | 524290 | 31431.0 ± 0.4% | 1545.5 ± 3.7% | 1084.8 ± 0.5% | 583.2 ± 0.6% | 1038.8 ± 0.8% | 452.0 ± 0.6% | 20.337 | 28.973 | 53.893 | 30.257 | 69.544 |
| hex: http/js-1kx1024 | 2099200 | 25307.5 ± 0.5% | 1611.5 ± 13.7% | 1090.4 ± 0.7% | 438.0 ± 1.0% | 1074.0 ± 1.9% | 455.8 ± 0.4% | 15.704 | 23.209 | 57.774 | 23.564 | 55.519 |
| hex: http/js-16kx64 | 2097280 | 30318.6 ± 0.6% | 1609.9 ± 1.7% | 1104.6 ± 12.0% | 435.1 ± 20.3% | 1041.7 ± 0.6% | 458.9 ± 0.3% | 18.833 | 27.448 | 69.686 | 29.106 | 66.066 |
| hex: http/js-1m | 524290 | 30632.1 ± 5.6% | 1560.5 ± 0.2% | 1089.4 ± 0.2% | 433.4 ± 0.3% | 1043.4 ± 0.3% | 452.1 ± 2.1% | 19.630 | 28.119 | 70.677 | 29.359 | 67.750 |
| hex: http/css-1kx1024 | 2099200 | 24953.3 ± 23.4% | 1608.1 ± 1.7% | 1087.6 ± 1.0% | 496.3 ± 0.2% | 1065.7 ± 1.4% | 454.4 ± 0.4% | 15.517 | 22.943 | 50.276 | 23.416 | 54.921 |
| hex: http/css-16kx64 | 2097280 | 30510.5 ± 0.5% | 1610.0 ± 0.7% | 1103.4 ± 0.2% | 492.5 ± 0.3% | 1021.2 ± 18.1% | 458.7 ± 4.1% | 18.951 | 27.652 | 61.954 | 29.876 | 66.516 |
| hex: http/css-1m | 524290 | 31459.7 ± 0.5% | 1559.8 ± 0.9% | 1085.9 ± 0.7% | 450.4 ± 2.6% | 1038.1 ± 1.0% | 453.1 ± 0.8% | 20.169 | 28.971 | 69.847 | 30.305 | 69.435 |
| hex: shuffled/dickens-1m | 524290 | 35122.2 ± 0.8% | 1550.2 ± 4.9% | 1084.2 ± 0.3% | 429.6 ± 5.4% | 1046.9 ± 1.2% | 452.4 ± 0.7% | 22.657 | 32.395 | 81.762 | 33.548 | 77.640 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.831 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.847 of yyjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.947 of simdjson.
- qlog records, JSON text sequence, decoding through TextReader.next: stdx runs at 0.949 of yyjson.
