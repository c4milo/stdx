# bench-json

| Field | Value |
|---|---|
| Commit | 862cb69 |
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
| CLDR supplemental, 34 texts | 920675 | 1129.1 ± 0.6% | 0.523 | 0.963 | 0.995 | 0.996 | 0.459 | 1.003 | 1.002 | 0.387 | 0.830 | 0.897 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 846.8 ± 1.8% | 0.820 | 1.008 | 1.005 | 1.002 | 0.445 | 1.002 | 1.031 | 0.388 | 0.918 | 0.990 | 0.124 |
| string: silesia/dickens | 172528 | 5035.1 ± 0.3% | 0.033 | 0.783 | 1.003 | 1.002 | 0.196 | 1.020 | 1.007 | 0.196 | 1.002 | 1.003 | 0.032 |
| string: silesia/nci | 1075110 | 4294.1 ± 0.5% | 0.039 | 0.803 | 1.006 | 1.006 | 0.280 | 1.005 | 0.997 | 0.279 | 1.002 | 1.002 | 0.038 |
| string: silesia/reymont | 1075159 | 2919.5 ± 0.8% | 0.057 | 0.815 | 0.998 | 1.005 | 0.360 | 1.010 | 1.010 | 0.361 | 1.021 | 1.021 | 0.056 |
| string: silesia/samba | 97582 | 3494.6 ± 0.3% | 0.040 | 0.861 | 1.003 | 1.006 | 0.069 | 0.779 | 1.010 | 0.072 | 1.003 | 1.006 | 0.039 |
| string: silesia/webster | 1098490 | 3646.1 ± 0.4% | 0.044 | 0.847 | 1.005 | 1.008 | 0.203 | 1.017 | 1.013 | 0.203 | 1.009 | 1.008 | 0.044 |
| string: silesia/xml | 1090118 | 4776.7 ± 0.7% | 0.035 | 0.810 | 1.008 | 1.010 | 0.221 | 0.980 | 1.006 | 0.224 | 1.008 | 1.012 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4305.5 ± 0.8% | 0.038 | 0.752 | 1.004 | 1.007 | 0.172 | 1.033 | 1.020 | 0.171 | 1.010 | 1.012 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3450.5 ± 1.0% | 0.046 | 0.749 | 1.010 | 1.013 | 0.177 | 1.007 | 0.965 | 0.176 | 1.014 | 1.016 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5099.7 ± 0.4% | 0.032 | 0.817 | 1.003 | 1.005 | 0.196 | 1.024 | 1.006 | 0.195 | 1.006 | 1.006 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4101.1 ± 0.8% | 0.040 | 0.829 | 1.007 | 1.008 | 0.199 | 1.017 | 1.003 | 0.199 | 1.009 | 1.009 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19098.4 ± 1.1% | 0.077 | 1.010 | 1.008 | 1.011 | 0.481 | 1.011 | 1.011 | 0.481 | 0.623 | 0.625 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6662.9 ± 0.8% | 0.026 | 0.804 | 1.000 | 1.002 | 0.434 | 1.029 | 1.044 | 0.434 | 1.036 | 1.036 | 0.026 |
| string: canterbury-large/world192.txt | 1103121 | 3378.3 ± 0.4% | 0.048 | 0.847 | 1.006 | 1.006 | 0.198 | 1.014 | 1.006 | 0.198 | 1.004 | 1.005 | 0.047 |
| string: http/html-1m | 1058582 | 6048.4 ± 1.0% | 0.028 | 0.784 | 1.001 | 1.041 | 0.389 | 1.044 | 1.052 | 0.390 | 1.030 | 1.031 | 0.028 |
| string: http/json-1m | 1190272 | 2531.0 ± 0.3% | 0.056 | 0.954 | 1.007 | 1.010 | 0.112 | 1.008 | 0.473 | 0.112 | 1.011 | 1.012 | 0.055 |
| string: http/js-1m | 1144362 | 2279.1 ± 0.4% | 0.066 | 0.892 | 1.007 | 1.006 | 0.174 | 1.055 | 1.046 | 0.174 | 1.005 | 1.005 | 0.066 |
| string: http/css-1m | 1097820 | 2625.0 ± 0.6% | 0.061 | 0.779 | 1.009 | 1.011 | 0.241 | 1.012 | 1.020 | 0.240 | 1.010 | 1.011 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3064.3 ± 0.8% | 0.044 | 0.125 | 1.006 | 1.005 | 0.337 | 1.003 | 1.008 | 0.336 | 1.005 | 1.003 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1325.8 ± 1.3% | 0.081 | 1.004 | 1.002 | 1.002 | 0.076 | 0.637 | 1.004 | 0.081 | 1.003 | 1.004 | 0.081 |
| hex: silesia/dickens | 524290 | 18823.8 ± 1.2% | 0.079 | 1.001 | 0.993 | 0.993 | 0.504 | 0.997 | 0.993 | 0.506 | 0.634 | 0.635 | 0.009 |
| hex: silesia/mozilla | 524290 | 19048.2 ± 0.6% | 0.078 | 0.999 | 0.996 | 0.994 | 0.506 | 0.998 | 0.988 | 0.506 | 0.628 | 0.629 | 0.009 |
| hex: silesia/mr | 524290 | 18664.7 ± 0.9% | 0.080 | 0.996 | 0.993 | 0.995 | 0.511 | 1.003 | 0.996 | 0.512 | 0.642 | 0.642 | 0.009 |
| hex: silesia/nci | 524290 | 18730.3 ± 1.5% | 0.079 | 1.002 | 0.998 | 0.999 | 0.512 | 0.994 | 0.997 | 0.513 | 0.641 | 0.641 | 0.009 |
| hex: silesia/ooffice | 524290 | 18861.7 ± 0.4% | 0.079 | 0.999 | 1.000 | 1.000 | 0.513 | 1.000 | 1.000 | 0.514 | 0.636 | 0.636 | 0.009 |
| hex: silesia/osdb | 524290 | 18570.0 ± 0.6% | 0.080 | 1.003 | 0.996 | 0.998 | 0.514 | 1.001 | 1.003 | 0.514 | 0.645 | 0.643 | 0.009 |
| hex: silesia/reymont | 524290 | 18835.9 ± 0.3% | 0.079 | 0.997 | 0.998 | 0.999 | 0.514 | 1.001 | 0.997 | 0.517 | 0.638 | 0.638 | 0.009 |
| hex: silesia/samba | 524290 | 18574.3 ± 0.8% | 0.080 | 1.002 | 1.001 | 1.000 | 0.517 | 1.002 | 0.999 | 0.516 | 0.645 | 0.644 | 0.009 |
| hex: silesia/sao | 524290 | 18863.1 ± 1.0% | 0.079 | 1.012 | 1.005 | 1.000 | 0.507 | 1.007 | 1.004 | 0.509 | 0.637 | 0.637 | 0.009 |
| hex: silesia/webster | 524290 | 18919.5 ± 0.4% | 0.078 | 1.000 | 0.996 | 0.995 | 0.500 | 1.000 | 0.999 | 0.502 | 0.633 | 0.633 | 0.009 |
| hex: silesia/x-ray | 524290 | 18779.8 ± 0.5% | 0.079 | 1.006 | 1.005 | 1.003 | 0.521 | 1.000 | 1.003 | 0.520 | 0.639 | 0.639 | 0.009 |
| hex: silesia/xml | 524290 | 18918.1 ± 0.4% | 0.079 | 1.003 | 1.005 | 1.002 | 0.510 | 0.999 | 0.999 | 0.511 | 0.633 | 0.634 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 18930.9 ± 1.3% | 0.079 | 1.006 | 1.000 | 1.001 | 0.518 | 0.995 | 1.001 | 0.515 | 0.634 | 0.634 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 18923.9 ± 0.4% | 0.079 | 1.028 | 1.028 | 1.028 | 0.527 | 1.003 | 1.028 | 0.529 | 0.634 | 0.634 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19280.0 ± 0.5% | 0.083 | 1.003 | 1.002 | 1.000 | 0.542 | 1.003 | 1.002 | 0.543 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18794.4 ± 1.1% | 0.085 | 1.009 | 1.009 | 1.009 | 0.536 | 1.005 | 1.009 | 0.542 | 0.626 | 0.627 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17417.4 ± 0.8% | 0.090 | 1.009 | 1.010 | 1.010 | 0.529 | 1.009 | 1.009 | 0.548 | 0.646 | 0.649 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18913.8 ± 2.4% | 0.079 | 1.010 | 1.004 | 1.002 | 0.515 | 0.999 | 0.990 | 0.515 | 0.634 | 0.635 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18622.1 ± 1.9% | 0.080 | 1.009 | 1.011 | 1.009 | 0.527 | 1.008 | 1.005 | 0.527 | 0.645 | 0.644 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18704.9 ± 0.4% | 0.080 | 1.006 | 1.005 | 1.005 | 0.520 | 1.005 | 1.004 | 0.516 | 0.641 | 0.641 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 18623.8 ± 2.1% | 0.080 | 1.009 | 1.007 | 1.007 | 0.514 | 1.004 | 1.007 | 0.512 | 0.643 | 0.644 | 0.009 |
| hex: canterbury/sum | 76482 | 19279.2 ± 0.2% | 0.078 | 1.002 | 1.003 | 1.002 | 0.518 | 1.002 | 1.002 | 0.519 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17785.4 ± 0.1% | 0.088 | 1.002 | 1.003 | 1.003 | 0.527 | 1.002 | 1.002 | 0.542 | 0.637 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 19080.8 ± 1.3% | 0.078 | 1.001 | 0.997 | 0.989 | 0.496 | 0.989 | 0.988 | 0.496 | 0.627 | 0.629 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18973.2 ± 0.5% | 0.078 | 1.009 | 1.006 | 1.002 | 0.506 | 0.998 | 0.999 | 0.505 | 0.631 | 0.632 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18582.4 ± 0.6% | 0.080 | 1.000 | 1.000 | 1.000 | 0.515 | 1.001 | 1.000 | 0.517 | 0.645 | 0.645 | 0.009 |
| hex: http/html-1kx1024 | 2099200 | 9849.6 ± 18.9% | 0.145 | 1.234 | 1.231 | 1.231 | 0.675 | 1.236 | 0.953 | 0.732 | 0.899 | 0.906 | 0.017 |
| hex: http/html-16kx64 | 2097280 | 18367.8 ± 1.2% | 0.082 | 1.012 | 1.010 | 1.009 | 0.556 | 1.011 | 0.992 | 0.562 | 0.640 | 0.640 | 0.009 |
| hex: http/html-1m | 524290 | 18749.9 ± 1.8% | 0.079 | 1.008 | 1.003 | 1.004 | 0.516 | 1.004 | 0.999 | 0.516 | 0.640 | 0.640 | 0.009 |
| hex: http/json-1kx1024 | 2099200 | 9597.5 ± 20.1% | 0.149 | 1.261 | 1.259 | 1.258 | 0.686 | 1.259 | 0.975 | 0.747 | 0.918 | 0.924 | 0.018 |
| hex: http/json-16kx64 | 2097280 | 18455.5 ± 2.1% | 0.081 | 1.008 | 1.008 | 1.007 | 0.554 | 1.009 | 0.993 | 0.559 | 0.637 | 0.638 | 0.009 |
| hex: http/json-1m | 524290 | 18677.6 ± 1.9% | 0.080 | 1.006 | 1.006 | 1.006 | 0.514 | 1.007 | 1.006 | 0.516 | 0.643 | 0.643 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 9757.3 ± 18.6% | 0.145 | 1.208 | 1.207 | 1.209 | 0.678 | 1.214 | 0.965 | 0.740 | 0.903 | 0.904 | 0.018 |
| hex: http/js-16kx64 | 2097280 | 18401.1 ± 0.7% | 0.080 | 1.012 | 1.009 | 1.011 | 0.554 | 1.009 | 0.993 | 0.560 | 0.640 | 0.640 | 0.009 |
| hex: http/js-1m | 524290 | 18768.6 ± 1.0% | 0.079 | 1.007 | 1.003 | 0.999 | 0.508 | 0.999 | 1.002 | 0.507 | 0.639 | 0.639 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9591.3 ± 20.4% | 0.149 | 1.256 | 1.250 | 1.252 | 0.688 | 1.252 | 0.978 | 0.747 | 0.921 | 0.925 | 0.018 |
| hex: http/css-16kx64 | 2097280 | 18273.2 ± 5.9% | 0.082 | 1.020 | 1.017 | 1.017 | 0.559 | 1.018 | 1.001 | 0.565 | 0.644 | 0.644 | 0.010 |
| hex: http/css-1m | 524290 | 18824.2 ± 0.8% | 0.079 | 1.013 | 1.008 | 1.002 | 0.517 | 1.002 | 1.002 | 0.518 | 0.637 | 0.637 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18402.4 ± 0.9% | 0.081 | 1.012 | 1.006 | 1.007 | 0.516 | 1.004 | 1.008 | 0.518 | 0.652 | 0.651 | 0.009 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1473.3 ± 0.7% | 0.445 | 1.003 | 0.970 | 1.009 | 1.008 | 0.269 | 1.000 | 0.549 | 0.917 | 0.089 | 1.029 |
| qlog records, JSON text sequence | 1467503 | 1255.2 ± 1.9% | 0.696 | 0.980 | 1.015 | 1.018 | 1.015 | 0.267 | 1.007 | 0.505 | 0.833 | 0.107 | 1.024 |
| string: silesia/dickens | 172528 | 6890.0 ± 0.4% | 0.025 | 1.001 | 1.002 | 1.002 | 1.002 | 0.167 | 0.718 | 1.003 | 1.003 | 0.025 | 1.035 |
| string: silesia/nci | 1075110 | 7287.4 ± 0.3% | 0.023 | 1.004 | 1.002 | 1.003 | 1.002 | 0.212 | 0.564 | 1.003 | 1.002 | 0.024 | 1.009 |
| string: silesia/reymont | 1075159 | 3336.9 ± 1.4% | 0.052 | 1.004 | 1.002 | 1.001 | 1.002 | 0.389 | 0.874 | 1.002 | 1.008 | 0.052 | 1.049 |
| string: silesia/samba | 97582 | 4189.5 ± 0.6% | 0.053 | 1.004 | 1.000 | 1.006 | 1.008 | 0.125 | 0.940 | 1.004 | 1.005 | 0.054 | 1.090 |
| string: silesia/webster | 1098490 | 4054.7 ± 0.4% | 0.042 | 1.009 | 1.008 | 1.007 | 1.008 | 0.212 | 0.887 | 0.999 | 1.006 | 0.042 | 1.008 |
| string: silesia/xml | 1090118 | 6118.2 ± 0.3% | 0.029 | 1.005 | 0.997 | 1.001 | 1.002 | 0.253 | 0.776 | 1.001 | 1.002 | 0.029 | 1.020 |
| string: canterbury/alice29.txt | 159425 | 6425.0 ± 0.8% | 0.027 | 1.005 | 1.009 | 1.010 | 1.011 | 0.132 | 0.653 | 1.003 | 1.005 | 0.027 | 1.063 |
| string: canterbury/asyoulik.txt | 132198 | 5600.4 ± 1.9% | 0.030 | 1.022 | 1.028 | 1.030 | 1.033 | 0.129 | 0.595 | 1.005 | 1.011 | 0.030 | 1.055 |
| string: canterbury/lcet10.txt | 441884 | 6251.2 ± 0.6% | 0.027 | 1.005 | 1.006 | 1.006 | 1.007 | 0.184 | 0.799 | 1.002 | 1.002 | 0.028 | 1.002 |
| string: canterbury/plrabn12.txt | 503330 | 5716.8 ± 0.2% | 0.030 | 1.002 | 1.003 | 1.003 | 1.002 | 0.168 | 0.696 | 1.001 | 1.002 | 0.030 | 1.005 |
| string: canterbury-large/E.coli | 1048578 | 19315.2 ± 0.6% | 0.077 | 1.002 | 1.002 | 1.000 | 1.003 | 0.476 | 1.004 | 1.002 | 1.002 | 0.009 | 1.002 |
| string: canterbury-large/bible.txt | 1055886 | 6779.5 ± 0.4% | 0.026 | 1.001 | 1.002 | 1.001 | 1.001 | 0.497 | 0.972 | 1.001 | 1.003 | 0.026 | 1.002 |
| string: canterbury-large/world192.txt | 1103121 | 4011.6 ± 0.5% | 0.042 | 1.020 | 1.020 | 1.018 | 1.019 | 0.194 | 0.834 | 1.006 | 1.013 | 0.043 | 1.004 |
| string: http/html-1m | 1058582 | 6748.8 ± 0.9% | 0.026 | 1.004 | 0.923 | 1.005 | 1.007 | 0.404 | 0.894 | 1.000 | 1.003 | 0.026 | 1.007 |
| string: http/json-1m | 1190272 | 3161.0 ± 0.2% | 0.051 | 1.001 | 0.966 | 1.001 | 1.002 | 0.133 | 0.371 | 0.998 | 1.000 | 0.051 | 1.041 |
| string: http/js-1m | 1144362 | 2756.2 ± 0.3% | 0.061 | 1.002 | 1.006 | 1.000 | 1.006 | 0.165 | 0.839 | 1.001 | 1.004 | 0.061 | 1.012 |
| string: http/css-1m | 1097820 | 3970.5 ± 0.8% | 0.042 | 1.005 | 1.007 | 1.011 | 1.009 | 0.208 | 0.647 | 1.003 | 1.009 | 0.044 | 1.014 |
| string: dickens as Cyrillic and CJK | 1883069 | 3064.6 ± 0.4% | 0.048 | 1.001 | 0.124 | 1.000 | 1.001 | 0.321 | 1.002 | 0.999 | 1.002 | 0.048 | 1.001 |
| hex: silesia/dickens | 524290 | 15632.5 ± 0.1% | 1.001 | 0.177 | 1.002 | 1.001 | 1.001 | 0.994 | 0.999 | 0.999 | 0.999 | 0.177 | 0.997 |
| hex: silesia/mozilla | 524290 | 15633.2 ± 0.3% | 0.999 | 0.178 | 1.001 | 1.001 | 1.001 | 0.999 | 0.997 | 1.000 | 1.000 | 0.178 | 0.998 |
| hex: silesia/mr | 524290 | 15635.8 ± 0.3% | 1.002 | 0.179 | 1.002 | 1.001 | 1.002 | 1.001 | 1.001 | 1.002 | 1.002 | 0.178 | 1.000 |
| hex: silesia/nci | 524290 | 15648.9 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.002 | 1.002 | 1.001 | 1.002 | 1.000 | 1.000 | 0.178 | 1.002 |
| hex: silesia/ooffice | 524290 | 15612.5 ± 0.4% | 1.003 | 0.178 | 1.002 | 1.002 | 1.002 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: silesia/osdb | 524290 | 15653.6 ± 0.4% | 0.999 | 0.178 | 1.000 | 0.999 | 0.999 | 0.999 | 1.000 | 0.999 | 0.999 | 0.178 | 0.999 |
| hex: silesia/reymont | 524290 | 15661.4 ± 0.3% | 1.002 | 0.177 | 1.000 | 1.002 | 1.001 | 1.000 | 1.001 | 1.002 | 1.000 | 0.177 | 1.002 |
| hex: silesia/samba | 524290 | 15661.8 ± 0.8% | 1.002 | 0.177 | 1.001 | 1.001 | 1.000 | 1.000 | 1.002 | 1.001 | 1.001 | 0.177 | 1.000 |
| hex: silesia/sao | 524290 | 15635.5 ± 0.2% | 1.000 | 0.177 | 1.000 | 1.001 | 1.000 | 0.999 | 1.001 | 0.999 | 1.002 | 0.177 | 1.001 |
| hex: silesia/webster | 524290 | 15627.3 ± 0.4% | 1.002 | 0.178 | 1.002 | 1.002 | 1.002 | 1.002 | 1.002 | 1.002 | 1.002 | 0.177 | 0.999 |
| hex: silesia/x-ray | 524290 | 15607.0 ± 0.3% | 1.001 | 0.179 | 1.002 | 1.002 | 1.001 | 1.003 | 1.004 | 1.002 | 1.002 | 0.179 | 1.003 |
| hex: silesia/xml | 524290 | 15604.7 ± 0.3% | 1.000 | 0.178 | 1.000 | 1.002 | 1.000 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/alice29.txt | 304180 | 15658.1 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.001 | 1.002 | 1.001 | 1.002 | 0.178 | 1.002 |
| hex: canterbury/asyoulik.txt | 250360 | 15686.6 ± 0.1% | 1.002 | 0.178 | 1.002 | 1.002 | 1.002 | 1.000 | 1.002 | 1.002 | 1.002 | 0.177 | 1.002 |
| hex: canterbury/cp.html | 49208 | 15617.3 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.001 | 1.001 | 0.998 | 1.001 | 1.001 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15431.7 ± 0.0% | 1.002 | 0.181 | 1.001 | 1.001 | 1.001 | 0.995 | 1.001 | 1.003 | 1.006 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14939.8 ± 0.3% | 1.003 | 0.186 | 1.000 | 1.001 | 1.001 | 0.983 | 1.001 | 1.004 | 1.014 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15626.5 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.001 | 1.000 | 0.999 | 0.999 | 1.000 | 1.002 | 0.178 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 15582.3 ± 0.8% | 1.001 | 0.178 | 1.002 | 1.000 | 1.001 | 1.000 | 1.002 | 1.001 | 1.001 | 0.178 | 1.000 |
| hex: canterbury/plrabn12.txt | 524290 | 15661.2 ± 0.1% | 1.000 | 0.177 | 1.001 | 1.002 | 1.000 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 15628.3 ± 0.2% | 1.003 | 0.179 | 1.002 | 1.002 | 1.001 | 1.001 | 0.998 | 0.999 | 0.999 | 0.179 | 1.001 |
| hex: canterbury/sum | 76482 | 15640.7 ± 0.0% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.998 | 1.001 | 1.000 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 15016.0 ± 0.3% | 1.001 | 0.185 | 1.000 | 1.000 | 1.000 | 0.984 | 1.000 | 1.003 | 1.012 | 0.183 | 1.002 |
| hex: canterbury-large/E.coli | 524290 | 15643.6 ± 0.3% | 1.002 | 0.178 | 1.002 | 1.002 | 1.001 | 1.001 | 1.002 | 1.001 | 1.002 | 0.178 | 1.002 |
| hex: canterbury-large/bible.txt | 524290 | 15646.1 ± 0.3% | 1.001 | 0.178 | 1.002 | 1.000 | 1.001 | 1.001 | 0.999 | 0.999 | 1.001 | 0.177 | 1.002 |
| hex: canterbury-large/world192.txt | 524290 | 15640.5 ± 0.4% | 1.001 | 0.177 | 0.999 | 0.998 | 0.999 | 1.000 | 1.000 | 1.000 | 1.000 | 0.177 | 0.999 |
| hex: http/html-1kx1024 | 2099200 | 13737.0 ± 0.4% | 1.005 | 0.194 | 0.997 | 1.000 | 1.000 | 0.937 | 0.997 | 1.010 | 1.035 | 0.186 | 1.013 |
| hex: http/html-16kx64 | 2097280 | 15216.5 ± 0.8% | 1.003 | 0.181 | 0.998 | 1.004 | 1.002 | 0.994 | 1.003 | 1.004 | 1.005 | 0.180 | 1.005 |
| hex: http/html-1m | 524290 | 15648.3 ± 0.1% | 1.002 | 0.177 | 1.002 | 1.001 | 1.001 | 1.001 | 1.002 | 1.002 | 1.001 | 0.178 | 1.002 |
| hex: http/json-1kx1024 | 2099200 | 13668.8 ± 0.3% | 1.012 | 0.196 | 0.997 | 1.004 | 1.006 | 0.942 | 0.998 | 1.012 | 1.035 | 0.188 | 1.014 |
| hex: http/json-16kx64 | 2097280 | 15228.6 ± 2.1% | 1.000 | 0.181 | 1.000 | 1.001 | 1.002 | 0.990 | 0.999 | 1.003 | 1.004 | 0.181 | 1.001 |
| hex: http/json-1m | 524290 | 15672.1 ± 0.3% | 1.001 | 0.178 | 1.000 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 1.000 | 0.177 | 1.001 |
| hex: http/js-1kx1024 | 2099200 | 13680.0 ± 1.6% | 1.006 | 0.195 | 1.001 | 1.003 | 1.003 | 0.936 | 0.998 | 1.013 | 1.036 | 0.187 | 1.014 |
| hex: http/js-16kx64 | 2097280 | 15204.0 ± 0.1% | 1.003 | 0.181 | 1.002 | 0.999 | 1.001 | 0.993 | 1.001 | 1.009 | 1.009 | 0.181 | 1.002 |
| hex: http/js-1m | 524290 | 15645.1 ± 0.5% | 1.000 | 0.177 | 1.001 | 1.001 | 1.002 | 1.000 | 1.001 | 1.001 | 1.002 | 0.177 | 1.000 |
| hex: http/css-1kx1024 | 2099200 | 13709.2 ± 0.9% | 1.004 | 0.195 | 1.002 | 1.003 | 1.002 | 0.938 | 0.995 | 1.011 | 1.035 | 0.187 | 1.013 |
| hex: http/css-16kx64 | 2097280 | 15191.8 ± 0.2% | 1.000 | 0.181 | 1.004 | 1.003 | 1.003 | 0.997 | 1.005 | 1.010 | 1.010 | 0.181 | 1.003 |
| hex: http/css-1m | 524290 | 15656.0 ± 0.3% | 1.001 | 0.177 | 1.000 | 1.001 | 1.000 | 0.999 | 1.001 | 1.001 | 1.000 | 0.177 | 1.002 |
| hex: shuffled/dickens-1m | 524290 | 15687.8 ± 0.2% | 1.001 | 0.177 | 1.001 | 1.000 | 1.000 | 0.999 | 1.001 | 1.000 | 0.999 | 0.177 | 1.001 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.052 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.055 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.234 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.231 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.231 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.236 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.261 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.259 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.258 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.259 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.208 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.207 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.209 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.214 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.256 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.250 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.252 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.252 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43349.4 ± 0.3% | 47403.4 ± 0.1% | 0.914 | — | — |
| string: silesia/nci | 1048576 | 36389.5 ± 2.1% | 38865.2 ± 2.5% | 0.936 | — | — |
| string: silesia/reymont | 1048576 | 36765.4 ± 9.6% | 38735.4 ± 10.2% | 0.949 | — | — |
| string: silesia/samba | 65546 | 43565.3 ± 0.1% | 48501.7 ± 0.1% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 38275.5 ± 5.3% | 41879.1 ± 2.9% | 0.914 | — | — |
| string: silesia/xml | 1048576 | 32937.3 ± 1.7% | 33947.3 ± 1.0% | 0.970 | — | — |
| string: canterbury/alice29.txt | 152089 | 35890.0 ± 0.3% | 36546.7 ± 0.7% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43344.2 ± 0.1% | 47672.4 ± 0.1% | 0.909 | — | — |
| string: canterbury/lcet10.txt | 426754 | 34995.2 ± 0.6% | 35747.6 ± 0.7% | 0.979 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 41097.2 ± 0.2% | 44634.5 ± 0.5% | 0.921 | — | — |
| string: canterbury-large/E.coli | 1048576 | 37604.8 ± 2.8% | 40695.5 ± 4.4% | 0.924 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 33779.0 ± 3.2% | 34503.8 ± 3.7% | 0.979 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 33229.6 ± 4.2% | 34121.4 ± 2.5% | 0.974 | — | — |
| string: http/html-1m | 1048576 | 34840.7 ± 1.7% | 37220.8 ± 4.0% | 0.936 | — | — |
| string: http/json-1m | 1048576 | 31441.3 ± 2.9% | 33160.8 ± 2.2% | 0.948 | — | — |
| string: http/js-1m | 1048576 | 38807.2 ± 5.1% | 41975.1 ± 3.9% | 0.925 | — | — |
| string: http/css-1m | 1048576 | 38008.2 ± 4.0% | 41108.3 ± 6.5% | 0.925 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5764.7 ± 0.7% | 5652.5 ± 0.3% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.914 of simdutf.
- string: silesia/nci: stdx runs at 0.936 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.914 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.909 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.921 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.924 of simdutf.
- string: http/html-1m: stdx runs at 0.936 of simdutf.
- string: http/json-1m: stdx runs at 0.948 of simdutf.
- string: http/js-1m: stdx runs at 0.925 of simdutf.
- string: http/css-1m: stdx runs at 0.925 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 39557.9 ± 1.6% | 43373.3 ± 2.6% | 0.912 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 33834.7 ± 5.5% | 34632.5 ± 4.5% | 0.977 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 38161.6 ± 4.4% | 41146.9 ± 2.3% | 0.927 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 38605.1 ± 4.1% | 42835.1 ± 4.6% | 0.901 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 39140.5 ± 4.1% | 43092.3 ± 4.2% | 0.908 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 38662.7 ± 5.0% | 42730.0 ± 3.5% | 0.905 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5741.9 ± 0.2% | 5627.8 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5739.7 ± 0.2% | 5635.4 ± 0.4% | 1.019 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5749.0 ± 0.3% | 5636.0 ± 0.1% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5745.9 ± 0.4% | 5632.1 ± 0.1% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5744.9 ± 0.5% | 5621.4 ± 0.2% | 1.022 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5752.1 ± 0.3% | 5631.4 ± 0.5% | 1.021 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1129.1 ± 0.6% | 930.8 ± 0.7% | 1021.8 ± 0.2% | 300.5 ± 1.4% | 664.0 ± 0.4% | 308.4 ± 2.2% | 1.213 | 1.105 | 3.757 | 1.700 | 3.661 |
| qlog records, JSON text sequence | 1467503 | 846.8 ± 1.8% | 817.4 ± 0.2% | 769.2 ± 0.6% | 242.8 ± 0.5% | 686.3 ± 1.4% | 235.2 ± 2.5% | 1.036 | 1.101 | 3.488 | 1.234 | 3.601 |
| string: silesia/dickens | 172528 | 5035.1 ± 0.3% | 1877.1 ± 0.1% | 2648.2 ± 0.3% | 362.6 ± 1.0% | 2862.5 ± 0.8% | 549.5 ± 2.1% | 2.682 | 1.901 | 13.887 | 1.759 | 9.163 |
| string: silesia/nci | 1075110 | 4294.1 ± 0.5% | 2240.1 ± 0.7% | 2997.6 ± 0.5% | 544.5 ± 0.7% | 3017.0 ± 0.5% | 590.8 ± 2.0% | 1.917 | 1.432 | 7.886 | 1.423 | 7.268 |
| string: silesia/reymont | 1075159 | 2919.5 ± 0.8% | 1820.5 ± 2.1% | 2063.8 ± 0.5% | 374.5 ± 0.9% | 2139.0 ± 0.6% | 526.9 ± 0.5% | 1.604 | 1.415 | 7.795 | 1.365 | 5.541 |
| string: silesia/samba | 97582 | 3494.6 ± 0.3% | 2024.2 ± 0.2% | 2617.2 ± 0.3% | 329.8 ± 0.1% | 1498.1 ± 0.8% | 426.0 ± 0.8% | 1.726 | 1.335 | 10.597 | 2.333 | 8.203 |
| string: silesia/webster | 1098490 | 3646.1 ± 0.4% | 1516.5 ± 0.3% | 2014.2 ± 0.4% | 359.6 ± 0.3% | 2177.2 ± 0.4% | 491.6 ± 1.2% | 2.404 | 1.810 | 10.140 | 1.675 | 7.416 |
| string: silesia/xml | 1090118 | 4776.7 ± 0.7% | 2357.2 ± 0.5% | 2525.1 ± 0.3% | 456.6 ± 1.3% | 2858.2 ± 1.2% | 555.1 ± 1.3% | 2.026 | 1.892 | 10.461 | 1.671 | 8.605 |
| string: canterbury/alice29.txt | 159425 | 4305.5 ± 0.8% | 1600.3 ± 0.2% | 2458.2 ± 0.6% | 342.6 ± 0.7% | 2502.5 ± 0.6% | 505.0 ± 1.5% | 2.690 | 1.751 | 12.567 | 1.720 | 8.526 |
| string: canterbury/asyoulik.txt | 132198 | 3450.5 ± 1.0% | 1459.9 ± 0.3% | 2252.9 ± 1.1% | 334.8 ± 1.4% | 2079.6 ± 0.9% | 453.2 ± 3.6% | 2.364 | 1.532 | 10.306 | 1.659 | 7.614 |
| string: canterbury/lcet10.txt | 441884 | 5099.7 ± 0.4% | 1851.8 ± 0.2% | 2335.7 ± 0.4% | 390.4 ± 0.2% | 2833.7 ± 0.7% | 534.6 ± 1.9% | 2.754 | 2.183 | 13.063 | 1.800 | 9.539 |
| string: canterbury/plrabn12.txt | 503330 | 4101.1 ± 0.8% | 1733.8 ± 0.1% | 2057.3 ± 0.2% | 361.0 ± 1.4% | 2500.2 ± 1.1% | 498.4 ± 4.0% | 2.365 | 1.993 | 11.360 | 1.640 | 8.228 |
| string: canterbury-large/E.coli | 1048578 | 19098.4 ± 1.1% | 3601.4 ± 0.5% | 3246.8 ± 0.5% | 929.5 ± 1.2% | 6030.0 ± 0.8% | 741.4 ± 1.3% | 5.303 | 5.882 | 20.547 | 3.167 | 25.760 |
| string: canterbury-large/bible.txt | 1055886 | 6662.9 ± 0.8% | 2934.4 ± 0.7% | 2824.1 ± 0.4% | 421.7 ± 0.8% | 3778.4 ± 1.5% | 604.9 ± 1.0% | 2.271 | 2.359 | 15.800 | 1.763 | 11.015 |
| string: canterbury-large/world192.txt | 1103121 | 3378.3 ± 0.4% | 1480.8 ± 0.3% | 2009.0 ± 0.2% | 353.1 ± 0.6% | 2108.8 ± 0.2% | 491.3 ± 0.7% | 2.281 | 1.682 | 9.567 | 1.602 | 6.877 |
| string: http/html-1m | 1058582 | 6048.4 ± 1.0% | 2729.6 ± 0.5% | 2685.7 ± 0.6% | 441.5 ± 0.9% | 3476.9 ± 0.8% | 588.8 ± 1.0% | 2.216 | 2.252 | 13.698 | 1.740 | 10.273 |
| string: http/json-1m | 1190272 | 2531.0 ± 0.3% | 877.5 ± 0.1% | 2247.1 ± 0.3% | 390.6 ± 0.5% | 1060.8 ± 0.5% | 425.8 ± 2.2% | 2.884 | 1.126 | 6.479 | 2.386 | 5.944 |
| string: http/js-1m | 1144362 | 2279.1 ± 0.4% | 1028.6 ± 0.5% | 1635.9 ± 0.5% | 321.3 ± 0.5% | 1521.1 ± 0.3% | 402.7 ± 4.3% | 2.216 | 1.393 | 7.095 | 1.498 | 5.659 |
| string: http/css-1m | 1097820 | 2625.0 ± 0.6% | 1675.7 ± 0.2% | 2221.1 ± 0.8% | 406.1 ± 0.2% | 1950.7 ± 0.7% | 479.6 ± 0.8% | 1.566 | 1.182 | 6.464 | 1.346 | 5.473 |
| string: dickens as Cyrillic and CJK | 1883069 | 3064.3 ± 0.8% | 1682.9 ± 0.4% | 891.8 ± 1.2% | 350.1 ± 0.2% | 665.3 ± 2.8% | 156.7 ± 2.4% | 1.821 | 3.436 | 8.753 | 4.606 | 19.558 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1325.8 ± 1.3% | 978.4 ± 0.2% | 1198.3 ± 0.3% | 216.0 ± 0.3% | 471.7 ± 0.7% | 250.0 ± 5.2% | 1.355 | 1.106 | 6.138 | 2.811 | 5.302 |
| hex: silesia/dickens | 524290 | 18823.8 ± 1.2% | 3613.0 ± 0.4% | 3297.2 ± 0.3% | 506.1 ± 1.4% | 6065.9 ± 1.2% | 781.6 ± 2.9% | 5.210 | 5.709 | 37.197 | 3.103 | 24.083 |
| hex: silesia/mozilla | 524290 | 19048.2 ± 0.6% | 3611.9 ± 0.5% | 3295.1 ± 0.5% | 453.0 ± 0.6% | 6102.9 ± 1.8% | 780.1 ± 0.3% | 5.274 | 5.781 | 42.048 | 3.121 | 24.417 |
| hex: silesia/mr | 524290 | 18664.7 ± 0.9% | 3611.8 ± 0.3% | 3288.1 ± 0.1% | 570.2 ± 1.8% | 6115.2 ± 0.9% | 779.1 ± 1.1% | 5.168 | 5.676 | 32.733 | 3.052 | 23.956 |
| hex: silesia/nci | 524290 | 18730.3 ± 1.5% | 3612.6 ± 0.6% | 3288.9 ± 0.5% | 621.2 ± 2.0% | 6061.7 ± 1.1% | 780.7 ± 0.4% | 5.185 | 5.695 | 30.150 | 3.090 | 23.993 |
| hex: silesia/ooffice | 524290 | 18861.7 ± 0.4% | 3614.0 ± 0.2% | 3304.3 ± 0.3% | 397.3 ± 1.4% | 6080.8 ± 0.4% | 780.6 ± 0.4% | 5.219 | 5.708 | 47.473 | 3.102 | 24.163 |
| hex: silesia/osdb | 524290 | 18570.0 ± 0.6% | 3609.1 ± 0.2% | 3288.0 ± 0.3% | 481.4 ± 0.3% | 6042.1 ± 0.9% | 781.3 ± 0.4% | 5.145 | 5.648 | 38.572 | 3.073 | 23.769 |
| hex: silesia/reymont | 524290 | 18835.9 ± 0.3% | 3611.5 ± 0.3% | 3291.6 ± 0.3% | 522.3 ± 3.6% | 6096.5 ± 1.5% | 781.8 ± 0.5% | 5.216 | 5.723 | 36.062 | 3.090 | 24.092 |
| hex: silesia/samba | 524290 | 18574.3 ± 0.8% | 3612.4 ± 0.4% | 3287.9 ± 0.2% | 408.6 ± 0.7% | 6020.6 ± 0.5% | 781.4 ± 0.1% | 5.142 | 5.649 | 45.460 | 3.085 | 23.769 |
| hex: silesia/sao | 524290 | 18863.1 ± 1.0% | 3611.2 ± 0.1% | 3292.7 ± 0.1% | 345.5 ± 1.9% | 6084.3 ± 1.8% | 783.1 ± 0.6% | 5.224 | 5.729 | 54.596 | 3.100 | 24.088 |
| hex: silesia/webster | 524290 | 18919.5 ± 0.4% | 3613.0 ± 0.1% | 3288.9 ± 0.2% | 472.7 ± 1.4% | 6081.2 ± 1.9% | 781.4 ± 0.2% | 5.236 | 5.753 | 40.028 | 3.111 | 24.213 |
| hex: silesia/x-ray | 524290 | 18779.8 ± 0.5% | 3611.7 ± 0.2% | 3302.3 ± 0.4% | 485.2 ± 0.3% | 6068.6 ± 1.2% | 782.9 ± 0.6% | 5.200 | 5.687 | 38.704 | 3.095 | 23.989 |
| hex: silesia/xml | 524290 | 18918.1 ± 0.4% | 3613.0 ± 0.2% | 3294.9 ± 0.3% | 533.3 ± 0.4% | 6057.7 ± 0.9% | 782.1 ± 0.6% | 5.236 | 5.742 | 35.475 | 3.123 | 24.189 |
| hex: canterbury/alice29.txt | 304180 | 18930.9 ± 1.3% | 3638.1 ± 0.2% | 3338.0 ± 0.2% | 524.0 ± 0.2% | 6060.5 ± 1.9% | 779.9 ± 1.3% | 5.204 | 5.671 | 36.125 | 3.124 | 24.274 |
| hex: canterbury/asyoulik.txt | 250360 | 18923.9 ± 0.4% | 3638.1 ± 0.1% | 3373.8 ± 0.1% | 516.9 ± 0.2% | 6072.1 ± 1.4% | 779.4 ± 1.1% | 5.202 | 5.609 | 36.610 | 3.117 | 24.279 |
| hex: canterbury/cp.html | 49208 | 19280.0 ± 0.5% | 3637.5 ± 0.4% | 3278.0 ± 0.1% | 472.0 ± 0.9% | 6277.7 ± 2.5% | 761.6 ± 1.8% | 5.300 | 5.882 | 40.844 | 3.071 | 25.316 |
| hex: canterbury/fields.c | 22302 | 18794.4 ± 1.1% | 3628.3 ± 0.2% | 3349.3 ± 0.1% | 511.5 ± 0.5% | 6257.1 ± 0.5% | 751.7 ± 3.2% | 5.180 | 5.612 | 36.743 | 3.004 | 25.003 |
| hex: canterbury/grammar.lsp | 7444 | 17417.4 ± 0.8% | 3600.9 ± 0.0% | 3354.1 ± 0.3% | 540.3 ± 1.9% | 6170.2 ± 0.8% | 714.0 ± 1.7% | 4.837 | 5.193 | 32.239 | 2.823 | 24.395 |
| hex: canterbury/kennedy.xls | 524290 | 18913.8 ± 2.4% | 3620.7 ± 0.3% | 3295.4 ± 0.1% | 663.4 ± 9.9% | 6098.0 ± 1.9% | 764.9 ± 9.8% | 5.224 | 5.739 | 28.512 | 3.102 | 24.728 |
| hex: canterbury/lcet10.txt | 524290 | 18622.1 ± 1.9% | 3616.1 ± 0.3% | 3293.3 ± 0.3% | 515.1 ± 3.7% | 6131.6 ± 1.1% | 766.1 ± 5.0% | 5.150 | 5.655 | 36.153 | 3.037 | 24.308 |
| hex: canterbury/plrabn12.txt | 524290 | 18704.9 ± 0.4% | 3618.0 ± 0.1% | 3294.0 ± 0.3% | 504.3 ± 0.3% | 6097.0 ± 2.1% | 767.5 ± 1.2% | 5.170 | 5.678 | 37.090 | 3.068 | 24.370 |
| hex: canterbury/ptt5 | 524290 | 18623.8 ± 2.1% | 3617.5 ± 0.1% | 3291.0 ± 0.5% | 559.5 ± 1.3% | 6100.1 ± 0.5% | 769.5 ± 0.7% | 5.148 | 5.659 | 33.289 | 3.053 | 24.201 |
| hex: canterbury/sum | 76482 | 19279.2 ± 0.2% | 3631.4 ± 0.1% | 3354.7 ± 0.3% | 512.4 ± 2.2% | 6166.0 ± 0.7% | 768.0 ± 1.3% | 5.309 | 5.747 | 37.626 | 3.127 | 25.102 |
| hex: canterbury/xargs.1 | 8456 | 17785.4 ± 0.1% | 3601.8 ± 0.1% | 3344.8 ± 0.3% | 505.5 ± 1.5% | 6140.3 ± 0.4% | 746.0 ± 0.6% | 4.938 | 5.317 | 35.184 | 2.897 | 23.842 |
| hex: canterbury-large/E.coli | 524290 | 19080.8 ± 1.3% | 3613.3 ± 0.3% | 3293.2 ± 0.4% | 689.4 ± 0.3% | 6078.1 ± 0.9% | 782.4 ± 7.9% | 5.281 | 5.794 | 27.678 | 3.139 | 24.388 |
| hex: canterbury-large/bible.txt | 524290 | 18973.2 ± 0.5% | 3614.2 ± 0.3% | 3306.8 ± 0.4% | 520.6 ± 1.7% | 6073.3 ± 1.5% | 779.4 ± 2.4% | 5.250 | 5.738 | 36.443 | 3.124 | 24.343 |
| hex: canterbury-large/world192.txt | 524290 | 18582.4 ± 0.6% | 3614.4 ± 0.2% | 3300.1 ± 0.4% | 499.1 ± 2.3% | 6093.6 ± 0.7% | 780.3 ± 2.1% | 5.141 | 5.631 | 37.235 | 3.049 | 23.813 |
| hex: http/html-1kx1024 | 2099200 | 9849.6 ± 18.9% | 3461.8 ± 0.1% | 2855.3 ± 0.4% | 475.6 ± 1.0% | 5139.7 ± 1.1% | 636.3 ± 2.5% | 2.845 | 3.450 | 20.708 | 1.916 | 15.478 |
| hex: http/html-16kx64 | 2097280 | 18367.8 ± 1.2% | 3607.8 ± 0.1% | 3249.9 ± 0.3% | 479.2 ± 1.3% | 6009.1 ± 0.2% | 741.8 ± 1.6% | 5.091 | 5.652 | 38.333 | 3.057 | 24.763 |
| hex: http/html-1m | 524290 | 18749.9 ± 1.8% | 3618.5 ± 0.2% | 3289.3 ± 0.2% | 501.4 ± 3.2% | 6110.6 ± 1.2% | 772.4 ± 1.8% | 5.182 | 5.700 | 37.396 | 3.068 | 24.274 |
| hex: http/json-1kx1024 | 2099200 | 9597.5 ± 20.1% | 3460.9 ± 0.3% | 2849.1 ± 0.2% | 576.2 ± 0.2% | 5124.0 ± 0.7% | 623.0 ± 2.2% | 2.773 | 3.369 | 16.657 | 1.873 | 15.406 |
| hex: http/json-16kx64 | 2097280 | 18455.5 ± 2.1% | 3606.9 ± 0.0% | 3251.8 ± 0.2% | 572.0 ± 1.1% | 6024.3 ± 2.1% | 738.4 ± 9.1% | 5.117 | 5.675 | 32.262 | 3.063 | 24.994 |
| hex: http/json-1m | 524290 | 18677.6 ± 1.9% | 3614.9 ± 0.2% | 3299.2 ± 0.4% | 597.1 ± 3.0% | 6098.3 ± 0.8% | 767.2 ± 2.0% | 5.167 | 5.661 | 31.282 | 3.063 | 24.346 |
| hex: http/js-1kx1024 | 2099200 | 9757.3 ± 18.6% | 3463.6 ± 0.2% | 2851.5 ± 0.3% | 480.7 ± 0.7% | 5127.8 ± 1.8% | 633.5 ± 5.4% | 2.817 | 3.422 | 20.300 | 1.903 | 15.401 |
| hex: http/js-16kx64 | 2097280 | 18401.1 ± 0.7% | 3611.5 ± 0.3% | 3247.6 ± 0.2% | 481.1 ± 2.4% | 6022.1 ± 0.2% | 739.2 ± 2.7% | 5.095 | 5.666 | 38.246 | 3.056 | 24.894 |
| hex: http/js-1m | 524290 | 18768.6 ± 1.0% | 3615.0 ± 0.1% | 3291.4 ± 0.3% | 509.0 ± 4.0% | 6101.0 ± 1.7% | 772.2 ± 4.4% | 5.192 | 5.702 | 36.876 | 3.076 | 24.307 |
| hex: http/css-1kx1024 | 2099200 | 9591.3 ± 20.4% | 3462.2 ± 0.2% | 2847.7 ± 0.4% | 489.0 ± 0.2% | 5143.5 ± 1.1% | 621.3 ± 0.7% | 2.770 | 3.368 | 19.615 | 1.865 | 15.438 |
| hex: http/css-16kx64 | 2097280 | 18273.2 ± 5.9% | 3607.1 ± 0.2% | 3257.9 ± 0.2% | 494.8 ± 0.8% | 6026.5 ± 0.5% | 736.4 ± 2.0% | 5.066 | 5.609 | 36.931 | 3.032 | 24.815 |
| hex: http/css-1m | 524290 | 18824.2 ± 0.8% | 3612.5 ± 0.3% | 3299.3 ± 0.7% | 503.4 ± 2.7% | 6080.6 ± 1.4% | 768.4 ± 4.3% | 5.211 | 5.706 | 37.395 | 3.096 | 24.497 |
| hex: shuffled/dickens-1m | 524290 | 18402.4 ± 0.9% | 3617.0 ± 0.1% | 3304.9 ± 0.2% | 525.7 ± 0.2% | 6074.5 ± 0.8% | 760.2 ± 1.5% | 5.088 | 5.568 | 35.004 | 3.029 | 24.207 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1473.3 ± 0.7% | 1247.9 ± 0.5% | 1036.3 ± 0.3% | 409.4 ± 0.3% | 447.7 ± 0.1% | 414.1 ± 0.2% | 1.181 | 1.422 | 3.599 | 3.291 | 3.558 |
| qlog records, JSON text sequence | 1467503 | 1255.2 ± 1.9% | 1057.4 ± 0.4% | 782.0 ± 0.8% | 380.2 ± 1.0% | 472.7 ± 1.0% | 278.0 ± 0.8% | 1.187 | 1.605 | 3.302 | 2.655 | 4.515 |
| string: silesia/dickens | 172528 | 6890.0 ± 0.4% | 2818.5 ± 0.4% | 2922.5 ± 0.3% | 428.0 ± 0.4% | 1564.1 ± 0.3% | 1009.8 ± 0.2% | 2.445 | 2.358 | 16.100 | 4.405 | 6.823 |
| string: silesia/nci | 1075110 | 7287.4 ± 0.3% | 3437.9 ± 0.5% | 3095.4 ± 0.3% | 817.0 ± 1.3% | 1854.4 ± 0.2% | 1105.9 ± 0.8% | 2.120 | 2.354 | 8.919 | 3.930 | 6.590 |
| string: silesia/reymont | 1075159 | 3336.9 ± 1.4% | 1984.4 ± 1.6% | 2061.7 ± 0.3% | 451.4 ± 0.7% | 1510.3 ± 0.2% | 946.8 ± 0.7% | 1.682 | 1.619 | 7.392 | 2.209 | 3.524 |
| string: silesia/samba | 97582 | 4189.5 ± 0.6% | 2120.1 ± 0.7% | 3448.4 ± 0.6% | 353.7 ± 0.7% | 1432.9 ± 0.4% | 1050.3 ± 0.1% | 1.976 | 1.215 | 11.846 | 2.924 | 3.989 |
| string: silesia/webster | 1098490 | 4054.7 ± 0.4% | 1881.6 ± 0.4% | 2050.9 ± 0.2% | 442.0 ± 0.4% | 1387.9 ± 0.3% | 646.5 ± 0.4% | 2.155 | 1.977 | 9.174 | 2.922 | 6.271 |
| string: silesia/xml | 1090118 | 6118.2 ± 0.3% | 2871.8 ± 0.3% | 2641.2 ± 0.4% | 610.0 ± 0.6% | 1752.1 ± 0.3% | 920.6 ± 0.3% | 2.130 | 2.317 | 10.030 | 3.492 | 6.646 |
| string: canterbury/alice29.txt | 159425 | 6425.0 ± 0.8% | 2205.4 ± 0.5% | 2761.3 ± 0.3% | 406.9 ± 0.6% | 1464.4 ± 0.4% | 953.5 ± 0.3% | 2.913 | 2.327 | 15.791 | 4.388 | 6.739 |
| string: canterbury/asyoulik.txt | 132198 | 5600.4 ± 1.9% | 1711.4 ± 0.3% | 2379.5 ± 0.6% | 402.5 ± 0.3% | 1332.2 ± 0.7% | 884.8 ± 0.3% | 3.272 | 2.354 | 13.913 | 4.204 | 6.330 |
| string: canterbury/lcet10.txt | 441884 | 6251.2 ± 0.6% | 2574.2 ± 0.4% | 2492.4 ± 1.5% | 466.5 ± 0.8% | 1524.8 ± 0.1% | 988.5 ± 0.5% | 2.428 | 2.508 | 13.401 | 4.100 | 6.324 |
| string: canterbury/plrabn12.txt | 503330 | 5716.8 ± 0.2% | 2054.3 ± 0.2% | 2068.9 ± 0.5% | 422.5 ± 0.5% | 1408.1 ± 0.4% | 932.8 ± 0.5% | 2.783 | 2.763 | 13.531 | 4.060 | 6.129 |
| string: canterbury-large/E.coli | 1048578 | 19315.2 ± 0.6% | 9825.7 ± 0.6% | 3779.7 ± 0.8% | 1475.8 ± 0.3% | 2360.9 ± 0.3% | 1188.4 ± 0.5% | 1.966 | 5.110 | 13.088 | 8.181 | 16.253 |
| string: canterbury-large/bible.txt | 1055886 | 6779.5 ± 0.4% | 4147.6 ± 2.6% | 3056.7 ± 2.2% | 501.1 ± 1.6% | 1979.6 ± 0.4% | 1120.0 ± 1.8% | 1.635 | 2.218 | 13.528 | 3.425 | 6.053 |
| string: canterbury-large/world192.txt | 1103121 | 4011.6 ± 0.5% | 1657.3 ± 0.3% | 2001.5 ± 0.4% | 448.9 ± 0.3% | 1356.3 ± 0.3% | 907.1 ± 0.3% | 2.421 | 2.004 | 8.937 | 2.958 | 4.422 |
| string: http/html-1m | 1058582 | 6748.8 ± 0.9% | 3990.5 ± 0.3% | 3031.4 ± 0.4% | 500.1 ± 0.9% | 1925.6 ± 0.3% | 804.2 ± 0.7% | 1.691 | 2.226 | 13.496 | 3.505 | 8.392 |
| string: http/json-1m | 1190272 | 3161.0 ± 0.2% | 1350.2 ± 0.4% | 1556.5 ± 0.1% | 443.4 ± 0.8% | 962.0 ± 0.2% | 765.0 ± 0.3% | 2.341 | 2.031 | 7.129 | 3.286 | 4.132 |
| string: http/js-1m | 1144362 | 2756.2 ± 0.3% | 1180.0 ± 0.5% | 1622.9 ± 0.8% | 368.5 ± 0.3% | 1092.9 ± 0.3% | 757.2 ± 0.3% | 2.336 | 1.698 | 7.479 | 2.522 | 3.640 |
| string: http/css-1m | 1097820 | 3970.5 ± 0.8% | 1484.8 ± 0.4% | 2148.7 ± 0.6% | 495.0 ± 1.0% | 1367.7 ± 0.3% | 892.3 ± 0.5% | 2.674 | 1.848 | 8.021 | 2.903 | 4.450 |
| string: dickens as Cyrillic and CJK | 1883069 | 3064.6 ± 0.4% | 2337.8 ± 0.4% | 521.0 ± 0.3% | 306.0 ± 0.5% | 564.3 ± 0.7% | 335.6 ± 0.2% | 1.311 | 5.883 | 10.016 | 5.431 | 9.131 |
| hex: silesia/dickens | 524290 | 15632.5 ± 0.1% | 1465.7 ± 0.3% | 1081.9 ± 0.2% | 495.5 ± 1.0% | 989.0 ± 0.5% | 734.8 ± 0.4% | 10.666 | 14.449 | 31.552 | 15.806 | 21.275 |
| hex: silesia/mozilla | 524290 | 15633.2 ± 0.3% | 1474.3 ± 0.2% | 1088.0 ± 0.5% | 443.0 ± 0.4% | 991.8 ± 0.4% | 734.2 ± 0.4% | 10.604 | 14.369 | 35.290 | 15.762 | 21.293 |
| hex: silesia/mr | 524290 | 15635.8 ± 0.3% | 1484.7 ± 0.3% | 1093.7 ± 0.5% | 557.8 ± 3.7% | 993.4 ± 0.4% | 735.3 ± 0.4% | 10.532 | 14.297 | 28.032 | 15.739 | 21.266 |
| hex: silesia/nci | 524290 | 15648.9 ± 0.2% | 1473.7 ± 0.2% | 1090.5 ± 0.4% | 641.4 ± 2.1% | 988.2 ± 0.2% | 735.5 ± 0.3% | 10.619 | 14.350 | 24.400 | 15.835 | 21.278 |
| hex: silesia/ooffice | 524290 | 15612.5 ± 0.4% | 1466.3 ± 0.4% | 1085.0 ± 0.6% | 389.1 ± 0.4% | 990.2 ± 0.2% | 734.2 ± 0.5% | 10.648 | 14.390 | 40.126 | 15.767 | 21.265 |
| hex: silesia/osdb | 524290 | 15653.6 ± 0.4% | 1471.3 ± 0.3% | 1086.1 ± 0.2% | 466.7 ± 1.7% | 990.9 ± 0.4% | 734.7 ± 0.5% | 10.639 | 14.413 | 33.538 | 15.798 | 21.307 |
| hex: silesia/reymont | 524290 | 15661.4 ± 0.3% | 1465.5 ± 0.4% | 1086.6 ± 0.4% | 518.6 ± 1.7% | 987.9 ± 0.4% | 735.0 ± 0.6% | 10.686 | 14.414 | 30.198 | 15.853 | 21.307 |
| hex: silesia/samba | 524290 | 15661.8 ± 0.8% | 1467.8 ± 0.3% | 1085.0 ± 0.4% | 402.7 ± 0.5% | 988.6 ± 0.3% | 735.8 ± 1.2% | 10.670 | 14.434 | 38.893 | 15.842 | 21.286 |
| hex: silesia/sao | 524290 | 15635.5 ± 0.2% | 1465.6 ± 0.4% | 1083.8 ± 0.3% | 332.3 ± 0.4% | 988.7 ± 0.3% | 735.7 ± 0.5% | 10.669 | 14.427 | 47.054 | 15.815 | 21.252 |
| hex: silesia/webster | 524290 | 15627.3 ± 0.4% | 1466.1 ± 0.3% | 1085.5 ± 0.5% | 474.1 ± 0.5% | 989.2 ± 0.3% | 734.2 ± 0.4% | 10.659 | 14.397 | 32.960 | 15.798 | 21.284 |
| hex: silesia/x-ray | 524290 | 15607.0 ± 0.3% | 1475.5 ± 0.4% | 1087.8 ± 0.3% | 446.5 ± 0.8% | 994.5 ± 0.2% | 734.3 ± 0.3% | 10.578 | 14.347 | 34.955 | 15.694 | 21.255 |
| hex: silesia/xml | 524290 | 15604.7 ± 0.3% | 1467.9 ± 0.3% | 1085.4 ± 0.8% | 618.2 ± 1.1% | 987.3 ± 0.4% | 734.8 ± 0.2% | 10.630 | 14.378 | 25.241 | 15.806 | 21.236 |
| hex: canterbury/alice29.txt | 304180 | 15658.1 ± 0.1% | 1475.5 ± 0.7% | 1088.3 ± 0.2% | 500.1 ± 2.5% | 992.4 ± 0.4% | 734.0 ± 0.3% | 10.612 | 14.388 | 31.307 | 15.778 | 21.334 |
| hex: canterbury/asyoulik.txt | 250360 | 15686.6 ± 0.1% | 1475.7 ± 0.3% | 1088.5 ± 0.2% | 489.3 ± 1.2% | 993.2 ± 0.1% | 740.5 ± 0.3% | 10.630 | 14.411 | 32.056 | 15.794 | 21.184 |
| hex: canterbury/cp.html | 49208 | 15617.3 ± 0.1% | 1470.2 ± 0.2% | 1096.7 ± 0.2% | 522.6 ± 1.6% | 1000.5 ± 0.2% | 743.2 ± 0.2% | 10.623 | 14.241 | 29.882 | 15.610 | 21.014 |
| hex: canterbury/fields.c | 22302 | 15431.7 ± 0.0% | 1417.0 ± 0.6% | 1061.1 ± 0.4% | 608.7 ± 7.2% | 987.0 ± 0.1% | 735.9 ± 0.2% | 10.891 | 14.544 | 25.350 | 15.635 | 20.970 |
| hex: canterbury/grammar.lsp | 7444 | 14939.8 ± 0.3% | 1508.7 ± 0.1% | 1091.3 ± 0.6% | 671.5 ± 6.0% | 996.0 ± 0.3% | 725.3 ± 0.1% | 9.903 | 13.690 | 22.250 | 14.999 | 20.597 |
| hex: canterbury/kennedy.xls | 524290 | 15626.5 ± 0.2% | 1476.6 ± 0.5% | 1088.2 ± 0.3% | 652.0 ± 2.7% | 988.9 ± 0.3% | 734.6 ± 0.4% | 10.583 | 14.359 | 23.967 | 15.802 | 21.273 |
| hex: canterbury/lcet10.txt | 524290 | 15582.3 ± 0.8% | 1468.4 ± 0.6% | 1081.9 ± 0.4% | 503.4 ± 0.4% | 991.1 ± 0.4% | 733.9 ± 0.5% | 10.611 | 14.403 | 30.954 | 15.723 | 21.231 |
| hex: canterbury/plrabn12.txt | 524290 | 15661.2 ± 0.1% | 1468.5 ± 0.3% | 1081.0 ± 0.4% | 490.7 ± 4.0% | 986.6 ± 0.3% | 733.5 ± 0.3% | 10.665 | 14.488 | 31.915 | 15.873 | 21.353 |
| hex: canterbury/ptt5 | 524290 | 15628.3 ± 0.2% | 1482.1 ± 0.5% | 1088.8 ± 0.5% | 555.8 ± 0.5% | 993.0 ± 0.3% | 735.0 ± 0.4% | 10.545 | 14.354 | 28.117 | 15.738 | 21.262 |
| hex: canterbury/sum | 76482 | 15640.7 ± 0.0% | 1494.4 ± 1.9% | 1103.0 ± 0.1% | 595.8 ± 0.9% | 997.9 ± 0.1% | 743.8 ± 0.1% | 10.466 | 14.180 | 26.253 | 15.674 | 21.029 |
| hex: canterbury/xargs.1 | 8456 | 15016.0 ± 0.3% | 1493.5 ± 0.7% | 1095.7 ± 0.8% | 667.0 ± 4.2% | 1002.8 ± 0.2% | 728.3 ± 0.9% | 10.054 | 13.705 | 22.513 | 14.974 | 20.618 |
| hex: canterbury-large/E.coli | 524290 | 15643.6 ± 0.3% | 1475.8 ± 0.3% | 1085.1 ± 0.4% | 671.7 ± 0.4% | 990.5 ± 0.4% | 735.0 ± 0.4% | 10.600 | 14.417 | 23.288 | 15.794 | 21.285 |
| hex: canterbury-large/bible.txt | 524290 | 15646.1 ± 0.3% | 1468.8 ± 0.2% | 1083.2 ± 0.6% | 514.5 ± 0.9% | 987.9 ± 0.2% | 735.2 ± 0.6% | 10.653 | 14.444 | 30.409 | 15.838 | 21.282 |
| hex: canterbury-large/world192.txt | 524290 | 15640.5 ± 0.4% | 1467.0 ± 0.3% | 1079.3 ± 0.3% | 501.6 ± 0.5% | 986.7 ± 0.9% | 734.2 ± 0.3% | 10.662 | 14.491 | 31.181 | 15.851 | 21.304 |
| hex: http/html-1kx1024 | 2099200 | 13737.0 ± 0.4% | 1453.8 ± 0.3% | 1062.0 ± 0.3% | 502.3 ± 0.3% | 983.3 ± 0.5% | 691.7 ± 0.1% | 9.449 | 12.934 | 27.346 | 13.970 | 19.860 |
| hex: http/html-16kx64 | 2097280 | 15216.5 ± 0.8% | 1445.9 ± 0.3% | 1074.3 ± 0.4% | 509.0 ± 0.3% | 995.5 ± 0.2% | 734.1 ± 0.3% | 10.524 | 14.164 | 29.897 | 15.285 | 20.727 |
| hex: http/html-1m | 524290 | 15648.3 ± 0.1% | 1467.7 ± 0.4% | 1081.4 ± 0.3% | 499.4 ± 0.6% | 983.1 ± 0.9% | 731.5 ± 0.5% | 10.662 | 14.471 | 31.332 | 15.917 | 21.393 |
| hex: http/json-1kx1024 | 2099200 | 13668.8 ± 0.3% | 1463.4 ± 0.1% | 1066.5 ± 0.3% | 609.0 ± 0.8% | 985.9 ± 0.2% | 691.6 ± 0.4% | 9.341 | 12.816 | 22.443 | 13.864 | 19.764 |
| hex: http/json-16kx64 | 2097280 | 15228.6 ± 2.1% | 1447.9 ± 0.5% | 1074.6 ± 0.4% | 617.5 ± 0.8% | 993.7 ± 0.5% | 734.8 ± 0.6% | 10.518 | 14.172 | 24.664 | 15.326 | 20.725 |
| hex: http/json-1m | 524290 | 15672.1 ± 0.3% | 1475.7 ± 0.5% | 1090.4 ± 0.2% | 634.6 ± 1.4% | 991.7 ± 0.4% | 734.7 ± 0.6% | 10.620 | 14.373 | 24.696 | 15.803 | 21.332 |
| hex: http/js-1kx1024 | 2099200 | 13680.0 ± 1.6% | 1455.0 ± 0.1% | 1062.8 ± 0.3% | 498.9 ± 0.3% | 983.8 ± 0.2% | 692.1 ± 0.2% | 9.402 | 12.872 | 27.420 | 13.906 | 19.765 |
| hex: http/js-16kx64 | 2097280 | 15204.0 ± 0.1% | 1444.2 ± 0.3% | 1073.4 ± 0.5% | 503.8 ± 0.9% | 994.1 ± 0.4% | 734.7 ± 0.1% | 10.528 | 14.164 | 30.178 | 15.294 | 20.695 |
| hex: http/js-1m | 524290 | 15645.1 ± 0.5% | 1466.3 ± 0.3% | 1081.6 ± 0.7% | 509.3 ± 0.6% | 983.9 ± 0.4% | 734.2 ± 0.4% | 10.670 | 14.465 | 30.716 | 15.901 | 21.309 |
| hex: http/css-1kx1024 | 2099200 | 13709.2 ± 0.9% | 1454.5 ± 0.2% | 1062.0 ± 0.1% | 531.4 ± 0.3% | 983.5 ± 0.0% | 692.1 ± 0.2% | 9.425 | 12.909 | 25.796 | 13.939 | 19.809 |
| hex: http/css-16kx64 | 2097280 | 15191.8 ± 0.2% | 1442.2 ± 0.2% | 1074.5 ± 0.2% | 541.6 ± 1.0% | 998.9 ± 0.3% | 734.9 ± 0.4% | 10.534 | 14.138 | 28.051 | 15.208 | 20.673 |
| hex: http/css-1m | 524290 | 15656.0 ± 0.3% | 1467.0 ± 0.2% | 1084.0 ± 0.8% | 528.5 ± 0.3% | 988.9 ± 0.3% | 733.8 ± 0.3% | 10.672 | 14.443 | 29.621 | 15.831 | 21.336 |
| hex: shuffled/dickens-1m | 524290 | 15687.8 ± 0.2% | 1466.4 ± 0.3% | 1083.4 ± 0.4% | 503.2 ± 0.6% | 988.4 ± 0.4% | 734.3 ± 0.2% | 10.698 | 14.480 | 31.175 | 15.872 | 21.363 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1516.5 ± 0.2% | 1247.9 ± 0.5% | 1036.3 ± 0.3% | 409.4 ± 0.3% | 447.7 ± 0.1% | 414.1 ± 0.2% | 1.215 | 1.463 | 3.704 | 3.387 | 3.662 |
| qlog records, JSON text sequence | 1467503 | 1285.1 ± 0.5% | 1057.4 ± 0.4% | 782.0 ± 0.8% | 380.2 ± 1.0% | 472.7 ± 1.0% | 278.0 ± 0.8% | 1.215 | 1.643 | 3.380 | 2.719 | 4.623 |
| string: silesia/dickens | 172528 | 7133.0 ± 0.6% | 2818.5 ± 0.4% | 2922.5 ± 0.3% | 428.0 ± 0.4% | 1564.1 ± 0.3% | 1009.8 ± 0.2% | 2.531 | 2.441 | 16.668 | 4.560 | 7.064 |
| string: silesia/nci | 1075110 | 7356.3 ± 7.0% | 3437.9 ± 0.5% | 3095.4 ± 0.3% | 817.0 ± 1.3% | 1854.4 ± 0.2% | 1105.9 ± 0.8% | 2.140 | 2.377 | 9.004 | 3.967 | 6.652 |
| string: silesia/reymont | 1075159 | 3498.8 ± 1.0% | 1984.4 ± 1.6% | 2061.7 ± 0.3% | 451.4 ± 0.7% | 1510.3 ± 0.2% | 946.8 ± 0.7% | 1.763 | 1.697 | 7.750 | 2.317 | 3.695 |
| string: silesia/samba | 97582 | 4566.0 ± 1.8% | 2120.1 ± 0.7% | 3448.4 ± 0.6% | 353.7 ± 0.7% | 1432.9 ± 0.4% | 1050.3 ± 0.1% | 2.154 | 1.324 | 12.911 | 3.186 | 4.347 |
| string: silesia/webster | 1098490 | 4087.2 ± 0.6% | 1881.6 ± 0.4% | 2050.9 ± 0.2% | 442.0 ± 0.4% | 1387.9 ± 0.3% | 646.5 ± 0.4% | 2.172 | 1.993 | 9.247 | 2.945 | 6.322 |
| string: silesia/xml | 1090118 | 6240.9 ± 1.1% | 2871.8 ± 0.3% | 2641.2 ± 0.4% | 610.0 ± 0.6% | 1752.1 ± 0.3% | 920.6 ± 0.3% | 2.173 | 2.363 | 10.231 | 3.562 | 6.779 |
| string: canterbury/alice29.txt | 159425 | 6826.7 ± 2.5% | 2205.4 ± 0.5% | 2761.3 ± 0.3% | 406.9 ± 0.6% | 1464.4 ± 0.4% | 953.5 ± 0.3% | 3.095 | 2.472 | 16.779 | 4.662 | 7.160 |
| string: canterbury/asyoulik.txt | 132198 | 5908.3 ± 2.9% | 1711.4 ± 0.3% | 2379.5 ± 0.6% | 402.5 ± 0.3% | 1332.2 ± 0.7% | 884.8 ± 0.3% | 3.452 | 2.483 | 14.677 | 4.435 | 6.678 |
| string: canterbury/lcet10.txt | 441884 | 6266.0 ± 1.2% | 2574.2 ± 0.4% | 2492.4 ± 1.5% | 466.5 ± 0.8% | 1524.8 ± 0.1% | 988.5 ± 0.5% | 2.434 | 2.514 | 13.432 | 4.109 | 6.339 |
| string: canterbury/plrabn12.txt | 503330 | 5742.7 ± 0.3% | 2054.3 ± 0.2% | 2068.9 ± 0.5% | 422.5 ± 0.5% | 1408.1 ± 0.4% | 932.8 ± 0.5% | 2.795 | 2.776 | 13.593 | 4.078 | 6.156 |
| string: canterbury-large/E.coli | 1048578 | 19348.1 ± 0.5% | 9825.7 ± 0.6% | 3779.7 ± 0.8% | 1475.8 ± 0.3% | 2360.9 ± 0.3% | 1188.4 ± 0.5% | 1.969 | 5.119 | 13.110 | 8.195 | 16.281 |
| string: canterbury-large/bible.txt | 1055886 | 6795.5 ± 0.4% | 4147.6 ± 2.6% | 3056.7 ± 2.2% | 501.1 ± 1.6% | 1979.6 ± 0.4% | 1120.0 ± 1.8% | 1.638 | 2.223 | 13.560 | 3.433 | 6.068 |
| string: canterbury-large/world192.txt | 1103121 | 4026.6 ± 0.8% | 1657.3 ± 0.3% | 2001.5 ± 0.4% | 448.9 ± 0.3% | 1356.3 ± 0.3% | 907.1 ± 0.3% | 2.430 | 2.012 | 8.970 | 2.969 | 4.439 |
| string: http/html-1m | 1058582 | 6799.0 ± 0.2% | 3990.5 ± 0.3% | 3031.4 ± 0.4% | 500.1 ± 0.9% | 1925.6 ± 0.3% | 804.2 ± 0.7% | 1.704 | 2.243 | 13.596 | 3.531 | 8.454 |
| string: http/json-1m | 1190272 | 3290.7 ± 0.8% | 1350.2 ± 0.4% | 1556.5 ± 0.1% | 443.4 ± 0.8% | 962.0 ± 0.2% | 765.0 ± 0.3% | 2.437 | 2.114 | 7.422 | 3.420 | 4.302 |
| string: http/js-1m | 1144362 | 2789.4 ± 1.2% | 1180.0 ± 0.5% | 1622.9 ± 0.8% | 368.5 ± 0.3% | 1092.9 ± 0.3% | 757.2 ± 0.3% | 2.364 | 1.719 | 7.569 | 2.552 | 3.684 |
| string: http/css-1m | 1097820 | 4025.7 ± 1.0% | 1484.8 ± 0.4% | 2148.7 ± 0.6% | 495.0 ± 1.0% | 1367.7 ± 0.3% | 892.3 ± 0.5% | 2.711 | 1.874 | 8.132 | 2.943 | 4.511 |
| string: dickens as Cyrillic and CJK | 1883069 | 3068.4 ± 0.5% | 2337.8 ± 0.4% | 521.0 ± 0.3% | 306.0 ± 0.5% | 564.3 ± 0.7% | 335.6 ± 0.2% | 1.313 | 5.890 | 10.028 | 5.437 | 9.143 |
| hex: silesia/dickens | 524290 | 15590.6 ± 0.4% | 1465.7 ± 0.3% | 1081.9 ± 0.2% | 495.5 ± 1.0% | 989.0 ± 0.5% | 734.8 ± 0.4% | 10.637 | 14.410 | 31.467 | 15.764 | 21.217 |
| hex: silesia/mozilla | 524290 | 15594.4 ± 0.6% | 1474.3 ± 0.2% | 1088.0 ± 0.5% | 443.0 ± 0.4% | 991.8 ± 0.4% | 734.2 ± 0.4% | 10.578 | 14.334 | 35.203 | 15.723 | 21.240 |
| hex: silesia/mr | 524290 | 15641.9 ± 0.4% | 1484.7 ± 0.3% | 1093.7 ± 0.5% | 557.8 ± 3.7% | 993.4 ± 0.4% | 735.3 ± 0.4% | 10.536 | 14.302 | 28.043 | 15.745 | 21.274 |
| hex: silesia/nci | 524290 | 15683.4 ± 0.3% | 1473.7 ± 0.2% | 1090.5 ± 0.4% | 641.4 ± 2.1% | 988.2 ± 0.2% | 735.5 ± 0.3% | 10.642 | 14.382 | 24.454 | 15.870 | 21.325 |
| hex: silesia/ooffice | 524290 | 15633.0 ± 0.2% | 1466.3 ± 0.4% | 1085.0 ± 0.6% | 389.1 ± 0.4% | 990.2 ± 0.2% | 734.2 ± 0.5% | 10.662 | 14.409 | 40.179 | 15.787 | 21.293 |
| hex: silesia/osdb | 524290 | 15645.1 ± 0.2% | 1471.3 ± 0.3% | 1086.1 ± 0.2% | 466.7 ± 1.7% | 990.9 ± 0.4% | 734.7 ± 0.5% | 10.634 | 14.405 | 33.519 | 15.789 | 21.295 |
| hex: silesia/reymont | 524290 | 15688.2 ± 0.2% | 1465.5 ± 0.4% | 1086.6 ± 0.4% | 518.6 ± 1.7% | 987.9 ± 0.4% | 735.0 ± 0.6% | 10.705 | 14.438 | 30.250 | 15.880 | 21.344 |
| hex: silesia/samba | 524290 | 15662.6 ± 0.2% | 1467.8 ± 0.3% | 1085.0 ± 0.4% | 402.7 ± 0.5% | 988.6 ± 0.3% | 735.8 ± 1.2% | 10.671 | 14.435 | 38.895 | 15.843 | 21.287 |
| hex: silesia/sao | 524290 | 15648.1 ± 0.3% | 1465.6 ± 0.4% | 1083.8 ± 0.3% | 332.3 ± 0.4% | 988.7 ± 0.3% | 735.7 ± 0.5% | 10.677 | 14.439 | 47.092 | 15.827 | 21.269 |
| hex: silesia/webster | 524290 | 15614.5 ± 0.3% | 1466.1 ± 0.3% | 1085.5 ± 0.5% | 474.1 ± 0.5% | 989.2 ± 0.3% | 734.2 ± 0.4% | 10.650 | 14.385 | 32.933 | 15.785 | 21.267 |
| hex: silesia/x-ray | 524290 | 15646.6 ± 0.1% | 1475.5 ± 0.4% | 1087.8 ± 0.3% | 446.5 ± 0.8% | 994.5 ± 0.2% | 734.3 ± 0.3% | 10.604 | 14.383 | 35.044 | 15.733 | 21.308 |
| hex: silesia/xml | 524290 | 15621.4 ± 0.4% | 1467.9 ± 0.3% | 1085.4 ± 0.8% | 618.2 ± 1.1% | 987.3 ± 0.4% | 734.8 ± 0.2% | 10.642 | 14.393 | 25.268 | 15.823 | 21.259 |
| hex: canterbury/alice29.txt | 304180 | 15686.3 ± 0.1% | 1475.5 ± 0.7% | 1088.3 ± 0.2% | 500.1 ± 2.5% | 992.4 ± 0.4% | 734.0 ± 0.3% | 10.631 | 14.414 | 31.363 | 15.806 | 21.372 |
| hex: canterbury/asyoulik.txt | 250360 | 15714.4 ± 0.0% | 1475.7 ± 0.3% | 1088.5 ± 0.2% | 489.3 ± 1.2% | 993.2 ± 0.1% | 740.5 ± 0.3% | 10.649 | 14.437 | 32.113 | 15.822 | 21.221 |
| hex: canterbury/cp.html | 49208 | 15636.4 ± 0.0% | 1470.2 ± 0.2% | 1096.7 ± 0.2% | 522.6 ± 1.6% | 1000.5 ± 0.2% | 743.2 ± 0.2% | 10.636 | 14.258 | 29.918 | 15.629 | 21.040 |
| hex: canterbury/fields.c | 22302 | 15450.7 ± 0.0% | 1417.0 ± 0.6% | 1061.1 ± 0.4% | 608.7 ± 7.2% | 987.0 ± 0.1% | 735.9 ± 0.2% | 10.904 | 14.561 | 25.382 | 15.654 | 20.996 |
| hex: canterbury/grammar.lsp | 7444 | 14991.8 ± 0.1% | 1508.7 ± 0.1% | 1091.3 ± 0.6% | 671.5 ± 6.0% | 996.0 ± 0.3% | 725.3 ± 0.1% | 9.937 | 13.738 | 22.327 | 15.052 | 20.669 |
| hex: canterbury/kennedy.xls | 524290 | 15622.3 ± 0.2% | 1476.6 ± 0.5% | 1088.2 ± 0.3% | 652.0 ± 2.7% | 988.9 ± 0.3% | 734.6 ± 0.4% | 10.580 | 14.355 | 23.961 | 15.798 | 21.267 |
| hex: canterbury/lcet10.txt | 524290 | 15588.1 ± 0.8% | 1468.4 ± 0.6% | 1081.9 ± 0.4% | 503.4 ± 0.4% | 991.1 ± 0.4% | 733.9 ± 0.5% | 10.615 | 14.408 | 30.966 | 15.729 | 21.239 |
| hex: canterbury/plrabn12.txt | 524290 | 15670.8 ± 0.1% | 1468.5 ± 0.3% | 1081.0 ± 0.4% | 490.7 ± 4.0% | 986.6 ± 0.3% | 733.5 ± 0.3% | 10.672 | 14.497 | 31.934 | 15.883 | 21.365 |
| hex: canterbury/ptt5 | 524290 | 15646.4 ± 0.4% | 1482.1 ± 0.5% | 1088.8 ± 0.5% | 555.8 ± 0.5% | 993.0 ± 0.3% | 735.0 ± 0.4% | 10.557 | 14.371 | 28.150 | 15.757 | 21.287 |
| hex: canterbury/sum | 76482 | 15649.4 ± 0.0% | 1494.4 ± 1.9% | 1103.0 ± 0.1% | 595.8 ± 0.9% | 997.9 ± 0.1% | 743.8 ± 0.1% | 10.472 | 14.188 | 26.268 | 15.683 | 21.040 |
| hex: canterbury/xargs.1 | 8456 | 15049.5 ± 0.0% | 1493.5 ± 0.7% | 1095.7 ± 0.8% | 667.0 ± 4.2% | 1002.8 ± 0.2% | 728.3 ± 0.9% | 10.076 | 13.735 | 22.563 | 15.008 | 20.664 |
| hex: canterbury-large/E.coli | 524290 | 15677.0 ± 0.1% | 1475.8 ± 0.3% | 1085.1 ± 0.4% | 671.7 ± 0.4% | 990.5 ± 0.4% | 735.0 ± 0.4% | 10.623 | 14.448 | 23.338 | 15.828 | 21.331 |
| hex: canterbury-large/bible.txt | 524290 | 15671.3 ± 0.6% | 1468.8 ± 0.2% | 1083.2 ± 0.6% | 514.5 ± 0.9% | 987.9 ± 0.2% | 735.2 ± 0.6% | 10.670 | 14.468 | 30.458 | 15.864 | 21.316 |
| hex: canterbury-large/world192.txt | 524290 | 15620.9 ± 0.6% | 1467.0 ± 0.3% | 1079.3 ± 0.3% | 501.6 ± 0.5% | 986.7 ± 0.9% | 734.2 ± 0.3% | 10.648 | 14.473 | 31.142 | 15.831 | 21.277 |
| hex: http/html-1kx1024 | 2099200 | 13916.1 ± 0.5% | 1453.8 ± 0.3% | 1062.0 ± 0.3% | 502.3 ± 0.3% | 983.3 ± 0.5% | 691.7 ± 0.1% | 9.572 | 13.103 | 27.703 | 14.152 | 20.119 |
| hex: http/html-16kx64 | 2097280 | 15290.5 ± 0.5% | 1445.9 ± 0.3% | 1074.3 ± 0.4% | 509.0 ± 0.3% | 995.5 ± 0.2% | 734.1 ± 0.3% | 10.575 | 14.233 | 30.043 | 15.359 | 20.828 |
| hex: http/html-1m | 524290 | 15675.1 ± 0.3% | 1467.7 ± 0.4% | 1081.4 ± 0.3% | 499.4 ± 0.6% | 983.1 ± 0.9% | 731.5 ± 0.5% | 10.680 | 14.496 | 31.386 | 15.944 | 21.429 |
| hex: http/json-1kx1024 | 2099200 | 13864.4 ± 1.0% | 1463.4 ± 0.1% | 1066.5 ± 0.3% | 609.0 ± 0.8% | 985.9 ± 0.2% | 691.6 ± 0.4% | 9.474 | 13.000 | 22.764 | 14.063 | 20.047 |
| hex: http/json-16kx64 | 2097280 | 15248.0 ± 0.4% | 1447.9 ± 0.5% | 1074.6 ± 0.4% | 617.5 ± 0.8% | 993.7 ± 0.5% | 734.8 ± 0.6% | 10.531 | 14.190 | 24.695 | 15.345 | 20.752 |
| hex: http/json-1m | 524290 | 15680.4 ± 0.3% | 1475.7 ± 0.5% | 1090.4 ± 0.2% | 634.6 ± 1.4% | 991.7 ± 0.4% | 734.7 ± 0.6% | 10.625 | 14.381 | 24.709 | 15.812 | 21.343 |
| hex: http/js-1kx1024 | 2099200 | 13869.6 ± 0.6% | 1455.0 ± 0.1% | 1062.8 ± 0.3% | 498.9 ± 0.3% | 983.8 ± 0.2% | 692.1 ± 0.2% | 9.532 | 13.051 | 27.799 | 14.098 | 20.039 |
| hex: http/js-16kx64 | 2097280 | 15230.7 ± 0.2% | 1444.2 ± 0.3% | 1073.4 ± 0.5% | 503.8 ± 0.9% | 994.1 ± 0.4% | 734.7 ± 0.1% | 10.546 | 14.189 | 30.231 | 15.320 | 20.732 |
| hex: http/js-1m | 524290 | 15647.7 ± 0.2% | 1466.3 ± 0.3% | 1081.6 ± 0.7% | 509.3 ± 0.6% | 983.9 ± 0.4% | 734.2 ± 0.4% | 10.672 | 14.467 | 30.721 | 15.904 | 21.313 |
| hex: http/css-1kx1024 | 2099200 | 13893.6 ± 0.3% | 1454.5 ± 0.2% | 1062.0 ± 0.1% | 531.4 ± 0.3% | 983.5 ± 0.0% | 692.1 ± 0.2% | 9.552 | 13.082 | 26.143 | 14.126 | 20.075 |
| hex: http/css-16kx64 | 2097280 | 15240.4 ± 0.4% | 1442.2 ± 0.2% | 1074.5 ± 0.2% | 541.6 ± 1.0% | 998.9 ± 0.3% | 734.9 ± 0.4% | 10.568 | 14.183 | 28.140 | 15.257 | 20.739 |
| hex: http/css-1m | 524290 | 15681.3 ± 0.4% | 1467.0 ± 0.2% | 1084.0 ± 0.8% | 528.5 ± 0.3% | 988.9 ± 0.3% | 733.8 ± 0.3% | 10.689 | 14.466 | 29.669 | 15.857 | 21.370 |
| hex: shuffled/dickens-1m | 524290 | 15707.0 ± 0.3% | 1466.4 ± 0.3% | 1083.4 ± 0.4% | 503.2 ± 0.6% | 988.4 ± 0.4% | 734.3 ± 0.2% | 10.711 | 14.498 | 31.213 | 15.892 | 21.389 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.2 ± 0.3% | 930.8 ± 0.7% | 1021.8 ± 0.2% | 300.5 ± 1.4% | 664.0 ± 0.4% | 308.4 ± 2.2% | 1.007 | 0.917 | 3.118 | 1.411 | 3.039 |
| qlog records, JSON text sequence | 1467503 | 777.5 ± 0.9% | 817.4 ± 0.2% | 769.2 ± 0.6% | 242.8 ± 0.5% | 686.3 ± 1.4% | 235.2 ± 2.5% | 0.951 | 1.011 | 3.202 | 1.133 | 3.306 |
| string: silesia/dickens | 172528 | 5047.5 ± 0.3% | 1877.1 ± 0.1% | 2648.2 ± 0.3% | 362.6 ± 1.0% | 2862.5 ± 0.8% | 549.5 ± 2.1% | 2.689 | 1.906 | 13.921 | 1.763 | 9.185 |
| string: silesia/nci | 1075110 | 4304.5 ± 0.5% | 2240.1 ± 0.7% | 2997.6 ± 0.5% | 544.5 ± 0.7% | 3017.0 ± 0.5% | 590.8 ± 2.0% | 1.922 | 1.436 | 7.905 | 1.427 | 7.285 |
| string: silesia/reymont | 1075159 | 2981.5 ± 1.4% | 1820.5 ± 2.1% | 2063.8 ± 0.5% | 374.5 ± 0.9% | 2139.0 ± 0.6% | 526.9 ± 0.5% | 1.638 | 1.445 | 7.961 | 1.394 | 5.659 |
| string: silesia/samba | 97582 | 3505.1 ± 0.4% | 2024.2 ± 0.2% | 2617.2 ± 0.3% | 329.8 ± 0.1% | 1498.1 ± 0.8% | 426.0 ± 0.8% | 1.732 | 1.339 | 10.629 | 2.340 | 8.227 |
| string: silesia/webster | 1098490 | 3678.7 ± 0.7% | 1516.5 ± 0.3% | 2014.2 ± 0.4% | 359.6 ± 0.3% | 2177.2 ± 0.4% | 491.6 ± 1.2% | 2.426 | 1.826 | 10.230 | 1.690 | 7.483 |
| string: silesia/xml | 1090118 | 4813.6 ± 0.3% | 2357.2 ± 0.5% | 2525.1 ± 0.3% | 456.6 ± 1.3% | 2858.2 ± 1.2% | 555.1 ± 1.3% | 2.042 | 1.906 | 10.542 | 1.684 | 8.671 |
| string: canterbury/alice29.txt | 159425 | 4348.3 ± 1.0% | 1600.3 ± 0.2% | 2458.2 ± 0.6% | 342.6 ± 0.7% | 2502.5 ± 0.6% | 505.0 ± 1.5% | 2.717 | 1.769 | 12.693 | 1.738 | 8.611 |
| string: canterbury/asyoulik.txt | 132198 | 3499.1 ± 0.8% | 1459.9 ± 0.3% | 2252.9 ± 1.1% | 334.8 ± 1.4% | 2079.6 ± 0.9% | 453.2 ± 3.6% | 2.397 | 1.553 | 10.451 | 1.683 | 7.721 |
| string: canterbury/lcet10.txt | 441884 | 5131.8 ± 0.4% | 1851.8 ± 0.2% | 2335.7 ± 0.4% | 390.4 ± 0.2% | 2833.7 ± 0.7% | 534.6 ± 1.9% | 2.771 | 2.197 | 13.145 | 1.811 | 9.599 |
| string: canterbury/plrabn12.txt | 503330 | 4140.1 ± 0.5% | 1733.8 ± 0.1% | 2057.3 ± 0.2% | 361.0 ± 1.4% | 2500.2 ± 1.1% | 498.4 ± 4.0% | 2.388 | 2.012 | 11.468 | 1.656 | 8.306 |
| string: canterbury-large/E.coli | 1048578 | 11906.8 ± 0.3% | 3601.4 ± 0.5% | 3246.8 ± 0.5% | 929.5 ± 1.2% | 6030.0 ± 0.8% | 741.4 ± 1.3% | 3.306 | 3.667 | 12.810 | 1.975 | 16.060 |
| string: canterbury-large/bible.txt | 1055886 | 6902.4 ± 1.3% | 2934.4 ± 0.7% | 2824.1 ± 0.4% | 421.7 ± 0.8% | 3778.4 ± 1.5% | 604.9 ± 1.0% | 2.352 | 2.444 | 16.367 | 1.827 | 11.411 |
| string: canterbury-large/world192.txt | 1103121 | 3393.4 ± 0.3% | 1480.8 ± 0.3% | 2009.0 ± 0.2% | 353.1 ± 0.6% | 2108.8 ± 0.2% | 491.3 ± 0.7% | 2.292 | 1.689 | 9.610 | 1.609 | 6.907 |
| string: http/html-1m | 1058582 | 6229.0 ± 1.0% | 2729.6 ± 0.5% | 2685.7 ± 0.6% | 441.5 ± 0.9% | 3476.9 ± 0.8% | 588.8 ± 1.0% | 2.282 | 2.319 | 14.107 | 1.792 | 10.579 |
| string: http/json-1m | 1190272 | 2559.5 ± 0.9% | 877.5 ± 0.1% | 2247.1 ± 0.3% | 390.6 ± 0.5% | 1060.8 ± 0.5% | 425.8 ± 2.2% | 2.917 | 1.139 | 6.552 | 2.413 | 6.011 |
| string: http/js-1m | 1144362 | 2290.9 ± 0.5% | 1028.6 ± 0.5% | 1635.9 ± 0.5% | 321.3 ± 0.5% | 1521.1 ± 0.3% | 402.7 ± 4.3% | 2.227 | 1.400 | 7.131 | 1.506 | 5.688 |
| string: http/css-1m | 1097820 | 2650.7 ± 0.9% | 1675.7 ± 0.2% | 2221.1 ± 0.8% | 406.1 ± 0.2% | 1950.7 ± 0.7% | 479.6 ± 0.8% | 1.582 | 1.193 | 6.527 | 1.359 | 5.527 |
| string: dickens as Cyrillic and CJK | 1883069 | 3079.1 ± 0.5% | 1682.9 ± 0.4% | 891.8 ± 1.2% | 350.1 ± 0.2% | 665.3 ± 2.8% | 156.7 ± 2.4% | 1.830 | 3.453 | 8.795 | 4.628 | 19.652 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.9 ± 0.2% | 978.4 ± 0.2% | 1198.3 ± 0.3% | 216.0 ± 0.3% | 471.7 ± 0.7% | 250.0 ± 5.2% | 1.359 | 1.110 | 6.157 | 2.820 | 5.319 |
| hex: silesia/dickens | 524290 | 11941.9 ± 0.1% | 3613.0 ± 0.4% | 3297.2 ± 0.3% | 506.1 ± 1.4% | 6065.9 ± 1.2% | 781.6 ± 2.9% | 3.305 | 3.622 | 23.598 | 1.969 | 15.279 |
| hex: silesia/mozilla | 524290 | 11970.3 ± 0.2% | 3611.9 ± 0.5% | 3295.1 ± 0.5% | 453.0 ± 0.6% | 6102.9 ± 1.8% | 780.1 ± 0.3% | 3.314 | 3.633 | 26.424 | 1.961 | 15.344 |
| hex: silesia/mr | 524290 | 11983.3 ± 0.1% | 3611.8 ± 0.3% | 3288.1 ± 0.1% | 570.2 ± 1.8% | 6115.2 ± 0.9% | 779.1 ± 1.1% | 3.318 | 3.644 | 21.015 | 1.960 | 15.381 |
| hex: silesia/nci | 524290 | 12005.2 ± 0.1% | 3612.6 ± 0.6% | 3288.9 ± 0.5% | 621.2 ± 2.0% | 6061.7 ± 1.1% | 780.7 ± 0.4% | 3.323 | 3.650 | 19.324 | 1.980 | 15.378 |
| hex: silesia/ooffice | 524290 | 12002.6 ± 0.2% | 3614.0 ± 0.2% | 3304.3 ± 0.3% | 397.3 ± 1.4% | 6080.8 ± 0.4% | 780.6 ± 0.4% | 3.321 | 3.632 | 30.209 | 1.974 | 15.376 |
| hex: silesia/osdb | 524290 | 11980.6 ± 0.2% | 3609.1 ± 0.2% | 3288.0 ± 0.3% | 481.4 ± 0.3% | 6042.1 ± 0.9% | 781.3 ± 0.4% | 3.320 | 3.644 | 24.885 | 1.983 | 15.335 |
| hex: silesia/reymont | 524290 | 12011.6 ± 0.1% | 3611.5 ± 0.3% | 3291.6 ± 0.3% | 522.3 ± 3.6% | 6096.5 ± 1.5% | 781.8 ± 0.5% | 3.326 | 3.649 | 22.996 | 1.970 | 15.363 |
| hex: silesia/samba | 524290 | 11972.1 ± 0.2% | 3612.4 ± 0.4% | 3287.9 ± 0.2% | 408.6 ± 0.7% | 6020.6 ± 0.5% | 781.4 ± 0.1% | 3.314 | 3.641 | 29.302 | 1.989 | 15.321 |
| hex: silesia/sao | 524290 | 12006.5 ± 0.1% | 3611.2 ± 0.1% | 3292.7 ± 0.1% | 345.5 ± 1.9% | 6084.3 ± 1.8% | 783.1 ± 0.6% | 3.325 | 3.646 | 34.751 | 1.973 | 15.332 |
| hex: silesia/webster | 524290 | 11983.0 ± 0.1% | 3613.0 ± 0.1% | 3288.9 ± 0.2% | 472.7 ± 1.4% | 6081.2 ± 1.9% | 781.4 ± 0.2% | 3.317 | 3.643 | 25.352 | 1.971 | 15.335 |
| hex: silesia/x-ray | 524290 | 12003.7 ± 0.2% | 3611.7 ± 0.2% | 3302.3 ± 0.4% | 485.2 ± 0.3% | 6068.6 ± 1.2% | 782.9 ± 0.6% | 3.324 | 3.635 | 24.739 | 1.978 | 15.333 |
| hex: silesia/xml | 524290 | 11966.6 ± 0.3% | 3613.0 ± 0.2% | 3294.9 ± 0.3% | 533.3 ± 0.4% | 6057.7 ± 0.9% | 782.1 ± 0.6% | 3.312 | 3.632 | 22.440 | 1.975 | 15.301 |
| hex: canterbury/alice29.txt | 304180 | 11998.7 ± 0.1% | 3638.1 ± 0.2% | 3338.0 ± 0.2% | 524.0 ± 0.2% | 6060.5 ± 1.9% | 779.9 ± 1.3% | 3.298 | 3.595 | 22.896 | 1.980 | 15.385 |
| hex: canterbury/asyoulik.txt | 250360 | 12000.8 ± 0.1% | 3638.1 ± 0.1% | 3373.8 ± 0.1% | 516.9 ± 0.2% | 6072.1 ± 1.4% | 779.4 ± 1.1% | 3.299 | 3.557 | 23.216 | 1.976 | 15.397 |
| hex: canterbury/cp.html | 49208 | 11909.0 ± 0.2% | 3637.5 ± 0.4% | 3278.0 ± 0.1% | 472.0 ± 0.9% | 6277.7 ± 2.5% | 761.6 ± 1.8% | 3.274 | 3.633 | 25.229 | 1.897 | 15.637 |
| hex: canterbury/fields.c | 22302 | 11773.0 ± 0.0% | 3628.3 ± 0.2% | 3349.3 ± 0.1% | 511.5 ± 0.5% | 6257.1 ± 0.5% | 751.7 ± 3.2% | 3.245 | 3.515 | 23.016 | 1.882 | 15.662 |
| hex: canterbury/grammar.lsp | 7444 | 11250.9 ± 0.1% | 3600.9 ± 0.0% | 3354.1 ± 0.3% | 540.3 ± 1.9% | 6170.2 ± 0.8% | 714.0 ± 1.7% | 3.124 | 3.354 | 20.825 | 1.823 | 15.758 |
| hex: canterbury/kennedy.xls | 524290 | 11995.4 ± 0.1% | 3620.7 ± 0.3% | 3295.4 ± 0.1% | 663.4 ± 9.9% | 6098.0 ± 1.9% | 764.9 ± 9.8% | 3.313 | 3.640 | 18.083 | 1.967 | 15.682 |
| hex: canterbury/lcet10.txt | 524290 | 12008.1 ± 0.4% | 3616.1 ± 0.3% | 3293.3 ± 0.3% | 515.1 ± 3.7% | 6131.6 ± 1.1% | 766.1 ± 5.0% | 3.321 | 3.646 | 23.313 | 1.958 | 15.675 |
| hex: canterbury/plrabn12.txt | 524290 | 11981.0 ± 0.1% | 3618.0 ± 0.1% | 3294.0 ± 0.3% | 504.3 ± 0.3% | 6097.0 ± 2.1% | 767.5 ± 1.2% | 3.311 | 3.637 | 23.757 | 1.965 | 15.610 |
| hex: canterbury/ptt5 | 524290 | 11980.7 ± 0.3% | 3617.5 ± 0.1% | 3291.0 ± 0.5% | 559.5 ± 1.3% | 6100.1 ± 0.5% | 769.5 ± 0.7% | 3.312 | 3.640 | 21.415 | 1.964 | 15.569 |
| hex: canterbury/sum | 76482 | 11909.9 ± 0.2% | 3631.4 ± 0.1% | 3354.7 ± 0.3% | 512.4 ± 2.2% | 6166.0 ± 0.7% | 768.0 ± 1.3% | 3.280 | 3.550 | 23.244 | 1.932 | 15.507 |
| hex: canterbury/xargs.1 | 8456 | 11334.9 ± 0.1% | 3601.8 ± 0.1% | 3344.8 ± 0.3% | 505.5 ± 1.5% | 6140.3 ± 0.4% | 746.0 ± 0.6% | 3.147 | 3.389 | 22.424 | 1.846 | 15.195 |
| hex: canterbury-large/E.coli | 524290 | 11968.3 ± 0.3% | 3613.3 ± 0.3% | 3293.2 ± 0.4% | 689.4 ± 0.3% | 6078.1 ± 0.9% | 782.4 ± 7.9% | 3.312 | 3.634 | 17.361 | 1.969 | 15.297 |
| hex: canterbury-large/bible.txt | 524290 | 11975.2 ± 0.2% | 3614.2 ± 0.3% | 3306.8 ± 0.4% | 520.6 ± 1.7% | 6073.3 ± 1.5% | 779.4 ± 2.4% | 3.313 | 3.621 | 23.001 | 1.972 | 15.365 |
| hex: canterbury-large/world192.txt | 524290 | 11990.9 ± 0.1% | 3614.4 ± 0.2% | 3300.1 ± 0.4% | 499.1 ± 2.3% | 6093.6 ± 0.7% | 780.3 ± 2.1% | 3.318 | 3.633 | 24.027 | 1.968 | 15.366 |
| hex: http/html-1kx1024 | 2099200 | 8850.8 ± 4.1% | 3461.8 ± 0.1% | 2855.3 ± 0.4% | 475.6 ± 1.0% | 5139.7 ± 1.1% | 636.3 ± 2.5% | 2.557 | 3.100 | 18.608 | 1.722 | 13.909 |
| hex: http/html-16kx64 | 2097280 | 11750.5 ± 0.3% | 3607.8 ± 0.1% | 3249.9 ± 0.3% | 479.2 ± 1.3% | 6009.1 ± 0.2% | 741.8 ± 1.6% | 3.257 | 3.616 | 24.523 | 1.955 | 15.842 |
| hex: http/html-1m | 524290 | 11993.4 ± 0.0% | 3618.5 ± 0.2% | 3289.3 ± 0.2% | 501.4 ± 3.2% | 6110.6 ± 1.2% | 772.4 ± 1.8% | 3.314 | 3.646 | 23.920 | 1.963 | 15.527 |
| hex: http/json-1kx1024 | 2099200 | 8805.8 ± 4.1% | 3460.9 ± 0.3% | 2849.1 ± 0.2% | 576.2 ± 0.2% | 5124.0 ± 0.7% | 623.0 ± 2.2% | 2.544 | 3.091 | 15.283 | 1.719 | 14.136 |
| hex: http/json-16kx64 | 2097280 | 11764.7 ± 0.2% | 3606.9 ± 0.0% | 3251.8 ± 0.2% | 572.0 ± 1.1% | 6024.3 ± 2.1% | 738.4 ± 9.1% | 3.262 | 3.618 | 20.566 | 1.953 | 15.933 |
| hex: http/json-1m | 524290 | 12006.3 ± 0.1% | 3614.9 ± 0.2% | 3299.2 ± 0.4% | 597.1 ± 3.0% | 6098.3 ± 0.8% | 767.2 ± 2.0% | 3.321 | 3.639 | 20.109 | 1.969 | 15.650 |
| hex: http/js-1kx1024 | 2099200 | 8814.5 ± 5.4% | 3463.6 ± 0.2% | 2851.5 ± 0.3% | 480.7 ± 0.7% | 5127.8 ± 1.8% | 633.5 ± 5.4% | 2.545 | 3.091 | 18.338 | 1.719 | 13.913 |
| hex: http/js-16kx64 | 2097280 | 11771.2 ± 0.2% | 3611.5 ± 0.3% | 3247.6 ± 0.2% | 481.1 ± 2.4% | 6022.1 ± 0.2% | 739.2 ± 2.7% | 3.259 | 3.625 | 24.466 | 1.955 | 15.925 |
| hex: http/js-1m | 524290 | 12001.9 ± 0.3% | 3615.0 ± 0.1% | 3291.4 ± 0.3% | 509.0 ± 4.0% | 6101.0 ± 1.7% | 772.2 ± 4.4% | 3.320 | 3.646 | 23.581 | 1.967 | 15.543 |
| hex: http/css-1kx1024 | 2099200 | 8835.6 ± 4.0% | 3462.2 ± 0.2% | 2847.7 ± 0.4% | 489.0 ± 0.2% | 5143.5 ± 1.1% | 621.3 ± 0.7% | 2.552 | 3.103 | 18.070 | 1.718 | 14.221 |
| hex: http/css-16kx64 | 2097280 | 11759.1 ± 0.2% | 3607.1 ± 0.2% | 3257.9 ± 0.2% | 494.8 ± 0.8% | 6026.5 ± 0.5% | 736.4 ± 2.0% | 3.260 | 3.609 | 23.766 | 1.951 | 15.969 |
| hex: http/css-1m | 524290 | 11996.0 ± 0.3% | 3612.5 ± 0.3% | 3299.3 ± 0.7% | 503.4 ± 2.7% | 6080.6 ± 1.4% | 768.4 ± 4.3% | 3.321 | 3.636 | 23.831 | 1.973 | 15.611 |
| hex: shuffled/dickens-1m | 524290 | 11990.1 ± 0.5% | 3617.0 ± 0.1% | 3304.9 ± 0.2% | 525.7 ± 0.2% | 6074.5 ± 0.8% | 760.2 ± 1.5% | 3.315 | 3.628 | 22.807 | 1.974 | 15.772 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1012.4 ± 0.2% | 930.8 ± 0.7% | 1021.8 ± 0.2% | 300.5 ± 1.4% | 664.0 ± 0.4% | 308.4 ± 2.2% | 1.088 | 0.991 | 3.369 | 1.525 | 3.283 |
| qlog records, JSON text sequence | 1467503 | 838.2 ± 0.3% | 817.4 ± 0.2% | 769.2 ± 0.6% | 242.8 ± 0.5% | 686.3 ± 1.4% | 235.2 ± 2.5% | 1.025 | 1.090 | 3.452 | 1.221 | 3.564 |
| string: silesia/dickens | 172528 | 5051.1 ± 0.2% | 1877.1 ± 0.1% | 2648.2 ± 0.3% | 362.6 ± 1.0% | 2862.5 ± 0.8% | 549.5 ± 2.1% | 2.691 | 1.907 | 13.931 | 1.765 | 9.192 |
| string: silesia/nci | 1075110 | 4301.4 ± 0.4% | 2240.1 ± 0.7% | 2997.6 ± 0.5% | 544.5 ± 0.7% | 3017.0 ± 0.5% | 590.8 ± 2.0% | 1.920 | 1.435 | 7.900 | 1.426 | 7.280 |
| string: silesia/reymont | 1075159 | 2982.1 ± 0.7% | 1820.5 ± 2.1% | 2063.8 ± 0.5% | 374.5 ± 0.9% | 2139.0 ± 0.6% | 526.9 ± 0.5% | 1.638 | 1.445 | 7.962 | 1.394 | 5.660 |
| string: silesia/samba | 97582 | 3516.5 ± 0.4% | 2024.2 ± 0.2% | 2617.2 ± 0.3% | 329.8 ± 0.1% | 1498.1 ± 0.8% | 426.0 ± 0.8% | 1.737 | 1.344 | 10.663 | 2.347 | 8.254 |
| string: silesia/webster | 1098490 | 3674.0 ± 0.8% | 1516.5 ± 0.3% | 2014.2 ± 0.4% | 359.6 ± 0.3% | 2177.2 ± 0.4% | 491.6 ± 1.2% | 2.423 | 1.824 | 10.217 | 1.687 | 7.473 |
| string: silesia/xml | 1090118 | 4834.7 ± 0.6% | 2357.2 ± 0.5% | 2525.1 ± 0.3% | 456.6 ± 1.3% | 2858.2 ± 1.2% | 555.1 ± 1.3% | 2.051 | 1.915 | 10.588 | 1.692 | 8.709 |
| string: canterbury/alice29.txt | 159425 | 4356.1 ± 0.9% | 1600.3 ± 0.2% | 2458.2 ± 0.6% | 342.6 ± 0.7% | 2502.5 ± 0.6% | 505.0 ± 1.5% | 2.722 | 1.772 | 12.715 | 1.741 | 8.627 |
| string: canterbury/asyoulik.txt | 132198 | 3507.4 ± 0.8% | 1459.9 ± 0.3% | 2252.9 ± 1.1% | 334.8 ± 1.4% | 2079.6 ± 0.9% | 453.2 ± 3.6% | 2.402 | 1.557 | 10.476 | 1.687 | 7.740 |
| string: canterbury/lcet10.txt | 441884 | 5129.3 ± 0.4% | 1851.8 ± 0.2% | 2335.7 ± 0.4% | 390.4 ± 0.2% | 2833.7 ± 0.7% | 534.6 ± 1.9% | 2.770 | 2.196 | 13.139 | 1.810 | 9.594 |
| string: canterbury/plrabn12.txt | 503330 | 4140.0 ± 0.5% | 1733.8 ± 0.1% | 2057.3 ± 0.2% | 361.0 ± 1.4% | 2500.2 ± 1.1% | 498.4 ± 4.0% | 2.388 | 2.012 | 11.467 | 1.656 | 8.306 |
| string: canterbury-large/E.coli | 1048578 | 11931.5 ± 0.4% | 3601.4 ± 0.5% | 3246.8 ± 0.5% | 929.5 ± 1.2% | 6030.0 ± 0.8% | 741.4 ± 1.3% | 3.313 | 3.675 | 12.837 | 1.979 | 16.093 |
| string: canterbury-large/bible.txt | 1055886 | 6903.2 ± 1.6% | 2934.4 ± 0.7% | 2824.1 ± 0.4% | 421.7 ± 0.8% | 3778.4 ± 1.5% | 604.9 ± 1.0% | 2.353 | 2.444 | 16.369 | 1.827 | 11.412 |
| string: canterbury-large/world192.txt | 1103121 | 3393.9 ± 0.5% | 1480.8 ± 0.3% | 2009.0 ± 0.2% | 353.1 ± 0.6% | 2108.8 ± 0.2% | 491.3 ± 0.7% | 2.292 | 1.689 | 9.612 | 1.609 | 6.908 |
| string: http/html-1m | 1058582 | 6234.9 ± 1.2% | 2729.6 ± 0.5% | 2685.7 ± 0.6% | 441.5 ± 0.9% | 3476.9 ± 0.8% | 588.8 ± 1.0% | 2.284 | 2.322 | 14.121 | 1.793 | 10.589 |
| string: http/json-1m | 1190272 | 2561.2 ± 0.5% | 877.5 ± 0.1% | 2247.1 ± 0.3% | 390.6 ± 0.5% | 1060.8 ± 0.5% | 425.8 ± 2.2% | 2.919 | 1.140 | 6.556 | 2.414 | 6.015 |
| string: http/js-1m | 1144362 | 2289.7 ± 0.5% | 1028.6 ± 0.5% | 1635.9 ± 0.5% | 321.3 ± 0.5% | 1521.1 ± 0.3% | 402.7 ± 4.3% | 2.226 | 1.400 | 7.128 | 1.505 | 5.685 |
| string: http/css-1m | 1097820 | 2654.2 ± 0.4% | 1675.7 ± 0.2% | 2221.1 ± 0.8% | 406.1 ± 0.2% | 1950.7 ± 0.7% | 479.6 ± 0.8% | 1.584 | 1.195 | 6.536 | 1.361 | 5.534 |
| string: dickens as Cyrillic and CJK | 1883069 | 3074.4 ± 0.4% | 1682.9 ± 0.4% | 891.8 ± 1.2% | 350.1 ± 0.2% | 665.3 ± 2.8% | 156.7 ± 2.4% | 1.827 | 3.448 | 8.781 | 4.621 | 19.622 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.7 ± 0.3% | 978.4 ± 0.2% | 1198.3 ± 0.3% | 216.0 ± 0.3% | 471.7 ± 0.7% | 250.0 ± 5.2% | 1.360 | 1.111 | 6.161 | 2.821 | 5.322 |
| hex: silesia/dickens | 524290 | 11951.6 ± 0.4% | 3613.0 ± 0.4% | 3297.2 ± 0.3% | 506.1 ± 1.4% | 6065.9 ± 1.2% | 781.6 ± 2.9% | 3.308 | 3.625 | 23.617 | 1.970 | 15.291 |
| hex: silesia/mozilla | 524290 | 11983.1 ± 0.2% | 3611.9 ± 0.5% | 3295.1 ± 0.5% | 453.0 ± 0.6% | 6102.9 ± 1.8% | 780.1 ± 0.3% | 3.318 | 3.637 | 26.452 | 1.964 | 15.361 |
| hex: silesia/mr | 524290 | 11985.4 ± 0.1% | 3611.8 ± 0.3% | 3288.1 ± 0.1% | 570.2 ± 1.8% | 6115.2 ± 0.9% | 779.1 ± 1.1% | 3.318 | 3.645 | 21.019 | 1.960 | 15.383 |
| hex: silesia/nci | 524290 | 12010.1 ± 0.3% | 3612.6 ± 0.6% | 3288.9 ± 0.5% | 621.2 ± 2.0% | 6061.7 ± 1.1% | 780.7 ± 0.4% | 3.325 | 3.652 | 19.332 | 1.981 | 15.384 |
| hex: silesia/ooffice | 524290 | 12003.4 ± 0.1% | 3614.0 ± 0.2% | 3304.3 ± 0.3% | 397.3 ± 1.4% | 6080.8 ± 0.4% | 780.6 ± 0.4% | 3.321 | 3.633 | 30.211 | 1.974 | 15.377 |
| hex: silesia/osdb | 524290 | 11936.2 ± 0.6% | 3609.1 ± 0.2% | 3288.0 ± 0.3% | 481.4 ± 0.3% | 6042.1 ± 0.9% | 781.3 ± 0.4% | 3.307 | 3.630 | 24.793 | 1.976 | 15.278 |
| hex: silesia/reymont | 524290 | 12018.7 ± 0.1% | 3611.5 ± 0.3% | 3291.6 ± 0.3% | 522.3 ± 3.6% | 6096.5 ± 1.5% | 781.8 ± 0.5% | 3.328 | 3.651 | 23.010 | 1.971 | 15.372 |
| hex: silesia/samba | 524290 | 11965.7 ± 0.2% | 3612.4 ± 0.4% | 3287.9 ± 0.2% | 408.6 ± 0.7% | 6020.6 ± 0.5% | 781.4 ± 0.1% | 3.312 | 3.639 | 29.286 | 1.987 | 15.312 |
| hex: silesia/sao | 524290 | 12012.3 ± 0.3% | 3611.2 ± 0.1% | 3292.7 ± 0.1% | 345.5 ± 1.9% | 6084.3 ± 1.8% | 783.1 ± 0.6% | 3.326 | 3.648 | 34.768 | 1.974 | 15.340 |
| hex: silesia/webster | 524290 | 11985.0 ± 0.3% | 3613.0 ± 0.1% | 3288.9 ± 0.2% | 472.7 ± 1.4% | 6081.2 ± 1.9% | 781.4 ± 0.2% | 3.317 | 3.644 | 25.357 | 1.971 | 15.338 |
| hex: silesia/x-ray | 524290 | 11991.5 ± 0.3% | 3611.7 ± 0.2% | 3302.3 ± 0.4% | 485.2 ± 0.3% | 6068.6 ± 1.2% | 782.9 ± 0.6% | 3.320 | 3.631 | 24.714 | 1.976 | 15.318 |
| hex: silesia/xml | 524290 | 11988.3 ± 0.1% | 3613.0 ± 0.2% | 3294.9 ± 0.3% | 533.3 ± 0.4% | 6057.7 ± 0.9% | 782.1 ± 0.6% | 3.318 | 3.639 | 22.480 | 1.979 | 15.329 |
| hex: canterbury/alice29.txt | 304180 | 12004.9 ± 0.1% | 3638.1 ± 0.2% | 3338.0 ± 0.2% | 524.0 ± 0.2% | 6060.5 ± 1.9% | 779.9 ± 1.3% | 3.300 | 3.596 | 22.908 | 1.981 | 15.393 |
| hex: canterbury/asyoulik.txt | 250360 | 11995.1 ± 0.2% | 3638.1 ± 0.1% | 3373.8 ± 0.1% | 516.9 ± 0.2% | 6072.1 ± 1.4% | 779.4 ± 1.1% | 3.297 | 3.555 | 23.205 | 1.975 | 15.389 |
| hex: canterbury/cp.html | 49208 | 11907.2 ± 0.0% | 3637.5 ± 0.4% | 3278.0 ± 0.1% | 472.0 ± 0.9% | 6277.7 ± 2.5% | 761.6 ± 1.8% | 3.273 | 3.633 | 25.225 | 1.897 | 15.635 |
| hex: canterbury/fields.c | 22302 | 11776.2 ± 0.0% | 3628.3 ± 0.2% | 3349.3 ± 0.1% | 511.5 ± 0.5% | 6257.1 ± 0.5% | 751.7 ± 3.2% | 3.246 | 3.516 | 23.022 | 1.882 | 15.667 |
| hex: canterbury/grammar.lsp | 7444 | 11312.5 ± 0.1% | 3600.9 ± 0.0% | 3354.1 ± 0.3% | 540.3 ± 1.9% | 6170.2 ± 0.8% | 714.0 ± 1.7% | 3.142 | 3.373 | 20.939 | 1.833 | 15.844 |
| hex: canterbury/kennedy.xls | 524290 | 12008.4 ± 0.1% | 3620.7 ± 0.3% | 3295.4 ± 0.1% | 663.4 ± 9.9% | 6098.0 ± 1.9% | 764.9 ± 9.8% | 3.317 | 3.644 | 18.102 | 1.969 | 15.700 |
| hex: canterbury/lcet10.txt | 524290 | 11999.1 ± 0.2% | 3616.1 ± 0.3% | 3293.3 ± 0.3% | 515.1 ± 3.7% | 6131.6 ± 1.1% | 766.1 ± 5.0% | 3.318 | 3.643 | 23.295 | 1.957 | 15.663 |
| hex: canterbury/plrabn12.txt | 524290 | 11985.7 ± 0.1% | 3618.0 ± 0.1% | 3294.0 ± 0.3% | 504.3 ± 0.3% | 6097.0 ± 2.1% | 767.5 ± 1.2% | 3.313 | 3.639 | 23.767 | 1.966 | 15.616 |
| hex: canterbury/ptt5 | 524290 | 12001.3 ± 0.1% | 3617.5 ± 0.1% | 3291.0 ± 0.5% | 559.5 ± 1.3% | 6100.1 ± 0.5% | 769.5 ± 0.7% | 3.318 | 3.647 | 21.452 | 1.967 | 15.595 |
| hex: canterbury/sum | 76482 | 11909.3 ± 0.2% | 3631.4 ± 0.1% | 3354.7 ± 0.3% | 512.4 ± 2.2% | 6166.0 ± 0.7% | 768.0 ± 1.3% | 3.280 | 3.550 | 23.243 | 1.931 | 15.506 |
| hex: canterbury/xargs.1 | 8456 | 11335.2 ± 0.0% | 3601.8 ± 0.1% | 3344.8 ± 0.3% | 505.5 ± 1.5% | 6140.3 ± 0.4% | 746.0 ± 0.6% | 3.147 | 3.389 | 22.424 | 1.846 | 15.196 |
| hex: canterbury-large/E.coli | 524290 | 11995.6 ± 0.1% | 3613.3 ± 0.3% | 3293.2 ± 0.4% | 689.4 ± 0.3% | 6078.1 ± 0.9% | 782.4 ± 7.9% | 3.320 | 3.643 | 17.401 | 1.974 | 15.332 |
| hex: canterbury-large/bible.txt | 524290 | 11995.1 ± 0.3% | 3614.2 ± 0.3% | 3306.8 ± 0.4% | 520.6 ± 1.7% | 6073.3 ± 1.5% | 779.4 ± 2.4% | 3.319 | 3.627 | 23.040 | 1.975 | 15.390 |
| hex: canterbury-large/world192.txt | 524290 | 11989.2 ± 0.5% | 3614.4 ± 0.2% | 3300.1 ± 0.4% | 499.1 ± 2.3% | 6093.6 ± 0.7% | 780.3 ± 2.1% | 3.317 | 3.633 | 24.023 | 1.968 | 15.364 |
| hex: http/html-1kx1024 | 2099200 | 8926.9 ± 5.1% | 3461.8 ± 0.1% | 2855.3 ± 0.4% | 475.6 ± 1.0% | 5139.7 ± 1.1% | 636.3 ± 2.5% | 2.579 | 3.126 | 18.768 | 1.737 | 14.029 |
| hex: http/html-16kx64 | 2097280 | 11763.1 ± 0.2% | 3607.8 ± 0.1% | 3249.9 ± 0.3% | 479.2 ± 1.3% | 6009.1 ± 0.2% | 741.8 ± 1.6% | 3.260 | 3.619 | 24.549 | 1.958 | 15.858 |
| hex: http/html-1m | 524290 | 12001.0 ± 0.2% | 3618.5 ± 0.2% | 3289.3 ± 0.2% | 501.4 ± 3.2% | 6110.6 ± 1.2% | 772.4 ± 1.8% | 3.317 | 3.648 | 23.935 | 1.964 | 15.537 |
| hex: http/json-1kx1024 | 2099200 | 8867.3 ± 5.0% | 3460.9 ± 0.3% | 2849.1 ± 0.2% | 576.2 ± 0.2% | 5124.0 ± 0.7% | 623.0 ± 2.2% | 2.562 | 3.112 | 15.390 | 1.731 | 14.234 |
| hex: http/json-16kx64 | 2097280 | 11770.4 ± 0.1% | 3606.9 ± 0.0% | 3251.8 ± 0.2% | 572.0 ± 1.1% | 6024.3 ± 2.1% | 738.4 ± 9.1% | 3.263 | 3.620 | 20.576 | 1.954 | 15.941 |
| hex: http/json-1m | 524290 | 12010.9 ± 0.2% | 3614.9 ± 0.2% | 3299.2 ± 0.4% | 597.1 ± 3.0% | 6098.3 ± 0.8% | 767.2 ± 2.0% | 3.323 | 3.641 | 20.117 | 1.970 | 15.656 |
| hex: http/js-1kx1024 | 2099200 | 8818.9 ± 4.8% | 3463.6 ± 0.2% | 2851.5 ± 0.3% | 480.7 ± 0.7% | 5127.8 ± 1.8% | 633.5 ± 5.4% | 2.546 | 3.093 | 18.347 | 1.720 | 13.920 |
| hex: http/js-16kx64 | 2097280 | 11771.5 ± 0.2% | 3611.5 ± 0.3% | 3247.6 ± 0.2% | 481.1 ± 2.4% | 6022.1 ± 0.2% | 739.2 ± 2.7% | 3.259 | 3.625 | 24.467 | 1.955 | 15.925 |
| hex: http/js-1m | 524290 | 11998.6 ± 0.1% | 3615.0 ± 0.1% | 3291.4 ± 0.3% | 509.0 ± 4.0% | 6101.0 ± 1.7% | 772.2 ± 4.4% | 3.319 | 3.645 | 23.574 | 1.967 | 15.539 |
| hex: http/css-1kx1024 | 2099200 | 8868.5 ± 3.8% | 3462.2 ± 0.2% | 2847.7 ± 0.4% | 489.0 ± 0.2% | 5143.5 ± 1.1% | 621.3 ± 0.7% | 2.562 | 3.114 | 18.137 | 1.724 | 14.274 |
| hex: http/css-16kx64 | 2097280 | 11768.4 ± 0.1% | 3607.1 ± 0.2% | 3257.9 ± 0.2% | 494.8 ± 0.8% | 6026.5 ± 0.5% | 736.4 ± 2.0% | 3.263 | 3.612 | 23.784 | 1.953 | 15.982 |
| hex: http/css-1m | 524290 | 11993.2 ± 0.2% | 3612.5 ± 0.3% | 3299.3 ± 0.7% | 503.4 ± 2.7% | 6080.6 ± 1.4% | 768.4 ± 4.3% | 3.320 | 3.635 | 23.825 | 1.972 | 15.607 |
| hex: shuffled/dickens-1m | 524290 | 11977.9 ± 0.1% | 3617.0 ± 0.1% | 3304.9 ± 0.2% | 525.7 ± 0.2% | 6074.5 ± 0.8% | 760.2 ± 1.5% | 3.312 | 3.624 | 22.784 | 1.972 | 15.756 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1351.5 ± 0.2% | 1247.9 ± 0.5% | 1036.3 ± 0.3% | 409.4 ± 0.3% | 447.7 ± 0.1% | 414.1 ± 0.2% | 1.083 | 1.304 | 3.301 | 3.018 | 3.264 |
| qlog records, JSON text sequence | 1467503 | 1045.9 ± 0.8% | 1057.4 ± 0.4% | 782.0 ± 0.8% | 380.2 ± 1.0% | 472.7 ± 1.0% | 278.0 ± 0.8% | 0.989 | 1.337 | 2.751 | 2.213 | 3.762 |
| string: silesia/dickens | 172528 | 6911.3 ± 0.3% | 2818.5 ± 0.4% | 2922.5 ± 0.3% | 428.0 ± 0.4% | 1564.1 ± 0.3% | 1009.8 ± 0.2% | 2.452 | 2.365 | 16.150 | 4.419 | 6.844 |
| string: silesia/nci | 1075110 | 7300.7 ± 0.6% | 3437.9 ± 0.5% | 3095.4 ± 0.3% | 817.0 ± 1.3% | 1854.4 ± 0.2% | 1105.9 ± 0.8% | 2.124 | 2.359 | 8.936 | 3.937 | 6.602 |
| string: silesia/reymont | 1075159 | 3363.1 ± 0.8% | 1984.4 ± 1.6% | 2061.7 ± 0.3% | 451.4 ± 0.7% | 1510.3 ± 0.2% | 946.8 ± 0.7% | 1.695 | 1.631 | 7.450 | 2.227 | 3.552 |
| string: silesia/samba | 97582 | 4211.9 ± 0.4% | 2120.1 ± 0.7% | 3448.4 ± 0.6% | 353.7 ± 0.7% | 1432.9 ± 0.4% | 1050.3 ± 0.1% | 1.987 | 1.221 | 11.910 | 2.939 | 4.010 |
| string: silesia/webster | 1098490 | 4077.8 ± 0.4% | 1881.6 ± 0.4% | 2050.9 ± 0.2% | 442.0 ± 0.4% | 1387.9 ± 0.3% | 646.5 ± 0.4% | 2.167 | 1.988 | 9.226 | 2.938 | 6.307 |
| string: silesia/xml | 1090118 | 6132.0 ± 0.7% | 2871.8 ± 0.3% | 2641.2 ± 0.4% | 610.0 ± 0.6% | 1752.1 ± 0.3% | 920.6 ± 0.3% | 2.135 | 2.322 | 10.052 | 3.500 | 6.661 |
| string: canterbury/alice29.txt | 159425 | 6459.0 ± 0.9% | 2205.4 ± 0.5% | 2761.3 ± 0.3% | 406.9 ± 0.6% | 1464.4 ± 0.4% | 953.5 ± 0.3% | 2.929 | 2.339 | 15.875 | 4.411 | 6.774 |
| string: canterbury/asyoulik.txt | 132198 | 5662.8 ± 1.5% | 1711.4 ± 0.3% | 2379.5 ± 0.6% | 402.5 ± 0.3% | 1332.2 ± 0.7% | 884.8 ± 0.3% | 3.309 | 2.380 | 14.067 | 4.251 | 6.400 |
| string: canterbury/lcet10.txt | 441884 | 6262.3 ± 0.7% | 2574.2 ± 0.4% | 2492.4 ± 1.5% | 466.5 ± 0.8% | 1524.8 ± 0.1% | 988.5 ± 0.5% | 2.433 | 2.513 | 13.424 | 4.107 | 6.335 |
| string: canterbury/plrabn12.txt | 503330 | 5725.4 ± 0.6% | 2054.3 ± 0.2% | 2068.9 ± 0.5% | 422.5 ± 0.5% | 1408.1 ± 0.4% | 932.8 ± 0.5% | 2.787 | 2.767 | 13.552 | 4.066 | 6.138 |
| string: canterbury-large/E.coli | 1048578 | 19362.4 ± 0.7% | 9825.7 ± 0.6% | 3779.7 ± 0.8% | 1475.8 ± 0.3% | 2360.9 ± 0.3% | 1188.4 ± 0.5% | 1.971 | 5.123 | 13.120 | 8.201 | 16.293 |
| string: canterbury-large/bible.txt | 1055886 | 6799.7 ± 2.1% | 4147.6 ± 2.6% | 3056.7 ± 2.2% | 501.1 ± 1.6% | 1979.6 ± 0.4% | 1120.0 ± 1.8% | 1.639 | 2.225 | 13.568 | 3.435 | 6.071 |
| string: canterbury-large/world192.txt | 1103121 | 4062.4 ± 0.5% | 1657.3 ± 0.3% | 2001.5 ± 0.4% | 448.9 ± 0.3% | 1356.3 ± 0.3% | 907.1 ± 0.3% | 2.451 | 2.030 | 9.050 | 2.995 | 4.478 |
| string: http/html-1m | 1058582 | 6771.9 ± 0.5% | 3990.5 ± 0.3% | 3031.4 ± 0.4% | 500.1 ± 0.9% | 1925.6 ± 0.3% | 804.2 ± 0.7% | 1.697 | 2.234 | 13.542 | 3.517 | 8.420 |
| string: http/json-1m | 1190272 | 3161.8 ± 0.2% | 1350.2 ± 0.4% | 1556.5 ± 0.1% | 443.4 ± 0.8% | 962.0 ± 0.2% | 765.0 ± 0.3% | 2.342 | 2.031 | 7.131 | 3.287 | 4.133 |
| string: http/js-1m | 1144362 | 2765.9 ± 0.7% | 1180.0 ± 0.5% | 1622.9 ± 0.8% | 368.5 ± 0.3% | 1092.9 ± 0.3% | 757.2 ± 0.3% | 2.344 | 1.704 | 7.505 | 2.531 | 3.653 |
| string: http/css-1m | 1097820 | 4005.1 ± 1.1% | 1484.8 ± 0.4% | 2148.7 ± 0.6% | 495.0 ± 1.0% | 1367.7 ± 0.3% | 892.3 ± 0.5% | 2.697 | 1.864 | 8.091 | 2.928 | 4.488 |
| string: dickens as Cyrillic and CJK | 1883069 | 3071.0 ± 0.5% | 2337.8 ± 0.4% | 521.0 ± 0.3% | 306.0 ± 0.5% | 564.3 ± 0.7% | 335.6 ± 0.2% | 1.314 | 5.895 | 10.036 | 5.442 | 9.150 |
| hex: silesia/dickens | 524290 | 15615.5 ± 0.4% | 1465.7 ± 0.3% | 1081.9 ± 0.2% | 495.5 ± 1.0% | 989.0 ± 0.5% | 734.8 ± 0.4% | 10.654 | 14.433 | 31.518 | 15.789 | 21.251 |
| hex: silesia/mozilla | 524290 | 15633.9 ± 0.6% | 1474.3 ± 0.2% | 1088.0 ± 0.5% | 443.0 ± 0.4% | 991.8 ± 0.4% | 734.2 ± 0.4% | 10.604 | 14.370 | 35.292 | 15.763 | 21.294 |
| hex: silesia/mr | 524290 | 15673.8 ± 0.1% | 1484.7 ± 0.3% | 1093.7 ± 0.5% | 557.8 ± 3.7% | 993.4 ± 0.4% | 735.3 ± 0.4% | 10.557 | 14.332 | 28.100 | 15.777 | 21.317 |
| hex: silesia/nci | 524290 | 15645.2 ± 0.3% | 1473.7 ± 0.2% | 1090.5 ± 0.4% | 641.4 ± 2.1% | 988.2 ± 0.2% | 735.5 ± 0.3% | 10.616 | 14.347 | 24.394 | 15.831 | 21.273 |
| hex: silesia/ooffice | 524290 | 15621.1 ± 0.3% | 1466.3 ± 0.4% | 1085.0 ± 0.6% | 389.1 ± 0.4% | 990.2 ± 0.2% | 734.2 ± 0.5% | 10.654 | 14.398 | 40.148 | 15.775 | 21.277 |
| hex: silesia/osdb | 524290 | 15644.3 ± 0.2% | 1471.3 ± 0.3% | 1086.1 ± 0.2% | 466.7 ± 1.7% | 990.9 ± 0.4% | 734.7 ± 0.5% | 10.633 | 14.404 | 33.518 | 15.788 | 21.294 |
| hex: silesia/reymont | 524290 | 15664.5 ± 0.2% | 1465.5 ± 0.4% | 1086.6 ± 0.4% | 518.6 ± 1.7% | 987.9 ± 0.4% | 735.0 ± 0.6% | 10.689 | 14.417 | 30.204 | 15.856 | 21.312 |
| hex: silesia/samba | 524290 | 15678.3 ± 0.3% | 1467.8 ± 0.3% | 1085.0 ± 0.4% | 402.7 ± 0.5% | 988.6 ± 0.3% | 735.8 ± 1.2% | 10.681 | 14.450 | 38.934 | 15.859 | 21.309 |
| hex: silesia/sao | 524290 | 15661.6 ± 0.2% | 1465.6 ± 0.4% | 1083.8 ± 0.3% | 332.3 ± 0.4% | 988.7 ± 0.3% | 735.7 ± 0.5% | 10.686 | 14.451 | 47.132 | 15.841 | 21.288 |
| hex: silesia/webster | 524290 | 15652.9 ± 0.3% | 1466.1 ± 0.3% | 1085.5 ± 0.5% | 474.1 ± 0.5% | 989.2 ± 0.3% | 734.2 ± 0.4% | 10.677 | 14.420 | 33.014 | 15.824 | 21.319 |
| hex: silesia/x-ray | 524290 | 15641.9 ± 0.1% | 1475.5 ± 0.4% | 1087.8 ± 0.3% | 446.5 ± 0.8% | 994.5 ± 0.2% | 734.3 ± 0.3% | 10.601 | 14.379 | 35.033 | 15.729 | 21.302 |
| hex: silesia/xml | 524290 | 15618.6 ± 0.2% | 1467.9 ± 0.3% | 1085.4 ± 0.8% | 618.2 ± 1.1% | 987.3 ± 0.4% | 734.8 ± 0.2% | 10.640 | 14.390 | 25.263 | 15.820 | 21.255 |
| hex: canterbury/alice29.txt | 304180 | 15684.8 ± 0.0% | 1475.5 ± 0.7% | 1088.3 ± 0.2% | 500.1 ± 2.5% | 992.4 ± 0.4% | 734.0 ± 0.3% | 10.630 | 14.413 | 31.360 | 15.805 | 21.370 |
| hex: canterbury/asyoulik.txt | 250360 | 15713.1 ± 0.0% | 1475.7 ± 0.3% | 1088.5 ± 0.2% | 489.3 ± 1.2% | 993.2 ± 0.1% | 740.5 ± 0.3% | 10.648 | 14.436 | 32.110 | 15.821 | 21.220 |
| hex: canterbury/cp.html | 49208 | 15662.9 ± 0.3% | 1470.2 ± 0.2% | 1096.7 ± 0.2% | 522.6 ± 1.6% | 1000.5 ± 0.2% | 743.2 ± 0.2% | 10.654 | 14.282 | 29.969 | 15.656 | 21.075 |
| hex: canterbury/fields.c | 22302 | 15519.8 ± 0.3% | 1417.0 ± 0.6% | 1061.1 ± 0.4% | 608.7 ± 7.2% | 987.0 ± 0.1% | 735.9 ± 0.2% | 10.953 | 14.627 | 25.495 | 15.724 | 21.090 |
| hex: canterbury/grammar.lsp | 7444 | 15151.9 ± 0.1% | 1508.7 ± 0.1% | 1091.3 ± 0.6% | 671.5 ± 6.0% | 996.0 ± 0.3% | 725.3 ± 0.1% | 10.043 | 13.884 | 22.566 | 15.212 | 20.890 |
| hex: canterbury/kennedy.xls | 524290 | 15654.1 ± 0.3% | 1476.6 ± 0.5% | 1088.2 ± 0.3% | 652.0 ± 2.7% | 988.9 ± 0.3% | 734.6 ± 0.4% | 10.601 | 14.385 | 24.009 | 15.830 | 21.310 |
| hex: canterbury/lcet10.txt | 524290 | 15604.1 ± 0.7% | 1468.4 ± 0.6% | 1081.9 ± 0.4% | 503.4 ± 0.4% | 991.1 ± 0.4% | 733.9 ± 0.5% | 10.626 | 14.423 | 30.998 | 15.745 | 21.261 |
| hex: canterbury/plrabn12.txt | 524290 | 15671.9 ± 0.2% | 1468.5 ± 0.3% | 1081.0 ± 0.4% | 490.7 ± 4.0% | 986.6 ± 0.3% | 733.5 ± 0.3% | 10.672 | 14.498 | 31.937 | 15.884 | 21.367 |
| hex: canterbury/ptt5 | 524290 | 15611.2 ± 0.5% | 1482.1 ± 0.5% | 1088.8 ± 0.5% | 555.8 ± 0.5% | 993.0 ± 0.3% | 735.0 ± 0.4% | 10.533 | 14.338 | 28.086 | 15.721 | 21.239 |
| hex: canterbury/sum | 76482 | 15676.3 ± 0.1% | 1494.4 ± 1.9% | 1103.0 ± 0.1% | 595.8 ± 0.9% | 997.9 ± 0.1% | 743.8 ± 0.1% | 10.490 | 14.212 | 26.313 | 15.710 | 21.077 |
| hex: canterbury/xargs.1 | 8456 | 15196.0 ± 0.1% | 1493.5 ± 0.7% | 1095.7 ± 0.8% | 667.0 ± 4.2% | 1002.8 ± 0.2% | 728.3 ± 0.9% | 10.175 | 13.869 | 22.782 | 15.154 | 20.865 |
| hex: canterbury-large/E.coli | 524290 | 15674.1 ± 0.1% | 1475.8 ± 0.3% | 1085.1 ± 0.4% | 671.7 ± 0.4% | 990.5 ± 0.4% | 735.0 ± 0.4% | 10.621 | 14.445 | 23.334 | 15.825 | 21.327 |
| hex: canterbury-large/bible.txt | 524290 | 15665.3 ± 0.2% | 1468.8 ± 0.2% | 1083.2 ± 0.6% | 514.5 ± 0.9% | 987.9 ± 0.2% | 735.2 ± 0.6% | 10.666 | 14.462 | 30.446 | 15.857 | 21.308 |
| hex: canterbury-large/world192.txt | 524290 | 15638.0 ± 0.2% | 1467.0 ± 0.3% | 1079.3 ± 0.3% | 501.6 ± 0.5% | 986.7 ± 0.9% | 734.2 ± 0.3% | 10.660 | 14.489 | 31.176 | 15.849 | 21.301 |
| hex: http/html-1kx1024 | 2099200 | 14214.1 ± 0.6% | 1453.8 ± 0.3% | 1062.0 ± 0.3% | 502.3 ± 0.3% | 983.3 ± 0.5% | 691.7 ± 0.1% | 9.777 | 13.384 | 28.296 | 14.456 | 20.550 |
| hex: http/html-16kx64 | 2097280 | 15288.9 ± 0.7% | 1445.9 ± 0.3% | 1074.3 ± 0.4% | 509.0 ± 0.3% | 995.5 ± 0.2% | 734.1 ± 0.3% | 10.574 | 14.232 | 30.039 | 15.357 | 20.825 |
| hex: http/html-1m | 524290 | 15666.4 ± 0.3% | 1467.7 ± 0.4% | 1081.4 ± 0.3% | 499.4 ± 0.6% | 983.1 ± 0.9% | 731.5 ± 0.5% | 10.674 | 14.487 | 31.369 | 15.935 | 21.417 |
| hex: http/json-1kx1024 | 2099200 | 14146.0 ± 0.6% | 1463.4 ± 0.1% | 1066.5 ± 0.3% | 609.0 ± 0.8% | 985.9 ± 0.2% | 691.6 ± 0.4% | 9.667 | 13.264 | 23.226 | 14.348 | 20.454 |
| hex: http/json-16kx64 | 2097280 | 15287.6 ± 0.4% | 1447.9 ± 0.5% | 1074.6 ± 0.4% | 617.5 ± 0.8% | 993.7 ± 0.5% | 734.8 ± 0.6% | 10.559 | 14.227 | 24.759 | 15.385 | 20.806 |
| hex: http/json-1m | 524290 | 15675.6 ± 0.3% | 1475.7 ± 0.5% | 1090.4 ± 0.2% | 634.6 ± 1.4% | 991.7 ± 0.4% | 734.7 ± 0.6% | 10.622 | 14.376 | 24.702 | 15.807 | 21.337 |
| hex: http/js-1kx1024 | 2099200 | 14177.0 ± 0.6% | 1455.0 ± 0.1% | 1062.8 ± 0.3% | 498.9 ± 0.3% | 983.8 ± 0.2% | 692.1 ± 0.2% | 9.744 | 13.340 | 28.416 | 14.411 | 20.483 |
| hex: http/js-16kx64 | 2097280 | 15347.6 ± 0.4% | 1444.2 ± 0.3% | 1073.4 ± 0.5% | 503.8 ± 0.9% | 994.1 ± 0.4% | 734.7 ± 0.1% | 10.627 | 14.298 | 30.463 | 15.438 | 20.891 |
| hex: http/js-1m | 524290 | 15678.0 ± 0.1% | 1466.3 ± 0.3% | 1081.6 ± 0.7% | 509.3 ± 0.6% | 983.9 ± 0.4% | 734.2 ± 0.4% | 10.692 | 14.495 | 30.781 | 15.935 | 21.354 |
| hex: http/css-1kx1024 | 2099200 | 14195.8 ± 0.5% | 1454.5 ± 0.2% | 1062.0 ± 0.1% | 531.4 ± 0.3% | 983.5 ± 0.0% | 692.1 ± 0.2% | 9.760 | 13.367 | 26.712 | 14.433 | 20.512 |
| hex: http/css-16kx64 | 2097280 | 15339.3 ± 0.7% | 1442.2 ± 0.2% | 1074.5 ± 0.2% | 541.6 ± 1.0% | 998.9 ± 0.3% | 734.9 ± 0.4% | 10.636 | 14.275 | 28.323 | 15.356 | 20.874 |
| hex: http/css-1m | 524290 | 15657.4 ± 0.5% | 1467.0 ± 0.2% | 1084.0 ± 0.8% | 528.5 ± 0.3% | 988.9 ± 0.3% | 733.8 ± 0.3% | 10.673 | 14.444 | 29.624 | 15.832 | 21.338 |
| hex: shuffled/dickens-1m | 524290 | 15675.1 ± 0.3% | 1466.4 ± 0.3% | 1083.4 ± 0.4% | 503.2 ± 0.6% | 988.4 ± 0.4% | 734.3 ± 0.2% | 10.689 | 14.468 | 31.150 | 15.859 | 21.346 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.917 of yyjson.
