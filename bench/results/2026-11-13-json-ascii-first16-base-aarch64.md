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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43483791171 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1129.6 ± 0.4% | 0.523 | 0.964 | 0.995 | 0.997 | 0.457 | 1.001 | 1.005 | 0.383 | 0.830 | 0.897 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 834.9 ± 1.5% | 0.832 | 1.017 | 1.012 | 1.012 | 0.454 | 1.010 | 1.040 | 0.400 | 0.933 | 1.002 | 0.128 |
| string: silesia/dickens | 172528 | 5046.0 ± 0.4% | 0.033 | 0.782 | 1.003 | 1.004 | 0.197 | 1.016 | 1.008 | 0.196 | 1.001 | 1.002 | 0.032 |
| string: silesia/nci | 1075110 | 4282.4 ± 0.6% | 0.039 | 0.806 | 1.010 | 1.007 | 0.278 | 1.008 | 1.002 | 0.280 | 1.008 | 1.006 | 0.038 |
| string: silesia/reymont | 1075159 | 2911.1 ± 1.0% | 0.058 | 0.825 | 1.011 | 1.018 | 0.362 | 1.015 | 1.013 | 0.362 | 1.022 | 1.026 | 0.056 |
| string: silesia/samba | 97582 | 3494.2 ± 0.8% | 0.041 | 0.861 | 1.003 | 1.005 | 0.070 | 0.779 | 1.010 | 0.067 | 1.002 | 1.005 | 0.040 |
| string: silesia/webster | 1098490 | 3646.8 ± 0.4% | 0.044 | 0.846 | 1.004 | 1.003 | 0.203 | 1.018 | 1.013 | 0.203 | 1.007 | 1.007 | 0.044 |
| string: silesia/xml | 1090118 | 4774.8 ± 0.7% | 0.035 | 0.807 | 1.005 | 1.006 | 0.222 | 0.983 | 1.008 | 0.220 | 1.003 | 1.005 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4319.4 ± 0.5% | 0.038 | 0.749 | 1.002 | 1.005 | 0.171 | 1.031 | 1.017 | 0.170 | 1.012 | 1.013 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3452.5 ± 1.0% | 0.046 | 0.748 | 1.007 | 1.010 | 0.176 | 1.008 | 0.973 | 0.176 | 1.013 | 1.014 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5107.1 ± 0.2% | 0.032 | 0.814 | 1.004 | 1.004 | 0.196 | 1.022 | 1.005 | 0.195 | 1.006 | 1.005 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4102.5 ± 0.6% | 0.040 | 0.830 | 1.005 | 1.007 | 0.199 | 1.015 | 1.002 | 0.198 | 1.006 | 1.006 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 18810.2 ± 1.2% | 0.078 | 1.016 | 1.009 | 1.006 | 0.487 | 1.010 | 1.006 | 0.486 | 0.632 | 0.633 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6675.3 ± 0.8% | 0.026 | 0.800 | 1.001 | 1.009 | 0.432 | 1.032 | 1.043 | 0.433 | 1.032 | 1.033 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3384.8 ± 0.4% | 0.048 | 0.844 | 1.002 | 1.004 | 0.197 | 1.015 | 1.006 | 0.197 | 1.004 | 1.003 | 0.047 |
| string: http/html-1m | 1058582 | 6021.9 ± 1.6% | 0.029 | 0.786 | 1.006 | 1.042 | 0.390 | 1.045 | 1.057 | 0.391 | 1.034 | 1.040 | 0.028 |
| string: http/json-1m | 1190272 | 2539.9 ± 0.5% | 0.055 | 0.953 | 1.006 | 1.005 | 0.110 | 1.006 | 0.472 | 0.111 | 1.005 | 1.006 | 0.055 |
| string: http/js-1m | 1144362 | 2283.3 ± 0.9% | 0.066 | 0.890 | 1.001 | 1.001 | 0.174 | 1.055 | 1.044 | 0.174 | 1.002 | 1.004 | 0.065 |
| string: http/css-1m | 1097820 | 2633.0 ± 0.6% | 0.061 | 0.777 | 1.006 | 1.009 | 0.238 | 1.012 | 1.015 | 0.240 | 1.008 | 1.010 | 0.059 |
| string: dickens as Cyrillic and CJK | 1883069 | 3061.9 ± 0.2% | 0.044 | 0.125 | 1.006 | 1.008 | 0.335 | 1.003 | 1.011 | 0.336 | 1.006 | 1.005 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.0 ± 1.0% | 0.086 | 1.003 | 1.002 | 1.001 | 0.078 | 0.638 | 1.005 | 0.075 | 1.002 | 1.002 | 0.084 |
| hex: silesia/dickens | 524290 | 18448.1 ± 2.4% | 0.081 | 1.013 | 0.997 | 0.996 | 0.526 | 1.003 | 1.009 | 0.526 | 0.648 | 0.649 | 0.009 |
| hex: silesia/mozilla | 524290 | 18597.5 ± 0.8% | 0.080 | 1.006 | 1.004 | 0.999 | 0.526 | 0.994 | 0.998 | 0.525 | 0.646 | 0.646 | 0.009 |
| hex: silesia/mr | 524290 | 18529.2 ± 1.0% | 0.080 | 0.985 | 0.990 | 0.986 | 0.528 | 0.985 | 0.985 | 0.530 | 0.648 | 0.649 | 0.009 |
| hex: silesia/nci | 524290 | 18240.5 ± 0.8% | 0.081 | 1.017 | 1.005 | 0.997 | 0.519 | 1.007 | 1.001 | 0.520 | 0.658 | 0.658 | 0.009 |
| hex: silesia/ooffice | 524290 | 18544.9 ± 1.5% | 0.080 | 1.003 | 0.997 | 0.993 | 0.522 | 0.989 | 0.993 | 0.524 | 0.647 | 0.647 | 0.009 |
| hex: silesia/osdb | 524290 | 18326.9 ± 0.9% | 0.081 | 0.998 | 0.998 | 0.999 | 0.514 | 0.999 | 0.994 | 0.515 | 0.656 | 0.655 | 0.009 |
| hex: silesia/reymont | 524290 | 18606.2 ± 1.3% | 0.080 | 1.007 | 1.003 | 0.996 | 0.526 | 1.004 | 0.993 | 0.522 | 0.646 | 0.646 | 0.009 |
| hex: silesia/samba | 524290 | 18007.9 ± 0.7% | 0.083 | 1.004 | 0.999 | 0.997 | 0.530 | 1.005 | 0.996 | 0.532 | 0.666 | 0.665 | 0.010 |
| hex: silesia/sao | 524290 | 18546.2 ± 1.6% | 0.080 | 1.004 | 0.997 | 0.996 | 0.516 | 0.995 | 0.991 | 0.515 | 0.643 | 0.646 | 0.009 |
| hex: silesia/webster | 524290 | 18576.7 ± 2.1% | 0.080 | 1.004 | 1.000 | 0.994 | 0.520 | 0.993 | 0.990 | 0.522 | 0.647 | 0.647 | 0.009 |
| hex: silesia/x-ray | 524290 | 18601.2 ± 0.8% | 0.080 | 1.008 | 0.999 | 0.993 | 0.513 | 0.993 | 0.990 | 0.511 | 0.645 | 0.645 | 0.009 |
| hex: silesia/xml | 524290 | 18294.0 ± 1.3% | 0.081 | 1.007 | 0.995 | 0.995 | 0.530 | 1.000 | 0.997 | 0.530 | 0.657 | 0.657 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19082.6 ± 0.7% | 0.078 | 1.006 | 0.998 | 0.997 | 0.511 | 1.002 | 1.002 | 0.505 | 0.629 | 0.630 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19522.6 ± 0.1% | 0.077 | 1.003 | 1.003 | 1.003 | 0.514 | 1.003 | 1.003 | 0.514 | 0.615 | 0.615 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19297.0 ± 0.3% | 0.083 | 1.002 | 1.002 | 1.001 | 0.541 | 1.002 | 1.002 | 0.542 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18894.3 ± 0.9% | 0.084 | 1.001 | 1.005 | 1.005 | 0.533 | 1.004 | 1.005 | 0.539 | 0.624 | 0.624 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17434.8 ± 1.6% | 0.089 | 1.011 | 1.012 | 1.012 | 0.530 | 1.011 | 1.011 | 0.547 | 0.647 | 0.650 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18156.1 ± 1.5% | 0.082 | 1.006 | 1.004 | 1.003 | 0.532 | 1.003 | 1.004 | 0.534 | 0.658 | 0.658 | 0.010 |
| hex: canterbury/lcet10.txt | 524290 | 18574.1 ± 1.5% | 0.080 | 1.004 | 1.000 | 0.989 | 0.520 | 0.988 | 0.986 | 0.524 | 0.647 | 0.647 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18232.4 ± 0.5% | 0.081 | 1.007 | 1.004 | 1.005 | 0.523 | 1.003 | 1.007 | 0.525 | 0.656 | 0.655 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 18247.1 ± 0.9% | 0.082 | 1.004 | 0.999 | 1.000 | 0.528 | 1.001 | 1.004 | 0.531 | 0.656 | 0.658 | 0.009 |
| hex: canterbury/sum | 76482 | 19290.7 ± 0.1% | 0.078 | 1.002 | 1.003 | 1.003 | 0.518 | 1.002 | 1.002 | 0.519 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17839.4 ± 0.4% | 0.086 | 1.002 | 1.002 | 1.003 | 0.524 | 1.001 | 1.001 | 0.540 | 0.637 | 0.636 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18307.6 ± 3.5% | 0.081 | 0.993 | 0.985 | 0.984 | 0.528 | 0.987 | 0.984 | 0.529 | 0.657 | 0.656 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18658.6 ± 4.9% | 0.079 | 0.998 | 0.993 | 0.992 | 0.507 | 0.993 | 0.982 | 0.506 | 0.642 | 0.642 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 17988.8 ± 0.9% | 0.083 | 1.004 | 0.998 | 0.998 | 0.530 | 1.002 | 0.998 | 0.530 | 0.664 | 0.665 | 0.010 |
| hex: http/html-1kx1024 | 2099200 | 9084.5 ± 18.4% | 0.155 | 1.280 | 1.268 | 1.276 | 0.722 | 1.289 | 0.982 | 0.793 | 0.954 | 0.961 | 0.019 |
| hex: http/html-16kx64 | 2097280 | 17642.0 ± 0.9% | 0.085 | 1.026 | 1.024 | 1.023 | 0.580 | 1.025 | 0.989 | 0.584 | 0.666 | 0.667 | 0.010 |
| hex: http/html-1m | 524290 | 18108.3 ± 1.1% | 0.082 | 0.996 | 0.994 | 0.994 | 0.521 | 0.997 | 1.001 | 0.521 | 0.660 | 0.660 | 0.010 |
| hex: http/json-1kx1024 | 2099200 | 8972.6 ± 17.1% | 0.160 | 1.306 | 1.289 | 1.290 | 0.723 | 1.310 | 0.984 | 0.787 | 0.956 | 0.964 | 0.019 |
| hex: http/json-16kx64 | 2097280 | 17816.1 ± 1.7% | 0.084 | 1.019 | 1.016 | 1.016 | 0.575 | 1.017 | 0.980 | 0.578 | 0.660 | 0.660 | 0.010 |
| hex: http/json-1m | 524290 | 18228.8 ± 1.4% | 0.082 | 1.010 | 1.004 | 1.006 | 0.528 | 1.006 | 1.001 | 0.529 | 0.656 | 0.653 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 9428.9 ± 20.5% | 0.151 | 1.251 | 1.255 | 1.255 | 0.694 | 1.249 | 0.987 | 0.754 | 0.919 | 0.927 | 0.018 |
| hex: http/js-16kx64 | 2097280 | 17734.0 ± 1.1% | 0.085 | 1.023 | 1.017 | 1.018 | 0.575 | 1.020 | 0.984 | 0.579 | 0.663 | 0.663 | 0.010 |
| hex: http/js-1m | 524290 | 18309.2 ± 2.7% | 0.081 | 1.023 | 1.012 | 1.011 | 0.510 | 1.015 | 1.010 | 0.514 | 0.653 | 0.654 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9075.9 ± 18.6% | 0.156 | 1.288 | 1.289 | 1.281 | 0.716 | 1.291 | 0.961 | 0.777 | 0.950 | 0.960 | 0.019 |
| hex: http/css-16kx64 | 2097280 | 17762.9 ± 1.5% | 0.085 | 1.022 | 1.019 | 1.019 | 0.575 | 1.020 | 0.981 | 0.579 | 0.661 | 0.662 | 0.010 |
| hex: http/css-1m | 524290 | 18237.7 ± 1.2% | 0.082 | 1.007 | 0.999 | 0.998 | 0.537 | 0.995 | 0.998 | 0.535 | 0.659 | 0.660 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18005.3 ± 0.7% | 0.082 | 1.002 | 1.002 | 0.998 | 0.528 | 1.001 | 0.999 | 0.524 | 0.663 | 0.664 | 0.010 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1483.6 ± 1.6% | 0.444 | 1.000 | 0.965 | 1.004 | 1.007 | 0.267 | 0.997 | 0.547 | 0.914 | 0.088 | 1.026 |
| qlog records, JSON text sequence | 1467503 | 1265.0 ± 0.9% | 0.691 | 0.978 | 1.011 | 1.013 | 1.012 | 0.266 | 1.004 | 0.502 | 0.830 | 0.106 | 1.017 |
| string: silesia/dickens | 172528 | 6895.3 ± 0.5% | 0.025 | 1.001 | 1.002 | 1.001 | 1.000 | 0.165 | 0.717 | 1.002 | 1.001 | 0.025 | 1.034 |
| string: silesia/nci | 1075110 | 7309.8 ± 0.4% | 0.024 | 0.998 | 0.999 | 0.999 | 0.999 | 0.208 | 0.564 | 0.999 | 1.001 | 0.023 | 1.009 |
| string: silesia/reymont | 1075159 | 3320.7 ± 1.3% | 0.052 | 1.006 | 0.999 | 1.000 | 1.011 | 0.390 | 0.874 | 1.004 | 1.009 | 0.052 | 1.056 |
| string: silesia/samba | 97582 | 4194.7 ± 0.8% | 0.053 | 1.003 | 1.001 | 1.005 | 1.007 | 0.124 | 0.939 | 1.005 | 1.002 | 0.053 | 1.091 |
| string: silesia/webster | 1098490 | 4049.0 ± 0.8% | 0.043 | 1.009 | 1.007 | 1.007 | 1.008 | 0.211 | 0.888 | 1.000 | 1.005 | 0.042 | 1.012 |
| string: silesia/xml | 1090118 | 6106.2 ± 0.3% | 0.029 | 1.002 | 0.999 | 1.004 | 1.006 | 0.252 | 0.777 | 1.002 | 1.003 | 0.029 | 1.019 |
| string: canterbury/alice29.txt | 159425 | 6389.2 ± 0.8% | 0.027 | 1.010 | 1.014 | 1.015 | 1.015 | 0.132 | 0.655 | 1.004 | 1.007 | 0.027 | 1.056 |
| string: canterbury/asyoulik.txt | 132198 | 5595.5 ± 1.4% | 0.030 | 1.024 | 1.030 | 1.030 | 1.033 | 0.128 | 0.597 | 1.000 | 1.010 | 0.030 | 1.048 |
| string: canterbury/lcet10.txt | 441884 | 6235.3 ± 1.3% | 0.028 | 1.007 | 1.006 | 1.008 | 1.009 | 0.182 | 0.801 | 1.006 | 1.006 | 0.028 | 1.002 |
| string: canterbury/plrabn12.txt | 503330 | 5709.0 ± 0.3% | 0.030 | 1.002 | 1.003 | 1.004 | 1.002 | 0.167 | 0.699 | 1.003 | 1.003 | 0.030 | 1.007 |
| string: canterbury-large/E.coli | 1048578 | 19105.5 ± 1.3% | 0.078 | 1.001 | 1.003 | 1.001 | 1.003 | 0.480 | 1.004 | 1.004 | 1.000 | 0.009 | 1.004 |
| string: canterbury-large/bible.txt | 1055886 | 6790.5 ± 0.7% | 0.026 | 1.000 | 1.002 | 1.001 | 1.002 | 0.494 | 0.964 | 1.001 | 1.002 | 0.027 | 1.001 |
| string: canterbury-large/world192.txt | 1103121 | 4014.4 ± 0.4% | 0.044 | 1.018 | 1.021 | 1.017 | 1.018 | 0.192 | 0.831 | 1.002 | 1.010 | 0.043 | 1.006 |
| string: http/html-1m | 1058582 | 6736.3 ± 0.5% | 0.026 | 1.005 | 0.926 | 1.003 | 1.007 | 0.403 | 0.881 | 1.002 | 1.005 | 0.026 | 1.010 |
| string: http/json-1m | 1190272 | 3160.8 ± 0.4% | 0.051 | 1.002 | 0.965 | 1.000 | 1.004 | 0.132 | 0.371 | 1.000 | 1.001 | 0.051 | 1.043 |
| string: http/js-1m | 1144362 | 2759.1 ± 0.7% | 0.061 | 1.004 | 1.008 | 1.001 | 1.007 | 0.164 | 0.837 | 1.001 | 1.006 | 0.061 | 1.015 |
| string: http/css-1m | 1097820 | 3970.4 ± 0.7% | 0.043 | 1.010 | 1.009 | 1.007 | 1.010 | 0.206 | 0.648 | 1.005 | 1.010 | 0.043 | 1.017 |
| string: dickens as Cyrillic and CJK | 1883069 | 3064.5 ± 0.4% | 0.048 | 1.002 | 0.124 | 1.001 | 1.002 | 0.319 | 1.004 | 1.001 | 1.001 | 0.048 | 1.003 |
| hex: silesia/dickens | 524290 | 15677.8 ± 0.1% | 1.000 | 0.178 | 1.000 | 1.001 | 1.000 | 1.000 | 1.000 | 0.999 | 0.999 | 0.177 | 0.999 |
| hex: silesia/mozilla | 524290 | 15653.0 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.000 | 1.000 | 1.001 | 1.001 | 0.999 | 0.998 | 0.178 | 1.001 |
| hex: silesia/mr | 524290 | 15615.0 ± 0.2% | 1.003 | 0.179 | 0.999 | 1.001 | 1.000 | 1.003 | 1.001 | 1.002 | 1.001 | 0.179 | 1.001 |
| hex: silesia/nci | 524290 | 15663.9 ± 0.3% | 1.000 | 0.178 | 0.996 | 0.998 | 0.997 | 0.995 | 0.997 | 0.998 | 0.997 | 0.178 | 0.997 |
| hex: silesia/ooffice | 524290 | 15605.3 ± 0.2% | 1.000 | 0.178 | 1.002 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 0.999 | 0.178 | 1.000 |
| hex: silesia/osdb | 524290 | 15610.7 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.001 | 1.001 | 0.999 | 1.001 | 1.002 | 1.001 | 0.178 | 1.000 |
| hex: silesia/reymont | 524290 | 15647.8 ± 0.2% | 1.000 | 0.177 | 0.998 | 1.001 | 1.000 | 0.999 | 1.001 | 1.000 | 0.999 | 0.177 | 1.000 |
| hex: silesia/samba | 524290 | 15652.5 ± 0.2% | 1.001 | 0.178 | 1.002 | 1.001 | 1.001 | 1.001 | 1.002 | 1.001 | 1.000 | 0.178 | 1.001 |
| hex: silesia/sao | 524290 | 15652.4 ± 0.1% | 1.000 | 0.178 | 1.002 | 1.001 | 1.000 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: silesia/webster | 524290 | 15636.0 ± 0.3% | 1.000 | 0.178 | 0.997 | 1.000 | 1.000 | 1.001 | 1.002 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: silesia/x-ray | 524290 | 15625.6 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.001 | 1.000 | 0.998 | 0.998 | 0.997 | 0.998 | 0.178 | 0.997 |
| hex: silesia/xml | 524290 | 15640.2 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.000 | 1.000 | 1.000 | 0.999 | 1.001 | 1.000 | 0.178 | 0.998 |
| hex: canterbury/alice29.txt | 304180 | 15666.3 ± 0.2% | 1.000 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 0.177 | 0.997 |
| hex: canterbury/asyoulik.txt | 250360 | 15705.7 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15620.0 ± 0.2% | 1.001 | 0.179 | 1.000 | 1.001 | 1.001 | 0.998 | 1.001 | 1.001 | 1.003 | 0.178 | 1.000 |
| hex: canterbury/fields.c | 22302 | 15441.6 ± 0.1% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.994 | 1.000 | 1.002 | 1.006 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14940.3 ± 0.2% | 1.003 | 0.186 | 1.000 | 1.000 | 0.998 | 0.983 | 1.001 | 1.004 | 1.015 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15656.8 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 1.001 | 1.000 | 0.178 | 1.001 |
| hex: canterbury/lcet10.txt | 524290 | 15634.9 ± 0.1% | 1.002 | 0.178 | 1.001 | 1.001 | 1.000 | 1.000 | 0.999 | 1.001 | 1.001 | 0.178 | 0.997 |
| hex: canterbury/plrabn12.txt | 524290 | 15621.1 ± 0.1% | 0.998 | 0.178 | 0.998 | 0.998 | 1.000 | 0.998 | 1.001 | 1.000 | 0.999 | 0.178 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 15636.0 ± 0.2% | 1.002 | 0.178 | 0.999 | 1.001 | 1.000 | 0.998 | 0.999 | 0.999 | 0.999 | 0.178 | 1.000 |
| hex: canterbury/sum | 76482 | 15642.9 ± 0.0% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 14994.8 ± 0.1% | 1.002 | 0.185 | 1.000 | 1.000 | 1.000 | 0.986 | 1.000 | 1.004 | 1.014 | 0.184 | 1.002 |
| hex: canterbury-large/E.coli | 524290 | 15625.2 ± 0.3% | 1.001 | 0.178 | 1.002 | 1.001 | 1.001 | 1.000 | 1.001 | 1.002 | 1.002 | 0.178 | 1.001 |
| hex: canterbury-large/bible.txt | 524290 | 15627.4 ± 0.2% | 1.002 | 0.178 | 1.001 | 1.000 | 1.000 | 1.001 | 1.000 | 1.000 | 1.000 | 0.178 | 1.000 |
| hex: canterbury-large/world192.txt | 524290 | 15599.2 ± 0.3% | 1.001 | 0.178 | 0.999 | 1.000 | 1.000 | 0.997 | 0.998 | 0.997 | 0.996 | 0.178 | 1.000 |
| hex: http/html-1kx1024 | 2099200 | 13734.7 ± 0.5% | 1.005 | 0.195 | 0.995 | 1.002 | 0.999 | 0.935 | 0.995 | 1.006 | 1.033 | 0.187 | 1.001 |
| hex: http/html-16kx64 | 2097280 | 15258.0 ± 0.5% | 0.999 | 0.181 | 0.999 | 0.998 | 1.000 | 0.991 | 0.996 | 1.002 | 1.005 | 0.180 | 0.998 |
| hex: http/html-1m | 524290 | 15616.0 ± 0.3% | 0.998 | 0.178 | 1.001 | 1.001 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 0.178 | 1.000 |
| hex: http/json-1kx1024 | 2099200 | 13613.4 ± 0.3% | 1.008 | 0.196 | 1.005 | 1.002 | 1.002 | 0.945 | 1.004 | 1.009 | 1.034 | 0.188 | 1.010 |
| hex: http/json-16kx64 | 2097280 | 15205.2 ± 0.5% | 1.000 | 0.181 | 0.999 | 1.000 | 1.001 | 0.993 | 1.001 | 1.007 | 1.009 | 0.181 | 1.004 |
| hex: http/json-1m | 524290 | 15632.7 ± 0.3% | 1.000 | 0.178 | 1.000 | 1.000 | 0.999 | 1.001 | 1.002 | 1.001 | 0.999 | 0.178 | 1.001 |
| hex: http/js-1kx1024 | 2099200 | 13654.0 ± 0.5% | 1.011 | 0.196 | 1.008 | 1.001 | 1.004 | 0.940 | 0.997 | 1.009 | 1.037 | 0.188 | 1.012 |
| hex: http/js-16kx64 | 2097280 | 15207.6 ± 0.6% | 1.002 | 0.182 | 1.005 | 1.002 | 0.999 | 0.996 | 0.999 | 1.006 | 1.010 | 0.181 | 1.003 |
| hex: http/js-1m | 524290 | 15683.0 ± 0.3% | 1.001 | 0.177 | 1.001 | 1.001 | 1.000 | 0.999 | 1.001 | 1.000 | 0.999 | 0.177 | 1.000 |
| hex: http/css-1kx1024 | 2099200 | 13684.7 ± 0.5% | 1.003 | 0.195 | 0.994 | 1.002 | 1.001 | 0.935 | 0.997 | 1.002 | 1.029 | 0.187 | 1.008 |
| hex: http/css-16kx64 | 2097280 | 15231.5 ± 0.7% | 0.997 | 0.181 | 0.997 | 1.001 | 0.999 | 0.989 | 0.995 | 1.004 | 1.004 | 0.180 | 0.999 |
| hex: http/css-1m | 524290 | 15682.5 ± 0.2% | 0.999 | 0.177 | 1.000 | 1.000 | 1.000 | 0.998 | 1.000 | 0.999 | 0.998 | 0.177 | 1.000 |
| hex: shuffled/dickens-1m | 524290 | 15613.3 ± 0.3% | 1.002 | 0.178 | 1.005 | 1.002 | 1.002 | 1.003 | 1.003 | 1.003 | 1.002 | 0.178 | 1.004 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.057 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.055 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.280 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.268 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.276 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.289 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.306 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.289 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.290 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.310 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.251 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.255 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.255 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.249 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.288 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.289 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.281 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.291 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43340.5 ± 0.2% | 47381.5 ± 0.1% | 0.915 | — | — |
| string: silesia/nci | 1048576 | 33900.6 ± 2.8% | 36219.2 ± 2.9% | 0.936 | — | — |
| string: silesia/reymont | 1048576 | 33439.4 ± 5.1% | 35923.9 ± 1.8% | 0.931 | — | — |
| string: silesia/samba | 65546 | 43576.4 ± 0.1% | 48513.4 ± 0.1% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 35312.5 ± 4.7% | 38215.8 ± 4.7% | 0.924 | — | — |
| string: silesia/xml | 1048576 | 30300.8 ± 4.0% | 31027.5 ± 4.6% | 0.977 | — | — |
| string: canterbury/alice29.txt | 152089 | 35908.4 ± 0.1% | 36545.7 ± 0.1% | 0.983 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43333.3 ± 0.1% | 47639.3 ± 0.1% | 0.910 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36066.1 ± 0.1% | 36711.6 ± 0.1% | 0.982 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 40356.7 ± 0.2% | 43804.3 ± 0.4% | 0.921 | — | — |
| string: canterbury-large/E.coli | 1048576 | 34525.0 ± 5.4% | 37204.2 ± 3.3% | 0.928 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 31891.1 ± 2.1% | 33195.6 ± 3.5% | 0.961 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 31029.8 ± 5.8% | 31689.4 ± 4.4% | 0.979 | — | — |
| string: http/html-1m | 1048576 | 33016.2 ± 2.4% | 35480.1 ± 2.1% | 0.931 | — | — |
| string: http/json-1m | 1048576 | 29763.6 ± 7.8% | 31716.6 ± 4.9% | 0.938 | — | — |
| string: http/js-1m | 1048576 | 35231.8 ± 6.4% | 38432.9 ± 14.2% | 0.917 | — | — |
| string: http/css-1m | 1048576 | 34434.4 ± 3.2% | 37112.2 ± 1.9% | 0.928 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5767.5 ± 0.2% | 5651.4 ± 0.1% | 1.021 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.915 of simdutf.
- string: silesia/nci: stdx runs at 0.936 of simdutf.
- string: silesia/reymont: stdx runs at 0.931 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.924 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.910 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.921 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.928 of simdutf.
- string: http/html-1m: stdx runs at 0.931 of simdutf.
- string: http/css-1m: stdx runs at 0.928 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 36638.7 ± 1.3% | 39906.0 ± 1.1% | 0.918 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 31581.8 ± 1.2% | 32886.7 ± 1.0% | 0.960 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 35414.8 ± 1.2% | 38342.9 ± 1.5% | 0.924 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 36943.9 ± 2.1% | 40453.0 ± 3.0% | 0.913 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 36572.3 ± 1.0% | 40068.1 ± 1.7% | 0.913 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 36539.1 ± 2.4% | 39841.6 ± 0.7% | 0.917 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5757.7 ± 0.2% | 5641.4 ± 0.2% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5749.3 ± 0.2% | 5644.7 ± 0.1% | 1.019 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5754.1 ± 0.1% | 5643.5 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5759.0 ± 0.2% | 5640.7 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5750.7 ± 0.2% | 5636.1 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5758.3 ± 0.1% | 5645.2 ± 0.1% | 1.020 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1129.6 ± 0.4% | 930.9 ± 1.3% | 1021.0 ± 0.3% | 300.2 ± 0.9% | 665.8 ± 0.5% | 308.8 ± 1.6% | 1.213 | 1.106 | 3.762 | 1.696 | 3.658 |
| qlog records, JSON text sequence | 1467503 | 834.9 ± 1.5% | 817.4 ± 0.1% | 770.4 ± 0.5% | 242.9 ± 1.3% | 698.0 ± 0.5% | 248.6 ± 3.1% | 1.021 | 1.084 | 3.438 | 1.196 | 3.359 |
| string: silesia/dickens | 172528 | 5046.0 ± 0.4% | 1878.8 ± 0.2% | 2650.5 ± 0.7% | 361.0 ± 1.2% | 2872.0 ± 0.2% | 551.4 ± 2.3% | 2.686 | 1.904 | 13.979 | 1.757 | 9.151 |
| string: silesia/nci | 1075110 | 4282.4 ± 0.6% | 2236.8 ± 0.2% | 2993.7 ± 0.3% | 545.5 ± 1.3% | 2985.1 ± 0.9% | 589.8 ± 4.9% | 1.915 | 1.430 | 7.851 | 1.435 | 7.261 |
| string: silesia/reymont | 1075159 | 2911.1 ± 1.0% | 1815.2 ± 2.0% | 2062.2 ± 0.4% | 374.4 ± 0.6% | 2156.9 ± 0.7% | 534.1 ± 0.6% | 1.604 | 1.412 | 7.775 | 1.350 | 5.450 |
| string: silesia/samba | 97582 | 3494.2 ± 0.8% | 2027.2 ± 0.1% | 2616.4 ± 0.3% | 323.0 ± 0.3% | 1495.6 ± 0.8% | 427.9 ± 1.3% | 1.724 | 1.335 | 10.817 | 2.336 | 8.166 |
| string: silesia/webster | 1098490 | 3646.8 ± 0.4% | 1518.8 ± 0.3% | 2011.3 ± 0.4% | 359.5 ± 0.3% | 2181.4 ± 1.1% | 499.3 ± 1.1% | 2.401 | 1.813 | 10.145 | 1.672 | 7.304 |
| string: silesia/xml | 1090118 | 4774.8 ± 0.7% | 2356.8 ± 0.4% | 2524.6 ± 0.4% | 454.3 ± 0.9% | 2802.6 ± 0.8% | 563.4 ± 1.0% | 2.026 | 1.891 | 10.511 | 1.704 | 8.475 |
| string: canterbury/alice29.txt | 159425 | 4319.4 ± 0.5% | 1600.8 ± 0.3% | 2453.5 ± 0.5% | 342.5 ± 0.4% | 2515.3 ± 0.4% | 503.0 ± 1.0% | 2.698 | 1.760 | 12.610 | 1.717 | 8.587 |
| string: canterbury/asyoulik.txt | 132198 | 3452.5 ± 1.0% | 1458.7 ± 0.1% | 2241.2 ± 1.3% | 335.1 ± 0.8% | 2091.4 ± 0.1% | 455.0 ± 0.7% | 2.367 | 1.540 | 10.302 | 1.651 | 7.587 |
| string: canterbury/lcet10.txt | 441884 | 5107.1 ± 0.2% | 1852.3 ± 0.2% | 2340.2 ± 0.9% | 391.0 ± 0.4% | 2838.8 ± 0.7% | 529.9 ± 3.0% | 2.757 | 2.182 | 13.062 | 1.799 | 9.637 |
| string: canterbury/plrabn12.txt | 503330 | 4102.5 ± 0.6% | 1736.6 ± 0.2% | 2057.1 ± 0.4% | 361.4 ± 0.9% | 2456.1 ± 0.9% | 497.1 ± 1.2% | 2.362 | 1.994 | 11.351 | 1.670 | 8.253 |
| string: canterbury-large/E.coli | 1048578 | 18810.2 ± 1.2% | 3601.8 ± 0.2% | 3252.0 ± 0.2% | 931.5 ± 0.2% | 5992.2 ± 0.5% | 740.9 ± 2.0% | 5.222 | 5.784 | 20.193 | 3.139 | 25.387 |
| string: canterbury-large/bible.txt | 1055886 | 6675.3 ± 0.8% | 2933.1 ± 0.7% | 2825.3 ± 0.7% | 423.3 ± 1.8% | 3759.8 ± 0.7% | 615.5 ± 0.9% | 2.276 | 2.363 | 15.768 | 1.775 | 10.846 |
| string: canterbury-large/world192.txt | 1103121 | 3384.8 ± 0.4% | 1482.8 ± 0.2% | 2009.8 ± 0.6% | 353.8 ± 0.6% | 2113.6 ± 1.0% | 497.9 ± 0.7% | 2.283 | 1.684 | 9.567 | 1.601 | 6.798 |
| string: http/html-1m | 1058582 | 6021.9 ± 1.6% | 2732.2 ± 0.5% | 2699.7 ± 1.0% | 441.1 ± 0.5% | 3479.2 ± 1.3% | 596.8 ± 4.6% | 2.204 | 2.231 | 13.653 | 1.731 | 10.090 |
| string: http/json-1m | 1190272 | 2539.9 ± 0.5% | 876.8 ± 0.9% | 2248.8 ± 1.5% | 390.7 ± 0.4% | 1050.1 ± 3.5% | 441.3 ± 0.4% | 2.897 | 1.129 | 6.500 | 2.419 | 5.755 |
| string: http/js-1m | 1144362 | 2283.3 ± 0.9% | 1027.8 ± 0.2% | 1640.7 ± 0.5% | 320.9 ± 0.3% | 1506.6 ± 0.5% | 418.5 ± 0.8% | 2.222 | 1.392 | 7.115 | 1.516 | 5.456 |
| string: http/css-1m | 1097820 | 2633.0 ± 0.6% | 1677.4 ± 0.4% | 2225.0 ± 0.6% | 407.3 ± 1.1% | 1902.6 ± 2.2% | 486.4 ± 1.0% | 1.570 | 1.183 | 6.464 | 1.384 | 5.414 |
| string: dickens as Cyrillic and CJK | 1883069 | 3061.9 ± 0.2% | 1686.8 ± 0.3% | 893.6 ± 0.4% | 351.1 ± 0.2% | 668.2 ± 0.5% | 156.4 ± 3.2% | 1.815 | 3.427 | 8.721 | 4.582 | 19.578 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.0 ± 1.0% | 980.8 ± 0.4% | 1200.0 ± 0.5% | 213.4 ± 0.2% | 472.9 ± 1.3% | 251.6 ± 4.0% | 1.353 | 1.106 | 6.218 | 2.806 | 5.274 |
| hex: silesia/dickens | 524290 | 18448.1 ± 2.4% | 3618.4 ± 0.2% | 3281.0 ± 0.1% | 513.3 ± 2.0% | 5980.5 ± 0.9% | 779.3 ± 2.9% | 5.098 | 5.623 | 35.942 | 3.085 | 23.674 |
| hex: silesia/mozilla | 524290 | 18597.5 ± 0.8% | 3616.9 ± 0.1% | 3303.0 ± 0.2% | 451.6 ± 1.8% | 6101.4 ± 1.4% | 781.4 ± 0.6% | 5.142 | 5.630 | 41.184 | 3.048 | 23.801 |
| hex: silesia/mr | 524290 | 18529.2 ± 1.0% | 3614.1 ± 0.2% | 3299.1 ± 0.3% | 568.6 ± 0.7% | 6116.9 ± 2.0% | 780.7 ± 0.4% | 5.127 | 5.616 | 32.589 | 3.029 | 23.735 |
| hex: silesia/nci | 524290 | 18240.5 ± 0.8% | 3616.5 ± 0.2% | 3279.4 ± 0.3% | 623.9 ± 0.3% | 6119.3 ± 2.1% | 780.3 ± 0.5% | 5.044 | 5.562 | 29.238 | 2.981 | 23.375 |
| hex: silesia/ooffice | 524290 | 18544.9 ± 1.5% | 3616.2 ± 0.2% | 3288.7 ± 0.2% | 396.4 ± 0.8% | 6138.5 ± 0.5% | 778.8 ± 0.4% | 5.128 | 5.639 | 46.780 | 3.021 | 23.812 |
| hex: silesia/osdb | 524290 | 18326.9 ± 0.9% | 3617.9 ± 0.2% | 3293.1 ± 0.2% | 475.8 ± 1.4% | 6077.4 ± 0.9% | 780.8 ± 0.6% | 5.066 | 5.565 | 38.516 | 3.016 | 23.473 |
| hex: silesia/reymont | 524290 | 18606.2 ± 1.3% | 3615.8 ± 0.1% | 3293.5 ± 0.2% | 519.2 ± 1.7% | 6141.0 ± 1.7% | 780.6 ± 1.1% | 5.146 | 5.649 | 35.838 | 3.030 | 23.837 |
| hex: silesia/samba | 524290 | 18007.9 ± 0.7% | 3613.8 ± 0.3% | 3292.2 ± 0.4% | 410.4 ± 2.0% | 6133.0 ± 0.8% | 777.8 ± 0.8% | 4.983 | 5.470 | 43.881 | 2.936 | 23.154 |
| hex: silesia/sao | 524290 | 18546.2 ± 1.6% | 3614.4 ± 0.2% | 3284.9 ± 0.4% | 345.6 ± 1.3% | 6102.6 ± 1.6% | 780.4 ± 0.8% | 5.131 | 5.646 | 53.658 | 3.039 | 23.764 |
| hex: silesia/webster | 524290 | 18576.7 ± 2.1% | 3617.5 ± 0.4% | 3284.0 ± 0.5% | 473.0 ± 1.8% | 6139.0 ± 1.3% | 782.3 ± 0.5% | 5.135 | 5.657 | 39.275 | 3.026 | 23.747 |
| hex: silesia/x-ray | 524290 | 18601.2 ± 0.8% | 3618.3 ± 0.3% | 3289.7 ± 0.2% | 475.9 ± 2.2% | 6106.4 ± 2.7% | 782.6 ± 0.6% | 5.141 | 5.654 | 39.088 | 3.046 | 23.767 |
| hex: silesia/xml | 524290 | 18294.0 ± 1.3% | 3616.3 ± 0.2% | 3291.4 ± 0.2% | 531.4 ± 0.8% | 6128.0 ± 1.4% | 780.2 ± 0.3% | 5.059 | 5.558 | 34.423 | 2.985 | 23.447 |
| hex: canterbury/alice29.txt | 304180 | 19082.6 ± 0.7% | 3626.9 ± 0.2% | 3334.9 ± 0.3% | 523.7 ± 0.6% | 6115.2 ± 0.9% | 779.5 ± 1.3% | 5.261 | 5.722 | 36.439 | 3.121 | 24.482 |
| hex: canterbury/asyoulik.txt | 250360 | 19522.6 ± 0.1% | 3632.6 ± 0.2% | 3370.4 ± 0.1% | 517.2 ± 0.3% | 6115.1 ± 0.6% | 776.4 ± 1.1% | 5.374 | 5.792 | 37.748 | 3.193 | 25.145 |
| hex: canterbury/cp.html | 49208 | 19297.0 ± 0.3% | 3638.5 ± 0.1% | 3292.2 ± 0.3% | 469.8 ± 0.9% | 6211.1 ± 1.9% | 762.5 ± 2.0% | 5.304 | 5.861 | 41.078 | 3.107 | 25.307 |
| hex: canterbury/fields.c | 22302 | 18894.3 ± 0.9% | 3629.6 ± 0.0% | 3352.6 ± 0.0% | 499.5 ± 0.4% | 6252.8 ± 0.2% | 759.7 ± 2.6% | 5.206 | 5.636 | 37.823 | 3.022 | 24.869 |
| hex: canterbury/grammar.lsp | 7444 | 17434.8 ± 1.6% | 3601.1 ± 0.0% | 3356.9 ± 0.2% | 541.0 ± 1.6% | 6177.4 ± 0.5% | 723.8 ± 5.3% | 4.842 | 5.194 | 32.227 | 2.822 | 24.089 |
| hex: canterbury/kennedy.xls | 524290 | 18156.1 ± 1.5% | 3620.6 ± 0.5% | 3279.1 ± 0.4% | 657.2 ± 4.9% | 6072.4 ± 1.0% | 774.5 ± 5.1% | 5.015 | 5.537 | 27.628 | 2.990 | 23.443 |
| hex: canterbury/lcet10.txt | 524290 | 18574.1 ± 1.5% | 3619.6 ± 0.2% | 3285.9 ± 0.2% | 513.5 ± 1.3% | 6139.6 ± 1.4% | 779.5 ± 0.6% | 5.132 | 5.653 | 36.173 | 3.025 | 23.829 |
| hex: canterbury/plrabn12.txt | 524290 | 18232.4 ± 0.5% | 3619.1 ± 0.1% | 3288.5 ± 0.5% | 504.2 ± 0.4% | 6048.8 ± 1.0% | 781.5 ± 0.3% | 5.038 | 5.544 | 36.160 | 3.014 | 23.331 |
| hex: canterbury/ptt5 | 524290 | 18247.1 ± 0.9% | 3617.1 ± 0.1% | 3291.0 ± 0.3% | 558.5 ± 0.2% | 5995.8 ± 1.1% | 780.9 ± 0.3% | 5.045 | 5.545 | 32.670 | 3.043 | 23.367 |
| hex: canterbury/sum | 76482 | 19290.7 ± 0.1% | 3633.8 ± 0.0% | 3356.0 ± 0.3% | 509.9 ± 0.9% | 6185.2 ± 0.5% | 770.8 ± 0.8% | 5.309 | 5.748 | 37.829 | 3.119 | 25.026 |
| hex: canterbury/xargs.1 | 8456 | 17839.4 ± 0.4% | 3602.6 ± 0.0% | 3378.7 ± 0.3% | 488.9 ± 1.5% | 6153.6 ± 0.2% | 755.4 ± 1.4% | 4.952 | 5.280 | 36.487 | 2.899 | 23.616 |
| hex: canterbury-large/E.coli | 524290 | 18307.6 ± 3.5% | 3609.6 ± 0.3% | 3285.5 ± 0.5% | 688.8 ± 0.2% | 6156.8 ± 1.9% | 775.3 ± 5.8% | 5.072 | 5.572 | 26.578 | 2.974 | 23.614 |
| hex: canterbury-large/bible.txt | 524290 | 18658.6 ± 4.9% | 3613.3 ± 0.2% | 3295.0 ± 0.3% | 521.3 ± 1.1% | 6083.7 ± 1.6% | 781.8 ± 0.5% | 5.164 | 5.663 | 35.789 | 3.067 | 23.867 |
| hex: canterbury-large/world192.txt | 524290 | 17988.8 ± 0.9% | 3613.5 ± 0.1% | 3278.2 ± 0.3% | 495.5 ± 0.7% | 6016.7 ± 1.1% | 778.6 ± 0.3% | 4.978 | 5.487 | 36.307 | 2.990 | 23.105 |
| hex: http/html-1kx1024 | 2099200 | 9084.5 ± 18.4% | 3458.8 ± 0.1% | 2842.5 ± 0.2% | 474.6 ± 0.4% | 5072.4 ± 1.0% | 642.1 ± 4.4% | 2.627 | 3.196 | 19.142 | 1.791 | 14.149 |
| hex: http/html-16kx64 | 2097280 | 17642.0 ± 0.9% | 3607.1 ± 0.1% | 3268.4 ± 0.2% | 479.2 ± 0.6% | 5997.0 ± 0.3% | 757.8 ± 1.1% | 4.891 | 5.398 | 36.819 | 2.942 | 23.280 |
| hex: http/html-1m | 524290 | 18108.3 ± 1.1% | 3608.0 ± 0.1% | 3284.6 ± 0.3% | 498.8 ± 0.8% | 6095.8 ± 1.8% | 780.4 ± 2.8% | 5.019 | 5.513 | 36.306 | 2.971 | 23.203 |
| hex: http/json-1kx1024 | 2099200 | 8972.6 ± 17.1% | 3461.1 ± 0.7% | 2831.7 ± 8.8% | 575.0 ± 0.2% | 5123.4 ± 1.0% | 629.5 ± 2.1% | 2.592 | 3.169 | 15.603 | 1.751 | 14.253 |
| hex: http/json-16kx64 | 2097280 | 17816.1 ± 1.7% | 3607.5 ± 0.1% | 3244.7 ± 0.2% | 573.4 ± 0.9% | 6021.0 ± 0.6% | 745.3 ± 1.3% | 4.939 | 5.491 | 31.072 | 2.959 | 23.904 |
| hex: http/json-1m | 524290 | 18228.8 ± 1.4% | 3610.1 ± 0.1% | 3283.1 ± 0.3% | 593.8 ± 0.9% | 6058.3 ± 1.7% | 763.2 ± 2.2% | 5.049 | 5.552 | 30.701 | 3.009 | 23.885 |
| hex: http/js-1kx1024 | 2099200 | 9428.9 ± 20.5% | 3460.0 ± 0.1% | 2832.5 ± 0.6% | 478.8 ± 0.4% | 5082.3 ± 0.7% | 624.1 ± 1.7% | 2.725 | 3.329 | 19.691 | 1.855 | 15.109 |
| hex: http/js-16kx64 | 2097280 | 17734.0 ± 1.1% | 3609.2 ± 0.1% | 3259.1 ± 0.4% | 480.4 ± 1.2% | 6011.7 ± 0.7% | 751.5 ± 2.8% | 4.914 | 5.441 | 36.916 | 2.950 | 23.597 |
| hex: http/js-1m | 524290 | 18309.2 ± 2.7% | 3616.6 ± 0.2% | 3290.9 ± 0.3% | 495.8 ± 2.2% | 5953.5 ± 0.8% | 780.7 ± 4.0% | 5.063 | 5.564 | 36.927 | 3.075 | 23.452 |
| hex: http/css-1kx1024 | 2099200 | 9075.9 ± 18.6% | 3459.3 ± 0.1% | 2834.3 ± 0.3% | 486.0 ± 0.6% | 5070.9 ± 0.9% | 629.1 ± 2.0% | 2.624 | 3.202 | 18.676 | 1.790 | 14.426 |
| hex: http/css-16kx64 | 2097280 | 17762.9 ± 1.5% | 3609.0 ± 0.1% | 3256.4 ± 0.5% | 495.0 ± 0.2% | 6015.2 ± 0.9% | 749.8 ± 2.6% | 4.922 | 5.455 | 35.887 | 2.953 | 23.690 |
| hex: http/css-1m | 524290 | 18237.7 ± 1.2% | 3621.9 ± 0.1% | 3285.0 ± 0.2% | 492.8 ± 0.9% | 6105.9 ± 1.4% | 772.3 ± 2.2% | 5.035 | 5.552 | 37.012 | 2.987 | 23.616 |
| hex: shuffled/dickens-1m | 524290 | 18005.3 ± 0.7% | 3615.9 ± 0.2% | 3281.3 ± 0.4% | 510.1 ± 0.7% | 6026.0 ± 1.2% | 782.2 ± 0.4% | 4.979 | 5.487 | 35.301 | 2.988 | 23.018 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1483.6 ± 1.6% | 1251.8 ± 3.4% | 1036.8 ± 6.6% | 408.8 ± 2.7% | 448.9 ± 2.3% | 414.9 ± 4.0% | 1.185 | 1.431 | 3.629 | 3.305 | 3.576 |
| qlog records, JSON text sequence | 1467503 | 1265.0 ± 0.9% | 1059.8 ± 19.0% | 781.3 ± 25.4% | 378.0 ± 5.8% | 466.3 ± 2.1% | 278.6 ± 0.3% | 1.194 | 1.619 | 3.346 | 2.713 | 4.540 |
| string: silesia/dickens | 172528 | 6895.3 ± 0.5% | 2811.1 ± 0.6% | 2931.5 ± 0.9% | 430.6 ± 0.9% | 1565.5 ± 0.2% | 1008.8 ± 0.2% | 2.453 | 2.352 | 16.015 | 4.405 | 6.835 |
| string: silesia/nci | 1075110 | 7309.8 ± 0.4% | 3403.3 ± 0.3% | 3099.9 ± 0.4% | 811.7 ± 1.1% | 1834.5 ± 0.3% | 1107.3 ± 0.3% | 2.148 | 2.358 | 9.006 | 3.985 | 6.601 |
| string: silesia/reymont | 1075159 | 3320.7 ± 1.3% | 1978.4 ± 1.7% | 2057.3 ± 0.9% | 450.3 ± 0.6% | 1491.0 ± 0.7% | 949.7 ± 0.5% | 1.678 | 1.614 | 7.374 | 2.227 | 3.496 |
| string: silesia/samba | 97582 | 4194.7 ± 0.8% | 2109.4 ± 0.6% | 3447.6 ± 0.7% | 353.0 ± 0.8% | 1406.1 ± 0.3% | 1053.9 ± 0.3% | 1.989 | 1.217 | 11.883 | 2.983 | 3.980 |
| string: silesia/webster | 1098490 | 4049.0 ± 0.8% | 1876.9 ± 0.7% | 2052.8 ± 0.6% | 440.7 ± 0.8% | 1371.2 ± 0.4% | 645.8 ± 0.5% | 2.157 | 1.972 | 9.188 | 2.953 | 6.270 |
| string: silesia/xml | 1090118 | 6106.2 ± 0.3% | 2845.4 ± 0.7% | 2654.2 ± 0.2% | 611.2 ± 0.8% | 1731.8 ± 0.3% | 920.7 ± 0.3% | 2.146 | 2.301 | 9.990 | 3.526 | 6.632 |
| string: canterbury/alice29.txt | 159425 | 6389.2 ± 0.8% | 2193.6 ± 0.4% | 2756.2 ± 0.6% | 407.9 ± 0.2% | 1437.2 ± 0.5% | 956.7 ± 0.1% | 2.913 | 2.318 | 15.663 | 4.446 | 6.678 |
| string: canterbury/asyoulik.txt | 132198 | 5595.5 ± 1.4% | 1709.0 ± 0.3% | 2379.3 ± 1.3% | 402.2 ± 0.5% | 1309.4 ± 0.4% | 885.6 ± 0.2% | 3.274 | 2.352 | 13.911 | 4.273 | 6.318 |
| string: canterbury/lcet10.txt | 441884 | 6235.3 ± 1.3% | 2563.8 ± 0.3% | 2497.2 ± 1.9% | 467.8 ± 0.2% | 1522.5 ± 0.4% | 984.5 ± 0.8% | 2.432 | 2.497 | 13.328 | 4.096 | 6.334 |
| string: canterbury/plrabn12.txt | 503330 | 5709.0 ± 0.3% | 2055.3 ± 0.3% | 2066.5 ± 0.5% | 424.3 ± 0.5% | 1361.1 ± 0.3% | 931.4 ± 0.5% | 2.778 | 2.763 | 13.456 | 4.194 | 6.129 |
| string: canterbury-large/E.coli | 1048578 | 19105.5 ± 1.3% | 9789.7 ± 0.7% | 3787.5 ± 0.4% | 1473.4 ± 0.7% | 2362.0 ± 1.2% | 1188.2 ± 0.6% | 1.952 | 5.044 | 12.967 | 8.089 | 16.080 |
| string: canterbury-large/bible.txt | 1055886 | 6790.5 ± 0.7% | 4150.1 ± 1.1% | 3055.9 ± 1.7% | 501.7 ± 0.8% | 1978.5 ± 0.3% | 1117.9 ± 1.2% | 1.636 | 2.222 | 13.535 | 3.432 | 6.074 |
| string: canterbury-large/world192.txt | 1103121 | 4014.4 ± 0.4% | 1654.8 ± 0.6% | 1996.7 ± 1.2% | 449.3 ± 0.5% | 1342.3 ± 0.2% | 907.4 ± 0.5% | 2.426 | 2.011 | 8.935 | 2.991 | 4.424 |
| string: http/html-1m | 1058582 | 6736.3 ± 0.5% | 3921.2 ± 0.5% | 3037.8 ± 0.5% | 500.8 ± 0.2% | 1919.0 ± 0.2% | 804.9 ± 0.4% | 1.718 | 2.217 | 13.450 | 3.510 | 8.369 |
| string: http/json-1m | 1190272 | 3160.8 ± 0.4% | 1354.5 ± 0.3% | 1556.1 ± 0.5% | 443.4 ± 1.0% | 1035.2 ± 0.2% | 764.6 ± 0.5% | 2.334 | 2.031 | 7.128 | 3.053 | 4.134 |
| string: http/js-1m | 1144362 | 2759.1 ± 0.7% | 1180.2 ± 0.5% | 1622.9 ± 0.4% | 369.7 ± 0.3% | 1084.5 ± 0.1% | 757.4 ± 0.3% | 2.338 | 1.700 | 7.464 | 2.544 | 3.643 |
| string: http/css-1m | 1097820 | 3970.4 ± 0.7% | 1492.8 ± 0.3% | 2146.0 ± 0.5% | 494.0 ± 0.5% | 1356.1 ± 0.4% | 893.3 ± 0.4% | 2.660 | 1.850 | 8.037 | 2.928 | 4.445 |
| string: dickens as Cyrillic and CJK | 1883069 | 3064.5 ± 0.4% | 2341.4 ± 0.5% | 521.7 ± 0.3% | 307.0 ± 0.7% | 560.1 ± 1.2% | 335.8 ± 0.2% | 1.309 | 5.874 | 9.982 | 5.472 | 9.127 |
| hex: silesia/dickens | 524290 | 15677.8 ± 0.1% | 1458.9 ± 0.2% | 1082.6 ± 0.3% | 500.1 ± 1.0% | 993.7 ± 0.5% | 732.6 ± 0.2% | 10.746 | 14.482 | 31.351 | 15.777 | 21.400 |
| hex: silesia/mozilla | 524290 | 15653.0 ± 0.1% | 1470.5 ± 0.2% | 1089.3 ± 0.3% | 439.9 ± 0.7% | 992.4 ± 1.1% | 733.8 ± 0.4% | 10.645 | 14.370 | 35.582 | 15.772 | 21.332 |
| hex: silesia/mr | 524290 | 15615.0 ± 0.2% | 1478.8 ± 1.2% | 1093.6 ± 0.4% | 549.0 ± 2.5% | 997.8 ± 0.7% | 733.6 ± 0.4% | 10.559 | 14.279 | 28.444 | 15.650 | 21.286 |
| hex: silesia/nci | 524290 | 15663.9 ± 0.3% | 1466.7 ± 0.2% | 1089.5 ± 0.3% | 637.6 ± 4.0% | 990.7 ± 0.5% | 731.3 ± 0.4% | 10.680 | 14.377 | 24.567 | 15.811 | 21.419 |
| hex: silesia/ooffice | 524290 | 15605.3 ± 0.2% | 1463.6 ± 0.2% | 1085.6 ± 0.2% | 389.3 ± 0.4% | 988.0 ± 0.3% | 733.3 ± 0.4% | 10.662 | 14.375 | 40.088 | 15.795 | 21.282 |
| hex: silesia/osdb | 524290 | 15610.7 ± 0.2% | 1465.5 ± 0.5% | 1083.9 ± 0.6% | 465.1 ± 0.5% | 992.3 ± 0.8% | 733.1 ± 0.4% | 10.652 | 14.403 | 33.561 | 15.732 | 21.295 |
| hex: silesia/reymont | 524290 | 15647.8 ± 0.2% | 1460.5 ± 0.6% | 1086.4 ± 0.3% | 515.9 ± 1.0% | 991.7 ± 0.6% | 733.4 ± 0.3% | 10.714 | 14.403 | 30.332 | 15.778 | 21.336 |
| hex: silesia/samba | 524290 | 15652.5 ± 0.2% | 1464.8 ± 0.4% | 1084.3 ± 0.4% | 402.1 ± 0.2% | 989.9 ± 0.4% | 732.3 ± 0.4% | 10.686 | 14.436 | 38.930 | 15.813 | 21.376 |
| hex: silesia/sao | 524290 | 15652.4 ± 0.1% | 1462.9 ± 0.3% | 1084.3 ± 0.4% | 332.2 ± 0.4% | 992.3 ± 0.6% | 734.0 ± 0.6% | 10.699 | 14.435 | 47.117 | 15.774 | 21.325 |
| hex: silesia/webster | 524290 | 15636.0 ± 0.3% | 1458.5 ± 0.6% | 1083.6 ± 0.4% | 474.1 ± 0.5% | 988.3 ± 0.5% | 731.8 ± 0.7% | 10.721 | 14.429 | 32.979 | 15.820 | 21.366 |
| hex: silesia/x-ray | 524290 | 15625.6 ± 0.2% | 1475.3 ± 0.1% | 1090.9 ± 0.5% | 446.8 ± 1.1% | 996.6 ± 0.4% | 732.9 ± 0.3% | 10.591 | 14.324 | 34.970 | 15.679 | 21.321 |
| hex: silesia/xml | 524290 | 15640.2 ± 0.2% | 1468.2 ± 0.2% | 1085.4 ± 0.3% | 612.3 ± 0.6% | 988.4 ± 0.6% | 733.2 ± 0.2% | 10.653 | 14.410 | 25.545 | 15.823 | 21.333 |
| hex: canterbury/alice29.txt | 304180 | 15666.3 ± 0.2% | 1465.9 ± 0.7% | 1090.2 ± 0.2% | 504.5 ± 1.5% | 995.8 ± 0.7% | 732.9 ± 0.8% | 10.687 | 14.370 | 31.050 | 15.732 | 21.375 |
| hex: canterbury/asyoulik.txt | 250360 | 15705.7 ± 0.1% | 1475.8 ± 0.2% | 1090.2 ± 0.5% | 499.4 ± 1.2% | 994.7 ± 0.5% | 738.9 ± 0.3% | 10.642 | 14.406 | 31.448 | 15.790 | 21.254 |
| hex: canterbury/cp.html | 49208 | 15620.0 ± 0.2% | 1473.1 ± 0.2% | 1097.8 ± 0.2% | 520.9 ± 2.7% | 1001.2 ± 0.4% | 743.7 ± 0.1% | 10.603 | 14.229 | 29.985 | 15.602 | 21.002 |
| hex: canterbury/fields.c | 22302 | 15441.6 ± 0.1% | 1440.2 ± 0.2% | 1062.1 ± 0.7% | 636.0 ± 7.4% | 986.6 ± 0.3% | 737.4 ± 0.1% | 10.722 | 14.539 | 24.280 | 15.652 | 20.939 |
| hex: canterbury/grammar.lsp | 7444 | 14940.3 ± 0.2% | 1506.2 ± 0.3% | 1094.6 ± 0.3% | 674.6 ± 7.7% | 987.2 ± 0.2% | 725.8 ± 0.1% | 9.919 | 13.650 | 22.146 | 15.134 | 20.584 |
| hex: canterbury/kennedy.xls | 524290 | 15656.8 ± 0.2% | 1472.3 ± 0.2% | 1088.8 ± 0.4% | 643.7 ± 3.2% | 990.8 ± 0.2% | 733.7 ± 0.3% | 10.635 | 14.379 | 24.324 | 15.803 | 21.339 |
| hex: canterbury/lcet10.txt | 524290 | 15634.9 ± 0.1% | 1466.7 ± 0.3% | 1084.8 ± 0.3% | 502.6 ± 3.1% | 993.2 ± 0.8% | 733.1 ± 0.4% | 10.660 | 14.413 | 31.107 | 15.741 | 21.327 |
| hex: canterbury/plrabn12.txt | 524290 | 15621.1 ± 0.1% | 1462.9 ± 0.2% | 1083.5 ± 0.6% | 491.0 ± 1.5% | 986.7 ± 0.5% | 734.0 ± 0.5% | 10.678 | 14.418 | 31.813 | 15.832 | 21.282 |
| hex: canterbury/ptt5 | 524290 | 15636.0 ± 0.2% | 1479.6 ± 0.4% | 1093.6 ± 0.3% | 555.4 ± 0.3% | 994.6 ± 0.7% | 735.3 ± 0.8% | 10.568 | 14.297 | 28.154 | 15.720 | 21.266 |
| hex: canterbury/sum | 76482 | 15642.9 ± 0.0% | 1494.5 ± 0.1% | 1104.0 ± 0.4% | 597.7 ± 0.4% | 998.2 ± 0.1% | 744.4 ± 0.1% | 10.467 | 14.170 | 26.171 | 15.670 | 21.013 |
| hex: canterbury/xargs.1 | 8456 | 14994.8 ± 0.1% | 1493.9 ± 0.5% | 1096.7 ± 0.4% | 660.1 ± 4.6% | 973.7 ± 0.1% | 728.4 ± 0.7% | 10.037 | 13.672 | 22.715 | 15.399 | 20.585 |
| hex: canterbury-large/E.coli | 524290 | 15625.2 ± 0.3% | 1472.4 ± 0.7% | 1088.6 ± 0.7% | 672.3 ± 0.4% | 991.5 ± 0.4% | 733.8 ± 0.3% | 10.612 | 14.353 | 23.242 | 15.759 | 21.292 |
| hex: canterbury-large/bible.txt | 524290 | 15627.4 ± 0.2% | 1462.3 ± 0.3% | 1083.7 ± 0.5% | 511.5 ± 1.2% | 984.3 ± 0.7% | 734.6 ± 0.4% | 10.687 | 14.420 | 30.553 | 15.877 | 21.274 |
| hex: canterbury-large/world192.txt | 524290 | 15599.2 ± 0.3% | 1464.0 ± 0.6% | 1084.0 ± 0.4% | 502.2 ± 0.7% | 988.7 ± 0.4% | 733.0 ± 0.4% | 10.655 | 14.390 | 31.059 | 15.777 | 21.283 |
| hex: http/html-1kx1024 | 2099200 | 13734.7 ± 0.5% | 1455.7 ± 0.1% | 1061.7 ± 0.6% | 501.4 ± 0.2% | 982.8 ± 0.2% | 692.8 ± 0.1% | 9.435 | 12.937 | 27.394 | 13.976 | 19.824 |
| hex: http/html-16kx64 | 2097280 | 15258.0 ± 0.5% | 1442.1 ± 0.2% | 1074.5 ± 0.5% | 506.5 ± 0.2% | 996.2 ± 0.1% | 735.2 ± 0.1% | 10.580 | 14.200 | 30.125 | 15.316 | 20.753 |
| hex: http/html-1m | 524290 | 15616.0 ± 0.3% | 1468.1 ± 0.2% | 1086.4 ± 0.4% | 500.2 ± 0.3% | 990.6 ± 0.3% | 733.8 ± 0.4% | 10.637 | 14.374 | 31.219 | 15.765 | 21.282 |
| hex: http/json-1kx1024 | 2099200 | 13613.4 ± 0.3% | 1463.9 ± 0.2% | 1067.1 ± 0.1% | 608.9 ± 0.3% | 987.8 ± 0.2% | 692.8 ± 0.3% | 9.299 | 12.758 | 22.359 | 13.782 | 19.649 |
| hex: http/json-16kx64 | 2097280 | 15205.2 ± 0.5% | 1446.5 ± 0.2% | 1074.5 ± 0.2% | 616.3 ± 0.5% | 994.7 ± 0.4% | 735.3 ± 0.1% | 10.512 | 14.151 | 24.673 | 15.286 | 20.678 |
| hex: http/json-1m | 524290 | 15632.7 ± 0.3% | 1470.1 ± 0.3% | 1087.2 ± 0.1% | 629.0 ± 1.0% | 992.8 ± 0.2% | 734.1 ± 0.1% | 10.634 | 14.379 | 24.852 | 15.746 | 21.294 |
| hex: http/js-1kx1024 | 2099200 | 13654.0 ± 0.5% | 1455.6 ± 0.2% | 1062.4 ± 0.1% | 498.5 ± 0.1% | 982.8 ± 0.1% | 693.1 ± 0.1% | 9.381 | 12.852 | 27.393 | 13.893 | 19.700 |
| hex: http/js-16kx64 | 2097280 | 15207.6 ± 0.6% | 1443.6 ± 0.2% | 1075.6 ± 0.1% | 503.8 ± 0.4% | 998.1 ± 0.4% | 735.1 ± 0.1% | 10.535 | 14.138 | 30.185 | 15.237 | 20.689 |
| hex: http/js-1m | 524290 | 15683.0 ± 0.3% | 1464.4 ± 0.2% | 1085.2 ± 0.6% | 509.5 ± 0.6% | 990.7 ± 0.3% | 732.5 ± 0.5% | 10.709 | 14.451 | 30.784 | 15.830 | 21.409 |
| hex: http/css-1kx1024 | 2099200 | 13684.7 ± 0.5% | 1456.3 ± 0.1% | 1062.8 ± 0.2% | 531.3 ± 0.3% | 983.3 ± 0.1% | 692.5 ± 0.1% | 9.397 | 12.876 | 25.755 | 13.917 | 19.761 |
| hex: http/css-16kx64 | 2097280 | 15231.5 ± 0.7% | 1444.4 ± 0.1% | 1076.4 ± 0.7% | 541.4 ± 0.5% | 997.9 ± 0.6% | 735.1 ± 0.5% | 10.545 | 14.150 | 28.132 | 15.263 | 20.719 |
| hex: http/css-1m | 524290 | 15682.5 ± 0.2% | 1461.4 ± 0.3% | 1082.9 ± 0.6% | 527.4 ± 0.4% | 989.9 ± 0.3% | 733.4 ± 0.9% | 10.732 | 14.482 | 29.735 | 15.842 | 21.384 |
| hex: shuffled/dickens-1m | 524290 | 15613.3 ± 0.3% | 1461.4 ± 0.3% | 1086.9 ± 0.4% | 502.9 ± 0.8% | 991.7 ± 0.3% | 733.4 ± 0.3% | 10.684 | 14.366 | 31.044 | 15.744 | 21.289 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1522.8 ± 0.6% | 1251.8 ± 3.4% | 1036.8 ± 6.6% | 408.8 ± 2.7% | 448.9 ± 2.3% | 414.9 ± 4.0% | 1.216 | 1.469 | 3.725 | 3.392 | 3.670 |
| qlog records, JSON text sequence | 1467503 | 1287.1 ± 0.5% | 1059.8 ± 19.0% | 781.3 ± 25.4% | 378.0 ± 5.8% | 466.3 ± 2.1% | 278.6 ± 0.3% | 1.214 | 1.647 | 3.405 | 2.760 | 4.619 |
| string: silesia/dickens | 172528 | 7128.1 ± 0.5% | 2811.1 ± 0.6% | 2931.5 ± 0.9% | 430.6 ± 0.9% | 1565.5 ± 0.2% | 1008.8 ± 0.2% | 2.536 | 2.432 | 16.555 | 4.553 | 7.066 |
| string: silesia/nci | 1075110 | 7372.7 ± 1.7% | 3403.3 ± 0.3% | 3099.9 ± 0.4% | 811.7 ± 1.1% | 1834.5 ± 0.3% | 1107.3 ± 0.3% | 2.166 | 2.378 | 9.083 | 4.019 | 6.658 |
| string: silesia/reymont | 1075159 | 3507.6 ± 1.4% | 1978.4 ± 1.7% | 2057.3 ± 0.9% | 450.3 ± 0.6% | 1491.0 ± 0.7% | 949.7 ± 0.5% | 1.773 | 1.705 | 7.789 | 2.352 | 3.693 |
| string: silesia/samba | 97582 | 4576.1 ± 0.3% | 2109.4 ± 0.6% | 3447.6 ± 0.7% | 353.0 ± 0.8% | 1406.1 ± 0.3% | 1053.9 ± 0.3% | 2.169 | 1.327 | 12.963 | 3.254 | 4.342 |
| string: silesia/webster | 1098490 | 4096.9 ± 0.3% | 1876.9 ± 0.7% | 2052.8 ± 0.6% | 440.7 ± 0.8% | 1371.2 ± 0.4% | 645.8 ± 0.5% | 2.183 | 1.996 | 9.296 | 2.988 | 6.344 |
| string: silesia/xml | 1090118 | 6220.7 ± 0.7% | 2845.4 ± 0.7% | 2654.2 ± 0.2% | 611.2 ± 0.8% | 1731.8 ± 0.3% | 920.7 ± 0.3% | 2.186 | 2.344 | 10.178 | 3.592 | 6.756 |
| string: canterbury/alice29.txt | 159425 | 6749.2 ± 1.5% | 2193.6 ± 0.4% | 2756.2 ± 0.6% | 407.9 ± 0.2% | 1437.2 ± 0.5% | 956.7 ± 0.1% | 3.077 | 2.449 | 16.546 | 4.696 | 7.054 |
| string: canterbury/asyoulik.txt | 132198 | 5861.3 ± 1.8% | 1709.0 ± 0.3% | 2379.3 ± 1.3% | 402.2 ± 0.5% | 1309.4 ± 0.4% | 885.6 ± 0.2% | 3.430 | 2.463 | 14.572 | 4.476 | 6.618 |
| string: canterbury/lcet10.txt | 441884 | 6244.8 ± 0.3% | 2563.8 ± 0.3% | 2497.2 ± 1.9% | 467.8 ± 0.2% | 1522.5 ± 0.4% | 984.5 ± 0.8% | 2.436 | 2.501 | 13.348 | 4.102 | 6.343 |
| string: canterbury/plrabn12.txt | 503330 | 5750.4 ± 0.4% | 2055.3 ± 0.3% | 2066.5 ± 0.5% | 424.3 ± 0.5% | 1361.1 ± 0.3% | 931.4 ± 0.5% | 2.798 | 2.783 | 13.553 | 4.225 | 6.174 |
| string: canterbury-large/E.coli | 1048578 | 19172.8 ± 0.6% | 9789.7 ± 0.7% | 3787.5 ± 0.4% | 1473.4 ± 0.7% | 2362.0 ± 1.2% | 1188.2 ± 0.6% | 1.958 | 5.062 | 13.012 | 8.117 | 16.137 |
| string: canterbury-large/bible.txt | 1055886 | 6794.6 ± 0.2% | 4150.1 ± 1.1% | 3055.9 ± 1.7% | 501.7 ± 0.8% | 1978.5 ± 0.3% | 1117.9 ± 1.2% | 1.637 | 2.223 | 13.543 | 3.434 | 6.078 |
| string: canterbury-large/world192.txt | 1103121 | 4038.3 ± 1.1% | 1654.8 ± 0.6% | 1996.7 ± 1.2% | 449.3 ± 0.5% | 1342.3 ± 0.2% | 907.4 ± 0.5% | 2.440 | 2.023 | 8.989 | 3.008 | 4.450 |
| string: http/html-1m | 1058582 | 6804.3 ± 0.2% | 3921.2 ± 0.5% | 3037.8 ± 0.5% | 500.8 ± 0.2% | 1919.0 ± 0.2% | 804.9 ± 0.4% | 1.735 | 2.240 | 13.586 | 3.546 | 8.453 |
| string: http/json-1m | 1190272 | 3298.0 ± 1.1% | 1354.5 ± 0.3% | 1556.1 ± 0.5% | 443.4 ± 1.0% | 1035.2 ± 0.2% | 764.6 ± 0.5% | 2.435 | 2.119 | 7.438 | 3.186 | 4.313 |
| string: http/js-1m | 1144362 | 2800.1 ± 0.9% | 1180.2 ± 0.5% | 1622.9 ± 0.4% | 369.7 ± 0.3% | 1084.5 ± 0.1% | 757.4 ± 0.3% | 2.373 | 1.725 | 7.575 | 2.582 | 3.697 |
| string: http/css-1m | 1097820 | 4036.7 ± 0.7% | 1492.8 ± 0.3% | 2146.0 ± 0.5% | 494.0 ± 0.5% | 1356.1 ± 0.4% | 893.3 ± 0.4% | 2.704 | 1.881 | 8.171 | 2.977 | 4.519 |
| string: dickens as Cyrillic and CJK | 1883069 | 3074.7 ± 0.5% | 2341.4 ± 0.5% | 521.7 ± 0.3% | 307.0 ± 0.7% | 560.1 ± 1.2% | 335.8 ± 0.2% | 1.313 | 5.894 | 10.016 | 5.490 | 9.158 |
| hex: silesia/dickens | 524290 | 15660.4 ± 0.4% | 1458.9 ± 0.2% | 1082.6 ± 0.3% | 500.1 ± 1.0% | 993.7 ± 0.5% | 732.6 ± 0.2% | 10.734 | 14.466 | 31.317 | 15.760 | 21.376 |
| hex: silesia/mozilla | 524290 | 15665.0 ± 0.5% | 1470.5 ± 0.2% | 1089.3 ± 0.3% | 439.9 ± 0.7% | 992.4 ± 1.1% | 733.8 ± 0.4% | 10.653 | 14.381 | 35.609 | 15.784 | 21.349 |
| hex: silesia/mr | 524290 | 15631.8 ± 0.5% | 1478.8 ± 1.2% | 1093.6 ± 0.4% | 549.0 ± 2.5% | 997.8 ± 0.7% | 733.6 ± 0.4% | 10.571 | 14.294 | 28.474 | 15.667 | 21.309 |
| hex: silesia/nci | 524290 | 15620.2 ± 0.5% | 1466.7 ± 0.2% | 1089.5 ± 0.3% | 637.6 ± 4.0% | 990.7 ± 0.5% | 731.3 ± 0.4% | 10.650 | 14.337 | 24.499 | 15.767 | 21.360 |
| hex: silesia/ooffice | 524290 | 15611.1 ± 0.8% | 1463.6 ± 0.2% | 1085.6 ± 0.2% | 389.3 ± 0.4% | 988.0 ± 0.3% | 733.3 ± 0.4% | 10.666 | 14.380 | 40.103 | 15.800 | 21.290 |
| hex: silesia/osdb | 524290 | 15615.2 ± 0.3% | 1465.5 ± 0.5% | 1083.9 ± 0.6% | 465.1 ± 0.5% | 992.3 ± 0.8% | 733.1 ± 0.4% | 10.655 | 14.407 | 33.571 | 15.736 | 21.301 |
| hex: silesia/reymont | 524290 | 15645.9 ± 0.3% | 1460.5 ± 0.6% | 1086.4 ± 0.3% | 515.9 ± 1.0% | 991.7 ± 0.6% | 733.4 ± 0.3% | 10.713 | 14.402 | 30.328 | 15.776 | 21.334 |
| hex: silesia/samba | 524290 | 15672.8 ± 0.1% | 1464.8 ± 0.4% | 1084.3 ± 0.4% | 402.1 ± 0.2% | 989.9 ± 0.4% | 732.3 ± 0.4% | 10.699 | 14.454 | 38.980 | 15.833 | 21.404 |
| hex: silesia/sao | 524290 | 15669.3 ± 0.5% | 1462.9 ± 0.3% | 1084.3 ± 0.4% | 332.2 ± 0.4% | 992.3 ± 0.6% | 734.0 ± 0.6% | 10.711 | 14.451 | 47.168 | 15.791 | 21.348 |
| hex: silesia/webster | 524290 | 15656.3 ± 0.3% | 1458.5 ± 0.6% | 1083.6 ± 0.4% | 474.1 ± 0.5% | 988.3 ± 0.5% | 731.8 ± 0.7% | 10.735 | 14.448 | 33.022 | 15.841 | 21.394 |
| hex: silesia/x-ray | 524290 | 15585.8 ± 0.6% | 1475.3 ± 0.1% | 1090.9 ± 0.5% | 446.8 ± 1.1% | 996.6 ± 0.4% | 732.9 ± 0.3% | 10.564 | 14.287 | 34.881 | 15.640 | 21.267 |
| hex: silesia/xml | 524290 | 15612.8 ± 0.2% | 1468.2 ± 0.2% | 1085.4 ± 0.3% | 612.3 ± 0.6% | 988.4 ± 0.6% | 733.2 ± 0.2% | 10.634 | 14.385 | 25.501 | 15.796 | 21.295 |
| hex: canterbury/alice29.txt | 304180 | 15616.1 ± 0.2% | 1465.9 ± 0.7% | 1090.2 ± 0.2% | 504.5 ± 1.5% | 995.8 ± 0.7% | 732.9 ± 0.8% | 10.653 | 14.324 | 30.951 | 15.681 | 21.306 |
| hex: canterbury/asyoulik.txt | 250360 | 15721.8 ± 0.0% | 1475.8 ± 0.2% | 1090.2 ± 0.5% | 499.4 ± 1.2% | 994.7 ± 0.5% | 738.9 ± 0.3% | 10.653 | 14.421 | 31.480 | 15.806 | 21.276 |
| hex: canterbury/cp.html | 49208 | 15622.9 ± 0.1% | 1473.1 ± 0.2% | 1097.8 ± 0.2% | 520.9 ± 2.7% | 1001.2 ± 0.4% | 743.7 ± 0.1% | 10.605 | 14.232 | 29.991 | 15.605 | 21.006 |
| hex: canterbury/fields.c | 22302 | 15457.5 ± 0.0% | 1440.2 ± 0.2% | 1062.1 ± 0.7% | 636.0 ± 7.4% | 986.6 ± 0.3% | 737.4 ± 0.1% | 10.733 | 14.554 | 24.305 | 15.668 | 20.961 |
| hex: canterbury/grammar.lsp | 7444 | 14985.7 ± 0.4% | 1506.2 ± 0.3% | 1094.6 ± 0.3% | 674.6 ± 7.7% | 987.2 ± 0.2% | 725.8 ± 0.1% | 9.950 | 13.691 | 22.214 | 15.180 | 20.647 |
| hex: canterbury/kennedy.xls | 524290 | 15669.2 ± 0.2% | 1472.3 ± 0.2% | 1088.8 ± 0.4% | 643.7 ± 3.2% | 990.8 ± 0.2% | 733.7 ± 0.3% | 10.643 | 14.391 | 24.343 | 15.815 | 21.356 |
| hex: canterbury/lcet10.txt | 524290 | 15592.6 ± 0.1% | 1466.7 ± 0.3% | 1084.8 ± 0.3% | 502.6 ± 3.1% | 993.2 ± 0.8% | 733.1 ± 0.4% | 10.631 | 14.374 | 31.023 | 15.699 | 21.270 |
| hex: canterbury/plrabn12.txt | 524290 | 15633.4 ± 0.5% | 1462.9 ± 0.2% | 1083.5 ± 0.6% | 491.0 ± 1.5% | 986.7 ± 0.5% | 734.0 ± 0.5% | 10.686 | 14.429 | 31.838 | 15.845 | 21.299 |
| hex: canterbury/ptt5 | 524290 | 15630.2 ± 0.3% | 1479.6 ± 0.4% | 1093.6 ± 0.3% | 555.4 ± 0.3% | 994.6 ± 0.7% | 735.3 ± 0.8% | 10.564 | 14.292 | 28.143 | 15.714 | 21.258 |
| hex: canterbury/sum | 76482 | 15655.2 ± 0.0% | 1494.5 ± 0.1% | 1104.0 ± 0.4% | 597.7 ± 0.4% | 998.2 ± 0.1% | 744.4 ± 0.1% | 10.475 | 14.181 | 26.191 | 15.683 | 21.030 |
| hex: canterbury/xargs.1 | 8456 | 15021.5 ± 0.0% | 1493.9 ± 0.5% | 1096.7 ± 0.4% | 660.1 ± 4.6% | 973.7 ± 0.1% | 728.4 ± 0.7% | 10.055 | 13.697 | 22.755 | 15.427 | 20.622 |
| hex: canterbury-large/E.coli | 524290 | 15633.2 ± 0.3% | 1472.4 ± 0.7% | 1088.6 ± 0.7% | 672.3 ± 0.4% | 991.5 ± 0.4% | 733.8 ± 0.3% | 10.618 | 14.360 | 23.254 | 15.767 | 21.303 |
| hex: canterbury-large/bible.txt | 524290 | 15634.9 ± 0.7% | 1462.3 ± 0.3% | 1083.7 ± 0.5% | 511.5 ± 1.2% | 984.3 ± 0.7% | 734.6 ± 0.4% | 10.692 | 14.427 | 30.567 | 15.884 | 21.284 |
| hex: canterbury-large/world192.txt | 524290 | 15593.1 ± 1.2% | 1464.0 ± 0.6% | 1084.0 ± 0.4% | 502.2 ± 0.7% | 988.7 ± 0.4% | 733.0 ± 0.4% | 10.651 | 14.385 | 31.047 | 15.771 | 21.274 |
| hex: http/html-1kx1024 | 2099200 | 13753.8 ± 0.5% | 1455.7 ± 0.1% | 1061.7 ± 0.6% | 501.4 ± 0.2% | 982.8 ± 0.2% | 692.8 ± 0.1% | 9.448 | 12.955 | 27.432 | 13.995 | 19.851 |
| hex: http/html-16kx64 | 2097280 | 15233.7 ± 0.6% | 1442.1 ± 0.2% | 1074.5 ± 0.5% | 506.5 ± 0.2% | 996.2 ± 0.1% | 735.2 ± 0.1% | 10.563 | 14.177 | 30.077 | 15.291 | 20.720 |
| hex: http/html-1m | 524290 | 15617.8 ± 0.5% | 1468.1 ± 0.2% | 1086.4 ± 0.4% | 500.2 ± 0.3% | 990.6 ± 0.3% | 733.8 ± 0.4% | 10.638 | 14.376 | 31.223 | 15.766 | 21.284 |
| hex: http/json-1kx1024 | 2099200 | 13749.7 ± 1.1% | 1463.9 ± 0.2% | 1067.1 ± 0.1% | 608.9 ± 0.3% | 987.8 ± 0.2% | 692.8 ± 0.3% | 9.392 | 12.885 | 22.583 | 13.920 | 19.846 |
| hex: http/json-16kx64 | 2097280 | 15269.9 ± 0.8% | 1446.5 ± 0.2% | 1074.5 ± 0.2% | 616.3 ± 0.5% | 994.7 ± 0.4% | 735.3 ± 0.1% | 10.556 | 14.211 | 24.778 | 15.351 | 20.766 |
| hex: http/json-1m | 524290 | 15650.0 ± 0.2% | 1470.1 ± 0.3% | 1087.2 ± 0.1% | 629.0 ± 1.0% | 992.8 ± 0.2% | 734.1 ± 0.1% | 10.645 | 14.395 | 24.880 | 15.763 | 21.318 |
| hex: http/js-1kx1024 | 2099200 | 13814.8 ± 0.2% | 1455.6 ± 0.2% | 1062.4 ± 0.1% | 498.5 ± 0.1% | 982.8 ± 0.1% | 693.1 ± 0.1% | 9.491 | 13.003 | 27.715 | 14.056 | 19.932 |
| hex: http/js-16kx64 | 2097280 | 15257.5 ± 0.6% | 1443.6 ± 0.2% | 1075.6 ± 0.1% | 503.8 ± 0.4% | 998.1 ± 0.4% | 735.1 ± 0.1% | 10.569 | 14.185 | 30.284 | 15.287 | 20.757 |
| hex: http/js-1m | 524290 | 15681.6 ± 0.4% | 1464.4 ± 0.2% | 1085.2 ± 0.6% | 509.5 ± 0.6% | 990.7 ± 0.3% | 732.5 ± 0.5% | 10.708 | 14.450 | 30.781 | 15.829 | 21.407 |
| hex: http/css-1kx1024 | 2099200 | 13794.5 ± 1.2% | 1456.3 ± 0.1% | 1062.8 ± 0.2% | 531.3 ± 0.3% | 983.3 ± 0.1% | 692.5 ± 0.1% | 9.473 | 12.980 | 25.962 | 14.029 | 19.919 |
| hex: http/css-16kx64 | 2097280 | 15219.5 ± 0.5% | 1444.4 ± 0.1% | 1076.4 ± 0.7% | 541.4 ± 0.5% | 997.9 ± 0.6% | 735.1 ± 0.5% | 10.537 | 14.139 | 28.110 | 15.251 | 20.703 |
| hex: http/css-1m | 524290 | 15681.3 ± 1.1% | 1461.4 ± 0.3% | 1082.9 ± 0.6% | 527.4 ± 0.4% | 989.9 ± 0.3% | 733.4 ± 0.9% | 10.731 | 14.481 | 29.733 | 15.841 | 21.382 |
| hex: shuffled/dickens-1m | 524290 | 15676.5 ± 0.6% | 1461.4 ± 0.3% | 1086.9 ± 0.4% | 502.9 ± 0.8% | 991.7 ± 0.3% | 733.4 ± 0.3% | 10.727 | 14.424 | 31.170 | 15.808 | 21.375 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.6 ± 0.1% | 930.9 ± 1.3% | 1021.0 ± 0.3% | 300.2 ± 0.9% | 665.8 ± 0.5% | 308.8 ± 1.6% | 1.007 | 0.918 | 3.123 | 1.408 | 3.036 |
| qlog records, JSON text sequence | 1467503 | 779.0 ± 0.6% | 817.4 ± 0.1% | 770.4 ± 0.5% | 242.9 ± 1.3% | 698.0 ± 0.5% | 248.6 ± 3.1% | 0.953 | 1.011 | 3.208 | 1.116 | 3.134 |
| string: silesia/dickens | 172528 | 5052.3 ± 0.4% | 1878.8 ± 0.2% | 2650.5 ± 0.7% | 361.0 ± 1.2% | 2872.0 ± 0.2% | 551.4 ± 2.3% | 2.689 | 1.906 | 13.996 | 1.759 | 9.162 |
| string: silesia/nci | 1075110 | 4314.8 ± 0.4% | 2236.8 ± 0.2% | 2993.7 ± 0.3% | 545.5 ± 1.3% | 2985.1 ± 0.9% | 589.8 ± 4.9% | 1.929 | 1.441 | 7.910 | 1.445 | 7.316 |
| string: silesia/reymont | 1075159 | 2973.7 ± 2.7% | 1815.2 ± 2.0% | 2062.2 ± 0.4% | 374.4 ± 0.6% | 2156.9 ± 0.7% | 534.1 ± 0.6% | 1.638 | 1.442 | 7.943 | 1.379 | 5.567 |
| string: silesia/samba | 97582 | 3502.8 ± 0.3% | 2027.2 ± 0.1% | 2616.4 ± 0.3% | 323.0 ± 0.3% | 1495.6 ± 0.8% | 427.9 ± 1.3% | 1.728 | 1.339 | 10.844 | 2.342 | 8.186 |
| string: silesia/webster | 1098490 | 3671.0 ± 0.9% | 1518.8 ± 0.3% | 2011.3 ± 0.4% | 359.5 ± 0.3% | 2181.4 ± 1.1% | 499.3 ± 1.1% | 2.417 | 1.825 | 10.213 | 1.683 | 7.352 |
| string: silesia/xml | 1090118 | 4791.3 ± 0.6% | 2356.8 ± 0.4% | 2524.6 ± 0.4% | 454.3 ± 0.9% | 2802.6 ± 0.8% | 563.4 ± 1.0% | 2.033 | 1.898 | 10.547 | 1.710 | 8.504 |
| string: canterbury/alice29.txt | 159425 | 4372.8 ± 1.8% | 1600.8 ± 0.3% | 2453.5 ± 0.5% | 342.5 ± 0.4% | 2515.3 ± 0.4% | 503.0 ± 1.0% | 2.732 | 1.782 | 12.766 | 1.738 | 8.693 |
| string: canterbury/asyoulik.txt | 132198 | 3499.1 ± 0.9% | 1458.7 ± 0.1% | 2241.2 ± 1.3% | 335.1 ± 0.8% | 2091.4 ± 0.1% | 455.0 ± 0.7% | 2.399 | 1.561 | 10.441 | 1.673 | 7.690 |
| string: canterbury/lcet10.txt | 441884 | 5138.3 ± 0.4% | 1852.3 ± 0.2% | 2340.2 ± 0.9% | 391.0 ± 0.4% | 2838.8 ± 0.7% | 529.9 ± 3.0% | 2.774 | 2.196 | 13.141 | 1.810 | 9.696 |
| string: canterbury/plrabn12.txt | 503330 | 4127.9 ± 0.5% | 1736.6 ± 0.2% | 2057.1 ± 0.4% | 361.4 ± 0.9% | 2456.1 ± 0.9% | 497.1 ± 1.2% | 2.377 | 2.007 | 11.421 | 1.681 | 8.304 |
| string: canterbury-large/E.coli | 1048578 | 11894.8 ± 0.3% | 3601.8 ± 0.2% | 3252.0 ± 0.2% | 931.5 ± 0.2% | 5992.2 ± 0.5% | 740.9 ± 2.0% | 3.302 | 3.658 | 12.769 | 1.985 | 16.054 |
| string: canterbury-large/bible.txt | 1055886 | 6890.8 ± 1.7% | 2933.1 ± 0.7% | 2825.3 ± 0.7% | 423.3 ± 1.8% | 3759.8 ± 0.7% | 615.5 ± 0.9% | 2.349 | 2.439 | 16.277 | 1.833 | 11.196 |
| string: canterbury-large/world192.txt | 1103121 | 3396.9 ± 0.3% | 1482.8 ± 0.2% | 2009.8 ± 0.6% | 353.8 ± 0.6% | 2113.6 ± 1.0% | 497.9 ± 0.7% | 2.291 | 1.690 | 9.601 | 1.607 | 6.823 |
| string: http/html-1m | 1058582 | 6223.8 ± 1.7% | 2732.2 ± 0.5% | 2699.7 ± 1.0% | 441.1 ± 0.5% | 3479.2 ± 1.3% | 596.8 ± 4.6% | 2.278 | 2.305 | 14.111 | 1.789 | 10.428 |
| string: http/json-1m | 1190272 | 2553.0 ± 0.4% | 876.8 ± 0.9% | 2248.8 ± 1.5% | 390.7 ± 0.4% | 1050.1 ± 3.5% | 441.3 ± 0.4% | 2.912 | 1.135 | 6.534 | 2.431 | 5.785 |
| string: http/js-1m | 1144362 | 2287.5 ± 0.5% | 1027.8 ± 0.2% | 1640.7 ± 0.5% | 320.9 ± 0.3% | 1506.6 ± 0.5% | 418.5 ± 0.8% | 2.226 | 1.394 | 7.128 | 1.518 | 5.466 |
| string: http/css-1m | 1097820 | 2654.4 ± 0.3% | 1677.4 ± 0.4% | 2225.0 ± 0.6% | 407.3 ± 1.1% | 1902.6 ± 2.2% | 486.4 ± 1.0% | 1.582 | 1.193 | 6.517 | 1.395 | 5.458 |
| string: dickens as Cyrillic and CJK | 1883069 | 3079.9 ± 0.3% | 1686.8 ± 0.3% | 893.6 ± 0.4% | 351.1 ± 0.2% | 668.2 ± 0.5% | 156.4 ± 3.2% | 1.826 | 3.447 | 8.772 | 4.609 | 19.693 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.2 ± 0.3% | 980.8 ± 0.4% | 1200.0 ± 0.5% | 213.4 ± 0.2% | 472.9 ± 1.3% | 251.6 ± 4.0% | 1.355 | 1.108 | 6.229 | 2.811 | 5.283 |
| hex: silesia/dickens | 524290 | 11953.8 ± 0.1% | 3618.4 ± 0.2% | 3281.0 ± 0.1% | 513.3 ± 2.0% | 5980.5 ± 0.9% | 779.3 ± 2.9% | 3.304 | 3.643 | 23.289 | 1.999 | 15.340 |
| hex: silesia/mozilla | 524290 | 12006.6 ± 0.3% | 3616.9 ± 0.1% | 3303.0 ± 0.2% | 451.6 ± 1.8% | 6101.4 ± 1.4% | 781.4 ± 0.6% | 3.320 | 3.635 | 26.588 | 1.968 | 15.366 |
| hex: silesia/mr | 524290 | 12010.6 ± 0.1% | 3614.1 ± 0.2% | 3299.1 ± 0.3% | 568.6 ± 0.7% | 6116.9 ± 2.0% | 780.7 ± 0.4% | 3.323 | 3.641 | 21.124 | 1.964 | 15.385 |
| hex: silesia/nci | 524290 | 11998.5 ± 0.1% | 3616.5 ± 0.2% | 3279.4 ± 0.3% | 623.9 ± 0.3% | 6119.3 ± 2.1% | 780.3 ± 0.5% | 3.318 | 3.659 | 19.233 | 1.961 | 15.376 |
| hex: silesia/ooffice | 524290 | 11995.8 ± 0.1% | 3616.2 ± 0.2% | 3288.7 ± 0.2% | 396.4 ± 0.8% | 6138.5 ± 0.5% | 778.8 ± 0.4% | 3.317 | 3.648 | 30.259 | 1.954 | 15.403 |
| hex: silesia/osdb | 524290 | 12018.3 ± 0.2% | 3617.9 ± 0.2% | 3293.1 ± 0.2% | 475.8 ± 1.4% | 6077.4 ± 0.9% | 780.8 ± 0.6% | 3.322 | 3.650 | 25.258 | 1.978 | 15.393 |
| hex: silesia/reymont | 524290 | 12014.5 ± 0.1% | 3615.8 ± 0.1% | 3293.5 ± 0.2% | 519.2 ± 1.7% | 6141.0 ± 1.7% | 780.6 ± 1.1% | 3.323 | 3.648 | 23.142 | 1.956 | 15.392 |
| hex: silesia/samba | 524290 | 12000.3 ± 0.1% | 3613.8 ± 0.3% | 3292.2 ± 0.4% | 410.4 ± 2.0% | 6133.0 ± 0.8% | 777.8 ± 0.8% | 3.321 | 3.645 | 29.242 | 1.957 | 15.430 |
| hex: silesia/sao | 524290 | 11925.6 ± 0.1% | 3614.4 ± 0.2% | 3284.9 ± 0.4% | 345.6 ± 1.3% | 6102.6 ± 1.6% | 780.4 ± 0.8% | 3.299 | 3.630 | 34.503 | 1.954 | 15.281 |
| hex: silesia/webster | 524290 | 12013.0 ± 0.1% | 3617.5 ± 0.4% | 3284.0 ± 0.5% | 473.0 ± 1.8% | 6139.0 ± 1.3% | 782.3 ± 0.5% | 3.321 | 3.658 | 25.398 | 1.957 | 15.357 |
| hex: silesia/x-ray | 524290 | 12001.5 ± 0.1% | 3618.3 ± 0.3% | 3289.7 ± 0.2% | 475.9 ± 2.2% | 6106.4 ± 2.7% | 782.6 ± 0.6% | 3.317 | 3.648 | 25.219 | 1.965 | 15.335 |
| hex: silesia/xml | 524290 | 12016.2 ± 0.1% | 3616.3 ± 0.2% | 3291.4 ± 0.2% | 531.4 ± 0.8% | 6128.0 ± 1.4% | 780.2 ± 0.3% | 3.323 | 3.651 | 22.611 | 1.961 | 15.401 |
| hex: canterbury/alice29.txt | 304180 | 12011.4 ± 0.1% | 3626.9 ± 0.2% | 3334.9 ± 0.3% | 523.7 ± 0.6% | 6115.2 ± 0.9% | 779.5 ± 1.3% | 3.312 | 3.602 | 22.936 | 1.964 | 15.410 |
| hex: canterbury/asyoulik.txt | 250360 | 11999.5 ± 0.2% | 3632.6 ± 0.2% | 3370.4 ± 0.1% | 517.2 ± 0.3% | 6115.1 ± 0.6% | 776.4 ± 1.1% | 3.303 | 3.560 | 23.202 | 1.962 | 15.455 |
| hex: canterbury/cp.html | 49208 | 11928.6 ± 0.2% | 3638.5 ± 0.1% | 3292.2 ± 0.3% | 469.8 ± 0.9% | 6211.1 ± 1.9% | 762.5 ± 2.0% | 3.278 | 3.623 | 25.393 | 1.921 | 15.644 |
| hex: canterbury/fields.c | 22302 | 11788.3 ± 0.0% | 3629.6 ± 0.0% | 3352.6 ± 0.0% | 499.5 ± 0.4% | 6252.8 ± 0.2% | 759.7 ± 2.6% | 3.248 | 3.516 | 23.598 | 1.885 | 15.516 |
| hex: canterbury/grammar.lsp | 7444 | 11280.6 ± 0.2% | 3601.1 ± 0.0% | 3356.9 ± 0.2% | 541.0 ± 1.6% | 6177.4 ± 0.5% | 723.8 ± 5.3% | 3.133 | 3.360 | 20.851 | 1.826 | 15.586 |
| hex: canterbury/kennedy.xls | 524290 | 11948.7 ± 0.2% | 3620.6 ± 0.5% | 3279.1 ± 0.4% | 657.2 ± 4.9% | 6072.4 ± 1.0% | 774.5 ± 5.1% | 3.300 | 3.644 | 18.182 | 1.968 | 15.428 |
| hex: canterbury/lcet10.txt | 524290 | 12022.1 ± 0.1% | 3619.6 ± 0.2% | 3285.9 ± 0.2% | 513.5 ± 1.3% | 6139.6 ± 1.4% | 779.5 ± 0.6% | 3.321 | 3.659 | 23.413 | 1.958 | 15.424 |
| hex: canterbury/plrabn12.txt | 524290 | 11959.2 ± 0.1% | 3619.1 ± 0.1% | 3288.5 ± 0.5% | 504.2 ± 0.4% | 6048.8 ± 1.0% | 781.5 ± 0.3% | 3.304 | 3.637 | 23.718 | 1.977 | 15.304 |
| hex: canterbury/ptt5 | 524290 | 11969.8 ± 0.1% | 3617.1 ± 0.1% | 3291.0 ± 0.3% | 558.5 ± 0.2% | 5995.8 ± 1.1% | 780.9 ± 0.3% | 3.309 | 3.637 | 21.431 | 1.996 | 15.329 |
| hex: canterbury/sum | 76482 | 11918.9 ± 0.2% | 3633.8 ± 0.0% | 3356.0 ± 0.3% | 509.9 ± 0.9% | 6185.2 ± 0.5% | 770.8 ± 0.8% | 3.280 | 3.552 | 23.373 | 1.927 | 15.463 |
| hex: canterbury/xargs.1 | 8456 | 11361.4 ± 0.1% | 3602.6 ± 0.0% | 3378.7 ± 0.3% | 488.9 ± 1.5% | 6153.6 ± 0.2% | 755.4 ± 1.4% | 3.154 | 3.363 | 23.238 | 1.846 | 15.041 |
| hex: canterbury-large/E.coli | 524290 | 12018.9 ± 0.1% | 3609.6 ± 0.3% | 3285.5 ± 0.5% | 688.8 ± 0.2% | 6156.8 ± 1.9% | 775.3 ± 5.8% | 3.330 | 3.658 | 17.449 | 1.952 | 15.502 |
| hex: canterbury-large/bible.txt | 524290 | 11983.7 ± 0.1% | 3613.3 ± 0.2% | 3295.0 ± 0.3% | 521.3 ± 1.1% | 6083.7 ± 1.6% | 781.8 ± 0.5% | 3.317 | 3.637 | 22.986 | 1.970 | 15.329 |
| hex: canterbury-large/world192.txt | 524290 | 11951.0 ± 0.2% | 3613.5 ± 0.1% | 3278.2 ± 0.3% | 495.5 ± 0.7% | 6016.7 ± 1.1% | 778.6 ± 0.3% | 3.307 | 3.646 | 24.121 | 1.986 | 15.350 |
| hex: http/html-1kx1024 | 2099200 | 8665.0 ± 4.1% | 3458.8 ± 0.1% | 2842.5 ± 0.2% | 474.6 ± 0.4% | 5072.4 ± 1.0% | 642.1 ± 4.4% | 2.505 | 3.048 | 18.258 | 1.708 | 13.496 |
| hex: http/html-16kx64 | 2097280 | 11743.7 ± 0.2% | 3607.1 ± 0.1% | 3268.4 ± 0.2% | 479.2 ± 0.6% | 5997.0 ± 0.3% | 757.8 ± 1.1% | 3.256 | 3.593 | 24.509 | 1.958 | 15.497 |
| hex: http/html-1m | 524290 | 11955.8 ± 0.1% | 3608.0 ± 0.1% | 3284.6 ± 0.3% | 498.8 ± 0.8% | 6095.8 ± 1.8% | 780.4 ± 2.8% | 3.314 | 3.640 | 23.970 | 1.961 | 15.320 |
| hex: http/json-1kx1024 | 2099200 | 8574.1 ± 13.9% | 3461.1 ± 0.7% | 2831.7 ± 8.8% | 575.0 ± 0.2% | 5123.4 ± 1.0% | 629.5 ± 2.1% | 2.477 | 3.028 | 14.911 | 1.674 | 13.620 |
| hex: http/json-16kx64 | 2097280 | 11752.3 ± 0.2% | 3607.5 ± 0.1% | 3244.7 ± 0.2% | 573.4 ± 0.9% | 6021.0 ± 0.6% | 745.3 ± 1.3% | 3.258 | 3.622 | 20.496 | 1.952 | 15.768 |
| hex: http/json-1m | 524290 | 11963.8 ± 0.1% | 3610.1 ± 0.1% | 3283.1 ± 0.3% | 593.8 ± 0.9% | 6058.3 ± 1.7% | 763.2 ± 2.2% | 3.314 | 3.644 | 20.149 | 1.975 | 15.676 |
| hex: http/js-1kx1024 | 2099200 | 8669.8 ± 4.7% | 3460.0 ± 0.1% | 2832.5 ± 0.6% | 478.8 ± 0.4% | 5082.3 ± 0.7% | 624.1 ± 1.7% | 2.506 | 3.061 | 18.106 | 1.706 | 13.892 |
| hex: http/js-16kx64 | 2097280 | 11757.8 ± 0.2% | 3609.2 ± 0.1% | 3259.1 ± 0.4% | 480.4 ± 1.2% | 6011.7 ± 0.7% | 751.5 ± 2.8% | 3.258 | 3.608 | 24.476 | 1.956 | 15.645 |
| hex: http/js-1m | 524290 | 11949.0 ± 0.2% | 3616.6 ± 0.2% | 3290.9 ± 0.3% | 495.8 ± 2.2% | 5953.5 ± 0.8% | 780.7 ± 4.0% | 3.304 | 3.631 | 24.100 | 2.007 | 15.305 |
| hex: http/css-1kx1024 | 2099200 | 8618.6 ± 4.6% | 3459.3 ± 0.1% | 2834.3 ± 0.3% | 486.0 ± 0.6% | 5070.9 ± 0.9% | 629.1 ± 2.0% | 2.491 | 3.041 | 17.735 | 1.700 | 13.699 |
| hex: http/css-16kx64 | 2097280 | 11744.6 ± 0.1% | 3609.0 ± 0.1% | 3256.4 ± 0.5% | 495.0 ± 0.2% | 6015.2 ± 0.9% | 749.8 ± 2.6% | 3.254 | 3.607 | 23.728 | 1.952 | 15.663 |
| hex: http/css-1m | 524290 | 12018.8 ± 0.0% | 3621.9 ± 0.1% | 3285.0 ± 0.2% | 492.8 ± 0.9% | 6105.9 ± 1.4% | 772.3 ± 2.2% | 3.318 | 3.659 | 24.391 | 1.968 | 15.563 |
| hex: shuffled/dickens-1m | 524290 | 11937.5 ± 0.1% | 3615.9 ± 0.2% | 3281.3 ± 0.4% | 510.1 ± 0.7% | 6026.0 ± 1.2% | 782.2 ± 0.4% | 3.301 | 3.638 | 23.404 | 1.981 | 15.261 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1013.8 ± 0.1% | 930.9 ± 1.3% | 1021.0 ± 0.3% | 300.2 ± 0.9% | 665.8 ± 0.5% | 308.8 ± 1.6% | 1.089 | 0.993 | 3.377 | 1.523 | 3.283 |
| qlog records, JSON text sequence | 1467503 | 836.4 ± 1.0% | 817.4 ± 0.1% | 770.4 ± 0.5% | 242.9 ± 1.3% | 698.0 ± 0.5% | 248.6 ± 3.1% | 1.023 | 1.086 | 3.444 | 1.198 | 3.365 |
| string: silesia/dickens | 172528 | 5055.2 ± 0.3% | 1878.8 ± 0.2% | 2650.5 ± 0.7% | 361.0 ± 1.2% | 2872.0 ± 0.2% | 551.4 ± 2.3% | 2.691 | 1.907 | 14.004 | 1.760 | 9.167 |
| string: silesia/nci | 1075110 | 4309.5 ± 0.2% | 2236.8 ± 0.2% | 2993.7 ± 0.3% | 545.5 ± 1.3% | 2985.1 ± 0.9% | 589.8 ± 4.9% | 1.927 | 1.440 | 7.900 | 1.444 | 7.306 |
| string: silesia/reymont | 1075159 | 2986.4 ± 2.6% | 1815.2 ± 2.0% | 2062.2 ± 0.4% | 374.4 ± 0.6% | 2156.9 ± 0.7% | 534.1 ± 0.6% | 1.645 | 1.448 | 7.977 | 1.385 | 5.591 |
| string: silesia/samba | 97582 | 3510.5 ± 0.3% | 2027.2 ± 0.1% | 2616.4 ± 0.3% | 323.0 ± 0.3% | 1495.6 ± 0.8% | 427.9 ± 1.3% | 1.732 | 1.342 | 10.868 | 2.347 | 8.204 |
| string: silesia/webster | 1098490 | 3673.8 ± 0.5% | 1518.8 ± 0.3% | 2011.3 ± 0.4% | 359.5 ± 0.3% | 2181.4 ± 1.1% | 499.3 ± 1.1% | 2.419 | 1.827 | 10.220 | 1.684 | 7.358 |
| string: silesia/xml | 1090118 | 4799.2 ± 0.3% | 2356.8 ± 0.4% | 2524.6 ± 0.4% | 454.3 ± 0.9% | 2802.6 ± 0.8% | 563.4 ± 1.0% | 2.036 | 1.901 | 10.564 | 1.712 | 8.518 |
| string: canterbury/alice29.txt | 159425 | 4375.7 ± 1.7% | 1600.8 ± 0.3% | 2453.5 ± 0.5% | 342.5 ± 0.4% | 2515.3 ± 0.4% | 503.0 ± 1.0% | 2.733 | 1.783 | 12.774 | 1.740 | 8.699 |
| string: canterbury/asyoulik.txt | 132198 | 3499.4 ± 0.3% | 1458.7 ± 0.1% | 2241.2 ± 1.3% | 335.1 ± 0.8% | 2091.4 ± 0.1% | 455.0 ± 0.7% | 2.399 | 1.561 | 10.442 | 1.673 | 7.691 |
| string: canterbury/lcet10.txt | 441884 | 5133.6 ± 0.4% | 1852.3 ± 0.2% | 2340.2 ± 0.9% | 391.0 ± 0.4% | 2838.8 ± 0.7% | 529.9 ± 3.0% | 2.771 | 2.194 | 13.130 | 1.808 | 9.688 |
| string: canterbury/plrabn12.txt | 503330 | 4127.1 ± 0.6% | 1736.6 ± 0.2% | 2057.1 ± 0.4% | 361.4 ± 0.9% | 2456.1 ± 0.9% | 497.1 ± 1.2% | 2.377 | 2.006 | 11.419 | 1.680 | 8.302 |
| string: canterbury-large/E.coli | 1048578 | 11908.1 ± 0.3% | 3601.8 ± 0.2% | 3252.0 ± 0.2% | 931.5 ± 0.2% | 5992.2 ± 0.5% | 740.9 ± 2.0% | 3.306 | 3.662 | 12.784 | 1.987 | 16.072 |
| string: canterbury-large/bible.txt | 1055886 | 6897.0 ± 2.0% | 2933.1 ± 0.7% | 2825.3 ± 0.7% | 423.3 ± 1.8% | 3759.8 ± 0.7% | 615.5 ± 0.9% | 2.351 | 2.441 | 16.292 | 1.834 | 11.206 |
| string: canterbury-large/world192.txt | 1103121 | 3393.4 ± 0.4% | 1482.8 ± 0.2% | 2009.8 ± 0.6% | 353.8 ± 0.6% | 2113.6 ± 1.0% | 497.9 ± 0.7% | 2.289 | 1.688 | 9.591 | 1.605 | 6.816 |
| string: http/html-1m | 1058582 | 6264.1 ± 1.9% | 2732.2 ± 0.5% | 2699.7 ± 1.0% | 441.1 ± 0.5% | 3479.2 ± 1.3% | 596.8 ± 4.6% | 2.293 | 2.320 | 14.202 | 1.800 | 10.496 |
| string: http/json-1m | 1190272 | 2556.0 ± 0.4% | 876.8 ± 0.9% | 2248.8 ± 1.5% | 390.7 ± 0.4% | 1050.1 ± 3.5% | 441.3 ± 0.4% | 2.915 | 1.137 | 6.542 | 2.434 | 5.792 |
| string: http/js-1m | 1144362 | 2291.9 ± 0.6% | 1027.8 ± 0.2% | 1640.7 ± 0.5% | 320.9 ± 0.3% | 1506.6 ± 0.5% | 418.5 ± 0.8% | 2.230 | 1.397 | 7.141 | 1.521 | 5.477 |
| string: http/css-1m | 1097820 | 2658.7 ± 0.5% | 1677.4 ± 0.4% | 2225.0 ± 0.6% | 407.3 ± 1.1% | 1902.6 ± 2.2% | 486.4 ± 1.0% | 1.585 | 1.195 | 6.527 | 1.397 | 5.466 |
| string: dickens as Cyrillic and CJK | 1883069 | 3076.5 ± 0.6% | 1686.8 ± 0.3% | 893.6 ± 0.4% | 351.1 ± 0.2% | 668.2 ± 0.5% | 156.4 ± 3.2% | 1.824 | 3.443 | 8.763 | 4.604 | 19.672 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.0 ± 0.1% | 980.8 ± 0.4% | 1200.0 ± 0.5% | 213.4 ± 0.2% | 472.9 ± 1.3% | 251.6 ± 4.0% | 1.356 | 1.108 | 6.233 | 2.813 | 5.286 |
| hex: silesia/dickens | 524290 | 11980.5 ± 0.2% | 3618.4 ± 0.2% | 3281.0 ± 0.1% | 513.3 ± 2.0% | 5980.5 ± 0.9% | 779.3 ± 2.9% | 3.311 | 3.651 | 23.341 | 2.003 | 15.374 |
| hex: silesia/mozilla | 524290 | 12009.2 ± 0.1% | 3616.9 ± 0.1% | 3303.0 ± 0.2% | 451.6 ± 1.8% | 6101.4 ± 1.4% | 781.4 ± 0.6% | 3.320 | 3.636 | 26.594 | 1.968 | 15.370 |
| hex: silesia/mr | 524290 | 12017.2 ± 0.1% | 3614.1 ± 0.2% | 3299.1 ± 0.3% | 568.6 ± 0.7% | 6116.9 ± 2.0% | 780.7 ± 0.4% | 3.325 | 3.643 | 21.136 | 1.965 | 15.393 |
| hex: silesia/nci | 524290 | 12001.2 ± 0.1% | 3616.5 ± 0.2% | 3279.4 ± 0.3% | 623.9 ± 0.3% | 6119.3 ± 2.1% | 780.3 ± 0.5% | 3.318 | 3.660 | 19.237 | 1.961 | 15.380 |
| hex: silesia/ooffice | 524290 | 11998.8 ± 0.1% | 3616.2 ± 0.2% | 3288.7 ± 0.2% | 396.4 ± 0.8% | 6138.5 ± 0.5% | 778.8 ± 0.4% | 3.318 | 3.649 | 30.267 | 1.955 | 15.407 |
| hex: silesia/osdb | 524290 | 12011.0 ± 0.1% | 3617.9 ± 0.2% | 3293.1 ± 0.2% | 475.8 ± 1.4% | 6077.4 ± 0.9% | 780.8 ± 0.6% | 3.320 | 3.647 | 25.242 | 1.976 | 15.383 |
| hex: silesia/reymont | 524290 | 12016.1 ± 0.2% | 3615.8 ± 0.1% | 3293.5 ± 0.2% | 519.2 ± 1.7% | 6141.0 ± 1.7% | 780.6 ± 1.1% | 3.323 | 3.648 | 23.145 | 1.957 | 15.394 |
| hex: silesia/samba | 524290 | 11979.9 ± 0.1% | 3613.8 ± 0.3% | 3292.2 ± 0.4% | 410.4 ± 2.0% | 6133.0 ± 0.8% | 777.8 ± 0.8% | 3.315 | 3.639 | 29.192 | 1.953 | 15.403 |
| hex: silesia/sao | 524290 | 11976.8 ± 0.3% | 3614.4 ± 0.2% | 3284.9 ± 0.4% | 345.6 ± 1.3% | 6102.6 ± 1.6% | 780.4 ± 0.8% | 3.314 | 3.646 | 34.651 | 1.963 | 15.346 |
| hex: silesia/webster | 524290 | 12017.4 ± 0.1% | 3617.5 ± 0.4% | 3284.0 ± 0.5% | 473.0 ± 1.8% | 6139.0 ± 1.3% | 782.3 ± 0.5% | 3.322 | 3.659 | 25.407 | 1.958 | 15.362 |
| hex: silesia/x-ray | 524290 | 12001.4 ± 0.1% | 3618.3 ± 0.3% | 3289.7 ± 0.2% | 475.9 ± 2.2% | 6106.4 ± 2.7% | 782.6 ± 0.6% | 3.317 | 3.648 | 25.219 | 1.965 | 15.334 |
| hex: silesia/xml | 524290 | 12021.1 ± 0.1% | 3616.3 ± 0.2% | 3291.4 ± 0.2% | 531.4 ± 0.8% | 6128.0 ± 1.4% | 780.2 ± 0.3% | 3.324 | 3.652 | 22.620 | 1.962 | 15.407 |
| hex: canterbury/alice29.txt | 304180 | 12013.7 ± 0.2% | 3626.9 ± 0.2% | 3334.9 ± 0.3% | 523.7 ± 0.6% | 6115.2 ± 0.9% | 779.5 ± 1.3% | 3.312 | 3.602 | 22.941 | 1.965 | 15.413 |
| hex: canterbury/asyoulik.txt | 250360 | 11997.0 ± 0.1% | 3632.6 ± 0.2% | 3370.4 ± 0.1% | 517.2 ± 0.3% | 6115.1 ± 0.6% | 776.4 ± 1.1% | 3.303 | 3.559 | 23.197 | 1.962 | 15.452 |
| hex: canterbury/cp.html | 49208 | 11929.6 ± 0.1% | 3638.5 ± 0.1% | 3292.2 ± 0.3% | 469.8 ± 0.9% | 6211.1 ± 1.9% | 762.5 ± 2.0% | 3.279 | 3.624 | 25.395 | 1.921 | 15.645 |
| hex: canterbury/fields.c | 22302 | 11785.5 ± 0.0% | 3629.6 ± 0.0% | 3352.6 ± 0.0% | 499.5 ± 0.4% | 6252.8 ± 0.2% | 759.7 ± 2.6% | 3.247 | 3.515 | 23.593 | 1.885 | 15.512 |
| hex: canterbury/grammar.lsp | 7444 | 11332.7 ± 0.0% | 3601.1 ± 0.0% | 3356.9 ± 0.2% | 541.0 ± 1.6% | 6177.4 ± 0.5% | 723.8 ± 5.3% | 3.147 | 3.376 | 20.947 | 1.835 | 15.658 |
| hex: canterbury/kennedy.xls | 524290 | 11946.4 ± 0.4% | 3620.6 ± 0.5% | 3279.1 ± 0.4% | 657.2 ± 4.9% | 6072.4 ± 1.0% | 774.5 ± 5.1% | 3.300 | 3.643 | 18.179 | 1.967 | 15.425 |
| hex: canterbury/lcet10.txt | 524290 | 12017.3 ± 0.1% | 3619.6 ± 0.2% | 3285.9 ± 0.2% | 513.5 ± 1.3% | 6139.6 ± 1.4% | 779.5 ± 0.6% | 3.320 | 3.657 | 23.404 | 1.957 | 15.417 |
| hex: canterbury/plrabn12.txt | 524290 | 11945.8 ± 0.3% | 3619.1 ± 0.1% | 3288.5 ± 0.5% | 504.2 ± 0.4% | 6048.8 ± 1.0% | 781.5 ± 0.3% | 3.301 | 3.633 | 23.692 | 1.975 | 15.286 |
| hex: canterbury/ptt5 | 524290 | 12000.8 ± 0.3% | 3617.1 ± 0.1% | 3291.0 ± 0.3% | 558.5 ± 0.2% | 5995.8 ± 1.1% | 780.9 ± 0.3% | 3.318 | 3.647 | 21.487 | 2.002 | 15.368 |
| hex: canterbury/sum | 76482 | 11914.8 ± 0.1% | 3633.8 ± 0.0% | 3356.0 ± 0.3% | 509.9 ± 0.9% | 6185.2 ± 0.5% | 770.8 ± 0.8% | 3.279 | 3.550 | 23.365 | 1.926 | 15.457 |
| hex: canterbury/xargs.1 | 8456 | 11350.4 ± 0.0% | 3602.6 ± 0.0% | 3378.7 ± 0.3% | 488.9 ± 1.5% | 6153.6 ± 0.2% | 755.4 ± 1.4% | 3.151 | 3.359 | 23.215 | 1.845 | 15.026 |
| hex: canterbury-large/E.coli | 524290 | 12007.2 ± 0.2% | 3609.6 ± 0.3% | 3285.5 ± 0.5% | 688.8 ± 0.2% | 6156.8 ± 1.9% | 775.3 ± 5.8% | 3.326 | 3.655 | 17.432 | 1.950 | 15.487 |
| hex: canterbury-large/bible.txt | 524290 | 11981.0 ± 0.2% | 3613.3 ± 0.2% | 3295.0 ± 0.3% | 521.3 ± 1.1% | 6083.7 ± 1.6% | 781.8 ± 0.5% | 3.316 | 3.636 | 22.981 | 1.969 | 15.325 |
| hex: canterbury-large/world192.txt | 524290 | 11957.3 ± 0.2% | 3613.5 ± 0.1% | 3278.2 ± 0.3% | 495.5 ± 0.7% | 6016.7 ± 1.1% | 778.6 ± 0.3% | 3.309 | 3.648 | 24.133 | 1.987 | 15.358 |
| hex: http/html-1kx1024 | 2099200 | 8726.9 ± 5.7% | 3458.8 ± 0.1% | 2842.5 ± 0.2% | 474.6 ± 0.4% | 5072.4 ± 1.0% | 642.1 ± 4.4% | 2.523 | 3.070 | 18.389 | 1.720 | 13.592 |
| hex: http/html-16kx64 | 2097280 | 11766.4 ± 0.2% | 3607.1 ± 0.1% | 3268.4 ± 0.2% | 479.2 ± 0.6% | 5997.0 ± 0.3% | 757.8 ± 1.1% | 3.262 | 3.600 | 24.556 | 1.962 | 15.527 |
| hex: http/html-1m | 524290 | 11959.9 ± 0.1% | 3608.0 ± 0.1% | 3284.6 ± 0.3% | 498.8 ± 0.8% | 6095.8 ± 1.8% | 780.4 ± 2.8% | 3.315 | 3.641 | 23.979 | 1.962 | 15.325 |
| hex: http/json-1kx1024 | 2099200 | 8653.5 ± 16.1% | 3461.1 ± 0.7% | 2831.7 ± 8.8% | 575.0 ± 0.2% | 5123.4 ± 1.0% | 629.5 ± 2.1% | 2.500 | 3.056 | 15.049 | 1.689 | 13.746 |
| hex: http/json-16kx64 | 2097280 | 11756.2 ± 0.2% | 3607.5 ± 0.1% | 3244.7 ± 0.2% | 573.4 ± 0.9% | 6021.0 ± 0.6% | 745.3 ± 1.3% | 3.259 | 3.623 | 20.503 | 1.953 | 15.773 |
| hex: http/json-1m | 524290 | 11909.4 ± 0.2% | 3610.1 ± 0.1% | 3283.1 ± 0.3% | 593.8 ± 0.9% | 6058.3 ± 1.7% | 763.2 ± 2.2% | 3.299 | 3.627 | 20.058 | 1.966 | 15.605 |
| hex: http/js-1kx1024 | 2099200 | 8741.3 ± 4.9% | 3460.0 ± 0.1% | 2832.5 ± 0.6% | 478.8 ± 0.4% | 5082.3 ± 0.7% | 624.1 ± 1.7% | 2.526 | 3.086 | 18.255 | 1.720 | 14.007 |
| hex: http/js-16kx64 | 2097280 | 11757.8 ± 0.2% | 3609.2 ± 0.1% | 3259.1 ± 0.4% | 480.4 ± 1.2% | 6011.7 ± 0.7% | 751.5 ± 2.8% | 3.258 | 3.608 | 24.476 | 1.956 | 15.645 |
| hex: http/js-1m | 524290 | 11979.9 ± 0.3% | 3616.6 ± 0.2% | 3290.9 ± 0.3% | 495.8 ± 2.2% | 5953.5 ± 0.8% | 780.7 ± 4.0% | 3.313 | 3.640 | 24.162 | 2.012 | 15.345 |
| hex: http/css-1kx1024 | 2099200 | 8711.6 ± 4.6% | 3459.3 ± 0.1% | 2834.3 ± 0.3% | 486.0 ± 0.6% | 5070.9 ± 0.9% | 629.1 ± 2.0% | 2.518 | 3.074 | 17.927 | 1.718 | 13.847 |
| hex: http/css-16kx64 | 2097280 | 11765.1 ± 0.2% | 3609.0 ± 0.1% | 3256.4 ± 0.5% | 495.0 ± 0.2% | 6015.2 ± 0.9% | 749.8 ± 2.6% | 3.260 | 3.613 | 23.769 | 1.956 | 15.691 |
| hex: http/css-1m | 524290 | 12027.9 ± 0.1% | 3621.9 ± 0.1% | 3285.0 ± 0.2% | 492.8 ± 0.9% | 6105.9 ± 1.4% | 772.3 ± 2.2% | 3.321 | 3.661 | 24.409 | 1.970 | 15.575 |
| hex: shuffled/dickens-1m | 524290 | 11947.2 ± 0.4% | 3615.9 ± 0.2% | 3281.3 ± 0.4% | 510.1 ± 0.7% | 6026.0 ± 1.2% | 782.2 ± 0.4% | 3.304 | 3.641 | 23.423 | 1.983 | 15.273 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1356.5 ± 2.7% | 1251.8 ± 3.4% | 1036.8 ± 6.6% | 408.8 ± 2.7% | 448.9 ± 2.3% | 414.9 ± 4.0% | 1.084 | 1.308 | 3.318 | 3.022 | 3.269 |
| qlog records, JSON text sequence | 1467503 | 1050.1 ± 18.2% | 1059.8 ± 19.0% | 781.3 ± 25.4% | 378.0 ± 5.8% | 466.3 ± 2.1% | 278.6 ± 0.3% | 0.991 | 1.344 | 2.778 | 2.252 | 3.769 |
| string: silesia/dickens | 172528 | 6902.5 ± 0.4% | 2811.1 ± 0.6% | 2931.5 ± 0.9% | 430.6 ± 0.9% | 1565.5 ± 0.2% | 1008.8 ± 0.2% | 2.455 | 2.355 | 16.031 | 4.409 | 6.843 |
| string: silesia/nci | 1075110 | 7317.3 ± 0.5% | 3403.3 ± 0.3% | 3099.9 ± 0.4% | 811.7 ± 1.1% | 1834.5 ± 0.3% | 1107.3 ± 0.3% | 2.150 | 2.361 | 9.015 | 3.989 | 6.608 |
| string: silesia/reymont | 1075159 | 3351.3 ± 1.5% | 1978.4 ± 1.7% | 2057.3 ± 0.9% | 450.3 ± 0.6% | 1491.0 ± 0.7% | 949.7 ± 0.5% | 1.694 | 1.629 | 7.442 | 2.248 | 3.529 |
| string: silesia/samba | 97582 | 4203.5 ± 0.7% | 2109.4 ± 0.6% | 3447.6 ± 0.7% | 353.0 ± 0.8% | 1406.1 ± 0.3% | 1053.9 ± 0.3% | 1.993 | 1.219 | 11.908 | 2.989 | 3.988 |
| string: silesia/webster | 1098490 | 4068.0 ± 0.2% | 1876.9 ± 0.7% | 2052.8 ± 0.6% | 440.7 ± 0.8% | 1371.2 ± 0.4% | 645.8 ± 0.5% | 2.167 | 1.982 | 9.231 | 2.967 | 6.299 |
| string: silesia/xml | 1090118 | 6124.8 ± 0.6% | 2845.4 ± 0.7% | 2654.2 ± 0.2% | 611.2 ± 0.8% | 1731.8 ± 0.3% | 920.7 ± 0.3% | 2.152 | 2.308 | 10.021 | 3.537 | 6.652 |
| string: canterbury/alice29.txt | 159425 | 6433.0 ± 0.5% | 2193.6 ± 0.4% | 2756.2 ± 0.6% | 407.9 ± 0.2% | 1437.2 ± 0.5% | 956.7 ± 0.1% | 2.933 | 2.334 | 15.771 | 4.476 | 6.724 |
| string: canterbury/asyoulik.txt | 132198 | 5653.0 ± 0.8% | 1709.0 ± 0.3% | 2379.3 ± 1.3% | 402.2 ± 0.5% | 1309.4 ± 0.4% | 885.6 ± 0.2% | 3.308 | 2.376 | 14.054 | 4.317 | 6.383 |
| string: canterbury/lcet10.txt | 441884 | 6274.4 ± 0.6% | 2563.8 ± 0.3% | 2497.2 ± 1.9% | 467.8 ± 0.2% | 1522.5 ± 0.4% | 984.5 ± 0.8% | 2.447 | 2.513 | 13.412 | 4.121 | 6.373 |
| string: canterbury/plrabn12.txt | 503330 | 5725.2 ± 0.1% | 2055.3 ± 0.3% | 2066.5 ± 0.5% | 424.3 ± 0.5% | 1361.1 ± 0.3% | 931.4 ± 0.5% | 2.786 | 2.770 | 13.494 | 4.206 | 6.147 |
| string: canterbury-large/E.coli | 1048578 | 19099.4 ± 0.3% | 9789.7 ± 0.7% | 3787.5 ± 0.4% | 1473.4 ± 0.7% | 2362.0 ± 1.2% | 1188.2 ± 0.6% | 1.951 | 5.043 | 12.963 | 8.086 | 16.075 |
| string: canterbury-large/bible.txt | 1055886 | 6804.2 ± 0.2% | 4150.1 ± 1.1% | 3055.9 ± 1.7% | 501.7 ± 0.8% | 1978.5 ± 0.3% | 1117.9 ± 1.2% | 1.640 | 2.227 | 13.562 | 3.439 | 6.087 |
| string: canterbury-large/world192.txt | 1103121 | 4053.3 ± 0.4% | 1654.8 ± 0.6% | 1996.7 ± 1.2% | 449.3 ± 0.5% | 1342.3 ± 0.2% | 907.4 ± 0.5% | 2.449 | 2.030 | 9.022 | 3.020 | 4.467 |
| string: http/html-1m | 1058582 | 6770.5 ± 0.3% | 3921.2 ± 0.5% | 3037.8 ± 0.5% | 500.8 ± 0.2% | 1919.0 ± 0.2% | 804.9 ± 0.4% | 1.727 | 2.229 | 13.518 | 3.528 | 8.411 |
| string: http/json-1m | 1190272 | 3164.5 ± 0.7% | 1354.5 ± 0.3% | 1556.1 ± 0.5% | 443.4 ± 1.0% | 1035.2 ± 0.2% | 764.6 ± 0.5% | 2.336 | 2.034 | 7.137 | 3.057 | 4.139 |
| string: http/js-1m | 1144362 | 2775.4 ± 0.7% | 1180.2 ± 0.5% | 1622.9 ± 0.4% | 369.7 ± 0.3% | 1084.5 ± 0.1% | 757.4 ± 0.3% | 2.352 | 1.710 | 7.508 | 2.559 | 3.665 |
| string: http/css-1m | 1097820 | 4011.9 ± 0.6% | 1492.8 ± 0.3% | 2146.0 ± 0.5% | 494.0 ± 0.5% | 1356.1 ± 0.4% | 893.3 ± 0.4% | 2.687 | 1.869 | 8.121 | 2.958 | 4.491 |
| string: dickens as Cyrillic and CJK | 1883069 | 3068.9 ± 0.4% | 2341.4 ± 0.5% | 521.7 ± 0.3% | 307.0 ± 0.7% | 560.1 ± 1.2% | 335.8 ± 0.2% | 1.311 | 5.883 | 9.997 | 5.480 | 9.140 |
| hex: silesia/dickens | 524290 | 15666.3 ± 0.4% | 1458.9 ± 0.2% | 1082.6 ± 0.3% | 500.1 ± 1.0% | 993.7 ± 0.5% | 732.6 ± 0.2% | 10.738 | 14.471 | 31.329 | 15.766 | 21.384 |
| hex: silesia/mozilla | 524290 | 15624.2 ± 0.3% | 1470.5 ± 0.2% | 1089.3 ± 0.3% | 439.9 ± 0.7% | 992.4 ± 1.1% | 733.8 ± 0.4% | 10.625 | 14.343 | 35.516 | 15.743 | 21.293 |
| hex: silesia/mr | 524290 | 15626.9 ± 2.6% | 1478.8 ± 1.2% | 1093.6 ± 0.4% | 549.0 ± 2.5% | 997.8 ± 0.7% | 733.6 ± 0.4% | 10.567 | 14.289 | 28.465 | 15.662 | 21.302 |
| hex: silesia/nci | 524290 | 15621.5 ± 0.6% | 1466.7 ± 0.2% | 1089.5 ± 0.3% | 637.6 ± 4.0% | 990.7 ± 0.5% | 731.3 ± 0.4% | 10.651 | 14.339 | 24.501 | 15.768 | 21.362 |
| hex: silesia/ooffice | 524290 | 15591.7 ± 0.5% | 1463.6 ± 0.2% | 1085.6 ± 0.2% | 389.3 ± 0.4% | 988.0 ± 0.3% | 733.3 ± 0.4% | 10.653 | 14.362 | 40.053 | 15.781 | 21.263 |
| hex: silesia/osdb | 524290 | 15629.9 ± 0.2% | 1465.5 ± 0.5% | 1083.9 ± 0.6% | 465.1 ± 0.5% | 992.3 ± 0.8% | 733.1 ± 0.4% | 10.665 | 14.421 | 33.603 | 15.751 | 21.321 |
| hex: silesia/reymont | 524290 | 15637.7 ± 0.4% | 1460.5 ± 0.6% | 1086.4 ± 0.3% | 515.9 ± 1.0% | 991.7 ± 0.6% | 733.4 ± 0.3% | 10.707 | 14.394 | 30.312 | 15.768 | 21.322 |
| hex: silesia/samba | 524290 | 15655.7 ± 0.9% | 1464.8 ± 0.4% | 1084.3 ± 0.4% | 402.1 ± 0.2% | 989.9 ± 0.4% | 732.3 ± 0.4% | 10.688 | 14.439 | 38.938 | 15.816 | 21.380 |
| hex: silesia/sao | 524290 | 15662.5 ± 0.8% | 1462.9 ± 0.3% | 1084.3 ± 0.4% | 332.2 ± 0.4% | 992.3 ± 0.6% | 734.0 ± 0.6% | 10.706 | 14.445 | 47.147 | 15.784 | 21.339 |
| hex: silesia/webster | 524290 | 15657.0 ± 0.4% | 1458.5 ± 0.6% | 1083.6 ± 0.4% | 474.1 ± 0.5% | 988.3 ± 0.5% | 731.8 ± 0.7% | 10.735 | 14.449 | 33.024 | 15.842 | 21.394 |
| hex: silesia/x-ray | 524290 | 15599.6 ± 0.4% | 1475.3 ± 0.1% | 1090.9 ± 0.5% | 446.8 ± 1.1% | 996.6 ± 0.4% | 732.9 ± 0.3% | 10.573 | 14.300 | 34.912 | 15.653 | 21.286 |
| hex: silesia/xml | 524290 | 15641.0 ± 0.2% | 1468.2 ± 0.2% | 1085.4 ± 0.3% | 612.3 ± 0.6% | 988.4 ± 0.6% | 733.2 ± 0.2% | 10.653 | 14.411 | 25.547 | 15.824 | 21.334 |
| hex: canterbury/alice29.txt | 304180 | 15683.0 ± 0.1% | 1465.9 ± 0.7% | 1090.2 ± 0.2% | 504.5 ± 1.5% | 995.8 ± 0.7% | 732.9 ± 0.8% | 10.698 | 14.385 | 31.083 | 15.748 | 21.397 |
| hex: canterbury/asyoulik.txt | 250360 | 15723.8 ± 0.0% | 1475.8 ± 0.2% | 1090.2 ± 0.5% | 499.4 ± 1.2% | 994.7 ± 0.5% | 738.9 ± 0.3% | 10.654 | 14.422 | 31.484 | 15.808 | 21.279 |
| hex: canterbury/cp.html | 49208 | 15668.3 ± 0.0% | 1473.1 ± 0.2% | 1097.8 ± 0.2% | 520.9 ± 2.7% | 1001.2 ± 0.4% | 743.7 ± 0.1% | 10.636 | 14.273 | 30.078 | 15.650 | 21.067 |
| hex: canterbury/fields.c | 22302 | 15529.0 ± 0.1% | 1440.2 ± 0.2% | 1062.1 ± 0.7% | 636.0 ± 7.4% | 986.6 ± 0.3% | 737.4 ± 0.1% | 10.782 | 14.621 | 24.417 | 15.740 | 21.058 |
| hex: canterbury/grammar.lsp | 7444 | 15164.1 ± 0.0% | 1506.2 ± 0.3% | 1094.6 ± 0.3% | 674.6 ± 7.7% | 987.2 ± 0.2% | 725.8 ± 0.1% | 10.068 | 13.854 | 22.478 | 15.361 | 20.892 |
| hex: canterbury/kennedy.xls | 524290 | 15649.2 ± 0.4% | 1472.3 ± 0.2% | 1088.8 ± 0.4% | 643.7 ± 3.2% | 990.8 ± 0.2% | 733.7 ± 0.3% | 10.629 | 14.372 | 24.312 | 15.795 | 21.329 |
| hex: canterbury/lcet10.txt | 524290 | 15647.6 ± 0.1% | 1466.7 ± 0.3% | 1084.8 ± 0.3% | 502.6 ± 3.1% | 993.2 ± 0.8% | 733.1 ± 0.4% | 10.668 | 14.424 | 31.132 | 15.754 | 21.345 |
| hex: canterbury/plrabn12.txt | 524290 | 15610.5 ± 0.6% | 1462.9 ± 0.2% | 1083.5 ± 0.6% | 491.0 ± 1.5% | 986.7 ± 0.5% | 734.0 ± 0.5% | 10.671 | 14.408 | 31.791 | 15.821 | 21.268 |
| hex: canterbury/ptt5 | 524290 | 15620.2 ± 0.5% | 1479.6 ± 0.4% | 1093.6 ± 0.3% | 555.4 ± 0.3% | 994.6 ± 0.7% | 735.3 ± 0.8% | 10.557 | 14.283 | 28.126 | 15.704 | 21.245 |
| hex: canterbury/sum | 76482 | 15678.9 ± 0.0% | 1494.5 ± 0.1% | 1104.0 ± 0.4% | 597.7 ± 0.4% | 998.2 ± 0.1% | 744.4 ± 0.1% | 10.491 | 14.202 | 26.231 | 15.706 | 21.062 |
| hex: canterbury/xargs.1 | 8456 | 15210.0 ± 0.0% | 1493.9 ± 0.5% | 1096.7 ± 0.4% | 660.1 ± 4.6% | 973.7 ± 0.1% | 728.4 ± 0.7% | 10.181 | 13.869 | 23.041 | 15.620 | 20.881 |
| hex: canterbury-large/E.coli | 524290 | 15658.1 ± 0.4% | 1472.4 ± 0.7% | 1088.6 ± 0.7% | 672.3 ± 0.4% | 991.5 ± 0.4% | 733.8 ± 0.3% | 10.634 | 14.383 | 23.291 | 15.792 | 21.337 |
| hex: canterbury-large/bible.txt | 524290 | 15627.1 ± 0.4% | 1462.3 ± 0.3% | 1083.7 ± 0.5% | 511.5 ± 1.2% | 984.3 ± 0.7% | 734.6 ± 0.4% | 10.687 | 14.420 | 30.552 | 15.876 | 21.273 |
| hex: canterbury-large/world192.txt | 524290 | 15539.2 ± 0.3% | 1464.0 ± 0.6% | 1084.0 ± 0.4% | 502.2 ± 0.7% | 988.7 ± 0.4% | 733.0 ± 0.4% | 10.614 | 14.335 | 30.940 | 15.717 | 21.201 |
| hex: http/html-1kx1024 | 2099200 | 14189.3 ± 0.6% | 1455.7 ± 0.1% | 1061.7 ± 0.6% | 501.4 ± 0.2% | 982.8 ± 0.2% | 692.8 ± 0.1% | 9.748 | 13.365 | 28.301 | 14.438 | 20.480 |
| hex: http/html-16kx64 | 2097280 | 15331.2 ± 0.4% | 1442.1 ± 0.2% | 1074.5 ± 0.5% | 506.5 ± 0.2% | 996.2 ± 0.1% | 735.2 ± 0.1% | 10.631 | 14.268 | 30.269 | 15.389 | 20.853 |
| hex: http/html-1m | 524290 | 15634.1 ± 0.4% | 1468.1 ± 0.2% | 1086.4 ± 0.4% | 500.2 ± 0.3% | 990.6 ± 0.3% | 733.8 ± 0.4% | 10.649 | 14.391 | 31.256 | 15.783 | 21.307 |
| hex: http/json-1kx1024 | 2099200 | 14075.8 ± 51.0% | 1463.9 ± 0.2% | 1067.1 ± 0.1% | 608.9 ± 0.3% | 987.8 ± 0.2% | 692.8 ± 0.3% | 9.615 | 13.191 | 23.118 | 14.250 | 20.316 |
| hex: http/json-16kx64 | 2097280 | 15349.0 ± 0.6% | 1446.5 ± 0.2% | 1074.5 ± 0.2% | 616.3 ± 0.5% | 994.7 ± 0.4% | 735.3 ± 0.1% | 10.611 | 14.285 | 24.906 | 15.431 | 20.874 |
| hex: http/json-1m | 524290 | 15620.3 ± 0.5% | 1470.1 ± 0.3% | 1087.2 ± 0.1% | 629.0 ± 1.0% | 992.8 ± 0.2% | 734.1 ± 0.1% | 10.625 | 14.367 | 24.833 | 15.733 | 21.277 |
| hex: http/js-1kx1024 | 2099200 | 14161.8 ± 0.7% | 1455.6 ± 0.2% | 1062.4 ± 0.1% | 498.5 ± 0.1% | 982.8 ± 0.1% | 693.1 ± 0.1% | 9.729 | 13.330 | 28.411 | 14.409 | 20.433 |
| hex: http/js-16kx64 | 2097280 | 15364.0 ± 0.6% | 1443.6 ± 0.2% | 1075.6 ± 0.1% | 503.8 ± 0.4% | 998.1 ± 0.4% | 735.1 ± 0.1% | 10.643 | 14.284 | 30.496 | 15.393 | 20.902 |
| hex: http/js-1m | 524290 | 15674.1 ± 0.2% | 1464.4 ± 0.2% | 1085.2 ± 0.6% | 509.5 ± 0.6% | 990.7 ± 0.3% | 732.5 ± 0.5% | 10.703 | 14.443 | 30.767 | 15.821 | 21.397 |
| hex: http/css-1kx1024 | 2099200 | 14075.6 ± 11.7% | 1456.3 ± 0.1% | 1062.8 ± 0.2% | 531.3 ± 0.3% | 983.3 ± 0.1% | 692.5 ± 0.1% | 9.666 | 13.244 | 26.491 | 14.315 | 20.325 |
| hex: http/css-16kx64 | 2097280 | 15296.6 ± 1.0% | 1444.4 ± 0.1% | 1076.4 ± 0.7% | 541.4 ± 0.5% | 997.9 ± 0.6% | 735.1 ± 0.5% | 10.590 | 14.211 | 28.253 | 15.328 | 20.808 |
| hex: http/css-1m | 524290 | 15650.3 ± 0.6% | 1461.4 ± 0.3% | 1082.9 ± 0.6% | 527.4 ± 0.4% | 989.9 ± 0.3% | 733.4 ± 0.9% | 10.709 | 14.452 | 29.674 | 15.810 | 21.340 |
| hex: shuffled/dickens-1m | 524290 | 15649.6 ± 0.2% | 1461.4 ± 0.3% | 1086.9 ± 0.4% | 502.9 ± 0.8% | 991.7 ± 0.3% | 733.4 ± 0.3% | 10.709 | 14.399 | 31.116 | 15.781 | 21.339 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.918 of yyjson.
