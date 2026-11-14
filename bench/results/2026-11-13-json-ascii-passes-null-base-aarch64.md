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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43464717657 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1131.4 ± 0.4% | 0.522 | 0.964 | 0.995 | 0.997 | 0.459 | 1.000 | 1.005 | 0.387 | 0.829 | 0.896 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 860.1 ± 1.2% | 0.813 | 0.993 | 0.996 | 0.994 | 0.442 | 0.991 | 1.021 | 0.395 | 0.915 | 0.981 | 0.123 |
| string: silesia/dickens | 172528 | 5056.1 ± 0.7% | 0.033 | 0.781 | 1.002 | 1.002 | 0.196 | 1.017 | 1.005 | 0.196 | 1.000 | 1.000 | 0.032 |
| string: silesia/nci | 1075110 | 4314.1 ± 0.9% | 0.039 | 0.799 | 1.000 | 1.000 | 0.279 | 1.004 | 0.994 | 0.278 | 1.000 | 1.001 | 0.038 |
| string: silesia/reymont | 1075159 | 2951.0 ± 3.2% | 0.057 | 0.812 | 1.002 | 1.006 | 0.357 | 0.999 | 1.003 | 0.357 | 1.012 | 1.013 | 0.056 |
| string: silesia/samba | 97582 | 3498.5 ± 0.7% | 0.040 | 0.859 | 1.001 | 1.004 | 0.068 | 0.778 | 1.009 | 0.072 | 1.001 | 1.004 | 0.039 |
| string: silesia/webster | 1098490 | 3650.4 ± 0.5% | 0.044 | 0.847 | 1.002 | 1.005 | 0.203 | 1.014 | 1.015 | 0.203 | 1.008 | 1.007 | 0.044 |
| string: silesia/xml | 1090118 | 4784.2 ± 0.6% | 0.035 | 0.806 | 1.006 | 1.008 | 0.221 | 0.978 | 1.004 | 0.224 | 1.007 | 1.007 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4303.2 ± 0.9% | 0.038 | 0.751 | 1.004 | 1.007 | 0.172 | 1.034 | 1.019 | 0.172 | 1.011 | 1.012 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3463.1 ± 0.9% | 0.046 | 0.747 | 1.003 | 1.007 | 0.176 | 1.001 | 0.965 | 0.175 | 1.007 | 1.008 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5131.6 ± 0.4% | 0.032 | 0.811 | 1.001 | 1.002 | 0.195 | 1.017 | 1.005 | 0.194 | 1.003 | 1.002 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4116.3 ± 1.5% | 0.040 | 0.826 | 1.006 | 1.006 | 0.199 | 1.013 | 0.998 | 0.198 | 1.006 | 1.007 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19237.4 ± 1.2% | 0.077 | 1.007 | 1.007 | 1.007 | 0.480 | 1.006 | 1.007 | 0.481 | 0.620 | 0.620 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6688.9 ± 1.5% | 0.026 | 0.804 | 1.001 | 1.004 | 0.433 | 1.031 | 1.041 | 0.432 | 1.033 | 1.037 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3381.3 ± 0.7% | 0.048 | 0.847 | 1.001 | 1.003 | 0.197 | 1.015 | 1.008 | 0.198 | 1.003 | 1.004 | 0.047 |
| string: http/html-1m | 1058582 | 6054.3 ± 1.4% | 0.028 | 0.781 | 1.021 | 1.040 | 0.390 | 1.043 | 1.055 | 0.388 | 1.032 | 1.037 | 0.028 |
| string: http/json-1m | 1190272 | 2550.3 ± 0.5% | 0.055 | 0.950 | 1.003 | 1.002 | 0.111 | 1.004 | 0.470 | 0.111 | 1.004 | 1.004 | 0.055 |
| string: http/js-1m | 1144362 | 2289.1 ± 0.6% | 0.066 | 0.885 | 0.999 | 1.001 | 0.174 | 1.051 | 1.043 | 0.174 | 0.997 | 1.000 | 0.065 |
| string: http/css-1m | 1097820 | 2630.3 ± 1.2% | 0.061 | 0.779 | 1.008 | 1.014 | 0.241 | 1.011 | 1.015 | 0.240 | 1.009 | 1.012 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3077.6 ± 0.4% | 0.044 | 0.124 | 1.002 | 1.002 | 0.335 | 0.996 | 1.007 | 0.335 | 1.002 | 1.001 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.3 ± 1.2% | 0.081 | 1.004 | 1.002 | 1.000 | 0.076 | 0.637 | 1.005 | 0.081 | 1.002 | 1.000 | 0.081 |
| hex: silesia/dickens | 524290 | 18566.4 ± 0.5% | 0.080 | 1.008 | 1.002 | 1.000 | 0.517 | 0.999 | 1.002 | 0.516 | 0.647 | 0.647 | 0.009 |
| hex: silesia/mozilla | 524290 | 19021.6 ± 1.3% | 0.078 | 1.010 | 1.008 | 1.007 | 0.505 | 1.004 | 1.005 | 0.504 | 0.631 | 0.630 | 0.009 |
| hex: silesia/mr | 524290 | 18811.8 ± 0.7% | 0.079 | 1.003 | 0.995 | 0.994 | 0.509 | 0.994 | 0.994 | 0.511 | 0.638 | 0.637 | 0.009 |
| hex: silesia/nci | 524290 | 18806.6 ± 0.3% | 0.079 | 1.006 | 1.004 | 1.004 | 0.507 | 1.005 | 1.004 | 0.507 | 0.639 | 0.639 | 0.009 |
| hex: silesia/ooffice | 524290 | 18813.8 ± 0.5% | 0.079 | 1.008 | 1.003 | 1.002 | 0.513 | 1.005 | 1.003 | 0.512 | 0.638 | 0.637 | 0.009 |
| hex: silesia/osdb | 524290 | 18704.3 ± 1.0% | 0.080 | 1.001 | 1.002 | 1.002 | 0.519 | 1.004 | 0.999 | 0.520 | 0.642 | 0.642 | 0.009 |
| hex: silesia/reymont | 524290 | 18994.8 ± 0.4% | 0.078 | 0.999 | 0.999 | 0.998 | 0.507 | 0.995 | 0.996 | 0.508 | 0.632 | 0.632 | 0.009 |
| hex: silesia/samba | 524290 | 18649.2 ± 0.4% | 0.080 | 1.004 | 1.005 | 1.004 | 0.523 | 1.000 | 1.003 | 0.524 | 0.644 | 0.644 | 0.009 |
| hex: silesia/sao | 524290 | 18965.9 ± 0.8% | 0.079 | 1.008 | 1.000 | 0.996 | 0.515 | 1.004 | 0.998 | 0.512 | 0.634 | 0.634 | 0.009 |
| hex: silesia/webster | 524290 | 18785.2 ± 0.5% | 0.079 | 1.015 | 1.009 | 1.008 | 0.510 | 1.010 | 1.008 | 0.508 | 0.638 | 0.638 | 0.009 |
| hex: silesia/x-ray | 524290 | 18753.0 ± 1.0% | 0.079 | 1.007 | 1.005 | 1.006 | 0.519 | 1.009 | 1.007 | 0.516 | 0.639 | 0.639 | 0.009 |
| hex: silesia/xml | 524290 | 19057.6 ± 0.5% | 0.078 | 1.002 | 0.996 | 1.000 | 0.513 | 0.998 | 0.995 | 0.514 | 0.629 | 0.629 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19556.1 ± 0.1% | 0.077 | 1.002 | 1.002 | 1.001 | 0.513 | 1.002 | 1.002 | 0.514 | 0.614 | 0.614 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19525.4 ± 0.1% | 0.077 | 1.001 | 1.004 | 1.003 | 0.514 | 1.003 | 1.003 | 0.514 | 0.615 | 0.615 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19159.5 ± 0.7% | 0.081 | 1.006 | 1.006 | 1.006 | 0.543 | 1.006 | 1.006 | 0.544 | 0.622 | 0.622 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18882.2 ± 0.7% | 0.085 | 1.004 | 1.005 | 1.005 | 0.534 | 1.003 | 1.001 | 0.540 | 0.624 | 0.624 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17440.8 ± 1.0% | 0.089 | 1.009 | 1.009 | 1.009 | 0.529 | 1.008 | 1.008 | 0.547 | 0.645 | 0.649 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18693.6 ± 3.2% | 0.080 | 1.011 | 1.009 | 1.009 | 0.523 | 1.008 | 1.006 | 0.519 | 0.643 | 0.643 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18986.5 ± 1.4% | 0.078 | 1.009 | 0.996 | 0.995 | 0.505 | 0.993 | 0.994 | 0.506 | 0.632 | 0.632 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18846.9 ± 0.6% | 0.079 | 1.008 | 1.002 | 1.001 | 0.502 | 0.999 | 0.999 | 0.501 | 0.634 | 0.635 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 18789.3 ± 0.8% | 0.080 | 1.003 | 1.004 | 1.008 | 0.523 | 1.005 | 1.003 | 0.524 | 0.638 | 0.639 | 0.009 |
| hex: canterbury/sum | 76482 | 19295.2 ± 0.5% | 0.078 | 1.002 | 1.002 | 1.002 | 0.518 | 1.002 | 1.002 | 0.519 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17790.4 ± 0.1% | 0.085 | 1.002 | 1.003 | 1.003 | 0.526 | 1.002 | 1.002 | 0.541 | 0.637 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18978.8 ± 0.8% | 0.078 | 0.999 | 0.993 | 0.994 | 0.505 | 0.998 | 0.995 | 0.505 | 0.631 | 0.631 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18944.5 ± 1.1% | 0.079 | 1.006 | 1.006 | 1.006 | 0.505 | 0.998 | 1.008 | 0.505 | 0.633 | 0.633 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18461.4 ± 0.6% | 0.081 | 1.008 | 1.009 | 1.009 | 0.532 | 1.011 | 1.008 | 0.529 | 0.651 | 0.651 | 0.009 |
| hex: http/html-1kx1024 | 2099200 | 9775.2 ± 18.8% | 0.146 | 1.231 | 1.233 | 1.231 | 0.678 | 1.239 | 0.984 | 0.741 | 0.907 | 0.912 | 0.018 |
| hex: http/html-16kx64 | 2097280 | 18356.6 ± 1.5% | 0.082 | 1.016 | 1.016 | 1.014 | 0.556 | 1.015 | 1.000 | 0.562 | 0.642 | 0.642 | 0.009 |
| hex: http/html-1m | 524290 | 18646.9 ± 2.6% | 0.080 | 1.011 | 1.007 | 1.009 | 0.524 | 1.012 | 1.011 | 0.522 | 0.645 | 0.645 | 0.009 |
| hex: http/json-1kx1024 | 2099200 | 10593.7 ± 17.2% | 0.134 | 1.131 | 1.133 | 1.134 | 0.625 | 1.151 | 1.001 | 0.681 | 0.832 | 0.835 | 0.016 |
| hex: http/json-16kx64 | 2097280 | 18391.4 ± 1.5% | 0.080 | 1.014 | 1.011 | 1.012 | 0.554 | 1.012 | 1.000 | 0.559 | 0.640 | 0.640 | 0.009 |
| hex: http/json-1m | 524290 | 18678.3 ± 0.6% | 0.080 | 1.006 | 1.002 | 1.001 | 0.519 | 0.996 | 0.997 | 0.519 | 0.643 | 0.643 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 9647.2 ± 19.5% | 0.148 | 1.255 | 1.252 | 1.244 | 0.688 | 1.261 | 0.989 | 0.746 | 0.916 | 0.918 | 0.018 |
| hex: http/js-16kx64 | 2097280 | 18371.0 ± 1.8% | 0.080 | 1.015 | 1.013 | 1.013 | 0.556 | 1.013 | 1.001 | 0.561 | 0.640 | 0.641 | 0.009 |
| hex: http/js-1m | 524290 | 18876.7 ± 1.9% | 0.079 | 1.001 | 1.000 | 1.000 | 0.515 | 0.995 | 0.996 | 0.515 | 0.637 | 0.637 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9685.2 ± 18.8% | 0.147 | 1.239 | 1.251 | 1.258 | 0.685 | 1.253 | 0.977 | 0.746 | 0.917 | 0.918 | 0.018 |
| hex: http/css-16kx64 | 2097280 | 18334.5 ± 1.5% | 0.081 | 1.017 | 1.015 | 1.015 | 0.557 | 1.014 | 1.001 | 0.563 | 0.642 | 0.642 | 0.009 |
| hex: http/css-1m | 524290 | 18800.9 ± 1.1% | 0.079 | 1.009 | 1.003 | 1.003 | 0.520 | 1.006 | 1.006 | 0.520 | 0.639 | 0.639 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18713.0 ± 0.9% | 0.079 | 1.003 | 1.003 | 1.003 | 0.516 | 1.002 | 0.998 | 0.518 | 0.642 | 0.642 | 0.009 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1481.4 ± 0.7% | 0.444 | 1.004 | 0.968 | 1.008 | 1.009 | 0.268 | 0.998 | 0.547 | 0.918 | 0.089 | 1.030 |
| qlog records, JSON text sequence | 1467503 | 1264.3 ± 0.7% | 0.692 | 0.978 | 1.009 | 1.010 | 1.011 | 0.265 | 0.999 | 0.500 | 0.827 | 0.106 | 1.015 |
| string: silesia/dickens | 172528 | 6895.3 ± 0.3% | 0.025 | 1.001 | 1.002 | 1.002 | 1.002 | 0.167 | 0.717 | 1.003 | 1.003 | 0.025 | 1.036 |
| string: silesia/nci | 1075110 | 7311.2 ± 1.0% | 0.024 | 1.001 | 1.001 | 1.000 | 1.000 | 0.211 | 0.565 | 1.001 | 1.001 | 0.024 | 1.010 |
| string: silesia/reymont | 1075159 | 3347.1 ± 1.2% | 0.051 | 0.994 | 0.995 | 0.999 | 0.999 | 0.389 | 0.869 | 0.997 | 0.998 | 0.052 | 1.046 |
| string: silesia/samba | 97582 | 4183.4 ± 0.4% | 0.053 | 1.001 | 1.002 | 1.005 | 1.006 | 0.125 | 0.921 | 1.001 | 1.005 | 0.054 | 1.095 |
| string: silesia/webster | 1098490 | 4053.5 ± 0.3% | 0.043 | 1.013 | 1.008 | 1.008 | 1.007 | 0.212 | 0.887 | 1.000 | 1.007 | 0.043 | 1.011 |
| string: silesia/xml | 1090118 | 6118.8 ± 0.8% | 0.029 | 1.003 | 0.999 | 1.004 | 1.004 | 0.254 | 0.775 | 1.003 | 1.003 | 0.029 | 1.017 |
| string: canterbury/alice29.txt | 159425 | 6381.3 ± 2.1% | 0.027 | 1.010 | 1.013 | 1.015 | 1.015 | 0.133 | 0.658 | 1.008 | 1.010 | 0.027 | 1.066 |
| string: canterbury/asyoulik.txt | 132198 | 5586.4 ± 1.2% | 0.030 | 1.023 | 1.027 | 1.028 | 1.034 | 0.130 | 0.597 | 1.001 | 1.009 | 0.030 | 1.035 |
| string: canterbury/lcet10.txt | 441884 | 6257.0 ± 0.5% | 0.027 | 1.005 | 1.006 | 1.006 | 1.006 | 0.184 | 0.799 | 1.001 | 1.002 | 0.028 | 0.998 |
| string: canterbury/plrabn12.txt | 503330 | 5710.3 ± 0.5% | 0.030 | 1.002 | 1.004 | 1.001 | 1.002 | 0.168 | 0.698 | 1.002 | 1.003 | 0.030 | 1.010 |
| string: canterbury-large/E.coli | 1048578 | 19347.8 ± 0.8% | 0.077 | 0.998 | 0.997 | 0.997 | 0.999 | 0.481 | 1.002 | 0.997 | 0.999 | 0.009 | 1.000 |
| string: canterbury-large/bible.txt | 1055886 | 6774.2 ± 0.1% | 0.026 | 1.003 | 1.003 | 1.003 | 1.003 | 0.496 | 0.974 | 1.002 | 1.003 | 0.026 | 1.005 |
| string: canterbury-large/world192.txt | 1103121 | 4017.2 ± 0.3% | 0.043 | 1.020 | 1.018 | 1.019 | 1.022 | 0.193 | 0.831 | 1.003 | 1.010 | 0.043 | 1.005 |
| string: http/html-1m | 1058582 | 6735.6 ± 1.5% | 0.026 | 1.004 | 0.926 | 1.003 | 1.007 | 0.406 | 0.896 | 1.002 | 1.006 | 0.026 | 1.013 |
| string: http/json-1m | 1190272 | 3162.3 ± 0.2% | 0.051 | 1.001 | 0.967 | 1.002 | 1.001 | 0.133 | 0.371 | 1.001 | 1.002 | 0.051 | 1.044 |
| string: http/js-1m | 1144362 | 2762.0 ± 0.4% | 0.060 | 1.003 | 1.007 | 1.001 | 1.004 | 0.165 | 0.838 | 1.001 | 1.002 | 0.061 | 1.011 |
| string: http/css-1m | 1097820 | 3988.7 ± 0.8% | 0.042 | 1.008 | 1.005 | 1.004 | 1.009 | 0.208 | 0.646 | 1.002 | 1.007 | 0.043 | 1.010 |
| string: dickens as Cyrillic and CJK | 1883069 | 3066.8 ± 0.3% | 0.048 | 1.003 | 0.124 | 1.002 | 1.001 | 0.321 | 1.003 | 1.001 | 1.002 | 0.048 | 1.003 |
| hex: silesia/dickens | 524290 | 15650.6 ± 0.3% | 1.001 | 0.178 | 1.000 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.002 |
| hex: silesia/mozilla | 524290 | 15639.6 ± 0.1% | 1.003 | 0.178 | 1.002 | 1.000 | 1.000 | 1.000 | 1.002 | 1.003 | 1.002 | 0.178 | 1.003 |
| hex: silesia/mr | 524290 | 15687.2 ± 0.2% | 1.000 | 0.178 | 1.001 | 1.000 | 1.000 | 0.997 | 1.001 | 1.000 | 1.000 | 0.178 | 1.000 |
| hex: silesia/nci | 524290 | 15655.2 ± 0.2% | 1.000 | 0.178 | 0.998 | 0.999 | 1.001 | 0.996 | 0.997 | 0.997 | 0.997 | 0.178 | 0.996 |
| hex: silesia/ooffice | 524290 | 15649.6 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.001 | 1.000 | 0.998 | 1.000 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: silesia/osdb | 524290 | 15649.8 ± 0.2% | 1.000 | 0.178 | 1.001 | 1.001 | 1.000 | 0.999 | 0.999 | 1.000 | 1.001 | 0.178 | 1.001 |
| hex: silesia/reymont | 524290 | 15613.9 ± 0.2% | 1.000 | 0.178 | 1.000 | 1.001 | 1.001 | 0.999 | 1.000 | 0.998 | 1.001 | 0.178 | 1.000 |
| hex: silesia/samba | 524290 | 15678.8 ± 0.1% | 1.001 | 0.178 | 0.999 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 1.000 | 0.178 | 1.001 |
| hex: silesia/sao | 524290 | 15652.0 ± 0.3% | 1.000 | 0.178 | 0.998 | 0.999 | 1.000 | 0.997 | 0.998 | 0.999 | 0.999 | 0.177 | 0.998 |
| hex: silesia/webster | 524290 | 15677.4 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: silesia/x-ray | 524290 | 15630.5 ± 0.2% | 1.002 | 0.178 | 1.001 | 1.001 | 1.002 | 0.997 | 1.001 | 1.002 | 1.002 | 0.178 | 1.002 |
| hex: silesia/xml | 524290 | 15575.6 ± 0.1% | 1.002 | 0.179 | 1.000 | 1.002 | 1.002 | 1.000 | 1.002 | 1.002 | 1.003 | 0.178 | 1.000 |
| hex: canterbury/alice29.txt | 304180 | 15667.7 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15700.9 ± 0.0% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15620.1 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.998 | 1.000 | 1.001 | 1.002 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15440.0 ± 0.1% | 1.002 | 0.181 | 1.000 | 1.000 | 1.001 | 0.994 | 1.001 | 1.002 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14946.3 ± 0.1% | 1.003 | 0.185 | 1.001 | 1.000 | 1.001 | 0.983 | 1.001 | 1.005 | 1.014 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15645.4 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 0.178 | 1.002 |
| hex: canterbury/lcet10.txt | 524290 | 15632.7 ± 0.2% | 1.002 | 0.178 | 1.000 | 1.002 | 1.002 | 1.001 | 1.003 | 1.002 | 1.001 | 0.178 | 1.000 |
| hex: canterbury/plrabn12.txt | 524290 | 15655.6 ± 0.2% | 1.001 | 0.178 | 1.002 | 1.000 | 1.001 | 1.000 | 1.002 | 1.001 | 1.001 | 0.177 | 1.002 |
| hex: canterbury/ptt5 | 524290 | 15636.0 ± 0.1% | 1.000 | 0.179 | 0.998 | 1.000 | 0.999 | 0.998 | 0.998 | 1.000 | 1.001 | 0.179 | 0.998 |
| hex: canterbury/sum | 76482 | 15645.9 ± 0.0% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 1.000 | 1.002 | 0.178 | 1.000 |
| hex: canterbury/xargs.1 | 8456 | 15021.6 ± 0.2% | 1.001 | 0.185 | 1.000 | 1.000 | 1.000 | 0.984 | 1.000 | 1.002 | 1.012 | 0.183 | 1.002 |
| hex: canterbury-large/E.coli | 524290 | 15661.8 ± 0.1% | 1.000 | 0.178 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury-large/bible.txt | 524290 | 15638.9 ± 0.1% | 1.001 | 0.178 | 0.998 | 1.001 | 1.001 | 0.999 | 1.000 | 1.001 | 1.001 | 0.178 | 0.998 |
| hex: canterbury-large/world192.txt | 524290 | 15639.2 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 1.000 | 0.178 | 1.000 |
| hex: http/html-1kx1024 | 2099200 | 13769.5 ± 0.5% | 1.003 | 0.194 | 0.997 | 0.999 | 0.998 | 0.937 | 0.991 | 1.005 | 1.034 | 0.186 | 1.009 |
| hex: http/html-16kx64 | 2097280 | 15262.7 ± 0.4% | 1.002 | 0.181 | 1.002 | 1.001 | 1.001 | 0.997 | 1.002 | 1.007 | 1.006 | 0.179 | 1.003 |
| hex: http/html-1m | 524290 | 15689.4 ± 0.2% | 1.001 | 0.177 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: http/json-1kx1024 | 2099200 | 13677.8 ± 0.2% | 1.007 | 0.195 | 1.000 | 1.002 | 1.001 | 0.938 | 0.996 | 1.013 | 1.037 | 0.187 | 1.012 |
| hex: http/json-16kx64 | 2097280 | 15280.8 ± 0.5% | 0.999 | 0.180 | 0.998 | 0.999 | 1.000 | 0.989 | 0.997 | 1.001 | 1.004 | 0.179 | 0.999 |
| hex: http/json-1m | 524290 | 15663.3 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.002 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 0.178 | 1.002 |
| hex: http/js-1kx1024 | 2099200 | 13696.1 ± 0.5% | 1.009 | 0.195 | 1.001 | 1.002 | 1.003 | 0.945 | 1.002 | 1.011 | 1.037 | 0.187 | 1.014 |
| hex: http/js-16kx64 | 2097280 | 15270.4 ± 0.1% | 1.001 | 0.181 | 0.999 | 1.001 | 1.001 | 0.990 | 0.999 | 1.004 | 1.004 | 0.180 | 1.000 |
| hex: http/js-1m | 524290 | 15674.5 ± 0.1% | 1.001 | 0.177 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 0.999 | 1.001 | 0.177 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 13718.2 ± 0.1% | 1.008 | 0.195 | 1.000 | 1.001 | 1.003 | 0.940 | 1.001 | 1.006 | 1.035 | 0.186 | 1.012 |
| hex: http/css-16kx64 | 2097280 | 15260.2 ± 0.2% | 1.000 | 0.180 | 1.003 | 1.001 | 1.000 | 0.994 | 0.998 | 1.004 | 1.004 | 0.179 | 1.003 |
| hex: http/css-1m | 524290 | 15664.5 ± 0.1% | 1.002 | 0.177 | 1.001 | 1.000 | 1.001 | 1.000 | 1.000 | 1.001 | 1.001 | 0.177 | 1.000 |
| hex: shuffled/dickens-1m | 524290 | 15649.6 ± 0.3% | 1.001 | 0.178 | 0.999 | 0.999 | 1.001 | 1.000 | 1.002 | 1.001 | 1.002 | 0.177 | 1.000 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.055 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.051 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.231 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.233 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.231 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.239 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.255 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.252 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.244 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.261 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.239 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.251 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.258 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.253 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43345.7 ± 0.1% | 47400.2 ± 0.1% | 0.914 | — | — |
| string: silesia/nci | 1048576 | 37038.9 ± 1.7% | 39581.3 ± 1.0% | 0.936 | — | — |
| string: silesia/reymont | 1048576 | 37687.1 ± 2.4% | 41102.6 ± 3.8% | 0.917 | — | — |
| string: silesia/samba | 65546 | 43584.2 ± 0.0% | 48516.9 ± 0.0% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 37849.4 ± 1.4% | 41484.8 ± 2.0% | 0.912 | — | — |
| string: silesia/xml | 1048576 | 32543.4 ± 1.3% | 33611.8 ± 2.3% | 0.968 | — | — |
| string: canterbury/alice29.txt | 152089 | 35890.3 ± 0.1% | 36539.6 ± 0.1% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43333.7 ± 0.1% | 47650.8 ± 0.1% | 0.909 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36075.6 ± 0.5% | 36704.6 ± 0.5% | 0.983 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 43567.9 ± 0.1% | 47611.8 ± 0.1% | 0.915 | — | — |
| string: canterbury-large/E.coli | 1048576 | 37219.8 ± 3.0% | 39860.7 ± 1.6% | 0.934 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 33213.7 ± 1.0% | 34201.0 ± 1.1% | 0.971 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 33163.3 ± 2.0% | 34133.9 ± 1.7% | 0.972 | — | — |
| string: http/html-1m | 1048576 | 36828.1 ± 1.3% | 40058.0 ± 1.6% | 0.919 | — | — |
| string: http/json-1m | 1048576 | 31658.7 ± 3.0% | 33947.4 ± 4.4% | 0.933 | — | — |
| string: http/js-1m | 1048576 | 36642.3 ± 2.8% | 39682.3 ± 4.5% | 0.923 | — | — |
| string: http/css-1m | 1048576 | 37680.1 ± 0.9% | 40892.3 ± 1.2% | 0.921 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5767.7 ± 0.2% | 5649.9 ± 0.2% | 1.021 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.914 of simdutf.
- string: silesia/nci: stdx runs at 0.936 of simdutf.
- string: silesia/reymont: stdx runs at 0.917 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.912 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.909 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.915 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.934 of simdutf.
- string: http/html-1m: stdx runs at 0.919 of simdutf.
- string: http/json-1m: stdx runs at 0.933 of simdutf.
- string: http/js-1m: stdx runs at 0.923 of simdutf.
- string: http/css-1m: stdx runs at 0.921 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 39830.4 ± 1.8% | 43942.1 ± 1.5% | 0.906 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 33432.8 ± 0.5% | 34572.0 ± 0.4% | 0.967 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 37786.2 ± 1.3% | 40903.2 ± 0.8% | 0.924 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 39247.8 ± 2.0% | 43171.8 ± 2.1% | 0.909 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 38860.9 ± 0.8% | 42874.0 ± 2.2% | 0.906 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 38749.9 ± 4.5% | 42254.7 ± 1.6% | 0.917 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5752.9 ± 0.2% | 5639.0 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5755.3 ± 0.3% | 5640.4 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5758.5 ± 0.1% | 5638.0 ± 1.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5763.4 ± 0.1% | 5640.5 ± 0.1% | 1.022 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5757.6 ± 0.3% | 5640.6 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5759.2 ± 0.1% | 5639.4 ± 0.2% | 1.021 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1131.4 ± 0.4% | 935.8 ± 0.4% | 1023.9 ± 0.3% | 301.5 ± 0.4% | 664.5 ± 0.1% | 309.7 ± 1.8% | 1.209 | 1.105 | 3.753 | 1.702 | 3.653 |
| qlog records, JSON text sequence | 1467503 | 860.1 ± 1.2% | 818.7 ± 0.1% | 795.6 ± 1.0% | 245.0 ± 1.2% | 701.1 ± 0.9% | 251.7 ± 1.9% | 1.051 | 1.081 | 3.511 | 1.227 | 3.417 |
| string: silesia/dickens | 172528 | 5056.1 ± 0.7% | 1878.1 ± 0.2% | 2646.3 ± 0.5% | 362.8 ± 1.2% | 2856.2 ± 0.3% | 547.9 ± 1.2% | 2.692 | 1.911 | 13.937 | 1.770 | 9.229 |
| string: silesia/nci | 1075110 | 4314.1 ± 0.9% | 2243.6 ± 0.3% | 3001.1 ± 0.1% | 543.2 ± 1.2% | 3004.5 ± 0.8% | 603.0 ± 2.3% | 1.923 | 1.437 | 7.941 | 1.436 | 7.154 |
| string: silesia/reymont | 1075159 | 2951.0 ± 3.2% | 1820.5 ± 1.3% | 2064.4 ± 0.5% | 373.3 ± 0.9% | 2141.5 ± 0.7% | 537.3 ± 1.1% | 1.621 | 1.429 | 7.905 | 1.378 | 5.492 |
| string: silesia/samba | 97582 | 3498.5 ± 0.7% | 2026.5 ± 0.2% | 2617.7 ± 0.6% | 328.9 ± 0.6% | 1498.3 ± 0.3% | 431.6 ± 1.1% | 1.726 | 1.336 | 10.636 | 2.335 | 8.107 |
| string: silesia/webster | 1098490 | 3650.4 ± 0.5% | 1517.9 ± 0.3% | 2016.7 ± 0.3% | 359.6 ± 0.5% | 2178.4 ± 1.7% | 496.9 ± 1.4% | 2.405 | 1.810 | 10.152 | 1.676 | 7.346 |
| string: silesia/xml | 1090118 | 4784.2 ± 0.6% | 2362.1 ± 0.5% | 2526.4 ± 0.2% | 455.8 ± 0.6% | 2858.7 ± 0.7% | 568.4 ± 0.5% | 2.025 | 1.894 | 10.496 | 1.674 | 8.417 |
| string: canterbury/alice29.txt | 159425 | 4303.2 ± 0.9% | 1599.8 ± 0.2% | 2459.4 ± 0.3% | 343.3 ± 0.3% | 2501.8 ± 1.4% | 507.7 ± 1.5% | 2.690 | 1.750 | 12.536 | 1.720 | 8.476 |
| string: canterbury/asyoulik.txt | 132198 | 3463.1 ± 0.9% | 1459.0 ± 0.3% | 2247.3 ± 0.6% | 335.4 ± 1.1% | 2084.0 ± 0.4% | 466.1 ± 0.3% | 2.374 | 1.541 | 10.324 | 1.662 | 7.430 |
| string: canterbury/lcet10.txt | 441884 | 5131.6 ± 0.4% | 1854.4 ± 0.2% | 2343.6 ± 0.9% | 389.9 ± 0.3% | 2852.0 ± 0.5% | 536.5 ± 0.8% | 2.767 | 2.190 | 13.160 | 1.799 | 9.565 |
| string: canterbury/plrabn12.txt | 503330 | 4116.3 ± 1.5% | 1737.9 ± 0.1% | 2061.8 ± 0.4% | 359.4 ± 0.8% | 2518.0 ± 0.7% | 499.0 ± 1.5% | 2.369 | 1.996 | 11.453 | 1.635 | 8.249 |
| string: canterbury-large/E.coli | 1048578 | 19237.4 ± 1.2% | 3609.8 ± 0.3% | 3260.1 ± 0.2% | 936.4 ± 1.3% | 6066.1 ± 0.6% | 761.8 ± 2.0% | 5.329 | 5.901 | 20.543 | 3.171 | 25.253 |
| string: canterbury-large/bible.txt | 1055886 | 6688.9 ± 1.5% | 2939.3 ± 0.4% | 2837.5 ± 0.4% | 418.4 ± 1.1% | 3768.3 ± 1.3% | 616.0 ± 1.8% | 2.276 | 2.357 | 15.988 | 1.775 | 10.860 |
| string: canterbury-large/world192.txt | 1103121 | 3381.3 ± 0.7% | 1482.9 ± 0.3% | 2012.4 ± 0.6% | 352.4 ± 0.5% | 2121.7 ± 0.9% | 503.2 ± 1.2% | 2.280 | 1.680 | 9.594 | 1.594 | 6.719 |
| string: http/html-1m | 1058582 | 6054.3 ± 1.4% | 2740.2 ± 1.1% | 2708.1 ± 0.8% | 442.3 ± 0.2% | 3479.7 ± 0.8% | 603.6 ± 1.4% | 2.209 | 2.236 | 13.689 | 1.740 | 10.030 |
| string: http/json-1m | 1190272 | 2550.3 ± 0.5% | 877.4 ± 0.4% | 2256.4 ± 0.2% | 391.7 ± 0.5% | 1065.1 ± 0.3% | 443.3 ± 1.3% | 2.907 | 1.130 | 6.511 | 2.394 | 5.754 |
| string: http/js-1m | 1144362 | 2289.1 ± 0.6% | 1029.1 ± 0.5% | 1642.3 ± 0.4% | 321.2 ± 0.6% | 1525.1 ± 0.6% | 419.7 ± 0.9% | 2.224 | 1.394 | 7.126 | 1.501 | 5.454 |
| string: http/css-1m | 1097820 | 2630.3 ± 1.2% | 1678.1 ± 2.3% | 2222.5 ± 2.4% | 405.4 ± 0.7% | 1943.8 ± 2.3% | 488.4 ± 0.8% | 1.567 | 1.184 | 6.488 | 1.353 | 5.385 |
| string: dickens as Cyrillic and CJK | 1883069 | 3077.6 ± 0.4% | 1685.1 ± 0.4% | 893.5 ± 0.2% | 350.7 ± 0.3% | 667.2 ± 0.3% | 158.5 ± 1.0% | 1.826 | 3.444 | 8.776 | 4.613 | 19.420 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.3 ± 1.2% | 980.1 ± 0.3% | 1203.1 ± 0.4% | 216.3 ± 0.2% | 471.7 ± 0.8% | 252.8 ± 4.0% | 1.354 | 1.103 | 6.135 | 2.814 | 5.250 |
| hex: silesia/dickens | 524290 | 18566.4 ± 0.5% | 3616.7 ± 2.2% | 3297.6 ± 1.8% | 517.6 ± 3.0% | 6135.7 ± 1.8% | 782.1 ± 3.8% | 5.134 | 5.630 | 35.873 | 3.026 | 23.738 |
| hex: silesia/mozilla | 524290 | 19021.6 ± 1.3% | 3615.9 ± 0.2% | 3308.4 ± 0.1% | 452.0 ± 1.0% | 6127.0 ± 0.8% | 783.4 ± 0.5% | 5.260 | 5.749 | 42.085 | 3.105 | 24.281 |
| hex: silesia/mr | 524290 | 18811.8 ± 0.7% | 3617.5 ± 0.3% | 3286.8 ± 0.4% | 569.6 ± 0.9% | 6094.6 ± 1.0% | 781.9 ± 0.7% | 5.200 | 5.723 | 33.027 | 3.087 | 24.058 |
| hex: silesia/nci | 524290 | 18806.6 ± 0.3% | 3619.3 ± 0.1% | 3303.1 ± 0.2% | 617.3 ± 1.2% | 6088.5 ± 0.9% | 782.8 ± 0.4% | 5.196 | 5.694 | 30.464 | 3.089 | 24.026 |
| hex: silesia/ooffice | 524290 | 18813.8 ± 0.5% | 3622.3 ± 0.2% | 3293.4 ± 0.2% | 390.6 ± 1.5% | 6124.8 ± 1.3% | 782.6 ± 0.8% | 5.194 | 5.713 | 48.172 | 3.072 | 24.040 |
| hex: silesia/osdb | 524290 | 18704.3 ± 1.0% | 3620.1 ± 0.3% | 3295.5 ± 0.3% | 463.2 ± 2.8% | 6061.9 ± 0.6% | 783.8 ± 0.5% | 5.167 | 5.676 | 40.379 | 3.086 | 23.865 |
| hex: silesia/reymont | 524290 | 18994.8 ± 0.4% | 3617.3 ± 0.3% | 3294.0 ± 0.2% | 499.4 ± 1.7% | 6121.8 ± 1.5% | 783.6 ± 0.2% | 5.251 | 5.767 | 38.039 | 3.103 | 24.241 |
| hex: silesia/samba | 524290 | 18649.2 ± 0.4% | 3623.0 ± 0.2% | 3310.1 ± 0.2% | 395.9 ± 1.0% | 6116.1 ± 1.4% | 783.1 ± 0.2% | 5.147 | 5.634 | 47.108 | 3.049 | 23.814 |
| hex: silesia/sao | 524290 | 18965.9 ± 0.8% | 3619.8 ± 0.3% | 3301.7 ± 0.2% | 336.0 ± 1.3% | 6119.9 ± 1.5% | 783.6 ± 0.6% | 5.240 | 5.744 | 56.446 | 3.099 | 24.205 |
| hex: silesia/webster | 524290 | 18785.2 ± 0.5% | 3617.3 ± 0.3% | 3290.2 ± 0.1% | 449.5 ± 1.7% | 6012.5 ± 0.9% | 781.8 ± 0.4% | 5.193 | 5.709 | 41.792 | 3.124 | 24.027 |
| hex: silesia/x-ray | 524290 | 18753.0 ± 1.0% | 3619.6 ± 0.2% | 3294.3 ± 0.2% | 468.4 ± 2.3% | 6060.4 ± 1.8% | 782.6 ± 0.5% | 5.181 | 5.693 | 40.034 | 3.094 | 23.963 |
| hex: silesia/xml | 524290 | 19057.6 ± 0.5% | 3617.1 ± 0.3% | 3301.0 ± 0.1% | 524.0 ± 0.5% | 6104.5 ± 1.7% | 784.0 ± 0.2% | 5.269 | 5.773 | 36.371 | 3.122 | 24.307 |
| hex: canterbury/alice29.txt | 304180 | 19556.1 ± 0.1% | 3632.8 ± 0.1% | 3375.2 ± 0.1% | 520.7 ± 0.3% | 6130.2 ± 0.7% | 782.0 ± 0.3% | 5.383 | 5.794 | 37.556 | 3.190 | 25.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19525.4 ± 0.1% | 3637.0 ± 0.1% | 3377.4 ± 0.1% | 514.3 ± 0.4% | 6173.6 ± 1.7% | 780.8 ± 0.6% | 5.369 | 5.781 | 37.965 | 3.163 | 25.006 |
| hex: canterbury/cp.html | 49208 | 19159.5 ± 0.7% | 3639.6 ± 0.0% | 3278.7 ± 0.3% | 480.3 ± 0.7% | 6256.7 ± 1.9% | 763.8 ± 1.1% | 5.264 | 5.844 | 39.887 | 3.062 | 25.083 |
| hex: canterbury/fields.c | 22302 | 18882.2 ± 0.7% | 3629.1 ± 0.1% | 3395.0 ± 0.3% | 511.9 ± 0.9% | 6243.1 ± 0.4% | 750.3 ± 2.9% | 5.203 | 5.562 | 36.886 | 3.025 | 25.168 |
| hex: canterbury/grammar.lsp | 7444 | 17440.8 ± 1.0% | 3601.7 ± 0.0% | 3339.6 ± 0.6% | 551.5 ± 2.7% | 6171.3 ± 0.5% | 722.2 ± 2.2% | 4.842 | 5.222 | 31.626 | 2.826 | 24.149 |
| hex: canterbury/kennedy.xls | 524290 | 18693.6 ± 3.2% | 3613.6 ± 0.3% | 3303.3 ± 0.3% | 665.8 ± 2.7% | 6126.7 ± 1.2% | 760.9 ± 6.8% | 5.173 | 5.659 | 28.077 | 3.051 | 24.567 |
| hex: canterbury/lcet10.txt | 524290 | 18986.5 ± 1.4% | 3617.9 ± 0.4% | 3292.8 ± 0.1% | 506.6 ± 0.8% | 6143.4 ± 1.4% | 771.2 ± 0.6% | 5.248 | 5.766 | 37.481 | 3.091 | 24.619 |
| hex: canterbury/plrabn12.txt | 524290 | 18846.9 ± 0.6% | 3615.7 ± 0.3% | 3290.0 ± 0.1% | 502.9 ± 0.6% | 6046.3 ± 1.2% | 773.9 ± 0.7% | 5.213 | 5.729 | 37.476 | 3.117 | 24.354 |
| hex: canterbury/ptt5 | 524290 | 18789.3 ± 0.8% | 3612.8 ± 0.1% | 3295.4 ± 0.6% | 557.7 ± 0.4% | 6066.7 ± 1.3% | 772.3 ± 1.4% | 5.201 | 5.702 | 33.690 | 3.097 | 24.329 |
| hex: canterbury/sum | 76482 | 19295.2 ± 0.5% | 3634.2 ± 0.1% | 3355.4 ± 0.3% | 500.0 ± 1.0% | 6186.2 ± 0.7% | 766.6 ± 0.8% | 5.309 | 5.751 | 38.590 | 3.119 | 25.170 |
| hex: canterbury/xargs.1 | 8456 | 17790.4 ± 0.1% | 3603.1 ± 0.0% | 3366.0 ± 0.1% | 484.7 ± 0.8% | 6145.1 ± 0.2% | 749.2 ± 1.2% | 4.937 | 5.285 | 36.702 | 2.895 | 23.747 |
| hex: canterbury-large/E.coli | 524290 | 18978.8 ± 0.8% | 3618.8 ± 0.2% | 3290.8 ± 0.5% | 688.1 ± 0.4% | 6117.4 ± 0.9% | 761.4 ± 7.3% | 5.244 | 5.767 | 27.582 | 3.102 | 24.927 |
| hex: canterbury-large/bible.txt | 524290 | 18944.5 ± 1.1% | 3618.0 ± 0.2% | 3299.7 ± 0.2% | 513.8 ± 1.2% | 6115.1 ± 1.0% | 761.9 ± 2.0% | 5.236 | 5.741 | 36.871 | 3.098 | 24.864 |
| hex: canterbury-large/world192.txt | 524290 | 18461.4 ± 0.6% | 3616.4 ± 0.4% | 3305.1 ± 0.4% | 487.2 ± 3.1% | 6104.5 ± 1.1% | 766.1 ± 1.0% | 5.105 | 5.586 | 37.889 | 3.024 | 24.098 |
| hex: http/html-1kx1024 | 2099200 | 9775.2 ± 18.8% | 3463.1 ± 0.5% | 2878.4 ± 0.4% | 476.4 ± 0.9% | 5168.3 ± 0.9% | 627.5 ± 2.5% | 2.823 | 3.396 | 20.519 | 1.891 | 15.577 |
| hex: http/html-16kx64 | 2097280 | 18356.6 ± 1.5% | 3612.0 ± 0.1% | 3262.0 ± 0.3% | 477.1 ± 0.9% | 6009.1 ± 0.3% | 745.7 ± 3.2% | 5.082 | 5.627 | 38.473 | 3.055 | 24.616 |
| hex: http/html-1m | 524290 | 18646.9 ± 2.6% | 3618.4 ± 0.2% | 3294.3 ± 0.3% | 493.6 ± 1.0% | 6126.3 ± 1.5% | 756.5 ± 1.4% | 5.153 | 5.660 | 37.778 | 3.044 | 24.648 |
| hex: http/json-1kx1024 | 2099200 | 10593.7 ± 17.2% | 3460.5 ± 0.2% | 2874.9 ± 0.3% | 576.1 ± 0.6% | 5154.2 ± 0.3% | 624.9 ± 2.0% | 3.061 | 3.685 | 18.388 | 2.055 | 16.953 |
| hex: http/json-16kx64 | 2097280 | 18391.4 ± 1.5% | 3610.8 ± 0.1% | 3258.8 ± 0.2% | 574.4 ± 1.2% | 6016.8 ± 0.6% | 741.5 ± 1.0% | 5.093 | 5.644 | 32.019 | 3.057 | 24.802 |
| hex: http/json-1m | 524290 | 18678.3 ± 0.6% | 3619.0 ± 0.1% | 3297.2 ± 0.2% | 595.3 ± 1.3% | 6081.5 ± 1.7% | 760.7 ± 4.4% | 5.161 | 5.665 | 31.374 | 3.071 | 24.553 |
| hex: http/js-1kx1024 | 2099200 | 9647.2 ± 19.5% | 3465.0 ± 0.1% | 2876.6 ± 0.3% | 480.7 ± 0.7% | 5154.2 ± 1.1% | 628.3 ± 1.1% | 2.784 | 3.354 | 20.069 | 1.872 | 15.354 |
| hex: http/js-16kx64 | 2097280 | 18371.0 ± 1.8% | 3611.0 ± 0.1% | 3249.5 ± 0.4% | 481.2 ± 0.8% | 6010.6 ± 0.3% | 730.6 ± 2.6% | 5.087 | 5.654 | 38.181 | 3.056 | 25.147 |
| hex: http/js-1m | 524290 | 18876.7 ± 1.9% | 3620.7 ± 0.2% | 3302.2 ± 0.1% | 517.0 ± 5.7% | 6110.6 ± 1.8% | 754.9 ± 2.5% | 5.214 | 5.716 | 36.513 | 3.089 | 25.007 |
| hex: http/css-1kx1024 | 2099200 | 9685.2 ± 18.8% | 3463.0 ± 0.2% | 2873.6 ± 0.3% | 488.9 ± 1.4% | 5151.0 ± 1.2% | 625.3 ± 4.9% | 2.797 | 3.370 | 19.809 | 1.880 | 15.489 |
| hex: http/css-16kx64 | 2097280 | 18334.5 ± 1.5% | 3612.1 ± 0.2% | 3257.9 ± 0.4% | 493.9 ± 1.7% | 6018.7 ± 0.3% | 739.7 ± 3.9% | 5.076 | 5.628 | 37.122 | 3.046 | 24.788 |
| hex: http/css-1m | 524290 | 18800.9 ± 1.1% | 3622.6 ± 0.1% | 3303.0 ± 0.2% | 512.1 ± 1.8% | 6127.5 ± 2.4% | 756.6 ± 1.6% | 5.190 | 5.692 | 36.711 | 3.068 | 24.849 |
| hex: shuffled/dickens-1m | 524290 | 18713.0 ± 0.9% | 3619.8 ± 0.2% | 3296.6 ± 0.1% | 504.0 ± 1.3% | 6133.7 ± 1.0% | 764.2 ± 0.5% | 5.170 | 5.676 | 37.128 | 3.051 | 24.487 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1481.4 ± 0.7% | 1257.0 ± 0.7% | 1036.5 ± 0.5% | 410.8 ± 0.2% | 449.1 ± 0.2% | 415.0 ± 0.3% | 1.178 | 1.429 | 3.606 | 3.299 | 3.569 |
| qlog records, JSON text sequence | 1467503 | 1264.3 ± 0.7% | 1057.0 ± 0.3% | 780.8 ± 1.8% | 378.7 ± 0.9% | 467.2 ± 1.8% | 279.1 ± 0.8% | 1.196 | 1.619 | 3.338 | 2.706 | 4.530 |
| string: silesia/dickens | 172528 | 6895.3 ± 0.3% | 2819.8 ± 0.4% | 2929.0 ± 0.2% | 430.0 ± 0.3% | 1569.4 ± 0.3% | 1011.8 ± 0.1% | 2.445 | 2.354 | 16.034 | 4.394 | 6.815 |
| string: silesia/nci | 1075110 | 7311.2 ± 1.0% | 3432.4 ± 1.9% | 3101.5 ± 0.5% | 813.5 ± 1.0% | 1854.6 ± 0.3% | 1108.8 ± 0.3% | 2.130 | 2.357 | 8.987 | 3.942 | 6.594 |
| string: silesia/reymont | 1075159 | 3347.1 ± 1.2% | 1984.7 ± 1.1% | 2062.4 ± 0.3% | 449.3 ± 0.7% | 1512.4 ± 0.7% | 950.1 ± 1.0% | 1.686 | 1.623 | 7.449 | 2.213 | 3.523 |
| string: silesia/samba | 97582 | 4183.4 ± 0.4% | 2120.1 ± 0.5% | 3446.8 ± 0.4% | 353.5 ± 0.7% | 1436.4 ± 0.4% | 1056.6 ± 0.3% | 1.973 | 1.214 | 11.833 | 2.912 | 3.959 |
| string: silesia/webster | 1098490 | 4053.5 ± 0.3% | 1882.3 ± 0.4% | 2058.3 ± 0.3% | 442.0 ± 0.7% | 1390.0 ± 0.2% | 648.2 ± 0.4% | 2.153 | 1.969 | 9.171 | 2.916 | 6.254 |
| string: silesia/xml | 1090118 | 6118.8 ± 0.8% | 2872.4 ± 0.4% | 2641.9 ± 0.6% | 610.6 ± 0.6% | 1753.2 ± 0.3% | 925.2 ± 0.3% | 2.130 | 2.316 | 10.021 | 3.490 | 6.614 |
| string: canterbury/alice29.txt | 159425 | 6381.3 ± 2.1% | 2200.5 ± 0.6% | 2766.9 ± 1.1% | 407.6 ± 1.4% | 1465.4 ± 0.4% | 957.1 ± 0.1% | 2.900 | 2.306 | 15.656 | 4.355 | 6.667 |
| string: canterbury/asyoulik.txt | 132198 | 5586.4 ± 1.2% | 1718.8 ± 0.2% | 2383.6 ± 1.0% | 402.9 ± 0.5% | 1335.8 ± 0.4% | 885.8 ± 0.2% | 3.250 | 2.344 | 13.865 | 4.182 | 6.307 |
| string: canterbury/lcet10.txt | 441884 | 6257.0 ± 0.5% | 2564.7 ± 0.2% | 2494.8 ± 1.7% | 469.9 ± 0.4% | 1526.6 ± 0.3% | 985.0 ± 0.6% | 2.440 | 2.508 | 13.314 | 4.099 | 6.352 |
| string: canterbury/plrabn12.txt | 503330 | 5710.3 ± 0.5% | 2057.7 ± 0.2% | 2076.7 ± 0.5% | 425.4 ± 0.7% | 1410.5 ± 0.3% | 933.6 ± 0.1% | 2.775 | 2.750 | 13.423 | 4.048 | 6.117 |
| string: canterbury-large/E.coli | 1048578 | 19347.8 ± 0.8% | 9630.1 ± 2.6% | 3793.0 ± 0.4% | 1478.6 ± 0.7% | 2377.1 ± 1.0% | 1193.9 ± 0.9% | 2.009 | 5.101 | 13.085 | 8.139 | 16.206 |
| string: canterbury-large/bible.txt | 1055886 | 6774.2 ± 0.1% | 4158.0 ± 1.3% | 3042.6 ± 1.2% | 502.3 ± 0.3% | 1990.3 ± 0.5% | 1121.5 ± 0.4% | 1.629 | 2.226 | 13.486 | 3.404 | 6.040 |
| string: canterbury-large/world192.txt | 1103121 | 4017.2 ± 0.3% | 1657.2 ± 0.4% | 1996.5 ± 0.5% | 448.3 ± 0.5% | 1357.6 ± 0.3% | 910.0 ± 0.2% | 2.424 | 2.012 | 8.961 | 2.959 | 4.415 |
| string: http/html-1m | 1058582 | 6735.6 ± 1.5% | 3992.4 ± 0.5% | 3044.6 ± 0.4% | 499.4 ± 0.4% | 1930.4 ± 0.4% | 806.9 ± 0.2% | 1.687 | 2.212 | 13.486 | 3.489 | 8.347 |
| string: http/json-1m | 1190272 | 3162.3 ± 0.2% | 1349.7 ± 0.3% | 1556.3 ± 0.4% | 445.0 ± 0.2% | 962.3 ± 0.2% | 765.0 ± 1.1% | 2.343 | 2.032 | 7.106 | 3.286 | 4.134 |
| string: http/js-1m | 1144362 | 2762.0 ± 0.4% | 1180.7 ± 0.1% | 1626.8 ± 0.2% | 369.4 ± 0.3% | 1094.8 ± 0.1% | 758.4 ± 0.3% | 2.339 | 1.698 | 7.477 | 2.523 | 3.642 |
| string: http/css-1m | 1097820 | 3988.7 ± 0.8% | 1487.2 ± 0.3% | 2158.7 ± 0.8% | 494.3 ± 0.4% | 1369.0 ± 0.4% | 896.2 ± 0.3% | 2.682 | 1.848 | 8.070 | 2.914 | 4.451 |
| string: dickens as Cyrillic and CJK | 1883069 | 3066.8 ± 0.3% | 2341.7 ± 0.3% | 521.2 ± 0.2% | 307.8 ± 0.6% | 563.8 ± 0.9% | 335.6 ± 0.2% | 1.310 | 5.884 | 9.963 | 5.440 | 9.138 |
| hex: silesia/dickens | 524290 | 15650.6 ± 0.3% | 1468.2 ± 0.1% | 1087.3 ± 0.4% | 499.7 ± 1.1% | 990.2 ± 0.5% | 735.1 ± 0.1% | 10.660 | 14.394 | 31.321 | 15.805 | 21.289 |
| hex: silesia/mozilla | 524290 | 15639.6 ± 0.1% | 1478.3 ± 0.2% | 1088.4 ± 0.4% | 442.1 ± 0.8% | 994.0 ± 0.4% | 736.4 ± 1.0% | 10.579 | 14.370 | 35.373 | 15.734 | 21.238 |
| hex: silesia/mr | 524290 | 15687.2 ± 0.2% | 1483.2 ± 0.2% | 1091.2 ± 0.2% | 563.7 ± 1.3% | 994.2 ± 0.3% | 736.2 ± 0.2% | 10.576 | 14.377 | 27.828 | 15.778 | 21.309 |
| hex: silesia/nci | 524290 | 15655.2 ± 0.2% | 1481.4 ± 0.2% | 1091.9 ± 0.1% | 641.2 ± 4.2% | 993.2 ± 0.2% | 734.6 ± 0.4% | 10.568 | 14.337 | 24.416 | 15.763 | 21.311 |
| hex: silesia/ooffice | 524290 | 15649.6 ± 0.1% | 1469.0 ± 0.2% | 1086.2 ± 0.3% | 390.0 ± 0.2% | 990.0 ± 0.5% | 735.2 ± 0.5% | 10.653 | 14.407 | 40.129 | 15.807 | 21.286 |
| hex: silesia/osdb | 524290 | 15649.8 ± 0.2% | 1475.8 ± 0.2% | 1088.8 ± 0.3% | 468.9 ± 1.4% | 994.3 ± 0.3% | 735.8 ± 0.3% | 10.604 | 14.373 | 33.373 | 15.740 | 21.270 |
| hex: silesia/reymont | 524290 | 15613.9 ± 0.2% | 1466.5 ± 0.7% | 1087.3 ± 0.4% | 512.8 ± 1.2% | 992.9 ± 0.6% | 735.9 ± 0.4% | 10.647 | 14.361 | 30.450 | 15.726 | 21.216 |
| hex: silesia/samba | 524290 | 15678.8 ± 0.1% | 1471.0 ± 0.1% | 1085.8 ± 0.2% | 403.3 ± 0.7% | 992.0 ± 0.2% | 736.1 ± 0.5% | 10.659 | 14.440 | 38.874 | 15.805 | 21.300 |
| hex: silesia/sao | 524290 | 15652.0 ± 0.3% | 1468.2 ± 0.2% | 1084.8 ± 0.1% | 332.8 ± 0.6% | 990.7 ± 0.4% | 735.4 ± 0.7% | 10.661 | 14.428 | 47.033 | 15.799 | 21.282 |
| hex: silesia/webster | 524290 | 15677.4 ± 0.1% | 1469.3 ± 0.3% | 1084.1 ± 0.2% | 471.9 ± 0.6% | 990.7 ± 0.5% | 736.3 ± 0.2% | 10.670 | 14.461 | 33.219 | 15.825 | 21.293 |
| hex: silesia/x-ray | 524290 | 15630.5 ± 0.2% | 1477.4 ± 0.2% | 1090.3 ± 0.2% | 445.6 ± 1.0% | 996.3 ± 0.3% | 736.5 ± 0.6% | 10.579 | 14.336 | 35.081 | 15.688 | 21.223 |
| hex: silesia/xml | 524290 | 15575.6 ± 0.1% | 1472.1 ± 0.4% | 1087.6 ± 0.8% | 611.3 ± 1.3% | 991.8 ± 0.4% | 735.9 ± 0.5% | 10.581 | 14.321 | 25.478 | 15.704 | 21.165 |
| hex: canterbury/alice29.txt | 304180 | 15667.7 ± 0.1% | 1475.1 ± 0.5% | 1090.3 ± 0.3% | 504.4 ± 0.3% | 996.5 ± 0.3% | 736.5 ± 0.3% | 10.622 | 14.370 | 31.065 | 15.722 | 21.274 |
| hex: canterbury/asyoulik.txt | 250360 | 15700.9 ± 0.0% | 1476.7 ± 0.4% | 1096.3 ± 0.4% | 495.1 ± 1.5% | 997.1 ± 0.4% | 741.8 ± 0.3% | 10.633 | 14.322 | 31.712 | 15.746 | 21.167 |
| hex: canterbury/cp.html | 49208 | 15620.1 ± 0.1% | 1471.2 ± 0.7% | 1098.5 ± 0.2% | 515.8 ± 1.6% | 1002.1 ± 0.5% | 742.7 ± 0.1% | 10.617 | 14.220 | 30.284 | 15.588 | 21.032 |
| hex: canterbury/fields.c | 22302 | 15440.0 ± 0.1% | 1415.9 ± 0.6% | 1065.3 ± 0.7% | 633.8 ± 6.2% | 987.0 ± 0.6% | 736.0 ± 0.3% | 10.905 | 14.494 | 24.359 | 15.644 | 20.979 |
| hex: canterbury/grammar.lsp | 7444 | 14946.3 ± 0.1% | 1509.4 ± 0.1% | 1098.1 ± 0.5% | 656.7 ± 2.6% | 995.3 ± 0.5% | 726.1 ± 0.2% | 9.902 | 13.611 | 22.759 | 15.017 | 20.584 |
| hex: canterbury/kennedy.xls | 524290 | 15645.4 ± 0.2% | 1477.2 ± 0.2% | 1088.3 ± 0.3% | 658.5 ± 1.1% | 991.2 ± 0.5% | 735.2 ± 0.2% | 10.591 | 14.376 | 23.758 | 15.784 | 21.279 |
| hex: canterbury/lcet10.txt | 524290 | 15632.7 ± 0.2% | 1464.6 ± 0.4% | 1086.0 ± 0.2% | 504.1 ± 1.4% | 990.1 ± 0.6% | 735.2 ± 0.3% | 10.674 | 14.394 | 31.012 | 15.789 | 21.264 |
| hex: canterbury/plrabn12.txt | 524290 | 15655.6 ± 0.2% | 1467.9 ± 0.3% | 1085.3 ± 0.3% | 493.5 ± 0.2% | 992.0 ± 0.3% | 734.3 ± 0.5% | 10.666 | 14.425 | 31.724 | 15.782 | 21.320 |
| hex: canterbury/ptt5 | 524290 | 15636.0 ± 0.1% | 1481.8 ± 0.3% | 1094.3 ± 0.2% | 552.4 ± 1.6% | 993.7 ± 0.2% | 735.7 ± 0.3% | 10.552 | 14.288 | 28.303 | 15.734 | 21.253 |
| hex: canterbury/sum | 76482 | 15645.9 ± 0.0% | 1494.9 ± 0.1% | 1105.5 ± 0.1% | 594.0 ± 2.8% | 998.3 ± 0.1% | 744.7 ± 0.3% | 10.466 | 14.153 | 26.341 | 15.673 | 21.010 |
| hex: canterbury/xargs.1 | 8456 | 15021.6 ± 0.2% | 1494.9 ± 0.2% | 1096.0 ± 0.4% | 654.8 ± 4.0% | 1003.7 ± 0.3% | 728.6 ± 0.1% | 10.049 | 13.706 | 22.942 | 14.967 | 20.616 |
| hex: canterbury-large/E.coli | 524290 | 15661.8 ± 0.1% | 1476.1 ± 0.5% | 1092.2 ± 0.4% | 672.2 ± 0.3% | 991.4 ± 0.3% | 735.8 ± 0.6% | 10.611 | 14.340 | 23.299 | 15.798 | 21.284 |
| hex: canterbury-large/bible.txt | 524290 | 15638.9 ± 0.1% | 1466.4 ± 0.4% | 1086.3 ± 0.9% | 514.4 ± 0.7% | 988.1 ± 0.6% | 735.3 ± 0.6% | 10.665 | 14.396 | 30.404 | 15.828 | 21.270 |
| hex: canterbury-large/world192.txt | 524290 | 15639.2 ± 0.1% | 1471.0 ± 0.2% | 1083.6 ± 0.5% | 502.1 ± 0.3% | 992.3 ± 0.5% | 735.2 ± 0.3% | 10.631 | 14.432 | 31.148 | 15.761 | 21.272 |
| hex: http/html-1kx1024 | 2099200 | 13769.5 ± 0.5% | 1453.7 ± 0.2% | 1063.4 ± 0.2% | 503.0 ± 0.3% | 982.7 ± 0.1% | 692.6 ± 0.4% | 9.472 | 12.949 | 27.372 | 14.012 | 19.880 |
| hex: http/html-16kx64 | 2097280 | 15262.7 ± 0.4% | 1445.7 ± 0.1% | 1076.2 ± 0.1% | 507.8 ± 0.1% | 996.4 ± 0.1% | 735.6 ± 0.0% | 10.557 | 14.183 | 30.055 | 15.319 | 20.747 |
| hex: http/html-1m | 524290 | 15689.4 ± 0.2% | 1471.0 ± 0.5% | 1085.9 ± 0.8% | 501.3 ± 0.5% | 992.2 ± 0.4% | 735.4 ± 0.5% | 10.666 | 14.448 | 31.297 | 15.813 | 21.334 |
| hex: http/json-1kx1024 | 2099200 | 13677.8 ± 0.2% | 1463.4 ± 0.1% | 1067.8 ± 0.1% | 608.9 ± 0.5% | 985.9 ± 0.1% | 692.6 ± 0.1% | 9.347 | 12.809 | 22.462 | 13.873 | 19.749 |
| hex: http/json-16kx64 | 2097280 | 15280.8 ± 0.5% | 1447.7 ± 0.3% | 1077.4 ± 0.2% | 615.2 ± 0.7% | 997.6 ± 0.2% | 735.0 ± 0.1% | 10.555 | 14.183 | 24.839 | 15.318 | 20.791 |
| hex: http/json-1m | 524290 | 15663.3 ± 0.2% | 1477.1 ± 0.3% | 1088.2 ± 0.3% | 631.9 ± 1.0% | 993.4 ± 0.3% | 735.5 ± 0.5% | 10.604 | 14.393 | 24.786 | 15.767 | 21.295 |
| hex: http/js-1kx1024 | 2099200 | 13696.1 ± 0.5% | 1455.1 ± 0.3% | 1058.6 ± 0.2% | 499.1 ± 0.2% | 983.3 ± 0.3% | 692.3 ± 0.1% | 9.412 | 12.938 | 27.441 | 13.928 | 19.784 |
| hex: http/js-16kx64 | 2097280 | 15270.4 ± 0.1% | 1447.8 ± 0.1% | 1075.8 ± 0.1% | 504.4 ± 0.3% | 996.9 ± 0.2% | 735.3 ± 0.1% | 10.547 | 14.195 | 30.273 | 15.319 | 20.767 |
| hex: http/js-1m | 524290 | 15674.5 ± 0.1% | 1468.4 ± 0.2% | 1084.6 ± 0.2% | 512.9 ± 0.6% | 991.2 ± 0.2% | 735.0 ± 0.4% | 10.674 | 14.451 | 30.562 | 15.813 | 21.327 |
| hex: http/css-1kx1024 | 2099200 | 13718.2 ± 0.1% | 1456.1 ± 0.1% | 1062.9 ± 0.4% | 531.2 ± 0.5% | 982.9 ± 0.3% | 692.4 ± 0.3% | 9.421 | 12.907 | 25.824 | 13.957 | 19.814 |
| hex: http/css-16kx64 | 2097280 | 15260.2 ± 0.2% | 1444.3 ± 0.1% | 1075.0 ± 0.2% | 539.5 ± 0.6% | 999.2 ± 0.5% | 735.0 ± 0.2% | 10.566 | 14.196 | 28.288 | 15.272 | 20.761 |
| hex: http/css-1m | 524290 | 15664.5 ± 0.1% | 1470.4 ± 0.2% | 1087.7 ± 0.2% | 524.7 ± 0.4% | 989.9 ± 0.2% | 735.7 ± 0.2% | 10.653 | 14.401 | 29.853 | 15.824 | 21.293 |
| hex: shuffled/dickens-1m | 524290 | 15649.6 ± 0.3% | 1466.7 ± 0.2% | 1087.1 ± 0.4% | 504.0 ± 0.6% | 988.8 ± 0.3% | 734.3 ± 0.3% | 10.670 | 14.396 | 31.051 | 15.827 | 21.311 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1525.9 ± 0.5% | 1257.0 ± 0.7% | 1036.5 ± 0.5% | 410.8 ± 0.2% | 449.1 ± 0.2% | 415.0 ± 0.3% | 1.214 | 1.472 | 3.714 | 3.398 | 3.677 |
| qlog records, JSON text sequence | 1467503 | 1283.0 ± 1.2% | 1057.0 ± 0.3% | 780.8 ± 1.8% | 378.7 ± 0.9% | 467.2 ± 1.8% | 279.1 ± 0.8% | 1.214 | 1.643 | 3.388 | 2.746 | 4.598 |
| string: silesia/dickens | 172528 | 7145.0 ± 0.3% | 2819.8 ± 0.4% | 2929.0 ± 0.2% | 430.0 ± 0.3% | 1569.4 ± 0.3% | 1011.8 ± 0.1% | 2.534 | 2.439 | 16.615 | 4.553 | 7.062 |
| string: silesia/nci | 1075110 | 7385.1 ± 12.1% | 3432.4 ± 1.9% | 3101.5 ± 0.5% | 813.5 ± 1.0% | 1854.6 ± 0.3% | 1108.8 ± 0.3% | 2.152 | 2.381 | 9.078 | 3.982 | 6.660 |
| string: silesia/reymont | 1075159 | 3501.3 ± 1.0% | 1984.7 ± 1.1% | 2062.4 ± 0.3% | 449.3 ± 0.7% | 1512.4 ± 0.7% | 950.1 ± 1.0% | 1.764 | 1.698 | 7.793 | 2.315 | 3.685 |
| string: silesia/samba | 97582 | 4581.4 ± 0.7% | 2120.1 ± 0.5% | 3446.8 ± 0.4% | 353.5 ± 0.7% | 1436.4 ± 0.4% | 1056.6 ± 0.3% | 2.161 | 1.329 | 12.959 | 3.190 | 4.336 |
| string: silesia/webster | 1098490 | 4097.0 ± 0.6% | 1882.3 ± 0.4% | 2058.3 ± 0.3% | 442.0 ± 0.7% | 1390.0 ± 0.2% | 648.2 ± 0.4% | 2.177 | 1.990 | 9.269 | 2.948 | 6.321 |
| string: silesia/xml | 1090118 | 6220.3 ± 0.5% | 2872.4 ± 0.4% | 2641.9 ± 0.6% | 610.6 ± 0.6% | 1753.2 ± 0.3% | 925.2 ± 0.3% | 2.166 | 2.354 | 10.187 | 3.548 | 6.723 |
| string: canterbury/alice29.txt | 159425 | 6805.2 ± 1.4% | 2200.5 ± 0.6% | 2766.9 ± 1.1% | 407.6 ± 1.4% | 1465.4 ± 0.4% | 957.1 ± 0.1% | 3.093 | 2.460 | 16.696 | 4.644 | 7.110 |
| string: canterbury/asyoulik.txt | 132198 | 5779.4 ± 5.0% | 1718.8 ± 0.2% | 2383.6 ± 1.0% | 402.9 ± 0.5% | 1335.8 ± 0.4% | 885.8 ± 0.2% | 3.362 | 2.425 | 14.344 | 4.327 | 6.525 |
| string: canterbury/lcet10.txt | 441884 | 6246.4 ± 1.3% | 2564.7 ± 0.2% | 2494.8 ± 1.7% | 469.9 ± 0.4% | 1526.6 ± 0.3% | 985.0 ± 0.6% | 2.435 | 2.504 | 13.292 | 4.092 | 6.342 |
| string: canterbury/plrabn12.txt | 503330 | 5764.7 ± 0.2% | 2057.7 ± 0.2% | 2076.7 ± 0.5% | 425.4 ± 0.7% | 1410.5 ± 0.3% | 933.6 ± 0.1% | 2.802 | 2.776 | 13.551 | 4.087 | 6.175 |
| string: canterbury-large/E.coli | 1048578 | 19340.8 ± 0.9% | 9630.1 ± 2.6% | 3793.0 ± 0.4% | 1478.6 ± 0.7% | 2377.1 ± 1.0% | 1193.9 ± 0.9% | 2.008 | 5.099 | 13.080 | 8.136 | 16.200 |
| string: canterbury-large/bible.txt | 1055886 | 6807.1 ± 0.5% | 4158.0 ± 1.3% | 3042.6 ± 1.2% | 502.3 ± 0.3% | 1990.3 ± 0.5% | 1121.5 ± 0.4% | 1.637 | 2.237 | 13.552 | 3.420 | 6.069 |
| string: canterbury-large/world192.txt | 1103121 | 4038.8 ± 0.3% | 1657.2 ± 0.4% | 1996.5 ± 0.5% | 448.3 ± 0.5% | 1357.6 ± 0.3% | 910.0 ± 0.2% | 2.437 | 2.023 | 9.009 | 2.975 | 4.438 |
| string: http/html-1m | 1058582 | 6825.5 ± 0.3% | 3992.4 ± 0.5% | 3044.6 ± 0.4% | 499.4 ± 0.4% | 1930.4 ± 0.4% | 806.9 ± 0.2% | 1.710 | 2.242 | 13.667 | 3.536 | 8.458 |
| string: http/json-1m | 1190272 | 3302.1 ± 0.4% | 1349.7 ± 0.3% | 1556.3 ± 0.4% | 445.0 ± 0.2% | 962.3 ± 0.2% | 765.0 ± 1.1% | 2.447 | 2.122 | 7.420 | 3.432 | 4.317 |
| string: http/js-1m | 1144362 | 2793.6 ± 0.8% | 1180.7 ± 0.1% | 1626.8 ± 0.2% | 369.4 ± 0.3% | 1094.8 ± 0.1% | 758.4 ± 0.3% | 2.366 | 1.717 | 7.562 | 2.552 | 3.683 |
| string: http/css-1m | 1097820 | 4030.4 ± 0.9% | 1487.2 ± 0.3% | 2158.7 ± 0.8% | 494.3 ± 0.4% | 1369.0 ± 0.4% | 896.2 ± 0.3% | 2.710 | 1.867 | 8.154 | 2.944 | 4.497 |
| string: dickens as Cyrillic and CJK | 1883069 | 3075.6 ± 0.3% | 2341.7 ± 0.3% | 521.2 ± 0.2% | 307.8 ± 0.6% | 563.8 ± 0.9% | 335.6 ± 0.2% | 1.313 | 5.900 | 9.991 | 5.455 | 9.164 |
| hex: silesia/dickens | 524290 | 15676.4 ± 0.4% | 1468.2 ± 0.1% | 1087.3 ± 0.4% | 499.7 ± 1.1% | 990.2 ± 0.5% | 735.1 ± 0.1% | 10.677 | 14.418 | 31.372 | 15.831 | 21.324 |
| hex: silesia/mozilla | 524290 | 15690.9 ± 0.1% | 1478.3 ± 0.2% | 1088.4 ± 0.4% | 442.1 ± 0.8% | 994.0 ± 0.4% | 736.4 ± 1.0% | 10.614 | 14.417 | 35.490 | 15.786 | 21.308 |
| hex: silesia/mr | 524290 | 15687.8 ± 0.2% | 1483.2 ± 0.2% | 1091.2 ± 0.2% | 563.7 ± 1.3% | 994.2 ± 0.3% | 736.2 ± 0.2% | 10.577 | 14.377 | 27.829 | 15.779 | 21.310 |
| hex: silesia/nci | 524290 | 15599.7 ± 0.6% | 1481.4 ± 0.2% | 1091.9 ± 0.1% | 641.2 ± 4.2% | 993.2 ± 0.2% | 734.6 ± 0.4% | 10.531 | 14.286 | 24.330 | 15.707 | 21.235 |
| hex: silesia/ooffice | 524290 | 15663.8 ± 0.1% | 1469.0 ± 0.2% | 1086.2 ± 0.3% | 390.0 ± 0.2% | 990.0 ± 0.5% | 735.2 ± 0.5% | 10.663 | 14.420 | 40.165 | 15.821 | 21.305 |
| hex: silesia/osdb | 524290 | 15665.5 ± 0.5% | 1475.8 ± 0.2% | 1088.8 ± 0.3% | 468.9 ± 1.4% | 994.3 ± 0.3% | 735.8 ± 0.3% | 10.615 | 14.388 | 33.406 | 15.756 | 21.292 |
| hex: silesia/reymont | 524290 | 15607.1 ± 0.4% | 1466.5 ± 0.7% | 1087.3 ± 0.4% | 512.8 ± 1.2% | 992.9 ± 0.6% | 735.9 ± 0.4% | 10.642 | 14.354 | 30.437 | 15.719 | 21.207 |
| hex: silesia/samba | 524290 | 15691.8 ± 0.3% | 1471.0 ± 0.1% | 1085.8 ± 0.2% | 403.3 ± 0.7% | 992.0 ± 0.2% | 736.1 ± 0.5% | 10.668 | 14.452 | 38.906 | 15.818 | 21.318 |
| hex: silesia/sao | 524290 | 15619.3 ± 0.4% | 1468.2 ± 0.2% | 1084.8 ± 0.1% | 332.8 ± 0.6% | 990.7 ± 0.4% | 735.4 ± 0.7% | 10.638 | 14.398 | 46.935 | 15.766 | 21.238 |
| hex: silesia/webster | 524290 | 15689.6 ± 0.1% | 1469.3 ± 0.3% | 1084.1 ± 0.2% | 471.9 ± 0.6% | 990.7 ± 0.5% | 736.3 ± 0.2% | 10.678 | 14.472 | 33.245 | 15.837 | 21.310 |
| hex: silesia/x-ray | 524290 | 15662.4 ± 0.2% | 1477.4 ± 0.2% | 1090.3 ± 0.2% | 445.6 ± 1.0% | 996.3 ± 0.3% | 736.5 ± 0.6% | 10.601 | 14.366 | 35.152 | 15.720 | 21.267 |
| hex: silesia/xml | 524290 | 15582.0 ± 0.3% | 1472.1 ± 0.4% | 1087.6 ± 0.8% | 611.3 ± 1.3% | 991.8 ± 0.4% | 735.9 ± 0.5% | 10.585 | 14.327 | 25.489 | 15.711 | 21.174 |
| hex: canterbury/alice29.txt | 304180 | 15683.0 ± 0.1% | 1475.1 ± 0.5% | 1090.3 ± 0.3% | 504.4 ± 0.3% | 996.5 ± 0.3% | 736.5 ± 0.3% | 10.632 | 14.384 | 31.095 | 15.738 | 21.294 |
| hex: canterbury/asyoulik.txt | 250360 | 15718.8 ± 0.1% | 1476.7 ± 0.4% | 1096.3 ± 0.4% | 495.1 ± 1.5% | 997.1 ± 0.4% | 741.8 ± 0.3% | 10.645 | 14.338 | 31.748 | 15.764 | 21.191 |
| hex: canterbury/cp.html | 49208 | 15631.0 ± 0.1% | 1471.2 ± 0.7% | 1098.5 ± 0.2% | 515.8 ± 1.6% | 1002.1 ± 0.5% | 742.7 ± 0.1% | 10.625 | 14.230 | 30.305 | 15.599 | 21.046 |
| hex: canterbury/fields.c | 22302 | 15459.9 ± 0.0% | 1415.9 ± 0.6% | 1065.3 ± 0.7% | 633.8 ± 6.2% | 987.0 ± 0.6% | 736.0 ± 0.3% | 10.919 | 14.513 | 24.391 | 15.664 | 21.006 |
| hex: canterbury/grammar.lsp | 7444 | 14995.6 ± 0.0% | 1509.4 ± 0.1% | 1098.1 ± 0.5% | 656.7 ± 2.6% | 995.3 ± 0.5% | 726.1 ± 0.2% | 9.935 | 13.656 | 22.835 | 15.066 | 20.652 |
| hex: canterbury/kennedy.xls | 524290 | 15672.8 ± 0.2% | 1477.2 ± 0.2% | 1088.3 ± 0.3% | 658.5 ± 1.1% | 991.2 ± 0.5% | 735.2 ± 0.2% | 10.610 | 14.401 | 23.800 | 15.812 | 21.317 |
| hex: canterbury/lcet10.txt | 524290 | 15633.1 ± 0.2% | 1464.6 ± 0.4% | 1086.0 ± 0.2% | 504.1 ± 1.4% | 990.1 ± 0.6% | 735.2 ± 0.3% | 10.674 | 14.395 | 31.013 | 15.789 | 21.265 |
| hex: canterbury/plrabn12.txt | 524290 | 15682.9 ± 0.9% | 1467.9 ± 0.3% | 1085.3 ± 0.3% | 493.5 ± 0.2% | 992.0 ± 0.3% | 734.3 ± 0.5% | 10.684 | 14.450 | 31.779 | 15.810 | 21.357 |
| hex: canterbury/ptt5 | 524290 | 15605.6 ± 0.5% | 1481.8 ± 0.3% | 1094.3 ± 0.2% | 552.4 ± 1.6% | 993.7 ± 0.2% | 735.7 ± 0.3% | 10.531 | 14.260 | 28.248 | 15.704 | 21.212 |
| hex: canterbury/sum | 76482 | 15645.3 ± 0.0% | 1494.9 ± 0.1% | 1105.5 ± 0.1% | 594.0 ± 2.8% | 998.3 ± 0.1% | 744.7 ± 0.3% | 10.466 | 14.153 | 26.340 | 15.672 | 21.009 |
| hex: canterbury/xargs.1 | 8456 | 15054.7 ± 0.0% | 1494.9 ± 0.2% | 1096.0 ± 0.4% | 654.8 ± 4.0% | 1003.7 ± 0.3% | 728.6 ± 0.1% | 10.071 | 13.736 | 22.993 | 15.000 | 20.661 |
| hex: canterbury-large/E.coli | 524290 | 15676.6 ± 0.3% | 1476.1 ± 0.5% | 1092.2 ± 0.4% | 672.2 ± 0.3% | 991.4 ± 0.3% | 735.8 ± 0.6% | 10.621 | 14.353 | 23.321 | 15.813 | 21.304 |
| hex: canterbury-large/bible.txt | 524290 | 15610.4 ± 0.1% | 1466.4 ± 0.4% | 1086.3 ± 0.9% | 514.4 ± 0.7% | 988.1 ± 0.6% | 735.3 ± 0.6% | 10.645 | 14.370 | 30.349 | 15.799 | 21.231 |
| hex: canterbury-large/world192.txt | 524290 | 15641.3 ± 0.3% | 1471.0 ± 0.2% | 1083.6 ± 0.5% | 502.1 ± 0.3% | 992.3 ± 0.5% | 735.2 ± 0.3% | 10.633 | 14.434 | 31.152 | 15.763 | 21.275 |
| hex: http/html-1kx1024 | 2099200 | 13894.8 ± 0.4% | 1453.7 ± 0.2% | 1063.4 ± 0.2% | 503.0 ± 0.3% | 982.7 ± 0.1% | 692.6 ± 0.4% | 9.558 | 13.066 | 27.621 | 14.139 | 20.060 |
| hex: http/html-16kx64 | 2097280 | 15312.4 ± 0.3% | 1445.7 ± 0.1% | 1076.2 ± 0.1% | 507.8 ± 0.1% | 996.4 ± 0.1% | 735.6 ± 0.0% | 10.592 | 14.229 | 30.153 | 15.368 | 20.815 |
| hex: http/html-1m | 524290 | 15700.1 ± 0.2% | 1471.0 ± 0.5% | 1085.9 ± 0.8% | 501.3 ± 0.5% | 992.2 ± 0.4% | 735.4 ± 0.5% | 10.673 | 14.458 | 31.318 | 15.824 | 21.348 |
| hex: http/json-1kx1024 | 2099200 | 13847.1 ± 0.3% | 1463.4 ± 0.1% | 1067.8 ± 0.1% | 608.9 ± 0.5% | 985.9 ± 0.1% | 692.6 ± 0.1% | 9.462 | 12.968 | 22.740 | 14.045 | 19.994 |
| hex: http/json-16kx64 | 2097280 | 15266.4 ± 1.0% | 1447.7 ± 0.3% | 1077.4 ± 0.2% | 615.2 ± 0.7% | 997.6 ± 0.2% | 735.0 ± 0.1% | 10.545 | 14.170 | 24.815 | 15.304 | 20.771 |
| hex: http/json-1m | 524290 | 15688.4 ± 0.1% | 1477.1 ± 0.3% | 1088.2 ± 0.3% | 631.9 ± 1.0% | 993.4 ± 0.3% | 735.5 ± 0.5% | 10.621 | 14.416 | 24.826 | 15.792 | 21.329 |
| hex: http/js-1kx1024 | 2099200 | 13887.6 ± 0.5% | 1455.1 ± 0.3% | 1058.6 ± 0.2% | 499.1 ± 0.2% | 983.3 ± 0.3% | 692.3 ± 0.1% | 9.544 | 13.119 | 27.825 | 14.123 | 20.061 |
| hex: http/js-16kx64 | 2097280 | 15267.1 ± 0.4% | 1447.8 ± 0.1% | 1075.8 ± 0.1% | 504.4 ± 0.3% | 996.9 ± 0.2% | 735.3 ± 0.1% | 10.545 | 14.192 | 30.266 | 15.315 | 20.763 |
| hex: http/js-1m | 524290 | 15685.1 ± 0.2% | 1468.4 ± 0.2% | 1084.6 ± 0.2% | 512.9 ± 0.6% | 991.2 ± 0.2% | 735.0 ± 0.4% | 10.681 | 14.461 | 30.582 | 15.824 | 21.341 |
| hex: http/css-1kx1024 | 2099200 | 13877.4 ± 0.5% | 1456.1 ± 0.1% | 1062.9 ± 0.4% | 531.2 ± 0.5% | 982.9 ± 0.3% | 692.4 ± 0.3% | 9.530 | 13.057 | 26.123 | 14.119 | 20.044 |
| hex: http/css-16kx64 | 2097280 | 15300.3 ± 0.1% | 1444.3 ± 0.1% | 1075.0 ± 0.2% | 539.5 ± 0.6% | 999.2 ± 0.5% | 735.0 ± 0.2% | 10.594 | 14.233 | 28.362 | 15.312 | 20.816 |
| hex: http/css-1m | 524290 | 15668.9 ± 0.2% | 1470.4 ± 0.2% | 1087.7 ± 0.2% | 524.7 ± 0.4% | 989.9 ± 0.2% | 735.7 ± 0.2% | 10.656 | 14.405 | 29.861 | 15.828 | 21.299 |
| hex: shuffled/dickens-1m | 524290 | 15648.0 ± 0.2% | 1466.7 ± 0.2% | 1087.1 ± 0.4% | 504.0 ± 0.6% | 988.8 ± 0.3% | 734.3 ± 0.3% | 10.669 | 14.395 | 31.048 | 15.826 | 21.309 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 938.0 ± 0.1% | 935.8 ± 0.4% | 1023.9 ± 0.3% | 301.5 ± 0.4% | 664.5 ± 0.1% | 309.7 ± 1.8% | 1.002 | 0.916 | 3.112 | 1.412 | 3.028 |
| qlog records, JSON text sequence | 1467503 | 787.0 ± 0.5% | 818.7 ± 0.1% | 795.6 ± 1.0% | 245.0 ± 1.2% | 701.1 ± 0.9% | 251.7 ± 1.9% | 0.961 | 0.989 | 3.213 | 1.123 | 3.126 |
| string: silesia/dickens | 172528 | 5053.7 ± 0.3% | 1878.1 ± 0.2% | 2646.3 ± 0.5% | 362.8 ± 1.2% | 2856.2 ± 0.3% | 547.9 ± 1.2% | 2.691 | 1.910 | 13.930 | 1.769 | 9.225 |
| string: silesia/nci | 1075110 | 4315.3 ± 0.3% | 2243.6 ± 0.3% | 3001.1 ± 0.1% | 543.2 ± 1.2% | 3004.5 ± 0.8% | 603.0 ± 2.3% | 1.923 | 1.438 | 7.944 | 1.436 | 7.157 |
| string: silesia/reymont | 1075159 | 2985.5 ± 2.6% | 1820.5 ± 1.3% | 2064.4 ± 0.5% | 373.3 ± 0.9% | 2141.5 ± 0.7% | 537.3 ± 1.1% | 1.640 | 1.446 | 7.998 | 1.394 | 5.556 |
| string: silesia/samba | 97582 | 3501.6 ± 0.4% | 2026.5 ± 0.2% | 2617.7 ± 0.6% | 328.9 ± 0.6% | 1498.3 ± 0.3% | 431.6 ± 1.1% | 1.728 | 1.338 | 10.645 | 2.337 | 8.114 |
| string: silesia/webster | 1098490 | 3678.6 ± 0.5% | 1517.9 ± 0.3% | 2016.7 ± 0.3% | 359.6 ± 0.5% | 2178.4 ± 1.7% | 496.9 ± 1.4% | 2.423 | 1.824 | 10.230 | 1.689 | 7.403 |
| string: silesia/xml | 1090118 | 4815.6 ± 0.3% | 2362.1 ± 0.5% | 2526.4 ± 0.2% | 455.8 ± 0.6% | 2858.7 ± 0.7% | 568.4 ± 0.5% | 2.039 | 1.906 | 10.565 | 1.685 | 8.472 |
| string: canterbury/alice29.txt | 159425 | 4350.1 ± 0.9% | 1599.8 ± 0.2% | 2459.4 ± 0.3% | 343.3 ± 0.3% | 2501.8 ± 1.4% | 507.7 ± 1.5% | 2.719 | 1.769 | 12.673 | 1.739 | 8.569 |
| string: canterbury/asyoulik.txt | 132198 | 3488.2 ± 2.0% | 1459.0 ± 0.3% | 2247.3 ± 0.6% | 335.4 ± 1.1% | 2084.0 ± 0.4% | 466.1 ± 0.3% | 2.391 | 1.552 | 10.399 | 1.674 | 7.484 |
| string: canterbury/lcet10.txt | 441884 | 5148.3 ± 0.2% | 1854.4 ± 0.2% | 2343.6 ± 0.9% | 389.9 ± 0.3% | 2852.0 ± 0.5% | 536.5 ± 0.8% | 2.776 | 2.197 | 13.203 | 1.805 | 9.597 |
| string: canterbury/plrabn12.txt | 503330 | 4141.8 ± 0.4% | 1737.9 ± 0.1% | 2061.8 ± 0.4% | 359.4 ± 0.8% | 2518.0 ± 0.7% | 499.0 ± 1.5% | 2.383 | 2.009 | 11.524 | 1.645 | 8.300 |
| string: canterbury-large/E.coli | 1048578 | 11922.9 ± 0.3% | 3609.8 ± 0.3% | 3260.1 ± 0.2% | 936.4 ± 1.3% | 6066.1 ± 0.6% | 761.8 ± 2.0% | 3.303 | 3.657 | 12.732 | 1.965 | 15.651 |
| string: canterbury-large/bible.txt | 1055886 | 6912.2 ± 1.6% | 2939.3 ± 0.4% | 2837.5 ± 0.4% | 418.4 ± 1.1% | 3768.3 ± 1.3% | 616.0 ± 1.8% | 2.352 | 2.436 | 16.521 | 1.834 | 11.222 |
| string: canterbury-large/world192.txt | 1103121 | 3392.2 ± 0.2% | 1482.9 ± 0.3% | 2012.4 ± 0.6% | 352.4 ± 0.5% | 2121.7 ± 0.9% | 503.2 ± 1.2% | 2.288 | 1.686 | 9.625 | 1.599 | 6.741 |
| string: http/html-1m | 1058582 | 6246.3 ± 2.9% | 2740.2 ± 1.1% | 2708.1 ± 0.8% | 442.3 ± 0.2% | 3479.7 ± 0.8% | 603.6 ± 1.4% | 2.280 | 2.307 | 14.123 | 1.795 | 10.348 |
| string: http/json-1m | 1190272 | 2560.4 ± 0.6% | 877.4 ± 0.4% | 2256.4 ± 0.2% | 391.7 ± 0.5% | 1065.1 ± 0.3% | 443.3 ± 1.3% | 2.918 | 1.135 | 6.536 | 2.404 | 5.776 |
| string: http/js-1m | 1144362 | 2281.3 ± 1.5% | 1029.1 ± 0.5% | 1642.3 ± 0.4% | 321.2 ± 0.6% | 1525.1 ± 0.6% | 419.7 ± 0.9% | 2.217 | 1.389 | 7.102 | 1.496 | 5.436 |
| string: http/css-1m | 1097820 | 2654.3 ± 1.8% | 1678.1 ± 2.3% | 2222.5 ± 2.4% | 405.4 ± 0.7% | 1943.8 ± 2.3% | 488.4 ± 0.8% | 1.582 | 1.194 | 6.547 | 1.366 | 5.434 |
| string: dickens as Cyrillic and CJK | 1883069 | 3083.1 ± 0.2% | 1685.1 ± 0.4% | 893.5 ± 0.2% | 350.7 ± 0.3% | 667.2 ± 0.3% | 158.5 ± 1.0% | 1.830 | 3.451 | 8.792 | 4.621 | 19.455 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.5 ± 0.3% | 980.1 ± 0.3% | 1203.1 ± 0.4% | 216.3 ± 0.2% | 471.7 ± 0.8% | 252.8 ± 4.0% | 1.357 | 1.105 | 6.145 | 2.819 | 5.259 |
| hex: silesia/dickens | 524290 | 12013.2 ± 0.2% | 3616.7 ± 2.2% | 3297.6 ± 1.8% | 517.6 ± 3.0% | 6135.7 ± 1.8% | 782.1 ± 3.8% | 3.322 | 3.643 | 23.211 | 1.958 | 15.360 |
| hex: silesia/mozilla | 524290 | 11995.1 ± 0.1% | 3615.9 ± 0.2% | 3308.4 ± 0.1% | 452.0 ± 1.0% | 6127.0 ± 0.8% | 783.4 ± 0.5% | 3.317 | 3.626 | 26.539 | 1.958 | 15.311 |
| hex: silesia/mr | 524290 | 11999.1 ± 0.1% | 3617.5 ± 0.3% | 3286.8 ± 0.4% | 569.6 ± 0.9% | 6094.6 ± 1.0% | 781.9 ± 0.7% | 3.317 | 3.651 | 21.066 | 1.969 | 15.345 |
| hex: silesia/nci | 524290 | 12013.9 ± 0.1% | 3619.3 ± 0.1% | 3303.1 ± 0.2% | 617.3 ± 1.2% | 6088.5 ± 0.9% | 782.8 ± 0.4% | 3.319 | 3.637 | 19.461 | 1.973 | 15.348 |
| hex: silesia/ooffice | 524290 | 12008.7 ± 0.0% | 3622.3 ± 0.2% | 3293.4 ± 0.2% | 390.6 ± 1.5% | 6124.8 ± 1.3% | 782.6 ± 0.8% | 3.315 | 3.646 | 30.748 | 1.961 | 15.345 |
| hex: silesia/osdb | 524290 | 12005.6 ± 0.1% | 3620.1 ± 0.3% | 3295.5 ± 0.3% | 463.2 ± 2.8% | 6061.9 ± 0.6% | 783.8 ± 0.5% | 3.316 | 3.643 | 25.918 | 1.980 | 15.318 |
| hex: silesia/reymont | 524290 | 12012.0 ± 0.1% | 3617.3 ± 0.3% | 3294.0 ± 0.2% | 499.4 ± 1.7% | 6121.8 ± 1.5% | 783.6 ± 0.2% | 3.321 | 3.647 | 24.055 | 1.962 | 15.330 |
| hex: silesia/samba | 524290 | 12005.1 ± 0.1% | 3623.0 ± 0.2% | 3310.1 ± 0.2% | 395.9 ± 1.0% | 6116.1 ± 1.4% | 783.1 ± 0.2% | 3.314 | 3.627 | 30.325 | 1.963 | 15.330 |
| hex: silesia/sao | 524290 | 12020.0 ± 0.1% | 3619.8 ± 0.3% | 3301.7 ± 0.2% | 336.0 ± 1.3% | 6119.9 ± 1.5% | 783.6 ± 0.6% | 3.321 | 3.641 | 35.773 | 1.964 | 15.340 |
| hex: silesia/webster | 524290 | 11986.0 ± 0.2% | 3617.3 ± 0.3% | 3290.2 ± 0.1% | 449.5 ± 1.7% | 6012.5 ± 0.9% | 781.8 ± 0.4% | 3.314 | 3.643 | 26.666 | 1.994 | 15.330 |
| hex: silesia/x-ray | 524290 | 11979.6 ± 0.1% | 3619.6 ± 0.2% | 3294.3 ± 0.2% | 468.4 ± 2.3% | 6060.4 ± 1.8% | 782.6 ± 0.5% | 3.310 | 3.637 | 25.574 | 1.977 | 15.308 |
| hex: silesia/xml | 524290 | 11993.1 ± 0.1% | 3617.1 ± 0.3% | 3301.0 ± 0.1% | 524.0 ± 0.5% | 6104.5 ± 1.7% | 784.0 ± 0.2% | 3.316 | 3.633 | 22.889 | 1.965 | 15.296 |
| hex: canterbury/alice29.txt | 304180 | 12011.6 ± 0.1% | 3632.8 ± 0.1% | 3375.2 ± 0.1% | 520.7 ± 0.3% | 6130.2 ± 0.7% | 782.0 ± 0.3% | 3.306 | 3.559 | 23.067 | 1.959 | 15.361 |
| hex: canterbury/asyoulik.txt | 250360 | 12006.2 ± 0.2% | 3637.0 ± 0.1% | 3377.4 ± 0.1% | 514.3 ± 0.4% | 6173.6 ± 1.7% | 780.8 ± 0.6% | 3.301 | 3.555 | 23.345 | 1.945 | 15.376 |
| hex: canterbury/cp.html | 49208 | 11911.4 ± 0.1% | 3639.6 ± 0.0% | 3278.7 ± 0.3% | 480.3 ± 0.7% | 6256.7 ± 1.9% | 763.8 ± 1.1% | 3.273 | 3.633 | 24.797 | 1.904 | 15.594 |
| hex: canterbury/fields.c | 22302 | 11776.5 ± 0.1% | 3629.1 ± 0.1% | 3395.0 ± 0.3% | 511.9 ± 0.9% | 6243.1 ± 0.4% | 750.3 ± 2.9% | 3.245 | 3.469 | 23.005 | 1.886 | 15.697 |
| hex: canterbury/grammar.lsp | 7444 | 11253.1 ± 0.1% | 3601.7 ± 0.0% | 3339.6 ± 0.6% | 551.5 ± 2.7% | 6171.3 ± 0.5% | 722.2 ± 2.2% | 3.124 | 3.370 | 20.405 | 1.823 | 15.581 |
| hex: canterbury/kennedy.xls | 524290 | 12013.1 ± 0.1% | 3613.6 ± 0.3% | 3303.3 ± 0.3% | 665.8 ± 2.7% | 6126.7 ± 1.2% | 760.9 ± 6.8% | 3.324 | 3.637 | 18.043 | 1.961 | 15.787 |
| hex: canterbury/lcet10.txt | 524290 | 11998.9 ± 0.2% | 3617.9 ± 0.4% | 3292.8 ± 0.1% | 506.6 ± 0.8% | 6143.4 ± 1.4% | 771.2 ± 0.6% | 3.317 | 3.644 | 23.687 | 1.953 | 15.558 |
| hex: canterbury/plrabn12.txt | 524290 | 11953.0 ± 0.3% | 3615.7 ± 0.3% | 3290.0 ± 0.1% | 502.9 ± 0.6% | 6046.3 ± 1.2% | 773.9 ± 0.7% | 3.306 | 3.633 | 23.768 | 1.977 | 15.446 |
| hex: canterbury/ptt5 | 524290 | 11992.6 ± 0.3% | 3612.8 ± 0.1% | 3295.4 ± 0.6% | 557.7 ± 0.4% | 6066.7 ± 1.3% | 772.3 ± 1.4% | 3.319 | 3.639 | 21.503 | 1.977 | 15.529 |
| hex: canterbury/sum | 76482 | 11917.2 ± 0.0% | 3634.2 ± 0.1% | 3355.4 ± 0.3% | 500.0 ± 1.0% | 6186.2 ± 0.7% | 766.6 ± 0.8% | 3.279 | 3.552 | 23.834 | 1.926 | 15.545 |
| hex: canterbury/xargs.1 | 8456 | 11336.1 ± 0.1% | 3603.1 ± 0.0% | 3366.0 ± 0.1% | 484.7 ± 0.8% | 6145.1 ± 0.2% | 749.2 ± 1.2% | 3.146 | 3.368 | 23.387 | 1.845 | 15.132 |
| hex: canterbury-large/E.coli | 524290 | 11974.9 ± 0.2% | 3618.8 ± 0.2% | 3290.8 ± 0.5% | 688.1 ± 0.4% | 6117.4 ± 0.9% | 761.4 ± 7.3% | 3.309 | 3.639 | 17.403 | 1.958 | 15.728 |
| hex: canterbury-large/bible.txt | 524290 | 11997.3 ± 0.1% | 3618.0 ± 0.2% | 3299.7 ± 0.2% | 513.8 ± 1.2% | 6115.1 ± 1.0% | 761.9 ± 2.0% | 3.316 | 3.636 | 23.350 | 1.962 | 15.746 |
| hex: canterbury-large/world192.txt | 524290 | 12012.9 ± 0.1% | 3616.4 ± 0.4% | 3305.1 ± 0.4% | 487.2 ± 3.1% | 6104.5 ± 1.1% | 766.1 ± 1.0% | 3.322 | 3.635 | 24.655 | 1.968 | 15.681 |
| hex: http/html-1kx1024 | 2099200 | 8865.6 ± 3.5% | 3463.1 ± 0.5% | 2878.4 ± 0.4% | 476.4 ± 0.9% | 5168.3 ± 0.9% | 627.5 ± 2.5% | 2.560 | 3.080 | 18.610 | 1.715 | 14.127 |
| hex: http/html-16kx64 | 2097280 | 11781.9 ± 0.1% | 3612.0 ± 0.1% | 3262.0 ± 0.3% | 477.1 ± 0.9% | 6009.1 ± 0.3% | 745.7 ± 3.2% | 3.262 | 3.612 | 24.693 | 1.961 | 15.799 |
| hex: http/html-1m | 524290 | 12023.5 ± 0.1% | 3618.4 ± 0.2% | 3294.3 ± 0.3% | 493.6 ± 1.0% | 6126.3 ± 1.5% | 756.5 ± 1.4% | 3.323 | 3.650 | 24.359 | 1.963 | 15.893 |
| hex: http/json-1kx1024 | 2099200 | 8818.4 ± 4.8% | 3460.5 ± 0.2% | 2874.9 ± 0.3% | 576.1 ± 0.6% | 5154.2 ± 0.3% | 624.9 ± 2.0% | 2.548 | 3.067 | 15.306 | 1.711 | 14.112 |
| hex: http/json-16kx64 | 2097280 | 11774.7 ± 0.1% | 3610.8 ± 0.1% | 3258.8 ± 0.2% | 574.4 ± 1.2% | 6016.8 ± 0.6% | 741.5 ± 1.0% | 3.261 | 3.613 | 20.500 | 1.957 | 15.879 |
| hex: http/json-1m | 524290 | 12016.4 ± 0.2% | 3619.0 ± 0.1% | 3297.2 ± 0.2% | 595.3 ± 1.3% | 6081.5 ± 1.7% | 760.7 ± 4.4% | 3.320 | 3.644 | 20.184 | 1.976 | 15.796 |
| hex: http/js-1kx1024 | 2099200 | 8832.7 ± 3.8% | 3465.0 ± 0.1% | 2876.6 ± 0.3% | 480.7 ± 0.7% | 5154.2 ± 1.1% | 628.3 ± 1.1% | 2.549 | 3.071 | 18.375 | 1.714 | 14.058 |
| hex: http/js-16kx64 | 2097280 | 11762.5 ± 0.1% | 3611.0 ± 0.1% | 3249.5 ± 0.4% | 481.2 ± 0.8% | 6010.6 ± 0.3% | 730.6 ± 2.6% | 3.257 | 3.620 | 24.447 | 1.957 | 16.101 |
| hex: http/js-1m | 524290 | 12018.2 ± 0.1% | 3620.7 ± 0.2% | 3302.2 ± 0.1% | 517.0 ± 5.7% | 6110.6 ± 1.8% | 754.9 ± 2.5% | 3.319 | 3.639 | 23.247 | 1.967 | 15.921 |
| hex: http/css-1kx1024 | 2099200 | 8879.6 ± 6.0% | 3463.0 ± 0.2% | 2873.6 ± 0.3% | 488.9 ± 1.4% | 5151.0 ± 1.2% | 625.3 ± 4.9% | 2.564 | 3.090 | 18.161 | 1.724 | 14.201 |
| hex: http/css-16kx64 | 2097280 | 11768.2 ± 0.2% | 3612.1 ± 0.2% | 3257.9 ± 0.4% | 493.9 ± 1.7% | 6018.7 ± 0.3% | 739.7 ± 3.9% | 3.258 | 3.612 | 23.827 | 1.955 | 15.910 |
| hex: http/css-1m | 524290 | 12011.1 ± 0.1% | 3622.6 ± 0.1% | 3303.0 ± 0.2% | 512.1 ± 1.8% | 6127.5 ± 2.4% | 756.6 ± 1.6% | 3.316 | 3.636 | 23.453 | 1.960 | 15.875 |
| hex: shuffled/dickens-1m | 524290 | 12012.5 ± 0.1% | 3619.8 ± 0.2% | 3296.6 ± 0.1% | 504.0 ± 1.3% | 6133.7 ± 1.0% | 764.2 ± 0.5% | 3.319 | 3.644 | 23.834 | 1.958 | 15.719 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1014.1 ± 0.7% | 935.8 ± 0.4% | 1023.9 ± 0.3% | 301.5 ± 0.4% | 664.5 ± 0.1% | 309.7 ± 1.8% | 1.084 | 0.990 | 3.364 | 1.526 | 3.274 |
| qlog records, JSON text sequence | 1467503 | 843.5 ± 0.4% | 818.7 ± 0.1% | 795.6 ± 1.0% | 245.0 ± 1.2% | 701.1 ± 0.9% | 251.7 ± 1.9% | 1.030 | 1.060 | 3.443 | 1.203 | 3.351 |
| string: silesia/dickens | 172528 | 5055.9 ± 0.4% | 1878.1 ± 0.2% | 2646.3 ± 0.5% | 362.8 ± 1.2% | 2856.2 ± 0.3% | 547.9 ± 1.2% | 2.692 | 1.911 | 13.936 | 1.770 | 9.229 |
| string: silesia/nci | 1075110 | 4317.6 ± 0.4% | 2243.6 ± 0.3% | 3001.1 ± 0.1% | 543.2 ± 1.2% | 3004.5 ± 0.8% | 603.0 ± 2.3% | 1.924 | 1.439 | 7.948 | 1.437 | 7.160 |
| string: silesia/reymont | 1075159 | 2989.0 ± 3.1% | 1820.5 ± 1.3% | 2064.4 ± 0.5% | 373.3 ± 0.9% | 2141.5 ± 0.7% | 537.3 ± 1.1% | 1.642 | 1.448 | 8.007 | 1.396 | 5.563 |
| string: silesia/samba | 97582 | 3512.1 ± 0.3% | 2026.5 ± 0.2% | 2617.7 ± 0.6% | 328.9 ± 0.6% | 1498.3 ± 0.3% | 431.6 ± 1.1% | 1.733 | 1.342 | 10.677 | 2.344 | 8.138 |
| string: silesia/webster | 1098490 | 3677.4 ± 0.6% | 1517.9 ± 0.3% | 2016.7 ± 0.3% | 359.6 ± 0.5% | 2178.4 ± 1.7% | 496.9 ± 1.4% | 2.423 | 1.823 | 10.227 | 1.688 | 7.401 |
| string: silesia/xml | 1090118 | 4818.5 ± 0.4% | 2362.1 ± 0.5% | 2526.4 ± 0.2% | 455.8 ± 0.6% | 2858.7 ± 0.7% | 568.4 ± 0.5% | 2.040 | 1.907 | 10.572 | 1.686 | 8.478 |
| string: canterbury/alice29.txt | 159425 | 4355.2 ± 0.9% | 1599.8 ± 0.2% | 2459.4 ± 0.3% | 343.3 ± 0.3% | 2501.8 ± 1.4% | 507.7 ± 1.5% | 2.722 | 1.771 | 12.688 | 1.741 | 8.579 |
| string: canterbury/asyoulik.txt | 132198 | 3492.4 ± 1.1% | 1459.0 ± 0.3% | 2247.3 ± 0.6% | 335.4 ± 1.1% | 2084.0 ± 0.4% | 466.1 ± 0.3% | 2.394 | 1.554 | 10.411 | 1.676 | 7.493 |
| string: canterbury/lcet10.txt | 441884 | 5142.6 ± 0.3% | 1854.4 ± 0.2% | 2343.6 ± 0.9% | 389.9 ± 0.3% | 2852.0 ± 0.5% | 536.5 ± 0.8% | 2.773 | 2.194 | 13.188 | 1.803 | 9.586 |
| string: canterbury/plrabn12.txt | 503330 | 4143.2 ± 0.6% | 1737.9 ± 0.1% | 2061.8 ± 0.4% | 359.4 ± 0.8% | 2518.0 ± 0.7% | 499.0 ± 1.5% | 2.384 | 2.009 | 11.528 | 1.645 | 8.303 |
| string: canterbury-large/E.coli | 1048578 | 11933.0 ± 0.2% | 3609.8 ± 0.3% | 3260.1 ± 0.2% | 936.4 ± 1.3% | 6066.1 ± 0.6% | 761.8 ± 2.0% | 3.306 | 3.660 | 12.743 | 1.967 | 15.664 |
| string: canterbury-large/bible.txt | 1055886 | 6938.4 ± 1.3% | 2939.3 ± 0.4% | 2837.5 ± 0.4% | 418.4 ± 1.1% | 3768.3 ± 1.3% | 616.0 ± 1.8% | 2.361 | 2.445 | 16.584 | 1.841 | 11.265 |
| string: canterbury-large/world192.txt | 1103121 | 3395.1 ± 0.3% | 1482.9 ± 0.3% | 2012.4 ± 0.6% | 352.4 ± 0.5% | 2121.7 ± 0.9% | 503.2 ± 1.2% | 2.289 | 1.687 | 9.634 | 1.600 | 6.747 |
| string: http/html-1m | 1058582 | 6276.2 ± 3.4% | 2740.2 ± 1.1% | 2708.1 ± 0.8% | 442.3 ± 0.2% | 3479.7 ± 0.8% | 603.6 ± 1.4% | 2.290 | 2.318 | 14.191 | 1.804 | 10.398 |
| string: http/json-1m | 1190272 | 2559.3 ± 0.4% | 877.4 ± 0.4% | 2256.4 ± 0.2% | 391.7 ± 0.5% | 1065.1 ± 0.3% | 443.3 ± 1.3% | 2.917 | 1.134 | 6.534 | 2.403 | 5.774 |
| string: http/js-1m | 1144362 | 2288.2 ± 1.5% | 1029.1 ± 0.5% | 1642.3 ± 0.4% | 321.2 ± 0.6% | 1525.1 ± 0.6% | 419.7 ± 0.9% | 2.224 | 1.393 | 7.124 | 1.500 | 5.452 |
| string: http/css-1m | 1097820 | 2661.7 ± 1.9% | 1678.1 ± 2.3% | 2222.5 ± 2.4% | 405.4 ± 0.7% | 1943.8 ± 2.3% | 488.4 ± 0.8% | 1.586 | 1.198 | 6.565 | 1.369 | 5.450 |
| string: dickens as Cyrillic and CJK | 1883069 | 3080.6 ± 0.5% | 1685.1 ± 0.4% | 893.5 ± 0.2% | 350.7 ± 0.3% | 667.2 ± 0.3% | 158.5 ± 1.0% | 1.828 | 3.448 | 8.785 | 4.617 | 19.439 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.5 ± 0.3% | 980.1 ± 0.3% | 1203.1 ± 0.4% | 216.3 ± 0.2% | 471.7 ± 0.8% | 252.8 ± 4.0% | 1.354 | 1.103 | 6.136 | 2.814 | 5.251 |
| hex: silesia/dickens | 524290 | 12011.3 ± 0.2% | 3616.7 ± 2.2% | 3297.6 ± 1.8% | 517.6 ± 3.0% | 6135.7 ± 1.8% | 782.1 ± 3.8% | 3.321 | 3.642 | 23.208 | 1.958 | 15.357 |
| hex: silesia/mozilla | 524290 | 11990.8 ± 0.2% | 3615.9 ± 0.2% | 3308.4 ± 0.1% | 452.0 ± 1.0% | 6127.0 ± 0.8% | 783.4 ± 0.5% | 3.316 | 3.624 | 26.529 | 1.957 | 15.306 |
| hex: silesia/mr | 524290 | 11992.4 ± 0.1% | 3617.5 ± 0.3% | 3286.8 ± 0.4% | 569.6 ± 0.9% | 6094.6 ± 1.0% | 781.9 ± 0.7% | 3.315 | 3.649 | 21.054 | 1.968 | 15.337 |
| hex: silesia/nci | 524290 | 12010.9 ± 0.2% | 3619.3 ± 0.1% | 3303.1 ± 0.2% | 617.3 ± 1.2% | 6088.5 ± 0.9% | 782.8 ± 0.4% | 3.319 | 3.636 | 19.456 | 1.973 | 15.344 |
| hex: silesia/ooffice | 524290 | 11989.7 ± 0.1% | 3622.3 ± 0.2% | 3293.4 ± 0.2% | 390.6 ± 1.5% | 6124.8 ± 1.3% | 782.6 ± 0.8% | 3.310 | 3.641 | 30.699 | 1.958 | 15.320 |
| hex: silesia/osdb | 524290 | 12006.0 ± 0.2% | 3620.1 ± 0.3% | 3295.5 ± 0.3% | 463.2 ± 2.8% | 6061.9 ± 0.6% | 783.8 ± 0.5% | 3.317 | 3.643 | 25.919 | 1.981 | 15.319 |
| hex: silesia/reymont | 524290 | 12003.5 ± 0.1% | 3617.3 ± 0.3% | 3294.0 ± 0.2% | 499.4 ± 1.7% | 6121.8 ± 1.5% | 783.6 ± 0.2% | 3.318 | 3.644 | 24.038 | 1.961 | 15.319 |
| hex: silesia/samba | 524290 | 12007.7 ± 0.0% | 3623.0 ± 0.2% | 3310.1 ± 0.2% | 395.9 ± 1.0% | 6116.1 ± 1.4% | 783.1 ± 0.2% | 3.314 | 3.628 | 30.331 | 1.963 | 15.333 |
| hex: silesia/sao | 524290 | 12023.1 ± 0.1% | 3619.8 ± 0.3% | 3301.7 ± 0.2% | 336.0 ± 1.3% | 6119.9 ± 1.5% | 783.6 ± 0.6% | 3.322 | 3.641 | 35.783 | 1.965 | 15.344 |
| hex: silesia/webster | 524290 | 11988.8 ± 0.1% | 3617.3 ± 0.3% | 3290.2 ± 0.1% | 449.5 ± 1.7% | 6012.5 ± 0.9% | 781.8 ± 0.4% | 3.314 | 3.644 | 26.672 | 1.994 | 15.334 |
| hex: silesia/x-ray | 524290 | 11989.0 ± 0.1% | 3619.6 ± 0.2% | 3294.3 ± 0.2% | 468.4 ± 2.3% | 6060.4 ± 1.8% | 782.6 ± 0.5% | 3.312 | 3.639 | 25.594 | 1.978 | 15.320 |
| hex: silesia/xml | 524290 | 11990.0 ± 0.3% | 3617.1 ± 0.3% | 3301.0 ± 0.1% | 524.0 ± 0.5% | 6104.5 ± 1.7% | 784.0 ± 0.2% | 3.315 | 3.632 | 22.883 | 1.964 | 15.292 |
| hex: canterbury/alice29.txt | 304180 | 12016.9 ± 0.1% | 3632.8 ± 0.1% | 3375.2 ± 0.1% | 520.7 ± 0.3% | 6130.2 ± 0.7% | 782.0 ± 0.3% | 3.308 | 3.560 | 23.078 | 1.960 | 15.368 |
| hex: canterbury/asyoulik.txt | 250360 | 12008.6 ± 0.1% | 3637.0 ± 0.1% | 3377.4 ± 0.1% | 514.3 ± 0.4% | 6173.6 ± 1.7% | 780.8 ± 0.6% | 3.302 | 3.556 | 23.349 | 1.945 | 15.379 |
| hex: canterbury/cp.html | 49208 | 11909.7 ± 0.0% | 3639.6 ± 0.0% | 3278.7 ± 0.3% | 480.3 ± 0.7% | 6256.7 ± 1.9% | 763.8 ± 1.1% | 3.272 | 3.632 | 24.794 | 1.904 | 15.592 |
| hex: canterbury/fields.c | 22302 | 11780.8 ± 0.0% | 3629.1 ± 0.1% | 3395.0 ± 0.3% | 511.9 ± 0.9% | 6243.1 ± 0.4% | 750.3 ± 2.9% | 3.246 | 3.470 | 23.014 | 1.887 | 15.702 |
| hex: canterbury/grammar.lsp | 7444 | 11316.7 ± 0.0% | 3601.7 ± 0.0% | 3339.6 ± 0.6% | 551.5 ± 2.7% | 6171.3 ± 0.5% | 722.2 ± 2.2% | 3.142 | 3.389 | 20.521 | 1.834 | 15.669 |
| hex: canterbury/kennedy.xls | 524290 | 12016.9 ± 0.1% | 3613.6 ± 0.3% | 3303.3 ± 0.3% | 665.8 ± 2.7% | 6126.7 ± 1.2% | 760.9 ± 6.8% | 3.325 | 3.638 | 18.049 | 1.961 | 15.792 |
| hex: canterbury/lcet10.txt | 524290 | 11997.1 ± 0.1% | 3617.9 ± 0.4% | 3292.8 ± 0.1% | 506.6 ± 0.8% | 6143.4 ± 1.4% | 771.2 ± 0.6% | 3.316 | 3.643 | 23.683 | 1.953 | 15.556 |
| hex: canterbury/plrabn12.txt | 524290 | 11971.4 ± 0.3% | 3615.7 ± 0.3% | 3290.0 ± 0.1% | 502.9 ± 0.6% | 6046.3 ± 1.2% | 773.9 ± 0.7% | 3.311 | 3.639 | 23.805 | 1.980 | 15.470 |
| hex: canterbury/ptt5 | 524290 | 12000.9 ± 0.1% | 3612.8 ± 0.1% | 3295.4 ± 0.6% | 557.7 ± 0.4% | 6066.7 ± 1.3% | 772.3 ± 1.4% | 3.322 | 3.642 | 21.518 | 1.978 | 15.539 |
| hex: canterbury/sum | 76482 | 11916.4 ± 0.1% | 3634.2 ± 0.1% | 3355.4 ± 0.3% | 500.0 ± 1.0% | 6186.2 ± 0.7% | 766.6 ± 0.8% | 3.279 | 3.551 | 23.833 | 1.926 | 15.544 |
| hex: canterbury/xargs.1 | 8456 | 11337.2 ± 0.1% | 3603.1 ± 0.0% | 3366.0 ± 0.1% | 484.7 ± 0.8% | 6145.1 ± 0.2% | 749.2 ± 1.2% | 3.146 | 3.368 | 23.389 | 1.845 | 15.133 |
| hex: canterbury-large/E.coli | 524290 | 11984.6 ± 0.1% | 3618.8 ± 0.2% | 3290.8 ± 0.5% | 688.1 ± 0.4% | 6117.4 ± 0.9% | 761.4 ± 7.3% | 3.312 | 3.642 | 17.417 | 1.959 | 15.741 |
| hex: canterbury-large/bible.txt | 524290 | 12000.0 ± 0.1% | 3618.0 ± 0.2% | 3299.7 ± 0.2% | 513.8 ± 1.2% | 6115.1 ± 1.0% | 761.9 ± 2.0% | 3.317 | 3.637 | 23.355 | 1.962 | 15.749 |
| hex: canterbury-large/world192.txt | 524290 | 12021.6 ± 0.0% | 3616.4 ± 0.4% | 3305.1 ± 0.4% | 487.2 ± 3.1% | 6104.5 ± 1.1% | 766.1 ± 1.0% | 3.324 | 3.637 | 24.673 | 1.969 | 15.692 |
| hex: http/html-1kx1024 | 2099200 | 8916.5 ± 3.9% | 3463.1 ± 0.5% | 2878.4 ± 0.4% | 476.4 ± 0.9% | 5168.3 ± 0.9% | 627.5 ± 2.5% | 2.575 | 3.098 | 18.717 | 1.725 | 14.209 |
| hex: http/html-16kx64 | 2097280 | 11778.6 ± 0.2% | 3612.0 ± 0.1% | 3262.0 ± 0.3% | 477.1 ± 0.9% | 6009.1 ± 0.3% | 745.7 ± 3.2% | 3.261 | 3.611 | 24.686 | 1.960 | 15.795 |
| hex: http/html-1m | 524290 | 12025.1 ± 0.0% | 3618.4 ± 0.2% | 3294.3 ± 0.3% | 493.6 ± 1.0% | 6126.3 ± 1.5% | 756.5 ± 1.4% | 3.323 | 3.650 | 24.362 | 1.963 | 15.895 |
| hex: http/json-1kx1024 | 2099200 | 8844.1 ± 4.7% | 3460.5 ± 0.2% | 2874.9 ± 0.3% | 576.1 ± 0.6% | 5154.2 ± 0.3% | 624.9 ± 2.0% | 2.556 | 3.076 | 15.351 | 1.716 | 14.154 |
| hex: http/json-16kx64 | 2097280 | 11771.5 ± 0.1% | 3610.8 ± 0.1% | 3258.8 ± 0.2% | 574.4 ± 1.2% | 6016.8 ± 0.6% | 741.5 ± 1.0% | 3.260 | 3.612 | 20.494 | 1.956 | 15.875 |
| hex: http/json-1m | 524290 | 12011.5 ± 0.1% | 3619.0 ± 0.1% | 3297.2 ± 0.2% | 595.3 ± 1.3% | 6081.5 ± 1.7% | 760.7 ± 4.4% | 3.319 | 3.643 | 20.176 | 1.975 | 15.790 |
| hex: http/js-1kx1024 | 2099200 | 8857.3 ± 4.6% | 3465.0 ± 0.1% | 2876.6 ± 0.3% | 480.7 ± 0.7% | 5154.2 ± 1.1% | 628.3 ± 1.1% | 2.556 | 3.079 | 18.426 | 1.718 | 14.097 |
| hex: http/js-16kx64 | 2097280 | 11771.7 ± 0.1% | 3611.0 ± 0.1% | 3249.5 ± 0.4% | 481.2 ± 0.8% | 6010.6 ± 0.3% | 730.6 ± 2.6% | 3.260 | 3.623 | 24.466 | 1.958 | 16.114 |
| hex: http/js-1m | 524290 | 12015.5 ± 0.1% | 3620.7 ± 0.2% | 3302.2 ± 0.1% | 517.0 ± 5.7% | 6110.6 ± 1.8% | 754.9 ± 2.5% | 3.319 | 3.639 | 23.242 | 1.966 | 15.918 |
| hex: http/css-1kx1024 | 2099200 | 8886.5 ± 5.8% | 3463.0 ± 0.2% | 2873.6 ± 0.3% | 488.9 ± 1.4% | 5151.0 ± 1.2% | 625.3 ± 4.9% | 2.566 | 3.093 | 18.176 | 1.725 | 14.212 |
| hex: http/css-16kx64 | 2097280 | 11775.3 ± 0.2% | 3612.1 ± 0.2% | 3257.9 ± 0.4% | 493.9 ± 1.7% | 6018.7 ± 0.3% | 739.7 ± 3.9% | 3.260 | 3.614 | 23.841 | 1.956 | 15.920 |
| hex: http/css-1m | 524290 | 12013.4 ± 0.1% | 3622.6 ± 0.1% | 3303.0 ± 0.2% | 512.1 ± 1.8% | 6127.5 ± 2.4% | 756.6 ± 1.6% | 3.316 | 3.637 | 23.458 | 1.961 | 15.878 |
| hex: shuffled/dickens-1m | 524290 | 12011.9 ± 0.1% | 3619.8 ± 0.2% | 3296.6 ± 0.1% | 504.0 ± 1.3% | 6133.7 ± 1.0% | 764.2 ± 0.5% | 3.318 | 3.644 | 23.832 | 1.958 | 15.718 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1359.4 ± 0.3% | 1257.0 ± 0.7% | 1036.5 ± 0.5% | 410.8 ± 0.2% | 449.1 ± 0.2% | 415.0 ± 0.3% | 1.081 | 1.312 | 3.309 | 3.027 | 3.275 |
| qlog records, JSON text sequence | 1467503 | 1045.9 ± 0.8% | 1057.0 ± 0.3% | 780.8 ± 1.8% | 378.7 ± 0.9% | 467.2 ± 1.8% | 279.1 ± 0.8% | 0.989 | 1.339 | 2.761 | 2.239 | 3.748 |
| string: silesia/dickens | 172528 | 6913.0 ± 0.2% | 2819.8 ± 0.4% | 2929.0 ± 0.2% | 430.0 ± 0.3% | 1569.4 ± 0.3% | 1011.8 ± 0.1% | 2.452 | 2.360 | 16.075 | 4.405 | 6.832 |
| string: silesia/nci | 1075110 | 7319.6 ± 0.5% | 3432.4 ± 1.9% | 3101.5 ± 0.5% | 813.5 ± 1.0% | 1854.6 ± 0.3% | 1108.8 ± 0.3% | 2.132 | 2.360 | 8.997 | 3.947 | 6.601 |
| string: silesia/reymont | 1075159 | 3341.4 ± 1.4% | 1984.7 ± 1.1% | 2062.4 ± 0.3% | 449.3 ± 0.7% | 1512.4 ± 0.7% | 950.1 ± 1.0% | 1.684 | 1.620 | 7.437 | 2.209 | 3.517 |
| string: silesia/samba | 97582 | 4203.1 ± 0.5% | 2120.1 ± 0.5% | 3446.8 ± 0.4% | 353.5 ± 0.7% | 1436.4 ± 0.4% | 1056.6 ± 0.3% | 1.983 | 1.219 | 11.889 | 2.926 | 3.978 |
| string: silesia/webster | 1098490 | 4080.8 ± 0.4% | 1882.3 ± 0.4% | 2058.3 ± 0.3% | 442.0 ± 0.7% | 1390.0 ± 0.2% | 648.2 ± 0.4% | 2.168 | 1.983 | 9.232 | 2.936 | 6.296 |
| string: silesia/xml | 1090118 | 6138.5 ± 0.2% | 2872.4 ± 0.4% | 2641.9 ± 0.6% | 610.6 ± 0.6% | 1753.2 ± 0.3% | 925.2 ± 0.3% | 2.137 | 2.323 | 10.053 | 3.501 | 6.635 |
| string: canterbury/alice29.txt | 159425 | 6447.0 ± 1.0% | 2200.5 ± 0.6% | 2766.9 ± 1.1% | 407.6 ± 1.4% | 1465.4 ± 0.4% | 957.1 ± 0.1% | 2.930 | 2.330 | 15.818 | 4.400 | 6.736 |
| string: canterbury/asyoulik.txt | 132198 | 5636.3 ± 0.8% | 1718.8 ± 0.2% | 2383.6 ± 1.0% | 402.9 ± 0.5% | 1335.8 ± 0.4% | 885.8 ± 0.2% | 3.279 | 2.365 | 13.989 | 4.220 | 6.363 |
| string: canterbury/lcet10.txt | 441884 | 6269.0 ± 0.3% | 2564.7 ± 0.2% | 2494.8 ± 1.7% | 469.9 ± 0.4% | 1526.6 ± 0.3% | 985.0 ± 0.6% | 2.444 | 2.513 | 13.340 | 4.107 | 6.365 |
| string: canterbury/plrabn12.txt | 503330 | 5729.1 ± 0.3% | 2057.7 ± 0.2% | 2076.7 ± 0.5% | 425.4 ± 0.7% | 1410.5 ± 0.3% | 933.6 ± 0.1% | 2.784 | 2.759 | 13.468 | 4.062 | 6.137 |
| string: canterbury-large/E.coli | 1048578 | 19338.0 ± 0.3% | 9630.1 ± 2.6% | 3793.0 ± 0.4% | 1478.6 ± 0.7% | 2377.1 ± 1.0% | 1193.9 ± 0.9% | 2.008 | 5.098 | 13.078 | 8.135 | 16.197 |
| string: canterbury-large/bible.txt | 1055886 | 6796.0 ± 0.5% | 4158.0 ± 1.3% | 3042.6 ± 1.2% | 502.3 ± 0.3% | 1990.3 ± 0.5% | 1121.5 ± 0.4% | 1.634 | 2.234 | 13.530 | 3.415 | 6.060 |
| string: canterbury-large/world192.txt | 1103121 | 4059.0 ± 0.4% | 1657.2 ± 0.4% | 1996.5 ± 0.5% | 448.3 ± 0.5% | 1357.6 ± 0.3% | 910.0 ± 0.2% | 2.449 | 2.033 | 9.054 | 2.990 | 4.461 |
| string: http/html-1m | 1058582 | 6777.1 ± 0.3% | 3992.4 ± 0.5% | 3044.6 ± 0.4% | 499.4 ± 0.4% | 1930.4 ± 0.4% | 806.9 ± 0.2% | 1.698 | 2.226 | 13.570 | 3.511 | 8.398 |
| string: http/json-1m | 1190272 | 3170.1 ± 0.1% | 1349.7 ± 0.3% | 1556.3 ± 0.4% | 445.0 ± 0.2% | 962.3 ± 0.2% | 765.0 ± 1.1% | 2.349 | 2.037 | 7.124 | 3.294 | 4.144 |
| string: http/js-1m | 1144362 | 2767.0 ± 0.9% | 1180.7 ± 0.1% | 1626.8 ± 0.2% | 369.4 ± 0.3% | 1094.8 ± 0.1% | 758.4 ± 0.3% | 2.344 | 1.701 | 7.491 | 2.527 | 3.648 |
| string: http/css-1m | 1097820 | 4015.7 ± 0.4% | 1487.2 ± 0.3% | 2158.7 ± 0.8% | 494.3 ± 0.4% | 1369.0 ± 0.4% | 896.2 ± 0.3% | 2.700 | 1.860 | 8.125 | 2.933 | 4.481 |
| string: dickens as Cyrillic and CJK | 1883069 | 3071.7 ± 0.3% | 2341.7 ± 0.3% | 521.2 ± 0.2% | 307.8 ± 0.6% | 563.8 ± 0.9% | 335.6 ± 0.2% | 1.312 | 5.893 | 9.979 | 5.448 | 9.152 |
| hex: silesia/dickens | 524290 | 15670.5 ± 0.1% | 1468.2 ± 0.1% | 1087.3 ± 0.4% | 499.7 ± 1.1% | 990.2 ± 0.5% | 735.1 ± 0.1% | 10.673 | 14.412 | 31.360 | 15.825 | 21.316 |
| hex: silesia/mozilla | 524290 | 15671.7 ± 0.3% | 1478.3 ± 0.2% | 1088.4 ± 0.4% | 442.1 ± 0.8% | 994.0 ± 0.4% | 736.4 ± 1.0% | 10.601 | 14.399 | 35.446 | 15.767 | 21.282 |
| hex: silesia/mr | 524290 | 15691.5 ± 0.2% | 1483.2 ± 0.2% | 1091.2 ± 0.2% | 563.7 ± 1.3% | 994.2 ± 0.3% | 736.2 ± 0.2% | 10.579 | 14.381 | 27.836 | 15.782 | 21.315 |
| hex: silesia/nci | 524290 | 15606.0 ± 0.6% | 1481.4 ± 0.2% | 1091.9 ± 0.1% | 641.2 ± 4.2% | 993.2 ± 0.2% | 734.6 ± 0.4% | 10.535 | 14.292 | 24.340 | 15.713 | 21.244 |
| hex: silesia/ooffice | 524290 | 15671.2 ± 0.1% | 1469.0 ± 0.2% | 1086.2 ± 0.3% | 390.0 ± 0.2% | 990.0 ± 0.5% | 735.2 ± 0.5% | 10.668 | 14.427 | 40.184 | 15.829 | 21.315 |
| hex: silesia/osdb | 524290 | 15661.7 ± 0.4% | 1475.8 ± 0.2% | 1088.8 ± 0.3% | 468.9 ± 1.4% | 994.3 ± 0.3% | 735.8 ± 0.3% | 10.612 | 14.384 | 33.398 | 15.752 | 21.286 |
| hex: silesia/reymont | 524290 | 15623.6 ± 0.5% | 1466.5 ± 0.7% | 1087.3 ± 0.4% | 512.8 ± 1.2% | 992.9 ± 0.6% | 735.9 ± 0.4% | 10.653 | 14.370 | 30.469 | 15.736 | 21.229 |
| hex: silesia/samba | 524290 | 15683.4 ± 0.3% | 1471.0 ± 0.1% | 1085.8 ± 0.2% | 403.3 ± 0.7% | 992.0 ± 0.2% | 736.1 ± 0.5% | 10.662 | 14.444 | 38.885 | 15.809 | 21.306 |
| hex: silesia/sao | 524290 | 15641.1 ± 0.5% | 1468.2 ± 0.2% | 1084.8 ± 0.1% | 332.8 ± 0.6% | 990.7 ± 0.4% | 735.4 ± 0.7% | 10.653 | 14.418 | 47.000 | 15.788 | 21.267 |
| hex: silesia/webster | 524290 | 15695.5 ± 0.2% | 1469.3 ± 0.3% | 1084.1 ± 0.2% | 471.9 ± 0.6% | 990.7 ± 0.5% | 736.3 ± 0.2% | 10.682 | 14.478 | 33.257 | 15.843 | 21.318 |
| hex: silesia/x-ray | 524290 | 15661.7 ± 0.2% | 1477.4 ± 0.2% | 1090.3 ± 0.2% | 445.6 ± 1.0% | 996.3 ± 0.3% | 736.5 ± 0.6% | 10.601 | 14.365 | 35.151 | 15.720 | 21.266 |
| hex: silesia/xml | 524290 | 15616.2 ± 0.1% | 1472.1 ± 0.4% | 1087.6 ± 0.8% | 611.3 ± 1.3% | 991.8 ± 0.4% | 735.9 ± 0.5% | 10.608 | 14.359 | 25.544 | 15.745 | 21.220 |
| hex: canterbury/alice29.txt | 304180 | 15682.3 ± 0.0% | 1475.1 ± 0.5% | 1090.3 ± 0.3% | 504.4 ± 0.3% | 996.5 ± 0.3% | 736.5 ± 0.3% | 10.631 | 14.383 | 31.094 | 15.737 | 21.293 |
| hex: canterbury/asyoulik.txt | 250360 | 15720.2 ± 0.0% | 1476.7 ± 0.4% | 1096.3 ± 0.4% | 495.1 ± 1.5% | 997.1 ± 0.4% | 741.8 ± 0.3% | 10.646 | 14.340 | 31.751 | 15.765 | 21.193 |
| hex: canterbury/cp.html | 49208 | 15648.2 ± 0.0% | 1471.2 ± 0.7% | 1098.5 ± 0.2% | 515.8 ± 1.6% | 1002.1 ± 0.5% | 742.7 ± 0.1% | 10.637 | 14.245 | 30.339 | 15.616 | 21.070 |
| hex: canterbury/fields.c | 22302 | 15523.2 ± 0.0% | 1415.9 ± 0.6% | 1065.3 ± 0.7% | 633.8 ± 6.2% | 987.0 ± 0.6% | 736.0 ± 0.3% | 10.964 | 14.572 | 24.491 | 15.728 | 21.092 |
| hex: canterbury/grammar.lsp | 7444 | 15161.0 ± 0.0% | 1509.4 ± 0.1% | 1098.1 ± 0.5% | 656.7 ± 2.6% | 995.3 ± 0.5% | 726.1 ± 0.2% | 10.044 | 13.806 | 23.086 | 15.233 | 20.880 |
| hex: canterbury/kennedy.xls | 524290 | 15665.4 ± 0.1% | 1477.2 ± 0.2% | 1088.3 ± 0.3% | 658.5 ± 1.1% | 991.2 ± 0.5% | 735.2 ± 0.2% | 10.605 | 14.394 | 23.789 | 15.805 | 21.307 |
| hex: canterbury/lcet10.txt | 524290 | 15649.7 ± 0.2% | 1464.6 ± 0.4% | 1086.0 ± 0.2% | 504.1 ± 1.4% | 990.1 ± 0.6% | 735.2 ± 0.3% | 10.686 | 14.410 | 31.045 | 15.806 | 21.287 |
| hex: canterbury/plrabn12.txt | 524290 | 15674.4 ± 0.6% | 1467.9 ± 0.3% | 1085.3 ± 0.3% | 493.5 ± 0.2% | 992.0 ± 0.3% | 734.3 ± 0.5% | 10.678 | 14.442 | 31.762 | 15.801 | 21.345 |
| hex: canterbury/ptt5 | 524290 | 15653.2 ± 0.6% | 1481.8 ± 0.3% | 1094.3 ± 0.2% | 552.4 ± 1.6% | 993.7 ± 0.2% | 735.7 ± 0.3% | 10.563 | 14.304 | 28.335 | 15.752 | 21.277 |
| hex: canterbury/sum | 76482 | 15679.4 ± 0.0% | 1494.9 ± 0.1% | 1105.5 ± 0.1% | 594.0 ± 2.8% | 998.3 ± 0.1% | 744.7 ± 0.3% | 10.489 | 14.183 | 26.397 | 15.706 | 21.055 |
| hex: canterbury/xargs.1 | 8456 | 15204.0 ± 0.2% | 1494.9 ± 0.2% | 1096.0 ± 0.4% | 654.8 ± 4.0% | 1003.7 ± 0.3% | 728.6 ± 0.1% | 10.171 | 13.872 | 23.221 | 15.149 | 20.866 |
| hex: canterbury-large/E.coli | 524290 | 15675.3 ± 0.3% | 1476.1 ± 0.5% | 1092.2 ± 0.4% | 672.2 ± 0.3% | 991.4 ± 0.3% | 735.8 ± 0.6% | 10.620 | 14.352 | 23.319 | 15.811 | 21.303 |
| hex: canterbury-large/bible.txt | 524290 | 15658.0 ± 0.2% | 1466.4 ± 0.4% | 1086.3 ± 0.9% | 514.4 ± 0.7% | 988.1 ± 0.6% | 735.3 ± 0.6% | 10.678 | 14.413 | 30.441 | 15.847 | 21.296 |
| hex: canterbury-large/world192.txt | 524290 | 15639.4 ± 0.2% | 1471.0 ± 0.2% | 1083.6 ± 0.5% | 502.1 ± 0.3% | 992.3 ± 0.5% | 735.2 ± 0.3% | 10.632 | 14.432 | 31.148 | 15.761 | 21.272 |
| hex: http/html-1kx1024 | 2099200 | 14233.8 ± 0.3% | 1453.7 ± 0.2% | 1063.4 ± 0.2% | 503.0 ± 0.3% | 982.7 ± 0.1% | 692.6 ± 0.4% | 9.792 | 13.385 | 28.295 | 14.484 | 20.550 |
| hex: http/html-16kx64 | 2097280 | 15359.1 ± 0.3% | 1445.7 ± 0.1% | 1076.2 ± 0.1% | 507.8 ± 0.1% | 996.4 ± 0.1% | 735.6 ± 0.0% | 10.624 | 14.272 | 30.245 | 15.415 | 20.878 |
| hex: http/html-1m | 524290 | 15699.1 ± 0.1% | 1471.0 ± 0.5% | 1085.9 ± 0.8% | 501.3 ± 0.5% | 992.2 ± 0.4% | 735.4 ± 0.5% | 10.673 | 14.457 | 31.316 | 15.822 | 21.347 |
| hex: http/json-1kx1024 | 2099200 | 14190.0 ± 0.6% | 1463.4 ± 0.1% | 1067.8 ± 0.1% | 608.9 ± 0.5% | 985.9 ± 0.1% | 692.6 ± 0.1% | 9.697 | 13.289 | 23.304 | 14.392 | 20.489 |
| hex: http/json-16kx64 | 2097280 | 15336.5 ± 0.2% | 1447.7 ± 0.3% | 1077.4 ± 0.2% | 615.2 ± 0.7% | 997.6 ± 0.2% | 735.0 ± 0.1% | 10.594 | 14.235 | 24.929 | 15.374 | 20.867 |
| hex: http/json-1m | 524290 | 15682.5 ± 0.2% | 1477.1 ± 0.3% | 1088.2 ± 0.3% | 631.9 ± 1.0% | 993.4 ± 0.3% | 735.5 ± 0.5% | 10.617 | 14.411 | 24.817 | 15.786 | 21.321 |
| hex: http/js-1kx1024 | 2099200 | 14197.4 ± 0.1% | 1455.1 ± 0.3% | 1058.6 ± 0.2% | 499.1 ± 0.2% | 983.3 ± 0.3% | 692.3 ± 0.1% | 9.757 | 13.411 | 28.445 | 14.438 | 20.508 |
| hex: http/js-16kx64 | 2097280 | 15331.4 ± 0.5% | 1447.8 ± 0.1% | 1075.8 ± 0.1% | 504.4 ± 0.3% | 996.9 ± 0.2% | 735.3 ± 0.1% | 10.589 | 14.251 | 30.394 | 15.380 | 20.850 |
| hex: http/js-1m | 524290 | 15688.6 ± 0.2% | 1468.4 ± 0.2% | 1084.6 ± 0.2% | 512.9 ± 0.6% | 991.2 ± 0.2% | 735.0 ± 0.4% | 10.684 | 14.464 | 30.589 | 15.827 | 21.346 |
| hex: http/css-1kx1024 | 2099200 | 14193.2 ± 0.5% | 1456.1 ± 0.1% | 1062.9 ± 0.4% | 531.2 ± 0.5% | 982.9 ± 0.3% | 692.4 ± 0.3% | 9.747 | 13.354 | 26.718 | 14.441 | 20.500 |
| hex: http/css-16kx64 | 2097280 | 15317.8 ± 0.5% | 1444.3 ± 0.1% | 1075.0 ± 0.2% | 539.5 ± 0.6% | 999.2 ± 0.5% | 735.0 ± 0.2% | 10.606 | 14.250 | 28.394 | 15.330 | 20.840 |
| hex: http/css-1m | 524290 | 15674.0 ± 0.2% | 1470.4 ± 0.2% | 1087.7 ± 0.2% | 524.7 ± 0.4% | 989.9 ± 0.2% | 735.7 ± 0.2% | 10.659 | 14.410 | 29.871 | 15.834 | 21.306 |
| hex: shuffled/dickens-1m | 524290 | 15682.2 ± 0.3% | 1466.7 ± 0.2% | 1087.1 ± 0.4% | 504.0 ± 0.6% | 988.8 ± 0.3% | 734.3 ± 0.3% | 10.692 | 14.426 | 31.115 | 15.860 | 21.355 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.916 of yyjson.
