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
| Run URL | https://github.com/c4milo/stdx/actions/runs/43616680590 |
| Date | 2026-11-14 |


## Decoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextReader.next` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The `TextReader.next_items` column is that helper's queued tokens a slice a call (decision 79), over many tokens a call.

| Workload | Octets | All on, MB/s | J3 decoder string vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J8 decoder fast path off | J10 decoder token loop off | J12 decoder escape words off | J13 decoder escape blocks off | One token a call | TextReader.next | TextReader.next_items | All off |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1130.1 ± 0.7% | 0.522 | 0.963 | 0.994 | 0.995 | 0.459 | 0.999 | 1.004 | 0.386 | 0.829 | 0.897 | 0.100 |
| qlog records, JSON text sequence | 1467503 | 846.4 ± 0.8% | 0.816 | 0.997 | 1.000 | 0.998 | 0.448 | 0.997 | 1.027 | 0.398 | 0.924 | 0.988 | 0.125 |
| string: silesia/dickens | 172528 | 5032.0 ± 0.5% | 0.033 | 0.784 | 1.005 | 1.006 | 0.197 | 1.022 | 1.010 | 0.196 | 1.004 | 1.005 | 0.033 |
| string: silesia/nci | 1075110 | 4297.2 ± 0.9% | 0.039 | 0.803 | 1.004 | 1.003 | 0.280 | 1.005 | 0.997 | 0.279 | 1.002 | 1.002 | 0.038 |
| string: silesia/reymont | 1075159 | 2940.4 ± 1.7% | 0.057 | 0.806 | 1.005 | 1.007 | 0.358 | 1.009 | 1.011 | 0.358 | 1.027 | 1.026 | 0.056 |
| string: silesia/samba | 97582 | 3490.8 ± 0.6% | 0.040 | 0.863 | 1.004 | 1.005 | 0.069 | 0.779 | 1.012 | 0.073 | 1.002 | 1.005 | 0.039 |
| string: silesia/webster | 1098490 | 3638.0 ± 0.7% | 0.044 | 0.848 | 1.005 | 1.006 | 0.203 | 1.019 | 1.014 | 0.203 | 1.011 | 1.009 | 0.044 |
| string: silesia/xml | 1090118 | 4777.2 ± 0.3% | 0.035 | 0.808 | 1.007 | 1.008 | 0.222 | 0.979 | 1.005 | 0.225 | 1.006 | 1.006 | 0.034 |
| string: canterbury/alice29.txt | 159425 | 4300.8 ± 0.6% | 0.038 | 0.753 | 1.008 | 1.012 | 0.172 | 1.040 | 1.017 | 0.171 | 1.009 | 1.014 | 0.037 |
| string: canterbury/asyoulik.txt | 132198 | 3447.6 ± 1.0% | 0.046 | 0.750 | 1.009 | 1.012 | 0.177 | 1.007 | 0.975 | 0.176 | 1.014 | 1.016 | 0.045 |
| string: canterbury/lcet10.txt | 441884 | 5130.3 ± 0.3% | 0.032 | 0.810 | 1.002 | 1.002 | 0.194 | 1.016 | 1.005 | 0.194 | 1.001 | 1.000 | 0.032 |
| string: canterbury/plrabn12.txt | 503330 | 4125.7 ± 0.6% | 0.040 | 0.822 | 1.003 | 1.002 | 0.198 | 1.011 | 0.994 | 0.197 | 1.005 | 1.003 | 0.039 |
| string: canterbury-large/E.coli | 1048578 | 19077.3 ± 1.5% | 0.077 | 1.008 | 1.005 | 1.002 | 0.479 | 1.006 | 1.010 | 0.477 | 0.625 | 0.625 | 0.009 |
| string: canterbury-large/bible.txt | 1055886 | 6691.9 ± 1.1% | 0.026 | 0.800 | 1.004 | 1.009 | 0.432 | 1.031 | 1.039 | 0.432 | 1.033 | 1.035 | 0.025 |
| string: canterbury-large/world192.txt | 1103121 | 3381.8 ± 0.5% | 0.048 | 0.844 | 1.003 | 1.004 | 0.197 | 1.015 | 1.007 | 0.198 | 1.004 | 1.004 | 0.047 |
| string: http/html-1m | 1058582 | 6039.1 ± 1.2% | 0.028 | 0.784 | 1.023 | 1.041 | 0.390 | 1.043 | 1.055 | 0.390 | 1.027 | 1.031 | 0.028 |
| string: http/json-1m | 1190272 | 2546.1 ± 0.6% | 0.055 | 0.953 | 1.002 | 1.002 | 0.111 | 1.006 | 0.472 | 0.111 | 1.002 | 1.003 | 0.055 |
| string: http/js-1m | 1144362 | 2280.9 ± 0.4% | 0.066 | 0.891 | 1.001 | 1.002 | 0.174 | 1.055 | 1.046 | 0.174 | 1.000 | 1.000 | 0.065 |
| string: http/css-1m | 1097820 | 2633.8 ± 0.4% | 0.060 | 0.776 | 1.005 | 1.010 | 0.241 | 1.010 | 1.017 | 0.240 | 1.009 | 1.008 | 0.060 |
| string: dickens as Cyrillic and CJK | 1883069 | 3075.5 ± 0.5% | 0.044 | 0.124 | 1.002 | 1.000 | 0.335 | 0.999 | 1.004 | 0.335 | 1.000 | 1.000 | 0.044 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.9 ± 1.9% | 0.081 | 1.003 | 1.001 | 1.001 | 0.076 | 0.637 | 1.002 | 0.081 | 1.001 | 1.002 | 0.081 |
| hex: silesia/dickens | 524290 | 18568.2 ± 1.4% | 0.080 | 1.014 | 0.999 | 0.989 | 0.508 | 0.988 | 0.995 | 0.511 | 0.644 | 0.644 | 0.009 |
| hex: silesia/mozilla | 524290 | 18418.2 ± 1.7% | 0.081 | 1.009 | 0.995 | 0.994 | 0.519 | 1.002 | 0.995 | 0.516 | 0.652 | 0.652 | 0.009 |
| hex: silesia/mr | 524290 | 18167.8 ± 0.6% | 0.082 | 1.005 | 1.006 | 1.003 | 0.530 | 1.001 | 1.002 | 0.532 | 0.661 | 0.661 | 0.010 |
| hex: silesia/nci | 524290 | 18529.2 ± 1.3% | 0.080 | 1.016 | 0.999 | 0.995 | 0.509 | 0.996 | 0.992 | 0.512 | 0.647 | 0.646 | 0.009 |
| hex: silesia/ooffice | 524290 | 18483.4 ± 0.9% | 0.080 | 1.012 | 0.997 | 0.993 | 0.510 | 0.995 | 0.994 | 0.507 | 0.648 | 0.648 | 0.009 |
| hex: silesia/osdb | 524290 | 18224.7 ± 0.7% | 0.082 | 1.003 | 0.998 | 1.002 | 0.530 | 1.001 | 1.002 | 0.531 | 0.658 | 0.659 | 0.009 |
| hex: silesia/reymont | 524290 | 18728.4 ± 1.3% | 0.079 | 0.999 | 0.990 | 0.988 | 0.512 | 0.979 | 0.987 | 0.516 | 0.640 | 0.636 | 0.009 |
| hex: silesia/samba | 524290 | 17885.5 ± 0.8% | 0.083 | 1.003 | 1.003 | 1.000 | 0.541 | 1.001 | 1.005 | 0.540 | 0.670 | 0.671 | 0.010 |
| hex: silesia/sao | 524290 | 18603.7 ± 2.1% | 0.080 | 1.014 | 1.008 | 1.001 | 0.508 | 1.009 | 1.002 | 0.511 | 0.645 | 0.645 | 0.009 |
| hex: silesia/webster | 524290 | 18396.2 ± 1.0% | 0.081 | 1.017 | 1.002 | 1.000 | 0.533 | 1.000 | 1.005 | 0.533 | 0.652 | 0.653 | 0.009 |
| hex: silesia/x-ray | 524290 | 18679.0 ± 0.9% | 0.080 | 1.002 | 0.998 | 0.995 | 0.510 | 0.996 | 1.000 | 0.509 | 0.641 | 0.641 | 0.009 |
| hex: silesia/xml | 524290 | 18372.8 ± 1.2% | 0.081 | 1.002 | 0.994 | 0.997 | 0.518 | 0.996 | 0.997 | 0.521 | 0.652 | 0.652 | 0.009 |
| hex: canterbury/alice29.txt | 304180 | 19043.0 ± 0.6% | 0.079 | 1.007 | 1.002 | 1.000 | 0.522 | 1.001 | 1.000 | 0.520 | 0.631 | 0.631 | 0.009 |
| hex: canterbury/asyoulik.txt | 250360 | 19544.8 ± 0.1% | 0.077 | 0.997 | 1.003 | 1.003 | 0.514 | 1.002 | 1.002 | 0.514 | 0.614 | 0.614 | 0.009 |
| hex: canterbury/cp.html | 49208 | 19293.0 ± 0.4% | 0.078 | 1.002 | 1.000 | 1.000 | 0.542 | 1.000 | 1.001 | 0.542 | 0.618 | 0.618 | 0.009 |
| hex: canterbury/fields.c | 22302 | 18875.7 ± 0.8% | 0.081 | 1.004 | 1.005 | 1.005 | 0.535 | 1.004 | 1.005 | 0.540 | 0.624 | 0.624 | 0.009 |
| hex: canterbury/grammar.lsp | 7444 | 17529.3 ± 0.6% | 0.089 | 1.003 | 1.003 | 1.003 | 0.525 | 1.002 | 1.003 | 0.544 | 0.642 | 0.645 | 0.010 |
| hex: canterbury/kennedy.xls | 524290 | 18428.4 ± 1.7% | 0.081 | 1.013 | 0.994 | 0.994 | 0.519 | 1.009 | 0.997 | 0.521 | 0.649 | 0.649 | 0.009 |
| hex: canterbury/lcet10.txt | 524290 | 18488.3 ± 1.2% | 0.081 | 0.998 | 0.994 | 0.996 | 0.523 | 1.000 | 1.002 | 0.525 | 0.650 | 0.650 | 0.009 |
| hex: canterbury/plrabn12.txt | 524290 | 18094.7 ± 1.4% | 0.082 | 1.005 | 1.000 | 0.998 | 0.533 | 1.001 | 0.997 | 0.532 | 0.663 | 0.663 | 0.010 |
| hex: canterbury/ptt5 | 524290 | 18349.2 ± 1.7% | 0.081 | 1.006 | 1.000 | 1.001 | 0.512 | 0.998 | 0.997 | 0.513 | 0.651 | 0.651 | 0.009 |
| hex: canterbury/sum | 76482 | 19292.2 ± 0.2% | 0.078 | 1.002 | 1.002 | 1.002 | 0.518 | 1.002 | 1.002 | 0.520 | 0.617 | 0.617 | 0.009 |
| hex: canterbury/xargs.1 | 8456 | 17807.2 ± 0.6% | 0.086 | 1.001 | 1.002 | 1.002 | 0.524 | 1.000 | 1.001 | 0.540 | 0.636 | 0.637 | 0.010 |
| hex: canterbury-large/E.coli | 524290 | 18020.6 ± 0.8% | 0.082 | 1.008 | 0.998 | 0.997 | 0.519 | 1.003 | 1.003 | 0.521 | 0.663 | 0.664 | 0.010 |
| hex: canterbury-large/bible.txt | 524290 | 18528.1 ± 1.4% | 0.080 | 0.995 | 0.994 | 0.995 | 0.511 | 0.993 | 0.991 | 0.513 | 0.647 | 0.647 | 0.009 |
| hex: canterbury-large/world192.txt | 524290 | 17735.3 ± 0.8% | 0.084 | 1.008 | 1.004 | 1.002 | 0.541 | 1.006 | 1.005 | 0.542 | 0.677 | 0.677 | 0.010 |
| hex: http/html-1kx1024 | 2099200 | 9110.9 ± 19.6% | 0.155 | 1.263 | 1.260 | 1.249 | 0.712 | 1.268 | 0.959 | 0.766 | 0.940 | 0.942 | 0.019 |
| hex: http/html-16kx64 | 2097280 | 17493.8 ± 1.5% | 0.084 | 1.036 | 1.033 | 1.033 | 0.581 | 1.030 | 0.997 | 0.587 | 0.671 | 0.671 | 0.010 |
| hex: http/html-1m | 524290 | 18048.2 ± 0.4% | 0.082 | 1.006 | 1.000 | 1.000 | 0.537 | 0.994 | 0.997 | 0.538 | 0.664 | 0.663 | 0.010 |
| hex: http/json-1kx1024 | 2099200 | 9402.7 ± 19.3% | 0.151 | 1.258 | 1.247 | 1.254 | 0.694 | 1.255 | 0.955 | 0.755 | 0.924 | 0.928 | 0.018 |
| hex: http/json-16kx64 | 2097280 | 17693.1 ± 0.8% | 0.085 | 1.023 | 1.021 | 1.023 | 0.575 | 1.020 | 0.988 | 0.581 | 0.664 | 0.663 | 0.010 |
| hex: http/json-1m | 524290 | 17991.6 ± 0.9% | 0.083 | 1.009 | 1.000 | 0.997 | 0.521 | 1.001 | 1.002 | 0.524 | 0.668 | 0.668 | 0.010 |
| hex: http/js-1kx1024 | 2099200 | 8910.4 ± 19.4% | 0.159 | 1.296 | 1.301 | 1.292 | 0.726 | 1.286 | 0.973 | 0.787 | 0.970 | 0.975 | 0.019 |
| hex: http/js-16kx64 | 2097280 | 17834.0 ± 2.1% | 0.083 | 1.017 | 1.011 | 1.009 | 0.569 | 1.011 | 0.978 | 0.575 | 0.658 | 0.657 | 0.010 |
| hex: http/js-1m | 524290 | 18422.8 ± 0.8% | 0.081 | 1.019 | 1.011 | 1.009 | 0.518 | 0.999 | 0.998 | 0.516 | 0.649 | 0.649 | 0.009 |
| hex: http/css-1kx1024 | 2099200 | 9415.2 ± 19.2% | 0.150 | 1.247 | 1.248 | 1.258 | 0.691 | 1.248 | 0.972 | 0.748 | 0.924 | 0.919 | 0.018 |
| hex: http/css-16kx64 | 2097280 | 17709.0 ± 1.9% | 0.085 | 1.023 | 1.017 | 1.016 | 0.574 | 1.020 | 0.985 | 0.580 | 0.663 | 0.663 | 0.010 |
| hex: http/css-1m | 524290 | 18655.6 ± 2.6% | 0.080 | 0.989 | 0.985 | 0.984 | 0.513 | 0.982 | 0.985 | 0.515 | 0.642 | 0.643 | 0.009 |
| hex: shuffled/dickens-1m | 524290 | 18097.2 ± 1.2% | 0.082 | 0.992 | 0.996 | 0.996 | 0.526 | 0.991 | 0.996 | 0.527 | 0.664 | 0.664 | 0.010 |

## Encoding

Each claim's column is the throughput with the claim off over the throughput with every claim on; above 1, the claim's path lost. The `TextWriter's methods` column is a token a call through the whole-buffer helper, over many tokens a call (decision 69). Octets are the ones written. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1. The last column is the throughput with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35), over every claim on; above 1, the checks cost that much.

