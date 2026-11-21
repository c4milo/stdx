# bench-json

| Field | Value |
|---|---|
| Commit | 8f71a68 |
| Runner label | ubuntu-26.04 |
| Image version | 20261116.202.1 |
| CPU model | AMD EPYC 7763 64-Core Processor |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1020-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/44935468830 |
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
| CLDR supplemental, 34 texts | 920675 | 1026.5 ± 0.7% | 0.462 | 0.982 | 1.053 | 1.029 | 0.412 | 1.059 | 1.060 | 0.365 | 0.814 | 0.936 | 0.096 |
| qlog records, JSON text sequence | 1467503 | 778.4 ± 9.2% | 0.790 | 1.052 | 1.086 | 1.040 | 0.411 | 1.087 | 1.051 | 0.345 | 0.956 | 1.030 | 0.116 |
| messages: 11 string members | 1025025 | 801.1 ± 2.4% | 0.631 | 0.978 | 0.977 | 0.979 | 0.535 | 1.007 | 0.982 | 0.533 | 0.976 | 1.134 | 0.119 |
| messages: 50 nested objects | 1121600 | 1017.5 ± 2.1% | 0.712 | 1.047 | 1.057 | 1.047 | 0.393 | 1.092 | 1.020 | 0.329 | 0.911 | 1.045 | 0.100 |
| messages: a tree of 341 objects | 612600 | 386.9 ± 3.9% | 0.905 | 1.143 | 1.073 | 1.081 | 0.339 | 1.065 | 1.074 | 0.272 | 0.809 | 1.051 | 0.147 |
| string: silesia/dickens | 172528 | 6283.2 ± 0.8% | 0.022 | 0.568 | 0.898 | 0.912 | 0.156 | 0.870 | 0.912 | 0.156 | 0.993 | 0.990 | 0.022 |
| string: silesia/nci | 1075110 | 5087.1 ± 0.5% | 0.027 | 0.703 | 1.036 | 1.037 | 0.235 | 1.008 | 1.039 | 0.236 | 1.001 | 1.002 | 0.027 |
| string: silesia/reymont | 1075159 | 3288.6 ± 1.5% | 0.042 | 0.581 | 0.823 | 0.826 | 0.288 | 0.819 | 0.828 | 0.290 | 1.002 | 1.004 | 0.042 |
| string: silesia/samba | 97582 | 3330.6 ± 1.8% | 0.037 | 0.886 | 1.026 | 1.029 | 0.066 | 0.841 | 1.028 | 0.066 | 1.007 | 1.007 | 0.037 |
| string: silesia/webster | 1098490 | 4091.5 ± 0.9% | 0.033 | 0.603 | 0.920 | 0.940 | 0.174 | 0.911 | 0.941 | 0.176 | 1.002 | 1.003 | 0.033 |
| string: silesia/xml | 1090118 | 5377.0 ± 0.9% | 0.026 | 0.802 | 0.957 | 0.950 | 0.207 | 0.945 | 0.949 | 0.206 | 0.998 | 1.010 | 0.026 |
| string: canterbury/alice29.txt | 159425 | 4894.2 ± 5.4% | 0.028 | 0.668 | 0.931 | 1.003 | 0.147 | 0.954 | 1.003 | 0.150 | 0.999 | 0.996 | 0.028 |
| string: canterbury/asyoulik.txt | 132198 | 3807.0 ± 0.4% | 0.035 | 0.804 | 1.067 | 1.125 | 0.163 | 1.033 | 1.126 | 0.164 | 1.000 | 1.001 | 0.035 |
| string: canterbury/lcet10.txt | 441884 | 6052.7 ± 0.9% | 0.023 | 0.539 | 0.984 | 1.005 | 0.154 | 0.968 | 1.008 | 0.154 | 1.003 | 1.002 | 0.023 |
| string: canterbury/plrabn12.txt | 503330 | 4713.8 ± 0.3% | 0.029 | 0.751 | 0.976 | 1.020 | 0.174 | 0.955 | 1.018 | 0.177 | 1.002 | 1.002 | 0.029 |
| string: canterbury-large/E.coli | 1048578 | 37209.0 ± 1.5% | 0.040 | 1.033 | 0.601 | 1.033 | 0.483 | 1.041 | 1.041 | 0.481 | 0.901 | 0.906 | 0.004 |
| string: canterbury-large/bible.txt | 1055886 | 9476.6 ± 0.7% | 0.015 | 0.480 | 0.632 | 0.629 | 0.278 | 0.688 | 0.627 | 0.280 | 1.001 | 1.007 | 0.015 |
| string: canterbury-large/world192.txt | 1103121 | 3760.3 ± 0.8% | 0.036 | 0.643 | 0.957 | 0.966 | 0.171 | 0.928 | 0.970 | 0.173 | 0.996 | 0.996 | 0.036 |
| string: http/html-1m | 1058582 | 7864.6 ± 2.5% | 0.018 | 0.545 | 0.750 | 0.750 | 0.288 | 0.780 | 0.753 | 0.289 | 1.005 | 1.014 | 0.018 |
| string: http/json-1m | 1190272 | 3306.2 ± 0.8% | 0.038 | 0.384 | 0.438 | 0.438 | 0.094 | 0.393 | 0.438 | 0.094 | 1.004 | 1.005 | 0.038 |
| string: http/js-1m | 1144362 | 2650.0 ± 0.9% | 0.049 | 0.659 | 0.872 | 0.912 | 0.149 | 0.864 | 0.897 | 0.149 | 1.002 | 1.003 | 0.049 |
| string: http/css-1m | 1097820 | 3020.8 ± 0.5% | 0.044 | 0.728 | 1.008 | 1.058 | 0.217 | 1.008 | 1.024 | 0.218 | 1.002 | 1.001 | 0.044 |
| string: dickens as Cyrillic and CJK | 1883069 | 5321.2 ± 0.4% | 0.020 | 0.056 | 0.485 | 0.486 | 0.174 | 0.483 | 0.486 | 0.176 | 1.003 | 1.003 | 0.020 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1057.6 ± 0.8% | 0.093 | 0.977 | 0.978 | 0.978 | 0.089 | 0.711 | 0.975 | 0.088 | 1.000 | 0.995 | 0.092 |
| hex: silesia/dickens | 524290 | 36976.1 ± 5.8% | 0.040 | 1.033 | 0.592 | 1.030 | 0.486 | 1.043 | 1.039 | 0.486 | 0.899 | 0.901 | 0.004 |
| hex: silesia/mozilla | 524290 | 35779.4 ± 1.6% | 0.042 | 1.027 | 0.622 | 1.032 | 0.500 | 1.038 | 1.038 | 0.498 | 0.945 | 0.945 | 0.004 |
| hex: silesia/mr | 524290 | 36912.2 ± 1.2% | 0.040 | 1.032 | 0.604 | 1.029 | 0.481 | 1.036 | 1.035 | 0.481 | 0.914 | 0.916 | 0.004 |
| hex: silesia/nci | 524290 | 36543.2 ± 1.3% | 0.040 | 1.025 | 0.605 | 1.030 | 0.486 | 1.037 | 1.038 | 0.484 | 0.912 | 0.914 | 0.004 |
| hex: silesia/ooffice | 524290 | 35619.1 ± 0.4% | 0.042 | 1.029 | 0.627 | 1.031 | 0.500 | 1.037 | 1.037 | 0.497 | 0.939 | 0.937 | 0.004 |
| hex: silesia/osdb | 524290 | 36955.1 ± 19.0% | 0.040 | 1.027 | 0.594 | 1.027 | 0.490 | 1.036 | 1.036 | 0.489 | 0.915 | 0.912 | 0.004 |
| hex: silesia/reymont | 524290 | 36889.8 ± 3.2% | 0.040 | 1.044 | 0.600 | 1.050 | 0.492 | 1.051 | 1.052 | 0.491 | 0.910 | 0.911 | 0.004 |
| hex: silesia/samba | 524290 | 26209.7 ± 1.9% | 0.056 | 1.030 | 0.738 | 1.031 | 0.646 | 1.029 | 1.032 | 0.645 | 1.274 | 1.273 | 0.006 |
| hex: silesia/sao | 524290 | 37190.4 ± 0.7% | 0.041 | 1.027 | 0.599 | 1.026 | 0.490 | 1.035 | 1.040 | 0.484 | 0.907 | 0.907 | 0.004 |
| hex: silesia/webster | 524290 | 36940.6 ± 2.1% | 0.040 | 1.040 | 0.593 | 1.027 | 0.490 | 1.048 | 1.047 | 0.483 | 0.906 | 0.907 | 0.004 |
| hex: silesia/x-ray | 524290 | 35455.4 ± 1.8% | 0.041 | 1.031 | 0.627 | 1.035 | 0.498 | 1.040 | 1.036 | 0.497 | 0.943 | 0.941 | 0.004 |
| hex: silesia/xml | 524290 | 36653.4 ± 1.1% | 0.039 | 1.051 | 0.607 | 1.047 | 0.488 | 1.057 | 1.058 | 0.489 | 0.911 | 0.907 | 0.004 |
| hex: canterbury/alice29.txt | 304180 | 36960.1 ± 1.2% | 0.040 | 1.021 | 0.600 | 1.021 | 0.476 | 1.032 | 1.037 | 0.478 | 0.913 | 0.916 | 0.004 |
| hex: canterbury/asyoulik.txt | 250360 | 35400.4 ± 3.4% | 0.041 | 1.048 | 0.616 | 1.044 | 0.513 | 1.062 | 1.055 | 0.512 | 0.949 | 0.947 | 0.004 |
| hex: canterbury/cp.html | 49208 | 37025.5 ± 2.3% | 0.038 | 1.012 | 0.597 | 1.007 | 0.490 | 0.995 | 1.009 | 0.496 | 0.885 | 0.888 | 0.004 |
| hex: canterbury/fields.c | 22302 | 37743.8 ± 0.8% | 0.037 | 1.017 | 0.564 | 1.012 | 0.466 | 1.019 | 1.019 | 0.476 | 0.838 | 0.842 | 0.004 |
| hex: canterbury/grammar.lsp | 7444 | 34996.1 ± 4.7% | 0.041 | 1.059 | 0.555 | 1.049 | 0.443 | 1.053 | 1.043 | 0.476 | 0.785 | 0.794 | 0.004 |
| hex: canterbury/kennedy.xls | 524290 | 36939.6 ± 2.4% | 0.040 | 1.060 | 0.599 | 1.040 | 0.492 | 1.065 | 1.062 | 0.490 | 0.910 | 0.904 | 0.004 |
| hex: canterbury/lcet10.txt | 524290 | 37744.0 ± 1.5% | 0.039 | 1.028 | 0.589 | 1.030 | 0.477 | 1.037 | 1.035 | 0.476 | 0.892 | 0.891 | 0.004 |
| hex: canterbury/plrabn12.txt | 524290 | 36437.1 ± 3.3% | 0.040 | 1.052 | 0.613 | 1.051 | 0.494 | 1.063 | 1.062 | 0.483 | 0.917 | 0.926 | 0.004 |
| hex: canterbury/ptt5 | 524290 | 36476.5 ± 3.0% | 0.040 | 1.030 | 0.595 | 1.030 | 0.496 | 1.041 | 1.038 | 0.495 | 0.918 | 0.920 | 0.004 |
| hex: canterbury/sum | 76482 | 40015.7 ± 0.4% | 0.036 | 1.002 | 0.555 | 1.007 | 0.454 | 1.008 | 1.007 | 0.457 | 0.831 | 0.833 | 0.004 |
| hex: canterbury/xargs.1 | 8456 | 37590.3 ± 1.5% | 0.040 | 1.022 | 0.524 | 1.026 | 0.426 | 1.005 | 1.030 | 0.452 | 0.747 | 0.754 | 0.004 |
| hex: canterbury-large/E.coli | 524290 | 37243.2 ± 5.6% | 0.041 | 1.029 | 0.595 | 1.030 | 0.483 | 1.037 | 1.035 | 0.480 | 0.892 | 0.905 | 0.004 |
| hex: canterbury-large/bible.txt | 524290 | 37564.9 ± 1.9% | 0.040 | 1.032 | 0.591 | 1.026 | 0.483 | 1.039 | 1.036 | 0.481 | 0.886 | 0.886 | 0.004 |
| hex: canterbury-large/world192.txt | 524290 | 37052.2 ± 2.5% | 0.040 | 1.027 | 0.600 | 1.034 | 0.490 | 1.042 | 1.034 | 0.486 | 0.901 | 0.902 | 0.004 |
| hex: http/html-1kx1024 | 2099200 | 16774.0 ± 2.5% | 0.087 | 1.028 | 0.799 | 1.042 | 0.607 | 1.038 | 1.042 | 0.693 | 1.005 | 1.020 | 0.009 |
| hex: http/html-16kx64 | 2097280 | 34733.0 ± 2.1% | 0.044 | 1.021 | 0.606 | 1.028 | 0.497 | 1.026 | 1.029 | 0.503 | 0.890 | 0.890 | 0.004 |
| hex: http/html-1m | 524290 | 37528.5 ± 3.3% | 0.041 | 1.040 | 0.594 | 1.037 | 0.483 | 1.046 | 1.043 | 0.482 | 0.897 | 0.897 | 0.004 |
| hex: http/json-1kx1024 | 2099200 | 16335.2 ± 2.1% | 0.090 | 1.050 | 0.811 | 1.066 | 0.624 | 1.056 | 1.064 | 0.705 | 1.037 | 1.049 | 0.009 |
| hex: http/json-16kx64 | 2097280 | 34654.5 ± 2.5% | 0.044 | 1.022 | 0.605 | 1.008 | 0.499 | 1.029 | 1.035 | 0.502 | 0.888 | 0.890 | 0.004 |
| hex: http/json-1m | 524290 | 37669.0 ± 7.5% | 0.040 | 1.032 | 0.590 | 1.033 | 0.479 | 1.042 | 1.033 | 0.478 | 0.894 | 0.894 | 0.004 |
| hex: http/js-1kx1024 | 2099200 | 16655.5 ± 4.5% | 0.088 | 1.044 | 0.801 | 1.051 | 0.615 | 1.040 | 1.049 | 0.697 | 1.015 | 1.029 | 0.009 |
| hex: http/js-16kx64 | 2097280 | 34613.2 ± 4.0% | 0.044 | 1.018 | 0.604 | 1.022 | 0.498 | 1.024 | 1.029 | 0.498 | 0.890 | 0.891 | 0.004 |
| hex: http/js-1m | 524290 | 36793.5 ± 4.8% | 0.041 | 1.039 | 0.600 | 1.039 | 0.487 | 1.042 | 1.044 | 0.485 | 0.903 | 0.903 | 0.004 |
| hex: http/css-1kx1024 | 2099200 | 16638.4 ± 2.3% | 0.089 | 1.041 | 0.804 | 1.052 | 0.614 | 1.045 | 1.058 | 0.696 | 1.016 | 1.030 | 0.009 |
| hex: http/css-16kx64 | 2097280 | 34995.1 ± 1.1% | 0.043 | 1.017 | 0.601 | 1.021 | 0.500 | 1.019 | 1.025 | 0.500 | 0.882 | 0.883 | 0.004 |
| hex: http/css-1m | 524290 | 37164.9 ± 1.5% | 0.041 | 1.035 | 0.597 | 1.029 | 0.489 | 1.036 | 1.039 | 0.488 | 0.902 | 0.905 | 0.004 |
| hex: shuffled/dickens-1m | 524290 | 36894.0 ± 1.0% | 0.041 | 1.027 | 0.599 | 1.026 | 0.489 | 1.034 | 1.032 | 0.486 | 0.905 | 0.905 | 0.004 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1344.8 ± 3.7% | 0.438 | 0.966 | 0.977 | 0.997 | 0.998 | 0.233 | 0.996 | 0.444 | 0.842 | 0.085 | 1.017 |
| qlog records, JSON text sequence | 1467503 | 1141.3 ± 0.8% | 0.706 | 0.951 | 0.983 | 0.977 | 0.978 | 0.229 | 0.984 | 0.420 | 0.829 | 0.106 | 1.014 |
| messages: 11 string members | 1025025 | 981.7 ± 8.8% | 0.594 | 1.034 | 1.056 | 1.042 | 1.065 | 0.316 | 1.049 | 0.574 | 1.069 | 0.111 | 1.021 |
| messages: 50 nested objects | 1121600 | 1320.7 ± 3.9% | 0.627 | 0.971 | 0.979 | 0.966 | 0.967 | 0.224 | 0.974 | 0.403 | 0.855 | 0.092 | 1.005 |
| messages: a tree of 341 objects | 612600 | 428.2 ± 10.3% | 0.925 | 0.984 | 1.001 | 1.001 | 1.029 | 0.201 | 1.048 | 0.362 | 0.948 | 0.167 | 1.063 |
| string: silesia/dickens | 172528 | 9157.5 ± 1.0% | 0.017 | 0.584 | 0.420 | 0.599 | 0.585 | 0.119 | 0.586 | 1.004 | 1.005 | 0.017 | 1.040 |
| string: silesia/nci | 1075110 | 8705.4 ± 4.8% | 0.018 | 0.594 | 0.400 | 0.592 | 0.594 | 0.166 | 0.594 | 1.003 | 1.004 | 0.018 | 1.032 |
| string: silesia/reymont | 1075159 | 3837.1 ± 1.3% | 0.041 | 0.675 | 0.512 | 0.668 | 0.677 | 0.279 | 0.676 | 1.002 | 1.003 | 0.041 | 0.996 |
| string: silesia/samba | 97582 | 4657.9 ± 7.9% | 0.043 | 0.930 | 0.792 | 0.933 | 0.930 | 0.112 | 0.931 | 0.998 | 0.997 | 0.043 | 1.117 |
| string: silesia/webster | 1098490 | 5092.0 ± 1.4% | 0.030 | 0.700 | 0.495 | 0.704 | 0.700 | 0.155 | 0.699 | 1.001 | 1.002 | 0.030 | 0.999 |
| string: silesia/xml | 1090118 | 7845.7 ± 0.7% | 0.020 | 0.634 | 0.565 | 0.646 | 0.635 | 0.199 | 0.635 | 0.998 | 1.020 | 0.020 | 1.050 |
| string: canterbury/alice29.txt | 159425 | 9898.3 ± 2.1% | 0.016 | 0.510 | 0.388 | 0.507 | 0.513 | 0.083 | 0.521 | 1.002 | 1.000 | 0.016 | 1.012 |
| string: canterbury/asyoulik.txt | 132198 | 7970.8 ± 0.8% | 0.019 | 0.509 | 0.399 | 0.504 | 0.513 | 0.087 | 0.517 | 1.006 | 1.007 | 0.019 | 1.047 |
| string: canterbury/lcet10.txt | 441884 | 8853.2 ± 0.7% | 0.018 | 0.603 | 0.387 | 0.614 | 0.604 | 0.118 | 0.604 | 1.002 | 1.007 | 0.018 | 1.030 |
| string: canterbury/plrabn12.txt | 503330 | 6065.7 ± 0.1% | 0.026 | 0.764 | 0.581 | 0.756 | 0.766 | 0.156 | 0.765 | 0.999 | 1.001 | 0.025 | 1.048 |
| string: canterbury-large/E.coli | 1048578 | 37440.2 ± 4.6% | 0.040 | 1.021 | 1.037 | 0.595 | 1.038 | 0.481 | 1.040 | 1.028 | 1.033 | 0.004 | 1.037 |
| string: canterbury-large/bible.txt | 1055886 | 7038.0 ± 0.3% | 0.023 | 0.793 | 0.657 | 0.821 | 0.793 | 0.410 | 0.792 | 1.001 | 1.001 | 0.023 | 1.053 |
| string: canterbury-large/world192.txt | 1103121 | 4908.7 ± 6.5% | 0.031 | 0.672 | 0.518 | 0.671 | 0.673 | 0.145 | 0.673 | 1.030 | 0.995 | 0.031 | 0.981 |
| string: http/html-1m | 1058582 | 8463.3 ± 1.1% | 0.019 | 0.626 | 0.522 | 0.657 | 0.628 | 0.293 | 0.624 | 1.000 | 1.010 | 0.019 | 1.018 |
| string: http/json-1m | 1190272 | 6682.0 ± 1.4% | 0.022 | 0.214 | 0.187 | 0.217 | 0.214 | 0.061 | 0.214 | 1.000 | 1.002 | 0.022 | 1.018 |
| string: http/js-1m | 1144362 | 5050.0 ± 2.7% | 0.029 | 0.446 | 0.357 | 0.447 | 0.447 | 0.086 | 0.446 | 1.008 | 1.020 | 0.029 | 1.007 |
| string: http/css-1m | 1097820 | 6886.5 ± 3.9% | 0.022 | 0.502 | 0.346 | 0.506 | 0.505 | 0.114 | 0.486 | 1.001 | 1.006 | 0.022 | 1.059 |
| string: dickens as Cyrillic and CJK | 1883069 | 5339.7 ± 2.2% | 0.024 | 0.463 | 0.056 | 0.470 | 0.466 | 0.176 | 0.465 | 1.003 | 1.004 | 0.024 | 0.973 |
| hex: silesia/dickens | 524290 | 30893.2 ± 2.8% | 1.006 | 0.082 | 1.005 | 0.619 | 1.009 | 1.009 | 1.009 | 1.007 | 1.008 | 0.083 | 1.008 |
| hex: silesia/mozilla | 524290 | 34592.6 ± 1.7% | 1.011 | 0.073 | 1.014 | 0.586 | 1.015 | 1.013 | 1.018 | 1.014 | 1.018 | 0.074 | 1.018 |
| hex: silesia/mr | 524290 | 34692.0 ± 1.0% | 1.003 | 0.073 | 1.004 | 0.579 | 1.006 | 1.003 | 1.007 | 1.000 | 1.005 | 0.074 | 1.006 |
| hex: silesia/nci | 524290 | 35007.9 ± 2.4% | 1.008 | 0.072 | 1.007 | 0.579 | 1.006 | 1.005 | 1.009 | 1.006 | 1.008 | 0.073 | 1.011 |
| hex: silesia/ooffice | 524290 | 32632.9 ± 20.9% | 1.036 | 0.078 | 1.038 | 0.618 | 1.033 | 1.033 | 1.030 | 1.026 | 1.031 | 0.078 | 1.038 |
| hex: silesia/osdb | 524290 | 32456.0 ± 0.5% | 1.013 | 0.078 | 1.015 | 0.622 | 1.013 | 1.011 | 1.014 | 1.013 | 1.013 | 0.079 | 1.016 |
| hex: silesia/reymont | 524290 | 33492.9 ± 2.3% | 1.009 | 0.076 | 1.010 | 0.602 | 1.009 | 1.007 | 1.011 | 1.006 | 1.010 | 0.076 | 1.011 |
| hex: silesia/samba | 524290 | 35345.5 ± 3.5% | 1.010 | 0.072 | 1.013 | 0.570 | 1.012 | 1.009 | 1.013 | 1.010 | 1.002 | 0.070 | 1.017 |
| hex: silesia/sao | 524290 | 33891.5 ± 3.2% | 1.005 | 0.075 | 1.013 | 0.590 | 1.004 | 1.003 | 1.006 | 1.003 | 1.008 | 0.074 | 1.003 |
| hex: silesia/webster | 524290 | 35626.6 ± 16.5% | 1.009 | 0.071 | 1.012 | 0.570 | 1.013 | 1.008 | 1.014 | 1.012 | 1.014 | 0.072 | 1.010 |
| hex: silesia/x-ray | 524290 | 33577.0 ± 0.6% | 1.014 | 0.076 | 1.013 | 0.600 | 1.018 | 1.014 | 1.016 | 1.014 | 1.014 | 0.076 | 1.013 |
| hex: silesia/xml | 524290 | 34752.4 ± 0.5% | 1.011 | 0.073 | 1.006 | 0.581 | 1.008 | 1.008 | 1.009 | 1.004 | 1.011 | 0.073 | 1.012 |
| hex: canterbury/alice29.txt | 304180 | 33762.6 ± 0.5% | 1.006 | 0.075 | 1.000 | 0.576 | 1.008 | 1.004 | 1.010 | 1.003 | 1.007 | 0.074 | 1.007 |
| hex: canterbury/asyoulik.txt | 250360 | 31377.5 ± 4.3% | 1.003 | 0.081 | 1.003 | 0.630 | 1.007 | 1.004 | 1.006 | 1.003 | 1.002 | 0.081 | 1.001 |
| hex: canterbury/cp.html | 49208 | 31593.3 ± 11.6% | 1.004 | 0.080 | 0.998 | 0.614 | 1.002 | 1.003 | 1.003 | 1.006 | 1.008 | 0.080 | 1.005 |
| hex: canterbury/fields.c | 22302 | 32853.5 ± 0.6% | 0.999 | 0.077 | 0.991 | 0.582 | 0.995 | 0.983 | 0.992 | 0.997 | 1.010 | 0.077 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 32433.3 ± 1.3% | 0.998 | 0.078 | 0.999 | 0.567 | 0.999 | 0.953 | 1.000 | 1.000 | 1.031 | 0.077 | 1.016 |
| hex: canterbury/kennedy.xls | 524290 | 31076.8 ± 1.1% | 1.003 | 0.082 | 1.006 | 0.626 | 1.006 | 1.006 | 1.008 | 1.003 | 1.007 | 0.082 | 1.008 |
| hex: canterbury/lcet10.txt | 524290 | 35289.9 ± 1.1% | 1.009 | 0.072 | 1.009 | 0.574 | 1.008 | 1.008 | 1.007 | 1.006 | 1.010 | 0.072 | 1.011 |
| hex: canterbury/plrabn12.txt | 524290 | 34191.3 ± 1.1% | 1.005 | 0.074 | 1.005 | 0.583 | 1.006 | 1.006 | 1.008 | 1.002 | 1.010 | 0.074 | 1.008 |
| hex: canterbury/ptt5 | 524290 | 34075.2 ± 2.5% | 1.013 | 0.074 | 1.014 | 0.589 | 1.008 | 1.014 | 1.014 | 1.010 | 1.018 | 0.074 | 1.019 |
| hex: canterbury/sum | 76482 | 35287.9 ± 0.7% | 1.005 | 0.071 | 1.006 | 0.573 | 1.005 | 1.004 | 1.005 | 1.004 | 1.011 | 0.066 | 1.010 |
| hex: canterbury/xargs.1 | 8456 | 34610.7 ± 2.6% | 0.994 | 0.071 | 0.994 | 0.545 | 0.997 | 0.948 | 0.996 | 0.998 | 1.028 | 0.065 | 1.008 |
| hex: canterbury-large/E.coli | 524290 | 30535.1 ± 4.2% | 1.004 | 0.083 | 1.003 | 0.616 | 1.000 | 1.002 | 1.006 | 1.002 | 1.006 | 0.083 | 1.007 |
| hex: canterbury-large/bible.txt | 524290 | 35114.4 ± 0.3% | 1.010 | 0.072 | 1.010 | 0.578 | 1.006 | 1.008 | 1.007 | 1.006 | 1.010 | 0.073 | 1.011 |
| hex: canterbury-large/world192.txt | 524290 | 33037.6 ± 7.3% | 1.016 | 0.077 | 1.015 | 0.606 | 1.017 | 1.012 | 1.011 | 1.011 | 1.015 | 0.074 | 1.013 |
| hex: http/html-1kx1024 | 2099200 | 23102.8 ± 1.5% | 1.007 | 0.106 | 0.993 | 0.688 | 1.007 | 0.898 | 1.007 | 1.011 | 1.066 | 0.103 | 1.040 |
| hex: http/html-16kx64 | 2097280 | 29042.0 ± 7.6% | 1.031 | 0.087 | 1.033 | 0.665 | 1.033 | 1.017 | 1.036 | 1.032 | 1.037 | 0.087 | 1.040 |
| hex: http/html-1m | 524290 | 31354.7 ± 1.6% | 1.004 | 0.081 | 1.005 | 0.633 | 1.003 | 1.002 | 1.002 | 1.000 | 1.004 | 0.081 | 1.002 |
| hex: http/json-1kx1024 | 2099200 | 23025.3 ± 2.6% | 1.009 | 0.106 | 0.991 | 0.690 | 0.998 | 0.897 | 0.998 | 1.005 | 1.068 | 0.103 | 1.044 |
| hex: http/json-16kx64 | 2097280 | 29738.7 ± 2.2% | 1.017 | 0.085 | 1.013 | 0.646 | 1.016 | 1.000 | 1.016 | 1.016 | 1.023 | 0.085 | 1.022 |
| hex: http/json-1m | 524290 | 30983.6 ± 0.6% | 0.995 | 0.082 | 1.008 | 0.643 | 1.010 | 1.007 | 1.006 | 1.007 | 1.012 | 0.082 | 1.010 |
| hex: http/js-1kx1024 | 2099200 | 23281.6 ± 0.6% | 1.008 | 0.105 | 0.989 | 0.683 | 1.003 | 0.895 | 1.003 | 1.002 | 1.065 | 0.102 | 1.035 |
| hex: http/js-16kx64 | 2097280 | 29513.6 ± 14.5% | 1.013 | 0.086 | 1.011 | 0.654 | 1.013 | 0.998 | 1.014 | 1.012 | 1.018 | 0.086 | 1.018 |
| hex: http/js-1m | 524290 | 31734.5 ± 1.4% | 1.003 | 0.080 | 1.004 | 0.623 | 1.001 | 1.002 | 1.005 | 1.005 | 1.008 | 0.080 | 1.007 |
| hex: http/css-1kx1024 | 2099200 | 23069.0 ± 0.7% | 1.005 | 0.106 | 0.995 | 0.690 | 1.005 | 0.895 | 1.004 | 1.009 | 1.066 | 0.103 | 1.041 |
| hex: http/css-16kx64 | 2097280 | 29380.1 ± 2.1% | 1.022 | 0.086 | 1.023 | 0.660 | 1.037 | 1.020 | 1.035 | 1.033 | 1.041 | 0.086 | 1.041 |
| hex: http/css-1m | 524290 | 30763.2 ± 1.4% | 1.006 | 0.082 | 1.007 | 0.645 | 1.008 | 1.005 | 1.009 | 1.007 | 1.006 | 0.083 | 1.009 |
| hex: shuffled/dickens-1m | 524290 | 32847.9 ± 1.2% | 1.007 | 0.077 | 1.008 | 0.614 | 1.009 | 1.005 | 1.007 | 1.007 | 1.007 | 0.078 | 1.007 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding: J7 wide vectors off runs at 1.053 of all on.
- CLDR supplemental, 34 texts, decoding: J12 decoder escape words off runs at 1.059 of all on.
- CLDR supplemental, 34 texts, decoding: J13 decoder escape blocks off runs at 1.060 of all on.
- messages: 50 nested objects, decoding: J12 decoder escape words off runs at 1.092 of all on.
- messages: a tree of 341 objects, decoding: J8 decoder fast path off runs at 1.081 of all on.
- messages: a tree of 341 objects, decoding: J12 decoder escape words off runs at 1.065 of all on.
- messages: a tree of 341 objects, decoding: J13 decoder escape blocks off runs at 1.074 of all on.
- string: canterbury/asyoulik.txt, decoding: J7 wide vectors off runs at 1.067 of all on.
- string: canterbury/asyoulik.txt, decoding: J8 decoder fast path off runs at 1.125 of all on.
- string: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.126 of all on.
- hex: silesia/reymont, decoding: J12 decoder escape words off runs at 1.051 of all on.
- hex: silesia/reymont, decoding: J13 decoder escape blocks off runs at 1.052 of all on.
- hex: silesia/xml, decoding: J5 UTF-8 vectors off runs at 1.051 of all on.
- hex: silesia/xml, decoding: J12 decoder escape words off runs at 1.057 of all on.
- hex: silesia/xml, decoding: J13 decoder escape blocks off runs at 1.058 of all on.
- hex: canterbury/asyoulik.txt, decoding: J12 decoder escape words off runs at 1.062 of all on.
- hex: canterbury/asyoulik.txt, decoding: J13 decoder escape blocks off runs at 1.055 of all on.
- hex: canterbury/grammar.lsp, decoding: J5 UTF-8 vectors off runs at 1.059 of all on.
- hex: canterbury/grammar.lsp, decoding: J12 decoder escape words off runs at 1.053 of all on.
- hex: canterbury/kennedy.xls, decoding: J5 UTF-8 vectors off runs at 1.060 of all on.
- hex: canterbury/kennedy.xls, decoding: J12 decoder escape words off runs at 1.065 of all on.
- hex: canterbury/kennedy.xls, decoding: J13 decoder escape blocks off runs at 1.062 of all on.
- hex: canterbury/plrabn12.txt, decoding: J5 UTF-8 vectors off runs at 1.052 of all on.
- hex: canterbury/plrabn12.txt, decoding: J8 decoder fast path off runs at 1.051 of all on.
- hex: canterbury/plrabn12.txt, decoding: J12 decoder escape words off runs at 1.063 of all on.
- hex: canterbury/plrabn12.txt, decoding: J13 decoder escape blocks off runs at 1.062 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.050 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.066 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.056 of all on.
- hex: http/json-1kx1024, decoding: J13 decoder escape blocks off runs at 1.064 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.051 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.052 of all on.
- hex: http/css-1kx1024, decoding: J13 decoder escape blocks off runs at 1.058 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 90540.5 ± 1.4% | 83178.8 ± 0.7% | 1.089 | — | — |
| string: silesia/nci | 1048576 | 73192.3 ± 5.1% | 71999.7 ± 0.7% | 1.017 | — | — |
| string: silesia/reymont | 1048576 | 72554.9 ± 0.4% | 71860.1 ± 2.7% | 1.010 | — | — |
| string: silesia/samba | 65546 | 98502.0 ± 0.8% | 90567.0 ± 0.7% | 1.088 | — | — |
| string: silesia/webster | 1048576 | 73692.1 ± 12.7% | 75134.3 ± 1.7% | 0.981 | — | — |
| string: silesia/xml | 1048576 | 73222.2 ± 0.8% | 72198.1 ± 1.1% | 1.014 | — | — |
| string: canterbury/alice29.txt | 152089 | 100268.6 ± 1.9% | 91514.4 ± 0.2% | 1.096 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 99575.4 ± 6.4% | 91757.8 ± 0.1% | 1.085 | — | — |
| string: canterbury/lcet10.txt | 426754 | 83410.1 ± 3.5% | 80121.8 ± 3.0% | 1.041 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 85734.7 ± 1.1% | 81264.9 ± 1.1% | 1.055 | — | — |
| string: canterbury-large/E.coli | 1048576 | 72718.0 ± 10.1% | 71569.7 ± 0.2% | 1.016 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 72828.3 ± 0.2% | 72024.9 ± 0.7% | 1.011 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 73216.0 ± 1.2% | 72047.2 ± 0.4% | 1.016 | — | — |
| string: http/html-1m | 1048576 | 67802.0 ± 0.2% | 67199.9 ± 0.8% | 1.009 | — | — |
| string: http/json-1m | 1048576 | 60976.1 ± 1.8% | 65277.9 ± 0.6% | 0.934 | — | — |
| string: http/js-1m | 1048576 | 72127.7 ± 0.4% | 71142.8 ± 0.3% | 1.014 | — | — |
| string: http/css-1m | 1048576 | 72545.3 ± 0.9% | 71656.3 ± 0.3% | 1.012 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 14638.8 ± 0.6% | 15334.2 ± 8.2% | 0.955 | — | — |

