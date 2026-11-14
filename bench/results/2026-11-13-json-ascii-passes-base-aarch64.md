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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43464690664 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.5 ± 0.3% | 0.523 | 0.965 | 0.996 | 0.997 | 0.460 | 1.003 | 1.005 | 0.388 | 0.831 | 0.899 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 811.6 ± 2.9% | 0.847 | 1.049 | 1.060 | 1.062 | 0.470 | 1.058 | 1.075 | 0.417 | 0.959 | 1.031 | 0.129 |
| string: silesia/dickens | 172528 | 5041.2 ± 0.5% | 0.033 | 0.782 | 1.004 | 1.004 | 0.197 | 1.017 | 1.007 | 0.197 | 1.001 | 1.001 | 0.032 |
| string: silesia/nci | 1075110 | 4277.8 ± 0.9% | 0.039 | 0.805 | 1.004 | 1.006 | 0.281 | 1.008 | 1.001 | 0.280 | 1.006 | 1.005 | 0.038 |
| string: silesia/reymont | 1075159 | 2926.3 ± 2.0% | 0.057 | 0.819 | 1.002 | 1.005 | 0.360 | 1.004 | 1.009 | 0.360 | 1.009 | 1.011 | 0.056 |
| string: silesia/samba | 97582 | 3493.5 ± 0.9% | 0.040 | 0.861 | 1.005 | 1.005 | 0.069 | 0.775 | 1.010 | 0.073 | 1.003 | 1.006 | 0.039 |
| string: silesia/webster | 1098490 | 3635.0 ± 0.3% | 0.044 | 0.850 | 1.007 | 1.010 | 0.204 | 1.019 | 1.014 | 0.204 | 1.011 | 1.010 | 0.044 |
| string: silesia/xml | 1090118 | 4758.2 ± 0.5% | 0.035 | 0.808 | 1.006 | 1.006 | 0.223 | 0.984 | 1.008 | 0.225 | 1.008 | 1.010 | 0.035 |
| string: canterbury/alice29.txt | 159425 | 4312.5 ± 0.9% | 0.038 | 0.751 | 1.004 | 1.007 | 0.172 | 1.029 | 1.018 | 0.172 | 1.006 | 1.009 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3446.1 ± 1.1% | 0.046 | 0.750 | 1.007 | 1.011 | 0.177 | 1.008 | 0.969 | 0.176 | 1.016 | 1.018 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5107.2 ± 0.2% | 0.032 | 0.816 | 1.003 | 1.003 | 0.195 | 1.020 | 1.006 | 0.196 | 1.003 | 1.006 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4130.9 ± 0.7% | 0.039 | 0.823 | 1.002 | 1.002 | 0.199 | 1.010 | 0.993 | 0.198 | 1.002 | 1.001 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 18927.7 ± 3.7% | 0.078 | 1.010 | 1.006 | 1.007 | 0.479 | 1.007 | 1.006 | 0.480 | 0.629 | 0.630 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6645.0 ± 2.0% | 0.026 | 0.806 | 1.007 | 1.011 | 0.435 | 1.032 | 1.046 | 0.435 | 1.044 | 1.050 | 0.026 |
| string: canterbury-large/world192.txt | 1103121 | 3379.2 ± 0.3% | 0.048 | 0.847 | 1.004 | 1.004 | 0.198 | 1.015 | 1.007 | 0.198 | 1.005 | 1.005 | 0.047 |
| string: http/html-1m | 1058582 | 6049.0 ± 1.0% | 0.028 | 0.783 | 0.997 | 1.011 | 0.389 | 1.041 | 1.053 | 0.389 | 1.028 | 1.029 | 0.028 |
| string: http/json-1m | 1190272 | 2546.1 ± 0.4% | 0.056 | 0.951 | 1.003 | 1.004 | 0.111 | 1.002 | 0.471 | 0.111 | 1.005 | 1.005 | 0.055 |
| string: http/js-1m | 1144362 | 2286.6 ± 0.6% | 0.066 | 0.888 | 1.003 | 1.001 | 0.174 | 1.054 | 1.042 | 0.174 | 1.000 | 1.000 | 0.065 |
| string: http/css-1m | 1097820 | 2634.7 ± 0.7% | 0.061 | 0.776 | 1.004 | 1.006 | 0.241 | 1.006 | 1.018 | 0.240 | 1.006 | 1.007 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3063.2 ± 0.2% | 0.044 | 0.125 | 1.004 | 1.003 | 0.337 | 0.999 | 1.008 | 0.337 | 1.006 | 1.007 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.0 ± 1.3% | 0.082 | 1.004 | 1.003 | 1.002 | 0.077 | 0.637 | 1.005 | 0.081 | 1.002 | 1.002 | 0.081 |
| hex: silesia/dickens | 524290 | 18097.6 ± 0.9% | 0.082 | 0.997 | 0.993 | 0.993 | 0.523 | 0.997 | 0.998 | 0.522 | 0.661 | 0.661 | 0.010 |
| hex: silesia/mozilla | 524290 | 18227.6 ± 0.9% | 0.082 | 0.999 | 1.001 | 1.000 | 0.524 | 0.999 | 1.001 | 0.526 | 0.657 | 0.657 | 0.010 |
| hex: silesia/mr | 524290 | 18117.9 ± 0.9% | 0.082 | 1.003 | 1.001 | 1.002 | 0.525 | 0.995 | 1.000 | 0.526 | 0.662 | 0.662 | 0.010 |
| hex: silesia/nci | 524290 | 18132.9 ± 0.9% | 0.082 | 0.995 | 0.995 | 0.991 | 0.520 | 0.990 | 0.992 | 0.521 | 0.658 | 0.660 | 0.010 |
| hex: silesia/ooffice | 524290 | 18296.6 ± 0.7% | 0.081 | 1.006 | 0.988 | 0.992 | 0.523 | 0.996 | 0.992 | 0.522 | 0.653 | 0.655 | 0.009 |
| hex: silesia/osdb | 524290 | 17896.8 ± 0.6% | 0.083 | 1.003 | 0.999 | 0.999 | 0.534 | 1.000 | 0.998 | 0.532 | 0.667 | 0.669 | 0.010 |
| hex: silesia/reymont | 524290 | 18319.2 ± 1.3% | 0.081 | 0.999 | 0.996 | 0.994 | 0.520 | 0.997 | 0.992 | 0.521 | 0.653 | 0.652 | 0.009 |
| hex: silesia/samba | 524290 | 17671.8 ± 0.4% | 0.084 | 1.011 | 0.998 | 0.999 | 0.531 | 1.010 | 1.005 | 0.532 | 0.679 | 0.679 | 0.010 |
| hex: silesia/sao | 524290 | 18046.9 ± 1.2% | 0.083 | 1.004 | 1.004 | 1.002 | 0.539 | 1.004 | 1.000 | 0.538 | 0.664 | 0.661 | 0.010 |
| hex: silesia/webster | 524290 | 18338.4 ± 0.7% | 0.081 | 1.014 | 1.004 | 0.999 | 0.539 | 1.000 | 1.001 | 0.534 | 0.655 | 0.656 | 0.009 |
| hex: silesia/x-ray | 524290 | 18159.2 ± 0.8% | 0.082 | 1.006 | 0.995 | 0.997 | 0.545 | 0.996 | 0.994 | 0.544 | 0.662 | 0.662 | 0.010 |
| hex: silesia/xml | 524290 | 18168.1 ± 1.3% | 0.082 | 1.009 | 0.996 | 0.993 | 0.529 | 0.995 | 0.995 | 0.531 | 0.660 | 0.660 | 0.010 |
| hex: canterbury/alice29.txt | 304180 | 18849.4 ± 1.0% | 0.079 | 1.004 | 0.995 | 0.998 | 0.515 | 1.001 | 0.999 | 0.514 | 0.631 | 0.631 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19149.5 ± 0.6% | 0.078 | 0.999 | 1.002 | 1.001 | 0.514 | 1.000 | 0.999 | 0.515 | 0.627 | 0.627 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19270.6 ± 0.1% | 0.081 | 1.001 | 1.002 | 1.002 | 0.541 | 1.002 | 1.002 | 0.543 | 0.619 | 0.619 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18857.3 ± 0.8% | 0.084 | 1.006 | 1.006 | 1.006 | 0.536 | 1.002 | 1.006 | 0.541 | 0.625 | 0.625 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17431.7 ± 1.0% | 0.088 | 1.010 | 1.011 | 1.011 | 0.528 | 1.009 | 1.010 | 0.549 | 0.646 | 0.649 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18333.3 ± 1.6% | 0.081 | 1.005 | 0.994 | 0.998 | 0.517 | 0.996 | 1.003 | 0.515 | 0.656 | 0.656 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18155.7 ± 2.3% | 0.082 | 1.006 | 0.990 | 0.990 | 0.520 | 0.989 | 0.990 | 0.520 | 0.656 | 0.658 | 0.010 |
| hex: canterbury/plrabn12.txt | 524290 | 17979.3 ± 0.3% | 0.083 | 1.006 | 0.998 | 0.998 | 0.539 | 0.996 | 0.999 | 0.539 | 0.668 | 0.668 | 0.010 |
| hex: canterbury/ptt5 | 524290 | 18040.4 ± 1.3% | 0.082 | 0.995 | 1.001 | 1.003 | 0.529 | 1.003 | 0.994 | 0.530 | 0.665 | 0.665 | 0.010 |
| hex: canterbury/sum | 76482 | 19283.0 ± 0.5% | 0.078 | 1.002 | 1.002 | 1.002 | 0.518 | 1.002 | 1.002 | 0.520 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17817.5 ± 0.3% | 0.088 | 1.003 | 1.003 | 1.003 | 0.525 | 1.001 | 1.002 | 0.542 | 0.637 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18159.5 ± 3.4% | 0.082 | 1.022 | 1.010 | 0.999 | 0.518 | 0.999 | 1.003 | 0.518 | 0.659 | 0.659 | 0.010 |
| hex: canterbury-large/bible.txt | 524290 | 18169.1 ± 1.3% | 0.082 | 1.008 | 0.999 | 0.995 | 0.526 | 0.995 | 0.995 | 0.527 | 0.661 | 0.661 | 0.010 |
| hex: canterbury-large/world192.txt | 524290 | 17909.9 ± 0.9% | 0.083 | 0.999 | 1.000 | 0.999 | 0.527 | 1.005 | 0.998 | 0.527 | 0.669 | 0.667 | 0.010 |
| hex: http/html-1kx1024 | 2099200 | 8950.5 ± 12.3% | 0.158 | 1.300 | 1.288 | 1.298 | 0.727 | 1.313 | 0.969 | 0.798 | 0.962 | 0.971 | 0.019 |
| hex: http/html-16kx64 | 2097280 | 17461.5 ± 0.9% | 0.086 | 1.023 | 1.023 | 1.024 | 0.582 | 1.023 | 0.985 | 0.590 | 0.673 | 0.673 | 0.010 |
| hex: http/html-1m | 524290 | 18033.7 ± 0.6% | 0.082 | 1.003 | 0.999 | 0.998 | 0.515 | 1.003 | 1.003 | 0.515 | 0.660 | 0.663 | 0.010 |
| hex: http/json-1kx1024 | 2099200 | 9132.9 ± 14.0% | 0.154 | 1.251 | 1.237 | 1.267 | 0.710 | 1.266 | 0.980 | 0.778 | 0.947 | 0.942 | 0.019 |
| hex: http/json-16kx64 | 2097280 | 17730.4 ± 0.7% | 0.085 | 1.015 | 1.013 | 1.012 | 0.575 | 1.011 | 0.973 | 0.582 | 0.663 | 0.663 | 0.010 |
| hex: http/json-1m | 524290 | 17920.4 ± 1.7% | 0.083 | 1.000 | 1.000 | 0.997 | 0.539 | 0.995 | 0.994 | 0.540 | 0.669 | 0.670 | 0.010 |
| hex: http/js-1kx1024 | 2099200 | 9007.0 ± 12.0% | 0.157 | 1.275 | 1.274 | 1.275 | 0.724 | 1.274 | 0.969 | 0.795 | 0.963 | 0.969 | 0.019 |
| hex: http/js-16kx64 | 2097280 | 17558.2 ± 0.9% | 0.085 | 1.026 | 1.023 | 1.023 | 0.581 | 1.022 | 0.982 | 0.587 | 0.670 | 0.670 | 0.010 |
| hex: http/js-1m | 524290 | 18462.4 ± 1.9% | 0.080 | 1.004 | 1.002 | 0.989 | 0.512 | 0.998 | 0.983 | 0.512 | 0.647 | 0.648 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9050.8 ± 17.2% | 0.157 | 1.280 | 1.280 | 1.276 | 0.720 | 1.287 | 0.963 | 0.791 | 0.960 | 0.962 | 0.019 |
| hex: http/css-16kx64 | 2097280 | 17725.8 ± 1.0% | 0.085 | 1.022 | 1.017 | 1.017 | 0.575 | 1.017 | 0.981 | 0.582 | 0.663 | 0.664 | 0.010 |
| hex: http/css-1m | 524290 | 18635.6 ± 1.2% | 0.079 | 1.001 | 0.999 | 0.989 | 0.502 | 0.996 | 0.987 | 0.504 | 0.641 | 0.639 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 17781.4 ± 0.6% | 0.083 | 1.002 | 1.006 | 1.003 | 0.524 | 1.007 | 1.007 | 0.523 | 0.669 | 0.670 | 0.010 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1476.0 ± 0.5% | 0.446 | 1.002 | 0.969 | 1.006 | 1.008 | 0.269 | 1.003 | 0.544 | 0.918 | 0.089 | 1.030 |
| qlog records, JSON text sequence | 1467503 | 1268.9 ± 2.0% | 0.691 | 0.979 | 1.013 | 1.014 | 1.014 | 0.265 | 1.004 | 0.499 | 0.830 | 0.106 | 1.020 |
| string: silesia/dickens | 172528 | 6890.4 ± 0.4% | 0.025 | 1.001 | 1.002 | 1.002 | 1.003 | 0.167 | 0.718 | 1.004 | 1.004 | 0.025 | 1.036 |
| string: silesia/nci | 1075110 | 7296.1 ± 0.7% | 0.024 | 1.001 | 1.000 | 0.999 | 1.000 | 0.212 | 0.565 | 1.002 | 1.002 | 0.024 | 1.004 |
| string: silesia/reymont | 1075159 | 3316.7 ± 1.5% | 0.053 | 1.007 | 1.000 | 1.006 | 1.005 | 0.393 | 0.877 | 1.007 | 1.008 | 0.053 | 1.060 |
| string: silesia/samba | 97582 | 4175.2 ± 0.7% | 0.053 | 1.004 | 1.002 | 1.005 | 1.009 | 0.125 | 0.946 | 1.007 | 1.007 | 0.054 | 1.094 |
| string: silesia/webster | 1098490 | 4053.0 ± 0.3% | 0.042 | 1.011 | 1.006 | 1.009 | 1.010 | 0.213 | 0.887 | 0.999 | 1.006 | 0.044 | 1.011 |
| string: silesia/xml | 1090118 | 6107.2 ± 0.4% | 0.029 | 1.003 | 0.995 | 1.003 | 1.005 | 0.255 | 0.777 | 1.002 | 1.003 | 0.029 | 1.018 |
| string: canterbury/alice29.txt | 159425 | 6404.4 ± 1.2% | 0.027 | 1.007 | 1.009 | 1.012 | 1.015 | 0.133 | 0.655 | 1.003 | 1.006 | 0.027 | 1.065 |
| string: canterbury/asyoulik.txt | 132198 | 5594.4 ± 2.0% | 0.030 | 1.026 | 1.032 | 1.034 | 1.037 | 0.130 | 0.597 | 1.001 | 1.010 | 0.030 | 1.050 |
| string: canterbury/lcet10.txt | 441884 | 6230.8 ± 0.7% | 0.028 | 1.004 | 1.006 | 1.005 | 1.007 | 0.185 | 0.801 | 1.001 | 1.004 | 0.028 | 1.000 |
| string: canterbury/plrabn12.txt | 503330 | 5699.1 ± 0.3% | 0.030 | 1.002 | 1.003 | 1.002 | 1.002 | 0.169 | 0.697 | 1.001 | 1.001 | 0.030 | 1.009 |
| string: canterbury-large/E.coli | 1048578 | 19121.7 ± 1.1% | 0.078 | 0.998 | 0.997 | 0.997 | 1.000 | 0.480 | 1.000 | 0.999 | 0.998 | 0.009 | 0.999 |
| string: canterbury-large/bible.txt | 1055886 | 6772.0 ± 0.5% | 0.026 | 1.002 | 1.002 | 1.002 | 1.002 | 0.494 | 0.979 | 1.001 | 1.001 | 0.026 | 1.002 |
| string: canterbury-large/world192.txt | 1103121 | 4018.3 ± 0.8% | 0.043 | 1.017 | 1.018 | 1.018 | 1.015 | 0.194 | 0.831 | 1.002 | 1.009 | 0.043 | 1.003 |
| string: http/html-1m | 1058582 | 6742.5 ± 0.6% | 0.026 | 1.005 | 0.926 | 1.004 | 1.005 | 0.404 | 0.891 | 0.998 | 1.000 | 0.026 | 1.009 |
| string: http/json-1m | 1190272 | 3153.8 ± 0.5% | 0.051 | 1.002 | 0.967 | 1.005 | 1.003 | 0.133 | 0.372 | 1.002 | 1.003 | 0.051 | 1.044 |
| string: http/js-1m | 1144362 | 2754.4 ± 0.5% | 0.060 | 1.004 | 1.012 | 1.004 | 1.010 | 0.166 | 0.842 | 1.003 | 1.009 | 0.061 | 1.019 |
| string: http/css-1m | 1097820 | 3988.5 ± 0.6% | 0.042 | 1.006 | 1.004 | 1.005 | 1.007 | 0.208 | 0.644 | 0.996 | 1.004 | 0.043 | 1.006 |
| string: dickens as Cyrillic and CJK | 1883069 | 3068.6 ± 0.2% | 0.048 | 1.000 | 0.124 | 1.002 | 1.002 | 0.320 | 1.003 | 1.001 | 1.002 | 0.048 | 1.000 |
| hex: silesia/dickens | 524290 | 15657.4 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.000 | 1.001 | 1.000 | 1.000 | 1.001 | 0.998 | 0.178 | 1.001 |
| hex: silesia/mozilla | 524290 | 15658.4 ± 2.7% | 1.000 | 0.178 | 0.998 | 0.998 | 0.994 | 0.997 | 0.993 | 0.992 | 0.995 | 0.178 | 0.994 |
| hex: silesia/mr | 524290 | 15655.6 ± 0.2% | 1.000 | 0.178 | 1.001 | 1.000 | 1.000 | 0.997 | 0.997 | 1.000 | 0.999 | 0.178 | 0.999 |
| hex: silesia/nci | 524290 | 15650.0 ± 0.2% | 1.000 | 0.178 | 1.001 | 1.000 | 1.000 | 0.998 | 1.000 | 1.000 | 1.000 | 0.178 | 1.000 |
| hex: silesia/ooffice | 524290 | 15588.7 ± 0.3% | 1.002 | 0.179 | 1.002 | 0.999 | 0.998 | 0.998 | 0.999 | 0.992 | 0.993 | 0.178 | 0.994 |
| hex: silesia/osdb | 524290 | 15646.0 ± 0.4% | 1.002 | 0.178 | 1.000 | 1.000 | 1.001 | 0.999 | 1.000 | 0.998 | 0.997 | 0.178 | 0.999 |
| hex: silesia/reymont | 524290 | 15613.4 ± 0.3% | 1.002 | 0.178 | 0.997 | 1.002 | 1.000 | 0.999 | 1.003 | 1.003 | 1.001 | 0.178 | 1.002 |
| hex: silesia/samba | 524290 | 15636.5 ± 0.3% | 1.000 | 0.178 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 1.001 | 1.002 | 0.178 | 0.997 |
| hex: silesia/sao | 524290 | 15650.0 ± 0.3% | 1.000 | 0.178 | 0.999 | 0.998 | 0.997 | 0.989 | 0.993 | 0.996 | 0.996 | 0.177 | 0.995 |
| hex: silesia/webster | 524290 | 15554.3 ± 0.3% | 1.001 | 0.179 | 1.000 | 0.999 | 0.998 | 0.994 | 0.994 | 0.993 | 0.996 | 0.178 | 0.994 |
| hex: silesia/x-ray | 524290 | 15635.7 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.001 | 1.000 | 0.994 | 0.999 | 0.997 | 0.996 | 0.178 | 0.999 |
| hex: silesia/xml | 524290 | 15609.5 ± 0.4% | 1.001 | 0.179 | 0.989 | 0.993 | 0.995 | 0.992 | 0.998 | 0.991 | 0.994 | 0.178 | 0.997 |
| hex: canterbury/alice29.txt | 304180 | 15575.7 ± 0.1% | 1.001 | 0.180 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 1.001 | 1.000 | 0.178 | 1.000 |
| hex: canterbury/asyoulik.txt | 250360 | 15703.8 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15619.8 ± 0.1% | 1.001 | 0.179 | 1.001 | 1.000 | 1.000 | 0.998 | 1.000 | 1.001 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15437.1 ± 0.1% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.994 | 1.000 | 1.002 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14924.8 ± 0.1% | 1.002 | 0.186 | 1.000 | 1.000 | 1.000 | 0.983 | 1.000 | 1.003 | 1.014 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15488.3 ± 0.2% | 1.002 | 0.179 | 0.998 | 0.995 | 0.998 | 0.992 | 0.990 | 0.989 | 0.990 | 0.179 | 0.990 |
| hex: canterbury/lcet10.txt | 524290 | 15622.1 ± 0.3% | 1.002 | 0.178 | 0.999 | 1.001 | 1.000 | 1.002 | 1.002 | 1.001 | 1.001 | 0.178 | 1.002 |
| hex: canterbury/plrabn12.txt | 524290 | 15695.9 ± 0.2% | 0.999 | 0.178 | 0.998 | 0.998 | 0.999 | 0.997 | 0.997 | 0.998 | 0.995 | 0.177 | 0.996 |
| hex: canterbury/ptt5 | 524290 | 15582.5 ± 0.3% | 0.998 | 0.179 | 1.005 | 1.001 | 1.002 | 1.003 | 1.003 | 1.002 | 1.004 | 0.179 | 1.004 |
| hex: canterbury/sum | 76482 | 15638.6 ± 0.0% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 14992.1 ± 0.1% | 1.003 | 0.185 | 1.000 | 1.000 | 1.000 | 0.986 | 1.001 | 1.003 | 1.014 | 0.184 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 15574.2 ± 0.2% | 1.001 | 0.178 | 1.004 | 1.001 | 1.001 | 1.001 | 1.002 | 1.002 | 1.001 | 0.179 | 1.002 |
| hex: canterbury-large/bible.txt | 524290 | 15630.7 ± 0.4% | 1.001 | 0.179 | 1.000 | 1.001 | 1.002 | 0.998 | 1.000 | 1.000 | 1.001 | 0.177 | 1.001 |
| hex: canterbury-large/world192.txt | 524290 | 15626.2 ± 0.3% | 1.002 | 0.179 | 0.999 | 1.001 | 1.001 | 1.001 | 1.002 | 1.002 | 1.003 | 0.178 | 1.002 |
| hex: http/html-1kx1024 | 2099200 | 13571.0 ± 0.9% | 1.006 | 0.196 | 1.006 | 1.000 | 1.001 | 0.945 | 1.006 | 1.009 | 1.041 | 0.188 | 1.018 |
| hex: http/html-16kx64 | 2097280 | 15214.4 ± 0.3% | 0.999 | 0.182 | 0.999 | 1.001 | 1.001 | 0.988 | 0.996 | 1.005 | 1.013 | 0.180 | 1.003 |
| hex: http/html-1m | 524290 | 15612.7 ± 0.4% | 1.002 | 0.177 | 1.000 | 0.997 | 0.992 | 0.996 | 0.999 | 0.993 | 0.992 | 0.177 | 0.998 |
| hex: http/json-1kx1024 | 2099200 | 13624.8 ± 0.2% | 1.003 | 0.196 | 0.999 | 1.002 | 1.002 | 0.940 | 0.998 | 1.002 | 1.035 | 0.188 | 1.015 |
| hex: http/json-16kx64 | 2097280 | 15184.0 ± 0.7% | 1.002 | 0.182 | 0.998 | 1.000 | 1.001 | 0.989 | 0.999 | 1.005 | 1.013 | 0.180 | 1.004 |
| hex: http/json-1m | 524290 | 15626.6 ± 0.1% | 1.004 | 0.178 | 1.002 | 1.000 | 1.000 | 1.000 | 1.001 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: http/js-1kx1024 | 2099200 | 13650.3 ± 0.4% | 1.008 | 0.195 | 0.995 | 1.000 | 1.000 | 0.932 | 0.995 | 0.996 | 1.033 | 0.188 | 1.010 |
| hex: http/js-16kx64 | 2097280 | 15190.5 ± 0.3% | 0.999 | 0.182 | 1.001 | 1.002 | 1.003 | 0.993 | 1.003 | 1.011 | 1.015 | 0.180 | 1.002 |
| hex: http/js-1m | 524290 | 15613.8 ± 0.3% | 1.004 | 0.178 | 1.002 | 1.000 | 0.998 | 0.998 | 0.997 | 0.995 | 0.999 | 0.178 | 0.993 |
| hex: http/css-1kx1024 | 2099200 | 13609.6 ± 0.6% | 1.002 | 0.196 | 0.994 | 1.000 | 1.000 | 0.936 | 0.995 | 0.998 | 1.037 | 0.188 | 1.011 |
| hex: http/css-16kx64 | 2097280 | 15231.6 ± 0.5% | 0.999 | 0.181 | 0.999 | 1.002 | 1.002 | 0.992 | 0.995 | 1.006 | 1.008 | 0.180 | 0.999 |
| hex: http/css-1m | 524290 | 15664.0 ± 0.2% | 1.000 | 0.177 | 1.000 | 1.000 | 0.999 | 0.999 | 1.000 | 1.002 | 1.000 | 0.178 | 0.997 |
| hex: shuffled/dickens-1m | 524290 | 15628.6 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.000 | 1.000 | 1.000 | 1.001 | 0.999 | 0.999 | 0.178 | 1.001 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- qlog records, JSON text sequence, decoding: J7 wide vectors off runs at 1.060 of all on.
- qlog records, JSON text sequence, decoding: J8 decoder fast path off runs at 1.062 of all on.
- qlog records, JSON text sequence, decoding: J12 decoder escape words off runs at 1.058 of all on.
- qlog records, JSON text sequence, decoding: J13 decoder escape blocks off runs at 1.075 of all on.
- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.053 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.054 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.300 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.288 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.298 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.313 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.251 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.237 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.267 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.266 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.275 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.274 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.275 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.274 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.280 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.280 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.276 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.287 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43354.1 ± 0.2% | 47405.9 ± 0.1% | 0.915 | — | — |
| string: silesia/nci | 1048576 | 32832.5 ± 3.5% | 34748.3 ± 1.7% | 0.945 | — | — |
| string: silesia/reymont | 1048576 | 32721.8 ± 4.1% | 34829.0 ± 5.7% | 0.939 | — | — |
| string: silesia/samba | 65546 | 43595.0 ± 0.0% | 48511.8 ± 0.0% | 0.899 | — | — |
| string: silesia/webster | 1048576 | 33688.5 ± 3.6% | 36329.0 ± 1.9% | 0.927 | — | — |
| string: silesia/xml | 1048576 | 30491.4 ± 4.1% | 31998.1 ± 1.5% | 0.953 | — | — |
| string: canterbury/alice29.txt | 152089 | 35901.9 ± 0.1% | 36548.4 ± 0.1% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43329.0 ± 0.2% | 47617.0 ± 0.1% | 0.910 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36059.0 ± 0.2% | 36713.3 ± 0.1% | 0.982 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 40623.6 ± 0.9% | 44252.3 ± 2.7% | 0.918 | — | — |
| string: canterbury-large/E.coli | 1048576 | 34356.8 ± 4.8% | 36619.4 ± 6.6% | 0.938 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 30842.5 ± 2.1% | 32495.9 ± 2.8% | 0.949 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 28910.1 ± 3.9% | 29629.3 ± 4.7% | 0.976 | — | — |
| string: http/html-1m | 1048576 | 33053.0 ± 4.8% | 35396.1 ± 4.8% | 0.934 | — | — |
| string: http/json-1m | 1048576 | 29671.8 ± 2.2% | 31283.6 ± 2.4% | 0.948 | — | — |
| string: http/js-1m | 1048576 | 33547.4 ± 5.0% | 35648.2 ± 4.3% | 0.941 | — | — |
| string: http/css-1m | 1048576 | 34056.9 ± 2.8% | 37045.6 ± 1.9% | 0.919 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5768.0 ± 0.4% | 5651.8 ± 0.1% | 1.021 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.915 of simdutf.
- string: silesia/nci: stdx runs at 0.945 of simdutf.
- string: silesia/reymont: stdx runs at 0.939 of simdutf.
- string: silesia/samba: stdx runs at 0.899 of simdutf.
- string: silesia/webster: stdx runs at 0.927 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.910 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.918 of simdutf.
- string: canterbury-large/bible.txt: stdx runs at 0.949 of simdutf.
- string: http/html-1m: stdx runs at 0.934 of simdutf.
- string: http/json-1m: stdx runs at 0.948 of simdutf.
- string: http/js-1m: stdx runs at 0.941 of simdutf.
- string: http/css-1m: stdx runs at 0.919 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 34077.3 ± 3.3% | 36455.9 ± 1.3% | 0.935 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 29638.3 ± 0.7% | 30820.1 ± 1.1% | 0.962 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 32328.8 ± 0.6% | 34452.3 ± 1.1% | 0.938 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 32972.8 ± 2.0% | 35477.0 ± 0.8% | 0.929 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 32874.5 ± 1.5% | 35557.4 ± 1.9% | 0.925 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 32651.2 ± 1.3% | 35416.0 ± 2.6% | 0.922 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5752.1 ± 0.3% | 5637.5 ± 0.5% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5746.2 ± 0.2% | 5641.2 ± 0.2% | 1.019 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5751.3 ± 0.2% | 5640.5 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5745.8 ± 0.2% | 5633.8 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5745.7 ± 0.4% | 5634.7 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5749.7 ± 0.1% | 5639.5 ± 0.1% | 1.020 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.5 ± 0.3% | 931.0 ± 0.5% | 1018.7 ± 0.2% | 300.8 ± 0.6% | 666.5 ± 0.2% | 309.9 ± 1.8% | 1.211 | 1.107 | 3.749 | 1.692 | 3.638 |
| qlog records, JSON text sequence | 1467503 | 811.6 ± 2.9% | 817.3 ± 0.1% | 770.3 ± 1.5% | 243.6 ± 1.0% | 693.7 ± 0.5% | 249.1 ± 0.6% | 0.993 | 1.054 | 3.332 | 1.170 | 3.257 |
| string: silesia/dickens | 172528 | 5041.2 ± 0.5% | 1878.0 ± 0.1% | 2646.3 ± 0.2% | 360.7 ± 0.8% | 2851.2 ± 0.3% | 548.3 ± 1.4% | 2.684 | 1.905 | 13.976 | 1.768 | 9.195 |
| string: silesia/nci | 1075110 | 4277.8 ± 0.9% | 2235.9 ± 0.5% | 2985.1 ± 0.5% | 543.4 ± 1.3% | 2990.0 ± 0.6% | 596.5 ± 1.7% | 1.913 | 1.433 | 7.872 | 1.431 | 7.172 |
| string: silesia/reymont | 1075159 | 2926.3 ± 2.0% | 1818.2 ± 2.1% | 2057.5 ± 0.2% | 373.8 ± 1.7% | 2141.3 ± 0.4% | 532.7 ± 0.3% | 1.609 | 1.422 | 7.829 | 1.367 | 5.493 |
| string: silesia/samba | 97582 | 3493.5 ± 0.9% | 2026.6 ± 0.9% | 2611.7 ± 0.4% | 328.3 ± 0.3% | 1497.4 ± 0.6% | 427.5 ± 2.1% | 1.724 | 1.338 | 10.641 | 2.333 | 8.172 |
| string: silesia/webster | 1098490 | 3635.0 ± 0.3% | 1516.3 ± 0.4% | 2008.5 ± 0.4% | 359.2 ± 0.5% | 2176.5 ± 0.4% | 480.7 ± 1.9% | 2.397 | 1.810 | 10.119 | 1.670 | 7.562 |
| string: silesia/xml | 1090118 | 4758.2 ± 0.5% | 2359.4 ± 0.4% | 2522.5 ± 0.4% | 453.2 ± 0.6% | 2851.2 ± 1.0% | 549.8 ± 0.8% | 2.017 | 1.886 | 10.499 | 1.669 | 8.654 |
| string: canterbury/alice29.txt | 159425 | 4312.5 ± 0.9% | 1599.6 ± 0.2% | 2457.3 ± 0.1% | 342.4 ± 0.5% | 2492.8 ± 0.3% | 502.9 ± 2.5% | 2.696 | 1.755 | 12.594 | 1.730 | 8.576 |
| string: canterbury/asyoulik.txt | 132198 | 3446.1 ± 1.1% | 1458.1 ± 0.3% | 2254.1 ± 0.9% | 331.8 ± 1.7% | 2073.7 ± 0.6% | 459.8 ± 2.4% | 2.363 | 1.529 | 10.387 | 1.662 | 7.494 |
| string: canterbury/lcet10.txt | 441884 | 5107.2 ± 0.2% | 1853.8 ± 0.3% | 2338.4 ± 0.5% | 389.7 ± 0.5% | 2823.5 ± 0.5% | 533.1 ± 1.4% | 2.755 | 2.184 | 13.107 | 1.809 | 9.580 |
| string: canterbury/plrabn12.txt | 503330 | 4130.9 ± 0.7% | 1736.9 ± 0.2% | 2054.8 ± 0.3% | 361.6 ± 0.7% | 2495.2 ± 0.6% | 492.7 ± 0.9% | 2.378 | 2.010 | 11.422 | 1.655 | 8.384 |
| string: canterbury-large/E.coli | 1048578 | 18927.7 ± 3.7% | 3607.5 ± 0.4% | 3246.9 ± 0.3% | 930.9 ± 0.8% | 5925.7 ± 0.9% | 742.6 ± 0.5% | 5.247 | 5.829 | 20.333 | 3.194 | 25.488 |
| string: canterbury-large/bible.txt | 1055886 | 6645.0 ± 2.0% | 2932.7 ± 0.3% | 2823.7 ± 0.8% | 419.1 ± 1.7% | 3735.0 ± 1.4% | 600.9 ± 1.2% | 2.266 | 2.353 | 15.855 | 1.779 | 11.058 |
| string: canterbury-large/world192.txt | 1103121 | 3379.2 ± 0.3% | 1482.3 ± 0.1% | 2006.6 ± 0.4% | 352.1 ± 0.2% | 2120.2 ± 0.5% | 489.7 ± 3.0% | 2.280 | 1.684 | 9.596 | 1.594 | 6.901 |
| string: http/html-1m | 1058582 | 6049.0 ± 1.0% | 2736.4 ± 0.5% | 2697.0 ± 0.4% | 441.8 ± 0.3% | 3473.0 ± 0.6% | 596.4 ± 0.8% | 2.211 | 2.243 | 13.691 | 1.742 | 10.143 |
| string: http/json-1m | 1190272 | 2546.1 ± 0.4% | 876.5 ± 0.2% | 2244.2 ± 0.3% | 390.2 ± 0.6% | 1063.8 ± 0.2% | 440.7 ± 0.4% | 2.905 | 1.134 | 6.526 | 2.393 | 5.778 |
| string: http/js-1m | 1144362 | 2286.6 ± 0.6% | 1028.8 ± 0.3% | 1637.3 ± 0.4% | 320.6 ± 0.2% | 1525.2 ± 0.5% | 417.4 ± 0.7% | 2.223 | 1.396 | 7.132 | 1.499 | 5.478 |
| string: http/css-1m | 1097820 | 2634.7 ± 0.7% | 1677.8 ± 0.3% | 2221.4 ± 0.8% | 403.9 ± 1.1% | 1955.2 ± 0.7% | 487.4 ± 0.8% | 1.570 | 1.186 | 6.523 | 1.348 | 5.406 |
| string: dickens as Cyrillic and CJK | 1883069 | 3063.2 ± 0.2% | 1686.1 ± 0.4% | 893.0 ± 0.1% | 351.4 ± 0.1% | 671.3 ± 0.4% | 156.7 ± 3.1% | 1.817 | 3.430 | 8.717 | 4.563 | 19.549 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.0 ± 1.3% | 980.5 ± 0.3% | 1198.4 ± 0.8% | 216.0 ± 0.2% | 468.7 ± 0.7% | 255.4 ± 2.4% | 1.353 | 1.107 | 6.145 | 2.831 | 5.196 |
| hex: silesia/dickens | 524290 | 18097.6 ± 0.9% | 3611.3 ± 0.2% | 3277.1 ± 0.4% | 515.7 ± 2.1% | 6052.4 ± 1.2% | 780.5 ± 2.1% | 5.011 | 5.522 | 35.096 | 2.990 | 23.186 |
| hex: silesia/mozilla | 524290 | 18227.6 ± 0.9% | 3613.3 ± 0.2% | 3298.5 ± 0.2% | 460.8 ± 0.5% | 6016.9 ± 1.5% | 781.3 ± 0.6% | 5.045 | 5.526 | 39.556 | 3.029 | 23.329 |
| hex: silesia/mr | 524290 | 18117.9 ± 0.9% | 3610.8 ± 0.4% | 3272.5 ± 0.3% | 565.1 ± 1.0% | 6131.3 ± 0.6% | 782.0 ± 0.4% | 5.018 | 5.536 | 32.060 | 2.955 | 23.170 |
| hex: silesia/nci | 524290 | 18132.9 ± 0.9% | 3612.1 ± 0.2% | 3281.9 ± 0.2% | 614.7 ± 2.5% | 5946.7 ± 0.6% | 779.4 ± 0.8% | 5.020 | 5.525 | 29.498 | 3.049 | 23.264 |
| hex: silesia/ooffice | 524290 | 18296.6 ± 0.7% | 3608.6 ± 0.3% | 3285.2 ± 0.4% | 405.9 ± 1.1% | 5963.4 ± 1.1% | 779.6 ± 0.5% | 5.070 | 5.569 | 45.078 | 3.068 | 23.470 |
| hex: silesia/osdb | 524290 | 17896.8 ± 0.6% | 3610.1 ± 0.2% | 3287.2 ± 0.3% | 491.6 ± 1.8% | 5959.1 ± 0.3% | 781.1 ± 0.2% | 4.957 | 5.444 | 36.405 | 3.003 | 22.914 |
| hex: silesia/reymont | 524290 | 18319.2 ± 1.3% | 3607.7 ± 0.7% | 3278.5 ± 0.4% | 521.9 ± 1.8% | 6071.7 ± 1.2% | 781.0 ± 0.5% | 5.078 | 5.588 | 35.100 | 3.017 | 23.455 |
| hex: silesia/samba | 524290 | 17671.8 ± 0.4% | 3609.7 ± 0.4% | 3290.5 ± 0.3% | 411.4 ± 2.0% | 6137.4 ± 0.8% | 780.5 ± 0.4% | 4.896 | 5.371 | 42.950 | 2.879 | 22.643 |
| hex: silesia/sao | 524290 | 18046.9 ± 1.2% | 3612.5 ± 0.3% | 3281.4 ± 0.4% | 343.4 ± 0.9% | 6089.0 ± 1.1% | 780.3 ± 0.6% | 4.996 | 5.500 | 52.549 | 2.964 | 23.127 |
| hex: silesia/webster | 524290 | 18338.4 ± 0.7% | 3608.8 ± 0.3% | 3289.9 ± 0.3% | 465.5 ± 1.0% | 6131.4 ± 1.4% | 780.7 ± 0.5% | 5.082 | 5.574 | 39.394 | 2.991 | 23.489 |
| hex: silesia/x-ray | 524290 | 18159.2 ± 0.8% | 3612.2 ± 0.1% | 3281.4 ± 0.2% | 475.3 ± 0.7% | 6082.8 ± 1.2% | 779.8 ± 0.5% | 5.027 | 5.534 | 38.209 | 2.985 | 23.288 |
| hex: silesia/xml | 524290 | 18168.1 ± 1.3% | 3615.0 ± 0.3% | 3292.1 ± 0.2% | 524.1 ± 1.1% | 6103.7 ± 1.2% | 780.4 ± 0.4% | 5.026 | 5.519 | 34.664 | 2.977 | 23.281 |
| hex: canterbury/alice29.txt | 304180 | 18849.4 ± 1.0% | 3641.0 ± 0.1% | 3322.6 ± 0.2% | 505.7 ± 0.7% | 6003.3 ± 1.7% | 779.1 ± 2.1% | 5.177 | 5.673 | 37.272 | 3.140 | 24.194 |
| hex: canterbury/asyoulik.txt | 250360 | 19149.5 ± 0.6% | 3641.9 ± 0.1% | 3376.5 ± 0.2% | 501.7 ± 0.7% | 6200.4 ± 0.6% | 776.5 ± 0.4% | 5.258 | 5.671 | 38.167 | 3.088 | 24.660 |
| hex: canterbury/cp.html | 49208 | 19270.6 ± 0.1% | 3639.0 ± 0.0% | 3284.4 ± 0.5% | 474.2 ± 0.7% | 6278.2 ± 1.1% | 766.4 ± 0.2% | 5.296 | 5.867 | 40.639 | 3.069 | 25.145 |
| hex: canterbury/fields.c | 22302 | 18857.3 ± 0.8% | 3628.9 ± 0.1% | 3402.5 ± 0.3% | 499.0 ± 0.6% | 6263.0 ± 0.2% | 745.5 ± 2.5% | 5.196 | 5.542 | 37.793 | 3.011 | 25.294 |
| hex: canterbury/grammar.lsp | 7444 | 17431.7 ± 1.0% | 3601.3 ± 0.0% | 3369.0 ± 0.4% | 532.4 ± 3.9% | 6186.3 ± 1.0% | 717.7 ± 1.6% | 4.840 | 5.174 | 32.742 | 2.818 | 24.287 |
| hex: canterbury/kennedy.xls | 524290 | 18333.3 ± 1.6% | 3604.9 ± 0.3% | 3286.6 ± 0.1% | 659.5 ± 1.6% | 6128.1 ± 1.4% | 768.0 ± 5.7% | 5.086 | 5.578 | 27.800 | 2.992 | 23.870 |
| hex: canterbury/lcet10.txt | 524290 | 18155.7 ± 2.3% | 3605.2 ± 0.8% | 3284.3 ± 0.5% | 509.6 ± 1.5% | 6091.9 ± 0.9% | 775.0 ± 1.3% | 5.036 | 5.528 | 35.626 | 2.980 | 23.427 |
| hex: canterbury/plrabn12.txt | 524290 | 17979.3 ± 0.3% | 3607.5 ± 0.1% | 3292.6 ± 0.3% | 502.4 ± 0.8% | 6143.6 ± 1.5% | 773.7 ± 0.9% | 4.984 | 5.461 | 35.785 | 2.927 | 23.239 |
| hex: canterbury/ptt5 | 524290 | 18040.4 ± 1.3% | 3603.0 ± 0.5% | 3286.7 ± 0.1% | 566.7 ± 0.3% | 6134.3 ± 2.3% | 771.2 ± 1.0% | 5.007 | 5.489 | 31.836 | 2.941 | 23.393 |
| hex: canterbury/sum | 76482 | 19283.0 ± 0.5% | 3632.6 ± 0.0% | 3363.7 ± 0.4% | 512.6 ± 1.7% | 6174.4 ± 0.4% | 769.0 ± 1.4% | 5.308 | 5.733 | 37.617 | 3.123 | 25.075 |
| hex: canterbury/xargs.1 | 8456 | 17817.5 ± 0.3% | 3602.2 ± 0.0% | 3363.9 ± 0.1% | 489.6 ± 2.2% | 6159.6 ± 0.3% | 746.3 ± 0.7% | 4.946 | 5.297 | 36.391 | 2.893 | 23.874 |
| hex: canterbury-large/E.coli | 524290 | 18159.5 ± 3.4% | 3609.3 ± 0.4% | 3273.8 ± 0.3% | 688.7 ± 0.1% | 6046.9 ± 1.2% | 754.3 ± 4.7% | 5.031 | 5.547 | 26.369 | 3.003 | 24.075 |
| hex: canterbury-large/bible.txt | 524290 | 18169.1 ± 1.3% | 3609.3 ± 0.2% | 3283.9 ± 0.4% | 526.3 ± 1.2% | 6147.1 ± 1.0% | 768.8 ± 1.6% | 5.034 | 5.533 | 34.519 | 2.956 | 23.633 |
| hex: canterbury-large/world192.txt | 524290 | 17909.9 ± 0.9% | 3609.0 ± 0.2% | 3275.6 ± 0.4% | 508.6 ± 0.6% | 6109.8 ± 0.7% | 766.3 ± 0.8% | 4.963 | 5.468 | 35.212 | 2.931 | 23.372 |
| hex: http/html-1kx1024 | 2099200 | 8950.5 ± 12.3% | 3462.7 ± 0.1% | 2821.4 ± 0.6% | 471.8 ± 1.1% | 5060.5 ± 1.1% | 631.7 ± 2.0% | 2.585 | 3.172 | 18.970 | 1.769 | 14.170 |
| hex: http/html-16kx64 | 2097280 | 17461.5 ± 0.9% | 3603.8 ± 0.1% | 3251.7 ± 0.2% | 473.5 ± 1.8% | 6021.1 ± 0.8% | 746.4 ± 6.0% | 4.845 | 5.370 | 36.875 | 2.900 | 23.394 |
| hex: http/html-1m | 524290 | 18033.7 ± 0.6% | 3594.0 ± 0.5% | 3263.5 ± 0.5% | 500.5 ± 2.3% | 6100.9 ± 1.8% | 764.1 ± 3.7% | 5.018 | 5.526 | 36.032 | 2.956 | 23.600 |
| hex: http/json-1kx1024 | 2099200 | 9132.9 ± 14.0% | 3459.2 ± 0.3% | 2827.4 ± 0.3% | 572.2 ± 1.3% | 5112.1 ± 1.0% | 631.5 ± 2.8% | 2.640 | 3.230 | 15.962 | 1.787 | 14.461 |
| hex: http/json-16kx64 | 2097280 | 17730.4 ± 0.7% | 3609.6 ± 0.2% | 3242.1 ± 0.2% | 574.1 ± 0.7% | 6010.4 ± 0.6% | 751.5 ± 4.8% | 4.912 | 5.469 | 30.886 | 2.950 | 23.594 |
| hex: http/json-1m | 524290 | 17920.4 ± 1.7% | 3595.7 ± 0.5% | 3286.8 ± 0.2% | 595.2 ± 1.1% | 6124.8 ± 2.2% | 765.8 ± 1.5% | 4.984 | 5.452 | 30.109 | 2.926 | 23.400 |
| hex: http/js-1kx1024 | 2099200 | 9007.0 ± 12.0% | 3463.9 ± 1.1% | 2831.9 ± 0.5% | 480.2 ± 0.5% | 5083.0 ± 0.3% | 637.6 ± 4.1% | 2.600 | 3.181 | 18.756 | 1.772 | 14.127 |
| hex: http/js-16kx64 | 2097280 | 17558.2 ± 0.9% | 3610.7 ± 0.1% | 3264.6 ± 0.1% | 480.4 ± 2.1% | 6015.7 ± 0.5% | 750.3 ± 2.6% | 4.863 | 5.378 | 36.546 | 2.919 | 23.401 |
| hex: http/js-1m | 524290 | 18462.4 ± 1.9% | 3608.8 ± 0.5% | 3285.2 ± 0.4% | 504.6 ± 2.9% | 6091.4 ± 0.7% | 751.2 ± 1.0% | 5.116 | 5.620 | 36.586 | 3.031 | 24.579 |
| hex: http/css-1kx1024 | 2099200 | 9050.8 ± 17.2% | 3463.0 ± 0.3% | 2828.5 ± 0.5% | 488.1 ± 0.5% | 5054.6 ± 1.3% | 640.3 ± 4.2% | 2.614 | 3.200 | 18.543 | 1.791 | 14.136 |
| hex: http/css-16kx64 | 2097280 | 17725.8 ± 1.0% | 3609.7 ± 0.1% | 3258.4 ± 0.2% | 495.2 ± 0.8% | 6010.0 ± 0.5% | 749.5 ± 1.5% | 4.911 | 5.440 | 35.794 | 2.949 | 23.649 |
| hex: http/css-1m | 524290 | 18635.6 ± 1.2% | 3606.6 ± 0.3% | 3286.6 ± 0.3% | 495.1 ± 2.4% | 6105.3 ± 1.4% | 751.0 ± 3.8% | 5.167 | 5.670 | 37.640 | 3.052 | 24.815 |
| hex: shuffled/dickens-1m | 524290 | 17781.4 ± 0.6% | 3612.5 ± 0.5% | 3285.9 ± 0.4% | 500.7 ± 3.2% | 6106.8 ± 2.2% | 770.4 ± 2.2% | 4.922 | 5.411 | 35.514 | 2.912 | 23.080 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1476.0 ± 0.5% | 1249.5 ± 0.4% | 1038.6 ± 0.7% | 409.7 ± 0.7% | 448.0 ± 0.3% | 415.5 ± 0.5% | 1.181 | 1.421 | 3.603 | 3.295 | 3.552 |
| qlog records, JSON text sequence | 1467503 | 1268.9 ± 2.0% | 1064.0 ± 0.3% | 783.6 ± 0.9% | 376.7 ± 1.2% | 469.0 ± 0.8% | 279.9 ± 0.2% | 1.193 | 1.619 | 3.368 | 2.706 | 4.534 |
| string: silesia/dickens | 172528 | 6890.4 ± 0.4% | 2812.7 ± 0.4% | 2936.3 ± 0.4% | 429.7 ± 0.7% | 1596.6 ± 0.3% | 1007.9 ± 0.2% | 2.450 | 2.347 | 16.035 | 4.316 | 6.836 |
| string: silesia/nci | 1075110 | 7296.1 ± 0.7% | 3393.9 ± 1.4% | 3092.4 ± 0.5% | 822.3 ± 1.9% | 1859.2 ± 0.4% | 1106.6 ± 0.3% | 2.150 | 2.359 | 8.873 | 3.924 | 6.593 |
| string: silesia/reymont | 1075159 | 3316.7 ± 1.5% | 1976.0 ± 2.0% | 2061.9 ± 0.5% | 449.8 ± 0.6% | 1508.4 ± 0.5% | 949.2 ± 0.4% | 1.679 | 1.609 | 7.374 | 2.199 | 3.494 |
| string: silesia/samba | 97582 | 4175.2 ± 0.7% | 2116.9 ± 0.7% | 3446.9 ± 0.5% | 354.0 ± 0.9% | 1437.5 ± 0.3% | 1055.5 ± 0.3% | 1.972 | 1.211 | 11.796 | 2.905 | 3.956 |
| string: silesia/webster | 1098490 | 4053.0 ± 0.3% | 1875.1 ± 0.6% | 2052.9 ± 0.4% | 439.5 ± 0.9% | 1393.3 ± 0.4% | 645.3 ± 0.4% | 2.161 | 1.974 | 9.222 | 2.909 | 6.281 |
| string: silesia/xml | 1090118 | 6107.2 ± 0.4% | 2856.9 ± 1.1% | 2648.2 ± 0.4% | 606.8 ± 0.9% | 1753.6 ± 0.5% | 918.3 ± 0.7% | 2.138 | 2.306 | 10.065 | 3.483 | 6.650 |
| string: canterbury/alice29.txt | 159425 | 6404.4 ± 1.2% | 2200.7 ± 0.6% | 2755.2 ± 1.0% | 407.2 ± 0.9% | 1476.9 ± 0.9% | 954.0 ± 0.5% | 2.910 | 2.324 | 15.729 | 4.336 | 6.713 |
| string: canterbury/asyoulik.txt | 132198 | 5594.4 ± 2.0% | 1716.2 ± 0.5% | 2362.5 ± 0.5% | 401.5 ± 0.7% | 1348.6 ± 1.0% | 884.7 ± 0.1% | 3.260 | 2.368 | 13.933 | 4.148 | 6.324 |
| string: canterbury/lcet10.txt | 441884 | 6230.8 ± 0.7% | 2547.5 ± 0.3% | 2511.0 ± 2.5% | 466.8 ± 0.9% | 1540.6 ± 0.3% | 982.1 ± 0.4% | 2.446 | 2.481 | 13.347 | 4.044 | 6.344 |
| string: canterbury/plrabn12.txt | 503330 | 5699.1 ± 0.3% | 2041.5 ± 0.4% | 2074.4 ± 0.5% | 423.4 ± 0.4% | 1428.5 ± 0.3% | 930.3 ± 0.5% | 2.792 | 2.747 | 13.460 | 3.990 | 6.126 |
| string: canterbury-large/E.coli | 1048578 | 19121.7 ± 1.1% | 9548.8 ± 1.0% | 3790.5 ± 0.3% | 1473.0 ± 0.7% | 2363.8 ± 0.4% | 1190.8 ± 0.1% | 2.003 | 5.045 | 12.981 | 8.089 | 16.057 |
| string: canterbury-large/bible.txt | 1055886 | 6772.0 ± 0.5% | 4116.5 ± 1.2% | 3019.3 ± 1.9% | 503.0 ± 0.9% | 1971.0 ± 0.5% | 1120.1 ± 1.3% | 1.645 | 2.243 | 13.464 | 3.436 | 6.046 |
| string: canterbury-large/world192.txt | 1103121 | 4018.3 ± 0.8% | 1651.7 ± 0.6% | 1994.4 ± 0.4% | 448.3 ± 0.4% | 1357.7 ± 0.3% | 906.7 ± 0.4% | 2.433 | 2.015 | 8.963 | 2.960 | 4.432 |
| string: http/html-1m | 1058582 | 6742.5 ± 0.6% | 3970.0 ± 0.6% | 3040.2 ± 0.8% | 500.5 ± 1.2% | 1913.0 ± 0.5% | 803.8 ± 0.3% | 1.698 | 2.218 | 13.470 | 3.525 | 8.388 |
| string: http/json-1m | 1190272 | 3153.8 ± 0.5% | 1347.5 ± 0.4% | 1552.7 ± 0.6% | 442.5 ± 0.6% | 960.5 ± 0.2% | 763.7 ± 0.3% | 2.340 | 2.031 | 7.127 | 3.283 | 4.130 |
| string: http/js-1m | 1144362 | 2754.4 ± 0.5% | 1176.5 ± 0.5% | 1627.1 ± 0.4% | 368.0 ± 0.2% | 1093.2 ± 0.2% | 757.9 ± 0.2% | 2.341 | 1.693 | 7.485 | 2.520 | 3.634 |
| string: http/css-1m | 1097820 | 3988.5 ± 0.6% | 1482.1 ± 0.6% | 2153.7 ± 0.7% | 494.1 ± 0.6% | 1369.6 ± 0.3% | 893.8 ± 0.4% | 2.691 | 1.852 | 8.073 | 2.912 | 4.462 |
| string: dickens as Cyrillic and CJK | 1883069 | 3068.6 ± 0.2% | 2346.5 ± 0.6% | 520.9 ± 0.4% | 307.0 ± 0.7% | 561.9 ± 1.4% | 335.9 ± 0.4% | 1.308 | 5.891 | 9.997 | 5.461 | 9.135 |
| hex: silesia/dickens | 524290 | 15657.4 ± 0.2% | 1459.3 ± 0.2% | 1082.2 ± 0.3% | 490.0 ± 1.2% | 991.9 ± 0.3% | 731.8 ± 0.5% | 10.729 | 14.468 | 31.952 | 15.786 | 21.396 |
| hex: silesia/mozilla | 524290 | 15658.4 ± 2.7% | 1467.2 ± 0.2% | 1089.3 ± 0.2% | 440.9 ± 0.1% | 993.6 ± 0.4% | 732.1 ± 1.5% | 10.672 | 14.375 | 35.511 | 15.759 | 21.390 |
| hex: silesia/mr | 524290 | 15655.6 ± 0.2% | 1479.2 ± 0.2% | 1091.1 ± 0.5% | 554.8 ± 3.0% | 993.0 ± 0.1% | 732.7 ± 0.8% | 10.584 | 14.349 | 28.218 | 15.766 | 21.367 |
| hex: silesia/nci | 524290 | 15650.0 ± 0.2% | 1466.1 ± 0.3% | 1086.6 ± 0.5% | 628.6 ± 3.5% | 994.5 ± 0.7% | 733.6 ± 0.5% | 10.675 | 14.403 | 24.897 | 15.736 | 21.333 |
| hex: silesia/ooffice | 524290 | 15588.7 ± 0.3% | 1464.5 ± 0.2% | 1083.2 ± 0.5% | 389.3 ± 0.4% | 991.5 ± 0.4% | 734.8 ± 0.4% | 10.644 | 14.392 | 40.046 | 15.722 | 21.215 |
| hex: silesia/osdb | 524290 | 15646.0 ± 0.4% | 1461.7 ± 0.5% | 1088.8 ± 0.6% | 464.6 ± 3.0% | 991.9 ± 0.5% | 731.4 ± 0.1% | 10.704 | 14.369 | 33.678 | 15.773 | 21.391 |
| hex: silesia/reymont | 524290 | 15613.4 ± 0.3% | 1462.8 ± 0.7% | 1085.0 ± 0.4% | 513.6 ± 0.7% | 988.4 ± 0.2% | 732.0 ± 0.8% | 10.674 | 14.390 | 30.400 | 15.796 | 21.329 |
| hex: silesia/samba | 524290 | 15636.5 ± 0.3% | 1464.6 ± 0.4% | 1083.8 ± 0.3% | 401.4 ± 0.7% | 992.1 ± 0.5% | 731.8 ± 0.6% | 10.676 | 14.428 | 38.954 | 15.761 | 21.368 |
| hex: silesia/sao | 524290 | 15650.0 ± 0.3% | 1463.3 ± 0.4% | 1084.0 ± 0.6% | 333.4 ± 0.3% | 990.4 ± 0.2% | 734.5 ± 0.9% | 10.695 | 14.437 | 46.942 | 15.802 | 21.308 |
| hex: silesia/webster | 524290 | 15554.3 ± 0.3% | 1459.6 ± 0.3% | 1083.2 ± 0.4% | 475.6 ± 0.9% | 989.3 ± 0.6% | 733.5 ± 0.5% | 10.656 | 14.360 | 32.706 | 15.723 | 21.205 |
| hex: silesia/x-ray | 524290 | 15635.7 ± 0.2% | 1472.8 ± 0.4% | 1089.5 ± 0.6% | 445.6 ± 1.7% | 997.2 ± 0.5% | 733.2 ± 0.3% | 10.616 | 14.352 | 35.087 | 15.679 | 21.324 |
| hex: silesia/xml | 524290 | 15609.5 ± 0.4% | 1460.8 ± 0.4% | 1088.0 ± 0.5% | 615.1 ± 0.9% | 990.0 ± 0.4% | 732.2 ± 0.3% | 10.686 | 14.346 | 25.379 | 15.767 | 21.318 |
| hex: canterbury/alice29.txt | 304180 | 15575.7 ± 0.1% | 1468.6 ± 0.6% | 1091.8 ± 0.2% | 501.8 ± 0.3% | 990.6 ± 0.7% | 733.2 ± 0.4% | 10.606 | 14.266 | 31.041 | 15.724 | 21.243 |
| hex: canterbury/asyoulik.txt | 250360 | 15703.8 ± 0.1% | 1476.3 ± 0.5% | 1094.0 ± 0.5% | 497.8 ± 1.1% | 994.6 ± 0.4% | 739.5 ± 0.1% | 10.637 | 14.355 | 31.548 | 15.790 | 21.236 |
| hex: canterbury/cp.html | 49208 | 15619.8 ± 0.1% | 1471.3 ± 0.3% | 1097.7 ± 0.3% | 526.5 ± 3.2% | 1002.7 ± 0.6% | 743.2 ± 0.1% | 10.616 | 14.229 | 29.666 | 15.577 | 21.016 |
| hex: canterbury/fields.c | 22302 | 15437.1 ± 0.1% | 1408.9 ± 0.1% | 1066.3 ± 0.7% | 630.3 ± 6.2% | 985.5 ± 0.1% | 737.0 ± 0.2% | 10.957 | 14.478 | 24.491 | 15.664 | 20.947 |
| hex: canterbury/grammar.lsp | 7444 | 14924.8 ± 0.1% | 1503.0 ± 0.3% | 1090.7 ± 0.6% | 663.2 ± 4.4% | 995.1 ± 0.3% | 726.2 ± 0.1% | 9.930 | 13.684 | 22.504 | 14.998 | 20.553 |
| hex: canterbury/kennedy.xls | 524290 | 15488.3 ± 0.2% | 1473.5 ± 0.4% | 1087.2 ± 0.7% | 655.0 ± 1.8% | 994.5 ± 0.4% | 732.9 ± 0.6% | 10.511 | 14.247 | 23.645 | 15.573 | 21.132 |
| hex: canterbury/lcet10.txt | 524290 | 15622.1 ± 0.3% | 1462.8 ± 0.6% | 1084.2 ± 0.2% | 500.5 ± 0.7% | 988.7 ± 0.5% | 731.6 ± 0.4% | 10.680 | 14.409 | 31.212 | 15.801 | 21.353 |
| hex: canterbury/plrabn12.txt | 524290 | 15695.9 ± 0.2% | 1460.7 ± 0.2% | 1084.9 ± 0.2% | 495.2 ± 0.7% | 990.6 ± 0.3% | 734.2 ± 0.9% | 10.746 | 14.467 | 31.695 | 15.845 | 21.380 |
| hex: canterbury/ptt5 | 524290 | 15582.5 ± 0.3% | 1477.8 ± 0.3% | 1089.6 ± 0.4% | 554.4 ± 0.8% | 995.5 ± 0.4% | 732.1 ± 0.8% | 10.544 | 14.301 | 28.108 | 15.653 | 21.284 |
| hex: canterbury/sum | 76482 | 15638.6 ± 0.0% | 1494.2 ± 0.3% | 1104.5 ± 0.1% | 597.4 ± 1.8% | 998.3 ± 0.0% | 744.1 ± 0.6% | 10.466 | 14.159 | 26.179 | 15.665 | 21.016 |
| hex: canterbury/xargs.1 | 8456 | 14992.1 ± 0.1% | 1430.7 ± 0.5% | 1097.3 ± 0.6% | 662.4 ± 3.6% | 997.3 ± 0.3% | 727.7 ± 0.1% | 10.479 | 13.662 | 22.634 | 15.032 | 20.602 |
| hex: canterbury-large/E.coli | 524290 | 15574.2 ± 0.2% | 1470.6 ± 0.3% | 1089.7 ± 0.3% | 672.3 ± 0.3% | 993.4 ± 0.3% | 732.8 ± 0.1% | 10.590 | 14.292 | 23.165 | 15.678 | 21.252 |
| hex: canterbury-large/bible.txt | 524290 | 15630.7 ± 0.4% | 1457.5 ± 0.6% | 1081.0 ± 0.3% | 515.7 ± 0.6% | 987.4 ± 0.4% | 731.9 ± 0.7% | 10.724 | 14.459 | 30.308 | 15.831 | 21.356 |
| hex: canterbury-large/world192.txt | 524290 | 15626.2 ± 0.3% | 1464.2 ± 0.4% | 1085.5 ± 0.6% | 504.9 ± 1.1% | 988.8 ± 0.4% | 731.6 ± 0.5% | 10.672 | 14.395 | 30.951 | 15.803 | 21.360 |
| hex: http/html-1kx1024 | 2099200 | 13571.0 ± 0.9% | 1453.9 ± 0.2% | 1061.6 ± 0.2% | 500.8 ± 0.4% | 982.8 ± 0.2% | 692.1 ± 0.3% | 9.334 | 12.784 | 27.097 | 13.809 | 19.610 |
| hex: http/html-16kx64 | 2097280 | 15214.4 ± 0.3% | 1444.9 ± 0.1% | 1074.7 ± 0.1% | 507.3 ± 0.2% | 996.5 ± 0.1% | 734.3 ± 0.1% | 10.530 | 14.157 | 29.990 | 15.268 | 20.719 |
| hex: http/html-1m | 524290 | 15612.7 ± 0.4% | 1462.6 ± 0.2% | 1083.8 ± 0.4% | 501.4 ± 0.4% | 990.5 ± 0.4% | 732.0 ± 0.3% | 10.675 | 14.405 | 31.139 | 15.763 | 21.330 |
| hex: http/json-1kx1024 | 2099200 | 13624.8 ± 0.2% | 1463.6 ± 0.4% | 1066.6 ± 0.2% | 608.2 ± 0.5% | 986.8 ± 0.1% | 692.6 ± 0.0% | 9.309 | 12.774 | 22.401 | 13.808 | 19.672 |
| hex: http/json-16kx64 | 2097280 | 15184.0 ± 0.7% | 1446.2 ± 0.3% | 1074.5 ± 0.1% | 615.6 ± 0.8% | 995.7 ± 0.1% | 734.2 ± 0.1% | 10.499 | 14.131 | 24.666 | 15.250 | 20.680 |
| hex: http/json-1m | 524290 | 15626.6 ± 0.1% | 1469.8 ± 0.4% | 1087.6 ± 0.4% | 632.1 ± 0.6% | 993.4 ± 0.6% | 731.7 ± 0.2% | 10.632 | 14.368 | 24.721 | 15.730 | 21.355 |
| hex: http/js-1kx1024 | 2099200 | 13650.3 ± 0.4% | 1454.4 ± 0.1% | 1062.4 ± 0.3% | 499.3 ± 0.3% | 982.7 ± 0.1% | 692.6 ± 0.1% | 9.385 | 12.849 | 27.338 | 13.891 | 19.708 |
| hex: http/js-16kx64 | 2097280 | 15190.5 ± 0.3% | 1442.7 ± 0.1% | 1072.5 ± 0.2% | 505.3 ± 0.4% | 994.8 ± 0.2% | 734.4 ± 0.2% | 10.529 | 14.163 | 30.061 | 15.269 | 20.683 |
| hex: http/js-1m | 524290 | 15613.8 ± 0.3% | 1465.8 ± 0.3% | 1087.3 ± 0.2% | 512.8 ± 0.4% | 991.6 ± 0.1% | 732.6 ± 0.3% | 10.652 | 14.360 | 30.450 | 15.746 | 21.312 |
| hex: http/css-1kx1024 | 2099200 | 13609.6 ± 0.6% | 1453.9 ± 0.4% | 1062.5 ± 0.2% | 532.0 ± 0.2% | 983.3 ± 0.1% | 692.5 ± 0.8% | 9.361 | 12.809 | 25.582 | 13.841 | 19.652 |
| hex: http/css-16kx64 | 2097280 | 15231.6 ± 0.5% | 1441.2 ± 0.1% | 1074.0 ± 0.1% | 542.2 ± 0.5% | 999.1 ± 0.4% | 734.1 ± 0.2% | 10.568 | 14.182 | 28.090 | 15.245 | 20.749 |
| hex: http/css-1m | 524290 | 15664.0 ± 0.2% | 1461.2 ± 0.1% | 1087.3 ± 0.5% | 528.8 ± 0.6% | 991.4 ± 0.7% | 731.1 ± 0.7% | 10.720 | 14.406 | 29.619 | 15.800 | 21.424 |
| hex: shuffled/dickens-1m | 524290 | 15628.6 ± 0.2% | 1462.0 ± 0.4% | 1083.7 ± 0.4% | 501.8 ± 0.3% | 990.3 ± 0.7% | 731.9 ± 0.5% | 10.690 | 14.422 | 31.145 | 15.781 | 21.353 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1519.9 ± 0.6% | 1249.5 ± 0.4% | 1038.6 ± 0.7% | 409.7 ± 0.7% | 448.0 ± 0.3% | 415.5 ± 0.5% | 1.216 | 1.463 | 3.710 | 3.392 | 3.658 |
| qlog records, JSON text sequence | 1467503 | 1294.0 ± 0.2% | 1064.0 ± 0.3% | 783.6 ± 0.9% | 376.7 ± 1.2% | 469.0 ± 0.8% | 279.9 ± 0.2% | 1.216 | 1.651 | 3.435 | 2.759 | 4.624 |
| string: silesia/dickens | 172528 | 7138.3 ± 0.3% | 2812.7 ± 0.4% | 2936.3 ± 0.4% | 429.7 ± 0.7% | 1596.6 ± 0.3% | 1007.9 ± 0.2% | 2.538 | 2.431 | 16.612 | 4.471 | 7.082 |
| string: silesia/nci | 1075110 | 7327.1 ± 6.6% | 3393.9 ± 1.4% | 3092.4 ± 0.5% | 822.3 ± 1.9% | 1859.2 ± 0.4% | 1106.6 ± 0.3% | 2.159 | 2.369 | 8.910 | 3.941 | 6.621 |
| string: silesia/reymont | 1075159 | 3514.8 ± 1.8% | 1976.0 ± 2.0% | 2061.9 ± 0.5% | 449.8 ± 0.6% | 1508.4 ± 0.5% | 949.2 ± 0.4% | 1.779 | 1.705 | 7.815 | 2.330 | 3.703 |
| string: silesia/samba | 97582 | 4569.0 ± 1.1% | 2116.9 ± 0.7% | 3446.9 ± 0.5% | 354.0 ± 0.9% | 1437.5 ± 0.3% | 1055.5 ± 0.3% | 2.158 | 1.326 | 12.909 | 3.179 | 4.329 |
| string: silesia/webster | 1098490 | 4098.0 ± 0.5% | 1875.1 ± 0.6% | 2052.9 ± 0.4% | 439.5 ± 0.9% | 1393.3 ± 0.4% | 645.3 ± 0.4% | 2.185 | 1.996 | 9.324 | 2.941 | 6.351 |
| string: silesia/xml | 1090118 | 6219.5 ± 0.7% | 2856.9 ± 1.1% | 2648.2 ± 0.4% | 606.8 ± 0.9% | 1753.6 ± 0.5% | 918.3 ± 0.7% | 2.177 | 2.349 | 10.250 | 3.547 | 6.773 |
| string: canterbury/alice29.txt | 159425 | 6819.2 ± 1.7% | 2200.7 ± 0.6% | 2755.2 ± 1.0% | 407.2 ± 0.9% | 1476.9 ± 0.9% | 954.0 ± 0.5% | 3.099 | 2.475 | 16.747 | 4.617 | 7.148 |
| string: canterbury/asyoulik.txt | 132198 | 5873.2 ± 3.8% | 1716.2 ± 0.5% | 2362.5 ± 0.5% | 401.5 ± 0.7% | 1348.6 ± 1.0% | 884.7 ± 0.1% | 3.422 | 2.486 | 14.628 | 4.355 | 6.639 |
| string: canterbury/lcet10.txt | 441884 | 6232.2 ± 0.6% | 2547.5 ± 0.3% | 2511.0 ± 2.5% | 466.8 ± 0.9% | 1540.6 ± 0.3% | 982.1 ± 0.4% | 2.446 | 2.482 | 13.350 | 4.045 | 6.346 |
| string: canterbury/plrabn12.txt | 503330 | 5750.6 ± 0.4% | 2041.5 ± 0.4% | 2074.4 ± 0.5% | 423.4 ± 0.4% | 1428.5 ± 0.3% | 930.3 ± 0.5% | 2.817 | 2.772 | 13.582 | 4.026 | 6.181 |
| string: canterbury-large/E.coli | 1048578 | 19104.6 ± 1.0% | 9548.8 ± 1.0% | 3790.5 ± 0.3% | 1473.0 ± 0.7% | 2363.8 ± 0.4% | 1190.8 ± 0.1% | 2.001 | 5.040 | 12.970 | 8.082 | 16.043 |
| string: canterbury-large/bible.txt | 1055886 | 6788.5 ± 0.3% | 4116.5 ± 1.2% | 3019.3 ± 1.9% | 503.0 ± 0.9% | 1971.0 ± 0.5% | 1120.1 ± 1.3% | 1.649 | 2.248 | 13.497 | 3.444 | 6.060 |
| string: canterbury-large/world192.txt | 1103121 | 4031.9 ± 0.2% | 1651.7 ± 0.6% | 1994.4 ± 0.4% | 448.3 ± 0.4% | 1357.7 ± 0.3% | 906.7 ± 0.4% | 2.441 | 2.022 | 8.993 | 2.970 | 4.447 |
| string: http/html-1m | 1058582 | 6801.3 ± 0.2% | 3970.0 ± 0.6% | 3040.2 ± 0.8% | 500.5 ± 1.2% | 1913.0 ± 0.5% | 803.8 ± 0.3% | 1.713 | 2.237 | 13.588 | 3.555 | 8.461 |
| string: http/json-1m | 1190272 | 3291.8 ± 0.1% | 1347.5 ± 0.4% | 1552.7 ± 0.6% | 442.5 ± 0.6% | 960.5 ± 0.2% | 763.7 ± 0.3% | 2.443 | 2.120 | 7.439 | 3.427 | 4.310 |
| string: http/js-1m | 1144362 | 2806.5 ± 0.8% | 1176.5 ± 0.5% | 1627.1 ± 0.4% | 368.0 ± 0.2% | 1093.2 ± 0.2% | 757.9 ± 0.2% | 2.385 | 1.725 | 7.627 | 2.567 | 3.703 |
| string: http/css-1m | 1097820 | 4013.6 ± 0.9% | 1482.1 ± 0.6% | 2153.7 ± 0.7% | 494.1 ± 0.6% | 1369.6 ± 0.3% | 893.8 ± 0.4% | 2.708 | 1.864 | 8.124 | 2.930 | 4.490 |
| string: dickens as Cyrillic and CJK | 1883069 | 3069.6 ± 0.5% | 2346.5 ± 0.6% | 520.9 ± 0.4% | 307.0 ± 0.7% | 561.9 ± 1.4% | 335.9 ± 0.4% | 1.308 | 5.893 | 10.000 | 5.463 | 9.138 |
| hex: silesia/dickens | 524290 | 15672.8 ± 0.2% | 1459.3 ± 0.2% | 1082.2 ± 0.3% | 490.0 ± 1.2% | 991.9 ± 0.3% | 731.8 ± 0.5% | 10.740 | 14.483 | 31.983 | 15.801 | 21.417 |
| hex: silesia/mozilla | 524290 | 15559.0 ± 1.3% | 1467.2 ± 0.2% | 1089.3 ± 0.2% | 440.9 ± 0.1% | 993.6 ± 0.4% | 732.1 ± 1.5% | 10.605 | 14.283 | 35.285 | 15.659 | 21.254 |
| hex: silesia/mr | 524290 | 15644.3 ± 0.5% | 1479.2 ± 0.2% | 1091.1 ± 0.5% | 554.8 ± 3.0% | 993.0 ± 0.1% | 732.7 ± 0.8% | 10.576 | 14.339 | 28.198 | 15.755 | 21.351 |
| hex: silesia/nci | 524290 | 15647.9 ± 0.5% | 1466.1 ± 0.3% | 1086.6 ± 0.5% | 628.6 ± 3.5% | 994.5 ± 0.7% | 733.6 ± 0.5% | 10.673 | 14.401 | 24.894 | 15.734 | 21.330 |
| hex: silesia/ooffice | 524290 | 15501.9 ± 0.8% | 1464.5 ± 0.2% | 1083.2 ± 0.5% | 389.3 ± 0.4% | 991.5 ± 0.4% | 734.8 ± 0.4% | 10.585 | 14.312 | 39.823 | 15.635 | 21.097 |
| hex: silesia/osdb | 524290 | 15626.1 ± 0.5% | 1461.7 ± 0.5% | 1088.8 ± 0.6% | 464.6 ± 3.0% | 991.9 ± 0.5% | 731.4 ± 0.1% | 10.690 | 14.351 | 33.635 | 15.753 | 21.364 |
| hex: silesia/reymont | 524290 | 15649.7 ± 0.2% | 1462.8 ± 0.7% | 1085.0 ± 0.4% | 513.6 ± 0.7% | 988.4 ± 0.2% | 732.0 ± 0.8% | 10.699 | 14.424 | 30.471 | 15.833 | 21.379 |
| hex: silesia/samba | 524290 | 15593.6 ± 0.6% | 1464.6 ± 0.4% | 1083.8 ± 0.3% | 401.4 ± 0.7% | 992.1 ± 0.5% | 731.8 ± 0.6% | 10.647 | 14.388 | 38.848 | 15.718 | 21.309 |
| hex: silesia/sao | 524290 | 15567.4 ± 0.7% | 1463.3 ± 0.4% | 1084.0 ± 0.6% | 333.4 ± 0.3% | 990.4 ± 0.2% | 734.5 ± 0.9% | 10.639 | 14.361 | 46.694 | 15.718 | 21.196 |
| hex: silesia/webster | 524290 | 15465.3 ± 0.8% | 1459.6 ± 0.3% | 1083.2 ± 0.4% | 475.6 ± 0.9% | 989.3 ± 0.6% | 733.5 ± 0.5% | 10.595 | 14.277 | 32.519 | 15.633 | 21.084 |
| hex: silesia/x-ray | 524290 | 15625.8 ± 0.6% | 1472.8 ± 0.4% | 1089.5 ± 0.6% | 445.6 ± 1.7% | 997.2 ± 0.5% | 733.2 ± 0.3% | 10.610 | 14.343 | 35.065 | 15.669 | 21.311 |
| hex: silesia/xml | 524290 | 15565.8 ± 0.9% | 1460.8 ± 0.4% | 1088.0 ± 0.5% | 615.1 ± 0.9% | 990.0 ± 0.4% | 732.2 ± 0.3% | 10.656 | 14.306 | 25.307 | 15.723 | 21.258 |
| hex: canterbury/alice29.txt | 304180 | 15580.2 ± 0.1% | 1468.6 ± 0.6% | 1091.8 ± 0.2% | 501.8 ± 0.3% | 990.6 ± 0.7% | 733.2 ± 0.4% | 10.609 | 14.270 | 31.051 | 15.728 | 21.250 |
| hex: canterbury/asyoulik.txt | 250360 | 15717.5 ± 0.1% | 1476.3 ± 0.5% | 1094.0 ± 0.5% | 497.8 ± 1.1% | 994.6 ± 0.4% | 739.5 ± 0.1% | 10.647 | 14.367 | 31.576 | 15.803 | 21.254 |
| hex: canterbury/cp.html | 49208 | 15636.4 ± 0.0% | 1471.3 ± 0.3% | 1097.7 ± 0.3% | 526.5 ± 3.2% | 1002.7 ± 0.6% | 743.2 ± 0.1% | 10.627 | 14.244 | 29.697 | 15.594 | 21.038 |
| hex: canterbury/fields.c | 22302 | 15456.0 ± 0.0% | 1408.9 ± 0.1% | 1066.3 ± 0.7% | 630.3 ± 6.2% | 985.5 ± 0.1% | 737.0 ± 0.2% | 10.970 | 14.495 | 24.521 | 15.683 | 20.972 |
| hex: canterbury/grammar.lsp | 7444 | 14971.1 ± 0.5% | 1503.0 ± 0.3% | 1090.7 ± 0.6% | 663.2 ± 4.4% | 995.1 ± 0.3% | 726.2 ± 0.1% | 9.961 | 13.727 | 22.574 | 15.044 | 20.617 |
| hex: canterbury/kennedy.xls | 524290 | 15330.9 ± 1.2% | 1473.5 ± 0.4% | 1087.2 ± 0.7% | 655.0 ± 1.8% | 994.5 ± 0.4% | 732.9 ± 0.6% | 10.405 | 14.102 | 23.405 | 15.415 | 20.918 |
| hex: canterbury/lcet10.txt | 524290 | 15659.2 ± 0.3% | 1462.8 ± 0.6% | 1084.2 ± 0.2% | 500.5 ± 0.7% | 988.7 ± 0.5% | 731.6 ± 0.4% | 10.705 | 14.444 | 31.286 | 15.838 | 21.403 |
| hex: canterbury/plrabn12.txt | 524290 | 15625.4 ± 0.3% | 1460.7 ± 0.2% | 1084.9 ± 0.2% | 495.2 ± 0.7% | 990.6 ± 0.3% | 734.2 ± 0.9% | 10.697 | 14.402 | 31.552 | 15.774 | 21.283 |
| hex: canterbury/ptt5 | 524290 | 15642.9 ± 0.8% | 1477.8 ± 0.3% | 1089.6 ± 0.4% | 554.4 ± 0.8% | 995.5 ± 0.4% | 732.1 ± 0.8% | 10.585 | 14.357 | 28.217 | 15.714 | 21.366 |
| hex: canterbury/sum | 76482 | 15653.2 ± 0.0% | 1494.2 ± 0.3% | 1104.5 ± 0.1% | 597.4 ± 1.8% | 998.3 ± 0.0% | 744.1 ± 0.6% | 10.476 | 14.172 | 26.204 | 15.679 | 21.035 |
| hex: canterbury/xargs.1 | 8456 | 15037.6 ± 0.0% | 1430.7 ± 0.5% | 1097.3 ± 0.6% | 662.4 ± 3.6% | 997.3 ± 0.3% | 727.7 ± 0.1% | 10.511 | 13.704 | 22.703 | 15.078 | 20.664 |
| hex: canterbury-large/E.coli | 524290 | 15601.8 ± 1.2% | 1470.6 ± 0.3% | 1089.7 ± 0.3% | 672.3 ± 0.3% | 993.4 ± 0.3% | 732.8 ± 0.1% | 10.609 | 14.317 | 23.207 | 15.706 | 21.289 |
| hex: canterbury-large/bible.txt | 524290 | 15647.4 ± 0.3% | 1457.5 ± 0.6% | 1081.0 ± 0.3% | 515.7 ± 0.6% | 987.4 ± 0.4% | 731.9 ± 0.7% | 10.735 | 14.475 | 30.340 | 15.848 | 21.378 |
| hex: canterbury-large/world192.txt | 524290 | 15649.8 ± 0.2% | 1464.2 ± 0.4% | 1085.5 ± 0.6% | 504.9 ± 1.1% | 988.8 ± 0.4% | 731.6 ± 0.5% | 10.688 | 14.417 | 30.998 | 15.827 | 21.392 |
| hex: http/html-1kx1024 | 2099200 | 13819.5 ± 0.7% | 1453.9 ± 0.2% | 1061.6 ± 0.2% | 500.8 ± 0.4% | 982.8 ± 0.2% | 692.1 ± 0.3% | 9.505 | 13.018 | 27.593 | 14.062 | 19.969 |
| hex: http/html-16kx64 | 2097280 | 15255.9 ± 0.4% | 1444.9 ± 0.1% | 1074.7 ± 0.1% | 507.3 ± 0.2% | 996.5 ± 0.1% | 734.3 ± 0.1% | 10.558 | 14.196 | 30.071 | 15.310 | 20.776 |
| hex: http/html-1m | 524290 | 15579.9 ± 0.7% | 1462.6 ± 0.2% | 1083.8 ± 0.4% | 501.4 ± 0.4% | 990.5 ± 0.4% | 732.0 ± 0.3% | 10.652 | 14.375 | 31.074 | 15.730 | 21.285 |
| hex: http/json-1kx1024 | 2099200 | 13825.3 ± 0.5% | 1463.6 ± 0.4% | 1066.6 ± 0.2% | 608.2 ± 0.5% | 986.8 ± 0.1% | 692.6 ± 0.0% | 9.446 | 12.962 | 22.731 | 14.011 | 19.961 |
| hex: http/json-16kx64 | 2097280 | 15241.5 ± 0.5% | 1446.2 ± 0.3% | 1074.5 ± 0.1% | 615.6 ± 0.8% | 995.7 ± 0.1% | 734.2 ± 0.1% | 10.539 | 14.184 | 24.759 | 15.307 | 20.758 |
| hex: http/json-1m | 524290 | 15644.1 ± 0.5% | 1469.8 ± 0.4% | 1087.6 ± 0.4% | 632.1 ± 0.6% | 993.4 ± 0.6% | 731.7 ± 0.2% | 10.644 | 14.384 | 24.749 | 15.748 | 21.379 |
| hex: http/js-1kx1024 | 2099200 | 13787.3 ± 0.6% | 1454.4 ± 0.1% | 1062.4 ± 0.3% | 499.3 ± 0.3% | 982.7 ± 0.1% | 692.6 ± 0.1% | 9.480 | 12.978 | 27.613 | 14.031 | 19.906 |
| hex: http/js-16kx64 | 2097280 | 15225.7 ± 0.8% | 1442.7 ± 0.1% | 1072.5 ± 0.2% | 505.3 ± 0.4% | 994.8 ± 0.2% | 734.4 ± 0.2% | 10.553 | 14.196 | 30.131 | 15.305 | 20.731 |
| hex: http/js-1m | 524290 | 15510.5 ± 1.3% | 1465.8 ± 0.3% | 1087.3 ± 0.2% | 512.8 ± 0.4% | 991.6 ± 0.1% | 732.6 ± 0.3% | 10.581 | 14.265 | 30.248 | 15.642 | 21.171 |
| hex: http/css-1kx1024 | 2099200 | 13759.6 ± 0.3% | 1453.9 ± 0.4% | 1062.5 ± 0.2% | 532.0 ± 0.2% | 983.3 ± 0.1% | 692.5 ± 0.8% | 9.464 | 12.950 | 25.864 | 13.993 | 19.869 |
| hex: http/css-16kx64 | 2097280 | 15210.7 ± 0.4% | 1441.2 ± 0.1% | 1074.0 ± 0.1% | 542.2 ± 0.5% | 999.1 ± 0.4% | 734.1 ± 0.2% | 10.554 | 14.163 | 28.051 | 15.224 | 20.721 |
| hex: http/css-1m | 524290 | 15621.5 ± 0.2% | 1461.2 ± 0.1% | 1087.3 ± 0.5% | 528.8 ± 0.6% | 991.4 ± 0.7% | 731.1 ± 0.7% | 10.691 | 14.367 | 29.539 | 15.758 | 21.366 |
| hex: shuffled/dickens-1m | 524290 | 15646.8 ± 1.0% | 1462.0 ± 0.4% | 1083.7 ± 0.4% | 501.8 ± 0.3% | 990.3 ± 0.7% | 731.9 ± 0.5% | 10.702 | 14.439 | 31.181 | 15.800 | 21.378 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 936.6 ± 0.2% | 931.0 ± 0.5% | 1018.7 ± 0.2% | 300.8 ± 0.6% | 666.5 ± 0.2% | 309.9 ± 1.8% | 1.006 | 0.919 | 3.114 | 1.405 | 3.022 |
| qlog records, JSON text sequence | 1467503 | 778.5 ± 1.3% | 817.3 ± 0.1% | 770.3 ± 1.5% | 243.6 ± 1.0% | 693.7 ± 0.5% | 249.1 ± 0.6% | 0.953 | 1.011 | 3.196 | 1.122 | 3.125 |
| string: silesia/dickens | 172528 | 5046.5 ± 0.3% | 1878.0 ± 0.1% | 2646.3 ± 0.2% | 360.7 ± 0.8% | 2851.2 ± 0.3% | 548.3 ± 1.4% | 2.687 | 1.907 | 13.990 | 1.770 | 9.204 |
| string: silesia/nci | 1075110 | 4305.2 ± 0.6% | 2235.9 ± 0.5% | 2985.1 ± 0.5% | 543.4 ± 1.3% | 2990.0 ± 0.6% | 596.5 ± 1.7% | 1.926 | 1.442 | 7.922 | 1.440 | 7.218 |
| string: silesia/reymont | 1075159 | 2952.0 ± 1.4% | 1818.2 ± 2.1% | 2057.5 ± 0.2% | 373.8 ± 1.7% | 2141.3 ± 0.4% | 532.7 ± 0.3% | 1.624 | 1.435 | 7.898 | 1.379 | 5.541 |
| string: silesia/samba | 97582 | 3502.7 ± 0.3% | 2026.6 ± 0.9% | 2611.7 ± 0.4% | 328.3 ± 0.3% | 1497.4 ± 0.6% | 427.5 ± 2.1% | 1.728 | 1.341 | 10.669 | 2.339 | 8.194 |
| string: silesia/webster | 1098490 | 3673.9 ± 0.4% | 1516.3 ± 0.4% | 2008.5 ± 0.4% | 359.2 ± 0.5% | 2176.5 ± 0.4% | 480.7 ± 1.9% | 2.423 | 1.829 | 10.227 | 1.688 | 7.643 |
| string: silesia/xml | 1090118 | 4797.2 ± 0.3% | 2359.4 ± 0.4% | 2522.5 ± 0.4% | 453.2 ± 0.6% | 2851.2 ± 1.0% | 549.8 ± 0.8% | 2.033 | 1.902 | 10.585 | 1.682 | 8.725 |
| string: canterbury/alice29.txt | 159425 | 4337.5 ± 1.0% | 1599.6 ± 0.2% | 2457.3 ± 0.1% | 342.4 ± 0.5% | 2492.8 ± 0.3% | 502.9 ± 2.5% | 2.712 | 1.765 | 12.667 | 1.740 | 8.625 |
| string: canterbury/asyoulik.txt | 132198 | 3502.9 ± 0.4% | 1458.1 ± 0.3% | 2254.1 ± 0.9% | 331.8 ± 1.7% | 2073.7 ± 0.6% | 459.8 ± 2.4% | 2.402 | 1.554 | 10.559 | 1.689 | 7.618 |
| string: canterbury/lcet10.txt | 441884 | 5120.5 ± 0.5% | 1853.8 ± 0.3% | 2338.4 ± 0.5% | 389.7 ± 0.5% | 2823.5 ± 0.5% | 533.1 ± 1.4% | 2.762 | 2.190 | 13.141 | 1.814 | 9.605 |
| string: canterbury/plrabn12.txt | 503330 | 4140.7 ± 0.4% | 1736.9 ± 0.2% | 2054.8 ± 0.3% | 361.6 ± 0.7% | 2495.2 ± 0.6% | 492.7 ± 0.9% | 2.384 | 2.015 | 11.450 | 1.659 | 8.404 |
| string: canterbury-large/E.coli | 1048578 | 11909.5 ± 0.3% | 3607.5 ± 0.4% | 3246.9 ± 0.3% | 930.9 ± 0.8% | 5925.7 ± 0.9% | 742.6 ± 0.5% | 3.301 | 3.668 | 12.794 | 2.010 | 16.037 |
| string: canterbury-large/bible.txt | 1055886 | 6938.4 ± 0.9% | 2932.7 ± 0.3% | 2823.7 ± 0.8% | 419.1 ± 1.7% | 3735.0 ± 1.4% | 600.9 ± 1.2% | 2.366 | 2.457 | 16.554 | 1.858 | 11.546 |
| string: canterbury-large/world192.txt | 1103121 | 3395.1 ± 0.2% | 1482.3 ± 0.1% | 2006.6 ± 0.4% | 352.1 ± 0.2% | 2120.2 ± 0.5% | 489.7 ± 3.0% | 2.290 | 1.692 | 9.641 | 1.601 | 6.933 |
| string: http/html-1m | 1058582 | 6216.9 ± 1.8% | 2736.4 ± 0.5% | 2697.0 ± 0.4% | 441.8 ± 0.3% | 3473.0 ± 0.6% | 596.4 ± 0.8% | 2.272 | 2.305 | 14.072 | 1.790 | 10.424 |
| string: http/json-1m | 1190272 | 2557.9 ± 0.3% | 876.5 ± 0.2% | 2244.2 ± 0.3% | 390.2 ± 0.6% | 1063.8 ± 0.2% | 440.7 ± 0.4% | 2.918 | 1.140 | 6.556 | 2.404 | 5.804 |
| string: http/js-1m | 1144362 | 2287.5 ± 0.4% | 1028.8 ± 0.3% | 1637.3 ± 0.4% | 320.6 ± 0.2% | 1525.2 ± 0.5% | 417.4 ± 0.7% | 2.223 | 1.397 | 7.135 | 1.500 | 5.480 |
| string: http/css-1m | 1097820 | 2650.4 ± 0.5% | 1677.8 ± 0.3% | 2221.4 ± 0.8% | 403.9 ± 1.1% | 1955.2 ± 0.7% | 487.4 ± 0.8% | 1.580 | 1.193 | 6.562 | 1.356 | 5.438 |
| string: dickens as Cyrillic and CJK | 1883069 | 3080.5 ± 0.5% | 1686.1 ± 0.4% | 893.0 ± 0.1% | 351.4 ± 0.1% | 671.3 ± 0.4% | 156.7 ± 3.1% | 1.827 | 3.450 | 8.766 | 4.589 | 19.659 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.5 ± 0.3% | 980.5 ± 0.3% | 1198.4 ± 0.8% | 216.0 ± 0.2% | 468.7 ± 0.7% | 255.4 ± 2.4% | 1.356 | 1.109 | 6.156 | 2.836 | 5.206 |
| hex: silesia/dickens | 524290 | 11954.1 ± 0.2% | 3611.3 ± 0.2% | 3277.1 ± 0.4% | 515.7 ± 2.1% | 6052.4 ± 1.2% | 780.5 ± 2.1% | 3.310 | 3.648 | 23.182 | 1.975 | 15.315 |
| hex: silesia/mozilla | 524290 | 11981.7 ± 0.1% | 3613.3 ± 0.2% | 3298.5 ± 0.2% | 460.8 ± 0.5% | 6016.9 ± 1.5% | 781.3 ± 0.6% | 3.316 | 3.632 | 26.002 | 1.991 | 15.335 |
| hex: silesia/mr | 524290 | 11994.9 ± 0.1% | 3610.8 ± 0.4% | 3272.5 ± 0.3% | 565.1 ± 1.0% | 6131.3 ± 0.6% | 782.0 ± 0.4% | 3.322 | 3.665 | 21.225 | 1.956 | 15.340 |
| hex: silesia/nci | 524290 | 11938.4 ± 0.6% | 3612.1 ± 0.2% | 3281.9 ± 0.2% | 614.7 ± 2.5% | 5946.7 ± 0.6% | 779.4 ± 0.8% | 3.305 | 3.638 | 19.421 | 2.008 | 15.317 |
| hex: silesia/ooffice | 524290 | 11950.4 ± 0.1% | 3608.6 ± 0.3% | 3285.2 ± 0.4% | 405.9 ± 1.1% | 5963.4 ± 1.1% | 779.6 ± 0.5% | 3.312 | 3.638 | 29.443 | 2.004 | 15.329 |
| hex: silesia/osdb | 524290 | 11932.8 ± 0.1% | 3610.1 ± 0.2% | 3287.2 ± 0.3% | 491.6 ± 1.8% | 5959.1 ± 0.3% | 781.1 ± 0.2% | 3.305 | 3.630 | 24.273 | 2.002 | 15.278 |
| hex: silesia/reymont | 524290 | 11959.6 ± 0.3% | 3607.7 ± 0.7% | 3278.5 ± 0.4% | 521.9 ± 1.8% | 6071.7 ± 1.2% | 781.0 ± 0.5% | 3.315 | 3.648 | 22.915 | 1.970 | 15.312 |
| hex: silesia/samba | 524290 | 12002.1 ± 0.1% | 3609.7 ± 0.4% | 3290.5 ± 0.3% | 411.4 ± 2.0% | 6137.4 ± 0.8% | 780.5 ± 0.4% | 3.325 | 3.648 | 29.170 | 1.956 | 15.378 |
| hex: silesia/sao | 524290 | 11989.4 ± 0.1% | 3612.5 ± 0.3% | 3281.4 ± 0.4% | 343.4 ± 0.9% | 6089.0 ± 1.1% | 780.3 ± 0.6% | 3.319 | 3.654 | 34.910 | 1.969 | 15.364 |
| hex: silesia/webster | 524290 | 12020.5 ± 0.1% | 3608.8 ± 0.3% | 3289.9 ± 0.3% | 465.5 ± 1.0% | 6131.4 ± 1.4% | 780.7 ± 0.5% | 3.331 | 3.654 | 25.822 | 1.960 | 15.397 |
| hex: silesia/x-ray | 524290 | 12023.7 ± 0.0% | 3612.2 ± 0.1% | 3281.4 ± 0.2% | 475.3 ± 0.7% | 6082.8 ± 1.2% | 779.8 ± 0.5% | 3.329 | 3.664 | 25.300 | 1.977 | 15.420 |
| hex: silesia/xml | 524290 | 11991.0 ± 0.1% | 3615.0 ± 0.3% | 3292.1 ± 0.2% | 524.1 ± 1.1% | 6103.7 ± 1.2% | 780.4 ± 0.4% | 3.317 | 3.642 | 22.879 | 1.965 | 15.365 |
| hex: canterbury/alice29.txt | 304180 | 11893.4 ± 0.5% | 3641.0 ± 0.1% | 3322.6 ± 0.2% | 505.7 ± 0.7% | 6003.3 ± 1.7% | 779.1 ± 2.1% | 3.266 | 3.580 | 23.518 | 1.981 | 15.265 |
| hex: canterbury/asyoulik.txt | 250360 | 12006.2 ± 0.0% | 3641.9 ± 0.1% | 3376.5 ± 0.2% | 501.7 ± 0.7% | 6200.4 ± 0.6% | 776.5 ± 0.4% | 3.297 | 3.556 | 23.930 | 1.936 | 15.461 |
| hex: canterbury/cp.html | 49208 | 11925.0 ± 0.1% | 3639.0 ± 0.0% | 3284.4 ± 0.5% | 474.2 ± 0.7% | 6278.2 ± 1.1% | 766.4 ± 0.2% | 3.277 | 3.631 | 25.148 | 1.899 | 15.560 |
| hex: canterbury/fields.c | 22302 | 11777.0 ± 0.0% | 3628.9 ± 0.1% | 3402.5 ± 0.3% | 499.0 ± 0.6% | 6263.0 ± 0.2% | 745.5 ± 2.5% | 3.245 | 3.461 | 23.603 | 1.880 | 15.797 |
| hex: canterbury/grammar.lsp | 7444 | 11258.2 ± 0.1% | 3601.3 ± 0.0% | 3369.0 ± 0.4% | 532.4 ± 3.9% | 6186.3 ± 1.0% | 717.7 ± 1.6% | 3.126 | 3.342 | 21.146 | 1.820 | 15.686 |
| hex: canterbury/kennedy.xls | 524290 | 12018.2 ± 0.1% | 3604.9 ± 0.3% | 3286.6 ± 0.1% | 659.5 ± 1.6% | 6128.1 ± 1.4% | 768.0 ± 5.7% | 3.334 | 3.657 | 18.224 | 1.961 | 15.648 |
| hex: canterbury/lcet10.txt | 524290 | 11905.4 ± 0.1% | 3605.2 ± 0.8% | 3284.3 ± 0.5% | 509.6 ± 1.5% | 6091.9 ± 0.9% | 775.0 ± 1.3% | 3.302 | 3.625 | 23.362 | 1.954 | 15.362 |
| hex: canterbury/plrabn12.txt | 524290 | 12015.3 ± 0.1% | 3607.5 ± 0.1% | 3292.6 ± 0.3% | 502.4 ± 0.8% | 6143.6 ± 1.5% | 773.7 ± 0.9% | 3.331 | 3.649 | 23.914 | 1.956 | 15.530 |
| hex: canterbury/ptt5 | 524290 | 11998.9 ± 0.1% | 3603.0 ± 0.5% | 3286.7 ± 0.1% | 566.7 ± 0.3% | 6134.3 ± 2.3% | 771.2 ± 1.0% | 3.330 | 3.651 | 21.175 | 1.956 | 15.559 |
| hex: canterbury/sum | 76482 | 11916.1 ± 0.1% | 3632.6 ± 0.0% | 3363.7 ± 0.4% | 512.6 ± 1.7% | 6174.4 ± 0.4% | 769.0 ± 1.4% | 3.280 | 3.543 | 23.246 | 1.930 | 15.495 |
| hex: canterbury/xargs.1 | 8456 | 11348.5 ± 0.2% | 3602.2 ± 0.0% | 3363.9 ± 0.1% | 489.6 ± 2.2% | 6159.6 ± 0.3% | 746.3 ± 0.7% | 3.150 | 3.374 | 23.178 | 1.842 | 15.206 |
| hex: canterbury-large/E.coli | 524290 | 11965.3 ± 0.2% | 3609.3 ± 0.4% | 3273.8 ± 0.3% | 688.7 ± 0.1% | 6046.9 ± 1.2% | 754.3 ± 4.7% | 3.315 | 3.655 | 17.374 | 1.979 | 15.863 |
| hex: canterbury-large/bible.txt | 524290 | 12005.8 ± 0.1% | 3609.3 ± 0.2% | 3283.9 ± 0.4% | 526.3 ± 1.2% | 6147.1 ± 1.0% | 768.8 ± 1.6% | 3.326 | 3.656 | 22.810 | 1.953 | 15.616 |
| hex: canterbury-large/world192.txt | 524290 | 11985.2 ± 0.4% | 3609.0 ± 0.2% | 3275.6 ± 0.4% | 508.6 ± 0.6% | 6109.8 ± 0.7% | 766.3 ± 0.8% | 3.321 | 3.659 | 23.564 | 1.962 | 15.640 |
| hex: http/html-1kx1024 | 2099200 | 8612.3 ± 3.4% | 3462.7 ± 0.1% | 2821.4 ± 0.6% | 471.8 ± 1.1% | 5060.5 ± 1.1% | 631.7 ± 2.0% | 2.487 | 3.052 | 18.253 | 1.702 | 13.634 |
| hex: http/html-16kx64 | 2097280 | 11743.9 ± 0.3% | 3603.8 ± 0.1% | 3251.7 ± 0.2% | 473.5 ± 1.8% | 6021.1 ± 0.8% | 746.4 ± 6.0% | 3.259 | 3.612 | 24.801 | 1.950 | 15.734 |
| hex: http/html-1m | 524290 | 11905.5 ± 0.5% | 3594.0 ± 0.5% | 3263.5 ± 0.5% | 500.5 ± 2.3% | 6100.9 ± 1.8% | 764.1 ± 3.7% | 3.313 | 3.648 | 23.788 | 1.951 | 15.581 |
| hex: http/json-1kx1024 | 2099200 | 8645.9 ± 6.8% | 3459.2 ± 0.3% | 2827.4 ± 0.3% | 572.2 ± 1.3% | 5112.1 ± 1.0% | 631.5 ± 2.8% | 2.499 | 3.058 | 15.111 | 1.691 | 13.690 |
| hex: http/json-16kx64 | 2097280 | 11752.3 ± 0.2% | 3609.6 ± 0.2% | 3242.1 ± 0.2% | 574.1 ± 0.7% | 6010.4 ± 0.6% | 751.5 ± 4.8% | 3.256 | 3.625 | 20.472 | 1.955 | 15.639 |
| hex: http/json-1m | 524290 | 11990.8 ± 0.1% | 3595.7 ± 0.5% | 3286.8 ± 0.2% | 595.2 ± 1.1% | 6124.8 ± 2.2% | 765.8 ± 1.5% | 3.335 | 3.648 | 20.147 | 1.958 | 15.658 |
| hex: http/js-1kx1024 | 2099200 | 8672.8 ± 4.5% | 3463.9 ± 1.1% | 2831.9 ± 0.5% | 480.2 ± 0.5% | 5083.0 ± 0.3% | 637.6 ± 4.1% | 2.504 | 3.063 | 18.060 | 1.706 | 13.602 |
| hex: http/js-16kx64 | 2097280 | 11762.6 ± 0.1% | 3610.7 ± 0.1% | 3264.6 ± 0.1% | 480.4 ± 2.1% | 6015.7 ± 0.5% | 750.3 ± 2.6% | 3.258 | 3.603 | 24.483 | 1.955 | 15.677 |
| hex: http/js-1m | 524290 | 11949.2 ± 0.3% | 3608.8 ± 0.5% | 3285.2 ± 0.4% | 504.6 ± 2.9% | 6091.4 ± 0.7% | 751.2 ± 1.0% | 3.311 | 3.637 | 23.679 | 1.962 | 15.908 |
| hex: http/css-1kx1024 | 2099200 | 8688.7 ± 3.8% | 3463.0 ± 0.3% | 2828.5 ± 0.5% | 488.1 ± 0.5% | 5054.6 ± 1.3% | 640.3 ± 4.2% | 2.509 | 3.072 | 17.801 | 1.719 | 13.570 |
| hex: http/css-16kx64 | 2097280 | 11754.9 ± 0.4% | 3609.7 ± 0.1% | 3258.4 ± 0.2% | 495.2 ± 0.8% | 6010.0 ± 0.5% | 749.5 ± 1.5% | 3.256 | 3.608 | 23.737 | 1.956 | 15.683 |
| hex: http/css-1m | 524290 | 11951.9 ± 0.2% | 3606.6 ± 0.3% | 3286.6 ± 0.3% | 495.1 ± 2.4% | 6105.3 ± 1.4% | 751.0 ± 3.8% | 3.314 | 3.637 | 24.140 | 1.958 | 15.915 |
| hex: shuffled/dickens-1m | 524290 | 11890.3 ± 0.3% | 3612.5 ± 0.5% | 3285.9 ± 0.4% | 500.7 ± 3.2% | 6106.8 ± 2.2% | 770.4 ± 2.2% | 3.291 | 3.619 | 23.748 | 1.947 | 15.434 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1013.6 ± 0.2% | 931.0 ± 0.5% | 1018.7 ± 0.2% | 300.8 ± 0.6% | 666.5 ± 0.2% | 309.9 ± 1.8% | 1.089 | 0.995 | 3.370 | 1.521 | 3.271 |
| qlog records, JSON text sequence | 1467503 | 837.1 ± 0.4% | 817.3 ± 0.1% | 770.3 ± 1.5% | 243.6 ± 1.0% | 693.7 ± 0.5% | 249.1 ± 0.6% | 1.024 | 1.087 | 3.437 | 1.207 | 3.360 |
| string: silesia/dickens | 172528 | 5047.1 ± 0.2% | 1878.0 ± 0.1% | 2646.3 ± 0.2% | 360.7 ± 0.8% | 2851.2 ± 0.3% | 548.3 ± 1.4% | 2.688 | 1.907 | 13.992 | 1.770 | 9.205 |
| string: silesia/nci | 1075110 | 4298.5 ± 0.4% | 2235.9 ± 0.5% | 2985.1 ± 0.5% | 543.4 ± 1.3% | 2990.0 ± 0.6% | 596.5 ± 1.7% | 1.923 | 1.440 | 7.910 | 1.438 | 7.207 |
| string: silesia/reymont | 1075159 | 2959.7 ± 3.0% | 1818.2 ± 2.1% | 2057.5 ± 0.2% | 373.8 ± 1.7% | 2141.3 ± 0.4% | 532.7 ± 0.3% | 1.628 | 1.439 | 7.918 | 1.382 | 5.556 |
| string: silesia/samba | 97582 | 3512.7 ± 0.2% | 2026.6 ± 0.9% | 2611.7 ± 0.4% | 328.3 ± 0.3% | 1497.4 ± 0.6% | 427.5 ± 2.1% | 1.733 | 1.345 | 10.700 | 2.346 | 8.217 |
| string: silesia/webster | 1098490 | 3670.0 ± 0.4% | 1516.3 ± 0.4% | 2008.5 ± 0.4% | 359.2 ± 0.5% | 2176.5 ± 0.4% | 480.7 ± 1.9% | 2.420 | 1.827 | 10.216 | 1.686 | 7.635 |
| string: silesia/xml | 1090118 | 4804.2 ± 0.6% | 2359.4 ± 0.4% | 2522.5 ± 0.4% | 453.2 ± 0.6% | 2851.2 ± 1.0% | 549.8 ± 0.8% | 2.036 | 1.905 | 10.601 | 1.685 | 8.738 |
| string: canterbury/alice29.txt | 159425 | 4351.6 ± 0.8% | 1599.6 ± 0.2% | 2457.3 ± 0.1% | 342.4 ± 0.5% | 2492.8 ± 0.3% | 502.9 ± 2.5% | 2.720 | 1.771 | 12.708 | 1.746 | 8.653 |
| string: canterbury/asyoulik.txt | 132198 | 3507.6 ± 0.5% | 1458.1 ± 0.3% | 2254.1 ± 0.9% | 331.8 ± 1.7% | 2073.7 ± 0.6% | 459.8 ± 2.4% | 2.406 | 1.556 | 10.573 | 1.691 | 7.628 |
| string: canterbury/lcet10.txt | 441884 | 5136.4 ± 0.3% | 1853.8 ± 0.3% | 2338.4 ± 0.5% | 389.7 ± 0.5% | 2823.5 ± 0.5% | 533.1 ± 1.4% | 2.771 | 2.197 | 13.182 | 1.819 | 9.635 |
| string: canterbury/plrabn12.txt | 503330 | 4136.6 ± 0.3% | 1736.9 ± 0.2% | 2054.8 ± 0.3% | 361.6 ± 0.7% | 2495.2 ± 0.6% | 492.7 ± 0.9% | 2.382 | 2.013 | 11.438 | 1.658 | 8.396 |
| string: canterbury-large/E.coli | 1048578 | 11919.3 ± 0.2% | 3607.5 ± 0.4% | 3246.9 ± 0.3% | 930.9 ± 0.8% | 5925.7 ± 0.9% | 742.6 ± 0.5% | 3.304 | 3.671 | 12.804 | 2.011 | 16.051 |
| string: canterbury-large/bible.txt | 1055886 | 6979.9 ± 1.7% | 2932.7 ± 0.3% | 2823.7 ± 0.8% | 419.1 ± 1.7% | 3735.0 ± 1.4% | 600.9 ± 1.2% | 2.380 | 2.472 | 16.654 | 1.869 | 11.615 |
| string: canterbury-large/world192.txt | 1103121 | 3395.5 ± 0.4% | 1482.3 ± 0.1% | 2006.6 ± 0.4% | 352.1 ± 0.2% | 2120.2 ± 0.5% | 489.7 ± 3.0% | 2.291 | 1.692 | 9.642 | 1.601 | 6.934 |
| string: http/html-1m | 1058582 | 6223.2 ± 2.4% | 2736.4 ± 0.5% | 2697.0 ± 0.4% | 441.8 ± 0.3% | 3473.0 ± 0.6% | 596.4 ± 0.8% | 2.274 | 2.307 | 14.086 | 1.792 | 10.435 |
| string: http/json-1m | 1190272 | 2558.4 ± 0.3% | 876.5 ± 0.2% | 2244.2 ± 0.3% | 390.2 ± 0.6% | 1063.8 ± 0.2% | 440.7 ± 0.4% | 2.919 | 1.140 | 6.557 | 2.405 | 5.805 |
| string: http/js-1m | 1144362 | 2285.9 ± 0.5% | 1028.8 ± 0.3% | 1637.3 ± 0.4% | 320.6 ± 0.2% | 1525.2 ± 0.5% | 417.4 ± 0.7% | 2.222 | 1.396 | 7.130 | 1.499 | 5.476 |
| string: http/css-1m | 1097820 | 2654.1 ± 0.4% | 1677.8 ± 0.3% | 2221.4 ± 0.8% | 403.9 ± 1.1% | 1955.2 ± 0.7% | 487.4 ± 0.8% | 1.582 | 1.195 | 6.572 | 1.357 | 5.446 |
| string: dickens as Cyrillic and CJK | 1883069 | 3083.1 ± 0.5% | 1686.1 ± 0.4% | 893.0 ± 0.1% | 351.4 ± 0.1% | 671.3 ± 0.4% | 156.7 ± 3.1% | 1.829 | 3.453 | 8.774 | 4.593 | 19.676 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.1 ± 0.4% | 980.5 ± 0.3% | 1198.4 ± 0.8% | 216.0 ± 0.2% | 468.7 ± 0.7% | 255.4 ± 2.4% | 1.355 | 1.109 | 6.154 | 2.835 | 5.204 |
| hex: silesia/dickens | 524290 | 11964.9 ± 0.4% | 3611.3 ± 0.2% | 3277.1 ± 0.4% | 515.7 ± 2.1% | 6052.4 ± 1.2% | 780.5 ± 2.1% | 3.313 | 3.651 | 23.203 | 1.977 | 15.329 |
| hex: silesia/mozilla | 524290 | 11982.2 ± 0.2% | 3613.3 ± 0.2% | 3298.5 ± 0.2% | 460.8 ± 0.5% | 6016.9 ± 1.5% | 781.3 ± 0.6% | 3.316 | 3.633 | 26.003 | 1.991 | 15.336 |
| hex: silesia/mr | 524290 | 11993.1 ± 0.1% | 3610.8 ± 0.4% | 3272.5 ± 0.3% | 565.1 ± 1.0% | 6131.3 ± 0.6% | 782.0 ± 0.4% | 3.321 | 3.665 | 21.222 | 1.956 | 15.337 |
| hex: silesia/nci | 524290 | 11969.6 ± 0.5% | 3612.1 ± 0.2% | 3281.9 ± 0.2% | 614.7 ± 2.5% | 5946.7 ± 0.6% | 779.4 ± 0.8% | 3.314 | 3.647 | 19.472 | 2.013 | 15.357 |
| hex: silesia/ooffice | 524290 | 11979.1 ± 0.1% | 3608.6 ± 0.3% | 3285.2 ± 0.4% | 405.9 ± 1.1% | 5963.4 ± 1.1% | 779.6 ± 0.5% | 3.320 | 3.646 | 29.514 | 2.009 | 15.366 |
| hex: silesia/osdb | 524290 | 11975.0 ± 0.2% | 3610.1 ± 0.2% | 3287.2 ± 0.3% | 491.6 ± 1.8% | 5959.1 ± 0.3% | 781.1 ± 0.2% | 3.317 | 3.643 | 24.359 | 2.010 | 15.332 |
| hex: silesia/reymont | 524290 | 11948.7 ± 1.1% | 3607.7 ± 0.7% | 3278.5 ± 0.4% | 521.9 ± 1.8% | 6071.7 ± 1.2% | 781.0 ± 0.5% | 3.312 | 3.645 | 22.894 | 1.968 | 15.298 |
| hex: silesia/samba | 524290 | 11996.0 ± 0.1% | 3609.7 ± 0.4% | 3290.5 ± 0.3% | 411.4 ± 2.0% | 6137.4 ± 0.8% | 780.5 ± 0.4% | 3.323 | 3.646 | 29.156 | 1.955 | 15.370 |
| hex: silesia/sao | 524290 | 11929.9 ± 0.1% | 3612.5 ± 0.3% | 3281.4 ± 0.4% | 343.4 ± 0.9% | 6089.0 ± 1.1% | 780.3 ± 0.6% | 3.302 | 3.636 | 34.737 | 1.959 | 15.288 |
| hex: silesia/webster | 524290 | 12024.7 ± 0.2% | 3608.8 ± 0.3% | 3289.9 ± 0.3% | 465.5 ± 1.0% | 6131.4 ± 1.4% | 780.7 ± 0.5% | 3.332 | 3.655 | 25.831 | 1.961 | 15.402 |
| hex: silesia/x-ray | 524290 | 12025.5 ± 0.1% | 3612.2 ± 0.1% | 3281.4 ± 0.2% | 475.3 ± 0.7% | 6082.8 ± 1.2% | 779.8 ± 0.5% | 3.329 | 3.665 | 25.303 | 1.977 | 15.422 |
| hex: silesia/xml | 524290 | 11988.8 ± 0.1% | 3615.0 ± 0.3% | 3292.1 ± 0.2% | 524.1 ± 1.1% | 6103.7 ± 1.2% | 780.4 ± 0.4% | 3.316 | 3.642 | 22.874 | 1.964 | 15.362 |
| hex: canterbury/alice29.txt | 304180 | 11890.9 ± 0.4% | 3641.0 ± 0.1% | 3322.6 ± 0.2% | 505.7 ± 0.7% | 6003.3 ± 1.7% | 779.1 ± 2.1% | 3.266 | 3.579 | 23.513 | 1.981 | 15.262 |
| hex: canterbury/asyoulik.txt | 250360 | 12005.9 ± 0.1% | 3641.9 ± 0.1% | 3376.5 ± 0.2% | 501.7 ± 0.7% | 6200.4 ± 0.6% | 776.5 ± 0.4% | 3.297 | 3.556 | 23.929 | 1.936 | 15.461 |
| hex: canterbury/cp.html | 49208 | 11927.2 ± 0.1% | 3639.0 ± 0.0% | 3284.4 ± 0.5% | 474.2 ± 0.7% | 6278.2 ± 1.1% | 766.4 ± 0.2% | 3.278 | 3.631 | 25.152 | 1.900 | 15.563 |
| hex: canterbury/fields.c | 22302 | 11783.4 ± 0.0% | 3628.9 ± 0.1% | 3402.5 ± 0.3% | 499.0 ± 0.6% | 6263.0 ± 0.2% | 745.5 ± 2.5% | 3.247 | 3.463 | 23.616 | 1.881 | 15.806 |
| hex: canterbury/grammar.lsp | 7444 | 11312.5 ± 0.1% | 3601.3 ± 0.0% | 3369.0 ± 0.4% | 532.4 ± 3.9% | 6186.3 ± 1.0% | 717.7 ± 1.6% | 3.141 | 3.358 | 21.248 | 1.829 | 15.761 |
| hex: canterbury/kennedy.xls | 524290 | 12018.7 ± 0.1% | 3604.9 ± 0.3% | 3286.6 ± 0.1% | 659.5 ± 1.6% | 6128.1 ± 1.4% | 768.0 ± 5.7% | 3.334 | 3.657 | 18.225 | 1.961 | 15.648 |
| hex: canterbury/lcet10.txt | 524290 | 11954.9 ± 0.2% | 3605.2 ± 0.8% | 3284.3 ± 0.5% | 509.6 ± 1.5% | 6091.9 ± 0.9% | 775.0 ± 1.3% | 3.316 | 3.640 | 23.459 | 1.962 | 15.426 |
| hex: canterbury/plrabn12.txt | 524290 | 12014.4 ± 0.0% | 3607.5 ± 0.1% | 3292.6 ± 0.3% | 502.4 ± 0.8% | 6143.6 ± 1.5% | 773.7 ± 0.9% | 3.330 | 3.649 | 23.913 | 1.956 | 15.529 |
| hex: canterbury/ptt5 | 524290 | 11997.1 ± 0.1% | 3603.0 ± 0.5% | 3286.7 ± 0.1% | 566.7 ± 0.3% | 6134.3 ± 2.3% | 771.2 ± 1.0% | 3.330 | 3.650 | 21.171 | 1.956 | 15.556 |
| hex: canterbury/sum | 76482 | 11917.4 ± 0.0% | 3632.6 ± 0.0% | 3363.7 ± 0.4% | 512.6 ± 1.7% | 6174.4 ± 0.4% | 769.0 ± 1.4% | 3.281 | 3.543 | 23.248 | 1.930 | 15.497 |
| hex: canterbury/xargs.1 | 8456 | 11349.1 ± 0.0% | 3602.2 ± 0.0% | 3363.9 ± 0.1% | 489.6 ± 2.2% | 6159.6 ± 0.3% | 746.3 ± 0.7% | 3.151 | 3.374 | 23.180 | 1.843 | 15.207 |
| hex: canterbury-large/E.coli | 524290 | 11959.7 ± 0.2% | 3609.3 ± 0.4% | 3273.8 ± 0.3% | 688.7 ± 0.1% | 6046.9 ± 1.2% | 754.3 ± 4.7% | 3.314 | 3.653 | 17.366 | 1.978 | 15.856 |
| hex: canterbury-large/bible.txt | 524290 | 12005.7 ± 0.0% | 3609.3 ± 0.2% | 3283.9 ± 0.4% | 526.3 ± 1.2% | 6147.1 ± 1.0% | 768.8 ± 1.6% | 3.326 | 3.656 | 22.809 | 1.953 | 15.616 |
| hex: canterbury-large/world192.txt | 524290 | 11939.0 ± 0.3% | 3609.0 ± 0.2% | 3275.6 ± 0.4% | 508.6 ± 0.6% | 6109.8 ± 0.7% | 766.3 ± 0.8% | 3.308 | 3.645 | 23.473 | 1.954 | 15.580 |
| hex: http/html-1kx1024 | 2099200 | 8693.5 ± 3.9% | 3462.7 ± 0.1% | 2821.4 ± 0.6% | 471.8 ± 1.1% | 5060.5 ± 1.1% | 631.7 ± 2.0% | 2.511 | 3.081 | 18.425 | 1.718 | 13.763 |
| hex: http/html-16kx64 | 2097280 | 11752.1 ± 0.3% | 3603.8 ± 0.1% | 3251.7 ± 0.2% | 473.5 ± 1.8% | 6021.1 ± 0.8% | 746.4 ± 6.0% | 3.261 | 3.614 | 24.818 | 1.952 | 15.745 |
| hex: http/html-1m | 524290 | 11961.8 ± 0.1% | 3594.0 ± 0.5% | 3263.5 ± 0.5% | 500.5 ± 2.3% | 6100.9 ± 1.8% | 764.1 ± 3.7% | 3.328 | 3.665 | 23.900 | 1.961 | 15.654 |
| hex: http/json-1kx1024 | 2099200 | 8603.0 ± 6.6% | 3459.2 ± 0.3% | 2827.4 ± 0.3% | 572.2 ± 1.3% | 5112.1 ± 1.0% | 631.5 ± 2.8% | 2.487 | 3.043 | 15.036 | 1.683 | 13.622 |
| hex: http/json-16kx64 | 2097280 | 11761.4 ± 0.2% | 3609.6 ± 0.2% | 3242.1 ± 0.2% | 574.1 ± 0.7% | 6010.4 ± 0.6% | 751.5 ± 4.8% | 3.258 | 3.628 | 20.488 | 1.957 | 15.651 |
| hex: http/json-1m | 524290 | 11999.0 ± 0.1% | 3595.7 ± 0.5% | 3286.8 ± 0.2% | 595.2 ± 1.1% | 6124.8 ± 2.2% | 765.8 ± 1.5% | 3.337 | 3.651 | 20.160 | 1.959 | 15.668 |
| hex: http/js-1kx1024 | 2099200 | 8730.0 ± 4.4% | 3463.9 ± 1.1% | 2831.9 ± 0.5% | 480.2 ± 0.5% | 5083.0 ± 0.3% | 637.6 ± 4.1% | 2.520 | 3.083 | 18.179 | 1.717 | 13.692 |
| hex: http/js-16kx64 | 2097280 | 11759.5 ± 0.2% | 3610.7 ± 0.1% | 3264.6 ± 0.1% | 480.4 ± 2.1% | 6015.7 ± 0.5% | 750.3 ± 2.6% | 3.257 | 3.602 | 24.476 | 1.955 | 15.673 |
| hex: http/js-1m | 524290 | 11971.6 ± 0.5% | 3608.8 ± 0.5% | 3285.2 ± 0.4% | 504.6 ± 2.9% | 6091.4 ± 0.7% | 751.2 ± 1.0% | 3.317 | 3.644 | 23.724 | 1.965 | 15.938 |
| hex: http/css-1kx1024 | 2099200 | 8707.0 ± 5.0% | 3463.0 ± 0.3% | 2828.5 ± 0.5% | 488.1 ± 0.5% | 5054.6 ± 1.3% | 640.3 ± 4.2% | 2.514 | 3.078 | 17.839 | 1.723 | 13.599 |
| hex: http/css-16kx64 | 2097280 | 11767.2 ± 0.1% | 3609.7 ± 0.1% | 3258.4 ± 0.2% | 495.2 ± 0.8% | 6010.0 ± 0.5% | 749.5 ± 1.5% | 3.260 | 3.611 | 23.762 | 1.958 | 15.700 |
| hex: http/css-1m | 524290 | 11902.3 ± 0.2% | 3606.6 ± 0.3% | 3286.6 ± 0.3% | 495.1 ± 2.4% | 6105.3 ± 1.4% | 751.0 ± 3.8% | 3.300 | 3.621 | 24.040 | 1.950 | 15.849 |
| hex: shuffled/dickens-1m | 524290 | 11912.9 ± 0.6% | 3612.5 ± 0.5% | 3285.9 ± 0.4% | 500.7 ± 3.2% | 6106.8 ± 2.2% | 770.4 ± 2.2% | 3.298 | 3.625 | 23.793 | 1.951 | 15.463 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1355.4 ± 0.5% | 1249.5 ± 0.4% | 1038.6 ± 0.7% | 409.7 ± 0.7% | 448.0 ± 0.3% | 415.5 ± 0.5% | 1.085 | 1.305 | 3.308 | 3.025 | 3.262 |
| qlog records, JSON text sequence | 1467503 | 1052.6 ± 0.1% | 1064.0 ± 0.3% | 783.6 ± 0.9% | 376.7 ± 1.2% | 469.0 ± 0.8% | 279.9 ± 0.2% | 0.989 | 1.343 | 2.794 | 2.244 | 3.761 |
| string: silesia/dickens | 172528 | 6916.5 ± 0.2% | 2812.7 ± 0.4% | 2936.3 ± 0.4% | 429.7 ± 0.7% | 1596.6 ± 0.3% | 1007.9 ± 0.2% | 2.459 | 2.356 | 16.096 | 4.332 | 6.862 |
| string: silesia/nci | 1075110 | 7309.5 ± 0.8% | 3393.9 ± 1.4% | 3092.4 ± 0.5% | 822.3 ± 1.9% | 1859.2 ± 0.4% | 1106.6 ± 0.3% | 2.154 | 2.364 | 8.889 | 3.932 | 6.605 |
| string: silesia/reymont | 1075159 | 3343.9 ± 1.8% | 1976.0 ± 2.0% | 2061.9 ± 0.5% | 449.8 ± 0.6% | 1508.4 ± 0.5% | 949.2 ± 0.4% | 1.692 | 1.622 | 7.435 | 2.217 | 3.523 |
| string: silesia/samba | 97582 | 4205.1 ± 0.4% | 2116.9 ± 0.7% | 3446.9 ± 0.5% | 354.0 ± 0.9% | 1437.5 ± 0.3% | 1055.5 ± 0.3% | 1.986 | 1.220 | 11.880 | 2.925 | 3.984 |
| string: silesia/webster | 1098490 | 4076.8 ± 0.5% | 1875.1 ± 0.6% | 2052.9 ± 0.4% | 439.5 ± 0.9% | 1393.3 ± 0.4% | 645.3 ± 0.4% | 2.174 | 1.986 | 9.276 | 2.926 | 6.318 |
| string: silesia/xml | 1090118 | 6127.6 ± 3.3% | 2856.9 ± 1.1% | 2648.2 ± 0.4% | 606.8 ± 0.9% | 1753.6 ± 0.5% | 918.3 ± 0.7% | 2.145 | 2.314 | 10.098 | 3.494 | 6.673 |
| string: canterbury/alice29.txt | 159425 | 6444.5 ± 0.5% | 2200.7 ± 0.6% | 2755.2 ± 1.0% | 407.2 ± 0.9% | 1476.9 ± 0.9% | 954.0 ± 0.5% | 2.928 | 2.339 | 15.827 | 4.364 | 6.755 |
| string: canterbury/asyoulik.txt | 132198 | 5650.9 ± 0.6% | 1716.2 ± 0.5% | 2362.5 ± 0.5% | 401.5 ± 0.7% | 1348.6 ± 1.0% | 884.7 ± 0.1% | 3.293 | 2.392 | 14.074 | 4.190 | 6.387 |
| string: canterbury/lcet10.txt | 441884 | 6252.9 ± 0.2% | 2547.5 ± 0.3% | 2511.0 ± 2.5% | 466.8 ± 0.9% | 1540.6 ± 0.3% | 982.1 ± 0.4% | 2.454 | 2.490 | 13.395 | 4.059 | 6.367 |
| string: canterbury/plrabn12.txt | 503330 | 5705.7 ± 0.4% | 2041.5 ± 0.4% | 2074.4 ± 0.5% | 423.4 ± 0.4% | 1428.5 ± 0.3% | 930.3 ± 0.5% | 2.795 | 2.750 | 13.476 | 3.994 | 6.133 |
| string: canterbury-large/E.coli | 1048578 | 19089.4 ± 1.1% | 9548.8 ± 1.0% | 3790.5 ± 0.3% | 1473.0 ± 0.7% | 2363.8 ± 0.4% | 1190.8 ± 0.1% | 1.999 | 5.036 | 12.959 | 8.076 | 16.030 |
| string: canterbury-large/bible.txt | 1055886 | 6777.8 ± 0.4% | 4116.5 ± 1.2% | 3019.3 ± 1.9% | 503.0 ± 0.9% | 1971.0 ± 0.5% | 1120.1 ± 1.3% | 1.647 | 2.245 | 13.476 | 3.439 | 6.051 |
| string: canterbury-large/world192.txt | 1103121 | 4054.2 ± 0.2% | 1651.7 ± 0.6% | 1994.4 ± 0.4% | 448.3 ± 0.4% | 1357.7 ± 0.3% | 906.7 ± 0.4% | 2.455 | 2.033 | 9.043 | 2.986 | 4.471 |
| string: http/html-1m | 1058582 | 6741.5 ± 0.4% | 3970.0 ± 0.6% | 3040.2 ± 0.8% | 500.5 ± 1.2% | 1913.0 ± 0.5% | 803.8 ± 0.3% | 1.698 | 2.217 | 13.468 | 3.524 | 8.387 |
| string: http/json-1m | 1190272 | 3163.5 ± 0.5% | 1347.5 ± 0.4% | 1552.7 ± 0.6% | 442.5 ± 0.6% | 960.5 ± 0.2% | 763.7 ± 0.3% | 2.348 | 2.037 | 7.149 | 3.294 | 4.142 |
| string: http/js-1m | 1144362 | 2778.8 ± 0.8% | 1176.5 ± 0.5% | 1627.1 ± 0.4% | 368.0 ± 0.2% | 1093.2 ± 0.2% | 757.9 ± 0.2% | 2.362 | 1.708 | 7.551 | 2.542 | 3.667 |
| string: http/css-1m | 1097820 | 4004.5 ± 0.9% | 1482.1 ± 0.6% | 2153.7 ± 0.7% | 494.1 ± 0.6% | 1369.6 ± 0.3% | 893.8 ± 0.4% | 2.702 | 1.859 | 8.105 | 2.924 | 4.480 |
| string: dickens as Cyrillic and CJK | 1883069 | 3073.4 ± 0.4% | 2346.5 ± 0.6% | 520.9 ± 0.4% | 307.0 ± 0.7% | 561.9 ± 1.4% | 335.9 ± 0.4% | 1.310 | 5.900 | 10.012 | 5.470 | 9.149 |
| hex: silesia/dickens | 524290 | 15620.8 ± 0.6% | 1459.3 ± 0.2% | 1082.2 ± 0.3% | 490.0 ± 1.2% | 991.9 ± 0.3% | 731.8 ± 0.5% | 10.704 | 14.435 | 31.877 | 15.749 | 21.346 |
| hex: silesia/mozilla | 524290 | 15582.8 ± 1.0% | 1467.2 ± 0.2% | 1089.3 ± 0.2% | 440.9 ± 0.1% | 993.6 ± 0.4% | 732.1 ± 1.5% | 10.621 | 14.305 | 35.339 | 15.683 | 21.286 |
| hex: silesia/mr | 524290 | 15632.6 ± 0.7% | 1479.2 ± 0.2% | 1091.1 ± 0.5% | 554.8 ± 3.0% | 993.0 ± 0.1% | 732.7 ± 0.8% | 10.568 | 14.328 | 28.177 | 15.743 | 21.335 |
| hex: silesia/nci | 524290 | 15656.7 ± 0.5% | 1466.1 ± 0.3% | 1086.6 ± 0.5% | 628.6 ± 3.5% | 994.5 ± 0.7% | 733.6 ± 0.5% | 10.679 | 14.410 | 24.908 | 15.743 | 21.342 |
| hex: silesia/ooffice | 524290 | 15475.1 ± 0.8% | 1464.5 ± 0.2% | 1083.2 ± 0.5% | 389.3 ± 0.4% | 991.5 ± 0.4% | 734.8 ± 0.4% | 10.567 | 14.287 | 39.754 | 15.608 | 21.060 |
| hex: silesia/osdb | 524290 | 15604.4 ± 1.0% | 1461.7 ± 0.5% | 1088.8 ± 0.6% | 464.6 ± 3.0% | 991.9 ± 0.5% | 731.4 ± 0.1% | 10.675 | 14.331 | 33.588 | 15.731 | 21.334 |
| hex: silesia/reymont | 524290 | 15632.6 ± 0.3% | 1462.8 ± 0.7% | 1085.0 ± 0.4% | 513.6 ± 0.7% | 988.4 ± 0.2% | 732.0 ± 0.8% | 10.687 | 14.408 | 30.437 | 15.815 | 21.355 |
| hex: silesia/samba | 524290 | 15664.3 ± 0.4% | 1464.6 ± 0.4% | 1083.8 ± 0.3% | 401.4 ± 0.7% | 992.1 ± 0.5% | 731.8 ± 0.6% | 10.695 | 14.454 | 39.024 | 15.789 | 21.406 |
| hex: silesia/sao | 524290 | 15587.3 ± 0.5% | 1463.3 ± 0.4% | 1084.0 ± 0.6% | 333.4 ± 0.3% | 990.4 ± 0.2% | 734.5 ± 0.9% | 10.652 | 14.379 | 46.753 | 15.738 | 21.223 |
| hex: silesia/webster | 524290 | 15493.0 ± 0.6% | 1459.6 ± 0.3% | 1083.2 ± 0.4% | 475.6 ± 0.9% | 989.3 ± 0.6% | 733.5 ± 0.5% | 10.614 | 14.303 | 32.577 | 15.661 | 21.121 |
| hex: silesia/x-ray | 524290 | 15571.5 ± 0.9% | 1472.8 ± 0.4% | 1089.5 ± 0.6% | 445.6 ± 1.7% | 997.2 ± 0.5% | 733.2 ± 0.3% | 10.573 | 14.293 | 34.943 | 15.615 | 21.237 |
| hex: silesia/xml | 524290 | 15518.9 ± 0.7% | 1460.8 ± 0.4% | 1088.0 ± 0.5% | 615.1 ± 0.9% | 990.0 ± 0.4% | 732.2 ± 0.3% | 10.624 | 14.263 | 25.231 | 15.676 | 21.194 |
| hex: canterbury/alice29.txt | 304180 | 15583.0 ± 0.1% | 1468.6 ± 0.6% | 1091.8 ± 0.2% | 501.8 ± 0.3% | 990.6 ± 0.7% | 733.2 ± 0.4% | 10.611 | 14.273 | 31.056 | 15.731 | 21.253 |
| hex: canterbury/asyoulik.txt | 250360 | 15719.8 ± 0.0% | 1476.3 ± 0.5% | 1094.0 ± 0.5% | 497.8 ± 1.1% | 994.6 ± 0.4% | 739.5 ± 0.1% | 10.648 | 14.369 | 31.580 | 15.806 | 21.258 |
| hex: canterbury/cp.html | 49208 | 15668.6 ± 0.0% | 1471.3 ± 0.3% | 1097.7 ± 0.3% | 526.5 ± 3.2% | 1002.7 ± 0.6% | 743.2 ± 0.1% | 10.649 | 14.273 | 29.758 | 15.626 | 21.082 |
| hex: canterbury/fields.c | 22302 | 15518.6 ± 0.0% | 1408.9 ± 0.1% | 1066.3 ± 0.7% | 630.3 ± 6.2% | 985.5 ± 0.1% | 737.0 ± 0.2% | 11.015 | 14.554 | 24.620 | 15.747 | 21.057 |
| hex: canterbury/grammar.lsp | 7444 | 15133.3 ± 0.1% | 1503.0 ± 0.3% | 1090.7 ± 0.6% | 663.2 ± 4.4% | 995.1 ± 0.3% | 726.2 ± 0.1% | 10.069 | 13.875 | 22.819 | 15.207 | 20.840 |
| hex: canterbury/kennedy.xls | 524290 | 15336.7 ± 0.4% | 1473.5 ± 0.4% | 1087.2 ± 0.7% | 655.0 ± 1.8% | 994.5 ± 0.4% | 732.9 ± 0.6% | 10.409 | 14.107 | 23.414 | 15.421 | 20.926 |
| hex: canterbury/lcet10.txt | 524290 | 15631.0 ± 0.2% | 1462.8 ± 0.6% | 1084.2 ± 0.2% | 500.5 ± 0.7% | 988.7 ± 0.5% | 731.6 ± 0.4% | 10.686 | 14.418 | 31.230 | 15.810 | 21.365 |
| hex: canterbury/plrabn12.txt | 524290 | 15624.6 ± 0.4% | 1460.7 ± 0.2% | 1084.9 ± 0.2% | 495.2 ± 0.7% | 990.6 ± 0.3% | 734.2 ± 0.9% | 10.697 | 14.401 | 31.551 | 15.773 | 21.282 |
| hex: canterbury/ptt5 | 524290 | 15645.3 ± 0.4% | 1477.8 ± 0.3% | 1089.6 ± 0.4% | 554.4 ± 0.8% | 995.5 ± 0.4% | 732.1 ± 0.8% | 10.587 | 14.359 | 28.221 | 15.716 | 21.370 |
| hex: canterbury/sum | 76482 | 15676.9 ± 0.0% | 1494.2 ± 0.3% | 1104.5 ± 0.1% | 597.4 ± 1.8% | 998.3 ± 0.0% | 744.1 ± 0.6% | 10.492 | 14.194 | 26.244 | 15.703 | 21.067 |
| hex: canterbury/xargs.1 | 8456 | 15208.8 ± 0.1% | 1430.7 ± 0.5% | 1097.3 ± 0.6% | 662.4 ± 3.6% | 997.3 ± 0.3% | 727.7 ± 0.1% | 10.630 | 13.860 | 22.961 | 15.249 | 20.899 |
| hex: canterbury-large/E.coli | 524290 | 15591.4 ± 0.6% | 1470.6 ± 0.3% | 1089.7 ± 0.3% | 672.3 ± 0.3% | 993.4 ± 0.3% | 732.8 ± 0.1% | 10.602 | 14.308 | 23.191 | 15.695 | 21.275 |
| hex: canterbury-large/bible.txt | 524290 | 15642.4 ± 0.3% | 1457.5 ± 0.6% | 1081.0 ± 0.3% | 515.7 ± 0.6% | 987.4 ± 0.4% | 731.9 ± 0.7% | 10.732 | 14.470 | 30.331 | 15.843 | 21.372 |
| hex: canterbury-large/world192.txt | 524290 | 15666.0 ± 0.1% | 1464.2 ± 0.4% | 1085.5 ± 0.6% | 504.9 ± 1.1% | 988.8 ± 0.4% | 731.6 ± 0.5% | 10.699 | 14.432 | 31.030 | 15.844 | 21.414 |
| hex: http/html-1kx1024 | 2099200 | 14133.7 ± 0.9% | 1453.9 ± 0.2% | 1061.6 ± 0.2% | 500.8 ± 0.4% | 982.8 ± 0.2% | 692.1 ± 0.3% | 9.721 | 13.314 | 28.220 | 14.382 | 20.423 |
| hex: http/html-16kx64 | 2097280 | 15406.0 ± 0.8% | 1444.9 ± 0.1% | 1074.7 ± 0.1% | 507.3 ± 0.2% | 996.5 ± 0.1% | 734.3 ± 0.1% | 10.662 | 14.336 | 30.367 | 15.460 | 20.980 |
| hex: http/html-1m | 524290 | 15490.9 ± 0.8% | 1462.6 ± 0.2% | 1083.8 ± 0.4% | 501.4 ± 0.4% | 990.5 ± 0.4% | 732.0 ± 0.3% | 10.591 | 14.293 | 30.897 | 15.640 | 21.164 |
| hex: http/json-1kx1024 | 2099200 | 14101.8 ± 0.8% | 1463.6 ± 0.4% | 1066.6 ± 0.2% | 608.2 ± 0.5% | 986.8 ± 0.1% | 692.6 ± 0.0% | 9.635 | 13.221 | 23.185 | 14.291 | 20.361 |
| hex: http/json-16kx64 | 2097280 | 15388.4 ± 0.4% | 1446.2 ± 0.3% | 1074.5 ± 0.1% | 615.6 ± 0.8% | 995.7 ± 0.1% | 734.2 ± 0.1% | 10.641 | 14.321 | 24.998 | 15.455 | 20.958 |
| hex: http/json-1m | 524290 | 15652.8 ± 0.5% | 1469.8 ± 0.4% | 1087.6 ± 0.4% | 632.1 ± 0.6% | 993.4 ± 0.6% | 731.7 ± 0.2% | 10.650 | 14.392 | 24.763 | 15.756 | 21.391 |
| hex: http/js-1kx1024 | 2099200 | 14097.9 ± 0.9% | 1454.4 ± 0.1% | 1062.4 ± 0.3% | 499.3 ± 0.3% | 982.7 ± 0.1% | 692.6 ± 0.1% | 9.693 | 13.270 | 28.235 | 14.347 | 20.354 |
| hex: http/js-16kx64 | 2097280 | 15412.7 ± 0.4% | 1442.7 ± 0.1% | 1072.5 ± 0.2% | 505.3 ± 0.4% | 994.8 ± 0.2% | 734.4 ± 0.2% | 10.683 | 14.371 | 30.501 | 15.493 | 20.986 |
| hex: http/js-1m | 524290 | 15601.9 ± 1.0% | 1465.8 ± 0.3% | 1087.3 ± 0.2% | 512.8 ± 0.4% | 991.6 ± 0.1% | 732.6 ± 0.3% | 10.644 | 14.349 | 30.426 | 15.734 | 21.296 |
| hex: http/css-1kx1024 | 2099200 | 14111.3 ± 0.5% | 1453.9 ± 0.4% | 1062.5 ± 0.2% | 532.0 ± 0.2% | 983.3 ± 0.1% | 692.5 ± 0.8% | 9.706 | 13.281 | 26.526 | 14.351 | 20.377 |
| hex: http/css-16kx64 | 2097280 | 15351.0 ± 0.4% | 1441.2 ± 0.1% | 1074.0 ± 0.1% | 542.2 ± 0.5% | 999.1 ± 0.4% | 734.1 ± 0.2% | 10.651 | 14.294 | 28.310 | 15.364 | 20.912 |
| hex: http/css-1m | 524290 | 15663.3 ± 0.2% | 1461.2 ± 0.1% | 1087.3 ± 0.5% | 528.8 ± 0.6% | 991.4 ± 0.7% | 731.1 ± 0.7% | 10.720 | 14.406 | 29.618 | 15.800 | 21.423 |
| hex: shuffled/dickens-1m | 524290 | 15606.1 ± 1.2% | 1462.0 ± 0.4% | 1083.7 ± 0.4% | 501.8 ± 0.3% | 990.3 ± 0.7% | 731.9 ± 0.5% | 10.674 | 14.401 | 31.100 | 15.759 | 21.322 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.919 of yyjson.
