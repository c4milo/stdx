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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43616673315 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1128.8 ± 0.4% | 0.523 | 0.965 | 0.995 | 0.998 | 0.457 | 1.002 | 1.007 | 0.382 | 0.830 | 0.896 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 840.6 ± 0.5% | 0.826 | 1.014 | 1.010 | 1.014 | 0.451 | 1.001 | 1.036 | 0.399 | 0.933 | 1.001 | 0.127 |
| string: silesia/dickens | 172528 | 5034.3 ± 0.6% | 0.033 | 0.784 | 1.005 | 1.005 | 0.197 | 1.021 | 1.007 | 0.196 | 1.003 | 1.003 | 0.032 |
| string: silesia/nci | 1075110 | 4301.0 ± 0.8% | 0.039 | 0.802 | 1.002 | 1.002 | 0.277 | 1.004 | 0.995 | 0.279 | 1.002 | 1.002 | 0.038 |
| string: silesia/reymont | 1075159 | 2937.2 ± 2.3% | 0.057 | 0.814 | 0.993 | 1.004 | 0.358 | 0.999 | 1.005 | 0.359 | 1.013 | 1.021 | 0.056 |
| string: silesia/samba | 97582 | 3497.1 ± 0.4% | 0.041 | 0.863 | 1.003 | 1.005 | 0.070 | 0.778 | 1.009 | 0.067 | 1.001 | 1.005 | 0.040 |
| string: silesia/webster | 1098490 | 3643.8 ± 0.7% | 0.044 | 0.848 | 1.002 | 1.003 | 0.203 | 1.019 | 1.012 | 0.203 | 1.008 | 1.006 | 0.044 |
| string: silesia/xml | 1090118 | 4778.8 ± 0.3% | 0.035 | 0.806 | 1.005 | 1.009 | 0.221 | 0.983 | 1.009 | 0.219 | 1.005 | 1.005 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4312.9 ± 0.5% | 0.038 | 0.750 | 1.004 | 1.007 | 0.171 | 1.022 | 1.018 | 0.171 | 1.017 | 1.017 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3452.1 ± 0.4% | 0.046 | 0.749 | 1.006 | 1.010 | 0.176 | 1.005 | 0.975 | 0.176 | 1.013 | 1.013 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5129.6 ± 0.2% | 0.032 | 0.810 | 1.000 | 1.001 | 0.195 | 1.019 | 1.004 | 0.194 | 1.000 | 1.003 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4131.0 ± 0.8% | 0.040 | 0.824 | 1.003 | 1.003 | 0.197 | 1.004 | 0.995 | 0.197 | 1.002 | 1.003 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19250.7 ± 0.4% | 0.077 | 1.006 | 1.001 | 1.000 | 0.479 | 1.003 | 1.002 | 0.480 | 0.617 | 0.619 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6658.9 ± 1.0% | 0.026 | 0.805 | 1.008 | 1.011 | 0.433 | 1.032 | 1.042 | 0.434 | 1.037 | 1.042 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3382.0 ± 0.4% | 0.048 | 0.847 | 1.002 | 1.004 | 0.198 | 1.018 | 1.008 | 0.197 | 1.003 | 1.004 | 0.047 |
| string: http/html-1m | 1058582 | 6046.2 ± 1.4% | 0.028 | 0.784 | 1.004 | 1.005 | 0.389 | 1.044 | 1.057 | 0.389 | 1.033 | 1.036 | 0.028 |
| string: http/json-1m | 1190272 | 2546.7 ± 0.1% | 0.055 | 0.950 | 1.004 | 1.006 | 0.110 | 1.003 | 0.471 | 0.110 | 1.003 | 1.005 | 0.054 |
| string: http/js-1m | 1144362 | 2283.9 ± 0.6% | 0.066 | 0.889 | 1.000 | 0.999 | 0.174 | 1.054 | 1.044 | 0.174 | 0.999 | 1.002 | 0.066 |
| string: http/css-1m | 1097820 | 2636.5 ± 0.7% | 0.061 | 0.777 | 1.002 | 1.006 | 0.238 | 1.009 | 1.015 | 0.240 | 1.006 | 1.008 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3060.7 ± 0.6% | 0.044 | 0.125 | 1.006 | 1.005 | 0.336 | 1.004 | 1.012 | 0.336 | 1.004 | 1.005 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1325.9 ± 1.4% | 0.086 | 1.004 | 1.002 | 1.003 | 0.078 | 0.638 | 1.003 | 0.075 | 1.004 | 1.004 | 0.084 |
| hex: silesia/dickens | 524290 | 18778.0 ± 0.3% | 0.079 | 1.008 | 0.989 | 0.981 | 0.510 | 1.001 | 0.998 | 0.511 | 0.635 | 0.638 | 0.009 |
| hex: silesia/mozilla | 524290 | 18839.9 ± 1.6% | 0.079 | 1.008 | 0.993 | 0.989 | 0.501 | 0.994 | 0.992 | 0.501 | 0.633 | 0.633 | 0.009 |
| hex: silesia/mr | 524290 | 18153.5 ± 0.8% | 0.082 | 1.009 | 1.004 | 0.998 | 0.524 | 1.004 | 1.003 | 0.524 | 0.659 | 0.659 | 0.010 |
| hex: silesia/nci | 524290 | 18919.4 ± 1.3% | 0.078 | 0.998 | 0.989 | 0.988 | 0.497 | 1.000 | 0.991 | 0.498 | 0.633 | 0.633 | 0.009 |
| hex: silesia/ooffice | 524290 | 18748.1 ± 1.9% | 0.080 | 1.002 | 1.005 | 0.997 | 0.518 | 1.003 | 1.006 | 0.521 | 0.641 | 0.641 | 0.009 |
| hex: silesia/osdb | 524290 | 18391.6 ± 0.9% | 0.081 | 1.006 | 1.001 | 0.999 | 0.513 | 1.002 | 1.002 | 0.516 | 0.653 | 0.653 | 0.009 |
| hex: silesia/reymont | 524290 | 18409.7 ± 1.0% | 0.081 | 1.003 | 0.998 | 1.000 | 0.530 | 1.003 | 0.995 | 0.532 | 0.653 | 0.653 | 0.009 |
| hex: silesia/samba | 524290 | 18303.3 ± 0.4% | 0.081 | 1.003 | 1.000 | 1.000 | 0.531 | 1.003 | 1.002 | 0.531 | 0.656 | 0.654 | 0.009 |
| hex: silesia/sao | 524290 | 18793.5 ± 0.9% | 0.079 | 1.001 | 0.990 | 0.985 | 0.510 | 0.993 | 0.991 | 0.512 | 0.639 | 0.639 | 0.009 |
| hex: silesia/webster | 524290 | 18834.2 ± 1.5% | 0.079 | 1.000 | 1.001 | 0.990 | 0.511 | 0.995 | 0.992 | 0.511 | 0.636 | 0.637 | 0.009 |
| hex: silesia/x-ray | 524290 | 18349.7 ± 0.5% | 0.081 | 1.005 | 0.994 | 0.995 | 0.530 | 1.003 | 1.006 | 0.530 | 0.654 | 0.654 | 0.009 |
| hex: silesia/xml | 524290 | 18703.3 ± 1.0% | 0.079 | 1.008 | 0.998 | 0.999 | 0.508 | 0.998 | 0.996 | 0.510 | 0.642 | 0.642 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19437.9 ± 0.3% | 0.077 | 1.003 | 1.002 | 1.003 | 0.516 | 1.001 | 1.002 | 0.516 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19431.3 ± 0.3% | 0.077 | 1.003 | 1.003 | 1.004 | 0.515 | 1.002 | 1.002 | 0.514 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19294.2 ± 0.1% | 0.082 | 1.002 | 1.001 | 1.000 | 0.541 | 1.002 | 1.002 | 0.542 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18913.8 ± 0.6% | 0.084 | 1.003 | 1.004 | 1.004 | 0.534 | 1.003 | 1.003 | 0.539 | 0.623 | 0.623 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17506.1 ± 1.8% | 0.089 | 1.007 | 1.007 | 1.008 | 0.526 | 1.006 | 1.007 | 0.545 | 0.644 | 0.647 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18657.9 ± 5.0% | 0.080 | 1.013 | 1.007 | 1.002 | 0.512 | 1.003 | 0.998 | 0.515 | 0.643 | 0.643 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18798.5 ± 1.0% | 0.079 | 0.997 | 1.002 | 1.000 | 0.509 | 0.992 | 0.995 | 0.511 | 0.639 | 0.639 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18405.9 ± 1.0% | 0.081 | 1.004 | 1.000 | 1.000 | 0.519 | 0.997 | 0.995 | 0.519 | 0.652 | 0.652 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 18254.5 ± 0.8% | 0.082 | 1.008 | 1.004 | 1.003 | 0.527 | 0.999 | 1.007 | 0.528 | 0.657 | 0.657 | 0.009 |
| hex: canterbury/sum | 76482 | 19283.0 ± 0.2% | 0.078 | 1.002 | 1.003 | 1.002 | 0.519 | 1.002 | 1.002 | 0.520 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17826.5 ± 0.7% | 0.088 | 1.002 | 1.003 | 1.003 | 0.525 | 1.001 | 1.002 | 0.541 | 0.637 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18631.0 ± 1.4% | 0.080 | 1.013 | 1.012 | 1.000 | 0.512 | 0.998 | 0.998 | 0.513 | 0.644 | 0.644 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18675.9 ± 0.7% | 0.080 | 1.007 | 0.993 | 0.987 | 0.532 | 0.991 | 0.992 | 0.530 | 0.643 | 0.643 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18115.1 ± 1.1% | 0.082 | 1.012 | 1.002 | 1.001 | 0.536 | 1.002 | 1.010 | 0.537 | 0.663 | 0.664 | 0.010 |
| hex: http/html-1kx1024 | 2099200 | 9207.8 ± 13.3% | 0.155 | 1.272 | 1.268 | 1.271 | 0.711 | 1.274 | 0.984 | 0.778 | 0.944 | 0.951 | 0.019 |
| hex: http/html-16kx64 | 2097280 | 17846.5 ± 0.8% | 0.082 | 1.023 | 1.024 | 1.025 | 0.575 | 1.022 | 0.993 | 0.579 | 0.659 | 0.659 | 0.010 |
| hex: http/html-1m | 524290 | 18441.2 ± 2.5% | 0.081 | 1.003 | 0.999 | 0.998 | 0.520 | 1.000 | 0.997 | 0.522 | 0.644 | 0.649 | 0.009 |
| hex: http/json-1kx1024 | 2099200 | 9198.4 ± 18.5% | 0.155 | 1.273 | 1.262 | 1.277 | 0.710 | 1.280 | 0.980 | 0.775 | 0.944 | 0.951 | 0.019 |
| hex: http/json-16kx64 | 2097280 | 17981.2 ± 0.6% | 0.084 | 1.019 | 1.018 | 1.018 | 0.569 | 1.018 | 0.986 | 0.574 | 0.654 | 0.654 | 0.010 |
| hex: http/json-1m | 524290 | 18615.6 ± 1.0% | 0.080 | 1.006 | 1.000 | 1.000 | 0.518 | 1.006 | 1.001 | 0.521 | 0.644 | 0.644 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 9364.9 ± 17.9% | 0.152 | 1.256 | 1.247 | 1.248 | 0.699 | 1.257 | 0.987 | 0.763 | 0.930 | 0.938 | 0.018 |
| hex: http/js-16kx64 | 2097280 | 17838.7 ± 1.6% | 0.084 | 1.028 | 1.025 | 1.025 | 0.573 | 1.026 | 0.996 | 0.579 | 0.659 | 0.660 | 0.010 |
| hex: http/js-1m | 524290 | 18734.6 ± 1.1% | 0.079 | 1.008 | 1.001 | 0.998 | 0.517 | 1.005 | 0.991 | 0.517 | 0.641 | 0.641 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 10412.7 ± 11.7% | 0.137 | 1.129 | 1.128 | 1.131 | 0.625 | 1.137 | 1.022 | 0.685 | 0.831 | 0.845 | 0.016 |
| hex: http/css-16kx64 | 2097280 | 18059.2 ± 0.5% | 0.083 | 1.019 | 1.015 | 1.014 | 0.567 | 1.016 | 0.987 | 0.571 | 0.652 | 0.652 | 0.010 |
| hex: http/css-1m | 524290 | 18782.9 ± 1.7% | 0.079 | 1.005 | 0.997 | 0.993 | 0.503 | 1.004 | 0.988 | 0.504 | 0.639 | 0.639 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18076.6 ± 0.5% | 0.082 | 1.006 | 1.002 | 1.004 | 0.535 | 0.999 | 1.002 | 0.536 | 0.664 | 0.663 | 0.010 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1486.4 ± 0.6% | 0.443 | 0.999 | 0.970 | 1.006 | 1.009 | 0.267 | 0.998 | 0.547 | 0.915 | 0.088 | 1.028 |
| qlog records, JSON text sequence | 1467503 | 1267.3 ± 1.0% | 0.690 | 0.978 | 1.011 | 1.013 | 1.012 | 0.266 | 1.003 | 0.503 | 0.831 | 0.106 | 1.019 |
| string: silesia/dickens | 172528 | 6902.6 ± 0.6% | 0.025 | 1.000 | 0.999 | 0.999 | 1.000 | 0.165 | 0.716 | 1.002 | 1.002 | 0.025 | 1.030 |
| string: silesia/nci | 1075110 | 7305.0 ± 0.7% | 0.024 | 1.002 | 1.001 | 1.001 | 1.001 | 0.210 | 0.565 | 1.001 | 1.003 | 0.024 | 0.987 |
| string: silesia/reymont | 1075159 | 3340.1 ± 1.0% | 0.052 | 1.004 | 0.996 | 1.003 | 1.007 | 0.388 | 0.871 | 0.999 | 1.005 | 0.051 | 1.046 |
| string: silesia/samba | 97582 | 4193.4 ± 0.6% | 0.054 | 1.003 | 0.999 | 1.004 | 1.006 | 0.124 | 0.945 | 1.004 | 1.004 | 0.053 | 1.093 |
| string: silesia/webster | 1098490 | 4045.3 ± 0.4% | 0.043 | 1.010 | 1.009 | 1.008 | 1.008 | 0.211 | 0.890 | 1.003 | 1.006 | 0.042 | 1.011 |
| string: silesia/xml | 1090118 | 6122.3 ± 4.9% | 0.029 | 1.000 | 0.997 | 1.004 | 1.003 | 0.252 | 0.776 | 1.003 | 1.003 | 0.029 | 1.019 |
| string: canterbury/alice29.txt | 159425 | 6420.7 ± 1.1% | 0.027 | 1.010 | 1.011 | 1.012 | 1.012 | 0.131 | 0.651 | 1.003 | 1.004 | 0.027 | 1.062 |
| string: canterbury/asyoulik.txt | 132198 | 5572.7 ± 0.3% | 0.030 | 1.027 | 1.031 | 1.033 | 1.035 | 0.129 | 0.600 | 1.004 | 1.015 | 0.030 | 1.058 |
| string: canterbury/lcet10.txt | 441884 | 6240.1 ± 0.5% | 0.028 | 1.008 | 1.005 | 1.009 | 1.009 | 0.183 | 0.800 | 1.005 | 1.004 | 0.028 | 1.003 |
| string: canterbury/plrabn12.txt | 503330 | 5712.6 ± 0.2% | 0.030 | 0.999 | 1.000 | 1.002 | 1.003 | 0.167 | 0.698 | 0.999 | 1.002 | 0.030 | 1.009 |
| string: canterbury-large/E.coli | 1048578 | 19205.5 ± 0.4% | 0.078 | 1.004 | 1.004 | 1.005 | 1.003 | 0.479 | 1.004 | 1.003 | 1.005 | 0.009 | 1.005 |
| string: canterbury-large/bible.txt | 1055886 | 6790.3 ± 0.3% | 0.026 | 1.001 | 1.002 | 1.002 | 1.003 | 0.493 | 0.974 | 1.000 | 1.001 | 0.026 | 1.000 |
| string: canterbury-large/world192.txt | 1103121 | 4013.3 ± 0.6% | 0.043 | 1.020 | 1.020 | 1.019 | 1.019 | 0.191 | 0.832 | 1.002 | 1.011 | 0.042 | 1.006 |
| string: http/html-1m | 1058582 | 6736.8 ± 1.6% | 0.026 | 1.003 | 0.925 | 1.003 | 1.005 | 0.402 | 0.895 | 1.003 | 1.005 | 0.026 | 1.013 |
| string: http/json-1m | 1190272 | 3152.8 ± 0.5% | 0.051 | 1.005 | 0.969 | 1.005 | 1.004 | 0.133 | 0.372 | 1.002 | 1.004 | 0.051 | 1.047 |
| string: http/js-1m | 1144362 | 2749.8 ± 0.4% | 0.061 | 1.005 | 1.010 | 1.000 | 1.009 | 0.164 | 0.841 | 1.003 | 1.007 | 0.061 | 1.019 |
| string: http/css-1m | 1097820 | 3977.6 ± 0.6% | 0.043 | 1.007 | 1.006 | 1.011 | 1.009 | 0.206 | 0.646 | 1.001 | 1.008 | 0.042 | 1.017 |
| string: dickens as Cyrillic and CJK | 1883069 | 3067.1 ± 0.2% | 0.048 | 1.003 | 0.124 | 1.001 | 1.001 | 0.319 | 1.004 | 1.002 | 1.003 | 0.048 | 1.001 |
| hex: silesia/dickens | 524290 | 15661.6 ± 0.2% | 0.999 | 0.177 | 1.001 | 1.001 | 1.002 | 1.000 | 1.001 | 0.998 | 1.001 | 0.177 | 1.001 |
| hex: silesia/mozilla | 524290 | 15656.8 ± 0.1% | 0.999 | 0.178 | 1.001 | 1.000 | 1.000 | 0.998 | 0.999 | 1.001 | 1.001 | 0.178 | 1.000 |
| hex: silesia/mr | 524290 | 15669.9 ± 0.2% | 1.002 | 0.178 | 1.002 | 1.001 | 1.001 | 1.001 | 1.002 | 1.002 | 1.002 | 0.178 | 1.002 |
| hex: silesia/nci | 524290 | 15622.1 ± 0.2% | 1.000 | 0.178 | 1.001 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 1.003 | 0.178 | 1.002 |
| hex: silesia/ooffice | 524290 | 15576.1 ± 0.1% | 1.000 | 0.178 | 1.000 | 1.001 | 1.001 | 1.001 | 1.000 | 0.999 | 1.001 | 0.178 | 1.001 |
| hex: silesia/osdb | 524290 | 15644.7 ± 0.1% | 1.000 | 0.178 | 0.998 | 0.999 | 1.000 | 1.001 | 1.001 | 1.000 | 0.999 | 0.178 | 1.000 |
| hex: silesia/reymont | 524290 | 15637.6 ± 0.3% | 1.002 | 0.177 | 1.001 | 1.000 | 1.000 | 1.001 | 1.001 | 1.002 | 1.003 | 0.178 | 1.001 |
| hex: silesia/samba | 524290 | 15653.6 ± 0.2% | 0.999 | 0.178 | 1.000 | 1.002 | 1.001 | 1.000 | 1.001 | 0.998 | 1.000 | 0.178 | 1.001 |
| hex: silesia/sao | 524290 | 15636.8 ± 0.4% | 1.002 | 0.178 | 0.997 | 1.000 | 1.001 | 0.998 | 1.001 | 1.002 | 1.000 | 0.178 | 1.002 |
| hex: silesia/webster | 524290 | 15676.8 ± 0.1% | 1.001 | 0.177 | 0.997 | 1.000 | 1.000 | 0.998 | 1.000 | 1.000 | 0.999 | 0.177 | 1.002 |
| hex: silesia/x-ray | 524290 | 15613.4 ± 0.2% | 1.000 | 0.179 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 0.995 | 0.990 | 0.178 | 1.000 |
| hex: silesia/xml | 524290 | 15636.0 ± 0.2% | 1.001 | 0.178 | 0.999 | 1.000 | 1.000 | 1.001 | 1.001 | 1.002 | 1.002 | 0.178 | 1.002 |
| hex: canterbury/alice29.txt | 304180 | 15485.8 ± 0.1% | 0.996 | 0.180 | 1.000 | 1.001 | 1.001 | 1.000 | 1.001 | 0.998 | 1.001 | 0.179 | 1.000 |
| hex: canterbury/asyoulik.txt | 250360 | 15704.0 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15621.5 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.000 | 1.001 | 0.998 | 1.001 | 1.001 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15441.0 ± 0.1% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.994 | 1.000 | 1.002 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14938.9 ± 0.1% | 1.003 | 0.185 | 1.001 | 1.001 | 1.000 | 0.983 | 1.001 | 1.004 | 1.015 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15636.5 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/lcet10.txt | 524290 | 15637.9 ± 0.3% | 1.000 | 0.178 | 1.000 | 1.000 | 0.999 | 0.999 | 1.001 | 1.000 | 1.000 | 0.177 | 1.001 |
| hex: canterbury/plrabn12.txt | 524290 | 15681.5 ± 0.2% | 0.999 | 0.177 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 0.999 | 1.000 | 0.177 | 1.000 |
| hex: canterbury/ptt5 | 524290 | 15610.3 ± 0.3% | 1.001 | 0.179 | 1.002 | 1.001 | 1.002 | 1.001 | 1.001 | 1.002 | 1.002 | 0.179 | 1.001 |
| hex: canterbury/sum | 76482 | 15643.5 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.999 | 1.001 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 14994.5 ± 0.1% | 1.002 | 0.185 | 1.000 | 1.000 | 1.000 | 0.986 | 1.000 | 1.004 | 1.014 | 0.183 | 1.002 |
| hex: canterbury-large/E.coli | 524290 | 15630.7 ± 0.3% | 1.000 | 0.177 | 1.000 | 0.999 | 1.000 | 0.998 | 1.000 | 0.999 | 1.000 | 0.178 | 0.999 |
| hex: canterbury-large/bible.txt | 524290 | 15589.0 ± 0.2% | 1.000 | 0.179 | 1.002 | 1.002 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury-large/world192.txt | 524290 | 15627.3 ± 0.2% | 1.001 | 0.178 | 1.002 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 1.003 | 0.178 | 1.001 |
| hex: http/html-1kx1024 | 2099200 | 13705.8 ± 0.3% | 1.003 | 0.195 | 1.001 | 1.001 | 1.001 | 0.941 | 1.001 | 1.009 | 1.033 | 0.186 | 1.008 |
| hex: http/html-16kx64 | 2097280 | 15232.2 ± 0.2% | 1.002 | 0.181 | 1.004 | 0.999 | 1.000 | 0.995 | 1.002 | 1.003 | 1.009 | 0.179 | 1.004 |
| hex: http/html-1m | 524290 | 15618.0 ± 0.4% | 1.001 | 0.177 | 1.002 | 1.002 | 1.001 | 1.003 | 1.003 | 1.002 | 1.003 | 0.178 | 1.001 |
| hex: http/json-1kx1024 | 2099200 | 13668.1 ± 0.4% | 1.008 | 0.195 | 1.004 | 0.999 | 1.001 | 0.944 | 1.003 | 1.011 | 1.041 | 0.188 | 1.010 |
| hex: http/json-16kx64 | 2097280 | 15228.3 ± 0.5% | 1.000 | 0.181 | 1.000 | 1.001 | 1.001 | 0.989 | 1.000 | 1.005 | 1.010 | 0.180 | 1.003 |
| hex: http/json-1m | 524290 | 15679.8 ± 0.3% | 1.001 | 0.177 | 0.999 | 1.001 | 1.001 | 0.999 | 1.000 | 1.000 | 1.000 | 0.177 | 1.001 |
| hex: http/js-1kx1024 | 2099200 | 13777.1 ± 0.3% | 1.009 | 0.194 | 0.998 | 1.002 | 1.000 | 0.930 | 0.990 | 1.010 | 1.032 | 0.186 | 1.012 |
| hex: http/js-16kx64 | 2097280 | 15192.3 ± 0.3% | 1.002 | 0.182 | 0.999 | 1.001 | 1.001 | 0.996 | 1.006 | 1.007 | 1.011 | 0.181 | 1.003 |
| hex: http/js-1m | 524290 | 15631.5 ± 0.1% | 1.003 | 0.177 | 1.003 | 1.002 | 1.001 | 1.003 | 1.003 | 1.003 | 1.003 | 0.177 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 13717.9 ± 0.4% | 1.005 | 0.194 | 0.998 | 1.002 | 1.001 | 0.934 | 0.997 | 1.008 | 1.031 | 0.187 | 1.009 |
| hex: http/css-16kx64 | 2097280 | 15205.1 ± 0.4% | 1.004 | 0.181 | 1.001 | 1.001 | 1.001 | 0.993 | 1.002 | 1.009 | 1.007 | 0.181 | 1.001 |
| hex: http/css-1m | 524290 | 15680.8 ± 0.2% | 1.001 | 0.177 | 1.001 | 1.001 | 1.002 | 1.000 | 1.001 | 0.999 | 1.002 | 0.177 | 1.001 |
| hex: shuffled/dickens-1m | 524290 | 15679.9 ± 0.2% | 1.002 | 0.177 | 1.002 | 1.002 | 1.002 | 1.001 | 1.001 | 1.001 | 1.002 | 0.177 | 1.002 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.057 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.054 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.272 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.268 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.271 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.274 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.273 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.262 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.277 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.280 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.256 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.247 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.248 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.257 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.129 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.128 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.131 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.137 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43256.8 ± 0.1% | 47393.7 ± 0.1% | 0.913 | — | — |
| string: silesia/nci | 1048576 | 35090.9 ± 1.9% | 37392.6 ± 2.7% | 0.938 | — | — |
| string: silesia/reymont | 1048576 | 36300.8 ± 2.5% | 39054.9 ± 2.6% | 0.929 | — | — |
| string: silesia/samba | 65546 | 43428.1 ± 0.1% | 48512.0 ± 0.0% | 0.895 | — | — |
| string: silesia/webster | 1048576 | 35037.5 ± 3.2% | 38371.2 ± 1.6% | 0.913 | — | — |
| string: silesia/xml | 1048576 | 32251.9 ± 1.4% | 33353.2 ± 2.4% | 0.967 | — | — |
| string: canterbury/alice29.txt | 152089 | 35910.1 ± 0.1% | 36544.4 ± 0.1% | 0.983 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43251.8 ± 0.1% | 47629.0 ± 0.1% | 0.908 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36114.6 ± 0.1% | 36747.9 ± 0.2% | 0.983 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 43437.1 ± 0.1% | 47528.6 ± 0.2% | 0.914 | — | — |
| string: canterbury-large/E.coli | 1048576 | 35886.0 ± 1.7% | 38236.6 ± 1.0% | 0.939 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 31448.1 ± 0.4% | 32709.9 ± 1.5% | 0.961 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 31392.4 ± 3.2% | 32404.1 ± 2.9% | 0.969 | — | — |
| string: http/html-1m | 1048576 | 33925.6 ± 2.2% | 36249.5 ± 1.9% | 0.936 | — | — |
| string: http/json-1m | 1048576 | 30570.0 ± 2.7% | 32537.5 ± 1.2% | 0.940 | — | — |
| string: http/js-1m | 1048576 | 34262.5 ± 2.4% | 36409.1 ± 2.8% | 0.941 | — | — |
| string: http/css-1m | 1048576 | 37063.9 ± 1.9% | 40267.4 ± 1.5% | 0.920 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5769.1 ± 0.6% | 5655.1 ± 0.1% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.913 of simdutf.
- string: silesia/nci: stdx runs at 0.938 of simdutf.
- string: silesia/reymont: stdx runs at 0.929 of simdutf.
- string: silesia/samba: stdx runs at 0.895 of simdutf.
- string: silesia/webster: stdx runs at 0.913 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.908 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.914 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.939 of simdutf.
- string: http/html-1m: stdx runs at 0.936 of simdutf.
- string: http/json-1m: stdx runs at 0.940 of simdutf.
- string: http/js-1m: stdx runs at 0.941 of simdutf.
- string: http/css-1m: stdx runs at 0.920 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 37502.2 ± 2.0% | 41053.0 ± 1.6% | 0.914 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 31600.6 ± 0.6% | 32655.0 ± 0.8% | 0.968 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 35217.0 ± 1.4% | 37880.8 ± 0.8% | 0.930 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 35753.9 ± 0.6% | 38860.9 ± 1.1% | 0.920 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 35795.0 ± 1.0% | 38947.5 ± 0.6% | 0.919 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 35890.5 ± 0.7% | 38989.8 ± 2.0% | 0.921 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5736.4 ± 0.4% | 5619.9 ± 0.4% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5729.7 ± 0.3% | 5626.5 ± 0.4% | 1.018 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5731.4 ± 0.4% | 5620.7 ± 0.4% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5738.9 ± 0.3% | 5616.3 ± 0.3% | 1.022 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5736.2 ± 0.3% | 5618.8 ± 0.4% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5731.1 ± 0.6% | 5618.0 ± 0.4% | 1.020 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1128.8 ± 0.4% | 929.5 ± 0.6% | 1023.2 ± 0.3% | 300.3 ± 0.3% | 666.8 ± 0.3% | 309.9 ± 1.3% | 1.214 | 1.103 | 3.759 | 1.693 | 3.642 |
| qlog records, JSON text sequence | 1467503 | 840.6 ± 0.5% | 817.9 ± 0.3% | 785.0 ± 0.8% | 243.4 ± 0.7% | 700.5 ± 0.7% | 250.8 ± 0.6% | 1.028 | 1.071 | 3.453 | 1.200 | 3.352 |
| string: silesia/dickens | 172528 | 5034.3 ± 0.6% | 1877.8 ± 0.2% | 2641.5 ± 0.3% | 362.9 ± 1.3% | 2869.9 ± 0.3% | 547.2 ± 1.8% | 2.681 | 1.906 | 13.874 | 1.754 | 9.200 |
| string: silesia/nci | 1075110 | 4301.0 ± 0.8% | 2235.8 ± 0.4% | 2996.3 ± 0.2% | 544.6 ± 1.4% | 2994.7 ± 1.5% | 604.2 ± 2.5% | 1.924 | 1.435 | 7.897 | 1.436 | 7.118 |
| string: silesia/reymont | 1075159 | 2937.2 ± 2.3% | 1824.1 ± 1.8% | 2063.8 ± 0.8% | 375.2 ± 0.7% | 2147.3 ± 0.8% | 532.3 ± 1.5% | 1.610 | 1.423 | 7.828 | 1.368 | 5.518 |
| string: silesia/samba | 97582 | 3497.1 ± 0.4% | 2028.2 ± 0.1% | 2616.3 ± 0.4% | 322.7 ± 0.3% | 1497.6 ± 0.3% | 426.8 ± 1.6% | 1.724 | 1.337 | 10.838 | 2.335 | 8.193 |
| string: silesia/webster | 1098490 | 3643.8 ± 0.7% | 1516.8 ± 0.4% | 2013.2 ± 0.4% | 359.3 ± 0.6% | 2168.2 ± 1.0% | 499.8 ± 1.4% | 2.402 | 1.810 | 10.141 | 1.681 | 7.290 |
| string: silesia/xml | 1090118 | 4778.8 ± 0.3% | 2359.9 ± 0.3% | 2528.7 ± 0.6% | 454.2 ± 1.3% | 2840.2 ± 1.2% | 569.6 ± 1.1% | 2.025 | 1.890 | 10.521 | 1.683 | 8.390 |
| string: canterbury/alice29.txt | 159425 | 4312.9 ± 0.5% | 1599.6 ± 0.3% | 2454.6 ± 0.7% | 342.6 ± 0.8% | 2510.6 ± 0.5% | 506.3 ± 1.0% | 2.696 | 1.757 | 12.588 | 1.718 | 8.519 |
| string: canterbury/asyoulik.txt | 132198 | 3452.1 ± 0.4% | 1457.4 ± 0.1% | 2244.4 ± 0.4% | 334.6 ± 0.7% | 2090.7 ± 0.4% | 461.9 ± 1.6% | 2.369 | 1.538 | 10.316 | 1.651 | 7.474 |
| string: canterbury/lcet10.txt | 441884 | 5129.6 ± 0.2% | 1851.6 ± 0.2% | 2332.8 ± 1.0% | 390.9 ± 0.9% | 2865.3 ± 0.7% | 534.8 ± 0.8% | 2.770 | 2.199 | 13.123 | 1.790 | 9.592 |
| string: canterbury/plrabn12.txt | 503330 | 4131.0 ± 0.8% | 1736.5 ± 0.1% | 2063.3 ± 0.4% | 359.5 ± 0.5% | 2482.5 ± 0.5% | 500.3 ± 1.0% | 2.379 | 2.002 | 11.492 | 1.664 | 8.257 |
| string: canterbury-large/E.coli | 1048578 | 19250.7 ± 0.4% | 3604.5 ± 0.3% | 3258.4 ± 0.3% | 929.6 ± 1.2% | 5960.6 ± 1.0% | 769.0 ± 0.4% | 5.341 | 5.908 | 20.709 | 3.230 | 25.034 |
| string: canterbury-large/bible.txt | 1055886 | 6658.9 ± 1.0% | 2938.1 ± 0.5% | 2836.8 ± 0.8% | 418.5 ± 0.8% | 3750.6 ± 1.3% | 616.9 ± 3.0% | 2.266 | 2.347 | 15.913 | 1.775 | 10.795 |
| string: canterbury-large/world192.txt | 1103121 | 3382.0 ± 0.4% | 1481.5 ± 0.2% | 2013.4 ± 0.4% | 353.2 ± 0.4% | 2122.1 ± 0.9% | 501.9 ± 0.5% | 2.283 | 1.680 | 9.574 | 1.594 | 6.738 |
| string: http/html-1m | 1058582 | 6046.2 ± 1.4% | 2735.9 ± 0.3% | 2706.3 ± 0.4% | 442.8 ± 0.7% | 3491.4 ± 0.6% | 595.7 ± 1.5% | 2.210 | 2.234 | 13.655 | 1.732 | 10.150 |
| string: http/json-1m | 1190272 | 2546.7 ± 0.1% | 876.6 ± 0.1% | 2254.3 ± 0.4% | 391.8 ± 0.6% | 1049.6 ± 5.9% | 444.3 ± 0.6% | 2.905 | 1.130 | 6.501 | 2.426 | 5.732 |
| string: http/js-1m | 1144362 | 2283.9 ± 0.6% | 1027.4 ± 0.1% | 1638.4 ± 0.6% | 321.2 ± 0.5% | 1508.8 ± 1.4% | 420.0 ± 0.9% | 2.223 | 1.394 | 7.111 | 1.514 | 5.437 |
| string: http/css-1m | 1097820 | 2636.5 ± 0.7% | 1676.8 ± 0.2% | 2220.3 ± 0.8% | 404.5 ± 1.4% | 1911.3 ± 1.3% | 490.6 ± 1.1% | 1.572 | 1.187 | 6.517 | 1.379 | 5.374 |
| string: dickens as Cyrillic and CJK | 1883069 | 3060.7 ± 0.6% | 1688.7 ± 0.5% | 892.1 ± 0.7% | 351.4 ± 0.1% | 667.6 ± 0.2% | 157.8 ± 2.4% | 1.812 | 3.431 | 8.710 | 4.584 | 19.392 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1325.9 ± 1.4% | 980.8 ± 0.2% | 1204.8 ± 0.5% | 213.5 ± 0.2% | 469.6 ± 0.6% | 250.2 ± 3.8% | 1.352 | 1.101 | 6.211 | 2.823 | 5.299 |
| hex: silesia/dickens | 524290 | 18778.0 ± 0.3% | 3616.4 ± 0.1% | 3287.8 ± 0.3% | 505.7 ± 3.0% | 6049.0 ± 1.0% | 781.5 ± 2.5% | 5.192 | 5.711 | 37.133 | 3.104 | 24.029 |
| hex: silesia/mozilla | 524290 | 18839.9 ± 1.6% | 3617.6 ± 0.1% | 3286.3 ± 0.6% | 446.6 ± 2.6% | 5958.5 ± 2.7% | 783.6 ± 0.5% | 5.208 | 5.733 | 42.186 | 3.162 | 24.042 |
| hex: silesia/mr | 524290 | 18153.5 ± 0.8% | 3619.9 ± 0.1% | 3295.2 ± 0.2% | 567.1 ± 0.5% | 6070.9 ± 1.2% | 784.8 ± 0.3% | 5.015 | 5.509 | 32.009 | 2.990 | 23.132 |
| hex: silesia/nci | 524290 | 18919.4 ± 1.3% | 3616.9 ± 0.2% | 3290.2 ± 0.2% | 625.8 ± 1.8% | 6014.7 ± 1.6% | 785.0 ± 0.4% | 5.231 | 5.750 | 30.233 | 3.146 | 24.100 |
| hex: silesia/ooffice | 524290 | 18748.1 ± 1.9% | 3621.9 ± 0.1% | 3288.4 ± 0.2% | 397.7 ± 1.1% | 6044.5 ± 2.1% | 783.9 ± 0.4% | 5.176 | 5.701 | 47.145 | 3.102 | 23.916 |
| hex: silesia/osdb | 524290 | 18391.6 ± 0.9% | 3617.8 ± 0.2% | 3288.8 ± 0.6% | 475.7 ± 2.2% | 6058.1 ± 1.3% | 784.0 ± 0.6% | 5.084 | 5.592 | 38.665 | 3.036 | 23.460 |
| hex: silesia/reymont | 524290 | 18409.7 ± 1.0% | 3618.3 ± 0.3% | 3282.1 ± 0.5% | 510.8 ± 1.6% | 6094.5 ± 0.9% | 784.4 ± 0.6% | 5.088 | 5.609 | 36.040 | 3.021 | 23.469 |
| hex: silesia/samba | 524290 | 18303.3 ± 0.4% | 3617.8 ± 0.2% | 3287.1 ± 0.2% | 400.6 ± 0.9% | 6083.3 ± 0.9% | 785.4 ± 0.6% | 5.059 | 5.568 | 45.690 | 3.009 | 23.303 |
| hex: silesia/sao | 524290 | 18793.5 ± 0.9% | 3618.2 ± 0.2% | 3289.4 ± 0.2% | 337.1 ± 0.7% | 6065.2 ± 1.7% | 783.5 ± 0.3% | 5.194 | 5.713 | 55.751 | 3.099 | 23.987 |
| hex: silesia/webster | 524290 | 18834.2 ± 1.5% | 3616.9 ± 0.3% | 3296.0 ± 0.8% | 456.8 ± 1.5% | 6047.9 ± 0.9% | 781.7 ± 0.3% | 5.207 | 5.714 | 41.231 | 3.114 | 24.094 |
| hex: silesia/x-ray | 524290 | 18349.7 ± 0.5% | 3619.1 ± 0.2% | 3291.6 ± 0.3% | 466.1 ± 1.1% | 6059.5 ± 0.6% | 783.3 ± 0.4% | 5.070 | 5.575 | 39.368 | 3.028 | 23.425 |
| hex: silesia/xml | 524290 | 18703.3 ± 1.0% | 3618.3 ± 0.1% | 3293.1 ± 0.2% | 512.4 ± 1.6% | 6072.6 ± 1.1% | 783.5 ± 0.1% | 5.169 | 5.680 | 36.502 | 3.080 | 23.872 |
| hex: canterbury/alice29.txt | 304180 | 19437.9 ± 0.3% | 3642.9 ± 0.0% | 3322.4 ± 0.3% | 500.3 ± 1.1% | 6054.2 ± 0.7% | 782.9 ± 0.6% | 5.336 | 5.851 | 38.854 | 3.211 | 24.829 |
| hex: canterbury/asyoulik.txt | 250360 | 19431.3 ± 0.3% | 3638.6 ± 0.1% | 3373.9 ± 0.1% | 499.8 ± 1.7% | 6052.8 ± 1.4% | 780.8 ± 0.8% | 5.340 | 5.759 | 38.876 | 3.210 | 24.887 |
| hex: canterbury/cp.html | 49208 | 19294.2 ± 0.1% | 3639.5 ± 0.0% | 3282.6 ± 0.3% | 468.5 ± 1.6% | 6283.9 ± 0.5% | 762.3 ± 3.3% | 5.301 | 5.878 | 41.183 | 3.070 | 25.310 |
| hex: canterbury/fields.c | 22302 | 18913.8 ± 0.6% | 3629.5 ± 0.0% | 3392.6 ± 0.2% | 499.0 ± 0.4% | 6255.7 ± 0.3% | 754.4 ± 1.9% | 5.211 | 5.575 | 37.904 | 3.023 | 25.071 |
| hex: canterbury/grammar.lsp | 7444 | 17506.1 ± 1.8% | 3601.4 ± 0.0% | 3350.6 ± 0.5% | 552.5 ± 2.3% | 6176.8 ± 1.0% | 712.1 ± 2.4% | 4.861 | 5.225 | 31.685 | 2.834 | 24.584 |
| hex: canterbury/kennedy.xls | 524290 | 18657.9 ± 5.0% | 3615.3 ± 0.1% | 3294.4 ± 0.5% | 659.6 ± 1.7% | 5956.4 ± 0.4% | 764.8 ± 3.4% | 5.161 | 5.664 | 28.287 | 3.132 | 24.396 |
| hex: canterbury/lcet10.txt | 524290 | 18798.5 ± 1.0% | 3612.1 ± 0.2% | 3279.7 ± 0.3% | 523.8 ± 0.8% | 6062.7 ± 1.4% | 781.9 ± 0.8% | 5.204 | 5.732 | 35.890 | 3.101 | 24.043 |
| hex: canterbury/plrabn12.txt | 524290 | 18405.9 ± 1.0% | 3611.9 ± 0.3% | 3284.4 ± 0.3% | 506.7 ± 4.1% | 6030.4 ± 0.5% | 783.3 ± 0.1% | 5.096 | 5.604 | 36.326 | 3.052 | 23.498 |
| hex: canterbury/ptt5 | 524290 | 18254.5 ± 0.8% | 3611.2 ± 0.2% | 3294.0 ± 0.2% | 556.1 ± 3.0% | 6022.3 ± 0.9% | 783.3 ± 0.3% | 5.055 | 5.542 | 32.826 | 3.031 | 23.304 |
| hex: canterbury/sum | 76482 | 19283.0 ± 0.2% | 3633.6 ± 0.1% | 3356.9 ± 0.2% | 503.8 ± 2.6% | 6179.8 ± 0.7% | 774.6 ± 1.2% | 5.307 | 5.744 | 38.275 | 3.120 | 24.894 |
| hex: canterbury/xargs.1 | 8456 | 17826.5 ± 0.7% | 3602.3 ± 0.0% | 3355.3 ± 0.1% | 499.7 ± 5.7% | 6157.6 ± 0.5% | 755.2 ± 1.9% | 4.949 | 5.313 | 35.677 | 2.895 | 23.605 |
| hex: canterbury-large/E.coli | 524290 | 18631.0 ± 1.4% | 3616.6 ± 0.3% | 3291.8 ± 0.3% | 688.3 ± 0.3% | 6075.5 ± 0.4% | 783.5 ± 4.4% | 5.151 | 5.660 | 27.069 | 3.067 | 23.779 |
| hex: canterbury-large/bible.txt | 524290 | 18675.9 ± 0.7% | 3615.3 ± 0.1% | 3289.6 ± 0.1% | 528.3 ± 1.7% | 6056.8 ± 1.7% | 783.7 ± 0.2% | 5.166 | 5.677 | 35.352 | 3.083 | 23.831 |
| hex: canterbury-large/world192.txt | 524290 | 18115.1 ± 1.1% | 3615.8 ± 0.4% | 3289.0 ± 0.2% | 493.7 ± 2.4% | 6083.1 ± 1.2% | 782.6 ± 0.3% | 5.010 | 5.508 | 36.690 | 2.978 | 23.148 |
| hex: http/html-1kx1024 | 2099200 | 9207.8 ± 13.3% | 3457.3 ± 0.2% | 2853.1 ± 0.2% | 464.9 ± 0.9% | 5093.6 ± 3.4% | 626.9 ± 15.6% | 2.663 | 3.227 | 19.806 | 1.808 | 14.687 |
| hex: http/html-16kx64 | 2097280 | 17846.5 ± 0.8% | 3607.7 ± 0.6% | 3261.5 ± 1.0% | 466.0 ± 0.5% | 5998.9 ± 0.2% | 756.3 ± 2.2% | 4.947 | 5.472 | 38.301 | 2.975 | 23.597 |
| hex: http/html-1m | 524290 | 18441.2 ± 2.5% | 3612.0 ± 0.3% | 3285.6 ± 0.1% | 491.0 ± 2.1% | 6029.6 ± 0.5% | 779.3 ± 1.5% | 5.106 | 5.613 | 37.560 | 3.058 | 23.665 |
| hex: http/json-1kx1024 | 2099200 | 9198.4 ± 18.5% | 3456.1 ± 0.3% | 2847.7 ± 0.4% | 565.7 ± 2.1% | 5092.0 ± 0.3% | 638.4 ± 3.4% | 2.661 | 3.230 | 16.259 | 1.806 | 14.410 |
| hex: http/json-16kx64 | 2097280 | 17981.2 ± 0.6% | 3609.1 ± 0.2% | 3258.0 ± 0.4% | 572.1 ± 0.6% | 6022.4 ± 0.5% | 750.4 ± 2.3% | 4.982 | 5.519 | 31.432 | 2.986 | 23.961 |
| hex: http/json-1m | 524290 | 18615.6 ± 1.0% | 3615.5 ± 0.3% | 3279.3 ± 0.2% | 588.8 ± 4.4% | 6045.4 ± 1.4% | 776.7 ± 1.1% | 5.149 | 5.677 | 31.616 | 3.079 | 23.968 |
| hex: http/js-1kx1024 | 2099200 | 9364.9 ± 17.9% | 3459.2 ± 0.1% | 2852.4 ± 0.2% | 478.0 ± 0.9% | 5102.8 ± 6.1% | 628.5 ± 20.4% | 2.707 | 3.283 | 19.592 | 1.835 | 14.900 |
| hex: http/js-16kx64 | 2097280 | 17838.7 ± 1.6% | 3609.9 ± 0.0% | 3261.1 ± 0.1% | 476.0 ± 0.6% | 6013.5 ± 0.5% | 754.3 ± 1.9% | 4.942 | 5.470 | 37.477 | 2.966 | 23.651 |
| hex: http/js-1m | 524290 | 18734.6 ± 1.1% | 3611.2 ± 0.3% | 3296.1 ± 0.2% | 503.2 ± 1.3% | 6070.4 ± 1.0% | 780.0 ± 1.8% | 5.188 | 5.684 | 37.231 | 3.086 | 24.018 |
| hex: http/css-1kx1024 | 2099200 | 10412.7 ± 11.7% | 3457.6 ± 0.1% | 2847.4 ± 0.6% | 483.4 ± 1.1% | 5149.2 ± 1.9% | 639.3 ± 2.9% | 3.012 | 3.657 | 21.538 | 2.022 | 16.287 |
| hex: http/css-16kx64 | 2097280 | 18059.2 ± 0.5% | 3611.2 ± 0.1% | 3259.9 ± 0.5% | 494.4 ± 0.6% | 6067.3 ± 1.0% | 746.3 ± 4.0% | 5.001 | 5.540 | 36.527 | 2.976 | 24.197 |
| hex: http/css-1m | 524290 | 18782.9 ± 1.7% | 3611.8 ± 0.2% | 3293.7 ± 0.4% | 495.9 ± 1.7% | 5980.7 ± 0.6% | 781.3 ± 1.5% | 5.200 | 5.703 | 37.875 | 3.141 | 24.040 |
| hex: shuffled/dickens-1m | 524290 | 18076.6 ± 0.5% | 3615.4 ± 0.2% | 3291.7 ± 0.2% | 505.5 ± 2.1% | 6081.4 ± 1.1% | 782.8 ± 0.4% | 5.000 | 5.492 | 35.762 | 2.972 | 23.092 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1486.4 ± 0.6% | 1253.2 ± 0.2% | 1040.6 ± 0.4% | 409.4 ± 0.1% | 449.1 ± 0.2% | 416.1 ± 0.2% | 1.186 | 1.428 | 3.631 | 3.310 | 3.572 |
| qlog records, JSON text sequence | 1467503 | 1267.3 ± 1.0% | 1064.3 ± 0.2% | 785.3 ± 0.4% | 378.1 ± 0.8% | 468.4 ± 1.2% | 279.1 ± 0.4% | 1.191 | 1.614 | 3.352 | 2.706 | 4.540 |
| string: silesia/dickens | 172528 | 6902.6 ± 0.6% | 2812.3 ± 0.4% | 2938.7 ± 1.1% | 429.8 ± 0.8% | 1565.3 ± 0.2% | 1008.3 ± 0.1% | 2.454 | 2.349 | 16.059 | 4.410 | 6.846 |
| string: silesia/nci | 1075110 | 7305.0 ± 0.7% | 3413.5 ± 0.6% | 3099.9 ± 0.6% | 822.0 ± 2.2% | 1826.1 ± 0.4% | 1108.7 ± 0.2% | 2.140 | 2.357 | 8.887 | 4.000 | 6.589 |
| string: silesia/reymont | 1075159 | 3340.1 ± 1.0% | 1992.8 ± 1.9% | 2062.1 ± 0.2% | 449.5 ± 0.5% | 1491.5 ± 0.5% | 948.8 ± 0.5% | 1.676 | 1.620 | 7.432 | 2.239 | 3.520 |
| string: silesia/samba | 97582 | 4193.4 ± 0.6% | 2104.3 ± 0.1% | 3450.5 ± 0.5% | 353.5 ± 0.6% | 1408.0 ± 0.4% | 1054.9 ± 0.2% | 1.993 | 1.215 | 11.861 | 2.978 | 3.975 |
| string: silesia/webster | 1098490 | 4045.3 ± 0.4% | 1879.8 ± 0.1% | 2056.1 ± 0.5% | 440.8 ± 0.6% | 1372.0 ± 0.2% | 646.8 ± 0.5% | 2.152 | 1.967 | 9.177 | 2.948 | 6.254 |
| string: silesia/xml | 1090118 | 6122.3 ± 4.9% | 2853.9 ± 0.2% | 2650.0 ± 0.5% | 609.8 ± 0.7% | 1733.0 ± 0.1% | 920.7 ± 0.3% | 2.145 | 2.310 | 10.039 | 3.533 | 6.650 |
| string: canterbury/alice29.txt | 159425 | 6420.7 ± 1.1% | 2193.2 ± 0.3% | 2759.8 ± 1.3% | 408.1 ± 0.4% | 1436.8 ± 0.3% | 953.4 ± 0.1% | 2.928 | 2.327 | 15.735 | 4.469 | 6.735 |
| string: canterbury/asyoulik.txt | 132198 | 5572.7 ± 0.3% | 1711.4 ± 0.3% | 2375.8 ± 1.6% | 402.8 ± 0.9% | 1309.6 ± 0.3% | 885.2 ± 0.2% | 3.256 | 2.346 | 13.834 | 4.255 | 6.296 |
| string: canterbury/lcet10.txt | 441884 | 6240.1 ± 0.5% | 2565.7 ± 0.5% | 2476.3 ± 1.5% | 468.5 ± 0.9% | 1524.5 ± 0.2% | 983.1 ± 0.5% | 2.432 | 2.520 | 13.320 | 4.093 | 6.347 |
| string: canterbury/plrabn12.txt | 503330 | 5712.6 ± 0.2% | 2064.6 ± 0.2% | 2068.9 ± 0.5% | 424.4 ± 0.2% | 1361.5 ± 0.3% | 929.2 ± 0.7% | 2.767 | 2.761 | 13.460 | 4.196 | 6.148 |
| string: canterbury-large/E.coli | 1048578 | 19205.5 ± 0.4% | 9746.9 ± 1.6% | 3775.1 ± 0.5% | 1474.9 ± 0.3% | 2354.0 ± 0.6% | 1191.6 ± 0.3% | 1.970 | 5.087 | 13.022 | 8.159 | 16.117 |
| string: canterbury-large/bible.txt | 1055886 | 6790.3 ± 0.3% | 4127.3 ± 0.8% | 3040.8 ± 1.5% | 503.7 ± 1.3% | 1979.2 ± 0.3% | 1122.9 ± 0.4% | 1.645 | 2.233 | 13.482 | 3.431 | 6.047 |
| string: canterbury-large/world192.txt | 1103121 | 4013.3 ± 0.6% | 1655.2 ± 0.4% | 2004.2 ± 0.6% | 449.6 ± 0.4% | 1345.9 ± 0.3% | 909.3 ± 0.2% | 2.425 | 2.003 | 8.927 | 2.982 | 4.414 |
| string: http/html-1m | 1058582 | 6736.8 ± 1.6% | 3946.9 ± 0.4% | 3041.3 ± 0.3% | 500.1 ± 0.9% | 1916.5 ± 0.9% | 805.4 ± 0.4% | 1.707 | 2.215 | 13.471 | 3.515 | 8.364 |
| string: http/json-1m | 1190272 | 3152.8 ± 0.5% | 1351.7 ± 0.2% | 1554.9 ± 0.7% | 443.9 ± 0.3% | 1036.1 ± 0.2% | 765.9 ± 0.5% | 2.332 | 2.028 | 7.103 | 3.043 | 4.117 |
| string: http/js-1m | 1144362 | 2749.8 ± 0.4% | 1180.7 ± 0.3% | 1627.8 ± 0.2% | 369.1 ± 0.3% | 1085.0 ± 0.1% | 758.9 ± 0.2% | 2.329 | 1.689 | 7.449 | 2.534 | 3.623 |
| string: http/css-1m | 1097820 | 3977.6 ± 0.6% | 1493.4 ± 0.3% | 2143.0 ± 0.8% | 494.9 ± 0.4% | 1355.8 ± 0.3% | 893.5 ± 0.3% | 2.663 | 1.856 | 8.037 | 2.934 | 4.452 |
| string: dickens as Cyrillic and CJK | 1883069 | 3067.1 ± 0.2% | 2330.8 ± 0.7% | 514.4 ± 1.9% | 307.8 ± 1.2% | 560.3 ± 0.6% | 335.9 ± 0.1% | 1.316 | 5.962 | 9.964 | 5.474 | 9.131 |
| hex: silesia/dickens | 524290 | 15661.6 ± 0.2% | 1463.9 ± 0.2% | 1085.2 ± 0.5% | 500.0 ± 1.7% | 987.8 ± 0.5% | 733.5 ± 0.3% | 10.699 | 14.433 | 31.323 | 15.854 | 21.351 |
| hex: silesia/mozilla | 524290 | 15656.8 ± 0.1% | 1474.4 ± 0.4% | 1088.8 ± 0.4% | 442.4 ± 0.8% | 995.0 ± 0.4% | 735.3 ± 0.3% | 10.619 | 14.380 | 35.388 | 15.736 | 21.294 |
| hex: silesia/mr | 524290 | 15669.9 ± 0.2% | 1483.6 ± 0.3% | 1095.4 ± 0.3% | 549.0 ± 3.7% | 998.0 ± 0.5% | 735.3 ± 0.2% | 10.562 | 14.305 | 28.541 | 15.701 | 21.310 |
| hex: silesia/nci | 524290 | 15622.1 ± 0.2% | 1471.2 ± 0.6% | 1088.4 ± 0.3% | 638.9 ± 2.7% | 991.4 ± 0.9% | 734.7 ± 0.2% | 10.619 | 14.353 | 24.451 | 15.758 | 21.265 |
| hex: silesia/ooffice | 524290 | 15576.1 ± 0.1% | 1464.3 ± 0.3% | 1086.3 ± 0.2% | 388.9 ± 0.3% | 990.6 ± 0.4% | 734.7 ± 0.1% | 10.637 | 14.339 | 40.053 | 15.723 | 21.201 |
| hex: silesia/osdb | 524290 | 15644.7 ± 0.1% | 1472.1 ± 0.3% | 1085.1 ± 0.2% | 467.7 ± 0.9% | 990.2 ± 0.2% | 734.8 ± 0.3% | 10.627 | 14.418 | 33.453 | 15.800 | 21.291 |
| hex: silesia/reymont | 524290 | 15637.6 ± 0.3% | 1461.9 ± 0.7% | 1087.5 ± 0.5% | 506.0 ± 1.1% | 989.3 ± 1.2% | 734.4 ± 0.7% | 10.697 | 14.379 | 30.903 | 15.806 | 21.292 |
| hex: silesia/samba | 524290 | 15653.6 ± 0.2% | 1467.6 ± 0.3% | 1084.9 ± 0.1% | 403.2 ± 0.1% | 990.3 ± 0.4% | 733.8 ± 1.2% | 10.666 | 14.429 | 38.822 | 15.806 | 21.332 |
| hex: silesia/sao | 524290 | 15636.8 ± 0.4% | 1466.3 ± 0.2% | 1084.8 ± 0.4% | 332.5 ± 0.7% | 989.5 ± 0.4% | 734.0 ± 0.3% | 10.664 | 14.414 | 47.028 | 15.803 | 21.303 |
| hex: silesia/webster | 524290 | 15676.8 ± 0.1% | 1466.1 ± 0.2% | 1086.2 ± 0.3% | 475.7 ± 0.2% | 992.6 ± 0.1% | 735.7 ± 0.5% | 10.693 | 14.432 | 32.957 | 15.794 | 21.310 |
| hex: silesia/x-ray | 524290 | 15613.4 ± 0.2% | 1475.2 ± 0.3% | 1089.3 ± 0.4% | 446.8 ± 2.1% | 994.4 ± 0.4% | 733.4 ± 0.3% | 10.584 | 14.333 | 34.944 | 15.701 | 21.289 |
| hex: silesia/xml | 524290 | 15636.0 ± 0.2% | 1470.3 ± 0.3% | 1086.2 ± 0.3% | 620.1 ± 0.7% | 991.7 ± 0.1% | 734.0 ± 0.2% | 10.634 | 14.396 | 25.216 | 15.767 | 21.301 |
| hex: canterbury/alice29.txt | 304180 | 15485.8 ± 0.1% | 1473.8 ± 0.5% | 1090.2 ± 0.2% | 499.0 ± 0.7% | 990.1 ± 0.6% | 735.9 ± 0.6% | 10.507 | 14.205 | 31.033 | 15.641 | 21.044 |
| hex: canterbury/asyoulik.txt | 250360 | 15704.0 ± 0.2% | 1481.6 ± 0.4% | 1094.1 ± 0.3% | 496.1 ± 0.6% | 997.5 ± 0.6% | 740.3 ± 0.2% | 10.599 | 14.354 | 31.653 | 15.743 | 21.214 |
| hex: canterbury/cp.html | 49208 | 15621.5 ± 0.1% | 1483.7 ± 0.9% | 1099.5 ± 0.4% | 521.1 ± 2.8% | 1005.2 ± 0.6% | 743.8 ± 0.1% | 10.529 | 14.208 | 29.979 | 15.541 | 21.002 |
| hex: canterbury/fields.c | 22302 | 15441.0 ± 0.1% | 1427.2 ± 1.0% | 1067.2 ± 1.1% | 612.9 ± 4.4% | 986.6 ± 0.1% | 737.2 ± 0.1% | 10.819 | 14.468 | 25.194 | 15.650 | 20.946 |
| hex: canterbury/grammar.lsp | 7444 | 14938.9 ± 0.1% | 1506.9 ± 0.2% | 1094.7 ± 0.5% | 659.3 ± 4.2% | 995.9 ± 0.5% | 726.6 ± 0.1% | 9.913 | 13.647 | 22.660 | 15.001 | 20.560 |
| hex: canterbury/kennedy.xls | 524290 | 15636.5 ± 0.2% | 1475.9 ± 0.2% | 1088.2 ± 0.6% | 652.6 ± 1.4% | 989.2 ± 0.6% | 734.1 ± 0.4% | 10.595 | 14.369 | 23.961 | 15.806 | 21.300 |
| hex: canterbury/lcet10.txt | 524290 | 15637.9 ± 0.3% | 1462.2 ± 0.2% | 1082.1 ± 0.5% | 494.4 ± 2.0% | 986.4 ± 0.4% | 733.9 ± 0.5% | 10.695 | 14.451 | 31.632 | 15.854 | 21.309 |
| hex: canterbury/plrabn12.txt | 524290 | 15681.5 ± 0.2% | 1464.4 ± 0.3% | 1085.3 ± 0.3% | 490.5 ± 1.1% | 989.5 ± 0.4% | 735.6 ± 0.3% | 10.708 | 14.449 | 31.970 | 15.848 | 21.317 |
| hex: canterbury/ptt5 | 524290 | 15610.3 ± 0.3% | 1478.9 ± 0.1% | 1090.8 ± 0.6% | 555.8 ± 1.1% | 991.4 ± 0.6% | 734.3 ± 0.7% | 10.555 | 14.310 | 28.088 | 15.746 | 21.258 |
| hex: canterbury/sum | 76482 | 15643.5 ± 0.1% | 1495.6 ± 0.1% | 1104.9 ± 0.2% | 584.7 ± 2.8% | 998.7 ± 0.0% | 744.3 ± 0.1% | 10.459 | 14.158 | 26.757 | 15.664 | 21.018 |
| hex: canterbury/xargs.1 | 8456 | 14994.5 ± 0.1% | 1493.1 ± 0.3% | 1095.4 ± 0.9% | 640.5 ± 7.1% | 1001.3 ± 0.2% | 727.8 ± 0.9% | 10.042 | 13.688 | 23.410 | 14.975 | 20.602 |
| hex: canterbury-large/E.coli | 524290 | 15630.7 ± 0.3% | 1473.0 ± 0.4% | 1088.4 ± 0.5% | 672.9 ± 0.1% | 993.1 ± 0.7% | 734.7 ± 0.3% | 10.612 | 14.361 | 23.229 | 15.740 | 21.275 |
| hex: canterbury-large/bible.txt | 524290 | 15589.0 ± 0.2% | 1464.1 ± 0.3% | 1085.0 ± 0.6% | 514.9 ± 0.6% | 987.6 ± 0.9% | 733.8 ± 0.2% | 10.648 | 14.367 | 30.274 | 15.784 | 21.244 |
| hex: canterbury-large/world192.txt | 524290 | 15627.3 ± 0.2% | 1466.2 ± 0.3% | 1083.4 ± 0.6% | 501.9 ± 0.6% | 989.8 ± 0.6% | 733.6 ± 0.6% | 10.658 | 14.424 | 31.136 | 15.788 | 21.301 |
| hex: http/html-1kx1024 | 2099200 | 13705.8 ± 0.3% | 1455.2 ± 0.3% | 1062.9 ± 0.6% | 501.8 ± 0.1% | 982.5 ± 0.1% | 692.8 ± 0.1% | 9.418 | 12.895 | 27.313 | 13.949 | 19.783 |
| hex: http/html-16kx64 | 2097280 | 15232.2 ± 0.2% | 1445.0 ± 0.3% | 1075.2 ± 0.3% | 506.9 ± 0.2% | 995.7 ± 0.1% | 734.3 ± 0.2% | 10.541 | 14.167 | 30.052 | 15.298 | 20.745 |
| hex: http/html-1m | 524290 | 15618.0 ± 0.4% | 1468.1 ± 0.1% | 1086.3 ± 0.2% | 500.4 ± 0.1% | 991.5 ± 0.4% | 734.1 ± 0.7% | 10.638 | 14.377 | 31.213 | 15.751 | 21.276 |
| hex: http/json-1kx1024 | 2099200 | 13668.1 ± 0.4% | 1464.4 ± 0.2% | 1067.8 ± 0.3% | 608.6 ± 0.4% | 986.8 ± 0.1% | 693.0 ± 0.1% | 9.334 | 12.800 | 22.457 | 13.851 | 19.723 |
| hex: http/json-16kx64 | 2097280 | 15228.3 ± 0.5% | 1445.4 ± 0.6% | 1075.7 ± 0.4% | 616.5 ± 1.0% | 994.9 ± 0.3% | 735.1 ± 0.1% | 10.536 | 14.156 | 24.702 | 15.306 | 20.716 |
| hex: http/json-1m | 524290 | 15679.8 ± 0.3% | 1473.4 ± 0.2% | 1088.8 ± 0.3% | 634.1 ± 0.9% | 991.2 ± 0.4% | 734.3 ± 0.6% | 10.642 | 14.401 | 24.729 | 15.819 | 21.354 |
| hex: http/js-1kx1024 | 2099200 | 13777.1 ± 0.3% | 1457.6 ± 0.5% | 1063.3 ± 0.6% | 499.2 ± 0.4% | 983.9 ± 0.2% | 693.1 ± 0.3% | 9.452 | 12.957 | 27.598 | 14.003 | 19.877 |
| hex: http/js-16kx64 | 2097280 | 15192.3 ± 0.3% | 1445.1 ± 0.2% | 1074.7 ± 0.4% | 504.2 ± 0.3% | 995.5 ± 0.1% | 735.3 ± 0.2% | 10.513 | 14.136 | 30.131 | 15.260 | 20.662 |
| hex: http/js-1m | 524290 | 15631.5 ± 0.1% | 1464.1 ± 0.3% | 1085.3 ± 0.4% | 510.4 ± 0.5% | 987.4 ± 0.4% | 735.5 ± 0.3% | 10.677 | 14.403 | 30.628 | 15.831 | 21.252 |
| hex: http/css-1kx1024 | 2099200 | 13717.9 ± 0.4% | 1456.1 ± 0.1% | 1062.8 ± 0.2% | 532.1 ± 0.2% | 982.9 ± 0.1% | 692.8 ± 0.3% | 9.421 | 12.908 | 25.779 | 13.957 | 19.801 |
| hex: http/css-16kx64 | 2097280 | 15205.1 ± 0.4% | 1443.1 ± 0.2% | 1074.7 ± 0.2% | 542.0 ± 0.5% | 999.2 ± 0.3% | 735.2 ± 0.3% | 10.537 | 14.148 | 28.052 | 15.217 | 20.682 |
| hex: http/css-1m | 524290 | 15680.8 ± 0.2% | 1467.8 ± 0.3% | 1085.7 ± 0.4% | 527.4 ± 0.7% | 990.9 ± 0.5% | 733.1 ± 0.6% | 10.683 | 14.443 | 29.731 | 15.824 | 21.391 |
| hex: shuffled/dickens-1m | 524290 | 15679.9 ± 0.2% | 1463.2 ± 0.2% | 1084.2 ± 0.3% | 500.5 ± 0.9% | 986.4 ± 0.4% | 735.5 ± 0.5% | 10.716 | 14.462 | 31.329 | 15.896 | 21.320 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1527.5 ± 0.4% | 1253.2 ± 0.2% | 1040.6 ± 0.4% | 409.4 ± 0.1% | 449.1 ± 0.2% | 416.1 ± 0.2% | 1.219 | 1.468 | 3.731 | 3.401 | 3.671 |
| qlog records, JSON text sequence | 1467503 | 1290.8 ± 0.3% | 1064.3 ± 0.2% | 785.3 ± 0.4% | 378.1 ± 0.8% | 468.4 ± 1.2% | 279.1 ± 0.4% | 1.213 | 1.644 | 3.414 | 2.756 | 4.625 |
| string: silesia/dickens | 172528 | 7111.0 ± 0.6% | 2812.3 ± 0.4% | 2938.7 ± 1.1% | 429.8 ± 0.8% | 1565.3 ± 0.2% | 1008.3 ± 0.1% | 2.529 | 2.420 | 16.544 | 4.543 | 7.053 |
| string: silesia/nci | 1075110 | 7208.5 ± 6.2% | 3413.5 ± 0.6% | 3099.9 ± 0.6% | 822.0 ± 2.2% | 1826.1 ± 0.4% | 1108.7 ± 0.2% | 2.112 | 2.325 | 8.769 | 3.948 | 6.502 |
| string: silesia/reymont | 1075159 | 3492.5 ± 1.5% | 1992.8 ± 1.9% | 2062.1 ± 0.2% | 449.5 ± 0.5% | 1491.5 ± 0.5% | 948.8 ± 0.5% | 1.753 | 1.694 | 7.771 | 2.342 | 3.681 |
| string: silesia/samba | 97582 | 4582.7 ± 0.3% | 2104.3 ± 0.1% | 3450.5 ± 0.5% | 353.5 ± 0.6% | 1408.0 ± 0.4% | 1054.9 ± 0.2% | 2.178 | 1.328 | 12.962 | 3.255 | 4.344 |
| string: silesia/webster | 1098490 | 4089.2 ± 0.8% | 1879.8 ± 0.1% | 2056.1 ± 0.5% | 440.8 ± 0.6% | 1372.0 ± 0.2% | 646.8 ± 0.5% | 2.175 | 1.989 | 9.276 | 2.980 | 6.322 |
| string: silesia/xml | 1090118 | 6238.5 ± 0.7% | 2853.9 ± 0.2% | 2650.0 ± 0.5% | 609.8 ± 0.7% | 1733.0 ± 0.1% | 920.7 ± 0.3% | 2.186 | 2.354 | 10.230 | 3.600 | 6.776 |
| string: canterbury/alice29.txt | 159425 | 6821.4 ± 2.0% | 2193.2 ± 0.3% | 2759.8 ± 1.3% | 408.1 ± 0.4% | 1436.8 ± 0.3% | 953.4 ± 0.1% | 3.110 | 2.472 | 16.717 | 4.748 | 7.155 |
| string: canterbury/asyoulik.txt | 132198 | 5895.4 ± 1.8% | 1711.4 ± 0.3% | 2375.8 ± 1.6% | 402.8 ± 0.9% | 1309.6 ± 0.3% | 885.2 ± 0.2% | 3.445 | 2.481 | 14.635 | 4.502 | 6.660 |
| string: canterbury/lcet10.txt | 441884 | 6255.9 ± 0.6% | 2565.7 ± 0.5% | 2476.3 ± 1.5% | 468.5 ± 0.9% | 1524.5 ± 0.2% | 983.1 ± 0.5% | 2.438 | 2.526 | 13.354 | 4.104 | 6.363 |
| string: canterbury/plrabn12.txt | 503330 | 5762.5 ± 0.3% | 2064.6 ± 0.2% | 2068.9 ± 0.5% | 424.4 ± 0.2% | 1361.5 ± 0.3% | 929.2 ± 0.7% | 2.791 | 2.785 | 13.578 | 4.232 | 6.202 |
| string: canterbury-large/E.coli | 1048578 | 19295.3 ± 0.8% | 9746.9 ± 1.6% | 3775.1 ± 0.5% | 1474.9 ± 0.3% | 2354.0 ± 0.6% | 1191.6 ± 0.3% | 1.980 | 5.111 | 13.083 | 8.197 | 16.193 |
| string: canterbury-large/bible.txt | 1055886 | 6791.0 ± 0.3% | 4127.3 ± 0.8% | 3040.8 ± 1.5% | 503.7 ± 1.3% | 1979.2 ± 0.3% | 1122.9 ± 0.4% | 1.645 | 2.233 | 13.483 | 3.431 | 6.048 |
| string: canterbury-large/world192.txt | 1103121 | 4038.5 ± 0.3% | 1655.2 ± 0.4% | 2004.2 ± 0.6% | 449.6 ± 0.4% | 1345.9 ± 0.3% | 909.3 ± 0.2% | 2.440 | 2.015 | 8.983 | 3.001 | 4.441 |
| string: http/html-1m | 1058582 | 6824.3 ± 0.6% | 3946.9 ± 0.4% | 3041.3 ± 0.3% | 500.1 ± 0.9% | 1916.5 ± 0.9% | 805.4 ± 0.4% | 1.729 | 2.244 | 13.646 | 3.561 | 8.473 |
| string: http/json-1m | 1190272 | 3300.0 ± 0.3% | 1351.7 ± 0.2% | 1554.9 ± 0.7% | 443.9 ± 0.3% | 1036.1 ± 0.2% | 765.9 ± 0.5% | 2.441 | 2.122 | 7.435 | 3.185 | 4.309 |
| string: http/js-1m | 1144362 | 2802.7 ± 0.5% | 1180.7 ± 0.3% | 1627.8 ± 0.2% | 369.1 ± 0.3% | 1085.0 ± 0.1% | 758.9 ± 0.2% | 2.374 | 1.722 | 7.593 | 2.583 | 3.693 |
| string: http/css-1m | 1097820 | 4045.2 ± 0.8% | 1493.4 ± 0.3% | 2143.0 ± 0.8% | 494.9 ± 0.4% | 1355.8 ± 0.3% | 893.5 ± 0.3% | 2.709 | 1.888 | 8.174 | 2.984 | 4.527 |
| string: dickens as Cyrillic and CJK | 1883069 | 3070.5 ± 0.2% | 2330.8 ± 0.7% | 514.4 ± 1.9% | 307.8 ± 1.2% | 560.3 ± 0.6% | 335.9 ± 0.1% | 1.317 | 5.969 | 9.975 | 5.480 | 9.141 |
| hex: silesia/dickens | 524290 | 15674.5 ± 0.2% | 1463.9 ± 0.2% | 1085.2 ± 0.5% | 500.0 ± 1.7% | 987.8 ± 0.5% | 733.5 ± 0.3% | 10.707 | 14.445 | 31.349 | 15.867 | 21.369 |
| hex: silesia/mozilla | 524290 | 15662.7 ± 0.2% | 1474.4 ± 0.4% | 1088.8 ± 0.4% | 442.4 ± 0.8% | 995.0 ± 0.4% | 735.3 ± 0.3% | 10.623 | 14.386 | 35.402 | 15.742 | 21.302 |
| hex: silesia/mr | 524290 | 15699.1 ± 0.1% | 1483.6 ± 0.3% | 1095.4 ± 0.3% | 549.0 ± 3.7% | 998.0 ± 0.5% | 735.3 ± 0.2% | 10.581 | 14.331 | 28.594 | 15.731 | 21.350 |
| hex: silesia/nci | 524290 | 15659.9 ± 0.2% | 1471.2 ± 0.6% | 1088.4 ± 0.3% | 638.9 ± 2.7% | 991.4 ± 0.9% | 734.7 ± 0.2% | 10.644 | 14.387 | 24.510 | 15.796 | 21.316 |
| hex: silesia/ooffice | 524290 | 15585.2 ± 0.5% | 1464.3 ± 0.3% | 1086.3 ± 0.2% | 388.9 ± 0.3% | 990.6 ± 0.4% | 734.7 ± 0.1% | 10.643 | 14.347 | 40.076 | 15.732 | 21.213 |
| hex: silesia/osdb | 524290 | 15642.4 ± 0.2% | 1472.1 ± 0.3% | 1085.1 ± 0.2% | 467.7 ± 0.9% | 990.2 ± 0.2% | 734.8 ± 0.3% | 10.626 | 14.416 | 33.449 | 15.798 | 21.288 |
| hex: silesia/reymont | 524290 | 15649.4 ± 0.4% | 1461.9 ± 0.7% | 1087.5 ± 0.5% | 506.0 ± 1.1% | 989.3 ± 1.2% | 734.4 ± 0.7% | 10.705 | 14.390 | 30.926 | 15.818 | 21.308 |
| hex: silesia/samba | 524290 | 15669.5 ± 0.2% | 1467.6 ± 0.3% | 1084.9 ± 0.1% | 403.2 ± 0.1% | 990.3 ± 0.4% | 733.8 ± 1.2% | 10.677 | 14.444 | 38.861 | 15.822 | 21.354 |
| hex: silesia/sao | 524290 | 15668.8 ± 0.2% | 1466.3 ± 0.2% | 1084.8 ± 0.4% | 332.5 ± 0.7% | 989.5 ± 0.4% | 734.0 ± 0.3% | 10.686 | 14.444 | 47.125 | 15.835 | 21.347 |
| hex: silesia/webster | 524290 | 15702.1 ± 0.2% | 1466.1 ± 0.2% | 1086.2 ± 0.3% | 475.7 ± 0.2% | 992.6 ± 0.1% | 735.7 ± 0.5% | 10.710 | 14.456 | 33.010 | 15.819 | 21.344 |
| hex: silesia/x-ray | 524290 | 15607.4 ± 0.2% | 1475.2 ± 0.3% | 1089.3 ± 0.4% | 446.8 ± 2.1% | 994.4 ± 0.4% | 733.4 ± 0.3% | 10.580 | 14.327 | 34.930 | 15.695 | 21.281 |
| hex: silesia/xml | 524290 | 15661.8 ± 0.3% | 1470.3 ± 0.3% | 1086.2 ± 0.3% | 620.1 ± 0.7% | 991.7 ± 0.1% | 734.0 ± 0.2% | 10.652 | 14.419 | 25.258 | 15.793 | 21.337 |
| hex: canterbury/alice29.txt | 304180 | 15482.5 ± 0.1% | 1473.8 ± 0.5% | 1090.2 ± 0.2% | 499.0 ± 0.7% | 990.1 ± 0.6% | 735.9 ± 0.6% | 10.505 | 14.202 | 31.026 | 15.638 | 21.040 |
| hex: canterbury/asyoulik.txt | 250360 | 15715.0 ± 0.1% | 1481.6 ± 0.4% | 1094.1 ± 0.3% | 496.1 ± 0.6% | 997.5 ± 0.6% | 740.3 ± 0.2% | 10.606 | 14.364 | 31.675 | 15.754 | 21.228 |
| hex: canterbury/cp.html | 49208 | 15638.4 ± 0.0% | 1483.7 ± 0.9% | 1099.5 ± 0.4% | 521.1 ± 2.8% | 1005.2 ± 0.6% | 743.8 ± 0.1% | 10.540 | 14.223 | 30.011 | 15.558 | 21.024 |
| hex: canterbury/fields.c | 22302 | 15459.6 ± 0.0% | 1427.2 ± 1.0% | 1067.2 ± 1.1% | 612.9 ± 4.4% | 986.6 ± 0.1% | 737.2 ± 0.1% | 10.832 | 14.486 | 25.225 | 15.669 | 20.971 |
| hex: canterbury/grammar.lsp | 7444 | 14987.3 ± 0.1% | 1506.9 ± 0.2% | 1094.7 ± 0.5% | 659.3 ± 4.2% | 995.9 ± 0.5% | 726.6 ± 0.1% | 9.946 | 13.691 | 22.733 | 15.050 | 20.627 |
| hex: canterbury/kennedy.xls | 524290 | 15651.0 ± 0.3% | 1475.9 ± 0.2% | 1088.2 ± 0.6% | 652.6 ± 1.4% | 989.2 ± 0.6% | 734.1 ± 0.4% | 10.604 | 14.382 | 23.983 | 15.821 | 21.320 |
| hex: canterbury/lcet10.txt | 524290 | 15646.7 ± 0.1% | 1462.2 ± 0.2% | 1082.1 ± 0.5% | 494.4 ± 2.0% | 986.4 ± 0.4% | 733.9 ± 0.5% | 10.701 | 14.460 | 31.650 | 15.863 | 21.321 |
| hex: canterbury/plrabn12.txt | 524290 | 15686.5 ± 0.2% | 1464.4 ± 0.3% | 1085.3 ± 0.3% | 490.5 ± 1.1% | 989.5 ± 0.4% | 735.6 ± 0.3% | 10.712 | 14.454 | 31.980 | 15.853 | 21.324 |
| hex: canterbury/ptt5 | 524290 | 15629.1 ± 0.2% | 1478.9 ± 0.1% | 1090.8 ± 0.6% | 555.8 ± 1.1% | 991.4 ± 0.6% | 734.3 ± 0.7% | 10.568 | 14.328 | 28.121 | 15.765 | 21.284 |
| hex: canterbury/sum | 76482 | 15652.8 ± 0.0% | 1495.6 ± 0.1% | 1104.9 ± 0.2% | 584.7 ± 2.8% | 998.7 ± 0.0% | 744.3 ± 0.1% | 10.466 | 14.167 | 26.773 | 15.673 | 21.031 |
| hex: canterbury/xargs.1 | 8456 | 15021.5 ± 0.0% | 1493.1 ± 0.3% | 1095.4 ± 0.9% | 640.5 ± 7.1% | 1001.3 ± 0.2% | 727.8 ± 0.9% | 10.060 | 13.713 | 23.453 | 15.002 | 20.640 |
| hex: canterbury-large/E.coli | 524290 | 15616.7 ± 0.3% | 1473.0 ± 0.4% | 1088.4 ± 0.5% | 672.9 ± 0.1% | 993.1 ± 0.7% | 734.7 ± 0.3% | 10.602 | 14.348 | 23.209 | 15.726 | 21.256 |
| hex: canterbury-large/bible.txt | 524290 | 15604.1 ± 0.1% | 1464.1 ± 0.3% | 1085.0 ± 0.6% | 514.9 ± 0.6% | 987.6 ± 0.9% | 733.8 ± 0.2% | 10.658 | 14.381 | 30.304 | 15.800 | 21.265 |
| hex: canterbury-large/world192.txt | 524290 | 15643.8 ± 0.2% | 1466.2 ± 0.3% | 1083.4 ± 0.6% | 501.9 ± 0.6% | 989.8 ± 0.6% | 733.6 ± 0.6% | 10.669 | 14.440 | 31.169 | 15.805 | 21.324 |
| hex: http/html-1kx1024 | 2099200 | 13813.8 ± 0.3% | 1455.2 ± 0.3% | 1062.9 ± 0.6% | 501.8 ± 0.1% | 982.5 ± 0.1% | 692.8 ± 0.1% | 9.492 | 12.997 | 27.529 | 14.059 | 19.939 |
| hex: http/html-16kx64 | 2097280 | 15298.4 ± 0.3% | 1445.0 ± 0.3% | 1075.2 ± 0.3% | 506.9 ± 0.2% | 995.7 ± 0.1% | 734.3 ± 0.2% | 10.587 | 14.228 | 30.182 | 15.365 | 20.835 |
| hex: http/html-1m | 524290 | 15640.1 ± 0.2% | 1468.1 ± 0.1% | 1086.3 ± 0.2% | 500.4 ± 0.1% | 991.5 ± 0.4% | 734.1 ± 0.7% | 10.654 | 14.398 | 31.258 | 15.773 | 21.306 |
| hex: http/json-1kx1024 | 2099200 | 13810.9 ± 0.7% | 1464.4 ± 0.2% | 1067.8 ± 0.3% | 608.6 ± 0.4% | 986.8 ± 0.1% | 693.0 ± 0.1% | 9.431 | 12.934 | 22.692 | 13.996 | 19.929 |
| hex: http/json-16kx64 | 2097280 | 15267.5 ± 0.4% | 1445.4 ± 0.6% | 1075.7 ± 0.4% | 616.5 ± 1.0% | 994.9 ± 0.3% | 735.1 ± 0.1% | 10.563 | 14.193 | 24.766 | 15.346 | 20.770 |
| hex: http/json-1m | 524290 | 15688.0 ± 0.1% | 1473.4 ± 0.2% | 1088.8 ± 0.3% | 634.1 ± 0.9% | 991.2 ± 0.4% | 734.3 ± 0.6% | 10.647 | 14.408 | 24.742 | 15.827 | 21.365 |
| hex: http/js-1kx1024 | 2099200 | 13943.8 ± 0.5% | 1457.6 ± 0.5% | 1063.3 ± 0.6% | 499.2 ± 0.4% | 983.9 ± 0.2% | 693.1 ± 0.3% | 9.566 | 13.113 | 27.931 | 14.172 | 20.118 |
| hex: http/js-16kx64 | 2097280 | 15243.6 ± 0.4% | 1445.1 ± 0.2% | 1074.7 ± 0.4% | 504.2 ± 0.3% | 995.5 ± 0.1% | 735.3 ± 0.2% | 10.548 | 14.184 | 30.233 | 15.312 | 20.732 |
| hex: http/js-1m | 524290 | 15654.7 ± 0.3% | 1464.1 ± 0.3% | 1085.3 ± 0.4% | 510.4 ± 0.5% | 987.4 ± 0.4% | 735.5 ± 0.3% | 10.693 | 14.424 | 30.674 | 15.854 | 21.284 |
| hex: http/css-1kx1024 | 2099200 | 13843.6 ± 0.1% | 1456.1 ± 0.1% | 1062.8 ± 0.2% | 532.1 ± 0.2% | 982.9 ± 0.1% | 692.8 ± 0.3% | 9.507 | 13.026 | 26.015 | 14.085 | 19.982 |
| hex: http/css-16kx64 | 2097280 | 15218.5 ± 0.9% | 1443.1 ± 0.2% | 1074.7 ± 0.2% | 542.0 ± 0.5% | 999.2 ± 0.3% | 735.2 ± 0.3% | 10.546 | 14.161 | 28.077 | 15.231 | 20.701 |
| hex: http/css-1m | 524290 | 15691.9 ± 0.2% | 1467.8 ± 0.3% | 1085.7 ± 0.4% | 527.4 ± 0.7% | 990.9 ± 0.5% | 733.1 ± 0.6% | 10.691 | 14.453 | 29.752 | 15.835 | 21.406 |
| hex: shuffled/dickens-1m | 524290 | 15714.3 ± 0.1% | 1463.2 ± 0.2% | 1084.2 ± 0.3% | 500.5 ± 0.9% | 986.4 ± 0.4% | 735.5 ± 0.5% | 10.739 | 14.494 | 31.398 | 15.931 | 21.367 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.1 ± 0.1% | 929.5 ± 0.6% | 1023.2 ± 0.3% | 300.3 ± 0.3% | 666.8 ± 0.3% | 309.9 ± 1.3% | 1.008 | 0.916 | 3.121 | 1.405 | 3.024 |
| qlog records, JSON text sequence | 1467503 | 784.2 ± 1.0% | 817.9 ± 0.3% | 785.0 ± 0.8% | 243.4 ± 0.7% | 700.5 ± 0.7% | 250.8 ± 0.6% | 0.959 | 0.999 | 3.221 | 1.120 | 3.127 |
| string: silesia/dickens | 172528 | 5050.3 ± 0.7% | 1877.8 ± 0.2% | 2641.5 ± 0.3% | 362.9 ± 1.3% | 2869.9 ± 0.3% | 547.2 ± 1.8% | 2.689 | 1.912 | 13.918 | 1.760 | 9.229 |
| string: silesia/nci | 1075110 | 4310.4 ± 0.3% | 2235.8 ± 0.4% | 2996.3 ± 0.2% | 544.6 ± 1.4% | 2994.7 ± 1.5% | 604.2 ± 2.5% | 1.928 | 1.439 | 7.914 | 1.439 | 7.134 |
| string: silesia/reymont | 1075159 | 2976.7 ± 2.1% | 1824.1 ± 1.8% | 2063.8 ± 0.8% | 375.2 ± 0.7% | 2147.3 ± 0.8% | 532.3 ± 1.5% | 1.632 | 1.442 | 7.933 | 1.386 | 5.593 |
| string: silesia/samba | 97582 | 3501.1 ± 0.2% | 2028.2 ± 0.1% | 2616.3 ± 0.4% | 322.7 ± 0.3% | 1497.6 ± 0.3% | 426.8 ± 1.6% | 1.726 | 1.338 | 10.851 | 2.338 | 8.203 |
| string: silesia/webster | 1098490 | 3672.9 ± 0.5% | 1516.8 ± 0.4% | 2013.2 ± 0.4% | 359.3 ± 0.6% | 2168.2 ± 1.0% | 499.8 ± 1.4% | 2.421 | 1.824 | 10.222 | 1.694 | 7.348 |
| string: silesia/xml | 1090118 | 4800.7 ± 0.2% | 2359.9 ± 0.3% | 2528.7 ± 0.6% | 454.2 ± 1.3% | 2840.2 ± 1.2% | 569.6 ± 1.1% | 2.034 | 1.898 | 10.569 | 1.690 | 8.428 |
| string: canterbury/alice29.txt | 159425 | 4385.4 ± 1.4% | 1599.6 ± 0.3% | 2454.6 ± 0.7% | 342.6 ± 0.8% | 2510.6 ± 0.5% | 506.3 ± 1.0% | 2.742 | 1.787 | 12.800 | 1.747 | 8.663 |
| string: canterbury/asyoulik.txt | 132198 | 3495.5 ± 0.6% | 1457.4 ± 0.1% | 2244.4 ± 0.4% | 334.6 ± 0.7% | 2090.7 ± 0.4% | 461.9 ± 1.6% | 2.399 | 1.557 | 10.445 | 1.672 | 7.568 |
| string: canterbury/lcet10.txt | 441884 | 5132.2 ± 0.2% | 1851.6 ± 0.2% | 2332.8 ± 1.0% | 390.9 ± 0.9% | 2865.3 ± 0.7% | 534.8 ± 0.8% | 2.772 | 2.200 | 13.129 | 1.791 | 9.596 |
| string: canterbury/plrabn12.txt | 503330 | 4140.4 ± 0.3% | 1736.5 ± 0.1% | 2063.3 ± 0.4% | 359.5 ± 0.5% | 2482.5 ± 0.5% | 500.3 ± 1.0% | 2.384 | 2.007 | 11.518 | 1.668 | 8.276 |
| string: canterbury-large/E.coli | 1048578 | 11874.6 ± 1.0% | 3604.5 ± 0.3% | 3258.4 ± 0.3% | 929.6 ± 1.2% | 5960.6 ± 1.0% | 769.0 ± 0.4% | 3.294 | 3.644 | 12.774 | 1.992 | 15.442 |
| string: canterbury-large/bible.txt | 1055886 | 6908.3 ± 0.5% | 2938.1 ± 0.5% | 2836.8 ± 0.8% | 418.5 ± 0.8% | 3750.6 ± 1.3% | 616.9 ± 3.0% | 2.351 | 2.435 | 16.509 | 1.842 | 11.199 |
| string: canterbury-large/world192.txt | 1103121 | 3393.1 ± 0.5% | 1481.5 ± 0.2% | 2013.4 ± 0.4% | 353.2 ± 0.4% | 2122.1 ± 0.9% | 501.9 ± 0.5% | 2.290 | 1.685 | 9.605 | 1.599 | 6.760 |
| string: http/html-1m | 1058582 | 6245.5 ± 1.0% | 2735.9 ± 0.3% | 2706.3 ± 0.4% | 442.8 ± 0.7% | 3491.4 ± 0.6% | 595.7 ± 1.5% | 2.283 | 2.308 | 14.105 | 1.789 | 10.485 |
| string: http/json-1m | 1190272 | 2555.1 ± 0.2% | 876.6 ± 0.1% | 2254.3 ± 0.4% | 391.8 ± 0.6% | 1049.6 ± 5.9% | 444.3 ± 0.6% | 2.915 | 1.133 | 6.522 | 2.434 | 5.750 |
| string: http/js-1m | 1144362 | 2282.5 ± 0.7% | 1027.4 ± 0.1% | 1638.4 ± 0.6% | 321.2 ± 0.5% | 1508.8 ± 1.4% | 420.0 ± 0.9% | 2.222 | 1.393 | 7.107 | 1.513 | 5.434 |
| string: http/css-1m | 1097820 | 2652.2 ± 0.4% | 1676.8 ± 0.2% | 2220.3 ± 0.8% | 404.5 ± 1.4% | 1911.3 ± 1.3% | 490.6 ± 1.1% | 1.582 | 1.195 | 6.556 | 1.388 | 5.406 |
| string: dickens as Cyrillic and CJK | 1883069 | 3073.2 ± 0.2% | 1688.7 ± 0.5% | 892.1 ± 0.7% | 351.4 ± 0.1% | 667.6 ± 0.2% | 157.8 ± 2.4% | 1.820 | 3.445 | 8.745 | 4.603 | 19.471 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.7 ± 0.3% | 980.8 ± 0.2% | 1204.8 ± 0.5% | 213.5 ± 0.2% | 469.6 ± 0.6% | 250.2 ± 3.8% | 1.357 | 1.104 | 6.234 | 2.834 | 5.318 |
| hex: silesia/dickens | 524290 | 11926.7 ± 0.1% | 3616.4 ± 0.1% | 3287.8 ± 0.3% | 505.7 ± 3.0% | 6049.0 ± 1.0% | 781.5 ± 2.5% | 3.298 | 3.628 | 23.585 | 1.972 | 15.262 |
| hex: silesia/mozilla | 524290 | 11928.5 ± 0.6% | 3617.6 ± 0.1% | 3286.3 ± 0.6% | 446.6 ± 2.6% | 5958.5 ± 2.7% | 783.6 ± 0.5% | 3.297 | 3.630 | 26.710 | 2.002 | 15.222 |
| hex: silesia/mr | 524290 | 11965.0 ± 0.2% | 3619.9 ± 0.1% | 3295.2 ± 0.2% | 567.1 ± 0.5% | 6070.9 ± 1.2% | 784.8 ± 0.3% | 3.305 | 3.631 | 21.097 | 1.971 | 15.246 |
| hex: silesia/nci | 524290 | 11980.1 ± 0.3% | 3616.9 ± 0.2% | 3290.2 ± 0.2% | 625.8 ± 1.8% | 6014.7 ± 1.6% | 785.0 ± 0.4% | 3.312 | 3.641 | 19.144 | 1.992 | 15.260 |
| hex: silesia/ooffice | 524290 | 12021.7 ± 0.1% | 3621.9 ± 0.1% | 3288.4 ± 0.2% | 397.7 ± 1.1% | 6044.5 ± 2.1% | 783.9 ± 0.4% | 3.319 | 3.656 | 30.230 | 1.989 | 15.336 |
| hex: silesia/osdb | 524290 | 12016.5 ± 0.1% | 3617.8 ± 0.2% | 3288.8 ± 0.6% | 475.7 ± 2.2% | 6058.1 ± 1.3% | 784.0 ± 0.6% | 3.322 | 3.654 | 25.263 | 1.984 | 15.328 |
| hex: silesia/reymont | 524290 | 12014.1 ± 0.3% | 3618.3 ± 0.3% | 3282.1 ± 0.5% | 510.8 ± 1.6% | 6094.5 ± 0.9% | 784.4 ± 0.6% | 3.320 | 3.660 | 23.520 | 1.971 | 15.316 |
| hex: silesia/samba | 524290 | 12005.2 ± 0.1% | 3617.8 ± 0.2% | 3287.1 ± 0.2% | 400.6 ± 0.9% | 6083.3 ± 0.9% | 785.4 ± 0.6% | 3.318 | 3.652 | 29.968 | 1.973 | 15.285 |
| hex: silesia/sao | 524290 | 12006.5 ± 0.1% | 3618.2 ± 0.2% | 3289.4 ± 0.2% | 337.1 ± 0.7% | 6065.2 ± 1.7% | 783.5 ± 0.3% | 3.318 | 3.650 | 35.618 | 1.980 | 15.325 |
| hex: silesia/webster | 524290 | 11986.7 ± 0.0% | 3616.9 ± 0.3% | 3296.0 ± 0.8% | 456.8 ± 1.5% | 6047.9 ± 0.9% | 781.7 ± 0.3% | 3.314 | 3.637 | 26.241 | 1.982 | 15.334 |
| hex: silesia/x-ray | 524290 | 11997.7 ± 0.2% | 3619.1 ± 0.2% | 3291.6 ± 0.3% | 466.1 ± 1.1% | 6059.5 ± 0.6% | 783.3 ± 0.4% | 3.315 | 3.645 | 25.740 | 1.980 | 15.316 |
| hex: silesia/xml | 524290 | 12010.4 ± 0.0% | 3618.3 ± 0.1% | 3293.1 ± 0.2% | 512.4 ± 1.6% | 6072.6 ± 1.1% | 783.5 ± 0.1% | 3.319 | 3.647 | 23.440 | 1.978 | 15.330 |
| hex: canterbury/alice29.txt | 304180 | 12012.3 ± 0.1% | 3642.9 ± 0.0% | 3322.4 ± 0.3% | 500.3 ± 1.1% | 6054.2 ± 0.7% | 782.9 ± 0.6% | 3.297 | 3.616 | 24.011 | 1.984 | 15.344 |
| hex: canterbury/asyoulik.txt | 250360 | 12010.1 ± 0.1% | 3638.6 ± 0.1% | 3373.9 ± 0.1% | 499.8 ± 1.7% | 6052.8 ± 1.4% | 780.8 ± 0.8% | 3.301 | 3.560 | 24.028 | 1.984 | 15.382 |
| hex: canterbury/cp.html | 49208 | 11930.0 ± 0.0% | 3639.5 ± 0.0% | 3282.6 ± 0.3% | 468.5 ± 1.6% | 6283.9 ± 0.5% | 762.3 ± 3.3% | 3.278 | 3.634 | 25.464 | 1.899 | 15.650 |
| hex: canterbury/fields.c | 22302 | 11786.7 ± 0.0% | 3629.5 ± 0.0% | 3392.6 ± 0.2% | 499.0 ± 0.4% | 6255.7 ± 0.3% | 754.4 ± 1.9% | 3.247 | 3.474 | 23.621 | 1.884 | 15.624 |
| hex: canterbury/grammar.lsp | 7444 | 11277.2 ± 0.1% | 3601.4 ± 0.0% | 3350.6 ± 0.5% | 552.5 ± 2.3% | 6176.8 ± 1.0% | 712.1 ± 2.4% | 3.131 | 3.366 | 20.411 | 1.826 | 15.837 |
| hex: canterbury/kennedy.xls | 524290 | 11995.3 ± 0.1% | 3615.3 ± 0.1% | 3294.4 ± 0.5% | 659.6 ± 1.7% | 5956.4 ± 0.4% | 764.8 ± 3.4% | 3.318 | 3.641 | 18.186 | 2.014 | 15.684 |
| hex: canterbury/lcet10.txt | 524290 | 12011.5 ± 0.1% | 3612.1 ± 0.2% | 3279.7 ± 0.3% | 523.8 ± 0.8% | 6062.7 ± 1.4% | 781.9 ± 0.8% | 3.325 | 3.662 | 22.932 | 1.981 | 15.363 |
| hex: canterbury/plrabn12.txt | 524290 | 11996.6 ± 0.2% | 3611.9 ± 0.3% | 3284.4 ± 0.3% | 506.7 ± 4.1% | 6030.4 ± 0.5% | 783.3 ± 0.1% | 3.321 | 3.653 | 23.677 | 1.989 | 15.316 |
| hex: canterbury/ptt5 | 524290 | 11994.0 ± 0.4% | 3611.2 ± 0.2% | 3294.0 ± 0.2% | 556.1 ± 3.0% | 6022.3 ± 0.9% | 783.3 ± 0.3% | 3.321 | 3.641 | 21.568 | 1.992 | 15.311 |
| hex: canterbury/sum | 76482 | 11918.7 ± 0.0% | 3633.6 ± 0.1% | 3356.9 ± 0.2% | 503.8 ± 2.6% | 6179.8 ± 0.7% | 774.6 ± 1.2% | 3.280 | 3.550 | 23.658 | 1.929 | 15.387 |
| hex: canterbury/xargs.1 | 8456 | 11359.0 ± 0.0% | 3602.3 ± 0.0% | 3355.3 ± 0.1% | 499.7 ± 5.7% | 6157.6 ± 0.5% | 755.2 ± 1.9% | 3.153 | 3.385 | 22.733 | 1.845 | 15.041 |
| hex: canterbury-large/E.coli | 524290 | 11995.4 ± 0.1% | 3616.6 ± 0.3% | 3291.8 ± 0.3% | 688.3 ± 0.3% | 6075.5 ± 0.4% | 783.5 ± 4.4% | 3.317 | 3.644 | 17.428 | 1.974 | 15.310 |
| hex: canterbury-large/bible.txt | 524290 | 12014.8 ± 0.3% | 3615.3 ± 0.1% | 3289.6 ± 0.1% | 528.3 ± 1.7% | 6056.8 ± 1.7% | 783.7 ± 0.2% | 3.323 | 3.652 | 22.743 | 1.984 | 15.331 |
| hex: canterbury-large/world192.txt | 524290 | 12017.9 ± 0.1% | 3615.8 ± 0.4% | 3289.0 ± 0.2% | 493.7 ± 2.4% | 6083.1 ± 1.2% | 782.6 ± 0.3% | 3.324 | 3.654 | 24.341 | 1.976 | 15.357 |
| hex: http/html-1kx1024 | 2099200 | 8692.1 ± 2.3% | 3457.3 ± 0.2% | 2853.1 ± 0.2% | 464.9 ± 0.9% | 5093.6 ± 3.4% | 626.9 ± 15.6% | 2.514 | 3.047 | 18.697 | 1.706 | 13.865 |
| hex: http/html-16kx64 | 2097280 | 11760.1 ± 0.2% | 3607.7 ± 0.6% | 3261.5 ± 1.0% | 466.0 ± 0.5% | 5998.9 ± 0.2% | 756.3 ± 2.2% | 3.260 | 3.606 | 25.238 | 1.960 | 15.549 |
| hex: http/html-1m | 524290 | 11883.6 ± 0.3% | 3612.0 ± 0.3% | 3285.6 ± 0.1% | 491.0 ± 2.1% | 6029.6 ± 0.5% | 779.3 ± 1.5% | 3.290 | 3.617 | 24.204 | 1.971 | 15.250 |
| hex: http/json-1kx1024 | 2099200 | 8680.6 ± 4.4% | 3456.1 ± 0.3% | 2847.7 ± 0.4% | 565.7 ± 2.1% | 5092.0 ± 0.3% | 638.4 ± 3.4% | 2.512 | 3.048 | 15.344 | 1.705 | 13.599 |
| hex: http/json-16kx64 | 2097280 | 11761.9 ± 0.4% | 3609.1 ± 0.2% | 3258.0 ± 0.4% | 572.1 ± 0.6% | 6022.4 ± 0.5% | 750.4 ± 2.3% | 3.259 | 3.610 | 20.561 | 1.953 | 15.673 |
| hex: http/json-1m | 524290 | 11987.2 ± 0.2% | 3615.5 ± 0.3% | 3279.3 ± 0.2% | 588.8 ± 4.4% | 6045.4 ± 1.4% | 776.7 ± 1.1% | 3.315 | 3.655 | 20.359 | 1.983 | 15.433 |
| hex: http/js-1kx1024 | 2099200 | 8705.1 ± 4.3% | 3459.2 ± 0.1% | 2852.4 ± 0.2% | 478.0 ± 0.9% | 5102.8 ± 6.1% | 628.5 ± 20.4% | 2.516 | 3.052 | 18.212 | 1.706 | 13.850 |
| hex: http/js-16kx64 | 2097280 | 11756.5 ± 0.3% | 3609.9 ± 0.0% | 3261.1 ± 0.1% | 476.0 ± 0.6% | 6013.5 ± 0.5% | 754.3 ± 1.9% | 3.257 | 3.605 | 24.699 | 1.955 | 15.587 |
| hex: http/js-1m | 524290 | 12005.5 ± 0.1% | 3611.2 ± 0.3% | 3296.1 ± 0.2% | 503.2 ± 1.3% | 6070.4 ± 1.0% | 780.0 ± 1.8% | 3.324 | 3.642 | 23.858 | 1.978 | 15.391 |
| hex: http/css-1kx1024 | 2099200 | 8656.3 ± 2.3% | 3457.6 ± 0.1% | 2847.4 ± 0.6% | 483.4 ± 1.1% | 5149.2 ± 1.9% | 639.3 ± 2.9% | 2.504 | 3.040 | 17.905 | 1.681 | 13.540 |
| hex: http/css-16kx64 | 2097280 | 11767.7 ± 0.4% | 3611.2 ± 0.1% | 3259.9 ± 0.5% | 494.4 ± 0.6% | 6067.3 ± 1.0% | 746.3 ± 4.0% | 3.259 | 3.610 | 23.802 | 1.940 | 15.767 |
| hex: http/css-1m | 524290 | 12003.1 ± 0.1% | 3611.8 ± 0.2% | 3293.7 ± 0.4% | 495.9 ± 1.7% | 5980.7 ± 0.6% | 781.3 ± 1.5% | 3.323 | 3.644 | 24.203 | 2.007 | 15.362 |
| hex: shuffled/dickens-1m | 524290 | 11997.8 ± 0.1% | 3615.4 ± 0.2% | 3291.7 ± 0.2% | 505.5 ± 2.1% | 6081.4 ± 1.1% | 782.8 ± 0.4% | 3.319 | 3.645 | 23.736 | 1.973 | 15.327 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1011.8 ± 0.3% | 929.5 ± 0.6% | 1023.2 ± 0.3% | 300.3 ± 0.3% | 666.8 ± 0.3% | 309.9 ± 1.3% | 1.089 | 0.989 | 3.369 | 1.518 | 3.265 |
| qlog records, JSON text sequence | 1467503 | 841.2 ± 0.7% | 817.9 ± 0.3% | 785.0 ± 0.8% | 243.4 ± 0.7% | 700.5 ± 0.7% | 250.8 ± 0.6% | 1.028 | 1.071 | 3.455 | 1.201 | 3.354 |
| string: silesia/dickens | 172528 | 5051.8 ± 0.4% | 1877.8 ± 0.2% | 2641.5 ± 0.3% | 362.9 ± 1.3% | 2869.9 ± 0.3% | 547.2 ± 1.8% | 2.690 | 1.912 | 13.922 | 1.760 | 9.232 |
| string: silesia/nci | 1075110 | 4310.8 ± 0.6% | 2235.8 ± 0.4% | 2996.3 ± 0.2% | 544.6 ± 1.4% | 2994.7 ± 1.5% | 604.2 ± 2.5% | 1.928 | 1.439 | 7.915 | 1.439 | 7.134 |
| string: silesia/reymont | 1075159 | 2999.5 ± 1.6% | 1824.1 ± 1.8% | 2063.8 ± 0.8% | 375.2 ± 0.7% | 2147.3 ± 0.8% | 532.3 ± 1.5% | 1.644 | 1.453 | 7.994 | 1.397 | 5.635 |
| string: silesia/samba | 97582 | 3514.4 ± 0.1% | 2028.2 ± 0.1% | 2616.3 ± 0.4% | 322.7 ± 0.3% | 1497.6 ± 0.3% | 426.8 ± 1.6% | 1.733 | 1.343 | 10.892 | 2.347 | 8.234 |
| string: silesia/webster | 1098490 | 3666.1 ± 0.5% | 1516.8 ± 0.4% | 2013.2 ± 0.4% | 359.3 ± 0.6% | 2168.2 ± 1.0% | 499.8 ± 1.4% | 2.417 | 1.821 | 10.203 | 1.691 | 7.335 |
| string: silesia/xml | 1090118 | 4802.5 ± 0.3% | 2359.9 ± 0.3% | 2528.7 ± 0.6% | 454.2 ± 1.3% | 2840.2 ± 1.2% | 569.6 ± 1.1% | 2.035 | 1.899 | 10.573 | 1.691 | 8.431 |
| string: canterbury/alice29.txt | 159425 | 4387.9 ± 1.2% | 1599.6 ± 0.3% | 2454.6 ± 0.7% | 342.6 ± 0.8% | 2510.6 ± 0.5% | 506.3 ± 1.0% | 2.743 | 1.788 | 12.807 | 1.748 | 8.667 |
| string: canterbury/asyoulik.txt | 132198 | 3496.4 ± 0.7% | 1457.4 ± 0.1% | 2244.4 ± 0.4% | 334.6 ± 0.7% | 2090.7 ± 0.4% | 461.9 ± 1.6% | 2.399 | 1.558 | 10.448 | 1.672 | 7.570 |
| string: canterbury/lcet10.txt | 441884 | 5142.7 ± 0.3% | 1851.6 ± 0.2% | 2332.8 ± 1.0% | 390.9 ± 0.9% | 2865.3 ± 0.7% | 534.8 ± 0.8% | 2.777 | 2.204 | 13.156 | 1.795 | 9.616 |
| string: canterbury/plrabn12.txt | 503330 | 4144.8 ± 0.1% | 1736.5 ± 0.1% | 2063.3 ± 0.4% | 359.5 ± 0.5% | 2482.5 ± 0.5% | 500.3 ± 1.0% | 2.387 | 2.009 | 11.530 | 1.670 | 8.285 |
| string: canterbury-large/E.coli | 1048578 | 11916.3 ± 0.5% | 3604.5 ± 0.3% | 3258.4 ± 0.3% | 929.6 ± 1.2% | 5960.6 ± 1.0% | 769.0 ± 0.4% | 3.306 | 3.657 | 12.819 | 1.999 | 15.496 |
| string: canterbury-large/bible.txt | 1055886 | 6937.0 ± 0.5% | 2938.1 ± 0.5% | 2836.8 ± 0.8% | 418.5 ± 0.8% | 3750.6 ± 1.3% | 616.9 ± 3.0% | 2.361 | 2.445 | 16.578 | 1.850 | 11.246 |
| string: canterbury-large/world192.txt | 1103121 | 3394.5 ± 0.3% | 1481.5 ± 0.2% | 2013.4 ± 0.4% | 353.2 ± 0.4% | 2122.1 ± 0.9% | 501.9 ± 0.5% | 2.291 | 1.686 | 9.609 | 1.600 | 6.763 |
| string: http/html-1m | 1058582 | 6263.1 ± 1.0% | 2735.9 ± 0.3% | 2706.3 ± 0.4% | 442.8 ± 0.7% | 3491.4 ± 0.6% | 595.7 ± 1.5% | 2.289 | 2.314 | 14.145 | 1.794 | 10.514 |
| string: http/json-1m | 1190272 | 2558.2 ± 0.4% | 876.6 ± 0.1% | 2254.3 ± 0.4% | 391.8 ± 0.6% | 1049.6 ± 5.9% | 444.3 ± 0.6% | 2.918 | 1.135 | 6.530 | 2.437 | 5.757 |
| string: http/js-1m | 1144362 | 2287.6 ± 0.2% | 1027.4 ± 0.1% | 1638.4 ± 0.6% | 321.2 ± 0.5% | 1508.8 ± 1.4% | 420.0 ± 0.9% | 2.227 | 1.396 | 7.123 | 1.516 | 5.446 |
| string: http/css-1m | 1097820 | 2656.9 ± 0.3% | 1676.8 ± 0.2% | 2220.3 ± 0.8% | 404.5 ± 1.4% | 1911.3 ± 1.3% | 490.6 ± 1.1% | 1.585 | 1.197 | 6.568 | 1.390 | 5.416 |
| string: dickens as Cyrillic and CJK | 1883069 | 3076.1 ± 0.5% | 1688.7 ± 0.5% | 892.1 ± 0.7% | 351.4 ± 0.1% | 667.6 ± 0.2% | 157.8 ± 2.4% | 1.822 | 3.448 | 8.753 | 4.608 | 19.489 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1331.3 ± 0.3% | 980.8 ± 0.2% | 1204.8 ± 0.5% | 213.5 ± 0.2% | 469.6 ± 0.6% | 250.2 ± 3.8% | 1.357 | 1.105 | 6.237 | 2.835 | 5.320 |
| hex: silesia/dickens | 524290 | 11987.2 ± 0.2% | 3616.4 ± 0.1% | 3287.8 ± 0.3% | 505.7 ± 3.0% | 6049.0 ± 1.0% | 781.5 ± 2.5% | 3.315 | 3.646 | 23.705 | 1.982 | 15.339 |
| hex: silesia/mozilla | 524290 | 11924.8 ± 0.6% | 3617.6 ± 0.1% | 3286.3 ± 0.6% | 446.6 ± 2.6% | 5958.5 ± 2.7% | 783.6 ± 0.5% | 3.296 | 3.629 | 26.702 | 2.001 | 15.218 |
| hex: silesia/mr | 524290 | 11966.1 ± 0.2% | 3619.9 ± 0.1% | 3295.2 ± 0.2% | 567.1 ± 0.5% | 6070.9 ± 1.2% | 784.8 ± 0.3% | 3.306 | 3.631 | 21.099 | 1.971 | 15.248 |
| hex: silesia/nci | 524290 | 11983.4 ± 0.2% | 3616.9 ± 0.2% | 3290.2 ± 0.2% | 625.8 ± 1.8% | 6014.7 ± 1.6% | 785.0 ± 0.4% | 3.313 | 3.642 | 19.150 | 1.992 | 15.264 |
| hex: silesia/ooffice | 524290 | 12025.5 ± 0.1% | 3621.9 ± 0.1% | 3288.4 ± 0.2% | 397.7 ± 1.1% | 6044.5 ± 2.1% | 783.9 ± 0.4% | 3.320 | 3.657 | 30.240 | 1.989 | 15.340 |
| hex: silesia/osdb | 524290 | 12017.5 ± 0.1% | 3617.8 ± 0.2% | 3288.8 ± 0.6% | 475.7 ± 2.2% | 6058.1 ± 1.3% | 784.0 ± 0.6% | 3.322 | 3.654 | 25.265 | 1.984 | 15.329 |
| hex: silesia/reymont | 524290 | 12016.4 ± 0.1% | 3618.3 ± 0.3% | 3282.1 ± 0.5% | 510.8 ± 1.6% | 6094.5 ± 0.9% | 784.4 ± 0.6% | 3.321 | 3.661 | 23.524 | 1.972 | 15.318 |
| hex: silesia/samba | 524290 | 11966.7 ± 0.1% | 3617.8 ± 0.2% | 3287.1 ± 0.2% | 400.6 ± 0.9% | 6083.3 ± 0.9% | 785.4 ± 0.6% | 3.308 | 3.640 | 29.872 | 1.967 | 15.236 |
| hex: silesia/sao | 524290 | 12004.6 ± 0.1% | 3618.2 ± 0.2% | 3289.4 ± 0.2% | 337.1 ± 0.7% | 6065.2 ± 1.7% | 783.5 ± 0.3% | 3.318 | 3.649 | 35.612 | 1.979 | 15.322 |
| hex: silesia/webster | 524290 | 11992.3 ± 0.1% | 3616.9 ± 0.3% | 3296.0 ± 0.8% | 456.8 ± 1.5% | 6047.9 ± 0.9% | 781.7 ± 0.3% | 3.316 | 3.638 | 26.253 | 1.983 | 15.341 |
| hex: silesia/x-ray | 524290 | 12002.6 ± 0.1% | 3619.1 ± 0.2% | 3291.6 ± 0.3% | 466.1 ± 1.1% | 6059.5 ± 0.6% | 783.3 ± 0.4% | 3.316 | 3.646 | 25.751 | 1.981 | 15.322 |
| hex: silesia/xml | 524290 | 12009.6 ± 0.1% | 3618.3 ± 0.1% | 3293.1 ± 0.2% | 512.4 ± 1.6% | 6072.6 ± 1.1% | 783.5 ± 0.1% | 3.319 | 3.647 | 23.438 | 1.978 | 15.329 |
| hex: canterbury/alice29.txt | 304180 | 12012.8 ± 0.1% | 3642.9 ± 0.0% | 3322.4 ± 0.3% | 500.3 ± 1.1% | 6054.2 ± 0.7% | 782.9 ± 0.6% | 3.298 | 3.616 | 24.012 | 1.984 | 15.344 |
| hex: canterbury/asyoulik.txt | 250360 | 12008.3 ± 0.0% | 3638.6 ± 0.1% | 3373.9 ± 0.1% | 499.8 ± 1.7% | 6052.8 ± 1.4% | 780.8 ± 0.8% | 3.300 | 3.559 | 24.025 | 1.984 | 15.380 |
| hex: canterbury/cp.html | 49208 | 11928.9 ± 0.0% | 3639.5 ± 0.0% | 3282.6 ± 0.3% | 468.5 ± 1.6% | 6283.9 ± 0.5% | 762.3 ± 3.3% | 3.278 | 3.634 | 25.462 | 1.898 | 15.648 |
| hex: canterbury/fields.c | 22302 | 11785.8 ± 0.0% | 3629.5 ± 0.0% | 3392.6 ± 0.2% | 499.0 ± 0.4% | 6255.7 ± 0.3% | 754.4 ± 1.9% | 3.247 | 3.474 | 23.619 | 1.884 | 15.623 |
| hex: canterbury/grammar.lsp | 7444 | 11333.5 ± 0.0% | 3601.4 ± 0.0% | 3350.6 ± 0.5% | 552.5 ± 2.3% | 6176.8 ± 1.0% | 712.1 ± 2.4% | 3.147 | 3.383 | 20.513 | 1.835 | 15.916 |
| hex: canterbury/kennedy.xls | 524290 | 11998.7 ± 0.1% | 3615.3 ± 0.1% | 3294.4 ± 0.5% | 659.6 ± 1.7% | 5956.4 ± 0.4% | 764.8 ± 3.4% | 3.319 | 3.642 | 18.191 | 2.014 | 15.689 |
| hex: canterbury/lcet10.txt | 524290 | 12016.6 ± 0.1% | 3612.1 ± 0.2% | 3279.7 ± 0.3% | 523.8 ± 0.8% | 6062.7 ± 1.4% | 781.9 ± 0.8% | 3.327 | 3.664 | 22.942 | 1.982 | 15.369 |
| hex: canterbury/plrabn12.txt | 524290 | 12000.0 ± 0.2% | 3611.9 ± 0.3% | 3284.4 ± 0.3% | 506.7 ± 4.1% | 6030.4 ± 0.5% | 783.3 ± 0.1% | 3.322 | 3.654 | 23.683 | 1.990 | 15.320 |
| hex: canterbury/ptt5 | 524290 | 11992.4 ± 0.1% | 3611.2 ± 0.2% | 3294.0 ± 0.2% | 556.1 ± 3.0% | 6022.3 ± 0.9% | 783.3 ± 0.3% | 3.321 | 3.641 | 21.565 | 1.991 | 15.309 |
| hex: canterbury/sum | 76482 | 11915.3 ± 0.1% | 3633.6 ± 0.1% | 3356.9 ± 0.2% | 503.8 ± 2.6% | 6179.8 ± 0.7% | 774.6 ± 1.2% | 3.279 | 3.549 | 23.651 | 1.928 | 15.382 |
| hex: canterbury/xargs.1 | 8456 | 11351.7 ± 0.0% | 3602.3 ± 0.0% | 3355.3 ± 0.1% | 499.7 ± 5.7% | 6157.6 ± 0.5% | 755.2 ± 1.9% | 3.151 | 3.383 | 22.719 | 1.844 | 15.032 |
| hex: canterbury-large/E.coli | 524290 | 12006.0 ± 0.2% | 3616.6 ± 0.3% | 3291.8 ± 0.3% | 688.3 ± 0.3% | 6075.5 ± 0.4% | 783.5 ± 4.4% | 3.320 | 3.647 | 17.444 | 1.976 | 15.324 |
| hex: canterbury-large/bible.txt | 524290 | 12016.6 ± 0.0% | 3615.3 ± 0.1% | 3289.6 ± 0.1% | 528.3 ± 1.7% | 6056.8 ± 1.7% | 783.7 ± 0.2% | 3.324 | 3.653 | 22.746 | 1.984 | 15.334 |
| hex: canterbury-large/world192.txt | 524290 | 12022.4 ± 0.1% | 3615.8 ± 0.4% | 3289.0 ± 0.2% | 493.7 ± 2.4% | 6083.1 ± 1.2% | 782.6 ± 0.3% | 3.325 | 3.655 | 24.350 | 1.976 | 15.363 |
| hex: http/html-1kx1024 | 2099200 | 8752.5 ± 2.6% | 3457.3 ± 0.2% | 2853.1 ± 0.2% | 464.9 ± 0.9% | 5093.6 ± 3.4% | 626.9 ± 15.6% | 2.532 | 3.068 | 18.826 | 1.718 | 13.961 |
| hex: http/html-16kx64 | 2097280 | 11768.7 ± 0.6% | 3607.7 ± 0.6% | 3261.5 ± 1.0% | 466.0 ± 0.5% | 5998.9 ± 0.2% | 756.3 ± 2.2% | 3.262 | 3.608 | 25.257 | 1.962 | 15.560 |
| hex: http/html-1m | 524290 | 11968.4 ± 0.2% | 3612.0 ± 0.3% | 3285.6 ± 0.1% | 491.0 ± 2.1% | 6029.6 ± 0.5% | 779.3 ± 1.5% | 3.314 | 3.643 | 24.377 | 1.985 | 15.358 |
| hex: http/json-1kx1024 | 2099200 | 8749.4 ± 5.0% | 3456.1 ± 0.3% | 2847.7 ± 0.4% | 565.7 ± 2.1% | 5092.0 ± 0.3% | 638.4 ± 3.4% | 2.532 | 3.072 | 15.465 | 1.718 | 13.706 |
| hex: http/json-16kx64 | 2097280 | 11763.8 ± 0.5% | 3609.1 ± 0.2% | 3258.0 ± 0.4% | 572.1 ± 0.6% | 6022.4 ± 0.5% | 750.4 ± 2.3% | 3.259 | 3.611 | 20.564 | 1.953 | 15.676 |
| hex: http/json-1m | 524290 | 11992.4 ± 0.1% | 3615.5 ± 0.3% | 3279.3 ± 0.2% | 588.8 ± 4.4% | 6045.4 ± 1.4% | 776.7 ± 1.1% | 3.317 | 3.657 | 20.367 | 1.984 | 15.440 |
| hex: http/js-1kx1024 | 2099200 | 8784.9 ± 4.7% | 3459.2 ± 0.1% | 2852.4 ± 0.2% | 478.0 ± 0.9% | 5102.8 ± 6.1% | 628.5 ± 20.4% | 2.540 | 3.080 | 18.379 | 1.722 | 13.977 |
| hex: http/js-16kx64 | 2097280 | 11768.2 ± 0.3% | 3609.9 ± 0.0% | 3261.1 ± 0.1% | 476.0 ± 0.6% | 6013.5 ± 0.5% | 754.3 ± 1.9% | 3.260 | 3.609 | 24.723 | 1.957 | 15.602 |
| hex: http/js-1m | 524290 | 12013.0 ± 0.1% | 3611.2 ± 0.3% | 3296.1 ± 0.2% | 503.2 ± 1.3% | 6070.4 ± 1.0% | 780.0 ± 1.8% | 3.327 | 3.645 | 23.873 | 1.979 | 15.401 |
| hex: http/css-1kx1024 | 2099200 | 8793.7 ± 2.7% | 3457.6 ± 0.1% | 2847.4 ± 0.6% | 483.4 ± 1.1% | 5149.2 ± 1.9% | 639.3 ± 2.9% | 2.543 | 3.088 | 18.189 | 1.708 | 13.755 |
| hex: http/css-16kx64 | 2097280 | 11780.5 ± 0.2% | 3611.2 ± 0.1% | 3259.9 ± 0.5% | 494.4 ± 0.6% | 6067.3 ± 1.0% | 746.3 ± 4.0% | 3.262 | 3.614 | 23.827 | 1.942 | 15.784 |
| hex: http/css-1m | 524290 | 11999.9 ± 0.1% | 3611.8 ± 0.2% | 3293.7 ± 0.4% | 495.9 ± 1.7% | 5980.7 ± 0.6% | 781.3 ± 1.5% | 3.322 | 3.643 | 24.197 | 2.006 | 15.358 |
| hex: shuffled/dickens-1m | 524290 | 11993.6 ± 0.2% | 3615.4 ± 0.2% | 3291.7 ± 0.2% | 505.5 ± 2.1% | 6081.4 ± 1.1% | 782.8 ± 0.4% | 3.317 | 3.644 | 23.728 | 1.972 | 15.322 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1359.6 ± 0.3% | 1253.2 ± 0.2% | 1040.6 ± 0.4% | 409.4 ± 0.1% | 449.1 ± 0.2% | 416.1 ± 0.2% | 1.085 | 1.306 | 3.321 | 3.027 | 3.267 |
| qlog records, JSON text sequence | 1467503 | 1053.2 ± 0.1% | 1064.3 ± 0.2% | 785.3 ± 0.4% | 378.1 ± 0.8% | 468.4 ± 1.2% | 279.1 ± 0.4% | 0.990 | 1.341 | 2.786 | 2.249 | 3.773 |
| string: silesia/dickens | 172528 | 6917.2 ± 0.5% | 2812.3 ± 0.4% | 2938.7 ± 1.1% | 429.8 ± 0.8% | 1565.3 ± 0.2% | 1008.3 ± 0.1% | 2.460 | 2.354 | 16.093 | 4.419 | 6.860 |
| string: silesia/nci | 1075110 | 7326.5 ± 0.5% | 3413.5 ± 0.6% | 3099.9 ± 0.6% | 822.0 ± 2.2% | 1826.1 ± 0.4% | 1108.7 ± 0.2% | 2.146 | 2.363 | 8.913 | 4.012 | 6.608 |
| string: silesia/reymont | 1075159 | 3355.3 ± 0.9% | 1992.8 ± 1.9% | 2062.1 ± 0.2% | 449.5 ± 0.5% | 1491.5 ± 0.5% | 948.8 ± 0.5% | 1.684 | 1.627 | 7.465 | 2.250 | 3.536 |
| string: silesia/samba | 97582 | 4212.2 ± 0.6% | 2104.3 ± 0.1% | 3450.5 ± 0.5% | 353.5 ± 0.6% | 1408.0 ± 0.4% | 1054.9 ± 0.2% | 2.002 | 1.221 | 11.914 | 2.992 | 3.993 |
| string: silesia/webster | 1098490 | 4071.3 ± 0.4% | 1879.8 ± 0.1% | 2056.1 ± 0.5% | 440.8 ± 0.6% | 1372.0 ± 0.2% | 646.8 ± 0.5% | 2.166 | 1.980 | 9.235 | 2.967 | 6.295 |
| string: silesia/xml | 1090118 | 6142.3 ± 0.5% | 2853.9 ± 0.2% | 2650.0 ± 0.5% | 609.8 ± 0.7% | 1733.0 ± 0.1% | 920.7 ± 0.3% | 2.152 | 2.318 | 10.072 | 3.544 | 6.672 |
| string: canterbury/alice29.txt | 159425 | 6446.3 ± 0.5% | 2193.2 ± 0.3% | 2759.8 ± 1.3% | 408.1 ± 0.4% | 1436.8 ± 0.3% | 953.4 ± 0.1% | 2.939 | 2.336 | 15.797 | 4.487 | 6.761 |
| string: canterbury/asyoulik.txt | 132198 | 5655.0 ± 1.4% | 1711.4 ± 0.3% | 2375.8 ± 1.6% | 402.8 ± 0.9% | 1309.6 ± 0.3% | 885.2 ± 0.2% | 3.304 | 2.380 | 14.038 | 4.318 | 6.389 |
| string: canterbury/lcet10.txt | 441884 | 6268.0 ± 0.4% | 2565.7 ± 0.5% | 2476.3 ± 1.5% | 468.5 ± 0.9% | 1524.5 ± 0.2% | 983.1 ± 0.5% | 2.443 | 2.531 | 13.380 | 4.112 | 6.376 |
| string: canterbury/plrabn12.txt | 503330 | 5723.3 ± 0.3% | 2064.6 ± 0.2% | 2068.9 ± 0.5% | 424.4 ± 0.2% | 1361.5 ± 0.3% | 929.2 ± 0.7% | 2.772 | 2.766 | 13.485 | 4.204 | 6.159 |
| string: canterbury-large/E.coli | 1048578 | 19292.1 ± 0.3% | 9746.9 ± 1.6% | 3775.1 ± 0.5% | 1474.9 ± 0.3% | 2354.0 ± 0.6% | 1191.6 ± 0.3% | 1.979 | 5.110 | 13.081 | 8.195 | 16.190 |
| string: canterbury-large/bible.txt | 1055886 | 6797.9 ± 0.3% | 4127.3 ± 0.8% | 3040.8 ± 1.5% | 503.7 ± 1.3% | 1979.2 ± 0.3% | 1122.9 ± 0.4% | 1.647 | 2.236 | 13.497 | 3.435 | 6.054 |
| string: canterbury-large/world192.txt | 1103121 | 4059.1 ± 0.3% | 1655.2 ± 0.4% | 2004.2 ± 0.6% | 449.6 ± 0.4% | 1345.9 ± 0.3% | 909.3 ± 0.2% | 2.452 | 2.025 | 9.028 | 3.016 | 4.464 |
| string: http/html-1m | 1058582 | 6768.7 ± 0.7% | 3946.9 ± 0.4% | 3041.3 ± 0.3% | 500.1 ± 0.9% | 1916.5 ± 0.9% | 805.4 ± 0.4% | 1.715 | 2.226 | 13.535 | 3.532 | 8.404 |
| string: http/json-1m | 1190272 | 3166.6 ± 0.2% | 1351.7 ± 0.2% | 1554.9 ± 0.7% | 443.9 ± 0.3% | 1036.1 ± 0.2% | 765.9 ± 0.5% | 2.343 | 2.036 | 7.134 | 3.056 | 4.135 |
| string: http/js-1m | 1144362 | 2767.8 ± 0.7% | 1180.7 ± 0.3% | 1627.8 ± 0.2% | 369.1 ± 0.3% | 1085.0 ± 0.1% | 758.9 ± 0.2% | 2.344 | 1.700 | 7.498 | 2.551 | 3.647 |
| string: http/css-1m | 1097820 | 4008.6 ± 1.0% | 1493.4 ± 0.3% | 2143.0 ± 0.8% | 494.9 ± 0.4% | 1355.8 ± 0.3% | 893.5 ± 0.3% | 2.684 | 1.871 | 8.100 | 2.957 | 4.486 |
| string: dickens as Cyrillic and CJK | 1883069 | 3075.3 ± 0.5% | 2330.8 ± 0.7% | 514.4 ± 1.9% | 307.8 ± 1.2% | 560.3 ± 0.6% | 335.9 ± 0.1% | 1.319 | 5.978 | 9.990 | 5.488 | 9.155 |
| hex: silesia/dickens | 524290 | 15674.5 ± 0.2% | 1463.9 ± 0.2% | 1085.2 ± 0.5% | 500.0 ± 1.7% | 987.8 ± 0.5% | 733.5 ± 0.3% | 10.707 | 14.444 | 31.349 | 15.867 | 21.368 |
| hex: silesia/mozilla | 524290 | 15675.5 ± 0.1% | 1474.4 ± 0.4% | 1088.8 ± 0.4% | 442.4 ± 0.8% | 995.0 ± 0.4% | 735.3 ± 0.3% | 10.632 | 14.398 | 35.431 | 15.755 | 21.319 |
| hex: silesia/mr | 524290 | 15695.5 ± 0.1% | 1483.6 ± 0.3% | 1095.4 ± 0.3% | 549.0 ± 3.7% | 998.0 ± 0.5% | 735.3 ± 0.2% | 10.579 | 14.328 | 28.587 | 15.727 | 21.345 |
| hex: silesia/nci | 524290 | 15663.3 ± 0.2% | 1471.2 ± 0.6% | 1088.4 ± 0.3% | 638.9 ± 2.7% | 991.4 ± 0.9% | 734.7 ± 0.2% | 10.647 | 14.390 | 24.515 | 15.799 | 21.321 |
| hex: silesia/ooffice | 524290 | 15586.8 ± 0.2% | 1464.3 ± 0.3% | 1086.3 ± 0.2% | 388.9 ± 0.3% | 990.6 ± 0.4% | 734.7 ± 0.1% | 10.644 | 14.348 | 40.080 | 15.734 | 21.215 |
| hex: silesia/osdb | 524290 | 15633.3 ± 0.3% | 1472.1 ± 0.3% | 1085.1 ± 0.2% | 467.7 ± 0.9% | 990.2 ± 0.2% | 734.8 ± 0.3% | 10.620 | 14.408 | 33.429 | 15.788 | 21.275 |
| hex: silesia/reymont | 524290 | 15682.3 ± 0.1% | 1461.9 ± 0.7% | 1087.5 ± 0.5% | 506.0 ± 1.1% | 989.3 ± 1.2% | 734.4 ± 0.7% | 10.727 | 14.420 | 30.991 | 15.851 | 21.353 |
| hex: silesia/samba | 524290 | 15660.0 ± 0.2% | 1467.6 ± 0.3% | 1084.9 ± 0.1% | 403.2 ± 0.1% | 990.3 ± 0.4% | 733.8 ± 1.2% | 10.671 | 14.435 | 38.838 | 15.813 | 21.341 |
| hex: silesia/sao | 524290 | 15631.5 ± 0.0% | 1466.3 ± 0.2% | 1084.8 ± 0.4% | 332.5 ± 0.7% | 989.5 ± 0.4% | 734.0 ± 0.3% | 10.661 | 14.409 | 47.012 | 15.797 | 21.296 |
| hex: silesia/webster | 524290 | 15667.0 ± 0.1% | 1466.1 ± 0.2% | 1086.2 ± 0.3% | 475.7 ± 0.2% | 992.6 ± 0.1% | 735.7 ± 0.5% | 10.686 | 14.423 | 32.936 | 15.784 | 21.297 |
| hex: silesia/x-ray | 524290 | 15463.2 ± 0.3% | 1475.2 ± 0.3% | 1089.3 ± 0.4% | 446.8 ± 2.1% | 994.4 ± 0.4% | 733.4 ± 0.3% | 10.482 | 14.195 | 34.608 | 15.550 | 21.085 |
| hex: silesia/xml | 524290 | 15665.8 ± 0.2% | 1470.3 ± 0.3% | 1086.2 ± 0.3% | 620.1 ± 0.7% | 991.7 ± 0.1% | 734.0 ± 0.2% | 10.655 | 14.423 | 25.264 | 15.797 | 21.342 |
| hex: canterbury/alice29.txt | 304180 | 15494.4 ± 0.1% | 1473.8 ± 0.5% | 1090.2 ± 0.2% | 499.0 ± 0.7% | 990.1 ± 0.6% | 735.9 ± 0.6% | 10.513 | 14.213 | 31.050 | 15.650 | 21.056 |
| hex: canterbury/asyoulik.txt | 250360 | 15718.3 ± 0.1% | 1481.6 ± 0.4% | 1094.1 ± 0.3% | 496.1 ± 0.6% | 997.5 ± 0.6% | 740.3 ± 0.2% | 10.609 | 14.367 | 31.682 | 15.757 | 21.233 |
| hex: canterbury/cp.html | 49208 | 15667.5 ± 0.1% | 1483.7 ± 0.9% | 1099.5 ± 0.4% | 521.1 ± 2.8% | 1005.2 ± 0.6% | 743.8 ± 0.1% | 10.560 | 14.250 | 30.067 | 15.587 | 21.063 |
| hex: canterbury/fields.c | 22302 | 15523.3 ± 0.0% | 1427.2 ± 1.0% | 1067.2 ± 1.1% | 612.9 ± 4.4% | 986.6 ± 0.1% | 737.2 ± 0.1% | 10.877 | 14.545 | 25.328 | 15.733 | 21.057 |
| hex: canterbury/grammar.lsp | 7444 | 15163.7 ± 0.1% | 1506.9 ± 0.2% | 1094.7 ± 0.5% | 659.3 ± 4.2% | 995.9 ± 0.5% | 726.6 ± 0.1% | 10.063 | 13.852 | 23.001 | 15.227 | 20.870 |
| hex: canterbury/kennedy.xls | 524290 | 15654.0 ± 0.2% | 1475.9 ± 0.2% | 1088.2 ± 0.6% | 652.6 ± 1.4% | 989.2 ± 0.6% | 734.1 ± 0.4% | 10.606 | 14.385 | 23.988 | 15.824 | 21.324 |
| hex: canterbury/lcet10.txt | 524290 | 15640.4 ± 0.1% | 1462.2 ± 0.2% | 1082.1 ± 0.5% | 494.4 ± 2.0% | 986.4 ± 0.4% | 733.9 ± 0.5% | 10.696 | 14.454 | 31.637 | 15.857 | 21.312 |
| hex: canterbury/plrabn12.txt | 524290 | 15678.4 ± 0.1% | 1464.4 ± 0.3% | 1085.3 ± 0.3% | 490.5 ± 1.1% | 989.5 ± 0.4% | 735.6 ± 0.3% | 10.706 | 14.446 | 31.963 | 15.844 | 21.312 |
| hex: canterbury/ptt5 | 524290 | 15642.0 ± 0.3% | 1478.9 ± 0.1% | 1090.8 ± 0.6% | 555.8 ± 1.1% | 991.4 ± 0.6% | 734.3 ± 0.7% | 10.576 | 14.340 | 28.145 | 15.778 | 21.301 |
| hex: canterbury/sum | 76482 | 15680.7 ± 0.0% | 1495.6 ± 0.1% | 1104.9 ± 0.2% | 584.7 ± 2.8% | 998.7 ± 0.0% | 744.3 ± 0.1% | 10.484 | 14.192 | 26.821 | 15.701 | 21.068 |
| hex: canterbury/xargs.1 | 8456 | 15209.8 ± 0.1% | 1493.1 ± 0.3% | 1095.4 ± 0.9% | 640.5 ± 7.1% | 1001.3 ± 0.2% | 727.8 ± 0.9% | 10.186 | 13.885 | 23.747 | 15.190 | 20.898 |
| hex: canterbury-large/E.coli | 524290 | 15636.0 ± 0.2% | 1473.0 ± 0.4% | 1088.4 ± 0.5% | 672.9 ± 0.1% | 993.1 ± 0.7% | 734.7 ± 0.3% | 10.615 | 14.365 | 23.237 | 15.745 | 21.282 |
| hex: canterbury-large/bible.txt | 524290 | 15602.1 ± 0.2% | 1464.1 ± 0.3% | 1085.0 ± 0.6% | 514.9 ± 0.6% | 987.6 ± 0.9% | 733.8 ± 0.2% | 10.657 | 14.379 | 30.300 | 15.798 | 21.262 |
| hex: canterbury-large/world192.txt | 524290 | 15676.0 ± 0.2% | 1466.2 ± 0.3% | 1083.4 ± 0.6% | 501.9 ± 0.6% | 989.8 ± 0.6% | 733.6 ± 0.6% | 10.691 | 14.469 | 31.233 | 15.837 | 21.367 |
| hex: http/html-1kx1024 | 2099200 | 14153.0 ± 0.4% | 1455.2 ± 0.3% | 1062.9 ± 0.6% | 501.8 ± 0.1% | 982.5 ± 0.1% | 692.8 ± 0.1% | 9.726 | 13.316 | 28.204 | 14.405 | 20.429 |
| hex: http/html-16kx64 | 2097280 | 15374.6 ± 0.2% | 1445.0 ± 0.3% | 1075.2 ± 0.3% | 506.9 ± 0.2% | 995.7 ± 0.1% | 734.3 ± 0.2% | 10.640 | 14.299 | 30.333 | 15.441 | 20.939 |
| hex: http/html-1m | 524290 | 15658.8 ± 0.4% | 1468.1 ± 0.1% | 1086.3 ± 0.2% | 500.4 ± 0.1% | 991.5 ± 0.4% | 734.1 ± 0.7% | 10.666 | 14.415 | 31.295 | 15.792 | 21.331 |
| hex: http/json-1kx1024 | 2099200 | 14224.4 ± 0.4% | 1464.4 ± 0.2% | 1067.8 ± 0.3% | 608.6 ± 0.4% | 986.8 ± 0.1% | 693.0 ± 0.1% | 9.714 | 13.321 | 23.371 | 14.415 | 20.526 |
| hex: http/json-16kx64 | 2097280 | 15379.1 ± 0.1% | 1445.4 ± 0.6% | 1075.7 ± 0.4% | 616.5 ± 1.0% | 994.9 ± 0.3% | 735.1 ± 0.1% | 10.640 | 14.297 | 24.947 | 15.458 | 20.921 |
| hex: http/json-1m | 524290 | 15683.5 ± 0.2% | 1473.4 ± 0.2% | 1088.8 ± 0.3% | 634.1 ± 0.9% | 991.2 ± 0.4% | 734.3 ± 0.6% | 10.644 | 14.404 | 24.735 | 15.822 | 21.359 |
| hex: http/js-1kx1024 | 2099200 | 14222.1 ± 0.3% | 1457.6 ± 0.5% | 1063.3 ± 0.6% | 499.2 ± 0.4% | 983.9 ± 0.2% | 693.1 ± 0.3% | 9.757 | 13.375 | 28.489 | 14.455 | 20.519 |
| hex: http/js-16kx64 | 2097280 | 15359.6 ± 0.8% | 1445.1 ± 0.2% | 1074.7 ± 0.4% | 504.2 ± 0.3% | 995.5 ± 0.1% | 735.3 ± 0.2% | 10.628 | 14.292 | 30.463 | 15.429 | 20.890 |
| hex: http/js-1m | 524290 | 15678.3 ± 0.3% | 1464.1 ± 0.3% | 1085.3 ± 0.4% | 510.4 ± 0.5% | 987.4 ± 0.4% | 735.5 ± 0.3% | 10.709 | 14.446 | 30.720 | 15.878 | 21.316 |
| hex: http/css-1kx1024 | 2099200 | 14147.0 ± 0.7% | 1456.1 ± 0.1% | 1062.8 ± 0.2% | 532.1 ± 0.2% | 982.9 ± 0.1% | 692.8 ± 0.3% | 9.716 | 13.312 | 26.585 | 14.393 | 20.420 |
| hex: http/css-16kx64 | 2097280 | 15316.0 ± 0.3% | 1443.1 ± 0.2% | 1074.7 ± 0.2% | 542.0 ± 0.5% | 999.2 ± 0.3% | 735.2 ± 0.3% | 10.614 | 14.252 | 28.257 | 15.328 | 20.833 |
| hex: http/css-1m | 524290 | 15714.5 ± 0.2% | 1467.8 ± 0.3% | 1085.7 ± 0.4% | 527.4 ± 0.7% | 990.9 ± 0.5% | 733.1 ± 0.6% | 10.706 | 14.474 | 29.795 | 15.858 | 21.437 |
| hex: shuffled/dickens-1m | 524290 | 15704.4 ± 0.1% | 1463.2 ± 0.2% | 1084.2 ± 0.3% | 500.5 ± 0.9% | 986.4 ± 0.4% | 735.5 ± 0.5% | 10.733 | 14.484 | 31.378 | 15.921 | 21.353 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.916 of yyjson.
