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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43625761107 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1129.7 ± 0.3% | 0.522 | 0.963 | 0.995 | 0.996 | 0.459 | 1.002 | 1.005 | 0.387 | 0.830 | 0.898 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 836.4 ± 1.2% | 0.824 | 1.010 | 1.006 | 1.010 | 0.449 | 0.999 | 1.034 | 0.406 | 0.934 | 1.003 | 0.127 |
| string: silesia/dickens | 172528 | 5040.3 ± 0.3% | 0.033 | 0.781 | 1.002 | 1.003 | 0.196 | 1.019 | 1.005 | 0.196 | 1.002 | 1.001 | 0.032 |
| string: silesia/nci | 1075110 | 4313.3 ± 1.1% | 0.039 | 0.800 | 1.000 | 1.001 | 0.278 | 1.005 | 0.995 | 0.277 | 1.001 | 1.002 | 0.038 |
| string: silesia/reymont | 1075159 | 2936.9 ± 1.6% | 0.057 | 0.822 | 1.000 | 1.008 | 0.359 | 1.002 | 1.004 | 0.359 | 1.019 | 1.014 | 0.056 |
| string: silesia/samba | 97582 | 3494.6 ± 0.4% | 0.039 | 0.862 | 1.003 | 1.004 | 0.068 | 0.779 | 1.010 | 0.072 | 1.003 | 1.005 | 0.039 |
| string: silesia/webster | 1098490 | 3642.4 ± 1.3% | 0.045 | 0.848 | 1.006 | 1.006 | 0.203 | 1.022 | 1.014 | 0.203 | 1.008 | 1.008 | 0.044 |
| string: silesia/xml | 1090118 | 4762.9 ± 0.7% | 0.035 | 0.811 | 1.009 | 1.010 | 0.223 | 0.980 | 1.010 | 0.225 | 1.007 | 1.006 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4306.1 ± 0.5% | 0.038 | 0.752 | 1.004 | 1.008 | 0.171 | 1.028 | 1.018 | 0.171 | 1.009 | 1.011 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3447.5 ± 1.0% | 0.046 | 0.750 | 1.010 | 1.012 | 0.177 | 1.005 | 0.972 | 0.176 | 1.011 | 1.015 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5063.7 ± 0.5% | 0.033 | 0.821 | 1.006 | 1.007 | 0.197 | 1.027 | 1.015 | 0.197 | 1.006 | 1.004 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4100.2 ± 0.9% | 0.040 | 0.827 | 1.004 | 1.003 | 0.199 | 1.011 | 1.003 | 0.198 | 1.006 | 1.004 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19201.0 ± 0.6% | 0.077 | 1.005 | 1.003 | 1.007 | 0.476 | 1.004 | 1.001 | 0.478 | 0.619 | 0.619 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6711.3 ± 1.1% | 0.026 | 0.800 | 0.999 | 1.004 | 0.430 | 1.020 | 1.038 | 0.430 | 1.034 | 1.037 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3392.5 ± 0.4% | 0.048 | 0.844 | 1.002 | 1.003 | 0.197 | 1.013 | 1.004 | 0.196 | 1.003 | 1.003 | 0.047 |
| string: http/html-1m | 1058582 | 6055.9 ± 2.3% | 0.028 | 0.780 | 1.002 | 1.030 | 0.389 | 1.041 | 1.054 | 0.388 | 1.026 | 1.032 | 0.028 |
| string: http/json-1m | 1190272 | 2546.8 ± 0.4% | 0.056 | 0.952 | 1.007 | 1.005 | 0.111 | 1.004 | 0.471 | 0.111 | 1.004 | 1.004 | 0.055 |
| string: http/js-1m | 1144362 | 2280.6 ± 0.6% | 0.067 | 0.888 | 1.002 | 1.001 | 0.174 | 1.057 | 1.046 | 0.174 | 1.002 | 1.002 | 0.066 |
| string: http/css-1m | 1097820 | 2638.4 ± 0.5% | 0.060 | 0.776 | 1.003 | 1.007 | 0.240 | 1.007 | 1.014 | 0.239 | 1.006 | 1.008 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3068.6 ± 0.5% | 0.044 | 0.125 | 1.003 | 1.006 | 0.336 | 0.999 | 1.008 | 0.336 | 1.002 | 1.003 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.3 ± 1.3% | 0.081 | 1.002 | 1.001 | 1.000 | 0.076 | 0.636 | 1.003 | 0.081 | 1.001 | 1.001 | 0.081 |
| hex: silesia/dickens | 524290 | 18502.7 ± 0.7% | 0.081 | 1.013 | 0.989 | 0.989 | 0.523 | 0.995 | 0.993 | 0.524 | 0.649 | 0.649 | 0.009 |
| hex: silesia/mozilla | 524290 | 18401.1 ± 2.4% | 0.081 | 1.016 | 1.001 | 0.988 | 0.516 | 0.994 | 0.986 | 0.515 | 0.651 | 0.651 | 0.009 |
| hex: silesia/mr | 524290 | 18048.5 ± 0.5% | 0.082 | 1.012 | 1.004 | 1.004 | 0.535 | 0.999 | 1.004 | 0.536 | 0.666 | 0.666 | 0.010 |
| hex: silesia/nci | 524290 | 18865.4 ± 1.1% | 0.078 | 1.001 | 1.002 | 1.000 | 0.496 | 0.998 | 1.002 | 0.498 | 0.632 | 0.633 | 0.009 |
| hex: silesia/ooffice | 524290 | 18680.8 ± 1.5% | 0.079 | 1.009 | 1.002 | 0.999 | 0.503 | 0.991 | 1.001 | 0.505 | 0.642 | 0.642 | 0.009 |
| hex: silesia/osdb | 524290 | 18188.9 ± 0.5% | 0.082 | 1.003 | 0.999 | 0.998 | 0.521 | 1.001 | 0.992 | 0.523 | 0.658 | 0.658 | 0.010 |
| hex: silesia/reymont | 524290 | 18405.6 ± 0.6% | 0.081 | 1.000 | 1.000 | 1.003 | 0.518 | 0.996 | 1.000 | 0.519 | 0.650 | 0.647 | 0.009 |
| hex: silesia/samba | 524290 | 17647.1 ± 0.8% | 0.084 | 1.004 | 1.000 | 1.002 | 0.528 | 1.004 | 1.000 | 0.529 | 0.674 | 0.673 | 0.010 |
| hex: silesia/sao | 524290 | 18478.0 ± 1.0% | 0.080 | 1.006 | 1.007 | 1.003 | 0.523 | 1.002 | 0.991 | 0.524 | 0.649 | 0.649 | 0.009 |
| hex: silesia/webster | 524290 | 18490.9 ± 0.5% | 0.080 | 1.012 | 1.007 | 1.003 | 0.512 | 1.002 | 1.005 | 0.512 | 0.650 | 0.649 | 0.009 |
| hex: silesia/x-ray | 524290 | 18333.1 ± 0.9% | 0.081 | 1.005 | 0.999 | 0.997 | 0.519 | 0.998 | 1.006 | 0.521 | 0.655 | 0.655 | 0.009 |
| hex: silesia/xml | 524290 | 18584.9 ± 1.8% | 0.080 | 0.999 | 0.998 | 1.000 | 0.504 | 0.999 | 0.997 | 0.503 | 0.645 | 0.644 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19524.6 ± 0.1% | 0.077 | 1.002 | 1.001 | 1.002 | 0.514 | 0.991 | 1.002 | 0.514 | 0.615 | 0.615 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19526.8 ± 0.4% | 0.077 | 1.002 | 1.002 | 1.003 | 0.514 | 1.003 | 1.002 | 0.514 | 0.615 | 0.615 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19230.6 ± 0.5% | 0.081 | 1.003 | 1.002 | 1.001 | 0.543 | 1.002 | 1.002 | 0.544 | 0.619 | 0.619 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18823.1 ± 0.9% | 0.082 | 1.003 | 1.003 | 1.003 | 0.537 | 1.002 | 0.999 | 0.542 | 0.626 | 0.626 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17262.5 ± 1.6% | 0.089 | 1.007 | 1.006 | 1.007 | 0.534 | 1.006 | 1.007 | 0.553 | 0.652 | 0.656 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18153.2 ± 0.9% | 0.082 | 1.003 | 1.008 | 1.008 | 0.522 | 1.004 | 1.006 | 0.520 | 0.656 | 0.659 | 0.010 |
| hex: canterbury/lcet10.txt | 524290 | 18137.2 ± 0.8% | 0.082 | 1.012 | 0.999 | 0.999 | 0.542 | 1.006 | 1.001 | 0.542 | 0.663 | 0.663 | 0.010 |
| hex: canterbury/plrabn12.txt | 524290 | 18215.6 ± 1.3% | 0.082 | 1.002 | 1.005 | 1.001 | 0.525 | 1.005 | 1.000 | 0.523 | 0.659 | 0.659 | 0.010 |
| hex: canterbury/ptt5 | 524290 | 18121.8 ± 0.7% | 0.082 | 1.001 | 1.001 | 1.001 | 0.524 | 1.001 | 1.002 | 0.521 | 0.662 | 0.662 | 0.010 |
| hex: canterbury/sum | 76482 | 19276.7 ± 0.1% | 0.078 | 1.001 | 1.002 | 1.002 | 0.518 | 1.001 | 1.001 | 0.520 | 0.617 | 0.617 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17625.2 ± 0.7% | 0.088 | 1.001 | 1.001 | 1.002 | 0.530 | 1.000 | 1.001 | 0.546 | 0.643 | 0.643 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18730.0 ± 1.0% | 0.079 | 1.005 | 0.994 | 0.988 | 0.508 | 0.993 | 0.991 | 0.508 | 0.638 | 0.640 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18340.6 ± 1.0% | 0.081 | 1.006 | 0.996 | 0.998 | 0.519 | 0.998 | 1.003 | 0.516 | 0.652 | 0.652 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 17990.2 ± 1.0% | 0.083 | 1.007 | 1.002 | 1.004 | 0.530 | 1.000 | 1.000 | 0.529 | 0.665 | 0.665 | 0.010 |
| hex: http/html-1kx1024 | 2099200 | 9277.2 ± 16.4% | 0.153 | 1.234 | 1.240 | 1.242 | 0.705 | 1.228 | 0.967 | 0.781 | 0.944 | 0.953 | 0.019 |
| hex: http/html-16kx64 | 2097280 | 17714.6 ± 0.7% | 0.085 | 1.023 | 1.019 | 1.020 | 0.577 | 1.019 | 0.984 | 0.584 | 0.665 | 0.665 | 0.010 |
| hex: http/html-1m | 524290 | 17990.1 ± 1.4% | 0.083 | 1.009 | 1.008 | 1.009 | 0.534 | 1.009 | 1.006 | 0.533 | 0.668 | 0.668 | 0.010 |
| hex: http/json-1kx1024 | 2099200 | 9170.0 ± 17.2% | 0.155 | 1.239 | 1.234 | 1.234 | 0.711 | 1.230 | 0.978 | 0.787 | 0.959 | 0.959 | 0.019 |
| hex: http/json-16kx64 | 2097280 | 17935.5 ± 0.8% | 0.084 | 1.014 | 1.008 | 1.008 | 0.569 | 1.010 | 0.975 | 0.576 | 0.655 | 0.657 | 0.010 |
| hex: http/json-1m | 524290 | 18208.7 ± 1.1% | 0.082 | 1.009 | 1.005 | 1.004 | 0.529 | 0.999 | 1.001 | 0.528 | 0.658 | 0.658 | 0.010 |
| hex: http/js-1kx1024 | 2099200 | 9177.2 ± 15.3% | 0.154 | 1.243 | 1.243 | 1.243 | 0.714 | 1.235 | 0.973 | 0.787 | 0.960 | 0.966 | 0.019 |
| hex: http/js-16kx64 | 2097280 | 17773.9 ± 1.7% | 0.084 | 1.019 | 1.013 | 1.014 | 0.575 | 1.017 | 0.984 | 0.581 | 0.662 | 0.662 | 0.010 |
| hex: http/js-1m | 524290 | 18475.9 ± 1.6% | 0.080 | 1.011 | 0.993 | 0.995 | 0.517 | 1.005 | 0.988 | 0.518 | 0.647 | 0.648 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9084.3 ± 12.3% | 0.156 | 1.252 | 1.247 | 1.255 | 0.716 | 1.252 | 0.979 | 0.794 | 0.966 | 0.970 | 0.019 |
| hex: http/css-16kx64 | 2097280 | 17854.8 ± 1.2% | 0.082 | 1.016 | 1.013 | 1.017 | 0.572 | 1.014 | 0.977 | 0.578 | 0.659 | 0.659 | 0.010 |
| hex: http/css-1m | 524290 | 18231.7 ± 1.6% | 0.081 | 1.012 | 1.006 | 1.009 | 0.529 | 1.007 | 1.008 | 0.528 | 0.659 | 0.659 | 0.010 |
| hex: shuffled/dickens-1m | 524290 | 17663.2 ± 1.0% | 0.084 | 1.001 | 1.006 | 1.009 | 0.533 | 1.006 | 1.007 | 0.534 | 0.678 | 0.677 | 0.010 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1484.1 ± 1.0% | 0.443 | 1.003 | 0.966 | 1.007 | 1.007 | 0.268 | 1.001 | 0.547 | 0.913 | 0.089 | 1.028 |
| qlog records, JSON text sequence | 1467503 | 1276.6 ± 1.9% | 0.688 | 0.971 | 1.003 | 1.008 | 1.006 | 0.263 | 0.996 | 0.499 | 0.824 | 0.105 | 1.014 |
| string: silesia/dickens | 172528 | 6895.1 ± 0.2% | 0.025 | 1.001 | 1.001 | 1.001 | 1.001 | 0.167 | 0.717 | 1.002 | 1.002 | 0.025 | 1.034 |
| string: silesia/nci | 1075110 | 7315.1 ± 0.6% | 0.023 | 1.000 | 0.999 | 1.000 | 1.000 | 0.211 | 0.565 | 0.999 | 1.001 | 0.024 | 1.008 |
| string: silesia/reymont | 1075159 | 3340.4 ± 0.7% | 0.051 | 1.004 | 0.994 | 1.001 | 1.004 | 0.389 | 0.873 | 1.000 | 1.001 | 0.052 | 1.044 |
| string: silesia/samba | 97582 | 4200.0 ± 0.8% | 0.053 | 1.001 | 0.999 | 1.004 | 1.006 | 0.124 | 0.941 | 1.001 | 1.002 | 0.053 | 1.092 |
| string: silesia/webster | 1098490 | 4054.7 ± 0.6% | 0.042 | 1.008 | 1.008 | 1.006 | 1.006 | 0.212 | 0.886 | 0.999 | 1.004 | 0.043 | 1.009 |
| string: silesia/xml | 1090118 | 6109.1 ± 0.7% | 0.029 | 1.006 | 1.000 | 1.005 | 1.007 | 0.254 | 0.776 | 1.001 | 1.000 | 0.029 | 1.021 |
| string: canterbury/alice29.txt | 159425 | 6404.7 ± 1.6% | 0.027 | 1.010 | 1.014 | 1.014 | 1.015 | 0.132 | 0.654 | 1.007 | 1.010 | 0.027 | 1.063 |
| string: canterbury/asyoulik.txt | 132198 | 5609.6 ± 1.5% | 0.030 | 1.026 | 1.032 | 1.033 | 1.034 | 0.129 | 0.596 | 1.004 | 1.014 | 0.030 | 1.044 |
| string: canterbury/lcet10.txt | 441884 | 6237.2 ± 0.6% | 0.027 | 1.003 | 1.008 | 1.006 | 1.008 | 0.185 | 0.800 | 1.002 | 1.004 | 0.028 | 0.996 |
| string: canterbury/plrabn12.txt | 503330 | 5703.0 ± 0.3% | 0.030 | 1.002 | 1.005 | 1.002 | 1.000 | 0.169 | 0.699 | 1.000 | 1.000 | 0.030 | 1.007 |
| string: canterbury-large/E.coli | 1048578 | 19239.0 ± 0.3% | 0.078 | 0.999 | 1.000 | 1.000 | 0.999 | 0.479 | 1.000 | 1.000 | 0.998 | 0.009 | 1.000 |
| string: canterbury-large/bible.txt | 1055886 | 6797.7 ± 0.4% | 0.025 | 0.999 | 1.002 | 1.003 | 1.003 | 0.494 | 0.970 | 0.998 | 0.999 | 0.026 | 1.000 |
| string: canterbury-large/world192.txt | 1103121 | 4030.9 ± 0.5% | 0.042 | 1.018 | 1.016 | 1.017 | 1.016 | 0.193 | 0.830 | 1.000 | 1.006 | 0.043 | 0.999 |
| string: http/html-1m | 1058582 | 6727.8 ± 1.0% | 0.026 | 1.008 | 0.915 | 1.007 | 1.008 | 0.405 | 0.895 | 1.004 | 1.007 | 0.026 | 1.010 |
| string: http/json-1m | 1190272 | 3165.1 ± 0.4% | 0.050 | 1.000 | 0.967 | 0.999 | 1.003 | 0.133 | 0.370 | 1.000 | 1.000 | 0.051 | 1.040 |
| string: http/js-1m | 1144362 | 2747.6 ± 0.4% | 0.060 | 1.005 | 1.014 | 1.005 | 1.008 | 0.166 | 0.843 | 1.005 | 1.008 | 0.061 | 1.024 |
| string: http/css-1m | 1097820 | 3976.9 ± 1.0% | 0.042 | 1.009 | 1.009 | 1.013 | 1.013 | 0.208 | 0.647 | 1.002 | 1.008 | 0.043 | 1.014 |
| string: dickens as Cyrillic and CJK | 1883069 | 3063.6 ± 0.4% | 0.048 | 1.004 | 0.124 | 1.002 | 1.001 | 0.321 | 1.005 | 1.003 | 1.002 | 0.048 | 1.003 |
| hex: silesia/dickens | 524290 | 15662.3 ± 0.2% | 1.003 | 0.177 | 1.002 | 1.001 | 1.001 | 1.001 | 1.001 | 1.002 | 1.002 | 0.177 | 1.002 |
| hex: silesia/mozilla | 524290 | 15677.4 ± 0.1% | 0.999 | 0.178 | 1.001 | 1.000 | 0.999 | 0.998 | 1.000 | 1.000 | 1.001 | 0.178 | 0.999 |
| hex: silesia/mr | 524290 | 15651.9 ± 0.2% | 1.000 | 0.178 | 1.000 | 1.000 | 0.999 | 0.999 | 0.999 | 0.999 | 0.999 | 0.178 | 1.000 |
| hex: silesia/nci | 524290 | 15647.3 ± 0.3% | 1.001 | 0.178 | 0.998 | 0.998 | 1.000 | 0.995 | 0.995 | 0.991 | 0.991 | 0.178 | 0.996 |
| hex: silesia/ooffice | 524290 | 15600.8 ± 0.2% | 1.001 | 0.178 | 1.002 | 1.001 | 1.002 | 0.999 | 0.999 | 0.999 | 0.999 | 0.178 | 1.001 |
| hex: silesia/osdb | 524290 | 15604.8 ± 0.4% | 1.002 | 0.178 | 1.001 | 0.999 | 1.000 | 1.001 | 1.002 | 1.004 | 1.003 | 0.178 | 1.002 |
| hex: silesia/reymont | 524290 | 15585.2 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.000 | 1.001 | 1.002 | 1.002 | 1.002 | 0.178 | 1.001 |
| hex: silesia/samba | 524290 | 15688.0 ± 0.2% | 1.001 | 0.177 | 1.001 | 1.001 | 1.000 | 1.000 | 1.000 | 1.001 | 1.000 | 0.177 | 0.999 |
| hex: silesia/sao | 524290 | 15647.6 ± 0.2% | 1.002 | 0.177 | 1.002 | 1.001 | 1.001 | 1.001 | 1.002 | 1.002 | 1.001 | 0.177 | 1.002 |
| hex: silesia/webster | 524290 | 15656.7 ± 0.4% | 1.003 | 0.177 | 1.002 | 1.001 | 1.000 | 1.001 | 1.002 | 1.000 | 1.001 | 0.177 | 1.002 |
| hex: silesia/x-ray | 524290 | 15630.9 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 1.000 | 0.178 | 1.001 |
| hex: silesia/xml | 524290 | 15638.9 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 0.999 | 0.999 | 0.999 | 0.999 | 0.178 | 0.999 |
| hex: canterbury/alice29.txt | 304180 | 15670.4 ± 0.0% | 1.001 | 0.178 | 1.000 | 1.001 | 1.000 | 0.999 | 0.997 | 0.999 | 0.999 | 0.178 | 1.000 |
| hex: canterbury/asyoulik.txt | 250360 | 15707.8 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15618.7 ± 0.1% | 1.001 | 0.179 | 1.001 | 1.000 | 1.000 | 0.998 | 1.001 | 1.001 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15436.9 ± 0.1% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.995 | 1.001 | 1.002 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14936.9 ± 0.1% | 1.004 | 0.186 | 1.000 | 1.000 | 1.000 | 0.983 | 1.000 | 1.005 | 1.014 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15601.7 ± 0.4% | 1.002 | 0.178 | 0.996 | 0.995 | 0.993 | 0.995 | 0.995 | 0.996 | 0.995 | 0.179 | 0.996 |
| hex: canterbury/lcet10.txt | 524290 | 15625.2 ± 0.2% | 1.000 | 0.178 | 0.999 | 0.999 | 0.998 | 0.994 | 0.995 | 0.992 | 0.994 | 0.177 | 0.995 |
| hex: canterbury/plrabn12.txt | 524290 | 15643.9 ± 0.4% | 1.002 | 0.178 | 0.996 | 0.998 | 0.997 | 0.996 | 0.996 | 0.996 | 0.998 | 0.177 | 0.995 |
| hex: canterbury/ptt5 | 524290 | 15559.1 ± 0.1% | 1.003 | 0.179 | 1.002 | 1.002 | 1.002 | 1.001 | 1.000 | 1.002 | 1.001 | 0.179 | 1.001 |
| hex: canterbury/sum | 76482 | 15640.0 ± 0.0% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 1.002 | 0.178 | 1.000 |
| hex: canterbury/xargs.1 | 8456 | 15003.5 ± 0.1% | 1.002 | 0.185 | 1.001 | 1.000 | 1.000 | 0.985 | 1.001 | 1.003 | 1.013 | 0.183 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 15652.7 ± 0.3% | 1.002 | 0.178 | 0.999 | 1.001 | 1.001 | 0.999 | 0.999 | 1.000 | 1.000 | 0.178 | 1.000 |
| hex: canterbury-large/bible.txt | 524290 | 15627.0 ± 0.4% | 1.003 | 0.178 | 1.002 | 1.002 | 1.001 | 1.000 | 1.001 | 1.001 | 1.000 | 0.178 | 1.001 |
| hex: canterbury-large/world192.txt | 524290 | 15585.1 ± 0.2% | 1.000 | 0.178 | 1.000 | 1.000 | 1.001 | 0.999 | 0.999 | 0.999 | 0.999 | 0.178 | 0.999 |
| hex: http/html-1kx1024 | 2099200 | 13710.7 ± 0.3% | 1.001 | 0.195 | 0.999 | 1.001 | 1.004 | 0.935 | 0.994 | 1.011 | 1.032 | 0.187 | 1.013 |
| hex: http/html-16kx64 | 2097280 | 15229.1 ± 0.3% | 1.000 | 0.181 | 1.001 | 1.001 | 0.999 | 0.992 | 0.998 | 1.003 | 1.002 | 0.180 | 0.999 |
| hex: http/html-1m | 524290 | 15630.3 ± 0.4% | 1.001 | 0.177 | 1.001 | 1.000 | 1.000 | 1.001 | 1.000 | 0.996 | 0.999 | 0.178 | 0.999 |
| hex: http/json-1kx1024 | 2099200 | 13643.6 ± 0.1% | 1.007 | 0.196 | 0.998 | 0.999 | 0.999 | 0.939 | 0.999 | 1.011 | 1.035 | 0.188 | 1.005 |
| hex: http/json-16kx64 | 2097280 | 15227.9 ± 0.5% | 1.001 | 0.181 | 1.003 | 1.001 | 0.998 | 0.993 | 1.000 | 1.005 | 1.005 | 0.181 | 1.001 |
| hex: http/json-1m | 524290 | 15643.3 ± 0.2% | 1.003 | 0.178 | 1.002 | 1.002 | 1.002 | 1.001 | 1.002 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: http/js-1kx1024 | 2099200 | 13601.8 ± 0.3% | 1.007 | 0.196 | 1.007 | 1.002 | 1.001 | 0.945 | 1.002 | 1.014 | 1.035 | 0.188 | 1.023 |
| hex: http/js-16kx64 | 2097280 | 15229.9 ± 4.5% | 1.001 | 0.181 | 0.998 | 1.003 | 1.002 | 0.991 | 1.001 | 0.999 | 1.003 | 0.181 | 1.003 |
| hex: http/js-1m | 524290 | 15631.2 ± 0.3% | 1.000 | 0.177 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 0.996 | 0.996 | 0.177 | 0.999 |
| hex: http/css-1kx1024 | 2099200 | 13655.7 ± 0.5% | 1.006 | 0.196 | 0.997 | 0.999 | 1.000 | 0.938 | 0.999 | 1.009 | 1.034 | 0.188 | 1.013 |
| hex: http/css-16kx64 | 2097280 | 15220.4 ± 0.4% | 1.001 | 0.181 | 1.001 | 1.002 | 1.004 | 0.992 | 0.997 | 1.003 | 1.005 | 0.181 | 1.000 |
| hex: http/css-1m | 524290 | 15653.0 ± 0.4% | 1.001 | 0.177 | 1.002 | 1.001 | 1.002 | 1.001 | 1.001 | 1.001 | 1.003 | 0.177 | 1.003 |
| hex: shuffled/dickens-1m | 524290 | 15682.5 ± 0.4% | 0.998 | 0.178 | 0.997 | 0.998 | 0.995 | 0.996 | 0.995 | 0.995 | 0.995 | 0.177 | 0.995 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.054 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.057 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.234 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.240 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.242 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.228 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.239 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.234 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.234 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.230 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.243 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.243 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.243 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.235 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.252 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.247 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.255 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.252 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43378.0 ± 0.2% | 47416.6 ± 0.1% | 0.915 | — | — |
| string: silesia/nci | 1048576 | 34521.0 ± 3.0% | 37345.1 ± 4.0% | 0.924 | — | — |
| string: silesia/reymont | 1048576 | 33656.2 ± 2.9% | 36409.1 ± 1.7% | 0.924 | — | — |
| string: silesia/samba | 65546 | 43543.8 ± 0.0% | 48470.6 ± 0.0% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 34707.1 ± 1.5% | 37875.7 ± 1.9% | 0.916 | — | — |
| string: silesia/xml | 1048576 | 31989.4 ± 2.8% | 32955.5 ± 1.2% | 0.971 | — | — |
| string: canterbury/alice29.txt | 152089 | 35910.4 ± 0.1% | 36548.7 ± 0.1% | 0.983 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43357.8 ± 0.0% | 47679.8 ± 0.0% | 0.909 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36131.9 ± 0.0% | 36757.0 ± 0.0% | 0.983 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 43524.6 ± 0.2% | 47599.9 ± 0.1% | 0.914 | — | — |
| string: canterbury-large/E.coli | 1048576 | 35722.1 ± 3.6% | 37944.3 ± 3.5% | 0.941 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 30719.2 ± 2.8% | 32071.7 ± 3.0% | 0.958 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 31409.2 ± 2.0% | 32394.1 ± 1.3% | 0.970 | — | — |
| string: http/html-1m | 1048576 | 33449.2 ± 4.3% | 35833.0 ± 3.0% | 0.933 | — | — |
| string: http/json-1m | 1048576 | 29169.5 ± 7.5% | 30852.2 ± 6.2% | 0.945 | — | — |
| string: http/js-1m | 1048576 | 33988.3 ± 3.4% | 36209.5 ± 3.8% | 0.939 | — | — |
| string: http/css-1m | 1048576 | 34386.4 ± 3.5% | 36545.4 ± 3.9% | 0.941 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5766.6 ± 0.2% | 5651.4 ± 0.2% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.915 of simdutf.
- string: silesia/nci: stdx runs at 0.924 of simdutf.
- string: silesia/reymont: stdx runs at 0.924 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.916 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.909 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.914 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.941 of simdutf.
- string: http/html-1m: stdx runs at 0.933 of simdutf.
- string: http/js-1m: stdx runs at 0.939 of simdutf.
- string: http/css-1m: stdx runs at 0.941 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 38043.2 ± 3.7% | 41693.0 ± 5.2% | 0.912 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 33251.2 ± 3.1% | 34385.3 ± 3.1% | 0.967 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 36086.3 ± 2.6% | 38765.6 ± 4.0% | 0.931 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 36833.0 ± 2.0% | 40272.4 ± 2.9% | 0.915 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 36948.1 ± 3.5% | 40562.2 ± 3.3% | 0.911 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 36820.0 ± 3.0% | 40262.6 ± 2.9% | 0.914 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5760.0 ± 0.1% | 5643.0 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5749.2 ± 0.2% | 5642.3 ± 0.1% | 1.019 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5760.1 ± 0.2% | 5650.5 ± 0.3% | 1.019 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5762.0 ± 0.1% | 5646.8 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5759.7 ± 0.6% | 5646.7 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5764.7 ± 0.3% | 5647.0 ± 0.3% | 1.021 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1129.7 ± 0.3% | 928.9 ± 0.4% | 1023.5 ± 0.4% | 300.5 ± 0.5% | 664.4 ± 0.2% | 310.2 ± 1.8% | 1.216 | 1.104 | 3.760 | 1.700 | 3.641 |
| qlog records, JSON text sequence | 1467503 | 836.4 ± 1.2% | 817.9 ± 0.2% | 788.6 ± 1.0% | 244.3 ± 0.8% | 681.3 ± 0.8% | 250.3 ± 0.1% | 1.023 | 1.061 | 3.423 | 1.228 | 3.342 |
| string: silesia/dickens | 172528 | 5040.3 ± 0.3% | 1876.6 ± 0.2% | 2647.6 ± 0.7% | 361.5 ± 0.8% | 2864.3 ± 0.4% | 552.1 ± 1.5% | 2.686 | 1.904 | 13.944 | 1.760 | 9.129 |
| string: silesia/nci | 1075110 | 4313.3 ± 1.1% | 2236.4 ± 0.6% | 2988.5 ± 0.4% | 546.0 ± 0.5% | 2995.5 ± 1.7% | 605.1 ± 2.6% | 1.929 | 1.443 | 7.901 | 1.440 | 7.128 |
| string: silesia/reymont | 1075159 | 2936.9 ± 1.6% | 1817.5 ± 0.9% | 2060.6 ± 0.2% | 373.4 ± 1.1% | 2140.3 ± 0.1% | 535.1 ± 0.5% | 1.616 | 1.425 | 7.866 | 1.372 | 5.489 |
| string: silesia/samba | 97582 | 3494.6 ± 0.4% | 2026.6 ± 0.3% | 2615.6 ± 0.2% | 329.1 ± 0.6% | 1501.0 ± 0.6% | 429.4 ± 1.5% | 1.724 | 1.336 | 10.619 | 2.328 | 8.138 |
| string: silesia/webster | 1098490 | 3642.4 ± 1.3% | 1518.1 ± 0.2% | 2011.3 ± 1.0% | 359.4 ± 0.5% | 2163.5 ± 0.9% | 495.8 ± 2.5% | 2.399 | 1.811 | 10.133 | 1.684 | 7.347 |
| string: silesia/xml | 1090118 | 4762.9 ± 0.7% | 2355.2 ± 0.4% | 2524.5 ± 0.1% | 453.1 ± 1.0% | 2845.9 ± 1.1% | 562.6 ± 1.0% | 2.022 | 1.887 | 10.512 | 1.674 | 8.466 |
| string: canterbury/alice29.txt | 159425 | 4306.1 ± 0.5% | 1600.1 ± 0.3% | 2461.0 ± 0.6% | 342.1 ± 0.4% | 2501.7 ± 0.8% | 505.2 ± 1.3% | 2.691 | 1.750 | 12.586 | 1.721 | 8.523 |
| string: canterbury/asyoulik.txt | 132198 | 3447.5 ± 1.0% | 1458.2 ± 0.3% | 2224.5 ± 0.4% | 336.1 ± 0.6% | 2080.4 ± 0.3% | 459.4 ± 1.1% | 2.364 | 1.550 | 10.257 | 1.657 | 7.505 |
| string: canterbury/lcet10.txt | 441884 | 5063.7 ± 0.5% | 1850.7 ± 0.3% | 2324.6 ± 1.8% | 390.7 ± 0.6% | 2840.4 ± 0.8% | 537.9 ± 2.2% | 2.736 | 2.178 | 12.961 | 1.783 | 9.414 |
| string: canterbury/plrabn12.txt | 503330 | 4100.2 ± 0.9% | 1736.1 ± 0.2% | 2059.8 ± 0.6% | 360.0 ± 0.6% | 2491.7 ± 1.0% | 499.1 ± 2.3% | 2.362 | 1.991 | 11.390 | 1.646 | 8.215 |
| string: canterbury-large/E.coli | 1048578 | 19201.0 ± 0.6% | 3602.4 ± 0.3% | 3252.6 ± 0.3% | 929.9 ± 0.7% | 5914.9 ± 1.0% | 758.0 ± 1.7% | 5.330 | 5.903 | 20.648 | 3.246 | 25.330 |
| string: canterbury-large/bible.txt | 1055886 | 6711.3 ± 1.1% | 2938.3 ± 0.6% | 2833.2 ± 0.5% | 422.2 ± 1.5% | 3737.9 ± 2.7% | 612.4 ± 1.5% | 2.284 | 2.369 | 15.895 | 1.795 | 10.958 |
| string: canterbury-large/world192.txt | 1103121 | 3392.5 ± 0.4% | 1481.0 ± 0.2% | 2011.5 ± 0.4% | 353.2 ± 0.3% | 2108.8 ± 0.7% | 500.4 ± 0.5% | 2.291 | 1.687 | 9.604 | 1.609 | 6.779 |
| string: http/html-1m | 1058582 | 6055.9 ± 2.3% | 2742.9 ± 0.4% | 2704.2 ± 1.0% | 442.1 ± 0.6% | 3462.9 ± 0.6% | 598.9 ± 0.6% | 2.208 | 2.239 | 13.698 | 1.749 | 10.112 |
| string: http/json-1m | 1190272 | 2546.8 ± 0.4% | 877.6 ± 0.1% | 2244.6 ± 0.4% | 391.4 ± 0.2% | 1060.4 ± 0.4% | 442.4 ± 0.4% | 2.902 | 1.135 | 6.507 | 2.402 | 5.756 |
| string: http/js-1m | 1144362 | 2280.6 ± 0.6% | 1028.4 ± 0.1% | 1634.3 ± 0.2% | 321.1 ± 0.2% | 1520.2 ± 0.5% | 418.5 ± 0.6% | 2.218 | 1.395 | 7.103 | 1.500 | 5.449 |
| string: http/css-1m | 1097820 | 2638.4 ± 0.5% | 1677.8 ± 0.2% | 2226.1 ± 0.6% | 406.0 ± 1.0% | 1946.2 ± 1.0% | 489.6 ± 1.0% | 1.573 | 1.185 | 6.498 | 1.356 | 5.389 |
| string: dickens as Cyrillic and CJK | 1883069 | 3068.6 ± 0.5% | 1682.6 ± 0.3% | 893.3 ± 0.8% | 350.4 ± 0.2% | 666.2 ± 0.9% | 157.8 ± 2.0% | 1.824 | 3.435 | 8.757 | 4.606 | 19.441 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.3 ± 1.3% | 980.9 ± 0.2% | 1207.8 ± 0.5% | 216.2 ± 0.2% | 471.1 ± 0.4% | 253.2 ± 3.9% | 1.355 | 1.101 | 6.148 | 2.822 | 5.251 |
| hex: silesia/dickens | 524290 | 18502.7 ± 0.7% | 3614.4 ± 0.1% | 3303.4 ± 0.3% | 505.7 ± 2.9% | 6112.9 ± 2.6% | 782.1 ± 2.9% | 5.119 | 5.601 | 36.588 | 3.027 | 23.659 |
| hex: silesia/mozilla | 524290 | 18401.1 ± 2.4% | 3612.2 ± 0.2% | 3288.6 ± 0.4% | 442.6 ± 1.1% | 5960.5 ± 0.7% | 784.7 ± 0.6% | 5.094 | 5.595 | 41.577 | 3.087 | 23.450 |
| hex: silesia/mr | 524290 | 18048.5 ± 0.5% | 3611.7 ± 0.6% | 3293.6 ± 0.3% | 566.1 ± 7.3% | 6084.6 ± 1.5% | 784.2 ± 0.6% | 4.997 | 5.480 | 31.882 | 2.966 | 23.016 |
| hex: silesia/nci | 524290 | 18865.4 ± 1.1% | 3610.4 ± 0.3% | 3281.7 ± 0.3% | 604.9 ± 4.4% | 6016.0 ± 1.2% | 782.8 ± 0.2% | 5.225 | 5.749 | 31.190 | 3.136 | 24.100 |
| hex: silesia/ooffice | 524290 | 18680.8 ± 1.5% | 3612.3 ± 0.3% | 3291.1 ± 0.4% | 392.1 ± 0.6% | 6113.2 ± 1.7% | 782.7 ± 0.3% | 5.171 | 5.676 | 47.645 | 3.056 | 23.867 |
| hex: silesia/osdb | 524290 | 18188.9 ± 0.5% | 3614.3 ± 0.2% | 3284.4 ± 0.4% | 478.4 ± 3.6% | 6129.0 ± 2.5% | 784.0 ± 0.6% | 5.032 | 5.538 | 38.021 | 2.968 | 23.201 |
| hex: silesia/reymont | 524290 | 18405.6 ± 0.6% | 3615.0 ± 0.3% | 3297.4 ± 0.2% | 509.8 ± 0.5% | 6026.6 ± 0.7% | 783.4 ± 0.6% | 5.092 | 5.582 | 36.105 | 3.054 | 23.496 |
| hex: silesia/samba | 524290 | 17647.1 ± 0.8% | 3611.2 ± 0.3% | 3280.6 ± 0.3% | 400.6 ± 3.0% | 5964.6 ± 0.8% | 782.8 ± 0.2% | 4.887 | 5.379 | 44.047 | 2.959 | 22.543 |
| hex: silesia/sao | 524290 | 18478.0 ± 1.0% | 3612.2 ± 0.2% | 3287.0 ± 0.3% | 335.2 ± 0.8% | 5986.2 ± 0.7% | 782.0 ± 0.3% | 5.115 | 5.621 | 55.120 | 3.087 | 23.629 |
| hex: silesia/webster | 524290 | 18490.9 ± 0.5% | 3612.9 ± 0.3% | 3292.4 ± 0.5% | 467.1 ± 1.0% | 6087.0 ± 1.4% | 785.4 ± 0.3% | 5.118 | 5.616 | 39.590 | 3.038 | 23.543 |
| hex: silesia/x-ray | 524290 | 18333.1 ± 0.9% | 3616.6 ± 0.2% | 3287.7 ± 0.3% | 476.6 ± 2.4% | 6093.4 ± 1.4% | 783.3 ± 0.5% | 5.069 | 5.576 | 38.467 | 3.009 | 23.405 |
| hex: silesia/xml | 524290 | 18584.9 ± 1.8% | 3613.4 ± 0.3% | 3294.9 ± 0.3% | 523.1 ± 3.4% | 6094.9 ± 0.4% | 785.0 ± 0.3% | 5.143 | 5.640 | 35.529 | 3.049 | 23.674 |
| hex: canterbury/alice29.txt | 304180 | 19524.6 ± 0.1% | 3633.5 ± 0.1% | 3370.1 ± 0.1% | 507.7 ± 2.0% | 6078.3 ± 0.5% | 785.0 ± 0.2% | 5.374 | 5.794 | 38.457 | 3.212 | 24.872 |
| hex: canterbury/asyoulik.txt | 250360 | 19526.8 ± 0.4% | 3636.3 ± 0.0% | 3359.5 ± 0.1% | 500.3 ± 2.0% | 6106.0 ± 1.5% | 780.9 ± 0.3% | 5.370 | 5.812 | 39.032 | 3.198 | 25.006 |
| hex: canterbury/cp.html | 49208 | 19230.6 ± 0.5% | 3638.4 ± 0.1% | 3280.4 ± 0.2% | 465.0 ± 1.7% | 6266.7 ± 0.6% | 771.7 ± 0.7% | 5.285 | 5.862 | 41.357 | 3.069 | 24.921 |
| hex: canterbury/fields.c | 22302 | 18823.1 ± 0.9% | 3629.2 ± 0.0% | 3356.6 ± 0.2% | 497.7 ± 1.6% | 6253.1 ± 0.6% | 762.6 ± 1.6% | 5.187 | 5.608 | 37.824 | 3.010 | 24.682 |
| hex: canterbury/grammar.lsp | 7444 | 17262.5 ± 1.6% | 3601.4 ± 0.0% | 3357.9 ± 0.4% | 539.5 ± 5.2% | 6167.2 ± 0.8% | 732.9 ± 1.8% | 4.793 | 5.141 | 31.999 | 2.799 | 23.555 |
| hex: canterbury/kennedy.xls | 524290 | 18153.2 ± 0.9% | 3608.6 ± 0.3% | 3287.6 ± 0.3% | 670.6 ± 1.9% | 6064.5 ± 0.9% | 766.0 ± 5.5% | 5.031 | 5.522 | 27.071 | 2.993 | 23.699 |
| hex: canterbury/lcet10.txt | 524290 | 18137.2 ± 0.8% | 3605.2 ± 0.5% | 3303.5 ± 0.6% | 527.4 ± 1.0% | 6129.4 ± 2.5% | 783.5 ± 0.8% | 5.031 | 5.490 | 34.388 | 2.959 | 23.148 |
| hex: canterbury/plrabn12.txt | 524290 | 18215.6 ± 1.3% | 3610.0 ± 0.2% | 3295.6 ± 0.3% | 517.6 ± 0.2% | 6125.3 ± 0.5% | 782.7 ± 0.6% | 5.046 | 5.527 | 35.189 | 2.974 | 23.272 |
| hex: canterbury/ptt5 | 524290 | 18121.8 ± 0.7% | 3609.8 ± 0.2% | 3289.0 ± 0.2% | 559.2 ± 2.4% | 6094.2 ± 1.5% | 783.6 ± 1.1% | 5.020 | 5.510 | 32.409 | 2.974 | 23.125 |
| hex: canterbury/sum | 76482 | 19276.7 ± 0.1% | 3634.4 ± 0.0% | 3354.9 ± 0.3% | 508.9 ± 0.4% | 6177.2 ± 0.7% | 775.4 ± 0.8% | 5.304 | 5.746 | 37.878 | 3.121 | 24.860 |
| hex: canterbury/xargs.1 | 8456 | 17625.2 ± 0.7% | 3601.4 ± 0.2% | 3380.8 ± 0.5% | 491.3 ± 1.9% | 6153.0 ± 0.4% | 756.3 ± 0.5% | 4.894 | 5.213 | 35.872 | 2.864 | 23.305 |
| hex: canterbury-large/E.coli | 524290 | 18730.0 ± 1.0% | 3607.1 ± 0.3% | 3285.0 ± 0.3% | 688.7 ± 0.1% | 6043.6 ± 1.4% | 774.5 ± 6.9% | 5.193 | 5.702 | 27.197 | 3.099 | 24.182 |
| hex: canterbury-large/bible.txt | 524290 | 18340.6 ± 1.0% | 3607.2 ± 0.6% | 3291.4 ± 0.3% | 531.1 ± 2.6% | 6026.4 ± 0.8% | 779.3 ± 0.7% | 5.084 | 5.572 | 34.533 | 3.043 | 23.535 |
| hex: canterbury-large/world192.txt | 524290 | 17990.2 ± 1.0% | 3610.0 ± 0.4% | 3284.6 ± 0.6% | 494.2 ± 2.1% | 6064.5 ± 0.6% | 770.5 ± 1.9% | 4.983 | 5.477 | 36.400 | 2.966 | 23.349 |
| hex: http/html-1kx1024 | 2099200 | 9277.2 ± 16.4% | 3458.3 ± 0.2% | 2856.0 ± 0.5% | 477.1 ± 0.9% | 5115.8 ± 0.3% | 646.7 ± 2.5% | 2.683 | 3.248 | 19.446 | 1.813 | 14.345 |
| hex: http/html-16kx64 | 2097280 | 17714.6 ± 0.7% | 3608.2 ± 0.1% | 3262.5 ± 0.3% | 478.6 ± 1.0% | 6030.6 ± 1.1% | 757.1 ± 1.3% | 4.910 | 5.430 | 37.012 | 2.937 | 23.397 |
| hex: http/html-1m | 524290 | 17990.1 ± 1.4% | 3612.3 ± 0.2% | 3287.9 ± 0.3% | 500.6 ± 1.2% | 6127.0 ± 1.1% | 774.5 ± 3.2% | 4.980 | 5.472 | 35.936 | 2.936 | 23.227 |
| hex: http/json-1kx1024 | 2099200 | 9170.0 ± 17.2% | 3459.6 ± 0.2% | 2854.0 ± 0.2% | 575.0 ± 0.8% | 5108.2 ± 0.9% | 643.2 ± 1.4% | 2.651 | 3.213 | 15.948 | 1.795 | 14.257 |
| hex: http/json-16kx64 | 2097280 | 17935.5 ± 0.8% | 3608.0 ± 0.1% | 3253.7 ± 0.3% | 572.2 ± 2.5% | 6026.1 ± 0.2% | 750.3 ± 2.1% | 4.971 | 5.512 | 31.344 | 2.976 | 23.903 |
| hex: http/json-1m | 524290 | 18208.7 ± 1.1% | 3614.1 ± 0.2% | 3294.4 ± 0.1% | 589.3 ± 1.1% | 6125.9 ± 1.9% | 764.4 ± 3.6% | 5.038 | 5.527 | 30.898 | 2.972 | 23.820 |
| hex: http/js-1kx1024 | 2099200 | 9177.2 ± 15.3% | 3461.6 ± 0.1% | 2857.1 ± 0.4% | 481.1 ± 0.7% | 5131.3 ± 0.8% | 641.9 ± 4.1% | 2.651 | 3.212 | 19.077 | 1.788 | 14.296 |
| hex: http/js-16kx64 | 2097280 | 17773.9 ± 1.7% | 3609.0 ± 0.2% | 3262.2 ± 0.3% | 479.6 ± 0.4% | 6028.5 ± 0.5% | 755.3 ± 2.6% | 4.925 | 5.448 | 37.058 | 2.948 | 23.532 |
| hex: http/js-1m | 524290 | 18475.9 ± 1.6% | 3619.8 ± 0.2% | 3285.4 ± 0.5% | 502.6 ± 0.9% | 6061.4 ± 1.0% | 760.6 ± 2.5% | 5.104 | 5.624 | 36.762 | 3.048 | 24.291 |
| hex: http/css-1kx1024 | 2099200 | 9084.3 ± 12.3% | 3459.1 ± 0.3% | 2854.1 ± 0.5% | 488.6 ± 0.7% | 5125.2 ± 0.5% | 630.7 ± 2.8% | 2.626 | 3.183 | 18.592 | 1.772 | 14.404 |
| hex: http/css-16kx64 | 2097280 | 17854.8 ± 1.2% | 3610.3 ± 0.1% | 3257.8 ± 0.3% | 493.6 ± 0.3% | 6011.8 ± 0.6% | 743.3 ± 2.1% | 4.946 | 5.481 | 36.175 | 2.970 | 24.021 |
| hex: http/css-1m | 524290 | 18231.7 ± 1.6% | 3611.4 ± 0.2% | 3297.6 ± 0.2% | 501.4 ± 2.0% | 6085.5 ± 0.6% | 743.7 ± 2.3% | 5.048 | 5.529 | 36.359 | 2.996 | 24.515 |
| hex: shuffled/dickens-1m | 524290 | 17663.2 ± 1.0% | 3612.5 ± 0.1% | 3288.5 ± 0.2% | 526.3 ± 0.2% | 6093.2 ± 1.3% | 758.4 ± 2.9% | 4.890 | 5.371 | 33.559 | 2.899 | 23.291 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1484.1 ± 1.0% | 1252.3 ± 0.4% | 1040.7 ± 1.0% | 409.8 ± 0.8% | 448.1 ± 0.1% | 414.7 ± 0.4% | 1.185 | 1.426 | 3.621 | 3.312 | 3.579 |
| qlog records, JSON text sequence | 1467503 | 1276.6 ± 1.9% | 1063.6 ± 0.2% | 778.0 ± 0.6% | 378.3 ± 1.4% | 467.4 ± 0.2% | 278.7 ± 0.6% | 1.200 | 1.641 | 3.374 | 2.731 | 4.580 |
| string: silesia/dickens | 172528 | 6895.1 ± 0.2% | 2820.5 ± 0.5% | 2920.8 ± 0.7% | 429.4 ± 0.5% | 1570.5 ± 0.1% | 1011.9 ± 0.1% | 2.445 | 2.361 | 16.059 | 4.390 | 6.814 |
| string: silesia/nci | 1075110 | 7315.1 ± 0.6% | 3437.2 ± 0.8% | 3098.1 ± 0.4% | 816.2 ± 0.8% | 1851.9 ± 0.2% | 1111.1 ± 0.3% | 2.128 | 2.361 | 8.962 | 3.950 | 6.584 |
| string: silesia/reymont | 1075159 | 3340.4 ± 0.7% | 1979.5 ± 0.5% | 2061.8 ± 0.5% | 449.7 ± 1.2% | 1510.4 ± 0.4% | 948.7 ± 0.8% | 1.688 | 1.620 | 7.428 | 2.212 | 3.521 |
| string: silesia/samba | 97582 | 4200.0 ± 0.8% | 2111.0 ± 1.7% | 3448.6 ± 0.2% | 353.5 ± 1.0% | 1434.6 ± 0.5% | 1054.5 ± 0.3% | 1.990 | 1.218 | 11.880 | 2.928 | 3.983 |
| string: silesia/webster | 1098490 | 4054.7 ± 0.6% | 1885.3 ± 0.4% | 2052.8 ± 0.2% | 440.1 ± 0.6% | 1387.1 ± 0.1% | 645.1 ± 0.3% | 2.151 | 1.975 | 9.214 | 2.923 | 6.285 |
| string: silesia/xml | 1090118 | 6109.1 ± 0.7% | 2875.1 ± 0.5% | 2648.2 ± 0.3% | 609.0 ± 0.3% | 1746.4 ± 0.3% | 919.1 ± 1.0% | 2.125 | 2.307 | 10.031 | 3.498 | 6.647 |
| string: canterbury/alice29.txt | 159425 | 6404.7 ± 1.6% | 2196.5 ± 0.5% | 2760.1 ± 0.5% | 407.8 ± 0.6% | 1463.6 ± 0.2% | 955.2 ± 0.1% | 2.916 | 2.320 | 15.704 | 4.376 | 6.705 |
| string: canterbury/asyoulik.txt | 132198 | 5609.6 ± 1.5% | 1713.3 ± 0.5% | 2371.8 ± 1.1% | 401.8 ± 0.6% | 1335.1 ± 0.5% | 886.3 ± 0.2% | 3.274 | 2.365 | 13.960 | 4.202 | 6.329 |
| string: canterbury/lcet10.txt | 441884 | 6237.2 ± 0.6% | 2553.6 ± 0.5% | 2503.2 ± 2.1% | 467.9 ± 0.5% | 1522.1 ± 0.3% | 984.1 ± 0.6% | 2.443 | 2.492 | 13.331 | 4.098 | 6.338 |
| string: canterbury/plrabn12.txt | 503330 | 5703.0 ± 0.3% | 2049.2 ± 0.2% | 2067.2 ± 0.3% | 422.8 ± 0.9% | 1405.3 ± 0.2% | 933.9 ± 0.3% | 2.783 | 2.759 | 13.490 | 4.058 | 6.106 |
| string: canterbury-large/E.coli | 1048578 | 19239.0 ± 0.3% | 9646.1 ± 1.1% | 3786.8 ± 0.4% | 1477.4 ± 0.5% | 2358.6 ± 0.5% | 1195.3 ± 0.5% | 1.994 | 5.081 | 13.022 | 8.157 | 16.095 |
| string: canterbury-large/bible.txt | 1055886 | 6797.7 ± 0.4% | 4122.3 ± 1.2% | 3061.2 ± 1.2% | 500.9 ± 0.5% | 1977.4 ± 0.6% | 1117.2 ± 0.7% | 1.649 | 2.221 | 13.572 | 3.438 | 6.084 |
| string: canterbury-large/world192.txt | 1103121 | 4030.9 ± 0.5% | 1654.8 ± 0.6% | 1991.5 ± 1.0% | 448.8 ± 0.9% | 1356.7 ± 0.2% | 906.3 ± 0.6% | 2.436 | 2.024 | 8.981 | 2.971 | 4.448 |
| string: http/html-1m | 1058582 | 6727.8 ± 1.0% | 3972.6 ± 0.7% | 3037.6 ± 0.5% | 500.4 ± 0.9% | 1929.8 ± 0.5% | 805.7 ± 0.3% | 1.694 | 2.215 | 13.444 | 3.486 | 8.350 |
| string: http/json-1m | 1190272 | 3165.1 ± 0.4% | 1350.3 ± 0.2% | 1555.0 ± 0.3% | 444.8 ± 0.6% | 962.2 ± 0.3% | 765.3 ± 1.0% | 2.344 | 2.036 | 7.116 | 3.289 | 4.136 |
| string: http/js-1m | 1144362 | 2747.6 ± 0.4% | 1180.3 ± 0.5% | 1625.5 ± 0.5% | 369.1 ± 0.5% | 1093.8 ± 0.2% | 758.4 ± 0.7% | 2.328 | 1.690 | 7.445 | 2.512 | 3.623 |
| string: http/css-1m | 1097820 | 3976.9 ± 1.0% | 1488.0 ± 0.6% | 2147.6 ± 0.9% | 494.7 ± 0.2% | 1369.4 ± 0.3% | 895.7 ± 0.5% | 2.673 | 1.852 | 8.038 | 2.904 | 4.440 |
| string: dickens as Cyrillic and CJK | 1883069 | 3063.6 ± 0.4% | 2339.8 ± 0.5% | 521.7 ± 0.6% | 306.3 ± 1.2% | 564.2 ± 0.7% | 336.2 ± 0.2% | 1.309 | 5.872 | 10.001 | 5.430 | 9.113 |
| hex: silesia/dickens | 524290 | 15662.3 ± 0.2% | 1460.1 ± 0.4% | 1082.4 ± 0.3% | 491.7 ± 1.9% | 991.4 ± 0.2% | 731.4 ± 0.5% | 10.727 | 14.470 | 31.857 | 15.798 | 21.414 |
| hex: silesia/mozilla | 524290 | 15677.4 ± 0.1% | 1470.3 ± 0.4% | 1087.7 ± 0.3% | 441.6 ± 0.6% | 991.5 ± 0.3% | 735.2 ± 0.5% | 10.662 | 14.413 | 35.505 | 15.811 | 21.323 |
| hex: silesia/mr | 524290 | 15651.9 ± 0.2% | 1482.3 ± 0.3% | 1091.9 ± 0.4% | 545.9 ± 3.4% | 993.0 ± 0.3% | 733.3 ± 0.5% | 10.560 | 14.334 | 28.673 | 15.762 | 21.345 |
| hex: silesia/nci | 524290 | 15647.3 ± 0.3% | 1470.9 ± 0.6% | 1088.0 ± 0.7% | 632.0 ± 4.5% | 987.9 ± 0.7% | 734.6 ± 0.5% | 10.638 | 14.382 | 24.758 | 15.839 | 21.300 |
| hex: silesia/ooffice | 524290 | 15600.8 ± 0.2% | 1463.8 ± 0.2% | 1082.6 ± 0.3% | 389.3 ± 0.4% | 989.9 ± 0.6% | 733.8 ± 0.4% | 10.658 | 14.410 | 40.074 | 15.759 | 21.261 |
| hex: silesia/osdb | 524290 | 15604.8 ± 0.4% | 1467.8 ± 0.2% | 1085.2 ± 0.4% | 466.9 ± 1.0% | 990.8 ± 0.4% | 735.0 ± 0.5% | 10.631 | 14.380 | 33.418 | 15.750 | 21.232 |
| hex: silesia/reymont | 524290 | 15585.2 ± 0.1% | 1461.1 ± 0.5% | 1082.2 ± 0.3% | 514.8 ± 0.8% | 988.2 ± 0.8% | 732.6 ± 0.4% | 10.667 | 14.401 | 30.273 | 15.771 | 21.275 |
| hex: silesia/samba | 524290 | 15688.0 ± 0.2% | 1466.0 ± 0.3% | 1085.4 ± 0.2% | 403.4 ± 0.7% | 985.8 ± 0.5% | 733.7 ± 0.5% | 10.701 | 14.454 | 38.887 | 15.913 | 21.383 |
| hex: silesia/sao | 524290 | 15647.6 ± 0.2% | 1462.3 ± 0.5% | 1082.8 ± 0.4% | 332.3 ± 1.0% | 985.7 ± 0.7% | 731.8 ± 0.7% | 10.700 | 14.451 | 47.091 | 15.875 | 21.383 |
| hex: silesia/webster | 524290 | 15656.7 ± 0.4% | 1464.7 ± 0.4% | 1083.8 ± 0.2% | 473.5 ± 0.7% | 989.3 ± 0.5% | 734.3 ± 0.3% | 10.689 | 14.446 | 33.063 | 15.825 | 21.323 |
| hex: silesia/x-ray | 524290 | 15630.9 ± 0.2% | 1475.5 ± 0.4% | 1089.6 ± 0.3% | 445.1 ± 1.1% | 992.7 ± 0.9% | 734.5 ± 0.3% | 10.593 | 14.345 | 35.117 | 15.746 | 21.281 |
| hex: silesia/xml | 524290 | 15638.9 ± 0.2% | 1465.5 ± 0.4% | 1086.9 ± 0.3% | 610.2 ± 1.1% | 991.8 ± 0.4% | 734.4 ± 0.4% | 10.671 | 14.388 | 25.630 | 15.768 | 21.294 |
| hex: canterbury/alice29.txt | 304180 | 15670.4 ± 0.0% | 1466.1 ± 0.8% | 1092.6 ± 0.1% | 505.6 ± 1.2% | 991.5 ± 0.4% | 734.9 ± 0.9% | 10.689 | 14.342 | 30.992 | 15.804 | 21.322 |
| hex: canterbury/asyoulik.txt | 250360 | 15707.8 ± 0.1% | 1468.7 ± 0.4% | 1092.9 ± 0.2% | 498.6 ± 1.0% | 997.8 ± 0.4% | 740.3 ± 0.4% | 10.695 | 14.373 | 31.505 | 15.743 | 21.218 |
| hex: canterbury/cp.html | 49208 | 15618.7 ± 0.1% | 1479.6 ± 0.4% | 1096.6 ± 0.1% | 533.8 ± 1.6% | 1000.7 ± 0.4% | 743.9 ± 0.2% | 10.556 | 14.243 | 29.260 | 15.607 | 20.995 |
| hex: canterbury/fields.c | 22302 | 15436.9 ± 0.1% | 1413.8 ± 0.7% | 1063.9 ± 0.5% | 614.0 ± 5.6% | 995.3 ± 0.1% | 737.4 ± 0.2% | 10.918 | 14.510 | 25.143 | 15.509 | 20.935 |
| hex: canterbury/grammar.lsp | 7444 | 14936.9 ± 0.1% | 1508.6 ± 0.2% | 1087.9 ± 0.4% | 663.0 ± 3.7% | 996.9 ± 0.3% | 725.9 ± 0.1% | 9.901 | 13.730 | 22.530 | 14.984 | 20.578 |
| hex: canterbury/kennedy.xls | 524290 | 15601.7 ± 0.4% | 1472.0 ± 0.2% | 1088.3 ± 0.4% | 659.2 ± 1.2% | 988.9 ± 0.2% | 733.7 ± 0.5% | 10.599 | 14.335 | 23.668 | 15.777 | 21.263 |
| hex: canterbury/lcet10.txt | 524290 | 15625.2 ± 0.2% | 1461.1 ± 0.2% | 1082.4 ± 0.3% | 495.5 ± 1.9% | 992.8 ± 0.6% | 734.6 ± 0.4% | 10.694 | 14.436 | 31.536 | 15.738 | 21.269 |
| hex: canterbury/plrabn12.txt | 524290 | 15643.9 ± 0.4% | 1461.6 ± 0.5% | 1082.0 ± 0.5% | 489.0 ± 2.5% | 984.7 ± 0.3% | 733.2 ± 0.7% | 10.703 | 14.459 | 31.994 | 15.887 | 21.336 |
| hex: canterbury/ptt5 | 524290 | 15559.1 ± 0.1% | 1477.2 ± 0.2% | 1092.4 ± 0.3% | 553.7 ± 0.5% | 991.3 ± 0.6% | 734.1 ± 0.5% | 10.533 | 14.243 | 28.099 | 15.696 | 21.196 |
| hex: canterbury/sum | 76482 | 15640.0 ± 0.0% | 1494.9 ± 0.2% | 1103.6 ± 0.1% | 584.1 ± 1.2% | 998.3 ± 0.0% | 744.7 ± 0.2% | 10.463 | 14.171 | 26.775 | 15.667 | 21.001 |
| hex: canterbury/xargs.1 | 8456 | 15003.5 ± 0.1% | 1492.5 ± 0.4% | 1076.3 ± 0.4% | 658.7 ± 4.4% | 1003.0 ± 0.1% | 727.9 ± 0.1% | 10.053 | 13.940 | 22.776 | 14.959 | 20.611 |
| hex: canterbury-large/E.coli | 524290 | 15652.7 ± 0.3% | 1465.7 ± 0.2% | 1086.4 ± 0.7% | 671.6 ± 0.1% | 990.5 ± 0.7% | 733.6 ± 0.5% | 10.679 | 14.408 | 23.306 | 15.802 | 21.338 |
| hex: canterbury-large/bible.txt | 524290 | 15627.0 ± 0.4% | 1462.3 ± 0.3% | 1084.2 ± 0.3% | 514.3 ± 0.6% | 992.4 ± 0.7% | 735.5 ± 0.7% | 10.687 | 14.414 | 30.385 | 15.747 | 21.248 |
| hex: canterbury-large/world192.txt | 524290 | 15585.1 ± 0.2% | 1457.4 ± 0.3% | 1081.8 ± 0.4% | 502.7 ± 0.4% | 986.5 ± 0.6% | 735.4 ± 0.2% | 10.694 | 14.407 | 31.005 | 15.799 | 21.194 |
| hex: http/html-1kx1024 | 2099200 | 13710.7 ± 0.3% | 1455.3 ± 0.1% | 1061.2 ± 0.1% | 500.8 ± 0.2% | 982.2 ± 0.1% | 692.4 ± 0.1% | 9.421 | 12.920 | 27.375 | 13.960 | 19.801 |
| hex: http/html-16kx64 | 2097280 | 15229.1 ± 0.3% | 1444.2 ± 0.2% | 1072.4 ± 0.2% | 506.2 ± 0.4% | 995.5 ± 0.1% | 734.1 ± 0.2% | 10.545 | 14.200 | 30.087 | 15.299 | 20.744 |
| hex: http/html-1m | 524290 | 15630.3 ± 0.4% | 1464.3 ± 1.3% | 1083.7 ± 0.5% | 498.1 ± 0.3% | 988.2 ± 0.9% | 733.4 ± 1.0% | 10.674 | 14.423 | 31.381 | 15.817 | 21.312 |
| hex: http/json-1kx1024 | 2099200 | 13643.6 ± 0.1% | 1463.3 ± 0.2% | 1065.5 ± 0.3% | 608.3 ± 0.4% | 986.1 ± 0.1% | 692.3 ± 0.3% | 9.324 | 12.804 | 22.428 | 13.836 | 19.708 |
| hex: http/json-16kx64 | 2097280 | 15227.9 ± 0.5% | 1445.9 ± 0.2% | 1073.9 ± 0.1% | 615.9 ± 0.8% | 994.9 ± 0.2% | 734.5 ± 0.1% | 10.532 | 14.180 | 24.726 | 15.306 | 20.733 |
| hex: http/json-1m | 524290 | 15643.3 ± 0.2% | 1474.1 ± 0.2% | 1088.2 ± 0.3% | 633.2 ± 0.5% | 994.7 ± 0.7% | 735.0 ± 0.5% | 10.612 | 14.375 | 24.704 | 15.727 | 21.283 |
| hex: http/js-1kx1024 | 2099200 | 13601.8 ± 0.3% | 1454.4 ± 0.3% | 1062.4 ± 0.2% | 498.8 ± 0.1% | 982.8 ± 0.2% | 692.7 ± 0.3% | 9.352 | 12.803 | 27.270 | 13.841 | 19.637 |
| hex: http/js-16kx64 | 2097280 | 15229.9 ± 4.5% | 1443.8 ± 0.2% | 1073.7 ± 0.1% | 503.3 ± 0.5% | 996.6 ± 0.5% | 734.9 ± 0.5% | 10.548 | 14.184 | 30.260 | 15.282 | 20.725 |
| hex: http/js-1m | 524290 | 15631.2 ± 0.3% | 1462.4 ± 0.3% | 1085.0 ± 0.4% | 509.1 ± 0.3% | 986.5 ± 0.4% | 733.8 ± 0.5% | 10.689 | 14.407 | 30.705 | 15.845 | 21.303 |
| hex: http/css-1kx1024 | 2099200 | 13655.7 ± 0.5% | 1455.5 ± 0.1% | 1061.4 ± 0.1% | 531.4 ± 0.3% | 983.3 ± 0.1% | 692.7 ± 0.1% | 9.382 | 12.865 | 25.696 | 13.888 | 19.715 |
| hex: http/css-16kx64 | 2097280 | 15220.4 ± 0.4% | 1444.1 ± 0.2% | 1073.5 ± 0.2% | 539.3 ± 0.7% | 999.3 ± 0.2% | 734.8 ± 0.4% | 10.540 | 14.179 | 28.220 | 15.231 | 20.715 |
| hex: http/css-1m | 524290 | 15653.0 ± 0.4% | 1465.3 ± 0.5% | 1085.1 ± 0.5% | 525.4 ± 0.4% | 991.4 ± 0.4% | 735.4 ± 1.6% | 10.683 | 14.425 | 29.795 | 15.789 | 21.285 |
| hex: shuffled/dickens-1m | 524290 | 15682.5 ± 0.4% | 1461.6 ± 0.3% | 1085.7 ± 0.1% | 498.6 ± 2.5% | 986.1 ± 0.3% | 735.0 ± 0.4% | 10.730 | 14.445 | 31.451 | 15.904 | 21.337 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1525.6 ± 0.7% | 1252.3 ± 0.4% | 1040.7 ± 1.0% | 409.8 ± 0.8% | 448.1 ± 0.1% | 414.7 ± 0.4% | 1.218 | 1.466 | 3.723 | 3.405 | 3.679 |
| qlog records, JSON text sequence | 1467503 | 1294.8 ± 0.5% | 1063.6 ± 0.2% | 778.0 ± 0.6% | 378.3 ± 1.4% | 467.4 ± 0.2% | 278.7 ± 0.6% | 1.217 | 1.664 | 3.422 | 2.770 | 4.646 |
| string: silesia/dickens | 172528 | 7127.5 ± 0.3% | 2820.5 ± 0.5% | 2920.8 ± 0.7% | 429.4 ± 0.5% | 1570.5 ± 0.1% | 1011.9 ± 0.1% | 2.527 | 2.440 | 16.600 | 4.538 | 7.043 |
| string: silesia/nci | 1075110 | 7377.0 ± 7.6% | 3437.2 ± 0.8% | 3098.1 ± 0.4% | 816.2 ± 0.8% | 1851.9 ± 0.2% | 1111.1 ± 0.3% | 2.146 | 2.381 | 9.038 | 3.983 | 6.640 |
| string: silesia/reymont | 1075159 | 3486.6 ± 1.8% | 1979.5 ± 0.5% | 2061.8 ± 0.5% | 449.7 ± 1.2% | 1510.4 ± 0.4% | 948.7 ± 0.8% | 1.761 | 1.691 | 7.753 | 2.308 | 3.675 |
| string: silesia/samba | 97582 | 4584.9 ± 0.8% | 2111.0 ± 1.7% | 3448.6 ± 0.2% | 353.5 ± 1.0% | 1434.6 ± 0.5% | 1054.5 ± 0.3% | 2.172 | 1.330 | 12.969 | 3.196 | 4.348 |
| string: silesia/webster | 1098490 | 4091.5 ± 0.5% | 1885.3 ± 0.4% | 2052.8 ± 0.2% | 440.1 ± 0.6% | 1387.1 ± 0.1% | 645.1 ± 0.3% | 2.170 | 1.993 | 9.298 | 2.950 | 6.342 |
| string: silesia/xml | 1090118 | 6235.9 ± 0.7% | 2875.1 ± 0.5% | 2648.2 ± 0.3% | 609.0 ± 0.3% | 1746.4 ± 0.3% | 919.1 ± 1.0% | 2.169 | 2.355 | 10.239 | 3.571 | 6.785 |
| string: canterbury/alice29.txt | 159425 | 6806.0 ± 2.4% | 2196.5 ± 0.5% | 2760.1 ± 0.5% | 407.8 ± 0.6% | 1463.6 ± 0.2% | 955.2 ± 0.1% | 3.098 | 2.466 | 16.688 | 4.650 | 7.125 |
| string: canterbury/asyoulik.txt | 132198 | 5855.5 ± 5.7% | 1713.3 ± 0.5% | 2371.8 ± 1.1% | 401.8 ± 0.6% | 1335.1 ± 0.5% | 886.3 ± 0.2% | 3.418 | 2.469 | 14.573 | 4.386 | 6.606 |
| string: canterbury/lcet10.txt | 441884 | 6215.1 ± 0.8% | 2553.6 ± 0.5% | 2503.2 ± 2.1% | 467.9 ± 0.5% | 1522.1 ± 0.3% | 984.1 ± 0.6% | 2.434 | 2.483 | 13.283 | 4.083 | 6.315 |
| string: canterbury/plrabn12.txt | 503330 | 5744.6 ± 0.3% | 2049.2 ± 0.2% | 2067.2 ± 0.3% | 422.8 ± 0.9% | 1405.3 ± 0.2% | 933.9 ± 0.3% | 2.803 | 2.779 | 13.589 | 4.088 | 6.151 |
| string: canterbury-large/E.coli | 1048578 | 19244.2 ± 0.7% | 9646.1 ± 1.1% | 3786.8 ± 0.4% | 1477.4 ± 0.5% | 2358.6 ± 0.5% | 1195.3 ± 0.5% | 1.995 | 5.082 | 13.025 | 8.159 | 16.099 |
| string: canterbury-large/bible.txt | 1055886 | 6796.3 ± 0.5% | 4122.3 ± 1.2% | 3061.2 ± 1.2% | 500.9 ± 0.5% | 1977.4 ± 0.6% | 1117.2 ± 0.7% | 1.649 | 2.220 | 13.569 | 3.437 | 6.083 |
| string: canterbury-large/world192.txt | 1103121 | 4028.8 ± 1.1% | 1654.8 ± 0.6% | 1991.5 ± 1.0% | 448.8 ± 0.9% | 1356.7 ± 0.2% | 906.3 ± 0.6% | 2.435 | 2.023 | 8.976 | 2.970 | 4.445 |
| string: http/html-1m | 1058582 | 6792.4 ± 0.6% | 3972.6 ± 0.7% | 3037.6 ± 0.5% | 500.4 ± 0.9% | 1929.8 ± 0.5% | 805.7 ± 0.3% | 1.710 | 2.236 | 13.574 | 3.520 | 8.430 |
| string: http/json-1m | 1190272 | 3291.8 ± 0.2% | 1350.3 ± 0.2% | 1555.0 ± 0.3% | 444.8 ± 0.6% | 962.2 ± 0.3% | 765.3 ± 1.0% | 2.438 | 2.117 | 7.401 | 3.421 | 4.301 |
| string: http/js-1m | 1144362 | 2812.6 ± 0.4% | 1180.3 ± 0.5% | 1625.5 ± 0.5% | 369.1 ± 0.5% | 1093.8 ± 0.2% | 758.4 ± 0.7% | 2.383 | 1.730 | 7.621 | 2.572 | 3.709 |
| string: http/css-1m | 1097820 | 4031.8 ± 0.5% | 1488.0 ± 0.6% | 2147.6 ± 0.9% | 494.7 ± 0.2% | 1369.4 ± 0.3% | 895.7 ± 0.5% | 2.710 | 1.877 | 8.149 | 2.944 | 4.501 |
| string: dickens as Cyrillic and CJK | 1883069 | 3072.6 ± 0.5% | 2339.8 ± 0.5% | 521.7 ± 0.6% | 306.3 ± 1.2% | 564.2 ± 0.7% | 336.2 ± 0.2% | 1.313 | 5.889 | 10.030 | 5.446 | 9.140 |
| hex: silesia/dickens | 524290 | 15688.2 ± 0.1% | 1460.1 ± 0.4% | 1082.4 ± 0.3% | 491.7 ± 1.9% | 991.4 ± 0.2% | 731.4 ± 0.5% | 10.745 | 14.494 | 31.909 | 15.824 | 21.449 |
| hex: silesia/mozilla | 524290 | 15658.2 ± 0.1% | 1470.3 ± 0.4% | 1087.7 ± 0.3% | 441.6 ± 0.6% | 991.5 ± 0.3% | 735.2 ± 0.5% | 10.649 | 14.396 | 35.461 | 15.792 | 21.297 |
| hex: silesia/mr | 524290 | 15650.5 ± 0.3% | 1482.3 ± 0.3% | 1091.9 ± 0.4% | 545.9 ± 3.4% | 993.0 ± 0.3% | 733.3 ± 0.5% | 10.559 | 14.333 | 28.671 | 15.760 | 21.343 |
| hex: silesia/nci | 524290 | 15579.5 ± 0.5% | 1470.9 ± 0.6% | 1088.0 ± 0.7% | 632.0 ± 4.5% | 987.9 ± 0.7% | 734.6 ± 0.5% | 10.592 | 14.320 | 24.651 | 15.771 | 21.207 |
| hex: silesia/ooffice | 524290 | 15617.1 ± 0.4% | 1463.8 ± 0.2% | 1082.6 ± 0.3% | 389.3 ± 0.4% | 989.9 ± 0.6% | 733.8 ± 0.4% | 10.669 | 14.425 | 40.116 | 15.776 | 21.283 |
| hex: silesia/osdb | 524290 | 15632.3 ± 0.2% | 1467.8 ± 0.2% | 1085.2 ± 0.4% | 466.9 ± 1.0% | 990.8 ± 0.4% | 735.0 ± 0.5% | 10.650 | 14.406 | 33.478 | 15.778 | 21.270 |
| hex: silesia/reymont | 524290 | 15606.6 ± 0.4% | 1461.1 ± 0.5% | 1082.2 ± 0.3% | 514.8 ± 0.8% | 988.2 ± 0.8% | 732.6 ± 0.4% | 10.682 | 14.421 | 30.314 | 15.793 | 21.304 |
| hex: silesia/samba | 524290 | 15671.0 ± 0.2% | 1466.0 ± 0.3% | 1085.4 ± 0.2% | 403.4 ± 0.7% | 985.8 ± 0.5% | 733.7 ± 0.5% | 10.690 | 14.438 | 38.845 | 15.896 | 21.359 |
| hex: silesia/sao | 524290 | 15676.0 ± 0.4% | 1462.3 ± 0.5% | 1082.8 ± 0.4% | 332.3 ± 1.0% | 985.7 ± 0.7% | 731.8 ± 0.7% | 10.720 | 14.478 | 47.176 | 15.903 | 21.422 |
| hex: silesia/webster | 524290 | 15686.7 ± 0.7% | 1464.7 ± 0.4% | 1083.8 ± 0.2% | 473.5 ± 0.7% | 989.3 ± 0.5% | 734.3 ± 0.3% | 10.710 | 14.473 | 33.127 | 15.856 | 21.364 |
| hex: silesia/x-ray | 524290 | 15650.5 ± 0.4% | 1475.5 ± 0.4% | 1089.6 ± 0.3% | 445.1 ± 1.1% | 992.7 ± 0.9% | 734.5 ± 0.3% | 10.607 | 14.363 | 35.161 | 15.766 | 21.308 |
| hex: silesia/xml | 524290 | 15624.9 ± 0.3% | 1465.5 ± 0.4% | 1086.9 ± 0.3% | 610.2 ± 1.1% | 991.8 ± 0.4% | 734.4 ± 0.4% | 10.661 | 14.375 | 25.607 | 15.754 | 21.275 |
| hex: canterbury/alice29.txt | 304180 | 15669.2 ± 0.1% | 1466.1 ± 0.8% | 1092.6 ± 0.1% | 505.6 ± 1.2% | 991.5 ± 0.4% | 734.9 ± 0.9% | 10.688 | 14.341 | 30.990 | 15.803 | 21.321 |
| hex: canterbury/asyoulik.txt | 250360 | 15721.4 ± 0.0% | 1468.7 ± 0.4% | 1092.9 ± 0.2% | 498.6 ± 1.0% | 997.8 ± 0.4% | 740.3 ± 0.4% | 10.704 | 14.386 | 31.533 | 15.757 | 21.236 |
| hex: canterbury/cp.html | 49208 | 15631.3 ± 0.1% | 1479.6 ± 0.4% | 1096.6 ± 0.1% | 533.8 ± 1.6% | 1000.7 ± 0.4% | 743.9 ± 0.2% | 10.564 | 14.254 | 29.284 | 15.620 | 21.012 |
| hex: canterbury/fields.c | 22302 | 15448.7 ± 0.1% | 1413.8 ± 0.7% | 1063.9 ± 0.5% | 614.0 ± 5.6% | 995.3 ± 0.1% | 737.4 ± 0.2% | 10.927 | 14.521 | 25.162 | 15.521 | 20.951 |
| hex: canterbury/grammar.lsp | 7444 | 14987.1 ± 0.0% | 1508.6 ± 0.2% | 1087.9 ± 0.4% | 663.0 ± 3.7% | 996.9 ± 0.3% | 725.9 ± 0.1% | 9.934 | 13.776 | 22.606 | 15.034 | 20.647 |
| hex: canterbury/kennedy.xls | 524290 | 15545.3 ± 0.6% | 1472.0 ± 0.2% | 1088.3 ± 0.4% | 659.2 ± 1.2% | 988.9 ± 0.2% | 733.7 ± 0.5% | 10.561 | 14.283 | 23.582 | 15.720 | 21.186 |
| hex: canterbury/lcet10.txt | 524290 | 15541.6 ± 0.7% | 1461.1 ± 0.2% | 1082.4 ± 0.3% | 495.5 ± 1.9% | 992.8 ± 0.6% | 734.6 ± 0.4% | 10.637 | 14.359 | 31.367 | 15.654 | 21.156 |
| hex: canterbury/plrabn12.txt | 524290 | 15564.0 ± 0.3% | 1461.6 ± 0.5% | 1082.0 ± 0.5% | 489.0 ± 2.5% | 984.7 ± 0.3% | 733.2 ± 0.7% | 10.649 | 14.385 | 31.830 | 15.806 | 21.227 |
| hex: canterbury/ptt5 | 524290 | 15581.4 ± 0.2% | 1477.2 ± 0.2% | 1092.4 ± 0.3% | 553.7 ± 0.5% | 991.3 ± 0.6% | 734.1 ± 0.5% | 10.548 | 14.264 | 28.139 | 15.718 | 21.226 |
| hex: canterbury/sum | 76482 | 15645.6 ± 0.0% | 1494.9 ± 0.2% | 1103.6 ± 0.1% | 584.1 ± 1.2% | 998.3 ± 0.0% | 744.7 ± 0.2% | 10.466 | 14.176 | 26.785 | 15.672 | 21.009 |
| hex: canterbury/xargs.1 | 8456 | 15043.7 ± 0.1% | 1492.5 ± 0.4% | 1076.3 ± 0.4% | 658.7 ± 4.4% | 1003.0 ± 0.1% | 727.9 ± 0.1% | 10.080 | 13.978 | 22.837 | 14.999 | 20.667 |
| hex: canterbury-large/E.coli | 524290 | 15651.5 ± 0.3% | 1465.7 ± 0.2% | 1086.4 ± 0.7% | 671.6 ± 0.1% | 990.5 ± 0.7% | 733.6 ± 0.5% | 10.678 | 14.407 | 23.304 | 15.801 | 21.337 |
| hex: canterbury-large/bible.txt | 524290 | 15642.2 ± 0.4% | 1462.3 ± 0.3% | 1084.2 ± 0.3% | 514.3 ± 0.6% | 992.4 ± 0.7% | 735.5 ± 0.7% | 10.697 | 14.428 | 30.415 | 15.763 | 21.269 |
| hex: canterbury-large/world192.txt | 524290 | 15564.0 ± 0.8% | 1457.4 ± 0.3% | 1081.8 ± 0.4% | 502.7 ± 0.4% | 986.5 ± 0.6% | 735.4 ± 0.2% | 10.679 | 14.387 | 30.963 | 15.778 | 21.165 |
| hex: http/html-1kx1024 | 2099200 | 13891.6 ± 0.6% | 1455.3 ± 0.1% | 1061.2 ± 0.1% | 500.8 ± 0.2% | 982.2 ± 0.1% | 692.4 ± 0.1% | 9.545 | 13.090 | 27.736 | 14.144 | 20.062 |
| hex: http/html-16kx64 | 2097280 | 15213.8 ± 0.4% | 1444.2 ± 0.2% | 1072.4 ± 0.2% | 506.2 ± 0.4% | 995.5 ± 0.1% | 734.1 ± 0.2% | 10.534 | 14.186 | 30.056 | 15.283 | 20.723 |
| hex: http/html-1m | 524290 | 15617.8 ± 0.3% | 1464.3 ± 1.3% | 1083.7 ± 0.5% | 498.1 ± 0.3% | 988.2 ± 0.9% | 733.4 ± 1.0% | 10.665 | 14.412 | 31.356 | 15.805 | 21.295 |
| hex: http/json-1kx1024 | 2099200 | 13716.3 ± 33.0% | 1463.3 ± 0.2% | 1065.5 ± 0.3% | 608.3 ± 0.4% | 986.1 ± 0.1% | 692.3 ± 0.3% | 9.374 | 12.873 | 22.548 | 13.909 | 19.813 |
| hex: http/json-16kx64 | 2097280 | 15245.3 ± 0.6% | 1445.9 ± 0.2% | 1073.9 ± 0.1% | 615.9 ± 0.8% | 994.9 ± 0.2% | 734.5 ± 0.1% | 10.544 | 14.197 | 24.754 | 15.323 | 20.757 |
| hex: http/json-1m | 524290 | 15659.6 ± 0.3% | 1474.1 ± 0.2% | 1088.2 ± 0.3% | 633.2 ± 0.5% | 994.7 ± 0.7% | 735.0 ± 0.5% | 10.623 | 14.390 | 24.730 | 15.743 | 21.306 |
| hex: http/js-1kx1024 | 2099200 | 13908.9 ± 0.4% | 1454.4 ± 0.3% | 1062.4 ± 0.2% | 498.8 ± 0.1% | 982.8 ± 0.2% | 692.7 ± 0.3% | 9.564 | 13.092 | 27.886 | 14.153 | 20.080 |
| hex: http/js-16kx64 | 2097280 | 15281.5 ± 0.6% | 1443.8 ± 0.2% | 1073.7 ± 0.1% | 503.3 ± 0.5% | 996.6 ± 0.5% | 734.9 ± 0.5% | 10.584 | 14.232 | 30.363 | 15.334 | 20.795 |
| hex: http/js-1m | 524290 | 15610.5 ± 0.8% | 1462.4 ± 0.3% | 1085.0 ± 0.4% | 509.1 ± 0.3% | 986.5 ± 0.4% | 733.8 ± 0.5% | 10.674 | 14.388 | 30.664 | 15.824 | 21.275 |
| hex: http/css-1kx1024 | 2099200 | 13831.0 ± 0.7% | 1455.5 ± 0.1% | 1061.4 ± 0.1% | 531.4 ± 0.3% | 983.3 ± 0.1% | 692.7 ± 0.1% | 9.502 | 13.030 | 26.026 | 14.066 | 19.968 |
| hex: http/css-16kx64 | 2097280 | 15221.4 ± 0.6% | 1444.1 ± 0.2% | 1073.5 ± 0.2% | 539.3 ± 0.7% | 999.3 ± 0.2% | 734.8 ± 0.4% | 10.540 | 14.180 | 28.222 | 15.232 | 20.716 |
| hex: http/css-1m | 524290 | 15696.1 ± 0.7% | 1465.3 ± 0.5% | 1085.1 ± 0.5% | 525.4 ± 0.4% | 991.4 ± 0.4% | 735.4 ± 1.6% | 10.712 | 14.464 | 29.876 | 15.833 | 21.344 |
| hex: shuffled/dickens-1m | 524290 | 15605.2 ± 0.8% | 1461.6 ± 0.3% | 1085.7 ± 0.1% | 498.6 ± 2.5% | 986.1 ± 0.3% | 735.0 ± 0.4% | 10.677 | 14.374 | 31.296 | 15.825 | 21.232 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.1 ± 0.2% | 928.9 ± 0.4% | 1023.5 ± 0.4% | 300.5 ± 0.5% | 664.4 ± 0.2% | 310.2 ± 1.8% | 1.009 | 0.916 | 3.119 | 1.410 | 3.021 |
| qlog records, JSON text sequence | 1467503 | 781.1 ± 18.8% | 817.9 ± 0.2% | 788.6 ± 1.0% | 244.3 ± 0.8% | 681.3 ± 0.8% | 250.3 ± 0.1% | 0.955 | 0.990 | 3.197 | 1.147 | 3.121 |
| string: silesia/dickens | 172528 | 5049.8 ± 0.5% | 1876.6 ± 0.2% | 2647.6 ± 0.7% | 361.5 ± 0.8% | 2864.3 ± 0.4% | 552.1 ± 1.5% | 2.691 | 1.907 | 13.970 | 1.763 | 9.146 |
| string: silesia/nci | 1075110 | 4319.5 ± 0.3% | 2236.4 ± 0.6% | 2988.5 ± 0.4% | 546.0 ± 0.5% | 2995.5 ± 1.7% | 605.1 ± 2.6% | 1.932 | 1.445 | 7.912 | 1.442 | 7.138 |
| string: silesia/reymont | 1075159 | 2993.3 ± 1.8% | 1817.5 ± 0.9% | 2060.6 ± 0.2% | 373.4 ± 1.1% | 2140.3 ± 0.1% | 535.1 ± 0.5% | 1.647 | 1.453 | 8.017 | 1.399 | 5.594 |
| string: silesia/samba | 97582 | 3505.6 ± 0.3% | 2026.6 ± 0.3% | 2615.6 ± 0.2% | 329.1 ± 0.6% | 1501.0 ± 0.6% | 429.4 ± 1.5% | 1.730 | 1.340 | 10.652 | 2.336 | 8.164 |
| string: silesia/webster | 1098490 | 3672.3 ± 0.8% | 1518.1 ± 0.2% | 2011.3 ± 1.0% | 359.4 ± 0.5% | 2163.5 ± 0.9% | 495.8 ± 2.5% | 2.419 | 1.826 | 10.216 | 1.697 | 7.407 |
| string: silesia/xml | 1090118 | 4796.0 ± 0.8% | 2355.2 ± 0.4% | 2524.5 ± 0.1% | 453.1 ± 1.0% | 2845.9 ± 1.1% | 562.6 ± 1.0% | 2.036 | 1.900 | 10.585 | 1.685 | 8.525 |
| string: canterbury/alice29.txt | 159425 | 4346.9 ± 1.2% | 1600.1 ± 0.3% | 2461.0 ± 0.6% | 342.1 ± 0.4% | 2501.7 ± 0.8% | 505.2 ± 1.3% | 2.717 | 1.766 | 12.705 | 1.738 | 8.604 |
| string: canterbury/asyoulik.txt | 132198 | 3486.0 ± 1.2% | 1458.2 ± 0.3% | 2224.5 ± 0.4% | 336.1 ± 0.6% | 2080.4 ± 0.3% | 459.4 ± 1.1% | 2.391 | 1.567 | 10.372 | 1.676 | 7.588 |
| string: canterbury/lcet10.txt | 441884 | 5092.7 ± 0.3% | 1850.7 ± 0.3% | 2324.6 ± 1.8% | 390.7 ± 0.6% | 2840.4 ± 0.8% | 537.9 ± 2.2% | 2.752 | 2.191 | 13.035 | 1.793 | 9.468 |
| string: canterbury/plrabn12.txt | 503330 | 4124.6 ± 0.5% | 1736.1 ± 0.2% | 2059.8 ± 0.6% | 360.0 ± 0.6% | 2491.7 ± 1.0% | 499.1 ± 2.3% | 2.376 | 2.002 | 11.458 | 1.655 | 8.264 |
| string: canterbury-large/E.coli | 1048578 | 11890.1 ± 0.6% | 3602.4 ± 0.3% | 3252.6 ± 0.3% | 929.9 ± 0.7% | 5914.9 ± 1.0% | 758.0 ± 1.7% | 3.301 | 3.656 | 12.786 | 2.010 | 15.685 |
| string: canterbury-large/bible.txt | 1055886 | 6938.1 ± 1.1% | 2938.3 ± 0.6% | 2833.2 ± 0.5% | 422.2 ± 1.5% | 3737.9 ± 2.7% | 612.4 ± 1.5% | 2.361 | 2.449 | 16.433 | 1.856 | 11.329 |
| string: canterbury-large/world192.txt | 1103121 | 3401.1 ± 0.3% | 1481.0 ± 0.2% | 2011.5 ± 0.4% | 353.2 ± 0.3% | 2108.8 ± 0.7% | 500.4 ± 0.5% | 2.296 | 1.691 | 9.629 | 1.613 | 6.796 |
| string: http/html-1m | 1058582 | 6214.7 ± 0.5% | 2742.9 ± 0.4% | 2704.2 ± 1.0% | 442.1 ± 0.6% | 3462.9 ± 0.6% | 598.9 ± 0.6% | 2.266 | 2.298 | 14.058 | 1.795 | 10.377 |
| string: http/json-1m | 1190272 | 2557.3 ± 0.5% | 877.6 ± 0.1% | 2244.6 ± 0.4% | 391.4 ± 0.2% | 1060.4 ± 0.4% | 442.4 ± 0.4% | 2.914 | 1.139 | 6.534 | 2.412 | 5.780 |
| string: http/js-1m | 1144362 | 2285.4 ± 0.5% | 1028.4 ± 0.1% | 1634.3 ± 0.2% | 321.1 ± 0.2% | 1520.2 ± 0.5% | 418.5 ± 0.6% | 2.222 | 1.398 | 7.117 | 1.503 | 5.461 |
| string: http/css-1m | 1097820 | 2653.1 ± 0.5% | 1677.8 ± 0.2% | 2226.1 ± 0.6% | 406.0 ± 1.0% | 1946.2 ± 1.0% | 489.6 ± 1.0% | 1.581 | 1.192 | 6.534 | 1.363 | 5.419 |
| string: dickens as Cyrillic and CJK | 1883069 | 3075.3 ± 0.5% | 1682.6 ± 0.3% | 893.3 ± 0.8% | 350.4 ± 0.2% | 666.2 ± 0.9% | 157.8 ± 2.0% | 1.828 | 3.442 | 8.776 | 4.617 | 19.484 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.3 ± 0.1% | 980.9 ± 0.2% | 1207.8 ± 0.5% | 216.2 ± 0.2% | 471.1 ± 0.4% | 253.2 ± 3.9% | 1.356 | 1.101 | 6.153 | 2.824 | 5.255 |
| hex: silesia/dickens | 524290 | 12007.8 ± 0.1% | 3614.4 ± 0.1% | 3303.4 ± 0.3% | 505.7 ± 2.9% | 6112.9 ± 2.6% | 782.1 ± 2.9% | 3.322 | 3.635 | 23.745 | 1.964 | 15.354 |
| hex: silesia/mozilla | 524290 | 11982.8 ± 0.2% | 3612.2 ± 0.2% | 3288.6 ± 0.4% | 442.6 ± 1.1% | 5960.5 ± 0.7% | 784.7 ± 0.6% | 3.317 | 3.644 | 27.075 | 2.010 | 15.271 |
| hex: silesia/mr | 524290 | 12023.3 ± 0.1% | 3611.7 ± 0.6% | 3293.6 ± 0.3% | 566.1 ± 7.3% | 6084.6 ± 1.5% | 784.2 ± 0.6% | 3.329 | 3.650 | 21.239 | 1.976 | 15.333 |
| hex: silesia/nci | 524290 | 11931.6 ± 0.2% | 3610.4 ± 0.3% | 3281.7 ± 0.3% | 604.9 ± 4.4% | 6016.0 ± 1.2% | 782.8 ± 0.2% | 3.305 | 3.636 | 19.726 | 1.983 | 15.242 |
| hex: silesia/ooffice | 524290 | 11994.6 ± 0.2% | 3612.3 ± 0.3% | 3291.1 ± 0.4% | 392.1 ± 0.6% | 6113.2 ± 1.7% | 782.7 ± 0.3% | 3.320 | 3.645 | 30.592 | 1.962 | 15.324 |
| hex: silesia/osdb | 524290 | 11971.1 ± 0.2% | 3614.3 ± 0.2% | 3284.4 ± 0.4% | 478.4 ± 3.6% | 6129.0 ± 2.5% | 784.0 ± 0.6% | 3.312 | 3.645 | 25.024 | 1.953 | 15.270 |
| hex: silesia/reymont | 524290 | 11963.0 ± 0.2% | 3615.0 ± 0.3% | 3297.4 ± 0.2% | 509.8 ± 0.5% | 6026.6 ± 0.7% | 783.4 ± 0.6% | 3.309 | 3.628 | 23.467 | 1.985 | 15.272 |
| hex: silesia/samba | 524290 | 11900.3 ± 0.2% | 3611.2 ± 0.3% | 3280.6 ± 0.3% | 400.6 ± 3.0% | 5964.6 ± 0.8% | 782.8 ± 0.2% | 3.295 | 3.627 | 29.703 | 1.995 | 15.202 |
| hex: silesia/sao | 524290 | 11996.2 ± 0.1% | 3612.2 ± 0.2% | 3287.0 ± 0.3% | 335.2 ± 0.8% | 5986.2 ± 0.7% | 782.0 ± 0.3% | 3.321 | 3.650 | 35.785 | 2.004 | 15.341 |
| hex: silesia/webster | 524290 | 12015.7 ± 0.1% | 3612.9 ± 0.3% | 3292.4 ± 0.5% | 467.1 ± 1.0% | 6087.0 ± 1.4% | 785.4 ± 0.3% | 3.326 | 3.649 | 25.726 | 1.974 | 15.299 |
| hex: silesia/x-ray | 524290 | 12001.9 ± 0.2% | 3616.6 ± 0.2% | 3287.7 ± 0.3% | 476.6 ± 2.4% | 6093.4 ± 1.4% | 783.3 ± 0.5% | 3.319 | 3.651 | 25.183 | 1.970 | 15.322 |
| hex: silesia/xml | 524290 | 11978.8 ± 0.1% | 3613.4 ± 0.3% | 3294.9 ± 0.3% | 523.1 ± 3.4% | 6094.9 ± 0.4% | 785.0 ± 0.3% | 3.315 | 3.636 | 22.900 | 1.965 | 15.259 |
| hex: canterbury/alice29.txt | 304180 | 12013.1 ± 0.1% | 3633.5 ± 0.1% | 3370.1 ± 0.1% | 507.7 ± 2.0% | 6078.3 ± 0.5% | 785.0 ± 0.2% | 3.306 | 3.565 | 23.662 | 1.976 | 15.303 |
| hex: canterbury/asyoulik.txt | 250360 | 12002.7 ± 0.1% | 3636.3 ± 0.0% | 3359.5 ± 0.1% | 500.3 ± 2.0% | 6106.0 ± 1.5% | 780.9 ± 0.3% | 3.301 | 3.573 | 23.992 | 1.966 | 15.370 |
| hex: canterbury/cp.html | 49208 | 11905.6 ± 0.0% | 3638.4 ± 0.1% | 3280.4 ± 0.2% | 465.0 ± 1.7% | 6266.7 ± 0.6% | 771.7 ± 0.7% | 3.272 | 3.629 | 25.604 | 1.900 | 15.428 |
| hex: canterbury/fields.c | 22302 | 11777.7 ± 0.0% | 3629.2 ± 0.0% | 3356.6 ± 0.2% | 497.7 ± 1.6% | 6253.1 ± 0.6% | 762.6 ± 1.6% | 3.245 | 3.509 | 23.667 | 1.883 | 15.443 |
| hex: canterbury/grammar.lsp | 7444 | 11254.2 ± 0.2% | 3601.4 ± 0.0% | 3357.9 ± 0.4% | 539.5 ± 5.2% | 6167.2 ± 0.8% | 732.9 ± 1.8% | 3.125 | 3.352 | 20.861 | 1.825 | 15.357 |
| hex: canterbury/kennedy.xls | 524290 | 11904.2 ± 0.1% | 3608.6 ± 0.3% | 3287.6 ± 0.3% | 670.6 ± 1.9% | 6064.5 ± 0.9% | 766.0 ± 5.5% | 3.299 | 3.621 | 17.752 | 1.963 | 15.541 |
| hex: canterbury/lcet10.txt | 524290 | 12025.4 ± 0.0% | 3605.2 ± 0.5% | 3303.5 ± 0.6% | 527.4 ± 1.0% | 6129.4 ± 2.5% | 783.5 ± 0.8% | 3.336 | 3.640 | 22.800 | 1.962 | 15.348 |
| hex: canterbury/plrabn12.txt | 524290 | 12003.9 ± 0.1% | 3610.0 ± 0.2% | 3295.6 ± 0.3% | 517.6 ± 0.2% | 6125.3 ± 0.5% | 782.7 ± 0.6% | 3.325 | 3.642 | 23.189 | 1.960 | 15.336 |
| hex: canterbury/ptt5 | 524290 | 11997.7 ± 0.3% | 3609.8 ± 0.2% | 3289.0 ± 0.2% | 559.2 ± 2.4% | 6094.2 ± 1.5% | 783.6 ± 1.1% | 3.324 | 3.648 | 21.457 | 1.969 | 15.310 |
| hex: canterbury/sum | 76482 | 11898.2 ± 0.1% | 3634.4 ± 0.0% | 3354.9 ± 0.3% | 508.9 ± 0.4% | 6177.2 ± 0.7% | 775.4 ± 0.8% | 3.274 | 3.546 | 23.379 | 1.926 | 15.344 |
| hex: canterbury/xargs.1 | 8456 | 11333.4 ± 0.1% | 3601.4 ± 0.2% | 3380.8 ± 0.5% | 491.3 ± 1.9% | 6153.0 ± 0.4% | 756.3 ± 0.5% | 3.147 | 3.352 | 23.067 | 1.842 | 14.986 |
| hex: canterbury-large/E.coli | 524290 | 11959.1 ± 0.1% | 3607.1 ± 0.3% | 3285.0 ± 0.3% | 688.7 ± 0.1% | 6043.6 ± 1.4% | 774.5 ± 6.9% | 3.315 | 3.641 | 17.365 | 1.979 | 15.440 |
| hex: canterbury-large/bible.txt | 524290 | 11955.5 ± 0.3% | 3607.2 ± 0.6% | 3291.4 ± 0.3% | 531.1 ± 2.6% | 6026.4 ± 0.8% | 779.3 ± 0.7% | 3.314 | 3.632 | 22.511 | 1.984 | 15.341 |
| hex: canterbury-large/world192.txt | 524290 | 11968.9 ± 0.2% | 3610.0 ± 0.4% | 3284.6 ± 0.6% | 494.2 ± 2.1% | 6064.5 ± 0.6% | 770.5 ± 1.9% | 3.315 | 3.644 | 24.217 | 1.974 | 15.534 |
| hex: http/html-1kx1024 | 2099200 | 8756.2 ± 4.1% | 3458.3 ± 0.2% | 2856.0 ± 0.5% | 477.1 ± 0.9% | 5115.8 ± 0.3% | 646.7 ± 2.5% | 2.532 | 3.066 | 18.354 | 1.712 | 13.539 |
| hex: http/html-16kx64 | 2097280 | 11775.1 ± 0.1% | 3608.2 ± 0.1% | 3262.5 ± 0.3% | 478.6 ± 1.0% | 6030.6 ± 1.1% | 757.1 ± 1.3% | 3.263 | 3.609 | 24.603 | 1.953 | 15.552 |
| hex: http/html-1m | 524290 | 12013.3 ± 0.2% | 3612.3 ± 0.2% | 3287.9 ± 0.3% | 500.6 ± 1.2% | 6127.0 ± 1.1% | 774.5 ± 3.2% | 3.326 | 3.654 | 23.997 | 1.961 | 15.510 |
| hex: http/json-1kx1024 | 2099200 | 8795.7 ± 3.5% | 3459.6 ± 0.2% | 2854.0 ± 0.2% | 575.0 ± 0.8% | 5108.2 ± 0.9% | 643.2 ± 1.4% | 2.542 | 3.082 | 15.297 | 1.722 | 13.675 |
| hex: http/json-16kx64 | 2097280 | 11743.8 ± 0.5% | 3608.0 ± 0.1% | 3253.7 ± 0.3% | 572.2 ± 2.5% | 6026.1 ± 0.2% | 750.3 ± 2.1% | 3.255 | 3.609 | 20.523 | 1.949 | 15.651 |
| hex: http/json-1m | 524290 | 11987.5 ± 0.1% | 3614.1 ± 0.2% | 3294.4 ± 0.1% | 589.3 ± 1.1% | 6125.9 ± 1.9% | 764.4 ± 3.6% | 3.317 | 3.639 | 20.341 | 1.957 | 15.682 |
| hex: http/js-1kx1024 | 2099200 | 8806.3 ± 4.4% | 3461.6 ± 0.1% | 2857.1 ± 0.4% | 481.1 ± 0.7% | 5131.3 ± 0.8% | 641.9 ± 4.1% | 2.544 | 3.082 | 18.306 | 1.716 | 13.718 |
| hex: http/js-16kx64 | 2097280 | 11764.4 ± 0.3% | 3609.0 ± 0.2% | 3262.2 ± 0.3% | 479.6 ± 0.4% | 6028.5 ± 0.5% | 755.3 ± 2.6% | 3.260 | 3.606 | 24.528 | 1.951 | 15.576 |
| hex: http/js-1m | 524290 | 11952.8 ± 0.2% | 3619.8 ± 0.2% | 3285.4 ± 0.5% | 502.6 ± 0.9% | 6061.4 ± 1.0% | 760.6 ± 2.5% | 3.302 | 3.638 | 23.782 | 1.972 | 15.715 |
| hex: http/css-1kx1024 | 2099200 | 8771.1 ± 1.2% | 3459.1 ± 0.3% | 2854.1 ± 0.5% | 488.6 ± 0.7% | 5125.2 ± 0.5% | 630.7 ± 2.8% | 2.536 | 3.073 | 17.951 | 1.711 | 13.908 |
| hex: http/css-16kx64 | 2097280 | 11767.1 ± 0.3% | 3610.3 ± 0.1% | 3257.8 ± 0.3% | 493.6 ± 0.3% | 6011.8 ± 0.6% | 743.3 ± 2.1% | 3.259 | 3.612 | 23.841 | 1.957 | 15.831 |
| hex: http/css-1m | 524290 | 12006.8 ± 0.1% | 3611.4 ± 0.2% | 3297.6 ± 0.2% | 501.4 ± 2.0% | 6085.5 ± 0.6% | 743.7 ± 2.3% | 3.325 | 3.641 | 23.945 | 1.973 | 16.145 |
| hex: shuffled/dickens-1m | 524290 | 11972.5 ± 0.3% | 3612.5 ± 0.1% | 3288.5 ± 0.2% | 526.3 ± 0.2% | 6093.2 ± 1.3% | 758.4 ± 2.9% | 3.314 | 3.641 | 22.747 | 1.965 | 15.787 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1014.3 ± 0.1% | 928.9 ± 0.4% | 1023.5 ± 0.4% | 300.5 ± 0.5% | 664.4 ± 0.2% | 310.2 ± 1.8% | 1.092 | 0.991 | 3.375 | 1.526 | 3.269 |
| qlog records, JSON text sequence | 1467503 | 839.2 ± 18.1% | 817.9 ± 0.2% | 788.6 ± 1.0% | 244.3 ± 0.8% | 681.3 ± 0.8% | 250.3 ± 0.1% | 1.026 | 1.064 | 3.435 | 1.232 | 3.353 |
| string: silesia/dickens | 172528 | 5047.6 ± 0.3% | 1876.6 ± 0.2% | 2647.6 ± 0.7% | 361.5 ± 0.8% | 2864.3 ± 0.4% | 552.1 ± 1.5% | 2.690 | 1.906 | 13.964 | 1.762 | 9.142 |
| string: silesia/nci | 1075110 | 4321.0 ± 0.4% | 2236.4 ± 0.6% | 2988.5 ± 0.4% | 546.0 ± 0.5% | 2995.5 ± 1.7% | 605.1 ± 2.6% | 1.932 | 1.446 | 7.915 | 1.443 | 7.141 |
| string: silesia/reymont | 1075159 | 2978.0 ± 1.4% | 1817.5 ± 0.9% | 2060.6 ± 0.2% | 373.4 ± 1.1% | 2140.3 ± 0.1% | 535.1 ± 0.5% | 1.639 | 1.445 | 7.976 | 1.391 | 5.566 |
| string: silesia/samba | 97582 | 3512.6 ± 0.2% | 2026.6 ± 0.3% | 2615.6 ± 0.2% | 329.1 ± 0.6% | 1501.0 ± 0.6% | 429.4 ± 1.5% | 1.733 | 1.343 | 10.673 | 2.340 | 8.180 |
| string: silesia/webster | 1098490 | 3673.3 ± 0.6% | 1518.1 ± 0.2% | 2011.3 ± 1.0% | 359.4 ± 0.5% | 2163.5 ± 0.9% | 495.8 ± 2.5% | 2.420 | 1.826 | 10.219 | 1.698 | 7.409 |
| string: silesia/xml | 1090118 | 4789.4 ± 0.8% | 2355.2 ± 0.4% | 2524.5 ± 0.1% | 453.1 ± 1.0% | 2845.9 ± 1.1% | 562.6 ± 1.0% | 2.034 | 1.897 | 10.571 | 1.683 | 8.513 |
| string: canterbury/alice29.txt | 159425 | 4355.0 ± 0.7% | 1600.1 ± 0.3% | 2461.0 ± 0.6% | 342.1 ± 0.4% | 2501.7 ± 0.8% | 505.2 ± 1.3% | 2.722 | 1.770 | 12.729 | 1.741 | 8.620 |
| string: canterbury/asyoulik.txt | 132198 | 3500.6 ± 1.1% | 1458.2 ± 0.3% | 2224.5 ± 0.4% | 336.1 ± 0.6% | 2080.4 ± 0.3% | 459.4 ± 1.1% | 2.401 | 1.574 | 10.415 | 1.683 | 7.620 |
| string: canterbury/lcet10.txt | 441884 | 5081.8 ± 0.4% | 1850.7 ± 0.3% | 2324.6 ± 1.8% | 390.7 ± 0.6% | 2840.4 ± 0.8% | 537.9 ± 2.2% | 2.746 | 2.186 | 13.007 | 1.789 | 9.448 |
| string: canterbury/plrabn12.txt | 503330 | 4114.6 ± 0.6% | 1736.1 ± 0.2% | 2059.8 ± 0.6% | 360.0 ± 0.6% | 2491.7 ± 1.0% | 499.1 ± 2.3% | 2.370 | 1.998 | 11.430 | 1.651 | 8.244 |
| string: canterbury-large/E.coli | 1048578 | 11882.6 ± 0.5% | 3602.4 ± 0.3% | 3252.6 ± 0.3% | 929.9 ± 0.7% | 5914.9 ± 1.0% | 758.0 ± 1.7% | 3.299 | 3.653 | 12.778 | 2.009 | 15.675 |
| string: canterbury-large/bible.txt | 1055886 | 6957.4 ± 1.2% | 2938.3 ± 0.6% | 2833.2 ± 0.5% | 422.2 ± 1.5% | 3737.9 ± 2.7% | 612.4 ± 1.5% | 2.368 | 2.456 | 16.478 | 1.861 | 11.360 |
| string: canterbury-large/world192.txt | 1103121 | 3402.3 ± 0.7% | 1481.0 ± 0.2% | 2011.5 ± 0.4% | 353.2 ± 0.3% | 2108.8 ± 0.7% | 500.4 ± 0.5% | 2.297 | 1.691 | 9.632 | 1.613 | 6.799 |
| string: http/html-1m | 1058582 | 6247.6 ± 0.7% | 2742.9 ± 0.4% | 2704.2 ± 1.0% | 442.1 ± 0.6% | 3462.9 ± 0.6% | 598.9 ± 0.6% | 2.278 | 2.310 | 14.132 | 1.804 | 10.432 |
| string: http/json-1m | 1190272 | 2557.9 ± 0.3% | 877.6 ± 0.1% | 2244.6 ± 0.4% | 391.4 ± 0.2% | 1060.4 ± 0.4% | 442.4 ± 0.4% | 2.915 | 1.140 | 6.536 | 2.412 | 5.781 |
| string: http/js-1m | 1144362 | 2284.3 ± 1.2% | 1028.4 ± 0.1% | 1634.3 ± 0.2% | 321.1 ± 0.2% | 1520.2 ± 0.5% | 418.5 ± 0.6% | 2.221 | 1.398 | 7.114 | 1.503 | 5.458 |
| string: http/css-1m | 1097820 | 2659.2 ± 0.5% | 1677.8 ± 0.2% | 2226.1 ± 0.6% | 406.0 ± 1.0% | 1946.2 ± 1.0% | 489.6 ± 1.0% | 1.585 | 1.195 | 6.549 | 1.366 | 5.432 |
| string: dickens as Cyrillic and CJK | 1883069 | 3077.2 ± 0.5% | 1682.6 ± 0.3% | 893.3 ± 0.8% | 350.4 ± 0.2% | 666.2 ± 0.9% | 157.8 ± 2.0% | 1.829 | 3.445 | 8.782 | 4.619 | 19.496 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.5 ± 0.3% | 980.9 ± 0.2% | 1207.8 ± 0.5% | 216.2 ± 0.2% | 471.1 ± 0.4% | 253.2 ± 3.9% | 1.356 | 1.102 | 6.154 | 2.825 | 5.255 |
| hex: silesia/dickens | 524290 | 12011.8 ± 0.2% | 3614.4 ± 0.1% | 3303.4 ± 0.3% | 505.7 ± 2.9% | 6112.9 ± 2.6% | 782.1 ± 2.9% | 3.323 | 3.636 | 23.753 | 1.965 | 15.359 |
| hex: silesia/mozilla | 524290 | 11973.6 ± 0.2% | 3612.2 ± 0.2% | 3288.6 ± 0.4% | 442.6 ± 1.1% | 5960.5 ± 0.7% | 784.7 ± 0.6% | 3.315 | 3.641 | 27.054 | 2.009 | 15.259 |
| hex: silesia/mr | 524290 | 12025.7 ± 0.1% | 3611.7 ± 0.6% | 3293.6 ± 0.3% | 566.1 ± 7.3% | 6084.6 ± 1.5% | 784.2 ± 0.6% | 3.330 | 3.651 | 21.243 | 1.976 | 15.336 |
| hex: silesia/nci | 524290 | 11949.9 ± 0.5% | 3610.4 ± 0.3% | 3281.7 ± 0.3% | 604.9 ± 4.4% | 6016.0 ± 1.2% | 782.8 ± 0.2% | 3.310 | 3.641 | 19.757 | 1.986 | 15.266 |
| hex: silesia/ooffice | 524290 | 11993.3 ± 0.1% | 3612.3 ± 0.3% | 3291.1 ± 0.4% | 392.1 ± 0.6% | 6113.2 ± 1.7% | 782.7 ± 0.3% | 3.320 | 3.644 | 30.588 | 1.962 | 15.323 |
| hex: silesia/osdb | 524290 | 11966.8 ± 0.1% | 3614.3 ± 0.2% | 3284.4 ± 0.4% | 478.4 ± 3.6% | 6129.0 ± 2.5% | 784.0 ± 0.6% | 3.311 | 3.644 | 25.015 | 1.952 | 15.264 |
| hex: silesia/reymont | 524290 | 11912.5 ± 0.3% | 3615.0 ± 0.3% | 3297.4 ± 0.2% | 509.8 ± 0.5% | 6026.6 ± 0.7% | 783.4 ± 0.6% | 3.295 | 3.613 | 23.368 | 1.977 | 15.207 |
| hex: silesia/samba | 524290 | 11884.8 ± 0.2% | 3611.2 ± 0.3% | 3280.6 ± 0.3% | 400.6 ± 3.0% | 5964.6 ± 0.8% | 782.8 ± 0.2% | 3.291 | 3.623 | 29.664 | 1.993 | 15.182 |
| hex: silesia/sao | 524290 | 11998.3 ± 0.1% | 3612.2 ± 0.2% | 3287.0 ± 0.3% | 335.2 ± 0.8% | 5986.2 ± 0.7% | 782.0 ± 0.3% | 3.322 | 3.650 | 35.791 | 2.004 | 15.343 |
| hex: silesia/webster | 524290 | 12008.1 ± 0.4% | 3612.9 ± 0.3% | 3292.4 ± 0.5% | 467.1 ± 1.0% | 6087.0 ± 1.4% | 785.4 ± 0.3% | 3.324 | 3.647 | 25.710 | 1.973 | 15.289 |
| hex: silesia/x-ray | 524290 | 12009.4 ± 0.1% | 3616.6 ± 0.2% | 3287.7 ± 0.3% | 476.6 ± 2.4% | 6093.4 ± 1.4% | 783.3 ± 0.5% | 3.321 | 3.653 | 25.199 | 1.971 | 15.332 |
| hex: silesia/xml | 524290 | 11970.3 ± 0.1% | 3613.4 ± 0.3% | 3294.9 ± 0.3% | 523.1 ± 3.4% | 6094.9 ± 0.4% | 785.0 ± 0.3% | 3.313 | 3.633 | 22.884 | 1.964 | 15.248 |
| hex: canterbury/alice29.txt | 304180 | 12012.5 ± 0.1% | 3633.5 ± 0.1% | 3370.1 ± 0.1% | 507.7 ± 2.0% | 6078.3 ± 0.5% | 785.0 ± 0.2% | 3.306 | 3.564 | 23.661 | 1.976 | 15.302 |
| hex: canterbury/asyoulik.txt | 250360 | 12010.1 ± 0.0% | 3636.3 ± 0.0% | 3359.5 ± 0.1% | 500.3 ± 2.0% | 6106.0 ± 1.5% | 780.9 ± 0.3% | 3.303 | 3.575 | 24.007 | 1.967 | 15.380 |
| hex: canterbury/cp.html | 49208 | 11902.6 ± 0.0% | 3638.4 ± 0.1% | 3280.4 ± 0.2% | 465.0 ± 1.7% | 6266.7 ± 0.6% | 771.7 ± 0.7% | 3.271 | 3.628 | 25.597 | 1.899 | 15.424 |
| hex: canterbury/fields.c | 22302 | 11776.8 ± 0.1% | 3629.2 ± 0.0% | 3356.6 ± 0.2% | 497.7 ± 1.6% | 6253.1 ± 0.6% | 762.6 ± 1.6% | 3.245 | 3.509 | 23.665 | 1.883 | 15.442 |
| hex: canterbury/grammar.lsp | 7444 | 11316.6 ± 0.0% | 3601.4 ± 0.0% | 3357.9 ± 0.4% | 539.5 ± 5.2% | 6167.2 ± 0.8% | 732.9 ± 1.8% | 3.142 | 3.370 | 20.977 | 1.835 | 15.442 |
| hex: canterbury/kennedy.xls | 524290 | 11961.5 ± 0.2% | 3608.6 ± 0.3% | 3287.6 ± 0.3% | 670.6 ± 1.9% | 6064.5 ± 0.9% | 766.0 ± 5.5% | 3.315 | 3.638 | 17.838 | 1.972 | 15.616 |
| hex: canterbury/lcet10.txt | 524290 | 12026.0 ± 0.1% | 3605.2 ± 0.5% | 3303.5 ± 0.6% | 527.4 ± 1.0% | 6129.4 ± 2.5% | 783.5 ± 0.8% | 3.336 | 3.640 | 22.801 | 1.962 | 15.348 |
| hex: canterbury/plrabn12.txt | 524290 | 12004.4 ± 0.1% | 3610.0 ± 0.2% | 3295.6 ± 0.3% | 517.6 ± 0.2% | 6125.3 ± 0.5% | 782.7 ± 0.6% | 3.325 | 3.643 | 23.190 | 1.960 | 15.337 |
| hex: canterbury/ptt5 | 524290 | 11992.8 ± 0.1% | 3609.8 ± 0.2% | 3289.0 ± 0.2% | 559.2 ± 2.4% | 6094.2 ± 1.5% | 783.6 ± 1.1% | 3.322 | 3.646 | 21.448 | 1.968 | 15.304 |
| hex: canterbury/sum | 76482 | 11899.1 ± 0.1% | 3634.4 ± 0.0% | 3354.9 ± 0.3% | 508.9 ± 0.4% | 6177.2 ± 0.7% | 775.4 ± 0.8% | 3.274 | 3.547 | 23.381 | 1.926 | 15.346 |
| hex: canterbury/xargs.1 | 8456 | 11337.1 ± 0.1% | 3601.4 ± 0.2% | 3380.8 ± 0.5% | 491.3 ± 1.9% | 6153.0 ± 0.4% | 756.3 ± 0.5% | 3.148 | 3.353 | 23.074 | 1.843 | 14.991 |
| hex: canterbury-large/E.coli | 524290 | 11982.3 ± 0.2% | 3607.1 ± 0.3% | 3285.0 ± 0.3% | 688.7 ± 0.1% | 6043.6 ± 1.4% | 774.5 ± 6.9% | 3.322 | 3.648 | 17.399 | 1.983 | 15.470 |
| hex: canterbury-large/bible.txt | 524290 | 11963.4 ± 0.4% | 3607.2 ± 0.6% | 3291.4 ± 0.3% | 531.1 ± 2.6% | 6026.4 ± 0.8% | 779.3 ± 0.7% | 3.317 | 3.635 | 22.525 | 1.985 | 15.352 |
| hex: canterbury-large/world192.txt | 524290 | 11959.6 ± 0.3% | 3610.0 ± 0.4% | 3284.6 ± 0.6% | 494.2 ± 2.1% | 6064.5 ± 0.6% | 770.5 ± 1.9% | 3.313 | 3.641 | 24.198 | 1.972 | 15.522 |
| hex: http/html-1kx1024 | 2099200 | 8840.8 ± 4.1% | 3458.3 ± 0.2% | 2856.0 ± 0.5% | 477.1 ± 0.9% | 5115.8 ± 0.3% | 646.7 ± 2.5% | 2.556 | 3.095 | 18.532 | 1.728 | 13.670 |
| hex: http/html-16kx64 | 2097280 | 11773.9 ± 0.2% | 3608.2 ± 0.1% | 3262.5 ± 0.3% | 478.6 ± 1.0% | 6030.6 ± 1.1% | 757.1 ± 1.3% | 3.263 | 3.609 | 24.600 | 1.952 | 15.550 |
| hex: http/html-1m | 524290 | 12016.2 ± 0.1% | 3612.3 ± 0.2% | 3287.9 ± 0.3% | 500.6 ± 1.2% | 6127.0 ± 1.1% | 774.5 ± 3.2% | 3.326 | 3.655 | 24.003 | 1.961 | 15.514 |
| hex: http/json-1kx1024 | 2099200 | 8792.5 ± 3.8% | 3459.6 ± 0.2% | 2854.0 ± 0.2% | 575.0 ± 0.8% | 5108.2 ± 0.9% | 643.2 ± 1.4% | 2.541 | 3.081 | 15.292 | 1.721 | 13.670 |
| hex: http/json-16kx64 | 2097280 | 11774.9 ± 0.3% | 3608.0 ± 0.1% | 3253.7 ± 0.3% | 572.2 ± 2.5% | 6026.1 ± 0.2% | 750.3 ± 2.1% | 3.264 | 3.619 | 20.578 | 1.954 | 15.693 |
| hex: http/json-1m | 524290 | 11987.7 ± 0.2% | 3614.1 ± 0.2% | 3294.4 ± 0.1% | 589.3 ± 1.1% | 6125.9 ± 1.9% | 764.4 ± 3.6% | 3.317 | 3.639 | 20.341 | 1.957 | 15.682 |
| hex: http/js-1kx1024 | 2099200 | 8869.1 ± 3.5% | 3461.6 ± 0.1% | 2857.1 ± 0.4% | 481.1 ± 0.7% | 5131.3 ± 0.8% | 641.9 ± 4.1% | 2.562 | 3.104 | 18.437 | 1.728 | 13.816 |
| hex: http/js-16kx64 | 2097280 | 11768.9 ± 0.2% | 3609.0 ± 0.2% | 3262.2 ± 0.3% | 479.6 ± 0.4% | 6028.5 ± 0.5% | 755.3 ± 2.6% | 3.261 | 3.608 | 24.538 | 1.952 | 15.582 |
| hex: http/js-1m | 524290 | 11968.3 ± 0.3% | 3619.8 ± 0.2% | 3285.4 ± 0.5% | 502.6 ± 0.9% | 6061.4 ± 1.0% | 760.6 ± 2.5% | 3.306 | 3.643 | 23.813 | 1.975 | 15.735 |
| hex: http/css-1kx1024 | 2099200 | 8813.7 ± 1.4% | 3459.1 ± 0.3% | 2854.1 ± 0.5% | 488.6 ± 0.7% | 5125.2 ± 0.5% | 630.7 ± 2.8% | 2.548 | 3.088 | 18.038 | 1.720 | 13.975 |
| hex: http/css-16kx64 | 2097280 | 11767.1 ± 0.2% | 3610.3 ± 0.1% | 3257.8 ± 0.3% | 493.6 ± 0.3% | 6011.8 ± 0.6% | 743.3 ± 2.1% | 3.259 | 3.612 | 23.841 | 1.957 | 15.831 |
| hex: http/css-1m | 524290 | 12008.3 ± 0.2% | 3611.4 ± 0.2% | 3297.6 ± 0.2% | 501.4 ± 2.0% | 6085.5 ± 0.6% | 743.7 ± 2.3% | 3.325 | 3.642 | 23.948 | 1.973 | 16.147 |
| hex: shuffled/dickens-1m | 524290 | 11966.4 ± 0.2% | 3612.5 ± 0.1% | 3288.5 ± 0.2% | 526.3 ± 0.2% | 6093.2 ± 1.3% | 758.4 ± 2.9% | 3.313 | 3.639 | 22.735 | 1.964 | 15.779 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1354.3 ± 0.5% | 1252.3 ± 0.4% | 1040.7 ± 1.0% | 409.8 ± 0.8% | 448.1 ± 0.1% | 414.7 ± 0.4% | 1.081 | 1.301 | 3.305 | 3.022 | 3.266 |
| qlog records, JSON text sequence | 1467503 | 1052.4 ± 0.1% | 1063.6 ± 0.2% | 778.0 ± 0.6% | 378.3 ± 1.4% | 467.4 ± 0.2% | 278.7 ± 0.6% | 0.989 | 1.353 | 2.782 | 2.252 | 3.776 |
| string: silesia/dickens | 172528 | 6910.1 ± 0.3% | 2820.5 ± 0.5% | 2920.8 ± 0.7% | 429.4 ± 0.5% | 1570.5 ± 0.1% | 1011.9 ± 0.1% | 2.450 | 2.366 | 16.094 | 4.400 | 6.829 |
| string: silesia/nci | 1075110 | 7325.4 ± 0.4% | 3437.2 ± 0.8% | 3098.1 ± 0.4% | 816.2 ± 0.8% | 1851.9 ± 0.2% | 1111.1 ± 0.3% | 2.131 | 2.364 | 8.975 | 3.956 | 6.593 |
| string: silesia/reymont | 1075159 | 3343.5 ± 1.1% | 1979.5 ± 0.5% | 2061.8 ± 0.5% | 449.7 ± 1.2% | 1510.4 ± 0.4% | 948.7 ± 0.8% | 1.689 | 1.622 | 7.435 | 2.214 | 3.524 |
| string: silesia/samba | 97582 | 4207.8 ± 0.6% | 2111.0 ± 1.7% | 3448.6 ± 0.2% | 353.5 ± 1.0% | 1434.6 ± 0.5% | 1054.5 ± 0.3% | 1.993 | 1.220 | 11.902 | 2.933 | 3.990 |
| string: silesia/webster | 1098490 | 4070.0 ± 0.6% | 1885.3 ± 0.4% | 2052.8 ± 0.2% | 440.1 ± 0.6% | 1387.1 ± 0.1% | 645.1 ± 0.3% | 2.159 | 1.983 | 9.249 | 2.934 | 6.309 |
| string: silesia/xml | 1090118 | 6112.1 ± 0.4% | 2875.1 ± 0.5% | 2648.2 ± 0.3% | 609.0 ± 0.3% | 1746.4 ± 0.3% | 919.1 ± 1.0% | 2.126 | 2.308 | 10.036 | 3.500 | 6.650 |
| string: canterbury/alice29.txt | 159425 | 6466.0 ± 1.2% | 2196.5 ± 0.5% | 2760.1 ± 0.5% | 407.8 ± 0.6% | 1463.6 ± 0.2% | 955.2 ± 0.1% | 2.944 | 2.343 | 15.855 | 4.418 | 6.769 |
| string: canterbury/asyoulik.txt | 132198 | 5689.0 ± 0.9% | 1713.3 ± 0.5% | 2371.8 ± 1.1% | 401.8 ± 0.6% | 1335.1 ± 0.5% | 886.3 ± 0.2% | 3.321 | 2.399 | 14.158 | 4.261 | 6.419 |
| string: canterbury/lcet10.txt | 441884 | 6262.0 ± 0.4% | 2553.6 ± 0.5% | 2503.2 ± 2.1% | 467.9 ± 0.5% | 1522.1 ± 0.3% | 984.1 ± 0.6% | 2.452 | 2.502 | 13.384 | 4.114 | 6.363 |
| string: canterbury/plrabn12.txt | 503330 | 5703.4 ± 0.7% | 2049.2 ± 0.2% | 2067.2 ± 0.3% | 422.8 ± 0.9% | 1405.3 ± 0.2% | 933.9 ± 0.3% | 2.783 | 2.759 | 13.491 | 4.058 | 6.107 |
| string: canterbury-large/E.coli | 1048578 | 19207.2 ± 1.8% | 9646.1 ± 1.1% | 3786.8 ± 0.4% | 1477.4 ± 0.5% | 2358.6 ± 0.5% | 1195.3 ± 0.5% | 1.991 | 5.072 | 13.000 | 8.143 | 16.068 |
| string: canterbury-large/bible.txt | 1055886 | 6788.5 ± 0.4% | 4122.3 ± 1.2% | 3061.2 ± 1.2% | 500.9 ± 0.5% | 1977.4 ± 0.6% | 1117.2 ± 0.7% | 1.647 | 2.218 | 13.554 | 3.433 | 6.076 |
| string: canterbury-large/world192.txt | 1103121 | 4056.5 ± 0.4% | 1654.8 ± 0.6% | 1991.5 ± 1.0% | 448.8 ± 0.9% | 1356.7 ± 0.2% | 906.3 ± 0.6% | 2.451 | 2.037 | 9.038 | 2.990 | 4.476 |
| string: http/html-1m | 1058582 | 6772.6 ± 1.4% | 3972.6 ± 0.7% | 3037.6 ± 0.5% | 500.4 ± 0.9% | 1929.8 ± 0.5% | 805.7 ± 0.3% | 1.705 | 2.230 | 13.534 | 3.509 | 8.405 |
| string: http/json-1m | 1190272 | 3166.5 ± 0.6% | 1350.3 ± 0.2% | 1555.0 ± 0.3% | 444.8 ± 0.6% | 962.2 ± 0.3% | 765.3 ± 1.0% | 2.345 | 2.036 | 7.119 | 3.291 | 4.137 |
| string: http/js-1m | 1144362 | 2770.3 ± 0.9% | 1180.3 ± 0.5% | 1625.5 ± 0.5% | 369.1 ± 0.5% | 1093.8 ± 0.2% | 758.4 ± 0.7% | 2.347 | 1.704 | 7.506 | 2.533 | 3.653 |
| string: http/css-1m | 1097820 | 4009.7 ± 0.9% | 1488.0 ± 0.6% | 2147.6 ± 0.9% | 494.7 ± 0.2% | 1369.4 ± 0.3% | 895.7 ± 0.5% | 2.695 | 1.867 | 8.105 | 2.928 | 4.477 |
| string: dickens as Cyrillic and CJK | 1883069 | 3070.8 ± 0.8% | 2339.8 ± 0.5% | 521.7 ± 0.6% | 306.3 ± 1.2% | 564.2 ± 0.7% | 336.2 ± 0.2% | 1.312 | 5.886 | 10.024 | 5.443 | 9.135 |
| hex: silesia/dickens | 524290 | 15687.2 ± 0.1% | 1460.1 ± 0.4% | 1082.4 ± 0.3% | 491.7 ± 1.9% | 991.4 ± 0.2% | 731.4 ± 0.5% | 10.744 | 14.493 | 31.907 | 15.823 | 21.448 |
| hex: silesia/mozilla | 524290 | 15690.7 ± 0.2% | 1470.3 ± 0.4% | 1087.7 ± 0.3% | 441.6 ± 0.6% | 991.5 ± 0.3% | 735.2 ± 0.5% | 10.672 | 14.426 | 35.535 | 15.825 | 21.341 |
| hex: silesia/mr | 524290 | 15635.9 ± 0.4% | 1482.3 ± 0.3% | 1091.9 ± 0.4% | 545.9 ± 3.4% | 993.0 ± 0.3% | 733.3 ± 0.5% | 10.549 | 14.319 | 28.644 | 15.745 | 21.323 |
| hex: silesia/nci | 524290 | 15506.8 ± 0.7% | 1470.9 ± 0.6% | 1088.0 ± 0.7% | 632.0 ± 4.5% | 987.9 ± 0.7% | 734.6 ± 0.5% | 10.542 | 14.253 | 24.536 | 15.697 | 21.108 |
| hex: silesia/ooffice | 524290 | 15585.5 ± 0.2% | 1463.8 ± 0.2% | 1082.6 ± 0.3% | 389.3 ± 0.4% | 989.9 ± 0.6% | 733.8 ± 0.4% | 10.648 | 14.396 | 40.035 | 15.744 | 21.240 |
| hex: silesia/osdb | 524290 | 15654.1 ± 0.3% | 1467.8 ± 0.2% | 1085.2 ± 0.4% | 466.9 ± 1.0% | 990.8 ± 0.4% | 735.0 ± 0.5% | 10.665 | 14.426 | 33.524 | 15.800 | 21.299 |
| hex: silesia/reymont | 524290 | 15608.8 ± 0.2% | 1461.1 ± 0.5% | 1082.2 ± 0.3% | 514.8 ± 0.8% | 988.2 ± 0.8% | 732.6 ± 0.4% | 10.683 | 14.423 | 30.318 | 15.795 | 21.307 |
| hex: silesia/samba | 524290 | 15687.7 ± 0.3% | 1466.0 ± 0.3% | 1085.4 ± 0.2% | 403.4 ± 0.7% | 985.8 ± 0.5% | 733.7 ± 0.5% | 10.701 | 14.454 | 38.887 | 15.913 | 21.382 |
| hex: silesia/sao | 524290 | 15665.8 ± 0.3% | 1462.3 ± 0.5% | 1082.8 ± 0.4% | 332.3 ± 1.0% | 985.7 ± 0.7% | 731.8 ± 0.7% | 10.713 | 14.468 | 47.146 | 15.893 | 21.408 |
| hex: silesia/webster | 524290 | 15669.3 ± 0.7% | 1464.7 ± 0.4% | 1083.8 ± 0.2% | 473.5 ± 0.7% | 989.3 ± 0.5% | 734.3 ± 0.3% | 10.698 | 14.457 | 33.090 | 15.838 | 21.340 |
| hex: silesia/x-ray | 524290 | 15637.2 ± 0.3% | 1475.5 ± 0.4% | 1089.6 ± 0.3% | 445.1 ± 1.1% | 992.7 ± 0.9% | 734.5 ± 0.3% | 10.598 | 14.351 | 35.131 | 15.753 | 21.290 |
| hex: silesia/xml | 524290 | 15617.9 ± 0.7% | 1465.5 ± 0.4% | 1086.9 ± 0.3% | 610.2 ± 1.1% | 991.8 ± 0.4% | 734.4 ± 0.4% | 10.657 | 14.369 | 25.596 | 15.747 | 21.265 |
| hex: canterbury/alice29.txt | 304180 | 15660.6 ± 0.2% | 1466.1 ± 0.8% | 1092.6 ± 0.1% | 505.6 ± 1.2% | 991.5 ± 0.4% | 734.9 ± 0.9% | 10.682 | 14.333 | 30.973 | 15.794 | 21.309 |
| hex: canterbury/asyoulik.txt | 250360 | 15722.5 ± 0.0% | 1468.7 ± 0.4% | 1092.9 ± 0.2% | 498.6 ± 1.0% | 997.8 ± 0.4% | 740.3 ± 0.4% | 10.705 | 14.387 | 31.535 | 15.758 | 21.238 |
| hex: canterbury/cp.html | 49208 | 15669.0 ± 0.0% | 1479.6 ± 0.4% | 1096.6 ± 0.1% | 533.8 ± 1.6% | 1000.7 ± 0.4% | 743.9 ± 0.2% | 10.590 | 14.289 | 29.355 | 15.658 | 21.063 |
| hex: canterbury/fields.c | 22302 | 15520.0 ± 0.1% | 1413.8 ± 0.7% | 1063.9 ± 0.5% | 614.0 ± 5.6% | 995.3 ± 0.1% | 737.4 ± 0.2% | 10.977 | 14.588 | 25.278 | 15.593 | 21.047 |
| hex: canterbury/grammar.lsp | 7444 | 15152.4 ± 0.3% | 1508.6 ± 0.2% | 1087.9 ± 0.4% | 663.0 ± 3.7% | 996.9 ± 0.3% | 725.9 ± 0.1% | 10.044 | 13.928 | 22.855 | 15.200 | 20.875 |
| hex: canterbury/kennedy.xls | 524290 | 15517.5 ± 0.5% | 1472.0 ± 0.2% | 1088.3 ± 0.4% | 659.2 ± 1.2% | 988.9 ± 0.2% | 733.7 ± 0.5% | 10.542 | 14.258 | 23.540 | 15.692 | 21.148 |
| hex: canterbury/lcet10.txt | 524290 | 15533.4 ± 0.5% | 1461.1 ± 0.2% | 1082.4 ± 0.3% | 495.5 ± 1.9% | 992.8 ± 0.6% | 734.6 ± 0.4% | 10.631 | 14.351 | 31.351 | 15.645 | 21.144 |
| hex: canterbury/plrabn12.txt | 524290 | 15607.9 ± 0.4% | 1461.6 ± 0.5% | 1082.0 ± 0.5% | 489.0 ± 2.5% | 984.7 ± 0.3% | 733.2 ± 0.7% | 10.679 | 14.425 | 31.920 | 15.850 | 21.287 |
| hex: canterbury/ptt5 | 524290 | 15573.6 ± 0.3% | 1477.2 ± 0.2% | 1092.4 ± 0.3% | 553.7 ± 0.5% | 991.3 ± 0.6% | 734.1 ± 0.5% | 10.542 | 14.257 | 28.125 | 15.711 | 21.215 |
| hex: canterbury/sum | 76482 | 15676.7 ± 0.0% | 1494.9 ± 0.2% | 1103.6 ± 0.1% | 584.1 ± 1.2% | 998.3 ± 0.0% | 744.7 ± 0.2% | 10.487 | 14.205 | 26.838 | 15.703 | 21.050 |
| hex: canterbury/xargs.1 | 8456 | 15198.0 ± 0.0% | 1492.5 ± 0.4% | 1076.3 ± 0.4% | 658.7 ± 4.4% | 1003.0 ± 0.1% | 727.9 ± 0.1% | 10.183 | 14.121 | 23.071 | 15.153 | 20.879 |
| hex: canterbury-large/E.coli | 524290 | 15651.9 ± 0.6% | 1465.7 ± 0.2% | 1086.4 ± 0.7% | 671.6 ± 0.1% | 990.5 ± 0.7% | 733.6 ± 0.5% | 10.679 | 14.408 | 23.305 | 15.801 | 21.337 |
| hex: canterbury-large/bible.txt | 524290 | 15629.2 ± 0.7% | 1462.3 ± 0.3% | 1084.2 ± 0.3% | 514.3 ± 0.6% | 992.4 ± 0.7% | 735.5 ± 0.7% | 10.688 | 14.416 | 30.390 | 15.749 | 21.251 |
| hex: canterbury-large/world192.txt | 524290 | 15561.9 ± 0.5% | 1457.4 ± 0.3% | 1081.8 ± 0.4% | 502.7 ± 0.4% | 986.5 ± 0.6% | 735.4 ± 0.2% | 10.678 | 14.385 | 30.959 | 15.776 | 21.162 |
| hex: http/html-1kx1024 | 2099200 | 14153.6 ± 0.5% | 1455.3 ± 0.1% | 1061.2 ± 0.1% | 500.8 ± 0.2% | 982.2 ± 0.1% | 692.4 ± 0.1% | 9.725 | 13.337 | 28.260 | 14.411 | 20.440 |
| hex: http/html-16kx64 | 2097280 | 15264.4 ± 0.4% | 1444.2 ± 0.2% | 1072.4 ± 0.2% | 506.2 ± 0.4% | 995.5 ± 0.1% | 734.1 ± 0.2% | 10.569 | 14.233 | 30.156 | 15.334 | 20.792 |
| hex: http/html-1m | 524290 | 15617.3 ± 0.5% | 1464.3 ± 1.3% | 1083.7 ± 0.5% | 498.1 ± 0.3% | 988.2 ± 0.9% | 733.4 ± 1.0% | 10.665 | 14.411 | 31.355 | 15.804 | 21.294 |
| hex: http/json-1kx1024 | 2099200 | 14119.8 ± 26.8% | 1463.3 ± 0.2% | 1065.5 ± 0.3% | 608.3 ± 0.4% | 986.1 ± 0.1% | 692.3 ± 0.3% | 9.649 | 13.251 | 23.211 | 14.318 | 20.396 |
| hex: http/json-16kx64 | 2097280 | 15301.9 ± 2.3% | 1445.9 ± 0.2% | 1073.9 ± 0.1% | 615.9 ± 0.8% | 994.9 ± 0.2% | 734.5 ± 0.1% | 10.583 | 14.249 | 24.846 | 15.380 | 20.834 |
| hex: http/json-1m | 524290 | 15662.1 ± 0.2% | 1474.1 ± 0.2% | 1088.2 ± 0.3% | 633.2 ± 0.5% | 994.7 ± 0.7% | 735.0 ± 0.5% | 10.625 | 14.393 | 24.734 | 15.745 | 21.309 |
| hex: http/js-1kx1024 | 2099200 | 14084.6 ± 0.4% | 1454.4 ± 0.3% | 1062.4 ± 0.2% | 498.8 ± 0.1% | 982.8 ± 0.2% | 692.7 ± 0.3% | 9.684 | 13.257 | 28.238 | 14.332 | 20.334 |
| hex: http/js-16kx64 | 2097280 | 15277.3 ± 1.0% | 1443.8 ± 0.2% | 1073.7 ± 0.1% | 503.3 ± 0.5% | 996.6 ± 0.5% | 734.9 ± 0.5% | 10.581 | 14.228 | 30.355 | 15.330 | 20.790 |
| hex: http/js-1m | 524290 | 15576.5 ± 0.7% | 1462.4 ± 0.3% | 1085.0 ± 0.4% | 509.1 ± 0.3% | 986.5 ± 0.4% | 733.8 ± 0.5% | 10.651 | 14.356 | 30.597 | 15.789 | 21.228 |
| hex: http/css-1kx1024 | 2099200 | 14113.4 ± 0.6% | 1455.5 ± 0.1% | 1061.4 ± 0.1% | 531.4 ± 0.3% | 983.3 ± 0.1% | 692.7 ± 0.1% | 9.696 | 13.296 | 26.558 | 14.354 | 20.376 |
| hex: http/css-16kx64 | 2097280 | 15290.4 ± 17.3% | 1444.1 ± 0.2% | 1073.5 ± 0.2% | 539.3 ± 0.7% | 999.3 ± 0.2% | 734.8 ± 0.4% | 10.588 | 14.244 | 28.350 | 15.301 | 20.810 |
| hex: http/css-1m | 524290 | 15699.9 ± 0.6% | 1465.3 ± 0.5% | 1085.1 ± 0.5% | 525.4 ± 0.4% | 991.4 ± 0.4% | 735.4 ± 1.6% | 10.715 | 14.468 | 29.884 | 15.837 | 21.349 |
| hex: shuffled/dickens-1m | 524290 | 15604.8 ± 0.3% | 1461.6 ± 0.3% | 1085.7 ± 0.1% | 498.6 ± 2.5% | 986.1 ± 0.3% | 735.0 ± 0.4% | 10.677 | 14.374 | 31.296 | 15.825 | 21.232 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.916 of yyjson.
