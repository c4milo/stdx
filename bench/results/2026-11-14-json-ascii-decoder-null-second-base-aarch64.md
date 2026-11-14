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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43625781498 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1131.7 ± 0.4% | 0.522 | 0.963 | 0.994 | 0.995 | 0.458 | 1.000 | 1.002 | 0.387 | 0.829 | 0.897 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 850.9 ± 0.8% | 0.821 | 1.006 | 1.002 | 1.003 | 0.447 | 1.002 | 1.030 | 0.401 | 0.920 | 0.990 | 0.124 |
| string: silesia/dickens | 172528 | 5052.2 ± 0.3% | 0.033 | 0.781 | 1.003 | 1.003 | 0.196 | 1.015 | 1.003 | 0.196 | 1.000 | 1.001 | 0.032 |
| string: silesia/nci | 1075110 | 4295.1 ± 0.5% | 0.039 | 0.805 | 1.004 | 1.007 | 0.280 | 1.008 | 1.000 | 0.280 | 1.006 | 1.006 | 0.038 |
| string: silesia/reymont | 1075159 | 2925.0 ± 2.0% | 0.057 | 0.819 | 0.992 | 1.004 | 0.360 | 1.018 | 1.014 | 0.360 | 1.013 | 1.017 | 0.056 |
| string: silesia/samba | 97582 | 3504.4 ± 0.8% | 0.039 | 0.859 | 1.001 | 1.003 | 0.068 | 0.776 | 1.007 | 0.073 | 1.000 | 1.003 | 0.039 |
| string: silesia/webster | 1098490 | 3660.5 ± 0.6% | 0.044 | 0.844 | 1.001 | 1.004 | 0.203 | 1.018 | 1.010 | 0.203 | 1.003 | 1.007 | 0.044 |
| string: silesia/xml | 1090118 | 4784.3 ± 0.4% | 0.035 | 0.808 | 1.005 | 1.003 | 0.222 | 0.978 | 1.007 | 0.225 | 1.008 | 1.008 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4312.3 ± 0.6% | 0.038 | 0.751 | 1.003 | 1.007 | 0.172 | 1.028 | 1.014 | 0.171 | 1.015 | 1.017 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3447.5 ± 1.3% | 0.046 | 0.750 | 1.005 | 1.011 | 0.177 | 1.008 | 0.973 | 0.176 | 1.013 | 1.013 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5103.2 ± 0.2% | 0.032 | 0.817 | 1.006 | 1.006 | 0.196 | 1.022 | 1.008 | 0.196 | 1.005 | 1.007 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4101.1 ± 0.7% | 0.040 | 0.830 | 1.007 | 1.007 | 0.200 | 1.019 | 1.001 | 0.199 | 1.009 | 1.010 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19180.8 ± 1.1% | 0.077 | 1.009 | 1.007 | 1.007 | 0.478 | 1.010 | 1.009 | 0.479 | 0.622 | 0.623 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6663.3 ± 0.8% | 0.026 | 0.804 | 1.009 | 1.013 | 0.435 | 1.033 | 1.047 | 0.434 | 1.037 | 1.039 | 0.026 |
| string: canterbury-large/world192.txt | 1103121 | 3375.5 ± 0.4% | 0.048 | 0.847 | 1.006 | 1.007 | 0.198 | 1.016 | 1.011 | 0.199 | 1.007 | 1.005 | 0.047 |
| string: http/html-1m | 1058582 | 6078.0 ± 1.2% | 0.028 | 0.783 | 0.997 | 1.032 | 0.388 | 1.039 | 1.050 | 0.388 | 1.024 | 1.030 | 0.028 |
| string: http/json-1m | 1190272 | 2543.3 ± 0.8% | 0.056 | 0.951 | 1.005 | 1.004 | 0.111 | 1.006 | 0.472 | 0.111 | 1.007 | 1.004 | 0.055 |
| string: http/js-1m | 1144362 | 2284.8 ± 0.7% | 0.066 | 0.890 | 1.002 | 1.004 | 0.174 | 1.056 | 1.042 | 0.174 | 1.004 | 1.004 | 0.065 |
| string: http/css-1m | 1097820 | 2629.3 ± 0.4% | 0.061 | 0.780 | 1.005 | 1.010 | 0.241 | 1.012 | 1.017 | 0.240 | 1.009 | 1.011 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3063.7 ± 0.9% | 0.044 | 0.125 | 1.005 | 1.004 | 0.338 | 1.004 | 1.011 | 0.337 | 1.008 | 1.009 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.7 ± 1.5% | 0.082 | 1.004 | 1.002 | 1.001 | 0.077 | 0.638 | 1.005 | 0.081 | 1.002 | 1.001 | 0.081 |
| hex: silesia/dickens | 524290 | 18892.2 ± 1.3% | 0.079 | 1.000 | 0.991 | 0.997 | 0.518 | 0.996 | 0.991 | 0.519 | 0.635 | 0.635 | 0.009 |
| hex: silesia/mozilla | 524290 | 18938.4 ± 1.2% | 0.079 | 1.004 | 0.993 | 0.995 | 0.509 | 1.000 | 0.994 | 0.509 | 0.635 | 0.635 | 0.009 |
| hex: silesia/mr | 524290 | 18849.5 ± 0.6% | 0.079 | 1.004 | 0.998 | 0.998 | 0.503 | 0.992 | 0.996 | 0.506 | 0.636 | 0.635 | 0.009 |
| hex: silesia/nci | 524290 | 18900.6 ± 1.1% | 0.079 | 1.012 | 0.999 | 0.998 | 0.516 | 0.999 | 0.997 | 0.513 | 0.636 | 0.635 | 0.009 |
| hex: silesia/ooffice | 524290 | 19048.4 ± 0.7% | 0.078 | 0.997 | 0.990 | 0.989 | 0.520 | 0.998 | 0.992 | 0.522 | 0.631 | 0.631 | 0.009 |
| hex: silesia/osdb | 524290 | 18675.4 ± 0.7% | 0.080 | 1.007 | 1.003 | 1.001 | 0.516 | 1.002 | 1.003 | 0.516 | 0.641 | 0.642 | 0.009 |
| hex: silesia/reymont | 524290 | 18985.8 ± 0.9% | 0.078 | 1.000 | 0.994 | 0.989 | 0.514 | 0.994 | 0.992 | 0.511 | 0.633 | 0.633 | 0.009 |
| hex: silesia/samba | 524290 | 18520.0 ± 0.5% | 0.080 | 1.002 | 0.997 | 0.996 | 0.517 | 0.998 | 0.999 | 0.518 | 0.645 | 0.648 | 0.009 |
| hex: silesia/sao | 524290 | 18826.0 ± 0.5% | 0.079 | 1.005 | 0.997 | 0.994 | 0.523 | 1.001 | 1.000 | 0.523 | 0.638 | 0.638 | 0.009 |
| hex: silesia/webster | 524290 | 19090.0 ± 1.2% | 0.078 | 1.001 | 0.993 | 0.990 | 0.510 | 0.994 | 0.994 | 0.511 | 0.629 | 0.629 | 0.009 |
| hex: silesia/x-ray | 524290 | 18900.5 ± 0.8% | 0.079 | 1.002 | 0.999 | 0.997 | 0.510 | 0.997 | 1.000 | 0.512 | 0.635 | 0.634 | 0.009 |
| hex: silesia/xml | 524290 | 19039.2 ± 0.9% | 0.078 | 1.001 | 0.993 | 0.991 | 0.512 | 0.997 | 0.992 | 0.511 | 0.628 | 0.630 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19384.0 ± 0.3% | 0.077 | 1.002 | 1.000 | 0.998 | 0.517 | 1.000 | 0.997 | 0.516 | 0.619 | 0.620 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19516.1 ± 0.2% | 0.077 | 1.001 | 1.001 | 1.002 | 0.506 | 1.002 | 1.001 | 0.509 | 0.615 | 0.615 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19272.7 ± 0.5% | 0.081 | 1.002 | 1.002 | 1.002 | 0.541 | 1.002 | 1.002 | 0.545 | 0.619 | 0.619 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18845.8 ± 0.9% | 0.084 | 1.007 | 1.007 | 1.007 | 0.536 | 1.006 | 1.007 | 0.541 | 0.625 | 0.625 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17543.6 ± 0.7% | 0.089 | 1.004 | 1.004 | 1.004 | 0.525 | 1.003 | 1.003 | 0.543 | 0.642 | 0.645 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18863.8 ± 0.6% | 0.079 | 1.003 | 0.994 | 0.995 | 0.509 | 1.001 | 0.998 | 0.508 | 0.635 | 0.635 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18977.7 ± 1.0% | 0.079 | 1.008 | 1.002 | 0.993 | 0.510 | 0.999 | 0.997 | 0.511 | 0.632 | 0.632 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18897.0 ± 1.2% | 0.079 | 1.004 | 0.998 | 0.997 | 0.513 | 1.000 | 0.999 | 0.513 | 0.633 | 0.632 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 18900.6 ± 0.4% | 0.079 | 0.998 | 0.995 | 0.998 | 0.519 | 1.003 | 0.999 | 0.519 | 0.634 | 0.632 | 0.009 |
| hex: canterbury/sum | 76482 | 19297.2 ± 0.1% | 0.078 | 1.002 | 1.002 | 1.002 | 0.518 | 1.002 | 1.002 | 0.520 | 0.617 | 0.618 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17830.9 ± 0.3% | 0.087 | 1.002 | 1.002 | 1.002 | 0.524 | 1.001 | 1.001 | 0.541 | 0.636 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18772.3 ± 1.0% | 0.080 | 1.004 | 1.001 | 0.997 | 0.518 | 1.002 | 0.998 | 0.518 | 0.637 | 0.640 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18977.6 ± 1.2% | 0.079 | 1.001 | 0.999 | 0.990 | 0.513 | 0.996 | 0.989 | 0.514 | 0.633 | 0.633 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18662.1 ± 0.9% | 0.080 | 1.005 | 1.003 | 1.004 | 0.519 | 1.005 | 1.003 | 0.518 | 0.641 | 0.641 | 0.009 |
| hex: http/html-1kx1024 | 2099200 | 9906.8 ± 17.9% | 0.144 | 1.226 | 1.231 | 1.234 | 0.676 | 1.238 | 0.976 | 0.743 | 0.904 | 0.907 | 0.017 |
| hex: http/html-16kx64 | 2097280 | 18513.5 ± 0.8% | 0.081 | 1.009 | 1.005 | 1.007 | 0.552 | 1.006 | 0.992 | 0.559 | 0.637 | 0.637 | 0.009 |
| hex: http/html-1m | 524290 | 18800.6 ± 0.8% | 0.079 | 1.003 | 0.999 | 1.000 | 0.521 | 0.998 | 1.003 | 0.521 | 0.639 | 0.639 | 0.009 |
| hex: http/json-1kx1024 | 2099200 | 10082.7 ± 17.1% | 0.142 | 1.209 | 1.212 | 1.213 | 0.661 | 1.200 | 0.948 | 0.732 | 0.886 | 0.890 | 0.017 |
| hex: http/json-16kx64 | 2097280 | 18473.8 ± 3.5% | 0.081 | 1.008 | 1.009 | 1.009 | 0.554 | 1.009 | 0.998 | 0.560 | 0.637 | 0.638 | 0.009 |
| hex: http/json-1m | 524290 | 19040.4 ± 1.3% | 0.078 | 0.995 | 0.991 | 0.992 | 0.504 | 0.992 | 0.990 | 0.505 | 0.631 | 0.631 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 10005.8 ± 12.9% | 0.142 | 1.224 | 1.219 | 1.217 | 0.670 | 1.210 | 0.979 | 0.731 | 0.896 | 0.898 | 0.017 |
| hex: http/js-16kx64 | 2097280 | 18508.1 ± 0.9% | 0.082 | 1.008 | 1.007 | 1.006 | 0.553 | 1.006 | 0.994 | 0.560 | 0.636 | 0.637 | 0.009 |
| hex: http/js-1m | 524290 | 18842.9 ± 2.6% | 0.079 | 1.009 | 1.003 | 1.000 | 0.509 | 1.005 | 1.002 | 0.510 | 0.635 | 0.636 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 10023.2 ± 15.0% | 0.142 | 1.220 | 1.227 | 1.225 | 0.665 | 1.213 | 0.979 | 0.733 | 0.891 | 0.896 | 0.017 |
| hex: http/css-16kx64 | 2097280 | 18575.7 ± 0.3% | 0.081 | 1.006 | 1.003 | 1.004 | 0.551 | 1.005 | 0.991 | 0.557 | 0.634 | 0.635 | 0.009 |
| hex: http/css-1m | 524290 | 18902.8 ± 1.4% | 0.079 | 1.004 | 1.001 | 1.004 | 0.514 | 1.001 | 1.001 | 0.515 | 0.635 | 0.635 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18875.2 ± 0.3% | 0.079 | 1.000 | 1.000 | 1.000 | 0.518 | 0.997 | 1.002 | 0.518 | 0.636 | 0.636 | 0.009 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1490.6 ± 1.2% | 0.443 | 1.006 | 0.970 | 1.010 | 1.012 | 0.267 | 0.999 | 0.546 | 0.915 | 0.089 | 1.030 |
| qlog records, JSON text sequence | 1467503 | 1267.0 ± 2.0% | 0.692 | 0.980 | 1.014 | 1.016 | 1.015 | 0.265 | 1.004 | 0.504 | 0.831 | 0.106 | 1.023 |
| string: silesia/dickens | 172528 | 6889.7 ± 0.5% | 0.025 | 1.002 | 1.002 | 1.001 | 1.001 | 0.167 | 0.718 | 1.004 | 1.003 | 0.025 | 1.036 |
| string: silesia/nci | 1075110 | 7313.7 ± 0.3% | 0.024 | 1.002 | 1.002 | 0.999 | 1.002 | 0.212 | 0.565 | 1.001 | 1.002 | 0.024 | 1.010 |
| string: silesia/reymont | 1075159 | 3339.0 ± 1.4% | 0.052 | 1.001 | 1.009 | 1.005 | 1.009 | 0.390 | 0.871 | 1.003 | 1.006 | 0.052 | 1.051 |
| string: silesia/samba | 97582 | 4190.6 ± 0.7% | 0.053 | 1.004 | 1.001 | 1.005 | 1.006 | 0.125 | 0.943 | 1.003 | 1.005 | 0.054 | 1.090 |
| string: silesia/webster | 1098490 | 4057.7 ± 0.6% | 0.042 | 1.010 | 1.008 | 1.010 | 1.010 | 0.213 | 0.889 | 1.002 | 1.006 | 0.043 | 1.009 |
| string: silesia/xml | 1090118 | 6140.1 ± 0.2% | 0.028 | 1.003 | 0.996 | 1.002 | 1.004 | 0.254 | 0.775 | 0.998 | 1.001 | 0.029 | 1.013 |
| string: canterbury/alice29.txt | 159425 | 6416.1 ± 1.6% | 0.027 | 1.012 | 1.014 | 1.015 | 1.014 | 0.132 | 0.657 | 1.003 | 1.006 | 0.027 | 1.060 |
| string: canterbury/asyoulik.txt | 132198 | 5588.8 ± 1.5% | 0.030 | 1.025 | 1.030 | 1.031 | 1.031 | 0.130 | 0.598 | 1.005 | 1.015 | 0.031 | 1.044 |
| string: canterbury/lcet10.txt | 441884 | 6254.2 ± 0.6% | 0.028 | 1.004 | 1.005 | 1.006 | 1.007 | 0.185 | 0.799 | 1.003 | 1.004 | 0.028 | 1.000 |
| string: canterbury/plrabn12.txt | 503330 | 5723.2 ± 0.6% | 0.030 | 1.002 | 1.003 | 1.003 | 1.001 | 0.168 | 0.697 | 1.001 | 1.002 | 0.030 | 1.006 |
| string: canterbury-large/E.coli | 1048578 | 19371.2 ± 0.7% | 0.077 | 1.002 | 1.003 | 1.003 | 1.003 | 0.482 | 1.002 | 1.002 | 1.003 | 0.009 | 1.003 |
| string: canterbury-large/bible.txt | 1055886 | 6800.7 ± 0.4% | 0.026 | 1.002 | 1.002 | 1.001 | 1.002 | 0.496 | 0.972 | 1.001 | 1.003 | 0.026 | 1.000 |
| string: canterbury-large/world192.txt | 1103121 | 4018.1 ± 0.6% | 0.042 | 1.018 | 1.020 | 1.021 | 1.021 | 0.194 | 0.832 | 1.002 | 1.011 | 0.043 | 1.003 |
| string: http/html-1m | 1058582 | 6776.8 ± 0.6% | 0.026 | 1.002 | 0.924 | 1.001 | 1.004 | 0.404 | 0.896 | 0.996 | 1.004 | 0.026 | 1.007 |
| string: http/json-1m | 1190272 | 3170.1 ± 0.3% | 0.050 | 1.001 | 0.965 | 0.998 | 1.000 | 0.133 | 0.370 | 1.000 | 1.001 | 0.051 | 1.043 |
| string: http/js-1m | 1144362 | 2761.1 ± 0.5% | 0.060 | 1.001 | 1.011 | 1.000 | 1.005 | 0.165 | 0.840 | 1.001 | 1.006 | 0.061 | 1.014 |
| string: http/css-1m | 1097820 | 3980.5 ± 0.7% | 0.042 | 1.007 | 1.006 | 1.006 | 1.009 | 0.209 | 0.646 | 1.002 | 1.008 | 0.043 | 1.011 |
| string: dickens as Cyrillic and CJK | 1883069 | 3070.0 ± 0.5% | 0.048 | 1.002 | 0.124 | 0.999 | 1.003 | 0.320 | 1.004 | 1.000 | 1.001 | 0.048 | 1.003 |
| hex: silesia/dickens | 524290 | 15675.0 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 0.998 | 1.000 | 1.000 | 0.177 | 1.001 |
| hex: silesia/mozilla | 524290 | 15652.6 ± 0.2% | 1.000 | 0.178 | 1.001 | 1.000 | 1.002 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.002 |
| hex: silesia/mr | 524290 | 15664.9 ± 0.3% | 1.002 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.002 | 0.178 | 1.002 |
| hex: silesia/nci | 524290 | 15657.0 ± 0.5% | 1.002 | 0.178 | 1.001 | 1.002 | 1.002 | 1.001 | 1.001 | 1.002 | 1.002 | 0.178 | 1.003 |
| hex: silesia/ooffice | 524290 | 15657.2 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.002 | 1.001 | 0.999 | 1.002 | 1.001 | 1.001 | 0.178 | 1.002 |
| hex: silesia/osdb | 524290 | 15647.3 ± 0.4% | 1.000 | 0.178 | 1.000 | 1.000 | 1.001 | 0.998 | 0.998 | 1.001 | 1.000 | 0.178 | 0.999 |
| hex: silesia/reymont | 524290 | 15664.7 ± 0.3% | 1.002 | 0.178 | 1.000 | 1.001 | 1.000 | 1.000 | 1.000 | 1.003 | 1.003 | 0.177 | 1.000 |
| hex: silesia/samba | 524290 | 15661.1 ± 0.2% | 1.000 | 0.178 | 1.001 | 1.002 | 1.000 | 1.000 | 1.001 | 1.000 | 1.001 | 0.178 | 1.000 |
| hex: silesia/sao | 524290 | 15646.2 ± 0.3% | 1.000 | 0.178 | 0.999 | 1.000 | 0.998 | 0.996 | 0.997 | 0.998 | 0.998 | 0.178 | 0.997 |
| hex: silesia/webster | 524290 | 15664.5 ± 0.3% | 1.003 | 0.177 | 0.999 | 1.001 | 1.002 | 1.001 | 1.001 | 1.002 | 1.001 | 0.178 | 1.002 |
| hex: silesia/x-ray | 524290 | 15623.0 ± 0.1% | 1.000 | 0.179 | 0.998 | 0.997 | 0.995 | 0.994 | 0.994 | 0.993 | 0.995 | 0.179 | 0.995 |
| hex: silesia/xml | 524290 | 15651.6 ± 0.2% | 0.999 | 0.178 | 1.000 | 1.002 | 1.001 | 0.998 | 1.000 | 1.000 | 0.998 | 0.178 | 1.000 |
| hex: canterbury/alice29.txt | 304180 | 15684.3 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15706.8 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15617.7 ± 0.2% | 1.001 | 0.179 | 1.000 | 1.000 | 1.001 | 0.998 | 1.000 | 1.002 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15436.6 ± 0.0% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.994 | 1.000 | 1.002 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14930.1 ± 0.1% | 1.004 | 0.186 | 1.001 | 1.000 | 1.001 | 0.984 | 1.001 | 1.005 | 1.015 | 0.184 | 1.004 |
| hex: canterbury/kennedy.xls | 524290 | 15666.6 ± 0.3% | 0.999 | 0.178 | 0.999 | 1.000 | 1.000 | 1.000 | 0.999 | 0.998 | 1.000 | 0.178 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 15638.5 ± 0.3% | 1.000 | 0.178 | 1.000 | 1.000 | 1.001 | 0.999 | 0.999 | 1.000 | 1.000 | 0.178 | 1.001 |
| hex: canterbury/plrabn12.txt | 524290 | 15645.5 ± 0.1% | 1.002 | 0.178 | 1.001 | 1.000 | 1.002 | 1.000 | 1.000 | 0.999 | 1.000 | 0.177 | 1.000 |
| hex: canterbury/ptt5 | 524290 | 15622.7 ± 0.3% | 1.002 | 0.179 | 0.999 | 0.999 | 1.002 | 1.000 | 1.002 | 1.002 | 1.001 | 0.179 | 1.002 |
| hex: canterbury/sum | 76482 | 15653.8 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.998 | 1.001 | 1.000 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 14989.9 ± 0.1% | 1.003 | 0.185 | 1.000 | 1.000 | 1.000 | 0.986 | 1.000 | 1.005 | 1.014 | 0.184 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 15672.2 ± 0.2% | 1.000 | 0.178 | 1.000 | 0.999 | 1.000 | 0.998 | 0.996 | 1.000 | 0.999 | 0.178 | 0.999 |
| hex: canterbury-large/bible.txt | 524290 | 15636.1 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.001 | 1.002 | 1.000 | 1.002 | 1.002 | 1.003 | 0.178 | 1.001 |
| hex: canterbury-large/world192.txt | 524290 | 15625.6 ± 0.1% | 1.002 | 0.178 | 1.001 | 1.001 | 1.002 | 1.000 | 1.001 | 1.003 | 1.002 | 0.178 | 1.002 |
| hex: http/html-1kx1024 | 2099200 | 13737.9 ± 0.3% | 1.007 | 0.196 | 1.004 | 0.998 | 1.001 | 0.940 | 1.001 | 1.009 | 1.038 | 0.187 | 1.015 |
| hex: http/html-16kx64 | 2097280 | 15306.7 ± 0.2% | 0.998 | 0.180 | 1.002 | 1.001 | 1.003 | 0.991 | 0.998 | 1.008 | 1.010 | 0.179 | 1.001 |
| hex: http/html-1m | 524290 | 15674.1 ± 0.1% | 1.000 | 0.177 | 1.001 | 0.999 | 1.001 | 1.000 | 1.000 | 0.999 | 1.001 | 0.177 | 1.001 |
| hex: http/json-1kx1024 | 2099200 | 13668.8 ± 0.6% | 1.008 | 0.195 | 1.005 | 1.002 | 1.002 | 0.945 | 0.999 | 1.015 | 1.037 | 0.188 | 1.014 |
| hex: http/json-16kx64 | 2097280 | 15306.8 ± 0.5% | 1.000 | 0.181 | 0.997 | 1.002 | 1.001 | 0.989 | 0.996 | 0.999 | 1.010 | 0.179 | 1.000 |
| hex: http/json-1m | 524290 | 15693.5 ± 0.3% | 1.000 | 0.177 | 1.000 | 1.002 | 1.002 | 1.000 | 1.000 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: http/js-1kx1024 | 2099200 | 13729.2 ± 0.3% | 1.006 | 0.195 | 1.001 | 1.003 | 1.004 | 0.940 | 0.997 | 1.010 | 1.034 | 0.187 | 1.010 |
| hex: http/js-16kx64 | 2097280 | 15282.5 ± 0.3% | 0.997 | 0.181 | 0.996 | 1.001 | 1.002 | 0.993 | 1.000 | 1.000 | 1.010 | 0.180 | 1.000 |
| hex: http/js-1m | 524290 | 15658.3 ± 0.4% | 1.002 | 0.177 | 1.003 | 1.001 | 1.001 | 1.004 | 1.004 | 1.003 | 1.002 | 0.177 | 1.004 |
| hex: http/css-1kx1024 | 2099200 | 13707.9 ± 0.6% | 1.010 | 0.195 | 0.999 | 1.000 | 1.002 | 0.940 | 0.998 | 1.009 | 1.032 | 0.187 | 1.016 |
| hex: http/css-16kx64 | 2097280 | 15332.1 ± 0.4% | 0.998 | 0.180 | 0.998 | 1.002 | 0.998 | 0.992 | 0.993 | 1.000 | 1.008 | 0.180 | 0.998 |
| hex: http/css-1m | 524290 | 15682.8 ± 0.1% | 1.000 | 0.177 | 1.000 | 1.000 | 1.000 | 0.998 | 0.998 | 0.996 | 0.999 | 0.177 | 1.000 |
| hex: shuffled/dickens-1m | 524290 | 15701.2 ± 0.2% | 0.999 | 0.177 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 1.000 | 0.999 | 0.177 | 1.001 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.050 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.056 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.226 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.231 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.234 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.238 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.209 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.212 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.213 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.200 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.224 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.219 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.217 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.210 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.220 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.227 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.225 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.213 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43344.4 ± 0.1% | 47408.2 ± 0.1% | 0.914 | — | — |
| string: silesia/nci | 1048576 | 36531.5 ± 2.3% | 38708.9 ± 3.1% | 0.944 | — | — |
| string: silesia/reymont | 1048576 | 36646.7 ± 2.3% | 39195.5 ± 5.9% | 0.935 | — | — |
| string: silesia/samba | 65546 | 43560.1 ± 0.0% | 48503.6 ± 0.1% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 38849.1 ± 3.3% | 42901.6 ± 3.6% | 0.906 | — | — |
| string: silesia/xml | 1048576 | 32861.4 ± 2.0% | 33968.0 ± 2.0% | 0.967 | — | — |
| string: canterbury/alice29.txt | 152089 | 35880.8 ± 0.2% | 36529.0 ± 0.2% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43336.8 ± 0.1% | 47665.3 ± 0.1% | 0.909 | — | — |
| string: canterbury/lcet10.txt | 426754 | 34818.2 ± 0.6% | 35244.3 ± 1.1% | 0.988 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 43569.3 ± 0.2% | 47664.1 ± 0.3% | 0.914 | — | — |
| string: canterbury-large/E.coli | 1048576 | 37904.9 ± 1.8% | 40826.7 ± 2.8% | 0.928 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32610.3 ± 4.4% | 33760.6 ± 3.7% | 0.966 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 32422.9 ± 1.8% | 33444.4 ± 3.3% | 0.969 | — | — |
| string: http/html-1m | 1048576 | 35181.3 ± 0.9% | 37702.0 ± 0.6% | 0.933 | — | — |
| string: http/json-1m | 1048576 | 31773.3 ± 1.9% | 34110.2 ± 2.7% | 0.931 | — | — |
| string: http/js-1m | 1048576 | 37279.9 ± 1.1% | 40503.0 ± 2.0% | 0.920 | — | — |
| string: http/css-1m | 1048576 | 38445.5 ± 6.7% | 42003.3 ± 4.5% | 0.915 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5768.6 ± 0.2% | 5654.8 ± 0.1% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.914 of simdutf.
- string: silesia/nci: stdx runs at 0.944 of simdutf.
- string: silesia/reymont: stdx runs at 0.935 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.906 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.909 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.914 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.928 of simdutf.
- string: http/html-1m: stdx runs at 0.933 of simdutf.
- string: http/json-1m: stdx runs at 0.931 of simdutf.
- string: http/js-1m: stdx runs at 0.920 of simdutf.
- string: http/css-1m: stdx runs at 0.915 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 38713.2 ± 0.7% | 42502.6 ± 1.9% | 0.911 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 33327.0 ± 1.6% | 34406.0 ± 1.1% | 0.969 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 37447.0 ± 2.0% | 40344.4 ± 1.9% | 0.928 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 38300.3 ± 3.7% | 42086.1 ± 3.8% | 0.910 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 38285.4 ± 2.8% | 41517.2 ± 2.9% | 0.922 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 38181.9 ± 3.6% | 41251.9 ± 2.9% | 0.926 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5761.9 ± 0.1% | 5644.8 ± 0.2% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5754.7 ± 0.2% | 5647.6 ± 0.1% | 1.019 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5757.7 ± 0.2% | 5642.8 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5763.8 ± 0.2% | 5649.2 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5762.2 ± 0.2% | 5646.7 ± 0.1% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5761.2 ± 0.1% | 5646.8 ± 0.1% | 1.020 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1131.7 ± 0.4% | 931.6 ± 0.6% | 1024.4 ± 0.4% | 301.3 ± 0.6% | 667.7 ± 0.2% | 310.5 ± 1.3% | 1.215 | 1.105 | 3.757 | 1.695 | 3.645 |
| qlog records, JSON text sequence | 1467503 | 850.9 ± 0.8% | 817.3 ± 0.3% | 806.0 ± 1.1% | 243.5 ± 0.7% | 700.7 ± 0.8% | 252.7 ± 0.5% | 1.041 | 1.056 | 3.495 | 1.214 | 3.367 |
| string: silesia/dickens | 172528 | 5052.2 ± 0.3% | 1877.2 ± 0.5% | 2650.8 ± 0.3% | 361.2 ± 1.2% | 2849.0 ± 0.2% | 554.8 ± 1.7% | 2.691 | 1.906 | 13.987 | 1.773 | 9.107 |
| string: silesia/nci | 1075110 | 4295.1 ± 0.5% | 2242.5 ± 0.3% | 3006.5 ± 0.3% | 544.5 ± 0.3% | 3012.1 ± 0.4% | 604.8 ± 2.7% | 1.915 | 1.429 | 7.888 | 1.426 | 7.101 |
| string: silesia/reymont | 1075159 | 2925.0 ± 2.0% | 1828.7 ± 1.1% | 2068.2 ± 0.7% | 376.0 ± 0.4% | 2145.9 ± 1.1% | 533.7 ± 6.8% | 1.600 | 1.414 | 7.779 | 1.363 | 5.481 |
| string: silesia/samba | 97582 | 3504.4 ± 0.8% | 2025.9 ± 0.2% | 2617.2 ± 0.3% | 328.8 ± 0.6% | 1497.2 ± 0.2% | 432.0 ± 1.2% | 1.730 | 1.339 | 10.657 | 2.341 | 8.112 |
| string: silesia/webster | 1098490 | 3660.5 ± 0.6% | 1519.0 ± 0.5% | 2016.7 ± 0.6% | 359.2 ± 0.6% | 2185.7 ± 0.5% | 500.5 ± 0.4% | 2.410 | 1.815 | 10.191 | 1.675 | 7.314 |
| string: silesia/xml | 1090118 | 4784.3 ± 0.4% | 2357.4 ± 0.4% | 2531.9 ± 0.4% | 456.1 ± 0.5% | 2874.1 ± 0.3% | 568.2 ± 1.0% | 2.029 | 1.890 | 10.490 | 1.665 | 8.420 |
| string: canterbury/alice29.txt | 159425 | 4312.3 ± 0.6% | 1601.3 ± 0.2% | 2457.0 ± 0.5% | 342.2 ± 0.4% | 2499.2 ± 0.7% | 507.3 ± 1.5% | 2.693 | 1.755 | 12.602 | 1.725 | 8.501 |
| string: canterbury/asyoulik.txt | 132198 | 3447.5 ± 1.3% | 1459.2 ± 0.3% | 2241.8 ± 1.0% | 334.8 ± 0.4% | 2074.1 ± 0.6% | 460.9 ± 1.7% | 2.363 | 1.538 | 10.298 | 1.662 | 7.480 |
| string: canterbury/lcet10.txt | 441884 | 5103.2 ± 0.2% | 1854.8 ± 0.2% | 2355.7 ± 0.9% | 389.8 ± 0.6% | 2834.4 ± 1.0% | 533.5 ± 1.3% | 2.751 | 2.166 | 13.091 | 1.800 | 9.566 |
| string: canterbury/plrabn12.txt | 503330 | 4101.1 ± 0.7% | 1735.6 ± 0.2% | 2061.6 ± 0.5% | 360.0 ± 0.5% | 2502.6 ± 0.6% | 496.9 ± 1.5% | 2.363 | 1.989 | 11.393 | 1.639 | 8.254 |
| string: canterbury-large/E.coli | 1048578 | 19180.8 ± 1.1% | 3608.8 ± 0.4% | 3264.3 ± 0.4% | 932.7 ± 1.0% | 6038.5 ± 1.6% | 756.4 ± 1.6% | 5.315 | 5.876 | 20.564 | 3.176 | 25.359 |
| string: canterbury-large/bible.txt | 1055886 | 6663.3 ± 0.8% | 2943.6 ± 0.3% | 2846.9 ± 1.3% | 422.6 ± 2.6% | 3768.5 ± 1.2% | 612.1 ± 1.8% | 2.264 | 2.341 | 15.768 | 1.768 | 10.886 |
| string: canterbury-large/world192.txt | 1103121 | 3375.5 ± 0.4% | 1483.1 ± 0.2% | 2012.3 ± 0.5% | 352.7 ± 0.2% | 2126.5 ± 1.1% | 498.4 ± 0.4% | 2.276 | 1.677 | 9.569 | 1.587 | 6.772 |
| string: http/html-1m | 1058582 | 6078.0 ± 1.2% | 2737.8 ± 0.4% | 2708.7 ± 0.4% | 441.7 ± 0.4% | 3482.3 ± 0.5% | 596.5 ± 1.2% | 2.220 | 2.244 | 13.761 | 1.745 | 10.189 |
| string: http/json-1m | 1190272 | 2543.3 ± 0.8% | 878.2 ± 0.2% | 2253.4 ± 0.5% | 389.8 ± 0.2% | 1066.5 ± 0.7% | 439.6 ± 0.6% | 2.896 | 1.129 | 6.524 | 2.385 | 5.785 |
| string: http/js-1m | 1144362 | 2284.8 ± 0.7% | 1029.7 ± 0.2% | 1640.3 ± 0.4% | 319.8 ± 0.6% | 1529.0 ± 0.3% | 415.7 ± 0.8% | 2.219 | 1.393 | 7.145 | 1.494 | 5.497 |
| string: http/css-1m | 1097820 | 2629.3 ± 0.4% | 1679.2 ± 0.3% | 2223.3 ± 0.9% | 405.2 ± 0.5% | 1960.9 ± 0.6% | 486.3 ± 0.6% | 1.566 | 1.183 | 6.489 | 1.341 | 5.407 |
| string: dickens as Cyrillic and CJK | 1883069 | 3063.7 ± 0.9% | 1685.7 ± 0.3% | 893.7 ± 0.6% | 351.6 ± 0.2% | 669.3 ± 1.5% | 157.0 ± 1.4% | 1.817 | 3.428 | 8.713 | 4.577 | 19.516 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.7 ± 1.5% | 981.2 ± 0.3% | 1198.8 ± 0.4% | 215.9 ± 0.2% | 471.6 ± 1.0% | 251.6 ± 4.3% | 1.353 | 1.107 | 6.149 | 2.815 | 5.277 |
| hex: silesia/dickens | 524290 | 18892.2 ± 1.3% | 3622.7 ± 0.2% | 3292.3 ± 0.4% | 517.7 ± 2.4% | 6074.6 ± 1.6% | 784.0 ± 2.6% | 5.215 | 5.738 | 36.491 | 3.110 | 24.098 |
| hex: silesia/mozilla | 524290 | 18938.4 ± 1.2% | 3622.4 ± 0.2% | 3297.9 ± 0.3% | 454.4 ± 1.5% | 6134.0 ± 1.2% | 782.1 ± 0.4% | 5.228 | 5.743 | 41.678 | 3.087 | 24.215 |
| hex: silesia/mr | 524290 | 18849.5 ± 0.6% | 3620.0 ± 0.3% | 3301.7 ± 0.2% | 569.8 ± 2.7% | 6068.4 ± 1.8% | 781.8 ± 0.5% | 5.207 | 5.709 | 33.079 | 3.106 | 24.112 |
| hex: silesia/nci | 524290 | 18900.6 ± 1.1% | 3622.0 ± 0.2% | 3290.0 ± 0.7% | 622.5 ± 1.6% | 6141.9 ± 2.1% | 780.6 ± 0.2% | 5.218 | 5.745 | 30.361 | 3.077 | 24.213 |
| hex: silesia/ooffice | 524290 | 19048.4 ± 0.7% | 3621.6 ± 0.1% | 3305.5 ± 0.4% | 395.0 ± 1.0% | 6102.0 ± 1.2% | 781.5 ± 0.3% | 5.260 | 5.763 | 48.228 | 3.122 | 24.375 |
| hex: silesia/osdb | 524290 | 18675.4 ± 0.7% | 3620.2 ± 0.2% | 3296.1 ± 0.2% | 474.9 ± 1.6% | 5984.9 ± 0.3% | 781.4 ± 0.6% | 5.159 | 5.666 | 39.323 | 3.120 | 23.899 |
| hex: silesia/reymont | 524290 | 18985.8 ± 0.9% | 3620.5 ± 0.2% | 3308.8 ± 0.3% | 509.4 ± 0.8% | 6104.2 ± 1.9% | 781.7 ± 0.2% | 5.244 | 5.738 | 37.270 | 3.110 | 24.288 |
| hex: silesia/samba | 524290 | 18520.0 ± 0.5% | 3622.3 ± 0.2% | 3302.3 ± 0.2% | 401.4 ± 0.8% | 6152.2 ± 0.7% | 783.1 ± 0.1% | 5.113 | 5.608 | 46.134 | 3.010 | 23.648 |
| hex: silesia/sao | 524290 | 18826.0 ± 0.5% | 3619.5 ± 0.2% | 3301.6 ± 0.4% | 341.6 ± 0.4% | 6156.8 ± 2.1% | 782.3 ± 0.4% | 5.201 | 5.702 | 55.112 | 3.058 | 24.065 |
| hex: silesia/webster | 524290 | 19090.0 ± 1.2% | 3620.6 ± 0.1% | 3298.2 ± 0.3% | 467.8 ± 0.8% | 6114.8 ± 1.8% | 782.8 ± 0.9% | 5.273 | 5.788 | 40.806 | 3.122 | 24.387 |
| hex: silesia/x-ray | 524290 | 18900.5 ± 0.8% | 3620.7 ± 0.2% | 3309.3 ± 0.4% | 471.6 ± 0.8% | 6113.1 ± 1.1% | 782.6 ± 0.4% | 5.220 | 5.711 | 40.076 | 3.092 | 24.150 |
| hex: silesia/xml | 524290 | 19039.2 ± 0.9% | 3622.8 ± 0.1% | 3296.8 ± 0.3% | 521.3 ± 1.3% | 6065.7 ± 0.5% | 782.6 ± 0.2% | 5.255 | 5.775 | 36.521 | 3.139 | 24.329 |
| hex: canterbury/alice29.txt | 304180 | 19384.0 ± 0.3% | 3635.7 ± 0.1% | 3365.3 ± 0.1% | 500.8 ± 5.6% | 6125.0 ± 1.7% | 781.1 ± 0.5% | 5.332 | 5.760 | 38.708 | 3.165 | 24.815 |
| hex: canterbury/asyoulik.txt | 250360 | 19516.1 ± 0.2% | 3641.4 ± 0.0% | 3375.9 ± 0.2% | 497.5 ± 0.7% | 6107.3 ± 2.2% | 780.8 ± 0.4% | 5.360 | 5.781 | 39.227 | 3.196 | 24.996 |
| hex: canterbury/cp.html | 49208 | 19272.7 ± 0.5% | 3638.1 ± 0.1% | 3279.3 ± 0.3% | 467.9 ± 3.2% | 6247.0 ± 1.9% | 765.7 ± 1.7% | 5.298 | 5.877 | 41.187 | 3.085 | 25.170 |
| hex: canterbury/fields.c | 22302 | 18845.8 ± 0.9% | 3625.8 ± 0.1% | 3397.0 ± 0.4% | 498.1 ± 0.7% | 6257.6 ± 0.4% | 759.0 ± 1.8% | 5.198 | 5.548 | 37.836 | 3.012 | 24.829 |
| hex: canterbury/grammar.lsp | 7444 | 17543.6 ± 0.7% | 3599.8 ± 0.1% | 3355.3 ± 0.5% | 540.4 ± 3.6% | 6185.3 ± 0.7% | 731.4 ± 1.8% | 4.873 | 5.229 | 32.461 | 2.836 | 23.986 |
| hex: canterbury/kennedy.xls | 524290 | 18863.8 ± 0.6% | 3617.9 ± 0.3% | 3297.2 ± 0.4% | 654.9 ± 5.4% | 6098.3 ± 2.0% | 785.5 ± 5.8% | 5.214 | 5.721 | 28.803 | 3.093 | 24.016 |
| hex: canterbury/lcet10.txt | 524290 | 18977.7 ± 1.0% | 3623.7 ± 0.3% | 3300.8 ± 0.8% | 509.3 ± 3.2% | 6142.3 ± 0.7% | 787.0 ± 0.4% | 5.237 | 5.749 | 37.264 | 3.090 | 24.115 |
| hex: canterbury/plrabn12.txt | 524290 | 18897.0 ± 1.2% | 3621.2 ± 0.2% | 3310.8 ± 0.3% | 504.4 ± 0.6% | 6059.3 ± 1.9% | 784.9 ± 0.3% | 5.218 | 5.708 | 37.461 | 3.119 | 24.076 |
| hex: canterbury/ptt5 | 524290 | 18900.6 ± 0.4% | 3620.3 ± 0.2% | 3294.8 ± 0.3% | 557.1 ± 0.9% | 6119.5 ± 1.4% | 787.8 ± 0.3% | 5.221 | 5.736 | 33.929 | 3.089 | 23.993 |
| hex: canterbury/sum | 76482 | 19297.2 ± 0.1% | 3633.4 ± 0.1% | 3357.1 ± 0.5% | 509.7 ± 1.4% | 6178.3 ± 0.7% | 778.0 ± 1.3% | 5.311 | 5.748 | 37.856 | 3.123 | 24.804 |
| hex: canterbury/xargs.1 | 8456 | 17830.9 ± 0.3% | 3602.8 ± 0.0% | 3378.6 ± 0.3% | 492.6 ± 1.9% | 6152.6 ± 0.7% | 758.4 ± 2.1% | 4.949 | 5.278 | 36.195 | 2.898 | 23.511 |
| hex: canterbury-large/E.coli | 524290 | 18772.3 ± 1.0% | 3615.4 ± 0.1% | 3295.5 ± 0.3% | 689.1 ± 0.1% | 6141.6 ± 2.2% | 781.3 ± 3.9% | 5.192 | 5.696 | 27.240 | 3.057 | 24.026 |
| hex: canterbury-large/bible.txt | 524290 | 18977.6 ± 1.2% | 3619.9 ± 0.3% | 3300.1 ± 0.3% | 522.1 ± 0.5% | 6119.9 ± 1.5% | 783.1 ± 0.5% | 5.243 | 5.751 | 36.350 | 3.101 | 24.235 |
| hex: canterbury-large/world192.txt | 524290 | 18662.1 ± 0.9% | 3619.1 ± 0.3% | 3295.7 ± 0.5% | 496.6 ± 2.1% | 6081.0 ± 1.5% | 783.1 ± 0.5% | 5.157 | 5.663 | 37.582 | 3.069 | 23.830 |
| hex: http/html-1kx1024 | 2099200 | 9906.8 ± 17.9% | 3464.2 ± 0.2% | 2897.2 ± 0.7% | 475.7 ± 1.5% | 5167.4 ± 0.7% | 652.3 ± 1.0% | 2.860 | 3.419 | 20.827 | 1.917 | 15.188 |
| hex: http/html-16kx64 | 2097280 | 18513.5 ± 0.8% | 3612.5 ± 0.1% | 3277.8 ± 0.2% | 478.2 ± 1.2% | 6020.1 ± 0.6% | 754.3 ± 2.8% | 5.125 | 5.648 | 38.714 | 3.075 | 24.544 |
| hex: http/html-1m | 524290 | 18800.6 ± 0.8% | 3611.9 ± 0.3% | 3308.8 ± 0.3% | 494.2 ± 1.7% | 6096.1 ± 0.9% | 783.1 ± 1.1% | 5.205 | 5.682 | 38.042 | 3.084 | 24.008 |
| hex: http/json-1kx1024 | 2099200 | 10082.7 ± 17.1% | 3463.1 ± 0.2% | 2895.1 ± 0.8% | 576.1 ± 0.4% | 5178.5 ± 2.3% | 660.5 ± 11.3% | 2.911 | 3.483 | 17.503 | 1.947 | 15.266 |
| hex: http/json-16kx64 | 2097280 | 18473.8 ± 3.5% | 3611.5 ± 0.1% | 3269.7 ± 0.3% | 570.3 ± 0.8% | 6028.2 ± 0.2% | 763.5 ± 1.9% | 5.115 | 5.650 | 32.394 | 3.065 | 24.197 |
| hex: http/json-1m | 524290 | 19040.4 ± 1.3% | 3620.2 ± 0.1% | 3307.2 ± 0.5% | 593.2 ± 2.6% | 6155.6 ± 0.9% | 786.2 ± 0.2% | 5.259 | 5.757 | 32.096 | 3.093 | 24.219 |
| hex: http/js-1kx1024 | 2099200 | 10005.8 ± 12.9% | 3456.7 ± 0.3% | 2907.5 ± 0.3% | 479.7 ± 0.5% | 5150.8 ± 1.1% | 651.7 ± 3.6% | 2.895 | 3.441 | 20.860 | 1.943 | 15.354 |
| hex: http/js-16kx64 | 2097280 | 18508.1 ± 0.9% | 3608.9 ± 0.1% | 3280.5 ± 0.2% | 478.5 ± 1.3% | 6026.6 ± 0.3% | 759.8 ± 1.2% | 5.128 | 5.642 | 38.677 | 3.071 | 24.358 |
| hex: http/js-1m | 524290 | 18842.9 ± 2.6% | 3619.8 ± 0.2% | 3296.6 ± 0.4% | 507.4 ± 1.5% | 6112.0 ± 1.7% | 772.2 ± 2.7% | 5.206 | 5.716 | 37.137 | 3.083 | 24.401 |
| hex: http/css-1kx1024 | 2099200 | 10023.2 ± 15.0% | 3464.7 ± 0.2% | 2906.4 ± 0.4% | 489.5 ± 0.6% | 5160.5 ± 1.5% | 648.4 ± 1.9% | 2.893 | 3.449 | 20.477 | 1.942 | 15.458 |
| hex: http/css-16kx64 | 2097280 | 18575.7 ± 0.3% | 3610.4 ± 0.1% | 3269.0 ± 0.3% | 494.2 ± 1.3% | 6022.3 ± 0.3% | 759.0 ± 2.1% | 5.145 | 5.682 | 37.585 | 3.084 | 24.474 |
| hex: http/css-1m | 524290 | 18902.8 ± 1.4% | 3620.3 ± 0.7% | 3305.2 ± 0.1% | 492.7 ± 1.5% | 6120.7 ± 1.7% | 783.3 ± 4.9% | 5.221 | 5.719 | 38.362 | 3.088 | 24.131 |
| hex: shuffled/dickens-1m | 524290 | 18875.2 ± 0.3% | 3623.5 ± 0.3% | 3293.2 ± 0.3% | 512.5 ± 3.1% | 6101.0 ± 1.7% | 787.9 ± 0.6% | 5.209 | 5.732 | 36.827 | 3.094 | 23.955 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1490.6 ± 1.2% | 1260.5 ± 0.2% | 1046.4 ± 0.4% | 410.3 ± 0.4% | 448.8 ± 0.4% | 417.5 ± 0.3% | 1.183 | 1.425 | 3.633 | 3.321 | 3.570 |
| qlog records, JSON text sequence | 1467503 | 1267.0 ± 2.0% | 1065.2 ± 0.5% | 791.3 ± 0.5% | 377.7 ± 0.8% | 468.3 ± 0.7% | 278.5 ± 0.3% | 1.189 | 1.601 | 3.354 | 2.705 | 4.549 |
| string: silesia/dickens | 172528 | 6889.7 ± 0.5% | 2815.2 ± 0.4% | 2934.7 ± 0.5% | 431.4 ± 0.3% | 1590.8 ± 0.8% | 1010.8 ± 0.2% | 2.447 | 2.348 | 15.970 | 4.331 | 6.816 |
| string: silesia/nci | 1075110 | 7313.7 ± 0.3% | 3415.0 ± 0.9% | 3101.5 ± 0.6% | 821.5 ± 3.1% | 1866.6 ± 0.3% | 1111.5 ± 0.4% | 2.142 | 2.358 | 8.903 | 3.918 | 6.580 |
| string: silesia/reymont | 1075159 | 3339.0 ± 1.4% | 1989.4 ± 1.9% | 2063.1 ± 0.4% | 451.7 ± 0.5% | 1511.5 ± 0.7% | 953.6 ± 0.4% | 1.678 | 1.618 | 7.393 | 2.209 | 3.501 |
| string: silesia/samba | 97582 | 4190.6 ± 0.7% | 2120.4 ± 0.8% | 3453.7 ± 0.3% | 353.2 ± 1.0% | 1436.1 ± 0.2% | 1055.6 ± 0.3% | 1.976 | 1.213 | 11.865 | 2.918 | 3.970 |
| string: silesia/webster | 1098490 | 4057.7 ± 0.6% | 1885.4 ± 0.5% | 2059.1 ± 0.4% | 443.0 ± 0.3% | 1398.0 ± 0.3% | 646.3 ± 1.1% | 2.152 | 1.971 | 9.161 | 2.903 | 6.279 |
| string: silesia/xml | 1090118 | 6140.1 ± 0.2% | 2881.4 ± 0.7% | 2652.0 ± 0.5% | 608.9 ± 0.1% | 1756.0 ± 0.4% | 923.0 ± 0.7% | 2.131 | 2.315 | 10.084 | 3.497 | 6.652 |
| string: canterbury/alice29.txt | 159425 | 6416.1 ± 1.6% | 2197.4 ± 0.4% | 2762.2 ± 0.7% | 406.9 ± 0.8% | 1480.4 ± 0.6% | 954.9 ± 0.4% | 2.920 | 2.323 | 15.767 | 4.334 | 6.719 |
| string: canterbury/asyoulik.txt | 132198 | 5588.8 ± 1.5% | 1716.4 ± 0.7% | 2366.4 ± 1.1% | 401.0 ± 0.6% | 1349.6 ± 0.7% | 885.6 ± 0.2% | 3.256 | 2.362 | 13.939 | 4.141 | 6.311 |
| string: canterbury/lcet10.txt | 441884 | 6254.2 ± 0.6% | 2572.0 ± 0.4% | 2518.0 ± 2.1% | 467.7 ± 0.8% | 1542.3 ± 0.6% | 988.8 ± 0.5% | 2.432 | 2.484 | 13.373 | 4.055 | 6.325 |
| string: canterbury/plrabn12.txt | 503330 | 5723.2 ± 0.6% | 2064.5 ± 0.4% | 2071.1 ± 0.5% | 424.2 ± 0.9% | 1432.7 ± 0.3% | 936.3 ± 0.6% | 2.772 | 2.763 | 13.491 | 3.995 | 6.113 |
| string: canterbury-large/E.coli | 1048578 | 19371.2 ± 0.7% | 9873.0 ± 0.7% | 3796.4 ± 0.5% | 1483.1 ± 0.7% | 2368.8 ± 1.1% | 1195.5 ± 0.7% | 1.962 | 5.103 | 13.062 | 8.178 | 16.204 |
| string: canterbury-large/bible.txt | 1055886 | 6800.7 ± 0.4% | 4175.8 ± 1.1% | 3064.6 ± 1.8% | 505.3 ± 0.3% | 1975.8 ± 0.2% | 1125.2 ± 1.2% | 1.629 | 2.219 | 13.459 | 3.442 | 6.044 |
| string: canterbury-large/world192.txt | 1103121 | 4018.1 ± 0.6% | 1660.1 ± 0.2% | 2004.2 ± 0.8% | 447.4 ± 0.3% | 1361.6 ± 0.4% | 909.9 ± 0.4% | 2.420 | 2.005 | 8.980 | 2.951 | 4.416 |
| string: http/html-1m | 1058582 | 6776.8 ± 0.6% | 4011.2 ± 0.3% | 3045.8 ± 0.3% | 500.8 ± 0.7% | 1921.3 ± 0.3% | 807.6 ± 0.6% | 1.689 | 2.225 | 13.533 | 3.527 | 8.391 |
| string: http/json-1m | 1190272 | 3170.1 ± 0.3% | 1351.5 ± 0.4% | 1558.5 ± 0.4% | 444.1 ± 0.3% | 962.3 ± 0.1% | 767.7 ± 0.3% | 2.346 | 2.034 | 7.138 | 3.294 | 4.129 |
| string: http/js-1m | 1144362 | 2761.1 ± 0.5% | 1181.2 ± 0.5% | 1631.4 ± 0.3% | 368.8 ± 0.2% | 1096.3 ± 0.2% | 760.3 ± 0.4% | 2.338 | 1.692 | 7.486 | 2.519 | 3.632 |
| string: http/css-1m | 1097820 | 3980.5 ± 0.7% | 1491.3 ± 0.6% | 2149.4 ± 0.8% | 494.3 ± 0.2% | 1370.0 ± 0.4% | 894.9 ± 0.4% | 2.669 | 1.852 | 8.052 | 2.905 | 4.448 |
| string: dickens as Cyrillic and CJK | 1883069 | 3070.0 ± 0.5% | 2349.3 ± 0.6% | 522.1 ± 0.2% | 307.0 ± 0.6% | 561.2 ± 1.0% | 336.6 ± 0.2% | 1.307 | 5.880 | 10.001 | 5.471 | 9.121 |
| hex: silesia/dickens | 524290 | 15675.0 ± 0.2% | 1469.7 ± 0.2% | 1084.0 ± 0.3% | 503.1 ± 1.1% | 988.4 ± 0.6% | 737.0 ± 0.5% | 10.666 | 14.460 | 31.154 | 15.859 | 21.269 |
| hex: silesia/mozilla | 524290 | 15652.6 ± 0.2% | 1479.5 ± 0.3% | 1092.6 ± 0.7% | 441.3 ± 0.3% | 996.9 ± 0.4% | 736.0 ± 0.4% | 10.580 | 14.326 | 35.467 | 15.701 | 21.268 |
| hex: silesia/mr | 524290 | 15664.9 ± 0.3% | 1486.6 ± 0.3% | 1094.6 ± 0.5% | 554.4 ± 0.9% | 997.2 ± 0.4% | 736.8 ± 0.4% | 10.538 | 14.311 | 28.257 | 15.708 | 21.262 |
| hex: silesia/nci | 524290 | 15657.0 ± 0.5% | 1477.0 ± 0.7% | 1091.7 ± 0.6% | 644.0 ± 3.0% | 994.2 ± 0.4% | 737.7 ± 0.6% | 10.601 | 14.341 | 24.312 | 15.748 | 21.225 |
| hex: silesia/ooffice | 524290 | 15657.2 ± 0.2% | 1467.9 ± 0.3% | 1088.4 ± 0.2% | 389.9 ± 0.3% | 992.4 ± 0.6% | 736.6 ± 0.6% | 10.667 | 14.386 | 40.154 | 15.777 | 21.255 |
| hex: silesia/osdb | 524290 | 15647.3 ± 0.4% | 1472.4 ± 0.2% | 1089.3 ± 0.5% | 476.9 ± 1.7% | 994.1 ± 0.5% | 737.9 ± 0.5% | 10.627 | 14.364 | 32.809 | 15.741 | 21.205 |
| hex: silesia/reymont | 524290 | 15664.7 ± 0.3% | 1474.9 ± 0.5% | 1091.1 ± 0.4% | 514.2 ± 0.5% | 988.2 ± 0.4% | 737.6 ± 0.4% | 10.621 | 14.357 | 30.462 | 15.851 | 21.238 |
| hex: silesia/samba | 524290 | 15661.1 ± 0.2% | 1471.9 ± 0.4% | 1089.1 ± 0.5% | 402.2 ± 0.5% | 995.5 ± 0.5% | 736.3 ± 0.5% | 10.640 | 14.379 | 38.935 | 15.733 | 21.270 |
| hex: silesia/sao | 524290 | 15646.2 ± 0.3% | 1468.0 ± 0.3% | 1086.3 ± 0.6% | 333.2 ± 0.7% | 992.0 ± 0.3% | 737.9 ± 0.3% | 10.658 | 14.404 | 46.964 | 15.773 | 21.203 |
| hex: silesia/webster | 524290 | 15664.5 ± 0.3% | 1470.3 ± 0.3% | 1088.0 ± 0.2% | 476.3 ± 0.4% | 994.7 ± 0.3% | 737.3 ± 0.5% | 10.654 | 14.398 | 32.886 | 15.748 | 21.246 |
| hex: silesia/x-ray | 524290 | 15623.0 ± 0.1% | 1481.4 ± 0.2% | 1092.8 ± 0.4% | 443.6 ± 1.2% | 996.2 ± 0.4% | 736.7 ± 0.5% | 10.546 | 14.297 | 35.217 | 15.683 | 21.208 |
| hex: silesia/xml | 524290 | 15651.6 ± 0.2% | 1473.3 ± 0.6% | 1090.7 ± 0.3% | 615.0 ± 0.6% | 994.4 ± 0.4% | 736.9 ± 0.6% | 10.624 | 14.350 | 25.450 | 15.740 | 21.239 |
| hex: canterbury/alice29.txt | 304180 | 15684.3 ± 0.1% | 1474.0 ± 0.5% | 1094.2 ± 0.2% | 503.9 ± 0.5% | 994.1 ± 0.3% | 738.4 ± 0.5% | 10.641 | 14.334 | 31.126 | 15.777 | 21.242 |
| hex: canterbury/asyoulik.txt | 250360 | 15706.8 ± 0.1% | 1477.3 ± 0.6% | 1095.1 ± 0.2% | 498.7 ± 0.9% | 996.7 ± 0.5% | 742.1 ± 0.2% | 10.632 | 14.343 | 31.497 | 15.759 | 21.167 |
| hex: canterbury/cp.html | 49208 | 15617.7 ± 0.2% | 1472.5 ± 0.6% | 1098.0 ± 0.2% | 530.6 ± 3.4% | 1000.5 ± 0.6% | 743.2 ± 0.2% | 10.606 | 14.224 | 29.433 | 15.609 | 21.014 |
| hex: canterbury/fields.c | 22302 | 15436.6 ± 0.0% | 1407.1 ± 0.7% | 1068.4 ± 0.7% | 635.9 ± 8.9% | 989.1 ± 0.5% | 736.8 ± 0.2% | 10.970 | 14.449 | 24.275 | 15.607 | 20.950 |
| hex: canterbury/grammar.lsp | 7444 | 14930.1 ± 0.1% | 1504.1 ± 0.2% | 1089.4 ± 0.9% | 685.3 ± 5.3% | 995.4 ± 0.5% | 725.4 ± 0.2% | 9.926 | 13.704 | 21.787 | 14.999 | 20.581 |
| hex: canterbury/kennedy.xls | 524290 | 15666.6 ± 0.3% | 1483.1 ± 0.5% | 1092.1 ± 0.4% | 657.9 ± 0.9% | 992.0 ± 0.4% | 738.1 ± 0.5% | 10.563 | 14.345 | 23.813 | 15.793 | 21.225 |
| hex: canterbury/lcet10.txt | 524290 | 15638.5 ± 0.3% | 1465.0 ± 0.3% | 1084.4 ± 0.5% | 501.3 ± 0.7% | 991.4 ± 0.2% | 735.8 ± 0.7% | 10.675 | 14.422 | 31.195 | 15.774 | 21.253 |
| hex: canterbury/plrabn12.txt | 524290 | 15645.5 ± 0.1% | 1471.4 ± 0.4% | 1085.7 ± 0.3% | 495.0 ± 0.5% | 991.1 ± 0.5% | 737.4 ± 0.4% | 10.633 | 14.411 | 31.608 | 15.786 | 21.217 |
| hex: canterbury/ptt5 | 524290 | 15622.7 ± 0.3% | 1486.3 ± 0.3% | 1095.4 ± 0.3% | 557.5 ± 1.1% | 994.9 ± 0.4% | 737.4 ± 0.6% | 10.511 | 14.262 | 28.023 | 15.703 | 21.187 |
| hex: canterbury/sum | 76482 | 15653.8 ± 0.1% | 1494.6 ± 0.1% | 1104.7 ± 0.2% | 589.6 ± 2.6% | 998.1 ± 0.1% | 744.3 ± 0.1% | 10.474 | 14.170 | 26.550 | 15.683 | 21.031 |
| hex: canterbury/xargs.1 | 8456 | 14989.9 ± 0.1% | 1430.1 ± 1.7% | 1088.6 ± 0.7% | 647.3 ± 5.6% | 997.5 ± 0.1% | 727.6 ± 0.7% | 10.482 | 13.770 | 23.158 | 15.028 | 20.601 |
| hex: canterbury-large/E.coli | 524290 | 15672.2 ± 0.2% | 1477.5 ± 0.4% | 1093.6 ± 0.9% | 673.1 ± 0.8% | 993.5 ± 0.3% | 738.1 ± 0.2% | 10.607 | 14.330 | 23.283 | 15.775 | 21.233 |
| hex: canterbury-large/bible.txt | 524290 | 15636.1 ± 0.2% | 1465.4 ± 0.4% | 1083.3 ± 0.4% | 516.9 ± 0.8% | 989.8 ± 0.7% | 737.6 ± 0.4% | 10.670 | 14.434 | 30.251 | 15.797 | 21.198 |
| hex: canterbury-large/world192.txt | 524290 | 15625.6 ± 0.1% | 1469.8 ± 0.1% | 1088.2 ± 0.2% | 504.0 ± 0.7% | 991.8 ± 0.7% | 737.4 ± 0.6% | 10.631 | 14.359 | 31.004 | 15.754 | 21.190 |
| hex: http/html-1kx1024 | 2099200 | 13737.9 ± 0.3% | 1454.2 ± 0.4% | 1061.3 ± 0.3% | 502.6 ± 0.2% | 982.8 ± 0.1% | 692.1 ± 0.2% | 9.447 | 12.944 | 27.333 | 13.979 | 19.849 |
| hex: http/html-16kx64 | 2097280 | 15306.7 ± 0.2% | 1444.2 ± 0.1% | 1074.7 ± 0.2% | 507.3 ± 0.4% | 996.2 ± 0.1% | 735.3 ± 0.1% | 10.599 | 14.243 | 30.176 | 15.365 | 20.818 |
| hex: http/html-1m | 524290 | 15674.1 ± 0.1% | 1471.4 ± 0.3% | 1086.1 ± 1.1% | 501.6 ± 0.4% | 992.5 ± 0.5% | 737.4 ± 0.6% | 10.652 | 14.432 | 31.250 | 15.793 | 21.257 |
| hex: http/json-1kx1024 | 2099200 | 13668.8 ± 0.6% | 1464.3 ± 0.3% | 1068.7 ± 1.0% | 610.5 ± 0.2% | 986.7 ± 0.2% | 692.0 ± 0.1% | 9.335 | 12.790 | 22.391 | 13.852 | 19.752 |
| hex: http/json-16kx64 | 2097280 | 15306.8 ± 0.5% | 1447.3 ± 0.2% | 1076.4 ± 0.2% | 614.8 ± 0.8% | 997.1 ± 0.3% | 734.5 ± 0.2% | 10.576 | 14.220 | 24.898 | 15.352 | 20.840 |
| hex: http/json-1m | 524290 | 15693.5 ± 0.3% | 1476.4 ± 0.2% | 1091.3 ± 0.4% | 636.2 ± 0.4% | 995.8 ± 0.1% | 735.2 ± 0.3% | 10.630 | 14.380 | 24.666 | 15.759 | 21.347 |
| hex: http/js-1kx1024 | 2099200 | 13729.2 ± 0.3% | 1456.0 ± 0.2% | 1064.5 ± 0.2% | 500.1 ± 0.1% | 983.6 ± 0.3% | 692.1 ± 0.3% | 9.430 | 12.897 | 27.454 | 13.959 | 19.836 |
| hex: http/js-16kx64 | 2097280 | 15282.5 ± 0.3% | 1444.6 ± 0.3% | 1074.7 ± 0.2% | 504.1 ± 0.6% | 998.2 ± 0.3% | 735.6 ± 0.2% | 10.579 | 14.221 | 30.315 | 15.310 | 20.774 |
| hex: http/js-1m | 524290 | 15658.3 ± 0.4% | 1470.0 ± 0.3% | 1084.5 ± 0.5% | 510.4 ± 0.4% | 989.7 ± 0.5% | 737.4 ± 0.5% | 10.652 | 14.438 | 30.677 | 15.822 | 21.235 |
| hex: http/css-1kx1024 | 2099200 | 13707.9 ± 0.6% | 1455.7 ± 0.2% | 1063.3 ± 0.2% | 531.8 ± 0.2% | 983.6 ± 0.1% | 692.0 ± 0.1% | 9.417 | 12.892 | 25.776 | 13.937 | 19.809 |
| hex: http/css-16kx64 | 2097280 | 15332.1 ± 0.4% | 1445.1 ± 0.1% | 1075.8 ± 0.1% | 541.0 ± 0.5% | 997.3 ± 0.4% | 735.6 ± 0.3% | 10.610 | 14.251 | 28.339 | 15.374 | 20.844 |
| hex: http/css-1m | 524290 | 15682.8 ± 0.1% | 1471.6 ± 0.4% | 1089.6 ± 0.3% | 529.7 ± 0.7% | 992.3 ± 0.6% | 736.2 ± 0.4% | 10.657 | 14.393 | 29.606 | 15.804 | 21.301 |
| hex: shuffled/dickens-1m | 524290 | 15701.2 ± 0.2% | 1468.8 ± 0.3% | 1085.9 ± 0.7% | 491.6 ± 1.8% | 994.8 ± 0.6% | 736.7 ± 0.5% | 10.690 | 14.459 | 31.941 | 15.784 | 21.313 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1535.5 ± 0.4% | 1260.5 ± 0.2% | 1046.4 ± 0.4% | 410.3 ± 0.4% | 448.8 ± 0.4% | 417.5 ± 0.3% | 1.218 | 1.467 | 3.742 | 3.421 | 3.678 |
| qlog records, JSON text sequence | 1467503 | 1295.8 ± 0.5% | 1065.2 ± 0.5% | 791.3 ± 0.5% | 377.7 ± 0.8% | 468.3 ± 0.7% | 278.5 ± 0.3% | 1.217 | 1.638 | 3.431 | 2.767 | 4.652 |
| string: silesia/dickens | 172528 | 7134.6 ± 0.3% | 2815.2 ± 0.4% | 2934.7 ± 0.5% | 431.4 ± 0.3% | 1590.8 ± 0.8% | 1010.8 ± 0.2% | 2.534 | 2.431 | 16.538 | 4.485 | 7.058 |
| string: silesia/nci | 1075110 | 7383.5 ± 6.7% | 3415.0 ± 0.9% | 3101.5 ± 0.6% | 821.5 ± 3.1% | 1866.6 ± 0.3% | 1111.5 ± 0.4% | 2.162 | 2.381 | 8.988 | 3.956 | 6.643 |
| string: silesia/reymont | 1075159 | 3508.7 ± 2.2% | 1989.4 ± 1.9% | 2063.1 ± 0.4% | 451.7 ± 0.5% | 1511.5 ± 0.7% | 953.6 ± 0.4% | 1.764 | 1.701 | 7.768 | 2.321 | 3.679 |
| string: silesia/samba | 97582 | 4569.5 ± 1.1% | 2120.4 ± 0.8% | 3453.7 ± 0.3% | 353.2 ± 1.0% | 1436.1 ± 0.2% | 1055.6 ± 0.3% | 2.155 | 1.323 | 12.937 | 3.182 | 4.329 |
| string: silesia/webster | 1098490 | 4095.7 ± 0.4% | 1885.4 ± 0.5% | 2059.1 ± 0.4% | 443.0 ± 0.3% | 1398.0 ± 0.3% | 646.3 ± 1.1% | 2.172 | 1.989 | 9.246 | 2.930 | 6.337 |
| string: silesia/xml | 1090118 | 6220.0 ± 0.6% | 2881.4 ± 0.7% | 2652.0 ± 0.5% | 608.9 ± 0.1% | 1756.0 ± 0.4% | 923.0 ± 0.7% | 2.159 | 2.345 | 10.215 | 3.542 | 6.739 |
| string: canterbury/alice29.txt | 159425 | 6803.1 ± 2.8% | 2197.4 ± 0.4% | 2762.2 ± 0.7% | 406.9 ± 0.8% | 1480.4 ± 0.6% | 954.9 ± 0.4% | 3.096 | 2.463 | 16.718 | 4.595 | 7.125 |
| string: canterbury/asyoulik.txt | 132198 | 5834.5 ± 2.9% | 1716.4 ± 0.7% | 2366.4 ± 1.1% | 401.0 ± 0.6% | 1349.6 ± 0.7% | 885.6 ± 0.2% | 3.399 | 2.466 | 14.551 | 4.323 | 6.588 |
| string: canterbury/lcet10.txt | 441884 | 6253.8 ± 0.5% | 2572.0 ± 0.4% | 2518.0 ± 2.1% | 467.7 ± 0.8% | 1542.3 ± 0.6% | 988.8 ± 0.5% | 2.431 | 2.484 | 13.372 | 4.055 | 6.324 |
| string: canterbury/plrabn12.txt | 503330 | 5758.2 ± 0.9% | 2064.5 ± 0.4% | 2071.1 ± 0.5% | 424.2 ± 0.9% | 1432.7 ± 0.3% | 936.3 ± 0.6% | 2.789 | 2.780 | 13.574 | 4.019 | 6.150 |
| string: canterbury-large/E.coli | 1048578 | 19426.2 ± 0.4% | 9873.0 ± 0.7% | 3796.4 ± 0.5% | 1483.1 ± 0.7% | 2368.8 ± 1.1% | 1195.5 ± 0.7% | 1.968 | 5.117 | 13.099 | 8.201 | 16.250 |
| string: canterbury-large/bible.txt | 1055886 | 6799.0 ± 0.6% | 4175.8 ± 1.1% | 3064.6 ± 1.8% | 505.3 ± 0.3% | 1975.8 ± 0.2% | 1125.2 ± 1.2% | 1.628 | 2.219 | 13.456 | 3.441 | 6.043 |
| string: canterbury-large/world192.txt | 1103121 | 4029.1 ± 0.5% | 1660.1 ± 0.2% | 2004.2 ± 0.8% | 447.4 ± 0.3% | 1361.6 ± 0.4% | 909.9 ± 0.4% | 2.427 | 2.010 | 9.005 | 2.959 | 4.428 |
| string: http/html-1m | 1058582 | 6827.4 ± 0.6% | 4011.2 ± 0.3% | 3045.8 ± 0.3% | 500.8 ± 0.7% | 1921.3 ± 0.3% | 807.6 ± 0.6% | 1.702 | 2.242 | 13.634 | 3.554 | 8.454 |
| string: http/json-1m | 1190272 | 3307.6 ± 0.4% | 1351.5 ± 0.4% | 1558.5 ± 0.4% | 444.1 ± 0.3% | 962.3 ± 0.1% | 767.7 ± 0.3% | 2.447 | 2.122 | 7.448 | 3.437 | 4.308 |
| string: http/js-1m | 1144362 | 2798.7 ± 0.4% | 1181.2 ± 0.5% | 1631.4 ± 0.3% | 368.8 ± 0.2% | 1096.3 ± 0.2% | 760.3 ± 0.4% | 2.369 | 1.715 | 7.588 | 2.553 | 3.681 |
| string: http/css-1m | 1097820 | 4026.2 ± 0.5% | 1491.3 ± 0.6% | 2149.4 ± 0.8% | 494.3 ± 0.2% | 1370.0 ± 0.4% | 894.9 ± 0.4% | 2.700 | 1.873 | 8.144 | 2.939 | 4.499 |
| string: dickens as Cyrillic and CJK | 1883069 | 3079.5 ± 0.3% | 2349.3 ± 0.6% | 522.1 ± 0.2% | 307.0 ± 0.6% | 561.2 ± 1.0% | 336.6 ± 0.2% | 1.311 | 5.898 | 10.032 | 5.488 | 9.149 |
| hex: silesia/dickens | 524290 | 15688.1 ± 0.7% | 1469.7 ± 0.2% | 1084.0 ± 0.3% | 503.1 ± 1.1% | 988.4 ± 0.6% | 737.0 ± 0.5% | 10.675 | 14.473 | 31.180 | 15.872 | 21.287 |
| hex: silesia/mozilla | 524290 | 15679.0 ± 0.5% | 1479.5 ± 0.3% | 1092.6 ± 0.7% | 441.3 ± 0.3% | 996.9 ± 0.4% | 736.0 ± 0.4% | 10.598 | 14.350 | 35.527 | 15.727 | 21.304 |
| hex: silesia/mr | 524290 | 15694.4 ± 0.2% | 1486.6 ± 0.3% | 1094.6 ± 0.5% | 554.4 ± 0.9% | 997.2 ± 0.4% | 736.8 ± 0.4% | 10.557 | 14.338 | 28.311 | 15.738 | 21.302 |
| hex: silesia/nci | 524290 | 15698.7 ± 0.4% | 1477.0 ± 0.7% | 1091.7 ± 0.6% | 644.0 ± 3.0% | 994.2 ± 0.4% | 737.7 ± 0.6% | 10.629 | 14.380 | 24.377 | 15.790 | 21.282 |
| hex: silesia/ooffice | 524290 | 15682.4 ± 0.3% | 1467.9 ± 0.3% | 1088.4 ± 0.2% | 389.9 ± 0.3% | 992.4 ± 0.6% | 736.6 ± 0.6% | 10.684 | 14.409 | 40.218 | 15.802 | 21.289 |
| hex: silesia/osdb | 524290 | 15631.2 ± 0.4% | 1472.4 ± 0.2% | 1089.3 ± 0.5% | 476.9 ± 1.7% | 994.1 ± 0.5% | 737.9 ± 0.5% | 10.616 | 14.349 | 32.776 | 15.725 | 21.183 |
| hex: silesia/reymont | 524290 | 15659.7 ± 0.5% | 1474.9 ± 0.5% | 1091.1 ± 0.4% | 514.2 ± 0.5% | 988.2 ± 0.4% | 737.6 ± 0.4% | 10.617 | 14.352 | 30.453 | 15.846 | 21.231 |
| hex: silesia/samba | 524290 | 15667.9 ± 0.5% | 1471.9 ± 0.4% | 1089.1 ± 0.5% | 402.2 ± 0.5% | 995.5 ± 0.5% | 736.3 ± 0.5% | 10.644 | 14.386 | 38.952 | 15.739 | 21.279 |
| hex: silesia/sao | 524290 | 15605.2 ± 0.1% | 1468.0 ± 0.3% | 1086.3 ± 0.6% | 333.2 ± 0.7% | 992.0 ± 0.3% | 737.9 ± 0.3% | 10.630 | 14.366 | 46.841 | 15.731 | 21.147 |
| hex: silesia/webster | 524290 | 15695.9 ± 0.3% | 1470.3 ± 0.3% | 1088.0 ± 0.2% | 476.3 ± 0.4% | 994.7 ± 0.3% | 737.3 ± 0.5% | 10.676 | 14.427 | 32.952 | 15.780 | 21.288 |
| hex: silesia/x-ray | 524290 | 15540.3 ± 0.3% | 1481.4 ± 0.2% | 1092.8 ± 0.4% | 443.6 ± 1.2% | 996.2 ± 0.4% | 736.7 ± 0.5% | 10.490 | 14.221 | 35.031 | 15.600 | 21.095 |
| hex: silesia/xml | 524290 | 15650.5 ± 0.3% | 1473.3 ± 0.6% | 1090.7 ± 0.3% | 615.0 ± 0.6% | 994.4 ± 0.4% | 736.9 ± 0.6% | 10.623 | 14.349 | 25.449 | 15.739 | 21.237 |
| hex: canterbury/alice29.txt | 304180 | 15702.3 ± 0.1% | 1474.0 ± 0.5% | 1094.2 ± 0.2% | 503.9 ± 0.5% | 994.1 ± 0.3% | 738.4 ± 0.5% | 10.653 | 14.350 | 31.162 | 15.795 | 21.267 |
| hex: canterbury/asyoulik.txt | 250360 | 15720.2 ± 0.0% | 1477.3 ± 0.6% | 1095.1 ± 0.2% | 498.7 ± 0.9% | 996.7 ± 0.5% | 742.1 ± 0.2% | 10.641 | 14.356 | 31.524 | 15.772 | 21.185 |
| hex: canterbury/cp.html | 49208 | 15636.8 ± 0.0% | 1472.5 ± 0.6% | 1098.0 ± 0.2% | 530.6 ± 3.4% | 1000.5 ± 0.6% | 743.2 ± 0.2% | 10.619 | 14.241 | 29.469 | 15.628 | 21.040 |
| hex: canterbury/fields.c | 22302 | 15450.5 ± 0.1% | 1407.1 ± 0.7% | 1068.4 ± 0.7% | 635.9 ± 8.9% | 989.1 ± 0.5% | 736.8 ± 0.2% | 10.980 | 14.462 | 24.297 | 15.621 | 20.969 |
| hex: canterbury/grammar.lsp | 7444 | 14993.4 ± 0.1% | 1504.1 ± 0.2% | 1089.4 ± 0.9% | 685.3 ± 5.3% | 995.4 ± 0.5% | 725.4 ± 0.2% | 9.968 | 13.763 | 21.879 | 15.062 | 20.669 |
| hex: canterbury/kennedy.xls | 524290 | 15665.8 ± 0.3% | 1483.1 ± 0.5% | 1092.1 ± 0.4% | 657.9 ± 0.9% | 992.0 ± 0.4% | 738.1 ± 0.5% | 10.563 | 14.344 | 23.811 | 15.793 | 21.223 |
| hex: canterbury/lcet10.txt | 524290 | 15647.8 ± 0.5% | 1465.0 ± 0.3% | 1084.4 ± 0.5% | 501.3 ± 0.7% | 991.4 ± 0.2% | 735.8 ± 0.7% | 10.681 | 14.430 | 31.213 | 15.783 | 21.266 |
| hex: canterbury/plrabn12.txt | 524290 | 15642.5 ± 0.4% | 1471.4 ± 0.4% | 1085.7 ± 0.3% | 495.0 ± 0.5% | 991.1 ± 0.5% | 737.4 ± 0.4% | 10.631 | 14.408 | 31.602 | 15.783 | 21.213 |
| hex: canterbury/ptt5 | 524290 | 15647.9 ± 0.2% | 1486.3 ± 0.3% | 1095.4 ± 0.3% | 557.5 ± 1.1% | 994.9 ± 0.4% | 737.4 ± 0.6% | 10.528 | 14.285 | 28.068 | 15.728 | 21.221 |
| hex: canterbury/sum | 76482 | 15664.8 ± 0.0% | 1494.6 ± 0.1% | 1104.7 ± 0.2% | 589.6 ± 2.6% | 998.1 ± 0.1% | 744.3 ± 0.1% | 10.481 | 14.180 | 26.569 | 15.694 | 21.046 |
| hex: canterbury/xargs.1 | 8456 | 15035.2 ± 0.0% | 1430.1 ± 1.7% | 1088.6 ± 0.7% | 647.3 ± 5.6% | 997.5 ± 0.1% | 727.6 ± 0.7% | 10.513 | 13.811 | 23.228 | 15.073 | 20.663 |
| hex: canterbury-large/E.coli | 524290 | 15659.1 ± 0.3% | 1477.5 ± 0.4% | 1093.6 ± 0.9% | 673.1 ± 0.8% | 993.5 ± 0.3% | 738.1 ± 0.2% | 10.598 | 14.318 | 23.263 | 15.762 | 21.215 |
| hex: canterbury-large/bible.txt | 524290 | 15659.0 ± 0.1% | 1465.4 ± 0.4% | 1083.3 ± 0.4% | 516.9 ± 0.8% | 989.8 ± 0.7% | 737.6 ± 0.4% | 10.686 | 14.455 | 30.295 | 15.820 | 21.229 |
| hex: canterbury-large/world192.txt | 524290 | 15660.0 ± 0.3% | 1469.8 ± 0.1% | 1088.2 ± 0.2% | 504.0 ± 0.7% | 991.8 ± 0.7% | 737.4 ± 0.6% | 10.654 | 14.391 | 31.072 | 15.789 | 21.237 |
| hex: http/html-1kx1024 | 2099200 | 13945.2 ± 0.4% | 1454.2 ± 0.4% | 1061.3 ± 0.3% | 502.6 ± 0.2% | 982.8 ± 0.1% | 692.1 ± 0.2% | 9.590 | 13.139 | 27.745 | 14.190 | 20.149 |
| hex: http/html-16kx64 | 2097280 | 15322.4 ± 0.6% | 1444.2 ± 0.1% | 1074.7 ± 0.2% | 507.3 ± 0.4% | 996.2 ± 0.1% | 735.3 ± 0.1% | 10.610 | 14.258 | 30.207 | 15.380 | 20.839 |
| hex: http/html-1m | 524290 | 15685.0 ± 0.2% | 1471.4 ± 0.3% | 1086.1 ± 1.1% | 501.6 ± 0.4% | 992.5 ± 0.5% | 737.4 ± 0.6% | 10.660 | 14.442 | 31.272 | 15.804 | 21.272 |
| hex: http/json-1kx1024 | 2099200 | 13854.5 ± 0.4% | 1464.3 ± 0.3% | 1068.7 ± 1.0% | 610.5 ± 0.2% | 986.7 ± 0.2% | 692.0 ± 0.1% | 9.462 | 12.963 | 22.695 | 14.041 | 20.020 |
| hex: http/json-16kx64 | 2097280 | 15302.6 ± 0.6% | 1447.3 ± 0.2% | 1076.4 ± 0.2% | 614.8 ± 0.8% | 997.1 ± 0.3% | 734.5 ± 0.2% | 10.573 | 14.216 | 24.891 | 15.347 | 20.834 |
| hex: http/json-1m | 524290 | 15706.6 ± 0.2% | 1476.4 ± 0.2% | 1091.3 ± 0.4% | 636.2 ± 0.4% | 995.8 ± 0.1% | 735.2 ± 0.3% | 10.639 | 14.392 | 24.686 | 15.772 | 21.365 |
| hex: http/js-1kx1024 | 2099200 | 13867.3 ± 0.5% | 1456.0 ± 0.2% | 1064.5 ± 0.2% | 500.1 ± 0.1% | 983.6 ± 0.3% | 692.1 ± 0.3% | 9.524 | 13.027 | 27.730 | 14.099 | 20.036 |
| hex: http/js-16kx64 | 2097280 | 15286.5 ± 0.4% | 1444.6 ± 0.3% | 1074.7 ± 0.2% | 504.1 ± 0.6% | 998.2 ± 0.3% | 735.6 ± 0.2% | 10.582 | 14.225 | 30.323 | 15.314 | 20.780 |
| hex: http/js-1m | 524290 | 15721.9 ± 0.1% | 1470.0 ± 0.3% | 1084.5 ± 0.5% | 510.4 ± 0.4% | 989.7 ± 0.5% | 737.4 ± 0.5% | 10.695 | 14.497 | 30.801 | 15.886 | 21.321 |
| hex: http/css-1kx1024 | 2099200 | 13924.8 ± 0.4% | 1455.7 ± 0.2% | 1063.3 ± 0.2% | 531.8 ± 0.2% | 983.6 ± 0.1% | 692.0 ± 0.1% | 9.566 | 13.096 | 26.184 | 14.157 | 20.122 |
| hex: http/css-16kx64 | 2097280 | 15308.1 ± 1.1% | 1445.1 ± 0.1% | 1075.8 ± 0.1% | 541.0 ± 0.5% | 997.3 ± 0.4% | 735.6 ± 0.3% | 10.593 | 14.229 | 28.295 | 15.350 | 20.812 |
| hex: http/css-1m | 524290 | 15678.2 ± 0.3% | 1471.6 ± 0.4% | 1089.6 ± 0.3% | 529.7 ± 0.7% | 992.3 ± 0.6% | 736.2 ± 0.4% | 10.654 | 14.389 | 29.598 | 15.799 | 21.295 |
| hex: shuffled/dickens-1m | 524290 | 15712.1 ± 0.3% | 1468.8 ± 0.3% | 1085.9 ± 0.7% | 491.6 ± 1.8% | 994.8 ± 0.6% | 736.7 ± 0.5% | 10.697 | 14.469 | 31.963 | 15.795 | 21.328 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.9 ± 0.3% | 931.6 ± 0.6% | 1024.4 ± 0.4% | 301.3 ± 0.6% | 667.7 ± 0.2% | 310.5 ± 1.3% | 1.007 | 0.916 | 3.113 | 1.405 | 3.021 |
| qlog records, JSON text sequence | 1467503 | 782.9 ± 0.5% | 817.3 ± 0.3% | 806.0 ± 1.1% | 243.5 ± 0.7% | 700.7 ± 0.8% | 252.7 ± 0.5% | 0.958 | 0.971 | 3.216 | 1.117 | 3.098 |
| string: silesia/dickens | 172528 | 5051.3 ± 0.4% | 1877.2 ± 0.5% | 2650.8 ± 0.3% | 361.2 ± 1.2% | 2849.0 ± 0.2% | 554.8 ± 1.7% | 2.691 | 1.906 | 13.984 | 1.773 | 9.105 |
| string: silesia/nci | 1075110 | 4319.6 ± 0.2% | 2242.5 ± 0.3% | 3006.5 ± 0.3% | 544.5 ± 0.3% | 3012.1 ± 0.4% | 604.8 ± 2.7% | 1.926 | 1.437 | 7.933 | 1.434 | 7.142 |
| string: silesia/reymont | 1075159 | 2964.0 ± 2.9% | 1828.7 ± 1.1% | 2068.2 ± 0.7% | 376.0 ± 0.4% | 2145.9 ± 1.1% | 533.7 ± 6.8% | 1.621 | 1.433 | 7.883 | 1.381 | 5.554 |
| string: silesia/samba | 97582 | 3506.0 ± 0.2% | 2025.9 ± 0.2% | 2617.2 ± 0.3% | 328.8 ± 0.6% | 1497.2 ± 0.2% | 432.0 ± 1.2% | 1.731 | 1.340 | 10.662 | 2.342 | 8.115 |
| string: silesia/webster | 1098490 | 3670.6 ± 0.9% | 1519.0 ± 0.5% | 2016.7 ± 0.6% | 359.2 ± 0.6% | 2185.7 ± 0.5% | 500.5 ± 0.4% | 2.416 | 1.820 | 10.219 | 1.679 | 7.335 |
| string: silesia/xml | 1090118 | 4824.1 ± 0.6% | 2357.4 ± 0.4% | 2531.9 ± 0.4% | 456.1 ± 0.5% | 2874.1 ± 0.3% | 568.2 ± 1.0% | 2.046 | 1.905 | 10.577 | 1.678 | 8.490 |
| string: canterbury/alice29.txt | 159425 | 4376.0 ± 1.0% | 1601.3 ± 0.2% | 2457.0 ± 0.5% | 342.2 ± 0.4% | 2499.2 ± 0.7% | 507.3 ± 1.5% | 2.733 | 1.781 | 12.789 | 1.751 | 8.626 |
| string: canterbury/asyoulik.txt | 132198 | 3492.5 ± 1.1% | 1459.2 ± 0.3% | 2241.8 ± 1.0% | 334.8 ± 0.4% | 2074.1 ± 0.6% | 460.9 ± 1.7% | 2.393 | 1.558 | 10.432 | 1.684 | 7.577 |
| string: canterbury/lcet10.txt | 441884 | 5129.5 ± 0.2% | 1854.8 ± 0.2% | 2355.7 ± 0.9% | 389.8 ± 0.6% | 2834.4 ± 1.0% | 533.5 ± 1.3% | 2.765 | 2.177 | 13.159 | 1.810 | 9.615 |
| string: canterbury/plrabn12.txt | 503330 | 4137.3 ± 0.4% | 1735.6 ± 0.2% | 2061.6 ± 0.5% | 360.0 ± 0.5% | 2502.6 ± 0.6% | 496.9 ± 1.5% | 2.384 | 2.007 | 11.494 | 1.653 | 8.327 |
| string: canterbury-large/E.coli | 1048578 | 11928.5 ± 0.4% | 3608.8 ± 0.4% | 3264.3 ± 0.4% | 932.7 ± 1.0% | 6038.5 ± 1.6% | 756.4 ± 1.6% | 3.305 | 3.654 | 12.789 | 1.975 | 15.771 |
| string: canterbury-large/bible.txt | 1055886 | 6912.8 ± 0.6% | 2943.6 ± 0.3% | 2846.9 ± 1.3% | 422.6 ± 2.6% | 3768.5 ± 1.2% | 612.1 ± 1.8% | 2.348 | 2.428 | 16.358 | 1.834 | 11.294 |
| string: canterbury-large/world192.txt | 1103121 | 3399.6 ± 0.7% | 1483.1 ± 0.2% | 2012.3 ± 0.5% | 352.7 ± 0.2% | 2126.5 ± 1.1% | 498.4 ± 0.4% | 2.292 | 1.689 | 9.638 | 1.599 | 6.820 |
| string: http/html-1m | 1058582 | 6221.2 ± 1.1% | 2737.8 ± 0.4% | 2708.7 ± 0.4% | 441.7 ± 0.4% | 3482.3 ± 0.5% | 596.5 ± 1.2% | 2.272 | 2.297 | 14.085 | 1.786 | 10.429 |
| string: http/json-1m | 1190272 | 2560.5 ± 0.3% | 878.2 ± 0.2% | 2253.4 ± 0.5% | 389.8 ± 0.2% | 1066.5 ± 0.7% | 439.6 ± 0.6% | 2.916 | 1.136 | 6.568 | 2.401 | 5.824 |
| string: http/js-1m | 1144362 | 2293.8 ± 0.7% | 1029.7 ± 0.2% | 1640.3 ± 0.4% | 319.8 ± 0.6% | 1529.0 ± 0.3% | 415.7 ± 0.8% | 2.228 | 1.398 | 7.173 | 1.500 | 5.519 |
| string: http/css-1m | 1097820 | 2652.6 ± 0.6% | 1679.2 ± 0.3% | 2223.3 ± 0.9% | 405.2 ± 0.5% | 1960.9 ± 0.6% | 486.3 ± 0.6% | 1.580 | 1.193 | 6.546 | 1.353 | 5.455 |
| string: dickens as Cyrillic and CJK | 1883069 | 3086.8 ± 0.3% | 1685.7 ± 0.3% | 893.7 ± 0.6% | 351.6 ± 0.2% | 669.3 ± 1.5% | 157.0 ± 1.4% | 1.831 | 3.454 | 8.779 | 4.612 | 19.663 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.6 ± 0.3% | 981.2 ± 0.3% | 1198.8 ± 0.4% | 215.9 ± 0.2% | 471.6 ± 1.0% | 251.6 ± 4.3% | 1.356 | 1.110 | 6.162 | 2.821 | 5.289 |
| hex: silesia/dickens | 524290 | 11999.7 ± 0.1% | 3622.7 ± 0.2% | 3292.3 ± 0.4% | 517.7 ± 2.4% | 6074.6 ± 1.6% | 784.0 ± 2.6% | 3.312 | 3.645 | 23.178 | 1.975 | 15.306 |
| hex: silesia/mozilla | 524290 | 12019.1 ± 0.2% | 3622.4 ± 0.2% | 3297.9 ± 0.3% | 454.4 ± 1.5% | 6134.0 ± 1.2% | 782.1 ± 0.4% | 3.318 | 3.645 | 26.450 | 1.959 | 15.368 |
| hex: silesia/mr | 524290 | 11983.6 ± 0.3% | 3620.0 ± 0.3% | 3301.7 ± 0.2% | 569.8 ± 2.7% | 6068.4 ± 1.8% | 781.8 ± 0.5% | 3.310 | 3.630 | 21.030 | 1.975 | 15.329 |
| hex: silesia/nci | 524290 | 12012.3 ± 0.2% | 3622.0 ± 0.2% | 3290.0 ± 0.7% | 622.5 ± 1.6% | 6141.9 ± 2.1% | 780.6 ± 0.2% | 3.316 | 3.651 | 19.296 | 1.956 | 15.389 |
| hex: silesia/ooffice | 524290 | 12019.0 ± 0.1% | 3621.6 ± 0.1% | 3305.5 ± 0.4% | 395.0 ± 1.0% | 6102.0 ± 1.2% | 781.5 ± 0.3% | 3.319 | 3.636 | 30.431 | 1.970 | 15.380 |
| hex: silesia/osdb | 524290 | 11974.1 ± 0.1% | 3620.2 ± 0.2% | 3296.1 ± 0.2% | 474.9 ± 1.6% | 5984.9 ± 0.3% | 781.4 ± 0.6% | 3.308 | 3.633 | 25.213 | 2.001 | 15.323 |
| hex: silesia/reymont | 524290 | 12012.9 ± 0.1% | 3620.5 ± 0.2% | 3308.8 ± 0.3% | 509.4 ± 0.8% | 6104.2 ± 1.9% | 781.7 ± 0.2% | 3.318 | 3.631 | 23.582 | 1.968 | 15.368 |
| hex: silesia/samba | 524290 | 11951.1 ± 0.1% | 3622.3 ± 0.2% | 3302.3 ± 0.2% | 401.4 ± 0.8% | 6152.2 ± 0.7% | 783.1 ± 0.1% | 3.299 | 3.619 | 29.771 | 1.943 | 15.261 |
| hex: silesia/sao | 524290 | 12015.2 ± 0.1% | 3619.5 ± 0.2% | 3301.6 ± 0.4% | 341.6 ± 0.4% | 6156.8 ± 2.1% | 782.3 ± 0.4% | 3.320 | 3.639 | 35.174 | 1.952 | 15.359 |
| hex: silesia/webster | 524290 | 12013.2 ± 0.1% | 3620.6 ± 0.1% | 3298.2 ± 0.3% | 467.8 ± 0.8% | 6114.8 ± 1.8% | 782.8 ± 0.9% | 3.318 | 3.642 | 25.679 | 1.965 | 15.346 |
| hex: silesia/x-ray | 524290 | 11996.5 ± 0.1% | 3620.7 ± 0.2% | 3309.3 ± 0.4% | 471.6 ± 0.8% | 6113.1 ± 1.1% | 782.6 ± 0.4% | 3.313 | 3.625 | 25.437 | 1.962 | 15.328 |
| hex: silesia/xml | 524290 | 11961.0 ± 0.1% | 3622.8 ± 0.1% | 3296.8 ± 0.3% | 521.3 ± 1.3% | 6065.7 ± 0.5% | 782.6 ± 0.2% | 3.302 | 3.628 | 22.944 | 1.972 | 15.284 |
| hex: canterbury/alice29.txt | 304180 | 12004.4 ± 0.1% | 3635.7 ± 0.1% | 3365.3 ± 0.1% | 500.8 ± 5.6% | 6125.0 ± 1.7% | 781.1 ± 0.5% | 3.302 | 3.567 | 23.972 | 1.960 | 15.368 |
| hex: canterbury/asyoulik.txt | 250360 | 11999.6 ± 0.1% | 3641.4 ± 0.0% | 3375.9 ± 0.2% | 497.5 ± 0.7% | 6107.3 ± 2.2% | 780.8 ± 0.4% | 3.295 | 3.554 | 24.119 | 1.965 | 15.369 |
| hex: canterbury/cp.html | 49208 | 11925.2 ± 0.0% | 3638.1 ± 0.1% | 3279.3 ± 0.3% | 467.9 ± 3.2% | 6247.0 ± 1.9% | 765.7 ± 1.7% | 3.278 | 3.636 | 25.485 | 1.909 | 15.574 |
| hex: canterbury/fields.c | 22302 | 11778.2 ± 0.0% | 3625.8 ± 0.1% | 3397.0 ± 0.4% | 498.1 ± 0.7% | 6257.6 ± 0.4% | 759.0 ± 1.8% | 3.248 | 3.467 | 23.647 | 1.882 | 15.518 |
| hex: canterbury/grammar.lsp | 7444 | 11254.6 ± 0.2% | 3599.8 ± 0.1% | 3355.3 ± 0.5% | 540.4 ± 3.6% | 6185.3 ± 0.7% | 731.4 ± 1.8% | 3.126 | 3.354 | 20.825 | 1.820 | 15.387 |
| hex: canterbury/kennedy.xls | 524290 | 11975.6 ± 0.2% | 3617.9 ± 0.3% | 3297.2 ± 0.4% | 654.9 ± 5.4% | 6098.3 ± 2.0% | 785.5 ± 5.8% | 3.310 | 3.632 | 18.286 | 1.964 | 15.246 |
| hex: canterbury/lcet10.txt | 524290 | 12002.9 ± 0.1% | 3623.7 ± 0.3% | 3300.8 ± 0.8% | 509.3 ± 3.2% | 6142.3 ± 0.7% | 787.0 ± 0.4% | 3.312 | 3.636 | 23.569 | 1.954 | 15.252 |
| hex: canterbury/plrabn12.txt | 524290 | 11964.4 ± 0.6% | 3621.2 ± 0.2% | 3310.8 ± 0.3% | 504.4 ± 0.6% | 6059.3 ± 1.9% | 784.9 ± 0.3% | 3.304 | 3.614 | 23.718 | 1.975 | 15.243 |
| hex: canterbury/ptt5 | 524290 | 11986.6 ± 0.1% | 3620.3 ± 0.2% | 3294.8 ± 0.3% | 557.1 ± 0.9% | 6119.5 ± 1.4% | 787.8 ± 0.3% | 3.311 | 3.638 | 21.517 | 1.959 | 15.216 |
| hex: canterbury/sum | 76482 | 11915.2 ± 0.1% | 3633.4 ± 0.1% | 3357.1 ± 0.5% | 509.7 ± 1.4% | 6178.3 ± 0.7% | 778.0 ± 1.3% | 3.279 | 3.549 | 23.375 | 1.929 | 15.316 |
| hex: canterbury/xargs.1 | 8456 | 11346.1 ± 0.1% | 3602.8 ± 0.0% | 3378.6 ± 0.3% | 492.6 ± 1.9% | 6152.6 ± 0.7% | 758.4 ± 2.1% | 3.149 | 3.358 | 23.032 | 1.844 | 14.960 |
| hex: canterbury-large/E.coli | 524290 | 11958.7 ± 0.1% | 3615.4 ± 0.1% | 3295.5 ± 0.3% | 689.1 ± 0.1% | 6141.6 ± 2.2% | 781.3 ± 3.9% | 3.308 | 3.629 | 17.353 | 1.947 | 15.305 |
| hex: canterbury-large/bible.txt | 524290 | 12004.1 ± 0.1% | 3619.9 ± 0.3% | 3300.1 ± 0.3% | 522.1 ± 0.5% | 6119.9 ± 1.5% | 783.1 ± 0.5% | 3.316 | 3.638 | 22.993 | 1.961 | 15.330 |
| hex: canterbury-large/world192.txt | 524290 | 11971.7 ± 0.2% | 3619.1 ± 0.3% | 3295.7 ± 0.5% | 496.6 ± 2.1% | 6081.0 ± 1.5% | 783.1 ± 0.5% | 3.308 | 3.633 | 24.109 | 1.969 | 15.287 |
| hex: http/html-1kx1024 | 2099200 | 8957.9 ± 2.8% | 3464.2 ± 0.2% | 2897.2 ± 0.7% | 475.7 ± 1.5% | 5167.4 ± 0.7% | 652.3 ± 1.0% | 2.586 | 3.092 | 18.832 | 1.734 | 13.733 |
| hex: http/html-16kx64 | 2097280 | 11788.7 ± 0.3% | 3612.5 ± 0.1% | 3277.8 ± 0.2% | 478.2 ± 1.2% | 6020.1 ± 0.6% | 754.3 ± 2.8% | 3.263 | 3.596 | 24.652 | 1.958 | 15.628 |
| hex: http/html-1m | 524290 | 12022.0 ± 0.1% | 3611.9 ± 0.3% | 3308.8 ± 0.3% | 494.2 ± 1.7% | 6096.1 ± 0.9% | 783.1 ± 1.1% | 3.328 | 3.633 | 24.326 | 1.972 | 15.352 |
| hex: http/json-1kx1024 | 2099200 | 8937.5 ± 3.6% | 3463.1 ± 0.2% | 2895.1 ± 0.8% | 576.1 ± 0.4% | 5178.5 ± 2.3% | 660.5 ± 11.3% | 2.581 | 3.087 | 15.515 | 1.726 | 13.532 |
| hex: http/json-16kx64 | 2097280 | 11761.2 ± 2.5% | 3611.5 ± 0.1% | 3269.7 ± 0.3% | 570.3 ± 0.8% | 6028.2 ± 0.2% | 763.5 ± 1.9% | 3.257 | 3.597 | 20.623 | 1.951 | 15.405 |
| hex: http/json-1m | 524290 | 12018.5 ± 0.2% | 3620.2 ± 0.1% | 3307.2 ± 0.5% | 593.2 ± 2.6% | 6155.6 ± 0.9% | 786.2 ± 0.2% | 3.320 | 3.634 | 20.259 | 1.952 | 15.287 |
| hex: http/js-1kx1024 | 2099200 | 8965.6 ± 1.4% | 3456.7 ± 0.3% | 2907.5 ± 0.3% | 479.7 ± 0.5% | 5150.8 ± 1.1% | 651.7 ± 3.6% | 2.594 | 3.084 | 18.692 | 1.741 | 13.758 |
| hex: http/js-16kx64 | 2097280 | 11778.5 ± 0.3% | 3608.9 ± 0.1% | 3280.5 ± 0.2% | 478.5 ± 1.3% | 6026.6 ± 0.3% | 759.8 ± 1.2% | 3.264 | 3.591 | 24.614 | 1.954 | 15.501 |
| hex: http/js-1m | 524290 | 11958.4 ± 0.2% | 3619.8 ± 0.2% | 3296.6 ± 0.4% | 507.4 ± 1.5% | 6112.0 ± 1.7% | 772.2 ± 2.7% | 3.304 | 3.627 | 23.568 | 1.957 | 15.486 |
| hex: http/css-1kx1024 | 2099200 | 8932.9 ± 3.5% | 3464.7 ± 0.2% | 2906.4 ± 0.4% | 489.5 ± 0.6% | 5160.5 ± 1.5% | 648.4 ± 1.9% | 2.578 | 3.074 | 18.250 | 1.731 | 13.776 |
| hex: http/css-16kx64 | 2097280 | 11777.6 ± 0.2% | 3610.4 ± 0.1% | 3269.0 ± 0.3% | 494.2 ± 1.3% | 6022.3 ± 0.3% | 759.0 ± 2.1% | 3.262 | 3.603 | 23.830 | 1.956 | 15.518 |
| hex: http/css-1m | 524290 | 12002.7 ± 0.2% | 3620.3 ± 0.7% | 3305.2 ± 0.1% | 492.7 ± 1.5% | 6120.7 ± 1.7% | 783.3 ± 4.9% | 3.315 | 3.632 | 24.359 | 1.961 | 15.322 |
| hex: shuffled/dickens-1m | 524290 | 12010.9 ± 0.0% | 3623.5 ± 0.3% | 3293.2 ± 0.3% | 512.5 ± 3.1% | 6101.0 ± 1.7% | 787.9 ± 0.6% | 3.315 | 3.647 | 23.434 | 1.969 | 15.243 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1015.3 ± 0.2% | 931.6 ± 0.6% | 1024.4 ± 0.4% | 301.3 ± 0.6% | 667.7 ± 0.2% | 310.5 ± 1.3% | 1.090 | 0.991 | 3.370 | 1.521 | 3.270 |
| qlog records, JSON text sequence | 1467503 | 842.5 ± 0.3% | 817.3 ± 0.3% | 806.0 ± 1.1% | 243.5 ± 0.7% | 700.7 ± 0.8% | 252.7 ± 0.5% | 1.031 | 1.045 | 3.460 | 1.202 | 3.333 |
| string: silesia/dickens | 172528 | 5056.6 ± 0.5% | 1877.2 ± 0.5% | 2650.8 ± 0.3% | 361.2 ± 1.2% | 2849.0 ± 0.2% | 554.8 ± 1.7% | 2.694 | 1.908 | 13.999 | 1.775 | 9.115 |
| string: silesia/nci | 1075110 | 4322.1 ± 0.1% | 2242.5 ± 0.3% | 3006.5 ± 0.3% | 544.5 ± 0.3% | 3012.1 ± 0.4% | 604.8 ± 2.7% | 1.927 | 1.438 | 7.938 | 1.435 | 7.146 |
| string: silesia/reymont | 1075159 | 2975.8 ± 2.8% | 1828.7 ± 1.1% | 2068.2 ± 0.7% | 376.0 ± 0.4% | 2145.9 ± 1.1% | 533.7 ± 6.8% | 1.627 | 1.439 | 7.914 | 1.387 | 5.576 |
| string: silesia/samba | 97582 | 3516.4 ± 0.2% | 2025.9 ± 0.2% | 2617.2 ± 0.3% | 328.8 ± 0.6% | 1497.2 ± 0.2% | 432.0 ± 1.2% | 1.736 | 1.344 | 10.693 | 2.349 | 8.139 |
| string: silesia/webster | 1098490 | 3684.6 ± 0.6% | 1519.0 ± 0.5% | 2016.7 ± 0.6% | 359.2 ± 0.6% | 2185.7 ± 0.5% | 500.5 ± 0.4% | 2.426 | 1.827 | 10.258 | 1.686 | 7.362 |
| string: silesia/xml | 1090118 | 4822.6 ± 0.5% | 2357.4 ± 0.4% | 2531.9 ± 0.4% | 456.1 ± 0.5% | 2874.1 ± 0.3% | 568.2 ± 1.0% | 2.046 | 1.905 | 10.574 | 1.678 | 8.488 |
| string: canterbury/alice29.txt | 159425 | 4385.2 ± 0.9% | 1601.3 ± 0.2% | 2457.0 ± 0.5% | 342.2 ± 0.4% | 2499.2 ± 0.7% | 507.3 ± 1.5% | 2.739 | 1.785 | 12.815 | 1.755 | 8.645 |
| string: canterbury/asyoulik.txt | 132198 | 3490.9 ± 1.2% | 1459.2 ± 0.3% | 2241.8 ± 1.0% | 334.8 ± 0.4% | 2074.1 ± 0.6% | 460.9 ± 1.7% | 2.392 | 1.557 | 10.428 | 1.683 | 7.574 |
| string: canterbury/lcet10.txt | 441884 | 5140.3 ± 0.3% | 1854.8 ± 0.2% | 2355.7 ± 0.9% | 389.8 ± 0.6% | 2834.4 ± 1.0% | 533.5 ± 1.3% | 2.771 | 2.182 | 13.187 | 1.814 | 9.636 |
| string: canterbury/plrabn12.txt | 503330 | 4141.2 ± 0.4% | 1735.6 ± 0.2% | 2061.6 ± 0.5% | 360.0 ± 0.5% | 2502.6 ± 0.6% | 496.9 ± 1.5% | 2.386 | 2.009 | 11.505 | 1.655 | 8.335 |
| string: canterbury-large/E.coli | 1048578 | 11949.7 ± 0.5% | 3608.8 ± 0.4% | 3264.3 ± 0.4% | 932.7 ± 1.0% | 6038.5 ± 1.6% | 756.4 ± 1.6% | 3.311 | 3.661 | 12.812 | 1.979 | 15.799 |
| string: canterbury-large/bible.txt | 1055886 | 6919.9 ± 0.4% | 2943.6 ± 0.3% | 2846.9 ± 1.3% | 422.6 ± 2.6% | 3768.5 ± 1.2% | 612.1 ± 1.8% | 2.351 | 2.431 | 16.375 | 1.836 | 11.305 |
| string: canterbury-large/world192.txt | 1103121 | 3391.5 ± 0.5% | 1483.1 ± 0.2% | 2012.3 ± 0.5% | 352.7 ± 0.2% | 2126.5 ± 1.1% | 498.4 ± 0.4% | 2.287 | 1.685 | 9.615 | 1.595 | 6.804 |
| string: http/html-1m | 1058582 | 6260.4 ± 1.5% | 2737.8 ± 0.4% | 2708.7 ± 0.4% | 441.7 ± 0.4% | 3482.3 ± 0.5% | 596.5 ± 1.2% | 2.287 | 2.311 | 14.174 | 1.798 | 10.494 |
| string: http/json-1m | 1190272 | 2554.5 ± 0.2% | 878.2 ± 0.2% | 2253.4 ± 0.5% | 389.8 ± 0.2% | 1066.5 ± 0.7% | 439.6 ± 0.6% | 2.909 | 1.134 | 6.553 | 2.395 | 5.811 |
| string: http/js-1m | 1144362 | 2294.4 ± 0.5% | 1029.7 ± 0.2% | 1640.3 ± 0.4% | 319.8 ± 0.6% | 1529.0 ± 0.3% | 415.7 ± 0.8% | 2.228 | 1.399 | 7.175 | 1.501 | 5.520 |
| string: http/css-1m | 1097820 | 2658.4 ± 0.8% | 1679.2 ± 0.3% | 2223.3 ± 0.9% | 405.2 ± 0.5% | 1960.9 ± 0.6% | 486.3 ± 0.6% | 1.583 | 1.196 | 6.560 | 1.356 | 5.467 |
| string: dickens as Cyrillic and CJK | 1883069 | 3090.8 ± 0.8% | 1685.7 ± 0.3% | 893.7 ± 0.6% | 351.6 ± 0.2% | 669.3 ± 1.5% | 157.0 ± 1.4% | 1.834 | 3.458 | 8.790 | 4.618 | 19.689 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.3 ± 0.2% | 981.2 ± 0.3% | 1198.8 ± 0.4% | 215.9 ± 0.2% | 471.6 ± 1.0% | 251.6 ± 4.3% | 1.355 | 1.109 | 6.156 | 2.819 | 5.284 |
| hex: silesia/dickens | 524290 | 12001.3 ± 0.1% | 3622.7 ± 0.2% | 3292.3 ± 0.4% | 517.7 ± 2.4% | 6074.6 ± 1.6% | 784.0 ± 2.6% | 3.313 | 3.645 | 23.181 | 1.976 | 15.308 |
| hex: silesia/mozilla | 524290 | 12022.6 ± 0.1% | 3622.4 ± 0.2% | 3297.9 ± 0.3% | 454.4 ± 1.5% | 6134.0 ± 1.2% | 782.1 ± 0.4% | 3.319 | 3.646 | 26.458 | 1.960 | 15.372 |
| hex: silesia/mr | 524290 | 11977.0 ± 0.2% | 3620.0 ± 0.3% | 3301.7 ± 0.2% | 569.8 ± 2.7% | 6068.4 ± 1.8% | 781.8 ± 0.5% | 3.309 | 3.628 | 21.018 | 1.974 | 15.321 |
| hex: silesia/nci | 524290 | 12009.5 ± 0.2% | 3622.0 ± 0.2% | 3290.0 ± 0.7% | 622.5 ± 1.6% | 6141.9 ± 2.1% | 780.6 ± 0.2% | 3.316 | 3.650 | 19.291 | 1.955 | 15.385 |
| hex: silesia/ooffice | 524290 | 12020.1 ± 0.1% | 3621.6 ± 0.1% | 3305.5 ± 0.4% | 395.0 ± 1.0% | 6102.0 ± 1.2% | 781.5 ± 0.3% | 3.319 | 3.636 | 30.433 | 1.970 | 15.381 |
| hex: silesia/osdb | 524290 | 11997.8 ± 0.0% | 3620.2 ± 0.2% | 3296.1 ± 0.2% | 474.9 ± 1.6% | 5984.9 ± 0.3% | 781.4 ± 0.6% | 3.314 | 3.640 | 25.263 | 2.005 | 15.353 |
| hex: silesia/reymont | 524290 | 12015.2 ± 0.0% | 3620.5 ± 0.2% | 3308.8 ± 0.3% | 509.4 ± 0.8% | 6104.2 ± 1.9% | 781.7 ± 0.2% | 3.319 | 3.631 | 23.586 | 1.968 | 15.370 |
| hex: silesia/samba | 524290 | 11999.0 ± 0.1% | 3622.3 ± 0.2% | 3302.3 ± 0.2% | 401.4 ± 0.8% | 6152.2 ± 0.7% | 783.1 ± 0.1% | 3.313 | 3.634 | 29.890 | 1.950 | 15.322 |
| hex: silesia/sao | 524290 | 12007.6 ± 0.2% | 3619.5 ± 0.2% | 3301.6 ± 0.4% | 341.6 ± 0.4% | 6156.8 ± 2.1% | 782.3 ± 0.4% | 3.317 | 3.637 | 35.152 | 1.950 | 15.349 |
| hex: silesia/webster | 524290 | 12010.4 ± 1.0% | 3620.6 ± 0.1% | 3298.2 ± 0.3% | 467.8 ± 0.8% | 6114.8 ± 1.8% | 782.8 ± 0.9% | 3.317 | 3.641 | 25.673 | 1.964 | 15.343 |
| hex: silesia/x-ray | 524290 | 11981.5 ± 0.1% | 3620.7 ± 0.2% | 3309.3 ± 0.4% | 471.6 ± 0.8% | 6113.1 ± 1.1% | 782.6 ± 0.4% | 3.309 | 3.621 | 25.405 | 1.960 | 15.309 |
| hex: silesia/xml | 524290 | 11998.5 ± 0.1% | 3622.8 ± 0.1% | 3296.8 ± 0.3% | 521.3 ± 1.3% | 6065.7 ± 0.5% | 782.6 ± 0.2% | 3.312 | 3.639 | 23.016 | 1.978 | 15.332 |
| hex: canterbury/alice29.txt | 304180 | 12017.2 ± 0.0% | 3635.7 ± 0.1% | 3365.3 ± 0.1% | 500.8 ± 5.6% | 6125.0 ± 1.7% | 781.1 ± 0.5% | 3.305 | 3.571 | 23.998 | 1.962 | 15.384 |
| hex: canterbury/asyoulik.txt | 250360 | 12001.7 ± 0.1% | 3641.4 ± 0.0% | 3375.9 ± 0.2% | 497.5 ± 0.7% | 6107.3 ± 2.2% | 780.8 ± 0.4% | 3.296 | 3.555 | 24.123 | 1.965 | 15.372 |
| hex: canterbury/cp.html | 49208 | 11926.3 ± 0.1% | 3638.1 ± 0.1% | 3279.3 ± 0.3% | 467.9 ± 3.2% | 6247.0 ± 1.9% | 765.7 ± 1.7% | 3.278 | 3.637 | 25.487 | 1.909 | 15.575 |
| hex: canterbury/fields.c | 22302 | 11782.7 ± 0.1% | 3625.8 ± 0.1% | 3397.0 ± 0.4% | 498.1 ± 0.7% | 6257.6 ± 0.4% | 759.0 ± 1.8% | 3.250 | 3.469 | 23.656 | 1.883 | 15.523 |
| hex: canterbury/grammar.lsp | 7444 | 11307.0 ± 0.5% | 3599.8 ± 0.1% | 3355.3 ± 0.5% | 540.4 ± 3.6% | 6185.3 ± 0.7% | 731.4 ± 1.8% | 3.141 | 3.370 | 20.921 | 1.828 | 15.459 |
| hex: canterbury/kennedy.xls | 524290 | 11987.4 ± 0.1% | 3617.9 ± 0.3% | 3297.2 ± 0.4% | 654.9 ± 5.4% | 6098.3 ± 2.0% | 785.5 ± 5.8% | 3.313 | 3.636 | 18.304 | 1.966 | 15.261 |
| hex: canterbury/lcet10.txt | 524290 | 12002.1 ± 0.2% | 3623.7 ± 0.3% | 3300.8 ± 0.8% | 509.3 ± 3.2% | 6142.3 ± 0.7% | 787.0 ± 0.4% | 3.312 | 3.636 | 23.567 | 1.954 | 15.251 |
| hex: canterbury/plrabn12.txt | 524290 | 11950.7 ± 0.5% | 3621.2 ± 0.2% | 3310.8 ± 0.3% | 504.4 ± 0.6% | 6059.3 ± 1.9% | 784.9 ± 0.3% | 3.300 | 3.610 | 23.691 | 1.972 | 15.226 |
| hex: canterbury/ptt5 | 524290 | 11948.3 ± 0.2% | 3620.3 ± 0.2% | 3294.8 ± 0.3% | 557.1 ± 0.9% | 6119.5 ± 1.4% | 787.8 ± 0.3% | 3.300 | 3.626 | 21.449 | 1.952 | 15.167 |
| hex: canterbury/sum | 76482 | 11918.1 ± 0.2% | 3633.4 ± 0.1% | 3357.1 ± 0.5% | 509.7 ± 1.4% | 6178.3 ± 0.7% | 778.0 ± 1.3% | 3.280 | 3.550 | 23.380 | 1.929 | 15.319 |
| hex: canterbury/xargs.1 | 8456 | 11351.2 ± 0.0% | 3602.8 ± 0.0% | 3378.6 ± 0.3% | 492.6 ± 1.9% | 6152.6 ± 0.7% | 758.4 ± 2.1% | 3.151 | 3.360 | 23.042 | 1.845 | 14.967 |
| hex: canterbury-large/E.coli | 524290 | 12007.7 ± 0.2% | 3615.4 ± 0.1% | 3295.5 ± 0.3% | 689.1 ± 0.1% | 6141.6 ± 2.2% | 781.3 ± 3.9% | 3.321 | 3.644 | 17.424 | 1.955 | 15.368 |
| hex: canterbury-large/bible.txt | 524290 | 12019.0 ± 0.5% | 3619.9 ± 0.3% | 3300.1 ± 0.3% | 522.1 ± 0.5% | 6119.9 ± 1.5% | 783.1 ± 0.5% | 3.320 | 3.642 | 23.022 | 1.964 | 15.349 |
| hex: canterbury-large/world192.txt | 524290 | 11969.3 ± 0.2% | 3619.1 ± 0.3% | 3295.7 ± 0.5% | 496.6 ± 2.1% | 6081.0 ± 1.5% | 783.1 ± 0.5% | 3.307 | 3.632 | 24.104 | 1.968 | 15.284 |
| hex: http/html-1kx1024 | 2099200 | 8982.0 ± 3.5% | 3464.2 ± 0.2% | 2897.2 ± 0.7% | 475.7 ± 1.5% | 5167.4 ± 0.7% | 652.3 ± 1.0% | 2.593 | 3.100 | 18.882 | 1.738 | 13.770 |
| hex: http/html-16kx64 | 2097280 | 11793.3 ± 0.1% | 3612.5 ± 0.1% | 3277.8 ± 0.2% | 478.2 ± 1.2% | 6020.1 ± 0.6% | 754.3 ± 2.8% | 3.265 | 3.598 | 24.661 | 1.959 | 15.635 |
| hex: http/html-1m | 524290 | 12022.2 ± 0.1% | 3611.9 ± 0.3% | 3308.8 ± 0.3% | 494.2 ± 1.7% | 6096.1 ± 0.9% | 783.1 ± 1.1% | 3.328 | 3.633 | 24.326 | 1.972 | 15.352 |
| hex: http/json-1kx1024 | 2099200 | 8977.3 ± 3.4% | 3463.1 ± 0.2% | 2895.1 ± 0.8% | 576.1 ± 0.4% | 5178.5 ± 2.3% | 660.5 ± 11.3% | 2.592 | 3.101 | 15.584 | 1.734 | 13.593 |
| hex: http/json-16kx64 | 2097280 | 11778.0 ± 0.3% | 3611.5 ± 0.1% | 3269.7 ± 0.3% | 570.3 ± 0.8% | 6028.2 ± 0.2% | 763.5 ± 1.9% | 3.261 | 3.602 | 20.653 | 1.954 | 15.427 |
| hex: http/json-1m | 524290 | 12018.9 ± 0.1% | 3620.2 ± 0.1% | 3307.2 ± 0.5% | 593.2 ± 2.6% | 6155.6 ± 0.9% | 786.2 ± 0.2% | 3.320 | 3.634 | 20.260 | 1.953 | 15.288 |
| hex: http/js-1kx1024 | 2099200 | 8984.0 ± 1.6% | 3456.7 ± 0.3% | 2907.5 ± 0.3% | 479.7 ± 0.5% | 5150.8 ± 1.1% | 651.7 ± 3.6% | 2.599 | 3.090 | 18.730 | 1.744 | 13.786 |
| hex: http/js-16kx64 | 2097280 | 11788.2 ± 0.2% | 3608.9 ± 0.1% | 3280.5 ± 0.2% | 478.5 ± 1.3% | 6026.6 ± 0.3% | 759.8 ± 1.2% | 3.266 | 3.593 | 24.634 | 1.956 | 15.514 |
| hex: http/js-1m | 524290 | 11992.6 ± 0.1% | 3619.8 ± 0.2% | 3296.6 ± 0.4% | 507.4 ± 1.5% | 6112.0 ± 1.7% | 772.2 ± 2.7% | 3.313 | 3.638 | 23.636 | 1.962 | 15.530 |
| hex: http/css-1kx1024 | 2099200 | 8981.3 ± 3.8% | 3464.7 ± 0.2% | 2906.4 ± 0.4% | 489.5 ± 0.6% | 5160.5 ± 1.5% | 648.4 ± 1.9% | 2.592 | 3.090 | 18.349 | 1.740 | 13.851 |
| hex: http/css-16kx64 | 2097280 | 11789.1 ± 0.2% | 3610.4 ± 0.1% | 3269.0 ± 0.3% | 494.2 ± 1.3% | 6022.3 ± 0.3% | 759.0 ± 2.1% | 3.265 | 3.606 | 23.853 | 1.958 | 15.533 |
| hex: http/css-1m | 524290 | 11998.2 ± 0.2% | 3620.3 ± 0.7% | 3305.2 ± 0.1% | 492.7 ± 1.5% | 6120.7 ± 1.7% | 783.3 ± 4.9% | 3.314 | 3.630 | 24.350 | 1.960 | 15.317 |
| hex: shuffled/dickens-1m | 524290 | 12009.1 ± 0.1% | 3623.5 ± 0.3% | 3293.2 ± 0.3% | 512.5 ± 3.1% | 6101.0 ± 1.7% | 787.9 ± 0.6% | 3.314 | 3.647 | 23.431 | 1.968 | 15.241 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1363.3 ± 0.2% | 1260.5 ± 0.2% | 1046.4 ± 0.4% | 410.3 ± 0.4% | 448.8 ± 0.4% | 417.5 ± 0.3% | 1.082 | 1.303 | 3.322 | 3.038 | 3.265 |
| qlog records, JSON text sequence | 1467503 | 1053.3 ± 0.2% | 1065.2 ± 0.5% | 791.3 ± 0.5% | 377.7 ± 0.8% | 468.3 ± 0.7% | 278.5 ± 0.3% | 0.989 | 1.331 | 2.789 | 2.249 | 3.782 |
| string: silesia/dickens | 172528 | 6913.1 ± 0.3% | 2815.2 ± 0.4% | 2934.7 ± 0.5% | 431.4 ± 0.3% | 1590.8 ± 0.8% | 1010.8 ± 0.2% | 2.456 | 2.356 | 16.025 | 4.346 | 6.839 |
| string: silesia/nci | 1075110 | 7325.4 ± 0.7% | 3415.0 ± 0.9% | 3101.5 ± 0.6% | 821.5 ± 3.1% | 1866.6 ± 0.3% | 1111.5 ± 0.4% | 2.145 | 2.362 | 8.917 | 3.924 | 6.591 |
| string: silesia/reymont | 1075159 | 3357.9 ± 1.5% | 1989.4 ± 1.9% | 2063.1 ± 0.4% | 451.7 ± 0.5% | 1511.5 ± 0.7% | 953.6 ± 0.4% | 1.688 | 1.628 | 7.434 | 2.222 | 3.521 |
| string: silesia/samba | 97582 | 4212.2 ± 0.3% | 2120.4 ± 0.8% | 3453.7 ± 0.3% | 353.2 ± 1.0% | 1436.1 ± 0.2% | 1055.6 ± 0.3% | 1.986 | 1.220 | 11.926 | 2.933 | 3.990 |
| string: silesia/webster | 1098490 | 4083.8 ± 0.4% | 1885.4 ± 0.5% | 2059.1 ± 0.4% | 443.0 ± 0.3% | 1398.0 ± 0.3% | 646.3 ± 1.1% | 2.166 | 1.983 | 9.219 | 2.921 | 6.319 |
| string: silesia/xml | 1090118 | 6149.2 ± 0.8% | 2881.4 ± 0.7% | 2652.0 ± 0.5% | 608.9 ± 0.1% | 1756.0 ± 0.4% | 923.0 ± 0.7% | 2.134 | 2.319 | 10.098 | 3.502 | 6.662 |
| string: canterbury/alice29.txt | 159425 | 6457.8 ± 1.5% | 2197.4 ± 0.4% | 2762.2 ± 0.7% | 406.9 ± 0.8% | 1480.4 ± 0.6% | 954.9 ± 0.4% | 2.939 | 2.338 | 15.870 | 4.362 | 6.763 |
| string: canterbury/asyoulik.txt | 132198 | 5673.8 ± 0.8% | 1716.4 ± 0.7% | 2366.4 ± 1.1% | 401.0 ± 0.6% | 1349.6 ± 0.7% | 885.6 ± 0.2% | 3.306 | 2.398 | 14.151 | 4.204 | 6.406 |
| string: canterbury/lcet10.txt | 441884 | 6281.5 ± 0.2% | 2572.0 ± 0.4% | 2518.0 ± 2.1% | 467.7 ± 0.8% | 1542.3 ± 0.6% | 988.8 ± 0.5% | 2.442 | 2.495 | 13.431 | 4.073 | 6.352 |
| string: canterbury/plrabn12.txt | 503330 | 5736.7 ± 0.4% | 2064.5 ± 0.4% | 2071.1 ± 0.5% | 424.2 ± 0.9% | 1432.7 ± 0.3% | 936.3 ± 0.6% | 2.779 | 2.770 | 13.523 | 4.004 | 6.127 |
| string: canterbury-large/E.coli | 1048578 | 19432.2 ± 0.3% | 9873.0 ± 0.7% | 3796.4 ± 0.5% | 1483.1 ± 0.7% | 2368.8 ± 1.1% | 1195.5 ± 0.7% | 1.968 | 5.119 | 13.103 | 8.203 | 16.255 |
| string: canterbury-large/bible.txt | 1055886 | 6818.0 ± 0.4% | 4175.8 ± 1.1% | 3064.6 ± 1.8% | 505.3 ± 0.3% | 1975.8 ± 0.2% | 1125.2 ± 1.2% | 1.633 | 2.225 | 13.493 | 3.451 | 6.059 |
| string: canterbury-large/world192.txt | 1103121 | 4060.4 ± 0.5% | 1660.1 ± 0.2% | 2004.2 ± 0.8% | 447.4 ± 0.3% | 1361.6 ± 0.4% | 909.9 ± 0.4% | 2.446 | 2.026 | 9.075 | 2.982 | 4.462 |
| string: http/html-1m | 1058582 | 6803.3 ± 1.3% | 4011.2 ± 0.3% | 3045.8 ± 0.3% | 500.8 ± 0.7% | 1921.3 ± 0.3% | 807.6 ± 0.6% | 1.696 | 2.234 | 13.585 | 3.541 | 8.424 |
| string: http/json-1m | 1190272 | 3172.2 ± 0.2% | 1351.5 ± 0.4% | 1558.5 ± 0.4% | 444.1 ± 0.3% | 962.3 ± 0.1% | 767.7 ± 0.3% | 2.347 | 2.035 | 7.143 | 3.297 | 4.132 |
| string: http/js-1m | 1144362 | 2778.0 ± 1.0% | 1181.2 ± 0.5% | 1631.4 ± 0.3% | 368.8 ± 0.2% | 1096.3 ± 0.2% | 760.3 ± 0.4% | 2.352 | 1.703 | 7.532 | 2.534 | 3.654 |
| string: http/css-1m | 1097820 | 4013.0 ± 1.4% | 1491.3 ± 0.6% | 2149.4 ± 0.8% | 494.3 ± 0.2% | 1370.0 ± 0.4% | 894.9 ± 0.4% | 2.691 | 1.867 | 8.118 | 2.929 | 4.484 |
| string: dickens as Cyrillic and CJK | 1883069 | 3074.0 ± 0.3% | 2349.3 ± 0.6% | 522.1 ± 0.2% | 307.0 ± 0.6% | 561.2 ± 1.0% | 336.6 ± 0.2% | 1.308 | 5.888 | 10.014 | 5.478 | 9.133 |
| hex: silesia/dickens | 524290 | 15680.6 ± 0.6% | 1469.7 ± 0.2% | 1084.0 ± 0.3% | 503.1 ± 1.1% | 988.4 ± 0.6% | 737.0 ± 0.5% | 10.670 | 14.466 | 31.166 | 15.865 | 21.277 |
| hex: silesia/mozilla | 524290 | 15662.1 ± 0.4% | 1479.5 ± 0.3% | 1092.6 ± 0.7% | 441.3 ± 0.3% | 996.9 ± 0.4% | 736.0 ± 0.4% | 10.586 | 14.334 | 35.489 | 15.711 | 21.281 |
| hex: silesia/mr | 524290 | 15689.8 ± 0.2% | 1486.6 ± 0.3% | 1094.6 ± 0.5% | 554.4 ± 0.9% | 997.2 ± 0.4% | 736.8 ± 0.4% | 10.554 | 14.334 | 28.302 | 15.733 | 21.296 |
| hex: silesia/nci | 524290 | 15689.7 ± 0.3% | 1477.0 ± 0.7% | 1091.7 ± 0.6% | 644.0 ± 3.0% | 994.2 ± 0.4% | 737.7 ± 0.6% | 10.623 | 14.371 | 24.363 | 15.781 | 21.270 |
| hex: silesia/ooffice | 524290 | 15676.4 ± 0.2% | 1467.9 ± 0.3% | 1088.4 ± 0.2% | 389.9 ± 0.3% | 992.4 ± 0.6% | 736.6 ± 0.6% | 10.680 | 14.403 | 40.203 | 15.796 | 21.281 |
| hex: silesia/osdb | 524290 | 15646.0 ± 0.4% | 1472.4 ± 0.2% | 1089.3 ± 0.5% | 476.9 ± 1.7% | 994.1 ± 0.5% | 737.9 ± 0.5% | 10.626 | 14.363 | 32.807 | 15.739 | 21.203 |
| hex: silesia/reymont | 524290 | 15704.2 ± 0.6% | 1474.9 ± 0.5% | 1091.1 ± 0.4% | 514.2 ± 0.5% | 988.2 ± 0.4% | 737.6 ± 0.4% | 10.647 | 14.393 | 30.539 | 15.891 | 21.292 |
| hex: silesia/samba | 524290 | 15673.5 ± 0.3% | 1471.9 ± 0.4% | 1089.1 ± 0.5% | 402.2 ± 0.5% | 995.5 ± 0.5% | 736.3 ± 0.5% | 10.648 | 14.391 | 38.966 | 15.745 | 21.287 |
| hex: silesia/sao | 524290 | 15615.2 ± 0.2% | 1468.0 ± 0.3% | 1086.3 ± 0.6% | 333.2 ± 0.7% | 992.0 ± 0.3% | 737.9 ± 0.3% | 10.637 | 14.375 | 46.871 | 15.741 | 21.161 |
| hex: silesia/webster | 524290 | 15683.4 ± 0.3% | 1470.3 ± 0.3% | 1088.0 ± 0.2% | 476.3 ± 0.4% | 994.7 ± 0.3% | 737.3 ± 0.5% | 10.667 | 14.415 | 32.926 | 15.767 | 21.271 |
| hex: silesia/x-ray | 524290 | 15537.1 ± 0.3% | 1481.4 ± 0.2% | 1092.8 ± 0.4% | 443.6 ± 1.2% | 996.2 ± 0.4% | 736.7 ± 0.5% | 10.488 | 14.218 | 35.024 | 15.596 | 21.091 |
| hex: silesia/xml | 524290 | 15626.7 ± 0.5% | 1473.3 ± 0.6% | 1090.7 ± 0.3% | 615.0 ± 0.6% | 994.4 ± 0.4% | 736.9 ± 0.6% | 10.607 | 14.327 | 25.410 | 15.715 | 21.205 |
| hex: canterbury/alice29.txt | 304180 | 15708.1 ± 0.0% | 1474.0 ± 0.5% | 1094.2 ± 0.2% | 503.9 ± 0.5% | 994.1 ± 0.3% | 738.4 ± 0.5% | 10.657 | 14.355 | 31.173 | 15.801 | 21.275 |
| hex: canterbury/asyoulik.txt | 250360 | 15721.9 ± 0.0% | 1477.3 ± 0.6% | 1095.1 ± 0.2% | 498.7 ± 0.9% | 996.7 ± 0.5% | 742.1 ± 0.2% | 10.643 | 14.357 | 31.528 | 15.774 | 21.187 |
| hex: canterbury/cp.html | 49208 | 15666.5 ± 0.0% | 1472.5 ± 0.6% | 1098.0 ± 0.2% | 530.6 ± 3.4% | 1000.5 ± 0.6% | 743.2 ± 0.2% | 10.639 | 14.268 | 29.525 | 15.658 | 21.080 |
| hex: canterbury/fields.c | 22302 | 15520.2 ± 0.0% | 1407.1 ± 0.7% | 1068.4 ± 0.7% | 635.9 ± 8.9% | 989.1 ± 0.5% | 736.8 ± 0.2% | 11.030 | 14.527 | 24.406 | 15.692 | 21.064 |
| hex: canterbury/grammar.lsp | 7444 | 15151.3 ± 0.1% | 1504.1 ± 0.2% | 1089.4 ± 0.9% | 685.3 ± 5.3% | 995.4 ± 0.5% | 725.4 ± 0.2% | 10.073 | 13.907 | 22.110 | 15.221 | 20.886 |
| hex: canterbury/kennedy.xls | 524290 | 15662.4 ± 0.3% | 1483.1 ± 0.5% | 1092.1 ± 0.4% | 657.9 ± 0.9% | 992.0 ± 0.4% | 738.1 ± 0.5% | 10.560 | 14.341 | 23.806 | 15.789 | 21.219 |
| hex: canterbury/lcet10.txt | 524290 | 15636.3 ± 0.4% | 1465.0 ± 0.3% | 1084.4 ± 0.5% | 501.3 ± 0.7% | 991.4 ± 0.2% | 735.8 ± 0.7% | 10.673 | 14.420 | 31.190 | 15.772 | 21.250 |
| hex: canterbury/plrabn12.txt | 524290 | 15649.0 ± 0.3% | 1471.4 ± 0.4% | 1085.7 ± 0.3% | 495.0 ± 0.5% | 991.1 ± 0.5% | 737.4 ± 0.4% | 10.636 | 14.414 | 31.615 | 15.789 | 21.221 |
| hex: canterbury/ptt5 | 524290 | 15635.2 ± 0.1% | 1486.3 ± 0.3% | 1095.4 ± 0.3% | 557.5 ± 1.1% | 994.9 ± 0.4% | 737.4 ± 0.6% | 10.519 | 14.273 | 28.045 | 15.715 | 21.204 |
| hex: canterbury/sum | 76482 | 15672.5 ± 0.1% | 1494.6 ± 0.1% | 1104.7 ± 0.2% | 589.6 ± 2.6% | 998.1 ± 0.1% | 744.3 ± 0.1% | 10.486 | 14.187 | 26.582 | 15.702 | 21.056 |
| hex: canterbury/xargs.1 | 8456 | 15204.3 ± 0.1% | 1430.1 ± 1.7% | 1088.6 ± 0.7% | 647.3 ± 5.6% | 997.5 ± 0.1% | 727.6 ± 0.7% | 10.632 | 13.967 | 23.490 | 15.243 | 20.896 |
| hex: canterbury-large/E.coli | 524290 | 15651.2 ± 0.4% | 1477.5 ± 0.4% | 1093.6 ± 0.9% | 673.1 ± 0.8% | 993.5 ± 0.3% | 738.1 ± 0.2% | 10.593 | 14.311 | 23.252 | 15.754 | 21.205 |
| hex: canterbury-large/bible.txt | 524290 | 15677.1 ± 0.2% | 1465.4 ± 0.4% | 1083.3 ± 0.4% | 516.9 ± 0.8% | 989.8 ± 0.7% | 737.6 ± 0.4% | 10.698 | 14.472 | 30.330 | 15.838 | 21.254 |
| hex: canterbury-large/world192.txt | 524290 | 15654.0 ± 0.2% | 1469.8 ± 0.1% | 1088.2 ± 0.2% | 504.0 ± 0.7% | 991.8 ± 0.7% | 737.4 ± 0.6% | 10.650 | 14.385 | 31.061 | 15.783 | 21.229 |
| hex: http/html-1kx1024 | 2099200 | 14255.7 ± 0.2% | 1454.2 ± 0.4% | 1061.3 ± 0.3% | 502.6 ± 0.2% | 982.8 ± 0.1% | 692.1 ± 0.2% | 9.803 | 13.432 | 28.363 | 14.506 | 20.598 |
| hex: http/html-16kx64 | 2097280 | 15461.6 ± 0.3% | 1444.2 ± 0.1% | 1074.7 ± 0.2% | 507.3 ± 0.4% | 996.2 ± 0.1% | 735.3 ± 0.1% | 10.706 | 14.388 | 30.481 | 15.520 | 21.029 |
| hex: http/html-1m | 524290 | 15684.5 ± 0.3% | 1471.4 ± 0.3% | 1086.1 ± 1.1% | 501.6 ± 0.4% | 992.5 ± 0.5% | 737.4 ± 0.6% | 10.659 | 14.441 | 31.271 | 15.804 | 21.271 |
| hex: http/json-1kx1024 | 2099200 | 14172.0 ± 0.9% | 1464.3 ± 0.3% | 1068.7 ± 1.0% | 610.5 ± 0.2% | 986.7 ± 0.2% | 692.0 ± 0.1% | 9.678 | 13.260 | 23.215 | 14.362 | 20.479 |
| hex: http/json-16kx64 | 2097280 | 15453.9 ± 0.6% | 1447.3 ± 0.2% | 1076.4 ± 0.2% | 614.8 ± 0.8% | 997.1 ± 0.3% | 734.5 ± 0.2% | 10.677 | 14.357 | 25.138 | 15.499 | 21.040 |
| hex: http/json-1m | 524290 | 15708.3 ± 0.2% | 1476.4 ± 0.2% | 1091.3 ± 0.4% | 636.2 ± 0.4% | 995.8 ± 0.1% | 735.2 ± 0.3% | 10.640 | 14.394 | 24.689 | 15.774 | 21.367 |
| hex: http/js-1kx1024 | 2099200 | 14202.6 ± 0.4% | 1456.0 ± 0.2% | 1064.5 ± 0.2% | 500.1 ± 0.1% | 983.6 ± 0.3% | 692.1 ± 0.3% | 9.755 | 13.342 | 28.401 | 14.440 | 20.520 |
| hex: http/js-16kx64 | 2097280 | 15438.2 ± 0.6% | 1444.6 ± 0.3% | 1074.7 ± 0.2% | 504.1 ± 0.6% | 998.2 ± 0.3% | 735.6 ± 0.2% | 10.687 | 14.366 | 30.624 | 15.466 | 20.986 |
| hex: http/js-1m | 524290 | 15696.2 ± 0.3% | 1470.0 ± 0.3% | 1084.5 ± 0.5% | 510.4 ± 0.4% | 989.7 ± 0.5% | 737.4 ± 0.5% | 10.678 | 14.473 | 30.751 | 15.860 | 21.286 |
| hex: http/css-1kx1024 | 2099200 | 14150.1 ± 0.2% | 1455.7 ± 0.2% | 1063.3 ± 0.2% | 531.8 ± 0.2% | 983.6 ± 0.1% | 692.0 ± 0.1% | 9.721 | 13.307 | 26.608 | 14.387 | 20.448 |
| hex: http/css-16kx64 | 2097280 | 15448.7 ± 0.6% | 1445.1 ± 0.1% | 1075.8 ± 0.1% | 541.0 ± 0.5% | 997.3 ± 0.4% | 735.6 ± 0.3% | 10.691 | 14.360 | 28.555 | 15.491 | 21.003 |
| hex: http/css-1m | 524290 | 15659.7 ± 0.3% | 1471.6 ± 0.4% | 1089.6 ± 0.3% | 529.7 ± 0.7% | 992.3 ± 0.6% | 736.2 ± 0.4% | 10.642 | 14.372 | 29.563 | 15.780 | 21.270 |
| hex: shuffled/dickens-1m | 524290 | 15689.9 ± 0.2% | 1468.8 ± 0.3% | 1085.9 ± 0.7% | 491.6 ± 1.8% | 994.8 ± 0.6% | 736.7 ± 0.5% | 10.682 | 14.448 | 31.918 | 15.772 | 21.297 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.916 of yyjson.
