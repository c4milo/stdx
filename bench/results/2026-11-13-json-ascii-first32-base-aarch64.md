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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43487600712 |
| Date | 2026-11-13 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1126.8 ± 0.5% | 0.524 | 0.966 | 0.999 | 0.999 | 0.457 | 1.004 | 1.006 | 0.383 | 0.831 | 0.899 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 842.6 ± 1.2% | 0.825 | 1.010 | 1.009 | 1.008 | 0.449 | 1.004 | 1.035 | 0.399 | 0.927 | 0.993 | 0.127 |
| string: silesia/dickens | 172528 | 5049.0 ± 0.4% | 0.033 | 0.782 | 1.002 | 1.003 | 0.196 | 1.015 | 1.006 | 0.196 | 1.002 | 1.002 | 0.032 |
| string: silesia/nci | 1075110 | 4298.2 ± 0.7% | 0.039 | 0.800 | 1.006 | 1.005 | 0.276 | 1.003 | 0.997 | 0.279 | 1.003 | 1.004 | 0.038 |
| string: silesia/reymont | 1075159 | 2924.6 ± 1.5% | 0.057 | 0.821 | 0.997 | 1.001 | 0.361 | 1.008 | 1.010 | 0.360 | 1.016 | 1.016 | 0.056 |
| string: silesia/samba | 97582 | 3496.2 ± 1.8% | 0.041 | 0.861 | 1.001 | 1.003 | 0.070 | 0.778 | 1.011 | 0.067 | 1.000 | 1.004 | 0.040 |
| string: silesia/webster | 1098490 | 3625.5 ± 0.6% | 0.045 | 0.852 | 1.007 | 1.009 | 0.204 | 1.024 | 1.018 | 0.204 | 1.014 | 1.012 | 0.044 |
| string: silesia/xml | 1090118 | 4747.7 ± 0.5% | 0.035 | 0.810 | 1.013 | 1.013 | 0.222 | 0.986 | 1.015 | 0.220 | 1.012 | 1.013 | 0.035 |
| string: canterbury/alice29.txt | 159425 | 4305.2 ± 0.4% | 0.038 | 0.752 | 1.004 | 1.009 | 0.172 | 1.034 | 1.019 | 0.171 | 1.008 | 1.010 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3454.3 ± 0.7% | 0.046 | 0.749 | 1.006 | 1.009 | 0.176 | 1.005 | 0.975 | 0.176 | 1.014 | 1.016 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5071.5 ± 0.3% | 0.033 | 0.821 | 1.005 | 1.006 | 0.197 | 1.030 | 1.012 | 0.197 | 1.008 | 1.007 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4096.0 ± 0.7% | 0.040 | 0.828 | 1.012 | 1.014 | 0.199 | 1.018 | 1.002 | 0.198 | 1.010 | 1.010 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19246.6 ± 0.5% | 0.077 | 1.006 | 1.002 | 1.002 | 0.476 | 1.001 | 1.001 | 0.476 | 0.618 | 0.619 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6657.7 ± 8.2% | 0.026 | 0.804 | 1.004 | 1.011 | 0.433 | 1.033 | 1.046 | 0.433 | 1.035 | 1.036 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3380.4 ± 0.3% | 0.048 | 0.846 | 1.002 | 1.003 | 0.198 | 1.016 | 1.007 | 0.198 | 1.005 | 1.005 | 0.047 |
| string: http/html-1m | 1058582 | 6035.7 ± 0.6% | 0.028 | 0.785 | 1.007 | 1.044 | 0.389 | 1.050 | 1.056 | 0.390 | 1.032 | 1.037 | 0.028 |
| string: http/json-1m | 1190272 | 2543.2 ± 0.5% | 0.056 | 0.953 | 1.005 | 1.005 | 0.110 | 1.004 | 0.472 | 0.110 | 1.005 | 1.004 | 0.055 |
| string: http/js-1m | 1144362 | 2279.9 ± 0.8% | 0.066 | 0.890 | 1.005 | 1.004 | 0.175 | 1.058 | 1.046 | 0.174 | 1.004 | 1.004 | 0.066 |
| string: http/css-1m | 1097820 | 2635.9 ± 0.6% | 0.061 | 0.777 | 1.007 | 1.010 | 0.238 | 1.008 | 1.015 | 0.239 | 1.008 | 1.009 | 0.059 |
| string: dickens as Cyrillic and CJK | 1883069 | 3067.0 ± 0.9% | 0.044 | 0.125 | 1.003 | 1.004 | 0.335 | 1.003 | 1.009 | 0.335 | 1.005 | 1.003 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1325.6 ± 1.5% | 0.086 | 1.004 | 1.003 | 1.004 | 0.078 | 0.639 | 1.006 | 0.075 | 1.003 | 1.004 | 0.084 |
| hex: silesia/dickens | 524290 | 18796.8 ± 1.4% | 0.079 | 1.004 | 0.988 | 0.979 | 0.513 | 0.990 | 0.984 | 0.514 | 0.639 | 0.638 | 0.009 |
| hex: silesia/mozilla | 524290 | 18379.9 ± 0.5% | 0.081 | 1.001 | 1.001 | 1.000 | 0.520 | 1.004 | 1.002 | 0.522 | 0.654 | 0.654 | 0.009 |
| hex: silesia/mr | 524290 | 18425.3 ± 0.8% | 0.081 | 1.006 | 0.999 | 0.998 | 0.524 | 0.997 | 1.001 | 0.523 | 0.652 | 0.652 | 0.009 |
| hex: silesia/nci | 524290 | 18619.6 ± 1.4% | 0.080 | 1.009 | 0.999 | 0.997 | 0.524 | 1.005 | 0.998 | 0.524 | 0.645 | 0.644 | 0.009 |
| hex: silesia/ooffice | 524290 | 18369.2 ± 0.9% | 0.081 | 1.018 | 0.996 | 0.999 | 0.528 | 0.996 | 0.997 | 0.529 | 0.652 | 0.652 | 0.009 |
| hex: silesia/osdb | 524290 | 18371.9 ± 0.7% | 0.081 | 0.999 | 1.003 | 1.002 | 0.521 | 0.998 | 0.999 | 0.521 | 0.653 | 0.653 | 0.009 |
| hex: silesia/reymont | 524290 | 18520.5 ± 0.4% | 0.080 | 1.004 | 0.998 | 0.999 | 0.518 | 1.001 | 1.000 | 0.515 | 0.647 | 0.647 | 0.009 |
| hex: silesia/samba | 524290 | 18234.1 ± 0.7% | 0.081 | 1.004 | 1.000 | 1.003 | 0.522 | 1.007 | 1.006 | 0.522 | 0.656 | 0.656 | 0.009 |
| hex: silesia/sao | 524290 | 18780.6 ± 0.7% | 0.079 | 0.997 | 0.990 | 0.994 | 0.512 | 0.993 | 0.986 | 0.511 | 0.639 | 0.638 | 0.009 |
| hex: silesia/webster | 524290 | 18585.8 ± 0.5% | 0.080 | 1.007 | 0.999 | 1.002 | 0.514 | 0.998 | 0.999 | 0.513 | 0.646 | 0.646 | 0.009 |
| hex: silesia/x-ray | 524290 | 18396.5 ± 0.2% | 0.081 | 1.002 | 1.004 | 1.003 | 0.514 | 1.003 | 1.001 | 0.516 | 0.652 | 0.652 | 0.009 |
| hex: silesia/xml | 524290 | 18619.3 ± 0.7% | 0.080 | 1.005 | 0.997 | 0.997 | 0.520 | 0.993 | 0.996 | 0.519 | 0.644 | 0.644 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19550.2 ± 0.2% | 0.077 | 1.002 | 1.001 | 1.002 | 0.514 | 1.002 | 1.001 | 0.513 | 0.614 | 0.615 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19542.5 ± 0.1% | 0.077 | 1.002 | 1.002 | 1.002 | 0.514 | 1.002 | 1.002 | 0.514 | 0.614 | 0.615 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19311.6 ± 0.1% | 0.081 | 1.002 | 1.000 | 1.000 | 0.541 | 1.001 | 1.001 | 0.542 | 0.617 | 0.617 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18894.1 ± 0.7% | 0.083 | 1.005 | 1.005 | 1.005 | 0.535 | 1.004 | 1.004 | 0.539 | 0.624 | 0.624 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17510.1 ± 0.5% | 0.088 | 1.007 | 1.007 | 1.008 | 0.528 | 1.006 | 1.006 | 0.546 | 0.644 | 0.647 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18658.3 ± 0.9% | 0.080 | 1.008 | 0.990 | 0.989 | 0.513 | 0.994 | 0.991 | 0.514 | 0.642 | 0.642 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18543.7 ± 1.3% | 0.080 | 1.012 | 1.008 | 0.999 | 0.513 | 1.010 | 1.003 | 0.515 | 0.648 | 0.648 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18192.0 ± 1.0% | 0.082 | 1.007 | 1.002 | 1.000 | 0.531 | 1.004 | 1.000 | 0.531 | 0.659 | 0.659 | 0.010 |
| hex: canterbury/ptt5 | 524290 | 18278.7 ± 0.6% | 0.081 | 1.004 | 1.005 | 1.001 | 0.531 | 1.000 | 1.006 | 0.532 | 0.657 | 0.657 | 0.009 |
| hex: canterbury/sum | 76482 | 19288.2 ± 0.6% | 0.078 | 1.002 | 1.003 | 1.003 | 0.518 | 1.002 | 1.002 | 0.520 | 0.618 | 0.617 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17845.9 ± 0.2% | 0.088 | 1.001 | 1.002 | 1.002 | 0.524 | 1.000 | 1.001 | 0.541 | 0.636 | 0.636 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18806.7 ± 1.5% | 0.079 | 1.003 | 1.000 | 0.993 | 0.501 | 1.000 | 0.992 | 0.498 | 0.637 | 0.637 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18462.4 ± 0.8% | 0.080 | 1.002 | 1.001 | 1.001 | 0.519 | 1.003 | 1.001 | 0.520 | 0.650 | 0.649 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18339.3 ± 0.7% | 0.081 | 0.999 | 1.001 | 1.001 | 0.527 | 1.000 | 1.001 | 0.527 | 0.654 | 0.654 | 0.009 |
| hex: http/html-1kx1024 | 2099200 | 9169.1 ± 20.9% | 0.155 | 1.268 | 1.262 | 1.274 | 0.712 | 1.274 | 0.981 | 0.768 | 0.939 | 0.947 | 0.019 |
| hex: http/html-16kx64 | 2097280 | 17918.1 ± 1.3% | 0.084 | 1.021 | 1.020 | 1.018 | 0.572 | 1.019 | 0.990 | 0.576 | 0.656 | 0.657 | 0.010 |
| hex: http/html-1m | 524290 | 18462.4 ± 0.4% | 0.081 | 1.000 | 1.004 | 1.002 | 0.539 | 1.005 | 1.003 | 0.539 | 0.651 | 0.651 | 0.009 |
| hex: http/json-1kx1024 | 2099200 | 9156.3 ± 19.7% | 0.153 | 1.298 | 1.286 | 1.294 | 0.714 | 1.291 | 0.989 | 0.770 | 0.948 | 0.961 | 0.019 |
| hex: http/json-16kx64 | 2097280 | 18034.4 ± 1.4% | 0.083 | 1.018 | 1.016 | 1.016 | 0.568 | 1.015 | 0.984 | 0.573 | 0.652 | 0.652 | 0.010 |
| hex: http/json-1m | 524290 | 18586.9 ± 1.2% | 0.080 | 1.013 | 1.014 | 1.015 | 0.536 | 1.009 | 1.010 | 0.536 | 0.646 | 0.647 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 9277.2 ± 19.7% | 0.153 | 1.258 | 1.257 | 1.251 | 0.701 | 1.256 | 0.978 | 0.763 | 0.929 | 0.931 | 0.018 |
| hex: http/js-16kx64 | 2097280 | 17855.7 ± 1.3% | 0.083 | 1.025 | 1.024 | 1.023 | 0.573 | 1.024 | 0.994 | 0.576 | 0.658 | 0.659 | 0.010 |
| hex: http/js-1m | 524290 | 18883.3 ± 1.3% | 0.079 | 1.009 | 1.002 | 1.000 | 0.514 | 0.996 | 0.983 | 0.517 | 0.636 | 0.636 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9357.9 ± 13.8% | 0.152 | 1.271 | 1.261 | 1.268 | 0.696 | 1.273 | 1.010 | 0.765 | 0.932 | 0.938 | 0.018 |
| hex: http/css-16kx64 | 2097280 | 18030.2 ± 1.0% | 0.083 | 1.020 | 1.015 | 1.017 | 0.567 | 1.013 | 0.984 | 0.571 | 0.652 | 0.652 | 0.010 |
| hex: http/css-1m | 524290 | 18903.5 ± 1.9% | 0.078 | 1.011 | 1.009 | 1.010 | 0.492 | 1.004 | 1.007 | 0.493 | 0.629 | 0.630 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18479.2 ± 0.7% | 0.080 | 0.994 | 0.992 | 0.993 | 0.515 | 0.999 | 0.998 | 0.516 | 0.648 | 0.648 | 0.009 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1481.6 ± 0.8% | 0.445 | 1.002 | 0.971 | 1.008 | 1.009 | 0.268 | 1.002 | 0.548 | 0.916 | 0.088 | 1.026 |
| qlog records, JSON text sequence | 1467503 | 1266.7 ± 1.6% | 0.691 | 0.978 | 1.013 | 1.014 | 1.014 | 0.266 | 1.003 | 0.504 | 0.832 | 0.106 | 1.017 |
| string: silesia/dickens | 172528 | 6895.3 ± 0.6% | 0.025 | 1.001 | 1.002 | 1.002 | 1.002 | 0.165 | 0.717 | 1.002 | 1.003 | 0.025 | 1.032 |
| string: silesia/nci | 1075110 | 7318.7 ± 0.7% | 0.024 | 1.001 | 0.999 | 1.000 | 0.998 | 0.209 | 0.565 | 1.001 | 0.999 | 0.023 | 1.004 |
| string: silesia/reymont | 1075159 | 3318.9 ± 1.1% | 0.052 | 1.002 | 1.002 | 1.003 | 1.001 | 0.389 | 0.873 | 1.000 | 1.003 | 0.052 | 1.050 |
| string: silesia/samba | 97582 | 4187.9 ± 1.1% | 0.053 | 1.003 | 1.001 | 1.006 | 1.006 | 0.125 | 0.946 | 1.001 | 1.006 | 0.053 | 1.088 |
| string: silesia/webster | 1098490 | 4045.1 ± 0.2% | 0.043 | 1.012 | 1.009 | 1.008 | 1.009 | 0.211 | 0.889 | 1.001 | 1.006 | 0.042 | 1.012 |
| string: silesia/xml | 1090118 | 6101.1 ± 0.2% | 0.029 | 1.006 | 0.999 | 1.006 | 1.006 | 0.253 | 0.775 | 1.001 | 1.004 | 0.029 | 1.019 |
| string: canterbury/alice29.txt | 159425 | 6414.7 ± 1.6% | 0.027 | 1.009 | 1.009 | 1.012 | 1.014 | 0.131 | 0.653 | 1.005 | 1.008 | 0.027 | 1.064 |
| string: canterbury/asyoulik.txt | 132198 | 5606.1 ± 0.7% | 0.030 | 1.026 | 1.029 | 1.030 | 1.031 | 0.128 | 0.595 | 1.000 | 1.007 | 0.030 | 1.038 |
| string: canterbury/lcet10.txt | 441884 | 6229.4 ± 0.7% | 0.028 | 1.002 | 1.003 | 1.004 | 1.004 | 0.183 | 0.800 | 1.000 | 1.001 | 0.027 | 1.004 |
| string: canterbury/plrabn12.txt | 503330 | 5712.7 ± 0.3% | 0.030 | 1.000 | 1.002 | 1.002 | 1.003 | 0.167 | 0.697 | 1.001 | 1.002 | 0.030 | 1.008 |
| string: canterbury-large/E.coli | 1048578 | 19229.1 ± 0.9% | 0.078 | 0.996 | 0.999 | 1.000 | 0.999 | 0.481 | 1.000 | 1.000 | 1.000 | 0.009 | 0.998 |
| string: canterbury-large/bible.txt | 1055886 | 6784.5 ± 0.5% | 0.026 | 1.003 | 1.002 | 1.002 | 1.001 | 0.494 | 0.974 | 1.003 | 1.003 | 0.026 | 1.001 |
| string: canterbury-large/world192.txt | 1103121 | 4019.0 ± 0.2% | 0.043 | 1.010 | 1.017 | 1.017 | 1.018 | 0.192 | 0.830 | 1.001 | 1.009 | 0.043 | 1.005 |
| string: http/html-1m | 1058582 | 6745.9 ± 0.9% | 0.026 | 1.003 | 0.923 | 1.002 | 1.005 | 0.402 | 0.874 | 1.002 | 1.002 | 0.026 | 1.008 |
| string: http/json-1m | 1190272 | 3165.5 ± 0.4% | 0.051 | 1.002 | 0.964 | 1.001 | 1.003 | 0.132 | 0.371 | 0.998 | 1.001 | 0.050 | 1.044 |
| string: http/js-1m | 1144362 | 2756.1 ± 1.0% | 0.061 | 1.004 | 1.008 | 1.003 | 1.006 | 0.163 | 0.840 | 1.003 | 1.007 | 0.061 | 1.016 |
| string: http/css-1m | 1097820 | 3980.6 ± 0.2% | 0.043 | 1.007 | 1.009 | 1.009 | 1.012 | 0.207 | 0.645 | 1.000 | 1.007 | 0.042 | 1.008 |
| string: dickens as Cyrillic and CJK | 1883069 | 3067.4 ± 0.3% | 0.048 | 1.003 | 0.124 | 1.002 | 1.001 | 0.319 | 1.002 | 1.000 | 1.002 | 0.048 | 1.004 |
| hex: silesia/dickens | 524290 | 15646.3 ± 0.3% | 1.001 | 0.178 | 0.999 | 1.002 | 1.000 | 0.999 | 1.002 | 1.001 | 1.000 | 0.178 | 1.002 |
| hex: silesia/mozilla | 524290 | 15646.8 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 0.998 | 1.000 | 1.001 | 0.178 | 0.997 |
| hex: silesia/mr | 524290 | 15649.5 ± 0.2% | 1.001 | 0.179 | 1.002 | 1.001 | 1.002 | 1.002 | 1.003 | 1.002 | 1.000 | 0.178 | 1.002 |
| hex: silesia/nci | 524290 | 15574.8 ± 0.6% | 1.000 | 0.179 | 1.003 | 1.001 | 1.002 | 1.002 | 1.002 | 1.001 | 1.002 | 0.179 | 1.002 |
| hex: silesia/ooffice | 524290 | 15594.9 ± 0.2% | 1.004 | 0.179 | 1.002 | 1.000 | 0.999 | 1.002 | 1.003 | 1.003 | 1.002 | 0.178 | 1.003 |
| hex: silesia/osdb | 524290 | 15640.3 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.001 | 1.000 | 1.000 | 0.999 | 0.998 | 1.000 | 0.178 | 0.999 |
| hex: silesia/reymont | 524290 | 15655.8 ± 0.1% | 1.001 | 0.177 | 0.999 | 0.999 | 0.998 | 1.000 | 1.000 | 1.002 | 1.000 | 0.177 | 1.000 |
| hex: silesia/samba | 524290 | 15652.9 ± 0.2% | 1.000 | 0.178 | 1.001 | 1.002 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 0.178 | 1.002 |
| hex: silesia/sao | 524290 | 15657.0 ± 0.2% | 1.003 | 0.178 | 1.001 | 1.001 | 1.002 | 0.999 | 1.000 | 1.002 | 0.998 | 0.178 | 1.001 |
| hex: silesia/webster | 524290 | 15642.0 ± 0.4% | 1.002 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 0.999 | 1.002 | 1.000 | 0.178 | 0.999 |
| hex: silesia/x-ray | 524290 | 15641.8 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 1.000 | 0.178 | 1.001 |
| hex: silesia/xml | 524290 | 15634.0 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 1.002 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/alice29.txt | 304180 | 15669.9 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15704.0 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15618.3 ± 0.1% | 1.001 | 0.179 | 1.001 | 1.001 | 1.000 | 0.998 | 1.001 | 1.001 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15431.9 ± 0.2% | 1.002 | 0.181 | 1.001 | 1.001 | 1.001 | 0.995 | 1.001 | 1.002 | 1.006 | 0.180 | 1.002 |
| hex: canterbury/grammar.lsp | 7444 | 14934.9 ± 0.1% | 1.004 | 0.186 | 1.001 | 1.000 | 1.001 | 0.983 | 1.001 | 1.004 | 1.015 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15651.9 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 0.999 | 0.999 | 0.178 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 15606.3 ± 0.3% | 1.002 | 0.179 | 1.002 | 1.001 | 1.001 | 1.003 | 1.003 | 1.003 | 1.003 | 0.178 | 1.004 |
| hex: canterbury/plrabn12.txt | 524290 | 15640.0 ± 0.3% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 1.000 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 15626.6 ± 0.1% | 1.002 | 0.179 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.000 | 1.000 | 0.179 | 1.000 |
| hex: canterbury/sum | 76482 | 15639.8 ± 0.0% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.999 | 1.001 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 14993.6 ± 0.1% | 1.002 | 0.185 | 1.000 | 1.000 | 1.000 | 0.986 | 1.000 | 1.004 | 1.014 | 0.183 | 1.001 |
| hex: canterbury-large/E.coli | 524290 | 15643.9 ± 0.3% | 1.002 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.000 |
| hex: canterbury-large/bible.txt | 524290 | 15643.7 ± 0.2% | 0.999 | 0.178 | 1.000 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 0.999 | 0.178 | 0.999 |
| hex: canterbury-large/world192.txt | 524290 | 15630.2 ± 0.2% | 0.999 | 0.178 | 1.001 | 1.001 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 0.178 | 1.001 |
| hex: http/html-1kx1024 | 2099200 | 13612.0 ± 0.5% | 1.007 | 0.197 | 1.006 | 1.003 | 1.001 | 0.946 | 1.006 | 1.014 | 1.036 | 0.188 | 1.016 |
| hex: http/html-16kx64 | 2097280 | 15268.6 ± 0.6% | 0.996 | 0.180 | 0.996 | 0.999 | 0.997 | 0.988 | 0.996 | 1.003 | 1.007 | 0.179 | 0.998 |
| hex: http/html-1m | 524290 | 15678.2 ± 0.2% | 1.002 | 0.177 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: http/json-1kx1024 | 2099200 | 13641.1 ± 0.2% | 1.005 | 0.196 | 1.002 | 1.004 | 1.003 | 0.939 | 1.000 | 1.015 | 1.036 | 0.188 | 1.011 |
| hex: http/json-16kx64 | 2097280 | 15205.9 ± 0.2% | 1.001 | 0.181 | 1.002 | 1.002 | 1.003 | 0.994 | 1.002 | 1.005 | 1.007 | 0.180 | 1.003 |
| hex: http/json-1m | 524290 | 15634.4 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.002 | 1.001 | 0.999 | 1.001 | 1.001 | 1.001 | 0.178 | 0.999 |
| hex: http/js-1kx1024 | 2099200 | 13668.0 ± 0.4% | 1.006 | 0.196 | 0.997 | 1.001 | 1.000 | 0.940 | 1.000 | 1.011 | 1.036 | 0.187 | 1.011 |
| hex: http/js-16kx64 | 2097280 | 15230.7 ± 0.4% | 1.000 | 0.181 | 0.997 | 0.998 | 1.001 | 0.993 | 1.000 | 1.007 | 1.007 | 0.180 | 1.002 |
| hex: http/js-1m | 524290 | 15693.4 ± 0.2% | 1.000 | 0.177 | 1.000 | 1.000 | 1.001 | 1.000 | 1.001 | 1.001 | 1.000 | 0.177 | 0.998 |
| hex: http/css-1kx1024 | 2099200 | 13626.9 ± 0.5% | 1.005 | 0.196 | 1.004 | 1.001 | 1.002 | 0.943 | 1.002 | 1.012 | 1.038 | 0.188 | 1.010 |
| hex: http/css-16kx64 | 2097280 | 15210.5 ± 0.5% | 1.002 | 0.181 | 1.003 | 1.003 | 1.000 | 0.994 | 1.003 | 1.005 | 1.005 | 0.181 | 1.002 |
| hex: http/css-1m | 524290 | 15684.4 ± 0.1% | 1.001 | 0.177 | 1.001 | 1.001 | 1.000 | 1.001 | 1.002 | 1.002 | 1.002 | 0.177 | 1.002 |
| hex: shuffled/dickens-1m | 524290 | 15691.1 ± 0.2% | 1.001 | 0.177 | 1.001 | 1.000 | 1.001 | 1.000 | 1.001 | 1.002 | 1.002 | 0.177 | 1.001 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.056 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.058 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.268 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.262 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.274 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.274 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.298 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.286 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.294 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.291 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.258 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.257 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.251 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.256 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.271 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.261 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.268 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.273 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43349.3 ± 0.1% | 47429.0 ± 0.1% | 0.914 | — | — |
| string: silesia/nci | 1048576 | 34747.4 ± 3.2% | 36850.1 ± 5.0% | 0.943 | — | — |
| string: silesia/reymont | 1048576 | 33606.3 ± 3.2% | 35921.5 ± 3.9% | 0.936 | — | — |
| string: silesia/samba | 65546 | 43555.0 ± 0.0% | 48509.3 ± 0.0% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 34574.1 ± 3.5% | 37631.3 ± 3.0% | 0.919 | — | — |
| string: silesia/xml | 1048576 | 30694.0 ± 1.4% | 31546.9 ± 1.6% | 0.973 | — | — |
| string: canterbury/alice29.txt | 152089 | 35889.5 ± 0.1% | 36534.7 ± 0.1% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43338.6 ± 0.2% | 47576.3 ± 0.3% | 0.911 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36057.2 ± 0.3% | 36712.7 ± 0.2% | 0.982 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 38738.1 ± 1.2% | 41863.2 ± 0.9% | 0.925 | — | — |
| string: canterbury-large/E.coli | 1048576 | 35732.9 ± 0.7% | 38186.6 ± 1.1% | 0.936 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 31550.2 ± 0.9% | 32790.6 ± 0.4% | 0.962 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 31082.6 ± 0.6% | 32345.0 ± 1.2% | 0.961 | — | — |
| string: http/html-1m | 1048576 | 35724.4 ± 2.9% | 38592.2 ± 3.5% | 0.926 | — | — |
| string: http/json-1m | 1048576 | 31999.8 ± 1.4% | 34134.7 ± 1.0% | 0.937 | — | — |
| string: http/js-1m | 1048576 | 35562.6 ± 3.3% | 37978.6 ± 2.7% | 0.936 | — | — |
| string: http/css-1m | 1048576 | 35240.7 ± 1.1% | 37554.3 ± 3.1% | 0.938 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5767.2 ± 0.4% | 5654.1 ± 0.1% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.914 of simdutf.
- string: silesia/nci: stdx runs at 0.943 of simdutf.
- string: silesia/reymont: stdx runs at 0.936 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.919 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.911 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.925 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.936 of simdutf.
- string: http/html-1m: stdx runs at 0.926 of simdutf.
- string: http/json-1m: stdx runs at 0.937 of simdutf.
- string: http/js-1m: stdx runs at 0.936 of simdutf.
- string: http/css-1m: stdx runs at 0.938 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 40131.1 ± 1.5% | 44284.0 ± 0.2% | 0.906 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 33540.6 ± 1.2% | 34197.1 ± 0.5% | 0.981 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 39043.3 ± 1.7% | 42175.6 ± 0.5% | 0.926 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 39836.8 ± 1.6% | 43825.9 ± 0.3% | 0.909 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 39829.9 ± 1.4% | 43682.6 ± 0.4% | 0.912 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 39775.4 ± 1.2% | 43566.0 ± 0.4% | 0.913 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5748.3 ± 0.2% | 5629.0 ± 0.2% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5736.4 ± 0.5% | 5628.2 ± 0.5% | 1.019 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5751.6 ± 0.6% | 5629.8 ± 0.1% | 1.022 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5751.1 ± 0.4% | 5626.1 ± 0.2% | 1.022 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5743.2 ± 0.2% | 5627.9 ± 0.3% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5748.8 ± 0.3% | 5628.9 ± 0.2% | 1.021 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1126.8 ± 0.5% | 929.9 ± 0.3% | 1022.6 ± 0.3% | 300.7 ± 1.0% | 665.3 ± 0.1% | 310.1 ± 1.3% | 1.212 | 1.102 | 3.747 | 1.694 | 3.633 |
| qlog records, JSON text sequence | 1467503 | 842.6 ± 1.2% | 817.6 ± 0.2% | 786.8 ± 2.3% | 244.0 ± 0.4% | 698.7 ± 0.4% | 250.0 ± 2.7% | 1.031 | 1.071 | 3.454 | 1.206 | 3.371 |
| string: silesia/dickens | 172528 | 5049.0 ± 0.4% | 1879.4 ± 0.2% | 2646.8 ± 0.3% | 362.3 ± 1.4% | 2874.1 ± 0.3% | 552.8 ± 2.2% | 2.686 | 1.908 | 13.937 | 1.757 | 9.133 |
| string: silesia/nci | 1075110 | 4298.2 ± 0.7% | 2233.8 ± 0.6% | 2997.4 ± 0.3% | 546.6 ± 0.4% | 2997.2 ± 0.8% | 597.1 ± 1.5% | 1.924 | 1.434 | 7.864 | 1.434 | 7.199 |
| string: silesia/reymont | 1075159 | 2924.6 ± 1.5% | 1819.6 ± 2.1% | 2061.5 ± 0.5% | 375.0 ± 1.2% | 2145.8 ± 0.5% | 535.6 ± 1.3% | 1.607 | 1.419 | 7.800 | 1.363 | 5.461 |
| string: silesia/samba | 97582 | 3496.2 ± 1.8% | 2026.0 ± 0.6% | 2618.3 ± 0.8% | 322.4 ± 0.4% | 1507.1 ± 0.8% | 425.7 ± 1.3% | 1.726 | 1.335 | 10.846 | 2.320 | 8.213 |
| string: silesia/webster | 1098490 | 3625.5 ± 0.6% | 1518.0 ± 0.3% | 2013.1 ± 0.3% | 359.0 ± 0.2% | 2173.4 ± 1.0% | 495.5 ± 1.4% | 2.388 | 1.801 | 10.098 | 1.668 | 7.317 |
| string: silesia/xml | 1090118 | 4747.7 ± 0.5% | 2359.8 ± 0.2% | 2530.8 ± 0.2% | 454.0 ± 1.0% | 2801.1 ± 0.8% | 562.0 ± 0.7% | 2.012 | 1.876 | 10.458 | 1.695 | 8.448 |
| string: canterbury/alice29.txt | 159425 | 4305.2 ± 0.4% | 1600.4 ± 0.5% | 2455.5 ± 0.2% | 342.2 ± 0.9% | 2494.2 ± 0.5% | 506.3 ± 1.2% | 2.690 | 1.753 | 12.580 | 1.726 | 8.504 |
| string: canterbury/asyoulik.txt | 132198 | 3454.3 ± 0.7% | 1458.4 ± 0.1% | 2247.5 ± 0.6% | 335.1 ± 1.0% | 2093.7 ± 0.2% | 455.2 ± 1.4% | 2.369 | 1.537 | 10.308 | 1.650 | 7.588 |
| string: canterbury/lcet10.txt | 441884 | 5071.5 ± 0.3% | 1854.6 ± 0.1% | 2335.2 ± 1.3% | 389.8 ± 0.3% | 2861.5 ± 0.5% | 534.3 ± 4.1% | 2.735 | 2.172 | 13.011 | 1.772 | 9.491 |
| string: canterbury/plrabn12.txt | 503330 | 4096.0 ± 0.7% | 1737.1 ± 0.5% | 2058.1 ± 0.4% | 360.3 ± 0.8% | 2475.8 ± 0.4% | 498.9 ± 0.9% | 2.358 | 1.990 | 11.368 | 1.654 | 8.210 |
| string: canterbury-large/E.coli | 1048578 | 19246.6 ± 0.5% | 3599.7 ± 0.5% | 3249.7 ± 0.8% | 931.5 ± 1.0% | 6002.0 ± 1.0% | 762.0 ± 1.5% | 5.347 | 5.923 | 20.662 | 3.207 | 25.258 |
| string: canterbury-large/bible.txt | 1055886 | 6657.7 ± 8.2% | 2940.7 ± 0.4% | 2825.9 ± 0.5% | 419.6 ± 1.1% | 3762.5 ± 1.1% | 615.0 ± 4.1% | 2.264 | 2.356 | 15.867 | 1.769 | 10.825 |
| string: canterbury-large/world192.txt | 1103121 | 3380.4 ± 0.3% | 1480.8 ± 0.2% | 2011.9 ± 0.4% | 352.9 ± 0.6% | 2118.7 ± 1.1% | 501.9 ± 1.0% | 2.283 | 1.680 | 9.578 | 1.596 | 6.735 |
| string: http/html-1m | 1058582 | 6035.7 ± 0.6% | 2737.5 ± 0.4% | 2699.5 ± 0.7% | 442.1 ± 0.2% | 3487.1 ± 0.9% | 599.5 ± 1.1% | 2.205 | 2.236 | 13.652 | 1.731 | 10.067 |
| string: http/json-1m | 1190272 | 2543.2 ± 0.5% | 875.9 ± 0.2% | 2252.3 ± 0.5% | 391.7 ± 0.4% | 1046.3 ± 1.8% | 443.3 ± 0.7% | 2.904 | 1.129 | 6.493 | 2.431 | 5.737 |
| string: http/js-1m | 1144362 | 2279.9 ± 0.8% | 1027.5 ± 0.1% | 1637.6 ± 0.3% | 321.8 ± 0.3% | 1520.8 ± 1.0% | 418.5 ± 0.5% | 2.219 | 1.392 | 7.086 | 1.499 | 5.448 |
| string: http/css-1m | 1097820 | 2635.9 ± 0.6% | 1678.0 ± 0.3% | 2220.1 ± 0.5% | 405.6 ± 1.2% | 1900.2 ± 1.1% | 489.4 ± 0.5% | 1.571 | 1.187 | 6.498 | 1.387 | 5.386 |
| string: dickens as Cyrillic and CJK | 1883069 | 3067.0 ± 0.9% | 1685.3 ± 0.3% | 891.2 ± 0.5% | 351.3 ± 0.2% | 667.2 ± 0.5% | 157.8 ± 2.2% | 1.820 | 3.441 | 8.730 | 4.597 | 19.438 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1325.6 ± 1.5% | 980.1 ± 0.2% | 1200.0 ± 0.9% | 213.4 ± 0.2% | 469.7 ± 0.5% | 250.6 ± 4.4% | 1.353 | 1.105 | 6.212 | 2.823 | 5.290 |
| hex: silesia/dickens | 524290 | 18796.8 ± 1.4% | 3615.8 ± 0.2% | 3286.9 ± 0.4% | 509.0 ± 1.3% | 6146.4 ± 1.6% | 781.1 ± 3.0% | 5.199 | 5.719 | 36.926 | 3.058 | 24.063 |
| hex: silesia/mozilla | 524290 | 18379.9 ± 0.5% | 3616.8 ± 0.2% | 3300.6 ± 0.2% | 445.6 ± 0.9% | 6111.5 ± 1.3% | 784.3 ± 0.5% | 5.082 | 5.569 | 41.249 | 3.007 | 23.434 |
| hex: silesia/mr | 524290 | 18425.3 ± 0.8% | 3613.4 ± 0.2% | 3295.8 ± 0.3% | 580.1 ± 1.5% | 6132.1 ± 1.1% | 783.7 ± 0.4% | 5.099 | 5.591 | 31.763 | 3.005 | 23.511 |
| hex: silesia/nci | 524290 | 18619.6 ± 1.4% | 3615.5 ± 0.3% | 3284.6 ± 0.1% | 637.8 ± 6.1% | 6103.9 ± 1.3% | 782.3 ± 0.3% | 5.150 | 5.669 | 29.192 | 3.050 | 23.800 |
| hex: silesia/ooffice | 524290 | 18369.2 ± 0.9% | 3616.8 ± 0.2% | 3290.6 ± 0.4% | 403.3 ± 1.0% | 6086.1 ± 1.4% | 783.8 ± 0.6% | 5.079 | 5.582 | 45.552 | 3.018 | 23.436 |
| hex: silesia/osdb | 524290 | 18371.9 ± 0.7% | 3619.6 ± 0.2% | 3302.7 ± 0.3% | 482.8 ± 0.3% | 6102.9 ± 0.8% | 783.9 ± 0.4% | 5.076 | 5.563 | 38.053 | 3.010 | 23.437 |
| hex: silesia/reymont | 524290 | 18520.5 ± 0.4% | 3613.0 ± 0.5% | 3287.6 ± 0.4% | 514.1 ± 2.1% | 6089.4 ± 2.0% | 782.4 ± 0.3% | 5.126 | 5.633 | 36.023 | 3.041 | 23.670 |
| hex: silesia/samba | 524290 | 18234.1 ± 0.7% | 3617.4 ± 0.2% | 3289.6 ± 0.1% | 406.1 ± 0.7% | 6022.7 ± 0.2% | 783.7 ± 0.3% | 5.041 | 5.543 | 44.903 | 3.028 | 23.265 |
| hex: silesia/sao | 524290 | 18780.6 ± 0.7% | 3618.2 ± 0.1% | 3289.7 ± 0.4% | 344.5 ± 1.2% | 6065.4 ± 1.2% | 784.8 ± 0.6% | 5.191 | 5.709 | 54.514 | 3.096 | 23.932 |
| hex: silesia/webster | 524290 | 18585.8 ± 0.5% | 3616.1 ± 0.2% | 3298.2 ± 0.2% | 468.6 ± 0.6% | 6089.3 ± 1.4% | 782.8 ± 0.6% | 5.140 | 5.635 | 39.661 | 3.052 | 23.742 |
| hex: silesia/x-ray | 524290 | 18396.5 ± 0.2% | 3613.4 ± 0.3% | 3291.7 ± 1.2% | 476.3 ± 0.7% | 6109.7 ± 0.7% | 782.0 ± 0.5% | 5.091 | 5.589 | 38.628 | 3.011 | 23.526 |
| hex: silesia/xml | 524290 | 18619.3 ± 0.7% | 3615.6 ± 0.2% | 3291.5 ± 0.2% | 522.1 ± 0.5% | 6117.8 ± 1.0% | 784.0 ± 0.5% | 5.150 | 5.657 | 35.659 | 3.043 | 23.748 |
| hex: canterbury/alice29.txt | 304180 | 19550.2 ± 0.2% | 3641.7 ± 0.0% | 3371.5 ± 0.1% | 503.8 ± 0.6% | 6103.0 ± 1.6% | 782.7 ± 0.2% | 5.368 | 5.799 | 38.808 | 3.203 | 24.979 |
| hex: canterbury/asyoulik.txt | 250360 | 19542.5 ± 0.1% | 3640.9 ± 0.1% | 3370.7 ± 0.0% | 495.5 ± 0.6% | 6142.1 ± 1.5% | 781.1 ± 0.5% | 5.367 | 5.798 | 39.438 | 3.182 | 25.020 |
| hex: canterbury/cp.html | 49208 | 19311.6 ± 0.1% | 3638.3 ± 0.0% | 3289.8 ± 0.2% | 465.8 ± 2.1% | 6280.5 ± 0.2% | 770.1 ± 1.4% | 5.308 | 5.870 | 41.455 | 3.075 | 25.076 |
| hex: canterbury/fields.c | 22302 | 18894.1 ± 0.7% | 3628.9 ± 0.0% | 3361.7 ± 0.1% | 497.8 ± 0.3% | 6254.9 ± 0.7% | 760.6 ± 2.3% | 5.207 | 5.620 | 37.957 | 3.021 | 24.841 |
| hex: canterbury/grammar.lsp | 7444 | 17510.1 ± 0.5% | 3600.7 ± 0.0% | 3352.3 ± 0.6% | 540.8 ± 0.6% | 6170.1 ± 0.9% | 723.8 ± 2.9% | 4.863 | 5.223 | 32.376 | 2.838 | 24.191 |
| hex: canterbury/kennedy.xls | 524290 | 18658.3 ± 0.9% | 3613.9 ± 0.1% | 3294.3 ± 0.2% | 660.6 ± 5.1% | 6048.4 ± 1.1% | 781.4 ± 5.2% | 5.163 | 5.664 | 28.247 | 3.085 | 23.878 |
| hex: canterbury/lcet10.txt | 524290 | 18543.7 ± 1.3% | 3611.1 ± 0.3% | 3283.9 ± 0.3% | 504.1 ± 2.4% | 6134.8 ± 1.2% | 782.5 ± 0.4% | 5.135 | 5.647 | 36.783 | 3.023 | 23.699 |
| hex: canterbury/plrabn12.txt | 524290 | 18192.0 ± 1.0% | 3613.4 ± 0.2% | 3297.2 ± 0.3% | 503.8 ± 1.1% | 6085.6 ± 2.4% | 783.3 ± 0.4% | 5.035 | 5.517 | 36.112 | 2.989 | 23.224 |
| hex: canterbury/ptt5 | 524290 | 18278.7 ± 0.6% | 3613.9 ± 0.4% | 3283.0 ± 0.2% | 558.0 ± 1.7% | 6142.1 ± 0.7% | 782.3 ± 0.3% | 5.058 | 5.568 | 32.757 | 2.976 | 23.365 |
| hex: canterbury/sum | 76482 | 19288.2 ± 0.6% | 3634.0 ± 0.0% | 3356.2 ± 0.3% | 497.0 ± 1.0% | 6173.1 ± 0.7% | 775.8 ± 1.4% | 5.308 | 5.747 | 38.806 | 3.125 | 24.863 |
| hex: canterbury/xargs.1 | 8456 | 17845.9 ± 0.2% | 3601.7 ± 0.0% | 3366.1 ± 0.1% | 492.6 ± 3.6% | 6153.9 ± 0.3% | 757.5 ± 1.2% | 4.955 | 5.302 | 36.231 | 2.900 | 23.559 |
| hex: canterbury-large/E.coli | 524290 | 18806.7 ± 1.5% | 3615.7 ± 0.2% | 3292.8 ± 0.2% | 688.2 ± 0.3% | 6123.7 ± 1.1% | 781.0 ± 3.9% | 5.201 | 5.711 | 27.328 | 3.071 | 24.082 |
| hex: canterbury-large/bible.txt | 524290 | 18462.4 ± 0.8% | 3615.6 ± 0.3% | 3283.9 ± 0.3% | 516.9 ± 0.7% | 6111.3 ± 1.0% | 783.6 ± 0.6% | 5.106 | 5.622 | 35.720 | 3.021 | 23.562 |
| hex: canterbury-large/world192.txt | 524290 | 18339.3 ± 0.7% | 3621.3 ± 0.2% | 3288.7 ± 0.4% | 484.3 ± 2.1% | 6126.7 ± 0.9% | 783.8 ± 0.9% | 5.064 | 5.576 | 37.870 | 2.993 | 23.399 |
| hex: http/html-1kx1024 | 2099200 | 9169.1 ± 20.9% | 3458.7 ± 0.2% | 2845.2 ± 0.8% | 475.1 ± 0.6% | 5069.8 ± 0.7% | 624.1 ± 3.6% | 2.651 | 3.223 | 19.300 | 1.809 | 14.691 |
| hex: http/html-16kx64 | 2097280 | 17918.1 ± 1.3% | 3607.2 ± 0.1% | 3255.5 ± 0.3% | 477.8 ± 0.5% | 6013.3 ± 0.5% | 740.8 ± 4.1% | 4.967 | 5.504 | 37.500 | 2.980 | 24.187 |
| hex: http/html-1m | 524290 | 18462.4 ± 0.4% | 3622.0 ± 0.2% | 3277.8 ± 0.4% | 494.1 ± 0.5% | 6133.7 ± 2.0% | 775.0 ± 3.8% | 5.097 | 5.633 | 37.369 | 3.010 | 23.823 |
| hex: http/json-1kx1024 | 2099200 | 9156.3 ± 19.7% | 3461.3 ± 0.0% | 2846.3 ± 0.4% | 574.3 ± 0.4% | 5086.7 ± 0.5% | 628.2 ± 2.3% | 2.645 | 3.217 | 15.943 | 1.800 | 14.575 |
| hex: http/json-16kx64 | 2097280 | 18034.4 ± 1.4% | 3608.8 ± 0.2% | 3258.3 ± 0.3% | 573.2 ± 1.3% | 6014.6 ± 0.7% | 740.0 ± 2.6% | 4.997 | 5.535 | 31.460 | 2.998 | 24.372 |
| hex: http/json-1m | 524290 | 18586.9 ± 1.2% | 3615.9 ± 0.1% | 3302.3 ± 0.2% | 582.6 ± 0.7% | 6135.1 ± 1.3% | 771.5 ± 3.5% | 5.140 | 5.629 | 31.905 | 3.030 | 24.092 |
| hex: http/js-1kx1024 | 2099200 | 9277.2 ± 19.7% | 3455.6 ± 0.3% | 2838.9 ± 0.5% | 480.9 ± 0.7% | 5068.4 ± 1.6% | 619.3 ± 2.4% | 2.685 | 3.268 | 19.291 | 1.830 | 14.981 |
| hex: http/js-16kx64 | 2097280 | 17855.7 ± 1.3% | 3608.2 ± 0.1% | 3259.8 ± 0.1% | 480.5 ± 2.0% | 6021.5 ± 0.7% | 744.2 ± 1.5% | 4.949 | 5.478 | 37.164 | 2.965 | 23.992 |
| hex: http/js-1m | 524290 | 18883.3 ± 1.3% | 3615.4 ± 0.1% | 3294.9 ± 0.4% | 496.8 ± 1.7% | 6147.5 ± 1.0% | 779.5 ± 4.5% | 5.223 | 5.731 | 38.006 | 3.072 | 24.224 |
| hex: http/css-1kx1024 | 2099200 | 9357.9 ± 13.8% | 3460.7 ± 0.3% | 2847.6 ± 0.5% | 490.0 ± 0.8% | 5113.1 ± 1.3% | 623.8 ± 2.3% | 2.704 | 3.286 | 19.098 | 1.830 | 15.001 |
| hex: http/css-16kx64 | 2097280 | 18030.2 ± 1.0% | 3608.8 ± 0.1% | 3255.0 ± 0.4% | 494.7 ± 1.6% | 6010.3 ± 0.3% | 750.4 ± 4.2% | 4.996 | 5.539 | 36.445 | 3.000 | 24.027 |
| hex: http/css-1m | 524290 | 18903.5 ± 1.9% | 3617.3 ± 0.2% | 3283.2 ± 0.2% | 507.6 ± 1.4% | 6051.2 ± 1.7% | 767.0 ± 2.6% | 5.226 | 5.758 | 37.238 | 3.124 | 24.645 |
| hex: shuffled/dickens-1m | 524290 | 18479.2 ± 0.7% | 3613.7 ± 0.2% | 3281.4 ± 0.2% | 524.2 ± 1.5% | 5968.4 ± 0.7% | 778.9 ± 0.8% | 5.114 | 5.632 | 35.251 | 3.096 | 23.724 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1481.6 ± 0.8% | 1252.1 ± 0.5% | 1039.9 ± 0.6% | 409.2 ± 0.3% | 448.8 ± 0.3% | 415.7 ± 0.1% | 1.183 | 1.425 | 3.621 | 3.301 | 3.564 |
| qlog records, JSON text sequence | 1467503 | 1266.7 ± 1.6% | 1064.6 ± 0.3% | 780.1 ± 0.3% | 378.5 ± 0.5% | 466.5 ± 0.3% | 279.1 ± 0.3% | 1.190 | 1.624 | 3.346 | 2.715 | 4.538 |
| string: silesia/dickens | 172528 | 6895.3 ± 0.6% | 2812.1 ± 0.1% | 2930.7 ± 0.9% | 429.5 ± 0.4% | 1564.4 ± 0.6% | 1010.5 ± 0.1% | 2.452 | 2.353 | 16.053 | 4.408 | 6.823 |
| string: silesia/nci | 1075110 | 7318.7 ± 0.7% | 3424.6 ± 0.9% | 3107.7 ± 0.1% | 816.3 ± 0.7% | 1835.8 ± 0.3% | 1107.3 ± 0.3% | 2.137 | 2.355 | 8.966 | 3.987 | 6.609 |
| string: silesia/reymont | 1075159 | 3318.9 ± 1.1% | 1986.6 ± 1.5% | 2060.8 ± 0.4% | 447.4 ± 1.4% | 1488.1 ± 1.2% | 951.1 ± 0.3% | 1.671 | 1.610 | 7.419 | 2.230 | 3.489 |
| string: silesia/samba | 97582 | 4187.9 ± 1.1% | 2106.3 ± 0.6% | 3445.9 ± 1.2% | 353.2 ± 0.8% | 1408.3 ± 0.3% | 1055.7 ± 0.2% | 1.988 | 1.215 | 11.857 | 2.974 | 3.967 |
| string: silesia/webster | 1098490 | 4045.1 ± 0.2% | 1877.8 ± 0.6% | 2049.9 ± 0.8% | 442.3 ± 0.3% | 1372.1 ± 0.2% | 646.7 ± 1.3% | 2.154 | 1.973 | 9.146 | 2.948 | 6.255 |
| string: silesia/xml | 1090118 | 6101.1 ± 0.2% | 2863.9 ± 0.6% | 2644.6 ± 0.4% | 608.6 ± 0.5% | 1731.4 ± 0.4% | 922.1 ± 0.8% | 2.130 | 2.307 | 10.025 | 3.524 | 6.616 |
| string: canterbury/alice29.txt | 159425 | 6414.7 ± 1.6% | 2195.2 ± 0.5% | 2771.4 ± 0.7% | 404.6 ± 0.9% | 1439.6 ± 0.1% | 955.2 ± 0.2% | 2.922 | 2.315 | 15.854 | 4.456 | 6.715 |
| string: canterbury/asyoulik.txt | 132198 | 5606.1 ± 0.7% | 1710.0 ± 0.5% | 2377.3 ± 1.0% | 402.6 ± 0.5% | 1307.6 ± 0.5% | 885.0 ± 0.3% | 3.278 | 2.358 | 13.926 | 4.287 | 6.335 |
| string: canterbury/lcet10.txt | 441884 | 6229.4 ± 0.7% | 2566.5 ± 0.3% | 2483.4 ± 1.4% | 466.8 ± 0.7% | 1525.9 ± 0.2% | 985.9 ± 0.5% | 2.427 | 2.508 | 13.346 | 4.082 | 6.318 |
| string: canterbury/plrabn12.txt | 503330 | 5712.7 ± 0.3% | 2063.6 ± 0.4% | 2068.6 ± 0.7% | 424.2 ± 0.8% | 1363.1 ± 0.3% | 928.9 ± 0.6% | 2.768 | 2.762 | 13.467 | 4.191 | 6.150 |
| string: canterbury-large/E.coli | 1048578 | 19229.1 ± 0.9% | 9711.7 ± 1.7% | 3782.0 ± 0.5% | 1475.5 ± 0.4% | 2362.1 ± 0.5% | 1193.3 ± 0.3% | 1.980 | 5.084 | 13.032 | 8.141 | 16.115 |
| string: canterbury-large/bible.txt | 1055886 | 6784.5 ± 0.5% | 4136.7 ± 1.3% | 3023.5 ± 1.3% | 504.2 ± 0.6% | 1978.4 ± 0.4% | 1122.2 ± 0.2% | 1.640 | 2.244 | 13.457 | 3.429 | 6.046 |
| string: canterbury-large/world192.txt | 1103121 | 4019.0 ± 0.2% | 1658.5 ± 0.6% | 2001.1 ± 0.8% | 450.1 ± 0.4% | 1345.0 ± 0.5% | 909.5 ± 0.4% | 2.423 | 2.008 | 8.928 | 2.988 | 4.419 |
| string: http/html-1m | 1058582 | 6745.9 ± 0.9% | 3943.3 ± 0.5% | 3041.3 ± 0.5% | 500.4 ± 0.4% | 1921.4 ± 0.5% | 804.9 ± 0.4% | 1.711 | 2.218 | 13.480 | 3.511 | 8.381 |
| string: http/json-1m | 1190272 | 3165.5 ± 0.4% | 1356.4 ± 0.4% | 1555.3 ± 0.3% | 444.3 ± 0.3% | 1035.5 ± 0.2% | 765.4 ± 0.9% | 2.334 | 2.035 | 7.125 | 3.057 | 4.136 |
| string: http/js-1m | 1144362 | 2756.1 ± 1.0% | 1182.0 ± 0.4% | 1624.4 ± 0.6% | 369.2 ± 0.2% | 1084.0 ± 0.4% | 757.7 ± 0.4% | 2.332 | 1.697 | 7.465 | 2.543 | 3.637 |
| string: http/css-1m | 1097820 | 3980.6 ± 0.2% | 1495.3 ± 0.3% | 2153.5 ± 0.6% | 493.8 ± 0.7% | 1355.5 ± 0.3% | 895.2 ± 0.2% | 2.662 | 1.848 | 8.062 | 2.937 | 4.447 |
| string: dickens as Cyrillic and CJK | 1883069 | 3067.4 ± 0.3% | 2331.6 ± 0.4% | 521.0 ± 0.4% | 307.6 ± 0.7% | 562.7 ± 1.1% | 336.1 ± 0.3% | 1.316 | 5.888 | 9.972 | 5.451 | 9.126 |
| hex: silesia/dickens | 524290 | 15646.3 ± 0.3% | 1466.9 ± 0.1% | 1085.6 ± 0.4% | 498.1 ± 0.2% | 988.6 ± 0.2% | 734.8 ± 0.5% | 10.666 | 14.413 | 31.413 | 15.827 | 21.292 |
| hex: silesia/mozilla | 524290 | 15646.8 ± 0.2% | 1475.2 ± 0.2% | 1089.5 ± 0.2% | 440.9 ± 0.4% | 992.7 ± 0.4% | 735.4 ± 0.5% | 10.607 | 14.362 | 35.485 | 15.762 | 21.275 |
| hex: silesia/mr | 524290 | 15649.5 ± 0.2% | 1483.3 ± 0.6% | 1093.6 ± 0.5% | 561.7 ± 3.9% | 996.1 ± 0.2% | 734.9 ± 0.4% | 10.550 | 14.311 | 27.863 | 15.711 | 21.295 |
| hex: silesia/nci | 524290 | 15574.8 ± 0.6% | 1476.4 ± 0.5% | 1089.4 ± 0.3% | 625.5 ± 2.8% | 991.3 ± 0.6% | 735.7 ± 0.8% | 10.549 | 14.297 | 24.898 | 15.712 | 21.171 |
| hex: silesia/ooffice | 524290 | 15594.9 ± 0.2% | 1467.3 ± 0.2% | 1086.0 ± 0.3% | 389.3 ± 0.7% | 988.8 ± 0.3% | 734.9 ± 0.2% | 10.628 | 14.360 | 40.060 | 15.771 | 21.220 |
| hex: silesia/osdb | 524290 | 15640.3 ± 0.2% | 1472.5 ± 0.2% | 1089.3 ± 0.3% | 468.6 ± 1.2% | 991.1 ± 0.4% | 733.7 ± 0.4% | 10.622 | 14.358 | 33.379 | 15.781 | 21.316 |
| hex: silesia/reymont | 524290 | 15655.8 ± 0.1% | 1464.8 ± 0.5% | 1085.6 ± 0.4% | 516.9 ± 0.5% | 990.9 ± 0.5% | 733.6 ± 0.6% | 10.688 | 14.422 | 30.286 | 15.799 | 21.340 |
| hex: silesia/samba | 524290 | 15652.9 ± 0.2% | 1468.0 ± 0.2% | 1086.1 ± 0.4% | 402.8 ± 0.1% | 992.6 ± 0.9% | 734.9 ± 0.5% | 10.663 | 14.412 | 38.856 | 15.769 | 21.299 |
| hex: silesia/sao | 524290 | 15657.0 ± 0.2% | 1465.5 ± 0.2% | 1083.8 ± 0.5% | 332.7 ± 0.5% | 991.1 ± 0.4% | 734.0 ± 0.4% | 10.684 | 14.446 | 47.060 | 15.797 | 21.332 |
| hex: silesia/webster | 524290 | 15642.0 ± 0.4% | 1469.2 ± 0.1% | 1085.2 ± 0.4% | 473.7 ± 0.7% | 990.4 ± 0.5% | 734.4 ± 0.2% | 10.647 | 14.414 | 33.024 | 15.793 | 21.299 |
| hex: silesia/x-ray | 524290 | 15641.8 ± 0.2% | 1481.1 ± 0.3% | 1091.7 ± 0.6% | 445.4 ± 1.2% | 995.5 ± 0.1% | 736.2 ± 0.3% | 10.561 | 14.328 | 35.121 | 15.713 | 21.246 |
| hex: silesia/xml | 524290 | 15634.0 ± 0.2% | 1472.5 ± 0.3% | 1087.4 ± 0.4% | 614.8 ± 1.4% | 993.1 ± 0.5% | 734.4 ± 0.6% | 10.617 | 14.378 | 25.431 | 15.743 | 21.289 |
| hex: canterbury/alice29.txt | 304180 | 15669.9 ± 0.1% | 1474.4 ± 0.5% | 1091.6 ± 0.3% | 504.5 ± 0.8% | 997.1 ± 0.6% | 734.8 ± 0.4% | 10.628 | 14.356 | 31.063 | 15.716 | 21.324 |
| hex: canterbury/asyoulik.txt | 250360 | 15704.0 ± 0.1% | 1480.2 ± 0.6% | 1093.8 ± 0.4% | 496.5 ± 1.0% | 994.6 ± 0.6% | 740.8 ± 0.5% | 10.609 | 14.357 | 31.627 | 15.789 | 21.198 |
| hex: canterbury/cp.html | 49208 | 15618.3 ± 0.1% | 1470.7 ± 0.2% | 1097.5 ± 0.2% | 531.4 ± 2.1% | 1001.3 ± 0.6% | 743.1 ± 0.2% | 10.620 | 14.230 | 29.390 | 15.598 | 21.017 |
| hex: canterbury/fields.c | 22302 | 15431.9 ± 0.2% | 1413.8 ± 0.9% | 1069.6 ± 0.9% | 616.6 ± 6.3% | 988.7 ± 0.2% | 737.2 ± 0.3% | 10.915 | 14.428 | 25.027 | 15.609 | 20.934 |
| hex: canterbury/grammar.lsp | 7444 | 14934.9 ± 0.1% | 1507.7 ± 0.2% | 1093.8 ± 0.8% | 658.3 ± 2.4% | 995.7 ± 0.4% | 726.2 ± 0.1% | 9.906 | 13.654 | 22.687 | 15.000 | 20.566 |
| hex: canterbury/kennedy.xls | 524290 | 15651.9 ± 0.2% | 1476.8 ± 0.2% | 1090.8 ± 0.3% | 654.0 ± 1.5% | 990.3 ± 0.5% | 735.0 ± 0.2% | 10.598 | 14.349 | 23.933 | 15.805 | 21.296 |
| hex: canterbury/lcet10.txt | 524290 | 15606.3 ± 0.3% | 1467.6 ± 0.3% | 1087.1 ± 0.4% | 502.7 ± 1.1% | 988.2 ± 0.3% | 735.3 ± 0.3% | 10.634 | 14.355 | 31.044 | 15.793 | 21.224 |
| hex: canterbury/plrabn12.txt | 524290 | 15640.0 ± 0.3% | 1464.3 ± 0.2% | 1083.8 ± 0.4% | 486.2 ± 2.2% | 985.8 ± 0.3% | 735.6 ± 0.3% | 10.681 | 14.430 | 32.170 | 15.865 | 21.262 |
| hex: canterbury/ptt5 | 524290 | 15626.6 ± 0.1% | 1482.6 ± 0.7% | 1091.6 ± 0.3% | 557.2 ± 0.9% | 994.3 ± 0.3% | 735.6 ± 0.6% | 10.540 | 14.315 | 28.042 | 15.716 | 21.243 |
| hex: canterbury/sum | 76482 | 15639.8 ± 0.0% | 1494.5 ± 0.1% | 1105.8 ± 0.3% | 593.9 ± 2.1% | 998.2 ± 0.0% | 743.8 ± 0.1% | 10.465 | 14.144 | 26.336 | 15.667 | 21.026 |
| hex: canterbury/xargs.1 | 8456 | 14993.6 ± 0.1% | 1492.9 ± 0.4% | 1086.8 ± 0.3% | 649.3 ± 7.8% | 1005.5 ± 0.1% | 728.3 ± 0.1% | 10.044 | 13.797 | 23.090 | 14.911 | 20.587 |
| hex: canterbury-large/E.coli | 524290 | 15643.9 ± 0.3% | 1472.3 ± 0.3% | 1090.3 ± 0.3% | 672.5 ± 0.3% | 997.0 ± 0.8% | 733.5 ± 0.5% | 10.626 | 14.348 | 23.263 | 15.691 | 21.329 |
| hex: canterbury-large/bible.txt | 524290 | 15643.7 ± 0.2% | 1463.9 ± 0.2% | 1084.9 ± 0.3% | 516.0 ± 0.6% | 988.0 ± 0.5% | 732.9 ± 0.7% | 10.686 | 14.419 | 30.315 | 15.834 | 21.345 |
| hex: canterbury-large/world192.txt | 524290 | 15630.2 ± 0.2% | 1465.1 ± 0.1% | 1086.9 ± 0.4% | 501.1 ± 0.4% | 988.3 ± 0.3% | 734.2 ± 0.3% | 10.668 | 14.381 | 31.195 | 15.816 | 21.289 |
| hex: http/html-1kx1024 | 2099200 | 13612.0 ± 0.5% | 1455.4 ± 0.5% | 1062.2 ± 0.1% | 501.3 ± 0.3% | 982.6 ± 0.1% | 692.8 ± 0.1% | 9.353 | 12.815 | 27.154 | 13.853 | 19.647 |
| hex: http/html-16kx64 | 2097280 | 15268.6 ± 0.6% | 1445.4 ± 0.5% | 1074.8 ± 0.4% | 506.3 ± 0.5% | 995.5 ± 0.3% | 734.3 ± 0.3% | 10.564 | 14.206 | 30.156 | 15.337 | 20.792 |
| hex: http/html-1m | 524290 | 15678.2 ± 0.2% | 1470.1 ± 0.2% | 1085.4 ± 0.5% | 501.0 ± 0.3% | 991.8 ± 0.6% | 736.1 ± 0.4% | 10.665 | 14.445 | 31.296 | 15.808 | 21.298 |
| hex: http/json-1kx1024 | 2099200 | 13641.1 ± 0.2% | 1464.3 ± 0.4% | 1066.6 ± 0.1% | 608.0 ± 0.3% | 986.6 ± 0.3% | 693.0 ± 0.1% | 9.316 | 12.789 | 22.437 | 13.826 | 19.683 |
| hex: http/json-16kx64 | 2097280 | 15205.9 ± 0.2% | 1443.9 ± 0.4% | 1074.9 ± 0.2% | 614.7 ± 0.4% | 997.4 ± 0.3% | 735.2 ± 0.1% | 10.531 | 14.146 | 24.738 | 15.245 | 20.683 |
| hex: http/json-1m | 524290 | 15634.4 ± 0.2% | 1474.1 ± 0.4% | 1091.0 ± 0.4% | 631.7 ± 1.0% | 992.6 ± 0.4% | 736.1 ± 0.8% | 10.606 | 14.330 | 24.749 | 15.751 | 21.240 |
| hex: http/js-1kx1024 | 2099200 | 13668.0 ± 0.4% | 1454.0 ± 0.6% | 1063.1 ± 0.1% | 498.8 ± 0.2% | 982.8 ± 0.2% | 692.5 ± 0.3% | 9.400 | 12.857 | 27.400 | 13.908 | 19.736 |
| hex: http/js-16kx64 | 2097280 | 15230.7 ± 0.4% | 1444.7 ± 0.2% | 1075.5 ± 0.2% | 504.8 ± 0.3% | 996.4 ± 0.3% | 734.6 ± 0.2% | 10.542 | 14.161 | 30.169 | 15.286 | 20.732 |
| hex: http/js-1m | 524290 | 15693.4 ± 0.2% | 1471.7 ± 0.4% | 1085.7 ± 0.4% | 510.8 ± 0.3% | 990.3 ± 0.2% | 734.3 ± 0.5% | 10.664 | 14.455 | 30.725 | 15.847 | 21.371 |
| hex: http/css-1kx1024 | 2099200 | 13626.9 ± 0.5% | 1456.0 ± 0.2% | 1062.5 ± 0.1% | 531.5 ± 0.1% | 983.7 ± 0.1% | 693.2 ± 0.1% | 9.359 | 12.826 | 25.638 | 13.852 | 19.659 |
| hex: http/css-16kx64 | 2097280 | 15210.5 ± 0.5% | 1445.5 ± 0.1% | 1075.0 ± 0.1% | 540.9 ± 0.6% | 1000.3 ± 0.1% | 735.1 ± 0.0% | 10.523 | 14.150 | 28.119 | 15.206 | 20.692 |
| hex: http/css-1m | 524290 | 15684.4 ± 0.1% | 1469.1 ± 0.3% | 1085.4 ± 0.5% | 526.9 ± 0.4% | 991.7 ± 0.5% | 735.5 ± 0.3% | 10.676 | 14.450 | 29.769 | 15.816 | 21.325 |
| hex: shuffled/dickens-1m | 524290 | 15691.1 ± 0.2% | 1469.0 ± 0.2% | 1084.4 ± 0.4% | 502.9 ± 1.6% | 993.9 ± 0.5% | 735.4 ± 0.6% | 10.681 | 14.470 | 31.199 | 15.788 | 21.338 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1520.5 ± 0.5% | 1252.1 ± 0.5% | 1039.9 ± 0.6% | 409.2 ± 0.3% | 448.8 ± 0.3% | 415.7 ± 0.1% | 1.214 | 1.462 | 3.716 | 3.388 | 3.658 |
| qlog records, JSON text sequence | 1467503 | 1288.8 ± 0.5% | 1064.6 ± 0.3% | 780.1 ± 0.3% | 378.5 ± 0.5% | 466.5 ± 0.3% | 279.1 ± 0.3% | 1.211 | 1.652 | 3.405 | 2.763 | 4.617 |
| string: silesia/dickens | 172528 | 7115.6 ± 0.5% | 2812.1 ± 0.1% | 2930.7 ± 0.9% | 429.5 ± 0.4% | 1564.4 ± 0.6% | 1010.5 ± 0.1% | 2.530 | 2.428 | 16.566 | 4.549 | 7.041 |
| string: silesia/nci | 1075110 | 7348.1 ± 6.8% | 3424.6 ± 0.9% | 3107.7 ± 0.1% | 816.3 ± 0.7% | 1835.8 ± 0.3% | 1107.3 ± 0.3% | 2.146 | 2.365 | 9.002 | 4.003 | 6.636 |
| string: silesia/reymont | 1075159 | 3483.2 ± 2.2% | 1986.6 ± 1.5% | 2060.8 ± 0.4% | 447.4 ± 1.4% | 1488.1 ± 1.2% | 951.1 ± 0.3% | 1.753 | 1.690 | 7.786 | 2.341 | 3.662 |
| string: silesia/samba | 97582 | 4554.9 ± 1.2% | 2106.3 ± 0.6% | 3445.9 ± 1.2% | 353.2 ± 0.8% | 1408.3 ± 0.3% | 1055.7 ± 0.2% | 2.163 | 1.322 | 12.896 | 3.234 | 4.314 |
| string: silesia/webster | 1098490 | 4092.6 ± 0.6% | 1877.8 ± 0.6% | 2049.9 ± 0.8% | 442.3 ± 0.3% | 1372.1 ± 0.2% | 646.7 ± 1.3% | 2.179 | 1.996 | 9.254 | 2.983 | 6.328 |
| string: silesia/xml | 1090118 | 6215.2 ± 0.5% | 2863.9 ± 0.6% | 2644.6 ± 0.4% | 608.6 ± 0.5% | 1731.4 ± 0.4% | 922.1 ± 0.8% | 2.170 | 2.350 | 10.213 | 3.590 | 6.740 |
| string: canterbury/alice29.txt | 159425 | 6827.7 ± 0.7% | 2195.2 ± 0.5% | 2771.4 ± 0.7% | 404.6 ± 0.9% | 1439.6 ± 0.1% | 955.2 ± 0.2% | 3.110 | 2.464 | 16.875 | 4.743 | 7.148 |
| string: canterbury/asyoulik.txt | 132198 | 5819.3 ± 3.0% | 1710.0 ± 0.5% | 2377.3 ± 1.0% | 402.6 ± 0.5% | 1307.6 ± 0.5% | 885.0 ± 0.3% | 3.403 | 2.448 | 14.456 | 4.450 | 6.576 |
| string: canterbury/lcet10.txt | 441884 | 6256.2 ± 0.3% | 2566.5 ± 0.3% | 2483.4 ± 1.4% | 466.8 ± 0.7% | 1525.9 ± 0.2% | 985.9 ± 0.5% | 2.438 | 2.519 | 13.403 | 4.100 | 6.345 |
| string: canterbury/plrabn12.txt | 503330 | 5757.5 ± 0.3% | 2063.6 ± 0.4% | 2068.6 ± 0.7% | 424.2 ± 0.8% | 1363.1 ± 0.3% | 928.9 ± 0.6% | 2.790 | 2.783 | 13.573 | 4.224 | 6.198 |
| string: canterbury-large/E.coli | 1048578 | 19188.3 ± 0.5% | 9711.7 ± 1.7% | 3782.0 ± 0.5% | 1475.5 ± 0.4% | 2362.1 ± 0.5% | 1193.3 ± 0.3% | 1.976 | 5.074 | 13.005 | 8.123 | 16.080 |
| string: canterbury-large/bible.txt | 1055886 | 6794.2 ± 0.3% | 4136.7 ± 1.3% | 3023.5 ± 1.3% | 504.2 ± 0.6% | 1978.4 ± 0.4% | 1122.2 ± 0.2% | 1.642 | 2.247 | 13.476 | 3.434 | 6.055 |
| string: canterbury-large/world192.txt | 1103121 | 4037.2 ± 0.8% | 1658.5 ± 0.6% | 2001.1 ± 0.8% | 450.1 ± 0.4% | 1345.0 ± 0.5% | 909.5 ± 0.4% | 2.434 | 2.017 | 8.969 | 3.002 | 4.439 |
| string: http/html-1m | 1058582 | 6800.6 ± 0.4% | 3943.3 ± 0.5% | 3041.3 ± 0.5% | 500.4 ± 0.4% | 1921.4 ± 0.5% | 804.9 ± 0.4% | 1.725 | 2.236 | 13.589 | 3.539 | 8.449 |
| string: http/json-1m | 1190272 | 3303.7 ± 0.4% | 1356.4 ± 0.4% | 1555.3 ± 0.3% | 444.3 ± 0.3% | 1035.5 ± 0.2% | 765.4 ± 0.9% | 2.436 | 2.124 | 7.436 | 3.190 | 4.316 |
| string: http/js-1m | 1144362 | 2799.7 ± 0.5% | 1182.0 ± 0.4% | 1624.4 ± 0.6% | 369.2 ± 0.2% | 1084.0 ± 0.4% | 757.7 ± 0.4% | 2.369 | 1.724 | 7.583 | 2.583 | 3.695 |
| string: http/css-1m | 1097820 | 4013.9 ± 0.5% | 1495.3 ± 0.3% | 2153.5 ± 0.6% | 493.8 ± 0.7% | 1355.5 ± 0.3% | 895.2 ± 0.2% | 2.684 | 1.864 | 8.129 | 2.961 | 4.484 |
| string: dickens as Cyrillic and CJK | 1883069 | 3078.4 ± 0.5% | 2331.6 ± 0.4% | 521.0 ± 0.4% | 307.6 ± 0.7% | 562.7 ± 1.1% | 336.1 ± 0.3% | 1.320 | 5.909 | 10.008 | 5.471 | 9.159 |
| hex: silesia/dickens | 524290 | 15678.7 ± 0.2% | 1466.9 ± 0.1% | 1085.6 ± 0.4% | 498.1 ± 0.2% | 988.6 ± 0.2% | 734.8 ± 0.5% | 10.688 | 14.443 | 31.478 | 15.860 | 21.337 |
| hex: silesia/mozilla | 524290 | 15605.5 ± 0.5% | 1475.2 ± 0.2% | 1089.5 ± 0.2% | 440.9 ± 0.4% | 992.7 ± 0.4% | 735.4 ± 0.5% | 10.579 | 14.324 | 35.392 | 15.720 | 21.219 |
| hex: silesia/mr | 524290 | 15682.0 ± 0.1% | 1483.3 ± 0.6% | 1093.6 ± 0.5% | 561.7 ± 3.9% | 996.1 ± 0.2% | 734.9 ± 0.4% | 10.572 | 14.340 | 27.920 | 15.744 | 21.339 |
| hex: silesia/nci | 524290 | 15602.3 ± 0.3% | 1476.4 ± 0.5% | 1089.4 ± 0.3% | 625.5 ± 2.8% | 991.3 ± 0.6% | 735.7 ± 0.8% | 10.568 | 14.322 | 24.942 | 15.739 | 21.208 |
| hex: silesia/ooffice | 524290 | 15647.0 ± 0.4% | 1467.3 ± 0.2% | 1086.0 ± 0.3% | 389.3 ± 0.7% | 988.8 ± 0.3% | 734.9 ± 0.2% | 10.664 | 14.408 | 40.194 | 15.824 | 21.291 |
| hex: silesia/osdb | 524290 | 15625.8 ± 0.4% | 1472.5 ± 0.2% | 1089.3 ± 0.3% | 468.6 ± 1.2% | 991.1 ± 0.4% | 733.7 ± 0.4% | 10.612 | 14.345 | 33.348 | 15.766 | 21.297 |
| hex: silesia/reymont | 524290 | 15658.4 ± 0.2% | 1464.8 ± 0.5% | 1085.6 ± 0.4% | 516.9 ± 0.5% | 990.9 ± 0.5% | 733.6 ± 0.6% | 10.689 | 14.424 | 30.291 | 15.802 | 21.343 |
| hex: silesia/samba | 524290 | 15687.6 ± 0.4% | 1468.0 ± 0.2% | 1086.1 ± 0.4% | 402.8 ± 0.1% | 992.6 ± 0.9% | 734.9 ± 0.5% | 10.687 | 14.443 | 38.943 | 15.804 | 21.346 |
| hex: silesia/sao | 524290 | 15677.6 ± 0.4% | 1465.5 ± 0.2% | 1083.8 ± 0.5% | 332.7 ± 0.5% | 991.1 ± 0.4% | 734.0 ± 0.4% | 10.698 | 14.465 | 47.122 | 15.818 | 21.360 |
| hex: silesia/webster | 524290 | 15628.2 ± 0.4% | 1469.2 ± 0.1% | 1085.2 ± 0.4% | 473.7 ± 0.7% | 990.4 ± 0.5% | 734.4 ± 0.2% | 10.637 | 14.401 | 32.995 | 15.779 | 21.280 |
| hex: silesia/x-ray | 524290 | 15656.8 ± 0.4% | 1481.1 ± 0.3% | 1091.7 ± 0.6% | 445.4 ± 1.2% | 995.5 ± 0.1% | 736.2 ± 0.3% | 10.571 | 14.341 | 35.154 | 15.728 | 21.266 |
| hex: silesia/xml | 524290 | 15657.1 ± 0.2% | 1472.5 ± 0.3% | 1087.4 ± 0.4% | 614.8 ± 1.4% | 993.1 ± 0.5% | 734.4 ± 0.6% | 10.633 | 14.399 | 25.469 | 15.766 | 21.320 |
| hex: canterbury/alice29.txt | 304180 | 15683.7 ± 0.0% | 1474.4 ± 0.5% | 1091.6 ± 0.3% | 504.5 ± 0.8% | 997.1 ± 0.6% | 734.8 ± 0.4% | 10.637 | 14.368 | 31.090 | 15.730 | 21.343 |
| hex: canterbury/asyoulik.txt | 250360 | 15719.6 ± 0.0% | 1480.2 ± 0.6% | 1093.8 ± 0.4% | 496.5 ± 1.0% | 994.6 ± 0.6% | 740.8 ± 0.5% | 10.620 | 14.372 | 31.659 | 15.805 | 21.219 |
| hex: canterbury/cp.html | 49208 | 15635.4 ± 0.3% | 1470.7 ± 0.2% | 1097.5 ± 0.2% | 531.4 ± 2.1% | 1001.3 ± 0.6% | 743.1 ± 0.2% | 10.631 | 14.246 | 29.422 | 15.615 | 21.040 |
| hex: canterbury/fields.c | 22302 | 15455.3 ± 0.0% | 1413.8 ± 0.9% | 1069.6 ± 0.9% | 616.6 ± 6.3% | 988.7 ± 0.2% | 737.2 ± 0.3% | 10.932 | 14.450 | 25.065 | 15.632 | 20.966 |
| hex: canterbury/grammar.lsp | 7444 | 14986.0 ± 0.0% | 1507.7 ± 0.2% | 1093.8 ± 0.8% | 658.3 ± 2.4% | 995.7 ± 0.4% | 726.2 ± 0.1% | 9.940 | 13.701 | 22.765 | 15.051 | 20.636 |
| hex: canterbury/kennedy.xls | 524290 | 15646.6 ± 0.2% | 1476.8 ± 0.2% | 1090.8 ± 0.3% | 654.0 ± 1.5% | 990.3 ± 0.5% | 735.0 ± 0.2% | 10.595 | 14.345 | 23.925 | 15.799 | 21.288 |
| hex: canterbury/lcet10.txt | 524290 | 15662.2 ± 0.1% | 1467.6 ± 0.3% | 1087.1 ± 0.4% | 502.7 ± 1.1% | 988.2 ± 0.3% | 735.3 ± 0.3% | 10.672 | 14.407 | 31.155 | 15.850 | 21.300 |
| hex: canterbury/plrabn12.txt | 524290 | 15650.3 ± 0.3% | 1464.3 ± 0.2% | 1083.8 ± 0.4% | 486.2 ± 2.2% | 985.8 ± 0.3% | 735.6 ± 0.3% | 10.688 | 14.440 | 32.191 | 15.875 | 21.276 |
| hex: canterbury/ptt5 | 524290 | 15625.1 ± 0.3% | 1482.6 ± 0.7% | 1091.6 ± 0.3% | 557.2 ± 0.9% | 994.3 ± 0.3% | 735.6 ± 0.6% | 10.539 | 14.313 | 28.040 | 15.714 | 21.241 |
| hex: canterbury/sum | 76482 | 15651.5 ± 0.0% | 1494.5 ± 0.1% | 1105.8 ± 0.3% | 593.9 ± 2.1% | 998.2 ± 0.0% | 743.8 ± 0.1% | 10.473 | 14.154 | 26.356 | 15.679 | 21.041 |
| hex: canterbury/xargs.1 | 8456 | 15016.1 ± 0.0% | 1492.9 ± 0.4% | 1086.8 ± 0.3% | 649.3 ± 7.8% | 1005.5 ± 0.1% | 728.3 ± 0.1% | 10.059 | 13.817 | 23.125 | 14.933 | 20.618 |
| hex: canterbury-large/E.coli | 524290 | 15646.0 ± 0.2% | 1472.3 ± 0.3% | 1090.3 ± 0.3% | 672.5 ± 0.3% | 997.0 ± 0.8% | 733.5 ± 0.5% | 10.627 | 14.350 | 23.266 | 15.693 | 21.332 |
| hex: canterbury-large/bible.txt | 524290 | 15631.8 ± 0.3% | 1463.9 ± 0.2% | 1084.9 ± 0.3% | 516.0 ± 0.6% | 988.0 ± 0.5% | 732.9 ± 0.7% | 10.678 | 14.408 | 30.292 | 15.821 | 21.329 |
| hex: canterbury-large/world192.txt | 524290 | 15646.8 ± 0.3% | 1465.1 ± 0.1% | 1086.9 ± 0.4% | 501.1 ± 0.4% | 988.3 ± 0.3% | 734.2 ± 0.3% | 10.680 | 14.396 | 31.228 | 15.833 | 21.312 |
| hex: http/html-1kx1024 | 2099200 | 13823.2 ± 0.3% | 1455.4 ± 0.5% | 1062.2 ± 0.1% | 501.3 ± 0.3% | 982.6 ± 0.1% | 692.8 ± 0.1% | 9.498 | 13.014 | 27.575 | 14.068 | 19.952 |
| hex: http/html-16kx64 | 2097280 | 15245.1 ± 0.8% | 1445.4 ± 0.5% | 1074.8 ± 0.4% | 506.3 ± 0.5% | 995.5 ± 0.3% | 734.3 ± 0.3% | 10.547 | 14.184 | 30.110 | 15.314 | 20.760 |
| hex: http/html-1m | 524290 | 15692.8 ± 0.2% | 1470.1 ± 0.2% | 1085.4 ± 0.5% | 501.0 ± 0.3% | 991.8 ± 0.6% | 736.1 ± 0.4% | 10.675 | 14.459 | 31.325 | 15.823 | 21.318 |
| hex: http/json-1kx1024 | 2099200 | 13795.6 ± 0.6% | 1464.3 ± 0.4% | 1066.6 ± 0.1% | 608.0 ± 0.3% | 986.6 ± 0.3% | 693.0 ± 0.1% | 9.421 | 12.934 | 22.691 | 13.983 | 19.906 |
| hex: http/json-16kx64 | 2097280 | 15251.9 ± 0.2% | 1443.9 ± 0.4% | 1074.9 ± 0.2% | 614.7 ± 0.4% | 997.4 ± 0.3% | 735.2 ± 0.1% | 10.563 | 14.189 | 24.812 | 15.291 | 20.746 |
| hex: http/json-1m | 524290 | 15612.7 ± 0.2% | 1474.1 ± 0.4% | 1091.0 ± 0.4% | 631.7 ± 1.0% | 992.6 ± 0.4% | 736.1 ± 0.8% | 10.592 | 14.310 | 24.715 | 15.729 | 21.211 |
| hex: http/js-1kx1024 | 2099200 | 13821.7 ± 0.4% | 1454.0 ± 0.6% | 1063.1 ± 0.1% | 498.8 ± 0.2% | 982.8 ± 0.2% | 692.5 ± 0.3% | 9.506 | 13.001 | 27.708 | 14.064 | 19.958 |
| hex: http/js-16kx64 | 2097280 | 15258.7 ± 0.2% | 1444.7 ± 0.2% | 1075.5 ± 0.2% | 504.8 ± 0.3% | 996.4 ± 0.3% | 734.6 ± 0.2% | 10.562 | 14.187 | 30.225 | 15.314 | 20.770 |
| hex: http/js-1m | 524290 | 15655.1 ± 0.2% | 1471.7 ± 0.4% | 1085.7 ± 0.4% | 510.8 ± 0.3% | 990.3 ± 0.2% | 734.3 ± 0.5% | 10.638 | 14.420 | 30.650 | 15.808 | 21.319 |
| hex: http/css-1kx1024 | 2099200 | 13767.1 ± 0.4% | 1456.0 ± 0.2% | 1062.5 ± 0.1% | 531.5 ± 0.1% | 983.7 ± 0.1% | 693.2 ± 0.1% | 9.456 | 12.958 | 25.902 | 13.995 | 19.861 |
| hex: http/css-16kx64 | 2097280 | 15238.5 ± 1.1% | 1445.5 ± 0.1% | 1075.0 ± 0.1% | 540.9 ± 0.6% | 1000.3 ± 0.1% | 735.1 ± 0.0% | 10.542 | 14.176 | 28.171 | 15.234 | 20.730 |
| hex: http/css-1m | 524290 | 15722.9 ± 0.2% | 1469.1 ± 0.3% | 1085.4 ± 0.5% | 526.9 ± 0.4% | 991.7 ± 0.5% | 735.5 ± 0.3% | 10.702 | 14.486 | 29.842 | 15.854 | 21.378 |
| hex: shuffled/dickens-1m | 524290 | 15704.2 ± 0.2% | 1469.0 ± 0.2% | 1084.4 ± 0.4% | 502.9 ± 1.6% | 993.9 ± 0.5% | 735.4 ± 0.6% | 10.690 | 14.482 | 31.225 | 15.801 | 21.356 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 936.6 ± 0.3% | 929.9 ± 0.3% | 1022.6 ± 0.3% | 300.7 ± 1.0% | 665.3 ± 0.1% | 310.1 ± 1.3% | 1.007 | 0.916 | 3.115 | 1.408 | 3.020 |
| qlog records, JSON text sequence | 1467503 | 780.7 ± 0.7% | 817.6 ± 0.2% | 786.8 ± 2.3% | 244.0 ± 0.4% | 698.7 ± 0.4% | 250.0 ± 2.7% | 0.955 | 0.992 | 3.200 | 1.117 | 3.123 |
| string: silesia/dickens | 172528 | 5057.8 ± 0.2% | 1879.4 ± 0.2% | 2646.8 ± 0.3% | 362.3 ± 1.4% | 2874.1 ± 0.3% | 552.8 ± 2.2% | 2.691 | 1.911 | 13.961 | 1.760 | 9.149 |
| string: silesia/nci | 1075110 | 4311.2 ± 0.3% | 2233.8 ± 0.6% | 2997.4 ± 0.3% | 546.6 ± 0.4% | 2997.2 ± 0.8% | 597.1 ± 1.5% | 1.930 | 1.438 | 7.888 | 1.438 | 7.221 |
| string: silesia/reymont | 1075159 | 2970.8 ± 1.2% | 1819.6 ± 2.1% | 2061.5 ± 0.5% | 375.0 ± 1.2% | 2145.8 ± 0.5% | 535.6 ± 1.3% | 1.633 | 1.441 | 7.923 | 1.384 | 5.547 |
| string: silesia/samba | 97582 | 3497.1 ± 0.3% | 2026.0 ± 0.6% | 2618.3 ± 0.8% | 322.4 ± 0.4% | 1507.1 ± 0.8% | 425.7 ± 1.3% | 1.726 | 1.336 | 10.848 | 2.320 | 8.215 |
| string: silesia/webster | 1098490 | 3676.6 ± 0.5% | 1518.0 ± 0.3% | 2013.1 ± 0.3% | 359.0 ± 0.2% | 2173.4 ± 1.0% | 495.5 ± 1.4% | 2.422 | 1.826 | 10.241 | 1.692 | 7.420 |
| string: silesia/xml | 1090118 | 4803.0 ± 0.4% | 2359.8 ± 0.2% | 2530.8 ± 0.2% | 454.0 ± 1.0% | 2801.1 ± 0.8% | 562.0 ± 0.7% | 2.035 | 1.898 | 10.579 | 1.715 | 8.546 |
| string: canterbury/alice29.txt | 159425 | 4340.7 ± 0.7% | 1600.4 ± 0.5% | 2455.5 ± 0.2% | 342.2 ± 0.9% | 2494.2 ± 0.5% | 506.3 ± 1.2% | 2.712 | 1.768 | 12.684 | 1.740 | 8.574 |
| string: canterbury/asyoulik.txt | 132198 | 3504.1 ± 0.9% | 1458.4 ± 0.1% | 2247.5 ± 0.6% | 335.1 ± 1.0% | 2093.7 ± 0.2% | 455.2 ± 1.4% | 2.403 | 1.559 | 10.456 | 1.674 | 7.698 |
| string: canterbury/lcet10.txt | 441884 | 5110.1 ± 0.5% | 1854.6 ± 0.1% | 2335.2 ± 1.3% | 389.8 ± 0.3% | 2861.5 ± 0.5% | 534.3 ± 4.1% | 2.755 | 2.188 | 13.110 | 1.786 | 9.563 |
| string: canterbury/plrabn12.txt | 503330 | 4137.2 ± 0.2% | 1737.1 ± 0.5% | 2058.1 ± 0.4% | 360.3 ± 0.8% | 2475.8 ± 0.4% | 498.9 ± 0.9% | 2.382 | 2.010 | 11.483 | 1.671 | 8.293 |
| string: canterbury-large/E.coli | 1048578 | 11892.6 ± 0.9% | 3599.7 ± 0.5% | 3249.7 ± 0.8% | 931.5 ± 1.0% | 6002.0 ± 1.0% | 762.0 ± 1.5% | 3.304 | 3.660 | 12.767 | 1.981 | 15.607 |
| string: canterbury-large/bible.txt | 1055886 | 6887.9 ± 1.7% | 2940.7 ± 0.4% | 2825.9 ± 0.5% | 419.6 ± 1.1% | 3762.5 ± 1.1% | 615.0 ± 4.1% | 2.342 | 2.437 | 16.415 | 1.831 | 11.199 |
| string: canterbury-large/world192.txt | 1103121 | 3396.3 ± 0.5% | 1480.8 ± 0.2% | 2011.9 ± 0.4% | 352.9 ± 0.6% | 2118.7 ± 1.1% | 501.9 ± 1.0% | 2.294 | 1.688 | 9.623 | 1.603 | 6.767 |
| string: http/html-1m | 1058582 | 6226.4 ± 0.8% | 2737.5 ± 0.4% | 2699.5 ± 0.7% | 442.1 ± 0.2% | 3487.1 ± 0.9% | 599.5 ± 1.1% | 2.274 | 2.306 | 14.083 | 1.786 | 10.385 |
| string: http/json-1m | 1190272 | 2555.8 ± 0.5% | 875.9 ± 0.2% | 2252.3 ± 0.5% | 391.7 ± 0.4% | 1046.3 ± 1.8% | 443.3 ± 0.7% | 2.918 | 1.135 | 6.525 | 2.443 | 5.765 |
| string: http/js-1m | 1144362 | 2290.0 ± 0.8% | 1027.5 ± 0.1% | 1637.6 ± 0.3% | 321.8 ± 0.3% | 1520.8 ± 1.0% | 418.5 ± 0.5% | 2.229 | 1.398 | 7.117 | 1.506 | 5.472 |
| string: http/css-1m | 1097820 | 2657.0 ± 0.3% | 1678.0 ± 0.3% | 2220.1 ± 0.5% | 405.6 ± 1.2% | 1900.2 ± 1.1% | 489.4 ± 0.5% | 1.583 | 1.197 | 6.550 | 1.398 | 5.429 |
| string: dickens as Cyrillic and CJK | 1883069 | 3081.1 ± 0.4% | 1685.3 ± 0.3% | 891.2 ± 0.5% | 351.3 ± 0.2% | 667.2 ± 0.5% | 157.8 ± 2.2% | 1.828 | 3.457 | 8.770 | 4.618 | 19.528 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.4 ± 0.1% | 980.1 ± 0.2% | 1200.0 ± 0.9% | 213.4 ± 0.2% | 469.7 ± 0.5% | 250.6 ± 4.4% | 1.356 | 1.108 | 6.230 | 2.831 | 5.306 |
| hex: silesia/dickens | 524290 | 12004.3 ± 0.0% | 3615.8 ± 0.2% | 3286.9 ± 0.4% | 509.0 ± 1.3% | 6146.4 ± 1.6% | 781.1 ± 3.0% | 3.320 | 3.652 | 23.582 | 1.953 | 15.368 |
| hex: silesia/mozilla | 524290 | 12012.6 ± 0.1% | 3616.8 ± 0.2% | 3300.6 ± 0.2% | 445.6 ± 0.9% | 6111.5 ± 1.3% | 784.3 ± 0.5% | 3.321 | 3.640 | 26.959 | 1.966 | 15.316 |
| hex: silesia/mr | 524290 | 12007.1 ± 0.1% | 3613.4 ± 0.2% | 3295.8 ± 0.3% | 580.1 ± 1.5% | 6132.1 ± 1.1% | 783.7 ± 0.4% | 3.323 | 3.643 | 20.699 | 1.958 | 15.321 |
| hex: silesia/nci | 524290 | 12003.2 ± 0.1% | 3615.5 ± 0.3% | 3284.6 ± 0.1% | 637.8 ± 6.1% | 6103.9 ± 1.3% | 782.3 ± 0.3% | 3.320 | 3.654 | 18.819 | 1.966 | 15.343 |
| hex: silesia/ooffice | 524290 | 11983.4 ± 0.2% | 3616.8 ± 0.2% | 3290.6 ± 0.4% | 403.3 ± 1.0% | 6086.1 ± 1.4% | 783.8 ± 0.6% | 3.313 | 3.642 | 29.716 | 1.969 | 15.289 |
| hex: silesia/osdb | 524290 | 12005.9 ± 0.1% | 3619.6 ± 0.2% | 3302.7 ± 0.3% | 482.8 ± 0.3% | 6102.9 ± 0.8% | 783.9 ± 0.4% | 3.317 | 3.635 | 24.867 | 1.967 | 15.316 |
| hex: silesia/reymont | 524290 | 11986.6 ± 0.1% | 3613.0 ± 0.5% | 3287.6 ± 0.4% | 514.1 ± 2.1% | 6089.4 ± 2.0% | 782.4 ± 0.3% | 3.318 | 3.646 | 23.315 | 1.968 | 15.320 |
| hex: silesia/samba | 524290 | 11961.3 ± 0.1% | 3617.4 ± 0.2% | 3289.6 ± 0.1% | 406.1 ± 0.7% | 6022.7 ± 0.2% | 783.7 ± 0.3% | 3.307 | 3.636 | 29.455 | 1.986 | 15.262 |
| hex: silesia/sao | 524290 | 11993.6 ± 0.1% | 3618.2 ± 0.1% | 3289.7 ± 0.4% | 344.5 ± 1.2% | 6065.4 ± 1.2% | 784.8 ± 0.6% | 3.315 | 3.646 | 34.814 | 1.977 | 15.283 |
| hex: silesia/webster | 524290 | 12011.6 ± 0.1% | 3616.1 ± 0.2% | 3298.2 ± 0.2% | 468.6 ± 0.6% | 6089.3 ± 1.4% | 782.8 ± 0.6% | 3.322 | 3.642 | 25.632 | 1.973 | 15.344 |
| hex: silesia/x-ray | 524290 | 12000.0 ± 0.1% | 3613.4 ± 0.3% | 3291.7 ± 1.2% | 476.3 ± 0.7% | 6109.7 ± 0.7% | 782.0 ± 0.5% | 3.321 | 3.646 | 25.197 | 1.964 | 15.346 |
| hex: silesia/xml | 524290 | 11989.9 ± 0.4% | 3615.6 ± 0.2% | 3291.5 ± 0.2% | 522.1 ± 0.5% | 6117.8 ± 1.0% | 784.0 ± 0.5% | 3.316 | 3.643 | 22.963 | 1.960 | 15.293 |
| hex: canterbury/alice29.txt | 304180 | 12008.2 ± 0.2% | 3641.7 ± 0.0% | 3371.5 ± 0.1% | 503.8 ± 0.6% | 6103.0 ± 1.6% | 782.7 ± 0.2% | 3.297 | 3.562 | 23.837 | 1.968 | 15.342 |
| hex: canterbury/asyoulik.txt | 250360 | 12002.2 ± 0.1% | 3640.9 ± 0.1% | 3370.7 ± 0.0% | 495.5 ± 0.6% | 6142.1 ± 1.5% | 781.1 ± 0.5% | 3.296 | 3.561 | 24.221 | 1.954 | 15.367 |
| hex: canterbury/cp.html | 49208 | 11911.2 ± 0.0% | 3638.3 ± 0.0% | 3289.8 ± 0.2% | 465.8 ± 2.1% | 6280.5 ± 0.2% | 770.1 ± 1.4% | 3.274 | 3.621 | 25.569 | 1.897 | 15.467 |
| hex: canterbury/fields.c | 22302 | 11785.8 ± 0.0% | 3628.9 ± 0.0% | 3361.7 ± 0.1% | 497.8 ± 0.3% | 6254.9 ± 0.7% | 760.6 ± 2.3% | 3.248 | 3.506 | 23.677 | 1.884 | 15.495 |
| hex: canterbury/grammar.lsp | 7444 | 11277.2 ± 0.1% | 3600.7 ± 0.0% | 3352.3 ± 0.6% | 540.8 ± 0.6% | 6170.1 ± 0.9% | 723.8 ± 2.9% | 3.132 | 3.364 | 20.852 | 1.828 | 15.580 |
| hex: canterbury/kennedy.xls | 524290 | 11980.6 ± 0.1% | 3613.9 ± 0.1% | 3294.3 ± 0.2% | 660.6 ± 5.1% | 6048.4 ± 1.1% | 781.4 ± 5.2% | 3.315 | 3.637 | 18.137 | 1.981 | 15.332 |
| hex: canterbury/lcet10.txt | 524290 | 12018.4 ± 0.0% | 3611.1 ± 0.3% | 3283.9 ± 0.3% | 504.1 ± 2.4% | 6134.8 ± 1.2% | 782.5 ± 0.4% | 3.328 | 3.660 | 23.839 | 1.959 | 15.360 |
| hex: canterbury/plrabn12.txt | 524290 | 11983.4 ± 0.1% | 3613.4 ± 0.2% | 3297.2 ± 0.3% | 503.8 ± 1.1% | 6085.6 ± 2.4% | 783.3 ± 0.4% | 3.316 | 3.634 | 23.787 | 1.969 | 15.298 |
| hex: canterbury/ptt5 | 524290 | 12014.6 ± 0.1% | 3613.9 ± 0.4% | 3283.0 ± 0.2% | 558.0 ± 1.7% | 6142.1 ± 0.7% | 782.3 ± 0.3% | 3.325 | 3.660 | 21.531 | 1.956 | 15.358 |
| hex: canterbury/sum | 76482 | 11913.4 ± 0.0% | 3634.0 ± 0.0% | 3356.2 ± 0.3% | 497.0 ± 1.0% | 6173.1 ± 0.7% | 775.8 ± 1.4% | 3.278 | 3.550 | 23.968 | 1.930 | 15.357 |
| hex: canterbury/xargs.1 | 8456 | 11356.6 ± 0.1% | 3601.7 ± 0.0% | 3366.1 ± 0.1% | 492.6 ± 3.6% | 6153.9 ± 0.3% | 757.5 ± 1.2% | 3.153 | 3.374 | 23.056 | 1.845 | 14.992 |
| hex: canterbury-large/E.coli | 524290 | 11988.9 ± 0.2% | 3615.7 ± 0.2% | 3292.8 ± 0.2% | 688.2 ± 0.3% | 6123.7 ± 1.1% | 781.0 ± 3.9% | 3.316 | 3.641 | 17.421 | 1.958 | 15.351 |
| hex: canterbury-large/bible.txt | 524290 | 11995.6 ± 0.2% | 3615.6 ± 0.3% | 3283.9 ± 0.3% | 516.9 ± 0.7% | 6111.3 ± 1.0% | 783.6 ± 0.6% | 3.318 | 3.653 | 23.208 | 1.963 | 15.309 |
| hex: canterbury-large/world192.txt | 524290 | 12003.0 ± 0.1% | 3621.3 ± 0.2% | 3288.7 ± 0.4% | 484.3 ± 2.1% | 6126.7 ± 0.9% | 783.8 ± 0.9% | 3.315 | 3.650 | 24.785 | 1.959 | 15.315 |
| hex: http/html-1kx1024 | 2099200 | 8614.3 ± 5.5% | 3458.7 ± 0.2% | 2845.2 ± 0.8% | 475.1 ± 0.6% | 5069.8 ± 0.7% | 624.1 ± 3.6% | 2.491 | 3.028 | 18.133 | 1.699 | 13.802 |
| hex: http/html-16kx64 | 2097280 | 11762.8 ± 0.2% | 3607.2 ± 0.1% | 3255.5 ± 0.3% | 477.8 ± 0.5% | 6013.3 ± 0.5% | 740.8 ± 4.1% | 3.261 | 3.613 | 24.618 | 1.956 | 15.878 |
| hex: http/html-1m | 524290 | 12016.6 ± 0.1% | 3622.0 ± 0.2% | 3277.8 ± 0.4% | 494.1 ± 0.5% | 6133.7 ± 2.0% | 775.0 ± 3.8% | 3.318 | 3.666 | 24.322 | 1.959 | 15.506 |
| hex: http/json-1kx1024 | 2099200 | 8681.3 ± 4.9% | 3461.3 ± 0.0% | 2846.3 ± 0.4% | 574.3 ± 0.4% | 5086.7 ± 0.5% | 628.2 ± 2.3% | 2.508 | 3.050 | 15.116 | 1.707 | 13.819 |
| hex: http/json-16kx64 | 2097280 | 11757.1 ± 0.1% | 3608.8 ± 0.2% | 3258.3 ± 0.3% | 573.2 ± 1.3% | 6014.6 ± 0.7% | 740.0 ± 2.6% | 3.258 | 3.608 | 20.510 | 1.955 | 15.889 |
| hex: http/json-1m | 524290 | 12013.7 ± 0.2% | 3615.9 ± 0.1% | 3302.3 ± 0.2% | 582.6 ± 0.7% | 6135.1 ± 1.3% | 771.5 ± 3.5% | 3.322 | 3.638 | 20.622 | 1.958 | 15.572 |
| hex: http/js-1kx1024 | 2099200 | 8618.3 ± 5.9% | 3455.6 ± 0.3% | 2838.9 ± 0.5% | 480.9 ± 0.7% | 5068.4 ± 1.6% | 619.3 ± 2.4% | 2.494 | 3.036 | 17.920 | 1.700 | 13.917 |
| hex: http/js-16kx64 | 2097280 | 11752.0 ± 0.1% | 3608.2 ± 0.1% | 3259.8 ± 0.1% | 480.5 ± 2.0% | 6021.5 ± 0.7% | 744.2 ± 1.5% | 3.257 | 3.605 | 24.460 | 1.952 | 15.791 |
| hex: http/js-1m | 524290 | 12002.4 ± 0.1% | 3615.4 ± 0.1% | 3294.9 ± 0.4% | 496.8 ± 1.7% | 6147.5 ± 1.0% | 779.5 ± 4.5% | 3.320 | 3.643 | 24.157 | 1.952 | 15.397 |
| hex: http/css-1kx1024 | 2099200 | 8725.9 ± 4.7% | 3460.7 ± 0.3% | 2847.6 ± 0.5% | 490.0 ± 0.8% | 5113.1 ± 1.3% | 623.8 ± 2.3% | 2.521 | 3.064 | 17.808 | 1.707 | 13.988 |
| hex: http/css-16kx64 | 2097280 | 11759.7 ± 0.2% | 3608.8 ± 0.1% | 3255.0 ± 0.4% | 494.7 ± 1.6% | 6010.3 ± 0.3% | 750.4 ± 4.2% | 3.259 | 3.613 | 23.770 | 1.957 | 15.671 |
| hex: http/css-1m | 524290 | 11888.8 ± 0.4% | 3617.3 ± 0.2% | 3283.2 ± 0.2% | 507.6 ± 1.4% | 6051.2 ± 1.7% | 767.0 ± 2.6% | 3.287 | 3.621 | 23.419 | 1.965 | 15.499 |
| hex: shuffled/dickens-1m | 524290 | 11965.5 ± 0.1% | 3613.7 ± 0.2% | 3281.4 ± 0.2% | 524.2 ± 1.5% | 5968.4 ± 0.7% | 778.9 ± 0.8% | 3.311 | 3.647 | 22.825 | 2.005 | 15.362 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1012.7 ± 0.3% | 929.9 ± 0.3% | 1022.6 ± 0.3% | 300.7 ± 1.0% | 665.3 ± 0.1% | 310.1 ± 1.3% | 1.089 | 0.990 | 3.368 | 1.522 | 3.265 |
| qlog records, JSON text sequence | 1467503 | 836.7 ± 0.7% | 817.6 ± 0.2% | 786.8 ± 2.3% | 244.0 ± 0.4% | 698.7 ± 0.4% | 250.0 ± 2.7% | 1.023 | 1.063 | 3.430 | 1.198 | 3.347 |
| string: silesia/dickens | 172528 | 5060.6 ± 0.2% | 1879.4 ± 0.2% | 2646.8 ± 0.3% | 362.3 ± 1.4% | 2874.1 ± 0.3% | 552.8 ± 2.2% | 2.693 | 1.912 | 13.969 | 1.761 | 9.154 |
| string: silesia/nci | 1075110 | 4315.2 ± 0.1% | 2233.8 ± 0.6% | 2997.4 ± 0.3% | 546.6 ± 0.4% | 2997.2 ± 0.8% | 597.1 ± 1.5% | 1.932 | 1.440 | 7.895 | 1.440 | 7.227 |
| string: silesia/reymont | 1075159 | 2971.8 ± 1.6% | 1819.6 ± 2.1% | 2061.5 ± 0.5% | 375.0 ± 1.2% | 2145.8 ± 0.5% | 535.6 ± 1.3% | 1.633 | 1.442 | 7.926 | 1.385 | 5.549 |
| string: silesia/samba | 97582 | 3509.0 ± 0.1% | 2026.0 ± 0.6% | 2618.3 ± 0.8% | 322.4 ± 0.4% | 1507.1 ± 0.8% | 425.7 ± 1.3% | 1.732 | 1.340 | 10.886 | 2.328 | 8.243 |
| string: silesia/webster | 1098490 | 3670.3 ± 0.5% | 1518.0 ± 0.3% | 2013.1 ± 0.3% | 359.0 ± 0.2% | 2173.4 ± 1.0% | 495.5 ± 1.4% | 2.418 | 1.823 | 10.223 | 1.689 | 7.407 |
| string: silesia/xml | 1090118 | 4811.2 ± 0.6% | 2359.8 ± 0.2% | 2530.8 ± 0.2% | 454.0 ± 1.0% | 2801.1 ± 0.8% | 562.0 ± 0.7% | 2.039 | 1.901 | 10.597 | 1.718 | 8.561 |
| string: canterbury/alice29.txt | 159425 | 4348.6 ± 0.8% | 1600.4 ± 0.5% | 2455.5 ± 0.2% | 342.2 ± 0.9% | 2494.2 ± 0.5% | 506.3 ± 1.2% | 2.717 | 1.771 | 12.707 | 1.743 | 8.590 |
| string: canterbury/asyoulik.txt | 132198 | 3508.0 ± 0.9% | 1458.4 ± 0.1% | 2247.5 ± 0.6% | 335.1 ± 1.0% | 2093.7 ± 0.2% | 455.2 ± 1.4% | 2.405 | 1.561 | 10.468 | 1.676 | 7.706 |
| string: canterbury/lcet10.txt | 441884 | 5105.6 ± 0.5% | 1854.6 ± 0.1% | 2335.2 ± 1.3% | 389.8 ± 0.3% | 2861.5 ± 0.5% | 534.3 ± 4.1% | 2.753 | 2.186 | 13.098 | 1.784 | 9.555 |
| string: canterbury/plrabn12.txt | 503330 | 4135.9 ± 0.4% | 1737.1 ± 0.5% | 2058.1 ± 0.4% | 360.3 ± 0.8% | 2475.8 ± 0.4% | 498.9 ± 0.9% | 2.381 | 2.010 | 11.479 | 1.671 | 8.290 |
| string: canterbury-large/E.coli | 1048578 | 11918.3 ± 0.4% | 3599.7 ± 0.5% | 3249.7 ± 0.8% | 931.5 ± 1.0% | 6002.0 ± 1.0% | 762.0 ± 1.5% | 3.311 | 3.668 | 12.795 | 1.986 | 15.641 |
| string: canterbury-large/bible.txt | 1055886 | 6900.4 ± 1.9% | 2940.7 ± 0.4% | 2825.9 ± 0.5% | 419.6 ± 1.1% | 3762.5 ± 1.1% | 615.0 ± 4.1% | 2.347 | 2.442 | 16.445 | 1.834 | 11.220 |
| string: canterbury-large/world192.txt | 1103121 | 3398.8 ± 0.3% | 1480.8 ± 0.2% | 2011.9 ± 0.4% | 352.9 ± 0.6% | 2118.7 ± 1.1% | 501.9 ± 1.0% | 2.295 | 1.689 | 9.630 | 1.604 | 6.772 |
| string: http/html-1m | 1058582 | 6260.5 ± 1.1% | 2737.5 ± 0.4% | 2699.5 ± 0.7% | 442.1 ± 0.2% | 3487.1 ± 0.9% | 599.5 ± 1.1% | 2.287 | 2.319 | 14.160 | 1.795 | 10.442 |
| string: http/json-1m | 1190272 | 2554.5 ± 0.3% | 875.9 ± 0.2% | 2252.3 ± 0.5% | 391.7 ± 0.4% | 1046.3 ± 1.8% | 443.3 ± 0.7% | 2.916 | 1.134 | 6.522 | 2.441 | 5.762 |
| string: http/js-1m | 1144362 | 2289.6 ± 0.7% | 1027.5 ± 0.1% | 1637.6 ± 0.3% | 321.8 ± 0.3% | 1520.8 ± 1.0% | 418.5 ± 0.5% | 2.228 | 1.398 | 7.116 | 1.506 | 5.471 |
| string: http/css-1m | 1097820 | 2659.2 ± 0.6% | 1678.0 ± 0.3% | 2220.1 ± 0.5% | 405.6 ± 1.2% | 1900.2 ± 1.1% | 489.4 ± 0.5% | 1.585 | 1.198 | 6.556 | 1.399 | 5.434 |
| string: dickens as Cyrillic and CJK | 1883069 | 3075.5 ± 0.2% | 1685.3 ± 0.3% | 891.2 ± 0.5% | 351.3 ± 0.2% | 667.2 ± 0.5% | 157.8 ± 2.2% | 1.825 | 3.451 | 8.754 | 4.610 | 19.492 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.5 ± 0.1% | 980.1 ± 0.2% | 1200.0 ± 0.9% | 213.4 ± 0.2% | 469.7 ± 0.5% | 250.6 ± 4.4% | 1.358 | 1.109 | 6.235 | 2.833 | 5.310 |
| hex: silesia/dickens | 524290 | 11999.1 ± 0.1% | 3615.8 ± 0.2% | 3286.9 ± 0.4% | 509.0 ± 1.3% | 6146.4 ± 1.6% | 781.1 ± 3.0% | 3.319 | 3.651 | 23.572 | 1.952 | 15.361 |
| hex: silesia/mozilla | 524290 | 12016.7 ± 0.0% | 3616.8 ± 0.2% | 3300.6 ± 0.2% | 445.6 ± 0.9% | 6111.5 ± 1.3% | 784.3 ± 0.5% | 3.322 | 3.641 | 26.969 | 1.966 | 15.321 |
| hex: silesia/mr | 524290 | 12014.9 ± 0.4% | 3613.4 ± 0.2% | 3295.8 ± 0.3% | 580.1 ± 1.5% | 6132.1 ± 1.1% | 783.7 ± 0.4% | 3.325 | 3.646 | 20.712 | 1.959 | 15.331 |
| hex: silesia/nci | 524290 | 11998.3 ± 0.1% | 3615.5 ± 0.3% | 3284.6 ± 0.1% | 637.8 ± 6.1% | 6103.9 ± 1.3% | 782.3 ± 0.3% | 3.319 | 3.653 | 18.811 | 1.966 | 15.337 |
| hex: silesia/ooffice | 524290 | 11974.9 ± 0.2% | 3616.8 ± 0.2% | 3290.6 ± 0.4% | 403.3 ± 1.0% | 6086.1 ± 1.4% | 783.8 ± 0.6% | 3.311 | 3.639 | 29.695 | 1.968 | 15.278 |
| hex: silesia/osdb | 524290 | 12000.4 ± 0.1% | 3619.6 ± 0.2% | 3302.7 ± 0.3% | 482.8 ± 0.3% | 6102.9 ± 0.8% | 783.9 ± 0.4% | 3.315 | 3.633 | 24.856 | 1.966 | 15.309 |
| hex: silesia/reymont | 524290 | 11984.3 ± 0.4% | 3613.0 ± 0.5% | 3287.6 ± 0.4% | 514.1 ± 2.1% | 6089.4 ± 2.0% | 782.4 ± 0.3% | 3.317 | 3.645 | 23.310 | 1.968 | 15.317 |
| hex: silesia/samba | 524290 | 11967.2 ± 0.1% | 3617.4 ± 0.2% | 3289.6 ± 0.1% | 406.1 ± 0.7% | 6022.7 ± 0.2% | 783.7 ± 0.3% | 3.308 | 3.638 | 29.470 | 1.987 | 15.269 |
| hex: silesia/sao | 524290 | 11987.4 ± 0.2% | 3618.2 ± 0.1% | 3289.7 ± 0.4% | 344.5 ± 1.2% | 6065.4 ± 1.2% | 784.8 ± 0.6% | 3.313 | 3.644 | 34.796 | 1.976 | 15.275 |
| hex: silesia/webster | 524290 | 12006.0 ± 0.1% | 3616.1 ± 0.2% | 3298.2 ± 0.2% | 468.6 ± 0.6% | 6089.3 ± 1.4% | 782.8 ± 0.6% | 3.320 | 3.640 | 25.620 | 1.972 | 15.337 |
| hex: silesia/x-ray | 524290 | 11994.4 ± 0.1% | 3613.4 ± 0.3% | 3291.7 ± 1.2% | 476.3 ± 0.7% | 6109.7 ± 0.7% | 782.0 ± 0.5% | 3.319 | 3.644 | 25.185 | 1.963 | 15.339 |
| hex: silesia/xml | 524290 | 11997.6 ± 0.1% | 3615.6 ± 0.2% | 3291.5 ± 0.2% | 522.1 ± 0.5% | 6117.8 ± 1.0% | 784.0 ± 0.5% | 3.318 | 3.645 | 22.977 | 1.961 | 15.303 |
| hex: canterbury/alice29.txt | 304180 | 12015.9 ± 0.1% | 3641.7 ± 0.0% | 3371.5 ± 0.1% | 503.8 ± 0.6% | 6103.0 ± 1.6% | 782.7 ± 0.2% | 3.300 | 3.564 | 23.852 | 1.969 | 15.352 |
| hex: canterbury/asyoulik.txt | 250360 | 12010.5 ± 0.1% | 3640.9 ± 0.1% | 3370.7 ± 0.0% | 495.5 ± 0.6% | 6142.1 ± 1.5% | 781.1 ± 0.5% | 3.299 | 3.563 | 24.238 | 1.955 | 15.377 |
| hex: canterbury/cp.html | 49208 | 11909.0 ± 0.0% | 3638.3 ± 0.0% | 3289.8 ± 0.2% | 465.8 ± 2.1% | 6280.5 ± 0.2% | 770.1 ± 1.4% | 3.273 | 3.620 | 25.564 | 1.896 | 15.464 |
| hex: canterbury/fields.c | 22302 | 11785.5 ± 0.0% | 3628.9 ± 0.0% | 3361.7 ± 0.1% | 497.8 ± 0.3% | 6254.9 ± 0.7% | 760.6 ± 2.3% | 3.248 | 3.506 | 23.677 | 1.884 | 15.495 |
| hex: canterbury/grammar.lsp | 7444 | 11332.1 ± 0.2% | 3600.7 ± 0.0% | 3352.3 ± 0.6% | 540.8 ± 0.6% | 6170.1 ± 0.9% | 723.8 ± 2.9% | 3.147 | 3.380 | 20.953 | 1.837 | 15.656 |
| hex: canterbury/kennedy.xls | 524290 | 11980.9 ± 0.1% | 3613.9 ± 0.1% | 3294.3 ± 0.2% | 660.6 ± 5.1% | 6048.4 ± 1.1% | 781.4 ± 5.2% | 3.315 | 3.637 | 18.138 | 1.981 | 15.333 |
| hex: canterbury/lcet10.txt | 524290 | 12008.1 ± 0.1% | 3611.1 ± 0.3% | 3283.9 ± 0.3% | 504.1 ± 2.4% | 6134.8 ± 1.2% | 782.5 ± 0.4% | 3.325 | 3.657 | 23.819 | 1.957 | 15.347 |
| hex: canterbury/plrabn12.txt | 524290 | 11980.1 ± 0.1% | 3613.4 ± 0.2% | 3297.2 ± 0.3% | 503.8 ± 1.1% | 6085.6 ± 2.4% | 783.3 ± 0.4% | 3.315 | 3.633 | 23.781 | 1.969 | 15.294 |
| hex: canterbury/ptt5 | 524290 | 12011.5 ± 0.1% | 3613.9 ± 0.4% | 3283.0 ± 0.2% | 558.0 ± 1.7% | 6142.1 ± 0.7% | 782.3 ± 0.3% | 3.324 | 3.659 | 21.526 | 1.956 | 15.354 |
| hex: canterbury/sum | 76482 | 11909.4 ± 0.5% | 3634.0 ± 0.0% | 3356.2 ± 0.3% | 497.0 ± 1.0% | 6173.1 ± 0.7% | 775.8 ± 1.4% | 3.277 | 3.548 | 23.960 | 1.929 | 15.352 |
| hex: canterbury/xargs.1 | 8456 | 11350.6 ± 0.0% | 3601.7 ± 0.0% | 3366.1 ± 0.1% | 492.6 ± 3.6% | 6153.9 ± 0.3% | 757.5 ± 1.2% | 3.151 | 3.372 | 23.044 | 1.844 | 14.984 |
| hex: canterbury-large/E.coli | 524290 | 11981.8 ± 0.1% | 3615.7 ± 0.2% | 3292.8 ± 0.2% | 688.2 ± 0.3% | 6123.7 ± 1.1% | 781.0 ± 3.9% | 3.314 | 3.639 | 17.411 | 1.957 | 15.342 |
| hex: canterbury-large/bible.txt | 524290 | 11987.2 ± 0.5% | 3615.6 ± 0.3% | 3283.9 ± 0.3% | 516.9 ± 0.7% | 6111.3 ± 1.0% | 783.6 ± 0.6% | 3.315 | 3.650 | 23.192 | 1.961 | 15.298 |
| hex: canterbury-large/world192.txt | 524290 | 11986.0 ± 0.0% | 3621.3 ± 0.2% | 3288.7 ± 0.4% | 484.3 ± 2.1% | 6126.7 ± 0.9% | 783.8 ± 0.9% | 3.310 | 3.645 | 24.750 | 1.956 | 15.293 |
| hex: http/html-1kx1024 | 2099200 | 8682.6 ± 5.3% | 3458.7 ± 0.2% | 2845.2 ± 0.8% | 475.1 ± 0.6% | 5069.8 ± 0.7% | 624.1 ± 3.6% | 2.510 | 3.052 | 18.276 | 1.713 | 13.911 |
| hex: http/html-16kx64 | 2097280 | 11770.3 ± 0.1% | 3607.2 ± 0.1% | 3255.5 ± 0.3% | 477.8 ± 0.5% | 6013.3 ± 0.5% | 740.8 ± 4.1% | 3.263 | 3.615 | 24.634 | 1.957 | 15.888 |
| hex: http/html-1m | 524290 | 12013.1 ± 0.1% | 3622.0 ± 0.2% | 3277.8 ± 0.4% | 494.1 ± 0.5% | 6133.7 ± 2.0% | 775.0 ± 3.8% | 3.317 | 3.665 | 24.315 | 1.959 | 15.501 |
| hex: http/json-1kx1024 | 2099200 | 8795.9 ± 5.2% | 3461.3 ± 0.0% | 2846.3 ± 0.4% | 574.3 ± 0.4% | 5086.7 ± 0.5% | 628.2 ± 2.3% | 2.541 | 3.090 | 15.315 | 1.729 | 14.001 |
| hex: http/json-16kx64 | 2097280 | 11765.3 ± 0.2% | 3608.8 ± 0.2% | 3258.3 ± 0.3% | 573.2 ± 1.3% | 6014.6 ± 0.7% | 740.0 ± 2.6% | 3.260 | 3.611 | 20.524 | 1.956 | 15.900 |
| hex: http/json-1m | 524290 | 12023.4 ± 0.1% | 3615.9 ± 0.1% | 3302.3 ± 0.2% | 582.6 ± 0.7% | 6135.1 ± 1.3% | 771.5 ± 3.5% | 3.325 | 3.641 | 20.638 | 1.960 | 15.585 |
| hex: http/js-1kx1024 | 2099200 | 8637.4 ± 6.8% | 3455.6 ± 0.3% | 2838.9 ± 0.5% | 480.9 ± 0.7% | 5068.4 ± 1.6% | 619.3 ± 2.4% | 2.500 | 3.043 | 17.960 | 1.704 | 13.947 |
| hex: http/js-16kx64 | 2097280 | 11765.3 ± 0.1% | 3608.2 ± 0.1% | 3259.8 ± 0.1% | 480.5 ± 2.0% | 6021.5 ± 0.7% | 744.2 ± 1.5% | 3.261 | 3.609 | 24.488 | 1.954 | 15.809 |
| hex: http/js-1m | 524290 | 12007.2 ± 0.1% | 3615.4 ± 0.1% | 3294.9 ± 0.4% | 496.8 ± 1.7% | 6147.5 ± 1.0% | 779.5 ± 4.5% | 3.321 | 3.644 | 24.167 | 1.953 | 15.403 |
| hex: http/css-1kx1024 | 2099200 | 8778.9 ± 5.0% | 3460.7 ± 0.3% | 2847.6 ± 0.5% | 490.0 ± 0.8% | 5113.1 ± 1.3% | 623.8 ± 2.3% | 2.537 | 3.083 | 17.916 | 1.717 | 14.073 |
| hex: http/css-16kx64 | 2097280 | 11762.7 ± 0.1% | 3608.8 ± 0.1% | 3255.0 ± 0.4% | 494.7 ± 1.6% | 6010.3 ± 0.3% | 750.4 ± 4.2% | 3.259 | 3.614 | 23.776 | 1.957 | 15.675 |
| hex: http/css-1m | 524290 | 11917.1 ± 0.1% | 3617.3 ± 0.2% | 3283.2 ± 0.2% | 507.6 ± 1.4% | 6051.2 ± 1.7% | 767.0 ± 2.6% | 3.294 | 3.630 | 23.475 | 1.969 | 15.536 |
| hex: shuffled/dickens-1m | 524290 | 11971.1 ± 0.1% | 3613.7 ± 0.2% | 3281.4 ± 0.2% | 524.2 ± 1.5% | 5968.4 ± 0.7% | 778.9 ± 0.8% | 3.313 | 3.648 | 22.836 | 2.006 | 15.369 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1357.6 ± 0.3% | 1252.1 ± 0.5% | 1039.9 ± 0.6% | 409.2 ± 0.3% | 448.8 ± 0.3% | 415.7 ± 0.1% | 1.084 | 1.306 | 3.317 | 3.025 | 3.266 |
| qlog records, JSON text sequence | 1467503 | 1054.2 ± 0.1% | 1064.6 ± 0.3% | 780.1 ± 0.3% | 378.5 ± 0.5% | 466.5 ± 0.3% | 279.1 ± 0.3% | 0.990 | 1.351 | 2.785 | 2.260 | 3.777 |
| string: silesia/dickens | 172528 | 6915.3 ± 0.2% | 2812.1 ± 0.1% | 2930.7 ± 0.9% | 429.5 ± 0.4% | 1564.4 ± 0.6% | 1010.5 ± 0.1% | 2.459 | 2.360 | 16.100 | 4.421 | 6.843 |
| string: silesia/nci | 1075110 | 7314.3 ± 0.6% | 3424.6 ± 0.9% | 3107.7 ± 0.1% | 816.3 ± 0.7% | 1835.8 ± 0.3% | 1107.3 ± 0.3% | 2.136 | 2.354 | 8.961 | 3.984 | 6.605 |
| string: silesia/reymont | 1075159 | 3328.4 ± 0.9% | 1986.6 ± 1.5% | 2060.8 ± 0.4% | 447.4 ± 1.4% | 1488.1 ± 1.2% | 951.1 ± 0.3% | 1.675 | 1.615 | 7.440 | 2.237 | 3.499 |
| string: silesia/samba | 97582 | 4211.5 ± 1.1% | 2106.3 ± 0.6% | 3445.9 ± 1.2% | 353.2 ± 0.8% | 1408.3 ± 0.3% | 1055.7 ± 0.2% | 1.999 | 1.222 | 11.923 | 2.990 | 3.989 |
| string: silesia/webster | 1098490 | 4070.8 ± 0.4% | 1877.8 ± 0.6% | 2049.9 ± 0.8% | 442.3 ± 0.3% | 1372.1 ± 0.2% | 646.7 ± 1.3% | 2.168 | 1.986 | 9.204 | 2.967 | 6.295 |
| string: silesia/xml | 1090118 | 6127.6 ± 0.4% | 2863.9 ± 0.6% | 2644.6 ± 0.4% | 608.6 ± 0.5% | 1731.4 ± 0.4% | 922.1 ± 0.8% | 2.140 | 2.317 | 10.069 | 3.539 | 6.645 |
| string: canterbury/alice29.txt | 159425 | 6466.8 ± 0.6% | 2195.2 ± 0.5% | 2771.4 ± 0.7% | 404.6 ± 0.9% | 1439.6 ± 0.1% | 955.2 ± 0.2% | 2.946 | 2.333 | 15.983 | 4.492 | 6.770 |
| string: canterbury/asyoulik.txt | 132198 | 5645.7 ± 0.7% | 1710.0 ± 0.5% | 2377.3 ± 1.0% | 402.6 ± 0.5% | 1307.6 ± 0.5% | 885.0 ± 0.3% | 3.302 | 2.375 | 14.024 | 4.317 | 6.380 |
| string: canterbury/lcet10.txt | 441884 | 6236.2 ± 0.9% | 2566.5 ± 0.3% | 2483.4 ± 1.4% | 466.8 ± 0.7% | 1525.9 ± 0.2% | 985.9 ± 0.5% | 2.430 | 2.511 | 13.360 | 4.087 | 6.325 |
| string: canterbury/plrabn12.txt | 503330 | 5723.5 ± 0.3% | 2063.6 ± 0.4% | 2068.6 ± 0.7% | 424.2 ± 0.8% | 1363.1 ± 0.3% | 928.9 ± 0.6% | 2.774 | 2.767 | 13.493 | 4.199 | 6.161 |
| string: canterbury-large/E.coli | 1048578 | 19237.7 ± 0.8% | 9711.7 ± 1.7% | 3782.0 ± 0.5% | 1475.5 ± 0.4% | 2362.1 ± 0.5% | 1193.3 ± 0.3% | 1.981 | 5.087 | 13.038 | 8.144 | 16.122 |
| string: canterbury-large/bible.txt | 1055886 | 6802.9 ± 0.5% | 4136.7 ± 1.3% | 3023.5 ± 1.3% | 504.2 ± 0.6% | 1978.4 ± 0.4% | 1122.2 ± 0.2% | 1.645 | 2.250 | 13.493 | 3.439 | 6.062 |
| string: canterbury-large/world192.txt | 1103121 | 4054.7 ± 0.3% | 1658.5 ± 0.6% | 2001.1 ± 0.8% | 450.1 ± 0.4% | 1345.0 ± 0.5% | 909.5 ± 0.4% | 2.445 | 2.026 | 9.008 | 3.015 | 4.458 |
| string: http/html-1m | 1058582 | 6758.5 ± 0.4% | 3943.3 ± 0.5% | 3041.3 ± 0.5% | 500.4 ± 0.4% | 1921.4 ± 0.5% | 804.9 ± 0.4% | 1.714 | 2.222 | 13.505 | 3.518 | 8.397 |
| string: http/json-1m | 1190272 | 3168.6 ± 0.4% | 1356.4 ± 0.4% | 1555.3 ± 0.3% | 444.3 ± 0.3% | 1035.5 ± 0.2% | 765.4 ± 0.9% | 2.336 | 2.037 | 7.132 | 3.060 | 4.140 |
| string: http/js-1m | 1144362 | 2774.6 ± 0.9% | 1182.0 ± 0.4% | 1624.4 ± 0.6% | 369.2 ± 0.2% | 1084.0 ± 0.4% | 757.7 ± 0.4% | 2.347 | 1.708 | 7.515 | 2.560 | 3.662 |
| string: http/css-1m | 1097820 | 4008.8 ± 1.1% | 1495.3 ± 0.3% | 2153.5 ± 0.6% | 493.8 ± 0.7% | 1355.5 ± 0.3% | 895.2 ± 0.2% | 2.681 | 1.862 | 8.119 | 2.957 | 4.478 |
| string: dickens as Cyrillic and CJK | 1883069 | 3072.9 ± 0.4% | 2331.6 ± 0.4% | 521.0 ± 0.4% | 307.6 ± 0.7% | 562.7 ± 1.1% | 336.1 ± 0.3% | 1.318 | 5.898 | 9.990 | 5.461 | 9.143 |
| hex: silesia/dickens | 524290 | 15652.5 ± 0.1% | 1466.9 ± 0.1% | 1085.6 ± 0.4% | 498.1 ± 0.2% | 988.6 ± 0.2% | 734.8 ± 0.5% | 10.670 | 14.419 | 31.425 | 15.833 | 21.301 |
| hex: silesia/mozilla | 524290 | 15660.5 ± 0.7% | 1475.2 ± 0.2% | 1089.5 ± 0.2% | 440.9 ± 0.4% | 992.7 ± 0.4% | 735.4 ± 0.5% | 10.616 | 14.375 | 35.516 | 15.776 | 21.294 |
| hex: silesia/mr | 524290 | 15650.4 ± 0.5% | 1483.3 ± 0.6% | 1093.6 ± 0.5% | 561.7 ± 3.9% | 996.1 ± 0.2% | 734.9 ± 0.4% | 10.551 | 14.311 | 27.864 | 15.712 | 21.296 |
| hex: silesia/nci | 524290 | 15598.7 ± 0.2% | 1476.4 ± 0.5% | 1089.4 ± 0.3% | 625.5 ± 2.8% | 991.3 ± 0.6% | 735.7 ± 0.8% | 10.565 | 14.319 | 24.936 | 15.736 | 21.203 |
| hex: silesia/ooffice | 524290 | 15629.8 ± 0.4% | 1467.3 ± 0.2% | 1086.0 ± 0.3% | 389.3 ± 0.7% | 988.8 ± 0.3% | 734.9 ± 0.2% | 10.652 | 14.393 | 40.150 | 15.806 | 21.268 |
| hex: silesia/osdb | 524290 | 15633.1 ± 0.4% | 1472.5 ± 0.2% | 1089.3 ± 0.3% | 468.6 ± 1.2% | 991.1 ± 0.4% | 733.7 ± 0.4% | 10.617 | 14.351 | 33.364 | 15.774 | 21.307 |
| hex: silesia/reymont | 524290 | 15648.7 ± 0.2% | 1464.8 ± 0.5% | 1085.6 ± 0.4% | 516.9 ± 0.5% | 990.9 ± 0.5% | 733.6 ± 0.6% | 10.683 | 14.415 | 30.272 | 15.792 | 21.330 |
| hex: silesia/samba | 524290 | 15672.6 ± 0.1% | 1468.0 ± 0.2% | 1086.1 ± 0.4% | 402.8 ± 0.1% | 992.6 ± 0.9% | 734.9 ± 0.5% | 10.676 | 14.430 | 38.905 | 15.789 | 21.325 |
| hex: silesia/sao | 524290 | 15632.1 ± 0.6% | 1465.5 ± 0.2% | 1083.8 ± 0.5% | 332.7 ± 0.5% | 991.1 ± 0.4% | 734.0 ± 0.4% | 10.667 | 14.423 | 46.985 | 15.772 | 21.299 |
| hex: silesia/webster | 524290 | 15640.4 ± 0.3% | 1469.2 ± 0.1% | 1085.2 ± 0.4% | 473.7 ± 0.7% | 990.4 ± 0.5% | 734.4 ± 0.2% | 10.645 | 14.412 | 33.021 | 15.791 | 21.297 |
| hex: silesia/x-ray | 524290 | 15640.9 ± 0.9% | 1481.1 ± 0.3% | 1091.7 ± 0.6% | 445.4 ± 1.2% | 995.5 ± 0.1% | 736.2 ± 0.3% | 10.560 | 14.327 | 35.119 | 15.712 | 21.244 |
| hex: silesia/xml | 524290 | 15658.7 ± 0.2% | 1472.5 ± 0.3% | 1087.4 ± 0.4% | 614.8 ± 1.4% | 993.1 ± 0.5% | 734.4 ± 0.6% | 10.634 | 14.400 | 25.471 | 15.767 | 21.322 |
| hex: canterbury/alice29.txt | 304180 | 15691.1 ± 0.1% | 1474.4 ± 0.5% | 1091.6 ± 0.3% | 504.5 ± 0.8% | 997.1 ± 0.6% | 734.8 ± 0.4% | 10.642 | 14.375 | 31.105 | 15.737 | 21.353 |
| hex: canterbury/asyoulik.txt | 250360 | 15721.9 ± 0.0% | 1480.2 ± 0.6% | 1093.8 ± 0.4% | 496.5 ± 1.0% | 994.6 ± 0.6% | 740.8 ± 0.5% | 10.621 | 14.374 | 31.664 | 15.807 | 21.222 |
| hex: canterbury/cp.html | 49208 | 15668.3 ± 0.0% | 1470.7 ± 0.2% | 1097.5 ± 0.2% | 531.4 ± 2.1% | 1001.3 ± 0.6% | 743.1 ± 0.2% | 10.654 | 14.276 | 29.484 | 15.648 | 21.084 |
| hex: canterbury/fields.c | 22302 | 15522.4 ± 0.1% | 1413.8 ± 0.9% | 1069.6 ± 0.9% | 616.6 ± 6.3% | 988.7 ± 0.2% | 737.2 ± 0.3% | 10.979 | 14.513 | 25.174 | 15.700 | 21.057 |
| hex: canterbury/grammar.lsp | 7444 | 15163.4 ± 0.0% | 1507.7 ± 0.2% | 1093.8 ± 0.8% | 658.3 ± 2.4% | 995.7 ± 0.4% | 726.2 ± 0.1% | 10.057 | 13.863 | 23.034 | 15.229 | 20.880 |
| hex: canterbury/kennedy.xls | 524290 | 15632.7 ± 0.4% | 1476.8 ± 0.2% | 1090.8 ± 0.3% | 654.0 ± 1.5% | 990.3 ± 0.5% | 735.0 ± 0.2% | 10.585 | 14.332 | 23.904 | 15.785 | 21.270 |
| hex: canterbury/lcet10.txt | 524290 | 15652.8 ± 0.2% | 1467.6 ± 0.3% | 1087.1 ± 0.4% | 502.7 ± 1.1% | 988.2 ± 0.3% | 735.3 ± 0.3% | 10.665 | 14.398 | 31.136 | 15.840 | 21.287 |
| hex: canterbury/plrabn12.txt | 524290 | 15650.4 ± 0.2% | 1464.3 ± 0.2% | 1083.8 ± 0.4% | 486.2 ± 2.2% | 985.8 ± 0.3% | 735.6 ± 0.3% | 10.688 | 14.440 | 32.192 | 15.876 | 21.276 |
| hex: canterbury/ptt5 | 524290 | 15620.9 ± 0.1% | 1482.6 ± 0.7% | 1091.6 ± 0.3% | 557.2 ± 0.9% | 994.3 ± 0.3% | 735.6 ± 0.6% | 10.536 | 14.310 | 28.032 | 15.710 | 21.236 |
| hex: canterbury/sum | 76482 | 15676.7 ± 0.1% | 1494.5 ± 0.1% | 1105.8 ± 0.3% | 593.9 ± 2.1% | 998.2 ± 0.0% | 743.8 ± 0.1% | 10.490 | 14.177 | 26.398 | 15.704 | 21.075 |
| hex: canterbury/xargs.1 | 8456 | 15205.5 ± 0.0% | 1492.9 ± 0.4% | 1086.8 ± 0.3% | 649.3 ± 7.8% | 1005.5 ± 0.1% | 728.3 ± 0.1% | 10.186 | 13.992 | 23.417 | 15.122 | 20.878 |
| hex: canterbury-large/E.coli | 524290 | 15656.5 ± 0.4% | 1472.3 ± 0.3% | 1090.3 ± 0.3% | 672.5 ± 0.3% | 997.0 ± 0.8% | 733.5 ± 0.5% | 10.634 | 14.359 | 23.282 | 15.704 | 21.346 |
| hex: canterbury-large/bible.txt | 524290 | 15622.7 ± 0.2% | 1463.9 ± 0.2% | 1084.9 ± 0.3% | 516.0 ± 0.6% | 988.0 ± 0.5% | 732.9 ± 0.7% | 10.672 | 14.400 | 30.274 | 15.812 | 21.316 |
| hex: canterbury-large/world192.txt | 524290 | 15642.2 ± 0.2% | 1465.1 ± 0.1% | 1086.9 ± 0.4% | 501.1 ± 0.4% | 988.3 ± 0.3% | 734.2 ± 0.3% | 10.676 | 14.391 | 31.218 | 15.828 | 21.305 |
| hex: http/html-1kx1024 | 2099200 | 14100.4 ± 0.6% | 1455.4 ± 0.5% | 1062.2 ± 0.1% | 501.3 ± 0.3% | 982.6 ± 0.1% | 692.8 ± 0.1% | 9.688 | 13.275 | 28.128 | 14.350 | 20.352 |
| hex: http/html-16kx64 | 2097280 | 15371.5 ± 0.4% | 1445.4 ± 0.5% | 1074.8 ± 0.4% | 506.3 ± 0.5% | 995.5 ± 0.3% | 734.3 ± 0.3% | 10.635 | 14.302 | 30.359 | 15.441 | 20.932 |
| hex: http/html-1m | 524290 | 15701.5 ± 0.0% | 1470.1 ± 0.2% | 1085.4 ± 0.5% | 501.0 ± 0.3% | 991.8 ± 0.6% | 736.1 ± 0.4% | 10.681 | 14.467 | 31.342 | 15.832 | 21.329 |
| hex: http/json-1kx1024 | 2099200 | 14134.1 ± 0.3% | 1464.3 ± 0.4% | 1066.6 ± 0.1% | 608.0 ± 0.3% | 986.6 ± 0.3% | 693.0 ± 0.1% | 9.652 | 13.251 | 23.247 | 14.326 | 20.395 |
| hex: http/json-16kx64 | 2097280 | 15314.8 ± 0.7% | 1443.9 ± 0.4% | 1074.9 ± 0.2% | 614.7 ± 0.4% | 997.4 ± 0.3% | 735.2 ± 0.1% | 10.607 | 14.248 | 24.915 | 15.354 | 20.831 |
| hex: http/json-1m | 524290 | 15649.4 ± 0.4% | 1474.1 ± 0.4% | 1091.0 ± 0.4% | 631.7 ± 1.0% | 992.6 ± 0.4% | 736.1 ± 0.8% | 10.617 | 14.344 | 24.773 | 15.766 | 21.261 |
| hex: http/js-1kx1024 | 2099200 | 14165.5 ± 0.5% | 1454.0 ± 0.6% | 1063.1 ± 0.1% | 498.8 ± 0.2% | 982.8 ± 0.2% | 692.5 ± 0.3% | 9.743 | 13.325 | 28.397 | 14.414 | 20.455 |
| hex: http/js-16kx64 | 2097280 | 15335.8 ± 0.5% | 1444.7 ± 0.2% | 1075.5 ± 0.2% | 504.8 ± 0.3% | 996.4 ± 0.3% | 734.6 ± 0.2% | 10.615 | 14.259 | 30.377 | 15.392 | 20.875 |
| hex: http/js-1m | 524290 | 15685.8 ± 0.2% | 1471.7 ± 0.4% | 1085.7 ± 0.4% | 510.8 ± 0.3% | 990.3 ± 0.2% | 734.3 ± 0.5% | 10.658 | 14.448 | 30.710 | 15.839 | 21.361 |
| hex: http/css-1kx1024 | 2099200 | 14140.0 ± 0.6% | 1456.0 ± 0.2% | 1062.5 ± 0.1% | 531.5 ± 0.1% | 983.7 ± 0.1% | 693.2 ± 0.1% | 9.712 | 13.309 | 26.603 | 14.374 | 20.399 |
| hex: http/css-16kx64 | 2097280 | 15290.2 ± 0.7% | 1445.5 ± 0.1% | 1075.0 ± 0.1% | 540.9 ± 0.6% | 1000.3 ± 0.1% | 735.1 ± 0.0% | 10.578 | 14.224 | 28.266 | 15.285 | 20.800 |
| hex: http/css-1m | 524290 | 15712.8 ± 0.1% | 1469.1 ± 0.3% | 1085.4 ± 0.5% | 526.9 ± 0.4% | 991.7 ± 0.5% | 735.5 ± 0.3% | 10.696 | 14.476 | 29.823 | 15.844 | 21.364 |
| hex: shuffled/dickens-1m | 524290 | 15716.6 ± 0.1% | 1469.0 ± 0.2% | 1084.4 ± 0.4% | 502.9 ± 1.6% | 993.9 ± 0.5% | 735.4 ± 0.6% | 10.699 | 14.494 | 31.250 | 15.814 | 21.373 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.916 of yyjson.
