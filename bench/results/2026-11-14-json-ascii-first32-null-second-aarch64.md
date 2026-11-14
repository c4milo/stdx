# bench-json

| Field | Value |
|---|---|
| Commit | 45fb15d |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43616701751 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1130.0 ± 0.5% | 0.523 | 0.962 | 0.994 | 0.995 | 0.456 | 1.001 | 1.003 | 0.381 | 0.829 | 0.897 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 846.9 ± 1.2% | 0.816 | 1.005 | 1.003 | 1.000 | 0.445 | 1.003 | 1.030 | 0.393 | 0.923 | 0.985 | 0.125 |
| string: silesia/dickens | 172528 | 5047.2 ± 0.1% | 0.033 | 0.783 | 1.001 | 1.002 | 0.197 | 1.016 | 1.007 | 0.196 | 1.002 | 1.002 | 0.032 |
| string: silesia/nci | 1075110 | 4290.9 ± 0.4% | 0.039 | 0.803 | 1.006 | 1.006 | 0.277 | 1.008 | 0.997 | 0.280 | 1.006 | 1.005 | 0.038 |
| string: silesia/reymont | 1075159 | 2940.6 ± 1.7% | 0.057 | 0.808 | 0.991 | 0.997 | 0.357 | 1.010 | 1.005 | 0.358 | 1.007 | 1.010 | 0.056 |
| string: silesia/samba | 97582 | 3489.6 ± 0.6% | 0.041 | 0.864 | 1.005 | 1.007 | 0.069 | 0.779 | 1.012 | 0.067 | 1.003 | 1.006 | 0.041 |
| string: silesia/webster | 1098490 | 3648.1 ± 0.5% | 0.045 | 0.845 | 1.003 | 1.005 | 0.204 | 1.019 | 1.012 | 0.204 | 1.006 | 1.006 | 0.044 |
| string: silesia/xml | 1090118 | 4762.4 ± 0.5% | 0.035 | 0.808 | 1.006 | 1.007 | 0.222 | 0.983 | 1.009 | 0.220 | 1.009 | 1.011 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4295.4 ± 0.7% | 0.038 | 0.754 | 1.007 | 1.012 | 0.172 | 1.037 | 1.025 | 0.172 | 1.015 | 1.016 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3445.1 ± 0.8% | 0.046 | 0.750 | 1.008 | 1.013 | 0.176 | 1.007 | 0.975 | 0.176 | 1.017 | 1.018 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5113.5 ± 0.6% | 0.032 | 0.816 | 1.003 | 1.005 | 0.196 | 1.019 | 1.008 | 0.196 | 1.005 | 1.006 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4092.7 ± 0.6% | 0.040 | 0.829 | 1.007 | 1.006 | 0.199 | 1.017 | 1.001 | 0.199 | 1.010 | 1.010 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19144.9 ± 1.4% | 0.077 | 1.010 | 1.007 | 1.009 | 0.478 | 1.010 | 1.009 | 0.479 | 0.623 | 0.623 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6651.3 ± 9.9% | 0.026 | 0.807 | 1.009 | 1.013 | 0.434 | 1.034 | 1.046 | 0.434 | 1.038 | 1.042 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3373.9 ± 0.7% | 0.048 | 0.846 | 1.003 | 1.004 | 0.198 | 1.017 | 1.008 | 0.198 | 1.006 | 1.005 | 0.047 |
| string: http/html-1m | 1058582 | 6058.1 ± 3.6% | 0.028 | 0.783 | 1.003 | 1.039 | 0.388 | 1.040 | 1.051 | 0.388 | 1.028 | 1.037 | 0.028 |
| string: http/json-1m | 1190272 | 2544.6 ± 0.4% | 0.055 | 0.950 | 1.005 | 1.005 | 0.109 | 1.006 | 0.471 | 0.110 | 1.003 | 1.004 | 0.055 |
| string: http/js-1m | 1144362 | 2281.7 ± 0.6% | 0.066 | 0.890 | 0.998 | 0.999 | 0.175 | 1.054 | 1.045 | 0.174 | 1.001 | 0.999 | 0.065 |
| string: http/css-1m | 1097820 | 2633.8 ± 0.5% | 0.061 | 0.778 | 1.007 | 1.011 | 0.238 | 1.007 | 1.015 | 0.239 | 1.009 | 1.011 | 0.059 |
| string: dickens as Cyrillic and CJK | 1883069 | 3060.3 ± 0.2% | 0.044 | 0.125 | 1.002 | 1.005 | 0.337 | 1.003 | 1.010 | 0.338 | 1.005 | 1.004 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1324.1 ± 1.4% | 0.085 | 1.004 | 1.003 | 1.004 | 0.078 | 0.638 | 1.005 | 0.075 | 1.003 | 1.004 | 0.085 |
| hex: silesia/dickens | 524290 | 18706.3 ± 1.5% | 0.079 | 0.990 | 0.979 | 0.972 | 0.518 | 0.986 | 0.975 | 0.518 | 0.638 | 0.641 | 0.009 |
| hex: silesia/mozilla | 524290 | 18684.3 ± 0.3% | 0.080 | 1.011 | 0.998 | 0.991 | 0.518 | 1.002 | 0.997 | 0.520 | 0.643 | 0.643 | 0.009 |
| hex: silesia/mr | 524290 | 18312.4 ± 1.9% | 0.081 | 0.998 | 0.994 | 0.991 | 0.525 | 0.996 | 0.993 | 0.524 | 0.655 | 0.654 | 0.009 |
| hex: silesia/nci | 524290 | 18865.6 ± 1.3% | 0.079 | 0.997 | 0.997 | 0.992 | 0.498 | 0.989 | 0.988 | 0.500 | 0.635 | 0.635 | 0.009 |
| hex: silesia/ooffice | 524290 | 18636.7 ± 0.8% | 0.080 | 1.013 | 1.001 | 0.998 | 0.515 | 1.006 | 1.006 | 0.512 | 0.643 | 0.643 | 0.009 |
| hex: silesia/osdb | 524290 | 18355.2 ± 1.2% | 0.081 | 1.001 | 1.002 | 1.001 | 0.527 | 1.005 | 1.003 | 0.529 | 0.652 | 0.652 | 0.009 |
| hex: silesia/reymont | 524290 | 18637.0 ± 0.7% | 0.079 | 1.011 | 1.008 | 0.996 | 0.506 | 0.993 | 0.992 | 0.506 | 0.643 | 0.643 | 0.009 |
| hex: silesia/samba | 524290 | 18101.7 ± 0.8% | 0.082 | 0.999 | 1.000 | 1.000 | 0.526 | 1.002 | 0.996 | 0.526 | 0.660 | 0.662 | 0.010 |
| hex: silesia/sao | 524290 | 18580.6 ± 1.2% | 0.080 | 1.009 | 1.011 | 1.001 | 0.507 | 1.004 | 1.001 | 0.507 | 0.643 | 0.643 | 0.009 |
| hex: silesia/webster | 524290 | 18685.8 ± 0.8% | 0.079 | 1.008 | 0.991 | 0.989 | 0.503 | 1.000 | 1.006 | 0.506 | 0.642 | 0.642 | 0.009 |
| hex: silesia/x-ray | 524290 | 18473.8 ± 0.8% | 0.080 | 1.012 | 1.000 | 1.001 | 0.511 | 1.001 | 0.999 | 0.510 | 0.649 | 0.648 | 0.009 |
| hex: silesia/xml | 524290 | 18541.9 ± 0.6% | 0.080 | 1.005 | 0.994 | 0.993 | 0.518 | 0.998 | 0.997 | 0.518 | 0.644 | 0.644 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19562.5 ± 0.2% | 0.077 | 1.002 | 1.002 | 1.001 | 0.513 | 1.002 | 1.001 | 0.514 | 0.614 | 0.614 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19490.1 ± 0.8% | 0.077 | 1.004 | 1.003 | 1.004 | 0.505 | 1.003 | 1.004 | 0.508 | 0.616 | 0.616 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19263.1 ± 0.5% | 0.081 | 1.002 | 1.002 | 1.001 | 0.543 | 1.001 | 1.002 | 0.544 | 0.619 | 0.619 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18900.4 ± 1.1% | 0.081 | 1.000 | 1.004 | 1.004 | 0.535 | 1.003 | 1.004 | 0.540 | 0.623 | 0.623 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17450.0 ± 2.0% | 0.089 | 1.009 | 1.009 | 1.010 | 0.529 | 1.008 | 1.009 | 0.546 | 0.645 | 0.649 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18442.1 ± 0.7% | 0.080 | 1.000 | 0.998 | 1.000 | 0.516 | 1.006 | 1.000 | 0.516 | 0.651 | 0.651 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18554.6 ± 2.5% | 0.080 | 1.013 | 0.998 | 0.988 | 0.517 | 0.990 | 0.994 | 0.514 | 0.647 | 0.647 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18435.3 ± 2.1% | 0.081 | 1.005 | 1.000 | 0.998 | 0.523 | 1.002 | 1.000 | 0.523 | 0.651 | 0.651 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 18008.4 ± 1.1% | 0.082 | 1.010 | 1.007 | 1.009 | 0.535 | 1.012 | 1.006 | 0.533 | 0.665 | 0.665 | 0.010 |
| hex: canterbury/sum | 76482 | 19285.0 ± 0.1% | 0.078 | 1.002 | 1.003 | 1.003 | 0.518 | 1.002 | 1.003 | 0.519 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17833.1 ± 0.4% | 0.087 | 1.002 | 1.002 | 1.003 | 0.524 | 1.001 | 1.002 | 0.539 | 0.637 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18616.3 ± 1.4% | 0.079 | 1.007 | 1.003 | 1.002 | 0.502 | 1.002 | 1.000 | 0.502 | 0.642 | 0.641 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18495.1 ± 4.8% | 0.080 | 1.017 | 1.001 | 0.997 | 0.524 | 1.018 | 1.010 | 0.523 | 0.649 | 0.649 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18212.8 ± 1.8% | 0.082 | 1.004 | 1.003 | 1.003 | 0.536 | 1.003 | 0.999 | 0.533 | 0.658 | 0.660 | 0.009 |
| hex: http/html-1kx1024 | 2099200 | 9444.8 ± 17.8% | 0.151 | 1.245 | 1.242 | 1.238 | 0.689 | 1.227 | 0.971 | 0.745 | 0.919 | 0.924 | 0.018 |
| hex: http/html-16kx64 | 2097280 | 18024.8 ± 1.8% | 0.083 | 1.013 | 1.012 | 1.015 | 0.566 | 1.007 | 0.980 | 0.570 | 0.651 | 0.652 | 0.010 |
| hex: http/html-1m | 524290 | 18362.6 ± 2.7% | 0.081 | 1.006 | 0.998 | 0.992 | 0.522 | 0.994 | 0.995 | 0.523 | 0.653 | 0.654 | 0.009 |
| hex: http/json-1kx1024 | 2099200 | 9031.3 ± 19.3% | 0.158 | 1.308 | 1.293 | 1.296 | 0.724 | 1.300 | 0.983 | 0.782 | 0.961 | 0.967 | 0.019 |
| hex: http/json-16kx64 | 2097280 | 17827.0 ± 10.0% | 0.084 | 1.027 | 1.023 | 1.022 | 0.573 | 1.025 | 0.997 | 0.577 | 0.658 | 0.659 | 0.010 |
| hex: http/json-1m | 524290 | 18393.8 ± 1.7% | 0.081 | 1.008 | 0.993 | 0.994 | 0.520 | 0.998 | 0.993 | 0.521 | 0.652 | 0.652 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 9082.2 ± 13.0% | 0.156 | 1.279 | 1.268 | 1.270 | 0.715 | 1.268 | 0.995 | 0.771 | 0.954 | 0.996 | 0.019 |
| hex: http/js-16kx64 | 2097280 | 17987.2 ± 0.8% | 0.083 | 1.018 | 1.016 | 1.015 | 0.569 | 1.016 | 0.986 | 0.572 | 0.652 | 0.653 | 0.010 |
| hex: http/js-1m | 524290 | 18490.6 ± 2.0% | 0.080 | 1.015 | 1.012 | 1.004 | 0.511 | 1.003 | 1.002 | 0.512 | 0.645 | 0.647 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9248.4 ± 17.6% | 0.154 | 1.271 | 1.274 | 1.276 | 0.704 | 1.278 | 0.967 | 0.759 | 0.937 | 0.941 | 0.019 |
| hex: http/css-16kx64 | 2097280 | 18033.8 ± 1.2% | 0.083 | 1.015 | 1.012 | 1.010 | 0.568 | 1.013 | 0.987 | 0.570 | 0.651 | 0.652 | 0.010 |
| hex: http/css-1m | 524290 | 18743.1 ± 1.2% | 0.079 | 1.006 | 0.999 | 0.997 | 0.513 | 0.997 | 0.999 | 0.515 | 0.640 | 0.640 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18326.2 ± 0.5% | 0.081 | 1.002 | 0.998 | 0.997 | 0.522 | 1.001 | 0.996 | 0.523 | 0.655 | 0.655 | 0.009 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1462.4 ± 0.8% | 0.448 | 1.002 | 0.971 | 1.006 | 1.009 | 0.270 | 1.001 | 0.552 | 0.917 | 0.089 | 1.030 |
| qlog records, JSON text sequence | 1467503 | 1247.8 ± 2.7% | 0.697 | 0.983 | 1.015 | 1.018 | 1.017 | 0.269 | 1.009 | 0.508 | 0.835 | 0.107 | 1.025 |
| string: silesia/dickens | 172528 | 6895.3 ± 0.1% | 0.025 | 1.001 | 1.001 | 1.001 | 1.002 | 0.165 | 0.716 | 1.003 | 1.003 | 0.025 | 1.033 |
| string: silesia/nci | 1075110 | 7294.2 ± 0.4% | 0.024 | 1.003 | 1.002 | 1.002 | 1.003 | 0.210 | 0.566 | 1.001 | 1.002 | 0.023 | 0.978 |
| string: silesia/reymont | 1075159 | 3330.1 ± 1.5% | 0.052 | 1.005 | 1.007 | 1.006 | 1.004 | 0.388 | 0.870 | 1.002 | 0.995 | 0.052 | 1.051 |
| string: silesia/samba | 97582 | 4188.6 ± 1.2% | 0.053 | 1.003 | 1.001 | 1.005 | 1.005 | 0.125 | 0.947 | 1.006 | 1.005 | 0.053 | 1.090 |
| string: silesia/webster | 1098490 | 4049.6 ± 0.3% | 0.043 | 1.009 | 1.007 | 1.005 | 1.007 | 0.211 | 0.888 | 1.000 | 1.006 | 0.043 | 1.012 |
| string: silesia/xml | 1090118 | 6115.6 ± 0.5% | 0.029 | 1.002 | 0.996 | 1.001 | 1.002 | 0.252 | 0.776 | 1.001 | 1.003 | 0.029 | 1.023 |
| string: canterbury/alice29.txt | 159425 | 6419.1 ± 0.8% | 0.027 | 1.008 | 1.009 | 1.009 | 1.011 | 0.131 | 0.654 | 1.005 | 1.009 | 0.027 | 1.059 |
| string: canterbury/asyoulik.txt | 132198 | 5546.6 ± 1.6% | 0.031 | 1.033 | 1.039 | 1.041 | 1.043 | 0.129 | 0.602 | 1.012 | 1.023 | 0.030 | 1.061 |
| string: canterbury/lcet10.txt | 441884 | 6240.7 ± 0.4% | 0.028 | 1.006 | 1.008 | 1.008 | 1.008 | 0.183 | 0.799 | 1.002 | 1.005 | 0.028 | 1.002 |
| string: canterbury/plrabn12.txt | 503330 | 5712.1 ± 0.4% | 0.031 | 1.002 | 1.002 | 1.003 | 1.003 | 0.167 | 0.698 | 1.003 | 1.004 | 0.030 | 1.006 |
| string: canterbury-large/E.coli | 1048578 | 19162.3 ± 0.7% | 0.078 | 1.005 | 1.007 | 1.005 | 1.004 | 0.478 | 1.003 | 1.005 | 1.006 | 0.009 | 1.006 |
| string: canterbury-large/bible.txt | 1055886 | 6782.2 ± 0.4% | 0.026 | 1.002 | 1.002 | 1.002 | 1.002 | 0.495 | 0.973 | 1.000 | 1.002 | 0.026 | 1.000 |
| string: canterbury-large/world192.txt | 1103121 | 4022.0 ± 0.4% | 0.043 | 1.018 | 1.016 | 1.018 | 1.017 | 0.192 | 0.831 | 1.001 | 1.009 | 0.043 | 1.004 |
| string: http/html-1m | 1058582 | 6748.3 ± 1.5% | 0.026 | 1.004 | 0.925 | 1.003 | 1.006 | 0.402 | 0.884 | 1.001 | 1.003 | 0.026 | 1.009 |
| string: http/json-1m | 1190272 | 3158.9 ± 0.2% | 0.051 | 1.001 | 0.967 | 1.002 | 1.002 | 0.132 | 0.371 | 0.999 | 1.002 | 0.050 | 1.042 |
| string: http/js-1m | 1144362 | 2750.1 ± 0.3% | 0.061 | 1.003 | 1.008 | 1.003 | 1.009 | 0.164 | 0.841 | 1.001 | 1.005 | 0.061 | 1.021 |
| string: http/css-1m | 1097820 | 3956.7 ± 0.9% | 0.043 | 1.013 | 1.013 | 1.015 | 1.015 | 0.207 | 0.650 | 1.007 | 1.012 | 0.043 | 1.017 |
| string: dickens as Cyrillic and CJK | 1883069 | 3060.6 ± 0.2% | 0.048 | 1.002 | 0.124 | 1.002 | 1.000 | 0.320 | 1.004 | 1.001 | 1.003 | 0.048 | 1.002 |
| hex: silesia/dickens | 524290 | 15657.4 ± 0.2% | 1.001 | 0.177 | 1.001 | 1.001 | 1.001 | 0.997 | 1.001 | 1.001 | 1.001 | 0.177 | 1.002 |
| hex: silesia/mozilla | 524290 | 15641.5 ± 0.1% | 1.001 | 0.178 | 0.999 | 1.000 | 1.000 | 0.998 | 0.999 | 0.997 | 0.994 | 0.178 | 0.997 |
| hex: silesia/mr | 524290 | 15619.2 ± 0.2% | 1.001 | 0.179 | 0.999 | 1.001 | 1.000 | 0.999 | 0.999 | 1.000 | 1.000 | 0.178 | 0.999 |
| hex: silesia/nci | 524290 | 15647.8 ± 0.2% | 1.001 | 0.178 | 0.997 | 0.998 | 0.999 | 0.998 | 0.998 | 0.999 | 0.997 | 0.177 | 0.998 |
| hex: silesia/ooffice | 524290 | 15634.5 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 1.000 | 0.178 | 1.000 |
| hex: silesia/osdb | 524290 | 15570.9 ± 0.2% | 1.003 | 0.178 | 1.003 | 1.001 | 1.002 | 1.003 | 1.003 | 1.003 | 1.004 | 0.178 | 1.003 |
| hex: silesia/reymont | 524290 | 15642.9 ± 0.4% | 1.000 | 0.177 | 1.000 | 1.002 | 1.000 | 1.001 | 1.001 | 1.001 | 1.000 | 0.177 | 1.002 |
| hex: silesia/samba | 524290 | 15676.4 ± 0.0% | 1.001 | 0.177 | 1.001 | 1.001 | 1.000 | 0.999 | 1.001 | 1.000 | 1.001 | 0.177 | 1.000 |
| hex: silesia/sao | 524290 | 15649.8 ± 0.2% | 1.000 | 0.177 | 0.999 | 1.000 | 1.000 | 1.001 | 1.002 | 1.001 | 1.002 | 0.177 | 1.002 |
| hex: silesia/webster | 524290 | 15676.8 ± 0.2% | 1.001 | 0.177 | 1.001 | 1.001 | 1.001 | 0.999 | 1.000 | 0.999 | 1.002 | 0.177 | 1.001 |
| hex: silesia/x-ray | 524290 | 15617.4 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.001 | 1.000 | 0.999 | 1.001 | 1.002 | 1.001 | 0.178 | 1.002 |
| hex: silesia/xml | 524290 | 15634.3 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 1.001 | 1.000 | 1.000 | 1.000 | 0.178 | 1.000 |
| hex: canterbury/alice29.txt | 304180 | 15688.2 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.000 |
| hex: canterbury/asyoulik.txt | 250360 | 15701.4 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15613.9 ± 0.2% | 1.001 | 0.179 | 1.001 | 1.001 | 1.001 | 0.998 | 1.001 | 1.001 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15438.2 ± 0.0% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.994 | 1.000 | 1.002 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14932.4 ± 0.1% | 1.003 | 0.186 | 1.000 | 1.000 | 1.001 | 0.983 | 1.001 | 1.004 | 1.015 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15595.5 ± 0.3% | 1.001 | 0.178 | 1.000 | 0.999 | 1.000 | 1.000 | 0.999 | 0.999 | 0.999 | 0.178 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 15627.1 ± 0.8% | 1.001 | 0.178 | 1.001 | 1.000 | 1.001 | 0.995 | 0.998 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/plrabn12.txt | 524290 | 15584.2 ± 0.3% | 1.002 | 0.178 | 1.002 | 1.002 | 1.002 | 1.000 | 1.000 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 15599.5 ± 0.3% | 1.002 | 0.179 | 1.002 | 1.000 | 1.001 | 1.000 | 1.001 | 1.002 | 1.001 | 0.178 | 1.000 |
| hex: canterbury/sum | 76482 | 15633.0 ± 0.1% | 1.002 | 0.179 | 1.001 | 1.001 | 1.001 | 0.999 | 1.001 | 1.001 | 1.003 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 14993.9 ± 0.1% | 1.002 | 0.185 | 1.001 | 1.001 | 1.001 | 0.985 | 1.001 | 1.003 | 1.015 | 0.184 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 15631.2 ± 0.3% | 1.000 | 0.178 | 0.990 | 0.990 | 0.990 | 0.992 | 0.992 | 0.992 | 0.991 | 0.178 | 0.992 |
| hex: canterbury-large/bible.txt | 524290 | 15613.8 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.001 | 1.000 | 0.999 | 1.001 | 1.000 | 1.001 | 0.177 | 1.001 |
| hex: canterbury-large/world192.txt | 524290 | 15611.0 ± 0.1% | 1.002 | 0.178 | 1.001 | 1.002 | 1.002 | 1.000 | 1.001 | 1.002 | 1.002 | 0.178 | 1.002 |
| hex: http/html-1kx1024 | 2099200 | 13637.7 ± 0.3% | 1.007 | 0.196 | 1.001 | 1.003 | 1.003 | 0.943 | 1.002 | 1.011 | 1.036 | 0.187 | 1.013 |
| hex: http/html-16kx64 | 2097280 | 15184.7 ± 0.3% | 1.000 | 0.181 | 1.002 | 1.002 | 1.001 | 0.993 | 1.001 | 1.007 | 1.009 | 0.180 | 1.004 |
| hex: http/html-1m | 524290 | 15658.7 ± 0.1% | 1.001 | 0.177 | 1.001 | 1.001 | 1.001 | 0.999 | 1.000 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: http/json-1kx1024 | 2099200 | 13656.0 ± 0.2% | 1.009 | 0.196 | 0.999 | 1.001 | 1.003 | 0.946 | 1.003 | 1.014 | 1.034 | 0.188 | 1.013 |
| hex: http/json-16kx64 | 2097280 | 15162.3 ± 0.6% | 1.002 | 0.182 | 1.002 | 1.001 | 0.999 | 0.996 | 1.006 | 1.009 | 1.009 | 0.181 | 1.005 |
| hex: http/json-1m | 524290 | 15653.6 ± 0.4% | 1.001 | 0.177 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 0.997 | 1.001 | 0.178 | 1.001 |
| hex: http/js-1kx1024 | 2099200 | 13622.0 ± 1.0% | 1.004 | 0.196 | 1.007 | 1.002 | 1.003 | 0.942 | 1.002 | 1.009 | 1.035 | 0.187 | 1.011 |
| hex: http/js-16kx64 | 2097280 | 15219.8 ± 0.7% | 0.998 | 0.180 | 0.998 | 0.999 | 1.000 | 0.995 | 1.001 | 1.004 | 1.005 | 0.180 | 1.003 |
| hex: http/js-1m | 524290 | 15597.0 ± 0.3% | 1.001 | 0.177 | 1.001 | 1.001 | 1.000 | 0.999 | 1.001 | 1.000 | 1.000 | 0.178 | 1.000 |
| hex: http/css-1kx1024 | 2099200 | 13632.0 ± 0.4% | 1.003 | 0.195 | 0.999 | 1.000 | 0.998 | 0.936 | 0.998 | 1.006 | 1.036 | 0.187 | 1.009 |
| hex: http/css-16kx64 | 2097280 | 15126.8 ± 0.2% | 1.005 | 0.182 | 1.007 | 1.003 | 1.001 | 0.995 | 0.999 | 1.009 | 1.013 | 0.181 | 1.003 |
| hex: http/css-1m | 524290 | 15611.9 ± 0.7% | 1.002 | 0.177 | 1.002 | 1.003 | 1.002 | 1.003 | 1.003 | 1.002 | 1.001 | 0.177 | 1.002 |
| hex: shuffled/dickens-1m | 524290 | 15653.1 ± 0.2% | 1.000 | 0.177 | 1.002 | 1.002 | 1.001 | 1.001 | 1.001 | 1.002 | 1.002 | 0.177 | 1.002 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.051 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.054 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.245 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.242 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.238 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.227 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.308 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.293 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.296 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.300 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.279 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.268 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.270 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.268 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.271 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.274 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.276 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.278 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43330.6 ± 0.1% | 47402.7 ± 0.1% | 0.914 | — | — |
| string: silesia/nci | 1048576 | 34548.2 ± 3.5% | 37039.1 ± 5.0% | 0.933 | — | — |
| string: silesia/reymont | 1048576 | 34077.2 ± 2.2% | 36413.8 ± 2.9% | 0.936 | — | — |
| string: silesia/samba | 65546 | 43550.9 ± 0.1% | 48504.0 ± 0.0% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 34786.8 ± 4.7% | 37519.5 ± 4.7% | 0.927 | — | — |
| string: silesia/xml | 1048576 | 31597.3 ± 4.8% | 32677.8 ± 3.7% | 0.967 | — | — |
| string: canterbury/alice29.txt | 152089 | 35898.2 ± 0.2% | 36531.2 ± 0.2% | 0.983 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43340.1 ± 0.1% | 47628.6 ± 0.1% | 0.910 | — | — |
| string: canterbury/lcet10.txt | 426754 | 34750.9 ± 0.6% | 35427.7 ± 0.8% | 0.981 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 43434.3 ± 0.0% | 47492.1 ± 0.2% | 0.915 | — | — |
| string: canterbury-large/E.coli | 1048576 | 36187.4 ± 2.0% | 39114.0 ± 2.7% | 0.925 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 31332.3 ± 2.7% | 32730.1 ± 1.3% | 0.957 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 31820.1 ± 2.6% | 32911.9 ± 2.6% | 0.967 | — | — |
| string: http/html-1m | 1048576 | 34829.7 ± 3.1% | 37566.2 ± 7.8% | 0.927 | — | — |
| string: http/json-1m | 1048576 | 30002.0 ± 6.8% | 31507.8 ± 3.9% | 0.952 | — | — |
| string: http/js-1m | 1048576 | 35696.6 ± 2.5% | 38472.7 ± 2.9% | 0.928 | — | — |
| string: http/css-1m | 1048576 | 36043.8 ± 2.4% | 38626.5 ± 3.9% | 0.933 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5764.0 ± 0.2% | 5644.9 ± 0.2% | 1.021 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.914 of simdutf.
- string: silesia/nci: stdx runs at 0.933 of simdutf.
- string: silesia/reymont: stdx runs at 0.936 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.927 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.910 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.915 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.925 of simdutf.
- string: http/js-1m: stdx runs at 0.928 of simdutf.
- string: http/css-1m: stdx runs at 0.933 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 36539.2 ± 8.3% | 40462.1 ± 6.3% | 0.903 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 31984.3 ± 3.1% | 33186.0 ± 3.2% | 0.964 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 35890.9 ± 3.6% | 38750.0 ± 3.7% | 0.926 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 36467.2 ± 2.5% | 39495.2 ± 1.3% | 0.923 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 36613.9 ± 1.9% | 40003.1 ± 1.9% | 0.915 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 36118.0 ± 14.2% | 38727.7 ± 10.3% | 0.933 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5762.6 ± 0.2% | 5646.1 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5755.2 ± 0.1% | 5643.1 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5761.9 ± 0.4% | 5642.9 ± 0.2% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5760.2 ± 0.2% | 5646.7 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5764.6 ± 0.2% | 5644.5 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5759.4 ± 0.1% | 5642.2 ± 0.1% | 1.021 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1130.0 ± 0.5% | 924.4 ± 1.1% | 1014.5 ± 0.2% | 300.3 ± 0.8% | 665.7 ± 0.3% | 309.4 ± 2.3% | 1.222 | 1.114 | 3.763 | 1.697 | 3.653 |
| qlog records, JSON text sequence | 1467503 | 846.9 ± 1.2% | 814.6 ± 0.6% | 769.6 ± 47.2% | 240.7 ± 2.2% | 706.8 ± 0.7% | 246.5 ± 2.6% | 1.040 | 1.101 | 3.519 | 1.198 | 3.436 |
| string: silesia/dickens | 172528 | 5047.2 ± 0.1% | 1876.5 ± 0.2% | 2647.9 ± 0.3% | 360.5 ± 0.5% | 2872.1 ± 0.6% | 550.7 ± 2.5% | 2.690 | 1.906 | 14.001 | 1.757 | 9.165 |
| string: silesia/nci | 1075110 | 4290.9 ± 0.4% | 2236.3 ± 0.2% | 2989.7 ± 0.6% | 542.3 ± 1.1% | 2969.8 ± 0.6% | 595.7 ± 4.5% | 1.919 | 1.435 | 7.913 | 1.445 | 7.204 |
| string: silesia/reymont | 1075159 | 2940.6 ± 1.7% | 1809.9 ± 0.9% | 2057.0 ± 0.4% | 374.8 ± 1.1% | 2142.6 ± 0.8% | 536.7 ± 0.9% | 1.625 | 1.430 | 7.846 | 1.372 | 5.479 |
| string: silesia/samba | 97582 | 3489.6 ± 0.6% | 2024.0 ± 0.2% | 2616.3 ± 0.3% | 324.0 ± 0.5% | 1507.1 ± 1.0% | 424.1 ± 1.3% | 1.724 | 1.334 | 10.770 | 2.315 | 8.229 |
| string: silesia/webster | 1098490 | 3648.1 ± 0.5% | 1517.7 ± 0.3% | 2009.8 ± 0.5% | 359.0 ± 0.5% | 2170.0 ± 1.1% | 497.3 ± 3.8% | 2.404 | 1.815 | 10.161 | 1.681 | 7.336 |
| string: silesia/xml | 1090118 | 4762.4 ± 0.5% | 2355.3 ± 0.2% | 2517.4 ± 0.2% | 453.1 ± 1.3% | 2783.0 ± 1.7% | 563.6 ± 1.3% | 2.022 | 1.892 | 10.511 | 1.711 | 8.449 |
| string: canterbury/alice29.txt | 159425 | 4295.4 ± 0.7% | 1598.2 ± 0.3% | 2454.9 ± 0.5% | 343.1 ± 0.7% | 2516.1 ± 0.6% | 502.9 ± 1.3% | 2.688 | 1.750 | 12.521 | 1.707 | 8.541 |
| string: canterbury/asyoulik.txt | 132198 | 3445.1 ± 0.8% | 1458.1 ± 0.2% | 2244.8 ± 0.3% | 334.5 ± 1.7% | 2091.7 ± 0.2% | 462.8 ± 1.3% | 2.363 | 1.535 | 10.300 | 1.647 | 7.443 |
| string: canterbury/lcet10.txt | 441884 | 5113.5 ± 0.6% | 1853.6 ± 0.2% | 2342.1 ± 0.6% | 391.1 ± 0.6% | 2869.7 ± 1.3% | 533.5 ± 2.4% | 2.759 | 2.183 | 13.076 | 1.782 | 9.584 |
| string: canterbury/plrabn12.txt | 503330 | 4092.7 ± 0.6% | 1735.6 ± 0.1% | 2061.0 ± 0.2% | 360.9 ± 0.7% | 2488.5 ± 0.4% | 492.9 ± 1.2% | 2.358 | 1.986 | 11.339 | 1.645 | 8.304 |
| string: canterbury-large/E.coli | 1048578 | 19144.9 ± 1.4% | 3601.0 ± 0.3% | 3247.8 ± 0.4% | 933.5 ± 1.0% | 6000.2 ± 0.4% | 755.8 ± 1.7% | 5.317 | 5.895 | 20.509 | 3.191 | 25.331 |
| string: canterbury-large/bible.txt | 1055886 | 6651.3 ± 9.9% | 2934.4 ± 4.0% | 2823.7 ± 0.3% | 418.9 ± 1.5% | 3739.3 ± 5.9% | 611.0 ± 9.3% | 2.267 | 2.356 | 15.877 | 1.779 | 10.887 |
| string: canterbury-large/world192.txt | 1103121 | 3373.9 ± 0.7% | 1480.8 ± 1.4% | 2005.5 ± 2.6% | 352.3 ± 0.6% | 2124.8 ± 4.5% | 497.9 ± 1.1% | 2.278 | 1.682 | 9.577 | 1.588 | 6.776 |
| string: http/html-1m | 1058582 | 6058.1 ± 3.6% | 2733.4 ± 0.6% | 2687.0 ± 0.6% | 442.1 ± 0.4% | 3463.0 ± 0.6% | 594.3 ± 1.1% | 2.216 | 2.255 | 13.704 | 1.749 | 10.194 |
| string: http/json-1m | 1190272 | 2544.6 ± 0.4% | 876.3 ± 0.2% | 2243.6 ± 0.5% | 390.1 ± 0.6% | 1048.5 ± 4.4% | 439.4 ± 2.0% | 2.904 | 1.134 | 6.523 | 2.427 | 5.790 |
| string: http/js-1m | 1144362 | 2281.7 ± 0.6% | 1027.5 ± 0.4% | 1633.9 ± 0.4% | 321.2 ± 0.8% | 1513.4 ± 0.4% | 415.6 ± 1.2% | 2.221 | 1.396 | 7.104 | 1.508 | 5.491 |
| string: http/css-1m | 1097820 | 2633.8 ± 0.5% | 1676.3 ± 0.4% | 2213.1 ± 0.4% | 406.7 ± 0.9% | 1910.7 ± 0.5% | 484.2 ± 1.0% | 1.571 | 1.190 | 6.477 | 1.378 | 5.440 |
| string: dickens as Cyrillic and CJK | 1883069 | 3060.3 ± 0.2% | 1681.9 ± 0.3% | 889.1 ± 0.3% | 350.8 ± 0.3% | 665.3 ± 0.7% | 155.9 ± 3.2% | 1.819 | 3.442 | 8.725 | 4.600 | 19.627 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1324.1 ± 1.4% | 978.1 ± 0.3% | 1187.6 ± 0.3% | 213.8 ± 0.3% | 470.7 ± 0.8% | 248.9 ± 4.8% | 1.354 | 1.115 | 6.192 | 2.813 | 5.319 |
| hex: silesia/dickens | 524290 | 18706.3 ± 1.5% | 3612.2 ± 1.2% | 3286.1 ± 0.7% | 507.6 ± 0.9% | 6095.8 ± 1.9% | 776.1 ± 4.5% | 5.179 | 5.692 | 36.849 | 3.069 | 24.103 |
| hex: silesia/mozilla | 524290 | 18684.3 ± 0.3% | 3615.2 ± 0.2% | 3292.1 ± 0.3% | 452.3 ± 0.9% | 6093.0 ± 1.9% | 776.6 ± 0.4% | 5.168 | 5.675 | 41.308 | 3.066 | 24.059 |
| hex: silesia/mr | 524290 | 18312.4 ± 1.9% | 3615.7 ± 0.1% | 3280.9 ± 0.2% | 579.8 ± 1.4% | 6050.0 ± 1.1% | 778.3 ± 0.6% | 5.065 | 5.582 | 31.586 | 3.027 | 23.528 |
| hex: silesia/nci | 524290 | 18865.6 ± 1.3% | 3616.1 ± 0.5% | 3293.7 ± 0.2% | 629.2 ± 1.9% | 6065.0 ± 1.6% | 778.6 ± 0.5% | 5.217 | 5.728 | 29.985 | 3.111 | 24.231 |
| hex: silesia/ooffice | 524290 | 18636.7 ± 0.8% | 3610.1 ± 0.3% | 3284.5 ± 0.2% | 405.8 ± 0.7% | 6059.1 ± 1.1% | 778.0 ± 0.2% | 5.162 | 5.674 | 45.922 | 3.076 | 23.955 |
| hex: silesia/osdb | 524290 | 18355.2 ± 1.2% | 3611.2 ± 0.2% | 3290.6 ± 0.2% | 490.0 ± 1.8% | 6033.9 ± 0.9% | 778.5 ± 0.4% | 5.083 | 5.578 | 37.460 | 3.042 | 23.577 |
| hex: silesia/reymont | 524290 | 18637.0 ± 0.7% | 3616.5 ± 0.2% | 3278.7 ± 0.2% | 523.1 ± 2.2% | 6059.9 ± 1.3% | 777.8 ± 0.6% | 5.153 | 5.684 | 35.630 | 3.075 | 23.962 |
| hex: silesia/samba | 524290 | 18101.7 ± 0.8% | 3614.0 ± 0.3% | 3290.6 ± 0.2% | 411.8 ± 1.1% | 6079.2 ± 1.5% | 779.5 ± 0.3% | 5.009 | 5.501 | 43.960 | 2.978 | 23.223 |
| hex: silesia/sao | 524290 | 18580.6 ± 1.2% | 3616.8 ± 0.2% | 3289.2 ± 0.2% | 347.0 ± 1.5% | 6070.3 ± 1.2% | 778.1 ± 0.8% | 5.137 | 5.649 | 53.545 | 3.061 | 23.880 |
| hex: silesia/webster | 524290 | 18685.8 ± 0.8% | 3615.9 ± 0.2% | 3289.4 ± 0.3% | 479.3 ± 2.4% | 6147.3 ± 1.3% | 778.8 ± 0.7% | 5.168 | 5.681 | 38.984 | 3.040 | 23.993 |
| hex: silesia/x-ray | 524290 | 18473.8 ± 0.8% | 3615.0 ± 0.3% | 3282.5 ± 0.3% | 484.8 ± 0.2% | 6059.6 ± 2.7% | 779.6 ± 0.4% | 5.110 | 5.628 | 38.106 | 3.049 | 23.697 |
| hex: silesia/xml | 524290 | 18541.9 ± 0.6% | 3617.2 ± 0.3% | 3293.2 ± 0.3% | 533.8 ± 0.9% | 6061.2 ± 0.3% | 779.7 ± 0.2% | 5.126 | 5.630 | 34.734 | 3.059 | 23.781 |
| hex: canterbury/alice29.txt | 304180 | 19562.5 ± 0.2% | 3638.2 ± 0.0% | 3349.6 ± 0.2% | 525.0 ± 0.1% | 6091.2 ± 0.6% | 780.0 ± 0.6% | 5.377 | 5.840 | 37.259 | 3.212 | 25.081 |
| hex: canterbury/asyoulik.txt | 250360 | 19490.1 ± 0.8% | 3635.5 ± 0.1% | 3363.3 ± 0.6% | 515.6 ± 0.5% | 6171.8 ± 1.4% | 778.7 ± 0.5% | 5.361 | 5.795 | 37.797 | 3.158 | 25.030 |
| hex: canterbury/cp.html | 49208 | 19263.1 ± 0.5% | 3637.7 ± 0.1% | 3277.6 ± 0.1% | 482.3 ± 0.7% | 6272.3 ± 0.3% | 759.5 ± 0.9% | 5.295 | 5.877 | 39.942 | 3.071 | 25.364 |
| hex: canterbury/fields.c | 22302 | 18900.4 ± 1.1% | 3627.4 ± 0.5% | 3389.0 ± 0.0% | 510.5 ± 0.3% | 6259.6 ± 0.4% | 755.7 ± 2.2% | 5.210 | 5.577 | 37.023 | 3.019 | 25.012 |
| hex: canterbury/grammar.lsp | 7444 | 17450.0 ± 2.0% | 3600.6 ± 0.4% | 3354.0 ± 0.7% | 554.7 ± 3.1% | 6162.4 ± 0.4% | 702.4 ± 1.7% | 4.846 | 5.203 | 31.459 | 2.832 | 24.842 |
| hex: canterbury/kennedy.xls | 524290 | 18442.1 ± 0.7% | 3613.3 ± 0.2% | 3283.5 ± 0.3% | 656.9 ± 5.9% | 6123.6 ± 1.0% | 759.3 ± 8.7% | 5.104 | 5.617 | 28.074 | 3.012 | 24.289 |
| hex: canterbury/lcet10.txt | 524290 | 18554.6 ± 2.5% | 3611.1 ± 0.3% | 3287.7 ± 0.1% | 511.5 ± 1.1% | 6104.4 ± 1.2% | 769.9 ± 2.6% | 5.138 | 5.644 | 36.278 | 3.040 | 24.101 |
| hex: canterbury/plrabn12.txt | 524290 | 18435.3 ± 2.1% | 3615.4 ± 0.2% | 3290.2 ± 0.2% | 503.5 ± 0.8% | 6085.2 ± 1.1% | 762.8 ± 2.0% | 5.099 | 5.603 | 36.615 | 3.030 | 24.169 |
| hex: canterbury/ptt5 | 524290 | 18008.4 ± 1.1% | 3613.1 ± 0.3% | 3281.0 ± 0.4% | 556.5 ± 0.3% | 6090.5 ± 1.7% | 773.4 ± 3.7% | 4.984 | 5.489 | 32.362 | 2.957 | 23.284 |
| hex: canterbury/sum | 76482 | 19285.0 ± 0.1% | 3632.8 ± 0.1% | 3358.0 ± 0.4% | 506.6 ± 1.3% | 6171.0 ± 0.6% | 770.6 ± 1.4% | 5.309 | 5.743 | 38.071 | 3.125 | 25.026 |
| hex: canterbury/xargs.1 | 8456 | 17833.1 ± 0.4% | 3602.0 ± 0.1% | 3349.2 ± 0.4% | 486.5 ± 1.8% | 6153.2 ± 0.4% | 734.9 ± 2.1% | 4.951 | 5.325 | 36.655 | 2.898 | 24.265 |
| hex: canterbury-large/E.coli | 524290 | 18616.3 ± 1.4% | 3611.4 ± 0.7% | 3272.4 ± 0.8% | 688.0 ± 0.1% | 6024.2 ± 1.1% | 769.8 ± 6.1% | 5.155 | 5.689 | 27.058 | 3.090 | 24.184 |
| hex: canterbury-large/bible.txt | 524290 | 18495.1 ± 4.8% | 3615.4 ± 0.3% | 3295.4 ± 0.2% | 522.0 ± 2.1% | 6078.2 ± 1.4% | 772.3 ± 2.6% | 5.116 | 5.612 | 35.432 | 3.043 | 23.948 |
| hex: canterbury-large/world192.txt | 524290 | 18212.8 ± 1.8% | 3612.3 ± 0.6% | 3291.1 ± 0.3% | 505.9 ± 2.1% | 6098.3 ± 0.9% | 770.0 ± 1.3% | 5.042 | 5.534 | 36.000 | 2.987 | 23.653 |
| hex: http/html-1kx1024 | 2099200 | 9444.8 ± 17.8% | 3459.0 ± 0.2% | 2815.0 ± 0.7% | 475.4 ± 0.5% | 5022.0 ± 1.1% | 610.0 ± 1.9% | 2.731 | 3.355 | 19.868 | 1.881 | 15.484 |
| hex: http/html-16kx64 | 2097280 | 18024.8 ± 1.8% | 3610.0 ± 0.1% | 3249.3 ± 0.3% | 479.6 ± 1.4% | 6004.4 ± 1.0% | 728.0 ± 3.8% | 4.993 | 5.547 | 37.582 | 3.002 | 24.759 |
| hex: http/html-1m | 524290 | 18362.6 ± 2.7% | 3609.0 ± 0.2% | 3290.0 ± 0.9% | 493.9 ± 1.8% | 6110.8 ± 1.1% | 775.1 ± 3.1% | 5.088 | 5.581 | 37.176 | 3.005 | 23.689 |
| hex: http/json-1kx1024 | 2099200 | 9031.3 ± 19.3% | 3459.7 ± 0.1% | 2816.7 ± 0.9% | 576.1 ± 1.0% | 5034.2 ± 1.0% | 629.7 ± 3.4% | 2.610 | 3.206 | 15.675 | 1.794 | 14.343 |
| hex: http/json-16kx64 | 2097280 | 17827.0 ± 10.0% | 3608.9 ± 0.2% | 3247.6 ± 0.3% | 574.6 ± 1.4% | 6010.2 ± 3.1% | 743.9 ± 6.8% | 4.940 | 5.489 | 31.026 | 2.966 | 23.964 |
| hex: http/json-1m | 524290 | 18393.8 ± 1.7% | 3612.3 ± 0.1% | 3289.3 ± 0.1% | 596.9 ± 2.7% | 6094.5 ± 0.9% | 768.2 ± 2.7% | 5.092 | 5.592 | 30.814 | 3.018 | 23.944 |
| hex: http/js-1kx1024 | 2099200 | 9082.2 ± 13.0% | 3455.4 ± 0.2% | 2812.8 ± 0.5% | 480.9 ± 0.6% | 5021.8 ± 2.2% | 609.7 ± 4.4% | 2.628 | 3.229 | 18.885 | 1.809 | 14.895 |
| hex: http/js-16kx64 | 2097280 | 17987.2 ± 0.8% | 3610.8 ± 0.2% | 3262.5 ± 0.2% | 482.7 ± 1.9% | 6007.4 ± 0.8% | 736.7 ± 2.0% | 4.981 | 5.513 | 37.263 | 2.994 | 24.416 |
| hex: http/js-1m | 524290 | 18490.6 ± 2.0% | 3617.8 ± 0.3% | 3286.5 ± 0.2% | 505.6 ± 1.1% | 6047.7 ± 0.2% | 778.6 ± 3.4% | 5.111 | 5.626 | 36.572 | 3.057 | 23.750 |
| hex: http/css-1kx1024 | 2099200 | 9248.4 ± 17.6% | 3461.8 ± 0.1% | 2824.6 ± 0.6% | 488.8 ± 0.4% | 5050.1 ± 1.3% | 620.8 ± 5.1% | 2.672 | 3.274 | 18.919 | 1.831 | 14.899 |
| hex: http/css-16kx64 | 2097280 | 18033.8 ± 1.2% | 3609.6 ± 0.3% | 3246.4 ± 0.2% | 496.2 ± 0.8% | 6013.8 ± 0.9% | 745.7 ± 3.8% | 4.996 | 5.555 | 36.343 | 2.999 | 24.185 |
| hex: http/css-1m | 524290 | 18743.1 ± 1.2% | 3616.2 ± 0.8% | 3288.3 ± 1.5% | 498.5 ± 2.1% | 6110.2 ± 0.7% | 767.6 ± 2.6% | 5.183 | 5.700 | 37.603 | 3.068 | 24.418 |
| hex: shuffled/dickens-1m | 524290 | 18326.2 ± 0.5% | 3611.8 ± 0.2% | 3286.5 ± 0.3% | 511.7 ± 0.5% | 6150.7 ± 1.1% | 777.4 ± 1.5% | 5.074 | 5.576 | 35.816 | 2.980 | 23.573 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1462.4 ± 0.8% | 1242.0 ± 0.1% | 1029.8 ± 0.5% | 407.6 ± 0.5% | 446.6 ± 0.3% | 414.2 ± 0.2% | 1.178 | 1.420 | 3.588 | 3.274 | 3.531 |
| qlog records, JSON text sequence | 1467503 | 1247.8 ± 2.7% | 1050.1 ± 0.5% | 773.8 ± 2.3% | 376.7 ± 1.4% | 476.2 ± 1.6% | 277.2 ± 0.7% | 1.188 | 1.613 | 3.312 | 2.621 | 4.501 |
| string: silesia/dickens | 172528 | 6895.3 ± 0.1% | 2810.6 ± 0.2% | 2927.3 ± 0.5% | 428.7 ± 0.4% | 1594.2 ± 0.4% | 1005.9 ± 0.2% | 2.453 | 2.355 | 16.083 | 4.325 | 6.855 |
| string: silesia/nci | 1075110 | 7294.2 ± 0.4% | 3403.8 ± 0.3% | 3090.4 ± 0.6% | 813.7 ± 1.3% | 1861.3 ± 0.3% | 1105.6 ± 0.3% | 2.143 | 2.360 | 8.964 | 3.919 | 6.598 |
| string: silesia/reymont | 1075159 | 3330.1 ± 1.5% | 1971.1 ± 1.4% | 2058.4 ± 0.4% | 449.3 ± 0.5% | 1495.4 ± 1.6% | 949.7 ± 0.2% | 1.689 | 1.618 | 7.412 | 2.227 | 3.506 |
| string: silesia/samba | 97582 | 4188.6 ± 1.2% | 2110.0 ± 1.1% | 3440.9 ± 0.6% | 353.8 ± 0.9% | 1485.5 ± 0.2% | 1054.4 ± 0.3% | 1.985 | 1.217 | 11.839 | 2.820 | 3.972 |
| string: silesia/webster | 1098490 | 4049.6 ± 0.3% | 1867.2 ± 0.4% | 2051.7 ± 0.2% | 440.5 ± 0.8% | 1398.5 ± 0.2% | 642.9 ± 0.9% | 2.169 | 1.974 | 9.193 | 2.896 | 6.299 |
| string: silesia/xml | 1090118 | 6115.6 ± 0.5% | 2848.8 ± 0.2% | 2645.8 ± 0.4% | 607.3 ± 0.5% | 1755.6 ± 0.1% | 919.3 ± 0.3% | 2.147 | 2.311 | 10.070 | 3.484 | 6.652 |
| string: canterbury/alice29.txt | 159425 | 6419.1 ± 0.8% | 2198.5 ± 0.6% | 2759.9 ± 0.9% | 404.9 ± 1.0% | 1471.5 ± 0.1% | 956.5 ± 0.3% | 2.920 | 2.326 | 15.854 | 4.362 | 6.711 |
| string: canterbury/asyoulik.txt | 132198 | 5546.6 ± 1.6% | 1708.8 ± 0.4% | 2373.5 ± 0.7% | 401.7 ± 1.0% | 1331.7 ± 1.3% | 883.8 ± 0.1% | 3.246 | 2.337 | 13.810 | 4.165 | 6.276 |
| string: canterbury/lcet10.txt | 441884 | 6240.7 ± 0.4% | 2566.2 ± 0.5% | 2499.3 ± 2.2% | 467.8 ± 0.9% | 1554.0 ± 0.2% | 984.3 ± 0.3% | 2.432 | 2.497 | 13.339 | 4.016 | 6.340 |
| string: canterbury/plrabn12.txt | 503330 | 5712.1 ± 0.4% | 2054.4 ± 0.2% | 2067.4 ± 0.9% | 424.6 ± 0.9% | 1390.7 ± 0.1% | 929.5 ± 0.2% | 2.780 | 2.763 | 13.454 | 4.107 | 6.146 |
| string: canterbury-large/E.coli | 1048578 | 19162.3 ± 0.7% | 9670.1 ± 2.7% | 3786.8 ± 0.2% | 1475.4 ± 1.2% | 2364.3 ± 0.2% | 1189.1 ± 0.3% | 1.982 | 5.060 | 12.988 | 8.105 | 16.115 |
| string: canterbury-large/bible.txt | 1055886 | 6782.2 ± 0.4% | 4123.5 ± 2.3% | 3046.6 ± 3.4% | 503.5 ± 1.6% | 1980.6 ± 2.2% | 1117.7 ± 2.5% | 1.645 | 2.226 | 13.469 | 3.424 | 6.068 |
| string: canterbury-large/world192.txt | 1103121 | 4022.0 ± 0.4% | 1651.4 ± 0.8% | 1998.8 ± 1.2% | 449.8 ± 0.6% | 1369.7 ± 0.1% | 906.4 ± 0.4% | 2.436 | 2.012 | 8.942 | 2.936 | 4.437 |
| string: http/html-1m | 1058582 | 6748.3 ± 1.5% | 3940.3 ± 0.2% | 3040.1 ± 0.1% | 502.4 ± 1.3% | 1931.5 ± 0.4% | 805.1 ± 0.2% | 1.713 | 2.220 | 13.433 | 3.494 | 8.382 |
| string: http/json-1m | 1190272 | 3158.9 ± 0.2% | 1353.0 ± 0.4% | 1554.1 ± 0.3% | 443.9 ± 0.6% | 1069.6 ± 0.3% | 764.2 ± 0.3% | 2.335 | 2.033 | 7.117 | 2.953 | 4.134 |
| string: http/js-1m | 1144362 | 2750.1 ± 0.3% | 1174.7 ± 0.3% | 1620.0 ± 0.6% | 368.6 ± 0.3% | 1107.2 ± 0.5% | 755.3 ± 0.3% | 2.341 | 1.698 | 7.461 | 2.484 | 3.641 |
| string: http/css-1m | 1097820 | 3956.7 ± 0.9% | 1488.4 ± 0.5% | 2150.5 ± 0.7% | 492.2 ± 0.7% | 1378.0 ± 0.7% | 893.0 ± 0.9% | 2.658 | 1.840 | 8.038 | 2.871 | 4.431 |
| string: dickens as Cyrillic and CJK | 1883069 | 3060.6 ± 0.2% | 2331.5 ± 0.8% | 521.2 ± 0.3% | 307.5 ± 0.9% | 563.8 ± 0.3% | 334.4 ± 0.2% | 1.313 | 5.872 | 9.955 | 5.429 | 9.152 |
| hex: silesia/dickens | 524290 | 15657.4 ± 0.2% | 1464.3 ± 0.2% | 1081.9 ± 0.3% | 500.1 ± 0.9% | 987.5 ± 0.2% | 731.6 ± 0.3% | 10.693 | 14.472 | 31.309 | 15.856 | 21.402 |
| hex: silesia/mozilla | 524290 | 15641.5 ± 0.1% | 1472.7 ± 0.3% | 1089.3 ± 0.1% | 440.1 ± 0.4% | 990.9 ± 0.2% | 732.4 ± 0.2% | 10.621 | 14.359 | 35.544 | 15.785 | 21.356 |
| hex: silesia/mr | 524290 | 15619.2 ± 0.2% | 1480.0 ± 0.2% | 1092.6 ± 0.5% | 555.3 ± 0.9% | 994.7 ± 0.4% | 733.5 ± 0.2% | 10.553 | 14.296 | 28.125 | 15.702 | 21.295 |
| hex: silesia/nci | 524290 | 15647.8 ± 0.2% | 1472.0 ± 0.5% | 1088.7 ± 0.3% | 636.2 ± 4.6% | 988.6 ± 0.6% | 732.2 ± 0.4% | 10.630 | 14.373 | 24.597 | 15.829 | 21.370 |
| hex: silesia/ooffice | 524290 | 15634.5 ± 0.1% | 1464.2 ± 0.1% | 1083.0 ± 0.4% | 388.7 ± 0.2% | 989.2 ± 0.5% | 731.9 ± 0.4% | 10.678 | 14.436 | 40.220 | 15.806 | 21.363 |
| hex: silesia/osdb | 524290 | 15570.9 ± 0.2% | 1470.3 ± 0.1% | 1085.6 ± 0.4% | 474.8 ± 1.4% | 991.6 ± 0.4% | 732.8 ± 0.2% | 10.591 | 14.343 | 32.793 | 15.703 | 21.249 |
| hex: silesia/reymont | 524290 | 15642.9 ± 0.4% | 1460.0 ± 0.3% | 1083.9 ± 0.5% | 512.7 ± 0.8% | 986.9 ± 0.4% | 731.9 ± 0.6% | 10.714 | 14.432 | 30.509 | 15.850 | 21.372 |
| hex: silesia/samba | 524290 | 15676.4 ± 0.0% | 1466.3 ± 0.1% | 1084.5 ± 0.2% | 402.3 ± 0.3% | 989.6 ± 0.2% | 731.8 ± 0.7% | 10.691 | 14.454 | 38.962 | 15.840 | 21.421 |
| hex: silesia/sao | 524290 | 15649.8 ± 0.2% | 1459.9 ± 0.8% | 1081.8 ± 0.5% | 332.6 ± 0.5% | 988.8 ± 0.4% | 732.2 ± 0.4% | 10.720 | 14.467 | 47.056 | 15.827 | 21.375 |
| hex: silesia/webster | 524290 | 15676.8 ± 0.2% | 1465.5 ± 0.4% | 1084.4 ± 0.4% | 475.1 ± 0.5% | 986.9 ± 0.7% | 731.9 ± 0.3% | 10.697 | 14.457 | 33.000 | 15.885 | 21.420 |
| hex: silesia/x-ray | 524290 | 15617.4 ± 0.1% | 1476.8 ± 0.5% | 1090.1 ± 0.1% | 444.5 ± 1.7% | 995.1 ± 0.3% | 732.3 ± 0.3% | 10.575 | 14.326 | 35.139 | 15.694 | 21.325 |
| hex: silesia/xml | 524290 | 15634.3 ± 0.1% | 1467.1 ± 0.3% | 1085.3 ± 0.3% | 616.4 ± 0.8% | 990.5 ± 0.3% | 732.2 ± 0.3% | 10.657 | 14.405 | 25.364 | 15.785 | 21.353 |
| hex: canterbury/alice29.txt | 304180 | 15688.2 ± 0.1% | 1475.0 ± 0.2% | 1089.9 ± 0.3% | 503.8 ± 1.1% | 995.7 ± 0.4% | 733.8 ± 0.2% | 10.636 | 14.394 | 31.140 | 15.756 | 21.379 |
| hex: canterbury/asyoulik.txt | 250360 | 15701.4 ± 0.1% | 1476.8 ± 0.7% | 1094.8 ± 0.2% | 500.1 ± 1.3% | 994.7 ± 0.3% | 737.8 ± 0.2% | 10.632 | 14.342 | 31.395 | 15.786 | 21.281 |
| hex: canterbury/cp.html | 49208 | 15613.9 ± 0.2% | 1479.6 ± 1.0% | 1099.0 ± 0.2% | 530.9 ± 2.8% | 1004.8 ± 0.6% | 742.0 ± 0.2% | 10.553 | 14.207 | 29.411 | 15.540 | 21.042 |
| hex: canterbury/fields.c | 22302 | 15438.2 ± 0.0% | 1412.7 ± 0.4% | 1067.2 ± 0.3% | 619.2 ± 9.2% | 986.4 ± 0.2% | 736.5 ± 0.5% | 10.928 | 14.466 | 24.933 | 15.651 | 20.961 |
| hex: canterbury/grammar.lsp | 7444 | 14932.4 ± 0.1% | 1507.7 ± 0.2% | 1092.5 ± 0.3% | 667.6 ± 3.2% | 998.9 ± 0.1% | 725.2 ± 0.2% | 9.904 | 13.668 | 22.366 | 14.949 | 20.591 |
| hex: canterbury/kennedy.xls | 524290 | 15595.5 ± 0.3% | 1472.7 ± 0.3% | 1087.9 ± 0.4% | 653.6 ± 2.0% | 991.4 ± 0.2% | 731.0 ± 0.3% | 10.590 | 14.336 | 23.861 | 15.731 | 21.334 |
| hex: canterbury/lcet10.txt | 524290 | 15627.1 ± 0.8% | 1461.2 ± 0.3% | 1082.9 ± 0.2% | 502.3 ± 1.0% | 987.8 ± 0.2% | 731.4 ± 0.7% | 10.695 | 14.431 | 31.110 | 15.821 | 21.367 |
| hex: canterbury/plrabn12.txt | 524290 | 15584.2 ± 0.3% | 1461.6 ± 0.1% | 1083.0 ± 0.1% | 492.0 ± 0.3% | 988.4 ± 0.3% | 732.5 ± 0.3% | 10.663 | 14.390 | 31.678 | 15.767 | 21.274 |
| hex: canterbury/ptt5 | 524290 | 15599.5 ± 0.3% | 1479.2 ± 0.2% | 1090.9 ± 0.2% | 557.7 ± 0.7% | 991.8 ± 0.2% | 732.4 ± 0.3% | 10.546 | 14.299 | 27.973 | 15.729 | 21.300 |
| hex: canterbury/sum | 76482 | 15633.0 ± 0.1% | 1494.6 ± 0.2% | 1103.9 ± 0.1% | 594.2 ± 2.6% | 997.8 ± 0.1% | 743.6 ± 0.2% | 10.460 | 14.162 | 26.309 | 15.667 | 21.023 |
| hex: canterbury/xargs.1 | 8456 | 14993.9 ± 0.1% | 1491.8 ± 2.5% | 1098.7 ± 0.4% | 660.2 ± 5.5% | 974.7 ± 0.2% | 727.6 ± 1.1% | 10.051 | 13.647 | 22.710 | 15.384 | 20.606 |
| hex: canterbury-large/E.coli | 524290 | 15631.2 ± 0.3% | 1470.0 ± 0.4% | 1088.6 ± 0.6% | 671.0 ± 0.3% | 991.3 ± 0.4% | 733.0 ± 0.2% | 10.633 | 14.358 | 23.294 | 15.769 | 21.324 |
| hex: canterbury-large/bible.txt | 524290 | 15613.8 ± 0.1% | 1464.1 ± 0.3% | 1083.3 ± 0.5% | 512.8 ± 0.4% | 988.4 ± 0.1% | 730.0 ± 0.4% | 10.665 | 14.413 | 30.448 | 15.797 | 21.389 |
| hex: canterbury-large/world192.txt | 524290 | 15611.0 ± 0.1% | 1467.6 ± 0.1% | 1083.4 ± 0.2% | 502.4 ± 0.4% | 986.6 ± 0.5% | 730.5 ± 0.3% | 10.637 | 14.409 | 31.074 | 15.823 | 21.370 |
| hex: http/html-1kx1024 | 2099200 | 13637.7 ± 0.3% | 1453.6 ± 0.2% | 1061.8 ± 0.2% | 501.8 ± 0.3% | 982.1 ± 0.1% | 691.6 ± 0.4% | 9.382 | 12.844 | 27.175 | 13.886 | 19.719 |
| hex: http/html-16kx64 | 2097280 | 15184.7 ± 0.3% | 1442.1 ± 0.2% | 1073.9 ± 0.1% | 507.1 ± 0.2% | 994.9 ± 0.2% | 733.4 ± 0.2% | 10.529 | 14.139 | 29.946 | 15.262 | 20.705 |
| hex: http/html-1m | 524290 | 15658.7 ± 0.1% | 1467.3 ± 0.2% | 1084.6 ± 0.4% | 499.6 ± 0.8% | 990.2 ± 0.4% | 730.8 ± 0.1% | 10.672 | 14.437 | 31.341 | 15.814 | 21.428 |
| hex: http/json-1kx1024 | 2099200 | 13656.0 ± 0.2% | 1462.2 ± 0.2% | 1065.1 ± 0.2% | 609.4 ± 0.4% | 985.6 ± 0.1% | 691.8 ± 0.2% | 9.340 | 12.821 | 22.409 | 13.856 | 19.739 |
| hex: http/json-16kx64 | 2097280 | 15162.3 ± 0.6% | 1443.4 ± 0.4% | 1073.7 ± 0.6% | 616.1 ± 0.9% | 994.6 ± 0.5% | 733.9 ± 0.2% | 10.505 | 14.121 | 24.610 | 15.245 | 20.660 |
| hex: http/json-1m | 524290 | 15653.6 ± 0.4% | 1474.2 ± 0.1% | 1089.9 ± 0.2% | 632.1 ± 0.6% | 991.5 ± 0.3% | 732.2 ± 0.8% | 10.618 | 14.363 | 24.763 | 15.788 | 21.378 |
| hex: http/js-1kx1024 | 2099200 | 13622.0 ± 1.0% | 1456.0 ± 0.4% | 1062.1 ± 0.4% | 498.4 ± 0.4% | 983.3 ± 0.2% | 692.1 ± 0.3% | 9.356 | 12.825 | 27.334 | 13.854 | 19.681 |
| hex: http/js-16kx64 | 2097280 | 15219.8 ± 0.7% | 1444.3 ± 0.2% | 1074.2 ± 0.2% | 506.1 ± 0.2% | 996.2 ± 0.2% | 733.3 ± 0.3% | 10.538 | 14.168 | 30.072 | 15.278 | 20.755 |
| hex: http/js-1m | 524290 | 15597.0 ± 0.3% | 1463.7 ± 0.5% | 1083.7 ± 0.4% | 511.8 ± 0.4% | 989.2 ± 0.3% | 732.3 ± 0.6% | 10.656 | 14.392 | 30.472 | 15.767 | 21.299 |
| hex: http/css-1kx1024 | 2099200 | 13632.0 ± 0.4% | 1454.6 ± 0.1% | 1062.7 ± 0.2% | 531.4 ± 0.6% | 982.6 ± 0.2% | 692.2 ± 0.1% | 9.372 | 12.828 | 25.651 | 13.873 | 19.693 |
| hex: http/css-16kx64 | 2097280 | 15126.8 ± 0.2% | 1442.7 ± 0.3% | 1074.0 ± 0.2% | 541.9 ± 0.2% | 999.1 ± 0.1% | 732.5 ± 0.4% | 10.485 | 14.084 | 27.916 | 15.140 | 20.651 |
| hex: http/css-1m | 524290 | 15611.9 ± 0.7% | 1467.9 ± 0.3% | 1083.9 ± 0.3% | 529.7 ± 0.4% | 991.0 ± 0.5% | 730.9 ± 0.3% | 10.636 | 14.404 | 29.474 | 15.753 | 21.360 |
| hex: shuffled/dickens-1m | 524290 | 15653.1 ± 0.2% | 1465.5 ± 0.3% | 1084.2 ± 0.4% | 502.4 ± 1.2% | 990.4 ± 0.6% | 732.6 ± 0.3% | 10.681 | 14.438 | 31.155 | 15.804 | 21.367 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1506.7 ± 0.5% | 1242.0 ± 0.1% | 1029.8 ± 0.5% | 407.6 ± 0.5% | 446.6 ± 0.3% | 414.2 ± 0.2% | 1.213 | 1.463 | 3.697 | 3.373 | 3.638 |
| qlog records, JSON text sequence | 1467503 | 1278.6 ± 0.8% | 1050.1 ± 0.5% | 773.8 ± 2.3% | 376.7 ± 1.4% | 476.2 ± 1.6% | 277.2 ± 0.7% | 1.218 | 1.652 | 3.394 | 2.685 | 4.612 |
| string: silesia/dickens | 172528 | 7122.4 ± 0.4% | 2810.6 ± 0.2% | 2927.3 ± 0.5% | 428.7 ± 0.4% | 1594.2 ± 0.4% | 1005.9 ± 0.2% | 2.534 | 2.433 | 16.612 | 4.468 | 7.080 |
| string: silesia/nci | 1075110 | 7130.9 ± 6.6% | 3403.8 ± 0.3% | 3090.4 ± 0.6% | 813.7 ± 1.3% | 1861.3 ± 0.3% | 1105.6 ± 0.3% | 2.095 | 2.307 | 8.763 | 3.831 | 6.450 |
| string: silesia/reymont | 1075159 | 3500.2 ± 2.5% | 1971.1 ± 1.4% | 2058.4 ± 0.4% | 449.3 ± 0.5% | 1495.4 ± 1.6% | 949.7 ± 0.2% | 1.776 | 1.700 | 7.791 | 2.341 | 3.686 |
| string: silesia/samba | 97582 | 4563.8 ± 2.3% | 2110.0 ± 1.1% | 3440.9 ± 0.6% | 353.8 ± 0.9% | 1485.5 ± 0.2% | 1054.4 ± 0.3% | 2.163 | 1.326 | 12.900 | 3.072 | 4.328 |
| string: silesia/webster | 1098490 | 4096.3 ± 0.7% | 1867.2 ± 0.4% | 2051.7 ± 0.2% | 440.5 ± 0.8% | 1398.5 ± 0.2% | 642.9 ± 0.9% | 2.194 | 1.996 | 9.299 | 2.929 | 6.372 |
| string: silesia/xml | 1090118 | 6255.7 ± 0.7% | 2848.8 ± 0.2% | 2645.8 ± 0.4% | 607.3 ± 0.5% | 1755.6 ± 0.1% | 919.3 ± 0.3% | 2.196 | 2.364 | 10.301 | 3.563 | 6.805 |
| string: canterbury/alice29.txt | 159425 | 6799.1 ± 1.1% | 2198.5 ± 0.6% | 2759.9 ± 0.9% | 404.9 ± 1.0% | 1471.5 ± 0.1% | 956.5 ± 0.3% | 3.093 | 2.463 | 16.793 | 4.620 | 7.108 |
| string: canterbury/asyoulik.txt | 132198 | 5886.3 ± 2.3% | 1708.8 ± 0.4% | 2373.5 ± 0.7% | 401.7 ± 1.0% | 1331.7 ± 1.3% | 883.8 ± 0.1% | 3.445 | 2.480 | 14.655 | 4.420 | 6.660 |
| string: canterbury/lcet10.txt | 441884 | 6254.1 ± 0.3% | 2566.2 ± 0.5% | 2499.3 ± 2.2% | 467.8 ± 0.9% | 1554.0 ± 0.2% | 984.3 ± 0.3% | 2.437 | 2.502 | 13.368 | 4.024 | 6.354 |
| string: canterbury/plrabn12.txt | 503330 | 5747.4 ± 0.2% | 2054.4 ± 0.2% | 2067.4 ± 0.9% | 424.6 ± 0.9% | 1390.7 ± 0.1% | 929.5 ± 0.2% | 2.798 | 2.780 | 13.537 | 4.133 | 6.183 |
| string: canterbury-large/E.coli | 1048578 | 19279.2 ± 6.5% | 9670.1 ± 2.7% | 3786.8 ± 0.2% | 1475.4 ± 1.2% | 2364.3 ± 0.2% | 1189.1 ± 0.3% | 1.994 | 5.091 | 13.068 | 8.154 | 16.213 |
| string: canterbury-large/bible.txt | 1055886 | 6781.5 ± 0.2% | 4123.5 ± 2.3% | 3046.6 ± 3.4% | 503.5 ± 1.6% | 1980.6 ± 2.2% | 1117.7 ± 2.5% | 1.645 | 2.226 | 13.468 | 3.424 | 6.067 |
| string: canterbury-large/world192.txt | 1103121 | 4038.4 ± 0.5% | 1651.4 ± 0.8% | 1998.8 ± 1.2% | 449.8 ± 0.6% | 1369.7 ± 0.1% | 906.4 ± 0.4% | 2.445 | 2.020 | 8.978 | 2.948 | 4.455 |
| string: http/html-1m | 1058582 | 6805.8 ± 0.7% | 3940.3 ± 0.2% | 3040.1 ± 0.1% | 502.4 ± 1.3% | 1931.5 ± 0.4% | 805.1 ± 0.2% | 1.727 | 2.239 | 13.547 | 3.524 | 8.453 |
| string: http/json-1m | 1190272 | 3292.7 ± 0.3% | 1353.0 ± 0.4% | 1554.1 ± 0.3% | 443.9 ± 0.6% | 1069.6 ± 0.3% | 764.2 ± 0.3% | 2.434 | 2.119 | 7.418 | 3.078 | 4.309 |
| string: http/js-1m | 1144362 | 2808.5 ± 0.4% | 1174.7 ± 0.3% | 1620.0 ± 0.6% | 368.6 ± 0.3% | 1107.2 ± 0.5% | 755.3 ± 0.3% | 2.391 | 1.734 | 7.620 | 2.537 | 3.719 |
| string: http/css-1m | 1097820 | 4025.7 ± 0.6% | 1488.4 ± 0.5% | 2150.5 ± 0.7% | 492.2 ± 0.7% | 1378.0 ± 0.7% | 893.0 ± 0.9% | 2.705 | 1.872 | 8.179 | 2.921 | 4.508 |
| string: dickens as Cyrillic and CJK | 1883069 | 3066.1 ± 0.2% | 2331.5 ± 0.8% | 521.2 ± 0.3% | 307.5 ± 0.9% | 563.8 ± 0.3% | 334.4 ± 0.2% | 1.315 | 5.882 | 9.973 | 5.439 | 9.169 |
| hex: silesia/dickens | 524290 | 15681.1 ± 0.2% | 1464.3 ± 0.2% | 1081.9 ± 0.3% | 500.1 ± 0.9% | 987.5 ± 0.2% | 731.6 ± 0.3% | 10.709 | 14.494 | 31.357 | 15.880 | 21.434 |
| hex: silesia/mozilla | 524290 | 15599.8 ± 0.5% | 1472.7 ± 0.3% | 1089.3 ± 0.1% | 440.1 ± 0.4% | 990.9 ± 0.2% | 732.4 ± 0.2% | 10.593 | 14.321 | 35.449 | 15.743 | 21.299 |
| hex: silesia/mr | 524290 | 15610.2 ± 0.5% | 1480.0 ± 0.2% | 1092.6 ± 0.5% | 555.3 ± 0.9% | 994.7 ± 0.4% | 733.5 ± 0.2% | 10.547 | 14.287 | 28.109 | 15.693 | 21.282 |
| hex: silesia/nci | 524290 | 15613.8 ± 0.4% | 1472.0 ± 0.5% | 1088.7 ± 0.3% | 636.2 ± 4.6% | 988.6 ± 0.6% | 732.2 ± 0.4% | 10.607 | 14.342 | 24.543 | 15.794 | 21.324 |
| hex: silesia/ooffice | 524290 | 15632.3 ± 0.3% | 1464.2 ± 0.1% | 1083.0 ± 0.4% | 388.7 ± 0.2% | 989.2 ± 0.5% | 731.9 ± 0.4% | 10.676 | 14.434 | 40.215 | 15.804 | 21.360 |
| hex: silesia/osdb | 524290 | 15614.8 ± 0.2% | 1470.3 ± 0.1% | 1085.6 ± 0.4% | 474.8 ± 1.4% | 991.6 ± 0.4% | 732.8 ± 0.2% | 10.620 | 14.383 | 32.885 | 15.747 | 21.309 |
| hex: silesia/reymont | 524290 | 15668.1 ± 0.3% | 1460.0 ± 0.3% | 1083.9 ± 0.5% | 512.7 ± 0.8% | 986.9 ± 0.4% | 731.9 ± 0.6% | 10.732 | 14.455 | 30.558 | 15.876 | 21.407 |
| hex: silesia/samba | 524290 | 15673.5 ± 0.2% | 1466.3 ± 0.1% | 1084.5 ± 0.2% | 402.3 ± 0.3% | 989.6 ± 0.2% | 731.8 ± 0.7% | 10.689 | 14.452 | 38.955 | 15.837 | 21.418 |
| hex: silesia/sao | 524290 | 15673.9 ± 0.3% | 1459.9 ± 0.8% | 1081.8 ± 0.5% | 332.6 ± 0.5% | 988.8 ± 0.4% | 732.2 ± 0.4% | 10.737 | 14.489 | 47.129 | 15.852 | 21.408 |
| hex: silesia/webster | 524290 | 15692.6 ± 0.1% | 1465.5 ± 0.4% | 1084.4 ± 0.4% | 475.1 ± 0.5% | 986.9 ± 0.7% | 731.9 ± 0.3% | 10.708 | 14.472 | 33.033 | 15.901 | 21.441 |
| hex: silesia/x-ray | 524290 | 15644.5 ± 0.2% | 1476.8 ± 0.5% | 1090.1 ± 0.1% | 444.5 ± 1.7% | 995.1 ± 0.3% | 732.3 ± 0.3% | 10.594 | 14.351 | 35.200 | 15.721 | 21.362 |
| hex: silesia/xml | 524290 | 15635.6 ± 0.7% | 1467.1 ± 0.3% | 1085.3 ± 0.3% | 616.4 ± 0.8% | 990.5 ± 0.3% | 732.2 ± 0.3% | 10.658 | 14.406 | 25.367 | 15.786 | 21.355 |
| hex: canterbury/alice29.txt | 304180 | 15695.7 ± 0.1% | 1475.0 ± 0.2% | 1089.9 ± 0.3% | 503.8 ± 1.1% | 995.7 ± 0.4% | 733.8 ± 0.2% | 10.641 | 14.401 | 31.155 | 15.764 | 21.389 |
| hex: canterbury/asyoulik.txt | 250360 | 15718.8 ± 0.1% | 1476.8 ± 0.7% | 1094.8 ± 0.2% | 500.1 ± 1.3% | 994.7 ± 0.3% | 737.8 ± 0.2% | 10.644 | 14.358 | 31.430 | 15.803 | 21.304 |
| hex: canterbury/cp.html | 49208 | 15633.5 ± 0.0% | 1479.6 ± 1.0% | 1099.0 ± 0.2% | 530.9 ± 2.8% | 1004.8 ± 0.6% | 742.0 ± 0.2% | 10.566 | 14.225 | 29.448 | 15.559 | 21.068 |
| hex: canterbury/fields.c | 22302 | 15451.9 ± 0.1% | 1412.7 ± 0.4% | 1067.2 ± 0.3% | 619.2 ± 9.2% | 986.4 ± 0.2% | 736.5 ± 0.5% | 10.938 | 14.478 | 24.955 | 15.665 | 20.979 |
| hex: canterbury/grammar.lsp | 7444 | 14979.5 ± 0.0% | 1507.7 ± 0.2% | 1092.5 ± 0.3% | 667.6 ± 3.2% | 998.9 ± 0.1% | 725.2 ± 0.2% | 9.935 | 13.711 | 22.437 | 14.996 | 20.656 |
| hex: canterbury/kennedy.xls | 524290 | 15590.0 ± 0.2% | 1472.7 ± 0.3% | 1087.9 ± 0.4% | 653.6 ± 2.0% | 991.4 ± 0.2% | 731.0 ± 0.3% | 10.586 | 14.331 | 23.852 | 15.725 | 21.327 |
| hex: canterbury/lcet10.txt | 524290 | 15643.0 ± 0.1% | 1461.2 ± 0.3% | 1082.9 ± 0.2% | 502.3 ± 1.0% | 987.8 ± 0.2% | 731.4 ± 0.7% | 10.706 | 14.445 | 31.142 | 15.837 | 21.388 |
| hex: canterbury/plrabn12.txt | 524290 | 15595.2 ± 0.4% | 1461.6 ± 0.1% | 1083.0 ± 0.1% | 492.0 ± 0.3% | 988.4 ± 0.3% | 732.5 ± 0.3% | 10.670 | 14.400 | 31.700 | 15.778 | 21.289 |
| hex: canterbury/ptt5 | 524290 | 15592.5 ± 0.7% | 1479.2 ± 0.2% | 1090.9 ± 0.2% | 557.7 ± 0.7% | 991.8 ± 0.2% | 732.4 ± 0.3% | 10.541 | 14.293 | 27.961 | 15.722 | 21.291 |
| hex: canterbury/sum | 76482 | 15649.7 ± 0.0% | 1494.6 ± 0.2% | 1103.9 ± 0.1% | 594.2 ± 2.6% | 997.8 ± 0.1% | 743.6 ± 0.2% | 10.471 | 14.177 | 26.337 | 15.684 | 21.045 |
| hex: canterbury/xargs.1 | 8456 | 15037.1 ± 0.0% | 1491.8 ± 2.5% | 1098.7 ± 0.4% | 660.2 ± 5.5% | 974.7 ± 0.2% | 727.6 ± 1.1% | 10.080 | 13.687 | 22.776 | 15.428 | 20.666 |
| hex: canterbury-large/E.coli | 524290 | 15503.0 ± 0.2% | 1470.0 ± 0.4% | 1088.6 ± 0.6% | 671.0 ± 0.3% | 991.3 ± 0.4% | 733.0 ± 0.2% | 10.546 | 14.241 | 23.103 | 15.639 | 21.149 |
| hex: canterbury-large/bible.txt | 524290 | 15627.7 ± 0.6% | 1464.1 ± 0.3% | 1083.3 ± 0.5% | 512.8 ± 0.4% | 988.4 ± 0.1% | 730.0 ± 0.4% | 10.674 | 14.426 | 30.475 | 15.811 | 21.408 |
| hex: canterbury-large/world192.txt | 524290 | 15639.6 ± 0.3% | 1467.6 ± 0.1% | 1083.4 ± 0.2% | 502.4 ± 0.4% | 986.6 ± 0.5% | 730.5 ± 0.3% | 10.656 | 14.435 | 31.131 | 15.852 | 21.409 |
| hex: http/html-1kx1024 | 2099200 | 13813.9 ± 0.8% | 1453.6 ± 0.2% | 1061.8 ± 0.2% | 501.8 ± 0.3% | 982.1 ± 0.1% | 691.6 ± 0.4% | 9.503 | 13.010 | 27.527 | 14.065 | 19.974 |
| hex: http/html-16kx64 | 2097280 | 15242.9 ± 0.3% | 1442.1 ± 0.2% | 1073.9 ± 0.1% | 507.1 ± 0.2% | 994.9 ± 0.2% | 733.4 ± 0.2% | 10.570 | 14.193 | 30.061 | 15.321 | 20.784 |
| hex: http/html-1m | 524290 | 15668.9 ± 0.2% | 1467.3 ± 0.2% | 1084.6 ± 0.4% | 499.6 ± 0.8% | 990.2 ± 0.4% | 730.8 ± 0.1% | 10.679 | 14.447 | 31.362 | 15.825 | 21.442 |
| hex: http/json-1kx1024 | 2099200 | 13826.9 ± 0.7% | 1462.2 ± 0.2% | 1065.1 ± 0.2% | 609.4 ± 0.4% | 985.6 ± 0.1% | 691.8 ± 0.2% | 9.456 | 12.982 | 22.689 | 14.030 | 19.986 |
| hex: http/json-16kx64 | 2097280 | 15235.5 ± 0.5% | 1443.4 ± 0.4% | 1073.7 ± 0.6% | 616.1 ± 0.9% | 994.6 ± 0.5% | 733.9 ± 0.2% | 10.556 | 14.189 | 24.729 | 15.318 | 20.760 |
| hex: http/json-1m | 524290 | 15673.1 ± 0.2% | 1474.2 ± 0.1% | 1089.9 ± 0.2% | 632.1 ± 0.6% | 991.5 ± 0.3% | 732.2 ± 0.8% | 10.632 | 14.381 | 24.794 | 15.808 | 21.405 |
| hex: http/js-1kx1024 | 2099200 | 13772.1 ± 0.5% | 1456.0 ± 0.4% | 1062.1 ± 0.4% | 498.4 ± 0.4% | 983.3 ± 0.2% | 692.1 ± 0.3% | 9.459 | 12.967 | 27.635 | 14.006 | 19.898 |
| hex: http/js-16kx64 | 2097280 | 15266.4 ± 1.3% | 1444.3 ± 0.2% | 1074.2 ± 0.2% | 506.1 ± 0.2% | 996.2 ± 0.2% | 733.3 ± 0.3% | 10.570 | 14.211 | 30.164 | 15.325 | 20.818 |
| hex: http/js-1m | 524290 | 15594.4 ± 0.3% | 1463.7 ± 0.5% | 1083.7 ± 0.4% | 511.8 ± 0.4% | 989.2 ± 0.3% | 732.3 ± 0.6% | 10.654 | 14.389 | 30.467 | 15.764 | 21.295 |
| hex: http/css-1kx1024 | 2099200 | 13757.3 ± 0.3% | 1454.6 ± 0.1% | 1062.7 ± 0.2% | 531.4 ± 0.6% | 982.6 ± 0.2% | 692.2 ± 0.1% | 9.458 | 12.946 | 25.886 | 14.001 | 19.874 |
| hex: http/css-16kx64 | 2097280 | 15174.6 ± 4.3% | 1442.7 ± 0.3% | 1074.0 ± 0.2% | 541.9 ± 0.2% | 999.1 ± 0.1% | 732.5 ± 0.4% | 10.518 | 14.129 | 28.004 | 15.188 | 20.716 |
| hex: http/css-1m | 524290 | 15647.8 ± 0.2% | 1467.9 ± 0.3% | 1083.9 ± 0.3% | 529.7 ± 0.4% | 991.0 ± 0.5% | 730.9 ± 0.3% | 10.660 | 14.437 | 29.542 | 15.790 | 21.409 |
| hex: shuffled/dickens-1m | 524290 | 15679.5 ± 0.2% | 1465.5 ± 0.3% | 1084.2 ± 0.4% | 502.4 ± 1.2% | 990.4 ± 0.6% | 732.6 ± 0.3% | 10.699 | 14.462 | 31.207 | 15.831 | 21.403 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.0 ± 0.2% | 924.4 ± 1.1% | 1014.5 ± 0.2% | 300.3 ± 0.8% | 665.7 ± 0.3% | 309.4 ± 2.3% | 1.014 | 0.924 | 3.121 | 1.408 | 3.029 |
| qlog records, JSON text sequence | 1467503 | 781.9 ± 6.3% | 814.6 ± 0.6% | 769.6 ± 47.2% | 240.7 ± 2.2% | 706.8 ± 0.7% | 246.5 ± 2.6% | 0.960 | 1.016 | 3.249 | 1.106 | 3.172 |
| string: silesia/dickens | 172528 | 5056.5 ± 0.4% | 1876.5 ± 0.2% | 2647.9 ± 0.3% | 360.5 ± 0.5% | 2872.1 ± 0.6% | 550.7 ± 2.5% | 2.695 | 1.910 | 14.027 | 1.761 | 9.182 |
| string: silesia/nci | 1075110 | 4317.2 ± 0.4% | 2236.3 ± 0.2% | 2989.7 ± 0.6% | 542.3 ± 1.1% | 2969.8 ± 0.6% | 595.7 ± 4.5% | 1.930 | 1.444 | 7.962 | 1.454 | 7.248 |
| string: silesia/reymont | 1075159 | 2962.3 ± 2.5% | 1809.9 ± 0.9% | 2057.0 ± 0.4% | 374.8 ± 1.1% | 2142.6 ± 0.8% | 536.7 ± 0.9% | 1.637 | 1.440 | 7.904 | 1.383 | 5.520 |
| string: silesia/samba | 97582 | 3499.5 ± 0.4% | 2024.0 ± 0.2% | 2616.3 ± 0.3% | 324.0 ± 0.5% | 1507.1 ± 1.0% | 424.1 ± 1.3% | 1.729 | 1.338 | 10.800 | 2.322 | 8.252 |
| string: silesia/webster | 1098490 | 3671.3 ± 0.9% | 1517.7 ± 0.3% | 2009.8 ± 0.5% | 359.0 ± 0.5% | 2170.0 ± 1.1% | 497.3 ± 3.8% | 2.419 | 1.827 | 10.225 | 1.692 | 7.382 |
| string: silesia/xml | 1090118 | 4805.1 ± 1.0% | 2355.3 ± 0.2% | 2517.4 ± 0.2% | 453.1 ± 1.3% | 2783.0 ± 1.7% | 563.6 ± 1.3% | 2.040 | 1.909 | 10.605 | 1.727 | 8.525 |
| string: canterbury/alice29.txt | 159425 | 4361.4 ± 1.5% | 1598.2 ± 0.3% | 2454.9 ± 0.5% | 343.1 ± 0.7% | 2516.1 ± 0.6% | 502.9 ± 1.3% | 2.729 | 1.777 | 12.713 | 1.733 | 8.672 |
| string: canterbury/asyoulik.txt | 132198 | 3502.7 ± 1.1% | 1458.1 ± 0.2% | 2244.8 ± 0.3% | 334.5 ± 1.7% | 2091.7 ± 0.2% | 462.8 ± 1.3% | 2.402 | 1.560 | 10.472 | 1.675 | 7.568 |
| string: canterbury/lcet10.txt | 441884 | 5137.1 ± 0.3% | 1853.6 ± 0.2% | 2342.1 ± 0.6% | 391.1 ± 0.6% | 2869.7 ± 1.3% | 533.5 ± 2.4% | 2.771 | 2.193 | 13.136 | 1.790 | 9.628 |
| string: canterbury/plrabn12.txt | 503330 | 4134.4 ± 0.2% | 1735.6 ± 0.1% | 2061.0 ± 0.2% | 360.9 ± 0.7% | 2488.5 ± 0.4% | 492.9 ± 1.2% | 2.382 | 2.006 | 11.455 | 1.661 | 8.388 |
| string: canterbury-large/E.coli | 1048578 | 11919.0 ± 0.3% | 3601.0 ± 0.3% | 3247.8 ± 0.4% | 933.5 ± 1.0% | 6000.2 ± 0.4% | 755.8 ± 1.7% | 3.310 | 3.670 | 12.768 | 1.986 | 15.770 |
| string: canterbury-large/bible.txt | 1055886 | 6905.2 ± 9.5% | 2934.4 ± 4.0% | 2823.7 ± 0.3% | 418.9 ± 1.5% | 3739.3 ± 5.9% | 611.0 ± 9.3% | 2.353 | 2.445 | 16.483 | 1.847 | 11.302 |
| string: canterbury-large/world192.txt | 1103121 | 3393.3 ± 0.4% | 1480.8 ± 1.4% | 2005.5 ± 2.6% | 352.3 ± 0.6% | 2124.8 ± 4.5% | 497.9 ± 1.1% | 2.292 | 1.692 | 9.632 | 1.597 | 6.815 |
| string: http/html-1m | 1058582 | 6226.4 ± 1.0% | 2733.4 ± 0.6% | 2687.0 ± 0.6% | 442.1 ± 0.4% | 3463.0 ± 0.6% | 594.3 ± 1.1% | 2.278 | 2.317 | 14.085 | 1.798 | 10.477 |
| string: http/json-1m | 1190272 | 2552.2 ± 0.4% | 876.3 ± 0.2% | 2243.6 ± 0.5% | 390.1 ± 0.6% | 1048.5 ± 4.4% | 439.4 ± 2.0% | 2.913 | 1.138 | 6.542 | 2.434 | 5.808 |
| string: http/js-1m | 1144362 | 2283.2 ± 0.7% | 1027.5 ± 0.4% | 1633.9 ± 0.4% | 321.2 ± 0.8% | 1513.4 ± 0.4% | 415.6 ± 1.2% | 2.222 | 1.397 | 7.109 | 1.509 | 5.494 |
| string: http/css-1m | 1097820 | 2657.3 ± 0.6% | 1676.3 ± 0.4% | 2213.1 ± 0.4% | 406.7 ± 0.9% | 1910.7 ± 0.5% | 484.2 ± 1.0% | 1.585 | 1.201 | 6.535 | 1.391 | 5.488 |
| string: dickens as Cyrillic and CJK | 1883069 | 3075.9 ± 0.4% | 1681.9 ± 0.3% | 889.1 ± 0.3% | 350.8 ± 0.3% | 665.3 ± 0.7% | 155.9 ± 3.2% | 1.829 | 3.460 | 8.769 | 4.623 | 19.727 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1328.7 ± 0.4% | 978.1 ± 0.3% | 1187.6 ± 0.3% | 213.8 ± 0.3% | 470.7 ± 0.8% | 248.9 ± 4.8% | 1.358 | 1.119 | 6.214 | 2.823 | 5.338 |
| hex: silesia/dickens | 524290 | 11928.8 ± 0.3% | 3612.2 ± 1.2% | 3286.1 ± 0.7% | 507.6 ± 0.9% | 6095.8 ± 1.9% | 776.1 ± 4.5% | 3.302 | 3.630 | 23.498 | 1.957 | 15.370 |
| hex: silesia/mozilla | 524290 | 12013.9 ± 0.1% | 3615.2 ± 0.2% | 3292.1 ± 0.3% | 452.3 ± 0.9% | 6093.0 ± 1.9% | 776.6 ± 0.4% | 3.323 | 3.649 | 26.561 | 1.972 | 15.470 |
| hex: silesia/mr | 524290 | 11991.9 ± 0.2% | 3615.7 ± 0.1% | 3280.9 ± 0.2% | 579.8 ± 1.4% | 6050.0 ± 1.1% | 778.3 ± 0.6% | 3.317 | 3.655 | 20.684 | 1.982 | 15.407 |
| hex: silesia/nci | 524290 | 11975.9 ± 0.2% | 3616.1 ± 0.5% | 3293.7 ± 0.2% | 629.2 ± 1.9% | 6065.0 ± 1.6% | 778.6 ± 0.5% | 3.312 | 3.636 | 19.035 | 1.975 | 15.382 |
| hex: silesia/ooffice | 524290 | 11977.8 ± 0.5% | 3610.1 ± 0.3% | 3284.5 ± 0.2% | 405.8 ± 0.7% | 6059.1 ± 1.1% | 778.0 ± 0.2% | 3.318 | 3.647 | 29.514 | 1.977 | 15.396 |
| hex: silesia/osdb | 524290 | 11975.0 ± 0.2% | 3611.2 ± 0.2% | 3290.6 ± 0.2% | 490.0 ± 1.8% | 6033.9 ± 0.9% | 778.5 ± 0.4% | 3.316 | 3.639 | 24.439 | 1.985 | 15.382 |
| hex: silesia/reymont | 524290 | 11989.7 ± 0.3% | 3616.5 ± 0.2% | 3278.7 ± 0.2% | 523.1 ± 2.2% | 6059.9 ± 1.3% | 777.8 ± 0.6% | 3.315 | 3.657 | 22.922 | 1.979 | 15.415 |
| hex: silesia/samba | 524290 | 11951.5 ± 0.2% | 3614.0 ± 0.3% | 3290.6 ± 0.2% | 411.8 ± 1.1% | 6079.2 ± 1.5% | 779.5 ± 0.3% | 3.307 | 3.632 | 29.024 | 1.966 | 15.333 |
| hex: silesia/sao | 524290 | 11945.7 ± 0.4% | 3616.8 ± 0.2% | 3289.2 ± 0.2% | 347.0 ± 1.5% | 6070.3 ± 1.2% | 778.1 ± 0.8% | 3.303 | 3.632 | 34.425 | 1.968 | 15.353 |
| hex: silesia/webster | 524290 | 11990.8 ± 0.1% | 3615.9 ± 0.2% | 3289.4 ± 0.3% | 479.3 ± 2.4% | 6147.3 ± 1.3% | 778.8 ± 0.7% | 3.316 | 3.645 | 25.017 | 1.951 | 15.397 |
| hex: silesia/x-ray | 524290 | 11984.1 ± 0.2% | 3615.0 ± 0.3% | 3282.5 ± 0.3% | 484.8 ± 0.2% | 6059.6 ± 2.7% | 779.6 ± 0.4% | 3.315 | 3.651 | 24.720 | 1.978 | 15.372 |
| hex: silesia/xml | 524290 | 11946.6 ± 0.2% | 3617.2 ± 0.3% | 3293.2 ± 0.3% | 533.8 ± 0.9% | 6061.2 ± 0.3% | 779.7 ± 0.2% | 3.303 | 3.628 | 22.379 | 1.971 | 15.322 |
| hex: canterbury/alice29.txt | 304180 | 12007.9 ± 0.1% | 3638.2 ± 0.0% | 3349.6 ± 0.2% | 525.0 ± 0.1% | 6091.2 ± 0.6% | 780.0 ± 0.6% | 3.301 | 3.585 | 22.871 | 1.971 | 15.395 |
| hex: canterbury/asyoulik.txt | 250360 | 11999.4 ± 0.1% | 3635.5 ± 0.1% | 3363.3 ± 0.6% | 515.6 ± 0.5% | 6171.8 ± 1.4% | 778.7 ± 0.5% | 3.301 | 3.568 | 23.271 | 1.944 | 15.410 |
| hex: canterbury/cp.html | 49208 | 11926.1 ± 0.1% | 3637.7 ± 0.1% | 3277.6 ± 0.1% | 482.3 ± 0.7% | 6272.3 ± 0.3% | 759.5 ± 0.9% | 3.278 | 3.639 | 24.729 | 1.901 | 15.703 |
| hex: canterbury/fields.c | 22302 | 11780.0 ± 0.1% | 3627.4 ± 0.5% | 3389.0 ± 0.0% | 510.5 ± 0.3% | 6259.6 ± 0.4% | 755.7 ± 2.2% | 3.248 | 3.476 | 23.076 | 1.882 | 15.589 |
| hex: canterbury/grammar.lsp | 7444 | 11249.8 ± 0.1% | 3600.6 ± 0.4% | 3354.0 ± 0.7% | 554.7 ± 3.1% | 6162.4 ± 0.4% | 702.4 ± 1.7% | 3.124 | 3.354 | 20.281 | 1.826 | 16.016 |
| hex: canterbury/kennedy.xls | 524290 | 12013.1 ± 0.1% | 3613.3 ± 0.2% | 3283.5 ± 0.3% | 656.9 ± 5.9% | 6123.6 ± 1.0% | 759.3 ± 8.7% | 3.325 | 3.659 | 18.287 | 1.962 | 15.822 |
| hex: canterbury/lcet10.txt | 524290 | 12003.7 ± 0.1% | 3611.1 ± 0.3% | 3287.7 ± 0.1% | 511.5 ± 1.1% | 6104.4 ± 1.2% | 769.9 ± 2.6% | 3.324 | 3.651 | 23.469 | 1.966 | 15.592 |
| hex: canterbury/plrabn12.txt | 524290 | 12000.8 ± 0.1% | 3615.4 ± 0.2% | 3290.2 ± 0.2% | 503.5 ± 0.8% | 6085.2 ± 1.1% | 762.8 ± 2.0% | 3.319 | 3.647 | 23.835 | 1.972 | 15.733 |
| hex: canterbury/ptt5 | 524290 | 11971.2 ± 0.3% | 3613.1 ± 0.3% | 3281.0 ± 0.4% | 556.5 ± 0.3% | 6090.5 ± 1.7% | 773.4 ± 3.7% | 3.313 | 3.649 | 21.513 | 1.966 | 15.478 |
| hex: canterbury/sum | 76482 | 11917.4 ± 0.1% | 3632.8 ± 0.1% | 3358.0 ± 0.4% | 506.6 ± 1.3% | 6171.0 ± 0.6% | 770.6 ± 1.4% | 3.280 | 3.549 | 23.526 | 1.931 | 15.465 |
| hex: canterbury/xargs.1 | 8456 | 11351.8 ± 0.0% | 3602.0 ± 0.1% | 3349.2 ± 0.4% | 486.5 ± 1.8% | 6153.2 ± 0.4% | 734.9 ± 2.1% | 3.152 | 3.389 | 23.333 | 1.845 | 15.446 |
| hex: canterbury-large/E.coli | 524290 | 11946.6 ± 0.4% | 3611.4 ± 0.7% | 3272.4 ± 0.8% | 688.0 ± 0.1% | 6024.2 ± 1.1% | 769.8 ± 6.1% | 3.308 | 3.651 | 17.364 | 1.983 | 15.520 |
| hex: canterbury-large/bible.txt | 524290 | 12005.0 ± 0.1% | 3615.4 ± 0.3% | 3295.4 ± 0.2% | 522.0 ± 2.1% | 6078.2 ± 1.4% | 772.3 ± 2.6% | 3.321 | 3.643 | 22.999 | 1.975 | 15.544 |
| hex: canterbury-large/world192.txt | 524290 | 11993.0 ± 0.2% | 3612.3 ± 0.6% | 3291.1 ± 0.3% | 505.9 ± 2.1% | 6098.3 ± 0.9% | 770.0 ± 1.3% | 3.320 | 3.644 | 23.706 | 1.967 | 15.575 |
| hex: http/html-1kx1024 | 2099200 | 8680.8 ± 4.7% | 3459.0 ± 0.2% | 2815.0 ± 0.7% | 475.4 ± 0.5% | 5022.0 ± 1.1% | 610.0 ± 1.9% | 2.510 | 3.084 | 18.260 | 1.729 | 14.231 |
| hex: http/html-16kx64 | 2097280 | 11730.3 ± 0.3% | 3610.0 ± 0.1% | 3249.3 ± 0.3% | 479.6 ± 1.4% | 6004.4 ± 1.0% | 728.0 ± 3.8% | 3.249 | 3.610 | 24.458 | 1.954 | 16.113 |
| hex: http/html-1m | 524290 | 11993.7 ± 0.3% | 3609.0 ± 0.2% | 3290.0 ± 0.9% | 493.9 ± 1.8% | 6110.8 ± 1.1% | 775.1 ± 3.1% | 3.323 | 3.646 | 24.282 | 1.963 | 15.473 |
| hex: http/json-1kx1024 | 2099200 | 8675.0 ± 4.5% | 3459.7 ± 0.1% | 2816.7 ± 0.9% | 576.1 ± 1.0% | 5034.2 ± 1.0% | 629.7 ± 3.4% | 2.507 | 3.080 | 15.057 | 1.723 | 13.777 |
| hex: http/json-16kx64 | 2097280 | 11732.1 ± 0.2% | 3608.9 ± 0.2% | 3247.6 ± 0.3% | 574.6 ± 1.4% | 6010.2 ± 3.1% | 743.9 ± 6.8% | 3.251 | 3.613 | 20.419 | 1.952 | 15.771 |
| hex: http/json-1m | 524290 | 11983.9 ± 0.2% | 3612.3 ± 0.1% | 3289.3 ± 0.1% | 596.9 ± 2.7% | 6094.5 ± 0.9% | 768.2 ± 2.7% | 3.317 | 3.643 | 20.076 | 1.966 | 15.600 |
| hex: http/js-1kx1024 | 2099200 | 8659.9 ± 4.2% | 3455.4 ± 0.2% | 2812.8 ± 0.5% | 480.9 ± 0.6% | 5021.8 ± 2.2% | 609.7 ± 4.4% | 2.506 | 3.079 | 18.007 | 1.724 | 14.202 |
| hex: http/js-16kx64 | 2097280 | 11732.9 ± 0.1% | 3610.8 ± 0.2% | 3262.5 ± 0.2% | 482.7 ± 1.9% | 6007.4 ± 0.8% | 736.7 ± 2.0% | 3.249 | 3.596 | 24.306 | 1.953 | 15.926 |
| hex: http/js-1m | 524290 | 11919.0 ± 0.2% | 3617.8 ± 0.3% | 3286.5 ± 0.2% | 505.6 ± 1.1% | 6047.7 ± 0.2% | 778.6 ± 3.4% | 3.295 | 3.627 | 23.574 | 1.971 | 15.309 |
| hex: http/css-1kx1024 | 2099200 | 8662.7 ± 4.9% | 3461.8 ± 0.1% | 2824.6 ± 0.6% | 488.8 ± 0.4% | 5050.1 ± 1.3% | 620.8 ± 5.1% | 2.502 | 3.067 | 17.721 | 1.715 | 13.955 |
| hex: http/css-16kx64 | 2097280 | 11741.0 ± 0.1% | 3609.6 ± 0.3% | 3246.4 ± 0.2% | 496.2 ± 0.8% | 6013.8 ± 0.9% | 745.7 ± 3.8% | 3.253 | 3.617 | 23.661 | 1.952 | 15.746 |
| hex: http/css-1m | 524290 | 11989.4 ± 0.3% | 3616.2 ± 0.8% | 3288.3 ± 1.5% | 498.5 ± 2.1% | 6110.2 ± 0.7% | 767.6 ± 2.6% | 3.315 | 3.646 | 24.053 | 1.962 | 15.620 |
| hex: shuffled/dickens-1m | 524290 | 12009.1 ± 0.1% | 3611.8 ± 0.2% | 3286.5 ± 0.3% | 511.7 ± 0.5% | 6150.7 ± 1.1% | 777.4 ± 1.5% | 3.325 | 3.654 | 23.470 | 1.952 | 15.447 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1013.3 ± 0.3% | 924.4 ± 1.1% | 1014.5 ± 0.2% | 300.3 ± 0.8% | 665.7 ± 0.3% | 309.4 ± 2.3% | 1.096 | 0.999 | 3.375 | 1.522 | 3.276 |
| qlog records, JSON text sequence | 1467503 | 833.9 ± 16.9% | 814.6 ± 0.6% | 769.6 ± 47.2% | 240.7 ± 2.2% | 706.8 ± 0.7% | 246.5 ± 2.6% | 1.024 | 1.084 | 3.465 | 1.180 | 3.383 |
| string: silesia/dickens | 172528 | 5055.6 ± 0.3% | 1876.5 ± 0.2% | 2647.9 ± 0.3% | 360.5 ± 0.5% | 2872.1 ± 0.6% | 550.7 ± 2.5% | 2.694 | 1.909 | 14.024 | 1.760 | 9.180 |
| string: silesia/nci | 1075110 | 4312.9 ± 0.4% | 2236.3 ± 0.2% | 2989.7 ± 0.6% | 542.3 ± 1.1% | 2969.8 ± 0.6% | 595.7 ± 4.5% | 1.929 | 1.443 | 7.954 | 1.452 | 7.240 |
| string: silesia/reymont | 1075159 | 2970.4 ± 1.4% | 1809.9 ± 0.9% | 2057.0 ± 0.4% | 374.8 ± 1.1% | 2142.6 ± 0.8% | 536.7 ± 0.9% | 1.641 | 1.444 | 7.926 | 1.386 | 5.535 |
| string: silesia/samba | 97582 | 3509.0 ± 0.3% | 2024.0 ± 0.2% | 2616.3 ± 0.3% | 324.0 ± 0.5% | 1507.1 ± 1.0% | 424.1 ± 1.3% | 1.734 | 1.341 | 10.830 | 2.328 | 8.274 |
| string: silesia/webster | 1098490 | 3668.3 ± 0.3% | 1517.7 ± 0.3% | 2009.8 ± 0.5% | 359.0 ± 0.5% | 2170.0 ± 1.1% | 497.3 ± 3.8% | 2.417 | 1.825 | 10.217 | 1.690 | 7.376 |
| string: silesia/xml | 1090118 | 4813.6 ± 0.6% | 2355.3 ± 0.2% | 2517.4 ± 0.2% | 453.1 ± 1.3% | 2783.0 ± 1.7% | 563.6 ± 1.3% | 2.044 | 1.912 | 10.624 | 1.730 | 8.540 |
| string: canterbury/alice29.txt | 159425 | 4365.1 ± 1.4% | 1598.2 ± 0.3% | 2454.9 ± 0.5% | 343.1 ± 0.7% | 2516.1 ± 0.6% | 502.9 ± 1.3% | 2.731 | 1.778 | 12.724 | 1.735 | 8.680 |
| string: canterbury/asyoulik.txt | 132198 | 3508.0 ± 1.1% | 1458.1 ± 0.2% | 2244.8 ± 0.3% | 334.5 ± 1.7% | 2091.7 ± 0.2% | 462.8 ± 1.3% | 2.406 | 1.563 | 10.488 | 1.677 | 7.579 |
| string: canterbury/lcet10.txt | 441884 | 5142.4 ± 0.2% | 1853.6 ± 0.2% | 2342.1 ± 0.6% | 391.1 ± 0.6% | 2869.7 ± 1.3% | 533.5 ± 2.4% | 2.774 | 2.196 | 13.150 | 1.792 | 9.638 |
| string: canterbury/plrabn12.txt | 503330 | 4133.4 ± 0.5% | 1735.6 ± 0.1% | 2061.0 ± 0.2% | 360.9 ± 0.7% | 2488.5 ± 0.4% | 492.9 ± 1.2% | 2.382 | 2.006 | 11.452 | 1.661 | 8.386 |
| string: canterbury-large/E.coli | 1048578 | 11931.3 ± 0.3% | 3601.0 ± 0.3% | 3247.8 ± 0.4% | 933.5 ± 1.0% | 6000.2 ± 0.4% | 755.8 ± 1.7% | 3.313 | 3.674 | 12.782 | 1.988 | 15.787 |
| string: canterbury-large/bible.txt | 1055886 | 6930.8 ± 2.2% | 2934.4 ± 4.0% | 2823.7 ± 0.3% | 418.9 ± 1.5% | 3739.3 ± 5.9% | 611.0 ± 9.3% | 2.362 | 2.454 | 16.545 | 1.853 | 11.344 |
| string: canterbury-large/world192.txt | 1103121 | 3390.0 ± 1.0% | 1480.8 ± 1.4% | 2005.5 ± 2.6% | 352.3 ± 0.6% | 2124.8 ± 4.5% | 497.9 ± 1.1% | 2.289 | 1.690 | 9.623 | 1.595 | 6.808 |
| string: http/html-1m | 1058582 | 6280.7 ± 1.7% | 2733.4 ± 0.6% | 2687.0 ± 0.6% | 442.1 ± 0.4% | 3463.0 ± 0.6% | 594.3 ± 1.1% | 2.298 | 2.337 | 14.208 | 1.814 | 10.568 |
| string: http/json-1m | 1190272 | 2554.0 ± 0.3% | 876.3 ± 0.2% | 2243.6 ± 0.5% | 390.1 ± 0.6% | 1048.5 ± 4.4% | 439.4 ± 2.0% | 2.915 | 1.138 | 6.547 | 2.436 | 5.812 |
| string: http/js-1m | 1144362 | 2279.6 ± 0.5% | 1027.5 ± 0.4% | 1633.9 ± 0.4% | 321.2 ± 0.8% | 1513.4 ± 0.4% | 415.6 ± 1.2% | 2.219 | 1.395 | 7.097 | 1.506 | 5.486 |
| string: http/css-1m | 1097820 | 2663.3 ± 0.5% | 1676.3 ± 0.4% | 2213.1 ± 0.4% | 406.7 ± 0.9% | 1910.7 ± 0.5% | 484.2 ± 1.0% | 1.589 | 1.203 | 6.549 | 1.394 | 5.501 |
| string: dickens as Cyrillic and CJK | 1883069 | 3073.1 ± 0.1% | 1681.9 ± 0.3% | 889.1 ± 0.3% | 350.8 ± 0.3% | 665.3 ± 0.7% | 155.9 ± 3.2% | 1.827 | 3.457 | 8.761 | 4.619 | 19.709 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.0 ± 0.3% | 978.1 ± 0.3% | 1187.6 ± 0.3% | 213.8 ± 0.3% | 470.7 ± 0.8% | 248.9 ± 4.8% | 1.359 | 1.119 | 6.215 | 2.823 | 5.339 |
| hex: silesia/dickens | 524290 | 11989.2 ± 0.1% | 3612.2 ± 1.2% | 3286.1 ± 0.7% | 507.6 ± 0.9% | 6095.8 ± 1.9% | 776.1 ± 4.5% | 3.319 | 3.648 | 23.617 | 1.967 | 15.448 |
| hex: silesia/mozilla | 524290 | 12012.0 ± 0.1% | 3615.2 ± 0.2% | 3292.1 ± 0.3% | 452.3 ± 0.9% | 6093.0 ± 1.9% | 776.6 ± 0.4% | 3.323 | 3.649 | 26.556 | 1.971 | 15.468 |
| hex: silesia/mr | 524290 | 11977.3 ± 0.2% | 3615.7 ± 0.1% | 3280.9 ± 0.2% | 579.8 ± 1.4% | 6050.0 ± 1.1% | 778.3 ± 0.6% | 3.313 | 3.651 | 20.659 | 1.980 | 15.388 |
| hex: silesia/nci | 524290 | 11973.6 ± 0.2% | 3616.1 ± 0.5% | 3293.7 ± 0.2% | 629.2 ± 1.9% | 6065.0 ± 1.6% | 778.6 ± 0.5% | 3.311 | 3.635 | 19.031 | 1.974 | 15.379 |
| hex: silesia/ooffice | 524290 | 11981.1 ± 0.3% | 3610.1 ± 0.3% | 3284.5 ± 0.2% | 405.8 ± 0.7% | 6059.1 ± 1.1% | 778.0 ± 0.2% | 3.319 | 3.648 | 29.522 | 1.977 | 15.400 |
| hex: silesia/osdb | 524290 | 11969.6 ± 0.2% | 3611.2 ± 0.2% | 3290.6 ± 0.2% | 490.0 ± 1.8% | 6033.9 ± 0.9% | 778.5 ± 0.4% | 3.315 | 3.638 | 24.428 | 1.984 | 15.375 |
| hex: silesia/reymont | 524290 | 11990.3 ± 0.2% | 3616.5 ± 0.2% | 3278.7 ± 0.2% | 523.1 ± 2.2% | 6059.9 ± 1.3% | 777.8 ± 0.6% | 3.315 | 3.657 | 22.923 | 1.979 | 15.416 |
| hex: silesia/samba | 524290 | 11976.9 ± 0.1% | 3614.0 ± 0.3% | 3290.6 ± 0.2% | 411.8 ± 1.1% | 6079.2 ± 1.5% | 779.5 ± 0.3% | 3.314 | 3.640 | 29.086 | 1.970 | 15.366 |
| hex: silesia/sao | 524290 | 11952.6 ± 0.1% | 3616.8 ± 0.2% | 3289.2 ± 0.2% | 347.0 ± 1.5% | 6070.3 ± 1.2% | 778.1 ± 0.8% | 3.305 | 3.634 | 34.445 | 1.969 | 15.362 |
| hex: silesia/webster | 524290 | 11991.7 ± 2.1% | 3615.9 ± 0.2% | 3289.4 ± 0.3% | 479.3 ± 2.4% | 6147.3 ± 1.3% | 778.8 ± 0.7% | 3.316 | 3.646 | 25.018 | 1.951 | 15.398 |
| hex: silesia/x-ray | 524290 | 11974.3 ± 0.2% | 3615.0 ± 0.3% | 3282.5 ± 0.3% | 484.8 ± 0.2% | 6059.6 ± 2.7% | 779.6 ± 0.4% | 3.312 | 3.648 | 24.699 | 1.976 | 15.360 |
| hex: silesia/xml | 524290 | 11943.5 ± 0.6% | 3617.2 ± 0.3% | 3293.2 ± 0.3% | 533.8 ± 0.9% | 6061.2 ± 0.3% | 779.7 ± 0.2% | 3.302 | 3.627 | 22.373 | 1.970 | 15.318 |
| hex: canterbury/alice29.txt | 304180 | 12013.0 ± 0.4% | 3638.2 ± 0.0% | 3349.6 ± 0.2% | 525.0 ± 0.1% | 6091.2 ± 0.6% | 780.0 ± 0.6% | 3.302 | 3.586 | 22.880 | 1.972 | 15.402 |
| hex: canterbury/asyoulik.txt | 250360 | 11999.0 ± 0.1% | 3635.5 ± 0.1% | 3363.3 ± 0.6% | 515.6 ± 0.5% | 6171.8 ± 1.4% | 778.7 ± 0.5% | 3.301 | 3.568 | 23.270 | 1.944 | 15.409 |
| hex: canterbury/cp.html | 49208 | 11925.9 ± 0.1% | 3637.7 ± 0.1% | 3277.6 ± 0.1% | 482.3 ± 0.7% | 6272.3 ± 0.3% | 759.5 ± 0.9% | 3.278 | 3.639 | 24.728 | 1.901 | 15.703 |
| hex: canterbury/fields.c | 22302 | 11784.3 ± 0.0% | 3627.4 ± 0.5% | 3389.0 ± 0.0% | 510.5 ± 0.3% | 6259.6 ± 0.4% | 755.7 ± 2.2% | 3.249 | 3.477 | 23.084 | 1.883 | 15.595 |
| hex: canterbury/grammar.lsp | 7444 | 11327.7 ± 0.1% | 3600.6 ± 0.4% | 3354.0 ± 0.7% | 554.7 ± 3.1% | 6162.4 ± 0.4% | 702.4 ± 1.7% | 3.146 | 3.377 | 20.422 | 1.838 | 16.126 |
| hex: canterbury/kennedy.xls | 524290 | 12010.9 ± 0.1% | 3613.3 ± 0.2% | 3283.5 ± 0.3% | 656.9 ± 5.9% | 6123.6 ± 1.0% | 759.3 ± 8.7% | 3.324 | 3.658 | 18.284 | 1.961 | 15.819 |
| hex: canterbury/lcet10.txt | 524290 | 12008.2 ± 0.1% | 3611.1 ± 0.3% | 3287.7 ± 0.1% | 511.5 ± 1.1% | 6104.4 ± 1.2% | 769.9 ± 2.6% | 3.325 | 3.653 | 23.478 | 1.967 | 15.598 |
| hex: canterbury/plrabn12.txt | 524290 | 11999.3 ± 0.1% | 3615.4 ± 0.2% | 3290.2 ± 0.2% | 503.5 ± 0.8% | 6085.2 ± 1.1% | 762.8 ± 2.0% | 3.319 | 3.647 | 23.832 | 1.972 | 15.731 |
| hex: canterbury/ptt5 | 524290 | 11983.7 ± 0.1% | 3613.1 ± 0.3% | 3281.0 ± 0.4% | 556.5 ± 0.3% | 6090.5 ± 1.7% | 773.4 ± 3.7% | 3.317 | 3.653 | 21.535 | 1.968 | 15.494 |
| hex: canterbury/sum | 76482 | 11916.9 ± 0.1% | 3632.8 ± 0.1% | 3358.0 ± 0.4% | 506.6 ± 1.3% | 6171.0 ± 0.6% | 770.6 ± 1.4% | 3.280 | 3.549 | 23.526 | 1.931 | 15.465 |
| hex: canterbury/xargs.1 | 8456 | 11351.0 ± 0.1% | 3602.0 ± 0.1% | 3349.2 ± 0.4% | 486.5 ± 1.8% | 6153.2 ± 0.4% | 734.9 ± 2.1% | 3.151 | 3.389 | 23.332 | 1.845 | 15.445 |
| hex: canterbury-large/E.coli | 524290 | 11929.6 ± 0.2% | 3611.4 ± 0.7% | 3272.4 ± 0.8% | 688.0 ± 0.1% | 6024.2 ± 1.1% | 769.8 ± 6.1% | 3.303 | 3.646 | 17.339 | 1.980 | 15.498 |
| hex: canterbury-large/bible.txt | 524290 | 12001.9 ± 0.2% | 3615.4 ± 0.3% | 3295.4 ± 0.2% | 522.0 ± 2.1% | 6078.2 ± 1.4% | 772.3 ± 2.6% | 3.320 | 3.642 | 22.993 | 1.975 | 15.540 |
| hex: canterbury-large/world192.txt | 524290 | 12013.0 ± 0.2% | 3612.3 ± 0.6% | 3291.1 ± 0.3% | 505.9 ± 2.1% | 6098.3 ± 0.9% | 770.0 ± 1.3% | 3.326 | 3.650 | 23.745 | 1.970 | 15.601 |
| hex: http/html-1kx1024 | 2099200 | 8730.9 ± 6.4% | 3459.0 ± 0.2% | 2815.0 ± 0.7% | 475.4 ± 0.5% | 5022.0 ± 1.1% | 610.0 ± 1.9% | 2.524 | 3.102 | 18.366 | 1.739 | 14.313 |
| hex: http/html-16kx64 | 2097280 | 11743.4 ± 0.1% | 3610.0 ± 0.1% | 3249.3 ± 0.3% | 479.6 ± 1.4% | 6004.4 ± 1.0% | 728.0 ± 3.8% | 3.253 | 3.614 | 24.485 | 1.956 | 16.131 |
| hex: http/html-1m | 524290 | 12002.3 ± 0.1% | 3609.0 ± 0.2% | 3290.0 ± 0.9% | 493.9 ± 1.8% | 6110.8 ± 1.1% | 775.1 ± 3.1% | 3.326 | 3.648 | 24.299 | 1.964 | 15.484 |
| hex: http/json-1kx1024 | 2099200 | 8729.3 ± 4.8% | 3459.7 ± 0.1% | 2816.7 ± 0.9% | 576.1 ± 1.0% | 5034.2 ± 1.0% | 629.7 ± 3.4% | 2.523 | 3.099 | 15.151 | 1.734 | 13.863 |
| hex: http/json-16kx64 | 2097280 | 11746.2 ± 0.3% | 3608.9 ± 0.2% | 3247.6 ± 0.3% | 574.6 ± 1.4% | 6010.2 ± 3.1% | 743.9 ± 6.8% | 3.255 | 3.617 | 20.443 | 1.954 | 15.790 |
| hex: http/json-1m | 524290 | 11985.6 ± 0.2% | 3612.3 ± 0.1% | 3289.3 ± 0.1% | 596.9 ± 2.7% | 6094.5 ± 0.9% | 768.2 ± 2.7% | 3.318 | 3.644 | 20.079 | 1.967 | 15.602 |
| hex: http/js-1kx1024 | 2099200 | 9042.6 ± 5.3% | 3455.4 ± 0.2% | 2812.8 ± 0.5% | 480.9 ± 0.6% | 5021.8 ± 2.2% | 609.7 ± 4.4% | 2.617 | 3.215 | 18.803 | 1.801 | 14.830 |
| hex: http/js-16kx64 | 2097280 | 11751.6 ± 0.2% | 3610.8 ± 0.2% | 3262.5 ± 0.2% | 482.7 ± 1.9% | 6007.4 ± 0.8% | 736.7 ± 2.0% | 3.255 | 3.602 | 24.345 | 1.956 | 15.952 |
| hex: http/js-1m | 524290 | 11971.4 ± 0.3% | 3617.8 ± 0.3% | 3286.5 ± 0.2% | 505.6 ± 1.1% | 6047.7 ± 0.2% | 778.6 ± 3.4% | 3.309 | 3.643 | 23.678 | 1.980 | 15.376 |
| hex: http/css-1kx1024 | 2099200 | 8707.2 ± 5.4% | 3461.8 ± 0.1% | 2824.6 ± 0.6% | 488.8 ± 0.4% | 5050.1 ± 1.3% | 620.8 ± 5.1% | 2.515 | 3.083 | 17.812 | 1.724 | 14.027 |
| hex: http/css-16kx64 | 2097280 | 11753.3 ± 0.1% | 3609.6 ± 0.3% | 3246.4 ± 0.2% | 496.2 ± 0.8% | 6013.8 ± 0.9% | 745.7 ± 3.8% | 3.256 | 3.620 | 23.686 | 1.954 | 15.762 |
| hex: http/css-1m | 524290 | 11997.7 ± 0.1% | 3616.2 ± 0.8% | 3288.3 ± 1.5% | 498.5 ± 2.1% | 6110.2 ± 0.7% | 767.6 ± 2.6% | 3.318 | 3.649 | 24.070 | 1.964 | 15.630 |
| hex: shuffled/dickens-1m | 524290 | 12011.7 ± 0.1% | 3611.8 ± 0.2% | 3286.5 ± 0.3% | 511.7 ± 0.5% | 6150.7 ± 1.1% | 777.4 ± 1.5% | 3.326 | 3.655 | 23.475 | 1.953 | 15.451 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1341.5 ± 0.6% | 1242.0 ± 0.1% | 1029.8 ± 0.5% | 407.6 ± 0.5% | 446.6 ± 0.3% | 414.2 ± 0.2% | 1.080 | 1.303 | 3.292 | 3.003 | 3.239 |
| qlog records, JSON text sequence | 1467503 | 1041.5 ± 0.2% | 1050.1 ± 0.5% | 773.8 ± 2.3% | 376.7 ± 1.4% | 476.2 ± 1.6% | 277.2 ± 0.7% | 0.992 | 1.346 | 2.765 | 2.187 | 3.757 |
| string: silesia/dickens | 172528 | 6917.8 ± 0.4% | 2810.6 ± 0.2% | 2927.3 ± 0.5% | 428.7 ± 0.4% | 1594.2 ± 0.4% | 1005.9 ± 0.2% | 2.461 | 2.363 | 16.135 | 4.339 | 6.877 |
| string: silesia/nci | 1075110 | 7311.3 ± 0.3% | 3403.8 ± 0.3% | 3090.4 ± 0.6% | 813.7 ± 1.3% | 1861.3 ± 0.3% | 1105.6 ± 0.3% | 2.148 | 2.366 | 8.985 | 3.928 | 6.613 |
| string: silesia/reymont | 1075159 | 3312.9 ± 1.0% | 1971.1 ± 1.4% | 2058.4 ± 0.4% | 449.3 ± 0.5% | 1495.4 ± 1.6% | 949.7 ± 0.2% | 1.681 | 1.609 | 7.374 | 2.215 | 3.488 |
| string: silesia/samba | 97582 | 4210.6 ± 0.5% | 2110.0 ± 1.1% | 3440.9 ± 0.6% | 353.8 ± 0.9% | 1485.5 ± 0.2% | 1054.4 ± 0.3% | 1.996 | 1.224 | 11.902 | 2.835 | 3.993 |
| string: silesia/webster | 1098490 | 4072.8 ± 0.5% | 1867.2 ± 0.4% | 2051.7 ± 0.2% | 440.5 ± 0.8% | 1398.5 ± 0.2% | 642.9 ± 0.9% | 2.181 | 1.985 | 9.245 | 2.912 | 6.335 |
| string: silesia/xml | 1090118 | 6131.8 ± 0.4% | 2848.8 ± 0.2% | 2645.8 ± 0.4% | 607.3 ± 0.5% | 1755.6 ± 0.1% | 919.3 ± 0.3% | 2.152 | 2.318 | 10.097 | 3.493 | 6.670 |
| string: canterbury/alice29.txt | 159425 | 6474.2 ± 1.0% | 2198.5 ± 0.6% | 2759.9 ± 0.9% | 404.9 ± 1.0% | 1471.5 ± 0.1% | 956.5 ± 0.3% | 2.945 | 2.346 | 15.990 | 4.400 | 6.769 |
| string: canterbury/asyoulik.txt | 132198 | 5671.6 ± 1.1% | 1708.8 ± 0.4% | 2373.5 ± 0.7% | 401.7 ± 1.0% | 1331.7 ± 1.3% | 883.8 ± 0.1% | 3.319 | 2.389 | 14.121 | 4.259 | 6.417 |
| string: canterbury/lcet10.txt | 441884 | 6268.8 ± 0.2% | 2566.2 ± 0.5% | 2499.3 ± 2.2% | 467.8 ± 0.9% | 1554.0 ± 0.2% | 984.3 ± 0.3% | 2.443 | 2.508 | 13.399 | 4.034 | 6.369 |
| string: canterbury/plrabn12.txt | 503330 | 5732.2 ± 0.3% | 2054.4 ± 0.2% | 2067.4 ± 0.9% | 424.6 ± 0.9% | 1390.7 ± 0.1% | 929.5 ± 0.2% | 2.790 | 2.773 | 13.501 | 4.122 | 6.167 |
| string: canterbury-large/E.coli | 1048578 | 19272.9 ± 1.9% | 9670.1 ± 2.7% | 3786.8 ± 0.2% | 1475.4 ± 1.2% | 2364.3 ± 0.2% | 1189.1 ± 0.3% | 1.993 | 5.089 | 13.063 | 8.152 | 16.208 |
| string: canterbury-large/bible.txt | 1055886 | 6792.4 ± 0.2% | 4123.5 ± 2.3% | 3046.6 ± 3.4% | 503.5 ± 1.6% | 1980.6 ± 2.2% | 1117.7 ± 2.5% | 1.647 | 2.229 | 13.490 | 3.429 | 6.077 |
| string: canterbury-large/world192.txt | 1103121 | 4057.3 ± 0.4% | 1651.4 ± 0.8% | 1998.8 ± 1.2% | 449.8 ± 0.6% | 1369.7 ± 0.1% | 906.4 ± 0.4% | 2.457 | 2.030 | 9.020 | 2.962 | 4.476 |
| string: http/html-1m | 1058582 | 6769.7 ± 0.6% | 3940.3 ± 0.2% | 3040.1 ± 0.1% | 502.4 ± 1.3% | 1931.5 ± 0.4% | 805.1 ± 0.2% | 1.718 | 2.227 | 13.475 | 3.505 | 8.408 |
| string: http/json-1m | 1190272 | 3163.8 ± 0.3% | 1353.0 ± 0.4% | 1554.1 ± 0.3% | 443.9 ± 0.6% | 1069.6 ± 0.3% | 764.2 ± 0.3% | 2.338 | 2.036 | 7.128 | 2.958 | 4.140 |
| string: http/js-1m | 1144362 | 2764.3 ± 0.8% | 1174.7 ± 0.3% | 1620.0 ± 0.6% | 368.6 ± 0.3% | 1107.2 ± 0.5% | 755.3 ± 0.3% | 2.353 | 1.706 | 7.500 | 2.497 | 3.660 |
| string: http/css-1m | 1097820 | 4003.9 ± 0.9% | 1488.4 ± 0.5% | 2150.5 ± 0.7% | 492.2 ± 0.7% | 1378.0 ± 0.7% | 893.0 ± 0.9% | 2.690 | 1.862 | 8.134 | 2.906 | 4.484 |
| string: dickens as Cyrillic and CJK | 1883069 | 3069.5 ± 0.3% | 2331.5 ± 0.8% | 521.2 ± 0.3% | 307.5 ± 0.9% | 563.8 ± 0.3% | 334.4 ± 0.2% | 1.317 | 5.889 | 9.984 | 5.445 | 9.179 |
| hex: silesia/dickens | 524290 | 15676.7 ± 0.1% | 1464.3 ± 0.2% | 1081.9 ± 0.3% | 500.1 ± 0.9% | 987.5 ± 0.2% | 731.6 ± 0.3% | 10.706 | 14.490 | 31.348 | 15.876 | 21.428 |
| hex: silesia/mozilla | 524290 | 15548.2 ± 0.3% | 1472.7 ± 0.3% | 1089.3 ± 0.1% | 440.1 ± 0.4% | 990.9 ± 0.2% | 732.4 ± 0.2% | 10.558 | 14.273 | 35.331 | 15.690 | 21.229 |
| hex: silesia/mr | 524290 | 15625.2 ± 0.4% | 1480.0 ± 0.2% | 1092.6 ± 0.5% | 555.3 ± 0.9% | 994.7 ± 0.4% | 733.5 ± 0.2% | 10.557 | 14.301 | 28.136 | 15.708 | 21.303 |
| hex: silesia/nci | 524290 | 15603.9 ± 0.7% | 1472.0 ± 0.5% | 1088.7 ± 0.3% | 636.2 ± 4.6% | 988.6 ± 0.6% | 732.2 ± 0.4% | 10.600 | 14.333 | 24.528 | 15.784 | 21.310 |
| hex: silesia/ooffice | 524290 | 15637.2 ± 0.3% | 1464.2 ± 0.1% | 1083.0 ± 0.4% | 388.7 ± 0.2% | 989.2 ± 0.5% | 731.9 ± 0.4% | 10.680 | 14.439 | 40.227 | 15.809 | 21.366 |
| hex: silesia/osdb | 524290 | 15628.9 ± 0.2% | 1470.3 ± 0.1% | 1085.6 ± 0.4% | 474.8 ± 1.4% | 991.6 ± 0.4% | 732.8 ± 0.2% | 10.630 | 14.396 | 32.915 | 15.761 | 21.328 |
| hex: silesia/reymont | 524290 | 15649.9 ± 0.5% | 1460.0 ± 0.3% | 1083.9 ± 0.5% | 512.7 ± 0.8% | 986.9 ± 0.4% | 731.9 ± 0.6% | 10.719 | 14.439 | 30.523 | 15.858 | 21.382 |
| hex: silesia/samba | 524290 | 15687.4 ± 0.1% | 1466.3 ± 0.1% | 1084.5 ± 0.2% | 402.3 ± 0.3% | 989.6 ± 0.2% | 731.8 ± 0.7% | 10.699 | 14.465 | 38.990 | 15.852 | 21.436 |
| hex: silesia/sao | 524290 | 15673.3 ± 0.2% | 1459.9 ± 0.8% | 1081.8 ± 0.5% | 332.6 ± 0.5% | 988.8 ± 0.4% | 732.2 ± 0.4% | 10.736 | 14.489 | 47.127 | 15.851 | 21.407 |
| hex: silesia/webster | 524290 | 15701.6 ± 0.3% | 1465.5 ± 0.4% | 1084.4 ± 0.4% | 475.1 ± 0.5% | 986.9 ± 0.7% | 731.9 ± 0.3% | 10.714 | 14.480 | 33.052 | 15.910 | 21.454 |
| hex: silesia/x-ray | 524290 | 15636.6 ± 0.2% | 1476.8 ± 0.5% | 1090.1 ± 0.1% | 444.5 ± 1.7% | 995.1 ± 0.3% | 732.3 ± 0.3% | 10.588 | 14.344 | 35.182 | 15.714 | 21.352 |
| hex: silesia/xml | 524290 | 15630.1 ± 0.2% | 1467.1 ± 0.3% | 1085.3 ± 0.3% | 616.4 ± 0.8% | 990.5 ± 0.3% | 732.2 ± 0.3% | 10.654 | 14.401 | 25.358 | 15.781 | 21.347 |
| hex: canterbury/alice29.txt | 304180 | 15707.4 ± 0.2% | 1475.0 ± 0.2% | 1089.9 ± 0.3% | 503.8 ± 1.1% | 995.7 ± 0.4% | 733.8 ± 0.2% | 10.649 | 14.411 | 31.178 | 15.776 | 21.405 |
| hex: canterbury/asyoulik.txt | 250360 | 15720.3 ± 0.1% | 1476.8 ± 0.7% | 1094.8 ± 0.2% | 500.1 ± 1.3% | 994.7 ± 0.3% | 737.8 ± 0.2% | 10.645 | 14.359 | 31.433 | 15.805 | 21.306 |
| hex: canterbury/cp.html | 49208 | 15659.4 ± 0.1% | 1479.6 ± 1.0% | 1099.0 ± 0.2% | 530.9 ± 2.8% | 1004.8 ± 0.6% | 742.0 ± 0.2% | 10.583 | 14.248 | 29.497 | 15.585 | 21.103 |
| hex: canterbury/fields.c | 22302 | 15514.0 ± 0.2% | 1412.7 ± 0.4% | 1067.2 ± 0.3% | 619.2 ± 9.2% | 986.4 ± 0.2% | 736.5 ± 0.5% | 10.982 | 14.537 | 25.055 | 15.728 | 21.064 |
| hex: canterbury/grammar.lsp | 7444 | 15153.5 ± 0.0% | 1507.7 ± 0.2% | 1092.5 ± 0.3% | 667.6 ± 3.2% | 998.9 ± 0.1% | 725.2 ± 0.2% | 10.051 | 13.870 | 22.697 | 15.170 | 20.896 |
| hex: canterbury/kennedy.xls | 524290 | 15587.6 ± 0.2% | 1472.7 ± 0.3% | 1087.9 ± 0.4% | 653.6 ± 2.0% | 991.4 ± 0.2% | 731.0 ± 0.3% | 10.584 | 14.328 | 23.849 | 15.723 | 21.323 |
| hex: canterbury/lcet10.txt | 524290 | 15644.2 ± 0.2% | 1461.2 ± 0.3% | 1082.9 ± 0.2% | 502.3 ± 1.0% | 987.8 ± 0.2% | 731.4 ± 0.7% | 10.707 | 14.446 | 31.144 | 15.838 | 21.390 |
| hex: canterbury/plrabn12.txt | 524290 | 15609.9 ± 0.3% | 1461.6 ± 0.1% | 1083.0 ± 0.1% | 492.0 ± 0.3% | 988.4 ± 0.3% | 732.5 ± 0.3% | 10.680 | 14.414 | 31.730 | 15.793 | 21.309 |
| hex: canterbury/ptt5 | 524290 | 15612.7 ± 0.2% | 1479.2 ± 0.2% | 1090.9 ± 0.2% | 557.7 ± 0.7% | 991.8 ± 0.2% | 732.4 ± 0.3% | 10.555 | 14.311 | 27.997 | 15.742 | 21.318 |
| hex: canterbury/sum | 76482 | 15673.7 ± 0.0% | 1494.6 ± 0.2% | 1103.9 ± 0.1% | 594.2 ± 2.6% | 997.8 ± 0.1% | 743.6 ± 0.2% | 10.487 | 14.199 | 26.378 | 15.708 | 21.077 |
| hex: canterbury/xargs.1 | 8456 | 15211.5 ± 0.1% | 1491.8 ± 2.5% | 1098.7 ± 0.4% | 660.2 ± 5.5% | 974.7 ± 0.2% | 727.6 ± 1.1% | 10.197 | 13.845 | 23.040 | 15.607 | 20.905 |
| hex: canterbury-large/E.coli | 524290 | 15482.9 ± 0.2% | 1470.0 ± 0.4% | 1088.6 ± 0.6% | 671.0 ± 0.3% | 991.3 ± 0.4% | 733.0 ± 0.2% | 10.533 | 14.222 | 23.073 | 15.619 | 21.122 |
| hex: canterbury-large/bible.txt | 524290 | 15622.5 ± 0.9% | 1464.1 ± 0.3% | 1083.3 ± 0.5% | 512.8 ± 0.4% | 988.4 ± 0.1% | 730.0 ± 0.4% | 10.671 | 14.421 | 30.465 | 15.806 | 21.401 |
| hex: canterbury-large/world192.txt | 524290 | 15649.2 ± 0.2% | 1467.6 ± 0.1% | 1083.4 ± 0.2% | 502.4 ± 0.4% | 986.6 ± 0.5% | 730.5 ± 0.3% | 10.663 | 14.444 | 31.150 | 15.862 | 21.423 |
| hex: http/html-1kx1024 | 2099200 | 14128.5 ± 0.3% | 1453.6 ± 0.2% | 1061.8 ± 0.2% | 501.8 ± 0.3% | 982.1 ± 0.1% | 691.6 ± 0.4% | 9.720 | 13.307 | 28.154 | 14.386 | 20.429 |
| hex: http/html-16kx64 | 2097280 | 15319.5 ± 0.4% | 1442.1 ± 0.2% | 1073.9 ± 0.1% | 507.1 ± 0.2% | 994.9 ± 0.2% | 733.4 ± 0.2% | 10.623 | 14.265 | 30.212 | 15.398 | 20.889 |
| hex: http/html-1m | 524290 | 15674.4 ± 0.3% | 1467.3 ± 0.2% | 1084.6 ± 0.4% | 499.6 ± 0.8% | 990.2 ± 0.4% | 730.8 ± 0.1% | 10.682 | 14.452 | 31.373 | 15.830 | 21.450 |
| hex: http/json-1kx1024 | 2099200 | 14123.2 ± 0.2% | 1462.2 ± 0.2% | 1065.1 ± 0.2% | 609.4 ± 0.4% | 985.6 ± 0.1% | 691.8 ± 0.2% | 9.659 | 13.260 | 23.175 | 14.330 | 20.414 |
| hex: http/json-16kx64 | 2097280 | 15298.0 ± 2.4% | 1443.4 ± 0.4% | 1073.7 ± 0.6% | 616.1 ± 0.9% | 994.6 ± 0.5% | 733.9 ± 0.2% | 10.599 | 14.247 | 24.831 | 15.381 | 20.845 |
| hex: http/json-1m | 524290 | 15675.9 ± 0.3% | 1474.2 ± 0.1% | 1089.9 ± 0.2% | 632.1 ± 0.6% | 991.5 ± 0.3% | 732.2 ± 0.8% | 10.633 | 14.383 | 24.798 | 15.811 | 21.409 |
| hex: http/js-1kx1024 | 2099200 | 14098.5 ± 0.7% | 1456.0 ± 0.4% | 1062.1 ± 0.4% | 498.4 ± 0.4% | 983.3 ± 0.2% | 692.1 ± 0.3% | 9.683 | 13.274 | 28.290 | 14.338 | 20.370 |
| hex: http/js-16kx64 | 2097280 | 15293.6 ± 0.5% | 1444.3 ± 0.2% | 1074.2 ± 0.2% | 506.1 ± 0.2% | 996.2 ± 0.2% | 733.3 ± 0.3% | 10.589 | 14.237 | 30.218 | 15.353 | 20.855 |
| hex: http/js-1m | 524290 | 15594.5 ± 0.1% | 1463.7 ± 0.5% | 1083.7 ± 0.4% | 511.8 ± 0.4% | 989.2 ± 0.3% | 732.3 ± 0.6% | 10.655 | 14.390 | 30.468 | 15.764 | 21.296 |
| hex: http/css-1kx1024 | 2099200 | 14123.5 ± 0.2% | 1454.6 ± 0.1% | 1062.7 ± 0.2% | 531.4 ± 0.6% | 982.6 ± 0.2% | 692.2 ± 0.1% | 9.710 | 13.291 | 26.576 | 14.374 | 20.403 |
| hex: http/css-16kx64 | 2097280 | 15328.5 ± 2.3% | 1442.7 ± 0.3% | 1074.0 ± 0.2% | 541.9 ± 0.2% | 999.1 ± 0.1% | 732.5 ± 0.4% | 10.625 | 14.272 | 28.288 | 15.342 | 20.926 |
| hex: http/css-1m | 524290 | 15629.3 ± 0.2% | 1467.9 ± 0.3% | 1083.9 ± 0.3% | 529.7 ± 0.4% | 991.0 ± 0.5% | 730.9 ± 0.3% | 10.648 | 14.420 | 29.507 | 15.771 | 21.383 |
| hex: shuffled/dickens-1m | 524290 | 15681.8 ± 0.3% | 1465.5 ± 0.3% | 1084.2 ± 0.4% | 502.4 ± 1.2% | 990.4 ± 0.6% | 732.6 ± 0.3% | 10.700 | 14.464 | 31.212 | 15.833 | 21.406 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.924 of yyjson.
