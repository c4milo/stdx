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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43625781498 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1129.6 ± 0.3% | 0.523 | 0.964 | 0.997 | 0.998 | 0.459 | 1.002 | 1.004 | 0.387 | 0.829 | 0.897 | 0.101 |
| qlog records, JSON text sequence | 1467503 | 852.2 ± 0.4% | 0.823 | 1.005 | 1.002 | 1.003 | 0.447 | 1.000 | 1.031 | 0.400 | 0.924 | 0.988 | 0.125 |
| string: silesia/dickens | 172528 | 5048.9 ± 0.4% | 0.033 | 0.782 | 1.002 | 1.002 | 0.196 | 1.004 | 1.005 | 0.196 | 1.000 | 0.997 | 0.032 |
| string: silesia/nci | 1075110 | 4294.4 ± 0.7% | 0.039 | 0.803 | 1.004 | 1.003 | 0.280 | 1.008 | 0.998 | 0.279 | 1.004 | 1.004 | 0.038 |
| string: silesia/reymont | 1075159 | 2932.8 ± 2.7% | 0.057 | 0.821 | 0.995 | 1.001 | 0.360 | 1.005 | 1.010 | 0.360 | 1.022 | 1.023 | 0.057 |
| string: silesia/samba | 97582 | 3500.7 ± 0.7% | 0.040 | 0.861 | 1.001 | 1.002 | 0.068 | 0.778 | 1.009 | 0.072 | 1.001 | 1.004 | 0.039 |
| string: silesia/webster | 1098490 | 3637.2 ± 1.3% | 0.045 | 0.850 | 1.006 | 1.010 | 0.204 | 1.021 | 1.019 | 0.204 | 1.012 | 1.009 | 0.044 |
| string: silesia/xml | 1090118 | 4794.1 ± 0.7% | 0.035 | 0.805 | 1.003 | 1.007 | 0.222 | 0.980 | 1.005 | 0.223 | 1.004 | 1.006 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4301.7 ± 1.0% | 0.038 | 0.752 | 1.005 | 1.011 | 0.172 | 1.038 | 1.022 | 0.172 | 1.010 | 1.012 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3455.7 ± 0.7% | 0.046 | 0.749 | 1.003 | 1.007 | 0.176 | 1.008 | 0.974 | 0.176 | 1.008 | 1.009 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5112.7 ± 0.2% | 0.032 | 0.816 | 1.003 | 1.005 | 0.195 | 1.021 | 1.007 | 0.194 | 1.006 | 1.005 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4135.8 ± 0.8% | 0.040 | 0.822 | 0.999 | 0.998 | 0.198 | 1.008 | 0.991 | 0.197 | 1.000 | 1.000 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19187.9 ± 1.0% | 0.077 | 1.011 | 1.011 | 1.009 | 0.485 | 1.010 | 1.008 | 0.486 | 0.623 | 0.623 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6637.0 ± 1.8% | 0.026 | 0.810 | 1.008 | 1.011 | 0.436 | 1.039 | 1.051 | 0.436 | 1.050 | 1.053 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3379.4 ± 0.3% | 0.048 | 0.849 | 1.003 | 1.006 | 0.198 | 1.015 | 1.010 | 0.198 | 1.005 | 1.004 | 0.047 |
| string: http/html-1m | 1058582 | 6056.3 ± 1.4% | 0.028 | 0.787 | 1.007 | 1.044 | 0.390 | 1.036 | 1.052 | 0.390 | 1.029 | 1.036 | 0.028 |
| string: http/json-1m | 1190272 | 2547.1 ± 0.5% | 0.056 | 0.952 | 1.005 | 1.005 | 0.111 | 1.007 | 0.471 | 0.111 | 1.005 | 1.005 | 0.055 |
| string: http/js-1m | 1144362 | 2281.6 ± 0.4% | 0.067 | 0.890 | 1.005 | 1.006 | 0.174 | 1.056 | 1.047 | 0.174 | 1.003 | 1.003 | 0.066 |
| string: http/css-1m | 1097820 | 2639.8 ± 0.5% | 0.061 | 0.777 | 1.005 | 1.008 | 0.240 | 1.008 | 1.016 | 0.239 | 1.005 | 1.009 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3079.6 ± 0.7% | 0.044 | 0.124 | 1.001 | 1.000 | 0.335 | 0.997 | 1.006 | 0.335 | 1.001 | 1.001 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.7 ± 1.9% | 0.081 | 1.003 | 1.001 | 1.002 | 0.076 | 0.638 | 1.004 | 0.081 | 1.002 | 1.001 | 0.081 |
| hex: silesia/dickens | 524290 | 18998.7 ± 0.9% | 0.078 | 1.005 | 0.996 | 0.993 | 0.509 | 0.997 | 0.999 | 0.508 | 0.633 | 0.633 | 0.009 |
| hex: silesia/mozilla | 524290 | 19167.7 ± 0.8% | 0.078 | 0.999 | 0.999 | 0.994 | 0.501 | 1.002 | 0.995 | 0.501 | 0.626 | 0.626 | 0.009 |
| hex: silesia/mr | 524290 | 18966.9 ± 1.2% | 0.079 | 0.996 | 0.996 | 0.993 | 0.517 | 0.997 | 0.995 | 0.518 | 0.633 | 0.633 | 0.009 |
| hex: silesia/nci | 524290 | 18841.3 ± 0.2% | 0.079 | 1.005 | 0.998 | 1.001 | 0.513 | 0.998 | 1.000 | 0.512 | 0.637 | 0.637 | 0.009 |
| hex: silesia/ooffice | 524290 | 18905.2 ± 0.4% | 0.079 | 1.002 | 1.000 | 1.002 | 0.507 | 1.002 | 1.004 | 0.507 | 0.635 | 0.635 | 0.009 |
| hex: silesia/osdb | 524290 | 18652.4 ± 0.3% | 0.080 | 1.003 | 1.003 | 1.004 | 0.516 | 1.002 | 1.003 | 0.515 | 0.643 | 0.643 | 0.009 |
| hex: silesia/reymont | 524290 | 18806.7 ± 1.1% | 0.079 | 1.011 | 1.002 | 1.002 | 0.521 | 1.003 | 1.002 | 0.520 | 0.639 | 0.639 | 0.009 |
| hex: silesia/samba | 524290 | 18488.7 ± 0.9% | 0.080 | 1.009 | 1.009 | 1.009 | 0.526 | 1.005 | 1.008 | 0.529 | 0.650 | 0.650 | 0.009 |
| hex: silesia/sao | 524290 | 19031.6 ± 0.5% | 0.078 | 0.997 | 0.993 | 0.996 | 0.502 | 0.996 | 0.996 | 0.502 | 0.630 | 0.630 | 0.009 |
| hex: silesia/webster | 524290 | 19004.2 ± 0.3% | 0.078 | 1.006 | 1.000 | 0.998 | 0.508 | 1.000 | 0.991 | 0.505 | 0.631 | 0.631 | 0.009 |
| hex: silesia/x-ray | 524290 | 18756.8 ± 0.5% | 0.079 | 1.002 | 1.006 | 1.006 | 0.518 | 1.004 | 1.005 | 0.519 | 0.639 | 0.640 | 0.009 |
| hex: silesia/xml | 524290 | 18902.6 ± 0.5% | 0.079 | 1.003 | 0.997 | 0.997 | 0.511 | 0.999 | 1.002 | 0.512 | 0.636 | 0.635 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19475.3 ± 0.3% | 0.077 | 1.005 | 1.003 | 1.003 | 0.515 | 1.005 | 0.999 | 0.515 | 0.616 | 0.617 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19527.3 ± 0.2% | 0.077 | 1.003 | 1.002 | 1.002 | 0.513 | 1.003 | 1.002 | 0.514 | 0.614 | 0.615 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19184.1 ± 0.8% | 0.081 | 1.005 | 1.005 | 1.004 | 0.542 | 1.004 | 1.005 | 0.543 | 0.621 | 0.621 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18902.5 ± 0.3% | 0.084 | 1.002 | 1.004 | 1.003 | 0.534 | 0.999 | 1.003 | 0.540 | 0.623 | 0.623 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17437.4 ± 4.0% | 0.089 | 1.009 | 1.009 | 1.009 | 0.529 | 1.008 | 1.009 | 0.549 | 0.645 | 0.645 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18605.2 ± 0.7% | 0.080 | 1.012 | 1.010 | 1.009 | 0.516 | 1.005 | 1.011 | 0.519 | 0.646 | 0.646 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18907.3 ± 2.1% | 0.079 | 1.012 | 1.000 | 0.998 | 0.509 | 0.994 | 0.997 | 0.510 | 0.635 | 0.635 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18756.4 ± 1.1% | 0.079 | 1.000 | 1.001 | 1.003 | 0.514 | 1.003 | 1.004 | 0.515 | 0.640 | 0.640 | 0.009 |
| hex: canterbury/ptt5 | 524290 | 18994.8 ± 1.7% | 0.078 | 1.009 | 1.006 | 0.998 | 0.508 | 1.004 | 1.000 | 0.511 | 0.633 | 0.632 | 0.009 |
| hex: canterbury/sum | 76482 | 19284.4 ± 0.5% | 0.077 | 1.002 | 1.002 | 1.002 | 0.517 | 1.002 | 1.002 | 0.519 | 0.617 | 0.617 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17801.6 ± 0.1% | 0.087 | 1.001 | 1.002 | 1.002 | 0.524 | 1.001 | 1.001 | 0.541 | 0.637 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18807.9 ± 0.4% | 0.079 | 1.013 | 1.005 | 1.002 | 0.510 | 0.998 | 0.996 | 0.511 | 0.636 | 0.636 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 19055.5 ± 1.4% | 0.078 | 1.007 | 1.004 | 1.001 | 0.504 | 1.006 | 1.003 | 0.505 | 0.630 | 0.630 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 18530.7 ± 1.1% | 0.080 | 1.007 | 1.014 | 1.011 | 0.518 | 1.007 | 1.008 | 0.519 | 0.646 | 0.647 | 0.009 |
| hex: http/html-1kx1024 | 2099200 | 9606.4 ± 15.3% | 0.148 | 1.261 | 1.258 | 1.261 | 0.689 | 1.264 | 0.985 | 0.753 | 0.919 | 0.929 | 0.018 |
| hex: http/html-16kx64 | 2097280 | 18365.5 ± 1.3% | 0.082 | 1.017 | 1.015 | 1.016 | 0.557 | 1.015 | 1.002 | 0.563 | 0.642 | 0.642 | 0.009 |
| hex: http/html-1m | 524290 | 18870.1 ± 0.3% | 0.079 | 1.006 | 1.005 | 1.006 | 0.506 | 1.002 | 1.003 | 0.505 | 0.633 | 0.635 | 0.009 |
| hex: http/json-1kx1024 | 2099200 | 9842.4 ± 15.6% | 0.145 | 1.235 | 1.233 | 1.238 | 0.672 | 1.233 | 0.980 | 0.743 | 0.897 | 0.907 | 0.017 |
| hex: http/json-16kx64 | 2097280 | 18331.5 ± 1.4% | 0.083 | 1.017 | 1.017 | 1.017 | 0.558 | 1.017 | 1.003 | 0.565 | 0.643 | 0.642 | 0.009 |
| hex: http/json-1m | 524290 | 18656.6 ± 1.1% | 0.080 | 1.014 | 1.003 | 1.003 | 0.525 | 1.009 | 1.008 | 0.523 | 0.645 | 0.645 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 9900.2 ± 18.5% | 0.144 | 1.225 | 1.228 | 1.229 | 0.673 | 1.226 | 0.975 | 0.739 | 0.902 | 0.909 | 0.017 |
| hex: http/js-16kx64 | 2097280 | 18429.3 ± 0.9% | 0.081 | 1.010 | 1.008 | 1.009 | 0.555 | 1.010 | 0.996 | 0.561 | 0.639 | 0.639 | 0.009 |
| hex: http/js-1m | 524290 | 19105.8 ± 1.4% | 0.078 | 1.005 | 1.005 | 1.003 | 0.500 | 1.004 | 0.999 | 0.502 | 0.627 | 0.628 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9956.5 ± 15.9% | 0.143 | 1.232 | 1.230 | 1.229 | 0.670 | 1.239 | 0.969 | 0.741 | 0.901 | 0.903 | 0.017 |
| hex: http/css-16kx64 | 2097280 | 18454.6 ± 1.4% | 0.081 | 1.013 | 1.010 | 1.010 | 0.554 | 1.010 | 0.996 | 0.561 | 0.638 | 0.638 | 0.009 |
| hex: http/css-1m | 524290 | 19010.9 ± 1.6% | 0.078 | 1.009 | 1.008 | 0.999 | 0.504 | 1.010 | 1.002 | 0.504 | 0.629 | 0.630 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18576.1 ± 0.7% | 0.080 | 1.001 | 1.002 | 1.001 | 0.524 | 1.003 | 1.002 | 0.525 | 0.647 | 0.647 | 0.009 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1493.6 ± 1.1% | 0.442 | 1.001 | 0.966 | 1.005 | 1.006 | 0.267 | 1.000 | 0.544 | 0.913 | 0.088 | 1.027 |
| qlog records, JSON text sequence | 1467503 | 1271.6 ± 1.3% | 0.690 | 0.977 | 1.011 | 1.012 | 1.012 | 0.264 | 1.002 | 0.502 | 0.828 | 0.106 | 1.020 |
| string: silesia/dickens | 172528 | 6876.4 ± 0.2% | 0.025 | 1.001 | 1.001 | 1.001 | 1.002 | 0.167 | 0.717 | 1.004 | 1.004 | 0.025 | 1.035 |
| string: silesia/nci | 1075110 | 7308.9 ± 0.8% | 0.023 | 1.004 | 1.003 | 1.003 | 1.003 | 0.212 | 0.565 | 1.002 | 1.001 | 0.024 | 1.013 |
| string: silesia/reymont | 1075159 | 3318.8 ± 1.1% | 0.052 | 1.008 | 0.998 | 1.012 | 1.010 | 0.393 | 0.873 | 1.002 | 1.003 | 0.052 | 1.052 |
| string: silesia/samba | 97582 | 4186.9 ± 0.7% | 0.053 | 1.004 | 0.999 | 1.003 | 1.005 | 0.125 | 0.942 | 1.003 | 1.006 | 0.054 | 1.097 |
| string: silesia/webster | 1098490 | 4061.5 ± 0.4% | 0.043 | 1.006 | 1.006 | 1.008 | 1.007 | 0.212 | 0.887 | 0.997 | 1.004 | 0.043 | 1.007 |
| string: silesia/xml | 1090118 | 6113.0 ± 0.7% | 0.029 | 1.003 | 0.997 | 1.003 | 1.006 | 0.254 | 0.778 | 1.002 | 1.005 | 0.029 | 1.019 |
| string: canterbury/alice29.txt | 159425 | 6401.1 ± 0.7% | 0.026 | 1.010 | 1.011 | 1.013 | 1.014 | 0.132 | 0.658 | 1.004 | 1.006 | 0.027 | 1.064 |
| string: canterbury/asyoulik.txt | 132198 | 5591.4 ± 0.3% | 0.030 | 1.025 | 1.031 | 1.032 | 1.034 | 0.129 | 0.596 | 1.005 | 1.014 | 0.030 | 1.049 |
| string: canterbury/lcet10.txt | 441884 | 6232.3 ± 0.8% | 0.028 | 1.007 | 1.008 | 1.007 | 1.009 | 0.185 | 0.802 | 1.004 | 1.006 | 0.028 | 1.003 |
| string: canterbury/plrabn12.txt | 503330 | 5724.2 ± 0.4% | 0.030 | 1.001 | 1.003 | 1.002 | 1.002 | 0.168 | 0.698 | 1.002 | 1.002 | 0.030 | 1.005 |
| string: canterbury-large/E.coli | 1048578 | 19390.1 ± 0.6% | 0.077 | 0.999 | 0.999 | 0.999 | 1.000 | 0.482 | 0.998 | 0.999 | 0.997 | 0.009 | 0.998 |
| string: canterbury-large/bible.txt | 1055886 | 6803.4 ± 0.7% | 0.025 | 1.002 | 1.000 | 1.001 | 1.000 | 0.496 | 0.975 | 1.001 | 1.000 | 0.026 | 1.000 |
| string: canterbury-large/world192.txt | 1103121 | 4023.9 ± 0.5% | 0.042 | 1.020 | 1.018 | 1.020 | 1.019 | 0.193 | 0.833 | 1.002 | 1.012 | 0.043 | 1.004 |
| string: http/html-1m | 1058582 | 6749.6 ± 1.2% | 0.026 | 1.006 | 0.926 | 1.007 | 1.010 | 0.405 | 0.898 | 1.003 | 1.006 | 0.026 | 1.012 |
| string: http/json-1m | 1190272 | 3158.9 ± 0.3% | 0.051 | 1.005 | 0.970 | 1.003 | 1.007 | 0.133 | 0.371 | 1.003 | 1.004 | 0.051 | 1.046 |
| string: http/js-1m | 1144362 | 2768.8 ± 0.6% | 0.060 | 1.005 | 1.005 | 1.002 | 1.007 | 0.165 | 0.840 | 1.000 | 1.005 | 0.061 | 1.017 |
| string: http/css-1m | 1097820 | 3990.3 ± 1.2% | 0.042 | 1.004 | 1.006 | 1.008 | 1.009 | 0.208 | 0.644 | 1.000 | 1.006 | 0.043 | 1.012 |
| string: dickens as Cyrillic and CJK | 1883069 | 3073.9 ± 0.4% | 0.048 | 1.000 | 0.124 | 1.001 | 1.002 | 0.320 | 1.003 | 0.999 | 0.999 | 0.048 | 1.002 |
| hex: silesia/dickens | 524290 | 15677.7 ± 0.2% | 1.000 | 0.178 | 1.000 | 1.002 | 1.000 | 0.999 | 0.999 | 0.997 | 0.999 | 0.177 | 1.001 |
| hex: silesia/mozilla | 524290 | 15661.4 ± 0.9% | 1.001 | 0.178 | 0.997 | 0.997 | 0.999 | 0.996 | 0.998 | 0.997 | 0.998 | 0.178 | 0.997 |
| hex: silesia/mr | 524290 | 15658.7 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.000 | 1.000 | 1.002 | 1.001 | 1.002 | 1.002 | 0.178 | 1.002 |
| hex: silesia/nci | 524290 | 15647.5 ± 0.5% | 0.999 | 0.178 | 0.999 | 1.001 | 1.001 | 1.000 | 1.001 | 1.000 | 1.000 | 0.178 | 1.001 |
| hex: silesia/ooffice | 524290 | 15626.5 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.002 | 1.002 | 1.000 | 1.000 | 0.998 | 0.997 | 0.178 | 0.999 |
| hex: silesia/osdb | 524290 | 15610.6 ± 0.3% | 1.002 | 0.178 | 0.999 | 1.000 | 0.999 | 1.000 | 1.000 | 0.999 | 1.000 | 0.178 | 1.000 |
| hex: silesia/reymont | 524290 | 15675.0 ± 0.2% | 0.999 | 0.177 | 1.000 | 1.001 | 0.999 | 0.999 | 0.998 | 0.999 | 1.000 | 0.177 | 0.999 |
| hex: silesia/samba | 524290 | 15663.5 ± 0.3% | 1.002 | 0.178 | 1.001 | 0.999 | 1.000 | 1.001 | 1.001 | 1.002 | 1.001 | 0.177 | 0.999 |
| hex: silesia/sao | 524290 | 15670.4 ± 0.3% | 1.001 | 0.178 | 1.000 | 1.000 | 1.001 | 1.000 | 1.000 | 1.000 | 1.000 | 0.177 | 1.001 |
| hex: silesia/webster | 524290 | 15683.6 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.001 | 1.000 | 1.000 | 0.998 | 1.001 | 1.000 | 0.177 | 1.000 |
| hex: silesia/x-ray | 524290 | 15631.2 ± 0.2% | 1.000 | 0.178 | 1.001 | 1.000 | 0.999 | 1.000 | 1.001 | 0.999 | 1.000 | 0.178 | 1.002 |
| hex: silesia/xml | 524290 | 15646.8 ± 0.1% | 1.001 | 0.178 | 0.999 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 1.001 | 0.178 | 1.000 |
| hex: canterbury/alice29.txt | 304180 | 15664.7 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15704.6 ± 0.0% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15618.6 ± 0.2% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.998 | 1.001 | 1.001 | 1.002 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15438.8 ± 0.1% | 1.002 | 0.181 | 1.001 | 1.000 | 1.000 | 0.994 | 1.000 | 1.002 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14947.2 ± 0.1% | 1.003 | 0.185 | 1.000 | 1.000 | 1.000 | 0.983 | 1.000 | 1.004 | 1.014 | 0.184 | 1.003 |
| hex: canterbury/kennedy.xls | 524290 | 15630.0 ± 0.2% | 1.001 | 0.178 | 0.999 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 0.178 | 1.000 |
| hex: canterbury/lcet10.txt | 524290 | 15635.1 ± 0.3% | 1.001 | 0.178 | 1.001 | 1.001 | 1.000 | 1.000 | 1.000 | 1.001 | 1.000 | 0.178 | 1.002 |
| hex: canterbury/plrabn12.txt | 524290 | 15654.3 ± 0.4% | 1.002 | 0.178 | 1.001 | 1.000 | 1.000 | 1.001 | 1.001 | 1.002 | 1.002 | 0.177 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 15612.6 ± 0.2% | 1.002 | 0.179 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 0.999 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/sum | 76482 | 15643.9 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 1.000 | 1.002 | 0.178 | 1.000 |
| hex: canterbury/xargs.1 | 8456 | 15018.8 ± 0.1% | 1.001 | 0.185 | 1.000 | 1.000 | 1.000 | 0.984 | 1.001 | 1.002 | 1.012 | 0.183 | 1.002 |
| hex: canterbury-large/E.coli | 524290 | 15654.7 ± 0.1% | 1.000 | 0.178 | 1.001 | 1.001 | 1.001 | 0.999 | 0.999 | 0.999 | 1.000 | 0.178 | 1.000 |
| hex: canterbury-large/bible.txt | 524290 | 15588.2 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.000 | 0.999 | 1.001 | 1.002 | 1.002 | 0.178 | 1.000 |
| hex: canterbury-large/world192.txt | 524290 | 15627.5 ± 0.2% | 1.001 | 0.178 | 1.000 | 1.001 | 0.999 | 0.999 | 1.001 | 1.000 | 1.001 | 0.178 | 1.000 |
| hex: http/html-1kx1024 | 2099200 | 13678.6 ± 0.6% | 1.006 | 0.195 | 1.001 | 1.002 | 1.001 | 0.946 | 1.002 | 1.014 | 1.041 | 0.187 | 1.014 |
| hex: http/html-16kx64 | 2097280 | 15230.1 ± 0.6% | 1.001 | 0.181 | 1.000 | 1.001 | 1.002 | 0.995 | 1.000 | 1.002 | 1.007 | 0.179 | 1.004 |
| hex: http/html-1m | 524290 | 15672.3 ± 0.1% | 1.000 | 0.177 | 1.000 | 1.001 | 1.001 | 1.000 | 1.001 | 1.000 | 1.000 | 0.177 | 1.001 |
| hex: http/json-1kx1024 | 2099200 | 13646.9 ± 0.5% | 1.008 | 0.195 | 0.999 | 1.002 | 1.001 | 0.945 | 1.004 | 1.013 | 1.041 | 0.188 | 1.017 |
| hex: http/json-16kx64 | 2097280 | 15174.9 ± 0.5% | 1.005 | 0.182 | 1.007 | 1.004 | 1.003 | 1.001 | 1.008 | 1.008 | 1.012 | 0.180 | 1.010 |
| hex: http/json-1m | 524290 | 15656.9 ± 0.3% | 0.999 | 0.177 | 1.000 | 1.000 | 1.000 | 1.001 | 1.000 | 0.997 | 0.998 | 0.177 | 1.000 |
| hex: http/js-1kx1024 | 2099200 | 13650.3 ± 1.4% | 1.007 | 0.195 | 1.005 | 1.002 | 1.003 | 0.945 | 1.005 | 1.014 | 1.040 | 0.188 | 1.022 |
| hex: http/js-16kx64 | 2097280 | 15243.9 ± 0.5% | 1.003 | 0.181 | 0.999 | 1.000 | 1.000 | 0.992 | 1.002 | 1.004 | 1.005 | 0.180 | 1.006 |
| hex: http/js-1m | 524290 | 15649.0 ± 0.4% | 1.002 | 0.177 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 0.998 | 0.999 | 0.177 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 13716.6 ± 0.4% | 1.005 | 0.195 | 1.005 | 1.002 | 1.001 | 0.938 | 1.000 | 1.010 | 1.035 | 0.187 | 1.009 |
| hex: http/css-16kx64 | 2097280 | 15321.2 ± 0.4% | 0.998 | 0.180 | 1.001 | 1.001 | 1.001 | 0.991 | 0.996 | 0.999 | 1.003 | 0.179 | 0.998 |
| hex: http/css-1m | 524290 | 15662.6 ± 0.2% | 1.000 | 0.177 | 1.001 | 1.001 | 1.001 | 0.999 | 1.001 | 1.001 | 1.000 | 0.177 | 1.001 |
| hex: shuffled/dickens-1m | 524290 | 15662.4 ± 0.3% | 1.002 | 0.178 | 1.002 | 1.002 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.177 | 1.000 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: canterbury-large/bible.txt, decoding: J13 decoder escape blocks off runs at 1.051 of all on.
- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.052 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.056 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.261 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.258 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.261 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.264 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.235 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.233 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.238 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.233 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.225 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.228 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.229 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.226 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.232 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.230 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.229 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.239 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43306.6 ± 0.4% | 47375.7 ± 0.1% | 0.914 | — | — |
| string: silesia/nci | 1048576 | 37025.9 ± 5.6% | 39508.1 ± 3.7% | 0.937 | — | — |
| string: silesia/reymont | 1048576 | 36773.2 ± 5.6% | 39283.2 ± 3.5% | 0.936 | — | — |
| string: silesia/samba | 65546 | 43531.5 ± 0.1% | 48499.8 ± 0.1% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 38025.2 ± 3.2% | 41254.2 ± 2.8% | 0.922 | — | — |
| string: silesia/xml | 1048576 | 33372.5 ± 1.0% | 34525.5 ± 1.3% | 0.967 | — | — |
| string: canterbury/alice29.txt | 152089 | 35856.7 ± 0.2% | 36513.4 ± 0.3% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43290.6 ± 0.2% | 47606.0 ± 0.1% | 0.909 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36062.4 ± 0.1% | 36695.7 ± 0.1% | 0.983 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 43507.3 ± 0.1% | 47614.5 ± 0.1% | 0.914 | — | — |
| string: canterbury-large/E.coli | 1048576 | 36796.1 ± 1.8% | 39358.0 ± 3.6% | 0.935 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 33684.8 ± 0.9% | 34530.7 ± 2.0% | 0.976 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 32802.1 ± 1.7% | 33807.5 ± 2.0% | 0.970 | — | — |
| string: http/html-1m | 1048576 | 35348.8 ± 3.3% | 38574.3 ± 2.1% | 0.916 | — | — |
| string: http/json-1m | 1048576 | 31533.2 ± 1.8% | 33427.4 ± 3.5% | 0.943 | — | — |
| string: http/js-1m | 1048576 | 38375.1 ± 3.2% | 41502.5 ± 4.4% | 0.925 | — | — |
| string: http/css-1m | 1048576 | 36349.8 ± 1.3% | 39468.8 ± 1.1% | 0.921 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5764.9 ± 0.4% | 5653.7 ± 0.2% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.914 of simdutf.
- string: silesia/nci: stdx runs at 0.937 of simdutf.
- string: silesia/reymont: stdx runs at 0.936 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.922 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.909 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.914 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.935 of simdutf.
- string: http/html-1m: stdx runs at 0.916 of simdutf.
- string: http/json-1m: stdx runs at 0.943 of simdutf.
- string: http/js-1m: stdx runs at 0.925 of simdutf.
- string: http/css-1m: stdx runs at 0.921 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 39324.5 ± 2.7% | 42887.5 ± 2.3% | 0.917 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 32968.1 ± 1.0% | 34001.3 ± 1.4% | 0.970 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 37631.6 ± 4.8% | 40471.4 ± 2.1% | 0.930 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 38475.3 ± 1.8% | 41607.1 ± 2.3% | 0.925 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 38185.5 ± 3.9% | 41476.2 ± 3.4% | 0.921 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 38429.7 ± 1.9% | 41644.1 ± 1.4% | 0.923 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5760.1 ± 0.1% | 5640.9 ± 0.2% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5753.9 ± 0.1% | 5644.5 ± 0.1% | 1.019 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5759.1 ± 0.5% | 5643.5 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5761.3 ± 0.2% | 5644.9 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5754.7 ± 0.2% | 5641.3 ± 0.2% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5757.1 ± 0.1% | 5644.9 ± 0.2% | 1.020 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1129.6 ± 0.3% | 934.4 ± 0.5% | 1027.5 ± 0.3% | 301.2 ± 0.9% | 663.3 ± 0.3% | 310.5 ± 1.5% | 1.209 | 1.099 | 3.751 | 1.703 | 3.639 |
| qlog records, JSON text sequence | 1467503 | 852.2 ± 0.4% | 818.5 ± 0.3% | 812.0 ± 1.5% | 244.8 ± 0.9% | 699.2 ± 0.7% | 252.7 ± 0.8% | 1.041 | 1.050 | 3.482 | 1.219 | 3.372 |
| string: silesia/dickens | 172528 | 5048.9 ± 0.4% | 1875.7 ± 0.1% | 2651.8 ± 0.5% | 361.5 ± 0.8% | 2843.4 ± 0.2% | 553.8 ± 2.2% | 2.692 | 1.904 | 13.965 | 1.776 | 9.117 |
| string: silesia/nci | 1075110 | 4294.4 ± 0.7% | 2241.8 ± 0.5% | 3004.8 ± 0.4% | 544.2 ± 0.9% | 3007.6 ± 0.6% | 600.1 ± 1.1% | 1.916 | 1.429 | 7.891 | 1.428 | 7.157 |
| string: silesia/reymont | 1075159 | 2932.8 ± 2.7% | 1825.2 ± 1.5% | 2067.2 ± 0.3% | 374.8 ± 1.0% | 2147.2 ± 1.0% | 532.7 ± 0.9% | 1.607 | 1.419 | 7.824 | 1.366 | 5.505 |
| string: silesia/samba | 97582 | 3500.7 ± 0.7% | 2025.5 ± 0.1% | 2614.9 ± 0.8% | 330.3 ± 0.5% | 1501.6 ± 0.7% | 432.1 ± 1.1% | 1.728 | 1.339 | 10.600 | 2.331 | 8.101 |
| string: silesia/webster | 1098490 | 3637.2 ± 1.3% | 1520.9 ± 0.3% | 2018.3 ± 0.7% | 359.3 ± 0.5% | 2170.9 ± 0.8% | 500.7 ± 2.0% | 2.391 | 1.802 | 10.124 | 1.675 | 7.265 |
| string: silesia/xml | 1090118 | 4794.1 ± 0.7% | 2367.4 ± 0.2% | 2535.3 ± 0.3% | 453.5 ± 1.2% | 2861.5 ± 0.8% | 567.8 ± 1.1% | 2.025 | 1.891 | 10.571 | 1.675 | 8.443 |
| string: canterbury/alice29.txt | 159425 | 4301.7 ± 1.0% | 1600.3 ± 0.2% | 2460.9 ± 0.8% | 342.6 ± 0.5% | 2493.1 ± 0.5% | 507.0 ± 0.9% | 2.688 | 1.748 | 12.556 | 1.725 | 8.485 |
| string: canterbury/asyoulik.txt | 132198 | 3455.7 ± 0.7% | 1458.5 ± 0.3% | 2242.8 ± 0.2% | 335.7 ± 0.3% | 2082.9 ± 0.8% | 465.2 ± 0.7% | 2.369 | 1.541 | 10.294 | 1.659 | 7.429 |
| string: canterbury/lcet10.txt | 441884 | 5112.7 ± 0.2% | 1853.1 ± 0.1% | 2344.3 ± 1.3% | 390.6 ± 0.4% | 2847.9 ± 0.7% | 539.2 ± 0.9% | 2.759 | 2.181 | 13.090 | 1.795 | 9.481 |
| string: canterbury/plrabn12.txt | 503330 | 4135.8 ± 0.8% | 1737.9 ± 0.1% | 2062.7 ± 0.7% | 360.9 ± 0.7% | 2504.4 ± 0.8% | 500.2 ± 1.9% | 2.380 | 2.005 | 11.460 | 1.651 | 8.268 |
| string: canterbury-large/E.coli | 1048578 | 19187.9 ± 1.0% | 3613.4 ± 0.3% | 3262.3 ± 0.4% | 931.0 ± 0.8% | 6090.3 ± 0.4% | 754.7 ± 1.7% | 5.310 | 5.882 | 20.609 | 3.151 | 25.425 |
| string: canterbury-large/bible.txt | 1055886 | 6637.0 ± 1.8% | 2945.8 ± 0.8% | 2845.4 ± 0.5% | 424.8 ± 1.1% | 3772.0 ± 1.3% | 612.8 ± 1.9% | 2.253 | 2.333 | 15.623 | 1.760 | 10.831 |
| string: canterbury-large/world192.txt | 1103121 | 3379.4 ± 0.3% | 1483.4 ± 0.2% | 2017.0 ± 0.7% | 353.7 ± 0.8% | 2118.7 ± 0.6% | 498.9 ± 0.7% | 2.278 | 1.675 | 9.554 | 1.595 | 6.773 |
| string: http/html-1m | 1058582 | 6056.3 ± 1.4% | 2737.6 ± 0.5% | 2707.4 ± 0.4% | 442.1 ± 0.5% | 3485.2 ± 0.6% | 597.9 ± 1.8% | 2.212 | 2.237 | 13.699 | 1.738 | 10.130 |
| string: http/json-1m | 1190272 | 2547.1 ± 0.5% | 877.6 ± 0.3% | 2256.9 ± 0.3% | 390.6 ± 0.5% | 1059.8 ± 0.3% | 438.4 ± 1.0% | 2.902 | 1.129 | 6.521 | 2.403 | 5.810 |
| string: http/js-1m | 1144362 | 2281.6 ± 0.4% | 1029.2 ± 0.1% | 1640.7 ± 0.5% | 321.3 ± 0.5% | 1524.2 ± 0.4% | 420.7 ± 1.4% | 2.217 | 1.391 | 7.101 | 1.497 | 5.424 |
| string: http/css-1m | 1097820 | 2639.8 ± 0.5% | 1679.5 ± 0.3% | 2232.4 ± 0.5% | 407.0 ± 1.1% | 1946.3 ± 0.5% | 490.7 ± 1.1% | 1.572 | 1.183 | 6.486 | 1.356 | 5.380 |
| string: dickens as Cyrillic and CJK | 1883069 | 3079.6 ± 0.7% | 1687.2 ± 0.4% | 895.3 ± 0.3% | 350.5 ± 0.2% | 668.7 ± 0.5% | 157.9 ± 2.2% | 1.825 | 3.440 | 8.787 | 4.605 | 19.506 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.7 ± 1.9% | 981.2 ± 0.4% | 1216.4 ± 1.5% | 216.3 ± 0.3% | 472.6 ± 0.9% | 252.0 ± 4.6% | 1.353 | 1.091 | 6.139 | 2.809 | 5.269 |
| hex: silesia/dickens | 524290 | 18998.7 ± 0.9% | 3622.0 ± 0.3% | 3305.3 ± 0.3% | 518.3 ± 1.0% | 6145.6 ± 0.8% | 784.7 ± 3.8% | 5.245 | 5.748 | 36.655 | 3.091 | 24.211 |
| hex: silesia/mozilla | 524290 | 19167.7 ± 0.8% | 3623.3 ± 0.3% | 3294.3 ± 0.5% | 452.9 ± 2.5% | 6083.1 ± 1.4% | 787.1 ± 0.5% | 5.290 | 5.818 | 42.319 | 3.151 | 24.352 |
| hex: silesia/mr | 524290 | 18966.9 ± 1.2% | 3620.1 ± 0.3% | 3306.0 ± 0.2% | 585.2 ± 3.5% | 6119.5 ± 2.0% | 785.4 ± 1.4% | 5.239 | 5.737 | 32.410 | 3.099 | 24.149 |
| hex: silesia/nci | 524290 | 18841.3 ± 0.2% | 3619.4 ± 0.2% | 3295.5 ± 0.2% | 635.5 ± 4.5% | 6096.0 ± 0.7% | 775.8 ± 0.3% | 5.206 | 5.717 | 29.647 | 3.091 | 24.286 |
| hex: silesia/ooffice | 524290 | 18905.2 ± 0.4% | 3620.3 ± 0.3% | 3291.4 ± 0.4% | 403.0 ± 1.2% | 6124.2 ± 1.5% | 776.9 ± 0.6% | 5.222 | 5.744 | 46.910 | 3.087 | 24.336 |
| hex: silesia/osdb | 524290 | 18652.4 ± 0.3% | 3617.2 ± 0.2% | 3290.9 ± 0.1% | 486.4 ± 0.4% | 6140.6 ± 1.3% | 777.3 ± 0.5% | 5.157 | 5.668 | 38.346 | 3.038 | 23.997 |
| hex: silesia/reymont | 524290 | 18806.7 ± 1.1% | 3621.3 ± 0.3% | 3291.2 ± 0.2% | 525.1 ± 1.8% | 6121.5 ± 1.1% | 777.1 ± 0.5% | 5.193 | 5.714 | 35.814 | 3.072 | 24.201 |
| hex: silesia/samba | 524290 | 18488.7 ± 0.9% | 3620.2 ± 0.0% | 3293.9 ± 0.1% | 407.5 ± 1.7% | 6102.2 ± 0.4% | 776.8 ± 0.5% | 5.107 | 5.613 | 45.375 | 3.030 | 23.801 |
| hex: silesia/sao | 524290 | 19031.6 ± 0.5% | 3619.3 ± 0.2% | 3303.2 ± 0.2% | 344.5 ± 0.4% | 6088.7 ± 1.0% | 775.7 ± 0.5% | 5.258 | 5.762 | 55.247 | 3.126 | 24.534 |
| hex: silesia/webster | 524290 | 19004.2 ± 0.3% | 3620.4 ± 0.6% | 3293.8 ± 0.2% | 475.0 ± 1.9% | 6085.5 ± 1.6% | 778.3 ± 0.6% | 5.249 | 5.770 | 40.010 | 3.123 | 24.416 |
| hex: silesia/x-ray | 524290 | 18756.8 ± 0.5% | 3619.5 ± 0.4% | 3295.3 ± 0.4% | 482.4 ± 0.4% | 6100.2 ± 2.2% | 778.5 ± 0.5% | 5.182 | 5.692 | 38.882 | 3.075 | 24.094 |
| hex: silesia/xml | 524290 | 18902.6 ± 0.5% | 3617.0 ± 0.1% | 3304.9 ± 0.2% | 529.1 ± 1.2% | 6089.9 ± 0.8% | 778.4 ± 0.4% | 5.226 | 5.720 | 35.726 | 3.104 | 24.282 |
| hex: canterbury/alice29.txt | 304180 | 19475.3 ± 0.3% | 3630.7 ± 0.1% | 3378.8 ± 0.1% | 516.2 ± 0.5% | 6128.5 ± 0.3% | 776.4 ± 0.8% | 5.364 | 5.764 | 37.728 | 3.178 | 25.083 |
| hex: canterbury/asyoulik.txt | 250360 | 19527.3 ± 0.2% | 3636.5 ± 0.1% | 3363.7 ± 0.2% | 507.8 ± 0.6% | 6156.5 ± 0.3% | 775.6 ± 0.3% | 5.370 | 5.805 | 38.453 | 3.172 | 25.176 |
| hex: canterbury/cp.html | 49208 | 19184.1 ± 0.8% | 3639.6 ± 0.0% | 3276.0 ± 0.3% | 474.6 ± 4.6% | 6278.6 ± 0.7% | 757.9 ± 0.8% | 5.271 | 5.856 | 40.423 | 3.055 | 25.313 |
| hex: canterbury/fields.c | 22302 | 18902.5 ± 0.3% | 3628.9 ± 0.1% | 3398.8 ± 0.3% | 495.4 ± 3.6% | 6259.1 ± 0.6% | 742.1 ± 3.0% | 5.209 | 5.562 | 38.154 | 3.020 | 25.470 |
| hex: canterbury/grammar.lsp | 7444 | 17437.4 ± 4.0% | 3601.1 ± 0.1% | 3359.2 ± 0.3% | 530.9 ± 6.9% | 6162.5 ± 0.7% | 700.4 ± 2.2% | 4.842 | 5.191 | 32.842 | 2.830 | 24.896 |
| hex: canterbury/kennedy.xls | 524290 | 18605.2 ± 0.7% | 3617.7 ± 0.2% | 3290.6 ± 0.2% | 659.1 ± 1.5% | 6111.3 ± 1.4% | 759.0 ± 6.6% | 5.143 | 5.654 | 28.229 | 3.044 | 24.513 |
| hex: canterbury/lcet10.txt | 524290 | 18907.3 ± 2.1% | 3618.0 ± 0.3% | 3306.1 ± 0.1% | 513.0 ± 0.4% | 6075.9 ± 2.1% | 765.4 ± 3.8% | 5.226 | 5.719 | 36.856 | 3.112 | 24.702 |
| hex: canterbury/plrabn12.txt | 524290 | 18756.4 ± 1.1% | 3617.5 ± 0.2% | 3299.2 ± 0.1% | 504.5 ± 0.5% | 6121.6 ± 2.3% | 767.9 ± 0.8% | 5.185 | 5.685 | 37.180 | 3.064 | 24.426 |
| hex: canterbury/ptt5 | 524290 | 18994.8 ± 1.7% | 3619.1 ± 0.2% | 3294.4 ± 0.4% | 559.2 ± 0.9% | 6073.4 ± 1.3% | 780.1 ± 2.1% | 5.249 | 5.766 | 33.969 | 3.128 | 24.349 |
| hex: canterbury/sum | 76482 | 19284.4 ± 0.5% | 3632.0 ± 0.0% | 3362.5 ± 0.2% | 507.6 ± 0.2% | 6174.4 ± 0.1% | 774.9 ± 0.7% | 5.310 | 5.735 | 37.992 | 3.123 | 24.888 |
| hex: canterbury/xargs.1 | 8456 | 17801.6 ± 0.1% | 3602.6 ± 0.0% | 3374.0 ± 0.3% | 485.9 ± 1.8% | 6144.7 ± 0.1% | 751.7 ± 2.6% | 4.941 | 5.276 | 36.640 | 2.897 | 23.681 |
| hex: canterbury-large/E.coli | 524290 | 18807.9 ± 0.4% | 3618.2 ± 0.4% | 3301.6 ± 0.3% | 688.4 ± 0.3% | 6073.4 ± 1.3% | 756.7 ± 4.4% | 5.198 | 5.697 | 27.320 | 3.097 | 24.854 |
| hex: canterbury-large/bible.txt | 524290 | 19055.5 ± 1.4% | 3621.0 ± 0.2% | 3298.9 ± 0.2% | 512.4 ± 2.6% | 6112.2 ± 1.2% | 763.1 ± 1.1% | 5.263 | 5.776 | 37.190 | 3.118 | 24.971 |
| hex: canterbury-large/world192.txt | 524290 | 18530.7 ± 1.1% | 3617.5 ± 0.1% | 3296.7 ± 0.3% | 491.7 ± 0.8% | 6146.3 ± 0.6% | 760.8 ± 1.1% | 5.123 | 5.621 | 37.690 | 3.015 | 24.357 |
| hex: http/html-1kx1024 | 2099200 | 9606.4 ± 15.3% | 3463.3 ± 0.2% | 2885.5 ± 0.6% | 471.7 ± 0.5% | 5151.3 ± 1.4% | 629.5 ± 2.4% | 2.774 | 3.329 | 20.363 | 1.865 | 15.261 |
| hex: http/html-16kx64 | 2097280 | 18365.5 ± 1.3% | 3612.7 ± 0.2% | 3269.9 ± 0.3% | 479.7 ± 1.2% | 6031.8 ± 0.9% | 753.8 ± 2.5% | 5.084 | 5.617 | 38.284 | 3.045 | 24.364 |
| hex: http/html-1m | 524290 | 18870.1 ± 0.3% | 3620.9 ± 0.2% | 3289.2 ± 0.3% | 497.4 ± 1.0% | 6105.9 ± 2.2% | 773.9 ± 1.4% | 5.212 | 5.737 | 37.938 | 3.090 | 24.384 |
| hex: http/json-1kx1024 | 2099200 | 9842.4 ± 15.6% | 3464.0 ± 0.2% | 2891.9 ± 0.5% | 573.2 ± 0.6% | 5153.6 ± 0.9% | 645.9 ± 3.6% | 2.841 | 3.403 | 17.172 | 1.910 | 15.239 |
| hex: http/json-16kx64 | 2097280 | 18331.5 ± 1.4% | 3612.6 ± 0.2% | 3269.4 ± 0.4% | 570.0 ± 0.9% | 6038.8 ± 1.3% | 748.9 ± 2.7% | 5.074 | 5.607 | 32.161 | 3.036 | 24.478 |
| hex: http/json-1m | 524290 | 18656.6 ± 1.1% | 3623.7 ± 0.2% | 3304.5 ± 0.5% | 594.4 ± 2.6% | 6117.0 ± 1.8% | 751.1 ± 1.2% | 5.148 | 5.646 | 31.386 | 3.050 | 24.838 |
| hex: http/js-1kx1024 | 2099200 | 9900.2 ± 18.5% | 3458.2 ± 0.3% | 2905.0 ± 0.5% | 478.8 ± 0.7% | 5151.7 ± 1.7% | 658.0 ± 1.9% | 2.863 | 3.408 | 20.676 | 1.922 | 15.046 |
| hex: http/js-16kx64 | 2097280 | 18429.3 ± 0.9% | 3612.5 ± 0.6% | 3261.6 ± 3.6% | 479.2 ± 0.5% | 6054.5 ± 0.9% | 757.0 ± 2.6% | 5.102 | 5.650 | 38.457 | 3.044 | 24.346 |
| hex: http/js-1m | 524290 | 19105.8 ± 1.4% | 3623.5 ± 0.4% | 3305.8 ± 0.3% | 497.6 ± 2.2% | 6089.0 ± 0.9% | 751.6 ± 2.6% | 5.273 | 5.779 | 38.395 | 3.138 | 25.420 |
| hex: http/css-1kx1024 | 2099200 | 9956.5 ± 15.9% | 3463.7 ± 0.1% | 2892.5 ± 0.5% | 488.5 ± 0.7% | 5160.4 ± 0.7% | 653.8 ± 1.6% | 2.874 | 3.442 | 20.383 | 1.929 | 15.229 |
| hex: http/css-16kx64 | 2097280 | 18454.6 ± 1.4% | 3612.0 ± 0.1% | 3267.1 ± 0.4% | 497.0 ± 0.8% | 6021.3 ± 0.5% | 753.1 ± 1.0% | 5.109 | 5.649 | 37.135 | 3.065 | 24.506 |
| hex: http/css-1m | 524290 | 19010.9 ± 1.6% | 3627.0 ± 0.1% | 3300.2 ± 0.3% | 491.5 ± 2.8% | 6070.2 ± 1.3% | 757.4 ± 2.1% | 5.242 | 5.761 | 38.682 | 3.132 | 25.101 |
| hex: shuffled/dickens-1m | 524290 | 18576.1 ± 0.7% | 3624.6 ± 0.3% | 3299.9 ± 0.4% | 514.4 ± 0.4% | 6153.1 ± 1.3% | 763.4 ± 0.8% | 5.125 | 5.629 | 36.109 | 3.019 | 24.333 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1493.6 ± 1.1% | 1260.4 ± 0.5% | 1047.8 ± 0.9% | 411.1 ± 0.3% | 448.8 ± 0.3% | 418.0 ± 0.4% | 1.185 | 1.425 | 3.633 | 3.328 | 3.573 |
| qlog records, JSON text sequence | 1467503 | 1271.6 ± 1.3% | 1064.5 ± 0.4% | 788.6 ± 0.6% | 380.0 ± 0.7% | 470.8 ± 0.9% | 278.9 ± 0.7% | 1.195 | 1.613 | 3.347 | 2.701 | 4.559 |
| string: silesia/dickens | 172528 | 6876.4 ± 0.2% | 2818.5 ± 0.4% | 2935.6 ± 0.6% | 430.7 ± 0.5% | 1569.4 ± 0.4% | 1007.7 ± 0.1% | 2.440 | 2.342 | 15.964 | 4.382 | 6.824 |
| string: silesia/nci | 1075110 | 7308.9 ± 0.8% | 3441.7 ± 1.1% | 3103.5 ± 0.4% | 818.9 ± 0.8% | 1858.0 ± 0.3% | 1110.6 ± 0.2% | 2.124 | 2.355 | 8.925 | 3.934 | 6.581 |
| string: silesia/reymont | 1075159 | 3318.8 ± 1.1% | 1989.4 ± 1.9% | 2061.8 ± 0.7% | 451.4 ± 0.5% | 1513.0 ± 0.7% | 951.6 ± 0.5% | 1.668 | 1.610 | 7.352 | 2.193 | 3.488 |
| string: silesia/samba | 97582 | 4186.9 ± 0.7% | 2115.5 ± 0.5% | 3446.5 ± 0.8% | 353.8 ± 0.6% | 1434.7 ± 0.4% | 1055.3 ± 0.1% | 1.979 | 1.215 | 11.834 | 2.918 | 3.968 |
| string: silesia/webster | 1098490 | 4061.5 ± 0.4% | 1887.3 ± 0.6% | 2060.1 ± 0.5% | 441.4 ± 0.8% | 1389.4 ± 0.2% | 646.8 ± 0.8% | 2.152 | 1.972 | 9.201 | 2.923 | 6.279 |
| string: silesia/xml | 1090118 | 6113.0 ± 0.7% | 2881.6 ± 0.6% | 2654.2 ± 0.3% | 614.0 ± 0.5% | 1756.0 ± 0.4% | 923.6 ± 0.5% | 2.121 | 2.303 | 9.956 | 3.481 | 6.618 |
| string: canterbury/alice29.txt | 159425 | 6401.1 ± 0.7% | 2201.3 ± 0.5% | 2762.0 ± 0.8% | 407.9 ± 0.6% | 1462.7 ± 0.1% | 953.7 ± 0.2% | 2.908 | 2.318 | 15.692 | 4.376 | 6.712 |
| string: canterbury/asyoulik.txt | 132198 | 5591.4 ± 0.3% | 1715.1 ± 0.6% | 2375.8 ± 0.6% | 403.0 ± 0.5% | 1337.5 ± 1.0% | 885.5 ± 0.1% | 3.260 | 2.353 | 13.875 | 4.181 | 6.314 |
| string: canterbury/lcet10.txt | 441884 | 6232.3 ± 0.8% | 2571.7 ± 0.4% | 2484.8 ± 1.9% | 466.9 ± 0.8% | 1523.9 ± 0.3% | 989.3 ± 0.7% | 2.423 | 2.508 | 13.348 | 4.090 | 6.300 |
| string: canterbury/plrabn12.txt | 503330 | 5724.2 ± 0.4% | 2061.9 ± 0.3% | 2076.5 ± 0.8% | 425.2 ± 0.6% | 1410.7 ± 0.4% | 937.2 ± 0.4% | 2.776 | 2.757 | 13.463 | 4.058 | 6.108 |
| string: canterbury-large/E.coli | 1048578 | 19390.1 ± 0.6% | 9875.1 ± 0.9% | 3800.8 ± 0.6% | 1474.8 ± 0.8% | 2363.6 ± 0.7% | 1199.4 ± 0.9% | 1.964 | 5.102 | 13.148 | 8.204 | 16.166 |
| string: canterbury-large/bible.txt | 1055886 | 6803.4 ± 0.7% | 4174.8 ± 0.6% | 3034.0 ± 1.4% | 502.4 ± 0.3% | 1986.9 ± 0.7% | 1122.8 ± 0.5% | 1.630 | 2.242 | 13.541 | 3.424 | 6.060 |
| string: canterbury-large/world192.txt | 1103121 | 4023.9 ± 0.5% | 1663.5 ± 0.5% | 2002.3 ± 1.1% | 449.2 ± 0.8% | 1357.4 ± 0.2% | 910.6 ± 0.3% | 2.419 | 2.010 | 8.957 | 2.964 | 4.419 |
| string: http/html-1m | 1058582 | 6749.6 ± 1.2% | 3999.3 ± 0.5% | 3049.2 ± 0.3% | 501.7 ± 0.9% | 1930.3 ± 0.5% | 808.9 ± 0.5% | 1.688 | 2.214 | 13.454 | 3.497 | 8.344 |
| string: http/json-1m | 1190272 | 3158.9 ± 0.3% | 1354.1 ± 0.4% | 1562.3 ± 0.2% | 445.8 ± 1.2% | 963.7 ± 0.2% | 765.7 ± 1.3% | 2.333 | 2.022 | 7.085 | 3.278 | 4.125 |
| string: http/js-1m | 1144362 | 2768.8 ± 0.6% | 1180.8 ± 0.4% | 1624.7 ± 0.8% | 368.9 ± 0.6% | 1095.2 ± 0.2% | 759.8 ± 0.2% | 2.345 | 1.704 | 7.506 | 2.528 | 3.644 |
| string: http/css-1m | 1097820 | 3990.3 ± 1.2% | 1489.3 ± 0.5% | 2159.1 ± 0.4% | 495.3 ± 0.2% | 1369.6 ± 0.6% | 898.0 ± 0.5% | 2.679 | 1.848 | 8.056 | 2.913 | 4.443 |
| string: dickens as Cyrillic and CJK | 1883069 | 3073.9 ± 0.4% | 2345.6 ± 0.6% | 522.1 ± 0.5% | 308.4 ± 1.2% | 563.8 ± 1.3% | 336.5 ± 0.3% | 1.310 | 5.887 | 9.966 | 5.452 | 9.136 |
| hex: silesia/dickens | 524290 | 15677.7 ± 0.2% | 1469.8 ± 0.4% | 1085.9 ± 0.8% | 496.9 ± 1.5% | 987.3 ± 0.5% | 736.0 ± 1.0% | 10.666 | 14.437 | 31.548 | 15.879 | 21.301 |
| hex: silesia/mozilla | 524290 | 15661.4 ± 0.9% | 1478.7 ± 0.3% | 1089.0 ± 0.4% | 441.3 ± 0.3% | 992.7 ± 0.4% | 735.8 ± 0.5% | 10.591 | 14.381 | 35.493 | 15.777 | 21.284 |
| hex: silesia/mr | 524290 | 15658.7 ± 0.2% | 1488.9 ± 0.3% | 1092.2 ± 0.5% | 547.2 ± 1.8% | 994.1 ± 0.7% | 736.8 ± 0.9% | 10.517 | 14.338 | 28.614 | 15.752 | 21.253 |
| hex: silesia/nci | 524290 | 15647.5 ± 0.5% | 1477.0 ± 0.6% | 1088.2 ± 0.5% | 638.4 ± 7.4% | 994.2 ± 0.5% | 735.9 ± 0.2% | 10.594 | 14.379 | 24.512 | 15.739 | 21.262 |
| hex: silesia/ooffice | 524290 | 15626.5 ± 0.2% | 1470.5 ± 0.5% | 1084.0 ± 0.6% | 389.1 ± 0.2% | 989.0 ± 0.4% | 734.5 ± 0.5% | 10.627 | 14.415 | 40.163 | 15.801 | 21.276 |
| hex: silesia/osdb | 524290 | 15610.6 ± 0.3% | 1472.9 ± 0.1% | 1089.4 ± 0.3% | 470.4 ± 1.4% | 991.2 ± 0.9% | 734.9 ± 0.3% | 10.598 | 14.329 | 33.187 | 15.749 | 21.241 |
| hex: silesia/reymont | 524290 | 15675.0 ± 0.2% | 1469.1 ± 0.4% | 1087.9 ± 0.3% | 516.4 ± 1.1% | 988.9 ± 0.6% | 736.2 ± 0.5% | 10.670 | 14.408 | 30.357 | 15.851 | 21.292 |
| hex: silesia/samba | 524290 | 15663.5 ± 0.3% | 1469.7 ± 0.2% | 1083.2 ± 0.5% | 402.8 ± 0.4% | 990.5 ± 0.7% | 734.6 ± 0.4% | 10.658 | 14.460 | 38.887 | 15.814 | 21.321 |
| hex: silesia/sao | 524290 | 15670.4 ± 0.3% | 1469.6 ± 0.3% | 1086.0 ± 0.5% | 332.7 ± 0.3% | 987.0 ± 0.6% | 736.1 ± 0.6% | 10.663 | 14.429 | 47.097 | 15.877 | 21.288 |
| hex: silesia/webster | 524290 | 15683.6 ± 0.2% | 1468.6 ± 0.2% | 1088.4 ± 0.6% | 472.9 ± 0.4% | 990.7 ± 0.5% | 736.3 ± 0.3% | 10.679 | 14.410 | 33.165 | 15.831 | 21.300 |
| hex: silesia/x-ray | 524290 | 15631.2 ± 0.2% | 1483.7 ± 0.2% | 1091.6 ± 0.1% | 445.5 ± 0.2% | 993.8 ± 0.3% | 735.9 ± 0.4% | 10.536 | 14.320 | 35.089 | 15.729 | 21.242 |
| hex: silesia/xml | 524290 | 15646.8 ± 0.1% | 1473.0 ± 0.1% | 1087.8 ± 0.3% | 609.4 ± 1.0% | 995.0 ± 0.3% | 734.8 ± 0.4% | 10.622 | 14.384 | 25.678 | 15.725 | 21.293 |
| hex: canterbury/alice29.txt | 304180 | 15664.7 ± 0.1% | 1470.2 ± 0.4% | 1086.5 ± 0.3% | 502.0 ± 0.5% | 991.6 ± 0.4% | 736.6 ± 0.4% | 10.655 | 14.417 | 31.204 | 15.798 | 21.266 |
| hex: canterbury/asyoulik.txt | 250360 | 15704.6 ± 0.0% | 1478.7 ± 0.4% | 1091.9 ± 0.5% | 496.4 ± 1.3% | 995.4 ± 0.3% | 740.6 ± 0.3% | 10.621 | 14.382 | 31.640 | 15.778 | 21.206 |
| hex: canterbury/cp.html | 49208 | 15618.6 ± 0.2% | 1474.7 ± 0.7% | 1098.7 ± 0.2% | 528.3 ± 2.0% | 1006.6 ± 0.5% | 742.6 ± 0.2% | 10.591 | 14.215 | 29.564 | 15.517 | 21.031 |
| hex: canterbury/fields.c | 22302 | 15438.8 ± 0.1% | 1411.2 ± 0.5% | 1069.0 ± 1.0% | 618.1 ± 4.6% | 990.3 ± 0.2% | 735.8 ± 0.1% | 10.940 | 14.442 | 24.979 | 15.591 | 20.983 |
| hex: canterbury/grammar.lsp | 7444 | 14947.2 ± 0.1% | 1508.9 ± 0.2% | 1098.1 ± 0.6% | 663.8 ± 5.0% | 997.5 ± 0.3% | 725.9 ± 0.1% | 9.906 | 13.612 | 22.519 | 14.985 | 20.591 |
| hex: canterbury/kennedy.xls | 524290 | 15630.0 ± 0.2% | 1477.6 ± 0.4% | 1087.6 ± 0.4% | 652.4 ± 1.2% | 992.2 ± 0.3% | 733.7 ± 0.3% | 10.578 | 14.371 | 23.958 | 15.752 | 21.302 |
| hex: canterbury/lcet10.txt | 524290 | 15635.1 ± 0.3% | 1467.7 ± 0.5% | 1083.9 ± 0.4% | 504.6 ± 1.2% | 989.3 ± 0.3% | 735.7 ± 0.6% | 10.653 | 14.425 | 30.985 | 15.804 | 21.253 |
| hex: canterbury/plrabn12.txt | 524290 | 15654.3 ± 0.4% | 1464.9 ± 0.3% | 1085.4 ± 0.5% | 495.0 ± 0.9% | 989.6 ± 0.5% | 734.8 ± 0.2% | 10.686 | 14.422 | 31.627 | 15.819 | 21.305 |
| hex: canterbury/ptt5 | 524290 | 15612.6 ± 0.2% | 1483.8 ± 0.3% | 1089.9 ± 0.2% | 552.2 ± 1.4% | 995.9 ± 0.2% | 736.1 ± 0.4% | 10.522 | 14.325 | 28.275 | 15.676 | 21.211 |
| hex: canterbury/sum | 76482 | 15643.9 ± 0.1% | 1494.7 ± 0.1% | 1105.6 ± 0.2% | 593.8 ± 3.0% | 998.1 ± 0.1% | 744.5 ± 0.1% | 10.466 | 14.149 | 26.345 | 15.674 | 21.013 |
| hex: canterbury/xargs.1 | 8456 | 15018.8 ± 0.1% | 1495.0 ± 0.3% | 1096.7 ± 0.7% | 662.8 ± 7.6% | 1005.0 ± 0.2% | 728.2 ± 0.2% | 10.046 | 13.695 | 22.659 | 14.944 | 20.626 |
| hex: canterbury-large/E.coli | 524290 | 15654.7 ± 0.1% | 1477.8 ± 0.4% | 1088.7 ± 0.5% | 673.5 ± 0.3% | 995.0 ± 0.3% | 736.1 ± 0.4% | 10.593 | 14.379 | 23.243 | 15.734 | 21.268 |
| hex: canterbury-large/bible.txt | 524290 | 15588.2 ± 0.1% | 1465.9 ± 0.3% | 1085.3 ± 0.7% | 515.1 ± 0.4% | 994.1 ± 0.3% | 733.5 ± 0.5% | 10.634 | 14.363 | 30.261 | 15.680 | 21.251 |
| hex: canterbury-large/world192.txt | 524290 | 15627.5 ± 0.2% | 1472.3 ± 0.5% | 1087.3 ± 0.3% | 503.5 ± 0.7% | 992.0 ± 0.4% | 733.6 ± 0.7% | 10.614 | 14.373 | 31.037 | 15.754 | 21.304 |
| hex: http/html-1kx1024 | 2099200 | 13678.6 ± 0.6% | 1453.8 ± 0.3% | 1064.7 ± 0.3% | 501.7 ± 0.2% | 982.8 ± 0.2% | 691.9 ± 0.2% | 9.409 | 12.847 | 27.262 | 13.918 | 19.769 |
| hex: http/html-16kx64 | 2097280 | 15230.1 ± 0.6% | 1448.2 ± 0.4% | 1078.0 ± 0.3% | 507.9 ± 0.3% | 996.6 ± 0.1% | 735.4 ± 0.1% | 10.516 | 14.129 | 29.987 | 15.282 | 20.709 |
| hex: http/html-1m | 524290 | 15672.3 ± 0.1% | 1468.4 ± 0.3% | 1084.7 ± 0.2% | 501.7 ± 0.3% | 993.8 ± 0.3% | 734.5 ± 0.3% | 10.673 | 14.448 | 31.239 | 15.771 | 21.338 |
| hex: http/json-1kx1024 | 2099200 | 13646.9 ± 0.5% | 1463.9 ± 0.2% | 1069.0 ± 0.1% | 609.3 ± 0.4% | 986.7 ± 0.1% | 692.4 ± 0.0% | 9.322 | 12.766 | 22.398 | 13.830 | 19.708 |
| hex: http/json-16kx64 | 2097280 | 15174.9 ± 0.5% | 1449.1 ± 0.2% | 1076.9 ± 0.3% | 618.4 ± 0.6% | 998.0 ± 0.3% | 735.2 ± 0.1% | 10.472 | 14.091 | 24.540 | 15.206 | 20.640 |
| hex: http/json-1m | 524290 | 15656.9 ± 0.3% | 1474.6 ± 0.2% | 1087.4 ± 0.3% | 630.6 ± 0.7% | 995.6 ± 0.1% | 735.3 ± 0.7% | 10.618 | 14.399 | 24.828 | 15.726 | 21.294 |
| hex: http/js-1kx1024 | 2099200 | 13650.3 ± 1.4% | 1453.4 ± 0.3% | 1063.2 ± 0.2% | 498.8 ± 0.1% | 983.8 ± 0.2% | 692.3 ± 0.2% | 9.392 | 12.839 | 27.368 | 13.875 | 19.718 |
| hex: http/js-16kx64 | 2097280 | 15243.9 ± 0.5% | 1445.6 ± 0.1% | 1075.8 ± 0.2% | 506.0 ± 0.3% | 999.4 ± 0.3% | 735.4 ± 0.4% | 10.545 | 14.169 | 30.129 | 15.253 | 20.730 |
| hex: http/js-1m | 524290 | 15649.0 ± 0.4% | 1469.1 ± 0.2% | 1085.0 ± 0.4% | 508.6 ± 0.8% | 991.2 ± 0.5% | 735.0 ± 0.4% | 10.652 | 14.422 | 30.767 | 15.788 | 21.291 |
| hex: http/css-1kx1024 | 2099200 | 13716.6 ± 0.4% | 1454.4 ± 0.1% | 1064.3 ± 0.3% | 531.8 ± 0.4% | 984.2 ± 0.2% | 692.7 ± 0.4% | 9.431 | 12.888 | 25.792 | 13.937 | 19.803 |
| hex: http/css-16kx64 | 2097280 | 15321.2 ± 0.4% | 1446.2 ± 0.2% | 1074.7 ± 0.4% | 541.8 ± 0.9% | 999.9 ± 0.6% | 735.0 ± 0.2% | 10.594 | 14.256 | 28.277 | 15.323 | 20.844 |
| hex: http/css-1m | 524290 | 15662.6 ± 0.2% | 1471.4 ± 0.3% | 1084.7 ± 0.5% | 530.0 ± 0.8% | 995.7 ± 0.5% | 735.3 ± 0.4% | 10.645 | 14.440 | 29.552 | 15.731 | 21.302 |
| hex: shuffled/dickens-1m | 524290 | 15662.4 ± 0.3% | 1467.0 ± 0.3% | 1084.6 ± 0.3% | 500.9 ± 0.5% | 988.5 ± 0.5% | 736.4 ± 0.8% | 10.676 | 14.441 | 31.272 | 15.845 | 21.268 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1533.3 ± 0.5% | 1260.4 ± 0.5% | 1047.8 ± 0.9% | 411.1 ± 0.3% | 448.8 ± 0.3% | 418.0 ± 0.4% | 1.217 | 1.463 | 3.730 | 3.417 | 3.668 |
| qlog records, JSON text sequence | 1467503 | 1297.0 ± 0.5% | 1064.5 ± 0.4% | 788.6 ± 0.6% | 380.0 ± 0.7% | 470.8 ± 0.9% | 278.9 ± 0.7% | 1.218 | 1.645 | 3.413 | 2.755 | 4.650 |
| string: silesia/dickens | 172528 | 7114.1 ± 0.2% | 2818.5 ± 0.4% | 2935.6 ± 0.6% | 430.7 ± 0.5% | 1569.4 ± 0.4% | 1007.7 ± 0.1% | 2.524 | 2.423 | 16.516 | 4.533 | 7.060 |
| string: silesia/nci | 1075110 | 7406.1 ± 6.9% | 3441.7 ± 1.1% | 3103.5 ± 0.4% | 818.9 ± 0.8% | 1858.0 ± 0.3% | 1110.6 ± 0.2% | 2.152 | 2.386 | 9.043 | 3.986 | 6.669 |
| string: silesia/reymont | 1075159 | 3492.7 ± 2.4% | 1989.4 ± 1.9% | 2061.8 ± 0.7% | 451.4 ± 0.5% | 1513.0 ± 0.7% | 951.6 ± 0.5% | 1.756 | 1.694 | 7.737 | 2.308 | 3.670 |
| string: silesia/samba | 97582 | 4591.9 ± 2.2% | 2115.5 ± 0.5% | 3446.5 ± 0.8% | 353.8 ± 0.6% | 1434.7 ± 0.4% | 1055.3 ± 0.1% | 2.171 | 1.332 | 12.978 | 3.201 | 4.351 |
| string: silesia/webster | 1098490 | 4089.6 ± 0.5% | 1887.3 ± 0.6% | 2060.1 ± 0.5% | 441.4 ± 0.8% | 1389.4 ± 0.2% | 646.8 ± 0.8% | 2.167 | 1.985 | 9.264 | 2.943 | 6.323 |
| string: silesia/xml | 1090118 | 6231.0 ± 0.8% | 2881.6 ± 0.6% | 2654.2 ± 0.3% | 614.0 ± 0.5% | 1756.0 ± 0.4% | 923.6 ± 0.5% | 2.162 | 2.348 | 10.148 | 3.548 | 6.746 |
| string: canterbury/alice29.txt | 159425 | 6809.5 ± 1.5% | 2201.3 ± 0.5% | 2762.0 ± 0.8% | 407.9 ± 0.6% | 1462.7 ± 0.1% | 953.7 ± 0.2% | 3.093 | 2.465 | 16.693 | 4.655 | 7.140 |
| string: canterbury/asyoulik.txt | 132198 | 5862.8 ± 4.1% | 1715.1 ± 0.6% | 2375.8 ± 0.6% | 403.0 ± 0.5% | 1337.5 ± 1.0% | 885.5 ± 0.1% | 3.418 | 2.468 | 14.549 | 4.383 | 6.621 |
| string: canterbury/lcet10.txt | 441884 | 6249.1 ± 0.3% | 2571.7 ± 0.4% | 2484.8 ± 1.9% | 466.9 ± 0.8% | 1523.9 ± 0.3% | 989.3 ± 0.7% | 2.430 | 2.515 | 13.384 | 4.101 | 6.317 |
| string: canterbury/plrabn12.txt | 503330 | 5750.4 ± 0.4% | 2061.9 ± 0.3% | 2076.5 ± 0.8% | 425.2 ± 0.6% | 1410.7 ± 0.4% | 937.2 ± 0.4% | 2.789 | 2.769 | 13.525 | 4.076 | 6.136 |
| string: canterbury-large/E.coli | 1048578 | 19347.3 ± 2.9% | 9875.1 ± 0.9% | 3800.8 ± 0.6% | 1474.8 ± 0.8% | 2363.6 ± 0.7% | 1199.4 ± 0.9% | 1.959 | 5.090 | 13.119 | 8.185 | 16.131 |
| string: canterbury-large/bible.txt | 1055886 | 6800.6 ± 0.5% | 4174.8 ± 0.6% | 3034.0 ± 1.4% | 502.4 ± 0.3% | 1986.9 ± 0.7% | 1122.8 ± 0.5% | 1.629 | 2.241 | 13.535 | 3.423 | 6.057 |
| string: canterbury-large/world192.txt | 1103121 | 4039.0 ± 1.3% | 1663.5 ± 0.5% | 2002.3 ± 1.1% | 449.2 ± 0.8% | 1357.4 ± 0.2% | 910.6 ± 0.3% | 2.428 | 2.017 | 8.991 | 2.975 | 4.435 |
| string: http/html-1m | 1058582 | 6829.9 ± 0.1% | 3999.3 ± 0.5% | 3049.2 ± 0.3% | 501.7 ± 0.9% | 1930.3 ± 0.5% | 808.9 ± 0.5% | 1.708 | 2.240 | 13.614 | 3.538 | 8.443 |
| string: http/json-1m | 1190272 | 3305.6 ± 0.5% | 1354.1 ± 0.4% | 1562.3 ± 0.2% | 445.8 ± 1.2% | 963.7 ± 0.2% | 765.7 ± 1.3% | 2.441 | 2.116 | 7.414 | 3.430 | 4.317 |
| string: http/js-1m | 1144362 | 2815.7 ± 0.3% | 1180.8 ± 0.4% | 1624.7 ± 0.8% | 368.9 ± 0.6% | 1095.2 ± 0.2% | 759.8 ± 0.2% | 2.385 | 1.733 | 7.633 | 2.571 | 3.706 |
| string: http/css-1m | 1097820 | 4038.2 ± 0.7% | 1489.3 ± 0.5% | 2159.1 ± 0.4% | 495.3 ± 0.2% | 1369.6 ± 0.6% | 898.0 ± 0.5% | 2.712 | 1.870 | 8.153 | 2.948 | 4.497 |
| string: dickens as Cyrillic and CJK | 1883069 | 3080.9 ± 0.3% | 2345.6 ± 0.6% | 522.1 ± 0.5% | 308.4 ± 1.2% | 563.8 ± 1.3% | 336.5 ± 0.3% | 1.313 | 5.901 | 9.989 | 5.464 | 9.156 |
| hex: silesia/dickens | 524290 | 15685.6 ± 0.4% | 1469.8 ± 0.4% | 1085.9 ± 0.8% | 496.9 ± 1.5% | 987.3 ± 0.5% | 736.0 ± 1.0% | 10.672 | 14.445 | 31.564 | 15.887 | 21.311 |
| hex: silesia/mozilla | 524290 | 15616.6 ± 0.2% | 1478.7 ± 0.3% | 1089.0 ± 0.4% | 441.3 ± 0.3% | 992.7 ± 0.4% | 735.8 ± 0.5% | 10.561 | 14.340 | 35.391 | 15.732 | 21.223 |
| hex: silesia/mr | 524290 | 15693.3 ± 0.3% | 1488.9 ± 0.3% | 1092.2 ± 0.5% | 547.2 ± 1.8% | 994.1 ± 0.7% | 736.8 ± 0.9% | 10.540 | 14.369 | 28.677 | 15.786 | 21.300 |
| hex: silesia/nci | 524290 | 15664.6 ± 0.4% | 1477.0 ± 0.6% | 1088.2 ± 0.5% | 638.4 ± 7.4% | 994.2 ± 0.5% | 735.9 ± 0.2% | 10.606 | 14.395 | 24.538 | 15.756 | 21.285 |
| hex: silesia/ooffice | 524290 | 15610.4 ± 0.7% | 1470.5 ± 0.5% | 1084.0 ± 0.6% | 389.1 ± 0.2% | 989.0 ± 0.4% | 734.5 ± 0.5% | 10.616 | 14.400 | 40.121 | 15.784 | 21.254 |
| hex: silesia/osdb | 524290 | 15610.5 ± 0.4% | 1472.9 ± 0.1% | 1089.4 ± 0.3% | 470.4 ± 1.4% | 991.2 ± 0.9% | 734.9 ± 0.3% | 10.598 | 14.329 | 33.187 | 15.748 | 21.241 |
| hex: silesia/reymont | 524290 | 15663.2 ± 0.2% | 1469.1 ± 0.4% | 1087.9 ± 0.3% | 516.4 ± 1.1% | 988.9 ± 0.6% | 736.2 ± 0.5% | 10.662 | 14.397 | 30.334 | 15.839 | 21.276 |
| hex: silesia/samba | 524290 | 15648.4 ± 0.5% | 1469.7 ± 0.2% | 1083.2 ± 0.5% | 402.8 ± 0.4% | 990.5 ± 0.7% | 734.6 ± 0.4% | 10.647 | 14.446 | 38.850 | 15.799 | 21.300 |
| hex: silesia/sao | 524290 | 15682.4 ± 0.4% | 1469.6 ± 0.3% | 1086.0 ± 0.5% | 332.7 ± 0.3% | 987.0 ± 0.6% | 736.1 ± 0.6% | 10.671 | 14.440 | 47.133 | 15.889 | 21.304 |
| hex: silesia/webster | 524290 | 15685.6 ± 0.2% | 1468.6 ± 0.2% | 1088.4 ± 0.6% | 472.9 ± 0.4% | 990.7 ± 0.5% | 736.3 ± 0.3% | 10.681 | 14.412 | 33.169 | 15.833 | 21.303 |
| hex: silesia/x-ray | 524290 | 15655.1 ± 0.5% | 1483.7 ± 0.2% | 1091.6 ± 0.1% | 445.5 ± 0.2% | 993.8 ± 0.3% | 735.9 ± 0.4% | 10.552 | 14.341 | 35.142 | 15.753 | 21.274 |
| hex: silesia/xml | 524290 | 15654.3 ± 0.2% | 1473.0 ± 0.1% | 1087.8 ± 0.3% | 609.4 ± 1.0% | 995.0 ± 0.3% | 734.8 ± 0.4% | 10.627 | 14.391 | 25.690 | 15.733 | 21.303 |
| hex: canterbury/alice29.txt | 304180 | 15684.1 ± 0.4% | 1470.2 ± 0.4% | 1086.5 ± 0.3% | 502.0 ± 0.5% | 991.6 ± 0.4% | 736.6 ± 0.4% | 10.668 | 14.435 | 31.243 | 15.818 | 21.292 |
| hex: canterbury/asyoulik.txt | 250360 | 15719.1 ± 0.1% | 1478.7 ± 0.4% | 1091.9 ± 0.5% | 496.4 ± 1.3% | 995.4 ± 0.3% | 740.6 ± 0.3% | 10.631 | 14.395 | 31.669 | 15.792 | 21.226 |
| hex: canterbury/cp.html | 49208 | 15633.6 ± 0.1% | 1474.7 ± 0.7% | 1098.7 ± 0.2% | 528.3 ± 2.0% | 1006.6 ± 0.5% | 742.6 ± 0.2% | 10.601 | 14.229 | 29.592 | 15.532 | 21.052 |
| hex: canterbury/fields.c | 22302 | 15455.6 ± 0.0% | 1411.2 ± 0.5% | 1069.0 ± 1.0% | 618.1 ± 4.6% | 990.3 ± 0.2% | 735.8 ± 0.1% | 10.952 | 14.458 | 25.006 | 15.608 | 21.006 |
| hex: canterbury/grammar.lsp | 7444 | 14994.7 ± 0.1% | 1508.9 ± 0.2% | 1098.1 ± 0.6% | 663.8 ± 5.0% | 997.5 ± 0.3% | 725.9 ± 0.1% | 9.937 | 13.656 | 22.590 | 15.033 | 20.656 |
| hex: canterbury/kennedy.xls | 524290 | 15633.0 ± 0.3% | 1477.6 ± 0.4% | 1087.6 ± 0.4% | 652.4 ± 1.2% | 992.2 ± 0.3% | 733.7 ± 0.3% | 10.580 | 14.374 | 23.963 | 15.755 | 21.306 |
| hex: canterbury/lcet10.txt | 524290 | 15659.0 ± 0.4% | 1467.7 ± 0.5% | 1083.9 ± 0.4% | 504.6 ± 1.2% | 989.3 ± 0.3% | 735.7 ± 0.6% | 10.669 | 14.447 | 31.032 | 15.829 | 21.285 |
| hex: canterbury/plrabn12.txt | 524290 | 15673.5 ± 0.2% | 1464.9 ± 0.3% | 1085.4 ± 0.5% | 495.0 ± 0.9% | 989.6 ± 0.5% | 734.8 ± 0.2% | 10.699 | 14.440 | 31.666 | 15.839 | 21.331 |
| hex: canterbury/ptt5 | 524290 | 15620.5 ± 0.7% | 1483.8 ± 0.3% | 1089.9 ± 0.2% | 552.2 ± 1.4% | 995.9 ± 0.2% | 736.1 ± 0.4% | 10.528 | 14.332 | 28.289 | 15.684 | 21.221 |
| hex: canterbury/sum | 76482 | 15645.7 ± 0.1% | 1494.7 ± 0.1% | 1105.6 ± 0.2% | 593.8 ± 3.0% | 998.1 ± 0.1% | 744.5 ± 0.1% | 10.468 | 14.151 | 26.348 | 15.676 | 21.015 |
| hex: canterbury/xargs.1 | 8456 | 15053.3 ± 0.0% | 1495.0 ± 0.3% | 1096.7 ± 0.7% | 662.8 ± 7.6% | 1005.0 ± 0.2% | 728.2 ± 0.2% | 10.069 | 13.726 | 22.711 | 14.979 | 20.673 |
| hex: canterbury-large/E.coli | 524290 | 15648.8 ± 0.3% | 1477.8 ± 0.4% | 1088.7 ± 0.5% | 673.5 ± 0.3% | 995.0 ± 0.3% | 736.1 ± 0.4% | 10.589 | 14.374 | 23.235 | 15.728 | 21.260 |
| hex: canterbury-large/bible.txt | 524290 | 15590.7 ± 0.3% | 1465.9 ± 0.3% | 1085.3 ± 0.7% | 515.1 ± 0.4% | 994.1 ± 0.3% | 733.5 ± 0.5% | 10.636 | 14.365 | 30.266 | 15.683 | 21.255 |
| hex: canterbury-large/world192.txt | 524290 | 15630.4 ± 0.3% | 1472.3 ± 0.5% | 1087.3 ± 0.3% | 503.5 ± 0.7% | 992.0 ± 0.4% | 733.6 ± 0.7% | 10.616 | 14.375 | 31.043 | 15.757 | 21.308 |
| hex: http/html-1kx1024 | 2099200 | 13867.2 ± 0.7% | 1453.8 ± 0.3% | 1064.7 ± 0.3% | 501.7 ± 0.2% | 982.8 ± 0.2% | 691.9 ± 0.2% | 9.538 | 13.024 | 27.638 | 14.110 | 20.041 |
| hex: http/html-16kx64 | 2097280 | 15293.9 ± 0.6% | 1448.2 ± 0.4% | 1078.0 ± 0.3% | 507.9 ± 0.3% | 996.6 ± 0.1% | 735.4 ± 0.1% | 10.560 | 14.188 | 30.112 | 15.346 | 20.796 |
| hex: http/html-1m | 524290 | 15689.2 ± 0.2% | 1468.4 ± 0.3% | 1084.7 ± 0.2% | 501.7 ± 0.3% | 993.8 ± 0.3% | 734.5 ± 0.3% | 10.685 | 14.463 | 31.273 | 15.788 | 21.361 |
| hex: http/json-1kx1024 | 2099200 | 13873.0 ± 0.7% | 1463.9 ± 0.2% | 1069.0 ± 0.1% | 609.3 ± 0.4% | 986.7 ± 0.1% | 692.4 ± 0.0% | 9.477 | 12.978 | 22.770 | 14.059 | 20.035 |
| hex: http/json-16kx64 | 2097280 | 15332.0 ± 0.4% | 1449.1 ± 0.2% | 1076.9 ± 0.3% | 618.4 ± 0.6% | 998.0 ± 0.3% | 735.2 ± 0.1% | 10.580 | 14.237 | 24.794 | 15.363 | 20.853 |
| hex: http/json-1m | 524290 | 15656.9 ± 0.4% | 1474.6 ± 0.2% | 1087.4 ± 0.3% | 630.6 ± 0.7% | 995.6 ± 0.1% | 735.3 ± 0.7% | 10.618 | 14.399 | 24.828 | 15.726 | 21.294 |
| hex: http/js-1kx1024 | 2099200 | 13956.1 ± 0.7% | 1453.4 ± 0.3% | 1063.2 ± 0.2% | 498.8 ± 0.1% | 983.8 ± 0.2% | 692.3 ± 0.2% | 9.602 | 13.126 | 27.981 | 14.186 | 20.160 |
| hex: http/js-16kx64 | 2097280 | 15329.3 ± 0.2% | 1445.6 ± 0.1% | 1075.8 ± 0.2% | 506.0 ± 0.3% | 999.4 ± 0.3% | 735.4 ± 0.4% | 10.604 | 14.249 | 30.297 | 15.338 | 20.846 |
| hex: http/js-1m | 524290 | 15664.0 ± 0.4% | 1469.1 ± 0.2% | 1085.0 ± 0.4% | 508.6 ± 0.8% | 991.2 ± 0.5% | 735.0 ± 0.4% | 10.662 | 14.436 | 30.796 | 15.803 | 21.311 |
| hex: http/css-1kx1024 | 2099200 | 13842.2 ± 0.5% | 1454.4 ± 0.1% | 1064.3 ± 0.3% | 531.8 ± 0.4% | 984.2 ± 0.2% | 692.7 ± 0.4% | 9.518 | 13.006 | 26.028 | 14.065 | 19.984 |
| hex: http/css-16kx64 | 2097280 | 15286.2 ± 0.5% | 1446.2 ± 0.2% | 1074.7 ± 0.4% | 541.8 ± 0.9% | 999.9 ± 0.6% | 735.0 ± 0.2% | 10.570 | 14.223 | 28.212 | 15.288 | 20.796 |
| hex: http/css-1m | 524290 | 15681.9 ± 0.3% | 1471.4 ± 0.3% | 1084.7 ± 0.5% | 530.0 ± 0.8% | 995.7 ± 0.5% | 735.3 ± 0.4% | 10.658 | 14.458 | 29.588 | 15.750 | 21.328 |
| hex: shuffled/dickens-1m | 524290 | 15667.5 ± 0.3% | 1467.0 ± 0.3% | 1084.6 ± 0.3% | 500.9 ± 0.5% | 988.5 ± 0.5% | 736.4 ± 0.8% | 10.680 | 14.446 | 31.282 | 15.850 | 21.275 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 937.0 ± 0.7% | 934.4 ± 0.5% | 1027.5 ± 0.3% | 301.2 ± 0.9% | 663.3 ± 0.3% | 310.5 ± 1.5% | 1.003 | 0.912 | 3.111 | 1.413 | 3.018 |
| qlog records, JSON text sequence | 1467503 | 787.2 ± 0.4% | 818.5 ± 0.3% | 812.0 ± 1.5% | 244.8 ± 0.9% | 699.2 ± 0.7% | 252.7 ± 0.8% | 0.962 | 0.970 | 3.216 | 1.126 | 3.115 |
| string: silesia/dickens | 172528 | 5051.1 ± 0.3% | 1875.7 ± 0.1% | 2651.8 ± 0.5% | 361.5 ± 0.8% | 2843.4 ± 0.2% | 553.8 ± 2.2% | 2.693 | 1.905 | 13.971 | 1.776 | 9.121 |
| string: silesia/nci | 1075110 | 4310.5 ± 0.1% | 2241.8 ± 0.5% | 3004.8 ± 0.4% | 544.2 ± 0.9% | 3007.6 ± 0.6% | 600.1 ± 1.1% | 1.923 | 1.435 | 7.920 | 1.433 | 7.184 |
| string: silesia/reymont | 1075159 | 2998.7 ± 3.0% | 1825.2 ± 1.5% | 2067.2 ± 0.3% | 374.8 ± 1.0% | 2147.2 ± 1.0% | 532.7 ± 0.9% | 1.643 | 1.451 | 8.000 | 1.397 | 5.629 |
| string: silesia/samba | 97582 | 3505.5 ± 0.5% | 2025.5 ± 0.1% | 2614.9 ± 0.8% | 330.3 ± 0.5% | 1501.6 ± 0.7% | 432.1 ± 1.1% | 1.731 | 1.341 | 10.614 | 2.334 | 8.112 |
| string: silesia/webster | 1098490 | 3679.8 ± 0.3% | 1520.9 ± 0.3% | 2018.3 ± 0.7% | 359.3 ± 0.5% | 2170.9 ± 0.8% | 500.7 ± 2.0% | 2.420 | 1.823 | 10.243 | 1.695 | 7.350 |
| string: silesia/xml | 1090118 | 4815.1 ± 0.5% | 2367.4 ± 0.2% | 2535.3 ± 0.3% | 453.5 ± 1.2% | 2861.5 ± 0.8% | 567.8 ± 1.1% | 2.034 | 1.899 | 10.618 | 1.683 | 8.480 |
| string: canterbury/alice29.txt | 159425 | 4342.9 ± 0.8% | 1600.3 ± 0.2% | 2460.9 ± 0.8% | 342.6 ± 0.5% | 2493.1 ± 0.5% | 507.0 ± 0.9% | 2.714 | 1.765 | 12.676 | 1.742 | 8.566 |
| string: canterbury/asyoulik.txt | 132198 | 3484.1 ± 1.3% | 1458.5 ± 0.3% | 2242.8 ± 0.2% | 335.7 ± 0.3% | 2082.9 ± 0.8% | 465.2 ± 0.7% | 2.389 | 1.553 | 10.378 | 1.673 | 7.490 |
| string: canterbury/lcet10.txt | 441884 | 5143.2 ± 0.4% | 1853.1 ± 0.1% | 2344.3 ± 1.3% | 390.6 ± 0.4% | 2847.9 ± 0.7% | 539.2 ± 0.9% | 2.776 | 2.194 | 13.168 | 1.806 | 9.538 |
| string: canterbury/plrabn12.txt | 503330 | 4137.1 ± 0.4% | 1737.9 ± 0.1% | 2062.7 ± 0.7% | 360.9 ± 0.7% | 2504.4 ± 0.8% | 500.2 ± 1.9% | 2.381 | 2.006 | 11.464 | 1.652 | 8.271 |
| string: canterbury-large/E.coli | 1048578 | 11954.5 ± 0.2% | 3613.4 ± 0.3% | 3262.3 ± 0.4% | 931.0 ± 0.8% | 6090.3 ± 0.4% | 754.7 ± 1.7% | 3.308 | 3.664 | 12.840 | 1.963 | 15.840 |
| string: canterbury-large/bible.txt | 1055886 | 6966.8 ± 1.6% | 2945.8 ± 0.8% | 2845.4 ± 0.5% | 424.8 ± 1.1% | 3772.0 ± 1.3% | 612.8 ± 1.9% | 2.365 | 2.448 | 16.399 | 1.847 | 11.370 |
| string: canterbury-large/world192.txt | 1103121 | 3396.5 ± 0.6% | 1483.4 ± 0.2% | 2017.0 ± 0.7% | 353.7 ± 0.8% | 2118.7 ± 0.6% | 498.9 ± 0.7% | 2.290 | 1.684 | 9.602 | 1.603 | 6.807 |
| string: http/html-1m | 1058582 | 6231.5 ± 1.7% | 2737.6 ± 0.5% | 2707.4 ± 0.4% | 442.1 ± 0.5% | 3485.2 ± 0.6% | 597.9 ± 1.8% | 2.276 | 2.302 | 14.095 | 1.788 | 10.423 |
| string: http/json-1m | 1190272 | 2560.5 ± 0.5% | 877.6 ± 0.3% | 2256.9 ± 0.3% | 390.6 ± 0.5% | 1059.8 ± 0.3% | 438.4 ± 1.0% | 2.918 | 1.135 | 6.556 | 2.416 | 5.840 |
| string: http/js-1m | 1144362 | 2289.5 ± 0.3% | 1029.2 ± 0.1% | 1640.7 ± 0.5% | 321.3 ± 0.5% | 1524.2 ± 0.4% | 420.7 ± 1.4% | 2.225 | 1.395 | 7.125 | 1.502 | 5.443 |
| string: http/css-1m | 1097820 | 2652.8 ± 0.4% | 1679.5 ± 0.3% | 2232.4 ± 0.5% | 407.0 ± 1.1% | 1946.3 ± 0.5% | 490.7 ± 1.1% | 1.579 | 1.188 | 6.518 | 1.363 | 5.406 |
| string: dickens as Cyrillic and CJK | 1883069 | 3082.3 ± 0.5% | 1687.2 ± 0.4% | 895.3 ± 0.3% | 350.5 ± 0.2% | 668.7 ± 0.5% | 157.9 ± 2.2% | 1.827 | 3.443 | 8.795 | 4.609 | 19.523 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.2 ± 0.1% | 981.2 ± 0.4% | 1216.4 ± 1.5% | 216.3 ± 0.3% | 472.6 ± 0.9% | 252.0 ± 4.6% | 1.356 | 1.094 | 6.151 | 2.814 | 5.279 |
| hex: silesia/dickens | 524290 | 12017.7 ± 0.2% | 3622.0 ± 0.3% | 3305.3 ± 0.3% | 518.3 ± 1.0% | 6145.6 ± 0.8% | 784.7 ± 3.8% | 3.318 | 3.636 | 23.186 | 1.956 | 15.315 |
| hex: silesia/mozilla | 524290 | 11996.8 ± 0.1% | 3623.3 ± 0.3% | 3294.3 ± 0.5% | 452.9 ± 2.5% | 6083.1 ± 1.4% | 787.1 ± 0.5% | 3.311 | 3.642 | 26.487 | 1.972 | 15.241 |
| hex: silesia/mr | 524290 | 12010.7 ± 0.1% | 3620.1 ± 0.3% | 3306.0 ± 0.2% | 585.2 ± 3.5% | 6119.5 ± 2.0% | 785.4 ± 1.4% | 3.318 | 3.633 | 20.524 | 1.963 | 15.292 |
| hex: silesia/nci | 524290 | 12001.8 ± 0.1% | 3619.4 ± 0.2% | 3295.5 ± 0.2% | 635.5 ± 4.5% | 6096.0 ± 0.7% | 775.8 ± 0.3% | 3.316 | 3.642 | 18.885 | 1.969 | 15.470 |
| hex: silesia/ooffice | 524290 | 12001.5 ± 0.2% | 3620.3 ± 0.3% | 3291.4 ± 0.4% | 403.0 ± 1.2% | 6124.2 ± 1.5% | 776.9 ± 0.6% | 3.315 | 3.646 | 29.780 | 1.960 | 15.449 |
| hex: silesia/osdb | 524290 | 11985.5 ± 0.2% | 3617.2 ± 0.2% | 3290.9 ± 0.1% | 486.4 ± 0.4% | 6140.6 ± 1.3% | 777.3 ± 0.5% | 3.313 | 3.642 | 24.640 | 1.952 | 15.420 |
| hex: silesia/reymont | 524290 | 12015.4 ± 0.1% | 3621.3 ± 0.3% | 3291.2 ± 0.2% | 525.1 ± 1.8% | 6121.5 ± 1.1% | 777.1 ± 0.5% | 3.318 | 3.651 | 22.881 | 1.963 | 15.462 |
| hex: silesia/samba | 524290 | 12008.8 ± 0.1% | 3620.2 ± 0.0% | 3293.9 ± 0.1% | 407.5 ± 1.7% | 6102.2 ± 0.4% | 776.8 ± 0.5% | 3.317 | 3.646 | 29.472 | 1.968 | 15.459 |
| hex: silesia/sao | 524290 | 11996.8 ± 0.2% | 3619.3 ± 0.2% | 3303.2 ± 0.2% | 344.5 ± 0.4% | 6088.7 ± 1.0% | 775.7 ± 0.5% | 3.315 | 3.632 | 34.826 | 1.970 | 15.466 |
| hex: silesia/webster | 524290 | 11987.1 ± 0.2% | 3620.4 ± 0.6% | 3293.8 ± 0.2% | 475.0 ± 1.9% | 6085.5 ± 1.6% | 778.3 ± 0.6% | 3.311 | 3.639 | 25.237 | 1.970 | 15.401 |
| hex: silesia/x-ray | 524290 | 11985.9 ± 0.3% | 3619.5 ± 0.4% | 3295.3 ± 0.4% | 482.4 ± 0.4% | 6100.2 ± 2.2% | 778.5 ± 0.5% | 3.312 | 3.637 | 24.846 | 1.965 | 15.396 |
| hex: silesia/xml | 524290 | 12016.1 ± 0.1% | 3617.0 ± 0.1% | 3304.9 ± 0.2% | 529.1 ± 1.2% | 6089.9 ± 0.8% | 778.4 ± 0.4% | 3.322 | 3.636 | 22.711 | 1.973 | 15.436 |
| hex: canterbury/alice29.txt | 304180 | 12000.6 ± 0.1% | 3630.7 ± 0.1% | 3378.8 ± 0.1% | 516.2 ± 0.5% | 6128.5 ± 0.3% | 776.4 ± 0.8% | 3.305 | 3.552 | 23.248 | 1.958 | 15.456 |
| hex: canterbury/asyoulik.txt | 250360 | 11996.2 ± 0.1% | 3636.5 ± 0.1% | 3363.7 ± 0.2% | 507.8 ± 0.6% | 6156.5 ± 0.3% | 775.6 ± 0.3% | 3.299 | 3.566 | 23.623 | 1.949 | 15.466 |
| hex: canterbury/cp.html | 49208 | 11906.9 ± 0.1% | 3639.6 ± 0.0% | 3276.0 ± 0.3% | 474.6 ± 4.6% | 6278.6 ± 0.7% | 757.9 ± 0.8% | 3.271 | 3.635 | 25.089 | 1.896 | 15.711 |
| hex: canterbury/fields.c | 22302 | 11775.5 ± 0.0% | 3628.9 ± 0.1% | 3398.8 ± 0.3% | 495.4 ± 3.6% | 6259.1 ± 0.6% | 742.1 ± 3.0% | 3.245 | 3.465 | 23.769 | 1.881 | 15.867 |
| hex: canterbury/grammar.lsp | 7444 | 11251.7 ± 0.2% | 3601.1 ± 0.1% | 3359.2 ± 0.3% | 530.9 ± 6.9% | 6162.5 ± 0.7% | 700.4 ± 2.2% | 3.125 | 3.350 | 21.192 | 1.826 | 16.064 |
| hex: canterbury/kennedy.xls | 524290 | 12012.2 ± 0.2% | 3617.7 ± 0.2% | 3290.6 ± 0.2% | 659.1 ± 1.5% | 6111.3 ± 1.4% | 759.0 ± 6.6% | 3.320 | 3.650 | 18.226 | 1.966 | 15.826 |
| hex: canterbury/lcet10.txt | 524290 | 12004.1 ± 0.1% | 3618.0 ± 0.3% | 3306.1 ± 0.1% | 513.0 ± 0.4% | 6075.9 ± 2.1% | 765.4 ± 3.8% | 3.318 | 3.631 | 23.400 | 1.976 | 15.683 |
| hex: canterbury/plrabn12.txt | 524290 | 11997.8 ± 0.1% | 3617.5 ± 0.2% | 3299.2 ± 0.1% | 504.5 ± 0.5% | 6121.6 ± 2.3% | 767.9 ± 0.8% | 3.317 | 3.637 | 23.783 | 1.960 | 15.624 |
| hex: canterbury/ptt5 | 524290 | 12014.8 ± 0.1% | 3619.1 ± 0.2% | 3294.4 ± 0.4% | 559.2 ± 0.9% | 6073.4 ± 1.3% | 780.1 ± 2.1% | 3.320 | 3.647 | 21.487 | 1.978 | 15.401 |
| hex: canterbury/sum | 76482 | 11899.8 ± 0.1% | 3632.0 ± 0.0% | 3362.5 ± 0.2% | 507.6 ± 0.2% | 6174.4 ± 0.1% | 774.9 ± 0.7% | 3.276 | 3.539 | 23.444 | 1.927 | 15.357 |
| hex: canterbury/xargs.1 | 8456 | 11335.2 ± 0.1% | 3602.6 ± 0.0% | 3374.0 ± 0.3% | 485.9 ± 1.8% | 6144.7 ± 0.1% | 751.7 ± 2.6% | 3.146 | 3.360 | 23.331 | 1.845 | 15.079 |
| hex: canterbury-large/E.coli | 524290 | 11962.2 ± 0.2% | 3618.2 ± 0.4% | 3301.6 ± 0.3% | 688.4 ± 0.3% | 6073.4 ± 1.3% | 756.7 ± 4.4% | 3.306 | 3.623 | 17.376 | 1.970 | 15.808 |
| hex: canterbury-large/bible.txt | 524290 | 12012.6 ± 0.2% | 3621.0 ± 0.2% | 3298.9 ± 0.2% | 512.4 ± 2.6% | 6112.2 ± 1.2% | 763.1 ± 1.1% | 3.318 | 3.641 | 23.445 | 1.965 | 15.741 |
| hex: canterbury-large/world192.txt | 524290 | 11976.0 ± 0.1% | 3617.5 ± 0.1% | 3296.7 ± 0.3% | 491.7 ± 0.8% | 6146.3 ± 0.6% | 760.8 ± 1.1% | 3.311 | 3.633 | 24.358 | 1.948 | 15.742 |
| hex: http/html-1kx1024 | 2099200 | 8826.3 ± 3.1% | 3463.3 ± 0.2% | 2885.5 ± 0.6% | 471.7 ± 0.5% | 5151.3 ± 1.4% | 629.5 ± 2.4% | 2.549 | 3.059 | 18.710 | 1.713 | 14.022 |
| hex: http/html-16kx64 | 2097280 | 11784.9 ± 0.1% | 3612.7 ± 0.2% | 3269.9 ± 0.3% | 479.7 ± 1.2% | 6031.8 ± 0.9% | 753.8 ± 2.5% | 3.262 | 3.604 | 24.566 | 1.954 | 15.634 |
| hex: http/html-1m | 524290 | 11939.7 ± 0.3% | 3620.9 ± 0.2% | 3289.2 ± 0.3% | 497.4 ± 1.0% | 6105.9 ± 2.2% | 773.9 ± 1.4% | 3.297 | 3.630 | 24.005 | 1.955 | 15.428 |
| hex: http/json-1kx1024 | 2099200 | 8827.6 ± 4.6% | 3464.0 ± 0.2% | 2891.9 ± 0.5% | 573.2 ± 0.6% | 5153.6 ± 0.9% | 645.9 ± 3.6% | 2.548 | 3.053 | 15.402 | 1.713 | 13.668 |
| hex: http/json-16kx64 | 2097280 | 11781.9 ± 0.3% | 3612.6 ± 0.2% | 3269.4 ± 0.4% | 570.0 ± 0.9% | 6038.8 ± 1.3% | 748.9 ± 2.7% | 3.261 | 3.604 | 20.670 | 1.951 | 15.732 |
| hex: http/json-1m | 524290 | 12026.3 ± 0.1% | 3623.7 ± 0.2% | 3304.5 ± 0.5% | 594.4 ± 2.6% | 6117.0 ± 1.8% | 751.1 ± 1.2% | 3.319 | 3.639 | 20.232 | 1.966 | 16.011 |
| hex: http/js-1kx1024 | 2099200 | 8932.8 ± 4.0% | 3458.2 ± 0.3% | 2905.0 ± 0.5% | 478.8 ± 0.7% | 5151.7 ± 1.7% | 658.0 ± 1.9% | 2.583 | 3.075 | 18.656 | 1.734 | 13.576 |
| hex: http/js-16kx64 | 2097280 | 11783.3 ± 0.7% | 3612.5 ± 0.6% | 3261.6 ± 3.6% | 479.2 ± 0.5% | 6054.5 ± 0.9% | 757.0 ± 2.6% | 3.262 | 3.613 | 24.589 | 1.946 | 15.566 |
| hex: http/js-1m | 524290 | 11977.7 ± 0.2% | 3623.5 ± 0.4% | 3305.8 ± 0.3% | 497.6 ± 2.2% | 6089.0 ± 0.9% | 751.6 ± 2.6% | 3.306 | 3.623 | 24.070 | 1.967 | 15.936 |
| hex: http/css-1kx1024 | 2099200 | 8973.2 ± 2.8% | 3463.7 ± 0.1% | 2892.5 ± 0.5% | 488.5 ± 0.7% | 5160.4 ± 0.7% | 653.8 ± 1.6% | 2.591 | 3.102 | 18.370 | 1.739 | 13.725 |
| hex: http/css-16kx64 | 2097280 | 11770.6 ± 0.2% | 3612.0 ± 0.1% | 3267.1 ± 0.4% | 497.0 ± 0.8% | 6021.3 ± 0.5% | 753.1 ± 1.0% | 3.259 | 3.603 | 23.686 | 1.955 | 15.630 |
| hex: http/css-1m | 524290 | 11965.2 ± 0.2% | 3627.0 ± 0.1% | 3300.2 ± 0.3% | 491.5 ± 2.8% | 6070.2 ± 1.3% | 757.4 ± 2.1% | 3.299 | 3.626 | 24.346 | 1.971 | 15.798 |
| hex: shuffled/dickens-1m | 524290 | 12024.3 ± 0.3% | 3624.6 ± 0.3% | 3299.9 ± 0.4% | 514.4 ± 0.4% | 6153.1 ± 1.3% | 763.4 ± 0.8% | 3.317 | 3.644 | 23.373 | 1.954 | 15.751 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1013.6 ± 0.4% | 934.4 ± 0.5% | 1027.5 ± 0.3% | 301.2 ± 0.9% | 663.3 ± 0.3% | 310.5 ± 1.5% | 1.085 | 0.986 | 3.366 | 1.528 | 3.265 |
| qlog records, JSON text sequence | 1467503 | 841.7 ± 0.2% | 818.5 ± 0.3% | 812.0 ± 1.5% | 244.8 ± 0.9% | 699.2 ± 0.7% | 252.7 ± 0.8% | 1.028 | 1.037 | 3.439 | 1.204 | 3.330 |
| string: silesia/dickens | 172528 | 5034.2 ± 0.4% | 1875.7 ± 0.1% | 2651.8 ± 0.5% | 361.5 ± 0.8% | 2843.4 ± 0.2% | 553.8 ± 2.2% | 2.684 | 1.898 | 13.925 | 1.770 | 9.091 |
| string: silesia/nci | 1075110 | 4313.4 ± 0.3% | 2241.8 ± 0.5% | 3004.8 ± 0.4% | 544.2 ± 0.9% | 3007.6 ± 0.6% | 600.1 ± 1.1% | 1.924 | 1.436 | 7.925 | 1.434 | 7.188 |
| string: silesia/reymont | 1075159 | 3001.2 ± 3.2% | 1825.2 ± 1.5% | 2067.2 ± 0.3% | 374.8 ± 1.0% | 2147.2 ± 1.0% | 532.7 ± 0.9% | 1.644 | 1.452 | 8.007 | 1.398 | 5.634 |
| string: silesia/samba | 97582 | 3513.0 ± 0.5% | 2025.5 ± 0.1% | 2614.9 ± 0.8% | 330.3 ± 0.5% | 1501.6 ± 0.7% | 432.1 ± 1.1% | 1.734 | 1.343 | 10.637 | 2.339 | 8.130 |
| string: silesia/webster | 1098490 | 3670.9 ± 0.6% | 1520.9 ± 0.3% | 2018.3 ± 0.7% | 359.3 ± 0.5% | 2170.9 ± 0.8% | 500.7 ± 2.0% | 2.414 | 1.819 | 10.218 | 1.691 | 7.332 |
| string: silesia/xml | 1090118 | 4823.2 ± 0.4% | 2367.4 ± 0.2% | 2535.3 ± 0.3% | 453.5 ± 1.2% | 2861.5 ± 0.8% | 567.8 ± 1.1% | 2.037 | 1.902 | 10.635 | 1.686 | 8.494 |
| string: canterbury/alice29.txt | 159425 | 4354.5 ± 0.9% | 1600.3 ± 0.2% | 2460.9 ± 0.8% | 342.6 ± 0.5% | 2493.1 ± 0.5% | 507.0 ± 0.9% | 2.721 | 1.769 | 12.710 | 1.747 | 8.589 |
| string: canterbury/asyoulik.txt | 132198 | 3488.1 ± 1.2% | 1458.5 ± 0.3% | 2242.8 ± 0.2% | 335.7 ± 0.3% | 2082.9 ± 0.8% | 465.2 ± 0.7% | 2.392 | 1.555 | 10.390 | 1.675 | 7.499 |
| string: canterbury/lcet10.txt | 441884 | 5140.2 ± 0.4% | 1853.1 ± 0.1% | 2344.3 ± 1.3% | 390.6 ± 0.4% | 2847.9 ± 0.7% | 539.2 ± 0.9% | 2.774 | 2.193 | 13.161 | 1.805 | 9.533 |
| string: canterbury/plrabn12.txt | 503330 | 4136.3 ± 0.1% | 1737.9 ± 0.1% | 2062.7 ± 0.7% | 360.9 ± 0.7% | 2504.4 ± 0.8% | 500.2 ± 1.9% | 2.380 | 2.005 | 11.461 | 1.652 | 8.269 |
| string: canterbury-large/E.coli | 1048578 | 11960.6 ± 0.3% | 3613.4 ± 0.3% | 3262.3 ± 0.4% | 931.0 ± 0.8% | 6090.3 ± 0.4% | 754.7 ± 1.7% | 3.310 | 3.666 | 12.847 | 1.964 | 15.848 |
| string: canterbury-large/bible.txt | 1055886 | 6987.2 ± 1.6% | 2945.8 ± 0.8% | 2845.4 ± 0.5% | 424.8 ± 1.1% | 3772.0 ± 1.3% | 612.8 ± 1.9% | 2.372 | 2.456 | 16.447 | 1.852 | 11.403 |
| string: canterbury-large/world192.txt | 1103121 | 3393.7 ± 0.7% | 1483.4 ± 0.2% | 2017.0 ± 0.7% | 353.7 ± 0.8% | 2118.7 ± 0.6% | 498.9 ± 0.7% | 2.288 | 1.682 | 9.594 | 1.602 | 6.802 |
| string: http/html-1m | 1058582 | 6275.1 ± 1.8% | 2737.6 ± 0.5% | 2707.4 ± 0.4% | 442.1 ± 0.5% | 3485.2 ± 0.6% | 597.9 ± 1.8% | 2.292 | 2.318 | 14.194 | 1.800 | 10.496 |
| string: http/json-1m | 1190272 | 2560.8 ± 0.4% | 877.6 ± 0.3% | 2256.9 ± 0.3% | 390.6 ± 0.5% | 1059.8 ± 0.3% | 438.4 ± 1.0% | 2.918 | 1.135 | 6.556 | 2.416 | 5.841 |
| string: http/js-1m | 1144362 | 2289.5 ± 0.6% | 1029.2 ± 0.1% | 1640.7 ± 0.5% | 321.3 ± 0.5% | 1524.2 ± 0.4% | 420.7 ± 1.4% | 2.225 | 1.395 | 7.126 | 1.502 | 5.443 |
| string: http/css-1m | 1097820 | 2664.0 ± 0.5% | 1679.5 ± 0.3% | 2232.4 ± 0.5% | 407.0 ± 1.1% | 1946.3 ± 0.5% | 490.7 ± 1.1% | 1.586 | 1.193 | 6.545 | 1.369 | 5.429 |
| string: dickens as Cyrillic and CJK | 1883069 | 3082.7 ± 0.1% | 1687.2 ± 0.4% | 895.3 ± 0.3% | 350.5 ± 0.2% | 668.7 ± 0.5% | 157.9 ± 2.2% | 1.827 | 3.443 | 8.796 | 4.610 | 19.526 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1328.6 ± 0.4% | 981.2 ± 0.4% | 1216.4 ± 1.5% | 216.3 ± 0.3% | 472.6 ± 0.9% | 252.0 ± 4.6% | 1.354 | 1.092 | 6.143 | 2.811 | 5.273 |
| hex: silesia/dickens | 524290 | 12022.7 ± 0.0% | 3622.0 ± 0.3% | 3305.3 ± 0.3% | 518.3 ± 1.0% | 6145.6 ± 0.8% | 784.7 ± 3.8% | 3.319 | 3.637 | 23.196 | 1.956 | 15.321 |
| hex: silesia/mozilla | 524290 | 11993.5 ± 0.1% | 3623.3 ± 0.3% | 3294.3 ± 0.5% | 452.9 ± 2.5% | 6083.1 ± 1.4% | 787.1 ± 0.5% | 3.310 | 3.641 | 26.480 | 1.972 | 15.237 |
| hex: silesia/mr | 524290 | 12014.9 ± 0.1% | 3620.1 ± 0.3% | 3306.0 ± 0.2% | 585.2 ± 3.5% | 6119.5 ± 2.0% | 785.4 ± 1.4% | 3.319 | 3.634 | 20.531 | 1.963 | 15.298 |
| hex: silesia/nci | 524290 | 12004.8 ± 0.2% | 3619.4 ± 0.2% | 3295.5 ± 0.2% | 635.5 ± 4.5% | 6096.0 ± 0.7% | 775.8 ± 0.3% | 3.317 | 3.643 | 18.890 | 1.969 | 15.474 |
| hex: silesia/ooffice | 524290 | 12012.1 ± 0.1% | 3620.3 ± 0.3% | 3291.4 ± 0.4% | 403.0 ± 1.2% | 6124.2 ± 1.5% | 776.9 ± 0.6% | 3.318 | 3.649 | 29.806 | 1.961 | 15.462 |
| hex: silesia/osdb | 524290 | 11991.7 ± 0.1% | 3617.2 ± 0.2% | 3290.9 ± 0.1% | 486.4 ± 0.4% | 6140.6 ± 1.3% | 777.3 ± 0.5% | 3.315 | 3.644 | 24.653 | 1.953 | 15.428 |
| hex: silesia/reymont | 524290 | 12020.8 ± 0.1% | 3621.3 ± 0.3% | 3291.2 ± 0.2% | 525.1 ± 1.8% | 6121.5 ± 1.1% | 777.1 ± 0.5% | 3.319 | 3.652 | 22.891 | 1.964 | 15.469 |
| hex: silesia/samba | 524290 | 12010.2 ± 0.1% | 3620.2 ± 0.0% | 3293.9 ± 0.1% | 407.5 ± 1.7% | 6102.2 ± 0.4% | 776.8 ± 0.5% | 3.318 | 3.646 | 29.475 | 1.968 | 15.461 |
| hex: silesia/sao | 524290 | 11994.4 ± 0.2% | 3619.3 ± 0.2% | 3303.2 ± 0.2% | 344.5 ± 0.4% | 6088.7 ± 1.0% | 775.7 ± 0.5% | 3.314 | 3.631 | 34.819 | 1.970 | 15.463 |
| hex: silesia/webster | 524290 | 11991.3 ± 0.1% | 3620.4 ± 0.6% | 3293.8 ± 0.2% | 475.0 ± 1.9% | 6085.5 ± 1.6% | 778.3 ± 0.6% | 3.312 | 3.641 | 25.246 | 1.970 | 15.406 |
| hex: silesia/x-ray | 524290 | 11999.0 ± 0.1% | 3619.5 ± 0.4% | 3295.3 ± 0.4% | 482.4 ± 0.4% | 6100.2 ± 2.2% | 778.5 ± 0.5% | 3.315 | 3.641 | 24.873 | 1.967 | 15.413 |
| hex: silesia/xml | 524290 | 12008.9 ± 0.1% | 3617.0 ± 0.1% | 3304.9 ± 0.2% | 529.1 ± 1.2% | 6089.9 ± 0.8% | 778.4 ± 0.4% | 3.320 | 3.634 | 22.697 | 1.972 | 15.427 |
| hex: canterbury/alice29.txt | 304180 | 12006.7 ± 0.0% | 3630.7 ± 0.1% | 3378.8 ± 0.1% | 516.2 ± 0.5% | 6128.5 ± 0.3% | 776.4 ± 0.8% | 3.307 | 3.554 | 23.260 | 1.959 | 15.464 |
| hex: canterbury/asyoulik.txt | 250360 | 12006.1 ± 0.1% | 3636.5 ± 0.1% | 3363.7 ± 0.2% | 507.8 ± 0.6% | 6156.5 ± 0.3% | 775.6 ± 0.3% | 3.302 | 3.569 | 23.643 | 1.950 | 15.479 |
| hex: canterbury/cp.html | 49208 | 11907.1 ± 0.4% | 3639.6 ± 0.0% | 3276.0 ± 0.3% | 474.6 ± 4.6% | 6278.6 ± 0.7% | 757.9 ± 0.8% | 3.272 | 3.635 | 25.089 | 1.896 | 15.711 |
| hex: canterbury/fields.c | 22302 | 11779.5 ± 0.0% | 3628.9 ± 0.1% | 3398.8 ± 0.3% | 495.4 ± 3.6% | 6259.1 ± 0.6% | 742.1 ± 3.0% | 3.246 | 3.466 | 23.777 | 1.882 | 15.872 |
| hex: canterbury/grammar.lsp | 7444 | 11250.4 ± 0.7% | 3601.1 ± 0.1% | 3359.2 ± 0.3% | 530.9 ± 6.9% | 6162.5 ± 0.7% | 700.4 ± 2.2% | 3.124 | 3.349 | 21.190 | 1.826 | 16.062 |
| hex: canterbury/kennedy.xls | 524290 | 12017.0 ± 0.1% | 3617.7 ± 0.2% | 3290.6 ± 0.2% | 659.1 ± 1.5% | 6111.3 ± 1.4% | 759.0 ± 6.6% | 3.322 | 3.652 | 18.233 | 1.966 | 15.833 |
| hex: canterbury/lcet10.txt | 524290 | 12012.7 ± 0.1% | 3618.0 ± 0.3% | 3306.1 ± 0.1% | 513.0 ± 0.4% | 6075.9 ± 2.1% | 765.4 ± 3.8% | 3.320 | 3.633 | 23.416 | 1.977 | 15.694 |
| hex: canterbury/plrabn12.txt | 524290 | 11997.9 ± 0.1% | 3617.5 ± 0.2% | 3299.2 ± 0.1% | 504.5 ± 0.5% | 6121.6 ± 2.3% | 767.9 ± 0.8% | 3.317 | 3.637 | 23.783 | 1.960 | 15.624 |
| hex: canterbury/ptt5 | 524290 | 12007.0 ± 0.1% | 3619.1 ± 0.2% | 3294.4 ± 0.4% | 559.2 ± 0.9% | 6073.4 ± 1.3% | 780.1 ± 2.1% | 3.318 | 3.645 | 21.473 | 1.977 | 15.391 |
| hex: canterbury/sum | 76482 | 11900.4 ± 0.2% | 3632.0 ± 0.0% | 3362.5 ± 0.2% | 507.6 ± 0.2% | 6174.4 ± 0.1% | 774.9 ± 0.7% | 3.277 | 3.539 | 23.445 | 1.927 | 15.358 |
| hex: canterbury/xargs.1 | 8456 | 11339.0 ± 0.1% | 3602.6 ± 0.0% | 3374.0 ± 0.3% | 485.9 ± 1.8% | 6144.7 ± 0.1% | 751.7 ± 2.6% | 3.147 | 3.361 | 23.339 | 1.845 | 15.084 |
| hex: canterbury-large/E.coli | 524290 | 11953.8 ± 0.1% | 3618.2 ± 0.4% | 3301.6 ± 0.3% | 688.4 ± 0.3% | 6073.4 ± 1.3% | 756.7 ± 4.4% | 3.304 | 3.621 | 17.364 | 1.968 | 15.797 |
| hex: canterbury-large/bible.txt | 524290 | 12012.6 ± 0.1% | 3621.0 ± 0.2% | 3298.9 ± 0.2% | 512.4 ± 2.6% | 6112.2 ± 1.2% | 763.1 ± 1.1% | 3.318 | 3.641 | 23.445 | 1.965 | 15.742 |
| hex: canterbury-large/world192.txt | 524290 | 11980.2 ± 0.4% | 3617.5 ± 0.1% | 3296.7 ± 0.3% | 491.7 ± 0.8% | 6146.3 ± 0.6% | 760.8 ± 1.1% | 3.312 | 3.634 | 24.366 | 1.949 | 15.747 |
| hex: http/html-1kx1024 | 2099200 | 8921.7 ± 3.2% | 3463.3 ± 0.2% | 2885.5 ± 0.6% | 471.7 ± 0.5% | 5151.3 ± 1.4% | 629.5 ± 2.4% | 2.576 | 3.092 | 18.912 | 1.732 | 14.173 |
| hex: http/html-16kx64 | 2097280 | 11785.5 ± 0.2% | 3612.7 ± 0.2% | 3269.9 ± 0.3% | 479.7 ± 1.2% | 6031.8 ± 0.9% | 753.8 ± 2.5% | 3.262 | 3.604 | 24.567 | 1.954 | 15.635 |
| hex: http/html-1m | 524290 | 11976.8 ± 0.3% | 3620.9 ± 0.2% | 3289.2 ± 0.3% | 497.4 ± 1.0% | 6105.9 ± 2.2% | 773.9 ± 1.4% | 3.308 | 3.641 | 24.079 | 1.962 | 15.476 |
| hex: http/json-1kx1024 | 2099200 | 8930.0 ± 4.6% | 3464.0 ± 0.2% | 2891.9 ± 0.5% | 573.2 ± 0.6% | 5153.6 ± 0.9% | 645.9 ± 3.6% | 2.578 | 3.088 | 15.581 | 1.733 | 13.827 |
| hex: http/json-16kx64 | 2097280 | 11777.9 ± 0.2% | 3612.6 ± 0.2% | 3269.4 ± 0.4% | 570.0 ± 0.9% | 6038.8 ± 1.3% | 748.9 ± 2.7% | 3.260 | 3.602 | 20.663 | 1.950 | 15.727 |
| hex: http/json-1m | 524290 | 12024.7 ± 0.1% | 3623.7 ± 0.2% | 3304.5 ± 0.5% | 594.4 ± 2.6% | 6117.0 ± 1.8% | 751.1 ± 1.2% | 3.318 | 3.639 | 20.229 | 1.966 | 16.009 |
| hex: http/js-1kx1024 | 2099200 | 9000.9 ± 4.1% | 3458.2 ± 0.3% | 2905.0 ± 0.5% | 478.8 ± 0.7% | 5151.7 ± 1.7% | 658.0 ± 1.9% | 2.603 | 3.098 | 18.798 | 1.747 | 13.679 |
| hex: http/js-16kx64 | 2097280 | 11779.3 ± 0.1% | 3612.5 ± 0.6% | 3261.6 ± 3.6% | 479.2 ± 0.5% | 6054.5 ± 0.9% | 757.0 ± 2.6% | 3.261 | 3.612 | 24.580 | 1.946 | 15.561 |
| hex: http/js-1m | 524290 | 12006.7 ± 0.3% | 3623.5 ± 0.4% | 3305.8 ± 0.3% | 497.6 ± 2.2% | 6089.0 ± 0.9% | 751.6 ± 2.6% | 3.314 | 3.632 | 24.128 | 1.972 | 15.975 |
| hex: http/css-1kx1024 | 2099200 | 8986.7 ± 3.2% | 3463.7 ± 0.1% | 2892.5 ± 0.5% | 488.5 ± 0.7% | 5160.4 ± 0.7% | 653.8 ± 1.6% | 2.595 | 3.107 | 18.397 | 1.741 | 13.745 |
| hex: http/css-16kx64 | 2097280 | 11777.6 ± 0.2% | 3612.0 ± 0.1% | 3267.1 ± 0.4% | 497.0 ± 0.8% | 6021.3 ± 0.5% | 753.1 ± 1.0% | 3.261 | 3.605 | 23.700 | 1.956 | 15.640 |
| hex: http/css-1m | 524290 | 11986.4 ± 0.1% | 3627.0 ± 0.1% | 3300.2 ± 0.3% | 491.5 ± 2.8% | 6070.2 ± 1.3% | 757.4 ± 2.1% | 3.305 | 3.632 | 24.389 | 1.975 | 15.826 |
| hex: shuffled/dickens-1m | 524290 | 12024.7 ± 0.2% | 3624.6 ± 0.3% | 3299.9 ± 0.4% | 514.4 ± 0.4% | 6153.1 ± 1.3% | 763.4 ± 0.8% | 3.318 | 3.644 | 23.374 | 1.954 | 15.751 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1363.3 ± 0.4% | 1260.4 ± 0.5% | 1047.8 ± 0.9% | 411.1 ± 0.3% | 448.8 ± 0.3% | 418.0 ± 0.4% | 1.082 | 1.301 | 3.316 | 3.038 | 3.261 |
| qlog records, JSON text sequence | 1467503 | 1052.6 ± 0.3% | 1064.5 ± 0.4% | 788.6 ± 0.6% | 380.0 ± 0.7% | 470.8 ± 0.9% | 278.9 ± 0.7% | 0.989 | 1.335 | 2.770 | 2.236 | 3.774 |
| string: silesia/dickens | 172528 | 6901.9 ± 0.3% | 2818.5 ± 0.4% | 2935.6 ± 0.6% | 430.7 ± 0.5% | 1569.4 ± 0.4% | 1007.7 ± 0.1% | 2.449 | 2.351 | 16.024 | 4.398 | 6.849 |
| string: silesia/nci | 1075110 | 7319.1 ± 0.4% | 3441.7 ± 1.1% | 3103.5 ± 0.4% | 818.9 ± 0.8% | 1858.0 ± 0.3% | 1110.6 ± 0.2% | 2.127 | 2.358 | 8.937 | 3.939 | 6.590 |
| string: silesia/reymont | 1075159 | 3330.4 ± 1.2% | 1989.4 ± 1.9% | 2061.8 ± 0.7% | 451.4 ± 0.5% | 1513.0 ± 0.7% | 951.6 ± 0.5% | 1.674 | 1.615 | 7.378 | 2.201 | 3.500 |
| string: silesia/samba | 97582 | 4210.2 ± 0.8% | 2115.5 ± 0.5% | 3446.5 ± 0.8% | 353.8 ± 0.6% | 1434.7 ± 0.4% | 1055.3 ± 0.1% | 1.990 | 1.222 | 11.900 | 2.935 | 3.990 |
| string: silesia/webster | 1098490 | 4078.3 ± 0.4% | 1887.3 ± 0.6% | 2060.1 ± 0.5% | 441.4 ± 0.8% | 1389.4 ± 0.2% | 646.8 ± 0.8% | 2.161 | 1.980 | 9.239 | 2.935 | 6.305 |
| string: silesia/xml | 1090118 | 6142.9 ± 0.6% | 2881.6 ± 0.6% | 2654.2 ± 0.3% | 614.0 ± 0.5% | 1756.0 ± 0.4% | 923.6 ± 0.5% | 2.132 | 2.314 | 10.005 | 3.498 | 6.651 |
| string: canterbury/alice29.txt | 159425 | 6439.1 ± 1.2% | 2201.3 ± 0.5% | 2762.0 ± 0.8% | 407.9 ± 0.6% | 1462.7 ± 0.1% | 953.7 ± 0.2% | 2.925 | 2.331 | 15.785 | 4.402 | 6.751 |
| string: canterbury/asyoulik.txt | 132198 | 5672.1 ± 1.3% | 1715.1 ± 0.6% | 2375.8 ± 0.6% | 403.0 ± 0.5% | 1337.5 ± 1.0% | 885.5 ± 0.1% | 3.307 | 2.387 | 14.076 | 4.241 | 6.405 |
| string: canterbury/lcet10.txt | 441884 | 6268.7 ± 0.4% | 2571.7 ± 0.4% | 2484.8 ± 1.9% | 466.9 ± 0.8% | 1523.9 ± 0.3% | 989.3 ± 0.7% | 2.438 | 2.523 | 13.426 | 4.114 | 6.337 |
| string: canterbury/plrabn12.txt | 503330 | 5735.4 ± 0.4% | 2061.9 ± 0.3% | 2076.5 ± 0.8% | 425.2 ± 0.6% | 1410.7 ± 0.4% | 937.2 ± 0.4% | 2.782 | 2.762 | 13.489 | 4.066 | 6.120 |
| string: canterbury-large/E.coli | 1048578 | 19341.4 ± 0.5% | 9875.1 ± 0.9% | 3800.8 ± 0.6% | 1474.8 ± 0.8% | 2363.6 ± 0.7% | 1199.4 ± 0.9% | 1.959 | 5.089 | 13.115 | 8.183 | 16.126 |
| string: canterbury-large/bible.txt | 1055886 | 6800.6 ± 0.6% | 4174.8 ± 0.6% | 3034.0 ± 1.4% | 502.4 ± 0.3% | 1986.9 ± 0.7% | 1122.8 ± 0.5% | 1.629 | 2.241 | 13.535 | 3.423 | 6.057 |
| string: canterbury-large/world192.txt | 1103121 | 4071.9 ± 0.2% | 1663.5 ± 0.5% | 2002.3 ± 1.1% | 449.2 ± 0.8% | 1357.4 ± 0.2% | 910.6 ± 0.3% | 2.448 | 2.034 | 9.064 | 3.000 | 4.471 |
| string: http/html-1m | 1058582 | 6792.0 ± 0.4% | 3999.3 ± 0.5% | 3049.2 ± 0.3% | 501.7 ± 0.9% | 1930.3 ± 0.5% | 808.9 ± 0.5% | 1.698 | 2.227 | 13.538 | 3.519 | 8.397 |
| string: http/json-1m | 1190272 | 3171.4 ± 0.4% | 1354.1 ± 0.4% | 1562.3 ± 0.2% | 445.8 ± 1.2% | 963.7 ± 0.2% | 765.7 ± 1.3% | 2.342 | 2.030 | 7.113 | 3.291 | 4.142 |
| string: http/js-1m | 1144362 | 2783.7 ± 0.7% | 1180.8 ± 0.4% | 1624.7 ± 0.8% | 368.9 ± 0.6% | 1095.2 ± 0.2% | 759.8 ± 0.2% | 2.358 | 1.713 | 7.546 | 2.542 | 3.664 |
| string: http/css-1m | 1097820 | 4015.8 ± 0.6% | 1489.3 ± 0.5% | 2159.1 ± 0.4% | 495.3 ± 0.2% | 1369.6 ± 0.6% | 898.0 ± 0.5% | 2.696 | 1.860 | 8.108 | 2.932 | 4.472 |
| string: dickens as Cyrillic and CJK | 1883069 | 3072.0 ± 0.3% | 2345.6 ± 0.6% | 522.1 ± 0.5% | 308.4 ± 1.2% | 563.8 ± 1.3% | 336.5 ± 0.3% | 1.310 | 5.884 | 9.960 | 5.449 | 9.130 |
| hex: silesia/dickens | 524290 | 15656.6 ± 0.4% | 1469.8 ± 0.4% | 1085.9 ± 0.8% | 496.9 ± 1.5% | 987.3 ± 0.5% | 736.0 ± 1.0% | 10.652 | 14.418 | 31.506 | 15.858 | 21.272 |
| hex: silesia/mozilla | 524290 | 15624.9 ± 0.1% | 1478.7 ± 0.3% | 1089.0 ± 0.4% | 441.3 ± 0.3% | 992.7 ± 0.4% | 735.8 ± 0.5% | 10.566 | 14.347 | 35.410 | 15.740 | 21.234 |
| hex: silesia/mr | 524290 | 15684.1 ± 0.2% | 1488.9 ± 0.3% | 1092.2 ± 0.5% | 547.2 ± 1.8% | 994.1 ± 0.7% | 736.8 ± 0.9% | 10.534 | 14.361 | 28.660 | 15.777 | 21.287 |
| hex: silesia/nci | 524290 | 15644.7 ± 0.3% | 1477.0 ± 0.6% | 1088.2 ± 0.5% | 638.4 ± 7.4% | 994.2 ± 0.5% | 735.9 ± 0.2% | 10.592 | 14.376 | 24.507 | 15.736 | 21.258 |
| hex: silesia/ooffice | 524290 | 15579.4 ± 0.5% | 1470.5 ± 0.5% | 1084.0 ± 0.6% | 389.1 ± 0.2% | 989.0 ± 0.4% | 734.5 ± 0.5% | 10.595 | 14.372 | 40.042 | 15.753 | 21.212 |
| hex: silesia/osdb | 524290 | 15611.9 ± 0.5% | 1472.9 ± 0.1% | 1089.4 ± 0.3% | 470.4 ± 1.4% | 991.2 ± 0.9% | 734.9 ± 0.3% | 10.599 | 14.330 | 33.190 | 15.750 | 21.243 |
| hex: silesia/reymont | 524290 | 15670.9 ± 0.4% | 1469.1 ± 0.4% | 1087.9 ± 0.3% | 516.4 ± 1.1% | 988.9 ± 0.6% | 736.2 ± 0.5% | 10.667 | 14.404 | 30.349 | 15.847 | 21.287 |
| hex: silesia/samba | 524290 | 15675.6 ± 0.4% | 1469.7 ± 0.2% | 1083.2 ± 0.5% | 402.8 ± 0.4% | 990.5 ± 0.7% | 734.6 ± 0.4% | 10.666 | 14.471 | 38.917 | 15.826 | 21.338 |
| hex: silesia/sao | 524290 | 15666.9 ± 0.3% | 1469.6 ± 0.3% | 1086.0 ± 0.5% | 332.7 ± 0.3% | 987.0 ± 0.6% | 736.1 ± 0.6% | 10.661 | 14.426 | 47.086 | 15.874 | 21.283 |
| hex: silesia/webster | 524290 | 15687.1 ± 0.2% | 1468.6 ± 0.2% | 1088.4 ± 0.6% | 472.9 ± 0.4% | 990.7 ± 0.5% | 736.3 ± 0.3% | 10.682 | 14.414 | 33.173 | 15.835 | 21.305 |
| hex: silesia/x-ray | 524290 | 15626.1 ± 0.4% | 1483.7 ± 0.2% | 1091.6 ± 0.1% | 445.5 ± 0.2% | 993.8 ± 0.3% | 735.9 ± 0.4% | 10.532 | 14.315 | 35.077 | 15.724 | 21.235 |
| hex: silesia/xml | 524290 | 15669.3 ± 0.2% | 1473.0 ± 0.1% | 1087.8 ± 0.3% | 609.4 ± 1.0% | 995.0 ± 0.3% | 734.8 ± 0.4% | 10.637 | 14.404 | 25.715 | 15.748 | 21.324 |
| hex: canterbury/alice29.txt | 304180 | 15686.6 ± 0.0% | 1470.2 ± 0.4% | 1086.5 ± 0.3% | 502.0 ± 0.5% | 991.6 ± 0.4% | 736.6 ± 0.4% | 10.670 | 14.438 | 31.247 | 15.820 | 21.295 |
| hex: canterbury/asyoulik.txt | 250360 | 15718.9 ± 0.1% | 1478.7 ± 0.4% | 1091.9 ± 0.5% | 496.4 ± 1.3% | 995.4 ± 0.3% | 740.6 ± 0.3% | 10.631 | 14.395 | 31.669 | 15.792 | 21.225 |
| hex: canterbury/cp.html | 49208 | 15649.5 ± 0.0% | 1474.7 ± 0.7% | 1098.7 ± 0.2% | 528.3 ± 2.0% | 1006.6 ± 0.5% | 742.6 ± 0.2% | 10.612 | 14.243 | 29.622 | 15.547 | 21.073 |
| hex: canterbury/fields.c | 22302 | 15518.1 ± 0.0% | 1411.2 ± 0.5% | 1069.0 ± 1.0% | 618.1 ± 4.6% | 990.3 ± 0.2% | 735.8 ± 0.1% | 10.996 | 14.517 | 25.107 | 15.671 | 21.091 |
| hex: canterbury/grammar.lsp | 7444 | 15154.3 ± 0.1% | 1508.9 ± 0.2% | 1098.1 ± 0.6% | 663.8 ± 5.0% | 997.5 ± 0.3% | 725.9 ± 0.1% | 10.043 | 13.801 | 22.831 | 15.193 | 20.876 |
| hex: canterbury/kennedy.xls | 524290 | 15626.3 ± 0.2% | 1477.6 ± 0.4% | 1087.6 ± 0.4% | 652.4 ± 1.2% | 992.2 ± 0.3% | 733.7 ± 0.3% | 10.575 | 14.368 | 23.952 | 15.749 | 21.297 |
| hex: canterbury/lcet10.txt | 524290 | 15637.8 ± 0.2% | 1467.7 ± 0.5% | 1083.9 ± 0.4% | 504.6 ± 1.2% | 989.3 ± 0.3% | 735.7 ± 0.6% | 10.655 | 14.427 | 30.991 | 15.807 | 21.256 |
| hex: canterbury/plrabn12.txt | 524290 | 15688.1 ± 0.2% | 1464.9 ± 0.3% | 1085.4 ± 0.5% | 495.0 ± 0.9% | 989.6 ± 0.5% | 734.8 ± 0.2% | 10.709 | 14.453 | 31.695 | 15.854 | 21.351 |
| hex: canterbury/ptt5 | 524290 | 15627.3 ± 0.4% | 1483.8 ± 0.3% | 1089.9 ± 0.2% | 552.2 ± 1.4% | 995.9 ± 0.2% | 736.1 ± 0.4% | 10.532 | 14.339 | 28.301 | 15.691 | 21.231 |
| hex: canterbury/sum | 76482 | 15675.3 ± 0.1% | 1494.7 ± 0.1% | 1105.6 ± 0.2% | 593.8 ± 3.0% | 998.1 ± 0.1% | 744.5 ± 0.1% | 10.487 | 14.178 | 26.398 | 15.705 | 21.055 |
| hex: canterbury/xargs.1 | 8456 | 15201.9 ± 0.1% | 1495.0 ± 0.3% | 1096.7 ± 0.7% | 662.8 ± 7.6% | 1005.0 ± 0.2% | 728.2 ± 0.2% | 10.169 | 13.862 | 22.935 | 15.127 | 20.877 |
| hex: canterbury-large/E.coli | 524290 | 15653.8 ± 0.4% | 1477.8 ± 0.4% | 1088.7 ± 0.5% | 673.5 ± 0.3% | 995.0 ± 0.3% | 736.1 ± 0.4% | 10.592 | 14.379 | 23.242 | 15.733 | 21.267 |
| hex: canterbury-large/bible.txt | 524290 | 15616.0 ± 0.5% | 1465.9 ± 0.3% | 1085.3 ± 0.7% | 515.1 ± 0.4% | 994.1 ± 0.3% | 733.5 ± 0.5% | 10.653 | 14.389 | 30.316 | 15.708 | 21.289 |
| hex: canterbury-large/world192.txt | 524290 | 15637.2 ± 0.3% | 1472.3 ± 0.5% | 1087.3 ± 0.3% | 503.5 ± 0.7% | 992.0 ± 0.4% | 733.6 ± 0.7% | 10.621 | 14.382 | 31.056 | 15.764 | 21.317 |
| hex: http/html-1kx1024 | 2099200 | 14240.2 ± 0.4% | 1453.8 ± 0.3% | 1064.7 ± 0.3% | 501.7 ± 0.2% | 982.8 ± 0.2% | 691.9 ± 0.2% | 9.795 | 13.375 | 28.381 | 14.489 | 20.580 |
| hex: http/html-16kx64 | 2097280 | 15329.9 ± 0.7% | 1448.2 ± 0.4% | 1078.0 ± 0.3% | 507.9 ± 0.3% | 996.6 ± 0.1% | 735.4 ± 0.1% | 10.585 | 14.221 | 30.183 | 15.382 | 20.845 |
| hex: http/html-1m | 524290 | 15679.0 ± 0.2% | 1468.4 ± 0.3% | 1084.7 ± 0.2% | 501.7 ± 0.3% | 993.8 ± 0.3% | 734.5 ± 0.3% | 10.678 | 14.454 | 31.253 | 15.777 | 21.347 |
| hex: http/json-1kx1024 | 2099200 | 14212.8 ± 0.3% | 1463.9 ± 0.2% | 1069.0 ± 0.1% | 609.3 ± 0.4% | 986.7 ± 0.1% | 692.4 ± 0.0% | 9.709 | 13.296 | 23.327 | 14.404 | 20.525 |
| hex: http/json-16kx64 | 2097280 | 15360.7 ± 0.6% | 1449.1 ± 0.2% | 1076.9 ± 0.3% | 618.4 ± 0.6% | 998.0 ± 0.3% | 735.2 ± 0.1% | 10.600 | 14.263 | 24.840 | 15.392 | 20.893 |
| hex: http/json-1m | 524290 | 15621.5 ± 0.5% | 1474.6 ± 0.2% | 1087.4 ± 0.3% | 630.6 ± 0.7% | 995.6 ± 0.1% | 735.3 ± 0.7% | 10.594 | 14.366 | 24.771 | 15.691 | 21.245 |
| hex: http/js-1kx1024 | 2099200 | 14196.7 ± 0.7% | 1453.4 ± 0.3% | 1063.2 ± 0.2% | 498.8 ± 0.1% | 983.8 ± 0.2% | 692.3 ± 0.2% | 9.768 | 13.353 | 28.463 | 14.431 | 20.508 |
| hex: http/js-16kx64 | 2097280 | 15320.3 ± 0.5% | 1445.6 ± 0.1% | 1075.8 ± 0.2% | 506.0 ± 0.3% | 999.4 ± 0.3% | 735.4 ± 0.4% | 10.598 | 14.240 | 30.279 | 15.329 | 20.833 |
| hex: http/js-1m | 524290 | 15628.6 ± 0.6% | 1469.1 ± 0.2% | 1085.0 ± 0.4% | 508.6 ± 0.8% | 991.2 ± 0.5% | 735.0 ± 0.4% | 10.638 | 14.404 | 30.727 | 15.768 | 21.263 |
| hex: http/css-1kx1024 | 2099200 | 14190.4 ± 0.4% | 1454.4 ± 0.1% | 1064.3 ± 0.3% | 531.8 ± 0.4% | 984.2 ± 0.2% | 692.7 ± 0.4% | 9.757 | 13.334 | 26.683 | 14.419 | 20.487 |
| hex: http/css-16kx64 | 2097280 | 15366.6 ± 0.4% | 1446.2 ± 0.2% | 1074.7 ± 0.4% | 541.8 ± 0.9% | 999.9 ± 0.6% | 735.0 ± 0.2% | 10.626 | 14.298 | 28.361 | 15.368 | 20.906 |
| hex: http/css-1m | 524290 | 15665.3 ± 0.9% | 1471.4 ± 0.3% | 1084.7 ± 0.5% | 530.0 ± 0.8% | 995.7 ± 0.5% | 735.3 ± 0.4% | 10.647 | 14.442 | 29.557 | 15.733 | 21.305 |
| hex: shuffled/dickens-1m | 524290 | 15678.2 ± 0.5% | 1467.0 ± 0.3% | 1084.6 ± 0.3% | 500.9 ± 0.5% | 988.5 ± 0.5% | 736.4 ± 0.8% | 10.687 | 14.456 | 31.303 | 15.861 | 21.290 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.912 of yyjson.
