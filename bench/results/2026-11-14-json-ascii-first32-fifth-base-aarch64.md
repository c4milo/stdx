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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43616687779 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1130.1 ± 0.5% | 0.523 | 0.963 | 0.997 | 0.998 | 0.456 | 1.001 | 1.005 | 0.382 | 0.829 | 0.897 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 849.8 ± 1.5% | 0.821 | 1.000 | 1.001 | 1.001 | 0.447 | 0.996 | 1.030 | 0.395 | 0.925 | 0.989 | 0.126 |
| string: silesia/dickens | 172528 | 5051.8 ± 0.2% | 0.033 | 0.780 | 1.003 | 1.002 | 0.196 | 1.019 | 1.005 | 0.195 | 1.001 | 1.001 | 0.032 |
| string: silesia/nci | 1075110 | 4295.7 ± 0.6% | 0.039 | 0.802 | 1.004 | 1.003 | 0.278 | 1.007 | 0.998 | 0.280 | 1.003 | 1.005 | 0.038 |
| string: silesia/reymont | 1075159 | 2941.6 ± 1.2% | 0.057 | 0.813 | 0.997 | 0.995 | 0.358 | 1.002 | 1.006 | 0.358 | 1.004 | 1.003 | 0.056 |
| string: silesia/samba | 97582 | 3489.5 ± 0.2% | 0.041 | 0.861 | 1.002 | 1.004 | 0.070 | 0.779 | 1.011 | 0.067 | 1.003 | 1.004 | 0.040 |
| string: silesia/webster | 1098490 | 3640.7 ± 0.4% | 0.045 | 0.848 | 1.004 | 1.007 | 0.204 | 1.020 | 1.015 | 0.203 | 1.012 | 1.010 | 0.044 |
| string: silesia/xml | 1090118 | 4788.0 ± 0.6% | 0.035 | 0.808 | 1.005 | 1.007 | 0.221 | 0.976 | 1.004 | 0.219 | 1.007 | 1.008 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4307.7 ± 0.4% | 0.038 | 0.751 | 1.004 | 1.008 | 0.172 | 1.031 | 1.019 | 0.171 | 1.006 | 1.008 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3454.7 ± 1.3% | 0.046 | 0.747 | 1.006 | 1.010 | 0.176 | 1.007 | 0.971 | 0.176 | 1.011 | 1.014 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5128.2 ± 0.5% | 0.032 | 0.814 | 1.002 | 1.003 | 0.195 | 1.021 | 1.003 | 0.195 | 1.003 | 1.003 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4101.0 ± 0.6% | 0.040 | 0.829 | 1.007 | 1.007 | 0.199 | 1.016 | 1.002 | 0.198 | 1.008 | 1.009 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19316.4 ± 1.2% | 0.077 | 1.002 | 1.002 | 1.002 | 0.481 | 1.003 | 1.003 | 0.482 | 0.619 | 0.619 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6695.8 ± 0.6% | 0.026 | 0.801 | 0.999 | 1.004 | 0.431 | 1.029 | 1.039 | 0.432 | 1.033 | 1.037 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3395.8 ± 0.3% | 0.048 | 0.844 | 1.001 | 1.002 | 0.197 | 1.011 | 1.004 | 0.197 | 1.001 | 1.001 | 0.047 |
| string: http/html-1m | 1058582 | 6072.6 ± 1.6% | 0.028 | 0.783 | 1.017 | 1.040 | 0.388 | 1.042 | 1.050 | 0.388 | 1.024 | 1.026 | 0.028 |
| string: http/json-1m | 1190272 | 2545.1 ± 0.6% | 0.056 | 0.952 | 1.005 | 1.006 | 0.110 | 1.006 | 0.472 | 0.110 | 1.005 | 1.005 | 0.055 |
| string: http/js-1m | 1144362 | 2274.5 ± 0.4% | 0.067 | 0.892 | 1.004 | 1.003 | 0.175 | 1.059 | 1.050 | 0.175 | 1.002 | 1.005 | 0.066 |
| string: http/css-1m | 1097820 | 2641.4 ± 0.1% | 0.061 | 0.777 | 1.004 | 1.010 | 0.238 | 1.006 | 1.013 | 0.239 | 1.006 | 1.008 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3065.5 ± 0.3% | 0.044 | 0.125 | 1.005 | 1.002 | 0.335 | 1.005 | 1.010 | 0.336 | 1.004 | 1.004 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.9 ± 1.2% | 0.086 | 1.003 | 1.001 | 1.001 | 0.078 | 0.638 | 1.005 | 0.075 | 1.002 | 1.003 | 0.084 |
| hex: silesia/dickens | 524290 | 18670.1 ± 0.5% | 0.080 | 1.003 | 0.996 | 1.000 | 0.515 | 1.000 | 0.998 | 0.514 | 0.640 | 0.641 | 0.009 |
| hex: silesia/mozilla | 524290 | 19031.5 ± 1.3% | 0.078 | 1.000 | 0.992 | 0.994 | 0.501 | 0.991 | 0.998 | 0.502 | 0.632 | 0.632 | 0.009 |
| hex: silesia/mr | 524290 | 18786.3 ± 0.5% | 0.079 | 0.995 | 1.001 | 1.000 | 0.516 | 0.995 | 1.000 | 0.516 | 0.639 | 0.640 | 0.009 |
| hex: silesia/nci | 524290 | 18889.7 ± 0.3% | 0.079 | 1.002 | 0.997 | 0.996 | 0.499 | 1.003 | 1.000 | 0.499 | 0.634 | 0.632 | 0.009 |
| hex: silesia/ooffice | 524290 | 19014.3 ± 1.6% | 0.078 | 1.011 | 0.997 | 0.999 | 0.504 | 1.002 | 0.999 | 0.505 | 0.629 | 0.629 | 0.009 |
| hex: silesia/osdb | 524290 | 18865.9 ± 0.5% | 0.079 | 1.004 | 1.001 | 1.004 | 0.515 | 1.002 | 1.002 | 0.514 | 0.637 | 0.636 | 0.009 |
| hex: silesia/reymont | 524290 | 18889.9 ± 1.6% | 0.079 | 1.005 | 1.001 | 0.998 | 0.502 | 0.999 | 0.999 | 0.503 | 0.635 | 0.635 | 0.009 |
| hex: silesia/samba | 524290 | 18606.9 ± 1.0% | 0.080 | 1.000 | 0.996 | 0.997 | 0.518 | 1.001 | 1.000 | 0.517 | 0.642 | 0.644 | 0.009 |
| hex: silesia/sao | 524290 | 18902.4 ± 0.5% | 0.079 | 1.006 | 0.997 | 0.997 | 0.513 | 0.997 | 0.997 | 0.513 | 0.635 | 0.635 | 0.009 |
| hex: silesia/webster | 524290 | 18841.7 ± 0.5% | 0.079 | 1.005 | 1.003 | 1.004 | 0.511 | 1.006 | 1.002 | 0.509 | 0.636 | 0.633 | 0.009 |
| hex: silesia/x-ray | 524290 | 18737.2 ± 0.6% | 0.079 | 0.996 | 0.995 | 0.993 | 0.512 | 0.994 | 0.997 | 0.510 | 0.640 | 0.640 | 0.009 |
| hex: silesia/xml | 524290 | 18828.5 ± 0.4% | 0.079 | 1.012 | 1.009 | 1.003 | 0.507 | 1.007 | 1.002 | 0.507 | 0.635 | 0.633 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19124.0 ± 0.6% | 0.078 | 1.020 | 1.018 | 1.018 | 0.525 | 1.015 | 0.999 | 0.525 | 0.628 | 0.628 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19512.8 ± 0.1% | 0.077 | 1.002 | 1.002 | 1.002 | 0.513 | 0.991 | 1.002 | 0.511 | 0.615 | 0.615 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19316.4 ± 0.4% | 0.081 | 1.002 | 1.000 | 1.000 | 0.542 | 1.001 | 1.001 | 0.542 | 0.617 | 0.618 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18927.9 ± 0.3% | 0.083 | 1.002 | 1.003 | 1.003 | 0.534 | 1.001 | 0.999 | 0.540 | 0.623 | 0.623 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17568.1 ± 0.3% | 0.088 | 1.004 | 1.004 | 1.004 | 0.528 | 1.003 | 1.003 | 0.543 | 0.642 | 0.645 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18964.1 ± 1.2% | 0.079 | 1.000 | 0.995 | 0.996 | 0.512 | 0.998 | 0.998 | 0.513 | 0.633 | 0.633 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18907.8 ± 0.7% | 0.079 | 1.005 | 1.000 | 0.999 | 0.519 | 1.006 | 0.998 | 0.519 | 0.636 | 0.636 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18878.0 ± 0.3% | 0.079 | 1.002 | 0.999 | 0.998 | 0.506 | 1.002 | 1.001 | 0.506 | 0.635 | 0.635 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 18873.1 ± 0.7% | 0.079 | 1.006 | 1.004 | 1.004 | 0.512 | 1.003 | 1.008 | 0.513 | 0.636 | 0.637 | 0.009 |
| hex: canterbury/sum | 76482 | 19303.0 ± 0.1% | 0.078 | 1.001 | 1.002 | 1.002 | 0.518 | 1.002 | 1.001 | 0.519 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17823.6 ± 0.7% | 0.086 | 1.003 | 1.003 | 1.004 | 0.525 | 1.002 | 1.002 | 0.540 | 0.637 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 19116.2 ± 0.7% | 0.078 | 1.005 | 1.001 | 1.001 | 0.511 | 1.000 | 0.997 | 0.510 | 0.629 | 0.629 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18755.8 ± 0.5% | 0.080 | 1.005 | 1.002 | 1.004 | 0.527 | 1.003 | 1.000 | 0.525 | 0.640 | 0.640 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18606.0 ± 0.5% | 0.080 | 1.009 | 1.003 | 1.004 | 0.522 | 1.006 | 1.001 | 0.522 | 0.645 | 0.645 | 0.009 |
| hex: http/html-1kx1024 | 2099200 | 9698.3 ± 17.5% | 0.147 | 1.253 | 1.252 | 1.251 | 0.686 | 1.254 | 0.995 | 0.749 | 0.909 | 0.919 | 0.018 |
| hex: http/html-16kx64 | 2097280 | 18440.3 ± 1.2% | 0.080 | 1.012 | 1.010 | 1.010 | 0.556 | 1.009 | 0.996 | 0.561 | 0.638 | 0.639 | 0.009 |
| hex: http/html-1m | 524290 | 18664.0 ± 0.4% | 0.079 | 1.005 | 1.003 | 1.005 | 0.513 | 1.005 | 0.999 | 0.511 | 0.642 | 0.643 | 0.009 |
| hex: http/json-1kx1024 | 2099200 | 9665.4 ± 16.1% | 0.148 | 1.253 | 1.245 | 1.249 | 0.687 | 1.255 | 0.984 | 0.754 | 0.912 | 0.919 | 0.018 |
| hex: http/json-16kx64 | 2097280 | 18461.1 ± 1.1% | 0.081 | 1.007 | 1.007 | 1.006 | 0.555 | 1.008 | 0.992 | 0.560 | 0.637 | 0.638 | 0.009 |
| hex: http/json-1m | 524290 | 18770.3 ± 1.4% | 0.079 | 1.008 | 1.001 | 1.004 | 0.512 | 1.003 | 1.001 | 0.510 | 0.637 | 0.637 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 9592.6 ± 16.5% | 0.149 | 1.255 | 1.257 | 1.254 | 0.691 | 1.253 | 0.987 | 0.745 | 0.915 | 0.924 | 0.018 |
| hex: http/js-16kx64 | 2097280 | 18407.5 ± 0.5% | 0.082 | 1.011 | 1.008 | 1.009 | 0.556 | 1.008 | 0.991 | 0.560 | 0.638 | 0.639 | 0.009 |
| hex: http/js-1m | 524290 | 18981.9 ± 0.7% | 0.078 | 1.005 | 0.998 | 0.994 | 0.514 | 1.003 | 1.000 | 0.514 | 0.632 | 0.632 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9453.9 ± 18.8% | 0.152 | 1.293 | 1.287 | 1.283 | 0.700 | 1.295 | 1.000 | 0.759 | 0.933 | 0.941 | 0.018 |
| hex: http/css-16kx64 | 2097280 | 18469.6 ± 1.1% | 0.081 | 1.008 | 1.006 | 1.007 | 0.555 | 1.005 | 0.991 | 0.558 | 0.637 | 0.637 | 0.009 |
| hex: http/css-1m | 524290 | 18961.0 ± 1.4% | 0.078 | 1.005 | 1.000 | 0.992 | 0.506 | 0.997 | 0.996 | 0.505 | 0.632 | 0.632 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18693.6 ± 0.3% | 0.080 | 1.005 | 1.004 | 1.002 | 0.518 | 0.999 | 1.002 | 0.518 | 0.643 | 0.643 | 0.009 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1475.2 ± 2.1% | 0.446 | 1.001 | 0.971 | 1.007 | 1.009 | 0.269 | 1.000 | 0.549 | 0.917 | 0.089 | 1.030 |
| qlog records, JSON text sequence | 1467503 | 1263.2 ± 2.9% | 0.691 | 0.981 | 1.013 | 1.016 | 1.015 | 0.266 | 1.007 | 0.504 | 0.834 | 0.106 | 1.021 |
| string: silesia/dickens | 172528 | 6884.5 ± 0.7% | 0.025 | 1.002 | 1.004 | 1.003 | 1.002 | 0.165 | 0.718 | 1.002 | 1.004 | 0.025 | 1.036 |
| string: silesia/nci | 1075110 | 7287.4 ± 0.5% | 0.025 | 1.004 | 1.005 | 1.005 | 1.002 | 0.211 | 0.567 | 1.003 | 1.003 | 0.024 | 1.013 |
| string: silesia/reymont | 1075159 | 3327.6 ± 0.9% | 0.054 | 1.000 | 0.998 | 1.002 | 1.002 | 0.388 | 0.870 | 1.004 | 1.002 | 0.052 | 1.038 |
| string: silesia/samba | 97582 | 4180.3 ± 0.9% | 0.054 | 1.005 | 1.000 | 1.006 | 1.007 | 0.125 | 0.944 | 1.007 | 1.007 | 0.053 | 1.093 |
| string: silesia/webster | 1098490 | 4059.3 ± 0.6% | 0.043 | 1.008 | 1.009 | 1.009 | 1.006 | 0.209 | 0.887 | 0.999 | 1.003 | 0.042 | 1.010 |
| string: silesia/xml | 1090118 | 6119.7 ± 0.4% | 0.029 | 1.005 | 1.000 | 1.004 | 1.005 | 0.253 | 0.775 | 1.002 | 1.004 | 0.028 | 1.021 |
| string: canterbury/alice29.txt | 159425 | 6411.7 ± 1.6% | 0.027 | 1.010 | 1.013 | 1.014 | 1.015 | 0.131 | 0.654 | 1.005 | 1.006 | 0.027 | 1.055 |
| string: canterbury/asyoulik.txt | 132198 | 5619.3 ± 2.5% | 0.030 | 1.022 | 1.029 | 1.031 | 1.034 | 0.128 | 0.593 | 0.997 | 1.006 | 0.030 | 1.043 |
| string: canterbury/lcet10.txt | 441884 | 6241.8 ± 0.7% | 0.028 | 1.005 | 1.007 | 1.006 | 1.006 | 0.183 | 0.800 | 1.000 | 1.003 | 0.028 | 1.000 |
| string: canterbury/plrabn12.txt | 503330 | 5721.6 ± 0.4% | 0.030 | 1.002 | 1.001 | 1.001 | 1.002 | 0.167 | 0.697 | 1.000 | 1.001 | 0.030 | 1.002 |
| string: canterbury-large/E.coli | 1048578 | 19367.8 ± 0.2% | 0.077 | 1.002 | 1.003 | 1.004 | 1.002 | 0.480 | 1.002 | 1.001 | 1.002 | 0.009 | 1.003 |
| string: canterbury-large/bible.txt | 1055886 | 6792.6 ± 0.2% | 0.026 | 1.000 | 1.000 | 1.001 | 0.999 | 0.494 | 0.973 | 0.999 | 1.000 | 0.025 | 1.000 |
| string: canterbury-large/world192.txt | 1103121 | 4014.2 ± 0.4% | 0.043 | 1.020 | 1.020 | 1.020 | 1.021 | 0.191 | 0.834 | 1.005 | 1.012 | 0.043 | 1.004 |
| string: http/html-1m | 1058582 | 6734.6 ± 1.5% | 0.026 | 1.004 | 0.925 | 1.006 | 1.010 | 0.402 | 0.878 | 1.006 | 1.007 | 0.026 | 1.011 |
| string: http/json-1m | 1190272 | 3162.2 ± 0.5% | 0.051 | 1.004 | 0.969 | 1.001 | 1.004 | 0.132 | 0.371 | 1.001 | 1.001 | 0.051 | 1.044 |
| string: http/js-1m | 1144362 | 2760.4 ± 0.5% | 0.060 | 1.003 | 1.007 | 1.003 | 1.006 | 0.164 | 0.837 | 0.999 | 1.005 | 0.060 | 1.013 |
| string: http/css-1m | 1097820 | 3976.0 ± 0.5% | 0.043 | 1.007 | 1.006 | 1.009 | 1.009 | 0.207 | 0.647 | 1.001 | 1.006 | 0.042 | 1.012 |
| string: dickens as Cyrillic and CJK | 1883069 | 3066.3 ± 0.2% | 0.048 | 1.001 | 0.124 | 1.000 | 1.002 | 0.319 | 1.002 | 1.001 | 1.002 | 0.048 | 1.004 |
| hex: silesia/dickens | 524290 | 15589.4 ± 0.3% | 1.000 | 0.178 | 1.001 | 1.000 | 1.000 | 0.999 | 1.000 | 0.999 | 0.999 | 0.178 | 1.001 |
| hex: silesia/mozilla | 524290 | 15615.7 ± 0.4% | 1.003 | 0.178 | 1.002 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 1.000 | 0.178 | 1.002 |
| hex: silesia/mr | 524290 | 15678.6 ± 0.2% | 1.001 | 0.178 | 0.999 | 1.001 | 1.000 | 1.000 | 0.999 | 1.000 | 1.000 | 0.178 | 0.999 |
| hex: silesia/nci | 524290 | 15640.7 ± 0.3% | 1.002 | 0.178 | 0.997 | 1.002 | 1.001 | 1.000 | 1.000 | 1.000 | 0.999 | 0.178 | 1.000 |
| hex: silesia/ooffice | 524290 | 15622.9 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.000 | 1.001 | 1.001 | 1.000 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: silesia/osdb | 524290 | 15612.5 ± 0.2% | 1.002 | 0.178 | 0.998 | 1.001 | 1.000 | 0.999 | 0.999 | 0.998 | 0.999 | 0.178 | 0.999 |
| hex: silesia/reymont | 524290 | 15636.2 ± 0.2% | 1.002 | 0.177 | 1.001 | 1.002 | 1.000 | 0.997 | 0.999 | 0.999 | 0.999 | 0.177 | 1.000 |
| hex: silesia/samba | 524290 | 15619.1 ± 0.3% | 1.002 | 0.178 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 1.002 | 1.002 | 0.178 | 1.002 |
| hex: silesia/sao | 524290 | 15633.1 ± 0.2% | 1.001 | 0.177 | 1.002 | 1.002 | 1.002 | 1.001 | 1.002 | 1.002 | 1.001 | 0.177 | 1.002 |
| hex: silesia/webster | 524290 | 15619.8 ± 0.2% | 1.002 | 0.178 | 1.003 | 1.001 | 1.002 | 1.001 | 1.002 | 1.002 | 1.002 | 0.178 | 1.002 |
| hex: silesia/x-ray | 524290 | 15584.8 ± 0.1% | 1.002 | 0.179 | 1.000 | 1.001 | 1.001 | 0.999 | 1.000 | 0.998 | 0.998 | 0.179 | 0.997 |
| hex: silesia/xml | 524290 | 15616.3 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.002 | 1.002 | 1.001 | 1.002 | 0.178 | 1.000 |
| hex: canterbury/alice29.txt | 304180 | 15684.8 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15700.6 ± 0.0% | 1.001 | 0.177 | 1.001 | 1.000 | 1.001 | 1.000 | 1.000 | 1.000 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15617.7 ± 0.2% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.998 | 1.001 | 1.001 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15434.3 ± 0.2% | 1.002 | 0.181 | 1.001 | 1.000 | 1.000 | 0.995 | 1.001 | 1.002 | 1.006 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14934.3 ± 0.1% | 1.003 | 0.186 | 1.001 | 1.000 | 1.000 | 0.983 | 1.001 | 1.004 | 1.015 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15575.4 ± 0.4% | 1.001 | 0.178 | 1.002 | 1.001 | 1.002 | 1.000 | 1.002 | 1.000 | 1.001 | 0.179 | 1.002 |
| hex: canterbury/lcet10.txt | 524290 | 15633.1 ± 0.2% | 1.002 | 0.178 | 1.001 | 1.001 | 1.001 | 1.002 | 1.002 | 1.001 | 1.001 | 0.178 | 1.002 |
| hex: canterbury/plrabn12.txt | 524290 | 15590.9 ± 0.2% | 0.999 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 15642.9 ± 0.4% | 1.000 | 0.179 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 1.001 | 1.000 | 0.179 | 1.001 |
| hex: canterbury/sum | 76482 | 15639.3 ± 0.0% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 1.002 | 0.178 | 1.000 |
| hex: canterbury/xargs.1 | 8456 | 14991.3 ± 0.2% | 1.002 | 0.185 | 1.000 | 1.000 | 1.000 | 0.986 | 1.000 | 1.003 | 1.014 | 0.183 | 1.001 |
| hex: canterbury-large/E.coli | 524290 | 15684.4 ± 0.3% | 1.001 | 0.177 | 1.001 | 1.001 | 1.001 | 1.000 | 1.002 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury-large/bible.txt | 524290 | 15646.4 ± 0.2% | 1.001 | 0.177 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.000 | 0.177 | 1.001 |
| hex: canterbury-large/world192.txt | 524290 | 15655.5 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.000 | 0.999 | 1.001 | 1.001 | 1.002 | 1.001 | 0.178 | 1.001 |
| hex: http/html-1kx1024 | 2099200 | 13724.3 ± 0.3% | 1.004 | 0.195 | 1.000 | 0.999 | 0.999 | 0.939 | 1.001 | 1.010 | 1.039 | 0.187 | 1.008 |
| hex: http/html-16kx64 | 2097280 | 15261.1 ± 0.4% | 1.003 | 0.181 | 0.998 | 1.001 | 1.000 | 0.990 | 1.001 | 1.005 | 1.007 | 0.179 | 1.001 |
| hex: http/html-1m | 524290 | 15654.2 ± 0.2% | 1.001 | 0.177 | 1.001 | 1.001 | 1.002 | 1.001 | 1.002 | 1.001 | 1.001 | 0.177 | 1.002 |
| hex: http/json-1kx1024 | 2099200 | 13686.4 ± 0.4% | 1.006 | 0.195 | 1.004 | 1.001 | 1.001 | 0.941 | 1.001 | 1.011 | 1.039 | 0.187 | 1.009 |
| hex: http/json-16kx64 | 2097280 | 15252.8 ± 0.5% | 1.000 | 0.181 | 0.998 | 0.999 | 0.998 | 0.991 | 0.998 | 1.004 | 1.007 | 0.180 | 1.001 |
| hex: http/json-1m | 524290 | 15648.6 ± 0.2% | 1.001 | 0.177 | 1.001 | 1.001 | 1.000 | 0.999 | 0.999 | 0.999 | 0.999 | 0.177 | 0.999 |
| hex: http/js-1kx1024 | 2099200 | 13721.0 ± 0.1% | 1.006 | 0.195 | 1.002 | 1.000 | 1.000 | 0.938 | 0.999 | 1.010 | 1.034 | 0.187 | 1.008 |
| hex: http/js-16kx64 | 2097280 | 15270.1 ± 0.6% | 1.001 | 0.181 | 0.998 | 0.999 | 1.002 | 0.991 | 0.998 | 1.002 | 1.006 | 0.180 | 1.002 |
| hex: http/js-1m | 524290 | 15665.8 ± 0.2% | 1.003 | 0.177 | 1.002 | 1.002 | 1.001 | 1.002 | 1.001 | 1.002 | 1.002 | 0.177 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 13726.3 ± 0.3% | 1.003 | 0.194 | 0.997 | 1.000 | 1.000 | 0.935 | 0.998 | 1.005 | 1.036 | 0.186 | 1.012 |
| hex: http/css-16kx64 | 2097280 | 15239.3 ± 0.7% | 1.001 | 0.181 | 1.001 | 1.002 | 1.002 | 0.993 | 0.998 | 1.004 | 1.010 | 0.180 | 1.003 |
| hex: http/css-1m | 524290 | 15613.7 ± 0.2% | 1.000 | 0.177 | 0.999 | 0.997 | 0.999 | 0.998 | 0.996 | 0.997 | 0.998 | 0.177 | 0.997 |
| hex: shuffled/dickens-1m | 524290 | 15682.6 ± 0.1% | 1.002 | 0.177 | 1.001 | 1.001 | 1.001 | 0.999 | 1.002 | 1.001 | 1.000 | 0.177 | 1.002 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.059 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.253 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.252 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.251 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.254 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.253 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.245 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.249 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.255 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.255 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.257 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.254 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.253 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.293 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.287 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.283 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.295 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43342.9 ± 0.1% | 47417.3 ± 0.1% | 0.914 | — | — |
| string: silesia/nci | 1048576 | 36753.0 ± 1.4% | 39290.5 ± 2.7% | 0.935 | — | — |
| string: silesia/reymont | 1048576 | 36679.0 ± 1.2% | 39545.2 ± 1.6% | 0.928 | — | — |
| string: silesia/samba | 65546 | 43536.1 ± 0.0% | 48506.1 ± 0.1% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 40187.7 ± 6.6% | 44513.2 ± 4.7% | 0.903 | — | — |
| string: silesia/xml | 1048576 | 33509.3 ± 2.4% | 34606.6 ± 1.3% | 0.968 | — | — |
| string: canterbury/alice29.txt | 152089 | 35910.2 ± 0.0% | 36567.3 ± 0.1% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43335.8 ± 0.1% | 47657.2 ± 0.1% | 0.909 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36019.6 ± 0.1% | 36532.5 ± 0.5% | 0.986 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 43569.4 ± 0.2% | 47563.4 ± 0.4% | 0.916 | — | — |
| string: canterbury-large/E.coli | 1048576 | 37219.3 ± 1.8% | 39808.2 ± 1.5% | 0.935 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 33138.3 ± 2.9% | 34245.0 ± 0.7% | 0.968 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 33107.3 ± 2.0% | 34594.7 ± 2.1% | 0.957 | — | — |
| string: http/html-1m | 1048576 | 37146.6 ± 1.6% | 40193.5 ± 2.5% | 0.924 | — | — |
| string: http/json-1m | 1048576 | 31860.0 ± 2.0% | 34102.9 ± 1.8% | 0.934 | — | — |
| string: http/js-1m | 1048576 | 38077.0 ± 3.6% | 41709.0 ± 4.1% | 0.913 | — | — |
| string: http/css-1m | 1048576 | 37389.2 ± 4.2% | 40684.1 ± 3.8% | 0.919 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5771.0 ± 0.3% | 5654.0 ± 0.2% | 1.021 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.914 of simdutf.
- string: silesia/nci: stdx runs at 0.935 of simdutf.
- string: silesia/reymont: stdx runs at 0.928 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.903 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.909 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.916 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.935 of simdutf.
- string: http/html-1m: stdx runs at 0.924 of simdutf.
- string: http/json-1m: stdx runs at 0.934 of simdutf.
- string: http/js-1m: stdx runs at 0.913 of simdutf.
- string: http/css-1m: stdx runs at 0.919 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 41231.8 ± 1.8% | 45836.3 ± 2.5% | 0.900 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 33209.9 ± 2.2% | 34446.4 ± 1.1% | 0.964 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 36840.1 ± 2.9% | 39583.0 ± 2.6% | 0.931 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 38586.6 ± 2.9% | 41768.8 ± 2.1% | 0.924 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 37650.2 ± 2.1% | 40978.4 ± 2.2% | 0.919 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 37721.3 ± 2.8% | 41100.0 ± 1.3% | 0.918 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5763.5 ± 0.2% | 5650.7 ± 0.1% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5758.7 ± 0.2% | 5654.4 ± 0.1% | 1.018 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5762.8 ± 0.1% | 5649.6 ± 0.1% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5766.6 ± 0.1% | 5656.0 ± 0.1% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5769.4 ± 0.1% | 5658.7 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5765.3 ± 0.1% | 5654.4 ± 0.1% | 1.020 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1130.1 ± 0.5% | 931.2 ± 0.3% | 1026.2 ± 0.3% | 301.4 ± 0.8% | 665.8 ± 0.3% | 309.9 ± 1.7% | 1.214 | 1.101 | 3.749 | 1.697 | 3.646 |
| qlog records, JSON text sequence | 1467503 | 849.8 ± 1.5% | 817.3 ± 0.1% | 797.5 ± 1.9% | 242.9 ± 0.8% | 701.0 ± 0.7% | 251.5 ± 1.9% | 1.040 | 1.066 | 3.499 | 1.212 | 3.379 |
| string: silesia/dickens | 172528 | 5051.8 ± 0.2% | 1878.2 ± 0.3% | 2649.5 ± 0.4% | 361.7 ± 1.2% | 2872.6 ± 0.5% | 553.5 ± 2.6% | 2.690 | 1.907 | 13.968 | 1.759 | 9.126 |
| string: silesia/nci | 1075110 | 4295.7 ± 0.6% | 2242.0 ± 0.3% | 2997.9 ± 0.2% | 543.5 ± 1.0% | 3028.5 ± 0.5% | 603.8 ± 0.4% | 1.916 | 1.433 | 7.903 | 1.418 | 7.115 |
| string: silesia/reymont | 1075159 | 2941.6 ± 1.2% | 1805.6 ± 3.2% | 2063.5 ± 0.5% | 375.9 ± 0.3% | 2158.4 ± 0.4% | 537.8 ± 1.3% | 1.629 | 1.426 | 7.825 | 1.363 | 5.470 |
| string: silesia/samba | 97582 | 3489.5 ± 0.2% | 2023.8 ± 0.3% | 2617.5 ± 0.4% | 322.9 ± 0.3% | 1502.0 ± 0.8% | 429.0 ± 4.9% | 1.724 | 1.333 | 10.806 | 2.323 | 8.133 |
| string: silesia/webster | 1098490 | 3640.7 ± 0.4% | 1518.2 ± 0.4% | 2014.5 ± 0.4% | 359.6 ± 0.3% | 2190.5 ± 0.7% | 501.9 ± 1.1% | 2.398 | 1.807 | 10.123 | 1.662 | 7.253 |
| string: silesia/xml | 1090118 | 4788.0 ± 0.6% | 2358.1 ± 0.5% | 2530.3 ± 0.5% | 455.5 ± 1.2% | 2836.3 ± 1.0% | 565.4 ± 0.9% | 2.030 | 1.892 | 10.511 | 1.688 | 8.469 |
| string: canterbury/alice29.txt | 159425 | 4307.7 ± 0.4% | 1600.1 ± 0.3% | 2460.3 ± 0.4% | 342.7 ± 0.4% | 2516.4 ± 0.3% | 507.2 ± 1.6% | 2.692 | 1.751 | 12.569 | 1.712 | 8.492 |
| string: canterbury/asyoulik.txt | 132198 | 3454.7 ± 1.3% | 1458.9 ± 0.2% | 2249.2 ± 0.8% | 335.0 ± 1.1% | 2094.2 ± 0.4% | 461.0 ± 1.9% | 2.368 | 1.536 | 10.313 | 1.650 | 7.494 |
| string: canterbury/lcet10.txt | 441884 | 5128.2 ± 0.5% | 1853.3 ± 0.2% | 2333.8 ± 0.6% | 389.8 ± 0.8% | 2871.5 ± 0.6% | 536.1 ± 1.3% | 2.767 | 2.197 | 13.157 | 1.786 | 9.565 |
| string: canterbury/plrabn12.txt | 503330 | 4101.0 ± 0.6% | 1737.0 ± 0.1% | 2064.1 ± 0.2% | 360.4 ± 0.3% | 2509.6 ± 0.3% | 501.7 ± 1.0% | 2.361 | 1.987 | 11.378 | 1.634 | 8.174 |
| string: canterbury-large/E.coli | 1048578 | 19316.4 ± 1.2% | 3601.0 ± 0.4% | 3266.2 ± 0.4% | 935.2 ± 1.0% | 6025.3 ± 0.8% | 755.1 ± 1.7% | 5.364 | 5.914 | 20.656 | 3.206 | 25.580 |
| string: canterbury-large/bible.txt | 1055886 | 6695.8 ± 0.6% | 2942.1 ± 0.1% | 2835.9 ± 0.7% | 418.2 ± 2.0% | 3770.3 ± 0.9% | 620.0 ± 1.1% | 2.276 | 2.361 | 16.011 | 1.776 | 10.800 |
| string: canterbury-large/world192.txt | 1103121 | 3395.8 ± 0.3% | 1483.6 ± 0.1% | 2017.6 ± 0.5% | 353.1 ± 0.3% | 2130.4 ± 0.7% | 503.3 ± 0.8% | 2.289 | 1.683 | 9.617 | 1.594 | 6.748 |
| string: http/html-1m | 1058582 | 6072.6 ± 1.6% | 2737.1 ± 1.2% | 2702.0 ± 1.3% | 441.6 ± 0.7% | 3495.1 ± 0.4% | 601.1 ± 1.8% | 2.219 | 2.247 | 13.751 | 1.737 | 10.102 |
| string: http/json-1m | 1190272 | 2545.1 ± 0.6% | 875.9 ± 0.3% | 2253.3 ± 0.6% | 389.8 ± 0.5% | 1063.1 ± 0.3% | 444.9 ± 0.8% | 2.906 | 1.130 | 6.529 | 2.394 | 5.721 |
| string: http/js-1m | 1144362 | 2274.5 ± 0.4% | 1029.9 ± 0.4% | 1637.4 ± 0.2% | 321.0 ± 0.7% | 1526.4 ± 0.9% | 420.7 ± 0.9% | 2.209 | 1.389 | 7.087 | 1.490 | 5.407 |
| string: http/css-1m | 1097820 | 2641.4 ± 0.1% | 1680.3 ± 0.2% | 2227.2 ± 0.8% | 407.7 ± 1.1% | 1932.8 ± 0.6% | 489.9 ± 0.3% | 1.572 | 1.186 | 6.478 | 1.367 | 5.392 |
| string: dickens as Cyrillic and CJK | 1883069 | 3065.5 ± 0.3% | 1685.5 ± 0.5% | 893.4 ± 0.5% | 351.4 ± 0.2% | 667.1 ± 1.0% | 158.0 ± 1.6% | 1.819 | 3.431 | 8.724 | 4.595 | 19.397 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.9 ± 1.2% | 981.0 ± 0.2% | 1212.2 ± 0.7% | 213.5 ± 0.5% | 471.7 ± 0.8% | 256.5 ± 2.8% | 1.354 | 1.095 | 6.220 | 2.815 | 5.177 |
| hex: silesia/dickens | 524290 | 18670.1 ± 0.5% | 3622.0 ± 0.4% | 3292.3 ± 0.5% | 508.1 ± 0.8% | 6120.1 ± 0.7% | 783.4 ± 1.6% | 5.155 | 5.671 | 36.743 | 3.051 | 23.833 |
| hex: silesia/mozilla | 524290 | 19031.5 ± 1.3% | 3614.8 ± 0.3% | 3293.3 ± 0.7% | 453.7 ± 2.2% | 6156.8 ± 1.5% | 785.4 ± 0.4% | 5.265 | 5.779 | 41.947 | 3.091 | 24.233 |
| hex: silesia/mr | 524290 | 18786.3 ± 0.5% | 3619.0 ± 0.3% | 3293.6 ± 0.4% | 575.9 ± 1.1% | 6125.1 ± 1.5% | 785.9 ± 0.6% | 5.191 | 5.704 | 32.621 | 3.067 | 23.904 |
| hex: silesia/nci | 524290 | 18889.7 ± 0.3% | 3617.3 ± 0.2% | 3291.0 ± 0.2% | 627.1 ± 1.6% | 6096.0 ± 0.8% | 784.4 ± 0.5% | 5.222 | 5.740 | 30.122 | 3.099 | 24.080 |
| hex: silesia/ooffice | 524290 | 19014.3 ± 1.6% | 3619.3 ± 0.1% | 3294.7 ± 0.3% | 406.3 ± 1.2% | 6045.6 ± 0.5% | 784.3 ± 0.5% | 5.254 | 5.771 | 46.802 | 3.145 | 24.244 |
| hex: silesia/osdb | 524290 | 18865.9 ± 0.5% | 3619.8 ± 0.2% | 3297.3 ± 0.2% | 483.7 ± 2.9% | 6090.9 ± 0.2% | 785.2 ± 0.3% | 5.212 | 5.722 | 39.002 | 3.097 | 24.026 |
| hex: silesia/reymont | 524290 | 18889.9 ± 1.6% | 3617.5 ± 0.1% | 3296.0 ± 0.4% | 515.6 ± 1.8% | 6099.0 ± 1.2% | 786.4 ± 1.0% | 5.222 | 5.731 | 36.638 | 3.097 | 24.022 |
| hex: silesia/samba | 524290 | 18606.9 ± 1.0% | 3615.5 ± 0.3% | 3304.1 ± 0.2% | 409.7 ± 1.5% | 6082.9 ± 1.9% | 785.0 ± 0.7% | 5.146 | 5.631 | 45.418 | 3.059 | 23.702 |
| hex: silesia/sao | 524290 | 18902.4 ± 0.5% | 3616.1 ± 0.4% | 3308.0 ± 0.2% | 341.9 ± 0.7% | 6135.0 ± 1.0% | 783.2 ± 0.8% | 5.227 | 5.714 | 55.289 | 3.081 | 24.135 |
| hex: silesia/webster | 524290 | 18841.7 ± 0.5% | 3616.0 ± 0.2% | 3296.4 ± 0.3% | 466.1 ± 0.6% | 6102.4 ± 1.0% | 784.4 ± 0.4% | 5.211 | 5.716 | 40.421 | 3.088 | 24.022 |
| hex: silesia/x-ray | 524290 | 18737.2 ± 0.6% | 3620.5 ± 0.3% | 3301.1 ± 0.3% | 475.7 ± 0.5% | 6067.0 ± 1.2% | 785.8 ± 0.5% | 5.175 | 5.676 | 39.391 | 3.088 | 23.845 |
| hex: silesia/xml | 524290 | 18828.5 ± 0.4% | 3619.0 ± 0.6% | 3292.5 ± 0.5% | 522.1 ± 1.0% | 6113.8 ± 1.1% | 786.4 ± 0.4% | 5.203 | 5.719 | 36.061 | 3.080 | 23.944 |
| hex: canterbury/alice29.txt | 304180 | 19124.0 ± 0.6% | 3640.9 ± 0.2% | 3359.0 ± 0.2% | 510.8 ± 0.2% | 6113.5 ± 1.1% | 783.6 ± 0.5% | 5.252 | 5.693 | 37.440 | 3.128 | 24.404 |
| hex: canterbury/asyoulik.txt | 250360 | 19512.8 ± 0.1% | 3641.5 ± 0.2% | 3371.7 ± 0.4% | 504.6 ± 0.3% | 6176.9 ± 2.4% | 785.2 ± 0.7% | 5.358 | 5.787 | 38.670 | 3.159 | 24.850 |
| hex: canterbury/cp.html | 49208 | 19316.4 ± 0.4% | 3639.2 ± 0.2% | 3275.4 ± 0.0% | 480.0 ± 3.6% | 6273.7 ± 0.3% | 770.3 ± 1.6% | 5.308 | 5.897 | 40.243 | 3.079 | 25.076 |
| hex: canterbury/fields.c | 22302 | 18927.9 ± 0.3% | 3628.1 ± 0.3% | 3419.4 ± 0.1% | 511.6 ± 0.2% | 6256.5 ± 0.7% | 758.6 ± 2.3% | 5.217 | 5.535 | 36.997 | 3.025 | 24.951 |
| hex: canterbury/grammar.lsp | 7444 | 17568.1 ± 0.3% | 3600.8 ± 0.1% | 3350.0 ± 0.2% | 541.0 ± 4.3% | 6168.2 ± 0.5% | 729.6 ± 1.4% | 4.879 | 5.244 | 32.475 | 2.848 | 24.078 |
| hex: canterbury/kennedy.xls | 524290 | 18964.1 ± 1.2% | 3611.3 ± 0.3% | 3295.7 ± 0.2% | 656.1 ± 2.2% | 6126.0 ± 0.9% | 784.0 ± 6.7% | 5.251 | 5.754 | 28.906 | 3.096 | 24.187 |
| hex: canterbury/lcet10.txt | 524290 | 18907.8 ± 0.7% | 3613.9 ± 0.3% | 3293.1 ± 0.6% | 514.9 ± 0.3% | 6078.7 ± 1.5% | 786.5 ± 1.6% | 5.232 | 5.742 | 36.722 | 3.111 | 24.040 |
| hex: canterbury/plrabn12.txt | 524290 | 18878.0 ± 0.3% | 3614.4 ± 0.3% | 3300.0 ± 0.2% | 505.8 ± 0.4% | 6035.6 ± 2.3% | 783.8 ± 0.7% | 5.223 | 5.721 | 37.324 | 3.128 | 24.086 |
| hex: canterbury/ptt5 | 524290 | 18873.1 ± 0.7% | 3620.0 ± 0.1% | 3295.0 ± 0.3% | 559.1 ± 0.8% | 6136.5 ± 1.7% | 785.6 ± 0.4% | 5.214 | 5.728 | 33.759 | 3.076 | 24.025 |
| hex: canterbury/sum | 76482 | 19303.0 ± 0.1% | 3632.7 ± 0.0% | 3354.3 ± 0.1% | 508.1 ± 0.7% | 6173.4 ± 0.1% | 770.5 ± 1.5% | 5.314 | 5.755 | 37.993 | 3.127 | 25.051 |
| hex: canterbury/xargs.1 | 8456 | 17823.6 ± 0.7% | 3601.4 ± 0.1% | 3346.8 ± 0.2% | 490.7 ± 2.0% | 6148.5 ± 0.3% | 753.9 ± 1.8% | 4.949 | 5.326 | 36.324 | 2.899 | 23.643 |
| hex: canterbury-large/E.coli | 524290 | 19116.2 ± 0.7% | 3615.5 ± 0.2% | 3292.0 ± 0.3% | 688.2 ± 0.5% | 6160.4 ± 1.8% | 774.4 ± 2.3% | 5.287 | 5.807 | 27.776 | 3.103 | 24.684 |
| hex: canterbury-large/bible.txt | 524290 | 18755.8 ± 0.5% | 3615.1 ± 0.1% | 3304.1 ± 0.2% | 520.1 ± 1.0% | 6127.5 ± 0.9% | 784.9 ± 2.1% | 5.188 | 5.677 | 36.063 | 3.061 | 23.896 |
| hex: canterbury-large/world192.txt | 524290 | 18606.0 ± 0.5% | 3610.4 ± 0.3% | 3299.2 ± 0.5% | 494.9 ± 0.4% | 6141.0 ± 0.8% | 785.0 ± 0.4% | 5.153 | 5.640 | 37.595 | 3.030 | 23.703 |
| hex: http/html-1kx1024 | 2099200 | 9698.3 ± 17.5% | 3462.2 ± 0.1% | 2876.3 ± 1.2% | 476.2 ± 0.8% | 5126.5 ± 1.7% | 646.9 ± 1.9% | 2.801 | 3.372 | 20.368 | 1.892 | 14.993 |
| hex: http/html-16kx64 | 2097280 | 18440.3 ± 1.2% | 3613.6 ± 0.2% | 3270.3 ± 0.4% | 478.0 ± 0.6% | 6062.0 ± 0.7% | 750.4 ± 2.0% | 5.103 | 5.639 | 38.577 | 3.042 | 24.573 |
| hex: http/html-1m | 524290 | 18664.0 ± 0.4% | 3616.2 ± 0.1% | 3294.9 ± 0.2% | 501.4 ± 1.8% | 6065.5 ± 1.3% | 782.9 ± 1.2% | 5.161 | 5.665 | 37.221 | 3.077 | 23.839 |
| hex: http/json-1kx1024 | 2099200 | 9665.4 ± 16.1% | 3458.9 ± 0.2% | 2868.5 ± 0.8% | 577.2 ± 0.5% | 5139.3 ± 1.5% | 653.6 ± 1.4% | 2.794 | 3.369 | 16.744 | 1.881 | 14.788 |
| hex: http/json-16kx64 | 2097280 | 18461.1 ± 1.1% | 3612.0 ± 0.2% | 3253.0 ± 0.3% | 575.0 ± 0.6% | 6039.8 ± 0.7% | 754.2 ± 1.1% | 5.111 | 5.675 | 32.107 | 3.057 | 24.477 |
| hex: http/json-1m | 524290 | 18770.3 ± 1.4% | 3616.1 ± 0.5% | 3303.0 ± 0.3% | 594.8 ± 2.2% | 6077.0 ± 1.2% | 780.6 ± 2.7% | 5.191 | 5.683 | 31.559 | 3.089 | 24.045 |
| hex: http/js-1kx1024 | 2099200 | 9592.6 ± 16.5% | 3460.8 ± 0.3% | 2859.2 ± 1.1% | 481.6 ± 0.9% | 5108.5 ± 1.2% | 639.6 ± 5.4% | 2.772 | 3.355 | 19.916 | 1.878 | 14.999 |
| hex: http/js-16kx64 | 2097280 | 18407.5 ± 0.5% | 3608.4 ± 0.1% | 3264.0 ± 0.8% | 479.6 ± 0.8% | 6016.0 ± 0.6% | 743.1 ± 1.4% | 5.101 | 5.639 | 38.378 | 3.060 | 24.770 |
| hex: http/js-1m | 524290 | 18981.9 ± 0.7% | 3615.5 ± 0.1% | 3291.8 ± 0.2% | 502.4 ± 2.5% | 6090.3 ± 1.9% | 779.4 ± 3.3% | 5.250 | 5.766 | 37.786 | 3.117 | 24.354 |
| hex: http/css-1kx1024 | 2099200 | 9453.9 ± 18.8% | 3460.0 ± 0.3% | 2857.2 ± 0.4% | 488.7 ± 0.6% | 5134.8 ± 1.5% | 627.8 ± 2.0% | 2.732 | 3.309 | 19.344 | 1.841 | 15.060 |
| hex: http/css-16kx64 | 2097280 | 18469.6 ± 1.1% | 3608.7 ± 0.1% | 3262.1 ± 0.3% | 497.0 ± 1.6% | 6020.8 ± 0.1% | 743.2 ± 3.8% | 5.118 | 5.662 | 37.162 | 3.068 | 24.853 |
| hex: http/css-1m | 524290 | 18961.0 ± 1.4% | 3614.2 ± 0.3% | 3293.5 ± 0.2% | 494.4 ± 2.2% | 6103.3 ± 0.3% | 780.8 ± 3.6% | 5.246 | 5.757 | 38.350 | 3.107 | 24.285 |
| hex: shuffled/dickens-1m | 524290 | 18693.6 ± 0.3% | 3618.6 ± 0.1% | 3295.0 ± 0.2% | 510.0 ± 1.0% | 6127.3 ± 1.5% | 785.4 ± 0.2% | 5.166 | 5.673 | 36.653 | 3.051 | 23.801 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1475.2 ± 2.1% | 1248.4 ± 0.6% | 1037.8 ± 0.3% | 407.4 ± 0.6% | 448.1 ± 0.2% | 416.0 ± 0.4% | 1.182 | 1.421 | 3.621 | 3.292 | 3.546 |
| qlog records, JSON text sequence | 1467503 | 1263.2 ± 2.9% | 1064.9 ± 0.3% | 788.7 ± 0.3% | 378.7 ± 0.6% | 473.1 ± 0.7% | 279.6 ± 0.6% | 1.186 | 1.602 | 3.336 | 2.670 | 4.517 |
| string: silesia/dickens | 172528 | 6884.5 ± 0.7% | 2814.7 ± 0.5% | 2930.4 ± 0.4% | 430.1 ± 0.4% | 1561.9 ± 0.2% | 1009.1 ± 0.2% | 2.446 | 2.349 | 16.005 | 4.408 | 6.823 |
| string: silesia/nci | 1075110 | 7287.4 ± 0.5% | 3431.1 ± 0.4% | 3093.0 ± 0.3% | 818.9 ± 1.0% | 1836.7 ± 0.3% | 1109.0 ± 0.5% | 2.124 | 2.356 | 8.899 | 3.968 | 6.571 |
| string: silesia/reymont | 1075159 | 3327.6 ± 0.9% | 1989.5 ± 1.3% | 2054.6 ± 0.8% | 450.3 ± 0.5% | 1492.3 ± 0.3% | 950.5 ± 0.6% | 1.673 | 1.620 | 7.390 | 2.230 | 3.501 |
| string: silesia/samba | 97582 | 4180.3 ± 0.9% | 2110.7 ± 0.5% | 3450.8 ± 0.6% | 353.2 ± 0.9% | 1406.1 ± 0.4% | 1054.8 ± 0.2% | 1.981 | 1.211 | 11.834 | 2.973 | 3.963 |
| string: silesia/webster | 1098490 | 4059.3 ± 0.6% | 1879.6 ± 0.3% | 2051.3 ± 0.5% | 441.0 ± 0.3% | 1372.7 ± 0.3% | 648.2 ± 0.4% | 2.160 | 1.979 | 9.205 | 2.957 | 6.263 |
| string: silesia/xml | 1090118 | 6119.7 ± 0.4% | 2868.2 ± 0.2% | 2643.8 ± 0.3% | 608.0 ± 0.6% | 1734.3 ± 0.3% | 922.9 ± 0.5% | 2.134 | 2.315 | 10.065 | 3.529 | 6.631 |
| string: canterbury/alice29.txt | 159425 | 6411.7 ± 1.6% | 2194.5 ± 0.5% | 2760.9 ± 0.9% | 407.4 ± 1.1% | 1438.0 ± 0.2% | 957.3 ± 0.1% | 2.922 | 2.322 | 15.737 | 4.459 | 6.698 |
| string: canterbury/asyoulik.txt | 132198 | 5619.3 ± 2.5% | 1708.7 ± 0.6% | 2368.2 ± 0.9% | 402.0 ± 0.4% | 1308.5 ± 0.5% | 885.1 ± 0.1% | 3.289 | 2.373 | 13.980 | 4.294 | 6.349 |
| string: canterbury/lcet10.txt | 441884 | 6241.8 ± 0.7% | 2565.4 ± 0.2% | 2484.3 ± 1.5% | 465.1 ± 0.7% | 1524.9 ± 0.2% | 986.7 ± 0.9% | 2.433 | 2.512 | 13.422 | 4.093 | 6.326 |
| string: canterbury/plrabn12.txt | 503330 | 5721.6 ± 0.4% | 2057.4 ± 0.4% | 2068.1 ± 0.3% | 424.5 ± 0.7% | 1366.0 ± 0.3% | 935.1 ± 0.4% | 2.781 | 2.767 | 13.477 | 4.189 | 6.119 |
| string: canterbury-large/E.coli | 1048578 | 19367.8 ± 0.2% | 9843.1 ± 0.8% | 3780.6 ± 0.5% | 1473.6 ± 0.4% | 2366.1 ± 0.5% | 1193.8 ± 0.2% | 1.968 | 5.123 | 13.143 | 8.186 | 16.223 |
| string: canterbury-large/bible.txt | 1055886 | 6792.6 ± 0.2% | 4164.1 ± 0.4% | 3055.1 ± 2.0% | 503.4 ± 0.3% | 1978.0 ± 0.4% | 1121.7 ± 0.4% | 1.631 | 2.223 | 13.493 | 3.434 | 6.055 |
| string: canterbury-large/world192.txt | 1103121 | 4014.2 ± 0.4% | 1654.3 ± 0.4% | 1999.7 ± 1.2% | 448.9 ± 0.6% | 1345.1 ± 0.4% | 909.7 ± 0.1% | 2.426 | 2.007 | 8.943 | 2.984 | 4.413 |
| string: http/html-1m | 1058582 | 6734.6 ± 1.5% | 3963.4 ± 0.5% | 3040.9 ± 0.7% | 498.8 ± 0.4% | 1921.7 ± 0.4% | 807.3 ± 0.2% | 1.699 | 2.215 | 13.502 | 3.505 | 8.343 |
| string: http/json-1m | 1190272 | 3162.2 ± 0.5% | 1357.7 ± 0.1% | 1556.4 ± 0.4% | 442.8 ± 0.8% | 1035.4 ± 0.3% | 765.1 ± 0.7% | 2.329 | 2.032 | 7.141 | 3.054 | 4.133 |
| string: http/js-1m | 1144362 | 2760.4 ± 0.5% | 1180.7 ± 0.5% | 1621.5 ± 0.3% | 369.0 ± 0.4% | 1084.2 ± 0.1% | 758.5 ± 0.5% | 2.338 | 1.702 | 7.480 | 2.546 | 3.639 |
| string: http/css-1m | 1097820 | 3976.0 ± 0.5% | 1494.9 ± 0.3% | 2146.5 ± 1.1% | 494.2 ± 0.7% | 1355.1 ± 0.4% | 895.4 ± 0.3% | 2.660 | 1.852 | 8.045 | 2.934 | 4.440 |
| string: dickens as Cyrillic and CJK | 1883069 | 3066.3 ± 0.2% | 2334.6 ± 0.5% | 520.9 ± 1.1% | 307.1 ± 0.8% | 559.2 ± 0.7% | 336.4 ± 0.3% | 1.313 | 5.887 | 9.986 | 5.483 | 9.116 |
| hex: silesia/dickens | 524290 | 15589.4 ± 0.3% | 1462.2 ± 0.4% | 1083.0 ± 0.5% | 494.6 ± 2.8% | 985.7 ± 0.4% | 735.7 ± 1.8% | 10.661 | 14.394 | 31.518 | 15.815 | 21.191 |
| hex: silesia/mozilla | 524290 | 15615.7 ± 0.4% | 1479.6 ± 0.2% | 1091.7 ± 0.5% | 442.1 ± 0.5% | 993.7 ± 0.6% | 735.4 ± 0.4% | 10.554 | 14.304 | 35.318 | 15.715 | 21.234 |
| hex: silesia/mr | 524290 | 15678.6 ± 0.2% | 1479.8 ± 0.2% | 1093.7 ± 0.5% | 547.8 ± 2.4% | 991.3 ± 0.2% | 735.6 ± 0.4% | 10.595 | 14.336 | 28.619 | 15.816 | 21.314 |
| hex: silesia/nci | 524290 | 15640.7 ± 0.3% | 1474.8 ± 0.3% | 1090.4 ± 0.3% | 634.5 ± 4.8% | 990.6 ± 0.4% | 735.0 ± 0.2% | 10.605 | 14.343 | 24.650 | 15.789 | 21.278 |
| hex: silesia/ooffice | 524290 | 15622.9 ± 0.2% | 1462.9 ± 0.1% | 1085.3 ± 0.3% | 388.8 ± 0.3% | 986.2 ± 0.5% | 735.1 ± 0.2% | 10.679 | 14.394 | 40.178 | 15.842 | 21.253 |
| hex: silesia/osdb | 524290 | 15612.5 ± 0.2% | 1473.5 ± 0.2% | 1089.4 ± 0.2% | 469.1 ± 3.6% | 991.8 ± 0.4% | 735.4 ± 0.2% | 10.595 | 14.331 | 33.285 | 15.742 | 21.229 |
| hex: silesia/reymont | 524290 | 15636.2 ± 0.2% | 1459.6 ± 0.3% | 1086.2 ± 0.7% | 513.3 ± 1.1% | 989.2 ± 0.3% | 735.6 ± 0.3% | 10.713 | 14.395 | 30.464 | 15.807 | 21.257 |
| hex: silesia/samba | 524290 | 15619.1 ± 0.3% | 1467.9 ± 0.5% | 1086.0 ± 0.2% | 403.6 ± 0.6% | 991.9 ± 0.3% | 734.9 ± 0.4% | 10.641 | 14.383 | 38.701 | 15.747 | 21.253 |
| hex: silesia/sao | 524290 | 15633.1 ± 0.2% | 1463.2 ± 0.4% | 1085.8 ± 0.5% | 333.0 ± 0.1% | 987.8 ± 0.4% | 735.1 ± 0.4% | 10.684 | 14.397 | 46.950 | 15.826 | 21.266 |
| hex: silesia/webster | 524290 | 15619.8 ± 0.2% | 1468.3 ± 0.4% | 1086.0 ± 0.2% | 475.7 ± 0.8% | 991.4 ± 0.6% | 734.7 ± 0.6% | 10.638 | 14.383 | 32.838 | 15.756 | 21.261 |
| hex: silesia/x-ray | 524290 | 15584.8 ± 0.1% | 1473.3 ± 0.1% | 1092.8 ± 0.3% | 445.3 ± 0.8% | 996.0 ± 0.2% | 734.0 ± 0.4% | 10.578 | 14.262 | 35.002 | 15.648 | 21.233 |
| hex: silesia/xml | 524290 | 15616.3 ± 0.1% | 1470.3 ± 0.7% | 1086.9 ± 0.3% | 615.8 ± 0.6% | 991.5 ± 0.2% | 733.7 ± 0.3% | 10.621 | 14.367 | 25.358 | 15.751 | 21.283 |
| hex: canterbury/alice29.txt | 304180 | 15684.8 ± 0.1% | 1472.3 ± 0.1% | 1090.3 ± 0.2% | 502.8 ± 0.2% | 991.6 ± 0.4% | 735.4 ± 0.2% | 10.654 | 14.386 | 31.193 | 15.817 | 21.327 |
| hex: canterbury/asyoulik.txt | 250360 | 15700.6 ± 0.0% | 1475.7 ± 0.1% | 1091.9 ± 0.3% | 495.5 ± 1.3% | 993.3 ± 0.4% | 741.1 ± 0.2% | 10.639 | 14.379 | 31.685 | 15.806 | 21.186 |
| hex: canterbury/cp.html | 49208 | 15617.7 ± 0.2% | 1472.4 ± 0.1% | 1095.7 ± 0.4% | 527.6 ± 2.5% | 999.5 ± 0.1% | 742.7 ± 0.2% | 10.607 | 14.254 | 29.604 | 15.625 | 21.029 |
| hex: canterbury/fields.c | 22302 | 15434.3 ± 0.2% | 1398.6 ± 0.5% | 1059.7 ± 0.1% | 635.0 ± 6.6% | 976.2 ± 0.1% | 736.7 ± 0.2% | 11.036 | 14.565 | 24.304 | 15.810 | 20.951 |
| hex: canterbury/grammar.lsp | 7444 | 14934.3 ± 0.1% | 1508.4 ± 0.2% | 1090.2 ± 0.4% | 668.8 ± 3.4% | 979.2 ± 0.4% | 725.9 ± 0.2% | 9.901 | 13.698 | 22.329 | 15.251 | 20.573 |
| hex: canterbury/kennedy.xls | 524290 | 15575.4 ± 0.4% | 1478.1 ± 0.3% | 1088.2 ± 0.6% | 659.9 ± 1.8% | 990.2 ± 0.3% | 735.5 ± 0.3% | 10.537 | 14.313 | 23.604 | 15.729 | 21.176 |
| hex: canterbury/lcet10.txt | 524290 | 15633.1 ± 0.2% | 1467.8 ± 0.2% | 1086.0 ± 0.2% | 503.4 ± 0.3% | 987.3 ± 0.2% | 735.8 ± 0.5% | 10.651 | 14.395 | 31.056 | 15.834 | 21.248 |
| hex: canterbury/plrabn12.txt | 524290 | 15590.9 ± 0.2% | 1468.6 ± 0.1% | 1085.0 ± 1.1% | 493.3 ± 0.6% | 986.7 ± 0.3% | 735.1 ± 0.2% | 10.616 | 14.370 | 31.608 | 15.801 | 21.210 |
| hex: canterbury/ptt5 | 524290 | 15642.9 ± 0.4% | 1486.5 ± 0.6% | 1094.5 ± 0.1% | 553.3 ± 1.0% | 991.6 ± 0.2% | 735.7 ± 0.6% | 10.523 | 14.292 | 28.270 | 15.775 | 21.262 |
| hex: canterbury/sum | 76482 | 15639.3 ± 0.0% | 1494.2 ± 0.1% | 1103.7 ± 0.1% | 594.7 ± 2.2% | 997.9 ± 0.0% | 743.7 ± 0.3% | 10.467 | 14.170 | 26.298 | 15.672 | 21.030 |
| hex: canterbury/xargs.1 | 8456 | 14991.3 ± 0.2% | 1494.5 ± 1.1% | 1087.4 ± 0.4% | 667.8 ± 4.8% | 991.5 ± 0.4% | 728.4 ± 0.2% | 10.031 | 13.787 | 22.450 | 15.119 | 20.582 |
| hex: canterbury-large/E.coli | 524290 | 15684.4 ± 0.3% | 1476.9 ± 0.1% | 1090.5 ± 0.2% | 671.8 ± 0.3% | 992.9 ± 0.3% | 734.5 ± 0.3% | 10.620 | 14.383 | 23.347 | 15.797 | 21.353 |
| hex: canterbury-large/bible.txt | 524290 | 15646.4 ± 0.2% | 1467.4 ± 0.2% | 1082.9 ± 0.5% | 515.1 ± 0.3% | 986.5 ± 0.3% | 735.1 ± 0.8% | 10.663 | 14.449 | 30.377 | 15.860 | 21.286 |
| hex: canterbury-large/world192.txt | 524290 | 15655.5 ± 0.2% | 1467.7 ± 0.3% | 1082.7 ± 0.5% | 503.4 ± 0.7% | 988.7 ± 0.7% | 736.2 ± 0.7% | 10.667 | 14.460 | 31.099 | 15.834 | 21.266 |
| hex: http/html-1kx1024 | 2099200 | 13724.3 ± 0.3% | 1454.6 ± 0.3% | 1062.4 ± 0.3% | 502.0 ± 0.1% | 983.0 ± 0.4% | 692.7 ± 0.1% | 9.435 | 12.919 | 27.341 | 13.961 | 19.812 |
| hex: http/html-16kx64 | 2097280 | 15261.1 ± 0.4% | 1444.7 ± 0.7% | 1075.3 ± 0.1% | 508.5 ± 0.2% | 997.8 ± 0.1% | 735.0 ± 0.2% | 10.564 | 14.193 | 30.014 | 15.294 | 20.764 |
| hex: http/html-1m | 524290 | 15654.2 ± 0.2% | 1467.6 ± 0.2% | 1083.0 ± 0.3% | 502.2 ± 0.4% | 988.4 ± 0.1% | 735.0 ± 0.3% | 10.667 | 14.455 | 31.169 | 15.837 | 21.299 |
| hex: http/json-1kx1024 | 2099200 | 13686.4 ± 0.4% | 1463.8 ± 0.3% | 1066.9 ± 0.1% | 607.7 ± 0.4% | 986.9 ± 0.2% | 692.7 ± 0.3% | 9.350 | 12.828 | 22.521 | 13.868 | 19.757 |
| hex: http/json-16kx64 | 2097280 | 15252.8 ± 0.5% | 1445.0 ± 0.1% | 1074.7 ± 0.3% | 617.4 ± 0.4% | 994.7 ± 0.3% | 735.0 ± 0.3% | 10.555 | 14.193 | 24.703 | 15.334 | 20.752 |
| hex: http/json-1m | 524290 | 15648.6 ± 0.2% | 1477.8 ± 0.5% | 1089.1 ± 0.5% | 636.4 ± 1.1% | 992.0 ± 0.2% | 735.7 ± 0.3% | 10.589 | 14.368 | 24.588 | 15.774 | 21.270 |
| hex: http/js-1kx1024 | 2099200 | 13721.0 ± 0.1% | 1455.8 ± 0.1% | 1064.8 ± 0.2% | 499.6 ± 0.4% | 984.4 ± 0.3% | 692.8 ± 0.2% | 9.425 | 12.886 | 27.463 | 13.938 | 19.804 |
| hex: http/js-16kx64 | 2097280 | 15270.1 ± 0.6% | 1442.6 ± 0.1% | 1073.8 ± 0.2% | 505.7 ± 0.6% | 996.1 ± 0.1% | 734.4 ± 0.2% | 10.585 | 14.220 | 30.195 | 15.330 | 20.793 |
| hex: http/js-1m | 524290 | 15665.8 ± 0.2% | 1471.6 ± 0.2% | 1086.0 ± 0.4% | 512.5 ± 0.7% | 991.1 ± 0.4% | 735.4 ± 0.6% | 10.645 | 14.425 | 30.569 | 15.806 | 21.303 |
| hex: http/css-1kx1024 | 2099200 | 13726.3 ± 0.3% | 1455.2 ± 0.2% | 1063.0 ± 0.2% | 531.2 ± 0.3% | 983.1 ± 0.1% | 692.5 ± 0.2% | 9.433 | 12.913 | 25.840 | 13.962 | 19.821 |
| hex: http/css-16kx64 | 2097280 | 15239.3 ± 0.7% | 1440.5 ± 0.2% | 1075.6 ± 0.1% | 542.6 ± 0.7% | 995.6 ± 0.5% | 733.9 ± 0.2% | 10.579 | 14.168 | 28.086 | 15.307 | 20.766 |
| hex: http/css-1m | 524290 | 15613.7 ± 0.2% | 1468.9 ± 0.2% | 1084.5 ± 0.3% | 529.4 ± 0.3% | 987.9 ± 0.1% | 734.1 ± 0.2% | 10.630 | 14.397 | 29.492 | 15.806 | 21.270 |
| hex: shuffled/dickens-1m | 524290 | 15682.6 ± 0.1% | 1465.9 ± 0.5% | 1083.8 ± 0.3% | 501.9 ± 0.5% | 985.1 ± 0.1% | 736.0 ± 0.6% | 10.699 | 14.470 | 31.245 | 15.920 | 21.308 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1519.6 ± 0.5% | 1248.4 ± 0.6% | 1037.8 ± 0.3% | 407.4 ± 0.6% | 448.1 ± 0.2% | 416.0 ± 0.4% | 1.217 | 1.464 | 3.730 | 3.391 | 3.653 |
| qlog records, JSON text sequence | 1467503 | 1289.8 ± 0.3% | 1064.9 ± 0.3% | 788.7 ± 0.3% | 378.7 ± 0.6% | 473.1 ± 0.7% | 279.6 ± 0.6% | 1.211 | 1.635 | 3.406 | 2.726 | 4.612 |
| string: silesia/dickens | 172528 | 7129.4 ± 0.3% | 2814.7 ± 0.5% | 2930.4 ± 0.4% | 430.1 ± 0.4% | 1561.9 ± 0.2% | 1009.1 ± 0.2% | 2.533 | 2.433 | 16.575 | 4.565 | 7.065 |
| string: silesia/nci | 1075110 | 7379.8 ± 7.3% | 3431.1 ± 0.4% | 3093.0 ± 0.3% | 818.9 ± 1.0% | 1836.7 ± 0.3% | 1109.0 ± 0.5% | 2.151 | 2.386 | 9.012 | 4.018 | 6.654 |
| string: silesia/reymont | 1075159 | 3455.1 ± 1.8% | 1989.5 ± 1.3% | 2054.6 ± 0.8% | 450.3 ± 0.5% | 1492.3 ± 0.3% | 950.5 ± 0.6% | 1.737 | 1.682 | 7.673 | 2.315 | 3.635 |
| string: silesia/samba | 97582 | 4569.1 ± 0.6% | 2110.7 ± 0.5% | 3450.8 ± 0.6% | 353.2 ± 0.9% | 1406.1 ± 0.4% | 1054.8 ± 0.2% | 2.165 | 1.324 | 12.935 | 3.249 | 4.332 |
| string: silesia/webster | 1098490 | 4099.8 ± 0.6% | 1879.6 ± 0.3% | 2051.3 ± 0.5% | 441.0 ± 0.3% | 1372.7 ± 0.3% | 648.2 ± 0.4% | 2.181 | 1.999 | 9.297 | 2.987 | 6.325 |
| string: silesia/xml | 1090118 | 6251.0 ± 0.7% | 2868.2 ± 0.2% | 2643.8 ± 0.3% | 608.0 ± 0.6% | 1734.3 ± 0.3% | 922.9 ± 0.5% | 2.179 | 2.364 | 10.281 | 3.604 | 6.773 |
| string: canterbury/alice29.txt | 159425 | 6764.3 ± 1.8% | 2194.5 ± 0.5% | 2760.9 ± 0.9% | 407.4 ± 1.1% | 1438.0 ± 0.2% | 957.3 ± 0.1% | 3.082 | 2.450 | 16.602 | 4.704 | 7.066 |
| string: canterbury/asyoulik.txt | 132198 | 5860.8 ± 2.6% | 1708.7 ± 0.6% | 2368.2 ± 0.9% | 402.0 ± 0.4% | 1308.5 ± 0.5% | 885.1 ± 0.1% | 3.430 | 2.475 | 14.581 | 4.479 | 6.622 |
| string: canterbury/lcet10.txt | 441884 | 6244.3 ± 1.2% | 2565.4 ± 0.2% | 2484.3 ± 1.5% | 465.1 ± 0.7% | 1524.9 ± 0.2% | 986.7 ± 0.9% | 2.434 | 2.513 | 13.427 | 4.095 | 6.329 |
| string: canterbury/plrabn12.txt | 503330 | 5733.2 ± 0.3% | 2057.4 ± 0.4% | 2068.1 ± 0.3% | 424.5 ± 0.7% | 1366.0 ± 0.3% | 935.1 ± 0.4% | 2.787 | 2.772 | 13.505 | 4.197 | 6.131 |
| string: canterbury-large/E.coli | 1048578 | 19433.3 ± 0.4% | 9843.1 ± 0.8% | 3780.6 ± 0.5% | 1473.6 ± 0.4% | 2366.1 ± 0.5% | 1193.8 ± 0.2% | 1.974 | 5.140 | 13.188 | 8.213 | 16.278 |
| string: canterbury-large/bible.txt | 1055886 | 6794.7 ± 0.4% | 4164.1 ± 0.4% | 3055.1 ± 2.0% | 503.4 ± 0.3% | 1978.0 ± 0.4% | 1121.7 ± 0.4% | 1.632 | 2.224 | 13.498 | 3.435 | 6.057 |
| string: canterbury-large/world192.txt | 1103121 | 4032.2 ± 0.7% | 1654.3 ± 0.4% | 1999.7 ± 1.2% | 448.9 ± 0.6% | 1345.1 ± 0.4% | 909.7 ± 0.1% | 2.437 | 2.016 | 8.983 | 2.998 | 4.432 |
| string: http/html-1m | 1058582 | 6811.2 ± 0.4% | 3963.4 ± 0.5% | 3040.9 ± 0.7% | 498.8 ± 0.4% | 1921.7 ± 0.4% | 807.3 ± 0.2% | 1.719 | 2.240 | 13.655 | 3.544 | 8.437 |
| string: http/json-1m | 1190272 | 3302.1 ± 0.5% | 1357.7 ± 0.1% | 1556.4 ± 0.4% | 442.8 ± 0.8% | 1035.4 ± 0.3% | 765.1 ± 0.7% | 2.432 | 2.122 | 7.457 | 3.189 | 4.316 |
| string: http/js-1m | 1144362 | 2797.2 ± 0.7% | 1180.7 ± 0.5% | 1621.5 ± 0.3% | 369.0 ± 0.4% | 1084.2 ± 0.1% | 758.5 ± 0.5% | 2.369 | 1.725 | 7.580 | 2.580 | 3.688 |
| string: http/css-1m | 1097820 | 4025.2 ± 0.7% | 1494.9 ± 0.3% | 2146.5 ± 1.1% | 494.2 ± 0.7% | 1355.1 ± 0.4% | 895.4 ± 0.3% | 2.693 | 1.875 | 8.145 | 2.970 | 4.495 |
| string: dickens as Cyrillic and CJK | 1883069 | 3078.8 ± 0.4% | 2334.6 ± 0.5% | 520.9 ± 1.1% | 307.1 ± 0.8% | 559.2 ± 0.7% | 336.4 ± 0.3% | 1.319 | 5.911 | 10.026 | 5.505 | 9.153 |
| hex: silesia/dickens | 524290 | 15603.8 ± 0.6% | 1462.2 ± 0.4% | 1083.0 ± 0.5% | 494.6 ± 2.8% | 985.7 ± 0.4% | 735.7 ± 1.8% | 10.671 | 14.407 | 31.547 | 15.829 | 21.210 |
| hex: silesia/mozilla | 524290 | 15640.9 ± 0.7% | 1479.6 ± 0.2% | 1091.7 ± 0.5% | 442.1 ± 0.5% | 993.7 ± 0.6% | 735.4 ± 0.4% | 10.571 | 14.327 | 35.375 | 15.740 | 21.268 |
| hex: silesia/mr | 524290 | 15661.2 ± 0.3% | 1479.8 ± 0.2% | 1093.7 ± 0.5% | 547.8 ± 2.4% | 991.3 ± 0.2% | 735.6 ± 0.4% | 10.583 | 14.320 | 28.587 | 15.798 | 21.290 |
| hex: silesia/nci | 524290 | 15640.3 ± 0.5% | 1474.8 ± 0.3% | 1090.4 ± 0.3% | 634.5 ± 4.8% | 990.6 ± 0.4% | 735.0 ± 0.2% | 10.605 | 14.343 | 24.650 | 15.789 | 21.278 |
| hex: silesia/ooffice | 524290 | 15639.9 ± 0.1% | 1462.9 ± 0.1% | 1085.3 ± 0.3% | 388.8 ± 0.3% | 986.2 ± 0.5% | 735.1 ± 0.2% | 10.691 | 14.410 | 40.221 | 15.859 | 21.276 |
| hex: silesia/osdb | 524290 | 15604.5 ± 0.2% | 1473.5 ± 0.2% | 1089.4 ± 0.2% | 469.1 ± 3.6% | 991.8 ± 0.4% | 735.4 ± 0.2% | 10.590 | 14.323 | 33.268 | 15.734 | 21.218 |
| hex: silesia/reymont | 524290 | 15641.1 ± 0.6% | 1459.6 ± 0.3% | 1086.2 ± 0.7% | 513.3 ± 1.1% | 989.2 ± 0.3% | 735.6 ± 0.3% | 10.716 | 14.400 | 30.474 | 15.812 | 21.264 |
| hex: silesia/samba | 524290 | 15646.3 ± 0.1% | 1467.9 ± 0.5% | 1086.0 ± 0.2% | 403.6 ± 0.6% | 991.9 ± 0.3% | 734.9 ± 0.4% | 10.659 | 14.408 | 38.768 | 15.775 | 21.290 |
| hex: silesia/sao | 524290 | 15665.7 ± 0.3% | 1463.2 ± 0.4% | 1085.8 ± 0.5% | 333.0 ± 0.1% | 987.8 ± 0.4% | 735.1 ± 0.4% | 10.706 | 14.427 | 47.047 | 15.859 | 21.310 |
| hex: silesia/webster | 524290 | 15655.9 ± 0.1% | 1468.3 ± 0.4% | 1086.0 ± 0.2% | 475.7 ± 0.8% | 991.4 ± 0.6% | 734.7 ± 0.6% | 10.663 | 14.416 | 32.914 | 15.792 | 21.310 |
| hex: silesia/x-ray | 524290 | 15543.4 ± 0.7% | 1473.3 ± 0.1% | 1092.8 ± 0.3% | 445.3 ± 0.8% | 996.0 ± 0.2% | 734.0 ± 0.4% | 10.550 | 14.224 | 34.909 | 15.606 | 21.177 |
| hex: silesia/xml | 524290 | 15618.7 ± 0.1% | 1470.3 ± 0.7% | 1086.9 ± 0.3% | 615.8 ± 0.6% | 991.5 ± 0.2% | 733.7 ± 0.3% | 10.623 | 14.370 | 25.362 | 15.753 | 21.286 |
| hex: canterbury/alice29.txt | 304180 | 15697.0 ± 0.2% | 1472.3 ± 0.1% | 1090.3 ± 0.2% | 502.8 ± 0.2% | 991.6 ± 0.4% | 735.4 ± 0.2% | 10.662 | 14.397 | 31.218 | 15.829 | 21.344 |
| hex: canterbury/asyoulik.txt | 250360 | 15708.5 ± 0.0% | 1475.7 ± 0.1% | 1091.9 ± 0.3% | 495.5 ± 1.3% | 993.3 ± 0.4% | 741.1 ± 0.2% | 10.645 | 14.387 | 31.701 | 15.814 | 21.196 |
| hex: canterbury/cp.html | 49208 | 15635.1 ± 0.2% | 1472.4 ± 0.1% | 1095.7 ± 0.4% | 527.6 ± 2.5% | 999.5 ± 0.1% | 742.7 ± 0.2% | 10.618 | 14.269 | 29.637 | 15.642 | 21.053 |
| hex: canterbury/fields.c | 22302 | 15451.8 ± 0.0% | 1398.6 ± 0.5% | 1059.7 ± 0.1% | 635.0 ± 6.6% | 976.2 ± 0.1% | 736.7 ± 0.2% | 11.048 | 14.582 | 24.332 | 15.828 | 20.975 |
| hex: canterbury/grammar.lsp | 7444 | 14974.1 ± 0.1% | 1508.4 ± 0.2% | 1090.2 ± 0.4% | 668.8 ± 3.4% | 979.2 ± 0.4% | 725.9 ± 0.2% | 9.927 | 13.735 | 22.389 | 15.292 | 20.628 |
| hex: canterbury/kennedy.xls | 524290 | 15608.4 ± 0.4% | 1478.1 ± 0.3% | 1088.2 ± 0.6% | 659.9 ± 1.8% | 990.2 ± 0.3% | 735.5 ± 0.3% | 10.560 | 14.343 | 23.654 | 15.762 | 21.221 |
| hex: canterbury/lcet10.txt | 524290 | 15659.5 ± 0.1% | 1467.8 ± 0.2% | 1086.0 ± 0.2% | 503.4 ± 0.3% | 987.3 ± 0.2% | 735.8 ± 0.5% | 10.669 | 14.420 | 31.109 | 15.861 | 21.284 |
| hex: canterbury/plrabn12.txt | 524290 | 15612.6 ± 0.1% | 1468.6 ± 0.1% | 1085.0 ± 1.1% | 493.3 ± 0.6% | 986.7 ± 0.3% | 735.1 ± 0.2% | 10.631 | 14.390 | 31.652 | 15.823 | 21.239 |
| hex: canterbury/ptt5 | 524290 | 15653.1 ± 0.1% | 1486.5 ± 0.6% | 1094.5 ± 0.1% | 553.3 ± 1.0% | 991.6 ± 0.2% | 735.7 ± 0.6% | 10.530 | 14.302 | 28.289 | 15.786 | 21.276 |
| hex: canterbury/sum | 76482 | 15647.0 ± 0.1% | 1494.2 ± 0.1% | 1103.7 ± 0.1% | 594.7 ± 2.2% | 997.9 ± 0.0% | 743.7 ± 0.3% | 10.472 | 14.177 | 26.311 | 15.679 | 21.040 |
| hex: canterbury/xargs.1 | 8456 | 15006.1 ± 0.0% | 1494.5 ± 1.1% | 1087.4 ± 0.4% | 667.8 ± 4.8% | 991.5 ± 0.4% | 728.4 ± 0.2% | 10.041 | 13.801 | 22.472 | 15.134 | 20.602 |
| hex: canterbury-large/E.coli | 524290 | 15698.6 ± 0.3% | 1476.9 ± 0.1% | 1090.5 ± 0.2% | 671.8 ± 0.3% | 992.9 ± 0.3% | 734.5 ± 0.3% | 10.629 | 14.396 | 23.368 | 15.811 | 21.373 |
| hex: canterbury-large/bible.txt | 524290 | 15659.5 ± 0.3% | 1467.4 ± 0.2% | 1082.9 ± 0.5% | 515.1 ± 0.3% | 986.5 ± 0.3% | 735.1 ± 0.8% | 10.672 | 14.461 | 30.402 | 15.873 | 21.304 |
| hex: canterbury-large/world192.txt | 524290 | 15670.3 ± 0.4% | 1467.7 ± 0.3% | 1082.7 ± 0.5% | 503.4 ± 0.7% | 988.7 ± 0.7% | 736.2 ± 0.7% | 10.677 | 14.474 | 31.128 | 15.849 | 21.286 |
| hex: http/html-1kx1024 | 2099200 | 13835.6 ± 0.4% | 1454.6 ± 0.3% | 1062.4 ± 0.3% | 502.0 ± 0.1% | 983.0 ± 0.4% | 692.7 ± 0.1% | 9.512 | 13.023 | 27.563 | 14.074 | 19.972 |
| hex: http/html-16kx64 | 2097280 | 15274.5 ± 0.4% | 1444.7 ± 0.7% | 1075.3 ± 0.1% | 508.5 ± 0.2% | 997.8 ± 0.1% | 735.0 ± 0.2% | 10.573 | 14.205 | 30.041 | 15.308 | 20.782 |
| hex: http/html-1m | 524290 | 15682.0 ± 0.3% | 1467.6 ± 0.2% | 1083.0 ± 0.3% | 502.2 ± 0.4% | 988.4 ± 0.1% | 735.0 ± 0.3% | 10.686 | 14.481 | 31.224 | 15.865 | 21.337 |
| hex: http/json-1kx1024 | 2099200 | 13805.5 ± 0.3% | 1463.8 ± 0.3% | 1066.9 ± 0.1% | 607.7 ± 0.4% | 986.9 ± 0.2% | 692.7 ± 0.3% | 9.431 | 12.940 | 22.717 | 13.988 | 19.929 |
| hex: http/json-16kx64 | 2097280 | 15265.7 ± 0.5% | 1445.0 ± 0.1% | 1074.7 ± 0.3% | 617.4 ± 0.4% | 994.7 ± 0.3% | 735.0 ± 0.3% | 10.564 | 14.205 | 24.724 | 15.347 | 20.769 |
| hex: http/json-1m | 524290 | 15634.4 ± 0.4% | 1477.8 ± 0.5% | 1089.1 ± 0.5% | 636.4 ± 1.1% | 992.0 ± 0.2% | 735.7 ± 0.3% | 10.579 | 14.355 | 24.566 | 15.760 | 21.251 |
| hex: http/js-1kx1024 | 2099200 | 13825.2 ± 0.3% | 1455.8 ± 0.1% | 1064.8 ± 0.2% | 499.6 ± 0.4% | 984.4 ± 0.3% | 692.8 ± 0.2% | 9.497 | 12.984 | 27.671 | 14.044 | 19.955 |
| hex: http/js-16kx64 | 2097280 | 15305.3 ± 0.4% | 1442.6 ± 0.1% | 1073.8 ± 0.2% | 505.7 ± 0.6% | 996.1 ± 0.1% | 734.4 ± 0.2% | 10.609 | 14.253 | 30.264 | 15.365 | 20.841 |
| hex: http/js-1m | 524290 | 15688.9 ± 0.3% | 1471.6 ± 0.2% | 1086.0 ± 0.4% | 512.5 ± 0.7% | 991.1 ± 0.4% | 735.4 ± 0.6% | 10.661 | 14.446 | 30.614 | 15.829 | 21.335 |
| hex: http/css-1kx1024 | 2099200 | 13893.7 ± 0.7% | 1455.2 ± 0.2% | 1063.0 ± 0.2% | 531.2 ± 0.3% | 983.1 ± 0.1% | 692.5 ± 0.2% | 9.548 | 13.070 | 26.155 | 14.132 | 20.063 |
| hex: http/css-16kx64 | 2097280 | 15289.2 ± 0.4% | 1440.5 ± 0.2% | 1075.6 ± 0.1% | 542.6 ± 0.7% | 995.6 ± 0.5% | 733.9 ± 0.2% | 10.614 | 14.214 | 28.178 | 15.357 | 20.834 |
| hex: http/css-1m | 524290 | 15565.2 ± 0.4% | 1468.9 ± 0.2% | 1084.5 ± 0.3% | 529.4 ± 0.3% | 987.9 ± 0.1% | 734.1 ± 0.2% | 10.596 | 14.353 | 29.401 | 15.756 | 21.204 |
| hex: shuffled/dickens-1m | 524290 | 15711.5 ± 0.2% | 1465.9 ± 0.5% | 1083.8 ± 0.3% | 501.9 ± 0.5% | 985.1 ± 0.1% | 736.0 ± 0.6% | 10.718 | 14.496 | 31.303 | 15.949 | 21.347 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.3 ± 0.2% | 931.2 ± 0.3% | 1026.2 ± 0.3% | 301.4 ± 0.8% | 665.8 ± 0.3% | 309.9 ± 1.7% | 1.007 | 0.913 | 3.110 | 1.408 | 3.024 |
| qlog records, JSON text sequence | 1467503 | 785.9 ± 0.7% | 817.3 ± 0.1% | 797.5 ± 1.9% | 242.9 ± 0.8% | 701.0 ± 0.7% | 251.5 ± 1.9% | 0.962 | 0.985 | 3.236 | 1.121 | 3.125 |
| string: silesia/dickens | 172528 | 5054.8 ± 0.3% | 1878.2 ± 0.3% | 2649.5 ± 0.4% | 361.7 ± 1.2% | 2872.6 ± 0.5% | 553.5 ± 2.6% | 2.691 | 1.908 | 13.977 | 1.760 | 9.132 |
| string: silesia/nci | 1075110 | 4310.5 ± 0.4% | 2242.0 ± 0.3% | 2997.9 ± 0.2% | 543.5 ± 1.0% | 3028.5 ± 0.5% | 603.8 ± 0.4% | 1.923 | 1.438 | 7.931 | 1.423 | 7.139 |
| string: silesia/reymont | 1075159 | 2952.8 ± 2.5% | 1805.6 ± 3.2% | 2063.5 ± 0.5% | 375.9 ± 0.3% | 2158.4 ± 0.4% | 537.8 ± 1.3% | 1.635 | 1.431 | 7.855 | 1.368 | 5.491 |
| string: silesia/samba | 97582 | 3499.7 ± 0.4% | 2023.8 ± 0.3% | 2617.5 ± 0.4% | 322.9 ± 0.3% | 1502.0 ± 0.8% | 429.0 ± 4.9% | 1.729 | 1.337 | 10.838 | 2.330 | 8.157 |
| string: silesia/webster | 1098490 | 3683.1 ± 0.5% | 1518.2 ± 0.4% | 2014.5 ± 0.4% | 359.6 ± 0.3% | 2190.5 ± 0.7% | 501.9 ± 1.1% | 2.426 | 1.828 | 10.241 | 1.681 | 7.338 |
| string: silesia/xml | 1090118 | 4821.0 ± 0.6% | 2358.1 ± 0.5% | 2530.3 ± 0.5% | 455.5 ± 1.2% | 2836.3 ± 1.0% | 565.4 ± 0.9% | 2.044 | 1.905 | 10.583 | 1.700 | 8.527 |
| string: canterbury/alice29.txt | 159425 | 4332.5 ± 0.8% | 1600.1 ± 0.3% | 2460.3 ± 0.4% | 342.7 ± 0.4% | 2516.4 ± 0.3% | 507.2 ± 1.6% | 2.708 | 1.761 | 12.642 | 1.722 | 8.541 |
| string: canterbury/asyoulik.txt | 132198 | 3492.4 ± 1.2% | 1458.9 ± 0.2% | 2249.2 ± 0.8% | 335.0 ± 1.1% | 2094.2 ± 0.4% | 461.0 ± 1.9% | 2.394 | 1.553 | 10.426 | 1.668 | 7.576 |
| string: canterbury/lcet10.txt | 441884 | 5144.2 ± 0.7% | 1853.3 ± 0.2% | 2333.8 ± 0.6% | 389.8 ± 0.8% | 2871.5 ± 0.6% | 536.1 ± 1.3% | 2.776 | 2.204 | 13.198 | 1.791 | 9.595 |
| string: canterbury/plrabn12.txt | 503330 | 4132.5 ± 0.8% | 1737.0 ± 0.1% | 2064.1 ± 0.2% | 360.4 ± 0.3% | 2509.6 ± 0.3% | 501.7 ± 1.0% | 2.379 | 2.002 | 11.465 | 1.647 | 8.236 |
| string: canterbury-large/E.coli | 1048578 | 11962.0 ± 0.3% | 3601.0 ± 0.4% | 3266.2 ± 0.4% | 935.2 ± 1.0% | 6025.3 ± 0.8% | 755.1 ± 1.7% | 3.322 | 3.662 | 12.792 | 1.985 | 15.841 |
| string: canterbury-large/bible.txt | 1055886 | 6916.3 ± 1.5% | 2942.1 ± 0.1% | 2835.9 ± 0.7% | 418.2 ± 2.0% | 3770.3 ± 0.9% | 620.0 ± 1.1% | 2.351 | 2.439 | 16.538 | 1.834 | 11.156 |
| string: canterbury-large/world192.txt | 1103121 | 3400.4 ± 0.6% | 1483.6 ± 0.1% | 2017.6 ± 0.5% | 353.1 ± 0.3% | 2130.4 ± 0.7% | 503.3 ± 0.8% | 2.292 | 1.685 | 9.630 | 1.596 | 6.757 |
| string: http/html-1m | 1058582 | 6217.4 ± 1.7% | 2737.1 ± 1.2% | 2702.0 ± 1.3% | 441.6 ± 0.7% | 3495.1 ± 0.4% | 601.1 ± 1.8% | 2.271 | 2.301 | 14.079 | 1.779 | 10.343 |
| string: http/json-1m | 1190272 | 2557.0 ± 0.6% | 875.9 ± 0.3% | 2253.3 ± 0.6% | 389.8 ± 0.5% | 1063.1 ± 0.3% | 444.9 ± 0.8% | 2.919 | 1.135 | 6.559 | 2.405 | 5.747 |
| string: http/js-1m | 1144362 | 2279.9 ± 0.5% | 1029.9 ± 0.4% | 1637.4 ± 0.2% | 321.0 ± 0.7% | 1526.4 ± 0.9% | 420.7 ± 0.9% | 2.214 | 1.392 | 7.103 | 1.494 | 5.419 |
| string: http/css-1m | 1097820 | 2656.9 ± 0.6% | 1680.3 ± 0.2% | 2227.2 ± 0.8% | 407.7 ± 1.1% | 1932.8 ± 0.6% | 489.9 ± 0.3% | 1.581 | 1.193 | 6.517 | 1.375 | 5.423 |
| string: dickens as Cyrillic and CJK | 1883069 | 3077.5 ± 0.3% | 1685.5 ± 0.5% | 893.4 ± 0.5% | 351.4 ± 0.2% | 667.1 ± 1.0% | 158.0 ± 1.6% | 1.826 | 3.445 | 8.758 | 4.613 | 19.473 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1331.0 ± 0.2% | 981.0 ± 0.2% | 1212.2 ± 0.7% | 213.5 ± 0.5% | 471.7 ± 0.8% | 256.5 ± 2.8% | 1.357 | 1.098 | 6.235 | 2.822 | 5.189 |
| hex: silesia/dickens | 524290 | 11958.0 ± 0.3% | 3622.0 ± 0.4% | 3292.3 ± 0.5% | 508.1 ± 0.8% | 6120.1 ± 0.7% | 783.4 ± 1.6% | 3.301 | 3.632 | 23.534 | 1.954 | 15.265 |
| hex: silesia/mozilla | 524290 | 12021.4 ± 0.1% | 3614.8 ± 0.3% | 3293.3 ± 0.7% | 453.7 ± 2.2% | 6156.8 ± 1.5% | 785.4 ± 0.4% | 3.326 | 3.650 | 26.496 | 1.953 | 15.307 |
| hex: silesia/mr | 524290 | 12011.6 ± 0.1% | 3619.0 ± 0.3% | 3293.6 ± 0.4% | 575.9 ± 1.1% | 6125.1 ± 1.5% | 785.9 ± 0.6% | 3.319 | 3.647 | 20.857 | 1.961 | 15.284 |
| hex: silesia/nci | 524290 | 11976.1 ± 0.2% | 3617.3 ± 0.2% | 3291.0 ± 0.2% | 627.1 ± 1.6% | 6096.0 ± 0.8% | 784.4 ± 0.5% | 3.311 | 3.639 | 19.098 | 1.965 | 15.267 |
| hex: silesia/ooffice | 524290 | 11966.9 ± 0.2% | 3619.3 ± 0.1% | 3294.7 ± 0.3% | 406.3 ± 1.2% | 6045.6 ± 0.5% | 784.3 ± 0.5% | 3.306 | 3.632 | 29.456 | 1.979 | 15.258 |
| hex: silesia/osdb | 524290 | 12008.7 ± 0.3% | 3619.8 ± 0.2% | 3297.3 ± 0.2% | 483.7 ± 2.9% | 6090.9 ± 0.2% | 785.2 ± 0.3% | 3.318 | 3.642 | 24.826 | 1.972 | 15.293 |
| hex: silesia/reymont | 524290 | 11994.0 ± 0.1% | 3617.5 ± 0.1% | 3296.0 ± 0.4% | 515.6 ± 1.8% | 6099.0 ± 1.2% | 786.4 ± 1.0% | 3.316 | 3.639 | 23.263 | 1.967 | 15.253 |
| hex: silesia/samba | 524290 | 11940.4 ± 0.3% | 3615.5 ± 0.3% | 3304.1 ± 0.2% | 409.7 ± 1.5% | 6082.9 ± 1.9% | 785.0 ± 0.7% | 3.303 | 3.614 | 29.146 | 1.963 | 15.210 |
| hex: silesia/sao | 524290 | 11999.6 ± 0.1% | 3616.1 ± 0.4% | 3308.0 ± 0.2% | 341.9 ± 0.7% | 6135.0 ± 1.0% | 783.2 ± 0.8% | 3.318 | 3.627 | 35.099 | 1.956 | 15.322 |
| hex: silesia/webster | 524290 | 11984.9 ± 0.1% | 3616.0 ± 0.2% | 3296.4 ± 0.3% | 466.1 ± 0.6% | 6102.4 ± 1.0% | 784.4 ± 0.4% | 3.314 | 3.636 | 25.711 | 1.964 | 15.280 |
| hex: silesia/x-ray | 524290 | 11984.7 ± 0.1% | 3620.5 ± 0.3% | 3301.1 ± 0.3% | 475.7 ± 0.5% | 6067.0 ± 1.2% | 785.8 ± 0.5% | 3.310 | 3.631 | 25.195 | 1.975 | 15.252 |
| hex: silesia/xml | 524290 | 11965.2 ± 0.1% | 3619.0 ± 0.6% | 3292.5 ± 0.5% | 522.1 ± 1.0% | 6113.8 ± 1.1% | 786.4 ± 0.4% | 3.306 | 3.634 | 22.916 | 1.957 | 15.216 |
| hex: canterbury/alice29.txt | 304180 | 12005.5 ± 0.1% | 3640.9 ± 0.2% | 3359.0 ± 0.2% | 510.8 ± 0.2% | 6113.5 ± 1.1% | 783.6 ± 0.5% | 3.297 | 3.574 | 23.504 | 1.964 | 15.320 |
| hex: canterbury/asyoulik.txt | 250360 | 12009.1 ± 0.1% | 3641.5 ± 0.2% | 3371.7 ± 0.4% | 504.6 ± 0.3% | 6176.9 ± 2.4% | 785.2 ± 0.7% | 3.298 | 3.562 | 23.800 | 1.944 | 15.294 |
| hex: canterbury/cp.html | 49208 | 11927.6 ± 0.1% | 3639.2 ± 0.2% | 3275.4 ± 0.0% | 480.0 ± 3.6% | 6273.7 ± 0.3% | 770.3 ± 1.6% | 3.278 | 3.642 | 24.850 | 1.901 | 15.484 |
| hex: canterbury/fields.c | 22302 | 11786.0 ± 0.0% | 3628.1 ± 0.3% | 3419.4 ± 0.1% | 511.6 ± 0.2% | 6256.5 ± 0.7% | 758.6 ± 2.3% | 3.249 | 3.447 | 23.037 | 1.884 | 15.537 |
| hex: canterbury/grammar.lsp | 7444 | 11272.6 ± 0.2% | 3600.8 ± 0.1% | 3350.0 ± 0.2% | 541.0 ± 4.3% | 6168.2 ± 0.5% | 729.6 ± 1.4% | 3.131 | 3.365 | 20.838 | 1.828 | 15.450 |
| hex: canterbury/kennedy.xls | 524290 | 11995.6 ± 0.1% | 3611.3 ± 0.3% | 3295.7 ± 0.2% | 656.1 ± 2.2% | 6126.0 ± 0.9% | 784.0 ± 6.7% | 3.322 | 3.640 | 18.285 | 1.958 | 15.300 |
| hex: canterbury/lcet10.txt | 524290 | 12020.6 ± 0.1% | 3613.9 ± 0.3% | 3293.1 ± 0.6% | 514.9 ± 0.3% | 6078.7 ± 1.5% | 786.5 ± 1.6% | 3.326 | 3.650 | 23.346 | 1.977 | 15.283 |
| hex: canterbury/plrabn12.txt | 524290 | 11981.7 ± 0.1% | 3614.4 ± 0.3% | 3300.0 ± 0.2% | 505.8 ± 0.4% | 6035.6 ± 2.3% | 783.8 ± 0.7% | 3.315 | 3.631 | 23.689 | 1.985 | 15.287 |
| hex: canterbury/ptt5 | 524290 | 12007.7 ± 0.1% | 3620.0 ± 0.1% | 3295.0 ± 0.3% | 559.1 ± 0.8% | 6136.5 ± 1.7% | 785.6 ± 0.4% | 3.317 | 3.644 | 21.479 | 1.957 | 15.286 |
| hex: canterbury/sum | 76482 | 11923.1 ± 0.0% | 3632.7 ± 0.0% | 3354.3 ± 0.1% | 508.1 ± 0.7% | 6173.4 ± 0.1% | 770.5 ± 1.5% | 3.282 | 3.555 | 23.467 | 1.931 | 15.474 |
| hex: canterbury/xargs.1 | 8456 | 11356.3 ± 0.1% | 3601.4 ± 0.1% | 3346.8 ± 0.2% | 490.7 ± 2.0% | 6148.5 ± 0.3% | 753.9 ± 1.8% | 3.153 | 3.393 | 23.144 | 1.847 | 15.064 |
| hex: canterbury-large/E.coli | 524290 | 12016.1 ± 0.2% | 3615.5 ± 0.2% | 3292.0 ± 0.3% | 688.2 ± 0.5% | 6160.4 ± 1.8% | 774.4 ± 2.3% | 3.324 | 3.650 | 17.459 | 1.951 | 15.516 |
| hex: canterbury-large/bible.txt | 524290 | 12007.7 ± 0.1% | 3615.1 ± 0.1% | 3304.1 ± 0.2% | 520.1 ± 1.0% | 6127.5 ± 0.9% | 784.9 ± 2.1% | 3.322 | 3.634 | 23.088 | 1.960 | 15.298 |
| hex: canterbury-large/world192.txt | 524290 | 12008.6 ± 0.1% | 3610.4 ± 0.3% | 3299.2 ± 0.5% | 494.9 ± 0.4% | 6141.0 ± 0.8% | 785.0 ± 0.4% | 3.326 | 3.640 | 24.264 | 1.955 | 15.298 |
| hex: http/html-1kx1024 | 2099200 | 8819.4 ± 4.2% | 3462.2 ± 0.1% | 2876.3 ± 1.2% | 476.2 ± 0.8% | 5126.5 ± 1.7% | 646.9 ± 1.9% | 2.547 | 3.066 | 18.522 | 1.720 | 13.634 |
| hex: http/html-16kx64 | 2097280 | 11770.3 ± 0.2% | 3613.6 ± 0.2% | 3270.3 ± 0.4% | 478.0 ± 0.6% | 6062.0 ± 0.7% | 750.4 ± 2.0% | 3.257 | 3.599 | 24.623 | 1.942 | 15.685 |
| hex: http/html-1m | 524290 | 11984.5 ± 0.2% | 3616.2 ± 0.1% | 3294.9 ± 0.2% | 501.4 ± 1.8% | 6065.5 ± 1.3% | 782.9 ± 1.2% | 3.314 | 3.637 | 23.900 | 1.976 | 15.308 |
| hex: http/json-1kx1024 | 2099200 | 8816.7 ± 2.9% | 3458.9 ± 0.2% | 2868.5 ± 0.8% | 577.2 ± 0.5% | 5139.3 ± 1.5% | 653.6 ± 1.4% | 2.549 | 3.074 | 15.274 | 1.716 | 13.490 |
| hex: http/json-16kx64 | 2097280 | 11760.5 ± 0.2% | 3612.0 ± 0.2% | 3253.0 ± 0.3% | 575.0 ± 0.6% | 6039.8 ± 0.7% | 754.2 ± 1.1% | 3.256 | 3.615 | 20.453 | 1.947 | 15.593 |
| hex: http/json-1m | 524290 | 11963.5 ± 1.5% | 3616.1 ± 0.5% | 3303.0 ± 0.3% | 594.8 ± 2.2% | 6077.0 ± 1.2% | 780.6 ± 2.7% | 3.308 | 3.622 | 20.114 | 1.969 | 15.325 |
| hex: http/js-1kx1024 | 2099200 | 8775.4 ± 3.8% | 3460.8 ± 0.3% | 2859.2 ± 1.1% | 481.6 ± 0.9% | 5108.5 ± 1.2% | 639.6 ± 5.4% | 2.536 | 3.069 | 18.220 | 1.718 | 13.721 |
| hex: http/js-16kx64 | 2097280 | 11751.6 ± 0.1% | 3608.4 ± 0.1% | 3264.0 ± 0.8% | 479.6 ± 0.8% | 6016.0 ± 0.6% | 743.1 ± 1.4% | 3.257 | 3.600 | 24.501 | 1.953 | 15.814 |
| hex: http/js-1m | 524290 | 11996.7 ± 0.1% | 3615.5 ± 0.1% | 3291.8 ± 0.2% | 502.4 ± 2.5% | 6090.3 ± 1.9% | 779.4 ± 3.3% | 3.318 | 3.644 | 23.881 | 1.970 | 15.392 |
| hex: http/css-1kx1024 | 2099200 | 8816.0 ± 3.8% | 3460.0 ± 0.3% | 2857.2 ± 0.4% | 488.7 ± 0.6% | 5134.8 ± 1.5% | 627.8 ± 2.0% | 2.548 | 3.086 | 18.038 | 1.717 | 14.044 |
| hex: http/css-16kx64 | 2097280 | 11759.7 ± 0.3% | 3608.7 ± 0.1% | 3262.1 ± 0.3% | 497.0 ± 1.6% | 6020.8 ± 0.1% | 743.2 ± 3.8% | 3.259 | 3.605 | 23.661 | 1.953 | 15.824 |
| hex: http/css-1m | 524290 | 11984.6 ± 0.1% | 3614.2 ± 0.3% | 3293.5 ± 0.2% | 494.4 ± 2.2% | 6103.3 ± 0.3% | 780.8 ± 3.6% | 3.316 | 3.639 | 24.240 | 1.964 | 15.350 |
| hex: shuffled/dickens-1m | 524290 | 12014.3 ± 0.2% | 3618.6 ± 0.1% | 3295.0 ± 0.2% | 510.0 ± 1.0% | 6127.3 ± 1.5% | 785.4 ± 0.2% | 3.320 | 3.646 | 23.557 | 1.961 | 15.297 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1013.2 ± 0.8% | 931.2 ± 0.3% | 1026.2 ± 0.3% | 301.4 ± 0.8% | 665.8 ± 0.3% | 309.9 ± 1.7% | 1.088 | 0.987 | 3.362 | 1.522 | 3.269 |
| qlog records, JSON text sequence | 1467503 | 840.7 ± 0.7% | 817.3 ± 0.1% | 797.5 ± 1.9% | 242.9 ± 0.8% | 701.0 ± 0.7% | 251.5 ± 1.9% | 1.029 | 1.054 | 3.462 | 1.199 | 3.343 |
| string: silesia/dickens | 172528 | 5055.3 ± 0.1% | 1878.2 ± 0.3% | 2649.5 ± 0.4% | 361.7 ± 1.2% | 2872.6 ± 0.5% | 553.5 ± 2.6% | 2.692 | 1.908 | 13.978 | 1.760 | 9.133 |
| string: silesia/nci | 1075110 | 4318.0 ± 0.3% | 2242.0 ± 0.3% | 2997.9 ± 0.2% | 543.5 ± 1.0% | 3028.5 ± 0.5% | 603.8 ± 0.4% | 1.926 | 1.440 | 7.944 | 1.426 | 7.152 |
| string: silesia/reymont | 1075159 | 2949.5 ± 3.4% | 1805.6 ± 3.2% | 2063.5 ± 0.5% | 375.9 ± 0.3% | 2158.4 ± 0.4% | 537.8 ± 1.3% | 1.634 | 1.429 | 7.846 | 1.367 | 5.485 |
| string: silesia/samba | 97582 | 3504.2 ± 0.2% | 2023.8 ± 0.3% | 2617.5 ± 0.4% | 322.9 ± 0.3% | 1502.0 ± 0.8% | 429.0 ± 4.9% | 1.731 | 1.339 | 10.852 | 2.333 | 8.168 |
| string: silesia/webster | 1098490 | 3677.1 ± 0.5% | 1518.2 ± 0.4% | 2014.5 ± 0.4% | 359.6 ± 0.3% | 2190.5 ± 0.7% | 501.9 ± 1.1% | 2.422 | 1.825 | 10.224 | 1.679 | 7.326 |
| string: silesia/xml | 1090118 | 4828.0 ± 0.5% | 2358.1 ± 0.5% | 2530.3 ± 0.5% | 455.5 ± 1.2% | 2836.3 ± 1.0% | 565.4 ± 0.9% | 2.047 | 1.908 | 10.599 | 1.702 | 8.539 |
| string: canterbury/alice29.txt | 159425 | 4341.3 ± 0.7% | 1600.1 ± 0.3% | 2460.3 ± 0.4% | 342.7 ± 0.4% | 2516.4 ± 0.3% | 507.2 ± 1.6% | 2.713 | 1.765 | 12.667 | 1.725 | 8.559 |
| string: canterbury/asyoulik.txt | 132198 | 3502.1 ± 1.2% | 1458.9 ± 0.2% | 2249.2 ± 0.8% | 335.0 ± 1.1% | 2094.2 ± 0.4% | 461.0 ± 1.9% | 2.401 | 1.557 | 10.455 | 1.672 | 7.597 |
| string: canterbury/lcet10.txt | 441884 | 5145.9 ± 0.3% | 1853.3 ± 0.2% | 2333.8 ± 0.6% | 389.8 ± 0.8% | 2871.5 ± 0.6% | 536.1 ± 1.3% | 2.777 | 2.205 | 13.202 | 1.792 | 9.598 |
| string: canterbury/plrabn12.txt | 503330 | 4139.2 ± 0.6% | 1737.0 ± 0.1% | 2064.1 ± 0.2% | 360.4 ± 0.3% | 2509.6 ± 0.3% | 501.7 ± 1.0% | 2.383 | 2.005 | 11.484 | 1.649 | 8.250 |
| string: canterbury-large/E.coli | 1048578 | 11958.3 ± 0.3% | 3601.0 ± 0.4% | 3266.2 ± 0.4% | 935.2 ± 1.0% | 6025.3 ± 0.8% | 755.1 ± 1.7% | 3.321 | 3.661 | 12.788 | 1.985 | 15.836 |
| string: canterbury-large/bible.txt | 1055886 | 6943.0 ± 1.5% | 2942.1 ± 0.1% | 2835.9 ± 0.7% | 418.2 ± 2.0% | 3770.3 ± 0.9% | 620.0 ± 1.1% | 2.360 | 2.448 | 16.602 | 1.841 | 11.199 |
| string: canterbury-large/world192.txt | 1103121 | 3400.8 ± 0.6% | 1483.6 ± 0.1% | 2017.6 ± 0.5% | 353.1 ± 0.3% | 2130.4 ± 0.7% | 503.3 ± 0.8% | 2.292 | 1.686 | 9.632 | 1.596 | 6.758 |
| string: http/html-1m | 1058582 | 6233.3 ± 2.1% | 2737.1 ± 1.2% | 2702.0 ± 1.3% | 441.6 ± 0.7% | 3495.1 ± 0.4% | 601.1 ± 1.8% | 2.277 | 2.307 | 14.115 | 1.783 | 10.370 |
| string: http/json-1m | 1190272 | 2558.4 ± 0.5% | 875.9 ± 0.3% | 2253.3 ± 0.6% | 389.8 ± 0.5% | 1063.1 ± 0.3% | 444.9 ± 0.8% | 2.921 | 1.135 | 6.563 | 2.407 | 5.750 |
| string: http/js-1m | 1144362 | 2284.8 ± 0.6% | 1029.9 ± 0.4% | 1637.4 ± 0.2% | 321.0 ± 0.7% | 1526.4 ± 0.9% | 420.7 ± 0.9% | 2.219 | 1.395 | 7.119 | 1.497 | 5.431 |
| string: http/css-1m | 1097820 | 2663.2 ± 0.5% | 1680.3 ± 0.2% | 2227.2 ± 0.8% | 407.7 ± 1.1% | 1932.8 ± 0.6% | 489.9 ± 0.3% | 1.585 | 1.196 | 6.532 | 1.378 | 5.436 |
| string: dickens as Cyrillic and CJK | 1883069 | 3078.2 ± 1.0% | 1685.5 ± 0.5% | 893.4 ± 0.5% | 351.4 ± 0.2% | 667.1 ± 1.0% | 158.0 ± 1.6% | 1.826 | 3.446 | 8.760 | 4.614 | 19.477 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1331.3 ± 0.4% | 981.0 ± 0.2% | 1212.2 ± 0.7% | 213.5 ± 0.5% | 471.7 ± 0.8% | 256.5 ± 2.8% | 1.357 | 1.098 | 6.236 | 2.822 | 5.190 |
| hex: silesia/dickens | 524290 | 11958.9 ± 0.2% | 3622.0 ± 0.4% | 3292.3 ± 0.5% | 508.1 ± 0.8% | 6120.1 ± 0.7% | 783.4 ± 1.6% | 3.302 | 3.632 | 23.535 | 1.954 | 15.266 |
| hex: silesia/mozilla | 524290 | 12021.4 ± 0.0% | 3614.8 ± 0.3% | 3293.3 ± 0.7% | 453.7 ± 2.2% | 6156.8 ± 1.5% | 785.4 ± 0.4% | 3.326 | 3.650 | 26.496 | 1.953 | 15.307 |
| hex: silesia/mr | 524290 | 12015.0 ± 0.1% | 3619.0 ± 0.3% | 3293.6 ± 0.4% | 575.9 ± 1.1% | 6125.1 ± 1.5% | 785.9 ± 0.6% | 3.320 | 3.648 | 20.863 | 1.962 | 15.288 |
| hex: silesia/nci | 524290 | 11936.3 ± 0.0% | 3617.3 ± 0.2% | 3291.0 ± 0.2% | 627.1 ± 1.6% | 6096.0 ± 0.8% | 784.4 ± 0.5% | 3.300 | 3.627 | 19.034 | 1.958 | 15.216 |
| hex: silesia/ooffice | 524290 | 11968.4 ± 0.1% | 3619.3 ± 0.1% | 3294.7 ± 0.3% | 406.3 ± 1.2% | 6045.6 ± 0.5% | 784.3 ± 0.5% | 3.307 | 3.633 | 29.460 | 1.980 | 15.260 |
| hex: silesia/osdb | 524290 | 12001.3 ± 0.2% | 3619.8 ± 0.2% | 3297.3 ± 0.2% | 483.7 ± 2.9% | 6090.9 ± 0.2% | 785.2 ± 0.3% | 3.315 | 3.640 | 24.811 | 1.970 | 15.284 |
| hex: silesia/reymont | 524290 | 11987.6 ± 0.1% | 3617.5 ± 0.1% | 3296.0 ± 0.4% | 515.6 ± 1.8% | 6099.0 ± 1.2% | 786.4 ± 1.0% | 3.314 | 3.637 | 23.250 | 1.966 | 15.245 |
| hex: silesia/samba | 524290 | 11978.7 ± 0.4% | 3615.5 ± 0.3% | 3304.1 ± 0.2% | 409.7 ± 1.5% | 6082.9 ± 1.9% | 785.0 ± 0.7% | 3.313 | 3.625 | 29.239 | 1.969 | 15.259 |
| hex: silesia/sao | 524290 | 12004.3 ± 0.1% | 3616.1 ± 0.4% | 3308.0 ± 0.2% | 341.9 ± 0.7% | 6135.0 ± 1.0% | 783.2 ± 0.8% | 3.320 | 3.629 | 35.112 | 1.957 | 15.328 |
| hex: silesia/webster | 524290 | 11935.4 ± 0.3% | 3616.0 ± 0.2% | 3296.4 ± 0.3% | 466.1 ± 0.6% | 6102.4 ± 1.0% | 784.4 ± 0.4% | 3.301 | 3.621 | 25.605 | 1.956 | 15.217 |
| hex: silesia/x-ray | 524290 | 11985.9 ± 0.1% | 3620.5 ± 0.3% | 3301.1 ± 0.3% | 475.7 ± 0.5% | 6067.0 ± 1.2% | 785.8 ± 0.5% | 3.311 | 3.631 | 25.198 | 1.976 | 15.253 |
| hex: silesia/xml | 524290 | 11921.3 ± 0.3% | 3619.0 ± 0.6% | 3292.5 ± 0.5% | 522.1 ± 1.0% | 6113.8 ± 1.1% | 786.4 ± 0.4% | 3.294 | 3.621 | 22.832 | 1.950 | 15.160 |
| hex: canterbury/alice29.txt | 304180 | 12003.2 ± 0.2% | 3640.9 ± 0.2% | 3359.0 ± 0.2% | 510.8 ± 0.2% | 6113.5 ± 1.1% | 783.6 ± 0.5% | 3.297 | 3.573 | 23.499 | 1.963 | 15.317 |
| hex: canterbury/asyoulik.txt | 250360 | 12007.1 ± 0.1% | 3641.5 ± 0.2% | 3371.7 ± 0.4% | 504.6 ± 0.3% | 6176.9 ± 2.4% | 785.2 ± 0.7% | 3.297 | 3.561 | 23.796 | 1.944 | 15.291 |
| hex: canterbury/cp.html | 49208 | 11928.3 ± 0.1% | 3639.2 ± 0.2% | 3275.4 ± 0.0% | 480.0 ± 3.6% | 6273.7 ± 0.3% | 770.3 ± 1.6% | 3.278 | 3.642 | 24.851 | 1.901 | 15.485 |
| hex: canterbury/fields.c | 22302 | 11784.7 ± 0.1% | 3628.1 ± 0.3% | 3419.4 ± 0.1% | 511.6 ± 0.2% | 6256.5 ± 0.7% | 758.6 ± 2.3% | 3.248 | 3.446 | 23.035 | 1.884 | 15.535 |
| hex: canterbury/grammar.lsp | 7444 | 11328.0 ± 0.7% | 3600.8 ± 0.1% | 3350.0 ± 0.2% | 541.0 ± 4.3% | 6168.2 ± 0.5% | 729.6 ± 1.4% | 3.146 | 3.382 | 20.940 | 1.837 | 15.525 |
| hex: canterbury/kennedy.xls | 524290 | 11995.4 ± 0.0% | 3611.3 ± 0.3% | 3295.7 ± 0.2% | 656.1 ± 2.2% | 6126.0 ± 0.9% | 784.0 ± 6.7% | 3.322 | 3.640 | 18.284 | 1.958 | 15.299 |
| hex: canterbury/lcet10.txt | 524290 | 12027.8 ± 0.2% | 3613.9 ± 0.3% | 3293.1 ± 0.6% | 514.9 ± 0.3% | 6078.7 ± 1.5% | 786.5 ± 1.6% | 3.328 | 3.652 | 23.360 | 1.979 | 15.292 |
| hex: canterbury/plrabn12.txt | 524290 | 11990.1 ± 0.1% | 3614.4 ± 0.3% | 3300.0 ± 0.2% | 505.8 ± 0.4% | 6035.6 ± 2.3% | 783.8 ± 0.7% | 3.317 | 3.633 | 23.706 | 1.987 | 15.298 |
| hex: canterbury/ptt5 | 524290 | 12014.2 ± 0.2% | 3620.0 ± 0.1% | 3295.0 ± 0.3% | 559.1 ± 0.8% | 6136.5 ± 1.7% | 785.6 ± 0.4% | 3.319 | 3.646 | 21.490 | 1.958 | 15.294 |
| hex: canterbury/sum | 76482 | 11921.0 ± 0.0% | 3632.7 ± 0.0% | 3354.3 ± 0.1% | 508.1 ± 0.7% | 6173.4 ± 0.1% | 770.5 ± 1.5% | 3.282 | 3.554 | 23.463 | 1.931 | 15.471 |
| hex: canterbury/xargs.1 | 8456 | 11350.8 ± 0.1% | 3601.4 ± 0.1% | 3346.8 ± 0.2% | 490.7 ± 2.0% | 6148.5 ± 0.3% | 753.9 ± 1.8% | 3.152 | 3.391 | 23.132 | 1.846 | 15.057 |
| hex: canterbury-large/E.coli | 524290 | 12017.3 ± 0.1% | 3615.5 ± 0.2% | 3292.0 ± 0.3% | 688.2 ± 0.5% | 6160.4 ± 1.8% | 774.4 ± 2.3% | 3.324 | 3.650 | 17.461 | 1.951 | 15.517 |
| hex: canterbury-large/bible.txt | 524290 | 12008.0 ± 0.2% | 3615.1 ± 0.1% | 3304.1 ± 0.2% | 520.1 ± 1.0% | 6127.5 ± 0.9% | 784.9 ± 2.1% | 3.322 | 3.634 | 23.088 | 1.960 | 15.299 |
| hex: canterbury-large/world192.txt | 524290 | 12007.9 ± 0.1% | 3610.4 ± 0.3% | 3299.2 ± 0.5% | 494.9 ± 0.4% | 6141.0 ± 0.8% | 785.0 ± 0.4% | 3.326 | 3.640 | 24.263 | 1.955 | 15.297 |
| hex: http/html-1kx1024 | 2099200 | 8912.2 ± 3.9% | 3462.2 ± 0.1% | 2876.3 ± 1.2% | 476.2 ± 0.8% | 5126.5 ± 1.7% | 646.9 ± 1.9% | 2.574 | 3.098 | 18.717 | 1.738 | 13.778 |
| hex: http/html-16kx64 | 2097280 | 11788.2 ± 0.2% | 3613.6 ± 0.2% | 3270.3 ± 0.4% | 478.0 ± 0.6% | 6062.0 ± 0.7% | 750.4 ± 2.0% | 3.262 | 3.605 | 24.660 | 1.945 | 15.709 |
| hex: http/html-1m | 524290 | 12000.0 ± 0.2% | 3616.2 ± 0.1% | 3294.9 ± 0.2% | 501.4 ± 1.8% | 6065.5 ± 1.3% | 782.9 ± 1.2% | 3.318 | 3.642 | 23.931 | 1.978 | 15.327 |
| hex: http/json-1kx1024 | 2099200 | 8879.7 ± 3.9% | 3458.9 ± 0.2% | 2868.5 ± 0.8% | 577.2 ± 0.5% | 5139.3 ± 1.5% | 653.6 ± 1.4% | 2.567 | 3.096 | 15.383 | 1.728 | 13.586 |
| hex: http/json-16kx64 | 2097280 | 11779.1 ± 0.2% | 3612.0 ± 0.2% | 3253.0 ± 0.3% | 575.0 ± 0.6% | 6039.8 ± 0.7% | 754.2 ± 1.1% | 3.261 | 3.621 | 20.486 | 1.950 | 15.617 |
| hex: http/json-1m | 524290 | 11962.8 ± 0.3% | 3616.1 ± 0.5% | 3303.0 ± 0.3% | 594.8 ± 2.2% | 6077.0 ± 1.2% | 780.6 ± 2.7% | 3.308 | 3.622 | 20.113 | 1.969 | 15.324 |
| hex: http/js-1kx1024 | 2099200 | 8859.4 ± 4.1% | 3460.8 ± 0.3% | 2859.2 ± 1.1% | 481.6 ± 0.9% | 5108.5 ± 1.2% | 639.6 ± 5.4% | 2.560 | 3.099 | 18.394 | 1.734 | 13.852 |
| hex: http/js-16kx64 | 2097280 | 11766.8 ± 0.1% | 3608.4 ± 0.1% | 3264.0 ± 0.8% | 479.6 ± 0.8% | 6016.0 ± 0.6% | 743.1 ± 1.4% | 3.261 | 3.605 | 24.533 | 1.956 | 15.834 |
| hex: http/js-1m | 524290 | 11993.4 ± 0.2% | 3615.5 ± 0.1% | 3291.8 ± 0.2% | 502.4 ± 2.5% | 6090.3 ± 1.9% | 779.4 ± 3.3% | 3.317 | 3.643 | 23.874 | 1.969 | 15.387 |
| hex: http/css-1kx1024 | 2099200 | 8891.4 ± 3.8% | 3460.0 ± 0.3% | 2857.2 ± 0.4% | 488.7 ± 0.6% | 5134.8 ± 1.5% | 627.8 ± 2.0% | 2.570 | 3.112 | 18.193 | 1.732 | 14.164 |
| hex: http/css-16kx64 | 2097280 | 11770.4 ± 0.1% | 3608.7 ± 0.1% | 3262.1 ± 0.3% | 497.0 ± 1.6% | 6020.8 ± 0.1% | 743.2 ± 3.8% | 3.262 | 3.608 | 23.683 | 1.955 | 15.838 |
| hex: http/css-1m | 524290 | 11986.7 ± 0.3% | 3614.2 ± 0.3% | 3293.5 ± 0.2% | 494.4 ± 2.2% | 6103.3 ± 0.3% | 780.8 ± 3.6% | 3.317 | 3.639 | 24.244 | 1.964 | 15.352 |
| hex: shuffled/dickens-1m | 524290 | 12015.5 ± 0.1% | 3618.6 ± 0.1% | 3295.0 ± 0.2% | 510.0 ± 1.0% | 6127.3 ± 1.5% | 785.4 ± 0.2% | 3.320 | 3.647 | 23.559 | 1.961 | 15.299 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1352.4 ± 0.2% | 1248.4 ± 0.6% | 1037.8 ± 0.3% | 407.4 ± 0.6% | 448.1 ± 0.2% | 416.0 ± 0.4% | 1.083 | 1.303 | 3.319 | 3.018 | 3.251 |
| qlog records, JSON text sequence | 1467503 | 1053.3 ± 0.1% | 1064.9 ± 0.3% | 788.7 ± 0.3% | 378.7 ± 0.6% | 473.1 ± 0.7% | 279.6 ± 0.6% | 0.989 | 1.336 | 2.782 | 2.227 | 3.767 |
| string: silesia/dickens | 172528 | 6909.9 ± 0.5% | 2814.7 ± 0.5% | 2930.4 ± 0.4% | 430.1 ± 0.4% | 1561.9 ± 0.2% | 1009.1 ± 0.2% | 2.455 | 2.358 | 16.064 | 4.424 | 6.848 |
| string: silesia/nci | 1075110 | 7309.7 ± 0.3% | 3431.1 ± 0.4% | 3093.0 ± 0.3% | 818.9 ± 1.0% | 1836.7 ± 0.3% | 1109.0 ± 0.5% | 2.130 | 2.363 | 8.926 | 3.980 | 6.591 |
| string: silesia/reymont | 1075159 | 3334.6 ± 1.4% | 1989.5 ± 1.3% | 2054.6 ± 0.8% | 450.3 ± 0.5% | 1492.3 ± 0.3% | 950.5 ± 0.6% | 1.676 | 1.623 | 7.405 | 2.235 | 3.508 |
| string: silesia/samba | 97582 | 4208.2 ± 0.8% | 2110.7 ± 0.5% | 3450.8 ± 0.6% | 353.2 ± 0.9% | 1406.1 ± 0.4% | 1054.8 ± 0.2% | 1.994 | 1.219 | 11.913 | 2.993 | 3.990 |
| string: silesia/webster | 1098490 | 4072.4 ± 0.5% | 1879.6 ± 0.3% | 2051.3 ± 0.5% | 441.0 ± 0.3% | 1372.7 ± 0.3% | 648.2 ± 0.4% | 2.167 | 1.985 | 9.235 | 2.967 | 6.283 |
| string: silesia/xml | 1090118 | 6145.7 ± 0.5% | 2868.2 ± 0.2% | 2643.8 ± 0.3% | 608.0 ± 0.6% | 1734.3 ± 0.3% | 922.9 ± 0.5% | 2.143 | 2.325 | 10.108 | 3.544 | 6.659 |
| string: canterbury/alice29.txt | 159425 | 6452.2 ± 0.8% | 2194.5 ± 0.5% | 2760.9 ± 0.9% | 407.4 ± 1.1% | 1438.0 ± 0.2% | 957.3 ± 0.1% | 2.940 | 2.337 | 15.836 | 4.487 | 6.740 |
| string: canterbury/asyoulik.txt | 132198 | 5653.2 ± 0.3% | 1708.7 ± 0.6% | 2368.2 ± 0.9% | 402.0 ± 0.4% | 1308.5 ± 0.5% | 885.1 ± 0.1% | 3.308 | 2.387 | 14.064 | 4.320 | 6.387 |
| string: canterbury/lcet10.txt | 441884 | 6259.9 ± 0.4% | 2565.4 ± 0.2% | 2484.3 ± 1.5% | 465.1 ± 0.7% | 1524.9 ± 0.2% | 986.7 ± 0.9% | 2.440 | 2.520 | 13.461 | 4.105 | 6.344 |
| string: canterbury/plrabn12.txt | 503330 | 5728.7 ± 0.2% | 2057.4 ± 0.4% | 2068.1 ± 0.3% | 424.5 ± 0.7% | 1366.0 ± 0.3% | 935.1 ± 0.4% | 2.784 | 2.770 | 13.494 | 4.194 | 6.126 |
| string: canterbury-large/E.coli | 1048578 | 19408.8 ± 0.5% | 9843.1 ± 0.8% | 3780.6 ± 0.5% | 1473.6 ± 0.4% | 2366.1 ± 0.5% | 1193.8 ± 0.2% | 1.972 | 5.134 | 13.171 | 8.203 | 16.257 |
| string: canterbury-large/bible.txt | 1055886 | 6790.3 ± 0.4% | 4164.1 ± 0.4% | 3055.1 ± 2.0% | 503.4 ± 0.3% | 1978.0 ± 0.4% | 1121.7 ± 0.4% | 1.631 | 2.223 | 13.489 | 3.433 | 6.053 |
| string: canterbury-large/world192.txt | 1103121 | 4064.0 ± 0.1% | 1654.3 ± 0.4% | 1999.7 ± 1.2% | 448.9 ± 0.6% | 1345.1 ± 0.4% | 909.7 ± 0.1% | 2.457 | 2.032 | 9.054 | 3.021 | 4.467 |
| string: http/html-1m | 1058582 | 6782.8 ± 0.6% | 3963.4 ± 0.5% | 3040.9 ± 0.7% | 498.8 ± 0.4% | 1921.7 ± 0.4% | 807.3 ± 0.2% | 1.711 | 2.231 | 13.598 | 3.530 | 8.402 |
| string: http/json-1m | 1190272 | 3166.4 ± 0.2% | 1357.7 ± 0.1% | 1556.4 ± 0.4% | 442.8 ± 0.8% | 1035.4 ± 0.3% | 765.1 ± 0.7% | 2.332 | 2.034 | 7.151 | 3.058 | 4.138 |
| string: http/js-1m | 1144362 | 2774.2 ± 0.5% | 1180.7 ± 0.5% | 1621.5 ± 0.3% | 369.0 ± 0.4% | 1084.2 ± 0.1% | 758.5 ± 0.5% | 2.350 | 1.711 | 7.518 | 2.559 | 3.658 |
| string: http/css-1m | 1097820 | 4000.0 ± 0.8% | 1494.9 ± 0.3% | 2146.5 ± 1.1% | 494.2 ± 0.7% | 1355.1 ± 0.4% | 895.4 ± 0.3% | 2.676 | 1.863 | 8.094 | 2.952 | 4.467 |
| string: dickens as Cyrillic and CJK | 1883069 | 3070.9 ± 0.5% | 2334.6 ± 0.5% | 520.9 ± 1.1% | 307.1 ± 0.8% | 559.2 ± 0.7% | 336.4 ± 0.3% | 1.315 | 5.896 | 10.001 | 5.491 | 9.130 |
| hex: silesia/dickens | 524290 | 15566.1 ± 0.4% | 1462.2 ± 0.4% | 1083.0 ± 0.5% | 494.6 ± 2.8% | 985.7 ± 0.4% | 735.7 ± 1.8% | 10.645 | 14.373 | 31.470 | 15.791 | 21.159 |
| hex: silesia/mozilla | 524290 | 15614.1 ± 0.2% | 1479.6 ± 0.2% | 1091.7 ± 0.5% | 442.1 ± 0.5% | 993.7 ± 0.6% | 735.4 ± 0.4% | 10.553 | 14.303 | 35.315 | 15.713 | 21.232 |
| hex: silesia/mr | 524290 | 15675.5 ± 0.3% | 1479.8 ± 0.2% | 1093.7 ± 0.5% | 547.8 ± 2.4% | 991.3 ± 0.2% | 735.6 ± 0.4% | 10.593 | 14.333 | 28.614 | 15.812 | 21.309 |
| hex: silesia/nci | 524290 | 15617.6 ± 0.4% | 1474.8 ± 0.3% | 1090.4 ± 0.3% | 634.5 ± 4.8% | 990.6 ± 0.4% | 735.0 ± 0.2% | 10.590 | 14.322 | 24.614 | 15.766 | 21.247 |
| hex: silesia/ooffice | 524290 | 15649.1 ± 0.2% | 1462.9 ± 0.1% | 1085.3 ± 0.3% | 388.8 ± 0.3% | 986.2 ± 0.5% | 735.1 ± 0.2% | 10.697 | 14.419 | 40.245 | 15.868 | 21.289 |
| hex: silesia/osdb | 524290 | 15592.5 ± 0.5% | 1473.5 ± 0.2% | 1089.4 ± 0.2% | 469.1 ± 3.6% | 991.8 ± 0.4% | 735.4 ± 0.2% | 10.582 | 14.312 | 33.243 | 15.722 | 21.202 |
| hex: silesia/reymont | 524290 | 15621.8 ± 0.3% | 1459.6 ± 0.3% | 1086.2 ± 0.7% | 513.3 ± 1.1% | 989.2 ± 0.3% | 735.6 ± 0.3% | 10.703 | 14.382 | 30.436 | 15.792 | 21.237 |
| hex: silesia/samba | 524290 | 15655.5 ± 0.6% | 1467.9 ± 0.5% | 1086.0 ± 0.2% | 403.6 ± 0.6% | 991.9 ± 0.3% | 734.9 ± 0.4% | 10.665 | 14.416 | 38.791 | 15.784 | 21.303 |
| hex: silesia/sao | 524290 | 15647.2 ± 0.2% | 1463.2 ± 0.4% | 1085.8 ± 0.5% | 333.0 ± 0.1% | 987.8 ± 0.4% | 735.1 ± 0.4% | 10.694 | 14.410 | 46.992 | 15.840 | 21.285 |
| hex: silesia/webster | 524290 | 15656.2 ± 0.1% | 1468.3 ± 0.4% | 1086.0 ± 0.2% | 475.7 ± 0.8% | 991.4 ± 0.6% | 734.7 ± 0.6% | 10.663 | 14.416 | 32.914 | 15.792 | 21.311 |
| hex: silesia/x-ray | 524290 | 15551.7 ± 0.5% | 1473.3 ± 0.1% | 1092.8 ± 0.3% | 445.3 ± 0.8% | 996.0 ± 0.2% | 734.0 ± 0.4% | 10.555 | 14.232 | 34.927 | 15.614 | 21.188 |
| hex: silesia/xml | 524290 | 15651.7 ± 0.4% | 1470.3 ± 0.7% | 1086.9 ± 0.3% | 615.8 ± 0.6% | 991.5 ± 0.2% | 733.7 ± 0.3% | 10.646 | 14.400 | 25.416 | 15.786 | 21.331 |
| hex: canterbury/alice29.txt | 304180 | 15698.3 ± 0.1% | 1472.3 ± 0.1% | 1090.3 ± 0.2% | 502.8 ± 0.2% | 991.6 ± 0.4% | 735.4 ± 0.2% | 10.663 | 14.398 | 31.220 | 15.831 | 21.346 |
| hex: canterbury/asyoulik.txt | 250360 | 15715.1 ± 0.1% | 1475.7 ± 0.1% | 1091.9 ± 0.3% | 495.5 ± 1.3% | 993.3 ± 0.4% | 741.1 ± 0.2% | 10.649 | 14.393 | 31.714 | 15.821 | 21.205 |
| hex: canterbury/cp.html | 49208 | 15667.5 ± 0.0% | 1472.4 ± 0.1% | 1095.7 ± 0.4% | 527.6 ± 2.5% | 999.5 ± 0.1% | 742.7 ± 0.2% | 10.640 | 14.299 | 29.698 | 15.675 | 21.096 |
| hex: canterbury/fields.c | 22302 | 15521.2 ± 0.1% | 1398.6 ± 0.5% | 1059.7 ± 0.1% | 635.0 ± 6.6% | 976.2 ± 0.1% | 736.7 ± 0.2% | 11.098 | 14.647 | 24.441 | 15.900 | 21.069 |
| hex: canterbury/grammar.lsp | 7444 | 15163.3 ± 0.1% | 1508.4 ± 0.2% | 1090.2 ± 0.4% | 668.8 ± 3.4% | 979.2 ± 0.4% | 725.9 ± 0.2% | 10.053 | 13.908 | 22.671 | 15.485 | 20.888 |
| hex: canterbury/kennedy.xls | 524290 | 15597.6 ± 0.3% | 1478.1 ± 0.3% | 1088.2 ± 0.6% | 659.9 ± 1.8% | 990.2 ± 0.3% | 735.5 ± 0.3% | 10.552 | 14.334 | 23.637 | 15.751 | 21.207 |
| hex: canterbury/lcet10.txt | 524290 | 15644.8 ± 0.2% | 1467.8 ± 0.2% | 1086.0 ± 0.2% | 503.4 ± 0.3% | 987.3 ± 0.2% | 735.8 ± 0.5% | 10.659 | 14.406 | 31.079 | 15.846 | 21.264 |
| hex: canterbury/plrabn12.txt | 524290 | 15615.9 ± 0.2% | 1468.6 ± 0.1% | 1085.0 ± 1.1% | 493.3 ± 0.6% | 986.7 ± 0.3% | 735.1 ± 0.2% | 10.633 | 14.393 | 31.659 | 15.827 | 21.244 |
| hex: canterbury/ptt5 | 524290 | 15647.7 ± 0.1% | 1486.5 ± 0.6% | 1094.5 ± 0.1% | 553.3 ± 1.0% | 991.6 ± 0.2% | 735.7 ± 0.6% | 10.527 | 14.297 | 28.279 | 15.780 | 21.269 |
| hex: canterbury/sum | 76482 | 15677.5 ± 0.1% | 1494.2 ± 0.1% | 1103.7 ± 0.1% | 594.7 ± 2.2% | 997.9 ± 0.0% | 743.7 ± 0.3% | 10.492 | 14.205 | 26.362 | 15.710 | 21.081 |
| hex: canterbury/xargs.1 | 8456 | 15201.6 ± 0.0% | 1494.5 ± 1.1% | 1087.4 ± 0.4% | 667.8 ± 4.8% | 991.5 ± 0.4% | 728.4 ± 0.2% | 10.172 | 13.980 | 22.765 | 15.331 | 20.871 |
| hex: canterbury-large/E.coli | 524290 | 15703.6 ± 0.1% | 1476.9 ± 0.1% | 1090.5 ± 0.2% | 671.8 ± 0.3% | 992.9 ± 0.3% | 734.5 ± 0.3% | 10.633 | 14.400 | 23.375 | 15.816 | 21.380 |
| hex: canterbury-large/bible.txt | 524290 | 15642.6 ± 0.3% | 1467.4 ± 0.2% | 1082.9 ± 0.5% | 515.1 ± 0.3% | 986.5 ± 0.3% | 735.1 ± 0.8% | 10.660 | 14.446 | 30.370 | 15.856 | 21.281 |
| hex: canterbury-large/world192.txt | 524290 | 15678.9 ± 0.2% | 1467.7 ± 0.3% | 1082.7 ± 0.5% | 503.4 ± 0.7% | 988.7 ± 0.7% | 736.2 ± 0.7% | 10.682 | 14.482 | 31.145 | 15.858 | 21.298 |
| hex: http/html-1kx1024 | 2099200 | 14260.8 ± 0.9% | 1454.6 ± 0.3% | 1062.4 ± 0.3% | 502.0 ± 0.1% | 983.0 ± 0.4% | 692.7 ± 0.1% | 9.804 | 13.424 | 28.410 | 14.507 | 20.586 |
| hex: http/html-16kx64 | 2097280 | 15364.3 ± 0.4% | 1444.7 ± 0.7% | 1075.3 ± 0.1% | 508.5 ± 0.2% | 997.8 ± 0.1% | 735.0 ± 0.2% | 10.635 | 14.288 | 30.217 | 15.398 | 20.905 |
| hex: http/html-1m | 524290 | 15671.2 ± 1.1% | 1467.6 ± 0.2% | 1083.0 ± 0.3% | 502.2 ± 0.4% | 988.4 ± 0.1% | 735.0 ± 0.3% | 10.678 | 14.471 | 31.203 | 15.854 | 21.322 |
| hex: http/json-1kx1024 | 2099200 | 14214.2 ± 0.7% | 1463.8 ± 0.3% | 1066.9 ± 0.1% | 607.7 ± 0.4% | 986.9 ± 0.2% | 692.7 ± 0.3% | 9.710 | 13.323 | 23.390 | 14.402 | 20.519 |
| hex: http/json-16kx64 | 2097280 | 15360.9 ± 0.2% | 1445.0 ± 0.1% | 1074.7 ± 0.3% | 617.4 ± 0.4% | 994.7 ± 0.3% | 735.0 ± 0.3% | 10.630 | 14.294 | 24.878 | 15.443 | 20.899 |
| hex: http/json-1m | 524290 | 15635.0 ± 0.2% | 1477.8 ± 0.5% | 1089.1 ± 0.5% | 636.4 ± 1.1% | 992.0 ± 0.2% | 735.7 ± 0.3% | 10.580 | 14.356 | 24.566 | 15.761 | 21.252 |
| hex: http/js-1kx1024 | 2099200 | 14188.8 ± 0.3% | 1455.8 ± 0.1% | 1064.8 ± 0.2% | 499.6 ± 0.4% | 984.4 ± 0.3% | 692.8 ± 0.2% | 9.747 | 13.326 | 28.399 | 14.413 | 20.479 |
| hex: http/js-16kx64 | 2097280 | 15359.7 ± 0.4% | 1442.6 ± 0.1% | 1073.8 ± 0.2% | 505.7 ± 0.6% | 996.1 ± 0.1% | 734.4 ± 0.2% | 10.647 | 14.304 | 30.372 | 15.420 | 20.915 |
| hex: http/js-1m | 524290 | 15700.3 ± 0.3% | 1471.6 ± 0.2% | 1086.0 ± 0.4% | 512.5 ± 0.7% | 991.1 ± 0.4% | 735.4 ± 0.6% | 10.669 | 14.457 | 30.636 | 15.841 | 21.350 |
| hex: http/css-1kx1024 | 2099200 | 14217.7 ± 0.2% | 1455.2 ± 0.2% | 1063.0 ± 0.2% | 531.2 ± 0.3% | 983.1 ± 0.1% | 692.5 ± 0.2% | 9.770 | 13.375 | 26.765 | 14.462 | 20.531 |
| hex: http/css-16kx64 | 2097280 | 15390.3 ± 0.4% | 1440.5 ± 0.2% | 1075.6 ± 0.1% | 542.6 ± 0.7% | 995.6 ± 0.5% | 733.9 ± 0.2% | 10.684 | 14.308 | 28.365 | 15.459 | 20.972 |
| hex: http/css-1m | 524290 | 15586.3 ± 0.4% | 1468.9 ± 0.2% | 1084.5 ± 0.3% | 529.4 ± 0.3% | 987.9 ± 0.1% | 734.1 ± 0.2% | 10.611 | 14.372 | 29.440 | 15.778 | 21.232 |
| hex: shuffled/dickens-1m | 524290 | 15681.4 ± 0.3% | 1465.9 ± 0.5% | 1083.8 ± 0.3% | 501.9 ± 0.5% | 985.1 ± 0.1% | 736.0 ± 0.6% | 10.698 | 14.469 | 31.243 | 15.918 | 21.306 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.913 of yyjson.
