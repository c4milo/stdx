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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43625746162 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.4 ± 0.8% | 0.523 | 0.965 | 0.997 | 0.997 | 0.460 | 1.001 | 1.006 | 0.388 | 0.830 | 0.898 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 843.0 ± 1.2% | 0.826 | 1.011 | 1.009 | 1.012 | 0.450 | 1.005 | 1.037 | 0.402 | 0.930 | 0.998 | 0.124 |
| string: silesia/dickens | 172528 | 5046.4 ± 0.3% | 0.033 | 0.782 | 1.004 | 1.004 | 0.197 | 1.017 | 1.007 | 0.196 | 1.001 | 1.002 | 0.032 |
| string: silesia/nci | 1075110 | 4298.8 ± 0.5% | 0.039 | 0.800 | 1.002 | 1.003 | 0.280 | 1.002 | 0.996 | 0.279 | 1.003 | 1.001 | 0.038 |
| string: silesia/reymont | 1075159 | 2935.3 ± 2.6% | 0.057 | 0.810 | 0.999 | 1.000 | 0.359 | 1.013 | 1.008 | 0.359 | 1.020 | 1.022 | 0.056 |
| string: silesia/samba | 97582 | 3497.2 ± 0.3% | 0.040 | 0.860 | 1.002 | 1.004 | 0.068 | 0.777 | 1.010 | 0.073 | 1.002 | 1.005 | 0.039 |
| string: silesia/webster | 1098490 | 3646.7 ± 1.1% | 0.044 | 0.846 | 1.005 | 1.007 | 0.204 | 1.018 | 1.014 | 0.204 | 1.010 | 1.010 | 0.044 |
| string: silesia/xml | 1090118 | 4772.8 ± 0.6% | 0.035 | 0.810 | 1.004 | 1.009 | 0.222 | 0.983 | 1.008 | 0.225 | 1.007 | 1.009 | 0.035 |
| string: canterbury/alice29.txt | 159425 | 4311.4 ± 0.6% | 0.038 | 0.751 | 0.999 | 1.005 | 0.172 | 1.038 | 1.016 | 0.171 | 1.014 | 1.014 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3448.0 ± 0.3% | 0.046 | 0.749 | 1.008 | 1.011 | 0.177 | 1.005 | 0.969 | 0.176 | 1.015 | 1.016 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5111.4 ± 0.4% | 0.032 | 0.815 | 1.003 | 1.004 | 0.195 | 1.022 | 1.005 | 0.195 | 1.004 | 1.004 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4084.6 ± 1.2% | 0.040 | 0.830 | 1.009 | 1.010 | 0.201 | 1.022 | 1.006 | 0.200 | 1.009 | 1.009 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 18993.8 ± 2.0% | 0.078 | 1.016 | 1.011 | 1.006 | 0.486 | 1.014 | 1.014 | 0.487 | 0.627 | 0.628 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6687.9 ± 1.5% | 0.026 | 0.804 | 1.005 | 1.009 | 0.433 | 1.030 | 1.040 | 0.433 | 1.032 | 1.038 | 0.026 |
| string: canterbury-large/world192.txt | 1103121 | 3392.5 ± 0.8% | 0.047 | 0.844 | 1.000 | 1.001 | 0.197 | 1.011 | 1.006 | 0.198 | 1.002 | 1.001 | 0.047 |
| string: http/html-1m | 1058582 | 6061.5 ± 0.6% | 0.028 | 0.782 | 1.033 | 1.042 | 0.389 | 1.038 | 1.053 | 0.388 | 1.032 | 1.039 | 0.028 |
| string: http/json-1m | 1190272 | 2553.0 ± 0.5% | 0.055 | 0.949 | 1.004 | 1.005 | 0.111 | 1.003 | 0.470 | 0.111 | 1.003 | 1.002 | 0.055 |
| string: http/js-1m | 1144362 | 2289.4 ± 0.6% | 0.066 | 0.888 | 0.999 | 0.999 | 0.174 | 1.051 | 1.043 | 0.174 | 0.999 | 1.000 | 0.065 |
| string: http/css-1m | 1097820 | 2644.9 ± 0.7% | 0.060 | 0.775 | 1.005 | 1.008 | 0.240 | 1.002 | 1.013 | 0.239 | 1.006 | 1.007 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3067.5 ± 0.8% | 0.044 | 0.125 | 1.005 | 1.003 | 0.337 | 1.001 | 1.007 | 0.337 | 1.008 | 1.006 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1325.7 ± 1.4% | 0.082 | 1.005 | 1.004 | 1.004 | 0.077 | 0.638 | 1.006 | 0.081 | 1.005 | 1.004 | 0.081 |
| hex: silesia/dickens | 524290 | 18763.3 ± 1.0% | 0.080 | 1.002 | 0.975 | 0.974 | 0.522 | 0.996 | 0.994 | 0.521 | 0.640 | 0.640 | 0.009 |
| hex: silesia/mozilla | 524290 | 18849.4 ± 1.5% | 0.079 | 1.001 | 0.994 | 0.997 | 0.515 | 0.989 | 0.993 | 0.516 | 0.638 | 0.638 | 0.009 |
| hex: silesia/mr | 524290 | 18067.4 ± 2.3% | 0.082 | 1.011 | 1.007 | 0.996 | 0.525 | 1.002 | 1.006 | 0.525 | 0.663 | 0.662 | 0.010 |
| hex: silesia/nci | 524290 | 18751.6 ± 1.3% | 0.079 | 0.996 | 0.995 | 0.987 | 0.513 | 0.993 | 0.989 | 0.512 | 0.639 | 0.640 | 0.009 |
| hex: silesia/ooffice | 524290 | 18909.9 ± 0.9% | 0.079 | 0.998 | 1.001 | 0.997 | 0.501 | 1.004 | 0.998 | 0.504 | 0.634 | 0.635 | 0.009 |
| hex: silesia/osdb | 524290 | 18344.1 ± 1.0% | 0.081 | 1.008 | 1.002 | 1.003 | 0.524 | 1.002 | 1.002 | 0.526 | 0.654 | 0.654 | 0.010 |
| hex: silesia/reymont | 524290 | 18823.5 ± 1.0% | 0.079 | 1.000 | 1.002 | 1.001 | 0.511 | 1.003 | 1.002 | 0.512 | 0.638 | 0.638 | 0.009 |
| hex: silesia/samba | 524290 | 18094.4 ± 0.5% | 0.082 | 1.010 | 1.004 | 1.004 | 0.522 | 1.001 | 0.996 | 0.525 | 0.661 | 0.660 | 0.010 |
| hex: silesia/sao | 524290 | 18748.7 ± 0.9% | 0.079 | 0.999 | 1.003 | 0.996 | 0.509 | 1.005 | 1.003 | 0.512 | 0.641 | 0.641 | 0.009 |
| hex: silesia/webster | 524290 | 18861.1 ± 0.6% | 0.079 | 1.001 | 0.995 | 0.987 | 0.510 | 0.990 | 0.996 | 0.512 | 0.634 | 0.634 | 0.009 |
| hex: silesia/x-ray | 524290 | 18317.7 ± 0.6% | 0.081 | 1.008 | 1.003 | 1.003 | 0.525 | 1.007 | 1.001 | 0.524 | 0.655 | 0.656 | 0.009 |
| hex: silesia/xml | 524290 | 18778.4 ± 0.7% | 0.079 | 1.009 | 0.999 | 0.995 | 0.502 | 1.001 | 0.995 | 0.500 | 0.638 | 0.637 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19129.0 ± 0.5% | 0.078 | 0.999 | 1.001 | 1.000 | 0.507 | 1.000 | 1.000 | 0.507 | 0.627 | 0.627 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19543.6 ± 0.1% | 0.077 | 1.002 | 1.002 | 1.002 | 0.514 | 1.002 | 1.002 | 0.514 | 0.614 | 0.614 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19275.1 ± 0.1% | 0.081 | 1.001 | 1.001 | 1.000 | 0.542 | 1.001 | 1.001 | 0.545 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18920.3 ± 0.7% | 0.085 | 0.999 | 1.003 | 1.003 | 0.533 | 1.002 | 1.003 | 0.539 | 0.622 | 0.623 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17562.0 ± 2.2% | 0.086 | 1.003 | 1.002 | 1.003 | 0.525 | 1.002 | 1.002 | 0.542 | 0.641 | 0.644 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18694.0 ± 1.9% | 0.079 | 1.005 | 1.011 | 1.006 | 0.505 | 1.004 | 0.994 | 0.508 | 0.640 | 0.640 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18741.3 ± 1.0% | 0.079 | 1.002 | 0.997 | 0.996 | 0.506 | 0.996 | 0.997 | 0.507 | 0.640 | 0.641 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18228.3 ± 0.9% | 0.082 | 1.012 | 1.007 | 1.004 | 0.528 | 1.008 | 1.005 | 0.529 | 0.657 | 0.655 | 0.010 |
| hex: canterbury/ptt5 | 524290 | 18573.1 ± 1.2% | 0.080 | 1.003 | 0.992 | 0.993 | 0.512 | 0.997 | 0.997 | 0.509 | 0.644 | 0.645 | 0.009 |
| hex: canterbury/sum | 76482 | 19284.0 ± 0.5% | 0.078 | 1.002 | 1.002 | 1.002 | 0.518 | 1.002 | 1.002 | 0.520 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17819.5 ± 0.5% | 0.086 | 1.002 | 1.002 | 1.003 | 0.524 | 1.001 | 1.001 | 0.540 | 0.637 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18624.2 ± 1.2% | 0.080 | 1.012 | 1.008 | 1.000 | 0.512 | 1.001 | 1.002 | 0.516 | 0.642 | 0.642 | 0.009 |
| hex: canterbury-large/bible.txt | 524290 | 18637.5 ± 1.1% | 0.080 | 1.010 | 1.003 | 0.988 | 0.521 | 1.004 | 0.993 | 0.520 | 0.642 | 0.642 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 17988.0 ± 0.9% | 0.083 | 1.010 | 1.008 | 1.007 | 0.533 | 1.005 | 1.006 | 0.532 | 0.666 | 0.666 | 0.010 |
| hex: http/html-1kx1024 | 2099200 | 9461.7 ± 11.3% | 0.151 | 1.254 | 1.247 | 1.251 | 0.698 | 1.257 | 0.973 | 0.769 | 0.929 | 0.938 | 0.018 |
| hex: http/html-16kx64 | 2097280 | 17853.2 ± 0.6% | 0.084 | 1.027 | 1.024 | 1.023 | 0.575 | 1.025 | 0.994 | 0.579 | 0.659 | 0.660 | 0.010 |
| hex: http/html-1m | 524290 | 18204.8 ± 0.4% | 0.082 | 1.008 | 1.002 | 1.001 | 0.531 | 1.000 | 1.003 | 0.532 | 0.658 | 0.658 | 0.010 |
| hex: http/json-1kx1024 | 2099200 | 9660.7 ± 19.4% | 0.147 | 1.236 | 1.225 | 1.224 | 0.683 | 1.236 | 0.949 | 0.752 | 0.913 | 0.919 | 0.018 |
| hex: http/json-16kx64 | 2097280 | 17998.1 ± 0.4% | 0.084 | 1.016 | 1.015 | 1.016 | 0.570 | 1.014 | 0.986 | 0.574 | 0.654 | 0.654 | 0.010 |
| hex: http/json-1m | 524290 | 18401.4 ± 2.7% | 0.081 | 1.010 | 1.007 | 0.999 | 0.525 | 1.002 | 1.003 | 0.522 | 0.652 | 0.652 | 0.009 |
| hex: http/js-1kx1024 | 2099200 | 9382.5 ± 16.9% | 0.151 | 1.269 | 1.264 | 1.276 | 0.704 | 1.269 | 0.984 | 0.774 | 0.941 | 0.949 | 0.018 |
| hex: http/js-16kx64 | 2097280 | 17867.4 ± 2.8% | 0.084 | 1.023 | 1.021 | 1.022 | 0.573 | 1.023 | 0.991 | 0.579 | 0.659 | 0.660 | 0.010 |
| hex: http/js-1m | 524290 | 18660.7 ± 2.0% | 0.080 | 1.006 | 1.008 | 1.005 | 0.514 | 0.991 | 0.985 | 0.515 | 0.642 | 0.642 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9450.5 ± 17.7% | 0.151 | 1.266 | 1.254 | 1.253 | 0.699 | 1.248 | 0.969 | 0.767 | 0.929 | 0.933 | 0.018 |
| hex: http/css-16kx64 | 2097280 | 18075.7 ± 1.6% | 0.083 | 1.016 | 1.012 | 1.013 | 0.567 | 1.016 | 0.983 | 0.571 | 0.651 | 0.652 | 0.010 |
| hex: http/css-1m | 524290 | 18575.5 ± 0.9% | 0.080 | 1.012 | 1.007 | 1.000 | 0.522 | 0.995 | 0.995 | 0.520 | 0.647 | 0.647 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18034.9 ± 0.8% | 0.083 | 1.008 | 1.006 | 1.011 | 0.527 | 1.005 | 1.007 | 0.528 | 0.665 | 0.665 | 0.010 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1482.0 ± 0.8% | 0.444 | 1.005 | 0.971 | 1.009 | 1.012 | 0.268 | 1.005 | 0.547 | 0.916 | 0.089 | 1.029 |
| qlog records, JSON text sequence | 1467503 | 1270.1 ± 1.5% | 0.690 | 0.977 | 1.011 | 1.013 | 1.012 | 0.264 | 1.003 | 0.502 | 0.830 | 0.106 | 1.019 |
| string: silesia/dickens | 172528 | 6892.3 ± 0.4% | 0.025 | 1.001 | 1.001 | 1.001 | 1.001 | 0.167 | 0.717 | 1.003 | 1.003 | 0.025 | 1.032 |
| string: silesia/nci | 1075110 | 7308.9 ± 0.6% | 0.024 | 1.002 | 1.001 | 0.999 | 1.001 | 0.212 | 0.564 | 1.000 | 1.000 | 0.024 | 1.002 |
| string: silesia/reymont | 1075159 | 3327.9 ± 1.0% | 0.052 | 1.002 | 1.000 | 1.002 | 1.003 | 0.392 | 0.868 | 1.003 | 1.007 | 0.052 | 1.056 |
| string: silesia/samba | 97582 | 4197.8 ± 0.8% | 0.053 | 1.001 | 1.000 | 1.005 | 1.005 | 0.125 | 0.940 | 1.001 | 1.002 | 0.053 | 1.092 |
| string: silesia/webster | 1098490 | 4045.7 ± 0.3% | 0.042 | 1.008 | 1.009 | 1.010 | 1.009 | 0.213 | 0.888 | 1.004 | 1.009 | 0.043 | 1.011 |
| string: silesia/xml | 1090118 | 6125.5 ± 0.7% | 0.029 | 1.002 | 0.994 | 1.004 | 1.003 | 0.254 | 0.776 | 1.000 | 1.003 | 0.029 | 1.019 |
| string: canterbury/alice29.txt | 159425 | 6407.9 ± 1.0% | 0.027 | 1.011 | 1.015 | 1.015 | 1.016 | 0.133 | 0.655 | 1.007 | 1.011 | 0.027 | 1.054 |
| string: canterbury/asyoulik.txt | 132198 | 5594.9 ± 0.8% | 0.030 | 1.023 | 1.031 | 1.032 | 1.035 | 0.130 | 0.598 | 1.005 | 1.013 | 0.030 | 1.052 |
| string: canterbury/lcet10.txt | 441884 | 6228.9 ± 0.5% | 0.028 | 1.007 | 1.008 | 1.008 | 1.011 | 0.186 | 0.803 | 1.004 | 1.004 | 0.028 | 1.005 |
| string: canterbury/plrabn12.txt | 503330 | 5699.6 ± 0.5% | 0.030 | 1.001 | 1.002 | 1.002 | 1.002 | 0.169 | 0.698 | 1.000 | 1.002 | 0.030 | 1.006 |
| string: canterbury-large/E.coli | 1048578 | 19292.4 ± 0.9% | 0.078 | 1.000 | 0.996 | 0.998 | 1.002 | 0.481 | 1.001 | 0.998 | 1.000 | 0.009 | 1.002 |
| string: canterbury-large/bible.txt | 1055886 | 6789.7 ± 0.4% | 0.026 | 1.001 | 1.001 | 1.001 | 1.002 | 0.494 | 0.968 | 1.001 | 1.002 | 0.026 | 1.001 |
| string: canterbury-large/world192.txt | 1103121 | 4022.3 ± 0.4% | 0.042 | 1.017 | 1.019 | 1.018 | 1.019 | 0.194 | 0.832 | 1.001 | 1.011 | 0.043 | 1.003 |
| string: http/html-1m | 1058582 | 6741.2 ± 0.3% | 0.026 | 1.006 | 0.926 | 1.005 | 1.008 | 0.406 | 0.890 | 1.002 | 1.006 | 0.026 | 1.010 |
| string: http/json-1m | 1190272 | 3166.7 ± 0.4% | 0.050 | 1.001 | 0.965 | 1.000 | 1.002 | 0.133 | 0.370 | 0.998 | 1.001 | 0.051 | 1.042 |
| string: http/js-1m | 1144362 | 2751.4 ± 0.6% | 0.061 | 1.004 | 1.011 | 1.007 | 1.011 | 0.166 | 0.840 | 1.004 | 1.010 | 0.061 | 1.021 |
| string: http/css-1m | 1097820 | 3978.2 ± 0.6% | 0.043 | 1.005 | 1.007 | 1.010 | 1.011 | 0.209 | 0.648 | 1.001 | 1.008 | 0.043 | 1.015 |
| string: dickens as Cyrillic and CJK | 1883069 | 3065.2 ± 0.3% | 0.048 | 1.004 | 0.124 | 1.001 | 1.004 | 0.321 | 1.005 | 1.002 | 1.005 | 0.048 | 1.003 |
| hex: silesia/dickens | 524290 | 15640.7 ± 0.2% | 0.999 | 0.178 | 0.998 | 1.001 | 0.998 | 0.998 | 0.999 | 0.997 | 0.998 | 0.177 | 0.998 |
| hex: silesia/mozilla | 524290 | 15659.3 ± 0.3% | 1.001 | 0.178 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 1.001 | 1.000 | 0.178 | 1.002 |
| hex: silesia/mr | 524290 | 15631.0 ± 0.3% | 1.000 | 0.179 | 1.000 | 1.000 | 0.999 | 0.999 | 0.999 | 1.000 | 1.000 | 0.178 | 1.000 |
| hex: silesia/nci | 524290 | 15666.0 ± 0.3% | 1.001 | 0.178 | 1.002 | 1.000 | 1.001 | 1.001 | 1.002 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: silesia/ooffice | 524290 | 15586.3 ± 0.4% | 1.001 | 0.179 | 1.002 | 1.001 | 1.002 | 1.002 | 1.002 | 1.002 | 1.003 | 0.178 | 1.002 |
| hex: silesia/osdb | 524290 | 15627.9 ± 0.2% | 1.002 | 0.178 | 1.001 | 1.001 | 1.002 | 1.001 | 1.002 | 1.002 | 1.002 | 0.178 | 1.002 |
| hex: silesia/reymont | 524290 | 15686.8 ± 0.1% | 1.000 | 0.178 | 1.000 | 1.001 | 1.000 | 0.996 | 1.000 | 0.999 | 1.000 | 0.177 | 0.999 |
| hex: silesia/samba | 524290 | 15591.1 ± 0.2% | 1.001 | 0.178 | 1.002 | 1.001 | 1.001 | 0.999 | 1.000 | 0.998 | 1.000 | 0.178 | 0.999 |
| hex: silesia/sao | 524290 | 15581.1 ± 0.2% | 1.004 | 0.179 | 1.002 | 1.000 | 1.002 | 1.001 | 1.002 | 1.004 | 1.004 | 0.178 | 1.003 |
| hex: silesia/webster | 524290 | 15671.4 ± 0.3% | 1.001 | 0.177 | 1.001 | 1.001 | 1.000 | 1.001 | 0.999 | 0.999 | 1.001 | 0.177 | 1.001 |
| hex: silesia/x-ray | 524290 | 15627.2 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.000 | 1.001 | 1.002 | 0.178 | 1.002 |
| hex: silesia/xml | 524290 | 15644.8 ± 0.5% | 1.001 | 0.178 | 0.999 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 0.999 | 0.177 | 1.000 |
| hex: canterbury/alice29.txt | 304180 | 15668.3 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.001 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 0.178 | 1.000 |
| hex: canterbury/asyoulik.txt | 250360 | 15680.1 ± 0.5% | 1.002 | 0.178 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 1.001 | 0.999 | 0.177 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15617.7 ± 0.2% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.997 | 1.001 | 1.002 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15434.4 ± 0.1% | 1.002 | 0.181 | 1.000 | 1.000 | 1.000 | 0.994 | 1.000 | 1.003 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14933.5 ± 0.1% | 1.004 | 0.186 | 1.001 | 1.000 | 1.000 | 0.983 | 1.001 | 1.004 | 1.015 | 0.184 | 1.004 |
| hex: canterbury/kennedy.xls | 524290 | 15608.5 ± 0.3% | 1.004 | 0.178 | 1.002 | 1.004 | 1.003 | 1.001 | 1.002 | 1.003 | 1.002 | 0.179 | 1.003 |
| hex: canterbury/lcet10.txt | 524290 | 15641.0 ± 0.1% | 1.000 | 0.178 | 1.001 | 1.001 | 1.002 | 1.001 | 1.001 | 1.001 | 1.001 | 0.178 | 0.999 |
| hex: canterbury/plrabn12.txt | 524290 | 15655.3 ± 0.1% | 1.002 | 0.178 | 0.999 | 1.000 | 0.999 | 0.999 | 1.000 | 1.001 | 1.000 | 0.178 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 15656.7 ± 0.2% | 1.000 | 0.179 | 1.000 | 1.001 | 0.998 | 0.999 | 0.999 | 1.000 | 0.997 | 0.178 | 1.000 |
| hex: canterbury/sum | 76482 | 15638.6 ± 0.0% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.999 | 1.000 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 14992.4 ± 0.1% | 1.003 | 0.185 | 1.000 | 1.000 | 1.000 | 0.985 | 1.000 | 1.005 | 1.014 | 0.183 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 15634.6 ± 0.4% | 1.002 | 0.178 | 1.002 | 1.002 | 1.001 | 1.000 | 1.002 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury-large/bible.txt | 524290 | 15628.3 ± 0.3% | 1.003 | 0.178 | 1.000 | 1.001 | 1.001 | 0.996 | 1.000 | 1.001 | 1.001 | 0.177 | 1.000 |
| hex: canterbury-large/world192.txt | 524290 | 15598.8 ± 0.3% | 1.002 | 0.178 | 1.002 | 1.000 | 1.001 | 1.001 | 1.002 | 1.001 | 0.999 | 0.178 | 1.002 |
| hex: http/html-1kx1024 | 2099200 | 13616.7 ± 0.8% | 1.008 | 0.196 | 1.001 | 1.003 | 1.003 | 0.947 | 1.001 | 1.012 | 1.042 | 0.188 | 1.012 |
| hex: http/html-16kx64 | 2097280 | 15267.4 ± 0.3% | 1.004 | 0.181 | 0.997 | 1.001 | 1.001 | 0.991 | 1.000 | 1.009 | 1.011 | 0.179 | 1.001 |
| hex: http/html-1m | 524290 | 15667.3 ± 0.3% | 0.999 | 0.177 | 0.999 | 1.001 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 0.177 | 1.000 |
| hex: http/json-1kx1024 | 2099200 | 13674.7 ± 0.6% | 1.004 | 0.195 | 1.003 | 1.001 | 0.999 | 0.935 | 0.993 | 1.009 | 1.036 | 0.188 | 1.009 |
| hex: http/json-16kx64 | 2097280 | 15248.4 ± 0.2% | 0.999 | 0.181 | 0.996 | 1.002 | 0.998 | 0.985 | 0.993 | 1.002 | 1.013 | 0.180 | 0.998 |
| hex: http/json-1m | 524290 | 15649.4 ± 0.1% | 1.000 | 0.177 | 1.000 | 1.001 | 1.002 | 0.997 | 0.998 | 1.001 | 1.001 | 0.178 | 0.999 |
| hex: http/js-1kx1024 | 2099200 | 13673.2 ± 0.7% | 1.007 | 0.195 | 1.001 | 1.003 | 1.002 | 0.939 | 0.999 | 1.010 | 1.038 | 0.187 | 1.017 |
| hex: http/js-16kx64 | 2097280 | 15222.8 ± 0.5% | 0.998 | 0.181 | 0.997 | 0.999 | 1.000 | 0.994 | 1.001 | 1.002 | 1.009 | 0.181 | 1.001 |
| hex: http/js-1m | 524290 | 15615.6 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.002 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 0.178 | 1.000 |
| hex: http/css-1kx1024 | 2099200 | 13658.9 ± 0.7% | 1.004 | 0.196 | 1.000 | 1.003 | 1.002 | 0.939 | 0.997 | 1.008 | 1.036 | 0.187 | 1.011 |
| hex: http/css-16kx64 | 2097280 | 15251.8 ± 0.6% | 0.998 | 0.181 | 0.999 | 1.000 | 1.001 | 0.987 | 0.995 | 1.000 | 1.009 | 0.180 | 1.000 |
| hex: http/css-1m | 524290 | 15684.5 ± 0.1% | 0.999 | 0.177 | 1.001 | 1.000 | 1.001 | 1.000 | 1.000 | 0.998 | 1.002 | 0.177 | 1.000 |
| hex: shuffled/dickens-1m | 524290 | 15657.7 ± 0.3% | 1.001 | 0.178 | 1.000 | 1.002 | 1.001 | 1.000 | 1.001 | 1.002 | 1.002 | 0.177 | 1.003 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.053 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.051 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.254 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.247 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.251 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.257 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.236 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.225 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.224 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.236 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.269 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.264 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.276 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.269 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.266 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.254 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.253 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.248 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43356.7 ± 0.2% | 47397.5 ± 0.1% | 0.915 | — | — |
| string: silesia/nci | 1048576 | 35327.7 ± 0.9% | 38012.0 ± 1.5% | 0.929 | — | — |
| string: silesia/reymont | 1048576 | 34288.3 ± 3.9% | 36607.2 ± 3.7% | 0.937 | — | — |
| string: silesia/samba | 65546 | 43560.5 ± 0.1% | 48503.6 ± 0.0% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 36111.1 ± 3.6% | 38782.2 ± 5.7% | 0.931 | — | — |
| string: silesia/xml | 1048576 | 31354.0 ± 3.1% | 32860.8 ± 3.0% | 0.954 | — | — |
| string: canterbury/alice29.txt | 152089 | 35890.5 ± 0.1% | 36536.4 ± 0.1% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43329.2 ± 0.2% | 47668.0 ± 0.2% | 0.909 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36035.2 ± 0.1% | 36682.0 ± 0.1% | 0.982 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 40558.2 ± 0.3% | 43948.3 ± 0.3% | 0.923 | — | — |
| string: canterbury-large/E.coli | 1048576 | 34707.3 ± 7.2% | 37072.4 ± 6.4% | 0.936 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 31358.6 ± 1.4% | 32440.8 ± 2.8% | 0.967 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 31634.7 ± 2.6% | 33160.4 ± 2.1% | 0.954 | — | — |
| string: http/html-1m | 1048576 | 34726.7 ± 3.7% | 37280.3 ± 3.3% | 0.932 | — | — |
| string: http/json-1m | 1048576 | 29239.3 ± 3.0% | 30985.4 ± 3.7% | 0.944 | — | — |
| string: http/js-1m | 1048576 | 34009.2 ± 3.0% | 36673.0 ± 2.2% | 0.927 | — | — |
| string: http/css-1m | 1048576 | 35077.3 ± 2.8% | 37877.9 ± 4.2% | 0.926 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5767.2 ± 0.3% | 5652.3 ± 0.1% | 1.020 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.915 of simdutf.
- string: silesia/nci: stdx runs at 0.929 of simdutf.
- string: silesia/reymont: stdx runs at 0.937 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.931 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.909 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.923 of simdutf.
- string: http/html-1m: stdx runs at 0.932 of simdutf.
- string: http/json-1m: stdx runs at 0.944 of simdutf.
- string: http/js-1m: stdx runs at 0.927 of simdutf.
- string: http/css-1m: stdx runs at 0.926 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 38197.6 ± 3.6% | 41893.9 ± 3.8% | 0.912 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 32345.5 ± 2.8% | 33627.1 ± 1.8% | 0.962 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 36013.5 ± 8.8% | 38626.6 ± 9.9% | 0.932 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 36290.7 ± 3.0% | 39433.0 ± 2.0% | 0.920 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 36363.9 ± 3.5% | 39691.2 ± 4.3% | 0.916 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 35909.7 ± 3.6% | 39131.6 ± 3.9% | 0.918 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5764.7 ± 0.2% | 5645.6 ± 0.2% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5764.9 ± 0.1% | 5651.7 ± 0.1% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5767.0 ± 0.2% | 5650.1 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5764.4 ± 0.1% | 5648.5 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5768.3 ± 0.1% | 5650.4 ± 0.1% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5765.5 ± 0.1% | 5646.4 ± 0.1% | 1.021 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1127.4 ± 0.8% | 931.8 ± 0.5% | 1021.2 ± 0.2% | 300.9 ± 0.8% | 666.1 ± 0.2% | 309.2 ± 1.2% | 1.210 | 1.104 | 3.747 | 1.692 | 3.646 |
| qlog records, JSON text sequence | 1467503 | 843.0 ± 1.2% | 817.0 ± 0.2% | 784.9 ± 1.5% | 244.3 ± 1.1% | 698.2 ± 0.3% | 250.8 ± 0.3% | 1.032 | 1.074 | 3.451 | 1.207 | 3.361 |
| string: silesia/dickens | 172528 | 5046.4 ± 0.3% | 1877.6 ± 0.1% | 2648.8 ± 0.4% | 360.3 ± 1.1% | 2853.1 ± 0.3% | 550.6 ± 2.2% | 2.688 | 1.905 | 14.005 | 1.769 | 9.166 |
| string: silesia/nci | 1075110 | 4298.8 ± 0.5% | 2240.4 ± 0.4% | 2994.7 ± 0.1% | 545.1 ± 0.7% | 3002.6 ± 0.5% | 602.4 ± 1.1% | 1.919 | 1.435 | 7.887 | 1.432 | 7.136 |
| string: silesia/reymont | 1075159 | 2935.3 ± 2.6% | 1819.3 ± 1.2% | 2068.0 ± 0.3% | 374.5 ± 1.4% | 2140.9 ± 0.8% | 536.6 ± 1.0% | 1.613 | 1.419 | 7.839 | 1.371 | 5.470 |
| string: silesia/samba | 97582 | 3497.2 ± 0.3% | 2026.1 ± 0.1% | 2623.7 ± 2.7% | 328.1 ± 0.5% | 1498.5 ± 0.6% | 429.2 ± 1.3% | 1.726 | 1.333 | 10.659 | 2.334 | 8.148 |
| string: silesia/webster | 1098490 | 3646.7 ± 1.1% | 1519.8 ± 0.2% | 2009.3 ± 0.5% | 358.8 ± 0.4% | 2187.6 ± 0.4% | 497.6 ± 1.3% | 2.399 | 1.815 | 10.163 | 1.667 | 7.328 |
| string: silesia/xml | 1090118 | 4772.8 ± 0.6% | 2360.8 ± 0.4% | 2531.1 ± 0.4% | 453.8 ± 0.9% | 2858.3 ± 1.2% | 568.9 ± 0.6% | 2.022 | 1.886 | 10.518 | 1.670 | 8.389 |
| string: canterbury/alice29.txt | 159425 | 4311.4 ± 0.6% | 1598.1 ± 0.7% | 2457.6 ± 0.6% | 341.2 ± 0.3% | 2500.2 ± 0.1% | 506.0 ± 0.5% | 2.698 | 1.754 | 12.638 | 1.724 | 8.521 |
| string: canterbury/asyoulik.txt | 132198 | 3448.0 ± 0.3% | 1459.7 ± 0.2% | 2245.3 ± 0.7% | 334.7 ± 0.3% | 2070.4 ± 0.4% | 457.3 ± 2.0% | 2.362 | 1.536 | 10.302 | 1.665 | 7.540 |
| string: canterbury/lcet10.txt | 441884 | 5111.4 ± 0.4% | 1854.3 ± 0.3% | 2321.8 ± 1.1% | 390.2 ± 0.4% | 2834.9 ± 0.7% | 533.9 ± 0.8% | 2.757 | 2.201 | 13.101 | 1.803 | 9.573 |
| string: canterbury/plrabn12.txt | 503330 | 4084.6 ± 1.2% | 1735.3 ± 0.2% | 2062.6 ± 0.5% | 360.7 ± 0.7% | 2486.4 ± 0.5% | 498.8 ± 1.0% | 2.354 | 1.980 | 11.324 | 1.643 | 8.188 |
| string: canterbury-large/E.coli | 1048578 | 18993.8 ± 2.0% | 3611.0 ± 0.4% | 3252.4 ± 0.4% | 927.0 ± 0.9% | 5972.9 ± 0.6% | 762.4 ± 1.3% | 5.260 | 5.840 | 20.490 | 3.180 | 24.914 |
| string: canterbury-large/bible.txt | 1055886 | 6687.9 ± 1.5% | 2938.0 ± 1.0% | 2846.7 ± 0.8% | 425.4 ± 1.0% | 3738.2 ± 0.6% | 616.8 ± 1.0% | 2.276 | 2.349 | 15.723 | 1.789 | 10.843 |
| string: canterbury-large/world192.txt | 1103121 | 3392.5 ± 0.8% | 1483.6 ± 0.2% | 2014.4 ± 0.3% | 352.6 ± 0.8% | 2127.0 ± 1.1% | 504.1 ± 0.8% | 2.287 | 1.684 | 9.622 | 1.595 | 6.730 |
| string: http/html-1m | 1058582 | 6061.5 ± 0.6% | 2739.0 ± 0.4% | 2705.3 ± 0.4% | 440.7 ± 0.7% | 3478.2 ± 0.8% | 597.7 ± 1.1% | 2.213 | 2.241 | 13.755 | 1.743 | 10.141 |
| string: http/json-1m | 1190272 | 2553.0 ± 0.5% | 877.2 ± 0.2% | 2257.2 ± 0.6% | 389.8 ± 0.4% | 1064.3 ± 0.7% | 443.8 ± 1.0% | 2.910 | 1.131 | 6.549 | 2.399 | 5.753 |
| string: http/js-1m | 1144362 | 2289.4 ± 0.6% | 1030.1 ± 0.4% | 1635.4 ± 0.5% | 320.3 ± 0.3% | 1522.4 ± 0.1% | 419.1 ± 0.3% | 2.222 | 1.400 | 7.149 | 1.504 | 5.463 |
| string: http/css-1m | 1097820 | 2644.9 ± 0.7% | 1678.3 ± 0.2% | 2229.1 ± 0.7% | 403.9 ± 1.6% | 1957.1 ± 0.7% | 489.7 ± 0.7% | 1.576 | 1.187 | 6.548 | 1.351 | 5.401 |
| string: dickens as Cyrillic and CJK | 1883069 | 3067.5 ± 0.8% | 1687.1 ± 0.3% | 896.0 ± 0.1% | 351.5 ± 0.1% | 670.0 ± 0.6% | 157.7 ± 2.0% | 1.818 | 3.423 | 8.726 | 4.579 | 19.451 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1325.7 ± 1.4% | 981.8 ± 0.3% | 1206.2 ± 0.3% | 215.9 ± 0.2% | 470.2 ± 1.1% | 253.9 ± 3.5% | 1.350 | 1.099 | 6.141 | 2.819 | 5.221 |
| hex: silesia/dickens | 524290 | 18763.3 ± 1.0% | 3623.8 ± 0.3% | 3301.6 ± 0.5% | 517.4 ± 1.3% | 6056.7 ± 1.2% | 780.7 ± 4.1% | 5.178 | 5.683 | 36.267 | 3.098 | 24.033 |
| hex: silesia/mozilla | 524290 | 18849.4 ± 1.5% | 3614.7 ± 0.2% | 3294.7 ± 0.3% | 458.8 ± 0.5% | 6066.9 ± 0.5% | 785.8 ± 1.2% | 5.215 | 5.721 | 41.083 | 3.107 | 23.987 |
| hex: silesia/mr | 524290 | 18067.4 ± 2.3% | 3614.5 ± 0.4% | 3284.9 ± 0.4% | 582.1 ± 2.1% | 6113.8 ± 0.9% | 782.1 ± 0.5% | 4.999 | 5.500 | 31.038 | 2.955 | 23.102 |
| hex: silesia/nci | 524290 | 18751.6 ± 1.3% | 3614.4 ± 0.1% | 3285.6 ± 0.3% | 629.1 ± 1.6% | 6040.3 ± 1.6% | 779.3 ± 0.7% | 5.188 | 5.707 | 29.806 | 3.104 | 24.061 |
| hex: silesia/ooffice | 524290 | 18909.9 ± 0.9% | 3619.7 ± 0.3% | 3288.9 ± 0.2% | 396.7 ± 1.7% | 6088.9 ± 1.5% | 781.7 ± 1.1% | 5.224 | 5.750 | 47.665 | 3.106 | 24.192 |
| hex: silesia/osdb | 524290 | 18344.1 ± 1.0% | 3617.5 ± 0.4% | 3290.3 ± 0.3% | 474.6 ± 1.6% | 6058.0 ± 0.7% | 781.3 ± 1.0% | 5.071 | 5.575 | 38.652 | 3.028 | 23.479 |
| hex: silesia/reymont | 524290 | 18823.5 ± 1.0% | 3619.3 ± 0.4% | 3293.3 ± 0.4% | 520.2 ± 0.2% | 6076.8 ± 0.7% | 784.8 ± 0.5% | 5.201 | 5.716 | 36.184 | 3.098 | 23.984 |
| hex: silesia/samba | 524290 | 18094.4 ± 0.5% | 3616.0 ± 1.1% | 3285.9 ± 0.4% | 408.0 ± 0.7% | 6006.2 ± 1.0% | 782.7 ± 0.6% | 5.004 | 5.507 | 44.349 | 3.013 | 23.118 |
| hex: silesia/sao | 524290 | 18748.7 ± 0.9% | 3617.8 ± 0.2% | 3288.1 ± 0.2% | 342.8 ± 0.6% | 6037.6 ± 0.6% | 782.8 ± 0.6% | 5.182 | 5.702 | 54.687 | 3.105 | 23.950 |
| hex: silesia/webster | 524290 | 18861.1 ± 0.6% | 3616.6 ± 0.1% | 3287.1 ± 0.4% | 469.7 ± 1.3% | 6076.0 ± 0.7% | 782.2 ± 0.8% | 5.215 | 5.738 | 40.157 | 3.104 | 24.112 |
| hex: silesia/x-ray | 524290 | 18317.7 ± 0.6% | 3616.9 ± 0.5% | 3300.6 ± 0.3% | 476.5 ± 0.4% | 6097.5 ± 1.2% | 783.4 ± 0.5% | 5.064 | 5.550 | 38.445 | 3.004 | 23.383 |
| hex: silesia/xml | 524290 | 18778.4 ± 0.7% | 3620.8 ± 0.3% | 3289.9 ± 0.6% | 516.5 ± 1.2% | 6049.9 ± 0.7% | 783.3 ± 0.6% | 5.186 | 5.708 | 36.358 | 3.104 | 23.974 |
| hex: canterbury/alice29.txt | 304180 | 19129.0 ± 0.5% | 3620.7 ± 0.2% | 3374.0 ± 0.1% | 510.2 ± 4.3% | 6093.7 ± 1.0% | 784.2 ± 0.6% | 5.283 | 5.670 | 37.493 | 3.139 | 24.392 |
| hex: canterbury/asyoulik.txt | 250360 | 19543.6 ± 0.1% | 3632.3 ± 0.1% | 3377.2 ± 0.1% | 515.5 ± 0.1% | 6089.2 ± 2.0% | 781.9 ± 0.4% | 5.381 | 5.787 | 37.910 | 3.210 | 24.996 |
| hex: canterbury/cp.html | 49208 | 19275.1 ± 0.1% | 3637.4 ± 0.1% | 3285.3 ± 0.3% | 469.5 ± 2.1% | 6270.6 ± 0.3% | 760.5 ± 2.3% | 5.299 | 5.867 | 41.056 | 3.074 | 25.344 |
| hex: canterbury/fields.c | 22302 | 18920.3 ± 0.7% | 3628.9 ± 0.1% | 3352.1 ± 0.1% | 496.1 ± 0.8% | 6262.2 ± 0.6% | 751.6 ± 2.3% | 5.214 | 5.644 | 38.140 | 3.021 | 25.172 |
| hex: canterbury/grammar.lsp | 7444 | 17562.0 ± 2.2% | 3601.6 ± 0.0% | 3345.4 ± 0.2% | 532.6 ± 2.1% | 6174.5 ± 0.2% | 720.3 ± 2.2% | 4.876 | 5.250 | 32.976 | 2.844 | 24.382 |
| hex: canterbury/kennedy.xls | 524290 | 18694.0 ± 1.9% | 3614.5 ± 0.2% | 3286.0 ± 0.2% | 653.9 ± 6.4% | 5988.2 ± 1.0% | 760.0 ± 5.0% | 5.172 | 5.689 | 28.589 | 3.122 | 24.599 |
| hex: canterbury/lcet10.txt | 524290 | 18741.3 ± 1.0% | 3613.5 ± 0.3% | 3293.3 ± 0.3% | 522.0 ± 1.6% | 6097.9 ± 0.3% | 771.8 ± 1.8% | 5.187 | 5.691 | 35.901 | 3.073 | 24.281 |
| hex: canterbury/plrabn12.txt | 524290 | 18228.3 ± 0.9% | 3610.7 ± 0.5% | 3286.0 ± 0.1% | 510.5 ± 0.5% | 6080.0 ± 0.4% | 767.5 ± 1.2% | 5.048 | 5.547 | 35.706 | 2.998 | 23.752 |
| hex: canterbury/ptt5 | 524290 | 18573.1 ± 1.2% | 3616.3 ± 0.4% | 3288.3 ± 0.2% | 553.0 ± 3.0% | 5992.2 ± 1.4% | 768.7 ± 1.5% | 5.136 | 5.648 | 33.583 | 3.100 | 24.161 |
| hex: canterbury/sum | 76482 | 19284.0 ± 0.5% | 3633.4 ± 0.0% | 3354.5 ± 0.1% | 509.8 ± 0.5% | 6157.6 ± 0.4% | 768.5 ± 1.2% | 5.307 | 5.749 | 37.824 | 3.132 | 25.094 |
| hex: canterbury/xargs.1 | 8456 | 17819.5 ± 0.5% | 3602.7 ± 0.0% | 3348.1 ± 0.5% | 487.1 ± 4.6% | 6147.2 ± 0.5% | 751.3 ± 1.1% | 4.946 | 5.322 | 36.582 | 2.899 | 23.717 |
| hex: canterbury-large/E.coli | 524290 | 18624.2 ± 1.2% | 3614.2 ± 0.3% | 3296.0 ± 0.1% | 688.5 ± 0.3% | 5967.5 ± 2.9% | 762.6 ± 1.5% | 5.153 | 5.651 | 27.049 | 3.121 | 24.421 |
| hex: canterbury-large/bible.txt | 524290 | 18637.5 ± 1.1% | 3615.0 ± 0.4% | 3287.6 ± 0.6% | 516.0 ± 1.3% | 5946.8 ± 0.9% | 766.5 ± 1.3% | 5.156 | 5.669 | 36.120 | 3.134 | 24.317 |
| hex: canterbury-large/world192.txt | 524290 | 17988.0 ± 0.9% | 3619.6 ± 0.2% | 3289.0 ± 0.2% | 495.5 ± 1.4% | 6067.9 ± 1.0% | 769.4 ± 2.9% | 4.970 | 5.469 | 36.300 | 2.964 | 23.378 |
| hex: http/html-1kx1024 | 2099200 | 9461.7 ± 11.3% | 3464.8 ± 0.1% | 2867.0 ± 0.8% | 472.7 ± 1.2% | 5160.0 ± 1.5% | 646.2 ± 2.5% | 2.731 | 3.300 | 20.016 | 1.834 | 14.643 |
| hex: http/html-16kx64 | 2097280 | 17853.2 ± 0.6% | 3607.9 ± 0.3% | 3249.6 ± 0.2% | 476.2 ± 1.1% | 6005.2 ± 0.6% | 754.7 ± 1.4% | 4.948 | 5.494 | 37.493 | 2.973 | 23.656 |
| hex: http/html-1m | 524290 | 18204.8 ± 0.4% | 3620.6 ± 0.3% | 3292.6 ± 0.2% | 499.6 ± 2.6% | 6037.9 ± 0.9% | 762.7 ± 2.3% | 5.028 | 5.529 | 36.440 | 3.015 | 23.869 |
| hex: http/json-1kx1024 | 2099200 | 9660.7 ± 19.4% | 3459.6 ± 0.2% | 2863.0 ± 0.4% | 575.9 ± 0.7% | 5135.6 ± 1.9% | 640.5 ± 3.2% | 2.792 | 3.374 | 16.774 | 1.881 | 15.083 |
| hex: http/json-16kx64 | 2097280 | 17998.1 ± 0.4% | 3604.7 ± 0.2% | 3257.6 ± 0.2% | 572.7 ± 0.5% | 6015.3 ± 0.6% | 749.6 ± 2.5% | 4.993 | 5.525 | 31.425 | 2.992 | 24.011 |
| hex: http/json-1m | 524290 | 18401.4 ± 2.7% | 3616.0 ± 0.2% | 3290.6 ± 0.3% | 587.0 ± 3.1% | 6065.1 ± 0.7% | 765.6 ± 4.0% | 5.089 | 5.592 | 31.349 | 3.034 | 24.035 |
| hex: http/js-1kx1024 | 2099200 | 9382.5 ± 16.9% | 3464.8 ± 0.1% | 2864.0 ± 0.4% | 480.3 ± 0.5% | 5109.1 ± 2.0% | 648.3 ± 0.9% | 2.708 | 3.276 | 19.533 | 1.836 | 14.473 |
| hex: http/js-16kx64 | 2097280 | 17867.4 ± 2.8% | 3609.5 ± 0.1% | 3265.2 ± 0.1% | 480.2 ± 2.6% | 6010.0 ± 0.6% | 756.1 ± 2.5% | 4.950 | 5.472 | 37.205 | 2.973 | 23.631 |
| hex: http/js-1m | 524290 | 18660.7 ± 2.0% | 3621.2 ± 0.2% | 3285.8 ± 0.3% | 498.4 ± 2.0% | 6019.0 ± 0.8% | 762.2 ± 1.7% | 5.153 | 5.679 | 37.444 | 3.100 | 24.483 |
| hex: http/css-1kx1024 | 2099200 | 9450.5 ± 17.7% | 3459.7 ± 0.2% | 2863.4 ± 0.3% | 489.0 ± 0.6% | 5090.9 ± 1.8% | 644.6 ± 4.1% | 2.732 | 3.300 | 19.326 | 1.856 | 14.662 |
| hex: http/css-16kx64 | 2097280 | 18075.7 ± 1.6% | 3611.7 ± 0.2% | 3272.4 ± 0.2% | 495.9 ± 0.6% | 6001.5 ± 0.2% | 746.2 ± 2.2% | 5.005 | 5.524 | 36.448 | 3.012 | 24.223 |
| hex: http/css-1m | 524290 | 18575.5 ± 0.9% | 3616.5 ± 0.5% | 3290.5 ± 0.4% | 496.2 ± 1.3% | 6091.3 ± 0.6% | 748.4 ± 0.7% | 5.136 | 5.645 | 37.434 | 3.050 | 24.821 |
| hex: shuffled/dickens-1m | 524290 | 18034.9 ± 0.8% | 3619.0 ± 0.1% | 3283.9 ± 0.3% | 514.0 ± 0.6% | 6016.3 ± 0.8% | 755.4 ± 0.9% | 4.983 | 5.492 | 35.086 | 2.998 | 23.876 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1482.0 ± 0.8% | 1253.6 ± 0.8% | 1041.5 ± 0.6% | 410.3 ± 0.5% | 448.7 ± 0.4% | 414.8 ± 0.5% | 1.182 | 1.423 | 3.612 | 3.303 | 3.572 |
| qlog records, JSON text sequence | 1467503 | 1270.1 ± 1.5% | 1066.2 ± 0.6% | 788.8 ± 1.0% | 379.5 ± 0.5% | 468.0 ± 0.6% | 279.1 ± 0.6% | 1.191 | 1.610 | 3.347 | 2.714 | 4.551 |
| string: silesia/dickens | 172528 | 6892.3 ± 0.4% | 2816.1 ± 0.3% | 2929.0 ± 0.8% | 429.8 ± 0.7% | 1595.2 ± 0.4% | 1009.4 ± 0.2% | 2.447 | 2.353 | 16.037 | 4.321 | 6.828 |
| string: silesia/nci | 1075110 | 7308.9 ± 0.6% | 3389.8 ± 1.0% | 3097.0 ± 0.6% | 814.3 ± 1.3% | 1861.4 ± 0.4% | 1108.6 ± 0.3% | 2.156 | 2.360 | 8.976 | 3.927 | 6.593 |
| string: silesia/reymont | 1075159 | 3327.9 ± 1.0% | 1981.7 ± 1.6% | 2062.8 ± 0.4% | 449.8 ± 0.6% | 1510.7 ± 1.7% | 951.1 ± 0.5% | 1.679 | 1.613 | 7.399 | 2.203 | 3.499 |
| string: silesia/samba | 97582 | 4197.8 ± 0.8% | 2115.8 ± 0.3% | 3455.8 ± 0.3% | 353.3 ± 0.7% | 1436.1 ± 0.6% | 1053.8 ± 0.3% | 1.984 | 1.215 | 11.881 | 2.923 | 3.984 |
| string: silesia/webster | 1098490 | 4045.7 ± 0.3% | 1877.3 ± 0.6% | 2055.5 ± 0.7% | 440.4 ± 0.3% | 1394.7 ± 0.4% | 645.7 ± 0.4% | 2.155 | 1.968 | 9.187 | 2.901 | 6.265 |
| string: silesia/xml | 1090118 | 6125.5 ± 0.7% | 2864.2 ± 0.8% | 2651.9 ± 1.6% | 610.7 ± 1.0% | 1753.8 ± 0.4% | 921.4 ± 0.5% | 2.139 | 2.310 | 10.030 | 3.493 | 6.648 |
| string: canterbury/alice29.txt | 159425 | 6407.9 ± 1.0% | 2198.9 ± 0.9% | 2765.6 ± 0.6% | 407.2 ± 1.2% | 1480.0 ± 0.3% | 953.5 ± 0.2% | 2.914 | 2.317 | 15.735 | 4.330 | 6.720 |
| string: canterbury/asyoulik.txt | 132198 | 5594.9 ± 0.8% | 1718.4 ± 0.6% | 2362.4 ± 1.1% | 401.8 ± 0.6% | 1348.4 ± 0.9% | 883.1 ± 0.2% | 3.256 | 2.368 | 13.923 | 4.149 | 6.335 |
| string: canterbury/lcet10.txt | 441884 | 6228.9 ± 0.5% | 2552.1 ± 0.4% | 2494.4 ± 2.4% | 465.6 ± 0.6% | 1535.4 ± 0.3% | 985.8 ± 0.6% | 2.441 | 2.497 | 13.378 | 4.057 | 6.319 |
| string: canterbury/plrabn12.txt | 503330 | 5699.6 ± 0.5% | 2049.9 ± 0.2% | 2072.8 ± 0.5% | 422.6 ± 0.6% | 1430.2 ± 0.4% | 932.6 ± 0.7% | 2.780 | 2.750 | 13.488 | 3.985 | 6.112 |
| string: canterbury-large/E.coli | 1048578 | 19292.4 ± 0.9% | 9705.7 ± 0.8% | 3786.5 ± 0.7% | 1475.7 ± 0.3% | 2367.6 ± 0.6% | 1194.4 ± 0.4% | 1.988 | 5.095 | 13.073 | 8.149 | 16.152 |
| string: canterbury-large/bible.txt | 1055886 | 6789.7 ± 0.4% | 4142.0 ± 1.1% | 3019.2 ± 1.5% | 505.1 ± 0.6% | 1966.0 ± 0.3% | 1121.4 ± 0.6% | 1.639 | 2.249 | 13.443 | 3.454 | 6.054 |
| string: canterbury-large/world192.txt | 1103121 | 4022.3 ± 0.4% | 1653.7 ± 0.3% | 2000.6 ± 0.3% | 447.5 ± 0.5% | 1360.7 ± 0.4% | 909.3 ± 0.1% | 2.432 | 2.011 | 8.989 | 2.956 | 4.423 |
| string: http/html-1m | 1058582 | 6741.2 ± 0.3% | 3974.1 ± 0.5% | 3038.9 ± 0.7% | 499.9 ± 0.8% | 1917.6 ± 0.2% | 806.5 ± 0.5% | 1.696 | 2.218 | 13.485 | 3.516 | 8.359 |
| string: http/json-1m | 1190272 | 3166.7 ± 0.4% | 1348.5 ± 0.6% | 1556.1 ± 0.5% | 443.1 ± 1.0% | 961.9 ± 0.3% | 764.6 ± 1.3% | 2.348 | 2.035 | 7.147 | 3.292 | 4.141 |
| string: http/js-1m | 1144362 | 2751.4 ± 0.6% | 1180.0 ± 0.2% | 1626.9 ± 0.2% | 368.0 ± 0.4% | 1095.9 ± 0.4% | 758.1 ± 0.3% | 2.332 | 1.691 | 7.478 | 2.511 | 3.629 |
| string: http/css-1m | 1097820 | 3978.2 ± 0.6% | 1486.5 ± 0.5% | 2151.0 ± 1.2% | 493.0 ± 0.4% | 1369.6 ± 0.2% | 895.9 ± 0.4% | 2.676 | 1.849 | 8.070 | 2.905 | 4.441 |
| string: dickens as Cyrillic and CJK | 1883069 | 3065.2 ± 0.3% | 2348.7 ± 0.7% | 520.5 ± 0.5% | 308.1 ± 0.4% | 559.3 ± 0.8% | 336.6 ± 0.3% | 1.305 | 5.889 | 9.948 | 5.481 | 9.106 |
| hex: silesia/dickens | 524290 | 15640.7 ± 0.2% | 1464.6 ± 0.5% | 1082.7 ± 0.7% | 500.4 ± 0.8% | 989.3 ± 0.4% | 734.0 ± 0.9% | 10.679 | 14.446 | 31.254 | 15.810 | 21.310 |
| hex: silesia/mozilla | 524290 | 15659.3 ± 0.3% | 1467.3 ± 0.6% | 1089.2 ± 0.5% | 442.2 ± 0.7% | 991.8 ± 0.6% | 736.5 ± 0.3% | 10.673 | 14.377 | 35.413 | 15.788 | 21.262 |
| hex: silesia/mr | 524290 | 15631.0 ± 0.3% | 1483.6 ± 0.3% | 1094.4 ± 0.3% | 542.9 ± 3.7% | 997.4 ± 0.5% | 735.6 ± 0.2% | 10.536 | 14.283 | 28.792 | 15.671 | 21.249 |
| hex: silesia/nci | 524290 | 15666.0 ± 0.3% | 1472.8 ± 0.4% | 1088.9 ± 0.6% | 637.0 ± 4.0% | 991.1 ± 0.4% | 734.9 ± 0.4% | 10.637 | 14.387 | 24.593 | 15.806 | 21.317 |
| hex: silesia/ooffice | 524290 | 15586.3 ± 0.4% | 1466.7 ± 0.2% | 1085.2 ± 0.6% | 388.6 ± 0.2% | 992.0 ± 0.9% | 735.5 ± 0.6% | 10.627 | 14.363 | 40.109 | 15.712 | 21.192 |
| hex: silesia/osdb | 524290 | 15627.9 ± 0.2% | 1466.3 ± 0.4% | 1086.5 ± 0.4% | 468.2 ± 0.6% | 989.1 ± 0.6% | 736.4 ± 0.5% | 10.658 | 14.383 | 33.381 | 15.800 | 21.223 |
| hex: silesia/reymont | 524290 | 15686.8 ± 0.1% | 1463.7 ± 0.5% | 1085.2 ± 0.4% | 513.3 ± 2.1% | 989.7 ± 1.0% | 735.0 ± 0.8% | 10.718 | 14.456 | 30.558 | 15.849 | 21.342 |
| hex: silesia/samba | 524290 | 15591.1 ± 0.2% | 1465.4 ± 0.4% | 1085.9 ± 0.5% | 402.1 ± 0.5% | 991.5 ± 0.8% | 736.4 ± 0.6% | 10.639 | 14.358 | 38.772 | 15.725 | 21.171 |
| hex: silesia/sao | 524290 | 15581.1 ± 0.2% | 1465.8 ± 0.4% | 1085.6 ± 0.5% | 332.7 ± 0.1% | 990.0 ± 0.4% | 733.9 ± 0.6% | 10.630 | 14.353 | 46.831 | 15.739 | 21.229 |
| hex: silesia/webster | 524290 | 15671.4 ± 0.3% | 1465.1 ± 0.3% | 1086.7 ± 0.5% | 474.4 ± 0.5% | 991.7 ± 0.4% | 736.2 ± 0.6% | 10.696 | 14.421 | 33.035 | 15.802 | 21.288 |
| hex: silesia/x-ray | 524290 | 15627.2 ± 0.2% | 1474.9 ± 0.1% | 1092.9 ± 0.5% | 447.2 ± 1.5% | 993.0 ± 0.8% | 736.0 ± 0.4% | 10.595 | 14.299 | 34.945 | 15.738 | 21.232 |
| hex: silesia/xml | 524290 | 15644.8 ± 0.5% | 1468.1 ± 0.1% | 1088.3 ± 0.4% | 615.8 ± 1.4% | 992.1 ± 0.5% | 735.1 ± 0.4% | 10.657 | 14.375 | 25.406 | 15.770 | 21.282 |
| hex: canterbury/alice29.txt | 304180 | 15668.3 ± 0.1% | 1469.8 ± 0.6% | 1092.4 ± 0.6% | 503.9 ± 0.3% | 995.1 ± 0.8% | 735.3 ± 0.6% | 10.660 | 14.343 | 31.091 | 15.745 | 21.308 |
| hex: canterbury/asyoulik.txt | 250360 | 15680.1 ± 0.5% | 1470.7 ± 0.4% | 1093.6 ± 0.4% | 496.8 ± 0.6% | 994.3 ± 0.9% | 741.4 ± 0.2% | 10.662 | 14.339 | 31.564 | 15.770 | 21.151 |
| hex: canterbury/cp.html | 49208 | 15617.7 ± 0.2% | 1475.2 ± 0.4% | 1097.6 ± 0.1% | 530.2 ± 2.9% | 1001.6 ± 0.6% | 742.1 ± 0.2% | 10.587 | 14.229 | 29.459 | 15.593 | 21.045 |
| hex: canterbury/fields.c | 22302 | 15434.4 ± 0.1% | 1440.6 ± 0.7% | 1066.0 ± 0.2% | 626.7 ± 8.0% | 990.6 ± 0.1% | 735.3 ± 0.1% | 10.714 | 14.479 | 24.630 | 15.580 | 20.992 |
| hex: canterbury/grammar.lsp | 7444 | 14933.5 ± 0.1% | 1488.2 ± 0.1% | 1093.7 ± 0.4% | 659.6 ± 3.2% | 996.9 ± 0.3% | 725.8 ± 0.2% | 10.034 | 13.654 | 22.639 | 14.980 | 20.577 |
| hex: canterbury/kennedy.xls | 524290 | 15608.5 ± 0.3% | 1473.2 ± 0.4% | 1089.1 ± 0.3% | 654.7 ± 2.1% | 992.5 ± 0.6% | 733.3 ± 0.7% | 10.595 | 14.331 | 23.840 | 15.726 | 21.284 |
| hex: canterbury/lcet10.txt | 524290 | 15641.0 ± 0.1% | 1459.3 ± 0.6% | 1083.6 ± 0.2% | 501.3 ± 1.6% | 989.4 ± 0.7% | 735.6 ± 0.6% | 10.718 | 14.434 | 31.198 | 15.809 | 21.263 |
| hex: canterbury/plrabn12.txt | 524290 | 15655.3 ± 0.1% | 1464.3 ± 0.4% | 1082.4 ± 0.2% | 495.8 ± 0.4% | 990.6 ± 0.2% | 734.3 ± 0.4% | 10.692 | 14.464 | 31.574 | 15.804 | 21.321 |
| hex: canterbury/ptt5 | 524290 | 15656.7 ± 0.2% | 1478.9 ± 0.3% | 1092.6 ± 0.5% | 555.5 ± 0.5% | 993.2 ± 0.3% | 734.8 ± 0.7% | 10.587 | 14.330 | 28.184 | 15.763 | 21.309 |
| hex: canterbury/sum | 76482 | 15638.6 ± 0.0% | 1495.6 ± 0.2% | 1105.1 ± 0.2% | 596.2 ± 2.8% | 998.3 ± 0.2% | 743.8 ± 0.1% | 10.456 | 14.151 | 26.230 | 15.665 | 21.027 |
| hex: canterbury/xargs.1 | 8456 | 14992.4 ± 0.1% | 1432.4 ± 1.0% | 1068.8 ± 0.2% | 662.9 ± 4.5% | 1003.4 ± 0.3% | 727.9 ± 0.5% | 10.467 | 14.028 | 22.618 | 14.941 | 20.597 |
| hex: canterbury-large/E.coli | 524290 | 15634.6 ± 0.4% | 1475.1 ± 0.4% | 1090.0 ± 0.3% | 671.4 ± 0.2% | 993.4 ± 1.0% | 734.7 ± 0.5% | 10.599 | 14.343 | 23.286 | 15.738 | 21.280 |
| hex: canterbury-large/bible.txt | 524290 | 15628.3 ± 0.3% | 1463.2 ± 0.2% | 1088.1 ± 0.2% | 514.6 ± 1.0% | 986.4 ± 0.6% | 735.4 ± 0.9% | 10.681 | 14.363 | 30.372 | 15.844 | 21.253 |
| hex: canterbury-large/world192.txt | 524290 | 15598.8 ± 0.3% | 1466.8 ± 0.3% | 1085.0 ± 0.4% | 503.6 ± 0.5% | 990.2 ± 0.5% | 735.3 ± 0.6% | 10.635 | 14.377 | 30.974 | 15.754 | 21.214 |
| hex: http/html-1kx1024 | 2099200 | 13616.7 ± 0.8% | 1454.0 ± 0.1% | 1060.8 ± 0.2% | 502.1 ± 0.6% | 982.0 ± 0.1% | 692.5 ± 0.1% | 9.365 | 12.836 | 27.120 | 13.866 | 19.664 |
| hex: http/html-16kx64 | 2097280 | 15267.4 ± 0.3% | 1445.7 ± 0.2% | 1073.4 ± 0.4% | 506.4 ± 0.3% | 996.0 ± 0.1% | 734.9 ± 0.1% | 10.560 | 14.223 | 30.151 | 15.329 | 20.774 |
| hex: http/html-1m | 524290 | 15667.3 ± 0.3% | 1469.1 ± 0.4% | 1086.4 ± 0.5% | 500.8 ± 0.2% | 992.2 ± 0.6% | 735.0 ± 0.6% | 10.665 | 14.421 | 31.288 | 15.791 | 21.315 |
| hex: http/json-1kx1024 | 2099200 | 13674.7 ± 0.6% | 1462.8 ± 0.2% | 1066.3 ± 0.2% | 609.0 ± 0.4% | 986.0 ± 0.3% | 692.3 ± 0.1% | 9.348 | 12.824 | 22.453 | 13.869 | 19.752 |
| hex: http/json-16kx64 | 2097280 | 15248.4 ± 0.2% | 1445.6 ± 0.1% | 1074.9 ± 0.2% | 617.4 ± 0.4% | 996.7 ± 0.2% | 735.3 ± 0.3% | 10.548 | 14.185 | 24.698 | 15.299 | 20.739 |
| hex: http/json-1m | 524290 | 15649.4 ± 0.1% | 1474.9 ± 0.4% | 1089.7 ± 0.5% | 631.5 ± 1.4% | 992.8 ± 0.6% | 735.2 ± 0.6% | 10.610 | 14.361 | 24.781 | 15.763 | 21.286 |
| hex: http/js-1kx1024 | 2099200 | 13673.2 ± 0.7% | 1452.9 ± 0.1% | 1062.4 ± 0.2% | 499.3 ± 0.5% | 982.6 ± 0.1% | 692.3 ± 0.1% | 9.411 | 12.870 | 27.386 | 13.916 | 19.752 |
| hex: http/js-16kx64 | 2097280 | 15222.8 ± 0.5% | 1444.0 ± 0.1% | 1075.2 ± 0.2% | 504.4 ± 0.6% | 998.2 ± 0.3% | 734.2 ± 0.3% | 10.542 | 14.159 | 30.180 | 15.250 | 20.735 |
| hex: http/js-1m | 524290 | 15615.6 ± 0.1% | 1465.2 ± 0.3% | 1085.6 ± 0.3% | 511.8 ± 0.5% | 991.5 ± 0.7% | 735.4 ± 0.6% | 10.658 | 14.385 | 30.514 | 15.750 | 21.234 |
| hex: http/css-1kx1024 | 2099200 | 13658.9 ± 0.7% | 1454.1 ± 0.2% | 1062.6 ± 0.2% | 530.8 ± 0.4% | 982.5 ± 0.6% | 692.5 ± 0.3% | 9.394 | 12.855 | 25.735 | 13.902 | 19.725 |
| hex: http/css-16kx64 | 2097280 | 15251.8 ± 0.6% | 1444.1 ± 0.2% | 1073.4 ± 0.3% | 540.9 ± 0.4% | 999.9 ± 0.3% | 734.9 ± 0.1% | 10.561 | 14.208 | 28.198 | 15.253 | 20.753 |
| hex: http/css-1m | 524290 | 15684.5 ± 0.1% | 1461.9 ± 0.1% | 1084.0 ± 0.7% | 527.8 ± 0.5% | 989.3 ± 0.5% | 735.7 ± 0.2% | 10.729 | 14.469 | 29.717 | 15.854 | 21.319 |
| hex: shuffled/dickens-1m | 524290 | 15657.7 ± 0.3% | 1465.3 ± 0.3% | 1086.2 ± 0.7% | 503.7 ± 0.5% | 987.1 ± 0.6% | 736.5 ± 0.7% | 10.686 | 14.415 | 31.087 | 15.863 | 21.260 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1525.1 ± 0.4% | 1253.6 ± 0.8% | 1041.5 ± 0.6% | 410.3 ± 0.5% | 448.7 ± 0.4% | 414.8 ± 0.5% | 1.217 | 1.464 | 3.717 | 3.399 | 3.676 |
| qlog records, JSON text sequence | 1467503 | 1294.2 ± 0.3% | 1066.2 ± 0.6% | 788.8 ± 1.0% | 379.5 ± 0.5% | 468.0 ± 0.6% | 279.1 ± 0.6% | 1.214 | 1.641 | 3.410 | 2.765 | 4.637 |
| string: silesia/dickens | 172528 | 7114.9 ± 0.4% | 2816.1 ± 0.3% | 2929.0 ± 0.8% | 429.8 ± 0.7% | 1595.2 ± 0.4% | 1009.4 ± 0.2% | 2.526 | 2.429 | 16.555 | 4.460 | 7.049 |
| string: silesia/nci | 1075110 | 7324.0 ± 7.2% | 3389.8 ± 1.0% | 3097.0 ± 0.6% | 814.3 ± 1.3% | 1861.4 ± 0.4% | 1108.6 ± 0.3% | 2.161 | 2.365 | 8.994 | 3.935 | 6.606 |
| string: silesia/reymont | 1075159 | 3512.7 ± 1.7% | 1981.7 ± 1.6% | 2062.8 ± 0.4% | 449.8 ± 0.6% | 1510.7 ± 1.7% | 951.1 ± 0.5% | 1.773 | 1.703 | 7.810 | 2.325 | 3.693 |
| string: silesia/samba | 97582 | 4585.1 ± 1.1% | 2115.8 ± 0.3% | 3455.8 ± 0.3% | 353.3 ± 0.7% | 1436.1 ± 0.6% | 1053.8 ± 0.3% | 2.167 | 1.327 | 12.977 | 3.193 | 4.351 |
| string: silesia/webster | 1098490 | 4090.3 ± 0.8% | 1877.3 ± 0.6% | 2055.5 ± 0.7% | 440.4 ± 0.3% | 1394.7 ± 0.4% | 645.7 ± 0.4% | 2.179 | 1.990 | 9.288 | 2.933 | 6.334 |
| string: silesia/xml | 1090118 | 6241.0 ± 0.7% | 2864.2 ± 0.8% | 2651.9 ± 1.6% | 610.7 ± 1.0% | 1753.8 ± 0.4% | 921.4 ± 0.5% | 2.179 | 2.353 | 10.219 | 3.558 | 6.773 |
| string: canterbury/alice29.txt | 159425 | 6757.0 ± 2.3% | 2198.9 ± 0.9% | 2765.6 ± 0.6% | 407.2 ± 1.2% | 1480.0 ± 0.3% | 953.5 ± 0.2% | 3.073 | 2.443 | 16.592 | 4.566 | 7.086 |
| string: canterbury/asyoulik.txt | 132198 | 5886.0 ± 2.9% | 1718.4 ± 0.6% | 2362.4 ± 1.1% | 401.8 ± 0.6% | 1348.4 ± 0.9% | 883.1 ± 0.2% | 3.425 | 2.492 | 14.648 | 4.365 | 6.665 |
| string: canterbury/lcet10.txt | 441884 | 6257.4 ± 0.9% | 2552.1 ± 0.4% | 2494.4 ± 2.4% | 465.6 ± 0.6% | 1535.4 ± 0.3% | 985.8 ± 0.6% | 2.452 | 2.509 | 13.439 | 4.075 | 6.348 |
| string: canterbury/plrabn12.txt | 503330 | 5731.2 ± 0.4% | 2049.9 ± 0.2% | 2072.8 ± 0.5% | 422.6 ± 0.6% | 1430.2 ± 0.4% | 932.6 ± 0.7% | 2.796 | 2.765 | 13.562 | 4.007 | 6.145 |
| string: canterbury-large/E.coli | 1048578 | 19327.6 ± 0.4% | 9705.7 ± 0.8% | 3786.5 ± 0.7% | 1475.7 ± 0.3% | 2367.6 ± 0.6% | 1194.4 ± 0.4% | 1.991 | 5.104 | 13.097 | 8.163 | 16.182 |
| string: canterbury-large/bible.txt | 1055886 | 6795.6 ± 0.4% | 4142.0 ± 1.1% | 3019.2 ± 1.5% | 505.1 ± 0.6% | 1966.0 ± 0.3% | 1121.4 ± 0.6% | 1.641 | 2.251 | 13.454 | 3.457 | 6.060 |
| string: canterbury-large/world192.txt | 1103121 | 4033.4 ± 1.0% | 1653.7 ± 0.3% | 2000.6 ± 0.3% | 447.5 ± 0.5% | 1360.7 ± 0.4% | 909.3 ± 0.1% | 2.439 | 2.016 | 9.014 | 2.964 | 4.436 |
| string: http/html-1m | 1058582 | 6811.8 ± 0.4% | 3974.1 ± 0.5% | 3038.9 ± 0.7% | 499.9 ± 0.8% | 1917.6 ± 0.2% | 806.5 ± 0.5% | 1.714 | 2.242 | 13.627 | 3.552 | 8.446 |
| string: http/json-1m | 1190272 | 3299.2 ± 0.4% | 1348.5 ± 0.6% | 1556.1 ± 0.5% | 443.1 ± 1.0% | 961.9 ± 0.3% | 764.6 ± 1.3% | 2.447 | 2.120 | 7.447 | 3.430 | 4.315 |
| string: http/js-1m | 1144362 | 2809.3 ± 0.7% | 1180.0 ± 0.2% | 1626.9 ± 0.2% | 368.0 ± 0.4% | 1095.9 ± 0.4% | 758.1 ± 0.3% | 2.381 | 1.727 | 7.635 | 2.563 | 3.706 |
| string: http/css-1m | 1097820 | 4039.1 ± 0.8% | 1486.5 ± 0.5% | 2151.0 ± 1.2% | 493.0 ± 0.4% | 1369.6 ± 0.2% | 895.9 ± 0.4% | 2.717 | 1.878 | 8.193 | 2.949 | 4.509 |
| string: dickens as Cyrillic and CJK | 1883069 | 3075.9 ± 0.3% | 2348.7 ± 0.7% | 520.5 ± 0.5% | 308.1 ± 0.4% | 559.3 ± 0.8% | 336.6 ± 0.3% | 1.310 | 5.909 | 9.983 | 5.500 | 9.138 |
| hex: silesia/dickens | 524290 | 15606.8 ± 0.3% | 1464.6 ± 0.5% | 1082.7 ± 0.7% | 500.4 ± 0.8% | 989.3 ± 0.4% | 734.0 ± 0.9% | 10.656 | 14.415 | 31.187 | 15.776 | 21.264 |
| hex: silesia/mozilla | 524290 | 15686.6 ± 0.2% | 1467.3 ± 0.6% | 1089.2 ± 0.5% | 442.2 ± 0.7% | 991.8 ± 0.6% | 736.5 ± 0.3% | 10.691 | 14.402 | 35.475 | 15.816 | 21.299 |
| hex: silesia/mr | 524290 | 15627.2 ± 0.4% | 1483.6 ± 0.3% | 1094.4 ± 0.3% | 542.9 ± 3.7% | 997.4 ± 0.5% | 735.6 ± 0.2% | 10.534 | 14.280 | 28.785 | 15.667 | 21.244 |
| hex: silesia/nci | 524290 | 15687.0 ± 0.2% | 1472.8 ± 0.4% | 1088.9 ± 0.6% | 637.0 ± 4.0% | 991.1 ± 0.4% | 734.9 ± 0.4% | 10.651 | 14.407 | 24.626 | 15.827 | 21.346 |
| hex: silesia/ooffice | 524290 | 15624.2 ± 0.1% | 1466.7 ± 0.2% | 1085.2 ± 0.6% | 388.6 ± 0.2% | 992.0 ± 0.9% | 735.5 ± 0.6% | 10.653 | 14.397 | 40.206 | 15.750 | 21.244 |
| hex: silesia/osdb | 524290 | 15657.7 ± 0.3% | 1466.3 ± 0.4% | 1086.5 ± 0.4% | 468.2 ± 0.6% | 989.1 ± 0.6% | 736.4 ± 0.5% | 10.678 | 14.411 | 33.445 | 15.830 | 21.264 |
| hex: silesia/reymont | 524290 | 15677.3 ± 0.5% | 1463.7 ± 0.5% | 1085.2 ± 0.4% | 513.3 ± 2.1% | 989.7 ± 1.0% | 735.0 ± 0.8% | 10.711 | 14.447 | 30.540 | 15.840 | 21.329 |
| hex: silesia/samba | 524290 | 15573.4 ± 0.3% | 1465.4 ± 0.4% | 1085.9 ± 0.5% | 402.1 ± 0.5% | 991.5 ± 0.8% | 736.4 ± 0.6% | 10.627 | 14.342 | 38.728 | 15.707 | 21.147 |
| hex: silesia/sao | 524290 | 15623.1 ± 0.4% | 1465.8 ± 0.4% | 1085.6 ± 0.5% | 332.7 ± 0.1% | 990.0 ± 0.4% | 733.9 ± 0.6% | 10.658 | 14.392 | 46.957 | 15.782 | 21.287 |
| hex: silesia/webster | 524290 | 15690.3 ± 0.1% | 1465.1 ± 0.3% | 1086.7 ± 0.5% | 474.4 ± 0.5% | 991.7 ± 0.4% | 736.2 ± 0.6% | 10.709 | 14.439 | 33.075 | 15.821 | 21.314 |
| hex: silesia/x-ray | 524290 | 15651.5 ± 0.1% | 1474.9 ± 0.1% | 1092.9 ± 0.5% | 447.2 ± 1.5% | 993.0 ± 0.8% | 736.0 ± 0.4% | 10.612 | 14.321 | 34.999 | 15.762 | 21.265 |
| hex: silesia/xml | 524290 | 15642.5 ± 0.2% | 1468.1 ± 0.1% | 1088.3 ± 0.4% | 615.8 ± 1.4% | 992.1 ± 0.5% | 735.1 ± 0.4% | 10.655 | 14.373 | 25.402 | 15.768 | 21.279 |
| hex: canterbury/alice29.txt | 304180 | 15673.2 ± 0.2% | 1469.8 ± 0.6% | 1092.4 ± 0.6% | 503.9 ± 0.3% | 995.1 ± 0.8% | 735.3 ± 0.6% | 10.664 | 14.348 | 31.101 | 15.750 | 21.314 |
| hex: canterbury/asyoulik.txt | 250360 | 15699.4 ± 0.1% | 1470.7 ± 0.4% | 1093.6 ± 0.4% | 496.8 ± 0.6% | 994.3 ± 0.9% | 741.4 ± 0.2% | 10.675 | 14.356 | 31.603 | 15.790 | 21.177 |
| hex: canterbury/cp.html | 49208 | 15634.6 ± 0.0% | 1475.2 ± 0.4% | 1097.6 ± 0.1% | 530.2 ± 2.9% | 1001.6 ± 0.6% | 742.1 ± 0.2% | 10.598 | 14.244 | 29.491 | 15.610 | 21.067 |
| hex: canterbury/fields.c | 22302 | 15453.4 ± 0.0% | 1440.6 ± 0.7% | 1066.0 ± 0.2% | 626.7 ± 8.0% | 990.6 ± 0.1% | 735.3 ± 0.1% | 10.727 | 14.497 | 24.660 | 15.600 | 21.018 |
| hex: canterbury/grammar.lsp | 7444 | 14989.2 ± 0.2% | 1488.2 ± 0.1% | 1093.7 ± 0.4% | 659.6 ± 3.2% | 996.9 ± 0.3% | 725.8 ± 0.2% | 10.072 | 13.705 | 22.724 | 15.036 | 20.653 |
| hex: canterbury/kennedy.xls | 524290 | 15658.9 ± 0.2% | 1473.2 ± 0.4% | 1089.1 ± 0.3% | 654.7 ± 2.1% | 992.5 ± 0.6% | 733.3 ± 0.7% | 10.629 | 14.378 | 23.917 | 15.777 | 21.353 |
| hex: canterbury/lcet10.txt | 524290 | 15624.1 ± 0.4% | 1459.3 ± 0.6% | 1083.6 ± 0.2% | 501.3 ± 1.6% | 989.4 ± 0.7% | 735.6 ± 0.6% | 10.707 | 14.418 | 31.165 | 15.792 | 21.240 |
| hex: canterbury/plrabn12.txt | 524290 | 15666.8 ± 0.2% | 1464.3 ± 0.4% | 1082.4 ± 0.2% | 495.8 ± 0.4% | 990.6 ± 0.2% | 734.3 ± 0.4% | 10.699 | 14.475 | 31.597 | 15.815 | 21.336 |
| hex: canterbury/ptt5 | 524290 | 15657.8 ± 0.3% | 1478.9 ± 0.3% | 1092.6 ± 0.5% | 555.5 ± 0.5% | 993.2 ± 0.3% | 734.8 ± 0.7% | 10.587 | 14.331 | 28.186 | 15.764 | 21.310 |
| hex: canterbury/sum | 76482 | 15653.6 ± 0.0% | 1495.6 ± 0.2% | 1105.1 ± 0.2% | 596.2 ± 2.8% | 998.3 ± 0.2% | 743.8 ± 0.1% | 10.466 | 14.165 | 26.255 | 15.680 | 21.047 |
| hex: canterbury/xargs.1 | 8456 | 15036.5 ± 0.2% | 1432.4 ± 1.0% | 1068.8 ± 0.2% | 662.9 ± 4.5% | 1003.4 ± 0.3% | 727.9 ± 0.5% | 10.497 | 14.069 | 22.684 | 14.985 | 20.657 |
| hex: canterbury-large/E.coli | 524290 | 15648.7 ± 0.3% | 1475.1 ± 0.4% | 1090.0 ± 0.3% | 671.4 ± 0.2% | 993.4 ± 1.0% | 734.7 ± 0.5% | 10.608 | 14.356 | 23.307 | 15.753 | 21.299 |
| hex: canterbury-large/bible.txt | 524290 | 15626.1 ± 0.3% | 1463.2 ± 0.2% | 1088.1 ± 0.2% | 514.6 ± 1.0% | 986.4 ± 0.6% | 735.4 ± 0.9% | 10.680 | 14.361 | 30.367 | 15.841 | 21.250 |
| hex: canterbury-large/world192.txt | 524290 | 15625.3 ± 0.1% | 1466.8 ± 0.3% | 1085.0 ± 0.4% | 503.6 ± 0.5% | 990.2 ± 0.5% | 735.3 ± 0.6% | 10.653 | 14.401 | 31.026 | 15.780 | 21.250 |
| hex: http/html-1kx1024 | 2099200 | 13776.9 ± 0.4% | 1454.0 ± 0.1% | 1060.8 ± 0.2% | 502.1 ± 0.6% | 982.0 ± 0.1% | 692.5 ± 0.1% | 9.475 | 12.987 | 27.439 | 14.029 | 19.895 |
| hex: http/html-16kx64 | 2097280 | 15279.9 ± 0.8% | 1445.7 ± 0.2% | 1073.4 ± 0.4% | 506.4 ± 0.3% | 996.0 ± 0.1% | 734.9 ± 0.1% | 10.569 | 14.235 | 30.175 | 15.341 | 20.791 |
| hex: http/html-1m | 524290 | 15671.6 ± 0.2% | 1469.1 ± 0.4% | 1086.4 ± 0.5% | 500.8 ± 0.2% | 992.2 ± 0.6% | 735.0 ± 0.6% | 10.668 | 14.425 | 31.296 | 15.795 | 21.321 |
| hex: http/json-1kx1024 | 2099200 | 13793.0 ± 0.7% | 1462.8 ± 0.2% | 1066.3 ± 0.2% | 609.0 ± 0.4% | 986.0 ± 0.3% | 692.3 ± 0.1% | 9.429 | 12.935 | 22.647 | 13.989 | 19.923 |
| hex: http/json-16kx64 | 2097280 | 15219.0 ± 0.7% | 1445.6 ± 0.1% | 1074.9 ± 0.2% | 617.4 ± 0.4% | 996.7 ± 0.2% | 735.3 ± 0.3% | 10.528 | 14.158 | 24.650 | 15.270 | 20.699 |
| hex: http/json-1m | 524290 | 15631.6 ± 0.3% | 1474.9 ± 0.4% | 1089.7 ± 0.5% | 631.5 ± 1.4% | 992.8 ± 0.6% | 735.2 ± 0.6% | 10.598 | 14.345 | 24.752 | 15.745 | 21.261 |
| hex: http/js-1kx1024 | 2099200 | 13904.8 ± 0.4% | 1452.9 ± 0.1% | 1062.4 ± 0.2% | 499.3 ± 0.5% | 982.6 ± 0.1% | 692.3 ± 0.1% | 9.570 | 13.088 | 27.850 | 14.151 | 20.086 |
| hex: http/js-16kx64 | 2097280 | 15240.4 ± 0.5% | 1444.0 ± 0.1% | 1075.2 ± 0.2% | 504.4 ± 0.6% | 998.2 ± 0.3% | 734.2 ± 0.3% | 10.554 | 14.175 | 30.215 | 15.267 | 20.759 |
| hex: http/js-1m | 524290 | 15615.5 ± 0.5% | 1465.2 ± 0.3% | 1085.6 ± 0.3% | 511.8 ± 0.5% | 991.5 ± 0.7% | 735.4 ± 0.6% | 10.658 | 14.385 | 30.514 | 15.749 | 21.234 |
| hex: http/css-1kx1024 | 2099200 | 13816.0 ± 0.4% | 1454.1 ± 0.2% | 1062.6 ± 0.2% | 530.8 ± 0.4% | 982.5 ± 0.6% | 692.5 ± 0.3% | 9.502 | 13.002 | 26.030 | 14.062 | 19.951 |
| hex: http/css-16kx64 | 2097280 | 15252.0 ± 0.6% | 1444.1 ± 0.2% | 1073.4 ± 0.3% | 540.9 ± 0.4% | 999.9 ± 0.3% | 734.9 ± 0.1% | 10.562 | 14.209 | 28.198 | 15.254 | 20.754 |
| hex: http/css-1m | 524290 | 15689.3 ± 0.2% | 1461.9 ± 0.1% | 1084.0 ± 0.7% | 527.8 ± 0.5% | 989.3 ± 0.5% | 735.7 ± 0.2% | 10.732 | 14.473 | 29.726 | 15.859 | 21.326 |
| hex: shuffled/dickens-1m | 524290 | 15698.1 ± 0.4% | 1465.3 ± 0.3% | 1086.2 ± 0.7% | 503.7 ± 0.5% | 987.1 ± 0.6% | 736.5 ± 0.7% | 10.714 | 14.452 | 31.167 | 15.904 | 21.315 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 935.4 ± 0.3% | 931.8 ± 0.5% | 1021.2 ± 0.2% | 300.9 ± 0.8% | 666.1 ± 0.2% | 309.2 ± 1.2% | 1.004 | 0.916 | 3.109 | 1.404 | 3.025 |
| qlog records, JSON text sequence | 1467503 | 784.1 ± 0.6% | 817.0 ± 0.2% | 784.9 ± 1.5% | 244.3 ± 1.1% | 698.2 ± 0.3% | 250.8 ± 0.3% | 0.960 | 0.999 | 3.210 | 1.123 | 3.126 |
| string: silesia/dickens | 172528 | 5053.2 ± 0.2% | 1877.6 ± 0.1% | 2648.8 ± 0.4% | 360.3 ± 1.1% | 2853.1 ± 0.3% | 550.6 ± 2.2% | 2.691 | 1.908 | 14.024 | 1.771 | 9.178 |
| string: silesia/nci | 1075110 | 4309.7 ± 0.5% | 2240.4 ± 0.4% | 2994.7 ± 0.1% | 545.1 ± 0.7% | 3002.6 ± 0.5% | 602.4 ± 1.1% | 1.924 | 1.439 | 7.906 | 1.435 | 7.154 |
| string: silesia/reymont | 1075159 | 2994.4 ± 1.9% | 1819.3 ± 1.2% | 2068.0 ± 0.3% | 374.5 ± 1.4% | 2140.9 ± 0.8% | 536.6 ± 1.0% | 1.646 | 1.448 | 7.997 | 1.399 | 5.580 |
| string: silesia/samba | 97582 | 3505.6 ± 0.3% | 2026.1 ± 0.1% | 2623.7 ± 2.7% | 328.1 ± 0.5% | 1498.5 ± 0.6% | 429.2 ± 1.3% | 1.730 | 1.336 | 10.685 | 2.339 | 8.168 |
| string: silesia/webster | 1098490 | 3682.6 ± 0.3% | 1519.8 ± 0.2% | 2009.3 ± 0.5% | 358.8 ± 0.4% | 2187.6 ± 0.4% | 497.6 ± 1.3% | 2.423 | 1.833 | 10.263 | 1.683 | 7.400 |
| string: silesia/xml | 1090118 | 4805.0 ± 0.7% | 2360.8 ± 0.4% | 2531.1 ± 0.4% | 453.8 ± 0.9% | 2858.3 ± 1.2% | 568.9 ± 0.6% | 2.035 | 1.898 | 10.589 | 1.681 | 8.445 |
| string: canterbury/alice29.txt | 159425 | 4371.1 ± 2.0% | 1598.1 ± 0.7% | 2457.6 ± 0.6% | 341.2 ± 0.3% | 2500.2 ± 0.1% | 506.0 ± 0.5% | 2.735 | 1.779 | 12.812 | 1.748 | 8.639 |
| string: canterbury/asyoulik.txt | 132198 | 3498.1 ± 0.8% | 1459.7 ± 0.2% | 2245.3 ± 0.7% | 334.7 ± 0.3% | 2070.4 ± 0.4% | 457.3 ± 2.0% | 2.396 | 1.558 | 10.451 | 1.690 | 7.649 |
| string: canterbury/lcet10.txt | 441884 | 5132.9 ± 0.3% | 1854.3 ± 0.3% | 2321.8 ± 1.1% | 390.2 ± 0.4% | 2834.9 ± 0.7% | 533.9 ± 0.8% | 2.768 | 2.211 | 13.156 | 1.811 | 9.613 |
| string: canterbury/plrabn12.txt | 503330 | 4121.7 ± 0.7% | 1735.3 ± 0.2% | 2062.6 ± 0.5% | 360.7 ± 0.7% | 2486.4 ± 0.5% | 498.8 ± 1.0% | 2.375 | 1.998 | 11.427 | 1.658 | 8.263 |
| string: canterbury-large/E.coli | 1048578 | 11913.9 ± 0.4% | 3611.0 ± 0.4% | 3252.4 ± 0.4% | 927.0 ± 0.9% | 5972.9 ± 0.6% | 762.4 ± 1.3% | 3.299 | 3.663 | 12.852 | 1.995 | 15.627 |
| string: canterbury-large/bible.txt | 1055886 | 6904.0 ± 1.5% | 2938.0 ± 1.0% | 2846.7 ± 0.8% | 425.4 ± 1.0% | 3738.2 ± 0.6% | 616.8 ± 1.0% | 2.350 | 2.425 | 16.231 | 1.847 | 11.193 |
| string: canterbury-large/world192.txt | 1103121 | 3399.1 ± 0.5% | 1483.6 ± 0.2% | 2014.4 ± 0.3% | 352.6 ± 0.8% | 2127.0 ± 1.1% | 504.1 ± 0.8% | 2.291 | 1.687 | 9.641 | 1.598 | 6.743 |
| string: http/html-1m | 1058582 | 6253.3 ± 1.1% | 2739.0 ± 0.4% | 2705.3 ± 0.4% | 440.7 ± 0.7% | 3478.2 ± 0.8% | 597.7 ± 1.1% | 2.283 | 2.311 | 14.190 | 1.798 | 10.461 |
| string: http/json-1m | 1190272 | 2559.7 ± 0.3% | 877.2 ± 0.2% | 2257.2 ± 0.6% | 389.8 ± 0.4% | 1064.3 ± 0.7% | 443.8 ± 1.0% | 2.918 | 1.134 | 6.567 | 2.405 | 5.768 |
| string: http/js-1m | 1144362 | 2287.9 ± 0.3% | 1030.1 ± 0.4% | 1635.4 ± 0.5% | 320.3 ± 0.3% | 1522.4 ± 0.1% | 419.1 ± 0.3% | 2.221 | 1.399 | 7.144 | 1.503 | 5.459 |
| string: http/css-1m | 1097820 | 2660.3 ± 0.6% | 1678.3 ± 0.2% | 2229.1 ± 0.7% | 403.9 ± 1.6% | 1957.1 ± 0.7% | 489.7 ± 0.7% | 1.585 | 1.193 | 6.586 | 1.359 | 5.433 |
| string: dickens as Cyrillic and CJK | 1883069 | 3091.9 ± 0.3% | 1687.1 ± 0.3% | 896.0 ± 0.1% | 351.5 ± 0.1% | 670.0 ± 0.6% | 157.7 ± 2.0% | 1.833 | 3.451 | 8.796 | 4.615 | 19.605 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1331.8 ± 0.2% | 981.8 ± 0.3% | 1206.2 ± 0.3% | 215.9 ± 0.2% | 470.2 ± 1.1% | 253.9 ± 3.5% | 1.357 | 1.104 | 6.169 | 2.832 | 5.245 |
| hex: silesia/dickens | 524290 | 12017.4 ± 0.1% | 3623.8 ± 0.3% | 3301.6 ± 0.5% | 517.4 ± 1.3% | 6056.7 ± 1.2% | 780.7 ± 4.1% | 3.316 | 3.640 | 23.228 | 1.984 | 15.393 |
| hex: silesia/mozilla | 524290 | 12021.0 ± 0.2% | 3614.7 ± 0.2% | 3294.7 ± 0.3% | 458.8 ± 0.5% | 6066.9 ± 0.5% | 785.8 ± 1.2% | 3.326 | 3.649 | 26.200 | 1.981 | 15.298 |
| hex: silesia/mr | 524290 | 11976.9 ± 0.2% | 3614.5 ± 0.4% | 3284.9 ± 0.4% | 582.1 ± 2.1% | 6113.8 ± 0.9% | 782.1 ± 0.5% | 3.314 | 3.646 | 20.575 | 1.959 | 15.314 |
| hex: silesia/nci | 524290 | 11990.8 ± 0.1% | 3614.4 ± 0.1% | 3285.6 ± 0.3% | 629.1 ± 1.6% | 6040.3 ± 1.6% | 779.3 ± 0.7% | 3.317 | 3.649 | 19.060 | 1.985 | 15.386 |
| hex: silesia/ooffice | 524290 | 11996.6 ± 0.1% | 3619.7 ± 0.3% | 3288.9 ± 0.2% | 396.7 ± 1.7% | 6088.9 ± 1.5% | 781.7 ± 1.1% | 3.314 | 3.648 | 30.239 | 1.970 | 15.347 |
| hex: silesia/osdb | 524290 | 12002.3 ± 0.1% | 3617.5 ± 0.4% | 3290.3 ± 0.3% | 474.6 ± 1.6% | 6058.0 ± 0.7% | 781.3 ± 1.0% | 3.318 | 3.648 | 25.289 | 1.981 | 15.362 |
| hex: silesia/reymont | 524290 | 12002.5 ± 0.1% | 3619.3 ± 0.4% | 3293.3 ± 0.4% | 520.2 ± 0.2% | 6076.8 ± 0.7% | 784.8 ± 0.5% | 3.316 | 3.645 | 23.072 | 1.975 | 15.293 |
| hex: silesia/samba | 524290 | 11957.9 ± 0.3% | 3616.0 ± 1.1% | 3285.9 ± 0.4% | 408.0 ± 0.7% | 6006.2 ± 1.0% | 782.7 ± 0.6% | 3.307 | 3.639 | 29.309 | 1.991 | 15.278 |
| hex: silesia/sao | 524290 | 12014.6 ± 0.1% | 3617.8 ± 0.2% | 3288.1 ± 0.2% | 342.8 ± 0.6% | 6037.6 ± 0.6% | 782.8 ± 0.6% | 3.321 | 3.654 | 35.045 | 1.990 | 15.348 |
| hex: silesia/webster | 524290 | 11959.8 ± 0.1% | 3616.6 ± 0.1% | 3287.1 ± 0.4% | 469.7 ± 1.3% | 6076.0 ± 0.7% | 782.2 ± 0.8% | 3.307 | 3.638 | 25.464 | 1.968 | 15.290 |
| hex: silesia/x-ray | 524290 | 12002.9 ± 0.0% | 3616.9 ± 0.5% | 3300.6 ± 0.3% | 476.5 ± 0.4% | 6097.5 ± 1.2% | 783.4 ± 0.5% | 3.319 | 3.637 | 25.192 | 1.969 | 15.322 |
| hex: silesia/xml | 524290 | 11973.3 ± 0.3% | 3620.8 ± 0.3% | 3289.9 ± 0.6% | 516.5 ± 1.2% | 6049.9 ± 0.7% | 783.3 ± 0.6% | 3.307 | 3.639 | 23.182 | 1.979 | 15.286 |
| hex: canterbury/alice29.txt | 304180 | 11996.6 ± 0.1% | 3620.7 ± 0.2% | 3374.0 ± 0.1% | 510.2 ± 4.3% | 6093.7 ± 1.0% | 784.2 ± 0.6% | 3.313 | 3.556 | 23.513 | 1.969 | 15.297 |
| hex: canterbury/asyoulik.txt | 250360 | 12007.2 ± 0.0% | 3632.3 ± 0.1% | 3377.2 ± 0.1% | 515.5 ± 0.1% | 6089.2 ± 2.0% | 781.9 ± 0.4% | 3.306 | 3.555 | 23.291 | 1.972 | 15.357 |
| hex: canterbury/cp.html | 49208 | 11911.1 ± 0.0% | 3637.4 ± 0.1% | 3285.3 ± 0.3% | 469.5 ± 2.1% | 6270.6 ± 0.3% | 760.5 ± 2.3% | 3.275 | 3.626 | 25.371 | 1.900 | 15.662 |
| hex: canterbury/fields.c | 22302 | 11772.5 ± 0.5% | 3628.9 ± 0.1% | 3352.1 ± 0.1% | 496.1 ± 0.8% | 6262.2 ± 0.6% | 751.6 ± 2.3% | 3.244 | 3.512 | 23.731 | 1.880 | 15.663 |
| hex: canterbury/grammar.lsp | 7444 | 11259.4 ± 0.1% | 3601.6 ± 0.0% | 3345.4 ± 0.2% | 532.6 ± 2.1% | 6174.5 ± 0.2% | 720.3 ± 2.2% | 3.126 | 3.366 | 21.142 | 1.824 | 15.632 |
| hex: canterbury/kennedy.xls | 524290 | 11960.0 ± 0.1% | 3614.5 ± 0.2% | 3286.0 ± 0.2% | 653.9 ± 6.4% | 5988.2 ± 1.0% | 760.0 ± 5.0% | 3.309 | 3.640 | 18.291 | 1.997 | 15.738 |
| hex: canterbury/lcet10.txt | 524290 | 11993.1 ± 0.2% | 3613.5 ± 0.3% | 3293.3 ± 0.3% | 522.0 ± 1.6% | 6097.9 ± 0.3% | 771.8 ± 1.8% | 3.319 | 3.642 | 22.974 | 1.967 | 15.538 |
| hex: canterbury/plrabn12.txt | 524290 | 11977.7 ± 0.3% | 3610.7 ± 0.5% | 3286.0 ± 0.1% | 510.5 ± 0.5% | 6080.0 ± 0.4% | 767.5 ± 1.2% | 3.317 | 3.645 | 23.462 | 1.970 | 15.607 |
| hex: canterbury/ptt5 | 524290 | 11970.2 ± 0.3% | 3616.3 ± 0.4% | 3288.3 ± 0.2% | 553.0 ± 3.0% | 5992.2 ± 1.4% | 768.7 ± 1.5% | 3.310 | 3.640 | 21.644 | 1.998 | 15.571 |
| hex: canterbury/sum | 76482 | 11911.7 ± 0.1% | 3633.4 ± 0.0% | 3354.5 ± 0.1% | 509.8 ± 0.5% | 6157.6 ± 0.4% | 768.5 ± 1.2% | 3.278 | 3.551 | 23.364 | 1.934 | 15.500 |
| hex: canterbury/xargs.1 | 8456 | 11345.8 ± 0.1% | 3602.7 ± 0.0% | 3348.1 ± 0.5% | 487.1 ± 4.6% | 6147.2 ± 0.5% | 751.3 ± 1.1% | 3.149 | 3.389 | 23.292 | 1.846 | 15.101 |
| hex: canterbury-large/E.coli | 524290 | 11960.3 ± 0.2% | 3614.2 ± 0.3% | 3296.0 ± 0.1% | 688.5 ± 0.3% | 5967.5 ± 2.9% | 762.6 ± 1.5% | 3.309 | 3.629 | 17.371 | 2.004 | 15.683 |
| hex: canterbury-large/bible.txt | 524290 | 11963.4 ± 0.2% | 3615.0 ± 0.4% | 3287.6 ± 0.6% | 516.0 ± 1.3% | 5946.8 ± 0.9% | 766.5 ± 1.3% | 3.309 | 3.639 | 23.185 | 2.012 | 15.609 |
| hex: canterbury-large/world192.txt | 524290 | 11987.6 ± 0.1% | 3619.6 ± 0.2% | 3289.0 ± 0.2% | 495.5 ± 1.4% | 6067.9 ± 1.0% | 769.4 ± 2.9% | 3.312 | 3.645 | 24.191 | 1.976 | 15.580 |
| hex: http/html-1kx1024 | 2099200 | 8792.7 ± 2.2% | 3464.8 ± 0.1% | 2867.0 ± 0.8% | 472.7 ± 1.2% | 5160.0 ± 1.5% | 646.2 ± 2.5% | 2.538 | 3.067 | 18.601 | 1.704 | 13.607 |
| hex: http/html-16kx64 | 2097280 | 11771.7 ± 0.3% | 3607.9 ± 0.3% | 3249.6 ± 0.2% | 476.2 ± 1.1% | 6005.2 ± 0.6% | 754.7 ± 1.4% | 3.263 | 3.622 | 24.721 | 1.960 | 15.598 |
| hex: http/html-1m | 524290 | 11980.8 ± 0.5% | 3620.6 ± 0.3% | 3292.6 ± 0.2% | 499.6 ± 2.6% | 6037.9 ± 0.9% | 762.7 ± 2.3% | 3.309 | 3.639 | 23.981 | 1.984 | 15.708 |
| hex: http/json-1kx1024 | 2099200 | 8816.3 ± 4.0% | 3459.6 ± 0.2% | 2863.0 ± 0.4% | 575.9 ± 0.7% | 5135.6 ± 1.9% | 640.5 ± 3.2% | 2.548 | 3.079 | 15.308 | 1.717 | 13.765 |
| hex: http/json-16kx64 | 2097280 | 11765.3 ± 0.2% | 3604.7 ± 0.2% | 3257.6 ± 0.2% | 572.7 ± 0.5% | 6015.3 ± 0.6% | 749.6 ± 2.5% | 3.264 | 3.612 | 20.542 | 1.956 | 15.696 |
| hex: http/json-1m | 524290 | 11990.1 ± 0.2% | 3616.0 ± 0.2% | 3290.6 ± 0.3% | 587.0 ± 3.1% | 6065.1 ± 0.7% | 765.6 ± 4.0% | 3.316 | 3.644 | 20.426 | 1.977 | 15.661 |
| hex: http/js-1kx1024 | 2099200 | 8824.4 ± 3.7% | 3464.8 ± 0.1% | 2864.0 ± 0.4% | 480.3 ± 0.5% | 5109.1 ± 2.0% | 648.3 ± 0.9% | 2.547 | 3.081 | 18.371 | 1.727 | 13.612 |
| hex: http/js-16kx64 | 2097280 | 11782.4 ± 0.2% | 3609.5 ± 0.1% | 3265.2 ± 0.1% | 480.2 ± 2.6% | 6010.0 ± 0.6% | 756.1 ± 2.5% | 3.264 | 3.609 | 24.534 | 1.960 | 15.583 |
| hex: http/js-1m | 524290 | 11975.5 ± 0.1% | 3621.2 ± 0.2% | 3285.8 ± 0.3% | 498.4 ± 2.0% | 6019.0 ± 0.8% | 762.2 ± 1.7% | 3.307 | 3.645 | 24.029 | 1.990 | 15.712 |
| hex: http/css-1kx1024 | 2099200 | 8784.1 ± 4.4% | 3459.7 ± 0.2% | 2863.4 ± 0.3% | 489.0 ± 0.6% | 5090.9 ± 1.8% | 644.6 ± 4.1% | 2.539 | 3.068 | 17.963 | 1.725 | 13.628 |
| hex: http/css-16kx64 | 2097280 | 11767.8 ± 0.1% | 3611.7 ± 0.2% | 3272.4 ± 0.2% | 495.9 ± 0.6% | 6001.5 ± 0.2% | 746.2 ± 2.2% | 3.258 | 3.596 | 23.729 | 1.961 | 15.770 |
| hex: http/css-1m | 524290 | 12019.3 ± 0.1% | 3616.5 ± 0.5% | 3290.5 ± 0.4% | 496.2 ± 1.3% | 6091.3 ± 0.6% | 748.4 ± 0.7% | 3.323 | 3.653 | 24.222 | 1.973 | 16.060 |
| hex: shuffled/dickens-1m | 524290 | 11990.6 ± 0.1% | 3619.0 ± 0.1% | 3283.9 ± 0.3% | 514.0 ± 0.6% | 6016.3 ± 0.8% | 755.4 ± 0.9% | 3.313 | 3.651 | 23.327 | 1.993 | 15.874 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1012.2 ± 0.4% | 931.8 ± 0.5% | 1021.2 ± 0.2% | 300.9 ± 0.8% | 666.1 ± 0.2% | 309.2 ± 1.2% | 1.086 | 0.991 | 3.364 | 1.520 | 3.274 |
| qlog records, JSON text sequence | 1467503 | 841.3 ± 0.4% | 817.0 ± 0.2% | 784.9 ± 1.5% | 244.3 ± 1.1% | 698.2 ± 0.3% | 250.8 ± 0.3% | 1.030 | 1.072 | 3.444 | 1.205 | 3.354 |
| string: silesia/dickens | 172528 | 5054.4 ± 0.1% | 1877.6 ± 0.1% | 2648.8 ± 0.4% | 360.3 ± 1.1% | 2853.1 ± 0.3% | 550.6 ± 2.2% | 2.692 | 1.908 | 14.027 | 1.772 | 9.180 |
| string: silesia/nci | 1075110 | 4302.3 ± 0.3% | 2240.4 ± 0.4% | 2994.7 ± 0.1% | 545.1 ± 0.7% | 3002.6 ± 0.5% | 602.4 ± 1.1% | 1.920 | 1.437 | 7.893 | 1.433 | 7.142 |
| string: silesia/reymont | 1075159 | 3000.2 ± 1.6% | 1819.3 ± 1.2% | 2068.0 ± 0.3% | 374.5 ± 1.4% | 2140.9 ± 0.8% | 536.6 ± 1.0% | 1.649 | 1.451 | 8.012 | 1.401 | 5.591 |
| string: silesia/samba | 97582 | 3514.8 ± 0.3% | 2026.1 ± 0.1% | 2623.7 ± 2.7% | 328.1 ± 0.5% | 1498.5 ± 0.6% | 429.2 ± 1.3% | 1.735 | 1.340 | 10.713 | 2.346 | 8.189 |
| string: silesia/webster | 1098490 | 3682.9 ± 0.7% | 1519.8 ± 0.2% | 2009.3 ± 0.5% | 358.8 ± 0.4% | 2187.6 ± 0.4% | 497.6 ± 1.3% | 2.423 | 1.833 | 10.264 | 1.684 | 7.401 |
| string: silesia/xml | 1090118 | 4816.3 ± 0.9% | 2360.8 ± 0.4% | 2531.1 ± 0.4% | 453.8 ± 0.9% | 2858.3 ± 1.2% | 568.9 ± 0.6% | 2.040 | 1.903 | 10.614 | 1.685 | 8.465 |
| string: canterbury/alice29.txt | 159425 | 4373.9 ± 1.7% | 1598.1 ± 0.7% | 2457.6 ± 0.6% | 341.2 ± 0.3% | 2500.2 ± 0.1% | 506.0 ± 0.5% | 2.737 | 1.780 | 12.821 | 1.749 | 8.645 |
| string: canterbury/asyoulik.txt | 132198 | 3501.6 ± 0.6% | 1459.7 ± 0.2% | 2245.3 ± 0.7% | 334.7 ± 0.3% | 2070.4 ± 0.4% | 457.3 ± 2.0% | 2.399 | 1.560 | 10.462 | 1.691 | 7.657 |
| string: canterbury/lcet10.txt | 441884 | 5132.6 ± 0.3% | 1854.3 ± 0.3% | 2321.8 ± 1.1% | 390.2 ± 0.4% | 2834.9 ± 0.7% | 533.9 ± 0.8% | 2.768 | 2.211 | 13.155 | 1.811 | 9.613 |
| string: canterbury/plrabn12.txt | 503330 | 4123.2 ± 0.3% | 1735.3 ± 0.2% | 2062.6 ± 0.5% | 360.7 ± 0.7% | 2486.4 ± 0.5% | 498.8 ± 1.0% | 2.376 | 1.999 | 11.431 | 1.658 | 8.266 |
| string: canterbury-large/E.coli | 1048578 | 11925.6 ± 0.4% | 3611.0 ± 0.4% | 3252.4 ± 0.4% | 927.0 ± 0.9% | 5972.9 ± 0.6% | 762.4 ± 1.3% | 3.303 | 3.667 | 12.865 | 1.997 | 15.643 |
| string: canterbury-large/bible.txt | 1055886 | 6943.6 ± 1.2% | 2938.0 ± 1.0% | 2846.7 ± 0.8% | 425.4 ± 1.0% | 3738.2 ± 0.6% | 616.8 ± 1.0% | 2.363 | 2.439 | 16.324 | 1.857 | 11.257 |
| string: canterbury-large/world192.txt | 1103121 | 3396.8 ± 0.3% | 1483.6 ± 0.2% | 2014.4 ± 0.3% | 352.6 ± 0.8% | 2127.0 ± 1.1% | 504.1 ± 0.8% | 2.290 | 1.686 | 9.634 | 1.597 | 6.738 |
| string: http/html-1m | 1058582 | 6297.3 ± 1.2% | 2739.0 ± 0.4% | 2705.3 ± 0.4% | 440.7 ± 0.7% | 3478.2 ± 0.8% | 597.7 ± 1.1% | 2.299 | 2.328 | 14.290 | 1.811 | 10.535 |
| string: http/json-1m | 1190272 | 2558.4 ± 0.2% | 877.2 ± 0.2% | 2257.2 ± 0.6% | 389.8 ± 0.4% | 1064.3 ± 0.7% | 443.8 ± 1.0% | 2.917 | 1.133 | 6.563 | 2.404 | 5.765 |
| string: http/js-1m | 1144362 | 2288.9 ± 0.7% | 1030.1 ± 0.4% | 1635.4 ± 0.5% | 320.3 ± 0.3% | 1522.4 ± 0.1% | 419.1 ± 0.3% | 2.222 | 1.400 | 7.147 | 1.504 | 5.461 |
| string: http/css-1m | 1097820 | 2662.4 ± 0.7% | 1678.3 ± 0.2% | 2229.1 ± 0.7% | 403.9 ± 1.6% | 1957.1 ± 0.7% | 489.7 ± 0.7% | 1.586 | 1.194 | 6.592 | 1.360 | 5.437 |
| string: dickens as Cyrillic and CJK | 1883069 | 3085.2 ± 0.5% | 1687.1 ± 0.3% | 896.0 ± 0.1% | 351.5 ± 0.1% | 670.0 ± 0.6% | 157.7 ± 2.0% | 1.829 | 3.443 | 8.776 | 4.605 | 19.563 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.4 ± 0.3% | 981.8 ± 0.3% | 1206.2 ± 0.3% | 215.9 ± 0.2% | 470.2 ± 1.1% | 253.9 ± 3.5% | 1.355 | 1.103 | 6.163 | 2.829 | 5.240 |
| hex: silesia/dickens | 524290 | 12016.1 ± 0.1% | 3623.8 ± 0.3% | 3301.6 ± 0.5% | 517.4 ± 1.3% | 6056.7 ± 1.2% | 780.7 ± 4.1% | 3.316 | 3.639 | 23.226 | 1.984 | 15.391 |
| hex: silesia/mozilla | 524290 | 12017.5 ± 0.1% | 3614.7 ± 0.2% | 3294.7 ± 0.3% | 458.8 ± 0.5% | 6066.9 ± 0.5% | 785.8 ± 1.2% | 3.325 | 3.648 | 26.192 | 1.981 | 15.293 |
| hex: silesia/mr | 524290 | 11964.8 ± 0.2% | 3614.5 ± 0.4% | 3284.9 ± 0.4% | 582.1 ± 2.1% | 6113.8 ± 0.9% | 782.1 ± 0.5% | 3.310 | 3.642 | 20.554 | 1.957 | 15.299 |
| hex: silesia/nci | 524290 | 11993.4 ± 0.1% | 3614.4 ± 0.1% | 3285.6 ± 0.3% | 629.1 ± 1.6% | 6040.3 ± 1.6% | 779.3 ± 0.7% | 3.318 | 3.650 | 19.064 | 1.986 | 15.389 |
| hex: silesia/ooffice | 524290 | 12003.6 ± 0.3% | 3619.7 ± 0.3% | 3288.9 ± 0.2% | 396.7 ± 1.7% | 6088.9 ± 1.5% | 781.7 ± 1.1% | 3.316 | 3.650 | 30.257 | 1.971 | 15.356 |
| hex: silesia/osdb | 524290 | 11993.2 ± 0.1% | 3617.5 ± 0.4% | 3290.3 ± 0.3% | 474.6 ± 1.6% | 6058.0 ± 0.7% | 781.3 ± 1.0% | 3.315 | 3.645 | 25.270 | 1.980 | 15.351 |
| hex: silesia/reymont | 524290 | 12010.5 ± 0.0% | 3619.3 ± 0.4% | 3293.3 ± 0.4% | 520.2 ± 0.2% | 6076.8 ± 0.7% | 784.8 ± 0.5% | 3.318 | 3.647 | 23.088 | 1.976 | 15.303 |
| hex: silesia/samba | 524290 | 11937.7 ± 0.4% | 3616.0 ± 1.1% | 3285.9 ± 0.4% | 408.0 ± 0.7% | 6006.2 ± 1.0% | 782.7 ± 0.6% | 3.301 | 3.633 | 29.259 | 1.988 | 15.252 |
| hex: silesia/sao | 524290 | 12018.7 ± 0.1% | 3617.8 ± 0.2% | 3288.1 ± 0.2% | 342.8 ± 0.6% | 6037.6 ± 0.6% | 782.8 ± 0.6% | 3.322 | 3.655 | 35.057 | 1.991 | 15.353 |
| hex: silesia/webster | 524290 | 11957.5 ± 0.2% | 3616.6 ± 0.1% | 3287.1 ± 0.4% | 469.7 ± 1.3% | 6076.0 ± 0.7% | 782.2 ± 0.8% | 3.306 | 3.638 | 25.459 | 1.968 | 15.287 |
| hex: silesia/x-ray | 524290 | 12007.4 ± 0.1% | 3616.9 ± 0.5% | 3300.6 ± 0.3% | 476.5 ± 0.4% | 6097.5 ± 1.2% | 783.4 ± 0.5% | 3.320 | 3.638 | 25.201 | 1.969 | 15.328 |
| hex: silesia/xml | 524290 | 11958.7 ± 0.1% | 3620.8 ± 0.3% | 3289.9 ± 0.6% | 516.5 ± 1.2% | 6049.9 ± 0.7% | 783.3 ± 0.6% | 3.303 | 3.635 | 23.154 | 1.977 | 15.267 |
| hex: canterbury/alice29.txt | 304180 | 11993.3 ± 0.2% | 3620.7 ± 0.2% | 3374.0 ± 0.1% | 510.2 ± 4.3% | 6093.7 ± 1.0% | 784.2 ± 0.6% | 3.312 | 3.555 | 23.507 | 1.968 | 15.293 |
| hex: canterbury/asyoulik.txt | 250360 | 12005.7 ± 0.2% | 3632.3 ± 0.1% | 3377.2 ± 0.1% | 515.5 ± 0.1% | 6089.2 ± 2.0% | 781.9 ± 0.4% | 3.305 | 3.555 | 23.288 | 1.972 | 15.355 |
| hex: canterbury/cp.html | 49208 | 11911.4 ± 0.0% | 3637.4 ± 0.1% | 3285.3 ± 0.3% | 469.5 ± 2.1% | 6270.6 ± 0.3% | 760.5 ± 2.3% | 3.275 | 3.626 | 25.371 | 1.900 | 15.662 |
| hex: canterbury/fields.c | 22302 | 11783.4 ± 0.0% | 3628.9 ± 0.1% | 3352.1 ± 0.1% | 496.1 ± 0.8% | 6262.2 ± 0.6% | 751.6 ± 2.3% | 3.247 | 3.515 | 23.753 | 1.882 | 15.677 |
| hex: canterbury/grammar.lsp | 7444 | 11309.6 ± 0.5% | 3601.6 ± 0.0% | 3345.4 ± 0.2% | 532.6 ± 2.1% | 6174.5 ± 0.2% | 720.3 ± 2.2% | 3.140 | 3.381 | 21.236 | 1.832 | 15.702 |
| hex: canterbury/kennedy.xls | 524290 | 11962.0 ± 0.2% | 3614.5 ± 0.2% | 3286.0 ± 0.2% | 653.9 ± 6.4% | 5988.2 ± 1.0% | 760.0 ± 5.0% | 3.309 | 3.640 | 18.294 | 1.998 | 15.740 |
| hex: canterbury/lcet10.txt | 524290 | 12006.6 ± 0.2% | 3613.5 ± 0.3% | 3293.3 ± 0.3% | 522.0 ± 1.6% | 6097.9 ± 0.3% | 771.8 ± 1.8% | 3.323 | 3.646 | 23.000 | 1.969 | 15.556 |
| hex: canterbury/plrabn12.txt | 524290 | 11938.3 ± 0.2% | 3610.7 ± 0.5% | 3286.0 ± 0.1% | 510.5 ± 0.5% | 6080.0 ± 0.4% | 767.5 ± 1.2% | 3.306 | 3.633 | 23.385 | 1.964 | 15.556 |
| hex: canterbury/ptt5 | 524290 | 11982.3 ± 0.1% | 3616.3 ± 0.4% | 3288.3 ± 0.2% | 553.0 ± 3.0% | 5992.2 ± 1.4% | 768.7 ± 1.5% | 3.313 | 3.644 | 21.666 | 2.000 | 15.587 |
| hex: canterbury/sum | 76482 | 11911.6 ± 0.2% | 3633.4 ± 0.0% | 3354.5 ± 0.1% | 509.8 ± 0.5% | 6157.6 ± 0.4% | 768.5 ± 1.2% | 3.278 | 3.551 | 23.364 | 1.934 | 15.500 |
| hex: canterbury/xargs.1 | 8456 | 11351.9 ± 0.0% | 3602.7 ± 0.0% | 3348.1 ± 0.5% | 487.1 ± 4.6% | 6147.2 ± 0.5% | 751.3 ± 1.1% | 3.151 | 3.391 | 23.304 | 1.847 | 15.109 |
| hex: canterbury-large/E.coli | 524290 | 11966.0 ± 0.1% | 3614.2 ± 0.3% | 3296.0 ± 0.1% | 688.5 ± 0.3% | 5967.5 ± 2.9% | 762.6 ± 1.5% | 3.311 | 3.630 | 17.379 | 2.005 | 15.690 |
| hex: canterbury-large/bible.txt | 524290 | 11962.3 ± 0.3% | 3615.0 ± 0.4% | 3287.6 ± 0.6% | 516.0 ± 1.3% | 5946.8 ± 0.9% | 766.5 ± 1.3% | 3.309 | 3.639 | 23.183 | 2.012 | 15.607 |
| hex: canterbury-large/world192.txt | 524290 | 11987.5 ± 0.2% | 3619.6 ± 0.2% | 3289.0 ± 0.2% | 495.5 ± 1.4% | 6067.9 ± 1.0% | 769.4 ± 2.9% | 3.312 | 3.645 | 24.191 | 1.976 | 15.580 |
| hex: http/html-1kx1024 | 2099200 | 8875.7 ± 2.6% | 3464.8 ± 0.1% | 2867.0 ± 0.8% | 472.7 ± 1.2% | 5160.0 ± 1.5% | 646.2 ± 2.5% | 2.562 | 3.096 | 18.776 | 1.720 | 13.736 |
| hex: http/html-16kx64 | 2097280 | 11780.7 ± 0.3% | 3607.9 ± 0.3% | 3249.6 ± 0.2% | 476.2 ± 1.1% | 6005.2 ± 0.6% | 754.7 ± 1.4% | 3.265 | 3.625 | 24.740 | 1.962 | 15.610 |
| hex: http/html-1m | 524290 | 11981.9 ± 0.5% | 3620.6 ± 0.3% | 3292.6 ± 0.2% | 499.6 ± 2.6% | 6037.9 ± 0.9% | 762.7 ± 2.3% | 3.309 | 3.639 | 23.984 | 1.984 | 15.710 |
| hex: http/json-1kx1024 | 2099200 | 8879.9 ± 4.4% | 3459.6 ± 0.2% | 2863.0 ± 0.4% | 575.9 ± 0.7% | 5135.6 ± 1.9% | 640.5 ± 3.2% | 2.567 | 3.102 | 15.418 | 1.729 | 13.864 |
| hex: http/json-16kx64 | 2097280 | 11766.1 ± 0.2% | 3604.7 ± 0.2% | 3257.6 ± 0.2% | 572.7 ± 0.5% | 6015.3 ± 0.6% | 749.6 ± 2.5% | 3.264 | 3.612 | 20.544 | 1.956 | 15.697 |
| hex: http/json-1m | 524290 | 11998.3 ± 0.2% | 3616.0 ± 0.2% | 3290.6 ± 0.3% | 587.0 ± 3.1% | 6065.1 ± 0.7% | 765.6 ± 4.0% | 3.318 | 3.646 | 20.440 | 1.978 | 15.672 |
| hex: http/js-1kx1024 | 2099200 | 8899.8 ± 3.9% | 3464.8 ± 0.1% | 2864.0 ± 0.4% | 480.3 ± 0.5% | 5109.1 ± 2.0% | 648.3 ± 0.9% | 2.569 | 3.107 | 18.528 | 1.742 | 13.729 |
| hex: http/js-16kx64 | 2097280 | 11785.9 ± 0.1% | 3609.5 ± 0.1% | 3265.2 ± 0.1% | 480.2 ± 2.6% | 6010.0 ± 0.6% | 756.1 ± 2.5% | 3.265 | 3.610 | 24.542 | 1.961 | 15.588 |
| hex: http/js-1m | 524290 | 11974.5 ± 0.2% | 3621.2 ± 0.2% | 3285.8 ± 0.3% | 498.4 ± 2.0% | 6019.0 ± 0.8% | 762.2 ± 1.7% | 3.307 | 3.644 | 24.027 | 1.989 | 15.711 |
| hex: http/css-1kx1024 | 2099200 | 8819.7 ± 4.6% | 3459.7 ± 0.2% | 2863.4 ± 0.3% | 489.0 ± 0.6% | 5090.9 ± 1.8% | 644.6 ± 4.1% | 2.549 | 3.080 | 18.036 | 1.732 | 13.683 |
| hex: http/css-16kx64 | 2097280 | 11782.3 ± 0.1% | 3611.7 ± 0.2% | 3272.4 ± 0.2% | 495.9 ± 0.6% | 6001.5 ± 0.2% | 746.2 ± 2.2% | 3.262 | 3.601 | 23.758 | 1.963 | 15.789 |
| hex: http/css-1m | 524290 | 12026.2 ± 0.0% | 3616.5 ± 0.5% | 3290.5 ± 0.4% | 496.2 ± 1.3% | 6091.3 ± 0.6% | 748.4 ± 0.7% | 3.325 | 3.655 | 24.236 | 1.974 | 16.070 |
| hex: shuffled/dickens-1m | 524290 | 11992.3 ± 0.1% | 3619.0 ± 0.1% | 3283.9 ± 0.3% | 514.0 ± 0.6% | 6016.3 ± 0.8% | 755.4 ± 0.9% | 3.314 | 3.652 | 23.330 | 1.993 | 15.876 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1357.6 ± 0.7% | 1253.6 ± 0.8% | 1041.5 ± 0.6% | 410.3 ± 0.5% | 448.7 ± 0.4% | 414.8 ± 0.5% | 1.083 | 1.303 | 3.309 | 3.026 | 3.273 |
| qlog records, JSON text sequence | 1467503 | 1053.7 ± 0.2% | 1066.2 ± 0.6% | 788.8 ± 1.0% | 379.5 ± 0.5% | 468.0 ± 0.6% | 279.1 ± 0.6% | 0.988 | 1.336 | 2.776 | 2.252 | 3.776 |
| string: silesia/dickens | 172528 | 6913.7 ± 0.3% | 2816.1 ± 0.3% | 2929.0 ± 0.8% | 429.8 ± 0.7% | 1595.2 ± 0.4% | 1009.4 ± 0.2% | 2.455 | 2.360 | 16.087 | 4.334 | 6.849 |
| string: silesia/nci | 1075110 | 7311.2 ± 0.5% | 3389.8 ± 1.0% | 3097.0 ± 0.6% | 814.3 ± 1.3% | 1861.4 ± 0.4% | 1108.6 ± 0.3% | 2.157 | 2.361 | 8.978 | 3.928 | 6.595 |
| string: silesia/reymont | 1075159 | 3349.7 ± 1.1% | 1981.7 ± 1.6% | 2062.8 ± 0.4% | 449.8 ± 0.6% | 1510.7 ± 1.7% | 951.1 ± 0.5% | 1.690 | 1.624 | 7.448 | 2.217 | 3.522 |
| string: silesia/samba | 97582 | 4208.2 ± 0.8% | 2115.8 ± 0.3% | 3455.8 ± 0.3% | 353.3 ± 0.7% | 1436.1 ± 0.6% | 1053.8 ± 0.3% | 1.989 | 1.218 | 11.911 | 2.930 | 3.993 |
| string: silesia/webster | 1098490 | 4082.4 ± 0.3% | 1877.3 ± 0.6% | 2055.5 ± 0.7% | 440.4 ± 0.3% | 1394.7 ± 0.4% | 645.7 ± 0.4% | 2.175 | 1.986 | 9.271 | 2.927 | 6.322 |
| string: silesia/xml | 1090118 | 6144.9 ± 0.9% | 2864.2 ± 0.8% | 2651.9 ± 1.6% | 610.7 ± 1.0% | 1753.8 ± 0.4% | 921.4 ± 0.5% | 2.145 | 2.317 | 10.062 | 3.504 | 6.669 |
| string: canterbury/alice29.txt | 159425 | 6481.1 ± 0.8% | 2198.9 ± 0.9% | 2765.6 ± 0.6% | 407.2 ± 1.2% | 1480.0 ± 0.3% | 953.5 ± 0.2% | 2.947 | 2.344 | 15.915 | 4.379 | 6.797 |
| string: canterbury/asyoulik.txt | 132198 | 5670.2 ± 1.6% | 1718.4 ± 0.6% | 2362.4 ± 1.1% | 401.8 ± 0.6% | 1348.4 ± 0.9% | 883.1 ± 0.2% | 3.300 | 2.400 | 14.110 | 4.205 | 6.421 |
| string: canterbury/lcet10.txt | 441884 | 6256.7 ± 0.7% | 2552.1 ± 0.4% | 2494.4 ± 2.4% | 465.6 ± 0.6% | 1535.4 ± 0.3% | 985.8 ± 0.6% | 2.452 | 2.508 | 13.437 | 4.075 | 6.347 |
| string: canterbury/plrabn12.txt | 503330 | 5710.9 ± 0.5% | 2049.9 ± 0.2% | 2072.8 ± 0.5% | 422.6 ± 0.6% | 1430.2 ± 0.4% | 932.6 ± 0.7% | 2.786 | 2.755 | 13.514 | 3.993 | 6.124 |
| string: canterbury-large/E.coli | 1048578 | 19294.1 ± 0.6% | 9705.7 ± 0.8% | 3786.5 ± 0.7% | 1475.7 ± 0.3% | 2367.6 ± 0.6% | 1194.4 ± 0.4% | 1.988 | 5.096 | 13.074 | 8.149 | 16.154 |
| string: canterbury-large/bible.txt | 1055886 | 6804.4 ± 0.4% | 4142.0 ± 1.1% | 3019.2 ± 1.5% | 505.1 ± 0.6% | 1966.0 ± 0.3% | 1121.4 ± 0.6% | 1.643 | 2.254 | 13.472 | 3.461 | 6.068 |
| string: canterbury-large/world192.txt | 1103121 | 4065.2 ± 0.5% | 1653.7 ± 0.3% | 2000.6 ± 0.3% | 447.5 ± 0.5% | 1360.7 ± 0.4% | 909.3 ± 0.1% | 2.458 | 2.032 | 9.085 | 2.988 | 4.471 |
| string: http/html-1m | 1058582 | 6783.1 ± 0.0% | 3974.1 ± 0.5% | 3038.9 ± 0.7% | 499.9 ± 0.8% | 1917.6 ± 0.2% | 806.5 ± 0.5% | 1.707 | 2.232 | 13.569 | 3.537 | 8.411 |
| string: http/json-1m | 1190272 | 3168.5 ± 0.4% | 1348.5 ± 0.6% | 1556.1 ± 0.5% | 443.1 ± 1.0% | 961.9 ± 0.3% | 764.6 ± 1.3% | 2.350 | 2.036 | 7.152 | 3.294 | 4.144 |
| string: http/js-1m | 1144362 | 2777.8 ± 0.7% | 1180.0 ± 0.2% | 1626.9 ± 0.2% | 368.0 ± 0.4% | 1095.9 ± 0.4% | 758.1 ± 0.3% | 2.354 | 1.707 | 7.549 | 2.535 | 3.664 |
| string: http/css-1m | 1097820 | 4008.1 ± 1.1% | 1486.5 ± 0.5% | 2151.0 ± 1.2% | 493.0 ± 0.4% | 1369.6 ± 0.2% | 895.9 ± 0.4% | 2.696 | 1.863 | 8.131 | 2.926 | 4.474 |
| string: dickens as Cyrillic and CJK | 1883069 | 3079.1 ± 0.3% | 2348.7 ± 0.7% | 520.5 ± 0.5% | 308.1 ± 0.4% | 559.3 ± 0.8% | 336.6 ± 0.3% | 1.311 | 5.915 | 9.993 | 5.506 | 9.147 |
| hex: silesia/dickens | 524290 | 15614.0 ± 0.3% | 1464.6 ± 0.5% | 1082.7 ± 0.7% | 500.4 ± 0.8% | 989.3 ± 0.4% | 734.0 ± 0.9% | 10.661 | 14.421 | 31.201 | 15.783 | 21.274 |
| hex: silesia/mozilla | 524290 | 15664.6 ± 0.2% | 1467.3 ± 0.6% | 1089.2 ± 0.5% | 442.2 ± 0.7% | 991.8 ± 0.6% | 736.5 ± 0.3% | 10.676 | 14.382 | 35.425 | 15.794 | 21.269 |
| hex: silesia/mr | 524290 | 15627.5 ± 0.4% | 1483.6 ± 0.3% | 1094.4 ± 0.3% | 542.9 ± 3.7% | 997.4 ± 0.5% | 735.6 ± 0.2% | 10.534 | 14.280 | 28.786 | 15.668 | 21.244 |
| hex: silesia/nci | 524290 | 15697.8 ± 0.1% | 1472.8 ± 0.4% | 1088.9 ± 0.6% | 637.0 ± 4.0% | 991.1 ± 0.4% | 734.9 ± 0.4% | 10.658 | 14.417 | 24.643 | 15.838 | 21.361 |
| hex: silesia/ooffice | 524290 | 15632.2 ± 0.1% | 1466.7 ± 0.2% | 1085.2 ± 0.6% | 388.6 ± 0.2% | 992.0 ± 0.9% | 735.5 ± 0.6% | 10.658 | 14.405 | 40.227 | 15.758 | 21.255 |
| hex: silesia/osdb | 524290 | 15661.5 ± 0.2% | 1466.3 ± 0.4% | 1086.5 ± 0.4% | 468.2 ± 0.6% | 989.1 ± 0.6% | 736.4 ± 0.5% | 10.681 | 14.414 | 33.453 | 15.834 | 21.269 |
| hex: silesia/reymont | 524290 | 15685.4 ± 0.3% | 1463.7 ± 0.5% | 1085.2 ± 0.4% | 513.3 ± 2.1% | 989.7 ± 1.0% | 735.0 ± 0.8% | 10.717 | 14.454 | 30.555 | 15.848 | 21.340 |
| hex: silesia/samba | 524290 | 15585.4 ± 0.8% | 1465.4 ± 0.4% | 1085.9 ± 0.5% | 402.1 ± 0.5% | 991.5 ± 0.8% | 736.4 ± 0.6% | 10.636 | 14.353 | 38.758 | 15.719 | 21.163 |
| hex: silesia/sao | 524290 | 15642.0 ± 0.2% | 1465.8 ± 0.4% | 1085.6 ± 0.5% | 332.7 ± 0.1% | 990.0 ± 0.4% | 733.9 ± 0.6% | 10.671 | 14.409 | 47.014 | 15.801 | 21.312 |
| hex: silesia/webster | 524290 | 15687.8 ± 0.2% | 1465.1 ± 0.3% | 1086.7 ± 0.5% | 474.4 ± 0.5% | 991.7 ± 0.4% | 736.2 ± 0.6% | 10.707 | 14.437 | 33.070 | 15.819 | 21.310 |
| hex: silesia/x-ray | 524290 | 15652.4 ± 0.4% | 1474.9 ± 0.1% | 1092.9 ± 0.5% | 447.2 ± 1.5% | 993.0 ± 0.8% | 736.0 ± 0.4% | 10.612 | 14.322 | 35.001 | 15.763 | 21.266 |
| hex: silesia/xml | 524290 | 15626.8 ± 0.4% | 1468.1 ± 0.1% | 1088.3 ± 0.4% | 615.8 ± 1.4% | 992.1 ± 0.5% | 735.1 ± 0.4% | 10.644 | 14.359 | 25.376 | 15.752 | 21.257 |
| hex: canterbury/alice29.txt | 304180 | 15681.9 ± 0.1% | 1469.8 ± 0.6% | 1092.4 ± 0.6% | 503.9 ± 0.3% | 995.1 ± 0.8% | 735.3 ± 0.6% | 10.670 | 14.356 | 31.118 | 15.759 | 21.326 |
| hex: canterbury/asyoulik.txt | 250360 | 15668.9 ± 0.1% | 1470.7 ± 0.4% | 1093.6 ± 0.4% | 496.8 ± 0.6% | 994.3 ± 0.9% | 741.4 ± 0.2% | 10.654 | 14.328 | 31.542 | 15.759 | 21.136 |
| hex: canterbury/cp.html | 49208 | 15666.9 ± 0.1% | 1475.2 ± 0.4% | 1097.6 ± 0.1% | 530.2 ± 2.9% | 1001.6 ± 0.6% | 742.1 ± 0.2% | 10.620 | 14.274 | 29.552 | 15.642 | 21.111 |
| hex: canterbury/fields.c | 22302 | 15515.1 ± 0.0% | 1440.6 ± 0.7% | 1066.0 ± 0.2% | 626.7 ± 8.0% | 990.6 ± 0.1% | 735.3 ± 0.1% | 10.770 | 14.555 | 24.758 | 15.662 | 21.102 |
| hex: canterbury/grammar.lsp | 7444 | 15150.9 ± 0.1% | 1488.2 ± 0.1% | 1093.7 ± 0.4% | 659.6 ± 3.2% | 996.9 ± 0.3% | 725.8 ± 0.2% | 10.180 | 13.853 | 22.969 | 15.198 | 20.876 |
| hex: canterbury/kennedy.xls | 524290 | 15646.7 ± 0.2% | 1473.2 ± 0.4% | 1089.1 ± 0.3% | 654.7 ± 2.1% | 992.5 ± 0.6% | 733.3 ± 0.7% | 10.621 | 14.366 | 23.899 | 15.764 | 21.337 |
| hex: canterbury/lcet10.txt | 524290 | 15657.9 ± 0.2% | 1459.3 ± 0.6% | 1083.6 ± 0.2% | 501.3 ± 1.6% | 989.4 ± 0.7% | 735.6 ± 0.6% | 10.730 | 14.449 | 31.232 | 15.826 | 21.286 |
| hex: canterbury/plrabn12.txt | 524290 | 15653.3 ± 0.3% | 1464.3 ± 0.4% | 1082.4 ± 0.2% | 495.8 ± 0.4% | 990.6 ± 0.2% | 734.3 ± 0.4% | 10.690 | 14.462 | 31.570 | 15.802 | 21.318 |
| hex: canterbury/ptt5 | 524290 | 15610.5 ± 0.2% | 1478.9 ± 0.3% | 1092.6 ± 0.5% | 555.5 ± 0.5% | 993.2 ± 0.3% | 734.8 ± 0.7% | 10.555 | 14.288 | 28.100 | 15.717 | 21.246 |
| hex: canterbury/sum | 76482 | 15675.3 ± 0.1% | 1495.6 ± 0.2% | 1105.1 ± 0.2% | 596.2 ± 2.8% | 998.3 ± 0.2% | 743.8 ± 0.1% | 10.481 | 14.184 | 26.292 | 15.702 | 21.076 |
| hex: canterbury/xargs.1 | 8456 | 15199.8 ± 0.1% | 1432.4 ± 1.0% | 1068.8 ± 0.2% | 662.9 ± 4.5% | 1003.4 ± 0.3% | 727.9 ± 0.5% | 10.611 | 14.222 | 22.931 | 15.148 | 20.882 |
| hex: canterbury-large/E.coli | 524290 | 15651.5 ± 0.3% | 1475.1 ± 0.4% | 1090.0 ± 0.3% | 671.4 ± 0.2% | 993.4 ± 1.0% | 734.7 ± 0.5% | 10.610 | 14.359 | 23.311 | 15.755 | 21.303 |
| hex: canterbury-large/bible.txt | 524290 | 15640.4 ± 0.2% | 1463.2 ± 0.2% | 1088.1 ± 0.2% | 514.6 ± 1.0% | 986.4 ± 0.6% | 735.4 ± 0.9% | 10.689 | 14.374 | 30.395 | 15.856 | 21.269 |
| hex: canterbury-large/world192.txt | 524290 | 15581.6 ± 0.3% | 1466.8 ± 0.3% | 1085.0 ± 0.4% | 503.6 ± 0.5% | 990.2 ± 0.5% | 735.3 ± 0.6% | 10.623 | 14.361 | 30.940 | 15.736 | 21.191 |
| hex: http/html-1kx1024 | 2099200 | 14184.1 ± 0.4% | 1454.0 ± 0.1% | 1060.8 ± 0.2% | 502.1 ± 0.6% | 982.0 ± 0.1% | 692.5 ± 0.1% | 9.755 | 13.371 | 28.250 | 14.444 | 20.483 |
| hex: http/html-16kx64 | 2097280 | 15440.9 ± 0.2% | 1445.7 ± 0.2% | 1073.4 ± 0.4% | 506.4 ± 0.3% | 996.0 ± 0.1% | 734.9 ± 0.1% | 10.680 | 14.385 | 30.493 | 15.503 | 21.010 |
| hex: http/html-1m | 524290 | 15661.6 ± 0.2% | 1469.1 ± 0.4% | 1086.4 ± 0.5% | 500.8 ± 0.2% | 992.2 ± 0.6% | 735.0 ± 0.6% | 10.661 | 14.416 | 31.276 | 15.785 | 21.307 |
| hex: http/json-1kx1024 | 2099200 | 14162.7 ± 0.6% | 1462.8 ± 0.2% | 1066.3 ± 0.2% | 609.0 ± 0.4% | 986.0 ± 0.3% | 692.3 ± 0.1% | 9.682 | 13.282 | 23.254 | 14.364 | 20.457 |
| hex: http/json-16kx64 | 2097280 | 15440.3 ± 0.6% | 1445.6 ± 0.1% | 1074.9 ± 0.2% | 617.4 ± 0.4% | 996.7 ± 0.2% | 735.3 ± 0.3% | 10.681 | 14.364 | 25.008 | 15.492 | 21.000 |
| hex: http/json-1m | 524290 | 15662.9 ± 0.3% | 1474.9 ± 0.4% | 1089.7 ± 0.5% | 631.5 ± 1.4% | 992.8 ± 0.6% | 735.2 ± 0.6% | 10.620 | 14.373 | 24.802 | 15.777 | 21.304 |
| hex: http/js-1kx1024 | 2099200 | 14190.6 ± 0.7% | 1452.9 ± 0.1% | 1062.4 ± 0.2% | 499.3 ± 0.5% | 982.6 ± 0.1% | 692.3 ± 0.1% | 9.767 | 13.357 | 28.422 | 14.442 | 20.499 |
| hex: http/js-16kx64 | 2097280 | 15366.8 ± 0.4% | 1444.0 ± 0.1% | 1075.2 ± 0.2% | 504.4 ± 0.6% | 998.2 ± 0.3% | 734.2 ± 0.3% | 10.642 | 14.293 | 30.465 | 15.394 | 20.931 |
| hex: http/js-1m | 524290 | 15617.5 ± 0.1% | 1465.2 ± 0.3% | 1085.6 ± 0.3% | 511.8 ± 0.5% | 991.5 ± 0.7% | 735.4 ± 0.6% | 10.659 | 14.387 | 30.517 | 15.751 | 21.237 |
| hex: http/css-1kx1024 | 2099200 | 14155.9 ± 0.5% | 1454.1 ± 0.2% | 1062.6 ± 0.2% | 530.8 ± 0.4% | 982.5 ± 0.6% | 692.5 ± 0.3% | 9.735 | 13.322 | 26.671 | 14.408 | 20.442 |
| hex: http/css-16kx64 | 2097280 | 15391.3 ± 0.2% | 1444.1 ± 0.2% | 1073.4 ± 0.3% | 540.9 ± 0.4% | 999.9 ± 0.3% | 734.9 ± 0.1% | 10.658 | 14.338 | 28.455 | 15.393 | 20.943 |
| hex: http/css-1m | 524290 | 15708.5 ± 0.2% | 1461.9 ± 0.1% | 1084.0 ± 0.7% | 527.8 ± 0.5% | 989.3 ± 0.5% | 735.7 ± 0.2% | 10.745 | 14.491 | 29.763 | 15.878 | 21.352 |
| hex: shuffled/dickens-1m | 524290 | 15683.1 ± 0.1% | 1465.3 ± 0.3% | 1086.2 ± 0.7% | 503.7 ± 0.5% | 987.1 ± 0.6% | 736.5 ± 0.7% | 10.703 | 14.438 | 31.137 | 15.888 | 21.295 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.916 of yyjson.
