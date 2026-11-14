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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43464704827 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1128.0 ± 0.7% | 0.523 | 0.965 | 0.996 | 0.998 | 0.460 | 1.003 | 1.007 | 0.387 | 0.830 | 0.899 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 850.6 ± 1.6% | 0.821 | 1.005 | 1.004 | 1.001 | 0.448 | 0.993 | 1.029 | 0.400 | 0.925 | 0.989 | 0.125 |
| string: silesia/dickens | 172528 | 5039.1 ± 0.5% | 0.033 | 0.772 | 1.003 | 1.004 | 0.196 | 1.014 | 1.006 | 0.196 | 1.002 | 1.002 | 0.033 |
| string: silesia/nci | 1075110 | 4304.8 ± 0.5% | 0.039 | 0.802 | 1.003 | 1.003 | 0.280 | 1.007 | 0.998 | 0.278 | 1.004 | 1.003 | 0.038 |
| string: silesia/reymont | 1075159 | 2916.5 ± 1.7% | 0.058 | 0.818 | 1.001 | 1.002 | 0.361 | 1.017 | 1.016 | 0.361 | 1.026 | 1.024 | 0.057 |
| string: silesia/samba | 97582 | 3496.5 ± 0.7% | 0.040 | 0.861 | 1.003 | 1.005 | 0.068 | 0.779 | 1.011 | 0.072 | 1.002 | 1.005 | 0.039 |
| string: silesia/webster | 1098490 | 3650.0 ± 0.6% | 0.044 | 0.847 | 1.004 | 1.006 | 0.203 | 1.018 | 1.015 | 0.203 | 1.009 | 1.008 | 0.044 |
| string: silesia/xml | 1090118 | 4764.0 ± 0.4% | 0.035 | 0.811 | 1.008 | 1.012 | 0.223 | 0.986 | 1.012 | 0.225 | 1.009 | 1.013 | 0.035 |
| string: canterbury/alice29.txt | 159425 | 4305.8 ± 0.9% | 0.038 | 0.752 | 1.004 | 1.009 | 0.172 | 1.036 | 1.021 | 0.171 | 1.009 | 1.011 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3454.7 ± 1.0% | 0.046 | 0.746 | 1.004 | 1.009 | 0.177 | 1.007 | 0.973 | 0.176 | 1.014 | 1.014 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5093.1 ± 0.2% | 0.033 | 0.815 | 1.004 | 1.006 | 0.196 | 1.026 | 1.010 | 0.196 | 1.004 | 1.005 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4096.4 ± 0.3% | 0.040 | 0.829 | 1.002 | 1.002 | 0.200 | 1.019 | 1.005 | 0.199 | 1.005 | 1.005 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19244.7 ± 1.1% | 0.077 | 1.008 | 1.008 | 1.006 | 0.482 | 1.010 | 1.008 | 0.482 | 0.619 | 0.621 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6655.2 ± 1.1% | 0.026 | 0.805 | 1.006 | 1.009 | 0.434 | 1.035 | 1.046 | 0.434 | 1.038 | 1.038 | 0.026 |
| string: canterbury-large/world192.txt | 1103121 | 3385.0 ± 0.8% | 0.048 | 0.845 | 1.003 | 1.006 | 0.197 | 1.012 | 1.007 | 0.197 | 1.004 | 1.004 | 0.047 |
| string: http/html-1m | 1058582 | 6060.8 ± 0.7% | 0.028 | 0.782 | 1.005 | 1.038 | 0.390 | 1.043 | 1.051 | 0.390 | 1.027 | 1.030 | 0.028 |
| string: http/json-1m | 1190272 | 2553.3 ± 0.3% | 0.055 | 0.950 | 1.003 | 1.004 | 0.111 | 1.003 | 0.470 | 0.111 | 1.001 | 1.002 | 0.055 |
| string: http/js-1m | 1144362 | 2287.6 ± 0.4% | 0.066 | 0.888 | 0.998 | 1.000 | 0.174 | 1.056 | 1.043 | 0.174 | 1.001 | 1.001 | 0.065 |
| string: http/css-1m | 1097820 | 2640.3 ± 0.7% | 0.060 | 0.774 | 1.002 | 1.010 | 0.240 | 1.008 | 1.014 | 0.239 | 1.008 | 1.010 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3061.3 ± 0.4% | 0.044 | 0.125 | 1.009 | 1.009 | 0.337 | 1.002 | 1.012 | 0.337 | 1.006 | 1.005 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.1 ± 1.6% | 0.081 | 1.003 | 1.002 | 1.002 | 0.076 | 0.638 | 1.005 | 0.081 | 1.003 | 1.002 | 0.081 |
| hex: silesia/dickens | 524290 | 19139.3 ± 0.5% | 0.078 | 1.004 | 0.991 | 0.993 | 0.508 | 0.998 | 0.996 | 0.506 | 0.627 | 0.627 | 0.009 |
| hex: silesia/mozilla | 524290 | 18952.8 ± 0.9% | 0.079 | 1.007 | 1.000 | 0.997 | 0.512 | 0.996 | 1.000 | 0.509 | 0.634 | 0.634 | 0.009 |
| hex: silesia/mr | 524290 | 18689.9 ± 0.5% | 0.080 | 1.006 | 1.003 | 1.001 | 0.518 | 1.002 | 1.001 | 0.518 | 0.642 | 0.642 | 0.009 |
| hex: silesia/nci | 524290 | 19058.6 ± 1.6% | 0.078 | 0.996 | 0.993 | 0.989 | 0.506 | 0.991 | 0.990 | 0.504 | 0.630 | 0.631 | 0.009 |
| hex: silesia/ooffice | 524290 | 19018.2 ± 0.5% | 0.078 | 1.006 | 1.000 | 0.997 | 0.505 | 0.999 | 0.997 | 0.506 | 0.630 | 0.628 | 0.009 |
| hex: silesia/osdb | 524290 | 18872.9 ± 0.4% | 0.079 | 1.001 | 1.000 | 0.999 | 0.514 | 1.002 | 1.000 | 0.514 | 0.636 | 0.636 | 0.009 |
| hex: silesia/reymont | 524290 | 19033.3 ± 1.2% | 0.078 | 0.999 | 0.998 | 0.995 | 0.501 | 1.000 | 0.998 | 0.501 | 0.629 | 0.629 | 0.009 |
| hex: silesia/samba | 524290 | 18741.6 ± 0.2% | 0.080 | 1.004 | 1.000 | 1.000 | 0.523 | 1.003 | 0.999 | 0.525 | 0.641 | 0.641 | 0.009 |
| hex: silesia/sao | 524290 | 19059.5 ± 0.6% | 0.078 | 1.006 | 0.999 | 0.996 | 0.505 | 0.998 | 0.999 | 0.505 | 0.629 | 0.629 | 0.009 |
| hex: silesia/webster | 524290 | 19155.1 ± 0.4% | 0.078 | 1.005 | 0.997 | 0.997 | 0.506 | 0.997 | 0.992 | 0.503 | 0.627 | 0.627 | 0.009 |
| hex: silesia/x-ray | 524290 | 18784.2 ± 0.4% | 0.079 | 1.007 | 1.000 | 1.001 | 0.507 | 0.998 | 1.001 | 0.506 | 0.638 | 0.639 | 0.009 |
| hex: silesia/xml | 524290 | 19069.9 ± 1.2% | 0.078 | 1.002 | 1.001 | 1.000 | 0.511 | 0.999 | 0.994 | 0.510 | 0.630 | 0.631 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19247.6 ± 0.7% | 0.078 | 0.996 | 1.001 | 1.000 | 0.514 | 1.000 | 1.000 | 0.514 | 0.624 | 0.624 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19272.5 ± 0.1% | 0.078 | 1.015 | 1.015 | 1.015 | 0.521 | 1.012 | 1.016 | 0.520 | 0.623 | 0.623 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19303.0 ± 0.7% | 0.082 | 1.001 | 1.001 | 1.000 | 0.541 | 1.000 | 1.000 | 0.542 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18818.7 ± 0.6% | 0.084 | 1.007 | 1.008 | 1.008 | 0.537 | 1.007 | 1.008 | 0.542 | 0.626 | 0.626 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17462.7 ± 2.4% | 0.090 | 1.007 | 1.007 | 1.008 | 0.531 | 1.006 | 1.007 | 0.548 | 0.644 | 0.648 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 19075.2 ± 1.2% | 0.078 | 1.005 | 0.993 | 0.992 | 0.509 | 0.996 | 0.987 | 0.509 | 0.629 | 0.628 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 19037.8 ± 1.3% | 0.078 | 1.007 | 0.999 | 0.997 | 0.516 | 1.000 | 0.994 | 0.517 | 0.631 | 0.631 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18745.8 ± 0.4% | 0.079 | 1.007 | 1.002 | 1.000 | 0.505 | 1.003 | 1.000 | 0.507 | 0.640 | 0.640 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 18989.5 ± 0.3% | 0.079 | 1.001 | 1.000 | 0.999 | 0.518 | 1.003 | 1.000 | 0.519 | 0.632 | 0.633 | 0.009 |
| hex: canterbury/sum | 76482 | 19294.1 ± 0.1% | 0.078 | 1.002 | 1.002 | 1.002 | 0.518 | 1.002 | 1.002 | 0.520 | 0.617 | 0.617 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17800.7 ± 0.2% | 0.087 | 1.001 | 1.002 | 1.002 | 0.524 | 1.001 | 1.001 | 0.540 | 0.637 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 19055.1 ± 1.0% | 0.078 | 1.004 | 1.004 | 0.996 | 0.511 | 0.998 | 0.996 | 0.508 | 0.629 | 0.628 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18988.1 ± 1.4% | 0.078 | 1.013 | 1.003 | 0.998 | 0.509 | 0.997 | 0.998 | 0.508 | 0.632 | 0.632 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18732.0 ± 0.7% | 0.079 | 1.005 | 1.006 | 1.004 | 0.514 | 1.006 | 1.007 | 0.514 | 0.641 | 0.641 | 0.009 |
| hex: http/html-1kx1024 | 2099200 | 9876.5 ± 11.4% | 0.144 | 1.240 | 1.243 | 1.239 | 0.675 | 1.237 | 0.989 | 0.740 | 0.905 | 0.914 | 0.017 |
| hex: http/html-16kx64 | 2097280 | 18576.1 ± 0.3% | 0.081 | 1.008 | 1.008 | 1.010 | 0.551 | 1.009 | 0.998 | 0.557 | 0.634 | 0.634 | 0.009 |
| hex: http/html-1m | 524290 | 18852.5 ± 1.4% | 0.079 | 1.003 | 1.003 | 1.003 | 0.511 | 1.004 | 1.000 | 0.513 | 0.637 | 0.637 | 0.009 |
| hex: http/json-1kx1024 | 2099200 | 9766.5 ± 11.8% | 0.146 | 1.255 | 1.249 | 1.250 | 0.680 | 1.254 | 0.997 | 0.749 | 0.914 | 0.917 | 0.018 |
| hex: http/json-16kx64 | 2097280 | 18561.7 ± 0.7% | 0.081 | 1.009 | 1.009 | 1.009 | 0.551 | 1.009 | 1.000 | 0.558 | 0.634 | 0.635 | 0.009 |
| hex: http/json-1m | 524290 | 18923.2 ± 0.9% | 0.079 | 1.013 | 1.001 | 1.002 | 0.510 | 1.002 | 0.998 | 0.512 | 0.634 | 0.634 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 10077.9 ± 17.1% | 0.140 | 1.211 | 1.210 | 1.203 | 0.662 | 1.211 | 1.003 | 0.732 | 0.878 | 0.895 | 0.017 |
| hex: http/js-16kx64 | 2097280 | 18552.1 ± 1.3% | 0.081 | 1.010 | 1.006 | 1.007 | 0.551 | 1.010 | 1.000 | 0.558 | 0.635 | 0.635 | 0.009 |
| hex: http/js-1m | 524290 | 19178.6 ± 2.0% | 0.078 | 0.999 | 0.997 | 0.995 | 0.506 | 0.995 | 0.990 | 0.507 | 0.625 | 0.623 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9962.6 ± 16.3% | 0.143 | 1.243 | 1.233 | 1.235 | 0.670 | 1.233 | 0.973 | 0.743 | 0.898 | 0.908 | 0.017 |
| hex: http/css-16kx64 | 2097280 | 18568.0 ± 0.8% | 0.081 | 1.011 | 1.008 | 1.008 | 0.550 | 1.008 | 0.999 | 0.557 | 0.634 | 0.634 | 0.009 |
| hex: http/css-1m | 524290 | 18876.7 ± 1.5% | 0.079 | 1.014 | 1.005 | 1.003 | 0.514 | 1.007 | 1.001 | 0.513 | 0.634 | 0.634 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18912.9 ± 0.4% | 0.079 | 0.994 | 1.000 | 0.999 | 0.508 | 0.998 | 0.996 | 0.508 | 0.634 | 0.633 | 0.009 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1489.7 ± 0.5% | 0.443 | 1.003 | 0.968 | 1.009 | 1.012 | 0.266 | 1.003 | 0.547 | 0.916 | 0.089 | 1.028 |
| qlog records, JSON text sequence | 1467503 | 1269.8 ± 1.5% | 0.692 | 0.980 | 1.012 | 1.015 | 1.015 | 0.262 | 1.004 | 0.502 | 0.830 | 0.106 | 1.019 |
| string: silesia/dickens | 172528 | 6888.2 ± 0.4% | 0.025 | 1.002 | 1.002 | 1.001 | 1.001 | 0.167 | 0.717 | 1.003 | 1.002 | 0.025 | 1.036 |
| string: silesia/nci | 1075110 | 7326.6 ± 0.5% | 0.023 | 1.000 | 1.002 | 1.002 | 1.001 | 0.211 | 0.564 | 1.000 | 1.001 | 0.024 | 1.008 |
| string: silesia/reymont | 1075159 | 3336.1 ± 1.2% | 0.051 | 1.000 | 0.996 | 1.001 | 1.007 | 0.390 | 0.874 | 1.002 | 1.000 | 0.052 | 1.049 |
| string: silesia/samba | 97582 | 4192.2 ± 1.0% | 0.053 | 1.000 | 0.999 | 1.007 | 1.006 | 0.125 | 0.943 | 1.002 | 1.003 | 0.054 | 1.092 |
| string: silesia/webster | 1098490 | 4054.1 ± 0.5% | 0.042 | 1.009 | 1.008 | 1.009 | 1.010 | 0.212 | 0.886 | 0.999 | 1.007 | 0.043 | 1.011 |
| string: silesia/xml | 1090118 | 6106.5 ± 0.8% | 0.029 | 1.004 | 1.002 | 1.007 | 1.006 | 0.254 | 0.778 | 1.006 | 1.008 | 0.029 | 1.021 |
| string: canterbury/alice29.txt | 159425 | 6390.7 ± 0.9% | 0.027 | 1.009 | 1.009 | 1.010 | 1.012 | 0.133 | 0.657 | 1.009 | 1.011 | 0.027 | 1.066 |
| string: canterbury/asyoulik.txt | 132198 | 5593.0 ± 1.9% | 0.030 | 1.027 | 1.031 | 1.032 | 1.034 | 0.129 | 0.597 | 0.999 | 1.009 | 0.030 | 1.051 |
| string: canterbury/lcet10.txt | 441884 | 6249.0 ± 0.6% | 0.028 | 1.006 | 1.008 | 1.008 | 1.007 | 0.185 | 0.801 | 1.002 | 1.003 | 0.028 | 1.000 |
| string: canterbury/plrabn12.txt | 503330 | 5721.0 ± 0.4% | 0.030 | 1.001 | 1.002 | 1.001 | 1.001 | 0.168 | 0.698 | 1.002 | 1.002 | 0.030 | 1.008 |
| string: canterbury-large/E.coli | 1048578 | 19315.8 ± 0.7% | 0.078 | 1.003 | 1.004 | 1.003 | 1.000 | 0.482 | 1.003 | 1.003 | 1.005 | 0.009 | 1.005 |
| string: canterbury-large/bible.txt | 1055886 | 6799.0 ± 0.5% | 0.025 | 0.999 | 1.000 | 1.000 | 1.001 | 0.496 | 0.969 | 1.000 | 1.001 | 0.027 | 1.002 |
| string: canterbury-large/world192.txt | 1103121 | 4027.8 ± 0.6% | 0.042 | 1.017 | 1.016 | 1.016 | 1.014 | 0.193 | 0.830 | 1.000 | 1.009 | 0.043 | 1.002 |
| string: http/html-1m | 1058582 | 6756.3 ± 0.4% | 0.026 | 1.004 | 0.924 | 1.003 | 1.005 | 0.405 | 0.890 | 1.000 | 1.005 | 0.026 | 1.010 |
| string: http/json-1m | 1190272 | 3167.1 ± 0.4% | 0.051 | 0.998 | 0.965 | 1.003 | 1.003 | 0.133 | 0.370 | 0.999 | 1.002 | 0.051 | 1.040 |
| string: http/js-1m | 1144362 | 2761.3 ± 0.8% | 0.061 | 1.001 | 1.009 | 1.000 | 1.011 | 0.165 | 0.838 | 1.002 | 1.008 | 0.061 | 1.020 |
| string: http/css-1m | 1097820 | 3980.0 ± 0.3% | 0.042 | 1.004 | 1.007 | 1.011 | 1.010 | 0.208 | 0.645 | 0.999 | 1.007 | 0.043 | 1.010 |
| string: dickens as Cyrillic and CJK | 1883069 | 3073.6 ± 0.2% | 0.048 | 1.001 | 0.124 | 1.000 | 1.003 | 0.320 | 1.002 | 0.999 | 1.001 | 0.048 | 1.002 |
| hex: silesia/dickens | 524290 | 15666.1 ± 0.3% | 1.002 | 0.178 | 1.001 | 1.002 | 1.002 | 1.001 | 1.002 | 1.001 | 1.001 | 0.178 | 1.003 |
| hex: silesia/mozilla | 524290 | 15688.7 ± 0.2% | 1.000 | 0.178 | 1.000 | 1.001 | 1.000 | 0.996 | 1.000 | 1.001 | 1.000 | 0.177 | 1.000 |
| hex: silesia/mr | 524290 | 15624.4 ± 0.3% | 1.002 | 0.179 | 1.001 | 1.002 | 1.001 | 0.999 | 0.999 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: silesia/nci | 524290 | 15679.9 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.001 | 1.000 | 0.998 | 0.999 | 1.000 | 0.999 | 0.178 | 0.999 |
| hex: silesia/ooffice | 524290 | 15662.0 ± 0.1% | 1.000 | 0.178 | 0.999 | 1.000 | 1.000 | 0.999 | 0.999 | 1.000 | 0.999 | 0.178 | 1.000 |
| hex: silesia/osdb | 524290 | 15608.5 ± 0.2% | 1.000 | 0.179 | 0.999 | 1.000 | 0.999 | 0.999 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: silesia/reymont | 524290 | 15667.6 ± 0.2% | 1.002 | 0.178 | 1.002 | 1.001 | 1.002 | 1.001 | 1.000 | 1.001 | 1.001 | 0.177 | 1.000 |
| hex: silesia/samba | 524290 | 15648.9 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.000 | 1.002 | 1.002 | 1.000 | 1.001 | 1.000 | 0.178 | 1.002 |
| hex: silesia/sao | 524290 | 15637.7 ± 0.4% | 1.001 | 0.178 | 1.001 | 1.002 | 1.001 | 1.001 | 1.003 | 1.002 | 1.003 | 0.178 | 1.002 |
| hex: silesia/webster | 524290 | 15596.0 ± 0.4% | 0.999 | 0.178 | 1.002 | 1.000 | 1.000 | 1.001 | 1.000 | 1.000 | 1.001 | 0.178 | 1.002 |
| hex: silesia/x-ray | 524290 | 15624.8 ± 0.3% | 1.001 | 0.179 | 1.002 | 1.001 | 1.001 | 0.999 | 1.002 | 1.000 | 1.001 | 0.179 | 1.001 |
| hex: silesia/xml | 524290 | 15598.8 ± 0.4% | 0.999 | 0.178 | 1.001 | 0.999 | 1.000 | 1.000 | 1.002 | 1.000 | 1.000 | 0.179 | 1.001 |
| hex: canterbury/alice29.txt | 304180 | 15663.7 ± 0.2% | 1.001 | 0.179 | 1.001 | 1.001 | 1.001 | 1.000 | 1.002 | 1.002 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15693.2 ± 0.2% | 1.002 | 0.178 | 1.001 | 1.002 | 1.002 | 1.001 | 1.002 | 1.002 | 1.002 | 0.177 | 1.002 |
| hex: canterbury/cp.html | 49208 | 15622.5 ± 0.5% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.997 | 1.001 | 1.001 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15442.7 ± 0.0% | 1.001 | 0.181 | 1.001 | 1.000 | 1.000 | 0.994 | 1.000 | 1.002 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14946.7 ± 0.1% | 1.003 | 0.186 | 1.000 | 1.001 | 1.001 | 0.982 | 1.001 | 1.004 | 1.014 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15657.9 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.001 | 0.999 | 0.999 | 1.000 | 1.001 | 1.000 | 0.178 | 1.001 |
| hex: canterbury/lcet10.txt | 524290 | 15640.9 ± 0.2% | 1.000 | 0.178 | 0.999 | 1.001 | 1.000 | 1.001 | 1.002 | 1.003 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/plrabn12.txt | 524290 | 15635.8 ± 0.3% | 1.001 | 0.178 | 0.998 | 0.999 | 0.999 | 0.997 | 0.999 | 0.998 | 0.998 | 0.177 | 0.999 |
| hex: canterbury/ptt5 | 524290 | 15648.2 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.002 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 0.178 | 1.000 |
| hex: canterbury/sum | 76482 | 15644.0 ± 0.0% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.999 | 1.001 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 15012.1 ± 0.0% | 1.001 | 0.185 | 1.001 | 1.001 | 1.000 | 0.984 | 1.001 | 1.003 | 1.013 | 0.183 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 15626.3 ± 0.3% | 1.003 | 0.178 | 1.002 | 1.000 | 1.001 | 1.002 | 1.003 | 1.003 | 1.002 | 0.178 | 1.002 |
| hex: canterbury-large/bible.txt | 524290 | 15661.2 ± 0.3% | 1.001 | 0.178 | 1.001 | 1.001 | 1.000 | 1.000 | 0.999 | 1.001 | 0.998 | 0.178 | 1.000 |
| hex: canterbury-large/world192.txt | 524290 | 15616.4 ± 0.2% | 1.003 | 0.178 | 0.999 | 1.000 | 0.999 | 1.001 | 1.000 | 1.002 | 1.001 | 0.178 | 1.000 |
| hex: http/html-1kx1024 | 2099200 | 13718.9 ± 0.3% | 1.009 | 0.195 | 0.999 | 1.002 | 1.002 | 0.940 | 0.998 | 1.011 | 1.038 | 0.187 | 1.011 |
| hex: http/html-16kx64 | 2097280 | 15257.0 ± 0.4% | 0.999 | 0.181 | 1.001 | 1.003 | 1.002 | 0.995 | 1.001 | 1.004 | 1.008 | 0.180 | 1.000 |
| hex: http/html-1m | 524290 | 15613.1 ± 0.4% | 1.003 | 0.177 | 1.000 | 1.002 | 1.000 | 0.998 | 0.999 | 1.003 | 1.001 | 0.178 | 1.003 |
| hex: http/json-1kx1024 | 2099200 | 13686.4 ± 0.5% | 1.005 | 0.196 | 1.007 | 1.003 | 1.001 | 0.939 | 0.994 | 1.018 | 1.037 | 0.187 | 1.013 |
| hex: http/json-16kx64 | 2097280 | 15312.8 ± 0.5% | 0.998 | 0.180 | 0.997 | 0.998 | 1.000 | 0.991 | 0.992 | 1.006 | 1.001 | 0.179 | 0.998 |
| hex: http/json-1m | 524290 | 15672.2 ± 0.2% | 1.000 | 0.177 | 1.000 | 1.002 | 1.000 | 1.000 | 1.001 | 1.001 | 1.000 | 0.178 | 1.002 |
| hex: http/js-1kx1024 | 2099200 | 13722.1 ± 0.5% | 1.005 | 0.195 | 1.007 | 1.001 | 1.002 | 0.941 | 1.002 | 1.010 | 1.033 | 0.187 | 1.018 |
| hex: http/js-16kx64 | 2097280 | 15262.5 ± 0.6% | 1.002 | 0.181 | 1.001 | 1.002 | 1.003 | 0.992 | 0.998 | 1.004 | 1.006 | 0.180 | 1.003 |
| hex: http/js-1m | 524290 | 15671.6 ± 0.4% | 1.000 | 0.177 | 1.001 | 1.001 | 1.001 | 1.000 | 1.000 | 0.998 | 1.001 | 0.177 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 13694.1 ± 0.5% | 1.007 | 0.196 | 1.004 | 1.003 | 1.002 | 0.942 | 1.000 | 1.011 | 1.036 | 0.187 | 1.012 |
| hex: http/css-16kx64 | 2097280 | 15278.1 ± 0.5% | 1.000 | 0.181 | 0.998 | 1.000 | 0.999 | 0.987 | 0.995 | 1.003 | 1.005 | 0.180 | 0.997 |
| hex: http/css-1m | 524290 | 15635.5 ± 0.3% | 1.001 | 0.177 | 1.001 | 1.003 | 1.002 | 0.999 | 1.000 | 1.003 | 1.001 | 0.178 | 1.002 |
| hex: shuffled/dickens-1m | 524290 | 15694.3 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.000 | 1.000 | 1.002 | 1.000 | 1.001 | 0.177 | 1.001 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.051 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.056 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.240 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.243 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.239 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.237 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.255 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.249 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.250 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.254 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.211 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.210 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.203 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.211 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.243 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.233 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.235 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.233 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43328.4 ± 0.4% | 47373.1 ± 0.3% | 0.915 | — | — |
| string: silesia/nci | 1048576 | 38365.8 ± 1.7% | 41090.1 ± 1.9% | 0.934 | — | — |
| string: silesia/reymont | 1048576 | 37669.0 ± 3.4% | 40470.2 ± 3.9% | 0.931 | — | — |
| string: silesia/samba | 65546 | 43575.5 ± 0.0% | 48522.5 ± 0.0% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 39425.1 ± 5.4% | 43038.9 ± 1.6% | 0.916 | — | — |
| string: silesia/xml | 1048576 | 33864.1 ± 1.6% | 34652.1 ± 2.6% | 0.977 | — | — |
| string: canterbury/alice29.txt | 152089 | 35900.9 ± 0.2% | 36536.4 ± 0.2% | 0.983 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43337.6 ± 0.2% | 47629.3 ± 0.1% | 0.910 | — | — |
| string: canterbury/lcet10.txt | 426754 | 35028.4 ± 0.3% | 35739.7 ± 0.5% | 0.980 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 43563.2 ± 0.3% | 47656.2 ± 0.2% | 0.914 | — | — |
| string: canterbury-large/E.coli | 1048576 | 36469.6 ± 3.4% | 39107.0 ± 4.4% | 0.933 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 33288.4 ± 2.2% | 34370.2 ± 1.8% | 0.969 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 32878.8 ± 2.9% | 34124.7 ± 2.4% | 0.963 | — | — |
| string: http/html-1m | 1048576 | 38276.9 ± 3.4% | 41415.2 ± 4.4% | 0.924 | — | — |
| string: http/json-1m | 1048576 | 32594.1 ± 3.0% | 35003.9 ± 2.7% | 0.931 | — | — |
| string: http/js-1m | 1048576 | 39290.0 ± 6.1% | 42414.1 ± 4.3% | 0.926 | — | — |
| string: http/css-1m | 1048576 | 37301.3 ± 3.0% | 39913.4 ± 2.2% | 0.935 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5770.2 ± 0.5% | 5653.3 ± 0.1% | 1.021 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.915 of simdutf.
- string: silesia/nci: stdx runs at 0.934 of simdutf.
- string: silesia/reymont: stdx runs at 0.931 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.916 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.910 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.914 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.933 of simdutf.
- string: http/html-1m: stdx runs at 0.924 of simdutf.
- string: http/json-1m: stdx runs at 0.931 of simdutf.
- string: http/js-1m: stdx runs at 0.926 of simdutf.
- string: http/css-1m: stdx runs at 0.935 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 40178.1 ± 2.4% | 43873.4 ± 1.9% | 0.916 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 33426.0 ± 0.7% | 34479.6 ± 1.5% | 0.969 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 38155.6 ± 2.9% | 41437.8 ± 3.7% | 0.921 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 38905.0 ± 2.2% | 42180.8 ± 2.1% | 0.922 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 39250.7 ± 2.5% | 42662.4 ± 3.8% | 0.920 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 38440.8 ± 1.2% | 42034.3 ± 1.6% | 0.915 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5756.0 ± 0.2% | 5638.3 ± 0.2% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5741.0 ± 0.2% | 5625.8 ± 0.5% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5757.4 ± 0.1% | 5636.0 ± 0.3% | 1.022 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5749.1 ± 0.4% | 5626.6 ± 0.2% | 1.022 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5751.9 ± 0.6% | 5626.5 ± 0.4% | 1.022 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5750.7 ± 0.5% | 5630.7 ± 0.5% | 1.021 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1128.0 ± 0.7% | 933.8 ± 0.8% | 1026.8 ± 0.3% | 300.8 ± 0.8% | 664.8 ± 0.4% | 310.1 ± 1.6% | 1.208 | 1.099 | 3.749 | 1.697 | 3.638 |
| qlog records, JSON text sequence | 1467503 | 850.6 ± 1.6% | 818.3 ± 0.2% | 801.8 ± 1.4% | 244.1 ± 0.7% | 700.6 ± 0.9% | 252.9 ± 1.2% | 1.039 | 1.061 | 3.484 | 1.214 | 3.363 |
| string: silesia/dickens | 172528 | 5039.1 ± 0.5% | 1877.7 ± 0.2% | 2654.6 ± 0.5% | 361.7 ± 1.1% | 2860.2 ± 0.3% | 554.0 ± 2.0% | 2.684 | 1.898 | 13.933 | 1.762 | 9.096 |
| string: silesia/nci | 1075110 | 4304.8 ± 0.5% | 2238.1 ± 0.8% | 3003.4 ± 0.3% | 544.1 ± 0.7% | 3020.8 ± 0.6% | 601.0 ± 1.6% | 1.923 | 1.433 | 7.912 | 1.425 | 7.163 |
| string: silesia/reymont | 1075159 | 2916.5 ± 1.7% | 1823.3 ± 1.0% | 2067.3 ± 0.6% | 375.1 ± 0.7% | 2144.5 ± 0.2% | 535.4 ± 1.5% | 1.600 | 1.411 | 7.774 | 1.360 | 5.447 |
| string: silesia/samba | 97582 | 3496.5 ± 0.7% | 2024.2 ± 0.2% | 2610.7 ± 1.8% | 328.9 ± 0.2% | 1507.2 ± 0.6% | 432.5 ± 2.3% | 1.727 | 1.339 | 10.632 | 2.320 | 8.084 |
| string: silesia/webster | 1098490 | 3650.0 ± 0.6% | 1519.1 ± 0.6% | 2018.6 ± 0.6% | 359.4 ± 0.3% | 2178.8 ± 1.0% | 493.1 ± 1.1% | 2.403 | 1.808 | 10.155 | 1.675 | 7.403 |
| string: silesia/xml | 1090118 | 4764.0 ± 0.4% | 2358.4 ± 0.8% | 2536.5 ± 0.4% | 456.0 ± 0.9% | 2862.7 ± 1.3% | 564.2 ± 1.6% | 2.020 | 1.878 | 10.447 | 1.664 | 8.443 |
| string: canterbury/alice29.txt | 159425 | 4305.8 ± 0.9% | 1600.5 ± 0.5% | 2457.8 ± 0.4% | 342.4 ± 0.3% | 2500.8 ± 0.5% | 506.8 ± 1.1% | 2.690 | 1.752 | 12.576 | 1.722 | 8.496 |
| string: canterbury/asyoulik.txt | 132198 | 3454.7 ± 1.0% | 1459.8 ± 0.3% | 2243.9 ± 0.9% | 335.8 ± 0.3% | 2084.1 ± 0.1% | 465.7 ± 1.5% | 2.366 | 1.540 | 10.289 | 1.658 | 7.418 |
| string: canterbury/lcet10.txt | 441884 | 5093.1 ± 0.2% | 1850.3 ± 0.2% | 2342.5 ± 0.8% | 391.0 ± 0.7% | 2851.9 ± 0.7% | 534.3 ± 0.7% | 2.753 | 2.174 | 13.024 | 1.786 | 9.532 |
| string: canterbury/plrabn12.txt | 503330 | 4096.4 ± 0.3% | 1739.5 ± 0.3% | 2061.1 ± 0.4% | 360.0 ± 0.9% | 2490.7 ± 0.6% | 496.3 ± 0.9% | 2.355 | 1.987 | 11.379 | 1.645 | 8.254 |
| string: canterbury-large/E.coli | 1048578 | 19244.7 ± 1.1% | 3612.3 ± 0.3% | 3267.3 ± 0.3% | 926.7 ± 1.1% | 6021.3 ± 0.5% | 749.9 ± 1.5% | 5.328 | 5.890 | 20.767 | 3.196 | 25.664 |
| string: canterbury-large/bible.txt | 1055886 | 6655.2 ± 1.1% | 2941.5 ± 0.2% | 2833.0 ± 1.0% | 420.2 ± 1.9% | 3766.6 ± 1.6% | 613.7 ± 1.1% | 2.262 | 2.349 | 15.837 | 1.767 | 10.845 |
| string: canterbury-large/world192.txt | 1103121 | 3385.0 ± 0.8% | 1481.7 ± 0.4% | 2009.9 ± 0.4% | 352.5 ± 0.6% | 2122.9 ± 1.4% | 496.0 ± 1.3% | 2.284 | 1.684 | 9.602 | 1.595 | 6.825 |
| string: http/html-1m | 1058582 | 6060.8 ± 0.7% | 2742.8 ± 0.4% | 2703.2 ± 0.2% | 441.9 ± 0.1% | 3484.8 ± 0.6% | 597.2 ± 2.1% | 2.210 | 2.242 | 13.715 | 1.739 | 10.148 |
| string: http/json-1m | 1190272 | 2553.3 ± 0.3% | 878.4 ± 0.3% | 2254.8 ± 0.4% | 391.1 ± 0.6% | 1061.5 ± 0.5% | 443.1 ± 0.8% | 2.907 | 1.132 | 6.528 | 2.405 | 5.762 |
| string: http/js-1m | 1144362 | 2287.6 ± 0.4% | 1029.5 ± 0.3% | 1638.2 ± 0.5% | 320.7 ± 0.2% | 1522.4 ± 0.5% | 418.5 ± 1.1% | 2.222 | 1.396 | 7.134 | 1.503 | 5.467 |
| string: http/css-1m | 1097820 | 2640.3 ± 0.7% | 1680.0 ± 0.4% | 2234.3 ± 1.0% | 406.0 ± 0.5% | 1951.1 ± 1.2% | 491.9 ± 0.9% | 1.572 | 1.182 | 6.503 | 1.353 | 5.367 |
| string: dickens as Cyrillic and CJK | 1883069 | 3061.3 ± 0.4% | 1687.6 ± 0.5% | 892.9 ± 0.4% | 350.3 ± 0.2% | 667.3 ± 0.7% | 155.7 ± 2.9% | 1.814 | 3.428 | 8.739 | 4.588 | 19.657 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.1 ± 1.6% | 979.4 ± 0.2% | 1202.3 ± 0.7% | 216.3 ± 0.2% | 469.8 ± 0.4% | 248.6 ± 4.0% | 1.355 | 1.104 | 6.136 | 2.825 | 5.338 |
| hex: silesia/dickens | 524290 | 19139.3 ± 0.5% | 3620.9 ± 0.2% | 3296.8 ± 0.5% | 507.2 ± 1.9% | 6129.3 ± 0.6% | 783.1 ± 3.3% | 5.286 | 5.805 | 37.738 | 3.123 | 24.440 |
| hex: silesia/mozilla | 524290 | 18952.8 ± 0.9% | 3612.1 ± 0.2% | 3304.3 ± 0.4% | 448.2 ± 1.1% | 6085.2 ± 0.9% | 783.9 ± 0.3% | 5.247 | 5.736 | 42.288 | 3.115 | 24.178 |
| hex: silesia/mr | 524290 | 18689.9 ± 0.5% | 3614.3 ± 0.2% | 3301.2 ± 0.2% | 568.1 ± 1.8% | 6086.3 ± 0.9% | 782.5 ± 0.1% | 5.171 | 5.661 | 32.898 | 3.071 | 23.885 |
| hex: silesia/nci | 524290 | 19058.6 ± 1.6% | 3617.4 ± 0.6% | 3297.9 ± 0.2% | 617.7 ± 1.1% | 6151.2 ± 1.2% | 781.1 ± 0.3% | 5.269 | 5.779 | 30.856 | 3.098 | 24.399 |
| hex: silesia/ooffice | 524290 | 19018.2 ± 0.5% | 3615.7 ± 0.3% | 3302.8 ± 0.3% | 405.6 ± 3.0% | 6082.4 ± 1.0% | 782.4 ± 2.7% | 5.260 | 5.758 | 46.887 | 3.127 | 24.309 |
| hex: silesia/osdb | 524290 | 18872.9 ± 0.4% | 3615.4 ± 0.3% | 3306.5 ± 0.2% | 481.8 ± 0.6% | 6121.5 ± 0.7% | 783.1 ± 0.3% | 5.220 | 5.708 | 39.174 | 3.083 | 24.101 |
| hex: silesia/reymont | 524290 | 19033.3 ± 1.2% | 3613.4 ± 0.3% | 3295.3 ± 0.2% | 520.2 ± 1.4% | 6021.1 ± 2.7% | 784.2 ± 0.3% | 5.267 | 5.776 | 36.587 | 3.161 | 24.272 |
| hex: silesia/samba | 524290 | 18741.6 ± 0.2% | 3614.1 ± 0.2% | 3311.0 ± 0.1% | 409.7 ± 0.4% | 6143.3 ± 1.0% | 784.8 ± 0.7% | 5.186 | 5.660 | 45.750 | 3.051 | 23.880 |
| hex: silesia/sao | 524290 | 19059.5 ± 0.6% | 3616.4 ± 0.3% | 3295.2 ± 0.4% | 344.1 ± 0.6% | 6120.1 ± 0.9% | 782.8 ± 0.3% | 5.270 | 5.784 | 55.395 | 3.114 | 24.347 |
| hex: silesia/webster | 524290 | 19155.1 ± 0.4% | 3616.5 ± 0.4% | 3306.2 ± 0.4% | 480.2 ± 0.5% | 6140.3 ± 1.9% | 782.9 ± 0.3% | 5.297 | 5.794 | 39.893 | 3.120 | 24.467 |
| hex: silesia/x-ray | 524290 | 18784.2 ± 0.4% | 3618.4 ± 0.1% | 3297.4 ± 0.2% | 486.3 ± 0.4% | 6153.8 ± 1.6% | 782.4 ± 0.5% | 5.191 | 5.697 | 38.628 | 3.052 | 24.009 |
| hex: silesia/xml | 524290 | 19069.9 ± 1.2% | 3615.9 ± 0.3% | 3302.9 ± 0.3% | 531.4 ± 0.5% | 6127.8 ± 1.4% | 784.5 ± 0.6% | 5.274 | 5.774 | 35.888 | 3.112 | 24.309 |
| hex: canterbury/alice29.txt | 304180 | 19247.6 ± 0.7% | 3638.1 ± 0.1% | 3349.5 ± 0.1% | 522.1 ± 0.2% | 6119.4 ± 1.6% | 782.8 ± 0.3% | 5.291 | 5.746 | 36.864 | 3.145 | 24.589 |
| hex: canterbury/asyoulik.txt | 250360 | 19272.5 ± 0.1% | 3640.6 ± 0.1% | 3373.0 ± 0.2% | 515.8 ± 0.2% | 6176.5 ± 2.1% | 781.7 ± 0.6% | 5.294 | 5.714 | 37.367 | 3.120 | 24.653 |
| hex: canterbury/cp.html | 49208 | 19303.0 ± 0.7% | 3638.6 ± 0.0% | 3283.8 ± 0.4% | 482.0 ± 1.4% | 6262.9 ± 0.3% | 760.6 ± 2.0% | 5.305 | 5.878 | 40.049 | 3.082 | 25.378 |
| hex: canterbury/fields.c | 22302 | 18818.7 ± 0.6% | 3629.6 ± 0.1% | 3368.1 ± 0.4% | 511.6 ± 0.7% | 6248.8 ± 0.6% | 754.2 ± 2.3% | 5.185 | 5.587 | 36.784 | 3.012 | 24.953 |
| hex: canterbury/grammar.lsp | 7444 | 17462.7 ± 2.4% | 3601.4 ± 0.0% | 3369.1 ± 0.3% | 554.2 ± 2.1% | 6183.3 ± 0.4% | 715.5 ± 2.0% | 4.849 | 5.183 | 31.508 | 2.824 | 24.406 |
| hex: canterbury/kennedy.xls | 524290 | 19075.2 ± 1.2% | 3610.3 ± 0.3% | 3301.1 ± 0.2% | 663.4 ± 2.4% | 6047.4 ± 1.9% | 776.7 ± 6.7% | 5.284 | 5.778 | 28.752 | 3.154 | 24.560 |
| hex: canterbury/lcet10.txt | 524290 | 19037.8 ± 1.3% | 3616.6 ± 0.5% | 3301.1 ± 0.2% | 516.5 ± 2.6% | 6091.1 ± 1.2% | 784.3 ± 0.9% | 5.264 | 5.767 | 36.861 | 3.126 | 24.275 |
| hex: canterbury/plrabn12.txt | 524290 | 18745.8 ± 0.4% | 3621.7 ± 0.6% | 3305.2 ± 0.2% | 516.6 ± 0.4% | 6136.6 ± 2.0% | 782.7 ± 0.8% | 5.176 | 5.672 | 36.288 | 3.055 | 23.950 |
| hex: canterbury/ptt5 | 524290 | 18989.5 ± 0.3% | 3616.5 ± 0.2% | 3293.7 ± 0.1% | 565.8 ± 0.4% | 6144.4 ± 1.6% | 785.0 ± 1.0% | 5.251 | 5.765 | 33.560 | 3.091 | 24.191 |
| hex: canterbury/sum | 76482 | 19294.1 ± 0.1% | 3634.6 ± 0.0% | 3354.5 ± 0.3% | 518.1 ± 2.5% | 6165.7 ± 2.6% | 772.6 ± 1.1% | 5.308 | 5.752 | 37.243 | 3.129 | 24.972 |
| hex: canterbury/xargs.1 | 8456 | 17800.7 ± 0.2% | 3602.6 ± 0.0% | 3374.9 ± 0.2% | 496.9 ± 3.0% | 6148.6 ± 0.4% | 757.7 ± 0.8% | 4.941 | 5.274 | 35.825 | 2.895 | 23.493 |
| hex: canterbury-large/E.coli | 524290 | 19055.1 ± 1.0% | 3618.3 ± 0.2% | 3295.1 ± 0.3% | 689.0 ± 0.1% | 6155.0 ± 0.6% | 775.4 ± 7.1% | 5.266 | 5.783 | 27.656 | 3.096 | 24.574 |
| hex: canterbury-large/bible.txt | 524290 | 18988.1 ± 1.4% | 3617.3 ± 0.4% | 3304.7 ± 0.2% | 529.7 ± 2.2% | 6129.3 ± 0.4% | 772.0 ± 1.1% | 5.249 | 5.746 | 35.845 | 3.098 | 24.595 |
| hex: canterbury-large/world192.txt | 524290 | 18732.0 ± 0.7% | 3619.0 ± 0.2% | 3299.1 ± 0.2% | 507.7 ± 1.7% | 6142.1 ± 1.5% | 772.8 ± 0.5% | 5.176 | 5.678 | 36.898 | 3.050 | 24.239 |
| hex: http/html-1kx1024 | 2099200 | 9876.5 ± 11.4% | 3463.6 ± 0.4% | 2905.8 ± 0.4% | 473.8 ± 0.4% | 5156.5 ± 1.0% | 648.5 ± 3.7% | 2.852 | 3.399 | 20.846 | 1.915 | 15.229 |
| hex: http/html-16kx64 | 2097280 | 18576.1 ± 0.3% | 3610.8 ± 0.2% | 3274.2 ± 0.2% | 477.8 ± 1.3% | 6034.0 ± 0.5% | 754.7 ± 2.2% | 5.145 | 5.673 | 38.877 | 3.079 | 24.614 |
| hex: http/html-1m | 524290 | 18852.5 ± 1.4% | 3615.9 ± 0.3% | 3316.9 ± 0.7% | 505.1 ± 1.4% | 6096.8 ± 1.0% | 758.7 ± 4.9% | 5.214 | 5.684 | 37.324 | 3.092 | 24.848 |
| hex: http/json-1kx1024 | 2099200 | 9766.5 ± 11.8% | 3458.8 ± 0.2% | 2898.7 ± 0.5% | 574.9 ± 0.4% | 5171.5 ± 1.5% | 646.7 ± 2.2% | 2.824 | 3.369 | 16.988 | 1.889 | 15.103 |
| hex: http/json-16kx64 | 2097280 | 18561.7 ± 0.7% | 3610.0 ± 0.2% | 3267.7 ± 0.2% | 574.1 ± 1.4% | 6033.6 ± 0.3% | 755.6 ± 1.5% | 5.142 | 5.680 | 32.332 | 3.076 | 24.565 |
| hex: http/json-1m | 524290 | 18923.2 ± 0.9% | 3620.2 ± 0.2% | 3304.4 ± 0.4% | 597.2 ± 2.3% | 6096.4 ± 0.8% | 767.5 ± 2.0% | 5.227 | 5.727 | 31.687 | 3.104 | 24.657 |
| hex: http/js-1kx1024 | 2099200 | 10077.9 ± 17.1% | 3464.8 ± 0.2% | 2904.7 ± 0.4% | 480.8 ± 1.0% | 5186.9 ± 1.6% | 654.4 ± 4.8% | 2.909 | 3.469 | 20.962 | 1.943 | 15.399 |
| hex: http/js-16kx64 | 2097280 | 18552.1 ± 1.3% | 3610.0 ± 0.2% | 3268.8 ± 0.2% | 482.7 ± 0.9% | 6031.4 ± 0.5% | 754.1 ± 2.5% | 5.139 | 5.675 | 38.436 | 3.076 | 24.602 |
| hex: http/js-1m | 524290 | 19178.6 ± 2.0% | 3618.8 ± 3.0% | 3302.4 ± 0.3% | 511.1 ± 1.7% | 6095.8 ± 1.2% | 760.4 ± 1.3% | 5.300 | 5.808 | 37.527 | 3.146 | 25.221 |
| hex: http/css-1kx1024 | 2099200 | 9962.6 ± 16.3% | 3464.8 ± 0.1% | 2892.6 ± 0.7% | 488.1 ± 1.1% | 5154.9 ± 0.7% | 657.4 ± 1.5% | 2.875 | 3.444 | 20.410 | 1.933 | 15.154 |
| hex: http/css-16kx64 | 2097280 | 18568.0 ± 0.8% | 3610.9 ± 0.1% | 3273.3 ± 0.2% | 495.7 ± 0.6% | 6053.0 ± 0.9% | 764.3 ± 1.5% | 5.142 | 5.673 | 37.462 | 3.068 | 24.294 |
| hex: http/css-1m | 524290 | 18876.7 ± 1.5% | 3605.8 ± 0.5% | 3302.3 ± 0.2% | 497.0 ± 1.9% | 6091.1 ± 0.5% | 769.4 ± 2.3% | 5.235 | 5.716 | 37.979 | 3.099 | 24.535 |
| hex: shuffled/dickens-1m | 524290 | 18912.9 ± 0.4% | 3613.6 ± 0.4% | 3296.9 ± 0.2% | 512.5 ± 0.4% | 6076.7 ± 1.1% | 771.2 ± 1.1% | 5.234 | 5.736 | 36.905 | 3.112 | 24.524 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1489.7 ± 0.5% | 1259.5 ± 0.4% | 1046.4 ± 0.2% | 410.7 ± 0.7% | 448.9 ± 0.3% | 416.6 ± 0.3% | 1.183 | 1.424 | 3.627 | 3.319 | 3.576 |
| qlog records, JSON text sequence | 1467503 | 1269.8 ± 1.5% | 1066.1 ± 0.2% | 789.3 ± 0.6% | 379.6 ± 0.8% | 473.1 ± 0.3% | 280.1 ± 0.3% | 1.191 | 1.609 | 3.345 | 2.684 | 4.534 |
| string: silesia/dickens | 172528 | 6888.2 ± 0.4% | 2821.5 ± 0.4% | 2929.9 ± 0.8% | 430.0 ± 0.7% | 1567.1 ± 0.3% | 1008.8 ± 0.1% | 2.441 | 2.351 | 16.019 | 4.395 | 6.828 |
| string: silesia/nci | 1075110 | 7326.6 ± 0.5% | 3432.8 ± 0.9% | 3097.2 ± 0.8% | 815.6 ± 0.7% | 1857.5 ± 0.1% | 1110.2 ± 0.4% | 2.134 | 2.366 | 8.983 | 3.944 | 6.600 |
| string: silesia/reymont | 1075159 | 3336.1 ± 1.2% | 1980.9 ± 1.7% | 2062.0 ± 0.3% | 452.0 ± 0.3% | 1512.1 ± 1.4% | 951.5 ± 0.7% | 1.684 | 1.618 | 7.381 | 2.206 | 3.506 |
| string: silesia/samba | 97582 | 4192.2 ± 1.0% | 2112.6 ± 1.2% | 3443.1 ± 0.6% | 354.8 ± 0.9% | 1435.3 ± 0.4% | 1055.8 ± 0.1% | 1.984 | 1.218 | 11.817 | 2.921 | 3.971 |
| string: silesia/webster | 1098490 | 4054.1 ± 0.5% | 1882.3 ± 0.5% | 2054.1 ± 0.8% | 441.5 ± 0.6% | 1388.3 ± 0.3% | 647.7 ± 1.0% | 2.154 | 1.974 | 9.182 | 2.920 | 6.259 |
| string: silesia/xml | 1090118 | 6106.5 ± 0.8% | 2879.3 ± 0.6% | 2645.9 ± 0.8% | 611.9 ± 0.8% | 1750.0 ± 0.5% | 923.4 ± 0.3% | 2.121 | 2.308 | 9.979 | 3.489 | 6.613 |
| string: canterbury/alice29.txt | 159425 | 6390.7 ± 0.9% | 2200.6 ± 0.3% | 2769.1 ± 1.0% | 404.9 ± 0.9% | 1464.1 ± 0.4% | 953.5 ± 0.2% | 2.904 | 2.308 | 15.783 | 4.365 | 6.702 |
| string: canterbury/asyoulik.txt | 132198 | 5593.0 ± 1.9% | 1715.9 ± 0.4% | 2360.3 ± 1.7% | 402.0 ± 0.7% | 1338.2 ± 0.3% | 886.0 ± 3.1% | 3.260 | 2.370 | 13.913 | 4.180 | 6.313 |
| string: canterbury/lcet10.txt | 441884 | 6249.0 ± 0.6% | 2572.4 ± 0.4% | 2493.1 ± 1.8% | 468.5 ± 0.9% | 1519.0 ± 0.6% | 987.8 ± 0.2% | 2.429 | 2.506 | 13.337 | 4.114 | 6.326 |
| string: canterbury/plrabn12.txt | 503330 | 5721.0 ± 0.4% | 2060.2 ± 0.3% | 2073.3 ± 0.4% | 425.0 ± 0.5% | 1408.9 ± 0.3% | 932.5 ± 0.1% | 2.777 | 2.759 | 13.460 | 4.061 | 6.135 |
| string: canterbury-large/E.coli | 1048578 | 19315.8 ± 0.7% | 9827.3 ± 1.0% | 3788.5 ± 0.5% | 1476.4 ± 0.6% | 2374.0 ± 0.3% | 1199.4 ± 0.9% | 1.966 | 5.099 | 13.083 | 8.137 | 16.104 |
| string: canterbury-large/bible.txt | 1055886 | 6799.0 ± 0.5% | 4177.3 ± 0.7% | 3030.0 ± 1.4% | 503.4 ± 0.4% | 1982.3 ± 0.4% | 1124.2 ± 0.4% | 1.628 | 2.244 | 13.507 | 3.430 | 6.048 |
| string: canterbury-large/world192.txt | 1103121 | 4027.8 ± 0.6% | 1659.6 ± 0.3% | 2008.5 ± 1.0% | 448.7 ± 0.4% | 1357.5 ± 0.2% | 910.8 ± 0.2% | 2.427 | 2.005 | 8.977 | 2.967 | 4.422 |
| string: http/html-1m | 1058582 | 6756.3 ± 0.4% | 4006.0 ± 0.2% | 3043.1 ± 0.5% | 499.7 ± 0.4% | 1925.7 ± 0.4% | 808.8 ± 0.3% | 1.687 | 2.220 | 13.520 | 3.508 | 8.354 |
| string: http/json-1m | 1190272 | 3167.1 ± 0.4% | 1355.2 ± 0.2% | 1557.4 ± 0.2% | 444.4 ± 0.5% | 962.7 ± 0.2% | 766.5 ± 0.5% | 2.337 | 2.034 | 7.126 | 3.290 | 4.132 |
| string: http/js-1m | 1144362 | 2761.3 ± 0.8% | 1182.8 ± 0.2% | 1621.6 ± 0.5% | 369.2 ± 0.3% | 1094.8 ± 0.2% | 761.0 ± 0.2% | 2.335 | 1.703 | 7.478 | 2.522 | 3.629 |
| string: http/css-1m | 1097820 | 3980.0 ± 0.3% | 1486.8 ± 0.4% | 2151.4 ± 1.2% | 494.2 ± 0.7% | 1370.0 ± 0.3% | 897.1 ± 0.6% | 2.677 | 1.850 | 8.053 | 2.905 | 4.436 |
| string: dickens as Cyrillic and CJK | 1883069 | 3073.6 ± 0.2% | 2342.7 ± 0.3% | 521.3 ± 0.3% | 306.7 ± 1.2% | 563.6 ± 0.9% | 336.6 ± 0.4% | 1.312 | 5.897 | 10.021 | 5.454 | 9.131 |
| hex: silesia/dickens | 524290 | 15666.1 ± 0.3% | 1469.4 ± 0.3% | 1082.1 ± 0.4% | 502.7 ± 0.4% | 990.4 ± 0.5% | 736.2 ± 0.5% | 10.662 | 14.478 | 31.167 | 15.818 | 21.279 |
| hex: silesia/mozilla | 524290 | 15688.7 ± 0.2% | 1478.1 ± 0.4% | 1089.9 ± 0.6% | 441.8 ± 0.4% | 989.1 ± 0.3% | 735.3 ± 0.4% | 10.614 | 14.394 | 35.507 | 15.862 | 21.337 |
| hex: silesia/mr | 524290 | 15624.4 ± 0.3% | 1486.0 ± 0.5% | 1095.2 ± 0.4% | 558.5 ± 3.5% | 997.6 ± 0.3% | 736.7 ± 0.3% | 10.515 | 14.267 | 27.977 | 15.662 | 21.210 |
| hex: silesia/nci | 524290 | 15679.9 ± 0.1% | 1478.4 ± 0.5% | 1092.2 ± 0.8% | 638.3 ± 2.9% | 991.0 ± 0.5% | 735.7 ± 0.5% | 10.606 | 14.356 | 24.565 | 15.822 | 21.313 |
| hex: silesia/ooffice | 524290 | 15662.0 ± 0.1% | 1472.6 ± 0.3% | 1085.1 ± 0.3% | 389.6 ± 0.4% | 991.0 ± 0.6% | 736.7 ± 0.1% | 10.636 | 14.434 | 40.200 | 15.805 | 21.259 |
| hex: silesia/osdb | 524290 | 15608.5 ± 0.2% | 1472.4 ± 0.2% | 1086.9 ± 0.5% | 468.6 ± 0.6% | 988.7 ± 0.2% | 735.3 ± 0.6% | 10.601 | 14.360 | 33.305 | 15.786 | 21.228 |
| hex: silesia/reymont | 524290 | 15667.6 ± 0.2% | 1469.9 ± 0.6% | 1087.4 ± 0.9% | 517.5 ± 1.2% | 990.9 ± 0.8% | 737.2 ± 0.1% | 10.659 | 14.409 | 30.278 | 15.812 | 21.252 |
| hex: silesia/samba | 524290 | 15648.9 ± 0.2% | 1471.1 ± 0.5% | 1084.1 ± 0.5% | 401.9 ± 0.2% | 992.0 ± 0.9% | 734.6 ± 1.2% | 10.637 | 14.435 | 38.932 | 15.776 | 21.303 |
| hex: silesia/sao | 524290 | 15637.7 ± 0.4% | 1471.2 ± 0.3% | 1083.9 ± 0.3% | 333.2 ± 0.3% | 993.1 ± 0.2% | 736.1 ± 1.1% | 10.629 | 14.427 | 46.935 | 15.747 | 21.245 |
| hex: silesia/webster | 524290 | 15596.0 ± 0.4% | 1472.0 ± 0.1% | 1087.5 ± 0.2% | 477.3 ± 0.9% | 990.5 ± 0.5% | 736.8 ± 0.3% | 10.595 | 14.341 | 32.675 | 15.745 | 21.168 |
| hex: silesia/x-ray | 524290 | 15624.8 ± 0.3% | 1481.7 ± 0.2% | 1090.5 ± 0.3% | 447.3 ± 1.0% | 994.0 ± 0.2% | 735.0 ± 0.5% | 10.545 | 14.328 | 34.931 | 15.720 | 21.259 |
| hex: silesia/xml | 524290 | 15598.8 ± 0.4% | 1474.9 ± 0.3% | 1087.9 ± 0.4% | 617.6 ± 0.7% | 991.6 ± 0.4% | 736.4 ± 0.8% | 10.576 | 14.339 | 25.256 | 15.731 | 21.181 |
| hex: canterbury/alice29.txt | 304180 | 15663.7 ± 0.2% | 1473.1 ± 0.6% | 1090.8 ± 0.5% | 503.6 ± 0.5% | 993.4 ± 1.0% | 737.0 ± 0.8% | 10.633 | 14.359 | 31.101 | 15.769 | 21.255 |
| hex: canterbury/asyoulik.txt | 250360 | 15693.2 ± 0.2% | 1479.5 ± 0.5% | 1092.9 ± 0.5% | 497.8 ± 0.5% | 993.9 ± 0.2% | 740.1 ± 0.5% | 10.607 | 14.359 | 31.526 | 15.790 | 21.204 |
| hex: canterbury/cp.html | 49208 | 15622.5 ± 0.5% | 1473.6 ± 0.8% | 1098.8 ± 0.2% | 527.1 ± 0.7% | 1002.9 ± 0.5% | 742.8 ± 0.2% | 10.602 | 14.217 | 29.639 | 15.577 | 21.031 |
| hex: canterbury/fields.c | 22302 | 15442.7 ± 0.0% | 1412.1 ± 0.8% | 1064.3 ± 0.4% | 611.6 ± 5.6% | 986.2 ± 0.3% | 737.2 ± 0.2% | 10.936 | 14.510 | 25.250 | 15.658 | 20.948 |
| hex: canterbury/grammar.lsp | 7444 | 14946.7 ± 0.1% | 1507.8 ± 0.3% | 1093.8 ± 0.4% | 662.5 ± 4.6% | 990.3 ± 0.4% | 726.1 ± 0.1% | 9.913 | 13.665 | 22.562 | 15.093 | 20.586 |
| hex: canterbury/kennedy.xls | 524290 | 15657.9 ± 0.2% | 1475.9 ± 0.4% | 1091.2 ± 0.6% | 664.2 ± 1.9% | 990.8 ± 0.4% | 735.1 ± 0.5% | 10.609 | 14.349 | 23.573 | 15.803 | 21.301 |
| hex: canterbury/lcet10.txt | 524290 | 15640.9 ± 0.2% | 1470.8 ± 0.2% | 1086.9 ± 0.3% | 498.8 ± 4.3% | 989.8 ± 0.5% | 734.7 ± 0.7% | 10.634 | 14.390 | 31.357 | 15.801 | 21.287 |
| hex: canterbury/plrabn12.txt | 524290 | 15635.8 ± 0.3% | 1469.1 ± 0.1% | 1087.3 ± 0.4% | 493.5 ± 1.6% | 987.4 ± 0.4% | 736.2 ± 0.4% | 10.643 | 14.381 | 31.684 | 15.835 | 21.239 |
| hex: canterbury/ptt5 | 524290 | 15648.2 ± 0.1% | 1488.4 ± 0.2% | 1094.0 ± 0.5% | 554.8 ± 0.4% | 992.2 ± 0.3% | 736.3 ± 0.3% | 10.514 | 14.303 | 28.203 | 15.772 | 21.252 |
| hex: canterbury/sum | 76482 | 15644.0 ± 0.0% | 1495.2 ± 0.8% | 1103.8 ± 0.3% | 599.7 ± 0.7% | 998.4 ± 0.2% | 744.5 ± 0.2% | 10.463 | 14.172 | 26.088 | 15.670 | 21.014 |
| hex: canterbury/xargs.1 | 8456 | 15012.1 ± 0.0% | 1460.2 ± 2.5% | 1092.0 ± 0.8% | 663.7 ± 5.0% | 997.7 ± 0.4% | 728.2 ± 0.8% | 10.281 | 13.747 | 22.618 | 15.047 | 20.614 |
| hex: canterbury-large/E.coli | 524290 | 15626.3 ± 0.3% | 1479.6 ± 0.5% | 1090.5 ± 0.6% | 672.1 ± 0.4% | 993.8 ± 0.5% | 735.4 ± 0.4% | 10.561 | 14.330 | 23.251 | 15.723 | 21.249 |
| hex: canterbury-large/bible.txt | 524290 | 15661.2 ± 0.3% | 1473.0 ± 0.2% | 1085.4 ± 1.9% | 514.6 ± 0.8% | 990.9 ± 0.9% | 735.2 ± 0.6% | 10.632 | 14.429 | 30.432 | 15.806 | 21.302 |
| hex: canterbury-large/world192.txt | 524290 | 15616.4 ± 0.2% | 1471.8 ± 0.2% | 1085.6 ± 0.8% | 501.9 ± 1.4% | 988.7 ± 0.4% | 734.2 ± 0.4% | 10.610 | 14.385 | 31.115 | 15.795 | 21.269 |
| hex: http/html-1kx1024 | 2099200 | 13718.9 ± 0.3% | 1454.1 ± 0.2% | 1061.9 ± 0.3% | 502.1 ± 0.3% | 982.6 ± 0.3% | 692.8 ± 0.2% | 9.435 | 12.919 | 27.323 | 13.962 | 19.803 |
| hex: http/html-16kx64 | 2097280 | 15257.0 ± 0.4% | 1446.2 ± 0.2% | 1074.6 ± 0.4% | 508.1 ± 0.5% | 996.0 ± 0.1% | 734.9 ± 0.2% | 10.550 | 14.198 | 30.027 | 15.318 | 20.759 |
| hex: http/html-1m | 524290 | 15613.1 ± 0.4% | 1473.7 ± 0.4% | 1086.0 ± 0.7% | 503.0 ± 0.5% | 988.6 ± 0.4% | 734.7 ± 0.5% | 10.594 | 14.377 | 31.038 | 15.794 | 21.252 |
| hex: http/json-1kx1024 | 2099200 | 13686.4 ± 0.5% | 1463.4 ± 0.1% | 1066.8 ± 0.1% | 608.9 ± 1.4% | 985.7 ± 0.2% | 692.3 ± 0.3% | 9.353 | 12.830 | 22.477 | 13.884 | 19.769 |
| hex: http/json-16kx64 | 2097280 | 15312.8 ± 0.5% | 1446.6 ± 0.1% | 1077.0 ± 0.3% | 616.1 ± 0.6% | 996.3 ± 0.1% | 735.6 ± 0.1% | 10.585 | 14.218 | 24.855 | 15.370 | 20.816 |
| hex: http/json-1m | 524290 | 15672.2 ± 0.2% | 1478.5 ± 0.2% | 1088.6 ± 0.3% | 633.3 ± 0.4% | 993.3 ± 0.3% | 737.1 ± 0.4% | 10.600 | 14.396 | 24.748 | 15.778 | 21.261 |
| hex: http/js-1kx1024 | 2099200 | 13722.1 ± 0.5% | 1457.2 ± 0.3% | 1063.6 ± 0.2% | 500.0 ± 0.3% | 984.4 ± 0.3% | 693.0 ± 0.1% | 9.416 | 12.901 | 27.445 | 13.940 | 19.800 |
| hex: http/js-16kx64 | 2097280 | 15262.5 ± 0.6% | 1445.0 ± 0.3% | 1076.2 ± 0.2% | 505.8 ± 0.3% | 996.9 ± 0.4% | 735.2 ± 0.2% | 10.562 | 14.181 | 30.176 | 15.310 | 20.760 |
| hex: http/js-1m | 524290 | 15671.6 ± 0.4% | 1472.9 ± 0.2% | 1085.6 ± 0.4% | 513.5 ± 0.7% | 992.1 ± 0.7% | 735.9 ± 0.3% | 10.640 | 14.436 | 30.522 | 15.796 | 21.295 |
| hex: http/css-1kx1024 | 2099200 | 13694.1 ± 0.5% | 1455.7 ± 0.2% | 1063.0 ± 0.2% | 531.3 ± 0.5% | 983.3 ± 0.1% | 692.6 ± 0.2% | 9.407 | 12.883 | 25.775 | 13.927 | 19.772 |
| hex: http/css-16kx64 | 2097280 | 15278.1 ± 0.5% | 1446.6 ± 0.1% | 1076.3 ± 0.3% | 541.9 ± 0.9% | 996.0 ± 0.6% | 734.6 ± 0.3% | 10.561 | 14.195 | 28.194 | 15.340 | 20.798 |
| hex: http/css-1m | 524290 | 15635.5 ± 0.3% | 1474.0 ± 0.3% | 1086.7 ± 0.5% | 529.4 ± 0.5% | 987.2 ± 0.9% | 735.2 ± 0.5% | 10.607 | 14.388 | 29.537 | 15.838 | 21.268 |
| hex: shuffled/dickens-1m | 524290 | 15694.3 ± 0.1% | 1467.2 ± 0.6% | 1083.3 ± 0.5% | 497.9 ± 0.7% | 985.9 ± 0.5% | 735.9 ± 0.6% | 10.696 | 14.487 | 31.520 | 15.919 | 21.327 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1532.2 ± 0.4% | 1259.5 ± 0.4% | 1046.4 ± 0.2% | 410.7 ± 0.7% | 448.9 ± 0.3% | 416.6 ± 0.3% | 1.216 | 1.464 | 3.731 | 3.413 | 3.678 |
| qlog records, JSON text sequence | 1467503 | 1294.0 ± 0.3% | 1066.1 ± 0.2% | 789.3 ± 0.6% | 379.6 ± 0.8% | 473.1 ± 0.3% | 280.1 ± 0.3% | 1.214 | 1.640 | 3.409 | 2.735 | 4.620 |
| string: silesia/dickens | 172528 | 7132.9 ± 0.2% | 2821.5 ± 0.4% | 2929.9 ± 0.8% | 430.0 ± 0.7% | 1567.1 ± 0.3% | 1008.8 ± 0.1% | 2.528 | 2.434 | 16.588 | 4.552 | 7.071 |
| string: silesia/nci | 1075110 | 7383.6 ± 6.9% | 3432.8 ± 0.9% | 3097.2 ± 0.8% | 815.6 ± 0.7% | 1857.5 ± 0.1% | 1110.2 ± 0.4% | 2.151 | 2.384 | 9.053 | 3.975 | 6.651 |
| string: silesia/reymont | 1075159 | 3499.7 ± 0.9% | 1980.9 ± 1.7% | 2062.0 ± 0.3% | 452.0 ± 0.3% | 1512.1 ± 1.4% | 951.5 ± 0.7% | 1.767 | 1.697 | 7.743 | 2.314 | 3.678 |
| string: silesia/samba | 97582 | 4578.7 ± 1.4% | 2112.6 ± 1.2% | 3443.1 ± 0.6% | 354.8 ± 0.9% | 1435.3 ± 0.4% | 1055.8 ± 0.1% | 2.167 | 1.330 | 12.907 | 3.190 | 4.337 |
| string: silesia/webster | 1098490 | 4099.7 ± 0.3% | 1882.3 ± 0.5% | 2054.1 ± 0.8% | 441.5 ± 0.6% | 1388.3 ± 0.3% | 647.7 ± 1.0% | 2.178 | 1.996 | 9.285 | 2.953 | 6.329 |
| string: silesia/xml | 1090118 | 6233.5 ± 0.4% | 2879.3 ± 0.6% | 2645.9 ± 0.8% | 611.9 ± 0.8% | 1750.0 ± 0.5% | 923.4 ± 0.3% | 2.165 | 2.356 | 10.187 | 3.562 | 6.750 |
| string: canterbury/alice29.txt | 159425 | 6811.8 ± 1.2% | 2200.6 ± 0.3% | 2769.1 ± 1.0% | 404.9 ± 0.9% | 1464.1 ± 0.4% | 953.5 ± 0.2% | 3.096 | 2.460 | 16.823 | 4.653 | 7.144 |
| string: canterbury/asyoulik.txt | 132198 | 5877.8 ± 2.1% | 1715.9 ± 0.4% | 2360.3 ± 1.7% | 402.0 ± 0.7% | 1338.2 ± 0.3% | 886.0 ± 3.1% | 3.425 | 2.490 | 14.621 | 4.392 | 6.634 |
| string: canterbury/lcet10.txt | 441884 | 6251.5 ± 0.6% | 2572.4 ± 0.4% | 2493.1 ± 1.8% | 468.5 ± 0.9% | 1519.0 ± 0.6% | 987.8 ± 0.2% | 2.430 | 2.508 | 13.342 | 4.116 | 6.329 |
| string: canterbury/plrabn12.txt | 503330 | 5764.8 ± 0.3% | 2060.2 ± 0.3% | 2073.3 ± 0.4% | 425.0 ± 0.5% | 1408.9 ± 0.3% | 932.5 ± 0.1% | 2.798 | 2.781 | 13.563 | 4.092 | 6.182 |
| string: canterbury-large/E.coli | 1048578 | 19405.7 ± 0.5% | 9827.3 ± 1.0% | 3788.5 ± 0.5% | 1476.4 ± 0.6% | 2374.0 ± 0.3% | 1199.4 ± 0.9% | 1.975 | 5.122 | 13.144 | 8.174 | 16.179 |
| string: canterbury-large/bible.txt | 1055886 | 6814.2 ± 0.4% | 4177.3 ± 0.7% | 3030.0 ± 1.4% | 503.4 ± 0.4% | 1982.3 ± 0.4% | 1124.2 ± 0.4% | 1.631 | 2.249 | 13.538 | 3.438 | 6.061 |
| string: canterbury-large/world192.txt | 1103121 | 4034.8 ± 0.8% | 1659.6 ± 0.3% | 2008.5 ± 1.0% | 448.7 ± 0.4% | 1357.5 ± 0.2% | 910.8 ± 0.2% | 2.431 | 2.009 | 8.992 | 2.972 | 4.430 |
| string: http/html-1m | 1058582 | 6824.9 ± 0.2% | 4006.0 ± 0.2% | 3043.1 ± 0.5% | 499.7 ± 0.4% | 1925.7 ± 0.4% | 808.8 ± 0.3% | 1.704 | 2.243 | 13.657 | 3.544 | 8.439 |
| string: http/json-1m | 1190272 | 3293.7 ± 0.4% | 1355.2 ± 0.2% | 1557.4 ± 0.2% | 444.4 ± 0.5% | 962.7 ± 0.2% | 766.5 ± 0.5% | 2.430 | 2.115 | 7.411 | 3.421 | 4.297 |
| string: http/js-1m | 1144362 | 2817.8 ± 0.3% | 1182.8 ± 0.2% | 1621.6 ± 0.5% | 369.2 ± 0.3% | 1094.8 ± 0.2% | 761.0 ± 0.2% | 2.382 | 1.738 | 7.631 | 2.574 | 3.703 |
| string: http/css-1m | 1097820 | 4019.1 ± 1.4% | 1486.8 ± 0.4% | 2151.4 ± 1.2% | 494.2 ± 0.7% | 1370.0 ± 0.3% | 897.1 ± 0.6% | 2.703 | 1.868 | 8.132 | 2.934 | 4.480 |
| string: dickens as Cyrillic and CJK | 1883069 | 3078.2 ± 0.5% | 2342.7 ± 0.3% | 521.3 ± 0.3% | 306.7 ± 1.2% | 563.6 ± 0.9% | 336.6 ± 0.4% | 1.314 | 5.905 | 10.036 | 5.462 | 9.145 |
| hex: silesia/dickens | 524290 | 15706.4 ± 0.2% | 1469.4 ± 0.3% | 1082.1 ± 0.4% | 502.7 ± 0.4% | 990.4 ± 0.5% | 736.2 ± 0.5% | 10.689 | 14.515 | 31.247 | 15.859 | 21.334 |
| hex: silesia/mozilla | 524290 | 15683.6 ± 0.5% | 1478.1 ± 0.4% | 1089.9 ± 0.6% | 441.8 ± 0.4% | 989.1 ± 0.3% | 735.3 ± 0.4% | 10.611 | 14.389 | 35.495 | 15.856 | 21.330 |
| hex: silesia/mr | 524290 | 15644.3 ± 0.4% | 1486.0 ± 0.5% | 1095.2 ± 0.4% | 558.5 ± 3.5% | 997.6 ± 0.3% | 736.7 ± 0.3% | 10.528 | 14.285 | 28.013 | 15.682 | 21.237 |
| hex: silesia/nci | 524290 | 15657.1 ± 0.2% | 1478.4 ± 0.5% | 1092.2 ± 0.8% | 638.3 ± 2.9% | 991.0 ± 0.5% | 735.7 ± 0.5% | 10.590 | 14.335 | 24.530 | 15.799 | 21.282 |
| hex: silesia/ooffice | 524290 | 15663.3 ± 0.2% | 1472.6 ± 0.3% | 1085.1 ± 0.3% | 389.6 ± 0.4% | 991.0 ± 0.6% | 736.7 ± 0.1% | 10.637 | 14.435 | 40.204 | 15.806 | 21.261 |
| hex: silesia/osdb | 524290 | 15621.7 ± 0.4% | 1472.4 ± 0.2% | 1086.9 ± 0.5% | 468.6 ± 0.6% | 988.7 ± 0.2% | 735.3 ± 0.6% | 10.610 | 14.372 | 33.334 | 15.800 | 21.246 |
| hex: silesia/reymont | 524290 | 15664.1 ± 0.5% | 1469.9 ± 0.6% | 1087.4 ± 0.9% | 517.5 ± 1.2% | 990.9 ± 0.8% | 737.2 ± 0.1% | 10.656 | 14.405 | 30.272 | 15.808 | 21.247 |
| hex: silesia/samba | 524290 | 15676.6 ± 0.2% | 1471.1 ± 0.5% | 1084.1 ± 0.5% | 401.9 ± 0.2% | 992.0 ± 0.9% | 734.6 ± 1.2% | 10.656 | 14.461 | 39.001 | 15.804 | 21.341 |
| hex: silesia/sao | 524290 | 15663.8 ± 0.2% | 1471.2 ± 0.3% | 1083.9 ± 0.3% | 333.2 ± 0.3% | 993.1 ± 0.2% | 736.1 ± 1.1% | 10.647 | 14.451 | 47.014 | 15.773 | 21.281 |
| hex: silesia/webster | 524290 | 15629.8 ± 0.3% | 1472.0 ± 0.1% | 1087.5 ± 0.2% | 477.3 ± 0.9% | 990.5 ± 0.5% | 736.8 ± 0.3% | 10.618 | 14.372 | 32.746 | 15.779 | 21.214 |
| hex: silesia/x-ray | 524290 | 15647.2 ± 0.2% | 1481.7 ± 0.2% | 1090.5 ± 0.3% | 447.3 ± 1.0% | 994.0 ± 0.2% | 735.0 ± 0.5% | 10.561 | 14.348 | 34.981 | 15.742 | 21.290 |
| hex: silesia/xml | 524290 | 15618.4 ± 0.5% | 1474.9 ± 0.3% | 1087.9 ± 0.4% | 617.6 ± 0.7% | 991.6 ± 0.4% | 736.4 ± 0.8% | 10.589 | 14.357 | 25.287 | 15.751 | 21.208 |
| hex: canterbury/alice29.txt | 304180 | 15685.1 ± 0.1% | 1473.1 ± 0.6% | 1090.8 ± 0.5% | 503.6 ± 0.5% | 993.4 ± 1.0% | 737.0 ± 0.8% | 10.648 | 14.379 | 31.143 | 15.790 | 21.283 |
| hex: canterbury/asyoulik.txt | 250360 | 15718.7 ± 0.1% | 1479.5 ± 0.5% | 1092.9 ± 0.5% | 497.8 ± 0.5% | 993.9 ± 0.2% | 740.1 ± 0.5% | 10.624 | 14.383 | 31.577 | 15.816 | 21.239 |
| hex: canterbury/cp.html | 49208 | 15639.0 ± 0.1% | 1473.6 ± 0.8% | 1098.8 ± 0.2% | 527.1 ± 0.7% | 1002.9 ± 0.5% | 742.8 ± 0.2% | 10.613 | 14.232 | 29.670 | 15.593 | 21.053 |
| hex: canterbury/fields.c | 22302 | 15454.2 ± 0.0% | 1412.1 ± 0.8% | 1064.3 ± 0.4% | 611.6 ± 5.6% | 986.2 ± 0.3% | 737.2 ± 0.2% | 10.944 | 14.521 | 25.269 | 15.670 | 20.963 |
| hex: canterbury/grammar.lsp | 7444 | 14998.8 ± 0.0% | 1507.8 ± 0.3% | 1093.8 ± 0.4% | 662.5 ± 4.6% | 990.3 ± 0.4% | 726.1 ± 0.1% | 9.948 | 13.713 | 22.640 | 15.146 | 20.658 |
| hex: canterbury/kennedy.xls | 524290 | 15667.2 ± 0.1% | 1475.9 ± 0.4% | 1091.2 ± 0.6% | 664.2 ± 1.9% | 990.8 ± 0.4% | 735.1 ± 0.5% | 10.615 | 14.358 | 23.587 | 15.812 | 21.313 |
| hex: canterbury/lcet10.txt | 524290 | 15654.8 ± 0.2% | 1470.8 ± 0.2% | 1086.9 ± 0.3% | 498.8 ± 4.3% | 989.8 ± 0.5% | 734.7 ± 0.7% | 10.643 | 14.403 | 31.385 | 15.815 | 21.306 |
| hex: canterbury/plrabn12.txt | 524290 | 15614.9 ± 0.4% | 1469.1 ± 0.1% | 1087.3 ± 0.4% | 493.5 ± 1.6% | 987.4 ± 0.4% | 736.2 ± 0.4% | 10.629 | 14.362 | 31.641 | 15.814 | 21.211 |
| hex: canterbury/ptt5 | 524290 | 15648.8 ± 0.1% | 1488.4 ± 0.2% | 1094.0 ± 0.5% | 554.8 ± 0.4% | 992.2 ± 0.3% | 736.3 ± 0.3% | 10.514 | 14.304 | 28.204 | 15.772 | 21.253 |
| hex: canterbury/sum | 76482 | 15653.8 ± 0.1% | 1495.2 ± 0.8% | 1103.8 ± 0.3% | 599.7 ± 0.7% | 998.4 ± 0.2% | 744.5 ± 0.2% | 10.470 | 14.181 | 26.104 | 15.679 | 21.027 |
| hex: canterbury/xargs.1 | 8456 | 15053.3 ± 0.1% | 1460.2 ± 2.5% | 1092.0 ± 0.8% | 663.7 ± 5.0% | 997.7 ± 0.4% | 728.2 ± 0.8% | 10.309 | 13.785 | 22.680 | 15.089 | 20.671 |
| hex: canterbury-large/E.coli | 524290 | 15650.8 ± 0.3% | 1479.6 ± 0.5% | 1090.5 ± 0.6% | 672.1 ± 0.4% | 993.8 ± 0.5% | 735.4 ± 0.4% | 10.578 | 14.352 | 23.287 | 15.748 | 21.282 |
| hex: canterbury-large/bible.txt | 524290 | 15667.3 ± 0.2% | 1473.0 ± 0.2% | 1085.4 ± 1.9% | 514.6 ± 0.8% | 990.9 ± 0.9% | 735.2 ± 0.6% | 10.637 | 14.434 | 30.444 | 15.812 | 21.311 |
| hex: canterbury-large/world192.txt | 524290 | 15618.5 ± 0.3% | 1471.8 ± 0.2% | 1085.6 ± 0.8% | 501.9 ± 1.4% | 988.7 ± 0.4% | 734.2 ± 0.4% | 10.612 | 14.386 | 31.119 | 15.797 | 21.272 |
| hex: http/html-1kx1024 | 2099200 | 13868.9 ± 0.9% | 1454.1 ± 0.2% | 1061.9 ± 0.3% | 502.1 ± 0.3% | 982.6 ± 0.3% | 692.8 ± 0.2% | 9.538 | 13.060 | 27.622 | 14.115 | 20.019 |
| hex: http/html-16kx64 | 2097280 | 15259.9 ± 0.4% | 1446.2 ± 0.2% | 1074.6 ± 0.4% | 508.1 ± 0.5% | 996.0 ± 0.1% | 734.9 ± 0.2% | 10.552 | 14.201 | 30.033 | 15.321 | 20.763 |
| hex: http/html-1m | 524290 | 15653.6 ± 0.3% | 1473.7 ± 0.4% | 1086.0 ± 0.7% | 503.0 ± 0.5% | 988.6 ± 0.4% | 734.7 ± 0.5% | 10.622 | 14.414 | 31.119 | 15.835 | 21.307 |
| hex: http/json-1kx1024 | 2099200 | 13865.5 ± 0.5% | 1463.4 ± 0.1% | 1066.8 ± 0.1% | 608.9 ± 1.4% | 985.7 ± 0.2% | 692.3 ± 0.3% | 9.475 | 12.997 | 22.771 | 14.066 | 20.028 |
| hex: http/json-16kx64 | 2097280 | 15281.4 ± 0.6% | 1446.6 ± 0.1% | 1077.0 ± 0.3% | 616.1 ± 0.6% | 996.3 ± 0.1% | 735.6 ± 0.1% | 10.564 | 14.189 | 24.805 | 15.339 | 20.773 |
| hex: http/json-1m | 524290 | 15701.7 ± 0.3% | 1478.5 ± 0.2% | 1088.6 ± 0.3% | 633.3 ± 0.4% | 993.3 ± 0.3% | 737.1 ± 0.4% | 10.620 | 14.423 | 24.795 | 15.808 | 21.301 |
| hex: http/js-1kx1024 | 2099200 | 13968.3 ± 0.8% | 1457.2 ± 0.3% | 1063.6 ± 0.2% | 500.0 ± 0.3% | 984.4 ± 0.3% | 693.0 ± 0.1% | 9.585 | 13.133 | 27.938 | 14.190 | 20.155 |
| hex: http/js-16kx64 | 2097280 | 15311.0 ± 1.5% | 1445.0 ± 0.3% | 1076.2 ± 0.2% | 505.8 ± 0.3% | 996.9 ± 0.4% | 735.2 ± 0.2% | 10.596 | 14.226 | 30.272 | 15.359 | 20.826 |
| hex: http/js-1m | 524290 | 15681.5 ± 0.8% | 1472.9 ± 0.2% | 1085.6 ± 0.4% | 513.5 ± 0.7% | 992.1 ± 0.7% | 735.9 ± 0.3% | 10.647 | 14.445 | 30.541 | 15.806 | 21.309 |
| hex: http/css-1kx1024 | 2099200 | 13865.1 ± 0.7% | 1455.7 ± 0.2% | 1063.0 ± 0.2% | 531.3 ± 0.5% | 983.3 ± 0.1% | 692.6 ± 0.2% | 9.525 | 13.044 | 26.097 | 14.101 | 20.019 |
| hex: http/css-16kx64 | 2097280 | 15227.6 ± 0.5% | 1446.6 ± 0.1% | 1076.3 ± 0.3% | 541.9 ± 0.9% | 996.0 ± 0.6% | 734.6 ± 0.3% | 10.526 | 14.148 | 28.100 | 15.289 | 20.729 |
| hex: http/css-1m | 524290 | 15670.9 ± 0.4% | 1474.0 ± 0.3% | 1086.7 ± 0.5% | 529.4 ± 0.5% | 987.2 ± 0.9% | 735.2 ± 0.5% | 10.631 | 14.421 | 29.604 | 15.874 | 21.316 |
| hex: shuffled/dickens-1m | 524290 | 15716.7 ± 1.8% | 1467.2 ± 0.6% | 1083.3 ± 0.5% | 497.9 ± 0.7% | 985.9 ± 0.5% | 735.9 ± 0.6% | 10.712 | 14.508 | 31.565 | 15.942 | 21.358 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 936.5 ± 0.2% | 933.8 ± 0.8% | 1026.8 ± 0.3% | 300.8 ± 0.8% | 664.8 ± 0.4% | 310.1 ± 1.6% | 1.003 | 0.912 | 3.113 | 1.409 | 3.020 |
| qlog records, JSON text sequence | 1467503 | 787.2 ± 0.7% | 818.3 ± 0.2% | 801.8 ± 1.4% | 244.1 ± 0.7% | 700.6 ± 0.9% | 252.9 ± 1.2% | 0.962 | 0.982 | 3.224 | 1.124 | 3.112 |
| string: silesia/dickens | 172528 | 5047.2 ± 0.2% | 1877.7 ± 0.2% | 2654.6 ± 0.5% | 361.7 ± 1.1% | 2860.2 ± 0.3% | 554.0 ± 2.0% | 2.688 | 1.901 | 13.956 | 1.765 | 9.111 |
| string: silesia/nci | 1075110 | 4323.1 ± 0.4% | 2238.1 ± 0.8% | 3003.4 ± 0.3% | 544.1 ± 0.7% | 3020.8 ± 0.6% | 601.0 ± 1.6% | 1.932 | 1.439 | 7.946 | 1.431 | 7.193 |
| string: silesia/reymont | 1075159 | 2993.6 ± 4.2% | 1823.3 ± 1.0% | 2067.3 ± 0.6% | 375.1 ± 0.7% | 2144.5 ± 0.2% | 535.4 ± 1.5% | 1.642 | 1.448 | 7.980 | 1.396 | 5.591 |
| string: silesia/samba | 97582 | 3504.2 ± 0.4% | 2024.2 ± 0.2% | 2610.7 ± 1.8% | 328.9 ± 0.2% | 1507.2 ± 0.6% | 432.5 ± 2.3% | 1.731 | 1.342 | 10.656 | 2.325 | 8.102 |
| string: silesia/webster | 1098490 | 3683.1 ± 0.7% | 1519.1 ± 0.6% | 2018.6 ± 0.6% | 359.4 ± 0.3% | 2178.8 ± 1.0% | 493.1 ± 1.1% | 2.424 | 1.825 | 10.247 | 1.690 | 7.470 |
| string: silesia/xml | 1090118 | 4806.7 ± 0.9% | 2358.4 ± 0.8% | 2536.5 ± 0.4% | 456.0 ± 0.9% | 2862.7 ± 1.3% | 564.2 ± 1.6% | 2.038 | 1.895 | 10.540 | 1.679 | 8.519 |
| string: canterbury/alice29.txt | 159425 | 4343.8 ± 1.2% | 1600.5 ± 0.5% | 2457.8 ± 0.4% | 342.4 ± 0.3% | 2500.8 ± 0.5% | 506.8 ± 1.1% | 2.714 | 1.767 | 12.687 | 1.737 | 8.571 |
| string: canterbury/asyoulik.txt | 132198 | 3501.7 ± 0.9% | 1459.8 ± 0.3% | 2243.9 ± 0.9% | 335.8 ± 0.3% | 2084.1 ± 0.1% | 465.7 ± 1.5% | 2.399 | 1.561 | 10.429 | 1.680 | 7.519 |
| string: canterbury/lcet10.txt | 441884 | 5113.5 ± 0.4% | 1850.3 ± 0.2% | 2342.5 ± 0.8% | 391.0 ± 0.7% | 2851.9 ± 0.7% | 534.3 ± 0.7% | 2.764 | 2.183 | 13.077 | 1.793 | 9.570 |
| string: canterbury/plrabn12.txt | 503330 | 4117.2 ± 0.7% | 1739.5 ± 0.3% | 2061.1 ± 0.4% | 360.0 ± 0.9% | 2490.7 ± 0.6% | 496.3 ± 0.9% | 2.367 | 1.998 | 11.437 | 1.653 | 8.296 |
| string: canterbury-large/E.coli | 1048578 | 11908.7 ± 0.7% | 3612.3 ± 0.3% | 3267.3 ± 0.3% | 926.7 ± 1.1% | 6021.3 ± 0.5% | 749.9 ± 1.5% | 3.297 | 3.645 | 12.851 | 1.978 | 15.881 |
| string: canterbury-large/bible.txt | 1055886 | 6908.8 ± 1.3% | 2941.5 ± 0.2% | 2833.0 ± 1.0% | 420.2 ± 1.9% | 3766.6 ± 1.6% | 613.7 ± 1.1% | 2.349 | 2.439 | 16.440 | 1.834 | 11.258 |
| string: canterbury-large/world192.txt | 1103121 | 3397.9 ± 0.2% | 1481.7 ± 0.4% | 2009.9 ± 0.4% | 352.5 ± 0.6% | 2122.9 ± 1.4% | 496.0 ± 1.3% | 2.293 | 1.691 | 9.638 | 1.601 | 6.851 |
| string: http/html-1m | 1058582 | 6221.5 ± 0.7% | 2742.8 ± 0.4% | 2703.2 ± 0.2% | 441.9 ± 0.1% | 3484.8 ± 0.6% | 597.2 ± 2.1% | 2.268 | 2.301 | 14.079 | 1.785 | 10.417 |
| string: http/json-1m | 1190272 | 2556.2 ± 0.6% | 878.4 ± 0.3% | 2254.8 ± 0.4% | 391.1 ± 0.6% | 1061.5 ± 0.5% | 443.1 ± 0.8% | 2.910 | 1.134 | 6.535 | 2.408 | 5.769 |
| string: http/js-1m | 1144362 | 2289.2 ± 0.2% | 1029.5 ± 0.3% | 1638.2 ± 0.5% | 320.7 ± 0.2% | 1522.4 ± 0.5% | 418.5 ± 1.1% | 2.224 | 1.397 | 7.139 | 1.504 | 5.471 |
| string: http/css-1m | 1097820 | 2661.3 ± 0.3% | 1680.0 ± 0.4% | 2234.3 ± 1.0% | 406.0 ± 0.5% | 1951.1 ± 1.2% | 491.9 ± 0.9% | 1.584 | 1.191 | 6.555 | 1.364 | 5.410 |
| string: dickens as Cyrillic and CJK | 1883069 | 3081.0 ± 0.4% | 1687.6 ± 0.5% | 892.9 ± 0.4% | 350.3 ± 0.2% | 667.3 ± 0.7% | 155.7 ± 2.9% | 1.826 | 3.450 | 8.796 | 4.617 | 19.784 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.7 ± 0.4% | 979.4 ± 0.2% | 1202.3 ± 0.7% | 216.3 ± 0.2% | 469.8 ± 0.4% | 248.6 ± 4.0% | 1.359 | 1.107 | 6.152 | 2.832 | 5.353 |
| hex: silesia/dickens | 524290 | 12002.1 ± 0.3% | 3620.9 ± 0.2% | 3296.8 ± 0.5% | 507.2 ± 1.9% | 6129.3 ± 0.6% | 783.1 ± 3.3% | 3.315 | 3.641 | 23.665 | 1.958 | 15.326 |
| hex: silesia/mozilla | 524290 | 12019.7 ± 0.3% | 3612.1 ± 0.2% | 3304.3 ± 0.4% | 448.2 ± 1.1% | 6085.2 ± 0.9% | 783.9 ± 0.3% | 3.328 | 3.638 | 26.819 | 1.975 | 15.333 |
| hex: silesia/mr | 524290 | 11993.4 ± 0.3% | 3614.3 ± 0.2% | 3301.2 ± 0.2% | 568.1 ± 1.8% | 6086.3 ± 0.9% | 782.5 ± 0.1% | 3.318 | 3.633 | 21.111 | 1.971 | 15.327 |
| hex: silesia/nci | 524290 | 12013.8 ± 0.1% | 3617.4 ± 0.6% | 3297.9 ± 0.2% | 617.7 ± 1.1% | 6151.2 ± 1.2% | 781.1 ± 0.3% | 3.321 | 3.643 | 19.450 | 1.953 | 15.380 |
| hex: silesia/ooffice | 524290 | 11972.4 ± 0.5% | 3615.7 ± 0.3% | 3302.8 ± 0.3% | 405.6 ± 3.0% | 6082.4 ± 1.0% | 782.4 ± 2.7% | 3.311 | 3.625 | 29.516 | 1.968 | 15.303 |
| hex: silesia/osdb | 524290 | 12000.5 ± 0.1% | 3615.4 ± 0.3% | 3306.5 ± 0.2% | 481.8 ± 0.6% | 6121.5 ± 0.7% | 783.1 ± 0.3% | 3.319 | 3.629 | 24.909 | 1.960 | 15.325 |
| hex: silesia/reymont | 524290 | 11969.8 ± 0.1% | 3613.4 ± 0.3% | 3295.3 ± 0.2% | 520.2 ± 1.4% | 6021.1 ± 2.7% | 784.2 ± 0.3% | 3.313 | 3.632 | 23.009 | 1.988 | 15.265 |
| hex: silesia/samba | 524290 | 12017.0 ± 0.0% | 3614.1 ± 0.2% | 3311.0 ± 0.1% | 409.7 ± 0.4% | 6143.3 ± 1.0% | 784.8 ± 0.7% | 3.325 | 3.629 | 29.334 | 1.956 | 15.312 |
| hex: silesia/sao | 524290 | 11993.6 ± 0.2% | 3616.4 ± 0.3% | 3295.2 ± 0.4% | 344.1 ± 0.6% | 6120.1 ± 0.9% | 782.8 ± 0.3% | 3.316 | 3.640 | 34.858 | 1.960 | 15.321 |
| hex: silesia/webster | 524290 | 12006.9 ± 0.3% | 3616.5 ± 0.4% | 3306.2 ± 0.4% | 480.2 ± 0.5% | 6140.3 ± 1.9% | 782.9 ± 0.3% | 3.320 | 3.632 | 25.006 | 1.955 | 15.337 |
| hex: silesia/x-ray | 524290 | 11986.1 ± 0.2% | 3618.4 ± 0.1% | 3297.4 ± 0.2% | 486.3 ± 0.4% | 6153.8 ± 1.6% | 782.4 ± 0.5% | 3.313 | 3.635 | 24.649 | 1.948 | 15.320 |
| hex: silesia/xml | 524290 | 12020.5 ± 0.1% | 3615.9 ± 0.3% | 3302.9 ± 0.3% | 531.4 ± 0.5% | 6127.8 ± 1.4% | 784.5 ± 0.6% | 3.324 | 3.639 | 22.622 | 1.962 | 15.323 |
| hex: canterbury/alice29.txt | 304180 | 12008.9 ± 0.1% | 3638.1 ± 0.1% | 3349.5 ± 0.1% | 522.1 ± 0.2% | 6119.4 ± 1.6% | 782.8 ± 0.3% | 3.301 | 3.585 | 23.000 | 1.962 | 15.341 |
| hex: canterbury/asyoulik.txt | 250360 | 12001.6 ± 0.3% | 3640.6 ± 0.1% | 3373.0 ± 0.2% | 515.8 ± 0.2% | 6176.5 ± 2.1% | 781.7 ± 0.6% | 3.297 | 3.558 | 23.269 | 1.943 | 15.352 |
| hex: canterbury/cp.html | 49208 | 11920.8 ± 0.1% | 3638.6 ± 0.0% | 3283.8 ± 0.4% | 482.0 ± 1.4% | 6262.9 ± 0.3% | 760.6 ± 2.0% | 3.276 | 3.630 | 24.733 | 1.903 | 15.673 |
| hex: canterbury/fields.c | 22302 | 11777.3 ± 0.1% | 3629.6 ± 0.1% | 3368.1 ± 0.4% | 511.6 ± 0.7% | 6248.8 ± 0.6% | 754.2 ± 2.3% | 3.245 | 3.497 | 23.020 | 1.885 | 15.616 |
| hex: canterbury/grammar.lsp | 7444 | 11243.6 ± 0.1% | 3601.4 ± 0.0% | 3369.1 ± 0.3% | 554.2 ± 2.1% | 6183.3 ± 0.4% | 715.5 ± 2.0% | 3.122 | 3.337 | 20.287 | 1.818 | 15.714 |
| hex: canterbury/kennedy.xls | 524290 | 11989.1 ± 0.3% | 3610.3 ± 0.3% | 3301.1 ± 0.2% | 663.4 ± 2.4% | 6047.4 ± 1.9% | 776.7 ± 6.7% | 3.321 | 3.632 | 18.071 | 1.983 | 15.436 |
| hex: canterbury/lcet10.txt | 524290 | 12011.6 ± 0.1% | 3616.6 ± 0.5% | 3301.1 ± 0.2% | 516.5 ± 2.6% | 6091.1 ± 1.2% | 784.3 ± 0.9% | 3.321 | 3.639 | 23.257 | 1.972 | 15.316 |
| hex: canterbury/plrabn12.txt | 524290 | 11998.9 ± 0.1% | 3621.7 ± 0.6% | 3305.2 ± 0.2% | 516.6 ± 0.4% | 6136.6 ± 2.0% | 782.7 ± 0.8% | 3.313 | 3.630 | 23.228 | 1.955 | 15.330 |
| hex: canterbury/ptt5 | 524290 | 12004.2 ± 0.3% | 3616.5 ± 0.2% | 3293.7 ± 0.1% | 565.8 ± 0.4% | 6144.4 ± 1.6% | 785.0 ± 1.0% | 3.319 | 3.645 | 21.215 | 1.954 | 15.293 |
| hex: canterbury/sum | 76482 | 11907.4 ± 0.1% | 3634.6 ± 0.0% | 3354.5 ± 0.3% | 518.1 ± 2.5% | 6165.7 ± 2.6% | 772.6 ± 1.1% | 3.276 | 3.550 | 22.985 | 1.931 | 15.412 |
| hex: canterbury/xargs.1 | 8456 | 11331.7 ± 0.1% | 3602.6 ± 0.0% | 3374.9 ± 0.2% | 496.9 ± 3.0% | 6148.6 ± 0.4% | 757.7 ± 0.8% | 3.145 | 3.358 | 22.806 | 1.843 | 14.955 |
| hex: canterbury-large/E.coli | 524290 | 11994.0 ± 0.2% | 3618.3 ± 0.2% | 3295.1 ± 0.3% | 689.0 ± 0.1% | 6155.0 ± 0.6% | 775.4 ± 7.1% | 3.315 | 3.640 | 17.408 | 1.949 | 15.468 |
| hex: canterbury-large/bible.txt | 524290 | 12007.1 ± 0.1% | 3617.3 ± 0.4% | 3304.7 ± 0.2% | 529.7 ± 2.2% | 6129.3 ± 0.4% | 772.0 ± 1.1% | 3.319 | 3.633 | 22.666 | 1.959 | 15.553 |
| hex: canterbury-large/world192.txt | 524290 | 12013.3 ± 0.2% | 3619.0 ± 0.2% | 3299.1 ± 0.2% | 507.7 ± 1.7% | 6142.1 ± 1.5% | 772.8 ± 0.5% | 3.320 | 3.641 | 23.664 | 1.956 | 15.545 |
| hex: http/html-1kx1024 | 2099200 | 8939.7 ± 1.6% | 3463.6 ± 0.4% | 2905.8 ± 0.4% | 473.8 ± 0.4% | 5156.5 ± 1.0% | 648.5 ± 3.7% | 2.581 | 3.076 | 18.869 | 1.734 | 13.785 |
| hex: http/html-16kx64 | 2097280 | 11777.1 ± 0.2% | 3610.8 ± 0.2% | 3274.2 ± 0.2% | 477.8 ± 1.3% | 6034.0 ± 0.5% | 754.7 ± 2.2% | 3.262 | 3.597 | 24.648 | 1.952 | 15.605 |
| hex: http/html-1m | 524290 | 12015.7 ± 0.3% | 3615.9 ± 0.3% | 3316.9 ± 0.7% | 505.1 ± 1.4% | 6096.8 ± 1.0% | 758.7 ± 4.9% | 3.323 | 3.623 | 23.788 | 1.971 | 15.837 |
| hex: http/json-1kx1024 | 2099200 | 8926.6 ± 2.4% | 3458.8 ± 0.2% | 2898.7 ± 0.5% | 574.9 ± 0.4% | 5171.5 ± 1.5% | 646.7 ± 2.2% | 2.581 | 3.080 | 15.527 | 1.726 | 13.804 |
| hex: http/json-16kx64 | 2097280 | 11773.8 ± 0.3% | 3610.0 ± 0.2% | 3267.7 ± 0.2% | 574.1 ± 1.4% | 6033.6 ± 0.3% | 755.6 ± 1.5% | 3.261 | 3.603 | 20.509 | 1.951 | 15.582 |
| hex: http/json-1m | 524290 | 11998.4 ± 0.1% | 3620.2 ± 0.2% | 3304.4 ± 0.4% | 597.2 ± 2.3% | 6096.4 ± 0.8% | 767.5 ± 2.0% | 3.314 | 3.631 | 20.092 | 1.968 | 15.634 |
| hex: http/js-1kx1024 | 2099200 | 8849.6 ± 3.9% | 3464.8 ± 0.2% | 2904.7 ± 0.4% | 480.8 ± 1.0% | 5186.9 ± 1.6% | 654.4 ± 4.8% | 2.554 | 3.047 | 18.408 | 1.706 | 13.523 |
| hex: http/js-16kx64 | 2097280 | 11775.6 ± 0.2% | 3610.0 ± 0.2% | 3268.8 ± 0.2% | 482.7 ± 0.9% | 6031.4 ± 0.5% | 754.1 ± 2.5% | 3.262 | 3.602 | 24.397 | 1.952 | 15.616 |
| hex: http/js-1m | 524290 | 11984.1 ± 0.2% | 3618.8 ± 3.0% | 3302.4 ± 0.3% | 511.1 ± 1.7% | 6095.8 ± 1.2% | 760.4 ± 1.3% | 3.312 | 3.629 | 23.449 | 1.966 | 15.760 |
| hex: http/css-1kx1024 | 2099200 | 8941.6 ± 2.0% | 3464.8 ± 0.1% | 2892.6 ± 0.7% | 488.1 ± 1.1% | 5154.9 ± 0.7% | 657.4 ± 1.5% | 2.581 | 3.091 | 18.318 | 1.735 | 13.601 |
| hex: http/css-16kx64 | 2097280 | 11781.0 ± 0.3% | 3610.9 ± 0.1% | 3273.3 ± 0.2% | 495.7 ± 0.6% | 6053.0 ± 0.9% | 764.3 ± 1.5% | 3.263 | 3.599 | 23.769 | 1.946 | 15.414 |
| hex: http/css-1m | 524290 | 11971.6 ± 0.1% | 3605.8 ± 0.5% | 3302.3 ± 0.2% | 497.0 ± 1.9% | 6091.1 ± 0.5% | 769.4 ± 2.3% | 3.320 | 3.625 | 24.086 | 1.965 | 15.560 |
| hex: shuffled/dickens-1m | 524290 | 11985.6 ± 0.3% | 3613.6 ± 0.4% | 3296.9 ± 0.2% | 512.5 ± 0.4% | 6076.7 ± 1.1% | 771.2 ± 1.1% | 3.317 | 3.635 | 23.388 | 1.972 | 15.542 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1014.4 ± 0.4% | 933.8 ± 0.8% | 1026.8 ± 0.3% | 300.8 ± 0.8% | 664.8 ± 0.4% | 310.1 ± 1.6% | 1.086 | 0.988 | 3.372 | 1.526 | 3.271 |
| qlog records, JSON text sequence | 1467503 | 841.6 ± 0.4% | 818.3 ± 0.2% | 801.8 ± 1.4% | 244.1 ± 0.7% | 700.6 ± 0.9% | 252.9 ± 1.2% | 1.029 | 1.050 | 3.448 | 1.201 | 3.327 |
| string: silesia/dickens | 172528 | 5049.4 ± 0.2% | 1877.7 ± 0.2% | 2654.6 ± 0.5% | 361.7 ± 1.1% | 2860.2 ± 0.3% | 554.0 ± 2.0% | 2.689 | 1.902 | 13.962 | 1.765 | 9.115 |
| string: silesia/nci | 1075110 | 4316.2 ± 0.4% | 2238.1 ± 0.8% | 3003.4 ± 0.3% | 544.1 ± 0.7% | 3020.8 ± 0.6% | 601.0 ± 1.6% | 1.929 | 1.437 | 7.933 | 1.429 | 7.182 |
| string: silesia/reymont | 1075159 | 2986.8 ± 4.2% | 1823.3 ± 1.0% | 2067.3 ± 0.6% | 375.1 ± 0.7% | 2144.5 ± 0.2% | 535.4 ± 1.5% | 1.638 | 1.445 | 7.962 | 1.393 | 5.579 |
| string: silesia/samba | 97582 | 3513.8 ± 0.5% | 2024.2 ± 0.2% | 2610.7 ± 1.8% | 328.9 ± 0.2% | 1507.2 ± 0.6% | 432.5 ± 2.3% | 1.736 | 1.346 | 10.685 | 2.331 | 8.124 |
| string: silesia/webster | 1098490 | 3679.1 ± 0.7% | 1519.1 ± 0.6% | 2018.6 ± 0.6% | 359.4 ± 0.3% | 2178.8 ± 1.0% | 493.1 ± 1.1% | 2.422 | 1.823 | 10.236 | 1.689 | 7.462 |
| string: silesia/xml | 1090118 | 4824.5 ± 0.5% | 2358.4 ± 0.8% | 2536.5 ± 0.4% | 456.0 ± 0.9% | 2862.7 ± 1.3% | 564.2 ± 1.6% | 2.046 | 1.902 | 10.579 | 1.685 | 8.550 |
| string: canterbury/alice29.txt | 159425 | 4352.9 ± 1.0% | 1600.5 ± 0.5% | 2457.8 ± 0.4% | 342.4 ± 0.3% | 2500.8 ± 0.5% | 506.8 ± 1.1% | 2.720 | 1.771 | 12.714 | 1.741 | 8.589 |
| string: canterbury/asyoulik.txt | 132198 | 3503.2 ± 0.8% | 1459.8 ± 0.3% | 2243.9 ± 0.9% | 335.8 ± 0.3% | 2084.1 ± 0.1% | 465.7 ± 1.5% | 2.400 | 1.561 | 10.434 | 1.681 | 7.522 |
| string: canterbury/lcet10.txt | 441884 | 5117.8 ± 0.5% | 1850.3 ± 0.2% | 2342.5 ± 0.8% | 391.0 ± 0.7% | 2851.9 ± 0.7% | 534.3 ± 0.7% | 2.766 | 2.185 | 13.088 | 1.795 | 9.578 |
| string: canterbury/plrabn12.txt | 503330 | 4118.8 ± 0.6% | 1739.5 ± 0.3% | 2061.1 ± 0.4% | 360.0 ± 0.9% | 2490.7 ± 0.6% | 496.3 ± 0.9% | 2.368 | 1.998 | 11.441 | 1.654 | 8.300 |
| string: canterbury-large/E.coli | 1048578 | 11944.0 ± 0.4% | 3612.3 ± 0.3% | 3267.3 ± 0.3% | 926.7 ± 1.1% | 6021.3 ± 0.5% | 749.9 ± 1.5% | 3.307 | 3.656 | 12.889 | 1.984 | 15.928 |
| string: canterbury-large/bible.txt | 1055886 | 6905.4 ± 1.3% | 2941.5 ± 0.2% | 2833.0 ± 1.0% | 420.2 ± 1.9% | 3766.6 ± 1.6% | 613.7 ± 1.1% | 2.348 | 2.438 | 16.432 | 1.833 | 11.253 |
| string: canterbury-large/world192.txt | 1103121 | 3397.3 ± 0.6% | 1481.7 ± 0.4% | 2009.9 ± 0.4% | 352.5 ± 0.6% | 2122.9 ± 1.4% | 496.0 ± 1.3% | 2.293 | 1.690 | 9.636 | 1.600 | 6.849 |
| string: http/html-1m | 1058582 | 6242.0 ± 1.0% | 2742.8 ± 0.4% | 2703.2 ± 0.2% | 441.9 ± 0.1% | 3484.8 ± 0.6% | 597.2 ± 2.1% | 2.276 | 2.309 | 14.125 | 1.791 | 10.451 |
| string: http/json-1m | 1190272 | 2558.3 ± 0.4% | 878.4 ± 0.3% | 2254.8 ± 0.4% | 391.1 ± 0.6% | 1061.5 ± 0.5% | 443.1 ± 0.8% | 2.912 | 1.135 | 6.540 | 2.410 | 5.773 |
| string: http/js-1m | 1144362 | 2289.6 ± 0.5% | 1029.5 ± 0.3% | 1638.2 ± 0.5% | 320.7 ± 0.2% | 1522.4 ± 0.5% | 418.5 ± 1.1% | 2.224 | 1.398 | 7.140 | 1.504 | 5.471 |
| string: http/css-1m | 1097820 | 2666.3 ± 0.2% | 1680.0 ± 0.4% | 2234.3 ± 1.0% | 406.0 ± 0.5% | 1951.1 ± 1.2% | 491.9 ± 0.9% | 1.587 | 1.193 | 6.567 | 1.367 | 5.420 |
| string: dickens as Cyrillic and CJK | 1883069 | 3077.7 ± 0.7% | 1687.6 ± 0.5% | 892.9 ± 0.4% | 350.3 ± 0.2% | 667.3 ± 0.7% | 155.7 ± 2.9% | 1.824 | 3.447 | 8.786 | 4.612 | 19.763 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.2 ± 0.3% | 979.4 ± 0.2% | 1202.3 ± 0.7% | 216.3 ± 0.2% | 469.8 ± 0.4% | 248.6 ± 4.0% | 1.358 | 1.106 | 6.150 | 2.831 | 5.351 |
| hex: silesia/dickens | 524290 | 12000.4 ± 0.2% | 3620.9 ± 0.2% | 3296.8 ± 0.5% | 507.2 ± 1.9% | 6129.3 ± 0.6% | 783.1 ± 3.3% | 3.314 | 3.640 | 23.662 | 1.958 | 15.324 |
| hex: silesia/mozilla | 524290 | 12012.4 ± 0.1% | 3612.1 ± 0.2% | 3304.3 ± 0.4% | 448.2 ± 1.1% | 6085.2 ± 0.9% | 783.9 ± 0.3% | 3.326 | 3.635 | 26.802 | 1.974 | 15.324 |
| hex: silesia/mr | 524290 | 12004.3 ± 0.3% | 3614.3 ± 0.2% | 3301.2 ± 0.2% | 568.1 ± 1.8% | 6086.3 ± 0.9% | 782.5 ± 0.1% | 3.321 | 3.636 | 21.130 | 1.972 | 15.341 |
| hex: silesia/nci | 524290 | 12025.1 ± 0.1% | 3617.4 ± 0.6% | 3297.9 ± 0.2% | 617.7 ± 1.1% | 6151.2 ± 1.2% | 781.1 ± 0.3% | 3.324 | 3.646 | 19.468 | 1.955 | 15.395 |
| hex: silesia/ooffice | 524290 | 11945.9 ± 0.0% | 3615.7 ± 0.3% | 3302.8 ± 0.3% | 405.6 ± 3.0% | 6082.4 ± 1.0% | 782.4 ± 2.7% | 3.304 | 3.617 | 29.451 | 1.964 | 15.269 |
| hex: silesia/osdb | 524290 | 12001.0 ± 0.2% | 3615.4 ± 0.3% | 3306.5 ± 0.2% | 481.8 ± 0.6% | 6121.5 ± 0.7% | 783.1 ± 0.3% | 3.319 | 3.630 | 24.910 | 1.960 | 15.326 |
| hex: silesia/reymont | 524290 | 11970.2 ± 0.2% | 3613.4 ± 0.3% | 3295.3 ± 0.2% | 520.2 ± 1.4% | 6021.1 ± 2.7% | 784.2 ± 0.3% | 3.313 | 3.633 | 23.010 | 1.988 | 15.265 |
| hex: silesia/samba | 524290 | 12021.2 ± 0.1% | 3614.1 ± 0.2% | 3311.0 ± 0.1% | 409.7 ± 0.4% | 6143.3 ± 1.0% | 784.8 ± 0.7% | 3.326 | 3.631 | 29.345 | 1.957 | 15.317 |
| hex: silesia/sao | 524290 | 11995.7 ± 0.1% | 3616.4 ± 0.3% | 3295.2 ± 0.4% | 344.1 ± 0.6% | 6120.1 ± 0.9% | 782.8 ± 0.3% | 3.317 | 3.640 | 34.865 | 1.960 | 15.323 |
| hex: silesia/webster | 524290 | 12017.6 ± 0.1% | 3616.5 ± 0.4% | 3306.2 ± 0.4% | 480.2 ± 0.5% | 6140.3 ± 1.9% | 782.9 ± 0.3% | 3.323 | 3.635 | 25.028 | 1.957 | 15.350 |
| hex: silesia/x-ray | 524290 | 12005.9 ± 0.1% | 3618.4 ± 0.1% | 3297.4 ± 0.2% | 486.3 ± 0.4% | 6153.8 ± 1.6% | 782.4 ± 0.5% | 3.318 | 3.641 | 24.689 | 1.951 | 15.345 |
| hex: silesia/xml | 524290 | 12025.9 ± 0.1% | 3615.9 ± 0.3% | 3302.9 ± 0.3% | 531.4 ± 0.5% | 6127.8 ± 1.4% | 784.5 ± 0.6% | 3.326 | 3.641 | 22.632 | 1.963 | 15.330 |
| hex: canterbury/alice29.txt | 304180 | 12013.9 ± 0.1% | 3638.1 ± 0.1% | 3349.5 ± 0.1% | 522.1 ± 0.2% | 6119.4 ± 1.6% | 782.8 ± 0.3% | 3.302 | 3.587 | 23.010 | 1.963 | 15.348 |
| hex: canterbury/asyoulik.txt | 250360 | 12009.9 ± 0.0% | 3640.6 ± 0.1% | 3373.0 ± 0.2% | 515.8 ± 0.2% | 6176.5 ± 2.1% | 781.7 ± 0.6% | 3.299 | 3.561 | 23.285 | 1.944 | 15.363 |
| hex: canterbury/cp.html | 49208 | 11923.5 ± 0.1% | 3638.6 ± 0.0% | 3283.8 ± 0.4% | 482.0 ± 1.4% | 6262.9 ± 0.3% | 760.6 ± 2.0% | 3.277 | 3.631 | 24.739 | 1.904 | 15.676 |
| hex: canterbury/fields.c | 22302 | 11780.1 ± 0.0% | 3629.6 ± 0.1% | 3368.1 ± 0.4% | 511.6 ± 0.7% | 6248.8 ± 0.6% | 754.2 ± 2.3% | 3.246 | 3.498 | 23.026 | 1.885 | 15.620 |
| hex: canterbury/grammar.lsp | 7444 | 11318.6 ± 0.0% | 3601.4 ± 0.0% | 3369.1 ± 0.3% | 554.2 ± 2.1% | 6183.3 ± 0.4% | 715.5 ± 2.0% | 3.143 | 3.360 | 20.422 | 1.831 | 15.819 |
| hex: canterbury/kennedy.xls | 524290 | 11981.7 ± 0.4% | 3610.3 ± 0.3% | 3301.1 ± 0.2% | 663.4 ± 2.4% | 6047.4 ± 1.9% | 776.7 ± 6.7% | 3.319 | 3.630 | 18.060 | 1.981 | 15.427 |
| hex: canterbury/lcet10.txt | 524290 | 12010.9 ± 0.2% | 3616.6 ± 0.5% | 3301.1 ± 0.2% | 516.5 ± 2.6% | 6091.1 ± 1.2% | 784.3 ± 0.9% | 3.321 | 3.638 | 23.255 | 1.972 | 15.315 |
| hex: canterbury/plrabn12.txt | 524290 | 12000.2 ± 0.3% | 3621.7 ± 0.6% | 3305.2 ± 0.2% | 516.6 ± 0.4% | 6136.6 ± 2.0% | 782.7 ± 0.8% | 3.313 | 3.631 | 23.230 | 1.956 | 15.332 |
| hex: canterbury/ptt5 | 524290 | 12019.3 ± 0.1% | 3616.5 ± 0.2% | 3293.7 ± 0.1% | 565.8 ± 0.4% | 6144.4 ± 1.6% | 785.0 ± 1.0% | 3.323 | 3.649 | 21.242 | 1.956 | 15.312 |
| hex: canterbury/sum | 76482 | 11911.5 ± 0.3% | 3634.6 ± 0.0% | 3354.5 ± 0.3% | 518.1 ± 2.5% | 6165.7 ± 2.6% | 772.6 ± 1.1% | 3.277 | 3.551 | 22.993 | 1.932 | 15.417 |
| hex: canterbury/xargs.1 | 8456 | 11339.3 ± 0.0% | 3602.6 ± 0.0% | 3374.9 ± 0.2% | 496.9 ± 3.0% | 6148.6 ± 0.4% | 757.7 ± 0.8% | 3.148 | 3.360 | 22.821 | 1.844 | 14.965 |
| hex: canterbury-large/E.coli | 524290 | 11960.1 ± 0.3% | 3618.3 ± 0.2% | 3295.1 ± 0.3% | 689.0 ± 0.1% | 6155.0 ± 0.6% | 775.4 ± 7.1% | 3.305 | 3.630 | 17.358 | 1.943 | 15.424 |
| hex: canterbury-large/bible.txt | 524290 | 11996.1 ± 0.3% | 3617.3 ± 0.4% | 3304.7 ± 0.2% | 529.7 ± 2.2% | 6129.3 ± 0.4% | 772.0 ± 1.1% | 3.316 | 3.630 | 22.646 | 1.957 | 15.538 |
| hex: canterbury-large/world192.txt | 524290 | 12016.3 ± 0.2% | 3619.0 ± 0.2% | 3299.1 ± 0.2% | 507.7 ± 1.7% | 6142.1 ± 1.5% | 772.8 ± 0.5% | 3.320 | 3.642 | 23.670 | 1.956 | 15.549 |
| hex: http/html-1kx1024 | 2099200 | 9024.0 ± 2.5% | 3463.6 ± 0.4% | 2905.8 ± 0.4% | 473.8 ± 0.4% | 5156.5 ± 1.0% | 648.5 ± 3.7% | 2.605 | 3.105 | 19.046 | 1.750 | 13.915 |
| hex: http/html-16kx64 | 2097280 | 11782.8 ± 0.1% | 3610.8 ± 0.2% | 3274.2 ± 0.2% | 477.8 ± 1.3% | 6034.0 ± 0.5% | 754.7 ± 2.2% | 3.263 | 3.599 | 24.660 | 1.953 | 15.613 |
| hex: http/html-1m | 524290 | 12016.0 ± 0.1% | 3615.9 ± 0.3% | 3316.9 ± 0.7% | 505.1 ± 1.4% | 6096.8 ± 1.0% | 758.7 ± 4.9% | 3.323 | 3.623 | 23.789 | 1.971 | 15.838 |
| hex: http/json-1kx1024 | 2099200 | 8953.5 ± 3.2% | 3458.8 ± 0.2% | 2898.7 ± 0.5% | 574.9 ± 0.4% | 5171.5 ± 1.5% | 646.7 ± 2.2% | 2.589 | 3.089 | 15.573 | 1.731 | 13.846 |
| hex: http/json-16kx64 | 2097280 | 11790.4 ± 0.1% | 3610.0 ± 0.2% | 3267.7 ± 0.2% | 574.1 ± 1.4% | 6033.6 ± 0.3% | 755.6 ± 1.5% | 3.266 | 3.608 | 20.537 | 1.954 | 15.604 |
| hex: http/json-1m | 524290 | 12000.4 ± 0.2% | 3620.2 ± 0.2% | 3304.4 ± 0.4% | 597.2 ± 2.3% | 6096.4 ± 0.8% | 767.5 ± 2.0% | 3.315 | 3.632 | 20.095 | 1.968 | 15.636 |
| hex: http/js-1kx1024 | 2099200 | 9024.5 ± 3.7% | 3464.8 ± 0.2% | 2904.7 ± 0.4% | 480.8 ± 1.0% | 5186.9 ± 1.6% | 654.4 ± 4.8% | 2.605 | 3.107 | 18.771 | 1.740 | 13.790 |
| hex: http/js-16kx64 | 2097280 | 11788.1 ± 0.4% | 3610.0 ± 0.2% | 3268.8 ± 0.2% | 482.7 ± 0.9% | 6031.4 ± 0.5% | 754.1 ± 2.5% | 3.265 | 3.606 | 24.423 | 1.954 | 15.632 |
| hex: http/js-1m | 524290 | 11947.4 ± 0.2% | 3618.8 ± 3.0% | 3302.4 ± 0.3% | 511.1 ± 1.7% | 6095.8 ± 1.2% | 760.4 ± 1.3% | 3.302 | 3.618 | 23.378 | 1.960 | 15.712 |
| hex: http/css-1kx1024 | 2099200 | 9044.4 ± 3.6% | 3464.8 ± 0.1% | 2892.6 ± 0.7% | 488.1 ± 1.1% | 5154.9 ± 0.7% | 657.4 ± 1.5% | 2.610 | 3.127 | 18.529 | 1.755 | 13.757 |
| hex: http/css-16kx64 | 2097280 | 11766.5 ± 0.1% | 3610.9 ± 0.1% | 3273.3 ± 0.2% | 495.7 ± 0.6% | 6053.0 ± 0.9% | 764.3 ± 1.5% | 3.259 | 3.595 | 23.739 | 1.944 | 15.395 |
| hex: http/css-1m | 524290 | 11974.1 ± 0.6% | 3605.8 ± 0.5% | 3302.3 ± 0.2% | 497.0 ± 1.9% | 6091.1 ± 0.5% | 769.4 ± 2.3% | 3.321 | 3.626 | 24.091 | 1.966 | 15.563 |
| hex: shuffled/dickens-1m | 524290 | 11964.9 ± 0.4% | 3613.6 ± 0.4% | 3296.9 ± 0.2% | 512.5 ± 0.4% | 6076.7 ± 1.1% | 771.2 ± 1.1% | 3.311 | 3.629 | 23.347 | 1.969 | 15.515 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1364.6 ± 0.4% | 1259.5 ± 0.4% | 1046.4 ± 0.2% | 410.7 ± 0.7% | 448.9 ± 0.3% | 416.6 ± 0.3% | 1.083 | 1.304 | 3.323 | 3.040 | 3.275 |
| qlog records, JSON text sequence | 1467503 | 1053.7 ± 0.2% | 1066.1 ± 0.2% | 789.3 ± 0.6% | 379.6 ± 0.8% | 473.1 ± 0.3% | 280.1 ± 0.3% | 0.988 | 1.335 | 2.776 | 2.227 | 3.762 |
| string: silesia/dickens | 172528 | 6904.2 ± 0.4% | 2821.5 ± 0.4% | 2929.9 ± 0.8% | 430.0 ± 0.7% | 1567.1 ± 0.3% | 1008.8 ± 0.1% | 2.447 | 2.356 | 16.056 | 4.406 | 6.844 |
| string: silesia/nci | 1075110 | 7331.5 ± 0.6% | 3432.8 ± 0.9% | 3097.2 ± 0.8% | 815.6 ± 0.7% | 1857.5 ± 0.1% | 1110.2 ± 0.4% | 2.136 | 2.367 | 8.989 | 3.947 | 6.604 |
| string: silesia/reymont | 1075159 | 3337.4 ± 1.6% | 1980.9 ± 1.7% | 2062.0 ± 0.3% | 452.0 ± 0.3% | 1512.1 ± 1.4% | 951.5 ± 0.7% | 1.685 | 1.619 | 7.384 | 2.207 | 3.507 |
| string: silesia/samba | 97582 | 4206.8 ± 0.5% | 2112.6 ± 1.2% | 3443.1 ± 0.6% | 354.8 ± 0.9% | 1435.3 ± 0.4% | 1055.8 ± 0.1% | 1.991 | 1.222 | 11.858 | 2.931 | 3.985 |
| string: silesia/webster | 1098490 | 4081.3 ± 0.4% | 1882.3 ± 0.5% | 2054.1 ± 0.8% | 441.5 ± 0.6% | 1388.3 ± 0.3% | 647.7 ± 1.0% | 2.168 | 1.987 | 9.244 | 2.940 | 6.301 |
| string: silesia/xml | 1090118 | 6153.8 ± 0.4% | 2879.3 ± 0.6% | 2645.9 ± 0.8% | 611.9 ± 0.8% | 1750.0 ± 0.5% | 923.4 ± 0.3% | 2.137 | 2.326 | 10.057 | 3.516 | 6.664 |
| string: canterbury/alice29.txt | 159425 | 6463.1 ± 0.4% | 2200.6 ± 0.3% | 2769.1 ± 1.0% | 404.9 ± 0.9% | 1464.1 ± 0.4% | 953.5 ± 0.2% | 2.937 | 2.334 | 15.962 | 4.414 | 6.778 |
| string: canterbury/asyoulik.txt | 132198 | 5643.5 ± 1.0% | 1715.9 ± 0.4% | 2360.3 ± 1.7% | 402.0 ± 0.7% | 1338.2 ± 0.3% | 886.0 ± 3.1% | 3.289 | 2.391 | 14.039 | 4.217 | 6.370 |
| string: canterbury/lcet10.txt | 441884 | 6265.3 ± 0.6% | 2572.4 ± 0.4% | 2493.1 ± 1.8% | 468.5 ± 0.9% | 1519.0 ± 0.6% | 987.8 ± 0.2% | 2.436 | 2.513 | 13.372 | 4.125 | 6.343 |
| string: canterbury/plrabn12.txt | 503330 | 5731.7 ± 0.2% | 2060.2 ± 0.3% | 2073.3 ± 0.4% | 425.0 ± 0.5% | 1408.9 ± 0.3% | 932.5 ± 0.1% | 2.782 | 2.765 | 13.485 | 4.068 | 6.146 |
| string: canterbury-large/E.coli | 1048578 | 19408.4 ± 1.1% | 9827.3 ± 1.0% | 3788.5 ± 0.5% | 1476.4 ± 0.6% | 2374.0 ± 0.3% | 1199.4 ± 0.9% | 1.975 | 5.123 | 13.146 | 8.176 | 16.182 |
| string: canterbury-large/bible.txt | 1055886 | 6808.0 ± 0.4% | 4177.3 ± 0.7% | 3030.0 ± 1.4% | 503.4 ± 0.4% | 1982.3 ± 0.4% | 1124.2 ± 0.4% | 1.630 | 2.247 | 13.525 | 3.434 | 6.056 |
| string: canterbury-large/world192.txt | 1103121 | 4065.8 ± 0.4% | 1659.6 ± 0.3% | 2008.5 ± 1.0% | 448.7 ± 0.4% | 1357.5 ± 0.2% | 910.8 ± 0.2% | 2.450 | 2.024 | 9.061 | 2.995 | 4.464 |
| string: http/html-1m | 1058582 | 6787.1 ± 0.5% | 4006.0 ± 0.2% | 3043.1 ± 0.5% | 499.7 ± 0.4% | 1925.7 ± 0.4% | 808.8 ± 0.3% | 1.694 | 2.230 | 13.581 | 3.524 | 8.392 |
| string: http/json-1m | 1190272 | 3174.4 ± 0.3% | 1355.2 ± 0.2% | 1557.4 ± 0.2% | 444.4 ± 0.5% | 962.7 ± 0.2% | 766.5 ± 0.5% | 2.342 | 2.038 | 7.143 | 3.298 | 4.142 |
| string: http/js-1m | 1144362 | 2784.8 ± 0.4% | 1182.8 ± 0.2% | 1621.6 ± 0.5% | 369.2 ± 0.3% | 1094.8 ± 0.2% | 761.0 ± 0.2% | 2.354 | 1.717 | 7.542 | 2.544 | 3.660 |
| string: http/css-1m | 1097820 | 4009.3 ± 0.7% | 1486.8 ± 0.4% | 2151.4 ± 1.2% | 494.2 ± 0.7% | 1370.0 ± 0.3% | 897.1 ± 0.6% | 2.697 | 1.864 | 8.112 | 2.927 | 4.469 |
| string: dickens as Cyrillic and CJK | 1883069 | 3076.5 ± 0.6% | 2342.7 ± 0.3% | 521.3 ± 0.3% | 306.7 ± 1.2% | 563.6 ± 0.9% | 336.6 ± 0.4% | 1.313 | 5.902 | 10.031 | 5.459 | 9.140 |
| hex: silesia/dickens | 524290 | 15683.6 ± 0.1% | 1469.4 ± 0.3% | 1082.1 ± 0.4% | 502.7 ± 0.4% | 990.4 ± 0.5% | 736.2 ± 0.5% | 10.674 | 14.494 | 31.202 | 15.836 | 21.303 |
| hex: silesia/mozilla | 524290 | 15689.1 ± 0.2% | 1478.1 ± 0.4% | 1089.9 ± 0.6% | 441.8 ± 0.4% | 989.1 ± 0.3% | 735.3 ± 0.4% | 10.615 | 14.394 | 35.508 | 15.862 | 21.338 |
| hex: silesia/mr | 524290 | 15649.7 ± 0.2% | 1486.0 ± 0.5% | 1095.2 ± 0.4% | 558.5 ± 3.5% | 997.6 ± 0.3% | 736.7 ± 0.3% | 10.532 | 14.290 | 28.023 | 15.687 | 21.244 |
| hex: silesia/nci | 524290 | 15658.3 ± 0.2% | 1478.4 ± 0.5% | 1092.2 ± 0.8% | 638.3 ± 2.9% | 991.0 ± 0.5% | 735.7 ± 0.5% | 10.591 | 14.336 | 24.532 | 15.800 | 21.284 |
| hex: silesia/ooffice | 524290 | 15651.5 ± 0.6% | 1472.6 ± 0.3% | 1085.1 ± 0.3% | 389.6 ± 0.4% | 991.0 ± 0.6% | 736.7 ± 0.1% | 10.629 | 14.424 | 40.173 | 15.794 | 21.245 |
| hex: silesia/osdb | 524290 | 15617.5 ± 0.2% | 1472.4 ± 0.2% | 1086.9 ± 0.5% | 468.6 ± 0.6% | 988.7 ± 0.2% | 735.3 ± 0.6% | 10.607 | 14.368 | 33.325 | 15.795 | 21.240 |
| hex: silesia/reymont | 524290 | 15683.1 ± 0.3% | 1469.9 ± 0.6% | 1087.4 ± 0.9% | 517.5 ± 1.2% | 990.9 ± 0.8% | 737.2 ± 0.1% | 10.669 | 14.423 | 30.308 | 15.827 | 21.273 |
| hex: silesia/samba | 524290 | 15653.7 ± 0.3% | 1471.1 ± 0.5% | 1084.1 ± 0.5% | 401.9 ± 0.2% | 992.0 ± 0.9% | 734.6 ± 1.2% | 10.641 | 14.440 | 38.944 | 15.781 | 21.310 |
| hex: silesia/sao | 524290 | 15687.6 ± 0.2% | 1471.2 ± 0.3% | 1083.9 ± 0.3% | 333.2 ± 0.3% | 993.1 ± 0.2% | 736.1 ± 1.1% | 10.663 | 14.473 | 47.085 | 15.797 | 21.313 |
| hex: silesia/webster | 524290 | 15608.4 ± 0.5% | 1472.0 ± 0.1% | 1087.5 ± 0.2% | 477.3 ± 0.9% | 990.5 ± 0.5% | 736.8 ± 0.3% | 10.603 | 14.352 | 32.701 | 15.758 | 21.185 |
| hex: silesia/x-ray | 524290 | 15635.5 ± 0.4% | 1481.7 ± 0.2% | 1090.5 ± 0.3% | 447.3 ± 1.0% | 994.0 ± 0.2% | 735.0 ± 0.5% | 10.553 | 14.338 | 34.955 | 15.730 | 21.274 |
| hex: silesia/xml | 524290 | 15600.3 ± 0.3% | 1474.9 ± 0.3% | 1087.9 ± 0.4% | 617.6 ± 0.7% | 991.6 ± 0.4% | 736.4 ± 0.8% | 10.577 | 14.340 | 25.258 | 15.733 | 21.183 |
| hex: canterbury/alice29.txt | 304180 | 15691.8 ± 0.2% | 1473.1 ± 0.6% | 1090.8 ± 0.5% | 503.6 ± 0.5% | 993.4 ± 1.0% | 737.0 ± 0.8% | 10.652 | 14.385 | 31.156 | 15.797 | 21.293 |
| hex: canterbury/asyoulik.txt | 250360 | 15722.3 ± 0.1% | 1479.5 ± 0.5% | 1092.9 ± 0.5% | 497.8 ± 0.5% | 993.9 ± 0.2% | 740.1 ± 0.5% | 10.626 | 14.386 | 31.584 | 15.819 | 21.244 |
| hex: canterbury/cp.html | 49208 | 15665.5 ± 0.1% | 1473.6 ± 0.8% | 1098.8 ± 0.2% | 527.1 ± 0.7% | 1002.9 ± 0.5% | 742.8 ± 0.2% | 10.631 | 14.257 | 29.720 | 15.619 | 21.089 |
| hex: canterbury/fields.c | 22302 | 15524.9 ± 0.1% | 1412.1 ± 0.8% | 1064.3 ± 0.4% | 611.6 ± 5.6% | 986.2 ± 0.3% | 737.2 ± 0.2% | 10.994 | 14.588 | 25.384 | 15.742 | 21.059 |
| hex: canterbury/grammar.lsp | 7444 | 15154.0 ± 0.1% | 1507.8 ± 0.3% | 1093.8 ± 0.4% | 662.5 ± 4.6% | 990.3 ± 0.4% | 726.1 ± 0.1% | 10.050 | 13.854 | 22.874 | 15.303 | 20.872 |
| hex: canterbury/kennedy.xls | 524290 | 15659.7 ± 0.2% | 1475.9 ± 0.4% | 1091.2 ± 0.6% | 664.2 ± 1.9% | 990.8 ± 0.4% | 735.1 ± 0.5% | 10.610 | 14.351 | 23.575 | 15.805 | 21.303 |
| hex: canterbury/lcet10.txt | 524290 | 15651.4 ± 0.1% | 1470.8 ± 0.2% | 1086.9 ± 0.3% | 498.8 ± 4.3% | 989.8 ± 0.5% | 734.7 ± 0.7% | 10.641 | 14.399 | 31.378 | 15.812 | 21.302 |
| hex: canterbury/plrabn12.txt | 524290 | 15598.9 ± 0.3% | 1469.1 ± 0.1% | 1087.3 ± 0.4% | 493.5 ± 1.6% | 987.4 ± 0.4% | 736.2 ± 0.4% | 10.618 | 14.347 | 31.609 | 15.798 | 21.189 |
| hex: canterbury/ptt5 | 524290 | 15659.0 ± 0.2% | 1488.4 ± 0.2% | 1094.0 ± 0.5% | 554.8 ± 0.4% | 992.2 ± 0.3% | 736.3 ± 0.3% | 10.521 | 14.313 | 28.222 | 15.783 | 21.267 |
| hex: canterbury/sum | 76482 | 15678.8 ± 0.2% | 1495.2 ± 0.8% | 1103.8 ± 0.3% | 599.7 ± 0.7% | 998.4 ± 0.2% | 744.5 ± 0.2% | 10.486 | 14.204 | 26.146 | 15.705 | 21.061 |
| hex: canterbury/xargs.1 | 8456 | 15203.3 ± 0.0% | 1460.2 ± 2.5% | 1092.0 ± 0.8% | 663.7 ± 5.0% | 997.7 ± 0.4% | 728.2 ± 0.8% | 10.412 | 13.922 | 22.906 | 15.239 | 20.876 |
| hex: canterbury-large/E.coli | 524290 | 15659.2 ± 0.3% | 1479.6 ± 0.5% | 1090.5 ± 0.6% | 672.1 ± 0.4% | 993.8 ± 0.5% | 735.4 ± 0.4% | 10.583 | 14.360 | 23.300 | 15.756 | 21.293 |
| hex: canterbury-large/bible.txt | 524290 | 15629.0 ± 0.3% | 1473.0 ± 0.2% | 1085.4 ± 1.9% | 514.6 ± 0.8% | 990.9 ± 0.9% | 735.2 ± 0.6% | 10.611 | 14.399 | 30.369 | 15.773 | 21.259 |
| hex: canterbury-large/world192.txt | 524290 | 15629.4 ± 0.3% | 1471.8 ± 0.2% | 1085.6 ± 0.8% | 501.9 ± 1.4% | 988.7 ± 0.4% | 734.2 ± 0.4% | 10.619 | 14.396 | 31.141 | 15.808 | 21.287 |
| hex: http/html-1kx1024 | 2099200 | 14246.3 ± 0.7% | 1454.1 ± 0.2% | 1061.9 ± 0.3% | 502.1 ± 0.3% | 982.6 ± 0.3% | 692.8 ± 0.2% | 9.797 | 13.415 | 28.374 | 14.499 | 20.564 |
| hex: http/html-16kx64 | 2097280 | 15371.9 ± 0.3% | 1446.2 ± 0.2% | 1074.6 ± 0.4% | 508.1 ± 0.5% | 996.0 ± 0.1% | 734.9 ± 0.2% | 10.629 | 14.305 | 30.253 | 15.434 | 20.916 |
| hex: http/html-1m | 524290 | 15627.0 ± 0.4% | 1473.7 ± 0.4% | 1086.0 ± 0.7% | 503.0 ± 0.5% | 988.6 ± 0.4% | 734.7 ± 0.5% | 10.604 | 14.390 | 31.066 | 15.808 | 21.271 |
| hex: http/json-1kx1024 | 2099200 | 14188.4 ± 0.5% | 1463.4 ± 0.1% | 1066.8 ± 0.1% | 608.9 ± 1.4% | 985.7 ± 0.2% | 692.3 ± 0.3% | 9.696 | 13.300 | 23.301 | 14.394 | 20.494 |
| hex: http/json-16kx64 | 2097280 | 15325.5 ± 0.5% | 1446.6 ± 0.1% | 1077.0 ± 0.3% | 616.1 ± 0.6% | 996.3 ± 0.1% | 735.6 ± 0.1% | 10.594 | 14.230 | 24.876 | 15.383 | 20.833 |
| hex: http/json-1m | 524290 | 15675.3 ± 1.8% | 1478.5 ± 0.2% | 1088.6 ± 0.3% | 633.3 ± 0.4% | 993.3 ± 0.3% | 737.1 ± 0.4% | 10.602 | 14.399 | 24.753 | 15.781 | 21.266 |
| hex: http/js-1kx1024 | 2099200 | 14168.2 ± 0.5% | 1457.2 ± 0.3% | 1063.6 ± 0.2% | 500.0 ± 0.3% | 984.4 ± 0.3% | 693.0 ± 0.1% | 9.723 | 13.321 | 28.338 | 14.393 | 20.443 |
| hex: http/js-16kx64 | 2097280 | 15360.5 ± 0.5% | 1445.0 ± 0.3% | 1076.2 ± 0.2% | 505.8 ± 0.3% | 996.9 ± 0.4% | 735.2 ± 0.2% | 10.630 | 14.273 | 30.370 | 15.409 | 20.893 |
| hex: http/js-1m | 524290 | 15685.5 ± 0.3% | 1472.9 ± 0.2% | 1085.6 ± 0.4% | 513.5 ± 0.7% | 992.1 ± 0.7% | 735.9 ± 0.3% | 10.649 | 14.449 | 30.549 | 15.810 | 21.314 |
| hex: http/css-1kx1024 | 2099200 | 14183.5 ± 0.4% | 1455.7 ± 0.2% | 1063.0 ± 0.2% | 531.3 ± 0.5% | 983.3 ± 0.1% | 692.6 ± 0.2% | 9.743 | 13.343 | 26.696 | 14.425 | 20.479 |
| hex: http/css-16kx64 | 2097280 | 15362.0 ± 0.8% | 1446.6 ± 0.1% | 1076.3 ± 0.3% | 541.9 ± 0.9% | 996.0 ± 0.6% | 734.6 ± 0.3% | 10.619 | 14.273 | 28.349 | 15.424 | 20.912 |
| hex: http/css-1m | 524290 | 15651.1 ± 0.5% | 1474.0 ± 0.3% | 1086.7 ± 0.5% | 529.4 ± 0.5% | 987.2 ± 0.9% | 735.2 ± 0.5% | 10.618 | 14.403 | 29.567 | 15.854 | 21.289 |
| hex: shuffled/dickens-1m | 524290 | 15704.8 ± 0.4% | 1467.2 ± 0.6% | 1083.3 ± 0.5% | 497.9 ± 0.7% | 985.9 ± 0.5% | 735.9 ± 0.6% | 10.704 | 14.497 | 31.541 | 15.930 | 21.342 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.912 of yyjson.
