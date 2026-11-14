# bench-json

| Field | Value |
|---|---|
| Commit | d3df675 |
| Runner label | ubuntu-24.04-arm |
| Image version | 20261111.182.1 |
| CPU model | Neoverse-N2 |
| Virtual CPUs | 4 |
| Kernel | 7.0.0-1017-azure |
| Zig version | 0.16.0 |
| Run URL | https://github.com/c4milo/stdx/actions/runs/43625788040 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.6 ± 0.5% | 0.523 | 0.965 | 0.997 | 0.998 | 0.460 | 1.003 | 1.007 | 0.387 | 0.831 | 0.899 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 846.0 ± 1.3% | 0.821 | 1.001 | 0.998 | 0.999 | 0.446 | 0.993 | 1.023 | 0.401 | 0.923 | 0.986 | 0.125 |
| string: silesia/dickens | 172528 | 5046.8 ± 0.3% | 0.033 | 0.782 | 1.002 | 1.004 | 0.196 | 1.020 | 1.006 | 0.196 | 1.003 | 1.003 | 0.032 |
| string: silesia/nci | 1075110 | 4289.1 ± 0.4% | 0.039 | 0.802 | 1.003 | 1.003 | 0.280 | 1.007 | 0.999 | 0.279 | 1.003 | 1.004 | 0.038 |
| string: silesia/reymont | 1075159 | 2929.0 ± 2.2% | 0.057 | 0.819 | 1.006 | 1.007 | 0.360 | 1.006 | 1.010 | 0.360 | 1.019 | 1.017 | 0.056 |
| string: silesia/samba | 97582 | 3498.3 ± 0.3% | 0.040 | 0.859 | 1.003 | 1.004 | 0.068 | 0.777 | 1.010 | 0.072 | 1.001 | 1.004 | 0.039 |
| string: silesia/webster | 1098490 | 3650.4 ± 0.8% | 0.044 | 0.844 | 1.000 | 1.004 | 0.203 | 1.016 | 1.013 | 0.203 | 1.006 | 1.004 | 0.044 |
| string: silesia/xml | 1090118 | 4786.3 ± 0.4% | 0.035 | 0.808 | 1.003 | 1.005 | 0.222 | 0.976 | 1.003 | 0.224 | 1.002 | 1.004 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4304.2 ± 0.5% | 0.038 | 0.753 | 1.005 | 1.008 | 0.172 | 1.032 | 1.021 | 0.171 | 1.012 | 1.013 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3456.4 ± 0.6% | 0.046 | 0.746 | 1.005 | 1.008 | 0.176 | 1.005 | 0.967 | 0.176 | 1.012 | 1.014 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5116.0 ± 0.3% | 0.032 | 0.812 | 1.003 | 1.003 | 0.195 | 1.021 | 1.007 | 0.195 | 1.002 | 1.002 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4135.2 ± 0.4% | 0.039 | 0.821 | 1.000 | 1.000 | 0.198 | 1.002 | 0.990 | 0.197 | 1.001 | 1.000 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 18752.9 ± 0.7% | 0.079 | 1.013 | 1.008 | 1.010 | 0.488 | 1.010 | 1.008 | 0.489 | 0.634 | 0.635 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6683.8 ± 1.2% | 0.026 | 0.800 | 1.002 | 1.008 | 0.433 | 1.025 | 1.043 | 0.432 | 1.031 | 1.035 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3373.7 ± 0.8% | 0.048 | 0.849 | 1.003 | 1.005 | 0.198 | 1.018 | 1.008 | 0.198 | 1.006 | 1.004 | 0.047 |
| string: http/html-1m | 1058582 | 6048.3 ± 1.0% | 0.028 | 0.781 | 1.015 | 1.045 | 0.389 | 1.041 | 1.055 | 0.389 | 1.031 | 1.049 | 0.028 |
| string: http/json-1m | 1190272 | 2539.7 ± 0.3% | 0.056 | 0.953 | 1.007 | 1.010 | 0.111 | 1.005 | 0.472 | 0.111 | 1.008 | 1.008 | 0.055 |
| string: http/js-1m | 1144362 | 2277.2 ± 0.4% | 0.066 | 0.892 | 1.004 | 1.004 | 0.175 | 1.055 | 1.048 | 0.175 | 1.004 | 1.007 | 0.066 |
| string: http/css-1m | 1097820 | 2624.0 ± 0.4% | 0.061 | 0.780 | 1.008 | 1.013 | 0.242 | 1.015 | 1.020 | 0.241 | 1.011 | 1.013 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3065.6 ± 0.4% | 0.044 | 0.125 | 1.007 | 1.007 | 0.337 | 1.001 | 1.009 | 0.337 | 1.004 | 1.006 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.2 ± 1.7% | 0.082 | 1.003 | 1.002 | 1.002 | 0.076 | 0.637 | 1.005 | 0.081 | 1.002 | 1.002 | 0.081 |
| hex: silesia/dickens | 524290 | 17937.4 ± 1.4% | 0.083 | 0.994 | 0.995 | 0.990 | 0.528 | 0.991 | 0.995 | 0.528 | 0.669 | 0.670 | 0.010 |
| hex: silesia/mozilla | 524290 | 17949.3 ± 0.7% | 0.083 | 1.013 | 1.001 | 1.001 | 0.535 | 1.006 | 0.999 | 0.535 | 0.669 | 0.669 | 0.010 |
| hex: silesia/mr | 524290 | 18079.4 ± 0.6% | 0.082 | 1.003 | 1.000 | 0.999 | 0.533 | 1.007 | 1.002 | 0.531 | 0.664 | 0.664 | 0.010 |
| hex: silesia/nci | 524290 | 18335.5 ± 0.9% | 0.081 | 1.000 | 0.993 | 0.990 | 0.518 | 0.997 | 0.997 | 0.518 | 0.654 | 0.654 | 0.009 |
| hex: silesia/ooffice | 524290 | 18407.4 ± 1.4% | 0.081 | 1.007 | 1.008 | 0.994 | 0.516 | 1.003 | 0.994 | 0.517 | 0.652 | 0.652 | 0.009 |
| hex: silesia/osdb | 524290 | 18165.0 ± 0.9% | 0.082 | 1.005 | 1.008 | 1.008 | 0.531 | 1.008 | 1.009 | 0.530 | 0.659 | 0.654 | 0.010 |
| hex: silesia/reymont | 524290 | 18029.5 ± 0.4% | 0.082 | 1.012 | 1.001 | 0.999 | 0.533 | 1.001 | 1.004 | 0.532 | 0.666 | 0.666 | 0.010 |
| hex: silesia/samba | 524290 | 17951.8 ± 0.4% | 0.083 | 1.002 | 0.999 | 0.998 | 0.538 | 0.999 | 1.000 | 0.539 | 0.669 | 0.669 | 0.010 |
| hex: silesia/sao | 524290 | 18152.3 ± 0.4% | 0.082 | 1.003 | 0.997 | 0.996 | 0.537 | 0.999 | 0.999 | 0.537 | 0.662 | 0.662 | 0.010 |
| hex: silesia/webster | 524290 | 18459.0 ± 2.2% | 0.081 | 1.009 | 0.994 | 0.983 | 0.517 | 0.996 | 0.990 | 0.519 | 0.650 | 0.647 | 0.009 |
| hex: silesia/x-ray | 524290 | 17780.3 ± 1.2% | 0.083 | 1.007 | 1.009 | 1.010 | 0.537 | 1.008 | 1.015 | 0.537 | 0.675 | 0.673 | 0.010 |
| hex: silesia/xml | 524290 | 18188.3 ± 0.5% | 0.081 | 0.997 | 0.999 | 1.001 | 0.519 | 0.999 | 0.996 | 0.518 | 0.661 | 0.661 | 0.010 |
| hex: canterbury/alice29.txt | 304180 | 18939.7 ± 0.8% | 0.079 | 1.005 | 0.996 | 0.996 | 0.517 | 1.002 | 1.000 | 0.516 | 0.634 | 0.634 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19520.9 ± 0.1% | 0.077 | 1.001 | 1.002 | 1.002 | 0.513 | 1.002 | 1.002 | 0.513 | 0.615 | 0.615 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19291.0 ± 0.3% | 0.081 | 1.001 | 1.001 | 1.001 | 0.542 | 1.001 | 1.001 | 0.544 | 0.617 | 0.617 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18909.3 ± 0.4% | 0.083 | 1.000 | 1.003 | 1.004 | 0.533 | 1.003 | 1.003 | 0.539 | 0.623 | 0.623 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17461.9 ± 0.8% | 0.089 | 1.007 | 1.007 | 1.008 | 0.530 | 1.007 | 1.007 | 0.548 | 0.644 | 0.648 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18397.3 ± 1.5% | 0.080 | 1.008 | 1.009 | 0.997 | 0.512 | 0.998 | 0.992 | 0.513 | 0.648 | 0.648 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18320.7 ± 2.0% | 0.081 | 1.005 | 1.006 | 0.990 | 0.518 | 0.994 | 0.985 | 0.515 | 0.656 | 0.656 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18462.4 ± 1.7% | 0.081 | 1.008 | 0.997 | 0.998 | 0.519 | 0.998 | 0.997 | 0.521 | 0.650 | 0.650 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 17938.2 ± 1.9% | 0.083 | 1.008 | 1.008 | 1.007 | 0.541 | 1.003 | 1.010 | 0.541 | 0.670 | 0.669 | 0.010 |
| hex: canterbury/sum | 76482 | 19294.9 ± 0.5% | 0.078 | 1.002 | 1.002 | 1.002 | 0.518 | 1.002 | 1.002 | 0.520 | 0.617 | 0.617 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17802.0 ± 0.0% | 0.088 | 1.001 | 1.002 | 1.002 | 0.523 | 1.001 | 1.001 | 0.539 | 0.637 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18457.9 ± 2.2% | 0.080 | 1.006 | 0.992 | 0.985 | 0.523 | 0.986 | 0.986 | 0.526 | 0.649 | 0.649 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18580.6 ± 1.8% | 0.080 | 1.003 | 0.987 | 0.982 | 0.524 | 0.988 | 0.985 | 0.524 | 0.647 | 0.647 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 17892.3 ± 0.5% | 0.083 | 1.004 | 1.000 | 0.998 | 0.528 | 1.003 | 0.998 | 0.529 | 0.671 | 0.671 | 0.010 |
| hex: http/html-1kx1024 | 2099200 | 9225.4 ± 16.7% | 0.154 | 1.258 | 1.251 | 1.248 | 0.708 | 1.253 | 0.955 | 0.779 | 0.945 | 0.949 | 0.019 |
| hex: http/html-16kx64 | 2097280 | 17540.6 ± 1.4% | 0.086 | 1.024 | 1.021 | 1.022 | 0.584 | 1.020 | 0.984 | 0.590 | 0.671 | 0.670 | 0.010 |
| hex: http/html-1m | 524290 | 17829.4 ± 1.6% | 0.083 | 1.016 | 1.009 | 1.007 | 0.537 | 1.004 | 1.003 | 0.538 | 0.673 | 0.673 | 0.010 |
| hex: http/json-1kx1024 | 2099200 | 9391.4 ± 14.6% | 0.153 | 1.251 | 1.243 | 1.244 | 0.691 | 1.317 | 1.090 | 0.767 | 0.960 | 0.969 | 0.018 |
| hex: http/json-16kx64 | 2097280 | 17718.2 ± 1.2% | 0.085 | 1.019 | 1.017 | 1.015 | 0.577 | 1.017 | 0.979 | 0.583 | 0.664 | 0.664 | 0.010 |
| hex: http/json-1m | 524290 | 18014.6 ± 1.2% | 0.082 | 1.015 | 1.004 | 0.998 | 0.536 | 1.005 | 1.002 | 0.536 | 0.666 | 0.662 | 0.010 |
| hex: http/js-1kx1024 | 2099200 | 9126.9 ± 16.0% | 0.156 | 1.268 | 1.268 | 1.272 | 0.717 | 1.274 | 0.975 | 0.791 | 0.956 | 0.964 | 0.019 |
| hex: http/js-16kx64 | 2097280 | 17565.1 ± 0.7% | 0.085 | 1.021 | 1.023 | 1.023 | 0.582 | 1.023 | 0.982 | 0.586 | 0.669 | 0.669 | 0.010 |
| hex: http/js-1m | 524290 | 18329.2 ± 0.6% | 0.081 | 1.011 | 1.008 | 1.006 | 0.530 | 1.013 | 1.011 | 0.530 | 0.655 | 0.655 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9128.6 ± 15.6% | 0.156 | 1.275 | 1.276 | 1.284 | 0.715 | 1.282 | 0.972 | 0.794 | 0.988 | 0.994 | 0.019 |
| hex: http/css-16kx64 | 2097280 | 17625.0 ± 1.2% | 0.085 | 1.023 | 1.020 | 1.020 | 0.580 | 1.019 | 0.980 | 0.586 | 0.667 | 0.667 | 0.010 |
| hex: http/css-1m | 524290 | 18399.0 ± 1.6% | 0.081 | 0.999 | 0.998 | 0.991 | 0.521 | 0.993 | 0.992 | 0.522 | 0.653 | 0.653 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 17790.0 ± 0.8% | 0.083 | 1.002 | 1.002 | 1.002 | 0.538 | 1.004 | 1.003 | 0.539 | 0.674 | 0.674 | 0.010 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1473.9 ± 0.6% | 0.445 | 1.003 | 0.966 | 1.004 | 1.007 | 0.269 | 1.001 | 0.550 | 0.918 | 0.089 | 1.032 |
| qlog records, JSON text sequence | 1467503 | 1270.7 ± 1.6% | 0.691 | 0.977 | 1.010 | 1.012 | 1.012 | 0.264 | 1.001 | 0.502 | 0.828 | 0.106 | 1.020 |
| string: silesia/dickens | 172528 | 6887.6 ± 0.6% | 0.025 | 1.002 | 1.003 | 1.002 | 1.001 | 0.167 | 0.717 | 1.003 | 1.003 | 0.025 | 1.036 |
| string: silesia/nci | 1075110 | 7291.8 ± 0.5% | 0.023 | 1.001 | 1.004 | 1.002 | 1.003 | 0.212 | 0.565 | 1.002 | 1.002 | 0.024 | 1.005 |
| string: silesia/reymont | 1075159 | 3322.9 ± 0.9% | 0.052 | 1.001 | 0.998 | 1.000 | 1.010 | 0.392 | 0.877 | 1.007 | 1.000 | 0.052 | 1.055 |
| string: silesia/samba | 97582 | 4189.2 ± 0.2% | 0.053 | 1.003 | 1.000 | 1.006 | 1.006 | 0.125 | 0.946 | 1.005 | 1.004 | 0.054 | 1.093 |
| string: silesia/webster | 1098490 | 4049.4 ± 0.4% | 0.043 | 1.008 | 1.009 | 1.005 | 1.008 | 0.212 | 0.886 | 1.001 | 1.006 | 0.043 | 1.012 |
| string: silesia/xml | 1090118 | 6118.1 ± 0.3% | 0.029 | 1.002 | 0.996 | 1.001 | 1.002 | 0.254 | 0.776 | 0.999 | 1.001 | 0.029 | 1.021 |
| string: canterbury/alice29.txt | 159425 | 6398.5 ± 0.7% | 0.027 | 1.012 | 1.012 | 1.014 | 1.015 | 0.133 | 0.655 | 1.006 | 1.009 | 0.028 | 1.066 |
| string: canterbury/asyoulik.txt | 132198 | 5593.1 ± 1.1% | 0.030 | 1.027 | 1.031 | 1.033 | 1.035 | 0.129 | 0.595 | 1.005 | 1.015 | 0.030 | 1.054 |
| string: canterbury/lcet10.txt | 441884 | 6231.1 ± 0.6% | 0.028 | 1.004 | 1.005 | 1.006 | 1.009 | 0.185 | 0.800 | 0.999 | 1.001 | 0.028 | 1.002 |
| string: canterbury/plrabn12.txt | 503330 | 5706.7 ± 0.3% | 0.030 | 1.001 | 1.001 | 1.002 | 1.002 | 0.169 | 0.699 | 1.001 | 1.002 | 0.031 | 1.009 |
| string: canterbury-large/E.coli | 1048578 | 19137.4 ± 1.8% | 0.078 | 0.998 | 1.001 | 1.001 | 1.003 | 0.479 | 1.001 | 1.002 | 1.002 | 0.009 | 1.000 |
| string: canterbury-large/bible.txt | 1055886 | 6762.4 ± 0.7% | 0.026 | 1.001 | 1.004 | 1.003 | 1.003 | 0.496 | 0.976 | 1.002 | 1.003 | 0.026 | 1.002 |
| string: canterbury-large/world192.txt | 1103121 | 4003.5 ± 0.3% | 0.043 | 1.022 | 1.018 | 1.019 | 1.020 | 0.194 | 0.835 | 1.006 | 1.014 | 0.043 | 1.004 |
| string: http/html-1m | 1058582 | 6735.2 ± 0.6% | 0.026 | 1.006 | 0.926 | 1.007 | 1.009 | 0.405 | 0.896 | 1.003 | 1.007 | 0.026 | 1.010 |
| string: http/json-1m | 1190272 | 3151.1 ± 0.4% | 0.051 | 1.002 | 0.966 | 1.004 | 1.005 | 0.133 | 0.372 | 1.000 | 1.001 | 0.051 | 1.044 |
| string: http/js-1m | 1144362 | 2761.3 ± 0.8% | 0.060 | 0.998 | 1.007 | 1.000 | 1.005 | 0.165 | 0.839 | 0.997 | 1.004 | 0.061 | 1.014 |
| string: http/css-1m | 1097820 | 3975.0 ± 0.4% | 0.042 | 1.004 | 1.004 | 1.011 | 1.008 | 0.208 | 0.646 | 1.001 | 1.009 | 0.043 | 1.012 |
| string: dickens as Cyrillic and CJK | 1883069 | 3063.5 ± 0.3% | 0.048 | 1.000 | 0.124 | 1.001 | 1.001 | 0.321 | 1.003 | 1.000 | 1.000 | 0.048 | 1.001 |
| hex: silesia/dickens | 524290 | 15597.9 ± 0.2% | 1.002 | 0.179 | 1.004 | 1.001 | 1.002 | 1.001 | 1.003 | 1.001 | 1.002 | 0.178 | 1.005 |
| hex: silesia/mozilla | 524290 | 15642.9 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 0.999 | 0.999 | 0.997 | 0.996 | 0.178 | 1.000 |
| hex: silesia/mr | 524290 | 15568.2 ± 0.7% | 1.001 | 0.179 | 0.998 | 1.000 | 0.998 | 0.997 | 0.997 | 0.996 | 0.998 | 0.179 | 0.993 |
| hex: silesia/nci | 524290 | 15555.7 ± 0.4% | 1.001 | 0.179 | 0.994 | 0.996 | 0.993 | 0.993 | 0.992 | 0.997 | 0.999 | 0.178 | 0.993 |
| hex: silesia/ooffice | 524290 | 15587.7 ± 0.2% | 1.003 | 0.178 | 1.002 | 1.000 | 0.999 | 1.001 | 1.000 | 1.002 | 1.001 | 0.178 | 1.001 |
| hex: silesia/osdb | 524290 | 15567.1 ± 0.4% | 1.001 | 0.179 | 1.001 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 1.001 | 0.179 | 0.999 |
| hex: silesia/reymont | 524290 | 15643.0 ± 0.4% | 1.002 | 0.177 | 1.001 | 1.000 | 0.999 | 1.000 | 1.001 | 1.000 | 1.000 | 0.177 | 1.000 |
| hex: silesia/samba | 524290 | 15664.9 ± 0.6% | 1.001 | 0.177 | 1.000 | 1.000 | 1.000 | 1.000 | 0.999 | 0.998 | 0.998 | 0.178 | 0.999 |
| hex: silesia/sao | 524290 | 15616.4 ± 0.4% | 1.001 | 0.178 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 1.001 | 0.178 | 1.000 |
| hex: silesia/webster | 524290 | 15653.8 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.000 | 1.002 | 1.000 | 1.001 | 1.001 | 1.002 | 0.177 | 1.001 |
| hex: silesia/x-ray | 524290 | 15631.3 ± 0.2% | 1.001 | 0.178 | 0.999 | 1.000 | 0.999 | 1.000 | 0.999 | 0.999 | 1.000 | 0.178 | 0.999 |
| hex: silesia/xml | 524290 | 15654.8 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.001 | 0.999 | 1.000 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/alice29.txt | 304180 | 15671.7 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15706.9 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15620.1 ± 0.2% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.998 | 1.001 | 1.001 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15440.4 ± 0.0% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.994 | 1.001 | 1.002 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14942.7 ± 0.1% | 1.003 | 0.185 | 1.001 | 1.001 | 1.001 | 0.983 | 1.001 | 1.005 | 1.014 | 0.184 | 1.004 |
| hex: canterbury/kennedy.xls | 524290 | 15640.5 ± 0.2% | 1.001 | 0.178 | 0.998 | 1.000 | 1.000 | 0.999 | 0.999 | 1.000 | 1.000 | 0.178 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 15626.0 ± 0.3% | 0.998 | 0.178 | 1.002 | 1.001 | 1.000 | 1.002 | 1.001 | 1.000 | 0.999 | 0.177 | 1.002 |
| hex: canterbury/plrabn12.txt | 524290 | 15676.2 ± 0.3% | 1.001 | 0.177 | 0.995 | 0.995 | 1.000 | 0.997 | 0.996 | 0.992 | 0.997 | 0.177 | 0.995 |
| hex: canterbury/ptt5 | 524290 | 15607.6 ± 0.3% | 1.001 | 0.179 | 1.002 | 1.000 | 1.002 | 0.999 | 1.001 | 1.000 | 1.000 | 0.179 | 1.002 |
| hex: canterbury/sum | 76482 | 15641.2 ± 0.2% | 1.001 | 0.179 | 1.001 | 1.000 | 1.001 | 0.999 | 1.001 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 15013.9 ± 0.2% | 1.001 | 0.185 | 1.001 | 1.000 | 1.000 | 0.984 | 1.001 | 1.003 | 1.013 | 0.183 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 15650.6 ± 0.3% | 1.000 | 0.178 | 1.000 | 0.999 | 0.999 | 0.999 | 0.999 | 0.999 | 1.000 | 0.178 | 0.997 |
| hex: canterbury-large/bible.txt | 524290 | 15583.0 ± 0.5% | 1.000 | 0.179 | 0.998 | 0.999 | 0.997 | 0.996 | 0.995 | 0.997 | 0.996 | 0.178 | 0.997 |
| hex: canterbury-large/world192.txt | 524290 | 15624.6 ± 0.2% | 1.000 | 0.178 | 1.001 | 1.000 | 1.000 | 0.999 | 0.999 | 0.999 | 0.997 | 0.178 | 0.998 |
| hex: http/html-1kx1024 | 2099200 | 13549.9 ± 3.2% | 1.007 | 0.197 | 1.006 | 1.003 | 1.004 | 0.943 | 1.002 | 1.014 | 1.042 | 0.188 | 1.013 |
| hex: http/html-16kx64 | 2097280 | 15197.9 ± 0.4% | 1.001 | 0.181 | 0.998 | 1.003 | 1.004 | 0.994 | 0.998 | 1.004 | 1.007 | 0.180 | 1.001 |
| hex: http/html-1m | 524290 | 15661.4 ± 0.3% | 1.000 | 0.177 | 0.999 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 0.998 | 0.177 | 0.996 |
| hex: http/json-1kx1024 | 2099200 | 13524.7 ± 0.4% | 1.011 | 0.198 | 1.003 | 1.002 | 1.001 | 0.943 | 0.996 | 1.015 | 1.043 | 0.190 | 1.012 |
| hex: http/json-16kx64 | 2097280 | 15159.1 ± 0.4% | 1.002 | 0.182 | 1.007 | 1.004 | 1.003 | 0.992 | 1.002 | 1.008 | 1.008 | 0.181 | 1.008 |
| hex: http/json-1m | 524290 | 15640.2 ± 0.4% | 0.999 | 0.178 | 1.000 | 1.001 | 1.000 | 1.000 | 0.999 | 0.996 | 0.999 | 0.178 | 0.999 |
| hex: http/js-1kx1024 | 2099200 | 13602.4 ± 0.6% | 1.011 | 0.196 | 1.001 | 0.996 | 0.998 | 0.942 | 0.998 | 1.012 | 1.039 | 0.188 | 1.012 |
| hex: http/js-16kx64 | 2097280 | 15166.6 ± 0.6% | 1.000 | 0.182 | 1.004 | 1.002 | 1.002 | 0.991 | 0.998 | 1.010 | 1.008 | 0.181 | 1.002 |
| hex: http/js-1m | 524290 | 15674.2 ± 0.2% | 1.001 | 0.177 | 1.002 | 1.001 | 0.999 | 1.000 | 1.001 | 1.001 | 1.000 | 0.177 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 13564.0 ± 0.5% | 1.008 | 0.197 | 1.002 | 1.002 | 1.003 | 0.941 | 0.999 | 1.011 | 1.039 | 0.188 | 1.014 |
| hex: http/css-16kx64 | 2097280 | 15255.1 ± 0.8% | 1.001 | 0.181 | 1.000 | 1.002 | 1.002 | 0.991 | 1.001 | 1.002 | 1.001 | 0.180 | 1.003 |
| hex: http/css-1m | 524290 | 15668.8 ± 0.3% | 1.001 | 0.177 | 0.998 | 1.001 | 1.000 | 0.998 | 0.997 | 0.998 | 0.998 | 0.177 | 0.996 |
| hex: shuffled/dickens-1m | 524290 | 15650.7 ± 0.2% | 1.000 | 0.177 | 0.988 | 0.988 | 0.989 | 0.988 | 0.991 | 0.986 | 0.990 | 0.177 | 0.989 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.055 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.055 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.258 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.251 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.248 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.253 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.251 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.243 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.244 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.317 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.268 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.268 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.272 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.274 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.275 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.276 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.284 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.282 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43344.0 ± 0.1% | 47399.5 ± 0.1% | 0.914 | — | — |
| string: silesia/nci | 1048576 | 33952.3 ± 6.1% | 36193.9 ± 3.9% | 0.938 | — | — |
| string: silesia/reymont | 1048576 | 33440.3 ± 5.6% | 35576.0 ± 4.5% | 0.940 | — | — |
| string: silesia/samba | 65546 | 43560.5 ± 0.1% | 48515.9 ± 0.0% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 34638.9 ± 4.6% | 36748.4 ± 8.6% | 0.943 | — | — |
| string: silesia/xml | 1048576 | 30973.4 ± 1.1% | 32309.7 ± 1.9% | 0.959 | — | — |
| string: canterbury/alice29.txt | 152089 | 35902.1 ± 0.2% | 36538.5 ± 0.1% | 0.983 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43331.4 ± 0.0% | 47655.4 ± 0.1% | 0.909 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36121.1 ± 0.1% | 36734.4 ± 0.1% | 0.983 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 41166.2 ± 1.0% | 44879.4 ± 1.0% | 0.917 | — | — |
| string: canterbury-large/E.coli | 1048576 | 33949.7 ± 3.1% | 36826.3 ± 2.1% | 0.922 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 29958.4 ± 0.9% | 31065.3 ± 2.0% | 0.964 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 30247.8 ± 3.3% | 31268.9 ± 2.1% | 0.967 | — | — |
| string: http/html-1m | 1048576 | 31833.3 ± 2.7% | 33720.3 ± 3.4% | 0.944 | — | — |
| string: http/json-1m | 1048576 | 29167.9 ± 3.4% | 30721.1 ± 3.9% | 0.949 | — | — |
| string: http/js-1m | 1048576 | 33382.2 ± 0.8% | 35463.7 ± 3.6% | 0.941 | — | — |
| string: http/css-1m | 1048576 | 33496.0 ± 3.4% | 35817.3 ± 2.1% | 0.935 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5767.0 ± 0.1% | 5652.7 ± 0.2% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.914 of simdutf.
- string: silesia/nci: stdx runs at 0.938 of simdutf.
- string: silesia/reymont: stdx runs at 0.940 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.909 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.917 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.922 of simdutf.
- string: http/html-1m: stdx runs at 0.944 of simdutf.
- string: http/json-1m: stdx runs at 0.949 of simdutf.
- string: http/js-1m: stdx runs at 0.941 of simdutf.
- string: http/css-1m: stdx runs at 0.935 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 39193.0 ± 2.1% | 43324.7 ± 1.9% | 0.905 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 32016.2 ± 3.7% | 33437.6 ± 3.3% | 0.957 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 35120.0 ± 4.2% | 38389.9 ± 5.2% | 0.915 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 35788.0 ± 7.0% | 37734.1 ± 4.7% | 0.948 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 34839.3 ± 2.9% | 37529.3 ± 4.7% | 0.928 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 34397.2 ± 4.5% | 36497.0 ± 5.6% | 0.942 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5762.4 ± 0.2% | 5647.2 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5752.7 ± 0.1% | 5647.1 ± 0.3% | 1.019 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5757.1 ± 0.1% | 5647.3 ± 0.3% | 1.019 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5759.0 ± 0.2% | 5645.6 ± 0.1% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5757.5 ± 0.1% | 5646.4 ± 0.1% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5756.0 ± 0.2% | 5643.3 ± 0.2% | 1.020 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.6 ± 0.5% | 933.2 ± 0.6% | 1023.5 ± 0.4% | 299.9 ± 0.6% | 664.6 ± 0.4% | 310.2 ± 1.4% | 1.208 | 1.102 | 3.760 | 1.697 | 3.636 |
| qlog records, JSON text sequence | 1467503 | 846.0 ± 1.3% | 818.5 ± 0.1% | 791.3 ± 0.7% | 244.3 ± 0.9% | 712.4 ± 1.0% | 249.9 ± 0.2% | 1.034 | 1.069 | 3.463 | 1.187 | 3.386 |
| string: silesia/dickens | 172528 | 5046.8 ± 0.3% | 1879.1 ± 0.3% | 2646.5 ± 0.2% | 363.6 ± 1.6% | 2856.5 ± 0.6% | 550.3 ± 2.0% | 2.686 | 1.907 | 13.882 | 1.767 | 9.170 |
| string: silesia/nci | 1075110 | 4289.1 ± 0.4% | 2239.6 ± 0.4% | 2988.6 ± 0.1% | 545.1 ± 1.2% | 2962.6 ± 1.8% | 598.9 ± 1.7% | 1.915 | 1.435 | 7.869 | 1.448 | 7.162 |
| string: silesia/reymont | 1075159 | 2929.0 ± 2.2% | 1815.7 ± 1.4% | 2063.5 ± 0.5% | 375.4 ± 0.4% | 2139.0 ± 0.4% | 533.4 ± 1.8% | 1.613 | 1.419 | 7.802 | 1.369 | 5.491 |
| string: silesia/samba | 97582 | 3498.3 ± 0.3% | 2024.7 ± 0.2% | 2617.6 ± 0.3% | 329.0 ± 0.9% | 1498.0 ± 0.5% | 427.0 ± 0.6% | 1.728 | 1.336 | 10.635 | 2.335 | 8.193 |
| string: silesia/webster | 1098490 | 3650.4 ± 0.8% | 1518.3 ± 0.2% | 2010.7 ± 0.5% | 359.1 ± 0.6% | 2173.1 ± 0.7% | 499.4 ± 3.3% | 2.404 | 1.816 | 10.166 | 1.680 | 7.310 |
| string: silesia/xml | 1090118 | 4786.3 ± 0.4% | 2353.1 ± 0.3% | 2524.6 ± 0.5% | 453.0 ± 1.0% | 2827.4 ± 0.8% | 565.3 ± 1.0% | 2.034 | 1.896 | 10.567 | 1.693 | 8.466 |
| string: canterbury/alice29.txt | 159425 | 4304.2 ± 0.5% | 1600.5 ± 0.4% | 2453.4 ± 0.5% | 342.2 ± 0.4% | 2493.6 ± 0.8% | 504.2 ± 0.9% | 2.689 | 1.754 | 12.576 | 1.726 | 8.536 |
| string: canterbury/asyoulik.txt | 132198 | 3456.4 ± 0.6% | 1459.2 ± 0.2% | 2254.0 ± 0.5% | 335.0 ± 1.6% | 2084.4 ± 0.3% | 461.4 ± 1.0% | 2.369 | 1.533 | 10.319 | 1.658 | 7.491 |
| string: canterbury/lcet10.txt | 441884 | 5116.0 ± 0.3% | 1853.4 ± 0.2% | 2333.3 ± 0.6% | 390.3 ± 0.5% | 2835.1 ± 0.3% | 534.4 ± 0.6% | 2.760 | 2.193 | 13.109 | 1.805 | 9.573 |
| string: canterbury/plrabn12.txt | 503330 | 4135.2 ± 0.4% | 1737.1 ± 0.4% | 2055.2 ± 0.8% | 362.1 ± 0.6% | 2489.2 ± 0.5% | 497.2 ± 0.7% | 2.380 | 2.012 | 11.420 | 1.661 | 8.316 |
| string: canterbury-large/E.coli | 1048578 | 18752.9 ± 0.7% | 3605.5 ± 0.3% | 3243.7 ± 0.5% | 928.5 ± 0.9% | 5936.8 ± 0.6% | 746.8 ± 0.7% | 5.201 | 5.781 | 20.198 | 3.159 | 25.112 |
| string: canterbury-large/bible.txt | 1055886 | 6683.8 ± 1.2% | 2936.3 ± 0.4% | 2829.4 ± 0.6% | 419.2 ± 2.0% | 3732.6 ± 2.4% | 605.6 ± 1.1% | 2.276 | 2.362 | 15.944 | 1.791 | 11.037 |
| string: canterbury-large/world192.txt | 1103121 | 3373.7 ± 0.8% | 1478.9 ± 0.4% | 2013.0 ± 0.3% | 353.1 ± 0.6% | 2112.1 ± 1.8% | 486.7 ± 0.9% | 2.281 | 1.676 | 9.555 | 1.597 | 6.932 |
| string: http/html-1m | 1058582 | 6048.3 ± 1.0% | 2734.1 ± 0.5% | 2697.2 ± 0.7% | 442.2 ± 1.0% | 3461.8 ± 0.3% | 586.6 ± 0.9% | 2.212 | 2.242 | 13.678 | 1.747 | 10.311 |
| string: http/json-1m | 1190272 | 2539.7 ± 0.3% | 877.8 ± 0.1% | 2251.9 ± 0.4% | 390.5 ± 0.1% | 1062.3 ± 0.4% | 428.0 ± 0.9% | 2.893 | 1.128 | 6.503 | 2.391 | 5.933 |
| string: http/js-1m | 1144362 | 2277.2 ± 0.4% | 1028.8 ± 0.8% | 1636.5 ± 0.7% | 321.3 ± 0.4% | 1518.7 ± 0.4% | 406.2 ± 0.6% | 2.213 | 1.391 | 7.088 | 1.499 | 5.607 |
| string: http/css-1m | 1097820 | 2624.0 ± 0.4% | 1678.7 ± 0.5% | 2226.3 ± 0.4% | 406.4 ± 1.1% | 1933.6 ± 0.4% | 475.0 ± 1.3% | 1.563 | 1.179 | 6.456 | 1.357 | 5.524 |
| string: dickens as Cyrillic and CJK | 1883069 | 3065.6 ± 0.4% | 1685.8 ± 0.3% | 895.4 ± 0.6% | 350.4 ± 0.1% | 666.6 ± 0.7% | 156.6 ± 3.7% | 1.818 | 3.424 | 8.749 | 4.599 | 19.579 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.2 ± 1.7% | 980.7 ± 0.1% | 1218.1 ± 0.9% | 216.3 ± 0.1% | 472.2 ± 0.7% | 250.6 ± 4.2% | 1.353 | 1.090 | 6.135 | 2.811 | 5.296 |
| hex: silesia/dickens | 524290 | 17937.4 ± 1.4% | 3607.9 ± 0.2% | 3279.1 ± 0.3% | 506.8 ± 2.2% | 6116.5 ± 1.2% | 781.9 ± 2.8% | 4.972 | 5.470 | 35.394 | 2.933 | 22.941 |
| hex: silesia/mozilla | 524290 | 17949.3 ± 0.7% | 3606.5 ± 0.2% | 3278.6 ± 0.3% | 454.8 ± 1.8% | 6134.4 ± 1.1% | 781.6 ± 0.4% | 4.977 | 5.475 | 39.463 | 2.926 | 22.965 |
| hex: silesia/mr | 524290 | 18079.4 ± 0.6% | 3604.4 ± 0.2% | 3282.4 ± 0.3% | 568.9 ± 0.4% | 6095.9 ± 0.9% | 782.3 ± 0.1% | 5.016 | 5.508 | 31.777 | 2.966 | 23.110 |
| hex: silesia/nci | 524290 | 18335.5 ± 0.9% | 3607.7 ± 0.3% | 3278.5 ± 0.3% | 627.4 ± 2.8% | 6096.9 ± 1.5% | 781.8 ± 0.5% | 5.082 | 5.593 | 29.226 | 3.007 | 23.452 |
| hex: silesia/ooffice | 524290 | 18407.4 ± 1.4% | 3600.7 ± 0.4% | 3286.9 ± 0.2% | 397.7 ± 1.2% | 6078.3 ± 0.6% | 779.8 ± 1.0% | 5.112 | 5.600 | 46.284 | 3.028 | 23.605 |
| hex: silesia/osdb | 524290 | 18165.0 ± 0.9% | 3603.6 ± 0.3% | 3282.7 ± 0.1% | 483.2 ± 0.7% | 6018.2 ± 1.0% | 782.9 ± 0.9% | 5.041 | 5.533 | 37.589 | 3.018 | 23.201 |
| hex: silesia/reymont | 524290 | 18029.5 ± 0.4% | 3604.9 ± 0.3% | 3288.9 ± 0.2% | 528.0 ± 1.5% | 6110.9 ± 1.9% | 782.0 ± 0.2% | 5.001 | 5.482 | 34.146 | 2.950 | 23.054 |
| hex: silesia/samba | 524290 | 17951.8 ± 0.4% | 3610.7 ± 0.3% | 3295.8 ± 0.1% | 410.4 ± 1.6% | 6127.4 ± 1.1% | 782.4 ± 0.5% | 4.972 | 5.447 | 43.746 | 2.930 | 22.945 |
| hex: silesia/sao | 524290 | 18152.3 ± 0.4% | 3606.2 ± 0.3% | 3282.4 ± 0.7% | 346.0 ± 0.8% | 6121.7 ± 1.4% | 781.3 ± 0.6% | 5.034 | 5.530 | 52.470 | 2.965 | 23.232 |
| hex: silesia/webster | 524290 | 18459.0 ± 2.2% | 3605.1 ± 0.3% | 3285.0 ± 0.2% | 471.4 ± 1.9% | 6138.4 ± 1.2% | 781.9 ± 0.4% | 5.120 | 5.619 | 39.156 | 3.007 | 23.607 |
| hex: silesia/x-ray | 524290 | 17780.3 ± 1.2% | 3604.8 ± 0.4% | 3284.6 ± 0.5% | 484.7 ± 0.3% | 6069.1 ± 1.5% | 782.1 ± 0.4% | 4.932 | 5.413 | 36.680 | 2.930 | 22.735 |
| hex: silesia/xml | 524290 | 18188.3 ± 0.5% | 3604.9 ± 0.3% | 3295.2 ± 0.2% | 534.5 ± 0.2% | 6125.3 ± 1.3% | 783.1 ± 0.4% | 5.045 | 5.520 | 34.026 | 2.969 | 23.226 |
| hex: canterbury/alice29.txt | 304180 | 18939.7 ± 0.8% | 3629.6 ± 0.1% | 3357.3 ± 0.3% | 524.0 ± 0.1% | 6097.6 ± 1.0% | 781.7 ± 1.4% | 5.218 | 5.641 | 36.148 | 3.106 | 24.229 |
| hex: canterbury/asyoulik.txt | 250360 | 19520.9 ± 0.1% | 3638.6 ± 0.1% | 3366.0 ± 0.2% | 516.2 ± 0.4% | 6150.2 ± 1.8% | 779.5 ± 0.4% | 5.365 | 5.800 | 37.819 | 3.174 | 25.043 |
| hex: canterbury/cp.html | 49208 | 19291.0 ± 0.3% | 3637.7 ± 0.3% | 3292.6 ± 0.1% | 476.2 ± 2.4% | 6278.7 ± 0.4% | 768.5 ± 0.6% | 5.303 | 5.859 | 40.514 | 3.072 | 25.103 |
| hex: canterbury/fields.c | 22302 | 18909.3 ± 0.4% | 3629.2 ± 0.0% | 3357.2 ± 0.0% | 510.1 ± 0.5% | 6253.3 ± 0.2% | 757.5 ± 2.0% | 5.210 | 5.632 | 37.069 | 3.024 | 24.961 |
| hex: canterbury/grammar.lsp | 7444 | 17461.9 ± 0.8% | 3600.7 ± 0.1% | 3360.0 ± 0.2% | 543.0 ± 1.7% | 6169.6 ± 0.4% | 731.6 ± 1.6% | 4.850 | 5.197 | 32.156 | 2.830 | 23.867 |
| hex: canterbury/kennedy.xls | 524290 | 18397.3 ± 1.5% | 3599.6 ± 0.2% | 3276.7 ± 0.2% | 655.2 ± 3.3% | 6017.7 ± 1.8% | 772.4 ± 4.0% | 5.111 | 5.615 | 28.079 | 3.057 | 23.820 |
| hex: canterbury/lcet10.txt | 524290 | 18320.7 ± 2.0% | 3606.8 ± 0.2% | 3283.5 ± 0.4% | 512.0 ± 0.4% | 6139.3 ± 2.3% | 782.0 ± 0.5% | 5.079 | 5.580 | 35.786 | 2.984 | 23.429 |
| hex: canterbury/plrabn12.txt | 524290 | 18462.4 ± 1.7% | 3609.8 ± 0.3% | 3281.7 ± 0.3% | 503.8 ± 1.0% | 6125.5 ± 1.4% | 782.2 ± 0.3% | 5.115 | 5.626 | 36.647 | 3.014 | 23.603 |
| hex: canterbury/ptt5 | 524290 | 17938.2 ± 1.9% | 3608.4 ± 0.4% | 3286.0 ± 0.3% | 561.2 ± 0.5% | 6139.6 ± 1.5% | 782.3 ± 0.8% | 4.971 | 5.459 | 31.966 | 2.922 | 22.930 |
| hex: canterbury/sum | 76482 | 19294.9 ± 0.5% | 3634.3 ± 0.0% | 3357.3 ± 0.2% | 504.7 ± 1.0% | 6183.0 ± 0.7% | 775.2 ± 0.5% | 5.309 | 5.747 | 38.233 | 3.121 | 24.891 |
| hex: canterbury/xargs.1 | 8456 | 17802.0 ± 0.0% | 3601.7 ± 0.1% | 3347.0 ± 0.1% | 488.1 ± 2.4% | 6146.9 ± 0.5% | 758.0 ± 1.1% | 4.943 | 5.319 | 36.472 | 2.896 | 23.484 |
| hex: canterbury-large/E.coli | 524290 | 18457.9 ± 2.2% | 3611.8 ± 0.2% | 3284.3 ± 0.3% | 688.9 ± 0.2% | 6093.6 ± 0.9% | 781.9 ± 2.4% | 5.110 | 5.620 | 26.793 | 3.029 | 23.606 |
| hex: canterbury-large/bible.txt | 524290 | 18580.6 ± 1.8% | 3608.9 ± 0.2% | 3283.7 ± 0.2% | 518.2 ± 3.0% | 6096.9 ± 1.5% | 780.5 ± 0.5% | 5.149 | 5.658 | 35.857 | 3.048 | 23.807 |
| hex: canterbury-large/world192.txt | 524290 | 17892.3 ± 0.5% | 3608.9 ± 0.3% | 3277.3 ± 0.3% | 491.9 ± 2.3% | 6080.3 ± 1.1% | 781.9 ± 0.7% | 4.958 | 5.460 | 36.373 | 2.943 | 22.883 |
| hex: http/html-1kx1024 | 2099200 | 9225.4 ± 16.7% | 3458.1 ± 0.3% | 2838.7 ± 0.3% | 473.8 ± 0.7% | 5101.9 ± 0.6% | 648.3 ± 0.6% | 2.668 | 3.250 | 19.470 | 1.808 | 14.229 |
| hex: http/html-16kx64 | 2097280 | 17540.6 ± 1.4% | 3605.7 ± 0.1% | 3273.2 ± 0.1% | 478.5 ± 1.3% | 6017.2 ± 0.5% | 754.4 ± 1.0% | 4.865 | 5.359 | 36.659 | 2.915 | 23.251 |
| hex: http/html-1m | 524290 | 17829.4 ± 1.6% | 3604.6 ± 0.4% | 3281.6 ± 0.6% | 497.0 ± 1.7% | 6059.9 ± 0.7% | 761.4 ± 2.3% | 4.946 | 5.433 | 35.873 | 2.942 | 23.416 |
| hex: http/json-1kx1024 | 2099200 | 9391.4 ± 14.6% | 3461.8 ± 0.2% | 2838.2 ± 0.4% | 575.5 ± 0.7% | 5090.2 ± 1.2% | 639.3 ± 4.4% | 2.713 | 3.309 | 16.319 | 1.845 | 14.689 |
| hex: http/json-16kx64 | 2097280 | 17718.2 ± 1.2% | 3608.7 ± 0.2% | 3257.3 ± 0.3% | 573.8 ± 0.3% | 6008.3 ± 0.5% | 749.0 ± 3.9% | 4.910 | 5.440 | 30.879 | 2.949 | 23.656 |
| hex: http/json-1m | 524290 | 18014.6 ± 1.2% | 3606.5 ± 0.4% | 3288.1 ± 0.2% | 594.1 ± 0.8% | 6078.9 ± 1.2% | 767.6 ± 3.8% | 4.995 | 5.479 | 30.324 | 2.963 | 23.467 |
| hex: http/js-1kx1024 | 2099200 | 9126.9 ± 16.0% | 3461.4 ± 0.1% | 2833.3 ± 0.2% | 480.6 ± 0.8% | 5092.6 ± 1.0% | 636.1 ± 4.3% | 2.637 | 3.221 | 18.989 | 1.792 | 14.347 |
| hex: http/js-16kx64 | 2097280 | 17565.1 ± 0.7% | 3603.8 ± 0.2% | 3261.1 ± 0.4% | 483.2 ± 1.6% | 6008.9 ± 0.7% | 750.1 ± 1.7% | 4.874 | 5.386 | 36.349 | 2.923 | 23.418 |
| hex: http/js-1m | 524290 | 18329.2 ± 0.6% | 3611.1 ± 0.3% | 3285.3 ± 0.3% | 502.0 ± 1.8% | 6125.6 ± 0.9% | 780.1 ± 2.1% | 5.076 | 5.579 | 36.513 | 2.992 | 23.497 |
| hex: http/css-1kx1024 | 2099200 | 9128.6 ± 15.6% | 3461.0 ± 0.5% | 2838.6 ± 0.4% | 488.1 ± 0.8% | 5080.7 ± 1.4% | 642.2 ± 1.6% | 2.638 | 3.216 | 18.703 | 1.797 | 14.215 |
| hex: http/css-16kx64 | 2097280 | 17625.0 ± 1.2% | 3606.8 ± 0.2% | 3257.2 ± 0.4% | 496.4 ± 1.6% | 6010.9 ± 0.5% | 750.7 ± 2.5% | 4.887 | 5.411 | 35.502 | 2.932 | 23.478 |
| hex: http/css-1m | 524290 | 18399.0 ± 1.6% | 3610.9 ± 0.2% | 3291.6 ± 0.4% | 499.1 ± 1.8% | 6124.7 ± 2.1% | 780.3 ± 1.3% | 5.095 | 5.590 | 36.866 | 3.004 | 23.579 |
| hex: shuffled/dickens-1m | 524290 | 17790.0 ± 0.8% | 3608.0 ± 0.3% | 3283.2 ± 0.3% | 508.9 ± 1.2% | 6097.3 ± 1.3% | 780.4 ± 0.5% | 4.931 | 5.418 | 34.956 | 2.918 | 22.797 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1473.9 ± 0.6% | 1249.9 ± 0.6% | 1038.2 ± 0.4% | 409.7 ± 0.4% | 447.7 ± 0.2% | 415.0 ± 0.4% | 1.179 | 1.420 | 3.597 | 3.292 | 3.552 |
| qlog records, JSON text sequence | 1467503 | 1270.7 ± 1.6% | 1063.3 ± 0.7% | 785.7 ± 1.6% | 378.6 ± 0.9% | 476.6 ± 0.9% | 278.3 ± 0.9% | 1.195 | 1.617 | 3.356 | 2.666 | 4.566 |
| string: silesia/dickens | 172528 | 6887.6 ± 0.6% | 2808.6 ± 0.5% | 2934.8 ± 0.9% | 429.8 ± 0.6% | 1568.9 ± 0.3% | 1009.4 ± 0.1% | 2.452 | 2.347 | 16.024 | 4.390 | 6.823 |
| string: silesia/nci | 1075110 | 7291.8 ± 0.5% | 3436.4 ± 1.3% | 3096.4 ± 0.5% | 812.0 ± 3.2% | 1852.2 ± 0.2% | 1104.9 ± 0.3% | 2.122 | 2.355 | 8.980 | 3.937 | 6.599 |
| string: silesia/reymont | 1075159 | 3322.9 ± 0.9% | 1979.9 ± 1.6% | 2056.9 ± 0.6% | 449.7 ± 0.7% | 1508.9 ± 1.3% | 949.6 ± 0.6% | 1.678 | 1.615 | 7.389 | 2.202 | 3.499 |
| string: silesia/samba | 97582 | 4189.2 ± 0.2% | 2122.7 ± 0.8% | 3445.6 ± 0.2% | 354.8 ± 0.9% | 1435.9 ± 0.3% | 1054.3 ± 0.4% | 1.974 | 1.216 | 11.806 | 2.917 | 3.973 |
| string: silesia/webster | 1098490 | 4049.4 ± 0.4% | 1875.6 ± 0.3% | 2055.8 ± 0.5% | 441.3 ± 0.6% | 1387.7 ± 0.1% | 647.2 ± 1.2% | 2.159 | 1.970 | 9.177 | 2.918 | 6.257 |
| string: silesia/xml | 1090118 | 6118.1 ± 0.3% | 2868.3 ± 0.6% | 2649.2 ± 0.5% | 611.5 ± 0.6% | 1745.6 ± 0.3% | 920.0 ± 0.3% | 2.133 | 2.309 | 10.005 | 3.505 | 6.650 |
| string: canterbury/alice29.txt | 159425 | 6398.5 ± 0.7% | 2204.7 ± 0.3% | 2760.7 ± 0.8% | 407.9 ± 0.5% | 1463.9 ± 0.4% | 955.3 ± 0.1% | 2.902 | 2.318 | 15.686 | 4.371 | 6.698 |
| string: canterbury/asyoulik.txt | 132198 | 5593.1 ± 1.1% | 1713.1 ± 0.6% | 2378.0 ± 1.0% | 403.9 ± 0.9% | 1335.3 ± 0.4% | 883.5 ± 0.1% | 3.265 | 2.352 | 13.849 | 4.189 | 6.331 |
| string: canterbury/lcet10.txt | 441884 | 6231.1 ± 0.6% | 2563.6 ± 0.5% | 2502.1 ± 2.7% | 468.5 ± 0.7% | 1520.5 ± 0.4% | 980.7 ± 0.6% | 2.431 | 2.490 | 13.301 | 4.098 | 6.354 |
| string: canterbury/plrabn12.txt | 503330 | 5706.7 ± 0.3% | 2057.7 ± 0.4% | 2064.4 ± 0.3% | 423.7 ± 0.6% | 1403.4 ± 0.2% | 928.5 ± 0.4% | 2.773 | 2.764 | 13.468 | 4.066 | 6.146 |
| string: canterbury-large/E.coli | 1048578 | 19137.4 ± 1.8% | 9637.3 ± 1.0% | 3788.0 ± 0.5% | 1473.9 ± 0.5% | 2367.2 ± 0.5% | 1189.2 ± 0.3% | 1.986 | 5.052 | 12.984 | 8.084 | 16.093 |
| string: canterbury-large/bible.txt | 1055886 | 6762.4 ± 0.7% | 4149.9 ± 0.4% | 3060.6 ± 0.8% | 504.3 ± 0.6% | 1985.4 ± 0.4% | 1117.2 ± 0.4% | 1.630 | 2.210 | 13.411 | 3.406 | 6.053 |
| string: canterbury-large/world192.txt | 1103121 | 4003.5 ± 0.3% | 1653.0 ± 0.4% | 1999.4 ± 0.9% | 448.9 ± 0.6% | 1356.6 ± 0.1% | 907.3 ± 0.3% | 2.422 | 2.002 | 8.919 | 2.951 | 4.412 |
| string: http/html-1m | 1058582 | 6735.2 ± 0.6% | 3978.6 ± 0.6% | 3033.1 ± 0.9% | 500.9 ± 0.2% | 1929.3 ± 0.7% | 802.7 ± 0.3% | 1.693 | 2.221 | 13.445 | 3.491 | 8.390 |
| string: http/json-1m | 1190272 | 3151.1 ± 0.4% | 1348.4 ± 0.3% | 1555.5 ± 0.3% | 445.8 ± 0.3% | 962.2 ± 0.1% | 764.3 ± 1.1% | 2.337 | 2.026 | 7.068 | 3.275 | 4.123 |
| string: http/js-1m | 1144362 | 2761.3 ± 0.8% | 1178.2 ± 0.5% | 1620.7 ± 0.7% | 368.6 ± 0.3% | 1092.4 ± 0.5% | 757.2 ± 0.2% | 2.344 | 1.704 | 7.492 | 2.528 | 3.647 |
| string: http/css-1m | 1097820 | 3975.0 ± 0.4% | 1481.0 ± 0.3% | 2151.3 ± 0.4% | 495.9 ± 0.5% | 1367.0 ± 0.3% | 893.9 ± 0.2% | 2.684 | 1.848 | 8.015 | 2.908 | 4.447 |
| string: dickens as Cyrillic and CJK | 1883069 | 3063.5 ± 0.3% | 2338.7 ± 0.6% | 521.2 ± 0.5% | 307.1 ± 0.9% | 563.6 ± 1.1% | 336.0 ± 0.6% | 1.310 | 5.878 | 9.974 | 5.436 | 9.119 |
| hex: silesia/dickens | 524290 | 15597.9 ± 0.2% | 1456.3 ± 0.3% | 1081.7 ± 0.5% | 499.1 ± 1.0% | 984.9 ± 0.7% | 734.1 ± 0.5% | 10.711 | 14.420 | 31.252 | 15.837 | 21.247 |
| hex: silesia/mozilla | 524290 | 15642.9 ± 0.1% | 1470.4 ± 0.3% | 1085.1 ± 0.4% | 442.2 ± 1.2% | 991.1 ± 0.3% | 734.4 ± 0.4% | 10.639 | 14.416 | 35.377 | 15.783 | 21.300 |
| hex: silesia/mr | 524290 | 15568.2 ± 0.7% | 1474.7 ± 0.3% | 1089.0 ± 0.4% | 543.7 ± 4.9% | 990.9 ± 0.7% | 731.7 ± 0.5% | 10.557 | 14.296 | 28.634 | 15.711 | 21.276 |
| hex: silesia/nci | 524290 | 15555.7 ± 0.4% | 1472.7 ± 0.4% | 1084.7 ± 0.5% | 631.5 ± 4.7% | 992.7 ± 0.3% | 732.3 ± 0.4% | 10.562 | 14.342 | 24.633 | 15.670 | 21.241 |
| hex: silesia/ooffice | 524290 | 15587.7 ± 0.2% | 1459.1 ± 0.5% | 1080.7 ± 0.5% | 387.8 ± 0.2% | 983.8 ± 0.7% | 732.1 ± 0.9% | 10.683 | 14.424 | 40.191 | 15.845 | 21.291 |
| hex: silesia/osdb | 524290 | 15567.1 ± 0.4% | 1465.6 ± 0.3% | 1083.2 ± 0.2% | 465.7 ± 1.5% | 987.6 ± 0.7% | 731.2 ± 0.6% | 10.622 | 14.372 | 33.431 | 15.763 | 21.289 |
| hex: silesia/reymont | 524290 | 15643.0 ± 0.4% | 1461.8 ± 0.7% | 1082.6 ± 0.3% | 512.7 ± 1.0% | 985.6 ± 0.9% | 733.9 ± 0.8% | 10.701 | 14.449 | 30.513 | 15.872 | 21.314 |
| hex: silesia/samba | 524290 | 15664.9 ± 0.6% | 1462.3 ± 0.3% | 1083.6 ± 0.4% | 402.7 ± 0.5% | 987.8 ± 0.3% | 732.2 ± 0.9% | 10.712 | 14.456 | 38.899 | 15.858 | 21.394 |
| hex: silesia/sao | 524290 | 15616.4 ± 0.4% | 1460.5 ± 0.2% | 1082.2 ± 0.3% | 332.5 ± 0.5% | 986.9 ± 0.3% | 734.0 ± 0.1% | 10.692 | 14.430 | 46.970 | 15.823 | 21.275 |
| hex: silesia/webster | 524290 | 15653.8 ± 0.1% | 1460.4 ± 0.3% | 1082.5 ± 0.5% | 474.2 ± 0.7% | 991.5 ± 0.6% | 733.4 ± 0.5% | 10.719 | 14.461 | 33.014 | 15.788 | 21.346 |
| hex: silesia/x-ray | 524290 | 15631.3 ± 0.2% | 1470.6 ± 0.5% | 1086.5 ± 0.3% | 443.2 ± 1.1% | 991.0 ± 0.4% | 732.7 ± 0.8% | 10.629 | 14.387 | 35.273 | 15.774 | 21.334 |
| hex: silesia/xml | 524290 | 15654.8 ± 0.1% | 1465.9 ± 0.2% | 1085.5 ± 0.2% | 609.2 ± 0.9% | 988.6 ± 0.3% | 730.7 ± 0.5% | 10.680 | 14.422 | 25.695 | 15.836 | 21.425 |
| hex: canterbury/alice29.txt | 304180 | 15671.7 ± 0.2% | 1475.8 ± 0.5% | 1090.6 ± 0.4% | 502.9 ± 0.5% | 994.8 ± 0.5% | 735.4 ± 0.3% | 10.619 | 14.369 | 31.160 | 15.753 | 21.312 |
| hex: canterbury/asyoulik.txt | 250360 | 15706.9 ± 0.1% | 1480.0 ± 0.5% | 1093.6 ± 0.3% | 496.2 ± 0.8% | 994.8 ± 0.4% | 740.6 ± 0.3% | 10.613 | 14.363 | 31.655 | 15.788 | 21.208 |
| hex: canterbury/cp.html | 49208 | 15620.1 ± 0.2% | 1477.8 ± 0.2% | 1097.7 ± 0.2% | 525.2 ± 1.9% | 1004.1 ± 0.6% | 742.0 ± 0.2% | 10.570 | 14.229 | 29.742 | 15.557 | 21.052 |
| hex: canterbury/fields.c | 22302 | 15440.4 ± 0.0% | 1410.5 ± 0.7% | 1060.3 ± 0.3% | 620.9 ± 5.1% | 987.7 ± 0.2% | 736.3 ± 0.1% | 10.947 | 14.562 | 24.869 | 15.632 | 20.971 |
| hex: canterbury/grammar.lsp | 7444 | 14942.7 ± 0.1% | 1507.5 ± 0.3% | 1092.7 ± 0.3% | 659.4 ± 4.0% | 995.9 ± 0.1% | 725.4 ± 0.1% | 9.912 | 13.675 | 22.663 | 15.004 | 20.598 |
| hex: canterbury/kennedy.xls | 524290 | 15640.5 ± 0.2% | 1471.0 ± 0.2% | 1088.7 ± 0.2% | 653.3 ± 1.1% | 990.4 ± 0.3% | 733.7 ± 0.3% | 10.633 | 14.367 | 23.941 | 15.791 | 21.318 |
| hex: canterbury/lcet10.txt | 524290 | 15626.0 ± 0.3% | 1462.0 ± 0.3% | 1083.5 ± 0.7% | 502.9 ± 0.5% | 987.5 ± 0.5% | 734.1 ± 0.3% | 10.688 | 14.421 | 31.070 | 15.824 | 21.285 |
| hex: canterbury/plrabn12.txt | 524290 | 15676.2 ± 0.3% | 1460.2 ± 0.2% | 1084.3 ± 0.4% | 493.2 ± 0.6% | 990.1 ± 0.7% | 735.0 ± 0.5% | 10.736 | 14.458 | 31.788 | 15.833 | 21.328 |
| hex: canterbury/ptt5 | 524290 | 15607.6 ± 0.3% | 1478.3 ± 0.2% | 1091.4 ± 0.3% | 557.1 ± 0.9% | 993.9 ± 0.7% | 733.4 ± 0.5% | 10.558 | 14.300 | 28.018 | 15.703 | 21.280 |
| hex: canterbury/sum | 76482 | 15641.2 ± 0.2% | 1494.4 ± 0.1% | 1104.3 ± 0.1% | 601.7 ± 2.4% | 998.4 ± 0.1% | 743.9 ± 0.1% | 10.466 | 14.164 | 25.993 | 15.667 | 21.025 |
| hex: canterbury/xargs.1 | 8456 | 15013.9 ± 0.2% | 1494.0 ± 0.4% | 1088.9 ± 1.3% | 647.9 ± 3.0% | 993.9 ± 0.3% | 727.8 ± 0.1% | 10.050 | 13.788 | 23.172 | 15.106 | 20.628 |
| hex: canterbury-large/E.coli | 524290 | 15650.6 ± 0.3% | 1468.3 ± 0.7% | 1088.2 ± 0.3% | 672.3 ± 0.4% | 990.9 ± 0.6% | 733.4 ± 0.6% | 10.659 | 14.382 | 23.281 | 15.795 | 21.341 |
| hex: canterbury-large/bible.txt | 524290 | 15583.0 ± 0.5% | 1457.9 ± 0.3% | 1081.8 ± 0.4% | 513.7 ± 1.0% | 986.4 ± 0.7% | 733.9 ± 0.8% | 10.689 | 14.405 | 30.333 | 15.797 | 21.233 |
| hex: canterbury-large/world192.txt | 524290 | 15624.6 ± 0.2% | 1459.7 ± 1.4% | 1081.6 ± 1.3% | 501.8 ± 0.5% | 989.4 ± 0.4% | 733.1 ± 0.4% | 10.704 | 14.446 | 31.139 | 15.793 | 21.313 |
| hex: http/html-1kx1024 | 2099200 | 13549.9 ± 3.2% | 1453.7 ± 0.2% | 1062.0 ± 0.1% | 501.8 ± 0.2% | 982.1 ± 0.4% | 691.8 ± 0.2% | 9.321 | 12.759 | 27.005 | 13.797 | 19.588 |
| hex: http/html-16kx64 | 2097280 | 15197.9 ± 0.4% | 1443.6 ± 0.7% | 1075.1 ± 0.2% | 507.4 ± 0.4% | 995.0 ± 0.4% | 733.4 ± 0.3% | 10.528 | 14.137 | 29.950 | 15.274 | 20.722 |
| hex: http/html-1m | 524290 | 15661.4 ± 0.3% | 1460.5 ± 0.3% | 1082.3 ± 0.4% | 499.4 ± 0.5% | 986.7 ± 0.3% | 732.4 ± 0.3% | 10.723 | 14.470 | 31.357 | 15.872 | 21.384 |
| hex: http/json-1kx1024 | 2099200 | 13524.7 ± 0.4% | 1463.3 ± 0.1% | 1068.1 ± 0.2% | 608.2 ± 0.1% | 986.1 ± 0.2% | 692.0 ± 0.2% | 9.242 | 12.662 | 22.238 | 13.715 | 19.543 |
| hex: http/json-16kx64 | 2097280 | 15159.1 ± 0.4% | 1444.2 ± 0.1% | 1073.5 ± 0.2% | 614.9 ± 0.7% | 994.0 ± 0.3% | 733.5 ± 0.2% | 10.497 | 14.122 | 24.654 | 15.250 | 20.668 |
| hex: http/json-1m | 524290 | 15640.2 ± 0.4% | 1467.3 ± 0.7% | 1085.1 ± 0.5% | 634.5 ± 1.1% | 991.4 ± 0.8% | 733.8 ± 0.5% | 10.659 | 14.414 | 24.649 | 15.776 | 21.315 |
| hex: http/js-1kx1024 | 2099200 | 13602.4 ± 0.6% | 1454.0 ± 0.2% | 1063.6 ± 1.1% | 500.7 ± 0.1% | 983.2 ± 0.3% | 691.8 ± 0.2% | 9.355 | 12.790 | 27.169 | 13.835 | 19.664 |
| hex: http/js-16kx64 | 2097280 | 15166.6 ± 0.6% | 1439.7 ± 0.1% | 1074.2 ± 0.2% | 505.0 ± 0.4% | 994.7 ± 0.4% | 733.6 ± 0.1% | 10.535 | 14.119 | 30.036 | 15.248 | 20.673 |
| hex: http/js-1m | 524290 | 15674.2 ± 0.2% | 1461.5 ± 0.4% | 1083.3 ± 0.4% | 511.3 ± 0.5% | 987.1 ± 0.3% | 733.4 ± 0.7% | 10.725 | 14.470 | 30.654 | 15.879 | 21.372 |
| hex: http/css-1kx1024 | 2099200 | 13564.0 ± 0.5% | 1456.2 ± 0.3% | 1063.0 ± 0.1% | 531.9 ± 0.4% | 983.3 ± 0.2% | 692.2 ± 0.2% | 9.315 | 12.760 | 25.501 | 13.794 | 19.597 |
| hex: http/css-16kx64 | 2097280 | 15255.1 ± 0.8% | 1440.8 ± 0.2% | 1073.8 ± 0.2% | 540.0 ± 0.3% | 998.5 ± 0.6% | 733.9 ± 0.2% | 10.588 | 14.206 | 28.250 | 15.279 | 20.786 |
| hex: http/css-1m | 524290 | 15668.8 ± 0.3% | 1464.5 ± 0.5% | 1082.4 ± 0.4% | 528.4 ± 0.5% | 992.7 ± 0.4% | 735.0 ± 0.5% | 10.699 | 14.475 | 29.652 | 15.784 | 21.318 |
| hex: shuffled/dickens-1m | 524290 | 15650.7 ± 0.2% | 1461.5 ± 0.4% | 1082.9 ± 0.5% | 501.1 ± 0.7% | 992.1 ± 0.5% | 732.3 ± 0.8% | 10.709 | 14.452 | 31.234 | 15.775 | 21.373 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1520.7 ± 0.6% | 1249.9 ± 0.6% | 1038.2 ± 0.4% | 409.7 ± 0.4% | 447.7 ± 0.2% | 415.0 ± 0.4% | 1.217 | 1.465 | 3.712 | 3.396 | 3.665 |
| qlog records, JSON text sequence | 1467503 | 1296.6 ± 0.1% | 1063.3 ± 0.7% | 785.7 ± 1.6% | 378.6 ± 0.9% | 476.6 ± 0.9% | 278.3 ± 0.9% | 1.219 | 1.650 | 3.425 | 2.720 | 4.659 |
| string: silesia/dickens | 172528 | 7134.0 ± 0.2% | 2808.6 ± 0.5% | 2934.8 ± 0.9% | 429.8 ± 0.6% | 1568.9 ± 0.3% | 1009.4 ± 0.1% | 2.540 | 2.431 | 16.597 | 4.547 | 7.068 |
| string: silesia/nci | 1075110 | 7326.6 ± 7.3% | 3436.4 ± 1.3% | 3096.4 ± 0.5% | 812.0 ± 3.2% | 1852.2 ± 0.2% | 1104.9 ± 0.3% | 2.132 | 2.366 | 9.023 | 3.956 | 6.631 |
| string: silesia/reymont | 1075159 | 3504.9 ± 1.0% | 1979.9 ± 1.6% | 2056.9 ± 0.6% | 449.7 ± 0.7% | 1508.9 ± 1.3% | 949.6 ± 0.6% | 1.770 | 1.704 | 7.794 | 2.323 | 3.691 |
| string: silesia/samba | 97582 | 4580.7 ± 1.3% | 2122.7 ± 0.8% | 3445.6 ± 0.2% | 354.8 ± 0.9% | 1435.9 ± 0.3% | 1054.3 ± 0.4% | 2.158 | 1.329 | 12.909 | 3.190 | 4.345 |
| string: silesia/webster | 1098490 | 4097.0 ± 0.6% | 1875.6 ± 0.3% | 2055.8 ± 0.5% | 441.3 ± 0.6% | 1387.7 ± 0.1% | 647.2 ± 1.2% | 2.184 | 1.993 | 9.285 | 2.952 | 6.331 |
| string: silesia/xml | 1090118 | 6246.3 ± 0.8% | 2868.3 ± 0.6% | 2649.2 ± 0.5% | 611.5 ± 0.6% | 1745.6 ± 0.3% | 920.0 ± 0.3% | 2.178 | 2.358 | 10.214 | 3.578 | 6.789 |
| string: canterbury/alice29.txt | 159425 | 6822.9 ± 0.6% | 2204.7 ± 0.3% | 2760.7 ± 0.8% | 407.9 ± 0.5% | 1463.9 ± 0.4% | 955.3 ± 0.1% | 3.095 | 2.471 | 16.726 | 4.661 | 7.142 |
| string: canterbury/asyoulik.txt | 132198 | 5897.1 ± 1.8% | 1713.1 ± 0.6% | 2378.0 ± 1.0% | 403.9 ± 0.9% | 1335.3 ± 0.4% | 883.5 ± 0.1% | 3.442 | 2.480 | 14.602 | 4.416 | 6.675 |
| string: canterbury/lcet10.txt | 441884 | 6243.4 ± 0.9% | 2563.6 ± 0.5% | 2502.1 ± 2.7% | 468.5 ± 0.7% | 1520.5 ± 0.4% | 980.7 ± 0.6% | 2.435 | 2.495 | 13.327 | 4.106 | 6.366 |
| string: canterbury/plrabn12.txt | 503330 | 5756.8 ± 0.4% | 2057.7 ± 0.4% | 2064.4 ± 0.3% | 423.7 ± 0.6% | 1403.4 ± 0.2% | 928.5 ± 0.4% | 2.798 | 2.789 | 13.586 | 4.102 | 6.200 |
| string: canterbury-large/E.coli | 1048578 | 19132.3 ± 1.7% | 9637.3 ± 1.0% | 3788.0 ± 0.5% | 1473.9 ± 0.5% | 2367.2 ± 0.5% | 1189.2 ± 0.3% | 1.985 | 5.051 | 12.981 | 8.082 | 16.089 |
| string: canterbury-large/bible.txt | 1055886 | 6775.3 ± 0.3% | 4149.9 ± 0.4% | 3060.6 ± 0.8% | 504.3 ± 0.6% | 1985.4 ± 0.4% | 1117.2 ± 0.4% | 1.633 | 2.214 | 13.436 | 3.412 | 6.064 |
| string: canterbury-large/world192.txt | 1103121 | 4019.7 ± 1.1% | 1653.0 ± 0.4% | 1999.4 ± 0.9% | 448.9 ± 0.6% | 1356.6 ± 0.1% | 907.3 ± 0.3% | 2.432 | 2.010 | 8.955 | 2.963 | 4.430 |
| string: http/html-1m | 1058582 | 6805.4 ± 0.5% | 3978.6 ± 0.6% | 3033.1 ± 0.9% | 500.9 ± 0.2% | 1929.3 ± 0.7% | 802.7 ± 0.3% | 1.711 | 2.244 | 13.586 | 3.527 | 8.478 |
| string: http/json-1m | 1190272 | 3289.1 ± 0.5% | 1348.4 ± 0.3% | 1555.5 ± 0.3% | 445.8 ± 0.3% | 962.2 ± 0.1% | 764.3 ± 1.1% | 2.439 | 2.115 | 7.378 | 3.418 | 4.304 |
| string: http/js-1m | 1144362 | 2799.1 ± 0.8% | 1178.2 ± 0.5% | 1620.7 ± 0.7% | 368.6 ± 0.3% | 1092.4 ± 0.5% | 757.2 ± 0.2% | 2.376 | 1.727 | 7.595 | 2.562 | 3.697 |
| string: http/css-1m | 1097820 | 4023.2 ± 1.0% | 1481.0 ± 0.3% | 2151.3 ± 0.4% | 495.9 ± 0.5% | 1367.0 ± 0.3% | 893.9 ± 0.2% | 2.717 | 1.870 | 8.112 | 2.943 | 4.501 |
| string: dickens as Cyrillic and CJK | 1883069 | 3067.5 ± 0.3% | 2338.7 ± 0.6% | 521.2 ± 0.5% | 307.1 ± 0.9% | 563.6 ± 1.1% | 336.0 ± 0.6% | 1.312 | 5.886 | 9.987 | 5.443 | 9.131 |
| hex: silesia/dickens | 524290 | 15677.9 ± 0.4% | 1456.3 ± 0.3% | 1081.7 ± 0.5% | 499.1 ± 1.0% | 984.9 ± 0.7% | 734.1 ± 0.5% | 10.766 | 14.494 | 31.412 | 15.918 | 21.356 |
| hex: silesia/mozilla | 524290 | 15636.4 ± 0.5% | 1470.4 ± 0.3% | 1085.1 ± 0.4% | 442.2 ± 1.2% | 991.1 ± 0.3% | 734.4 ± 0.4% | 10.634 | 14.410 | 35.362 | 15.776 | 21.291 |
| hex: silesia/mr | 524290 | 15463.6 ± 0.3% | 1474.7 ± 0.3% | 1089.0 ± 0.4% | 543.7 ± 4.9% | 990.9 ± 0.7% | 731.7 ± 0.5% | 10.486 | 14.200 | 28.441 | 15.606 | 21.133 |
| hex: silesia/nci | 524290 | 15451.4 ± 1.2% | 1472.7 ± 0.4% | 1084.7 ± 0.5% | 631.5 ± 4.7% | 992.7 ± 0.3% | 732.3 ± 0.4% | 10.492 | 14.246 | 24.468 | 15.565 | 21.099 |
| hex: silesia/ooffice | 524290 | 15604.9 ± 0.2% | 1459.1 ± 0.5% | 1080.7 ± 0.5% | 387.8 ± 0.2% | 983.8 ± 0.7% | 732.1 ± 0.9% | 10.695 | 14.440 | 40.235 | 15.862 | 21.314 |
| hex: silesia/osdb | 524290 | 15552.3 ± 0.3% | 1465.6 ± 0.3% | 1083.2 ± 0.2% | 465.7 ± 1.5% | 987.6 ± 0.7% | 731.2 ± 0.6% | 10.611 | 14.358 | 33.399 | 15.748 | 21.269 |
| hex: silesia/reymont | 524290 | 15639.2 ± 0.6% | 1461.8 ± 0.7% | 1082.6 ± 0.3% | 512.7 ± 1.0% | 985.6 ± 0.9% | 733.9 ± 0.8% | 10.698 | 14.445 | 30.505 | 15.868 | 21.309 |
| hex: silesia/samba | 524290 | 15655.0 ± 0.7% | 1462.3 ± 0.3% | 1083.6 ± 0.4% | 402.7 ± 0.5% | 987.8 ± 0.3% | 732.2 ± 0.9% | 10.706 | 14.447 | 38.874 | 15.848 | 21.380 |
| hex: silesia/sao | 524290 | 15620.7 ± 1.0% | 1460.5 ± 0.2% | 1082.2 ± 0.3% | 332.5 ± 0.5% | 986.9 ± 0.3% | 734.0 ± 0.1% | 10.695 | 14.434 | 46.984 | 15.828 | 21.281 |
| hex: silesia/webster | 524290 | 15676.8 ± 0.7% | 1460.4 ± 0.3% | 1082.5 ± 0.5% | 474.2 ± 0.7% | 991.5 ± 0.6% | 733.4 ± 0.5% | 10.735 | 14.482 | 33.062 | 15.811 | 21.377 |
| hex: silesia/x-ray | 524290 | 15618.5 ± 0.1% | 1470.6 ± 0.5% | 1086.5 ± 0.3% | 443.2 ± 1.1% | 991.0 ± 0.4% | 732.7 ± 0.8% | 10.621 | 14.375 | 35.244 | 15.761 | 21.317 |
| hex: silesia/xml | 524290 | 15665.2 ± 0.1% | 1465.9 ± 0.2% | 1085.5 ± 0.2% | 609.2 ± 0.9% | 988.6 ± 0.3% | 730.7 ± 0.5% | 10.687 | 14.432 | 25.712 | 15.846 | 21.440 |
| hex: canterbury/alice29.txt | 304180 | 15688.2 ± 0.0% | 1475.8 ± 0.5% | 1090.6 ± 0.4% | 502.9 ± 0.5% | 994.8 ± 0.5% | 735.4 ± 0.3% | 10.630 | 14.384 | 31.193 | 15.770 | 21.334 |
| hex: canterbury/asyoulik.txt | 250360 | 15723.3 ± 0.0% | 1480.0 ± 0.5% | 1093.6 ± 0.3% | 496.2 ± 0.8% | 994.8 ± 0.4% | 740.6 ± 0.3% | 10.624 | 14.378 | 31.689 | 15.805 | 21.230 |
| hex: canterbury/cp.html | 49208 | 15636.1 ± 0.0% | 1477.8 ± 0.2% | 1097.7 ± 0.2% | 525.2 ± 1.9% | 1004.1 ± 0.6% | 742.0 ± 0.2% | 10.580 | 14.244 | 29.773 | 15.573 | 21.074 |
| hex: canterbury/fields.c | 22302 | 15457.5 ± 0.0% | 1410.5 ± 0.7% | 1060.3 ± 0.3% | 620.9 ± 5.1% | 987.7 ± 0.2% | 736.3 ± 0.1% | 10.959 | 14.578 | 24.897 | 15.649 | 20.994 |
| hex: canterbury/grammar.lsp | 7444 | 14995.6 ± 0.0% | 1507.5 ± 0.3% | 1092.7 ± 0.3% | 659.4 ± 4.0% | 995.9 ± 0.1% | 725.4 ± 0.1% | 9.947 | 13.724 | 22.743 | 15.057 | 20.671 |
| hex: canterbury/kennedy.xls | 524290 | 15641.1 ± 0.4% | 1471.0 ± 0.2% | 1088.7 ± 0.2% | 653.3 ± 1.1% | 990.4 ± 0.3% | 733.7 ± 0.3% | 10.633 | 14.367 | 23.942 | 15.792 | 21.318 |
| hex: canterbury/lcet10.txt | 524290 | 15652.1 ± 0.3% | 1462.0 ± 0.3% | 1083.5 ± 0.7% | 502.9 ± 0.5% | 987.5 ± 0.5% | 734.1 ± 0.3% | 10.706 | 14.445 | 31.121 | 15.850 | 21.321 |
| hex: canterbury/plrabn12.txt | 524290 | 15593.6 ± 0.8% | 1460.2 ± 0.2% | 1084.3 ± 0.4% | 493.2 ± 0.6% | 990.1 ± 0.7% | 735.0 ± 0.5% | 10.679 | 14.382 | 31.620 | 15.749 | 21.216 |
| hex: canterbury/ptt5 | 524290 | 15637.5 ± 0.4% | 1478.3 ± 0.2% | 1091.4 ± 0.3% | 557.1 ± 0.9% | 993.9 ± 0.7% | 733.4 ± 0.5% | 10.578 | 14.327 | 28.072 | 15.733 | 21.321 |
| hex: canterbury/sum | 76482 | 15652.9 ± 0.0% | 1494.4 ± 0.1% | 1104.3 ± 0.1% | 601.7 ± 2.4% | 998.4 ± 0.1% | 743.9 ± 0.1% | 10.474 | 14.174 | 26.012 | 15.678 | 21.040 |
| hex: canterbury/xargs.1 | 8456 | 15051.9 ± 0.1% | 1494.0 ± 0.4% | 1088.9 ± 1.3% | 647.9 ± 3.0% | 993.9 ± 0.3% | 727.8 ± 0.1% | 10.075 | 13.823 | 23.231 | 15.144 | 20.681 |
| hex: canterbury-large/E.coli | 524290 | 15601.3 ± 0.5% | 1468.3 ± 0.7% | 1088.2 ± 0.3% | 672.3 ± 0.4% | 990.9 ± 0.6% | 733.4 ± 0.6% | 10.625 | 14.337 | 23.207 | 15.745 | 21.273 |
| hex: canterbury-large/bible.txt | 524290 | 15533.3 ± 0.3% | 1457.9 ± 0.3% | 1081.8 ± 0.4% | 513.7 ± 1.0% | 986.4 ± 0.7% | 733.9 ± 0.8% | 10.655 | 14.359 | 30.236 | 15.747 | 21.165 |
| hex: canterbury-large/world192.txt | 524290 | 15600.4 ± 0.4% | 1459.7 ± 1.4% | 1081.6 ± 1.3% | 501.8 ± 0.5% | 989.4 ± 0.4% | 733.1 ± 0.4% | 10.688 | 14.424 | 31.091 | 15.768 | 21.280 |
| hex: http/html-1kx1024 | 2099200 | 13721.7 ± 0.6% | 1453.7 ± 0.2% | 1062.0 ± 0.1% | 501.8 ± 0.2% | 982.1 ± 0.4% | 691.8 ± 0.2% | 9.439 | 12.921 | 27.347 | 13.972 | 19.836 |
| hex: http/html-16kx64 | 2097280 | 15215.0 ± 0.5% | 1443.6 ± 0.7% | 1075.1 ± 0.2% | 507.4 ± 0.4% | 995.0 ± 0.4% | 733.4 ± 0.3% | 10.540 | 14.153 | 29.983 | 15.292 | 20.745 |
| hex: http/html-1m | 524290 | 15603.6 ± 0.4% | 1460.5 ± 0.3% | 1082.3 ± 0.4% | 499.4 ± 0.5% | 986.7 ± 0.3% | 732.4 ± 0.3% | 10.684 | 14.417 | 31.242 | 15.813 | 21.306 |
| hex: http/json-1kx1024 | 2099200 | 13682.5 ± 0.4% | 1463.3 ± 0.1% | 1068.1 ± 0.2% | 608.2 ± 0.1% | 986.1 ± 0.2% | 692.0 ± 0.2% | 9.350 | 12.810 | 22.498 | 13.875 | 19.771 |
| hex: http/json-16kx64 | 2097280 | 15285.7 ± 0.8% | 1444.2 ± 0.1% | 1073.5 ± 0.2% | 614.9 ± 0.7% | 994.0 ± 0.3% | 733.5 ± 0.2% | 10.584 | 14.240 | 24.860 | 15.377 | 20.840 |
| hex: http/json-1m | 524290 | 15624.5 ± 0.1% | 1467.3 ± 0.7% | 1085.1 ± 0.5% | 634.5 ± 1.1% | 991.4 ± 0.8% | 733.8 ± 0.5% | 10.649 | 14.400 | 24.625 | 15.760 | 21.293 |
| hex: http/js-1kx1024 | 2099200 | 13762.6 ± 0.7% | 1454.0 ± 0.2% | 1063.6 ± 1.1% | 500.7 ± 0.1% | 983.2 ± 0.3% | 691.8 ± 0.2% | 9.465 | 12.940 | 27.489 | 13.998 | 19.895 |
| hex: http/js-16kx64 | 2097280 | 15203.3 ± 0.6% | 1439.7 ± 0.1% | 1074.2 ± 0.2% | 505.0 ± 0.4% | 994.7 ± 0.4% | 733.6 ± 0.1% | 10.560 | 14.153 | 30.109 | 15.285 | 20.723 |
| hex: http/js-1m | 524290 | 15688.4 ± 0.2% | 1461.5 ± 0.4% | 1083.3 ± 0.4% | 511.3 ± 0.5% | 987.1 ± 0.3% | 733.4 ± 0.7% | 10.735 | 14.483 | 30.681 | 15.893 | 21.391 |
| hex: http/css-1kx1024 | 2099200 | 13757.3 ± 0.5% | 1456.2 ± 0.3% | 1063.0 ± 0.1% | 531.9 ± 0.4% | 983.3 ± 0.2% | 692.2 ± 0.2% | 9.447 | 12.941 | 25.864 | 13.990 | 19.876 |
| hex: http/css-16kx64 | 2097280 | 15306.5 ± 0.5% | 1440.8 ± 0.2% | 1073.8 ± 0.2% | 540.0 ± 0.3% | 998.5 ± 0.6% | 733.9 ± 0.2% | 10.623 | 14.254 | 28.345 | 15.330 | 20.856 |
| hex: http/css-1m | 524290 | 15602.5 ± 0.5% | 1464.5 ± 0.5% | 1082.4 ± 0.4% | 528.4 ± 0.5% | 992.7 ± 0.4% | 735.0 ± 0.5% | 10.654 | 14.414 | 29.527 | 15.717 | 21.228 |
| hex: shuffled/dickens-1m | 524290 | 15472.0 ± 0.9% | 1461.5 ± 0.4% | 1082.9 ± 0.5% | 501.1 ± 0.7% | 992.1 ± 0.5% | 732.3 ± 0.8% | 10.586 | 14.287 | 30.877 | 15.595 | 21.129 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.2 ± 0.7% | 933.2 ± 0.6% | 1023.5 ± 0.4% | 299.9 ± 0.6% | 664.6 ± 0.4% | 310.2 ± 1.4% | 1.004 | 0.916 | 3.125 | 1.410 | 3.022 |
| qlog records, JSON text sequence | 1467503 | 780.8 ± 0.7% | 818.5 ± 0.1% | 791.3 ± 0.7% | 244.3 ± 0.9% | 712.4 ± 1.0% | 249.9 ± 0.2% | 0.954 | 0.987 | 3.196 | 1.096 | 3.125 |
| string: silesia/dickens | 172528 | 5062.0 ± 0.3% | 1879.1 ± 0.3% | 2646.5 ± 0.2% | 363.6 ± 1.6% | 2856.5 ± 0.6% | 550.3 ± 2.0% | 2.694 | 1.913 | 13.923 | 1.772 | 9.198 |
| string: silesia/nci | 1075110 | 4299.9 ± 0.5% | 2239.6 ± 0.4% | 2988.6 ± 0.1% | 545.1 ± 1.2% | 2962.6 ± 1.8% | 598.9 ± 1.7% | 1.920 | 1.439 | 7.889 | 1.451 | 7.180 |
| string: silesia/reymont | 1075159 | 2984.5 ± 2.1% | 1815.7 ± 1.4% | 2063.5 ± 0.5% | 375.4 ± 0.4% | 2139.0 ± 0.4% | 533.4 ± 1.8% | 1.644 | 1.446 | 7.949 | 1.395 | 5.595 |
| string: silesia/samba | 97582 | 3502.0 ± 0.3% | 2024.7 ± 0.2% | 2617.6 ± 0.3% | 329.0 ± 0.9% | 1498.0 ± 0.5% | 427.0 ± 0.6% | 1.730 | 1.338 | 10.646 | 2.338 | 8.202 |
| string: silesia/webster | 1098490 | 3672.1 ± 0.7% | 1518.3 ± 0.2% | 2010.7 ± 0.5% | 359.1 ± 0.6% | 2173.1 ± 0.7% | 499.4 ± 3.3% | 2.419 | 1.826 | 10.227 | 1.690 | 7.353 |
| string: silesia/xml | 1090118 | 4797.3 ± 0.5% | 2353.1 ± 0.3% | 2524.6 ± 0.5% | 453.0 ± 1.0% | 2827.4 ± 0.8% | 565.3 ± 1.0% | 2.039 | 1.900 | 10.591 | 1.697 | 8.486 |
| string: canterbury/alice29.txt | 159425 | 4355.5 ± 1.7% | 1600.5 ± 0.4% | 2453.4 ± 0.5% | 342.2 ± 0.4% | 2493.6 ± 0.8% | 504.2 ± 0.9% | 2.721 | 1.775 | 12.726 | 1.747 | 8.638 |
| string: canterbury/asyoulik.txt | 132198 | 3497.5 ± 0.7% | 1459.2 ± 0.2% | 2254.0 ± 0.5% | 335.0 ± 1.6% | 2084.4 ± 0.3% | 461.4 ± 1.0% | 2.397 | 1.552 | 10.442 | 1.678 | 7.579 |
| string: canterbury/lcet10.txt | 441884 | 5128.5 ± 0.3% | 1853.4 ± 0.2% | 2333.3 ± 0.6% | 390.3 ± 0.5% | 2835.1 ± 0.3% | 534.4 ± 0.6% | 2.767 | 2.198 | 13.141 | 1.809 | 9.597 |
| string: canterbury/plrabn12.txt | 503330 | 4138.5 ± 0.4% | 1737.1 ± 0.4% | 2055.2 ± 0.8% | 362.1 ± 0.6% | 2489.2 ± 0.5% | 497.2 ± 0.7% | 2.382 | 2.014 | 11.429 | 1.663 | 8.323 |
| string: canterbury-large/E.coli | 1048578 | 11890.5 ± 0.3% | 3605.5 ± 0.3% | 3243.7 ± 0.5% | 928.5 ± 0.9% | 5936.8 ± 0.6% | 746.8 ± 0.7% | 3.298 | 3.666 | 12.807 | 2.003 | 15.922 |
| string: canterbury-large/bible.txt | 1055886 | 6893.0 ± 0.8% | 2936.3 ± 0.4% | 2829.4 ± 0.6% | 419.2 ± 2.0% | 3732.6 ± 2.4% | 605.6 ± 1.1% | 2.347 | 2.436 | 16.443 | 1.847 | 11.382 |
| string: canterbury-large/world192.txt | 1103121 | 3395.4 ± 0.3% | 1478.9 ± 0.4% | 2013.0 ± 0.3% | 353.1 ± 0.6% | 2112.1 ± 1.8% | 486.7 ± 0.9% | 2.296 | 1.687 | 9.617 | 1.608 | 6.977 |
| string: http/html-1m | 1058582 | 6235.5 ± 1.0% | 2734.1 ± 0.5% | 2697.2 ± 0.7% | 442.2 ± 1.0% | 3461.8 ± 0.3% | 586.6 ± 0.9% | 2.281 | 2.312 | 14.102 | 1.801 | 10.630 |
| string: http/json-1m | 1190272 | 2558.9 ± 0.5% | 877.8 ± 0.1% | 2251.9 ± 0.4% | 390.5 ± 0.1% | 1062.3 ± 0.4% | 428.0 ± 0.9% | 2.915 | 1.136 | 6.552 | 2.409 | 5.978 |
| string: http/js-1m | 1144362 | 2286.6 ± 0.4% | 1028.8 ± 0.8% | 1636.5 ± 0.7% | 321.3 ± 0.4% | 1518.7 ± 0.4% | 406.2 ± 0.6% | 2.223 | 1.397 | 7.117 | 1.506 | 5.630 |
| string: http/css-1m | 1097820 | 2652.8 ± 0.5% | 1678.7 ± 0.5% | 2226.3 ± 0.4% | 406.4 ± 1.1% | 1933.6 ± 0.4% | 475.0 ± 1.3% | 1.580 | 1.192 | 6.527 | 1.372 | 5.585 |
| string: dickens as Cyrillic and CJK | 1883069 | 3078.5 ± 0.4% | 1685.8 ± 0.3% | 895.4 ± 0.6% | 350.4 ± 0.1% | 666.6 ± 0.7% | 156.6 ± 3.7% | 1.826 | 3.438 | 8.786 | 4.618 | 19.661 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.3 ± 0.2% | 980.7 ± 0.1% | 1218.1 ± 0.9% | 216.3 ± 0.1% | 472.2 ± 0.7% | 250.6 ± 4.2% | 1.355 | 1.091 | 6.145 | 2.815 | 5.304 |
| hex: silesia/dickens | 524290 | 11994.7 ± 0.1% | 3607.9 ± 0.2% | 3279.1 ± 0.3% | 506.8 ± 2.2% | 6116.5 ± 1.2% | 781.9 ± 2.8% | 3.325 | 3.658 | 23.668 | 1.961 | 15.340 |
| hex: silesia/mozilla | 524290 | 11999.8 ± 0.1% | 3606.5 ± 0.2% | 3278.6 ± 0.3% | 454.8 ± 1.8% | 6134.4 ± 1.1% | 781.6 ± 0.4% | 3.327 | 3.660 | 26.383 | 1.956 | 15.353 |
| hex: silesia/mr | 524290 | 12002.5 ± 0.2% | 3604.4 ± 0.2% | 3282.4 ± 0.3% | 568.9 ± 0.4% | 6095.9 ± 0.9% | 782.3 ± 0.1% | 3.330 | 3.657 | 21.096 | 1.969 | 15.342 |
| hex: silesia/nci | 524290 | 11992.6 ± 0.1% | 3607.7 ± 0.3% | 3278.5 ± 0.3% | 627.4 ± 2.8% | 6096.9 ± 1.5% | 781.8 ± 0.5% | 3.324 | 3.658 | 19.116 | 1.967 | 15.339 |
| hex: silesia/ooffice | 524290 | 12007.1 ± 0.1% | 3600.7 ± 0.4% | 3286.9 ± 0.2% | 397.7 ± 1.2% | 6078.3 ± 0.6% | 779.8 ± 1.0% | 3.335 | 3.653 | 30.191 | 1.975 | 15.398 |
| hex: silesia/osdb | 524290 | 11962.4 ± 0.3% | 3603.6 ± 0.3% | 3282.7 ± 0.1% | 483.2 ± 0.7% | 6018.2 ± 1.0% | 782.9 ± 0.9% | 3.320 | 3.644 | 24.754 | 1.988 | 15.279 |
| hex: silesia/reymont | 524290 | 12006.9 ± 0.1% | 3604.9 ± 0.3% | 3288.9 ± 0.2% | 528.0 ± 1.5% | 6110.9 ± 1.9% | 782.0 ± 0.2% | 3.331 | 3.651 | 22.740 | 1.965 | 15.353 |
| hex: silesia/samba | 524290 | 12015.8 ± 0.2% | 3610.7 ± 0.3% | 3295.8 ± 0.1% | 410.4 ± 1.6% | 6127.4 ± 1.1% | 782.4 ± 0.5% | 3.328 | 3.646 | 29.281 | 1.961 | 15.358 |
| hex: silesia/sao | 524290 | 12022.7 ± 0.1% | 3606.2 ± 0.3% | 3282.4 ± 0.7% | 346.0 ± 0.8% | 6121.7 ± 1.4% | 781.3 ± 0.6% | 3.334 | 3.663 | 34.752 | 1.964 | 15.387 |
| hex: silesia/webster | 524290 | 11993.7 ± 0.1% | 3605.1 ± 0.3% | 3285.0 ± 0.2% | 471.4 ± 1.9% | 6138.4 ± 1.2% | 781.9 ± 0.4% | 3.327 | 3.651 | 25.441 | 1.954 | 15.339 |
| hex: silesia/x-ray | 524290 | 11993.5 ± 0.1% | 3604.8 ± 0.4% | 3284.6 ± 0.5% | 484.7 ± 0.3% | 6069.1 ± 1.5% | 782.1 ± 0.4% | 3.327 | 3.651 | 24.742 | 1.976 | 15.336 |
| hex: silesia/xml | 524290 | 12018.5 ± 0.1% | 3604.9 ± 0.3% | 3295.2 ± 0.2% | 534.5 ± 0.2% | 6125.3 ± 1.3% | 783.1 ± 0.4% | 3.334 | 3.647 | 22.484 | 1.962 | 15.348 |
| hex: canterbury/alice29.txt | 304180 | 12010.7 ± 0.1% | 3629.6 ± 0.1% | 3357.3 ± 0.3% | 524.0 ± 0.1% | 6097.6 ± 1.0% | 781.7 ± 1.4% | 3.309 | 3.578 | 22.923 | 1.970 | 15.365 |
| hex: canterbury/asyoulik.txt | 250360 | 12006.2 ± 0.1% | 3638.6 ± 0.1% | 3366.0 ± 0.2% | 516.2 ± 0.4% | 6150.2 ± 1.8% | 779.5 ± 0.4% | 3.300 | 3.567 | 23.261 | 1.952 | 15.403 |
| hex: canterbury/cp.html | 49208 | 11908.9 ± 0.0% | 3637.7 ± 0.3% | 3292.6 ± 0.1% | 476.2 ± 2.4% | 6278.7 ± 0.4% | 768.5 ± 0.6% | 3.274 | 3.617 | 25.010 | 1.897 | 15.497 |
| hex: canterbury/fields.c | 22302 | 11775.2 ± 0.1% | 3629.2 ± 0.0% | 3357.2 ± 0.0% | 510.1 ± 0.5% | 6253.3 ± 0.2% | 757.5 ± 2.0% | 3.245 | 3.507 | 23.084 | 1.883 | 15.544 |
| hex: canterbury/grammar.lsp | 7444 | 11253.6 ± 0.0% | 3600.7 ± 0.1% | 3360.0 ± 0.2% | 543.0 ± 1.7% | 6169.6 ± 0.4% | 731.6 ± 1.6% | 3.125 | 3.349 | 20.723 | 1.824 | 15.382 |
| hex: canterbury/kennedy.xls | 524290 | 11924.9 ± 0.2% | 3599.6 ± 0.2% | 3276.7 ± 0.2% | 655.2 ± 3.3% | 6017.7 ± 1.8% | 772.4 ± 4.0% | 3.313 | 3.639 | 18.200 | 1.982 | 15.440 |
| hex: canterbury/lcet10.txt | 524290 | 12017.3 ± 0.1% | 3606.8 ± 0.2% | 3283.5 ± 0.4% | 512.0 ± 0.4% | 6139.3 ± 2.3% | 782.0 ± 0.5% | 3.332 | 3.660 | 23.473 | 1.957 | 15.368 |
| hex: canterbury/plrabn12.txt | 524290 | 11997.7 ± 0.1% | 3609.8 ± 0.3% | 3281.7 ± 0.3% | 503.8 ± 1.0% | 6125.5 ± 1.4% | 782.2 ± 0.3% | 3.324 | 3.656 | 23.815 | 1.959 | 15.339 |
| hex: canterbury/ptt5 | 524290 | 12009.9 ± 0.2% | 3608.4 ± 0.4% | 3286.0 ± 0.3% | 561.2 ± 0.5% | 6139.6 ± 1.5% | 782.3 ± 0.8% | 3.328 | 3.655 | 21.402 | 1.956 | 15.352 |
| hex: canterbury/sum | 76482 | 11899.4 ± 0.2% | 3634.3 ± 0.0% | 3357.3 ± 0.2% | 504.7 ± 1.0% | 6183.0 ± 0.7% | 775.2 ± 0.5% | 3.274 | 3.544 | 23.579 | 1.925 | 15.351 |
| hex: canterbury/xargs.1 | 8456 | 11333.7 ± 0.1% | 3601.7 ± 0.1% | 3347.0 ± 0.1% | 488.1 ± 2.4% | 6146.9 ± 0.5% | 758.0 ± 1.1% | 3.147 | 3.386 | 23.220 | 1.844 | 14.951 |
| hex: canterbury-large/E.coli | 524290 | 11974.6 ± 0.2% | 3611.8 ± 0.2% | 3284.3 ± 0.3% | 688.9 ± 0.2% | 6093.6 ± 0.9% | 781.9 ± 2.4% | 3.315 | 3.646 | 17.382 | 1.965 | 15.314 |
| hex: canterbury-large/bible.txt | 524290 | 12018.9 ± 0.1% | 3608.9 ± 0.2% | 3283.7 ± 0.2% | 518.2 ± 3.0% | 6096.9 ± 1.5% | 780.5 ± 0.5% | 3.330 | 3.660 | 23.194 | 1.971 | 15.400 |
| hex: canterbury-large/world192.txt | 524290 | 12002.5 ± 0.2% | 3608.9 ± 0.3% | 3277.3 ± 0.3% | 491.9 ± 2.3% | 6080.3 ± 1.1% | 781.9 ± 0.7% | 3.326 | 3.662 | 24.399 | 1.974 | 15.350 |
| hex: http/html-1kx1024 | 2099200 | 8721.4 ± 3.9% | 3458.1 ± 0.3% | 2838.7 ± 0.3% | 473.8 ± 0.7% | 5101.9 ± 0.6% | 648.3 ± 0.6% | 2.522 | 3.072 | 18.406 | 1.709 | 13.452 |
| hex: http/html-16kx64 | 2097280 | 11767.7 ± 0.1% | 3605.7 ± 0.1% | 3273.2 ± 0.1% | 478.5 ± 1.3% | 6017.2 ± 0.5% | 754.4 ± 1.0% | 3.264 | 3.595 | 24.594 | 1.956 | 15.599 |
| hex: http/html-1m | 524290 | 11995.9 ± 0.1% | 3604.6 ± 0.4% | 3281.6 ± 0.6% | 497.0 ± 1.7% | 6059.9 ± 0.7% | 761.4 ± 2.3% | 3.328 | 3.655 | 24.136 | 1.980 | 15.754 |
| hex: http/json-1kx1024 | 2099200 | 9011.5 ± 3.7% | 3461.8 ± 0.2% | 2838.2 ± 0.4% | 575.5 ± 0.7% | 5090.2 ± 1.2% | 639.3 ± 4.4% | 2.603 | 3.175 | 15.659 | 1.770 | 14.095 |
| hex: http/json-16kx64 | 2097280 | 11767.0 ± 0.1% | 3608.7 ± 0.2% | 3257.3 ± 0.3% | 573.8 ± 0.3% | 6008.3 ± 0.5% | 749.0 ± 3.9% | 3.261 | 3.613 | 20.507 | 1.958 | 15.711 |
| hex: http/json-1m | 524290 | 11992.2 ± 0.1% | 3606.5 ± 0.4% | 3288.1 ± 0.2% | 594.1 ± 0.8% | 6078.9 ± 1.2% | 767.6 ± 3.8% | 3.325 | 3.647 | 20.186 | 1.973 | 15.622 |
| hex: http/js-1kx1024 | 2099200 | 8721.0 ± 4.3% | 3461.4 ± 0.1% | 2833.3 ± 0.2% | 480.6 ± 0.8% | 5092.6 ± 1.0% | 636.1 ± 4.3% | 2.519 | 3.078 | 18.145 | 1.712 | 13.709 |
| hex: http/js-16kx64 | 2097280 | 11758.4 ± 0.2% | 3603.8 ± 0.2% | 3261.1 ± 0.4% | 483.2 ± 1.6% | 6008.9 ± 0.7% | 750.1 ± 1.7% | 3.263 | 3.606 | 24.333 | 1.957 | 15.676 |
| hex: http/js-1m | 524290 | 11996.4 ± 0.1% | 3611.1 ± 0.3% | 3285.3 ± 0.3% | 502.0 ± 1.8% | 6125.6 ± 0.9% | 780.1 ± 2.1% | 3.322 | 3.652 | 23.898 | 1.958 | 15.379 |
| hex: http/css-1kx1024 | 2099200 | 9015.5 ± 4.3% | 3461.0 ± 0.5% | 2838.6 ± 0.4% | 488.1 ± 0.8% | 5080.7 ± 1.4% | 642.2 ± 1.6% | 2.605 | 3.176 | 18.472 | 1.774 | 14.038 |
| hex: http/css-16kx64 | 2097280 | 11747.5 ± 0.2% | 3606.8 ± 0.2% | 3257.2 ± 0.4% | 496.4 ± 1.6% | 6010.9 ± 0.5% | 750.7 ± 2.5% | 3.257 | 3.607 | 23.663 | 1.954 | 15.649 |
| hex: http/css-1m | 524290 | 12008.0 ± 0.1% | 3610.9 ± 0.2% | 3291.6 ± 0.4% | 499.1 ± 1.8% | 6124.7 ± 2.1% | 780.3 ± 1.3% | 3.325 | 3.648 | 24.061 | 1.961 | 15.388 |
| hex: shuffled/dickens-1m | 524290 | 11990.5 ± 0.1% | 3608.0 ± 0.3% | 3283.2 ± 0.3% | 508.9 ± 1.2% | 6097.3 ± 1.3% | 780.4 ± 0.5% | 3.323 | 3.652 | 23.560 | 1.967 | 15.365 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1013.4 ± 0.2% | 933.2 ± 0.6% | 1023.5 ± 0.4% | 299.9 ± 0.6% | 664.6 ± 0.4% | 310.2 ± 1.4% | 1.086 | 0.990 | 3.379 | 1.525 | 3.267 |
| qlog records, JSON text sequence | 1467503 | 834.3 ± 0.6% | 818.5 ± 0.1% | 791.3 ± 0.7% | 244.3 ± 0.9% | 712.4 ± 1.0% | 249.9 ± 0.2% | 1.019 | 1.054 | 3.415 | 1.171 | 3.339 |
| string: silesia/dickens | 172528 | 5060.2 ± 0.3% | 1879.1 ± 0.3% | 2646.5 ± 0.2% | 363.6 ± 1.6% | 2856.5 ± 0.6% | 550.3 ± 2.0% | 2.693 | 1.912 | 13.919 | 1.771 | 9.195 |
| string: silesia/nci | 1075110 | 4304.9 ± 0.4% | 2239.6 ± 0.4% | 2988.6 ± 0.1% | 545.1 ± 1.2% | 2962.6 ± 1.8% | 598.9 ± 1.7% | 1.922 | 1.440 | 7.898 | 1.453 | 7.188 |
| string: silesia/reymont | 1075159 | 2978.7 ± 2.4% | 1815.7 ± 1.4% | 2063.5 ± 0.5% | 375.4 ± 0.4% | 2139.0 ± 0.4% | 533.4 ± 1.8% | 1.641 | 1.444 | 7.934 | 1.393 | 5.584 |
| string: silesia/samba | 97582 | 3510.9 ± 0.4% | 2024.7 ± 0.2% | 2617.6 ± 0.3% | 329.0 ± 0.9% | 1498.0 ± 0.5% | 427.0 ± 0.6% | 1.734 | 1.341 | 10.673 | 2.344 | 8.223 |
| string: silesia/webster | 1098490 | 3666.8 ± 0.4% | 1518.3 ± 0.2% | 2010.7 ± 0.5% | 359.1 ± 0.6% | 2173.1 ± 0.7% | 499.4 ± 3.3% | 2.415 | 1.824 | 10.212 | 1.687 | 7.343 |
| string: silesia/xml | 1090118 | 4804.5 ± 0.4% | 2353.1 ± 0.3% | 2524.6 ± 0.5% | 453.0 ± 1.0% | 2827.4 ± 0.8% | 565.3 ± 1.0% | 2.042 | 1.903 | 10.607 | 1.699 | 8.499 |
| string: canterbury/alice29.txt | 159425 | 4358.0 ± 1.0% | 1600.5 ± 0.4% | 2453.4 ± 0.5% | 342.2 ± 0.4% | 2493.6 ± 0.8% | 504.2 ± 0.9% | 2.723 | 1.776 | 12.733 | 1.748 | 8.643 |
| string: canterbury/asyoulik.txt | 132198 | 3505.8 ± 0.5% | 1459.2 ± 0.2% | 2254.0 ± 0.5% | 335.0 ± 1.6% | 2084.4 ± 0.3% | 461.4 ± 1.0% | 2.403 | 1.555 | 10.467 | 1.682 | 7.598 |
| string: canterbury/lcet10.txt | 441884 | 5126.8 ± 0.3% | 1853.4 ± 0.2% | 2333.3 ± 0.6% | 390.3 ± 0.5% | 2835.1 ± 0.3% | 534.4 ± 0.6% | 2.766 | 2.197 | 13.137 | 1.808 | 9.593 |
| string: canterbury/plrabn12.txt | 503330 | 4136.8 ± 0.5% | 1737.1 ± 0.4% | 2055.2 ± 0.8% | 362.1 ± 0.6% | 2489.2 ± 0.5% | 497.2 ± 0.7% | 2.381 | 2.013 | 11.425 | 1.662 | 8.320 |
| string: canterbury-large/E.coli | 1048578 | 11908.7 ± 0.7% | 3605.5 ± 0.3% | 3243.7 ± 0.5% | 928.5 ± 0.9% | 5936.8 ± 0.6% | 746.8 ± 0.7% | 3.303 | 3.671 | 12.826 | 2.006 | 15.947 |
| string: canterbury-large/bible.txt | 1055886 | 6915.6 ± 1.7% | 2936.3 ± 0.4% | 2829.4 ± 0.6% | 419.2 ± 2.0% | 3732.6 ± 2.4% | 605.6 ± 1.1% | 2.355 | 2.444 | 16.497 | 1.853 | 11.419 |
| string: canterbury-large/world192.txt | 1103121 | 3386.8 ± 0.4% | 1478.9 ± 0.4% | 2013.0 ± 0.3% | 353.1 ± 0.6% | 2112.1 ± 1.8% | 486.7 ± 0.9% | 2.290 | 1.682 | 9.593 | 1.604 | 6.959 |
| string: http/html-1m | 1058582 | 6344.0 ± 1.7% | 2734.1 ± 0.5% | 2697.2 ± 0.7% | 442.2 ± 1.0% | 3461.8 ± 0.3% | 586.6 ± 0.9% | 2.320 | 2.352 | 14.347 | 1.833 | 10.815 |
| string: http/json-1m | 1190272 | 2561.1 ± 0.4% | 877.8 ± 0.1% | 2251.9 ± 0.4% | 390.5 ± 0.1% | 1062.3 ± 0.4% | 428.0 ± 0.9% | 2.918 | 1.137 | 6.558 | 2.411 | 5.983 |
| string: http/js-1m | 1144362 | 2293.4 ± 0.9% | 1028.8 ± 0.8% | 1636.5 ± 0.7% | 321.3 ± 0.4% | 1518.7 ± 0.4% | 406.2 ± 0.6% | 2.229 | 1.401 | 7.138 | 1.510 | 5.647 |
| string: http/css-1m | 1097820 | 2656.9 ± 0.5% | 1678.7 ± 0.5% | 2226.3 ± 0.4% | 406.4 ± 1.1% | 1933.6 ± 0.4% | 475.0 ± 1.3% | 1.583 | 1.193 | 6.537 | 1.374 | 5.593 |
| string: dickens as Cyrillic and CJK | 1883069 | 3082.7 ± 0.4% | 1685.8 ± 0.3% | 895.4 ± 0.6% | 350.4 ± 0.1% | 666.6 ± 0.7% | 156.6 ± 3.7% | 1.829 | 3.443 | 8.798 | 4.625 | 19.688 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.6 ± 0.2% | 980.7 ± 0.1% | 1218.1 ± 0.9% | 216.3 ± 0.1% | 472.2 ± 0.7% | 250.6 ± 4.2% | 1.356 | 1.092 | 6.146 | 2.816 | 5.305 |
| hex: silesia/dickens | 524290 | 12022.9 ± 0.1% | 3607.9 ± 0.2% | 3279.1 ± 0.3% | 506.8 ± 2.2% | 6116.5 ± 1.2% | 781.9 ± 2.8% | 3.332 | 3.667 | 23.724 | 1.966 | 15.376 |
| hex: silesia/mozilla | 524290 | 12013.1 ± 0.3% | 3606.5 ± 0.2% | 3278.6 ± 0.3% | 454.8 ± 1.8% | 6134.4 ± 1.1% | 781.6 ± 0.4% | 3.331 | 3.664 | 26.412 | 1.958 | 15.370 |
| hex: silesia/mr | 524290 | 12001.3 ± 0.2% | 3604.4 ± 0.2% | 3282.4 ± 0.3% | 568.9 ± 0.4% | 6095.9 ± 0.9% | 782.3 ± 0.1% | 3.330 | 3.656 | 21.094 | 1.969 | 15.341 |
| hex: silesia/nci | 524290 | 11996.7 ± 0.2% | 3607.7 ± 0.3% | 3278.5 ± 0.3% | 627.4 ± 2.8% | 6096.9 ± 1.5% | 781.8 ± 0.5% | 3.325 | 3.659 | 19.123 | 1.968 | 15.344 |
| hex: silesia/ooffice | 524290 | 11998.4 ± 0.1% | 3600.7 ± 0.4% | 3286.9 ± 0.2% | 397.7 ± 1.2% | 6078.3 ± 0.6% | 779.8 ± 1.0% | 3.332 | 3.650 | 30.169 | 1.974 | 15.386 |
| hex: silesia/osdb | 524290 | 11880.6 ± 0.3% | 3603.6 ± 0.3% | 3282.7 ± 0.1% | 483.2 ± 0.7% | 6018.2 ± 1.0% | 782.9 ± 0.9% | 3.297 | 3.619 | 24.585 | 1.974 | 15.175 |
| hex: silesia/reymont | 524290 | 12006.9 ± 0.2% | 3604.9 ± 0.3% | 3288.9 ± 0.2% | 528.0 ± 1.5% | 6110.9 ± 1.9% | 782.0 ± 0.2% | 3.331 | 3.651 | 22.740 | 1.965 | 15.353 |
| hex: silesia/samba | 524290 | 12014.5 ± 0.1% | 3610.7 ± 0.3% | 3295.8 ± 0.1% | 410.4 ± 1.6% | 6127.4 ± 1.1% | 782.4 ± 0.5% | 3.327 | 3.645 | 29.278 | 1.961 | 15.356 |
| hex: silesia/sao | 524290 | 12025.5 ± 0.1% | 3606.2 ± 0.3% | 3282.4 ± 0.7% | 346.0 ± 0.8% | 6121.7 ± 1.4% | 781.3 ± 0.6% | 3.335 | 3.664 | 34.760 | 1.964 | 15.391 |
| hex: silesia/webster | 524290 | 11935.3 ± 0.2% | 3605.1 ± 0.3% | 3285.0 ± 0.2% | 471.4 ± 1.9% | 6138.4 ± 1.2% | 781.9 ± 0.4% | 3.311 | 3.633 | 25.318 | 1.944 | 15.264 |
| hex: silesia/x-ray | 524290 | 11958.6 ± 0.2% | 3604.8 ± 0.4% | 3284.6 ± 0.5% | 484.7 ± 0.3% | 6069.1 ± 1.5% | 782.1 ± 0.4% | 3.317 | 3.641 | 24.670 | 1.970 | 15.291 |
| hex: silesia/xml | 524290 | 12017.7 ± 0.1% | 3604.9 ± 0.3% | 3295.2 ± 0.2% | 534.5 ± 0.2% | 6125.3 ± 1.3% | 783.1 ± 0.4% | 3.334 | 3.647 | 22.482 | 1.962 | 15.347 |
| hex: canterbury/alice29.txt | 304180 | 12013.9 ± 0.1% | 3629.6 ± 0.1% | 3357.3 ± 0.3% | 524.0 ± 0.1% | 6097.6 ± 1.0% | 781.7 ± 1.4% | 3.310 | 3.579 | 22.929 | 1.970 | 15.369 |
| hex: canterbury/asyoulik.txt | 250360 | 12004.1 ± 0.1% | 3638.6 ± 0.1% | 3366.0 ± 0.2% | 516.2 ± 0.4% | 6150.2 ± 1.8% | 779.5 ± 0.4% | 3.299 | 3.566 | 23.256 | 1.952 | 15.400 |
| hex: canterbury/cp.html | 49208 | 11905.1 ± 0.0% | 3637.7 ± 0.3% | 3292.6 ± 0.1% | 476.2 ± 2.4% | 6278.7 ± 0.4% | 768.5 ± 0.6% | 3.273 | 3.616 | 25.002 | 1.896 | 15.492 |
| hex: canterbury/fields.c | 22302 | 11778.6 ± 0.0% | 3629.2 ± 0.0% | 3357.2 ± 0.0% | 510.1 ± 0.5% | 6253.3 ± 0.2% | 757.5 ± 2.0% | 3.245 | 3.508 | 23.090 | 1.884 | 15.548 |
| hex: canterbury/grammar.lsp | 7444 | 11315.6 ± 0.7% | 3600.7 ± 0.1% | 3360.0 ± 0.2% | 543.0 ± 1.7% | 6169.6 ± 0.4% | 731.6 ± 1.6% | 3.143 | 3.368 | 20.837 | 1.834 | 15.466 |
| hex: canterbury/kennedy.xls | 524290 | 11922.4 ± 0.2% | 3599.6 ± 0.2% | 3276.7 ± 0.2% | 655.2 ± 3.3% | 6017.7 ± 1.8% | 772.4 ± 4.0% | 3.312 | 3.638 | 18.197 | 1.981 | 15.436 |
| hex: canterbury/lcet10.txt | 524290 | 12024.6 ± 0.1% | 3606.8 ± 0.2% | 3283.5 ± 0.4% | 512.0 ± 0.4% | 6139.3 ± 2.3% | 782.0 ± 0.5% | 3.334 | 3.662 | 23.488 | 1.959 | 15.378 |
| hex: canterbury/plrabn12.txt | 524290 | 12005.4 ± 0.1% | 3609.8 ± 0.3% | 3281.7 ± 0.3% | 503.8 ± 1.0% | 6125.5 ± 1.4% | 782.2 ± 0.3% | 3.326 | 3.658 | 23.830 | 1.960 | 15.348 |
| hex: canterbury/ptt5 | 524290 | 12009.5 ± 0.1% | 3608.4 ± 0.4% | 3286.0 ± 0.3% | 561.2 ± 0.5% | 6139.6 ± 1.5% | 782.3 ± 0.8% | 3.328 | 3.655 | 21.401 | 1.956 | 15.351 |
| hex: canterbury/sum | 76482 | 11909.1 ± 0.2% | 3634.3 ± 0.0% | 3357.3 ± 0.2% | 504.7 ± 1.0% | 6183.0 ± 0.7% | 775.2 ± 0.5% | 3.277 | 3.547 | 23.598 | 1.926 | 15.363 |
| hex: canterbury/xargs.1 | 8456 | 11337.3 ± 0.2% | 3601.7 ± 0.1% | 3347.0 ± 0.1% | 488.1 ± 2.4% | 6146.9 ± 0.5% | 758.0 ± 1.1% | 3.148 | 3.387 | 23.228 | 1.844 | 14.956 |
| hex: canterbury-large/E.coli | 524290 | 11970.3 ± 0.1% | 3611.8 ± 0.2% | 3284.3 ± 0.3% | 688.9 ± 0.2% | 6093.6 ± 0.9% | 781.9 ± 2.4% | 3.314 | 3.645 | 17.376 | 1.964 | 15.309 |
| hex: canterbury-large/bible.txt | 524290 | 12018.7 ± 0.3% | 3608.9 ± 0.2% | 3283.7 ± 0.2% | 518.2 ± 3.0% | 6096.9 ± 1.5% | 780.5 ± 0.5% | 3.330 | 3.660 | 23.193 | 1.971 | 15.399 |
| hex: canterbury-large/world192.txt | 524290 | 12002.9 ± 0.5% | 3608.9 ± 0.3% | 3277.3 ± 0.3% | 491.9 ± 2.3% | 6080.3 ± 1.1% | 781.9 ± 0.7% | 3.326 | 3.662 | 24.400 | 1.974 | 15.351 |
| hex: http/html-1kx1024 | 2099200 | 8755.3 ± 4.1% | 3458.1 ± 0.3% | 2838.7 ± 0.3% | 473.8 ± 0.7% | 5101.9 ± 0.6% | 648.3 ± 0.6% | 2.532 | 3.084 | 18.478 | 1.716 | 13.504 |
| hex: http/html-16kx64 | 2097280 | 11755.4 ± 0.3% | 3605.7 ± 0.1% | 3273.2 ± 0.1% | 478.5 ± 1.3% | 6017.2 ± 0.5% | 754.4 ± 1.0% | 3.260 | 3.591 | 24.568 | 1.954 | 15.582 |
| hex: http/html-1m | 524290 | 11997.9 ± 0.1% | 3604.6 ± 0.4% | 3281.6 ± 0.6% | 497.0 ± 1.7% | 6059.9 ± 0.7% | 761.4 ± 2.3% | 3.328 | 3.656 | 24.140 | 1.980 | 15.757 |
| hex: http/json-1kx1024 | 2099200 | 9096.7 ± 3.7% | 3461.8 ± 0.2% | 2838.2 ± 0.4% | 575.5 ± 0.7% | 5090.2 ± 1.2% | 639.3 ± 4.4% | 2.628 | 3.205 | 15.807 | 1.787 | 14.228 |
| hex: http/json-16kx64 | 2097280 | 11765.2 ± 0.2% | 3608.7 ± 0.2% | 3257.3 ± 0.3% | 573.8 ± 0.3% | 6008.3 ± 0.5% | 749.0 ± 3.9% | 3.260 | 3.612 | 20.504 | 1.958 | 15.708 |
| hex: http/json-1m | 524290 | 11925.4 ± 0.1% | 3606.5 ± 0.4% | 3288.1 ± 0.2% | 594.1 ± 0.8% | 6078.9 ± 1.2% | 767.6 ± 3.8% | 3.307 | 3.627 | 20.074 | 1.962 | 15.535 |
| hex: http/js-1kx1024 | 2099200 | 8796.0 ± 4.2% | 3461.4 ± 0.1% | 2833.3 ± 0.2% | 480.6 ± 0.8% | 5092.6 ± 1.0% | 636.1 ± 4.3% | 2.541 | 3.105 | 18.301 | 1.727 | 13.827 |
| hex: http/js-16kx64 | 2097280 | 11759.6 ± 0.2% | 3603.8 ± 0.2% | 3261.1 ± 0.4% | 483.2 ± 1.6% | 6008.9 ± 0.7% | 750.1 ± 1.7% | 3.263 | 3.606 | 24.335 | 1.957 | 15.678 |
| hex: http/js-1m | 524290 | 11996.8 ± 0.2% | 3611.1 ± 0.3% | 3285.3 ± 0.3% | 502.0 ± 1.8% | 6125.6 ± 0.9% | 780.1 ± 2.1% | 3.322 | 3.652 | 23.898 | 1.958 | 15.379 |
| hex: http/css-1kx1024 | 2099200 | 9075.0 ± 4.4% | 3461.0 ± 0.5% | 2838.6 ± 0.4% | 488.1 ± 0.8% | 5080.7 ± 1.4% | 642.2 ± 1.6% | 2.622 | 3.197 | 18.594 | 1.786 | 14.131 |
| hex: http/css-16kx64 | 2097280 | 11752.6 ± 0.2% | 3606.8 ± 0.2% | 3257.2 ± 0.4% | 496.4 ± 1.6% | 6010.9 ± 0.5% | 750.7 ± 2.5% | 3.258 | 3.608 | 23.674 | 1.955 | 15.656 |
| hex: http/css-1m | 524290 | 12006.8 ± 0.2% | 3610.9 ± 0.2% | 3291.6 ± 0.4% | 499.1 ± 1.8% | 6124.7 ± 2.1% | 780.3 ± 1.3% | 3.325 | 3.648 | 24.058 | 1.960 | 15.387 |
| hex: shuffled/dickens-1m | 524290 | 11995.9 ± 0.1% | 3608.0 ± 0.3% | 3283.2 ± 0.3% | 508.9 ± 1.2% | 6097.3 ± 1.3% | 780.4 ± 0.5% | 3.325 | 3.654 | 23.571 | 1.967 | 15.372 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1353.1 ± 0.1% | 1249.9 ± 0.6% | 1038.2 ± 0.4% | 409.7 ± 0.4% | 447.7 ± 0.2% | 415.0 ± 0.4% | 1.083 | 1.303 | 3.303 | 3.022 | 3.261 |
| qlog records, JSON text sequence | 1467503 | 1052.0 ± 0.3% | 1063.3 ± 0.7% | 785.7 ± 1.6% | 378.6 ± 0.9% | 476.6 ± 0.9% | 278.3 ± 0.9% | 0.989 | 1.339 | 2.779 | 2.207 | 3.780 |
| string: silesia/dickens | 172528 | 6909.1 ± 0.4% | 2808.6 ± 0.5% | 2934.8 ± 0.9% | 429.8 ± 0.6% | 1568.9 ± 0.3% | 1009.4 ± 0.1% | 2.460 | 2.354 | 16.074 | 4.404 | 6.845 |
| string: silesia/nci | 1075110 | 7307.8 ± 0.5% | 3436.4 ± 1.3% | 3096.4 ± 0.5% | 812.0 ± 3.2% | 1852.2 ± 0.2% | 1104.9 ± 0.3% | 2.127 | 2.360 | 8.999 | 3.946 | 6.614 |
| string: silesia/reymont | 1075159 | 3322.1 ± 1.5% | 1979.9 ± 1.6% | 2056.9 ± 0.6% | 449.7 ± 0.7% | 1508.9 ± 1.3% | 949.6 ± 0.6% | 1.678 | 1.615 | 7.387 | 2.202 | 3.498 |
| string: silesia/samba | 97582 | 4207.1 ± 0.8% | 2122.7 ± 0.8% | 3445.6 ± 0.2% | 354.8 ± 0.9% | 1435.9 ± 0.3% | 1054.3 ± 0.4% | 1.982 | 1.221 | 11.856 | 2.930 | 3.990 |
| string: silesia/webster | 1098490 | 4072.8 ± 0.5% | 1875.6 ± 0.3% | 2055.8 ± 0.5% | 441.3 ± 0.6% | 1387.7 ± 0.1% | 647.2 ± 1.2% | 2.171 | 1.981 | 9.230 | 2.935 | 6.293 |
| string: silesia/xml | 1090118 | 6122.6 ± 1.0% | 2868.3 ± 0.6% | 2649.2 ± 0.5% | 611.5 ± 0.6% | 1745.6 ± 0.3% | 920.0 ± 0.3% | 2.135 | 2.311 | 10.012 | 3.507 | 6.655 |
| string: canterbury/alice29.txt | 159425 | 6458.5 ± 0.5% | 2204.7 ± 0.3% | 2760.7 ± 0.8% | 407.9 ± 0.5% | 1463.9 ± 0.4% | 955.3 ± 0.1% | 2.929 | 2.339 | 15.833 | 4.412 | 6.761 |
| string: canterbury/asyoulik.txt | 132198 | 5678.5 ± 1.4% | 1713.1 ± 0.6% | 2378.0 ± 1.0% | 403.9 ± 0.9% | 1335.3 ± 0.4% | 883.5 ± 0.1% | 3.315 | 2.388 | 14.061 | 4.253 | 6.427 |
| string: canterbury/lcet10.txt | 441884 | 6240.2 ± 0.5% | 2563.6 ± 0.5% | 2502.1 ± 2.7% | 468.5 ± 0.7% | 1520.5 ± 0.4% | 980.7 ± 0.6% | 2.434 | 2.494 | 13.321 | 4.104 | 6.363 |
| string: canterbury/plrabn12.txt | 503330 | 5719.4 ± 0.4% | 2057.7 ± 0.4% | 2064.4 ± 0.3% | 423.7 ± 0.6% | 1403.4 ± 0.2% | 928.5 ± 0.4% | 2.779 | 2.771 | 13.498 | 4.075 | 6.160 |
| string: canterbury-large/E.coli | 1048578 | 19174.0 ± 1.6% | 9637.3 ± 1.0% | 3788.0 ± 0.5% | 1473.9 ± 0.5% | 2367.2 ± 0.5% | 1189.2 ± 0.3% | 1.990 | 5.062 | 13.009 | 8.100 | 16.124 |
| string: canterbury-large/bible.txt | 1055886 | 6785.2 ± 0.4% | 4149.9 ± 0.4% | 3060.6 ± 0.8% | 504.3 ± 0.6% | 1985.4 ± 0.4% | 1117.2 ± 0.4% | 1.635 | 2.217 | 13.456 | 3.417 | 6.073 |
| string: canterbury-large/world192.txt | 1103121 | 4058.4 ± 0.4% | 1653.0 ± 0.4% | 1999.4 ± 0.9% | 448.9 ± 0.6% | 1356.6 ± 0.1% | 907.3 ± 0.3% | 2.455 | 2.030 | 9.042 | 2.992 | 4.473 |
| string: http/html-1m | 1058582 | 6781.5 ± 0.3% | 3978.6 ± 0.6% | 3033.1 ± 0.9% | 500.9 ± 0.2% | 1929.3 ± 0.7% | 802.7 ± 0.3% | 1.704 | 2.236 | 13.538 | 3.515 | 8.448 |
| string: http/json-1m | 1190272 | 3155.8 ± 0.5% | 1348.4 ± 0.3% | 1555.5 ± 0.3% | 445.8 ± 0.3% | 962.2 ± 0.1% | 764.3 ± 1.1% | 2.340 | 2.029 | 7.079 | 3.280 | 4.129 |
| string: http/js-1m | 1144362 | 2773.0 ± 0.8% | 1178.2 ± 0.5% | 1620.7 ± 0.7% | 368.6 ± 0.3% | 1092.4 ± 0.5% | 757.2 ± 0.2% | 2.354 | 1.711 | 7.524 | 2.538 | 3.662 |
| string: http/css-1m | 1097820 | 4009.3 ± 0.3% | 1481.0 ± 0.3% | 2151.3 ± 0.4% | 495.9 ± 0.5% | 1367.0 ± 0.3% | 893.9 ± 0.2% | 2.707 | 1.864 | 8.084 | 2.933 | 4.485 |
| string: dickens as Cyrillic and CJK | 1883069 | 3062.8 ± 0.4% | 2338.7 ± 0.6% | 521.2 ± 0.5% | 307.1 ± 0.9% | 563.6 ± 1.1% | 336.0 ± 0.6% | 1.310 | 5.877 | 9.972 | 5.435 | 9.117 |
| hex: silesia/dickens | 524290 | 15631.5 ± 1.1% | 1456.3 ± 0.3% | 1081.7 ± 0.5% | 499.1 ± 1.0% | 984.9 ± 0.7% | 734.1 ± 0.5% | 10.734 | 14.451 | 31.319 | 15.871 | 21.293 |
| hex: silesia/mozilla | 524290 | 15584.6 ± 0.6% | 1470.4 ± 0.3% | 1085.1 ± 0.4% | 442.2 ± 1.2% | 991.1 ± 0.3% | 734.4 ± 0.4% | 10.599 | 14.362 | 35.245 | 15.724 | 21.220 |
| hex: silesia/mr | 524290 | 15529.8 ± 0.3% | 1474.7 ± 0.3% | 1089.0 ± 0.4% | 543.7 ± 4.9% | 990.9 ± 0.7% | 731.7 ± 0.5% | 10.531 | 14.261 | 28.563 | 15.672 | 21.223 |
| hex: silesia/nci | 524290 | 15547.7 ± 0.8% | 1472.7 ± 0.4% | 1084.7 ± 0.5% | 631.5 ± 4.7% | 992.7 ± 0.3% | 732.3 ± 0.4% | 10.557 | 14.334 | 24.620 | 15.662 | 21.230 |
| hex: silesia/ooffice | 524290 | 15609.7 ± 0.3% | 1459.1 ± 0.5% | 1080.7 ± 0.5% | 387.8 ± 0.2% | 983.8 ± 0.7% | 732.1 ± 0.9% | 10.698 | 14.445 | 40.247 | 15.867 | 21.321 |
| hex: silesia/osdb | 524290 | 15587.1 ± 0.3% | 1465.6 ± 0.3% | 1083.2 ± 0.2% | 465.7 ± 1.5% | 987.6 ± 0.7% | 731.2 ± 0.6% | 10.635 | 14.390 | 33.474 | 15.784 | 21.316 |
| hex: silesia/reymont | 524290 | 15641.6 ± 0.4% | 1461.8 ± 0.7% | 1082.6 ± 0.3% | 512.7 ± 1.0% | 985.6 ± 0.9% | 733.9 ± 0.8% | 10.700 | 14.448 | 30.510 | 15.871 | 21.312 |
| hex: silesia/samba | 524290 | 15640.2 ± 0.8% | 1462.3 ± 0.3% | 1083.6 ± 0.4% | 402.7 ± 0.5% | 987.8 ± 0.3% | 732.2 ± 0.9% | 10.695 | 14.433 | 38.838 | 15.833 | 21.360 |
| hex: silesia/sao | 524290 | 15639.8 ± 0.4% | 1460.5 ± 0.2% | 1082.2 ± 0.3% | 332.5 ± 0.5% | 986.9 ± 0.3% | 734.0 ± 0.1% | 10.708 | 14.452 | 47.041 | 15.847 | 21.307 |
| hex: silesia/webster | 524290 | 15685.7 ± 1.0% | 1460.4 ± 0.3% | 1082.5 ± 0.5% | 474.2 ± 0.7% | 991.5 ± 0.6% | 733.4 ± 0.5% | 10.741 | 14.490 | 33.081 | 15.820 | 21.389 |
| hex: silesia/x-ray | 524290 | 15628.4 ± 0.4% | 1470.6 ± 0.5% | 1086.5 ± 0.3% | 443.2 ± 1.1% | 991.0 ± 0.4% | 732.7 ± 0.8% | 10.627 | 14.385 | 35.266 | 15.771 | 21.330 |
| hex: silesia/xml | 524290 | 15668.2 ± 0.1% | 1465.9 ± 0.2% | 1085.5 ± 0.2% | 609.2 ± 0.9% | 988.6 ± 0.3% | 730.7 ± 0.5% | 10.689 | 14.434 | 25.717 | 15.849 | 21.444 |
| hex: canterbury/alice29.txt | 304180 | 15691.9 ± 0.1% | 1475.8 ± 0.5% | 1090.6 ± 0.4% | 502.9 ± 0.5% | 994.8 ± 0.5% | 735.4 ± 0.3% | 10.633 | 14.388 | 31.201 | 15.773 | 21.339 |
| hex: canterbury/asyoulik.txt | 250360 | 15718.6 ± 0.1% | 1480.0 ± 0.5% | 1093.6 ± 0.3% | 496.2 ± 0.8% | 994.8 ± 0.4% | 740.6 ± 0.3% | 10.621 | 14.373 | 31.679 | 15.800 | 21.224 |
| hex: canterbury/cp.html | 49208 | 15667.6 ± 0.1% | 1477.8 ± 0.2% | 1097.7 ± 0.2% | 525.2 ± 1.9% | 1004.1 ± 0.6% | 742.0 ± 0.2% | 10.602 | 14.273 | 29.833 | 15.604 | 21.116 |
| hex: canterbury/fields.c | 22302 | 15521.8 ± 0.0% | 1410.5 ± 0.7% | 1060.3 ± 0.3% | 620.9 ± 5.1% | 987.7 ± 0.2% | 736.3 ± 0.1% | 11.005 | 14.639 | 25.000 | 15.715 | 21.082 |
| hex: canterbury/grammar.lsp | 7444 | 15153.8 ± 0.4% | 1507.5 ± 0.3% | 1092.7 ± 0.3% | 659.4 ± 4.0% | 995.9 ± 0.1% | 725.4 ± 0.1% | 10.052 | 13.869 | 22.983 | 15.216 | 20.889 |
| hex: canterbury/kennedy.xls | 524290 | 15637.4 ± 0.5% | 1471.0 ± 0.2% | 1088.7 ± 0.2% | 653.3 ± 1.1% | 990.4 ± 0.3% | 733.7 ± 0.3% | 10.631 | 14.364 | 23.937 | 15.788 | 21.313 |
| hex: canterbury/lcet10.txt | 524290 | 15605.3 ± 0.4% | 1462.0 ± 0.3% | 1083.5 ± 0.7% | 502.9 ± 0.5% | 987.5 ± 0.5% | 734.1 ± 0.3% | 10.674 | 14.402 | 31.028 | 15.803 | 21.257 |
| hex: canterbury/plrabn12.txt | 524290 | 15630.8 ± 0.4% | 1460.2 ± 0.2% | 1084.3 ± 0.4% | 493.2 ± 0.6% | 990.1 ± 0.7% | 735.0 ± 0.5% | 10.705 | 14.416 | 31.696 | 15.787 | 21.266 |
| hex: canterbury/ptt5 | 524290 | 15609.3 ± 0.4% | 1478.3 ± 0.2% | 1091.4 ± 0.3% | 557.1 ± 0.9% | 993.9 ± 0.7% | 733.4 ± 0.5% | 10.559 | 14.302 | 28.021 | 15.705 | 21.282 |
| hex: canterbury/sum | 76482 | 15678.5 ± 0.0% | 1494.4 ± 0.1% | 1104.3 ± 0.1% | 601.7 ± 2.4% | 998.4 ± 0.1% | 743.9 ± 0.1% | 10.491 | 14.197 | 26.055 | 15.704 | 21.075 |
| hex: canterbury/xargs.1 | 8456 | 15203.3 ± 0.1% | 1494.0 ± 0.4% | 1088.9 ± 1.3% | 647.9 ± 3.0% | 993.9 ± 0.3% | 727.8 ± 0.1% | 10.176 | 13.962 | 23.464 | 15.297 | 20.889 |
| hex: canterbury-large/E.coli | 524290 | 15651.5 ± 0.3% | 1468.3 ± 0.7% | 1088.2 ± 0.3% | 672.3 ± 0.4% | 990.9 ± 0.6% | 733.4 ± 0.6% | 10.659 | 14.383 | 23.282 | 15.796 | 21.342 |
| hex: canterbury-large/bible.txt | 524290 | 15523.6 ± 0.7% | 1457.9 ± 0.3% | 1081.8 ± 0.4% | 513.7 ± 1.0% | 986.4 ± 0.7% | 733.9 ± 0.8% | 10.648 | 14.350 | 30.217 | 15.737 | 21.152 |
| hex: canterbury-large/world192.txt | 524290 | 15584.4 ± 0.6% | 1459.7 ± 1.4% | 1081.6 ± 1.3% | 501.8 ± 0.5% | 989.4 ± 0.4% | 733.1 ± 0.4% | 10.677 | 14.409 | 31.059 | 15.752 | 21.258 |
| hex: http/html-1kx1024 | 2099200 | 14113.8 ± 1.1% | 1453.7 ± 0.2% | 1062.0 ± 0.1% | 501.8 ± 0.2% | 982.1 ± 0.4% | 691.8 ± 0.2% | 9.709 | 13.290 | 28.129 | 14.371 | 20.403 |
| hex: http/html-16kx64 | 2097280 | 15307.8 ± 0.9% | 1443.6 ± 0.7% | 1075.1 ± 0.2% | 507.4 ± 0.4% | 995.0 ± 0.4% | 733.4 ± 0.3% | 10.604 | 14.239 | 30.166 | 15.385 | 20.872 |
| hex: http/html-1m | 524290 | 15635.9 ± 0.4% | 1460.5 ± 0.3% | 1082.3 ± 0.4% | 499.4 ± 0.5% | 986.7 ± 0.3% | 732.4 ± 0.3% | 10.706 | 14.447 | 31.307 | 15.846 | 21.350 |
| hex: http/json-1kx1024 | 2099200 | 14105.9 ± 0.7% | 1463.3 ± 0.1% | 1068.1 ± 0.2% | 608.2 ± 0.1% | 986.1 ± 0.2% | 692.0 ± 0.2% | 9.640 | 13.206 | 23.194 | 14.305 | 20.383 |
| hex: http/json-16kx64 | 2097280 | 15284.2 ± 0.4% | 1444.2 ± 0.1% | 1073.5 ± 0.2% | 614.9 ± 0.7% | 994.0 ± 0.3% | 733.5 ± 0.2% | 10.583 | 14.238 | 24.858 | 15.376 | 20.838 |
| hex: http/json-1m | 524290 | 15618.9 ± 0.8% | 1467.3 ± 0.7% | 1085.1 ± 0.5% | 634.5 ± 1.1% | 991.4 ± 0.8% | 733.8 ± 0.5% | 10.645 | 14.394 | 24.616 | 15.755 | 21.286 |
| hex: http/js-1kx1024 | 2099200 | 14133.0 ± 0.7% | 1454.0 ± 0.2% | 1063.6 ± 1.1% | 500.7 ± 0.1% | 983.2 ± 0.3% | 691.8 ± 0.2% | 9.720 | 13.289 | 28.229 | 14.375 | 20.431 |
| hex: http/js-16kx64 | 2097280 | 15281.1 ± 0.2% | 1439.7 ± 0.1% | 1074.2 ± 0.2% | 505.0 ± 0.4% | 994.7 ± 0.4% | 733.6 ± 0.1% | 10.614 | 14.225 | 30.263 | 15.363 | 20.829 |
| hex: http/js-1m | 524290 | 15679.0 ± 0.3% | 1461.5 ± 0.4% | 1083.3 ± 0.4% | 511.3 ± 0.5% | 987.1 ± 0.3% | 733.4 ± 0.7% | 10.728 | 14.474 | 30.663 | 15.884 | 21.378 |
| hex: http/css-1kx1024 | 2099200 | 14096.7 ± 0.6% | 1456.2 ± 0.3% | 1063.0 ± 0.1% | 531.9 ± 0.4% | 983.3 ± 0.2% | 692.2 ± 0.2% | 9.680 | 13.261 | 26.502 | 14.336 | 20.366 |
| hex: http/css-16kx64 | 2097280 | 15274.8 ± 0.4% | 1440.8 ± 0.2% | 1073.8 ± 0.2% | 540.0 ± 0.3% | 998.5 ± 0.6% | 733.9 ± 0.2% | 10.601 | 14.224 | 28.287 | 15.298 | 20.813 |
| hex: http/css-1m | 524290 | 15629.9 ± 0.6% | 1464.5 ± 0.5% | 1082.4 ± 0.4% | 528.4 ± 0.5% | 992.7 ± 0.4% | 735.0 ± 0.5% | 10.672 | 14.440 | 29.579 | 15.744 | 21.265 |
| hex: shuffled/dickens-1m | 524290 | 15487.7 ± 0.2% | 1461.5 ± 0.4% | 1082.9 ± 0.5% | 501.1 ± 0.7% | 992.1 ± 0.5% | 732.3 ± 0.8% | 10.597 | 14.302 | 30.909 | 15.611 | 21.150 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.916 of yyjson.
