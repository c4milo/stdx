# bench-json

| Field | Value |
|---|---|
| Commit | e59f48c |
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
| CLDR supplemental, 34 texts | 920675 | 1023.8 ± 0.6% | 0.472 | 0.983 | 1.048 | 1.060 | 0.416 | 1.065 | 1.053 | 0.365 | 0.816 | 0.946 | 0.097 |
| qlog records, JSON text sequence | 1467503 | 840.0 ± 1.7% | 0.739 | 1.024 | 1.028 | 1.012 | 0.397 | 1.035 | 1.016 | 0.346 | 0.913 | 0.975 | 0.111 |
| messages: 11 string members | 1025025 | 903.9 ± 1.0% | 0.582 | 0.985 | 1.012 | 1.006 | 0.508 | 1.016 | 1.006 | 0.486 | 0.872 | 1.012 | 0.111 |
| messages: 50 nested objects | 1121600 | 1021.6 ± 0.6% | 0.711 | 1.054 | 1.055 | 1.047 | 0.393 | 1.087 | 1.034 | 0.331 | 0.907 | 1.042 | 0.100 |
| messages: a tree of 341 objects | 612600 | 406.5 ± 0.5% | 0.880 | 1.106 | 1.033 | 1.040 | 0.322 | 1.032 | 1.029 | 0.259 | 0.792 | 0.989 | 0.139 |
| string: silesia/dickens | 172528 | 6197.3 ± 0.6% | 0.022 | 0.578 | 0.909 | 0.925 | 0.158 | 0.890 | 0.923 | 0.158 | 1.002 | 0.996 | 0.022 |
| string: silesia/nci | 1075110 | 5083.6 ± 0.4% | 0.027 | 0.701 | 1.035 | 1.039 | 0.234 | 1.008 | 1.037 | 0.236 | 1.004 | 1.004 | 0.027 |
| string: silesia/reymont | 1075159 | 3283.2 ± 0.5% | 0.042 | 0.579 | 0.812 | 0.824 | 0.290 | 0.821 | 0.825 | 0.289 | 1.002 | 1.003 | 0.042 |
| string: silesia/samba | 97582 | 3316.8 ± 11.8% | 0.036 | 0.896 | 1.025 | 1.027 | 0.066 | 0.838 | 1.026 | 0.066 | 1.008 | 1.007 | 0.037 |
| string: silesia/webster | 1098490 | 4092.2 ± 0.8% | 0.033 | 0.598 | 0.918 | 0.939 | 0.176 | 0.910 | 0.939 | 0.175 | 1.000 | 1.000 | 0.033 |
| string: silesia/xml | 1090118 | 5425.0 ± 2.7% | 0.026 | 0.802 | 0.933 | 0.942 | 0.205 | 0.938 | 0.945 | 0.205 | 1.010 | 0.996 | 0.026 |
| string: canterbury/alice29.txt | 159425 | 4887.1 ± 0.7% | 0.028 | 0.676 | 0.924 | 1.004 | 0.150 | 0.961 | 1.005 | 0.150 | 1.004 | 1.003 | 0.028 |
| string: canterbury/asyoulik.txt | 132198 | 3622.6 ± 5.5% | 0.037 | 0.817 | 1.099 | 1.181 | 0.171 | 1.085 | 1.181 | 0.171 | 1.032 | 0.986 | 0.037 |
| string: canterbury/lcet10.txt | 441884 | 6066.9 ± 0.5% | 0.022 | 0.542 | 0.979 | 1.000 | 0.154 | 0.958 | 1.000 | 0.156 | 0.998 | 0.991 | 0.023 |
| string: canterbury/plrabn12.txt | 503330 | 4687.0 ± 4.0% | 0.029 | 0.742 | 0.980 | 1.019 | 0.174 | 0.954 | 1.020 | 0.177 | 1.006 | 1.006 | 0.029 |
| string: canterbury-large/E.coli | 1048578 | 28709.6 ± 4.8% | 0.052 | 1.008 | 0.777 | 1.005 | 0.546 | 1.019 | 1.014 | 0.537 | 1.170 | 1.165 | 0.005 |
| string: canterbury-large/bible.txt | 1055886 | 9254.3 ± 5.4% | 0.015 | 0.490 | 0.638 | 0.644 | 0.285 | 0.704 | 0.653 | 0.284 | 1.033 | 1.038 | 0.016 |
| string: canterbury-large/world192.txt | 1103121 | 3769.9 ± 0.9% | 0.036 | 0.642 | 0.944 | 0.961 | 0.171 | 0.922 | 0.962 | 0.172 | 1.001 | 1.000 | 0.036 |
| string: http/html-1m | 1058582 | 7930.9 ± 1.5% | 0.018 | 0.539 | 0.740 | 0.746 | 0.285 | 0.769 | 0.746 | 0.287 | 0.993 | 1.000 | 0.018 |
| string: http/json-1m | 1190272 | 3316.4 ± 0.7% | 0.038 | 0.384 | 0.436 | 0.436 | 0.093 | 0.392 | 0.436 | 0.093 | 0.999 | 1.000 | 0.038 |
| string: http/js-1m | 1144362 | 2654.8 ± 0.4% | 0.048 | 0.659 | 0.866 | 0.909 | 0.149 | 0.861 | 0.897 | 0.149 | 1.005 | 1.000 | 0.048 |
| string: http/css-1m | 1097820 | 3045.4 ± 0.3% | 0.044 | 0.717 | 0.983 | 1.029 | 0.217 | 0.979 | 1.018 | 0.216 | 0.999 | 0.999 | 0.044 |
| string: dickens as Cyrillic and CJK | 1883069 | 5344.4 ± 0.5% | 0.020 | 0.055 | 0.482 | 0.483 | 0.170 | 0.481 | 0.483 | 0.169 | 0.992 | 0.992 | 0.020 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1062.2 ± 0.8% | 0.093 | 0.975 | 0.974 | 0.974 | 0.089 | 0.707 | 0.973 | 0.089 | 1.001 | 1.000 | 0.093 |
| hex: silesia/dickens | 524290 | 29138.9 ± 4.3% | 0.052 | 1.004 | 0.753 | 0.996 | 0.556 | 1.003 | 1.012 | 0.552 | 1.143 | 1.146 | 0.005 |
| hex: silesia/mozilla | 524290 | 28659.6 ± 4.8% | 0.052 | 0.996 | 0.775 | 1.022 | 0.562 | 1.008 | 0.998 | 0.561 | 1.171 | 1.169 | 0.005 |
| hex: silesia/mr | 524290 | 29898.7 ± 3.0% | 0.051 | 1.002 | 0.741 | 0.999 | 0.545 | 1.018 | 1.005 | 0.541 | 1.114 | 1.114 | 0.005 |
| hex: silesia/nci | 524290 | 28800.6 ± 6.8% | 0.052 | 1.001 | 0.769 | 1.003 | 0.553 | 0.991 | 1.006 | 0.554 | 1.157 | 1.160 | 0.005 |
| hex: silesia/ooffice | 524290 | 29016.3 ± 3.4% | 0.052 | 1.014 | 0.767 | 1.010 | 0.555 | 1.008 | 1.006 | 0.551 | 1.157 | 1.158 | 0.005 |
| hex: silesia/osdb | 524290 | 28883.4 ± 5.5% | 0.052 | 1.007 | 0.773 | 1.002 | 0.561 | 0.997 | 0.992 | 0.555 | 1.153 | 1.151 | 0.005 |
| hex: silesia/reymont | 524290 | 28855.2 ± 4.9% | 0.052 | 1.014 | 0.768 | 1.013 | 0.566 | 1.013 | 1.012 | 0.559 | 1.173 | 1.171 | 0.005 |
| hex: silesia/samba | 524290 | 29237.0 ± 0.8% | 0.052 | 1.009 | 0.743 | 1.022 | 0.561 | 1.012 | 1.018 | 0.557 | 1.138 | 1.137 | 0.005 |
| hex: silesia/sao | 524290 | 28599.7 ± 3.5% | 0.053 | 1.009 | 0.772 | 1.010 | 0.556 | 1.000 | 1.009 | 0.558 | 1.173 | 1.176 | 0.005 |
| hex: silesia/webster | 524290 | 28669.6 ± 1.8% | 0.053 | 1.012 | 0.769 | 1.007 | 0.556 | 1.007 | 1.012 | 0.554 | 1.167 | 1.161 | 0.005 |
| hex: silesia/x-ray | 524290 | 29213.3 ± 2.3% | 0.052 | 1.000 | 0.754 | 1.007 | 0.552 | 0.993 | 1.011 | 0.549 | 1.144 | 1.144 | 0.005 |
| hex: silesia/xml | 524290 | 28828.1 ± 2.9% | 0.052 | 1.006 | 0.768 | 1.002 | 0.564 | 1.008 | 1.017 | 0.556 | 1.156 | 1.157 | 0.005 |
| hex: canterbury/alice29.txt | 304180 | 35347.8 ± 2.7% | 0.043 | 1.006 | 0.626 | 1.025 | 0.498 | 1.018 | 1.011 | 0.496 | 0.959 | 0.958 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 37724.3 ± 10.9% | 0.041 | 1.007 | 0.591 | 0.999 | 0.486 | 0.999 | 1.003 | 0.489 | 0.897 | 0.898 | 0.004 |
| hex: canterbury/cp.html | 49208 | 40548.8 ± 1.0% | 0.038 | 1.004 | 0.545 | 1.001 | 0.450 | 1.001 | 0.995 | 0.455 | 0.806 | 0.809 | 0.004 |
| hex: canterbury/fields.c | 22302 | 38690.1 ± 8.4% | 0.040 | 0.996 | 0.550 | 0.998 | 0.450 | 1.000 | 1.000 | 0.460 | 0.815 | 0.820 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 37105.1 ± 1.6% | 0.041 | 0.997 | 0.520 | 1.009 | 0.431 | 1.003 | 1.006 | 0.458 | 0.741 | 0.750 | 0.004 |
| hex: canterbury/kennedy.xls | 524290 | 29345.7 ± 5.0% | 0.051 | 1.012 | 0.751 | 1.003 | 0.538 | 0.997 | 0.978 | 0.536 | 1.131 | 1.130 | 0.005 |
| hex: canterbury/lcet10.txt | 524290 | 28870.3 ± 5.3% | 0.052 | 1.014 | 0.767 | 0.995 | 0.556 | 0.998 | 1.016 | 0.547 | 1.160 | 1.163 | 0.005 |
| hex: canterbury/plrabn12.txt | 524290 | 29947.5 ± 5.3% | 0.051 | 1.005 | 0.739 | 1.014 | 0.543 | 1.011 | 1.015 | 0.539 | 1.113 | 1.114 | 0.005 |
| hex: canterbury/ptt5 | 524290 | 29504.4 ± 5.9% | 0.051 | 1.003 | 0.749 | 0.997 | 0.550 | 1.001 | 1.018 | 0.546 | 1.136 | 1.136 | 0.005 |
| hex: canterbury/sum | 76482 | 39451.1 ± 1.6% | 0.039 | 1.001 | 0.562 | 1.006 | 0.461 | 1.003 | 1.002 | 0.464 | 0.842 | 0.843 | 0.004 |
| hex: canterbury/xargs.1 | 8456 | 38437.4 ± 0.6% | 0.040 | 1.005 | 0.512 | 1.004 | 0.402 | 0.993 | 1.002 | 0.422 | 0.730 | 0.738 | 0.004 |
| hex: canterbury-large/E.coli | 524290 | 29361.3 ± 4.5% | 0.051 | 1.021 | 0.757 | 1.019 | 0.553 | 1.022 | 1.031 | 0.549 | 1.130 | 1.129 | 0.005 |
| hex: canterbury-large/bible.txt | 524290 | 28988.5 ± 4.2% | 0.052 | 1.002 | 0.759 | 1.005 | 0.552 | 1.004 | 1.005 | 0.551 | 1.159 | 1.157 | 0.005 |
| hex: canterbury-large/world192.txt | 524290 | 29202.2 ± 3.6% | 0.052 | 1.009 | 0.763 | 1.007 | 0.552 | 1.014 | 1.001 | 0.549 | 1.141 | 1.138 | 0.005 |
| hex: http/html-1kx1024 | 2099200 | 17053.5 ± 1.4% | 0.087 | 1.010 | 0.778 | 1.007 | 0.596 | 1.009 | 1.013 | 0.683 | 0.963 | 0.981 | 0.008 |
| hex: http/html-16kx64 | 2097280 | 34570.1 ± 2.4% | 0.044 | 1.002 | 0.605 | 1.006 | 0.495 | 1.010 | 1.015 | 0.500 | 0.876 | 0.882 | 0.004 |
| hex: http/html-1m | 524290 | 28890.2 ± 2.6% | 0.052 | 1.012 | 0.769 | 1.016 | 0.560 | 1.020 | 1.012 | 0.556 | 1.150 | 1.150 | 0.005 |
| hex: http/json-1kx1024 | 2099200 | 16764.4 ± 2.8% | 0.089 | 1.008 | 0.786 | 1.016 | 0.586 | 1.017 | 1.020 | 0.671 | 0.987 | 1.001 | 0.009 |
| hex: http/json-16kx64 | 2097280 | 35173.8 ± 1.4% | 0.044 | 0.998 | 0.598 | 1.005 | 0.493 | 1.003 | 1.007 | 0.500 | 0.864 | 0.865 | 0.004 |
| hex: http/json-1m | 524290 | 29157.9 ± 3.1% | 0.052 | 1.001 | 0.760 | 1.009 | 0.556 | 1.016 | 1.009 | 0.551 | 1.143 | 1.143 | 0.005 |
| hex: http/js-1kx1024 | 2099200 | 16626.5 ± 2.8% | 0.090 | 1.035 | 0.801 | 1.047 | 0.596 | 1.042 | 1.054 | 0.685 | 0.985 | 1.004 | 0.009 |
| hex: http/js-16kx64 | 2097280 | 34909.2 ± 1.9% | 0.044 | 1.005 | 0.601 | 1.009 | 0.496 | 1.008 | 1.015 | 0.502 | 0.878 | 0.873 | 0.004 |
| hex: http/js-1m | 524290 | 28789.1 ± 2.7% | 0.052 | 1.017 | 0.766 | 1.005 | 0.556 | 0.993 | 1.009 | 0.556 | 1.172 | 1.168 | 0.005 |
| hex: http/css-1kx1024 | 2099200 | 16869.8 ± 0.6% | 0.088 | 1.016 | 0.786 | 1.023 | 0.606 | 1.033 | 1.033 | 0.695 | 0.968 | 0.994 | 0.009 |
| hex: http/css-16kx64 | 2097280 | 34629.3 ± 0.9% | 0.044 | 0.999 | 0.602 | 1.002 | 0.496 | 1.004 | 1.003 | 0.504 | 0.876 | 0.874 | 0.004 |
| hex: http/css-1m | 524290 | 29183.0 ± 2.7% | 0.052 | 1.011 | 0.749 | 0.997 | 0.552 | 1.008 | 1.001 | 0.549 | 1.141 | 1.143 | 0.005 |
| hex: shuffled/dickens-1m | 524290 | 28830.6 ± 2.8% | 0.052 | 1.009 | 0.771 | 1.017 | 0.555 | 1.007 | 1.018 | 0.555 | 1.155 | 1.156 | 0.005 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1347.3 ± 2.6% | 0.440 | 0.967 | 0.967 | 0.976 | 0.983 | 0.233 | 0.979 | 0.441 | 0.838 | 0.085 | 0.998 |
| qlog records, JSON text sequence | 1467503 | 1169.2 ± 5.5% | 0.696 | 0.944 | 0.983 | 0.975 | 0.977 | 0.226 | 0.977 | 0.408 | 0.824 | 0.103 | 1.005 |
| messages: 11 string members | 1025025 | 1104.0 ± 3.3% | 0.550 | 1.009 | 0.961 | 0.969 | 0.992 | 0.320 | 0.999 | 0.585 | 1.001 | 0.104 | 1.008 |
| messages: 50 nested objects | 1121600 | 1383.5 ± 0.3% | 0.613 | 0.957 | 0.956 | 0.939 | 0.943 | 0.222 | 0.945 | 0.402 | 0.806 | 0.091 | 0.986 |
| messages: a tree of 341 objects | 612600 | 457.7 ± 2.8% | 0.933 | 1.004 | 1.039 | 1.050 | 1.046 | 0.199 | 1.040 | 0.365 | 0.720 | 0.163 | 1.070 |
| string: silesia/dickens | 172528 | 8533.1 ± 0.7% | 0.018 | 0.625 | 0.442 | 0.639 | 0.627 | 0.127 | 0.627 | 1.004 | 1.006 | 0.018 | 1.053 |
| string: silesia/nci | 1075110 | 8119.4 ± 0.7% | 0.019 | 0.634 | 0.425 | 0.632 | 0.634 | 0.178 | 0.634 | 1.000 | 0.999 | 0.019 | 1.025 |
| string: silesia/reymont | 1075159 | 3815.3 ± 0.4% | 0.041 | 0.678 | 0.508 | 0.672 | 0.681 | 0.280 | 0.680 | 1.001 | 1.001 | 0.041 | 1.003 |
| string: silesia/samba | 97582 | 4538.1 ± 0.5% | 0.042 | 0.953 | 0.806 | 0.956 | 0.953 | 0.114 | 0.955 | 1.002 | 1.006 | 0.042 | 1.119 |
| string: silesia/webster | 1098490 | 5045.1 ± 5.6% | 0.030 | 0.705 | 0.500 | 0.710 | 0.707 | 0.157 | 0.707 | 1.020 | 1.001 | 0.030 | 1.004 |
| string: silesia/xml | 1090118 | 7740.0 ± 10.1% | 0.020 | 0.646 | 0.575 | 0.656 | 0.645 | 0.203 | 0.644 | 1.006 | 1.001 | 0.020 | 1.056 |
| string: canterbury/alice29.txt | 159425 | 9156.6 ± 0.4% | 0.017 | 0.552 | 0.406 | 0.553 | 0.554 | 0.089 | 0.557 | 1.001 | 1.005 | 0.017 | 1.025 |
| string: canterbury/asyoulik.txt | 132198 | 7418.9 ± 1.0% | 0.020 | 0.548 | 0.418 | 0.540 | 0.545 | 0.093 | 0.553 | 1.001 | 1.006 | 0.020 | 1.039 |
| string: canterbury/lcet10.txt | 441884 | 8319.7 ± 1.9% | 0.019 | 0.643 | 0.415 | 0.655 | 0.644 | 0.126 | 0.643 | 1.006 | 1.013 | 0.019 | 1.045 |
| string: canterbury/plrabn12.txt | 503330 | 5915.4 ± 7.6% | 0.026 | 0.786 | 0.593 | 0.778 | 0.786 | 0.160 | 0.786 | 0.999 | 1.001 | 0.026 | 1.037 |
| string: canterbury-large/E.coli | 1048578 | 29155.1 ± 2.8% | 0.052 | 0.998 | 1.003 | 0.761 | 1.005 | 0.536 | 0.996 | 0.987 | 1.003 | 0.005 | 1.001 |
| string: canterbury-large/bible.txt | 1055886 | 6954.2 ± 0.7% | 0.023 | 0.802 | 0.660 | 0.831 | 0.804 | 0.417 | 0.803 | 1.003 | 1.003 | 0.023 | 1.042 |
| string: canterbury-large/world192.txt | 1103121 | 4945.8 ± 6.2% | 0.031 | 0.673 | 0.513 | 0.666 | 0.674 | 0.144 | 0.665 | 1.033 | 1.040 | 0.031 | 0.960 |
| string: http/html-1m | 1058582 | 8383.2 ± 0.8% | 0.019 | 0.631 | 0.524 | 0.653 | 0.632 | 0.296 | 0.631 | 1.002 | 1.011 | 0.019 | 1.015 |
| string: http/json-1m | 1190272 | 6307.8 ± 1.2% | 0.023 | 0.227 | 0.198 | 0.230 | 0.227 | 0.065 | 0.227 | 0.997 | 1.001 | 0.023 | 1.017 |
| string: http/js-1m | 1144362 | 5018.3 ± 1.1% | 0.029 | 0.449 | 0.357 | 0.434 | 0.450 | 0.086 | 0.449 | 0.998 | 1.011 | 0.029 | 0.997 |
| string: http/css-1m | 1097820 | 6492.1 ± 2.2% | 0.023 | 0.533 | 0.364 | 0.537 | 0.532 | 0.121 | 0.534 | 1.005 | 1.008 | 0.023 | 1.054 |
| string: dickens as Cyrillic and CJK | 1883069 | 5329.8 ± 0.4% | 0.024 | 0.467 | 0.057 | 0.470 | 0.468 | 0.177 | 0.468 | 0.999 | 1.001 | 0.024 | 0.981 |
| hex: silesia/dickens | 524290 | 30463.8 ± 0.6% | 1.010 | 0.083 | 1.002 | 0.625 | 1.001 | 1.003 | 1.004 | 1.002 | 1.005 | 0.083 | 1.004 |
| hex: silesia/mozilla | 524290 | 34361.1 ± 0.8% | 1.010 | 0.074 | 1.009 | 0.585 | 1.008 | 1.009 | 1.009 | 1.009 | 1.014 | 0.074 | 1.010 |
| hex: silesia/mr | 524290 | 34473.2 ± 0.2% | 1.008 | 0.074 | 1.007 | 0.579 | 1.010 | 1.003 | 1.006 | 1.006 | 1.007 | 0.074 | 1.008 |
| hex: silesia/nci | 524290 | 34757.5 ± 1.6% | 1.009 | 0.073 | 1.007 | 0.577 | 1.009 | 1.005 | 1.009 | 1.006 | 1.011 | 0.073 | 1.011 |
| hex: silesia/ooffice | 524290 | 33791.7 ± 1.0% | 1.007 | 0.075 | 1.007 | 0.592 | 1.010 | 1.006 | 1.008 | 1.009 | 1.010 | 0.075 | 1.010 |
| hex: silesia/osdb | 524290 | 32317.0 ± 2.1% | 1.000 | 0.078 | 1.007 | 0.621 | 1.006 | 1.000 | 1.002 | 1.000 | 1.001 | 0.079 | 0.998 |
| hex: silesia/reymont | 524290 | 33194.1 ± 1.5% | 1.013 | 0.076 | 1.011 | 0.607 | 1.008 | 1.001 | 1.004 | 1.005 | 1.004 | 0.077 | 1.008 |
| hex: silesia/samba | 524290 | 35246.1 ± 2.7% | 1.009 | 0.072 | 1.005 | 0.571 | 1.005 | 1.004 | 1.004 | 1.000 | 1.008 | 0.072 | 1.007 |
| hex: silesia/sao | 524290 | 34153.1 ± 15.8% | 1.000 | 0.074 | 1.002 | 0.583 | 1.000 | 0.996 | 1.000 | 1.001 | 1.007 | 0.074 | 1.005 |
| hex: silesia/webster | 524290 | 35596.7 ± 1.0% | 1.012 | 0.071 | 1.012 | 0.570 | 1.013 | 1.003 | 1.010 | 1.002 | 1.007 | 0.072 | 1.006 |
| hex: silesia/x-ray | 524290 | 33678.5 ± 2.1% | 1.018 | 0.075 | 1.021 | 0.596 | 1.016 | 1.008 | 1.015 | 1.009 | 1.015 | 0.072 | 1.015 |
| hex: silesia/xml | 524290 | 34349.6 ± 0.7% | 1.017 | 0.074 | 1.010 | 0.586 | 1.006 | 1.007 | 1.010 | 1.006 | 1.006 | 0.074 | 1.009 |
| hex: canterbury/alice29.txt | 304180 | 33161.9 ± 2.0% | 1.011 | 0.077 | 1.002 | 0.580 | 1.006 | 1.010 | 1.008 | 1.005 | 1.008 | 0.077 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 31892.2 ± 2.6% | 1.001 | 0.079 | 1.000 | 0.619 | 0.995 | 0.998 | 0.995 | 0.994 | 0.993 | 0.080 | 0.996 |
| hex: canterbury/cp.html | 49208 | 31647.6 ± 1.1% | 1.003 | 0.080 | 1.002 | 0.612 | 1.002 | 0.996 | 1.002 | 1.005 | 1.010 | 0.080 | 1.003 |
| hex: canterbury/fields.c | 22302 | 32281.3 ± 1.4% | 0.996 | 0.078 | 0.994 | 0.584 | 0.994 | 0.983 | 0.993 | 0.999 | 1.008 | 0.078 | 1.000 |
| hex: canterbury/grammar.lsp | 7444 | 32560.0 ± 0.2% | 1.000 | 0.077 | 1.000 | 0.567 | 0.997 | 0.946 | 0.998 | 0.999 | 1.034 | 0.077 | 1.011 |
| hex: canterbury/kennedy.xls | 524290 | 30790.0 ± 12.0% | 1.005 | 0.082 | 1.007 | 0.630 | 0.999 | 1.001 | 1.001 | 0.998 | 1.002 | 0.083 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 35014.2 ± 7.1% | 1.013 | 0.072 | 1.013 | 0.573 | 1.007 | 1.007 | 1.007 | 1.003 | 1.008 | 0.073 | 1.010 |
| hex: canterbury/plrabn12.txt | 524290 | 34203.5 ± 1.3% | 1.006 | 0.074 | 1.004 | 0.586 | 1.004 | 1.000 | 1.004 | 1.000 | 1.004 | 0.074 | 1.008 |
| hex: canterbury/ptt5 | 524290 | 34081.4 ± 0.9% | 1.013 | 0.074 | 1.006 | 0.587 | 1.005 | 1.004 | 1.009 | 1.005 | 1.010 | 0.075 | 1.010 |
| hex: canterbury/sum | 76482 | 35309.0 ± 0.8% | 0.997 | 0.072 | 0.998 | 0.572 | 1.002 | 0.996 | 1.001 | 0.998 | 1.009 | 0.072 | 1.009 |
| hex: canterbury/xargs.1 | 8456 | 34736.1 ± 8.8% | 0.991 | 0.073 | 0.995 | 0.544 | 0.993 | 0.952 | 0.993 | 0.991 | 1.028 | 0.072 | 1.008 |
| hex: canterbury-large/E.coli | 524290 | 30097.8 ± 1.3% | 1.007 | 0.084 | 1.007 | 0.621 | 1.002 | 0.999 | 1.002 | 1.007 | 1.003 | 0.084 | 1.002 |
| hex: canterbury-large/bible.txt | 524290 | 34836.8 ± 0.9% | 1.004 | 0.073 | 1.005 | 0.576 | 1.006 | 0.998 | 1.001 | 1.004 | 1.005 | 0.073 | 1.004 |
| hex: canterbury-large/world192.txt | 524290 | 32728.1 ± 2.1% | 1.015 | 0.077 | 1.016 | 0.606 | 1.014 | 1.009 | 1.012 | 1.011 | 1.012 | 0.078 | 1.012 |
| hex: http/html-1kx1024 | 2099200 | 23983.7 ± 1.3% | 0.989 | 0.102 | 0.971 | 0.667 | 0.985 | 0.873 | 0.985 | 0.984 | 1.043 | 0.099 | 1.017 |
| hex: http/html-16kx64 | 2097280 | 29930.9 ± 13.8% | 1.010 | 0.084 | 1.009 | 0.647 | 1.010 | 0.995 | 1.010 | 1.008 | 1.014 | 0.085 | 1.010 |
| hex: http/html-1m | 524290 | 31425.3 ± 0.6% | 1.004 | 0.081 | 1.000 | 0.631 | 1.005 | 0.999 | 1.003 | 1.006 | 1.004 | 0.081 | 1.003 |
| hex: http/json-1kx1024 | 2099200 | 23751.6 ± 0.9% | 0.994 | 0.103 | 0.961 | 0.669 | 0.985 | 0.886 | 0.984 | 0.983 | 1.043 | 0.100 | 1.015 |
| hex: http/json-16kx64 | 2097280 | 30142.3 ± 0.3% | 1.005 | 0.084 | 0.990 | 0.635 | 1.002 | 0.993 | 1.003 | 1.004 | 1.014 | 0.084 | 1.007 |
| hex: http/json-1m | 524290 | 30604.3 ± 2.8% | 1.011 | 0.082 | 1.011 | 0.647 | 1.006 | 1.003 | 1.006 | 1.003 | 1.004 | 0.083 | 1.006 |
| hex: http/js-1kx1024 | 2099200 | 23905.2 ± 6.5% | 0.995 | 0.102 | 0.968 | 0.671 | 0.984 | 0.877 | 0.986 | 0.982 | 1.044 | 0.100 | 1.007 |
| hex: http/js-16kx64 | 2097280 | 29937.7 ± 1.8% | 1.006 | 0.084 | 0.996 | 0.641 | 1.003 | 0.991 | 1.006 | 1.008 | 1.011 | 0.084 | 1.008 |
| hex: http/js-1m | 524290 | 30974.7 ± 0.9% | 1.010 | 0.082 | 1.007 | 0.642 | 1.004 | 1.002 | 1.007 | 1.003 | 1.006 | 0.082 | 1.005 |
| hex: http/css-1kx1024 | 2099200 | 23708.2 ± 1.5% | 0.988 | 0.103 | 0.983 | 0.680 | 0.984 | 0.884 | 0.985 | 0.985 | 1.044 | 0.100 | 1.015 |
| hex: http/css-16kx64 | 2097280 | 29700.0 ± 2.1% | 1.009 | 0.085 | 1.003 | 0.647 | 1.003 | 0.992 | 1.005 | 1.006 | 1.016 | 0.085 | 1.011 |
| hex: http/css-1m | 524290 | 30846.1 ± 0.8% | 1.006 | 0.082 | 1.007 | 0.642 | 1.002 | 1.001 | 1.004 | 1.001 | 1.001 | 0.082 | 1.000 |
| hex: shuffled/dickens-1m | 524290 | 32393.3 ± 10.7% | 1.016 | 0.078 | 1.018 | 0.624 | 1.017 | 1.009 | 1.018 | 1.014 | 1.009 | 0.079 | 1.016 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J8 decoder fast path off runs at 1.060 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.065 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.053 of all on.
- messages: 50 nested objects, decoding: J5 UTF-8 vectors off runs at 1.054 of all on.
- messages: 50 nested objects, decoding: J7 wide vectors off runs at 1.055 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.087 of all on.
- messages: a tree of 341 objects, decoding: J5 UTF-8 vectors off runs at 1.106 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.099 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.181 of all on.
- string: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.085 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.181 of all on.
- hex: http/js-1kx1024, decoding: J13 decoder escape blocks off runs at 1.054 of all on.
- messages: a tree of 341 objects, encoding: J7 wide vectors off runs at 1.050 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 100615.4 ± 0.8% | 91406.6 ± 0.5% | 1.101 | — | — |
| string: silesia/nci | 1048576 | 58621.2 ± 1.8% | 59695.2 ± 2.6% | 0.982 | — | — |
| string: silesia/reymont | 1048576 | 59014.5 ± 3.4% | 58939.4 ± 0.8% | 1.001 | — | — |
| string: silesia/samba | 65546 | 98177.8 ± 0.5% | 90281.8 ± 1.0% | 1.087 | — | — |
| string: silesia/webster | 1048576 | 59019.5 ± 9.0% | 59425.3 ± 0.6% | 0.993 | — | — |
| string: silesia/xml | 1048576 | 59949.2 ± 1.6% | 59661.0 ± 4.3% | 1.005 | — | — |
| string: canterbury/alice29.txt | 152089 | 100441.9 ± 1.4% | 90999.2 ± 0.5% | 1.104 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 99763.6 ± 1.4% | 91904.0 ± 0.3% | 1.086 | — | — |
| string: canterbury/lcet10.txt | 426754 | 85638.1 ± 1.6% | 80539.9 ± 0.7% | 1.063 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 79957.8 ± 1.8% | 78421.5 ± 1.0% | 1.020 | — | — |
| string: canterbury-large/E.coli | 1048576 | 58073.9 ± 2.2% | 58240.1 ± 3.7% | 0.997 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 59558.1 ± 2.1% | 60029.9 ± 1.7% | 0.992 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 59275.5 ± 5.0% | 59141.0 ± 6.1% | 1.002 | — | — |
| string: http/html-1m | 1048576 | 57653.0 ± 3.3% | 57598.5 ± 2.5% | 1.001 | — | — |
| string: http/json-1m | 1048576 | 52831.0 ± 1.1% | 56590.8 ± 12.0% | 0.934 | — | — |
| string: http/js-1m | 1048576 | 58899.8 ± 5.3% | 58845.9 ± 1.8% | 1.001 | — | — |
| string: http/css-1m | 1048576 | 57626.9 ± 3.6% | 58135.4 ± 2.8% | 0.991 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 14616.4 ± 0.3% | 15291.7 ± 3.2% | 0.956 | — | — |