| Workload | Octets | All on, MB/s | J1 encoder string vectors off | J2 hex vectors off | J5 UTF-8 vectors off | J7 wide vectors off | J9 encoder fast path off | J11 encoder token loop off | J14 encoder escape blocks off | One token a call | TextWriter's methods | All off | J11 loop unchecked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1477.3 ± 0.3% | 0.444 | 1.002 | 0.967 | 1.009 | 1.006 | 0.268 | 0.999 | 0.548 | 0.914 | 0.089 | 1.031 |
| qlog records, JSON text sequence | 1467503 | 1264.1 ± 1.1% | 0.690 | 0.976 | 1.010 | 1.011 | 1.010 | 0.265 | 1.000 | 0.501 | 0.830 | 0.106 | 1.019 |
| string: silesia/dickens | 172528 | 6892.9 ± 0.4% | 0.025 | 1.002 | 1.003 | 1.002 | 1.003 | 0.167 | 0.717 | 1.004 | 1.003 | 0.025 | 1.034 |
| string: silesia/nci | 1075110 | 7294.9 ± 0.6% | 0.023 | 1.000 | 1.000 | 1.002 | 1.001 | 0.212 | 0.566 | 1.000 | 1.001 | 0.024 | 1.011 |
| string: silesia/reymont | 1075159 | 3321.6 ± 1.6% | 0.052 | 1.009 | 1.000 | 1.004 | 1.006 | 0.392 | 0.868 | 1.003 | 1.004 | 0.052 | 1.057 |
| string: silesia/samba | 97582 | 4188.8 ± 0.8% | 0.053 | 1.006 | 1.002 | 1.004 | 1.004 | 0.125 | 0.941 | 1.003 | 1.004 | 0.054 | 1.097 |
| string: silesia/webster | 1098490 | 4039.1 ± 0.7% | 0.042 | 1.012 | 1.011 | 1.010 | 1.012 | 0.213 | 0.888 | 1.003 | 1.007 | 0.044 | 1.013 |
| string: silesia/xml | 1090118 | 6103.1 ± 0.3% | 0.029 | 1.008 | 0.999 | 1.006 | 1.005 | 0.254 | 0.776 | 1.004 | 1.004 | 0.029 | 1.018 |
| string: canterbury/alice29.txt | 159425 | 6391.0 ± 0.6% | 0.027 | 1.008 | 1.012 | 1.012 | 1.014 | 0.133 | 0.657 | 1.005 | 1.007 | 0.027 | 1.066 |
| string: canterbury/asyoulik.txt | 132198 | 5571.8 ± 1.2% | 0.031 | 1.026 | 1.032 | 1.033 | 1.035 | 0.130 | 0.599 | 1.006 | 1.015 | 0.030 | 1.063 |
| string: canterbury/lcet10.txt | 441884 | 6240.1 ± 0.7% | 0.028 | 1.004 | 1.006 | 1.005 | 1.006 | 0.185 | 0.800 | 0.997 | 1.002 | 0.028 | 1.002 |
| string: canterbury/plrabn12.txt | 503330 | 5706.1 ± 0.6% | 0.031 | 1.002 | 1.003 | 1.004 | 1.003 | 0.168 | 0.698 | 1.003 | 1.003 | 0.031 | 1.009 |
| string: canterbury-large/E.coli | 1048578 | 19085.4 ± 0.4% | 0.078 | 1.004 | 1.006 | 1.001 | 1.003 | 0.484 | 1.005 | 1.005 | 1.004 | 0.009 | 1.006 |
| string: canterbury-large/bible.txt | 1055886 | 6770.7 ± 0.5% | 0.026 | 1.002 | 1.004 | 1.005 | 1.002 | 0.496 | 0.973 | 1.003 | 1.003 | 0.026 | 1.003 |
| string: canterbury-large/world192.txt | 1103121 | 4018.7 ± 0.2% | 0.042 | 1.020 | 1.020 | 1.021 | 1.018 | 0.193 | 0.830 | 1.003 | 1.010 | 0.043 | 1.004 |
| string: http/html-1m | 1058582 | 6732.5 ± 1.9% | 0.026 | 1.007 | 0.925 | 1.005 | 1.007 | 0.405 | 0.902 | 1.004 | 1.008 | 0.026 | 1.012 |
| string: http/json-1m | 1190272 | 3159.6 ± 0.3% | 0.050 | 1.000 | 0.967 | 1.002 | 1.004 | 0.133 | 0.371 | 1.001 | 1.002 | 0.051 | 1.044 |
| string: http/js-1m | 1144362 | 2755.4 ± 0.5% | 0.060 | 1.005 | 1.007 | 1.002 | 1.008 | 0.165 | 0.841 | 1.004 | 1.008 | 0.061 | 1.020 |
| string: http/css-1m | 1097820 | 3982.6 ± 0.7% | 0.042 | 1.008 | 1.009 | 1.008 | 1.009 | 0.207 | 0.647 | 1.001 | 1.007 | 0.044 | 1.011 |
| string: dickens as Cyrillic and CJK | 1883069 | 3064.9 ± 0.3% | 0.048 | 1.003 | 0.124 | 1.002 | 1.000 | 0.321 | 1.002 | 1.001 | 1.003 | 0.048 | 1.002 |
| hex: silesia/dickens | 524290 | 15639.2 ± 0.3% | 1.003 | 0.178 | 1.003 | 1.001 | 1.002 | 1.002 | 1.004 | 1.003 | 1.003 | 0.178 | 1.003 |
| hex: silesia/mozilla | 524290 | 15683.3 ± 0.1% | 1.001 | 0.178 | 1.000 | 1.000 | 1.001 | 0.997 | 0.998 | 0.997 | 0.999 | 0.178 | 0.998 |
| hex: silesia/mr | 524290 | 15647.8 ± 0.3% | 1.001 | 0.179 | 1.000 | 0.999 | 0.995 | 0.994 | 0.994 | 0.995 | 0.994 | 0.178 | 0.994 |
| hex: silesia/nci | 524290 | 15658.8 ± 0.1% | 1.000 | 0.178 | 1.002 | 1.000 | 1.000 | 0.999 | 1.000 | 1.000 | 1.001 | 0.178 | 1.001 |
| hex: silesia/ooffice | 524290 | 15605.9 ± 0.3% | 1.003 | 0.179 | 1.003 | 1.003 | 1.003 | 1.003 | 1.003 | 1.003 | 1.003 | 0.178 | 1.004 |
| hex: silesia/osdb | 524290 | 15636.0 ± 0.2% | 1.000 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 0.999 | 0.997 | 1.001 | 0.178 | 1.000 |
| hex: silesia/reymont | 524290 | 15662.8 ± 0.3% | 1.000 | 0.177 | 1.001 | 1.000 | 1.001 | 0.999 | 0.998 | 0.999 | 0.998 | 0.178 | 0.999 |
| hex: silesia/samba | 524290 | 15655.5 ± 0.1% | 1.001 | 0.178 | 0.996 | 0.994 | 0.996 | 0.992 | 0.994 | 0.991 | 0.993 | 0.177 | 0.992 |
| hex: silesia/sao | 524290 | 15659.7 ± 0.2% | 1.000 | 0.177 | 1.001 | 0.999 | 1.000 | 0.998 | 1.000 | 0.999 | 1.001 | 0.178 | 1.000 |
| hex: silesia/webster | 524290 | 15669.6 ± 0.2% | 1.000 | 0.178 | 1.000 | 1.000 | 0.999 | 0.996 | 0.999 | 0.997 | 0.997 | 0.177 | 0.997 |
| hex: silesia/x-ray | 524290 | 15630.8 ± 0.2% | 1.000 | 0.178 | 0.998 | 0.999 | 0.999 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.000 |
| hex: silesia/xml | 524290 | 15637.1 ± 0.2% | 1.000 | 0.178 | 0.999 | 1.002 | 1.001 | 0.999 | 1.000 | 1.001 | 1.000 | 0.178 | 1.000 |
| hex: canterbury/alice29.txt | 304180 | 15629.0 ± 0.2% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 0.993 | 0.996 | 1.003 | 1.003 | 0.178 | 1.001 |
| hex: canterbury/asyoulik.txt | 250360 | 15698.6 ± 0.1% | 1.001 | 0.178 | 1.001 | 1.001 | 1.001 | 1.000 | 1.001 | 1.001 | 1.001 | 0.178 | 1.001 |
| hex: canterbury/cp.html | 49208 | 15618.1 ± 0.1% | 1.001 | 0.179 | 1.000 | 1.000 | 1.000 | 0.998 | 1.001 | 1.001 | 1.003 | 0.179 | 1.001 |
| hex: canterbury/fields.c | 22302 | 15437.4 ± 0.1% | 1.001 | 0.181 | 1.000 | 1.000 | 1.000 | 0.994 | 1.000 | 1.001 | 1.005 | 0.180 | 1.001 |
| hex: canterbury/grammar.lsp | 7444 | 14933.5 ± 0.1% | 1.003 | 0.186 | 1.000 | 1.000 | 1.000 | 0.983 | 1.000 | 1.003 | 1.015 | 0.184 | 1.004 |
| hex: canterbury/kennedy.xls | 524290 | 15632.1 ± 0.2% | 1.000 | 0.178 | 0.999 | 0.999 | 0.998 | 0.993 | 0.994 | 0.997 | 0.993 | 0.178 | 0.996 |
| hex: canterbury/lcet10.txt | 524290 | 15607.0 ± 0.3% | 1.002 | 0.178 | 1.002 | 0.999 | 0.999 | 1.001 | 1.000 | 1.000 | 0.999 | 0.178 | 1.001 |
| hex: canterbury/plrabn12.txt | 524290 | 15622.7 ± 0.2% | 1.002 | 0.178 | 1.003 | 0.999 | 0.999 | 1.001 | 1.000 | 1.002 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/ptt5 | 524290 | 15600.4 ± 0.1% | 1.003 | 0.179 | 1.002 | 1.001 | 1.001 | 1.003 | 1.004 | 1.004 | 1.003 | 0.179 | 1.002 |
| hex: canterbury/sum | 76482 | 15638.2 ± 0.0% | 1.001 | 0.179 | 1.000 | 1.000 | 1.001 | 0.999 | 1.001 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: canterbury/xargs.1 | 8456 | 15006.3 ± 0.1% | 1.001 | 0.185 | 1.000 | 1.000 | 1.000 | 0.984 | 1.000 | 1.002 | 1.013 | 0.183 | 1.003 |
| hex: canterbury-large/E.coli | 524290 | 15588.6 ± 0.2% | 1.002 | 0.178 | 1.002 | 1.000 | 1.001 | 0.999 | 1.001 | 0.998 | 0.999 | 0.179 | 1.000 |
| hex: canterbury-large/bible.txt | 524290 | 15630.9 ± 0.1% | 1.002 | 0.178 | 1.001 | 1.002 | 1.003 | 1.000 | 1.000 | 1.000 | 1.000 | 0.177 | 1.002 |
| hex: canterbury-large/world192.txt | 524290 | 15578.0 ± 0.3% | 1.000 | 0.179 | 0.998 | 1.001 | 1.000 | 0.995 | 0.998 | 0.997 | 1.000 | 0.178 | 0.998 |
| hex: http/html-1kx1024 | 2099200 | 13604.9 ± 0.5% | 1.006 | 0.196 | 1.005 | 1.002 | 1.002 | 0.944 | 1.002 | 1.010 | 1.037 | 0.188 | 1.018 |
| hex: http/html-16kx64 | 2097280 | 15187.9 ± 0.8% | 0.998 | 0.181 | 1.000 | 0.998 | 1.000 | 0.993 | 0.999 | 1.003 | 1.004 | 0.179 | 1.003 |
| hex: http/html-1m | 524290 | 15664.3 ± 0.2% | 1.000 | 0.177 | 1.000 | 1.001 | 1.001 | 0.999 | 0.999 | 1.001 | 1.002 | 0.177 | 0.999 |
| hex: http/json-1kx1024 | 2099200 | 13558.7 ± 1.1% | 1.005 | 0.197 | 1.001 | 1.004 | 1.003 | 0.944 | 1.002 | 1.011 | 1.039 | 0.188 | 1.017 |
| hex: http/json-16kx64 | 2097280 | 15179.1 ± 0.5% | 1.000 | 0.181 | 1.005 | 1.002 | 1.003 | 0.998 | 1.003 | 1.005 | 1.004 | 0.181 | 1.007 |
| hex: http/json-1m | 524290 | 15676.6 ± 0.3% | 1.001 | 0.177 | 0.999 | 1.000 | 1.000 | 1.000 | 1.000 | 1.001 | 1.000 | 0.178 | 1.000 |
| hex: http/js-1kx1024 | 2099200 | 13640.6 ± 0.6% | 1.004 | 0.195 | 0.996 | 1.002 | 1.001 | 0.935 | 0.993 | 1.006 | 1.033 | 0.188 | 1.010 |
| hex: http/js-16kx64 | 2097280 | 15194.1 ± 0.5% | 0.998 | 0.181 | 0.998 | 1.003 | 1.002 | 0.993 | 1.001 | 1.003 | 1.005 | 0.180 | 1.000 |
| hex: http/js-1m | 524290 | 15654.9 ± 0.3% | 1.001 | 0.177 | 1.002 | 1.001 | 1.002 | 1.001 | 1.000 | 1.001 | 1.002 | 0.178 | 1.001 |
| hex: http/css-1kx1024 | 2099200 | 13629.2 ± 0.6% | 1.003 | 0.195 | 0.996 | 1.003 | 1.002 | 0.934 | 0.992 | 1.003 | 1.035 | 0.188 | 1.010 |
| hex: http/css-16kx64 | 2097280 | 15199.2 ± 0.3% | 1.001 | 0.181 | 1.001 | 1.003 | 1.000 | 0.993 | 1.002 | 1.001 | 1.007 | 0.180 | 1.002 |
| hex: http/css-1m | 524290 | 15654.9 ± 0.2% | 1.000 | 0.177 | 1.002 | 0.999 | 1.002 | 1.001 | 1.001 | 1.002 | 1.002 | 0.177 | 1.001 |
| hex: shuffled/dickens-1m | 524290 | 15602.4 ± 0.2% | 1.000 | 0.178 | 0.999 | 1.001 | 1.000 | 1.000 | 1.000 | 1.003 | 1.002 | 0.178 | 1.001 |

## Losses

Each workload where a claim's path ran slower than the path it replaces by more than the noise floor of decision 20.

- string: http/html-1m, decoding: J13 decoder escape blocks off runs at 1.055 of all on.
- string: http/js-1m, decoding: J12 decoder escape words off runs at 1.055 of all on.
- hex: http/html-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.263 of all on.
- hex: http/html-1kx1024, decoding: J7 wide vectors off runs at 1.260 of all on.
- hex: http/html-1kx1024, decoding: J8 decoder fast path off runs at 1.249 of all on.
- hex: http/html-1kx1024, decoding: J12 decoder escape words off runs at 1.268 of all on.
- hex: http/json-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.258 of all on.
- hex: http/json-1kx1024, decoding: J7 wide vectors off runs at 1.247 of all on.
- hex: http/json-1kx1024, decoding: J8 decoder fast path off runs at 1.254 of all on.
- hex: http/json-1kx1024, decoding: J12 decoder escape words off runs at 1.255 of all on.
- hex: http/js-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.296 of all on.
- hex: http/js-1kx1024, decoding: J7 wide vectors off runs at 1.301 of all on.
- hex: http/js-1kx1024, decoding: J8 decoder fast path off runs at 1.292 of all on.
- hex: http/js-1kx1024, decoding: J12 decoder escape words off runs at 1.286 of all on.
- hex: http/css-1kx1024, decoding: J5 UTF-8 vectors off runs at 1.247 of all on.
- hex: http/css-1kx1024, decoding: J7 wide vectors off runs at 1.248 of all on.
- hex: http/css-1kx1024, decoding: J8 decoder fast path off runs at 1.258 of all on.
- hex: http/css-1kx1024, decoding: J12 decoder escape words off runs at 1.248 of all on.

## UTF-8 validation against simdutf

stdx's `is_utf8`, the check the loops apply to every string's octets, run alone over each string workload's octets at the width the host's features pick (16 lanes on aarch64, AVX2's 32 or AVX-512's 64 on x86-64, decision 39), beside simdutf 9.3.3's `validate_utf8` in the same run; on a host with AVX-512, again with AVX2 alone. Each ratio is stdx's throughput over the other's. simdutf picks its kernel at run time. Before timing, every copy of the check and simdutf judged 20000 seeded buffers and each workload, whole and changed, alike.

| Workload | Octets | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|
| string: silesia/dickens | 166668 | 43326.6 ± 0.2% | 47370.2 ± 0.3% | 0.915 | — | — |
| string: silesia/nci | 1048576 | 33950.5 ± 3.8% | 36474.7 ± 4.1% | 0.931 | — | — |
| string: silesia/reymont | 1048576 | 32588.1 ± 2.5% | 35062.8 ± 1.8% | 0.929 | — | — |
| string: silesia/samba | 65546 | 43564.0 ± 0.1% | 48510.6 ± 0.0% | 0.898 | — | — |
| string: silesia/webster | 1048576 | 34437.5 ± 2.9% | 37591.6 ± 1.6% | 0.916 | — | — |
| string: silesia/xml | 1048576 | 30562.3 ± 2.9% | 31774.3 ± 2.4% | 0.962 | — | — |
| string: canterbury/alice29.txt | 152089 | 35873.3 ± 0.3% | 36528.3 ± 0.0% | 0.982 | — | — |
| string: canterbury/asyoulik.txt | 125179 | 43332.8 ± 0.1% | 47637.4 ± 0.0% | 0.910 | — | — |
| string: canterbury/lcet10.txt | 426754 | 36083.4 ± 0.1% | 36724.0 ± 0.1% | 0.983 | — | — |
| string: canterbury/plrabn12.txt | 481861 | 42228.3 ± 0.2% | 47002.0 ± 0.3% | 0.898 | — | — |
| string: canterbury-large/E.coli | 1048576 | 34256.7 ± 2.5% | 36433.0 ± 4.8% | 0.940 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 30272.2 ± 3.6% | 31343.0 ± 4.9% | 0.966 | — | — |
| string: canterbury-large/world192.txt | 1048576 | 31727.2 ± 2.1% | 33019.1 ± 2.3% | 0.961 | — | — |
| string: http/html-1m | 1048576 | 33930.6 ± 2.8% | 35919.4 ± 2.7% | 0.945 | — | — |
| string: http/json-1m | 1048576 | 31563.0 ± 2.3% | 33558.7 ± 2.3% | 0.941 | — | — |
| string: http/js-1m | 1048576 | 38081.4 ± 1.4% | 41751.9 ± 2.3% | 0.912 | — | — |
| string: http/css-1m | 1048576 | 34537.4 ± 0.8% | 36679.6 ± 1.1% | 0.942 | — | — |
| string: dickens as Cyrillic and CJK | 1847045 | 5760.9 ± 0.3% | 5651.0 ± 0.1% | 1.019 | — | — |

## Losses to simdutf

- string: silesia/dickens: stdx runs at 0.915 of simdutf.
- string: silesia/nci: stdx runs at 0.931 of simdutf.
- string: silesia/reymont: stdx runs at 0.929 of simdutf.
- string: silesia/samba: stdx runs at 0.898 of simdutf.
- string: silesia/webster: stdx runs at 0.916 of simdutf.
- string: canterbury/asyoulik.txt: stdx runs at 0.910 of simdutf.
- string: canterbury/plrabn12.txt: stdx runs at 0.898 of simdutf.
- string: canterbury-large/E.coli: stdx runs at 0.940 of simdutf.
- string: http/html-1m: stdx runs at 0.945 of simdutf.
- string: http/json-1m: stdx runs at 0.941 of simdutf.
- string: http/js-1m: stdx runs at 0.912 of simdutf.
- string: http/css-1m: stdx runs at 0.942 of simdutf.

## UTF-8 validation by the buffer's offset from a 64-octet line

| Buffer | Octets | Offset | stdx, MB/s | simdutf, MB/s | stdx / simdutf | stdx with AVX2 alone, MB/s | stdx / stdx with AVX2 alone |
|---|---|---|---|---|---|---|---|
| string: canterbury-large/bible.txt | 1048576 | 0 | 37226.2 ± 1.5% | 39867.7 ± 3.2% | 0.934 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 1 | 33210.9 ± 5.5% | 34188.9 ± 5.0% | 0.971 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 8 | 35825.7 ± 4.1% | 38446.3 ± 1.1% | 0.932 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 16 | 36873.0 ± 1.6% | 40342.2 ± 1.4% | 0.914 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 32 | 36815.3 ± 2.8% | 40039.2 ± 2.4% | 0.919 | — | — |
| string: canterbury-large/bible.txt | 1048576 | 48 | 36424.0 ± 2.4% | 39783.4 ± 1.7% | 0.916 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 0 | 5754.0 ± 0.5% | 5637.1 ± 0.3% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 1 | 5742.2 ± 0.2% | 5635.3 ± 0.2% | 1.019 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 8 | 5762.3 ± 0.3% | 5644.7 ± 0.3% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 16 | 5756.0 ± 0.3% | 5638.7 ± 0.2% | 1.021 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 32 | 5759.3 ± 1.8% | 5644.3 ± 3.7% | 1.020 | — | — |
| string: dickens as Cyrillic and CJK | 1048576 | 48 | 5749.7 ± 0.1% | 5638.7 ± 0.2% | 1.020 | — | — |

## Against the baselines

stdx with every claim on, timed beside simdjson 5.1.1, yyjson 0.13.0, Zig 0.16.0's std.json, serde_json 1.0.154 and Go's encoding/json/jsontext in the same run. Each ratio is stdx's throughput over the baseline's; below 1, the baseline is faster. stdx is built for the architecture's baseline CPU in ReleaseSafe. Each baseline is built for the same CPU, the C, C++ and Zig ones in ReleaseFast (decision 75), and simdjson picks its kernel at run time. Decoding visits every value; encoding writes each text from its tokens.