## Losses to simdutf

- string: http/json-1m: stdx runs at 0.934 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 73692.6 ± 11.9% | 75250.4 ± 0.7% | 0.979 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 73183.3 ± 2.7% | 71554.2 ± 0.4% | 1.023 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 73173.0 ± 0.5% | 71586.3 ± 0.8% | 1.022 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 72961.6 ± 1.1% | 71667.9 ± 3.1% | 1.018 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 73194.5 ± 0.9% | 75173.7 ± 1.1% | 0.974 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 73286.3 ± 0.6% | 71846.2 ± 1.9% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 14586.0 ± 1.2% | 15338.2 ± 0.5% | 0.951 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 14615.3 ± 0.2% | 15305.6 ± 0.4% | 0.955 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 14578.3 ± 0.5% | 15296.6 ± 0.6% | 0.953 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 14593.7 ± 0.2% | 15297.9 ± 2.0% | 0.954 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 14600.5 ± 0.9% | 15286.6 ± 0.4% | 0.955 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 14602.6 ± 0.2% | 15297.5 ± 0.5% | 0.955 | — | — |

## Messages against serde_json's typed code

stdx's encoder a token a call through `TextWriter`'s methods, a member's name and its value in one `member_*` call, beside serde_json 1.0.154 writing the same messages from Rust types, as code of the form serde's derive generates writes them. Octets are the ones written.

