# bench-json

| Field | Value |
|---|---|
| Commit | 77b711d |
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
| CLDR supplemental, 34 texts | 920675 | 1129.1 ± 0.5% | 0.523 | 0.964 | 0.997 | 0.997 | 0.457 | 1.002 | 1.006 | 0.382 | 0.830 | 0.898 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 855.8 ± 1.1% | 0.818 | 0.995 | 1.003 | 1.004 | 0.444 | 0.999 | 1.029 | 0.392 | 0.916 | 0.981 | 0.124 |
| string: silesia/dickens | 172528 | 5051.4 ± 0.6% | 0.033 | 0.781 | 1.002 | 1.002 | 0.197 | 1.018 | 1.006 | 0.196 | 1.000 | 1.001 | 0.032 |
| string: silesia/nci | 1075110 | 4295.8 ± 0.4% | 0.039 | 0.802 | 1.003 | 1.006 | 0.278 | 1.005 | 1.000 | 0.280 | 1.003 | 1.005 | 0.038 |
| string: silesia/reymont | 1075159 | 2934.4 ± 2.6% | 0.057 | 0.807 | 0.994 | 1.005 | 0.359 | 1.012 | 1.008 | 0.359 | 1.020 | 1.018 | 0.056 |
| string: silesia/samba | 97582 | 3493.6 ± 0.4% | 0.041 | 0.862 | 1.005 | 1.007 | 0.069 | 0.778 | 1.011 | 0.067 | 1.003 | 1.005 | 0.040 |
| string: silesia/webster | 1098490 | 3658.7 ± 0.4% | 0.044 | 0.844 | 1.003 | 1.005 | 0.203 | 1.013 | 1.009 | 0.203 | 1.008 | 1.007 | 0.043 |
| string: silesia/xml | 1090118 | 4777.8 ± 0.7% | 0.035 | 0.808 | 1.004 | 1.008 | 0.221 | 0.982 | 1.008 | 0.219 | 1.006 | 1.007 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4299.9 ± 0.4% | 0.038 | 0.753 | 1.004 | 1.007 | 0.172 | 1.032 | 1.018 | 0.172 | 1.017 | 1.018 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3450.0 ± 1.0% | 0.046 | 0.749 | 1.006 | 1.010 | 0.176 | 1.009 | 0.973 | 0.176 | 1.016 | 1.017 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5120.4 ± 0.3% | 0.032 | 0.810 | 1.004 | 1.004 | 0.196 | 1.019 | 1.005 | 0.195 | 1.002 | 1.004 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4127.8 ± 0.8% | 0.040 | 0.825 | 1.005 | 1.005 | 0.198 | 1.007 | 0.996 | 0.198 | 1.005 | 1.004 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19299.3 ± 0.9% | 0.077 | 1.004 | 1.004 | 1.002 | 0.481 | 1.001 | 1.002 | 0.481 | 0.617 | 0.618 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6679.0 ± 1.6% | 0.026 | 0.802 | 1.008 | 1.011 | 0.433 | 1.033 | 1.041 | 0.433 | 1.035 | 1.036 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3382.9 ± 0.3% | 0.048 | 0.847 | 1.004 | 1.004 | 0.198 | 1.014 | 1.006 | 0.198 | 1.003 | 1.001 | 0.047 |
| string: http/html-1m | 1058582 | 6063.8 ± 1.3% | 0.028 | 0.782 | 1.002 | 1.041 | 0.389 | 1.043 | 1.054 | 0.389 | 1.030 | 1.034 | 0.028 |
| string: http/json-1m | 1190272 | 2550.5 ± 0.3% | 0.055 | 0.948 | 1.003 | 1.004 | 0.109 | 1.002 | 0.471 | 0.110 | 1.002 | 1.002 | 0.055 |
| string: http/js-1m | 1144362 | 2284.3 ± 0.8% | 0.067 | 0.888 | 1.004 | 1.003 | 0.174 | 1.053 | 1.044 | 0.174 | 0.998 | 1.000 | 0.066 |
| string: http/css-1m | 1097820 | 2642.7 ± 0.7% | 0.061 | 0.777 | 1.006 | 1.008 | 0.237 | 1.006 | 1.013 | 0.239 | 1.007 | 1.009 | 0.059 |
| string: dickens as Cyrillic and CJK | 1883069 | 3058.3 ± 0.5% | 0.044 | 0.125 | 1.007 | 1.007 | 0.338 | 1.004 | 1.014 | 0.338 | 1.007 | 1.007 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1326.9 ± 2.0% | 0.085 | 1.004 | 1.003 | 1.003 | 0.078 | 0.638 | 1.006 | 0.075 | 1.002 | 1.003 | 0.085 |
| hex: silesia/dickens | 524290 | 18856.9 ± 0.5% | 0.079 | 1.003 | 0.998 | 0.999 | 0.513 | 1.000 | 1.001 | 0.512 | 0.637 | 0.637 | 0.009 |
| hex: silesia/mozilla | 524290 | 18862.4 ± 0.8% | 0.079 | 0.996 | 0.998 | 0.996 | 0.500 | 0.995 | 0.993 | 0.502 | 0.633 | 0.636 | 0.009 |
| hex: silesia/mr | 524290 | 18720.4 ± 0.9% | 0.079 | 1.001 | 1.001 | 1.002 | 0.517 | 1.004 | 0.999 | 0.517 | 0.642 | 0.642 | 0.009 |
| hex: silesia/nci | 524290 | 19032.4 ± 0.8% | 0.078 | 1.000 | 0.999 | 0.998 | 0.508 | 0.996 | 0.995 | 0.510 | 0.630 | 0.631 | 0.009 |
| hex: silesia/ooffice | 524290 | 18876.3 ± 0.6% | 0.079 | 1.003 | 1.001 | 1.001 | 0.517 | 0.999 | 0.999 | 0.516 | 0.635 | 0.634 | 0.009 |
| hex: silesia/osdb | 524290 | 18704.7 ± 0.6% | 0.079 | 1.005 | 0.999 | 1.000 | 0.510 | 1.002 | 1.001 | 0.509 | 0.641 | 0.641 | 0.009 |
| hex: silesia/reymont | 524290 | 18908.4 ± 0.7% | 0.079 | 1.014 | 0.999 | 0.995 | 0.512 | 1.002 | 0.999 | 0.513 | 0.635 | 0.635 | 0.009 |
| hex: silesia/samba | 524290 | 18636.6 ± 0.4% | 0.080 | 1.009 | 1.004 | 1.003 | 0.520 | 1.007 | 1.007 | 0.521 | 0.642 | 0.644 | 0.009 |
| hex: silesia/sao | 524290 | 19113.2 ± 1.3% | 0.078 | 0.997 | 0.989 | 0.989 | 0.515 | 0.991 | 0.990 | 0.515 | 0.629 | 0.629 | 0.009 |
| hex: silesia/webster | 524290 | 19084.5 ± 0.7% | 0.078 | 1.002 | 0.999 | 0.997 | 0.507 | 0.997 | 0.994 | 0.508 | 0.627 | 0.628 | 0.009 |
| hex: silesia/x-ray | 524290 | 18852.4 ± 0.4% | 0.079 | 1.002 | 0.999 | 1.001 | 0.514 | 1.001 | 1.002 | 0.514 | 0.636 | 0.636 | 0.009 |
| hex: silesia/xml | 524290 | 19036.2 ± 0.5% | 0.078 | 1.002 | 1.004 | 1.003 | 0.509 | 1.002 | 0.999 | 0.509 | 0.631 | 0.631 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19535.5 ± 0.5% | 0.077 | 1.004 | 1.002 | 1.003 | 0.514 | 0.998 | 0.989 | 0.515 | 0.615 | 0.615 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19145.7 ± 0.3% | 0.078 | 1.006 | 0.997 | 0.994 | 0.515 | 1.003 | 1.001 | 0.515 | 0.627 | 0.627 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19308.6 ± 0.2% | 0.082 | 1.002 | 1.001 | 1.000 | 0.541 | 1.002 | 1.002 | 0.542 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18937.7 ± 0.3% | 0.081 | 0.999 | 1.002 | 1.002 | 0.532 | 1.001 | 1.002 | 0.538 | 0.622 | 0.622 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17484.3 ± 2.3% | 0.089 | 1.007 | 1.008 | 1.008 | 0.528 | 1.006 | 1.007 | 0.545 | 0.644 | 0.645 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18921.8 ± 5.0% | 0.078 | 1.007 | 0.998 | 0.997 | 0.502 | 1.000 | 0.999 | 0.503 | 0.633 | 0.631 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18981.8 ± 1.1% | 0.078 | 1.006 | 1.002 | 0.991 | 0.505 | 1.001 | 0.996 | 0.506 | 0.633 | 0.633 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18828.2 ± 0.4% | 0.079 | 1.003 | 0.998 | 0.997 | 0.509 | 1.001 | 1.000 | 0.509 | 0.637 | 0.638 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 18837.7 ± 7.9% | 0.079 | 1.008 | 1.005 | 1.006 | 0.518 | 1.005 | 1.006 | 0.516 | 0.636 | 0.637 | 0.009 |
| hex: canterbury/sum | 76482 | 19296.3 ± 0.3% | 0.078 | 1.002 | 1.003 | 1.002 | 0.517 | 1.001 | 1.002 | 0.519 | 0.618 | 0.617 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17831.9 ± 0.6% | 0.088 | 1.002 | 1.003 | 1.003 | 0.524 | 1.001 | 1.002 | 0.540 | 0.637 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 19045.9 ± 0.7% | 0.078 | 1.001 | 1.000 | 0.998 | 0.512 | 1.005 | 0.998 | 0.514 | 0.631 | 0.631 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18884.4 ± 0.9% | 0.079 | 1.005 | 1.009 | 1.002 | 0.518 | 1.002 | 1.004 | 0.519 | 0.635 | 0.635 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18478.2 ± 0.3% | 0.081 | 1.002 | 1.003 | 1.002 | 0.523 | 1.001 | 1.000 | 0.523 | 0.649 | 0.649 | 0.009 |
| hex: http/html-1kx1024 | 2099200 | 9753.6 ± 14.9% | 0.146 | 1.240 | 1.231 | 1.233 | 0.681 | 1.229 | 0.987 | 0.742 | 0.905 | 0.909 | 0.018 |
| hex: http/html-16kx64 | 2097280 | 18394.8 ± 1.2% | 0.082 | 1.012 | 1.010 | 1.009 | 0.556 | 1.012 | 0.997 | 0.562 | 0.640 | 0.640 | 0.009 |
| hex: http/html-1m | 524290 | 18724.9 ± 0.5% | 0.080 | 1.003 | 1.004 | 1.007 | 0.517 | 1.000 | 1.001 | 0.518 | 0.641 | 0.641 | 0.009 |
| hex: http/json-1kx1024 | 2099200 | 9668.3 ± 18.4% | 0.148 | 1.245 | 1.241 | 1.242 | 0.688 | 1.252 | 0.982 | 0.753 | 0.913 | 0.924 | 0.018 |
| hex: http/json-16kx64 | 2097280 | 18458.6 ± 0.7% | 0.081 | 1.009 | 1.008 | 1.009 | 0.554 | 1.011 | 0.994 | 0.559 | 0.637 | 0.638 | 0.009 |
| hex: http/json-1m | 524290 | 18729.7 ± 2.2% | 0.079 | 1.011 | 1.005 | 1.004 | 0.513 | 1.007 | 1.007 | 0.510 | 0.638 | 0.640 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 9512.8 ± 15.0% | 0.150 | 1.258 | 1.262 | 1.260 | 0.696 | 1.263 | 0.987 | 0.756 | 0.923 | 0.928 | 0.018 |
| hex: http/js-16kx64 | 2097280 | 18361.6 ± 1.6% | 0.082 | 1.014 | 1.012 | 1.013 | 0.556 | 1.014 | 0.999 | 0.560 | 0.640 | 0.641 | 0.009 |
| hex: http/js-1m | 524290 | 19025.3 ± 1.4% | 0.078 | 1.007 | 0.999 | 0.992 | 0.512 | 0.993 | 0.990 | 0.513 | 0.631 | 0.631 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9632.8 ± 18.1% | 0.148 | 1.254 | 1.252 | 1.254 | 0.689 | 1.254 | 0.993 | 0.756 | 0.921 | 0.926 | 0.018 |
| hex: http/css-16kx64 | 2097280 | 18441.2 ± 1.3% | 0.082 | 1.012 | 1.010 | 1.010 | 0.555 | 1.009 | 0.997 | 0.560 | 0.638 | 0.638 | 0.009 |
| hex: http/css-1m | 524290 | 18979.6 ± 0.9% | 0.079 | 1.011 | 1.003 | 1.000 | 0.512 | 1.000 | 0.999 | 0.513 | 0.632 | 0.632 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18597.3 ± 1.7% | 0.080 | 1.011 | 1.004 | 1.004 | 0.514 | 1.008 | 1.006 | 0.515 | 0.645 | 0.645 | 0.009 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1490.1 ± 0.6% | 0.444 | 1.005 | 0.972 | 1.006 | 1.008 | 0.267 | 1.003 | 0.547 | 0.914 | 0.088 | 1.029 |
| qlog records, JSON text sequence | 1467503 | 1267.3 ± 1.0% | 0.690 | 0.979 | 1.012 | 1.012 | 1.013 | 0.265 | 1.003 | 0.503 | 0.831 | 0.105 | 1.018 |
| string: silesia/dickens | 172528 | 6895.2 ± 0.4% | 0.025 | 1.002 | 1.001 | 1.000 | 1.003 | 0.165 | 0.716 | 1.002 | 1.002 | 0.025 | 1.032 |
| string: silesia/nci | 1075110 | 7305.1 ± 0.9% | 0.024 | 1.002 | 1.001 | 1.001 | 1.001 | 0.209 | 0.565 | 1.001 | 1.002 | 0.023 | 1.008 |
| string: silesia/reymont | 1075159 | 3309.6 ± 0.9% | 0.053 | 1.003 | 1.003 | 1.003 | 1.004 | 0.390 | 0.882 | 1.002 | 1.002 | 0.052 | 1.059 |
| string: silesia/samba | 97582 | 4181.2 ± 0.5% | 0.054 | 1.003 | 1.003 | 1.009 | 1.010 | 0.125 | 0.946 | 1.006 | 1.006 | 0.053 | 1.094 |
| string: silesia/webster | 1098490 | 4052.3 ± 0.2% | 0.043 | 1.011 | 1.008 | 1.007 | 1.008 | 0.211 | 0.886 | 1.001 | 1.005 | 0.043 | 1.010 |
| string: silesia/xml | 1090118 | 6121.7 ± 0.4% | 0.029 | 1.001 | 0.997 | 1.006 | 1.004 | 0.252 | 0.775 | 1.000 | 1.004 | 0.029 | 1.016 |
| string: canterbury/alice29.txt | 159425 | 6412.8 ± 0.8% | 0.028 | 1.008 | 1.009 | 1.010 | 1.012 | 0.131 | 0.654 | 1.003 | 1.006 | 0.027 | 1.064 |
| string: canterbury/asyoulik.txt | 132198 | 5573.6 ± 2.2% | 0.030 | 1.026 | 1.034 | 1.034 | 1.036 | 0.129 | 0.599 | 1.003 | 1.014 | 0.030 | 1.054 |
| string: canterbury/lcet10.txt | 441884 | 6237.3 ± 0.7% | 0.028 | 1.007 | 1.008 | 1.009 | 1.006 | 0.183 | 0.803 | 1.001 | 1.003 | 0.028 | 1.000 |
| string: canterbury/plrabn12.txt | 503330 | 5690.4 ± 0.1% | 0.031 | 1.002 | 1.004 | 1.004 | 1.003 | 0.167 | 0.700 | 1.002 | 1.002 | 0.030 | 1.009 |
| string: canterbury-large/E.coli | 1048578 | 19287.7 ± 0.5% | 0.078 | 0.999 | 1.000 | 1.001 | 1.001 | 0.481 | 1.000 | 1.000 | 1.000 | 0.009 | 1.000 |
| string: canterbury-large/bible.txt | 1055886 | 6787.2 ± 0.5% | 0.026 | 1.000 | 1.002 | 1.001 | 1.002 | 0.494 | 0.967 | 1.000 | 1.002 | 0.026 | 0.998 |
| string: canterbury-large/world192.txt | 1103121 | 4024.5 ± 0.4% | 0.043 | 1.019 | 1.017 | 1.018 | 1.019 | 0.192 | 0.830 | 1.003 | 1.010 | 0.043 | 1.004 |
| string: http/html-1m | 1058582 | 6753.6 ± 0.2% | 0.027 | 1.004 | 0.925 | 1.003 | 1.006 | 0.403 | 0.892 | 1.002 | 1.005 | 0.026 | 1.006 |
| string: http/json-1m | 1190272 | 3161.2 ± 0.3% | 0.051 | 1.001 | 0.968 | 1.003 | 1.002 | 0.132 | 0.371 | 1.001 | 1.001 | 0.050 | 1.043 |
| string: http/js-1m | 1144362 | 2756.7 ± 0.9% | 0.061 | 1.005 | 1.008 | 1.001 | 1.008 | 0.163 | 0.839 | 1.002 | 1.007 | 0.060 | 1.014 |
| string: http/css-1m | 1097820 | 3981.5 ± 0.6% | 0.043 | 1.008 | 1.011 | 1.011 | 1.010 | 0.207 | 0.646 | 1.003 | 1.009 | 0.042 | 1.017 |
| string: dickens as Cyrillic and CJK | 1883069 | 3071.4 ± 0.3% | 0.048 | 1.000 | 0.124 | 1.001 | 1.001 | 0.319 | 1.003 | 0.998 | 1.001 | 0.048 | 1.001 |
| hex: silesia/dickens | 524290 | 15626.5 ± 0.1% | 1.001 | 0.178 | 1.003 | 1.003 | 1.002 | 1.002 | 1.002 | 1.002 | 1.002 | 0.178 | 1.003 |
| hex: silesia/mozilla | 524290 | 15584.5 ± 0.2% | 1.002 | 0.179 | 1.003 | 1.001 | 1.002 | 1.001 | 1.003 | 1.003 | 1.003 | 0.178 | 1.002 |
| hex: silesia/mr | 524290 | 15647.4 ± 0.1% | 1.000 | 0.178 | 1.000 | 1.001 | 1.000 | 0.999 | 1.001 | 0.997 | 0.998 | 0.178 | 1.000 |
| hex: silesia/nci | 524290 | 15648.9 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 1.001 | 1.000 | 0.178 | 1.001 |
| hex: silesia/ooffice | 524290 | 15632.2 ± 0.3% | 1.002 | 0.178 | 1.000 | 1.001 | 1.002 | 1.001 | 1.002 | 1.001 | 1.002 | 0.178 | 0.999 |
| hex: silesia/osdb | 524290 | 15650.0 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 1.001 | 1.000 | 1.002 | 1.002 | 0.178 | 1.000 |
| hex: silesia/reymont | 524290 | 15667.0 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.000 | 0.999 | 1.000 | 0.999 | 0.999 | 0.999 | 0.177 | 1.000 |
| hex: silesia/samba | 524290 | 15591.5 ± 0.3% | 1.001 | 0.179 | 1.000 | 1.001 | 1.001 | 1.001 | 1.001 | 1.002 | 1.001 | 0.178 | 1.002 |
| hex: silesia/sao | 524290 | 15653.4 ± 0.3% | 1.001 | 0.178 | 1.001 | 1.002 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.002 |
| hex: silesia/webster | 524290 | 15643.0 ± 0.3% | 1.001 | 0.178 | 1.000 | 1.000 | 0.999 | 1.000 | 0.999 | 0.998 | 1.001 | 0.178 | 0.998 |
| hex: silesia/x-ray | 524290 | 15612.0 ± 0.2% | 1.001 | 0.179 | 0.999 | 0.999 | 1.001 | 0.999 | 1.002 | 1.001 | 1.002 | 0.178 | 1.002 |
| hex: silesia/xml | 524290 | 15615.6 ± 0.1% | 1.002 | 0.179 | 1.001 | 1.002 | 1.002 | 1.000 | 1.001 | 1.001 | 1.000 | 0.178 | 1.002 |
| hex: canterbury/alice29.txt | 304180 | 15691.6 ± 0.0% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15700.7 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15618.9 ± 0.1% | 1.001 | 0.179 | 1.001 | 1.001 | 1.001 | 0.998 | 1.001 | 1.001 | 1.003 | 0.178 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15442.5 ± 0.1% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.994 | 1.000 | 1.001 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14937.5 ± 0.1% | 1.003 | 0.186 | 1.000 | 1.000 | 1.000 | 0.983 | 1.000 | 1.004 | 1.015 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15627.5 ± 0.2% | 1.002 | 0.178 | 1.001 | 1.001 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 0.178 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 15634.4 ± 0.3% | 1.001 | 0.178 | 0.999 | 0.999 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 0.178 | 1.000 |
| hex: canterbury/plrabn12.txt | 524290 | 15654.5 ± 0.2% | 1.000 | 0.178 | 1.000 | 1.001 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 0.177 | 1.002 |
| hex: canterbury/ptt5 | 524290 | 15624.0 ± 0.2% | 1.001 | 0.179 | 0.997 | 0.999 | 1.001 | 0.999 | 1.001 | 1.000 | 1.001 | 0.178 | 1.002 |
| hex: canterbury/sum | 76482 | 15644.7 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 15008.2 ± 0.1% | 1.002 | 0.185 | 1.000 | 1.000 | 1.000 | 0.985 | 1.000 | 1.002 | 1.014 | 0.183 | 1.002 |
| hex: canterbury-large/E.coli | 524290 | 15641.4 ± 0.2% | 1.000 | 0.178 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 1.001 | 1.000 | 0.178 | 1.001 |
| hex: canterbury-large/bible.txt | 524290 | 15614.7 ± 0.3% | 1.002 | 0.179 | 1.002 | 1.001 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 0.178 | 1.003 |
| hex: canterbury-large/world192.txt | 524290 | 15591.2 ± 0.2% | 1.003 | 0.179 | 1.002 | 1.001 | 1.000 | 1.003 | 1.002 | 1.003 | 1.002 | 0.178 | 1.001 |
| hex: http/html-1kx1024 | 2099200 | 13724.2 ± 0.7% | 1.003 | 0.194 | 0.996 | 1.001 | 1.001 | 0.939 | 0.998 | 1.009 | 1.034 | 0.186 | 1.006 |
| hex: http/html-16kx64 | 2097280 | 15225.2 ± 0.2% | 1.002 | 0.181 | 1.004 | 1.002 | 1.001 | 0.993 | 1.000 | 1.004 | 1.007 | 0.179 | 1.002 |
| hex: http/html-1m | 524290 | 15605.2 ± 0.3% | 1.001 | 0.177 | 1.002 | 1.001 | 1.001 | 1.003 | 1.001 | 1.002 | 1.002 | 0.178 | 1.003 |
| hex: http/json-1kx1024 | 2099200 | 13674.9 ± 0.8% | 1.005 | 0.195 | 1.000 | 1.002 | 1.000 | 0.944 | 1.002 | 1.016 | 1.038 | 0.188 | 1.007 |
| hex: http/json-16kx64 | 2097280 | 15233.3 ± 0.2% | 1.000 | 0.181 | 0.997 | 1.001 | 1.000 | 0.992 | 1.002 | 1.002 | 1.007 | 0.180 | 1.006 |
| hex: http/json-1m | 524290 | 15683.0 ± 0.2% | 1.002 | 0.178 | 1.002 | 1.001 | 1.001 | 1.000 | 1.002 | 1.001 | 1.002 | 0.177 | 1.003 |
| hex: http/js-1kx1024 | 2099200 | 13661.1 ± 0.3% | 1.006 | 0.196 | 0.998 | 1.002 | 1.002 | 0.941 | 0.999 | 1.013 | 1.038 | 0.187 | 1.011 |
| hex: http/js-16kx64 | 2097280 | 15239.5 ± 0.2% | 1.003 | 0.181 | 1.002 | 1.000 | 1.001 | 0.990 | 1.000 | 1.007 | 1.008 | 0.180 | 1.004 |
| hex: http/js-1m | 524290 | 15629.3 ± 0.2% | 1.000 | 0.177 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 1.001 | 0.177 | 0.998 |
| hex: http/css-1kx1024 | 2099200 | 13762.4 ± 0.2% | 0.999 | 0.194 | 0.996 | 1.001 | 1.003 | 0.935 | 0.996 | 1.007 | 1.032 | 0.186 | 1.007 |
| hex: http/css-16kx64 | 2097280 | 15210.8 ± 0.5% | 1.001 | 0.181 | 0.997 | 0.998 | 1.001 | 0.990 | 0.996 | 1.007 | 1.010 | 0.180 | 1.002 |
| hex: http/css-1m | 524290 | 15664.8 ± 0.1% | 1.001 | 0.177 | 1.001 | 1.001 | 1.000 | 1.000 | 1.000 | 1.001 | 1.001 | 0.177 | 0.998 |
| hex: shuffled/dickens-1m | 524290 | 15665.0 ± 0.2% | 1.000 | 0.178 | 0.999 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 1.001 | 0.177 | 0.999 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.054 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.053 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.240 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.231 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.233 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.229 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.245 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.241 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.242 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.252 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.258 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.262 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.260 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.263 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.254 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.252 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.254 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.254 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43320.8 ± 0.1% | 47396.5 ± 0.1% | 0.914 | — | — |
| string: silesia/nci | 1048576 | 36831.9 ± 2.4% | 39461.4 ± 2.2% | 0.933 | — | — |
| string: silesia/reymont | 1048576 | 36842.0 ± 1.3% | 39619.7 ± 0.8% | 0.930 | — | — |
| string: silesia/samba | 65546 | 43573.3 ± 0.0% | 48505.4 ± 0.0% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 37240.7 ± 1.1% | 40935.4 ± 2.8% | 0.910 | — | — |
| string: silesia/xml | 1048576 | 32609.5 ± 0.9% | 33756.4 ± 1.0% | 0.966 | — | — |
| string: canterbury/alice29.txt | 152089 | 35848.8 ± 0.1% | 36524.2 ± 0.2% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43302.1 ± 0.0% | 47581.3 ± 0.1% | 0.910 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36014.3 ± 0.2% | 36670.3 ± 0.1% | 0.982 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 43539.4 ± 0.1% | 47597.0 ± 0.3% | 0.915 | — | — |
| string: canterbury-large/E.coli | 1048576 | 36374.0 ± 2.3% | 39389.2 ± 1.8% | 0.923 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32046.1 ± 1.0% | 33028.0 ± 1.8% | 0.970 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 32696.1 ± 1.4% | 33528.1 ± 1.2% | 0.975 | — | — |
| string: http/html-1m | 1048576 | 36096.3 ± 0.9% | 38826.5 ± 1.3% | 0.930 | — | — |
| string: http/json-1m | 1048576 | 31248.3 ± 0.4% | 33400.2 ± 1.4% | 0.936 | — | — |
| string: http/js-1m | 1048576 | 38051.6 ± 2.4% | 41343.6 ± 2.9% | 0.920 | — | — |
| string: http/css-1m | 1048576 | 37751.1 ± 3.4% | 40909.1 ± 3.7% | 0.923 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5769.7 ± 0.7% | 5654.1 ± 0.3% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.914 of simdutf.
- string: silesia/nci: stdx runs at 0.933 of simdutf.
- string: silesia/reymont: stdx runs at 0.930 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.910 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.910 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.915 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.923 of simdutf.
- string: http/html-1m: stdx runs at 0.930 of simdutf.
- string: http/json-1m: stdx runs at 0.936 of simdutf.
- string: http/js-1m: stdx runs at 0.920 of simdutf.
- string: http/css-1m: stdx runs at 0.923 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 39945.5 ± 2.7% | 43931.4 ± 1.0% | 0.909 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 33408.3 ± 0.6% | 34424.8 ± 0.7% | 0.970 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 38011.4 ± 1.4% | 41442.7 ± 5.4% | 0.917 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 39121.1 ± 1.0% | 42970.1 ± 1.0% | 0.910 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 39164.6 ± 1.1% | 43071.8 ± 0.6% | 0.909 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 38985.9 ± 0.7% | 42812.6 ± 0.4% | 0.911 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5763.7 ± 0.1% | 5646.0 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5759.8 ± 0.1% | 5647.7 ± 0.1% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5766.1 ± 0.1% | 5647.3 ± 0.4% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5763.3 ± 0.1% | 5646.6 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5761.4 ± 0.1% | 5645.5 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5763.4 ± 0.1% | 5644.2 ± 0.2% | 1.021 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1129.1 ± 0.5% | 927.2 ± 0.8% | 1016.8 ± 0.2% | 301.3 ± 0.9% | 665.8 ± 0.1% | 310.4 ± 1.3% | 1.218 | 1.110 | 3.748 | 1.696 | 3.638 |
| qlog records, JSON text sequence | 1467503 | 855.8 ± 1.1% | 815.3 ± 0.3% | 795.7 ± 36.2% | 243.0 ± 3.4% | 699.2 ± 14.1% | 252.3 ± 0.7% | 1.050 | 1.076 | 3.522 | 1.224 | 3.391 |
| string: silesia/dickens | 172528 | 5051.4 ± 0.6% | 1875.9 ± 0.3% | 2648.0 ± 0.5% | 360.8 ± 0.4% | 2866.7 ± 0.6% | 554.8 ± 1.8% | 2.693 | 1.908 | 14.001 | 1.762 | 9.104 |
| string: silesia/nci | 1075110 | 4295.8 ± 0.4% | 2240.5 ± 0.3% | 2997.4 ± 0.2% | 545.3 ± 0.9% | 2985.7 ± 0.6% | 608.4 ± 1.1% | 1.917 | 1.433 | 7.877 | 1.439 | 7.061 |
| string: silesia/reymont | 1075159 | 2934.4 ± 2.6% | 1808.0 ± 0.8% | 2062.7 ± 0.5% | 376.2 ± 0.9% | 2142.8 ± 0.4% | 538.2 ± 1.7% | 1.623 | 1.423 | 7.801 | 1.369 | 5.452 |
| string: silesia/samba | 97582 | 3493.6 ± 0.4% | 2025.8 ± 0.2% | 2616.2 ± 0.3% | 324.8 ± 0.5% | 1507.6 ± 0.7% | 431.2 ± 1.8% | 1.725 | 1.335 | 10.758 | 2.317 | 8.102 |
| string: silesia/webster | 1098490 | 3658.7 ± 0.4% | 1519.3 ± 0.3% | 2020.5 ± 0.6% | 359.1 ± 0.4% | 2174.2 ± 1.0% | 501.4 ± 1.4% | 2.408 | 1.811 | 10.189 | 1.683 | 7.298 |
| string: silesia/xml | 1090118 | 4777.8 ± 0.7% | 2359.4 ± 0.4% | 2527.6 ± 0.4% | 451.8 ± 1.0% | 2814.7 ± 1.7% | 569.5 ± 0.8% | 2.025 | 1.890 | 10.574 | 1.697 | 8.389 |
| string: canterbury/alice29.txt | 159425 | 4299.9 ± 0.4% | 1598.7 ± 0.5% | 2458.9 ± 0.8% | 342.1 ± 0.4% | 2517.3 ± 0.3% | 507.3 ± 1.2% | 2.690 | 1.749 | 12.567 | 1.708 | 8.476 |
| string: canterbury/asyoulik.txt | 132198 | 3450.0 ± 1.0% | 1458.5 ± 0.3% | 2249.6 ± 0.6% | 334.9 ± 0.9% | 2091.6 ± 0.2% | 462.6 ± 1.8% | 2.366 | 1.534 | 10.303 | 1.649 | 7.457 |
| string: canterbury/lcet10.txt | 441884 | 5120.4 ± 0.3% | 1854.3 ± 0.2% | 2336.5 ± 0.4% | 390.8 ± 0.3% | 2864.8 ± 0.5% | 537.5 ± 0.7% | 2.761 | 2.191 | 13.101 | 1.787 | 9.526 |
| string: canterbury/plrabn12.txt | 503330 | 4127.8 ± 0.8% | 1736.0 ± 0.3% | 2062.1 ± 0.7% | 360.9 ± 0.4% | 2508.3 ± 0.8% | 503.9 ± 3.4% | 2.378 | 2.002 | 11.438 | 1.646 | 8.191 |
| string: canterbury-large/E.coli | 1048578 | 19299.3 ± 0.9% | 3609.2 ± 0.4% | 3265.2 ± 0.3% | 931.2 ± 0.8% | 5989.9 ± 0.8% | 774.0 ± 0.4% | 5.347 | 5.911 | 20.725 | 3.222 | 24.934 |
| string: canterbury-large/bible.txt | 1055886 | 6679.0 ± 1.6% | 2942.2 ± 0.4% | 2837.5 ± 2.6% | 416.0 ± 0.8% | 3774.8 ± 2.0% | 623.5 ± 0.9% | 2.270 | 2.354 | 16.055 | 1.769 | 10.712 |
| string: canterbury-large/world192.txt | 1103121 | 3382.9 ± 0.3% | 1482.2 ± 0.3% | 2016.5 ± 0.3% | 352.2 ± 0.1% | 2116.9 ± 0.4% | 504.2 ± 0.7% | 2.282 | 1.678 | 9.604 | 1.598 | 6.709 |
| string: http/html-1m | 1058582 | 6063.8 ± 1.3% | 2739.1 ± 0.3% | 2703.3 ± 0.3% | 440.9 ± 0.3% | 3485.2 ± 0.6% | 595.8 ± 1.6% | 2.214 | 2.243 | 13.753 | 1.740 | 10.178 |
| string: http/json-1m | 1190272 | 2550.5 ± 0.3% | 877.2 ± 0.1% | 2254.7 ± 0.4% | 389.4 ± 0.7% | 1030.8 ± 2.2% | 443.5 ± 0.5% | 2.908 | 1.131 | 6.550 | 2.474 | 5.750 |
| string: http/js-1m | 1144362 | 2284.3 ± 0.8% | 1028.9 ± 1.5% | 1637.6 ± 0.4% | 321.0 ± 0.4% | 1518.2 ± 1.3% | 420.5 ± 0.8% | 2.220 | 1.395 | 7.116 | 1.505 | 5.432 |
| string: http/css-1m | 1097820 | 2642.7 ± 0.7% | 1674.9 ± 0.3% | 2228.2 ± 1.2% | 405.1 ± 0.7% | 1913.1 ± 0.4% | 491.6 ± 0.5% | 1.578 | 1.186 | 6.523 | 1.381 | 5.376 |
| string: dickens as Cyrillic and CJK | 1883069 | 3058.3 ± 0.5% | 1688.1 ± 0.4% | 892.9 ± 0.7% | 351.1 ± 0.1% | 668.2 ± 1.1% | 157.4 ± 3.2% | 1.812 | 3.425 | 8.710 | 4.577 | 19.436 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1326.9 ± 2.0% | 980.1 ± 0.3% | 1204.8 ± 0.4% | 214.3 ± 0.1% | 472.8 ± 0.6% | 256.1 ± 4.8% | 1.354 | 1.101 | 6.193 | 2.806 | 5.181 |
| hex: silesia/dickens | 524290 | 18856.9 ± 0.5% | 3624.6 ± 0.8% | 3298.9 ± 0.5% | 506.4 ± 1.1% | 6099.6 ± 0.7% | 785.1 ± 2.0% | 5.203 | 5.716 | 37.236 | 3.092 | 24.020 |
| hex: silesia/mozilla | 524290 | 18862.4 ± 0.8% | 3625.4 ± 0.1% | 3296.5 ± 0.2% | 451.9 ± 0.6% | 5987.2 ± 1.3% | 783.7 ± 0.9% | 5.203 | 5.722 | 41.737 | 3.150 | 24.068 |
| hex: silesia/mr | 524290 | 18720.4 ± 0.9% | 3624.4 ± 0.1% | 3300.8 ± 0.4% | 570.8 ± 1.9% | 6158.2 ± 2.1% | 785.0 ± 0.4% | 5.165 | 5.671 | 32.795 | 3.040 | 23.847 |
| hex: silesia/nci | 524290 | 19032.4 ± 0.8% | 3622.5 ± 0.2% | 3294.1 ± 0.3% | 622.4 ± 1.5% | 6120.9 ± 2.2% | 783.7 ± 0.3% | 5.254 | 5.778 | 30.580 | 3.109 | 24.286 |
| hex: silesia/ooffice | 524290 | 18876.3 ± 0.6% | 3624.8 ± 0.1% | 3304.8 ± 0.4% | 396.1 ± 0.4% | 6076.0 ± 1.6% | 784.3 ± 0.4% | 5.207 | 5.712 | 47.650 | 3.107 | 24.068 |
| hex: silesia/osdb | 524290 | 18704.7 ± 0.6% | 3621.9 ± 0.9% | 3295.9 ± 1.4% | 481.5 ± 0.5% | 6065.9 ± 1.0% | 783.2 ± 0.4% | 5.164 | 5.675 | 38.846 | 3.084 | 23.884 |
| hex: silesia/reymont | 524290 | 18908.4 ± 0.7% | 3624.4 ± 0.2% | 3295.1 ± 0.2% | 513.9 ± 1.7% | 6121.6 ± 1.1% | 783.6 ± 0.2% | 5.217 | 5.738 | 36.791 | 3.089 | 24.131 |
| hex: silesia/samba | 524290 | 18636.6 ± 0.4% | 3623.6 ± 0.3% | 3296.9 ± 0.2% | 404.5 ± 1.1% | 6139.3 ± 0.7% | 783.5 ± 0.8% | 5.143 | 5.653 | 46.072 | 3.036 | 23.787 |
| hex: silesia/sao | 524290 | 19113.2 ± 1.3% | 3622.4 ± 0.5% | 3290.7 ± 0.1% | 341.5 ± 0.9% | 6137.2 ± 1.1% | 784.0 ± 0.3% | 5.276 | 5.808 | 55.964 | 3.114 | 24.378 |
| hex: silesia/webster | 524290 | 19084.5 ± 0.7% | 3623.3 ± 0.2% | 3294.8 ± 0.3% | 462.0 ± 1.5% | 6103.1 ± 0.6% | 783.7 ± 0.5% | 5.267 | 5.792 | 41.307 | 3.127 | 24.351 |
| hex: silesia/x-ray | 524290 | 18852.4 ± 0.4% | 3623.6 ± 0.2% | 3295.9 ± 0.3% | 466.8 ± 2.3% | 6082.2 ± 1.1% | 782.4 ± 0.3% | 5.203 | 5.720 | 40.383 | 3.100 | 24.095 |
| hex: silesia/xml | 524290 | 19036.2 ± 0.5% | 3624.7 ± 0.2% | 3293.8 ± 0.3% | 511.0 ± 0.6% | 6104.4 ± 1.1% | 782.3 ± 0.4% | 5.252 | 5.779 | 37.255 | 3.118 | 24.335 |
| hex: canterbury/alice29.txt | 304180 | 19535.5 ± 0.5% | 3635.1 ± 0.1% | 3334.3 ± 0.1% | 499.7 ± 1.5% | 6059.1 ± 1.0% | 783.4 ± 0.6% | 5.374 | 5.859 | 39.097 | 3.224 | 24.935 |
| hex: canterbury/asyoulik.txt | 250360 | 19145.7 ± 0.3% | 3643.2 ± 0.1% | 3374.8 ± 0.0% | 502.8 ± 0.3% | 6106.2 ± 0.7% | 782.1 ± 0.8% | 5.255 | 5.673 | 38.078 | 3.135 | 24.479 |
| hex: canterbury/cp.html | 49208 | 19308.6 ± 0.2% | 3640.7 ± 0.0% | 3286.1 ± 0.3% | 467.7 ± 0.9% | 6286.5 ± 0.7% | 767.1 ± 0.7% | 5.304 | 5.876 | 41.282 | 3.071 | 25.171 |
| hex: canterbury/fields.c | 22302 | 18937.7 ± 0.3% | 3629.5 ± 0.0% | 3353.6 ± 0.0% | 497.5 ± 1.1% | 6261.7 ± 0.2% | 760.9 ± 2.8% | 5.218 | 5.647 | 38.067 | 3.024 | 24.888 |
| hex: canterbury/grammar.lsp | 7444 | 17484.3 ± 2.3% | 3601.2 ± 0.0% | 3343.7 ± 0.4% | 539.8 ± 1.1% | 6178.1 ± 0.5% | 709.1 ± 3.1% | 4.855 | 5.229 | 32.389 | 2.830 | 24.658 |
| hex: canterbury/kennedy.xls | 524290 | 18921.8 ± 5.0% | 3623.7 ± 0.2% | 3295.0 ± 0.2% | 657.4 ± 1.3% | 6081.2 ± 0.7% | 784.2 ± 3.5% | 5.222 | 5.743 | 28.785 | 3.112 | 24.129 |
| hex: canterbury/lcet10.txt | 524290 | 18981.8 ± 1.1% | 3617.8 ± 0.9% | 3293.4 ± 0.3% | 512.5 ± 1.8% | 6080.6 ± 1.0% | 779.1 ± 3.9% | 5.247 | 5.764 | 37.035 | 3.122 | 24.364 |
| hex: canterbury/plrabn12.txt | 524290 | 18828.2 ± 0.4% | 3625.1 ± 0.2% | 3294.0 ± 0.3% | 505.2 ± 3.1% | 6077.2 ± 0.9% | 783.5 ± 0.4% | 5.194 | 5.716 | 37.269 | 3.098 | 24.030 |
| hex: canterbury/ptt5 | 524290 | 18837.7 ± 7.9% | 3623.6 ± 0.5% | 3295.6 ± 0.5% | 562.6 ± 0.8% | 6038.0 ± 1.0% | 784.6 ± 2.9% | 5.199 | 5.716 | 33.484 | 3.120 | 24.011 |
| hex: canterbury/sum | 76482 | 19296.3 ± 0.3% | 3634.3 ± 0.0% | 3360.6 ± 0.4% | 522.0 ± 0.5% | 6176.8 ± 0.6% | 775.8 ± 1.3% | 5.310 | 5.742 | 36.964 | 3.124 | 24.871 |
| hex: canterbury/xargs.1 | 8456 | 17831.9 ± 0.6% | 3602.3 ± 0.0% | 3355.6 ± 0.2% | 501.7 ± 1.0% | 6152.5 ± 0.2% | 753.3 ± 3.0% | 4.950 | 5.314 | 35.540 | 2.898 | 23.671 |
| hex: canterbury-large/E.coli | 524290 | 19045.9 ± 0.7% | 3618.8 ± 0.1% | 3295.0 ± 0.3% | 689.4 ± 0.4% | 6108.9 ± 1.0% | 776.8 ± 8.6% | 5.263 | 5.780 | 27.628 | 3.118 | 24.518 |
| hex: canterbury-large/bible.txt | 524290 | 18884.4 ± 0.9% | 3620.2 ± 0.4% | 3297.9 ± 0.3% | 520.6 ± 2.5% | 6103.4 ± 1.1% | 784.2 ± 0.5% | 5.216 | 5.726 | 36.273 | 3.094 | 24.081 |
| hex: canterbury-large/world192.txt | 524290 | 18478.2 ± 0.3% | 3619.7 ± 0.2% | 3291.8 ± 0.4% | 499.8 ± 1.7% | 6087.9 ± 1.1% | 784.9 ± 0.5% | 5.105 | 5.613 | 36.969 | 3.035 | 23.543 |
| hex: http/html-1kx1024 | 2099200 | 9753.6 ± 14.9% | 3464.1 ± 0.4% | 2880.5 ± 4.6% | 473.7 ± 0.6% | 5165.0 ± 0.4% | 633.7 ± 3.7% | 2.816 | 3.386 | 20.592 | 1.888 | 15.390 |
| hex: http/html-16kx64 | 2097280 | 18394.8 ± 1.2% | 3612.6 ± 0.1% | 3267.3 ± 0.2% | 479.8 ± 0.5% | 6014.8 ± 0.4% | 745.3 ± 2.0% | 5.092 | 5.630 | 38.341 | 3.058 | 24.680 |
| hex: http/html-1m | 524290 | 18724.9 ± 0.5% | 3619.7 ± 0.2% | 3298.3 ± 0.2% | 501.5 ± 1.1% | 6103.1 ± 1.2% | 780.8 ± 2.0% | 5.173 | 5.677 | 37.341 | 3.068 | 23.982 |
| hex: http/json-1kx1024 | 2099200 | 9668.3 ± 18.4% | 3465.0 ± 0.0% | 2881.5 ± 0.5% | 574.2 ± 0.6% | 5131.7 ± 1.0% | 635.8 ± 4.4% | 2.790 | 3.355 | 16.837 | 1.884 | 15.205 |
| hex: http/json-16kx64 | 2097280 | 18458.6 ± 0.7% | 3611.5 ± 0.0% | 3278.6 ± 0.2% | 569.1 ± 0.2% | 6033.7 ± 1.6% | 752.0 ± 1.8% | 5.111 | 5.630 | 32.435 | 3.059 | 24.547 |
| hex: http/json-1m | 524290 | 18729.7 ± 2.2% | 3622.5 ± 0.0% | 3297.2 ± 0.1% | 582.3 ± 1.3% | 5993.0 ± 0.8% | 781.7 ± 1.6% | 5.170 | 5.680 | 32.162 | 3.125 | 23.961 |
| hex: http/js-1kx1024 | 2099200 | 9512.8 ± 15.0% | 3462.3 ± 0.2% | 2875.7 ± 0.3% | 479.9 ± 2.4% | 5131.0 ± 0.2% | 629.8 ± 4.0% | 2.748 | 3.308 | 19.822 | 1.854 | 15.104 |
| hex: http/js-16kx64 | 2097280 | 18361.6 ± 1.6% | 3611.4 ± 0.1% | 3259.3 ± 0.1% | 476.3 ± 1.8% | 6016.1 ± 0.4% | 735.6 ± 2.4% | 5.084 | 5.634 | 38.547 | 3.052 | 24.960 |
| hex: http/js-1m | 524290 | 19025.3 ± 1.4% | 3623.9 ± 0.2% | 3297.6 ± 0.2% | 496.3 ± 0.7% | 6111.9 ± 1.0% | 775.8 ± 3.8% | 5.250 | 5.769 | 38.332 | 3.113 | 24.523 |
| hex: http/css-1kx1024 | 2099200 | 9632.8 ± 18.1% | 3463.2 ± 0.1% | 2886.3 ± 0.4% | 489.5 ± 0.3% | 5122.0 ± 1.3% | 634.7 ± 2.2% | 2.781 | 3.337 | 19.679 | 1.881 | 15.178 |
| hex: http/css-16kx64 | 2097280 | 18441.2 ± 1.3% | 3614.5 ± 0.1% | 3267.5 ± 0.1% | 491.4 ± 0.6% | 6019.1 ± 0.3% | 748.5 ± 1.9% | 5.102 | 5.644 | 37.531 | 3.064 | 24.638 |
| hex: http/css-1m | 524290 | 18979.6 ± 0.9% | 3626.9 ± 0.1% | 3302.7 ± 0.3% | 492.4 ± 1.9% | 6030.4 ± 1.0% | 764.2 ± 3.8% | 5.233 | 5.747 | 38.545 | 3.147 | 24.836 |
| hex: shuffled/dickens-1m | 524290 | 18597.3 ± 1.7% | 3625.9 ± 0.1% | 3301.5 ± 0.2% | 517.5 ± 2.0% | 6156.6 ± 1.1% | 783.0 ± 0.7% | 5.129 | 5.633 | 35.940 | 3.021 | 23.751 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1490.1 ± 0.6% | 1258.0 ± 0.3% | 1043.4 ± 0.3% | 409.6 ± 0.3% | 449.2 ± 0.4% | 416.9 ± 0.6% | 1.185 | 1.428 | 3.638 | 3.318 | 3.575 |
| qlog records, JSON text sequence | 1467503 | 1267.3 ± 1.0% | 1063.5 ± 0.5% | 790.8 ± 1.1% | 379.9 ± 1.8% | 478.8 ± 8.9% | 279.7 ± 2.4% | 1.192 | 1.603 | 3.336 | 2.647 | 4.532 |
| string: silesia/dickens | 172528 | 6895.2 ± 0.4% | 2813.2 ± 0.6% | 2935.4 ± 0.6% | 430.9 ± 0.5% | 1596.8 ± 0.7% | 1009.9 ± 0.1% | 2.451 | 2.349 | 16.000 | 4.318 | 6.828 |
| string: silesia/nci | 1075110 | 7305.1 ± 0.9% | 3412.8 ± 1.0% | 3100.4 ± 0.6% | 808.1 ± 1.0% | 1864.9 ± 0.6% | 1109.8 ± 0.9% | 2.140 | 2.356 | 9.040 | 3.917 | 6.582 |
| string: silesia/reymont | 1075159 | 3309.6 ± 0.9% | 1969.7 ± 0.8% | 2060.8 ± 0.2% | 450.8 ± 0.3% | 1508.7 ± 0.1% | 949.1 ± 0.7% | 1.680 | 1.606 | 7.341 | 2.194 | 3.487 |
| string: silesia/samba | 97582 | 4181.2 ± 0.5% | 2105.8 ± 0.4% | 3447.1 ± 0.9% | 353.7 ± 0.3% | 1485.5 ± 0.4% | 1055.5 ± 0.3% | 1.986 | 1.213 | 11.820 | 2.815 | 3.961 |
| string: silesia/webster | 1098490 | 4052.3 ± 0.2% | 1876.3 ± 0.2% | 2059.8 ± 0.7% | 441.5 ± 0.6% | 1401.1 ± 0.2% | 646.9 ± 0.2% | 2.160 | 1.967 | 9.178 | 2.892 | 6.264 |
| string: silesia/xml | 1090118 | 6121.7 ± 0.4% | 2874.3 ± 0.7% | 2653.9 ± 0.5% | 606.4 ± 0.8% | 1758.5 ± 0.3% | 924.0 ± 0.2% | 2.130 | 2.307 | 10.094 | 3.481 | 6.625 |
| string: canterbury/alice29.txt | 159425 | 6412.8 ± 0.8% | 2201.0 ± 0.7% | 2759.1 ± 0.6% | 408.2 ± 0.4% | 1470.1 ± 0.2% | 956.4 ± 0.1% | 2.914 | 2.324 | 15.709 | 4.362 | 6.705 |
| string: canterbury/asyoulik.txt | 132198 | 5573.6 ± 2.2% | 1714.2 ± 0.1% | 2379.2 ± 1.2% | 402.0 ± 0.5% | 1332.9 ± 0.5% | 885.0 ± 0.3% | 3.251 | 2.343 | 13.863 | 4.182 | 6.298 |
| string: canterbury/lcet10.txt | 441884 | 6237.3 ± 0.7% | 2570.7 ± 0.4% | 2499.5 ± 1.1% | 468.5 ± 1.2% | 1554.3 ± 0.3% | 986.5 ± 0.4% | 2.426 | 2.495 | 13.314 | 4.013 | 6.322 |
| string: canterbury/plrabn12.txt | 503330 | 5690.4 ± 0.1% | 2065.3 ± 0.4% | 2067.1 ± 0.7% | 423.5 ± 0.5% | 1394.4 ± 0.4% | 931.9 ± 0.3% | 2.755 | 2.753 | 13.438 | 4.081 | 6.106 |
| string: canterbury-large/E.coli | 1048578 | 19287.7 ± 0.5% | 9745.1 ± 1.7% | 3794.8 ± 0.3% | 1480.7 ± 0.1% | 2371.7 ± 0.6% | 1196.7 ± 0.8% | 1.979 | 5.083 | 13.026 | 8.132 | 16.117 |
| string: canterbury-large/bible.txt | 1055886 | 6787.2 ± 0.5% | 4160.1 ± 1.1% | 3022.4 ± 1.7% | 502.5 ± 0.7% | 1987.1 ± 0.4% | 1121.7 ± 0.5% | 1.631 | 2.246 | 13.507 | 3.416 | 6.051 |
| string: canterbury-large/world192.txt | 1103121 | 4024.5 ± 0.4% | 1650.8 ± 0.6% | 2005.8 ± 0.7% | 451.0 ± 0.4% | 1372.6 ± 0.5% | 909.0 ± 0.2% | 2.438 | 2.006 | 8.923 | 2.932 | 4.428 |
| string: http/html-1m | 1058582 | 6753.6 ± 0.2% | 3976.7 ± 0.4% | 3047.1 ± 0.6% | 500.2 ± 0.7% | 1934.6 ± 0.2% | 805.2 ± 0.4% | 1.698 | 2.216 | 13.503 | 3.491 | 8.388 |
| string: http/json-1m | 1190272 | 3161.2 ± 0.3% | 1354.9 ± 0.1% | 1559.2 ± 0.4% | 443.0 ± 0.4% | 1072.0 ± 0.2% | 766.5 ± 1.6% | 2.333 | 2.027 | 7.135 | 2.949 | 4.124 |
| string: http/js-1m | 1144362 | 2756.7 ± 0.9% | 1176.9 ± 0.4% | 1626.4 ± 0.4% | 369.1 ± 0.3% | 1110.4 ± 0.4% | 757.4 ± 0.3% | 2.342 | 1.695 | 7.469 | 2.483 | 3.640 |
| string: http/css-1m | 1097820 | 3981.5 ± 0.6% | 1488.3 ± 0.1% | 2149.6 ± 0.7% | 493.9 ± 0.4% | 1382.2 ± 0.4% | 895.7 ± 0.3% | 2.675 | 1.852 | 8.061 | 2.881 | 4.445 |
| string: dickens as Cyrillic and CJK | 1883069 | 3071.4 ± 0.3% | 2342.2 ± 0.4% | 521.0 ± 0.4% | 307.4 ± 0.6% | 563.8 ± 0.6% | 336.2 ± 0.5% | 1.311 | 5.895 | 9.993 | 5.448 | 9.136 |
| hex: silesia/dickens | 524290 | 15626.5 ± 0.1% | 1468.8 ± 0.2% | 1085.7 ± 0.4% | 501.0 ± 2.4% | 993.1 ± 0.3% | 735.3 ± 0.2% | 10.639 | 14.393 | 31.191 | 15.735 | 21.252 |
| hex: silesia/mozilla | 524290 | 15584.5 ± 0.2% | 1472.9 ± 0.3% | 1087.2 ± 0.3% | 441.8 ± 0.4% | 993.4 ± 0.2% | 733.9 ± 0.3% | 10.581 | 14.334 | 35.276 | 15.687 | 21.234 |
| hex: silesia/mr | 524290 | 15647.4 ± 0.1% | 1484.6 ± 0.1% | 1091.7 ± 0.1% | 556.3 ± 0.9% | 995.9 ± 0.5% | 735.6 ± 0.3% | 10.540 | 14.333 | 28.127 | 15.713 | 21.272 |
| hex: silesia/nci | 524290 | 15648.9 ± 0.2% | 1474.6 ± 0.3% | 1090.7 ± 0.3% | 616.4 ± 5.1% | 993.0 ± 0.3% | 734.5 ± 0.6% | 10.612 | 14.347 | 25.390 | 15.759 | 21.306 |
| hex: silesia/ooffice | 524290 | 15632.2 ± 0.3% | 1468.9 ± 0.1% | 1085.8 ± 0.3% | 390.1 ± 0.3% | 991.5 ± 0.3% | 734.8 ± 0.3% | 10.642 | 14.397 | 40.072 | 15.766 | 21.274 |
| hex: silesia/osdb | 524290 | 15650.0 ± 0.2% | 1471.2 ± 0.4% | 1086.4 ± 0.4% | 465.2 ± 2.0% | 992.2 ± 0.3% | 734.9 ± 0.4% | 10.638 | 14.405 | 33.643 | 15.773 | 21.296 |
| hex: silesia/reymont | 524290 | 15667.0 ± 0.2% | 1472.0 ± 0.6% | 1086.0 ± 1.1% | 511.9 ± 1.2% | 993.2 ± 0.4% | 734.6 ± 0.1% | 10.643 | 14.426 | 30.606 | 15.773 | 21.327 |
| hex: silesia/samba | 524290 | 15591.5 ± 0.3% | 1469.4 ± 0.4% | 1084.8 ± 0.2% | 402.6 ± 1.0% | 989.9 ± 0.3% | 734.7 ± 0.3% | 10.611 | 14.373 | 38.730 | 15.750 | 21.221 |
| hex: silesia/sao | 524290 | 15653.4 ± 0.3% | 1468.1 ± 0.2% | 1084.6 ± 0.5% | 332.7 ± 0.4% | 990.9 ± 0.2% | 735.4 ± 0.1% | 10.662 | 14.433 | 47.046 | 15.797 | 21.286 |
| hex: silesia/webster | 524290 | 15643.0 ± 0.3% | 1466.7 ± 0.2% | 1084.6 ± 0.4% | 475.6 ± 0.4% | 988.3 ± 0.2% | 735.4 ± 0.3% | 10.666 | 14.423 | 32.893 | 15.828 | 21.273 |
| hex: silesia/x-ray | 524290 | 15612.0 ± 0.2% | 1480.5 ± 0.1% | 1089.5 ± 0.4% | 444.9 ± 1.1% | 999.6 ± 0.3% | 735.2 ± 0.5% | 10.545 | 14.330 | 35.091 | 15.619 | 21.235 |
| hex: silesia/xml | 524290 | 15615.6 ± 0.1% | 1468.9 ± 0.3% | 1088.4 ± 0.3% | 613.5 ± 1.4% | 991.1 ± 0.5% | 733.2 ± 0.6% | 10.631 | 14.347 | 25.454 | 15.756 | 21.298 |
| hex: canterbury/alice29.txt | 304180 | 15691.6 ± 0.0% | 1475.6 ± 0.6% | 1094.4 ± 0.2% | 501.2 ± 1.7% | 996.8 ± 0.3% | 734.5 ± 0.3% | 10.634 | 14.339 | 31.305 | 15.742 | 21.364 |
| hex: canterbury/asyoulik.txt | 250360 | 15700.7 ± 0.1% | 1474.4 ± 0.4% | 1095.9 ± 0.1% | 495.2 ± 3.4% | 996.1 ± 0.3% | 738.0 ± 0.2% | 10.649 | 14.327 | 31.704 | 15.761 | 21.275 |
| hex: canterbury/cp.html | 49208 | 15618.9 ± 0.1% | 1471.6 ± 0.1% | 1100.7 ± 0.2% | 522.0 ± 2.8% | 1004.9 ± 0.5% | 742.7 ± 0.2% | 10.613 | 14.190 | 29.922 | 15.542 | 21.031 |
| hex: canterbury/fields.c | 22302 | 15442.5 ± 0.1% | 1423.5 ± 0.1% | 1078.1 ± 0.2% | 632.8 ± 6.2% | 986.5 ± 0.3% | 737.4 ± 0.1% | 10.848 | 14.324 | 24.402 | 15.654 | 20.941 |
| hex: canterbury/grammar.lsp | 7444 | 14937.5 ± 0.1% | 1507.4 ± 0.2% | 1099.2 ± 0.3% | 658.1 ± 4.9% | 998.8 ± 0.3% | 726.0 ± 0.2% | 9.910 | 13.590 | 22.697 | 14.955 | 20.574 |
| hex: canterbury/kennedy.xls | 524290 | 15627.5 ± 0.2% | 1478.4 ± 0.2% | 1090.8 ± 0.4% | 659.1 ± 1.3% | 991.6 ± 0.5% | 733.5 ± 0.6% | 10.570 | 14.326 | 23.710 | 15.760 | 21.306 |
| hex: canterbury/lcet10.txt | 524290 | 15634.4 ± 0.3% | 1468.3 ± 0.3% | 1088.6 ± 0.2% | 501.7 ± 0.5% | 991.2 ± 0.7% | 733.8 ± 0.5% | 10.648 | 14.362 | 31.161 | 15.773 | 21.306 |
| hex: canterbury/plrabn12.txt | 524290 | 15654.5 ± 0.2% | 1467.1 ± 0.1% | 1083.3 ± 0.5% | 493.0 ± 0.8% | 991.1 ± 0.9% | 734.8 ± 1.1% | 10.670 | 14.451 | 31.755 | 15.795 | 21.305 |
| hex: canterbury/ptt5 | 524290 | 15624.0 ± 0.2% | 1483.5 ± 0.4% | 1092.7 ± 0.3% | 554.3 ± 0.6% | 996.1 ± 0.4% | 736.1 ± 0.4% | 10.532 | 14.299 | 28.188 | 15.686 | 21.226 |
| hex: canterbury/sum | 76482 | 15644.7 ± 0.1% | 1493.3 ± 0.2% | 1105.1 ± 0.2% | 592.8 ± 1.7% | 998.3 ± 0.0% | 743.7 ± 0.2% | 10.477 | 14.157 | 26.390 | 15.671 | 21.037 |
| hex: canterbury/xargs.1 | 8456 | 15008.2 ± 0.1% | 1493.7 ± 0.3% | 1097.8 ± 0.4% | 639.6 ± 1.2% | 1000.4 ± 0.3% | 728.3 ± 0.2% | 10.048 | 13.672 | 23.464 | 15.003 | 20.607 |
| hex: canterbury-large/E.coli | 524290 | 15641.4 ± 0.2% | 1476.4 ± 0.4% | 1093.4 ± 0.3% | 672.9 ± 0.3% | 995.8 ± 0.6% | 734.8 ± 0.4% | 10.594 | 14.305 | 23.246 | 15.707 | 21.287 |
| hex: canterbury-large/bible.txt | 524290 | 15614.7 ± 0.3% | 1466.1 ± 0.3% | 1083.5 ± 0.2% | 514.3 ± 0.7% | 988.1 ± 0.5% | 734.7 ± 0.5% | 10.651 | 14.412 | 30.363 | 15.803 | 21.254 |
| hex: canterbury-large/world192.txt | 524290 | 15591.2 ± 0.2% | 1470.9 ± 0.3% | 1086.6 ± 0.2% | 499.0 ± 1.1% | 994.0 ± 0.2% | 734.7 ± 0.2% | 10.600 | 14.348 | 31.248 | 15.686 | 21.222 |
| hex: http/html-1kx1024 | 2099200 | 13724.2 ± 0.7% | 1456.2 ± 0.2% | 1062.4 ± 0.1% | 500.2 ± 0.4% | 983.2 ± 0.0% | 692.8 ± 0.2% | 9.425 | 12.919 | 27.439 | 13.958 | 19.810 |
| hex: http/html-16kx64 | 2097280 | 15225.2 ± 0.2% | 1445.2 ± 0.2% | 1076.8 ± 0.5% | 505.6 ± 1.0% | 996.1 ± 0.2% | 735.6 ± 0.2% | 10.535 | 14.139 | 30.113 | 15.285 | 20.697 |
| hex: http/html-1m | 524290 | 15605.2 ± 0.3% | 1471.9 ± 0.3% | 1084.1 ± 0.1% | 497.8 ± 0.2% | 991.7 ± 0.2% | 734.5 ± 0.2% | 10.602 | 14.395 | 31.345 | 15.736 | 21.247 |
| hex: http/json-1kx1024 | 2099200 | 13674.9 ± 0.8% | 1464.3 ± 0.2% | 1068.3 ± 0.2% | 602.7 ± 2.0% | 987.0 ± 0.1% | 692.9 ± 0.1% | 9.339 | 12.800 | 22.691 | 13.854 | 19.736 |
| hex: http/json-16kx64 | 2097280 | 15233.3 ± 0.2% | 1448.1 ± 0.3% | 1076.6 ± 0.2% | 616.4 ± 0.5% | 997.0 ± 0.1% | 734.4 ± 0.2% | 10.519 | 14.149 | 24.714 | 15.279 | 20.742 |
| hex: http/json-1m | 524290 | 15683.0 ± 0.2% | 1477.4 ± 0.2% | 1087.9 ± 0.4% | 632.3 ± 0.3% | 993.2 ± 0.2% | 734.4 ± 0.6% | 10.615 | 14.416 | 24.805 | 15.791 | 21.354 |
| hex: http/js-1kx1024 | 2099200 | 13661.1 ± 0.3% | 1458.7 ± 0.4% | 1064.4 ± 0.4% | 498.3 ± 0.2% | 984.9 ± 0.2% | 693.1 ± 0.1% | 9.365 | 12.834 | 27.416 | 13.871 | 19.711 |
| hex: http/js-16kx64 | 2097280 | 15239.5 ± 0.2% | 1448.2 ± 0.1% | 1076.5 ± 0.2% | 503.6 ± 0.4% | 998.1 ± 0.4% | 735.3 ± 0.2% | 10.523 | 14.156 | 30.263 | 15.269 | 20.725 |
| hex: http/js-1m | 524290 | 15629.3 ± 0.2% | 1467.7 ± 0.3% | 1087.9 ± 0.5% | 510.9 ± 0.4% | 991.9 ± 0.1% | 734.4 ± 0.2% | 10.649 | 14.367 | 30.593 | 15.758 | 21.281 |
| hex: http/css-1kx1024 | 2099200 | 13762.4 ± 0.2% | 1456.5 ± 0.2% | 1063.6 ± 0.2% | 529.8 ± 0.4% | 983.9 ± 0.1% | 692.8 ± 0.1% | 9.449 | 12.939 | 25.977 | 13.987 | 19.864 |
| hex: http/css-16kx64 | 2097280 | 15210.8 ± 0.5% | 1445.0 ± 0.2% | 1076.0 ± 0.2% | 539.9 ± 0.8% | 999.4 ± 0.4% | 735.3 ± 0.1% | 10.527 | 14.137 | 28.171 | 15.220 | 20.686 |
| hex: http/css-1m | 524290 | 15664.8 ± 0.1% | 1467.6 ± 0.2% | 1085.1 ± 0.3% | 526.7 ± 0.2% | 992.8 ± 0.4% | 734.6 ± 0.4% | 10.674 | 14.437 | 29.743 | 15.778 | 21.324 |
| hex: shuffled/dickens-1m | 524290 | 15665.0 ± 0.2% | 1470.5 ± 0.4% | 1087.4 ± 0.6% | 500.4 ± 0.7% | 992.5 ± 0.6% | 733.0 ± 0.3% | 10.653 | 14.406 | 31.306 | 15.784 | 21.372 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1533.6 ± 0.5% | 1258.0 ± 0.3% | 1043.4 ± 0.3% | 409.6 ± 0.3% | 449.2 ± 0.4% | 416.9 ± 0.6% | 1.219 | 1.470 | 3.744 | 3.414 | 3.679 |
| qlog records, JSON text sequence | 1467503 | 1290.5 ± 0.8% | 1063.5 ± 0.5% | 790.8 ± 1.1% | 379.9 ± 1.8% | 478.8 ± 8.9% | 279.7 ± 2.4% | 1.213 | 1.632 | 3.397 | 2.695 | 4.614 |
| string: silesia/dickens | 172528 | 7113.7 ± 0.5% | 2813.2 ± 0.6% | 2935.4 ± 0.6% | 430.9 ± 0.5% | 1596.8 ± 0.7% | 1009.9 ± 0.1% | 2.529 | 2.423 | 16.507 | 4.455 | 7.044 |
| string: silesia/nci | 1075110 | 7363.3 ± 6.3% | 3412.8 ± 1.0% | 3100.4 ± 0.6% | 808.1 ± 1.0% | 1864.9 ± 0.6% | 1109.8 ± 0.9% | 2.158 | 2.375 | 9.112 | 3.948 | 6.635 |
| string: silesia/reymont | 1075159 | 3504.8 ± 1.3% | 1969.7 ± 0.8% | 2060.8 ± 0.2% | 450.8 ± 0.3% | 1508.7 ± 0.1% | 949.1 ± 0.7% | 1.779 | 1.701 | 7.774 | 2.323 | 3.693 |
| string: silesia/samba | 97582 | 4576.0 ± 1.9% | 2105.8 ± 0.4% | 3447.1 ± 0.9% | 353.7 ± 0.3% | 1485.5 ± 0.4% | 1055.5 ± 0.3% | 2.173 | 1.328 | 12.937 | 3.080 | 4.335 |
| string: silesia/webster | 1098490 | 4091.3 ± 1.0% | 1876.3 ± 0.2% | 2059.8 ± 0.7% | 441.5 ± 0.6% | 1401.1 ± 0.2% | 646.9 ± 0.2% | 2.180 | 1.986 | 9.266 | 2.920 | 6.325 |
| string: silesia/xml | 1090118 | 6219.6 ± 0.4% | 2874.3 ± 0.7% | 2653.9 ± 0.5% | 606.4 ± 0.8% | 1758.5 ± 0.3% | 924.0 ± 0.2% | 2.164 | 2.344 | 10.256 | 3.537 | 6.731 |
| string: canterbury/alice29.txt | 159425 | 6824.6 ± 0.9% | 2201.0 ± 0.7% | 2759.1 ± 0.6% | 408.2 ± 0.4% | 1470.1 ± 0.2% | 956.4 ± 0.1% | 3.101 | 2.473 | 16.717 | 4.642 | 7.136 |
| string: canterbury/asyoulik.txt | 132198 | 5873.9 ± 3.0% | 1714.2 ± 0.1% | 2379.2 ± 1.2% | 402.0 ± 0.5% | 1332.9 ± 0.5% | 885.0 ± 0.3% | 3.427 | 2.469 | 14.610 | 4.407 | 6.638 |
| string: canterbury/lcet10.txt | 441884 | 6238.4 ± 0.2% | 2570.7 ± 0.4% | 2499.5 ± 1.1% | 468.5 ± 1.2% | 1554.3 ± 0.3% | 986.5 ± 0.4% | 2.427 | 2.496 | 13.316 | 4.013 | 6.323 |
| string: canterbury/plrabn12.txt | 503330 | 5742.5 ± 0.1% | 2065.3 ± 0.4% | 2067.1 ± 0.7% | 423.5 ± 0.5% | 1394.4 ± 0.4% | 931.9 ± 0.3% | 2.780 | 2.778 | 13.561 | 4.118 | 6.162 |
| string: canterbury-large/E.coli | 1048578 | 19284.1 ± 2.8% | 9745.1 ± 1.7% | 3794.8 ± 0.3% | 1480.7 ± 0.1% | 2371.7 ± 0.6% | 1196.7 ± 0.8% | 1.979 | 5.082 | 13.024 | 8.131 | 16.114 |
| string: canterbury-large/bible.txt | 1055886 | 6775.3 ± 0.7% | 4160.1 ± 1.1% | 3022.4 ± 1.7% | 502.5 ± 0.7% | 1987.1 ± 0.4% | 1121.7 ± 0.5% | 1.629 | 2.242 | 13.484 | 3.410 | 6.040 |
| string: canterbury-large/world192.txt | 1103121 | 4040.0 ± 0.7% | 1650.8 ± 0.6% | 2005.8 ± 0.7% | 451.0 ± 0.4% | 1372.6 ± 0.5% | 909.0 ± 0.2% | 2.447 | 2.014 | 8.957 | 2.943 | 4.445 |
| string: http/html-1m | 1058582 | 6796.9 ± 0.5% | 3976.7 ± 0.4% | 3047.1 ± 0.6% | 500.2 ± 0.7% | 1934.6 ± 0.2% | 805.2 ± 0.4% | 1.709 | 2.231 | 13.589 | 3.513 | 8.441 |
| string: http/json-1m | 1190272 | 3297.6 ± 0.6% | 1354.9 ± 0.1% | 1559.2 ± 0.4% | 443.0 ± 0.4% | 1072.0 ± 0.2% | 766.5 ± 1.6% | 2.434 | 2.115 | 7.443 | 3.076 | 4.302 |
| string: http/js-1m | 1144362 | 2795.8 ± 0.9% | 1176.9 ± 0.4% | 1626.4 ± 0.4% | 369.1 ± 0.3% | 1110.4 ± 0.4% | 757.4 ± 0.3% | 2.376 | 1.719 | 7.575 | 2.518 | 3.691 |
| string: http/css-1m | 1097820 | 4047.5 ± 0.5% | 1488.3 ± 0.1% | 2149.6 ± 0.7% | 493.9 ± 0.4% | 1382.2 ± 0.4% | 895.7 ± 0.3% | 2.720 | 1.883 | 8.195 | 2.928 | 4.519 |
| string: dickens as Cyrillic and CJK | 1883069 | 3074.5 ± 0.7% | 2342.2 ± 0.4% | 521.0 ± 0.4% | 307.4 ± 0.6% | 563.8 ± 0.6% | 336.2 ± 0.5% | 1.313 | 5.901 | 10.003 | 5.453 | 9.145 |
| hex: silesia/dickens | 524290 | 15678.0 ± 0.3% | 1468.8 ± 0.2% | 1085.7 ± 0.4% | 501.0 ± 2.4% | 993.1 ± 0.3% | 735.3 ± 0.2% | 10.674 | 14.440 | 31.294 | 15.787 | 21.322 |
| hex: silesia/mozilla | 524290 | 15614.9 ± 0.2% | 1472.9 ± 0.3% | 1087.2 ± 0.3% | 441.8 ± 0.4% | 993.4 ± 0.2% | 733.9 ± 0.3% | 10.602 | 14.362 | 35.344 | 15.718 | 21.276 |
| hex: silesia/mr | 524290 | 15646.7 ± 0.5% | 1484.6 ± 0.1% | 1091.7 ± 0.1% | 556.3 ± 0.9% | 995.9 ± 0.5% | 735.6 ± 0.3% | 10.539 | 14.333 | 28.126 | 15.712 | 21.271 |
| hex: silesia/nci | 524290 | 15660.6 ± 0.8% | 1474.6 ± 0.3% | 1090.7 ± 0.3% | 616.4 ± 5.1% | 993.0 ± 0.3% | 734.5 ± 0.6% | 10.620 | 14.358 | 25.408 | 15.770 | 21.322 |
| hex: silesia/ooffice | 524290 | 15622.1 ± 0.2% | 1468.9 ± 0.1% | 1085.8 ± 0.3% | 390.1 ± 0.3% | 991.5 ± 0.3% | 734.8 ± 0.3% | 10.635 | 14.387 | 40.046 | 15.755 | 21.260 |
| hex: silesia/osdb | 524290 | 15654.2 ± 0.1% | 1471.2 ± 0.4% | 1086.4 ± 0.4% | 465.2 ± 2.0% | 992.2 ± 0.3% | 734.9 ± 0.4% | 10.640 | 14.409 | 33.652 | 15.778 | 21.302 |
| hex: silesia/reymont | 524290 | 15661.2 ± 0.4% | 1472.0 ± 0.6% | 1086.0 ± 1.1% | 511.9 ± 1.2% | 993.2 ± 0.4% | 734.6 ± 0.1% | 10.639 | 14.421 | 30.595 | 15.768 | 21.319 |
| hex: silesia/samba | 524290 | 15617.0 ± 0.1% | 1469.4 ± 0.4% | 1084.8 ± 0.2% | 402.6 ± 1.0% | 989.9 ± 0.3% | 734.7 ± 0.3% | 10.628 | 14.396 | 38.793 | 15.776 | 21.255 |
| hex: silesia/sao | 524290 | 15684.1 ± 0.3% | 1468.1 ± 0.2% | 1084.6 ± 0.5% | 332.7 ± 0.4% | 990.9 ± 0.2% | 735.4 ± 0.1% | 10.683 | 14.461 | 47.138 | 15.828 | 21.328 |
| hex: silesia/webster | 524290 | 15605.4 ± 0.5% | 1466.7 ± 0.2% | 1084.6 ± 0.4% | 475.6 ± 0.4% | 988.3 ± 0.2% | 735.4 ± 0.3% | 10.640 | 14.388 | 32.814 | 15.790 | 21.222 |
| hex: silesia/x-ray | 524290 | 15640.9 ± 0.7% | 1480.5 ± 0.1% | 1089.5 ± 0.4% | 444.9 ± 1.1% | 999.6 ± 0.3% | 735.2 ± 0.5% | 10.565 | 14.356 | 35.156 | 15.648 | 21.275 |
| hex: silesia/xml | 524290 | 15645.5 ± 0.3% | 1468.9 ± 0.3% | 1088.4 ± 0.3% | 613.5 ± 1.4% | 991.1 ± 0.5% | 733.2 ± 0.6% | 10.651 | 14.374 | 25.503 | 15.786 | 21.338 |
| hex: canterbury/alice29.txt | 304180 | 15705.0 ± 0.0% | 1475.6 ± 0.6% | 1094.4 ± 0.2% | 501.2 ± 1.7% | 996.8 ± 0.3% | 734.5 ± 0.3% | 10.643 | 14.351 | 31.332 | 15.755 | 21.382 |
| hex: canterbury/asyoulik.txt | 250360 | 15716.0 ± 0.1% | 1474.4 ± 0.4% | 1095.9 ± 0.1% | 495.2 ± 3.4% | 996.1 ± 0.3% | 738.0 ± 0.2% | 10.659 | 14.341 | 31.735 | 15.777 | 21.295 |
| hex: canterbury/cp.html | 49208 | 15631.3 ± 0.0% | 1471.6 ± 0.1% | 1100.7 ± 0.2% | 522.0 ± 2.8% | 1004.9 ± 0.5% | 742.7 ± 0.2% | 10.622 | 14.201 | 29.945 | 15.555 | 21.048 |
| hex: canterbury/fields.c | 22302 | 15457.2 ± 0.0% | 1423.5 ± 0.1% | 1078.1 ± 0.2% | 632.8 ± 6.2% | 986.5 ± 0.3% | 737.4 ± 0.1% | 10.858 | 14.337 | 24.425 | 15.669 | 20.961 |
| hex: canterbury/grammar.lsp | 7444 | 14982.2 ± 0.0% | 1507.4 ± 0.2% | 1099.2 ± 0.3% | 658.1 ± 4.9% | 998.8 ± 0.3% | 726.0 ± 0.2% | 9.939 | 13.631 | 22.765 | 15.000 | 20.636 |
| hex: canterbury/kennedy.xls | 524290 | 15627.4 ± 0.2% | 1478.4 ± 0.2% | 1090.8 ± 0.4% | 659.1 ± 1.3% | 991.6 ± 0.5% | 733.5 ± 0.6% | 10.570 | 14.326 | 23.710 | 15.760 | 21.306 |
| hex: canterbury/lcet10.txt | 524290 | 15631.4 ± 0.2% | 1468.3 ± 0.3% | 1088.6 ± 0.2% | 501.7 ± 0.5% | 991.2 ± 0.7% | 733.8 ± 0.5% | 10.646 | 14.359 | 31.155 | 15.771 | 21.302 |
| hex: canterbury/plrabn12.txt | 524290 | 15678.8 ± 0.4% | 1467.1 ± 0.1% | 1083.3 ± 0.5% | 493.0 ± 0.8% | 991.1 ± 0.9% | 734.8 ± 1.1% | 10.687 | 14.474 | 31.804 | 15.820 | 21.338 |
| hex: canterbury/ptt5 | 524290 | 15656.0 ± 0.3% | 1483.5 ± 0.4% | 1092.7 ± 0.3% | 554.3 ± 0.6% | 996.1 ± 0.4% | 736.1 ± 0.4% | 10.553 | 14.328 | 28.246 | 15.718 | 21.270 |
| hex: canterbury/sum | 76482 | 15655.6 ± 0.0% | 1493.3 ± 0.2% | 1105.1 ± 0.2% | 592.8 ± 1.7% | 998.3 ± 0.0% | 743.7 ± 0.2% | 10.484 | 14.166 | 26.409 | 15.682 | 21.051 |
| hex: canterbury/xargs.1 | 8456 | 15040.9 ± 0.0% | 1493.7 ± 0.3% | 1097.8 ± 0.4% | 639.6 ± 1.2% | 1000.4 ± 0.3% | 728.3 ± 0.2% | 10.069 | 13.701 | 23.515 | 15.035 | 20.652 |
| hex: canterbury-large/E.coli | 524290 | 15653.9 ± 0.2% | 1476.4 ± 0.4% | 1093.4 ± 0.3% | 672.9 ± 0.3% | 995.8 ± 0.6% | 734.8 ± 0.4% | 10.603 | 14.317 | 23.265 | 15.720 | 21.304 |
| hex: canterbury-large/bible.txt | 524290 | 15654.0 ± 0.1% | 1466.1 ± 0.3% | 1083.5 ± 0.2% | 514.3 ± 0.7% | 988.1 ± 0.5% | 734.7 ± 0.5% | 10.677 | 14.448 | 30.440 | 15.842 | 21.307 |
| hex: canterbury-large/world192.txt | 524290 | 15614.4 ± 0.2% | 1470.9 ± 0.3% | 1086.6 ± 0.2% | 499.0 ± 1.1% | 994.0 ± 0.2% | 734.7 ± 0.2% | 10.616 | 14.369 | 31.294 | 15.709 | 21.254 |
| hex: http/html-1kx1024 | 2099200 | 13801.1 ± 0.7% | 1456.2 ± 0.2% | 1062.4 ± 0.1% | 500.2 ± 0.4% | 983.2 ± 0.0% | 692.8 ± 0.2% | 9.478 | 12.991 | 27.593 | 14.036 | 19.921 |
| hex: http/html-16kx64 | 2097280 | 15253.9 ± 0.2% | 1445.2 ± 0.2% | 1076.8 ± 0.5% | 505.6 ± 1.0% | 996.1 ± 0.2% | 735.6 ± 0.2% | 10.555 | 14.166 | 30.170 | 15.314 | 20.736 |
| hex: http/html-1m | 524290 | 15651.6 ± 0.2% | 1471.9 ± 0.3% | 1084.1 ± 0.1% | 497.8 ± 0.2% | 991.7 ± 0.2% | 734.5 ± 0.2% | 10.633 | 14.438 | 31.438 | 15.783 | 21.310 |
| hex: http/json-1kx1024 | 2099200 | 13766.1 ± 0.5% | 1464.3 ± 0.2% | 1068.3 ± 0.2% | 602.7 ± 2.0% | 987.0 ± 0.1% | 692.9 ± 0.1% | 9.401 | 12.885 | 22.842 | 13.947 | 19.868 |
| hex: http/json-16kx64 | 2097280 | 15325.6 ± 0.5% | 1448.1 ± 0.3% | 1076.6 ± 0.2% | 616.4 ± 0.5% | 997.0 ± 0.1% | 734.4 ± 0.2% | 10.583 | 14.235 | 24.863 | 15.371 | 20.867 |
| hex: http/json-1m | 524290 | 15726.3 ± 0.2% | 1477.4 ± 0.2% | 1087.9 ± 0.4% | 632.3 ± 0.3% | 993.2 ± 0.2% | 734.4 ± 0.6% | 10.644 | 14.455 | 24.873 | 15.834 | 21.413 |
| hex: http/js-1kx1024 | 2099200 | 13814.0 ± 0.2% | 1458.7 ± 0.4% | 1064.4 ± 0.4% | 498.3 ± 0.2% | 984.9 ± 0.2% | 693.1 ± 0.1% | 9.470 | 12.978 | 27.723 | 14.026 | 19.932 |
| hex: http/js-16kx64 | 2097280 | 15305.8 ± 0.3% | 1448.2 ± 0.1% | 1076.5 ± 0.2% | 503.6 ± 0.4% | 998.1 ± 0.4% | 735.3 ± 0.2% | 10.569 | 14.218 | 30.395 | 15.335 | 20.815 |
| hex: http/js-1m | 524290 | 15601.9 ± 0.1% | 1467.7 ± 0.3% | 1087.9 ± 0.5% | 510.9 ± 0.4% | 991.9 ± 0.1% | 734.4 ± 0.2% | 10.631 | 14.342 | 30.539 | 15.730 | 21.244 |
| hex: http/css-1kx1024 | 2099200 | 13861.3 ± 0.6% | 1456.5 ± 0.2% | 1063.6 ± 0.2% | 529.8 ± 0.4% | 983.9 ± 0.1% | 692.8 ± 0.1% | 9.517 | 13.032 | 26.164 | 14.088 | 20.007 |
| hex: http/css-16kx64 | 2097280 | 15239.0 ± 0.3% | 1445.0 ± 0.2% | 1076.0 ± 0.2% | 539.9 ± 0.8% | 999.4 ± 0.4% | 735.3 ± 0.1% | 10.546 | 14.163 | 28.223 | 15.248 | 20.724 |
| hex: http/css-1m | 524290 | 15633.7 ± 0.1% | 1467.6 ± 0.2% | 1085.1 ± 0.3% | 526.7 ± 0.2% | 992.8 ± 0.4% | 734.6 ± 0.4% | 10.653 | 14.408 | 29.684 | 15.746 | 21.282 |
| hex: shuffled/dickens-1m | 524290 | 15654.1 ± 0.2% | 1470.5 ± 0.4% | 1087.4 ± 0.6% | 500.4 ± 0.7% | 992.5 ± 0.6% | 733.0 ± 0.3% | 10.646 | 14.396 | 31.284 | 15.773 | 21.357 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.4 ± 0.1% | 927.2 ± 0.8% | 1016.8 ± 0.2% | 301.3 ± 0.9% | 665.8 ± 0.1% | 310.4 ± 1.3% | 1.011 | 0.922 | 3.111 | 1.408 | 3.020 |
| qlog records, JSON text sequence | 1467503 | 783.9 ± 25.0% | 815.3 ± 0.3% | 795.7 ± 36.2% | 243.0 ± 3.4% | 699.2 ± 14.1% | 252.3 ± 0.7% | 0.961 | 0.985 | 3.226 | 1.121 | 3.106 |
| string: silesia/dickens | 172528 | 5052.6 ± 0.5% | 1875.9 ± 0.3% | 2648.0 ± 0.5% | 360.8 ± 0.4% | 2866.7 ± 0.6% | 554.8 ± 1.8% | 2.693 | 1.908 | 14.005 | 1.763 | 9.106 |
| string: silesia/nci | 1075110 | 4308.8 ± 0.2% | 2240.5 ± 0.3% | 2997.4 ± 0.2% | 545.3 ± 0.9% | 2985.7 ± 0.6% | 608.4 ± 1.1% | 1.923 | 1.437 | 7.901 | 1.443 | 7.082 |
| string: silesia/reymont | 1075159 | 2994.0 ± 4.5% | 1808.0 ± 0.8% | 2062.7 ± 0.5% | 376.2 ± 0.9% | 2142.8 ± 0.4% | 538.2 ± 1.7% | 1.656 | 1.451 | 7.959 | 1.397 | 5.563 |
| string: silesia/samba | 97582 | 3503.2 ± 0.2% | 2025.8 ± 0.2% | 2616.2 ± 0.3% | 324.8 ± 0.5% | 1507.6 ± 0.7% | 431.2 ± 1.8% | 1.729 | 1.339 | 10.787 | 2.324 | 8.125 |
| string: silesia/webster | 1098490 | 3687.7 ± 1.3% | 1519.3 ± 0.3% | 2020.5 ± 0.6% | 359.1 ± 0.4% | 2174.2 ± 1.0% | 501.4 ± 1.4% | 2.427 | 1.825 | 10.270 | 1.696 | 7.355 |
| string: silesia/xml | 1090118 | 4808.3 ± 0.5% | 2359.4 ± 0.4% | 2527.6 ± 0.4% | 451.8 ± 1.0% | 2814.7 ± 1.7% | 569.5 ± 0.8% | 2.038 | 1.902 | 10.642 | 1.708 | 8.443 |
| string: canterbury/alice29.txt | 159425 | 4372.2 ± 1.1% | 1598.7 ± 0.5% | 2458.9 ± 0.8% | 342.1 ± 0.4% | 2517.3 ± 0.3% | 507.3 ± 1.2% | 2.735 | 1.778 | 12.779 | 1.737 | 8.619 |
| string: canterbury/asyoulik.txt | 132198 | 3505.3 ± 0.6% | 1458.5 ± 0.3% | 2249.6 ± 0.6% | 334.9 ± 0.9% | 2091.6 ± 0.2% | 462.6 ± 1.8% | 2.403 | 1.558 | 10.468 | 1.676 | 7.577 |
| string: canterbury/lcet10.txt | 441884 | 5131.8 ± 0.4% | 1854.3 ± 0.2% | 2336.5 ± 0.4% | 390.8 ± 0.3% | 2864.8 ± 0.5% | 537.5 ± 0.7% | 2.768 | 2.196 | 13.130 | 1.791 | 9.547 |
| string: canterbury/plrabn12.txt | 503330 | 4146.6 ± 0.3% | 1736.0 ± 0.3% | 2062.1 ± 0.7% | 360.9 ± 0.4% | 2508.3 ± 0.8% | 503.9 ± 3.4% | 2.389 | 2.011 | 11.490 | 1.653 | 8.229 |
| string: canterbury-large/E.coli | 1048578 | 11905.8 ± 0.4% | 3609.2 ± 0.4% | 3265.2 ± 0.3% | 931.2 ± 0.8% | 5989.9 ± 0.8% | 774.0 ± 0.4% | 3.299 | 3.646 | 12.785 | 1.988 | 15.382 |
| string: canterbury-large/bible.txt | 1055886 | 6913.9 ± 5.0% | 2942.2 ± 0.4% | 2837.5 ± 2.6% | 416.0 ± 0.8% | 3774.8 ± 2.0% | 623.5 ± 0.9% | 2.350 | 2.437 | 16.620 | 1.832 | 11.088 |
| string: canterbury-large/world192.txt | 1103121 | 3392.2 ± 0.4% | 1482.2 ± 0.3% | 2016.5 ± 0.3% | 352.2 ± 0.1% | 2116.9 ± 0.4% | 504.2 ± 0.7% | 2.289 | 1.682 | 9.630 | 1.602 | 6.727 |
| string: http/html-1m | 1058582 | 6245.5 ± 0.9% | 2739.1 ± 0.3% | 2703.3 ± 0.3% | 440.9 ± 0.3% | 3485.2 ± 0.6% | 595.8 ± 1.6% | 2.280 | 2.310 | 14.165 | 1.792 | 10.483 |
| string: http/json-1m | 1190272 | 2554.5 ± 0.6% | 877.2 ± 0.1% | 2254.7 ± 0.4% | 389.4 ± 0.7% | 1030.8 ± 2.2% | 443.5 ± 0.5% | 2.912 | 1.133 | 6.560 | 2.478 | 5.760 |
| string: http/js-1m | 1144362 | 2279.3 ± 0.5% | 1028.9 ± 1.5% | 1637.6 ± 0.4% | 321.0 ± 0.4% | 1518.2 ± 1.3% | 420.5 ± 0.8% | 2.215 | 1.392 | 7.100 | 1.501 | 5.421 |
| string: http/css-1m | 1097820 | 2660.5 ± 0.6% | 1674.9 ± 0.3% | 2228.2 ± 1.2% | 405.1 ± 0.7% | 1913.1 ± 0.4% | 491.6 ± 0.5% | 1.588 | 1.194 | 6.567 | 1.391 | 5.412 |
| string: dickens as Cyrillic and CJK | 1883069 | 3079.6 ± 0.4% | 1688.1 ± 0.4% | 892.9 ± 0.7% | 351.1 ± 0.1% | 668.2 ± 1.1% | 157.4 ± 3.2% | 1.824 | 3.449 | 8.770 | 4.609 | 19.571 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.8 ± 0.1% | 980.1 ± 0.3% | 1204.8 ± 0.4% | 214.3 ± 0.1% | 472.8 ± 0.6% | 256.1 ± 4.8% | 1.357 | 1.104 | 6.207 | 2.813 | 5.192 |
| hex: silesia/dickens | 524290 | 12008.0 ± 0.1% | 3624.6 ± 0.8% | 3298.9 ± 0.5% | 506.4 ± 1.1% | 6099.6 ± 0.7% | 785.1 ± 2.0% | 3.313 | 3.640 | 23.711 | 1.969 | 15.296 |
| hex: silesia/mozilla | 524290 | 11945.0 ± 0.3% | 3625.4 ± 0.1% | 3296.5 ± 0.2% | 451.9 ± 0.6% | 5987.2 ± 1.3% | 783.7 ± 0.9% | 3.295 | 3.624 | 26.431 | 1.995 | 15.241 |
| hex: silesia/mr | 524290 | 12012.9 ± 0.1% | 3624.4 ± 0.1% | 3300.8 ± 0.4% | 570.8 ± 1.9% | 6158.2 ± 2.1% | 785.0 ± 0.4% | 3.314 | 3.639 | 21.045 | 1.951 | 15.303 |
| hex: silesia/nci | 524290 | 11999.6 ± 0.1% | 3622.5 ± 0.2% | 3294.1 ± 0.3% | 622.4 ± 1.5% | 6120.9 ± 2.2% | 783.7 ± 0.3% | 3.313 | 3.643 | 19.280 | 1.960 | 15.312 |
| hex: silesia/ooffice | 524290 | 11988.9 ± 0.1% | 3624.8 ± 0.1% | 3304.8 ± 0.4% | 396.1 ± 0.4% | 6076.0 ± 1.6% | 784.3 ± 0.4% | 3.307 | 3.628 | 30.264 | 1.973 | 15.286 |
| hex: silesia/osdb | 524290 | 11985.9 ± 0.2% | 3621.9 ± 0.9% | 3295.9 ± 1.4% | 481.5 ± 0.5% | 6065.9 ± 1.0% | 783.2 ± 0.4% | 3.309 | 3.637 | 24.892 | 1.976 | 15.305 |
| hex: silesia/reymont | 524290 | 12003.4 ± 0.1% | 3624.4 ± 0.2% | 3295.1 ± 0.2% | 513.9 ± 1.7% | 6121.6 ± 1.1% | 783.6 ± 0.2% | 3.312 | 3.643 | 23.356 | 1.961 | 15.319 |
| hex: silesia/samba | 524290 | 11972.1 ± 0.3% | 3623.6 ± 0.3% | 3296.9 ± 0.2% | 404.5 ± 1.1% | 6139.3 ± 0.7% | 783.5 ± 0.8% | 3.304 | 3.631 | 29.596 | 1.950 | 15.281 |
| hex: silesia/sao | 524290 | 12013.6 ± 0.1% | 3622.4 ± 0.5% | 3290.7 ± 0.1% | 341.5 ± 0.9% | 6137.2 ± 1.1% | 784.0 ± 0.3% | 3.316 | 3.651 | 35.176 | 1.957 | 15.323 |
| hex: silesia/webster | 524290 | 11969.9 ± 0.1% | 3623.3 ± 0.2% | 3294.8 ± 0.3% | 462.0 ± 1.5% | 6103.1 ± 0.6% | 783.7 ± 0.5% | 3.304 | 3.633 | 25.908 | 1.961 | 15.273 |
| hex: silesia/x-ray | 524290 | 11991.0 ± 0.1% | 3623.6 ± 0.2% | 3295.9 ± 0.3% | 466.8 ± 2.3% | 6082.2 ± 1.1% | 782.4 ± 0.3% | 3.309 | 3.638 | 25.685 | 1.971 | 15.326 |
| hex: silesia/xml | 524290 | 12018.1 ± 0.1% | 3624.7 ± 0.2% | 3293.8 ± 0.3% | 511.0 ± 0.6% | 6104.4 ± 1.1% | 782.3 ± 0.4% | 3.316 | 3.649 | 23.520 | 1.969 | 15.363 |
| hex: canterbury/alice29.txt | 304180 | 12017.3 ± 0.1% | 3635.1 ± 0.1% | 3334.3 ± 0.1% | 499.7 ± 1.5% | 6059.1 ± 1.0% | 783.4 ± 0.6% | 3.306 | 3.604 | 24.051 | 1.983 | 15.339 |
| hex: canterbury/asyoulik.txt | 250360 | 12011.1 ± 0.2% | 3643.2 ± 0.1% | 3374.8 ± 0.0% | 502.8 ± 0.3% | 6106.2 ± 0.7% | 782.1 ± 0.8% | 3.297 | 3.559 | 23.888 | 1.967 | 15.357 |
| hex: canterbury/cp.html | 49208 | 11924.8 ± 0.0% | 3640.7 ± 0.0% | 3286.1 ± 0.3% | 467.7 ± 0.9% | 6286.5 ± 0.7% | 767.1 ± 0.7% | 3.275 | 3.629 | 25.496 | 1.897 | 15.545 |
| hex: canterbury/fields.c | 22302 | 11784.7 ± 0.0% | 3629.5 ± 0.0% | 3353.6 ± 0.0% | 497.5 ± 1.1% | 6261.7 ± 0.2% | 760.9 ± 2.8% | 3.247 | 3.514 | 23.689 | 1.882 | 15.487 |
| hex: canterbury/grammar.lsp | 7444 | 11256.3 ± 1.3% | 3601.2 ± 0.0% | 3343.7 ± 0.4% | 539.8 ± 1.1% | 6178.1 ± 0.5% | 709.1 ± 3.1% | 3.126 | 3.366 | 20.852 | 1.822 | 15.875 |
| hex: canterbury/kennedy.xls | 524290 | 11983.2 ± 0.1% | 3623.7 ± 0.2% | 3295.0 ± 0.2% | 657.4 ± 1.3% | 6081.2 ± 0.7% | 784.2 ± 3.5% | 3.307 | 3.637 | 18.229 | 1.971 | 15.281 |
| hex: canterbury/lcet10.txt | 524290 | 12018.9 ± 0.0% | 3617.8 ± 0.9% | 3293.4 ± 0.3% | 512.5 ± 1.8% | 6080.6 ± 1.0% | 779.1 ± 3.9% | 3.322 | 3.649 | 23.450 | 1.977 | 15.427 |
| hex: canterbury/plrabn12.txt | 524290 | 12001.3 ± 0.1% | 3625.1 ± 0.2% | 3294.0 ± 0.3% | 505.2 ± 3.1% | 6077.2 ± 0.9% | 783.5 ± 0.4% | 3.311 | 3.643 | 23.756 | 1.975 | 15.317 |
| hex: canterbury/ptt5 | 524290 | 11989.1 ± 0.2% | 3623.6 ± 0.5% | 3295.6 ± 0.5% | 562.6 ± 0.8% | 6038.0 ± 1.0% | 784.6 ± 2.9% | 3.309 | 3.638 | 21.311 | 1.986 | 15.281 |
| hex: canterbury/sum | 76482 | 11916.5 ± 0.1% | 3634.3 ± 0.0% | 3360.6 ± 0.4% | 522.0 ± 0.5% | 6176.8 ± 0.6% | 775.8 ± 1.3% | 3.279 | 3.546 | 22.827 | 1.929 | 15.359 |
| hex: canterbury/xargs.1 | 8456 | 11352.1 ± 0.1% | 3602.3 ± 0.0% | 3355.6 ± 0.2% | 501.7 ± 1.0% | 6152.5 ± 0.2% | 753.3 ± 3.0% | 3.151 | 3.383 | 22.625 | 1.845 | 15.070 |
| hex: canterbury-large/E.coli | 524290 | 12018.3 ± 0.1% | 3618.8 ± 0.1% | 3295.0 ± 0.3% | 689.4 ± 0.4% | 6108.9 ± 1.0% | 776.8 ± 8.6% | 3.321 | 3.647 | 17.434 | 1.967 | 15.471 |
| hex: canterbury-large/bible.txt | 524290 | 11990.4 ± 0.1% | 3620.2 ± 0.4% | 3297.9 ± 0.3% | 520.6 ± 2.5% | 6103.4 ± 1.1% | 784.2 ± 0.5% | 3.312 | 3.636 | 23.032 | 1.965 | 15.290 |
| hex: canterbury-large/world192.txt | 524290 | 11993.5 ± 0.1% | 3619.7 ± 0.2% | 3291.8 ± 0.4% | 499.8 ± 1.7% | 6087.9 ± 1.1% | 784.9 ± 0.5% | 3.313 | 3.643 | 23.995 | 1.970 | 15.281 |
| hex: http/html-1kx1024 | 2099200 | 8826.1 ± 2.9% | 3464.1 ± 0.4% | 2880.5 ± 4.6% | 473.7 ± 0.6% | 5165.0 ± 0.4% | 633.7 ± 3.7% | 2.548 | 3.064 | 18.634 | 1.709 | 13.927 |
| hex: http/html-16kx64 | 2097280 | 11771.9 ± 0.1% | 3612.6 ± 0.1% | 3267.3 ± 0.2% | 479.8 ± 0.5% | 6014.8 ± 0.4% | 745.3 ± 2.0% | 3.259 | 3.603 | 24.537 | 1.957 | 15.794 |
| hex: http/html-1m | 524290 | 12001.8 ± 0.1% | 3619.7 ± 0.2% | 3298.3 ± 0.2% | 501.5 ± 1.1% | 6103.1 ± 1.2% | 780.8 ± 2.0% | 3.316 | 3.639 | 23.934 | 1.967 | 15.371 |
| hex: http/json-1kx1024 | 2099200 | 8828.1 ± 3.6% | 3465.0 ± 0.0% | 2881.5 ± 0.5% | 574.2 ± 0.6% | 5131.7 ± 1.0% | 635.8 ± 4.4% | 2.548 | 3.064 | 15.373 | 1.720 | 13.884 |
| hex: http/json-16kx64 | 2097280 | 11764.3 ± 0.2% | 3611.5 ± 0.0% | 3278.6 ± 0.2% | 569.1 ± 0.2% | 6033.7 ± 1.6% | 752.0 ± 1.8% | 3.257 | 3.588 | 20.672 | 1.950 | 15.645 |
| hex: http/json-1m | 524290 | 11943.6 ± 0.1% | 3622.5 ± 0.0% | 3297.2 ± 0.1% | 582.3 ± 1.3% | 5993.0 ± 0.8% | 781.7 ± 1.6% | 3.297 | 3.622 | 20.509 | 1.993 | 15.280 |
| hex: http/js-1kx1024 | 2099200 | 8784.2 ± 2.2% | 3462.3 ± 0.2% | 2875.7 ± 0.3% | 479.9 ± 2.4% | 5131.0 ± 0.2% | 629.8 ± 4.0% | 2.537 | 3.055 | 18.304 | 1.712 | 13.947 |
| hex: http/js-16kx64 | 2097280 | 11755.4 ± 0.2% | 3611.4 ± 0.1% | 3259.3 ± 0.1% | 476.3 ± 1.8% | 6016.1 ± 0.4% | 735.6 ± 2.4% | 3.255 | 3.607 | 24.678 | 1.954 | 15.980 |
| hex: http/js-1m | 524290 | 12009.6 ± 0.1% | 3623.9 ± 0.2% | 3297.6 ± 0.2% | 496.3 ± 0.7% | 6111.9 ± 1.0% | 775.8 ± 3.8% | 3.314 | 3.642 | 24.197 | 1.965 | 15.480 |
| hex: http/css-1kx1024 | 2099200 | 8873.2 ± 3.6% | 3463.2 ± 0.1% | 2886.3 ± 0.4% | 489.5 ± 0.3% | 5122.0 ± 1.3% | 634.7 ± 2.2% | 2.562 | 3.074 | 18.128 | 1.732 | 13.981 |
| hex: http/css-16kx64 | 2097280 | 11764.5 ± 0.2% | 3614.5 ± 0.1% | 3267.5 ± 0.1% | 491.4 ± 0.6% | 6019.1 ± 0.3% | 748.5 ± 1.9% | 3.255 | 3.600 | 23.943 | 1.955 | 15.718 |
| hex: http/css-1m | 524290 | 11998.3 ± 0.2% | 3626.9 ± 0.1% | 3302.7 ± 0.3% | 492.4 ± 1.9% | 6030.4 ± 1.0% | 764.2 ± 3.8% | 3.308 | 3.633 | 24.367 | 1.990 | 15.700 |
| hex: shuffled/dickens-1m | 524290 | 12002.4 ± 0.1% | 3625.9 ± 0.1% | 3301.5 ± 0.2% | 517.5 ± 2.0% | 6156.6 ± 1.1% | 783.0 ± 0.7% | 3.310 | 3.635 | 23.195 | 1.950 | 15.328 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1014.5 ± 0.1% | 927.2 ± 0.8% | 1016.8 ± 0.2% | 301.3 ± 0.9% | 665.8 ± 0.1% | 310.4 ± 1.3% | 1.094 | 0.998 | 3.367 | 1.524 | 3.268 |
| qlog records, JSON text sequence | 1467503 | 839.8 ± 15.0% | 815.3 ± 0.3% | 795.7 ± 36.2% | 243.0 ± 3.4% | 699.2 ± 14.1% | 252.3 ± 0.7% | 1.030 | 1.055 | 3.456 | 1.201 | 3.328 |
| string: silesia/dickens | 172528 | 5055.7 ± 0.3% | 1875.9 ± 0.3% | 2648.0 ± 0.5% | 360.8 ± 0.4% | 2866.7 ± 0.6% | 554.8 ± 1.8% | 2.695 | 1.909 | 14.013 | 1.764 | 9.112 |
| string: silesia/nci | 1075110 | 4316.5 ± 0.3% | 2240.5 ± 0.3% | 2997.4 ± 0.2% | 545.3 ± 0.9% | 2985.7 ± 0.6% | 608.4 ± 1.1% | 1.927 | 1.440 | 7.915 | 1.446 | 7.095 |
| string: silesia/reymont | 1075159 | 2986.5 ± 5.0% | 1808.0 ± 0.8% | 2062.7 ± 0.5% | 376.2 ± 0.9% | 2142.8 ± 0.4% | 538.2 ± 1.7% | 1.652 | 1.448 | 7.939 | 1.394 | 5.549 |
| string: silesia/samba | 97582 | 3511.8 ± 0.3% | 2025.8 ± 0.2% | 2616.2 ± 0.3% | 324.8 ± 0.5% | 1507.6 ± 0.7% | 431.2 ± 1.8% | 1.734 | 1.342 | 10.814 | 2.329 | 8.145 |
| string: silesia/webster | 1098490 | 3685.3 ± 0.8% | 1519.3 ± 0.3% | 2020.5 ± 0.6% | 359.1 ± 0.4% | 2174.2 ± 1.0% | 501.4 ± 1.4% | 2.426 | 1.824 | 10.263 | 1.695 | 7.351 |
| string: silesia/xml | 1090118 | 4809.9 ± 0.6% | 2359.4 ± 0.4% | 2527.6 ± 0.4% | 451.8 ± 1.0% | 2814.7 ± 1.7% | 569.5 ± 0.8% | 2.039 | 1.903 | 10.645 | 1.709 | 8.446 |
| string: canterbury/alice29.txt | 159425 | 4377.3 ± 1.0% | 1598.7 ± 0.5% | 2458.9 ± 0.8% | 342.1 ± 0.4% | 2517.3 ± 0.3% | 507.3 ± 1.2% | 2.738 | 1.780 | 12.794 | 1.739 | 8.629 |
| string: canterbury/asyoulik.txt | 132198 | 3507.0 ± 0.7% | 1458.5 ± 0.3% | 2249.6 ± 0.6% | 334.9 ± 0.9% | 2091.6 ± 0.2% | 462.6 ± 1.8% | 2.405 | 1.559 | 10.473 | 1.677 | 7.580 |
| string: canterbury/lcet10.txt | 441884 | 5139.2 ± 0.3% | 1854.3 ± 0.2% | 2336.5 ± 0.4% | 390.8 ± 0.3% | 2864.8 ± 0.5% | 537.5 ± 0.7% | 2.771 | 2.200 | 13.149 | 1.794 | 9.561 |
| string: canterbury/plrabn12.txt | 503330 | 4142.9 ± 0.6% | 1736.0 ± 0.3% | 2062.1 ± 0.7% | 360.9 ± 0.4% | 2508.3 ± 0.8% | 503.9 ± 3.4% | 2.386 | 2.009 | 11.480 | 1.652 | 8.221 |
| string: canterbury-large/E.coli | 1048578 | 11920.9 ± 0.3% | 3609.2 ± 0.4% | 3265.2 ± 0.3% | 931.2 ± 0.8% | 5989.9 ± 0.8% | 774.0 ± 0.4% | 3.303 | 3.651 | 12.802 | 1.990 | 15.401 |
| string: canterbury-large/bible.txt | 1055886 | 6918.5 ± 5.4% | 2942.2 ± 0.4% | 2837.5 ± 2.6% | 416.0 ± 0.8% | 3774.8 ± 2.0% | 623.5 ± 0.9% | 2.351 | 2.438 | 16.631 | 1.833 | 11.096 |
| string: canterbury-large/world192.txt | 1103121 | 3386.6 ± 0.6% | 1482.2 ± 0.3% | 2016.5 ± 0.3% | 352.2 ± 0.1% | 2116.9 ± 0.4% | 504.2 ± 0.7% | 2.285 | 1.679 | 9.614 | 1.600 | 6.716 |
| string: http/html-1m | 1058582 | 6267.5 ± 1.3% | 2739.1 ± 0.3% | 2703.3 ± 0.3% | 440.9 ± 0.3% | 3485.2 ± 0.6% | 595.8 ± 1.6% | 2.288 | 2.318 | 14.215 | 1.798 | 10.519 |
| string: http/json-1m | 1190272 | 2556.6 ± 0.7% | 877.2 ± 0.1% | 2254.7 ± 0.4% | 389.4 ± 0.7% | 1030.8 ± 2.2% | 443.5 ± 0.5% | 2.915 | 1.134 | 6.566 | 2.480 | 5.764 |
| string: http/js-1m | 1144362 | 2284.3 ± 1.1% | 1028.9 ± 1.5% | 1637.6 ± 0.4% | 321.0 ± 0.4% | 1518.2 ± 1.3% | 420.5 ± 0.8% | 2.220 | 1.395 | 7.116 | 1.505 | 5.432 |
| string: http/css-1m | 1097820 | 2665.3 ± 0.6% | 1674.9 ± 0.3% | 2228.2 ± 1.2% | 405.1 ± 0.7% | 1913.1 ± 0.4% | 491.6 ± 0.5% | 1.591 | 1.196 | 6.579 | 1.393 | 5.422 |
| string: dickens as Cyrillic and CJK | 1883069 | 3080.3 ± 0.4% | 1688.1 ± 0.4% | 892.9 ± 0.7% | 351.1 ± 0.1% | 668.2 ± 1.1% | 157.4 ± 3.2% | 1.825 | 3.450 | 8.772 | 4.610 | 19.575 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.6 ± 0.2% | 980.1 ± 0.3% | 1204.8 ± 0.4% | 214.3 ± 0.1% | 472.8 ± 0.6% | 256.1 ± 4.8% | 1.358 | 1.104 | 6.210 | 2.814 | 5.195 |
| hex: silesia/dickens | 524290 | 12014.2 ± 0.1% | 3624.6 ± 0.8% | 3298.9 ± 0.5% | 506.4 ± 1.1% | 6099.6 ± 0.7% | 785.1 ± 2.0% | 3.315 | 3.642 | 23.724 | 1.970 | 15.304 |
| hex: silesia/mozilla | 524290 | 11991.9 ± 0.2% | 3625.4 ± 0.1% | 3296.5 ± 0.2% | 451.9 ± 0.6% | 5987.2 ± 1.3% | 783.7 ± 0.9% | 3.308 | 3.638 | 26.535 | 2.003 | 15.301 |
| hex: silesia/mr | 524290 | 12012.6 ± 0.1% | 3624.4 ± 0.1% | 3300.8 ± 0.4% | 570.8 ± 1.9% | 6158.2 ± 2.1% | 785.0 ± 0.4% | 3.314 | 3.639 | 21.044 | 1.951 | 15.302 |
| hex: silesia/nci | 524290 | 12007.0 ± 0.2% | 3622.5 ± 0.2% | 3294.1 ± 0.3% | 622.4 ± 1.5% | 6120.9 ± 2.2% | 783.7 ± 0.3% | 3.315 | 3.645 | 19.292 | 1.962 | 15.321 |
| hex: silesia/ooffice | 524290 | 11972.4 ± 0.1% | 3624.8 ± 0.1% | 3304.8 ± 0.4% | 396.1 ± 0.4% | 6076.0 ± 1.6% | 784.3 ± 0.4% | 3.303 | 3.623 | 30.222 | 1.970 | 15.265 |
| hex: silesia/osdb | 524290 | 11987.9 ± 0.7% | 3621.9 ± 0.9% | 3295.9 ± 1.4% | 481.5 ± 0.5% | 6065.9 ± 1.0% | 783.2 ± 0.4% | 3.310 | 3.637 | 24.897 | 1.976 | 15.307 |
| hex: silesia/reymont | 524290 | 12013.0 ± 0.1% | 3624.4 ± 0.2% | 3295.1 ± 0.2% | 513.9 ± 1.7% | 6121.6 ± 1.1% | 783.6 ± 0.2% | 3.314 | 3.646 | 23.374 | 1.962 | 15.331 |
| hex: silesia/samba | 524290 | 12003.1 ± 0.2% | 3623.6 ± 0.3% | 3296.9 ± 0.2% | 404.5 ± 1.1% | 6139.3 ± 0.7% | 783.5 ± 0.8% | 3.312 | 3.641 | 29.673 | 1.955 | 15.320 |
| hex: silesia/sao | 524290 | 12016.7 ± 0.1% | 3622.4 ± 0.5% | 3290.7 ± 0.1% | 341.5 ± 0.9% | 6137.2 ± 1.1% | 784.0 ± 0.3% | 3.317 | 3.652 | 35.185 | 1.958 | 15.327 |
| hex: silesia/webster | 524290 | 11990.4 ± 0.1% | 3623.3 ± 0.2% | 3294.8 ± 0.3% | 462.0 ± 1.5% | 6103.1 ± 0.6% | 783.7 ± 0.5% | 3.309 | 3.639 | 25.952 | 1.965 | 15.299 |
| hex: silesia/x-ray | 524290 | 11996.1 ± 0.2% | 3623.6 ± 0.2% | 3295.9 ± 0.3% | 466.8 ± 2.3% | 6082.2 ± 1.1% | 782.4 ± 0.3% | 3.311 | 3.640 | 25.696 | 1.972 | 15.332 |
| hex: silesia/xml | 524290 | 12014.5 ± 0.1% | 3624.7 ± 0.2% | 3293.8 ± 0.3% | 511.0 ± 0.6% | 6104.4 ± 1.1% | 782.3 ± 0.4% | 3.315 | 3.648 | 23.513 | 1.968 | 15.359 |
| hex: canterbury/alice29.txt | 304180 | 12015.9 ± 0.1% | 3635.1 ± 0.1% | 3334.3 ± 0.1% | 499.7 ± 1.5% | 6059.1 ± 1.0% | 783.4 ± 0.6% | 3.306 | 3.604 | 24.048 | 1.983 | 15.337 |
| hex: canterbury/asyoulik.txt | 250360 | 12009.6 ± 0.0% | 3643.2 ± 0.1% | 3374.8 ± 0.0% | 502.8 ± 0.3% | 6106.2 ± 0.7% | 782.1 ± 0.8% | 3.296 | 3.559 | 23.885 | 1.967 | 15.355 |
| hex: canterbury/cp.html | 49208 | 11925.7 ± 0.0% | 3640.7 ± 0.0% | 3286.1 ± 0.3% | 467.7 ± 0.9% | 6286.5 ± 0.7% | 767.1 ± 0.7% | 3.276 | 3.629 | 25.497 | 1.897 | 15.547 |
| hex: canterbury/fields.c | 22302 | 11788.6 ± 0.0% | 3629.5 ± 0.0% | 3353.6 ± 0.0% | 497.5 ± 1.1% | 6261.7 ± 0.2% | 760.9 ± 2.8% | 3.248 | 3.515 | 23.697 | 1.883 | 15.493 |
| hex: canterbury/grammar.lsp | 7444 | 11280.2 ± 0.7% | 3601.2 ± 0.0% | 3343.7 ± 0.4% | 539.8 ± 1.1% | 6178.1 ± 0.5% | 709.1 ± 3.1% | 3.132 | 3.374 | 20.896 | 1.826 | 15.909 |
| hex: canterbury/kennedy.xls | 524290 | 11936.9 ± 0.2% | 3623.7 ± 0.2% | 3295.0 ± 0.2% | 657.4 ± 1.3% | 6081.2 ± 0.7% | 784.2 ± 3.5% | 3.294 | 3.623 | 18.159 | 1.963 | 15.222 |
| hex: canterbury/lcet10.txt | 524290 | 12016.9 ± 0.1% | 3617.8 ± 0.9% | 3293.4 ± 0.3% | 512.5 ± 1.8% | 6080.6 ± 1.0% | 779.1 ± 3.9% | 3.322 | 3.649 | 23.446 | 1.976 | 15.424 |
| hex: canterbury/plrabn12.txt | 524290 | 12005.1 ± 0.1% | 3625.1 ± 0.2% | 3294.0 ± 0.3% | 505.2 ± 3.1% | 6077.2 ± 0.9% | 783.5 ± 0.4% | 3.312 | 3.645 | 23.763 | 1.975 | 15.322 |
| hex: canterbury/ptt5 | 524290 | 11998.4 ± 0.2% | 3623.6 ± 0.5% | 3295.6 ± 0.5% | 562.6 ± 0.8% | 6038.0 ± 1.0% | 784.6 ± 2.9% | 3.311 | 3.641 | 21.327 | 1.987 | 15.293 |
| hex: canterbury/sum | 76482 | 11911.9 ± 0.1% | 3634.3 ± 0.0% | 3360.6 ± 0.4% | 522.0 ± 0.5% | 6176.8 ± 0.6% | 775.8 ± 1.3% | 3.278 | 3.545 | 22.818 | 1.928 | 15.353 |
| hex: canterbury/xargs.1 | 8456 | 11357.8 ± 0.0% | 3602.3 ± 0.0% | 3355.6 ± 0.2% | 501.7 ± 1.0% | 6152.5 ± 0.2% | 753.3 ± 3.0% | 3.153 | 3.385 | 22.636 | 1.846 | 15.077 |
| hex: canterbury-large/E.coli | 524290 | 12025.2 ± 0.1% | 3618.8 ± 0.1% | 3295.0 ± 0.3% | 689.4 ± 0.4% | 6108.9 ± 1.0% | 776.8 ± 8.6% | 3.323 | 3.650 | 17.444 | 1.968 | 15.480 |
| hex: canterbury-large/bible.txt | 524290 | 11991.3 ± 0.5% | 3620.2 ± 0.4% | 3297.9 ± 0.3% | 520.6 ± 2.5% | 6103.4 ± 1.1% | 784.2 ± 0.5% | 3.312 | 3.636 | 23.033 | 1.965 | 15.291 |
| hex: canterbury-large/world192.txt | 524290 | 11996.7 ± 0.2% | 3619.7 ± 0.2% | 3291.8 ± 0.4% | 499.8 ± 1.7% | 6087.9 ± 1.1% | 784.9 ± 0.5% | 3.314 | 3.644 | 24.002 | 1.971 | 15.285 |
| hex: http/html-1kx1024 | 2099200 | 8866.4 ± 3.2% | 3464.1 ± 0.4% | 2880.5 ± 4.6% | 473.7 ± 0.6% | 5165.0 ± 0.4% | 633.7 ± 3.7% | 2.559 | 3.078 | 18.719 | 1.717 | 13.990 |
| hex: http/html-16kx64 | 2097280 | 11774.1 ± 0.2% | 3612.6 ± 0.1% | 3267.3 ± 0.2% | 479.8 ± 0.5% | 6014.8 ± 0.4% | 745.3 ± 2.0% | 3.259 | 3.604 | 24.541 | 1.958 | 15.797 |
| hex: http/html-1m | 524290 | 12002.9 ± 0.2% | 3619.7 ± 0.2% | 3298.3 ± 0.2% | 501.5 ± 1.1% | 6103.1 ± 1.2% | 780.8 ± 2.0% | 3.316 | 3.639 | 23.936 | 1.967 | 15.373 |
| hex: http/json-1kx1024 | 2099200 | 8938.2 ± 4.1% | 3465.0 ± 0.0% | 2881.5 ± 0.5% | 574.2 ± 0.6% | 5131.7 ± 1.0% | 635.8 ± 4.4% | 2.580 | 3.102 | 15.565 | 1.742 | 14.057 |
| hex: http/json-16kx64 | 2097280 | 11775.5 ± 0.2% | 3611.5 ± 0.0% | 3278.6 ± 0.2% | 569.1 ± 0.2% | 6033.7 ± 1.6% | 752.0 ± 1.8% | 3.261 | 3.592 | 20.692 | 1.952 | 15.660 |
| hex: http/json-1m | 524290 | 11995.3 ± 0.2% | 3622.5 ± 0.0% | 3297.2 ± 0.1% | 582.3 ± 1.3% | 5993.0 ± 0.8% | 781.7 ± 1.6% | 3.311 | 3.638 | 20.598 | 2.002 | 15.346 |
| hex: http/js-1kx1024 | 2099200 | 8826.9 ± 2.7% | 3462.3 ± 0.2% | 2875.7 ± 0.3% | 479.9 ± 2.4% | 5131.0 ± 0.2% | 629.8 ± 4.0% | 2.549 | 3.069 | 18.393 | 1.720 | 14.015 |
| hex: http/js-16kx64 | 2097280 | 11769.0 ± 0.1% | 3611.4 ± 0.1% | 3259.3 ± 0.1% | 476.3 ± 1.8% | 6016.1 ± 0.4% | 735.6 ± 2.4% | 3.259 | 3.611 | 24.707 | 1.956 | 15.998 |
| hex: http/js-1m | 524290 | 12012.1 ± 0.1% | 3623.9 ± 0.2% | 3297.6 ± 0.2% | 496.3 ± 0.7% | 6111.9 ± 1.0% | 775.8 ± 3.8% | 3.315 | 3.643 | 24.202 | 1.965 | 15.483 |
| hex: http/css-1kx1024 | 2099200 | 8920.7 ± 4.3% | 3463.2 ± 0.1% | 2886.3 ± 0.4% | 489.5 ± 0.3% | 5122.0 ± 1.3% | 634.7 ± 2.2% | 2.576 | 3.091 | 18.225 | 1.742 | 14.056 |
| hex: http/css-16kx64 | 2097280 | 11763.1 ± 0.2% | 3614.5 ± 0.1% | 3267.5 ± 0.1% | 491.4 ± 0.6% | 6019.1 ± 0.3% | 748.5 ± 1.9% | 3.254 | 3.600 | 23.940 | 1.954 | 15.716 |
| hex: http/css-1m | 524290 | 12003.7 ± 0.1% | 3626.9 ± 0.1% | 3302.7 ± 0.3% | 492.4 ± 1.9% | 6030.4 ± 1.0% | 764.2 ± 3.8% | 3.310 | 3.634 | 24.378 | 1.991 | 15.707 |
| hex: shuffled/dickens-1m | 524290 | 11999.9 ± 0.2% | 3625.9 ± 0.1% | 3301.5 ± 0.2% | 517.5 ± 2.0% | 6156.6 ± 1.1% | 783.0 ± 0.7% | 3.310 | 3.635 | 23.190 | 1.949 | 15.325 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1361.8 ± 0.2% | 1258.0 ± 0.3% | 1043.4 ± 0.3% | 409.6 ± 0.3% | 449.2 ± 0.4% | 416.9 ± 0.6% | 1.083 | 1.305 | 3.325 | 3.032 | 3.267 |
| qlog records, JSON text sequence | 1467503 | 1052.7 ± 0.1% | 1063.5 ± 0.5% | 790.8 ± 1.1% | 379.9 ± 1.8% | 478.8 ± 8.9% | 279.7 ± 2.4% | 0.990 | 1.331 | 2.771 | 2.199 | 3.764 |
| string: silesia/dickens | 172528 | 6911.1 ± 0.4% | 2813.2 ± 0.6% | 2935.4 ± 0.6% | 430.9 ± 0.5% | 1596.8 ± 0.7% | 1009.9 ± 0.1% | 2.457 | 2.354 | 16.037 | 4.328 | 6.843 |
| string: silesia/nci | 1075110 | 7319.5 ± 0.5% | 3412.8 ± 1.0% | 3100.4 ± 0.6% | 808.1 ± 1.0% | 1864.9 ± 0.6% | 1109.8 ± 0.9% | 2.145 | 2.361 | 9.058 | 3.925 | 6.595 |
| string: silesia/reymont | 1075159 | 3316.9 ± 0.3% | 1969.7 ± 0.8% | 2060.8 ± 0.2% | 450.8 ± 0.3% | 1508.7 ± 0.1% | 949.1 ± 0.7% | 1.684 | 1.610 | 7.357 | 2.199 | 3.495 |
| string: silesia/samba | 97582 | 4208.0 ± 0.5% | 2105.8 ± 0.4% | 3447.1 ± 0.9% | 353.7 ± 0.3% | 1485.5 ± 0.4% | 1055.5 ± 0.3% | 1.998 | 1.221 | 11.896 | 2.833 | 3.987 |
| string: silesia/webster | 1098490 | 4073.6 ± 0.5% | 1876.3 ± 0.2% | 2059.8 ± 0.7% | 441.5 ± 0.6% | 1401.1 ± 0.2% | 646.9 ± 0.2% | 2.171 | 1.978 | 9.226 | 2.907 | 6.297 |
| string: silesia/xml | 1090118 | 6147.8 ± 0.3% | 2874.3 ± 0.7% | 2653.9 ± 0.5% | 606.4 ± 0.8% | 1758.5 ± 0.3% | 924.0 ± 0.2% | 2.139 | 2.317 | 10.137 | 3.496 | 6.654 |
| string: canterbury/alice29.txt | 159425 | 6450.7 ± 0.5% | 2201.0 ± 0.7% | 2759.1 ± 0.6% | 408.2 ± 0.4% | 1470.1 ± 0.2% | 956.4 ± 0.1% | 2.931 | 2.338 | 15.802 | 4.388 | 6.745 |
| string: canterbury/asyoulik.txt | 132198 | 5653.0 ± 0.7% | 1714.2 ± 0.1% | 2379.2 ± 1.2% | 402.0 ± 0.5% | 1332.9 ± 0.5% | 885.0 ± 0.3% | 3.298 | 2.376 | 14.061 | 4.241 | 6.388 |
| string: canterbury/lcet10.txt | 441884 | 6253.5 ± 0.7% | 2570.7 ± 0.4% | 2499.5 ± 1.1% | 468.5 ± 1.2% | 1554.3 ± 0.3% | 986.5 ± 0.4% | 2.433 | 2.502 | 13.349 | 4.023 | 6.339 |
| string: canterbury/plrabn12.txt | 503330 | 5704.0 ± 0.2% | 2065.3 ± 0.4% | 2067.1 ± 0.7% | 423.5 ± 0.5% | 1394.4 ± 0.4% | 931.9 ± 0.3% | 2.762 | 2.759 | 13.470 | 4.091 | 6.121 |
| string: canterbury-large/E.coli | 1048578 | 19283.3 ± 0.7% | 9745.1 ± 1.7% | 3794.8 ± 0.3% | 1480.7 ± 0.1% | 2371.7 ± 0.6% | 1196.7 ± 0.8% | 1.979 | 5.082 | 13.023 | 8.130 | 16.114 |
| string: canterbury-large/bible.txt | 1055886 | 6800.3 ± 0.4% | 4160.1 ± 1.1% | 3022.4 ± 1.7% | 502.5 ± 0.7% | 1987.1 ± 0.4% | 1121.7 ± 0.5% | 1.635 | 2.250 | 13.534 | 3.422 | 6.063 |
| string: canterbury-large/world192.txt | 1103121 | 4065.2 ± 0.5% | 1650.8 ± 0.6% | 2005.8 ± 0.7% | 451.0 ± 0.4% | 1372.6 ± 0.5% | 909.0 ± 0.2% | 2.463 | 2.027 | 9.013 | 2.962 | 4.472 |
| string: http/html-1m | 1058582 | 6786.5 ± 0.4% | 3976.7 ± 0.4% | 3047.1 ± 0.6% | 500.2 ± 0.7% | 1934.6 ± 0.2% | 805.2 ± 0.4% | 1.707 | 2.227 | 13.568 | 3.508 | 8.429 |
| string: http/json-1m | 1190272 | 3164.9 ± 0.2% | 1354.9 ± 0.1% | 1559.2 ± 0.4% | 443.0 ± 0.4% | 1072.0 ± 0.2% | 766.5 ± 1.6% | 2.336 | 2.030 | 7.143 | 2.952 | 4.129 |
| string: http/js-1m | 1144362 | 2777.2 ± 0.6% | 1176.9 ± 0.4% | 1626.4 ± 0.4% | 369.1 ± 0.3% | 1110.4 ± 0.4% | 757.4 ± 0.3% | 2.360 | 1.708 | 7.525 | 2.501 | 3.667 |
| string: http/css-1m | 1097820 | 4018.5 ± 0.6% | 1488.3 ± 0.1% | 2149.6 ± 0.7% | 493.9 ± 0.4% | 1382.2 ± 0.4% | 895.7 ± 0.3% | 2.700 | 1.869 | 8.136 | 2.907 | 4.486 |
| string: dickens as Cyrillic and CJK | 1883069 | 3073.9 ± 0.6% | 2342.2 ± 0.4% | 521.0 ± 0.4% | 307.4 ± 0.6% | 563.8 ± 0.6% | 336.2 ± 0.5% | 1.312 | 5.900 | 10.001 | 5.452 | 9.143 |
| hex: silesia/dickens | 524290 | 15651.4 ± 0.2% | 1468.8 ± 0.2% | 1085.7 ± 0.4% | 501.0 ± 2.4% | 993.1 ± 0.3% | 735.3 ± 0.2% | 10.656 | 14.416 | 31.240 | 15.760 | 21.286 |
| hex: silesia/mozilla | 524290 | 15626.9 ± 1.1% | 1472.9 ± 0.3% | 1087.2 ± 0.3% | 441.8 ± 0.4% | 993.4 ± 0.2% | 733.9 ± 0.3% | 10.610 | 14.373 | 35.372 | 15.730 | 21.292 |
| hex: silesia/mr | 524290 | 15608.8 ± 0.5% | 1484.6 ± 0.1% | 1091.7 ± 0.1% | 556.3 ± 0.9% | 995.9 ± 0.5% | 735.6 ± 0.3% | 10.514 | 14.298 | 28.058 | 15.674 | 21.219 |
| hex: silesia/nci | 524290 | 15642.9 ± 0.7% | 1474.6 ± 0.3% | 1090.7 ± 0.3% | 616.4 ± 5.1% | 993.0 ± 0.3% | 734.5 ± 0.6% | 10.608 | 14.342 | 25.380 | 15.753 | 21.297 |
| hex: silesia/ooffice | 524290 | 15657.7 ± 0.6% | 1468.9 ± 0.1% | 1085.8 ± 0.3% | 390.1 ± 0.3% | 991.5 ± 0.3% | 734.8 ± 0.3% | 10.659 | 14.420 | 40.137 | 15.791 | 21.309 |
| hex: silesia/osdb | 524290 | 15676.1 ± 0.2% | 1471.2 ± 0.4% | 1086.4 ± 0.4% | 465.2 ± 2.0% | 992.2 ± 0.3% | 734.9 ± 0.4% | 10.655 | 14.429 | 33.699 | 15.800 | 21.331 |
| hex: silesia/reymont | 524290 | 15647.3 ± 0.3% | 1472.0 ± 0.6% | 1086.0 ± 1.1% | 511.9 ± 1.2% | 993.2 ± 0.4% | 734.6 ± 0.1% | 10.630 | 14.408 | 30.568 | 15.754 | 21.300 |
| hex: silesia/samba | 524290 | 15605.8 ± 0.1% | 1469.4 ± 0.4% | 1084.8 ± 0.2% | 402.6 ± 1.0% | 989.9 ± 0.3% | 734.7 ± 0.3% | 10.621 | 14.386 | 38.765 | 15.765 | 21.240 |
| hex: silesia/sao | 524290 | 15672.2 ± 0.3% | 1468.1 ± 0.2% | 1084.6 ± 0.5% | 332.7 ± 0.4% | 990.9 ± 0.2% | 735.4 ± 0.1% | 10.675 | 14.450 | 47.102 | 15.816 | 21.312 |
| hex: silesia/webster | 524290 | 15664.2 ± 0.6% | 1466.7 ± 0.2% | 1084.6 ± 0.4% | 475.6 ± 0.4% | 988.3 ± 0.2% | 735.4 ± 0.3% | 10.680 | 14.442 | 32.938 | 15.849 | 21.301 |
| hex: silesia/x-ray | 524290 | 15643.0 ± 0.3% | 1480.5 ± 0.1% | 1089.5 ± 0.4% | 444.9 ± 1.1% | 999.6 ± 0.3% | 735.2 ± 0.5% | 10.566 | 14.358 | 35.161 | 15.650 | 21.278 |
| hex: silesia/xml | 524290 | 15619.3 ± 0.2% | 1468.9 ± 0.3% | 1088.4 ± 0.3% | 613.5 ± 1.4% | 991.1 ± 0.5% | 733.2 ± 0.6% | 10.633 | 14.350 | 25.460 | 15.760 | 21.303 |
| hex: canterbury/alice29.txt | 304180 | 15706.9 ± 0.1% | 1475.6 ± 0.6% | 1094.4 ± 0.2% | 501.2 ± 1.7% | 996.8 ± 0.3% | 734.5 ± 0.3% | 10.644 | 14.353 | 31.336 | 15.757 | 21.384 |
| hex: canterbury/asyoulik.txt | 250360 | 15716.8 ± 0.1% | 1474.4 ± 0.4% | 1095.9 ± 0.1% | 495.2 ± 3.4% | 996.1 ± 0.3% | 738.0 ± 0.2% | 10.660 | 14.342 | 31.736 | 15.778 | 21.297 |
| hex: canterbury/cp.html | 49208 | 15668.1 ± 0.0% | 1471.6 ± 0.1% | 1100.7 ± 0.2% | 522.0 ± 2.8% | 1004.9 ± 0.5% | 742.7 ± 0.2% | 10.647 | 14.235 | 30.016 | 15.591 | 21.097 |
| hex: canterbury/fields.c | 22302 | 15524.3 ± 0.2% | 1423.5 ± 0.1% | 1078.1 ± 0.2% | 632.8 ± 6.2% | 986.5 ± 0.3% | 737.4 ± 0.1% | 10.905 | 14.400 | 24.531 | 15.737 | 21.052 |
| hex: canterbury/grammar.lsp | 7444 | 15160.0 ± 0.1% | 1507.4 ± 0.2% | 1099.2 ± 0.3% | 658.1 ± 4.9% | 998.8 ± 0.3% | 726.0 ± 0.2% | 10.057 | 13.792 | 23.035 | 15.178 | 20.881 |
| hex: canterbury/kennedy.xls | 524290 | 15639.9 ± 0.2% | 1478.4 ± 0.2% | 1090.8 ± 0.4% | 659.1 ± 1.3% | 991.6 ± 0.5% | 733.5 ± 0.6% | 10.579 | 14.338 | 23.729 | 15.773 | 21.323 |
| hex: canterbury/lcet10.txt | 524290 | 15629.3 ± 0.3% | 1468.3 ± 0.3% | 1088.6 ± 0.2% | 501.7 ± 0.5% | 991.2 ± 0.7% | 733.8 ± 0.5% | 10.645 | 14.357 | 31.151 | 15.768 | 21.299 |
| hex: canterbury/plrabn12.txt | 524290 | 15666.9 ± 0.2% | 1467.1 ± 0.1% | 1083.3 ± 0.5% | 493.0 ± 0.8% | 991.1 ± 0.9% | 734.8 ± 1.1% | 10.679 | 14.463 | 31.780 | 15.808 | 21.322 |
| hex: canterbury/ptt5 | 524290 | 15643.2 ± 0.2% | 1483.5 ± 0.4% | 1092.7 ± 0.3% | 554.3 ± 0.6% | 996.1 ± 0.4% | 736.1 ± 0.4% | 10.545 | 14.317 | 28.223 | 15.705 | 21.252 |
| hex: canterbury/sum | 76482 | 15678.0 ± 0.2% | 1493.3 ± 0.2% | 1105.1 ± 0.2% | 592.8 ± 1.7% | 998.3 ± 0.0% | 743.7 ± 0.2% | 10.499 | 14.187 | 26.447 | 15.704 | 21.081 |
| hex: canterbury/xargs.1 | 8456 | 15210.8 ± 0.0% | 1493.7 ± 0.3% | 1097.8 ± 0.4% | 639.6 ± 1.2% | 1000.4 ± 0.3% | 728.3 ± 0.2% | 10.183 | 13.856 | 23.781 | 15.205 | 20.886 |
| hex: canterbury-large/E.coli | 524290 | 15640.8 ± 0.3% | 1476.4 ± 0.4% | 1093.4 ± 0.3% | 672.9 ± 0.3% | 995.8 ± 0.6% | 734.8 ± 0.4% | 10.594 | 14.305 | 23.245 | 15.706 | 21.286 |
| hex: canterbury-large/bible.txt | 524290 | 15625.8 ± 0.0% | 1466.1 ± 0.3% | 1083.5 ± 0.2% | 514.3 ± 0.7% | 988.1 ± 0.5% | 734.7 ± 0.5% | 10.658 | 14.422 | 30.385 | 15.814 | 21.269 |
| hex: canterbury-large/world192.txt | 524290 | 15627.2 ± 0.4% | 1470.9 ± 0.3% | 1086.6 ± 0.2% | 499.0 ± 1.1% | 994.0 ± 0.2% | 734.7 ± 0.2% | 10.625 | 14.381 | 31.320 | 15.722 | 21.271 |
| hex: http/html-1kx1024 | 2099200 | 14195.6 ± 0.2% | 1456.2 ± 0.2% | 1062.4 ± 0.1% | 500.2 ± 0.4% | 983.2 ± 0.0% | 692.8 ± 0.2% | 9.749 | 13.362 | 28.382 | 14.438 | 20.490 |
| hex: http/html-16kx64 | 2097280 | 15335.4 ± 0.5% | 1445.2 ± 0.2% | 1076.8 ± 0.5% | 505.6 ± 1.0% | 996.1 ± 0.2% | 735.6 ± 0.2% | 10.611 | 14.242 | 30.331 | 15.396 | 20.847 |
| hex: http/html-1m | 524290 | 15634.5 ± 0.1% | 1471.9 ± 0.3% | 1084.1 ± 0.1% | 497.8 ± 0.2% | 991.7 ± 0.2% | 734.5 ± 0.2% | 10.622 | 14.422 | 31.404 | 15.766 | 21.287 |
| hex: http/json-1kx1024 | 2099200 | 14197.7 ± 0.4% | 1464.3 ± 0.2% | 1068.3 ± 0.2% | 602.7 ± 2.0% | 987.0 ± 0.1% | 692.9 ± 0.1% | 9.696 | 13.289 | 23.558 | 14.384 | 20.491 |
| hex: http/json-16kx64 | 2097280 | 15337.9 ± 0.4% | 1448.1 ± 0.3% | 1076.6 ± 0.2% | 616.4 ± 0.5% | 997.0 ± 0.1% | 734.4 ± 0.2% | 10.592 | 14.246 | 24.883 | 15.383 | 20.884 |
| hex: http/json-1m | 524290 | 15714.9 ± 0.1% | 1477.4 ± 0.2% | 1087.9 ± 0.4% | 632.3 ± 0.3% | 993.2 ± 0.2% | 734.4 ± 0.6% | 10.637 | 14.445 | 24.855 | 15.823 | 21.397 |
| hex: http/js-1kx1024 | 2099200 | 14175.8 ± 0.5% | 1458.7 ± 0.4% | 1064.4 ± 0.4% | 498.3 ± 0.2% | 984.9 ± 0.2% | 693.1 ± 0.1% | 9.718 | 13.318 | 28.449 | 14.394 | 20.454 |
| hex: http/js-16kx64 | 2097280 | 15359.7 ± 0.2% | 1448.2 ± 0.1% | 1076.5 ± 0.2% | 503.6 ± 0.4% | 998.1 ± 0.4% | 735.3 ± 0.2% | 10.606 | 14.268 | 30.502 | 15.389 | 20.888 |
| hex: http/js-1m | 524290 | 15639.7 ± 0.1% | 1467.7 ± 0.3% | 1087.9 ± 0.5% | 510.9 ± 0.4% | 991.9 ± 0.1% | 734.4 ± 0.2% | 10.656 | 14.377 | 30.613 | 15.768 | 21.295 |
| hex: http/css-1kx1024 | 2099200 | 14199.1 ± 0.1% | 1456.5 ± 0.2% | 1063.6 ± 0.2% | 529.8 ± 0.4% | 983.9 ± 0.1% | 692.8 ± 0.1% | 9.749 | 13.350 | 26.802 | 14.431 | 20.495 |
| hex: http/css-16kx64 | 2097280 | 15355.6 ± 0.3% | 1445.0 ± 0.2% | 1076.0 ± 0.2% | 539.9 ± 0.8% | 999.4 ± 0.4% | 735.3 ± 0.1% | 10.627 | 14.272 | 28.439 | 15.365 | 20.882 |
| hex: http/css-1m | 524290 | 15685.5 ± 0.3% | 1467.6 ± 0.2% | 1085.1 ± 0.3% | 526.7 ± 0.2% | 992.8 ± 0.4% | 734.6 ± 0.4% | 10.688 | 14.456 | 29.783 | 15.799 | 21.353 |
| hex: shuffled/dickens-1m | 524290 | 15688.2 ± 0.3% | 1470.5 ± 0.4% | 1087.4 ± 0.6% | 500.4 ± 0.7% | 992.5 ± 0.6% | 733.0 ± 0.3% | 10.669 | 14.427 | 31.352 | 15.807 | 21.404 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.922 of yyjson.