## Decoding against the baselines

Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1130.1 ± 0.7% | 929.4 ± 0.2% | 1022.6 ± 0.5% | 301.1 ± 1.1% | 664.0 ± 0.2% | 309.2 ± 1.9% | 1.216 | 1.105 | 3.753 | 1.702 | 3.655 |
| qlog records, JSON text sequence | 1467503 | 846.4 ± 0.8% | 817.9 ± 0.1% | 776.3 ± 1.5% | 244.1 ± 0.4% | 693.8 ± 0.6% | 247.7 ± 0.5% | 1.035 | 1.090 | 3.467 | 1.220 | 3.417 |
| string: silesia/dickens | 172528 | 5032.0 ± 0.5% | 1876.8 ± 0.2% | 2650.6 ± 0.3% | 361.8 ± 0.7% | 2860.1 ± 0.4% | 543.7 ± 1.5% | 2.681 | 1.898 | 13.906 | 1.759 | 9.255 |
| string: silesia/nci | 1075110 | 4297.2 ± 0.9% | 2238.7 ± 0.3% | 2993.0 ± 0.3% | 544.6 ± 0.8% | 2992.3 ± 0.5% | 598.4 ± 2.5% | 1.919 | 1.436 | 7.890 | 1.436 | 7.181 |
| string: silesia/reymont | 1075159 | 2940.4 ± 1.7% | 1819.9 ± 2.1% | 2059.8 ± 0.4% | 374.5 ± 0.9% | 2139.1 ± 0.9% | 534.0 ± 0.9% | 1.616 | 1.428 | 7.851 | 1.375 | 5.506 |
| string: silesia/samba | 97582 | 3490.8 ± 0.6% | 2024.1 ± 0.2% | 2617.8 ± 0.3% | 329.6 ± 0.6% | 1496.2 ± 0.3% | 429.3 ± 0.6% | 1.725 | 1.333 | 10.591 | 2.333 | 8.131 |
| string: silesia/webster | 1098490 | 3638.0 ± 0.7% | 1518.4 ± 0.3% | 2010.3 ± 0.4% | 359.0 ± 0.3% | 2160.2 ± 0.9% | 494.8 ± 1.2% | 2.396 | 1.810 | 10.134 | 1.684 | 7.352 |
| string: silesia/xml | 1090118 | 4777.2 ± 0.3% | 2354.0 ± 1.9% | 2517.5 ± 2.0% | 452.7 ± 1.2% | 2833.3 ± 0.4% | 557.7 ± 1.6% | 2.029 | 1.898 | 10.553 | 1.686 | 8.565 |
| string: canterbury/alice29.txt | 159425 | 4300.8 ± 0.6% | 1598.5 ± 0.3% | 2455.9 ± 0.6% | 342.1 ± 0.8% | 2504.2 ± 0.4% | 503.8 ± 0.5% | 2.691 | 1.751 | 12.572 | 1.717 | 8.537 |
| string: canterbury/asyoulik.txt | 132198 | 3447.6 ± 1.0% | 1459.3 ± 0.3% | 2243.7 ± 0.3% | 335.7 ± 1.5% | 2077.4 ± 0.4% | 456.5 ± 1.9% | 2.362 | 1.537 | 10.269 | 1.660 | 7.552 |
| string: canterbury/lcet10.txt | 441884 | 5130.3 ± 0.3% | 1852.5 ± 0.3% | 2337.9 ± 0.5% | 390.9 ± 0.6% | 2846.0 ± 0.3% | 530.7 ± 1.4% | 2.769 | 2.194 | 13.125 | 1.803 | 9.666 |
| string: canterbury/plrabn12.txt | 503330 | 4125.7 ± 0.6% | 1736.3 ± 0.1% | 2058.1 ± 0.5% | 361.0 ± 1.0% | 2476.6 ± 0.8% | 496.2 ± 1.3% | 2.376 | 2.005 | 11.429 | 1.666 | 8.314 |
| string: canterbury-large/E.coli | 1048578 | 19077.3 ± 1.5% | 3610.7 ± 0.3% | 3252.3 ± 0.3% | 930.2 ± 1.1% | 5969.3 ± 1.2% | 759.4 ± 0.8% | 5.284 | 5.866 | 20.509 | 3.196 | 25.123 |
| string: canterbury-large/bible.txt | 1055886 | 6691.9 ± 1.1% | 2936.2 ± 0.5% | 2835.7 ± 0.6% | 423.5 ± 1.0% | 3751.0 ± 1.4% | 615.4 ± 1.3% | 2.279 | 2.360 | 15.800 | 1.784 | 10.874 |
| string: canterbury-large/world192.txt | 1103121 | 3381.8 ± 0.5% | 1481.2 ± 0.1% | 2013.9 ± 0.5% | 352.8 ± 0.7% | 2107.2 ± 1.4% | 499.6 ± 1.2% | 2.283 | 1.679 | 9.587 | 1.605 | 6.769 |
| string: http/html-1m | 1058582 | 6039.1 ± 1.2% | 2739.6 ± 0.5% | 2688.1 ± 0.6% | 441.8 ± 0.5% | 3469.0 ± 0.5% | 595.6 ± 1.6% | 2.204 | 2.247 | 13.668 | 1.741 | 10.139 |
| string: http/json-1m | 1190272 | 2546.1 ± 0.6% | 877.2 ± 0.4% | 2249.7 ± 0.2% | 391.0 ± 0.5% | 1058.2 ± 0.8% | 441.6 ± 0.5% | 2.902 | 1.132 | 6.511 | 2.406 | 5.766 |
| string: http/js-1m | 1144362 | 2280.9 ± 0.4% | 1028.8 ± 0.2% | 1636.5 ± 0.6% | 321.8 ± 0.4% | 1514.1 ± 0.9% | 416.5 ± 0.2% | 2.217 | 1.394 | 7.089 | 1.506 | 5.477 |
| string: http/css-1m | 1097820 | 2633.8 ± 0.4% | 1677.4 ± 0.2% | 2223.6 ± 0.5% | 407.6 ± 1.1% | 1937.2 ± 1.0% | 486.1 ± 1.4% | 1.570 | 1.184 | 6.462 | 1.360 | 5.418 |
| string: dickens as Cyrillic and CJK | 1883069 | 3075.5 ± 0.5% | 1683.9 ± 0.3% | 894.3 ± 0.2% | 350.1 ± 0.2% | 666.6 ± 1.3% | 158.2 ± 2.2% | 1.826 | 3.439 | 8.784 | 4.614 | 19.442 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1327.9 ± 1.9% | 981.7 ± 0.4% | 1199.6 ± 0.6% | 216.0 ± 0.2% | 473.1 ± 0.9% | 255.4 ± 3.9% | 1.353 | 1.107 | 6.147 | 2.807 | 5.198 |
| hex: silesia/dickens | 524290 | 18568.2 ± 1.4% | 3609.0 ± 0.0% | 3286.2 ± 0.4% | 503.7 ± 0.6% | 6024.0 ± 0.9% | 779.8 ± 3.5% | 5.145 | 5.650 | 36.866 | 3.082 | 23.811 |
| hex: silesia/mozilla | 524290 | 18418.2 ± 1.7% | 3611.4 ± 0.2% | 3285.6 ± 0.4% | 451.1 ± 1.2% | 6121.7 ± 2.0% | 781.5 ± 0.6% | 5.100 | 5.606 | 40.828 | 3.009 | 23.568 |
| hex: silesia/mr | 524290 | 18167.8 ± 0.6% | 3615.4 ± 0.2% | 3286.3 ± 0.4% | 568.6 ± 1.2% | 6094.5 ± 2.4% | 779.8 ± 0.4% | 5.025 | 5.528 | 31.952 | 2.981 | 23.299 |
| hex: silesia/nci | 524290 | 18529.2 ± 1.3% | 3615.4 ± 0.1% | 3284.0 ± 0.3% | 623.6 ± 2.2% | 6092.6 ± 1.4% | 779.6 ± 0.3% | 5.125 | 5.642 | 29.713 | 3.041 | 23.767 |
| hex: silesia/ooffice | 524290 | 18483.4 ± 0.9% | 3612.3 ± 0.4% | 3290.7 ± 0.3% | 397.7 ± 0.4% | 6025.9 ± 1.3% | 780.6 ± 0.4% | 5.117 | 5.617 | 46.473 | 3.067 | 23.678 |
| hex: silesia/osdb | 524290 | 18224.7 ± 0.7% | 3617.0 ± 0.2% | 3290.9 ± 0.4% | 477.1 ± 2.5% | 6112.8 ± 1.2% | 779.5 ± 0.7% | 5.039 | 5.538 | 38.196 | 2.981 | 23.380 |
| hex: silesia/reymont | 524290 | 18728.4 ± 1.3% | 3610.6 ± 0.2% | 3285.1 ± 0.9% | 517.1 ± 1.7% | 6031.1 ± 1.8% | 777.7 ± 1.7% | 5.187 | 5.701 | 36.219 | 3.105 | 24.080 |
| hex: silesia/samba | 524290 | 17885.5 ± 0.8% | 3616.6 ± 0.2% | 3287.3 ± 0.4% | 408.5 ± 0.8% | 6132.1 ± 0.8% | 781.9 ± 0.4% | 4.945 | 5.441 | 43.784 | 2.917 | 22.876 |
| hex: silesia/sao | 524290 | 18603.7 ± 2.1% | 3612.9 ± 0.3% | 3293.0 ± 0.2% | 343.6 ± 0.5% | 6148.6 ± 2.1% | 781.0 ± 0.2% | 5.149 | 5.650 | 54.145 | 3.026 | 23.820 |
| hex: silesia/webster | 524290 | 18396.2 ± 1.0% | 3612.8 ± 0.1% | 3296.0 ± 0.2% | 466.3 ± 1.2% | 6131.5 ± 1.5% | 780.5 ± 0.3% | 5.092 | 5.581 | 39.452 | 3.000 | 23.571 |
| hex: silesia/x-ray | 524290 | 18679.0 ± 0.9% | 3615.0 ± 0.2% | 3291.5 ± 0.4% | 475.1 ± 2.5% | 6009.8 ± 1.3% | 782.5 ± 0.3% | 5.167 | 5.675 | 39.319 | 3.108 | 23.871 |
| hex: silesia/xml | 524290 | 18372.8 ± 1.2% | 3617.1 ± 0.4% | 3287.1 ± 0.4% | 519.8 ± 0.7% | 6135.7 ± 1.0% | 781.3 ± 0.5% | 5.079 | 5.589 | 35.344 | 2.994 | 23.517 |
| hex: canterbury/alice29.txt | 304180 | 19043.0 ± 0.6% | 3627.9 ± 0.1% | 3343.2 ± 0.1% | 508.9 ± 0.6% | 6132.6 ± 0.8% | 780.2 ± 0.7% | 5.249 | 5.696 | 37.421 | 3.105 | 24.407 |
| hex: canterbury/asyoulik.txt | 250360 | 19544.8 ± 0.1% | 3642.1 ± 0.0% | 3372.3 ± 0.1% | 503.1 ± 0.2% | 6135.7 ± 1.6% | 779.7 ± 0.1% | 5.366 | 5.796 | 38.849 | 3.185 | 25.067 |
| hex: canterbury/cp.html | 49208 | 19293.0 ± 0.4% | 3637.6 ± 0.0% | 3279.1 ± 0.4% | 463.3 ± 1.6% | 6261.2 ± 0.5% | 762.1 ± 1.6% | 5.304 | 5.884 | 41.639 | 3.081 | 25.314 |
| hex: canterbury/fields.c | 22302 | 18875.7 ± 0.8% | 3629.2 ± 0.0% | 3371.3 ± 0.3% | 510.7 ± 0.9% | 6254.7 ± 0.3% | 756.9 ± 0.9% | 5.201 | 5.599 | 36.958 | 3.018 | 24.938 |
| hex: canterbury/grammar.lsp | 7444 | 17529.3 ± 0.6% | 3601.9 ± 0.1% | 3358.5 ± 0.3% | 544.1 ± 3.8% | 6167.2 ± 0.6% | 722.4 ± 2.4% | 4.867 | 5.219 | 32.215 | 2.842 | 24.264 |
| hex: canterbury/kennedy.xls | 524290 | 18428.4 ± 1.7% | 3611.9 ± 0.2% | 3281.4 ± 0.3% | 663.4 ± 1.6% | 6017.9 ± 0.8% | 775.0 ± 3.9% | 5.102 | 5.616 | 27.778 | 3.062 | 23.780 |
| hex: canterbury/lcet10.txt | 524290 | 18488.3 ± 1.2% | 3605.4 ± 0.2% | 3291.2 ± 0.2% | 526.9 ± 4.8% | 6148.0 ± 1.5% | 781.7 ± 0.5% | 5.128 | 5.618 | 35.090 | 3.007 | 23.652 |
| hex: canterbury/plrabn12.txt | 524290 | 18094.7 ± 1.4% | 3603.7 ± 0.1% | 3299.4 ± 0.3% | 505.8 ± 2.0% | 6085.1 ± 1.1% | 782.5 ± 0.2% | 5.021 | 5.484 | 35.774 | 2.974 | 23.124 |
| hex: canterbury/ptt5 | 524290 | 18349.2 ± 1.7% | 3606.4 ± 0.3% | 3286.7 ± 0.7% | 560.0 ± 0.9% | 6095.1 ± 0.8% | 779.7 ± 0.8% | 5.088 | 5.583 | 32.768 | 3.010 | 23.533 |
| hex: canterbury/sum | 76482 | 19292.2 ± 0.2% | 3633.8 ± 0.1% | 3362.7 ± 0.2% | 512.6 ± 0.6% | 6170.1 ± 0.8% | 773.8 ± 0.3% | 5.309 | 5.737 | 37.636 | 3.127 | 24.932 |
| hex: canterbury/xargs.1 | 8456 | 17807.2 ± 0.6% | 3601.9 ± 0.0% | 3348.7 ± 0.4% | 483.7 ± 2.2% | 6144.7 ± 0.2% | 756.1 ± 2.5% | 4.944 | 5.318 | 36.816 | 2.898 | 23.550 |
| hex: canterbury-large/E.coli | 524290 | 18020.6 ± 0.8% | 3611.7 ± 0.1% | 3279.6 ± 0.2% | 688.6 ± 0.2% | 6138.2 ± 1.5% | 771.1 ± 4.6% | 4.989 | 5.495 | 26.168 | 2.936 | 23.371 |
| hex: canterbury-large/bible.txt | 524290 | 18528.1 ± 1.4% | 3613.2 ± 0.2% | 3291.8 ± 0.6% | 518.3 ± 0.5% | 6086.2 ± 0.7% | 778.3 ± 0.5% | 5.128 | 5.629 | 35.751 | 3.044 | 23.807 |
| hex: canterbury-large/world192.txt | 524290 | 17735.3 ± 0.8% | 3611.3 ± 0.3% | 3286.0 ± 0.3% | 493.6 ± 1.3% | 6117.4 ± 0.4% | 777.0 ± 0.9% | 4.911 | 5.397 | 35.934 | 2.899 | 22.825 |
| hex: http/html-1kx1024 | 2099200 | 9110.9 ± 19.6% | 3459.7 ± 0.3% | 2833.1 ± 0.6% | 473.8 ± 0.1% | 5172.2 ± 0.7% | 608.5 ± 2.3% | 2.633 | 3.216 | 19.230 | 1.762 | 14.972 |
| hex: http/html-16kx64 | 2097280 | 17493.8 ± 1.5% | 3606.4 ± 0.2% | 3255.1 ± 0.1% | 479.9 ± 2.9% | 6005.2 ± 0.4% | 732.2 ± 2.1% | 4.851 | 5.374 | 36.453 | 2.913 | 23.893 |
| hex: http/html-1m | 524290 | 18048.2 ± 0.4% | 3618.0 ± 0.2% | 3287.5 ± 0.2% | 500.4 ± 1.5% | 6101.9 ± 0.9% | 767.1 ± 3.1% | 4.988 | 5.490 | 36.065 | 2.958 | 23.528 |
| hex: http/json-1kx1024 | 2099200 | 9402.7 ± 19.3% | 3460.7 ± 0.2% | 2829.2 ± 0.9% | 574.0 ± 0.7% | 5074.1 ± 0.8% | 617.2 ± 4.7% | 2.717 | 3.323 | 16.382 | 1.853 | 15.234 |
| hex: http/json-16kx64 | 2097280 | 17693.1 ± 0.8% | 3608.2 ± 0.1% | 3243.8 ± 0.3% | 568.4 ± 1.1% | 6005.5 ± 0.6% | 740.8 ± 1.2% | 4.904 | 5.454 | 31.127 | 2.946 | 23.883 |
| hex: http/json-1m | 524290 | 17991.6 ± 0.9% | 3614.0 ± 0.2% | 3298.1 ± 0.2% | 581.5 ± 0.8% | 6148.4 ± 2.2% | 773.3 ± 3.7% | 4.978 | 5.455 | 30.938 | 2.926 | 23.266 |
| hex: http/js-1kx1024 | 2099200 | 8910.4 ± 19.4% | 3461.0 ± 0.2% | 2816.1 ± 0.5% | 478.5 ± 0.5% | 5053.7 ± 1.3% | 597.0 ± 4.8% | 2.575 | 3.164 | 18.622 | 1.763 | 14.926 |
| hex: http/js-16kx64 | 2097280 | 17834.0 ± 2.1% | 3602.2 ± 0.1% | 3240.6 ± 0.3% | 478.8 ± 1.1% | 6003.4 ± 0.8% | 724.8 ± 2.3% | 4.951 | 5.503 | 37.247 | 2.971 | 24.606 |
| hex: http/js-1m | 524290 | 18422.8 ± 0.8% | 3612.1 ± 0.1% | 3287.8 ± 0.4% | 501.2 ± 1.2% | 6084.9 ± 1.2% | 765.6 ± 2.4% | 5.100 | 5.603 | 36.759 | 3.028 | 24.064 |
| hex: http/css-1kx1024 | 2099200 | 9415.2 ± 19.2% | 3456.6 ± 0.3% | 2816.4 ± 0.3% | 487.6 ± 1.2% | 5072.0 ± 1.2% | 610.3 ± 1.4% | 2.724 | 3.343 | 19.311 | 1.856 | 15.428 |
| hex: http/css-16kx64 | 2097280 | 17709.0 ± 1.9% | 3602.0 ± 0.3% | 3239.9 ± 0.3% | 485.3 ± 2.9% | 6017.7 ± 0.3% | 728.4 ± 2.4% | 4.916 | 5.466 | 36.491 | 2.943 | 24.313 |
| hex: http/css-1m | 524290 | 18655.6 ± 2.6% | 3614.0 ± 0.2% | 3285.9 ± 0.2% | 499.9 ± 1.3% | 6174.6 ± 0.4% | 763.8 ± 3.5% | 5.162 | 5.677 | 37.316 | 3.021 | 24.425 |
| hex: shuffled/dickens-1m | 524290 | 18097.2 ± 1.2% | 3613.2 ± 0.2% | 3289.0 ± 0.3% | 513.6 ± 0.5% | 6144.1 ± 0.6% | 776.0 ± 1.3% | 5.009 | 5.502 | 35.237 | 2.945 | 23.323 |