## Losses to simdutf

None.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 57950.4 ± 4.6% | 57904.6 ± 2.4% | 1.001 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 57732.7 ± 2.7% | 58249.8 ± 1.7% | 0.991 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 57614.5 ± 3.6% | 57954.9 ± 2.4% | 0.994 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 56324.7 ± 4.2% | 56503.4 ± 5.3% | 0.997 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 57692.5 ± 2.9% | 58350.2 ± 1.1% | 0.989 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 58162.5 ± 0.9% | 57839.0 ± 2.3% | 1.006 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 14568.8 ± 0.4% | 15243.1 ± 0.5% | 0.956 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 14583.1 ± 0.4% | 15258.9 ± 5.5% | 0.956 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 14571.4 ± 1.3% | 15308.9 ± 0.5% | 0.952 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 14591.8 ± 0.5% | 15282.4 ± 1.0% | 0.955 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 14608.4 ± 0.3% | 15254.5 ± 0.8% | 0.958 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 14559.0 ± 0.5% | 15252.3 ± 0.1% | 0.955 | — | — |

## Messages against serde_json's typed code

stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.

| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |
|---|---|---|---|---|
| messages: 11 string members | 1025025 | 1083.6 ± 3.8% | 550.0 ± 1.1% | 1.970 |
| messages: 50 nested objects | 1121600 | 1093.9 ± 1.9% | 631.7 ± 0.6% | 1.732 |
| messages: a tree of 341 objects | 612600 | 329.4 ± 0.6% | 360.6 ± 1.5% | 0.913 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1023.8 ± 0.6% | 1018.4 ± 0.5% | 985.6 ± 2.6% | 262.1 ± 1.2% | 515.6 ± 16.4% | 261.1 ± 3.6% | 1.005 | 1.039 | 3.906 | 1.986 | 3.922 |
| qlog records, JSON text sequence | 1467503 | 840.0 ± 1.7% | 482.7 ± 0.3% | 775.5 ± 1.8% | 229.6 ± 0.6% | 581.8 ± 0.6% | 247.1 ± 1.4% | 1.740 | 1.083 | 3.658 | 1.444 | 3.399 |
| messages: 11 string members | 1025025 | 903.9 ± 1.0% | 1139.4 ± 0.7% | 684.2 ± 0.4% | 261.4 ± 1.7% | 449.2 ± 1.0% | 247.5 ± 0.5% | 0.793 | 1.321 | 3.458 | 2.012 | 3.652 |
| messages: 50 nested objects | 1121600 | 1021.6 ± 0.6% | 1013.8 ± 1.2% | 1116.4 ± 0.7% | 282.5 ± 0.7% | 691.3 ± 0.6% | 330.3 ± 0.8% | 1.008 | 0.915 | 3.616 | 1.478 | 3.093 |
| messages: a tree of 341 objects | 612600 | 406.5 ± 0.5% | 446.8 ± 1.5% | 504.2 ± 1.6% | 123.8 ± 2.3% | 453.2 ± 0.5% | 145.7 ± 3.7% | 0.910 | 0.806 | 3.283 | 0.897 | 2.790 |
| string: silesia/dickens | 172528 | 6197.3 ± 0.6% | 2882.9 ± 0.2% | 2064.3 ± 17.5% | 292.7 ± 1.0% | 2181.6 ± 0.4% | 496.4 ± 2.5% | 2.150 | 3.002 | 21.173 | 2.841 | 12.485 |
| string: silesia/nci | 1075110 | 5083.6 ± 0.4% | 3461.8 ± 0.5% | 2836.5 ± 0.4% | 465.8 ± 3.8% | 2401.0 ± 0.3% | 527.1 ± 2.3% | 1.468 | 1.792 | 10.914 | 2.117 | 9.645 |
| string: silesia/reymont | 1075159 | 3283.2 ± 0.5% | 2187.9 ± 0.2% | 1744.3 ± 4.3% | 303.4 ± 0.9% | 1635.3 ± 0.9% | 476.7 ± 0.4% | 1.501 | 1.882 | 10.820 | 2.008 | 6.888 |
| string: silesia/samba | 97582 | 3316.8 ± 11.8% | 2877.8 ± 0.4% | 1715.7 ± 9.4% | 251.8 ± 9.8% | 1258.6 ± 0.2% | 353.9 ± 0.9% | 1.153 | 1.933 | 13.170 | 2.635 | 9.372 |
| string: silesia/webster | 1098490 | 4092.2 ± 0.8% | 2024.1 ± 0.3% | 1614.8 ± 3.0% | 291.5 ± 0.9% | 1673.6 ± 0.5% | 442.1 ± 0.9% | 2.022 | 2.534 | 14.036 | 2.445 | 9.257 |
| string: silesia/xml | 1090118 | 5425.0 ± 2.7% | 3653.4 ± 1.8% | 2121.8 ± 1.6% | 383.5 ± 1.0% | 2349.2 ± 0.3% | 504.6 ± 2.8% | 1.485 | 2.557 | 14.148 | 2.309 | 10.752 |
| string: canterbury/alice29.txt | 159425 | 4887.1 ± 0.7% | 2367.2 ± 6.5% | 1834.2 ± 1.6% | 275.0 ± 1.4% | 1937.9 ± 3.0% | 451.4 ± 2.1% | 2.064 | 2.664 | 17.769 | 2.522 | 10.826 |
| string: canterbury/asyoulik.txt | 132198 | 3622.6 ± 5.5% | 2105.2 ± 0.9% | 1477.3 ± 2.1% | 265.2 ± 0.6% | 1591.3 ± 1.3% | 403.5 ± 1.8% | 1.721 | 2.452 | 13.662 | 2.277 | 8.978 |
| string: canterbury/lcet10.txt | 441884 | 6066.9 ± 0.5% | 2784.5 ± 0.7% | 1979.1 ± 1.0% | 313.7 ± 0.5% | 2130.1 ± 6.2% | 484.7 ± 12.4% | 2.179 | 3.065 | 19.337 | 2.848 | 12.518 |
| string: canterbury/plrabn12.txt | 503330 | 4687.0 ± 4.0% | 2694.6 ± 0.2% | 1676.3 ± 0.5% | 286.8 ± 0.9% | 2007.6 ± 0.2% | 460.5 ± 1.6% | 1.739 | 2.796 | 16.341 | 2.335 | 10.178 |
| string: canterbury-large/E.coli | 1048578 | 28709.6 ± 4.8% | 7645.5 ± 3.5% | 3434.8 ± 0.6% | 873.0 ± 0.3% | 5501.7 ± 13.9% | 799.5 ± 1.6% | 3.755 | 8.359 | 32.888 | 5.218 | 35.910 |
| string: canterbury-large/bible.txt | 1055886 | 9254.3 ± 5.4% | 3906.0 ± 0.4% | 2557.3 ± 7.6% | 335.9 ± 0.1% | 2974.1 ± 1.4% | 602.2 ± 2.6% | 2.369 | 3.619 | 27.551 | 3.112 | 15.368 |
| string: canterbury-large/world192.txt | 1103121 | 3769.9 ± 0.9% | 1983.6 ± 0.8% | 1626.9 ± 1.7% | 287.4 ± 1.7% | 1676.7 ± 1.3% | 434.0 ± 0.8% | 1.901 | 2.317 | 13.118 | 2.248 | 8.687 |
| string: http/html-1m | 1058582 | 7930.9 ± 1.5% | 3400.9 ± 0.4% | 2410.9 ± 1.9% | 379.7 ± 7.8% | 2735.6 ± 1.5% | 429.1 ± 1.4% | 2.332 | 3.290 | 20.889 | 2.899 | 18.483 |
| string: http/json-1m | 1190272 | 3316.4 ± 0.7% | 1198.2 ± 1.5% | 1435.2 ± 5.8% | 336.0 ± 4.2% | 834.7 ± 11.1% | 296.9 ± 1.8% | 2.768 | 2.311 | 9.871 | 3.973 | 11.169 |
| string: http/js-1m | 1144362 | 2654.8 ± 0.4% | 1324.2 ± 0.8% | 1150.2 ± 2.8% | 265.9 ± 1.8% | 1162.2 ± 7.8% | 296.9 ± 0.7% | 2.005 | 2.308 | 9.984 | 2.284 | 8.942 |
| string: http/css-1m | 1097820 | 3045.4 ± 0.3% | 2499.8 ± 0.7% | 1544.9 ± 0.3% | 350.3 ± 0.9% | 1511.7 ± 1.7% | 338.0 ± 5.5% | 1.218 | 1.971 | 8.695 | 2.015 | 9.010 |
| string: dickens as Cyrillic and CJK | 1883069 | 5344.4 ± 0.5% | 3166.3 ± 6.7% | 652.7 ± 0.6% | 265.3 ± 11.7% | 496.5 ± 0.7% | 138.4 ± 2.5% | 1.688 | 8.189 | 20.141 | 10.763 | 38.629 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1062.2 ± 0.8% | 1077.3 ± 0.1% | 827.4 ± 1.1% | 157.1 ± 1.1% | 383.2 ± 0.8% | 201.0 ± 2.3% | 0.986 | 1.284 | 6.762 | 2.772 | 5.286 |
| hex: silesia/dickens | 524290 | 29138.9 ± 4.3% | 7616.6 ± 1.0% | 3447.2 ± 0.6% | 443.8 ± 10.3% | 5508.2 ± 0.4% | 817.2 ± 3.2% | 3.826 | 8.453 | 65.659 | 5.290 | 35.658 |
| hex: silesia/mozilla | 524290 | 28659.6 ± 4.8% | 7688.5 ± 1.8% | 3470.7 ± 0.8% | 392.6 ± 0.2% | 5527.2 ± 9.8% | 820.3 ± 2.8% | 3.728 | 8.258 | 72.992 | 5.185 | 34.939 |
| hex: silesia/mr | 524290 | 29898.7 ± 3.0% | 7637.0 ± 1.1% | 3444.8 ± 0.9% | 563.8 ± 0.1% | 5499.7 ± 0.5% | 820.1 ± 2.1% | 3.915 | 8.679 | 53.030 | 5.436 | 36.456 |
| hex: silesia/nci | 524290 | 28800.6 ± 6.8% | 7674.1 ± 1.0% | 3474.7 ± 0.8% | 633.0 ± 0.4% | 5503.9 ± 16.7% | 819.7 ± 1.9% | 3.753 | 8.289 | 45.498 | 5.233 | 35.136 |
| hex: silesia/ooffice | 524290 | 29016.3 ± 3.4% | 7646.1 ± 0.4% | 3453.0 ± 1.1% | 336.7 ± 0.2% | 5535.0 ± 1.1% | 823.5 ± 0.6% | 3.795 | 8.403 | 86.179 | 5.242 | 35.235 |
| hex: silesia/osdb | 524290 | 28883.4 ± 5.5% | 7647.7 ± 0.8% | 3436.7 ± 0.4% | 432.0 ± 3.3% | 5482.1 ± 8.7% | 817.6 ± 1.1% | 3.777 | 8.404 | 66.856 | 5.269 | 35.327 |
| hex: silesia/reymont | 524290 | 28855.2 ± 4.9% | 7680.2 ± 1.4% | 3457.3 ± 1.4% | 465.5 ± 11.7% | 5526.1 ± 0.2% | 826.9 ± 1.0% | 3.757 | 8.346 | 61.993 | 5.222 | 34.897 |
| hex: silesia/samba | 524290 | 29237.0 ± 0.8% | 7666.4 ± 0.8% | 3456.7 ± 0.6% | 342.6 ± 0.4% | 5505.8 ± 0.5% | 817.7 ± 3.5% | 3.814 | 8.458 | 85.348 | 5.310 | 35.756 |
| hex: silesia/sao | 524290 | 28599.7 ± 3.5% | 7651.1 ± 1.0% | 3442.4 ± 0.4% | 272.9 ± 0.9% | 5525.4 ± 0.8% | 824.6 ± 1.0% | 3.738 | 8.308 | 104.803 | 5.176 | 34.684 |
| hex: silesia/webster | 524290 | 28669.6 ± 1.8% | 7661.0 ± 1.2% | 3460.0 ± 0.7% | 405.5 ± 2.9% | 5522.4 ± 0.3% | 821.2 ± 1.6% | 3.742 | 8.286 | 70.696 | 5.191 | 34.910 |
| hex: silesia/x-ray | 524290 | 29213.3 ± 2.3% | 7639.8 ± 1.0% | 3462.7 ± 1.8% | 407.5 ± 8.9% | 5522.8 ± 0.4% | 819.9 ± 0.5% | 3.824 | 8.437 | 71.685 | 5.290 | 35.632 |
| hex: silesia/xml | 524290 | 28828.1 ± 2.9% | 7690.8 ± 1.0% | 3441.9 ± 2.5% | 567.1 ± 3.3% | 5506.1 ± 0.2% | 822.6 ± 2.8% | 3.748 | 8.376 | 50.834 | 5.236 | 35.045 |
| hex: canterbury/alice29.txt | 304180 | 35347.8 ± 2.7% | 7700.8 ± 0.6% | 3561.5 ± 0.9% | 444.5 ± 2.6% | 5529.6 ± 4.2% | 826.8 ± 2.3% | 4.590 | 9.925 | 79.521 | 6.392 | 42.754 |
| hex: canterbury/asyoulik.txt | 250360 | 37724.3 ± 10.9% | 7792.6 ± 0.5% | 3565.5 ± 0.8% | 435.3 ± 0.3% | 5527.6 ± 0.9% | 834.1 ± 1.5% | 4.841 | 10.580 | 86.661 | 6.825 | 45.225 |
| hex: canterbury/cp.html | 49208 | 40548.8 ± 1.0% | 7780.7 ± 0.2% | 3612.4 ± 0.5% | 430.6 ± 1.2% | 5459.0 ± 5.5% | 810.8 ± 9.4% | 5.211 | 11.225 | 94.179 | 7.428 | 50.012 |
| hex: canterbury/fields.c | 22302 | 38690.1 ± 8.4% | 7679.8 ± 0.2% | 3605.3 ± 6.8% | 459.4 ± 0.8% | 5469.5 ± 0.5% | 789.1 ± 1.2% | 5.038 | 10.732 | 84.213 | 7.074 | 49.029 |
| hex: canterbury/grammar.lsp | 7444 | 37105.1 ± 1.6% | 7465.9 ± 0.1% | 3575.2 ± 0.1% | 517.6 ± 0.7% | 5358.8 ± 11.9% | 772.6 ± 3.7% | 4.970 | 10.378 | 71.682 | 6.924 | 48.027 |
| hex: canterbury/kennedy.xls | 524290 | 29345.7 ± 5.0% | 7684.9 ± 0.6% | 3464.3 ± 1.2% | 667.6 ± 0.3% | 5502.8 ± 0.3% | 801.5 ± 9.4% | 3.819 | 8.471 | 43.958 | 5.333 | 36.616 |
| hex: canterbury/lcet10.txt | 524290 | 28870.3 ± 5.3% | 7676.3 ± 1.0% | 3456.8 ± 1.2% | 447.4 ± 0.4% | 5502.7 ± 1.1% | 825.1 ± 1.7% | 3.761 | 8.352 | 64.526 | 5.247 | 34.992 |
| hex: canterbury/plrabn12.txt | 524290 | 29947.5 ± 5.3% | 7707.8 ± 0.4% | 3443.2 ± 0.2% | 434.5 ± 0.9% | 5517.4 ± 0.3% | 818.8 ± 2.9% | 3.885 | 8.698 | 68.922 | 5.428 | 36.577 |
| hex: canterbury/ptt5 | 524290 | 29504.4 ± 5.9% | 7684.4 ± 0.5% | 3468.1 ± 0.6% | 559.5 ± 1.9% | 5518.5 ± 0.2% | 820.8 ± 0.9% | 3.840 | 8.507 | 52.734 | 5.346 | 35.945 |
| hex: canterbury/sum | 76482 | 39451.1 ± 1.6% | 7791.0 ± 0.2% | 3621.0 ± 1.9% | 498.8 ± 0.5% | 5501.7 ± 0.6% | 829.8 ± 0.7% | 5.064 | 10.895 | 79.087 | 7.171 | 47.544 |
| hex: canterbury/xargs.1 | 8456 | 38437.4 ± 0.6% | 7487.5 ± 1.1% | 3557.4 ± 1.3% | 488.1 ± 0.5% | 5356.9 ± 0.7% | 812.2 ± 2.6% | 5.134 | 10.805 | 78.750 | 7.175 | 47.324 |
| hex: canterbury-large/E.coli | 524290 | 29361.3 ± 4.5% | 7690.8 ± 3.0% | 3458.9 ± 0.6% | 710.5 ± 0.2% | 5509.1 ± 0.3% | 816.4 ± 3.1% | 3.818 | 8.489 | 41.328 | 5.330 | 35.966 |
| hex: canterbury-large/bible.txt | 524290 | 28988.5 ± 4.2% | 7659.0 ± 0.6% | 3458.1 ± 0.8% | 464.0 ± 0.4% | 5530.9 ± 3.9% | 824.0 ± 5.8% | 3.785 | 8.383 | 62.481 | 5.241 | 35.182 |
| hex: canterbury-large/world192.txt | 524290 | 29202.2 ± 3.6% | 7697.9 ± 0.5% | 3462.3 ± 0.7% | 429.7 ± 8.9% | 5503.7 ± 0.4% | 819.0 ± 1.3% | 3.794 | 8.434 | 67.966 | 5.306 | 35.656 |
| hex: http/html-1kx1024 | 2099200 | 17053.5 ± 1.4% | 6602.5 ± 0.9% | 3253.6 ± 0.6% | 454.5 ± 0.6% | 4724.0 ± 0.8% | 748.8 ± 2.3% | 2.583 | 5.241 | 37.518 | 3.610 | 22.775 |
| hex: http/html-16kx64 | 2097280 | 34570.1 ± 2.4% | 7667.6 ± 0.1% | 3517.3 ± 1.4% | 460.8 ± 4.1% | 5404.1 ± 17.7% | 799.7 ± 2.0% | 4.509 | 9.828 | 75.018 | 6.397 | 43.229 |
| hex: http/html-1m | 524290 | 28890.2 ± 2.6% | 7644.7 ± 1.2% | 3461.6 ± 0.9% | 461.5 ± 0.3% | 5513.3 ± 0.5% | 820.2 ± 2.1% | 3.779 | 8.346 | 62.603 | 5.240 | 35.224 |
| hex: http/json-1kx1024 | 2099200 | 16764.4 ± 2.8% | 6608.4 ± 1.0% | 3254.9 ± 0.1% | 574.7 ± 0.4% | 4700.7 ± 1.0% | 736.1 ± 3.1% | 2.537 | 5.150 | 29.173 | 3.566 | 22.774 |
| hex: http/json-16kx64 | 2097280 | 35173.8 ± 1.4% | 7628.3 ± 7.6% | 3506.1 ± 0.8% | 585.4 ± 0.3% | 5417.0 ± 0.8% | 805.8 ± 2.6% | 4.611 | 10.032 | 60.089 | 6.493 | 43.651 |
| hex: http/json-1m | 524290 | 29157.9 ± 3.1% | 7661.7 ± 0.7% | 3451.4 ± 1.6% | 595.9 ± 3.9% | 5500.8 ± 5.7% | 794.5 ± 5.1% | 3.806 | 8.448 | 48.930 | 5.301 | 36.698 |
| hex: http/js-1kx1024 | 2099200 | 16626.5 ± 2.8% | 6625.1 ± 0.2% | 3253.8 ± 0.2% | 444.3 ± 10.9% | 4719.1 ± 1.0% | 745.0 ± 1.0% | 2.510 | 5.110 | 37.423 | 3.523 | 22.316 |
| hex: http/js-16kx64 | 2097280 | 34909.2 ± 1.9% | 7666.9 ± 7.5% | 3518.5 ± 0.6% | 449.3 ± 0.8% | 5421.2 ± 0.2% | 810.4 ± 2.7% | 4.553 | 9.922 | 77.696 | 6.439 | 43.076 |
| hex: http/js-1m | 524290 | 28789.1 ± 2.7% | 7660.4 ± 1.5% | 3443.6 ± 7.7% | 466.7 ± 10.3% | 5529.6 ± 0.4% | 813.9 ± 3.9% | 3.758 | 8.360 | 61.691 | 5.206 | 35.371 |
| hex: http/css-1kx1024 | 2099200 | 16869.8 ± 0.6% | 6611.6 ± 0.3% | 3250.2 ± 0.4% | 498.0 ± 14.6% | 4716.6 ± 0.8% | 728.1 ± 2.4% | 2.552 | 5.190 | 33.876 | 3.577 | 23.171 |
| hex: http/css-16kx64 | 2097280 | 34629.3 ± 0.9% | 7644.7 ± 0.3% | 3514.8 ± 0.6% | 508.4 ± 0.9% | 5418.3 ± 0.4% | 788.1 ± 2.7% | 4.530 | 9.852 | 68.112 | 6.391 | 43.941 |
| hex: http/css-1m | 524290 | 29183.0 ± 2.7% | 7664.0 ± 1.1% | 3459.4 ± 0.8% | 500.7 ± 0.6% | 5511.0 ± 0.6% | 809.7 ± 1.1% | 3.808 | 8.436 | 58.285 | 5.295 | 36.043 |
| hex: shuffled/dickens-1m | 524290 | 28830.6 ± 2.8% | 7661.4 ± 1.0% | 3445.9 ± 1.7% | 445.6 ± 0.5% | 5501.8 ± 0.4% | 802.6 ± 3.5% | 3.763 | 8.367 | 64.708 | 5.240 | 35.922 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1347.3 ± 2.6% | 1133.1 ± 2.7% | 895.0 ± 0.9% | 329.2 ± 1.6% | 351.5 ± 0.9% | 305.6 ± 2.9% | 1.189 | 1.505 | 4.092 | 3.833 | 4.408 |
| qlog records, JSON text sequence | 1467503 | 1169.2 ± 5.5% | 872.6 ± 0.3% | 726.8 ± 1.0% | 320.4 ± 1.0% | 392.0 ± 0.7% | 230.7 ± 16.6% | 1.340 | 1.609 | 3.649 | 2.983 | 5.069 |
| messages: 11 string members | 1025025 | 1104.0 ± 3.3% | 893.8 ± 0.8% | 667.0 ± 0.8% | 315.9 ± 0.9% | 325.5 ± 1.6% | 283.6 ± 6.5% | 1.235 | 1.655 | 3.495 | 3.391 | 3.892 |
| messages: 50 nested objects | 1121600 | 1383.5 ± 0.3% | 1196.7 ± 1.3% | 999.2 ± 6.5% | 395.6 ± 5.7% | 428.6 ± 0.4% | 327.8 ± 1.4% | 1.156 | 1.385 | 3.497 | 3.228 | 4.220 |
| messages: a tree of 341 objects | 612600 | 457.7 ± 2.8% | 612.1 ± 1.2% | 405.1 ± 1.2% | 205.6 ± 2.1% | 266.0 ± 1.9% | 132.0 ± 4.6% | 0.748 | 1.130 | 2.226 | 1.720 | 3.466 |
| string: silesia/dickens | 172528 | 8533.1 ± 0.7% | 3012.6 ± 1.4% | 2013.7 ± 1.1% | 361.1 ± 0.6% | 1052.9 ± 0.3% | 560.7 ± 0.6% | 2.832 | 4.238 | 23.634 | 8.104 | 15.219 |
| string: silesia/nci | 1075110 | 8119.4 ± 0.7% | 3201.2 ± 7.1% | 2779.3 ± 2.7% | 775.7 ± 1.4% | 1095.8 ± 1.7% | 559.4 ± 0.7% | 2.536 | 2.921 | 10.467 | 7.409 | 14.515 |
| string: silesia/reymont | 1075159 | 3815.3 ± 0.4% | 1657.8 ± 0.5% | 1718.5 ± 1.4% | 371.8 ± 0.4% | 959.6 ± 0.6% | 548.0 ± 0.8% | 2.301 | 2.220 | 10.261 | 3.976 | 6.962 |
| string: silesia/samba | 97582 | 4538.1 ± 0.5% | 1943.7 ± 0.6% | 2177.5 ± 0.6% | 296.1 ± 1.2% | 912.3 ± 1.0% | 622.2 ± 11.0% | 2.335 | 2.084 | 15.327 | 4.974 | 7.294 |
| string: silesia/webster | 1098490 | 5045.1 ± 5.6% | 1637.3 ± 7.2% | 1524.3 ± 2.4% | 357.5 ± 1.7% | 940.4 ± 0.2% | 454.4 ± 0.5% | 3.081 | 3.310 | 14.113 | 5.365 | 11.104 |
| string: silesia/xml | 1090118 | 7740.0 ± 10.1% | 2673.9 ± 0.6% | 2165.4 ± 3.5% | 529.7 ± 0.9% | 1128.0 ± 0.6% | 558.1 ± 0.5% | 2.895 | 3.574 | 14.611 | 6.862 | 13.868 |
| string: canterbury/alice29.txt | 159425 | 9156.6 ± 0.4% | 2420.9 ± 2.8% | 1782.4 ± 8.1% | 339.5 ± 0.8% | 1015.7 ± 4.2% | 556.9 ± 0.4% | 3.782 | 5.137 | 26.967 | 9.015 | 16.441 |
| string: canterbury/asyoulik.txt | 132198 | 7418.9 ± 1.0% | 2181.9 ± 20.3% | 1538.9 ± 0.2% | 349.9 ± 3.8% | 906.4 ± 4.2% | 543.3 ± 0.4% | 3.400 | 4.821 | 21.203 | 8.185 | 13.656 |
| string: canterbury/lcet10.txt | 441884 | 8319.7 ± 1.9% | 2485.8 ± 4.1% | 1949.2 ± 0.5% | 395.7 ± 3.3% | 1035.4 ± 1.0% | 554.6 ± 12.5% | 3.347 | 4.268 | 21.024 | 8.035 | 15.002 |
| string: canterbury/plrabn12.txt | 503330 | 5915.4 ± 7.6% | 1849.3 ± 0.5% | 1665.8 ± 0.1% | 367.2 ± 1.1% | 1001.0 ± 1.3% | 556.4 ± 0.5% | 3.199 | 3.551 | 16.110 | 5.909 | 10.631 |
| string: canterbury-large/E.coli | 1048578 | 29155.1 ± 2.8% | 10428.7 ± 1.0% | 3380.5 ± 1.1% | 1416.6 ± 0.4% | 1420.2 ± 0.5% | 578.3 ± 0.8% | 2.796 | 8.624 | 20.581 | 20.529 | 50.415 |
| string: canterbury-large/bible.txt | 1055886 | 6954.2 ± 0.7% | 3992.8 ± 0.8% | 2648.9 ± 0.8% | 442.3 ± 0.6% | 1210.3 ± 0.5% | 564.8 ± 1.2% | 1.742 | 2.625 | 15.723 | 5.746 | 12.314 |
| string: canterbury-large/world192.txt | 1103121 | 4945.8 ± 6.2% | 1455.1 ± 9.3% | 1571.0 ± 1.6% | 361.4 ± 0.3% | 932.6 ± 0.3% | 537.1 ± 2.2% | 3.399 | 3.148 | 13.686 | 5.303 | 9.208 |
| string: http/html-1m | 1058582 | 8383.2 ± 0.8% | 3870.5 ± 1.6% | 2479.8 ± 7.0% | 445.4 ± 1.0% | 1192.3 ± 1.1% | 518.4 ± 0.7% | 2.166 | 3.381 | 18.823 | 7.031 | 16.172 |
| string: http/json-1m | 1190272 | 6307.8 ± 1.2% | 1234.4 ± 0.3% | 1271.6 ± 0.4% | 415.6 ± 0.3% | 784.6 ± 0.9% | 508.7 ± 0.5% | 5.110 | 4.961 | 15.179 | 8.039 | 12.399 |
| string: http/js-1m | 1144362 | 5018.3 ± 1.1% | 992.1 ± 8.2% | 1086.3 ± 1.1% | 308.7 ± 2.3% | 785.9 ± 0.7% | 473.1 ± 0.7% | 5.058 | 4.619 | 16.258 | 6.386 | 10.608 |
| string: http/css-1m | 1097820 | 6492.1 ± 2.2% | 1286.9 ± 1.3% | 1597.6 ± 0.3% | 443.4 ± 11.5% | 854.1 ± 1.7% | 527.9 ± 0.6% | 5.045 | 4.064 | 14.641 | 7.601 | 12.299 |
| string: dickens as Cyrillic and CJK | 1883069 | 5329.8 ± 0.4% | 3013.0 ± 0.4% | 348.0 ± 4.2% | 275.0 ± 0.2% | 400.2 ± 1.0% | 291.8 ± 0.4% | 1.769 | 15.315 | 19.380 | 13.319 | 18.265 |
| hex: silesia/dickens | 524290 | 30463.8 ± 0.6% | 1553.1 ± 0.8% | 1086.2 ± 0.8% | 423.1 ± 1.7% | 778.8 ± 1.3% | 450.8 ± 5.2% | 19.615 | 28.047 | 71.996 | 39.117 | 67.584 |
| hex: silesia/mozilla | 524290 | 34361.1 ± 0.8% | 1558.0 ± 0.7% | 1087.7 ± 1.2% | 370.9 ± 0.8% | 793.6 ± 1.1% | 451.3 ± 1.4% | 22.054 | 31.591 | 92.649 | 43.298 | 76.144 |
| hex: silesia/mr | 524290 | 34473.2 ± 0.2% | 1551.5 ± 0.8% | 1086.8 ± 0.9% | 510.6 ± 0.3% | 793.2 ± 0.7% | 450.2 ± 0.5% | 22.220 | 31.719 | 67.509 | 43.464 | 76.579 |
| hex: silesia/nci | 524290 | 34757.5 ± 1.6% | 1548.2 ± 1.2% | 1083.9 ± 0.5% | 581.6 ± 0.4% | 792.5 ± 0.7% | 452.1 ± 0.7% | 22.451 | 32.066 | 59.761 | 43.856 | 76.872 |
| hex: silesia/ooffice | 524290 | 33791.7 ± 1.0% | 1544.8 ± 0.5% | 1087.1 ± 0.4% | 327.9 ± 2.6% | 792.0 ± 1.8% | 450.7 ± 4.1% | 21.874 | 31.084 | 103.040 | 42.665 | 74.979 |
| hex: silesia/osdb | 524290 | 32317.0 ± 2.1% | 1552.2 ± 1.4% | 1087.0 ± 0.4% | 416.6 ± 0.4% | 794.1 ± 0.6% | 448.8 ± 1.8% | 20.820 | 29.732 | 77.581 | 40.695 | 72.009 |
| hex: silesia/reymont | 524290 | 33194.1 ± 1.5% | 1555.0 ± 1.0% | 1087.3 ± 0.6% | 447.6 ± 0.3% | 798.6 ± 0.2% | 451.1 ± 0.8% | 21.347 | 30.529 | 74.157 | 41.567 | 73.585 |
| hex: silesia/samba | 524290 | 35246.1 ± 2.7% | 1552.7 ± 0.4% | 1087.2 ± 9.3% | 334.5 ± 5.4% | 796.7 ± 0.6% | 450.6 ± 0.8% | 22.699 | 32.420 | 105.374 | 44.238 | 78.220 |
| hex: silesia/sao | 524290 | 34153.1 ± 15.8% | 1551.7 ± 1.6% | 1087.2 ± 0.3% | 268.5 ± 0.8% | 794.7 ± 0.3% | 450.4 ± 0.7% | 22.011 | 31.413 | 127.186 | 42.977 | 75.822 |
| hex: silesia/webster | 524290 | 35596.7 ± 1.0% | 1556.7 ± 0.6% | 1087.9 ± 0.4% | 407.9 ± 0.6% | 796.4 ± 2.0% | 450.8 ± 6.7% | 22.867 | 32.721 | 87.268 | 44.699 | 78.965 |
| hex: silesia/x-ray | 524290 | 33678.5 ± 2.1% | 1559.3 ± 1.9% | 1087.9 ± 0.2% | 384.9 ± 5.2% | 789.7 ± 0.9% | 433.2 ± 3.3% | 21.599 | 30.958 | 87.497 | 42.649 | 77.741 |
| hex: silesia/xml | 524290 | 34349.6 ± 0.7% | 1556.7 ± 1.7% | 1088.2 ± 0.6% | 583.0 ± 1.2% | 795.1 ± 33.8% | 450.6 ± 3.2% | 22.065 | 31.564 | 58.919 | 43.204 | 76.227 |
| hex: canterbury/alice29.txt | 304180 | 33161.9 ± 2.0% | 1585.3 ± 3.2% | 1095.2 ± 0.5% | 430.9 ± 0.4% | 807.2 ± 0.4% | 452.8 ± 1.3% | 20.919 | 30.280 | 76.961 | 41.081 | 73.234 |
| hex: canterbury/asyoulik.txt | 250360 | 31892.2 ± 2.6% | 1604.5 ± 9.8% | 1101.4 ± 0.2% | 423.5 ± 1.1% | 808.4 ± 0.5% | 453.8 ± 0.9% | 19.877 | 28.955 | 75.314 | 39.449 | 70.273 |
| hex: canterbury/cp.html | 49208 | 31647.6 ± 1.1% | 1619.0 ± 1.6% | 1110.2 ± 0.4% | 465.7 ± 0.3% | 814.0 ± 1.5% | 456.3 ± 0.5% | 19.548 | 28.506 | 67.954 | 38.878 | 69.349 |
| hex: canterbury/fields.c | 22302 | 32281.3 ± 1.4% | 1600.1 ± 0.6% | 1101.8 ± 0.2% | 542.6 ± 6.9% | 808.2 ± 1.7% | 454.8 ± 0.2% | 20.175 | 29.300 | 59.496 | 39.943 | 70.973 |
| hex: canterbury/grammar.lsp | 7444 | 32560.0 ± 0.2% | 1631.0 ± 4.1% | 1116.3 ± 0.7% | 563.9 ± 0.6% | 815.1 ± 1.6% | 460.2 ± 1.2% | 19.963 | 29.168 | 57.739 | 39.948 | 70.753 |
| hex: canterbury/kennedy.xls | 524290 | 30790.0 ± 12.0% | 1552.5 ± 0.9% | 1086.2 ± 0.6% | 591.7 ± 0.5% | 784.8 ± 1.5% | 451.4 ± 0.8% | 19.833 | 28.346 | 52.032 | 39.232 | 68.215 |
| hex: canterbury/lcet10.txt | 524290 | 35014.2 ± 7.1% | 1553.8 ± 5.0% | 1086.4 ± 0.6% | 430.8 ± 0.3% | 794.1 ± 16.9% | 450.5 ± 0.7% | 22.535 | 32.229 | 81.281 | 44.095 | 77.716 |
| hex: canterbury/plrabn12.txt | 524290 | 34203.5 ± 1.3% | 1555.3 ± 1.7% | 1087.4 ± 0.5% | 421.4 ± 1.2% | 797.3 ± 1.8% | 451.4 ± 0.6% | 21.991 | 31.454 | 81.175 | 42.902 | 75.779 |
| hex: canterbury/ptt5 | 524290 | 34081.4 ± 0.9% | 1550.6 ± 0.7% | 1087.5 ± 0.6% | 500.4 ± 0.3% | 795.3 ± 0.4% | 452.1 ± 0.9% | 21.979 | 31.338 | 68.115 | 42.855 | 75.378 |
| hex: canterbury/sum | 76482 | 35309.0 ± 0.8% | 1616.9 ± 0.1% | 1107.6 ± 0.8% | 520.1 ± 1.6% | 811.4 ± 0.3% | 458.4 ± 0.7% | 21.838 | 31.878 | 67.888 | 43.518 | 77.026 |
| hex: canterbury/xargs.1 | 8456 | 34736.1 ± 8.8% | 1631.1 ± 0.2% | 1112.4 ± 0.3% | 598.1 ± 0.5% | 815.7 ± 0.4% | 461.4 ± 1.0% | 21.297 | 31.226 | 58.081 | 42.582 | 75.282 |
| hex: canterbury-large/E.coli | 524290 | 30097.8 ± 1.3% | 1553.3 ± 0.5% | 1086.2 ± 1.1% | 607.9 ± 0.5% | 796.1 ± 0.9% | 452.3 ± 1.3% | 19.377 | 27.710 | 49.507 | 37.807 | 66.550 |
| hex: canterbury-large/bible.txt | 524290 | 34836.8 ± 0.9% | 1554.2 ± 1.0% | 1085.3 ± 2.3% | 441.6 ± 2.9% | 794.1 ± 0.1% | 450.3 ± 1.1% | 22.415 | 32.098 | 78.889 | 43.867 | 77.364 |
| hex: canterbury-large/world192.txt | 524290 | 32728.1 ± 2.1% | 1554.1 ± 6.1% | 1085.4 ± 0.2% | 421.4 ± 0.3% | 796.7 ± 0.7% | 451.3 ± 0.8% | 21.059 | 30.154 | 77.657 | 41.080 | 72.523 |
| hex: http/html-1kx1024 | 2099200 | 23983.7 ± 1.3% | 1606.5 ± 0.3% | 1089.6 ± 0.1% | 458.8 ± 2.9% | 807.6 ± 0.1% | 453.1 ± 0.5% | 14.930 | 22.012 | 52.280 | 29.696 | 52.938 |
| hex: http/html-16kx64 | 2097280 | 29930.9 ± 13.8% | 1607.9 ± 0.9% | 1105.8 ± 0.2% | 462.9 ± 0.4% | 806.3 ± 1.2% | 457.5 ± 0.2% | 18.615 | 27.068 | 64.660 | 37.120 | 65.426 |
| hex: http/html-1m | 524290 | 31425.3 ± 0.6% | 1552.4 ± 1.6% | 1078.6 ± 7.4% | 443.2 ± 1.5% | 777.5 ± 16.8% | 451.3 ± 0.2% | 20.242 | 29.134 | 70.899 | 40.418 | 69.640 |
| hex: http/json-1kx1024 | 2099200 | 23751.6 ± 0.9% | 1610.0 ± 0.4% | 1088.6 ± 0.3% | 566.3 ± 0.4% | 806.5 ± 0.4% | 453.3 ± 0.5% | 14.753 | 21.819 | 41.944 | 29.450 | 52.397 |
| hex: http/json-16kx64 | 2097280 | 30142.3 ± 0.3% | 1609.7 ± 0.3% | 1104.9 ± 1.7% | 581.0 ± 1.6% | 805.1 ± 0.9% | 457.2 ± 0.1% | 18.725 | 27.281 | 51.876 | 37.440 | 65.935 |
| hex: http/json-1m | 524290 | 30604.3 ± 2.8% | 1549.9 ± 2.0% | 1085.0 ± 0.8% | 585.0 ± 1.6% | 776.2 ± 0.7% | 450.5 ± 0.8% | 19.746 | 28.206 | 52.318 | 39.427 | 67.937 |
| hex: http/js-1kx1024 | 2099200 | 23905.2 ± 6.5% | 1607.2 ± 0.1% | 1087.6 ± 0.3% | 445.0 ± 8.3% | 806.0 ± 0.1% | 453.3 ± 0.4% | 14.874 | 21.980 | 53.716 | 29.658 | 52.739 |
| hex: http/js-16kx64 | 2097280 | 29937.7 ± 1.8% | 1609.1 ± 0.3% | 1102.4 ± 0.4% | 449.1 ± 9.5% | 806.8 ± 5.4% | 457.2 ± 7.3% | 18.605 | 27.158 | 66.664 | 37.108 | 65.481 |
| hex: http/js-1m | 524290 | 30974.7 ± 0.9% | 1552.9 ± 0.9% | 1086.8 ± 0.3% | 449.8 ± 0.3% | 777.8 ± 0.7% | 451.6 ± 0.4% | 19.947 | 28.501 | 68.862 | 39.823 | 68.591 |
| hex: http/css-1kx1024 | 2099200 | 23708.2 ± 1.5% | 1609.2 ± 0.3% | 1088.8 ± 1.6% | 499.4 ± 1.6% | 805.7 ± 1.9% | 452.5 ± 0.5% | 14.733 | 21.775 | 47.475 | 29.427 | 52.399 |
| hex: http/css-16kx64 | 2097280 | 29700.0 ± 2.1% | 1606.2 ± 0.3% | 1102.9 ± 0.2% | 506.7 ± 1.2% | 805.8 ± 14.1% | 457.4 ± 0.4% | 18.490 | 26.929 | 58.618 | 36.856 | 64.937 |
| hex: http/css-1m | 524290 | 30846.1 ± 0.8% | 1549.5 ± 1.3% | 1086.6 ± 1.2% | 482.1 ± 0.4% | 777.8 ± 0.6% | 450.1 ± 0.6% | 19.908 | 28.388 | 63.985 | 39.660 | 68.538 |
| hex: shuffled/dickens-1m | 524290 | 32393.3 ± 10.7% | 1551.8 ± 1.0% | 1083.9 ± 0.4% | 424.6 ± 0.3% | 779.8 ± 0.3% | 451.2 ± 0.7% | 20.874 | 29.886 | 76.283 | 41.539 | 71.787 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1345.2 ± 0.5% | 1133.1 ± 2.7% | 895.0 ± 0.9% | 329.2 ± 1.6% | 351.5 ± 0.9% | 305.6 ± 2.9% | 1.187 | 1.503 | 4.086 | 3.827 | 4.402 |
| qlog records, JSON text sequence | 1467503 | 1175.4 ± 0.5% | 872.6 ± 0.3% | 726.8 ± 1.0% | 320.4 ± 1.0% | 392.0 ± 0.7% | 230.7 ± 16.6% | 1.347 | 1.617 | 3.668 | 2.999 | 5.096 |
| messages: 11 string members | 1025025 | 1112.5 ± 13.3% | 893.8 ± 0.8% | 667.0 ± 0.8% | 315.9 ± 0.9% | 325.5 ± 1.6% | 283.6 ± 6.5% | 1.245 | 1.668 | 3.522 | 3.418 | 3.922 |
| messages: 50 nested objects | 1121600 | 1364.0 ± 0.5% | 1196.7 ± 1.3% | 999.2 ± 6.5% | 395.6 ± 5.7% | 428.6 ± 0.4% | 327.8 ± 1.4% | 1.140 | 1.365 | 3.448 | 3.183 | 4.161 |
| messages: a tree of 341 objects | 612600 | 489.8 ± 1.1% | 612.1 ± 1.2% | 405.1 ± 1.2% | 205.6 ± 2.1% | 266.0 ± 1.9% | 132.0 ± 4.6% | 0.800 | 1.209 | 2.382 | 1.841 | 3.709 |
| string: silesia/dickens | 172528 | 8986.3 ± 0.2% | 3012.6 ± 1.4% | 2013.7 ± 1.1% | 361.1 ± 0.6% | 1052.9 ± 0.3% | 560.7 ± 0.6% | 2.983 | 4.463 | 24.889 | 8.535 | 16.028 |
| string: silesia/nci | 1075110 | 8319.9 ± 0.3% | 3201.2 ± 7.1% | 2779.3 ± 2.7% | 775.7 ± 1.4% | 1095.8 ± 1.7% | 559.4 ± 0.7% | 2.599 | 2.993 | 10.726 | 7.592 | 14.873 |
| string: silesia/reymont | 1075159 | 3826.3 ± 0.9% | 1657.8 ± 0.5% | 1718.5 ± 1.4% | 371.8 ± 0.4% | 959.6 ± 0.6% | 548.0 ± 0.8% | 2.308 | 2.226 | 10.290 | 3.987 | 6.982 |
| string: silesia/samba | 97582 | 5077.4 ± 9.2% | 1943.7 ± 0.6% | 2177.5 ± 0.6% | 296.1 ± 1.2% | 912.3 ± 1.0% | 622.2 ± 11.0% | 2.612 | 2.332 | 17.148 | 5.565 | 8.161 |
| string: silesia/webster | 1098490 | 5063.9 ± 0.9% | 1637.3 ± 7.2% | 1524.3 ± 2.4% | 357.5 ± 1.7% | 940.4 ± 0.2% | 454.4 ± 0.5% | 3.093 | 3.322 | 14.165 | 5.385 | 11.145 |
| string: silesia/xml | 1090118 | 8173.9 ± 1.0% | 2673.9 ± 0.6% | 2165.4 ± 3.5% | 529.7 ± 0.9% | 1128.0 ± 0.6% | 558.1 ± 0.5% | 3.057 | 3.775 | 15.430 | 7.246 | 14.645 |
| string: canterbury/alice29.txt | 159425 | 9388.4 ± 0.8% | 2420.9 ± 2.8% | 1782.4 ± 8.1% | 339.5 ± 0.8% | 1015.7 ± 4.2% | 556.9 ± 0.4% | 3.878 | 5.267 | 27.650 | 9.243 | 16.857 |
| string: canterbury/asyoulik.txt | 132198 | 7704.6 ± 0.5% | 2181.9 ± 20.3% | 1538.9 ± 0.2% | 349.9 ± 3.8% | 906.4 ± 4.2% | 543.3 ± 0.4% | 3.531 | 5.007 | 22.020 | 8.500 | 14.182 |
| string: canterbury/lcet10.txt | 441884 | 8693.9 ± 0.6% | 2485.8 ± 4.1% | 1949.2 ± 0.5% | 395.7 ± 3.3% | 1035.4 ± 1.0% | 554.6 ± 12.5% | 3.497 | 4.460 | 21.970 | 8.397 | 15.677 |
| string: canterbury/plrabn12.txt | 503330 | 6131.6 ± 8.2% | 1849.3 ± 0.5% | 1665.8 ± 0.1% | 367.2 ± 1.1% | 1001.0 ± 1.3% | 556.4 ± 0.5% | 3.316 | 3.681 | 16.699 | 6.125 | 11.020 |
| string: canterbury-large/E.coli | 1048578 | 29176.6 ± 3.8% | 10428.7 ± 1.0% | 3380.5 ± 1.1% | 1416.6 ± 0.4% | 1420.2 ± 0.5% | 578.3 ± 0.8% | 2.798 | 8.631 | 20.596 | 20.544 | 50.452 |
| string: canterbury-large/bible.txt | 1055886 | 7243.8 ± 0.3% | 3992.8 ± 0.8% | 2648.9 ± 0.8% | 442.3 ± 0.6% | 1210.3 ± 0.5% | 564.8 ± 1.2% | 1.814 | 2.735 | 16.378 | 5.985 | 12.826 |
| string: canterbury-large/world192.txt | 1103121 | 4749.8 ± 1.0% | 1455.1 ± 9.3% | 1571.0 ± 1.6% | 361.4 ± 0.3% | 932.6 ± 0.3% | 537.1 ± 2.2% | 3.264 | 3.023 | 13.144 | 5.093 | 8.843 |
| string: http/html-1m | 1058582 | 8505.4 ± 0.6% | 3870.5 ± 1.6% | 2479.8 ± 7.0% | 445.4 ± 1.0% | 1192.3 ± 1.1% | 518.4 ± 0.7% | 2.197 | 3.430 | 19.098 | 7.133 | 16.408 |
| string: http/json-1m | 1190272 | 6416.1 ± 0.3% | 1234.4 ± 0.3% | 1271.6 ± 0.4% | 415.6 ± 0.3% | 784.6 ± 0.9% | 508.7 ± 0.5% | 5.198 | 5.046 | 15.440 | 8.177 | 12.612 |
| string: http/js-1m | 1144362 | 5002.8 ± 1.3% | 992.1 ± 8.2% | 1086.3 ± 1.1% | 308.7 ± 2.3% | 785.9 ± 0.7% | 473.1 ± 0.7% | 5.042 | 4.605 | 16.208 | 6.366 | 10.576 |
| string: http/css-1m | 1097820 | 6841.7 ± 1.7% | 1286.9 ± 1.3% | 1597.6 ± 0.3% | 443.4 ± 11.5% | 854.1 ± 1.7% | 527.9 ± 0.6% | 5.317 | 4.282 | 15.429 | 8.011 | 12.961 |
| string: dickens as Cyrillic and CJK | 1883069 | 5227.9 ± 1.7% | 3013.0 ± 0.4% | 348.0 ± 4.2% | 275.0 ± 0.2% | 400.2 ± 1.0% | 291.8 ± 0.4% | 1.735 | 15.022 | 19.010 | 13.064 | 17.916 |
| hex: silesia/dickens | 524290 | 30595.4 ± 0.4% | 1553.1 ± 0.8% | 1086.2 ± 0.8% | 423.1 ± 1.7% | 778.8 ± 1.3% | 450.8 ± 5.2% | 19.700 | 28.168 | 72.307 | 39.286 | 67.876 |
| hex: silesia/mozilla | 524290 | 34692.9 ± 0.4% | 1558.0 ± 0.7% | 1087.7 ± 1.2% | 370.9 ± 0.8% | 793.6 ± 1.1% | 451.3 ± 1.4% | 22.267 | 31.897 | 93.544 | 43.716 | 76.879 |
| hex: silesia/mr | 524290 | 34744.4 ± 1.2% | 1551.5 ± 0.8% | 1086.8 ± 0.9% | 510.6 ± 0.3% | 793.2 ± 0.7% | 450.2 ± 0.5% | 22.394 | 31.969 | 68.040 | 43.806 | 77.181 |
| hex: silesia/nci | 524290 | 35135.8 ± 0.9% | 1548.2 ± 1.2% | 1083.9 ± 0.5% | 581.6 ± 0.4% | 792.5 ± 0.7% | 452.1 ± 0.7% | 22.695 | 32.415 | 60.411 | 44.333 | 77.709 |
| hex: silesia/ooffice | 524290 | 34125.2 ± 0.6% | 1544.8 ± 0.5% | 1087.1 ± 0.4% | 327.9 ± 2.6% | 792.0 ± 1.8% | 450.7 ± 4.1% | 22.090 | 31.391 | 104.057 | 43.086 | 75.719 |
| hex: silesia/osdb | 524290 | 32262.8 ± 0.3% | 1552.2 ± 1.4% | 1087.0 ± 0.4% | 416.6 ± 0.4% | 794.1 ± 0.6% | 448.8 ± 1.8% | 20.785 | 29.682 | 77.451 | 40.627 | 71.888 |
| hex: silesia/reymont | 524290 | 33447.1 ± 0.1% | 1555.0 ± 1.0% | 1087.3 ± 0.6% | 447.6 ± 0.3% | 798.6 ± 0.2% | 451.1 ± 0.8% | 21.510 | 30.761 | 74.722 | 41.884 | 74.146 |
| hex: silesia/samba | 524290 | 35493.2 ± 0.5% | 1552.7 ± 0.4% | 1087.2 ± 9.3% | 334.5 ± 5.4% | 796.7 ± 0.6% | 450.6 ± 0.8% | 22.859 | 32.648 | 106.113 | 44.548 | 78.768 |
| hex: silesia/sao | 524290 | 34317.0 ± 0.7% | 1551.7 ± 1.6% | 1087.2 ± 0.3% | 268.5 ± 0.8% | 794.7 ± 0.3% | 450.4 ± 0.7% | 22.116 | 31.563 | 127.797 | 43.183 | 76.186 |
| hex: silesia/webster | 524290 | 35809.3 ± 15.6% | 1556.7 ± 0.6% | 1087.9 ± 0.4% | 407.9 ± 0.6% | 796.4 ± 2.0% | 450.8 ± 6.7% | 23.003 | 32.916 | 87.789 | 44.966 | 79.437 |
| hex: silesia/x-ray | 524290 | 34178.2 ± 0.7% | 1559.3 ± 1.9% | 1087.9 ± 0.2% | 384.9 ± 5.2% | 789.7 ± 0.9% | 433.2 ± 3.3% | 21.920 | 31.417 | 88.795 | 43.282 | 78.895 |
| hex: silesia/xml | 524290 | 34651.2 ± 0.6% | 1556.7 ± 1.7% | 1088.2 ± 0.6% | 583.0 ± 1.2% | 795.1 ± 33.8% | 450.6 ± 3.2% | 22.259 | 31.841 | 59.436 | 43.583 | 76.897 |
| hex: canterbury/alice29.txt | 304180 | 33186.1 ± 0.5% | 1585.3 ± 3.2% | 1095.2 ± 0.5% | 430.9 ± 0.4% | 807.2 ± 0.4% | 452.8 ± 1.3% | 20.934 | 30.302 | 77.017 | 41.111 | 73.288 |
| hex: canterbury/asyoulik.txt | 250360 | 31779.5 ± 0.3% | 1604.5 ± 9.8% | 1101.4 ± 0.2% | 423.5 ± 1.1% | 808.4 ± 0.5% | 453.8 ± 0.9% | 19.806 | 28.853 | 75.048 | 39.310 | 70.025 |
| hex: canterbury/cp.html | 49208 | 31748.1 ± 0.4% | 1619.0 ± 1.6% | 1110.2 ± 0.4% | 465.7 ± 0.3% | 814.0 ± 1.5% | 456.3 ± 0.5% | 19.610 | 28.597 | 68.170 | 39.001 | 69.570 |
| hex: canterbury/fields.c | 22302 | 32265.9 ± 0.8% | 1600.1 ± 0.6% | 1101.8 ± 0.2% | 542.6 ± 6.9% | 808.2 ± 1.7% | 454.8 ± 0.2% | 20.165 | 29.286 | 59.467 | 39.924 | 70.939 |
| hex: canterbury/grammar.lsp | 7444 | 32908.5 ± 0.5% | 1631.0 ± 4.1% | 1116.3 ± 0.7% | 563.9 ± 0.6% | 815.1 ± 1.6% | 460.2 ± 1.2% | 20.176 | 29.480 | 58.358 | 40.376 | 71.510 |
| hex: canterbury/kennedy.xls | 524290 | 30786.7 ± 1.7% | 1552.5 ± 0.9% | 1086.2 ± 0.6% | 591.7 ± 0.5% | 784.8 ± 1.5% | 451.4 ± 0.8% | 19.831 | 28.343 | 52.027 | 39.228 | 68.207 |
| hex: canterbury/lcet10.txt | 524290 | 35349.8 ± 0.3% | 1553.8 ± 5.0% | 1086.4 ± 0.6% | 430.8 ± 0.3% | 794.1 ± 16.9% | 450.5 ± 0.7% | 22.751 | 32.538 | 82.060 | 44.518 | 78.461 |
| hex: canterbury/plrabn12.txt | 524290 | 34461.9 ± 1.9% | 1555.3 ± 1.7% | 1087.4 ± 0.5% | 421.4 ± 1.2% | 797.3 ± 1.8% | 451.4 ± 0.6% | 22.157 | 31.692 | 81.788 | 43.226 | 76.351 |
| hex: canterbury/ptt5 | 524290 | 34429.4 ± 3.0% | 1550.6 ± 0.7% | 1087.5 ± 0.6% | 500.4 ± 0.3% | 795.3 ± 0.4% | 452.1 ± 0.9% | 22.204 | 31.658 | 68.810 | 43.293 | 76.147 |
| hex: canterbury/sum | 76482 | 35625.6 ± 0.8% | 1616.9 ± 0.1% | 1107.6 ± 0.8% | 520.1 ± 1.6% | 811.4 ± 0.3% | 458.4 ± 0.7% | 22.034 | 32.164 | 68.497 | 43.908 | 77.716 |
| hex: canterbury/xargs.1 | 8456 | 35004.3 ± 0.1% | 1631.1 ± 0.2% | 1112.4 ± 0.3% | 598.1 ± 0.5% | 815.7 ± 0.4% | 461.4 ± 1.0% | 21.461 | 31.467 | 58.529 | 42.911 | 75.864 |
| hex: canterbury-large/E.coli | 524290 | 30166.1 ± 2.8% | 1553.3 ± 0.5% | 1086.2 ± 1.1% | 607.9 ± 0.5% | 796.1 ± 0.9% | 452.3 ± 1.3% | 19.421 | 27.773 | 49.619 | 37.893 | 66.701 |
| hex: canterbury-large/bible.txt | 524290 | 34966.7 ± 0.5% | 1554.2 ± 1.0% | 1085.3 ± 2.3% | 441.6 ± 2.9% | 794.1 ± 0.1% | 450.3 ± 1.1% | 22.498 | 32.217 | 79.183 | 44.031 | 77.652 |
| hex: canterbury-large/world192.txt | 524290 | 33109.7 ± 0.4% | 1554.1 ± 6.1% | 1085.4 ± 0.2% | 421.4 ± 0.3% | 796.7 ± 0.7% | 451.3 ± 0.8% | 21.304 | 30.506 | 78.562 | 41.559 | 73.369 |
| hex: http/html-1kx1024 | 2099200 | 24387.9 ± 0.9% | 1606.5 ± 0.3% | 1089.6 ± 0.1% | 458.8 ± 2.9% | 807.6 ± 0.1% | 453.1 ± 0.5% | 15.181 | 22.383 | 53.161 | 30.197 | 53.830 |
| hex: http/html-16kx64 | 2097280 | 30220.6 ± 0.6% | 1607.9 ± 0.9% | 1105.8 ± 0.2% | 462.9 ± 0.4% | 806.3 ± 1.2% | 457.5 ± 0.2% | 18.796 | 27.330 | 65.286 | 37.479 | 66.059 |
| hex: http/html-1m | 524290 | 31514.1 ± 1.2% | 1552.4 ± 1.6% | 1078.6 ± 7.4% | 443.2 ± 1.5% | 777.5 ± 16.8% | 451.3 ± 0.2% | 20.300 | 29.216 | 71.100 | 40.533 | 69.837 |
| hex: http/json-1kx1024 | 2099200 | 24100.2 ± 0.9% | 1610.0 ± 0.4% | 1088.6 ± 0.3% | 566.3 ± 0.4% | 806.5 ± 0.4% | 453.3 ± 0.5% | 14.969 | 22.140 | 42.560 | 29.882 | 53.166 |
| hex: http/json-16kx64 | 2097280 | 30339.9 ± 0.6% | 1609.7 ± 0.3% | 1104.9 ± 1.7% | 581.0 ± 1.6% | 805.1 ± 0.9% | 457.2 ± 0.1% | 18.848 | 27.459 | 52.216 | 37.686 | 66.367 |
| hex: http/json-1m | 524290 | 30794.2 ± 0.7% | 1549.9 ± 2.0% | 1085.0 ± 0.8% | 585.0 ± 1.6% | 776.2 ± 0.7% | 450.5 ± 0.8% | 19.869 | 28.381 | 52.642 | 39.672 | 68.359 |
| hex: http/js-1kx1024 | 2099200 | 24081.7 ± 4.9% | 1607.2 ± 0.1% | 1087.6 ± 0.3% | 445.0 ± 8.3% | 806.0 ± 0.1% | 453.3 ± 0.4% | 14.984 | 22.142 | 54.112 | 29.877 | 53.129 |
| hex: http/js-16kx64 | 2097280 | 30185.3 ± 1.1% | 1609.1 ± 0.3% | 1102.4 ± 0.4% | 449.1 ± 9.5% | 806.8 ± 5.4% | 457.2 ± 7.3% | 18.759 | 27.383 | 67.215 | 37.415 | 66.023 |
| hex: http/js-1m | 524290 | 31141.3 ± 0.4% | 1552.9 ± 0.9% | 1086.8 ± 0.3% | 449.8 ± 0.3% | 777.8 ± 0.7% | 451.6 ± 0.4% | 20.054 | 28.654 | 69.232 | 40.037 | 68.960 |
| hex: http/css-1kx1024 | 2099200 | 24053.2 ± 0.8% | 1609.2 ± 0.3% | 1088.8 ± 1.6% | 499.4 ± 1.6% | 805.7 ± 1.9% | 452.5 ± 0.5% | 14.947 | 22.092 | 48.166 | 29.855 | 53.161 |
| hex: http/css-16kx64 | 2097280 | 30028.3 ± 2.6% | 1606.2 ± 0.3% | 1102.9 ± 0.2% | 506.7 ± 1.2% | 805.8 ± 14.1% | 457.4 ± 0.4% | 18.695 | 27.227 | 59.266 | 37.264 | 65.655 |
| hex: http/css-1m | 524290 | 30856.6 ± 0.5% | 1549.5 ± 1.3% | 1086.6 ± 1.2% | 482.1 ± 0.4% | 777.8 ± 0.6% | 450.1 ± 0.6% | 19.915 | 28.398 | 64.006 | 39.674 | 68.561 |
| hex: shuffled/dickens-1m | 524290 | 32910.9 ± 0.5% | 1551.8 ± 1.0% | 1083.9 ± 0.4% | 424.6 ± 0.3% | 779.8 ± 0.3% | 451.2 ± 0.7% | 21.208 | 30.364 | 77.502 | 42.203 | 72.934 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 835.8 ± 6.3% | 1018.4 ± 0.5% | 985.6 ± 2.6% | 262.1 ± 1.2% | 515.6 ± 16.4% | 261.1 ± 3.6% | 0.821 | 0.848 | 3.189 | 1.621 | 3.202 |
| qlog records, JSON text sequence | 1467503 | 766.7 ± 0.6% | 482.7 ± 0.3% | 775.5 ± 1.8% | 229.6 ± 0.6% | 581.8 ± 0.6% | 247.1 ± 1.4% | 1.588 | 0.989 | 3.339 | 1.318 | 3.103 |
| messages: 11 string members | 1025025 | 787.8 ± 0.5% | 1139.4 ± 0.7% | 684.2 ± 0.4% | 261.4 ± 1.7% | 449.2 ± 1.0% | 247.5 ± 0.5% | 0.691 | 1.151 | 3.014 | 1.754 | 3.183 |
| messages: 50 nested objects | 1121600 | 926.7 ± 0.7% | 1013.8 ± 1.2% | 1116.4 ± 0.7% | 282.5 ± 0.7% | 691.3 ± 0.6% | 330.3 ± 0.8% | 0.914 | 0.830 | 3.281 | 1.340 | 2.806 |
| messages: a tree of 341 objects | 612600 | 321.9 ± 3.6% | 446.8 ± 1.5% | 504.2 ± 1.6% | 123.8 ± 2.3% | 453.2 ± 0.5% | 145.7 ± 3.7% | 0.721 | 0.639 | 2.600 | 0.710 | 2.210 |
| string: silesia/dickens | 172528 | 6209.0 ± 6.0% | 2882.9 ± 0.2% | 2064.3 ± 17.5% | 292.7 ± 1.0% | 2181.6 ± 0.4% | 496.4 ± 2.5% | 2.154 | 3.008 | 21.212 | 2.846 | 12.509 |
| string: silesia/nci | 1075110 | 5101.6 ± 0.1% | 3461.8 ± 0.5% | 2836.5 ± 0.4% | 465.8 ± 3.8% | 2401.0 ± 0.3% | 527.1 ± 2.3% | 1.474 | 1.799 | 10.953 | 2.125 | 9.680 |
| string: silesia/reymont | 1075159 | 3290.2 ± 0.4% | 2187.9 ± 0.2% | 1744.3 ± 4.3% | 303.4 ± 0.9% | 1635.3 ± 0.9% | 476.7 ± 0.4% | 1.504 | 1.886 | 10.843 | 2.012 | 6.903 |
| string: silesia/samba | 97582 | 3344.4 ± 0.4% | 2877.8 ± 0.4% | 1715.7 ± 9.4% | 251.8 ± 9.8% | 1258.6 ± 0.2% | 353.9 ± 0.9% | 1.162 | 1.949 | 13.280 | 2.657 | 9.450 |
| string: silesia/webster | 1098490 | 4093.7 ± 0.5% | 2024.1 ± 0.3% | 1614.8 ± 3.0% | 291.5 ± 0.9% | 1673.6 ± 0.5% | 442.1 ± 0.9% | 2.022 | 2.535 | 14.041 | 2.446 | 9.261 |
| string: silesia/xml | 1090118 | 5478.3 ± 2.6% | 3653.4 ± 1.8% | 2121.8 ± 1.6% | 383.5 ± 1.0% | 2349.2 ± 0.3% | 504.6 ± 2.8% | 1.500 | 2.582 | 14.286 | 2.332 | 10.857 |
| string: canterbury/alice29.txt | 159425 | 4906.1 ± 0.3% | 2367.2 ± 6.5% | 1834.2 ± 1.6% | 275.0 ± 1.4% | 1937.9 ± 3.0% | 451.4 ± 2.1% | 2.072 | 2.675 | 17.838 | 2.532 | 10.868 |
| string: canterbury/asyoulik.txt | 132198 | 3739.8 ± 2.8% | 2105.2 ± 0.9% | 1477.3 ± 2.1% | 265.2 ± 0.6% | 1591.3 ± 1.3% | 403.5 ± 1.8% | 1.777 | 2.531 | 14.104 | 2.350 | 9.268 |
| string: canterbury/lcet10.txt | 441884 | 6054.8 ± 1.5% | 2784.5 ± 0.7% | 1979.1 ± 1.0% | 313.7 ± 0.5% | 2130.1 ± 6.2% | 484.7 ± 12.4% | 2.174 | 3.059 | 19.298 | 2.843 | 12.492 |
| string: canterbury/plrabn12.txt | 503330 | 4716.1 ± 0.4% | 2694.6 ± 0.2% | 1676.3 ± 0.5% | 286.8 ± 0.9% | 2007.6 ± 0.2% | 460.5 ± 1.6% | 1.750 | 2.813 | 16.443 | 2.349 | 10.241 |
| string: canterbury-large/E.coli | 1048578 | 33578.0 ± 13.5% | 7645.5 ± 3.5% | 3434.8 ± 0.6% | 873.0 ± 0.3% | 5501.7 ± 13.9% | 799.5 ± 1.6% | 4.392 | 9.776 | 38.465 | 6.103 | 41.999 |
| string: canterbury-large/bible.txt | 1055886 | 9556.1 ± 0.5% | 3906.0 ± 0.4% | 2557.3 ± 7.6% | 335.9 ± 0.1% | 2974.1 ± 1.4% | 602.2 ± 2.6% | 2.447 | 3.737 | 28.449 | 3.213 | 15.869 |
| string: canterbury-large/world192.txt | 1103121 | 3774.5 ± 0.2% | 1983.6 ± 0.8% | 1626.9 ± 1.7% | 287.4 ± 1.7% | 1676.7 ± 1.3% | 434.0 ± 0.8% | 1.903 | 2.320 | 13.133 | 2.251 | 8.697 |
| string: http/html-1m | 1058582 | 7877.8 ± 2.0% | 3400.9 ± 0.4% | 2410.9 ± 1.9% | 379.7 ± 7.8% | 2735.6 ± 1.5% | 429.1 ± 1.4% | 2.316 | 3.268 | 20.750 | 2.880 | 18.360 |
| string: http/json-1m | 1190272 | 3311.7 ± 4.4% | 1198.2 ± 1.5% | 1435.2 ± 5.8% | 336.0 ± 4.2% | 834.7 ± 11.1% | 296.9 ± 1.8% | 2.764 | 2.307 | 9.857 | 3.968 | 11.153 |
| string: http/js-1m | 1144362 | 2666.9 ± 1.5% | 1324.2 ± 0.8% | 1150.2 ± 2.8% | 265.9 ± 1.8% | 1162.2 ± 7.8% | 296.9 ± 0.7% | 2.014 | 2.319 | 10.029 | 2.295 | 8.983 |
| string: http/css-1m | 1097820 | 3042.8 ± 0.7% | 2499.8 ± 0.7% | 1544.9 ± 0.3% | 350.3 ± 0.9% | 1511.7 ± 1.7% | 338.0 ± 5.5% | 1.217 | 1.970 | 8.687 | 2.013 | 9.002 |
| string: dickens as Cyrillic and CJK | 1883069 | 5299.4 ± 0.5% | 3166.3 ± 6.7% | 652.7 ± 0.6% | 265.3 ± 11.7% | 496.5 ± 0.7% | 138.4 ± 2.5% | 1.674 | 8.120 | 19.972 | 10.673 | 38.303 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1062.8 ± 0.7% | 1077.3 ± 0.1% | 827.4 ± 1.1% | 157.1 ± 1.1% | 383.2 ± 0.8% | 201.0 ± 2.3% | 0.987 | 1.284 | 6.765 | 2.774 | 5.289 |
| hex: silesia/dickens | 524290 | 33320.1 ± 13.6% | 7616.6 ± 1.0% | 3447.2 ± 0.6% | 443.8 ± 10.3% | 5508.2 ± 0.4% | 817.2 ± 3.2% | 4.375 | 9.666 | 75.080 | 6.049 | 40.775 |
| hex: silesia/mozilla | 524290 | 33567.6 ± 0.3% | 7688.5 ± 1.8% | 3470.7 ± 0.8% | 392.6 ± 0.2% | 5527.2 ± 9.8% | 820.3 ± 2.8% | 4.366 | 9.672 | 85.492 | 6.073 | 40.922 |
| hex: silesia/mr | 524290 | 33306.1 ± 0.5% | 7637.0 ± 1.1% | 3444.8 ± 0.9% | 563.8 ± 0.1% | 5499.7 ± 0.5% | 820.1 ± 2.1% | 4.361 | 9.669 | 59.074 | 6.056 | 40.611 |
| hex: silesia/nci | 524290 | 33316.3 ± 2.0% | 7674.1 ± 1.0% | 3474.7 ± 0.8% | 633.0 ± 0.4% | 5503.9 ± 16.7% | 819.7 ± 1.9% | 4.341 | 9.588 | 52.632 | 6.053 | 40.645 |
| hex: silesia/ooffice | 524290 | 33564.7 ± 0.4% | 7646.1 ± 0.4% | 3453.0 ± 1.1% | 336.7 ± 0.2% | 5535.0 ± 1.1% | 823.5 ± 0.6% | 4.390 | 9.720 | 99.687 | 6.064 | 40.758 |
| hex: silesia/osdb | 524290 | 33295.8 ± 1.1% | 7647.7 ± 0.8% | 3436.7 ± 0.4% | 432.0 ± 3.3% | 5482.1 ± 8.7% | 817.6 ± 1.1% | 4.354 | 9.688 | 77.069 | 6.074 | 40.724 |
| hex: silesia/reymont | 524290 | 33843.1 ± 0.3% | 7680.2 ± 1.4% | 3457.3 ± 1.4% | 465.5 ± 11.7% | 5526.1 ± 0.2% | 826.9 ± 1.0% | 4.407 | 9.789 | 72.710 | 6.124 | 40.929 |
| hex: silesia/samba | 524290 | 33277.2 ± 0.1% | 7666.4 ± 0.8% | 3456.7 ± 0.6% | 342.6 ± 0.4% | 5505.8 ± 0.5% | 817.7 ± 3.5% | 4.341 | 9.627 | 97.142 | 6.044 | 40.697 |
| hex: silesia/sao | 524290 | 33551.9 ± 0.7% | 7651.1 ± 1.0% | 3442.4 ± 0.4% | 272.9 ± 0.9% | 5525.4 ± 0.8% | 824.6 ± 1.0% | 4.385 | 9.747 | 122.950 | 6.072 | 40.690 |
| hex: silesia/webster | 524290 | 33453.5 ± 0.9% | 7661.0 ± 1.2% | 3460.0 ± 0.7% | 405.5 ± 2.9% | 5522.4 ± 0.3% | 821.2 ± 1.6% | 4.367 | 9.669 | 82.493 | 6.058 | 40.735 |
| hex: silesia/x-ray | 524290 | 33419.8 ± 0.7% | 7639.8 ± 1.0% | 3462.7 ± 1.8% | 407.5 ± 8.9% | 5522.8 ± 0.4% | 819.9 ± 0.5% | 4.374 | 9.651 | 82.007 | 6.051 | 40.762 |
| hex: silesia/xml | 524290 | 33315.2 ± 0.4% | 7690.8 ± 1.0% | 3441.9 ± 2.5% | 567.1 ± 3.3% | 5506.1 ± 0.2% | 822.6 ± 2.8% | 4.332 | 9.679 | 58.746 | 6.051 | 40.500 |
| hex: canterbury/alice29.txt | 304180 | 33901.0 ± 0.1% | 7700.8 ± 0.6% | 3561.5 ± 0.9% | 444.5 ± 2.6% | 5529.6 ± 4.2% | 826.8 ± 2.3% | 4.402 | 9.519 | 76.266 | 6.131 | 41.004 |
| hex: canterbury/asyoulik.txt | 250360 | 33856.4 ± 0.5% | 7792.6 ± 0.5% | 3565.5 ± 0.8% | 435.3 ± 0.3% | 5527.6 ± 0.9% | 834.1 ± 1.5% | 4.345 | 9.496 | 77.776 | 6.125 | 40.588 |
| hex: canterbury/cp.html | 49208 | 32666.7 ± 0.3% | 7780.7 ± 0.2% | 3612.4 ± 0.5% | 430.6 ± 1.2% | 5459.0 ± 5.5% | 810.8 ± 9.4% | 4.198 | 9.043 | 75.872 | 5.984 | 40.291 |
| hex: canterbury/fields.c | 22302 | 31516.8 ± 18.4% | 7679.8 ± 0.2% | 3605.3 ± 6.8% | 459.4 ± 0.8% | 5469.5 ± 0.5% | 789.1 ± 1.2% | 4.104 | 8.742 | 68.599 | 5.762 | 39.939 |
| hex: canterbury/grammar.lsp | 7444 | 27477.8 ± 0.6% | 7465.9 ± 0.1% | 3575.2 ± 0.1% | 517.6 ± 0.7% | 5358.8 ± 11.9% | 772.6 ± 3.7% | 3.680 | 7.686 | 53.083 | 5.128 | 35.566 |
| hex: canterbury/kennedy.xls | 524290 | 33189.6 ± 0.5% | 7684.9 ± 0.6% | 3464.3 ± 1.2% | 667.6 ± 0.3% | 5502.8 ± 0.3% | 801.5 ± 9.4% | 4.319 | 9.580 | 49.716 | 6.031 | 41.412 |
| hex: canterbury/lcet10.txt | 524290 | 33485.3 ± 8.2% | 7676.3 ± 1.0% | 3456.8 ± 1.2% | 447.4 ± 0.4% | 5502.7 ± 1.1% | 825.1 ± 1.7% | 4.362 | 9.687 | 74.841 | 6.085 | 40.585 |
| hex: canterbury/plrabn12.txt | 524290 | 33338.5 ± 0.2% | 7707.8 ± 0.4% | 3443.2 ± 0.2% | 434.5 ± 0.9% | 5517.4 ± 0.3% | 818.8 ± 2.9% | 4.325 | 9.682 | 76.726 | 6.042 | 40.719 |
| hex: canterbury/ptt5 | 524290 | 33508.7 ± 1.6% | 7684.4 ± 0.5% | 3468.1 ± 0.6% | 559.5 ± 1.9% | 5518.5 ± 0.2% | 820.8 ± 0.9% | 4.361 | 9.662 | 59.891 | 6.072 | 40.823 |
| hex: canterbury/sum | 76482 | 33221.3 ± 0.9% | 7791.0 ± 0.2% | 3621.0 ± 1.9% | 498.8 ± 0.5% | 5501.7 ± 0.6% | 829.8 ± 0.7% | 4.264 | 9.175 | 66.598 | 6.038 | 40.036 |
| hex: canterbury/xargs.1 | 8456 | 28059.5 ± 2.3% | 7487.5 ± 1.1% | 3557.4 ± 1.3% | 488.1 ± 0.5% | 5356.9 ± 0.7% | 812.2 ± 2.6% | 3.748 | 7.888 | 57.488 | 5.238 | 34.547 |
| hex: canterbury-large/E.coli | 524290 | 33192.0 ± 0.3% | 7690.8 ± 3.0% | 3458.9 ± 0.6% | 710.5 ± 0.2% | 5509.1 ± 0.3% | 816.4 ± 3.1% | 4.316 | 9.596 | 46.720 | 6.025 | 40.658 |
| hex: canterbury-large/bible.txt | 524290 | 33599.7 ± 3.6% | 7659.0 ± 0.6% | 3458.1 ± 0.8% | 464.0 ± 0.4% | 5530.9 ± 3.9% | 824.0 ± 5.8% | 4.387 | 9.716 | 72.420 | 6.075 | 40.778 |
| hex: canterbury-large/world192.txt | 524290 | 33331.4 ± 1.7% | 7697.9 ± 0.5% | 3462.3 ± 0.7% | 429.7 ± 8.9% | 5503.7 ± 0.4% | 819.0 ± 1.3% | 4.330 | 9.627 | 77.577 | 6.056 | 40.698 |
| hex: http/html-1kx1024 | 2099200 | 16418.3 ± 1.1% | 6602.5 ± 0.9% | 3253.6 ± 0.6% | 454.5 ± 0.6% | 4724.0 ± 0.8% | 748.8 ± 2.3% | 2.487 | 5.046 | 36.120 | 3.476 | 21.927 |
| hex: http/html-16kx64 | 2097280 | 30283.0 ± 0.7% | 7667.6 ± 0.1% | 3517.3 ± 1.4% | 460.8 ± 4.1% | 5404.1 ± 17.7% | 799.7 ± 2.0% | 3.949 | 8.610 | 65.715 | 5.604 | 37.868 |
| hex: http/html-1m | 524290 | 33228.9 ± 0.5% | 7644.7 ± 1.2% | 3461.6 ± 0.9% | 461.5 ± 0.3% | 5513.3 ± 0.5% | 820.2 ± 2.1% | 4.347 | 9.599 | 72.005 | 6.027 | 40.514 |
| hex: http/json-1kx1024 | 2099200 | 16540.5 ± 0.5% | 6608.4 ± 1.0% | 3254.9 ± 0.1% | 574.7 ± 0.4% | 4700.7 ± 1.0% | 736.1 ± 3.1% | 2.503 | 5.082 | 28.783 | 3.519 | 22.470 |
| hex: http/json-16kx64 | 2097280 | 30391.3 ± 2.8% | 7628.3 ± 7.6% | 3506.1 ± 0.8% | 585.4 ± 0.3% | 5417.0 ± 0.8% | 805.8 ± 2.6% | 3.984 | 8.668 | 51.919 | 5.610 | 37.716 |
| hex: http/json-1m | 524290 | 33315.7 ± 0.4% | 7661.7 ± 0.7% | 3451.4 ± 1.6% | 595.9 ± 3.9% | 5500.8 ± 5.7% | 794.5 ± 5.1% | 4.348 | 9.653 | 55.908 | 6.057 | 41.931 |
| hex: http/js-1kx1024 | 2099200 | 16377.9 ± 1.0% | 6625.1 ± 0.2% | 3253.8 ± 0.2% | 444.3 ± 10.9% | 4719.1 ± 1.0% | 745.0 ± 1.0% | 2.472 | 5.033 | 36.864 | 3.471 | 21.982 |
| hex: http/js-16kx64 | 2097280 | 30652.8 ± 0.5% | 7666.9 ± 7.5% | 3518.5 ± 0.6% | 449.3 ± 0.8% | 5421.2 ± 0.2% | 810.4 ± 2.7% | 3.998 | 8.712 | 68.223 | 5.654 | 37.824 |
| hex: http/js-1m | 524290 | 33726.4 ± 0.6% | 7660.4 ± 1.5% | 3443.6 ± 7.7% | 466.7 ± 10.3% | 5529.6 ± 0.4% | 813.9 ± 3.9% | 4.403 | 9.794 | 72.271 | 6.099 | 41.438 |
| hex: http/css-1kx1024 | 2099200 | 16328.2 ± 0.9% | 6611.6 ± 0.3% | 3250.2 ± 0.4% | 498.0 ± 14.6% | 4716.6 ± 0.8% | 728.1 ± 2.4% | 2.470 | 5.024 | 32.789 | 3.462 | 22.427 |
| hex: http/css-16kx64 | 2097280 | 30326.7 ± 0.6% | 7644.7 ± 0.3% | 3514.8 ± 0.6% | 508.4 ± 0.9% | 5418.3 ± 0.4% | 788.1 ± 2.7% | 3.967 | 8.628 | 59.649 | 5.597 | 38.482 |
| hex: http/css-1m | 524290 | 33304.2 ± 1.7% | 7664.0 ± 1.1% | 3459.4 ± 0.8% | 500.7 ± 0.6% | 5511.0 ± 0.6% | 809.7 ± 1.1% | 4.346 | 9.627 | 66.516 | 6.043 | 41.132 |
| hex: shuffled/dickens-1m | 524290 | 33301.2 ± 0.3% | 7661.4 ± 1.0% | 3445.9 ± 1.7% | 445.6 ± 0.5% | 5501.8 ± 0.4% | 802.6 ± 3.5% | 4.347 | 9.664 | 74.742 | 6.053 | 41.492 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 968.6 ± 0.7% | 1018.4 ± 0.5% | 985.6 ± 2.6% | 262.1 ± 1.2% | 515.6 ± 16.4% | 261.1 ± 3.6% | 0.951 | 0.983 | 3.696 | 1.879 | 3.710 |
| qlog records, JSON text sequence | 1467503 | 819.0 ± 1.4% | 482.7 ± 0.3% | 775.5 ± 1.8% | 229.6 ± 0.6% | 581.8 ± 0.6% | 247.1 ± 1.4% | 1.697 | 1.056 | 3.567 | 1.408 | 3.315 |
| messages: 11 string members | 1025025 | 915.2 ± 0.3% | 1139.4 ± 0.7% | 684.2 ± 0.4% | 261.4 ± 1.7% | 449.2 ± 1.0% | 247.5 ± 0.5% | 0.803 | 1.338 | 3.501 | 2.037 | 3.698 |
| messages: 50 nested objects | 1121600 | 1064.0 ± 1.9% | 1013.8 ± 1.2% | 1116.4 ± 0.7% | 282.5 ± 0.7% | 691.3 ± 0.6% | 330.3 ± 0.8% | 1.050 | 0.953 | 3.767 | 1.539 | 3.222 |
| messages: a tree of 341 objects | 612600 | 402.0 ± 11.1% | 446.8 ± 1.5% | 504.2 ± 1.6% | 123.8 ± 2.3% | 453.2 ± 0.5% | 145.7 ± 3.7% | 0.900 | 0.797 | 3.247 | 0.887 | 2.760 |
| string: silesia/dickens | 172528 | 6172.2 ± 0.6% | 2882.9 ± 0.2% | 2064.3 ± 17.5% | 292.7 ± 1.0% | 2181.6 ± 0.4% | 496.4 ± 2.5% | 2.141 | 2.990 | 21.087 | 2.829 | 12.434 |
| string: silesia/nci | 1075110 | 5103.9 ± 0.3% | 3461.8 ± 0.5% | 2836.5 ± 0.4% | 465.8 ± 3.8% | 2401.0 ± 0.3% | 527.1 ± 2.3% | 1.474 | 1.799 | 10.958 | 2.126 | 9.684 |
| string: silesia/reymont | 1075159 | 3292.2 ± 0.5% | 2187.9 ± 0.2% | 1744.3 ± 4.3% | 303.4 ± 0.9% | 1635.3 ± 0.9% | 476.7 ± 0.4% | 1.505 | 1.887 | 10.849 | 2.013 | 6.907 |
| string: silesia/samba | 97582 | 3340.7 ± 0.3% | 2877.8 ± 0.4% | 1715.7 ± 9.4% | 251.8 ± 9.8% | 1258.6 ± 0.2% | 353.9 ± 0.9% | 1.161 | 1.947 | 13.265 | 2.654 | 9.439 |
| string: silesia/webster | 1098490 | 4093.1 ± 4.9% | 2024.1 ± 0.3% | 1614.8 ± 3.0% | 291.5 ± 0.9% | 1673.6 ± 0.5% | 442.1 ± 0.9% | 2.022 | 2.535 | 14.039 | 2.446 | 9.259 |
| string: silesia/xml | 1090118 | 5402.9 ± 2.7% | 3653.4 ± 1.8% | 2121.8 ± 1.6% | 383.5 ± 1.0% | 2349.2 ± 0.3% | 504.6 ± 2.8% | 1.479 | 2.546 | 14.090 | 2.300 | 10.708 |
| string: canterbury/alice29.txt | 159425 | 4900.4 ± 0.4% | 2367.2 ± 6.5% | 1834.2 ± 1.6% | 275.0 ± 1.4% | 1937.9 ± 3.0% | 451.4 ± 2.1% | 2.070 | 2.672 | 17.818 | 2.529 | 10.856 |
| string: canterbury/asyoulik.txt | 132198 | 3571.2 ± 1.5% | 2105.2 ± 0.9% | 1477.3 ± 2.1% | 265.2 ± 0.6% | 1591.3 ± 1.3% | 403.5 ± 1.8% | 1.696 | 2.417 | 13.468 | 2.244 | 8.850 |
| string: canterbury/lcet10.txt | 441884 | 6013.1 ± 3.4% | 2784.5 ± 0.7% | 1979.1 ± 1.0% | 313.7 ± 0.5% | 2130.1 ± 6.2% | 484.7 ± 12.4% | 2.160 | 3.038 | 19.166 | 2.823 | 12.407 |
| string: canterbury/plrabn12.txt | 503330 | 4717.1 ± 0.5% | 2694.6 ± 0.2% | 1676.3 ± 0.5% | 286.8 ± 0.9% | 2007.6 ± 0.2% | 460.5 ± 1.6% | 1.751 | 2.814 | 16.446 | 2.350 | 10.243 |
| string: canterbury-large/E.coli | 1048578 | 33440.6 ± 0.6% | 7645.5 ± 3.5% | 3434.8 ± 0.6% | 873.0 ± 0.3% | 5501.7 ± 13.9% | 799.5 ± 1.6% | 4.374 | 9.736 | 38.307 | 6.078 | 41.828 |
| string: canterbury-large/bible.txt | 1055886 | 9608.9 ± 4.6% | 3906.0 ± 0.4% | 2557.3 ± 7.6% | 335.9 ± 0.1% | 2974.1 ± 1.4% | 602.2 ± 2.6% | 2.460 | 3.757 | 28.607 | 3.231 | 15.957 |
| string: canterbury-large/world192.txt | 1103121 | 3769.0 ± 1.3% | 1983.6 ± 0.8% | 1626.9 ± 1.7% | 287.4 ± 1.7% | 1676.7 ± 1.3% | 434.0 ± 0.8% | 1.900 | 2.317 | 13.114 | 2.248 | 8.685 |
| string: http/html-1m | 1058582 | 7929.3 ± 0.6% | 3400.9 ± 0.4% | 2410.9 ± 1.9% | 379.7 ± 7.8% | 2735.6 ± 1.5% | 429.1 ± 1.4% | 2.332 | 3.289 | 20.885 | 2.899 | 18.480 |
| string: http/json-1m | 1190272 | 3317.2 ± 0.2% | 1198.2 ± 1.5% | 1435.2 ± 5.8% | 336.0 ± 4.2% | 834.7 ± 11.1% | 296.9 ± 1.8% | 2.768 | 2.311 | 9.874 | 3.974 | 11.171 |
| string: http/js-1m | 1144362 | 2655.6 ± 0.2% | 1324.2 ± 0.8% | 1150.2 ± 2.8% | 265.9 ± 1.8% | 1162.2 ± 7.8% | 296.9 ± 0.7% | 2.005 | 2.309 | 9.987 | 2.285 | 8.945 |
| string: http/css-1m | 1097820 | 3043.8 ± 2.2% | 2499.8 ± 0.7% | 1544.9 ± 0.3% | 350.3 ± 0.9% | 1511.7 ± 1.7% | 338.0 ± 5.5% | 1.218 | 1.970 | 8.690 | 2.013 | 9.005 |
| string: dickens as Cyrillic and CJK | 1883069 | 5303.6 ± 8.1% | 3166.3 ± 6.7% | 652.7 ± 0.6% | 265.3 ± 11.7% | 496.5 ± 0.7% | 138.4 ± 2.5% | 1.675 | 8.126 | 19.988 | 10.681 | 38.334 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1062.7 ± 10.5% | 1077.3 ± 0.1% | 827.4 ± 1.1% | 157.1 ± 1.1% | 383.2 ± 0.8% | 201.0 ± 2.3% | 0.986 | 1.284 | 6.765 | 2.773 | 5.288 |
| hex: silesia/dickens | 524290 | 33402.5 ± 0.4% | 7616.6 ± 1.0% | 3447.2 ± 0.6% | 443.8 ± 10.3% | 5508.2 ± 0.4% | 817.2 ± 3.2% | 4.385 | 9.690 | 75.266 | 6.064 | 40.876 |
| hex: silesia/mozilla | 524290 | 33511.3 ± 0.4% | 7688.5 ± 1.8% | 3470.7 ± 0.8% | 392.6 ± 0.2% | 5527.2 ± 9.8% | 820.3 ± 2.8% | 4.359 | 9.656 | 85.349 | 6.063 | 40.854 |
| hex: silesia/mr | 524290 | 33298.7 ± 1.0% | 7637.0 ± 1.1% | 3444.8 ± 0.9% | 563.8 ± 0.1% | 5499.7 ± 0.5% | 820.1 ± 2.1% | 4.360 | 9.666 | 59.061 | 6.055 | 40.602 |
| hex: silesia/nci | 524290 | 33403.8 ± 1.2% | 7674.1 ± 1.0% | 3474.7 ± 0.8% | 633.0 ± 0.4% | 5503.9 ± 16.7% | 819.7 ± 1.9% | 4.353 | 9.613 | 52.770 | 6.069 | 40.751 |
| hex: silesia/ooffice | 524290 | 33595.9 ± 0.4% | 7646.1 ± 0.4% | 3453.0 ± 1.1% | 336.7 ± 0.2% | 5535.0 ± 1.1% | 823.5 ± 0.6% | 4.394 | 9.729 | 99.780 | 6.070 | 40.796 |
| hex: silesia/osdb | 524290 | 33256.8 ± 0.7% | 7647.7 ± 0.8% | 3436.7 ± 0.4% | 432.0 ± 3.3% | 5482.1 ± 8.7% | 817.6 ± 1.1% | 4.349 | 9.677 | 76.978 | 6.066 | 40.676 |
| hex: silesia/reymont | 524290 | 33780.1 ± 0.3% | 7680.2 ± 1.4% | 3457.3 ± 1.4% | 465.5 ± 11.7% | 5526.1 ± 0.2% | 826.9 ± 1.0% | 4.398 | 9.771 | 72.574 | 6.113 | 40.853 |
| hex: silesia/samba | 524290 | 33255.8 ± 1.9% | 7666.4 ± 0.8% | 3456.7 ± 0.6% | 342.6 ± 0.4% | 5505.8 ± 0.5% | 817.7 ± 3.5% | 4.338 | 9.621 | 97.079 | 6.040 | 40.670 |
| hex: silesia/sao | 524290 | 33621.9 ± 0.3% | 7651.1 ± 1.0% | 3442.4 ± 0.4% | 272.9 ± 0.9% | 5525.4 ± 0.8% | 824.6 ± 1.0% | 4.394 | 9.767 | 123.207 | 6.085 | 40.775 |
| hex: silesia/webster | 524290 | 33272.7 ± 1.7% | 7661.0 ± 1.2% | 3460.0 ± 0.7% | 405.5 ± 2.9% | 5522.4 ± 0.3% | 821.2 ± 1.6% | 4.343 | 9.616 | 82.047 | 6.025 | 40.515 |
| hex: silesia/x-ray | 524290 | 33414.8 ± 1.1% | 7639.8 ± 1.0% | 3462.7 ± 1.8% | 407.5 ± 8.9% | 5522.8 ± 0.4% | 819.9 ± 0.5% | 4.374 | 9.650 | 81.995 | 6.050 | 40.756 |
| hex: silesia/xml | 524290 | 33359.8 ± 0.3% | 7690.8 ± 1.0% | 3441.9 ± 2.5% | 567.1 ± 3.3% | 5506.1 ± 0.2% | 822.6 ± 2.8% | 4.338 | 9.692 | 58.825 | 6.059 | 40.554 |
| hex: canterbury/alice29.txt | 304180 | 33875.8 ± 0.6% | 7700.8 ± 0.6% | 3561.5 ± 0.9% | 444.5 ± 2.6% | 5529.6 ± 4.2% | 826.8 ± 2.3% | 4.399 | 9.512 | 76.210 | 6.126 | 40.974 |
| hex: canterbury/asyoulik.txt | 250360 | 33866.8 ± 0.6% | 7792.6 ± 0.5% | 3565.5 ± 0.8% | 435.3 ± 0.3% | 5527.6 ± 0.9% | 834.1 ± 1.5% | 4.346 | 9.498 | 77.800 | 6.127 | 40.600 |
| hex: canterbury/cp.html | 49208 | 32821.8 ± 10.2% | 7780.7 ± 0.2% | 3612.4 ± 0.5% | 430.6 ± 1.2% | 5459.0 ± 5.5% | 810.8 ± 9.4% | 4.218 | 9.086 | 76.232 | 6.012 | 40.482 |
| hex: canterbury/fields.c | 22302 | 31730.1 ± 6.5% | 7679.8 ± 0.2% | 3605.3 ± 6.8% | 459.4 ± 0.8% | 5469.5 ± 0.5% | 789.1 ± 1.2% | 4.132 | 8.801 | 69.064 | 5.801 | 40.209 |
| hex: canterbury/grammar.lsp | 7444 | 27816.2 ± 12.5% | 7465.9 ± 0.1% | 3575.2 ± 0.1% | 517.6 ± 0.7% | 5358.8 ± 11.9% | 772.6 ± 3.7% | 3.726 | 7.780 | 53.737 | 5.191 | 36.004 |
| hex: canterbury/kennedy.xls | 524290 | 33153.0 ± 0.6% | 7684.9 ± 0.6% | 3464.3 ± 1.2% | 667.6 ± 0.3% | 5502.8 ± 0.3% | 801.5 ± 9.4% | 4.314 | 9.570 | 49.661 | 6.025 | 41.366 |
| hex: canterbury/lcet10.txt | 524290 | 33582.5 ± 0.3% | 7676.3 ± 1.0% | 3456.8 ± 1.2% | 447.4 ± 0.4% | 5502.7 ± 1.1% | 825.1 ± 1.7% | 4.375 | 9.715 | 75.058 | 6.103 | 40.703 |
| hex: canterbury/plrabn12.txt | 524290 | 33349.6 ± 0.4% | 7707.8 ± 0.4% | 3443.2 ± 0.2% | 434.5 ± 0.9% | 5517.4 ± 0.3% | 818.8 ± 2.9% | 4.327 | 9.686 | 76.752 | 6.045 | 40.732 |
| hex: canterbury/ptt5 | 524290 | 33516.9 ± 0.6% | 7684.4 ± 0.5% | 3468.1 ± 0.6% | 559.5 ± 1.9% | 5518.5 ± 0.2% | 820.8 ± 0.9% | 4.362 | 9.664 | 59.906 | 6.074 | 40.833 |
| hex: canterbury/sum | 76482 | 33275.7 ± 0.3% | 7791.0 ± 0.2% | 3621.0 ± 1.9% | 498.8 ± 0.5% | 5501.7 ± 0.6% | 829.8 ± 0.7% | 4.271 | 9.190 | 66.707 | 6.048 | 40.102 |
| hex: canterbury/xargs.1 | 8456 | 28349.6 ± 2.4% | 7487.5 ± 1.1% | 3557.4 ± 1.3% | 488.1 ± 0.5% | 5356.9 ± 0.7% | 812.2 ± 2.6% | 3.786 | 7.969 | 58.082 | 5.292 | 34.904 |
| hex: canterbury-large/E.coli | 524290 | 33159.2 ± 0.4% | 7690.8 ± 3.0% | 3458.9 ± 0.6% | 710.5 ± 0.2% | 5509.1 ± 0.3% | 816.4 ± 3.1% | 4.312 | 9.587 | 46.673 | 6.019 | 40.618 |
| hex: canterbury-large/bible.txt | 524290 | 33533.8 ± 12.3% | 7659.0 ± 0.6% | 3458.1 ± 0.8% | 464.0 ± 0.4% | 5530.9 ± 3.9% | 824.0 ± 5.8% | 4.378 | 9.697 | 72.278 | 6.063 | 40.698 |
| hex: canterbury-large/world192.txt | 524290 | 33232.7 ± 1.8% | 7697.9 ± 0.5% | 3462.3 ± 0.7% | 429.7 ± 8.9% | 5503.7 ± 0.4% | 819.0 ± 1.3% | 4.317 | 9.599 | 77.347 | 6.038 | 40.578 |
| hex: http/html-1kx1024 | 2099200 | 16729.4 ± 1.4% | 6602.5 ± 0.9% | 3253.6 ± 0.6% | 454.5 ± 0.6% | 4724.0 ± 0.8% | 748.8 ± 2.3% | 2.534 | 5.142 | 36.805 | 3.541 | 22.343 |
| hex: http/html-16kx64 | 2097280 | 30483.4 ± 0.3% | 7667.6 ± 0.1% | 3517.3 ± 1.4% | 460.8 ± 4.1% | 5404.1 ± 17.7% | 799.7 ± 2.0% | 3.976 | 8.667 | 66.150 | 5.641 | 38.119 |
| hex: http/html-1m | 524290 | 33228.4 ± 1.7% | 7644.7 ± 1.2% | 3461.6 ± 0.9% | 461.5 ± 0.3% | 5513.3 ± 0.5% | 820.2 ± 2.1% | 4.347 | 9.599 | 72.004 | 6.027 | 40.513 |
| hex: http/json-1kx1024 | 2099200 | 16777.1 ± 2.5% | 6608.4 ± 1.0% | 3254.9 ± 0.1% | 574.7 ± 0.4% | 4700.7 ± 1.0% | 736.1 ± 3.1% | 2.539 | 5.154 | 29.195 | 3.569 | 22.791 |
| hex: http/json-16kx64 | 2097280 | 30415.9 ± 1.0% | 7628.3 ± 7.6% | 3506.1 ± 0.8% | 585.4 ± 0.3% | 5417.0 ± 0.8% | 805.8 ± 2.6% | 3.987 | 8.675 | 51.961 | 5.615 | 37.747 |
| hex: http/json-1m | 524290 | 33328.1 ± 1.9% | 7661.7 ± 0.7% | 3451.4 ± 1.6% | 595.9 ± 3.9% | 5500.8 ± 5.7% | 794.5 ± 5.1% | 4.350 | 9.656 | 55.928 | 6.059 | 41.947 |
| hex: http/js-1kx1024 | 2099200 | 16687.9 ± 13.8% | 6625.1 ± 0.2% | 3253.8 ± 0.2% | 444.3 ± 10.9% | 4719.1 ± 1.0% | 745.0 ± 1.0% | 2.519 | 5.129 | 37.561 | 3.536 | 22.398 |
| hex: http/js-16kx64 | 2097280 | 30461.3 ± 1.2% | 7666.9 ± 7.5% | 3518.5 ± 0.6% | 449.3 ± 0.8% | 5421.2 ± 0.2% | 810.4 ± 2.7% | 3.973 | 8.658 | 67.796 | 5.619 | 37.587 |
| hex: http/js-1m | 524290 | 33620.0 ± 0.4% | 7660.4 ± 1.5% | 3443.6 ± 7.7% | 466.7 ± 10.3% | 5529.6 ± 0.4% | 813.9 ± 3.9% | 4.389 | 9.763 | 72.043 | 6.080 | 41.307 |
| hex: http/css-1kx1024 | 2099200 | 16775.0 ± 0.8% | 6611.6 ± 0.3% | 3250.2 ± 0.4% | 498.0 ± 14.6% | 4716.6 ± 0.8% | 728.1 ± 2.4% | 2.537 | 5.161 | 33.686 | 3.557 | 23.040 |
| hex: http/css-16kx64 | 2097280 | 30271.3 ± 0.6% | 7644.7 ± 0.3% | 3514.8 ± 0.6% | 508.4 ± 0.9% | 5418.3 ± 0.4% | 788.1 ± 2.7% | 3.960 | 8.613 | 59.540 | 5.587 | 38.411 |
| hex: http/css-1m | 524290 | 33368.5 ± 0.2% | 7664.0 ± 1.1% | 3459.4 ± 0.8% | 500.7 ± 0.6% | 5511.0 ± 0.6% | 809.7 ± 1.1% | 4.354 | 9.646 | 66.645 | 6.055 | 41.212 |
| hex: shuffled/dickens-1m | 524290 | 33339.9 ± 0.4% | 7661.4 ± 1.0% | 3445.9 ± 1.7% | 445.6 ± 0.5% | 5501.8 ± 0.4% | 802.6 ± 3.5% | 4.352 | 9.675 | 74.828 | 6.060 | 41.540 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1129.0 ± 0.8% | 1133.1 ± 2.7% | 895.0 ± 0.9% | 329.2 ± 1.6% | 351.5 ± 0.9% | 305.6 ± 2.9% | 0.996 | 1.261 | 3.429 | 3.212 | 3.694 |
| qlog records, JSON text sequence | 1467503 | 963.4 ± 0.3% | 872.6 ± 0.3% | 726.8 ± 1.0% | 320.4 ± 1.0% | 392.0 ± 0.7% | 230.7 ± 16.6% | 1.104 | 1.326 | 3.006 | 2.458 | 4.177 |
| messages: 11 string members | 1025025 | 1104.7 ± 5.0% | 893.8 ± 0.8% | 667.0 ± 0.8% | 315.9 ± 0.9% | 325.5 ± 1.6% | 283.6 ± 6.5% | 1.236 | 1.656 | 3.497 | 3.394 | 3.895 |
| messages: 50 nested objects | 1121600 | 1115.6 ± 0.8% | 1196.7 ± 1.3% | 999.2 ± 6.5% | 395.6 ± 5.7% | 428.6 ± 0.4% | 327.8 ± 1.4% | 0.932 | 1.117 | 2.820 | 2.603 | 3.403 |
| messages: a tree of 341 objects | 612600 | 329.3 ± 9.3% | 612.1 ± 1.2% | 405.1 ± 1.2% | 205.6 ± 2.1% | 266.0 ± 1.9% | 132.0 ± 4.6% | 0.538 | 0.813 | 1.602 | 1.238 | 2.494 |
| string: silesia/dickens | 172528 | 8584.9 ± 0.7% | 3012.6 ± 1.4% | 2013.7 ± 1.1% | 361.1 ± 0.6% | 1052.9 ± 0.3% | 560.7 ± 0.6% | 2.850 | 4.263 | 23.777 | 8.153 | 15.312 |
| string: silesia/nci | 1075110 | 8115.2 ± 1.4% | 3201.2 ± 7.1% | 2779.3 ± 2.7% | 775.7 ± 1.4% | 1095.8 ± 1.7% | 559.4 ± 0.7% | 2.535 | 2.920 | 10.462 | 7.406 | 14.507 |
| string: silesia/reymont | 1075159 | 3820.7 ± 0.2% | 1657.8 ± 0.5% | 1718.5 ± 1.4% | 371.8 ± 0.4% | 959.6 ± 0.6% | 548.0 ± 0.8% | 2.305 | 2.223 | 10.275 | 3.981 | 6.972 |
| string: silesia/samba | 97582 | 4564.6 ± 0.6% | 1943.7 ± 0.6% | 2177.5 ± 0.6% | 296.1 ± 1.2% | 912.3 ± 1.0% | 622.2 ± 11.0% | 2.348 | 2.096 | 15.416 | 5.003 | 7.336 |
| string: silesia/webster | 1098490 | 5050.0 ± 0.6% | 1637.3 ± 7.2% | 1524.3 ± 2.4% | 357.5 ± 1.7% | 940.4 ± 0.2% | 454.4 ± 0.5% | 3.084 | 3.313 | 14.126 | 5.370 | 11.115 |
| string: silesia/xml | 1090118 | 7746.8 ± 5.6% | 2673.9 ± 0.6% | 2165.4 ± 3.5% | 529.7 ± 0.9% | 1128.0 ± 0.6% | 558.1 ± 0.5% | 2.897 | 3.578 | 14.624 | 6.868 | 13.880 |
| string: canterbury/alice29.txt | 159425 | 9201.6 ± 0.9% | 2420.9 ± 2.8% | 1782.4 ± 8.1% | 339.5 ± 0.8% | 1015.7 ± 4.2% | 556.9 ± 0.4% | 3.801 | 5.163 | 27.100 | 9.059 | 16.522 |
| string: canterbury/asyoulik.txt | 132198 | 7463.2 ± 0.9% | 2181.9 ± 20.3% | 1538.9 ± 0.2% | 349.9 ± 3.8% | 906.4 ± 4.2% | 543.3 ± 0.4% | 3.421 | 4.850 | 21.330 | 8.234 | 13.738 |
| string: canterbury/lcet10.txt | 441884 | 8429.3 ± 0.6% | 2485.8 ± 4.1% | 1949.2 ± 0.5% | 395.7 ± 3.3% | 1035.4 ± 1.0% | 554.6 ± 12.5% | 3.391 | 4.324 | 21.301 | 8.141 | 15.200 |
| string: canterbury/plrabn12.txt | 503330 | 5922.3 ± 0.4% | 1849.3 ± 0.5% | 1665.8 ± 0.1% | 367.2 ± 1.1% | 1001.0 ± 1.3% | 556.4 ± 0.5% | 3.202 | 3.555 | 16.129 | 5.916 | 10.643 |
| string: canterbury-large/E.coli | 1048578 | 29246.4 ± 5.0% | 10428.7 ± 1.0% | 3380.5 ± 1.1% | 1416.6 ± 0.4% | 1420.2 ± 0.5% | 578.3 ± 0.8% | 2.804 | 8.652 | 20.645 | 20.593 | 50.573 |
| string: canterbury-large/bible.txt | 1055886 | 6976.8 ± 0.3% | 3992.8 ± 0.8% | 2648.9 ± 0.8% | 442.3 ± 0.6% | 1210.3 ± 0.5% | 564.8 ± 1.2% | 1.747 | 2.634 | 15.774 | 5.765 | 12.354 |
| string: canterbury-large/world192.txt | 1103121 | 5142.9 ± 7.1% | 1455.1 ± 9.3% | 1571.0 ± 1.6% | 361.4 ± 0.3% | 932.6 ± 0.3% | 537.1 ± 2.2% | 3.534 | 3.274 | 14.232 | 5.515 | 9.575 |
| string: http/html-1m | 1058582 | 8471.5 ± 0.4% | 3870.5 ± 1.6% | 2479.8 ± 7.0% | 445.4 ± 1.0% | 1192.3 ± 1.1% | 518.4 ± 0.7% | 2.189 | 3.416 | 19.022 | 7.105 | 16.342 |
| string: http/json-1m | 1190272 | 6314.7 ± 0.6% | 1234.4 ± 0.3% | 1271.6 ± 0.4% | 415.6 ± 0.3% | 784.6 ± 0.9% | 508.7 ± 0.5% | 5.116 | 4.966 | 15.196 | 8.048 | 12.413 |
| string: http/js-1m | 1144362 | 5073.4 ± 0.2% | 992.1 ± 8.2% | 1086.3 ± 1.1% | 308.7 ± 2.3% | 785.9 ± 0.7% | 473.1 ± 0.7% | 5.114 | 4.670 | 16.436 | 6.456 | 10.725 |
| string: http/css-1m | 1097820 | 6543.9 ± 0.8% | 1286.9 ± 1.3% | 1597.6 ± 0.3% | 443.4 ± 11.5% | 854.1 ± 1.7% | 527.9 ± 0.6% | 5.085 | 4.096 | 14.758 | 7.662 | 12.397 |
| string: dickens as Cyrillic and CJK | 1883069 | 5335.5 ± 1.2% | 3013.0 ± 0.4% | 348.0 ± 4.2% | 275.0 ± 0.2% | 400.2 ± 1.0% | 291.8 ± 0.4% | 1.771 | 15.331 | 19.401 | 13.333 | 18.285 |
| hex: silesia/dickens | 524290 | 30616.9 ± 6.4% | 1553.1 ± 0.8% | 1086.2 ± 0.8% | 423.1 ± 1.7% | 778.8 ± 1.3% | 450.8 ± 5.2% | 19.714 | 28.188 | 72.358 | 39.313 | 67.923 |
| hex: silesia/mozilla | 524290 | 34849.6 ± 3.0% | 1558.0 ± 0.7% | 1087.7 ± 1.2% | 370.9 ± 0.8% | 793.6 ± 1.1% | 451.3 ± 1.4% | 22.368 | 32.041 | 93.966 | 43.914 | 77.226 |
| hex: silesia/mr | 524290 | 34703.5 ± 2.6% | 1551.5 ± 0.8% | 1086.8 ± 0.9% | 510.6 ± 0.3% | 793.2 ± 0.7% | 450.2 ± 0.5% | 22.368 | 31.931 | 67.960 | 43.754 | 77.090 |
| hex: silesia/nci | 524290 | 35146.6 ± 0.8% | 1548.2 ± 1.2% | 1083.9 ± 0.5% | 581.6 ± 0.4% | 792.5 ± 0.7% | 452.1 ± 0.7% | 22.702 | 32.425 | 60.430 | 44.347 | 77.733 |
| hex: silesia/ooffice | 524290 | 34129.0 ± 0.7% | 1544.8 ± 0.5% | 1087.1 ± 0.4% | 327.9 ± 2.6% | 792.0 ± 1.8% | 450.7 ± 4.1% | 22.093 | 31.394 | 104.068 | 43.091 | 75.728 |
| hex: silesia/osdb | 524290 | 32351.5 ± 0.7% | 1552.2 ± 1.4% | 1087.0 ± 0.4% | 416.6 ± 0.4% | 794.1 ± 0.6% | 448.8 ± 1.8% | 20.843 | 29.764 | 77.664 | 40.738 | 72.086 |
| hex: silesia/reymont | 524290 | 33335.1 ± 0.7% | 1555.0 ± 1.0% | 1087.3 ± 0.6% | 447.6 ± 0.3% | 798.6 ± 0.2% | 451.1 ± 0.8% | 21.438 | 30.658 | 74.472 | 41.744 | 73.898 |
| hex: silesia/samba | 524290 | 35537.4 ± 1.0% | 1552.7 ± 0.4% | 1087.2 ± 9.3% | 334.5 ± 5.4% | 796.7 ± 0.6% | 450.6 ± 0.8% | 22.887 | 32.688 | 106.245 | 44.603 | 78.866 |
| hex: silesia/sao | 524290 | 34398.9 ± 0.8% | 1551.7 ± 1.6% | 1087.2 ± 0.3% | 268.5 ± 0.8% | 794.7 ± 0.3% | 450.4 ± 0.7% | 22.169 | 31.639 | 128.102 | 43.286 | 76.368 |
| hex: silesia/webster | 524290 | 35829.3 ± 2.0% | 1556.7 ± 0.6% | 1087.9 ± 0.4% | 407.9 ± 0.6% | 796.4 ± 2.0% | 450.8 ± 6.7% | 23.016 | 32.935 | 87.838 | 44.991 | 79.481 |
| hex: silesia/x-ray | 524290 | 34169.4 ± 0.4% | 1559.3 ± 1.9% | 1087.9 ± 0.2% | 384.9 ± 5.2% | 789.7 ± 0.9% | 433.2 ± 3.3% | 21.914 | 31.409 | 88.773 | 43.271 | 78.874 |
| hex: silesia/xml | 524290 | 34566.3 ± 0.7% | 1556.7 ± 1.7% | 1088.2 ± 0.6% | 583.0 ± 1.2% | 795.1 ± 33.8% | 450.6 ± 3.2% | 22.204 | 31.763 | 59.291 | 43.477 | 76.708 |
| hex: canterbury/alice29.txt | 304180 | 33422.0 ± 0.5% | 1585.3 ± 3.2% | 1095.2 ± 0.5% | 430.9 ± 0.4% | 807.2 ± 0.4% | 452.8 ± 1.3% | 21.083 | 30.517 | 77.564 | 41.403 | 73.809 |
| hex: canterbury/asyoulik.txt | 250360 | 31676.4 ± 2.9% | 1604.5 ± 9.8% | 1101.4 ± 0.2% | 423.5 ± 1.1% | 808.4 ± 0.5% | 453.8 ± 0.9% | 19.742 | 28.759 | 74.805 | 39.182 | 69.798 |
| hex: canterbury/cp.html | 49208 | 31953.6 ± 2.1% | 1619.0 ± 1.6% | 1110.2 ± 0.4% | 465.7 ± 0.3% | 814.0 ± 1.5% | 456.3 ± 0.5% | 19.737 | 28.782 | 68.611 | 39.254 | 70.020 |
| hex: canterbury/fields.c | 22302 | 32536.0 ± 0.5% | 1600.1 ± 0.6% | 1101.8 ± 0.2% | 542.6 ± 6.9% | 808.2 ± 1.7% | 454.8 ± 0.2% | 20.334 | 29.531 | 59.965 | 40.259 | 71.533 |
| hex: canterbury/grammar.lsp | 7444 | 33678.4 ± 0.2% | 1631.0 ± 4.1% | 1116.3 ± 0.7% | 563.9 ± 0.6% | 815.1 ± 1.6% | 460.2 ± 1.2% | 20.648 | 30.170 | 59.723 | 41.320 | 73.183 |
| hex: canterbury/kennedy.xls | 524290 | 30839.0 ± 0.7% | 1552.5 ± 0.9% | 1086.2 ± 0.6% | 591.7 ± 0.5% | 784.8 ± 1.5% | 451.4 ± 0.8% | 19.864 | 28.391 | 52.115 | 39.294 | 68.323 |
| hex: canterbury/lcet10.txt | 524290 | 35292.3 ± 0.2% | 1553.8 ± 5.0% | 1086.4 ± 0.6% | 430.8 ± 0.3% | 794.1 ± 16.9% | 450.5 ± 0.7% | 22.714 | 32.485 | 81.926 | 44.445 | 78.333 |
| hex: canterbury/plrabn12.txt | 524290 | 34342.2 ± 0.3% | 1555.3 ± 1.7% | 1087.4 ± 0.5% | 421.4 ± 1.2% | 797.3 ± 1.8% | 451.4 ± 0.6% | 22.080 | 31.582 | 81.504 | 43.076 | 76.086 |
| hex: canterbury/ptt5 | 524290 | 34410.2 ± 2.6% | 1550.6 ± 0.7% | 1087.5 ± 0.6% | 500.4 ± 0.3% | 795.3 ± 0.4% | 452.1 ± 0.9% | 22.191 | 31.640 | 68.772 | 43.269 | 76.105 |
| hex: canterbury/sum | 76482 | 35621.0 ± 0.7% | 1616.9 ± 0.1% | 1107.6 ± 0.8% | 520.1 ± 1.6% | 811.4 ± 0.3% | 458.4 ± 0.7% | 22.031 | 32.160 | 68.488 | 43.902 | 77.706 |
| hex: canterbury/xargs.1 | 8456 | 35721.0 ± 1.4% | 1631.1 ± 0.2% | 1112.4 ± 0.3% | 598.1 ± 0.5% | 815.7 ± 0.4% | 461.4 ± 1.0% | 21.901 | 32.111 | 59.727 | 43.789 | 77.417 |
| hex: canterbury-large/E.coli | 524290 | 30181.8 ± 2.0% | 1553.3 ± 0.5% | 1086.2 ± 1.1% | 607.9 ± 0.5% | 796.1 ± 0.9% | 452.3 ± 1.3% | 19.431 | 27.788 | 49.645 | 37.913 | 66.736 |
| hex: canterbury-large/bible.txt | 524290 | 34995.8 ± 7.7% | 1554.2 ± 1.0% | 1085.3 ± 2.3% | 441.6 ± 2.9% | 794.1 ± 0.1% | 450.3 ± 1.1% | 22.517 | 32.244 | 79.249 | 44.068 | 77.717 |
| hex: canterbury-large/world192.txt | 524290 | 33130.0 ± 0.8% | 1554.1 ± 6.1% | 1085.4 ± 0.2% | 421.4 ± 0.3% | 796.7 ± 0.7% | 451.3 ± 0.8% | 21.317 | 30.524 | 78.611 | 41.584 | 73.414 |
| hex: http/html-1kx1024 | 2099200 | 25004.8 ± 0.9% | 1606.5 ± 0.3% | 1089.6 ± 0.1% | 458.8 ± 2.9% | 807.6 ± 0.1% | 453.1 ± 0.5% | 15.565 | 22.949 | 54.506 | 30.961 | 55.192 |
| hex: http/html-16kx64 | 2097280 | 30346.7 ± 9.3% | 1607.9 ± 0.9% | 1105.8 ± 0.2% | 462.9 ± 0.4% | 806.3 ± 1.2% | 457.5 ± 0.2% | 18.874 | 27.444 | 65.558 | 37.636 | 66.335 |
| hex: http/html-1m | 524290 | 31554.8 ± 1.6% | 1552.4 ± 1.6% | 1078.6 ± 7.4% | 443.2 ± 1.5% | 777.5 ± 16.8% | 451.3 ± 0.2% | 20.326 | 29.254 | 71.192 | 40.585 | 69.927 |
| hex: http/json-1kx1024 | 2099200 | 24761.4 ± 0.8% | 1610.0 ± 0.4% | 1088.6 ± 0.3% | 566.3 ± 0.4% | 806.5 ± 0.4% | 453.3 ± 0.5% | 15.380 | 22.747 | 43.727 | 30.702 | 54.625 |
| hex: http/json-16kx64 | 2097280 | 30574.0 ± 0.5% | 1609.7 ± 0.3% | 1104.9 ± 1.7% | 581.0 ± 1.6% | 805.1 ± 0.9% | 457.2 ± 0.1% | 18.993 | 27.671 | 52.619 | 37.976 | 66.879 |
| hex: http/json-1m | 524290 | 30738.5 ± 1.9% | 1549.9 ± 2.0% | 1085.0 ± 0.8% | 585.0 ± 1.6% | 776.2 ± 0.7% | 450.5 ± 0.8% | 19.833 | 28.330 | 52.547 | 39.600 | 68.235 |
| hex: http/js-1kx1024 | 2099200 | 24955.1 ± 0.6% | 1607.2 ± 0.1% | 1087.6 ± 0.3% | 445.0 ± 8.3% | 806.0 ± 0.1% | 453.3 ± 0.4% | 15.528 | 22.945 | 56.075 | 30.961 | 55.055 |
| hex: http/js-16kx64 | 2097280 | 30272.0 ± 0.5% | 1609.1 ± 0.3% | 1102.4 ± 0.4% | 449.1 ± 9.5% | 806.8 ± 5.4% | 457.2 ± 7.3% | 18.813 | 27.461 | 67.409 | 37.523 | 66.213 |
| hex: http/js-1m | 524290 | 31170.8 ± 0.9% | 1552.9 ± 0.9% | 1086.8 ± 0.3% | 449.8 ± 0.3% | 777.8 ± 0.7% | 451.6 ± 0.4% | 20.073 | 28.681 | 69.298 | 40.075 | 69.026 |
| hex: http/css-1kx1024 | 2099200 | 24748.4 ± 0.3% | 1609.2 ± 0.3% | 1088.8 ± 1.6% | 499.4 ± 1.6% | 805.7 ± 1.9% | 452.5 ± 0.5% | 15.379 | 22.731 | 49.558 | 30.718 | 54.698 |
| hex: http/css-16kx64 | 2097280 | 30189.3 ± 0.8% | 1606.2 ± 0.3% | 1102.9 ± 0.2% | 506.7 ± 1.2% | 805.8 ± 14.1% | 457.4 ± 0.4% | 18.795 | 27.373 | 59.583 | 37.463 | 66.007 |
| hex: http/css-1m | 524290 | 30865.8 ± 0.5% | 1549.5 ± 1.3% | 1086.6 ± 1.2% | 482.1 ± 0.4% | 777.8 ± 0.6% | 450.1 ± 0.6% | 19.920 | 28.406 | 64.025 | 39.686 | 68.581 |
| hex: shuffled/dickens-1m | 524290 | 32678.5 ± 2.5% | 1551.8 ± 1.0% | 1083.9 ± 0.4% | 424.6 ± 0.3% | 779.8 ± 0.3% | 451.2 ± 0.7% | 21.058 | 30.149 | 76.955 | 41.905 | 72.419 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- messages: 11 string members, decoding: stdx runs at 0.793 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.915 of yyjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.910 of simdjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.806 of yyjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.897 of serde_json.
- messages: a tree of 341 objects, encoding: stdx runs at 0.748 of simdjson.
- messages: a tree of 341 objects, encoding with J11's loop unchecked: stdx runs at 0.800 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.821 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.848 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.691 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.914 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.830 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.721 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.639 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.710 of serde_json.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.803 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.797 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.887 of serde_json.
- messages: 50 nested objects, encoding through TextWriter's methods: stdx runs at 0.932 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.538 of simdjson.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.813 of yyjson.
