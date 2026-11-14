# bench-json

| Field | Value |
|---|---|
| Commit | 0a93ce6 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43625788040 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.1 ± 0.6% | 0.521 | 0.965 | 0.995 | 0.998 | 0.460 | 1.001 | 1.005 | 0.388 | 0.831 | 0.899 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 817.7 ± 1.1% | 0.822 | 1.014 | 1.013 | 1.010 | 0.463 | 0.999 | 1.037 | 0.410 | 0.955 | 1.024 | 0.129 |
| string: silesia/dickens | 172528 | 5042.8 ± 0.2% | 0.033 | 0.782 | 1.003 | 1.004 | 0.196 | 1.017 | 1.007 | 0.197 | 1.002 | 1.003 | 0.032 |
| string: silesia/nci | 1075110 | 4276.4 ± 0.5% | 0.039 | 0.807 | 1.005 | 1.006 | 0.281 | 1.009 | 1.001 | 0.281 | 1.003 | 1.003 | 0.038 |
| string: silesia/reymont | 1075159 | 2940.2 ± 1.7% | 0.057 | 0.813 | 0.998 | 0.998 | 0.359 | 1.001 | 1.005 | 0.358 | 1.014 | 1.015 | 0.056 |
| string: silesia/samba | 97582 | 3487.9 ± 0.6% | 0.040 | 0.864 | 1.005 | 1.006 | 0.069 | 0.780 | 1.012 | 0.073 | 1.004 | 1.007 | 0.039 |
| string: silesia/webster | 1098490 | 3627.7 ± 1.3% | 0.045 | 0.850 | 1.005 | 1.008 | 0.205 | 1.021 | 1.017 | 0.205 | 1.010 | 1.011 | 0.044 |
| string: silesia/xml | 1090118 | 4774.5 ± 0.4% | 0.035 | 0.808 | 1.004 | 1.007 | 0.222 | 0.982 | 1.006 | 0.224 | 1.006 | 1.009 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4314.4 ± 0.4% | 0.038 | 0.751 | 1.004 | 1.008 | 0.172 | 1.031 | 1.017 | 0.171 | 1.013 | 1.014 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3449.3 ± 1.7% | 0.046 | 0.749 | 1.007 | 1.011 | 0.177 | 1.006 | 0.970 | 0.176 | 1.009 | 1.009 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5097.4 ± 0.6% | 0.032 | 0.816 | 1.005 | 1.006 | 0.196 | 1.022 | 1.011 | 0.196 | 1.005 | 1.004 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4074.6 ± 0.6% | 0.040 | 0.833 | 1.005 | 1.006 | 0.201 | 1.024 | 1.008 | 0.201 | 1.006 | 1.006 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 18834.5 ± 2.0% | 0.078 | 1.015 | 1.014 | 1.011 | 0.486 | 1.017 | 1.013 | 0.486 | 0.630 | 0.630 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6669.8 ± 0.7% | 0.026 | 0.805 | 1.005 | 1.007 | 0.433 | 1.032 | 1.041 | 0.434 | 1.034 | 1.038 | 0.026 |
| string: canterbury-large/world192.txt | 1103121 | 3371.6 ± 0.3% | 0.048 | 0.848 | 1.006 | 1.007 | 0.198 | 1.015 | 1.010 | 0.199 | 1.007 | 1.005 | 0.047 |
| string: http/html-1m | 1058582 | 6047.9 ± 0.5% | 0.028 | 0.782 | 1.000 | 1.004 | 0.390 | 1.042 | 1.054 | 0.390 | 1.027 | 1.031 | 0.028 |
| string: http/json-1m | 1190272 | 2534.8 ± 0.6% | 0.056 | 0.957 | 1.009 | 1.006 | 0.111 | 1.008 | 0.473 | 0.111 | 1.007 | 1.007 | 0.055 |
| string: http/js-1m | 1144362 | 2279.2 ± 0.8% | 0.066 | 0.889 | 1.004 | 1.002 | 0.175 | 1.054 | 1.044 | 0.175 | 1.003 | 1.002 | 0.066 |
| string: http/css-1m | 1097820 | 2630.8 ± 0.7% | 0.061 | 0.776 | 1.007 | 1.009 | 0.241 | 1.011 | 1.015 | 0.240 | 1.006 | 1.007 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3060.7 ± 0.8% | 0.044 | 0.125 | 1.004 | 1.003 | 0.338 | 1.001 | 1.011 | 0.337 | 1.005 | 1.007 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.2 ± 1.0% | 0.082 | 1.003 | 1.002 | 1.001 | 0.077 | 0.637 | 1.004 | 0.081 | 1.003 | 1.003 | 0.081 |
| hex: silesia/dickens | 524290 | 18456.3 ± 1.6% | 0.081 | 1.013 | 0.995 | 0.993 | 0.531 | 0.996 | 0.994 | 0.532 | 0.651 | 0.651 | 0.009 |
| hex: silesia/mozilla | 524290 | 17841.0 ± 1.2% | 0.083 | 1.008 | 0.993 | 0.997 | 0.537 | 0.996 | 0.999 | 0.539 | 0.672 | 0.672 | 0.010 |
| hex: silesia/mr | 524290 | 17929.4 ± 0.7% | 0.083 | 0.998 | 0.995 | 0.994 | 0.531 | 0.997 | 1.000 | 0.532 | 0.669 | 0.668 | 0.010 |
| hex: silesia/nci | 524290 | 18301.9 ± 0.8% | 0.081 | 1.012 | 0.993 | 0.994 | 0.506 | 0.998 | 0.999 | 0.509 | 0.656 | 0.656 | 0.010 |
| hex: silesia/ooffice | 524290 | 18199.9 ± 0.4% | 0.082 | 1.009 | 0.995 | 0.995 | 0.537 | 1.001 | 1.003 | 0.538 | 0.659 | 0.659 | 0.010 |
| hex: silesia/osdb | 524290 | 17900.1 ± 0.9% | 0.083 | 1.016 | 1.008 | 1.009 | 0.523 | 1.015 | 1.006 | 0.524 | 0.669 | 0.670 | 0.010 |
| hex: silesia/reymont | 524290 | 18185.8 ± 0.9% | 0.082 | 1.011 | 0.996 | 0.995 | 0.533 | 1.003 | 0.998 | 0.530 | 0.661 | 0.661 | 0.010 |
| hex: silesia/samba | 524290 | 17657.8 ± 0.7% | 0.084 | 1.005 | 1.004 | 1.006 | 0.533 | 1.003 | 1.001 | 0.534 | 0.677 | 0.677 | 0.010 |
| hex: silesia/sao | 524290 | 18337.1 ± 0.7% | 0.081 | 1.012 | 0.997 | 0.998 | 0.534 | 1.003 | 0.994 | 0.539 | 0.655 | 0.656 | 0.009 |
| hex: silesia/webster | 524290 | 18420.8 ± 1.0% | 0.080 | 0.996 | 0.988 | 0.987 | 0.506 | 0.998 | 0.990 | 0.506 | 0.650 | 0.651 | 0.009 |
| hex: silesia/x-ray | 524290 | 18170.4 ± 0.2% | 0.082 | 1.007 | 1.003 | 1.004 | 0.519 | 1.000 | 1.000 | 0.519 | 0.660 | 0.655 | 0.010 |
| hex: silesia/xml | 524290 | 18052.5 ± 2.8% | 0.082 | 1.015 | 1.000 | 1.002 | 0.519 | 0.996 | 1.000 | 0.522 | 0.665 | 0.665 | 0.010 |
| hex: canterbury/alice29.txt | 304180 | 19195.7 ± 0.6% | 0.078 | 0.998 | 1.000 | 0.999 | 0.519 | 1.002 | 0.999 | 0.522 | 0.625 | 0.625 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 18772.9 ± 0.4% | 0.080 | 0.998 | 0.989 | 0.990 | 0.522 | 0.993 | 0.999 | 0.526 | 0.639 | 0.639 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19268.5 ± 0.7% | 0.082 | 1.002 | 1.001 | 1.000 | 0.543 | 1.002 | 1.002 | 0.541 | 0.618 | 0.619 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18733.2 ± 0.8% | 0.083 | 1.009 | 1.009 | 1.009 | 0.538 | 1.008 | 1.009 | 0.540 | 0.629 | 0.629 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17281.0 ± 0.7% | 0.090 | 1.009 | 1.009 | 1.009 | 0.534 | 1.008 | 1.008 | 0.541 | 0.652 | 0.655 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18203.8 ± 1.8% | 0.082 | 0.999 | 0.991 | 0.990 | 0.531 | 0.991 | 0.993 | 0.532 | 0.660 | 0.661 | 0.010 |
| hex: canterbury/lcet10.txt | 524290 | 18504.1 ± 3.0% | 0.080 | 1.011 | 0.995 | 0.990 | 0.516 | 0.985 | 0.978 | 0.517 | 0.648 | 0.647 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 17990.4 ± 0.5% | 0.083 | 1.012 | 1.007 | 1.005 | 0.546 | 1.001 | 1.002 | 0.546 | 0.668 | 0.668 | 0.010 |
| hex: canterbury/ptt5 | 524290 | 17775.8 ± 0.5% | 0.084 | 1.011 | 1.001 | 0.999 | 0.540 | 1.006 | 1.003 | 0.540 | 0.675 | 0.675 | 0.010 |
| hex: canterbury/sum | 76482 | 19258.5 ± 0.4% | 0.078 | 1.002 | 1.003 | 1.003 | 0.519 | 1.002 | 1.002 | 0.520 | 0.619 | 0.619 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17672.2 ± 0.7% | 0.087 | 1.002 | 1.002 | 1.003 | 0.528 | 1.001 | 1.002 | 0.536 | 0.642 | 0.642 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 17964.8 ± 1.0% | 0.083 | 1.008 | 1.005 | 1.003 | 0.525 | 1.011 | 1.005 | 0.526 | 0.667 | 0.667 | 0.010 |
| hex: canterbury-large/bible.txt | 524290 | 18125.1 ± 1.1% | 0.082 | 1.019 | 0.999 | 0.998 | 0.532 | 1.001 | 0.996 | 0.534 | 0.663 | 0.663 | 0.010 |
| hex: canterbury-large/world192.txt | 524290 | 17561.4 ± 0.7% | 0.085 | 1.012 | 1.011 | 1.008 | 0.540 | 1.011 | 1.013 | 0.539 | 0.684 | 0.683 | 0.010 |
| hex: http/html-1kx1024 | 2099200 | 9026.4 ± 15.5% | 0.157 | 1.241 | 1.232 | 1.236 | 0.722 | 1.241 | 0.964 | 0.762 | 0.968 | 0.970 | 0.019 |
| hex: http/html-16kx64 | 2097280 | 17592.4 ± 1.0% | 0.086 | 1.022 | 1.017 | 1.018 | 0.581 | 1.023 | 0.982 | 0.584 | 0.667 | 0.668 | 0.010 |
| hex: http/html-1m | 524290 | 18002.4 ± 1.6% | 0.083 | 1.010 | 1.005 | 1.002 | 0.534 | 1.008 | 1.002 | 0.537 | 0.668 | 0.667 | 0.010 |
| hex: http/json-1kx1024 | 2099200 | 9120.8 ± 18.1% | 0.155 | 1.222 | 1.217 | 1.218 | 0.712 | 1.208 | 0.938 | 0.738 | 0.953 | 0.955 | 0.019 |
| hex: http/json-16kx64 | 2097280 | 17839.7 ± 1.6% | 0.084 | 1.016 | 1.008 | 1.007 | 0.573 | 1.011 | 0.974 | 0.575 | 0.659 | 0.659 | 0.010 |
| hex: http/json-1m | 524290 | 18035.3 ± 2.0% | 0.082 | 1.015 | 1.004 | 1.001 | 0.539 | 1.003 | 0.998 | 0.541 | 0.666 | 0.665 | 0.010 |
| hex: http/js-1kx1024 | 2099200 | 9162.6 ± 17.1% | 0.154 | 1.214 | 1.210 | 1.212 | 0.706 | 1.206 | 0.970 | 0.735 | 0.940 | 0.948 | 0.019 |
| hex: http/js-16kx64 | 2097280 | 17695.0 ± 2.1% | 0.085 | 1.015 | 1.009 | 1.009 | 0.576 | 1.011 | 0.970 | 0.580 | 0.664 | 0.663 | 0.010 |
| hex: http/js-1m | 524290 | 17929.7 ± 1.1% | 0.083 | 1.004 | 1.007 | 1.005 | 0.521 | 1.006 | 1.003 | 0.521 | 0.666 | 0.665 | 0.010 |
| hex: http/css-1kx1024 | 2099200 | 8984.8 ± 15.6% | 0.158 | 1.259 | 1.251 | 1.239 | 0.725 | 1.259 | 0.970 | 0.765 | 0.973 | 0.976 | 0.019 |
| hex: http/css-16kx64 | 2097280 | 17805.4 ± 1.5% | 0.084 | 1.016 | 1.008 | 1.007 | 0.573 | 1.008 | 0.970 | 0.575 | 0.660 | 0.660 | 0.010 |
| hex: http/css-1m | 524290 | 18034.5 ± 1.7% | 0.082 | 1.020 | 1.008 | 1.004 | 0.521 | 1.006 | 1.003 | 0.520 | 0.664 | 0.664 | 0.010 |
| hex: shuffled/dickens-1m | 524290 | 17447.7 ± 1.1% | 0.085 | 1.005 | 1.000 | 1.003 | 0.541 | 0.993 | 1.003 | 0.542 | 0.688 | 0.688 | 0.010 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1478.3 ± 0.6% | 0.444 | 0.999 | 0.969 | 1.004 | 1.008 | 0.268 | 0.999 | 0.548 | 0.916 | 0.089 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1264.8 ± 1.9% | 0.693 | 0.981 | 1.015 | 1.015 | 1.015 | 0.265 | 1.005 | 0.504 | 0.832 | 0.106 | 1.022 |
| string: silesia/dickens | 172528 | 6887.7 ± 0.5% | 0.025 | 1.002 | 1.002 | 1.001 | 1.002 | 0.167 | 0.718 | 1.003 | 1.003 | 0.025 | 1.034 |
| string: silesia/nci | 1075110 | 7289.1 ± 0.3% | 0.024 | 1.001 | 1.003 | 1.003 | 1.003 | 0.213 | 0.565 | 1.002 | 1.002 | 0.024 | 1.008 |
| string: silesia/reymont | 1075159 | 3345.8 ± 1.8% | 0.051 | 1.001 | 0.991 | 1.001 | 1.000 | 0.389 | 0.866 | 0.998 | 1.003 | 0.052 | 1.047 |
| string: silesia/samba | 97582 | 4188.6 ± 1.1% | 0.053 | 1.000 | 1.003 | 1.005 | 1.005 | 0.125 | 0.942 | 1.003 | 1.004 | 0.054 | 1.091 |
| string: silesia/webster | 1098490 | 4048.0 ± 0.4% | 0.042 | 1.010 | 1.008 | 1.009 | 1.006 | 0.213 | 0.888 | 1.001 | 1.005 | 0.043 | 1.011 |
| string: silesia/xml | 1090118 | 6110.2 ± 0.6% | 0.029 | 1.002 | 0.999 | 1.005 | 1.001 | 0.254 | 0.777 | 1.002 | 1.004 | 0.029 | 1.021 |
| string: canterbury/alice29.txt | 159425 | 6414.2 ± 0.8% | 0.027 | 1.008 | 1.012 | 1.013 | 1.013 | 0.132 | 0.654 | 1.001 | 1.006 | 0.027 | 1.060 |
| string: canterbury/asyoulik.txt | 132198 | 5581.5 ± 0.6% | 0.030 | 1.028 | 1.032 | 1.033 | 1.035 | 0.130 | 0.597 | 1.003 | 1.009 | 0.030 | 1.064 |
| string: canterbury/lcet10.txt | 441884 | 6248.4 ± 0.5% | 0.028 | 1.004 | 1.006 | 1.006 | 1.006 | 0.185 | 0.800 | 1.001 | 1.004 | 0.028 | 0.999 |
| string: canterbury/plrabn12.txt | 503330 | 5702.4 ± 0.3% | 0.030 | 1.002 | 1.002 | 1.003 | 1.004 | 0.169 | 0.700 | 1.001 | 1.002 | 0.031 | 1.009 |
| string: canterbury-large/E.coli | 1048578 | 19134.8 ± 0.4% | 0.078 | 1.003 | 1.002 | 1.001 | 0.996 | 0.480 | 1.000 | 1.002 | 1.000 | 0.009 | 0.999 |
| string: canterbury-large/bible.txt | 1055886 | 6772.1 ± 0.6% | 0.026 | 1.002 | 1.005 | 1.002 | 1.004 | 0.494 | 0.977 | 1.002 | 1.004 | 0.026 | 1.002 |
| string: canterbury-large/world192.txt | 1103121 | 4019.6 ± 0.6% | 0.043 | 1.015 | 1.017 | 1.017 | 1.017 | 0.194 | 0.831 | 1.000 | 1.008 | 0.043 | 1.002 |
| string: http/html-1m | 1058582 | 6734.8 ± 0.5% | 0.026 | 1.006 | 0.924 | 1.005 | 1.005 | 0.405 | 0.903 | 1.000 | 1.002 | 0.026 | 1.012 |
| string: http/json-1m | 1190272 | 3158.6 ± 0.2% | 0.051 | 1.001 | 0.968 | 1.004 | 1.002 | 0.133 | 0.371 | 1.003 | 1.004 | 0.051 | 1.042 |
| string: http/js-1m | 1144362 | 2749.8 ± 0.3% | 0.060 | 1.004 | 1.013 | 1.005 | 1.008 | 0.166 | 0.843 | 1.001 | 1.007 | 0.061 | 1.015 |
| string: http/css-1m | 1097820 | 3971.4 ± 0.6% | 0.042 | 1.006 | 1.007 | 1.007 | 1.007 | 0.209 | 0.647 | 1.005 | 1.009 | 0.043 | 1.013 |
| string: dickens as Cyrillic and CJK | 1883069 | 3066.6 ± 0.3% | 0.048 | 1.000 | 0.124 | 1.000 | 1.000 | 0.321 | 1.004 | 1.000 | 1.001 | 0.048 | 1.001 |
| hex: silesia/dickens | 524290 | 15664.2 ± 0.2% | 1.001 | 0.177 | 1.000 | 1.001 | 1.000 | 1.000 | 0.999 | 1.000 | 0.998 | 0.177 | 1.001 |
| hex: silesia/mozilla | 524290 | 15673.4 ± 0.2% | 1.001 | 0.178 | 0.998 | 0.999 | 0.998 | 0.998 | 0.998 | 0.997 | 0.995 | 0.178 | 0.998 |
| hex: silesia/mr | 524290 | 15616.9 ± 0.3% | 1.001 | 0.179 | 1.002 | 1.001 | 1.002 | 1.002 | 1.002 | 1.003 | 1.003 | 0.179 | 1.001 |
| hex: silesia/nci | 524290 | 15630.6 ± 0.2% | 1.001 | 0.178 | 1.002 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 0.178 | 1.002 |
| hex: silesia/ooffice | 524290 | 15629.6 ± 0.1% | 0.998 | 0.178 | 0.999 | 0.999 | 0.998 | 0.997 | 0.997 | 0.996 | 0.999 | 0.178 | 1.000 |
| hex: silesia/osdb | 524290 | 15624.8 ± 0.3% | 1.002 | 0.178 | 1.001 | 1.001 | 0.999 | 0.999 | 0.999 | 1.000 | 1.000 | 0.178 | 1.000 |
| hex: silesia/reymont | 524290 | 15692.2 ± 0.1% | 0.998 | 0.177 | 1.000 | 1.000 | 1.000 | 0.999 | 0.998 | 0.994 | 0.998 | 0.177 | 0.999 |
| hex: silesia/samba | 524290 | 15630.7 ± 0.5% | 1.002 | 0.178 | 1.002 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 0.178 | 1.000 |
| hex: silesia/sao | 524290 | 15625.7 ± 0.4% | 1.000 | 0.178 | 0.997 | 0.994 | 0.993 | 0.995 | 0.995 | 0.997 | 0.997 | 0.178 | 0.996 |
| hex: silesia/webster | 524290 | 15639.6 ± 0.3% | 1.000 | 0.178 | 1.001 | 1.000 | 1.001 | 1.000 | 0.999 | 1.000 | 1.001 | 0.177 | 1.002 |
| hex: silesia/x-ray | 524290 | 15619.1 ± 0.3% | 1.002 | 0.179 | 1.002 | 1.001 | 1.000 | 0.994 | 0.994 | 0.996 | 0.998 | 0.178 | 0.997 |
| hex: silesia/xml | 524290 | 15643.1 ± 0.3% | 1.001 | 0.178 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/alice29.txt | 304180 | 15666.4 ± 0.2% | 1.000 | 0.178 | 1.001 | 1.001 | 1.000 | 0.999 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15701.0 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15617.3 ± 0.2% | 1.001 | 0.179 | 1.000 | 1.001 | 1.000 | 0.998 | 1.001 | 1.002 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15429.6 ± 0.1% | 1.002 | 0.181 | 1.001 | 1.000 | 1.000 | 0.995 | 1.001 | 1.003 | 1.006 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14926.1 ± 0.1% | 1.004 | 0.186 | 1.001 | 1.000 | 1.000 | 0.982 | 1.001 | 1.005 | 1.015 | 0.184 | 1.004 |
| hex: canterbury/kennedy.xls | 524290 | 15623.0 ± 0.7% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 1.000 | 1.000 | 0.179 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 15616.0 ± 0.2% | 1.002 | 0.178 | 1.001 | 1.000 | 1.003 | 1.000 | 1.000 | 0.999 | 1.000 | 0.178 | 0.999 |
| hex: canterbury/plrabn12.txt | 524290 | 15651.3 ± 0.2% | 1.001 | 0.177 | 1.001 | 1.000 | 1.000 | 0.998 | 1.000 | 0.998 | 0.999 | 0.177 | 0.999 |
| hex: canterbury/ptt5 | 524290 | 15583.8 ± 0.2% | 1.003 | 0.179 | 0.999 | 1.001 | 0.999 | 0.999 | 1.000 | 1.002 | 1.000 | 0.179 | 1.002 |
| hex: canterbury/sum | 76482 | 15641.8 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 14981.4 ± 0.1% | 1.004 | 0.185 | 1.001 | 1.000 | 1.000 | 0.985 | 1.001 | 1.005 | 1.015 | 0.184 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 15608.9 ± 0.2% | 0.998 | 0.179 | 1.003 | 1.000 | 1.000 | 1.000 | 0.997 | 0.997 | 0.998 | 0.179 | 0.999 |
| hex: canterbury-large/bible.txt | 524290 | 15623.8 ± 0.3% | 1.001 | 0.178 | 1.001 | 1.002 | 1.000 | 0.998 | 0.996 | 1.000 | 0.998 | 0.178 | 1.001 |
| hex: canterbury-large/world192.txt | 524290 | 15539.9 ± 0.2% | 1.000 | 0.179 | 1.001 | 1.002 | 1.000 | 1.002 | 1.000 | 1.000 | 1.001 | 0.179 | 1.001 |
| hex: http/html-1kx1024 | 2099200 | 13562.8 ± 0.8% | 1.009 | 0.197 | 1.008 | 1.002 | 1.002 | 0.939 | 0.998 | 1.012 | 1.042 | 0.188 | 1.011 |
| hex: http/html-16kx64 | 2097280 | 15228.5 ± 0.3% | 0.995 | 0.181 | 0.997 | 1.001 | 0.998 | 0.991 | 0.996 | 1.000 | 1.008 | 0.179 | 1.000 |
| hex: http/html-1m | 524290 | 15650.6 ± 0.1% | 1.001 | 0.177 | 0.999 | 1.000 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 0.177 | 1.001 |
| hex: http/json-1kx1024 | 2099200 | 13679.5 ± 0.6% | 1.004 | 0.195 | 0.999 | 1.000 | 1.000 | 0.936 | 0.997 | 0.999 | 1.035 | 0.187 | 1.013 |
| hex: http/json-16kx64 | 2097280 | 15286.2 ± 0.7% | 1.001 | 0.180 | 0.991 | 1.000 | 0.998 | 0.987 | 0.995 | 1.002 | 1.005 | 0.180 | 1.000 |
| hex: http/json-1m | 524290 | 15666.8 ± 0.3% | 1.001 | 0.177 | 0.999 | 1.000 | 0.998 | 0.998 | 0.999 | 0.997 | 0.997 | 0.178 | 0.998 |
| hex: http/js-1kx1024 | 2099200 | 13622.2 ± 0.6% | 1.007 | 0.196 | 0.993 | 1.002 | 1.000 | 0.942 | 1.004 | 1.010 | 1.036 | 0.188 | 1.012 |
| hex: http/js-16kx64 | 2097280 | 15228.5 ± 0.5% | 1.001 | 0.181 | 0.994 | 1.002 | 1.001 | 0.992 | 0.998 | 1.004 | 1.011 | 0.181 | 1.000 |
| hex: http/js-1m | 524290 | 15621.1 ± 0.3% | 1.000 | 0.177 | 1.003 | 1.002 | 1.001 | 1.001 | 0.999 | 1.002 | 1.001 | 0.177 | 1.002 |
| hex: http/css-1kx1024 | 2099200 | 13596.5 ± 0.3% | 1.006 | 0.196 | 0.999 | 1.004 | 1.004 | 0.939 | 0.999 | 1.007 | 1.037 | 0.188 | 1.015 |
| hex: http/css-16kx64 | 2097280 | 15213.8 ± 0.3% | 1.000 | 0.181 | 0.997 | 0.997 | 0.997 | 0.994 | 0.998 | 1.003 | 1.010 | 0.181 | 1.001 |
| hex: http/css-1m | 524290 | 15661.7 ± 0.4% | 0.999 | 0.177 | 1.000 | 1.000 | 1.000 | 1.000 | 0.999 | 0.999 | 0.998 | 0.177 | 1.000 |
| hex: shuffled/dickens-1m | 524290 | 15682.2 ± 0.6% | 0.999 | 0.177 | 1.001 | 1.001 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 0.177 | 1.001 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.054 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.054 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.241 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.232 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.236 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.241 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.222 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.217 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.218 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.208 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.214 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.210 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.212 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.206 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.259 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.251 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.239 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.259 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43343.3 ± 0.2% | 47417.2 ± 0.1% | 0.914 | — | — |
| string: silesia/nci | 1048576 | 32589.9 ± 7.0% | 34633.3 ± 3.6% | 0.941 | — | — |
| string: silesia/reymont | 1048576 | 32637.1 ± 8.3% | 34937.4 ± 4.5% | 0.934 | — | — |
| string: silesia/samba | 65546 | 43551.8 ± 0.0% | 48509.9 ± 0.0% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 34747.8 ± 2.8% | 37592.5 ± 1.7% | 0.924 | — | — |
| string: silesia/xml | 1048576 | 30435.3 ± 3.4% | 31488.9 ± 3.9% | 0.967 | — | — |
| string: canterbury/alice29.txt | 152089 | 35893.0 ± 0.1% | 36537.7 ± 0.1% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43335.0 ± 0.1% | 47641.3 ± 0.1% | 0.910 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36078.8 ± 0.3% | 36718.2 ± 0.1% | 0.983 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 40169.0 ± 0.9% | 43548.0 ± 1.1% | 0.922 | — | — |
| string: canterbury-large/E.coli | 1048576 | 34529.4 ± 6.4% | 36930.3 ± 3.8% | 0.935 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 29817.7 ± 1.6% | 30954.6 ± 1.0% | 0.963 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 31224.9 ± 4.5% | 32385.3 ± 2.4% | 0.964 | — | — |
| string: http/html-1m | 1048576 | 32728.8 ± 3.2% | 34886.9 ± 4.1% | 0.938 | — | — |
| string: http/json-1m | 1048576 | 30393.2 ± 1.5% | 32166.0 ± 2.8% | 0.945 | — | — |
| string: http/js-1m | 1048576 | 35425.5 ± 6.1% | 37558.2 ± 5.6% | 0.943 | — | — |
| string: http/css-1m | 1048576 | 35093.0 ± 3.4% | 37611.1 ± 3.8% | 0.933 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5765.0 ± 0.2% | 5652.0 ± 0.2% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.914 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.924 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.910 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.922 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.935 of simdutf.
- string: http/html-1m: stdx runs at 0.938 of simdutf.
- string: http/json-1m: stdx runs at 0.945 of simdutf.
- string: http/css-1m: stdx runs at 0.933 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 39573.0 ± 6.7% | 44301.9 ± 2.1% | 0.893 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 33053.9 ± 2.8% | 33967.8 ± 2.1% | 0.973 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 36027.9 ± 6.8% | 39125.5 ± 5.7% | 0.921 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 37251.4 ± 6.2% | 40836.1 ± 3.6% | 0.912 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 36454.2 ± 4.9% | 40280.1 ± 6.1% | 0.905 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 36402.7 ± 5.6% | 40008.3 ± 5.8% | 0.910 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5752.7 ± 0.3% | 5637.6 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5745.3 ± 0.5% | 5634.0 ± 0.4% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5753.6 ± 0.1% | 5635.8 ± 0.3% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5754.1 ± 0.3% | 5632.5 ± 0.3% | 1.022 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5751.7 ± 0.3% | 5630.0 ± 0.4% | 1.022 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5757.8 ± 0.1% | 5640.0 ± 0.2% | 1.021 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.1 ± 0.6% | 927.7 ± 0.7% | 1020.8 ± 0.2% | 299.9 ± 0.6% | 667.2 ± 0.1% | 309.5 ± 1.9% | 1.215 | 1.104 | 3.758 | 1.689 | 3.642 |
| qlog records, JSON text sequence | 1467503 | 817.7 ± 1.1% | 817.1 ± 0.1% | 773.7 ± 1.5% | 243.9 ± 0.5% | 686.6 ± 0.5% | 249.2 ± 3.1% | 1.001 | 1.057 | 3.353 | 1.191 | 3.281 |
| string: silesia/dickens | 172528 | 5042.8 ± 0.2% | 1877.0 ± 0.1% | 2644.2 ± 0.3% | 361.5 ± 0.8% | 2842.3 ± 0.3% | 552.1 ± 1.7% | 2.687 | 1.907 | 13.949 | 1.774 | 9.134 |
| string: silesia/nci | 1075110 | 4276.4 ± 0.5% | 2233.4 ± 0.6% | 2989.6 ± 0.3% | 542.9 ± 1.1% | 2992.6 ± 0.2% | 594.2 ± 1.2% | 1.915 | 1.430 | 7.877 | 1.429 | 7.197 |
| string: silesia/reymont | 1075159 | 2940.2 ± 1.7% | 1804.1 ± 1.3% | 2060.5 ± 0.4% | 375.0 ± 0.7% | 2136.2 ± 0.8% | 531.4 ± 1.7% | 1.630 | 1.427 | 7.840 | 1.376 | 5.533 |
| string: silesia/samba | 97582 | 3487.9 ± 0.6% | 2026.6 ± 0.2% | 2619.7 ± 0.2% | 327.8 ± 0.3% | 1500.0 ± 0.7% | 426.3 ± 1.7% | 1.721 | 1.331 | 10.639 | 2.325 | 8.183 |
| string: silesia/webster | 1098490 | 3627.7 ± 1.3% | 1517.8 ± 0.1% | 2009.4 ± 0.3% | 359.6 ± 0.3% | 2171.2 ± 0.8% | 493.5 ± 2.8% | 2.390 | 1.805 | 10.088 | 1.671 | 7.351 |
| string: silesia/xml | 1090118 | 4774.5 ± 0.4% | 2359.4 ± 0.2% | 2524.4 ± 0.4% | 452.0 ± 0.9% | 2864.7 ± 0.5% | 565.9 ± 0.9% | 2.024 | 1.891 | 10.562 | 1.667 | 8.437 |
| string: canterbury/alice29.txt | 159425 | 4314.4 ± 0.4% | 1601.0 ± 0.3% | 2454.3 ± 0.2% | 343.3 ± 0.2% | 2494.4 ± 0.5% | 505.3 ± 1.5% | 2.695 | 1.758 | 12.568 | 1.730 | 8.539 |
| string: canterbury/asyoulik.txt | 132198 | 3449.3 ± 1.7% | 1459.5 ± 0.3% | 2248.5 ± 0.5% | 334.9 ± 1.1% | 2078.4 ± 0.5% | 457.2 ± 1.4% | 2.363 | 1.534 | 10.298 | 1.660 | 7.545 |
| string: canterbury/lcet10.txt | 441884 | 5097.4 ± 0.6% | 1851.5 ± 0.6% | 2340.7 ± 0.6% | 390.1 ± 0.7% | 2819.3 ± 1.1% | 532.2 ± 1.6% | 2.753 | 2.178 | 13.067 | 1.808 | 9.578 |
| string: canterbury/plrabn12.txt | 503330 | 4074.6 ± 0.6% | 1732.7 ± 0.3% | 2051.6 ± 0.2% | 359.9 ± 0.4% | 2482.8 ± 0.7% | 497.9 ± 0.9% | 2.352 | 1.986 | 11.322 | 1.641 | 8.183 |
| string: canterbury-large/E.coli | 1048578 | 18834.5 ± 2.0% | 3591.3 ± 0.3% | 3240.6 ± 0.5% | 929.5 ± 1.3% | 5916.0 ± 1.0% | 745.8 ± 2.6% | 5.244 | 5.812 | 20.263 | 3.184 | 25.255 |
| string: canterbury-large/bible.txt | 1055886 | 6669.8 ± 0.7% | 2934.8 ± 0.3% | 2827.3 ± 0.8% | 420.5 ± 0.8% | 3759.2 ± 2.0% | 610.8 ± 0.7% | 2.273 | 2.359 | 15.862 | 1.774 | 10.919 |
| string: canterbury-large/world192.txt | 1103121 | 3371.6 ± 0.3% | 1482.7 ± 0.1% | 2011.1 ± 0.2% | 353.5 ± 0.3% | 2114.9 ± 0.4% | 498.0 ± 0.7% | 2.274 | 1.676 | 9.537 | 1.594 | 6.770 |
| string: http/html-1m | 1058582 | 6047.9 ± 0.5% | 2736.5 ± 0.7% | 2695.4 ± 0.9% | 442.7 ± 0.9% | 3467.8 ± 0.5% | 593.2 ± 1.7% | 2.210 | 2.244 | 13.663 | 1.744 | 10.196 |
| string: http/json-1m | 1190272 | 2534.8 ± 0.6% | 877.4 ± 0.3% | 2244.5 ± 0.6% | 390.0 ± 0.5% | 1061.4 ± 0.3% | 437.5 ± 0.6% | 2.889 | 1.129 | 6.500 | 2.388 | 5.794 |
| string: http/js-1m | 1144362 | 2279.2 ± 0.8% | 1028.2 ± 0.1% | 1634.9 ± 0.3% | 320.0 ± 0.7% | 1521.6 ± 0.2% | 416.8 ± 1.5% | 2.217 | 1.394 | 7.123 | 1.498 | 5.468 |
| string: http/css-1m | 1097820 | 2630.8 ± 0.7% | 1676.0 ± 0.4% | 2224.6 ± 0.4% | 407.0 ± 0.8% | 1955.5 ± 0.8% | 485.8 ± 1.5% | 1.570 | 1.183 | 6.463 | 1.345 | 5.416 |
| string: dickens as Cyrillic and CJK | 1883069 | 3060.7 ± 0.8% | 1684.1 ± 0.5% | 891.9 ± 0.5% | 351.5 ± 0.2% | 671.5 ± 0.5% | 157.3 ± 2.8% | 1.817 | 3.432 | 8.709 | 4.558 | 19.461 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.2 ± 1.0% | 980.2 ± 0.2% | 1198.4 ± 1.5% | 215.9 ± 0.2% | 471.3 ± 1.5% | 252.5 ± 5.2% | 1.354 | 1.108 | 6.147 | 2.816 | 5.257 |
| hex: silesia/dickens | 524290 | 18456.3 ± 1.6% | 3616.9 ± 0.2% | 3294.2 ± 0.2% | 506.7 ± 1.7% | 6106.7 ± 2.1% | 780.9 ± 2.6% | 5.103 | 5.603 | 36.428 | 3.022 | 23.634 |
| hex: silesia/mozilla | 524290 | 17841.0 ± 1.2% | 3616.8 ± 0.1% | 3289.1 ± 0.1% | 453.1 ± 2.4% | 6060.8 ± 0.6% | 782.3 ± 0.9% | 4.933 | 5.424 | 39.375 | 2.944 | 22.807 |
| hex: silesia/mr | 524290 | 17929.4 ± 0.7% | 3615.7 ± 0.3% | 3294.4 ± 0.2% | 561.5 ± 2.0% | 6085.5 ± 2.3% | 782.0 ± 1.3% | 4.959 | 5.442 | 31.932 | 2.946 | 22.929 |
| hex: silesia/nci | 524290 | 18301.9 ± 0.8% | 3616.0 ± 0.1% | 3277.0 ± 0.3% | 616.1 ± 3.1% | 6082.1 ± 0.9% | 778.8 ± 0.9% | 5.061 | 5.585 | 29.708 | 3.009 | 23.500 |
| hex: silesia/ooffice | 524290 | 18199.9 ± 0.4% | 3614.5 ± 0.2% | 3285.0 ± 0.5% | 399.6 ± 1.2% | 6118.9 ± 1.6% | 783.4 ± 0.6% | 5.035 | 5.540 | 45.549 | 2.974 | 23.231 |
| hex: silesia/osdb | 524290 | 17900.1 ± 0.9% | 3615.7 ± 0.2% | 3285.3 ± 0.3% | 484.8 ± 2.1% | 6047.7 ± 1.4% | 784.3 ± 0.5% | 4.951 | 5.449 | 36.922 | 2.960 | 22.824 |
| hex: silesia/reymont | 524290 | 18185.8 ± 0.9% | 3617.8 ± 0.2% | 3285.0 ± 0.3% | 526.1 ± 1.2% | 6127.2 ± 1.1% | 781.3 ± 0.8% | 5.027 | 5.536 | 34.569 | 2.968 | 23.276 |
| hex: silesia/samba | 524290 | 17657.8 ± 0.7% | 3618.0 ± 0.3% | 3282.1 ± 0.3% | 412.5 ± 1.3% | 6120.4 ± 2.3% | 779.4 ± 0.6% | 4.881 | 5.380 | 42.806 | 2.885 | 22.656 |
| hex: silesia/sao | 524290 | 18337.1 ± 0.7% | 3620.2 ± 0.4% | 3288.9 ± 0.3% | 346.7 ± 1.1% | 6134.5 ± 1.2% | 783.7 ± 0.9% | 5.065 | 5.576 | 52.884 | 2.989 | 23.399 |
| hex: silesia/webster | 524290 | 18420.8 ± 1.0% | 3614.7 ± 0.2% | 3284.9 ± 0.3% | 477.0 ± 0.4% | 6090.3 ± 1.0% | 781.0 ± 0.5% | 5.096 | 5.608 | 38.617 | 3.025 | 23.587 |
| hex: silesia/x-ray | 524290 | 18170.4 ± 0.2% | 3620.0 ± 0.1% | 3291.2 ± 0.3% | 487.6 ± 0.8% | 6066.0 ± 0.7% | 781.4 ± 0.6% | 5.019 | 5.521 | 37.269 | 2.995 | 23.253 |
| hex: silesia/xml | 524290 | 18052.5 ± 2.8% | 3617.9 ± 0.3% | 3293.7 ± 0.2% | 530.8 ± 0.5% | 6087.7 ± 1.3% | 784.7 ± 0.9% | 4.990 | 5.481 | 34.008 | 2.965 | 23.005 |
| hex: canterbury/alice29.txt | 304180 | 19195.7 ± 0.6% | 3636.0 ± 0.1% | 3355.1 ± 0.2% | 523.7 ± 0.5% | 6092.9 ± 2.0% | 780.3 ± 1.7% | 5.279 | 5.721 | 36.655 | 3.151 | 24.599 |
| hex: canterbury/asyoulik.txt | 250360 | 18772.9 ± 0.4% | 3642.6 ± 0.0% | 3336.8 ± 0.2% | 512.2 ± 1.2% | 6141.4 ± 2.0% | 781.0 ± 0.4% | 5.154 | 5.626 | 36.653 | 3.057 | 24.037 |
| hex: canterbury/cp.html | 49208 | 19268.5 ± 0.7% | 3638.3 ± 0.0% | 3285.6 ± 0.6% | 474.0 ± 1.5% | 6275.6 ± 2.2% | 767.4 ± 0.7% | 5.296 | 5.865 | 40.650 | 3.070 | 25.109 |
| hex: canterbury/fields.c | 22302 | 18733.2 ± 0.8% | 3628.5 ± 0.1% | 3401.7 ± 0.3% | 509.7 ± 0.3% | 6249.5 ± 0.3% | 752.2 ± 2.0% | 5.163 | 5.507 | 36.756 | 2.998 | 24.904 |
| hex: canterbury/grammar.lsp | 7444 | 17281.0 ± 0.7% | 3601.3 ± 0.1% | 3353.2 ± 0.6% | 553.8 ± 1.6% | 6131.8 ± 0.6% | 723.8 ± 1.4% | 4.799 | 5.154 | 31.204 | 2.818 | 23.875 |
| hex: canterbury/kennedy.xls | 524290 | 18203.8 ± 1.8% | 3607.5 ± 0.3% | 3286.3 ± 0.6% | 659.3 ± 2.7% | 6136.9 ± 1.4% | 778.4 ± 5.9% | 5.046 | 5.539 | 27.610 | 2.966 | 23.386 |
| hex: canterbury/lcet10.txt | 524290 | 18504.1 ± 3.0% | 3603.0 ± 0.2% | 3276.5 ± 0.2% | 522.7 ± 2.0% | 6053.1 ± 0.9% | 781.6 ± 0.6% | 5.136 | 5.648 | 35.403 | 3.057 | 23.674 |
| hex: canterbury/plrabn12.txt | 524290 | 17990.4 ± 0.5% | 3606.6 ± 0.5% | 3293.7 ± 0.2% | 513.3 ± 2.9% | 6102.3 ± 0.6% | 782.4 ± 0.6% | 4.988 | 5.462 | 35.049 | 2.948 | 22.995 |
| hex: canterbury/ptt5 | 524290 | 17775.8 ± 0.5% | 3606.5 ± 0.3% | 3286.7 ± 0.2% | 563.1 ± 0.7% | 6097.5 ± 1.3% | 784.1 ± 0.5% | 4.929 | 5.408 | 31.570 | 2.915 | 22.670 |
| hex: canterbury/sum | 76482 | 19258.5 ± 0.4% | 3633.8 ± 0.0% | 3360.2 ± 0.2% | 515.2 ± 1.5% | 6172.6 ± 0.6% | 773.1 ± 1.4% | 5.300 | 5.731 | 37.379 | 3.120 | 24.911 |
| hex: canterbury/xargs.1 | 8456 | 17672.2 ± 0.7% | 3601.8 ± 0.1% | 3350.5 ± 0.2% | 496.2 ± 1.9% | 6122.8 ± 0.4% | 753.6 ± 1.5% | 4.906 | 5.274 | 35.617 | 2.886 | 23.450 |
| hex: canterbury-large/E.coli | 524290 | 17964.8 ± 1.0% | 3601.8 ± 0.5% | 3292.1 ± 0.3% | 688.9 ± 0.3% | 6129.8 ± 0.5% | 765.5 ± 5.0% | 4.988 | 5.457 | 26.078 | 2.931 | 23.469 |
| hex: canterbury-large/bible.txt | 524290 | 18125.1 ± 1.1% | 3599.6 ± 0.2% | 3298.0 ± 0.3% | 526.3 ± 1.4% | 6139.7 ± 1.2% | 775.3 ± 1.9% | 5.035 | 5.496 | 34.439 | 2.952 | 23.379 |
| hex: canterbury-large/world192.txt | 524290 | 17561.4 ± 0.7% | 3599.0 ± 0.1% | 3295.4 ± 0.3% | 503.3 ± 1.9% | 6097.2 ± 1.6% | 771.5 ± 2.1% | 4.880 | 5.329 | 34.892 | 2.880 | 22.761 |
| hex: http/html-1kx1024 | 2099200 | 9026.4 ± 15.5% | 3464.3 ± 0.1% | 2837.6 ± 0.8% | 473.3 ± 0.8% | 5202.9 ± 1.5% | 641.9 ± 6.3% | 2.606 | 3.181 | 19.070 | 1.735 | 14.063 |
| hex: http/html-16kx64 | 2097280 | 17592.4 ± 1.0% | 3609.3 ± 0.2% | 3255.9 ± 0.2% | 479.7 ± 1.6% | 5975.9 ± 0.2% | 755.6 ± 6.8% | 4.874 | 5.403 | 36.671 | 2.944 | 23.282 |
| hex: http/html-1m | 524290 | 18002.4 ± 1.6% | 3610.9 ± 0.7% | 3290.2 ± 0.5% | 498.4 ± 1.7% | 6086.2 ± 1.8% | 750.4 ± 5.0% | 4.986 | 5.472 | 36.120 | 2.958 | 23.992 |
| hex: http/json-1kx1024 | 2099200 | 9120.8 ± 18.1% | 3462.4 ± 0.2% | 2818.8 ± 0.9% | 573.8 ± 0.5% | 5189.6 ± 0.5% | 627.8 ± 2.8% | 2.634 | 3.236 | 15.896 | 1.758 | 14.527 |
| hex: http/json-16kx64 | 2097280 | 17839.7 ± 1.6% | 3606.4 ± 0.3% | 3250.9 ± 0.6% | 572.2 ± 1.8% | 6012.2 ± 0.3% | 748.0 ± 2.8% | 4.947 | 5.488 | 31.179 | 2.967 | 23.849 |
| hex: http/json-1m | 524290 | 18035.3 ± 2.0% | 3605.5 ± 0.4% | 3291.4 ± 1.0% | 589.7 ± 1.6% | 6087.9 ± 1.7% | 735.8 ± 2.5% | 5.002 | 5.480 | 30.582 | 2.962 | 24.511 |
| hex: http/js-1kx1024 | 2099200 | 9162.6 ± 17.1% | 3462.7 ± 0.1% | 2823.3 ± 0.4% | 478.0 ± 1.5% | 5243.1 ± 0.6% | 624.3 ± 5.0% | 2.646 | 3.245 | 19.169 | 1.748 | 14.678 |
| hex: http/js-16kx64 | 2097280 | 17695.0 ± 2.1% | 3608.0 ± 0.2% | 3256.8 ± 0.5% | 475.8 ± 0.5% | 5970.4 ± 0.2% | 726.9 ± 3.9% | 4.904 | 5.433 | 37.188 | 2.964 | 24.343 |
| hex: http/js-1m | 524290 | 17929.7 ± 1.1% | 3599.1 ± 0.2% | 3287.0 ± 0.3% | 502.7 ± 4.4% | 6044.1 ± 1.0% | 750.2 ± 2.7% | 4.982 | 5.455 | 35.665 | 2.966 | 23.900 |
| hex: http/css-1kx1024 | 2099200 | 8984.8 ± 15.6% | 3460.7 ± 0.1% | 2836.3 ± 1.1% | 488.0 ± 0.6% | 5210.5 ± 0.8% | 633.7 ± 4.0% | 2.596 | 3.168 | 18.410 | 1.724 | 14.177 |
| hex: http/css-16kx64 | 2097280 | 17805.4 ± 1.5% | 3604.3 ± 0.2% | 3249.4 ± 0.4% | 493.5 ± 0.4% | 5996.1 ± 1.0% | 730.1 ± 4.1% | 4.940 | 5.480 | 36.083 | 2.970 | 24.388 |
| hex: http/css-1m | 524290 | 18034.5 ± 1.7% | 3602.2 ± 0.5% | 3280.6 ± 0.1% | 499.9 ± 3.0% | 6114.6 ± 0.5% | 764.6 ± 3.2% | 5.007 | 5.497 | 36.075 | 2.949 | 23.586 |
| hex: shuffled/dickens-1m | 524290 | 17447.7 ± 1.1% | 3602.8 ± 0.2% | 3287.1 ± 0.3% | 522.0 ± 0.9% | 6114.3 ± 1.6% | 773.9 ± 0.4% | 4.843 | 5.308 | 33.421 | 2.854 | 22.546 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1478.3 ± 0.6% | 1251.3 ± 0.6% | 1038.2 ± 0.5% | 409.4 ± 0.3% | 448.1 ± 0.3% | 415.9 ± 0.4% | 1.181 | 1.424 | 3.611 | 3.299 | 3.555 |
| qlog records, JSON text sequence | 1467503 | 1264.8 ± 1.9% | 1062.2 ± 0.7% | 786.8 ± 0.6% | 377.9 ± 1.0% | 467.5 ± 0.8% | 279.5 ± 0.3% | 1.191 | 1.607 | 3.347 | 2.705 | 4.526 |
| string: silesia/dickens | 172528 | 6887.7 ± 0.5% | 2816.1 ± 0.6% | 2926.7 ± 0.8% | 429.7 ± 0.8% | 1591.6 ± 0.3% | 1011.8 ± 0.2% | 2.446 | 2.353 | 16.029 | 4.328 | 6.807 |
| string: silesia/nci | 1075110 | 7289.1 ± 0.3% | 3380.8 ± 0.9% | 3101.1 ± 0.5% | 818.8 ± 2.1% | 1859.6 ± 0.3% | 1107.1 ± 0.4% | 2.156 | 2.351 | 8.902 | 3.920 | 6.584 |
| string: silesia/reymont | 1075159 | 3345.8 ± 1.8% | 1983.9 ± 0.4% | 2058.3 ± 0.7% | 449.8 ± 1.2% | 1507.6 ± 0.2% | 947.8 ± 0.4% | 1.686 | 1.626 | 7.439 | 2.219 | 3.530 |
| string: silesia/samba | 97582 | 4188.6 ± 1.1% | 2111.4 ± 0.6% | 3451.2 ± 0.7% | 354.8 ± 0.2% | 1435.1 ± 0.3% | 1054.3 ± 0.1% | 1.984 | 1.214 | 11.807 | 2.919 | 3.973 |
| string: silesia/webster | 1098490 | 4048.0 ± 0.4% | 1876.5 ± 0.7% | 2050.7 ± 0.5% | 439.5 ± 0.6% | 1393.0 ± 0.2% | 645.6 ± 1.0% | 2.157 | 1.974 | 9.211 | 2.906 | 6.270 |
| string: silesia/xml | 1090118 | 6110.2 ± 0.6% | 2848.2 ± 0.8% | 2643.0 ± 0.7% | 611.3 ± 0.4% | 1750.4 ± 0.5% | 919.6 ± 0.4% | 2.145 | 2.312 | 9.995 | 3.491 | 6.645 |
| string: canterbury/alice29.txt | 159425 | 6414.2 ± 0.8% | 2201.1 ± 0.6% | 2737.4 ± 0.7% | 404.8 ± 0.8% | 1480.3 ± 0.3% | 952.6 ± 0.3% | 2.914 | 2.343 | 15.846 | 4.333 | 6.733 |
| string: canterbury/asyoulik.txt | 132198 | 5581.5 ± 0.6% | 1715.2 ± 0.7% | 2370.2 ± 0.6% | 401.1 ± 0.7% | 1344.3 ± 0.9% | 884.1 ± 0.3% | 3.254 | 2.355 | 13.915 | 4.152 | 6.313 |
| string: canterbury/lcet10.txt | 441884 | 6248.4 ± 0.5% | 2559.9 ± 0.3% | 2471.6 ± 1.4% | 467.0 ± 1.0% | 1539.3 ± 0.6% | 982.6 ± 0.4% | 2.441 | 2.528 | 13.380 | 4.059 | 6.359 |
| string: canterbury/plrabn12.txt | 503330 | 5702.4 ± 0.3% | 2051.6 ± 0.5% | 2072.3 ± 0.3% | 424.2 ± 0.3% | 1425.1 ± 0.2% | 932.0 ± 0.6% | 2.780 | 2.752 | 13.443 | 4.001 | 6.118 |
| string: canterbury-large/E.coli | 1048578 | 19134.8 ± 0.4% | 9658.7 ± 0.9% | 3780.3 ± 0.3% | 1473.1 ± 0.6% | 2347.5 ± 1.0% | 1189.8 ± 0.2% | 1.981 | 5.062 | 12.990 | 8.151 | 16.082 |
| string: canterbury-large/bible.txt | 1055886 | 6772.1 ± 0.6% | 4134.4 ± 0.7% | 3011.5 ± 1.7% | 503.2 ± 0.6% | 1971.1 ± 0.3% | 1119.0 ± 0.2% | 1.638 | 2.249 | 13.459 | 3.436 | 6.052 |
| string: canterbury-large/world192.txt | 1103121 | 4019.6 ± 0.6% | 1656.5 ± 0.3% | 2000.0 ± 1.1% | 448.2 ± 0.4% | 1358.4 ± 0.4% | 908.2 ± 0.2% | 2.427 | 2.010 | 8.969 | 2.959 | 4.426 |
| string: http/html-1m | 1058582 | 6734.8 ± 0.5% | 3984.6 ± 0.4% | 3033.9 ± 0.5% | 499.6 ± 1.2% | 1911.8 ± 0.3% | 803.7 ± 0.5% | 1.690 | 2.220 | 13.481 | 3.523 | 8.379 |
| string: http/json-1m | 1190272 | 3158.6 ± 0.2% | 1344.0 ± 0.5% | 1554.8 ± 0.2% | 442.7 ± 0.4% | 960.8 ± 0.2% | 765.4 ± 1.1% | 2.350 | 2.032 | 7.136 | 3.287 | 4.127 |
| string: http/js-1m | 1144362 | 2749.8 ± 0.3% | 1176.4 ± 0.5% | 1626.2 ± 0.5% | 368.6 ± 0.3% | 1095.7 ± 0.1% | 757.9 ± 0.2% | 2.337 | 1.691 | 7.460 | 2.510 | 3.628 |
| string: http/css-1m | 1097820 | 3971.4 ± 0.6% | 1480.2 ± 0.4% | 2146.6 ± 0.8% | 493.8 ± 0.4% | 1368.5 ± 0.2% | 893.9 ± 0.2% | 2.683 | 1.850 | 8.042 | 2.902 | 4.443 |
| string: dickens as Cyrillic and CJK | 1883069 | 3066.6 ± 0.3% | 2339.4 ± 0.5% | 521.4 ± 0.3% | 308.4 ± 0.5% | 563.8 ± 0.5% | 335.9 ± 0.3% | 1.311 | 5.881 | 9.944 | 5.439 | 9.129 |
| hex: silesia/dickens | 524290 | 15664.2 ± 0.2% | 1457.2 ± 0.3% | 1081.9 ± 0.3% | 502.5 ± 2.0% | 987.9 ± 0.5% | 733.7 ± 0.3% | 10.749 | 14.478 | 31.173 | 15.856 | 21.349 |
| hex: silesia/mozilla | 524290 | 15673.4 ± 0.2% | 1467.5 ± 0.4% | 1084.9 ± 0.4% | 441.2 ± 0.5% | 992.9 ± 0.4% | 733.6 ± 0.7% | 10.680 | 14.447 | 35.522 | 15.785 | 21.366 |
| hex: silesia/mr | 524290 | 15616.9 ± 0.3% | 1474.8 ± 0.2% | 1090.9 ± 0.5% | 551.8 ± 2.7% | 997.5 ± 0.9% | 733.2 ± 0.5% | 10.589 | 14.316 | 28.302 | 15.655 | 21.298 |
| hex: silesia/nci | 524290 | 15630.6 ± 0.2% | 1468.8 ± 0.5% | 1087.6 ± 0.7% | 636.5 ± 3.3% | 992.1 ± 0.6% | 734.4 ± 0.4% | 10.642 | 14.371 | 24.557 | 15.755 | 21.284 |
| hex: silesia/ooffice | 524290 | 15629.6 ± 0.1% | 1459.9 ± 0.4% | 1082.0 ± 0.4% | 388.9 ± 0.3% | 987.5 ± 0.5% | 733.4 ± 0.4% | 10.706 | 14.445 | 40.187 | 15.828 | 21.310 |
| hex: silesia/osdb | 524290 | 15624.8 ± 0.3% | 1464.1 ± 0.2% | 1087.4 ± 0.2% | 467.8 ± 2.1% | 988.3 ± 0.5% | 732.8 ± 0.4% | 10.672 | 14.368 | 33.402 | 15.810 | 21.321 |
| hex: silesia/reymont | 524290 | 15692.2 ± 0.1% | 1459.8 ± 0.4% | 1081.3 ± 0.5% | 515.2 ± 1.0% | 992.2 ± 0.9% | 733.2 ± 0.8% | 10.749 | 14.512 | 30.458 | 15.815 | 21.403 |
| hex: silesia/samba | 524290 | 15630.7 ± 0.5% | 1463.3 ± 0.2% | 1085.8 ± 0.5% | 402.6 ± 0.5% | 989.7 ± 0.2% | 734.3 ± 0.5% | 10.682 | 14.396 | 38.822 | 15.793 | 21.285 |
| hex: silesia/sao | 524290 | 15625.7 ± 0.4% | 1459.8 ± 0.3% | 1083.3 ± 0.4% | 332.4 ± 0.6% | 987.8 ± 0.5% | 732.0 ± 0.1% | 10.704 | 14.424 | 47.005 | 15.819 | 21.346 |
| hex: silesia/webster | 524290 | 15639.6 ± 0.3% | 1462.5 ± 0.4% | 1084.8 ± 0.6% | 474.5 ± 0.4% | 989.3 ± 0.8% | 733.3 ± 0.7% | 10.694 | 14.417 | 32.959 | 15.809 | 21.328 |
| hex: silesia/x-ray | 524290 | 15619.1 ± 0.3% | 1470.0 ± 0.2% | 1089.4 ± 0.5% | 443.4 ± 1.5% | 994.8 ± 0.5% | 732.9 ± 0.7% | 10.625 | 14.337 | 35.223 | 15.701 | 21.311 |
| hex: silesia/xml | 524290 | 15643.1 ± 0.3% | 1465.4 ± 0.3% | 1085.3 ± 0.4% | 611.6 ± 0.9% | 989.2 ± 0.5% | 733.3 ± 0.4% | 10.675 | 14.413 | 25.576 | 15.814 | 21.334 |
| hex: canterbury/alice29.txt | 304180 | 15666.4 ± 0.2% | 1464.4 ± 0.5% | 1089.0 ± 0.5% | 502.4 ± 1.0% | 992.1 ± 0.6% | 733.0 ± 0.4% | 10.698 | 14.386 | 31.181 | 15.791 | 21.372 |
| hex: canterbury/asyoulik.txt | 250360 | 15701.0 ± 0.1% | 1472.1 ± 0.2% | 1095.4 ± 0.5% | 499.5 ± 1.6% | 996.0 ± 0.5% | 740.6 ± 0.2% | 10.665 | 14.333 | 31.433 | 15.764 | 21.202 |
| hex: canterbury/cp.html | 49208 | 15617.3 ± 0.2% | 1474.6 ± 0.8% | 1096.7 ± 0.1% | 524.2 ± 2.1% | 1006.7 ± 0.5% | 742.9 ± 0.1% | 10.591 | 14.240 | 29.793 | 15.513 | 21.023 |
| hex: canterbury/fields.c | 22302 | 15429.6 ± 0.1% | 1413.7 ± 0.8% | 1065.0 ± 0.5% | 616.4 ± 9.8% | 979.7 ± 0.6% | 736.5 ± 0.2% | 10.914 | 14.488 | 25.032 | 15.749 | 20.951 |
| hex: canterbury/grammar.lsp | 7444 | 14926.1 ± 0.1% | 1485.9 ± 0.5% | 1095.5 ± 0.4% | 651.6 ± 5.1% | 997.1 ± 0.3% | 726.1 ± 0.1% | 10.045 | 13.625 | 22.908 | 14.970 | 20.558 |
| hex: canterbury/kennedy.xls | 524290 | 15623.0 ± 0.7% | 1467.9 ± 1.0% | 1085.5 ± 0.5% | 651.7 ± 1.6% | 990.4 ± 0.3% | 733.3 ± 0.9% | 10.643 | 14.392 | 23.971 | 15.775 | 21.306 |
| hex: canterbury/lcet10.txt | 524290 | 15616.0 ± 0.2% | 1457.2 ± 0.3% | 1082.0 ± 0.5% | 500.5 ± 0.6% | 986.9 ± 0.2% | 732.8 ± 0.9% | 10.717 | 14.433 | 31.202 | 15.823 | 21.310 |
| hex: canterbury/plrabn12.txt | 524290 | 15651.3 ± 0.2% | 1459.3 ± 0.3% | 1082.5 ± 0.3% | 492.2 ± 0.8% | 989.6 ± 0.5% | 732.6 ± 0.2% | 10.725 | 14.459 | 31.798 | 15.816 | 21.363 |
| hex: canterbury/ptt5 | 524290 | 15583.8 ± 0.2% | 1476.7 ± 0.1% | 1092.9 ± 0.4% | 555.1 ± 0.7% | 992.5 ± 0.6% | 733.0 ± 1.0% | 10.553 | 14.259 | 28.074 | 15.701 | 21.259 |
| hex: canterbury/sum | 76482 | 15641.8 ± 0.1% | 1494.8 ± 0.1% | 1104.3 ± 0.2% | 594.7 ± 2.4% | 998.4 ± 0.0% | 744.6 ± 0.1% | 10.464 | 14.164 | 26.302 | 15.666 | 21.006 |
| hex: canterbury/xargs.1 | 8456 | 14981.4 ± 0.1% | 1432.2 ± 0.3% | 1095.3 ± 0.4% | 655.9 ± 3.0% | 1004.9 ± 0.5% | 727.8 ± 0.2% | 10.460 | 13.677 | 22.842 | 14.909 | 20.586 |
| hex: canterbury-large/E.coli | 524290 | 15608.9 ± 0.2% | 1465.9 ± 1.3% | 1086.8 ± 0.5% | 671.2 ± 0.1% | 991.1 ± 0.5% | 731.8 ± 0.4% | 10.648 | 14.362 | 23.256 | 15.749 | 21.328 |
| hex: canterbury-large/bible.txt | 524290 | 15623.8 ± 0.3% | 1459.5 ± 0.3% | 1082.4 ± 0.3% | 517.8 ± 1.0% | 988.0 ± 0.3% | 732.4 ± 0.8% | 10.705 | 14.434 | 30.174 | 15.814 | 21.333 |
| hex: canterbury-large/world192.txt | 524290 | 15539.9 ± 0.2% | 1458.9 ± 0.2% | 1084.0 ± 0.2% | 501.2 ± 0.7% | 988.0 ± 0.9% | 731.9 ± 0.3% | 10.652 | 14.335 | 31.004 | 15.729 | 21.232 |
| hex: http/html-1kx1024 | 2099200 | 13562.8 ± 0.8% | 1454.8 ± 0.2% | 1061.5 ± 0.2% | 500.8 ± 0.2% | 983.1 ± 0.2% | 692.3 ± 0.1% | 9.323 | 12.777 | 27.084 | 13.797 | 19.590 |
| hex: http/html-16kx64 | 2097280 | 15228.5 ± 0.3% | 1442.4 ± 0.1% | 1074.1 ± 0.4% | 507.2 ± 0.2% | 997.2 ± 0.1% | 734.8 ± 0.2% | 10.558 | 14.179 | 30.026 | 15.271 | 20.725 |
| hex: http/html-1m | 524290 | 15650.6 ± 0.1% | 1461.1 ± 0.3% | 1081.9 ± 0.5% | 502.7 ± 0.2% | 991.1 ± 0.2% | 733.5 ± 0.5% | 10.712 | 14.466 | 31.136 | 15.791 | 21.337 |
| hex: http/json-1kx1024 | 2099200 | 13679.5 ± 0.6% | 1463.6 ± 0.3% | 1068.6 ± 0.3% | 608.8 ± 0.4% | 986.9 ± 0.3% | 692.5 ± 0.1% | 9.346 | 12.801 | 22.471 | 13.861 | 19.752 |
| hex: http/json-16kx64 | 2097280 | 15286.2 ± 0.7% | 1442.0 ± 0.1% | 1073.8 ± 0.5% | 614.6 ± 0.7% | 996.9 ± 0.2% | 734.7 ± 0.1% | 10.601 | 14.235 | 24.872 | 15.334 | 20.806 |
| hex: http/json-1m | 524290 | 15666.8 ± 0.3% | 1468.6 ± 0.2% | 1090.8 ± 0.2% | 634.6 ± 0.4% | 990.6 ± 0.5% | 735.1 ± 0.5% | 10.668 | 14.362 | 24.689 | 15.816 | 21.314 |
| hex: http/js-1kx1024 | 2099200 | 13622.2 ± 0.6% | 1454.5 ± 0.2% | 1066.5 ± 0.7% | 498.9 ± 0.1% | 984.6 ± 0.3% | 692.1 ± 0.3% | 9.365 | 12.773 | 27.306 | 13.836 | 19.682 |
| hex: http/js-16kx64 | 2097280 | 15228.5 ± 0.5% | 1440.9 ± 0.1% | 1072.4 ± 0.3% | 505.0 ± 0.3% | 996.5 ± 0.3% | 733.9 ± 0.2% | 10.569 | 14.201 | 30.156 | 15.283 | 20.750 |
| hex: http/js-1m | 524290 | 15621.1 ± 0.3% | 1460.6 ± 0.2% | 1084.7 ± 0.4% | 509.7 ± 0.6% | 986.0 ± 0.4% | 734.8 ± 0.7% | 10.695 | 14.401 | 30.645 | 15.843 | 21.258 |
| hex: http/css-1kx1024 | 2099200 | 13596.5 ± 0.3% | 1455.3 ± 0.2% | 1063.7 ± 0.4% | 531.5 ± 0.3% | 983.1 ± 0.2% | 692.4 ± 0.1% | 9.342 | 12.783 | 25.582 | 13.830 | 19.635 |
| hex: http/css-16kx64 | 2097280 | 15213.8 ± 0.3% | 1443.3 ± 0.4% | 1073.3 ± 0.3% | 540.3 ± 0.3% | 998.5 ± 0.2% | 735.0 ± 0.3% | 10.541 | 14.175 | 28.156 | 15.237 | 20.699 |
| hex: http/css-1m | 524290 | 15661.7 ± 0.4% | 1464.0 ± 0.3% | 1084.4 ± 0.8% | 527.5 ± 0.6% | 989.7 ± 0.7% | 733.0 ± 0.3% | 10.698 | 14.443 | 29.691 | 15.825 | 21.365 |
| hex: shuffled/dickens-1m | 524290 | 15682.2 ± 0.6% | 1462.5 ± 0.3% | 1084.6 ± 0.4% | 499.5 ± 0.4% | 994.2 ± 0.3% | 733.3 ± 0.7% | 10.723 | 14.460 | 31.397 | 15.774 | 21.387 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1518.7 ± 0.7% | 1251.3 ± 0.6% | 1038.2 ± 0.5% | 409.4 ± 0.3% | 448.1 ± 0.3% | 415.9 ± 0.4% | 1.214 | 1.463 | 3.710 | 3.389 | 3.652 |
| qlog records, JSON text sequence | 1467503 | 1292.2 ± 0.2% | 1062.2 ± 0.7% | 786.8 ± 0.6% | 377.9 ± 1.0% | 467.5 ± 0.8% | 279.5 ± 0.3% | 1.217 | 1.642 | 3.420 | 2.764 | 4.624 |
| string: silesia/dickens | 172528 | 7122.1 ± 0.4% | 2816.1 ± 0.6% | 2926.7 ± 0.8% | 429.7 ± 0.8% | 1591.6 ± 0.3% | 1011.8 ± 0.2% | 2.529 | 2.433 | 16.575 | 4.475 | 7.039 |
| string: silesia/nci | 1075110 | 7349.4 ± 4.8% | 3380.8 ± 0.9% | 3101.1 ± 0.5% | 818.8 ± 2.1% | 1859.6 ± 0.3% | 1107.1 ± 0.4% | 2.174 | 2.370 | 8.976 | 3.952 | 6.639 |
| string: silesia/reymont | 1075159 | 3502.9 ± 0.7% | 1983.9 ± 0.4% | 2058.3 ± 0.7% | 449.8 ± 1.2% | 1507.6 ± 0.2% | 947.8 ± 0.4% | 1.766 | 1.702 | 7.788 | 2.323 | 3.696 |
| string: silesia/samba | 97582 | 4571.2 ± 1.5% | 2111.4 ± 0.6% | 3451.2 ± 0.7% | 354.8 ± 0.2% | 1435.1 ± 0.3% | 1054.3 ± 0.1% | 2.165 | 1.325 | 12.885 | 3.185 | 4.336 |
| string: silesia/webster | 1098490 | 4091.2 ± 0.5% | 1876.5 ± 0.7% | 2050.7 ± 0.5% | 439.5 ± 0.6% | 1393.0 ± 0.2% | 645.6 ± 1.0% | 2.180 | 1.995 | 9.309 | 2.937 | 6.337 |
| string: silesia/xml | 1090118 | 6238.7 ± 1.1% | 2848.2 ± 0.8% | 2643.0 ± 0.7% | 611.3 ± 0.4% | 1750.4 ± 0.5% | 919.6 ± 0.4% | 2.190 | 2.360 | 10.206 | 3.564 | 6.784 |
| string: canterbury/alice29.txt | 159425 | 6799.9 ± 0.7% | 2201.1 ± 0.6% | 2737.4 ± 0.7% | 404.8 ± 0.8% | 1480.3 ± 0.3% | 952.6 ± 0.3% | 3.089 | 2.484 | 16.799 | 4.594 | 7.138 |
| string: canterbury/asyoulik.txt | 132198 | 5939.0 ± 2.6% | 1715.2 ± 0.7% | 2370.2 ± 0.6% | 401.1 ± 0.7% | 1344.3 ± 0.9% | 884.1 ± 0.3% | 3.463 | 2.506 | 14.807 | 4.418 | 6.717 |
| string: canterbury/lcet10.txt | 441884 | 6244.4 ± 0.5% | 2559.9 ± 0.3% | 2471.6 ± 1.4% | 467.0 ± 1.0% | 1539.3 ± 0.6% | 982.6 ± 0.4% | 2.439 | 2.527 | 13.371 | 4.057 | 6.355 |
| string: canterbury/plrabn12.txt | 503330 | 5753.3 ± 0.4% | 2051.6 ± 0.5% | 2072.3 ± 0.3% | 424.2 ± 0.3% | 1425.1 ± 0.2% | 932.0 ± 0.6% | 2.804 | 2.776 | 13.563 | 4.037 | 6.173 |
| string: canterbury-large/E.coli | 1048578 | 19121.2 ± 0.7% | 9658.7 ± 0.9% | 3780.3 ± 0.3% | 1473.1 ± 0.6% | 2347.5 ± 1.0% | 1189.8 ± 0.2% | 1.980 | 5.058 | 12.981 | 8.145 | 16.071 |
| string: canterbury-large/bible.txt | 1055886 | 6783.8 ± 0.2% | 4134.4 ± 0.7% | 3011.5 ± 1.7% | 503.2 ± 0.6% | 1971.1 ± 0.3% | 1119.0 ± 0.2% | 1.641 | 2.253 | 13.482 | 3.442 | 6.062 |
| string: canterbury-large/world192.txt | 1103121 | 4026.7 ± 1.2% | 1656.5 ± 0.3% | 2000.0 ± 1.1% | 448.2 ± 0.4% | 1358.4 ± 0.4% | 908.2 ± 0.2% | 2.431 | 2.013 | 8.984 | 2.964 | 4.434 |
| string: http/html-1m | 1058582 | 6817.0 ± 0.3% | 3984.6 ± 0.4% | 3033.9 ± 0.5% | 499.6 ± 1.2% | 1911.8 ± 0.3% | 803.7 ± 0.5% | 1.711 | 2.247 | 13.645 | 3.566 | 8.482 |
| string: http/json-1m | 1190272 | 3291.7 ± 0.5% | 1344.0 ± 0.5% | 1554.8 ± 0.2% | 442.7 ± 0.4% | 960.8 ± 0.2% | 765.4 ± 1.1% | 2.449 | 2.117 | 7.436 | 3.426 | 4.301 |
| string: http/js-1m | 1144362 | 2792.2 ± 0.8% | 1176.4 ± 0.5% | 1626.2 ± 0.5% | 368.6 ± 0.3% | 1095.7 ± 0.1% | 757.9 ± 0.2% | 2.373 | 1.717 | 7.575 | 2.548 | 3.684 |
| string: http/css-1m | 1097820 | 4021.7 ± 0.4% | 1480.2 ± 0.4% | 2146.6 ± 0.8% | 493.8 ± 0.4% | 1368.5 ± 0.2% | 893.9 ± 0.2% | 2.717 | 1.873 | 8.144 | 2.939 | 4.499 |
| string: dickens as Cyrillic and CJK | 1883069 | 3069.0 ± 0.3% | 2339.4 ± 0.5% | 521.4 ± 0.3% | 308.4 ± 0.5% | 563.8 ± 0.5% | 335.9 ± 0.3% | 1.312 | 5.886 | 9.952 | 5.443 | 9.136 |
| hex: silesia/dickens | 524290 | 15674.4 ± 0.2% | 1457.2 ± 0.3% | 1081.9 ± 0.3% | 502.5 ± 2.0% | 987.9 ± 0.5% | 733.7 ± 0.3% | 10.756 | 14.487 | 31.193 | 15.866 | 21.363 |
| hex: silesia/mozilla | 524290 | 15641.7 ± 0.6% | 1467.5 ± 0.4% | 1084.9 ± 0.4% | 441.2 ± 0.5% | 992.9 ± 0.4% | 733.6 ± 0.7% | 10.658 | 14.417 | 35.451 | 15.753 | 21.322 |
| hex: silesia/mr | 524290 | 15632.0 ± 0.2% | 1474.8 ± 0.2% | 1090.9 ± 0.5% | 551.8 ± 2.7% | 997.5 ± 0.9% | 733.2 ± 0.5% | 10.600 | 14.330 | 28.329 | 15.671 | 21.319 |
| hex: silesia/nci | 524290 | 15662.6 ± 0.2% | 1468.8 ± 0.5% | 1087.6 ± 0.7% | 636.5 ± 3.3% | 992.1 ± 0.6% | 734.4 ± 0.4% | 10.663 | 14.401 | 24.608 | 15.787 | 21.328 |
| hex: silesia/ooffice | 524290 | 15632.7 ± 0.3% | 1459.9 ± 0.4% | 1082.0 ± 0.4% | 388.9 ± 0.3% | 987.5 ± 0.5% | 733.4 ± 0.4% | 10.708 | 14.448 | 40.195 | 15.831 | 21.314 |
| hex: silesia/osdb | 524290 | 15621.1 ± 0.3% | 1464.1 ± 0.2% | 1087.4 ± 0.2% | 467.8 ± 2.1% | 988.3 ± 0.5% | 732.8 ± 0.4% | 10.669 | 14.365 | 33.394 | 15.806 | 21.316 |
| hex: silesia/reymont | 524290 | 15672.0 ± 0.4% | 1459.8 ± 0.4% | 1081.3 ± 0.5% | 515.2 ± 1.0% | 992.2 ± 0.9% | 733.2 ± 0.8% | 10.736 | 14.493 | 30.419 | 15.795 | 21.375 |
| hex: silesia/samba | 524290 | 15627.2 ± 0.6% | 1463.3 ± 0.2% | 1085.8 ± 0.5% | 402.6 ± 0.5% | 989.7 ± 0.2% | 734.3 ± 0.5% | 10.679 | 14.393 | 38.813 | 15.790 | 21.280 |
| hex: silesia/sao | 524290 | 15559.9 ± 0.3% | 1459.8 ± 0.3% | 1083.3 ± 0.4% | 332.4 ± 0.6% | 987.8 ± 0.5% | 732.0 ± 0.1% | 10.659 | 14.363 | 46.807 | 15.752 | 21.256 |
| hex: silesia/webster | 524290 | 15670.5 ± 0.3% | 1462.5 ± 0.4% | 1084.8 ± 0.6% | 474.5 ± 0.4% | 989.3 ± 0.8% | 733.3 ± 0.7% | 10.715 | 14.445 | 33.024 | 15.840 | 21.370 |
| hex: silesia/x-ray | 524290 | 15566.4 ± 0.4% | 1470.0 ± 0.2% | 1089.4 ± 0.5% | 443.4 ± 1.5% | 994.8 ± 0.5% | 732.9 ± 0.7% | 10.589 | 14.289 | 35.105 | 15.648 | 21.239 |
| hex: silesia/xml | 524290 | 15662.4 ± 0.2% | 1465.4 ± 0.3% | 1085.3 ± 0.4% | 611.6 ± 0.9% | 989.2 ± 0.5% | 733.3 ± 0.4% | 10.688 | 14.431 | 25.607 | 15.833 | 21.360 |
| hex: canterbury/alice29.txt | 304180 | 15686.7 ± 0.1% | 1464.4 ± 0.5% | 1089.0 ± 0.5% | 502.4 ± 1.0% | 992.1 ± 0.6% | 733.0 ± 0.4% | 10.712 | 14.405 | 31.222 | 15.811 | 21.400 |
| hex: canterbury/asyoulik.txt | 250360 | 15717.9 ± 0.1% | 1472.1 ± 0.2% | 1095.4 ± 0.5% | 499.5 ± 1.6% | 996.0 ± 0.5% | 740.6 ± 0.2% | 10.677 | 14.348 | 31.467 | 15.781 | 21.225 |
| hex: canterbury/cp.html | 49208 | 15635.7 ± 0.0% | 1474.6 ± 0.8% | 1096.7 ± 0.1% | 524.2 ± 2.1% | 1006.7 ± 0.5% | 742.9 ± 0.1% | 10.604 | 14.257 | 29.828 | 15.531 | 21.048 |
| hex: canterbury/fields.c | 22302 | 15451.7 ± 0.0% | 1413.7 ± 0.8% | 1065.0 ± 0.5% | 616.4 ± 9.8% | 979.7 ± 0.6% | 736.5 ± 0.2% | 10.930 | 14.509 | 25.068 | 15.771 | 20.981 |
| hex: canterbury/grammar.lsp | 7444 | 14986.7 ± 0.0% | 1485.9 ± 0.5% | 1095.5 ± 0.4% | 651.6 ± 5.1% | 997.1 ± 0.3% | 726.1 ± 0.1% | 10.086 | 13.680 | 23.001 | 15.031 | 20.641 |
| hex: canterbury/kennedy.xls | 524290 | 15627.8 ± 0.3% | 1467.9 ± 1.0% | 1085.5 ± 0.5% | 651.7 ± 1.6% | 990.4 ± 0.3% | 733.3 ± 0.9% | 10.646 | 14.396 | 23.979 | 15.780 | 21.312 |
| hex: canterbury/lcet10.txt | 524290 | 15602.9 ± 0.4% | 1457.2 ± 0.3% | 1082.0 ± 0.5% | 500.5 ± 0.6% | 986.9 ± 0.2% | 732.8 ± 0.9% | 10.708 | 14.421 | 31.175 | 15.809 | 21.292 |
| hex: canterbury/plrabn12.txt | 524290 | 15640.5 ± 0.5% | 1459.3 ± 0.3% | 1082.5 ± 0.3% | 492.2 ± 0.8% | 989.6 ± 0.5% | 732.6 ± 0.2% | 10.718 | 14.449 | 31.776 | 15.806 | 21.348 |
| hex: canterbury/ptt5 | 524290 | 15608.3 ± 0.3% | 1476.7 ± 0.1% | 1092.9 ± 0.4% | 555.1 ± 0.7% | 992.5 ± 0.6% | 733.0 ± 1.0% | 10.570 | 14.282 | 28.118 | 15.726 | 21.293 |
| hex: canterbury/sum | 76482 | 15654.6 ± 0.0% | 1494.8 ± 0.1% | 1104.3 ± 0.2% | 594.7 ± 2.4% | 998.4 ± 0.0% | 744.6 ± 0.1% | 10.473 | 14.176 | 26.324 | 15.679 | 21.023 |
| hex: canterbury/xargs.1 | 8456 | 15032.0 ± 0.0% | 1432.2 ± 0.3% | 1095.3 ± 0.4% | 655.9 ± 3.0% | 1004.9 ± 0.5% | 727.8 ± 0.2% | 10.496 | 13.724 | 22.920 | 14.959 | 20.655 |
| hex: canterbury-large/E.coli | 524290 | 15592.0 ± 1.2% | 1465.9 ± 1.3% | 1086.8 ± 0.5% | 671.2 ± 0.1% | 991.1 ± 0.5% | 731.8 ± 0.4% | 10.637 | 14.346 | 23.230 | 15.732 | 21.305 |
| hex: canterbury-large/bible.txt | 524290 | 15634.5 ± 0.5% | 1459.5 ± 0.3% | 1082.4 ± 0.3% | 517.8 ± 1.0% | 988.0 ± 0.3% | 732.4 ± 0.8% | 10.713 | 14.444 | 30.195 | 15.824 | 21.348 |
| hex: canterbury-large/world192.txt | 524290 | 15552.2 ± 0.3% | 1458.9 ± 0.2% | 1084.0 ± 0.2% | 501.2 ± 0.7% | 988.0 ± 0.9% | 731.9 ± 0.3% | 10.660 | 14.347 | 31.028 | 15.742 | 21.249 |
| hex: http/html-1kx1024 | 2099200 | 13718.4 ± 0.5% | 1454.8 ± 0.2% | 1061.5 ± 0.2% | 500.8 ± 0.2% | 983.1 ± 0.2% | 692.3 ± 0.1% | 9.430 | 12.924 | 27.395 | 13.955 | 19.815 |
| hex: http/html-16kx64 | 2097280 | 15230.6 ± 0.3% | 1442.4 ± 0.1% | 1074.1 ± 0.4% | 507.2 ± 0.2% | 997.2 ± 0.1% | 734.8 ± 0.2% | 10.559 | 14.180 | 30.030 | 15.273 | 20.728 |
| hex: http/html-1m | 524290 | 15662.0 ± 0.2% | 1461.1 ± 0.3% | 1081.9 ± 0.5% | 502.7 ± 0.2% | 991.1 ± 0.2% | 733.5 ± 0.5% | 10.720 | 14.476 | 31.159 | 15.803 | 21.352 |
| hex: http/json-1kx1024 | 2099200 | 13856.8 ± 0.8% | 1463.6 ± 0.3% | 1068.6 ± 0.3% | 608.8 ± 0.4% | 986.9 ± 0.3% | 692.5 ± 0.1% | 9.468 | 12.967 | 22.762 | 14.041 | 20.008 |
| hex: http/json-16kx64 | 2097280 | 15283.7 ± 0.5% | 1442.0 ± 0.1% | 1073.8 ± 0.5% | 614.6 ± 0.7% | 996.9 ± 0.2% | 734.7 ± 0.1% | 10.599 | 14.233 | 24.867 | 15.331 | 20.802 |
| hex: http/json-1m | 524290 | 15642.4 ± 0.4% | 1468.6 ± 0.2% | 1090.8 ± 0.2% | 634.6 ± 0.4% | 990.6 ± 0.5% | 735.1 ± 0.5% | 10.651 | 14.340 | 24.651 | 15.791 | 21.281 |
| hex: http/js-1kx1024 | 2099200 | 13783.8 ± 0.6% | 1454.5 ± 0.2% | 1066.5 ± 0.7% | 498.9 ± 0.1% | 984.6 ± 0.3% | 692.1 ± 0.3% | 9.476 | 12.924 | 27.630 | 14.000 | 19.916 |
| hex: http/js-16kx64 | 2097280 | 15235.2 ± 0.4% | 1440.9 ± 0.1% | 1072.4 ± 0.3% | 505.0 ± 0.3% | 996.5 ± 0.3% | 733.9 ± 0.2% | 10.574 | 14.207 | 30.169 | 15.289 | 20.759 |
| hex: http/js-1m | 524290 | 15657.2 ± 0.6% | 1460.6 ± 0.2% | 1084.7 ± 0.4% | 509.7 ± 0.6% | 986.0 ± 0.4% | 734.8 ± 0.7% | 10.720 | 14.434 | 30.716 | 15.880 | 21.307 |
| hex: http/css-1kx1024 | 2099200 | 13793.9 ± 0.5% | 1455.3 ± 0.2% | 1063.7 ± 0.4% | 531.5 ± 0.3% | 983.1 ± 0.2% | 692.4 ± 0.1% | 9.478 | 12.968 | 25.953 | 14.031 | 19.920 |
| hex: http/css-16kx64 | 2097280 | 15223.9 ± 0.7% | 1443.3 ± 0.4% | 1073.3 ± 0.3% | 540.3 ± 0.3% | 998.5 ± 0.2% | 735.0 ± 0.3% | 10.548 | 14.185 | 28.174 | 15.247 | 20.713 |
| hex: http/css-1m | 524290 | 15668.6 ± 0.4% | 1464.0 ± 0.3% | 1084.4 ± 0.8% | 527.5 ± 0.6% | 989.7 ± 0.7% | 733.0 ± 0.3% | 10.702 | 14.450 | 29.705 | 15.831 | 21.375 |
| hex: shuffled/dickens-1m | 524290 | 15699.7 ± 0.3% | 1462.5 ± 0.3% | 1084.6 ± 0.4% | 499.5 ± 0.4% | 994.2 ± 0.3% | 733.3 ± 0.7% | 10.735 | 14.476 | 31.432 | 15.791 | 21.411 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 936.3 ± 0.1% | 927.7 ± 0.7% | 1020.8 ± 0.2% | 299.9 ± 0.6% | 667.2 ± 0.1% | 309.5 ± 1.9% | 1.009 | 0.917 | 3.122 | 1.403 | 3.025 |
| qlog records, JSON text sequence | 1467503 | 781.2 ± 0.6% | 817.1 ± 0.1% | 773.7 ± 1.5% | 243.9 ± 0.5% | 686.6 ± 0.5% | 249.2 ± 3.1% | 0.956 | 1.010 | 3.203 | 1.138 | 3.135 |
| string: silesia/dickens | 172528 | 5051.7 ± 0.3% | 1877.0 ± 0.1% | 2644.2 ± 0.3% | 361.5 ± 0.8% | 2842.3 ± 0.3% | 552.1 ± 1.7% | 2.691 | 1.910 | 13.973 | 1.777 | 9.150 |
| string: silesia/nci | 1075110 | 4289.1 ± 0.2% | 2233.4 ± 0.6% | 2989.6 ± 0.3% | 542.9 ± 1.1% | 2992.6 ± 0.2% | 594.2 ± 1.2% | 1.920 | 1.435 | 7.901 | 1.433 | 7.218 |
| string: silesia/reymont | 1075159 | 2982.3 ± 1.3% | 1804.1 ± 1.3% | 2060.5 ± 0.4% | 375.0 ± 0.7% | 2136.2 ± 0.8% | 531.4 ± 1.7% | 1.653 | 1.447 | 7.952 | 1.396 | 5.612 |
| string: silesia/samba | 97582 | 3503.3 ± 0.6% | 2026.6 ± 0.2% | 2619.7 ± 0.2% | 327.8 ± 0.3% | 1500.0 ± 0.7% | 426.3 ± 1.7% | 1.729 | 1.337 | 10.686 | 2.335 | 8.219 |
| string: silesia/webster | 1098490 | 3664.7 ± 0.6% | 1517.8 ± 0.1% | 2009.4 ± 0.3% | 359.6 ± 0.3% | 2171.2 ± 0.8% | 493.5 ± 2.8% | 2.414 | 1.824 | 10.191 | 1.688 | 7.426 |
| string: silesia/xml | 1090118 | 4801.2 ± 0.4% | 2359.4 ± 0.2% | 2524.4 ± 0.4% | 452.0 ± 0.9% | 2864.7 ± 0.5% | 565.9 ± 0.9% | 2.035 | 1.902 | 10.621 | 1.676 | 8.484 |
| string: canterbury/alice29.txt | 159425 | 4368.4 ± 1.6% | 1601.0 ± 0.3% | 2454.3 ± 0.2% | 343.3 ± 0.2% | 2494.4 ± 0.5% | 505.3 ± 1.5% | 2.729 | 1.780 | 12.726 | 1.751 | 8.646 |
| string: canterbury/asyoulik.txt | 132198 | 3480.1 ± 1.5% | 1459.5 ± 0.3% | 2248.5 ± 0.5% | 334.9 ± 1.1% | 2078.4 ± 0.5% | 457.2 ± 1.4% | 2.384 | 1.548 | 10.390 | 1.674 | 7.612 |
| string: canterbury/lcet10.txt | 441884 | 5124.8 ± 0.7% | 1851.5 ± 0.6% | 2340.7 ± 0.6% | 390.1 ± 0.7% | 2819.3 ± 1.1% | 532.2 ± 1.6% | 2.768 | 2.189 | 13.137 | 1.818 | 9.629 |
| string: canterbury/plrabn12.txt | 503330 | 4098.9 ± 0.3% | 1732.7 ± 0.3% | 2051.6 ± 0.2% | 359.9 ± 0.4% | 2482.8 ± 0.7% | 497.9 ± 0.9% | 2.366 | 1.998 | 11.389 | 1.651 | 8.232 |
| string: canterbury-large/E.coli | 1048578 | 11873.5 ± 0.5% | 3591.3 ± 0.3% | 3240.6 ± 0.5% | 929.5 ± 1.3% | 5916.0 ± 1.0% | 745.8 ± 2.6% | 3.306 | 3.664 | 12.774 | 2.007 | 15.921 |
| string: canterbury-large/bible.txt | 1055886 | 6899.3 ± 1.6% | 2934.8 ± 0.3% | 2827.3 ± 0.8% | 420.5 ± 0.8% | 3759.2 ± 2.0% | 610.8 ± 0.7% | 2.351 | 2.440 | 16.408 | 1.835 | 11.295 |
| string: canterbury-large/world192.txt | 1103121 | 3396.5 ± 0.4% | 1482.7 ± 0.1% | 2011.1 ± 0.2% | 353.5 ± 0.3% | 2114.9 ± 0.4% | 498.0 ± 0.7% | 2.291 | 1.689 | 9.608 | 1.606 | 6.820 |
| string: http/html-1m | 1058582 | 6210.9 ± 0.7% | 2736.5 ± 0.7% | 2695.4 ± 0.9% | 442.7 ± 0.9% | 3467.8 ± 0.5% | 593.2 ± 1.7% | 2.270 | 2.304 | 14.031 | 1.791 | 10.471 |
| string: http/json-1m | 1190272 | 2552.4 ± 0.6% | 877.4 ± 0.3% | 2244.5 ± 0.6% | 390.0 ± 0.5% | 1061.4 ± 0.3% | 437.5 ± 0.6% | 2.909 | 1.137 | 6.545 | 2.405 | 5.835 |
| string: http/js-1m | 1144362 | 2285.6 ± 0.1% | 1028.2 ± 0.1% | 1634.9 ± 0.3% | 320.0 ± 0.7% | 1521.6 ± 0.2% | 416.8 ± 1.5% | 2.223 | 1.398 | 7.143 | 1.502 | 5.483 |
| string: http/css-1m | 1097820 | 2646.8 ± 0.8% | 1676.0 ± 0.4% | 2224.6 ± 0.4% | 407.0 ± 0.8% | 1955.5 ± 0.8% | 485.8 ± 1.5% | 1.579 | 1.190 | 6.502 | 1.354 | 5.449 |
| string: dickens as Cyrillic and CJK | 1883069 | 3075.8 ± 0.3% | 1684.1 ± 0.5% | 891.9 ± 0.5% | 351.5 ± 0.2% | 671.5 ± 0.5% | 157.3 ± 2.8% | 1.826 | 3.449 | 8.752 | 4.581 | 19.556 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.7 ± 0.4% | 980.2 ± 0.2% | 1198.4 ± 1.5% | 215.9 ± 0.2% | 471.3 ± 1.5% | 252.5 ± 5.2% | 1.358 | 1.110 | 6.163 | 2.824 | 5.271 |
| hex: silesia/dickens | 524290 | 12016.0 ± 0.1% | 3616.9 ± 0.2% | 3294.2 ± 0.2% | 506.7 ± 1.7% | 6106.7 ± 2.1% | 780.9 ± 2.6% | 3.322 | 3.648 | 23.716 | 1.968 | 15.387 |
| hex: silesia/mozilla | 524290 | 11995.1 ± 0.1% | 3616.8 ± 0.1% | 3289.1 ± 0.1% | 453.1 ± 2.4% | 6060.8 ± 0.6% | 782.3 ± 0.9% | 3.316 | 3.647 | 26.473 | 1.979 | 15.334 |
| hex: silesia/mr | 524290 | 11988.0 ± 0.2% | 3615.7 ± 0.3% | 3294.4 ± 0.2% | 561.5 ± 2.0% | 6085.5 ± 2.3% | 782.0 ± 1.3% | 3.316 | 3.639 | 21.350 | 1.970 | 15.331 |
| hex: silesia/nci | 524290 | 11999.5 ± 0.4% | 3616.0 ± 0.1% | 3277.0 ± 0.3% | 616.1 ± 3.1% | 6082.1 ± 0.9% | 778.8 ± 0.9% | 3.318 | 3.662 | 19.478 | 1.973 | 15.407 |
| hex: silesia/ooffice | 524290 | 11995.1 ± 0.1% | 3614.5 ± 0.2% | 3285.0 ± 0.5% | 399.6 ± 1.2% | 6118.9 ± 1.6% | 783.4 ± 0.6% | 3.319 | 3.652 | 30.021 | 1.960 | 15.311 |
| hex: silesia/osdb | 524290 | 11977.3 ± 0.1% | 3615.7 ± 0.2% | 3285.3 ± 0.3% | 484.8 ± 2.1% | 6047.7 ± 1.4% | 784.3 ± 0.5% | 3.313 | 3.646 | 24.705 | 1.980 | 15.272 |
| hex: silesia/reymont | 524290 | 12013.6 ± 0.1% | 3617.8 ± 0.2% | 3285.0 ± 0.3% | 526.1 ± 1.2% | 6127.2 ± 1.1% | 781.3 ± 0.8% | 3.321 | 3.657 | 22.836 | 1.961 | 15.376 |
| hex: silesia/samba | 524290 | 11963.0 ± 0.2% | 3618.0 ± 0.3% | 3282.1 ± 0.3% | 412.5 ± 1.3% | 6120.4 ± 2.3% | 779.4 ± 0.6% | 3.307 | 3.645 | 29.000 | 1.955 | 15.349 |
| hex: silesia/sao | 524290 | 12019.2 ± 0.1% | 3620.2 ± 0.4% | 3288.9 ± 0.3% | 346.7 ± 1.1% | 6134.5 ± 1.2% | 783.7 ± 0.9% | 3.320 | 3.655 | 34.664 | 1.959 | 15.337 |
| hex: silesia/webster | 524290 | 11964.5 ± 0.1% | 3614.7 ± 0.2% | 3284.9 ± 0.3% | 477.0 ± 0.4% | 6090.3 ± 1.0% | 781.0 ± 0.5% | 3.310 | 3.642 | 25.082 | 1.965 | 15.320 |
| hex: silesia/x-ray | 524290 | 11983.7 ± 0.2% | 3620.0 ± 0.1% | 3291.2 ± 0.3% | 487.6 ± 0.8% | 6066.0 ± 0.7% | 781.4 ± 0.6% | 3.310 | 3.641 | 24.579 | 1.976 | 15.336 |
| hex: silesia/xml | 524290 | 12005.8 ± 0.1% | 3617.9 ± 0.3% | 3293.7 ± 0.2% | 530.8 ± 0.5% | 6087.7 ± 1.3% | 784.7 ± 0.9% | 3.318 | 3.645 | 22.617 | 1.972 | 15.300 |
| hex: canterbury/alice29.txt | 304180 | 12004.8 ± 0.1% | 3636.0 ± 0.1% | 3355.1 ± 0.2% | 523.7 ± 0.5% | 6092.9 ± 2.0% | 780.3 ± 1.7% | 3.302 | 3.578 | 22.924 | 1.970 | 15.384 |
| hex: canterbury/asyoulik.txt | 250360 | 12001.6 ± 0.1% | 3642.6 ± 0.0% | 3336.8 ± 0.2% | 512.2 ± 1.2% | 6141.4 ± 2.0% | 781.0 ± 0.4% | 3.295 | 3.597 | 23.433 | 1.954 | 15.367 |
| hex: canterbury/cp.html | 49208 | 11917.5 ± 0.1% | 3638.3 ± 0.0% | 3285.6 ± 0.6% | 474.0 ± 1.5% | 6275.6 ± 2.2% | 767.4 ± 0.7% | 3.276 | 3.627 | 25.142 | 1.899 | 15.530 |
| hex: canterbury/fields.c | 22302 | 11778.4 ± 0.1% | 3628.5 ± 0.1% | 3401.7 ± 0.3% | 509.7 ± 0.3% | 6249.5 ± 0.3% | 752.2 ± 2.0% | 3.246 | 3.463 | 23.110 | 1.885 | 15.658 |
| hex: canterbury/grammar.lsp | 7444 | 11260.1 ± 0.1% | 3601.3 ± 0.1% | 3353.2 ± 0.6% | 553.8 ± 1.6% | 6131.8 ± 0.6% | 723.8 ± 1.4% | 3.127 | 3.358 | 20.332 | 1.836 | 15.557 |
| hex: canterbury/kennedy.xls | 524290 | 12009.0 ± 0.2% | 3607.5 ± 0.3% | 3286.3 ± 0.6% | 659.3 ± 2.7% | 6136.9 ± 1.4% | 778.4 ± 5.9% | 3.329 | 3.654 | 18.214 | 1.957 | 15.428 |
| hex: canterbury/lcet10.txt | 524290 | 11999.8 ± 0.1% | 3603.0 ± 0.2% | 3276.5 ± 0.2% | 522.7 ± 2.0% | 6053.1 ± 0.9% | 781.6 ± 0.6% | 3.331 | 3.662 | 22.959 | 1.982 | 15.353 |
| hex: canterbury/plrabn12.txt | 524290 | 12021.0 ± 0.1% | 3606.6 ± 0.5% | 3293.7 ± 0.2% | 513.3 ± 2.9% | 6102.3 ± 0.6% | 782.4 ± 0.6% | 3.333 | 3.650 | 23.419 | 1.970 | 15.365 |
| hex: canterbury/ptt5 | 524290 | 12000.6 ± 0.1% | 3606.5 ± 0.3% | 3286.7 ± 0.2% | 563.1 ± 0.7% | 6097.5 ± 1.3% | 784.1 ± 0.5% | 3.327 | 3.651 | 21.313 | 1.968 | 15.305 |
| hex: canterbury/sum | 76482 | 11922.3 ± 0.2% | 3633.8 ± 0.0% | 3360.2 ± 0.2% | 515.2 ± 1.5% | 6172.6 ± 0.6% | 773.1 ± 1.4% | 3.281 | 3.548 | 23.140 | 1.931 | 15.421 |
| hex: canterbury/xargs.1 | 8456 | 11344.1 ± 0.1% | 3601.8 ± 0.1% | 3350.5 ± 0.2% | 496.2 ± 1.9% | 6122.8 ± 0.4% | 753.6 ± 1.5% | 3.150 | 3.386 | 22.863 | 1.853 | 15.053 |
| hex: canterbury-large/E.coli | 524290 | 11978.2 ± 0.1% | 3601.8 ± 0.5% | 3292.1 ± 0.3% | 688.9 ± 0.3% | 6129.8 ± 0.5% | 765.5 ± 5.0% | 3.326 | 3.638 | 17.388 | 1.954 | 15.648 |
| hex: canterbury-large/bible.txt | 524290 | 12012.5 ± 0.1% | 3599.6 ± 0.2% | 3298.0 ± 0.3% | 526.3 ± 1.4% | 6139.7 ± 1.2% | 775.3 ± 1.9% | 3.337 | 3.642 | 22.825 | 1.957 | 15.495 |
| hex: canterbury-large/world192.txt | 524290 | 12007.6 ± 0.1% | 3599.0 ± 0.1% | 3295.4 ± 0.3% | 503.3 ± 1.9% | 6097.2 ± 1.6% | 771.5 ± 2.1% | 3.336 | 3.644 | 23.858 | 1.969 | 15.563 |
| hex: http/html-1kx1024 | 2099200 | 8735.2 ± 4.8% | 3464.3 ± 0.1% | 2837.6 ± 0.8% | 473.3 ± 0.8% | 5202.9 ± 1.5% | 641.9 ± 6.3% | 2.522 | 3.078 | 18.455 | 1.679 | 13.609 |
| hex: http/html-16kx64 | 2097280 | 11742.3 ± 0.4% | 3609.3 ± 0.2% | 3255.9 ± 0.2% | 479.7 ± 1.6% | 5975.9 ± 0.2% | 755.6 ± 6.8% | 3.253 | 3.606 | 24.477 | 1.965 | 15.540 |
| hex: http/html-1m | 524290 | 12017.7 ± 0.1% | 3610.9 ± 0.7% | 3290.2 ± 0.5% | 498.4 ± 1.7% | 6086.2 ± 1.8% | 750.4 ± 5.0% | 3.328 | 3.653 | 24.113 | 1.975 | 16.016 |
| hex: http/json-1kx1024 | 2099200 | 8690.8 ± 4.5% | 3462.4 ± 0.2% | 2818.8 ± 0.9% | 573.8 ± 0.5% | 5189.6 ± 0.5% | 627.8 ± 2.8% | 2.510 | 3.083 | 15.147 | 1.675 | 13.842 |
| hex: http/json-16kx64 | 2097280 | 11755.3 ± 0.1% | 3606.4 ± 0.3% | 3250.9 ± 0.6% | 572.2 ± 1.8% | 6012.2 ± 0.3% | 748.0 ± 2.8% | 3.260 | 3.616 | 20.545 | 1.955 | 15.715 |
| hex: http/json-1m | 524290 | 12006.3 ± 0.2% | 3605.5 ± 0.4% | 3291.4 ± 1.0% | 589.7 ± 1.6% | 6087.9 ± 1.7% | 735.8 ± 2.5% | 3.330 | 3.648 | 20.359 | 1.972 | 16.317 |
| hex: http/js-1kx1024 | 2099200 | 8616.3 ± 5.2% | 3462.7 ± 0.1% | 2823.3 ± 0.4% | 478.0 ± 1.5% | 5243.1 ± 0.6% | 624.3 ± 5.0% | 2.488 | 3.052 | 18.026 | 1.643 | 13.802 |
| hex: http/js-16kx64 | 2097280 | 11746.0 ± 0.2% | 3608.0 ± 0.2% | 3256.8 ± 0.5% | 475.8 ± 0.5% | 5970.4 ± 0.2% | 726.9 ± 3.9% | 3.256 | 3.607 | 24.686 | 1.967 | 16.159 |
| hex: http/js-1m | 524290 | 11942.4 ± 0.4% | 3599.1 ± 0.2% | 3287.0 ± 0.3% | 502.7 ± 4.4% | 6044.1 ± 1.0% | 750.2 ± 2.7% | 3.318 | 3.633 | 23.755 | 1.976 | 15.919 |
| hex: http/css-1kx1024 | 2099200 | 8738.9 ± 4.0% | 3460.7 ± 0.1% | 2836.3 ± 1.1% | 488.0 ± 0.6% | 5210.5 ± 0.8% | 633.7 ± 4.0% | 2.525 | 3.081 | 17.906 | 1.677 | 13.789 |
| hex: http/css-16kx64 | 2097280 | 11745.2 ± 0.2% | 3604.3 ± 0.2% | 3249.4 ± 0.4% | 493.5 ± 0.4% | 5996.1 ± 1.0% | 730.1 ± 4.1% | 3.259 | 3.615 | 23.802 | 1.959 | 16.087 |
| hex: http/css-1m | 524290 | 11983.7 ± 0.1% | 3602.2 ± 0.5% | 3280.6 ± 0.1% | 499.9 ± 3.0% | 6114.6 ± 0.5% | 764.6 ± 3.2% | 3.327 | 3.653 | 23.972 | 1.960 | 15.673 |
| hex: shuffled/dickens-1m | 524290 | 12011.1 ± 0.1% | 3602.8 ± 0.2% | 3287.1 ± 0.3% | 522.0 ± 0.9% | 6114.3 ± 1.6% | 773.9 ± 0.4% | 3.334 | 3.654 | 23.008 | 1.964 | 15.521 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1013.2 ± 0.2% | 927.7 ± 0.7% | 1020.8 ± 0.2% | 299.9 ± 0.6% | 667.2 ± 0.1% | 309.5 ± 1.9% | 1.092 | 0.993 | 3.378 | 1.518 | 3.273 |
| qlog records, JSON text sequence | 1467503 | 837.5 ± 0.4% | 817.1 ± 0.1% | 773.7 ± 1.5% | 243.9 ± 0.5% | 686.6 ± 0.5% | 249.2 ± 3.1% | 1.025 | 1.082 | 3.434 | 1.220 | 3.361 |
| string: silesia/dickens | 172528 | 5055.7 ± 0.4% | 1877.0 ± 0.1% | 2644.2 ± 0.3% | 361.5 ± 0.8% | 2842.3 ± 0.3% | 552.1 ± 1.7% | 2.694 | 1.912 | 13.984 | 1.779 | 9.158 |
| string: silesia/nci | 1075110 | 4290.8 ± 0.3% | 2233.4 ± 0.6% | 2989.6 ± 0.3% | 542.9 ± 1.1% | 2992.6 ± 0.2% | 594.2 ± 1.2% | 1.921 | 1.435 | 7.904 | 1.434 | 7.221 |
| string: silesia/reymont | 1075159 | 2983.6 ± 1.6% | 1804.1 ± 1.3% | 2060.5 ± 0.4% | 375.0 ± 0.7% | 2136.2 ± 0.8% | 531.4 ± 1.7% | 1.654 | 1.448 | 7.955 | 1.397 | 5.615 |
| string: silesia/samba | 97582 | 3511.3 ± 0.4% | 2026.6 ± 0.2% | 2619.7 ± 0.2% | 327.8 ± 0.3% | 1500.0 ± 0.7% | 426.3 ± 1.7% | 1.733 | 1.340 | 10.710 | 2.341 | 8.238 |
| string: silesia/webster | 1098490 | 3667.8 ± 0.5% | 1517.8 ± 0.1% | 2009.4 ± 0.3% | 359.6 ± 0.3% | 2171.2 ± 0.8% | 493.5 ± 2.8% | 2.417 | 1.825 | 10.200 | 1.689 | 7.432 |
| string: silesia/xml | 1090118 | 4818.9 ± 0.3% | 2359.4 ± 0.2% | 2524.4 ± 0.4% | 452.0 ± 0.9% | 2864.7 ± 0.5% | 565.9 ± 0.9% | 2.042 | 1.909 | 10.660 | 1.682 | 8.515 |
| string: canterbury/alice29.txt | 159425 | 4374.0 ± 1.2% | 1601.0 ± 0.3% | 2454.3 ± 0.2% | 343.3 ± 0.2% | 2494.4 ± 0.5% | 505.3 ± 1.5% | 2.732 | 1.782 | 12.742 | 1.754 | 8.657 |
| string: canterbury/asyoulik.txt | 132198 | 3481.6 ± 1.5% | 1459.5 ± 0.3% | 2248.5 ± 0.5% | 334.9 ± 1.1% | 2078.4 ± 0.5% | 457.2 ± 1.4% | 2.385 | 1.548 | 10.395 | 1.675 | 7.615 |
| string: canterbury/lcet10.txt | 441884 | 5117.2 ± 1.9% | 1851.5 ± 0.6% | 2340.7 ± 0.6% | 390.1 ± 0.7% | 2819.3 ± 1.1% | 532.2 ± 1.6% | 2.764 | 2.186 | 13.118 | 1.815 | 9.615 |
| string: canterbury/plrabn12.txt | 503330 | 4097.6 ± 0.4% | 1732.7 ± 0.3% | 2051.6 ± 0.2% | 359.9 ± 0.4% | 2482.8 ± 0.7% | 497.9 ± 0.9% | 2.365 | 1.997 | 11.386 | 1.650 | 8.230 |
| string: canterbury-large/E.coli | 1048578 | 11864.9 ± 0.6% | 3591.3 ± 0.3% | 3240.6 ± 0.5% | 929.5 ± 1.3% | 5916.0 ± 1.0% | 745.8 ± 2.6% | 3.304 | 3.661 | 12.765 | 2.006 | 15.910 |
| string: canterbury-large/bible.txt | 1055886 | 6924.4 ± 1.6% | 2934.8 ± 0.3% | 2827.3 ± 0.8% | 420.5 ± 0.8% | 3759.2 ± 2.0% | 610.8 ± 0.7% | 2.359 | 2.449 | 16.468 | 1.842 | 11.336 |
| string: canterbury-large/world192.txt | 1103121 | 3388.9 ± 0.1% | 1482.7 ± 0.1% | 2011.1 ± 0.2% | 353.5 ± 0.3% | 2114.9 ± 0.4% | 498.0 ± 0.7% | 2.286 | 1.685 | 9.586 | 1.602 | 6.805 |
| string: http/html-1m | 1058582 | 6236.9 ± 0.9% | 2736.5 ± 0.7% | 2695.4 ± 0.9% | 442.7 ± 0.9% | 3467.8 ± 0.5% | 593.2 ± 1.7% | 2.279 | 2.314 | 14.090 | 1.799 | 10.515 |
| string: http/json-1m | 1190272 | 2553.2 ± 0.5% | 877.4 ± 0.3% | 2244.5 ± 0.6% | 390.0 ± 0.5% | 1061.4 ± 0.3% | 437.5 ± 0.6% | 2.910 | 1.138 | 6.547 | 2.405 | 5.836 |
| string: http/js-1m | 1144362 | 2283.1 ± 0.4% | 1028.2 ± 0.1% | 1634.9 ± 0.3% | 320.0 ± 0.7% | 1521.6 ± 0.2% | 416.8 ± 1.5% | 2.221 | 1.396 | 7.135 | 1.500 | 5.477 |
| string: http/css-1m | 1097820 | 2650.3 ± 0.8% | 1676.0 ± 0.4% | 2224.6 ± 0.4% | 407.0 ± 0.8% | 1955.5 ± 0.8% | 485.8 ± 1.5% | 1.581 | 1.191 | 6.511 | 1.355 | 5.456 |
| string: dickens as Cyrillic and CJK | 1883069 | 3081.2 ± 0.3% | 1684.1 ± 0.5% | 891.9 ± 0.5% | 351.5 ± 0.2% | 671.5 ± 0.5% | 157.3 ± 2.8% | 1.830 | 3.455 | 8.767 | 4.589 | 19.591 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.6 ± 0.4% | 980.2 ± 0.2% | 1198.4 ± 1.5% | 215.9 ± 0.2% | 471.3 ± 1.5% | 252.5 ± 5.2% | 1.357 | 1.110 | 6.163 | 2.823 | 5.270 |
| hex: silesia/dickens | 524290 | 12018.4 ± 0.1% | 3616.9 ± 0.2% | 3294.2 ± 0.2% | 506.7 ± 1.7% | 6106.7 ± 2.1% | 780.9 ± 2.6% | 3.323 | 3.648 | 23.721 | 1.968 | 15.390 |
| hex: silesia/mozilla | 524290 | 11994.7 ± 0.2% | 3616.8 ± 0.1% | 3289.1 ± 0.1% | 453.1 ± 2.4% | 6060.8 ± 0.6% | 782.3 ± 0.9% | 3.316 | 3.647 | 26.472 | 1.979 | 15.333 |
| hex: silesia/mr | 524290 | 11984.3 ± 0.1% | 3615.7 ± 0.3% | 3294.4 ± 0.2% | 561.5 ± 2.0% | 6085.5 ± 2.3% | 782.0 ± 1.3% | 3.315 | 3.638 | 21.344 | 1.969 | 15.326 |
| hex: silesia/nci | 524290 | 11999.6 ± 0.1% | 3616.0 ± 0.1% | 3277.0 ± 0.3% | 616.1 ± 3.1% | 6082.1 ± 0.9% | 778.8 ± 0.9% | 3.318 | 3.662 | 19.478 | 1.973 | 15.408 |
| hex: silesia/ooffice | 524290 | 11993.7 ± 0.1% | 3614.5 ± 0.2% | 3285.0 ± 0.5% | 399.6 ± 1.2% | 6118.9 ± 1.6% | 783.4 ± 0.6% | 3.318 | 3.651 | 30.017 | 1.960 | 15.309 |
| hex: silesia/osdb | 524290 | 11985.1 ± 0.1% | 3615.7 ± 0.2% | 3285.3 ± 0.3% | 484.8 ± 2.1% | 6047.7 ± 1.4% | 784.3 ± 0.5% | 3.315 | 3.648 | 24.721 | 1.982 | 15.282 |
| hex: silesia/reymont | 524290 | 12021.2 ± 0.1% | 3617.8 ± 0.2% | 3285.0 ± 0.3% | 526.1 ± 1.2% | 6127.2 ± 1.1% | 781.3 ± 0.8% | 3.323 | 3.659 | 22.851 | 1.962 | 15.386 |
| hex: silesia/samba | 524290 | 11947.0 ± 0.2% | 3618.0 ± 0.3% | 3282.1 ± 0.3% | 412.5 ± 1.3% | 6120.4 ± 2.3% | 779.4 ± 0.6% | 3.302 | 3.640 | 28.962 | 1.952 | 15.329 |
| hex: silesia/sao | 524290 | 12022.9 ± 0.1% | 3620.2 ± 0.4% | 3288.9 ± 0.3% | 346.7 ± 1.1% | 6134.5 ± 1.2% | 783.7 ± 0.9% | 3.321 | 3.656 | 34.674 | 1.960 | 15.342 |
| hex: silesia/webster | 524290 | 11989.9 ± 0.2% | 3614.7 ± 0.2% | 3284.9 ± 0.3% | 477.0 ± 0.4% | 6090.3 ± 1.0% | 781.0 ± 0.5% | 3.317 | 3.650 | 25.135 | 1.969 | 15.353 |
| hex: silesia/x-ray | 524290 | 11910.5 ± 0.1% | 3620.0 ± 0.1% | 3291.2 ± 0.3% | 487.6 ± 0.8% | 6066.0 ± 0.7% | 781.4 ± 0.6% | 3.290 | 3.619 | 24.429 | 1.963 | 15.242 |
| hex: silesia/xml | 524290 | 11999.3 ± 0.1% | 3617.9 ± 0.3% | 3293.7 ± 0.2% | 530.8 ± 0.5% | 6087.7 ± 1.3% | 784.7 ± 0.9% | 3.317 | 3.643 | 22.605 | 1.971 | 15.291 |
| hex: canterbury/alice29.txt | 304180 | 12006.0 ± 0.1% | 3636.0 ± 0.1% | 3355.1 ± 0.2% | 523.7 ± 0.5% | 6092.9 ± 2.0% | 780.3 ± 1.7% | 3.302 | 3.578 | 22.926 | 1.971 | 15.386 |
| hex: canterbury/asyoulik.txt | 250360 | 12002.3 ± 0.1% | 3642.6 ± 0.0% | 3336.8 ± 0.2% | 512.2 ± 1.2% | 6141.4 ± 2.0% | 781.0 ± 0.4% | 3.295 | 3.597 | 23.434 | 1.954 | 15.368 |
| hex: canterbury/cp.html | 49208 | 11923.3 ± 0.0% | 3638.3 ± 0.0% | 3285.6 ± 0.6% | 474.0 ± 1.5% | 6275.6 ± 2.2% | 767.4 ± 0.7% | 3.277 | 3.629 | 25.154 | 1.900 | 15.537 |
| hex: canterbury/fields.c | 22302 | 11783.2 ± 0.1% | 3628.5 ± 0.1% | 3401.7 ± 0.3% | 509.7 ± 0.3% | 6249.5 ± 0.3% | 752.2 ± 2.0% | 3.247 | 3.464 | 23.120 | 1.885 | 15.665 |
| hex: canterbury/grammar.lsp | 7444 | 11314.1 ± 0.2% | 3601.3 ± 0.1% | 3353.2 ± 0.6% | 553.8 ± 1.6% | 6131.8 ± 0.6% | 723.8 ± 1.4% | 3.142 | 3.374 | 20.429 | 1.845 | 15.631 |
| hex: canterbury/kennedy.xls | 524290 | 12023.8 ± 0.1% | 3607.5 ± 0.3% | 3286.3 ± 0.6% | 659.3 ± 2.7% | 6136.9 ± 1.4% | 778.4 ± 5.9% | 3.333 | 3.659 | 18.236 | 1.959 | 15.447 |
| hex: canterbury/lcet10.txt | 524290 | 11980.0 ± 0.1% | 3603.0 ± 0.2% | 3276.5 ± 0.2% | 522.7 ± 2.0% | 6053.1 ± 0.9% | 781.6 ± 0.6% | 3.325 | 3.656 | 22.921 | 1.979 | 15.327 |
| hex: canterbury/plrabn12.txt | 524290 | 12020.8 ± 0.1% | 3606.6 ± 0.5% | 3293.7 ± 0.2% | 513.3 ± 2.9% | 6102.3 ± 0.6% | 782.4 ± 0.6% | 3.333 | 3.650 | 23.419 | 1.970 | 15.365 |
| hex: canterbury/ptt5 | 524290 | 11997.6 ± 0.1% | 3606.5 ± 0.3% | 3286.7 ± 0.2% | 563.1 ± 0.7% | 6097.5 ± 1.3% | 784.1 ± 0.5% | 3.327 | 3.650 | 21.308 | 1.968 | 15.301 |
| hex: canterbury/sum | 76482 | 11918.0 ± 0.1% | 3633.8 ± 0.0% | 3360.2 ± 0.2% | 515.2 ± 1.5% | 6172.6 ± 0.6% | 773.1 ± 1.4% | 3.280 | 3.547 | 23.132 | 1.931 | 15.416 |
| hex: canterbury/xargs.1 | 8456 | 11347.9 ± 0.0% | 3601.8 ± 0.1% | 3350.5 ± 0.2% | 496.2 ± 1.9% | 6122.8 ± 0.4% | 753.6 ± 1.5% | 3.151 | 3.387 | 22.871 | 1.853 | 15.058 |
| hex: canterbury-large/E.coli | 524290 | 11981.5 ± 0.3% | 3601.8 ± 0.5% | 3292.1 ± 0.3% | 688.9 ± 0.3% | 6129.8 ± 0.5% | 765.5 ± 5.0% | 3.327 | 3.639 | 17.393 | 1.955 | 15.653 |
| hex: canterbury-large/bible.txt | 524290 | 12013.8 ± 0.1% | 3599.6 ± 0.2% | 3298.0 ± 0.3% | 526.3 ± 1.4% | 6139.7 ± 1.2% | 775.3 ± 1.9% | 3.338 | 3.643 | 22.827 | 1.957 | 15.496 |
| hex: canterbury-large/world192.txt | 524290 | 11993.9 ± 0.1% | 3599.0 ± 0.1% | 3295.4 ± 0.3% | 503.3 ± 1.9% | 6097.2 ± 1.6% | 771.5 ± 2.1% | 3.333 | 3.640 | 23.831 | 1.967 | 15.545 |
| hex: http/html-1kx1024 | 2099200 | 8759.2 ± 4.9% | 3464.3 ± 0.1% | 2837.6 ± 0.8% | 473.3 ± 0.8% | 5202.9 ± 1.5% | 641.9 ± 6.3% | 2.528 | 3.087 | 18.506 | 1.684 | 13.647 |
| hex: http/html-16kx64 | 2097280 | 11754.5 ± 0.6% | 3609.3 ± 0.2% | 3255.9 ± 0.2% | 479.7 ± 1.6% | 5975.9 ± 0.2% | 755.6 ± 6.8% | 3.257 | 3.610 | 24.502 | 1.967 | 15.556 |
| hex: http/html-1m | 524290 | 12016.5 ± 0.1% | 3610.9 ± 0.7% | 3290.2 ± 0.5% | 498.4 ± 1.7% | 6086.2 ± 1.8% | 750.4 ± 5.0% | 3.328 | 3.652 | 24.110 | 1.974 | 16.015 |
| hex: http/json-1kx1024 | 2099200 | 8714.8 ± 5.3% | 3462.4 ± 0.2% | 2818.8 ± 0.9% | 573.8 ± 0.5% | 5189.6 ± 0.5% | 627.8 ± 2.8% | 2.517 | 3.092 | 15.189 | 1.679 | 13.880 |
| hex: http/json-16kx64 | 2097280 | 11762.4 ± 0.3% | 3606.4 ± 0.3% | 3250.9 ± 0.6% | 572.2 ± 1.8% | 6012.2 ± 0.3% | 748.0 ± 2.8% | 3.262 | 3.618 | 20.557 | 1.956 | 15.725 |
| hex: http/json-1m | 524290 | 12001.0 ± 0.2% | 3605.5 ± 0.4% | 3291.4 ± 1.0% | 589.7 ± 1.6% | 6087.9 ± 1.7% | 735.8 ± 2.5% | 3.329 | 3.646 | 20.349 | 1.971 | 16.310 |
| hex: http/js-1kx1024 | 2099200 | 8686.1 ± 5.3% | 3462.7 ± 0.1% | 2823.3 ± 0.4% | 478.0 ± 1.5% | 5243.1 ± 0.6% | 624.3 ± 5.0% | 2.508 | 3.077 | 18.172 | 1.657 | 13.914 |
| hex: http/js-16kx64 | 2097280 | 11736.7 ± 0.3% | 3608.0 ± 0.2% | 3256.8 ± 0.5% | 475.8 ± 0.5% | 5970.4 ± 0.2% | 726.9 ± 3.9% | 3.253 | 3.604 | 24.666 | 1.966 | 16.146 |
| hex: http/js-1m | 524290 | 11932.0 ± 0.2% | 3599.1 ± 0.2% | 3287.0 ± 0.3% | 502.7 ± 4.4% | 6044.1 ± 1.0% | 750.2 ± 2.7% | 3.315 | 3.630 | 23.735 | 1.974 | 15.905 |
| hex: http/css-1kx1024 | 2099200 | 8766.6 ± 4.1% | 3460.7 ± 0.1% | 2836.3 ± 1.1% | 488.0 ± 0.6% | 5210.5 ± 0.8% | 633.7 ± 4.0% | 2.533 | 3.091 | 17.963 | 1.682 | 13.833 |
| hex: http/css-16kx64 | 2097280 | 11746.5 ± 0.3% | 3604.3 ± 0.2% | 3249.4 ± 0.4% | 493.5 ± 0.4% | 5996.1 ± 1.0% | 730.1 ± 4.1% | 3.259 | 3.615 | 23.804 | 1.959 | 16.089 |
| hex: http/css-1m | 524290 | 11981.0 ± 0.4% | 3602.2 ± 0.5% | 3280.6 ± 0.1% | 499.9 ± 3.0% | 6114.6 ± 0.5% | 764.6 ± 3.2% | 3.326 | 3.652 | 23.966 | 1.959 | 15.669 |
| hex: shuffled/dickens-1m | 524290 | 12010.5 ± 0.3% | 3602.8 ± 0.2% | 3287.1 ± 0.3% | 522.0 ± 0.9% | 6114.3 ± 1.6% | 773.9 ± 0.4% | 3.334 | 3.654 | 23.006 | 1.964 | 15.520 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1354.1 ± 0.1% | 1251.3 ± 0.6% | 1038.2 ± 0.5% | 409.4 ± 0.3% | 448.1 ± 0.3% | 415.9 ± 0.4% | 1.082 | 1.304 | 3.308 | 3.022 | 3.256 |
| qlog records, JSON text sequence | 1467503 | 1052.4 ± 0.1% | 1062.2 ± 0.7% | 786.8 ± 0.6% | 377.9 ± 1.0% | 467.5 ± 0.8% | 279.5 ± 0.3% | 0.991 | 1.338 | 2.785 | 2.251 | 3.766 |
| string: silesia/dickens | 172528 | 6906.6 ± 0.4% | 2816.1 ± 0.6% | 2926.7 ± 0.8% | 429.7 ± 0.8% | 1591.6 ± 0.3% | 1011.8 ± 0.2% | 2.453 | 2.360 | 16.073 | 4.339 | 6.826 |
| string: silesia/nci | 1075110 | 7304.3 ± 0.4% | 3380.8 ± 0.9% | 3101.1 ± 0.5% | 818.8 ± 2.1% | 1859.6 ± 0.3% | 1107.1 ± 0.4% | 2.161 | 2.355 | 8.921 | 3.928 | 6.598 |
| string: silesia/reymont | 1075159 | 3354.8 ± 0.4% | 1983.9 ± 0.4% | 2058.3 ± 0.7% | 449.8 ± 1.2% | 1507.6 ± 0.2% | 947.8 ± 0.4% | 1.691 | 1.630 | 7.459 | 2.225 | 3.540 |
| string: silesia/samba | 97582 | 4205.9 ± 0.4% | 2111.4 ± 0.6% | 3451.2 ± 0.7% | 354.8 ± 0.2% | 1435.1 ± 0.3% | 1054.3 ± 0.1% | 1.992 | 1.219 | 11.855 | 2.931 | 3.989 |
| string: silesia/webster | 1098490 | 4067.8 ± 0.6% | 1876.5 ± 0.7% | 2050.7 ± 0.5% | 439.5 ± 0.6% | 1393.0 ± 0.2% | 645.6 ± 1.0% | 2.168 | 1.984 | 9.256 | 2.920 | 6.300 |
| string: silesia/xml | 1090118 | 6131.8 ± 0.6% | 2848.2 ± 0.8% | 2643.0 ± 0.7% | 611.3 ± 0.4% | 1750.4 ± 0.5% | 919.6 ± 0.4% | 2.153 | 2.320 | 10.031 | 3.503 | 6.668 |
| string: canterbury/alice29.txt | 159425 | 6454.7 ± 1.2% | 2201.1 ± 0.6% | 2737.4 ± 0.7% | 404.8 ± 0.8% | 1480.3 ± 0.3% | 952.6 ± 0.3% | 2.932 | 2.358 | 15.946 | 4.360 | 6.776 |
| string: canterbury/asyoulik.txt | 132198 | 5630.8 ± 1.1% | 1715.2 ± 0.7% | 2370.2 ± 0.6% | 401.1 ± 0.7% | 1344.3 ± 0.9% | 884.1 ± 0.3% | 3.283 | 2.376 | 14.038 | 4.189 | 6.369 |
| string: canterbury/lcet10.txt | 441884 | 6271.5 ± 0.5% | 2559.9 ± 0.3% | 2471.6 ± 1.4% | 467.0 ± 1.0% | 1539.3 ± 0.6% | 982.6 ± 0.4% | 2.450 | 2.537 | 13.430 | 4.074 | 6.382 |
| string: canterbury/plrabn12.txt | 503330 | 5713.1 ± 0.3% | 2051.6 ± 0.5% | 2072.3 ± 0.3% | 424.2 ± 0.3% | 1425.1 ± 0.2% | 932.0 ± 0.6% | 2.785 | 2.757 | 13.469 | 4.009 | 6.130 |
| string: canterbury-large/E.coli | 1048578 | 19143.9 ± 1.5% | 9658.7 ± 0.9% | 3780.3 ± 0.3% | 1473.1 ± 0.6% | 2347.5 ± 1.0% | 1189.8 ± 0.2% | 1.982 | 5.064 | 12.996 | 8.155 | 16.090 |
| string: canterbury-large/bible.txt | 1055886 | 6800.4 ± 0.3% | 4134.4 ± 0.7% | 3011.5 ± 1.7% | 503.2 ± 0.6% | 1971.1 ± 0.3% | 1119.0 ± 0.2% | 1.645 | 2.258 | 13.515 | 3.450 | 6.077 |
| string: canterbury-large/world192.txt | 1103121 | 4052.1 ± 0.4% | 1656.5 ± 0.3% | 2000.0 ± 1.1% | 448.2 ± 0.4% | 1358.4 ± 0.4% | 908.2 ± 0.2% | 2.446 | 2.026 | 9.041 | 2.983 | 4.462 |
| string: http/html-1m | 1058582 | 6750.3 ± 1.8% | 3984.6 ± 0.4% | 3033.9 ± 0.5% | 499.6 ± 1.2% | 1911.8 ± 0.3% | 803.7 ± 0.5% | 1.694 | 2.225 | 13.512 | 3.531 | 8.399 |
| string: http/json-1m | 1190272 | 3172.0 ± 0.5% | 1344.0 ± 0.5% | 1554.8 ± 0.2% | 442.7 ± 0.4% | 960.8 ± 0.2% | 765.4 ± 1.1% | 2.360 | 2.040 | 7.166 | 3.301 | 4.144 |
| string: http/js-1m | 1144362 | 2768.4 ± 0.5% | 1176.4 ± 0.5% | 1626.2 ± 0.5% | 368.6 ± 0.3% | 1095.7 ± 0.1% | 757.9 ± 0.2% | 2.353 | 1.702 | 7.511 | 2.527 | 3.652 |
| string: http/css-1m | 1097820 | 4008.7 ± 0.7% | 1480.2 ± 0.4% | 2146.6 ± 0.8% | 493.8 ± 0.4% | 1368.5 ± 0.2% | 893.9 ± 0.2% | 2.708 | 1.867 | 8.118 | 2.929 | 4.485 |
| string: dickens as Cyrillic and CJK | 1883069 | 3069.8 ± 0.6% | 2339.4 ± 0.5% | 521.4 ± 0.3% | 308.4 ± 0.5% | 563.8 ± 0.5% | 335.9 ± 0.3% | 1.312 | 5.887 | 9.954 | 5.445 | 9.138 |
| hex: silesia/dickens | 524290 | 15627.4 ± 0.4% | 1457.2 ± 0.3% | 1081.9 ± 0.3% | 502.5 ± 2.0% | 987.9 ± 0.5% | 733.7 ± 0.3% | 10.724 | 14.444 | 31.100 | 15.819 | 21.299 |
| hex: silesia/mozilla | 524290 | 15599.0 ± 0.7% | 1467.5 ± 0.4% | 1084.9 ± 0.4% | 441.2 ± 0.5% | 992.9 ± 0.4% | 733.6 ± 0.7% | 10.629 | 14.378 | 35.354 | 15.710 | 21.264 |
| hex: silesia/mr | 524290 | 15670.1 ± 0.2% | 1474.8 ± 0.2% | 1090.9 ± 0.5% | 551.8 ± 2.7% | 997.5 ± 0.9% | 733.2 ± 0.5% | 10.625 | 14.365 | 28.398 | 15.709 | 21.371 |
| hex: silesia/nci | 524290 | 15647.9 ± 0.4% | 1468.8 ± 0.5% | 1087.6 ± 0.7% | 636.5 ± 3.3% | 992.1 ± 0.6% | 734.4 ± 0.4% | 10.653 | 14.387 | 24.585 | 15.772 | 21.308 |
| hex: silesia/ooffice | 524290 | 15612.6 ± 0.4% | 1459.9 ± 0.4% | 1082.0 ± 0.4% | 388.9 ± 0.3% | 987.5 ± 0.5% | 733.4 ± 0.4% | 10.695 | 14.429 | 40.143 | 15.810 | 21.287 |
| hex: silesia/osdb | 524290 | 15630.8 ± 0.4% | 1464.1 ± 0.2% | 1087.4 ± 0.2% | 467.8 ± 2.1% | 988.3 ± 0.5% | 732.8 ± 0.4% | 10.676 | 14.374 | 33.415 | 15.816 | 21.329 |
| hex: silesia/reymont | 524290 | 15664.1 ± 0.1% | 1459.8 ± 0.4% | 1081.3 ± 0.5% | 515.2 ± 1.0% | 992.2 ± 0.9% | 733.2 ± 0.8% | 10.730 | 14.486 | 30.404 | 15.787 | 21.365 |
| hex: silesia/samba | 524290 | 15640.5 ± 0.3% | 1463.3 ± 0.2% | 1085.8 ± 0.5% | 402.6 ± 0.5% | 989.7 ± 0.2% | 734.3 ± 0.5% | 10.689 | 14.405 | 38.846 | 15.803 | 21.298 |
| hex: silesia/sao | 524290 | 15583.9 ± 0.2% | 1459.8 ± 0.3% | 1083.3 ± 0.4% | 332.4 ± 0.6% | 987.8 ± 0.5% | 732.0 ± 0.1% | 10.675 | 14.386 | 46.880 | 15.777 | 21.289 |
| hex: silesia/webster | 524290 | 15656.3 ± 0.4% | 1462.5 ± 0.4% | 1084.8 ± 0.6% | 474.5 ± 0.4% | 989.3 ± 0.8% | 733.3 ± 0.7% | 10.705 | 14.432 | 32.994 | 15.826 | 21.351 |
| hex: silesia/x-ray | 524290 | 15581.8 ± 0.4% | 1470.0 ± 0.2% | 1089.4 ± 0.5% | 443.4 ± 1.5% | 994.8 ± 0.5% | 732.9 ± 0.7% | 10.600 | 14.303 | 35.139 | 15.663 | 21.260 |
| hex: silesia/xml | 524290 | 15662.5 ± 0.1% | 1465.4 ± 0.3% | 1085.3 ± 0.4% | 611.6 ± 0.9% | 989.2 ± 0.5% | 733.3 ± 0.4% | 10.688 | 14.431 | 25.607 | 15.834 | 21.360 |
| hex: canterbury/alice29.txt | 304180 | 15680.5 ± 0.1% | 1464.4 ± 0.5% | 1089.0 ± 0.5% | 502.4 ± 1.0% | 992.1 ± 0.6% | 733.0 ± 0.4% | 10.708 | 14.399 | 31.209 | 15.805 | 21.391 |
| hex: canterbury/asyoulik.txt | 250360 | 15715.2 ± 0.1% | 1472.1 ± 0.2% | 1095.4 ± 0.5% | 499.5 ± 1.6% | 996.0 ± 0.5% | 740.6 ± 0.2% | 10.675 | 14.346 | 31.461 | 15.778 | 21.221 |
| hex: canterbury/cp.html | 49208 | 15666.0 ± 0.0% | 1474.6 ± 0.8% | 1096.7 ± 0.1% | 524.2 ± 2.1% | 1006.7 ± 0.5% | 742.9 ± 0.1% | 10.624 | 14.284 | 29.886 | 15.561 | 21.089 |
| hex: canterbury/fields.c | 22302 | 15518.0 ± 0.0% | 1413.7 ± 0.8% | 1065.0 ± 0.5% | 616.4 ± 9.8% | 979.7 ± 0.6% | 736.5 ± 0.2% | 10.976 | 14.571 | 25.175 | 15.839 | 21.071 |
| hex: canterbury/grammar.lsp | 7444 | 15153.6 ± 0.0% | 1485.9 ± 0.5% | 1095.5 ± 0.4% | 651.6 ± 5.1% | 997.1 ± 0.3% | 726.1 ± 0.1% | 10.198 | 13.832 | 23.257 | 15.198 | 20.871 |
| hex: canterbury/kennedy.xls | 524290 | 15627.7 ± 0.6% | 1467.9 ± 1.0% | 1085.5 ± 0.5% | 651.7 ± 1.6% | 990.4 ± 0.3% | 733.3 ± 0.9% | 10.646 | 14.396 | 23.978 | 15.780 | 21.312 |
| hex: canterbury/lcet10.txt | 524290 | 15613.1 ± 0.6% | 1457.2 ± 0.3% | 1082.0 ± 0.5% | 500.5 ± 0.6% | 986.9 ± 0.2% | 732.8 ± 0.9% | 10.715 | 14.430 | 31.196 | 15.820 | 21.306 |
| hex: canterbury/plrabn12.txt | 524290 | 15636.9 ± 0.4% | 1459.3 ± 0.3% | 1082.5 ± 0.3% | 492.2 ± 0.8% | 989.6 ± 0.5% | 732.6 ± 0.2% | 10.715 | 14.445 | 31.769 | 15.802 | 21.343 |
| hex: canterbury/ptt5 | 524290 | 15579.7 ± 0.3% | 1476.7 ± 0.1% | 1092.9 ± 0.4% | 555.1 ± 0.7% | 992.5 ± 0.6% | 733.0 ± 1.0% | 10.550 | 14.256 | 28.066 | 15.697 | 21.254 |
| hex: canterbury/sum | 76482 | 15677.1 ± 0.1% | 1494.8 ± 0.1% | 1104.3 ± 0.2% | 594.7 ± 2.4% | 998.4 ± 0.0% | 744.6 ± 0.1% | 10.488 | 14.196 | 26.362 | 15.702 | 21.053 |
| hex: canterbury/xargs.1 | 8456 | 15205.6 ± 0.1% | 1432.2 ± 0.3% | 1095.3 ± 0.4% | 655.9 ± 3.0% | 1004.9 ± 0.5% | 727.8 ± 0.2% | 10.617 | 13.882 | 23.184 | 15.132 | 20.894 |
| hex: canterbury-large/E.coli | 524290 | 15575.4 ± 0.5% | 1465.9 ± 1.3% | 1086.8 ± 0.5% | 671.2 ± 0.1% | 991.1 ± 0.5% | 731.8 ± 0.4% | 10.625 | 14.331 | 23.206 | 15.715 | 21.282 |
| hex: canterbury-large/bible.txt | 524290 | 15597.4 ± 0.3% | 1459.5 ± 0.3% | 1082.4 ± 0.3% | 517.8 ± 1.0% | 988.0 ± 0.3% | 732.4 ± 0.8% | 10.687 | 14.409 | 30.123 | 15.787 | 21.297 |
| hex: canterbury-large/world192.txt | 524290 | 15556.8 ± 0.3% | 1458.9 ± 0.2% | 1084.0 ± 0.2% | 501.2 ± 0.7% | 988.0 ± 0.9% | 731.9 ± 0.3% | 10.663 | 14.351 | 31.038 | 15.746 | 21.255 |
| hex: http/html-1kx1024 | 2099200 | 14134.2 ± 0.7% | 1454.8 ± 0.2% | 1061.5 ± 0.2% | 500.8 ± 0.2% | 983.1 ± 0.2% | 692.3 ± 0.1% | 9.715 | 13.315 | 28.225 | 14.378 | 20.415 |
| hex: http/html-16kx64 | 2097280 | 15346.0 ± 0.3% | 1442.4 ± 0.1% | 1074.1 ± 0.4% | 507.2 ± 0.2% | 997.2 ± 0.1% | 734.8 ± 0.2% | 10.639 | 14.288 | 30.258 | 15.388 | 20.885 |
| hex: http/html-1m | 524290 | 15661.4 ± 0.4% | 1461.1 ± 0.3% | 1081.9 ± 0.5% | 502.7 ± 0.2% | 991.1 ± 0.2% | 733.5 ± 0.5% | 10.719 | 14.476 | 31.158 | 15.802 | 21.352 |
| hex: http/json-1kx1024 | 2099200 | 14155.5 ± 0.7% | 1463.6 ± 0.3% | 1068.6 ± 0.3% | 608.8 ± 0.4% | 986.9 ± 0.3% | 692.5 ± 0.1% | 9.672 | 13.247 | 23.253 | 14.343 | 20.440 |
| hex: http/json-16kx64 | 2097280 | 15364.8 ± 0.3% | 1442.0 ± 0.1% | 1073.8 ± 0.5% | 614.6 ± 0.7% | 996.9 ± 0.2% | 734.7 ± 0.1% | 10.655 | 14.308 | 25.000 | 15.413 | 20.913 |
| hex: http/json-1m | 524290 | 15614.9 ± 0.3% | 1468.6 ± 0.2% | 1090.8 ± 0.2% | 634.6 ± 0.4% | 990.6 ± 0.5% | 735.1 ± 0.5% | 10.632 | 14.315 | 24.607 | 15.763 | 21.243 |
| hex: http/js-1kx1024 | 2099200 | 14112.6 ± 0.7% | 1454.5 ± 0.2% | 1066.5 ± 0.7% | 498.9 ± 0.1% | 984.6 ± 0.3% | 692.1 ± 0.3% | 9.703 | 13.233 | 28.289 | 14.334 | 20.391 |
| hex: http/js-16kx64 | 2097280 | 15394.2 ± 0.5% | 1440.9 ± 0.1% | 1072.4 ± 0.3% | 505.0 ± 0.3% | 996.5 ± 0.3% | 733.9 ± 0.2% | 10.684 | 14.355 | 30.484 | 15.449 | 20.976 |
| hex: http/js-1m | 524290 | 15635.7 ± 0.7% | 1460.6 ± 0.2% | 1084.7 ± 0.4% | 509.7 ± 0.6% | 986.0 ± 0.4% | 734.8 ± 0.7% | 10.705 | 14.415 | 30.674 | 15.858 | 21.277 |
| hex: http/css-1kx1024 | 2099200 | 14103.0 ± 0.5% | 1455.3 ± 0.2% | 1063.7 ± 0.4% | 531.5 ± 0.3% | 983.1 ± 0.2% | 692.4 ± 0.1% | 9.691 | 13.259 | 26.535 | 14.345 | 20.367 |
| hex: http/css-16kx64 | 2097280 | 15372.1 ± 0.6% | 1443.3 ± 0.4% | 1073.3 ± 0.3% | 540.3 ± 0.3% | 998.5 ± 0.2% | 735.0 ± 0.3% | 10.651 | 14.323 | 28.449 | 15.395 | 20.914 |
| hex: http/css-1m | 524290 | 15630.9 ± 0.4% | 1464.0 ± 0.3% | 1084.4 ± 0.8% | 527.5 ± 0.6% | 989.7 ± 0.7% | 733.0 ± 0.3% | 10.677 | 14.415 | 29.633 | 15.793 | 21.323 |
| hex: shuffled/dickens-1m | 524290 | 15695.8 ± 0.3% | 1462.5 ± 0.3% | 1084.6 ± 0.4% | 499.5 ± 0.4% | 994.2 ± 0.3% | 733.3 ± 0.7% | 10.732 | 14.472 | 31.424 | 15.787 | 21.406 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.917 of yyjson.