## Encoding against the baselines

Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1477.3 ± 0.3% | 1251.1 ± 0.5% | 1035.9 ± 0.4% | 410.2 ± 0.4% | 448.0 ± 0.2% | 414.8 ± 0.6% | 1.181 | 1.426 | 3.601 | 3.298 | 3.562 |
| qlog records, JSON text sequence | 1467503 | 1264.1 ± 1.1% | 1059.9 ± 0.6% | 779.5 ± 0.9% | 378.5 ± 0.8% | 468.5 ± 1.1% | 278.7 ± 1.9% | 1.193 | 1.622 | 3.340 | 2.698 | 4.535 |
| string: silesia/dickens | 172528 | 6892.9 ± 0.4% | 2820.8 ± 0.2% | 2929.3 ± 1.0% | 430.7 ± 0.7% | 1570.2 ± 0.1% | 1011.3 ± 0.1% | 2.444 | 2.353 | 16.003 | 4.390 | 6.816 |
| string: silesia/nci | 1075110 | 7294.9 ± 0.6% | 3417.6 ± 1.0% | 3100.0 ± 0.7% | 819.6 ± 2.3% | 1852.2 ± 0.3% | 1106.7 ± 0.2% | 2.135 | 2.353 | 8.900 | 3.938 | 6.592 |
| string: silesia/reymont | 1075159 | 3321.6 ± 1.6% | 1991.7 ± 1.0% | 2061.1 ± 0.7% | 451.5 ± 1.5% | 1509.9 ± 0.2% | 948.1 ± 0.4% | 1.668 | 1.612 | 7.357 | 2.200 | 3.503 |
| string: silesia/samba | 97582 | 4188.8 ± 0.8% | 2114.1 ± 0.9% | 3456.2 ± 0.5% | 354.2 ± 0.8% | 1435.2 ± 0.3% | 1054.2 ± 0.3% | 1.981 | 1.212 | 11.826 | 2.919 | 3.974 |
| string: silesia/webster | 1098490 | 4039.1 ± 0.7% | 1876.7 ± 0.7% | 2055.8 ± 0.6% | 441.9 ± 0.6% | 1388.5 ± 0.2% | 644.5 ± 0.4% | 2.152 | 1.965 | 9.140 | 2.909 | 6.267 |
| string: silesia/xml | 1090118 | 6103.1 ± 0.3% | 2864.3 ± 0.5% | 2643.5 ± 0.6% | 607.9 ± 0.5% | 1747.8 ± 0.4% | 920.1 ± 0.4% | 2.131 | 2.309 | 10.040 | 3.492 | 6.633 |
| string: canterbury/alice29.txt | 159425 | 6391.0 ± 0.6% | 2202.7 ± 0.7% | 2766.4 ± 1.3% | 407.7 ± 0.4% | 1463.7 ± 0.3% | 956.5 ± 0.2% | 2.901 | 2.310 | 15.674 | 4.366 | 6.681 |
| string: canterbury/asyoulik.txt | 132198 | 5571.8 ± 1.2% | 1711.2 ± 0.4% | 2371.0 ± 1.1% | 401.5 ± 0.5% | 1337.3 ± 0.2% | 885.4 ± 0.2% | 3.256 | 2.350 | 13.877 | 4.166 | 6.293 |
| string: canterbury/lcet10.txt | 441884 | 6240.1 ± 0.7% | 2561.6 ± 0.5% | 2474.2 ± 1.4% | 469.6 ± 0.8% | 1521.9 ± 0.1% | 983.5 ± 0.2% | 2.436 | 2.522 | 13.289 | 4.100 | 6.345 |
| string: canterbury/plrabn12.txt | 503330 | 5706.1 ± 0.6% | 2056.7 ± 0.3% | 2068.7 ± 0.4% | 421.7 ± 0.7% | 1406.1 ± 0.1% | 929.8 ± 0.7% | 2.774 | 2.758 | 13.530 | 4.058 | 6.137 |
| string: canterbury-large/E.coli | 1048578 | 19085.4 ± 0.4% | 9731.1 ± 2.2% | 3793.5 ± 0.4% | 1472.5 ± 0.4% | 2366.4 ± 0.4% | 1192.5 ± 1.2% | 1.961 | 5.031 | 12.961 | 8.065 | 16.005 |
| string: canterbury-large/bible.txt | 1055886 | 6770.7 ± 0.5% | 4149.7 ± 0.7% | 3021.5 ± 1.5% | 501.9 ± 0.9% | 1987.4 ± 0.3% | 1119.0 ± 0.6% | 1.632 | 2.241 | 13.491 | 3.407 | 6.051 |
| string: canterbury-large/world192.txt | 1103121 | 4018.7 ± 0.2% | 1655.3 ± 0.5% | 2004.2 ± 0.8% | 448.4 ± 0.3% | 1357.8 ± 0.3% | 908.5 ± 0.2% | 2.428 | 2.005 | 8.962 | 2.960 | 4.423 |
| string: http/html-1m | 1058582 | 6732.5 ± 1.9% | 3973.2 ± 1.2% | 3039.8 ± 0.4% | 499.3 ± 1.0% | 1925.0 ± 0.3% | 805.3 ± 0.1% | 1.694 | 2.215 | 13.483 | 3.497 | 8.360 |
| string: http/json-1m | 1190272 | 3159.6 ± 0.3% | 1350.2 ± 0.2% | 1556.2 ± 0.3% | 445.2 ± 0.8% | 961.5 ± 0.5% | 765.7 ± 0.2% | 2.340 | 2.030 | 7.098 | 3.286 | 4.127 |
| string: http/js-1m | 1144362 | 2755.4 ± 0.5% | 1178.8 ± 0.6% | 1624.8 ± 0.3% | 369.5 ± 0.3% | 1092.9 ± 0.2% | 757.7 ± 0.2% | 2.338 | 1.696 | 7.458 | 2.521 | 3.637 |
| string: http/css-1m | 1097820 | 3982.6 ± 0.7% | 1486.7 ± 0.5% | 2150.1 ± 0.8% | 495.3 ± 0.7% | 1368.1 ± 0.1% | 895.3 ± 0.3% | 2.679 | 1.852 | 8.041 | 2.911 | 4.449 |
| string: dickens as Cyrillic and CJK | 1883069 | 3064.9 ± 0.3% | 2340.0 ± 0.5% | 521.1 ± 0.4% | 306.7 ± 0.5% | 562.5 ± 1.6% | 336.1 ± 0.6% | 1.310 | 5.881 | 9.993 | 5.449 | 9.119 |
| hex: silesia/dickens | 524290 | 15639.2 ± 0.3% | 1461.0 ± 0.4% | 1083.5 ± 0.2% | 500.5 ± 0.7% | 988.5 ± 0.3% | 734.9 ± 0.3% | 10.705 | 14.434 | 31.250 | 15.821 | 21.281 |
| hex: silesia/mozilla | 524290 | 15683.3 ± 0.1% | 1471.2 ± 0.2% | 1087.9 ± 0.3% | 441.3 ± 0.2% | 993.9 ± 0.4% | 733.1 ± 0.5% | 10.660 | 14.416 | 35.535 | 15.780 | 21.392 |
| hex: silesia/mr | 524290 | 15647.8 ± 0.3% | 1476.9 ± 0.5% | 1089.1 ± 0.5% | 554.9 ± 3.3% | 992.4 ± 0.2% | 734.2 ± 0.2% | 10.595 | 14.367 | 28.200 | 15.768 | 21.314 |
| hex: silesia/nci | 524290 | 15658.8 ± 0.1% | 1473.4 ± 0.5% | 1087.6 ± 0.3% | 634.5 ± 2.8% | 992.4 ± 0.6% | 733.7 ± 0.5% | 10.627 | 14.398 | 24.679 | 15.778 | 21.341 |
| hex: silesia/ooffice | 524290 | 15605.9 ± 0.3% | 1464.3 ± 0.2% | 1080.7 ± 0.4% | 388.9 ± 0.1% | 990.3 ± 0.5% | 734.4 ± 0.5% | 10.658 | 14.441 | 40.126 | 15.760 | 21.250 |
| hex: silesia/osdb | 524290 | 15636.0 ± 0.2% | 1469.9 ± 0.1% | 1086.2 ± 0.4% | 467.7 ± 0.5% | 990.7 ± 0.4% | 733.7 ± 0.6% | 10.637 | 14.396 | 33.433 | 15.782 | 21.310 |
| hex: silesia/reymont | 524290 | 15662.8 ± 0.3% | 1459.8 ± 0.3% | 1080.5 ± 0.5% | 513.8 ± 1.6% | 989.3 ± 0.6% | 735.5 ± 0.2% | 10.729 | 14.496 | 30.483 | 15.832 | 21.295 |
| hex: silesia/samba | 524290 | 15655.5 ± 0.1% | 1466.8 ± 0.5% | 1085.1 ± 0.4% | 402.6 ± 0.4% | 990.5 ± 0.3% | 734.0 ± 1.3% | 10.673 | 14.428 | 38.890 | 15.806 | 21.330 |
| hex: silesia/sao | 524290 | 15659.7 ± 0.2% | 1463.8 ± 0.3% | 1083.1 ± 0.4% | 333.4 ± 0.4% | 987.2 ± 0.3% | 733.5 ± 0.4% | 10.698 | 14.458 | 46.969 | 15.863 | 21.349 |
| hex: silesia/webster | 524290 | 15669.6 ± 0.2% | 1466.3 ± 0.2% | 1087.0 ± 0.2% | 474.7 ± 0.6% | 987.0 ± 0.6% | 733.8 ± 0.3% | 10.687 | 14.415 | 33.007 | 15.875 | 21.354 |
| hex: silesia/x-ray | 524290 | 15630.8 ± 0.2% | 1473.4 ± 0.4% | 1089.7 ± 0.4% | 445.3 ± 1.0% | 992.0 ± 0.4% | 732.2 ± 0.5% | 10.608 | 14.344 | 35.098 | 15.757 | 21.347 |
| hex: silesia/xml | 524290 | 15637.1 ± 0.2% | 1466.7 ± 0.5% | 1085.2 ± 0.6% | 615.1 ± 0.9% | 992.0 ± 0.4% | 734.2 ± 0.3% | 10.661 | 14.410 | 25.422 | 15.763 | 21.299 |
| hex: canterbury/alice29.txt | 304180 | 15629.0 ± 0.2% | 1470.3 ± 0.7% | 1092.4 ± 0.4% | 505.5 ± 0.9% | 995.0 ± 0.3% | 735.1 ± 0.3% | 10.630 | 14.307 | 30.918 | 15.708 | 21.262 |
| hex: canterbury/asyoulik.txt | 250360 | 15698.6 ± 0.1% | 1478.8 ± 0.6% | 1094.7 ± 0.4% | 500.1 ± 0.3% | 994.4 ± 0.4% | 740.1 ± 0.3% | 10.616 | 14.340 | 31.390 | 15.788 | 21.212 |
| hex: canterbury/cp.html | 49208 | 15618.1 ± 0.1% | 1474.5 ± 0.5% | 1099.6 ± 0.2% | 524.5 ± 1.6% | 1002.9 ± 0.6% | 743.5 ± 0.1% | 10.592 | 14.203 | 29.778 | 15.572 | 21.008 |
| hex: canterbury/fields.c | 22302 | 15437.4 ± 0.1% | 1420.5 ± 1.2% | 1067.5 ± 1.2% | 614.3 ± 4.6% | 986.7 ± 0.2% | 736.9 ± 0.1% | 10.867 | 14.461 | 25.129 | 15.645 | 20.948 |
| hex: canterbury/grammar.lsp | 7444 | 14933.5 ± 0.1% | 1508.8 ± 0.2% | 1097.2 ± 0.5% | 665.5 ± 5.7% | 997.4 ± 0.4% | 726.1 ± 0.1% | 9.897 | 13.611 | 22.440 | 14.973 | 20.566 |
| hex: canterbury/kennedy.xls | 524290 | 15632.1 ± 0.2% | 1473.0 ± 0.5% | 1087.0 ± 0.5% | 652.0 ± 1.2% | 991.5 ± 0.4% | 734.9 ± 0.3% | 10.612 | 14.381 | 23.976 | 15.766 | 21.271 |
| hex: canterbury/lcet10.txt | 524290 | 15607.0 ± 0.3% | 1464.9 ± 0.3% | 1086.9 ± 0.3% | 500.2 ± 1.5% | 988.8 ± 0.3% | 733.7 ± 0.4% | 10.654 | 14.360 | 31.205 | 15.783 | 21.273 |
| hex: canterbury/plrabn12.txt | 524290 | 15622.7 ± 0.2% | 1465.3 ± 0.3% | 1083.0 ± 0.3% | 491.1 ± 1.0% | 990.1 ± 0.1% | 732.6 ± 0.3% | 10.662 | 14.426 | 31.809 | 15.778 | 21.325 |
| hex: canterbury/ptt5 | 524290 | 15600.4 ± 0.1% | 1477.9 ± 0.2% | 1090.6 ± 0.5% | 553.2 ± 0.5% | 993.6 ± 1.0% | 733.6 ± 0.2% | 10.556 | 14.304 | 28.201 | 15.702 | 21.264 |
| hex: canterbury/sum | 76482 | 15638.2 ± 0.0% | 1495.2 ± 0.2% | 1103.6 ± 0.1% | 598.0 ± 2.2% | 998.2 ± 0.0% | 744.1 ± 0.2% | 10.459 | 14.170 | 26.150 | 15.667 | 21.016 |
| hex: canterbury/xargs.1 | 8456 | 15006.3 ± 0.1% | 1493.7 ± 0.4% | 1097.3 ± 0.6% | 662.2 ± 5.1% | 996.5 ± 0.6% | 727.4 ± 0.7% | 10.046 | 13.676 | 22.662 | 15.059 | 20.629 |
| hex: canterbury-large/E.coli | 524290 | 15588.6 ± 0.2% | 1470.1 ± 0.2% | 1087.1 ± 0.5% | 672.8 ± 0.1% | 994.4 ± 0.3% | 734.4 ± 0.2% | 10.604 | 14.340 | 23.169 | 15.676 | 21.225 |
| hex: canterbury-large/bible.txt | 524290 | 15630.9 ± 0.1% | 1460.9 ± 0.3% | 1083.1 ± 0.3% | 514.5 ± 1.0% | 989.1 ± 0.5% | 734.3 ± 0.1% | 10.700 | 14.432 | 30.381 | 15.803 | 21.288 |
| hex: canterbury-large/world192.txt | 524290 | 15578.0 ± 0.3% | 1463.5 ± 0.3% | 1082.4 ± 0.4% | 502.1 ± 0.6% | 991.4 ± 0.5% | 734.6 ± 0.3% | 10.644 | 14.393 | 31.028 | 15.714 | 21.205 |
| hex: http/html-1kx1024 | 2099200 | 13604.9 ± 0.5% | 1454.9 ± 0.6% | 1063.0 ± 0.4% | 501.1 ± 0.3% | 982.5 ± 0.6% | 692.0 ± 0.1% | 9.351 | 12.798 | 27.150 | 13.847 | 19.661 |
| hex: http/html-16kx64 | 2097280 | 15187.9 ± 0.8% | 1452.4 ± 0.3% | 1075.3 ± 0.2% | 507.6 ± 0.3% | 999.6 ± 0.3% | 734.2 ± 0.1% | 10.457 | 14.124 | 29.921 | 15.194 | 20.686 |
| hex: http/html-1m | 524290 | 15664.3 ± 0.2% | 1468.7 ± 0.2% | 1083.6 ± 0.4% | 500.5 ± 2.0% | 990.3 ± 0.2% | 733.9 ± 0.5% | 10.665 | 14.456 | 31.295 | 15.818 | 21.345 |
| hex: http/json-1kx1024 | 2099200 | 13558.7 ± 1.1% | 1465.5 ± 0.2% | 1068.6 ± 0.3% | 607.3 ± 0.3% | 988.1 ± 0.2% | 691.9 ± 0.1% | 9.252 | 12.689 | 22.325 | 13.721 | 19.597 |
| hex: http/json-16kx64 | 2097280 | 15179.1 ± 0.5% | 1443.5 ± 0.1% | 1074.7 ± 0.3% | 616.0 ± 0.3% | 993.3 ± 0.3% | 734.3 ± 0.4% | 10.516 | 14.125 | 24.643 | 15.282 | 20.672 |
| hex: http/json-1m | 524290 | 15676.6 ± 0.3% | 1474.2 ± 0.5% | 1087.7 ± 0.2% | 634.1 ± 0.8% | 994.3 ± 0.6% | 734.0 ± 0.5% | 10.634 | 14.413 | 24.723 | 15.767 | 21.357 |
| hex: http/js-1kx1024 | 2099200 | 13640.6 ± 0.6% | 1454.5 ± 0.3% | 1064.6 ± 0.3% | 499.4 ± 0.2% | 983.4 ± 0.1% | 692.3 ± 0.2% | 9.378 | 12.813 | 27.315 | 13.871 | 19.705 |
| hex: http/js-16kx64 | 2097280 | 15194.1 ± 0.5% | 1442.8 ± 0.2% | 1073.2 ± 0.3% | 505.8 ± 0.3% | 997.4 ± 0.5% | 734.6 ± 0.2% | 10.531 | 14.158 | 30.039 | 15.234 | 20.683 |
| hex: http/js-1m | 524290 | 15654.9 ± 0.3% | 1460.2 ± 0.2% | 1081.6 ± 0.4% | 511.5 ± 0.6% | 985.7 ± 0.7% | 732.8 ± 0.6% | 10.721 | 14.474 | 30.604 | 15.882 | 21.363 |
| hex: http/css-1kx1024 | 2099200 | 13629.2 ± 0.6% | 1455.6 ± 0.2% | 1063.6 ± 0.2% | 531.4 ± 0.3% | 983.5 ± 0.2% | 692.3 ± 0.3% | 9.363 | 12.814 | 25.648 | 13.857 | 19.686 |
| hex: http/css-16kx64 | 2097280 | 15199.2 ± 0.3% | 1441.1 ± 0.1% | 1074.3 ± 0.3% | 541.4 ± 0.6% | 998.3 ± 0.5% | 734.7 ± 0.5% | 10.547 | 14.149 | 28.074 | 15.225 | 20.688 |
| hex: http/css-1m | 524290 | 15654.9 ± 0.2% | 1467.3 ± 0.4% | 1085.2 ± 0.2% | 525.7 ± 0.6% | 990.3 ± 0.5% | 733.1 ± 0.5% | 10.669 | 14.426 | 29.779 | 15.808 | 21.353 |
| hex: shuffled/dickens-1m | 524290 | 15602.4 ± 0.2% | 1465.8 ± 0.3% | 1083.4 ± 0.3% | 503.7 ± 0.8% | 988.2 ± 0.7% | 733.2 ± 0.7% | 10.645 | 14.402 | 30.977 | 15.788 | 21.279 |

## Encoding against the baselines, J11's loop unchecked

