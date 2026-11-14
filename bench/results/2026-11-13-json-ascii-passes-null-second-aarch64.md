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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43464730913 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1130.0 ± 0.5% | 0.522 | 0.964 | 0.995 | 0.997 | 0.459 | 1.003 | 1.005 | 0.387 | 0.829 | 0.899 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 851.1 ± 1.8% | 0.822 | 1.002 | 1.004 | 1.004 | 0.447 | 1.000 | 1.029 | 0.400 | 0.920 | 0.990 | 0.123 |
| string: silesia/dickens | 172528 | 5051.5 ± 0.8% | 0.033 | 0.782 | 1.002 | 1.002 | 0.196 | 1.015 | 1.006 | 0.196 | 1.001 | 1.001 | 0.032 |
| string: silesia/nci | 1075110 | 4291.8 ± 1.0% | 0.039 | 0.804 | 1.003 | 1.003 | 0.280 | 1.007 | 0.998 | 0.280 | 1.004 | 1.003 | 0.038 |
| string: silesia/reymont | 1075159 | 2929.4 ± 0.9% | 0.057 | 0.819 | 0.997 | 0.995 | 0.360 | 1.005 | 1.016 | 0.360 | 1.016 | 1.019 | 0.056 |
| string: silesia/samba | 97582 | 3489.9 ± 0.4% | 0.040 | 0.863 | 1.004 | 1.006 | 0.069 | 0.780 | 1.010 | 0.073 | 1.004 | 1.006 | 0.039 |
| string: silesia/webster | 1098490 | 3647.1 ± 0.4% | 0.044 | 0.848 | 1.003 | 1.003 | 0.203 | 1.019 | 1.014 | 0.204 | 1.009 | 1.006 | 0.044 |
| string: silesia/xml | 1090118 | 4784.8 ± 0.6% | 0.035 | 0.806 | 1.004 | 1.008 | 0.222 | 0.980 | 1.005 | 0.224 | 1.010 | 1.008 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4311.1 ± 0.7% | 0.038 | 0.751 | 1.005 | 1.009 | 0.172 | 1.034 | 1.014 | 0.171 | 1.006 | 1.009 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3454.4 ± 1.2% | 0.046 | 0.748 | 1.005 | 1.009 | 0.177 | 1.002 | 0.971 | 0.176 | 1.012 | 1.014 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5075.5 ± 0.9% | 0.033 | 0.819 | 1.006 | 1.007 | 0.197 | 1.024 | 1.014 | 0.197 | 1.006 | 1.005 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4123.2 ± 0.8% | 0.040 | 0.824 | 1.003 | 1.006 | 0.199 | 1.006 | 0.996 | 0.198 | 1.004 | 1.003 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19195.6 ± 0.9% | 0.077 | 1.007 | 1.006 | 1.003 | 0.481 | 1.007 | 1.009 | 0.481 | 0.622 | 0.622 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6676.2 ± 1.0% | 0.026 | 0.803 | 1.004 | 1.007 | 0.434 | 1.028 | 1.044 | 0.434 | 1.037 | 1.039 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3386.7 ± 0.2% | 0.047 | 0.845 | 1.002 | 1.003 | 0.198 | 1.014 | 1.005 | 0.198 | 1.003 | 1.002 | 0.047 |
| string: http/html-1m | 1058582 | 6055.6 ± 0.5% | 0.028 | 0.784 | 0.998 | 1.032 | 0.389 | 1.042 | 1.056 | 0.390 | 1.027 | 1.030 | 0.028 |
| string: http/json-1m | 1190272 | 2556.0 ± 0.3% | 0.055 | 0.949 | 1.001 | 1.000 | 0.111 | 1.003 | 0.469 | 0.111 | 1.003 | 1.004 | 0.055 |
| string: http/js-1m | 1144362 | 2288.4 ± 0.4% | 0.066 | 0.888 | 1.001 | 1.002 | 0.174 | 1.053 | 1.044 | 0.174 | 0.998 | 0.998 | 0.065 |
| string: http/css-1m | 1097820 | 2639.0 ± 0.5% | 0.061 | 0.776 | 1.003 | 1.007 | 0.240 | 1.007 | 1.014 | 0.239 | 1.004 | 1.007 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3069.6 ± 0.5% | 0.044 | 0.125 | 1.003 | 1.004 | 0.337 | 1.002 | 1.007 | 0.337 | 1.006 | 1.005 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.7 ± 1.6% | 0.082 | 1.003 | 1.002 | 1.002 | 0.077 | 0.637 | 1.004 | 0.081 | 1.002 | 1.002 | 0.081 |
| hex: silesia/dickens | 524290 | 18966.4 ± 1.1% | 0.078 | 0.998 | 0.984 | 0.988 | 0.503 | 1.004 | 0.984 | 0.504 | 0.632 | 0.633 | 0.009 |
| hex: silesia/mozilla | 524290 | 18598.3 ± 1.3% | 0.080 | 1.009 | 0.990 | 0.987 | 0.522 | 0.995 | 0.992 | 0.524 | 0.646 | 0.646 | 0.009 |
| hex: silesia/mr | 524290 | 18568.9 ± 1.0% | 0.080 | 1.010 | 1.003 | 1.000 | 0.515 | 1.000 | 1.001 | 0.517 | 0.646 | 0.646 | 0.009 |
| hex: silesia/nci | 524290 | 18805.1 ± 0.8% | 0.079 | 1.004 | 0.998 | 0.998 | 0.509 | 0.999 | 0.999 | 0.507 | 0.638 | 0.638 | 0.009 |
| hex: silesia/ooffice | 524290 | 18841.1 ± 1.8% | 0.079 | 1.005 | 1.004 | 1.001 | 0.512 | 1.005 | 0.999 | 0.511 | 0.638 | 0.638 | 0.009 |
| hex: silesia/osdb | 524290 | 18349.6 ± 0.4% | 0.081 | 1.003 | 0.999 | 1.000 | 0.523 | 0.998 | 0.995 | 0.522 | 0.653 | 0.653 | 0.009 |
| hex: silesia/reymont | 524290 | 18546.3 ± 0.3% | 0.080 | 1.014 | 1.000 | 1.002 | 0.517 | 0.999 | 1.003 | 0.516 | 0.647 | 0.647 | 0.009 |
| hex: silesia/samba | 524290 | 18215.0 ± 1.1% | 0.082 | 1.001 | 1.000 | 1.000 | 0.532 | 1.001 | 0.997 | 0.532 | 0.660 | 0.659 | 0.010 |
| hex: silesia/sao | 524290 | 18756.3 ± 1.4% | 0.079 | 1.009 | 0.996 | 0.995 | 0.508 | 0.992 | 0.998 | 0.509 | 0.639 | 0.640 | 0.009 |
| hex: silesia/webster | 524290 | 18729.9 ± 1.4% | 0.079 | 1.011 | 1.006 | 1.004 | 0.517 | 0.996 | 0.995 | 0.515 | 0.641 | 0.641 | 0.009 |
| hex: silesia/x-ray | 524290 | 18679.6 ± 0.5% | 0.080 | 1.005 | 0.998 | 0.997 | 0.515 | 0.998 | 1.002 | 0.515 | 0.642 | 0.642 | 0.009 |
| hex: silesia/xml | 524290 | 18887.3 ± 0.8% | 0.079 | 0.999 | 0.990 | 0.992 | 0.507 | 0.995 | 0.998 | 0.508 | 0.635 | 0.635 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19282.5 ± 0.2% | 0.078 | 1.002 | 1.002 | 1.002 | 0.508 | 1.002 | 1.001 | 0.510 | 0.623 | 0.622 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19291.5 ± 0.3% | 0.078 | 1.001 | 1.000 | 1.001 | 0.516 | 1.000 | 0.999 | 0.516 | 0.622 | 0.622 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19287.7 ± 0.5% | 0.081 | 1.001 | 1.001 | 1.001 | 0.541 | 1.001 | 1.002 | 0.544 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18907.5 ± 0.3% | 0.084 | 1.003 | 1.002 | 1.003 | 0.534 | 1.003 | 1.003 | 0.540 | 0.623 | 0.623 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17476.8 ± 1.7% | 0.089 | 1.008 | 1.008 | 1.008 | 0.526 | 1.007 | 1.007 | 0.546 | 0.644 | 0.647 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18837.8 ± 1.8% | 0.079 | 1.005 | 1.001 | 0.993 | 0.503 | 0.997 | 0.989 | 0.504 | 0.637 | 0.636 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18895.8 ± 1.1% | 0.079 | 1.003 | 0.996 | 0.994 | 0.510 | 0.994 | 0.992 | 0.511 | 0.634 | 0.635 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18573.4 ± 1.1% | 0.080 | 1.007 | 1.007 | 1.008 | 0.536 | 0.999 | 1.003 | 0.534 | 0.647 | 0.647 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 18461.4 ± 0.9% | 0.081 | 1.012 | 1.008 | 1.006 | 0.528 | 1.004 | 1.008 | 0.526 | 0.651 | 0.651 | 0.009 |
| hex: canterbury/sum | 76482 | 19300.5 ± 0.2% | 0.078 | 1.001 | 1.002 | 1.002 | 0.518 | 1.002 | 1.001 | 0.519 | 0.617 | 0.617 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17804.5 ± 0.5% | 0.088 | 1.003 | 1.004 | 1.004 | 0.526 | 1.002 | 1.002 | 0.542 | 0.638 | 0.638 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18574.0 ± 0.9% | 0.080 | 1.014 | 1.002 | 1.004 | 0.522 | 1.005 | 1.004 | 0.522 | 0.644 | 0.644 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18840.5 ± 1.3% | 0.079 | 1.004 | 0.998 | 0.987 | 0.515 | 0.998 | 0.995 | 0.514 | 0.636 | 0.637 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18285.7 ± 0.5% | 0.081 | 1.006 | 1.003 | 1.003 | 0.529 | 1.002 | 1.001 | 0.529 | 0.656 | 0.656 | 0.010 |
| hex: http/html-1kx1024 | 2099200 | 10076.7 ± 16.4% | 0.142 | 1.191 | 1.195 | 1.192 | 0.661 | 1.179 | 0.938 | 0.727 | 0.882 | 0.888 | 0.017 |
| hex: http/html-16kx64 | 2097280 | 18113.1 ± 1.6% | 0.083 | 1.022 | 1.020 | 1.020 | 0.566 | 1.021 | 0.996 | 0.572 | 0.651 | 0.650 | 0.010 |
| hex: http/html-1m | 524290 | 18257.2 ± 0.6% | 0.082 | 1.013 | 1.006 | 1.006 | 0.529 | 1.014 | 1.011 | 0.530 | 0.657 | 0.657 | 0.010 |
| hex: http/json-1kx1024 | 2099200 | 9943.1 ± 16.3% | 0.143 | 1.218 | 1.217 | 1.213 | 0.668 | 1.204 | 0.949 | 0.736 | 0.893 | 0.900 | 0.017 |
| hex: http/json-16kx64 | 2097280 | 18320.7 ± 1.1% | 0.082 | 1.011 | 1.007 | 1.009 | 0.559 | 1.011 | 0.985 | 0.565 | 0.643 | 0.643 | 0.010 |
| hex: http/json-1m | 524290 | 18501.5 ± 1.2% | 0.080 | 1.010 | 1.005 | 1.001 | 0.514 | 1.000 | 1.000 | 0.514 | 0.647 | 0.647 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 9732.7 ± 18.1% | 0.147 | 1.244 | 1.245 | 1.241 | 0.684 | 1.235 | 0.966 | 0.749 | 0.910 | 0.922 | 0.018 |
| hex: http/js-16kx64 | 2097280 | 18140.0 ± 1.5% | 0.083 | 1.016 | 1.016 | 1.016 | 0.565 | 1.020 | 0.989 | 0.570 | 0.648 | 0.650 | 0.010 |
| hex: http/js-1m | 524290 | 18910.9 ± 1.0% | 0.079 | 1.004 | 1.002 | 0.999 | 0.508 | 0.997 | 0.991 | 0.508 | 0.634 | 0.634 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9711.6 ± 18.4% | 0.147 | 1.246 | 1.247 | 1.251 | 0.681 | 1.243 | 0.966 | 0.744 | 0.915 | 0.919 | 0.018 |
| hex: http/css-16kx64 | 2097280 | 18168.7 ± 0.6% | 0.083 | 1.019 | 1.015 | 1.013 | 0.563 | 1.016 | 0.992 | 0.566 | 0.648 | 0.648 | 0.010 |
| hex: http/css-1m | 524290 | 18649.8 ± 0.4% | 0.080 | 1.004 | 1.000 | 1.002 | 0.514 | 0.997 | 1.000 | 0.514 | 0.640 | 0.642 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18136.6 ± 1.1% | 0.082 | 1.001 | 1.001 | 1.001 | 0.527 | 1.004 | 1.004 | 0.529 | 0.661 | 0.658 | 0.010 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1488.5 ± 1.1% | 0.443 | 0.999 | 0.971 | 1.004 | 1.011 | 0.267 | 1.001 | 0.546 | 0.915 | 0.089 | 1.028 |
| qlog records, JSON text sequence | 1467503 | 1268.6 ± 1.0% | 0.692 | 0.978 | 1.012 | 1.014 | 1.013 | 0.264 | 1.003 | 0.502 | 0.829 | 0.106 | 1.020 |
| string: silesia/dickens | 172528 | 6887.8 ± 0.5% | 0.025 | 1.001 | 1.001 | 1.002 | 1.002 | 0.167 | 0.718 | 1.003 | 1.004 | 0.025 | 1.034 |
| string: silesia/nci | 1075110 | 7317.5 ± 0.4% | 0.023 | 1.000 | 1.000 | 0.999 | 1.001 | 0.212 | 0.564 | 0.999 | 1.000 | 0.024 | 1.006 |
| string: silesia/reymont | 1075159 | 3345.9 ± 0.9% | 0.051 | 1.005 | 0.995 | 1.005 | 1.000 | 0.389 | 0.868 | 1.000 | 0.996 | 0.052 | 1.047 |
| string: silesia/samba | 97582 | 4185.9 ± 1.2% | 0.053 | 1.001 | 0.999 | 1.007 | 1.008 | 0.125 | 0.946 | 1.004 | 1.003 | 0.054 | 1.094 |
| string: silesia/webster | 1098490 | 4043.9 ± 0.8% | 0.042 | 1.013 | 1.010 | 1.011 | 1.011 | 0.213 | 0.891 | 1.004 | 1.010 | 0.043 | 1.012 |
| string: silesia/xml | 1090118 | 6130.5 ± 0.5% | 0.028 | 1.002 | 1.000 | 1.003 | 1.002 | 0.254 | 0.775 | 1.000 | 1.001 | 0.029 | 1.015 |
| string: canterbury/alice29.txt | 159425 | 6404.5 ± 0.4% | 0.027 | 1.009 | 1.009 | 1.013 | 1.014 | 0.133 | 0.653 | 1.004 | 1.007 | 0.027 | 1.067 |
| string: canterbury/asyoulik.txt | 132198 | 5579.0 ± 0.9% | 0.030 | 1.024 | 1.030 | 1.031 | 1.034 | 0.130 | 0.598 | 1.006 | 1.013 | 0.030 | 1.058 |
| string: canterbury/lcet10.txt | 441884 | 6243.8 ± 0.8% | 0.028 | 1.004 | 1.006 | 1.009 | 1.008 | 0.185 | 0.799 | 1.005 | 1.004 | 0.028 | 1.002 |
| string: canterbury/plrabn12.txt | 503330 | 5710.4 ± 0.4% | 0.030 | 1.002 | 1.001 | 1.003 | 1.003 | 0.169 | 0.698 | 1.001 | 1.002 | 0.030 | 1.006 |
| string: canterbury-large/E.coli | 1048578 | 19308.4 ± 0.8% | 0.077 | 0.999 | 1.001 | 0.999 | 1.002 | 0.480 | 1.001 | 1.001 | 1.003 | 0.009 | 1.002 |
| string: canterbury-large/bible.txt | 1055886 | 6792.4 ± 0.8% | 0.026 | 1.001 | 1.001 | 1.001 | 1.002 | 0.495 | 0.970 | 0.999 | 1.001 | 0.026 | 1.001 |
| string: canterbury-large/world192.txt | 1103121 | 4027.9 ± 0.5% | 0.042 | 1.015 | 1.017 | 1.016 | 1.016 | 0.193 | 0.830 | 1.002 | 1.010 | 0.043 | 1.001 |
| string: http/html-1m | 1058582 | 6730.9 ± 0.2% | 0.026 | 1.004 | 0.927 | 1.006 | 1.009 | 0.406 | 0.889 | 1.003 | 1.006 | 0.026 | 1.013 |
| string: http/json-1m | 1190272 | 3161.4 ± 0.4% | 0.051 | 0.999 | 0.967 | 1.002 | 1.003 | 0.133 | 0.371 | 1.002 | 1.002 | 0.051 | 1.042 |
| string: http/js-1m | 1144362 | 2749.5 ± 0.5% | 0.060 | 1.005 | 1.011 | 1.004 | 1.009 | 0.166 | 0.843 | 1.003 | 1.008 | 0.061 | 1.014 |
| string: http/css-1m | 1097820 | 3976.0 ± 0.3% | 0.042 | 1.008 | 1.012 | 1.008 | 1.012 | 0.209 | 0.647 | 1.005 | 1.008 | 0.043 | 1.016 |
| string: dickens as Cyrillic and CJK | 1883069 | 3069.3 ± 0.5% | 0.048 | 1.002 | 0.124 | 1.001 | 1.001 | 0.320 | 1.003 | 1.002 | 1.002 | 0.048 | 1.001 |
| hex: silesia/dickens | 524290 | 15634.1 ± 0.4% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.000 | 1.002 | 1.002 | 0.178 | 0.998 |
| hex: silesia/mozilla | 524290 | 15682.1 ± 0.2% | 1.001 | 0.178 | 0.995 | 0.995 | 0.995 | 0.998 | 0.997 | 0.993 | 0.996 | 0.178 | 0.998 |
| hex: silesia/mr | 524290 | 15671.1 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.001 | 1.002 | 1.001 | 1.002 | 1.002 | 1.002 | 0.178 | 1.002 |
| hex: silesia/nci | 524290 | 15641.7 ± 0.1% | 1.001 | 0.178 | 1.003 | 1.001 | 1.003 | 1.003 | 1.003 | 1.003 | 1.003 | 0.178 | 1.003 |
| hex: silesia/ooffice | 524290 | 15557.8 ± 0.3% | 1.001 | 0.179 | 1.002 | 1.000 | 1.001 | 1.002 | 1.003 | 1.001 | 1.002 | 0.178 | 1.002 |
| hex: silesia/osdb | 524290 | 15615.6 ± 0.2% | 1.002 | 0.179 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: silesia/reymont | 524290 | 15684.2 ± 0.2% | 1.001 | 0.177 | 1.001 | 1.002 | 1.001 | 1.000 | 1.001 | 0.999 | 1.001 | 0.177 | 1.001 |
| hex: silesia/samba | 524290 | 15645.2 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.000 | 1.001 | 0.996 | 0.999 | 0.999 | 0.998 | 0.178 | 0.999 |
| hex: silesia/sao | 524290 | 15663.5 ± 0.5% | 1.001 | 0.177 | 1.002 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: silesia/webster | 524290 | 15643.8 ± 0.3% | 1.004 | 0.178 | 1.003 | 1.001 | 1.002 | 1.002 | 1.002 | 1.004 | 1.003 | 0.177 | 1.004 |
| hex: silesia/x-ray | 524290 | 15618.7 ± 0.3% | 1.001 | 0.178 | 1.001 | 1.001 | 0.999 | 1.000 | 1.001 | 1.001 | 1.000 | 0.178 | 1.001 |
| hex: silesia/xml | 524290 | 15587.6 ± 0.4% | 1.001 | 0.178 | 1.003 | 1.004 | 1.004 | 1.003 | 1.004 | 1.003 | 1.004 | 0.178 | 1.004 |
| hex: canterbury/alice29.txt | 304180 | 15675.7 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15696.4 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15611.3 ± 0.1% | 1.001 | 0.179 | 1.001 | 1.001 | 1.001 | 0.998 | 1.001 | 1.002 | 1.004 | 0.179 | 1.002 |
| hex: canterbury/fields.c | 22302 | 15430.6 ± 0.1% | 1.002 | 0.181 | 1.001 | 1.000 | 1.000 | 0.994 | 1.001 | 1.003 | 1.006 | 0.180 | 1.002 |
| hex: canterbury/grammar.lsp | 7444 | 14931.2 ± 0.1% | 1.004 | 0.186 | 1.001 | 1.000 | 1.001 | 0.983 | 1.001 | 1.005 | 1.015 | 0.184 | 1.004 |
| hex: canterbury/kennedy.xls | 524290 | 15628.4 ± 0.3% | 1.002 | 0.178 | 1.000 | 1.001 | 1.001 | 0.998 | 1.001 | 1.001 | 1.001 | 0.179 | 1.001 |
| hex: canterbury/lcet10.txt | 524290 | 15632.6 ± 0.3% | 1.002 | 0.178 | 1.002 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/plrabn12.txt | 524290 | 15690.7 ± 0.1% | 1.001 | 0.177 | 0.998 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 1.000 | 0.177 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 15650.9 ± 0.2% | 1.001 | 0.179 | 1.000 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/sum | 76482 | 15638.9 ± 0.1% | 1.002 | 0.179 | 1.000 | 1.001 | 1.000 | 0.999 | 1.001 | 1.001 | 1.002 | 0.179 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 14988.6 ± 0.1% | 1.003 | 0.185 | 1.001 | 1.000 | 1.000 | 0.986 | 1.000 | 1.005 | 1.015 | 0.184 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 15637.1 ± 0.3% | 1.003 | 0.178 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 1.002 | 1.002 | 0.178 | 1.000 |
| hex: canterbury-large/bible.txt | 524290 | 15640.6 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.001 | 1.001 | 0.999 | 1.001 | 1.000 | 1.000 | 0.178 | 1.000 |
| hex: canterbury-large/world192.txt | 524290 | 15560.8 ± 0.3% | 1.001 | 0.179 | 1.001 | 1.000 | 1.000 | 0.998 | 0.997 | 1.000 | 1.000 | 0.178 | 1.001 |
| hex: http/html-1kx1024 | 2099200 | 13701.2 ± 0.2% | 1.004 | 0.195 | 1.003 | 1.001 | 1.000 | 0.938 | 0.997 | 1.010 | 1.035 | 0.187 | 1.019 |
| hex: http/html-16kx64 | 2097280 | 15217.6 ± 1.8% | 1.000 | 0.181 | 1.001 | 1.002 | 1.002 | 0.991 | 1.000 | 1.003 | 1.011 | 0.180 | 1.005 |
| hex: http/html-1m | 524290 | 15653.5 ± 0.1% | 0.999 | 0.177 | 1.001 | 1.000 | 1.000 | 1.001 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: http/json-1kx1024 | 2099200 | 13668.8 ± 0.3% | 1.009 | 0.196 | 1.005 | 1.005 | 1.004 | 0.942 | 0.998 | 1.011 | 1.036 | 0.188 | 1.014 |
| hex: http/json-16kx64 | 2097280 | 15250.5 ± 0.4% | 1.000 | 0.181 | 1.003 | 1.001 | 0.999 | 0.993 | 0.997 | 1.002 | 1.011 | 0.180 | 1.001 |
| hex: http/json-1m | 524290 | 15670.5 ± 0.3% | 0.999 | 0.177 | 1.000 | 0.999 | 0.999 | 1.000 | 1.000 | 1.001 | 1.000 | 0.177 | 0.999 |
| hex: http/js-1kx1024 | 2099200 | 13687.5 ± 0.4% | 1.007 | 0.195 | 1.000 | 1.001 | 0.999 | 0.941 | 1.002 | 1.014 | 1.035 | 0.187 | 1.013 |
| hex: http/js-16kx64 | 2097280 | 15218.8 ± 0.4% | 1.000 | 0.181 | 1.006 | 1.002 | 1.003 | 0.994 | 1.002 | 1.006 | 1.012 | 0.180 | 1.006 |
| hex: http/js-1m | 524290 | 15639.7 ± 0.3% | 1.001 | 0.177 | 1.000 | 1.002 | 1.001 | 1.001 | 1.000 | 1.002 | 1.002 | 0.177 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 13619.3 ± 0.5% | 1.013 | 0.196 | 1.004 | 1.002 | 1.001 | 0.945 | 1.005 | 1.016 | 1.041 | 0.188 | 1.017 |
| hex: http/css-16kx64 | 2097280 | 15214.3 ± 0.3% | 1.002 | 0.181 | 1.004 | 1.002 | 1.002 | 0.994 | 1.002 | 1.005 | 1.013 | 0.180 | 1.006 |
| hex: http/css-1m | 524290 | 15662.6 ± 0.6% | 1.000 | 0.177 | 1.000 | 1.001 | 1.002 | 1.001 | 1.002 | 1.002 | 1.000 | 0.177 | 0.998 |
| hex: shuffled/dickens-1m | 524290 | 15656.7 ± 0.3% | 1.000 | 0.178 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 1.002 | 1.000 | 0.177 | 1.000 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.056 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.053 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.191 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.195 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.192 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.179 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.218 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.217 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.213 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.204 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.244 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.245 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.241 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.235 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.246 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.247 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.251 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.243 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43360.8 ± 0.1% | 47381.6 ± 0.1% | 0.915 | — | — |
| string: silesia/nci | 1048576 | 36835.7 ± 1.1% | 39475.5 ± 1.7% | 0.933 | — | — |
| string: silesia/reymont | 1048576 | 35813.5 ± 4.7% | 38472.9 ± 4.2% | 0.931 | — | — |
| string: silesia/samba | 65546 | 43583.4 ± 0.1% | 48508.8 ± 0.0% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 37175.7 ± 4.4% | 40372.4 ± 6.0% | 0.921 | — | — |
| string: silesia/xml | 1048576 | 32018.4 ± 2.2% | 33383.3 ± 2.0% | 0.959 | — | — |
| string: canterbury/alice29.txt | 152089 | 35880.4 ± 0.1% | 36514.2 ± 0.1% | 0.983 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43345.6 ± 0.1% | 47623.7 ± 0.1% | 0.910 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36004.1 ± 0.2% | 36673.1 ± 0.1% | 0.982 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 43555.0 ± 0.1% | 46773.8 ± 0.4% | 0.931 | — | — |
| string: canterbury-large/E.coli | 1048576 | 35528.8 ± 7.1% | 37999.0 ± 7.9% | 0.935 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 31781.9 ± 2.5% | 32954.9 ± 4.6% | 0.964 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 31883.6 ± 1.0% | 33166.4 ± 1.9% | 0.961 | — | — |
| string: http/html-1m | 1048576 | 34904.5 ± 3.1% | 38109.5 ± 2.2% | 0.916 | — | — |
| string: http/json-1m | 1048576 | 31039.2 ± 0.8% | 33110.7 ± 1.9% | 0.937 | — | — |
| string: http/js-1m | 1048576 | 36459.5 ± 2.3% | 39679.1 ± 1.3% | 0.919 | — | — |
| string: http/css-1m | 1048576 | 37234.3 ± 3.3% | 40147.6 ± 3.0% | 0.927 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5763.9 ± 0.5% | 5651.9 ± 0.1% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.915 of simdutf.
- string: silesia/nci: stdx runs at 0.933 of simdutf.
- string: silesia/reymont: stdx runs at 0.931 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.921 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.910 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.931 of simdutf.
- string: http/html-1m: stdx runs at 0.916 of simdutf.
- string: http/json-1m: stdx runs at 0.937 of simdutf.
- string: http/js-1m: stdx runs at 0.919 of simdutf.
- string: http/css-1m: stdx runs at 0.927 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 38320.2 ± 3.0% | 41722.2 ± 4.8% | 0.918 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 32811.4 ± 3.6% | 33905.8 ± 1.9% | 0.968 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 37526.7 ± 2.1% | 40035.4 ± 3.4% | 0.937 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 38244.0 ± 4.7% | 41768.7 ± 3.6% | 0.916 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 37871.0 ± 2.7% | 41363.6 ± 3.8% | 0.916 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 37518.3 ± 2.9% | 40943.6 ± 2.3% | 0.916 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5755.0 ± 0.2% | 5642.7 ± 0.1% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5750.4 ± 0.2% | 5635.6 ± 0.4% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5759.0 ± 0.1% | 5648.2 ± 0.1% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5764.1 ± 0.2% | 5648.4 ± 0.1% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5761.6 ± 0.4% | 5640.8 ± 0.3% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5766.2 ± 0.1% | 5645.0 ± 0.2% | 1.021 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1130.0 ± 0.5% | 925.8 ± 0.7% | 1022.3 ± 0.4% | 301.2 ± 0.4% | 667.6 ± 0.2% | 310.0 ± 1.4% | 1.221 | 1.105 | 3.752 | 1.693 | 3.645 |
| qlog records, JSON text sequence | 1467503 | 851.1 ± 1.8% | 817.0 ± 0.2% | 792.9 ± 1.4% | 243.3 ± 0.9% | 703.8 ± 0.5% | 250.9 ± 0.8% | 1.042 | 1.073 | 3.498 | 1.209 | 3.392 |
| string: silesia/dickens | 172528 | 5051.5 ± 0.8% | 1877.0 ± 0.2% | 2642.5 ± 0.6% | 360.6 ± 0.2% | 2845.4 ± 0.3% | 550.5 ± 1.2% | 2.691 | 1.912 | 14.009 | 1.775 | 9.175 |
| string: silesia/nci | 1075110 | 4291.8 ± 1.0% | 2239.4 ± 0.4% | 3001.9 ± 0.2% | 544.5 ± 0.5% | 3004.6 ± 0.6% | 603.1 ± 1.7% | 1.916 | 1.430 | 7.882 | 1.428 | 7.117 |
| string: silesia/reymont | 1075159 | 2929.4 ± 0.9% | 1814.9 ± 1.9% | 2062.6 ± 1.1% | 374.1 ± 1.9% | 2145.1 ± 0.7% | 536.3 ± 2.6% | 1.614 | 1.420 | 7.830 | 1.366 | 5.462 |
| string: silesia/samba | 97582 | 3489.9 ± 0.4% | 2025.8 ± 0.4% | 2616.1 ± 0.2% | 328.3 ± 0.3% | 1500.6 ± 0.2% | 430.4 ± 0.7% | 1.723 | 1.334 | 10.629 | 2.326 | 8.108 |
| string: silesia/webster | 1098490 | 3647.1 ± 0.4% | 1517.1 ± 0.2% | 2018.2 ± 0.7% | 358.0 ± 0.8% | 2186.5 ± 0.3% | 498.8 ± 1.0% | 2.404 | 1.807 | 10.186 | 1.668 | 7.312 |
| string: silesia/xml | 1090118 | 4784.8 ± 0.6% | 2354.5 ± 0.2% | 2524.7 ± 0.5% | 457.0 ± 0.6% | 2873.5 ± 0.7% | 563.3 ± 1.4% | 2.032 | 1.895 | 10.470 | 1.665 | 8.494 |
| string: canterbury/alice29.txt | 159425 | 4311.1 ± 0.7% | 1598.7 ± 0.3% | 2455.5 ± 0.9% | 342.3 ± 0.4% | 2496.3 ± 0.3% | 508.1 ± 0.9% | 2.697 | 1.756 | 12.596 | 1.727 | 8.485 |
| string: canterbury/asyoulik.txt | 132198 | 3454.4 ± 1.2% | 1459.7 ± 0.3% | 2246.3 ± 0.9% | 335.0 ± 1.3% | 2077.6 ± 0.5% | 459.2 ± 1.4% | 2.367 | 1.538 | 10.312 | 1.663 | 7.523 |
| string: canterbury/lcet10.txt | 441884 | 5075.5 ± 0.9% | 1853.2 ± 0.3% | 2341.0 ± 1.0% | 390.8 ± 0.5% | 2842.5 ± 0.7% | 536.7 ± 2.3% | 2.739 | 2.168 | 12.988 | 1.786 | 9.458 |
| string: canterbury/plrabn12.txt | 503330 | 4123.2 ± 0.8% | 1735.5 ± 0.3% | 2066.7 ± 0.4% | 359.7 ± 0.8% | 2495.4 ± 0.4% | 500.7 ± 0.8% | 2.376 | 1.995 | 11.464 | 1.652 | 8.235 |
| string: canterbury-large/E.coli | 1048578 | 19195.6 ± 0.9% | 3608.5 ± 0.4% | 3258.3 ± 0.5% | 932.0 ± 1.4% | 6010.5 ± 1.1% | 765.4 ± 1.4% | 5.319 | 5.891 | 20.597 | 3.194 | 25.079 |
| string: canterbury-large/bible.txt | 1055886 | 6676.2 ± 1.0% | 2947.6 ± 0.4% | 2832.3 ± 0.5% | 418.8 ± 2.4% | 3752.6 ± 1.4% | 619.0 ± 1.0% | 2.265 | 2.357 | 15.943 | 1.779 | 10.785 |
| string: canterbury-large/world192.txt | 1103121 | 3386.7 ± 0.2% | 1483.8 ± 0.1% | 2016.3 ± 0.8% | 352.3 ± 0.4% | 2124.7 ± 0.6% | 503.0 ± 0.8% | 2.283 | 1.680 | 9.613 | 1.594 | 6.734 |
| string: http/html-1m | 1058582 | 6055.6 ± 0.5% | 2741.1 ± 0.7% | 2702.6 ± 0.3% | 442.1 ± 0.8% | 3487.3 ± 0.7% | 595.7 ± 1.1% | 2.209 | 2.241 | 13.699 | 1.736 | 10.165 |
| string: http/json-1m | 1190272 | 2556.0 ± 0.3% | 877.6 ± 0.1% | 2252.6 ± 0.6% | 389.9 ± 0.4% | 1064.6 ± 0.4% | 443.6 ± 0.5% | 2.912 | 1.135 | 6.556 | 2.401 | 5.763 |
| string: http/js-1m | 1144362 | 2288.4 ± 0.4% | 1029.3 ± 0.1% | 1639.2 ± 0.4% | 320.6 ± 0.5% | 1528.9 ± 0.3% | 420.4 ± 0.6% | 2.223 | 1.396 | 7.137 | 1.497 | 5.443 |
| string: http/css-1m | 1097820 | 2639.0 ± 0.5% | 1679.1 ± 0.6% | 2230.3 ± 0.4% | 405.0 ± 1.2% | 1960.6 ± 0.1% | 490.2 ± 1.2% | 1.572 | 1.183 | 6.516 | 1.346 | 5.383 |
| string: dickens as Cyrillic and CJK | 1883069 | 3069.6 ± 0.5% | 1686.1 ± 0.4% | 894.3 ± 0.3% | 351.6 ± 0.2% | 671.2 ± 0.3% | 158.2 ± 1.7% | 1.820 | 3.432 | 8.731 | 4.573 | 19.406 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.7 ± 1.6% | 979.7 ± 0.3% | 1209.4 ± 0.7% | 215.9 ± 0.1% | 472.1 ± 0.4% | 256.0 ± 3.7% | 1.355 | 1.098 | 6.149 | 2.812 | 5.186 |
| hex: silesia/dickens | 524290 | 18966.4 ± 1.1% | 3620.0 ± 0.2% | 3292.4 ± 0.2% | 512.4 ± 1.9% | 6108.6 ± 1.6% | 780.4 ± 1.8% | 5.239 | 5.761 | 37.014 | 3.105 | 24.304 |
| hex: silesia/mozilla | 524290 | 18598.3 ± 1.3% | 3616.0 ± 0.3% | 3294.8 ± 0.6% | 450.5 ± 1.5% | 6125.0 ± 1.2% | 783.5 ± 0.6% | 5.143 | 5.645 | 41.280 | 3.036 | 23.738 |
| hex: silesia/mr | 524290 | 18568.9 ± 1.0% | 3616.9 ± 0.2% | 3296.4 ± 0.2% | 560.9 ± 3.6% | 6116.0 ± 1.0% | 782.9 ± 0.7% | 5.134 | 5.633 | 33.103 | 3.036 | 23.717 |
| hex: silesia/nci | 524290 | 18805.1 ± 0.8% | 3616.4 ± 0.2% | 3290.7 ± 0.4% | 613.3 ± 5.6% | 6092.3 ± 1.1% | 784.4 ± 0.7% | 5.200 | 5.715 | 30.663 | 3.087 | 23.974 |
| hex: silesia/ooffice | 524290 | 18841.1 ± 1.8% | 3619.0 ± 0.3% | 3305.9 ± 0.2% | 396.1 ± 2.0% | 6140.3 ± 0.9% | 783.5 ± 0.7% | 5.206 | 5.699 | 47.569 | 3.068 | 24.046 |
| hex: silesia/osdb | 524290 | 18349.6 ± 0.4% | 3615.1 ± 0.4% | 3296.3 ± 0.8% | 480.3 ± 1.8% | 6106.5 ± 0.7% | 784.1 ± 0.7% | 5.076 | 5.567 | 38.203 | 3.005 | 23.402 |
| hex: silesia/reymont | 524290 | 18546.3 ± 0.3% | 3618.1 ± 0.2% | 3297.1 ± 0.3% | 515.0 ± 1.6% | 6125.7 ± 1.3% | 783.0 ± 0.9% | 5.126 | 5.625 | 36.013 | 3.028 | 23.688 |
| hex: silesia/samba | 524290 | 18215.0 ± 1.1% | 3615.9 ± 0.2% | 3298.1 ± 0.4% | 406.2 ± 3.7% | 6138.9 ± 1.8% | 784.6 ± 1.3% | 5.038 | 5.523 | 44.838 | 2.967 | 23.216 |
| hex: silesia/sao | 524290 | 18756.3 ± 1.4% | 3615.7 ± 0.4% | 3292.7 ± 0.4% | 344.2 ± 1.9% | 6011.5 ± 1.0% | 784.5 ± 0.4% | 5.187 | 5.696 | 54.489 | 3.120 | 23.910 |
| hex: silesia/webster | 524290 | 18729.9 ± 1.4% | 3609.4 ± 0.3% | 3300.0 ± 0.5% | 463.7 ± 0.9% | 6132.3 ± 0.9% | 783.5 ± 0.8% | 5.189 | 5.676 | 40.391 | 3.054 | 23.906 |
| hex: silesia/x-ray | 524290 | 18679.6 ± 0.5% | 3616.8 ± 0.2% | 3298.3 ± 0.4% | 476.7 ± 2.6% | 6146.4 ± 1.8% | 784.7 ± 0.6% | 5.165 | 5.663 | 39.188 | 3.039 | 23.803 |
| hex: silesia/xml | 524290 | 18887.3 ± 0.8% | 3610.5 ± 0.2% | 3293.7 ± 0.5% | 527.4 ± 0.4% | 6080.6 ± 1.3% | 784.1 ± 0.5% | 5.231 | 5.734 | 35.809 | 3.106 | 24.088 |
| hex: canterbury/alice29.txt | 304180 | 19282.5 ± 0.2% | 3631.8 ± 0.1% | 3377.3 ± 0.1% | 518.7 ± 0.2% | 6105.8 ± 0.8% | 784.0 ± 1.7% | 5.309 | 5.709 | 37.173 | 3.158 | 24.595 |
| hex: canterbury/asyoulik.txt | 250360 | 19291.5 ± 0.3% | 3640.8 ± 0.1% | 3366.7 ± 0.1% | 511.4 ± 0.2% | 6113.3 ± 2.9% | 781.2 ± 0.5% | 5.299 | 5.730 | 37.725 | 3.156 | 24.693 |
| hex: canterbury/cp.html | 49208 | 19287.7 ± 0.5% | 3638.7 ± 0.0% | 3291.8 ± 0.2% | 475.8 ± 3.0% | 6282.0 ± 0.6% | 767.7 ± 1.1% | 5.301 | 5.859 | 40.539 | 3.070 | 25.123 |
| hex: canterbury/fields.c | 22302 | 18907.5 ± 0.3% | 3629.3 ± 0.1% | 3365.8 ± 0.2% | 505.6 ± 1.4% | 6256.1 ± 0.3% | 760.0 ± 2.7% | 5.210 | 5.618 | 37.393 | 3.022 | 24.878 |
| hex: canterbury/grammar.lsp | 7444 | 17476.8 ± 1.7% | 3602.2 ± 0.1% | 3355.5 ± 0.1% | 546.0 ± 2.3% | 6174.7 ± 0.3% | 733.5 ± 1.5% | 4.852 | 5.208 | 32.010 | 2.830 | 23.825 |
| hex: canterbury/kennedy.xls | 524290 | 18837.8 ± 1.8% | 3605.9 ± 0.6% | 3291.4 ± 0.4% | 666.4 ± 3.8% | 6107.9 ± 0.9% | 772.7 ± 7.4% | 5.224 | 5.723 | 28.268 | 3.084 | 24.379 |
| hex: canterbury/lcet10.txt | 524290 | 18895.8 ± 1.1% | 3616.2 ± 0.1% | 3291.4 ± 0.2% | 526.5 ± 1.7% | 6105.6 ± 0.7% | 774.5 ± 0.4% | 5.225 | 5.741 | 35.889 | 3.095 | 24.396 |
| hex: canterbury/plrabn12.txt | 524290 | 18573.4 ± 1.1% | 3612.8 ± 0.2% | 3294.4 ± 0.3% | 517.2 ± 0.3% | 6132.1 ± 1.6% | 773.0 ± 0.6% | 5.141 | 5.638 | 35.909 | 3.029 | 24.029 |
| hex: canterbury/ptt5 | 524290 | 18461.4 ± 0.9% | 3615.5 ± 0.2% | 3295.2 ± 0.2% | 567.5 ± 0.4% | 6065.9 ± 1.9% | 774.7 ± 0.8% | 5.106 | 5.603 | 32.533 | 3.043 | 23.830 |
| hex: canterbury/sum | 76482 | 19300.5 ± 0.2% | 3634.4 ± 0.0% | 3355.5 ± 0.3% | 517.2 ± 1.3% | 6165.5 ± 0.5% | 773.1 ± 1.3% | 5.311 | 5.752 | 37.320 | 3.130 | 24.966 |
| hex: canterbury/xargs.1 | 8456 | 17804.5 ± 0.5% | 3602.5 ± 0.0% | 3384.5 ± 0.3% | 503.7 ± 2.4% | 6145.9 ± 0.4% | 758.3 ± 0.6% | 4.942 | 5.261 | 35.348 | 2.897 | 23.479 |
| hex: canterbury-large/E.coli | 524290 | 18574.0 ± 0.9% | 3618.3 ± 0.2% | 3291.3 ± 0.3% | 688.6 ± 0.1% | 6053.8 ± 1.8% | 772.0 ± 6.7% | 5.133 | 5.643 | 26.975 | 3.068 | 24.061 |
| hex: canterbury-large/bible.txt | 524290 | 18840.5 ± 1.3% | 3614.5 ± 0.1% | 3299.5 ± 0.4% | 526.3 ± 1.5% | 6055.5 ± 1.6% | 771.8 ± 0.9% | 5.213 | 5.710 | 35.801 | 3.111 | 24.411 |
| hex: canterbury-large/world192.txt | 524290 | 18285.7 ± 0.5% | 3617.7 ± 0.2% | 3306.8 ± 0.2% | 505.8 ± 0.4% | 6126.4 ± 1.8% | 775.3 ± 0.7% | 5.055 | 5.530 | 36.154 | 2.985 | 23.586 |
| hex: http/html-1kx1024 | 2099200 | 10076.7 ± 16.4% | 3462.7 ± 0.3% | 2882.3 ± 0.5% | 474.8 ± 0.6% | 5181.4 ± 1.2% | 651.7 ± 1.8% | 2.910 | 3.496 | 21.224 | 1.945 | 15.462 |
| hex: http/html-16kx64 | 2097280 | 18113.1 ± 1.6% | 3612.2 ± 0.4% | 3271.2 ± 0.3% | 476.0 ± 0.7% | 6021.0 ± 0.5% | 751.4 ± 2.6% | 5.014 | 5.537 | 38.055 | 3.008 | 24.106 |
| hex: http/html-1m | 524290 | 18257.2 ± 0.6% | 3618.8 ± 0.2% | 3303.1 ± 0.4% | 501.2 ± 1.6% | 6092.1 ± 1.4% | 767.4 ± 2.8% | 5.045 | 5.527 | 36.429 | 2.997 | 23.789 |
| hex: http/json-1kx1024 | 2099200 | 9943.1 ± 16.3% | 3461.2 ± 0.2% | 2887.0 ± 0.5% | 575.3 ± 1.4% | 5132.8 ± 0.9% | 658.9 ± 2.4% | 2.873 | 3.444 | 17.282 | 1.937 | 15.090 |
| hex: http/json-16kx64 | 2097280 | 18320.7 ± 1.1% | 3613.2 ± 0.1% | 3262.1 ± 0.4% | 575.0 ± 0.9% | 6023.7 ± 0.3% | 755.4 ± 1.0% | 5.071 | 5.616 | 31.865 | 3.041 | 24.253 |
| hex: http/json-1m | 524290 | 18501.5 ± 1.2% | 3620.0 ± 0.2% | 3301.9 ± 0.4% | 601.4 ± 4.9% | 6057.5 ± 2.0% | 760.3 ± 3.1% | 5.111 | 5.603 | 30.761 | 3.054 | 24.335 |
| hex: http/js-1kx1024 | 2099200 | 9732.7 ± 18.1% | 3465.1 ± 0.3% | 2878.3 ± 0.6% | 480.9 ± 0.5% | 5131.1 ± 0.7% | 646.2 ± 5.2% | 2.809 | 3.381 | 20.239 | 1.897 | 15.062 |
| hex: http/js-16kx64 | 2097280 | 18140.0 ± 1.5% | 3614.2 ± 0.6% | 3270.5 ± 1.8% | 480.7 ± 0.6% | 6027.7 ± 1.4% | 743.5 ± 7.5% | 5.019 | 5.547 | 37.739 | 3.009 | 24.398 |
| hex: http/js-1m | 524290 | 18910.9 ± 1.0% | 3618.2 ± 0.2% | 3291.3 ± 0.5% | 501.7 ± 1.8% | 6127.6 ± 1.0% | 780.7 ± 2.9% | 5.227 | 5.746 | 37.696 | 3.086 | 24.222 |
| hex: http/css-1kx1024 | 2099200 | 9711.6 ± 18.4% | 3461.6 ± 0.1% | 2874.5 ± 0.7% | 488.4 ± 0.5% | 5137.3 ± 2.0% | 640.6 ± 2.8% | 2.806 | 3.378 | 19.884 | 1.890 | 15.160 |
| hex: http/css-16kx64 | 2097280 | 18168.7 ± 0.6% | 3614.1 ± 0.2% | 3277.1 ± 0.3% | 495.4 ± 0.7% | 6044.3 ± 0.8% | 749.6 ± 2.0% | 5.027 | 5.544 | 36.675 | 3.006 | 24.239 |
| hex: http/css-1m | 524290 | 18649.8 ± 0.4% | 3616.1 ± 0.6% | 3297.4 ± 0.3% | 498.7 ± 0.8% | 6065.4 ± 0.5% | 775.5 ± 2.1% | 5.157 | 5.656 | 37.400 | 3.075 | 24.050 |
| hex: shuffled/dickens-1m | 524290 | 18136.6 ± 1.1% | 3617.1 ± 0.1% | 3302.5 ± 0.2% | 514.4 ± 0.3% | 5993.2 ± 0.3% | 782.8 ± 2.4% | 5.014 | 5.492 | 35.258 | 3.026 | 23.170 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1488.5 ± 1.1% | 1258.5 ± 0.6% | 1043.2 ± 0.5% | 409.6 ± 0.3% | 448.8 ± 0.3% | 416.3 ± 0.5% | 1.183 | 1.427 | 3.634 | 3.317 | 3.576 |
| qlog records, JSON text sequence | 1467503 | 1268.6 ± 1.0% | 1062.5 ± 0.7% | 792.5 ± 0.8% | 378.0 ± 1.1% | 471.8 ± 1.3% | 279.0 ± 0.3% | 1.194 | 1.601 | 3.356 | 2.689 | 4.547 |
| string: silesia/dickens | 172528 | 6887.8 ± 0.5% | 2817.1 ± 0.7% | 2924.9 ± 0.4% | 429.8 ± 0.8% | 1592.5 ± 0.2% | 1007.2 ± 0.2% | 2.445 | 2.355 | 16.025 | 4.325 | 6.838 |
| string: silesia/nci | 1075110 | 7317.5 ± 0.4% | 3407.2 ± 1.8% | 3094.3 ± 0.6% | 821.2 ± 2.0% | 1860.8 ± 0.4% | 1107.7 ± 0.2% | 2.148 | 2.365 | 8.911 | 3.932 | 6.606 |
| string: silesia/reymont | 1075159 | 3345.9 ± 0.9% | 1971.6 ± 0.3% | 2060.7 ± 0.8% | 449.6 ± 1.1% | 1510.4 ± 0.7% | 949.7 ± 0.6% | 1.697 | 1.624 | 7.441 | 2.215 | 3.523 |
| string: silesia/samba | 97582 | 4185.9 ± 1.2% | 2116.3 ± 0.6% | 3456.6 ± 0.9% | 354.5 ± 0.3% | 1431.8 ± 0.7% | 1055.5 ± 0.3% | 1.978 | 1.211 | 11.807 | 2.923 | 3.966 |
| string: silesia/webster | 1098490 | 4043.9 ± 0.8% | 1879.9 ± 0.5% | 2058.7 ± 0.6% | 441.5 ± 0.8% | 1394.8 ± 0.2% | 645.5 ± 0.7% | 2.151 | 1.964 | 9.159 | 2.899 | 6.265 |
| string: silesia/xml | 1090118 | 6130.5 ± 0.5% | 2868.6 ± 0.1% | 2650.4 ± 0.5% | 611.7 ± 1.1% | 1759.1 ± 0.6% | 924.5 ± 0.4% | 2.137 | 2.313 | 10.023 | 3.485 | 6.631 |
| string: canterbury/alice29.txt | 159425 | 6404.5 ± 0.4% | 2196.1 ± 0.6% | 2759.8 ± 0.5% | 407.7 ± 1.0% | 1482.0 ± 0.2% | 954.6 ± 0.3% | 2.916 | 2.321 | 15.711 | 4.322 | 6.709 |
| string: canterbury/asyoulik.txt | 132198 | 5579.0 ± 0.9% | 1715.9 ± 0.5% | 2377.1 ± 0.8% | 402.0 ± 0.4% | 1345.8 ± 0.9% | 883.4 ± 0.2% | 3.251 | 2.347 | 13.879 | 4.146 | 6.316 |
| string: canterbury/lcet10.txt | 441884 | 6243.8 ± 0.8% | 2569.0 ± 0.4% | 2484.4 ± 2.3% | 467.0 ± 0.3% | 1541.2 ± 0.2% | 986.1 ± 0.6% | 2.430 | 2.513 | 13.370 | 4.051 | 6.332 |
| string: canterbury/plrabn12.txt | 503330 | 5710.4 ± 0.4% | 2054.4 ± 0.4% | 2072.3 ± 0.4% | 423.3 ± 0.7% | 1432.2 ± 0.4% | 930.0 ± 0.4% | 2.780 | 2.756 | 13.491 | 3.987 | 6.140 |
| string: canterbury-large/E.coli | 1048578 | 19308.4 ± 0.8% | 9728.3 ± 1.2% | 3787.9 ± 0.6% | 1478.6 ± 0.4% | 2364.2 ± 0.6% | 1193.5 ± 0.5% | 1.985 | 5.097 | 13.058 | 8.167 | 16.178 |
| string: canterbury-large/bible.txt | 1055886 | 6792.4 ± 0.8% | 4178.9 ± 1.2% | 3056.3 ± 2.0% | 504.2 ± 0.2% | 1969.9 ± 0.5% | 1120.2 ± 0.3% | 1.625 | 2.222 | 13.471 | 3.448 | 6.064 |
| string: canterbury-large/world192.txt | 1103121 | 4027.9 ± 0.5% | 1657.2 ± 0.6% | 2000.8 ± 0.8% | 446.7 ± 0.1% | 1359.2 ± 0.4% | 908.7 ± 0.4% | 2.431 | 2.013 | 9.017 | 2.963 | 4.432 |
| string: http/html-1m | 1058582 | 6730.9 ± 0.2% | 3988.4 ± 0.5% | 3032.7 ± 0.8% | 500.8 ± 0.7% | 1916.5 ± 0.3% | 803.9 ± 0.4% | 1.688 | 2.219 | 13.441 | 3.512 | 8.373 |
| string: http/json-1m | 1190272 | 3161.4 ± 0.4% | 1343.6 ± 0.3% | 1556.1 ± 0.1% | 442.8 ± 0.5% | 961.6 ± 0.4% | 763.3 ± 1.1% | 2.353 | 2.032 | 7.140 | 3.288 | 4.142 |
| string: http/js-1m | 1144362 | 2749.5 ± 0.5% | 1179.0 ± 0.3% | 1625.3 ± 0.5% | 368.3 ± 0.3% | 1094.6 ± 0.2% | 755.5 ± 0.4% | 2.332 | 1.692 | 7.465 | 2.512 | 3.639 |
| string: http/css-1m | 1097820 | 3976.0 ± 0.3% | 1485.9 ± 0.4% | 2154.8 ± 0.7% | 493.5 ± 0.2% | 1369.8 ± 0.4% | 892.9 ± 0.2% | 2.676 | 1.845 | 8.057 | 2.903 | 4.453 |
| string: dickens as Cyrillic and CJK | 1883069 | 3069.3 ± 0.5% | 2345.6 ± 0.3% | 521.5 ± 0.2% | 306.3 ± 0.6% | 560.4 ± 0.8% | 334.9 ± 0.4% | 1.308 | 5.885 | 10.019 | 5.477 | 9.164 |
| hex: silesia/dickens | 524290 | 15634.1 ± 0.4% | 1464.0 ± 0.3% | 1083.4 ± 0.4% | 502.3 ± 0.2% | 987.7 ± 0.4% | 733.9 ± 0.4% | 10.679 | 14.430 | 31.123 | 15.829 | 21.304 |
| hex: silesia/mozilla | 524290 | 15682.1 ± 0.2% | 1473.9 ± 0.5% | 1088.9 ± 0.3% | 442.5 ± 0.4% | 992.0 ± 0.4% | 733.6 ± 0.4% | 10.640 | 14.402 | 35.437 | 15.808 | 21.377 |
| hex: silesia/mr | 524290 | 15671.1 ± 0.2% | 1482.7 ± 0.2% | 1093.9 ± 0.5% | 558.3 ± 3.0% | 1000.3 ± 0.6% | 733.1 ± 0.3% | 10.569 | 14.326 | 28.071 | 15.667 | 21.375 |
| hex: silesia/nci | 524290 | 15641.7 ± 0.1% | 1473.3 ± 0.5% | 1090.9 ± 0.4% | 628.2 ± 4.5% | 993.2 ± 0.4% | 734.6 ± 0.3% | 10.617 | 14.339 | 24.900 | 15.749 | 21.294 |
| hex: silesia/ooffice | 524290 | 15557.8 ± 0.3% | 1467.5 ± 0.2% | 1083.9 ± 0.3% | 389.4 ± 0.3% | 991.2 ± 0.3% | 733.6 ± 0.3% | 10.602 | 14.353 | 39.958 | 15.696 | 21.209 |
| hex: silesia/osdb | 524290 | 15615.6 ± 0.2% | 1471.5 ± 0.2% | 1088.9 ± 0.3% | 468.9 ± 2.2% | 992.8 ± 0.5% | 732.6 ± 0.3% | 10.612 | 14.341 | 33.303 | 15.730 | 21.316 |
| hex: silesia/reymont | 524290 | 15684.2 ± 0.2% | 1468.7 ± 0.5% | 1084.8 ± 0.6% | 517.8 ± 1.1% | 991.3 ± 1.2% | 732.9 ± 0.5% | 10.679 | 14.459 | 30.291 | 15.821 | 21.400 |
| hex: silesia/samba | 524290 | 15645.2 ± 0.1% | 1466.9 ± 0.3% | 1088.2 ± 0.3% | 403.0 ± 0.4% | 990.5 ± 0.3% | 734.1 ± 0.3% | 10.665 | 14.377 | 38.819 | 15.795 | 21.312 |
| hex: silesia/sao | 524290 | 15663.5 ± 0.5% | 1466.0 ± 0.2% | 1085.0 ± 0.3% | 333.4 ± 0.6% | 990.6 ± 0.2% | 734.7 ± 0.4% | 10.685 | 14.436 | 46.977 | 15.812 | 21.319 |
| hex: silesia/webster | 524290 | 15643.8 ± 0.3% | 1468.3 ± 0.3% | 1084.8 ± 0.3% | 474.4 ± 0.3% | 989.9 ± 0.3% | 732.4 ± 0.2% | 10.654 | 14.421 | 32.976 | 15.803 | 21.359 |
| hex: silesia/x-ray | 524290 | 15618.7 ± 0.3% | 1475.8 ± 0.2% | 1090.6 ± 0.2% | 445.0 ± 1.3% | 997.0 ± 0.5% | 733.9 ± 0.7% | 10.583 | 14.321 | 35.095 | 15.666 | 21.282 |
| hex: silesia/xml | 524290 | 15587.6 ± 0.4% | 1470.2 ± 0.3% | 1089.3 ± 0.5% | 616.6 ± 1.1% | 991.9 ± 1.2% | 732.6 ± 0.5% | 10.603 | 14.309 | 25.282 | 15.715 | 21.277 |
| hex: canterbury/alice29.txt | 304180 | 15675.7 ± 0.1% | 1478.6 ± 0.8% | 1092.6 ± 0.3% | 494.8 ± 2.7% | 995.3 ± 0.3% | 733.2 ± 0.9% | 10.601 | 14.348 | 31.682 | 15.749 | 21.379 |
| hex: canterbury/asyoulik.txt | 250360 | 15696.4 ± 0.1% | 1483.6 ± 0.3% | 1093.1 ± 0.6% | 497.5 ± 1.1% | 995.9 ± 0.6% | 740.0 ± 0.3% | 10.580 | 14.359 | 31.551 | 15.761 | 21.211 |
| hex: canterbury/cp.html | 49208 | 15611.3 ± 0.1% | 1471.9 ± 0.6% | 1097.1 ± 0.3% | 531.1 ± 2.5% | 1001.8 ± 0.4% | 742.4 ± 0.3% | 10.606 | 14.229 | 29.396 | 15.583 | 21.029 |
| hex: canterbury/fields.c | 22302 | 15430.6 ± 0.1% | 1423.3 ± 0.6% | 1066.2 ± 0.6% | 610.4 ± 2.7% | 986.6 ± 0.1% | 737.1 ± 0.2% | 10.841 | 14.473 | 25.281 | 15.639 | 20.934 |
| hex: canterbury/grammar.lsp | 7444 | 14931.2 ± 0.1% | 1484.5 ± 0.7% | 1090.0 ± 0.6% | 674.7 ± 2.4% | 996.6 ± 0.1% | 725.8 ± 0.1% | 10.058 | 13.698 | 22.130 | 14.981 | 20.572 |
| hex: canterbury/kennedy.xls | 524290 | 15628.4 ± 0.3% | 1473.7 ± 0.5% | 1088.4 ± 0.7% | 657.8 ± 1.3% | 989.9 ± 0.4% | 733.5 ± 0.5% | 10.605 | 14.359 | 23.760 | 15.788 | 21.305 |
| hex: canterbury/lcet10.txt | 524290 | 15632.6 ± 0.3% | 1465.4 ± 0.2% | 1086.0 ± 0.3% | 500.4 ± 1.0% | 987.6 ± 0.8% | 733.6 ± 0.3% | 10.668 | 14.395 | 31.243 | 15.829 | 21.310 |
| hex: canterbury/plrabn12.txt | 524290 | 15690.7 ± 0.1% | 1466.1 ± 0.3% | 1082.5 ± 0.3% | 490.1 ± 1.8% | 990.7 ± 0.3% | 733.4 ± 0.3% | 10.702 | 14.494 | 32.014 | 15.838 | 21.395 |
| hex: canterbury/ptt5 | 524290 | 15650.9 ± 0.2% | 1483.7 ± 0.2% | 1091.3 ± 0.3% | 554.5 ± 1.2% | 995.0 ± 0.2% | 732.7 ± 0.4% | 10.549 | 14.341 | 28.224 | 15.729 | 21.362 |
| hex: canterbury/sum | 76482 | 15638.9 ± 0.1% | 1495.3 ± 0.1% | 1103.4 ± 0.1% | 596.0 ± 1.8% | 998.1 ± 0.1% | 742.1 ± 0.1% | 10.459 | 14.173 | 26.238 | 15.668 | 21.073 |
| hex: canterbury/xargs.1 | 8456 | 14988.6 ± 0.1% | 1437.4 ± 0.5% | 1095.9 ± 0.2% | 646.3 ± 6.0% | 1001.8 ± 0.7% | 726.3 ± 0.4% | 10.428 | 13.678 | 23.192 | 14.962 | 20.638 |
| hex: canterbury-large/E.coli | 524290 | 15637.1 ± 0.3% | 1476.3 ± 0.2% | 1092.7 ± 0.2% | 672.4 ± 0.3% | 993.5 ± 0.9% | 732.7 ± 0.3% | 10.592 | 14.311 | 23.254 | 15.740 | 21.343 |
| hex: canterbury-large/bible.txt | 524290 | 15640.6 ± 0.2% | 1466.4 ± 0.4% | 1085.9 ± 0.1% | 511.4 ± 0.6% | 989.0 ± 0.5% | 733.8 ± 0.4% | 10.666 | 14.404 | 30.582 | 15.814 | 21.316 |
| hex: canterbury-large/world192.txt | 524290 | 15560.8 ± 0.3% | 1469.3 ± 0.2% | 1087.1 ± 0.2% | 502.6 ± 0.9% | 990.5 ± 0.4% | 733.2 ± 0.3% | 10.591 | 14.315 | 30.958 | 15.710 | 21.222 |
| hex: http/html-1kx1024 | 2099200 | 13701.2 ± 0.2% | 1454.9 ± 0.0% | 1062.4 ± 0.2% | 501.0 ± 0.2% | 973.0 ± 0.1% | 692.3 ± 0.1% | 9.417 | 12.897 | 27.347 | 14.081 | 19.790 |
| hex: http/html-16kx64 | 2097280 | 15217.6 ± 1.8% | 1444.3 ± 0.7% | 1075.5 ± 0.2% | 507.4 ± 0.3% | 997.3 ± 0.4% | 733.8 ± 0.3% | 10.536 | 14.150 | 29.989 | 15.259 | 20.739 |
| hex: http/html-1m | 524290 | 15653.5 ± 0.1% | 1469.6 ± 0.4% | 1083.7 ± 0.5% | 501.1 ± 0.6% | 991.1 ± 0.6% | 732.9 ± 0.4% | 10.652 | 14.444 | 31.236 | 15.794 | 21.359 |
| hex: http/json-1kx1024 | 2099200 | 13668.8 ± 0.3% | 1464.0 ± 0.4% | 1066.5 ± 0.1% | 607.5 ± 0.2% | 987.0 ± 0.3% | 692.0 ± 0.1% | 9.337 | 12.817 | 22.500 | 13.849 | 19.754 |
| hex: http/json-16kx64 | 2097280 | 15250.5 ± 0.4% | 1447.6 ± 0.3% | 1078.9 ± 0.4% | 617.1 ± 0.7% | 997.2 ± 0.1% | 733.8 ± 0.2% | 10.535 | 14.135 | 24.714 | 15.294 | 20.782 |
| hex: http/json-1m | 524290 | 15670.5 ± 0.3% | 1477.9 ± 0.3% | 1090.8 ± 0.3% | 632.0 ± 1.1% | 992.5 ± 0.4% | 731.8 ± 0.6% | 10.604 | 14.366 | 24.795 | 15.789 | 21.415 |
| hex: http/js-1kx1024 | 2099200 | 13687.5 ± 0.4% | 1456.1 ± 0.3% | 1064.3 ± 0.6% | 499.4 ± 0.1% | 984.4 ± 0.2% | 692.3 ± 0.4% | 9.400 | 12.861 | 27.409 | 13.904 | 19.771 |
| hex: http/js-16kx64 | 2097280 | 15218.8 ± 0.4% | 1441.5 ± 0.3% | 1074.1 ± 0.4% | 504.6 ± 0.3% | 998.1 ± 0.4% | 735.3 ± 0.2% | 10.557 | 14.169 | 30.162 | 15.248 | 20.697 |
| hex: http/js-1m | 524290 | 15639.7 ± 0.3% | 1467.2 ± 0.1% | 1086.0 ± 0.4% | 511.1 ± 0.2% | 989.6 ± 0.4% | 733.9 ± 0.4% | 10.660 | 14.401 | 30.600 | 15.804 | 21.311 |
| hex: http/css-1kx1024 | 2099200 | 13619.3 ± 0.5% | 1455.9 ± 0.2% | 1062.6 ± 0.2% | 532.0 ± 0.3% | 983.6 ± 0.2% | 692.6 ± 0.4% | 9.354 | 12.817 | 25.599 | 13.846 | 19.664 |
| hex: http/css-16kx64 | 2097280 | 15214.3 ± 0.3% | 1446.0 ± 0.2% | 1073.9 ± 0.2% | 540.8 ± 0.3% | 999.8 ± 0.4% | 735.3 ± 0.3% | 10.522 | 14.167 | 28.134 | 15.217 | 20.691 |
| hex: http/css-1m | 524290 | 15662.6 ± 0.6% | 1468.4 ± 0.5% | 1084.1 ± 0.2% | 527.0 ± 0.8% | 991.6 ± 0.6% | 734.0 ± 0.6% | 10.666 | 14.447 | 29.723 | 15.795 | 21.338 |
| hex: shuffled/dickens-1m | 524290 | 15656.7 ± 0.3% | 1462.5 ± 0.5% | 1084.2 ± 0.5% | 503.0 ± 0.7% | 989.1 ± 0.2% | 734.7 ± 0.4% | 10.705 | 14.440 | 31.128 | 15.830 | 21.310 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1530.2 ± 0.9% | 1258.5 ± 0.6% | 1043.2 ± 0.5% | 409.6 ± 0.3% | 448.8 ± 0.3% | 416.3 ± 0.5% | 1.216 | 1.467 | 3.736 | 3.410 | 3.676 |
| qlog records, JSON text sequence | 1467503 | 1293.6 ± 0.2% | 1062.5 ± 0.7% | 792.5 ± 0.8% | 378.0 ± 1.1% | 471.8 ± 1.3% | 279.0 ± 0.3% | 1.218 | 1.632 | 3.422 | 2.742 | 4.636 |
| string: silesia/dickens | 172528 | 7122.8 ± 0.5% | 2817.1 ± 0.7% | 2924.9 ± 0.4% | 429.8 ± 0.8% | 1592.5 ± 0.2% | 1007.2 ± 0.2% | 2.528 | 2.435 | 16.572 | 4.473 | 7.072 |
| string: silesia/nci | 1075110 | 7358.7 ± 6.5% | 3407.2 ± 1.8% | 3094.3 ± 0.6% | 821.2 ± 2.0% | 1860.8 ± 0.4% | 1107.7 ± 0.2% | 2.160 | 2.378 | 8.961 | 3.955 | 6.643 |
| string: silesia/reymont | 1075159 | 3502.3 ± 1.8% | 1971.6 ± 0.3% | 2060.7 ± 0.8% | 449.6 ± 1.1% | 1510.4 ± 0.7% | 949.7 ± 0.6% | 1.776 | 1.700 | 7.789 | 2.319 | 3.688 |
| string: silesia/samba | 97582 | 4577.9 ± 0.7% | 2116.3 ± 0.6% | 3456.6 ± 0.9% | 354.5 ± 0.3% | 1431.8 ± 0.7% | 1055.5 ± 0.3% | 2.163 | 1.324 | 12.913 | 3.197 | 4.337 |
| string: silesia/webster | 1098490 | 4091.9 ± 0.7% | 1879.9 ± 0.5% | 2058.7 ± 0.6% | 441.5 ± 0.8% | 1394.8 ± 0.2% | 645.5 ± 0.7% | 2.177 | 1.988 | 9.267 | 2.934 | 6.340 |
| string: silesia/xml | 1090118 | 6222.8 ± 0.7% | 2868.6 ± 0.1% | 2650.4 ± 0.5% | 611.7 ± 1.1% | 1759.1 ± 0.6% | 924.5 ± 0.4% | 2.169 | 2.348 | 10.174 | 3.538 | 6.731 |
| string: canterbury/alice29.txt | 159425 | 6833.5 ± 0.5% | 2196.1 ± 0.6% | 2759.8 ± 0.5% | 407.7 ± 1.0% | 1482.0 ± 0.2% | 954.6 ± 0.3% | 3.112 | 2.476 | 16.763 | 4.611 | 7.159 |
| string: canterbury/asyoulik.txt | 132198 | 5901.3 ± 2.5% | 1715.9 ± 0.5% | 2377.1 ± 0.8% | 402.0 ± 0.4% | 1345.8 ± 0.9% | 883.4 ± 0.2% | 3.439 | 2.483 | 14.681 | 4.385 | 6.681 |
| string: canterbury/lcet10.txt | 441884 | 6256.0 ± 0.7% | 2569.0 ± 0.4% | 2484.4 ± 2.3% | 467.0 ± 0.3% | 1541.2 ± 0.2% | 986.1 ± 0.6% | 2.435 | 2.518 | 13.396 | 4.059 | 6.344 |
| string: canterbury/plrabn12.txt | 503330 | 5747.4 ± 0.4% | 2054.4 ± 0.4% | 2072.3 ± 0.4% | 423.3 ± 0.7% | 1432.2 ± 0.4% | 930.0 ± 0.4% | 2.798 | 2.773 | 13.578 | 4.013 | 6.180 |
| string: canterbury-large/E.coli | 1048578 | 19345.3 ± 0.8% | 9728.3 ± 1.2% | 3787.9 ± 0.6% | 1478.6 ± 0.4% | 2364.2 ± 0.6% | 1193.5 ± 0.5% | 1.989 | 5.107 | 13.083 | 8.183 | 16.209 |
| string: canterbury-large/bible.txt | 1055886 | 6798.7 ± 0.5% | 4178.9 ± 1.2% | 3056.3 ± 2.0% | 504.2 ± 0.2% | 1969.9 ± 0.5% | 1120.2 ± 0.3% | 1.627 | 2.224 | 13.484 | 3.451 | 6.069 |
| string: canterbury-large/world192.txt | 1103121 | 4032.2 ± 0.6% | 1657.2 ± 0.6% | 2000.8 ± 0.8% | 446.7 ± 0.1% | 1359.2 ± 0.4% | 908.7 ± 0.4% | 2.433 | 2.015 | 9.026 | 2.967 | 4.437 |
| string: http/html-1m | 1058582 | 6819.3 ± 0.6% | 3988.4 ± 0.5% | 3032.7 ± 0.8% | 500.8 ± 0.7% | 1916.5 ± 0.3% | 803.9 ± 0.4% | 1.710 | 2.249 | 13.617 | 3.558 | 8.483 |
| string: http/json-1m | 1190272 | 3295.0 ± 0.4% | 1343.6 ± 0.3% | 1556.1 ± 0.1% | 442.8 ± 0.5% | 961.6 ± 0.4% | 763.3 ± 1.1% | 2.452 | 2.118 | 7.441 | 3.427 | 4.317 |
| string: http/js-1m | 1144362 | 2786.6 ± 1.3% | 1179.0 ± 0.3% | 1625.3 ± 0.5% | 368.3 ± 0.3% | 1094.6 ± 0.2% | 755.5 ± 0.4% | 2.363 | 1.715 | 7.566 | 2.546 | 3.689 |
| string: http/css-1m | 1097820 | 4038.6 ± 0.5% | 1485.9 ± 0.4% | 2154.8 ± 0.7% | 493.5 ± 0.2% | 1369.8 ± 0.4% | 892.9 ± 0.2% | 2.718 | 1.874 | 8.184 | 2.948 | 4.523 |
| string: dickens as Cyrillic and CJK | 1883069 | 3072.7 ± 0.7% | 2345.6 ± 0.3% | 521.5 ± 0.2% | 306.3 ± 0.6% | 560.4 ± 0.8% | 334.9 ± 0.4% | 1.310 | 5.892 | 10.030 | 5.483 | 9.175 |
| hex: silesia/dickens | 524290 | 15609.8 ± 0.4% | 1464.0 ± 0.3% | 1083.4 ± 0.4% | 502.3 ± 0.2% | 987.7 ± 0.4% | 733.9 ± 0.4% | 10.663 | 14.408 | 31.074 | 15.805 | 21.270 |
| hex: silesia/mozilla | 524290 | 15646.0 ± 0.6% | 1473.9 ± 0.5% | 1088.9 ± 0.3% | 442.5 ± 0.4% | 992.0 ± 0.4% | 733.6 ± 0.4% | 10.616 | 14.369 | 35.356 | 15.772 | 21.328 |
| hex: silesia/mr | 524290 | 15701.6 ± 0.3% | 1482.7 ± 0.2% | 1093.9 ± 0.5% | 558.3 ± 3.0% | 1000.3 ± 0.6% | 733.1 ± 0.3% | 10.590 | 14.354 | 28.125 | 15.698 | 21.417 |
| hex: silesia/nci | 524290 | 15683.2 ± 0.2% | 1473.3 ± 0.5% | 1090.9 ± 0.4% | 628.2 ± 4.5% | 993.2 ± 0.4% | 734.6 ± 0.3% | 10.645 | 14.377 | 24.966 | 15.791 | 21.351 |
| hex: silesia/ooffice | 524290 | 15591.3 ± 0.4% | 1467.5 ± 0.2% | 1083.9 ± 0.3% | 389.4 ± 0.3% | 991.2 ± 0.3% | 733.6 ± 0.3% | 10.625 | 14.384 | 40.044 | 15.729 | 21.254 |
| hex: silesia/osdb | 524290 | 15625.9 ± 0.2% | 1471.5 ± 0.2% | 1088.9 ± 0.3% | 468.9 ± 2.2% | 992.8 ± 0.5% | 732.6 ± 0.3% | 10.619 | 14.351 | 33.325 | 15.740 | 21.330 |
| hex: silesia/reymont | 524290 | 15697.2 ± 0.2% | 1468.7 ± 0.5% | 1084.8 ± 0.6% | 517.8 ± 1.1% | 991.3 ± 1.2% | 732.9 ± 0.5% | 10.688 | 14.471 | 30.316 | 15.834 | 21.418 |
| hex: silesia/samba | 524290 | 15627.3 ± 0.7% | 1466.9 ± 0.3% | 1088.2 ± 0.3% | 403.0 ± 0.4% | 990.5 ± 0.3% | 734.1 ± 0.3% | 10.653 | 14.361 | 38.775 | 15.777 | 21.288 |
| hex: silesia/sao | 524290 | 15683.5 ± 0.1% | 1466.0 ± 0.2% | 1085.0 ± 0.3% | 333.4 ± 0.6% | 990.6 ± 0.2% | 734.7 ± 0.4% | 10.698 | 14.454 | 47.037 | 15.832 | 21.346 |
| hex: silesia/webster | 524290 | 15699.7 ± 0.3% | 1468.3 ± 0.3% | 1084.8 ± 0.3% | 474.4 ± 0.3% | 989.9 ± 0.3% | 732.4 ± 0.2% | 10.692 | 14.472 | 33.094 | 15.860 | 21.436 |
| hex: silesia/x-ray | 524290 | 15638.7 ± 0.2% | 1475.8 ± 0.2% | 1090.6 ± 0.2% | 445.0 ± 1.3% | 997.0 ± 0.5% | 733.9 ± 0.7% | 10.597 | 14.339 | 35.140 | 15.686 | 21.309 |
| hex: silesia/xml | 524290 | 15646.6 ± 0.4% | 1470.2 ± 0.3% | 1089.3 ± 0.5% | 616.6 ± 1.1% | 991.9 ± 1.2% | 732.6 ± 0.5% | 10.643 | 14.364 | 25.377 | 15.774 | 21.358 |
| hex: canterbury/alice29.txt | 304180 | 15691.4 ± 0.1% | 1478.6 ± 0.8% | 1092.6 ± 0.3% | 494.8 ± 2.7% | 995.3 ± 0.3% | 733.2 ± 0.9% | 10.612 | 14.362 | 31.714 | 15.765 | 21.400 |
| hex: canterbury/asyoulik.txt | 250360 | 15707.5 ± 0.1% | 1483.6 ± 0.3% | 1093.1 ± 0.6% | 497.5 ± 1.1% | 995.9 ± 0.6% | 740.0 ± 0.3% | 10.587 | 14.369 | 31.573 | 15.773 | 21.226 |
| hex: canterbury/cp.html | 49208 | 15637.8 ± 0.1% | 1471.9 ± 0.6% | 1097.1 ± 0.3% | 531.1 ± 2.5% | 1001.8 ± 0.4% | 742.4 ± 0.3% | 10.624 | 14.254 | 29.446 | 15.609 | 21.065 |
| hex: canterbury/fields.c | 22302 | 15454.5 ± 0.1% | 1423.3 ± 0.6% | 1066.2 ± 0.6% | 610.4 ± 2.7% | 986.6 ± 0.1% | 737.1 ± 0.2% | 10.858 | 14.495 | 25.320 | 15.664 | 20.967 |
| hex: canterbury/grammar.lsp | 7444 | 14991.9 ± 0.0% | 1484.5 ± 0.7% | 1090.0 ± 0.6% | 674.7 ± 2.4% | 996.6 ± 0.1% | 725.8 ± 0.1% | 10.099 | 13.754 | 22.220 | 15.042 | 20.655 |
| hex: canterbury/kennedy.xls | 524290 | 15639.2 ± 0.2% | 1473.7 ± 0.5% | 1088.4 ± 0.7% | 657.8 ± 1.3% | 989.9 ± 0.4% | 733.5 ± 0.5% | 10.612 | 14.369 | 23.776 | 15.799 | 21.320 |
| hex: canterbury/lcet10.txt | 524290 | 15645.1 ± 0.5% | 1465.4 ± 0.2% | 1086.0 ± 0.3% | 500.4 ± 1.0% | 987.6 ± 0.8% | 733.6 ± 0.3% | 10.677 | 14.406 | 31.268 | 15.841 | 21.327 |
| hex: canterbury/plrabn12.txt | 524290 | 15710.2 ± 0.2% | 1466.1 ± 0.3% | 1082.5 ± 0.3% | 490.1 ± 1.8% | 990.7 ± 0.3% | 733.4 ± 0.3% | 10.715 | 14.512 | 32.054 | 15.857 | 21.422 |
| hex: canterbury/ptt5 | 524290 | 15667.3 ± 0.1% | 1483.7 ± 0.2% | 1091.3 ± 0.3% | 554.5 ± 1.2% | 995.0 ± 0.2% | 732.7 ± 0.4% | 10.560 | 14.356 | 28.253 | 15.746 | 21.384 |
| hex: canterbury/sum | 76482 | 15653.7 ± 0.1% | 1495.3 ± 0.1% | 1103.4 ± 0.1% | 596.0 ± 1.8% | 998.1 ± 0.1% | 742.1 ± 0.1% | 10.469 | 14.186 | 26.263 | 15.683 | 21.093 |
| hex: canterbury/xargs.1 | 8456 | 15034.8 ± 0.0% | 1437.4 ± 0.5% | 1095.9 ± 0.2% | 646.3 ± 6.0% | 1001.8 ± 0.7% | 726.3 ± 0.4% | 10.460 | 13.720 | 23.264 | 15.008 | 20.702 |
| hex: canterbury-large/E.coli | 524290 | 15630.2 ± 0.1% | 1476.3 ± 0.2% | 1092.7 ± 0.2% | 672.4 ± 0.3% | 993.5 ± 0.9% | 732.7 ± 0.3% | 10.587 | 14.304 | 23.244 | 15.733 | 21.333 |
| hex: canterbury-large/bible.txt | 524290 | 15640.8 ± 0.3% | 1466.4 ± 0.4% | 1085.9 ± 0.1% | 511.4 ± 0.6% | 989.0 ± 0.5% | 733.8 ± 0.4% | 10.666 | 14.404 | 30.583 | 15.814 | 21.316 |
| hex: canterbury-large/world192.txt | 524290 | 15578.1 ± 0.5% | 1469.3 ± 0.2% | 1087.1 ± 0.2% | 502.6 ± 0.9% | 990.5 ± 0.4% | 733.2 ± 0.3% | 10.603 | 14.330 | 30.993 | 15.728 | 21.245 |
| hex: http/html-1kx1024 | 2099200 | 13959.0 ± 0.2% | 1454.9 ± 0.0% | 1062.4 ± 0.2% | 501.0 ± 0.2% | 973.0 ± 0.1% | 692.3 ± 0.1% | 9.594 | 13.140 | 27.861 | 14.346 | 20.163 |
| hex: http/html-16kx64 | 2097280 | 15299.9 ± 0.3% | 1444.3 ± 0.7% | 1075.5 ± 0.2% | 507.4 ± 0.3% | 997.3 ± 0.4% | 733.8 ± 0.3% | 10.593 | 14.226 | 30.151 | 15.341 | 20.851 |
| hex: http/html-1m | 524290 | 15671.1 ± 0.1% | 1469.6 ± 0.4% | 1083.7 ± 0.5% | 501.1 ± 0.6% | 991.1 ± 0.6% | 732.9 ± 0.4% | 10.664 | 14.460 | 31.271 | 15.812 | 21.383 |
| hex: http/json-1kx1024 | 2099200 | 13861.5 ± 0.6% | 1464.0 ± 0.4% | 1066.5 ± 0.1% | 607.5 ± 0.2% | 987.0 ± 0.3% | 692.0 ± 0.1% | 9.468 | 12.997 | 22.817 | 14.044 | 20.033 |
| hex: http/json-16kx64 | 2097280 | 15264.4 ± 0.3% | 1447.6 ± 0.3% | 1078.9 ± 0.4% | 617.1 ± 0.7% | 997.2 ± 0.1% | 733.8 ± 0.2% | 10.545 | 14.148 | 24.736 | 15.308 | 20.801 |
| hex: http/json-1m | 524290 | 15658.7 ± 0.5% | 1477.9 ± 0.3% | 1090.8 ± 0.3% | 632.0 ± 1.1% | 992.5 ± 0.4% | 731.8 ± 0.6% | 10.596 | 14.355 | 24.776 | 15.778 | 21.398 |
| hex: http/js-1kx1024 | 2099200 | 13862.3 ± 0.6% | 1456.1 ± 0.3% | 1064.3 ± 0.6% | 499.4 ± 0.1% | 984.4 ± 0.2% | 692.3 ± 0.4% | 9.520 | 13.025 | 27.759 | 14.082 | 20.024 |
| hex: http/js-16kx64 | 2097280 | 15306.1 ± 0.8% | 1441.5 ± 0.3% | 1074.1 ± 0.4% | 504.6 ± 0.3% | 998.1 ± 0.4% | 735.3 ± 0.2% | 10.618 | 14.251 | 30.335 | 15.335 | 20.815 |
| hex: http/js-1m | 524290 | 15649.7 ± 0.5% | 1467.2 ± 0.1% | 1086.0 ± 0.4% | 511.1 ± 0.2% | 989.6 ± 0.4% | 733.9 ± 0.4% | 10.667 | 14.410 | 30.620 | 15.814 | 21.325 |
| hex: http/css-1kx1024 | 2099200 | 13852.3 ± 1.0% | 1455.9 ± 0.2% | 1062.6 ± 0.2% | 532.0 ± 0.3% | 983.6 ± 0.2% | 692.6 ± 0.4% | 9.514 | 13.036 | 26.037 | 14.083 | 20.001 |
| hex: http/css-16kx64 | 2097280 | 15312.0 ± 0.4% | 1446.0 ± 0.2% | 1073.9 ± 0.2% | 540.8 ± 0.3% | 999.8 ± 0.4% | 735.3 ± 0.3% | 10.589 | 14.258 | 28.315 | 15.315 | 20.824 |
| hex: http/css-1m | 524290 | 15626.4 ± 0.6% | 1468.4 ± 0.5% | 1084.1 ± 0.2% | 527.0 ± 0.8% | 991.6 ± 0.6% | 734.0 ± 0.6% | 10.642 | 14.414 | 29.654 | 15.758 | 21.289 |
| hex: shuffled/dickens-1m | 524290 | 15661.6 ± 0.5% | 1462.5 ± 0.5% | 1084.2 ± 0.5% | 503.0 ± 0.7% | 989.1 ± 0.2% | 734.7 ± 0.4% | 10.708 | 14.445 | 31.138 | 15.835 | 21.317 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.2 ± 0.2% | 925.8 ± 0.7% | 1022.3 ± 0.4% | 301.2 ± 0.4% | 667.6 ± 0.2% | 310.0 ± 1.4% | 1.012 | 0.917 | 3.111 | 1.404 | 3.023 |
| qlog records, JSON text sequence | 1467503 | 783.2 ± 0.7% | 817.0 ± 0.2% | 792.9 ± 1.4% | 243.3 ± 0.9% | 703.8 ± 0.5% | 250.9 ± 0.8% | 0.959 | 0.988 | 3.219 | 1.113 | 3.121 |
| string: silesia/dickens | 172528 | 5056.3 ± 0.4% | 1877.0 ± 0.2% | 2642.5 ± 0.6% | 360.6 ± 0.2% | 2845.4 ± 0.3% | 550.5 ± 1.2% | 2.694 | 1.913 | 14.022 | 1.777 | 9.184 |
| string: silesia/nci | 1075110 | 4308.5 ± 0.7% | 2239.4 ± 0.4% | 3001.9 ± 0.2% | 544.5 ± 0.5% | 3004.6 ± 0.6% | 603.1 ± 1.7% | 1.924 | 1.435 | 7.912 | 1.434 | 7.144 |
| string: silesia/reymont | 1075159 | 2977.1 ± 1.1% | 1814.9 ± 1.9% | 2062.6 ± 1.1% | 374.1 ± 1.9% | 2145.1 ± 0.7% | 536.3 ± 2.6% | 1.640 | 1.443 | 7.958 | 1.388 | 5.551 |
| string: silesia/samba | 97582 | 3503.0 ± 0.3% | 2025.8 ± 0.4% | 2616.1 ± 0.2% | 328.3 ± 0.3% | 1500.6 ± 0.2% | 430.4 ± 0.7% | 1.729 | 1.339 | 10.669 | 2.334 | 8.139 |
| string: silesia/webster | 1098490 | 3678.9 ± 1.0% | 1517.1 ± 0.2% | 2018.2 ± 0.7% | 358.0 ± 0.8% | 2186.5 ± 0.3% | 498.8 ± 1.0% | 2.425 | 1.823 | 10.275 | 1.683 | 7.376 |
| string: silesia/xml | 1090118 | 4833.0 ± 0.4% | 2354.5 ± 0.2% | 2524.7 ± 0.5% | 457.0 ± 0.6% | 2873.5 ± 0.7% | 563.3 ± 1.4% | 2.053 | 1.914 | 10.576 | 1.682 | 8.579 |
| string: canterbury/alice29.txt | 159425 | 4338.9 ± 0.2% | 1598.7 ± 0.3% | 2455.5 ± 0.9% | 342.3 ± 0.4% | 2496.3 ± 0.3% | 508.1 ± 0.9% | 2.714 | 1.767 | 12.677 | 1.738 | 8.540 |
| string: canterbury/asyoulik.txt | 132198 | 3496.0 ± 0.5% | 1459.7 ± 0.3% | 2246.3 ± 0.9% | 335.0 ± 1.3% | 2077.6 ± 0.5% | 459.2 ± 1.4% | 2.395 | 1.556 | 10.436 | 1.683 | 7.613 |
| string: canterbury/lcet10.txt | 441884 | 5105.2 ± 0.3% | 1853.2 ± 0.3% | 2341.0 ± 1.0% | 390.8 ± 0.5% | 2842.5 ± 0.7% | 536.7 ± 2.3% | 2.755 | 2.181 | 13.064 | 1.796 | 9.513 |
| string: canterbury/plrabn12.txt | 503330 | 4138.2 ± 0.4% | 1735.5 ± 0.3% | 2066.7 ± 0.4% | 359.7 ± 0.8% | 2495.4 ± 0.4% | 500.7 ± 0.8% | 2.384 | 2.002 | 11.505 | 1.658 | 8.265 |
| string: canterbury-large/E.coli | 1048578 | 11936.8 ± 0.1% | 3608.5 ± 0.4% | 3258.3 ± 0.5% | 932.0 ± 1.4% | 6010.5 ± 1.1% | 765.4 ± 1.4% | 3.308 | 3.663 | 12.808 | 1.986 | 15.595 |
| string: canterbury-large/bible.txt | 1055886 | 6921.8 ± 0.7% | 2947.6 ± 0.4% | 2832.3 ± 0.5% | 418.8 ± 2.4% | 3752.6 ± 1.4% | 619.0 ± 1.0% | 2.348 | 2.444 | 16.530 | 1.845 | 11.182 |
| string: canterbury-large/world192.txt | 1103121 | 3396.7 ± 0.2% | 1483.8 ± 0.1% | 2016.3 ± 0.8% | 352.3 ± 0.4% | 2124.7 ± 0.6% | 503.0 ± 0.8% | 2.289 | 1.685 | 9.642 | 1.599 | 6.754 |
| string: http/html-1m | 1058582 | 6219.5 ± 0.5% | 2741.1 ± 0.7% | 2702.6 ± 0.3% | 442.1 ± 0.8% | 3487.3 ± 0.7% | 595.7 ± 1.1% | 2.269 | 2.301 | 14.070 | 1.783 | 10.441 |
| string: http/json-1m | 1190272 | 2564.6 ± 0.5% | 877.6 ± 0.1% | 2252.6 ± 0.6% | 389.9 ± 0.4% | 1064.6 ± 0.4% | 443.6 ± 0.5% | 2.922 | 1.138 | 6.578 | 2.409 | 5.782 |
| string: http/js-1m | 1144362 | 2284.4 ± 0.4% | 1029.3 ± 0.1% | 1639.2 ± 0.4% | 320.6 ± 0.5% | 1528.9 ± 0.3% | 420.4 ± 0.6% | 2.219 | 1.394 | 7.125 | 1.494 | 5.434 |
| string: http/css-1m | 1097820 | 2650.5 ± 0.8% | 1679.1 ± 0.6% | 2230.3 ± 0.4% | 405.0 ± 1.2% | 1960.6 ± 0.1% | 490.2 ± 1.2% | 1.579 | 1.188 | 6.544 | 1.352 | 5.407 |
| string: dickens as Cyrillic and CJK | 1883069 | 3088.9 ± 0.3% | 1686.1 ± 0.4% | 894.3 ± 0.3% | 351.6 ± 0.2% | 671.2 ± 0.3% | 158.2 ± 1.7% | 1.832 | 3.454 | 8.786 | 4.602 | 19.529 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.9 ± 0.2% | 979.7 ± 0.3% | 1209.4 ± 0.7% | 215.9 ± 0.1% | 472.1 ± 0.4% | 256.0 ± 3.7% | 1.357 | 1.100 | 6.160 | 2.817 | 5.195 |
| hex: silesia/dickens | 524290 | 11991.7 ± 0.1% | 3620.0 ± 0.2% | 3292.4 ± 0.2% | 512.4 ± 1.9% | 6108.6 ± 1.6% | 780.4 ± 1.8% | 3.313 | 3.642 | 23.402 | 1.963 | 15.367 |
| hex: silesia/mozilla | 524290 | 12016.4 ± 0.2% | 3616.0 ± 0.3% | 3294.8 ± 0.6% | 450.5 ± 1.5% | 6125.0 ± 1.2% | 783.5 ± 0.6% | 3.323 | 3.647 | 26.671 | 1.962 | 15.337 |
| hex: silesia/mr | 524290 | 11989.7 ± 0.1% | 3616.9 ± 0.2% | 3296.4 ± 0.2% | 560.9 ± 3.6% | 6116.0 ± 1.0% | 782.9 ± 0.7% | 3.315 | 3.637 | 21.374 | 1.960 | 15.314 |
| hex: silesia/nci | 524290 | 12004.9 ± 0.1% | 3616.4 ± 0.2% | 3290.7 ± 0.4% | 613.3 ± 5.6% | 6092.3 ± 1.1% | 784.4 ± 0.7% | 3.320 | 3.648 | 19.575 | 1.971 | 15.304 |
| hex: silesia/ooffice | 524290 | 12015.7 ± 0.1% | 3619.0 ± 0.3% | 3305.9 ± 0.2% | 396.1 ± 2.0% | 6140.3 ± 0.9% | 783.5 ± 0.7% | 3.320 | 3.635 | 30.336 | 1.957 | 15.335 |
| hex: silesia/osdb | 524290 | 11978.0 ± 0.2% | 3615.1 ± 0.4% | 3296.3 ± 0.8% | 480.3 ± 1.8% | 6106.5 ± 0.7% | 784.1 ± 0.7% | 3.313 | 3.634 | 24.938 | 1.961 | 15.276 |
| hex: silesia/reymont | 524290 | 12000.5 ± 0.1% | 3618.1 ± 0.2% | 3297.1 ± 0.3% | 515.0 ± 1.6% | 6125.7 ± 1.3% | 783.0 ± 0.9% | 3.317 | 3.640 | 23.302 | 1.959 | 15.327 |
| hex: silesia/samba | 524290 | 12015.4 ± 0.1% | 3615.9 ± 0.2% | 3298.1 ± 0.4% | 406.2 ± 3.7% | 6138.9 ± 1.8% | 784.6 ± 1.3% | 3.323 | 3.643 | 29.577 | 1.957 | 15.314 |
| hex: silesia/sao | 524290 | 11984.4 ± 0.2% | 3615.7 ± 0.4% | 3292.7 ± 0.4% | 344.2 ± 1.9% | 6011.5 ± 1.0% | 784.5 ± 0.4% | 3.315 | 3.640 | 34.816 | 1.994 | 15.277 |
| hex: silesia/webster | 524290 | 12013.2 ± 0.2% | 3609.4 ± 0.3% | 3300.0 ± 0.5% | 463.7 ± 0.9% | 6132.3 ± 0.9% | 783.5 ± 0.8% | 3.328 | 3.640 | 25.907 | 1.959 | 15.333 |
| hex: silesia/x-ray | 524290 | 11991.3 ± 0.2% | 3616.8 ± 0.2% | 3298.3 ± 0.4% | 476.7 ± 2.6% | 6146.4 ± 1.8% | 784.7 ± 0.6% | 3.315 | 3.636 | 25.156 | 1.951 | 15.281 |
| hex: silesia/xml | 524290 | 11999.4 ± 0.1% | 3610.5 ± 0.2% | 3293.7 ± 0.5% | 527.4 ± 0.4% | 6080.6 ± 1.3% | 784.1 ± 0.5% | 3.324 | 3.643 | 22.750 | 1.973 | 15.303 |
| hex: canterbury/alice29.txt | 304180 | 12006.7 ± 0.0% | 3631.8 ± 0.1% | 3377.3 ± 0.1% | 518.7 ± 0.2% | 6105.8 ± 0.8% | 784.0 ± 1.7% | 3.306 | 3.555 | 23.147 | 1.966 | 15.314 |
| hex: canterbury/asyoulik.txt | 250360 | 12002.3 ± 0.0% | 3640.8 ± 0.1% | 3366.7 ± 0.1% | 511.4 ± 0.2% | 6113.3 ± 2.9% | 781.2 ± 0.5% | 3.297 | 3.565 | 23.471 | 1.963 | 15.363 |
| hex: canterbury/cp.html | 49208 | 11916.1 ± 0.1% | 3638.7 ± 0.0% | 3291.8 ± 0.2% | 475.8 ± 3.0% | 6282.0 ± 0.6% | 767.7 ± 1.1% | 3.275 | 3.620 | 25.045 | 1.897 | 15.521 |
| hex: canterbury/fields.c | 22302 | 11778.8 ± 0.0% | 3629.3 ± 0.1% | 3365.8 ± 0.2% | 505.6 ± 1.4% | 6256.1 ± 0.3% | 760.0 ± 2.7% | 3.245 | 3.500 | 23.295 | 1.883 | 15.498 |
| hex: canterbury/grammar.lsp | 7444 | 11257.4 ± 0.1% | 3602.2 ± 0.1% | 3355.5 ± 0.1% | 546.0 ± 2.3% | 6174.7 ± 0.3% | 733.5 ± 1.5% | 3.125 | 3.355 | 20.619 | 1.823 | 15.347 |
| hex: canterbury/kennedy.xls | 524290 | 11992.7 ± 0.2% | 3605.9 ± 0.6% | 3291.4 ± 0.4% | 666.4 ± 3.8% | 6107.9 ± 0.9% | 772.7 ± 7.4% | 3.326 | 3.644 | 17.996 | 1.963 | 15.520 |
| hex: canterbury/lcet10.txt | 524290 | 11984.2 ± 0.3% | 3616.2 ± 0.1% | 3291.4 ± 0.2% | 526.5 ± 1.7% | 6105.6 ± 0.7% | 774.5 ± 0.4% | 3.314 | 3.641 | 22.762 | 1.963 | 15.473 |
| hex: canterbury/plrabn12.txt | 524290 | 12013.7 ± 0.2% | 3612.8 ± 0.2% | 3294.4 ± 0.3% | 517.2 ± 0.3% | 6132.1 ± 1.6% | 773.0 ± 0.6% | 3.325 | 3.647 | 23.227 | 1.959 | 15.542 |
| hex: canterbury/ptt5 | 524290 | 12024.0 ± 0.1% | 3615.5 ± 0.2% | 3295.2 ± 0.2% | 567.5 ± 0.4% | 6065.9 ± 1.9% | 774.7 ± 0.8% | 3.326 | 3.649 | 21.189 | 1.982 | 15.521 |
| hex: canterbury/sum | 76482 | 11914.3 ± 0.1% | 3634.4 ± 0.0% | 3355.5 ± 0.3% | 517.2 ± 1.3% | 6165.5 ± 0.5% | 773.1 ± 1.3% | 3.278 | 3.551 | 23.038 | 1.932 | 15.411 |
| hex: canterbury/xargs.1 | 8456 | 11351.3 ± 0.2% | 3602.5 ± 0.0% | 3384.5 ± 0.3% | 503.7 ± 2.4% | 6145.9 ± 0.4% | 758.3 ± 0.6% | 3.151 | 3.354 | 22.536 | 1.847 | 14.969 |
| hex: canterbury-large/E.coli | 524290 | 11962.4 ± 0.1% | 3618.3 ± 0.2% | 3291.3 ± 0.3% | 688.6 ± 0.1% | 6053.8 ± 1.8% | 772.0 ± 6.7% | 3.306 | 3.635 | 17.373 | 1.976 | 15.496 |
| hex: canterbury-large/bible.txt | 524290 | 11974.5 ± 0.3% | 3614.5 ± 0.1% | 3299.5 ± 0.4% | 526.3 ± 1.5% | 6055.5 ± 1.6% | 771.8 ± 0.9% | 3.313 | 3.629 | 22.754 | 1.977 | 15.515 |
| hex: canterbury-large/world192.txt | 524290 | 12002.6 ± 0.1% | 3617.7 ± 0.2% | 3306.8 ± 0.2% | 505.8 ± 0.4% | 6126.4 ± 1.8% | 775.3 ± 0.7% | 3.318 | 3.630 | 23.731 | 1.959 | 15.482 |
| hex: http/html-1kx1024 | 2099200 | 8887.4 ± 3.1% | 3462.7 ± 0.3% | 2882.3 ± 0.5% | 474.8 ± 0.6% | 5181.4 ± 1.2% | 651.7 ± 1.8% | 2.567 | 3.083 | 18.719 | 1.715 | 13.637 |
| hex: http/html-16kx64 | 2097280 | 11782.6 ± 0.1% | 3612.2 ± 0.4% | 3271.2 ± 0.3% | 476.0 ± 0.7% | 6021.0 ± 0.5% | 751.4 ± 2.6% | 3.262 | 3.602 | 24.755 | 1.957 | 15.681 |
| hex: http/html-1m | 524290 | 12003.2 ± 0.1% | 3618.8 ± 0.2% | 3303.1 ± 0.4% | 501.2 ± 1.6% | 6092.1 ± 1.4% | 767.4 ± 2.8% | 3.317 | 3.634 | 23.950 | 1.970 | 15.640 |
| hex: http/json-1kx1024 | 2099200 | 8882.2 ± 3.1% | 3461.2 ± 0.2% | 2887.0 ± 0.5% | 575.3 ± 1.4% | 5132.8 ± 0.9% | 658.9 ± 2.4% | 2.566 | 3.077 | 15.438 | 1.730 | 13.480 |
| hex: http/json-16kx64 | 2097280 | 11774.8 ± 0.4% | 3613.2 ± 0.1% | 3262.1 ± 0.4% | 575.0 ± 0.9% | 6023.7 ± 0.3% | 755.4 ± 1.0% | 3.259 | 3.610 | 20.480 | 1.955 | 15.587 |
| hex: http/json-1m | 524290 | 11974.3 ± 0.4% | 3620.0 ± 0.2% | 3301.9 ± 0.4% | 601.4 ± 4.9% | 6057.5 ± 2.0% | 760.3 ± 3.1% | 3.308 | 3.626 | 19.909 | 1.977 | 15.750 |
| hex: http/js-1kx1024 | 2099200 | 8854.7 ± 3.1% | 3465.1 ± 0.3% | 2878.3 ± 0.6% | 480.9 ± 0.5% | 5131.1 ± 0.7% | 646.2 ± 5.2% | 2.555 | 3.076 | 18.413 | 1.726 | 13.703 |
| hex: http/js-16kx64 | 2097280 | 11755.3 ± 6.3% | 3614.2 ± 0.6% | 3270.5 ± 1.8% | 480.7 ± 0.6% | 6027.7 ± 1.4% | 743.5 ± 7.5% | 3.253 | 3.594 | 24.456 | 1.950 | 15.811 |
| hex: http/js-1m | 524290 | 11995.4 ± 0.4% | 3618.2 ± 0.2% | 3291.3 ± 0.5% | 501.7 ± 1.8% | 6127.6 ± 1.0% | 780.7 ± 2.9% | 3.315 | 3.645 | 23.911 | 1.958 | 15.364 |
| hex: http/css-1kx1024 | 2099200 | 8888.2 ± 3.5% | 3461.6 ± 0.1% | 2874.5 ± 0.7% | 488.4 ± 0.5% | 5137.3 ± 2.0% | 640.6 ± 2.8% | 2.568 | 3.092 | 18.198 | 1.730 | 13.874 |
| hex: http/css-16kx64 | 2097280 | 11770.9 ± 0.2% | 3614.1 ± 0.2% | 3277.1 ± 0.3% | 495.4 ± 0.7% | 6044.3 ± 0.8% | 749.6 ± 2.0% | 3.257 | 3.592 | 23.761 | 1.947 | 15.704 |
| hex: http/css-1m | 524290 | 11942.1 ± 0.1% | 3616.1 ± 0.6% | 3297.4 ± 0.3% | 498.7 ± 0.8% | 6065.4 ± 0.5% | 775.5 ± 2.1% | 3.302 | 3.622 | 23.948 | 1.969 | 15.400 |
| hex: shuffled/dickens-1m | 524290 | 11988.9 ± 0.2% | 3617.1 ± 0.1% | 3302.5 ± 0.2% | 514.4 ± 0.3% | 5993.2 ± 0.3% | 782.8 ± 2.4% | 3.314 | 3.630 | 23.307 | 2.000 | 15.316 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1015.3 ± 0.3% | 925.8 ± 0.7% | 1022.3 ± 0.4% | 301.2 ± 0.4% | 667.6 ± 0.2% | 310.0 ± 1.4% | 1.097 | 0.993 | 3.371 | 1.521 | 3.275 |
| qlog records, JSON text sequence | 1467503 | 842.9 ± 0.4% | 817.0 ± 0.2% | 792.9 ± 1.4% | 243.3 ± 0.9% | 703.8 ± 0.5% | 250.9 ± 0.8% | 1.032 | 1.063 | 3.465 | 1.198 | 3.359 |
| string: silesia/dickens | 172528 | 5054.4 ± 0.2% | 1877.0 ± 0.2% | 2642.5 ± 0.6% | 360.6 ± 0.2% | 2845.4 ± 0.3% | 550.5 ± 1.2% | 2.693 | 1.913 | 14.017 | 1.776 | 9.181 |
| string: silesia/nci | 1075110 | 4305.8 ± 0.5% | 2239.4 ± 0.4% | 3001.9 ± 0.2% | 544.5 ± 0.5% | 3004.6 ± 0.6% | 603.1 ± 1.7% | 1.923 | 1.434 | 7.907 | 1.433 | 7.140 |
| string: silesia/reymont | 1075159 | 2986.2 ± 1.0% | 1814.9 ± 1.9% | 2062.6 ± 1.1% | 374.1 ± 1.9% | 2145.1 ± 0.7% | 536.3 ± 2.6% | 1.645 | 1.448 | 7.982 | 1.392 | 5.568 |
| string: silesia/samba | 97582 | 3512.1 ± 0.2% | 2025.8 ± 0.4% | 2616.1 ± 0.2% | 328.3 ± 0.3% | 1500.6 ± 0.2% | 430.4 ± 0.7% | 1.734 | 1.342 | 10.697 | 2.340 | 8.160 |
| string: silesia/webster | 1098490 | 3667.7 ± 0.9% | 1517.1 ± 0.2% | 2018.2 ± 0.7% | 358.0 ± 0.8% | 2186.5 ± 0.3% | 498.8 ± 1.0% | 2.418 | 1.817 | 10.244 | 1.677 | 7.353 |
| string: silesia/xml | 1090118 | 4825.0 ± 0.4% | 2354.5 ± 0.2% | 2524.7 ± 0.5% | 457.0 ± 0.6% | 2873.5 ± 0.7% | 563.3 ± 1.4% | 2.049 | 1.911 | 10.559 | 1.679 | 8.565 |
| string: canterbury/alice29.txt | 159425 | 4349.7 ± 0.3% | 1598.7 ± 0.3% | 2455.5 ± 0.9% | 342.3 ± 0.4% | 2496.3 ± 0.3% | 508.1 ± 0.9% | 2.721 | 1.771 | 12.709 | 1.742 | 8.561 |
| string: canterbury/asyoulik.txt | 132198 | 3504.5 ± 0.5% | 1459.7 ± 0.3% | 2246.3 ± 0.9% | 335.0 ± 1.3% | 2077.6 ± 0.5% | 459.2 ± 1.4% | 2.401 | 1.560 | 10.462 | 1.687 | 7.632 |
| string: canterbury/lcet10.txt | 441884 | 5102.2 ± 0.2% | 1853.2 ± 0.3% | 2341.0 ± 1.0% | 390.8 ± 0.5% | 2842.5 ± 0.7% | 536.7 ± 2.3% | 2.753 | 2.180 | 13.057 | 1.795 | 9.508 |
| string: canterbury/plrabn12.txt | 503330 | 4135.1 ± 0.4% | 1735.5 ± 0.3% | 2066.7 ± 0.4% | 359.7 ± 0.8% | 2495.4 ± 0.4% | 500.7 ± 0.8% | 2.383 | 2.001 | 11.497 | 1.657 | 8.259 |
| string: canterbury-large/E.coli | 1048578 | 11947.4 ± 0.4% | 3608.5 ± 0.4% | 3258.3 ± 0.5% | 932.0 ± 1.4% | 6010.5 ± 1.1% | 765.4 ± 1.4% | 3.311 | 3.667 | 12.820 | 1.988 | 15.609 |
| string: canterbury-large/bible.txt | 1055886 | 6937.5 ± 0.8% | 2947.6 ± 0.4% | 2832.3 ± 0.5% | 418.8 ± 2.4% | 3752.6 ± 1.4% | 619.0 ± 1.0% | 2.354 | 2.449 | 16.567 | 1.849 | 11.208 |
| string: canterbury-large/world192.txt | 1103121 | 3393.2 ± 0.6% | 1483.8 ± 0.1% | 2016.3 ± 0.8% | 352.3 ± 0.4% | 2124.7 ± 0.6% | 503.0 ± 0.8% | 2.287 | 1.683 | 9.632 | 1.597 | 6.747 |
| string: http/html-1m | 1058582 | 6237.5 ± 1.5% | 2741.1 ± 0.7% | 2702.6 ± 0.3% | 442.1 ± 0.8% | 3487.3 ± 0.7% | 595.7 ± 1.1% | 2.276 | 2.308 | 14.110 | 1.789 | 10.471 |
| string: http/json-1m | 1190272 | 2565.0 ± 0.5% | 877.6 ± 0.1% | 2252.6 ± 0.6% | 389.9 ± 0.4% | 1064.6 ± 0.4% | 443.6 ± 0.5% | 2.923 | 1.139 | 6.579 | 2.409 | 5.783 |
| string: http/js-1m | 1144362 | 2284.6 ± 0.6% | 1029.3 ± 0.1% | 1639.2 ± 0.4% | 320.6 ± 0.5% | 1528.9 ± 0.3% | 420.4 ± 0.6% | 2.220 | 1.394 | 7.125 | 1.494 | 5.434 |
| string: http/css-1m | 1097820 | 2656.7 ± 0.5% | 1679.1 ± 0.6% | 2230.3 ± 0.4% | 405.0 ± 1.2% | 1960.6 ± 0.1% | 490.2 ± 1.2% | 1.582 | 1.191 | 6.559 | 1.355 | 5.420 |
| string: dickens as Cyrillic and CJK | 1883069 | 3084.9 ± 0.5% | 1686.1 ± 0.4% | 894.3 ± 0.3% | 351.6 ± 0.2% | 671.2 ± 0.3% | 158.2 ± 1.7% | 1.830 | 3.449 | 8.775 | 4.596 | 19.503 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.1 ± 0.2% | 979.7 ± 0.3% | 1209.4 ± 0.7% | 215.9 ± 0.1% | 472.1 ± 0.4% | 256.0 ± 3.7% | 1.358 | 1.100 | 6.161 | 2.817 | 5.195 |
| hex: silesia/dickens | 524290 | 11996.7 ± 0.2% | 3620.0 ± 0.2% | 3292.4 ± 0.2% | 512.4 ± 1.9% | 6108.6 ± 1.6% | 780.4 ± 1.8% | 3.314 | 3.644 | 23.412 | 1.964 | 15.373 |
| hex: silesia/mozilla | 524290 | 12022.7 ± 0.4% | 3616.0 ± 0.3% | 3294.8 ± 0.6% | 450.5 ± 1.5% | 6125.0 ± 1.2% | 783.5 ± 0.6% | 3.325 | 3.649 | 26.685 | 1.963 | 15.345 |
| hex: silesia/mr | 524290 | 12001.4 ± 0.1% | 3616.9 ± 0.2% | 3296.4 ± 0.2% | 560.9 ± 3.6% | 6116.0 ± 1.0% | 782.9 ± 0.7% | 3.318 | 3.641 | 21.395 | 1.962 | 15.329 |
| hex: silesia/nci | 524290 | 12003.2 ± 0.1% | 3616.4 ± 0.2% | 3290.7 ± 0.4% | 613.3 ± 5.6% | 6092.3 ± 1.1% | 784.4 ± 0.7% | 3.319 | 3.648 | 19.572 | 1.970 | 15.302 |
| hex: silesia/ooffice | 524290 | 12015.3 ± 0.3% | 3619.0 ± 0.3% | 3305.9 ± 0.2% | 396.1 ± 2.0% | 6140.3 ± 0.9% | 783.5 ± 0.7% | 3.320 | 3.635 | 30.335 | 1.957 | 15.335 |
| hex: silesia/osdb | 524290 | 11973.3 ± 0.3% | 3615.1 ± 0.4% | 3296.3 ± 0.8% | 480.3 ± 1.8% | 6106.5 ± 0.7% | 784.1 ± 0.7% | 3.312 | 3.632 | 24.928 | 1.961 | 15.270 |
| hex: silesia/reymont | 524290 | 11999.3 ± 0.1% | 3618.1 ± 0.2% | 3297.1 ± 0.3% | 515.0 ± 1.6% | 6125.7 ± 1.3% | 783.0 ± 0.9% | 3.316 | 3.639 | 23.300 | 1.959 | 15.326 |
| hex: silesia/samba | 524290 | 12010.8 ± 0.1% | 3615.9 ± 0.2% | 3298.1 ± 0.4% | 406.2 ± 3.7% | 6138.9 ± 1.8% | 784.6 ± 1.3% | 3.322 | 3.642 | 29.566 | 1.957 | 15.308 |
| hex: silesia/sao | 524290 | 11999.4 ± 0.2% | 3615.7 ± 0.4% | 3292.7 ± 0.4% | 344.2 ± 1.9% | 6011.5 ± 1.0% | 784.5 ± 0.4% | 3.319 | 3.644 | 34.860 | 1.996 | 15.296 |
| hex: silesia/webster | 524290 | 12014.3 ± 0.1% | 3609.4 ± 0.3% | 3300.0 ± 0.5% | 463.7 ± 0.9% | 6132.3 ± 0.9% | 783.5 ± 0.8% | 3.329 | 3.641 | 25.909 | 1.959 | 15.334 |
| hex: silesia/x-ray | 524290 | 11992.8 ± 0.2% | 3616.8 ± 0.2% | 3298.3 ± 0.4% | 476.7 ± 2.6% | 6146.4 ± 1.8% | 784.7 ± 0.6% | 3.316 | 3.636 | 25.160 | 1.951 | 15.282 |
| hex: silesia/xml | 524290 | 11997.2 ± 0.1% | 3610.5 ± 0.2% | 3293.7 ± 0.5% | 527.4 ± 0.4% | 6080.6 ± 1.3% | 784.1 ± 0.5% | 3.323 | 3.643 | 22.746 | 1.973 | 15.301 |
| hex: canterbury/alice29.txt | 304180 | 12001.5 ± 0.2% | 3631.8 ± 0.1% | 3377.3 ± 0.1% | 518.7 ± 0.2% | 6105.8 ± 0.8% | 784.0 ± 1.7% | 3.305 | 3.554 | 23.137 | 1.966 | 15.308 |
| hex: canterbury/asyoulik.txt | 250360 | 12001.7 ± 0.1% | 3640.8 ± 0.1% | 3366.7 ± 0.1% | 511.4 ± 0.2% | 6113.3 ± 2.9% | 781.2 ± 0.5% | 3.296 | 3.565 | 23.470 | 1.963 | 15.362 |
| hex: canterbury/cp.html | 49208 | 11915.0 ± 0.0% | 3638.7 ± 0.0% | 3291.8 ± 0.2% | 475.8 ± 3.0% | 6282.0 ± 0.6% | 767.7 ± 1.1% | 3.274 | 3.620 | 25.043 | 1.897 | 15.520 |
| hex: canterbury/fields.c | 22302 | 11785.0 ± 0.0% | 3629.3 ± 0.1% | 3365.8 ± 0.2% | 505.6 ± 1.4% | 6256.1 ± 0.3% | 760.0 ± 2.7% | 3.247 | 3.501 | 23.307 | 1.884 | 15.506 |
| hex: canterbury/grammar.lsp | 7444 | 11308.5 ± 0.6% | 3602.2 ± 0.1% | 3355.5 ± 0.1% | 546.0 ± 2.3% | 6174.7 ± 0.3% | 733.5 ± 1.5% | 3.139 | 3.370 | 20.713 | 1.831 | 15.417 |
| hex: canterbury/kennedy.xls | 524290 | 11989.8 ± 0.3% | 3605.9 ± 0.6% | 3291.4 ± 0.4% | 666.4 ± 3.8% | 6107.9 ± 0.9% | 772.7 ± 7.4% | 3.325 | 3.643 | 17.992 | 1.963 | 15.517 |
| hex: canterbury/lcet10.txt | 524290 | 11992.5 ± 0.5% | 3616.2 ± 0.1% | 3291.4 ± 0.2% | 526.5 ± 1.7% | 6105.6 ± 0.7% | 774.5 ± 0.4% | 3.316 | 3.644 | 22.777 | 1.964 | 15.483 |
| hex: canterbury/plrabn12.txt | 524290 | 12013.8 ± 0.1% | 3612.8 ± 0.2% | 3294.4 ± 0.3% | 517.2 ± 0.3% | 6132.1 ± 1.6% | 773.0 ± 0.6% | 3.325 | 3.647 | 23.227 | 1.959 | 15.542 |
| hex: canterbury/ptt5 | 524290 | 12025.3 ± 0.1% | 3615.5 ± 0.2% | 3295.2 ± 0.2% | 567.5 ± 0.4% | 6065.9 ± 1.9% | 774.7 ± 0.8% | 3.326 | 3.649 | 21.191 | 1.982 | 15.522 |
| hex: canterbury/sum | 76482 | 11904.4 ± 0.1% | 3634.4 ± 0.0% | 3355.5 ± 0.3% | 517.2 ± 1.3% | 6165.5 ± 0.5% | 773.1 ± 1.3% | 3.275 | 3.548 | 23.019 | 1.931 | 15.399 |
| hex: canterbury/xargs.1 | 8456 | 11353.3 ± 0.0% | 3602.5 ± 0.0% | 3384.5 ± 0.3% | 503.7 ± 2.4% | 6145.9 ± 0.4% | 758.3 ± 0.6% | 3.152 | 3.355 | 22.540 | 1.847 | 14.972 |
| hex: canterbury-large/E.coli | 524290 | 11960.5 ± 0.1% | 3618.3 ± 0.2% | 3291.3 ± 0.3% | 688.6 ± 0.1% | 6053.8 ± 1.8% | 772.0 ± 6.7% | 3.306 | 3.634 | 17.370 | 1.976 | 15.494 |
| hex: canterbury-large/bible.txt | 524290 | 11992.6 ± 0.1% | 3614.5 ± 0.1% | 3299.5 ± 0.4% | 526.3 ± 1.5% | 6055.5 ± 1.6% | 771.8 ± 0.9% | 3.318 | 3.635 | 22.789 | 1.980 | 15.539 |
| hex: canterbury-large/world192.txt | 524290 | 12003.3 ± 0.1% | 3617.7 ± 0.2% | 3306.8 ± 0.2% | 505.8 ± 0.4% | 6126.4 ± 1.8% | 775.3 ± 0.7% | 3.318 | 3.630 | 23.732 | 1.959 | 15.483 |
| hex: http/html-1kx1024 | 2099200 | 8952.1 ± 3.4% | 3462.7 ± 0.3% | 2882.3 ± 0.5% | 474.8 ± 0.6% | 5181.4 ± 1.2% | 651.7 ± 1.8% | 2.585 | 3.106 | 18.855 | 1.728 | 13.737 |
| hex: http/html-16kx64 | 2097280 | 11781.3 ± 0.2% | 3612.2 ± 0.4% | 3271.2 ± 0.3% | 476.0 ± 0.7% | 6021.0 ± 0.5% | 751.4 ± 2.6% | 3.262 | 3.602 | 24.752 | 1.957 | 15.679 |
| hex: http/html-1m | 524290 | 12000.2 ± 0.1% | 3618.8 ± 0.2% | 3303.1 ± 0.4% | 501.2 ± 1.6% | 6092.1 ± 1.4% | 767.4 ± 2.8% | 3.316 | 3.633 | 23.944 | 1.970 | 15.636 |
| hex: http/json-1kx1024 | 2099200 | 8947.1 ± 3.7% | 3461.2 ± 0.2% | 2887.0 ± 0.5% | 575.3 ± 1.4% | 5132.8 ± 0.9% | 658.9 ± 2.4% | 2.585 | 3.099 | 15.551 | 1.743 | 13.579 |
| hex: http/json-16kx64 | 2097280 | 11788.0 ± 0.2% | 3613.2 ± 0.1% | 3262.1 ± 0.4% | 575.0 ± 0.9% | 6023.7 ± 0.3% | 755.4 ± 1.0% | 3.263 | 3.614 | 20.503 | 1.957 | 15.605 |
| hex: http/json-1m | 524290 | 11963.4 ± 0.2% | 3620.0 ± 0.2% | 3301.9 ± 0.4% | 601.4 ± 4.9% | 6057.5 ± 2.0% | 760.3 ± 3.1% | 3.305 | 3.623 | 19.891 | 1.975 | 15.735 |
| hex: http/js-1kx1024 | 2099200 | 8972.8 ± 3.2% | 3465.1 ± 0.3% | 2878.3 ± 0.6% | 480.9 ± 0.5% | 5131.1 ± 0.7% | 646.2 ± 5.2% | 2.590 | 3.117 | 18.659 | 1.749 | 13.886 |
| hex: http/js-16kx64 | 2097280 | 11783.0 ± 1.3% | 3614.2 ± 0.6% | 3270.5 ± 1.8% | 480.7 ± 0.6% | 6027.7 ± 1.4% | 743.5 ± 7.5% | 3.260 | 3.603 | 24.514 | 1.955 | 15.848 |
| hex: http/js-1m | 524290 | 11986.8 ± 0.1% | 3618.2 ± 0.2% | 3291.3 ± 0.5% | 501.7 ± 1.8% | 6127.6 ± 1.0% | 780.7 ± 2.9% | 3.313 | 3.642 | 23.894 | 1.956 | 15.353 |
| hex: http/css-1kx1024 | 2099200 | 8927.5 ± 3.4% | 3461.6 ± 0.1% | 2874.5 ± 0.7% | 488.4 ± 0.5% | 5137.3 ± 2.0% | 640.6 ± 2.8% | 2.579 | 3.106 | 18.278 | 1.738 | 13.936 |
| hex: http/css-16kx64 | 2097280 | 11779.9 ± 0.2% | 3614.1 ± 0.2% | 3277.1 ± 0.3% | 495.4 ± 0.7% | 6044.3 ± 0.8% | 749.6 ± 2.0% | 3.259 | 3.595 | 23.779 | 1.949 | 15.716 |
| hex: http/css-1m | 524290 | 11968.7 ± 0.1% | 3616.1 ± 0.6% | 3297.4 ± 0.3% | 498.7 ± 0.8% | 6065.4 ± 0.5% | 775.5 ± 2.1% | 3.310 | 3.630 | 24.002 | 1.973 | 15.434 |
| hex: shuffled/dickens-1m | 524290 | 11936.5 ± 0.2% | 3617.1 ± 0.1% | 3302.5 ± 0.2% | 514.4 ± 0.3% | 5993.2 ± 0.3% | 782.8 ± 2.4% | 3.300 | 3.614 | 23.205 | 1.992 | 15.249 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1362.1 ± 0.3% | 1258.5 ± 0.6% | 1043.2 ± 0.5% | 409.6 ± 0.3% | 448.8 ± 0.3% | 416.3 ± 0.5% | 1.082 | 1.306 | 3.325 | 3.035 | 3.272 |
| qlog records, JSON text sequence | 1467503 | 1052.2 ± 0.5% | 1062.5 ± 0.7% | 792.5 ± 0.8% | 378.0 ± 1.1% | 471.8 ± 1.3% | 279.0 ± 0.3% | 0.990 | 1.328 | 2.783 | 2.230 | 3.771 |
| string: silesia/dickens | 172528 | 6917.6 ± 0.6% | 2817.1 ± 0.7% | 2924.9 ± 0.4% | 429.8 ± 0.8% | 1592.5 ± 0.2% | 1007.2 ± 0.2% | 2.456 | 2.365 | 16.094 | 4.344 | 6.868 |
| string: silesia/nci | 1075110 | 7317.4 ± 0.5% | 3407.2 ± 1.8% | 3094.3 ± 0.6% | 821.2 ± 2.0% | 1860.8 ± 0.4% | 1107.7 ± 0.2% | 2.148 | 2.365 | 8.911 | 3.932 | 6.606 |
| string: silesia/reymont | 1075159 | 3333.2 ± 0.9% | 1971.6 ± 0.3% | 2060.7 ± 0.8% | 449.6 ± 1.1% | 1510.4 ± 0.7% | 949.7 ± 0.6% | 1.691 | 1.618 | 7.413 | 2.207 | 3.510 |
| string: silesia/samba | 97582 | 4199.4 ± 0.5% | 2116.3 ± 0.6% | 3456.6 ± 0.9% | 354.5 ± 0.3% | 1431.8 ± 0.7% | 1055.5 ± 0.3% | 1.984 | 1.215 | 11.845 | 2.933 | 3.979 |
| string: silesia/webster | 1098490 | 4086.2 ± 0.4% | 1879.9 ± 0.5% | 2058.7 ± 0.6% | 441.5 ± 0.8% | 1394.8 ± 0.2% | 645.5 ± 0.7% | 2.174 | 1.985 | 9.254 | 2.930 | 6.331 |
| string: silesia/xml | 1090118 | 6134.2 ± 0.4% | 2868.6 ± 0.1% | 2650.4 ± 0.5% | 611.7 ± 1.1% | 1759.1 ± 0.6% | 924.5 ± 0.4% | 2.138 | 2.314 | 10.029 | 3.487 | 6.635 |
| string: canterbury/alice29.txt | 159425 | 6451.3 ± 0.4% | 2196.1 ± 0.6% | 2759.8 ± 0.5% | 407.7 ± 1.0% | 1482.0 ± 0.2% | 954.6 ± 0.3% | 2.938 | 2.338 | 15.825 | 4.353 | 6.758 |
| string: canterbury/asyoulik.txt | 132198 | 5653.7 ± 1.0% | 1715.9 ± 0.5% | 2377.1 ± 0.8% | 402.0 ± 0.4% | 1345.8 ± 0.9% | 883.4 ± 0.2% | 3.295 | 2.378 | 14.065 | 4.201 | 6.400 |
| string: canterbury/lcet10.txt | 441884 | 6271.8 ± 0.3% | 2569.0 ± 0.4% | 2484.4 ± 2.3% | 467.0 ± 0.3% | 1541.2 ± 0.2% | 986.1 ± 0.6% | 2.441 | 2.524 | 13.430 | 4.069 | 6.360 |
| string: canterbury/plrabn12.txt | 503330 | 5720.0 ± 0.4% | 2054.4 ± 0.4% | 2072.3 ± 0.4% | 423.3 ± 0.7% | 1432.2 ± 0.4% | 930.0 ± 0.4% | 2.784 | 2.760 | 13.513 | 3.994 | 6.150 |
| string: canterbury-large/E.coli | 1048578 | 19359.8 ± 0.5% | 9728.3 ± 1.2% | 3787.9 ± 0.6% | 1478.6 ± 0.4% | 2364.2 ± 0.6% | 1193.5 ± 0.5% | 1.990 | 5.111 | 13.093 | 8.189 | 16.221 |
| string: canterbury-large/bible.txt | 1055886 | 6800.5 ± 0.4% | 4178.9 ± 1.2% | 3056.3 ± 2.0% | 504.2 ± 0.2% | 1969.9 ± 0.5% | 1120.2 ± 0.3% | 1.627 | 2.225 | 13.487 | 3.452 | 6.071 |
| string: canterbury-large/world192.txt | 1103121 | 4069.2 ± 0.6% | 1657.2 ± 0.6% | 2000.8 ± 0.8% | 446.7 ± 0.1% | 1359.2 ± 0.4% | 908.7 ± 0.4% | 2.456 | 2.034 | 9.109 | 2.994 | 4.478 |
| string: http/html-1m | 1058582 | 6772.0 ± 0.8% | 3988.4 ± 0.5% | 3032.7 ± 0.8% | 500.8 ± 0.7% | 1916.5 ± 0.3% | 803.9 ± 0.4% | 1.698 | 2.233 | 13.523 | 3.534 | 8.424 |
| string: http/json-1m | 1190272 | 3167.6 ± 0.8% | 1343.6 ± 0.3% | 1556.1 ± 0.1% | 442.8 ± 0.5% | 961.6 ± 0.4% | 763.3 ± 1.1% | 2.358 | 2.036 | 7.154 | 3.294 | 4.150 |
| string: http/js-1m | 1144362 | 2770.8 ± 0.7% | 1179.0 ± 0.3% | 1625.3 ± 0.5% | 368.3 ± 0.3% | 1094.6 ± 0.2% | 755.5 ± 0.4% | 2.350 | 1.705 | 7.523 | 2.531 | 3.668 |
| string: http/css-1m | 1097820 | 4009.1 ± 0.5% | 1485.9 ± 0.4% | 2154.8 ± 0.7% | 493.5 ± 0.2% | 1369.8 ± 0.4% | 892.9 ± 0.2% | 2.698 | 1.861 | 8.124 | 2.927 | 4.490 |
| string: dickens as Cyrillic and CJK | 1883069 | 3074.8 ± 0.2% | 2345.6 ± 0.3% | 521.5 ± 0.2% | 306.3 ± 0.6% | 560.4 ± 0.8% | 334.9 ± 0.4% | 1.311 | 5.896 | 10.037 | 5.487 | 9.181 |
| hex: silesia/dickens | 524290 | 15663.3 ± 0.2% | 1464.0 ± 0.3% | 1083.4 ± 0.4% | 502.3 ± 0.2% | 987.7 ± 0.4% | 733.9 ± 0.4% | 10.699 | 14.457 | 31.181 | 15.859 | 21.343 |
| hex: silesia/mozilla | 524290 | 15617.4 ± 0.4% | 1473.9 ± 0.5% | 1088.9 ± 0.3% | 442.5 ± 0.4% | 992.0 ± 0.4% | 733.6 ± 0.4% | 10.596 | 14.343 | 35.291 | 15.743 | 21.289 |
| hex: silesia/mr | 524290 | 15705.0 ± 0.2% | 1482.7 ± 0.2% | 1093.9 ± 0.5% | 558.3 ± 3.0% | 1000.3 ± 0.6% | 733.1 ± 0.3% | 10.592 | 14.357 | 28.131 | 15.701 | 21.422 |
| hex: silesia/nci | 524290 | 15687.6 ± 0.2% | 1473.3 ± 0.5% | 1090.9 ± 0.4% | 628.2 ± 4.5% | 993.2 ± 0.4% | 734.6 ± 0.3% | 10.648 | 14.381 | 24.973 | 15.795 | 21.357 |
| hex: silesia/ooffice | 524290 | 15592.7 ± 0.4% | 1467.5 ± 0.2% | 1083.9 ± 0.3% | 389.4 ± 0.3% | 991.2 ± 0.3% | 733.6 ± 0.3% | 10.626 | 14.385 | 40.048 | 15.731 | 21.256 |
| hex: silesia/osdb | 524290 | 15630.8 ± 0.3% | 1471.5 ± 0.2% | 1088.9 ± 0.3% | 468.9 ± 2.2% | 992.8 ± 0.5% | 732.6 ± 0.3% | 10.622 | 14.355 | 33.336 | 15.745 | 21.337 |
| hex: silesia/reymont | 524290 | 15700.9 ± 0.1% | 1468.7 ± 0.5% | 1084.8 ± 0.6% | 517.8 ± 1.1% | 991.3 ± 1.2% | 732.9 ± 0.5% | 10.690 | 14.474 | 30.323 | 15.838 | 21.423 |
| hex: silesia/samba | 524290 | 15620.7 ± 0.6% | 1466.9 ± 0.3% | 1088.2 ± 0.3% | 403.0 ± 0.4% | 990.5 ± 0.3% | 734.1 ± 0.3% | 10.648 | 14.355 | 38.759 | 15.771 | 21.279 |
| hex: silesia/sao | 524290 | 15671.9 ± 0.1% | 1466.0 ± 0.2% | 1085.0 ± 0.3% | 333.4 ± 0.6% | 990.6 ± 0.2% | 734.7 ± 0.4% | 10.690 | 14.444 | 47.002 | 15.820 | 21.330 |
| hex: silesia/webster | 524290 | 15690.9 ± 0.2% | 1468.3 ± 0.3% | 1084.8 ± 0.3% | 474.4 ± 0.3% | 989.9 ± 0.3% | 732.4 ± 0.2% | 10.686 | 14.464 | 33.075 | 15.851 | 21.424 |
| hex: silesia/x-ray | 524290 | 15616.6 ± 0.5% | 1475.8 ± 0.2% | 1090.6 ± 0.2% | 445.0 ± 1.3% | 997.0 ± 0.5% | 733.9 ± 0.7% | 10.582 | 14.319 | 35.090 | 15.664 | 21.279 |
| hex: silesia/xml | 524290 | 15651.6 ± 0.5% | 1470.2 ± 0.3% | 1089.3 ± 0.5% | 616.6 ± 1.1% | 991.9 ± 1.2% | 732.6 ± 0.5% | 10.646 | 14.368 | 25.386 | 15.779 | 21.365 |
| hex: canterbury/alice29.txt | 304180 | 15691.4 ± 0.2% | 1478.6 ± 0.8% | 1092.6 ± 0.3% | 494.8 ± 2.7% | 995.3 ± 0.3% | 733.2 ± 0.9% | 10.612 | 14.362 | 31.714 | 15.765 | 21.400 |
| hex: canterbury/asyoulik.txt | 250360 | 15714.1 ± 0.0% | 1483.6 ± 0.3% | 1093.1 ± 0.6% | 497.5 ± 1.1% | 995.9 ± 0.6% | 740.0 ± 0.3% | 10.592 | 14.375 | 31.586 | 15.779 | 21.235 |
| hex: canterbury/cp.html | 49208 | 15666.5 ± 0.0% | 1471.9 ± 0.6% | 1097.1 ± 0.3% | 531.1 ± 2.5% | 1001.8 ± 0.4% | 742.4 ± 0.3% | 10.643 | 14.280 | 29.500 | 15.638 | 21.103 |
| hex: canterbury/fields.c | 22302 | 15516.0 ± 0.1% | 1423.3 ± 0.6% | 1066.2 ± 0.6% | 610.4 ± 2.7% | 986.6 ± 0.1% | 737.1 ± 0.2% | 10.901 | 14.553 | 25.421 | 15.726 | 21.050 |
| hex: canterbury/grammar.lsp | 7444 | 15152.8 ± 0.0% | 1484.5 ± 0.7% | 1090.0 ± 0.6% | 674.7 ± 2.4% | 996.6 ± 0.1% | 725.8 ± 0.1% | 10.207 | 13.902 | 22.458 | 15.204 | 20.877 |
| hex: canterbury/kennedy.xls | 524290 | 15640.5 ± 0.3% | 1473.7 ± 0.5% | 1088.4 ± 0.7% | 657.8 ± 1.3% | 989.9 ± 0.4% | 733.5 ± 0.5% | 10.613 | 14.370 | 23.778 | 15.801 | 21.322 |
| hex: canterbury/lcet10.txt | 524290 | 15645.8 ± 0.2% | 1465.4 ± 0.2% | 1086.0 ± 0.3% | 500.4 ± 1.0% | 987.6 ± 0.8% | 733.6 ± 0.3% | 10.677 | 14.407 | 31.270 | 15.842 | 21.328 |
| hex: canterbury/plrabn12.txt | 524290 | 15688.9 ± 0.5% | 1466.1 ± 0.3% | 1082.5 ± 0.3% | 490.1 ± 1.8% | 990.7 ± 0.3% | 733.4 ± 0.3% | 10.701 | 14.493 | 32.010 | 15.836 | 21.393 |
| hex: canterbury/ptt5 | 524290 | 15665.3 ± 0.3% | 1483.7 ± 0.2% | 1091.3 ± 0.3% | 554.5 ± 1.2% | 995.0 ± 0.2% | 732.7 ± 0.4% | 10.559 | 14.354 | 28.250 | 15.744 | 21.382 |
| hex: canterbury/sum | 76482 | 15672.3 ± 0.0% | 1495.3 ± 0.1% | 1103.4 ± 0.1% | 596.0 ± 1.8% | 998.1 ± 0.1% | 742.1 ± 0.1% | 10.481 | 14.203 | 26.294 | 15.702 | 21.118 |
| hex: canterbury/xargs.1 | 8456 | 15206.6 ± 0.1% | 1437.4 ± 0.5% | 1095.9 ± 0.2% | 646.3 ± 6.0% | 1001.8 ± 0.7% | 726.3 ± 0.4% | 10.579 | 13.877 | 23.529 | 15.179 | 20.939 |
| hex: canterbury-large/E.coli | 524290 | 15667.6 ± 0.2% | 1476.3 ± 0.2% | 1092.7 ± 0.2% | 672.4 ± 0.3% | 993.5 ± 0.9% | 732.7 ± 0.3% | 10.613 | 14.339 | 23.299 | 15.770 | 21.384 |
| hex: canterbury-large/bible.txt | 524290 | 15634.6 ± 0.4% | 1466.4 ± 0.4% | 1085.9 ± 0.1% | 511.4 ± 0.6% | 989.0 ± 0.5% | 733.8 ± 0.4% | 10.662 | 14.398 | 30.571 | 15.808 | 21.307 |
| hex: canterbury-large/world192.txt | 524290 | 15561.3 ± 0.7% | 1469.3 ± 0.2% | 1087.1 ± 0.2% | 502.6 ± 0.9% | 990.5 ± 0.4% | 733.2 ± 0.3% | 10.591 | 14.315 | 30.959 | 15.711 | 21.222 |
| hex: http/html-1kx1024 | 2099200 | 14176.9 ± 0.7% | 1454.9 ± 0.0% | 1062.4 ± 0.2% | 501.0 ± 0.2% | 973.0 ± 0.1% | 692.3 ± 0.1% | 9.744 | 13.345 | 28.297 | 14.570 | 20.478 |
| hex: http/html-16kx64 | 2097280 | 15383.5 ± 0.7% | 1444.3 ± 0.7% | 1075.5 ± 0.2% | 507.4 ± 0.3% | 997.3 ± 0.4% | 733.8 ± 0.3% | 10.651 | 14.304 | 30.316 | 15.425 | 20.965 |
| hex: http/html-1m | 524290 | 15675.5 ± 0.2% | 1469.6 ± 0.4% | 1083.7 ± 0.5% | 501.1 ± 0.6% | 991.1 ± 0.6% | 732.9 ± 0.4% | 10.667 | 14.464 | 31.280 | 15.816 | 21.389 |
| hex: http/json-1kx1024 | 2099200 | 14162.3 ± 0.8% | 1464.0 ± 0.4% | 1066.5 ± 0.1% | 607.5 ± 0.2% | 987.0 ± 0.3% | 692.0 ± 0.1% | 9.674 | 13.279 | 23.312 | 14.349 | 20.467 |
| hex: http/json-16kx64 | 2097280 | 15410.8 ± 0.3% | 1447.6 ± 0.3% | 1078.9 ± 0.4% | 617.1 ± 0.7% | 997.2 ± 0.1% | 733.8 ± 0.2% | 10.646 | 14.283 | 24.973 | 15.455 | 21.001 |
| hex: http/json-1m | 524290 | 15671.2 ± 0.4% | 1477.9 ± 0.3% | 1090.8 ± 0.3% | 632.0 ± 1.1% | 992.5 ± 0.4% | 731.8 ± 0.6% | 10.604 | 14.366 | 24.796 | 15.790 | 21.416 |
| hex: http/js-1kx1024 | 2099200 | 14173.0 ± 0.7% | 1456.1 ± 0.3% | 1064.3 ± 0.6% | 499.4 ± 0.1% | 984.4 ± 0.2% | 692.3 ± 0.4% | 9.734 | 13.317 | 28.381 | 14.397 | 20.473 |
| hex: http/js-16kx64 | 2097280 | 15408.3 ± 0.5% | 1441.5 ± 0.3% | 1074.1 ± 0.4% | 504.6 ± 0.3% | 998.1 ± 0.4% | 735.3 ± 0.2% | 10.689 | 14.346 | 30.537 | 15.438 | 20.955 |
| hex: http/js-1m | 524290 | 15671.6 ± 0.4% | 1467.2 ± 0.1% | 1086.0 ± 0.4% | 511.1 ± 0.2% | 989.6 ± 0.4% | 733.9 ± 0.4% | 10.681 | 14.430 | 30.662 | 15.836 | 21.355 |
| hex: http/css-1kx1024 | 2099200 | 14172.8 ± 0.2% | 1455.9 ± 0.2% | 1062.6 ± 0.2% | 532.0 ± 0.3% | 983.6 ± 0.2% | 692.6 ± 0.4% | 9.735 | 13.338 | 26.640 | 14.409 | 20.463 |
| hex: http/css-16kx64 | 2097280 | 15417.4 ± 0.3% | 1446.0 ± 0.2% | 1073.9 ± 0.2% | 540.8 ± 0.3% | 999.8 ± 0.4% | 735.3 ± 0.3% | 10.662 | 14.356 | 28.510 | 15.421 | 20.967 |
| hex: http/css-1m | 524290 | 15668.6 ± 0.1% | 1468.4 ± 0.5% | 1084.1 ± 0.2% | 527.0 ± 0.8% | 991.6 ± 0.6% | 734.0 ± 0.6% | 10.670 | 14.453 | 29.734 | 15.801 | 21.346 |
| hex: shuffled/dickens-1m | 524290 | 15651.2 ± 0.8% | 1462.5 ± 0.5% | 1084.2 ± 0.5% | 503.0 ± 0.7% | 989.1 ± 0.2% | 734.7 ± 0.4% | 10.701 | 14.435 | 31.117 | 15.824 | 21.302 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.917 of yyjson.