| Workload | Octets | TextWriter's methods, MB/s | serde_json typed, MB/s | stdx / serde_json typed |
|---|---|---|---|---|
| messages: 11 string members | 1025025 | 1055.6 ± 2.4% | 538.5 ± 0.3% | 1.960 |
| messages: 50 nested objects | 1121600 | 1130.6 ± 2.8% | 620.1 ± 0.4% | 1.823 |
| messages: a tree of 341 objects | 612600 | 439.5 ± 3.6% | 367.9 ± 2.2% | 1.195 |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1026.5 ± 0.7% | 1025.7 ± 3.3% | 932.7 ± 3.9% | 259.7 ± 2.2% | 533.3 ± 0.7% | 251.9 ± 4.7% | 1.001 | 1.101 | 3.953 | 1.925 | 4.076 |
| qlog records, JSON text sequence | 1467503 | 778.4 ± 9.2% | 812.0 ± 0.3% | 771.0 ± 22.0% | 217.1 ± 8.6% | 551.8 ± 20.7% | 225.5 ± 5.2% | 0.959 | 1.010 | 3.585 | 1.410 | 3.451 |
| messages: 11 string members | 1025025 | 801.1 ± 2.4% | 1133.4 ± 0.4% | 663.0 ± 2.4% | 255.2 ± 4.3% | 448.6 ± 2.4% | 234.3 ± 5.6% | 0.707 | 1.208 | 3.140 | 1.786 | 3.420 |
| messages: 50 nested objects | 1121600 | 1017.5 ± 2.1% | 1001.6 ± 0.3% | 1096.2 ± 2.4% | 281.3 ± 0.7% | 689.5 ± 3.8% | 327.4 ± 2.1% | 1.016 | 0.928 | 3.617 | 1.476 | 3.108 |
| messages: a tree of 341 objects | 612600 | 386.9 ± 3.9% | 439.8 ± 0.2% | 439.2 ± 0.9% | 122.5 ± 1.7% | 445.5 ± 1.1% | 146.8 ± 0.5% | 0.880 | 0.881 | 3.158 | 0.868 | 2.635 |
| string: silesia/dickens | 172528 | 6283.2 ± 0.8% | 2850.9 ± 2.4% | 2094.5 ± 0.9% | 292.1 ± 8.1% | 2173.1 ± 1.1% | 476.6 ± 37.2% | 2.204 | 3.000 | 21.510 | 2.891 | 13.182 |
| string: silesia/nci | 1075110 | 5087.1 ± 0.5% | 3470.3 ± 0.2% | 2812.8 ± 0.7% | 467.5 ± 8.3% | 2330.9 ± 10.3% | 522.1 ± 2.2% | 1.466 | 1.809 | 10.881 | 2.182 | 9.744 |
| string: silesia/reymont | 1075159 | 3288.6 ± 1.5% | 2195.6 ± 0.6% | 1763.5 ± 3.6% | 303.0 ± 0.4% | 1621.4 ± 7.3% | 470.8 ± 1.1% | 1.498 | 1.865 | 10.852 | 2.028 | 6.985 |
| string: silesia/samba | 97582 | 3330.6 ± 1.8% | 2806.3 ± 2.8% | 1637.2 ± 1.4% | 252.8 ± 1.6% | 1279.8 ± 1.0% | 345.6 ± 2.8% | 1.187 | 2.034 | 13.175 | 2.603 | 9.638 |
| string: silesia/webster | 1098490 | 4091.5 ± 0.9% | 2029.2 ± 0.4% | 1633.7 ± 1.7% | 292.7 ± 1.0% | 1675.7 ± 1.3% | 440.4 ± 1.1% | 2.016 | 2.505 | 13.978 | 2.442 | 9.290 |
| string: silesia/xml | 1090118 | 5377.0 ± 0.9% | 3700.1 ± 2.0% | 2149.4 ± 2.5% | 378.2 ± 4.5% | 2350.2 ± 2.7% | 516.3 ± 6.7% | 1.453 | 2.502 | 14.219 | 2.288 | 10.414 |
| string: canterbury/alice29.txt | 159425 | 4894.2 ± 5.4% | 2417.0 ± 2.3% | 1880.7 ± 0.3% | 273.8 ± 2.9% | 1929.9 ± 1.2% | 421.5 ± 3.5% | 2.025 | 2.602 | 17.878 | 2.536 | 11.611 |
| string: canterbury/asyoulik.txt | 132198 | 3807.0 ± 0.4% | 2111.7 ± 0.5% | 1498.9 ± 12.4% | 263.6 ± 0.4% | 1572.8 ± 1.5% | 395.6 ± 2.4% | 1.803 | 2.540 | 14.443 | 2.421 | 9.624 |
| string: canterbury/lcet10.txt | 441884 | 6052.7 ± 0.9% | 2783.8 ± 1.0% | 1990.1 ± 0.7% | 313.2 ± 1.0% | 2137.3 ± 1.1% | 477.3 ± 1.2% | 2.174 | 3.041 | 19.328 | 2.832 | 12.682 |
| string: canterbury/plrabn12.txt | 503330 | 4713.8 ± 0.3% | 2701.3 ± 0.7% | 1694.8 ± 0.5% | 286.4 ± 0.4% | 2006.6 ± 0.6% | 454.1 ± 5.1% | 1.745 | 2.781 | 16.457 | 2.349 | 10.381 |
| string: canterbury-large/E.coli | 1048578 | 37209.0 ± 1.5% | 7759.0 ± 0.3% | 3549.0 ± 0.4% | 870.9 ± 0.9% | 5511.5 ± 0.6% | 798.6 ± 0.9% | 4.796 | 10.484 | 42.726 | 6.751 | 46.590 |
| string: canterbury-large/bible.txt | 1055886 | 9476.6 ± 0.7% | 3902.7 ± 0.4% | 2554.7 ± 1.2% | 334.3 ± 0.8% | 2960.8 ± 1.1% | 601.1 ± 1.5% | 2.428 | 3.709 | 28.347 | 3.201 | 15.766 |
| string: canterbury-large/world192.txt | 1103121 | 3760.3 ± 0.8% | 1974.6 ± 1.1% | 1656.8 ± 2.9% | 288.3 ± 2.5% | 1689.0 ± 6.6% | 430.0 ± 1.2% | 1.904 | 2.270 | 13.043 | 2.226 | 8.745 |
| string: http/html-1m | 1058582 | 7864.6 ± 2.5% | 3413.8 ± 2.0% | 2376.8 ± 14.5% | 379.1 ± 2.4% | 2713.7 ± 2.8% | 421.2 ± 4.6% | 2.304 | 3.309 | 20.748 | 2.898 | 18.672 |
| string: http/json-1m | 1190272 | 3306.2 ± 0.8% | 1201.2 ± 1.0% | 1481.4 ± 8.7% | 332.0 ± 4.2% | 812.1 ± 1.5% | 295.3 ± 1.6% | 2.753 | 2.232 | 9.960 | 4.071 | 11.196 |
| string: http/js-1m | 1144362 | 2650.0 ± 0.9% | 1324.2 ± 0.6% | 1193.8 ± 16.4% | 266.7 ± 0.8% | 1168.7 ± 1.4% | 295.4 ± 2.3% | 2.001 | 2.220 | 9.936 | 2.268 | 8.970 |
| string: http/css-1m | 1097820 | 3020.8 ± 0.5% | 2505.9 ± 0.5% | 1543.2 ± 1.7% | 344.4 ± 10.0% | 1509.2 ± 2.2% | 325.9 ± 2.7% | 1.205 | 1.958 | 8.771 | 2.002 | 9.269 |
| string: dickens as Cyrillic and CJK | 1883069 | 5321.2 ± 0.4% | 3168.4 ± 1.2% | 682.9 ± 7.0% | 278.0 ± 7.3% | 490.1 ± 3.3% | 137.9 ± 1.2% | 1.679 | 7.792 | 19.141 | 10.856 | 38.592 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1057.6 ± 0.8% | 1071.2 ± 1.4% | 930.0 ± 11.1% | 159.7 ± 0.5% | 384.7 ± 0.7% | 196.1 ± 5.4% | 0.987 | 1.137 | 6.621 | 2.749 | 5.393 |
| hex: silesia/dickens | 524290 | 36976.1 ± 5.8% | 7703.9 ± 1.0% | 3557.1 ± 0.3% | 434.9 ± 2.1% | 5508.0 ± 0.6% | 792.0 ± 4.0% | 4.800 | 10.395 | 85.018 | 6.713 | 46.689 |
| hex: silesia/mozilla | 524290 | 35779.4 ± 1.6% | 7712.4 ± 4.0% | 3524.6 ± 1.8% | 378.6 ± 3.3% | 5520.6 ± 0.5% | 788.3 ± 1.1% | 4.639 | 10.151 | 94.511 | 6.481 | 45.387 |
| hex: silesia/mr | 524290 | 36912.2 ± 1.2% | 7813.1 ± 1.4% | 3538.3 ± 0.6% | 548.8 ± 4.0% | 5490.9 ± 0.8% | 789.5 ± 0.8% | 4.724 | 10.432 | 67.257 | 6.722 | 46.756 |
| hex: silesia/nci | 524290 | 36543.2 ± 1.3% | 7744.7 ± 0.4% | 3528.6 ± 0.6% | 604.8 ± 6.1% | 5484.8 ± 8.8% | 784.8 ± 2.5% | 4.718 | 10.356 | 60.422 | 6.663 | 46.565 |
| hex: silesia/ooffice | 524290 | 35619.1 ± 0.4% | 7755.3 ± 0.5% | 3521.6 ± 0.6% | 332.6 ± 1.6% | 5499.1 ± 0.8% | 789.8 ± 0.9% | 4.593 | 10.115 | 107.085 | 6.477 | 45.096 |
| hex: silesia/osdb | 524290 | 36955.1 ± 19.0% | 7736.4 ± 0.6% | 3532.7 ± 1.1% | 423.7 ± 1.3% | 5480.7 ± 2.4% | 779.0 ± 3.1% | 4.777 | 10.461 | 87.223 | 6.743 | 47.440 |
| hex: silesia/reymont | 524290 | 36889.8 ± 3.2% | 7804.5 ± 1.2% | 3554.7 ± 0.4% | 453.3 ± 3.0% | 5522.2 ± 0.4% | 793.2 ± 3.1% | 4.727 | 10.378 | 81.372 | 6.680 | 46.510 |
| hex: silesia/samba | 524290 | 26209.7 ± 1.9% | 7767.2 ± 0.5% | 3517.3 ± 0.8% | 330.3 ± 14.3% | 5449.7 ± 5.3% | 790.3 ± 1.6% | 3.374 | 7.452 | 79.361 | 4.809 | 33.165 |
| hex: silesia/sao | 524290 | 37190.4 ± 0.7% | 7759.2 ± 6.4% | 3542.5 ± 1.7% | 273.0 ± 1.4% | 5503.3 ± 4.9% | 787.9 ± 3.9% | 4.793 | 10.498 | 136.231 | 6.758 | 47.202 |
| hex: silesia/webster | 524290 | 36940.6 ± 2.1% | 7752.7 ± 0.7% | 3527.4 ± 0.8% | 396.8 ± 0.8% | 5505.2 ± 0.3% | 783.4 ± 7.6% | 4.765 | 10.472 | 93.095 | 6.710 | 47.153 |
| hex: silesia/x-ray | 524290 | 35455.4 ± 1.8% | 7751.8 ± 1.1% | 3523.6 ± 0.7% | 396.3 ± 0.8% | 5475.9 ± 2.1% | 783.9 ± 1.4% | 4.574 | 10.062 | 89.458 | 6.475 | 45.231 |
| hex: silesia/xml | 524290 | 36653.4 ± 1.1% | 7753.2 ± 1.8% | 3519.6 ± 3.1% | 548.2 ± 1.9% | 5463.2 ± 2.4% | 788.9 ± 1.2% | 4.728 | 10.414 | 66.862 | 6.709 | 46.459 |
| hex: canterbury/alice29.txt | 304180 | 36960.1 ± 1.2% | 7735.5 ± 0.8% | 3525.8 ± 6.4% | 429.0 ± 7.4% | 5460.3 ± 1.3% | 793.7 ± 2.4% | 4.778 | 10.483 | 86.156 | 6.769 | 46.565 |
| hex: canterbury/asyoulik.txt | 250360 | 35400.4 ± 3.4% | 7762.8 ± 0.3% | 3541.8 ± 0.9% | 417.0 ± 2.7% | 5471.9 ± 0.7% | 794.2 ± 1.9% | 4.560 | 9.995 | 84.891 | 6.469 | 44.571 |
| hex: canterbury/cp.html | 49208 | 37025.5 ± 2.3% | 7783.1 ± 1.2% | 3568.1 ± 1.5% | 417.2 ± 1.6% | 5345.2 ± 0.7% | 788.8 ± 1.9% | 4.757 | 10.377 | 88.745 | 6.927 | 46.939 |
| hex: canterbury/fields.c | 22302 | 37743.8 ± 0.8% | 7706.8 ± 0.7% | 3593.6 ± 0.6% | 440.0 ± 2.5% | 5423.0 ± 1.3% | 767.8 ± 1.9% | 4.897 | 10.503 | 85.776 | 6.960 | 49.156 |
| hex: canterbury/grammar.lsp | 7444 | 34996.1 ± 4.7% | 7485.6 ± 1.8% | 3610.1 ± 2.0% | 497.1 ± 4.9% | 5315.1 ± 3.1% | 718.7 ± 6.2% | 4.675 | 9.694 | 70.405 | 6.584 | 48.696 |
| hex: canterbury/kennedy.xls | 524290 | 36939.6 ± 2.4% | 7713.0 ± 1.1% | 3556.6 ± 4.0% | 658.8 ± 19.6% | 5499.9 ± 0.3% | 788.7 ± 2.0% | 4.789 | 10.386 | 56.075 | 6.716 | 46.839 |
| hex: canterbury/lcet10.txt | 524290 | 37744.0 ± 1.5% | 7746.1 ± 0.5% | 3539.0 ± 3.8% | 436.5 ± 3.1% | 5493.0 ± 0.4% | 774.9 ± 3.0% | 4.873 | 10.665 | 86.472 | 6.871 | 48.706 |
| hex: canterbury/plrabn12.txt | 524290 | 36437.1 ± 3.3% | 7734.3 ± 0.9% | 3556.6 ± 1.0% | 420.1 ± 1.6% | 5497.8 ± 1.8% | 778.9 ± 11.6% | 4.711 | 10.245 | 86.731 | 6.628 | 46.779 |
| hex: canterbury/ptt5 | 524290 | 36476.5 ± 3.0% | 7747.1 ± 1.2% | 3545.4 ± 0.8% | 519.6 ± 6.9% | 5495.5 ± 0.9% | 788.8 ± 3.3% | 4.708 | 10.288 | 70.208 | 6.637 | 46.241 |
| hex: canterbury/sum | 76482 | 40015.7 ± 0.4% | 7812.6 ± 0.1% | 3573.0 ± 1.5% | 485.2 ± 4.2% | 5404.7 ± 1.2% | 772.9 ± 4.7% | 5.122 | 11.200 | 82.466 | 7.404 | 51.776 |
| hex: canterbury/xargs.1 | 8456 | 37590.3 ± 1.5% | 7527.9 ± 0.1% | 3572.9 ± 0.1% | 485.7 ± 0.9% | 5303.8 ± 1.6% | 782.0 ± 12.1% | 4.993 | 10.521 | 77.397 | 7.087 | 48.072 |
| hex: canterbury-large/E.coli | 524290 | 37243.2 ± 5.6% | 7727.0 ± 0.9% | 3559.4 ± 0.5% | 711.1 ± 1.0% | 5534.0 ± 0.5% | 781.3 ± 4.9% | 4.820 | 10.463 | 52.375 | 6.730 | 47.665 |
| hex: canterbury-large/bible.txt | 524290 | 37564.9 ± 1.9% | 7713.6 ± 1.6% | 3527.8 ± 1.3% | 463.3 ± 2.4% | 5525.6 ± 2.3% | 789.3 ± 1.9% | 4.870 | 10.648 | 81.084 | 6.798 | 47.595 |
| hex: canterbury-large/world192.txt | 524290 | 37052.2 ± 2.5% | 7756.3 ± 0.4% | 3413.7 ± 11.0% | 418.3 ± 1.0% | 5525.3 ± 0.4% | 788.1 ± 1.4% | 4.777 | 10.854 | 88.587 | 6.706 | 47.016 |
| hex: http/html-1kx1024 | 2099200 | 16774.0 ± 2.5% | 6635.3 ± 0.4% | 3225.2 ± 0.5% | 453.6 ± 3.1% | 4676.4 ± 1.9% | 688.0 ± 4.8% | 2.528 | 5.201 | 36.976 | 3.587 | 24.379 |
| hex: http/html-16kx64 | 2097280 | 34733.0 ± 2.1% | 7680.0 ± 0.4% | 3516.6 ± 7.9% | 461.5 ± 2.8% | 5436.1 ± 0.6% | 777.1 ± 6.0% | 4.523 | 9.877 | 75.269 | 6.389 | 44.695 |
| hex: http/html-1m | 524290 | 37528.5 ± 3.3% | 7762.8 ± 0.9% | 3539.5 ± 0.5% | 463.1 ± 2.4% | 5517.2 ± 17.4% | 776.4 ± 3.3% | 4.834 | 10.603 | 81.035 | 6.802 | 48.337 |
| hex: http/json-1kx1024 | 2099200 | 16335.2 ± 2.1% | 6633.6 ± 0.9% | 3217.0 ± 0.6% | 571.9 ± 1.7% | 4703.3 ± 0.8% | 692.0 ± 3.2% | 2.463 | 5.078 | 28.564 | 3.473 | 23.606 |
| hex: http/json-16kx64 | 2097280 | 34654.5 ± 2.5% | 7680.4 ± 0.6% | 3522.8 ± 0.7% | 586.2 ± 1.4% | 5428.4 ± 5.5% | 771.5 ± 2.8% | 4.512 | 9.837 | 59.117 | 6.384 | 44.919 |
| hex: http/json-1m | 524290 | 37669.0 ± 7.5% | 7760.8 ± 0.4% | 3561.7 ± 1.1% | 599.3 ± 1.4% | 5492.1 ± 9.8% | 786.5 ± 3.1% | 4.854 | 10.576 | 62.852 | 6.859 | 47.894 |
| hex: http/js-1kx1024 | 2099200 | 16655.5 ± 4.5% | 6634.6 ± 0.3% | 3227.1 ± 2.6% | 441.2 ± 5.2% | 4649.6 ± 5.2% | 669.2 ± 8.8% | 2.510 | 5.161 | 37.749 | 3.582 | 24.888 |
| hex: http/js-16kx64 | 2097280 | 34613.2 ± 4.0% | 7678.0 ± 1.0% | 3514.1 ± 1.0% | 444.4 ± 2.2% | 5435.7 ± 0.5% | 769.8 ± 5.2% | 4.508 | 9.850 | 77.888 | 6.368 | 44.965 |
| hex: http/js-1m | 524290 | 36793.5 ± 4.8% | 7757.5 ± 0.8% | 3553.3 ± 0.5% | 466.3 ± 3.3% | 5524.3 ± 0.4% | 788.8 ± 4.4% | 4.743 | 10.355 | 78.912 | 6.660 | 46.646 |
| hex: http/css-1kx1024 | 2099200 | 16638.4 ± 2.3% | 6640.0 ± 0.8% | 3228.2 ± 0.2% | 497.2 ± 18.9% | 4673.4 ± 3.3% | 683.2 ± 21.3% | 2.506 | 5.154 | 33.464 | 3.560 | 24.353 |
| hex: http/css-16kx64 | 2097280 | 34995.1 ± 1.1% | 7675.4 ± 0.8% | 3522.9 ± 11.9% | 509.5 ± 0.6% | 5434.5 ± 0.4% | 781.8 ± 2.2% | 4.559 | 9.934 | 68.691 | 6.439 | 44.763 |
| hex: http/css-1m | 524290 | 37164.9 ± 1.5% | 7741.4 ± 0.4% | 3550.9 ± 1.3% | 500.6 ± 0.4% | 5520.9 ± 0.4% | 794.0 ± 3.3% | 4.801 | 10.466 | 74.242 | 6.732 | 46.810 |
| hex: shuffled/dickens-1m | 524290 | 36894.0 ± 1.0% | 7775.9 ± 0.3% | 3523.8 ± 0.6% | 445.2 ± 2.4% | 5527.6 ± 13.0% | 786.7 ± 10.5% | 4.745 | 10.470 | 82.865 | 6.675 | 46.899 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1344.8 ± 3.7% | 1127.5 ± 3.2% | 856.0 ± 4.5% | 327.8 ± 3.2% | 344.4 ± 5.6% | 309.6 ± 34.8% | 1.193 | 1.571 | 4.102 | 3.905 | 4.344 |
| qlog records, JSON text sequence | 1467503 | 1141.3 ± 0.8% | 857.7 ± 1.1% | 693.9 ± 2.3% | 312.2 ± 3.7% | 388.4 ± 3.9% | 223.1 ± 4.7% | 1.331 | 1.645 | 3.655 | 2.939 | 5.116 |
| messages: 11 string members | 1025025 | 981.7 ± 8.8% | 880.1 ± 1.7% | 657.3 ± 7.6% | 288.7 ± 26.6% | 229.8 ± 31.6% | 231.6 ± 36.6% | 1.115 | 1.493 | 3.401 | 4.272 | 4.238 |
| messages: 50 nested objects | 1121600 | 1320.7 ± 3.9% | 1187.3 ± 3.6% | 922.0 ± 5.3% | 389.8 ± 5.7% | 430.4 ± 4.0% | 312.9 ± 2.7% | 1.112 | 1.432 | 3.389 | 3.068 | 4.222 |
| messages: a tree of 341 objects | 612600 | 428.2 ± 10.3% | 549.5 ± 11.6% | 348.6 ± 7.6% | 188.7 ± 5.9% | 246.8 ± 8.9% | 119.9 ± 7.1% | 0.779 | 1.229 | 2.269 | 1.735 | 3.573 |
| string: silesia/dickens | 172528 | 9157.5 ± 1.0% | 3019.7 ± 0.4% | 2064.6 ± 1.3% | 361.0 ± 0.9% | 1051.1 ± 1.6% | 563.2 ± 0.6% | 3.033 | 4.436 | 25.369 | 8.712 | 16.260 |
| string: silesia/nci | 1075110 | 8705.4 ± 4.8% | 3200.7 ± 1.7% | 2819.3 ± 0.4% | 774.8 ± 0.7% | 1094.3 ± 0.4% | 563.2 ± 0.7% | 2.720 | 3.088 | 11.235 | 7.955 | 15.458 |
| string: silesia/reymont | 1075159 | 3837.1 ± 1.3% | 1641.2 ± 1.6% | 1738.6 ± 5.0% | 372.3 ± 2.4% | 959.7 ± 3.0% | 551.1 ± 2.0% | 2.338 | 2.207 | 10.306 | 3.998 | 6.963 |
| string: silesia/samba | 97582 | 4657.9 ± 7.9% | 1962.8 ± 0.9% | 2104.7 ± 3.0% | 292.6 ± 7.7% | 894.3 ± 1.0% | 625.0 ± 7.2% | 2.373 | 2.213 | 15.918 | 5.208 | 7.452 |
| string: silesia/webster | 1098490 | 5092.0 ± 1.4% | 1626.5 ± 0.6% | 1546.6 ± 0.4% | 360.8 ± 0.8% | 935.1 ± 0.4% | 456.7 ± 0.8% | 3.131 | 3.292 | 14.112 | 5.445 | 11.150 |
| string: silesia/xml | 1090118 | 7845.7 ± 0.7% | 2671.8 ± 0.7% | 2161.8 ± 5.2% | 528.4 ± 0.8% | 1122.3 ± 0.4% | 562.3 ± 1.4% | 2.936 | 3.629 | 14.848 | 6.991 | 13.953 |
| string: canterbury/alice29.txt | 159425 | 9898.3 ± 2.1% | 2422.9 ± 2.7% | 1831.5 ± 0.4% | 340.4 ± 1.9% | 1027.0 ± 0.7% | 559.9 ± 0.6% | 4.085 | 5.404 | 29.077 | 9.639 | 17.680 |
| string: canterbury/asyoulik.txt | 132198 | 7970.8 ± 0.8% | 2164.4 ± 16.0% | 1570.8 ± 0.7% | 348.1 ± 1.2% | 906.0 ± 0.7% | 547.5 ± 0.3% | 3.683 | 5.074 | 22.895 | 8.798 | 14.557 |
| string: canterbury/lcet10.txt | 441884 | 8853.2 ± 0.7% | 2457.6 ± 1.3% | 1975.1 ± 2.2% | 394.9 ± 0.6% | 1034.4 ± 1.6% | 552.8 ± 0.5% | 3.602 | 4.482 | 22.420 | 8.559 | 16.014 |
| string: canterbury/plrabn12.txt | 503330 | 6065.7 ± 0.1% | 1838.0 ± 2.2% | 1682.2 ± 2.1% | 368.2 ± 3.7% | 998.5 ± 2.2% | 558.9 ± 1.6% | 3.300 | 3.606 | 16.473 | 6.075 | 10.852 |
| string: canterbury-large/E.coli | 1048578 | 37440.2 ± 4.6% | 11584.2 ± 1.5% | 3397.7 ± 0.6% | 1424.3 ± 0.5% | 1420.2 ± 1.4% | 572.0 ± 0.6% | 3.232 | 11.019 | 26.288 | 26.362 | 65.458 |
| string: canterbury-large/bible.txt | 1055886 | 7038.0 ± 0.3% | 3960.7 ± 1.4% | 2671.1 ± 0.2% | 439.4 ± 2.1% | 1198.2 ± 1.1% | 567.9 ± 1.0% | 1.777 | 2.635 | 16.019 | 5.874 | 12.394 |
| string: canterbury-large/world192.txt | 1103121 | 4908.7 ± 6.5% | 1438.9 ± 0.3% | 1604.9 ± 0.8% | 364.6 ± 11.0% | 928.1 ± 0.6% | 542.4 ± 0.5% | 3.411 | 3.059 | 13.462 | 5.289 | 9.050 |
| string: http/html-1m | 1058582 | 8463.3 ± 1.1% | 3878.4 ± 0.7% | 2492.2 ± 4.0% | 429.2 ± 1.6% | 1186.9 ± 0.8% | 522.7 ± 1.1% | 2.182 | 3.396 | 19.719 | 7.131 | 16.192 |
| string: http/json-1m | 1190272 | 6682.0 ± 1.4% | 1225.5 ± 0.6% | 1289.5 ± 0.5% | 414.1 ± 0.9% | 772.9 ± 3.5% | 509.6 ± 0.6% | 5.452 | 5.182 | 16.135 | 8.645 | 13.111 |
| string: http/js-1m | 1144362 | 5050.0 ± 2.7% | 988.6 ± 0.4% | 1115.3 ± 1.2% | 301.1 ± 2.0% | 781.8 ± 2.0% | 474.5 ± 14.0% | 5.108 | 4.528 | 16.770 | 6.459 | 10.643 |
| string: http/css-1m | 1097820 | 6886.5 ± 3.9% | 1279.8 ± 2.7% | 1614.3 ± 16.8% | 429.5 ± 9.9% | 854.5 ± 2.8% | 532.8 ± 1.5% | 5.381 | 4.266 | 16.033 | 8.059 | 12.924 |
| string: dickens as Cyrillic and CJK | 1883069 | 5339.7 ± 2.2% | 3019.7 ± 0.5% | 323.8 ± 3.0% | 272.5 ± 1.3% | 395.8 ± 1.1% | 292.9 ± 0.4% | 1.768 | 16.493 | 19.599 | 13.492 | 18.231 |
| hex: silesia/dickens | 524290 | 30893.2 ± 2.8% | 1569.2 ± 0.3% | 1093.8 ± 2.2% | 426.2 ± 1.4% | 785.8 ± 1.3% | 440.9 ± 7.7% | 19.687 | 28.243 | 72.486 | 39.314 | 70.070 |
| hex: silesia/mozilla | 524290 | 34592.6 ± 1.7% | 1568.9 ± 2.4% | 1094.0 ± 0.5% | 368.0 ± 1.3% | 785.9 ± 22.6% | 435.4 ± 1.6% | 22.049 | 31.620 | 94.004 | 44.015 | 79.453 |
| hex: silesia/mr | 524290 | 34692.0 ± 1.0% | 1565.8 ± 7.3% | 1085.1 ± 8.9% | 507.8 ± 0.4% | 787.5 ± 21.7% | 435.3 ± 2.6% | 22.156 | 31.972 | 68.315 | 44.055 | 79.702 |
| hex: silesia/nci | 524290 | 35007.9 ± 2.4% | 1573.1 ± 0.3% | 1093.6 ± 0.6% | 570.2 ± 3.0% | 789.4 ± 3.0% | 437.5 ± 1.9% | 22.254 | 32.012 | 61.397 | 44.346 | 80.015 |
| hex: silesia/ooffice | 524290 | 32632.9 ± 20.9% | 1566.3 ± 0.8% | 1091.0 ± 0.4% | 324.6 ± 1.2% | 786.2 ± 0.6% | 431.9 ± 2.7% | 20.835 | 29.912 | 100.546 | 41.507 | 75.561 |
| hex: silesia/osdb | 524290 | 32456.0 ± 0.5% | 1560.7 ± 1.1% | 1090.0 ± 2.5% | 414.5 ± 1.2% | 787.5 ± 2.2% | 439.4 ± 1.8% | 20.795 | 29.776 | 78.295 | 41.215 | 73.868 |
| hex: silesia/reymont | 524290 | 33492.9 ± 2.3% | 1559.8 ± 2.1% | 1088.4 ± 2.0% | 437.5 ± 7.5% | 787.3 ± 30.3% | 431.6 ± 3.1% | 21.472 | 30.774 | 76.558 | 42.542 | 77.601 |
| hex: silesia/samba | 524290 | 35345.5 ± 3.5% | 1562.1 ± 1.4% | 1091.1 ± 6.1% | 324.1 ± 0.7% | 783.0 ± 1.7% | 428.1 ± 2.3% | 22.628 | 32.396 | 109.059 | 45.143 | 82.569 |
| hex: silesia/sao | 524290 | 33891.5 ± 3.2% | 1568.6 ± 0.8% | 1094.9 ± 0.6% | 263.9 ± 1.7% | 785.0 ± 0.5% | 430.1 ± 1.2% | 21.607 | 30.954 | 128.408 | 43.172 | 78.804 |
| hex: silesia/webster | 524290 | 35626.6 ± 16.5% | 1570.8 ± 0.9% | 1092.4 ± 0.5% | 402.3 ± 2.4% | 787.8 ± 0.3% | 434.5 ± 0.8% | 22.681 | 32.612 | 88.564 | 45.221 | 82.000 |
| hex: silesia/x-ray | 524290 | 33577.0 ± 0.6% | 1565.0 ± 0.7% | 1089.8 ± 0.8% | 396.2 ± 1.6% | 786.4 ± 0.3% | 430.8 ± 1.4% | 21.454 | 30.811 | 84.755 | 42.697 | 77.940 |
| hex: silesia/xml | 524290 | 34752.4 ± 0.5% | 1565.5 ± 12.4% | 1093.4 ± 0.3% | 580.1 ± 5.0% | 787.3 ± 37.3% | 432.7 ± 1.1% | 22.198 | 31.783 | 59.909 | 44.143 | 80.314 |
| hex: canterbury/alice29.txt | 304180 | 33762.6 ± 0.5% | 1574.2 ± 6.6% | 1097.5 ± 0.5% | 421.1 ± 2.8% | 802.2 ± 7.3% | 432.6 ± 1.3% | 21.448 | 30.763 | 80.183 | 42.085 | 78.037 |
| hex: canterbury/asyoulik.txt | 250360 | 31377.5 ± 4.3% | 1572.5 ± 1.2% | 1087.2 ± 0.4% | 418.5 ± 1.5% | 802.7 ± 0.2% | 435.5 ± 5.1% | 19.954 | 28.861 | 74.973 | 39.090 | 72.056 |
| hex: canterbury/cp.html | 49208 | 31593.3 ± 11.6% | 1619.7 ± 3.4% | 1109.3 ± 1.9% | 463.5 ± 2.4% | 808.9 ± 2.3% | 444.4 ± 9.3% | 19.506 | 28.480 | 68.162 | 39.056 | 71.087 |
| hex: canterbury/fields.c | 22302 | 32853.5 ± 0.6% | 1599.4 ± 0.3% | 1099.8 ± 0.4% | 541.4 ± 0.2% | 805.4 ± 14.7% | 445.1 ± 3.2% | 20.541 | 29.874 | 60.681 | 40.792 | 73.817 |
| hex: canterbury/grammar.lsp | 7444 | 32433.3 ± 1.3% | 1642.5 ± 0.2% | 1120.5 ± 1.4% | 563.1 ± 1.3% | 816.7 ± 0.4% | 445.6 ± 2.1% | 19.746 | 28.944 | 57.599 | 39.714 | 72.787 |
| hex: canterbury/kennedy.xls | 524290 | 31076.8 ± 1.1% | 1565.3 ± 1.8% | 1094.0 ± 2.3% | 596.6 ± 1.1% | 792.4 ± 0.5% | 447.0 ± 0.6% | 19.853 | 28.408 | 52.092 | 39.216 | 69.526 |
| hex: canterbury/lcet10.txt | 524290 | 35289.9 ± 1.1% | 1570.6 ± 0.7% | 1093.2 ± 1.2% | 430.4 ± 0.3% | 790.7 ± 2.6% | 443.6 ± 1.7% | 22.469 | 32.280 | 81.992 | 44.630 | 79.556 |
| hex: canterbury/plrabn12.txt | 524290 | 34191.3 ± 1.1% | 1561.8 ± 1.7% | 1087.9 ± 0.6% | 416.2 ± 6.9% | 790.2 ± 0.7% | 439.1 ± 2.5% | 21.892 | 31.427 | 82.157 | 43.270 | 77.859 |
| hex: canterbury/ptt5 | 524290 | 34075.2 ± 2.5% | 1553.9 ± 27.0% | 1090.7 ± 4.1% | 486.0 ± 5.1% | 786.5 ± 1.2% | 434.5 ± 3.2% | 21.929 | 31.241 | 70.114 | 43.326 | 78.420 |
| hex: canterbury/sum | 76482 | 35287.9 ± 0.7% | 1600.4 ± 1.7% | 1101.0 ± 1.6% | 503.1 ± 1.6% | 807.2 ± 0.4% | 433.9 ± 1.0% | 22.049 | 32.051 | 70.145 | 43.715 | 81.319 |
| hex: canterbury/xargs.1 | 8456 | 34610.7 ± 2.6% | 1631.8 ± 0.9% | 1114.0 ± 0.3% | 567.4 ± 3.7% | 808.1 ± 0.4% | 427.0 ± 1.4% | 21.210 | 31.068 | 61.001 | 42.830 | 81.063 |
| hex: canterbury-large/E.coli | 524290 | 30535.1 ± 4.2% | 1553.2 ± 6.6% | 1089.1 ± 16.3% | 590.3 ± 2.9% | 781.8 ± 0.7% | 438.9 ± 2.2% | 19.659 | 28.038 | 51.732 | 39.057 | 69.567 |
| hex: canterbury-large/bible.txt | 524290 | 35114.4 ± 0.3% | 1572.4 ± 1.1% | 1093.7 ± 1.4% | 439.5 ± 4.5% | 788.3 ± 0.4% | 434.5 ± 1.3% | 22.332 | 32.106 | 79.899 | 44.542 | 80.813 |
| hex: canterbury-large/world192.txt | 524290 | 33037.6 ± 7.3% | 1559.4 ± 1.3% | 1092.4 ± 2.5% | 404.7 ± 4.7% | 781.3 ± 3.2% | 429.3 ± 3.3% | 21.186 | 30.242 | 81.636 | 42.286 | 76.955 |
| hex: http/html-1kx1024 | 2099200 | 23102.8 ± 1.5% | 1611.8 ± 1.0% | 1088.7 ± 0.3% | 457.9 ± 2.3% | 803.7 ± 2.6% | 438.7 ± 4.4% | 14.334 | 21.221 | 50.456 | 28.746 | 52.656 |
| hex: http/html-16kx64 | 2097280 | 29042.0 ± 7.6% | 1610.3 ± 0.3% | 1105.2 ± 0.4% | 456.3 ± 0.1% | 787.2 ± 0.9% | 446.1 ± 2.0% | 18.035 | 26.277 | 63.646 | 36.895 | 65.103 |
| hex: http/html-1m | 524290 | 31354.7 ± 1.6% | 1558.2 ± 2.1% | 1090.2 ± 0.7% | 445.7 ± 8.2% | 785.7 ± 0.3% | 447.2 ± 2.6% | 20.123 | 28.761 | 70.345 | 39.909 | 70.116 |
| hex: http/json-1kx1024 | 2099200 | 23025.3 ± 2.6% | 1612.9 ± 4.2% | 1089.4 ± 2.1% | 566.0 ± 2.2% | 807.1 ± 2.7% | 442.9 ± 3.1% | 14.275 | 21.136 | 40.678 | 28.529 | 51.985 |
| hex: http/json-16kx64 | 2097280 | 29738.7 ± 2.2% | 1608.1 ± 1.1% | 1104.0 ± 1.5% | 565.6 ± 0.7% | 775.6 ± 0.8% | 442.8 ± 4.7% | 18.493 | 26.936 | 52.576 | 38.341 | 67.155 |
| hex: http/json-1m | 524290 | 30983.6 ± 0.6% | 1549.8 ± 0.5% | 1088.9 ± 0.7% | 593.2 ± 0.2% | 792.0 ± 3.0% | 443.7 ± 1.9% | 19.992 | 28.454 | 52.232 | 39.122 | 69.826 |
| hex: http/js-1kx1024 | 2099200 | 23281.6 ± 0.6% | 1609.2 ± 0.1% | 1088.8 ± 0.7% | 440.2 ± 2.3% | 804.2 ± 0.3% | 432.2 ± 3.7% | 14.467 | 21.382 | 52.888 | 28.951 | 53.862 |
| hex: http/js-16kx64 | 2097280 | 29513.6 ± 14.5% | 1606.9 ± 0.6% | 1104.1 ± 0.3% | 440.0 ± 1.9% | 801.6 ± 1.1% | 434.4 ± 2.2% | 18.367 | 26.730 | 67.083 | 36.818 | 67.946 |
| hex: http/js-1m | 524290 | 31734.5 ± 1.4% | 1556.5 ± 0.4% | 1090.7 ± 0.5% | 450.7 ± 8.5% | 788.5 ± 0.3% | 437.5 ± 1.5% | 20.389 | 29.096 | 70.414 | 40.246 | 72.540 |
| hex: http/css-1kx1024 | 2099200 | 23069.0 ± 0.7% | 1612.2 ± 0.4% | 1088.1 ± 0.4% | 501.2 ± 0.8% | 807.1 ± 0.1% | 444.4 ± 2.2% | 14.309 | 21.201 | 46.027 | 28.583 | 51.911 |
| hex: http/css-16kx64 | 2097280 | 29380.1 ± 2.1% | 1608.6 ± 2.5% | 1101.6 ± 2.8% | 493.5 ± 2.6% | 772.0 ± 3.0% | 441.5 ± 3.3% | 18.265 | 26.672 | 59.533 | 38.055 | 66.543 |
| hex: http/css-1m | 524290 | 30763.2 ± 1.4% | 1551.7 ± 1.8% | 1088.3 ± 0.5% | 485.4 ± 0.8% | 786.4 ± 0.4% | 435.8 ± 1.6% | 19.825 | 28.268 | 63.372 | 39.118 | 70.594 |
| hex: shuffled/dickens-1m | 524290 | 32847.9 ± 1.2% | 1554.2 ± 0.5% | 1089.6 ± 0.4% | 427.1 ± 0.9% | 784.1 ± 6.6% | 444.9 ± 1.4% | 21.135 | 30.146 | 76.912 | 41.891 | 73.838 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1367.4 ± 3.6% | 1127.5 ± 3.2% | 856.0 ± 4.5% | 327.8 ± 3.2% | 344.4 ± 5.6% | 309.6 ± 34.8% | 1.213 | 1.598 | 4.172 | 3.970 | 4.417 |
| qlog records, JSON text sequence | 1467503 | 1157.3 ± 0.7% | 857.7 ± 1.1% | 693.9 ± 2.3% | 312.2 ± 3.7% | 388.4 ± 3.9% | 223.1 ± 4.7% | 1.349 | 1.668 | 3.707 | 2.980 | 5.188 |
| messages: 11 string members | 1025025 | 1002.4 ± 23.2% | 880.1 ± 1.7% | 657.3 ± 7.6% | 288.7 ± 26.6% | 229.8 ± 31.6% | 231.6 ± 36.6% | 1.139 | 1.525 | 3.472 | 4.362 | 4.328 |
| messages: 50 nested objects | 1121600 | 1327.1 ± 3.4% | 1187.3 ± 3.6% | 922.0 ± 5.3% | 389.8 ± 5.7% | 430.4 ± 4.0% | 312.9 ± 2.7% | 1.118 | 1.439 | 3.405 | 3.083 | 4.242 |
| messages: a tree of 341 objects | 612600 | 455.1 ± 5.6% | 549.5 ± 11.6% | 348.6 ± 7.6% | 188.7 ± 5.9% | 246.8 ± 8.9% | 119.9 ± 7.1% | 0.828 | 1.306 | 2.411 | 1.844 | 3.797 |
| string: silesia/dickens | 172528 | 9521.5 ± 1.0% | 3019.7 ± 0.4% | 2064.6 ± 1.3% | 361.0 ± 0.9% | 1051.1 ± 1.6% | 563.2 ± 0.6% | 3.153 | 4.612 | 26.377 | 9.059 | 16.907 |
| string: silesia/nci | 1075110 | 8983.1 ± 1.4% | 3200.7 ± 1.7% | 2819.3 ± 0.4% | 774.8 ± 0.7% | 1094.3 ± 0.4% | 563.2 ± 0.7% | 2.807 | 3.186 | 11.594 | 8.209 | 15.951 |
| string: silesia/reymont | 1075159 | 3823.1 ± 1.7% | 1641.2 ± 1.6% | 1738.6 ± 5.0% | 372.3 ± 2.4% | 959.7 ± 3.0% | 551.1 ± 2.0% | 2.329 | 2.199 | 10.268 | 3.984 | 6.937 |
| string: silesia/samba | 97582 | 5201.8 ± 0.2% | 1962.8 ± 0.9% | 2104.7 ± 3.0% | 292.6 ± 7.7% | 894.3 ± 1.0% | 625.0 ± 7.2% | 2.650 | 2.471 | 17.777 | 5.816 | 8.322 |
| string: silesia/webster | 1098490 | 5086.0 ± 3.6% | 1626.5 ± 0.6% | 1546.6 ± 0.4% | 360.8 ± 0.8% | 935.1 ± 0.4% | 456.7 ± 0.8% | 3.127 | 3.288 | 14.095 | 5.439 | 11.137 |
| string: silesia/xml | 1090118 | 8240.7 ± 4.2% | 2671.8 ± 0.7% | 2161.8 ± 5.2% | 528.4 ± 0.8% | 1122.3 ± 0.4% | 562.3 ± 1.4% | 3.084 | 3.812 | 15.595 | 7.343 | 14.655 |
| string: canterbury/alice29.txt | 159425 | 10015.5 ± 0.1% | 2422.9 ± 2.7% | 1831.5 ± 0.4% | 340.4 ± 1.9% | 1027.0 ± 0.7% | 559.9 ± 0.6% | 4.134 | 5.468 | 29.421 | 9.753 | 17.889 |
| string: canterbury/asyoulik.txt | 132198 | 8349.0 ± 0.3% | 2164.4 ± 16.0% | 1570.8 ± 0.7% | 348.1 ± 1.2% | 906.0 ± 0.7% | 547.5 ± 0.3% | 3.857 | 5.315 | 23.981 | 9.216 | 15.248 |
| string: canterbury/lcet10.txt | 441884 | 9121.8 ± 0.6% | 2457.6 ± 1.3% | 1975.1 ± 2.2% | 394.9 ± 0.6% | 1034.4 ± 1.6% | 552.8 ± 0.5% | 3.712 | 4.618 | 23.100 | 8.819 | 16.500 |
| string: canterbury/plrabn12.txt | 503330 | 6355.9 ± 1.6% | 1838.0 ± 2.2% | 1682.2 ± 2.1% | 368.2 ± 3.7% | 998.5 ± 2.2% | 558.9 ± 1.6% | 3.458 | 3.778 | 17.261 | 6.365 | 11.372 |
| string: canterbury-large/E.coli | 1048578 | 38838.0 ± 0.9% | 11584.2 ± 1.5% | 3397.7 ± 0.6% | 1424.3 ± 0.5% | 1420.2 ± 1.4% | 572.0 ± 0.6% | 3.353 | 11.431 | 27.269 | 27.347 | 67.902 |
| string: canterbury-large/bible.txt | 1055886 | 7413.7 ± 0.4% | 3960.7 ± 1.4% | 2671.1 ± 0.2% | 439.4 ± 2.1% | 1198.2 ± 1.1% | 567.9 ± 1.0% | 1.872 | 2.776 | 16.874 | 6.187 | 13.056 |
| string: canterbury-large/world192.txt | 1103121 | 4816.3 ± 0.4% | 1438.9 ± 0.3% | 1604.9 ± 0.8% | 364.6 ± 11.0% | 928.1 ± 0.6% | 542.4 ± 0.5% | 3.347 | 3.001 | 13.208 | 5.190 | 8.880 |
| string: http/html-1m | 1058582 | 8616.1 ± 0.4% | 3878.4 ± 0.7% | 2492.2 ± 4.0% | 429.2 ± 1.6% | 1186.9 ± 0.8% | 522.7 ± 1.1% | 2.222 | 3.457 | 20.076 | 7.259 | 16.485 |
| string: http/json-1m | 1190272 | 6802.4 ± 0.3% | 1225.5 ± 0.6% | 1289.5 ± 0.5% | 414.1 ± 0.9% | 772.9 ± 3.5% | 509.6 ± 0.6% | 5.551 | 5.275 | 16.426 | 8.801 | 13.348 |
| string: http/js-1m | 1144362 | 5087.1 ± 0.2% | 988.6 ± 0.4% | 1115.3 ± 1.2% | 301.1 ± 2.0% | 781.8 ± 2.0% | 474.5 ± 14.0% | 5.146 | 4.561 | 16.893 | 6.507 | 10.722 |
| string: http/css-1m | 1097820 | 7290.8 ± 1.3% | 1279.8 ± 2.7% | 1614.3 ± 16.8% | 429.5 ± 9.9% | 854.5 ± 2.8% | 532.8 ± 1.5% | 5.697 | 4.517 | 16.974 | 8.532 | 13.683 |
| string: dickens as Cyrillic and CJK | 1883069 | 5195.7 ± 2.4% | 3019.7 ± 0.5% | 323.8 ± 3.0% | 272.5 ± 1.3% | 395.8 ± 1.1% | 292.9 ± 0.4% | 1.721 | 16.048 | 19.070 | 13.128 | 17.739 |
| hex: silesia/dickens | 524290 | 31135.5 ± 0.6% | 1569.2 ± 0.3% | 1093.8 ± 2.2% | 426.2 ± 1.4% | 785.8 ± 1.3% | 440.9 ± 7.7% | 19.841 | 28.464 | 73.055 | 39.623 | 70.620 |
| hex: silesia/mozilla | 524290 | 35201.0 ± 0.6% | 1568.9 ± 2.4% | 1094.0 ± 0.5% | 368.0 ± 1.3% | 785.9 ± 22.6% | 435.4 ± 1.6% | 22.437 | 32.176 | 95.657 | 44.789 | 80.851 |
| hex: silesia/mr | 524290 | 34890.0 ± 0.4% | 1565.8 ± 7.3% | 1085.1 ± 8.9% | 507.8 ± 0.4% | 787.5 ± 21.7% | 435.3 ± 2.6% | 22.282 | 32.155 | 68.705 | 44.306 | 80.157 |
| hex: silesia/nci | 524290 | 35395.2 ± 0.5% | 1573.1 ± 0.3% | 1093.6 ± 0.6% | 570.2 ± 3.0% | 789.4 ± 3.0% | 437.5 ± 1.9% | 22.500 | 32.366 | 62.076 | 44.837 | 80.900 |
| hex: silesia/ooffice | 524290 | 33866.0 ± 1.1% | 1566.3 ± 0.8% | 1091.0 ± 0.4% | 324.6 ± 1.2% | 786.2 ± 0.6% | 431.9 ± 2.7% | 21.622 | 31.042 | 104.345 | 43.075 | 78.416 |
| hex: silesia/osdb | 524290 | 32961.0 ± 0.5% | 1560.7 ± 1.1% | 1090.0 ± 2.5% | 414.5 ± 1.2% | 787.5 ± 2.2% | 439.4 ± 1.8% | 21.119 | 30.239 | 79.513 | 41.856 | 75.017 |
| hex: silesia/reymont | 524290 | 33853.4 ± 1.1% | 1559.8 ± 2.1% | 1088.4 ± 2.0% | 437.5 ± 7.5% | 787.3 ± 30.3% | 431.6 ± 3.1% | 21.703 | 31.105 | 77.382 | 43.000 | 78.437 |
| hex: silesia/samba | 524290 | 35944.5 ± 2.6% | 1562.1 ± 1.4% | 1091.1 ± 6.1% | 324.1 ± 0.7% | 783.0 ± 1.7% | 428.1 ± 2.3% | 23.011 | 32.945 | 110.907 | 45.908 | 83.968 |
| hex: silesia/sao | 524290 | 33995.9 ± 9.5% | 1568.6 ± 0.8% | 1094.9 ± 0.6% | 263.9 ± 1.7% | 785.0 ± 0.5% | 430.1 ± 1.2% | 21.673 | 31.050 | 128.804 | 43.305 | 79.047 |
| hex: silesia/webster | 524290 | 35969.7 ± 0.6% | 1570.8 ± 0.9% | 1092.4 ± 0.5% | 402.3 ± 2.4% | 787.8 ± 0.3% | 434.5 ± 0.8% | 22.900 | 32.926 | 89.417 | 45.657 | 82.789 |
| hex: silesia/x-ray | 524290 | 34006.1 ± 0.6% | 1565.0 ± 0.7% | 1089.8 ± 0.8% | 396.2 ± 1.6% | 786.4 ± 0.3% | 430.8 ± 1.4% | 21.729 | 31.204 | 85.838 | 43.242 | 78.936 |
| hex: silesia/xml | 524290 | 35178.2 ± 0.4% | 1565.5 ± 12.4% | 1093.4 ± 0.3% | 580.1 ± 5.0% | 787.3 ± 37.3% | 432.7 ± 1.1% | 22.470 | 32.172 | 60.643 | 44.684 | 81.298 |
| hex: canterbury/alice29.txt | 304180 | 33998.5 ± 12.7% | 1574.2 ± 6.6% | 1097.5 ± 0.5% | 421.1 ± 2.8% | 802.2 ± 7.3% | 432.6 ± 1.3% | 21.598 | 30.978 | 80.744 | 42.380 | 78.582 |
| hex: canterbury/asyoulik.txt | 250360 | 31415.8 ± 0.3% | 1572.5 ± 1.2% | 1087.2 ± 0.4% | 418.5 ± 1.5% | 802.7 ± 0.2% | 435.5 ± 5.1% | 19.978 | 28.896 | 75.064 | 39.137 | 72.144 |
| hex: canterbury/cp.html | 49208 | 31762.1 ± 1.6% | 1619.7 ± 3.4% | 1109.3 ± 1.9% | 463.5 ± 2.4% | 808.9 ± 2.3% | 444.4 ± 9.3% | 19.610 | 28.632 | 68.527 | 39.265 | 71.467 |
| hex: canterbury/fields.c | 22302 | 32899.5 ± 0.3% | 1599.4 ± 0.3% | 1099.8 ± 0.4% | 541.4 ± 0.2% | 805.4 ± 14.7% | 445.1 ± 3.2% | 20.569 | 29.915 | 60.766 | 40.849 | 73.921 |
| hex: canterbury/grammar.lsp | 7444 | 32953.5 ± 0.3% | 1642.5 ± 0.2% | 1120.5 ± 1.4% | 563.1 ± 1.3% | 816.7 ± 0.4% | 445.6 ± 2.1% | 20.063 | 29.409 | 58.523 | 40.351 | 73.954 |
| hex: canterbury/kennedy.xls | 524290 | 31324.3 ± 0.6% | 1565.3 ± 1.8% | 1094.0 ± 2.3% | 596.6 ± 1.1% | 792.4 ± 0.5% | 447.0 ± 0.6% | 20.011 | 28.634 | 52.507 | 39.528 | 70.080 |
| hex: canterbury/lcet10.txt | 524290 | 35683.6 ± 3.0% | 1570.6 ± 0.7% | 1093.2 ± 1.2% | 430.4 ± 0.3% | 790.7 ± 2.6% | 443.6 ± 1.7% | 22.720 | 32.640 | 82.907 | 45.128 | 80.444 |
| hex: canterbury/plrabn12.txt | 524290 | 34452.8 ± 1.2% | 1561.8 ± 1.7% | 1087.9 ± 0.6% | 416.2 ± 6.9% | 790.2 ± 0.7% | 439.1 ± 2.5% | 22.060 | 31.668 | 82.785 | 43.601 | 78.455 |
| hex: canterbury/ptt5 | 524290 | 34709.7 ± 1.6% | 1553.9 ± 27.0% | 1090.7 ± 4.1% | 486.0 ± 5.1% | 786.5 ± 1.2% | 434.5 ± 3.2% | 22.338 | 31.823 | 71.420 | 44.133 | 79.881 |
| hex: canterbury/sum | 76482 | 35639.2 ± 0.3% | 1600.4 ± 1.7% | 1101.0 ± 1.6% | 503.1 ± 1.6% | 807.2 ± 0.4% | 433.9 ± 1.0% | 22.269 | 32.371 | 70.844 | 44.150 | 82.129 |
| hex: canterbury/xargs.1 | 8456 | 34889.6 ± 2.2% | 1631.8 ± 0.9% | 1114.0 ± 0.3% | 567.4 ± 3.7% | 808.1 ± 0.4% | 427.0 ± 1.4% | 21.381 | 31.318 | 61.492 | 43.175 | 81.717 |
| hex: canterbury-large/E.coli | 524290 | 30755.8 ± 0.2% | 1553.2 ± 6.6% | 1089.1 ± 16.3% | 590.3 ± 2.9% | 781.8 ± 0.7% | 438.9 ± 2.2% | 19.801 | 28.240 | 52.106 | 39.339 | 70.070 |
| hex: canterbury-large/bible.txt | 524290 | 35511.6 ± 0.4% | 1572.4 ± 1.1% | 1093.7 ± 1.4% | 439.5 ± 4.5% | 788.3 ± 0.4% | 434.5 ± 1.3% | 22.585 | 32.469 | 80.803 | 45.046 | 81.727 |
| hex: canterbury-large/world192.txt | 524290 | 33452.4 ± 1.3% | 1559.4 ± 1.3% | 1092.4 ± 2.5% | 404.7 ± 4.7% | 781.3 ± 3.2% | 429.3 ± 3.3% | 21.452 | 30.621 | 82.661 | 42.817 | 77.921 |
| hex: http/html-1kx1024 | 2099200 | 24030.6 ± 10.5% | 1611.8 ± 1.0% | 1088.7 ± 0.3% | 457.9 ± 2.3% | 803.7 ± 2.6% | 438.7 ± 4.4% | 14.909 | 22.073 | 52.482 | 29.901 | 54.771 |
| hex: http/html-16kx64 | 2097280 | 30201.1 ± 0.1% | 1610.3 ± 0.3% | 1105.2 ± 0.4% | 456.3 ± 0.1% | 787.2 ± 0.9% | 446.1 ± 2.0% | 18.755 | 27.326 | 66.186 | 38.367 | 67.701 |
| hex: http/html-1m | 524290 | 31411.4 ± 10.9% | 1558.2 ± 2.1% | 1090.2 ± 0.7% | 445.7 ± 8.2% | 785.7 ± 0.3% | 447.2 ± 2.6% | 20.159 | 28.813 | 70.472 | 39.981 | 70.243 |
| hex: http/json-1kx1024 | 2099200 | 24037.9 ± 0.4% | 1612.9 ± 4.2% | 1089.4 ± 2.1% | 566.0 ± 2.2% | 807.1 ± 2.7% | 442.9 ± 3.1% | 14.903 | 22.066 | 42.467 | 29.784 | 54.271 |
| hex: http/json-16kx64 | 2097280 | 30382.5 ± 0.9% | 1608.1 ± 1.1% | 1104.0 ± 1.5% | 565.6 ± 0.7% | 775.6 ± 0.8% | 442.8 ± 4.7% | 18.893 | 27.519 | 53.714 | 39.171 | 68.609 |
| hex: http/json-1m | 524290 | 31298.0 ± 0.5% | 1549.8 ± 0.5% | 1088.9 ± 0.7% | 593.2 ± 0.2% | 792.0 ± 3.0% | 443.7 ± 1.9% | 20.195 | 28.743 | 52.762 | 39.519 | 70.535 |
| hex: http/js-1kx1024 | 2099200 | 24090.7 ± 9.1% | 1609.2 ± 0.1% | 1088.8 ± 0.7% | 440.2 ± 2.3% | 804.2 ± 0.3% | 432.2 ± 3.7% | 14.970 | 22.125 | 54.726 | 29.957 | 55.734 |
| hex: http/js-16kx64 | 2097280 | 30043.2 ± 1.2% | 1606.9 ± 0.6% | 1104.1 ± 0.3% | 440.0 ± 1.9% | 801.6 ± 1.1% | 434.4 ± 2.2% | 18.696 | 27.209 | 68.286 | 37.478 | 69.165 |
| hex: http/js-1m | 524290 | 31960.1 ± 0.3% | 1556.5 ± 0.4% | 1090.7 ± 0.5% | 450.7 ± 8.5% | 788.5 ± 0.3% | 437.5 ± 1.5% | 20.534 | 29.303 | 70.915 | 40.533 | 73.056 |
| hex: http/css-1kx1024 | 2099200 | 24021.0 ± 1.9% | 1612.2 ± 0.4% | 1088.1 ± 0.4% | 501.2 ± 0.8% | 807.1 ± 0.1% | 444.4 ± 2.2% | 14.900 | 22.076 | 47.927 | 29.763 | 54.053 |
| hex: http/css-16kx64 | 2097280 | 30572.8 ± 1.4% | 1608.6 ± 2.5% | 1101.6 ± 2.8% | 493.5 ± 2.6% | 772.0 ± 3.0% | 441.5 ± 3.3% | 19.006 | 27.754 | 61.950 | 39.600 | 69.244 |
| hex: http/css-1m | 524290 | 31046.3 ± 0.8% | 1551.7 ± 1.8% | 1088.3 ± 0.5% | 485.4 ± 0.8% | 786.4 ± 0.4% | 435.8 ± 1.6% | 20.008 | 28.528 | 63.955 | 39.478 | 71.243 |
| hex: shuffled/dickens-1m | 524290 | 33083.0 ± 0.4% | 1554.2 ± 0.5% | 1089.6 ± 0.4% | 427.1 ± 0.9% | 784.1 ± 6.6% | 444.9 ± 1.4% | 21.287 | 30.362 | 77.463 | 42.190 | 74.367 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 835.6 ± 9.3% | 1025.7 ± 3.3% | 932.7 ± 3.9% | 259.7 ± 2.2% | 533.3 ± 0.7% | 251.9 ± 4.7% | 0.815 | 0.896 | 3.218 | 1.567 | 3.318 |
| qlog records, JSON text sequence | 1467503 | 743.7 ± 11.1% | 812.0 ± 0.3% | 771.0 ± 22.0% | 217.1 ± 8.6% | 551.8 ± 20.7% | 225.5 ± 5.2% | 0.916 | 0.965 | 3.426 | 1.348 | 3.298 |
| messages: 11 string members | 1025025 | 782.3 ± 1.9% | 1133.4 ± 0.4% | 663.0 ± 2.4% | 255.2 ± 4.3% | 448.6 ± 2.4% | 234.3 ± 5.6% | 0.690 | 1.180 | 3.066 | 1.744 | 3.339 |
| messages: 50 nested objects | 1121600 | 926.9 ± 1.3% | 1001.6 ± 0.3% | 1096.2 ± 2.4% | 281.3 ± 0.7% | 689.5 ± 3.8% | 327.4 ± 2.1% | 0.925 | 0.846 | 3.295 | 1.344 | 2.831 |
| messages: a tree of 341 objects | 612600 | 313.0 ± 9.1% | 439.8 ± 0.2% | 439.2 ± 0.9% | 122.5 ± 1.7% | 445.5 ± 1.1% | 146.8 ± 0.5% | 0.712 | 0.713 | 2.556 | 0.703 | 2.132 |
| string: silesia/dickens | 172528 | 6237.6 ± 0.6% | 2850.9 ± 2.4% | 2094.5 ± 0.9% | 292.1 ± 8.1% | 2173.1 ± 1.1% | 476.6 ± 37.2% | 2.188 | 2.978 | 21.354 | 2.870 | 13.086 |
| string: silesia/nci | 1075110 | 5093.4 ± 0.6% | 3470.3 ± 0.2% | 2812.8 ± 0.7% | 467.5 ± 8.3% | 2330.9 ± 10.3% | 522.1 ± 2.2% | 1.468 | 1.811 | 10.895 | 2.185 | 9.756 |
| string: silesia/reymont | 1075159 | 3296.0 ± 0.7% | 2195.6 ± 0.6% | 1763.5 ± 3.6% | 303.0 ± 0.4% | 1621.4 ± 7.3% | 470.8 ± 1.1% | 1.501 | 1.869 | 10.877 | 2.033 | 7.001 |
| string: silesia/samba | 97582 | 3353.2 ± 0.4% | 2806.3 ± 2.8% | 1637.2 ± 1.4% | 252.8 ± 1.6% | 1279.8 ± 1.0% | 345.6 ± 2.8% | 1.195 | 2.048 | 13.264 | 2.620 | 9.703 |
| string: silesia/webster | 1098490 | 4101.2 ± 0.5% | 2029.2 ± 0.4% | 1633.7 ± 1.7% | 292.7 ± 1.0% | 1675.7 ± 1.3% | 440.4 ± 1.1% | 2.021 | 2.510 | 14.011 | 2.448 | 9.312 |
| string: silesia/xml | 1090118 | 5367.7 ± 2.1% | 3700.1 ± 2.0% | 2149.4 ± 2.5% | 378.2 ± 4.5% | 2350.2 ± 2.7% | 516.3 ± 6.7% | 1.451 | 2.497 | 14.194 | 2.284 | 10.396 |
| string: canterbury/alice29.txt | 159425 | 4890.1 ± 0.2% | 2417.0 ± 2.3% | 1880.7 ± 0.3% | 273.8 ± 2.9% | 1929.9 ± 1.2% | 421.5 ± 3.5% | 2.023 | 2.600 | 17.862 | 2.534 | 11.601 |
| string: canterbury/asyoulik.txt | 132198 | 3805.8 ± 5.1% | 2111.7 ± 0.5% | 1498.9 ± 12.4% | 263.6 ± 0.4% | 1572.8 ± 1.5% | 395.6 ± 2.4% | 1.802 | 2.539 | 14.438 | 2.420 | 9.621 |
| string: canterbury/lcet10.txt | 441884 | 6070.2 ± 0.3% | 2783.8 ± 1.0% | 1990.1 ± 0.7% | 313.2 ± 1.0% | 2137.3 ± 1.1% | 477.3 ± 1.2% | 2.181 | 3.050 | 19.384 | 2.840 | 12.718 |
| string: canterbury/plrabn12.txt | 503330 | 4721.1 ± 0.3% | 2701.3 ± 0.7% | 1694.8 ± 0.5% | 286.4 ± 0.4% | 2006.6 ± 0.6% | 454.1 ± 5.1% | 1.748 | 2.786 | 16.482 | 2.353 | 10.397 |
| string: canterbury-large/E.coli | 1048578 | 33508.5 ± 6.2% | 7759.0 ± 0.3% | 3549.0 ± 0.4% | 870.9 ± 0.9% | 5511.5 ± 0.6% | 798.6 ± 0.9% | 4.319 | 9.442 | 38.477 | 6.080 | 41.957 |
| string: canterbury-large/bible.txt | 1055886 | 9487.0 ± 4.8% | 3902.7 ± 0.4% | 2554.7 ± 1.2% | 334.3 ± 0.8% | 2960.8 ± 1.1% | 601.1 ± 1.5% | 2.431 | 3.714 | 28.378 | 3.204 | 15.783 |
| string: canterbury-large/world192.txt | 1103121 | 3743.5 ± 0.9% | 1974.6 ± 1.1% | 1656.8 ± 2.9% | 288.3 ± 2.5% | 1689.0 ± 6.6% | 430.0 ± 1.2% | 1.896 | 2.260 | 12.984 | 2.216 | 8.705 |
| string: http/html-1m | 1058582 | 7905.7 ± 1.5% | 3413.8 ± 2.0% | 2376.8 ± 14.5% | 379.1 ± 2.4% | 2713.7 ± 2.8% | 421.2 ± 4.6% | 2.316 | 3.326 | 20.857 | 2.913 | 18.770 |
| string: http/json-1m | 1190272 | 3318.1 ± 0.1% | 1201.2 ± 1.0% | 1481.4 ± 8.7% | 332.0 ± 4.2% | 812.1 ± 1.5% | 295.3 ± 1.6% | 2.762 | 2.240 | 9.996 | 4.086 | 11.237 |
| string: http/js-1m | 1144362 | 2655.6 ± 1.4% | 1324.2 ± 0.6% | 1193.8 ± 16.4% | 266.7 ± 0.8% | 1168.7 ± 1.4% | 295.4 ± 2.3% | 2.006 | 2.225 | 9.958 | 2.272 | 8.989 |
| string: http/css-1m | 1097820 | 3026.6 ± 0.8% | 2505.9 ± 0.5% | 1543.2 ± 1.7% | 344.4 ± 10.0% | 1509.2 ± 2.2% | 325.9 ± 2.7% | 1.208 | 1.961 | 8.788 | 2.005 | 9.287 |
| string: dickens as Cyrillic and CJK | 1883069 | 5336.3 ± 7.0% | 3168.4 ± 1.2% | 682.9 ± 7.0% | 278.0 ± 7.3% | 490.1 ± 3.3% | 137.9 ± 1.2% | 1.684 | 7.814 | 19.195 | 10.887 | 38.701 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1058.1 ± 0.7% | 1071.2 ± 1.4% | 930.0 ± 11.1% | 159.7 ± 0.5% | 384.7 ± 0.7% | 196.1 ± 5.4% | 0.988 | 1.138 | 6.624 | 2.750 | 5.395 |
| hex: silesia/dickens | 524290 | 33234.4 ± 0.2% | 7703.9 ± 1.0% | 3557.1 ± 0.3% | 434.9 ± 2.1% | 5508.0 ± 0.6% | 792.0 ± 4.0% | 4.314 | 9.343 | 76.415 | 6.034 | 41.964 |
| hex: silesia/mozilla | 524290 | 33813.2 ± 2.5% | 7712.4 ± 4.0% | 3524.6 ± 1.8% | 378.6 ± 3.3% | 5520.6 ± 0.5% | 788.3 ± 1.1% | 4.384 | 9.594 | 89.317 | 6.125 | 42.893 |
| hex: silesia/mr | 524290 | 33754.1 ± 0.2% | 7813.1 ± 1.4% | 3538.3 ± 0.6% | 548.8 ± 4.0% | 5490.9 ± 0.8% | 789.5 ± 0.8% | 4.320 | 9.540 | 61.503 | 6.147 | 42.755 |
| hex: silesia/nci | 524290 | 33320.5 ± 0.2% | 7744.7 ± 0.4% | 3528.6 ± 0.6% | 604.8 ± 6.1% | 5484.8 ± 8.8% | 784.8 ± 2.5% | 4.302 | 9.443 | 55.093 | 6.075 | 42.458 |
| hex: silesia/ooffice | 524290 | 33459.9 ± 3.5% | 7755.3 ± 0.5% | 3521.6 ± 0.6% | 332.6 ± 1.6% | 5499.1 ± 0.8% | 789.8 ± 0.9% | 4.314 | 9.501 | 100.593 | 6.085 | 42.362 |
| hex: silesia/osdb | 524290 | 33817.1 ± 0.3% | 7736.4 ± 0.6% | 3532.7 ± 1.1% | 423.7 ± 1.3% | 5480.7 ± 2.4% | 779.0 ± 3.1% | 4.371 | 9.573 | 79.817 | 6.170 | 43.412 |
| hex: silesia/reymont | 524290 | 33584.8 ± 7.7% | 7804.5 ± 1.2% | 3554.7 ± 0.4% | 453.3 ± 3.0% | 5522.2 ± 0.4% | 793.2 ± 3.1% | 4.303 | 9.448 | 74.082 | 6.082 | 42.343 |
| hex: silesia/samba | 524290 | 33390.5 ± 1.5% | 7767.2 ± 0.5% | 3517.3 ± 0.8% | 330.3 ± 14.3% | 5449.7 ± 5.3% | 790.3 ± 1.6% | 4.299 | 9.493 | 101.104 | 6.127 | 42.251 |
| hex: silesia/sao | 524290 | 33739.6 ± 0.4% | 7759.2 ± 6.4% | 3542.5 ± 1.7% | 273.0 ± 1.4% | 5503.3 ± 4.9% | 787.9 ± 3.9% | 4.348 | 9.524 | 123.590 | 6.131 | 42.823 |
| hex: silesia/webster | 524290 | 33481.1 ± 2.4% | 7752.7 ± 0.7% | 3527.4 ± 0.8% | 396.8 ± 0.8% | 5505.2 ± 0.3% | 783.4 ± 7.6% | 4.319 | 9.492 | 84.376 | 6.082 | 42.737 |
| hex: silesia/x-ray | 524290 | 33441.3 ± 0.6% | 7751.8 ± 1.1% | 3523.6 ± 0.7% | 396.3 ± 0.8% | 5475.9 ± 2.1% | 783.9 ± 1.4% | 4.314 | 9.491 | 84.376 | 6.107 | 42.662 |
| hex: silesia/xml | 524290 | 33387.8 ± 2.0% | 7753.2 ± 1.8% | 3519.6 ± 3.1% | 548.2 ± 1.9% | 5463.2 ± 2.4% | 788.9 ± 1.2% | 4.306 | 9.486 | 60.905 | 6.111 | 42.320 |
| hex: canterbury/alice29.txt | 304180 | 33743.7 ± 0.9% | 7735.5 ± 0.8% | 3525.8 ± 6.4% | 429.0 ± 7.4% | 5460.3 ± 1.3% | 793.7 ± 2.4% | 4.362 | 9.571 | 78.658 | 6.180 | 42.513 |
| hex: canterbury/asyoulik.txt | 250360 | 33578.6 ± 1.8% | 7762.8 ± 0.3% | 3541.8 ± 0.9% | 417.0 ± 2.7% | 5471.9 ± 0.7% | 794.2 ± 1.9% | 4.326 | 9.481 | 80.522 | 6.137 | 42.277 |
| hex: canterbury/cp.html | 49208 | 32752.5 ± 1.1% | 7783.1 ± 1.2% | 3568.1 ± 1.5% | 417.2 ± 1.6% | 5345.2 ± 0.7% | 788.8 ± 1.9% | 4.208 | 9.179 | 78.503 | 6.127 | 41.522 |
| hex: canterbury/fields.c | 22302 | 31616.3 ± 0.2% | 7706.8 ± 0.7% | 3593.6 ± 0.6% | 440.0 ± 2.5% | 5423.0 ± 1.3% | 767.8 ± 1.9% | 4.102 | 8.798 | 71.851 | 5.830 | 41.176 |
| hex: canterbury/grammar.lsp | 7444 | 27466.6 ± 3.3% | 7485.6 ± 1.8% | 3610.1 ± 2.0% | 497.1 ± 4.9% | 5315.1 ± 3.1% | 718.7 ± 6.2% | 3.669 | 7.608 | 55.258 | 5.168 | 38.219 |
| hex: canterbury/kennedy.xls | 524290 | 33612.7 ± 0.5% | 7713.0 ± 1.1% | 3556.6 ± 4.0% | 658.8 ± 19.6% | 5499.9 ± 0.3% | 788.7 ± 2.0% | 4.358 | 9.451 | 51.025 | 6.111 | 42.620 |
| hex: canterbury/lcet10.txt | 524290 | 33681.6 ± 0.3% | 7746.1 ± 0.5% | 3539.0 ± 3.8% | 436.5 ± 3.1% | 5493.0 ± 0.4% | 774.9 ± 3.0% | 4.348 | 9.517 | 77.165 | 6.132 | 43.463 |
| hex: canterbury/plrabn12.txt | 524290 | 33395.1 ± 1.6% | 7734.3 ± 0.9% | 3556.6 ± 1.0% | 420.1 ± 1.6% | 5497.8 ± 1.8% | 778.9 ± 11.6% | 4.318 | 9.390 | 79.491 | 6.074 | 42.874 |
| hex: canterbury/ptt5 | 524290 | 33498.4 ± 1.1% | 7747.1 ± 1.2% | 3545.4 ± 0.8% | 519.6 ± 6.9% | 5495.5 ± 0.9% | 788.8 ± 3.3% | 4.324 | 9.448 | 64.476 | 6.096 | 42.466 |
| hex: canterbury/sum | 76482 | 33244.7 ± 0.2% | 7812.6 ± 0.1% | 3573.0 ± 1.5% | 485.2 ± 4.2% | 5404.7 ± 1.2% | 772.9 ± 4.7% | 4.255 | 9.304 | 68.512 | 6.151 | 43.015 |
| hex: canterbury/xargs.1 | 8456 | 28092.7 ± 6.8% | 7527.9 ± 0.1% | 3572.9 ± 0.1% | 485.7 ± 0.9% | 5303.8 ± 1.6% | 782.0 ± 12.1% | 3.732 | 7.863 | 57.842 | 5.297 | 35.926 |
| hex: canterbury-large/E.coli | 524290 | 33229.2 ± 5.7% | 7727.0 ± 0.9% | 3559.4 ± 0.5% | 711.1 ± 1.0% | 5534.0 ± 0.5% | 781.3 ± 4.9% | 4.300 | 9.336 | 46.731 | 6.005 | 42.528 |
| hex: canterbury-large/bible.txt | 524290 | 33292.9 ± 2.3% | 7713.6 ± 1.6% | 3527.8 ± 1.3% | 463.3 ± 2.4% | 5525.6 ± 2.3% | 789.3 ± 1.9% | 4.316 | 9.437 | 71.863 | 6.025 | 42.182 |
| hex: canterbury-large/world192.txt | 524290 | 33398.1 ± 0.5% | 7756.3 ± 0.4% | 3413.7 ± 11.0% | 418.3 ± 1.0% | 5525.3 ± 0.4% | 788.1 ± 1.4% | 4.306 | 9.784 | 79.850 | 6.045 | 42.379 |
| hex: http/html-1kx1024 | 2099200 | 16858.8 ± 1.7% | 6635.3 ± 0.4% | 3225.2 ± 0.5% | 453.6 ± 3.1% | 4676.4 ± 1.9% | 688.0 ± 4.8% | 2.541 | 5.227 | 37.163 | 3.605 | 24.502 |
| hex: http/html-16kx64 | 2097280 | 30914.2 ± 0.6% | 7680.0 ± 0.4% | 3516.6 ± 7.9% | 461.5 ± 2.8% | 5436.1 ± 0.6% | 777.1 ± 6.0% | 4.025 | 8.791 | 66.993 | 5.687 | 39.780 |
| hex: http/html-1m | 524290 | 33659.7 ± 0.4% | 7762.8 ± 0.9% | 3539.5 ± 0.5% | 463.1 ± 2.4% | 5517.2 ± 17.4% | 776.4 ± 3.3% | 4.336 | 9.510 | 72.681 | 6.101 | 43.354 |
| hex: http/json-1kx1024 | 2099200 | 16943.0 ± 1.8% | 6633.6 ± 0.9% | 3217.0 ± 0.6% | 571.9 ± 1.7% | 4703.3 ± 0.8% | 692.0 ± 3.2% | 2.554 | 5.267 | 29.627 | 3.602 | 24.484 |
| hex: http/json-16kx64 | 2097280 | 30784.1 ± 0.2% | 7680.4 ± 0.6% | 3522.8 ± 0.7% | 586.2 ± 1.4% | 5428.4 ± 5.5% | 771.5 ± 2.8% | 4.008 | 8.739 | 52.515 | 5.671 | 39.902 |
| hex: http/json-1m | 524290 | 33673.5 ± 0.3% | 7760.8 ± 0.4% | 3561.7 ± 1.1% | 599.3 ± 1.4% | 5492.1 ± 9.8% | 786.5 ± 3.1% | 4.339 | 9.454 | 56.186 | 6.131 | 42.814 |
| hex: http/js-1kx1024 | 2099200 | 16898.5 ± 1.2% | 6634.6 ± 0.3% | 3227.1 ± 2.6% | 441.2 ± 5.2% | 4649.6 ± 5.2% | 669.2 ± 8.8% | 2.547 | 5.236 | 38.299 | 3.634 | 25.251 |
| hex: http/js-16kx64 | 2097280 | 30812.8 ± 2.6% | 7678.0 ± 1.0% | 3514.1 ± 1.0% | 444.4 ± 2.2% | 5435.7 ± 0.5% | 769.8 ± 5.2% | 4.013 | 8.768 | 69.337 | 5.669 | 40.028 |
| hex: http/js-1m | 524290 | 33228.9 ± 2.4% | 7757.5 ± 0.8% | 3553.3 ± 0.5% | 466.3 ± 3.3% | 5524.3 ± 0.4% | 788.8 ± 4.4% | 4.283 | 9.351 | 71.267 | 6.015 | 42.127 |
| hex: http/css-1kx1024 | 2099200 | 16905.5 ± 0.8% | 6640.0 ± 0.8% | 3228.2 ± 0.2% | 497.2 ± 18.9% | 4673.4 ± 3.3% | 683.2 ± 21.3% | 2.546 | 5.237 | 34.001 | 3.617 | 24.744 |
| hex: http/css-16kx64 | 2097280 | 30860.2 ± 0.5% | 7675.4 ± 0.8% | 3522.9 ± 11.9% | 509.5 ± 0.6% | 5434.5 ± 0.4% | 781.8 ± 2.2% | 4.021 | 8.760 | 60.575 | 5.679 | 39.474 |
| hex: http/css-1m | 524290 | 33517.1 ± 0.5% | 7741.4 ± 0.4% | 3550.9 ± 1.3% | 500.6 ± 0.4% | 5520.9 ± 0.4% | 794.0 ± 3.3% | 4.330 | 9.439 | 66.955 | 6.071 | 42.215 |
| hex: shuffled/dickens-1m | 524290 | 33402.4 ± 0.5% | 7775.9 ± 0.3% | 3523.8 ± 0.6% | 445.2 ± 2.4% | 5527.6 ± 13.0% | 786.7 ± 10.5% | 4.296 | 9.479 | 75.023 | 6.043 | 42.461 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 960.8 ± 1.9% | 1025.7 ± 3.3% | 932.7 ± 3.9% | 259.7 ± 2.2% | 533.3 ± 0.7% | 251.9 ± 4.7% | 0.937 | 1.030 | 3.700 | 1.802 | 3.815 |
| qlog records, JSON text sequence | 1467503 | 801.4 ± 11.9% | 812.0 ± 0.3% | 771.0 ± 22.0% | 217.1 ± 8.6% | 551.8 ± 20.7% | 225.5 ± 5.2% | 0.987 | 1.039 | 3.691 | 1.452 | 3.554 |
| messages: 11 string members | 1025025 | 908.1 ± 0.8% | 1133.4 ± 0.4% | 663.0 ± 2.4% | 255.2 ± 4.3% | 448.6 ± 2.4% | 234.3 ± 5.6% | 0.801 | 1.370 | 3.559 | 2.024 | 3.876 |
| messages: 50 nested objects | 1121600 | 1063.5 ± 4.5% | 1001.6 ± 0.3% | 1096.2 ± 2.4% | 281.3 ± 0.7% | 689.5 ± 3.8% | 327.4 ± 2.1% | 1.062 | 0.970 | 3.781 | 1.542 | 3.248 |
| messages: a tree of 341 objects | 612600 | 406.7 ± 1.8% | 439.8 ± 0.2% | 439.2 ± 0.9% | 122.5 ± 1.7% | 445.5 ± 1.1% | 146.8 ± 0.5% | 0.925 | 0.926 | 3.321 | 0.913 | 2.770 |
| string: silesia/dickens | 172528 | 6223.3 ± 0.2% | 2850.9 ± 2.4% | 2094.5 ± 0.9% | 292.1 ± 8.1% | 2173.1 ± 1.1% | 476.6 ± 37.2% | 2.183 | 2.971 | 21.305 | 2.864 | 13.056 |
| string: silesia/nci | 1075110 | 5095.2 ± 0.3% | 3470.3 ± 0.2% | 2812.8 ± 0.7% | 467.5 ± 8.3% | 2330.9 ± 10.3% | 522.1 ± 2.2% | 1.468 | 1.811 | 10.898 | 2.186 | 9.759 |
| string: silesia/reymont | 1075159 | 3301.2 ± 1.0% | 2195.6 ± 0.6% | 1763.5 ± 3.6% | 303.0 ± 0.4% | 1621.4 ± 7.3% | 470.8 ± 1.1% | 1.504 | 1.872 | 10.894 | 2.036 | 7.012 |
| string: silesia/samba | 97582 | 3354.4 ± 0.2% | 2806.3 ± 2.8% | 1637.2 ± 1.4% | 252.8 ± 1.6% | 1279.8 ± 1.0% | 345.6 ± 2.8% | 1.195 | 2.049 | 13.269 | 2.621 | 9.707 |
| string: silesia/webster | 1098490 | 4104.6 ± 0.7% | 2029.2 ± 0.4% | 1633.7 ± 1.7% | 292.7 ± 1.0% | 1675.7 ± 1.3% | 440.4 ± 1.1% | 2.023 | 2.513 | 14.023 | 2.450 | 9.320 |
| string: silesia/xml | 1090118 | 5429.0 ± 1.6% | 3700.1 ± 2.0% | 2149.4 ± 2.5% | 378.2 ± 4.5% | 2350.2 ± 2.7% | 516.3 ± 6.7% | 1.467 | 2.526 | 14.356 | 2.310 | 10.514 |
| string: canterbury/alice29.txt | 159425 | 4874.8 ± 0.3% | 2417.0 ± 2.3% | 1880.7 ± 0.3% | 273.8 ± 2.9% | 1929.9 ± 1.2% | 421.5 ± 3.5% | 2.017 | 2.592 | 17.807 | 2.526 | 11.565 |
| string: canterbury/asyoulik.txt | 132198 | 3811.9 ± 5.8% | 2111.7 ± 0.5% | 1498.9 ± 12.4% | 263.6 ± 0.4% | 1572.8 ± 1.5% | 395.6 ± 2.4% | 1.805 | 2.543 | 14.461 | 2.424 | 9.636 |
| string: canterbury/lcet10.txt | 441884 | 6063.4 ± 0.7% | 2783.8 ± 1.0% | 1990.1 ± 0.7% | 313.2 ± 1.0% | 2137.3 ± 1.1% | 477.3 ± 1.2% | 2.178 | 3.047 | 19.362 | 2.837 | 12.704 |
| string: canterbury/plrabn12.txt | 503330 | 4721.3 ± 0.4% | 2701.3 ± 0.7% | 1694.8 ± 0.5% | 286.4 ± 0.4% | 2006.6 ± 0.6% | 454.1 ± 5.1% | 1.748 | 2.786 | 16.483 | 2.353 | 10.398 |
| string: canterbury-large/E.coli | 1048578 | 33714.4 ± 1.8% | 7759.0 ± 0.3% | 3549.0 ± 0.4% | 870.9 ± 0.9% | 5511.5 ± 0.6% | 798.6 ± 0.9% | 4.345 | 9.500 | 38.713 | 6.117 | 42.215 |
| string: canterbury-large/bible.txt | 1055886 | 9546.6 ± 3.6% | 3902.7 ± 0.4% | 2554.7 ± 1.2% | 334.3 ± 0.8% | 2960.8 ± 1.1% | 601.1 ± 1.5% | 2.446 | 3.737 | 28.556 | 3.224 | 15.882 |
| string: canterbury-large/world192.txt | 1103121 | 3744.0 ± 0.1% | 1974.6 ± 1.1% | 1656.8 ± 2.9% | 288.3 ± 2.5% | 1689.0 ± 6.6% | 430.0 ± 1.2% | 1.896 | 2.260 | 12.986 | 2.217 | 8.707 |
| string: http/html-1m | 1058582 | 7975.4 ± 1.6% | 3413.8 ± 2.0% | 2376.8 ± 14.5% | 379.1 ± 2.4% | 2713.7 ± 2.8% | 421.2 ± 4.6% | 2.336 | 3.356 | 21.040 | 2.939 | 18.935 |
| string: http/json-1m | 1190272 | 3322.7 ± 1.7% | 1201.2 ± 1.0% | 1481.4 ± 8.7% | 332.0 ± 4.2% | 812.1 ± 1.5% | 295.3 ± 1.6% | 2.766 | 2.243 | 10.009 | 4.091 | 11.252 |
| string: http/js-1m | 1144362 | 2658.6 ± 0.9% | 1324.2 ± 0.6% | 1193.8 ± 16.4% | 266.7 ± 0.8% | 1168.7 ± 1.4% | 295.4 ± 2.3% | 2.008 | 2.227 | 9.969 | 2.275 | 8.999 |
| string: http/css-1m | 1097820 | 3024.6 ± 0.2% | 2505.9 ± 0.5% | 1543.2 ± 1.7% | 344.4 ± 10.0% | 1509.2 ± 2.2% | 325.9 ± 2.7% | 1.207 | 1.960 | 8.782 | 2.004 | 9.281 |
| string: dickens as Cyrillic and CJK | 1883069 | 5339.1 ± 0.5% | 3168.4 ± 1.2% | 682.9 ± 7.0% | 278.0 ± 7.3% | 490.1 ± 3.3% | 137.9 ± 1.2% | 1.685 | 7.818 | 19.205 | 10.893 | 38.722 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1052.9 ± 8.6% | 1071.2 ± 1.4% | 930.0 ± 11.1% | 159.7 ± 0.5% | 384.7 ± 0.7% | 196.1 ± 5.4% | 0.983 | 1.132 | 6.591 | 2.737 | 5.368 |
| hex: silesia/dickens | 524290 | 33318.0 ± 0.2% | 7703.9 ± 1.0% | 3557.1 ± 0.3% | 434.9 ± 2.1% | 5508.0 ± 0.6% | 792.0 ± 4.0% | 4.325 | 9.367 | 76.607 | 6.049 | 42.070 |
| hex: silesia/mozilla | 524290 | 33823.3 ± 2.4% | 7712.4 ± 4.0% | 3524.6 ± 1.8% | 378.6 ± 3.3% | 5520.6 ± 0.5% | 788.3 ± 1.1% | 4.386 | 9.596 | 89.344 | 6.127 | 42.906 |
| hex: silesia/mr | 524290 | 33809.2 ± 1.0% | 7813.1 ± 1.4% | 3538.3 ± 0.6% | 548.8 ± 4.0% | 5490.9 ± 0.8% | 789.5 ± 0.8% | 4.327 | 9.555 | 61.603 | 6.157 | 42.825 |
| hex: silesia/nci | 524290 | 33413.0 ± 0.7% | 7744.7 ± 0.4% | 3528.6 ± 0.6% | 604.8 ± 6.1% | 5484.8 ± 8.8% | 784.8 ± 2.5% | 4.314 | 9.469 | 55.246 | 6.092 | 42.576 |
| hex: silesia/ooffice | 524290 | 33381.4 ± 0.7% | 7755.3 ± 0.5% | 3521.6 ± 0.6% | 332.6 ± 1.6% | 5499.1 ± 0.8% | 789.8 ± 0.9% | 4.304 | 9.479 | 100.358 | 6.070 | 42.263 |
| hex: silesia/osdb | 524290 | 33685.6 ± 0.1% | 7736.4 ± 0.6% | 3532.7 ± 1.1% | 423.7 ± 1.3% | 5480.7 ± 2.4% | 779.0 ± 3.1% | 4.354 | 9.535 | 79.506 | 6.146 | 43.243 |
| hex: silesia/reymont | 524290 | 33598.8 ± 16.1% | 7804.5 ± 1.2% | 3554.7 ± 0.4% | 453.3 ± 3.0% | 5522.2 ± 0.4% | 793.2 ± 3.1% | 4.305 | 9.452 | 74.113 | 6.084 | 42.361 |
| hex: silesia/samba | 524290 | 33363.7 ± 0.4% | 7767.2 ± 0.5% | 3517.3 ± 0.8% | 330.3 ± 14.3% | 5449.7 ± 5.3% | 790.3 ± 1.6% | 4.295 | 9.486 | 101.023 | 6.122 | 42.217 |
| hex: silesia/sao | 524290 | 33742.6 ± 0.3% | 7759.2 ± 6.4% | 3542.5 ± 1.7% | 273.0 ± 1.4% | 5503.3 ± 4.9% | 787.9 ± 3.9% | 4.349 | 9.525 | 123.601 | 6.131 | 42.826 |
| hex: silesia/webster | 524290 | 33515.6 ± 2.1% | 7752.7 ± 0.7% | 3527.4 ± 0.8% | 396.8 ± 0.8% | 5505.2 ± 0.3% | 783.4 ± 7.6% | 4.323 | 9.502 | 84.464 | 6.088 | 42.781 |
| hex: silesia/x-ray | 524290 | 33360.8 ± 0.8% | 7751.8 ± 1.1% | 3523.6 ± 0.7% | 396.3 ± 0.8% | 5475.9 ± 2.1% | 783.9 ± 1.4% | 4.304 | 9.468 | 84.173 | 6.092 | 42.559 |
| hex: silesia/xml | 524290 | 33261.9 ± 1.6% | 7753.2 ± 1.8% | 3519.6 ± 3.1% | 548.2 ± 1.9% | 5463.2 ± 2.4% | 788.9 ± 1.2% | 4.290 | 9.451 | 60.675 | 6.088 | 42.160 |
| hex: canterbury/alice29.txt | 304180 | 33864.8 ± 0.2% | 7735.5 ± 0.8% | 3525.8 ± 6.4% | 429.0 ± 7.4% | 5460.3 ± 1.3% | 793.7 ± 2.4% | 4.378 | 9.605 | 78.941 | 6.202 | 42.665 |
| hex: canterbury/asyoulik.txt | 250360 | 33506.7 ± 0.8% | 7762.8 ± 0.3% | 3541.8 ± 0.9% | 417.0 ± 2.7% | 5471.9 ± 0.7% | 794.2 ± 1.9% | 4.316 | 9.460 | 80.350 | 6.123 | 42.187 |
| hex: canterbury/cp.html | 49208 | 32862.5 ± 0.4% | 7783.1 ± 1.2% | 3568.1 ± 1.5% | 417.2 ± 1.6% | 5345.2 ± 0.7% | 788.8 ± 1.9% | 4.222 | 9.210 | 78.767 | 6.148 | 41.662 |
| hex: canterbury/fields.c | 22302 | 31793.4 ± 0.2% | 7706.8 ± 0.7% | 3593.6 ± 0.6% | 440.0 ± 2.5% | 5423.0 ± 1.3% | 767.8 ± 1.9% | 4.125 | 8.847 | 72.254 | 5.863 | 41.406 |
| hex: canterbury/grammar.lsp | 7444 | 27773.9 ± 0.9% | 7485.6 ± 1.8% | 3610.1 ± 2.0% | 497.1 ± 4.9% | 5315.1 ± 3.1% | 718.7 ± 6.2% | 3.710 | 7.693 | 55.876 | 5.225 | 38.647 |
| hex: canterbury/kennedy.xls | 524290 | 33384.0 ± 1.0% | 7713.0 ± 1.1% | 3556.6 ± 4.0% | 658.8 ± 19.6% | 5499.9 ± 0.3% | 788.7 ± 2.0% | 4.328 | 9.386 | 50.678 | 6.070 | 42.330 |
| hex: canterbury/lcet10.txt | 524290 | 33630.7 ± 1.0% | 7746.1 ± 0.5% | 3539.0 ± 3.8% | 436.5 ± 3.1% | 5493.0 ± 0.4% | 774.9 ± 3.0% | 4.342 | 9.503 | 77.048 | 6.123 | 43.398 |
| hex: canterbury/plrabn12.txt | 524290 | 33751.3 ± 0.9% | 7734.3 ± 0.9% | 3556.6 ± 1.0% | 420.1 ± 1.6% | 5497.8 ± 1.8% | 778.9 ± 11.6% | 4.364 | 9.490 | 80.338 | 6.139 | 43.331 |
| hex: canterbury/ptt5 | 524290 | 33576.4 ± 12.1% | 7747.1 ± 1.2% | 3545.4 ± 0.8% | 519.6 ± 6.9% | 5495.5 ± 0.9% | 788.8 ± 3.3% | 4.334 | 9.470 | 64.626 | 6.110 | 42.565 |
| hex: canterbury/sum | 76482 | 33323.0 ± 0.3% | 7812.6 ± 0.1% | 3573.0 ± 1.5% | 485.2 ± 4.2% | 5404.7 ± 1.2% | 772.9 ± 4.7% | 4.265 | 9.326 | 68.674 | 6.166 | 43.117 |
| hex: canterbury/xargs.1 | 8456 | 28331.0 ± 0.2% | 7527.9 ± 0.1% | 3572.9 ± 0.1% | 485.7 ± 0.9% | 5303.8 ± 1.6% | 782.0 ± 12.1% | 3.763 | 7.929 | 58.332 | 5.342 | 36.231 |
| hex: canterbury-large/E.coli | 524290 | 33711.3 ± 0.2% | 7727.0 ± 0.9% | 3559.4 ± 0.5% | 711.1 ± 1.0% | 5534.0 ± 0.5% | 781.3 ± 4.9% | 4.363 | 9.471 | 47.409 | 6.092 | 43.145 |
| hex: canterbury-large/bible.txt | 524290 | 33293.9 ± 2.3% | 7713.6 ± 1.6% | 3527.8 ± 1.3% | 463.3 ± 2.4% | 5525.6 ± 2.3% | 789.3 ± 1.9% | 4.316 | 9.438 | 71.865 | 6.025 | 42.184 |
| hex: canterbury-large/world192.txt | 524290 | 33415.5 ± 0.9% | 7756.3 ± 0.4% | 3413.7 ± 11.0% | 418.3 ± 1.0% | 5525.3 ± 0.4% | 788.1 ± 1.4% | 4.308 | 9.789 | 79.892 | 6.048 | 42.401 |
| hex: http/html-1kx1024 | 2099200 | 17105.6 ± 1.2% | 6635.3 ± 0.4% | 3225.2 ± 0.5% | 453.6 ± 3.1% | 4676.4 ± 1.9% | 688.0 ± 4.8% | 2.578 | 5.304 | 37.707 | 3.658 | 24.861 |
| hex: http/html-16kx64 | 2097280 | 30929.1 ± 0.3% | 7680.0 ± 0.4% | 3516.6 ± 7.9% | 461.5 ± 2.8% | 5436.1 ± 0.6% | 777.1 ± 6.0% | 4.027 | 8.795 | 67.025 | 5.690 | 39.800 |
| hex: http/html-1m | 524290 | 33677.2 ± 0.7% | 7762.8 ± 0.9% | 3539.5 ± 0.5% | 463.1 ± 2.4% | 5517.2 ± 17.4% | 776.4 ± 3.3% | 4.338 | 9.515 | 72.719 | 6.104 | 43.376 |
| hex: http/json-1kx1024 | 2099200 | 17137.1 ± 0.7% | 6633.6 ± 0.9% | 3217.0 ± 0.6% | 571.9 ± 1.7% | 4703.3 ± 0.8% | 692.0 ± 3.2% | 2.583 | 5.327 | 29.967 | 3.644 | 24.765 |
| hex: http/json-16kx64 | 2097280 | 30837.4 ± 2.0% | 7680.4 ± 0.6% | 3522.8 ± 0.7% | 586.2 ± 1.4% | 5428.4 ± 5.5% | 771.5 ± 2.8% | 4.015 | 8.754 | 52.605 | 5.681 | 39.971 |
| hex: http/json-1m | 524290 | 33686.0 ± 0.9% | 7760.8 ± 0.4% | 3561.7 ± 1.1% | 599.3 ± 1.4% | 5492.1 ± 9.8% | 786.5 ± 3.1% | 4.341 | 9.458 | 56.207 | 6.134 | 42.830 |
| hex: http/js-1kx1024 | 2099200 | 17132.2 ± 0.7% | 6634.6 ± 0.3% | 3227.1 ± 2.6% | 441.2 ± 5.2% | 4649.6 ± 5.2% | 669.2 ± 8.8% | 2.582 | 5.309 | 38.829 | 3.685 | 25.601 |
| hex: http/js-16kx64 | 2097280 | 30844.2 ± 0.7% | 7678.0 ± 1.0% | 3514.1 ± 1.0% | 444.4 ± 2.2% | 5435.7 ± 0.5% | 769.8 ± 5.2% | 4.017 | 8.777 | 69.407 | 5.674 | 40.068 |
| hex: http/js-1m | 524290 | 33237.0 ± 0.8% | 7757.5 ± 0.8% | 3553.3 ± 0.5% | 466.3 ± 3.3% | 5524.3 ± 0.4% | 788.8 ± 4.4% | 4.285 | 9.354 | 71.284 | 6.017 | 42.138 |
| hex: http/css-1kx1024 | 2099200 | 17131.6 ± 0.9% | 6640.0 ± 0.8% | 3228.2 ± 0.2% | 497.2 ± 18.9% | 4673.4 ± 3.3% | 683.2 ± 21.3% | 2.580 | 5.307 | 34.456 | 3.666 | 25.075 |
| hex: http/css-16kx64 | 2097280 | 30884.3 ± 0.8% | 7675.4 ± 0.8% | 3522.9 ± 11.9% | 509.5 ± 0.6% | 5434.5 ± 0.4% | 781.8 ± 2.2% | 4.024 | 8.767 | 60.623 | 5.683 | 39.505 |
| hex: http/css-1m | 524290 | 33618.4 ± 0.4% | 7741.4 ± 0.4% | 3550.9 ± 1.3% | 500.6 ± 0.4% | 5520.9 ± 0.4% | 794.0 ± 3.3% | 4.343 | 9.468 | 67.157 | 6.089 | 42.343 |
| hex: shuffled/dickens-1m | 524290 | 33388.6 ± 0.9% | 7775.9 ± 0.3% | 3523.8 ± 0.6% | 445.2 ± 2.4% | 5527.6 ± 13.0% | 786.7 ± 10.5% | 4.294 | 9.475 | 74.992 | 6.040 | 42.443 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1131.8 ± 8.1% | 1127.5 ± 3.2% | 856.0 ± 4.5% | 327.8 ± 3.2% | 344.4 ± 5.6% | 309.6 ± 34.8% | 1.004 | 1.322 | 3.453 | 3.286 | 3.656 |
| qlog records, JSON text sequence | 1467503 | 945.8 ± 1.1% | 857.7 ± 1.1% | 693.9 ± 2.3% | 312.2 ± 3.7% | 388.4 ± 3.9% | 223.1 ± 4.7% | 1.103 | 1.363 | 3.029 | 2.435 | 4.240 |
| messages: 11 string members | 1025025 | 1049.3 ± 17.3% | 880.1 ± 1.7% | 657.3 ± 7.6% | 288.7 ± 26.6% | 229.8 ± 31.6% | 231.6 ± 36.6% | 1.192 | 1.596 | 3.635 | 4.566 | 4.530 |
| messages: 50 nested objects | 1121600 | 1128.6 ± 5.7% | 1187.3 ± 3.6% | 922.0 ± 5.3% | 389.8 ± 5.7% | 430.4 ± 4.0% | 312.9 ± 2.7% | 0.951 | 1.224 | 2.896 | 2.622 | 3.608 |
| messages: a tree of 341 objects | 612600 | 406.0 ± 22.7% | 549.5 ± 11.6% | 348.6 ± 7.6% | 188.7 ± 5.9% | 246.8 ± 8.9% | 119.9 ± 7.1% | 0.739 | 1.165 | 2.151 | 1.645 | 3.387 |
| string: silesia/dickens | 172528 | 9203.3 ± 0.7% | 3019.7 ± 0.4% | 2064.6 ± 1.3% | 361.0 ± 0.9% | 1051.1 ± 1.6% | 563.2 ± 0.6% | 3.048 | 4.458 | 25.496 | 8.756 | 16.342 |
| string: silesia/nci | 1075110 | 8743.0 ± 0.9% | 3200.7 ± 1.7% | 2819.3 ± 0.4% | 774.8 ± 0.7% | 1094.3 ± 0.4% | 563.2 ± 0.7% | 2.732 | 3.101 | 11.284 | 7.989 | 15.524 |
| string: silesia/reymont | 1075159 | 3850.4 ± 1.5% | 1641.2 ± 1.6% | 1738.6 ± 5.0% | 372.3 ± 2.4% | 959.7 ± 3.0% | 551.1 ± 2.0% | 2.346 | 2.215 | 10.342 | 4.012 | 6.987 |
| string: silesia/samba | 97582 | 4645.5 ± 2.1% | 1962.8 ± 0.9% | 2104.7 ± 3.0% | 292.6 ± 7.7% | 894.3 ± 1.0% | 625.0 ± 7.2% | 2.367 | 2.207 | 15.876 | 5.194 | 7.432 |
| string: silesia/webster | 1098490 | 5104.2 ± 1.3% | 1626.5 ± 0.6% | 1546.6 ± 0.4% | 360.8 ± 0.8% | 935.1 ± 0.4% | 456.7 ± 0.8% | 3.138 | 3.300 | 14.145 | 5.458 | 11.177 |
| string: silesia/xml | 1090118 | 8001.4 ± 1.0% | 2671.8 ± 0.7% | 2161.8 ± 5.2% | 528.4 ± 0.8% | 1122.3 ± 0.4% | 562.3 ± 1.4% | 2.995 | 3.701 | 15.142 | 7.130 | 14.230 |
| string: canterbury/alice29.txt | 159425 | 9900.5 ± 2.4% | 2422.9 ± 2.7% | 1831.5 ± 0.4% | 340.4 ± 1.9% | 1027.0 ± 0.7% | 559.9 ± 0.6% | 4.086 | 5.406 | 29.083 | 9.641 | 17.684 |
| string: canterbury/asyoulik.txt | 132198 | 8028.5 ± 1.8% | 2164.4 ± 16.0% | 1570.8 ± 0.7% | 348.1 ± 1.2% | 906.0 ± 0.7% | 547.5 ± 0.3% | 3.709 | 5.111 | 23.061 | 8.862 | 14.663 |
| string: canterbury/lcet10.txt | 441884 | 8919.1 ± 2.9% | 2457.6 ± 1.3% | 1975.1 ± 2.2% | 394.9 ± 0.6% | 1034.4 ± 1.6% | 552.8 ± 0.5% | 3.629 | 4.516 | 22.587 | 8.623 | 16.133 |
| string: canterbury/plrabn12.txt | 503330 | 6072.5 ± 2.3% | 1838.0 ± 2.2% | 1682.2 ± 2.1% | 368.2 ± 3.7% | 998.5 ± 2.2% | 558.9 ± 1.6% | 3.304 | 3.610 | 16.491 | 6.082 | 10.865 |
| string: canterbury-large/E.coli | 1048578 | 38685.4 ± 3.0% | 11584.2 ± 1.5% | 3397.7 ± 0.6% | 1424.3 ± 0.5% | 1420.2 ± 1.4% | 572.0 ± 0.6% | 3.339 | 11.386 | 27.162 | 27.239 | 67.636 |
| string: canterbury-large/bible.txt | 1055886 | 7046.1 ± 0.4% | 3960.7 ± 1.4% | 2671.1 ± 0.2% | 439.4 ± 2.1% | 1198.2 ± 1.1% | 567.9 ± 1.0% | 1.779 | 2.638 | 16.037 | 5.880 | 12.408 |
| string: canterbury-large/world192.txt | 1103121 | 4886.3 ± 6.8% | 1438.9 ± 0.3% | 1604.9 ± 0.8% | 364.6 ± 11.0% | 928.1 ± 0.6% | 542.4 ± 0.5% | 3.396 | 3.045 | 13.400 | 5.265 | 9.009 |
| string: http/html-1m | 1058582 | 8545.5 ± 0.4% | 3878.4 ± 0.7% | 2492.2 ± 4.0% | 429.2 ± 1.6% | 1186.9 ± 0.8% | 522.7 ± 1.1% | 2.203 | 3.429 | 19.911 | 7.200 | 16.349 |
| string: http/json-1m | 1190272 | 6693.9 ± 0.4% | 1225.5 ± 0.6% | 1289.5 ± 0.5% | 414.1 ± 0.9% | 772.9 ± 3.5% | 509.6 ± 0.6% | 5.462 | 5.191 | 16.164 | 8.661 | 13.134 |
| string: http/js-1m | 1144362 | 5151.8 ± 0.4% | 988.6 ± 0.4% | 1115.3 ± 1.2% | 301.1 ± 2.0% | 781.8 ± 2.0% | 474.5 ± 14.0% | 5.211 | 4.619 | 17.108 | 6.589 | 10.858 |
| string: http/css-1m | 1097820 | 6929.7 ± 3.9% | 1279.8 ± 2.7% | 1614.3 ± 16.8% | 429.5 ± 9.9% | 854.5 ± 2.8% | 532.8 ± 1.5% | 5.415 | 4.293 | 16.134 | 8.110 | 13.005 |
| string: dickens as Cyrillic and CJK | 1883069 | 5359.5 ± 0.3% | 3019.7 ± 0.5% | 323.8 ± 3.0% | 272.5 ± 1.3% | 395.8 ± 1.1% | 292.9 ± 0.4% | 1.775 | 16.554 | 19.671 | 13.542 | 18.298 |
| hex: silesia/dickens | 524290 | 31151.8 ± 21.2% | 1569.2 ± 0.3% | 1093.8 ± 2.2% | 426.2 ± 1.4% | 785.8 ± 1.3% | 440.9 ± 7.7% | 19.852 | 28.479 | 73.093 | 39.643 | 70.657 |
| hex: silesia/mozilla | 524290 | 35228.6 ± 0.6% | 1568.9 ± 2.4% | 1094.0 ± 0.5% | 368.0 ± 1.3% | 785.9 ± 22.6% | 435.4 ± 1.6% | 22.454 | 32.202 | 95.732 | 44.824 | 80.914 |
| hex: silesia/mr | 524290 | 34880.3 ± 0.4% | 1565.8 ± 7.3% | 1085.1 ± 8.9% | 507.8 ± 0.4% | 787.5 ± 21.7% | 435.3 ± 2.6% | 22.276 | 32.146 | 68.686 | 44.294 | 80.134 |
| hex: silesia/nci | 524290 | 35296.6 ± 1.3% | 1573.1 ± 0.3% | 1093.6 ± 0.6% | 570.2 ± 3.0% | 789.4 ± 3.0% | 437.5 ± 1.9% | 22.438 | 32.276 | 61.904 | 44.712 | 80.675 |
| hex: silesia/ooffice | 524290 | 33637.8 ± 13.0% | 1566.3 ± 0.8% | 1091.0 ± 0.4% | 324.6 ± 1.2% | 786.2 ± 0.6% | 431.9 ± 2.7% | 21.476 | 30.833 | 103.642 | 42.785 | 77.888 |
| hex: silesia/osdb | 524290 | 32878.2 ± 0.5% | 1560.7 ± 1.1% | 1090.0 ± 2.5% | 414.5 ± 1.2% | 787.5 ± 2.2% | 439.4 ± 1.8% | 21.066 | 30.163 | 79.313 | 41.751 | 74.829 |
| hex: silesia/reymont | 524290 | 33821.2 ± 0.6% | 1559.8 ± 2.1% | 1088.4 ± 2.0% | 437.5 ± 7.5% | 787.3 ± 30.3% | 431.6 ± 3.1% | 21.682 | 31.075 | 77.308 | 42.960 | 78.362 |
| hex: silesia/samba | 524290 | 35414.5 ± 2.3% | 1562.1 ± 1.4% | 1091.1 ± 6.1% | 324.1 ± 0.7% | 783.0 ± 1.7% | 428.1 ± 2.3% | 22.672 | 32.459 | 109.272 | 45.231 | 82.730 |
| hex: silesia/sao | 524290 | 34174.0 ± 0.5% | 1568.6 ± 0.8% | 1094.9 ± 0.6% | 263.9 ± 1.7% | 785.0 ± 0.5% | 430.1 ± 1.2% | 21.787 | 31.212 | 129.478 | 43.532 | 79.461 |
| hex: silesia/webster | 524290 | 36110.6 ± 0.4% | 1570.8 ± 0.9% | 1092.4 ± 0.5% | 402.3 ± 2.4% | 787.8 ± 0.3% | 434.5 ± 0.8% | 22.989 | 33.055 | 89.767 | 45.835 | 83.114 |
| hex: silesia/x-ray | 524290 | 34050.2 ± 0.4% | 1565.0 ± 0.7% | 1089.8 ± 0.8% | 396.2 ± 1.6% | 786.4 ± 0.3% | 430.8 ± 1.4% | 21.757 | 31.245 | 85.949 | 43.298 | 79.038 |
| hex: silesia/xml | 524290 | 35126.7 ± 0.3% | 1565.5 ± 12.4% | 1093.4 ± 0.3% | 580.1 ± 5.0% | 787.3 ± 37.3% | 432.7 ± 1.1% | 22.437 | 32.125 | 60.554 | 44.618 | 81.179 |
| hex: canterbury/alice29.txt | 304180 | 33990.5 ± 2.2% | 1574.2 ± 6.6% | 1097.5 ± 0.5% | 421.1 ± 2.8% | 802.2 ± 7.3% | 432.6 ± 1.3% | 21.593 | 30.970 | 80.725 | 42.369 | 78.564 |
| hex: canterbury/asyoulik.txt | 250360 | 31449.1 ± 3.1% | 1572.5 ± 1.2% | 1087.2 ± 0.4% | 418.5 ± 1.5% | 802.7 ± 0.2% | 435.5 ± 5.1% | 20.000 | 28.927 | 75.144 | 39.179 | 72.221 |
| hex: canterbury/cp.html | 49208 | 31860.8 ± 1.0% | 1619.7 ± 3.4% | 1109.3 ± 1.9% | 463.5 ± 2.4% | 808.9 ± 2.3% | 444.4 ± 9.3% | 19.671 | 28.721 | 68.739 | 39.387 | 71.689 |
| hex: canterbury/fields.c | 22302 | 33174.0 ± 0.5% | 1599.4 ± 0.3% | 1099.8 ± 0.4% | 541.4 ± 0.2% | 805.4 ± 14.7% | 445.1 ± 3.2% | 20.741 | 30.165 | 61.273 | 41.190 | 74.537 |
| hex: canterbury/grammar.lsp | 7444 | 33424.6 ± 3.4% | 1642.5 ± 0.2% | 1120.5 ± 1.4% | 563.1 ± 1.3% | 816.7 ± 0.4% | 445.6 ± 2.1% | 20.349 | 29.829 | 59.359 | 40.928 | 75.012 |
| hex: canterbury/kennedy.xls | 524290 | 31285.8 ± 0.4% | 1565.3 ± 1.8% | 1094.0 ± 2.3% | 596.6 ± 1.1% | 792.4 ± 0.5% | 447.0 ± 0.6% | 19.987 | 28.599 | 52.443 | 39.480 | 69.993 |
| hex: canterbury/lcet10.txt | 524290 | 35646.3 ± 2.7% | 1570.6 ± 0.7% | 1093.2 ± 1.2% | 430.4 ± 0.3% | 790.7 ± 2.6% | 443.6 ± 1.7% | 22.696 | 32.606 | 82.820 | 45.081 | 80.360 |
| hex: canterbury/plrabn12.txt | 524290 | 34526.8 ± 1.5% | 1561.8 ± 1.7% | 1087.9 ± 0.6% | 416.2 ± 6.9% | 790.2 ± 0.7% | 439.1 ± 2.5% | 22.107 | 31.736 | 82.963 | 43.695 | 78.623 |
| hex: canterbury/ptt5 | 524290 | 34688.1 ± 1.4% | 1553.9 ± 27.0% | 1090.7 ± 4.1% | 486.0 ± 5.1% | 786.5 ± 1.2% | 434.5 ± 3.2% | 22.324 | 31.803 | 71.376 | 44.106 | 79.831 |
| hex: canterbury/sum | 76482 | 35682.4 ± 0.2% | 1600.4 ± 1.7% | 1101.0 ± 1.6% | 503.1 ± 1.6% | 807.2 ± 0.4% | 433.9 ± 1.0% | 22.296 | 32.410 | 70.930 | 44.203 | 82.228 |
| hex: canterbury/xargs.1 | 8456 | 35595.5 ± 0.5% | 1631.8 ± 0.9% | 1114.0 ± 0.3% | 567.4 ± 3.7% | 808.1 ± 0.4% | 427.0 ± 1.4% | 21.814 | 31.952 | 62.736 | 44.048 | 83.370 |
| hex: canterbury-large/E.coli | 524290 | 30723.8 ± 0.2% | 1553.2 ± 6.6% | 1089.1 ± 16.3% | 590.3 ± 2.9% | 781.8 ± 0.7% | 438.9 ± 2.2% | 19.781 | 28.211 | 52.051 | 39.298 | 69.997 |
| hex: canterbury-large/bible.txt | 524290 | 35477.7 ± 1.8% | 1572.4 ± 1.1% | 1093.7 ± 1.4% | 439.5 ± 4.5% | 788.3 ± 0.4% | 434.5 ± 1.3% | 22.563 | 32.438 | 80.726 | 45.003 | 81.649 |
| hex: canterbury-large/world192.txt | 524290 | 33546.2 ± 1.8% | 1559.4 ± 1.3% | 1092.4 ± 2.5% | 404.7 ± 4.7% | 781.3 ± 3.2% | 429.3 ± 3.3% | 21.512 | 30.707 | 82.893 | 42.937 | 78.140 |
| hex: http/html-1kx1024 | 2099200 | 24631.8 ± 7.8% | 1611.8 ± 1.0% | 1088.7 ± 0.3% | 457.9 ± 2.3% | 803.7 ± 2.6% | 438.7 ± 4.4% | 15.282 | 22.626 | 53.795 | 30.649 | 56.141 |
| hex: http/html-16kx64 | 2097280 | 30109.3 ± 2.0% | 1610.3 ± 0.3% | 1105.2 ± 0.4% | 456.3 ± 0.1% | 787.2 ± 0.9% | 446.1 ± 2.0% | 18.698 | 27.243 | 65.985 | 38.250 | 67.495 |
| hex: http/html-1m | 524290 | 31473.2 ± 0.5% | 1558.2 ± 2.1% | 1090.2 ± 0.7% | 445.7 ± 8.2% | 785.7 ± 0.3% | 447.2 ± 2.6% | 20.199 | 28.870 | 70.611 | 40.060 | 70.381 |
| hex: http/json-1kx1024 | 2099200 | 24591.0 ± 0.3% | 1612.9 ± 4.2% | 1089.4 ± 2.1% | 566.0 ± 2.2% | 807.1 ± 2.7% | 442.9 ± 3.1% | 15.246 | 22.573 | 43.444 | 30.469 | 55.520 |
| hex: http/json-16kx64 | 2097280 | 30432.3 ± 0.6% | 1608.1 ± 1.1% | 1104.0 ± 1.5% | 565.6 ± 0.7% | 775.6 ± 0.8% | 442.8 ± 4.7% | 18.924 | 27.564 | 53.802 | 39.236 | 68.721 |
| hex: http/json-1m | 524290 | 31340.9 ± 5.3% | 1549.8 ± 0.5% | 1088.9 ± 0.7% | 593.2 ± 0.2% | 792.0 ± 3.0% | 443.7 ± 1.9% | 20.223 | 28.782 | 52.835 | 39.573 | 70.631 |
| hex: http/js-1kx1024 | 2099200 | 24788.5 ± 0.7% | 1609.2 ± 0.1% | 1088.8 ± 0.7% | 440.2 ± 2.3% | 804.2 ± 0.3% | 432.2 ± 3.7% | 15.404 | 22.766 | 56.311 | 30.825 | 57.348 |
| hex: http/js-16kx64 | 2097280 | 30050.4 ± 5.4% | 1606.9 ± 0.6% | 1104.1 ± 0.3% | 440.0 ± 1.9% | 801.6 ± 1.1% | 434.4 ± 2.2% | 18.701 | 27.216 | 68.303 | 37.487 | 69.182 |
| hex: http/js-1m | 524290 | 31980.0 ± 0.5% | 1556.5 ± 0.4% | 1090.7 ± 0.5% | 450.7 ± 8.5% | 788.5 ± 0.3% | 437.5 ± 1.5% | 20.546 | 29.321 | 70.959 | 40.558 | 73.101 |
| hex: http/css-1kx1024 | 2099200 | 24589.9 ± 0.7% | 1612.2 ± 0.4% | 1088.1 ± 0.4% | 501.2 ± 0.8% | 807.1 ± 0.1% | 444.4 ± 2.2% | 15.253 | 22.599 | 49.062 | 30.468 | 55.333 |
| hex: http/css-16kx64 | 2097280 | 30587.6 ± 2.5% | 1608.6 ± 2.5% | 1101.6 ± 2.8% | 493.5 ± 2.6% | 772.0 ± 3.0% | 441.5 ± 3.3% | 19.015 | 27.768 | 61.980 | 39.619 | 69.278 |
| hex: http/css-1m | 524290 | 30947.9 ± 3.4% | 1551.7 ± 1.8% | 1088.3 ± 0.5% | 485.4 ± 0.8% | 786.4 ± 0.4% | 435.8 ± 1.6% | 19.945 | 28.438 | 63.753 | 39.353 | 71.018 |
| hex: shuffled/dickens-1m | 524290 | 33072.6 ± 17.9% | 1554.2 ± 0.5% | 1089.6 ± 0.4% | 427.1 ± 0.9% | 784.1 ± 6.6% | 444.9 ± 1.4% | 21.280 | 30.352 | 77.438 | 42.177 | 74.344 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- messages: 11 string members, decoding: stdx runs at 0.707 of simdjson.
- messages: 50 nested objects, decoding: stdx runs at 0.928 of yyjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.880 of simdjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.881 of yyjson.
- messages: a tree of 341 objects, decoding: stdx runs at 0.868 of serde_json.
- messages: a tree of 341 objects, encoding: stdx runs at 0.779 of simdjson.
- messages: a tree of 341 objects, encoding with J11's loop unchecked: stdx runs at 0.828 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.815 of simdjson.
- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.896 of yyjson.
- messages: 11 string members, decoding through TextReader.next: stdx runs at 0.690 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.925 of simdjson.
- messages: 50 nested objects, decoding through TextReader.next: stdx runs at 0.846 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.712 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.713 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next: stdx runs at 0.703 of serde_json.
- CLDR supplemental, 34 texts, decoding through TextReader.next_items: stdx runs at 0.937 of simdjson.
- messages: 11 string members, decoding through TextReader.next_items: stdx runs at 0.801 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.925 of simdjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.926 of yyjson.
- messages: a tree of 341 objects, decoding through TextReader.next_items: stdx runs at 0.913 of serde_json.
- messages: a tree of 341 objects, encoding through TextWriter's methods: stdx runs at 0.739 of simdjson.