stdx's encoder with claim J11's loop's runtime safety checks off, as a caller may choose (decision 35). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1523.6 ± 0.6% | 1251.1 ± 0.5% | 1035.9 ± 0.4% | 410.2 ± 0.4% | 448.0 ± 0.2% | 414.8 ± 0.6% | 1.218 | 1.471 | 3.714 | 3.401 | 3.673 |
| qlog records, JSON text sequence | 1467503 | 1288.7 ± 0.6% | 1059.9 ± 0.6% | 779.5 ± 0.9% | 378.5 ± 0.8% | 468.5 ± 1.1% | 278.7 ± 1.9% | 1.216 | 1.653 | 3.405 | 2.751 | 4.623 |
| string: silesia/dickens | 172528 | 7127.1 ± 0.2% | 2820.8 ± 0.2% | 2929.3 ± 1.0% | 430.7 ± 0.7% | 1570.2 ± 0.1% | 1011.3 ± 0.1% | 2.527 | 2.433 | 16.547 | 4.539 | 7.048 |
| string: silesia/nci | 1075110 | 7377.6 ± 6.5% | 3417.6 ± 1.0% | 3100.0 ± 0.7% | 819.6 ± 2.3% | 1852.2 ± 0.3% | 1106.7 ± 0.2% | 2.159 | 2.380 | 9.001 | 3.983 | 6.666 |
| string: silesia/reymont | 1075159 | 3511.6 ± 1.3% | 1991.7 ± 1.0% | 2061.1 ± 0.7% | 451.5 ± 1.5% | 1509.9 ± 0.2% | 948.1 ± 0.4% | 1.763 | 1.704 | 7.778 | 2.326 | 3.704 |
| string: silesia/samba | 97582 | 4594.1 ± 0.9% | 2114.1 ± 0.9% | 3456.2 ± 0.5% | 354.2 ± 0.8% | 1435.2 ± 0.3% | 1054.2 ± 0.3% | 2.173 | 1.329 | 12.971 | 3.201 | 4.358 |
| string: silesia/webster | 1098490 | 4090.5 ± 0.4% | 1876.7 ± 0.7% | 2055.8 ± 0.6% | 441.9 ± 0.6% | 1388.5 ± 0.2% | 644.5 ± 0.4% | 2.180 | 1.990 | 9.256 | 2.946 | 6.347 |
| string: silesia/xml | 1090118 | 6215.0 ± 0.6% | 2864.3 ± 0.5% | 2643.5 ± 0.6% | 607.9 ± 0.5% | 1747.8 ± 0.4% | 920.1 ± 0.4% | 2.170 | 2.351 | 10.224 | 3.556 | 6.754 |
| string: canterbury/alice29.txt | 159425 | 6811.5 ± 1.6% | 2202.7 ± 0.7% | 2766.4 ± 1.3% | 407.7 ± 0.4% | 1463.7 ± 0.3% | 956.5 ± 0.2% | 3.092 | 2.462 | 16.705 | 4.654 | 7.121 |
| string: canterbury/asyoulik.txt | 132198 | 5922.9 ± 2.8% | 1711.2 ± 0.4% | 2371.0 ± 1.1% | 401.5 ± 0.5% | 1337.3 ± 0.2% | 885.4 ± 0.2% | 3.461 | 2.498 | 14.752 | 4.429 | 6.689 |
| string: canterbury/lcet10.txt | 441884 | 6249.5 ± 0.2% | 2561.6 ± 0.5% | 2474.2 ± 1.4% | 469.6 ± 0.8% | 1521.9 ± 0.1% | 983.5 ± 0.2% | 2.440 | 2.526 | 13.309 | 4.106 | 6.354 |
| string: canterbury/plrabn12.txt | 503330 | 5758.8 ± 0.3% | 2056.7 ± 0.3% | 2068.7 ± 0.4% | 421.7 ± 0.7% | 1406.1 ± 0.1% | 929.8 ± 0.7% | 2.800 | 2.784 | 13.655 | 4.095 | 6.194 |
| string: canterbury-large/E.coli | 1048578 | 19205.2 ± 0.6% | 9731.1 ± 2.2% | 3793.5 ± 0.4% | 1472.5 ± 0.4% | 2366.4 ± 0.4% | 1192.5 ± 1.2% | 1.974 | 5.063 | 13.043 | 8.116 | 16.106 |
| string: canterbury-large/bible.txt | 1055886 | 6791.8 ± 0.3% | 4149.7 ± 0.7% | 3021.5 ± 1.5% | 501.9 ± 0.9% | 1987.4 ± 0.3% | 1119.0 ± 0.6% | 1.637 | 2.248 | 13.533 | 3.417 | 6.070 |
| string: canterbury-large/world192.txt | 1103121 | 4036.0 ± 0.3% | 1655.3 ± 0.5% | 2004.2 ± 0.8% | 448.4 ± 0.3% | 1357.8 ± 0.3% | 908.5 ± 0.2% | 2.438 | 2.014 | 9.001 | 2.972 | 4.442 |
| string: http/html-1m | 1058582 | 6810.8 ± 0.3% | 3973.2 ± 1.2% | 3039.8 ± 0.4% | 499.3 ± 1.0% | 1925.0 ± 0.3% | 805.3 ± 0.1% | 1.714 | 2.241 | 13.640 | 3.538 | 8.457 |
| string: http/json-1m | 1190272 | 3297.7 ± 0.4% | 1350.2 ± 0.2% | 1556.2 ± 0.3% | 445.2 ± 0.8% | 961.5 ± 0.5% | 765.7 ± 0.2% | 2.442 | 2.119 | 7.408 | 3.430 | 4.307 |
| string: http/js-1m | 1144362 | 2809.8 ± 0.4% | 1178.8 ± 0.6% | 1624.8 ± 0.3% | 369.5 ± 0.3% | 1092.9 ± 0.2% | 757.7 ± 0.2% | 2.384 | 1.729 | 7.605 | 2.571 | 3.708 |
| string: http/css-1m | 1097820 | 4024.9 ± 1.1% | 1486.7 ± 0.5% | 2150.1 ± 0.8% | 495.3 ± 0.7% | 1368.1 ± 0.1% | 895.3 ± 0.3% | 2.707 | 1.872 | 8.126 | 2.942 | 4.496 |
| string: dickens as Cyrillic and CJK | 1883069 | 3072.2 ± 0.3% | 2340.0 ± 0.5% | 521.1 ± 0.4% | 306.7 ± 0.5% | 562.5 ± 1.6% | 336.1 ± 0.6% | 1.313 | 5.895 | 10.017 | 5.462 | 9.141 |
| hex: silesia/dickens | 524290 | 15683.7 ± 0.3% | 1461.0 ± 0.4% | 1083.5 ± 0.2% | 500.5 ± 0.7% | 988.5 ± 0.3% | 734.9 ± 0.3% | 10.735 | 14.475 | 31.339 | 15.867 | 21.342 |
| hex: silesia/mozilla | 524290 | 15647.2 ± 0.7% | 1471.2 ± 0.2% | 1087.9 ± 0.3% | 441.3 ± 0.2% | 993.9 ± 0.4% | 733.1 ± 0.5% | 10.636 | 14.383 | 35.453 | 15.743 | 21.343 |
| hex: silesia/mr | 524290 | 15547.2 ± 0.8% | 1476.9 ± 0.5% | 1089.1 ± 0.5% | 554.9 ± 3.3% | 992.4 ± 0.2% | 734.2 ± 0.2% | 10.527 | 14.275 | 28.019 | 15.666 | 21.177 |
| hex: silesia/nci | 524290 | 15670.1 ± 0.4% | 1473.4 ± 0.5% | 1087.6 ± 0.3% | 634.5 ± 2.8% | 992.4 ± 0.6% | 733.7 ± 0.5% | 10.635 | 14.408 | 24.697 | 15.790 | 21.357 |
| hex: silesia/ooffice | 524290 | 15667.2 ± 0.2% | 1464.3 ± 0.2% | 1080.7 ± 0.4% | 388.9 ± 0.1% | 990.3 ± 0.5% | 734.4 ± 0.5% | 10.699 | 14.498 | 40.284 | 15.821 | 21.333 |
| hex: silesia/osdb | 524290 | 15641.7 ± 0.2% | 1469.9 ± 0.1% | 1086.2 ± 0.4% | 467.7 ± 0.5% | 990.7 ± 0.4% | 733.7 ± 0.6% | 10.641 | 14.401 | 33.445 | 15.788 | 21.318 |
| hex: silesia/reymont | 524290 | 15651.9 ± 0.3% | 1459.8 ± 0.3% | 1080.5 ± 0.5% | 513.8 ± 1.6% | 989.3 ± 0.6% | 735.5 ± 0.2% | 10.722 | 14.486 | 30.462 | 15.821 | 21.280 |
| hex: silesia/samba | 524290 | 15525.7 ± 0.7% | 1466.8 ± 0.5% | 1085.1 ± 0.4% | 402.6 ± 0.4% | 990.5 ± 0.3% | 734.0 ± 1.3% | 10.585 | 14.309 | 38.568 | 15.675 | 21.154 |
| hex: silesia/sao | 524290 | 15657.1 ± 0.3% | 1463.8 ± 0.3% | 1083.1 ± 0.4% | 333.4 ± 0.4% | 987.2 ± 0.3% | 733.5 ± 0.4% | 10.696 | 14.456 | 46.961 | 15.860 | 21.345 |
| hex: silesia/webster | 524290 | 15623.6 ± 0.7% | 1466.3 ± 0.2% | 1087.0 ± 0.2% | 474.7 ± 0.6% | 987.0 ± 0.6% | 733.8 ± 0.3% | 10.655 | 14.373 | 32.910 | 15.829 | 21.291 |
| hex: silesia/x-ray | 524290 | 15624.1 ± 0.3% | 1473.4 ± 0.4% | 1089.7 ± 0.4% | 445.3 ± 1.0% | 992.0 ± 0.4% | 732.2 ± 0.5% | 10.604 | 14.338 | 35.083 | 15.750 | 21.337 |
| hex: silesia/xml | 524290 | 15640.2 ± 0.7% | 1466.7 ± 0.5% | 1085.2 ± 0.6% | 615.1 ± 0.9% | 992.0 ± 0.4% | 734.2 ± 0.3% | 10.663 | 14.413 | 25.427 | 15.766 | 21.303 |
| hex: canterbury/alice29.txt | 304180 | 15642.1 ± 0.2% | 1470.3 ± 0.7% | 1092.4 ± 0.4% | 505.5 ± 0.9% | 995.0 ± 0.3% | 735.1 ± 0.3% | 10.639 | 14.319 | 30.944 | 15.721 | 21.279 |
| hex: canterbury/asyoulik.txt | 250360 | 15721.5 ± 0.1% | 1478.8 ± 0.6% | 1094.7 ± 0.4% | 500.1 ± 0.3% | 994.4 ± 0.4% | 740.1 ± 0.3% | 10.631 | 14.361 | 31.436 | 15.811 | 21.243 |
| hex: canterbury/cp.html | 49208 | 15635.9 ± 0.0% | 1474.5 ± 0.5% | 1099.6 ± 0.2% | 524.5 ± 1.6% | 1002.9 ± 0.6% | 743.5 ± 0.1% | 10.604 | 14.219 | 29.812 | 15.590 | 21.032 |
| hex: canterbury/fields.c | 22302 | 15456.4 ± 0.0% | 1420.5 ± 1.2% | 1067.5 ± 1.2% | 614.3 ± 4.6% | 986.7 ± 0.2% | 736.9 ± 0.1% | 10.881 | 14.479 | 25.160 | 15.664 | 20.974 |
| hex: canterbury/grammar.lsp | 7444 | 14996.2 ± 0.0% | 1508.8 ± 0.2% | 1097.2 ± 0.5% | 665.5 ± 5.7% | 997.4 ± 0.4% | 726.1 ± 0.1% | 9.939 | 13.668 | 22.535 | 15.036 | 20.653 |
| hex: canterbury/kennedy.xls | 524290 | 15576.1 ± 0.6% | 1473.0 ± 0.5% | 1087.0 ± 0.5% | 652.0 ± 1.2% | 991.5 ± 0.4% | 734.9 ± 0.3% | 10.574 | 14.330 | 23.890 | 15.710 | 21.195 |
| hex: canterbury/lcet10.txt | 524290 | 15627.8 ± 0.2% | 1464.9 ± 0.3% | 1086.9 ± 0.3% | 500.2 ± 1.5% | 988.8 ± 0.3% | 733.7 ± 0.4% | 10.668 | 14.379 | 31.246 | 15.804 | 21.301 |
| hex: canterbury/plrabn12.txt | 524290 | 15637.0 ± 0.3% | 1465.3 ± 0.3% | 1083.0 ± 0.3% | 491.1 ± 1.0% | 990.1 ± 0.1% | 732.6 ± 0.3% | 10.671 | 14.439 | 31.838 | 15.793 | 21.344 |
| hex: canterbury/ptt5 | 524290 | 15637.5 ± 0.3% | 1477.9 ± 0.2% | 1090.6 ± 0.5% | 553.2 ± 0.5% | 993.6 ± 1.0% | 733.6 ± 0.2% | 10.581 | 14.338 | 28.269 | 15.739 | 21.315 |
| hex: canterbury/sum | 76482 | 15652.6 ± 0.0% | 1495.2 ± 0.2% | 1103.6 ± 0.1% | 598.0 ± 2.2% | 998.2 ± 0.0% | 744.1 ± 0.2% | 10.468 | 14.183 | 26.174 | 15.681 | 21.036 |
| hex: canterbury/xargs.1 | 8456 | 15052.2 ± 0.2% | 1493.7 ± 0.4% | 1097.3 ± 0.6% | 662.2 ± 5.1% | 996.5 ± 0.6% | 727.4 ± 0.7% | 10.077 | 13.717 | 22.731 | 15.105 | 20.692 |
| hex: canterbury-large/E.coli | 524290 | 15593.4 ± 0.5% | 1470.1 ± 0.2% | 1087.1 ± 0.5% | 672.8 ± 0.1% | 994.4 ± 0.3% | 734.4 ± 0.2% | 10.607 | 14.344 | 23.176 | 15.681 | 21.232 |
| hex: canterbury-large/bible.txt | 524290 | 15657.9 ± 0.4% | 1460.9 ± 0.3% | 1083.1 ± 0.3% | 514.5 ± 1.0% | 989.1 ± 0.5% | 734.3 ± 0.1% | 10.718 | 14.457 | 30.433 | 15.830 | 21.325 |
| hex: canterbury-large/world192.txt | 524290 | 15545.5 ± 1.1% | 1463.5 ± 0.3% | 1082.4 ± 0.4% | 502.1 ± 0.6% | 991.4 ± 0.5% | 734.6 ± 0.3% | 10.622 | 14.363 | 30.963 | 15.681 | 21.161 |
| hex: http/html-1kx1024 | 2099200 | 13847.4 ± 0.8% | 1454.9 ± 0.6% | 1063.0 ± 0.4% | 501.1 ± 0.3% | 982.5 ± 0.6% | 692.0 ± 0.1% | 9.518 | 13.026 | 27.634 | 14.094 | 20.012 |
| hex: http/html-16kx64 | 2097280 | 15228.1 ± 0.7% | 1452.4 ± 0.3% | 1075.3 ± 0.2% | 507.6 ± 0.3% | 999.6 ± 0.3% | 734.2 ± 0.1% | 10.485 | 14.162 | 30.000 | 15.234 | 20.741 |
| hex: http/html-1m | 524290 | 15648.5 ± 0.2% | 1468.7 ± 0.2% | 1083.6 ± 0.4% | 500.5 ± 2.0% | 990.3 ± 0.2% | 733.9 ± 0.5% | 10.654 | 14.441 | 31.263 | 15.802 | 21.324 |
| hex: http/json-1kx1024 | 2099200 | 13794.3 ± 0.9% | 1465.5 ± 0.2% | 1068.6 ± 0.3% | 607.3 ± 0.3% | 988.1 ± 0.2% | 691.9 ± 0.1% | 9.413 | 12.909 | 22.713 | 13.960 | 19.937 |
| hex: http/json-16kx64 | 2097280 | 15280.3 ± 0.2% | 1443.5 ± 0.1% | 1074.7 ± 0.3% | 616.0 ± 0.3% | 993.3 ± 0.3% | 734.3 ± 0.4% | 10.586 | 14.219 | 24.807 | 15.383 | 20.810 |
| hex: http/json-1m | 524290 | 15673.2 ± 0.2% | 1474.2 ± 0.5% | 1087.7 ± 0.2% | 634.1 ± 0.8% | 994.3 ± 0.6% | 734.0 ± 0.5% | 10.632 | 14.410 | 24.718 | 15.763 | 21.352 |
| hex: http/js-1kx1024 | 2099200 | 13776.5 ± 0.9% | 1454.5 ± 0.3% | 1064.6 ± 0.3% | 499.4 ± 0.2% | 983.4 ± 0.1% | 692.3 ± 0.2% | 9.472 | 12.941 | 27.588 | 14.010 | 19.901 |
| hex: http/js-16kx64 | 2097280 | 15198.8 ± 0.5% | 1442.8 ± 0.2% | 1073.2 ± 0.3% | 505.8 ± 0.3% | 997.4 ± 0.5% | 734.6 ± 0.2% | 10.534 | 14.162 | 30.049 | 15.239 | 20.690 |
| hex: http/js-1m | 524290 | 15674.9 ± 0.6% | 1460.2 ± 0.2% | 1081.6 ± 0.4% | 511.5 ± 0.6% | 985.7 ± 0.7% | 732.8 ± 0.6% | 10.735 | 14.493 | 30.643 | 15.902 | 21.391 |
| hex: http/css-1kx1024 | 2099200 | 13761.2 ± 0.3% | 1455.6 ± 0.2% | 1063.6 ± 0.2% | 531.4 ± 0.3% | 983.5 ± 0.2% | 692.3 ± 0.3% | 9.454 | 12.938 | 25.897 | 13.992 | 19.876 |
| hex: http/css-16kx64 | 2097280 | 15231.5 ± 0.5% | 1441.1 ± 0.1% | 1074.3 ± 0.3% | 541.4 ± 0.6% | 998.3 ± 0.5% | 734.7 ± 0.5% | 10.569 | 14.179 | 28.133 | 15.258 | 20.732 |
| hex: http/css-1m | 524290 | 15666.7 ± 0.1% | 1467.3 ± 0.4% | 1085.2 ± 0.2% | 525.7 ± 0.6% | 990.3 ± 0.5% | 733.1 ± 0.5% | 10.677 | 14.437 | 29.801 | 15.819 | 21.369 |
| hex: shuffled/dickens-1m | 524290 | 15624.8 ± 0.2% | 1465.8 ± 0.3% | 1083.4 ± 0.3% | 503.7 ± 0.8% | 988.2 ± 0.7% | 733.2 ± 0.7% | 10.660 | 14.422 | 31.022 | 15.811 | 21.310 |

## TextReader.next against the baselines

