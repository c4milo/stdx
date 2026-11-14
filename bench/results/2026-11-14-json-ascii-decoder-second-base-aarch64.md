# bench-json

| Field | Value |
|---|---|
| Commit | f607235 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43625753773 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.4 ± 0.4% | 0.523 | 0.966 | 0.998 | 0.997 | 0.460 | 1.003 | 1.006 | 0.388 | 0.830 | 0.899 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 845.4 ± 1.4% | 0.824 | 1.010 | 1.009 | 1.010 | 0.450 | 1.005 | 1.035 | 0.398 | 0.926 | 0.988 | 0.123 |
| string: silesia/dickens | 172528 | 5042.1 ± 0.5% | 0.033 | 0.783 | 1.004 | 1.006 | 0.196 | 1.017 | 1.007 | 0.197 | 1.003 | 1.003 | 0.032 |
| string: silesia/nci | 1075110 | 4301.4 ± 0.6% | 0.038 | 0.800 | 1.003 | 1.001 | 0.279 | 1.003 | 0.996 | 0.279 | 1.002 | 1.001 | 0.038 |
| string: silesia/reymont | 1075159 | 2923.8 ± 1.6% | 0.057 | 0.823 | 1.012 | 1.016 | 0.361 | 1.008 | 1.015 | 0.361 | 1.031 | 1.035 | 0.056 |
| string: silesia/samba | 97582 | 3490.3 ± 0.8% | 0.039 | 0.863 | 1.004 | 1.007 | 0.069 | 0.779 | 1.012 | 0.073 | 1.004 | 1.007 | 0.039 |
| string: silesia/webster | 1098490 | 3640.4 ± 0.2% | 0.044 | 0.847 | 1.002 | 1.005 | 0.204 | 1.016 | 1.013 | 0.204 | 1.009 | 1.007 | 0.044 |
| string: silesia/xml | 1090118 | 4766.4 ± 0.4% | 0.035 | 0.808 | 1.004 | 1.007 | 0.223 | 0.981 | 1.009 | 0.225 | 1.006 | 1.007 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4303.7 ± 0.6% | 0.038 | 0.752 | 1.005 | 1.009 | 0.172 | 1.040 | 1.020 | 0.172 | 1.015 | 1.017 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3449.8 ± 0.6% | 0.046 | 0.750 | 1.005 | 1.010 | 0.177 | 1.004 | 0.974 | 0.176 | 1.016 | 1.015 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5090.4 ± 0.4% | 0.032 | 0.818 | 1.004 | 1.005 | 0.196 | 1.024 | 1.009 | 0.196 | 1.006 | 1.004 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4118.1 ± 0.5% | 0.039 | 0.824 | 1.003 | 1.003 | 0.199 | 1.008 | 0.995 | 0.198 | 1.005 | 1.000 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 18884.7 ± 1.2% | 0.078 | 1.007 | 1.004 | 1.001 | 0.486 | 0.999 | 1.004 | 0.486 | 0.631 | 0.631 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6641.0 ± 1.3% | 0.026 | 0.808 | 1.002 | 1.006 | 0.435 | 1.028 | 1.046 | 0.436 | 1.036 | 1.040 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3372.4 ± 1.2% | 0.047 | 0.848 | 1.003 | 1.004 | 0.199 | 1.018 | 1.007 | 0.198 | 1.005 | 1.005 | 0.047 |
| string: http/html-1m | 1058582 | 6018.5 ± 1.8% | 0.028 | 0.787 | 1.027 | 1.046 | 0.391 | 1.047 | 1.056 | 0.391 | 1.027 | 1.034 | 0.028 |
| string: http/json-1m | 1190272 | 2540.6 ± 0.3% | 0.055 | 0.951 | 1.003 | 1.006 | 0.111 | 1.006 | 0.472 | 0.111 | 1.006 | 1.007 | 0.054 |
| string: http/js-1m | 1144362 | 2276.6 ± 0.7% | 0.066 | 0.891 | 1.004 | 1.004 | 0.175 | 1.056 | 1.046 | 0.175 | 1.003 | 1.002 | 0.065 |
| string: http/css-1m | 1097820 | 2630.0 ± 0.6% | 0.060 | 0.776 | 1.005 | 1.009 | 0.241 | 1.010 | 1.014 | 0.240 | 1.008 | 1.009 | 0.059 |
| string: dickens as Cyrillic and CJK | 1883069 | 3048.8 ± 0.8% | 0.044 | 0.125 | 1.009 | 1.006 | 0.339 | 1.006 | 1.016 | 0.339 | 1.009 | 1.010 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1325.5 ± 1.3% | 0.082 | 1.004 | 1.003 | 1.003 | 0.077 | 0.638 | 1.004 | 0.081 | 1.003 | 1.003 | 0.081 |
| hex: silesia/dickens | 524290 | 18939.9 ± 1.4% | 0.079 | 1.005 | 1.005 | 1.007 | 0.518 | 1.006 | 0.995 | 0.516 | 0.633 | 0.634 | 0.009 |
| hex: silesia/mozilla | 524290 | 18841.9 ± 1.0% | 0.079 | 1.004 | 0.999 | 0.996 | 0.513 | 0.999 | 0.994 | 0.511 | 0.636 | 0.636 | 0.009 |
| hex: silesia/mr | 524290 | 18770.9 ± 0.4% | 0.079 | 1.006 | 1.000 | 1.000 | 0.516 | 1.006 | 1.003 | 0.517 | 0.638 | 0.639 | 0.009 |
| hex: silesia/nci | 524290 | 18954.8 ± 0.6% | 0.078 | 1.003 | 1.000 | 1.002 | 0.502 | 0.998 | 0.995 | 0.502 | 0.632 | 0.632 | 0.009 |
| hex: silesia/ooffice | 524290 | 18762.8 ± 0.6% | 0.079 | 1.006 | 1.000 | 1.001 | 0.515 | 1.000 | 0.999 | 0.513 | 0.639 | 0.639 | 0.009 |
| hex: silesia/osdb | 524290 | 18738.9 ± 0.7% | 0.079 | 1.002 | 0.997 | 0.998 | 0.512 | 0.997 | 0.997 | 0.512 | 0.639 | 0.639 | 0.009 |
| hex: silesia/reymont | 524290 | 18746.3 ± 0.3% | 0.079 | 1.010 | 1.001 | 1.001 | 0.526 | 1.002 | 1.001 | 0.525 | 0.639 | 0.639 | 0.009 |
| hex: silesia/samba | 524290 | 18597.5 ± 0.7% | 0.080 | 1.003 | 1.002 | 1.001 | 0.506 | 1.004 | 1.003 | 0.506 | 0.643 | 0.640 | 0.009 |
| hex: silesia/sao | 524290 | 18884.6 ± 1.2% | 0.079 | 1.008 | 0.995 | 0.996 | 0.507 | 1.007 | 1.002 | 0.509 | 0.634 | 0.634 | 0.009 |
| hex: silesia/webster | 524290 | 19056.5 ± 0.9% | 0.078 | 0.999 | 0.994 | 0.994 | 0.501 | 0.995 | 0.994 | 0.501 | 0.629 | 0.629 | 0.009 |
| hex: silesia/x-ray | 524290 | 18808.1 ± 0.4% | 0.079 | 1.002 | 1.001 | 1.001 | 0.525 | 0.996 | 0.999 | 0.523 | 0.639 | 0.639 | 0.009 |
| hex: silesia/xml | 524290 | 19076.8 ± 0.6% | 0.078 | 1.000 | 1.000 | 1.000 | 0.509 | 0.998 | 0.995 | 0.512 | 0.629 | 0.629 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19265.0 ± 1.2% | 0.078 | 1.004 | 0.991 | 0.990 | 0.516 | 1.000 | 0.997 | 0.517 | 0.623 | 0.623 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 18910.9 ± 0.4% | 0.079 | 1.028 | 1.028 | 1.028 | 0.528 | 1.028 | 1.029 | 0.528 | 0.634 | 0.634 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19282.1 ± 0.2% | 0.083 | 1.002 | 1.001 | 1.000 | 0.541 | 1.002 | 1.002 | 0.542 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18821.5 ± 0.9% | 0.080 | 1.007 | 1.008 | 1.008 | 0.535 | 1.004 | 1.008 | 0.542 | 0.626 | 0.626 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17440.2 ± 1.1% | 0.089 | 1.009 | 1.009 | 1.010 | 0.528 | 1.008 | 1.008 | 0.546 | 0.645 | 0.648 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18699.6 ± 1.6% | 0.079 | 1.003 | 0.999 | 1.000 | 0.521 | 0.998 | 0.997 | 0.520 | 0.641 | 0.641 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18998.1 ± 1.7% | 0.078 | 1.002 | 0.997 | 0.998 | 0.509 | 0.993 | 0.993 | 0.510 | 0.632 | 0.632 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18820.5 ± 0.8% | 0.079 | 1.001 | 0.996 | 0.995 | 0.509 | 0.998 | 0.994 | 0.509 | 0.636 | 0.637 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 18668.2 ± 0.5% | 0.080 | 1.006 | 1.003 | 1.002 | 0.526 | 1.000 | 1.002 | 0.527 | 0.643 | 0.643 | 0.009 |
| hex: canterbury/sum | 76482 | 19268.4 ± 0.1% | 0.078 | 1.002 | 1.003 | 1.003 | 0.518 | 1.003 | 1.002 | 0.520 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17812.2 ± 0.1% | 0.088 | 1.002 | 1.003 | 1.003 | 0.525 | 1.001 | 1.002 | 0.541 | 0.637 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18872.8 ± 1.7% | 0.079 | 1.011 | 0.996 | 0.995 | 0.510 | 1.001 | 1.001 | 0.511 | 0.636 | 0.636 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18718.3 ± 1.3% | 0.079 | 1.007 | 1.003 | 1.006 | 0.508 | 1.002 | 1.000 | 0.511 | 0.640 | 0.640 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18725.6 ± 0.4% | 0.080 | 1.001 | 1.003 | 1.001 | 0.523 | 0.994 | 1.000 | 0.524 | 0.642 | 0.642 | 0.009 |
| hex: http/html-1kx1024 | 2099200 | 9559.6 ± 17.8% | 0.150 | 1.251 | 1.249 | 1.247 | 0.693 | 1.257 | 0.972 | 0.752 | 0.924 | 0.930 | 0.018 |
| hex: http/html-16kx64 | 2097280 | 18335.6 ± 1.2% | 0.082 | 1.011 | 1.012 | 1.012 | 0.558 | 1.011 | 0.997 | 0.562 | 0.641 | 0.641 | 0.009 |
| hex: http/html-1m | 524290 | 18505.1 ± 1.9% | 0.081 | 1.007 | 1.008 | 1.006 | 0.519 | 1.010 | 1.010 | 0.520 | 0.646 | 0.649 | 0.009 |
| hex: http/json-1kx1024 | 2099200 | 9390.9 ± 19.1% | 0.152 | 1.278 | 1.272 | 1.271 | 0.697 | 1.278 | 0.972 | 0.755 | 0.933 | 0.936 | 0.018 |
| hex: http/json-16kx64 | 2097280 | 18385.2 ± 1.2% | 0.082 | 1.011 | 1.010 | 1.010 | 0.555 | 1.010 | 0.993 | 0.561 | 0.640 | 0.640 | 0.009 |
| hex: http/json-1m | 524290 | 18863.1 ± 2.8% | 0.079 | 0.998 | 0.990 | 0.992 | 0.511 | 0.999 | 0.995 | 0.512 | 0.636 | 0.636 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 9418.3 ± 15.4% | 0.151 | 1.269 | 1.272 | 1.276 | 0.701 | 1.261 | 1.003 | 0.759 | 0.937 | 0.940 | 0.018 |
| hex: http/js-16kx64 | 2097280 | 18345.8 ± 1.1% | 0.082 | 1.012 | 1.011 | 1.012 | 0.556 | 1.011 | 0.995 | 0.560 | 0.641 | 0.641 | 0.009 |
| hex: http/js-1m | 524290 | 19017.0 ± 0.5% | 0.078 | 0.999 | 0.997 | 0.989 | 0.507 | 0.988 | 0.986 | 0.505 | 0.631 | 0.631 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 10594.6 ± 17.1% | 0.134 | 1.125 | 1.130 | 1.131 | 0.625 | 1.137 | 0.962 | 0.678 | 0.832 | 0.837 | 0.016 |
| hex: http/css-16kx64 | 2097280 | 18432.2 ± 0.5% | 0.081 | 1.011 | 1.006 | 1.006 | 0.553 | 1.007 | 0.992 | 0.559 | 0.638 | 0.639 | 0.009 |
| hex: http/css-1m | 524290 | 18974.4 ± 1.8% | 0.078 | 1.005 | 1.004 | 0.998 | 0.503 | 0.998 | 1.000 | 0.503 | 0.632 | 0.631 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18760.7 ± 0.5% | 0.079 | 0.997 | 0.999 | 0.997 | 0.510 | 1.004 | 1.001 | 0.511 | 0.638 | 0.637 | 0.009 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1473.7 ± 0.4% | 0.446 | 1.001 | 0.969 | 1.006 | 1.008 | 0.269 | 0.999 | 0.548 | 0.917 | 0.089 | 1.028 |
| qlog records, JSON text sequence | 1467503 | 1260.2 ± 0.7% | 0.694 | 0.979 | 1.015 | 1.013 | 1.017 | 0.266 | 1.005 | 0.502 | 0.832 | 0.106 | 1.021 |
| string: silesia/dickens | 172528 | 6893.3 ± 0.2% | 0.025 | 1.000 | 1.002 | 1.001 | 1.002 | 0.167 | 0.717 | 1.004 | 1.003 | 0.025 | 1.035 |
| string: silesia/nci | 1075110 | 7301.3 ± 0.2% | 0.023 | 1.001 | 1.001 | 1.000 | 1.002 | 0.212 | 0.565 | 0.999 | 1.000 | 0.024 | 1.007 |
| string: silesia/reymont | 1075159 | 3341.0 ± 0.8% | 0.051 | 1.004 | 1.007 | 1.004 | 1.003 | 0.390 | 0.869 | 1.001 | 0.995 | 0.052 | 1.046 |
| string: silesia/samba | 97582 | 4185.9 ± 0.9% | 0.053 | 1.004 | 1.000 | 1.006 | 1.007 | 0.125 | 0.940 | 1.002 | 1.003 | 0.054 | 1.093 |
| string: silesia/webster | 1098490 | 4049.4 ± 0.2% | 0.042 | 1.009 | 1.009 | 1.009 | 1.007 | 0.213 | 0.886 | 1.000 | 1.005 | 0.043 | 1.010 |
| string: silesia/xml | 1090118 | 6108.9 ± 0.4% | 0.029 | 1.006 | 0.997 | 1.002 | 1.003 | 0.255 | 0.777 | 1.003 | 1.003 | 0.029 | 1.017 |
| string: canterbury/alice29.txt | 159425 | 6409.5 ± 0.5% | 0.027 | 1.009 | 1.010 | 1.012 | 1.013 | 0.133 | 0.654 | 1.003 | 1.007 | 0.027 | 1.064 |
| string: canterbury/asyoulik.txt | 132198 | 5609.5 ± 1.2% | 0.030 | 1.022 | 1.028 | 1.030 | 1.032 | 0.129 | 0.595 | 1.002 | 1.013 | 0.030 | 1.053 |
| string: canterbury/lcet10.txt | 441884 | 6222.3 ± 0.7% | 0.028 | 1.008 | 1.008 | 1.008 | 1.011 | 0.186 | 0.802 | 1.004 | 1.005 | 0.028 | 1.005 |
| string: canterbury/plrabn12.txt | 503330 | 5709.3 ± 0.4% | 0.030 | 1.002 | 1.004 | 1.003 | 1.003 | 0.169 | 0.696 | 1.001 | 1.003 | 0.030 | 1.006 |
| string: canterbury-large/E.coli | 1048578 | 19273.9 ± 0.6% | 0.077 | 1.002 | 1.003 | 1.001 | 1.004 | 0.477 | 1.005 | 1.002 | 1.002 | 0.009 | 1.002 |
| string: canterbury-large/bible.txt | 1055886 | 6789.3 ± 0.5% | 0.026 | 1.000 | 1.001 | 1.002 | 1.002 | 0.495 | 0.979 | 1.001 | 1.001 | 0.026 | 1.000 |
| string: canterbury-large/world192.txt | 1103121 | 4008.8 ± 0.3% | 0.043 | 1.018 | 1.019 | 1.020 | 1.018 | 0.194 | 0.833 | 1.003 | 1.011 | 0.043 | 1.008 |
| string: http/html-1m | 1058582 | 6743.3 ± 0.5% | 0.026 | 1.005 | 0.924 | 1.001 | 1.004 | 0.405 | 0.881 | 1.000 | 1.003 | 0.026 | 1.011 |
| string: http/json-1m | 1190272 | 3150.3 ± 0.4% | 0.050 | 1.006 | 0.968 | 1.004 | 1.008 | 0.133 | 0.373 | 1.003 | 1.004 | 0.051 | 1.047 |
| string: http/js-1m | 1144362 | 2750.8 ± 0.3% | 0.061 | 1.004 | 1.010 | 1.001 | 1.007 | 0.166 | 0.840 | 1.000 | 1.005 | 0.061 | 1.014 |
| string: http/css-1m | 1097820 | 3971.5 ± 0.5% | 0.042 | 1.010 | 1.011 | 1.016 | 1.014 | 0.209 | 0.649 | 1.003 | 1.006 | 0.043 | 1.016 |
| string: dickens as Cyrillic and CJK | 1883069 | 3062.3 ± 0.4% | 0.048 | 1.002 | 0.124 | 1.001 | 1.002 | 0.321 | 1.004 | 1.001 | 1.002 | 0.048 | 1.002 |
| hex: silesia/dickens | 524290 | 15600.2 ± 0.1% | 1.000 | 0.178 | 1.002 | 1.001 | 1.001 | 1.001 | 1.002 | 1.002 | 1.003 | 0.178 | 1.001 |
| hex: silesia/mozilla | 524290 | 15632.8 ± 0.2% | 1.002 | 0.178 | 1.002 | 1.001 | 1.000 | 1.001 | 1.000 | 1.000 | 1.001 | 0.178 | 0.998 |
| hex: silesia/mr | 524290 | 15630.9 ± 0.2% | 1.001 | 0.179 | 1.003 | 1.002 | 1.002 | 1.002 | 1.003 | 1.002 | 1.003 | 0.179 | 1.002 |
| hex: silesia/nci | 524290 | 15659.2 ± 0.1% | 1.001 | 0.178 | 0.999 | 1.001 | 1.000 | 0.995 | 0.998 | 0.999 | 0.998 | 0.177 | 1.000 |
| hex: silesia/ooffice | 524290 | 15591.0 ± 0.2% | 1.001 | 0.178 | 1.002 | 1.000 | 1.001 | 1.002 | 1.002 | 1.002 | 1.003 | 0.178 | 1.000 |
| hex: silesia/osdb | 524290 | 15644.2 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.002 | 1.001 | 1.000 | 1.002 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: silesia/reymont | 524290 | 15631.3 ± 0.3% | 1.001 | 0.177 | 1.001 | 1.002 | 1.003 | 1.001 | 1.000 | 1.001 | 1.003 | 0.177 | 1.003 |
| hex: silesia/samba | 524290 | 15663.2 ± 0.1% | 1.002 | 0.178 | 0.999 | 1.002 | 1.000 | 0.996 | 1.000 | 1.001 | 1.000 | 0.177 | 1.001 |
| hex: silesia/sao | 524290 | 15643.8 ± 0.2% | 1.001 | 0.177 | 0.997 | 0.997 | 0.999 | 0.998 | 0.997 | 0.997 | 0.998 | 0.177 | 0.997 |
| hex: silesia/webster | 524290 | 15664.8 ± 0.2% | 1.002 | 0.177 | 1.001 | 1.002 | 1.002 | 0.999 | 0.998 | 1.002 | 0.999 | 0.177 | 1.002 |
| hex: silesia/x-ray | 524290 | 15603.3 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 1.001 | 1.003 | 1.002 | 1.002 | 0.178 | 1.001 |
| hex: silesia/xml | 524290 | 15621.1 ± 0.4% | 1.001 | 0.178 | 1.000 | 1.001 | 1.001 | 0.999 | 1.001 | 1.000 | 1.000 | 0.178 | 1.001 |
| hex: canterbury/alice29.txt | 304180 | 15672.8 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 1.000 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15670.0 ± 0.1% | 1.002 | 0.178 | 1.002 | 1.002 | 1.002 | 1.001 | 1.002 | 1.000 | 1.002 | 0.177 | 1.002 |
| hex: canterbury/cp.html | 49208 | 15599.4 ± 0.3% | 1.001 | 0.179 | 1.001 | 1.001 | 1.001 | 0.998 | 1.001 | 1.002 | 1.004 | 0.178 | 1.002 |
| hex: canterbury/fields.c | 22302 | 15424.1 ± 0.1% | 1.002 | 0.181 | 1.001 | 1.001 | 1.001 | 0.995 | 1.001 | 1.003 | 1.006 | 0.180 | 1.002 |
| hex: canterbury/grammar.lsp | 7444 | 14913.7 ± 0.2% | 1.005 | 0.186 | 1.001 | 1.001 | 1.001 | 0.984 | 1.001 | 1.005 | 1.016 | 0.184 | 1.005 |
| hex: canterbury/kennedy.xls | 524290 | 15626.8 ± 0.5% | 1.002 | 0.178 | 1.001 | 1.002 | 1.003 | 1.000 | 1.001 | 1.001 | 1.002 | 0.178 | 1.002 |
| hex: canterbury/lcet10.txt | 524290 | 15604.6 ± 0.1% | 1.002 | 0.178 | 1.002 | 1.002 | 1.001 | 1.001 | 1.001 | 1.003 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/plrabn12.txt | 524290 | 15634.6 ± 0.2% | 0.999 | 0.177 | 1.001 | 0.999 | 1.001 | 1.001 | 1.001 | 0.999 | 1.000 | 0.177 | 1.000 |
| hex: canterbury/ptt5 | 524290 | 15620.0 ± 0.1% | 1.000 | 0.179 | 0.999 | 1.000 | 0.999 | 0.998 | 1.000 | 1.000 | 1.000 | 0.178 | 1.000 |
| hex: canterbury/sum | 76482 | 15634.9 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.001 | 1.000 | 0.999 | 1.001 | 1.001 | 1.003 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 14981.4 ± 0.2% | 1.003 | 0.185 | 1.001 | 1.001 | 1.000 | 0.986 | 1.001 | 1.005 | 1.015 | 0.183 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 15649.2 ± 0.5% | 1.000 | 0.177 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 0.178 | 1.000 |
| hex: canterbury-large/bible.txt | 524290 | 15621.2 ± 0.3% | 1.001 | 0.178 | 1.001 | 1.002 | 1.001 | 1.000 | 1.000 | 0.998 | 0.998 | 0.178 | 1.000 |
| hex: canterbury-large/world192.txt | 524290 | 15609.8 ± 0.4% | 1.002 | 0.178 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 1.002 | 1.001 | 0.178 | 1.002 |
| hex: http/html-1kx1024 | 2099200 | 13669.1 ± 0.5% | 1.007 | 0.195 | 1.001 | 1.003 | 1.003 | 0.942 | 0.998 | 1.011 | 1.039 | 0.187 | 1.015 |
| hex: http/html-16kx64 | 2097280 | 15271.7 ± 0.3% | 0.999 | 0.181 | 0.997 | 1.002 | 1.001 | 0.989 | 0.996 | 1.001 | 1.007 | 0.179 | 1.002 |
| hex: http/html-1m | 524290 | 15662.5 ± 0.2% | 1.001 | 0.177 | 1.000 | 1.000 | 1.000 | 0.997 | 0.997 | 0.999 | 1.000 | 0.177 | 1.000 |
| hex: http/json-1kx1024 | 2099200 | 13701.3 ± 0.3% | 1.007 | 0.195 | 0.993 | 1.001 | 0.999 | 0.939 | 0.998 | 1.011 | 1.033 | 0.187 | 1.011 |
| hex: http/json-16kx64 | 2097280 | 15225.0 ± 0.5% | 1.004 | 0.181 | 1.002 | 1.001 | 1.002 | 0.993 | 1.000 | 1.008 | 1.011 | 0.180 | 1.002 |
| hex: http/json-1m | 524290 | 15680.1 ± 0.2% | 1.001 | 0.177 | 1.000 | 1.000 | 1.001 | 0.999 | 1.000 | 1.000 | 1.000 | 0.177 | 1.001 |
| hex: http/js-1kx1024 | 2099200 | 13721.2 ± 0.4% | 1.002 | 0.195 | 0.995 | 1.002 | 1.001 | 0.938 | 0.997 | 1.008 | 1.033 | 0.186 | 1.014 |
| hex: http/js-16kx64 | 2097280 | 15224.4 ± 0.2% | 1.000 | 0.181 | 0.997 | 1.002 | 1.001 | 0.988 | 0.999 | 1.003 | 1.011 | 0.180 | 1.005 |
| hex: http/js-1m | 524290 | 15627.4 ± 0.1% | 0.999 | 0.177 | 1.001 | 1.001 | 1.000 | 0.998 | 1.001 | 0.999 | 1.001 | 0.178 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 13683.2 ± 0.4% | 1.004 | 0.195 | 0.997 | 0.999 | 0.998 | 0.943 | 0.999 | 1.012 | 1.034 | 0.186 | 1.010 |
| hex: http/css-16kx64 | 2097280 | 15190.0 ± 0.3% | 0.995 | 0.181 | 1.001 | 1.001 | 1.000 | 0.997 | 1.002 | 1.000 | 1.014 | 0.181 | 1.004 |
| hex: http/css-1m | 524290 | 15591.2 ± 0.3% | 1.000 | 0.177 | 1.001 | 1.000 | 1.002 | 1.001 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: shuffled/dickens-1m | 524290 | 15658.8 ± 0.5% | 1.000 | 0.177 | 1.000 | 1.000 | 1.001 | 1.000 | 1.000 | 1.001 | 1.001 | 0.177 | 1.000 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.056 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.056 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.251 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.249 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.247 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.257 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.278 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.272 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.271 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.278 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.269 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.272 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.276 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.261 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43265.6 ± 0.2% | 47340.4 ± 0.4% | 0.914 | — | — |
| string: silesia/nci | 1048576 | 38068.1 ± 2.9% | 40880.6 ± 2.3% | 0.931 | — | — |
| string: silesia/reymont | 1048576 | 34864.5 ± 9.7% | 36828.0 ± 8.4% | 0.947 | — | — |
| string: silesia/samba | 65546 | 43427.5 ± 0.1% | 48494.7 ± 0.1% | 0.896 | — | — |
| string: silesia/webster | 1048576 | 38056.1 ± 5.6% | 41287.1 ± 3.1% | 0.922 | — | — |
| string: silesia/xml | 1048576 | 33298.4 ± 1.9% | 34571.4 ± 1.5% | 0.963 | — | — |
| string: canterbury/alice29.txt | 152089 | 35880.5 ± 0.2% | 36523.0 ± 0.1% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43299.7 ± 0.1% | 47605.4 ± 0.2% | 0.910 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36044.8 ± 0.1% | 36384.8 ± 0.2% | 0.991 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 41651.6 ± 0.5% | 45382.1 ± 0.7% | 0.918 | — | — |
| string: canterbury-large/E.coli | 1048576 | 37848.4 ± 2.9% | 40968.5 ± 1.5% | 0.924 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 33812.4 ± 1.2% | 34975.1 ± 1.0% | 0.967 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 32560.2 ± 3.3% | 33966.4 ± 1.8% | 0.959 | — | — |
| string: http/html-1m | 1048576 | 37536.8 ± 6.1% | 40638.7 ± 4.8% | 0.924 | — | — |
| string: http/json-1m | 1048576 | 32074.0 ± 3.1% | 33990.8 ± 3.9% | 0.944 | — | — |
| string: http/js-1m | 1048576 | 37910.7 ± 4.3% | 41467.3 ± 3.5% | 0.914 | — | — |
| string: http/css-1m | 1048576 | 38853.2 ± 2.7% | 42425.7 ± 1.9% | 0.916 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5767.6 ± 0.3% | 5651.6 ± 0.0% | 1.021 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.914 of simdutf.
- string: silesia/nci: stdx runs at 0.931 of simdutf.
- string: silesia/samba: stdx runs at 0.896 of simdutf.
- string: silesia/webster: stdx runs at 0.922 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.910 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.918 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.924 of simdutf.
- string: http/html-1m: stdx runs at 0.924 of simdutf.
- string: http/json-1m: stdx runs at 0.944 of simdutf.
- string: http/js-1m: stdx runs at 0.914 of simdutf.
- string: http/css-1m: stdx runs at 0.916 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 40071.4 ± 5.0% | 43923.4 ± 3.4% | 0.912 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 33379.2 ± 3.2% | 34536.5 ± 1.8% | 0.966 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 37378.0 ± 2.2% | 39968.7 ± 2.7% | 0.935 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 38113.1 ± 1.9% | 41802.1 ± 1.1% | 0.912 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 38275.9 ± 4.5% | 41623.2 ± 2.3% | 0.920 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 38435.7 ± 2.5% | 41788.8 ± 1.5% | 0.920 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5753.4 ± 0.3% | 5640.0 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5747.2 ± 0.3% | 5636.8 ± 0.1% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5753.0 ± 0.2% | 5635.3 ± 0.2% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5752.9 ± 0.3% | 5640.9 ± 0.3% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5758.1 ± 0.1% | 5640.1 ± 0.3% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5752.2 ± 0.4% | 5640.1 ± 0.2% | 1.020 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.4 ± 0.4% | 935.1 ± 0.7% | 1019.9 ± 0.2% | 299.4 ± 0.9% | 667.2 ± 0.1% | 308.9 ± 1.7% | 1.206 | 1.105 | 3.765 | 1.690 | 3.650 |
| qlog records, JSON text sequence | 1467503 | 845.4 ± 1.4% | 816.2 ± 0.2% | 778.4 ± 5.3% | 242.9 ± 1.1% | 699.1 ± 3.3% | 247.9 ± 9.3% | 1.036 | 1.086 | 3.481 | 1.209 | 3.411 |
| string: silesia/dickens | 172528 | 5042.1 ± 0.5% | 1879.0 ± 0.1% | 2647.3 ± 0.3% | 360.7 ± 1.1% | 2849.7 ± 0.2% | 549.7 ± 2.4% | 2.683 | 1.905 | 13.977 | 1.769 | 9.172 |
| string: silesia/nci | 1075110 | 4301.4 ± 0.6% | 2236.3 ± 0.5% | 2998.0 ± 0.6% | 542.9 ± 0.6% | 3010.9 ± 0.9% | 601.6 ± 1.7% | 1.923 | 1.435 | 7.923 | 1.429 | 7.150 |
| string: silesia/reymont | 1075159 | 2923.8 ± 1.6% | 1807.6 ± 1.6% | 2060.7 ± 0.2% | 373.5 ± 0.6% | 2139.2 ± 0.8% | 532.3 ± 0.2% | 1.618 | 1.419 | 7.829 | 1.367 | 5.493 |
| string: silesia/samba | 97582 | 3490.3 ± 0.8% | 2025.3 ± 0.3% | 2618.2 ± 0.4% | 328.4 ± 0.3% | 1497.6 ± 0.3% | 429.1 ± 1.5% | 1.723 | 1.333 | 10.629 | 2.331 | 8.133 |
| string: silesia/webster | 1098490 | 3640.4 ± 0.2% | 1518.8 ± 0.4% | 2012.3 ± 0.5% | 358.8 ± 0.5% | 2181.5 ± 0.4% | 496.0 ± 1.5% | 2.397 | 1.809 | 10.145 | 1.669 | 7.340 |
| string: silesia/xml | 1090118 | 4766.4 ± 0.4% | 2353.4 ± 0.4% | 2527.8 ± 0.3% | 452.0 ± 1.2% | 2857.4 ± 0.8% | 564.3 ± 0.6% | 2.025 | 1.886 | 10.546 | 1.668 | 8.447 |
| string: canterbury/alice29.txt | 159425 | 4303.7 ± 0.6% | 1599.5 ± 0.3% | 2452.9 ± 0.6% | 341.8 ± 0.5% | 2494.3 ± 0.9% | 507.9 ± 2.0% | 2.691 | 1.755 | 12.591 | 1.725 | 8.474 |
| string: canterbury/asyoulik.txt | 132198 | 3449.8 ± 0.6% | 1457.3 ± 0.1% | 2243.7 ± 0.6% | 334.5 ± 0.8% | 2075.9 ± 0.2% | 462.3 ± 1.9% | 2.367 | 1.538 | 10.314 | 1.662 | 7.462 |
| string: canterbury/lcet10.txt | 441884 | 5090.4 ± 0.4% | 1853.2 ± 0.2% | 2343.6 ± 0.6% | 389.3 ± 0.4% | 2848.6 ± 0.5% | 535.1 ± 1.5% | 2.747 | 2.172 | 13.076 | 1.787 | 9.513 |
| string: canterbury/plrabn12.txt | 503330 | 4118.1 ± 0.5% | 1733.3 ± 0.4% | 2062.0 ± 0.2% | 360.7 ± 0.4% | 2483.8 ± 1.0% | 496.6 ± 2.0% | 2.376 | 1.997 | 11.419 | 1.658 | 8.293 |
| string: canterbury-large/E.coli | 1048578 | 18884.7 ± 1.2% | 3584.8 ± 0.8% | 3248.3 ± 0.4% | 934.4 ± 1.6% | 5992.6 ± 1.0% | 765.6 ± 1.0% | 5.268 | 5.814 | 20.210 | 3.151 | 24.666 |
| string: canterbury-large/bible.txt | 1055886 | 6641.0 ± 1.3% | 2937.0 ± 0.4% | 2836.1 ± 0.7% | 420.9 ± 2.5% | 3755.8 ± 1.7% | 614.3 ± 0.6% | 2.261 | 2.342 | 15.780 | 1.768 | 10.812 |
| string: canterbury-large/world192.txt | 1103121 | 3372.4 ± 1.2% | 1483.2 ± 0.4% | 2007.0 ± 0.2% | 352.7 ± 0.9% | 2103.8 ± 1.1% | 498.1 ± 0.7% | 2.274 | 1.680 | 9.563 | 1.603 | 6.771 |
| string: http/html-1m | 1058582 | 6018.5 ± 1.8% | 2729.7 ± 0.5% | 2686.5 ± 1.1% | 440.8 ± 0.6% | 3472.5 ± 1.3% | 589.8 ± 6.3% | 2.205 | 2.240 | 13.652 | 1.733 | 10.204 |
| string: http/json-1m | 1190272 | 2540.6 ± 0.3% | 875.0 ± 0.7% | 2244.7 ± 0.8% | 389.7 ± 0.3% | 1054.8 ± 0.8% | 437.9 ± 0.7% | 2.903 | 1.132 | 6.519 | 2.408 | 5.801 |
| string: http/js-1m | 1144362 | 2276.6 ± 0.7% | 1026.2 ± 0.3% | 1636.9 ± 0.4% | 319.3 ± 0.9% | 1520.7 ± 0.8% | 414.4 ± 0.4% | 2.218 | 1.391 | 7.130 | 1.497 | 5.494 |
| string: http/css-1m | 1097820 | 2630.0 ± 0.6% | 1676.3 ± 0.5% | 2222.7 ± 0.7% | 405.1 ± 0.7% | 1944.8 ± 0.6% | 485.6 ± 1.3% | 1.569 | 1.183 | 6.492 | 1.352 | 5.416 |
| string: dickens as Cyrillic and CJK | 1883069 | 3048.8 ± 0.8% | 1682.9 ± 0.5% | 888.0 ± 0.5% | 351.4 ± 0.2% | 669.7 ± 0.4% | 155.6 ± 1.7% | 1.812 | 3.434 | 8.677 | 4.552 | 19.597 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1325.5 ± 1.3% | 978.8 ± 0.3% | 1196.6 ± 0.2% | 215.9 ± 0.2% | 468.9 ± 0.8% | 254.8 ± 3.1% | 1.354 | 1.108 | 6.141 | 2.827 | 5.202 |
| hex: silesia/dickens | 524290 | 18939.9 ± 1.4% | 3618.7 ± 0.2% | 3297.7 ± 0.3% | 506.5 ± 1.6% | 6078.6 ± 2.4% | 779.7 ± 1.8% | 5.234 | 5.743 | 37.391 | 3.116 | 24.290 |
| hex: silesia/mozilla | 524290 | 18841.9 ± 1.0% | 3616.1 ± 0.2% | 3293.1 ± 0.3% | 450.8 ± 0.9% | 6060.2 ± 1.7% | 778.1 ± 0.7% | 5.211 | 5.722 | 41.794 | 3.109 | 24.215 |
| hex: silesia/mr | 524290 | 18770.9 ± 0.4% | 3621.3 ± 0.2% | 3290.6 ± 0.3% | 568.1 ± 1.0% | 6070.7 ± 0.8% | 779.9 ± 0.3% | 5.183 | 5.704 | 33.042 | 3.092 | 24.067 |
| hex: silesia/nci | 524290 | 18954.8 ± 0.6% | 3617.7 ± 0.1% | 3291.5 ± 0.2% | 627.0 ± 2.7% | 6068.1 ± 1.2% | 780.2 ± 0.3% | 5.239 | 5.759 | 30.231 | 3.124 | 24.293 |
| hex: silesia/ooffice | 524290 | 18762.8 ± 0.6% | 3615.3 ± 0.2% | 3293.4 ± 0.2% | 402.1 ± 1.1% | 6079.2 ± 0.7% | 779.6 ± 0.2% | 5.190 | 5.697 | 46.667 | 3.086 | 24.067 |
| hex: silesia/osdb | 524290 | 18738.9 ± 0.7% | 3613.7 ± 0.5% | 3290.4 ± 0.4% | 480.9 ± 0.9% | 6085.4 ± 1.0% | 780.0 ± 0.4% | 5.186 | 5.695 | 38.965 | 3.079 | 24.025 |
| hex: silesia/reymont | 524290 | 18746.3 ± 0.3% | 3620.1 ± 0.3% | 3297.0 ± 0.3% | 517.7 ± 1.2% | 6081.3 ± 0.9% | 779.5 ± 0.4% | 5.178 | 5.686 | 36.212 | 3.083 | 24.048 |
| hex: silesia/samba | 524290 | 18597.5 ± 0.7% | 3618.9 ± 0.2% | 3292.1 ± 0.3% | 408.8 ± 0.4% | 6075.3 ± 1.5% | 779.8 ± 0.5% | 5.139 | 5.649 | 45.492 | 3.061 | 23.851 |
| hex: silesia/sao | 524290 | 18884.6 ± 1.2% | 3619.9 ± 0.6% | 3290.4 ± 0.5% | 343.7 ± 0.6% | 6041.8 ± 2.3% | 780.2 ± 0.8% | 5.217 | 5.739 | 54.943 | 3.126 | 24.204 |
| hex: silesia/webster | 524290 | 19056.5 ± 0.9% | 3617.9 ± 0.2% | 3290.0 ± 0.4% | 476.9 ± 2.0% | 6050.1 ± 0.7% | 780.2 ± 0.3% | 5.267 | 5.792 | 39.960 | 3.150 | 24.426 |
| hex: silesia/x-ray | 524290 | 18808.1 ± 0.4% | 3618.5 ± 0.1% | 3298.2 ± 0.2% | 486.0 ± 0.4% | 6096.1 ± 1.4% | 781.5 ± 0.3% | 5.198 | 5.703 | 38.698 | 3.085 | 24.068 |
| hex: silesia/xml | 524290 | 19076.8 ± 0.6% | 3623.0 ± 0.2% | 3300.4 ± 0.3% | 533.3 ± 0.5% | 6053.6 ± 0.6% | 779.1 ± 0.5% | 5.265 | 5.780 | 35.772 | 3.151 | 24.485 |
| hex: canterbury/alice29.txt | 304180 | 19265.0 ± 1.2% | 3634.5 ± 1.2% | 3346.1 ± 0.1% | 524.4 ± 0.4% | 6082.0 ± 1.1% | 779.8 ± 0.4% | 5.301 | 5.758 | 36.736 | 3.168 | 24.706 |
| hex: canterbury/asyoulik.txt | 250360 | 18910.9 ± 0.4% | 3641.5 ± 0.0% | 3369.4 ± 0.1% | 516.9 ± 0.1% | 6071.5 ± 2.1% | 776.6 ± 0.5% | 5.193 | 5.613 | 36.586 | 3.115 | 24.351 |
| hex: canterbury/cp.html | 49208 | 19282.1 ± 0.2% | 3638.6 ± 0.1% | 3281.7 ± 0.3% | 476.4 ± 3.7% | 6281.8 ± 0.2% | 760.2 ± 1.2% | 5.299 | 5.876 | 40.476 | 3.070 | 25.365 |
| hex: canterbury/fields.c | 22302 | 18821.5 ± 0.9% | 3628.0 ± 0.1% | 3351.4 ± 0.1% | 511.2 ± 0.6% | 6250.8 ± 0.5% | 755.3 ± 2.0% | 5.188 | 5.616 | 36.816 | 3.011 | 24.920 |
| hex: canterbury/grammar.lsp | 7444 | 17440.2 ± 1.1% | 3599.3 ± 0.1% | 3346.2 ± 0.5% | 538.6 ± 1.8% | 6171.5 ± 0.9% | 712.1 ± 2.0% | 4.845 | 5.212 | 32.383 | 2.826 | 24.492 |
| hex: canterbury/kennedy.xls | 524290 | 18699.6 ± 1.6% | 3616.9 ± 0.2% | 3293.3 ± 0.2% | 659.9 ± 2.5% | 6097.6 ± 1.2% | 773.3 ± 2.3% | 5.170 | 5.678 | 28.338 | 3.067 | 24.181 |
| hex: canterbury/lcet10.txt | 524290 | 18998.1 ± 1.7% | 3616.5 ± 0.3% | 3283.9 ± 0.8% | 513.9 ± 0.5% | 6091.2 ± 1.2% | 774.6 ± 4.9% | 5.253 | 5.785 | 36.969 | 3.119 | 24.526 |
| hex: canterbury/plrabn12.txt | 524290 | 18820.5 ± 0.8% | 3618.7 ± 0.2% | 3297.6 ± 0.3% | 504.9 ± 0.5% | 6062.8 ± 1.0% | 778.3 ± 0.6% | 5.201 | 5.707 | 37.274 | 3.104 | 24.181 |
| hex: canterbury/ptt5 | 524290 | 18668.2 ± 0.5% | 3616.0 ± 0.3% | 3286.5 ± 0.4% | 558.4 ± 0.6% | 6124.7 ± 1.3% | 779.4 ± 0.7% | 5.163 | 5.680 | 33.434 | 3.048 | 23.951 |
| hex: canterbury/sum | 76482 | 19268.4 ± 0.1% | 3632.6 ± 0.0% | 3354.0 ± 0.1% | 510.7 ± 2.4% | 6181.8 ± 0.9% | 771.9 ± 1.3% | 5.304 | 5.745 | 37.733 | 3.117 | 24.962 |
| hex: canterbury/xargs.1 | 8456 | 17812.2 ± 0.1% | 3601.7 ± 0.1% | 3366.4 ± 0.3% | 497.1 ± 4.5% | 6141.8 ± 0.4% | 743.5 ± 1.7% | 4.945 | 5.291 | 35.831 | 2.900 | 23.958 |
| hex: canterbury-large/E.coli | 524290 | 18872.8 ± 1.7% | 3620.5 ± 0.1% | 3297.9 ± 0.2% | 688.6 ± 0.1% | 6061.0 ± 1.4% | 755.8 ± 4.9% | 5.213 | 5.723 | 27.406 | 3.114 | 24.971 |
| hex: canterbury-large/bible.txt | 524290 | 18718.3 ± 1.3% | 3619.3 ± 0.1% | 3279.7 ± 0.3% | 523.4 ± 1.7% | 6111.9 ± 1.1% | 778.9 ± 1.6% | 5.172 | 5.707 | 35.766 | 3.063 | 24.032 |
| hex: canterbury-large/world192.txt | 524290 | 18725.6 ± 0.4% | 3616.5 ± 0.2% | 3300.5 ± 0.4% | 491.9 ± 0.5% | 6111.0 ± 1.2% | 781.4 ± 0.5% | 5.178 | 5.674 | 38.069 | 3.064 | 23.963 |
| hex: http/html-1kx1024 | 2099200 | 9559.6 ± 17.8% | 3460.1 ± 0.2% | 2853.7 ± 0.3% | 476.6 ± 0.9% | 5153.7 ± 0.4% | 626.8 ± 2.7% | 2.763 | 3.350 | 20.060 | 1.855 | 15.253 |
| hex: http/html-16kx64 | 2097280 | 18335.6 ± 1.2% | 3611.4 ± 0.2% | 3259.9 ± 0.4% | 477.3 ± 1.0% | 6031.6 ± 0.8% | 743.3 ± 2.5% | 5.077 | 5.625 | 38.413 | 3.040 | 24.668 |
| hex: http/html-1m | 524290 | 18505.1 ± 1.9% | 3618.2 ± 0.4% | 3297.5 ± 0.3% | 500.8 ± 2.7% | 6102.4 ± 1.2% | 774.7 ± 3.4% | 5.115 | 5.612 | 36.953 | 3.032 | 23.887 |
| hex: http/json-1kx1024 | 2099200 | 9390.9 ± 19.1% | 3455.6 ± 0.3% | 2841.5 ± 0.6% | 575.3 ± 0.3% | 5136.2 ± 1.4% | 622.0 ± 3.0% | 2.718 | 3.305 | 16.324 | 1.828 | 15.098 |
| hex: http/json-16kx64 | 2097280 | 18385.2 ± 1.2% | 3606.6 ± 0.2% | 3263.6 ± 0.3% | 573.4 ± 1.7% | 6017.8 ± 0.4% | 742.8 ± 1.1% | 5.098 | 5.633 | 32.066 | 3.055 | 24.753 |
| hex: http/json-1m | 524290 | 18863.1 ± 2.8% | 3613.8 ± 0.2% | 3299.2 ± 0.3% | 592.5 ± 4.7% | 6097.9 ± 1.6% | 778.4 ± 1.3% | 5.220 | 5.717 | 31.837 | 3.093 | 24.234 |
| hex: http/js-1kx1024 | 2099200 | 9418.3 ± 15.4% | 3459.2 ± 0.2% | 2847.9 ± 0.6% | 480.2 ± 1.1% | 5121.6 ± 1.2% | 627.4 ± 2.3% | 2.723 | 3.307 | 19.613 | 1.839 | 15.012 |
| hex: http/js-16kx64 | 2097280 | 18345.8 ± 1.1% | 3609.8 ± 0.2% | 3254.8 ± 0.4% | 480.3 ± 0.5% | 6011.0 ± 0.7% | 744.6 ± 2.2% | 5.082 | 5.637 | 38.197 | 3.052 | 24.637 |
| hex: http/js-1m | 524290 | 19017.0 ± 0.5% | 3614.5 ± 0.3% | 3292.5 ± 0.2% | 520.9 ± 3.9% | 6025.5 ± 3.0% | 780.6 ± 3.2% | 5.261 | 5.776 | 36.511 | 3.156 | 24.363 |
| hex: http/css-1kx1024 | 2099200 | 10594.6 ± 17.1% | 3463.1 ± 0.1% | 2857.4 ± 0.7% | 489.1 ± 0.6% | 5147.7 ± 1.3% | 632.0 ± 1.0% | 3.059 | 3.708 | 21.661 | 2.058 | 16.763 |
| hex: http/css-16kx64 | 2097280 | 18432.2 ± 0.5% | 3610.4 ± 0.1% | 3254.7 ± 0.2% | 494.2 ± 1.5% | 6010.6 ± 0.8% | 746.4 ± 2.6% | 5.105 | 5.663 | 37.295 | 3.067 | 24.695 |
| hex: http/css-1m | 524290 | 18974.4 ± 1.8% | 3613.9 ± 0.3% | 3289.9 ± 0.3% | 496.3 ± 4.5% | 6026.1 ± 0.8% | 764.6 ± 2.7% | 5.250 | 5.767 | 38.233 | 3.149 | 24.816 |
| hex: shuffled/dickens-1m | 524290 | 18760.7 ± 0.5% | 3612.5 ± 0.3% | 3296.0 ± 0.1% | 512.1 ± 1.0% | 5980.5 ± 0.8% | 779.9 ± 3.0% | 5.193 | 5.692 | 36.633 | 3.137 | 24.057 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1473.7 ± 0.4% | 1245.9 ± 0.2% | 1033.7 ± 0.4% | 408.6 ± 0.3% | 448.0 ± 0.4% | 415.2 ± 0.6% | 1.183 | 1.426 | 3.607 | 3.290 | 3.549 |
| qlog records, JSON text sequence | 1467503 | 1260.2 ± 0.7% | 1058.6 ± 0.6% | 785.5 ± 2.0% | 378.3 ± 1.2% | 465.2 ± 1.5% | 277.9 ± 0.8% | 1.190 | 1.604 | 3.331 | 2.709 | 4.534 |
| string: silesia/dickens | 172528 | 6893.3 ± 0.2% | 2822.4 ± 0.5% | 2922.3 ± 0.3% | 429.0 ± 0.8% | 1592.1 ± 0.2% | 1009.8 ± 0.1% | 2.442 | 2.359 | 16.068 | 4.330 | 6.826 |
| string: silesia/nci | 1075110 | 7301.3 ± 0.2% | 3408.3 ± 0.8% | 3093.2 ± 0.4% | 814.6 ± 1.3% | 1860.7 ± 0.2% | 1107.4 ± 0.4% | 2.142 | 2.360 | 8.963 | 3.924 | 6.593 |
| string: silesia/reymont | 1075159 | 3341.0 ± 0.8% | 1992.9 ± 1.2% | 2057.3 ± 0.4% | 449.3 ± 0.8% | 1507.1 ± 1.6% | 948.7 ± 0.5% | 1.676 | 1.624 | 7.436 | 2.217 | 3.522 |
| string: silesia/samba | 97582 | 4185.9 ± 0.9% | 2113.7 ± 0.7% | 3442.3 ± 0.5% | 353.6 ± 0.5% | 1436.7 ± 0.9% | 1047.8 ± 0.3% | 1.980 | 1.216 | 11.837 | 2.914 | 3.995 |
| string: silesia/webster | 1098490 | 4049.4 ± 0.2% | 1881.9 ± 0.2% | 2056.5 ± 0.3% | 440.7 ± 0.4% | 1393.8 ± 0.4% | 645.7 ± 1.3% | 2.152 | 1.969 | 9.189 | 2.905 | 6.271 |
| string: silesia/xml | 1090118 | 6108.9 ± 0.4% | 2863.5 ± 0.5% | 2644.8 ± 0.3% | 610.5 ± 0.4% | 1755.6 ± 0.3% | 920.2 ± 0.3% | 2.133 | 2.310 | 10.006 | 3.480 | 6.638 |
| string: canterbury/alice29.txt | 159425 | 6409.5 ± 0.5% | 2199.8 ± 0.3% | 2760.4 ± 0.2% | 406.8 ± 1.0% | 1480.1 ± 0.3% | 950.3 ± 0.2% | 2.914 | 2.322 | 15.756 | 4.331 | 6.745 |
| string: canterbury/asyoulik.txt | 132198 | 5609.5 ± 1.2% | 1717.6 ± 0.3% | 2371.4 ± 0.5% | 401.5 ± 0.6% | 1347.2 ± 0.6% | 883.7 ± 0.5% | 3.266 | 2.366 | 13.972 | 4.164 | 6.348 |
| string: canterbury/lcet10.txt | 441884 | 6222.3 ± 0.7% | 2574.1 ± 0.3% | 2506.9 ± 2.0% | 466.9 ± 1.1% | 1542.0 ± 0.2% | 987.7 ± 0.3% | 2.417 | 2.482 | 13.327 | 4.035 | 6.300 |
| string: canterbury/plrabn12.txt | 503330 | 5709.3 ± 0.4% | 2059.0 ± 0.2% | 2064.0 ± 0.9% | 422.7 ± 0.5% | 1430.9 ± 0.3% | 933.1 ± 0.5% | 2.773 | 2.766 | 13.508 | 3.990 | 6.119 |
| string: canterbury-large/E.coli | 1048578 | 19273.9 ± 0.6% | 9771.8 ± 3.4% | 3785.0 ± 0.7% | 1473.4 ± 0.5% | 2359.8 ± 0.2% | 1189.8 ± 0.6% | 1.972 | 5.092 | 13.081 | 8.168 | 16.199 |
| string: canterbury-large/bible.txt | 1055886 | 6789.3 ± 0.5% | 4162.7 ± 0.6% | 3064.4 ± 1.8% | 503.8 ± 0.2% | 1970.8 ± 0.6% | 1119.2 ± 0.5% | 1.631 | 2.216 | 13.476 | 3.445 | 6.066 |
| string: canterbury-large/world192.txt | 1103121 | 4008.8 ± 0.3% | 1658.2 ± 0.3% | 2000.7 ± 1.4% | 446.6 ± 0.5% | 1359.4 ± 0.4% | 907.2 ± 0.6% | 2.418 | 2.004 | 8.977 | 2.949 | 4.419 |
| string: http/html-1m | 1058582 | 6743.3 ± 0.5% | 3993.8 ± 0.3% | 3041.5 ± 0.2% | 500.5 ± 0.8% | 1918.0 ± 0.3% | 804.6 ± 0.3% | 1.688 | 2.217 | 13.474 | 3.516 | 8.381 |
| string: http/json-1m | 1190272 | 3150.3 ± 0.4% | 1346.7 ± 0.3% | 1555.1 ± 0.4% | 442.7 ± 0.7% | 960.2 ± 0.2% | 764.4 ± 1.4% | 2.339 | 2.026 | 7.116 | 3.281 | 4.121 |
| string: http/js-1m | 1144362 | 2750.8 ± 0.3% | 1179.7 ± 0.3% | 1621.3 ± 0.5% | 367.8 ± 0.4% | 1094.0 ± 0.2% | 757.2 ± 0.3% | 2.332 | 1.697 | 7.478 | 2.514 | 3.633 |
| string: http/css-1m | 1097820 | 3971.5 ± 0.5% | 1486.0 ± 0.7% | 2146.6 ± 1.3% | 493.4 ± 0.2% | 1370.0 ± 0.1% | 893.3 ± 0.4% | 2.673 | 1.850 | 8.048 | 2.899 | 4.446 |
| string: dickens as Cyrillic and CJK | 1883069 | 3062.3 ± 0.4% | 2341.9 ± 0.5% | 521.4 ± 0.3% | 307.1 ± 0.6% | 561.5 ± 0.9% | 335.1 ± 0.2% | 1.308 | 5.873 | 9.971 | 5.454 | 9.139 |
| hex: silesia/dickens | 524290 | 15600.2 ± 0.1% | 1466.2 ± 0.1% | 1082.8 ± 0.1% | 501.6 ± 0.6% | 986.9 ± 0.3% | 733.4 ± 0.4% | 10.640 | 14.407 | 31.099 | 15.808 | 21.272 |
| hex: silesia/mozilla | 524290 | 15632.8 ± 0.2% | 1474.3 ± 0.3% | 1088.0 ± 0.2% | 440.9 ± 0.5% | 990.5 ± 0.4% | 734.1 ± 0.4% | 10.603 | 14.368 | 35.457 | 15.782 | 21.296 |
| hex: silesia/mr | 524290 | 15630.9 ± 0.2% | 1482.2 ± 0.8% | 1091.7 ± 1.6% | 561.7 ± 2.1% | 993.2 ± 0.4% | 734.0 ± 0.4% | 10.546 | 14.317 | 27.826 | 15.738 | 21.295 |
| hex: silesia/nci | 524290 | 15659.2 ± 0.1% | 1475.2 ± 0.1% | 1086.5 ± 0.2% | 646.2 ± 3.7% | 988.7 ± 0.2% | 733.1 ± 0.3% | 10.615 | 14.413 | 24.233 | 15.838 | 21.359 |
| hex: silesia/ooffice | 524290 | 15591.0 ± 0.2% | 1470.8 ± 0.4% | 1084.2 ± 0.5% | 388.9 ± 0.7% | 988.2 ± 0.3% | 734.0 ± 0.3% | 10.600 | 14.380 | 40.088 | 15.777 | 21.240 |
| hex: silesia/osdb | 524290 | 15644.2 ± 0.1% | 1470.8 ± 0.5% | 1084.0 ± 0.3% | 469.1 ± 1.9% | 990.8 ± 0.1% | 734.2 ± 0.3% | 10.636 | 14.433 | 33.348 | 15.790 | 21.308 |
| hex: silesia/reymont | 524290 | 15631.3 ± 0.3% | 1465.0 ± 0.5% | 1082.2 ± 0.6% | 513.0 ± 1.0% | 986.4 ± 0.4% | 733.6 ± 0.3% | 10.670 | 14.444 | 30.469 | 15.847 | 21.309 |
| hex: silesia/samba | 524290 | 15663.2 ± 0.1% | 1471.6 ± 0.3% | 1083.2 ± 0.4% | 401.4 ± 0.4% | 988.4 ± 0.4% | 734.4 ± 0.6% | 10.644 | 14.461 | 39.023 | 15.846 | 21.329 |
| hex: silesia/sao | 524290 | 15643.8 ± 0.2% | 1464.1 ± 0.3% | 1080.8 ± 0.4% | 332.4 ± 0.6% | 987.4 ± 0.1% | 734.0 ± 0.2% | 10.685 | 14.475 | 47.058 | 15.843 | 21.314 |
| hex: silesia/webster | 524290 | 15664.8 ± 0.2% | 1470.2 ± 0.2% | 1084.0 ± 0.1% | 475.1 ± 0.4% | 988.4 ± 0.3% | 733.9 ± 0.5% | 10.655 | 14.451 | 32.972 | 15.848 | 21.345 |
| hex: silesia/x-ray | 524290 | 15603.3 ± 0.2% | 1477.0 ± 0.1% | 1089.6 ± 0.2% | 447.0 ± 1.3% | 994.6 ± 0.3% | 733.4 ± 1.1% | 10.564 | 14.320 | 34.905 | 15.688 | 21.276 |
| hex: silesia/xml | 524290 | 15621.1 ± 0.4% | 1467.9 ± 0.2% | 1082.8 ± 0.3% | 615.1 ± 1.3% | 990.3 ± 1.0% | 734.1 ± 0.5% | 10.642 | 14.426 | 25.396 | 15.775 | 21.280 |
| hex: canterbury/alice29.txt | 304180 | 15672.8 ± 0.1% | 1477.0 ± 0.4% | 1089.7 ± 0.5% | 504.1 ± 0.7% | 993.0 ± 0.3% | 734.2 ± 0.7% | 10.612 | 14.383 | 31.091 | 15.783 | 21.346 |
| hex: canterbury/asyoulik.txt | 250360 | 15670.0 ± 0.1% | 1473.7 ± 0.2% | 1092.1 ± 0.2% | 498.1 ± 1.1% | 993.1 ± 0.4% | 738.1 ± 0.2% | 10.633 | 14.348 | 31.457 | 15.779 | 21.231 |
| hex: canterbury/cp.html | 49208 | 15599.4 ± 0.3% | 1481.9 ± 0.7% | 1097.9 ± 0.2% | 532.5 ± 0.5% | 1001.4 ± 0.2% | 743.4 ± 0.1% | 10.527 | 14.208 | 29.296 | 15.577 | 20.985 |
| hex: canterbury/fields.c | 22302 | 15424.1 ± 0.1% | 1436.2 ± 0.7% | 1067.6 ± 0.6% | 605.2 ± 6.8% | 994.1 ± 0.2% | 736.1 ± 0.1% | 10.739 | 14.448 | 25.486 | 15.515 | 20.954 |
| hex: canterbury/grammar.lsp | 7444 | 14913.7 ± 0.2% | 1488.6 ± 0.6% | 1091.8 ± 0.4% | 669.4 ± 4.2% | 1002.3 ± 0.1% | 726.1 ± 0.2% | 10.019 | 13.660 | 22.280 | 14.880 | 20.539 |
| hex: canterbury/kennedy.xls | 524290 | 15626.8 ± 0.5% | 1474.6 ± 0.2% | 1089.0 ± 0.3% | 658.4 ± 0.7% | 990.4 ± 0.6% | 735.4 ± 1.0% | 10.597 | 14.350 | 23.735 | 15.778 | 21.250 |
| hex: canterbury/lcet10.txt | 524290 | 15604.6 ± 0.1% | 1467.0 ± 0.3% | 1087.2 ± 0.6% | 501.2 ± 0.3% | 988.3 ± 0.5% | 734.9 ± 0.3% | 10.637 | 14.352 | 31.134 | 15.789 | 21.235 |
| hex: canterbury/plrabn12.txt | 524290 | 15634.6 ± 0.2% | 1468.4 ± 0.5% | 1081.4 ± 0.4% | 491.0 ± 3.1% | 987.7 ± 0.4% | 733.1 ± 0.4% | 10.647 | 14.458 | 31.839 | 15.829 | 21.327 |
| hex: canterbury/ptt5 | 524290 | 15620.0 ± 0.1% | 1482.8 ± 0.0% | 1091.1 ± 0.2% | 555.9 ± 1.0% | 997.3 ± 0.5% | 734.0 ± 0.4% | 10.534 | 14.315 | 28.098 | 15.662 | 21.280 |
| hex: canterbury/sum | 76482 | 15634.9 ± 0.1% | 1495.0 ± 0.1% | 1104.3 ± 0.4% | 592.4 ± 2.2% | 998.1 ± 0.1% | 743.6 ± 0.1% | 10.458 | 14.158 | 26.394 | 15.665 | 21.026 |
| hex: canterbury/xargs.1 | 8456 | 14981.4 ± 0.2% | 1431.7 ± 1.1% | 1095.1 ± 0.7% | 652.2 ± 4.0% | 1000.8 ± 0.3% | 728.2 ± 0.3% | 10.464 | 13.680 | 22.970 | 14.970 | 20.573 |
| hex: canterbury-large/E.coli | 524290 | 15649.2 ± 0.5% | 1475.2 ± 0.5% | 1088.1 ± 0.6% | 671.0 ± 0.2% | 990.9 ± 0.3% | 731.8 ± 0.5% | 10.608 | 14.382 | 23.324 | 15.794 | 21.384 |
| hex: canterbury-large/bible.txt | 524290 | 15621.2 ± 0.3% | 1469.9 ± 0.2% | 1084.7 ± 0.2% | 512.9 ± 0.6% | 991.3 ± 0.4% | 733.9 ± 0.7% | 10.627 | 14.401 | 30.458 | 15.759 | 21.285 |
| hex: canterbury-large/world192.txt | 524290 | 15609.8 ± 0.4% | 1470.1 ± 0.4% | 1083.6 ± 0.5% | 502.7 ± 0.8% | 988.9 ± 0.2% | 733.0 ± 0.7% | 10.618 | 14.406 | 31.055 | 15.786 | 21.297 |
| hex: http/html-1kx1024 | 2099200 | 13669.1 ± 0.5% | 1455.9 ± 0.3% | 1062.1 ± 0.3% | 501.9 ± 0.2% | 983.0 ± 0.2% | 692.6 ± 0.3% | 9.389 | 12.870 | 27.234 | 13.906 | 19.737 |
| hex: http/html-16kx64 | 2097280 | 15271.7 ± 0.3% | 1444.2 ± 0.2% | 1075.7 ± 0.4% | 508.1 ± 0.3% | 995.6 ± 0.1% | 734.7 ± 0.1% | 10.575 | 14.197 | 30.058 | 15.339 | 20.786 |
| hex: http/html-1m | 524290 | 15662.5 ± 0.2% | 1468.1 ± 0.4% | 1083.8 ± 0.6% | 502.1 ± 0.3% | 989.4 ± 0.3% | 733.4 ± 0.4% | 10.669 | 14.451 | 31.196 | 15.831 | 21.356 |
| hex: http/json-1kx1024 | 2099200 | 13701.3 ± 0.3% | 1463.0 ± 0.1% | 1067.4 ± 0.3% | 609.1 ± 0.3% | 986.0 ± 0.1% | 692.0 ± 0.3% | 9.365 | 12.837 | 22.494 | 13.897 | 19.799 |
| hex: http/json-16kx64 | 2097280 | 15225.0 ± 0.5% | 1445.4 ± 0.1% | 1075.1 ± 0.1% | 617.9 ± 0.3% | 994.6 ± 0.3% | 734.5 ± 0.2% | 10.533 | 14.162 | 24.639 | 15.308 | 20.728 |
| hex: http/json-1m | 524290 | 15680.1 ± 0.2% | 1476.9 ± 0.4% | 1087.6 ± 0.2% | 638.4 ± 0.9% | 992.5 ± 0.1% | 733.7 ± 0.3% | 10.617 | 14.418 | 24.563 | 15.798 | 21.370 |
| hex: http/js-1kx1024 | 2099200 | 13721.2 ± 0.4% | 1454.3 ± 0.2% | 1062.4 ± 0.3% | 498.7 ± 0.3% | 981.6 ± 0.2% | 691.9 ± 0.3% | 9.435 | 12.916 | 27.514 | 13.978 | 19.832 |
| hex: http/js-16kx64 | 2097280 | 15224.4 ± 0.2% | 1444.9 ± 0.1% | 1074.6 ± 0.2% | 506.4 ± 0.3% | 998.7 ± 0.3% | 734.8 ± 0.2% | 10.537 | 14.167 | 30.067 | 15.244 | 20.720 |
| hex: http/js-1m | 524290 | 15627.4 ± 0.1% | 1470.7 ± 0.2% | 1085.2 ± 0.4% | 512.8 ± 0.4% | 990.0 ± 0.4% | 733.9 ± 0.2% | 10.626 | 14.400 | 30.477 | 15.785 | 21.294 |
| hex: http/css-1kx1024 | 2099200 | 13683.2 ± 0.4% | 1453.4 ± 0.1% | 1061.4 ± 0.2% | 532.0 ± 0.2% | 982.4 ± 0.1% | 692.3 ± 0.1% | 9.415 | 12.891 | 25.720 | 13.928 | 19.766 |
| hex: http/css-16kx64 | 2097280 | 15190.0 ± 0.3% | 1445.4 ± 0.3% | 1074.8 ± 0.6% | 542.3 ± 0.7% | 996.5 ± 0.5% | 734.4 ± 0.1% | 10.509 | 14.133 | 28.010 | 15.243 | 20.685 |
| hex: http/css-1m | 524290 | 15591.2 ± 0.3% | 1469.7 ± 0.3% | 1086.2 ± 0.2% | 529.2 ± 0.3% | 989.3 ± 0.2% | 734.0 ± 0.2% | 10.608 | 14.354 | 29.462 | 15.759 | 21.242 |
| hex: shuffled/dickens-1m | 524290 | 15658.8 ± 0.5% | 1467.0 ± 0.9% | 1085.3 ± 0.5% | 500.7 ± 0.6% | 990.5 ± 0.5% | 734.0 ± 0.8% | 10.674 | 14.428 | 31.277 | 15.809 | 21.334 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1515.0 ± 0.1% | 1245.9 ± 0.2% | 1033.7 ± 0.4% | 408.6 ± 0.3% | 448.0 ± 0.4% | 415.2 ± 0.6% | 1.216 | 1.466 | 3.708 | 3.382 | 3.649 |
| qlog records, JSON text sequence | 1467503 | 1286.6 ± 0.5% | 1058.6 ± 0.6% | 785.5 ± 2.0% | 378.3 ± 1.2% | 465.2 ± 1.5% | 277.9 ± 0.8% | 1.215 | 1.638 | 3.401 | 2.765 | 4.629 |
| string: silesia/dickens | 172528 | 7135.0 ± 0.3% | 2822.4 ± 0.5% | 2922.3 ± 0.3% | 429.0 ± 0.8% | 1592.1 ± 0.2% | 1009.8 ± 0.1% | 2.528 | 2.442 | 16.631 | 4.482 | 7.066 |
| string: silesia/nci | 1075110 | 7351.1 ± 6.8% | 3408.3 ± 0.8% | 3093.2 ± 0.4% | 814.6 ± 1.3% | 1860.7 ± 0.2% | 1107.4 ± 0.4% | 2.157 | 2.377 | 9.024 | 3.951 | 6.638 |
| string: silesia/reymont | 1075159 | 3493.3 ± 0.8% | 1992.9 ± 1.2% | 2057.3 ± 0.4% | 449.3 ± 0.8% | 1507.1 ± 1.6% | 948.7 ± 0.5% | 1.753 | 1.698 | 7.775 | 2.318 | 3.682 |
| string: silesia/samba | 97582 | 4573.1 ± 1.2% | 2113.7 ± 0.7% | 3442.3 ± 0.5% | 353.6 ± 0.5% | 1436.7 ± 0.9% | 1047.8 ± 0.3% | 2.164 | 1.329 | 12.932 | 3.183 | 4.365 |
| string: silesia/webster | 1098490 | 4091.1 ± 0.8% | 1881.9 ± 0.2% | 2056.5 ± 0.3% | 440.7 ± 0.4% | 1393.8 ± 0.4% | 645.7 ± 1.3% | 2.174 | 1.989 | 9.283 | 2.935 | 6.336 |
| string: silesia/xml | 1090118 | 6214.9 ± 2.0% | 2863.5 ± 0.5% | 2644.8 ± 0.3% | 610.5 ± 0.4% | 1755.6 ± 0.3% | 920.2 ± 0.3% | 2.170 | 2.350 | 10.180 | 3.540 | 6.754 |
| string: canterbury/alice29.txt | 159425 | 6820.5 ± 1.8% | 2199.8 ± 0.3% | 2760.4 ± 0.2% | 406.8 ± 1.0% | 1480.1 ± 0.3% | 950.3 ± 0.2% | 3.101 | 2.471 | 16.766 | 4.608 | 7.177 |
| string: canterbury/asyoulik.txt | 132198 | 5908.2 ± 4.6% | 1717.6 ± 0.3% | 2371.4 ± 0.5% | 401.5 ± 0.6% | 1347.2 ± 0.6% | 883.7 ± 0.5% | 3.440 | 2.491 | 14.716 | 4.385 | 6.686 |
| string: canterbury/lcet10.txt | 441884 | 6251.0 ± 0.4% | 2574.1 ± 0.3% | 2506.9 ± 2.0% | 466.9 ± 1.1% | 1542.0 ± 0.2% | 987.7 ± 0.3% | 2.428 | 2.494 | 13.389 | 4.054 | 6.329 |
| string: canterbury/plrabn12.txt | 503330 | 5743.8 ± 0.2% | 2059.0 ± 0.2% | 2064.0 ± 0.9% | 422.7 ± 0.5% | 1430.9 ± 0.3% | 933.1 ± 0.5% | 2.790 | 2.783 | 13.590 | 4.014 | 6.156 |
| string: canterbury-large/E.coli | 1048578 | 19321.8 ± 1.2% | 9771.8 ± 3.4% | 3785.0 ± 0.7% | 1473.4 ± 0.5% | 2359.8 ± 0.2% | 1189.8 ± 0.6% | 1.977 | 5.105 | 13.114 | 8.188 | 16.240 |
| string: canterbury-large/bible.txt | 1055886 | 6789.1 ± 0.4% | 4162.7 ± 0.6% | 3064.4 ± 1.8% | 503.8 ± 0.2% | 1970.8 ± 0.6% | 1119.2 ± 0.5% | 1.631 | 2.215 | 13.476 | 3.445 | 6.066 |
| string: canterbury-large/world192.txt | 1103121 | 4042.1 ± 1.1% | 1658.2 ± 0.3% | 2000.7 ± 1.4% | 446.6 ± 0.5% | 1359.4 ± 0.4% | 907.2 ± 0.6% | 2.438 | 2.020 | 9.052 | 2.974 | 4.456 |
| string: http/html-1m | 1058582 | 6819.4 ± 0.4% | 3993.8 ± 0.3% | 3041.5 ± 0.2% | 500.5 ± 0.8% | 1918.0 ± 0.3% | 804.6 ± 0.3% | 1.707 | 2.242 | 13.626 | 3.556 | 8.475 |
| string: http/json-1m | 1190272 | 3297.6 ± 0.2% | 1346.7 ± 0.3% | 1555.1 ± 0.4% | 442.7 ± 0.7% | 960.2 ± 0.2% | 764.4 ± 1.4% | 2.449 | 2.121 | 7.449 | 3.434 | 4.314 |
| string: http/js-1m | 1144362 | 2788.7 ± 0.8% | 1179.7 ± 0.3% | 1621.3 ± 0.5% | 367.8 ± 0.4% | 1094.0 ± 0.2% | 757.2 ± 0.3% | 2.364 | 1.720 | 7.581 | 2.549 | 3.683 |
| string: http/css-1m | 1097820 | 4035.8 ± 0.2% | 1486.0 ± 0.7% | 2146.6 ± 1.3% | 493.4 ± 0.2% | 1370.0 ± 0.1% | 893.3 ± 0.4% | 2.716 | 1.880 | 8.179 | 2.946 | 4.518 |
| string: dickens as Cyrillic and CJK | 1883069 | 3068.5 ± 0.4% | 2341.9 ± 0.5% | 521.4 ± 0.3% | 307.1 ± 0.6% | 561.5 ± 0.9% | 335.1 ± 0.2% | 1.310 | 5.885 | 9.991 | 5.465 | 9.158 |
| hex: silesia/dickens | 524290 | 15620.2 ± 0.4% | 1466.2 ± 0.1% | 1082.8 ± 0.1% | 501.6 ± 0.6% | 986.9 ± 0.3% | 733.4 ± 0.4% | 10.654 | 14.426 | 31.139 | 15.828 | 21.299 |
| hex: silesia/mozilla | 524290 | 15597.4 ± 0.7% | 1474.3 ± 0.3% | 1088.0 ± 0.2% | 440.9 ± 0.5% | 990.5 ± 0.4% | 734.1 ± 0.4% | 10.579 | 14.335 | 35.377 | 15.747 | 21.247 |
| hex: silesia/mr | 524290 | 15669.0 ± 0.3% | 1482.2 ± 0.8% | 1091.7 ± 1.6% | 561.7 ± 2.1% | 993.2 ± 0.4% | 734.0 ± 0.4% | 10.571 | 14.352 | 27.893 | 15.776 | 21.347 |
| hex: silesia/nci | 524290 | 15665.3 ± 0.5% | 1475.2 ± 0.1% | 1086.5 ± 0.2% | 646.2 ± 3.7% | 988.7 ± 0.2% | 733.1 ± 0.3% | 10.619 | 14.418 | 24.242 | 15.844 | 21.368 |
| hex: silesia/ooffice | 524290 | 15584.6 ± 0.3% | 1470.8 ± 0.4% | 1084.2 ± 0.5% | 388.9 ± 0.7% | 988.2 ± 0.3% | 734.0 ± 0.3% | 10.596 | 14.374 | 40.071 | 15.771 | 21.232 |
| hex: silesia/osdb | 524290 | 15658.1 ± 0.2% | 1470.8 ± 0.5% | 1084.0 ± 0.3% | 469.1 ± 1.9% | 990.8 ± 0.1% | 734.2 ± 0.3% | 10.646 | 14.445 | 33.378 | 15.804 | 21.327 |
| hex: silesia/reymont | 524290 | 15684.1 ± 0.1% | 1465.0 ± 0.5% | 1082.2 ± 0.6% | 513.0 ± 1.0% | 986.4 ± 0.4% | 733.6 ± 0.3% | 10.706 | 14.493 | 30.572 | 15.900 | 21.381 |
| hex: silesia/samba | 524290 | 15685.5 ± 0.5% | 1471.6 ± 0.3% | 1083.2 ± 0.4% | 401.4 ± 0.4% | 988.4 ± 0.4% | 734.4 ± 0.6% | 10.659 | 14.481 | 39.079 | 15.869 | 21.360 |
| hex: silesia/sao | 524290 | 15594.6 ± 0.4% | 1464.1 ± 0.3% | 1080.8 ± 0.4% | 332.4 ± 0.6% | 987.4 ± 0.1% | 734.0 ± 0.2% | 10.651 | 14.429 | 46.910 | 15.793 | 21.247 |
| hex: silesia/webster | 524290 | 15690.4 ± 0.2% | 1470.2 ± 0.2% | 1084.0 ± 0.1% | 475.1 ± 0.4% | 988.4 ± 0.3% | 733.9 ± 0.5% | 10.672 | 14.475 | 33.026 | 15.874 | 21.380 |
| hex: silesia/x-ray | 524290 | 15616.5 ± 0.3% | 1477.0 ± 0.1% | 1089.6 ± 0.2% | 447.0 ± 1.3% | 994.6 ± 0.3% | 733.4 ± 1.1% | 10.573 | 14.333 | 34.935 | 15.701 | 21.294 |
| hex: silesia/xml | 524290 | 15638.0 ± 0.1% | 1467.9 ± 0.2% | 1082.8 ± 0.3% | 615.1 ± 1.3% | 990.3 ± 1.0% | 734.1 ± 0.5% | 10.653 | 14.442 | 25.423 | 15.792 | 21.304 |
| hex: canterbury/alice29.txt | 304180 | 15687.8 ± 0.1% | 1477.0 ± 0.4% | 1089.7 ± 0.5% | 504.1 ± 0.7% | 993.0 ± 0.3% | 734.2 ± 0.7% | 10.622 | 14.396 | 31.120 | 15.799 | 21.367 |
| hex: canterbury/asyoulik.txt | 250360 | 15705.5 ± 0.1% | 1473.7 ± 0.2% | 1092.1 ± 0.2% | 498.1 ± 1.1% | 993.1 ± 0.4% | 738.1 ± 0.2% | 10.657 | 14.381 | 31.528 | 15.815 | 21.279 |
| hex: canterbury/cp.html | 49208 | 15630.1 ± 0.0% | 1481.9 ± 0.7% | 1097.9 ± 0.2% | 532.5 ± 0.5% | 1001.4 ± 0.2% | 743.4 ± 0.1% | 10.547 | 14.236 | 29.353 | 15.608 | 21.027 |
| hex: canterbury/fields.c | 22302 | 15456.0 ± 0.1% | 1436.2 ± 0.7% | 1067.6 ± 0.6% | 605.2 ± 6.8% | 994.1 ± 0.2% | 736.1 ± 0.1% | 10.762 | 14.478 | 25.539 | 15.547 | 20.997 |
| hex: canterbury/grammar.lsp | 7444 | 14987.2 ± 0.0% | 1488.6 ± 0.6% | 1091.8 ± 0.4% | 669.4 ± 4.2% | 1002.3 ± 0.1% | 726.1 ± 0.2% | 10.068 | 13.727 | 22.389 | 14.953 | 20.640 |
| hex: canterbury/kennedy.xls | 524290 | 15656.4 ± 0.1% | 1474.6 ± 0.2% | 1089.0 ± 0.3% | 658.4 ± 0.7% | 990.4 ± 0.6% | 735.4 ± 1.0% | 10.617 | 14.377 | 23.779 | 15.808 | 21.290 |
| hex: canterbury/lcet10.txt | 524290 | 15620.4 ± 0.5% | 1467.0 ± 0.3% | 1087.2 ± 0.6% | 501.2 ± 0.3% | 988.3 ± 0.5% | 734.9 ± 0.3% | 10.648 | 14.367 | 31.165 | 15.805 | 21.256 |
| hex: canterbury/plrabn12.txt | 524290 | 15631.9 ± 0.1% | 1468.4 ± 0.5% | 1081.4 ± 0.4% | 491.0 ± 3.1% | 987.7 ± 0.4% | 733.1 ± 0.4% | 10.645 | 14.455 | 31.834 | 15.826 | 21.323 |
| hex: canterbury/ptt5 | 524290 | 15612.2 ± 0.2% | 1482.8 ± 0.0% | 1091.1 ± 0.2% | 555.9 ± 1.0% | 997.3 ± 0.5% | 734.0 ± 0.4% | 10.529 | 14.308 | 28.084 | 15.655 | 21.269 |
| hex: canterbury/sum | 76482 | 15649.8 ± 0.0% | 1495.0 ± 0.1% | 1104.3 ± 0.4% | 592.4 ± 2.2% | 998.1 ± 0.1% | 743.6 ± 0.1% | 10.468 | 14.171 | 26.419 | 15.680 | 21.046 |
| hex: canterbury/xargs.1 | 8456 | 15032.0 ± 0.0% | 1431.7 ± 1.1% | 1095.1 ± 0.7% | 652.2 ± 4.0% | 1000.8 ± 0.3% | 728.2 ± 0.3% | 10.499 | 13.726 | 23.048 | 15.020 | 20.642 |
| hex: canterbury-large/E.coli | 524290 | 15654.8 ± 0.4% | 1475.2 ± 0.5% | 1088.1 ± 0.6% | 671.0 ± 0.2% | 990.9 ± 0.3% | 731.8 ± 0.5% | 10.612 | 14.387 | 23.332 | 15.799 | 21.392 |
| hex: canterbury-large/bible.txt | 524290 | 15629.0 ± 0.3% | 1469.9 ± 0.2% | 1084.7 ± 0.2% | 512.9 ± 0.6% | 991.3 ± 0.4% | 733.9 ± 0.7% | 10.632 | 14.408 | 30.473 | 15.766 | 21.296 |
| hex: canterbury-large/world192.txt | 524290 | 15636.0 ± 0.1% | 1470.1 ± 0.4% | 1083.6 ± 0.5% | 502.7 ± 0.8% | 988.9 ± 0.2% | 733.0 ± 0.7% | 10.636 | 14.430 | 31.107 | 15.812 | 21.333 |
| hex: http/html-1kx1024 | 2099200 | 13873.6 ± 0.3% | 1455.9 ± 0.3% | 1062.1 ± 0.3% | 501.9 ± 0.2% | 983.0 ± 0.2% | 692.6 ± 0.3% | 9.529 | 13.062 | 27.642 | 14.114 | 20.032 |
| hex: http/html-16kx64 | 2097280 | 15297.2 ± 0.8% | 1444.2 ± 0.2% | 1075.7 ± 0.4% | 508.1 ± 0.3% | 995.6 ± 0.1% | 734.7 ± 0.1% | 10.592 | 14.221 | 30.108 | 15.365 | 20.821 |
| hex: http/html-1m | 524290 | 15656.6 ± 0.3% | 1468.1 ± 0.4% | 1083.8 ± 0.6% | 502.1 ± 0.3% | 989.4 ± 0.3% | 733.4 ± 0.4% | 10.665 | 14.445 | 31.184 | 15.825 | 21.348 |
| hex: http/json-1kx1024 | 2099200 | 13856.3 ± 0.7% | 1463.0 ± 0.1% | 1067.4 ± 0.3% | 609.1 ± 0.3% | 986.0 ± 0.1% | 692.0 ± 0.3% | 9.471 | 12.982 | 22.749 | 14.054 | 20.023 |
| hex: http/json-16kx64 | 2097280 | 15262.2 ± 0.3% | 1445.4 ± 0.1% | 1075.1 ± 0.1% | 617.9 ± 0.3% | 994.6 ± 0.3% | 734.5 ± 0.2% | 10.559 | 14.196 | 24.699 | 15.346 | 20.779 |
| hex: http/json-1m | 524290 | 15691.5 ± 0.1% | 1476.9 ± 0.4% | 1087.6 ± 0.2% | 638.4 ± 0.9% | 992.5 ± 0.1% | 733.7 ± 0.3% | 10.625 | 14.428 | 24.581 | 15.810 | 21.386 |
| hex: http/js-1kx1024 | 2099200 | 13910.3 ± 0.2% | 1454.3 ± 0.2% | 1062.4 ± 0.3% | 498.7 ± 0.3% | 981.6 ± 0.2% | 691.9 ± 0.3% | 9.565 | 13.094 | 27.893 | 14.171 | 20.105 |
| hex: http/js-16kx64 | 2097280 | 15295.6 ± 0.2% | 1444.9 ± 0.1% | 1074.6 ± 0.2% | 506.4 ± 0.3% | 998.7 ± 0.3% | 734.8 ± 0.2% | 10.586 | 14.233 | 30.207 | 15.316 | 20.817 |
| hex: http/js-1m | 524290 | 15637.0 ± 0.1% | 1470.7 ± 0.2% | 1085.2 ± 0.4% | 512.8 ± 0.4% | 990.0 ± 0.4% | 733.9 ± 0.2% | 10.632 | 14.409 | 30.496 | 15.795 | 21.307 |
| hex: http/css-1kx1024 | 2099200 | 13815.4 ± 0.4% | 1453.4 ± 0.1% | 1061.4 ± 0.2% | 532.0 ± 0.2% | 982.4 ± 0.1% | 692.3 ± 0.1% | 9.506 | 13.016 | 25.968 | 14.062 | 19.957 |
| hex: http/css-16kx64 | 2097280 | 15247.8 ± 0.1% | 1445.4 ± 0.3% | 1074.8 ± 0.6% | 542.3 ± 0.7% | 996.5 ± 0.5% | 734.4 ± 0.1% | 10.549 | 14.186 | 28.117 | 15.301 | 20.763 |
| hex: http/css-1m | 524290 | 15606.6 ± 0.4% | 1469.7 ± 0.3% | 1086.2 ± 0.2% | 529.2 ± 0.3% | 989.3 ± 0.2% | 734.0 ± 0.2% | 10.619 | 14.368 | 29.492 | 15.775 | 21.263 |
| hex: shuffled/dickens-1m | 524290 | 15652.7 ± 0.5% | 1467.0 ± 0.9% | 1085.3 ± 0.5% | 500.7 ± 0.6% | 990.5 ± 0.5% | 734.0 ± 0.8% | 10.670 | 14.422 | 31.264 | 15.803 | 21.326 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 935.9 ± 0.2% | 935.1 ± 0.7% | 1019.9 ± 0.2% | 299.4 ± 0.9% | 667.2 ± 0.1% | 308.9 ± 1.7% | 1.001 | 0.918 | 3.125 | 1.403 | 3.030 |
| qlog records, JSON text sequence | 1467503 | 782.5 ± 1.4% | 816.2 ± 0.2% | 778.4 ± 5.3% | 242.9 ± 1.1% | 699.1 ± 3.3% | 247.9 ± 9.3% | 0.959 | 1.005 | 3.222 | 1.119 | 3.157 |
| string: silesia/dickens | 172528 | 5059.1 ± 0.3% | 1879.0 ± 0.1% | 2647.3 ± 0.3% | 360.7 ± 1.1% | 2849.7 ± 0.2% | 549.7 ± 2.4% | 2.692 | 1.911 | 14.024 | 1.775 | 9.203 |
| string: silesia/nci | 1075110 | 4311.8 ± 0.3% | 2236.3 ± 0.5% | 2998.0 ± 0.6% | 542.9 ± 0.6% | 3010.9 ± 0.9% | 601.6 ± 1.7% | 1.928 | 1.438 | 7.943 | 1.432 | 7.167 |
| string: silesia/reymont | 1075159 | 3014.6 ± 1.4% | 1807.6 ± 1.6% | 2060.7 ± 0.2% | 373.5 ± 0.6% | 2139.2 ± 0.8% | 532.3 ± 0.2% | 1.668 | 1.463 | 8.072 | 1.409 | 5.663 |
| string: silesia/samba | 97582 | 3503.4 ± 0.3% | 2025.3 ± 0.3% | 2618.2 ± 0.4% | 328.4 ± 0.3% | 1497.6 ± 0.3% | 429.1 ± 1.5% | 1.730 | 1.338 | 10.669 | 2.339 | 8.164 |
| string: silesia/webster | 1098490 | 3672.8 ± 0.9% | 1518.8 ± 0.4% | 2012.3 ± 0.5% | 358.8 ± 0.5% | 2181.5 ± 0.4% | 496.0 ± 1.5% | 2.418 | 1.825 | 10.236 | 1.684 | 7.405 |
| string: silesia/xml | 1090118 | 4796.3 ± 0.3% | 2353.4 ± 0.4% | 2527.8 ± 0.3% | 452.0 ± 1.2% | 2857.4 ± 0.8% | 564.3 ± 0.6% | 2.038 | 1.897 | 10.612 | 1.679 | 8.500 |
| string: canterbury/alice29.txt | 159425 | 4369.4 ± 1.1% | 1599.5 ± 0.3% | 2452.9 ± 0.6% | 341.8 ± 0.5% | 2494.3 ± 0.9% | 507.9 ± 2.0% | 2.732 | 1.781 | 12.783 | 1.752 | 8.603 |
| string: canterbury/asyoulik.txt | 132198 | 3503.7 ± 0.6% | 1457.3 ± 0.1% | 2243.7 ± 0.6% | 334.5 ± 0.8% | 2075.9 ± 0.2% | 462.3 ± 1.9% | 2.404 | 1.562 | 10.475 | 1.688 | 7.578 |
| string: canterbury/lcet10.txt | 441884 | 5123.4 ± 0.3% | 1853.2 ± 0.2% | 2343.6 ± 0.6% | 389.3 ± 0.4% | 2848.6 ± 0.5% | 535.1 ± 1.5% | 2.765 | 2.186 | 13.160 | 1.799 | 9.575 |
| string: canterbury/plrabn12.txt | 503330 | 4139.2 ± 0.9% | 1733.3 ± 0.4% | 2062.0 ± 0.2% | 360.7 ± 0.4% | 2483.8 ± 1.0% | 496.6 ± 2.0% | 2.388 | 2.007 | 11.477 | 1.666 | 8.335 |
| string: canterbury-large/E.coli | 1048578 | 11906.9 ± 0.3% | 3584.8 ± 0.8% | 3248.3 ± 0.4% | 934.4 ± 1.6% | 5992.6 ± 1.0% | 765.6 ± 1.0% | 3.322 | 3.666 | 12.743 | 1.987 | 15.552 |
| string: canterbury-large/bible.txt | 1055886 | 6877.7 ± 1.1% | 2937.0 ± 0.4% | 2836.1 ± 0.7% | 420.9 ± 2.5% | 3755.8 ± 1.7% | 614.3 ± 0.6% | 2.342 | 2.425 | 16.342 | 1.831 | 11.197 |
| string: canterbury-large/world192.txt | 1103121 | 3390.2 ± 0.5% | 1483.2 ± 0.4% | 2007.0 ± 0.2% | 352.7 ± 0.9% | 2103.8 ± 1.1% | 498.1 ± 0.7% | 2.286 | 1.689 | 9.613 | 1.611 | 6.807 |
| string: http/html-1m | 1058582 | 6182.4 ± 1.0% | 2729.7 ± 0.5% | 2686.5 ± 1.1% | 440.8 ± 0.6% | 3472.5 ± 1.3% | 589.8 ± 6.3% | 2.265 | 2.301 | 14.024 | 1.780 | 10.482 |
| string: http/json-1m | 1190272 | 2556.3 ± 0.5% | 875.0 ± 0.7% | 2244.7 ± 0.8% | 389.7 ± 0.3% | 1054.8 ± 0.8% | 437.9 ± 0.7% | 2.921 | 1.139 | 6.560 | 2.423 | 5.837 |
| string: http/js-1m | 1144362 | 2283.0 ± 0.3% | 1026.2 ± 0.3% | 1636.9 ± 0.4% | 319.3 ± 0.9% | 1520.7 ± 0.8% | 414.4 ± 0.4% | 2.225 | 1.395 | 7.150 | 1.501 | 5.510 |
| string: http/css-1m | 1097820 | 2651.5 ± 0.6% | 1676.3 ± 0.5% | 2222.7 ± 0.7% | 405.1 ± 0.7% | 1944.8 ± 0.6% | 485.6 ± 1.3% | 1.582 | 1.193 | 6.545 | 1.363 | 5.460 |
| string: dickens as Cyrillic and CJK | 1883069 | 3076.4 ± 0.4% | 1682.9 ± 0.5% | 888.0 ± 0.5% | 351.4 ± 0.2% | 669.7 ± 0.4% | 155.6 ± 1.7% | 1.828 | 3.465 | 8.756 | 4.593 | 19.774 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1328.8 ± 0.3% | 978.8 ± 0.3% | 1196.6 ± 0.2% | 215.9 ± 0.2% | 468.9 ± 0.8% | 254.8 ± 3.1% | 1.358 | 1.111 | 6.156 | 2.834 | 5.215 |
| hex: silesia/dickens | 524290 | 11998.2 ± 0.1% | 3618.7 ± 0.2% | 3297.7 ± 0.3% | 506.5 ± 1.6% | 6078.6 ± 2.4% | 779.7 ± 1.8% | 3.316 | 3.638 | 23.687 | 1.974 | 15.388 |
| hex: silesia/mozilla | 524290 | 11974.3 ± 0.0% | 3616.1 ± 0.2% | 3293.1 ± 0.3% | 450.8 ± 0.9% | 6060.2 ± 1.7% | 778.1 ± 0.7% | 3.311 | 3.636 | 26.561 | 1.976 | 15.389 |
| hex: silesia/mr | 524290 | 11977.3 ± 0.2% | 3621.3 ± 0.2% | 3290.6 ± 0.3% | 568.1 ± 1.0% | 6070.7 ± 0.8% | 779.9 ± 0.3% | 3.307 | 3.640 | 21.083 | 1.973 | 15.357 |
| hex: silesia/nci | 524290 | 11988.1 ± 0.2% | 3617.7 ± 0.1% | 3291.5 ± 0.2% | 627.0 ± 2.7% | 6068.1 ± 1.2% | 780.2 ± 0.3% | 3.314 | 3.642 | 19.120 | 1.976 | 15.365 |
| hex: silesia/ooffice | 524290 | 11992.0 ± 0.6% | 3615.3 ± 0.2% | 3293.4 ± 0.2% | 402.1 ± 1.1% | 6079.2 ± 0.7% | 779.6 ± 0.2% | 3.317 | 3.641 | 29.827 | 1.973 | 15.382 |
| hex: silesia/osdb | 524290 | 11975.6 ± 0.2% | 3613.7 ± 0.5% | 3290.4 ± 0.4% | 480.9 ± 0.9% | 6085.4 ± 1.0% | 780.0 ± 0.4% | 3.314 | 3.640 | 24.901 | 1.968 | 15.354 |
| hex: silesia/reymont | 524290 | 11984.2 ± 0.1% | 3620.1 ± 0.3% | 3297.0 ± 0.3% | 517.7 ± 1.2% | 6081.3 ± 0.9% | 779.5 ± 0.4% | 3.310 | 3.635 | 23.150 | 1.971 | 15.374 |
| hex: silesia/samba | 524290 | 11954.1 ± 0.1% | 3618.9 ± 0.2% | 3292.1 ± 0.3% | 408.8 ± 0.4% | 6075.3 ± 1.5% | 779.8 ± 0.5% | 3.303 | 3.631 | 29.241 | 1.968 | 15.331 |
| hex: silesia/sao | 524290 | 11981.3 ± 0.1% | 3619.9 ± 0.6% | 3290.4 ± 0.5% | 343.7 ± 0.6% | 6041.8 ± 2.3% | 780.2 ± 0.8% | 3.310 | 3.641 | 34.858 | 1.983 | 15.356 |
| hex: silesia/webster | 524290 | 11980.8 ± 0.1% | 3617.9 ± 0.2% | 3290.0 ± 0.4% | 476.9 ± 2.0% | 6050.1 ± 0.7% | 780.2 ± 0.3% | 3.312 | 3.642 | 25.123 | 1.980 | 15.357 |
| hex: silesia/x-ray | 524290 | 12010.1 ± 0.1% | 3618.5 ± 0.1% | 3298.2 ± 0.2% | 486.0 ± 0.4% | 6096.1 ± 1.4% | 781.5 ± 0.3% | 3.319 | 3.641 | 24.711 | 1.970 | 15.369 |
| hex: silesia/xml | 524290 | 12005.3 ± 0.3% | 3623.0 ± 0.2% | 3300.4 ± 0.3% | 533.3 ± 0.5% | 6053.6 ± 0.6% | 779.1 ± 0.5% | 3.314 | 3.637 | 22.512 | 1.983 | 15.409 |
| hex: canterbury/alice29.txt | 304180 | 11999.5 ± 0.2% | 3634.5 ± 1.2% | 3346.1 ± 0.1% | 524.4 ± 0.4% | 6082.0 ± 1.1% | 779.8 ± 0.4% | 3.302 | 3.586 | 22.881 | 1.973 | 15.388 |
| hex: canterbury/asyoulik.txt | 250360 | 11994.8 ± 0.2% | 3641.5 ± 0.0% | 3369.4 ± 0.1% | 516.9 ± 0.1% | 6071.5 ± 2.1% | 776.6 ± 0.5% | 3.294 | 3.560 | 23.206 | 1.976 | 15.445 |
| hex: canterbury/cp.html | 49208 | 11923.0 ± 0.0% | 3638.6 ± 0.1% | 3281.7 ± 0.3% | 476.4 ± 3.7% | 6281.8 ± 0.2% | 760.2 ± 1.2% | 3.277 | 3.633 | 25.028 | 1.898 | 15.684 |
| hex: canterbury/fields.c | 22302 | 11775.8 ± 0.0% | 3628.0 ± 0.1% | 3351.4 ± 0.1% | 511.2 ± 0.6% | 6250.8 ± 0.5% | 755.3 ± 2.0% | 3.246 | 3.514 | 23.034 | 1.884 | 15.592 |
| hex: canterbury/grammar.lsp | 7444 | 11251.9 ± 0.1% | 3599.3 ± 0.1% | 3346.2 ± 0.5% | 538.6 ± 1.8% | 6171.5 ± 0.9% | 712.1 ± 2.0% | 3.126 | 3.363 | 20.892 | 1.823 | 15.801 |
| hex: canterbury/kennedy.xls | 524290 | 11982.4 ± 0.0% | 3616.9 ± 0.2% | 3293.3 ± 0.2% | 659.9 ± 2.5% | 6097.6 ± 1.2% | 773.3 ± 2.3% | 3.313 | 3.638 | 18.158 | 1.965 | 15.495 |
| hex: canterbury/lcet10.txt | 524290 | 12011.5 ± 0.1% | 3616.5 ± 0.3% | 3283.9 ± 0.8% | 513.9 ± 0.5% | 6091.2 ± 1.2% | 774.6 ± 4.9% | 3.321 | 3.658 | 23.374 | 1.972 | 15.507 |
| hex: canterbury/plrabn12.txt | 524290 | 11976.1 ± 0.3% | 3618.7 ± 0.2% | 3297.6 ± 0.3% | 504.9 ± 0.5% | 6062.8 ± 1.0% | 778.3 ± 0.6% | 3.309 | 3.632 | 23.719 | 1.975 | 15.387 |
| hex: canterbury/ptt5 | 524290 | 12000.0 ± 0.2% | 3616.0 ± 0.3% | 3286.5 ± 0.4% | 558.4 ± 0.6% | 6124.7 ± 1.3% | 779.4 ± 0.7% | 3.319 | 3.651 | 21.491 | 1.959 | 15.395 |
| hex: canterbury/sum | 76482 | 11900.7 ± 0.2% | 3632.6 ± 0.0% | 3354.0 ± 0.1% | 510.7 ± 2.4% | 6181.8 ± 0.9% | 771.9 ± 1.3% | 3.276 | 3.548 | 23.305 | 1.925 | 15.417 |
| hex: canterbury/xargs.1 | 8456 | 11346.7 ± 0.1% | 3601.7 ± 0.1% | 3366.4 ± 0.3% | 497.1 ± 4.5% | 6141.8 ± 0.4% | 743.5 ± 1.7% | 3.150 | 3.371 | 22.825 | 1.847 | 15.261 |
| hex: canterbury-large/E.coli | 524290 | 12008.9 ± 0.2% | 3620.5 ± 0.1% | 3297.9 ± 0.2% | 688.6 ± 0.1% | 6061.0 ± 1.4% | 755.8 ± 4.9% | 3.317 | 3.641 | 17.439 | 1.981 | 15.889 |
| hex: canterbury-large/bible.txt | 524290 | 11987.6 ± 0.2% | 3619.3 ± 0.1% | 3279.7 ± 0.3% | 523.4 ± 1.7% | 6111.9 ± 1.1% | 778.9 ± 1.6% | 3.312 | 3.655 | 22.905 | 1.961 | 15.391 |
| hex: canterbury-large/world192.txt | 524290 | 12015.5 ± 0.2% | 3616.5 ± 0.2% | 3300.5 ± 0.4% | 491.9 ± 0.5% | 6111.0 ± 1.2% | 781.4 ± 0.5% | 3.322 | 3.641 | 24.427 | 1.966 | 15.376 |
| hex: http/html-1kx1024 | 2099200 | 8836.5 ± 4.0% | 3460.1 ± 0.2% | 2853.7 ± 0.3% | 476.6 ± 0.9% | 5153.7 ± 0.4% | 626.8 ± 2.7% | 2.554 | 3.097 | 18.542 | 1.715 | 14.099 |
| hex: http/html-16kx64 | 2097280 | 11761.7 ± 0.2% | 3611.4 ± 0.2% | 3259.9 ± 0.4% | 477.3 ± 1.0% | 6031.6 ± 0.8% | 743.3 ± 2.5% | 3.257 | 3.608 | 24.641 | 1.950 | 15.824 |
| hex: http/html-1m | 524290 | 11955.4 ± 0.1% | 3618.2 ± 0.4% | 3297.5 ± 0.3% | 500.8 ± 2.7% | 6102.4 ± 1.2% | 774.7 ± 3.4% | 3.304 | 3.626 | 23.874 | 1.959 | 15.432 |
| hex: http/json-1kx1024 | 2099200 | 8763.8 ± 4.5% | 3455.6 ± 0.3% | 2841.5 ± 0.6% | 575.3 ± 0.3% | 5136.2 ± 1.4% | 622.0 ± 3.0% | 2.536 | 3.084 | 15.234 | 1.706 | 14.090 |
| hex: http/json-16kx64 | 2097280 | 11763.3 ± 2.3% | 3606.6 ± 0.2% | 3263.6 ± 0.3% | 573.4 ± 1.7% | 6017.8 ± 0.4% | 742.8 ± 1.1% | 3.262 | 3.604 | 20.517 | 1.955 | 15.837 |
| hex: http/json-1m | 524290 | 11991.4 ± 0.2% | 3613.8 ± 0.2% | 3299.2 ± 0.3% | 592.5 ± 4.7% | 6097.9 ± 1.6% | 778.4 ± 1.3% | 3.318 | 3.635 | 20.239 | 1.966 | 15.405 |
| hex: http/js-1kx1024 | 2099200 | 8826.1 ± 2.9% | 3459.2 ± 0.2% | 2847.9 ± 0.6% | 480.2 ± 1.1% | 5121.6 ± 1.2% | 627.4 ± 2.3% | 2.552 | 3.099 | 18.380 | 1.723 | 14.068 |
| hex: http/js-16kx64 | 2097280 | 11763.0 ± 0.2% | 3609.8 ± 0.2% | 3254.8 ± 0.4% | 480.3 ± 0.5% | 6011.0 ± 0.7% | 744.6 ± 2.2% | 3.259 | 3.614 | 24.491 | 1.957 | 15.797 |
| hex: http/js-1m | 524290 | 12000.7 ± 0.1% | 3614.5 ± 0.3% | 3292.5 ± 0.2% | 520.9 ± 3.9% | 6025.5 ± 3.0% | 780.6 ± 3.2% | 3.320 | 3.645 | 23.040 | 1.992 | 15.374 |
| hex: http/css-1kx1024 | 2099200 | 8816.2 ± 3.6% | 3463.1 ± 0.1% | 2857.4 ± 0.7% | 489.1 ± 0.6% | 5147.7 ± 1.3% | 632.0 ± 1.0% | 2.546 | 3.085 | 18.025 | 1.713 | 13.949 |
| hex: http/css-16kx64 | 2097280 | 11765.3 ± 0.1% | 3610.4 ± 0.1% | 3254.7 ± 0.2% | 494.2 ± 1.5% | 6010.6 ± 0.8% | 746.4 ± 2.6% | 3.259 | 3.615 | 23.805 | 1.957 | 15.763 |
| hex: http/css-1m | 524290 | 11989.0 ± 0.2% | 3613.9 ± 0.3% | 3289.9 ± 0.3% | 496.3 ± 4.5% | 6026.1 ± 0.8% | 764.6 ± 2.7% | 3.317 | 3.644 | 24.157 | 1.990 | 15.680 |
| hex: shuffled/dickens-1m | 524290 | 11968.1 ± 0.2% | 3612.5 ± 0.3% | 3296.0 ± 0.1% | 512.1 ± 1.0% | 5980.5 ± 0.8% | 779.9 ± 3.0% | 3.313 | 3.631 | 23.370 | 2.001 | 15.347 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1013.5 ± 0.3% | 935.1 ± 0.7% | 1019.9 ± 0.2% | 299.4 ± 0.9% | 667.2 ± 0.1% | 308.9 ± 1.7% | 1.084 | 0.994 | 3.385 | 1.519 | 3.281 |
| qlog records, JSON text sequence | 1467503 | 835.0 ± 1.1% | 816.2 ± 0.2% | 778.4 ± 5.3% | 242.9 ± 1.1% | 699.1 ± 3.3% | 247.9 ± 9.3% | 1.023 | 1.073 | 3.438 | 1.194 | 3.369 |
| string: silesia/dickens | 172528 | 5055.5 ± 0.3% | 1879.0 ± 0.1% | 2647.3 ± 0.3% | 360.7 ± 1.1% | 2849.7 ± 0.2% | 549.7 ± 2.4% | 2.690 | 1.910 | 14.014 | 1.774 | 9.197 |
| string: silesia/nci | 1075110 | 4307.2 ± 0.3% | 2236.3 ± 0.5% | 2998.0 ± 0.6% | 542.9 ± 0.6% | 3010.9 ± 0.9% | 601.6 ± 1.7% | 1.926 | 1.437 | 7.934 | 1.431 | 7.159 |
| string: silesia/reymont | 1075159 | 3025.4 ± 1.4% | 1807.6 ± 1.6% | 2060.7 ± 0.2% | 373.5 ± 0.6% | 2139.2 ± 0.8% | 532.3 ± 0.2% | 1.674 | 1.468 | 8.101 | 1.414 | 5.683 |
| string: silesia/samba | 97582 | 3514.2 ± 0.3% | 2025.3 ± 0.3% | 2618.2 ± 0.4% | 328.4 ± 0.3% | 1497.6 ± 0.3% | 429.1 ± 1.5% | 1.735 | 1.342 | 10.702 | 2.346 | 8.189 |
| string: silesia/webster | 1098490 | 3666.9 ± 0.9% | 1518.8 ± 0.4% | 2012.3 ± 0.5% | 358.8 ± 0.5% | 2181.5 ± 0.4% | 496.0 ± 1.5% | 2.414 | 1.822 | 10.219 | 1.681 | 7.393 |
| string: silesia/xml | 1090118 | 4799.6 ± 0.2% | 2353.4 ± 0.4% | 2527.8 ± 0.3% | 452.0 ± 1.2% | 2857.4 ± 0.8% | 564.3 ± 0.6% | 2.039 | 1.899 | 10.620 | 1.680 | 8.506 |
| string: canterbury/alice29.txt | 159425 | 4379.0 ± 1.0% | 1599.5 ± 0.3% | 2452.9 ± 0.6% | 341.8 ± 0.5% | 2494.3 ± 0.9% | 507.9 ± 2.0% | 2.738 | 1.785 | 12.811 | 1.756 | 8.622 |
| string: canterbury/asyoulik.txt | 132198 | 3502.0 ± 0.7% | 1457.3 ± 0.1% | 2243.7 ± 0.6% | 334.5 ± 0.8% | 2075.9 ± 0.2% | 462.3 ± 1.9% | 2.403 | 1.561 | 10.470 | 1.687 | 7.575 |
| string: canterbury/lcet10.txt | 441884 | 5109.0 ± 0.1% | 1853.2 ± 0.2% | 2343.6 ± 0.6% | 389.3 ± 0.4% | 2848.6 ± 0.5% | 535.1 ± 1.5% | 2.757 | 2.180 | 13.123 | 1.794 | 9.548 |
| string: canterbury/plrabn12.txt | 503330 | 4117.2 ± 0.8% | 1733.3 ± 0.4% | 2062.0 ± 0.2% | 360.7 ± 0.4% | 2483.8 ± 1.0% | 496.6 ± 2.0% | 2.375 | 1.997 | 11.416 | 1.658 | 8.291 |
| string: canterbury-large/E.coli | 1048578 | 11908.2 ± 0.5% | 3584.8 ± 0.8% | 3248.3 ± 0.4% | 934.4 ± 1.6% | 5992.6 ± 1.0% | 765.6 ± 1.0% | 3.322 | 3.666 | 12.744 | 1.987 | 15.554 |
| string: canterbury-large/bible.txt | 1055886 | 6907.0 ± 1.0% | 2937.0 ± 0.4% | 2836.1 ± 0.7% | 420.9 ± 2.5% | 3755.8 ± 1.7% | 614.3 ± 0.6% | 2.352 | 2.435 | 16.412 | 1.839 | 11.245 |
| string: canterbury-large/world192.txt | 1103121 | 3390.5 ± 0.2% | 1483.2 ± 0.4% | 2007.0 ± 0.2% | 352.7 ± 0.9% | 2103.8 ± 1.1% | 498.1 ± 0.7% | 2.286 | 1.689 | 9.614 | 1.612 | 6.808 |
| string: http/html-1m | 1058582 | 6222.7 ± 1.4% | 2729.7 ± 0.5% | 2686.5 ± 1.1% | 440.8 ± 0.6% | 3472.5 ± 1.3% | 589.8 ± 6.3% | 2.280 | 2.316 | 14.115 | 1.792 | 10.550 |
| string: http/json-1m | 1190272 | 2558.2 ± 0.2% | 875.0 ± 0.7% | 2244.7 ± 0.8% | 389.7 ± 0.3% | 1054.8 ± 0.8% | 437.9 ± 0.7% | 2.924 | 1.140 | 6.565 | 2.425 | 5.841 |
| string: http/js-1m | 1144362 | 2281.7 ± 0.3% | 1026.2 ± 0.3% | 1636.9 ± 0.4% | 319.3 ± 0.9% | 1520.7 ± 0.8% | 414.4 ± 0.4% | 2.223 | 1.394 | 7.145 | 1.500 | 5.506 |
| string: http/css-1m | 1097820 | 2653.6 ± 0.4% | 1676.3 ± 0.5% | 2222.7 ± 0.7% | 405.1 ± 0.7% | 1944.8 ± 0.6% | 485.6 ± 1.3% | 1.583 | 1.194 | 6.550 | 1.365 | 5.464 |
| string: dickens as Cyrillic and CJK | 1883069 | 3077.8 ± 0.3% | 1682.9 ± 0.5% | 888.0 ± 0.5% | 351.4 ± 0.2% | 669.7 ± 0.4% | 155.6 ± 1.7% | 1.829 | 3.466 | 8.760 | 4.596 | 19.783 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.2 ± 0.3% | 978.8 ± 0.3% | 1196.6 ± 0.2% | 215.9 ± 0.2% | 468.9 ± 0.8% | 254.8 ± 3.1% | 1.358 | 1.111 | 6.158 | 2.835 | 5.216 |
| hex: silesia/dickens | 524290 | 12008.8 ± 0.1% | 3618.7 ± 0.2% | 3297.7 ± 0.3% | 506.5 ± 1.6% | 6078.6 ± 2.4% | 779.7 ± 1.8% | 3.319 | 3.642 | 23.708 | 1.976 | 15.401 |
| hex: silesia/mozilla | 524290 | 11976.3 ± 0.2% | 3616.1 ± 0.2% | 3293.1 ± 0.3% | 450.8 ± 0.9% | 6060.2 ± 1.7% | 778.1 ± 0.7% | 3.312 | 3.637 | 26.566 | 1.976 | 15.392 |
| hex: silesia/mr | 524290 | 11986.5 ± 0.4% | 3621.3 ± 0.2% | 3290.6 ± 0.3% | 568.1 ± 1.0% | 6070.7 ± 0.8% | 779.9 ± 0.3% | 3.310 | 3.643 | 21.099 | 1.974 | 15.369 |
| hex: silesia/nci | 524290 | 11987.8 ± 0.3% | 3617.7 ± 0.1% | 3291.5 ± 0.2% | 627.0 ± 2.7% | 6068.1 ± 1.2% | 780.2 ± 0.3% | 3.314 | 3.642 | 19.119 | 1.976 | 15.364 |
| hex: silesia/ooffice | 524290 | 11990.5 ± 0.3% | 3615.3 ± 0.2% | 3293.4 ± 0.2% | 402.1 ± 1.1% | 6079.2 ± 0.7% | 779.6 ± 0.2% | 3.317 | 3.641 | 29.823 | 1.972 | 15.380 |
| hex: silesia/osdb | 524290 | 11967.0 ± 0.3% | 3613.7 ± 0.5% | 3290.4 ± 0.4% | 480.9 ± 0.9% | 6085.4 ± 1.0% | 780.0 ± 0.4% | 3.312 | 3.637 | 24.884 | 1.967 | 15.343 |
| hex: silesia/reymont | 524290 | 11973.9 ± 0.1% | 3620.1 ± 0.3% | 3297.0 ± 0.3% | 517.7 ± 1.2% | 6081.3 ± 0.9% | 779.5 ± 0.4% | 3.308 | 3.632 | 23.130 | 1.969 | 15.360 |
| hex: silesia/samba | 524290 | 11910.0 ± 0.2% | 3618.9 ± 0.2% | 3292.1 ± 0.3% | 408.8 ± 0.4% | 6075.3 ± 1.5% | 779.8 ± 0.5% | 3.291 | 3.618 | 29.133 | 1.960 | 15.274 |
| hex: silesia/sao | 524290 | 11980.5 ± 0.2% | 3619.9 ± 0.6% | 3290.4 ± 0.5% | 343.7 ± 0.6% | 6041.8 ± 2.3% | 780.2 ± 0.8% | 3.310 | 3.641 | 34.856 | 1.983 | 15.355 |
| hex: silesia/webster | 524290 | 11979.9 ± 0.2% | 3617.9 ± 0.2% | 3290.0 ± 0.4% | 476.9 ± 2.0% | 6050.1 ± 0.7% | 780.2 ± 0.3% | 3.311 | 3.641 | 25.121 | 1.980 | 15.356 |
| hex: silesia/x-ray | 524290 | 12009.5 ± 0.1% | 3618.5 ± 0.1% | 3298.2 ± 0.2% | 486.0 ± 0.4% | 6096.1 ± 1.4% | 781.5 ± 0.3% | 3.319 | 3.641 | 24.710 | 1.970 | 15.368 |
| hex: silesia/xml | 524290 | 12006.3 ± 0.2% | 3623.0 ± 0.2% | 3300.4 ± 0.3% | 533.3 ± 0.5% | 6053.6 ± 0.6% | 779.1 ± 0.5% | 3.314 | 3.638 | 22.514 | 1.983 | 15.410 |
| hex: canterbury/alice29.txt | 304180 | 12000.5 ± 0.2% | 3634.5 ± 1.2% | 3346.1 ± 0.1% | 524.4 ± 0.4% | 6082.0 ± 1.1% | 779.8 ± 0.4% | 3.302 | 3.586 | 22.883 | 1.973 | 15.390 |
| hex: canterbury/asyoulik.txt | 250360 | 11990.1 ± 0.2% | 3641.5 ± 0.0% | 3369.4 ± 0.1% | 516.9 ± 0.1% | 6071.5 ± 2.1% | 776.6 ± 0.5% | 3.293 | 3.559 | 23.196 | 1.975 | 15.439 |
| hex: canterbury/cp.html | 49208 | 11924.5 ± 0.0% | 3638.6 ± 0.1% | 3281.7 ± 0.3% | 476.4 ± 3.7% | 6281.8 ± 0.2% | 760.2 ± 1.2% | 3.277 | 3.634 | 25.031 | 1.898 | 15.686 |
| hex: canterbury/fields.c | 22302 | 11779.8 ± 0.1% | 3628.0 ± 0.1% | 3351.4 ± 0.1% | 511.2 ± 0.6% | 6250.8 ± 0.5% | 755.3 ± 2.0% | 3.247 | 3.515 | 23.042 | 1.885 | 15.597 |
| hex: canterbury/grammar.lsp | 7444 | 11309.3 ± 0.1% | 3599.3 ± 0.1% | 3346.2 ± 0.5% | 538.6 ± 1.8% | 6171.5 ± 0.9% | 712.1 ± 2.0% | 3.142 | 3.380 | 20.999 | 1.833 | 15.882 |
| hex: canterbury/kennedy.xls | 524290 | 11983.9 ± 0.2% | 3616.9 ± 0.2% | 3293.3 ± 0.2% | 659.9 ± 2.5% | 6097.6 ± 1.2% | 773.3 ± 2.3% | 3.313 | 3.639 | 18.161 | 1.965 | 15.497 |
| hex: canterbury/lcet10.txt | 524290 | 12013.5 ± 0.1% | 3616.5 ± 0.3% | 3283.9 ± 0.8% | 513.9 ± 0.5% | 6091.2 ± 1.2% | 774.6 ± 4.9% | 3.322 | 3.658 | 23.378 | 1.972 | 15.509 |
| hex: canterbury/plrabn12.txt | 524290 | 11989.5 ± 0.2% | 3618.7 ± 0.2% | 3297.6 ± 0.3% | 504.9 ± 0.5% | 6062.8 ± 1.0% | 778.3 ± 0.6% | 3.313 | 3.636 | 23.745 | 1.978 | 15.404 |
| hex: canterbury/ptt5 | 524290 | 11995.3 ± 0.1% | 3616.0 ± 0.3% | 3286.5 ± 0.4% | 558.4 ± 0.6% | 6124.7 ± 1.3% | 779.4 ± 0.7% | 3.317 | 3.650 | 21.483 | 1.959 | 15.389 |
| hex: canterbury/sum | 76482 | 11907.4 ± 0.3% | 3632.6 ± 0.0% | 3354.0 ± 0.1% | 510.7 ± 2.4% | 6181.8 ± 0.9% | 771.9 ± 1.3% | 3.278 | 3.550 | 23.318 | 1.926 | 15.426 |
| hex: canterbury/xargs.1 | 8456 | 11351.0 ± 0.1% | 3601.7 ± 0.1% | 3366.4 ± 0.3% | 497.1 ± 4.5% | 6141.8 ± 0.4% | 743.5 ± 1.7% | 3.152 | 3.372 | 22.834 | 1.848 | 15.267 |
| hex: canterbury-large/E.coli | 524290 | 12006.9 ± 0.3% | 3620.5 ± 0.1% | 3297.9 ± 0.2% | 688.6 ± 0.1% | 6061.0 ± 1.4% | 755.8 ± 4.9% | 3.316 | 3.641 | 17.436 | 1.981 | 15.887 |
| hex: canterbury-large/bible.txt | 524290 | 11988.5 ± 0.0% | 3619.3 ± 0.1% | 3279.7 ± 0.3% | 523.4 ± 1.7% | 6111.9 ± 1.1% | 778.9 ± 1.6% | 3.312 | 3.655 | 22.907 | 1.961 | 15.392 |
| hex: canterbury-large/world192.txt | 524290 | 12021.7 ± 0.1% | 3616.5 ± 0.2% | 3300.5 ± 0.4% | 491.9 ± 0.5% | 6111.0 ± 1.2% | 781.4 ± 0.5% | 3.324 | 3.642 | 24.440 | 1.967 | 15.384 |
| hex: http/html-1kx1024 | 2099200 | 8894.5 ± 5.0% | 3460.1 ± 0.2% | 2853.7 ± 0.3% | 476.6 ± 0.9% | 5153.7 ± 0.4% | 626.8 ± 2.7% | 2.571 | 3.117 | 18.664 | 1.726 | 14.191 |
| hex: http/html-16kx64 | 2097280 | 11760.8 ± 0.7% | 3611.4 ± 0.2% | 3259.9 ± 0.4% | 477.3 ± 1.0% | 6031.6 ± 0.8% | 743.3 ± 2.5% | 3.257 | 3.608 | 24.639 | 1.950 | 15.823 |
| hex: http/html-1m | 524290 | 12003.9 ± 0.2% | 3618.2 ± 0.4% | 3297.5 ± 0.3% | 500.8 ± 2.7% | 6102.4 ± 1.2% | 774.7 ± 3.4% | 3.318 | 3.640 | 23.971 | 1.967 | 15.495 |
| hex: http/json-1kx1024 | 2099200 | 8790.9 ± 4.8% | 3455.6 ± 0.3% | 2841.5 ± 0.6% | 575.3 ± 0.3% | 5136.2 ± 1.4% | 622.0 ± 3.0% | 2.544 | 3.094 | 15.281 | 1.712 | 14.133 |
| hex: http/json-16kx64 | 2097280 | 11763.8 ± 1.2% | 3606.6 ± 0.2% | 3263.6 ± 0.3% | 573.4 ± 1.7% | 6017.8 ± 0.4% | 742.8 ± 1.1% | 3.262 | 3.604 | 20.517 | 1.955 | 15.838 |
| hex: http/json-1m | 524290 | 11990.0 ± 0.0% | 3613.8 ± 0.2% | 3299.2 ± 0.3% | 592.5 ± 4.7% | 6097.9 ± 1.6% | 778.4 ± 1.3% | 3.318 | 3.634 | 20.237 | 1.966 | 15.404 |
| hex: http/js-1kx1024 | 2099200 | 8854.8 ± 3.4% | 3459.2 ± 0.2% | 2847.9 ± 0.6% | 480.2 ± 1.1% | 5121.6 ± 1.2% | 627.4 ± 2.3% | 2.560 | 3.109 | 18.439 | 1.729 | 14.114 |
| hex: http/js-16kx64 | 2097280 | 11763.5 ± 0.1% | 3609.8 ± 0.2% | 3254.8 ± 0.4% | 480.3 ± 0.5% | 6011.0 ± 0.7% | 744.6 ± 2.2% | 3.259 | 3.614 | 24.492 | 1.957 | 15.797 |
| hex: http/js-1m | 524290 | 12007.3 ± 0.2% | 3614.5 ± 0.3% | 3292.5 ± 0.2% | 520.9 ± 3.9% | 6025.5 ± 3.0% | 780.6 ± 3.2% | 3.322 | 3.647 | 23.053 | 1.993 | 15.383 |
| hex: http/css-1kx1024 | 2099200 | 8869.7 ± 4.3% | 3463.1 ± 0.1% | 2857.4 ± 0.7% | 489.1 ± 0.6% | 5147.7 ± 1.3% | 632.0 ± 1.0% | 2.561 | 3.104 | 18.134 | 1.723 | 14.034 |
| hex: http/css-16kx64 | 2097280 | 11774.3 ± 0.1% | 3610.4 ± 0.1% | 3254.7 ± 0.2% | 494.2 ± 1.5% | 6010.6 ± 0.8% | 746.4 ± 2.6% | 3.261 | 3.618 | 23.824 | 1.959 | 15.775 |
| hex: http/css-1m | 524290 | 11978.6 ± 0.1% | 3613.9 ± 0.3% | 3289.9 ± 0.3% | 496.3 ± 4.5% | 6026.1 ± 0.8% | 764.6 ± 2.7% | 3.315 | 3.641 | 24.137 | 1.988 | 15.667 |
| hex: shuffled/dickens-1m | 524290 | 11951.5 ± 0.3% | 3612.5 ± 0.3% | 3296.0 ± 0.1% | 512.1 ± 1.0% | 5980.5 ± 0.8% | 779.9 ± 3.0% | 3.308 | 3.626 | 23.337 | 1.998 | 15.325 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1350.7 ± 0.3% | 1245.9 ± 0.2% | 1033.7 ± 0.4% | 408.6 ± 0.3% | 448.0 ± 0.4% | 415.2 ± 0.6% | 1.084 | 1.307 | 3.306 | 3.015 | 3.253 |
| qlog records, JSON text sequence | 1467503 | 1047.9 ± 0.2% | 1058.6 ± 0.6% | 785.5 ± 2.0% | 378.3 ± 1.2% | 465.2 ± 1.5% | 277.9 ± 0.8% | 0.990 | 1.334 | 2.770 | 2.253 | 3.770 |
| string: silesia/dickens | 172528 | 6917.3 ± 0.2% | 2822.4 ± 0.5% | 2922.3 ± 0.3% | 429.0 ± 0.8% | 1592.1 ± 0.2% | 1009.8 ± 0.1% | 2.451 | 2.367 | 16.124 | 4.345 | 6.850 |
| string: silesia/nci | 1075110 | 7303.2 ± 0.5% | 3408.3 ± 0.8% | 3093.2 ± 0.4% | 814.6 ± 1.3% | 1860.7 ± 0.2% | 1107.4 ± 0.4% | 2.143 | 2.361 | 8.965 | 3.925 | 6.595 |
| string: silesia/reymont | 1075159 | 3324.6 ± 1.6% | 1992.9 ± 1.2% | 2057.3 ± 0.4% | 449.3 ± 0.8% | 1507.1 ± 1.6% | 948.7 ± 0.5% | 1.668 | 1.616 | 7.399 | 2.206 | 3.505 |
| string: silesia/samba | 97582 | 4197.8 ± 0.7% | 2113.7 ± 0.7% | 3442.3 ± 0.5% | 353.6 ± 0.5% | 1436.7 ± 0.9% | 1047.8 ± 0.3% | 1.986 | 1.219 | 11.871 | 2.922 | 4.006 |
| string: silesia/webster | 1098490 | 4071.3 ± 0.2% | 1881.9 ± 0.2% | 2056.5 ± 0.3% | 440.7 ± 0.4% | 1393.8 ± 0.4% | 645.7 ± 1.3% | 2.163 | 1.980 | 9.238 | 2.921 | 6.305 |
| string: silesia/xml | 1090118 | 6130.1 ± 0.1% | 2863.5 ± 0.5% | 2644.8 ± 0.3% | 610.5 ± 0.4% | 1755.6 ± 0.3% | 920.2 ± 0.3% | 2.141 | 2.318 | 10.041 | 3.492 | 6.661 |
| string: canterbury/alice29.txt | 159425 | 6453.8 ± 0.3% | 2199.8 ± 0.3% | 2760.4 ± 0.2% | 406.8 ± 1.0% | 1480.1 ± 0.3% | 950.3 ± 0.2% | 2.934 | 2.338 | 15.864 | 4.360 | 6.791 |
| string: canterbury/asyoulik.txt | 132198 | 5683.8 ± 1.1% | 1717.6 ± 0.3% | 2371.4 ± 0.5% | 401.5 ± 0.6% | 1347.2 ± 0.6% | 883.7 ± 0.5% | 3.309 | 2.397 | 14.157 | 4.219 | 6.432 |
| string: canterbury/lcet10.txt | 441884 | 6255.3 ± 1.0% | 2574.1 ± 0.3% | 2506.9 ± 2.0% | 466.9 ± 1.1% | 1542.0 ± 0.2% | 987.7 ± 0.3% | 2.430 | 2.495 | 13.398 | 4.057 | 6.334 |
| string: canterbury/plrabn12.txt | 503330 | 5723.7 ± 0.3% | 2059.0 ± 0.2% | 2064.0 ± 0.9% | 422.7 ± 0.5% | 1430.9 ± 0.3% | 933.1 ± 0.5% | 2.780 | 2.773 | 13.542 | 4.000 | 6.134 |
| string: canterbury-large/E.coli | 1048578 | 19307.1 ± 0.3% | 9771.8 ± 3.4% | 3785.0 ± 0.7% | 1473.4 ± 0.5% | 2359.8 ± 0.2% | 1189.8 ± 0.6% | 1.976 | 5.101 | 13.104 | 8.182 | 16.227 |
| string: canterbury-large/bible.txt | 1055886 | 6797.4 ± 0.4% | 4162.7 ± 0.6% | 3064.4 ± 1.8% | 503.8 ± 0.2% | 1970.8 ± 0.6% | 1119.2 ± 0.5% | 1.633 | 2.218 | 13.492 | 3.449 | 6.074 |
| string: canterbury-large/world192.txt | 1103121 | 4052.8 ± 0.5% | 1658.2 ± 0.3% | 2000.7 ± 1.4% | 446.6 ± 0.5% | 1359.4 ± 0.4% | 907.2 ± 0.6% | 2.444 | 2.026 | 9.076 | 2.981 | 4.467 |
| string: http/html-1m | 1058582 | 6761.2 ± 1.6% | 3993.8 ± 0.3% | 3041.5 ± 0.2% | 500.5 ± 0.8% | 1918.0 ± 0.3% | 804.6 ± 0.3% | 1.693 | 2.223 | 13.510 | 3.525 | 8.403 |
| string: http/json-1m | 1190272 | 3163.4 ± 0.3% | 1346.7 ± 0.3% | 1555.1 ± 0.4% | 442.7 ± 0.7% | 960.2 ± 0.2% | 764.4 ± 1.4% | 2.349 | 2.034 | 7.145 | 3.295 | 4.138 |
| string: http/js-1m | 1144362 | 2765.0 ± 0.3% | 1179.7 ± 0.3% | 1621.3 ± 0.5% | 367.8 ± 0.4% | 1094.0 ± 0.2% | 757.2 ± 0.3% | 2.344 | 1.705 | 7.517 | 2.527 | 3.652 |
| string: http/css-1m | 1097820 | 3997.2 ± 0.9% | 1486.0 ± 0.7% | 2146.6 ± 1.3% | 493.4 ± 0.2% | 1370.0 ± 0.1% | 893.3 ± 0.4% | 2.690 | 1.862 | 8.101 | 2.918 | 4.474 |
| string: dickens as Cyrillic and CJK | 1883069 | 3067.1 ± 0.2% | 2341.9 ± 0.5% | 521.4 ± 0.3% | 307.1 ± 0.6% | 561.5 ± 0.9% | 335.1 ± 0.2% | 1.310 | 5.882 | 9.986 | 5.462 | 9.153 |
| hex: silesia/dickens | 524290 | 15639.5 ± 0.1% | 1466.2 ± 0.1% | 1082.8 ± 0.1% | 501.6 ± 0.6% | 986.9 ± 0.3% | 733.4 ± 0.4% | 10.667 | 14.444 | 31.178 | 15.847 | 21.326 |
| hex: silesia/mozilla | 524290 | 15645.5 ± 0.6% | 1474.3 ± 0.3% | 1088.0 ± 0.2% | 440.9 ± 0.5% | 990.5 ± 0.4% | 734.1 ± 0.4% | 10.612 | 14.380 | 35.486 | 15.795 | 21.313 |
| hex: silesia/mr | 524290 | 15677.9 ± 0.4% | 1482.2 ± 0.8% | 1091.7 ± 1.6% | 561.7 ± 2.1% | 993.2 ± 0.4% | 734.0 ± 0.4% | 10.578 | 14.360 | 27.909 | 15.785 | 21.359 |
| hex: silesia/nci | 524290 | 15626.8 ± 0.3% | 1475.2 ± 0.1% | 1086.5 ± 0.2% | 646.2 ± 3.7% | 988.7 ± 0.2% | 733.1 ± 0.3% | 10.593 | 14.383 | 24.183 | 15.805 | 21.315 |
| hex: silesia/ooffice | 524290 | 15632.2 ± 0.5% | 1470.8 ± 0.4% | 1084.2 ± 0.5% | 388.9 ± 0.7% | 988.2 ± 0.3% | 734.0 ± 0.3% | 10.628 | 14.418 | 40.194 | 15.819 | 21.296 |
| hex: silesia/osdb | 524290 | 15673.4 ± 0.4% | 1470.8 ± 0.5% | 1084.0 ± 0.3% | 469.1 ± 1.9% | 990.8 ± 0.1% | 734.2 ± 0.3% | 10.656 | 14.460 | 33.410 | 15.819 | 21.348 |
| hex: silesia/reymont | 524290 | 15670.9 ± 0.2% | 1465.0 ± 0.5% | 1082.2 ± 0.6% | 513.0 ± 1.0% | 986.4 ± 0.4% | 733.6 ± 0.3% | 10.697 | 14.481 | 30.546 | 15.887 | 21.363 |
| hex: silesia/samba | 524290 | 15659.0 ± 0.1% | 1471.6 ± 0.3% | 1083.2 ± 0.4% | 401.4 ± 0.4% | 988.4 ± 0.4% | 734.4 ± 0.6% | 10.641 | 14.457 | 39.013 | 15.842 | 21.324 |
| hex: silesia/sao | 524290 | 15614.7 ± 0.4% | 1464.1 ± 0.3% | 1080.8 ± 0.4% | 332.4 ± 0.6% | 987.4 ± 0.1% | 734.0 ± 0.2% | 10.665 | 14.448 | 46.970 | 15.814 | 21.275 |
| hex: silesia/webster | 524290 | 15653.5 ± 0.6% | 1470.2 ± 0.2% | 1084.0 ± 0.1% | 475.1 ± 0.4% | 988.4 ± 0.3% | 733.9 ± 0.5% | 10.647 | 14.441 | 32.948 | 15.837 | 21.330 |
| hex: silesia/x-ray | 524290 | 15632.6 ± 0.3% | 1477.0 ± 0.1% | 1089.6 ± 0.2% | 447.0 ± 1.3% | 994.6 ± 0.3% | 733.4 ± 1.1% | 10.584 | 14.347 | 34.971 | 15.717 | 21.316 |
| hex: silesia/xml | 524290 | 15628.4 ± 0.3% | 1467.9 ± 0.2% | 1082.8 ± 0.3% | 615.1 ± 1.3% | 990.3 ± 1.0% | 734.1 ± 0.5% | 10.647 | 14.433 | 25.407 | 15.782 | 21.290 |
| hex: canterbury/alice29.txt | 304180 | 15681.6 ± 0.1% | 1477.0 ± 0.4% | 1089.7 ± 0.5% | 504.1 ± 0.7% | 993.0 ± 0.3% | 734.2 ± 0.7% | 10.618 | 14.391 | 31.108 | 15.792 | 21.358 |
| hex: canterbury/asyoulik.txt | 250360 | 15706.0 ± 0.2% | 1473.7 ± 0.2% | 1092.1 ± 0.2% | 498.1 ± 1.1% | 993.1 ± 0.4% | 738.1 ± 0.2% | 10.658 | 14.381 | 31.529 | 15.815 | 21.280 |
| hex: canterbury/cp.html | 49208 | 15655.5 ± 0.2% | 1481.9 ± 0.7% | 1097.9 ± 0.2% | 532.5 ± 0.5% | 1001.4 ± 0.2% | 743.4 ± 0.1% | 10.565 | 14.260 | 29.401 | 15.633 | 21.061 |
| hex: canterbury/fields.c | 22302 | 15516.0 ± 0.0% | 1436.2 ± 0.7% | 1067.6 ± 0.6% | 605.2 ± 6.8% | 994.1 ± 0.2% | 736.1 ± 0.1% | 10.803 | 14.534 | 25.638 | 15.608 | 21.079 |
| hex: canterbury/grammar.lsp | 7444 | 15150.3 ± 0.1% | 1488.6 ± 0.6% | 1091.8 ± 0.4% | 669.4 ± 4.2% | 1002.3 ± 0.1% | 726.1 ± 0.2% | 10.178 | 13.876 | 22.633 | 15.116 | 20.865 |
| hex: canterbury/kennedy.xls | 524290 | 15650.3 ± 0.2% | 1474.6 ± 0.2% | 1089.0 ± 0.3% | 658.4 ± 0.7% | 990.4 ± 0.6% | 735.4 ± 1.0% | 10.613 | 14.372 | 23.770 | 15.802 | 21.282 |
| hex: canterbury/lcet10.txt | 524290 | 15635.7 ± 0.5% | 1467.0 ± 0.3% | 1087.2 ± 0.6% | 501.2 ± 0.3% | 988.3 ± 0.5% | 734.9 ± 0.3% | 10.658 | 14.381 | 31.196 | 15.821 | 21.277 |
| hex: canterbury/plrabn12.txt | 524290 | 15635.7 ± 0.1% | 1468.4 ± 0.5% | 1081.4 ± 0.4% | 491.0 ± 3.1% | 987.7 ± 0.4% | 733.1 ± 0.4% | 10.648 | 14.459 | 31.841 | 15.830 | 21.329 |
| hex: canterbury/ptt5 | 524290 | 15627.5 ± 0.4% | 1482.8 ± 0.0% | 1091.1 ± 0.2% | 555.9 ± 1.0% | 997.3 ± 0.5% | 734.0 ± 0.4% | 10.539 | 14.322 | 28.112 | 15.670 | 21.290 |
| hex: canterbury/sum | 76482 | 15676.0 ± 0.0% | 1495.0 ± 0.1% | 1104.3 ± 0.4% | 592.4 ± 2.2% | 998.1 ± 0.1% | 743.6 ± 0.1% | 10.486 | 14.195 | 26.463 | 15.706 | 21.082 |
| hex: canterbury/xargs.1 | 8456 | 15203.6 ± 0.1% | 1431.7 ± 1.1% | 1095.1 ± 0.7% | 652.2 ± 4.0% | 1000.8 ± 0.3% | 728.2 ± 0.3% | 10.619 | 13.883 | 23.311 | 15.192 | 20.878 |
| hex: canterbury-large/E.coli | 524290 | 15663.1 ± 0.2% | 1475.2 ± 0.5% | 1088.1 ± 0.6% | 671.0 ± 0.2% | 990.9 ± 0.3% | 731.8 ± 0.5% | 10.618 | 14.395 | 23.344 | 15.808 | 21.403 |
| hex: canterbury-large/bible.txt | 524290 | 15591.9 ± 0.4% | 1469.9 ± 0.2% | 1084.7 ± 0.2% | 512.9 ± 0.6% | 991.3 ± 0.4% | 733.9 ± 0.7% | 10.607 | 14.374 | 30.401 | 15.729 | 21.245 |
| hex: canterbury-large/world192.txt | 524290 | 15625.1 ± 0.2% | 1470.1 ± 0.4% | 1083.6 ± 0.5% | 502.7 ± 0.8% | 988.9 ± 0.2% | 733.0 ± 0.7% | 10.629 | 14.420 | 31.085 | 15.801 | 21.318 |
| hex: http/html-1kx1024 | 2099200 | 14198.6 ± 0.6% | 1455.9 ± 0.3% | 1062.1 ± 0.3% | 501.9 ± 0.2% | 983.0 ± 0.2% | 692.6 ± 0.3% | 9.752 | 13.368 | 28.289 | 14.445 | 20.502 |
| hex: http/html-16kx64 | 2097280 | 15385.9 ± 0.3% | 1444.2 ± 0.2% | 1075.7 ± 0.4% | 508.1 ± 0.3% | 995.6 ± 0.1% | 734.7 ± 0.1% | 10.654 | 14.303 | 30.283 | 15.454 | 20.942 |
| hex: http/html-1m | 524290 | 15658.9 ± 0.3% | 1468.1 ± 0.4% | 1083.8 ± 0.6% | 502.1 ± 0.3% | 989.4 ± 0.3% | 733.4 ± 0.4% | 10.666 | 14.448 | 31.189 | 15.827 | 21.351 |
| hex: http/json-1kx1024 | 2099200 | 14160.3 ± 0.6% | 1463.0 ± 0.1% | 1067.4 ± 0.3% | 609.1 ± 0.3% | 986.0 ± 0.1% | 692.0 ± 0.3% | 9.679 | 13.267 | 23.248 | 14.362 | 20.462 |
| hex: http/json-16kx64 | 2097280 | 15385.7 ± 0.4% | 1445.4 ± 0.1% | 1075.1 ± 0.1% | 617.9 ± 0.3% | 994.6 ± 0.3% | 734.5 ± 0.2% | 10.645 | 14.311 | 24.898 | 15.470 | 20.947 |
| hex: http/json-1m | 524290 | 15677.9 ± 0.3% | 1476.9 ± 0.4% | 1087.6 ± 0.2% | 638.4 ± 0.9% | 992.5 ± 0.1% | 733.7 ± 0.3% | 10.616 | 14.416 | 24.559 | 15.796 | 21.367 |
| hex: http/js-1kx1024 | 2099200 | 14180.9 ± 0.6% | 1454.3 ± 0.2% | 1062.4 ± 0.3% | 498.7 ± 0.3% | 981.6 ± 0.2% | 691.9 ± 0.3% | 9.751 | 13.349 | 28.436 | 14.446 | 20.497 |
| hex: http/js-16kx64 | 2097280 | 15385.5 ± 0.3% | 1444.9 ± 0.1% | 1074.6 ± 0.2% | 506.4 ± 0.3% | 998.7 ± 0.3% | 734.8 ± 0.2% | 10.648 | 14.317 | 30.385 | 15.406 | 20.939 |
| hex: http/js-1m | 524290 | 15638.2 ± 0.3% | 1470.7 ± 0.2% | 1085.2 ± 0.4% | 512.8 ± 0.4% | 990.0 ± 0.4% | 733.9 ± 0.2% | 10.633 | 14.410 | 30.498 | 15.796 | 21.309 |
| hex: http/css-1kx1024 | 2099200 | 14150.5 ± 0.7% | 1453.4 ± 0.1% | 1061.4 ± 0.2% | 532.0 ± 0.2% | 982.4 ± 0.1% | 692.3 ± 0.1% | 9.736 | 13.332 | 26.598 | 14.404 | 20.441 |
| hex: http/css-16kx64 | 2097280 | 15403.6 ± 0.4% | 1445.4 ± 0.3% | 1074.8 ± 0.6% | 542.3 ± 0.7% | 996.5 ± 0.5% | 734.4 ± 0.1% | 10.657 | 14.331 | 28.404 | 15.457 | 20.975 |
| hex: http/css-1m | 524290 | 15611.4 ± 0.2% | 1469.7 ± 0.3% | 1086.2 ± 0.2% | 529.2 ± 0.3% | 989.3 ± 0.2% | 734.0 ± 0.2% | 10.622 | 14.373 | 29.501 | 15.780 | 21.270 |
| hex: shuffled/dickens-1m | 524290 | 15675.4 ± 0.2% | 1467.0 ± 0.9% | 1085.3 ± 0.5% | 500.7 ± 0.6% | 990.5 ± 0.5% | 734.0 ± 0.8% | 10.685 | 14.443 | 31.310 | 15.826 | 21.357 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.918 of yyjson.