stdx's decoder a token a call through `TextReader.next`, as a caller that reads a text a value at a time calls it (decision 69). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 936.4 ± 0.0% | 929.4 ± 0.2% | 1022.6 ± 0.5% | 301.1 ± 1.1% | 664.0 ± 0.2% | 309.2 ± 1.9% | 1.008 | 0.916 | 3.110 | 1.410 | 3.028 |
| qlog records, JSON text sequence | 1467503 | 781.8 ± 0.9% | 817.9 ± 0.1% | 776.3 ± 1.5% | 244.1 ± 0.4% | 693.8 ± 0.6% | 247.7 ± 0.5% | 0.956 | 1.007 | 3.203 | 1.127 | 3.156 |
| string: silesia/dickens | 172528 | 5054.5 ± 0.4% | 1876.8 ± 0.2% | 2650.6 ± 0.3% | 361.8 ± 0.7% | 2860.1 ± 0.4% | 543.7 ± 1.5% | 2.693 | 1.907 | 13.969 | 1.767 | 9.296 |
| string: silesia/nci | 1075110 | 4307.0 ± 0.4% | 2238.7 ± 0.3% | 2993.0 ± 0.3% | 544.6 ± 0.8% | 2992.3 ± 0.5% | 598.4 ± 2.5% | 1.924 | 1.439 | 7.908 | 1.439 | 7.197 |
| string: silesia/reymont | 1075159 | 3018.8 ± 2.0% | 1819.9 ± 2.1% | 2059.8 ± 0.4% | 374.5 ± 0.9% | 2139.1 ± 0.9% | 534.0 ± 0.9% | 1.659 | 1.466 | 8.060 | 1.411 | 5.653 |
| string: silesia/samba | 97582 | 3496.6 ± 0.9% | 2024.1 ± 0.2% | 2617.8 ± 0.3% | 329.6 ± 0.6% | 1496.2 ± 0.3% | 429.3 ± 0.6% | 1.727 | 1.336 | 10.608 | 2.337 | 8.145 |
| string: silesia/webster | 1098490 | 3678.9 ± 0.7% | 1518.4 ± 0.3% | 2010.3 ± 0.4% | 359.0 ± 0.3% | 2160.2 ± 0.9% | 494.8 ± 1.2% | 2.423 | 1.830 | 10.248 | 1.703 | 7.435 |
| string: silesia/xml | 1090118 | 4807.8 ± 0.5% | 2354.0 ± 1.9% | 2517.5 ± 2.0% | 452.7 ± 1.2% | 2833.3 ± 0.4% | 557.7 ± 1.6% | 2.042 | 1.910 | 10.620 | 1.697 | 8.620 |
| string: canterbury/alice29.txt | 159425 | 4339.7 ± 1.7% | 1598.5 ± 0.3% | 2455.9 ± 0.6% | 342.1 ± 0.8% | 2504.2 ± 0.4% | 503.8 ± 0.5% | 2.715 | 1.767 | 12.685 | 1.733 | 8.614 |
| string: canterbury/asyoulik.txt | 132198 | 3496.7 ± 0.4% | 1459.3 ± 0.3% | 2243.7 ± 0.3% | 335.7 ± 1.5% | 2077.4 ± 0.4% | 456.5 ± 1.9% | 2.396 | 1.558 | 10.416 | 1.683 | 7.659 |
| string: canterbury/lcet10.txt | 441884 | 5133.1 ± 0.3% | 1852.5 ± 0.3% | 2337.9 ± 0.5% | 390.9 ± 0.6% | 2846.0 ± 0.3% | 530.7 ± 1.4% | 2.771 | 2.196 | 13.132 | 1.804 | 9.672 |
| string: canterbury/plrabn12.txt | 503330 | 4147.7 ± 0.3% | 1736.3 ± 0.1% | 2058.1 ± 0.5% | 361.0 ± 1.0% | 2476.6 ± 0.8% | 496.2 ± 1.3% | 2.389 | 2.015 | 11.490 | 1.675 | 8.358 |
| string: canterbury-large/E.coli | 1048578 | 11918.3 ± 0.2% | 3610.7 ± 0.3% | 3252.3 ± 0.3% | 930.2 ± 1.1% | 5969.3 ± 1.2% | 759.4 ± 0.8% | 3.301 | 3.665 | 12.813 | 1.997 | 15.695 |
| string: canterbury-large/bible.txt | 1055886 | 6914.6 ± 1.5% | 2936.2 ± 0.5% | 2835.7 ± 0.6% | 423.5 ± 1.0% | 3751.0 ± 1.4% | 615.4 ± 1.3% | 2.355 | 2.438 | 16.326 | 1.843 | 11.236 |
| string: canterbury-large/world192.txt | 1103121 | 3394.8 ± 0.5% | 1481.2 ± 0.1% | 2013.9 ± 0.5% | 352.8 ± 0.7% | 2107.2 ± 1.4% | 499.6 ± 1.2% | 2.292 | 1.686 | 9.623 | 1.611 | 6.795 |
| string: http/html-1m | 1058582 | 6203.8 ± 1.3% | 2739.6 ± 0.5% | 2688.1 ± 0.6% | 441.8 ± 0.5% | 3469.0 ± 0.5% | 595.6 ± 1.6% | 2.265 | 2.308 | 14.041 | 1.788 | 10.415 |
| string: http/json-1m | 1190272 | 2552.4 ± 0.6% | 877.2 ± 0.4% | 2249.7 ± 0.2% | 391.0 ± 0.5% | 1058.2 ± 0.8% | 441.6 ± 0.5% | 2.910 | 1.135 | 6.527 | 2.412 | 5.780 |
| string: http/js-1m | 1144362 | 2281.0 ± 0.6% | 1028.8 ± 0.2% | 1636.5 ± 0.6% | 321.8 ± 0.4% | 1514.1 ± 0.9% | 416.5 ± 0.2% | 2.217 | 1.394 | 7.089 | 1.507 | 5.477 |
| string: http/css-1m | 1097820 | 2657.9 ± 0.4% | 1677.4 ± 0.2% | 2223.6 ± 0.5% | 407.6 ± 1.1% | 1937.2 ± 1.0% | 486.1 ± 1.4% | 1.584 | 1.195 | 6.521 | 1.372 | 5.468 |
| string: dickens as Cyrillic and CJK | 1883069 | 3074.1 ± 0.2% | 1683.9 ± 0.3% | 894.3 ± 0.2% | 350.1 ± 0.2% | 666.6 ± 1.3% | 158.2 ± 2.2% | 1.826 | 3.438 | 8.780 | 4.612 | 19.432 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1329.7 ± 0.4% | 981.7 ± 0.4% | 1199.6 ± 0.6% | 216.0 ± 0.2% | 473.1 ± 0.9% | 255.4 ± 3.9% | 1.354 | 1.108 | 6.155 | 2.811 | 5.205 |
| hex: silesia/dickens | 524290 | 11964.0 ± 0.4% | 3609.0 ± 0.0% | 3286.2 ± 0.4% | 503.7 ± 0.6% | 6024.0 ± 0.9% | 779.8 ± 3.5% | 3.315 | 3.641 | 23.754 | 1.986 | 15.342 |
| hex: silesia/mozilla | 524290 | 12006.7 ± 0.1% | 3611.4 ± 0.2% | 3285.6 ± 0.4% | 451.1 ± 1.2% | 6121.7 ± 2.0% | 781.5 ± 0.6% | 3.325 | 3.654 | 26.616 | 1.961 | 15.364 |
| hex: silesia/mr | 524290 | 12001.0 ± 0.2% | 3615.4 ± 0.2% | 3286.3 ± 0.4% | 568.6 ± 1.2% | 6094.5 ± 2.4% | 779.8 ± 0.4% | 3.319 | 3.652 | 21.107 | 1.969 | 15.390 |
| hex: silesia/nci | 524290 | 11995.2 ± 0.1% | 3615.4 ± 0.1% | 3284.0 ± 0.3% | 623.6 ± 2.2% | 6092.6 ± 1.4% | 779.6 ± 0.3% | 3.318 | 3.653 | 19.236 | 1.969 | 15.386 |
| hex: silesia/ooffice | 524290 | 11970.0 ± 0.2% | 3612.3 ± 0.4% | 3290.7 ± 0.3% | 397.7 ± 0.4% | 6025.9 ± 1.3% | 780.6 ± 0.4% | 3.314 | 3.638 | 30.096 | 1.986 | 15.334 |
| hex: silesia/osdb | 524290 | 12000.0 ± 0.1% | 3617.0 ± 0.2% | 3290.9 ± 0.4% | 477.1 ± 2.5% | 6112.8 ± 1.2% | 779.5 ± 0.7% | 3.318 | 3.646 | 25.150 | 1.963 | 15.394 |
| hex: silesia/reymont | 524290 | 11978.7 ± 0.3% | 3610.6 ± 0.2% | 3285.1 ± 0.9% | 517.1 ± 1.7% | 6031.1 ± 1.8% | 777.7 ± 1.7% | 3.318 | 3.646 | 23.166 | 1.986 | 15.402 |
| hex: silesia/samba | 524290 | 11989.1 ± 0.1% | 3616.6 ± 0.2% | 3287.3 ± 0.4% | 408.5 ± 0.8% | 6132.1 ± 0.8% | 781.9 ± 0.4% | 3.315 | 3.647 | 29.349 | 1.955 | 15.334 |
| hex: silesia/sao | 524290 | 12007.3 ± 0.1% | 3612.9 ± 0.3% | 3293.0 ± 0.2% | 343.6 ± 0.5% | 6148.6 ± 2.1% | 781.0 ± 0.2% | 3.323 | 3.646 | 34.946 | 1.953 | 15.374 |
| hex: silesia/webster | 524290 | 11991.3 ± 0.0% | 3612.8 ± 0.1% | 3296.0 ± 0.2% | 466.3 ± 1.2% | 6131.5 ± 1.5% | 780.5 ± 0.3% | 3.319 | 3.638 | 25.717 | 1.956 | 15.365 |
| hex: silesia/x-ray | 524290 | 11966.7 ± 0.2% | 3615.0 ± 0.2% | 3291.5 ± 0.4% | 475.1 ± 2.5% | 6009.8 ± 1.3% | 782.5 ± 0.3% | 3.310 | 3.636 | 25.190 | 1.991 | 15.293 |
| hex: silesia/xml | 524290 | 11983.0 ± 0.1% | 3617.1 ± 0.4% | 3287.1 ± 0.4% | 519.8 ± 0.7% | 6135.7 ± 1.0% | 781.3 ± 0.5% | 3.313 | 3.645 | 23.052 | 1.953 | 15.338 |
| hex: canterbury/alice29.txt | 304180 | 12008.1 ± 0.1% | 3627.9 ± 0.1% | 3343.2 ± 0.1% | 508.9 ± 0.6% | 6132.6 ± 0.8% | 780.2 ± 0.7% | 3.310 | 3.592 | 23.597 | 1.958 | 15.391 |
| hex: canterbury/asyoulik.txt | 250360 | 12002.9 ± 0.0% | 3642.1 ± 0.0% | 3372.3 ± 0.1% | 503.1 ± 0.2% | 6135.7 ± 1.6% | 779.7 ± 0.1% | 3.296 | 3.559 | 23.858 | 1.956 | 15.394 |
| hex: canterbury/cp.html | 49208 | 11924.0 ± 0.0% | 3637.6 ± 0.0% | 3279.1 ± 0.4% | 463.3 ± 1.6% | 6261.2 ± 0.5% | 762.1 ± 1.6% | 3.278 | 3.636 | 25.735 | 1.904 | 15.645 |
| hex: canterbury/fields.c | 22302 | 11775.6 ± 0.0% | 3629.2 ± 0.0% | 3371.3 ± 0.3% | 510.7 ± 0.9% | 6254.7 ± 0.3% | 756.9 ± 0.9% | 3.245 | 3.493 | 23.056 | 1.883 | 15.558 |
| hex: canterbury/grammar.lsp | 7444 | 11251.6 ± 0.1% | 3601.9 ± 0.1% | 3358.5 ± 0.3% | 544.1 ± 3.8% | 6167.2 ± 0.6% | 722.4 ± 2.4% | 3.124 | 3.350 | 20.678 | 1.824 | 15.574 |
| hex: canterbury/kennedy.xls | 524290 | 11962.6 ± 0.5% | 3611.9 ± 0.2% | 3281.4 ± 0.3% | 663.4 ± 1.6% | 6017.9 ± 0.8% | 775.0 ± 3.9% | 3.312 | 3.646 | 18.032 | 1.988 | 15.436 |
| hex: canterbury/lcet10.txt | 524290 | 12025.2 ± 0.1% | 3605.4 ± 0.2% | 3291.2 ± 0.2% | 526.9 ± 4.8% | 6148.0 ± 1.5% | 781.7 ± 0.5% | 3.335 | 3.654 | 22.823 | 1.956 | 15.384 |
| hex: canterbury/plrabn12.txt | 524290 | 11988.1 ± 0.1% | 3603.7 ± 0.1% | 3299.4 ± 0.3% | 505.8 ± 2.0% | 6085.1 ± 1.1% | 782.5 ± 0.2% | 3.327 | 3.633 | 23.701 | 1.970 | 15.320 |
| hex: canterbury/ptt5 | 524290 | 11953.3 ± 0.5% | 3606.4 ± 0.3% | 3286.7 ± 0.7% | 560.0 ± 0.9% | 6095.1 ± 0.8% | 779.7 ± 0.8% | 3.314 | 3.637 | 21.346 | 1.961 | 15.330 |
| hex: canterbury/sum | 76482 | 11911.2 ± 0.1% | 3633.8 ± 0.1% | 3362.7 ± 0.2% | 512.6 ± 0.6% | 6170.1 ± 0.8% | 773.8 ± 0.3% | 3.278 | 3.542 | 23.237 | 1.930 | 15.393 |
| hex: canterbury/xargs.1 | 8456 | 11332.9 ± 0.1% | 3601.9 ± 0.0% | 3348.7 ± 0.4% | 483.7 ± 2.2% | 6144.7 ± 0.2% | 756.1 ± 2.5% | 3.146 | 3.384 | 23.431 | 1.844 | 14.988 |
| hex: canterbury-large/E.coli | 524290 | 11955.7 ± 0.2% | 3611.7 ± 0.1% | 3279.6 ± 0.2% | 688.6 ± 0.2% | 6138.2 ± 1.5% | 771.1 ± 4.6% | 3.310 | 3.645 | 17.361 | 1.948 | 15.505 |
| hex: canterbury-large/bible.txt | 524290 | 11981.1 ± 0.3% | 3613.2 ± 0.2% | 3291.8 ± 0.6% | 518.3 ± 0.5% | 6086.2 ± 0.7% | 778.3 ± 0.5% | 3.316 | 3.640 | 23.118 | 1.969 | 15.395 |
| hex: canterbury-large/world192.txt | 524290 | 12012.4 ± 0.1% | 3611.3 ± 0.3% | 3286.0 ± 0.3% | 493.6 ± 1.3% | 6117.4 ± 0.4% | 777.0 ± 0.9% | 3.326 | 3.656 | 24.339 | 1.964 | 15.460 |
| hex: http/html-1kx1024 | 2099200 | 8566.4 ± 5.3% | 3459.7 ± 0.3% | 2833.1 ± 0.6% | 473.8 ± 0.1% | 5172.2 ± 0.7% | 608.5 ± 2.3% | 2.476 | 3.024 | 18.081 | 1.656 | 14.077 |
| hex: http/html-16kx64 | 2097280 | 11741.0 ± 0.2% | 3606.4 ± 0.2% | 3255.1 ± 0.1% | 479.9 ± 2.9% | 6005.2 ± 0.4% | 732.2 ± 2.1% | 3.256 | 3.607 | 24.466 | 1.955 | 16.036 |
| hex: http/html-1m | 524290 | 11985.4 ± 0.2% | 3618.0 ± 0.2% | 3287.5 ± 0.2% | 500.4 ± 1.5% | 6101.9 ± 0.9% | 767.1 ± 3.1% | 3.313 | 3.646 | 23.950 | 1.964 | 15.624 |
| hex: http/json-1kx1024 | 2099200 | 8692.2 ± 4.4% | 3460.7 ± 0.2% | 2829.2 ± 0.9% | 574.0 ± 0.7% | 5074.1 ± 0.8% | 617.2 ± 4.7% | 2.512 | 3.072 | 15.144 | 1.713 | 14.083 |
| hex: http/json-16kx64 | 2097280 | 11747.1 ± 0.3% | 3608.2 ± 0.1% | 3243.8 ± 0.3% | 568.4 ± 1.1% | 6005.5 ± 0.6% | 740.8 ± 1.2% | 3.256 | 3.621 | 20.666 | 1.956 | 15.857 |
| hex: http/json-1m | 524290 | 12013.4 ± 0.1% | 3614.0 ± 0.2% | 3298.1 ± 0.2% | 581.5 ± 0.8% | 6148.4 ± 2.2% | 773.3 ± 3.7% | 3.324 | 3.642 | 20.658 | 1.954 | 15.535 |
| hex: http/js-1kx1024 | 2099200 | 8639.9 ± 5.4% | 3461.0 ± 0.2% | 2816.1 ± 0.5% | 478.5 ± 0.5% | 5053.7 ± 1.3% | 597.0 ± 4.8% | 2.496 | 3.068 | 18.057 | 1.710 | 14.473 |
| hex: http/js-16kx64 | 2097280 | 11727.7 ± 0.5% | 3602.2 ± 0.1% | 3240.6 ± 0.3% | 478.8 ± 1.1% | 6003.4 ± 0.8% | 724.8 ± 2.3% | 3.256 | 3.619 | 24.494 | 1.953 | 16.181 |
| hex: http/js-1m | 524290 | 11961.0 ± 0.2% | 3612.1 ± 0.1% | 3287.8 ± 0.4% | 501.2 ± 1.2% | 6084.9 ± 1.2% | 765.6 ± 2.4% | 3.311 | 3.638 | 23.866 | 1.966 | 15.623 |
| hex: http/css-1kx1024 | 2099200 | 8696.5 ± 5.8% | 3456.6 ± 0.3% | 2816.4 ± 0.3% | 487.6 ± 1.2% | 5072.0 ± 1.2% | 610.3 ± 1.4% | 2.516 | 3.088 | 17.837 | 1.715 | 14.250 |
| hex: http/css-16kx64 | 2097280 | 11737.5 ± 0.5% | 3602.0 ± 0.3% | 3239.9 ± 0.3% | 485.3 ± 2.9% | 6017.7 ± 0.3% | 728.4 ± 2.4% | 3.259 | 3.623 | 24.186 | 1.951 | 16.115 |
| hex: http/css-1m | 524290 | 11981.5 ± 0.5% | 3614.0 ± 0.2% | 3285.9 ± 0.2% | 499.9 ± 1.3% | 6174.6 ± 0.4% | 763.8 ± 3.5% | 3.315 | 3.646 | 23.966 | 1.940 | 15.687 |
| hex: shuffled/dickens-1m | 524290 | 12009.4 ± 0.1% | 3613.2 ± 0.2% | 3289.0 ± 0.3% | 513.6 ± 0.5% | 6144.1 ± 0.6% | 776.0 ± 1.3% | 3.324 | 3.651 | 23.383 | 1.955 | 15.477 |

## TextReader.next_items against the baselines

stdx's decoder a slice of tokens a call through `TextReader.next_items`, as a caller that reads a text's values in a loop calls it (decision 79). Octets are the text's. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1013.7 ± 0.1% | 929.4 ± 0.2% | 1022.6 ± 0.5% | 301.1 ± 1.1% | 664.0 ± 0.2% | 309.2 ± 1.9% | 1.091 | 0.991 | 3.367 | 1.527 | 3.278 |
| qlog records, JSON text sequence | 1467503 | 836.3 ± 0.4% | 817.9 ± 0.1% | 776.3 ± 1.5% | 244.1 ± 0.4% | 693.8 ± 0.6% | 247.7 ± 0.5% | 1.023 | 1.077 | 3.426 | 1.205 | 3.376 |
| string: silesia/dickens | 172528 | 5058.7 ± 0.4% | 1876.8 ± 0.2% | 2650.6 ± 0.3% | 361.8 ± 0.7% | 2860.1 ± 0.4% | 543.7 ± 1.5% | 2.695 | 1.909 | 13.980 | 1.769 | 9.304 |
| string: silesia/nci | 1075110 | 4304.6 ± 0.4% | 2238.7 ± 0.3% | 2993.0 ± 0.3% | 544.6 ± 0.8% | 2992.3 ± 0.5% | 598.4 ± 2.5% | 1.923 | 1.438 | 7.903 | 1.439 | 7.193 |
| string: silesia/reymont | 1075159 | 3017.8 ± 2.1% | 1819.9 ± 2.1% | 2059.8 ± 0.4% | 374.5 ± 0.9% | 2139.1 ± 0.9% | 534.0 ± 0.9% | 1.658 | 1.465 | 8.057 | 1.411 | 5.651 |
| string: silesia/samba | 97582 | 3509.4 ± 0.5% | 2024.1 ± 0.2% | 2617.8 ± 0.3% | 329.6 ± 0.6% | 1496.2 ± 0.3% | 429.3 ± 0.6% | 1.734 | 1.341 | 10.647 | 2.346 | 8.174 |
| string: silesia/webster | 1098490 | 3670.0 ± 0.6% | 1518.4 ± 0.3% | 2010.3 ± 0.4% | 359.0 ± 0.3% | 2160.2 ± 0.9% | 494.8 ± 1.2% | 2.417 | 1.826 | 10.223 | 1.699 | 7.417 |
| string: silesia/xml | 1090118 | 4806.8 ± 0.7% | 2354.0 ± 1.9% | 2517.5 ± 2.0% | 452.7 ± 1.2% | 2833.3 ± 0.4% | 557.7 ± 1.6% | 2.042 | 1.909 | 10.618 | 1.697 | 8.618 |
| string: canterbury/alice29.txt | 159425 | 4359.1 ± 1.0% | 1598.5 ± 0.3% | 2455.9 ± 0.6% | 342.1 ± 0.8% | 2504.2 ± 0.4% | 503.8 ± 0.5% | 2.727 | 1.775 | 12.742 | 1.741 | 8.652 |
| string: canterbury/asyoulik.txt | 132198 | 3503.8 ± 0.4% | 1459.3 ± 0.3% | 2243.7 ± 0.3% | 335.7 ± 1.5% | 2077.4 ± 0.4% | 456.5 ± 1.9% | 2.401 | 1.562 | 10.437 | 1.687 | 7.675 |
| string: canterbury/lcet10.txt | 441884 | 5130.4 ± 0.3% | 1852.5 ± 0.3% | 2337.9 ± 0.5% | 390.9 ± 0.6% | 2846.0 ± 0.3% | 530.7 ± 1.4% | 2.769 | 2.194 | 13.125 | 1.803 | 9.666 |
| string: canterbury/plrabn12.txt | 503330 | 4138.5 ± 0.4% | 1736.3 ± 0.1% | 2058.1 ± 0.5% | 361.0 ± 1.0% | 2476.6 ± 0.8% | 496.2 ± 1.3% | 2.384 | 2.011 | 11.465 | 1.671 | 8.340 |
| string: canterbury-large/E.coli | 1048578 | 11931.9 ± 0.2% | 3610.7 ± 0.3% | 3252.3 ± 0.3% | 930.2 ± 1.1% | 5969.3 ± 1.2% | 759.4 ± 0.8% | 3.305 | 3.669 | 12.827 | 1.999 | 15.713 |
| string: canterbury-large/bible.txt | 1055886 | 6923.1 ± 1.5% | 2936.2 ± 0.5% | 2835.7 ± 0.6% | 423.5 ± 1.0% | 3751.0 ± 1.4% | 615.4 ± 1.3% | 2.358 | 2.441 | 16.346 | 1.846 | 11.249 |
| string: canterbury-large/world192.txt | 1103121 | 3395.4 ± 0.6% | 1481.2 ± 0.1% | 2013.9 ± 0.5% | 352.8 ± 0.7% | 2107.2 ± 1.4% | 499.6 ± 1.2% | 2.292 | 1.686 | 9.625 | 1.611 | 6.796 |
| string: http/html-1m | 1058582 | 6227.3 ± 2.2% | 2739.6 ± 0.5% | 2688.1 ± 0.6% | 441.8 ± 0.5% | 3469.0 ± 0.5% | 595.6 ± 1.6% | 2.273 | 2.317 | 14.094 | 1.795 | 10.455 |
| string: http/json-1m | 1190272 | 2554.4 ± 0.7% | 877.2 ± 0.4% | 2249.7 ± 0.2% | 391.0 ± 0.5% | 1058.2 ± 0.8% | 441.6 ± 0.5% | 2.912 | 1.135 | 6.532 | 2.414 | 5.784 |
| string: http/js-1m | 1144362 | 2280.4 ± 0.2% | 1028.8 ± 0.2% | 1636.5 ± 0.6% | 321.8 ± 0.4% | 1514.1 ± 0.9% | 416.5 ± 0.2% | 2.217 | 1.393 | 7.087 | 1.506 | 5.475 |
| string: http/css-1m | 1097820 | 2655.7 ± 0.4% | 1677.4 ± 0.2% | 2223.6 ± 0.5% | 407.6 ± 1.1% | 1937.2 ± 1.0% | 486.1 ± 1.4% | 1.583 | 1.194 | 6.515 | 1.371 | 5.463 |
| string: dickens as Cyrillic and CJK | 1883069 | 3074.1 ± 0.2% | 1683.9 ± 0.3% | 894.3 ± 0.2% | 350.1 ± 0.2% | 666.6 ± 1.3% | 158.2 ± 2.2% | 1.826 | 3.438 | 8.780 | 4.612 | 19.432 |
| string: dickens as Cyrillic and CJK, as \u escapes | 5075485 | 1330.1 ± 0.1% | 981.7 ± 0.4% | 1199.6 ± 0.6% | 216.0 ± 0.2% | 473.1 ± 0.9% | 255.4 ± 3.9% | 1.355 | 1.109 | 6.157 | 2.812 | 5.207 |
| hex: silesia/dickens | 524290 | 11956.8 ± 0.2% | 3609.0 ± 0.0% | 3286.2 ± 0.4% | 503.7 ± 0.6% | 6024.0 ± 0.9% | 779.8 ± 3.5% | 3.313 | 3.638 | 23.740 | 1.985 | 15.333 |
| hex: silesia/mozilla | 524290 | 12011.7 ± 0.1% | 3611.4 ± 0.2% | 3285.6 ± 0.4% | 451.1 ± 1.2% | 6121.7 ± 2.0% | 781.5 ± 0.6% | 3.326 | 3.656 | 26.627 | 1.962 | 15.370 |
| hex: silesia/mr | 524290 | 12003.1 ± 0.1% | 3615.4 ± 0.2% | 3286.3 ± 0.4% | 568.6 ± 1.2% | 6094.5 ± 2.4% | 779.8 ± 0.4% | 3.320 | 3.653 | 21.110 | 1.969 | 15.393 |
| hex: silesia/nci | 524290 | 11978.4 ± 0.2% | 3615.4 ± 0.1% | 3284.0 ± 0.3% | 623.6 ± 2.2% | 6092.6 ± 1.4% | 779.6 ± 0.3% | 3.313 | 3.648 | 19.209 | 1.966 | 15.364 |
| hex: silesia/ooffice | 524290 | 11977.5 ± 0.1% | 3612.3 ± 0.4% | 3290.7 ± 0.3% | 397.7 ± 0.4% | 6025.9 ± 1.3% | 780.6 ± 0.4% | 3.316 | 3.640 | 30.115 | 1.988 | 15.344 |
| hex: silesia/osdb | 524290 | 12007.3 ± 0.0% | 3617.0 ± 0.2% | 3290.9 ± 0.4% | 477.1 ± 2.5% | 6112.8 ± 1.2% | 779.5 ± 0.7% | 3.320 | 3.649 | 25.166 | 1.964 | 15.404 |
| hex: silesia/reymont | 524290 | 11905.5 ± 0.2% | 3610.6 ± 0.2% | 3285.1 ± 0.9% | 517.1 ± 1.7% | 6031.1 ± 1.8% | 777.7 ± 1.7% | 3.297 | 3.624 | 23.024 | 1.974 | 15.308 |
| hex: silesia/samba | 524290 | 12005.4 ± 0.2% | 3616.6 ± 0.2% | 3287.3 ± 0.4% | 408.5 ± 0.8% | 6132.1 ± 0.8% | 781.9 ± 0.4% | 3.319 | 3.652 | 29.389 | 1.958 | 15.355 |
| hex: silesia/sao | 524290 | 12008.5 ± 0.5% | 3612.9 ± 0.3% | 3293.0 ± 0.2% | 343.6 ± 0.5% | 6148.6 ± 2.1% | 781.0 ± 0.2% | 3.324 | 3.647 | 34.950 | 1.953 | 15.376 |
| hex: silesia/webster | 524290 | 12007.0 ± 0.0% | 3612.8 ± 0.1% | 3296.0 ± 0.2% | 466.3 ± 1.2% | 6131.5 ± 1.5% | 780.5 ± 0.3% | 3.323 | 3.643 | 25.750 | 1.958 | 15.385 |
| hex: silesia/x-ray | 524290 | 11967.5 ± 0.3% | 3615.0 ± 0.2% | 3291.5 ± 0.4% | 475.1 ± 2.5% | 6009.8 ± 1.3% | 782.5 ± 0.3% | 3.311 | 3.636 | 25.191 | 1.991 | 15.294 |
| hex: silesia/xml | 524290 | 11980.2 ± 0.4% | 3617.1 ± 0.4% | 3287.1 ± 0.4% | 519.8 ± 0.7% | 6135.7 ± 1.0% | 781.3 ± 0.5% | 3.312 | 3.645 | 23.047 | 1.953 | 15.334 |
| hex: canterbury/alice29.txt | 304180 | 12013.7 ± 0.1% | 3627.9 ± 0.1% | 3343.2 ± 0.1% | 508.9 ± 0.6% | 6132.6 ± 0.8% | 780.2 ± 0.7% | 3.311 | 3.593 | 23.608 | 1.959 | 15.398 |
| hex: canterbury/asyoulik.txt | 250360 | 12003.6 ± 0.3% | 3642.1 ± 0.0% | 3372.3 ± 0.1% | 503.1 ± 0.2% | 6135.7 ± 1.6% | 779.7 ± 0.1% | 3.296 | 3.559 | 23.860 | 1.956 | 15.395 |
| hex: canterbury/cp.html | 49208 | 11924.5 ± 0.1% | 3637.6 ± 0.0% | 3279.1 ± 0.4% | 463.3 ± 1.6% | 6261.2 ± 0.5% | 762.1 ± 1.6% | 3.278 | 3.637 | 25.736 | 1.905 | 15.646 |
| hex: canterbury/fields.c | 22302 | 11779.3 ± 0.0% | 3629.2 ± 0.0% | 3371.3 ± 0.3% | 510.7 ± 0.9% | 6254.7 ± 0.3% | 756.9 ± 0.9% | 3.246 | 3.494 | 23.064 | 1.883 | 15.563 |
| hex: canterbury/grammar.lsp | 7444 | 11313.2 ± 0.1% | 3601.9 ± 0.1% | 3358.5 ± 0.3% | 544.1 ± 3.8% | 6167.2 ± 0.6% | 722.4 ± 2.4% | 3.141 | 3.369 | 20.791 | 1.834 | 15.660 |
| hex: canterbury/kennedy.xls | 524290 | 11960.3 ± 0.2% | 3611.9 ± 0.2% | 3281.4 ± 0.3% | 663.4 ± 1.6% | 6017.9 ± 0.8% | 775.0 ± 3.9% | 3.311 | 3.645 | 18.028 | 1.987 | 15.433 |
| hex: canterbury/lcet10.txt | 524290 | 12026.4 ± 0.1% | 3605.4 ± 0.2% | 3291.2 ± 0.2% | 526.9 ± 4.8% | 6148.0 ± 1.5% | 781.7 ± 0.5% | 3.336 | 3.654 | 22.825 | 1.956 | 15.385 |
| hex: canterbury/plrabn12.txt | 524290 | 11997.2 ± 0.1% | 3603.7 ± 0.1% | 3299.4 ± 0.3% | 505.8 ± 2.0% | 6085.1 ± 1.1% | 782.5 ± 0.2% | 3.329 | 3.636 | 23.719 | 1.972 | 15.331 |
| hex: canterbury/ptt5 | 524290 | 11941.9 ± 0.2% | 3606.4 ± 0.3% | 3286.7 ± 0.7% | 560.0 ± 0.9% | 6095.1 ± 0.8% | 779.7 ± 0.8% | 3.311 | 3.633 | 21.326 | 1.959 | 15.316 |
| hex: canterbury/sum | 76482 | 11910.6 ± 0.2% | 3633.8 ± 0.1% | 3362.7 ± 0.2% | 512.6 ± 0.6% | 6170.1 ± 0.8% | 773.8 ± 0.3% | 3.278 | 3.542 | 23.236 | 1.930 | 15.392 |
| hex: canterbury/xargs.1 | 8456 | 11337.3 ± 0.0% | 3601.9 ± 0.0% | 3348.7 ± 0.4% | 483.7 ± 2.2% | 6144.7 ± 0.2% | 756.1 ± 2.5% | 3.148 | 3.386 | 23.440 | 1.845 | 14.994 |
| hex: canterbury-large/E.coli | 524290 | 11965.1 ± 0.2% | 3611.7 ± 0.1% | 3279.6 ± 0.2% | 688.6 ± 0.2% | 6138.2 ± 1.5% | 771.1 ± 4.6% | 3.313 | 3.648 | 17.375 | 1.949 | 15.517 |
| hex: canterbury-large/bible.txt | 524290 | 11987.8 ± 0.2% | 3613.2 ± 0.2% | 3291.8 ± 0.6% | 518.3 ± 0.5% | 6086.2 ± 0.7% | 778.3 ± 0.5% | 3.318 | 3.642 | 23.131 | 1.970 | 15.403 |
| hex: canterbury-large/world192.txt | 524290 | 12013.7 ± 0.1% | 3611.3 ± 0.3% | 3286.0 ± 0.3% | 493.6 ± 1.3% | 6117.4 ± 0.4% | 777.0 ± 0.9% | 3.327 | 3.656 | 24.341 | 1.964 | 15.462 |
| hex: http/html-1kx1024 | 2099200 | 8586.0 ± 5.8% | 3459.7 ± 0.3% | 2833.1 ± 0.6% | 473.8 ± 0.1% | 5172.2 ± 0.7% | 608.5 ± 2.3% | 2.482 | 3.031 | 18.123 | 1.660 | 14.110 |
| hex: http/html-16kx64 | 2097280 | 11742.0 ± 0.3% | 3606.4 ± 0.2% | 3255.1 ± 0.1% | 479.9 ± 2.9% | 6005.2 ± 0.4% | 732.2 ± 2.1% | 3.256 | 3.607 | 24.468 | 1.955 | 16.037 |
| hex: http/html-1m | 524290 | 11969.4 ± 0.1% | 3618.0 ± 0.2% | 3287.5 ± 0.2% | 500.4 ± 1.5% | 6101.9 ± 0.9% | 767.1 ± 3.1% | 3.308 | 3.641 | 23.918 | 1.962 | 15.604 |
| hex: http/json-1kx1024 | 2099200 | 8728.0 ± 5.7% | 3460.7 ± 0.2% | 2829.2 ± 0.9% | 574.0 ± 0.7% | 5074.1 ± 0.8% | 617.2 ± 4.7% | 2.522 | 3.085 | 15.206 | 1.720 | 14.140 |
| hex: http/json-16kx64 | 2097280 | 11736.5 ± 0.3% | 3608.2 ± 0.1% | 3243.8 ± 0.3% | 568.4 ± 1.1% | 6005.5 ± 0.6% | 740.8 ± 1.2% | 3.253 | 3.618 | 20.648 | 1.954 | 15.842 |
| hex: http/json-1m | 524290 | 12020.0 ± 0.1% | 3614.0 ± 0.2% | 3298.1 ± 0.2% | 581.5 ± 0.8% | 6148.4 ± 2.2% | 773.3 ± 3.7% | 3.326 | 3.644 | 20.669 | 1.955 | 15.544 |
| hex: http/js-1kx1024 | 2099200 | 8685.6 ± 5.5% | 3461.0 ± 0.2% | 2816.1 ± 0.5% | 478.5 ± 0.5% | 5053.7 ± 1.3% | 597.0 ± 4.8% | 2.510 | 3.084 | 18.152 | 1.719 | 14.549 |
| hex: http/js-16kx64 | 2097280 | 11718.8 ± 0.3% | 3602.2 ± 0.1% | 3240.6 ± 0.3% | 478.8 ± 1.1% | 6003.4 ± 0.8% | 724.8 ± 2.3% | 3.253 | 3.616 | 24.475 | 1.952 | 16.168 |
| hex: http/js-1m | 524290 | 11964.8 ± 0.2% | 3612.1 ± 0.1% | 3287.8 ± 0.4% | 501.2 ± 1.2% | 6084.9 ± 1.2% | 765.6 ± 2.4% | 3.312 | 3.639 | 23.873 | 1.966 | 15.628 |
| hex: http/css-1kx1024 | 2099200 | 8652.8 ± 6.6% | 3456.6 ± 0.3% | 2816.4 ± 0.3% | 487.6 ± 1.2% | 5072.0 ± 1.2% | 610.3 ± 1.4% | 2.503 | 3.072 | 17.747 | 1.706 | 14.178 |
| hex: http/css-16kx64 | 2097280 | 11733.8 ± 0.3% | 3602.0 ± 0.3% | 3239.9 ± 0.3% | 485.3 ± 2.9% | 6017.7 ± 0.3% | 728.4 ± 2.4% | 3.258 | 3.622 | 24.178 | 1.950 | 16.109 |
| hex: http/css-1m | 524290 | 11997.8 ± 0.1% | 3614.0 ± 0.2% | 3285.9 ± 0.2% | 499.9 ± 1.3% | 6174.6 ± 0.4% | 763.8 ± 3.5% | 3.320 | 3.651 | 23.999 | 1.943 | 15.708 |
| hex: shuffled/dickens-1m | 524290 | 12017.5 ± 0.1% | 3613.2 ± 0.2% | 3289.0 ± 0.3% | 513.6 ± 0.5% | 6144.1 ± 0.6% | 776.0 ± 1.3% | 3.326 | 3.654 | 23.399 | 1.956 | 15.487 |

## TextWriter's methods against the baselines

stdx's encoder a token a call through `TextWriter`'s methods, as a caller that writes a text a value at a time calls it (decision 69). Octets are the ones stdx writes. A row named `<file>x<count>` codes that many slices of the file's 1 MiB payload, one after another, each as a stream of its own (decision 45). A row that repeats one file of 256 KiB or less measures an input the branch predictor has learned, the shorter the file the more: canterbury/alice29.txt, canterbury/asyoulik.txt, canterbury/cp.html, canterbury/fields.c, canterbury/grammar.lsp, canterbury/sum, canterbury/xargs.1.

| Workload | Octets | stdx, MB/s | simdjson, MB/s | yyjson, MB/s | std.json, MB/s | serde_json, MB/s | Go jsontext, MB/s | stdx / simdjson | stdx / yyjson | stdx / std.json | stdx / serde_json | stdx / Go jsontext |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CLDR supplemental, 34 texts | 920675 | 1350.0 ± 0.3% | 1251.1 ± 0.5% | 1035.9 ± 0.4% | 410.2 ± 0.4% | 448.0 ± 0.2% | 414.8 ± 0.6% | 1.079 | 1.303 | 3.291 | 3.014 | 3.255 |
| qlog records, JSON text sequence | 1467503 | 1049.4 ± 0.5% | 1059.9 ± 0.6% | 779.5 ± 0.9% | 378.5 ± 0.8% | 468.5 ± 1.1% | 278.7 ± 1.9% | 0.990 | 1.346 | 2.772 | 2.240 | 3.765 |
| string: silesia/dickens | 172528 | 6912.4 ± 0.6% | 2820.8 ± 0.2% | 2929.3 ± 1.0% | 430.7 ± 0.7% | 1570.2 ± 0.1% | 1011.3 ± 0.1% | 2.451 | 2.360 | 16.048 | 4.402 | 6.835 |
| string: silesia/nci | 1075110 | 7302.9 ± 0.4% | 3417.6 ± 1.0% | 3100.0 ± 0.7% | 819.6 ± 2.3% | 1852.2 ± 0.3% | 1106.7 ± 0.2% | 2.137 | 2.356 | 8.910 | 3.943 | 6.599 |
| string: silesia/reymont | 1075159 | 3334.2 ± 1.6% | 1991.7 ± 1.0% | 2061.1 ± 0.7% | 451.5 ± 1.5% | 1509.9 ± 0.2% | 948.1 ± 0.4% | 1.674 | 1.618 | 7.385 | 2.208 | 3.517 |
| string: silesia/samba | 97582 | 4204.8 ± 0.7% | 2114.1 ± 0.9% | 3456.2 ± 0.5% | 354.2 ± 0.8% | 1435.2 ± 0.3% | 1054.2 ± 0.3% | 1.989 | 1.217 | 11.871 | 2.930 | 3.989 |
| string: silesia/webster | 1098490 | 4067.8 ± 0.1% | 1876.7 ± 0.7% | 2055.8 ± 0.6% | 441.9 ± 0.6% | 1388.5 ± 0.2% | 644.5 ± 0.4% | 2.168 | 1.979 | 9.204 | 2.930 | 6.312 |
| string: silesia/xml | 1090118 | 6129.2 ± 0.5% | 2864.3 ± 0.5% | 2643.5 ± 0.6% | 607.9 ± 0.5% | 1747.8 ± 0.4% | 920.1 ± 0.4% | 2.140 | 2.319 | 10.083 | 3.507 | 6.661 |
| string: canterbury/alice29.txt | 159425 | 6432.8 ± 1.7% | 2202.7 ± 0.7% | 2766.4 ± 1.3% | 407.7 ± 0.4% | 1463.7 ± 0.3% | 956.5 ± 0.2% | 2.920 | 2.325 | 15.776 | 4.395 | 6.725 |
| string: canterbury/asyoulik.txt | 132198 | 5656.4 ± 0.4% | 1711.2 ± 0.4% | 2371.0 ± 1.1% | 401.5 ± 0.5% | 1337.3 ± 0.2% | 885.4 ± 0.2% | 3.306 | 2.386 | 14.088 | 4.230 | 6.388 |
| string: canterbury/lcet10.txt | 441884 | 6254.2 ± 0.8% | 2561.6 ± 0.5% | 2474.2 ± 1.4% | 469.6 ± 0.8% | 1521.9 ± 0.1% | 983.5 ± 0.2% | 2.441 | 2.528 | 13.319 | 4.109 | 6.359 |
| string: canterbury/plrabn12.txt | 503330 | 5724.5 ± 0.4% | 2056.7 ± 0.3% | 2068.7 ± 0.4% | 421.7 ± 0.7% | 1406.1 ± 0.1% | 929.8 ± 0.7% | 2.783 | 2.767 | 13.574 | 4.071 | 6.157 |
| string: canterbury-large/E.coli | 1048578 | 19165.7 ± 0.4% | 9731.1 ± 2.2% | 3793.5 ± 0.4% | 1472.5 ± 0.4% | 2366.4 ± 0.4% | 1192.5 ± 1.2% | 1.970 | 5.052 | 13.016 | 8.099 | 16.072 |
| string: canterbury-large/bible.txt | 1055886 | 6792.8 ± 0.5% | 4149.7 ± 0.7% | 3021.5 ± 1.5% | 501.9 ± 0.9% | 1987.4 ± 0.3% | 1119.0 ± 0.6% | 1.637 | 2.248 | 13.535 | 3.418 | 6.071 |
| string: canterbury-large/world192.txt | 1103121 | 4060.4 ± 0.6% | 1655.3 ± 0.5% | 2004.2 ± 0.8% | 448.4 ± 0.3% | 1357.8 ± 0.3% | 908.5 ± 0.2% | 2.453 | 2.026 | 9.055 | 2.990 | 4.469 |
| string: http/html-1m | 1058582 | 6784.5 ± 0.1% | 3973.2 ± 1.2% | 3039.8 ± 0.4% | 499.3 ± 1.0% | 1925.0 ± 0.3% | 805.3 ± 0.1% | 1.708 | 2.232 | 13.587 | 3.524 | 8.425 |
| string: http/json-1m | 1190272 | 3167.0 ± 0.2% | 1350.2 ± 0.2% | 1556.2 ± 0.3% | 445.2 ± 0.8% | 961.5 ± 0.5% | 765.7 ± 0.2% | 2.346 | 2.035 | 7.114 | 3.294 | 4.136 |
| string: http/js-1m | 1144362 | 2778.3 ± 0.4% | 1178.8 ± 0.6% | 1624.8 ± 0.3% | 369.5 ± 0.3% | 1092.9 ± 0.2% | 757.7 ± 0.2% | 2.357 | 1.710 | 7.519 | 2.542 | 3.667 |
| string: http/css-1m | 1097820 | 4008.6 ± 0.3% | 1486.7 ± 0.5% | 2150.1 ± 0.8% | 495.3 ± 0.7% | 1368.1 ± 0.1% | 895.3 ± 0.3% | 2.696 | 1.864 | 8.093 | 2.930 | 4.478 |
| string: dickens as Cyrillic and CJK | 1883069 | 3073.7 ± 0.4% | 2340.0 ± 0.5% | 521.1 ± 0.4% | 306.7 ± 0.5% | 562.5 ± 1.6% | 336.1 ± 0.6% | 1.314 | 5.898 | 10.022 | 5.465 | 9.146 |
| hex: silesia/dickens | 524290 | 15688.2 ± 0.2% | 1461.0 ± 0.4% | 1083.5 ± 0.2% | 500.5 ± 0.7% | 988.5 ± 0.3% | 734.9 ± 0.3% | 10.738 | 14.479 | 31.348 | 15.871 | 21.348 |
| hex: silesia/mozilla | 524290 | 15673.6 ± 0.6% | 1471.2 ± 0.2% | 1087.9 ± 0.3% | 441.3 ± 0.2% | 993.9 ± 0.4% | 733.1 ± 0.5% | 10.654 | 14.408 | 35.513 | 15.770 | 21.379 |
| hex: silesia/mr | 524290 | 15551.7 ± 0.2% | 1476.9 ± 0.5% | 1089.1 ± 0.5% | 554.9 ± 3.3% | 992.4 ± 0.2% | 734.2 ± 0.2% | 10.530 | 14.279 | 28.027 | 15.671 | 21.183 |
| hex: silesia/nci | 524290 | 15674.3 ± 0.2% | 1473.4 ± 0.5% | 1087.6 ± 0.3% | 634.5 ± 2.8% | 992.4 ± 0.6% | 733.7 ± 0.5% | 10.638 | 14.412 | 24.704 | 15.794 | 21.363 |
| hex: silesia/ooffice | 524290 | 15660.5 ± 0.2% | 1464.3 ± 0.2% | 1080.7 ± 0.4% | 388.9 ± 0.1% | 990.3 ± 0.5% | 734.4 ± 0.5% | 10.695 | 14.492 | 40.266 | 15.815 | 21.324 |
| hex: silesia/osdb | 524290 | 15646.2 ± 0.2% | 1469.9 ± 0.1% | 1086.2 ± 0.4% | 467.7 ± 0.5% | 990.7 ± 0.4% | 733.7 ± 0.6% | 10.644 | 14.405 | 33.454 | 15.792 | 21.324 |
| hex: silesia/reymont | 524290 | 15633.7 ± 0.4% | 1459.8 ± 0.3% | 1080.5 ± 0.5% | 513.8 ± 1.6% | 989.3 ± 0.6% | 735.5 ± 0.2% | 10.709 | 14.469 | 30.427 | 15.803 | 21.255 |
| hex: silesia/samba | 524290 | 15546.9 ± 0.6% | 1466.8 ± 0.5% | 1085.1 ± 0.4% | 402.6 ± 0.4% | 990.5 ± 0.3% | 734.0 ± 1.3% | 10.599 | 14.328 | 38.620 | 15.696 | 21.182 |
| hex: silesia/sao | 524290 | 15667.9 ± 0.4% | 1463.8 ± 0.3% | 1083.1 ± 0.4% | 333.4 ± 0.4% | 987.2 ± 0.3% | 733.5 ± 0.4% | 10.703 | 14.466 | 46.993 | 15.871 | 21.360 |
| hex: silesia/webster | 524290 | 15618.8 ± 0.6% | 1466.3 ± 0.2% | 1087.0 ± 0.2% | 474.7 ± 0.6% | 987.0 ± 0.6% | 733.8 ± 0.3% | 10.652 | 14.369 | 32.900 | 15.824 | 21.284 |
| hex: silesia/x-ray | 524290 | 15649.4 ± 0.2% | 1473.4 ± 0.4% | 1089.7 ± 0.4% | 445.3 ± 1.0% | 992.0 ± 0.4% | 732.2 ± 0.5% | 10.621 | 14.361 | 35.140 | 15.776 | 21.372 |
| hex: silesia/xml | 524290 | 15637.1 ± 0.2% | 1466.7 ± 0.5% | 1085.2 ± 0.6% | 615.1 ± 0.9% | 992.0 ± 0.4% | 734.2 ± 0.3% | 10.661 | 14.410 | 25.422 | 15.763 | 21.299 |
| hex: canterbury/alice29.txt | 304180 | 15668.4 ± 0.2% | 1470.3 ± 0.7% | 1092.4 ± 0.4% | 505.5 ± 0.9% | 995.0 ± 0.3% | 735.1 ± 0.3% | 10.657 | 14.343 | 30.996 | 15.747 | 21.315 |
| hex: canterbury/asyoulik.txt | 250360 | 15721.2 ± 0.1% | 1478.8 ± 0.6% | 1094.7 ± 0.4% | 500.1 ± 0.3% | 994.4 ± 0.4% | 740.1 ± 0.3% | 10.631 | 14.361 | 31.435 | 15.810 | 21.243 |
| hex: canterbury/cp.html | 49208 | 15661.5 ± 0.1% | 1474.5 ± 0.5% | 1099.6 ± 0.2% | 524.5 ± 1.6% | 1002.9 ± 0.6% | 743.5 ± 0.1% | 10.622 | 14.243 | 29.861 | 15.616 | 21.066 |
| hex: canterbury/fields.c | 22302 | 15518.2 ± 0.1% | 1420.5 ± 1.2% | 1067.5 ± 1.2% | 614.3 ± 4.6% | 986.7 ± 0.2% | 736.9 ± 0.1% | 10.924 | 14.537 | 25.260 | 15.727 | 21.058 |
| hex: canterbury/grammar.lsp | 7444 | 15157.7 ± 0.1% | 1508.8 ± 0.2% | 1097.2 ± 0.5% | 665.5 ± 5.7% | 997.4 ± 0.4% | 726.1 ± 0.1% | 10.046 | 13.815 | 22.777 | 15.198 | 20.875 |
| hex: canterbury/kennedy.xls | 524290 | 15526.4 ± 0.8% | 1473.0 ± 0.5% | 1087.0 ± 0.5% | 652.0 ± 1.2% | 991.5 ± 0.4% | 734.9 ± 0.3% | 10.541 | 14.284 | 23.814 | 15.660 | 21.127 |
| hex: canterbury/lcet10.txt | 524290 | 15595.0 ± 0.1% | 1464.9 ± 0.3% | 1086.9 ± 0.3% | 500.2 ± 1.5% | 988.8 ± 0.3% | 733.7 ± 0.4% | 10.646 | 14.349 | 31.181 | 15.771 | 21.256 |
| hex: canterbury/plrabn12.txt | 524290 | 15647.6 ± 0.3% | 1465.3 ± 0.3% | 1083.0 ± 0.3% | 491.1 ± 1.0% | 990.1 ± 0.1% | 732.6 ± 0.3% | 10.679 | 14.449 | 31.859 | 15.803 | 21.359 |
| hex: canterbury/ptt5 | 524290 | 15647.6 ± 0.2% | 1477.9 ± 0.2% | 1090.6 ± 0.5% | 553.2 ± 0.5% | 993.6 ± 1.0% | 733.6 ± 0.2% | 10.588 | 14.347 | 28.287 | 15.749 | 21.329 |
| hex: canterbury/sum | 76482 | 15676.0 ± 0.0% | 1495.2 ± 0.2% | 1103.6 ± 0.1% | 598.0 ± 2.2% | 998.2 ± 0.0% | 744.1 ± 0.2% | 10.484 | 14.204 | 26.213 | 15.705 | 21.067 |
| hex: canterbury/xargs.1 | 8456 | 15196.4 ± 0.0% | 1493.7 ± 0.4% | 1097.3 ± 0.6% | 662.2 ± 5.1% | 996.5 ± 0.6% | 727.4 ± 0.7% | 10.174 | 13.849 | 22.949 | 15.249 | 20.891 |
| hex: canterbury-large/E.coli | 524290 | 15573.4 ± 0.5% | 1470.1 ± 0.2% | 1087.1 ± 0.5% | 672.8 ± 0.1% | 994.4 ± 0.3% | 734.4 ± 0.2% | 10.594 | 14.326 | 23.147 | 15.661 | 21.205 |
| hex: canterbury-large/bible.txt | 524290 | 15625.2 ± 0.4% | 1460.9 ± 0.3% | 1083.1 ± 0.3% | 514.5 ± 1.0% | 989.1 ± 0.5% | 734.3 ± 0.1% | 10.696 | 14.427 | 30.369 | 15.797 | 21.280 |
| hex: canterbury-large/world192.txt | 524290 | 15579.1 ± 0.7% | 1463.5 ± 0.3% | 1082.4 ± 0.4% | 502.1 ± 0.6% | 991.4 ± 0.5% | 734.6 ± 0.3% | 10.645 | 14.394 | 31.030 | 15.715 | 21.207 |
| hex: http/html-1kx1024 | 2099200 | 14108.4 ± 0.4% | 1454.9 ± 0.6% | 1063.0 ± 0.4% | 501.1 ± 0.3% | 982.5 ± 0.6% | 692.0 ± 0.1% | 9.697 | 13.272 | 28.155 | 14.359 | 20.389 |
| hex: http/html-16kx64 | 2097280 | 15254.9 ± 0.4% | 1452.4 ± 0.3% | 1075.3 ± 0.2% | 507.6 ± 0.3% | 999.6 ± 0.3% | 734.2 ± 0.1% | 10.503 | 14.187 | 30.053 | 15.261 | 20.777 |
| hex: http/html-1m | 524290 | 15688.4 ± 0.2% | 1468.7 ± 0.2% | 1083.6 ± 0.4% | 500.5 ± 2.0% | 990.3 ± 0.2% | 733.9 ± 0.5% | 10.682 | 14.478 | 31.343 | 15.843 | 21.378 |
| hex: http/json-1kx1024 | 2099200 | 14087.9 ± 1.1% | 1465.5 ± 0.2% | 1068.6 ± 0.3% | 607.3 ± 0.3% | 988.1 ± 0.2% | 691.9 ± 0.1% | 9.613 | 13.184 | 23.197 | 14.257 | 20.362 |
| hex: http/json-16kx64 | 2097280 | 15236.4 ± 0.5% | 1443.5 ± 0.1% | 1074.7 ± 0.3% | 616.0 ± 0.3% | 993.3 ± 0.3% | 734.3 ± 0.4% | 10.555 | 14.178 | 24.736 | 15.339 | 20.750 |
| hex: http/json-1m | 524290 | 15681.6 ± 0.3% | 1474.2 ± 0.5% | 1087.7 ± 0.2% | 634.1 ± 0.8% | 994.3 ± 0.6% | 734.0 ± 0.5% | 10.637 | 14.418 | 24.731 | 15.772 | 21.364 |
| hex: http/js-1kx1024 | 2099200 | 14094.5 ± 0.3% | 1454.5 ± 0.3% | 1064.6 ± 0.3% | 499.4 ± 0.2% | 983.4 ± 0.1% | 692.3 ± 0.2% | 9.690 | 13.240 | 28.224 | 14.333 | 20.360 |
| hex: http/js-16kx64 | 2097280 | 15270.2 ± 0.6% | 1442.8 ± 0.2% | 1073.2 ± 0.3% | 505.8 ± 0.3% | 997.4 ± 0.5% | 734.6 ± 0.2% | 10.584 | 14.229 | 30.190 | 15.310 | 20.787 |
| hex: http/js-1m | 524290 | 15684.5 ± 0.5% | 1460.2 ± 0.2% | 1081.6 ± 0.4% | 511.5 ± 0.6% | 985.7 ± 0.7% | 732.8 ± 0.6% | 10.741 | 14.501 | 30.661 | 15.912 | 21.404 |
| hex: http/css-1kx1024 | 2099200 | 14102.7 ± 0.4% | 1455.6 ± 0.2% | 1063.6 ± 0.2% | 531.4 ± 0.3% | 983.5 ± 0.2% | 692.3 ± 0.3% | 9.688 | 13.259 | 26.539 | 14.339 | 20.370 |
| hex: http/css-16kx64 | 2097280 | 15312.4 ± 0.4% | 1441.1 ± 0.1% | 1074.3 ± 0.3% | 541.4 ± 0.6% | 998.3 ± 0.5% | 734.7 ± 0.5% | 10.625 | 14.254 | 28.283 | 15.339 | 20.842 |
| hex: http/css-1m | 524290 | 15678.9 ± 0.3% | 1467.3 ± 0.4% | 1085.2 ± 0.2% | 525.7 ± 0.6% | 990.3 ± 0.5% | 733.1 ± 0.5% | 10.686 | 14.448 | 29.824 | 15.832 | 21.386 |
| hex: shuffled/dickens-1m | 524290 | 15635.1 ± 0.2% | 1465.8 ± 0.3% | 1083.4 ± 0.3% | 503.7 ± 0.8% | 988.2 ± 0.7% | 733.2 ± 0.7% | 10.667 | 14.432 | 31.042 | 15.821 | 21.324 |

## Losses to the baselines

Each workload where a baseline ran faster than stdx by more than the noise floor of decision 20.

- CLDR supplemental, 34 texts, decoding through TextReader.next: stdx runs at 0.916 of yyjson.
